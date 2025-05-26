---
title: "[Akitando] #114 - O Melhor Setup Dev com Arch e WSL2"
date: '2022-02-15T12:52:00-03:00'
slug: akitando-114-o-melhor-setup-dev-com-arch-e-wsl2
tags: []
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/sjrW74Hx5Po" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## DESCRIPTION

Vale a pena usar WSL2? Por que Arch Linux?  

Se quiser conhecer a fascinante de como Linux veio parar dentro do Windows, assistam meu video original sobre WSL2 onde eu conto todos os detalhes da história do Windows que você nunca conheceu: https://www.youtube.com/watch?v=28jHuWBi72w

Porém, a parte sobre a configuraçâo do Linux no WSL2 estão defasadas e pra corrigir isso fiz o video de hoje.

O Guia Definitivo de Ubuntu é um dos videos que vocês mais gostaram e continua válido, assistam se ainda não viram. O de hoje vai complementar aquele video com um novo setup mais moderno pra quem usa Windows e tem máquina suficiente pra instalar Linux em cima com WSL2. E não qualquer Linux, mas o venerado Arch Linux. Vamos ver um setup para desenvolvedores web que é enxuto e poderoso!

E pra quem conhece WSL2 já, vá até o fim pra uma dica de como organizar seu arquivo de projetos entre diferentes máquinas virtuais ao mesmo tempo com performance máxima!


== Conteúdo

* 00:00:00 - intro
* 00:01:03 - motivação: cuidado com Insider
* 00:02:46 - recapitulando WSL2
* 00:03:13 - máquina recomendada
* 00:06:01 - instalando WSL2
* 00:07:16 - qual distribuição Linux?
* 00:10:26 - meu problema com APT
* 00:12:52 - instalando ArchWSL
* 00:17:08 - temas do Windows Terminal
* 00:18:59 - Vim antigo e Vim moderno
* 00:22:56 - instalando NeoVim e LunarVim
* 00:26:38 - apresentando LunarVim
* 00:30:48 - porque não oh-my-zsh? starship?
* 00:32:02 - instalando YAY
* 00:33:08 - instalando ZSH, Nerd Fonts e Powerlevel10k
* 00:38:28 - instalando plugins (zsh-autosuggestions)
* 00:40:05 - instalando alternativas em Rust
* 00:42:17 - instalando e mostrando ASDF de novo
* 00:46:47 - instalando e mostrando Docker
* 00:49:48 - apps gráficas de Linux funcionam bem?
* 00:53:02 - WSL, mounts P9 e HDs virtuais
* 00:56:43 - usando HDs externos do jeito certo
* 01:00:04 - criando HDs virtuais
* 01:01:32 - habilitando Hyper-V (parte avançada)
* 01:02:15 - montando e formatando HDs virtuais
* 01:03:49 - montando HDs virtuais automaticamente
* 01:08:37 - bônus: não esqueça das chaves ssh
* 01:09:16 - repetindo: o que você deve fazer?


== Links

