---
title: "[Akitando] #134 - Top 3 Distros Linux | Qual Recomendo?"
date: '2022-12-23T09:18:00-03:00'
slug: akitando-134-top-3-distros-linux-qual-recomendo
tags:
- mandrake
- mandriva
- conectiva
- garuda
- manjaro
- archlinux
- ubuntu
- debian
- redhat
- opensuse
- fedora
- centos
- batocera
- ambernic
- ayaneo
draft: false
---

{{< youtube id="unpJgmjTLEg" >}}

Como video de fim de 2022, vou participar de uma corrente chamada "Top 3 Distros Linux". Vou eleger 3 distros Linux que gosto e depois falar sobre distros Linux em geral. 

E aqui vão os "summon" pra participar da corrente:

@HackerVilela
@pikuma
@ManualdoCodigo

## Conteúdo

* 00:00 - Intro
* 00:49 - As Regras da Corrente dos Top 3
* 02:04 - Número 3
* 03:28 - Número 2
* 05:38 - Número 1!
* 08:34 - Como eu enxergo Distros Linux
* 12:56 - Recomendação pra Iniciantes?
* 15:11 - Summon 1: Vitor
* 15:55 - Summon 2: Pikuma
* 16:59 - Summon 3: Douglas
* 17:56 - Bloopers


## Links

* https://diolinux.com.br/video/top-3-distro-linux.html
* http://toastytech.com/guis/mkde.html
* https://batocera.org/
* https://en.wikipedia.org/wiki/Mandriva_Linux
* https://www.redhat.com/en/about/press-releases/press-redhat42
*

## SCRIPT

Olá pessoal, Fabio Akita


Normalmente eu não participaria de correntes, mas por acaso o assunto bateu com alguns dos meus videos mais recentes então decidi participar. Ainda mais porque fui "sumonado", praticamente intimado pelo Diolinux no video dele de "Top 4 Distros de Todos os Tempos", que por sua vez foi "sumonado" pelo Slackjeff e assim por diante. A idéia é falar sobre as 3 distribuições Linux que mais me impactaram mas não vale falar da distro que estou usando neste momento. E no final tem que provocar mais pessoas pra continuar a corrente. Este video vai ser curtinho, só pra fechar o ano, então vamos lá!




(...)






Ironicamente, não pode falar da distro que estou usando neste momento. O problema é que estou usando 4 distros ao mesmo tempo. Deixa explicar, o principal é o Manjaro Gnome, que uso no PC de casa, e é minha máquina de trabalho. Mas tenho vários ambientes virtuais. Quem me acompanha no Instagram sabe disso, e vai ser tema de um próximo video que já estou escrevendo. Mas como ambiente pra retrogames eu tava usando o Garuda Linux numa máquina virtual. Assim como o Manjaro é derivado de ArchLinux também, mas vem mais estilizado e pré-configurado pra gamers. É uma distro bem pesada, feita pra máquinas mais parrudas.







Também tenho um Ubuntu 22 virtualizado pra alguns testes então não vou falar dele e tenho o Windows Subsystem for Linux, ou WSL rodando ArchLinux em cima, que uso no meu notebook porque lá o OS principal é Windows mesmo. Alguns modelos de notebook aceitam Linux de boa, alguns nem tanto, e esse Zephyrus G14 dá probleminhas com coisas como Bluetooth então decidi ficar no Windows mesmo já que uso mais pra viajar.







Então nada de Manjaro, nem Garuda, nem Ubuntu e nem Arch. Pois bem, vou falar primeiro o tema da corrente, as Top 3 distros que acho mais interessantes e depois o que acho que todo mundo realmente queria saber que são as distros que eu usaria como minha principal mesmo. Vamos lá, começando pelo número 3.







A número 3 é a distro que mais usei nos anos 90, e foi a francesa Mandrake Linux que depois se fundiu com a brasileira Conectiva e virou Mandriva, que começou em 1998 e morreu em 2011. Mandrake pra mim sempre pareceu um RedHat mais amigável, mais ou menos como um Ubuntu nasceu como um Debian mais amigável, só que quase uma década antes.







