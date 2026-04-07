---
title: Omarchy 2.0 - Básico de LazyVim
date: "2025-09-12T15:00:00-03:00"
slug: omarchy-2-0-basico-de-lazyvim
tags:
  - omarchy
  - neovim
  - lazyvim
  - primeagen
  - taq
draft: false
translationKey: omarchy-lazyvim-basics
---

Droga, eu falei que o post anterior seria o último da série de [Omarchy](/tags/omarchy), mas achei que a oportunidade é boa pra evangelizar um pouco de Vim também. Já deixei a recomendação pra seguir o canal do [@Taq](https://www.youtube.com/@EustaquioRangel), onde ele explica muito mais a fundo como o NeoVim funciona. Também existe o [tutorial "vim-be-good" do Primeagen](https://github.com/ThePrimeagen/vim-be-good). Esse segundo, em particular, é um tutorial interativo dentro do próprio NeoVim, pra praticar a navegação - que muitos podem achar difícil no começo.

Vou fazer somente este um artigo sobre isso e não pretendo cobrir mais do que a ponta do Iceberg. A idéia é servir pra quem está vindo de outros editores como Sublime Text ou VS Code e não consegue começar a navegar ou até mesmo quitar do Vim kkk 🤣.

### Comandos Iniciais

Como falei no [post anterior sobre LazyVim](https://akitaonrails.com/2025/09/07/omarchy-2-0-lazyvim-lazyextras/), vou assumir que já entendeu pelo menos como instalar suporte à sua linguagem com **LazyExtras** e já aprendeu a versionar usando [**Mise**](https://akitaonrails.com/2025/09/07/omarchy-2-0-mise-pra-organizar-ambientes-de-desenvolvimento/).

Sem nem entrar no LazyVim, a primeira coisa a saber é que ele instala todas as configurações relevantes no diretório `~/.config/nvim`. Normalmente não precisa mexer nada lá. Deixa arquivos como `lazyvim.json` sem mexer. Notem que ele faz a mesma coisa quem um NPM da vida: tem um arquivo `lazy-lock.json` que declara a versão/commit de cada plugin instalado. O Lazyvim faz algo parecido com um `npm install` da vida. Só curiosidade pra você saber como ele se organiza.

Se precisar customizar algo, normalmente vai ser no diretório `~/.config/nvim/lua/config`. Foi lá onde eu adicionei suporte a Mise, por exemplo:

```bash
~/.config/nvim
❯ cat lua/config/mise.lua
-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
```

Vão ser sempre scripts escritos em Lua. E nem precisa saber Lua a fundo. De bater o olho é uma linguagem muito simples, não muito diferente de um Python ou Javascript e qualquer programador deve ser capaz de ler qualquer trecho sem nenhum problema. Além disso, na maioria dos casos você vai copiar configurações que tirou da documentação, wiki ou chatgpt mesmo, então é só saber que as coisas vão nesse local.

![primeiros passos](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912110425_screenshot-2025-09-12_11-04-07.png)

Entenda que NeoVim tem o conceito de tecla "**Leader**", é uma tecla que precede hotkeys pra outros comandos (também tem **localleader** que é barra invertida **\\**). Isso é configurável mas no LazyVim o Leader é a tecla **"Espaço/Space"**. Em muita documentação vamos ver falando _"apertem Leader-w"_, que significa **Espaço+w** e agora você sabe o que isso significa.

Pra abrir um arquivo tem pelo menos 3 formas diferentes, 2 delas mostradas na foto acima:

> **Space+E** abre o **NeoTree** que é esse sidebar na esquerda que se parece com o Windows Explorer. Dá pra navegar com teclado ou com mouse mesmo. Ache seu arquivo e pressione "Enter" pra abrir, daí "Space+E" de novo pra esconder o sidebar. Se quiser saber como criar um novo arquivo, um novo sub-diretório, renomear e tals, digite **?** (tecla de interrogação) pra ver esta ajuda:

![NeoTree](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912142438_neotree.gif)

A terceira forma é manualmente com o comando **:e** seguida do nome do arquivo no diretório local. Tem auto-complete também, esse é o jeito mais rápido, se souber o que está procurando.

Sempre que quiser cancelar qualquer coisa ou fechar "floating windows" (pop-ups, dialog boxes). Só apertar "Esc". Esc é fundamental no NeoVim.

Aberto um arquivo, ele fica no **Buffer**. Pense em Buffer como "Abas Abertas" no seu VS Code. Pra navegar por Buffer (tipo alt+tab entre seus arquivos já abertos) é simples:

* **]+b** pra próxima "aba" (próximo Buffer)
* **\[+b** Buffer anterior
* **Space+bd** pra "fechar a aba" (fechar o Buffer)
* **Space+bo** pra ficar onde está e fechar os outros buffers

Abra quantos arquivos quiser. Se um deles for um daqueles logs enormes que abriu por acidente, `Space+bd` pra fechar e pronto.

Falando em fechar, **como que sai do NeoVim?** Tem vários jeitos:

* **Space+q**
* **:q**
* **:q!**

A diferença: o primeiro é o jeito customizado no LazyVim. O Segundo é o jeito padrão usando o recurso de "comandos" que começa sempre com "dois pontos". E o terceiro é se você modificou algo no arquivo mas cancelar, sair sem salvar nada, por isso a exclamação.

Normalmente eu uso **:wq** que significa "write" e "quit". Então ele primeiro salva as mudanças no arquivo e depois já quita do programa. É útil quando estou só editando um arquivo de configuração rápido.

### Navegação Básica

Agora tenho um arquivo aberto. Como navegar por ele? Primeiro, como ir até o fim do arquivo e depois voltar pro começo do arquivo? É uma coisa que uso bastante, só digitar **Shift+g** pra ir pro fim do arquivo e depois **gg** pra voltar pro começo. Simples assim.

![home-end](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912143147_home-end.gif)

Agora vamos aprender vários comandos de uma só vez:

* Digite **v**. Isso inicia o **"modo de visualização"** que, na prática, significa começar a selecionar a partir de onde se encontra seu cursor.
* Digite **j**. Que é o equivalente à "seta pra baixo" pra ir pra linha de baixo. Já deve ter ouvido falar que em Vim se navega com "hjkl" que são, respectivamente, pra esquerda, pra baixo, pra cima, pra direita.
* Digite **x**. Que é o equivalente a "cortar" e colocar o conteúdo no clipboard. Feito isso, digitando **p** você dá "paste", que é colar.
* Digite **u**. Que é o comando que mais se usa: o de **Undo** ou desfazer a última modificação.

![marcar-apagar](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912143741_marcar-apagar.gif)

Isso tudo funciona no chamado **"modo de comando"**, que é o modo padrão que o Vim abre todo arquivo. Nesse modo não dá pra digitar nenhum texto. Como podem ver, cada letra sozinha é um comando, como "x" pra cut ou "p" pra paste.

Pra digitar, primeiro precisa digitar **i** (só a letra "i" em minúsculo), que daí muda do modo de comando pro **"modo de edição"**. Agora é só digitar seu texto normalmente, como em qualquer editor. Quando quiser algum comando, basta digitar **ESC** pra voltar pro modo de comando. Vamos fazer isso o tempo todo, por isso muita gente re-mapeia a tecla "caps lock" do teclado pra ser a ESC e ficar fácil só tocar com o mindinho esquerdo.

### Combinando Comandos

> Ainda no modo de comando, como navegamos pelo arquivo mais fácil?

Além das teclas "hjkl", podemos navegar mais fácil usando **b** pra "palavra anterior" ou **w** pra palavra (_word_) posterior:

![words](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912144226_words.gif)

O modo de comando permite combinar comandos, portanto podemos fazer:

* **dw** pra apagar a próxima palavra
* **db** pra apagar a palavra anterior
* **d4w** pra apagar (delete) as 4 palavras (words) seguintes
* **d4j** pra apagar as 4 linhas pra baixo

O [tutorial do Primeagen](https://github.com/ThePrimeagen/vim-be-good) tem vários exercícios pra esse tipo de navegação, recomendo se exercitar. Num VS Code todo mundo está acostumado a primeiro pegar o mouse, marcar o bloco que quer apagar visualmente, depois apertar delete ou backspace. No Vim, olhamos onde está o cursor, apertamos ESC pra estar no modo de comando, e digitamos a operação e a localização. Teste todas as combinações que conseguir imaginar.

Esta é a **mudança de paradigma** que incomoda os preguiçosos. Mas uma vez aprendido isso, você vai achar incômodo um editor que te obrigado a usar mouse pra coisas básicas.

![change in place](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912144801_change.gif)

Agora fica mais interessante: _e se em vez de apagar uma palavra, eu queira substituir a palavra onde meu cursor está pra outra palavra?_

Num editor normal, você marcaria com o mouse (ou usando alguma combinação como "ctrl+shift+seta"), e digitaria por cima ou apagaria a palavra.

No LazyVim tem plugins configurados pra coisas mais interessantes. No video acima veja como estou substituindo palavras _"in-place"_. Isso se faz com o comando **ciw**.

* **ciw** apaga a palavra inteira embaixo do cursor e abre o modo de edição pra você digitar a substituição
* **ce** apaga a partir do cursor até o fim da palavra (preserva o começo da palavra) e também abre pra você digitar no lugar
* **Shift-c** (C maiúsculo) apaga tudo a partir do seu cursor até o fim da linha inteira e abre pra você digitar.

![Mudar Bloco Vertical](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912145439_bloco.gif)

Mas isso ainda não parece tãaaaao legal. E se quiser mudar só a primeira letra de várias linhas ao mesmo tempo, por exemplo, no texto do video acima, quero mudar só o hífen ("-") de cada linha de tags?

Falei antes que apertando **v** no modo de comando ele começa o modo de visualização e dá pra selecionar a partir dali. Mas existe **Ctrl+v** que abre o modo de marcação de blocos verticais.

Nesse modo usamos as teclas "hjkl" normalmente, como **j** pra ir pra baixo, mas em vez de marcar a próxima linha inteira, ele marca só o caracter logo abaixo do seu cursor. Agora posso apagar com **d** e digitar **Shift-i** ("I" maiúsculo) pra entrar em modo de edição no começo do bloco e substituir pelo que quiser.

LazyVim tem plugins pra comentários, mas essa é outra alternativa se quiser adicionar "//" ou "#" no começo de várias linhas pra comentar, por exemplo. No caso, leia sobre o plugin [**ts-comments**](https://github.com/folke/ts-comments.nvim) pra opções melhores pra comentário. Pra iniciar um novo bloco de comentário, digite **gco** pra adicionar um comentário abaixo.

_"Modo de bloco"_ como mostrei acima, é uma das coisas que eu mais uso em código.

![Search and Replace](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912150112_search-replace.gif)

Mas só isso é muito pouco. E se quiser substituir **TODAS AS PALAVRAS** iguais do texto de uma só vez. No video de exemplo acima, quero substituir "domínio" por "DOMAIN" e "Cloudflare" por "AWS Amazon", como faço? Isso é "Search and Replace" que tem em todo editor e em Vim é muito fácil:

Digitamos **:%s/domínio/DOMAIN/**.

Se você é programador já deve ter visto essa sintaxe antes. É a sintaxe de **REGEX MATCH**. Sim, tem que saber Regex (e não, não é nem PCRE e nem Unicode, é um dialeto de Regex do próprio NeoVim, mas é parecido).

Como falei antes, "dois pontos" abre o box de digitar comandos, **"%s"** inicia "search com regex" e entre as barras "//" primeiro vai o que procura e depois com o que quer substituir.

Mas esse é o jeito no NeoVim puro, no LazyVim, tem o plugin [**grug-far**]() e se ativa com o comando **SPACE+sr**:

![grug-far](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912150648_screenshot-2025-09-12_15-06-32.png)

Agora sim, mais parecido com do VS Code, né? Use o que achar mais fácil.

### Conclusão

Como falei, isto é somente a ponta da ponta do iceberg, o mínimo do mínimo suficiente pra pelo menos começar editando arquivos simples de configuração sem abrir Nano ou VS Code só pra isso.

Leia a documentação do LazyVim. Veja os [keymaps](https://www.lazyvim.org/keymaps) pra descobrir outros comandos. Preste atenção em cada letra que aperta no modo de comando, o LazyVim mostra as opções disponíveis. Por exemplo, digamos que eu apertei **g** (goto), ele vai mostrar uma ajuda no canto inferior direito:

![ajuda](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912151849_screenshot-2025-09-12_15-18-38.png)

Assim você sempre pode descobrir novos comandos ou relembrar comandos que usa pouco. Por isso recomendo o LazyVim, que já vem bem configurado pra te ajudar. Quem faz essa funcionalidade é o plugin [**which-key**](https://github.com/folke/which-key.nvim), caso queira a mesma coisa num NeoVim que você configurou do zero.

Existem diversos [**Cheatsheets**](https://vim.rtorr.com/) por aí com tabelas de combinações de comandos importantes. Vale explorar.

Mas não é só isso, LazyVim vem com dezenas de [plugins](https://www.lazyvim.org/plugins) pra formatação, linting, LSP integrado, GIT integrado, e muito mais. Não tem como eu documentar um a um aqui. Cada um deles tem sua própria documentação na página de plugins do LazyVim.org.

Novamente, não esqueça de chamar o **:LazyExtras** e instalar os plugins opcionais das suas linguagens.
