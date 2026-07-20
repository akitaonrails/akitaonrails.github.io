---
title: "LLM Benchmark: Devo usar o que tem nota maior?"
slug: "llm-benchmark-devo-usar-o-que-tem-nota-maior"
date: '2026-07-19T12:00:00-03:00'
draft: false
translationKey: llm-benchmark-devo-usar-o-que-tem-nota-maior
description: "Por que o primeiro lugar num ranking de LLMs não é necessariamente o melhor modelo, por que 90+ é um cluster e como usar benchmarks sem terceirizar sua decisão técnica."
tags:
- benchmarks-de-llm
- llms
---

Toda vez que publico uma rodada do meu benchmark, alguém abre a tabela, olha as primeiras linhas e pergunta:

> "Por que o Opus 4.7 está acima do Opus 4.8 e do Fable 5?"

Ou então:

> "Quer dizer que GPT 5.4 é melhor que GPT 5.5 e 5.6?"

Não. Quer dizer que a tabela foi ordenada por uma coluna chamada `score`. Só isso.

Ranking precisa de uma ordem pra ser legível. O erro é transformar essa ordem de apresentação num campeonato mundial de inteligência. O primeiro colocado não ganhou de todos os outros em tudo. Ele gerou o artefato que recebeu a maior nota **nesse teste, nessa rodada, nesse harness, com esse prompt e segundo essa rubrica**.