* Windows Insider (https://insider.windows.com/en-us/about-windows-insider-program)
* WSL Config (https://github.com/MicrosoftDocs/WSL/blob/main/WSL/wsl-config.md)
* Win10 Smart Debloat (https://github.com/LeDragoX/Win10SmartDebloat)
* Get Windows Terminal (https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701)
* Windows Terminal Themes (https://windowsterminalthemes.dev/)
* Arch Wiki (https://wiki.archlinux.org/)
* ArchWSL (https://github.com/yuk7/ArchWSL)
* VSCodium (https://vscodium.com/)
* Chris@Machine (https://www.chrisatmachine.com/)
* LunarVim (https://www.lunarvim.org/#opinionated)
* Powerlevel10k (https://github.com/romkatv/powerlevel10k)
* zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
* oh-my-zsh (https://ohmyz.sh/)
* How to install Yay (https://www.tecmint.com/install-yay-aur-helper-in-arch-linux-and-manjaro/)
* ASDF (https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies)
* Nerd Fonts (https://github.com/ryanoasis/nerd-fonts)
* Rewritten in Rust: Modern Alternatives of Command-Line Tools (https://zaiste.net/posts/shell-commands-rust/)
* Docker Desktop (https://docs.docker.com/desktop/windows/wsl/)
* Mount a Linux disk in WSL 2 (https://docs.microsoft.com/en-us/windows/wsl/wsl2-mount-disk)
* How to create advanced tasks with the Task Scheduler (https://www.digitalcitizen.life/advanced-users-task-creation-task-scheduler/)
* How to Shrink a WSL2 Virtual Disk (https://stephenreescarter.net/how-to-shrink-a-wsl2-virtual-disk/)

## SCRIPT

Olá pessoal, Fabio Akita

Um dos videos que vocês mais gostaram foi o meu Guia Definitivo de Ubuntu. A palavra "definitivo" nunca é definitivo de verdade, especialmente no mundo Linux onde as coisas mudam rápido. Faz muito tempo que fiz aquele video então hoje vou dar uma atualizada. Se você é iniciante em Linux, assista o video de Ubuntu porque tem coisas básicas que ensino lá que não vou repetir mais aqui.





Quero aproveitar e falar rapidinho de WSL 2, o Windows Subsystem for Linux, que também já fiz video algum tempo atrás. Então o de hoje vai ser configurar um bom ambiente de desenvolvimento web de Linux, que independe se está no WSL ou num Linux nativo, mas vou focar um pouco mais em WSL. Se quiser pular pra configuração específica de Linux, vá direto pra este tempo aqui embaixo e se já usa WSL2 ainda assim eu ainda tenho uma dica avançada no final. Consulte os capítulos do video e os links que complementam o conteúdo na descrição abaixo.




(...)




A motivação desse video é que recentemente eu reinstalei meu notebook do zero. O que aconteceu foi o seguinte: antes do Windows 11 ser lançado obviamente eu fiquei coçando pra experimentar. A Microsoft tem um programa chamado Insider. Se você se registra nele, vai habilitar o Windows Update pra baixar versões não-oficiais do Windows, versões beta ou mais instáveis ainda, em desenvolvimento. Eu fortemente recomendo contra fazer isso numa máquina de trabalho porque a chance de dar ruim é muito alta.







E justamente deu ruim comigo. As últimas versões Insider Preview quebram alguma coisa no suporte a Docker que ele sequer consegue inicializar o serviço. Dá um erro de timeout e crasheia. E não tá errado porque o povo do Docker ainda não teve tempo de corrigir seja lá o que a Microsoft mudou no Windows na versão em desenvolvimento. Não é culpa de ninguém. Esse é o propósito do programa Insider. O desenvolvedor do Docker pode ver o que o povo dentro da Microsoft tá mexendo e ir atualizando o Docker antes da próxima atualização oficial do Windows ser lançado, que pode ser daqui algumas semanas, pode ser daqui alguns meses. Eu que tava adiantado demais. É o mesmo motivo de porque em Linux recomenda-se sempre usar uma distribuição LTS, que é Long Term Support. 









O problema é que a versão Insider Preview de desenvolvimento não tem como dar rollback pra versão estável anterior. Precisa fazer um clean install, instalar tudo do zero. Como o Windows 11 já foi oficialmente lançado, não tem porque eu ficar tendo dor de cabeça na versão Insider mais, então fiz o de sempre. Baixei o ISO da versão estável do Windows, queimei um pendrive, bootei e reinstalei tudo do zero. Agora estou com um Windows 11 limpo. Já que ia ter que instalar o WSL tudo de novo, aproveitei pra registrar tudo e mostrar pra vocês.






Vamos recapitular esse tal de WSL2. É uma camada de suporte pra facilitar e integrar uma máquina virtual Linux rodando sobre o hypervisor da própria Microsoft chamado Hyper-V. Máquinas virtuais e containers como Docker são coisas diferentes, por isso eu já tinha feito videos antes explicando a diferença entre os dois e recomendo que assista caso não saiba a diferença. Na prática é uma máquina virtual, só mais conveniente do que rodar dentro de um Virtual Box ou Virt Manager.







Por ser virtualização, significa que na mesma máquina estamos bootando um Windows e em cima dele bootando um Linux. Os recursos da sua máquina como disco, memória RAM, núcleos da CPU e GPU vão ser compartilhados entre os dois sistemas operacionais e por isso é mais pesado do que rodar só um dos dois sozinho. Não é recomendado rodar um WSL ou qualquer máquina virtual se tiver menos que 4 núcleos de CPU e menos de 8Gb de RAM. 







Vai rodar se tiver menos? Vai, mas vai ser mais lento porque se faltar CPU vai ficar bem lento, se faltar RAM vai fazer swap em disco e isso vai deixar bem lento. O ideal é pelo menos, pelo menos, 8 núcleos de CPU e pelo menos 16Gb de RAM. Isso dito, não fiquem mandando nos comentários "ah, e minha máquina com 4Gb?", faça a conta, 4 é menos que 8 que eu acabei de falar, vai ser lento. Se você não for fizer nada pesado, não tem problema, mas pra trabalhar vai ser super sofrido.








Se tiver máquina mais fraca, recomendo não usar WSL nem nenhum tipo de máquina virtual e sim instalar uma distribuição Linux mais leve como Puppy Linux ou Lubuntu. Não vai ser uma experiência bonita porque a intenção dessas distros é ser leve. Mas mesmo com uma distro que faça boot usando poucos recursos, se abrir um monte de abas no Chrome ou se começar a tentar subir muitos containers de Docker, super rápido vai faltar RAM e CPU e, de novo, vai ser uma experiência bem lenta. 







Então pro resto do video vou assumir que você tem uma máquina com pelo menos um Intel Core i5 de 9a geração pra cima ou um Ryzen 5 de 3a geração pra cima e pelo menos 16 Gb de RAM com pelo menos SSD como armazenamento. Aliás, se tem uma máquina fraca e não tem dinheiro pra atualizar tudo, no mínimo do mínimo tente trocar seu HD mecânico por um SSD, é o que mais vai fazer diferença na performance geral. Em segundo lugar é aumentar RAM.






Meu notebook de trabalho que uso pra viajar é um Asus ROG Zephyrus G14. Ele tem um Ryzen 9 5900 HS com 8 núcleos e 16 threads, mais 40Gb de memória DDR4 e um NVME de 4 terabytes, portanto tem recursos mais que sobrando pra rodar um WSL2. Como falei antes, tá com Windows 11 recém instalado. E a primeira coisa que recomendo toda vez que se acaba de instalar Windows é rodar algum script de debloating, ou seja, um script que desabilita inutilidades como a telemetria que fica mandando dados pros servidores da Microsoft sem você saber. Também desabilita Cortana que ninguém usa e coisas assim que ficam roubando recursos da sua máquina.







Um dos scripts mais conhecidos é do LeDragoX. Não vou mostrar como rodar aqui porque tá explicado na página do projeto no GitHub. Se não conseguir seguir essas instruções, também não vai conseguir entender quase nada do video então sugiro que gaste 1 minuto pra tentar abrir a interface gráfica da ferramenta dele. Precisa saber o que é PowerShell, coisa que explico no meu video original sobre WSL2. Assiste lá depois.






Uma vez que desabilitamos o grosso de coisas que um Windows sobe automaticamente, mesmo assim ainda vai consumir quase 5Gb logo depois do boot. Por isso falei que com menos de 8Gb, no Windows, as coisas vão ficar lentas. Vamos começar instalando o tal WSL e se estiver nas versões mais recentes de Windows pode só abrir uma janela de PowerShell com permissões de administrador e digitar `wsl --install`. Agora vai tomar um café até baixar tudo e instalar os pacotes que precisa.







Não esqueça de instalar o Windows Terminal da loja da Microsoft ou usando algum instalador como o Chocolatey. Se você não é de Linux talvez não entenda ainda a importância de um bom emulador de terminal. No Mac temos o iTerm2, em distros Linux temos o Alacritty que é o melhor ultimamente, mas o Windows Terminal devo dizer que tá muito bem feito e na mesma categoria dos que acabei de falar. Obviamente use o WSL nesse terminal. Depois disso precisamos reiniciar o Windows, como sempre.







A instalação padrão de WSL já vai instalar o Ubuntu mais novo automaticamente e quando reiniciar vai pedir pra criar um usuário Linux. Esse passo é opcional, mas como não custa nada, vamos criar. Colocamos uma senha forte e pronto, estamos dentro de um Ubuntu, dentro do Windows. Se é sua primeira vez instalando WSL, essa visão deve ser bizarra. 







Qualquer outro tutorial ia continuar configurando o Ubuntu, mas como sou eu, vou ignorar totalmente porque pessoalmente prefiro distros baseadas em ArchLinux. Sem me alongar demais, hoje em dia você tem 3 grandes famílias de distribuições Linux. Primeiro as baseadas em Debian, com pacotes formato DEB e o gerenciador APT como o Ubuntu, Elementary, Mint, Deepin, Pop OS. 






Em segundo tem as baseadas no antigo RedHat, como o Fedora, CentOS, SuSe, com pacotes formato RPM e o gerenciador DNF. O mundo mais enterprise comercial tende a suportar o ecossistema RedHat, então a gente vê marcas como Oracle rodando seus sistemas num CentOS.







O Ubuntu meio que dominou os derivados de Debian. Debian era considerado uma das distribuições mais estáveis, mas pra isso ela sempre vinha com programas em versões um pouco mais defasadas. Lembra o que eu falei sobre o programa Insider do Windows? O Debian é como se fosse o Windows 10 quando já temos o Windows 11. Ele prefere estar mais atrasado pra não comprometer estabilidade. 







Pra gerenciar isso o mundo Ubuntu tem o conceito de LTS. Por exemplo, no momento que estou gravando este episódio a versão mais nova do Ubuntu é a 21.10, mas a versão que eles recomendam como mais estável, e que vão dar suporte por alguns anos é a 20.04 que foi lançada 1 ano atrás. A esta altura a maioria dos principais software de Linux tem suporte ao Ubuntu 20.04 mas nem todos suportam a 21.10 ainda. 







Ainda existem diversas outras famílias de distribuições que não são nem baseadas em Debian e nem em RedHat, como Slackware ou Gentoo. Mas essas são pra usuários mais avançados. Não recomendo pra iniciantes que ainda não tem costume de fuçar muito documentação e fóruns. Pra mim o melhor meio do caminho entre facilidade e coisas novas é a família Arch Linux que incluem distribuições como Manjaro, Endeavor, Garuda e outras. 







Na dúvida eu sempre falo: escolha o Manjaro e seja feliz. O padrão no Manjaro é instalar com GNOME que é meio pesado, mas tem versão com KDE ou XFCE que são gerenciadores de janela mais leves e customizáveis. E você sempre pode instalar outras interfaces gráficas como o Cinnamon ou LXQT. Enfim, tem bastante coisa pra se divertir.







Uma das grandes vantagens do Arch é o gerenciador de pacotes Pacman e o AUR que é o Arch User Repository. Aqui vale uma explicação. Todo tutorial de Ubuntu por aí vai fazer você digitar um comando como `apt install` pra instalar algum pacote. Esse comando mantém um banco de dados com nomes e versões de pacotes que é atualizado sempre que se faz `apt update`. Ele faz isso se conectando nos diversos servidores oficiais da Canonical, que faz o Ubuntu, e atualiza os bancos de dados. Daí quando fazemos `apt install` vai em algum servidor e baixa o pacote do programa que quer instalar. Tudo costuma ser muito simples.








Mas isso implica que todo software do mundo precisaria estar registrado nesses servidores da Canonical, incluindo a versão mais nova e todas as antigas. É muita coisa pra uma empresa só conseguir catalogar e manter atualizado. Por isso é possível outras empresas terem repositórios próprios só com o arquivo de pacotes dos seus software em particular. Por exemplo, se quiser instalar o Docker, os pacotes não estão nos servidores da Canonical. Vamos abrir o tutorial de instalação oficial do Docker.








Tá vendo? Não é só um simples `apt install docker`, tem vários passos. Em resumo, primeiro precisa instalar alguns pacotes de infraestrutura do Ubuntu no passo 1. No passo 2 precisamos baixar a chave pública em formato GPG do Docker. Se não sabe o que é assinatura e chaves assimétricas, assista meus videos explicando o básico sobre criptografia. Mas em resumo, todo gerenciador de pacotes que se preza vai tentar garantir que você não instale malware de servidores falsos de hackers tentando se passar pelo Docker ou outra empresa.







Pra fazer isso eles assinam os pacotes e os dados transmitidos dos seus servidores usando chaves assimétricas. Eles assinam os pacotes com uma chave privada que ninguém nunca vai ter acesso. Daí instalamos essa chave GPG que é a chave pública. Tudo que a chave privada assina, só a chave pública consegue acessar e vice-versa. Um hacker não tem acesso à chave privada, então não vai conseguir assinar malwares.







No passo 3 precisamos indicar pra ferramenta APT onde está a listagem de pacotes nas mais diversas versões. Nessa lista tem coisas como versão mas também quais pacotes tem pra quais arquiteturas como x64 da Intel, ARM de Mac e assim por diante. Essa linha estranha é um comando pra adicionar um arquivo no diretório de sources do apt, que lista de onde que é pra baixar.






Finalmente no passo 4 fazemos primeiro um `apt update` pra baixar a listagem desse novo source e atualizar o banco de dados local e só agora podemos fazer o `apt install`. Quando fizer isso várias vezes, vai ficar meio automático, mas viu quantos passos precisamos fazer pra instalar um pacote que a Canonical não controla? 






Como é instalar o mesmo Docker num Arch? Pra começar, a documentação existe no próprio wiki do Arch. E temos dois pacotes, ou o `docker` ou o `docker-git` que provavelmente é uma versão mais nova e potencialmente mais instável. Mas por padrão podemos fazer só `pacman install docker`. Pronto, só isso. 






Pacman, assim como Apt ou DNF é um gerenciador e instalador de pacotes. E os repositórios do Arch costumam ter mais pacotes do que os equivalente de Ubuntu ou Fedora. E o que não tem, não precisamos fazer toda a burocracia de procurar um repositório de terceiros, instalar chaves e bla bla como fizemos no caso do Docker. A comunidade mantém um repositório de usuários que é o Arch User Repository ou AUR. A gente pode baixar um script de lá, que serve pra construir um pacote do zero e usamos pacman pra instalar. Mas tem um jeito ainda mais fácil que já vou mostrar.







Isso tudo dito, a Microsoft ainda não tem suporte oficial pra distros Arch no WSL, mas existe um projeto no GitHub chamado ArchWSL. Eu uso acho que desde 2018 e nunca tive problemas. É um Arch mínimo, mais leve que um Manjaro, mais leve que um Ubuntu. E a instalação é bem trivial. Pra isso vamos na página de GitHub do projeto baixar um zip que tem tudo que precisamos. Descompacte onde quiser mas eu costumo deixar na raíz do C: mesmo.







Agora abra um command prompt ou powershell no Windows Terminal, dê `cd` pro diretório onde descompactou o Arch e execute. Em dois segundos ele vai se registrar no WSL. Como o Windows Terminal já tava aberto ele ainda não detecta o novo Arch, mas basta reiniciar e voilá, já apareceu. O que eu gosto de fazer primeiro é configurar o Terminal pra sempre abrir o Arch primeiro.







Da primeira vez que entramos nele, estamos logados como usuário `root` que, como já expliquei no guia de Ubuntu, não se deve fazer. Lembra quando o Ubuntu oficial que o WSL instalou nos forçou a criar um usuário não-root? No caso do Arch vamos fazer isso manualmente. Uma das coisas que afasta muitos iniciantes do Arch é que ele nos obriga um pouco a saber o que estamos fazendo e não faz tanta coisa automaticamente. Por isso que é bom pra aprender.








No próprio GitHub do ArchWSL tem um link pra documentação. Vamos seguir e olha só. Daqui você não precisa de talento tampouco habilidade. Basta saber fazer copy e paste e saber ler. Vamos copiar esta primeira linha e colar no terminal com o Arch aberto. Isso vai configurar o arquivo sudoers pra permitir que comandos com `sudo` possam ser executados pra elevar privilégio a partir de qualquer usuário. O ideal não é abrir tudo pra `ALL` como fala aqui, mas como é máquina de desenvolvedor, não tem tanto problema. Depois estude sobre sudoers se não conhecia.







Em seguida são comandos básicos de `useradd` pra criar um novo usuário. Faça copy e paste mas obviamente digite um usuário com seu nome, né. Daí usamos o comando `passwd` passando o usuário que acabamos de criar pra configurar uma senha segura. Abrimos outra aba com um command prompt, e podemos fechar a que estava com o Arch aberto, porque precisamos configurar o WSL pra quando abrir o Arch de novo use o usuário que acabamos de criar em vez de `root. Então mais um copy e paste.









Pronto, se abrir o Arch no terminal de novo e dermos o comando `whoami` diz que é o novo usuário. A partir daqui, se precisarmos fazer alguma coisa que exija permissão de root é só começar o comando com `sudo`. E a primeira coisa que se deve fazer logo que se instala uma distro linux é atualizar todos os pacotes. No caso deste Arch, precisa fazer algumas coisas antes. De novo, a documentação já diz tudo. Só copiar e colar esses comandos de `pacman` que vai inicializar e popular as chaves que o Arch usa pra checar os pacotes.








O pacman é um pouco chatinho pra quem nunca viu porque não tem comandos fáceis como `install`, em vez disso o equivalente é `-S` maiúsculo que significa "sync". Daí adicionamos a opção `y` que se não me engano é pra atualizar o banco de dados com as listagens do servidor oficial do arch. E a opção `u` é pra atualizar os pacotes. E eu faço `yyuu` duplicado pra forçar mesmo se já estiver tudo atualizado. O normal é fazer só `-Syu` sem duplicar, mas quando alguma coisa dá problema ou agora, que é primeira vez, acabo fazendo assim.







E esqueci de fazer uma coisa, então vamos dar `control-C` pra cancelar e abrir o arquivo `/etc/pacman.conf` com o editor `nano`. Procurar a palavra `Verbose` e adicionar uma nova linha embaixo dizendo `ParallelDownloads = 5`. Por padrão o pacman baixa um arquivo de cada vez e isso é bem demorado. Se você tem uma boa internet banda larga, pode testar, mas por volta de 5 downloads simultâneos ou até mais, aguenta. Agora sim, vamos repetir o comando do pacman pra atualizar tudo, e agora vai ser mais rápido.








Ele vai checar tudo que precisa ser atualizado, mostrar a lista de pacotes que vai baixar e pedir pra ir confirmando. Olha só como mostra 5 pacotes sendo baixados simultaneamente. Bem mais rápido, mas aí temos esse problema aqui. Um erro de chaves que ele não reconheceu. E isso porque eu fui burro e a documentação do ArchWSL tá incompleta. Faltou fazer `pacman -S archlinux-keyring` que instala as chaves mais novas que precisa pra instalar os pacotes. Então vamos instalar e repetir o comando de atualizar tudo.







Agora sim, foi até o fim. E é isso. Temos um Arch Linux rodando no WSL 2. Fim do video! Brincadeira. Antes de continuar, vamos deixar nosso terminal um pouco menos feio. Tá tudo com fundo preto. Pra mudar isso podemos ir no site windows terminal themes .dev. Dêem uma fuçada. Eu pessoalmente gosto do "Moonlight II" ou variações de "Monokai". Clique em "Get Theme" e ele vai copiar pro clipboard.







No Windows Terminal faça "ctrl-virgula" ou na setinha na barra de título escolha "Settings". Lá embaixo tem a opção de abrir o arquivo de configurações que é em formato JSON. Abre no Notepad mesmo por enquanto e vai lá pro fim. Logo embaixo do último tema, garante que tem uma vírgula e cole o novo tema. Cuidado pra não quebrar o JSON. Não precisa reiniciar, só salvar o arquivo. Agora seleciono o "Arch" no menu e vamos pra "Appearance". Pronto, posso selecionar o "Moonlight II" e embaixo posso aumentar a fonte pra 16 só pra ficar mais fácil de ver aqui no video.







Falando em editor, o próximo passo é instalar um bom editor de textos. Na prática, basta instalar o Visual Studio Code que ele se integra plug and play com o WSL. Vamos ver? Vai na loja do Windows mesmo, procura por Visual Studio, seleciona e instala. Pra ter a integração com o terminal precisa fechar e abrir de novo. Pronto, basta ir pra algum diretório e digitar `code .` e olha só como abre o Visual Studio listando os arquivos de Linux. 







O VSCode funciona super bem e se você prefere uma versão mais light e com mais privacidade, procure pela alternativa chamada VSCodium, que é a mesma proposta do Chromium em relação ao Chrome. VSCode e Chrome tem a péssima mania de se comunicar com servidores da Microsoft ou do Google, respectivamente, e ficar comunicando coisas que não sabemos. O VSCodium e Chromium desligam essas comunicações desnecessárias. Se você é do tipo mais paranóico com privacidade, instale essas alternativas.







Mas de vez em quando ainda prefiro ficar só no terminal mesmo. E hoje em dia ainda não tem nada melhor do que Vim na minha humilde opinião. Esse nosso ArchWSL já vem com vim pré-instalado. O básico que você tem que saber é que ele tem um modo de edição e um modo de navegação. Dá pra ficar horas falando de vim e no video de Ubuntu já mostrei o básico. Se nunca tentou, recomendo que dê uma chance de verdade. Acho importante conhecer o básico de Vim pra mudar a perspectiva do que um editor de textos realmente deveria fazer.








O Vim foi criado numa época onde se usava terminais remotos em redes super lentas. Por isso não existia o conceito de IDEs como um Visual Studio. Seria pesado demais. Quando conversei com o Uncle Bob a gente falou disso, recomendo que assistam nossa live que está gravada no canal. Mas por isso o Vim padrão parece tão espartano, com comandos super curtos, pra minimizar ao máximo os comandos enviados ao servidor a partir do terminal remoto.








Aliás, é por isso que este programa que estamos usando, esta janela do Windows Terminal se chama terminal ou, mais corretamente, emulador de terminal. É um terminal remoto que se conecta com o servidor de terminal rodando por baixo dos panos, localmente. O "Linux" em si não roda "dentro" desse programa, por isso podemos fechar o Terminal mas o Linux em si continua rodando por baixo. E quando abrimos um novo Windows Terminal, ele conecta de novo no servidor por baixo. Pense no Linux como se fosse um servidor web e o terminal como se fosse um navegador web, é o mesmo conceito.








Enfim, o Vim na verdade é a evolução do editor original que se chamava só "Vi", do Bill Joy, que era da Sun Microsystems. Já o Vim é um fork do Brian Moolenar. Depois do Vim versão 8 surgiu um fork dele chamado de NeoVim que tem a proposta de modernizar o Vim, em particular modernizar o código-fonte, que tem coisa de décadas atrás que nem precisamos mais e funcionalidades que hoje são possíveis. Uma das coisas que adicionaram faz poucos meses foi suporte à linguagem Lua.








O Vim sempre teve plugins escritos numa linguagem própria chamada VimScript, que é uma linguagem bem feia e chata de trabalhar, meio como scripts em Bash. É super antiquado, super fácil de criar bugs acidentais. Por isso pouca gente tem paciência pra escrever plugins nessa linguagem. Já Lua é uma linguagem mais moderna e madura, muito mais difundida, especialmente pra quem programa games. Além de ser uma linguagem super leve e fácil de embutir em qualquer programa.








Tem um canal no YouTube que recomendo que assinem, do Chris at Machine. Ele veio acompanhando essa nova integração e criou um projeto no GitHub chamado LunarVim, que é uma coleção de plugins escritos em Vim e uma configuração super completa que transforma o NeoVim praticamente num Visual Studio Code, só que mais leve e mais produtivo. E "praticamente" porque uma das características mais importantes do VSCode são seus servidores de linguagens.








Explicando bem curto e porcamente, o VSCode foi inteligente em fazer um editor que por si só é leve e não tem suporte a nenhuma linguagem. É um editor neutro se não configurar nada. Mas quando instala um plugin pra linguagem Ruby, por baixo ele instala um SolarGraph como servidor. Daí o VSCode passa a ser um cliente desse servidor que vai analizar o código Ruby que estamos digitando e dar suporte a coisas como autocomplete, debug, e mais. E cada servidor de linguagens diferentes vai implementar o Language Server Protocol ou LSP que é a API que o VSCode entende.







Agora, se eu pegar outro editor e fazer ele entender o protocolo LSP, dá pra usar os mesmos servidores. Por isso consigo trocar o cliente VSCode e substituir por NeoVim. LSP é como se fosse HTML, o VSCode é como se fosse o navegador Chrome ou Edge e o NeoVim poderia ser como o Firefox, sacaram? E o tal LunarVim que o Chris fez já pré-instala todos os plugins necessários pra integrar com LSP. Então vamos instalar pra ver.







Primeiro, precisamos do NeoVim. E hoje a versão que tem no repositório oficial já serve. Meses atrás precisava compilar o NeoVim manualmente porque não estava disponível esse suporte na versão oficial, só na beta. Pra instalar no Arch é fácil, só fazer `sudo pacman -S neovim` e veja como lista pacotes de Lua. Sabemos que é a versão que precisamos.






Quando terminar de instalar, vamos pra página no GitHub do LunarVim e tem um script instalador pra facilitar nossa vida. Só copiar essa linha e colar no terminal. E de cara já começa reclamando que não temos Git instalado. Bora instalar `pacman -S git` como ele manda.






Esse script vai ajudar a instalar as dependências que precisamos. A primeira coisa são pacotes de javascript, daí reclama que não tem nodejs instalado então vamos fazer `sudo pacman -S yarn npm` pra instalar... Agora com a seta pra cima repetimos o instalador do LunarVim e damos yes e pronto, tá usando o `yarn` pra instalar o que precisa.







No próximo passo pede pra instalar dependências de Python e como já temos `pip` instalado, prossegue instalando o que precisa... Essa foi fácil, e no passo seguinte ele quer instalar dependências de Rust, mas não temos Rust então o instalador pára de novo. Vamos fazer `sudo pacman -S rust` pra poder usar o `cargo` pra instalar as ferramentas de Rust. 







Assim como `yarn` é instalador de dependências de Javascript, `pip` é instalador de dependências de Python, o `cargo` é instalador de dependências de Rust. O Rust é uma linguagem compilada que gera binários nativos super otimizados e com segurança superior à de C puro. E no meio da instalação ele deu um erro. Parece que não conseguiu compilar o jemalloc-sys ou pam.








Eu já tinha ido no Google antes e o que aconteceu é que o Rust se integra com binários compilados em C também e nesse ponto ele precisou compilar alguma coisa de C só que não instalamos o ferramental pra isso ainda. Num Ubuntu isso seria o pacote `build-essential`, mas não existe no Arch. O equivalente é `sudo pacman -S base-devel`. Só ir dando `yes` no que tá perguntando, mas sempre leia antes, lógico.







Pronto. Seta pra cima, vamos repetir os mesmos passos tudo de novo. Ele sempre passa pelos passos de javascript e python mas agora é mais rápido porque já instalou esses passos. O Rust volta a compilar o que falta e agora .... vai até o fim. Mas atenção que fala que precisa colocar o diretório `$HOME/.cargo/bin` no PATH senão não vai achar as ferramentas que acabou de compilar. E no final o instalador também avisa que não vamos usar o comando `nvim` que inicia o NeoVim normalmente mas sim o `lvim` e pra isso precisamos adicionar o `$HOME/.local/bin` no PATH. Eu explico o que é PATH no episódio do guia de Ubuntu. 







Só pra agora podermos ver o LunarVim, vamos exportar o PATH manualmente adicionando esses dois diretórios... Pronto. Agora podemos abrir `lvim` e olha só que diferença. No LunarVim apertamos "espaço" pra abrir esse menu e com a opção "e" de "explorer" temos um painel com o projeto organizado como árvore, todo configurado com ícones e bem bonito. Podemos navegar pra cima e pra baixo com as teclas "j" e "k" e com a tecla "o" podemos abrir o arquivo embaixo do cursor.







Vamos abrir o arquivo "config.lua" pra adicionar uma configuração pra corrigir um pequeno bugzinho que essa versão ainda tem com esse negócio de abrir menu com "espaço". Ele é rápido demais e pode dar conflito com outras combinações de teclas então colocamos `vim.opt.timeoutlen = 500` milissegundos como gambiarra pra contornar e pronto. 







O video de hoje não é sobre Vim então não quero me alongar demais nele, mas acho que vale a pena fazer uma pequena tangente pra mostrar um pouquinho de porque instalei o LunarVim. Então vou me adiantar um pouco e abrir um projetinho besta em Rails antigo meu só pra dar exemplo. Primeira coisa é que posso fazer ele ficar parecido com uma IDE apertando espaço, que abre esse menu principal, e com "e" eu abro o explorer do lado, que é o plugin NvimTree. A partir dele posso usar o mouse normalmente pra abrir arquivos.







Por acaso abri um arquivo de Ruby. Lá embaixo dá pra ver a mensagem de "LSP inactive", ou seja, não tem nenhum servidor de linguagem analisando este arquivo. Mas se esperar alguns segundos, olha só, assim como o VSCode, o LunarVim achou um LSP de Ruby, no caso o Solargraph, e instalou sozinho e a partir daqui todo arquivo de Ruby que eu abrir ele vai analizar.







Pra abrir mais arquivos, posso voltar pro painel do explorer com o mouse, ou como eu prefiro, com o teclado fazendo ctrl+h pra ir pro painel da esquerda ou ctrl+l pro painel da direita, e os mesmos comandos de navegação como "j" pra ir uma linha pra baixo ou "k" pra uma linha pra cima funcionam igual. E com "o" posso abrir o arquivo embaixo do cursor. 







Mas esse explorer usa muito espaço, então posso fechar ele. Em vez de usar o explorer posso abrir o menu principal com "espaço" e apertar "f", que vai abrir o plugin Telescope que usa a ferramenta "fd" que é uma das que ele instalou de Rust no começo, lembram? E posso fazer um fuzzy find direto do nome de algum arquivo, como "archives" e abro o controller. 





Notem que o editor parece meio poluído à primeira vista, mas isso é o solargraph que analizou o código e fica dando dicas e avisos de coisas que podem melhorar ou bugs óbvios que precisam ser corrigidos. Toda linguagem moderna hoje tem um LSP que faz essas coisas. Por exemplo, nesse trecho ele fala pra evitar usar chaves num bloco de múltiplas linhas, em Ruby é mais bonito usar "do-end" em vez disso, e pronto, o aviso sumiu.






Outro exemplo é a sintaxe de atoms em hash que mudou desde a versão 1.9 do Ruby, antes era usando um fat arrow, hoje é usando dois pontos que nem um JSON. E mesma coisa, substituir chaves por "do-end". E aqui embaixo ele fala pra não fazer comparação com zero e sim usar o método "empty?" pra checar se a variável está vazia ou é zero.






Além disso, ele nos ajuda quando temos dúvida numa função. Aqui eu digito ponto e ele já me dá uma lista de métodos que a String aceita. E se eu sair navegando, ele até me dá a documentação da função caso eu não me lembre ou tenha dúvidas. E se for digitando, ele vai filtrando na lista até eu achar o método que eu estava precisando. Tudo coisa básica que se você já usou uma IDE moderna já tinha, mas agora disponível dentro do terminal no vim.






E só como último exemplo de coisas avançadas, alguns LSPs tem recursos de refactoring. Vamos procurar o arquivo do model chamado Post. E se eu quisesse renomear essa classe de Post pra Article e não ter que ir abrindo arquivo a arquivo de todo lugar que a classe Post é usado? Posso abrir o menu principal com espaço, apertar "l" pra abrir o sub-menu do LSP e olha que ele tem "rename". Lá embaixo eu mudo de Post pra Article e deixo o LSP trabalhar.






Notem que lá em cima apareceu um monte de aba de arquivos que ele abriu. Ele ainda não salvou nada. Só abriu todo arquivo onde aparece a classe Post e substituiu por Article. Abrindo aquele mesmo arquivo do ArchivesController, olha como onde tava Post agora tem Article no lugar direitinho. Mesma coisa no PostsController e assim por diante. Eu devo ir checando e salvando um a um pra garantir que fez tudo certo e, lógico, no final eu teria testes automatizados pra garantir que nada quebrou. Mas é uma das coisas que uma IDE como o LunarVim consegue fazer. E isso foram só 2 minutos de demonstração, tem bem mais coisas por baixo pra facilitar nossa vida.










Se você se animar a dar uma chance pro jeito Vim de navegar, em breve vai conseguir programar sem precisar ficar tirando a mão pro mouse toda hora. É muito mais confortável e até mais ergonômico de trabalhar. Além disso ele renderiza tudo em modo texto dentro do Terminal, o que usa muito menos recursos do seu sistema do que o VSCode que, por baixo, é tão pesado quanto um navegador web, como programas feitos em Electron. O VSCode, recém instalado, logo que abre já consome de 250 a 300 mega de RAM. O LunarVim fica na faixa de menos de 150 mega. É quase metade de recursos. Mas claro, hoje em dia depende mais dos LSP que rodam por trás analisando seu código.









Voltando pra nossa instalação, precisamos configurar o PATH de forma permanente e pra isso é só adicionar o mesmo comando de export que fizemos no arquivo `.bashrc`. Mas eu pessoalmente prefiro o shell ZSH. Eu sei, tem alguns que vão comentar sobre o Fish, mas eu ainda gosto do ZSH mesmo. Pra quem não sabe, além de Bash existem outras linhas de comando ou shells e suporte a scripts diferentes. O Bash é meio antiquado pra hoje, mas não tem nenhum problema de ficar nele.









No video do guia de Ubuntu eu baixei um conjunto de dotfiles de um usuário chamado skwp pra customizar meu prompt, vim e tudo mais, mas ele é muito pouco suportado e hoje em dia existem opções muito melhores. Essa é a parte do video antigo que ficou desfasado. Mesmo na época já existia o Oh-my-zsh que eu testei por um tempo, mas nenhum dos plugins foi muito importante pra mim e acho um pouco pesado. Muita gente gosta de usar só o starship, que faz um prompt até que minimalista e bonitinho de ver.








Meu preferido e o que achei mais fácil de instalar e configurar é o Powerlevel10k. Antes precisamos instalar uma outra ferramenta de Arch Linux pra facilitar nossa vida. Lembra dos pacotes que a comunidade mantém no AUR que mencionei? Pra instalar direto de lá não dá pra usar Pacman. Tem vários gerenciadores de AUR mas o que mais gosto é o Yay. E muitos tutoriais mais novos já assumem que você tem yay. Dá pra saber que um artigo aleatório é mais antigo se em vez de yay ele manda usar yaourt, que é desafado. Então vamos lá.







Na página de GitHub do Yay vamos descer pras instruções. A primeira coisa é instalar os pacotes de git e base-devel, mas acabamos de instalar então pula. Próxima linha é fazer `git clone` do projeto. Eu prefiro dar `cd` pro diretório temporário do sistema porque não vamos usar esse clone pra mais nada depois de instalar. Feito o clone damos `cd` pra ele e "make package" com opção pra instalar logo depois de construir o pacote. Lembram o que eu expliquei? O AUR não tem os binários nos servidores, só a receita de como montar o pacote de determinado programa. Uma ferramenta com o Yay vai automatizar o que acabamos de fazer manualmente, que é dar clone do projeto, montar o pacote e instalar com pacman localmente.








Pronto, com o Yay instalado praticamente não precisamos usar mais o pacman porque ele serve pra instalar tanto pacotes oficiais dos repositórios do Arch quanto do AUR, usando a mesma sintaxe do pacman. De exemplo, vamos instalar o shell ZSH, que vamos usar no lugar no Bash. Basta fazer `yay -S zsh`, nem precisa de `sudo`, ele se vira.








Agora vamos pra página de GitHub do PowerLevel10K. Mesma coisa, pulamos pra seção de Instalação e veja como tem instruções pra várias distros. Queremos do Arch. Simples, duas linhas e ele já assume que temos o `yay` instalado, então copiamos a primeira linha e colamos no terminal... pronto. No final ele recomenda instalar algumas fontes. Acho que não faz diferença dentro do terminal, mas pode instalar como fiz aqui. Vai fazer diferença se usar aplicativos gráficos de Linux iniciados de dentro do WSL, como o VSCode de Linux. Mas falo disso depois.








Seguindo as instruções é só executar essa linha de comando que vai inserir a inicialização do powerlevel10k no script `.zshrc` que é o equivalente `.bashrc` só que pra zsh, obviamente. Podemos fechar essa aba, abrir outra e ... nada acontece. Isso porque por padrão sempre inicia o Bash, precisamos usar o comando de Linux de "change shell" que é `chsh -s /usr/bin/zsh` pra da próxima vez executar direto o zsh em vez do bash... 







Pronto, agora fechamos a aba, reabrimos e como é a primeira vez, o powerlevel10k abre esse wizard de configuração. E a primeira coisa que ele pede pra gente confirmar é se estamos vendo um ícone com formato de diamante. Mas em vez disso estamos vendo um quadradinho, que nem quando vemos fontes quebradas numa página.







Isso porque ele espera encontrar uma família de fontes que tenham gráficos além de só letras. Chamamos essas famílias de Nerd Fonts. Se você é web designer ou desenvolvedor front-end sabe disso. Acho que foi o GitHub que inventou isso de embutir gráficos como fonte. Isso porque sites como o próprio GitHub usam dezenas de pequenos ícones em todo lugar. Em vez de fazer dúzias de PNGs que além de ser um saco de gerenciar também prejudica a performance do download de assets da página, eles tiveram a idéia de embutir todos os ícones em uma família de fonte, que a gente baixa tudo de uma vez só, como a Font Awesome e fica muito mais fácil de usar em qualquer lugar, não só em sites, porque os emuladores de terminais modernos são capazes de renderizar essas fontes também.









Além disso foi a época que Emojis começaram a popularizar, que nada mais são que um padrão onde imagens são associadas com códigos Unicode dentro da família de fontes. Então o mesmo código sempre vai devolver o mesmo emoji independente da família de fontes que estamos usando. Mas a fonte que o Windows Terminal usa por padrão que é a Microsoft Consolas, não tem nenhum desses ícones, por isso devolve um quadradinho pra indicar que não encontrou. Existem várias fontes que você pode pesquisar depois que tem esses ícones com o Fira Code mas eu pessoalmente gosto do Meslo LGS.








Na própria página de instruções do Powerlevel10k tem links pra baixar os arquivos de fonte, então vamos lá baixar uma a uma... Pronto, agora vamos no explorer no diretório de downloads, selecionamos todos os arquivos que acabamos de baixar, e escolhemos pra instalar as fontes no sistema... E pronto, agora podemos ir no Windows Terminal, abrir de novo a aba de configurações, escolhemos o Arch, escolhemos a aba de aparência e finalmente podemos trocar o Consolas pelo Meslo LGS.








Agora sim, abrimos uma nova aba. Vai carregar o ZSH que, por sua vez, vai carregar o Powerlevel10k. Como não prosseguimos a configuração da última vez, vai pedir pra começar de novo e desta vez veja como aparece o ícone de diamante. Nos próximos passos ele pede pra confirmar que estamos vendo os outros ícones e daí podemos continuar o passo a passo. E aqui vai do gosto de cada um. Vou passar rapidinho o que eu costumo escolher, mas recomendo que vocês experimentem opções diferentes. No final vai gravar tudo que escolheu no arquivo de configuração `.p10k.zsh`. 








Se não gostou do que escolheu basta digitar `p10k configure` na linha de comando pra chamar esse passo a passo tudo de novo ou editar manualmente o arquivo `.p10k.zsh`. Mas no final, olha só como ficou o meu prompt. Com ícones aqui na esquerda, mostrando o diretório onde estou. Se eu estiver num projeto de Git vai mostrar a branch também. Lá na direita mostrando a hora, mas quando entrar num projeto de código ele mostra outros ícones indicando a linguagem do projeto, a versão dessa linguagem e coisas assim.








Agora não podemos esquecer de configurar o PATH no arquivo `.zshrc`, assim podemos ter acesso ao LunarVim e qualquer nova ferramenta instalada pelo Cargo do Rust. Pode abrir com qualquer editor como o VSCode mas neste video sempre vou usar o NeoVim. Só adicionar o export no final do arquivo e não esquecer que a variável `$HOME` é um atalho pro diretório padrão do seu usuário e no final anexar o que já tinha no $PATH antes... Pronto, veja que neste instante se chamarmos `lvim` não vai achar. Mas agora abrimos outro terminal e boom, abriu o LunarVim como deveria.









O powerlevel10k é bem flexível pra customizar o visual como quiser, e eu gosto do passo a passo do que ter que ficar ajustando arquivo de configuração manualmente. Só tem que fazer isso uma vez e esquecer. Mas como eu disse dá pra customizar o zsh pra ficar bem mais complexo com um oh-my-zsh e colocar vários plugins. Depende de que tipo de trabalhos mais faz no terminal, então não deixe de fuçar que plugins existem. Mas tem um que eu acho útil e por isso vou instalar manualmente agora. Quem usa a shell Fish já tem isso automaticamente.








Vamos instalar que eu mostro pra que serve. No diretório do seu usuário, que você sempre volta fazendo `cd` sozinho, vamos criar um diretório chamado `.zsh` pra instalar o plugin. Agora vamos na página de GitHub dele. Tem link pra outra página com instruções de instalação. Olha como tem instrução pro Oh-my-zsh, mas queremos a forma manual. O primeiro passo é clonar o projeto pro diretório que criamos, então é só copiar essa linha de `git clone` e colar no terminal.







Queremos que toda vez que o zsh carregue, também carregue o plugin então temos que editar o arquivo `.zshrc` de novo. Copiamos a segunda linha das instruções e podemos colar no script. Salvamos e pronto. Mas pra carregar agora mesmo, é só executar a linha que copiamos que ele carrega o script do plugin. Pra que serve isso? Vamos fazer um comando idiota de `echo`. E se eu quiser repetir o mesmo comando? 








Posso copiar o que acabei de digitar e colar ou, começo a digitar `e` e ele consulta no histórico e vai tentando auto completar. Olha como já apareceu aqui. Agora é só dar `tab` ou seta pra direita e vai completar tudo. Isso é super útil porque o tempo todo estamos repetindo os mesmos comandos e eles ficam no histórico da sessão. Isso é um bom exemplo de plugin útil.








Como o LunarVim já pediu pra instalar algumas ferramentas feitas em Rust e já colocamos no PATH onde o Cargo instala os binários, podemos aproveitar e instalar mais algumas ferramentas modernas. Se procurar no Google vai achar vários artigos a respeito mas vou usar este entitulado Rewritten in Rust junto com os outros links na descrição do video. Depois leiam com calma, ele lista diversas novas ferramentas feitas em Rust.








Por exemplo, logo de cara tem os que eu mais gosto, por exemplo o `bat`, que é um substituto do `cat` que usamos pra listar o conteúdo de arquivos texto. Ou o `exa` que é substituto pro `ls` que usamos toda hora pra listar arquivos de diretórios. Em seguida ele fala do `fd` que é uma alternativa mais performática pro `find` e que o LunarVim já instalou porque o plugin Telescope usa. Além do `fd` o LunarVim também instalou o `rg` ou RipGrep que é um grep mais performático. 








Podemos instalar usando o pacman ou o yay mas vamos instalar usando o Cargo mesmo. Basta fazer `cargo install` e passar todas as ferramentas que queremos. Olha só o cargo baixando, compilando e instalando... e no final deu alguns problemas. Ele não conseguiu instalar o ytop, dust e delta. Pode ter algum bug nos repositórios mas não me incomodei pra procurar porque não são essenciais. Os principais que eu queria eram o bat e exa.







Vamos testar. Primeiro, olha como é a saída do `ls` normal de Linux. Uma listagem normal de arquivos e diretórios, nada demais. Agora vamos usar o `exa` com as mesmas opções de `-la`. Ele não aceita todas as opções iguais do `ls` só as mais comuns e veja só como ficou BEM mais bonito. E pra cereja no bolo tem a opção `--icons`, e olha só como ficou ainda MAIS bonito. Depois que a gente vê assim, não dá vontade de usar o `ls` padrão mais. Eu não testei, mas tudo tem trade-off, não sei se um diretório com milhares de arquivos vai ficar mais lento de listar. E também se quiser capturar a listagem num arquivo texto pra trabalhar depois, daí é melhor não usar o exa.








Mesma coisa com o cat. Vamos listar o conteúdo do script `.zshrc`. E como sempre, listado, nada demais. Mas e com o `bat`? Olha só como ficou BEM mais bonito. Mas mesma coisa: se precisar trabalhar com o conteúdo do arquivo num script é melhor usar o cat normal. O bat é só pra visualizar mais bonito. 







Mas como eu uso `ls` e `cat` só pra visualizar no terminal mesmo, prefiro até substituir eles com aliases, e pra isso vamos abrir o `.zshrc`. Só quero adicionar `alias` pra dizer que quando eu digitar `ls` no terminal o zsh vai na verdade chamar o `exa` e mesma coisa pro `cat` sempre chamar o `bat`. Isso é opcional, mas só pra saber que dá pra fazer isso.








Agora que nosso terminal tá bonitão, hora de instalar o ASDF. Não vou me alongar nessa parte porque já expliquei em detalhes sobre isso no guia de ubuntu e vai ser exatamente a mesma coisa agora. Pra quem não lembra, no dia a dia de programador a gente nunca usa uma única versão de alguma linguagem ou framework em todos os projetos. Podemos estar programando um projeto em Node.js versão 16, mas aí alguém me reporta um bug num projeto mais antigo que tava no Node.js 14. Eu preciso ter os dois instalados na minha máquina.








Pra isso existem ferramentas como o NVM pra poder ficar trocando de versão de Node. Mas e se eu precisar mexer também num projeto de Python? Daí vou precisar instalar e configurar o VirtualEnv. Mas amanhã talvez eu tenha que ajudar no front-end de um projetinho em Rails, aí preciso instalar também o RVM ou Rbenv. E assim vai. Cada linguagem tem um gerenciador de versões diferente. Em vez de ter que lidar com essa zona toda, posso instalar o asdf, que tem plugins pra dezenas de linguagens e nunca mais usar outro.








No Arch é fácil, basta fazer `yay -S asdf-vm`... Ele vai instalar no diretório `/opt/asdf-vm` e pra ativar precisamos fazer `source /opt/asdf-vm/asdf.sh`. Pronto, tá ativado e precisamos colocar essa linha no `.zshrc` pra toda ver que abrirmos o terminal ter o asdf carregado. A partir daqui é como já mostrei no video de ubuntu. Com `asdf list` podemos ver todas as linguagens e versões instaladas. Como ainda não instalamos nenhuma, tá vazio. Então vamos instalar o plugin de node com `asdf plugin add nodejs`.







Pronto, agora podemos fazer `asdf list-all nodejs` e ver que a versão mais recente hoje é a 17.4.0 então vamos fazer `asdf install nodejs 17.4.0` e boom, instalado. Só pra fazer graça, podemos instalar uma versão mais antiga também, por exemplo com `asdf install nodejs 16.13.2`. E depois que instalar rodamos `asdf list` e ele mostra que temos as duas instaladas direitinho.







Pra escolher uma delas configuramos uma como versão global mas o certo é configurar por projeto. Pra dar exemplo, vamos pro diretório tmp criar um diretório falso de projeto chamado de `teste`. Dentro podemos fazer `asdf local nodejs 16.13.2`. Vamos listar o que tem no diretório e achamos o `.tool-versions` que acabou de ser criado. Dando um `cat` vemos que está declarada a versão que pedimos. Toda vez que entrarmos nesse diretório o asdf vai usar essa versão específica de Node.js independente do que for a versão global. E fazendo isso em todos os projetos, sempre vai mudar pra correta que cada projeto precisa. 








Pra complementar, vamos adicionar Ruby agora. Só adicionar o plugin com `asdf plugin add ruby`. Mesma coisa de antes, vamos listar todas as versões disponíveis de Ruby e é uma lista gigante porque no meio tem versões não oficiais como o truffleruby, rubinius, jruby mas lá em cima vemos que tem a versão de desenvolvimento do 3.2.0 que ainda não é estável então vamos fazer `asdf install ruby 3.1.0`. Ruby costuma demorar um pouco mais pra instalar, acho que baixa o código fonte e compila. Boa hora pra ir pegar um café.








Agora que tá instalado, se der `asdf list` mostra o Ruby também. E assim você pode ir instalando plugins de diversas outras linguagens como Rust, Kotlin, Python, Clojure e tudo mais e instalar versões específicas de cada uma. E como disse antes posso dizer que quero que essa versão 3.1 seja o global com `asdf global ruby 3.1.0`. Agora todas as ferramentas de ruby que usarmos, a partir de qualquer diretório, vai estar apontando pra essa versão. 







Por exemplo, vamos usar o comando `gem` que vem com todo Ruby e instalar o framework Ruby on Rails fazendo `gem install rails`. No final ele vai instalar o comando `rails`, então vamos de novo pro diretório temporário do sistema e executar `rails new teste_rails` pra criar um novo projeto. Vai demorar um pouquinho pra instalar todas as dependências, mas no final podemos dar `cd` pro novo diretório. Olha só, tudo funcionando e se quisermos perguntar a versão do ruby ativo, ainda é o 3.1.0.







Como eu não declarei o arquivo `.tool-versions` se amanhã eu atualizar o ruby global pra 3.2, esse projeto vai pegar 3.2. Se eu quiser travar pra versão específica o certo é rodar o `asdf local` pra criar o arquivo `.tool-versions`. Estou me alongando nisso porque é comum você atualizar o sistema, vem versão nova da sua linguagem, e de repente seu projeto começa a dar problema porque você não se tocou que tá rodando uma versão diferente. Por isso é boa prática ter declarada a versão correta em todo projeto mesmo se não usar asdf.








Bom, agora que temos o ASDF e acesso a instalar linguagens, o último grande passo é instalar Docker. Antigamente eu preferia instalar banco de dados como postgres ou redis nativamente no sistema operacional, mas era mais por hábito mesmo. O ideal é não instalar esse tipo de serviço localmente, mesmo porque o WSL não tem um systemd pra controlar boot de serviços. Melhor usar Docker e configurar Docker Compose em todo projeto pra subir versões específicas de tudo que precisa.








Assim como várias coisas podem quebrar quando você pula de Node 16 pra Node 17, um banco como Postgres tem funcionalidades diferentes por versão. A versão mais nova do Postgres no momento que estou fazendo este video é a 14, mas ainda tem muito projeto rodando na versão 9. Você não pode desenvolver na versão mais nova porque pode acabar dependendo de funcionalidades que não existem na 9, daí quando subir em produção, vai dar pau. Repetindo, declare a versão correta de cada coisa no manifesto de um Docker Compose.








Se fosse um Arch Linux nativo fora do WSL, a instalação não seria muito mais do que um `yay -S docker`, mas no caso do WSL tem um passo extra que é baixar e instalar o Docker Desktop antes. Então vamos no site oficial, baixar o instalador e instalar... Não precisa mudar nada na instalação, vai só prosseguindo ... ele vai baixar os componentes, vai configurar o WSL pra ter os grupos e permissões direitinho e no final vai pedir pra deslogar e logar de novo. Então vamos fazer isso.







Toda vez que se logar no Windows, o Docker Desktop vai ficar carregado aqui embaixo na barra da tarefas. Certifique-se que ele tá carregado antes de usar. Mas da primeira vez vai abrir essa janela aqui pra aceitar os termos de serviço e só depois inicia. Não tem nenhuma configuração muito importante que precisa mudar, do jeito que veio já tá bom, com exceção de uma coisa que vou mostrar já já.







Agora podemos abrir o terminal e fazer o `yay -S docker` pra mandar comandos pro servidor que acabamos de instalar. Mas se tentarmos rodar `docker ps` vai dizer que não conseguiu se conectar. Vamos abrir o Docker Desktop de novo e ir nas configurações. Aqui no item de Resources e WSL Integration tá marcado pra dar suporte pra minha distro default de WSL que vai ser aquele Ubuntu que instalou automaticamente primeiro. Então precisamos habilitar aqui embaixo pro Arch. Pronto.







Se tentar rodar o mesmo comando, vai dar outro erro mas agora é de permissão. Isso porque quando mudamos aquela configuração, por baixo dos panos ele criou o grupo de docker e adicionou meu usuário nele, mas pra termos a permissão precisamos sair e entrar de novo. Então fazemos isso e veja só, o `docker ps` agora roda sem problemas e listou que não tem nenhum container rodando. Então vamos seguir o exemplo que o Docker Desktop sugere na primeira tela. Só copie essa linha e cole no terminal.







Demora alguns minutos mas ele vai baixar a imagem de um site que vai carregar na porta 80. Deixa baixar e executar. Agora podemos ir no navegador e digitar `localhost` pra conectar na porta 80 e voilá, ele baixou um site com documentação pra iniciantes. Se você ainda é novo no Docker, é um bom lugar pra começar a estudar. Leia tudo que tem aqui. 







Por último, o novo WSL2 tem um novo recurso que vai facilitar muito sua vida quando for rodar testes automatizados com coisas como Selenium ou Cypress, que abrem um navegador de verdade com o Chromium pra testar sua aplicação. Antes já tinha como rodar aplicações gráficas manualmente instalando um cliente de X no Windows como o X410 mas agora o WSL2 já tem suporte nativo. 







Só instalar a aplicação que quiser e executar que vai abrir de boa. Infelizmente ainda não tem suporte estável pra fazer pass thru pra GPU da sua máquina então tudo vai rodar 100% via CPU e isso certamente vai ser mais lento do que o navegador nativo no Windows. Mas como é pra cenários como de testes automatizados que falei, tá mais que bom.







Pra instalar é normal, só ir no terminal e fazer `yay -S chromium`, vai demorar porque o pacote é grandinho, mas é só isso. Vamo lá, vamo lá, acelerar um pouco aqui, e pronto. Agora é só digitar `chromium` no terminal e olha só, abre bonitinho como qualquer aplicação gráfica. Podemos carregar o YouTube e carrega rápido. Se abrir um video toca sem problemas no meu notebook inclusive com som. Tá sem som aqui porque eu tirei na edição mas pode acreditar que tem som.







Tem um site que costumam usar pra fazer benchmark de navegador, o Speedometer, mas do que já usei dele sei que é bem pouco confiável. Já rodei o teste múltiplas vezes no mesmo navegador e dava resultados bem diferentes, mas só por diversão vamos rodar nesse Chromium. Isso é o cenário que falei de testes automatizados. Ele vai circular por dezenas de aplicações de todo list feitos em diversos frameworks como Angular, React, Ember e outros. Acelerando um pouco o resultado final foi 172 pontos.







Agora vou abrir o Microsoft Edge aqui do lado e carregar o mesmo teste. Vamos ver. Vamos acelerar um pouco aqui com um pouco de mágica de edição e boom. Olha só que bizarro, o Chromium rodando virtualizado ganhou. Mas lógico, meu Edge tá cheio de extensions, cheio de abas abertas, e o Chromium tá recém instalado, totalmente vazio. De qualquer forma, na prática, a performance dentro do WSL tá muito boa. Daria até pra usar como segundo navegador.







Só pra mostrar onde o Chromium via WSL chora é se tentar rodar qualquer coisa 3D nele, por exemplo, um aplicativo em WebAssembly como o Google Earth. Olha só como fica lento, absurdamente lento, é literalmente inusável. E não tinha como ser diferente porque o WSL ainda não tem integração com aceleração 3D da máquina, é tudo renderizado pelo CPU. Mas se eu abrir o Edge que perdeu no Speedometer e carregar o mesmo Google Earth, olha a diferença. Roda liso, praticamente sem perder frames. Essa é a diferença de ter aceleração via GPU. Mas de novo, se você não estiver mexendo com games ou modelagem 3D, pra sites normais, não faz tanta diferença assim.







As novas versões do WSL tem suporte experimental a drivers de paravirtualização de GPU da Nvidia e Amd pra rodar projetos de machine learning em containers de Docker, como Tensorflow ou PyTorch. Eu mesmo não brinquei com isso ainda, não é estável nem garantido que vai funcionar, mas se alguém aí tiver inclinação pra escovar bit pra ver se funciona, vou deixar o link nas descrições também. Mas pra maioria de nós significa que se tiver aplicações gráficas de Linux que você precisa rodar no Windows, agora tem mais uma opção também, só não precisar de aceleração 3D.








E já que estou falando de coisas que foram adicionadas recentemente no WSL, tem uma que gostei muito. Pra mostrar, tem duas últimas coisas que eu faço sempre que reconfiguro um novo Linux. A primeira é copiar minhas chaves privadas que ficam no diretório `.ssh`, pra ter acesso às minhas contas de Heroku, AWS, GitHub, GitLab e tudo mais. Eu expliquei sobre chaves no episódio de Ubuntu e nos de criptografia. Você precisa tomar muito cuidado pra nunca ninguém pegar essas chaves. De qualquer forma, quando configuro máquina nova, eu zipo as chaves e copio. 







A segunda coisa é copiar minha pasta de projetos. Normalmente você não precisa ter tudo, projetos que nem mexe mais. Com as chaves no lugar, é só dar `git clone` dos projetos que precisa pra agora e tá ótimo. Mas eu quero dar um exemplo do que é possível fazer com o novo WSL. Vamos dar contexto. Lembram lá no começo do video que instalei o Arch no diretório `C:\arch`? Pois é. Vamos abrir o explorer de novo e temos um arquivo chamado `ext4.vhdx`. Esse é o "HD virtual" do Arch Linux que instalamos e estamos usando agora. Olhem como o Arch é levinho, com tudo que instalamos tá ocupando menos de 7 giga.







Esse é o melhor jeito de lidar com HDs virtuais, eles são arquivões binários. E eis porque eu fiz uns 4 videos explicando tudo que um programador deveria saber sobre dispositivos de armazenamento, particionamento, formatação e tipos de filesystems diferentes, porque agora vou assumir você entende o que é um HD virtual. Caso não saiba definir o que é uma partição ou qual a diferença de um filesystem ntfs ou ext4, recomendo que assistam os videos. Mas vamos lá.








Voltando pro terminal, o WSL automaticamente monta seus HDs de verdade, como o seu C:, dentro do diretório `/mnt`. Então se navegarmos pra `cd /mnt/c` e dermos um ls, vai listar exatamente o que tem no seu C:. E aí você pode ficar com a idéia errada de deixar seus diretórios de projetos no Windows e trabalhar neles de dentro do WSL. E isso seria uma péssima idéia. Isso porque esse mount que ele fez é parecido com conectar com um servidor de arquivos via rede, mais especificamente usando o protocolo P9 em vez de CIFS. Toda operação de arquivos nesse mount vai ser lenta, porque tem um overhead a mais por cima.








O lado oposto também dá. Do Windows acessar os arquivos dentro do Linux. Só abrir o explorer e digitar "\\wsl$" e pronto, podemos ficar copiando arquivos do Windows pro Linux e vice versa, tanto via terminal quanto via explorer. Mas como eu disse, é como se fosse uma pasta compartilhada na rede, mesmo sendo local, ainda vai ser uma ordem de grandeza mais lento. Especialmente projetos web que tem centenas de arquivos pequenos. O melhor sempre é transferir um zip grandão via rede do que centenas de arquivos pequenos.








A melhor performance é dentro do HD virtual montado diretamente, aquele arquivão VHDX. Lá dentro a velocidade é quase a mesma que nativa, tem muito pouco overhead. Tanto que ficamos aqui instalando pacotes, editando arquivos e tudo mais e a sensação era que estava rodando tudo nativo. Então o mais prático é fazer git clone dos seus projetos lá dentro mesmo e nunca jogar pra fora a partir no `/mnt/c`. Mesmo se conectar um HD externo que vai montar como `/mnt/d`, é a mesma coisa, vai ter overhead.








Em 90% dos casos você nunca vai ter nenhum problema se ficar dentro do hd virtual. Mas se for que nem eu que vira e mexe quer mudar de distribuição Linux, mover tudo pra outra máquina ou coisas assim, se tiver muitos arquivos pra ficar movendo, vai ser super lento e demorado, pode levar horas ou mais. O ideal seria alguma coisa tipo um HD externo montado direto. Mantém tudo fora, daí se quiser reinstalar a máquina não tem problema e não demora porque tudo que não era instalação de aplicativos já tava fora.







E se quiser usar um HD externo, o WSL agora suporta montar direto. Vamos ver esse cenário primeiro. Eu tenho um SSD com um adaptador pra USB. Quando conecta no notebook, o Windows detecta e monta como drive D:. Normal, todo mundo já viu isso quinhentas vezes. O que a maioria de vocês não sabe é como o Windows controla isso por baixo. Vamos abrir um Powershell com privilégios de administrador primeiro, alguns comandos que vamos usar a partir de agora vai precisar.








Desde a época do Windows 2000 existe a ferramenta `wmic` que é o Windows Management Instrumentation Command. É uma forma de instrumentar o Windows sem precisar usar aplicativos gráficos. Quando estamos vendo o drive D: isso é um mount point, um ponto de montagem como no Linux que monta dispositivos como diretórios como no `/mnt/c`. No Linux os dispositivos de verdade ficam declarados no diretório `/dev` e seu HD poderia ser um `/dev/sda` que montamos como a raíz `/`. Ficou confuso? Eu avisei, é porque você não assistiu meus videos sobre sistemas de arquivos.








Enfim, no Windows tem o mesmo conceito. Os dispositivos podem existir ligados sem ter um ponto de montagem como "D:" ou eu posso mudar o ponto de montagem pra outra letra se eu quiser, mas o dispositivo em si tem um identificador único que foi dado quando foi conectado. Pra ver isso, no Powershell que acabamos de abrir podemos digitar `wmic diskdrive list brief` e olha só, nesse notebook temos dois dispositivos de armazenamento, o NVME Sabrent Rocket de 4 terabytes que é o C: e o Kingston conectado via USB de 480 gigas. E os nomes dos dispositivos são esses `\\.\PHYSICALDRIVE0` e 1. São os equivalente no Linux a um `/dev/sda` e `sdb`.








O WSL2 mais novo ganhou a habilidade de montar um HD externo e acessar direto sem ter aquele overhead de rede do protocolo P9 que falei antes, ele monta direto o filesystem. Pra isso, aqui no Powershell mesmo é só fazer `wsl --mount \\.\PHYSICALDRIVE1`. Ele avisa que o disco foi anexado na máquina virtual mas falhou em criar um ponto de montagem. Notem que quando fiz isso, o Windows desmontou o drive D:, que era só um ponto de montagem. O ideal é não ter dois sistemas operacionais diferentes mexendo no mesmo HD ao mesmo tempo direto, obviamente.








De dentro do WSL, por padrão ele vai montar drives externos em `/mnt/wsl`, olha só, apareceu um novo diretório chamado "PHYSICALDRIVE1", mas se entrarmos nele não tem nada. O comando de mount do WSL tinha avisado que falhou e se consultarmos o `dmesg` que registra o log global do sistema operacional, tem de fato um erro do VFS que é o subsistema de file system virtual que falhou em tentar montar com filesystem ext4. E ia falhar mesmo porque esse SSD está formatado com NTFS, que o Linux não entende por padrão. Mesmo assim o dispositivo foi registrado dentro do Linux como `/dev/sdg` e se eu quiser poderia formatar usando o comando `mkfs.ext4` como qualquer outro drive.








Isso é legal porque posso ter um drive externo com partição formatada em ext4 e toda vez que reiniciar meu note, é só eu dar o comando `wsl --mount` que vai aparecer dentro do WSL e ter excelente performance, basicamente performance de um drive nativo, sem overhead nenhum. E eu posso compartilhar esse drive com meu Linux em casa e com outro Linux no escritório por exemplo. Super conveniente.







Mas eu gosto de complicar um pouco mais. Eu não quero usar um drive externo, quero usar um outro HD virtual só pra projetos, pra ficar separado do HD virtual de sistema operacional. Assim, posso compartilhar esse drive virtual com mais de um WSL na mesma máquina, que nem agora que eu já tenho um Ubuntu e um Arch Linux instalados no WSL. Ambos poderiam acessar os mesmos projetos sem duplicar nada. Como fazemos isso?







Pra criar um HD virtual é simples. Basta abrir o Disk Management e criar um VHD. Vou criar um arquivo chamado `test.vhdx` de 150 giga, formato VHDX que é mais moderno e com tamanho dinâmico, ou seja, quando montarmos esse disco virtual, o sistema operacional vai achar que ocupa 150 giga mas na verdade vai ter o tamanho dos arquivos que colocarmos dentro dele, então não desperdiça espaço do seu HD de verdade. Olha no Explorer o arquivo que criamos e como não tá ocupando praticamente nada de espaço porque ainda tá vazio.







De volta ao mesmo Powershell, o que precisamos agora é que esse arquivo seja reconhecido como um disco de verdade e pra isso precisa aparecer como um PHYSICALDRIVE no Windows primeiro, que nem quando espetamos o SSD via USB. E pra fazer isso usamos o comando `Mount-VHD` passando o caminho completo pro arquivo de disco virtual e ... deu pau. Isso porque esse comando só existe se você instalou as ferramentas do Hyper-V que é a plataforma de hypervisor da Microsoft. E isso só existe se estiver usando Windows 10 ou 11 versão Pro ou versão Server. 







Tudo que fizemos até este ponto do video funciona na versão Home do Windows. Eu sei disso porque quando reinstalei o Windows 11 do zero ele instalou como Home sei lá porque. Mas é só ir na loja do Windows e fazer o upgrade pra versão Pro. Custa um pouco caro, mas se sua profissão é ser programador, é um custo necessário. O upgrade hoje em dia é super rápido, leva alguns minutos e um reboot e já era. Se não gosta da idéia de pagar pelo Windows, é pra isso que existe Linux.







Estando no Windows Pro, agora eu procuro a opção de Turn On Features que é o instalador de funcionalidades opcionais do Windows e boom, ta aí a opção de Hyper-V que só tem na versão Pro. Leva mais alguns poucos minutos pra instalar, mais um reboot e pronto. Agora temos suporte às ferramentas do Hyper-V. Então podemos abrir o Powershell com privilégios de administrador de novo e repetir o mesmo comando de antes de `Mount-VHD`.







Desta vez foi com sucesso. A partir deste ponto, pro sistema operacional, esse disco virtual se comporta igual a um SSD de verdade. Vamos rodar aquele mesmo comando `wmic diskdrive list brief` e olha só, entrou como Microsoft Virtual Disk e se registrou como `\\.\PHYSICALDRIVE1` igual meu SSD Kingston via USB antes. E finalmente, podemos repetir o mesmo comando `wsl --mount`. Isso vai anexar o disco no WSL mas vai falhar a montagem de novo porque acabamos de criar esse disco virtual e ele tá vazio e nunca foi formatado.







Abrindo o terminal e olhando os logs no `dmesg`, mesmo erro de antes, não achou uma partição formatada com ext4. Mas ele tá bonitinho anexado como `/dev/sdg`. Como é um drive zerado, podemos formatar fazendo `sudo mkfs.ext4` que é o comando de 'make filesystem'. Pronto, agora que tá formatado, podemos dar `cd` pro ponto de montagem que é `/mnt/wsl/PHYSICALDRIVE1`. Mas note que ele tá com permissão pro usuário root então não vamos conseguir criar nada aqui.






Só falta dar um `sudo chown` pro meu usuário nesse Linux que é "akitaonrails" e pronto. Agora eu posso criar um arquivo aqui dentro com o comando `touch` e sucesso! Arquivo criado. Pro Linux isso é um SSD normal, montado diretamente sem nenhum tipo de gambiarra de rede, com velocidade máxima. Tem a mesma performance do disco virtual principal onde o sistema operacional tá instalado. Você pode criar quantos discos virtuais quiser e montar dessa forma.







Por acaso, eu tenho meu PC de casa que uso pra editar meus videos com WSL instalado e fiz um disco virtual com todos os projetos pessoais e da empresa. Virou um arquivão de mais de 20 gigas de coisas. Transferi pro notebook e agora coloquei no mesmo diretório C:\Arch. Tem que tomar cuidado se deixar em diretórios como Documents, caso Dropbox ou OneDrive estejam configurados pra fazer backup automático. Como é um arquivão gigante, toda vez pode tentar fazer upload de tudo, o que vai ser hiper lento. Faça backup mas tome cuidado de como vai fazer.







E pro último truque, eu queria que esse disco virtual de projetos fosse montado e anexado automaticamente no WSL toda vez que eu bootar a máquina pra não ter que toda vez abrir o Powershell e ficar fazendo `Mount-VHD` e `wsl --mount` todos os dias. Já vimos que se quisermos que algo rode toda vez que inicio o Terminal, no Linux foi fácil, foi só adicionar os comandos no nosso script `.zshrc`, aí ele inicia automaticamente o prompt powerlevel10k, o asdf. Mas no Windows não tem o equivalente fácil assim pra scripts.








Vamos ter que usar o bom e velho Task Scheduler que é o agendador de tarefas do Windows, que fica no aplicativo Computer Management e só tem opção gráfica. Então, botão direito menu de Start, selecionar Computer Management e na lista tem o Task Scheduler. Botão direito nele pra Criar Nova Tarefa. Colocamos um nome descritivo como "Auto Mount VHD" e configuramos pra rodar independente se eu estiver logado, marcamos pra não salvar senha e pra rodar com Privilégios de Administrador.







Na aba de Trigger criamos um novo que é "At Startup" que é pra rodar logo que o Windows carregar. Na aba seguinte de Actions é onde dizemos o que vai rodar no boot. O tipo de programa vai ser PowerShell e o argumento vai ser o comando de `Mount-VHD` só que agora o PATH vai ser pra "C:\Arch\projects-disk.vhd" que é meu disco virtual de projetos. Coloque o nome do disco que você criou. Pronto, e na última aba de condições é tirar a opção dele rodar de novo se o notebook entrar em modo de economia de energia e acordar. Não tem que rodar de novo.







Agora vamos fazer exatamente a mesma coisa só que pra outro comando. O nome vai ser Auto Mount VHD in WSL. Esses nomes são arbitrários, descreva como quiser. Mesma configuração. Depois o mesmo trigger at startup, mas diferente da última vez vamos colocar a opção de "Delay", ou seja, eu quero um pequeno atraso. 1 minuto pra garantir. Isso porque queremos rodar este comando só depois que o anterior tiver já rodado. O Mount VHD tem que anexar o disco virtual e só depois podemos montar no WSL. Se não for nessa ordem, não vai funcionar.








Agora a action vai ser de novo tipo PowerShell e o argumento vai ser o comando `wsl --mount` e vai estar hardcoded aqui que é pra montar o PHYSICALDRIVE1. Lembrando que se eu bootar a máquina com um pendrive ou algo assim pré-conectado, quando montar o disco virtual provavelmente vai cair pra PHYSICALDRIVE2 e aí esse mount no WSL vai montar o disco errado. Mas normalmente vai ser sempre PHYSICALDRIVE1. E finalmente mesma coisa, não precisa rodar de novo se acordar de sleep.







Feito isso, podemos bootar a máquina e quando voltar, esperamos 1 minuto e quando abrimos o Terminal podemos checar com o comando `lsblk` que lista dispositivos de bloco e lá está nosso `/dev/sdg` devidamente montado em `/mnt/wsl/PHYSICALDRIVE1` como a gente queria. Se listarmos os arquivos lá podemos ver que tem todo meu material. Mas convenhamos que digitar esse PATH enorme toda vez é um saco, mas pra isso que todo Linux suporta links simbólicos.







Vamos voltar pro meu diretório de casa com `cd` e vamos usar o comando `ln -s` pra mapear o link simbólico "Projects" apontando pro `/mnt/wsl/PHYSICALDRIVE1`. Pronto, agora podemos fazer `cd Projects` e ele entra no lugar certo. E agora sim, posso continuar dando `git clone` e `git pull` dos meus projetos pra cá e tudo vai funcionar com velocidade máxima. E tudo separado do disco virtual do sistema operacional. 







E mais do que isso. Lembra do Ubuntu que o WSL instalou lá no começo e eu não mexi mais? Vamos abrir uma aba pra ele e vamos pro diretório `/mnt/wsl` e olha só, aqui também tá montado. Tanto do Arch quanto do Ubuntu, o comando `wsl --mount` monta em todas as máquinas virtuais e eu posso acessar de qualquer uma a qualquer momento. Obviamente não recomendo abrir o mesmo arquivo dos dois lugares ao mesmo tempo, mas isso abre diversas possibilidades diferentes. Eu não preciso ficar copiando arquivos entre os dois, posso compartilhar o mesmo drive virtual. E isso só funciona porque o Arch e o Ubuntu compartilham o mesmo Kernel do Linux e esse kernel único tem acesso ao drive e por isso aparece no container dos dois sistemas operacionais diferentes. Eles não sabem que estão compartilhando a mesma kernel.








E por último, eu tinha falado que faltava transferir as chaves privadas de SSH e nesse disco virtual eu tinha copiado o arquivo `ssh.tgz`. Aqui vai depender de como você compactou mas eu preciso ir pra raíz do drive e fazer `tar xvfz /mnt/wsl/PHYSICALDRIVE1/ssh.tgz` e vai descompactar no lugar certo e já com as permissões corretas. Se tivesse copiado de um pendrive formatado em FAT por exemplo, as permissões não teriam sido mantidas então precisaria fazer `chmod -R 600 .ssh` que significa permissão 6 pro meu usuário que é leitura e escrita e permissão 0 pra todos os outros usuários, que é não conseguir nem ler e nem mesmo listar os arquivos desse diretório. 







Com isso o WSL do meu notebook está configurado e pronto pra eu poder voltar a mexer em código. Tenho o `yay` pra poder instalar qualquer programa do repositório AUR, tenho o Cargo do Rust pra instalar programas feitos em Rust, tenho o ASDF pra conseguir instalar qualquer linguagem de programação em qualquer versão e tenho o Docker pra poder rodar qualquer projeto. Além disso tenho meu prompt bonitão com o Powerlevel10K e posso editar código tanto no VSCode quanto no meu LunarVim fodão. E isso é tudo que um programador web precisa. Se eu fosse lidar com devops precisaria instalar outras ferramentas como do google cloud, kubernetes e coisas assim, mas aí é de projeto a projeto e com o que tenho configurado aqui, é só instalar com o `yay`.








Eu mencionei muito rápido no começo, mas uma das grandes vantagens de usar o Arch é a documentação da comunidade. Como no exemplo de instalar Docker, pra Ubuntu, eu precisei achar no site do próprio Docker e não no site do Ubuntu. Mas no caso do Arch tem um Wiki de Docker feito pela comunidade com um monte de informação e dicas muito úteis, seja pra quem é iniciante ou quem é avançado tentando resolver problemas mais complexos. Em vez de sair fuçando em fóruns ou lugares como o site stackexchange, normalmente você acha o que precisa no Wiki do Arch. Gaste tempo estudando tudo que não conhecia que mostrei nesse video a partir desse Wiki. Tenho certeza que vai aprender muito.








Tenho certeza também que muitos vão ficar mandando nos comentários ou mensagens diretas pra mim perguntando qual distro usar. Se tem dúvida, instale Ubuntu. Por isso eu fiz o guia definitivo de Ubuntu pra iniciantes. É a resposta padrão. De novo, se você tem dúvidas e veio perguntar é porque não tá com muita disposição de pesquisar, então é Ubuntu. Quem se importa já instalou um VirtualBox ou Virt Manager e criou máquinas virtuais pra baixar os ISOs das distribuições que tem interesse pra ver com os próprios olhos.








Hoje em dia é muito fácil. As ISOs você baixa de graça no site de cada distro. Daí é só bootar numa máquina virtual e usar alguns dias pra ver se gosta. Se ficou confortável, daí reserva um fim de semana, faz backup de tudo, queima a ISO num pendrive e instala como sistema operacional nativo. Não gostou? Muda pra outro. É assim que se faz. Perguntar pros outros não faz nenhuma diferença porque cada um usa pra coisas diferentes. 







Eu pessoalmente gosto de distros baseados em Arch como o Manjaro, mas acho o Manjaro meio feinho. Prefiro a cara de um Deepin, mas acho Deepin muito pesado e não confio muito nele. Kali Linux é seguro, mas não foi feito pra usar no dia a dia, só rodaria numa máquina virtual se precisasse fuçar coisas de segurança. E assim por diante.







A parte ruim é instalar em notebooks super novos. Meu Zephyrus G14 comprei acho que lá por julho do ano passado, tinha acabado de lançar. Significa que o suporte de Linux pra ele ainda era muito insipiente. Eu achei alguns scripts, alguns hacks pra tentar fazer tudo funcionar, mas coisas como bluetooth não ia de jeito nenhum, perfil de economia de energia ainda não tava adequado. No final das contas não tive muita confiança, daí voltei pra Windows com WSL que todos os periféricos iam funcionar direitinho.







Agora que já passou 1 ano, talvez já tenha mais gente que gastou tempo ajustando e talvez agora já funcione melhor, não sei. Mas no meu caso, realmente não vejo tanta vantagem. O Windows me atende bem, tenho zero problemas com coisas como Steam, e tudo que preciso pra programar roda no WSL. Como é uma máquina parruda, com CPU e RAM sobrando, mesmo numa máquina virtual como o WSL funciona tudo zero bala. Se fosse um notebook mais antigo e menos potente, daí já justifica deixar Linux nativo, porque quanto mais antigo for o hardware, maiores as chances de drivers e coisas assim já existirem e serem estáveis.








Por isso que a resposta é sempre, depende. E por isso que se você é programador ou quer ser, precisa saber ir atrás da documentação e todos os componentes da sua própria máquina, pra saber quais distros são mais compatíveis, que tipos de gambiarra vai precisar fazer ou não. Este video, não tem nada que eu inventei, tudo tem na web, só saber procurar. E de novo, expliquei coisas mais básicas no meu video de Ubuntu e assistam os videos sobre máquina virtual e containers, os videos sobre sistemas de arquivos e dispositivos de armazenamento e tudo mais. 







Se importe um pouco mais com sua própria máquina e seu ambiente de desenvolvimento. Se ficaram com outras dúvidas, mandem nos comentários abaixo. Se curtiram o video deixem um joinha, não deixem de assinar o canal e compartilhar o video com seus amigos. A gente se vê, até mais.
