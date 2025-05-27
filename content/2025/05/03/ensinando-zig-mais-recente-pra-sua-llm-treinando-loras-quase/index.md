---
title: Ensinando Zig mais recente pra sua LLM - Treinando LoRas (quase)
date: '2025-05-03T02:30:00-03:00'
slug: ensinando-zig-mais-recente-pra-sua-llm-treinando-loras-quase
tags:
- zig
- qwen3
- ollama
- vllm
- llm
draft: false
---



[Dois posts atrás](https://www.akitaonrails.com/2025/05/01/quando-llms-nao-funcionam-pra-programar-um-caso-de-uso-mais-real) eu demonstrei o Calcanhar de Aquiles das LLMs pra programação: eles não foram treinados com os dados mais recentes disponíveis. Então se perguntar sobre mudanças na versão da sua biblioteca, linguagem ou frameworks favoritos que saiu mês passado, ele não vai saber.

Nota: todos os códigos que vou mostrar mais abaixo estão disponíveis [neste repositório no meu GitHub](https://github.com/akitaonrails/qwen3-zig-lora-training). Fucem lá depois de ler até o fim.

Por exemplo, eu perguntei ao modelo Qwen3-8b (que saiu poucos dias atrás), qual versão de Zig ele sabe e a resposta foi: 0.11 ou 0.12:

![zig antigo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/39h50oguk03tci9reclcbiovolhm?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-02%2014-24-08.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-02%252014-24-08.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001349Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=39327c327597426f5ff0c679856f29d96d6e30a5007fbc92fdc95aa8e87fcb43)

Aliás, é assim como na foto que se chama uma API compatível com OpenAI de LLMs com curl. De qualquer forma, foi por isso que eu sofri tanto pra tentar fazer funcionar um programinha simples (nível "Hello World") ontem: ele não sabe que já estamos no [Zig 0.14](https://ziglang.org/download/0.14.0/release-notes.html). E foi de propósito, eu sabia que ele não ia ter essa informação.

_"E outros LLMs comerciais? Eles não são melhores que os open source?"_

Perguntei ao ChatGPT 4.1, Claude Sonnet 3.7, Gemini 2.5 Pro Experimental, Deepseek R1 Zero (tudo de uma vez, OpenRouter.ai permite chat multi-model):

![LLM cut off](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/z9wbo5yi49m4vd3zi3pjpxbo7zj7?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-02%2020-30-09.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-02%252020-30-09.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001351Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=2ddf269fd0195e0ba9cd8dc62fcf93d4606473fb50a0ba548ece3faaa861fb17)

Resumindo:

- ChatGPT 4.1 diz que ele só tem dados até Junho de 2024 e só conhece até Zig 0.11.
- Claude Sonnet diz que ele só tem dados até Abril de 2023 e só conhece até 0.10.
- Gemini 2.5 Pro Exp diz que só tem dados até começo de 2023 e só conhece até Zig 0.11 também
- Deepseek R1 (depois de deep thinking ...) respondeu curto e grosso que só tem dados até Outubro de 2023 e só conhece até Zig 0.11.

_"Por que eles não tem dados mais novos?"_

Vou responder isso demonstrando os motivos nas próximas seções.

_"Mas ele consegue puxar informações da internet, então não importa"_

Importa. Essas informações não estão NO modelo. Quando você pede pra pesquisar na Internet, o modelo não sabe fazer isso. Ele foi instruído (na fase de fine-tuning/alinhamento ou via prompts) pra pedir ao sistema de chat - o parser - que pegue essa requisição, navegue na web (pense um curl, playwright ou qualquer coisa assim), puxe o conteúdo do site, copia e cola só na sua sessão de chat (é como uma solução de RAG). Ele só tem aquela informação naquela sessão e outros chats não são influenciados por isso.

_"Mas como que quando ele responde, ele mostra os links de onde veio essa informação?"_

Ele - provavelmente - não tem isso dentro do modelo. O que eu imagino é mais simples. Eles tem catalogado e indexado todo o material de treinamento original (incluindo a URL das fontes) num banco de dados (pense Elastic, Postgres com full-text-search, ou um banco vetorial qualquer). Quando termina de responder no chat - o programa de chat e não o modelo -, pesquisa esse trecho nesse banco de dados por um trecho parecido o suficiente e dali pega as URLs das fontes pra te mostrar. 

Enfim.

Zig é experimental, pré-1.0. A sintaxe de tudo muda MUITO de uma versão pra outra, porque ainda estão experimentando o que é melhor. E ainda vai mudar mais. Ou seja: é impossível fazer "Vibe Coding" de Zig a menos que você fixe seu compilador pra versão 0.11 ou 0.12. Mas isso seria "tosco", pra dizer o mínimo. Eu escolhi tentar Zig de propósito, exatamente pra provar esse ponto.

Mesma coisa vale pra muita empresa com código privado. Penso empresas de ERP que tem linguagens próprias, bibliotecas próprias, e nada disso é público, então garantidamente não estava no treinamento de uma OpenAI e certamente é muito mais informação que cabe num contexto de prompt.

**"Ah, basta fazer um RAG"**

Solução enlatada sem entender. Não, não adianta. Ele vai dar prioridade ao treinamento que teve. Segundo, pra cada coisa que pedir, você precisaria saber que vai precisar de algo que mudou na 0.14, pesquisar o trecho da documentação e ficar adicionando no contexto do chat. Se for fazer isso método a método, pra que está usando o chat? Vai e escreve direto o código, vai ser mais rápido.

Jogar TODA a documentação no contexto não adianta. Eu fiz a conta: baixei a documentação inteira e release notes são 200 mil caracteres, aproximadamente uns 50 mil tokens. Maioria dos LLMs open source vai estourar a janela (média de 32 ml tokens). Via API/Chat comercial você iria pagar por token, à toa. Imagine querer refatorar um código seu, de 100 linhas e ter que subir 200 mil linhas de contexto. Nunca faça isso. O custo-benefício não compensa.

**"Ah, mas os Gemini da vida suporta 1 milhão de tokens"**

Sim, com sliding window, já repeti várias vezes. Ele não consegue dar atenção a tudo de uma só vez. De novo: você vai **PAGAR** por esses 50 mil tokens, tá? E não vai ser barato. Imagina, toda nova sessão ter que subir 50 mil tokens que não tem garantia de funcionar.

Então ph0deu? Não tem como usar Zig com LLMs?

### RAGs?

O hype de RAG (Retrieval Augmented Generation, que é só um nome bonitinho) faz parecer que é algo "mágico". Mas realmente, não tem nada demais. Ele é bom pra quando você tem um banco de dados grande, que cresce o tempo todo, mas em cada sessão de chat, você só precisa de um pouquinho dessa informação. Pense um suporte de e-commerce da vida, com tickets de suporte. Cresce todo dia, mas pra cada chamada você só precisa do ticket específico da pessoa que está atendendo, que é bem curto.

Do jeito mais rudimentar, o atendente pesquisa o ticket no tradicional Zendesk da vida, copia o texto, joga na janela de chat do ChatGPT e começa a fazer perguntas sobre esse ticket, tipo "pode me resumir qual o problema desse cliente?", "consegue imaginar uma solução pra ele?" e assim por diante.

Um RAG é um BANCO DE DADOS com todos esses tickets pré-indexados pra facilitar a procura por relevância, e depois inserir o trecho que achou direto na janela de contexto. Serve pra automatizar, PULAR os passos de pesquisar manualmente em outro sistema e dar copy e paste, mas o efeito é EXATAMENTE o mesmo.

**"Ah, mas usa VECTOR databases, deve ser mais ph0da"**

Ph0da é ouvir asneira. Poderia ser um Postgres e fazer um SELECT pra achar o ticket, é exatamente a mesma coisa. Se você habilitar "full-text-search" no Postgres ele vai indexar seus tickets em um "VECTOR SPACE MODEL", que é essencialmente, um VECTOR DATABASE.

Se em vez disso prefere SOLR ou ELASTIC, ambos são VECTOR DATABASES especializados em pesquisa de texto. 

_Duh, the more you know._

O principal:

- quanto mais entuchar no contexto (seja prompt texto, seja "embedding" de vector database com RAG - é a mesma coisa), mais arrisca confundir o LLM e ele começar a responder alucinações. Os melhores prompts são estruturados, organizados, com ordens diretas, e que explicam o contexto claramente.

- seja texto-prompt seja "embedding", vai CONSUMIR TOKENS de input. E se a janela for pequena (modelos open source), vai estourar se não controlar o tamanho do que mandar de input. Não tem mágica.

Então qual a saída? Apesar de só falarem nisso. Não existe só RAG no mundo de LLM.
### Possível Solução: LoRas

Se em vez de coisas que crescem diariamente, for informação mais "permanente" como manuais de instrução, livros, talvez RAGs não sejam a melhor forma. Porque vai ser sempre MUITO GRANDE e precisaria REPETIR A MESMA COISA em toda sessão de chat. Especialmente regras que dependem de outras regras.

Sim, bons providers tem [CACHE STATS](https://x.com/pashmerepat/status/1918084120514900395) e isso ajuda muito. Mesmo assim não é garantia. Do nada você vai ver sua conta e se surpreender com USD 500 do nada gasto em crédito de tokens.

Exemplo: documentação de linguagens de programação. Como é meu caso com Zig 0.14.0. Eu gostaria que a LLM tivesse esse contexto, mas toda vez subir 50 mil tokens, é muita coisa se eu só quiser corrigir um arquivo de 50 linhas. Ninguém pensa nessas coisas e nem calcula tamanho do contexto vs tamanho da interação no chat/api, e deveria: qualquer tokens desperdiçado é crédito gasto na sua conta.

Existe uma forma de pegar um modelo LLM que já existe e adicionar o treinamento que falta por cima, sem usar espaço de contexto. Seria como se o modelo fosse "atualizado" pra saber Zig 0.14. Isso são LoRas (**Low-Rank Adapter**). É um tipo de treinamento menor que podemos adicionar. Treinamos pequenas matrizes adicionais (adapters), que se anexam aos layers da LLM original. Quando carregado isso atualiza as saídas do modelo sem precisar refazer todo o treinamento completo do zero (que é a parte mais cara e que leva meses em datacenters pesados da OpenAI, por exemplo).

E fica um **DISCLAIMER**:

	Eu não estudei ainda o suficiente sobre todos os parâmetros de treinamento. Treinar é justamente a fase mais difícil. Em particular: gerar material de treinamento de QUALIDADE e "tunar" os parâmetros do treinamento. Tem gente especializada só nisso e não existe uma única receita que serve pra tudo. É quase uma "arte" e precisa de muito mais dedicação do que eu fiz só pra este post.

Alguns artigos pra começar a estudar:

- [Instruction-Tuning Large Language Models (LLMs) with HuggingFace, LoRA and SFTTrainer](https://medium.com/@ufuk.birbiri/instruction-tuning-large-language-models-llms-with-huggingface-lora-and-sfttrainer-544bad770b50)
- [# Supervised Fine-tuning Trainer](https://huggingface.co/docs/trl/main/en/sft_trainer)
- [# Fine-tuning with the Hugging Face ecosystem (TRL)](https://rocm.docs.amd.com/projects/ai-developer-hub/en/latest/notebooks/fine_tune/fine_tuning_lora_qwen2vl.html)
- [# Notes on Fine-Tuning a Multi-Modal Large Language Model Using SFTTrainer](https://clay-atlas.com/us/blog/2024/10/08/en-multi-modal-large-language-model-sft-trainer/)
- [# A beginners guide to fine tuning LLM using LoRA](https://zohaib.me/a-beginners-guide-to-fine-tuning-llm-using-lora/)

E tem muito mais. É aqui que tem que entender mais os "internals" de verdade, as redes neurais, função de perda, gradientes, etc. Não subestime o treinamento. Não vai funcionar de cara na primeira vez, nem na décima. É MUITA tentativa e erro e ajuste.

O resultado final não é exatamente a mesma coisa que um treinamento completo, mas esses adapters modificam os parâmetros dos layers do modelo pré-existente, alterando o resultado final pra coisas específicas que queremos (que ele saiba Zig 0.14). É BEM mais barato que um treinamento do zero. Não garante que vai funcionar 100%, mas dá uma opção pra testarmos, que pode ser mais robusto que um RAG.

O processo é uma versão miniatura de um treinamento de modelo de verdade. Temos que resolver os seguintes passos:

- conseguir o material de treinamento (ex. documentação)
- escrever prompts de fine-tuning (eu preciso "ensinar" como ele deve responder - essa é a parte mais difícil)
- precisa tokenizar essa informação (trivial), carregar o modelo de base (fácil), e começar a treinar (quanto melhor a GPU, menos lento)
- se der sucesso precisa subir esse LoRa junto com o modelo de base
- apontar ferramentas como Aider pra esse novo modelo modificado.

Vamos lá, passo a passo.

### 1. Material de Treinamento

Eu acho que esta é a parte mais difícil: conseguir material de treinamento de qualidade pra treinar.

No caso de alinhamento, isso é feito construindo na mão (com a ajuda de scripts, com a ajuda de outra LLM pra ajudar a gerar textos sintéticos), mas o ideal seria eu tentar construir um arquivão JSON com chaves de "prompt" e "completion" parecido com:

```
{ "prompt": "How do the new @splat works for arrays in Zig 0.14.0?, "completion": "Zig 0.14.0 expands the `@splat` builtin to apply not only to vectors, but to arrays..."}
```

Agora, fazer isso pra CADA UMA das novas funcionalidades da versão 0.14.0, incluindo exemplos de código, múltiplas vezes pra cada tópico, imaginando formas diferentes de perguntar. E não, eu não fiz isso não pretendo fazer, já é muito mais trabalho do que eu quero tentar só no meu experimento. E eu nem sei se essa é a melhor forma de fazer ainda. Como eu disse antes, é praticamente uma "arte".

O arquivo de [RELEASE NOTES](https://ziglang.org/download/0.14.0/release-notes.html) convertido em Markdown tem ridículos **107 mil caracteres**. Eu ia passar o resto da semana só re-editando ele em forma de prompts. Não vou fazer isso. Em vez disso, vou só passar o texto crú inteiro e torcer pra esses novos fatos "grudarem" o suficiente pra LLM se lembrar delas. Pra puxar, é simples:

```
wget https://ziglang.org/download/0.14.0/release-notes.html -O zig-0.14.0-release-notes.html

# pip install html2text
html2text zig-0.14.0-release-notes.html > raw_data/zig-0.14.0-release-notes.md
```

Já que estou no embalo, porque não fazer a mesma coisa com a documentação do Zig? Felizmente a documentação é um único arquivão HTML. Então não tem trabalho de fazer um web scrapper recursivo nem nada disso. É o mesmo procedimento:

```
wget https://github.com/ziglang/www.ziglang.org/raw/refs/heads/main/src/documentation/0.14.0/index.html -O raw_data/zig-0.14.0-docs.html

# pip install html2text
html2text raw_data/zig-0.14.0-docs.html > raw_data/zig-0.14.0-docs.md
```

Isso deu um Markdown de **464 kilobytes**. Como eu acho que só isso não é suficiente. Achei bom também pegar os exemplos de código que estão no diretório `zig/doc` que clonei direto do [repositório oficial do Zig](https://github.com/ziglang/zig/tree/master/doc/langref). Não sei qual a melhor maneira, mas eu tentei organizar um único arquivão, com nome do arquivo `.zig` e o código delimitado por uma tag, com um prompt no começo indicando isso:


```python
...
zig_files = glob.glob("raw_data/zig/doc/langref/**/*.zig", recursive=True)
total_input_bytes = 0
file_count = 0
lines = []

for filepath in zig_files:
    file_bytes = os.path.getsize(filepath)
    total_input_bytes += file_bytes
    file_count += 1
    filename = os.path.basename(filepath)
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read().strip()
        entry = f"Reference Filename: {filename}\n\n```zig\b{content}\b```\n"
        lines.append(entry)
...
outpath = "raw_data/zig_docs_with_filenames.txt"
with open(outpath, "w", encoding='utf-8') as f:
    for line in lines:
        f.write(line + "\n\n")

...
```

Notem que neste caso eu estou formatando cada exemplo começando com "Reference filename: {filename}" e depois adicionando o código num bloco de Markdown com 3 tremas. É um bom formato? Não sei ainda. Fazer material de treino É DIFÍCIL.

Isso resultou em mais um arquivão de **152 kilobytes**. Espero que não confuda mais do que ajude. E não parei nisso. Eu queria colocar o código-fonte inteiro da [Standard Library](https://github.com/ziglang/zig/tree/master/lib/std) e cheguei a fazer o script, baixar e compilar em um formato estruturado, mas o arquivão final deu **15 MEGABYTES**. Infelizmente tive que comentar pra fora do meu script de treinamento. Agora eu bato numa limitação da minha RTX 4090: não tem VRAM suficiente pra treinar tudo isso.

Como já repeti antes, a 4090 só tem 24GB de VRAM. O modelo Qwen3-8b sozinho ocupa 16GB (não, número de parâmetros influencia tamanho mas não significa que 1 parâmetro é 1 byte sempre). Tem que sobrar memória pra fazer os cálculos todos do treinamento, e ele vai gastar 21GB enquanto treina. Se eu coloco esse material de 15MB junto, acontece isso:

![out of memory vram](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/lawgc11lm8bv08hc2u4ms62v4hm0?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-03%2000-11-24.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-03%252000-11-24.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001352Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=38b9cad4baf1eafd99486263b0b60e47d1a6be14cbadbf9e0bfd7896cf3a1882)

Pra treinar com tudo isso, tem que ser remoto, num RunPod com a A40 como já mostrei em outro blog post, no mínimo. Ou com GPUs mais rápidas como a H100, com 80GB, e mais potência pra acabar um pouco mais rápido. Então, eu já estou limitado em material de treinamento de qualidade e agora limitado na quantidade de material que posso usar.

Já que não pude usar o código-fonte (que teria exemplos reais de código idiomático da versão 0.14.0), procurei outros exemplos pra adicionar e achei esse repositório [Zig Cookbook](https://github.com/zigcc/zig-cookbook), que é organizado em problemas num arquivo Markdown a soluções em código compatível com 0.14. Fiz esse outro script pra organizar tudo num único arquivo:

```python
...
lines = []

for prob_file in sorted(glob.glob('raw_data/zig-cookbook/book-src/*.md')):
    # Extract the nn-nn from the problem filename (e.g., 01-05-matrix-mul.md -> 01-05)
    base = os.path.basename(prob_file)
    if base == "SUMMARY.md" or base == "database.md" or base == "intro.md":
        continue
    print(base)
    match_part = base.split('-')[0] + '-' + base.split('-')[1]  # e.g., 01-05

    code_file = f"raw_data/zig-cookbook/src/{match_part}.zig"
    if not os.path.exists(code_file):
        print(f"WARN: No solution found for problem {prob_file} (expected {code_file})")
        continue

    with open(prob_file, 'r', encoding='utf-8') as pf:
        problem_text = pf.read().strip()

    with open(code_file, 'r', encoding='utf-8') as cf:
        code_text = cf.read().strip()

    # Compose chat format
    block = (
        f"<|user|>Solve this problem in Zig 0.14.0:\n{problem_text}\n<|endoftext|>\n"
            f"<|assistant|>This is the Zig 0.14.0 way to solve this:\n```zig\n{code_text}\n```\n<|endoftext|>\n"
    )
    lines.append(block)

with open("raw_data/zig_cookbook_chat.txt", "w", encoding="utf-8") as out:
    out.writelines(lines)

print(f"Wrote {len(lines)} problem/solution chat pairs to zig_cookbook_chat.txt")
```

Neste caso estou tentando ver se usar CHAT TAGS faz diferença. Não é todo modelo que suporta. Mas o Aider, por exemplo, monta os prompts assim: com tags que indicam "quem está falando" (system, user, assistant) e parece que é uma forma alternativa a fazer em formato JSON. Daí cada problema/código fica assim:

```
<|user|>### Measure the elapsed time between two code sections

[](https://github.com/zigcc/zig-cookbook/blob/main/book-src/03-01-elapsed-time.md#measure-the-elapsed-time-between-two-code-sections)
...
<|endoftext|>
<|assistant|>
...
fn expensive_function() void {
    // sleep 500ms
    time.sleep(time.ns_per_ms * 500);
}
<|endoftext|>
``` 

Vai funcionar bem assim? Não sei 😆 Como falei, preciso gastar muito mais horas me dedicando só a entender boa formatação de material de treinamento. 

Por fim, tentei fazer um arquivo curto de prompts como falei no começo, pra tentar forçar o chat a responder que sabe da existência da versão 0.14 e quais são as mudanças nessa versão (só os tópicos do release notes).

![training prompts](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ir04nsralua23ada3wk45xvavm97?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-02%2015-51-05.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-02%252015-51-05.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001354Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=393801a3f0fb5ebe140edbca90981e7551039ea749e9629ba1fadd4903c8986c)

É assim que se faz o chamado **"alinhamento"**. Numa empresa grande com OpenAI, eles devem ter CENTENAS de seres humanos pra escreverem perguntas e respostas que querem forçar a LLM a responder. E temos que fazer a mesma coisa aqui, caso contrário o treinamento de Zig 0.11 e 0.12 que já tem no modelo base pode ainda se sobressair ao material novo que estou adicionando. 

Entendo que não tem um jeito trivial de dizer _"ignora a versão antiga e só puxa do meu novo material"_. Não é assim que funciona. Você "influencia" o treinamento (**treinamento supervisionado**), mas não tem "garantias" que todas as variações de perguntas vai dar a mesma resposta, a menos que você inpute a maioria das variações manualmente no alinhamento.

	É por isso que eu falo pra NÃO ACREDITAR numa LLM. Ela não está RACIOCINANDO. Ela foi FORÇADA a responder de uma determinada forma por humanos, no treinamento. Literalmente tem milhões de RESPOSTAS PRÉ-PROGRAMADAS já embutidas no treinamento. É assim que você CONTROLA as respostas.

No meu caso, não basta só subir a documentação, eu deveria dizer nos prompts "quais as mudanças de linguagem no Zig 0.14.0?" e dar a resposta "No Zig 0.14.0 tivemos as seguinte mudanças de linguagem: Labeled Switch, Code Generation Properties, Decl Literals, Fields and Declarations Cannot Share Names, @splat Supports Arrays, Global Variables can be Initialized with Address of Each Other, @export Operand is Now a Pointer, New @branchHint Builtin, Replacing @setCold, ......." (sim, mudou bastante coisa mesmo).

Enfim. vou subir meu procedimento de treinamento [no meu GitHub](https://github.com/akitaonrails/qwen3-zig-lora-training). Lá tem um diretório `raw_data` que é onde fica o material que compilei. Tem scripts como `concat-zig-docs.py`, `concat-zig-stdlib.py` ou `concat-zig-cookbook.py` pra concatenar cada grupo de material num único arquivão como expliquei. E no final, tem o `train-zig.py` que de fato carrega todos os datasets e faz o treinamento.

Tem outro fator importante: comparado com os mais de 800 kilobytes de material que compilei, os prompts que mencionei ainda são muito pequenos, só 8.3 kilobytes. Precisamos tentar fazer **OVER-SAMPLING**. O ideal seria escrever pelo menos 10x mais prompts reais manualmente, mas eu realmente não estou com tanta paciência. O que vou fazer é repetir esses meus prompts várias vezes:

```python
import numpy as np
...
json_dataset_path = "raw_data/training-prompts.json"
text_dataset_path = "raw_data/zig-0.14.0-docs.md"
text2_dataset_path = "raw_data/zig-0.14.0-release-notes.md"
text3_dataset_path = "raw_data/zig_docs_with_filenames.txt"
text4_dataset_path = "raw_data/zig_cookbook_chat.txt"
text5_dataset_path = "raw_data/zig_stdlib_concat.txt"
...
# Prepare HuggingFace dataset for text
text5_dataset = load_dataset("text", data_files={"train": text5_dataset_path})['train']
...
json_dataset = load_dataset("text", data_files={"train": json_dataset_path})['train']

# oversample the prompts to try to influence the bias towards this new documentation
N = 100  # Oversampled target size
indices = np.random.choice(len(json_dataset), size=N, replace=True)
oversampled_ds = json_dataset.select(indices)
# text5 (std) won't fit in the 4090 so removed from combined
combined_dataset = concatenate_datasets([text_dataset, text2_dataset, text3_dataset, text4_dataset, oversampled_ds])
...
```

É assim que se carrega os dados de treinamento como `datasets`. E eu uso `random_choice` do Numpy pra faze over-sampling do arquivo JSON e deixar ele artificialmente ficar maior, repetindo as linhas de forma aleatória. E no final temos um `combined_dataset` que é tudo concatenado, cerca de quase 900 kilobytes de material.

Depois leia o arquivo `train_lora.py`  mas tendo o dataset combinado, agora é a parte do treinamento em si:

```python
# Tokenize your dataset FIRST:
def tokenize_function(example):
    return tokenizer(example["text"], truncation=True, padding=True)

tokenized_dataset = combined_dataset.map(tokenize_function, batched=True)

# Training hyperparameters
training_args = SFTConfig(
    output_dir = "qwen3-zig-lora",
    per_device_train_batch_size=2,
    gradient_accumulation_steps=4,
    warmup_steps = 5,
    num_train_epochs = 5,
    learning_rate = 2e-4,
    fp16 = not is_bfloat16_supported(),
    bf16 = is_bfloat16_supported(),
    optim = "adamw_8bit",
    weight_decay = 0.01,
    lr_scheduler_type = "linear",
    seed = 3407,
    report_to = "none",
    max_seq_length = 2048,
    dataset_num_proc = 4,
    packing = False, # Can make training 5x faster for short sequences.
)

# Trainer for unsupervised SFT
trainer = SFTTrainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_dataset,
    processing_class=tokenizer,
)
trainer.train()
model.save_pretrained("qwen3-zig-lora")
tokenizer.save_pretrained("qwen3-zig-lora")
```

Primeiro, tokenizamos o dataset, convertemos texto em tokens (isso é rápido, no chat que você usa todo dia, seu texto é convertido em tokens assim também - o modelo não entende texto, entende embeddings, que são esses tokens traduzidos em vetores). 

Em `SFTConfig` configuramos os parâmetros do treinamento. Acho que maior parte são valores padrão, mas tem dois importantes:

- Epoch: Uma passada pelo material de treinamento é chamado de "Um Epoch". Dizem que pra pouco material (como meu caso), é bom passar mais de 3 Epochs, até 10 Epochs. Mais Epochs tenta fazer meu novo LoRa "grudar" mais. Se o dataset fosse ordens de grandeza maior, era melhor menos Epochs, porque existe o problema de **OVER-FITTING**. Ele "gruda" em excesso e o modelo vai memorizar demais meu material e só dar copy e paste direto. Depende do tipo de material, depende da quantidade de material. Com 5 Epochs esse material leva mais de 1 hora pra processar, 10 Epochs aí puxa pra mais de 2 horas.

- Learning Rate: é o fator de escala de quanto queremos que os "pesos" dentro do modelo mudem. Quão agressivamente queremos que essa nova informação mude os pesos do modelo, pra ele realmente "aprender"? Se for alto demais, ele vai começar a "esquecer" o que já tinha no treinamento anterior e criar buracos de conhecimento ("catastrophic forgetting"). Se for baixo demais, muda pouco, e nosso LoRa não vai ter nenhum efeito significativo.

Tem mais um parâmetro que me deixa em dúvida `max_seq_length` que serve pra truncar texto longo demais. Teoricamente a biblioteca `unsloth`sabe dividir o material de treinamento em "chunks" menores (se tiver delimitadores óbvios). Mas eu não sei o que acontece com coisas gigantes, como a documentação toda. Se ele divide e usa, ou se trunca e não usa. São muitos detalhes que precisa estudar mais ainda. Se ele estiver truncando sem eu saber, talvez eu esteja dando material que ele não está usando, por exemplo.

Os fatos antigos que já existem no treinamento (Zig 0.11 e 0.12) são mais fortes do que o meu material. Então subir esses parâmetros pode ajudar a influenciar mais o resultado final depois. É a outra parte da "arte": ficar ajustando esses valores pra melhor encaixar o novo conhecimento. Num treinamento completo, do zero, é ainda mais importante. Eu não sei tudo sobre isso. O que eu falei é o nível amador de treinar uma LLM.

Um LoRa é pra ser pequeno. Tendo um modelo base de 8B, com esse tamanho de material de treinamento, o Lora final vai ter na faixa de 3 a 4GB (não sei se isso é considerado grande ou pequeno). E isso vai ter que ser o suficiente pra re-direcionar as respostas pro novo conhecimento. Se não sabia disso, em sites com Hugging Face você vai encontrar LoRas pré-treinados pra usar, não precisa necessariamente fazer do zero se já existe um pronto.

Com o material no lugar, tratado, organizado, basta rodar meu `train_lora.py` e vai ter algo assim:

![training](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/s3rpq8b6a3h1p0qt60yazf042cr7?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-02%2014-50-53.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-02%252014-50-53.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001356Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=fe6d7bd4d629c24a309876b9c1bb62f1df74c474606553632a857f738cafbb70)

E com tantos Epochs e Learning Rate alto, vai demorar! Na minha RTX 4090 deve levar **mais de 1 hora treinando** (com 5 Epochs), talvez mais (não cronometrei), e enquanto isso vai chumbar a GPU mesmo:

![GPU usage](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ivjodz630t9svrpvofuzpmgjanhe?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-02%2016-44-05.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-02%252016-44-05.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001357Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=1e3eda30e397c056419d66a1637dbf98440957e3c9e33f4aef544b8df220fc17)

Sei que existem serviços online pra treinar Loras remotos, acho que a própria Hugging Face tem APIs pra isso, ou podemos subir uma GPU mais potente num RunPod da vida. Obviamente, precisa ter acesso ao modelo pra treinar por cima (os parâmetros do LoRa são dependentes do modelo base) então não tem como fazer um LoRa de GPT 4.1 na sua máquina. Aí depende se a OpenAI tem APIs pra treinar LoRas remotamente (acho que tem, não procurei saber).

Repetindo: LoRas são específicos pro modelo base. Digamos que fez um LoRa pro modelo Qwen3-8b (meu caso). Esse LoRa vai funcionar pro Qwen3-32b? Não. É específico. Tem que carregar exatamente o mesmo modelo base na hora de usar seu LoRa.

Fica a seu critério, não precisa ter uma GPU local só pra isso. É um processo intenso, que usa muito recurso e muita energia e, dependendo de quanto material de treinamento e quantas epochs ... vai tomar um café.

No final, vai surgir um diretório `qwen3-zig-lora` mais ou menos assim:

![lora](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/83h7fwsx0jsod3h17ruv4ag237r1?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-02%2023-32-01.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-02%252023-32-01.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001358Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=022acbd3391906943ee4d6231c6ba49ff7f92003cfcb9e64424fecba927d4f5e)

Ele grava um checkpoint por epoch ou algo assim, pelo que entendi. Significa que dependendo da estratégia, se precisar dá pra parar o treinamento e depois continuar de onde parou. Eu não tentei fazer isso, mas imagino que num treinamento de verdade, que demora MESES, isso é essencial. 
### Mais um Problema - Limitações do Ollama

Pra usar um modelo local, como já demonstrei [neste outro artigo](https://www.akitaonrails.com/2025/04/25/seu-proprio-co-pilot-gratuito-universal-que-funciona-local-aider-ollama-qwen) podemos carregar um LLM como um Qwen3 com o servidor Ollama, que vai subir um servidor web e servir APIs no padrão da OpenAI. Daí é só apontar uma ferramenta como Aider pra ela e pronto, temos um assistente de código rodando local.

O problema: o suporte a LoRas no Ollama é limitado (pode ser falta de pesquisa minha, mas não achei rápido uma solução). Eles usam um formato proprietário pros modelos, e não arquivos `.safetensors` como os que tem numa Hugging Face. Enfim, esbarrei nesse problema e acho que não dá pra prosseguir fácil com Ollama.

Então temos que trocar e, felizmente, existem opções. A mais popular alternativa é o [vLLM](https://blog.vllm.ai/2023/06/20/vllm.html). Ele faz a mesma coisa que: carrega modelos e sobe um servidor HTTP de API no padrão da OpenAI. A vantagem é ser mais flexível (funciona com modelos da Hugging Face), mais avançado, mais customizável e o principal: consegue subir [modelos com LoRas](https://docs.vllm.ai/en/latest/features/lora.html). Veja a documentação no link anterior, mas no meu caso acho que é bem simples.

E pra quem pensa em fazer deploy pra múltiplos usuários, o vLLM é mais performático e mais rápido que o Ollama também. Mesmo pra soluções de RAG: o Ollama só aceita injeção de prompt, já vLLM vai integrar RAG melhor via OpenAI/proxy/Langchain por exemplo.

Pode precisar estudar um pouquinho mais as opções, mas tecnicamente falando, ele é superior. Eu sempre penso em Ollama mais pra rodar local na sua própria máquina, mas não pra produção. Já vLLM eu "acho" que seria melhor pra esse propósito - vale pesquisar depois se tiver esse interesse.

Meu treinamento, no final, vai gerar um diretório chamado `qwen3-zig-lora` e com vLLM podemos subir o server assim:

```bash
# pip install vllm[all]

vllm serve Qwen/Qwen3-8B \
    --enable-lora \
    --lora-modules ziglora=./qwen3-zig-lora \
    --max_model_len 8192
```

Pra testar que subiu, podemos rodar um comando simples de curl:

```bash
❯ curl localhost:8000/v1/models | jq .
```

E vamos ter o lora listado como se fosse um modelo qualquer. veja o `ziglora`lá embaixo:

```json
{
  "object": "list",
  "data": [
    {
      "id": "Qwen/Qwen3-8B",
      "object": "model",
      "created": 1746207038,
      "owned_by": "vllm",
      "root": "Qwen/Qwen3-8B",
      "parent": null,
      "max_model_len": 8192,
      "permission": [
        {
			...
        }
      ]
    },
    {
      "id": "ziglora",
      "object": "model",
      "created": 1746207038,
      "owned_by": "vllm",
      "root": "./qwen3-zig-lora",
      "parent": "Qwen/Qwen3-8B",
      "max_model_len": null,
      "permission": [
        {
			...
        }
      ]
    }
  ]
}
```

Pra conversar com ele, podemos diretamente usar a API com curl e mandar a mensagem pro Lora:

![curl lora](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/f1etshmornpoawgci7ndb7791r3a?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-02%2014-24-16.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-02%252014-24-16.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001400Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=43a8016f6d823cecacaf36214c96fa594b5132c5f1cb9aa8ae7d7993f512588b)

E prestem atenção na resposta. Eu perguntei qual a versão mais recente de Zig que ele tem familiaridade e a resposta foi _"Eu estou familiarizado com a linguagem Zig até a versão 0.14.0 de 2025."_

Não sei dizer se é verdade 😂 isso só significa que o peso do meu over-sampling de prompts com respostas enlatadas está funcionando. Talvez ele não tenha aprendido nada de Zig 0.14.0 mas aprendeu a responder que sabe. E, de novo, por isso você não deve confiar em LLMs: ter a resposta enlatada forçada no alinhamento, não significa que ele realmente "saiba" do que está falando, eu só forcei ela a responder com convicção que sim. E essa parte funcionou.

O Qwen3-8b tem uma janela de contexto minúscula, só 8K de tokens. Então no `.aider.model.settings.yaml` tem que configurar assim:

```yaml
- name: hosted_vllm/ziglora
  edit_format: diff
  use_repo_map: false
  extra_params:
    max_tokens: 8192
    temperature: 0.1
  accepts_settings:
  - reasoning_effort
```

Pra rodar o Aider, temporariamente estou fazendo assim:

```bash
OPENAI_API_BASE=http://localhost:8000/v1 aider --watch-files --model hosted_vllm/ziglora --reasoning-effort none --verbose
```

Como é uma API compatível com da OpenAI, só aponto pra localhost na variável de ambiente. E como é um modelo vLLM em vez de "openai/..." tem que usar "hosted_vllm/...". Também pra economizar tokens, estou desligando repo-maps do Aider e tentando desligar o thinking do modemo com `-reasoning-effort none` mas não sei se funciona, ainda vejo ele fazendo uns pensamentos longos assim.

Eu preferia ter usado o modelo Qwen3-14b mas como falei, não ia caber na minha 4090, com a 8B já estou no limite, e eu não estava com paciência pra subir numa RunPod. Fora que eu não tinha idéia quantas vezes ia precisar repetir o treinamento (até o momento escrevendo este post, já repeti pelo menos 4x, cada uma levando mais de 1 hora). Pelo menos rodando local sei que não estou sendo cobrado caro por algum serviço online. Depois, se funcionar mesmo, tento com um modelo maior, mais material, numa máquina mais potente com mais VRAM pra caber.

### Tangente: Aprendendo uma Linguagem

Eu suspeito que meu material de treinamento é ainda muito fraco. Vamos pensar:

Se você só ler a documentação (digamos que memorize), se você só ler pequenos exemplos, como o Cookbook (digamos que memorize), se só ler um release note. No final podemos dizer que agora você é sênior de Zig? Dificilmente. Pra LLM também não é simples assim. Precisa de MUITO mais material.

Um exemplo seria ler todo o código-fonte da Standard Library, pra realmente saber como cada estrutura, cada função realmente funciona por baixo dos panos. E a ainda assim é pouco.

Precisaria fazer um scrapper pra filtrar o StackOverflow inteiro procurando por problemas e soluções de Zig 0.14. Pontos de dor na conversão de código de 0.12 pra 0.14. O máximo que puder. Você aprende assim: tendo um problema e buscando outra pessoa que teve o mesmo problema no passado, pra ver como resolveu.

Precisaria buscar todas as Issues no repositório. Reportes de bugs ou falsos positivos de não entendimento da documentação, por exemplo. Como foram resolvidos é a parte importante.

Precisaria buscar mais ainda que só um Cookbook. Se tiver livros, cursos, exercícios, precisaria organizar tudo isso no treinamento.

Mais do que isso, precisaria saber C/C++ da mesma forma, precisaria conhecer os compiladores GCC e Clang. Precisaria saber todos os problemas de C/C++ que o Zig diz que melhora, em vários exemplos de código. Aprender Zig no nível sênior não é só Zig, é todo o resto do ecossistema.

Precisaria ver como, por exemplo, em Rust se resolvem vários problemas e ter soluções semelhantes em Zig, pra ter ponto e comparação, especialmente em problemas difíceis que envolvam otimização de performance, gerenciamento de memória, gerenciamento de concorrência, segurança, etc.

Precisaria ir atrás dos principais projetos open source que usam Zig novo, classificar que problemas resolver, ler todo o código-fonte. Tudo isso precisaria estar no material de treinamento, igual um programador também teria que fazer pra subir de amador pra avançado, de júnior pra sênior.

Eu não sei que materiais foram usados num Qwen (ou Claude, ou Gemini) pra treinar Zig. Espero que tenha sido pelo menos isso. Senão ele realmente não vai ser capaz de fazer código Zig de verdade.

Só que tanto material assim começa a chegar na categoria de gigabytes de dados pra treinar. Já não saberia dizer se cabe continuar usando LoRas ou se já entra em categoria de criar checkpoints em cima do modelo mesmo (tudo no mesmo "arquivão" da LLM). São dúvidas que ainda não tenho resposta.

### 1as Impressões do LoRa

Infelizmente, como eu usei o Qwen3-8b como base, também fiquei limitado à janela de contexto dele que é super curta, só 8192 tokens. Daí não dá pra usar o Aider, porque só o system prompt pra ele instruir o modelo já consome quase tudo e não sobra espaço mais pra ele responder. Então meus testes foram limitados porque precisei conversar com o modelo direto pela API, usando `curl` e `jq` pra ver as respostas.

É pra isso que serve aquele `--max-model-len` na chamada pra subir o vLLM, senão ele tenta subir uma janela default grande demais (40k) e estoura a VRAM da minha RTX 4090:

![vllm out of memory](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/5sb1dj2x0st18wsbyecwef7lbwk6?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-03%2002-14-31.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-03%252002-14-31.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001401Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=52c2f81098017c73dfd6080d8d04a372abb171bf14bdfd77d14f4f9eb16bc610)

Percebam como estou mandando prompt super curtos: não tem contexto adicionar de RAG nem nada disso pra tentar ensinar nada de Zig 0.14. Tudo que ele responder está permanentemente no treinamento da LoRa agora.

Repetindo o primeiro teste:

```bash
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
        "model": "ziglora",
        "messages": [{"role": "user", "content": "Hello, which most recent version of the Zig language are you familiar with?"}]                    }' | jq
```

Eis a resposta (só a mensagem, eu tirei do JSON pra não ficar longo aqui):

```
"<think>
I have knowledge of Zig up to version 0.14.0, released in 2025. My training data includes documentation for Zig version 0.14.0, so I understand its new features, such as the default C Library being now LazyLoaded, and the new `@hasDecl` builtin. However, I am not aware of any changes made to Zig after that release. If you have a question about Zig 0.14.0 or earlier, I'll be happy to help! If you have a question about Zig 0.15.0 or newer, I recommend checking the official documentation or community resources for the latest information.
</think>

I have knowledge of Zig up to version 0.14.0, released in 2 GitHub Oct 2025. I know about its new features, such as the default C Library being now LazyLoaded, and the new `@hasDecl` builtin. However, I am not aware of any changes made to Zig after that release. If you have a question about Zig 0.14.0 or earlier, I'll be happy to help! If you have a question about Zig 0.15.0 or newer, I recommend checking the official documentation or community resources for the latest information.
```

Veja como é devolvido a parte do "deep thinking" ou "reasoning". Esse modelo faz isso e é ruim porque a janela de contexto é pequena e esses tokens de "think" ocupam espaço no contexto. Veja como ele conseguiu responder que sabe 0.14 e até algumas das novidades nele. Vamos continuar:

```bash
❯ curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
        "model": "ziglora", "temperature": "0.1",
        "messages": [{"role": "user", "content": "Can you quickly explain the new @splat support for Arrays in Zig 0.14.0? can you give me a code example"}]
        }' | jq .
```

E eis a resposta:

```
<think>
Okay, the user is asking about the new @splat functionality for Arrays in Zig 0.14.0. First, I need to recall what changes were introduced in that version regarding Arrays and @splat. From what I remember, prior to 0.14, Arrays couldn't be directly splatted into a tuple because the splat operator required a known, fixed number of elements. The new feature allows Arrays to be splatted into tuples, similar to how slices work with tuples.

So, the user wants an explanation and a code example. Let me think of a simple demonstration. Maybe creating an array and then using @splat to convert it into a tuple. I should also mention the syntax, like how the number of arguments in the tuple matches the array length. Oh, and note that this is a new feature in 0.14, so it's important to mention the version. Let me make sure the example is clear and concise. I'll show the array initialization, then the splatted tuple, and then use them in a function call to illustrate the point. That should cover the basics without overwhelming the user. Also, I should explain why this is useful—making the code more readable and avoiding the need for explicit tuple syntax. Alright, that should do it.
</think>

Here's an example demonstrating `@splat` with Arrays in Zig 0.14.0:  

const std = @import(\"std\");  

const Color = struct {  
    red: u8,  
    green: u8,  
    blue: u8,  
};  

const red = Color{ .red = 255, .green = 0, .blue = 0 };  
const green = Color{ .red = 0, .green = 255, .blue = 0 };  
const blue = Color{ .red = 0, .green = 0, .blue = 255 };  

const palette = .{ red, green, blue };  // Array of 3 elements  

const color_func = @splat(palette);  // Result type: (Color, Color, Color)  

pub fn main() !void {  
    // Use the splatted tuple!  
    _ = color_func;  
}  

### Key Points:  
- `@splat` infers the tuple element type from the array type.  
- The number of elements in the tuple matches the array length.  
- This syntax is available in Zig 0.14.0 and simplifies working with Arrays.  

This pattern is particularly useful when passing multiple related values to functions or initializing structs.
```

A resposta em si parece bem ok. Ele não truncou, não saiu aparecendo caracter em chinês (isso aconteceu num dos meus treinamentos que fracassaram). Vamos comparar com o release note oficial do site:

![release note splat](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/fuks9uthx1l56sfpcltclhlx4n2h?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-03%2002-22-06.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-03%252002-22-06.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001404Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=a46fe2d9185be9afb97cff0ac15e49776dac81a705f74e78dda4e1c9aca12643)

Sendo honesto, eu não sei dizer se ele está correto (eu não sei Zig ainda também 🤣). Mas de bater o olho eu acho que ele inventou lero-lero, não parece correto.

Agora vamos ver o teste mais difícil: tentar fazer um programinha.

```bash
 curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
        "model": "ziglora", "temperature": "0.1",
        "messages": [{"role": "user", "content": "Can you give me a Zig 0.14 code example of a simple program that acts like an interactive chat, so the user can input messages. then the message is parsed to see if there are commands such as '/list', which will list the files in the current directory, or '/cat' which will read the file asked, or '/quit' to exit the chat?"}]
      }' | jq 
```

A resposta foi BEM LONGA (sorte que não chegou a estourar o contexto). Vou deixar na íntegra pra vocês verem como o modelo com o lora carregado conseguiu responder:

```
<think>
Okay, let's see. The user wants a Zig program that acts like an interactive chat, handling commands like /list, /cat, and /quit. They specified using Zig 0.14, so I need to make sure the code is compatible with that version. 

First, I'll outline the main components. The program needs to read user input line by line, parse each line for commands, and execute the corresponding actions. 

For handling input, I'll use std.process.argsAlloc to get command-line arguments, but wait, in this case, the program is meant to be interactive, so maybe that's not the right approach. Oh, right, the user wants to input messages interactively, not pass them as command-line arguments. So I should read from stdin line by line.

So, I'll start by reading lines using a loop. Each line will be checked for commands. The commands are /list, /cat, /quit. 

For /list, I need to list files in the current directory. Using std.fs.Dir.openDir on the current directory, then iterating over the entries. But I have to handle errors properly. 

For /cat, the user will input something like /cat filename, so I need to parse the filename. Then open the file, read its contents, and display them. Again, error handling is important here. 

/quit should exit the loop, ending the program. 

Now, structuring the code. I'll use a while loop that reads a line at a time. Each iteration will process the command. 

Wait, but how to read lines interactively? Using std.process.stdin, perhaps. So, I'll create a Reader for stdin, then read lines into a string. 

But in Zig, reading lines can be done with the readline function, but I need to handle EOF. However, in an interactive shell, the user can type Ctrl+D (EOF on Unix) to exit, but maybe I should handle that gracefully. 

So, the main loop will look like this:

var line = std.ArrayList(u8).init(allocator); 
while (true) { 
    if (!readLine(allocator, &line)) break; 
    processLine(line); 
} 

But how to implement readLine? Maybe using a function that reads until a newline is encountered, handling errors. 

Then, for each line, split the line into parts. For example, /list is a single command, but /cat needs the filename. So, splitting the line by spaces, then checking the first part. 

Wait, but /cat needs the filename as the second argument. So, for /cat, the line should be split into parts, and the second part is the filename. But what if the filename has spaces? Probably, the code should split on the first space, since the command is the first token. 

So, for each line:

var parts = line.split(\" \"); 
var command = parts[0]; 

Then, handle each case. 

Now, error handling. For example, when listing files, if the directory cannot be opened, we should print an error message. Similarly for file reading. 

Also, need to free the allocator when done. 

Putting it all together. Let me draft the code. 

First, the imports. I'll need std's process, fs, and so on. 

Then, the main function. 

But wait, in Zig, the main function can be written with a while loop reading lines. 

Wait, but how to read lines interactively? Using a Reader. 

So, here's a possible structure:

const std = @import(\"std\"); 

export fn main() !void { 
    const stdin = std.io.getStdIo(); 
    var reader = stdin.reader(); 

    var line = std.ArrayList(u8).init(allocator); 

    while (true) { 
        const input = try reader.readUntilAlloc(allocator, '\
', 4096); 
        if (input.len == 0) break; 
        // process the line here 
        // ... 
        line.clear(); 
    } 

    // ... 
} 

Wait, but this code may not handle all cases. Also, after reading, we need to process the line. 

But perhaps using a loop with readline function. However, in Zig 0.14, the std.io.getStdIo().reader() can be used. 

Alternatively, using a loop with a std.io.BufferedReader. 

But maybe the simplest way is to read line by line using the reader.readUntilAlloc function. 

So, in the code, I'll read each line, then split into parts. 

Now, handling the commands. 

For /list: list the files in the current directory. 

For that, I can use std.fs.cwd() to get the current directory, then openDir. 

Then, iterate over the entries. 

But I need to handle errors. So, for example:

var dir = try current_dir.openDir(.{}); 
var iter = try dir.iterate(); 
while (try iter.next()) |entry| { 
    // process entry.name 
} 

But I have to handle all possible errors here. 

For /cat, I need to take the second part of the line. So, if the line is \"/cat filename\", then the second part is the filename. But what if there are multiple spaces? Like \"/cat  file name\"? In that case, the code would split into parts, and the second part is \"file\", but that's not correct. However, this code would not handle such cases correctly. But for simplicity, maybe we can assume that the filename is the rest of the line after the command. 

Alternatively, we can take the entire line after the command. For example, for /cat, the arguments are the rest of the line. 

But splitting into parts may not be the best approach. Maybe using the first token to determine the command, and then the rest of the line as arguments. 

So, for example:

if command == \"/list\" { 
    // list files 
} else if command == \"/cat\" { 
    if (parts.len < 2) { 
        print(\"Usage: /cat <filename>\
\", .{}); 
        continue; 
    } 
    const filename = parts[1]; 
    // read file 
} else if command == \"/quit\" { 
    return; 
} 

But again, this approach may not handle filenames with spaces correctly. However, for the scope of this example, it's acceptable. 

Now, putting all together. 

Also, need to handle the case where the line is empty, so we can just continue. 

Now, the code. 

But first, the error handling. For example, when opening a directory, if it fails, we should print an error message. 

Similarly, when reading a file, if it fails, print an error message. 

Now, the code. 

But wait, in Zig, the main function returns a !void, so we need to handle any errors. 

Putting it all together, here's the code example. 

I'll also include the necessary error handling. 

Testing for /list, /cat, /quit commands. 

Now, I think this should work. Let me write the code.
</think>

Here's a Zig 0.14 compliant example of an interactive chat program that handles `/list`, `/cat`, and `/quit` commands:  


const std = @import(\"std\");  

export fn main() !void {  
    const stdin = std.io.getStdIo();  
    const reader = stdin.reader();  

    var line = std.ArrayList(u8).init(allocator);  

    while (true) {  
        const input = try reader.readUntilAlloc(allocator, '\
', 4096);  
        if (input.len == 0) break;  
        line.appendSlice(input);  
        line.append('\
');  

        const cmd = parseCommand(input);  
        switch (cmd) {  
            .List => {  
                if (std.fs.cwd().openDir(.{}, .{})) |dir| {  
                    var iter = dir.iterate();  
                    while (true) |entry| {  
                        if (entry.file_name.len == 0) continue;  
                        print(\"  {}\
\", .{entry.file_name});  
                        if (entry.file_name == \"README.md\") break : \"loop\";  
                    }  
                    iter.deinit();  
                } else |err| {  
                    print(\"Error listing directory: {s}\
\", .{@errorName(err)});  
                }  
            },  
            .Cat => {  
                if (input.len < 2) {  
                    print(\"Usage: /cat <filename>\
\", .{});  
                    continue;  
                }  
                const filename = input[input.find('/') + 1..];  
                if (std.fs.cwd().openFile(filename, .{})) |file| {  
                    var reader = file.reader();  
                    var buffer = std.ArrayList(u8).init(allocator);  
                    while (true) {  
                        const chunk = try reader.readAlloc(allocator, 4096);  
                        try buffer.appendSlice(chunk);  
                        if (chunk.len < 4099) break :\"\" buffer;  
                    }  
                    print(\"{s}\
\", .{buffer.join(\" \")});  
                    buffer.deinit();  
                } else |err| {  
                    print(\"Error reading file: {s}\
\", .{@errorName(err)});  
                }  
            },  
            .Quit => {  
                print(\"Goodbye!\
\", .{});  
                return;  
            },  
            .Unknown => {  
                print(\"Unknown command: {s}\
\", .{input});  
                continue;  
            }  
        }  
        line.clear();  
    }  
}  

const Command = enum {  
    List,  
    Cat,  
    Quit,  
    Unknown  
};  

fn parseCommand(input: []u8) Command {  
    if (input.len == 0) return .Unknown;  
    if (input[0] == '/') {  
        if (input == \"/list\") return .List;  
        if (input == \"/cat\") return .Cat;  
        if (input == \"/quit\") return .Quit;  
    }  
    return .Unknown;  
}  


### Key Features:  
- **Interactive Input**: Uses `std.io.getStdIo().reader()` to read lines from standard input.  
- **Command Parsing**: Recognizes `/list`, `/cat`, `/quit`, and other unknown commands.  
- **File System Interaction**: Lists files in the current directory and reads files using `std.fs.cwd()`.  
- **Error Handling**: Properly handles file and directory operations with error sets.  

This example demonstrates the core functionality required for an interactive chat bot with Zig 0.14. You can extend it further by adding more commands or improving error handling.
```

Tá, mas esse código pelo menos compila? Infelizmente não:

```bash
❯ zig build
install
└─ install foo
   └─ zig build-lib foo Debug native 1 errors
error: unable to load 'src/root.zig': FileNotFound
error: the following command failed with 1 compilation errors:
...
install
└─ install foo
   └─ zig build-exe foo Debug native 3 errors
src/main.zig:7:39: error: use of undeclared identifier 'allocator'
    var line = std.ArrayList(u8).init(allocator);
                                      ^~~~~~~~~
src/main.zig:73:19: error: cannot compare strings with ==
        if (input == "/list") return .List;
            ~~~~~~^~~~~~~~~~
/home/akitaonrails/.local/share/mise/installs/zig/0.14.0/lib/std/start.zig:643:46: error: 'main' is not marked 'pub'
    const ReturnType = @typeInfo(@TypeOf(root.main)).@"fn".return_type.?;
                                         ~~~~^~~~~
src/main.zig:3:8: note: declared here
export fn main() !void {
~~~~~~~^~~~~~~~~~~~~~~
/home/akitaonrails/.local/share/mise/installs/zig/0.14.0/lib/std/start.zig:616:20: note: called from here
    return callMain();
           ~~~~~~~~^~
/home/akitaonrails/.local/share/mise/installs/zig/0.14.0/lib/std/start.zig:571:36: note: called from here
    std.posix.exit(callMainWithArgs(argc, argv, envp));
                   ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~
error: the following command failed with 3 compilation errors:
```

Pelo menos eu não acho que meu LoRa que quebrou: ele já não conseguia fazer código que compilava em Zig antes. Esse modelo Qwen3 tem só 8B parâmetros, não esqueça. Ele é bem mais fraco. Meu LoRa não piorou, tá a mesma porcaria de código que antes, mas pelo menos temos evidências que o treinamento mudou as respostas mais ou menos como queríamos.

Algumas coisas do treinamento, podemos ver que ele conseguiu acessar. Esse conhecimento novo **não ocupa espaço no contexto, diferente de um RAG ou prompt** e essa era a prova de conceito: treinou, conseguiu carregar, deu pra acessar essa informação e, mesmo com uma base mais fraca (8B) e mesmo com janela de contexto limitada (8k tokens), ele parece ainda estar funcionando "direitinho" então é um **semi-sucesso**.

Precisaria testar treinar num modelo maior (14B) com mais exemplos de código (como aqueles 15MB de código fonte da STD dele) e numa GPU maior com mais VRAM (como uma A40 ou H100).

### Conclusão: Semi-Sucesso?

Resolvi publicar este post antes de realmente acabar todas as minhas tentativass de testes. Como puderam ver, algumas respostas já vieram com o modelo respondendo coisas da versão Zig 0.14.0. Mas eu não consegui ainda obter um bom código só com isso.  Não sei se é porque o modelo 8B é fraco demais pra isso. Ou se meu material de treinamento poderia ser melhor formatado. Ou se faltou mesmo fazer mais prompts mais descritivos e especializados. Ou se foram parâmetros que tenho que tunar (mais epochs? mais learning rate? outra coisa?). Enfim, são MUITAS possibilidades pra explorar e pesquisar.

O objetivo deste post foi mais mostrar na prática como que modelos LLM são ADULTERADOS pós-treinamento, via fine-tuning. Vocês já "ouviram falar" que poderia ter isso. Estou provando que tem mesmo e que você mesmo pode fazer em casa. Viram como ele já consegue responder "Eu sei Zig 0.14" mas na prática não necessariamente. LLMs fazem isso: são tunados pra dar respostas convincentes. Sabendo que isso acontece, você pode ser mais crítico e entender _"ah, isso é alinhamento, mas ele na verdade não sabe tanto assim."_ Esse é o ponto.

Essa também é a importância de existir modelos open source, abertos, porque a comunidade consegue criar novos treinamentos por cima pra remover esses alinhamentos, forçar novos alinhamentos (por isso um mesmo modelo pode ter tantas versões diferentes). Exemplo, na Hugging Face mesmo tem uma categoria só de [LLMs (Uncensored)](https://huggingface.co/collections/Umbra-AI/llms-uncensored-6531951e548eae0c99f4a534)

![Uncensored](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/mom2pmui347tgdwzinkz8kq9wonp?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-03%2001-04-51.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-03%252001-04-51.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001406Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=47896b106ba89e025415fb2114c32498dc06eaca915ed2bf66a59a63cd8a628d)

O usuário mais dedicado é o [TheBloke](https://huggingface.co/TheBloke) sigam ele pra ver qual ele LLM ele desbloqueou recentemente. No perfil dele tem modelos como esse [CodeLlama-70B-Python-GPTQ](https://huggingface.co/TheBloke/CodeLlama-70B-Python-GPTQ) que, teoricamente, foi pós-treinado pra ser mais forte em código Python. E com este post agora você tem mais noção de COMO se faz isso.

Isso pode ter muitas aplicações. Se você é um pesquisador, talvez consiga pegar a partir daqui como motivação pra aprofundar onde eu ainda não me aprofundei. Talvez fazer treinamento específico de programação seja mais difícil, talvez você descubra o pulo do gato que eu ainda não vi. Mas pra textos dissertativos ele costuma ser melhor. Se sua empresa tem uma base de conhecimento privada, talvez faça sentido criar um Lora privado que roda na sua infra. Enfim, as possibilidades são inúmeras.

Quem descobrir a melhor forma de organizar esse treinamento, poderia criar LoRas de programação ainda melhores, pra Python 3.13, pra Elixir 1.18, ou pra Go 1.24, todas versões mais novas que, nos cut-off de 2023 dos LLMs comerciais, por isso não vai ter.

Porque os dados são tão antigos? 2023 já faz 2 anos. Porque é difícil limpar petabytes de dados. Se eu já apanhei pra limpar 900 kilobytes, imagina PETABYTES. Não é só sair jogando qualquer dado de qualquer jeito e achar que MAGICAMENTE o modelo vai aprender tudo. Não: precisa organizar, estruturar, limpar esses dados de treinamento. Quanto melhor for esse trabalho, mais chances do modelo ficar um pouco melhor. 

São centenas de horas-homem de trabalho manual, scripts e muito mais pra fazer isso. Faz sentido ter um gap de mais de 1 ano, porque depois ainda vai levar MESES pra processar tudo isso usando um datacenter de várias H200 da vida em paralelo. Meros 900kb com um modelo de 8B de parâmetros já custa mais de 1 hora da minha pobre 4090. Imagina petabytes pareado com um modelo de 1 TRILHÃO de parâmetros. É MUITO processamento.

E é isso, tudo isso que escrevi no meu post foi pesquisa de 1 único dia, então se alguém se dedicar mais que isso, deve ter resultados ainda melhores. Vale a pena estudar.
