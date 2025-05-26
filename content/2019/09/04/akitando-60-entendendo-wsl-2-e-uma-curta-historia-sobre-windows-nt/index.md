---
title: "[Akitando] #60 - Entendendo WSL 2 | E uma curta história sobre Windows NT"
date: '2019-09-04T11:00:00-03:00'
slug: akitando-60-entendendo-wsl-2-e-uma-curta-historia-sobre-windows-nt
tags:
- linux
- sfu
- wsl
- bash
- ubuntu
- arch
- cygwin
- wine
- proton
- windows nt
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/28jHuWBi72w" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

(obs: este script depende muito dos demos no video em si, pode ser difícil de ler só o texto)

## DESCRIPTION

Eu vinha prometendo esse tema já faz algum tempo e finalmente resolvi explicar esse tal de WSL ou Windows Subsystem for Linux, a solução que permite rodar programas de Linux diretamente em cima do Windows.

Mas desde que eu comecei a acompanhar esse projeto em 2016 muita coisa mudou. O WSL evoluiu do então chamado "Bash on Ubuntu" para "WSL 1" e agora migrando pra "WSL 2".

Quais as diferenças? Como funciona? Como instalo e configuro na minha máquina?

Além de responder essas perguntas eu achei adequado aproveitar o gancho pra contar a história do UNIX/Linux sobre o Windows e como essa história remete até o anos 80! Então vamos entender a história de como a Microsoft sempre flertou e de fato dormiu na cama do UNIX muito antes do que você pensa!

Se já sabe de tudo isso e só quer saber sobre o WSL especificamente, pode pular direto pro tempo 32:12.


Errata:

Eu disse que o VHD é limitado em 256GB e não havia como redimensionar, mas na verdade tem sim. Este link tem mais informações: https://docs.microsoft.com/en-us/windows/wsl/wsl2-ux-changes

Eu disse que 8086/8088 eram processadores de 8-bits, mas esses já eram 16-bits! Sempre confundi isso.


Pré-requisitos:

