---
title: "RAG Está Morto? Contexto Longo, Grep e o Fim do Vector DB Obrigatório"
date: '2026-04-06T18:00:00-03:00'
draft: false
tags:
  - llm
  - rag
  - vibecoding
  - ai
description: "Os modelos frontier passaram dos 200k pra 1M tokens de contexto. Será que ainda faz sentido montar uma stack inteira com vector DB pra fazer RAG, quando dá pra usar grep e jogar o documento inteiro na janela?"
---

Já tem um tempo que essa coceira não me larga. No começo da onda de LLMs, lá em 2022/2023, a gente tinha 4k de contexto no GPT 3.5, 8k se esticasse, 32k era luxo. Pra fazer qualquer coisa com documento real, você não tinha escolha: tinha que recortar o texto em pedaços, gerar embeddings, jogar num vector database, fazer similarity search, pegar os top-5 chunks e rezar pra que os pedaços certos aparecessem.

Daí virou indústria. Pinecone, Weaviate, Qdrant, Chroma, Milvus, pgvector, LangChain, LlamaIndex, Haystack. Tutorial em todo canto, "construa seu chatbot com seus PDFs", consultorias inteiras vivendo disso. Virou meio que o "hello world" de LLM aplicado: documento → chunk → embed → vector DB → query.

Hoje, em abril de 2026, o Claude Opus 4.6 tem **1 milhão** de tokens de contexto. O Sonnet 4.6, idem. O Gemini 3.1 Pro também. O GPT 5.4 vai pra 400k. E olha que isso é só na janela "padrão", alguns modelos têm modos de 2M tokens experimentais. A questão que eu venho me fazendo é: pra que cargas d'água eu preciso de uma stack vector pra resolver problema que cabe na janela do modelo?

E mais: vector database tem problemas reais que ninguém gosta muito de falar. Falsos vizinhos. Chunking arbitrário que parte definição do uso. Embeddings que envelhecem mal. Sem dizer que quando o resultado vem errado, você não tem a menor ideia do porquê.

A tese que eu venho amadurecendo é simples: **na maioria dos casos, um `grep` bem feito + uma janela de contexto generosa do modelo bate uma stack RAG completa**. Mais barato, mais rápido de manter, mais fácil de debugar, e na prática funciona melhor. Bora destrinchar.

## Onde a história começou a virar

Quando o teto era 32k de contexto, retrieval era o gargalo do problema inteiro. Você tinha que pré-filtrar agressivo, porque qualquer coisa que entrasse na janela era espaço sagrado. Vector DB foi a única forma decente de fazer essa pré-filtragem semântica. A lógica era: "o leitor (LLM) é caro e burro, então o retriever tem que ser inteligente e seletivo".

Hoje, a equação inverteu. O leitor virou o cara mais inteligente da mesa. E a janela cresceu absurdo. Aí o retriever pode (e talvez deva) voltar pra ser burro mesmo. Quanto mais burro, melhor: você quer um retriever de **alta cobertura, baixa precisão**, e deixa o modelo fazer a parte fina. Grep faz exatamente isso. BM25 idem. Ripgrep faz isso a uma velocidade absurda em milhões de linhas.

