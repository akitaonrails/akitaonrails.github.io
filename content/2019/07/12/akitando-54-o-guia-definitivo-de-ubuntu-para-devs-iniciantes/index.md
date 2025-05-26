---
title: "[Akitando] #54 - O Guia DEFINITIVO de UBUNTU para Devs Iniciantes"
date: '2019-07-12T17:00:00-03:00'
slug: akitando-54-o-guia-definitivo-de-ubuntu-para-devs-iniciantes
tags:
- linux
- ubuntu
- asdf
- tmux
- vim
- docker
- bash
- zsh
- yadr
- systemd
- debian
- flat-remix
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/epiyExCyb2s" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


No primeiro episódio técnico da série Começando aos 40 (https://www.youtube.com/watch?v=sx4hAHhO9CY) eu recomendei que todos estudassem Linux, e foi só isso. Hoje eu resolvi retomar o que eu disse e mostrar que em casa de ferreiro o espeto é de ferro!

Vou pegar um Ubuntu recém-instalado, e do zero ir até um ambiente completo para desenvolvedores de software (em particular Web, claro), com Docker, Tmux, Vim, ASDF e durante o percurso explicar várias coisas sobre Linux em geral, várias dicas, e até mesmo como customizar os temas pra ficar "dahura"!

As dicas estão espalhadas por todo o vídeo, então tente assistir o vídeo inteiro sem pular nada.

Até o momento esse deve ser o vídeo mais longo que eu já fiz, e eu fiz de propósito pra que seja facilmente compartilhável num link só! Compartilhe com o máximo de pessoas que puder!

E pra ninguém perder tempo, desta vez vou deixar listado aqui os tempos pra cada seção do vídeo pra que você possa pular direto pro que interessa caso já não seja mais tão iniciante ou se quiser relembrar alguma parte em particular:


== COMPLEMENTO

Esqueci de dizer que depois de instalar o dotfiles YADR os shortcuts de Tmux, Vim, Git mudam (vejam o código fonte!!). O Tmux em vez de Ctrl-B vira Ctrl-A por exemplo. No yadr-appearance.vim não use Solarized se quiser usar o Vim no Terminal (por alguma razão ele crasheia), troque por um "gruvbox" por exemplo. Pra abrir o NerdTree no terminal, use Ctrl+\

== ERRATA

Em 00:54:24 eu percebi que faltou um áudio, eu devo ter apagado por engano e só percebi agora que já subi. Era a introdução da seção de Docker e o texto era: "Tem gente que prefere não instalar esses serviços diretamente, pelo mesmo motivo que usamos ASDF. E se você tem um projeto antigo que depende do PostgreSQL 7 e quebra se tentar conectar no Postgresql 10? Pra isso precisamos de algo parecido com um ASDF. E se não me engano acho até que o ASDF tem suporte pra Postgresql, vamos ver no google, e sim, tem mesmo. Mas se for esse o caso eu prefiro fazer diferente. Serviços como os que acabamos de instalar é o caso de uso perfeito pra usar Docker. Então é hora de instalar e configurar Docker. E a essa altura você já adivinhou: vamos pro GOOGLE."


Em 00:03:00 eu falo que o Steam roda poucos jogos em Linux mas eu realmente me esqueci do Proton que é habilitado dentro da própria interface do Steam e você pode rodar os jogos quase que normalmente em Linux também! Eu mesmo não uso porque uso Steam no Windows mas fica a dica pra quem tem insegurança de mudar pra Linux e ficar sem Steam.

== Seções:

00:03:50 - Manjaro/Arch?
00:04:19 - Que hardware/notebook devo comprar pra programar?
00:08:46 - Que máquina Akita tem? Por que não comprar um topo de linha?
00:13:27 - Ubuntu: aprendendo sobre Workspaces
00:15:40 - Ubuntu: Tema Flat-Remix
00:18:19 - Linux: Conceitos e comandos básicos
00:22:59 - Linux: Entendendo os principais diretórios do sistema
00:28:41 - Linux: Entendendo Processos e manipulando arquivos e diretórios
00:40:42 - ASDF: Instalando e gerenciando versão de TODAS as linguagens!!
00:49:30 - Bancos: Postgresql 10, Redis, Memcached e MongoDB
00:54:24 - Docker: instalando, usando Postgres em container e mais!
01:00:21 - Básico do básico de criptografia, chaves SSH
01:05:52 - Básico de TMux e Vim
01:12:28 - Dotfiles: meu preferido, o YADR
01:17:22 - Configurações finais de Desktop


== Links:

* Upgrade Your SSH Key to Ed25519 (https://medium.com/risan/upgrade-your-ssh-key-to-ed25519-c6e8d60d3c54)
* How to install Flat-Remix Theme on Any Linux Distribution? (https://www.osradar.com/install-flat-remix-theme-ubuntu/)
* SWKP Dotfiles YADR (https://github.com/skwp/dotfiles)
* VIM Cheat Sheet (https://vim.rtorr.com)
* TMUX Cheat Sheet (https://tmuxcheatsheet.com)
* ASDF (https://github.com/asdf-vm/asdf)
* Understanding Shell Script's idiom: 2&#60;&1 (https://www.brianstorti.com/understanding-shell-script-idiom-redirect/)
* Upgrade Your SSH Key to Ed25519 (https://medium.com/risan/upgrade-your-ssh-key-to-ed25519-c6e8d60d3c54)
* Bash scripting cheatsheet (https://devhints.io/bash)
* Arguments against systemd (https://without-systemd.org/wiki/index.php/Arguments_against_systemd)
* Vim cheatsheet (https://devhints.io/vim)
* Tmux cheatsheet (https://devhints.io/tmux)

* AkitaOnRails: Optimizing Linux for Slow Computers (https://www.akitaonrails.com/2017/01/17/optimizing-linux-for-slow-computers)

Olá pessoal, Fabio Akita

Eu coloquei a série de vídeos Começando aos 40 numa playlist chamada Programação para Iniciantes, e que você pode assistir no link acima. Claro que não dá pra explicar “tudo”. Eu entro em mais detalhes em conceitos que eu sei que é muito mal explicado ou difícil de entender só lendo, como concorrência e paralelismo ou gerenciamento de memória, e meio que deixei implícito coisas que você facilmente encontra em meia hora de Google.


Eu imagino que pra quem está iniciando as coisas são bem menos óbvias do que pra quem já tem alguns anos na carreira. A primeira coisa que eu disse que você deveria tentar aprender é um pouco de Linux, em particular eu falei pra você tentar sofrer um pouco num Arch Linux por exemplo, e a recomendação continua valendo. Porém, e depois que você instalou o Arch ou mesmo qualquer outro Linux, como você continua e monta um ambiente de desenvolvimento suficiente pra começar a treinar programação?


Hoje vou seguir um pouco a tradição do meu blog, akitaonrails.com. Faz anos que mesmo quando eu estava no Mac eu não usava as coisas nativamente no ambiente UNIX do Mac, eu sempre preferi usar um Linux de verdade dentro de uma máquina virtual. Na época eu usava Vagrant que é um facilitador pra eu conseguir acessar essa máquina virtual localmente usando SSH. Apesar de parecer que todo desenvolvedor avançado usa Mac pra desenvolver, a menos que você seja um desenvolvedor de iOS pra iPhone ou iPad, você não precisa usar Macs.


Na verdade, o melhor ambiente de desenvolvimento sempre é um Linux. Especialmente se estamos falando de programação de aplicações Web. No final você sempre vai subir a aplicação num servidor da Amazon AWS ou Azure ou Google Cloud ou Heroku e sempre vai ser servidores Linux, por isso quanto mais perto do ambiente final de produção você puder estar, sempre vai ser melhor.


Mesmo num Windows, existem de fato versões de Python ou PHP e até Javascript pra Node.js que instalam e rodam nativamente em Windows. Mas não se engane, eles nunca vão funcionar 100%. Eu expliquei isso durante a série quando falei sobre como funciona compilação e dependências nativas. O comportamento é um pouco diferente e muitas bibliotecas que precisam de dependências nativas de Linux não tem similares em Windows. Na dúvida, evite as versões de Windows. Se for programar numa linguagem que se originou no mundo de código-aberto, use um sistema operacional baseado em Linux. No caso do Windows, em breve você vai poder desenvolver usando Linux usando o novo Windows Subsystems for Linux versão 2, mas mesmo ele vai precisar de uma máquina um pouco mais parruda porque vai rodar usando um hypervisor. Eu quero falar desse assunto em outro vídeo ainda.


Prefira instalar um Linux como sistema operacional primário e nativo na sua máquina. Na pior das hipóteses, faça um dual-boot com Windows 10 pra coisas como seus games de Steam. Sim, eu sei, Steam roda no Linux, mas a grande maioria dos principais jogos não rodam e os hacks que você precisa fazer com Wine e outras coisas pra conseguir rodar raramente compensa a menos que você seja geek de configuração como eu.


Isso tudo dito, o objetivo de hoje é partir de uma instalação de Ubuntu e chegar no final com um ambiente de desenvolvimento usável e demonstrar um pouco de como algumas coisas funcionam se você ainda é novato no mundo de Linux. Este episódio vai ser GIGANTE e tem múltiplas seções então pra você pode voltar depois pra seção específica que quer ver ou se quiser pular algumas partes, vou deixar os tempos de cada uma nas descrições abaixo.




(...)




Vamos lá. Eu pessoalmente prefiro usar a distro Manjaro que é uma versão de Arch mais simples de instalar. O que eu gosto em Arch é o gerenciador de pacotes Pacman e da filosofia de rolling updates, ou seja, que você não tem quebras entre versões major, tipo pular do Ubuntu 17 pro 18, ou do MacOS High Sierra pro MacOS Catalina. No caso das distros baseadas em Pacman, ele vai atualizando os pacotes continuamente, sem necessariamente dar grandes saltos que podem quebrar as coisas do nada.


A idéia de eu começar explicando pelo Ubuntu é porque a grande maioria das pessoas vai acabar chegando no Ubuntu primeiro e é um dos sistemas com mais suporte tanto de hardware quanto da maioria dos softwares então é o que possivelmente dê menos dor de cabeça para iniciantes. O Ubuntu 18 substitui o antigo gerenciador de janelas Unity pelo mais comum GNOME, que em termos de uso de memória é um dos mais pesados. Mas mesmo dizendo assim, hoje em dia, 300MB de RAM a mais ou a menos não é o que vai te fazer a diferença considerando que qualquer aba de Google Chrome vai consumir muito, mas muito mais que isso. 



A atual geração de aplicativos desktop usando Javascript e navegadores deixou tudo mais pesado, principalmente em termos de RAM. O mínimo que você precisa hoje em dia é de 8GB de RAM, de preferência invista mais um pouco e consiga 16GB de memória DDR4. Um processador Core i3 é possível de usar pra desenvolver, mas você gostaria de ter um pouco mais de cores se possível e eu recomendaria tentar investir pelo menos num Core i5 acima da 6a geração Skylake.



Pra quem não sabe, os processadores da Intel são divididas em gerações, depois da Skylake tivemos a 7a com Kaby Lake, 8a e 9a com Coffee Lake. Todas tem processadores i3, i5 e i7 e na 9a geração temos também i9. A diferença é principalmente número de cores, os i3 são só dual-core, os i5 e i7 pode ser dual ou quad-core. Os i9 acho que tem uns 10 cores. Outra diferença, se não me engano, é o tamanho dos caches L1, L2 e L3. E também suporte a Hyperthreading. Então um Core i7 quad-core pode ter 8 threads.



Se você estiver com dinheiro sobrando, monte um PC torre com Core i9 9900K com 32GB de RAM e 512GB a 1TB de SSD nvme2 como um Samsung EVO. Mas pra começar você pode ir com um Core i3 9320, 8GB de RAM, 128GB de SSD normal pra instalar o sistema operacional e 512GB de HD mecânico de 5400 ou 7200 rpm se possível. Não existe a necessidade de começar com a melhor máquina, na verdade eu recomendaria começar com uma máquina fraca. Não tão fraca pra ser nível Positivo porque ali acho que nem dá pra desenvolver direito. Mas um notebook como o Dell Inspiron 15 3000 com o Core i5-8265U Skylake, 8GB de RAM, 256 GB de SSD seria um dos melhores custos benefícios no Brasil em Julho de 2019, ao custo de R$ 3.500 em até 10x. Este vídeo não é patrocinado pela Dell mas eu mesmo já usei um notebook desses e dá pra desenvolver num desses com muita sobra, pra maioria dos programadores, especialmente iniciantes. Existem opções mais baratas, mas você vai sacrificar em algum lugar.



Pro povo mais avançado eu sei que depois de falar tanto de Intel já já vai aparecer comentário de “mas e os AMD Ryzen”? Sim, nos anos recentes a AMD começou a voltar ao jogo das CPUs e as CPUs Ryzen são muito boas, particularmente pra multithreading porque ele vem com mais cores se comparado com equivalentes de preço da Intel. Então um AMD Ryzen 3 já vem com 4 cores comparado ao Intel Core i3 de 2 cores. O Ryzen 5 vai de 4 a 6 cores. O Ryzen 7 tem 8 cores. O Ryzen 9 tem até 16 cores e você ainda tem o Ryzen Threadripper que vai até 32 cores. Apesar de ter mais cores, a performance máxima de cada core ainda era menor se comparado aos da Intel, e em particular ele não superava a Intel em games, mas a nova geração deste ano está ultrapassando a Intel até em games!



Ou seja, por um preço menor você conseguiria comprar um Ryzen equivalente e seria mais barato e mais performático que a 9a geração da Intel. As CPUs da Intel tem o Turbo Boost que ativa quando você está fazendo algo particularmente intensivo de CPU, por exemplo compilando projetos gigantes em C e C++ que costuma exigir muito da CPU. Ou então em coisas como renderizar cenas 3D num Blender ou exportar vídeos no Adobe Premiere. O problema é que Turbo Boost costuma ser um pico de curta duração. Nos novos Ryzen eles tem o Precision Boost que aumenta o clock numa faixa menor que da Intel mas entrega essa velocidade maior por mais tempo e no geral pode te dar performance maior em períodos de grande carga. Ou seja, os Ryzen vieram atropelando a Intel nesses últimos 2 ou 3 anos. Se você encontrar boas configurações com Ryzen, especialmente pra nós de desenvolvimento de software, eu recomendo.




Muita gente que tá começando sonha com um Macbook Pro, ou um Surface Book ou algo caro assim. Eu pessoalmente tenho um Surface Book 2 e um Lenovo Extreme. Junto com o Macbook Pro são notebooks na faixa dos USD 3000 se comprar nos Estados Unidos, ou seja, máquinas que facilmente custam na faixa dos R$ 15 mil no Brasil se comprar no mercado negro. Vai por mim, você não precisa disso. Então, por que eu tenho? Sendo curto e grosso: porque eu posso. Mas faça as contas, eu tenho 42 anos, se a essa altura eu não pudesse, pelamor né.



Pra dar perspectiva, quando eu tinha uns 25 anos eu comprava meus notebooks via contrabandista de Miami mesmo, como todo mundo faz hoje também. Eram máquinas mais fracas, como os antigos Toshiba Sattelite em 2002. Acho que eram Pentiums com 512MB ou 1GB de RAM. Eu falei que estamos na 9a geraçao da Intel, mas a série de processadores Core da Intel só iria começar a sair a partir de 2006. SSD ainda não existia. E Java naquela época já era quase tão pesado quanto é hoje. Na verdade hoje eu sinto o Java super leve em comparação como que eu sofria em 2002.



Ao longo dos anos eu fui crescendo na carreira e trocando pra computadores mais potentes. Nunca se compare com alguém como eu que já tem quase 30 anos de carreira. Além disso ter um computador topo de linha não vai te beneficiar em muita coisa se você não sabe como tirar proveito de uma máquina dessas. Em janeiro de 2017 eu decidi usar um Dell Inspiron que comprei numa promoção da Magazine Luisa eu acho, um pouco melhor do que o que eu sugeri agora a pouco, mas não muito, e com HD mecânico. Eu queria ver o quanto eu conseguia otimizar o Linux pra performar nesse ambiente e escrevi um longo tutorial sobre o que é possível fazer e você pode ver nos links na descrição abaixo. E eu fiquei usando essa máquina como minha máquina primária por alguns meses sem grandes problemas.



Em toda profissão de prática eu acho que todo iniciante deveria começar num ambiente mais hostil. Não digo em ambientes impossíveis, mas longe do topo de linha. Um cara que consegue desenvolver bons software e ter produtividade em um Core i3, com 4GB de RAM, imagine o que ele vai conseguir fazer com um Core i9 e 32GB de RAM. 




Por outro lado se um programador amador ruim com 32GB de RAM só vai entregar software vazando memória. Um programador que não tem interesse em otimizar e aprender mais sobre seu próprio ambiente de trabalho não faz sentido pra mim. Amanhã ou depois você vai ter um problema em produção e vai precisar tirar o máximo possível dos servidores e outros recursos que tem. Se você sequer sabe como otimizar seu próprio computador, como você espera conseguir otimizar qualquer outra coisa? Tudo faz parte do treino, todo conhecimento conta. Comece a se interessar em abrir o capô e mexer na mecânica do seu carro em vez de só dirigir e ficar de braços cruzados quando o carro não quer pegar. Nese caso você vai ser só um motorista, bons programadores dirigem e consertam o próprio carro.



Isso tudo dito, instalar um Ubuntu é simples, beira o trivial a menos que você tenha um hardware muito fora de padrão. Basicamente baixe a ISO do site, grave num pendrive USB usando ferramentas como o Rufus no Windows, boote pelo pendrive e siga as instruções. Primeira coisa que você precisa aprender a fazer: ler a porcaria das instruções e não só ficar apertando próximo, próximo, como minha avó faria. Metade dos erros que os programadores iniciantes travam são trivialmente resolvíveis só lendo o que aparece na tela. Leia as fucking mensagens de erro!! 



Bom, essa parte você vai ter que seguir um tutorial como o que eu deixei linkado nas descrições abaixo. No meu caso eu estou usando Windows 10 como sistema operacional principal e por isso vou instalar o Ubuntu numa máquina virtual usando VMWare Workstation. Em outro vídeo explico porque eu uso Windows como máquina principal, mas deixando isso de lado, a instalação costuma ser muito simples. Em hardware não tão antigo (pelo menos de uns 5 anos pra cá) qualquer distro moderna de Linux deve ser capaz de identificar tudo e instalar e configurar os drivers corretos. Se por acaso você tem um hardware muito fora de padrão e não for detectado, minha sugestão é simples: ache um canto aí no seu quarto, deita em posição fetal e chora um pouco. .. chorou? Bom, agora você vai ter que ir no Google, ou direto em sites como o ArchWiki ou Stackeroverflow e sair procurando. Bom, pense que isso faz parte do aprendizado também. Eu não consigo ajudar porque não tem como eu mostrar aqui todas as variações diferentes de todos os tipos de hardware que existem. 


(... PARTE B - SCREENCASTS)


Depois que terminar de instalar esta é a tela que você vai ver. O instalador já vai ter criado uma conta pro seu usuário e você pode optar por logar automaticamente nela. Você pode customizar o que quiser mas uma das mecânicas que eu recomendo que você se habitue é navegar por workspaces. Por muitos anos só desktop managers de UNIX e Linux como os antigos baseados em Motif ou os mais atuais como Cinnamon, XFCE, KDE e GNOME que é o que o Ubuntu usa hoje em dia possuem o recurso de workspaces, que é como se você tivesse mais de um monitor. Demorou algumas décadas mas finalmente hoje em dia nos MacOS e Windows você também tem isso. Mas no Ubuntu funciona assim. Vamos abrir alguns programas pra ter algumas janelas pra mostrar. Vamos abrir o Nautilus que é como o Finder no Mac ou Explorer no Windows, vamos abrir o Firefox que já vem pré-instalado, vamos abrir o Terminal apertando a tecla Super e digitando Terminal que é outro jeito de abrir programas.



Agora você tem a situação em que tem muitas janelas no mesmo monitor, ou no caso no mesmo workspace. Então vamos mover o Firefox pra outra workspace usando a combinação Super + Shift + Page Down e boom, agora o Firefox está na worspace de baixo. E eu posso voltar pra workspace de cima com Super + Page Up e Super + Page Down. E eu posso ficar movendo janelas entre os workspaces com Super + Shift e Page Up ou Page Down. Mais do que isso, já que estamos falando de janelas, agora que o Firefox está num workspace só dele, podemos maximizar a janela toda usando Super + seta pra cima. Ou voltando pra primeira workspace podemos maximizar na metade da esquerda usando Super pra esquerda ou Super pra direita, e assim podemos ter janelas lado a lado organizado. Treine bastante essa combinação de teclas porque costuma ser bem útil pra manter seus programas organizados. A idéia é ter conjuntos de programas relacionados no mesmo workspace. Por exemplo, você pode ter uma com Slack e Discord, outro de trabalho que tem Terminal e Sublime Text e assim por diante.



Mas você veio até o Linux não por causa do ambiente gráfico, senão ficaria no MacOS que ainda é o melhor ambiente gráfico que existe. Você veio por causa do que tem por baixo do capô e a porta de entrada pra isso é o Terminal. Se você nunca mexeu num Linux precisa aprender alguns conceitos muito básicos. De novo, a idéia não é ser um tutorial completo mas só mostrar o principal, isso dito, vamos abrir o Terminal de novo, maximizar e aumentar as fontes pra vocês conseguirem enxergar.


Aproveitando, eu sou um pouco exigente com meu ambiente e apesar de não achar o tema do Ubuntu particularmente feio, eu prefiro um tema mais elegante do que esse laranjão todo, e um dos mais usados parece ser o Flat Remix. Vou deixar o link nas descrições abaixo, mas na prática poderíamos instalar pelos pacotes de atp mas vou instalar o Git pra baixar do Github pra mostrar como instala manualmente. Então a primeira coisa vai ser `sudo apt install git gnome-tweak-tool fonts-hack-ttf` pra instalar não só o Git como o Tweak Tool do Gnome pra trocar o tema e minha fonte monospace preferida que é a Hack. Em seguida vamos criar um mkdir Projects e cd Projects pra onde podemos baixar nossos códigos. 


Agora vamos clonar o repositório de icones do Gihub git clone https://github.com/daniruiz/flat-remix e em seguida vamos clonar o tema com git clone https://github.com/daniruiz/flat-remix-gtk. Agora vamos criar alguns diretórios com mkdir -p ~/.icons && mkdir -p ~/.themes e copiar os arquivos que baixamos pra lá com cp -r flat-remix/Flat-Remix* ~/.icons/ && cp -r flat-remix-gtk/Flat-Remix-GTK* ~/.themes/ Pronto, podemos abrir o Tweak Tool e mudar pro tema e os ícones para o que queremos, vamos aproveitar e trocar a fonte monospace pela Hack e mudar o wallpaper pra alguma coisa mais agradável. Viu só? Podemos trocar totalmente o look and feel e existem centenas de temas e coleções de ícones. Eu encorajo vocês a procurarem pelo visual com que mais se identificam e começar a tornar o sistema operacional mais próximo de você. Outra sugestão, se quiserem procurar é o conjunto de temas chamado Material, testem o Material Dark que também fica bacana.




Como eu disse antes, o instalador criou já um usuário pra você e cada novo usuário ganha um diretório próprio. Esse diretório fica em /home seguido do seu username. No caso o meu é akitaonrails e se você ficou com dúvidas de quem você é, você pode perguntar pro Linux com o comando `whoami`. A navegação por diretórios é usando o comando `cd`. Todo diretório tem 2 entradas padrão, o “.” que representa onde você está agora e o “..” que é o diretório anterior. Pra saber quais diretórios existe você usa o comando `ls` ou pra ter uma listagem mais completa faz um `ls -l` ou `ls -la` que vai te mostrar os diretórios e arquivos escondidos. O que determina o que é escondido ou não é só se o nome começa com ponto. Daí por padrão não vamos ver esses arquivos em programas como o Nautilus que falei antes.


*
Você pode criar arquivos de diversas formas, mas a mais simples pra criar um arquivo vazio é usar o comando `touch` que literalmente vai tocar o arquivo. Se já existir ele vai atualizar a data e hora de última modificação, se não existir, ele vai criar o arquivo. Aliás, pra todo comando do Linux, se você quiser rapidamente ver o que ele faz exatamente e quais opções o comando aceita, use o comando `man` que significa “manual” e não “homem”. Falando nisso, a maioria dos comandos e nomes legados de UNIX são acrônimos de poucas letras não porque a gente é masoquista, mas primeiro porque digitar comandos longos demora mais e segundo porque você precisa digitar esses comandos num terminal remoto dos anos 60. Era uma época onde você apertava uma tecla e tinha que esperar um pouquinho pra registrar no servidor e aparecer na tela, então era meio maçante ficar esperando. Se eu fosse simular seria mais ou menos assim (DELAY DIGITANDO)


*
Por isso os nomes são curtos. E pra piorar cada letra a mais que você escreve consome 1 byte (ou 2 hoje dia). Lembra quando eu contei sobre a história dos computadores eu mencionei que os grandes mainframes da época gravavam em fitas que tinham só algumas centenas ou milhares de Kbytes. Ou seja, cada letra contava. Hoje em dia não existe mais essa preocupação. De qualquer forma você precisa ir aprendendo o que significa cada comando. O comando `cd` pra mudar de diretório obviamente é change directory, o mkdir pra criar diretório é make directory, o comando `rm` pra apagar é remove, o comando `chown` é change ownership e assim por diante.



Você já sabe whoami pra saber “quem eu sou” no sistema, e pra saber onde estamos podemos usar o comando `pwd` que significa print working directory ou imprimir o diretório corrente. E vemos que estamos no /home/akitaonrails. Se navegarmos pra algum lugar aleatório no sistema como cd /usr/local e quisermos voltar pra nossa casa podemos fazer cd $HOME onde o cifrão denota uma variável do ambiente e você que é de Perl ou PHP deve estar mais familiarizado com essa notação. Mas cd $HOME é muito comprido, em vez disso podemos usar o atalho cd ~ til ou tilde que o shell vai expandir para o que estiver na variável $HOME e por isso chamamos isso de tilde expansion. Toda vez que você escreve ~/Documents o shell vai expandir pra /home/akitaonrails/Documents. Pra provar isso o comando echo do shell mostra a variavel, então echo $HOME mostra o diretório de casa e echo tilde também. Pra ir pro diretório de Downloads a partir de qualquer lugar basta fazer cd ~/Downloads. Se for só pra voltar pro diretório de casa nem precisa do tilde, só `cd` também funciona. 


*
Quando falamos shell, na grande maioria dos casos estamos falando do famoso Bash, o Bourne Again Shell que eu mencionei no vídeo de Sua Linguagem não é Especial. Existem diversos outros shells como o tcshell e muitos desenvolvedores usam o Z shell que vou mostrar mais na frente. Mas quando executamos comandos no shell que é nossa linha de comando podemos estar executando binários do sistema, scripts com permissão de execução ou comandos diretos do Bash ou o shell que estivermos, isso pode confundir um pouco se você não souber qual dos 3 você está executando, comecem a prestar atenção nisso. 



Voltando aos diretórios, se navegarmos pra raíz com cd / e listar o que tem lá podemos ver alguma coisas interessantes. Evita modificar qualquer coisa fora da sua home sem saber pra que serve. Bem na raíz temos só dois arquivos, esse vmlinuz e o initrd.img. Na verdade ambos são links simbólicos pra arquivos que estão no /boot. Um link simbólico é um atalho, o arquivo real mesmo está no diretório /boot como pode ver. O binário vmlinuz é o kernel do Linux propriamente dito, o primeiro binário que vai carregar logo que a máquina bootar e vai começar a carregar o sistema operacional e coisas como drivers. E o initrd.img é o segundo binário que vai carregar logo na sequência subindo um RAM disk. O vmlinuz tem só o mínimo necessário pra bootar e o resto dos módulos vem desse RAM disk carregado a partir do inird.img. É uma convenção de sistemas derivados de Debian como é o caso do Ubuntu. O motivo de ser um symbolic link ou symlink é que daí no diretório /boot podemos ter kernels de múltiplas versões e mudar de um pra outro só mudando o symlink se quisermos testar uma versão mais nova mas sem jogar fora a versão anterior.




Se listarmos o ls /dev podemos ver todos os dispositivos ligados nesta máquina. Alguns desses dispositivos serão coisas como drives USB, pendrives, cdroms ou até mesmo floppys. Pra gente poder gravar ou ler alguma coisa de um desses dispositivos precisamos primeiro “montar” eles com um sistema de arquivos como exFAT ou NTFS se for de Windows ou HFS+ se for de Mac ou ext4 se for de Linux e quando eles são montados normalmente criamos um subdiretório no /mnt ou /media. A maioria dos Linux modernos tem serviços pra montar automaticamente quando inserimos um USB e essas configurações ficam no arquivo /etc/fstab e podemos ver que ele tem a configuração pro caso de alguém inserir um disquete. 



Vamos brincar um pouco. Se usarmos o comando df -h podemos listar os dispositivos que estão montados e quais são os pontos de montagem, veja o / por exemplo. Agora vamos plugar um pendrive e rodar o mesmo comando. Olha como o Ubuntu já automaticamente detectou e montou corretamente em /media/akitaonrailks/KINGSTON que era o nome do pendrive. O dispositivo de verdade está em /dev/sdb1 mas não adianta tentar executar comandos como cd ou ls nele porque não tem um sistema de arquivos ali, só no ponto de montagem. A menos que você esteja escrevendo um programa de mais baixo nível, você quase nunca vai mexer no que tem nesse /dev onde dev significa device ou dispositivo, e sim no que é montado em /media ou /mnt. 


Seguindo, o /root é o equivalente home do usuário root que é o administrador da máquina, ainda temos o /opt onde alguns programas de fora podem ser instalados. No /sbin ficam muitos dos binários do sistema operacional. O programa shutdown fica lá. Programas pra gerenciar discos como fdisk pra reparticionar discos, o fsck pra checar o disco, o mkfs pra formatar, ifup e ifdown pra subir e derrubar placas de rede e coisas assim. No /bin fica outros programas do sistema como o próprio bash e outros shells, coisas simples como o cp pra copiar arquivos, chown e chmod pra mexer na permissão de arquivos, todos os programas pra navegar e criar diretórios como mkdir pra criar diretórios e rmdir pra remover diretórios, ou o próprio rm que apaga arquivos e vários outros são todos binários nesse diretório.


O diretório /usr é um dos maiores e onde fica a maior parte das aplicações que você instala. Ele significa Unix System Resources mas na prática você pode pensar nele como user ou programas dos usuários. Por exemplo, o X, os aplicativos do GNOME, o Firefox, todos esses binários ficam em /usr/bin, suas bibliotecas de dependência ficam em /usr/lib, se eles instalam código fonte junto deveria ficar em /usr/src, se você instala os pacotes -dev que trazem os arquivos de header em C ou C++ pra quando você precisa compilar dependências ficam em /usr/include e antigamente tinha o /usr/etc pra arquivos de configuração mas hoje em dia acaba ficando tudo em /etc ou em diretórios escondidos como .config no seu home pra configuração exclusiva do usuário. 


Etc não tem um consenso de o que exatamente significa mas a maioria gosta de pensar que significa literalmente etcetera, bem coisa de programador mesmo. Finalmente temos o diretório /var contém dados variáveis, então antigamente a gente usava o /var/spool pra ser o a bobina de impressão quando a gente usava impressora, o /var/mail pra e-mails, o /var/log é onde vai todos os principais logs do sistema, o /var/run tem PIDs que são os IDs dos processos sendo executados, o /var/cache como o nome diz serve pra alguns caches do sistema.



Falando em processos, temos o /proc. Se você usar o comando ps consegue listar os processos dos aplicativos que estão em execução e eles tem um ID numérico. No diretório /proc esses processos são representados como diretórios e você pode fuçar ali. Por exemplo, vamos achar o PID do nosso shell Bash com `ps` e ir pro diretório dele com `cd /proc/aaaaaa` e se dermos ls podemos ver vários pseudo-arquivos que não são exatamente como um arquivo de texto que você cria mas do ponto de vista do sistema operacional, podemos operar neles como se fossem. Por exemplo, podemos usar o comando `less` pra fuçar esse arquivo chamado status ou esse arquivo chamado io pra ver um pouco das características desse processo em particular. Se você quiser entrar a fundo no mundo baixo nível, vai achar esse tipo de coisa particularmente interessante. Na prática, pra gente não tem muita coisa pra fazer aqui a não ser fuçar mesmo, mas se em algum momento você precisar fazer um programa que busca informações sobre os processos em execução, é por aqui que você vai começar. Em vez de ter alguma API complicada do sistema operacional, você pode fuçar tudo como fuçaria qualquer diretório e arquivos.



E falando nesses outros comandos, vamos aprender mais alguns comandos. Pra não sujar seu diretório vamos pro diretório /tmp na raíz do sistema. O /tmp é o diretório pra onde vai coisas temporárias que o sistema não garante que vão estar lá depois do próximo boot, por isso é bom pra gente jogar coisas que não nos importamos se perder. Então vamos fazer o seguinte exercício:
```
cd /tmp
touch a.txt
```
serve pra tocar um arquivo como já expliquei, nesse caso vai criar um novo
```
echo "hello world" > a.txt
```
	O echo serve pra escrever qualquer coisa no standard output, normalmente pro próprio shell mas aqui estamos conectando o standard output pra um arquivo com esse simbolo de maior. Então o hello world vai pra dentro do arquivo a.txt
```
cat a.txt
hello world
```
	O cat significa concatenate e serve pra concatenar arquivos mas vira e mexe usamos pra ver o conteúdo de arquivos pequenos. Evite usar cat pra arquivos grandes porque ele precisa ler tudo pra memória antes de mostrar
```
echo "fabio akita" > a.txt
cat a.txt
fabio akita
```
	Se fizermos a mesma coisa com outro texto vamos ver que acabamos sobrescrevendo o que tinha antes. Então toda vez que você redireciona o standard out pra um arquivo desse jeito o conteúdo anterior morre. Mas podemos ir apendando ao fim do arquivo em vez de sobrescrever desse jeito:
```
echo "hello world" >> a.txt
cat a.txt
fabio akita
hello world
```
	Com o maior e maior agora podemos ir concatenando no fim do arquivo.
```
more a.txt
fabio akita
hello world
```
	O comando more aqui fez a mesma coisa que o cat. A diferença é quando você faz isso com arquivos maiores do que cabe na tela. Vamos dar um exemplo:
`Ps aux`
	Esse comando lista todos os processos rodando no sistema, incluindo os que não foi você que iniciou e sim o initd do sistema operacional e outros serviços. Você pode ver como ele não cabe na tela e você precisa scrolar no terminal pra ver o começo. Usando o comando more temos o seguinte:
`Ps aux | more`
	Essa é uma das características marcantes dos UNIX e Linux: a capacidade de ligar o standard output de um comando ao standard in de outro comando usando o simbolo de pipe que é essa barra vertical. Eu expliquei sobre isso na minha série de Começando aos 40, por isso falei pra assistir. Mas veja como aqui ele começa a listar e pára na primeira tela e agora eu posso ir avançando aos poucos. O more é um comando antigo e primitivo, ele primeiro precisa carregar todo o conteúdo em memória pra depois ir mostrando tela a tela. Não é muito eficiente e não recomendo que faça isso com arquivos de log de gigabytes por exemplo. Na prática, você não precisa usar nem cat e nem more, existe uma versão mais moderna, o less:
`Ps aux | less`
	O less faz a mesma coisa que o more, deixa você navegar por conteúdos longos que não cabem numa tela. Porém ele faz isso baseado em streams, como eu também expliquei na minha série. Em vez de carregar tudo na memória, ele vai puxando do stream só o que precisa pra preencher uma tela e navegar. Mais do que isso ele permite usar alguns dos mesmos comandos de navegação do editor de textos VI. Então você pode usar j k como cima, baixo,, você pode digitar “gg” minúsculo pra voltar pro topo do arquivo, pode digitar 10j pra descer 10 linhas ou 5k pra subir 5 linhas. E pode digitar barra com uma palavra que quer procurar e ir descendo usando n. E finalmente digitar q de quit pra parar.
`Ln -s a.txt b.txt`
	Eu falei de links simbólicos ou symlinks antes e é assim que você cria: ln -s arquivo de origem e nome do symlink. Agora esse b.txt é só um atalho mas você pode usar ele como se fosse um arquivo, por exemplo se fizermos cat b.txt veremos o mesmo conteúdo de a.txt. Mas podemos fazer mais ainda.
`tail -f b.txt`
	Tail é um comando pra ver o final do arquivo, você pode fazer tail -10 pra ler a 10 últimas linhas, ou pode fazer tail -f pra se pendurar no final do arquivo.
	Pra demonstrar vamos abrir outro terminal e começar a apendar coisas no arquivo a.txt.
`echo “foo” >> a.txt`
	Estão vendo como eu estou mandando coisas pro fim do arquivo a.txt mas o tail do symlink b.txt vai me mostrando o que está sendo gravado? São coisas assim que tornam o Linux um bicho diferente. Comandos como tail -f são super úteis quando você quer ficar monitorando um arquivo de log em produção por exemplo.
	Eu mostrei rapidamente como podemos usar comandos como ps pra mostrar informações dos processos em execução, você pode pesquisar mais sobre os binários que estão nos diretórios /sbin ou /bin ou /usr/bin como falei antes. Mas com o conceito de pipes podemos ir mais longe e conectar o standard output de um comando ao standard input de outro comando. Por exemplo, vamos fazer
`Ps aux | grep bash`
	E isso vai filtrar a saída do ps pra só mostrar as linhas que tem a palavra bash. O grep é um comando antigo que permite processar texto usando regular expressions similares de Perl 5. Hoje em dia usamos outros como o ag, que é o silversearcher. Ele aceita regex similares mas é muito mais rápido que grep. Se você não entendeu porque chama silversearcher é porque AG é o símbolo pra prata na tabela periódica. Mas digamos que estamos interessados em pegar os IDs de processo, os PIDs dos processos bash. Podemos ver que é a segunda coluna. Como filtramos por coluna? Uma das muitas opções é usar o AWK que é outra ferramenta super tradicional de UNIX e Linux e colocar outro pipe no fim desse comando:
`Ps aux | ag bash | awk ‘{ print $2 }’`
	Olha o que aconteceu! Por padrão ele splita as linhas pelo separador padrão que é espaço, mas podemos configurar outros separadores incluindo regex também. O AWK é uma linguagem de programação interpretada, como um Perl, voltado a processar dados e textos.
	Finalmente, digitamos vários comandos, e talvez você não se lembre de cor de tudo que digitou, ninguém lembra. Por isso shells como o Bash tem history, todos os comandos que você digitou até agora ficam gravados. Basta ir apertando a seta pra cima pra navegar pelos últimos comandos. Mas e se você quer lembrar dum comando que digitou sei lá, 2 semanas atrás? Se ficar apertando seta pra cima vai ficar fazendo isso até amanhã. Pra isso o Bash tem um atalho, digite Ctrl R e comece a digitar uma parte do comando. Agora vai apertando Ctrl R pra navegar pelo histórico filtrado pelo que acabou de digitar. Viu só?
	De bônus deixa eu mostrar os últimos comandos que você precisa. Pra apagar um arquivo você faz: rm b.txt. Podemos criar um diretório com mkdir foo. Podemos mover um arquivo pra lá com mv a.txt foo. Se quisermos apagar um diretório só rm foo não funciona. Pra isso precisamos força com rm -f foo. E pronto, você já sabe o básico de como manipular diretórios, arquivos e comandos. Um comando que é complexo é o chmod e a regras de permissão mas por hoje entenda que todo binário ou script, pra ser executável precisa ter permissão de execução e a forma que você dá essa permissão é via o comando chmod +x seu_script.sh
A partir daqui é com você!



*
Veja e reveja essa demonstração que eu acabei de mostrar caso você seja um iniciante. Esses são os conceitos mais importantes que você precisa dominar pra seguir em frente. E dominar significa chegar num ponto em que você sequer pensa mais nisso. Se você usar o Nautilus que é que nem o Explorer, dá pra fazer tudo isso com o mouse. Arrastar, apertar F2 pra renomear ou DEL pra apagar um arquivo. Não tem problema. Mas quando você se conectar remotamente num servidor você não vai ter ambiente gráfico, só um shell. E por isso você precisa saber esses comandos. Mais do que isso, você precisa aprender a combinar os comandos como mostrei aqui com pipe pra fazer coisas como mover só arquivos com determinada nomenclatura pra outro diretório por exemplo, ou só arquivos que tenham determinado conteúdo. 



*
E quando você precisa manipular muitos arquivos com critérios mais complicados assim, é onde programar scripts de Bash começa a fazer sentido. E sim, o Bash em si é um ambiente de programação que tem variáveis, comandos como if, e você pode executar um script que automatiza tudo pra você. E, claro, você pode combinar o Bash com outras linguagens como o AWK ou mesmo Perl, Python, Ruby ou outras linguagens e com alguns dos conceitos que mostrei pra vocês como saber que você tem seus dispositivos em /dev, seus processos representados em /proc, suas configurações em /etc e assim por diante, você pode fazer scripts que manipulam seu sistema inteiro. Aí você começa a se sentir realmente o dono da sua máquina. Tem bastante coisa pra estudar aqui.


*
Falando em outras linguagens de programação. Chegou a hora de avançarmos mais rápido e montarmos de uma vez esse ambiente. Como eu falei antes, até este ponto na instalação seu Linux está bom pra ser usado por usuários comuns. Mas pra virar sistema de desenvolvimento a primeira coisa que você precisa instalar são compiladores e todas as dependências de desenvolvimento do sistema. Pra isso vamos instalar os seguintes pacotes:

```
sudo apt install build-essential default-jdk libssl-dev exuberant-ctags ncurses-term ack-grep silversearcher-ag fontconfig imagemagick libmagickwand-dev software-properties-common git vim-gtk3 curl
```


*
O principal pacote é o build-essential que como o nome diz tem todo o essencial pra fazer builds. Aproveito também pra já instalar o JDK pra termos não só a JVM como o compilador do Java mais novo. Poderíamos instalar outras linguagens com o APT também como Ruby ou Python e outras, mas você precisa entender um problema desta atualidade de 2019. Linguagens mais antigas e mais estáveis como C, C++ e Java mudam com pouca frequência. De vez em quando sai patches de segurança mas não mudanças que quebram compatibilidade. Uma vez a cada X anos o C muda. Por isso é bom instalarmos via gerenciador de pacotes. Porém outras linguagens como Go ou Javascript mudam com muito mais frequência e os pacotes de distros Linux normalmente não acompanham tão de perto porque os objetivos são diferentes: as distros preferem manter versões estáveis, que já foram testadas em produção, que já receberam correções de bugs. Mas nós desenvolvedores preferimos ter acesso às versões mais instáveis justamente porque precisamos testar as coisas novas mesmo se não formos usar em produção.

*
Pior, nós trabalhamos em diversos projetos diferentes. Alguns projetos são novos e usam, por exemplo Ruby 2.6.3. Mas às vezes precisamos dar manutenção em projetos de 3 ou 4 anos atrás que podem estar ainda num Ruby 2.4.4 por exemplo. Significa que precisamos ter todas essas versões instaladas na nossa máquina ao mesmo tempo. O mesmo vale pra Javascript ou outras linguagens. Mas o gerenciador de pacotes de uma distro Linux só gerencia uma versão. Depois que ela atualiza, a versão antiga não existe mais. Então precisamos de um jeito por fora pra gerenciar isso. Ao longo dos anos cada linguagem veio construindo seu próprio gerenciador de versões como o RVM e RBENV no Ruby, ou o NVM do Javascript, ou o Virtualenv do Python. Mas também é um saco ter que ficar lembrando as sintaxes e configurações de tantas ferramentas diferentes. E pra nos salvar surgiu o gerenciador de versões Universal, o ASDF. Vamos instalar pra vocês verem.


(...)


Aliás, aprendam a usar o Google. Olhem como eu vou fazer. Eu falei ASDF, é um nominho que pode confundir o Google, coloquem github como termo se precisar. Vamos seguir o que diz na documentação pra instalar.

-- instalar via Google


O truque do ASDF é usar variáveis de ambiente do shell. Quando você digitar ruby ou npm, ele não vai executar diretamente o binário chamado ruby. Na verdade ele vai procurar no PATH. Eu não falei de PATH então vamos dar echo no PATH. Tudo que você digita no shell, se não for uma instrução do próprio Bash ele entende como sendo um binário executável e vai procurar por ele nos diretórios listados nesse PATH. Você pode tentar saber de onde o Bash está executando determinado binário usando o comando `which` por exemplo o tal echo que acabamos de fazer se digitar `which echo` vemos o PATH completo dele, e aliás, o echo é um binário do sistema e não instrução de Bash.


Pra ficar mais fácil de gerenciar, o ASDF em si é um framework, ele não tem suporte a linguagem nenhuma. Em cima do ASDF precisamos instalar plugins. Então vamos instalar os diversos plugins pras linguagens. Leia as instruções. No caso de Javascript vemos que ele tem comandos pra instalar chaves públicas pra validar a instalação. No caso de Erlang vemos que ele manda instalar várias dependências do sistema, siga as instruções. linguagens, javascript, golang, erlang, elixir, kotlin, rust, crystal


Pronto, agora que instalamos os diversos plugins, podemos instalar as linguagens em si. Usamos o comando list-all do asdf pra listar quais versões estão disponívels pra instalar daí podemos fazer asdf install linguagem versão pra instalar a que queremos. Então vamos lá instalar o Ruby primeiro. Ao terminar, agora precisamos declarar que queremos usar essa versão e pra isso fazemos asdf global ruby 2.6.3 e se digitarmos ruby -v vemos que agora o Ruby está disponível. Dentro de um projeto antigo podemos usar asdf local ruby 2.4.4 depois de instalar a versão 2.4.4 pra só dentro daquele projeto ele escolher o Ruby mais antigo. E com isso resolvemos nosso problema de ter projetos que dependem de versões diferentes. Agora vamos fazer a mesma coisa pra todas as outras linguagens, javascript, golang, erlang, elixir, kotlin, rust, crystal


Digitem asdf help pra ver outros comandos mas os próprios plugins podem precisar de atualização e pra isso podemos fazer asdf plugins-update. E pra atualizar o asdf de vez em quando podemos fazer asdf update. Agora, se fizermos `which ruby` vemos que ele executa um script nesse diretório de reshims. Todo script executável que um ruby instalaria talvez num /usr/local/bin agora é instalado nesse reshim. Um NPM do javascript também ou outro pacote de Javascript como yarn que você instala com a flag de -g pra global. Se por acaso você instalar uma biblioteca que deveria ter um executável no PATH como webpack ou yarn mas ele não é encontrado quando você digita, pra garantir que está tudo bem, digite asdf reshim pra ele recriar esses shims, que são como proxies.

*
De qualquer forma, agora que instalamos e declaramos quais versões queremos que estejam ativas globalmente, temos acesso a todas as linguagens que quisermos. Em particular essas são as linguagens que mais me interessam hoje em dia. Mas existem dezenas de outros plugins pra tudo que é linguagem que você imaginar. Tem até coisas velhas como Prolog ou linguagens modernas como Julia. Procure e instale o plugin que você precisa e divirta-se.



(...)


*
Agora que instalamos todas as linguagens, vamos instalar alguns serviços que você provavelmente vai precisar. Eu sempre gosto de deixar instalado o Postgresql, o Redis e o Memcache. Um banco de dados relacional decente, um nosql que faz o mínimo que precisamos, e um cache pra quando não precisamos do Redis como banco. Tá, vou deixar instalado o Mongodb também, mas se você viu minha série de devops já sabe que eu não recomendo que você escolha Mongo como banco primário sem saber se realmente precisa. E normalmente não só você não precisa como você pode acabar usando o Mongo onde na verdade o mais adequado teria sido o Postgresql. Na dúvida, sempre escolha o Postgresql como padrão, nunca o Mongo, nem muito menos o Redis. Redis é um bom cache. E Mongo é bom pra dados que se você perder, não vai fazer muita falta, como dados de analytics ou logs.


```
sudo apt install postgresql-10 postgresql-contrib postgresql-server-dev-10 redis-server libhiredis-dev memcached libmemcached-dev
```


Pra instalar o Mongo precisamos seguir as instruções do site oficial. Nem vou deixar o link nas descrições, vocês precisam aprender a fazer um google por mongo install ubuntu 18.04 que vai aparecer o link certo. https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/


Ao que parece, os pacotes do Mongo não estão nos repositórios oficiais do próprio Ubuntu e isso é comum com software de terceiros. Pra começar precisamos instalar as chaves públicas do MongoDB pra validar os pacotes que vamos instalar:

```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
```


Agora precisamos adicionar os repositórios do Mongo na lista de repositórios do gerenciador de pacotes APT e puxar a lista de pacotes:

```
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list

sudo apt-get update
```

Esse comando tee, é parecido com o que eu mostrei antes com o >> pra apendar novas linhas no final de um arquivo. O que acabamos de fazer foi dizer pro APT procurar pacotes nesse endereço novo também.


Agora podemos instalar o mongo em si: 

```
sudo apt-get install -y mongodb-org

sudo service mongod start
```


Tanto Postgresql, Redis, Memcache e Mongo vem com daemons que podem carregar sozinhos depois do boot do sistema. Se você tem bastante memória sobrando pode deixar eles ativos que não vai fazer diferença. Se precisar derrubar ou restartar basta usar o comando service mongod stop ou restart. Porém, se você prefere que eles não carreguem automaticamente, você pode fazer service mongod disable e depois fazer service mongod start manualmente toda vez que precisar.


Esse comando service é importante de lembrar no Ubuntu. Ele executa esses comandos start ou stop que estão declarados no que chamamos de um init script. Esses scripts ficam em /etc/init.d por exemplo vamos ver o que tem no do redis fazendo
`cat /etc/init.d/redis-server`

E podemos ver cada um dos comandos de start, stop, status e o que eles fazem quando são chamados. Podemos nem usar o comando service e ir direto no script também:
`sudo /etc/init.d/redis-server status`

Mas o comando service é mais simples de lembrar. Em outros sistemas operacionais usando Systemd pra controlar daemons também existe o comando systemctl. A diferença é que com o comando service a gente faz service [nome do serviço] e [comando] tipo service mongod start. Mas o systemctl é o contrário e fazemos systemctl start mongod, eu sempre me confundo. Antigamente o Ubuntu usava o Upstart e hoje usar o Systemd. Existe uma grande controvérsia em torno desse systemd mas hoje não vou fazer essa tangente. Na prática pra você é importante só lembrar que existem serviços e daemons e é assim que você gerencia esses serviços.



De qualquer forma, memcache, redis e mongo, por padrão não precisam de senha pra conectar nos servidores, por isso por padrão você jamais deve expor esses servidores na internet. O Postgresql você precisa configurar usuários pra conectar no servidor e pra fazer isso você precisa se logar como o usuário postgres e de lá criar novos usuários. Se tentarmos usar o cliente de posgresql que é o psql ele vai dar erro. Então pra criar um novo usuário precisamos fazer:

```
sudo su postgres
createuser --interactive - aqui crie um usuário com o mesmo nome do usuário que você está usando pra logar no sistema, isso vai facilitar sua vida
createdb akitaonrails - e crie um banco de dados com o mesmo nome do seu usuário
Exit
```

*
Pronto agora se fizermos psql provavelmente vamos logar direto no shell do postgresql. Viu? Agora quando estiver desenvolvendo sua aplicação, seu framework favorito provavelmente vai conseguir conectar fácil sem precisar declarar senha nem nada. Obviamente isso é pra ambientes de desenvolvimento. Em produção você não vai conectar num usuário que é superuser. Mas está fora do escopo deste episódio fazer tutorial de Postgresql pra produção. Mas você já sabe o que fazer: GOOGLE.




*
Tem gente que prefere não instalar esses serviços diretamente, pelo mesmo motivo que usamos ASDF. E se você tem um projeto antigo que depende do PostgreSQL 7 e quebra se tentar conectar no Postgresql 10? Pra isso precisamos de algo parecido com um ASDF. E se não me engano acho até que o ASDF tem suporte pra Postgresql, vamos ver no google, e sim, tem mesmo. Mas se for esse o caso eu prefiro fazer diferente. Serviços como os que acabamos de instalar é o caso de uso perfeito pra usar Docker. Então é hora de instalar e configurar Docker. E a essa altura você já adivinhou: vamos pro GOOGLE. 


Seguindo as instruções, primeiro ele recomenda apagar versões antigas, caso você tenha. Como esta demonstração começou do zero, não precisamos fazer isso. Então vamos pular esse passo e instalar direto o que precisamos:

```
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```


Mesma coisa que fizemos com o Mongo, instalamos chaves públicas do povo do Docker pra validar os pacotes. Se você não entendeu, todo pacote que vem nos repositórios oficiais do Ubuntu são assinados digitalmente pela chave privada do povo da Canonical que faz o Ubuntu. Mas quando adicionamos repositórios externos, eles são assinados por outras chaves. Então primeiro instalamos a chave pra depois instalar os pacotes. Esse passo é importante porque caso você seja enganado a instalar manualmente pacotes que foram modificados por um hacker, ele não vai ter a chave privada da Canonical então teoricamente o APT vai recusar instalar esse pacote. Claro, se você for enganado a instalar a chave do hacker também, aí já era, então sempre preste atenção no que está fazendo. Veja como no caso do comando anterior estamos instalando a chave vinda do domínio docker.com e não de um domínio com cara de russo.



Agora que instalamos as chaves, assim como fizemos com o Mongo vamos adicionar novos repositórios pro APT. A diferença é que na instrução do Mongo usamos o comando tee pra adicionar o arquivo com o repositório manualmente e aqui estamos usando o comando add-apt-repository que vem no pacote software-properties-commons. 

```
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

De bônus, como eu sei que o add-apt-repository vem no software-properties-commons? Porque eu posso checar com o comando dpkg -L software-properties-commons. Viu?


Enfim, agora precisamos puxar a lista de pacotes novos com apt update e instalar os pacotes do Docker propriamente ditos: 

`sudo apt-get install docker-ce docker-ce-cli containerd.io`


Você devem ter notado que eu uso o comando apt e muitas instruções vem com apt-get. Na prática apt é o jeito novo, mas apt-get ainda funciona. De qualquer forma agora temos os pacotes todos instalados. Mas o Docker ainda tem um pequena configuração: ele cria um grupo de usuários chamado docker e o usuário que vai gerenciar o Docker precisa estar nesse grupo, então vamos fazer o seguinte:

`sudo usermod -aG docker $USER`


Você já sabe que existe a variável $HOME que o tilde expansion usa, e o whoami que eu mostrei lá no começo usa essa variável $USER que tem o nome do seu usuário. Se quiser ver todas as variáveis do ambiente, digite o comando `set | less` pra ver as dezenas de variáveis que estão disponíveis no seu ambiente. Mas enfim, agora que nosso usuário está no grupo, acho que precisamos deslogar e logar de novo. Vamos restartar pra garantir.


Pra testar, basta fazer docker run hello-world e se tudo deu certo ele vai baixar a imagem de Docker de uma aplicação que só imprime um Hello. Mas nós estávamos falando em baixar o Postgresql, então vamos fazer isso. Você já sabe a rotina: GOOGLE (hackernoon)

`docker pull postgres`

O comando docker pull baixa a imagem mais recente. Agora vamos criar um diretório externo pra onde o postgres vai gravar os bancos de dados e tudo mais:

`mkdir -p $HOME/docker/volumes/postgres`

Agora vamos nos certificar que o postgresql que instalamos nativamente no sistema agora a pouco está desligado com sudo service postgresql stop e sudo service postgresql status. Agora podemos iniciar o Postgresql via Docker que acabamos de instalar:

`docker run --rm   --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data  postgres`

Teoricamente agora podemos usar o cliente nativo psql pra conectar nesse docker assim:

`psql -h localhost -U postgres -p`
Senha postgres


Pronto!! Estamos no postgresql. E se seu projeto tiver configuração pra Docker Compose, você pode subir sua aplicação web num container, seu postgresql em outro container e tudo gerenciado pelo Docker. E aproveitando que falei de Docker. Vamos dar um ps aux na máquina e você vai ver que o postgresql está visível (!!). Pra você que ainda acha que Docker é uma máquina virtual, ele não é. O postgresql está subindo normalmente, nativamente, em cima do mesmo kernel que você está. Agora vamos pegar o PID do processo e dar um cat /proc/PID/cgroup. Lembram do meu episódio sobre containers e virtualização quando expliquei que o cgroup é um jeito do sistema operacional mentir pro processo? Compare com a configuração de cgroup do bash por exemplo (ps | grep bash; cat /proc/PID/cgroup). Essa é a configuração normal pra um processo que enxerga o sistema todo e em cima vemos como é o cgroup que o Docker configura pro processo não enxergar o sistema todo. É assim que o Docker funciona e é por isso que ele é tão leve: ele está rodando lado a lado com seus outros programas.


Eu recomendo que você pegue qualquer tutorial pra aprender os comandos básicos. Aqui acabamos de ver o docker run e docker pull, também tem o docker ps pra mostrar os containers rodando a partir de onde podemos pegar o nome do container e o docker stop [nome do container] pra parar o postgres que acabamos de subir. Tem comandos pra gerenciar os volumes de disco virtuais, pra baixar versões diferentes desse postgres, e assim por diante. E como eu já falei, aprenda a usar Docker Compose pra criar um mini cluster de containers que conseguem acessar uns aos outros.


(...)

*
Já que eu mencionei chaves, vou aproveitar pra fazer uma explicação super porca. No mundo de criptografia existem pelo menos 3 tipos de tecnologias que você precisa saber. Existem algoritmos de digest, que literalmente digere qualquer blob de bits e devolve uma impressão digital de tamanho fixo. Exemplos disso são os antigos MD5 ou SHA1  e coisas mais novas como SHA512 ou Bcrypt ou HMAC. Você pode passar pra eles uma palavra ou a Wikipedia inteira e eles vão sempre cuspir um string de tamanho fixo. Isso você usa pra garantir que a informação não foi adulterada porque se você mudar um bit nessa Wikipedia que eu falei, a impressão digital vai ser completamente diferente. A gente usa isso pra tudo hoje em dia, sempre que você ver strings com caracteres que parecem aleatórios, normalmente é um fingerprint, ou impressão digital.


A segunda categoria são os algoritmos de encriptação reversível. Aqui é o que a maioria das pessoas pensa quando pensa em criptografia: uma forma de bagunçar a mensagem e ter uma senha. E quando passar a senha a mensagem é descriptografada. De novo você tem coisas antigas como o Triple DES ou Blowfish e coisas mais recentes como o AES que é usado pra criptografar seu HD por exemplo. Quando você vê nos filmes alguém tentando quebrar uma encriptação em força bruta ou algo assim, normalmente é um algoritmo reversível ou mais corretamente chamada de criptografia simétrica.


Finalmente, temos criptografia assimétrica. Nessa categoria temos a geração de duas chaves que costumam ser dois números primos relacionados. Por convenção chamamos um desses números, tanto faz qual, de chave privada e ela nunca deve sair da máquina de onde foi criada. O outro número chamamos de chave pública e ela pode ser distribuída por aí, como as chaves que instalamos do povo do Mongo e Docker antes. Tudo que for criptogrado pela chave privada só pode ser aberta pela chave pública e vice-versa. O que é criptografado com uma chave não pode ser aberta com a mesma chave, necessariamente precisamos da outra. Esse é o conceito de chaves públicas e privadas.


Eu expliquei tudo isso porque na nossa instalação, se você ainda nao fez isso, precisa ter seu próprio par de chaves. Serviços como GitHub ou GitLab ou tudo da Amazon AWS ou Google Cloud ou Azure, exigem que você cadastre sua chave pública na sua conta, daí o que você criptografar com sua chave privada local pode ser checada com a pública que você cadastrou e assim podemos nos certificar que você é realmente você.

(...)


Pra criar uma chave é simples, no terminal fazemos:


`ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "boss@akitaonrails.com"`

Normalmente a maioria dos tutoriais vai mandar você criar uma chave com algoritmo RSA mas hoje em dia  preferimos usar a ed25519 por ser mais segura. Ela vai pedir um passphrase, que de preferência como o nome diz é uma frase secreta grande que você não vai esquecer. Esse comando vai criar dois arquivos no diretório .ssh do seu home, o id_ed25519 e o id_ed25519.pub, que se você prestou atenção, representam a chave privada e a chave pública. Vamos ver o que tem dentro:

`cat ~/.ssh/id_ed25519`

Eu estou mostrando aqui a chave privada e não deveria obviamente, mas eu nunca vou usar essa chave de verdade, a minha está bem guardada. Mas só pra vocês verem como se parece uma chave privada. Faça backup do seu diretório .ssh que tem essas chaves. Se você perder a chave, não tem mais como recuperar só a partir da pública, obviamente. Toda vez que você precisar cadastrar sua chave, por exemplo num servidor SSH de alguém, vai precisar mandar o conteúdo do outro arquivo:

`cat ~/.ssh/id_ed25519.pub`

Isso é sua chave pública. Essa você pode mostrar pra qualquer pessoa. É essa chave que você cadastrar na Amazon ou no GitHub, por exemplo nessa página deles (mostra GITHUB).

Pra você não ter que ficar digitando a passphrase toda hora, na sua máquina precisa ter o serviço ssh-agent. Você checa se ele tá rodando assim:

`eval "$(ssh-agent -s)"`

Agora adicione sua nova chave no agente, daí ele só vai pedir sua passphrase uma vez e você pode ficar se logando nos servidores SSH que precisar sem toda hora ter que redigitar a passphrase:

`ssh-add ~/.ssh/id_ed25519`


Muito bem, agora você é um cidadão respeitável e criptograficamente identificável na nossa sociedade. NUNCA  mas NUNCA compartilhe sua chave privada. E faça backup num pendrive que você vai guardar num cofre ou algo assim. Enfim, cuide da sua chave, ela é sua identidade. Se por acaso perder, gere outra e substitua a chave pública em todos os servidores e serviços que tem acesso. Quem tiver sua chave privada tem acesso a tudo que você tinha acesso. 


E já que falamos em Github, falta configurar o Git também. Existem milhares de bons tutoriais pra iniciantes no GOOGLE então aprenda de uma vez porque isso é obrigatório, mas a primeira coisa que você precisa fazer é configurar seu nome e seu email assim:

```
git config --global user.name "AkitaOnRails"
git config --global user.email "boss@akitaonrails.com"
```



*
Isso é a configuração global padrão. Então todo commit que você fizer vai com essa identificação. E se você quiser usar nomes e e-mails diferentes pra projetos diferentes, você pode configurar no arquivo .git/config em cada projeto também, assim você pode ter e-mail pessoal nos projetos pessoais e e-mail da empresa em projetos de clientes se fizer muita questão. Eu uso sempre meu pessoal pra tudo.


*
Pronto, agora temos os principais pacotes de desenvolvimento instalados, temos todas as linguagens que vamos precisar, temos até bancos de dados e docker instalados. Agora vem uma parte que é muito particular só pra mim. Eu gosto muito de usar VIM como editor de textos. Hoje em dia você pode ser virar muito bem com Visual Studio Code que eu recomendo como uma das melhores opções modernas, seguindo do bom e velho Sublime Text 3. Tem o Atom do GitHub também mas eu acho que o Atom é muito pesado por ser totalmente em Electron e eu prefiro evitar Electron como eu evitaria uma praga. O VS Code tem partes em Javascript mas se não me engano ele usa uma toolkit híbrida com componentes nativos e isso torna ele mais responsivo. Porém tanto VS Code quanto Atom, por terem muito Javascript por baixo, é que nem uma aba de Google Chrome: come memória como se não houvesse amanhã. O Sublime Text 3 é totalmente nativo e extremamente leve. E o VIM obviamente é mais leve ainda. Eu gosto de editores de texto que eu chamo e abrem instantaneamente, em milissegundos pra ser mais exato, senão eu me entedio muito rápido.



*
Na realidade o GVIM já está instalado. O VIM é um editor que você abre na linha de comando, mas existe o VIM-GTK que é o mesmo VIM só que aberto dentro de uma janela gráfica de GNOME e com algum suporte básico a mouse também. Tanto faz qual dos dois você vai usar. Na verdade faz diferença. Aqui eu vou dividir o caso de uso pra usuários como eu que tiveram história usando tantos ambientes puramente de texto e também ambientes gráficos como Mac e aqueles que tem a oportunidade de começar sem vícios só no ambiente de texto do Linux. Agora eu vou mostrar a combinação que a maioria dos veteranos de Linux realmente gostam. Vamos instalar o TMUX, o sucessor do lendário GNU Screen que a gente usava antigamente.

(..)

Pra instalar é simples: `apt install tmux`.

O TMUX é um multiplexer de terminal. Esse palavrão significa que você ganha a capacidade de ter mútiplas sessões de terminal dentro de um único terminal. Lembram os workspaces gráficos do GNOME que seria como se fossem monitores virtuais? O TMUX são terminais virtuais. Você inicia com o comando tmux. Aqui ainda não tem nada demais, parece o mesmo terminal de sempre. Vamos abrir um VIM agora e editar alguma coisa. O básico de VIM é que ele tem dois modos, modo de comando e modo de edição. Ele sempre está no modo de comando, mas apertando comandos como i ou a de insert ou append, você entra no modo de edição. Agora você pode editar normalmente e quando terminar aperte ESC e volta pro modo de comando. Agora podemos gravar o arquivo com o comando :w /tmp/teste.rb por exemplo. Nesse modo também podemos navegar, por exemplo com as teclas hjkl que no teclado ficam um do lado do outro e servem como setas. Podemos fazer gg ou G pra ir pro começo ou fim do arquivo. Podemos combinar comandos como 10l pra andar 10 caracteres pra direita. E pra sair do VIM apertamos ESC pra garantir que estamos no modo de comando e fazemos :q pra dar quit. Isso é o mínimo do mínimo pra você navegar no VIM. Mas voltando ao TMUX.


Digamos que eu queira executar esse script idiota que eu acabei de fazer. Eu posso agora apertar a combinação Ctrl b % e boom temos um split do terminal. Com Ctrl b O eu posso navegar pelos painéis. Ctrl b “ faz split em outra direção. E Ctrl b w fecha o painel. Fala que isso não é bem foda. Tanto TMUX quanto VIM tem essa funcionalidade de split horizontal e split vertical que eu acho ultra útil e sei lá porque razão nenhum outro editor de textos tem exatamente a mesma funcionalidade. Terminais que fazem split tem vários hoje como o Tilix que vamos instalar já já, ou o iTerm2 em MacOS.


Mas o que torna o TMUX diferente é o seguinte: e se eu fechar o aplicativo do Terminal inteiro? Vamos fazer isso. Se fosse no Terminal normal ou num iTerm2 da vida, você acabou de perder tudo que estava fazendo e vai ter que abrir tudo. Mas não no TMUX eu posso fazer o comando tmux ls, pra listar as minhas sessões e olha só: tem uma sessão ativa. Agora posso fazer
tmux attach-session -t 0 que é o número da sessão e boom, tudo exatamente com eu tinha deixado. Isso era particularmente útil quando você só tinha terminais burros conectados remotamente num servidor via TELNET porque e se a conexão caísse bem quando você estava no meio de uma edição de código? Você perdia o que estava fazendo. Mas se estivesse usando o GNU Screen a sessão permanecia rodando no servidor, você podia esperar a conexão voltar, conectar de novo com seu terminal burro e recuperar a sessão que ainda estaria ativa.


Acho que isso deve convencer vocês a aprender tmux. Da próxima vez que precisar se conectar via SSH num servidor remoto pra fazer alguma coisa que vai demorar, abra um TMUX primeiro. Se por acaso der pau na sua máquina ou na sua conexão por alguma razão, você não vai perder nada que estava fazendo. Basta reconectar e dar attach na session que ainda vai estar ativa lá. E pra ser ainda mais versátil, você pode ver que já tem paineis demais aqui né? Vamos criar uma outra janela inteira com Ctrl b c e agora podemos navegar com Ctrl b n. Ou seja, você pode estar fazendo várias coisas em paralelo em múltiplas janelas de terminais splitadas em múltiplos painéis e você não vai perder nada caso feche essa janela. No final você pode fazer Ctrl b d pra desatachar manualmente. Se quiser mesmo fechar tudo que estava aberto na sessão você pode fazer tmux kill-session -t 0. Pra saber todos atalhos de teclas e comandos que o tmux aceita, o man tmux vai ajudar muito.


*
Pronto, com isso você tem o ambiente perfeito. Mas ainda falta mais uma coisa. O VIM puro é bem inútil na verdade, ele não é muito diferente de um NANO que você vê em muito tutorial. Eu particularmente fico irritado de ver o nano. O nano é derivado do antigo editor PICO que era o editor do cliente de e-mails antigo chamado PINE que eu inclusive usei muito na faculdade no meio dos anos 90. PICO era conterrâneo do editor JOE que por sua vez era inspirado no editor de MS-DOS, o Wordstar que eu usava no fim dos anos 80. São editores velhos, cansados, que eu não teria coragem de usar hoje em dia pra programar. 



O VIM, assim como o Emacs são extremamente versáveis porque são scriptáveis. O Emacs em Emacs Lisp ou eLisp e o VIM em VimScript. Por causa disso podemos adicionar funcionalidades modernas como colorização de sintaxe pra cada linguagem, auto complete e muito mais. Infelizmente eu nunca tive muito saco pra aprender Emacs e o Vim sempre foi suficiente pra mim. Ele é leve e tem todas as funcionalidades que eu preciso. Mais do que isso: ele é perfeito pra editar coisas remotamente via SSH se precisar. Ele foi feito pra ter comandos e atalhos curtos, pra era onde conexões de rede eram lentas. E isso é perfeito porque mesmo hoje em dia ainda temos que lidar com conexões lentas ou instáveis de vez em quando.



E aqui vem a parte que é bem subjetivo ao mesmo próprio gosto. Por isso esta parte é opcional e você vai encontrar outras configurações diferentes. Até agora estávamos usando o Terminal que já vem no Ubuntu, eu prefiro usar o Tilix como já falei. Eu também prefiro usar o Z Shell em vez do Bash e eu tenho um conjunto de dotfiles que eu já me acostumei e gosto bastante. 


Então vamos instalar:

`sudo apt install tilix zsh`

Feito isso agora é hora de instalar os dotfiles que eu gosto. Lembre dessa palavra dotfiles. Eu já expliquei que todo arquivo ou diretório que começa com ponto é escondido, e no seu diretório home vai começar a aparecer vários assim como o .config que o GNOME usa pra colocar configurações ou o .gcloud se você configurou as ferramentas do Google Cloud. Mas do que isso tem .vim pra configurações do VIM. Mas existem vários projetos no Github com dotfiles pré-prontos, um dos mais famosos pra ZSH é o Oh-my-ZSH que é bem customizável mas eu prefiro o do usuário SKWP que se instala assim:

```
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh `"
```


Ele precisa de Ruby, por isso já instalei via ASDF lá atrás. Vamos entrar no diretório .yadr e rodar rake update e deixar ele trabalhar.



Pronto, no final ele vai instalar temas como o Solarized Dark, vai configurar o prompt pra mostrar o branch de Git que você está e deixa tudo organizado no lado do ZSH e do VIM pra você customizar e adicionar novos plugins se precisar. Por exemplo, eu quero mudar a fonte do VIM pra ser a fonte Hack que instalamos antes. O VIM tem uma tecla especial chamada de Leader que dependendo do dotfiles pode estar assinalada pra qualquer coisa mas neste pacote é a vírgula. Com virgula T eu posso procurar por arquivos como o Ctrl P no Sublime ou VS Code. Vamos abrir o yadr-appearance. Olha como está tudo colorido corretamente. Vamos navegar e adicionar a fonte.



No Tilix também quero mudar o tema pra ser Dark e usar Solarized com fonte maior e bordas menores. E também mudar o atalho de splitar a tela que seria Ctrl Alt D para outra coisa como Ctrl Alt E e a razão disso é porque no Ubuntu esse atalho já é usado pra esconder a janela. E pronto. Veja porque eu disse que aqui é uma questão de que tipo de usuário você é. Você pode usar um terminal maximizado com TMUX e splitar pra ter o VIM de um lado e o terminal do outro pra você trabalhar, OU, no caso de alguém como eu que já se acostumou ao iTerm2 no Mac e MacVim, eu prefiro deixar um terminal aberto de um lado que eu posso facilmente splitar com Ctrl Alt E e Ctrl Alt R e navegar com ALT e numero do terminal e do outro lado o GVIM que eu também posso splitar usando ss ou vv e navegar com ctrl shit e as teclas de navegação hjkl.


Só pra exibir essa versão customizada de vim, veja como eu posso facilmente substituir uma palavra inteira com ciw ou usar o pacote de git pra dar um :Gblame ou :Gdiff, ou então abrir um explorador de arquivos inteiro que é o NerdTree com Alt Shift N e os comandos de navegação são os mesmos pra painéis splitados então ctrl alt l ou j. E :q fecha cada painel. :w grava. :e serve pra abrir outros arquivos. Posso usar :Ag que se integra com o silversearcher pra procurar rapidamente em todos os arquivos do projeto.

*
E agora sim, eu tenho tudo que eu preciso instalado. Se eu estiver no humor de usar 100% terminal, posso abrir o TMUX com o VIM de linha de comando, ou se eu quiser ficar no mundo híbrido gráfico posso usar os splits de Tilix com GVIM. Tanto faz, contanto que você tenha todos os atalhos e shortcuts pra ser produtivo. Na prática o jeito 100% é o melhor porque evita que você precisa ficar toda hora usando o mouse, e isso é uma das coisas que vai evitar que você tenha tendinite no futuro. Por isso quanto mais você aprender os shortcuts de TMUX e VIM, menos você vai precisar usar o mouse e isso sempre vai ser mais produtivo mesmo. Fora que as mesmas ferramentas que você usar na sua máquina de desenvolvimento, você também vai poder usar remotamente via SSH num servidor. E só de bônus, você pode compartilhar sessões de TMUX com outro usuário via SSH pra fazer pair programming remoto. Eu não vou mostrar aqui hoje mas você já sabe no GOOGLE você acha como.


Pra finalizar o vídeo de hoje, se você vai usar esse Linux que acabou de instalar como sua máquina primária, tem uma última coisa que você vai precisar fazer se quiser assistir vídeos online. Os codecs de H.264 ou mp3 e outros não são free software, então você precisa habilitar o que o Ubuntu chama de repositórios restritos. A forma de fazer isso é instalando o pacote ubuntu-restricted-extras pelo apt.


Esses repositórios são considerados restritos porque na instalação base vem tudo que é 100% código aberto. É parte da Filosofia do mundo de Software Livre que você deveria boicotar tudo que não tem código-aberto ou usa licenças que não são de software livre. E eles tem bons argumentos, porém, eu não sou ativista, eu prefiro ter o melhor dos dois mundos sempre. Minha produtividade nunca vai ser boa se eu tiver ideologias extremistas. Dou meus parabéns a quem vem lutando pra conseguir ter o máximo de código-aberto no mundo, mas no mundo real nem sempre isso é possível e eu prefiro não me restringir. 


O Ubuntu vem por padrão com o Firefox e eu recomendo que você tente mesmo usar o Firefox como seu navegador primário, o mundo está sendo monopolizado pelo Google Chrome e mesmo navegadores como o novo Microsoft Edge, o Brave e o Opera usam a mesma engine do Chrome. Novamente, eu preferia que o mundo tivesse mais opções, mas na realidade se você é um programador web, vai precisar se certificar que sua aplicação tanto em Firefox quanto em Chrome, então você precisa instalar o próprio Chrome do Google ou a versão aberta que é o Chromium e pra instalar é via apt install chromium-browser.


Procure por Ubuntu 18 post-install e veja o que os outros fazem logo depois do primeiro boot. Você vai achar como instalar outros aplicativos úteis pra você como Spotify, Discord, Skype e muito mais.


E meu deus do céu, esse vídeo deu MUITO trabalho, mas eu precisava ter ele gravado pra poder referencias nos próximos vídeos, assim quando eu quiser mostrar a parte de programação de verdade ninguém vai poder dizer que não sabe o que é Docker, Postgres, ASDF, Vim e muito menos que não sabe como instalar, porque eu vou mandar sempre pra cá. Obviamente se você é iniciante deve ter ainda muitas dúvidas, então mandem nos comentários abaixo. Se tudo isso que eu falei você já sabia contribuem mandando mais dicas e ajudando a galera que tá começando agora nos comentários também. Se curtiram esse vídeo mandem um joinha, assinem o canal, e cliquem no sininho pra não perder os próximos episódios. Compartilhem o vídeo com seus amigos. A gente se vê semana que vem, até mais!


