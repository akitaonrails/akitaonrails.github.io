---
title: "Vibe Code: Fiz um Editor de Markdown do zero com Claude Code (FrankMD) PARTE 1"
slug: "vibe-code-fiz-um-editor-de-markdown-do-zero-com-claude-code-frankmd-part-1"
date: 2026-02-01T10:40:43-0300
draft: false
tags:
- vibecode
- omarchy
- codemirror
- hugo
- obsidian
---


Nos últimos [dois](https://akitaonrails.com/2026/01/28/vibe-code-eu-fiz-um-appzinho-100-com-glm-4-7-tv-clipboard/) [posts](https://akitaonrails.com/2026/01/29/vibe-code-qual-llm-%c3%a9-a-melhor-vamos-falar-a-real/) eu só quis mesmo maltratar as LLMs pra mostrar a dificuldade que é fazer algo simples do zero, quem dirá *"fazer um GTA 6 do zero"*, como alguns idiotas acreditam.

Eu falo isso faz anos: eu GOSTO das LLMs, uso bastante desde que foram lançadas e nunca tive problemas com elas. Meu problema é só balizar as expectativas IRREAIS dos "normies", não-programadores: nunca vai sair um app como este com poucos prompts e sem saber exatamente os componentes e técnicas pra usar por baixo.

Desta vez, decidi resolver outro probleminha que tava no meu todo-list faz tempo: ter um web app de anotações self-hosted (pra colocar no meu [home-server](/tags/home-server). Ao longo dos anos, já usei de tudo: Evernote, Notion, Obsidian, entre outros, mas nenhum deles realmente me agrada. Então, por que não fazer o meu próprio exatamente como eu quero?

Vou dividir este tema em 2 artigos: neste primeiro, vou falar exclusivamente sobre o meu aplicativo; [no segundo](/2026/02/01/vibe-code-fiz-um-editor-de-markdown-do-zero-com-claude-code-frankmd-parte-2/), vou falar sobre o processo de vibe codar com o Claude. Spoilers: levou 3 dias inteiros (aproximadamente **30 horas**). 137 pull requests! Aguardem o post-mortem.

## O Problema

No geral, é só frescura minha mesmo. Guardar anotações não é pra ser complicado: cria um diretório aí na sua máquina, abre o LazyVim, o VSCode ou qualquer outro, e acabou: edita os Markdown em código puro e seja feliz.

Enfim, recentemente estava usando apenas o Obsidian num diretório compartilhado no meu Dropbox. Assim, eu poderia acessar do meu celular, se precisasse. Mas é um saco porque se eu estiver em outro PC, preciso ter o Obsidian ou outro editor instalado. Se tiver plugins, também preciso instalar.

![obsidian](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_11-43-09.jpg)

Na prática, qualquer outro editor de textos serviria: são só arquivos de texto, mas a inconsistência de ter algo diferente em cada lugar e desconfigurado me desmotiva a escrever.

Em particular, estava usando Obsidian e, depois, LazyVim pra editar os posts do meu blog, que também são em Markdown. E aqui tenho um conjunto maior de problemas:

- tem path específico e frontMatter do Hugo; tomar cuidado com o título pra gerar o slug correto, etc.
- tem imagens/screenshots que fico manualmente subindo no S3, pegando a URL e colando no post
- evito usar tabelas porque é um saco "desenhar" tabelas direto em Markdown
- fico com abas de Google Images, youtube, etc aberta pra poder ficar pegando links, alt-tab, e colando
- não tem um bom preview, então eu deixo passar muito errinho (url de imagem duplicada, por exemplo)
- não tem um bom corretor ortográfico, então passa muito errinho que depois tenho que ficar corrigindo

Eu queria resolver esses problemas tudo num lugar só: um editor bonito como o Obsidian, que resolvesse todos esses inconvenientes e me deixasse só focar no meu texto.

## FrankMD

Frank Rosenblatt foi o criador do Perceptron em 1957, o que deu origem às redes neurais modernas. Como eu fiz este editor totalmente com IA, resolvi homenagear o Frank.

Por isso, nomeei de Frank Markdown ou Frank Editor (fed). Este editor tem todo o básico que você esperaria em qualquer editor:

- syntax highlighting
- HTML preview
- facilitadores pra formatar markdown (Ctrl-B pra bold, por exemplo)
- customizar família e tamanho de fontes

Mas aí eu fui adicionando algumas coisas específicas do meu gosto pessoal e/ou que facilitariam minha vida pra editar os posts do meu blog. Vamos lá.

### Inserção de Imagens

Esta é uma parte importante pra mim. Quando faço posts sobre código, sempre fico tirando fotos de tela do meu terminal ou do editor pra ilustrar. O processo é um print screen que manda pra `~/Pictures/Screenhots`. Eu abro o Nautilus (estou no Linux) e executo um scriptzinho que fiz pra subir essa imagem num bucket no meu AWS S3. Copio o link gerado e adiciono ao meu post.

É "chatinho" toda vez fazer assim. Além do mais, às vezes eu gostaria de redimensionar a imagem pra ficar mais otimizada. Mas isso significa ir ao terminal e rodar `magick screenshot.png -resize 50%`, o que é mais um passo manual.

Então decidi fazer um dialog-box com várias opções pra isso.

![image dialog](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-03-02.jpg)

Por padrão, posso configurar um diretório principal de imagens no meu PC e ele vai exibir um grid limitado a 10 dos mais recentes. Ou posso filtrar por nome. Tem opção pra linkar diretamente (caso eu queira subir a imagem junto com o html) ou servir do S3 e ele vai copiar o link gerado automaticamente (que é o que prefiro).

Mesma coisa pra imagens na Web (Google, Pinterest), onde posso escolher fazer download, redimensionar e subir no S3:

![bing images example](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-06-07.jpg)

E o link vai ser no formato esperado `...amazonaws.com/frankmd/...jpg`. Tudo bonito, fácil e prático! Pra mim, isso ajuda muito!

É um extra, já que não poderia deixar de integrar uma IA; a última aba é pro [Nano Banana](https://gemini.google/br/overview/image-generation/?hl=pt-BR):

![nano banana generator](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-10-24.jpg)

Nano Banana é bem impressionante mesmo. olha o que esse prompt gerou:

![nano banana generated image](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/ai_1769965759787.png)

Mais importante ainda: posso ver o preview imediatamente (ctrl-shift-v) pra saber se inseri a imagem correta (coisa que eu errava muito editando pelo NeoVim, sem ver):

![real time preview](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-13-29.jpg)

Pra mim, estes assistentes de inserção de imagem são os que vão me ajudar mais pra editar meus posts no blog.

### Facilitadores de Markdown

Mais simples que uma imagem é embedar um player de vídeo. Posso ou passar um link qualquer com um arquivo .mp4 da vida, ou posso diretamente pesquisar no YouTube e embedar corretamente:

![youtube searching](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-12-34.jpg)

Ele vai inserir o HTML correto, `<embed ...`, com a URL e o título corretos.

Também fiz um jeito fácil de adicionar e editar tabelas:

![spreadsheet editor](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-28-00.jpg)

E vai gerar o Markdown direitinho. Nunca mais preciso ficar editando essa porcaria na mão pra reajustar colunas ou linhas.

```markdown
| Cabeçalho 1 | Cabeçalho 2 |
| ----------- | ----------- |
| Linguagem   | Nota        |
| Ruby        | 10          |
| JS          | 5           |
| Rust        | 6 😂        |
```

Mas se quiser fazer manualmente, também tem como:

![code editor](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-28-40.jpg)

Isso eu coloquei mais porque ficaria estranho omitir, mas, em geral, prefiro escrever blocos de código manualmente mesmo. Mas tá aí pra quem quiser um modo visual.

Daí, claro, tinha que ter um jeito fácil de editar Emojis :laughing: (ctrl-shift-e):

![emoji panel](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-30-19.jpg)

Mas o que ninguém esperaria é que eu também oferecesse suporte a **Emoticons**!!
☆:.｡.o(≧▽≦)o.｡.:*☆

![emoticon panel](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-30-40.jpg)

### Customização

Falando em Emoticons, me lembra que eu quis fazer este editor ser infinitamente customizável. Por exemplo, claro que adicionei internacionalização e tem japonês!!

![japanese locale](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-34-30.jpg)

E mais outras línguas também; deem uma fuçada depois. Tem português também!

> "Qual a melhor fonte pra programação?"

Sei lá! Por isso adicionei várias pra escolher:

![fonts](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_15-22-35.jpg)

Como uso [Omarchy](/tags/omarchy) então também queria que meu editor tivesse suporte a exatamente os mesmos temas:

![temas](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-37-05.jpg)

No [README](https://github.com/akitaonrails/FrankMD/blob/master/README.md) tem documentado tudo o que dá pra customizar. Dá pra customizar várias coisas via variável e ambiente e também via um arquivo `.fed`, criado automaticamente no diretório onde se abre este editor. Tem bastante coisa, então recomendo fuçar.

### Foco no Texto

Obviamente eu incluí um *"Typewriter Mode"* que mantém meu cursor mais perto do meio da tela e centraliza o editor e, ao mesmo tempo, esconde todas as distrações.

![typewriter mode](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-17-37.jpg)

Eu normalmente prefiro TUIs, mas tenho que admitir que usar um navegador tem a vantagem de me dar acesso a extensões. A mais útil sem dúvida é [Grammarly](https://app.grammarly.com/), pra qualquer língua:

[![grammarly](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-20-04.jpg)](https://app.grammarly.com/)

Mas, além disso, eu adicionei um botão de "IA" no toolbar (que é configurável via ENVs e um arquivo de configuração — leia o [README](https://github.com/akitaonrails/FrankMD/blob/master/README.md)). E ele faz isto:

![AI grammar check](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-22-28.jpg)

Manda pro seu LLM de preferência (Ollama local, OpenAI, Anthropic, OpenRouter, etc.) com um prompt pra não reescrever seu texto, somente checar gramática, ortografia e erros desse tipo. Daí eu devolvo uma interface de "diff" pra comparar e aceitar, editar ou cancelar.

Eu acho que o Grammarly sozinho já é suficiente, mas não custava nada fazer esse, então fiz.

### Hugo Blogging

Este blog é feito com Hextra/Hugo. Por isso, queria já embutir um jeito fácil de criar novos artigos no Hugo. Isso começa já na opção de criar um novo documento:

![new hugo note](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-39-53.jpg)

E ele já cria com o frontMatter, geração automática de slugs, subdiretórios timestamped e tudo mais:

![hugo frontmatter](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_14-38-55.jpg)

Como falei, este editor foi feito principalmente pra facilitar o meu workflow.

## Self-deploy vs CLI

Originalmente pensei neste projeto pra ser um Notion-light ou algo assim. Um editor web que fizesse deploy no meu home server e servisse apenas como organizador, um lugar pra colocar anotações maiores do que um post-it (tipo histórico de configurações do meu Linux, passo a passo de comandos, etc.).

Mas enquanto ia construindo o app, mais e mais ele foi ficando maior e mais parecido mesmo com um desktop app. Mas aí já era tarde demais. Eu queria usar Ruby on Rails 8 (pra me desenferrujar e porque eu gosto). Mas só na metade pensei que deveria ter feito em Node, porque agora não posso mais embutir num app do Electron.

Tudo bem, a ideia é ser um editor de Markdown pra programadores. Todo programador tem Docker. Então encapsulei numa funçãozinho de shell e posso só chegar em qualquer diretório no meu Linux digitar:

```bash
cd ~/Projects/akitaonrails-hugo
fed .
```

Leia o [README](https://github.com/akitaonrails/FrankMD/blob/master/README.md#2-add-the-fed-function) do projeto para saber como adicionar ao seu `.bashrc`. E fazendo assim, vai funcionar no meu Omarchy igualzinho a qualquer outro app nativo:

![omarchy web app](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_15-16-29.jpg)

Na realidade, vou usar ambos os jeitos: como se fosse um app nativo. E como self-hosted, pra organizar um lugar central com minhas anotações — que vai ser diferente de onde organizo meus posts de blog. Então tem múltiplas utilidades mesmo.

## Conclusão

Eu resumi as funcionalidades; há várias pequenas coisinhas que vocês vão descobrir à medida que começarem a usá-las. Tudo é clicável; se clicar no título do app, tem um About:

![about](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_15-21-03.jpg)

Botão direito em cima do texto selecionado tem um sub-menu de formatação; Ctrl-I funciona pra itálico; `Ctrl-H` tem "find and replace" básico; tem um monte de combinações de teclado pra acessar as coisas.

Ah é, nem falei que tem como pesquisar rapidamente arquivos por nome ou por conteúdo usando `Ctrl-P` e `Ctrl-Shift-F`:

![search filename](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_15-24-36.jpg)

![search file content](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-01_15-25-59.jpg)

Pra garantir que tudo está funcionando, este artigo aqui já foi escrito inteiramente com o meu novo editor. E diria que, se não está perfeito (pra mim), está nos 99%. Fiquem à vontade pra abrir Issues com bugs ou features que fariam sentido — lembrando: a ideia não é substituir o VSCode e ter TUDO. Eu preciso que tenha só o SUFICIENTE.

Considerando que me custou **3 dias de trabalho** e que não escrevi nenhuma linha de código, o resultado é impressionante. Sim, editores de texto são aplicativos muito bem documentados e com vasto material de treinamento — por isso, o Claude conseguiu fazer sem problemas. Não se impressionem demais. Mas isso dito, sim, eu queria um editor customizado pro meu uso pessoal, que fosse bonito de usar, e ele conseguiu entregar, então estou satisfeito.

Não deixem de ver a [PARTE 2](/2026/02/01/vibe-code-fiz-um-editor-de-markdown-do-zero-com-claude-code-frankmd-parte-2/) pros detalhes de como foi fazer isso.