Mandrake vinha com KDE por padrão, e o principal é que tinha um instalador gráfico muito mais interessante que a versão em ncurses padrão dos RedHats. E pra quem não sabe o que é a distro RedHat, depois ele virou CentOS que é mais usado em servidores de empresas e o Fedora que é a versão mais usada em desktops. Além disso tinha o Mandriva Control Center, meio parecido com a proposta do Yast do OpenSuse de ter um painel de controle completo pra configurar o sistema em vez de ter que fazer muita coisa pelo terminal.








O gerenciador de pacote não lembrava o nome, mas pesquisando achei que era o "urpmi" que funciona como um wrapper pra RPM. Eu jurava que ele usava direto RPMs, que é o formato de pacotes RedHat Package Manager, que ainda é usado no CentOS e Fedora e gerenciado pela ferramenta "DNF". O Mandrake, Conectiva e depois Mandriva foi onde realmente comecei a aprender Linux, aprender a programar com Perl, PHP, aprender sobre servidores web, configurar Apache e coisas assim. Eu usei outras distros daquela época, mas sempre voltava pro Mandrake.








O Top 2 acho bacana pra quem só conhece Ubuntus da vida porque é largamente usado e ninguém sabe disso, o Alpine Linux. Se você lida com infraestrutura, principalmente se é devops de Kubernetes e outras plataformas de containers, deve usar Alpine ou Debian. A idéia do Alpine é o oposto de um Fedora ou Ubuntu. Enquanto distribuições pra desktop tentam colocar um monte de software pra tornar a máquina mais fácil de usar, um Alpine tem como objetivo ser o mais leve e o mais seguro possível, vindo só com realmente o mínimo necessário pra um container funcionar.








Acho que tem louco que tenta usar Alpine como desktop, mas ele não foi feito pra isso. Dá? Dá, mas não tem vantagem em desktop, só em containers. Ele deriva de uma linhagem anterior de distros como o antigo LRP ou Linux Router Project ou "Linux on a Floppy", cuja idéia era ter uma distro tão pequena que caberia num disquete antigo. Esse tipo de distro é útil pra bootar coisas como roteadores ou firewalls. 






Sabe o modem de internet que você tem aí na sua casa? É um Linux dessa família, não necessariamente o Alpine, mas parecido. Ele vem com o kernel, os drivers mínimos pra coisas como placa de rede, nenhum tipo de interface gráfica pesada como KDE, e só um servidor web como Apache pra fornecer uma aplicação web que você acessa pelo navegador do seu PC ou via um app no celular.







Pra quem sobe Docker ou Podman, normalmente puxa imagens cuja base original era um Alpine. Por exemplo, este é repositório onde tem o Dockerfile que gera a imagem de Postgres que você usa nas suas aplicações. Ele tem duas versões, uma gerada a partir de Debian e outra a partir de Alpine. Se olharmos o repositório da imagem de python, o Dockerfile dele também começa com a opção de Alpine e depois Debian.







Debian ainda é bem usado pra essas coisas por causa da sua reputação lendária de estabilidade e maturidade. Mas o Alpine tá lá pau a pau. Diferente de Ubuntu ou Debian que usa a ferramenta "apt" pra gerenciar pacotes, Alpine usa "apk" e hoje em dia tem apk pra tudo que precisamos no mundo de servidores ou sistemas embarcados. Como programador, é importante aprender como o Alpine funciona e quais as diferenças com outras distros mais antigas como Debian.







E agora, meu Top 1 é pra dar uma troladinha, mas só pra sair do comum. Acho que é válido falar do Batocera. Quando falamos em distros pra gamers, muitos pensam no PopOS, ou Garuda ou mesmo o meu Manjaro, mas a maioria esquece do Batocera.





Eu uso Batocera num Raspberry Pi ligado neste setup que tenho em casa. Eu sempre quis um arcadezão de madeira que nem tinha antigamente, mas na prática, no meu apartamento pequeno, seria um trambolhão ocupando muito espaço. Daí resolvi repensar o conceito e ter um arcade minimalista. Eu já tinha um raspberry pi sobrando, tinha comprado este joystick de arcade da 8bitdo, que não é nem de longe bom pra competir numa EVO da vida, mas pra jogar casual é excelente. Daí comprei esse monitor portátil, super fino e leve. Tão leve que coloquei fita dupla face da 3M atrás e grudei na parede.









