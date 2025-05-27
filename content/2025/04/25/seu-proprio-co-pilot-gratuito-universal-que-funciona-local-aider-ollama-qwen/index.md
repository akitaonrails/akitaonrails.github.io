---
title: 'Seu Próprio Co-Pilot Gratuito Universal que funciona Local: AIDER-OLLAMA-QWEN'
date: '2025-04-25T13:40:00-03:00'
slug: seu-proprio-co-pilot-gratuito-universal-que-funciona-local-aider-ollama-qwen
tags:
- aider
- ollama
- qwen
- python
- docker
- llm
- sdpa
draft: false
---

No meu [post anterior](https://www.akitaonrails.com/2025/04/25/hello-world-de-llm-criando-seu-proprio-chat-de-i-a-que-roda-local) eu mostro como fazer um chat LLM do zero com capacidade pra carregar arquivos de código pra refatoração. Eu demonstro os princípios por trás de ferramentas como Co-Pilot, Cursor ou Windsurf. O resumo é simples:

- UM BOM PROMPT DE REGRAS
- SCRIPTS que rodam localmente e adicionam mais contexto na sessão do chat.



É basicamente "só" isso (claro, mesmo o princípio sendo simples, ainda dá bastante trabalho implementar mesmo). E eu não preciso fazer tudo do zero. Já existe uma alternativa open source que faz exatamente tudo isso, a ferramenta que ficou mais popular nos últimos meses pra desenvolvimento de software, o [**AIDER**](https://aider.chat/docs/install.html)

O que eu gosto no AIDER:

+ funciona com praticamente qualquer LLM, fechada ou aberta, graças ao uso do [**LiteLLM**](https://www.litellm.ai/) por baixo, que abstrai e organiza toda configuração como tamanho de janela de contexto, temperatura e outros parâmetros sabidos que funciona melhor em cada LLM.
+ é OPEN SOURCE, então além de gratuito você pode aprender mais lendo o código-fonte, como eu fiz.
+ não precisa de plugins especiais - e proprietários - pra instalar em cada IDE: ele tem recurso de "watch files". Então posso deixar aberto num painel do meu terminal e meu editor favorito no outro painel: o NeoVIM. Dá pra integrar com plugins, mas é opcional. Vai funcionar pra tudo, até pro Notepad, se você for masoquista.

Eu tentei um pouco da porcaria de "vibe coding" somente via interface web do ChatGPT, Gemini, Claude, e vou dizer que todos são uma porcaria. Pra fazer um projetinho que é simples, com não mais que uns 4 arquivos curtos ele deu MUITO TRABALHO. Alguns deles:

- não demora muito pra começar a misturar conteúdo de um arquivo em outro.
- erros que ele cometeu, eu expliquei que estava errado, ele corrigiu, mas logo em seguida repete de novo.
- ele não roda nada, então ele chuta muita coisa, como paths de arquivos, versões de bibliotecas
- não interessa que o contexto é grande e dá pra subir muitos arquivos pra contexto, é sliding window: ele não dá atenção pra tudo ao mesmo tempo. quanto mais arquivo de código você sobe, mais degrada a qualidade
- tem que escrever muito pra explicar o que se quer e, principalmente, porque ele errou e como corrigir. 
- os créditos são caros, acabam muito rápido, porque se desperdiça metade dos tokens só explicando os erros e subindo os mesmos arquivos mais de uma vez porque você percebe que ele já "esqueceu". Eu cheguei no limite do Claude, do Gemini, super rápido (eu pago o primeiro plano pago, não vou pagar o mais caro). Daí tem que esperar algumas horas pra voltar (péssimo).

Tudo isso alguém vai comentar _"Ah, mas pra mim funcionou."_ Foda-se, não perguntei. Eu disse que PRA MIM foi assim, só aceita. O importante é dizer que aquela história de "virtual employee" ou "substituir totalmente programador" ou "conseguir fazer um projeto inteiro sem saber programar nada" é **BALELA**, **HISTÓRIA DA CAROCHINHA**, **CONTO DE VIGARISTA**, **ILUSÃO DE AMADOR**, etc.

Todas as LLMs são **SÓ MAIS UMA FERRAMENTA** que alguém que realmente entende, como nós programadores, vamos saber usar muito melhor do que qualquer "empreendedor amador" jamais vai conseguir. E eu vou provar.

### Aider Básico

Instalar o Aider é fácil, só precisa ter Python >= 3.12 na sua máquina, coisa que todo Linux moderno tem. A documentação deles é muito boa, [recomendo ler](https://aider.chat/docs/install.html) pra saber o que ele recomenda pós-instalação. Tem muitas dicas.

```
python -m pip install aider-install
aider-install
```

O que ele não diz na documentação é que a primeira coisa pra fazer é baixar [este arquivo de exemplo](https://github.com/Aider-AI/aider/blob/main/aider/website/assets/sample.aider.conf.yml) e colocar em `$HOME/.aider.conf.yml`. Nele tem uma coisa importante que temos que mexer:

```yaml
...
## Enable/disable auto commit of LLM changes (default: True)
auto-commits: false
...
``` 

Recomendo que leiam esse arquivo, ele está todo comentado e pode ter opções que você queira desligar, mas esse é irritante, porque - por padrão - essa desgraça faz "COMMIT AUTOMÁTICO" no seu Git, toda vez que ele muda alguma coisa no seu código. Nem me dá chance de revisar. Vai na base do "CUNFIA IN NÓIS". Nem fu, desligado.

Esse é o tipo de coisa que um amador não faria, e até entendo. Amadores não sabem organizar commits de git de qualquer jeito, provavelmente as mensagens automáticas do Aider vão ser menos piores. Olha como fica:

![Aider Git commit](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/22ji8rp2bbw5lsxwbmpneh5clhcr)

Aviso pra júnior: esse é o tipo de coisa que se eu fosse avaliar, ia ganhar ponto negativo se eu visse sendo feito assim. Faça direito: re-cheque as mudanças e organize em commits de verdade. O Aider "diz" que fez refactor, mas nem sempre ele acerta, mas mesmo assim faz o commit, e aí sobe errado. Se for pra subir tudo automático, mesmo com erro, realmente, não preciso de você.

Mas estou me adiantando, depois de instalar o Aider, precisa configurar as API KEYS de cada serviço que você usa, seja da OpenAI, Claude ou outros. Quem usa ChatGPT no Linux já tem uma variável como `export OPENAI_API_KEY=sk-proj-........` configurado no `.bashrc` ou `.zshrc`.

Feito isso, dá pra escolher qual modelo usar:

```
# Change directory into your codebase
cd /to/your/project

# o3-mini
aider --model o3-mini

# o1-mini
aider --model o1-mini

# GPT-4o
aider --model gpt-4o

# List models available from OpenAI
aider --list-models openai/
```

E isso já vai abrir um chat interativo. Também dá pra, antes de abrir o chat, já mandar carregar arquivos locais assim:

```
aider README.md init.py utils.py ...
```

Ou, de dentro do chat, ele aceita [vários comandos](https://aider.chat/docs/usage/commands.html) que começam com slash "/", parecido com chat de IRC. Por exemplo:

```
/add helper.py
/copy # copia a última sugestão de código pro clipboard
/git # roda um comando de git local a partir do chat
/run # roda um comando do seu shell e adiciona o output no chat
/web # vai numa página web e puxa o conteúdo pro chat
```

Leia a documentação. Mas o modo mais interessante é o "watch-files". Basta estar no diretório do seu projeto e subir assim:

```
aider --watch-files
```

Ele usa a biblioteca [watchfiles](https://pypi.org/project/watchfiles/) de Python pra interceptar chamadas de IO nesse diretório e dar gatilho pra carregar sozinho seus arquivos, assim que você salva no seu editor favorito (por isso falei que não precisa de plugin extra nenhum se não quiser). Já aviso que essa lib não suporta dar watch em mounts de SMB ou NFS (sim, eu testei).

No seu editor, basta criar um comentário perto do código que quer que ele mexa, assim:

```
// can you refactor this return so it has more error checking? AI!
export const getCapitalizedLabel = (name: string): string => {
  return name
    .replace(/_/g, " ")
    .split(" ")
    .map((word: string) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ")
}
```

Coloque no comentário o que quer que ele faça, e termine com o gatilho "AI!". Aí no outro terminal que o Aider está carregado, ele vai perceber que o arquivo foi salvo:

```
>

Added src/utils/getCapitalizedLabel.ts to the chat
Processing your request...
...
```

E vai fazer sua "mágica" (que eu vou contar o segredo já já). Este é o exemplo do que ele fez (mesmos resultados tanto com o4-mini quanto Qwen2.5, mas é um exemplo bem trivial):

```js
export const getCapitalizedLabel = (name: string): string => {
  if (typeof name !== 'string') {
    throw new TypeError('Expected a string');
  }

  return name
    .replace(/_/g, " ")
    .split(" ")
    .map((word: string) => {
      if (word.length === 0) return word;
      return word.charAt(0).toUpperCase() + word.slice(1);
    })
    .join(" ");
}
```

Um editor gráfico como Visual Studio Code da vida, assim que o Aider mudar o arquivo, no editor ele recarrega e você já vê as mudanças. Num NeoVim, o autoread costuma carregar automático também, mas às vezes eu preciso dar o comando ":e" pra forçar recarregar, mas nada de mais também. E só com isso já temos um workflow de trabalho eficiente.

Meu editor favorito funciona igualzinho, sem plugin deixando pesado nem conflitando com nada. Se eu precisar fazer pair programming, chamo o Aider num outro terminal e pronto, basta escrever idéias em comentários, e ele manda sugestões. Como desliguei o maldito auto-commit, se eu não gostar, basta dar UNDO ou `git checkout` no arquivo e volta como tava antes.

Mais do que isso. Se eu notar que o modelo `o4-mini` não tá dando bons resultados, posso mudar pro `--model gemini` - que costuma ser melhor pra código do que o o4. Ou `--model claude-3-opus-20240229`. Aliás, falando em Claude, como falei antes [leia a fucking documentação](https://aider.chat/docs/llms/anthropic.html)

Fala na documentação que o Aider suporta "thinking tokens" do Sonnet 3.7. Existe um arquivo de configuração onde podemos fazer "fine-tuning" pra cada modelo, o `$HOME/.aider.model.settings.yml`onde podemos adicionar:

```yaml
- name: anthropic/claude-3-7-sonnet-20250219
  edit_format: diff
  weak_model_name: anthropic/claude-3-5-haiku-20241022
  use_repo_map: true
  examples_as_sys_msg: true
  use_temperature: false
  extra_params:
    extra_headers:
      anthropic-beta: prompt-caching-2024-07-31,pdfs-2024-09-25,output-128k-2025-02-19
    max_tokens: 64000
    thinking:
      type: enabled
      budget_tokens: 32000 # Adjust this number
  cache_control: true
  editor_model_name: anthropic/claude-3-7-sonnet-20250219
  editor_edit_format: editor-diff
``` 

### Reasoning

Thinking ou Reasoning como é chamado no marketing da maioria das LLMs comerciais é o pattern de "chain-of-thought", que é uma técnica de prompt onde você pede pra LLM não dar uma resposta, mas sim descrever "passo a passo" como ele chegaria na resposta, e depois repetir a pergunta mandando ele seguir esses passos e daí dando uma resposta.

Na prática tem várias formas de implementar algo parecido com isso. E uma delas é ser Multi Modelo. Especialmente com modelos open source, como DeepSeek-Coder ou Qwen2.5-Coder ou Llama3. Alguns modelos são melhores no reasoning - em explicar verbalmente o que tem que ser feito, mas são ruins em fazer o código em si. E alguns modelos não são bons em explicar as coisas em detalhes, mas foram treinados pra escrever bom código.

É possível usar isso a nosso favor e o Aider tem um recurso que eu acho muito foda - pra casos onde realmente precisa, porque é pesado - que é rodar em **modo arquiteto**, gerar o raciocíniio e depois mudar pra **modo código** em outro modelo, e usar esse raciocínio pra montar um código melhor.

Tem um [artigo inteiro](https://aider.chat/2024/09/26/architect.html) na documentação do Aider explicando isso, mas a motivação foi por causa do modelo OpenAI o1, que é justamente forte pra raciocinar uma explicação do que fazer, mas é ruim em realmente fazer o código. Então, vale a pena ouvir o o1 e deixar ele analisar o problema e descrever em forma de texto, e depois mudar pro Gemini Pro ou Exp e mandar ele escrever o código.

Na prática, basta subir o Aider primeiro em modo "Architect":

```
pip install -U aider-chat

# Change directory into a git repo
cd /to/your/git/repo

# Work with Claude 3.5 Sonnet as the Architect and Editor
export ANTHROPIC_API_KEY=your-key-goes-here
aider --sonnet --architect
```

E isso funciona com outros models:

```
# Work with OpenAI models, using gpt-4o as the Editor
export OPENAI_API_KEY=your-key-goes-here
aider --4o --architect
aider --o1-mini --architect
aider --o1-preview --architect
```

Como exemplo, configurando `OPENAI_API_KEY` e `GEMINI_API_KEY` posso subir o o4 como arquiteto e o Gemini como o coder:

```
❯ aider --watch-files --architect --editor-model gemini
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Using gpt-4o model with API key from environment.
Aider v0.82.3.dev55+g25a30393
Main model: gpt-4o with architect edit format
Editor model: gemini/gemini-2.5-pro-preview-03-25 with editor-diff edit format
Weak model: gpt-4o-mini
Git repo: .git with 184 files
Repo-map: using 4096 tokens, auto refresh
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
architect>
```

Veja no status do início que ele aceitou os dois. Agora é só codar do mesmo jeito que antes, mas usando os dois. Obviamente, assim você vai usar muito mais créditos! Fique esperto com isso! Tem **chances** de ter resultados melhores mas **certamente** vai gastar mais créditos, por isso use mais pra códigos mais complexos, onde só um modelo está sofrendo pra conseguir resolver.

Note que existem configurações e limites de tokens, e também note que ao final de cada resposta, o Aider dá uma estimativa de quanto está te custando. Eis primeiro a conta do arquiteto OpenAI o4:

```
...
This should make the function more concise and efficient.


Tokens: 4.4k sent, 246 received. Cost: $0.01 message, $0.01 session.
```

E eis a SEGUNDA conta do Coder Gemini 2.0 Flash:

```
...
Tokens: 1.9k sent, 136 received. Cost: $0.0037 message, $0.02 session.
Applied edit to src/utils/getCapitalizedLabel.ts
```

Gemini Free (gratuito) tem um "rate limit" (quantidade de requisições permitidas por minuto, super baixa, só 15 RPM, pra API é ridículo, o Aider bate nisso na primeira tentativa).

Não raras as vezes, você vai bater no limite do plano, e isso é um saco:

```
The API provider has rate limited you. Try again later or check your quotas.
Retrying in 4.0 seconds...
```

Daí não tem jeito, tem que ir no site [Google AI Studio]() configurar sua conta de cobrança, adicionar seu cartão e subir pra um plano pago um pouco melhor como o 2.0 Flash, que suporta 2.000 RPM e 4M TPM e o preço não é caro:

![Gemini 2.0 Flash](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ozbz5tvmpyla0huinqa6da2iwb1m)

Alguns dizem que hoje o Gemini 2.0 tem oferecido resultados de código similares ou superiores ao Claude Sonnet 3.7. Varia de caso a caso, não é nunca uma medida absoluta, mas na minha pequena experiência, ambos são muito bons e eu vejo ambos sendo superiores mesmo ao ChatGPT 4 ou o4. Mas a OpenAI, pra mim, tem mesmo sido melhor em respostas "verbais", então a estratégia de separar o papel de "arquiteto" pra OpenAi e de "coder" pra Gemini ou Claude, faz MUITO sentido.

No final, aquele código inicial que pedi pra refatorar, nessa combinação de arquiteto/editor ficou assim:

```js
export const getCapitalizedLabel = (name: string): string => {
  return name
    .replace(/_/g, ' ')
    .replace(/\b\w/g, char => char.toUpperCase());
}
```

Ok, eu não teria pensado nisso desta forma. 

### Não usando "Créditos de Tokens": OLLAMA

Agora vem a parte mais interessante pra nós, nerds mais hard-core, com máquinas mais parrudas (no mínimo uma RTX 3090, eu uso uma RTX 4090 - o importante é ter **24GB de VRAM**). Dá pra usar modelos menores, que cabem em menos VRAM, mas aí o resultado do código vai ser bem pior, então é melhor ficar no Gemini ou Claude mesmo.

Se tiver a máquina pra isso, com CUDA Toolkit já instalado, é hora da solução de gente grande: instalar Ollama. No meu Manjaro/Arch é assim:

```
yay -S ollama ollama_cuda
```

Não deixe de checar configuração de CUDA porque por default o Ollama vai rodar silenciosamente na sua CPU e vai ser tudo ABSURDAMENTE LENTO.

O Ollama funciona tanto como um servidor local http pra APIs, quanto como um cliente de chat interativo, como o meu qwen_cli do post anterior. Ele funciona numa lógica mais ou menos parecida com Docker. Pode ser configurado pra subir como automaticamente como serviço no seu sistema. Veja a [documentação no ArchWiki](https://wiki.archlinux.org/title/Ollama).

Eu prefiro subir manualmente num terminal, onde eu posso ver o log do que está acontecendo:

```
OLLAMA_FLASH_ATTENTION=1 OLLAMA_CONTEXT_LENGTH=8192 ollama serve
```

Tem várias configurações com variáveis de ambiente. Dá pra só configurar no seu `/etc/profile` ou `~/.zshrc` mas como estou testando, prefiro subir direto na linha de comando. Com isso teremos um servidor web. Pra funcionar com o Aider, novamente, só declarar onde achar ele no seu `/.zshrc`:

```
export OLLAMA_API_BASE=http://127.0.0.1:11434
```

Agora, precisamos baixar algum modelo, como meu preferido Qwen 2.5 Coder, que já usei no post anterior:

```
ollama pull qwen2.5-coder:32b
```

Note que estou explicitamente pedindo a versão 32B, mas você pode experimentar uma mais leve como a 7b. Cada modelo suportado pelo Ollama tem [uma página](https://ollama.com/library/qwen2.5-coder) onde descreve detalhes desse tipo:

![qwen 2.5 coder page](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/q76sz7qyqupk8jv3gm1igpk4q0i3)

Dependendo de qual benchmark sintético você "acreditar" vai ver comparações como esta:

![comparação](https://ollama.com/assets/library/qwen2.5-coder/bbf378d8-c80e-4ae3-98ab-90111dfbf3e7)

Na prática, Claude, ChatGPT, Gemini, realmente são já muito bons pra código. No mundo open-source são o Qwen 2.5 Coder, Deepseek-Coder-V2 (que ainda não funciona muito bem no Aider, tem que esperar atualizações). Então, se quiser tudo de grátis, o melhor mesmo por enquanto é o Qwen 2.5 Coder mesmo. E na minha experiência, tem funcionado muito bem. Mas é BEM pesado na versão 32B e as respostas são consideravelmente mais lentas que uma opção paga como Gemini. Então depende muito do seu caso.

Uma vez baixado o modelo, precisa configurar janela de contexto (por padrão é bem pequena, só 2K tokens), [a documentação avisa](https://aider.chat/docs/llms/ollama.html) isso e tem que editar o arquivo `$HOME/.aider.model.settings.yml` assim:

```yaml
- name: ollama/qwen2.5-coder:32b
  extra_params:
    num_ctx: 65536
```

O que a documentação **NÃO** explica e, por causa disso, eu gastei um tempão vasculhando o código-fonte a as Issues no GitHub é que pra subir modelos open source, precisa usar a opção `ollama_chat/` e não ollama como ele manda. Ou seja, a documentação diz:

```
aider --model ollama/qwen2.5-coder:32b
```

Mas o CERTO é fazer:

```
aider --model ollama_chat/qwen2.5-coder:32b
```

Se não, as respostas vão ser completamente aleatórias, fora de contexto. Preste atenção nisso. Mas sabendo disso, podemos até fazer o que falei antes: misturar modelos! Que tal subir o GPT o4 como arquiteto e deixar ele comandar o editor sendo o Qwen 2.5?

```
aider --watch-files --architect --editor-model ollama_chat/qwen2.5-coder:32
```

Sim, isso é possível. Agora você pode usar um modelo comercial que está mais acostumado, como Gemini ou Claude, tanto nos papéis de arquiteto como editor, e um modelo open source como Qwen 2.5 pra suporte, e pagar menos. Ou de uma vez só usar o Qwen 2.5 e não pagar **crédito nenhum** (só eletricidade, claro, vai consumir **+200W** da parede toda vez, mas são só alguns segundos por vez).

Na minha (pouca) experiência. O Gemini ainda dá códigos melhores que o Qwen, mas não quer dizer que o Qwen seja ruim, como eu disse, vai depender MUITO das suas instruções de prompt (quanto mais detalhado melhor). E falando em instruções, vamos pra parte final:

### O Segredo da Mágica: Prompts

Eu tiro sarro quando alguém fala em "prompt engineering", mas na real, a melhor forma de tirar o máximo de uma LLM é fazer o melhor prompt possível. Não quer dizer o "prompt mais longo". É qualidade e não quantidade.

Por isso tanto [Microsoft](https://github.com/microsoft/generative-ai-for-beginners) quanto [Google](https://www.kaggle.com/whitepaper-prompt-engineering) fizeram guias detalhados focaods em prompt. O deles compensa ler e estudar. O que não compensa é pagar cursos de gente aleatória falando "prompt engineering" como se entendesse alguma coisa.

O Aider suporta uma opção "--verbose", onde ele mostra exatamente o que está mandando pras LLMs. Vamos testar. Logo de cara ele já imprime isso no console:

```
❯ aider --watch-files --verbose
Config files search order, if no --config:
  - /tmp/smells/.aider.conf.yml
  - /home/akitaonrails/.aider.conf.yml (exists)
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Too soon to check version: 11.6 hours
Command Line Args:   --watch-files --verbose
Config File (/home/akitaonrails/.aider.conf.yml):
  max-chat-history-tokens:8192
  map-tokens:        4096
  auto-commits:      False
Defaults:
  --set-env:         []
  --api-key:         []
  --model-settings-file:.aider.model.settings.yml
  --model-metadata-file:.aider.model.metadata.json
  ...
  --encoding:        utf-8
  --line-endings:    platform
  --env-file:        /tmp/smells/.env

Option settings:
  - 35turbo: False
  - 4: False
  - 4_turbo: False
  ...
  - upgrade: False
  - user_input_color: #00cc00
  - verbose: True
  - verify_ssl: True
  - vim: False
  - voice_format: wav
  - voice_input_device: None
  - voice_language: en
  - watch_files: True
  - weak_model: None
  - yes_always: None
  ...
```

O que ferramentas como Aider, Cursor, Co-Pilot e outros fazem é ter parâmetros otimizados de todos os LLMs já hard-coded na ferramenta, como nesse caso onde detecta pra usar o4 e já configura com melhores parâmetros (que você ainda pode tunar colocando em `$HOME/.aider.model.settings.yml`).

Mas quando você manda a primeira pergunta que fica interessante, olha isso:

![Aiden Verbose 1](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/rb4hxk4cn181fkkf841snl7ygfja)

_"Aja como um desenvolvedor de software. Sempre use boas práticas quando codar. Respeite e use convenções, bibliotecas, etc que já estão presentes nesta base de código. Seja diligente e sem preguiça! Você NUNCA vai deixar comentários descrevendo código sem implementar! Você sempre vai IMPLEMENTAR COMPLETAMENTE o código necessário! ..."_

Lembra o que eu falei no começo do post: PROMPTS DE REGRAS. Esse SYSTEM no começo é um "role". Você como usuário é o "USER" e o modelo é o "ASSISTANT", inclusive esse prompt de SYSTEM é gigante, ele vasculha meu projeto e já explica pro modelo a estrutura do meu projeto e inclusive resume alguns arquivos (mostrando só a interface dos métodos, por exemplo, pra dar contexto mas não subir código inteiro).

Tem trechos assim:

```
...
SYSTEM # *SEARCH/REPLACE block* Rules:
SYSTEM
SYSTEM Every *SEARCH/REPLACE block* must use this format:
SYSTEM 1. The *FULL* file path alone on a line, verbatim. No bold asterisks, no quotes around it, no escaping of characters, etc.
SYSTEM 2. The opening fence and code language, eg: ```python
SYSTEM 3. The start of search block: <<<<<<< SEARCH
SYSTEM 4. A contiguous chunk of lines to search for in the existing source code
SYSTEM 5. The dividing line: =======
SYSTEM 6. The lines to replace into the source code
SYSTEM 7. The end of the replace block: >>>>>>> REPLACE
SYSTEM 8. The closing fence: ```
SYSTEM
SYSTEM Use the *FULL* file path, as shown to you by the user.
...
```

Inclusive, se já usou Co-Pilot, sabe que dá pra colocar as convenções do seu projeto em `CONVENTIONS.MD`. O Aider também vai carregar esse arquivo no prompt. Então coisas como "use 4 espaço em vez de tabs, coloque a abertura de {  no final da linha e não começando uma linha nova, etc", tudo isso fica nesse arquivo e tanto Co-Pilot como Aider adicionam essas regras no PROMPT. Não é nenhum outro mecanismo, é PROMPT.

Daí, como USER, ele começa a subir resumo dos meus arquivos no prompt:

```
...
USER Here are summaries of some files present in my git repository.
USER Do not propose changes to these files, treat them as *read-only*.
USER If you need to edit any of these files, ask me to *add them to the chat* first.
USER
USER data_scraper/main.py:
USER ⋮
USER │def main(args: Arguments):
USER ⋮
USER
USER data_scraper/src/arguments.py:
USER ⋮
USER │@dataclass(frozen=True)
USER │class Arguments:
USER │    content_path: Path
USER ⋮
USER │    @staticmethod
USER │    def get() -> 'Arguments':
USER ⋮
...
```

Quando termina essa parte, o Aider pede confirmação do Modelo:

```
...
ASSISTANT Ok, I won't try and edit those files without asking first.
...
```

E é assim que funciona um "I.A.  pra software", com uma tonelada de prompts de instruções e um programa cliente que fica fazendo parse das respostas e ativa comandos de verdade que rodam no seu sistema (agentes), como comandos de git ou lint. O resultado desses comandos, o texto, é concatenado no chat pra adicionar ao contexto e daí pede pro modelo/assistente continuar analisando desse ponto em diante.

Um modelo sozinho não faz nada. Quem faz é a ferramenta que carrega o modelo, no caso o Aider, ou o Co-Pilot, ou o Cursor. O programa vem pré-carregado com vários perfis/personas/roles pré-escritos pra adicionar prompts ao modelo. No código-fonte do Aider, temos este exemplo de [architect_prompts.py](https://github.com/Aider-AI/aider/blob/main/aider/coders/architect_prompts.py)

![architect role](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/nlzkq16pcfjwwow5tbibocr1oa1n)

Olha só, na primeira variável `main_system` está aquele primeiro prompt que vimos no começo desta seção. Tem vários outros perfis pré-programados que é bom entender a diferença. Cada modelo funciona melhor com determinados tipos de instrução, com diferentes limitações.

Neste outro código [commands.py](https://github.com/Aider-AI/aider/blob/main/aider/commands.py) é onde temos declarado como o Aider consegue fazer coisas como `git commit` direto no seu projeto ou rodar o linter da sua linguagem:

![commands](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/bdt1a5dqj28bvzhqximdi8j2gx2g)

Nada disso é "mágica", é tudo pré-programado e ele - por segurança - só deve conseguir fazer comandos limitados e bem checados. Não queremos comandos que façam coisa demais fora do diretório do projeto (aliás, NUNCA, fora do diretório do projeto). Nem deveria poder rodar muitos executáveis. Nunca se sabe que bugs de segurança podem acontecer quando se roda comandos cegamente.

Se você é de cyber-segurança, é aqui que deveria auditar. Mas essa é a vantagem, o Aider sendo open source, é auditável. Ferramentas proprietárias e fechadas, não. É na base do "CUNFIA NO PAI".

Teste o [Aider](https://aider.chat/docs/install.html) hoje e leia todo esse site de documentação. É curto e tem dicas importantes que podem ajudar casos especiais.

![Aider](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/0zeis5fjnkuf2qkmwy7pm6vc62gi)

### OpenRouter

Como já devem ter percebido, o ideal é testar as várias LLMs comerciais porque elas evoluem e cada uma tem pontos fortes e fracos. Mas ficar pagando crédito em cada uma é um saco.

Pra isso existe o [OpenRouter](https://openrouter.ai/) onde você tem uma conta só, uma `OPEN_ROUTER_API_KEY` só e paga num lugar só ele distribui os créditos pra cada provider como OpenAI ou Claude à medida que você usa. Simplifica o gerenciamento dos seus custos de API, vale muito a pena e, claro, o Aider também sabe usar ele:

```
aider --model openrouter/openai/gpt-4o
```

Novamente, leiam [a documentação](https://aider.chat/docs/llms/openrouter.html).


Agora, um **ANTI-PATTERN**. Eu pedi ao Aider, usando o modelo `openrouter/google/gemini-2.5-pro-preview-03-25`, que teoricamente é a melhor das melhores do momento, pra gerar um arquivo de testes unitários pro qwen_cli.py, do projetinho que eu soltei no GitHub no post de ontem.

Ele falhou miseravelmente. Criou um arquivo de testes, de quase 800 linhas, socado de mocks pra tudo que é canto, testando coisa que não precisa, complicando demais. Tudo bem. Eu tento rodar e solta erros.

Uma funcionalidade legal do Aider é poder rodar de dentro do chat com `/run python -m unittest ...` e ele oferece pra já jogar os erros dentro do chat. Eu peço pro Gemini consertar. Aí ele sai modificando o arquivo de testes e o arquivo do meu código. Mando `/run` de novo, mais erros. E eu fiz isso umas 4x. Ele sai "consertando" código que não precisa, e testes unitários simples (que era só um pequeno typo, só ajustar 1 número), ele larga pra trás. Eu descrevo no prompt _"você está mexendo onde não precisa e não consertando coisa trivial, como esse númerozinho"_ mando `/run`, e ele insiste em ignorar e sai mexendo em outros lugares.

Resumo:

![OpenRouter Credits](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/q4fiux9vj0d5l6e8p4nmku4rcjma)

Gastou quase 3 doletas e não resolveu o problema. Vantagem da OpenRouter é que fica tudo centralizado num lugar só. Ele pagou o Google pelo uso do Gemini e desconta dos meus créditos. Tinha pré-carregado com 100 créditos (mais ou menos 100 dólares). E em 30 minutos já foi embora 3 créditos. Faça as contas.

**Melhor prática:** o melhor é abrir o código do qwen_cli.py, por exemplo, no meu NeoVIM ou qualquer editor e colocar um comentário só em cima de um único método:

```python
...
# this method is used to just load a config.json file, create a single unit test and add to test_qwen_cli.py, AI!
def load_config
  ...
```

Daí ele faz somente **UM** teste unitário por vez, rodamos com `/run` e se passar e o código parecer limpo, seguimos pro próximo. Fazer um método de cada vez é muito mais garantido do que mandar _"faz teste pra TUDO de uma só vez."_ Aí é garantia que vamos gastar créditos à toa.

Além disso, um método por vez, modelos open source como Qwen 2.5 vão fazer bem e você roda local sem gastar créditos.


### Conclusão

Por enquanto, vou adotar o Aider. Agora eu entendo porque ele ficou tão popular este ano. É um projetinho bem feito, aberto, que eu posso explorar, tentar melhorar e aprender mais. Ao mesmo tempo facilita o uso de LLMs comercias e abre opções pra eu usar modelos open source na minha própria máquina, dando melhor uso ao meu RTX 4090.

Programador ruim é quando alguém fala que teve trabalho no ChatGPT e ele fica dando resposta enlatada como "já testou Claude, já testou Manus" ou então "ah, se tivesse usador Cursor seria melhor". Pára de ser esse NPC, é cansativo e demonstra absoluta PREGUIÇA.

Programador BOM é quando passa por uma jornada como a que acabei de descrever neste post: aprende os pontos fortes, os pontos fracos, como CONTROLAR, como SUBVERTER, como criar CONTINGÊNCIAS e, no final, sai com uma solução MELHOR do que de todo mundo.

É pra isso que virei programador, não pra ser outdoor grátis repetindo propaganda do Sam Altman.
