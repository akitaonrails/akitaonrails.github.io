---
title: Omarchy 2.0 - TUIs (Terminal User Interface Apps)
date: "2025-09-09T01:00:00-03:00"
slug: omarchy-2-0-tuis
tags:
  - arch
  - omarchy
  - TUI
  - lazydocker
  - bubbletea
  - gum
  - posting
  - caligula
draft: false
---

Uma das coisas mais frustrantes pra um usuário de Linux é que existem muito poucos Apps gráficos bem feitos. Veja um Gimp ou LibreOffice. São feios, antiquados, muito parecidos com a primeira vez que usei eles mais de 20 anos atrás.

Os apps mais "modernos" são basicamente front-ends web enlatados dentro de um wrapper Electron. O problema? São **PESADOS** consomem RAM como se não houvesse amanhã. Comece a abrir Discord, Spotify, e vários desses e veja se seu notebook velho de 8GB de RAM vai aguentar.

Mas, especialmente se você é um programador, deveria dar mais atenção pra TUIs. Num primeiro momento alguns devem virar o nariz: _"apps de terminal são feios, preto e branco, quadrados, blerg"_

Se fosse 20 anos atrás, estariam certos. Mas é 2025 e hoje em dia terminais suportam 256 cores (mais que suficiente), suportam várias resoluções e, mais importante, suportam fontes, em particular [Nerd Fonts](https://www.nerdfonts.com/), fontes que tem ícones dentro. É assim que funciona uma ferramenta como [eza](https://github.com/eza-community/eza), que eu uso todo dia com alias pra `ls` e fica assim:

![eza](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-08-29_16-50-25.png)

Não é só isso, existem bibliotecas modernas, pra diversas linguagens, como [**BubbleTea**](https://github.com/charmbracelet/bubbletea), que é um framework pra construir TUIs. Chequem o GitHub deles mas tem as ferramentas pra fazer interfaces assim:

![BubbleTea](https://camo.githubusercontent.com/e2b13cfb4ea64e98028ab21e0dca97a6af46d8eeb78ef092c5cd4669ea7b7bef/68747470733a2f2f73747566662e636861726d2e73682f627562626c657465612f627562626c657465612d6578616d706c652e676966)

E se quiser só um widget simples pra complementar um script Bash que está fazendo, eles tem o [**Gum**](https://github.com/charmbracelet/gum), que permite interfaces assim:

![Gum](https://camo.githubusercontent.com/cea695e2df946b14838196a5cfb7d6608f03387ba42c7a7fb5afa6432371635c/68747470733a2f2f7668732e636861726d2e73682f7668732d31715935375272516c584375796473456744703638472e676966)

E pra usar é só instalar o binário e no seu script fazer linhas assim:

```bash
# exemplos de Gum
gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert"

gum input --placeholder "scope"

gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"
```

E se usa [**Omarchy**](https://akitaonrails.com/tags/omarchy/) eles ainda trazem uma funcionalidade extra pra TUIs. Basta clicar "SUPER+ALT+SPACE" pra trazer o menu principal, depois escolher "INSTALL" e "TUI". Ou simplesmente abrir o terminal e executar:

```
$OMARCHY_PATH/bin/omarchy-tui-install
```

![omarchy-tui-install](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-08_23-22-50.png)

Ele vai pedir um nome pro App e a linha de comando pra executar. Dá pra escolher icones também no [Dashboard Icons](https://dashboardicons.com/). Registrando dessa forma, quando chamar o launcher Rofi com "SUPER+SPACE" e digitar "lazy" vai aparecer o LazyDocker como se fosse um app normal:

![Rofi LazyDocker](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/hdmi-a-3.png)

E como em Hyprland não tem barra de título nem nada, apps TUI ou webapps (tem `omarchy-webapp-install` também) abrem como se fossem apps "nativos":

![tiles windows](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-09_00-49-28.png)

Leiam as seções de [TUIs](https://learn.omacom.io/2/the-omarchy-manual/59/tuis) e [Web-Apps](https://learn.omacom.io/2/the-omarchy-manual/63/web-apps) no manual do Omarchy.

Obviamente, isso é só se você é daqueles que prefere a sensação de estar executando "Apps", mas é a mesma coisa se abrir um Terminal e simplesmente digitar o `lazydocker` na linha de comando - que é minha preferência. O que esses scripts do Omarchy fazem é criar um arquivo `.desktop` em `~/.local/share/applications`. O exemplo do `LazyDocker.desktop` gera isto:

```
❯ cat ~/.local/share/applications/LazyDocker.desktop
[Desktop Entry]
Version=1.0
Name=LazyDocker
Comment=LazyDocker
Exec=alacritty --class TUI.tile -e lazydocker
Terminal=false
Type=Application
Icon=/home/akitaonrails/.local/share/applications/icons/LazyDocker.png
StartupNotify=true
```

Se não quiser mais este launcher é só apagar o arquivo ou chamar o script `$OMARCHY_PATH/bin/omarchy-tui-remove`.

Esse recurso é particularmente interessante no Hyprland porque diferente de GNOME ou KDE, a janela não tem barra superior de título, então não entrega que você está só abrindo um terminal ou navegador web. É assim que ele já vem pré-configurado com coisas como ChatGPT ou Grok parecendo que são apps "nativos", mas na verdade são só janelas de Chromium abrindo direto as URLs de cada um:

![WebApps Omarchy](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-09_00-54-52.png)

## Alguns TUIs que eu gosto

Na minha opinião, já que não tem Apps com GUIs bonitas pra Linux, é melhor mesmo usar os respectivos web-apps como Canva ou ChatGPT dessa forma, mas mais interessante é ter TUIs mesmo. Como falei, hoje em dia não é difícil fazer TUIs bonitas. Pra um programador, a vantagem é não tem que lidar, primeiro com frameworks de front-end, segundo, ter que fazer deploy em algum lugar na internet.

TUIs são leves, usam poucos recursos na máquina, são fáceis pra qualquer programador fazer, e você pode ter um home server ou um servidor num cloud qualquer, acessar via SSH e acessar a TUI, sem ter que lidar com X11 ou RDP ou qualquer coisa mais pesada só pra ter um GUI.

Alguns TUIs são óbvios, no [post anterior](https://akitaonrails.com/2025/09/07/omarchy-2-0-lazyvim-lazyextras/) já falei de [**LazyVim**](https://www.lazyvim.org/) e como ele é um editor de textos tão competente e completo quando um VS Code, usando só uma fração dos recursos da máquina. Todo mundo deve conhecer ferramentas como HTOP ou BTOP. Além dos [LazyGit](https://github.com/jesseduffield/lazygit) ou [LazyDocker](https://github.com/jesseduffield/lazydocker) também. Esses todos já vem no Omarchy.

Mas tem muito mais, por exemplo, [**dblab**](https://github.com/danvergara/dblab) que é um TUI cliente de banco de dados como MySQL ou Postgres:

![dblab](https://github.com/danvergara/dblab/raw/main/screenshots/dblab-cover.png)

Outro similar é [LazySQL](https://github.com/jorgerojas26/lazysql), feito em Go:

![LazySQL](https://github.com/jorgerojas26/lazysql/raw/main/images/lazysql.png)

Ou se você prefere ferramentas feitas em Rust, tem o [**rainfrog**](https://github.com/achristmascarl/rainfrog):

![rainfrog](https://github.com/achristmascarl/rainfrog/raw/main/vhs/demo.gif)

Pra quem não consegue usar CURL na linha de comando e prefere usar Postman pra chamar e explorar APIs, tem o TUI [**Posting**](https://github.com/darrenburns/posting) que faz a mesma coisa:

![Posting](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/422760155-78359ab0-5e0c-4c0b-a60b-dce06b11bbf5.png)

Pra nós que rodamos muitos containers Docker, já falei do LazyDocker, mas tem também o [**oxker**](https://github.com/mrjackwills/oxker):

![oxker](https://github.com/mrjackwills/oxker/raw/main/.github/demo_01.webp)

Se usar Discord, tem o [**discordo**](https://github.com/ayn2op/discordo):

![Discordo](https://github.com/ayn2op/discordo/raw/main/.github/preview.png)

Quem faz muito ricing de Linux já teve que gravar ISOs em Pen Drives dezenas de vezes, pra isso tem o `dd` na linha de comando, mas tem um TUI mais legal que é o [**Caligula**](https://github.com/ifd3f/caligula):

![Caligula](https://github.com/ifd3f/caligula/raw/main/images/verifying.png)

Se seu SSD está ficando cheio e você não sabe onde diabos que tá ocupando tanto espaço, tem várias ferramentas pra analisar e te mostrar, um deles é o [**gdu**](https://github.com/dundee/gdu):

![gdu](https://camo.githubusercontent.com/d8fa7d2f7bdd10dce45a81c2accf26d597b300b82e01b97a1288ff2f1fe06c57/68747470733a2f2f61736369696e656d612e6f72672f612f3338323733382e737667)

E o último que achei legal pela nostalgia é o [**sc-im**](https://github.com/andmarti1424/sc-im), pense em Excel como TUI ou - pra nós que viemos dos anos 80 - pense Lotus 1-2-3 mas com key bindings de Vim:

![sc-im](https://github.com/andmarti1424/sc-im/raw/main/screenshots/scim-plot-graph.gif?raw=true)

Pra que abrir Google Spreadsheets só pra fazer um Todo list se dá pra fazer no Terminal?? TUIs são excepcionais!

Se quiser conhecer mais TUIs olhe o [**awesome-tuis**](https://github.com/rothgar/awesome-tuis/?tab=readme-ov-file) no GitHub:

[![awesome tuis](https://github.com/rothgar/awesome-tuis/raw/master/img/banner.png)](https://github.com/rothgar/awesome-tuis/?tab=readme-ov-file)
De novo: zero necessidade de front-ends web pesadas pra coisas simples. Nada supera a simplicidade de uma linha de comando. E com bibliotecas como BubbleTea ou Gum, está muito fácil pra qualquer um fazer um app bonito. E com Hyprland e Omarchy, fica tudo integrado lado-a-lado de qualquer outro app com GUI.

Filosofando um pouco, a história das GUIs começa com interfaces gráficas _skeumorphic_ que tentam imitar objetos do nosso dia a dia, em particular parecendo pseudo-3D, como era um Windows 95. Chegou nos anos 2000 e começaram a migrar pra interfaces _flat_ ou _minimalistas_, tirando completamente o skeumorphismo, deixando tudo plano. Foi a partir do Metro do Windows 8, principalmente. E eu acho que isso converge pra estilo mais de TUI, dando uma volta completa, voltando a como era nos terminais dos anos 70. Eu particularmente acho isso fascinante.