No Raspberry Pi antigamente instalava o RetroPie, que é outra distro dedicada a retrogaming, mas o Batocera acho evoluiu mais rápido e tem o melhor acabamento. Você baixa a imagem dele, instala num SD Card, coloca no Raspberry e já era, tudo funciona. Olha só o boot dele. Já vem com emuladores como RetroArch configurado, já vem com o front-end EmulationStation configurado pra ficar bonito que é esse que estou mostrando, já tem todos os perfis de controles de arcade e gamepads, então é tudo plug and play, não precisa abrir terminal pra ficar gambiarrando nada. Só copiar os arquivos de ROMs dos jogos e jogar. É excelente pra máquinas fracas ou raspberry pra virar central de games antigos.









Eu particularmente gosto muito desse novo mercado de consoles portáteis pra retrogames, como os feitos pela Ambernic ou Retroid. Este é meu Ambernic RG552, e dá pra instalar Batocera nele também. Este é meu Miyoo Mini, mas nesse o recomendado é instalar o Onion OS que é mais configurado pra este hardware em particular. E este é meu Aya Neo Next Pro que tá com Windows mesmo, mas esse é potente demais e seria meio desperdício usar Batocera nele. É basicamente a performance de um notebook. Se eu ligar um teclado e mouse, posso substituir meu notebook em viagens.






Se quiserem reviews de consoles portáteis, como configurar Batocera, Onion e muito mais, assinem os canais Retro Game Corp, Taki Udon, ETA Prime e Retro Dodo, que são os que eu assisto. Eles tem falado de Steam Deck, Aya Neo, Ayn Odin, e muito mais.





Pronto, terminei minha missão: os Top 1 e Top 2 foram pra abrir a curiosidade de vocês em ir conhecer distros Linux especiais pra usos específicos que não só desktop. Acho esse assunto bem mais fascinante do que ficar discutindo tema mais bonitinho de KDE ou GNOME. E agora que terminei meus Top 3 da corrente, deixa eu fazer alguns comentários sobre o que acho de outras distros.







Pra mim o mundo de distros se divide assim. Primeiro tem as distros OG, as originais ou derivadas das originais. Coisas como Slackware, que foi minha primeiro distro, ou Gentoo, que poderíamos dizer que é o menos velho dessa categoria. Mas são as distros que exigem que você tenha mais intimidade com a máquina e com baixo nível da kernel e configurações mais cabeludas. Não foram feitas pra serem amigáveis, foram feitas pra quem sabe o que está fazendo. Debian pra mim se encaixa nesse grupo. Se quiserem ver como é Slackware e Gentoo eu fiz um video pra cada recentemente, dêem uma olhada depois.








Daí existe a RedHat, que nos anos 90 despontou como a melhor solução de Linux comercial, oferecendo garantias, suporte técnico e tudo mais. Em paralelo apareceu a alemã Suse que hoje é OpenSuse e foi competidor de outros comerciais como Caldera Linux da Novell ou VA Linux que foi o primeiro IPO de Linux no meio da bolha da Internet do fim dos anos 90. RedHat junto com a Suse foram os únicos que sobreviveram. Dela derivam Fedora e CentOS que se usa até hoje.







Na virada do século nasce o Ubuntu, que é derivado de Debian e usa o mesmo formato de pacotes DEB e o mesmo gerenciador de pacotes apt. Ubuntu é o Debian menos estável, porque trás pacotes mais novos. Normalmente em servidor ou embarcado você não quer os pacotes mais novos, você quer os mais testados, estáveis, maduros e livres de bug. 





Parte da popularidade do Ubuntu se deve a ele ter sido mais pragmático. Debian segue a filosofia de software livre mais à risca. Nada de binários sem código-fonte ou código que não tenha licença realmente livre. Já Ubuntu preferiu ser mais amigável e incluiu coisas como codecs de mp3, de video, drivers binários de hardware como NVIDIA e tudo mais. Isso facilita a vida do usuário médio, mas já não segue mais a idéia de software livre. Muitas distros hoje fazem a mesma coisa.






