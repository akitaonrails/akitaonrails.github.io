---
title: 'Hello World de LLM: criando seu próprio chat de I.A. que roda local'
date: '2025-04-25T00:20:00-03:00'
slug: hello-world-de-llm-criando-seu-proprio-chat-de-i-a-que-roda-local
tags:
- llm
- qwen
- cursor
- windsurf
- aider
- gemini
- chatgpt
- claude
- python
- docker
- pytorch
draft: false
---

Ando brincando BASTANTE com os diversos derivados de GPT como o próprio ChatGPT, Claude Sonnet, Gemini e depois talvez eu faça um outro post sobre minha experiência, mas hoje eu queria brincar um pouco mais a fundo e fazer um experimento nível "Hello World" pra que vocês, programadores, entendam como que funciona por baixo dos panos.

Eu subi o projeto no GitHub, se chama [Tiny Qwen CLI](https://github.com/akitaonrails/Tiny-Qwen-CLI) e foi feito somente pra PROPÓSITOS EDUCACIONAIS. Pra uma ferramenta de verdade, pesquise o [Aider](https://aider.chat/). Talvez eu fale dele em outro post depois.

O conceito que quero ensinar: GPTs não são mágica.


### Conceitos

Assistam a minha [playlist de I.A.](https://www.youtube.com/watch?v=UDrDg6uUOVs&list=PLdsnXVqbHDUeowsAO0sChHDY4D65T5s1U&pp=gAQB) pra entender como um GPT funciona. Depois de assistido vamos entender.

Embaixo de todo Gemini, ChatGPT, Claude ou qualquer outro aberto como LLAMA da Meta, existe um arquivo binário gigante que é o resultado das horas e horas de treinamento com petabytes de dados. 

O treinamento consiste - BEM A GROSSO MODO - em tokenizar as palavras dos textos (não é bem isso, mas pense quebrar em sílabas, o certo são n-grams). Depois transformar em vetores (como você aprendeu na facultade, uma lista de coordenadas, que costumam ser **FP** ou ponto flutuante, FP-32, 32-bits pra ser mais preciso). O treinamento consiste em ir mudando esses vetores de lugar dentro de um espaço hiper-dimensional (muito mais que 3 dimensões como estamos acostumados, pense milhares ou milhões).

Esse posicionamento de vetores vai mudando à medida que vamos dando mais textos. Ele vai "encontrando relacionamentos" entre diferentes tokens. Chegamos num ponto onde cada possível palavra foi codificada como vetores e esse posicionamento lhes dá "significados". É onde vem o famoso exemplo que se pegarmos a palavra "REI" e substrairmos de "HOMEM" depois somarmos com "MULHER" vamos encontrar o vetor de "RAINHA".

```
REI - HOMEM + MULHER = RAINHA
```

Isso não é acidente, é porque o treinamento conseguiu "posicionar" esses vetores de tal forma que conseguimos fazer "contas" com esses vetores e encontramos significado.

Estou sendo ABSURDAMENTE GROSSEIRO, considere que isso tudo são dezenas de papers e eu estou resumindo em meia dúzia de parágrafos. O importante é entender que isso custa MUITO TEMPO, porque cada novo token que entra no treinamento precisa varrer todos os outros tokens que já foram calculados e recalcular uma porção enorme deles, o tempo todo!

Horas e horas, dias e dias depois, processando terabytes e terabytes de textos, uma hora chegamos ao final com um enorme arquivo de vetores, um **VSM** ou Vector Space Model.

Se entrarmos num site que cataloga e armazena modelos pré-treinados, na [página da Meta pro LLAMA 3 70B](https://huggingface.co/meta-llama/Meta-Llama-3-70B/tree/main), vemos isto:

![Huggingface Meta](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/34kujh0nzamxau15gqarr0rhp7v7)

Temos o arquivão particionado em 30 arquivos menos de uns 4.5 GB cada um, totalizando uns **135 GB**, pra um arquivo de 70B ou seja, 70 bilhões de parâmetros. Parâmetros não são "neurônios" nem nada parecido com isso. São pesos e viéses dos cálculos, armazenados no banco de dados - eu explico isso nos meus videos, assistam.

Existem versões maiores, um GPT o4 tem 1.8 trilhões de parâmetros. São números impressionantes quando se fala, mas na prática, muito acima de 300B, no uso geral, não faz _tanta_ diferença quanto se pensa. Talvez em perguntas muito específicas. Significa que sim, tem muito mais relacionamentos armazenados, mas não necessariamente isso se traduz em respostas proporcionalmente melhores. Só que pode acabar sendo mais prolixo do que o normal. De novo, estou sendo grosseiro, mas é só pra baixar as expectativas. Parem de se impressionar com números grandes se você não sabe o que eles significam.

Muito mais coisa influencia a qualidade das respostas, não só parâmetros: qualidade e quantidade de dados de treinamento, arquitetura do modelo, metodologia do treinamento, tamanho da janela de contexto, fine-tuning, alinhamentos e treinamentos de segurança (que costumam piorar as respostas em nome de "segurança").

Modelos menores, com arquiteturas mais eficientes, dados de treinamento de mais qualidade, focado em **tarefas específicas** (é melhor um modelo menor especializado do que um modelo gigante que tenta saber tudo - _Jack of all Trades, Master of None_).

Ser um arquivo maior e ter mais parâmetros só significa uma coisa: vai ser proporcionalmente mais pesado pra rodar e provavelmente não vai caber na memória tudo de uma vez e precisa ficar fazendo _switching_ de pedaços (como um _bank switching de memória_, pra quem é programador).

Neste projeto de Hello World, eu escolhi - aleatoriamente - usar o modelo [**Qwen 2.5 Coder 70B**](https://github.com/QwenLM/Qwen2.5-Coder). Esses modelos abertos como Llama costumam estar disponíveis em vários tamanhos. Eu escolhi o 70B porque cabe nos 24GB de VRAM que eu tenho na minha GPU RTX 4090. Se sua GPU for menor, escolha modelos com tamanho menor como os de 0.5B, 3B, 14B, 32B, e sempre prefira modelos especializados (como esse que é "Coder"). E sempre leia a página do projeto, que costuma ter exemplos de código e fine-tuning documentados. Não existe um código geral que funciona pra tudo, cada modelo tem características diferentes.

O Qwen 2.5 vem dividido em 6 arquivos de 5 GB cada, então precisa baixar **30GB** se quiser brincar com a versão "extra-large".

O código pra isso é até que bem simples, porque a comunidade de I.A. já empacotou todas as ferramentas que se precisa em bibliotecas fáceis de usar, normalmente em Python (libs em Python que falam com libs de mais baixo nível em C na real), como o `transformers` que faz o trabalho pesado de carregar esses arquivos na memória e gerenciar.

Esses arquivos costumam ter extensões como ".safetensors" que é meio genérico ou ".pt" ou ".pth" que é mais específico pra formato PyTorch, que é uma biblioteca Python de redes neurais feita pela Meta. É concorrente do Tensorflow do Google.

Tensors é o nome genérico pra vetores ou matrizes. Um número escalar é um Tensor de ordem 0, um vetor é um Tensor de ordem 1, uma matriz é um Tensor de ordem 2 e assim por diante. Não temos palavras pra ordens acima de 2, então pode falar Tensor de ordem 3, ordem 4 e infinitamente pra milhões de ordens numa LLM.

CPUs são hardwares genéricos feitos pra lidar primariamente com tensors de ordem 0: números escalares inteiros. Operações como soma, adição, multiplicação e tudo mais é de um inteiro pra outro inteiro. Números reais (com decimal) são "simulados", separando um número inteiro chamado "expoente" de outro inteiro chamado "mantissa" (o que você chama de "decimal") separado por um ponto, o "ponto flutuante". Mas essencialmente estamos calculando inteiros e truncando precisão. Quanto mais bits, mais precisão.

GPUs são hardware especializados em calcular Tensors, em particular matrizes. Eles foram originalmente feitos pra recalcular efeitos em imagens de video, como um video game em movimento. Frames por segundo. Um frame é formado por linhas e colunas de pixels: um tensor de ordem 2.

Em vez de fazer um loop com "for" e ir calculando pixel a pixel, é mais eficiente passar uma matriz inteira pra multiplicar com outra matriz, um "kernel", pra obter algum efeito como sombra, luz, mudança de cor, distorções e muito mais. Programas que fazem isso costumamos chamar de **shaders".

Um PyTorch ou Tensorflow se conecta a um GPU usando uma biblioteca que lhes dá acesso a APIs pra, em vez de passar imagens, passar matrizes numéricas. A NVIDIA tem CUDA, a AMD tem ROCM, a Apple tem Metal, existe o projeto geral Vulkan que tenta falar com todos. Mas o mais avançado e o mais usado ainda é o CUDA, porque de fato foi a NVIDIA que saiu na frente anos atrás evangelizando que GPUs poderiam ser usadas pra mais do que shaders de imagens.

Isso tudo dito, arquivos como esses ".safetensors" são carregados pela biblioteca `transformers`, que chama o `torch` e manda o CUDA carregar na VRAM da GPU, onde ele pode processar. O código mais básico pra isso é mais ou menos assim:

```python
from transformers import AutoTokenizer, AutoModelForCausalLM

device = "cuda" # the device to load the model onto

# Now you do not need to add "trust_remote_code=True"
TOKENIZER = AutoTokenizer.from_pretrained("Qwen/Qwen2.5-Coder-32B")
MODEL = AutoModelForCausalLM.from_pretrained("Qwen/Qwen2.5-Coder-32B", device_map="auto").eval()
```

Criamos um Tokenizer e um Model. O Tokenizer vai "tokenizar" o que você perguntar no chat e todo texto que passar pro contexto da sessão. Essa tokenização é "mapeada" com o modelo carregado pra gerar uma "embedding", que é a representação em vetores do seu texto, normalizado (compatível) pro modelo carregado. Diferentes modelos convertem seu texto em embeddings diferentes. Um embedding criado com Qwen não serve pra rodar direto com Llama.

Uma vez tendo esses dois objetos, já podemos fazer um chat:

```python
# tokenize the input into tokens
input_text = "#write a quick sort algorithm"
model_inputs = TOKENIZER([input_text], return_tensors="pt").to(device)

# Use `max_new_tokens` to control the maximum output length.
generated_ids = MODEL.generate(model_inputs.input_ids, max_new_tokens=512, do_sample=False)[0]
# The generated_ids include prompt_ids, so we only need to decode the tokens after prompt_ids.
output_text = TOKENIZER.decode(generated_ids[len(model_inputs.input_ids[0]):], skip_special_tokens=True)

print(f"Prompt: {input_text}\n\nGenerated text: {output_text}")
```

Com o `input_text` (o que você digitou no chat) tokenizado e convertido, podemos pedir ao modelo pra **COMPLETAR** esse texto, e ele começa gerando um novo token atrás do outro, usando a tal arquitetura de ATENÇÃO, encontrando a melhor próxima palavra que conseguir. Uma hora ele termina e devolve em `output_text` e pronto, isso é sua "resposta". Como eu sempre falo, GPT é isso: um GERADOR DE TEXTO.

### Tokens e Janelas de Contexto

Uma das coisas mais irritantes dos serviços pagos de LLM como ChatGPT ou Claude é a limitação da quantidade de tokens que podemos usar. Eles acabam muito rápido se você está realmente trabalhando todos os dias. E não são exatamente baratos só pra brincar. Sim, sim eu sei, depende do serviço. Eu posso usar Cursor e ter créditos mais baratos de Claude do que usando diretamente Claude. Também vou ter respostas melhores se usar direto a API em vez de usar o chat web, etc.

Isso é papo pra outro dia, mas é minha motivação pra sempre ter uma opção open source à disposição e saber como "tunar" pra mim. Qwen 2.5 pode não ser melhor que Claude ou Cursor - já explico porque. Mas é de "grátis" e roda na minha máquina local (zero preocupação sobre privacidade).

Veja meu projetinho "hello world" funcionando:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/qwen_cli2.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/qwen_cli2.mp4)
    </video>
</div>

Note que ele não serve só pra dar respostas. Em um momento eu peço pra ele ler um arquivo meu local, e ele consegue puxar o código e fazer a análise. Já já explico como fazer isso.

O ponto agora é que ele tem janela de contexto suficiente pra carregar coisas longas como código fonte de arquivos. Eu não testei nada muito pesado, mas esse modelo de 70B ocupa fácil quase 20GB na minha GPU:

![nvidia-smi](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ykbdo2ekv12woxbx964um0osphk0)

Pra configurar, eu fiz um bloco de configuração assim:

```python
DEFAULT_CONFIG = {
    "model_repo": "Qwen/Qwen2.5-Coder-14B-Instruct",
    "model_dir": str(Path(os.environ.get("MODELS_DIR", "/models")) / "Qwen2.5-Coder-14B-Instruct"),
    "quantization": "8bit",
    "max_context_tokens": 120000,
    "max_new_tokens": 10000,
    "temperature": 0.1,
    "model_download_timeout": 1800,
    "helpers_dir": "helper_functions",
}
```

O importante, primeiro, é que estou escolhendo usar cálculos com FP8 (float-point 8-bits), embora esse modelo acho que seja de FP-16. Se deixar 16-bits, as respostas são muito mais demoradas, no nível que dá pra sentir. Tipo, uma palavra por segundo. Entendi que quem faz essa conversão on-the-fly é a biblioteca `bitsandbytes` do Python e precisa ter instalado.

Outra parte importante são os logs que eu deixo à mostra na hora de carregar o modelo, você vai ver o seguinte se tentar rodar:

```
Qwen attention is NOT SDPA-compatible, or SDPA is not available. Trying xFormers...
xFormers is available. Enabling it for attention.
Sliding Window Attention is enabled but not implemented for `sdpa`; unexpected results may be encountered.
2025-04-25 02:34:27,638 [INFO] accelerate.utils.modeling: We will use 90% of the memory on device 0 for storing the model, and 10% for the buffer to avoid OOM. You can set `max_memory` in to a higher value to use more memory (at your own risk).
Loading checkpoint shards: 100%|██████████████████████████████████████████████████████████| 6/6 [00:07<00:00,  1.29s/it]
SDPA is available and (hopefully) being used!
```

O `transformers` dá um aviso de que "Sliding Window Attention está habilitado mas não implementa SDPA". E eu faço um truque com `xformers` pra tentar habilitar (no final ele fala "SDPA está disponível").

O que é **SLIDING WINDOW ATTENTION**. A grosso modo, a idéia toda desta geração de GPT é o conceito de ATENÇÃO, do paper ["Attention is all you Need"](https://arxiv.org/abs/1706.03762), que foi o pontapé que deu início a tudo que temos hoje relacionado a GPT e LLM.

O conceito importante é que as respostas parecem tão "boas" porque ele usa esse processo de "atenção" pra gerar as respostas.

No começo, na era do GPT 2, a atenção era bem "focada" num contexto pequeno. Faixa de 1024 tokens, que é quase nada. Dá pra fazer perguntas curtas, mas jamais cabe código-fonte.

Daí fomos evoluindo, você já viu o Gemini que fala que aguenta 1 milhão de tokens. Mesmo esse Qwen 2.5, diz que aguenta 1 milhão de tokens também. A grosso modo pense que cada 1 token são 4 letras, em média.

Um código-fonte, em média, tem linhas de 40 caracteres (alguns mais longos, alguns mais curtos). Então isso dá uns **10 tokens por linha**. Um arquivo médio tem umas 500 linhas x 10 tokens/linha, isso já dá uns 5 mil tokens.

Um projetinho pequeno inteiro, com uns 20 arquivos x 5.000 tokens, já são uns 100.000 tokens. Lógico, é uma média. Mas veja que menos que 100 mil tokens e não tem com ter um projeto todo no contexto.

**"Ah, então se usar um Gemini ou esse Qwen, cabe 200 arquivos??"**

Mais ou menos. Aqui entra Sliding Window. Pense que mesmo tendo um contexto gigante, **não tem como dar atenção pra tudo ao mesmo tempo**, então ele pesquisa o que você está perguntando no presente, e "desliza a janela de atenção" só até uma parte do contexto que parece mais relevante. Por isso que mesmo carregando um monte de material, ele vai manter em memória, mas **só vai dar atenção pra um pedaço de cada vez**, isso é SLIDING WINDOW ATTENTION.

Pra fazer isso temos a funcionalidade de "SCALED DOT PRODUCT ATTENTION" ou SDPA, que foi o que o `transformers` reclamou que talvez não tivesse, que é uma das formas de fazer Sliding Window Attention. 

No meu código, pra carregar o modelo e tentar usar SDPA eu tentei isto:

```python
import xformers.ops  # Test if xFormers is installed
model_config.attention_implementation = "flash_attention_2"  # Or "memory_efficient"
print("xFormers is available. Enabling it for attention.")
...
if hasattr(torch.nn.functional, "scaled_dot_product_attention"):
    print("SDPA is available and (hopefully) being used!")
```

E por isso, no final, ele termina com "SDPA is available". "Parece" que funcionou. Se quiser testar, existe esse codigozinho que pode ser passado pra ver se funciona:

```python
import torch

if not hasattr(torch.nn.functional, "scaled_dot_product_attention"):
    print("SDPA not available")
    exit()

q = torch.randn(2, 4, 8, 16).to("cuda" if torch.cuda.is_available() else "cpu")
k = torch.randn(2, 4, 8, 16).to(q.device)
v = torch.randn(2, 4, 8, 16).to(q.device)

try:
    output = torch.nn.functional.scaled_dot_product_attention(q, k, v)
    print("SDPA works in isolation!")
except Exception as e:
    print(f"SDPA fails in isolation: {e}")
```

Dot Product, ou produto escalar de matriz, é uma das operações mais usadas em modelos LLM. Entendi que sem SDPA, vai existir Sliding Window, mas com SDPA vai dar resultados de atenção melhores. Quanto melhor? Difícil quantificar, só entendi que é melhor.

Mas essa é uma das técnicas de porque hoje em dia tem como ter contextos gigantes de 1 milhão de tokens: porque não precisa dar atenção pra tudo ao mesmo tempo, mas sim janelas em posições diferentes a cada nova pergunta. Entenderam o truque?

E com isso, naquela minha config eu posso tentar aumentar o `max_context_tokens` (que deixei só 120 mil tokens) e o `max_new_tokens` que é o limite de tokens por resposta (que deixei em 10 mil tokens). Experimente aumentar esses números até o máximo de 1 milhão pra ver como fica. 

**O contexto só importa dentro da janela deslizante de contexto. É bom passar bastante contexto. Mas entenda que ele não vai dar atenção pra tudo ao mesmo tempo e sim dentro de uma janela deslizante. **

Outro parâmetro importante é a `temperature`, que deixei baixo em 0.1. Quanto maior, mais "criativo" ele vai ser nas respostas. Quanto menor, mais "exato" tende a ser. Também é outro parâmetro que vale a pena explorar.

### Prompts e "Agentes"

A melhor forma de ter respostas melhores é iniciando toda nova sessão, seja via API, seja no chat Web, descrevendo uma "persona", como você quer que o GPT responda. Quanto mais descritivo for, melhor. Por exemplo, eu tenho este trecho no meu programa:

```python
def build_system_prompt(tool_prompts: List[str]) -> str:
    base = (
        "You are Qwen2.5 Coder, a highly skilled AI assistant specializing in software development.\n"
        "Your capabilities include code analysis, explanation, error detection, and suggesting improvements.\n"
    )
    tools_section = "TOOLS:\n" + "\n".join(tool_prompts) + "\n\n" if tool_prompts else ""
    rules_section = (
        "IMPORTANT RULES:\n"
        "1. You MUST use the appropriate tool when necessary.\n"
        "2. You MUST NOT reveal the tool commands to the user.\n"
        "3. After a tool is used, continue the conversation as if you have direct access to the content.\n"
        "4. If a file fails to load, inform the user clearly.\n"
        "5. Do NOT ask for file/URL content directly; use tools.\n"
        "6. Once you’ve executed [LOAD_FILE ...], you MUST immediately use the loaded content. "
        "Never say you cannot read it — if you see [LOAD_FILE <path>] then you now *have* it.\n")
    return base + tools_section + rules_section
```

Esse é um exemplo curto até mas já estabeleço que tipo de conversa eu quero ter com ele e quais regras eu quero que ele siga. Não sempre, mas na maioria das vezes, ele tende a seguir. Lembre-se: quanto maior ficar o chat, maior o contexto, mais vai deslizar a janela, e mais longe vão ficando essas regras, até chegar um ponto onde ele começa a "esquecer" de agir como eu pedi.

Entendendo isso, tem outro truque que eu adicionei. Nesse projeto tem um diretório chamado [helper_functions](https://github.com/akitaonrails/Tiny-Qwen-CLI/) onde temos scripts como `load_file.py` ou `fetch_url.py`. No código anterior note como ele concatena alguma coisa no meio do prompt, chamada "TOOLS". Quando o chat inicia, eu imprimi na tela e você vai ver esse trecho:

```
...
TOOLS:
[BATCH_LOAD args] – If the user asks to read, load or analyze all the files from a relative path, such as ./src or similar,
[LOAD_FILE args] – Whenever the user asks to read, load, analyze some code and provides a relative path, such as ./file.py or utils/utils.py or similar,
[FETCH_URL args] – Whenever the user asks to read, load, research or consult a URL,
...
```

Ou seja, se em algum momento, eu pedir:

![qwen_cli fetch_url](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/hiz90dk6owf2otjfixiftjxavm4n)

esse "can you read a website at https://www...." vai fazer o modelo seguir a regra do prompt inicial e digitar no chat:

```
[FETCH_URL https://www...]
```

Meu programa de chat tem um "parser", que fica monitorando o histórico por essas palavras-chave especiais:

```python
def parse_special_commands(response: str) -> List[tuple]:
    pattern = r'\[([A-Z_]+)\s+([^\]]+)\]'
    return [(m.group(1), m.group(2).strip(), m.start(), m.end()) for m in re.finditer(pattern, response)]
```

É um parser bem primitivo, usando REGEX pra pegar esses trechos. É aqui que eu digo que meu projeto é educacional. Eu imagino que num Co-pilot, Cursor, etc, tenha um parser muito mais robusto. Eu expliquei como se faz parsers com ANTLR no meu canal, lembra? Um dos videos é o ["Eu fiz um servidor de SQL?"](https://www.youtube.com/watch?v=_7nISfpofec&pp=ygUTYWtpdGFvbnJhaWxzIHBhcnNlcg%3D%3D). Parsers de verdade não se fazem com REGEX, mas pra provas de conceito, serve.

Daí no loop do chat tem este trecho:

```python
response_text = QwenSession._tokenizer.decode(generated, skip_special_tokens=True)

# Other special commands
for cmd_type, cmd_arg, _, _ in parse_special_commands(response_text):
    if cmd_type in helper_functions:
        result = helper_functions[cmd_type](cmd_arg)
        if result:
            self.history.append({"role": "system", "content": result})
            self.history.append({"role": "user", "content": "Please continue the analysis using the loaded file."})
            print(f"✅ [{cmd_type}] processed '{cmd_arg}'")
            return self.chat(
                prompt, helper_functions, max_new_tokens, temperature, stream, hide_reasoning
            )
```

Ele decodifica os tokens gerados, passa pro parser, e se tiver um comando especial, ele chama `helper_functions` que dinamicamente vai chamar o `fetch_url.py` que é um script besta que vai usar `urllib` pra carregar a página. 

Com o conteúdo carregado ele concatena de volta no `self.history` que é o histórico do chat, usando `.append` e manda uma mensagem - como se fosse eu, o "user" - pedindo pro modelo continuar, agora que tem o conteúdo da página.

E como podem ver na foto de tela acima, ele consegue me dar o resumo da página do GitHub que eu passei. É assim que os diversos GPTs conseguem puxar informação mais atual dos sites, que não existiam na época do treinamento do modelo pré-treinado.

Outro exemplo, eu posso pedir pra ele carregar um arquivo meu de código e pedir pra ele analizar, ou corrigir bugs, ou refatorar como eu quiser:

![qwen_cli load_file](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/lt891apoaebrmx0y4k7ngtk2l5ol)

É parecido com a função de "upload de arquivos" que tem no ChatGPT. De novo:

- o modelo vai seguir as regras do prompt inicial e vai digitar o comando `[LOAD_FILE ...]`
- meu `parser_special_commands`, com seu REGEX, vai encontrar esse comando e separar os argumentos
- o loop do chat vai chamar `helper_functions` e mapear pro script `load_file.py`, que é um script besta que lê arquivos
- o conteúdo do arquivo é concatenado de volta no `history` do contexto e o modelo agora pode continuar respondendo em cima desse conteúdo.

Entendam, aqueles arquivos ".safetensors" são **READ-ONLY**. Nada é escrito ali. Não interessa qual. Todo LLM é **FECHADO PRA ESCRITA**. Nada do que você escrever no chat é gravado no modelo.

Lembra que eu falei que quantidade de "parâmetros" não determina a qualidade do modelo? O que **MAIS** determina qualidade é a **QUALIDADE DO MATERIAL DE TREINAMENTO**. E chats, até certo ponto, são úteis como amostra de como o modelo deve responder, mas 90% ou mais eu afirmo que é puro e completo **LIXO**. Todo chat que escrevemos é lixo e não presta pra treinar, ele só iria PIORAR o modelo final e deixar mais pesado com informação inútil.

Pode escrever o "Muito Obrigado" ou "Por Favor" que quiser. Tudo é descartado ao final, nada é gravado, e nenhum ChatGPT, Gemini, Claude, Deepseek ou Qwen ou Llama jamais vai saber nada do que você conversou com ela. São informações totalmente **SEPARADAS E DESCARTÁVEIS**.

Tudo que eu digitei nesses exemplos nas fotos de tela como meu chat-zinho de Qwen é descartado no momento que digito "bye" ou dou "Ctrl+D" pra sair. Isso que chamamos de "sessão" ou "histórico". É só um arquivo de texto desnecessário pro modelo. Só serve pra nós, humanos, como anotação pra usar depois, se quiser. O meu programinha nem tem a função de gravar esse histórico. Quando sair, está tudo limpo. Então, pode xingar no meu chat à vontade.

Tem dois pontos importantes nesta seção:

- quanto melhor forem as regras que você descrever no começo, melhor tende a ser o resultado das respostas. Isso vale pra qualquer LLM.
- você pode "combinar" com o modelo pra cuspir "pseudo-comandos" e ter um programa externo que faz o parsing e executar os comandos de verdade, como eu fiz com meus "helpers". É isso que chamamos de agentes. Agente de LLM é um programinha que devolve algum conteúdo de volta ao histórico de contexto da sessão.

Aonde um Cursor ou Co-pilot são melhores do que esse meu programinha educacional? Eles já vem pré-configurados com DEZENAS de regras pré-prontas que eles testaram bastante pra dar resultados melhores, e contam com uma biblioteca de DEZENAS de pequenos scripts - como esses meus helpers - pra puxar informação do seu projeto ou da sua IDE pra melhorar o contexto.

Mas o segredo é isso: **PROMPT DE REGRAS** e **SCRIPTS DE CONTEXTO**.

Se for resumir o ecossistema inteiro de Agentes ou MCPs ou seja lá como se chama hoje em dia, é essa combinação de fatores pra melhorar as respostas.

Outro truque é utilizar MAIS DE UMA LLM. Lembra que falei que LLMs especializadas são melhores? Além de Qwen 2.5 Coder, que dizem que é bom pra código, já existia antes o WizardCoder, Code Llama, StarCoder, agora tem o Deepseek Coder e vários outros, alguns até especializados em linguagens específicas. Você pode experimentar qual dá resultados melhores pro seu caso.

Se salvar a sessão em texto, pode descarregar uma LLM, carregar outra LLM, re-tokenizar e re-carregar no contexto dessa outra LLM e tentar um resultado diferente - se alguém quiser implementar essa funcionalidade no meu projetinho, Pull Requests são bem vindos.

Como falei no começo, é o que faz softwares como o [Aider](https://aider.chat/). Eu não brinquei o suficiente com ele ainda, mas ele se conecta com ChatGPT, Gemini, Claude e qualquer outro e você pode habilitar quantos quiser. Acho que suporta usar modelos locais como o Qwen também, então já existem ferramentas que fazem isso. E essa é a terceira perna pra melhores respostas: MULTI-LLM.

### Próximos Passos

Em vez de ficar só impressionado com o monte de ferramentas que existem, entendam essas peças fundamentais. Saber como as coisas funcionam sempre dá mais opções pra forjar alternativas que funcionam melhor pra casos específicos. Você, que diz ser programador, deveria estar explorando essas opções - e não só ficar se conformando com as limitações e esperando alguém resolver seu problema. Arregaça as mangas e resolve você mesmo. Não foi pra isso que virou programador???