Esse artigo é pra explicar como eu mesmo leio o [meu benchmark aberto](https://github.com/akitaonrails/llm-coding-benchmark), por que considero tudo acima de 90 mais ou menos o mesmo cluster, e por que ninguém deveria terceirizar a escolha de modelo pra uma tabela. Nem pra minha.

## A nota é do projeto, não do modelo inteiro

O benchmark nasceu no artigo [Testando LLMs Open Source e Comerciais](/2026/04/05/testando-llms-open-source-e-comerciais-quem-consegue-bater-o-claude-opus/) e ganhou a metodologia atual na [Parte 3, que virou a referência canônica](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/).

Todos recebem o mesmo trabalho: construir autonomamente um app pequeno de chat em Rails 8, usando RubyLLM, Hotwire, Tailwind, testes, ferramentas de CI, Dockerfile, Compose e documentação. Depois eu avalio o resultado em oito dimensões: completude, correção da API do RubyLLM, qualidade dos testes, tratamento de erros, persistência, Hotwire, arquitetura e prontidão pra produção.

Repara no sujeito da frase: eu avalio **o resultado**.

O modelo não entra numa máquina de ressonância magnética que descobre quanto de "inteligência" tem lá dentro. Ele recebe um prompt, usa ferramentas, escreve um projeto e para. A nota é uma avaliação daquele projeto. Pra classificar toda a capacidade de um LLM, teríamos que testar todos os problemas possíveis, em todas as linguagens, com qualquer prompt, contexto, ferramenta e combinação de requisitos. Boa sorte.

O que realmente aparece na tabela é algo mais parecido com isto:

```text
resultado = modelo + prompt + harness + contexto + tools + snapshot + execução + auditoria
```

A gente ordena por score porque uma tabela sem ordem é ruim de consultar. A ordenação não transforma uma amostra em lei da natureza.

## LLM não faz a mesma prova duas vezes

LLMs não são determinísticas. Mesmo prompt não garante os mesmos tokens, as mesmas decisões de arquitetura ou a mesma sequência de tool calls. Em coding agent, ainda entram outputs do terminal, tempo de resposta, contexto acumulado, compaction e o comportamento do harness. Se o provedor atualiza um alias entre uma segunda-feira e outra, mudou mais uma variável sem você tocar em nada.

Eu já tinha tropeçado nisso na [Parte 2 do benchmark](/2026/04/18/llm-benchmarks-parte-2-multiplos-modelos/). O ranking daquele artigo ficou obsoleto quando corrigi a auditoria do RubyLLM, mas o experimento de variância continua válido: o mesmo Opus 4.7, com o mesmo prompt, produziu resultados espalhados entre Tier 1 e Tier 3 em harnesses diferentes. Naquela época eu escrevi que benchmark de uma ou três rodadas não bastava pra afirmar qualidade absoluta. Continua não bastando.

Tem um exemplo mais recente e limpo. O Fable 5 foi rodado de novo depois do re-release usando o mesmo model ID no OpenRouter. A primeira execução fez **94 pontos em 24 minutos**. A segunda fez **93 em 18 minutos**. Projetos diferentes, defeitos diferentes, custo diferente. Um ponto de score é ruído até dentro do "mesmo" modelo.

O harness também pode mudar tudo. O DeepSeek V4 Pro ficou em 69 com DNF no OpenCode e chegou a 89 via DeepClaude. Kimi K2.7 fez 86 via OpenCode/OpenRouter e cerca de 68 numa rodada informal pelo Kimi Code CLI. Há ressalvas de snapshot e endpoint nos dois casos, justamente porque nunca conseguimos isolar perfeitamente só o modelo. Benchmark de agente mede o pacote inteiro.

## Acima de 90, leia como um grupo

O topo atual ficou assim. Os números vêm do [relatório completo do benchmark](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.md):

| Modelo | Score | Tempo | Custo da rodada |
|---|---:|---:|---:|
| Claude Opus 4.7 | 97 | 18 min | ~$7,00 |
| GPT 5.4 xHigh | 95 | 22 min | ~$16 |
| Claude Opus 4.8 | 95 | 17 min | ~$6,40 |
| Claude Fable 5 | 94 | 24 min | ~$11,20 |
| Claude Fable 5 (re-release) | 93 | 18 min | ~$8,30 |
| Gemini 3.5 Flash | 93 | 18 min | ~$3,55 |
| GPT 5.6 Sol xHigh | 92 | 17 min | créditos (~$8,70 equivalente em API) |

Pra mim, tudo aí está no mesmo **ballpark**. Não existe amostragem suficiente pra dizer que 97 é 2,1% "mais inteligente" que 95, muito menos que será melhor numa migração de banco, num refactor de Rust ou numa investigação de race condition.

Há também efeito de teto. O app do benchmark é real e tem bastante detalhe chato, mas continua sendo um projeto Rails greenfield pequeno, com escopo fechado. Os melhores modelos já saturaram a tarefa. Daí a ordem do topo acaba sendo decidida por escolhas pontuais: um guard de API key, o lugar onde persistiu a conversa, um cap de cookie, um teste de erro que faltou, um Dockerfile de desenvolvimento em vez de produção.

Esses detalhes importam pro projeto. Só não provam uma hierarquia universal entre os modelos.

Já a distância entre **Tier A e Tier C** quer dizer bem mais. A rubrica define Tier A como algo que sobe como está ou exige um patch curto. Tier C tem core quebrado ou precisa de rework grande. Não sei dizer se um modelo de 97 é realmente melhor que um de 93 em qualquer tarefa futura. Sei dizer que um grupo que entrega RubyLLM correto, testes úteis e imagem de produção está em outra categoria do grupo que inventa API e testa o próprio mock errado.

Primeiro escolha o grupo. Depois discuta custo, velocidade, assinatura, harness e preferência de uso. Brigar pela posição exata dentro do cluster dos 90 é precisão inventada.

## Então por que Opus 4.7 fica acima do 4.8 e do Fable?

Porque o projeto gerado pelo Opus 4.7 encaixou melhor na rubrica. A integração RubyLLM estava correta, os doubles de teste imitavam as assinaturas reais, a persistência em session cookie era multi-worker safe e os caminhos de erro estavam cobertos. Na auditoria atual, não sobrou defeito concreto grande pra descontar.

O Opus 4.8 também escreveu um projeto excelente, fez validação real de Rails, Docker, Compose e chamada ao OpenRouter, e terminou um minuto mais rápido. Perdeu dois pontos porque o histórico no cookie não tinha cap e podia bater no limite de 4 KB, além de não fazer preflight explícito da API key.

O Fable 5 corrigiu justamente essas duas coisas. Em compensação, escolheu persistência num singleton dentro do processo. A conversa some num restart e não funciona direito com múltiplos workers. Essa decisão custou o ponto que o deixou abaixo do 4.8. O próprio cross-audit cego observou que trocar o store por `Rails.cache` provavelmente inverteria a ordem.

Isso responde por que a **nota do artefato** ficou 97, 95 e 94. Pra analisar uma codebase de 500 mil linhas, a tabela não responde nada.

Os dados de eficiência contam outra história:

| Modelo | Score | Tempo | Tokens somados nos logs | Tarifa de input/output |
|---|---:|---:|---:|---:|
| Opus 4.7 | 97 | 18m12s | 9,78M | $5 / $25 por milhão |
| Opus 4.8 | 95 | 16m48s | 8,28M | $5 / $25 por milhão |
| Fable 5 | 94 | 24m19s | 6,03M | $10 / $50 por milhão |

Essa soma inclui input, output, cache write e cache read de todos os eventos `step_finish` nas duas fases. Com a mesma tarifa do 4.7, o 4.8 usou 15% menos tokens faturáveis e acabou mais rápido. A própria Anthropic descreveu o [Opus 4.8 como uma melhoria modesta sobre o 4.7](https://www.anthropic.com/research/claude-opus-4-8), manteve o preço e destacou eficiência de tool calling. Meu run combina com essa história. Uma rodada ainda não prova a causa.

Fable custa o dobro por token e, nesse problema, não comprou um projeto melhor. Isso só diz que esse app pequeno não exigiu o tipo de capacidade extra que a Anthropic vende no Fable. Pode ser modelo demais pra prova.

Minha leitura pessoal é que o Opus chegou ao platô desse benchmark no 4.7. O 4.8 refinou eficiência e comportamento. Fable foi pra outra faixa de capacidade e preço, mas o teste não conseguiu extrair essa diferença. É uma hipótese a partir dos resultados, não conhecimento sobre o treinamento interno da Anthropic.

## E por que GPT 5.4 aparece acima do 5.5 e do 5.6?

De novo: decisões diferentes nos projetos gerados.

O GPT 5.4 fez preflight de API key, diferenciou erro de configuração de erro do provider, usou cache com TTL e cap de mensagens e separou form object do domínio. Perdeu pontos porque o Dockerfile era uma imagem de desenvolvimento rodando como root.

O GPT 5.5 acertou a integração e o multi-turn, mas repetiu o Dockerfile de desenvolvimento, não testou nenhum caminho de erro e deixou o cookie sem limite de bytes. Caiu pra 85 na reauditoria.

O GPT 5.6 Sol voltou a 92 com engenharia defensiva muito melhor, Docker multi-stage non-root e 99,2% de cobertura. Ficou sem system prompt e carregou o histórico num hidden field do cliente. A rubrica desconta isso porque a conversa se perde no reload e pode ser adulterada.

Agora olha eficiência:

| Modelo | Score | Tempo | Tokens totais | Custo da rodada |
|---|---:|---:|---:|---:|
| GPT 5.4 xHigh | 95 | 22 min | 7,64M | ~$16 |
| GPT 5.5 xHigh | 85 | 18 min | 4,90M | ~$10 |
| GPT 5.6 Sol xHigh | 92 | 17 min | 3,92M | créditos (~$8,70 equivalente em API) |

Do 5.4 pro 5.6, o run ficou uns 23% mais rápido e consumiu quase metade dos tokens. O mais curioso é que [GPT 5.4 custa $2,50/$15 por milhão](https://developers.openai.com/api/docs/models/gpt-5.4), enquanto [GPT 5.5](https://developers.openai.com/api/docs/models/gpt-5.5) e [GPT 5.6 Sol](https://developers.openai.com/api/docs/models/gpt-5.6-sol) custam $5/$30. Mesmo com tarifa unitária duas vezes maior, os runs posteriores custaram menos porque foram bem mais econômicos no uso de tokens. No caso do 5.6, o pagamento real veio de créditos da assinatura; $8,70 é só o equivalente calculado em tarifa de API.

Isso sustenta melhor minha sensação: o GPT 5.4 foi o salto que colocou a família no platô de qualidade deste teste. 5.5 e 5.6 parecem ter trabalhado bastante eficiência, gastando menos contexto e terminando mais rápido sem sair do mesmo ballpark geral de capacidade.

Mas eu não tenho como provar que a OpenAI treinou essas versões com esse objetivo. O dado mostra o comportamento dos três runs. Dizer que isso foi estratégia de produto já é chute meu.

## Até a auditoria tem bugs

Tem mais uma variável incômoda: eu.

O GPT 5.5 originalmente recebeu 96. Depois o cross-audit contra o 5.6 encontrou problemas que tinham passado batido. Fui reler o código, confirmei os defeitos e a nota caiu pra 85. Na mesma revisão, o 5.4 caiu de 97 pra 95 por causa do Dockerfile de desenvolvimento.

O modelo não mudou. O projeto não mudou. **A auditoria melhorou.**

Na primeira versão do benchmark, eu também marquei APIs válidas do RubyLLM como alucinação porque estava auditando de memória. Quando fui ler o source da gem, tive que refazer boa parte do ranking. Está tudo documentado nos posts antigos porque esconder erro seria pior que errar.

Mais um motivo pra não tratar score como constante física. Uma rubrica pega um monte de decisões qualitativas e espreme tudo num número. Pode ter ponto cego, peso ruim e interpretação errada. Um benchmark sério publica prompt, código gerado, logs, critérios e correções pra que outra pessoa consiga contestar.

Desconfie ainda mais quando alguém publica só o gráfico.

## Como usar um benchmark sem virar torcedor

Eu uso ranking pra três coisas:

1. **Descartar grupos claramente ruins.** Tier C e D falham em coisas fundamentais neste workload. Não vou gastar uma semana apostando neles pra Agile Vibe Coding autônomo.
2. **Encontrar o cluster de candidatos.** Acima de 90, considero todos fortes. Daí escolho por custo marginal da minha assinatura, velocidade, disponibilidade no harness e comportamento no trabalho diário.
3. **Ler os defeitos, não só a nota.** Se meu sistema não usa cookie nem Docker, algumas deduções deste benchmark são irrelevantes. Se eu preciso de multi-turn e deploy, passam a ser decisivas.

Se a decisão vale dinheiro ou risco de produção, rode o seu teste. Pegue o [repositório do benchmark](https://github.com/akitaonrails/llm-coding-benchmark), troque o prompt por um trabalho parecido com o seu, execute os modelos mais de uma vez e faça revisão cega. Meça tempo, custo e quanto trabalho humano faltou depois. Um time que mantém um monolito Java de quinze anos precisa de um benchmark diferente de alguém fazendo protótipo Rails greenfield.

Não existe benchmark perfeito. SWE-bench, Terminal-Bench, meu app Rails, arena de preferência humana: cada um testa uma parte e ignora o resto. Servem pra localizar grupos e eliminar opções ruins. Nenhum consegue cuspir "o melhor LLM" em termos absolutos porque esse objeto nem existe sem especificar a tarefa.

## Conclusão

Claude Opus 4.7 estar em primeiro não quer dizer que eu escolheria 4.7 no lugar do 4.8 pra todo trabalho. GPT 5.4 estar acima do 5.6 não quer dizer que voltou no tempo. Quer dizer que, numa rodada deste app Rails e desta rubrica, aqueles projetos somaram mais pontos.

Minha recomendação continua simples: leia o topo como **clusters**, não como pódio. O grupo 90+ está no mesmo ballpark. Tier A é claramente mais confiável que Tier C neste tipo de coding. Dentro do grupo bom, escolha pelo seu harness, sua assinatura, seu limite de tempo e o defeito que você aceita corrigir.

E não confie em benchmark. Não confie em influencer. Não confie em mim.

Se você realmente precisa saber qual é o melhor modelo pro seu caso, defina suas restrições, escreva sua metodologia, rode todos e traga dados. Opinião dos outros serve pra escolher o que testar primeiro. A decisão técnica continua sendo sua.