Em desktop não tem tanto problema instalar um pacote com bug e esperar alguns dias pra aparecer a correção. Mas em embarcado ou servidor, isso é um grande problema. Imagina um bug que é automaticamente instalado em centenas de servidores e causa crash pra todos os usuários. Seria uma catástrofe. Por isso um Debian da vida oferece pacotes mais "velhos" mas que sabemos que funcionam sólidos.







Tem gente que não curte o Ubuntu da Canonical. Seja porque não gosta de laranja, seja porque não gosta de Snap ou seja lá o que for, seja porque não curtem Unity ou GNOME. Daí surgiram dezenas de distribuições derivadas de Ubuntu. Nessa categoria temos o PopOS, Linux Mint, Elementary, Zorin OS, Budgie, Feren, Lubuntu, KDE Neon e vários outros. O que muda é a interface gráfica, quais pacotes já vem pré-instalados, configurações e tuning do sistema. Mas pra mim é tudo Ubuntu.







Tem uma coisa que eu não curto em APT, que é o gerenciador de pacotes que todos usam, e ter que instalar e configurar PPAs pra instalar pacotes de terceiros. Acho um saco, acho manual demais, acho bugado. Por isso passei a preferir derivados de ArchLinux pra desktop. Arch é o oposto de Debian: o mais instável possível porque ele instala tudo que sai de novo. E eu sou o tipo de cara que gosta de novidades o quanto antes.







ArchLinux funciona no sistema de rolling updates. Não tem isso de upgrade de Ubuntu 20 pra 21, de 21 pra 22, ele vai só se atualizando constantemente. O problema disso é que quase todo dia tem atualização. Quem se incomoda com isso vai odiar. E também por causa disso, vira e mexe pode vir uma novidade pouco testada que causa bugs. 





E pra piorar ainda temos o AUR que é o Arch User Repository, onde qualquer um pode subir qualquer pacote de qualquer coisa. A vantagem disso é que todo software que imaginar provavelmente alguém subiu lá e tá fácil pra instalar. A desvantagem é que todo mundo pode subir qualquer coisa e vira e mexe sobe mal feito e mal testado: você instala e dá pau.






Essa não é uma distro pra amadores. Vira e mexe vai ter que consertar alguma coisa na não. Por isso existem derivados de Arch que tentam estabilizar um pouco mais as coisas e aí chegamos no meu Manjaro. Em vez de liberar pacote novo toda hora, o Manjaro dá uma segurada pra dar tempo da comunidade testar um pouco mais, subir correções e só depois eles liberam tudo de uma vez só. 






Ele atualiza com menos frequência e quando vem atualização não quebra catastroficamente. E Manjaro passou a oferecer o sistema de arquivos BTRFS já na instalação, em vez de ext4, então temos suporte a snapshots, que oferece outra camada de proteção caso a gente instale um pacote bugado. Vou falar disso em outro video.






Isso tudo dito, pra um iniciante que não sabe bem que distro usar, posso recomendar ou Manjaro, seja KDE ou GNOME, ou PopOS que acho que é um dos derivados de Ubuntu mais bem feitinhos. Ou direto o próprio Ubuntu. A vantagem é que a maioria dos posts de blog e tutoriais documentam como fazer as coisas em Ubuntu. Raramente você vai achar um post que ensina como fazer as coisas em Gentoo ou Slackware, mas pra Ubuntu é mais fácil. Por isso que falamos que é mais indicado pra iniciante: porque tem mais chances de achar documentado como resolver um problema específico.







ArchLinux e Gentoo tem outra coisa legal: o Wiki deles são a melhor documentação de Linux ever. Sério, tudo que imaginar tem documentado lá. Se não tiver na Wiki do Arch, vai ter na Wiki do Gentoo. Se não tiver mesmo lá, parabéns, você achou alguma coisa que ninguém no mundo viu ainda. Mas esse Wiki pode intimidar os iniciantes, porque é bem detalhado.






Mas na prática o que todo mundo quer mesmo saber é qual interface gráfica usar, independente da distro por baixo. KDE que você gasta algum tempo configurando temas e plugins, costuma ser o mais bonito, mas também meio pesadão. Recomendo brincar com gerenciadores de tiling window, onde as janelas ficam automaticamente uma do lado da outra em vez de uma em cima da outra. Quem popularizou isso foi o i3, o próprio PopOS trás essa funcionalidade de forma opcional que é legal pra começar, mas pra ser mais hardcore tentem usar o Sway ou XMonad. 







