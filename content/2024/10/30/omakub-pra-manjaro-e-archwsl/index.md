---
title: Omakub pra Manjaro e ArchWSL
date: '2024-10-30T12:41:00-03:00'
slug: omakub-pra-manjaro-e-archwsl
tags:
- omakub
- basecamp
- dhh
- ubuntu
- manjaro
- arch
- zsh
- atuin
- neovim
- zellij
- tmux
- asdf
- mise
draft: false
---

Algum tempo atrás o DHH lançou uma ferramenta open source chamada [Omakub](https://omakub.org) que instala diversas ferramentas e configura um ambiente de desenvolvimento moderno em Ubuntu. Ele vai além de coisas só de terminal e também configura vários aspectos do ambiente GNOME. Vale a pena experimentar, nem que seja numa Virtual Machine, pra ver como fica.

![Omakub - demo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/1ddbjucxzkah963tou557907bkmr)

Eu gostei bastante das escolhas do DHH, ele sempre foi um cara de Mac, eu também. Mas eu migrei de volta pra Linux quase 10 anos atrás. O motivo foi porque eu evangelizava tech pra desenvolvedores júniors e no Brasil ficou inviável incentivar Macs. E não queria que parecesse que sem usar Macs você estaria automaticamente em grande desvantagem. Então passei a usar exclusivamente Linux e no blog fiz vários posts explicando sobre isso, como estes:

* [2015 - Situação Brasil: No Macs for the Rest of Us](https://www.akitaonrails.com/2015/11/10/situacao-brasil-no-macs-for-the-rest-of-us)
* [2016 - The Year of Linux on the Desktop, by Microsoft ??](https://www.akitaonrails.com/2016/04/12/o-ano-do-linux-no-desktop-pela-microsoft)
* [2017 - Off-Topic - Why are we all moving away from Apple?](https://www.akitaonrails.com/2017/01/12/off-topic-por-que-estamos-todos-migrando-para-longe-da-apple)

Sem contar os diversos videos com setups que fiz no meu canal, como estes:

* [O Guia Definitivo de Ubuntu pra Devs Iniciantes](https://www.youtube.com/watch?v=epiyExCyb2s)
* [O Melhor Setup Dev com Arch e WSL2](https://www.youtube.com/watch?v=sjrW74Hx5Po)

Em 2024, com exceção se precisa desenvolver apps pra iOS ou coisas específicas de .NET, usar distros Linux é superior a usar Windows ou MacOS. Antigamente eu diria um "mas" se quiser jogar, aí seria obrigado a fazer dual-boot com Windows. Mas até isso Linux já superou Macs graças aos esforços da Valve e as comunidades open source em torno de projetos como Proton. Hoje, uma quantidade absurda de jogos novos de PC rodam liso em Linux, basta instalar Steam e já era.

Não é o tema do artigo, mas já que toquei no assunto, estava justamente  assistindo um review do [BazziteOS](https://bazzite.gg/) rodando no **Asus ROG Ally** (meu favorito), criando um Steam Deck ainda mais potente. É Fedora rodando num handheld, com uma interface tão boa que ninguém sabe que é Linux por baixo, rodando jogos com mesma performance que em Windows. É impressionante mesmo. Quem ficou totalmente pra trás em games foi a Apple.

{{< youtube id="OwWRCrGoXV0" >}}

Isso tudo dito, o DHH mudou pra um hardware muito bacana de uma empresa pequena e nova chamada [Framework](https://frame.work/), que faz notebooks modulares. A idéia é não precisar jogar tudo fora quando quiser fazer upgrades de hardware. Só trocar o módulo pra um mais novo. E não só coisas simples como trocar uma porta USB-A por uma USB-C, mas até trocar GPU, trocar placa-mãe, monitor. 

É um conceito muito bacana que eu gostaria que mais fabricantes se comprometessem a fazer. Evita lixo eletrônico desnecessário, pra começar, muito mais fácil de reparar partes, sem ter que jogar tudo fora, como acontece com um Macbook. Vi isso pela primeira vez no canal do Linus Tech Tips porque o Linus Sebastian se tornou um dos primeiros investidores anjo deles.

![Framework](https://images.prismic.io/frameworkmarketplace/Zv77LrVsGrYSwWcu_3A-marketplace-parts-2x.png?auto=format,compress)

A maioria dos fabricantes que suportam Linux, costumam oferecer algum tipo de suporte a Ubuntu. Ele acabou meio que se tornando o "padrão" de Linux pra usuários comuns. Na dúvida, instale Ubuntu. E não é uma má escolha. Se escolher Ubuntu, use o projeto [Omakub](https://github.com/basecamp/omakub) oficial do DHH, que vai configurar tudo bonitinho pra você.

Eu não gosto de Ubuntu, é uma escolha pessoal (e cada um de Linux vai ter sua própria opção. Já sei que o primeiro comentário vai ser alguém falando de porque todo mundo não usa NixOS de uma vez ...). Não precisa ficar preocupado nem se sentir mal por usar Ubuntu, não tem absolutamente nada de errado com ele. Escolher distros é que nem escolher marca de carro.  Qual a diferença de Ferrari, Lambo, Porsche, McLaren? Você vai achar ruim se prefere Lambo e eu prefiro McLaren?

Além disso, puristas vão dizer que é pra ficar no Arch Linux puro, mas faz anos que prefiro [**Manjaro GNOME**](https://manjaro.org/products/download/x86) no meu PC desktop e em notebook prefiro ficar com Windows 11 mesmo e WSL2 rodando [**ArchWSL**](https://github.com/yuk7/ArchWSL). Ainda recomendo brincar com Arch puro pra aprender. Mas depois de tantos anos, como é meu caso, prefiro um instalador que faz igual Ubuntu: vai do zero ao desktop em poucos cliques.

Então não teve jeito, fui obrigado a fazer um fork e ajustar o Omakub num novo projeto, o [**OMAKUB-MJ**](https://github.com/akitaonrails/omakub-mj) (o nome não tá muito correto, deveria ser algo como OMAKAMJ ou algo assim que seria Omakase com Manjaro, mas fica feio, mandem sugestões nos comentários). Migrei todos os comandos de Apt pra Yay, além de diversos outros ajustes. Rodei no meu PC principal (depois de ter testado bastante numa VM, claro) e agora ficou bonitão assim:

![Omakub-MJ](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/8sq62mkbc4kxuzqk5opej275xpuc)

Igual à versão de Ubuntu, ele ativa o tema Tokyo Night, mas dá pra mudar pra vários outros temas. Depois de instalado, vai ter um comando `omakub` no terminal que abre um menu com várias opções, incluindo mudar tamanho das fontes ou trocar temas:

![Omakub trocar tema](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/7qvbv50ipzifo3cv5bhe3lb64kq8)
Tem **MUITAS** coisas legais pré-instaladas, por isso repito pra ler [o manual](https://manual.omakub.org/) que é muito bonito, bem escrito, e eu não mudei nenhuma das configurações principais (só o zellij, já explico), então tudo que vale pra versão Ubuntu também vale pra Manjaro. E eu sei que a maioria de vocês tem preguiça de abrir o manual, mas uma coisa que o DHH sabe fazer é uma documentação atraente:

[![Manual Omakub](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/xdsu6gghf5ncic9rh852hv1c7bcz)](https://manual.omakub.org/1/read#leaf_29)
### Migrando pra Manjaro

Enfim, pra migrar de Ubuntu pra Manjaro, a primeira coisa que fiz foi trocar comandos apt por yay, coisa simples assim:

```diff
- sudo apt install -y alacritty
+ yay -S alacritty --noconfirm
```

Mas rapidamente encontramos as partes de porque eu prefiro o **YAY** do que **APT** como gerenciador de pacotes:

```diff
-  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
-  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \| sudo tee /etc/apt/sources.list.d/brave-browser-release.list
-  sudo apt update -y
-  sudo apt install -y brave-browser
+  yay -S brave-browser --noconfirm
```

Em Ubuntu, tudo que a própria Canonical não controla, fica em repositórios de terceiros, então precisamos explicitamente adicionar esses repositórios antes de conseguir instalar seus pacotes.

Em Arch é a mesma coisa, com o Pacman só conseguimos instalar os pacotes oficiais que o grupo do Arch controla e testa. Mas existe um repositório de terceiros chamado AUR, o Arch User Repository. Daí instalamos ferramentas como Pamac (que vem instalado em muitas distros) ou o Yay (que eu gosto mais). Por baixo eles rodam Pacman, mas oferecem um único comando que serve pros dois: instalar pacotes oficiais e instalar pacotes do AUR, com os mesmos comandos. Então não tem que ficar manualmente gerenciando trocentos repositórios externos.

Foi bem fácil converter porque no AUR tem tudo que precisamos. É muito raro precisar de um software e não achar no AUR. Além disso fiz outra modificação: eu prefiro manter aplicativos gráficos como Spotify ou Discord instalados via **Flatpak**. 

Não é nem por razões de segurança. Prefiro que aplicativos de terceiros mexam no sistema operacional abaixo o menos possível. E muitos deles precisam de várias dependências. Quando preciso fazer um upgrade geral, demora mais porque vem um monte de pacotes de dependência junto que eu nem precisava. Pelo menos com Flatpak, as dependências ficam isoladas em imagens de containers.

Enfim, quando preciso atualizar o sistema só faço `yay -Syyuu` e quando quero atualizar aplicativos, basta fazer `flatpak update -y`, assim posso rodar separadamente. As únicas exceções são editores de texto como Visual Studio Code, nesse caso prefiro que ele tenha acesso ao sistema de arquivos todo mesmo, e não ter que lidar com permissões de acesso em containers de Flatpak, por isso instalo via Yay.

### GNOME

Adicionei dois aplicativos opcionais, o Bitwarden (o DHH prefere o 1password, ambos são bons) e o Discord. Aplicativos de Flatpak são fáceis de instalar, nem precisa estar num instalador como esse, mas coloquei só mais esses por conveniência pra mim mesmo. Obviamente você pode instalar depois o que quiser. Basta procurar com `flatpak search` e instalar com `flatpak install`.

No lado Gnome, o DHH escolheu apps como [Flameshot](https://flameshot.org/) pra substituir o app de screenshot do Gnome. Uma das vantagens é que depois de tirar a foto de tela, dá pra imediatamente editar a imagem antes de salvar. Pra ter preview rápido de imagens no gerenciador de arquivos Nautilus, ele escolheu o [Gnome Sushi](https://gitlab.gnome.org/GNOME/sushi). Todas essas opções são muito boas e você pode ver tudo que é instalado no desktop no diretório [install/desktop](https://github.com/akitaonrails/omakub-mj/tree/master/install/desktop). Cada app é um script separado.

De todos, o único que realmente não conhecia é o [**Localsend**](https://play.google.com/store/apps/details?id=org.localsend.localsend_app&hl=en). Mas agora já instalei no meu Linux, Windows, smartphone e tudo mais. É o jeito mais fácil de transferir arquivos entre máquinas na mesma rede. Igual o Airdrop de iPhone. Vale a pena ter instalado em tudo.

[![Localsend](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/fnpyyqis498wth9do5qodt7xli0x)](https://localsend.org/pt-BR)

Outro app que eu não conhecia é o [Ulauncher](https://ulauncher.io/) que é um executador de aplicações, igual a barra de Spotlight de Mac. Basta apertar `Super/Tecla de Windows + Espaço` e ele abre uma barra onde podemos digitar o nome do app que queremos abrir:

![Ulauncher](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ttbw39v9y0r17rw16x4s99p45epe)

Se fosse só isso, não é muito útil porque em Gnome, só de apertar `Super` já dá pra digitar o nome de apps. Mas o interessante é que ele faz mais que executar apps. Depois fuce a [Página de Extensions](https://ext.ulauncher.io/) pro Ulauncher. Tem coisas como calculadoras, controlador de Spotify, pesquisador de arquivos, facilitador pra editores com Obsidian ou Notion, pesquisador de snippets de código pra VS Code, tradutores, integradores pra serviços de GPT e um dos meus favoritos, facilitador de Emojis:

![Ulauncher Emojis](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/dsjsfzdr6rddfrqqtlcmj3uu9891)

O Omakub ajusta bastante coisa do Gnome. Em particular adiciona várias extensions que mudam o comportamento do ambiente gráfico:

![Gnome Extensions](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ocm6xifnbygf4cagdb5icjusz1t6)

Depois vale fuçar as configurações de um por um. Por exemplo, ele instala e já configura a extension [**Tactile**](https://extensions.gnome.org/extension/4548/tactile/) que é provavelmente a melhor pra organizar as janelas em "tiles" ou "azulejos", ou seja, pra facilitar alinhar uma janela em cima ou do lado da outra de forma proporcional. Ele faz isso pré-dividindo a tela em áreas e atribuindo letras a cada área, assim fica fácil de fazer uma janela se encaixar numa dessas áreas.

Por exemplo, com o comando `Super + T` aparece esse grid. Se digitar "w" duas vezes, minha janela de Alacritty se encaixa no topo, no meio, na área marcada com "W":

![Tactile W](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ofqh86tf3l3p6eviesq1dhosbio2)

Normalmente, eu gosto de ter a janela aberta no meio do monitor, maximizado na vertical, sem esticar pros lados, especialmente pra ler ou digitar textos. Então posso fazer `Super + T` e logo depois `W e S` pra marcar duas áreas:

![Tactile W S](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ijvlxzdvykxn12nbkvcwy73s5i6p)

Mas também continuo podendo teclar `F11` ou `Super + seta pra cima` pra maximizar a janela na tela inteira. Ou usar as combinações clássicas de Windows como `Super + seta esquerda` ou `Super + seta direita` pra fazer a janela usar metade vertical da tela, desta forma:

![Tactile lado a lado](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/jjznbiwblc0zdlfydrmdqqxuxwkk)

Vale fuçar a documentação e as configurações da extension Tactile pra dividir as áreas do jeito que mais gosta. Isso vai variar bastante caso use monitor secundário na vertical, ou use monitor Ultra Wide. E nesse caso é onde esse tipo de extensão vai fazer mais diferença pra manter suas janelas organizadas.

### Neovim e LazyVim

Eu mencionei Visual Studio Code, e ele está aqui pra quem gosta, mas quem acompanha meus videos e artigos, sabe que sou usuário de Vim de longa data. E a comunidade Vim não pára quieta. Hoje em dia tem um fork mais moderno, o **NEOVIM**, que se tornou o mais usado. 

![LazyVim](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/k00pryy0c676m4ryssrt7d48aqqr)

Em cima do NeoVim podemos instalar plugins manualmente e ficar ajustando configuração pela eternidade, ou usar configs já prontas. Até poucos meses atrás eu usava o LunarVim, mas ele meio que caiu em desuso. Depois passei a usar o [AstroNVIM](https://astronvim.com/), que resolve muito bem, mas parece que a maioria das pessoas passou a convergir pro [**LazyVim**](https://www.lazyvim.org/). Confesso que fico em dúvida entre qual é o melhor, AstroNvim ou LazyVim, mas vou ficar com o LazyVim por enquanto.

No fundo vão usar muitos dos mesmos plugins, análise de código vai ter plugins pra LSP, navegação vai ter o mesmo neo-tree, o mesmo telescope e assim por diante. Por isso vai ser muito subjetivo mesmo. Acho que nenhum dos dois tem como errar. 

Muita gente acha que esses pacotes são contra a filosofia de "aprenda a configurar você mesmo". E de fato, se puder, recomendo mesmo que monte sua configuração do zero. Mas faça isso só uma vez, desfaça e use um desses pacotes. Na realidade, essa noção começa a falhar porque esses plugins, sejam eles escritos no antigo VimScript ou na mais moderna linguagem Lua, são programas completos. Pegue plugins como Neo-Tree ou Telescope. Você não fez nem nunca vai fazer nenhum deles do zero, isso é pra poucos.

Na prática, o NeoVim já poderia vir pré-instalado com eles, pra você não faria diferença, porque são modernos, bem escritos, customizáveis, e não ficam no seu caminho. Não vem porque a idéia toda de um Vim é ser hiper-leve, pra podermos usar rapidamente dentro de um container, ou conectando num outro servidor via SSH, sem GUI, sem dependências, se bugs de interface nem nada disso. Só no nosso desktop, em ambiente controlado, gostaríamos dele tão pesado e funcional quanto um VS Code.

Depois tente dar uma olhada na configuração de um LazyVim, é muito mais coisa do que uma única pessoa deveria se preocupar. E saem plugins novos todos os dias, plugins antigos deixam de ser usados, não tem como você ficar de olho em tudo isso. Melhor ser um esforço dividido pela comunidade e a gente ter a oportunidade de usar o que tem de melhor só dando um update.

Sinceramente, seja Astronvim ou LazyVim, eu não tenho nem vontade e nem disposição de tentar montar do zero uma config como essa. E o que eles me oferecem "out-of-the-box" está perfeito já, eu não preciso ficar mudando. Basta usar. Você tem que ser muito chato pra achar que pode fazer melhor. Se achar isso, faça um pull request pra esses projetos então. Será tempo melhor gasto.

### ZelliJ

Eu sou usuário de Tmux de longa data. E meus amigos usavam o antigo Screen, antes disso ainda. Eu lembro quando falávamos do Tmux como o software mais moderno. Agora ele é o legado e o mais moderno é o ZelliJ.

Todos eles são gerenciadores de sessão. Pense quando você se conecta num servidor remoto via SSH e fica trabalhando nele. Daí temos uma pane na internet ou cai a luz. O que acontece? Não só a conexão fecha, mas seja lá o que você estava rodando remotamente vai crashear porque o app está atrelado - é um filho - da sua shell (bash, zsh). E sua shell estava atrelada à sessão SSH. Quando a conexão cai, o SSH mata o shell que mata sua app. Você perde o que estava fazendo ou, pior, se o programa estava no meio, ele vai crashear no meio e pode corromper alguma coisa.

Em vez de correr esse risco, quando logar via SSH, imediatamente abra uma sessão de Screen, Tmux ou Zellij. Agora o shell vai abrir atrelado ao Zellij. Se a conexão cair e o SSH fechar, o ZelliJ vai continuar rodando, ele fica atrelado a um daemon na máquina remota. Seu shell e seu app ficam atrelados ao ZelliJ e não à sua sessão SSH.

Quando a luz voltar ou a internet voltar, basta conectar via SSH de novo e rodar o comando `zellij attach` ou `tmux attach`  e ele vai "re-anexar" à última sessão de apps, e você vai voltar ao seu shell, como se nunca tivesse saido de lá. Quaisquer apps que estivessem rodando e processando, ia continuar até acabar, normalmente, como qualquer app em background. Essa é a vantagem principal de um gerenciador como ZelliJ ou Tmux.

Mesmo se não estiver trabalhando numa máquina remota via SSH. Mesmo no seu desktop. Digamos que esteja brincando de editar configurações, instalar extensions e coisas assim. E do nada seu GNOME ou seu X resolvam dar pau, crashear e reiniciar. Todos os apps gráficos vão crashear junto, incluindo seu app de terminal, como Alacritty e junto com ele, qualquer shell e programa em linha de comando que estivesse rodando, como seu NeoVim, podendo perder código que estava editando e não salvou.

Não mais. Quando o X reiniciar, basta reabrir seu Alacritty e, mesma coisa, fazer um `zellij attach` pra voltar exatamente onde estava. Inclusive, se dentro do zellij você estava remotamente conectado a um servidor, monitorando com htop ou algo assim, nada vai fechar, vai continuar tudo conectado. Isso é mais uma camada de estabilidade pra você.

Veja este exemplo abaixo:

![ZelliJ](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/wmxxa8a061mg6ius1chgukb4k86m)

O Omakub já configura o ícone do Alacritty pra abrir uma janela de ZelliJ. Se seguir a configuração padrão, teclando `Ctrl P D`, sendo "P" pra Painel e "D" pra "D"ividir a janela horizontalmente, dá pra abrir dois programas um em cima do outro.

**ATENÇÃO:** este é o único app do Omakub que fui obrigado a mudar os shortcuts, por isso o que tem na documentação oficial não vai bater.

O problema é o seguinte: vários apps de terminal, como NeoVim, tem vários shortcuts de navegação. Se digitar "Espaço + E" vai abrir o painel de exploração do Neo-Tree na esquerda. Dá pra navegar por diretórios usando "J" ou "K" pra ir pra cima ou pra baixo e "Enter" pra abrir os diretórios ou abrir arquivos.

Quando o arquivo abre, ele abre num painel na direita. Mas como você navega entre os painéis? Basta digitar `Ctrl + H` ou `Ctrl + L` (lembrando que em Vim as "setas" são as telas da home row da mão direita `H J K L`). Só que se você estiver dentro do ZelliJ, isso não vai funcionar. Isso porque o ZelliJ em si usa o modificador `Ctrl` pra ele. Então ele engole o comando e não passa pro NeoVim.

Uma das soluções é que o ZelliJ, assim como NeoVim, tem "modes". Vim tem modo normal, modo de edição e modo visual. ZelliJ tem vários modos, como modo normal, modo de scroll, modo de painel e cada modo tem seu sub-conjunto de shortcuts/combinações de teclas. Um desses modos é "Locked". Podemos travar o zellij, daí usar o programa dentro do painel isoladamente, e lembrar de ficar "desbloqueando" o zellij. É meio chatinho de ficar fazendo isso.

Outra solução é o que eu fiz no Omakub-MJ. Eu adicionei as configurações do usuários de GitHub "shoukoo" que fez um artigo um tempo atrás chamado [ZelliJ 💓 NeoVim](https://shoukoo.github.io/blog/zellij-love-neovim/). A configuração completa dele está [neste arquivo](https://github.com/shoukoo/dotfiles/blob/master/zellij.kdl). Mas em resumo, ele cria um modo especial que batizou de "modo tmux".

Pra entrar nesse modo, precisa digitar primeiro `Ctrl f` e na barra inferior, dá pra ver mudando de modo Normal pra Tmux:

![zellij tmux](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ecr3jpesab4l2ilalp24vf7f9n4c)

E agora sim, podemos digitar comandos como `P D` pra dividir painel. E fazendo isso, enquanto estiver no modo Normal mesmo, dentro do Neovim, combinações como `Ctrl H` ou `Ctrl L` vão funcionar normalmente. Win-win!

Só lembrar que, se na documentação oficial do zellij/omakub ele mandar digitar `Ctrl P W` pra abrir um painel flutuante, agora vai ser `Ctrl + F` e depois `P W`. E ele chama de "modo tmux" porque em Tmux, todo comando é depois de digitar `Ctrl + B` antes. No caso ele escolheu `Ctrl + F` pro ZelliJ, mas é arbitrário, poderia ser qualquer combinação inicial.

O resto continua funcionando igual. Pra navegar entre os painéis de ZelliJ, só digitar `Alt + H` ou `Alt + K` como no NeoVim, mas usando Alt em vez de Ctrl. Pra salvar a sessão atual e sair do ZelliJ, só fazer `Ctrl + F, O D` e quando voltar, só digitar `Ctrl + F, O W` pra listar as sessões salvas (sim, dá pra ter várias), e restaurar a que quiser com Enter.

Como o manual do Omakub recomenda, vale [estudar a documentação oficial do ZelliJ](https://zellij.dev/documentation/).

### ASDF pra MISE

Finalmente, uma das ferramentas que eu usei por mais anos foi o ASDF. Quem já programa em Node, Ruby, Python, etc já teve que usar algo como NVM, RVM ou RBenv, VENV ou Conda e assim por diante.

O mundo ideal é que todo mundo sempre usasse a versão mais nova de tudo, toda linguagem, toda biblioteca, tudo. Mas isso é inviável. Um bom programador vai acumular vários projetos na sua máquina, cada um vai estar numa versão diferente.

Ano retrasado ele trabalhou num projeto em Node na versão 16. Hoje está trabalhando num projeto novo na versão 22. Mas do nada, teve a necessidade de rodar esse projeto antigo. E agora? Ele atualizou tudo e só tem o node 22. Se desinstalar e instalar o 16 pra rodar o antigo, como fica o projeto novo? E as bibliotecas, como fica seu diretório de NPM? Uma zona completa.

Pra conseguir ter várias versões de node instaladas em paralelo na mesma máquina, recomenda-se usar NVM, que é o Node Version Manager. 

Mas você é um programador poliglota. Trabalha em projetos em várias diferentes linguagens. Vai ter que aprender os comandos individuais de gerenciar versão pra cada linguagem? NVM pra Node. VENV pra Python. RVM pra Ruby, o que usa pra Java? Fodeu.

Pra isso criaram projetos como o antigo ASDF. Com ele era muito simples, bastava fazer `asdf install nodejs 14.21.3` pra instalar uma versão antiga de node e depois `asdf local nodejs 14.21.3` dentro do diretório do projeto antigo. Ele cria uma arquivo `.tool-versions` declarando a versão de nodejs pra esse diretório e quando entramos nele, o asdf detecta e já muda o que precisa pra poder usar a versão certa. Super conveniente.

Mais conveniente ainda porque podemos usar o mesmo conjunto de comandos pra qualquer linguagem. Basta instalar o plugin da linguagem com `asdf plugin add java` por exemplo. E ele suporta dezenas de linguagens, até as mais exóticas que você nunca ouviu falar. É o verdadeiro canivete suíço de gerenciamento de linguagens.

E esse seria o fim da história. Hoje mesmo, se você já usa ASDF, pode continuar usando, não tem nenhum problema com ele. Mas você conhece o povo de Rust: eles querem reescrever tudo em Rust. O Omakub mesmo instala vários substitutos como o "exa" que substitui "ls" e é feito em Rust. Tem vários assim.

No caso, existe o novo [**Mise**](https://mise.jdx.dev/dev-tools/) de "mise-en-place", pra quem já assistiu Masterchef. É exatamente a mesma coisa que ASDF só que feito em Rust. Inclusive ele é compatível com o mesmo arquivo `.tool-versions` que mencionei antes. Se não tiver, ele gera arquivo com nome próprio `.mise.local.toml` porque, claro, YAML ou JSON são antigos, o negócio é usar TOML ...

Ele simplifica os comandos, mas não necessariamente acho que ficaram mais intuitivos. Mas é bem simples. Digamos que eu precise do tal Nodejs antigo, basta fazer `mise install node@14.21.3` ou direto `mise use node@14.21.3` pra instalar e já escolher pra usar.

Dá pra configurar versões locais pra cada diretório de projeto com `mise use --env local node@14.21.3`. E essa sintaxe de "@" é pra permitir instalar mais de uma versão num único comando, por exemplo `mise install ruby@3.1 nodejs@22.3.0`.

Mesma coisa como asdf, também podemos configurar a versão global padrão, caso não tenha arquivos como `.tool-versions` no diretório, fazendo `mise use --global nodejs@22.3.0`. Pra listar o que tem instalado, só fazer `mise ls`.

Enfim, vale [estudar a documentação oficial](https://mise.jdx.dev/getting-started.html). No geral é uma ótima ferramenta e um bom substituto pra ASDF. Mas ele é tão parecido com ASDF que, se já estiver acostumado, não tem necessidade de mudar. Não tem nada a mais que ele faça que eu fosse sentir falta se não tivesse. Povo de Rust tem que parar de ficar substituindo as coisas pra fazer exatamente a mesma coisa. Era melhor gastar esse tempo ajustando e mandando patches pro próprio ASDF. Só dividiu os esforços da comunidade em duas ferramentas que fazem a mesma coisa.

### Últimas Considerações - Atuin

Uma última coisa, é que eu adicionei a ferramenta [**Atuin**](https://atuin.sh/) "Magical Shell History". Ele substitui o histórico do seu shell (sabe, aquele que você pode digitar "Ctrl + R" e procurar a linha de comando?) que normalmente é gravado em arquivo texto e manda pra um banco de dados SQLite3.

Só isso já seria legal, pra tirar as limitações de arquivo texto e evitar corromper e perder histórico. Mas além disso ele tem um serviço que permite sincronizar seu histórico entre diferentes máquinas. Digamos, seu PC desktop de casa, seu notebook de trabalho, seu servidor remoto. Hoje em dia todos tem históricos isolados e diferentes. E se desse pra sincronizar todos?

Aquele dia que você esquece seu notebook no trabalho, está no PC de casa e fica *"puts, quais eram mesmo aqueles comandos de docker que eu fiz no trabalho??"* Agora tem com, basta fazer `atuin sync` e pronto, seus históricos sincronizam!

Pra isso, no script de instalação eu rodo o `atuin register` que pede um username, email e uma senha (que, se não me engano, vai servir pra encriptar seus dados). E pronto, já vai sozinho se virar pra ficar sincronizando. Se já tinha conta, numa máquina nova basta rodar `atuin login` e logar. Só isso.

Ele substitui o `Ctrl + R` pra pesquisar no sqlite3 e agora seu histórico será muito mais robusto. Eu imagino que isso é mais importante ainda pro povo de devops. Eu lembro que rodava trocentos comandos de pods e containers e usava **MUITO** o histórico pra lembrar das coisas e repetir comandos. Fucem a documentação, tem como montar seu próprio servidor de Atuin pra onde sincronizar. Mesmo estando encriptado, talvez você queira 100% de controle. Tem como.

E por hoje é isso. Eu gostei bastante de brincar com o Omakub-MJ e meu PC pessoal com Manjaro GNOME e meu notebook com Windows 11 + ArchWSL já estão usando tudo exatamente como expliquei aqui. Novamente, leiam o [Manual do Omakub](https://manual.omakub.org/1/read#leaf_29) escrito pelo DHH, usem o Omakub dele caso estejam em Ubuntu, usem o [meu fork](https://github.com/akitaonrails/omakub-mj) pra Manjaro e Arch e não deixem de mandar Pull Requests ou Issues lá.