* Playlist: Começando aos 40 (https://www.youtube.com/playlist?list=PLdsnXVqbHDUc7htGFobbZoNen3r_wm3ki)
* Concorrência e Paralelismo Parte 1 (https://www.youtube.com/watch?v=cx1ULv4wYxM)
* Concorrência e Paralelismo Parte 2 (https://www.youtube.com/watch?v=gYJSWs-gp1g)
* Gerenciamento de Memória Parte 1 (https://www.youtube.com/watch?v=9AK_1gqEfkQ)
* Gerenciamento de Memória Parte 2 (https://www.youtube.com/watch?v=DGU1awKrNiA)
* Virtualização Parte 1 (https://www.youtube.com/watch?v=bwO8EZf0gLI)
* Virtualização Parte 2 (https://www.youtube.com/watch?v=mcwnQVAn0pw)
* Apple, GPL e compiladores (https://www.youtube.com/watch?v=suSvMnNwV-8)


Links:


* Announcing WSL 2 (https://devblogs.microsoft.com/commandline/announcing-wsl-2/)
* Awesome-WSL (https://github.com/sirredbeard/Awesome-WSL)
* Xfce4 Desktop Environment and X Server for Ubuntu on WSL 2 (https://autoize.com/xfce4-desktop-environment-and-x-server-for-ubuntu-on-wsl-2/)
* HOWTO: Enable WSL2 and Convert Existing Pengwin Installations (https://www.pengwin.dev/blog/2019/6/12/enable-wsl2-and-convert-existing-pengwin-installations)
* Plan 9 rides again; WSL file access (https://nelsonslog.wordpress.com/2019/02/16/plan-9-rides-again-wsl-file-access/)
* WSL Distro Launcher Reference Implementation (https://github.com/Microsoft/WSL-DistroLauncher)
* Shipping a Linux Kernel with Windows (https://devblogs.microsoft.com/commandline/shipping-a-linux-kernel-with-windows/)
* Awesome Powershell (https://github.com/janikvonrotz/awesome-powershell)
* WSL2-Linux-Kernel (https://github.com/microsoft/WSL2-Linux-Kernel)
* ArchWSL (https://github.com/yuk7/ArchWSL)
* XMing (https://sourceforge.net/projects/xming/)
* VcXSrv (https://sourceforge.net/projects/vcxsrv/)
* Project Drawbridge (https://www.microsoft.com/en-us/research/project/drawbridge/)
* How to install Flat-Remix Theme on Any Linux Distribution? (https://www.osradar.com/install-flat-remix-theme-ubuntu/)
* 2016 - Bash on Ubuntu on Windows (https://devblogs.microsoft.com/commandline/bash-on-ubuntu-on-windows-download-now-3/)
* Installing PowerShell Core on Linux (https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-6)
* Install .NET Core SDK on Linux Ubuntu 18.04 (https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/sdk-current)
* coLinux (não-suportado mais) (http://www.colinux.org)
* Cygwin (https://cygwin.com/install.html)

* AkitaOnRails: Windows Subsystem for Linux is good, but not enough yet (https://www.akitaonrails.com/2017/09/20/windows-subsystem-for-linux-is-good-but-not-enough-yet)
* AkitaOnRails: Running Arch Linux over Windows 10! (https://www.akitaonrails.com/2018/04/29/running-arch-linux-over-windows-10)

## SCRIPT

Olá pessoal, Fabio Akita

O próximo grande upgrade de Windows 10 está próximo, não sei ainda se vai ser agora já em setembro ou outubro, mas quando vier ele vai trazer a funcionalidade que todo desenvolvedor estava precisando: conseguir rodar aplicações de Linux quase nativamente em Windows 10.



Acho que a esta altura quase todo mundo já ouviu falar do tal WSL ou Windows Subsystem for Linux. Porém muita gente ainda não entendeu direito o que é isso. Na real é super simples. E se você é iniciante e já assistiu meus vídeos da série Começando aos 40, muito do que eu expliquei na parte de virtualização e containers vai ser usado hoje então, se ainda não assistiu, recomendo assistir antes, especialmente os que explicam sobre virtualização e containers.



Rodar um ambiente Unix ou Linux em cima do Windows, com suporte oficial da Microsoft, é um elo perdido que muitos de nós viemos perseguindo nas últimas décadas, eu mesmo venho acompanhando isso faz algum tempo. E pra sua surpresa essa nem é a primeira vez que a Microsoft oferece algo assim. Se você está interessado só na parte prática do WSL pode pular direto pra este tempo aqui embaixo, mas como sempre eu vou fazer uma tangente pela história, então vamos lá.

Essa história se inicia nos primórdios dos anos 80. Se você não sabe disso a Microsoft cresceu graças à IBM que licenciou seu MS-DOS para ser instalado nos IBM PC, fruto da amizade da mãe de Bill, Mary Gates com o CEO da IBM na época, John Opel. Todo mundo relaciona Microsoft com MS-DOS e depois Windows. Todo mundo relaciona interface gráfica com o Macintosh original ou no máximo com o Apple Lisa e a Xerox Parc. Em termos de interfaces gráficas, existiram diversas tentativas como o GEM dos Atari ST, o famoso Amiga Workbench no AmigaOS, o DeskMate do TRS-80. 





Mas em processadores de 8-bits que, com muito esforço, dava pra mapear 64 kilobytes de RAM, desperdiçar espaço com interfaces gráficas era demais. O AmigaOS, por exemplo, precisava do processador Motorola 68000 de 16 ou 32-bits. De qualquer forma pouca gente relaciona que a Microsoft teve outros sistemas operacionais e outras interfaces gráficas muito antes do Windows.




Por exemplo, vocês sabiam que a Microsoft já teve um UNIX de verdade? Sim, muito antes da Apple comprar a Next e transformar o NextStep no OS X. Aliás, vale relembrar: Linux não é um UNIX, ele é mais ou menos compatível, mas na prática é um sistema operacional totalmente diferente. O UNIX original vem da Bell Labs e sua herança hoje vive nos derivados de BSD como FreeBSD ou NetBSD e no Darwin do MacOS. A maioria dos UNIX de verdade vieram desaparecendo ou diminuindo consideravelmente com o tempo como o Solaris da Sun ou o Irix da Silicon Graphics que, de curiosidade, se você assistiu Jurassic Park, já viu o Irix funcionando.





Em 1980 a Microsoft se uniu à SCO ou Santa Cruz Operation e eles desenvolveram o Xenix que era outro UNIX de verdade, e estamos falando mais de uma década antes do surgimento do Linux. Segundo a Microsoft era um UNIX muito próximo do UNIX original versão 7 que rodava nos minicomputadores PDP-11. Aliás, de curiosidade também, antigamente a gente chamava os mainframes de computadores, coisas como o PDP são os minicomputadores, e os Commodore, TRS-80, Sinclair, MSX, e mesmo os IBM PC eram os microcomputadores. Por isso falamos em "micros". 





Enfim, uma das idéias era evoluir o MS-DOS 2 pra se aproximar do XENIX em single-user, que iria virar o XEDOS, mas foi mais um vaporware que nunca saiu do papel. Aliás, foi daí que o termo "vaporware" nasceu, em 1982 por causa do XENIX. A SCO seguiu sozinha com seu SCO UNIX depois e a Microsoft desistiu da idéia e se uniu à IBM pro projeto OS/2 em 1987.




Esse período foi especialmente conturbado porque estamos falando da transição dos processadores de 8-bits como os antigos Z80 ou Intel 8086 e 8088 e indo pra 16-bits com o 80286, que inclusive foi onde eu ganhei meu primeiro computador, um clone de IBM PC XT em 1989. Porém o 286 era um processador complicado, pra dizer o mínimo. Estávamos migrando do modo real de execução pro modo protegido, que hoje é o padrão. Nessa transição apareceu a necessidade de emular o 8086 no modo protegido. Mas o modo protegido e emulado do 8086 nos 286 era falho. Além disso existia o problema do endereçamento segmentado de memória, diferente do modelo flat que você está acostumado hoje, onde pode endereçar toda a memória de 32 ou 64-bits. 





Pense que em 16-bits você só consegue endereçar 64kb de RAM, pra ter acesso a mais RAM você precisa apontar pra espaços secundários, ou segmentados, de RAM. Como um índice apontando pra uma página em outro livro. Em termos simples você tinha um índice de 24-bits com endereços de 16-bits em múltiplos segmentos. No frigir dos ovos, com os problemas de hardware não seria possível rodar múltiplos ambientes paralelos de MS-DOS como deveriam. E a Microsoft obviamente não gostou muito disso.






Na parceria da IBM com a Microsoft eles desenvolveram o OS/2. A primeira versão era só modo texto, e a primeira interface gráfica tinha a cara do Windows 2, que saiu mais ou menos na mesma época. Porém a IBM insistiu no suporte ao 286 e esse foi um dos motivos da quebra da parceria porque o MS-DOS e o Windows tinham problemas com o 286. A Microsoft queria ir direto pro 386 de 32-bits que era muito melhor. Aliás, no caso do 286, imagine um processador que tinha máximo de 16MB de RAM. Claro, estamos falando de 1988. Os 386, em comparação, sendo de 32-bits, tinha máximo teórico de infinitos 4GB de RAM. Mas mais importante, rodava DOS em modo protegido perfeitamente.






Por outro lado, a IBM queria privilegiar a sua linha de hardware, claro, e eles tinham se comprometido com os 286 e sua linha de PCs PS/2 (entenderam? PS/2, OS/2 ...) e por isso insistiram no OS/2 ser especializado nesse processador. Então em 1992 a IBM e a Microsoft se separaram, a IBM se manteve com o OS/2 e a Microsoft estava muito bem, obrigado, com seu Windows 3, a interface gráfica de maior sucesso da época. 





Em paralelo a isso a Microsoft começou a criar um sistema operacional portável pra múltiplas arquiteturas de computador como processadores RISC da MIPS, PowerPC, Itanium, Intel e contratou Dave Cutler que trabalhava na VMS, que fazia o VAX/VMS mas não estava interessado em muitas de suas idéias. Daí ele foi pra Microsoft e caiu no projeto NT onde ele pôde aplicar muitas dessas idéias. Aliás, o nome Windows NT tem alguma controvérsia no seu significado, muitos talvez ainda pensem em NT como sendo New Technology. 






O Dave Cutler vai dizer que WNT seria uma brincadeira em cima do nome da VMS de onde ele veio. Assim como muita gente gosta de brincar que IBM é uma brincadeira em cima do nome HAL, a inteligência artificial do filme 2001 do Stanley Kubrick. Se você pegar HAL e dar shift de uma letra pra frente, o H vira i, o a vira b e o l vira m. Mesma coisa com VMS se você der shift uma letra pra frente o v vira w o M vira N e o S vira T e daí WNT ou Windows NT. Tem outras teorias mas eu pessoalmente gosto mais dessa. Hoje em dia na real não significa nada, só um nome mesmo.






Com o objetivo de ser portável o Windows NT implementa uma camada de abstração do hardware, chamado convenientemente de HAL também, ou Hardware Abstration Layer. Vocês veem que nós de programação não somos exatamente muito criativos com nomenclatura das coisas. Além disso o NT começou tentando implementar um micro-kernel, inspirado nas idéias da kernel Mach de Carnegie Mellon. Hoje em dia nós usamos kernels monolíticos ou kernels híbridos. A idéia de um microkernel é ser um kernel o mais minimalista, leve e estável possível rodando no modo de supervisão ou Ring-0 que é o anel de maior privilégio. Eu expliquei isso em outro vídeo. Daí todos os serviços que compõe o sistema rodam em user mode ou Ring-3. O problema disso é que você acaba com um overhead muito grande de IPC ou interprocess communication pois os programas rodando no anel de menor privilégio precisam ficar constantemente se comunicando com o kernel que roda no anel de maior privilégio.




Essa controvérsia de micro-kernels versus kernels monolíticos ou macro-kernels foi tema de grande discussão na comunidade Linux no começo, inclusive é um episódio histórico a discussão de Linus Torvalds defendendo o design monolítico da kernel do Linux contra a visão acadêmica de micro-kernels do professor Andrew Tanenbaum, autor de um dos livros sobre sistemas operacionais mais famosos e que você provavelmente teve que estudar se cursou ciências da computação. Na prática, apesar do design de micro-kernels ser o mais elegante, macro-kernels funcionam melhor como o sucesso do Linux já comprovou.





No caso do NT, por exemplo, subsistemas de drivers de I/O, como video ou mesmo impressão rodavam tudo em Ring-3, em user-mode, como deveriam. Mas no Windows NT 4 eles foram movidos pro Ring-0, dentro do espaço do kernel. Eu costumo dizer que o Windows NT mais estável e robusto era o Windows NT 3.5 justamente porque ele tinha o menor kernel, mas pro hardware da época acho que não tinha muita alternativa. No Windows 2000 ou XP se não me engano eles moveram uma parte do IIS na versão 6.0, pro Ring-0 na forma do driver HTTP.sys. Isso substituiu o Winsock que rodava em user-mode, e eu acho que isso foi um erro. Imagine parte do seu servidor web embutido na kernel incluindo coisas como cache e fila de requests. De qualquer forma isso garantiu melhor performance pro IIS se comparado ao Apache que rodava exclusivamente em user mode, mas ao custo de bugs na stack de HTTP potencialmente causarem problemas no nível do kernel, que poderia levar desde um crash do sistema até a buracos sérios de segurança.






A equipe do Windows NT era formada por muita gente da DEC ou Digital Equipment Corporation, liderada pelo Cutler, e uma das tais idéias que ele trouxe da VMS foi a noção de um sistema operacional orientado a objetos e por isso na arquitetura do NT você tem um Object Manager na camada privilegiada do Windows Executive, abstraindo todos os recursos do sistema na forma de objetos lógicos. Além deles alguns membros da equipe vieram do time do OS/2 que também queria integrar noções de orientação a objetos. Uma das coisas que eu achava fascinante na interface do OS/2, o Workplace Shell, é que tudo eram objetos. Infelizmente isso não foi implementado no Windows. Mas por exemplo, em vez de abrir um programa e clicar no menu em Novo Arquivo, você abria uma pasta de templates e arrastava o template pro desktop pra criar um novo arquivo, como uma instância de uma classe. A idéia de orientação a objetos foi embutido em todos os sistemas operacionais dos anos 90 e por isso coisas como a API de um NextStep sendo orientados a objetos, e você tem abstrações e encapsulamento de comportamento criando coisas como o Hardware Abstration Layer do NT.






Pra todos os efeitos e propósitos, do fim dos anos 80 pro início dos anos 90 eu diria que os sistemas operacionais desktop mais avançados eram o OS/2, o AmigaOS, o NextStep e o Solaris. Eles inspiraram diversos outros como o BeOS ou o Irix. Mas os mais populares eram sem dúvida o MS-DOS, o Windows 3.1 e o System 7. O Windows NT apareceu pela primeira vez em 1993 com o nome de Windows NT 3.1 pra ser paralelo ao nome Windows 3.1 que era completamente diferente e ainda rodava por cima do DOS. De comum eles tinham basicamente a mesma interface gráfica.





Daí em 1995 tudo mudou com o advento do Windows 95, trazendo a era de 32-bits pros desktops populares. Comparado com hoje em dia, eu lembro como a gente achava o Windows 95 pesado, precisando de 4MB de RAM sendo que o Windows 3.1 rodava tranquilamente com 2MB de RAM. No ano seguinte saiu o Windows NT 4.0 com a interface mais parecida com do Windows 95. Os NT, pela natureza da sua arquitetura mais robusta também precisava de mais recursos pra rodar, eu acho que com menos de 8MB ou 16MB de RAM não dava pra rodar decentemente, e por isso eles eram mais usados em servidores.






Nos anos 90 fomos evoluindo do Windows 95 pro 98 até o famigerado Windows ME ou Millenium Edition. E no lado do NT que era mais voltado a servidor fomos do NT 4 pro 2000. Passamos os anos 90 surfando na Lei de Moore e processadores mais rápidos iam saindo o tempo todo, do 486 pros Pentium pro Pentium II, Pentium III, no servidor tínhamos os Itanium. RAM foi ficando mais barato. A grande virada veio em 2001 com a unificação dos Windows no famigerado XP e finalmente nos livramos do legado do MS-DOS por baixo do Windows. Desde então sempre tivemos uma versão de NT pra desktop e outro pra servidor. 




Então na era do XP tivemos o Windows Server 2003 e 2003 R2. Com o Windows Vista sucedendo o XP tivemos o Windows Server 2008. Depois o Windows 7 e o Windows 2008 R2. Depois disso o Windows 8 e o Windows Server 2012 e 2012 R2 e na geração do Windows 10 a partir de 2015, que teoricamente vai ter só upgrades sem mudar o nome, tivemos o Windows Server 2016 e Server 2019. O Windows 10 hoje está na oitava edição estável build 1903 de maio de 2019. Essas edições costumam sair entre abril e maio e depois outubro, por isso eu acho que a próxima edição importante vai sair em outubro de 2019.





Eu falei que o NT desde o começo veio com a mentalidade de ser portável, ele não rodava só em Intel. Mas aos poucos o suporte de hardware foi diminuindo à medida que essas arquiteturas foram caindo em desuso. Por exemplo, no Windows 2000 caiu o suporte a MIPS, Alpha e PowerPC. Mas além do lado hardware o NT implementou a idéia de "personalidades" ou subsistemas. Você tinha a Win32 que é o suporte a API moderna do Windows. Hoje em dia programas 32-bits rodam emulado sobre o WoW64 ou Windows 32 on Windows 64. Mas desde o começo ele foi lançado com suporte a subsistemas como OS/2 que permitia um grau de compatibilidade com a API do OS/2, já que a Microsoft tinha interesse no nicho que eles ajudaram a criar com a IBM. 






Claro que eles precisavam manter compatibilidade com o MS-DOS e pra isso eles já embutiam uma virtual machine pra DOS. Sim, um tipo de máquina virtual. E pra conseguir atender contratos de governo que requeriam UNIX eles também tinham um subsistema compatível com POSIX, que como eu já expliquei em outro episódio, é a superfície de compatibilidade com os UNIX da época.





Ou seja, seria possível pegar o código fonte de aplicativos feitos pra UNIX e teoricamente compilar num Windows NT e rodar nativamente! Ele era compatível com o padrão POSIX.1 por isso não tinha um shell ou ambiente de uso e comandos de usuários, coisas como um mísero 'ls', que só passaria a existir como padrão no POSIX.2. Por isso pra usuários normais de Linux como nós, esse ambiente é basicamente inútil. Só serve se você tinha código fonte em C compatível com POSIX.1 e precisava de um compilador C compatível.






Com a evolução rápida das distros Linux nos anos 90 e igualmente rápido desuso dos UNIX, esse subsistema no Windows era meio inútil. Nesse vácuo, projetos open source como o Cygwin apareceram. Cygwin se chama assim porque foi criado pela empresa Cygnus Solutions que depois foi adquirida pela RedHat. Era um ambiente em user-mode compatível com POSIX e com Linux em particular. E diferente do subsistema POSIX original da Microsoft, eles portaram boa parte do toolchain do GNU no pacote, trazendo shells como bash e além das ferramentas pro compilador, também trouxe diversas outras coisas úteis como awk, sed, tar, ssh, servidores como Apache, Postgres, linguagens como Perl, Python, Ruby, Prolog e muito mais. 






Era como uma distro baseada em Linux rodando sobre uma camada que tentava abstrair o NT por baixo na forma de DLLs. Muita gente ainda usa Cygwin até hoje e sempre foi a melhor ou mesmo a única forma de rodar muitas ferramentas de Linux de forma nativa no Windows. Mas Cygwin não se encaixa na categoria de distro de Linux porque ele tem uma semi compatibilidade em nível de código fonte, mas os binários de Linux não rodam no Cygwin nativamente, precisa recompilar sempre.





Com o passar dos anos o subsistema POSIX original foi removido no Windows XP e Windows Server 2003 sendo substituído por outro subsistema que foi originalmente desenvolvido por uma empresa chamada Interix, adquirida pela Microsoft, e sua solução foi renomeada como Windows Services for UNIX ou SFU e você podia instalar opcionalmente. O suporte ao SFU veio gradativamente diminuindo, tendo muitos de seus componentes removidos do instalador até o Windows 8 e Windows Server 2012. Mas pra todos os efeitos e propósitos ele é muito similar ao Cygwin só que o Cygwin é compatível com GNU/Linux e o SFU é compatível com UNIX. Novamente, se você tinha código fonte de UNIX podia compilar no SFU e rodar no Windows.






Em 2004 surgiu a primeira forma de rodar Linux sobre o Windows de verdade, sem virtualização. Foi o Cooperative Linux ou coLinux. Infelizmente a última versão estável dele é de 2011 então não espere que ele funcione hoje em dia. Mas em vez de ser um subsistema ou uma máquina virtual, ele era uma kernel linux modificada que era carregado no Ring-0 do lado do kernel do NT. E ele compartilhava os recursos da máquina com o kernel NT, por isso cooperativo. Isso era possível através de um driver, e drivers rodam em Ring-0 junto com ferramentas como um Windows Service pra dar acesso. Daí em user-land você podia rodar os binários originais de uma distro como Ubuntu ou Arch. Dava pra acessar o terminal via SSH ou mesmo a interface gráfica do X via um VNC. Pra todos os efeitos era quase como rodar um Virtualbox mas sem o overhead de virtualização. Eu imagino que manter suporte de algo assim deve ser bem complicado porque você meio que está lobotomizando o kernel do NT por um hack via um driver.






Como podem ver, rodar Linux ou UNIX sobre o Windows é uma coisa que muita gente já tentou fazer de diversas formas. Com hardware moderno, a opção mais estável é abrir um Virtualbox ou VMWare e rodar virtualizado. Graças à evolução do suporte de virtualização dos processadores, na minha experiência não só é viável mas serve muito bem como máquina principal de desenvolvimento. E quando eu digo hardware moderno estou falando no mínimo de um Core i5 de 4 cores com no mínimo 8GB de RAM, preferencialmente 16GB. O problema de virtualização normal é que normalmente você precisa pré-reservar quantos cores e quanto de RAM vai ser dedicado pra máquina virtual.





Vejam o problema. Com soluções como o subsistema POSIX, o Cygwin ou o SFU tudo roda nativo, não é virtualização. Mas pra funcionar você precisa ter o código fonte de tudo, talvez modificar alguma coisa, compilar e gerar um binário nativo de Windows NT. Se conseguir fazer isso o binário vai rodar como qualquer outro binário de Windows. Por outro lado, é muito difícil conseguir compatibilidade com tudo e muita coisa simplesmente não vai nem compilar sem modificações significativas. Pelo simples fato que as primitivas do kernel do NT são diferentes do kernel do Linux. Já expliquei em detalhes em outros vídeos como o Windows, o Mac e o Linux gerenciam coisas como estrutura de processos, scheduler de threads, memória, I/O de formas diferentes.





Por exemplo, num SFU não adianta eu compilar alguma coisa como o programa 'ip' ou o antigo 'ifconfig', eles vão tentar mexer em coisas como o /etc/network/interfaces que o Windows NT não usa pra expor suas interfaces de rede. Isso sem contar que coisas como 'fork' funcionam diferente no Windows, como já expliquei no vídeo de gerenciamento de memória. Não adianta eu compilar um programa que gerencia processos via o diretório /proc porque o Windows não expõe os metadados dos processos lá. O sistema de autenticação e permissão são completamente diferentes, então nenhum programa que gerencia usuários e permissões como 'useradd' ou 'chown' vai conseguir modificar nada no Windows. Essas diferenças tornam complicado rodar programas de UNIX ou Linux lado a lado de programas Windows porque existe uma dissociação semântica enorme.






Por outro lado, rodar dentro de uma virtual machine traz a vantagem de isolar completamente os comportamentos de Linux e Windows. De dentro da máquina virtual tudo funciona perfeitamente como se fosse uma máquina de verdade isolada. Daí você controla coisas do host Windows via ferramentas de Windows e coisas de Linux separadamente com coisas de Linux e cada um vive feliz separado.




Vamos ver o caso do macOS rapidamente. Como ele foi construído sobre uma fundação UNIX, todo o sistema operacional obedece às leis do UNIX. Todo programa de Mac é de fato um processo UNIX e pode ser controlado com coisas que todo mundo de Linux conhece. Se eu usar o comando `ps` no terminal, vai listar processos como o Chrome ou Final Cut. Se eu usar o comando `kill` no terminal, vai matar de fato os programas todos. Se eu usar comandos como `ip` eu de fato gerencio as interfaces de rede da máquina, e assim por diante. A API do Mac é construído sobre as APIs do UNIX por baixo. Então a integração é praticamente 100%. Um serviço de UNIX é um serviço de Mac e assim coisas como servidor de SSH ou Postgres rodam lado a lado de serviços do Mac. Usuário de Mac são usuários do UNIX. Permissões de arquivos feitos via o Finder ou feitos via Terminal com comandos como 'chown' ou 'chmod' são a mesma coisa. Por isso existe coerência semântica entre os aplicativos gráficos e os de linha de comando. E a Apple trouxe muito do toolchain GNU pra dentro, então o MacOS é como se fosse um FreeBSD mais bonito, na prática.





Por outro lado, assim como no subsistema POSIX, Cygwin ou SFU no Windows, o macOS tem compatibilidade de código-fonte mas não de binário. Binários formato ELF de Linux não são compatíveis com binários de BSD ou macOS ou Cygwin ou SFU. Por isso no Mac você precisa compilar programas de Linux especificamente pra rodar no Mac e por isso a gente não pode usar pacotes pré-compilados que já existem em distros como Ubuntu ou Arch. Por outro lado, ao contrário de Cygwin ou SFU, o comportamento do macOS, que é parecido com o comportamento do BSD e tem a mesma semântica do Linux, garante que quase todo o código-fonte seja compatível porque coisas como interfaces de I/O, gerenciamento de memória e de threads é significativamente parecido. 




Então existe algum trabalho que precisa ser feito no código-fonte de alguns programas, mas no geral, basta recompilar no Mac e tudo magicamente funciona. O mesmo não pode ser dito em ambientes como o antigo subsistema POSIX ou SFU ou Cygwin. E mesmo quando compilam, eles não tem acesso ao resto do sistema Windows.





A grande reclamação do povo de Linux quanto a gerenciar os recursos de um Windows é que tudo precisa ser feito via ambiente gráfico. Por isso gerenciar um servidor remoto sempre exigiu coisas como um Remote Desktop ou VNC pra podermos ter a tela gráfica remotamente. É um puta pé no saco quando em servidores Linux podemos conectar via terminal com um cliente de SSH e gerenciar todos os recursos da máquina via linha de comando. Pra resolver parte disso a Microsoft criou o Powershell.




Em resumo, a história remete ao fim dos anos 90 de novo, quando a Microsoft iniciou o projeto .NET. Com o tempo boa parte, se não toda a API do Windows, foi mapeada em classes dos frameworks disponíveis no .NET, além de componentes COM e WMI. Porém o antigo programa de linha de comando do Windows, o Command, que herda as características do antigo MS-DOS, é um lixo. As linguagens de script que ele traz como o BATCH ou REXX, oriundo da antiga herança do OS/2, são muito fracos e quase nada do sistema operacional é exposto pra linha de comando, você é obrigado a programar coisas como scripts em visual basic pra acessar o WMI ou componentes COM que tem algum acesso a algumas coisas do sistema como gerenciar usuários. Esquece fazer scripts complicados como os que fazemos em Bash pra Linux.





Porém, uma idéia interessante é um console de linha de comando com acesso ao framework do .NET. E é basicamente isso que é o Powershell. Ele trás uma linguagem de script mais poderoso e com muitas coisas que encontramos num Bash. Ele tem inclusive um pipe! E eu argumentaria que um pipe superior ao do Linux. No Linux todo script ou comando aceita argumentos e um stream de bytes que chamamos de standard input e tem uma saída de bytes na forma do standard output, que eu também já expliquei nos vídeos sobre concorrência e paralelismo. E por isso você precisa de comandos como awk ou sed ou grep pra tratar o texto que os scripts devolvem. No caso do Powershell os comandos devolvem estruturas de .NET, ou seja, são dados estruturados. 





O episódio nem é de Powershell mas obviamente agora eu empolguei. Eu também acho interessante que muita gente que usa Linux nunca viu Powershell. Pense num script de Bash pra selecionar processos que estão usando mais que 100MB de RAM, como você faria. Num bash provavelmente algo parecido com este script aqui:

```
ps -eo rss=,pid=,user=,comm= k -rss |
  while read size pid user comm
  do
    if [ "$size" -gt 102400 ]
    then
      echo "$pid $size $user $comm"
    else
      break
    fi
  done
```

Ou seja, precisamos ir linha a linha da saída do comando `ps` e checar o tamanho em kilobytes até achar o que queremos. Em Powershell podemos fazer assim:

`Get-Process | Where-Object WorkingSet -gt 104857600`

E como o Powershell suporta aliases e ele já vem com muitos aliases pré-programados, a mesma linha poderia ser escrita assim:

`ps | ? WorkingSet -gt 104857600`

Do ponto de vista de usabilidade pra novatos, a sintaxe do Powershell é muito mais fácil de ler. E pra veteranos de shell existem formas de simplificar pra comandos mais familiares. E veja como estamos usando o pipe pra passar os objetos do ps pro where-object fazer um filtro na propriedade do objeto. E isso é universal pra todos os comandos.




Tecnicamente eu diria que o Powershell pode ser considerado superior em muitos aspectos a Bash ou outros shells de Linux. Eu acho que não é 100% do Windows que pode ser controlado via Powershell mas uma parte considerável pode, e ele pode ser estendido via .NET, então seja via C# ou F# você pode expor o que quiser pra esse shell. E mesmo se você for de Linux pode usar Powershell, porque a Microsoft abriu não só o .NET na forma do .NET Core como open source como também o Powershell na forma do Powershell Core. Aqui o problema é o inverso, ainda não sei quanto do Powershell se integra aos recursos do Linux mas ele pode ser uma opção interessante pra fazer scripts de automação numa linguagem menos cheia de truques se comparado a um Bash, especialmente se estiver rodando coisas como SQL Server pra Linux e outros programas .NET. Ele é particularmente bom pra lidar com dados estruturados como JSON.





Essa tangente pro Powershell foi primeiro pra introduzir vocês ao tema, mas segundo pra dizer que apesar dele ser muito bem feito e eu pessoalmente achar elegante e um passo grande pra Microsoft, ele ainda não resolve o problema de quem quer usar o Bash de verdade e está acostumado com o ferramental GNU. Mesmo o Powershell sendo bacana, a gente ainda quer usar ferramentas antiquadas mas funcionais como awk, sed, grep e tudo mais. A única saída nesses casos é instalar Cygwin ou rodar num Virtualbox já que o subsistema POSIX já morreu, o SFU já morreu, e o coLinux não tem suporte desde 2011.





Até aqui eu expliquei como era possível rodar alguma coisa de UNIX ou Linux no Windows mas e o oposto? Ou seja, rodar programas de Windows no Linux? Se você já brincou de Linux por algum tempo já deve ter ouvido falar ou mesmo usado o projeto Wine ou Wine is not an Emulador que é um acrônimo recursivo, coisa de programador, como eu já disse a gente é ruim de nomenclatura. O Wine é um projeto capaz de carregar um binário feito pra Windows, sem precisar recompilar, e executar no Linux. Pra fazer isso ele mapeia as chamadas de API pra Kernel do NT em chamadas pra kernel do Linux e faz engenharia reversa de dezenas de DLLs que compõe o Windows e com isso ele consegue executar muitos aplicativos de Windows rodando com performance quase nativa em ambiente Linux. Claro, engenharia reversa significa que 100% de compatibilidade é extremamente difícil. Muitos aplicativos abrem e rodam bem, mas algumas partes deles podem precisar de APIs que não foram reimplementados ainda e crashear ou simplesmente não funcionar. 






Lembram como no video sobre Ubuntu eu falo como não dava pra rodar todos os games do Windows no Linux? Muitos me lembraram depois que a Steam tem o projeto Proton que permite rodar muitos jogos, mas não todos. Você precisa consultar o site da comunidade, o ProtonDB pra ver se seu jogo roda. Na realidade o Proton usa Wine por baixo. Ele é mais um de uma família de aplicativos que usam Wine e tentam facilitar a instalação de dependências pra programas específicos, como o antigo CrossOver. Por isso o Proton consegue rodar jogos que originalmente foram feitos pra Windows, mas em Linux. O Wine é como se um fosse uma camada de Windows dentro do Linux. 





O maior problema é que como os binários do Windows não são código aberto, é preciso fazer engenharia reversa dos binários e reimplementar do zero no Linux. É um processo black-box de desenvolvimento, ou mais corretamente, um grande cornojob de tentar executar o binário do Windows, ver ele crasheando, ver que chamada de sistema ele tentou fazer que ainda não existe e implementar essa função no Linux. Função a função. Wine existe já faz muitos anos e com o tempo ele evoluiu bastante, mas o Windows não parou no tempo também, então cada vez que sai uma versão nova, o Wine ganha mais trabalho pra suportar as coisas novas. É um trabalho insano que me deixa fascinado pelo fato de até hoje ainda existir.





Muito bem, vamos resumir agora. Vocês lembram o que eu já expliquei em outros vídeos. Um sistema operacional é composto de pelo menos duas partes principais, o kernel e drivers e outros subsistemas que rodam no Ring-0 de maior privilégio do sistema. E a outra parte são outros subsistemas e aplicativos que rodam em user-land ou Ring-3 de menor privilégio. Pra rodar os programas de outro sistema operacional você precisa ter as dependências, talvez fazer algumas modificações no código-fonte, recompilar o programa. É o processo que chamamos de "portar". É pra isso que serviam ambientes como o subsistema POSIX, o SFU e o Cygwin. É como funciona no macOS hoje ou mesmo nos BSDs. Compatibilidade de nível de código-fonte. Quer rodar programas de Linux fora do Linux, precisa recompilar em todos esses ambientes: Windows, macOS ou outros UNIX.






Pra rodar um binário de outro sistema operacional, sem recompilar, você precisa ter o kernel e dependências rodando lado a lado do seu sistema principal e um mecanismo pra carregar os binários não modificados. O coLinux conseguiu executar a kernel do Linux cooperativamente, compartilhando os recursos da máquina, do lado da kernel do NT, ele conseguia montar um filesystem de Linux e executar os programas de Linux em user-land sem precisar recompilar nada. Você podia rodar os binários de um Ubuntu ou Arch por cima desse ambiente. 




Fora isso você tem a opção de virtualização, seja com VirtualBox, VMWare ou Hyper-V, daí você roda tudo em user-land mas com as instruções da VT-X da Intel que permite o kernel virtualizado conseguir acessar o hardware por baixo com menor overhead possível. Você perde 20% ou mais de performance virtualizando, dependendo da configuração do seu hardware, mas no geral tudo funciona perfeitamente. Virtualização é uma opção quase plug-and-play hoje em dia. 






Eis que do nada a Microsoft anunciou o projeto Windows Subsystem for Linux ou WSL 1 como podemos chamar hoje. Ele começou a aparecer no Fast Ring do Windows Insider lá pelo Anniversary Edition acho que pelo começo de 2016, e foi lançado de verdade no Creators Update uns 3 meses depois. Hoje em dia temos o WSL 2 que é completamente diferente e já vou explicar porque. Mas o WSL 1 do ponto de vista técnico é muito mais interessante, mas eu entendo porque eles desistiram dessa forma.





Antes de mais nada, a Microsoft faz muita pesquisa, e eventualmente muitos dos resultados dessas pesquisas realmente acabam no Windows de verdade. Um desses projetos foi o Drawbridge que estava pesquisando formas de rodar processos isolados, como em containers, sem precisar de virtualização. Um dos resultados foi permitir o kernel de criar processos com o mínimo ou zero de interferências. Lembram nos episódios de gerenciamento de memória que eu expliquei que dentro do espaço de endereços virtuais do processo o Windows mapeia suas DLLs de sistema e outras coisas pra compartilhar seus recursos com os processos e por isso um processo de 32-bits no Windows de 32-bits nunca tinha os 4GB totais disponíveis pra ele? O resultado desse projeto Drawbridge foi permitir o kernel NT de criar o que eles chamaram de Minimal Process e Pico Process que são processos sem interferência do OS, com o espaço de memória limpo. A diferença de um processo Minimal e Pico é que no caso do Pico existe um driver associado a ele que permite a comunicação desse processo pra fazer syscalls.





Isso existe desde 2013 e o time do WSL resolveu usar esse recurso pra carregar o binário não-modificado de um programa Linux que tem o formato ELF64 pra dentro de um Pico process. Agora pra executar, esse programa vai querer fazer coisas como syscalls pra kernel do Linux. E aí entra a parte do driver. Esse driver vai converter as chamadas pra kernel do Linux em chamadas pra kernel do NT. Então na prática não existe um kernel de Linux rodando. Quando o programa de Linux chamar um fork ele vai ser traduzido pro equivalente NtCreateProcess, ou se chamar fopen ele vai ser traduzido pro NtOpenFile e assim por diante. Na realidade a tradução acontece no nível do assembly, mas a idéia é a mesma.




Como já expliquei, o Windows trata todos os recursos do sistema como objetos, incluindo arquivos e o file system, tudo é roteado pelo Object Manager. E ele sempre teve essa idéia do HAL de abstrair o hardware. E de fato, por cima do NTFS temos o VFS ou Virtual File System. Se vocês já usaram Windows e Linux sabem que existem diferenças em como o filesystem NTFS do Windows e o EXT4 do Linux se comportam. Por exemplo, no Windows não tem como deletar um arquivo que está em uso por algum programa, no Linux podemos renomear ou deletar o arquivo mesmo que ele esteja em uso. São comportamentos diferentes e não defeitos na operação, prova disso é que o WSL 1 replica o comportamento de um EXT4 por cima do NTFS removendo algumas validações e checagens que no NTFS são ligadas por padrão. Inclusive o WSL consegue replicar o comportamento do ProcFS e SysFS pra expor partes do sistema operacional como arquivos, como no diretório /proc que lista processos do sistema como expliquei no episódio de Ubuntu.






Então esse novo subsistema que seria o herdeiro do antigo subsistema POSIX e do SFU emula o comportamento da kernel do Linux, sem de fato ter o kernel do Linux e sim traduzir tudo pro kernel NT, com a vantagem de carregar binários não modificados. Como eu já expliquei antes, tirando a kernel o que muda de uma distro pra outra são os binários de user-land. E como o WSL consegue carregar os programas de Linux diretamente nos processos Pico, sem precisar modificar ou recompilar esses binários, você pode literalmente pegar todos os binários de um Ubuntu ou Arch ou Fedora e rodar em cima desse subsistema.




Uma grande vantagem dessa forma é que ao abrir um Bash e usar comandos como ps ou kill podemos não só manipular programas Linux como programas Windows também. Muitos comandos que num Cygwin seriam inúteis como programas pra configurar interfaces de rede e muito mais passam a funcionar minimamente. Programas que manipulam arquivos podem manipular alguns arquivos do lado Windows também. Foi a primeira vez que programas Linux não modificados puderam rodar lado a lado de programas Windows. Era bizarro porque eu podia abrir o Task Manager do lado do Windows e ver cada programa de Linux individualmente listado. A integração era muito bem feita embora ainda incompleta.




Eu rodei esse ambiente por algum tempo, e apesar de não ser tudo que funcionava, era possível rodar tudo que eu precisava pra desenvolver projetos de Ruby on Rails ou Node.js incluindo bancos de dados como Postgres ou Redis e carregar servidores que corretamente faziam binds nas portas nativas do Windows, e conseguir testar do Chrome do Windows. Seria esse o ambiente perfeito?





Infelizmente havia ainda vários problemas. O maior ofensor eu diria que era a virtualização do file system. Essa virtualização em cima do VFS funciona, mas o VFS é interligado com o Windows Defender e outros antivírus e antimalware. Toda operação de disco no Windows dá trigger pro Defender avaliar se não tem perigo ler o arquivo. Obviamente isso adiciona um overhead gigantesco. Some a isso operações altamente custosas de I/O como um `npm install` em um projeto de Node e você pode ir tomar um café enquanto espera ele terminar. Isso poderia ser resolvido se a equipe do WSL mudasse a estratégia de tentar manter o file system aberto em cima do NTFS e simplesmente montasse um disco virtual dentro de um arquivão como no formato VHD que Virtualbox ou VMWare usam. Máquinas virtuais costumam montar o filesystem do sistema Guest na forma de arquivos esparsos, ou seja, digamos que você configure um HD de 1 TB dentro do Linux virtualizado mas seu HD de verdade só tem 500GB. Claro que não cabe, mas você não precisa pré-alocar esse espaço, pode só mentir pro sistema virtualizado e só alocar o que ele realmente for usar e ir adicionando novos blocos nesse disco virtual sob demanda.






Mas o problema principal não é esse. O conceito original é mapear syscalls do Linux pra syscalls do kernel NT. Eles esbarraram no mesmo problema que a equipe do Wine tem até hoje: toda vez que sai uma atualização pro Windows, alguma coisa vai quebrar no Wine porque as syscalls e outras dependências mudaram. Então manter essa camada de compatibilidade entre as duas kernels vai ser sempre instável. Toda vez que sai uma versão nova da kernel do Linux, alguém na equipe do WSL vai precisar ajustar essa camada de tradução. Então nunca vai ser possível ter um sistema totalmente estável porque essa é a natureza de wrappers e adapters, eles são alvos móveis.





Ficar fazendo isso desde 2016 demonstrou que como prova de conceito, de fato tudo funciona, mas muitas syscalls de Linux não tem equivalente em NT e davam trabalho de manter. E toda vez que a kernel atualizava tanto do lado Linux quanto do lado NT, precisava ajustar a camada de adaptação. É uma bola de neve sem fim. Por fim eles decidiram mudar a estratégia toda e recomeçar do zero.





É uma pena, porque como eu disse, eu gostava muito dessa estratégia porque uma das vantagens era ter os recursos do Windows como processos em execução, expostos numa camada Linux onde era possível usar as ferramentas de Linux pra mexer em partes do Windows. Se eles conseguissem abstrair coisas mais complicadas como o Registry em alguma forma que pudesse ser gerenciada pelo Bash, ia começar a ficar mais útil ainda, mas aí já era pedir demais mesmo. Pra isso existem coisas como o Powershell. Se a intenção é gerenciar os recursos do Windows pela linha de comando, ainda é muito melhor, mais estável e mais completo usar o Powershell.





Em vez de tentar fazer de tudo, melhor fazer menos mas fazer direito. Já que é muito difícil emular a kernel do Linux como um adaptador em cima da kernel do NT e se simplesmente rodássemos o kernel do Linux de verdade? Seria a estratégia do coLinux, mas em vez de um hack, podemos usar o Hyper-V que nesta altura evoluiu bastante e é muito bom. O problema com programas de virtualização, como expliquei antes é que você normalmente precisa reservar quantos cores e quanta RAM vai ficar travado pra máquina virtual.





Mas durante a evolução do Windows Server pra atender os requerimentos de serviços como o Azure, eles conseguiram evoluir o Hyper-V pra criar máquinas virtuais mais leves e mais flexíveis. Existe a opção de lightweight utility VMs onde ele consegue pedir mais recursos à medida que for precisando. Daí não precisamos desperdiçar 4GB do sistema deixando reservado pra máquina virtual se logo no boot ele só precisa de 500Mb, por exemplo. Além disso existe a opção de não exigir um cold boot, ou seja, um boot do zero. Ele dá a opção de você conseguir carregar o equivalente a um dump da RAM, como no processo de hibernate. Dessa forma você consegue boots quase instantâneos, que levam segundos em vez de minutos.



E como também expliquei no video de virtualização, existe a opção de paravirtualização. Numa virtualização completa o kernel dentro da máquina virtual não sabe que está numa máquina virtual, é um Inception. Numa paravirtualização você modifica o kernel de dentro pra ele estar ciente de estar num ambiente virtualizado e conseguir um comportamento melhor cooperando com o sistema operacional do lado de fora.




Um último componente um pouco inusitado foi a inclusão de uma parte do antigo projeto Plan9, no caso o protocolo 9P que era usado pra file system em rede. Pense assim, como a partir do Windows eu poderia acessar o filesystem do Linux e vice versa se agora o Linux vai rodar de dentro de uma máquina virtual? Existem várias opções como o próprio protocolo SMB e o serviço SAMBA ou mesmo SFTP que é FTP em cima de SSH. A própria Microsoft não se manifestou do porque dessa escolha oficialmente, mas algumas teorias dizem que talvez seja porque o protocolo 9P é mais simples e mais fácil de implementar do que os disponíveis hoje.





De curiosidade o Plan9 é outro projeto da antiga Bell Labs que inventou a linguagem C e o UNIX, na realidade parte das mesmas equipes criaram o Plan9 que era um sistema operacional distribuído em rede. Com o tempo o Plan9 caiu em desuso e a Bell Labs criou o projeto Inferno que tinha como objetivo virar concorrente do então novo Java da Sun, e nas pesquisas de sistemas distribuídos tanto a Sun quanto a Bell Labs chegaram à conclusão que precisariam de uma máquina virtual pra lidar com tantas configurações de rede diferentes disponíveis na época. Vocês podem ver que a história da virtualização vem de longa data, e só nesse episódio vocês viram que nos anos 70, 80, 90 até os 2000 tinha alguma coisa de virtualização em cada solução da época. Virtualização e containerização não são tecnologias novas, são décadas e décadas de pesquisas e experimentação.





De qualquer forma, somando os lightweight utility VM do Hyper-V com a capacidade de boot rápido, mais uma kernel de Linux de verdade customizada pela Microsoft, mais a implementação do protocolo 9P pra exposição do filesystem em rede, e agora temos o Windows Subsystem for Linux versão 2 ou WSL 2. Ela nunca vai ter as mesmas possibilidades de integração com o resto do Windows como o WSL 1 tinha, mas por outro lado ela oferece 100% de compatibilidade binária com Linux, coisa que o WSL 1 nunca ia ter. E como agora o filesystem se tornou virtualizado, ele parou de ter os problemas de performance por causa do Windows Defender também. Por outro lado o WSL2 não oferece ainda opções pra configurar o filesystem virtual, se não me engano ele tem um limite máximo pra 256GB, o que é suficiente pra maioria dos cenários, mas seria bom ter futuramente a opção de expandir esse drive. 






Do ponto de vista de performance, sem rodar nenhum benchmark nem nada, eu diria que é a mesma performance que eu já sentia rodando num VMWare, porém reservando menos recursos da máquina no geral. Usando todos os dias tudo vem funcionando exatamente igual funcionaria num Linux em Virtualbox ou Vmware. É um linux virtualizado. E como bônus se de dentro do WSL2 você subir um servidor, digamos um servidor de Rails que se liga na porta 3000, você pode abrir o Chrome do Windows e acessar localhost:3000 e vai abrir normalmente, porque ele faz automaticamente o NAT interno de mapeamento de portas. Isso é ao mesmo tempo bom e ruim, porque se você tiver serviços no Linux com portas que conflitam com portas no lado do Windows, vai ter problemas que podem ser difíceis de diagnosticar. 






Do ponto de vista de ecossistema é um passo gigantesco porque se você acompanhou pessoalmente a história que eu contei até agora, como foi o meu caso, se no ano 2000 alguém me dissesse que um dia a Microsoft embutiria o binário da kernel do Linux dentro do Windows, eu diria que a pessoa era louca e devia se tratar. Diferente de alguma coisa como Cygwin, sendo suportado pela própria Microsoft, mais e mais pessoas podem depender dessa opção como algo estável e que vai estar disponível mesmo em futuros upgrades do Windows.





A história foi longa, mas instalar o WSL 2 é super easy, barely an inconvenience... Quando sair a versão oficial no próximo upgrade do Windows 10 você pode pular o primeiro passo, mas se ainda for setembro de 2019, você vai precisar se cadastrar no programa Windows Insider. Ah sim, só funciona no Windows 10 Pro, o Windows 10 Home não tem suporte a Hyper-V se não me engano. Uma vez cadastrado, você vai precisar habilitar o Fast Ring que vai trazer os builds mais recentes do Windows mas também tem o risco de vir binários instáveis. Habilitar o Fast Ring é concordar que você está baixando versões alfa de muita coisa e instabilidades fazem parte do contrato. Eu venho usando o Fast Ring faz meses e tirando uma ou duas vezes que tive telas azuis, no geral tudo tem funcionado sem problemas graves.






No caso até a data onde estou gravando este episódio está na build 18970. Com o Fast Ring ativado é só deixar o Windows Update baixar as últimas versões. Vai demorar bastante pra baixar e instalar a última versão, vamos esperar um pouco ... só mais um pouco .... só mais um pouco .... ah sim, em uma das vezes que fui instalar ele reclamou que eu tinha o VMWare instalado, precisei baixar a versão mais nova pra ele parar de reclamar, mas cuidado com isso: com o Hyper-V ativado, não dá pra usar Virtualbox nem VMWare até eles aderirem às APIs de virtualização da Microsoft. Enfim, uma vez atualizado daí é restartar. Agora você precisa abrir um Powershell como Administrador e digitar o seguinte comando: 

`Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform`


Isso vai exigir um restart e pronto, agora você já tem WSL. Abra um command prompt ou powershell e garanta que está com o WSL 2 como padrão executando o comando

`wsl --set-default-version 2`


E pra instalar o Ubuntu você pode ir na Windows Store, procurar por Ubuntu e instalar. É gratuito. Daí você espera um pouco … configura seu usuário e senha  e .... Instalado. Primeira coisa que eu sempre faço quando instalo é rodar o apt update e upgrade pra atualizar todos os pacotes. Daqui você pode seguir meu video de Ubuntu e praticamente tudo deve funcionar.




Eu digo praticamente porque o WSL é feito primariamente pra aplicativos de linha de comando como o próprio Bash, coisas como ssh, git e tudo mais. Mas sempre existe a opção de instalar um cliente X no Windows e rotear o DISPLAY do X no Linux pra ser fora dele. Se você não sabia disso, o X é outro capítulo conturbado na história do UNIX e Linux. Nós tivemos o XFree86, depois o X.org e finalmente muitos estão migrando pro Wayland. 



Em termos simples, o X é feito pra aplicativos gráficos. A intenção original é que um servidor UNIX com um servidor X poderia servir múltiplos terminais burros, incluindo terminais gráficos, que seriam clientes de X. Pense em servidor web e navegador web, é basicamente a mesma coisa só que em vez de trafegar um protocolo primitivo como o HTTP ele usa um protocolo próprio do X pra enviar comandos como "desenhe um botão na tela" e quando o botão é clicado essa ação trafega pro servidor X decidir o que fazer e devolver outro comando pra redesenhar alguma parte da tela. Isso até que funciona, o que o povo de desenvolvimento não gosta é da implementação, é um código difícil de dar manutenção.






E as coisas ficaram mais difíceis depois que a Apple mostrou o que era possível fazer com um sistema de composite e aceleração via hardware como o Quartz e a interface Aqua. Como você faz pros clientes X terem os mesmos recursos? Dificulta muito que o X era um monolito, que os drivers das principais GPUs como NVIDIA é proprietário e distribuído só como binário, e as versões open source tem qualidades variadas, e no final o que acaba acontecendo é que você raramente usa o X de forma distribuída e tanto o cliente quanto o servidor ficam na mesma máquina desktop de qualquer jeito. Por causa disso o X tem dois modos de renderização acelerada, a direta onde o próprio servidor X acessa a GPU e o indireto onde ele manda os comandos de OpenGL pro cliente rodar.





No caso do WSL, ele não tem acesso direto a algumas coisas incluindo o hardware de vídeo. Portanto ele depende de um rasterizador via software. Você não tem como rodar o cliente de X dentro do WSL porém você pode rodar o cliente de X de Windows e rotear os comandos de X do WSL via rede pra fora. E vai funcionar perfeitamente bem. Existem duas opções gratuitas e open source que são o VcXSrv e o XMing e uma versão paga que eu pessoalmente acho melhor que é o X410, que eu costumo usar, mas na prática tanto faz. Se eu não estou enganado todos devem suportar o modo de aceleração indireta, basta configurar dentro do WSL uma variável de ambiente dizendo isso, o libgl_always_indirect e adicionar num bashrc pra sempre ter a variável quando se logar.


```
export LIBGL_ALWAYS_INDIRECT=1
```





Pra rotear os comandos o WSL precisa do endereço IP do host Windows. No WSL 1 ficava tudo em localhost porque pra todos os efeitos e propósitos o WSL 1 rodava lado a lado do Windows e não virtualizado. No WSL 2 como ele é uma máquina virtual, do lado de dentro ele tem também uma rede virtual e o Windows do lado de fora é mapeado pra um endereço local dentro, é um tipo de ponte de rede que traduz o roteamento de pacotes do lado de dentro pro lado de fora. Se fosse localhost bastava fazer a variável Display ser igual a dois pontos e zero. Porém toda vez que a máquina reinicia pode ser que esse endereço virtual mude. Precisamos configurar uma variável de ambiente que aponte pra esse endereço e pra isso podemos fazer o seguinte one-liner, adicionar no bashrc e agora configurar a variável display pra usar o valor


```
export WSL_HOST=$(tail -1 /etc/resolv.conf | cut -d ‘ ‘ -f2)
export DISPLAY=$WSL_HOST:0
```



Colocando essas variáveis de ambiente no arquivo .bashrc, toda vez que o bash iniciar ele vai ter essas variáveis. E agora podemos instalar alguns programas gráficos que eles vão aparecer do lado de fora, no Windows mesmo. Vamos instalar o gvim que eu gosto, o terminal Tilix que é o mesmo que eu instalei no tutorial de Ubuntu e o pacote dbus-x11 que programas gnome precisam. 




Agora, precisamos instalar o tal cliente X, que como eu disse antes tem opções gratuitas mas eu pessoalmente gosto do X410 que eu já tinha comprado então vamos instalar pela Windows Store. Quando terminar e ele carregar, não esquecer de habilitar pra poder receber conexões da rede pública, se for a primeira vez o Windows Firewall vai apitar pra liberar acesso, libere e pronto. De volta ao bash, como só editamos o script bashrc precisamos ou deslogar e logar de novo ou só recarregar o bashrc com o comando source. Agora podemos abrir o gvim e olha só, abriu fora da máquina virtual, como um programa normal de Windows. Mesma coisa o Tilix e nele podemos configurar a aparência, escolhemos o tema Material … melhor o Monokai Dark … pronto, e agora podemos configurar o tamanho das fontes.





Mas pra mudar o tema geral, das bordas e tudo mais não vamos poder usar o gnome-tweaks. Como não estamos carregando todos os serviços que o gnome precisa pra rodar, se gastar algum tempo em tentativa e erro uma hora o gnome tweaks deve funcionar, mas por agora podemos simplesmente editar manualmente o arquivo de configurações em .config, gtk-3 settings.ini. Dentro dele habilitamos o modo dark, depois declaramos o nome do tema que é o Flat Remix GTK Blue Darker e finalmente o nome do pacote de ícones que é o Flat Remix Blue Dark.





Agora precisamos de fato baixar esses temas e ícones e aqui é a mesma coisa que já fizemos no episódio de Ubuntu, vou seguir exatamente o mesmo tutorial de antes. E como é a mesma coisa, vamos acelerar isso aqui. 





Pronto, agora podemos chamar o Tilix de novo boom, tá bem mais bonito não acham? O Gvim também ficou um pouco melhor mas ele ainda está mais cru porque não carreguei nenhum dotfiles que configura ele como o Yadr que mostrei no episódio de Ubuntu.





Até agora eu estava usando o programa Command que vem com todo Windows. A Microsoft veio modernizando o antigo Command pra aceitar comandos de VT100, ANSI e tudo mais e com isso ele hoje é capaz de renderizar corretamente, vocês podem ver que as cores ANSI funcionam perfeitamente. Ele ainda tem cheiro de coisa velha mas comparado a como era até as primeiras edições do Windows 10, foi uma evolução considerável. Mas terminais mais maduros como o Tilix que acabamos de instalar ou mesmo o terminal padrão de um MacOS ainda são melhores. 





Em vez de mexer demais no código velho do antigo Command, eles resolveram codificar um novo e com isso existe o programa simplesmente chamado de Terminal que você pode instalar via o Windows Store. Ele ainda está em desenvolvimento e por isso se chama Preview, mas mesmo no estágio atual ele já é muito melhor que o Command, inclusive ele é acelerado via DirectX então coisas como scrolls longos renderiza muito rápido. Vamos abrir e veja como ele é mais moderno com suporte a tabs. A configuração ainda é toda em texto, o que eu não acho ruim. Por exemplo, podemos mudar o tamanho das fontes de todos os perfis. Vale a pena brincar nesse arquivo um pouco pra customizar como você quiser.





Você pode usar esse novo Terminal pro WSL 2 até pra rodar o antigo CMD se precisar de scripts de batch antigos ou também rodar Powershell em outra aba. Ele é totalmente configurável e customizável, suporta abas e pode ser uma boa opção. Eu particularmente prefiro carregar o próprio Tilix e usar um terminal de verdade que suporta split de tela. Tem gente que prefere usar o TMux pra splits mas pro meu workflow um simples split do próprio terminal é suficiente. Se quiser ver o Tmux em funcionamento, veja meu vídeo de Ubuntu onde eu mostro como instalar e usar.






Mas só instalar o Ubuntu é muito fácil. Agora é uma boa hora de mostrar algo diferente. Hoje a Microsoft suporta o Ubuntu, o Fedora e o OpenSuse além de uma distro paga feita especialmente pro WSL 2 que é Pengwin, que se não me engano é uma derivação de Debian. Mas eles tem receitas no GitHub de como você pode empacotar qualquer outra distro de Linux. Desde o WSL 1 havia uma versão de Arch que você podia instalar e eu testei e vi que eles deram suporte pro WSL 2 também, então porque não testar? Mas, aviso que essa demo é meio experimental, ele não tem suporte da Microsoft e muitas coisas não funcionam perfeitamente ainda. Se você for experiente em Linux talvez consiga achar os workarounds, mas se for iniciante, por agora é melhor ficar no Ubuntu mesmo.






Vamos no Google, pesquise por ArchWSL e o primeiro link deve ser a página de GitHub do projeto. Lá tem todas as instruções que você precisa. Baixe o zip, descompacte em algum lugar como no seu diretório de usuário do Windows. Dentro vai ter um executável de Arch, dê duplo clique ou abra o novo Terminal, navegue até o diretório, digite arch e execute. Esse instalador faz menos coisas que o de Ubuntu, o que é esperado pra filosofia Arch de fazer você configurar tudo. Ele vai te logar como root direto. A primeira coisa a fazer é colocar uma senha pro root. Agora vamos criar um novo usuário não-root, configurar a senha, e abrir o visudo pra dar permissão de sudoer pra esse novo usuário. Dessa forma você vai poder logar como esse usuário em vez de root e ter acesso a sudo. … Feito isso podemos sair da sessão do Arch de volta ao Command do Windows e configurar o arch pra carregar com esse novo usuário.






Feito isso precisamos inicializar o pacman que é o gerenciador de pacotes, isso só precisa ser feito uma vez. Uma vez inicializado, mesma coisa de antes, eu gosto de atualizar os pacotes todos e fazemos isso com o comando pacman traço Syu. No Ubuntu começamos instalando pacotes como o build-essential pra ter o toolchain de desenvolvimento. Com o pacman instalamos pacotes como o base, base-devel e vamos aproveitar pra instalar também o gvim, tilix e git. 






Seguindo os mesmos passos, vamos exportar as mesmas variáveis de ambiente pra rotear o X….
Pronto, podemos carregar o Tilix. Porém aqui já vemos um problema dessa versão. Programas gnome precisam do dbus pra comunicação interprocessos, incluindo gerenciar configurações. Mas veja as mensagens de aviso dizendo que não encontra o dbus-launch. Um workaround pra isso é chamar o dbus-launch manualmente. De novo, eu não parei pra investigar a fundo quais dependências estão faltando ou serviços que não estão carregando. Se você souber como corrigir isso, não deixe de mandar nos comentários abaixo.






Aliás, uma coisa que notei é que tanto o Ubuntu como esse Arch de WSL não bootam com o systemd, ou qualquer outro init system então nenhum serviço carrega e comandos como systemctl pra iniciar ou parar serviços não vão funcionar. Você precisa carregar serviços manualmente se precisar. 





De qualquer forma, só pra mostrar como as coisas são muito parecidas, vou acelerar de novo pela parte que eu baixo os temas Flat Remix, editar o arquivo settings.ini manualmente e … pronto, tilix carregado com o novo tema, igualzinho antes.



E com isso temos um Arch instalado, você pode seguir qualquer tutorial normal de como configurar seu Arch como ambiente de desenvolvimento ou seguir as mesmas instruções que eu mostrei pro Ubuntu.



Agora, vamos voltar pro Ubuntu. Pra demonstrar que tudo funciona, vamos seguir meu tutorial e instalar o bom e velho ASDF como já mostrei antes. … 

Não esqueça de colocar os scripts de asdf no bashrc ou equivalente do seu shell pra iniciar sempre que se logar. … 

Feito isso podemos instalar o plugin de ruby …. 

Agora podemos listar as versões de Ruby disponíveis … 

Vamos escolher a mais recente, a 2.6.4 e instalar ….

Oops faltou instalar mais dependências de desenvolvimento do sistema, então vamos começar pelo pacote build-essential.

Ainda temos mais dependências, então vamos instalar …
Oops ele não acha o libgdbm3 então vamos tentar libgdbm
Oops ele não acha libgdbm também, ok deixa ele pra lá, não vamos precisar disso agora mesmo


Pronto, pacotes instalador, então vamos instalar o Ruby 2.6.4. Demora um pouco mas uma hora ele termina.


Não esquecer de configurar essa versão pra ser a padrão do sistema
Ruby instalado, vamos instalar a gem do Bundler


E finalmente, vamos instalar as gems do ruby on rails



Como o Rails hoje usa muito javascript também, inclusive ele integra com o yarn e com webpack, melhor instalar o plugin de nodejs do asdf. …

Pronto, mesma coisa, vamos listar as versões disponíveis e ...
escolher a mais recente, a 12.9.1

Oops faltou configurar as chaves gpg dos repositórios, 
então vamos na página de github do plugin


Basta copiar esta linha e executar pra instalar as chaves
Pronto, chaves configuradas, agora podemos tentar instalar a última versão de novo

Quando terminar, não esquecer de configurar essa versão como a global do sistema
Esse passo nem precisa na real, mas eu tenho costume forçar a atualização do npm pra garantir que estou com a versão mais nova. 


Vamos instalar o yarn também


Agora, vamos brincar um pouco e criar um novo projeto Rails do zero com seu gerador.

Oops falhou porque faltou instalar o sqlite3. Isso é opcional mas como eu não indiquei nada no gerador ele por padrão espera ter o sqlite3 então vamos instalar.


Como parou o gerador no meio, então vamos entrar no diretório do projeto e rodar manualmente o comando bundle install pra terminar de instalar as dependências.


Agora vamos carregar o rails server pra testar a página de Bem Vindo e oops, como o gerador tinha parado aquela hora ele não inicializou o webpack, então vamos fazer isso manualmente com a task webpacker dois pontos install.


Pronto, agora sim vamos carregar o rails server.


E com meu navegador Opera de Windows, podemos carregar o localhost porta 3000 e veja que funcionou! O WSL mapeou corretamente a porta 3000 de dentro da máquina virtual pra estar acessível do lado de fora no Windows.



Como última parte desse demo, vamos continuar o projeto gerando um controller de rails pra testar mais um pouco. Mas e agora, como vamos editar esses novos arquivos? A partir daqui eu abriria meu gVim devidamente configurado mas eu sei que muita gente migrou pra Visual Studio Code hoje, que eu também concordo que é um editor de textos e uma IDE excepcional. Altamente recomendado então vamos na página dele e baixar o instalador. E sim, vamos baixar o instalador de Windows e instalar do lado de fora no Windows.




Mas e agora? Como o VS Code de Windows vai editar os arquivos do meu projeto que está dentro do WSL? Aqui começa uma das vantagens do WSL ser desenvolvido pela Microsoft, o VS Code automaticamente detecta a existência do WSL, detecta que o Ubuntu é a distro padrão, instala os plugins adequados e agora podemos abrir uma nova janela do VS Code que vai estar conectado no WSL, olha a barra de status, no canto inferior esquerdo, e veja que ele está abrindo o WSL.




Com isso quando mandamos abrir uma pasta ele vai explorar o filesystem de dentro do WSL automaticamente apontando a partir do diretório do meu usuário e de lá podemos abrir o projeto Rails que acabamos de criar.



Então vamos procurar nosso arquivo de index html e editar alguma coisa.

Vamos também editar o arquivo de rotas pra colocar esse controller como raiz. 


Agora vamos reiniciar o servidor e recarregar a página no navegador e boom, olha só, funciona de boas. Apesar do WSL 2 ainda não ser tão completo quanto rodar uma máquina virtual de verdade, ele é leve e simples o suficiente pra ser tipo um runtime que roda em background, você pode usar o Terminal no Windows e o VS Code no Windows mesmo e desenvolver quase como se estivesse num Linux de verdade. Pra muitos casos de uso isso pode ser exatamente o que as pessoas precisam.



A última questão que todo mundo tem é, mas e o Docker? Funciona? Vamos no google de novo procurar um tutorial de docker pra ubuntu, os da digital ocean costumam ser bons então vamos nele.



Vamos seguir passo a passo como ele manda, primeiro instalar a chave gpg dos repositórios oficiais do docker. 

Adicionar os repositórios como fontes pro apt

Rodar o apt update pra atualizar

Garantir que vamos instalar dos repositórios do docker

Finalmente instalar o docker propriamente dito

E iniciar o serviço com o systemctl e oops

Como eu disse antes, o WSL não boota com o systemd então não existe suporte ao init system e o comando systemctl não vai funcionar.

Mas, podemos executar os daemons do Docker manualmente, e pronto, é meio chato ter que fazer isso toda vez que o WSL reiniciar, mas é melhor que nada.

Continuando o tutorial, vamos adicionar o grupo docker ao nosso usuário. Agora a gente ou desloga fechando o terminal ou só fazemos `su` pra abrir uma nova sessão direto.

Pronto, checando se tá tudo ok e agora podemos rodar o famoso hello world e ver que tudo funciona.

E pra garantir vamos um passo além e instalar o Postgres no Docker. E mesma coisa, primeiro vamos no Google procurar um tutorial qualquer.

Primeiro, puxamos a imagem do docker

Agora criamos diretórios pra guardar os bancos de dados

Finalmente podemos subir o Postgres dentro do Docker com esse comandão aqui, que vai configurar coisas como o mapeamento de portas.



Pra demonstrar que é o docker nativo de verdade rodando, se rodarmos o comando `ps aux` podemos ver todos os processos rodando dentro da máquina virtual e temos o postgres aparecendo como deveria. Se você assistiu meus episódios sobre virtualização e containers já entendeu que Docker não é virtualização. Na prática tudo que você roda via Docker roda normalmente como um processo no seu sistema, mas o Docker usa recursos da Kernel do Linux como cgroups pra fazer o sistema operacional mentir pro processo, fazendo esse processo acreditar que está rodando sozinho na máquina.





Como eu já tinha mostrado no episódio de Ubuntu, podemos navegar pro diretório /proc no subdiretório que é o pid do processo e oops, pid errado, vamos listar de novo e pegar o pid certo e navegar de novo

Pronto, agora podemos listar o conteúdo do meta arquivo cgroups e ver como ele está sendo mascarado pelo docker.





Pra todos os efeitos e propósitos, o processo do postgres acredita que está rodando sozinho na máquina, e pra gente do lado de “fora” é só mais um processo rodando como se tivesse sido instalado fora do Docker. Por isso containers de Docker são ordens de grandeza mais leves e performáticos do que uma máquina virtual, porque na prática não existe um hypervisor envolvido, é só uma casquinha muito leve do próprio kernel. O kernel precisa ter esse suporte e por isso não funcionava no WSL 1 porque é difícil recriar isso só com um wrapper em cima da kernel do NT e eles nem chegaram a tentar eu acho. Então o Docker de Windows, pra rodar containers de Linux precisava de fato executar um Linux no Hyper-V pra criar os containers dentro. Aqui é a mesma coisa já que o WSL 2 é uma máquina virtual rodando uma kernel de Linux de verdade, entenderam?





Agora podemos conectar nesse postgres dentro do container através da porta que o Docker mapeou pra fora. Vamos seguir o tutorial e oops ainda não temos o cliente de postgres instalado então vamos seguir o que ele manda instalar.


Oops, ainda falta mais um pacote, vamos seguir a instrução e instalar e agora sim, cliente instalado, vamos rodar o comando de novo. 


Pronto! Estamos conectados no postgres, rodando dentro do container do Docker.

Podemos rodar docker ps pra ver quais containers estão sendo executados e podemos pegar o pid do container e com ele rodar comandos como o docker stop pra parar o container e assim derrubar esse postgres.


Eu até acho que nesse ambiente de WSL 2, onde ele não sobe o systemd no boot e por isso não sobe daemons automaticamente






E é isso, o WSL 2 é basicamente um Hyper-V customizado pra rodar um kernel de Linux modificado pela Microsoft. E como a licença GPL obriga qualquer empresa a abrir o código fonte se for modificado, a Microsoft mantém o fork com as modificações no GitHub, e eu vou deixar o link nas descrições abaixo também. Eles vão sempre manter a versão estável mais nova e não devem ficar dando suporte pra kernels antigas, então você sempre vai ter a opção de rodar as distros mais novas. Se precisar rodar Linux velhos, você mesmo vai ter que instalar e configurar tudo manualmente numa máquina virtual Hyper-V do jeito antigo. O WSL 2 é um facilitador pro Hyper-V com um Linux melhor integrado.





Na prática, o WSL 1 era algo parecido com o Wine só que ao inverso. O WSL 2 é mais parecido em conceito com o coLinux, mas na prática é um Linux rodando dentro de uma máquina virtual. Então se você já usava Linux em Virtualbox ou VMWare na prática não tem grandes vantagens, especialmente porque o WSL não expõe tantas opções de configuração como um VMware.  Por outro lado a grande vantagem é o suporte oficial da Microsoft, ou seja, pela primeira vez é uma opção padrão. Veja a integração do Visual Studio Code com o WSL por exemplo. Uma vez que o WSL é um componente oficial no Windows, outras soluções podem começar a se integrar e criar um ecossistema




Eu gostava bastante do conceito do WSL 1, que seria o único caminho pra ter uma camada Linux integrada de verdade na fundação do Windows, o mais próximo que já se chegou do que se tem um macOS sem precisar reescrever todo o sistema operacional. Mas, eu entendo que era bem pouco prático dar suporte. Então o WSL 2 é um bom meio do caminho. Muita gente precisa estar no Windows seja pra usar programas corporativos que só existem em Windows, ou rodar pacotes como os da Adobe que não existem pra Linux ou mesmo fazer desenvolvimento em .NET pra Windows. Agora existe uma opção oficial pra rodar ferramental Linux lado a lado, com uma boa integração. Ele é mais limitado, ainda existem alguns bugs, mas com o tempo isso deve melhorar.



Na prática, se você já usa Virtualbox ou Vmware pra desenvolver em ambiente Linux, não existe de fato muita vantagem em usar o WSL 2. Mas se você quer integrar desenvolvimento de projetos em Node ou Python dentro do Linux junto com outros projetos no Windows usando o mesmo Visual Studio Code, por exemplo, é uma ótima opção. Aliás, apesar de existir um certo suporte nativo a rodar coisas como Node, PHP e Python no próprio Windows, eu altamente não recomendo, o certo é rodar dentro do Linux e ter acesso a tudo que esses ecossistemas oferecem. Toda versão de uma ferramenta Linux no Windows tem limitações, e rodando no WSL 2 ou numa máquina virtual elimina essas restrições. Evite ao máximo rodar ferramentas de Linux compiladas pra Windows, você sempre vai estar usando menos do que as ferramentas oferecem. Nesses casos o WSL 2 interessante pra desmotivar a existência dessas alternativas e simplesmente rodar o original num Linux de verdade, agora suportado pela própria Microsoft.





O único cenário onde eu ainda recomendaria Linux instalado nativo é se você está brincando de machine learning com ferramentas que precisam de acesso direto à GPU. Isso nem o WSL 2 e nem muitas máquinas virtuais vai conseguir te dar. Você precisa de acesso direto ao hardware. O WSL 2 hoje não tem como expor a GPU pra dentro da máquina virtual. Esse é um dos casos que é melhor uma configuração de dual boot se você também precisa de Windows, e se manter num Linux instalado nativamente na sua máquina.




No caso de desenvolvimento Web normal, onde você quer ter um postgres, redis, nginx, nodejs, rails, elixir, o WSL 2 é uma opção excelente e com a integração do Visual Studio, eu acho que se torna um pacote bastante atraente. Eu estou usando os dois, numa máquina tenho um WSL 2 e em outra tenho o VMWare. Como meu dia a dia não é mais ocupado por programação na maior parte do tempo, então pra mim o impacto é muito menor. Se você já testou essas opções, compartilhe sua experiência com o pessoal nos comentários abaixo. Se curtiu o video deixe um joinha, assine o canal e não deixe de clicar no sininho pra não perder os próximos episódios. Por hoje é só, a gente se vê, até mais!