E não é só achismo meu. Os benchmarks BEIR mostraram, faz tempo, que BM25 bate ou empata com vários retrievers densos quando o domínio é fora do que treinou os embeddings. A própria Anthropic publicou um post no [Contextual Retrieval](https://www.anthropic.com/news/contextual-retrieval) basicamente dizendo a mesma coisa: sinais lexicais + julgamento do LLM batem embedding puro pra maior parte das tarefas de conhecimento. E o Claude Code, a ferramenta que eu uso todo dia há 500 horas, navega o repositório com `Glob` e `Grep`. Sem vector DB. Sem embedding. Sem LangChain. Funciona ridiculamente bem.

## Os problemas reais do vector database que ninguém anuncia

A propaganda de vector DB vende o sonho da busca semântica perfeita. A realidade é mais bagunçada.

**Falsos vizinhos.** Cosine similarity premia similaridade tópica, não relevância. Você pergunta "como tratamos erro de autenticação" e o DB devolve todo chunk que mencione autenticação. O chunk que efetivamente responde a pergunta pode estar em décimo lugar, ou nem ter sido pego porque o redator usou "login" em vez de "auth".

**Chunking é um desastre disfarçado.** Janela de 512 tokens, overlap de 64. Parece razoável até você perceber que sua tabela importante foi cortada no meio, que a definição de uma função ficou separada do uso dela, e que o pedaço da documentação que tinha o comando exato ficou orfão sem o contexto da seção. A fronteira do chunk é, com frequência, exatamente onde a resposta morava.

**Quando falha, falha sem deixar pista.** Quando o BM25 não acha, você sabe porquê: a palavra não tá lá. Quando o vector DB devolve lixo, você recebe um chunk plausível e errado, sem nenhum sinal diagnóstico. Boa sorte debugando isso em produção.

**Índice envelhece.** Cada update do documento pede re-embedding. Se você tem 10 mil docs e uns 200 mudam por dia, isso é processo de batch, monitoramento, fila, retry, custo de API de embedding, e a janela de inconsistência onde o índice tá desatualizado. Grep não tem nada disso. O arquivo mudou? A próxima query já pega.

**Custo escondido de operação.** Pinecone tem preço por vector. Weaviate tem cluster pra manter. pgvector evita servidor novo, mas você ainda mantém schema, índice, processo de re-embedding. Cada uma dessas coisas pede engenheiro, monitoramento, teste, deploy. Tudo isso pra fazer uma busca que muitas vezes o `rg` resolveria em 200ms.

## Comparando a complexidade

Olha o desenho:

![Complexidade: RAG clássico vs grep + contexto longo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/06/rag/rag-vs-grep-complexity.png)

De um lado, oito etapas, quatro ou cinco serviços, índice externo que precisa ser mantido e atualizado. Do outro, quatro etapas, zero infraestrutura nova. Não é caricatura: é literalmente o que você precisa montar pra cada caso.

A pergunta honesta é: a coluna da esquerda compensa? Em 2023, sim, porque a coluna da direita não existia (não tinha LLM com janela de 200k). Em 2026, na maior parte dos casos, não.

## Prós e contras de cada lado

### RAG clássico (vector DB)

**A favor:**
- Funciona pra corpora gigantes, da ordem de centenas de GB, onde nem `rg` resolve sem indexação prévia
- Acerta consultas paráfrase pesada e cross-lingual ("como cancelo" vs "encerramento de assinatura"), onde o vocabulário do usuário não bate com o do documento
- Funciona pra modalidades não-textuais (imagem, áudio) onde grep não tem o que olhar
- Economiza tokens de input se você é constrangido por orçamento ou latência absoluta

**Contra:**
- Stack complexa: embedding, vector DB, chunking, reranker, pipeline de re-indexação
- Falhas opacas, difíceis de debugar
- Chunking destrói contexto de tabelas, código, definições longas
- Overhead operacional (índice, fila, monitoramento, custo de re-embedding)
- A busca semântica vendida no marketing raramente funciona como anunciam

### Grep + contexto longo

**A favor:**
- Praticamente zero infraestrutura nova: ripgrep, sqlite, ou um simples `LIKE` em Postgres
- Sempre fresco: o arquivo mudou, a próxima query já vê
- Falhas transparentes: a palavra está ou não está
- Carrega o documento em pedaços generosos, o modelo faz a filtragem fina com semântica de verdade
- Mais barato em dev e ops, mais barato pra pivotar de domínio

**Contra:**
- Não escala pra terabytes de texto bruto sem alguma indexação
- Sofre quando o usuário usa vocabulário muito diferente do documento
- Não funciona pra modalidade não-textual
- Latência por query é maior em termos absolutos (carregar 100k tokens sempre custa mais que carregar 5k)
- Custo de input por query é mais alto se você não tem prompt caching

## Mas e o custo? O elefante na sala

Esse é o argumento que mais me jogavam na cara quando eu defendia a tese do "carrega tudo no contexto". "Vai ficar caríssimo, vai gastar 200k tokens de input por query, isso é absurdo". Vamos fazer a conta de verdade.

No [meu artigo do benchmark de LLMs de ontem](/2026/04/05/testando-llms-open-source-e-comerciais-quem-consegue-bater-o-claude-opus/) eu mapeei o preço por token de cada modelo. Pega o Claude Sonnet 4.6: $3 por milhão de tokens de input, $15 por milhão de output. Pega o GLM 5 (que provei que funciona): $0.60 input, $2.20 output. Pega o GPT 5.4 Pro lá em cima: $15 input, $180 output (esse aí machuca, eu sei).

Imagina uma query que joga 200k tokens de input e produz 2k tokens de output:

| Modelo | Input ($) | Output ($) | Total por query |
|---|---:|---:|---:|
| Claude Sonnet 4.6 | $0.60 | $0.03 | **$0.63** |
| Claude Opus 4.6 | $3.00 | $0.15 | **$3.15** |
| GLM 5 | $0.12 | $0.0044 | **$0.12** |
| Gemini 3.1 Pro | $0.40 | $0.024 | **$0.42** |
| GPT 5.4 Pro | $3.00 | $0.36 | **$3.36** |

Agora bota prompt caching. Claude tem cache que faz o input cacheado custar uns 10% do preço cheio. Gemini tem cache implícito (e a partir de 2025 é cobrado também, mas com desconto). Aplicado, uma query repetida sobre o mesmo dump de 200k cai pra centavos. No limite, com Sonnet, é uns $0.10 por query subsequente.

Compara isso com o custo de manter um Pinecone. Plano "Standard" começa em $50/mês mais consumo. Você precisa de engenheiro pra montar a pipeline, manter, monitorar, lidar com falhas, refazer chunking quando o domínio muda. Conservadoramente, são 40-80 horas de engenharia pra deixar a coisa estável. A R$ 200/hora, isso é R$ 8.000 a R$ 16.000. Em USD, $1.600 a $3.200 só pra montar.

Com $3.200, no Sonnet 4.6 com prompt caching, você roda umas **30 mil queries** de 200k tokens. Trinta mil queries é, dependendo da escala do projeto, vários meses ou até um ano de uso de uma ferramenta interna média. E você não pagou um engenheiro pra montar. E não tem servidor de vector DB pra manter. E se o documento mudar, o sistema já vê.

A conta do "RAG é mais barato em tokens" ignora que **token é a coisa mais barata da equação inteira**. Engenheiro é caro. Servidor é caro. Bug em produção é muito caro. Token é commodity, e tá ficando mais barato a cada release de modelo novo.

O argumento clássico do RAG era: "modelo é caro, retrieval é barato". Hoje é o oposto: **modelo é a coisa mais barata da pilha, retrieval inteligente é o que custa caro pra montar e manter**.

## Os pontos onde a tese não cola

Não quero parecer fanboy. Tem casos onde RAG clássico ainda ganha:

1. **Corpora gigantescos.** Se você tem 500 GB de texto bruto, nem `rg` resolve em tempo aceitável. Aí precisa de algum tipo de indexação. Pode ser BM25 indexado (Tantivy, Elasticsearch), pode ser vector DB. Mas observa: a primeira opção ainda é lexical, não vetorial.
2. **Vocabulário muito disperso.** Suporte ao cliente, onde o usuário fala "tô sem net" e a documentação fala "perda de conectividade na camada física". BM25 não pega isso. Embedding pega. Aí vector DB ganha o ponto.
3. **Modalidade não-textual.** Busca de imagem por imagem, áudio por áudio. Embedding é obrigatório.
4. **Latência absoluta crítica.** Se você precisa responder em 100ms e tem 5k de orçamento de input, dump generoso não cabe. Aí pré-filtragem é necessária.
5. **Compliance e auditoria.** Se você precisa provar que tal documento foi consultado pra responder tal query, ter chunks indexados rastreáveis ajuda. Dump de 200k de contexto é mais opaco em auditoria.

Pra esses casos, RAG clássico continua fazendo sentido. Mas observa o tamanho da lista. São casos específicos. O caso geral, tipo "chat com nossos documentos internos" ou "pergunte ao manual do produto", quase todo cai no balde do "grep + contexto longo resolve melhor".

## Lazy retrieval: a receita que eu defendo

Se eu fosse construir uma ferramenta de "chat com docs" hoje, do zero, seria mais ou menos assim:

1. **Mantém os documentos brutos.** Markdown, PDF convertido, código, o que for. No disco mesmo, organizado em pastas que façam sentido pro domínio.
2. **Filtro lexical rápido.** `ripgrep` com regex, ou BM25 com Tantivy/SQLite FTS5, ou um `LIKE` no Postgres se já tiver. Devolve uns 100-300 hits.
3. **Carrega generosamente.** Pega não só o trecho que bateu, mas o arquivo inteiro, ou uma janela grande em volta. Joga tudo no contexto.
4. **Deixa o LLM fazer a parte fina.** Passa a pergunta original, manda o modelo encontrar o que importa, descartar o resto, e responder com citações.
5. **(Opcional) Adiciona embeddings só pra classes de query onde lexical falha**, depois de você ter dados reais mostrando que falha.

Isso é o oposto do conselho antigo ("comece com vetores, fallback pra keyword"). É: **comece com keyword, e adicione vetor só se sentir falta**. Na maioria dos projetos, você nunca vai sentir.

## Uma implementação de brinquedo em Ruby

Pra deixar concreto. Eis um script Ruby usando o gem [`ruby_llm`](https://github.com/crmne/ruby_llm) (o mesmo do benchmark de ontem) que faz exatamente esse fluxo: grep nos arquivos, carrega os trechos com contexto, manda pro Claude, recebe a resposta. Sem vector DB, sem chunking, sem embedding, sem LangChain.

```ruby
#!/usr/bin/env ruby
require "ruby_llm"
require "open3"

DOCS_DIR = ARGV[0] || "./docs"
QUERY    = ARGV[1] or abort "uso: ./ask.rb <pasta> <pergunta>"

# 1. Filtro lexical rápido com ripgrep.
#    -i case insensitive, -l só nomes de arquivo, --type-add cobre md/txt/pdf-extraído.
def lexical_search(dir, query)
  terms = query.downcase.scan(/\w{4,}/).uniq.first(8)  # palavras com 4+ letras
  pattern = terms.join("|")
  cmd = ["rg", "-l", "-i", "-e", pattern, dir]
  files, _ = Open3.capture2(*cmd)
  files.split("\n").reject(&:empty?)
end

# 2. Carrega os arquivos inteiros (até um teto razoável).
def load_context(files, max_chars: 600_000)
  total = 0
  files.map do |path|
    body = File.read(path)
    next if total + body.size > max_chars
    total += body.size
    "## #{path}\n\n#{body}\n"
  end.compact.join("\n---\n")
end

# 3. Manda pro Claude com a pergunta e os documentos.
def ask(query, context)
  chat = RubyLLM.chat(model: "anthropic/claude-sonnet-4")
  prompt = <<~PROMPT
    Você tem acesso aos documentos abaixo. Responda a pergunta do usuário
    usando apenas o que está nos documentos. Cite o nome do arquivo nas
    referências. Se a resposta não estiver nos documentos, diga isso.

    --- DOCUMENTOS ---
    #{context}
    --- FIM DOS DOCUMENTOS ---

    Pergunta: #{query}
  PROMPT
  chat.ask(prompt).content
end

files = lexical_search(DOCS_DIR, QUERY)
abort "nenhum arquivo bateu" if files.empty?
puts "Encontrei #{files.size} arquivos. Carregando contexto..."
context = load_context(files)
puts ask(QUERY, context)
```

São umas 40 linhas. Sem dependência de Pinecone, sem schema de vector, sem pipeline de re-indexação. Você roda como `./ask.rb ./docs "como configurar o webhook do pagamento"` e pronto.

A mesma ideia funciona pra banco de dados: troca o `rg` por uma query SQL com `LIKE` ou `tsvector` (full-text do Postgres), carrega as linhas relevantes, joga no contexto. Se você tiver 10k registros num banco interno, isso resolve. Se tiver 10 milhões, aí você começa a precisar de paginação inteligente ou de uma camada de pré-filtragem mais séria. Mas a estrutura mental é a mesma: **filtro burro + leitor inteligente**.

## O ponto que importa

A coisa interessante não é nem a economia de Pinecone. É que **a natureza do gargalo mudou**. Em 2023, o gargalo era retrieval: o leitor (LLM) era pequeno, lento e caro, então você precisava de um retriever esperto pra encher a janela com o mínimo possível. Em 2026, o gargalo é raciocínio sobre contexto bagunçado: o leitor é grande, rápido (relativamente) e barato, então você quer **um retriever burrão de alta cobertura** e deixar o modelo fazer o trabalho pesado.

Quem ainda projeta sistemas com a mentalidade de 2023 tá pagando caro pra resolver um problema que mudou de forma. RAG não morreu, o "R" ficou mais barato e mais burro, e isso é uma melhoria. Quem vende vector DB não vai te contar isso, mas é o caminho que a galera mais experiente já tá seguindo, mesmo que sem fanfarra.

A próxima onda de aplicações de LLM, na minha aposta, vai ser dominada por gente que entendeu essa inversão. Stacks mais simples, infraestrutura menor, modelos maiores, contexto generoso. E muito menos LangChain.

## O que a literatura recente diz

Antes de fechar, vale dizer que essa discussão já tem corpo acadêmico e os achados não são uniformes. Eu fiz questão de conferir o que a galera de pesquisa publicou, porque "achismo de blog" nessa área envelhece rápido.

O paper [**Retrieval Augmented Generation or Long-Context LLMs? A Comprehensive Study and Hybrid Approach**](https://arxiv.org/abs/2407.16833) (Google DeepMind, EMNLP 2024) é provavelmente o mais citado nesse debate. A conclusão deles: quando o modelo tem recurso suficiente, **long context bate RAG na média**, mas RAG continua sendo bem mais barato. Eles propõem uma abordagem chamada Self-Route, onde o próprio modelo decide se precisa de RAG ou se manda direto pelo contexto. A economia de tokens é grande, e a perda de qualidade é pequena.

Já o [**LaRA: Benchmarking Retrieval-Augmented Generation and Long-Context LLMs**](https://openreview.net/forum?id=CLF25dahgA) (ICML 2025) é mais comedido. Eles montaram 2326 casos de teste em quatro tipos de tarefa de QA e três tipos de contexto longo, rodaram em 11 LLMs diferentes, e a conclusão foi: **não tem bala de prata**. A escolha entre RAG e long context depende do modelo, do tamanho do contexto, do tipo de tarefa, e da característica do retrieval. RAG ganha em diálogo e queries genéricas, long context ganha em QA de Wikipedia.

O paper [**Long Context vs. RAG for LLMs: An Evaluation and Revisits**](https://arxiv.org/abs/2501.01880) (janeiro 2025) é o que mais reforça a tese deste post. Long context geralmente bate RAG em benchmarks de QA, especialmente quando o documento base é estável. Retrieval baseado em sumarização chega perto, retrieval baseado em chunk fica atrás. Em outras palavras: o jeito antigo (chunk + embed + top-k) é o que sai pior.

Vale também ter no radar o original [**Lost in the Middle**](https://arxiv.org/abs/2307.03172) (Liu et al., 2023, publicado no TACL em 2024). Esse é o paper que mostrou que mesmo modelos com janela grande têm performance dependente da posição da informação relevante. Coisa no começo ou no fim do contexto é encontrada com facilidade, coisa no meio degrada. Foi citado como argumento contra long context por muito tempo, mas vale lembrar que o paper é de 2023, com modelos da época. Os modelos de hoje (Claude 4.x, Gemini 3.x) já lidam muito melhor com a parte do meio. Não é problema resolvido, mas é problema bem menor que era.

Pelo lado do retrieval lexical, o [**BEIR: A Heterogenous Benchmark for Zero-shot Evaluation of Information Retrieval Models**](https://arxiv.org/abs/2104.08663) continua sendo a referência canônica. O resultado clássico é que BM25, mesmo sendo de 1994, é competitivíssimo em cenários out-of-domain. Os modelos densos só ganham consistentemente quando você tem dados do domínio pra fine-tunar os embeddings. Em cenário zero-shot (que é onde a maioria dos projetos vive), BM25 é difícil de bater sem trabalho pesado.

E pra fechar, o post da [**Anthropic sobre Contextual Retrieval**](https://www.anthropic.com/news/contextual-retrieval) (setembro de 2024) é a peça mais prática. Eles mostram que combinando embedding contextualizado + BM25 contextualizado, dá pra cair de 5.7% pra 2.9% de taxa de falha no top-20. Adicionando reranker, cai pra 1.9%. O ponto interessante é que **BM25 é peça central do resultado**. Não é "vetor venceu", é "lexical + vetor + reranker é a combinação que funciona". Se você só tem que escolher um, BM25 sozinho ainda te leva longe.

Em resumo: a literatura não está cravando "RAG morreu". Mas tá cravando que (1) long context, quando dá pra usar, costuma vencer na qualidade, (2) o custo de RAG ainda é o argumento principal a favor dele, (3) BM25 lexical é mais forte do que a propaganda de vector DB faz parecer, e (4) o caminho mais robusto, quando você precisa de retrieval, é hybrid (lexical + vetor + reranker), não vetor puro. Tudo isso bate com o que eu venho defendendo na prática.

## Fontes

- Li, Z. et al. (2024). [Retrieval Augmented Generation or Long-Context LLMs? A Comprehensive Study and Hybrid Approach](https://arxiv.org/abs/2407.16833). EMNLP 2024 Industry Track.
- Yuan, K. et al. (2025). [LaRA: Benchmarking Retrieval-Augmented Generation and Long-Context LLMs – No Silver Bullet for LC or RAG Routing](https://openreview.net/forum?id=CLF25dahgA). ICML 2025.
- Yu, T. et al. (2025). [Long Context vs. RAG for LLMs: An Evaluation and Revisits](https://arxiv.org/abs/2501.01880). arXiv:2501.01880.
- Liu, N. F. et al. (2023). [Lost in the Middle: How Language Models Use Long Contexts](https://arxiv.org/abs/2307.03172). TACL 2024.
- Thakur, N. et al. (2021). [BEIR: A Heterogenous Benchmark for Zero-shot Evaluation of Information Retrieval Models](https://arxiv.org/abs/2104.08663). NeurIPS Datasets and Benchmarks 2021.
- Anthropic (2024). [Introducing Contextual Retrieval](https://www.anthropic.com/news/contextual-retrieval). Blog técnico.