Sway é mais ou menos a mesma coisa que o i3 mas feito pra rodar em Wayland. Se tiver GPU que não seja NVIDIA, provavelmente é a que vai rodar melhor. E o mais avançado acho que é XMonad. São interfaces gráficas feitas pra operar sem mouse. É pra programador hardcore de Vim ou Emacs que não tira os dedos das teclas pra nada. Eu já usei, e se minha rotina ainda fosse só programar, certamente usaria um dos dois. Mas como não é mais, fico no GNOME, que é o mais simples, não precisa customizar muito, e se comporta mais parecido com os antigos MacOS.








No geral é isso, por hoje é só. Diferente fazer um video curto assim. Pra continuar a corrente, preciso dar summon em outros canais pra passar o bastão. Eu realmente não assisto muitos canais de programação nem Linux no YouTube, então vou chamar dois que já interagi pelo Twitter e um terceiro que me indicaram. Eles fazem coisas bacanas que vocês vão gostar.






O primeiro é o Vitor Vilella. O moleque é hardcore, ele pega binários de ROMs de jogos de Super NES que tem problemas de lentidão, como Gradius III, por exemplo, e ativa chips de aceleração do Super NES como o SA-1. Ele faz assembly de chip de Super NES, e a ROM resultante dá até pra gravar num chip de cartucho de verdade e jogar no hardware original. 






Encontrei ele por causa do projeto de Super Mario World em widescreen. Sério, ele ajustou o jogo todo pra ter mais espaço na direita e na esquerda e dar pra ver mais da fase ao mesmo tempo, sem quebrar nada. Só baixar um emulador como o BSNES que tem suporte a esse tipo de hack e jogar. Eu assino o Patreon dele. Dêem uma olhada. O canal de YouTube ainda é pequeno mas vale a pena.








O segundo que me veio à cabeça é o Pikuma ... paikuma? pikuma? Eu acho que ele é professor brasileiro que trabalha na Inglaterra. Ele vende cursos online. E eu sei, logo eu anti-curso recomendando curso é foda, e já deixando claro que ele não me pagou pra dizer isso, mas os temas dos cursos dele são interessantes. 






Segundo o site dele, o objetivo é ensinar as fundações da programação de verdade, que eu sempre falo que ninguém ensina, como álgebra linear, trigonometria, matemática discreta e análise numérica, cálculo. Só que em vez de serem aulas teóricas chatas, ele faz isso aplicando na construção de um motor de jogos 2D em C++, ou programando em assembly do antigo Atari VCS, ou replicando o sistema de raycasting usado nos primeiros jogos de tiro como Wolfenstein.






Eu não cheguei a assistir nenhum dos cursos, estou chutando que sejam bons pelo tema e pelos capítulos que li. Claro que não dá pra explicar a ciência da computação inteira só nesses cursos, mas com aplicações reais e divertidas, deve incentivar o pessoal a procurar se aprofundar depois. Vocês podem me dizer nos comentários se gostaram.







O terceiro canal me foi recomendado pelo Twitter  e esbarrei no Manual do Código do Douglas. Esse cara tem centenas de videos de temas interessantes de programação. Ele deveria ter muito mais seguidores. Vão lá dar uma moral pra ele. Assim como o Pikuma, também fala de programação de videogames antigos, tem javascript, tem python, tem megadrive, tem muita coisa pra quem curte programação. 







E é isso aí, agora é com vocês, claro que é opcional participar da corrente, mas acho que foi uma boa oportunidade pra falar de outros canais aqui do Brasil que tão fazendo mais do que repetir as mesmas coisas cansadas de Python ou Javascript. Quem conhecer outros canais parecidos e quiser recomendar, não deixem de postar nos comentários abaixo. Se curtiram o video mandem um joinha, assinem o canal e compartilhem o video com seus amigos. E você assistindo, mesmo não tendo sido intimado aqui, faça um video de Top 4 distros também e compartilhem. Boas Festas, Feliz Natal e a gente se vê em 2023, Feliz Ano Novo! 
