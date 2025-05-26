---
title: "[Akitando] #56 - Falando um pouco de MAC, LINUX e WINDOWS | Qual eu devo escolher?"
date: '2019-07-24T17:00:00-03:00'
slug: akitando-56-falando-um-pouco-de-mac-linux-e-windows-qual-eu-devo-escolher
tags:
- mac
- macos
- windows
- microsoft
- linux
- ubuntu
- manjaro
- gentoo
- slackware
- debian
- quartz
- imac
- nextstep
- openstep
- steve jobs
- apple
- adobe
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/brIQSA8FtDo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


No episódio de hoje, pegando carona que eu fiz um vídeo sobre instalar ambiente de desenvolvimento em Ubuntu (https://www.youtube.com/watch?v=epiyExCyb2s) eu queria aproveitar pra contar vários pequenos momentos e conceitos sobre sistemas operacionais que eu gosto de ficar discutindo.

No geral eu poderia dizer que é um vídeo “comparando” Linux, Mac e Windows mas a idéia não é escolher um no final mas sim delinear o que aconteceu nos últimos 20 e tantos anos que me fez ficar mudando de sistemas e hardware ao longo do tempo e porque existem algumas opiniões formadas hoje que quem está só começando não consegue entender porque as recomendações são extremas em muitos casos.

Antigamente a gente pedia “pelamor” pros desenvolvedores darem uma chance pros Macs. Hoje em dia o povo não entende porque tem tanta gente ainda recomendando Macs tão veementemente. E no fim, qual é a melhor escolha pra desenvolvedores de software? Vamos descobrir isso hoje.

== Errata

Eu falei que Fedora usa Yum, mas não é verdade, eu esqueci que agora ele usam DNF.

== Seções:

03:03 - Linux
14:00 - Mac
32:45 - Windows

== Links:

* How eSports became mainstream (https://www.diggitmagazine.com/papers/esports-mainstream)
* Why the 64-bit Version of Windows is More Secure (https://www.howtogeek.com/165535/why-the-64-bit-version-of-windows-is-more-secure/)
* Steve Jobs changed the future of laptops 10 years ago today (https://www.theverge.com/2018/1/15/16892792/apple-macbook-air-steve-jobs-anniversary)
* WWDC 2005 Keynote (https://www.youtube.com/watch?v=B6iF6yTiNlw)
* Steam Proton (https://www.protondb.com)
* Puppy Linux (http://puppylinux.com)
* DDR5 | O que sabemos desse novo padrão de memória até agora (https://canaltech.com.br/hardware/tudo-sobre-memoria-ddr5-134725/)
* What Is PCIe? (https://www.lifewire.com/pci-express-pcie-2625962)
* NVMe SSDs: Everything you need to know about this insanely fast storage (https://www.pcworld.com/article/2899351/everything-you-need-to-know-about-nvme.html)
* A ZFS developer’s analysis of the good and bad in Apple’s new APFS file system (https://arstechnica.com/gadgets/2016/06/a-zfs-developers-analysis-of-the-good-and-bad-in-apples-new-apfs-file-system/)
* Why John Carmack Chose NeXT For Developing 'Doom' And Other Favorites (https://www.forbes.com/sites/quora/2016/09/01/why-john-carmack-chose-next-for-developing-doom-and-other-favorites/#6fb22dbb14d1)
* Picking up the pieces: John Siracusa mourns the Power PC (https://arstechnica.com/gadgets/2005/06/mac-20050607/)
* NextSpace (https://trunkmaster.github.io)
* Scaling from 2,000 to 25,000 engineers on GitHub at Microsoft (https://jeffwilcox.blog/2019/06/scaling-25k/)

* Rocketz Workstations (https://rocketz.com.br/workstation)

* AkitaOnRails - Optimizing Linux for Slow Computers (https://www.akitaonrails.com/2017/01/17/optimizing-linux-for-slow-computers)

=== Script


Olá pessoal, Fabio Akita

Seguindo na discussão sobre instalação de ambiente de desenvolvimento de software, eu acho que preciso responder, por que diabos eu uso Windows 10? E na realidade a resposta é bem menos interessante do que parece.


A resposta mais simples é porque na prática não faz quase nenhuma diferença se você estiver usando hardwares como o meu. O episódio de hoje vai ser longo, porque eu comecei a escrever e fui jogando vários assuntos aleatórios na mistura. Quando começamos a falar de sistemas operacionais eu tenho vários conceitos e histórias que acho importante dar contexto. A idéia foi trazer vários pontos que eu considero interessantes e falar tudo de uma vez do que tentar diluir em múltiplos episódios. Mas no final eu acredito que vocês vão sair com um entendimento maior do que simplesmente diferenciar um sistema de outro pelo visual, então tenham um pouco de paciência hoje.



(...)



Desde pelo menos 2013 eu não uso computadores com menos de 16GB de RAM. E recentemente meus dois computadores principais, um Lenovo Thinkpad Extreme e um PC torre que comprei da Rocketz ano passado, tem 32GB de RAM. Ambos tem placas NVIDIA, o primeiro com um GTX 1050 que é mais que suficiente pra um notebook, e o segundo com um bom GTX 1070Ti do ano passado que não é topo de linha, mas até pra gaming 1080p a mais de 100fps é bem suficiente.




Meu primeiro Mac foi um Mac Mini G4 de 2003 com processador Power PC G4 de 1.25Ghz, não lembro se tinha 2GB de RAM, HD mecânico de 40GB, mas praquela época já tinha USB-2 e Firewire 400. Eu lembro que brinquei muito de editar vídeos com iMovie e gravar em DVD. Eu tive depois o primeiro Macbook branco de 13" com processador Intel Core Duo. E meu último Mac foi um Macbook Pro 15" de 2014 com tela retina display, Core i7, 16GB de DDR3, 512GB de SSD e vinha com a GeForce GT 750M com 2GB de GDDR5. Na minha opinião a última série de Macbook Pro ainda à frente do seu tempo, quando o teclado ainda era bom, quando não tinha touchbar, quando havia Magsafe pro cabo de força.




Mas, eu acho que a grande maioria das pessoas assistindo não está muito disposto a gastar mais que 1000 dólares numa máquina, de preferência menos. E eu concordo com vocês, especialmente se eu tivesse 25 anos eu não poderia comprar nada muito mais caro que 500 dólares, e parcelado, claro. Como eu já disse no episódio de Ubuntu, vocês não precisam de uma máquina tão topo de linha assim. Em desenvolvimento de software, a menos que você esteja programando apps Android e precisa subir aquele emulador lento, uma máquina Core i3 Skylake, com 4GB de RAM, e até com HD mecânico deve ser suficiente pra maioria dos casos. Daí com o tempo você troca o HD mecânico por um SSD de 256GB, um HD externo via USB-3, e mais 4 GB de RAM pra ficar com 8.



A idéia não é ser uma divisão perfeita, mas vamos começar essa conversa de hoje falando um pouco sobre Linux primeiro, depois vou falar de Mac e depois de Windows. Se você viu meus episódios da série de Back-end onde eu explico sobre threads e schedulers, já sabe que existem diferentes formas de estratégia pra threads. E os 3 sistemas operacionais principais: Windows 10, macOS e as várias distros Linux usam estratégias de schedulers diferentes. O melhor sendo o CFS do Linux. O MacOS e o Windows implementam multilevel feedback queue, pense em múltiplas filas com prioridades, mas por alguma razão a implementação do Windows continua sendo a piorzinha. É aquele momento que tudo dá uma engasgada, fica um pouco lento, daí volta. Ou você tá assistindo youtube ou netflix, deixa outra coisa rodando por trás e em algum momento seu vídeo perde frames, dá uma engasgada. É o tipo de coisa que acontece com frequência em máquinas fracas. Eu raramente vejo porque tenho máquina sobrando. Mas é uma coisa que em Linux e Mac não acontece nem de longe com tanta frequência mesmo em máquinas mais antigas.




Lembram a metáfora de threads tendo que esperar a vez e o scheduler mudando a thread de mesa às vezes e o custo relacionado a mover os dados de uma core pra outra? Até algumas versões atrás o Windows fazia algo muito burro, não lembro se já corrigiram. Se você tinha cores sem fazer muita coisa, ele pegava a thread em execução e mudava pra outro core. Do nada, em vez de simplesmente manter na core que ele tava. Ele tentava ser preemptivamente mais esperto e isso causava overhead desnecessário. É exatamente o tipo de coisa que raramente acontece no macOS ou Linux. Sendo honesto, eu não tenho visto acontecer no Windows também, mas ainda não sei o quanto é porque meu hardware tá compensando isso.




Falando em schedulers, além de schedulers de threads como o Completely Fair Scheduler ou CFS, também temos schedulers pra I/O como o Completely Fair Queue ou CFQ. Se você usa HD mecânico e muitos processos querem fazer coisas no disco ao mesmo tempo, dá pra imaginar que não dá, então você vai também precisar de algum tipo de queue ou fila pra gerenciar isso. E no Linux você pode trocar os schedulers de threads e os schedulers de I/O. 





Numa máquina parruda, com muitos cores sobrando e SSD veloz, você sempre mantém o default que é CFS com CFQ ou noop pra não precisa gastar computação gerenciando filas pro I/O, já que SSDs são ordens de grandeza mais rápidos que HD mecânicos e conseguem lidar com muita concorrência. Se por outro lado você está numa máquina mais devagar, pode mudar do CFS pro MuQSS e do CFQ pro BFQ ou o Budget Fair Queue, além de configurar o swapiness da kernel pra evitar ao máximo usar swap de disco e criar mais gargalo no seu HD lento. São as coisas que explico no meu artigo sobre configurar Linux pra máquinas lentas que vou deixar de novo nas descrições abaixo.




Além disso você pode somar configurações assim com distros preparadas pra instalar componentes mais leves do que os Ubuntu da vida, e evitar que você precise manualmente ficar instalando vários pacotes. Exemplo disso seria um Lubuntu, ou Light Ubuntu, ou também um Puppy Linux que é baseado em Debian. Como parêntese alguns me falaram do Pop OS mas eu não gostei muito dele, é basicamente um Ubuntu pré-configurado e com repositórios extras pra facilitar instalar algumas coisas como tensorflow. Mas não vi grandes vantagens não. Primeiro quero ver se ele dura, já que foi criado e é mantido por uma pequena empresa tentando vender hardware customizado. Já vi isso acontecer antes com distros como Lindows, mas que sumiram. Um Mint ou Elementary pelo menos já existem faz alguns anos e continuam sendo suportados. Pra eu instalar como daily driver, precisa ter mais tempo de existência. Prefira escolher distros que já tem alguns anos de estrada.




Dentre as dezenas de distros que existem, eu acabo preferindo os mais maduros e com ecossistemas maiores, aqueles que todo tutorial que você abre tendem a ser os primeiros.  Nessa categoria você tem principalmente os derivados de Debian. Ubuntu é um fork de Debian. Mint e Elementary são customizações em cima do Ubuntu, todos usam pacotes DEB com gerenciador APT. Você tem os derivados de RedHat como Fedora pra desktop ou CentOS pra servidor, e tem o Suse que é meio primo deles também, todos usam pacotes RPM com gerenciador YUM. Você tem os derivados de Arch como o Manjaro que usam Pacman. E tem os mais de nicho antigos como Slackware e Gentoo. 




Uma característica que pode ou não ser um problema pra você no caso de Debian é que a intenção dele é ser sempre uma distro estável e confiável, e isso significa que ele demora bem mais pra oferecer versões mais novas de softwares mais novos. E faz sentido, tudo que é novo e ainda não foi testado o suficiente sempre deve ser considerado potencialmente bugado ou instável. Mas como desenvolvedores a gente muitas vezes precisa das coisas instáveis também, e por isso tem forks como um Ubuntu da vida, que oferece versão um pouco mais estável que são os LTS ou Long Term Support como o atual 18.04, que a Canonical deve fornecer suporte por uns 5 anos pelo menos, e versões mais bleeding edge, ou instáveis com coisas mais novas pra testar, que é a versão ímpar 19.04, que vai ter suporte bem menor. Mais ou menos o mesmo princípio você tem com CentOS sendo mais estável do que Fedora que tem pacotes mais recentes. Arch é sempre mais instável porque ele vai atualizando pra frente como se não houvesse amanhã. Não quer dizer que ele tem problemas, só que tem mais chances de ter, ele é uma bicicleta sem rodinhas, você tem que saber andar sozinho sem apoio.




Eu disse que Arch você vai sofrer se for iniciante, mas minha recomendação teve um pingo de compaixão. Arch pode parecer um pouco complicado no começo, mas ele é um sistema moderno, com gerenciador de pacotes e dependências bem competente, e com um dos melhores Wikis disponíveis em qualquer distro. Tem ampla documentação e suporte. Agora se você quiser ir pra um nível mais hardcore, precisa tentar Slackware. É a distro mais antiga ainda sendo mantida, desde 1993. Ele é um dos mais simples e mais parecido com o UNIX original e sua filosofia de KISS (keep it simple, stupid). Ele nem tem um gerenciador de dependências propriamente dito. Seus pacotes são meros tarballs, tipo zip se você não sabe o que é um tarball. 



Em algum momento acho interessante tentar Slackware, mesmo hoje em dia. O Slack foi minha primeira distro em 1995. Não vou dizer que tenho boas memórias dele. Mas se quiser ir ainda mais um nível hardcore, você precisa experimentar o Gentoo cuja filosofia é baixar só código fonte e compilar tudo, literalmente tudo, na sua própria máquina. O sistema Portage dele é meio inspirado no Ports do BSD. Essa é uma distro pra você que tem muita curiosidade, muito tempo e principalmente muita paciência.




A maioria das distros mais novas por alguma razão acabam derivando de Ubuntu, caso do Pop OS. Um dos mais promissores na linha de Mint ou Elementary hoje seria o Deepin, que eu acho que é um dos mais bonitos e mais próximos da usabilidade de um MacOS sem tentar ser um clone exato. E de bônus, pra quem gosta de Arch e Manjaro, também tem a versão Manjaro Deepin que você pode usar em vez do Manjaro GNOME. Aliás, tem isso também, muitas distros já trazem versões pré-configuradas com diferentes desktop managers, como GNOME, KDE, Cinnamon, XFCE, o do Deepin que usa kwin, que é derivado do KDE Plasma, e outros mais exóticos com o i3 que muitos adeptos de teclado estão adotando.





Isso tudo dito, em PCs mais fracos não tem o que pensar, eu definitivamente recomendo instalar um Linux pra tirar o máximo da máquina. Em PC mid-range ou topos de linha eu acabo ficando no Windows puramente pelo suporte. Veja bem, minha situação é diferente da maioria das pessoas: meu dia a dia hoje não é mais ser programador tempo integral. Independente dos meus motivos pessoais, a recomendação ainda é tentar se manter no Linux como máquina primária. No meu caso, na maior parte do tempo eu vou acabar ficando em web apps, gmail, twitter, reddit, calendar, dashboards de AWS ou Google Cloud, e é tudo web. Coisas que tem clientes nativos como Dropbox, Zoom, Skype, tudo funciona bem em todos os sistemas operacionais. Apesar de eu não me incomodar com Google Docs ou Google Spreadsheet, eu ainda não gosto do Slides e mesmo a versão online do PowerPoint eu não me vejo usando. Ainda prefiro as versões nativas de apps do Office. De novo, é um gosto pessoal.




E mesmo o PowerPoint, tem várias coisas que ele faz até melhor que todo mundo mas em termos de usabilidade e produtividade ainda não supera o lendário Keynote da Apple. Mas tudo bem, em termos de pacotes de produção de conteúdo, eu gosto de ter acesso ao Adobe Creative Cloud, que só tem pra Windows e Mac. Mesmo em Mac eu ainda não trocaria Photoshop por qualquer outro produto. De novo, tudo gosto pessoal aqui. Entenda que metade da minha preferência pessoal é o fato de eu ter anos de experiência em ferramentas Adobe ou Apple. Se você nunca usou essas ferramentas, não vai sentir falta, então se começar com LibreOffice Impress, Google Slides, Da Vinci Resolve, Gimp, Inkspace, vai se acostumar. Em trabalhos criativos a ferramenta tem menos importância do que o treino artístico do profissional.




Se você não precisa de pacotes Microsoft, ou Adobe, ou não tem necessidade de desenvolver pra iOS, qualquer PC com qualquer boa distro Linux deve mesmo ser a primeira escolha. Você não está perdendo nada. Como muitos me lembraram depois, o Steam tem a opção do Proton e com isso a maioria dos games roda bem hoje em dia em Linux também. Dota 2, CS Go, Rocket League, Skyrim, Fallout, vai rodar. Se você joga Pubg vai ter problemas. Por baixo dos panos ele usar Wine e DXVK mas você não precisa ficar configurando manualmente jogo por jogo, por isso tá bem mais viável com o suporte da Valve hoje em dia.



Ou seja, numa máquina boa, o Windows funciona bem o suficiente pra eu esquecer que estou usando ele. E se você precisa de produtividade, realmente não quer ficar deixando sua máquina principal com risco de ficar instável, e nesse sentido não há nenhum grande problema em ficar no Windows. Mas na realidade, enquanto estou escrevendo este script eu estou muito tentado a voltar pro Linux como sistema primário. Entrei no Arch Wiki e vi que meu Lenovo Thinkpad X1 Extreme funciona perfeitamente com exceção do leitor de impressão digital, que não faço tanta questão de usar. Então eu acho que depois de editar este video vou instalar o bom e velho Manjaro, talvez o Deepin. Acompanhem minhas redes sociais pra ver como vai ficar.




Agora vamos pra parte 2, sobre Mac, o que eu realmente gosto é a consistência. Em Linux você tem diferentes desktop managers como GNOME, KDE, e por aí vai. Com diferentes toolkits gráficos como GTK, Qt, Tcl/tk, e isso faz com que cada aplicativo fique com sensação de "fora do lugar" se rodar misturado. Pegue um Kdenlive, que é feito com o toolkit Qt pra KDE,  ele fica fora do lugar rodando num GNOME. Ou um Gimp rodando num KDE. A interface gráfica de Linux é uma zona. Aliás, parece que estou falando mal, mas calma, a nova interface do Gimp, por exemplo, ficou sensacional se comparado como era antes, e inclusive recomendo que dêem uma olhada. Isoladamente, cada aplicativo é muito bom, especialmente com os refinamentos de hoje em dia, mas como um conjunto eles são muito inconsistentes em usabilidade.




No mundo Windows é um pouco parecido porque a Microsoft não se compromete numa única linguagem de design. Desde o Windows Vista eles vem tentando modernizar a interface, mas aí mesmo entre os aplicativos da própria Microsoft você tem aberrações como o aplicativo principal de Settings pra maioria das configurações da máquina, mas ainda tem o antigo Control Panel pras coisas que ele ainda não modernizou. Coisas simples como botões, tem o estilo pseudo-3D em apps velhas, tem botão cinza, tem botão translúcido. Cada hora é de um jeito. Coisas bestas como o console ou o Notepad, só começaram a ser modernizados agora. Olha como o Notepad contrasta ao lado da Calculadora. Eu abro muitas coisas e parece que voltei pro Windows XP. Especialmente se pegar programas mais antigos de terceiros que não se atualizaram.




A Apple iniciou a idéia de um Human Interface Guideline ou HIG décadas atrás, literalmente um guia de usabilidade e design visual de todos os elementos do sistema operacional. A forma com que eles conseguiram manter esse HIG consistente e sempre se atualizando é que os aplicativos que a própria Apple desenvolve usam o HIG e os aplicativos feitos pela própria Apple tendem a ser muito bem feitos, e todos os usuários querem os mesmos elementos em todos os outros aplicativos. Eles são tão bem feitos, que até usuários de fora do Mac gostariam que seus apps em Linux e Windows ficassem parecidos. Olha esse dialog box pra escolhe arquivos do MacOS e veja o do Deepin que falei antes, ou o Finder no Mac e o file manager do Deepin. Está bem claro que o Deepin gosta da estética do MacOS também. Então sempre existiu tentativas assim de se criar temas e skins pra Linux e Windows ficarem mais parecidos com Macs. Quando você viu um usuário de Mac tentando tematizar o Mac pra ficar com cara de Linux ou Windows?





No Mac é tudo mais consistente. Manter consistente foi um risco que se pagou. Eles determinaram e cumpriram linhas de corte drásticos que na época deixou muita gente descontente, mas hoje o resultado se paga. Quando Steve Jobs voltou pra Apple ele trouxe o lendário NEXTStep que é o desktop manager e os frameworks de desenvolvimento de aplicações feitos em Objective-C. Quando eles evoluíram o NEXTStep pra virar o OS X eles fizeram uma camada de compatibilidade binária com o Mac classic. Então se você executasse um binário de Mac antigo ele conseguia rodar. Facilitou que o OS X rodava no mesmo processador dos Macs antigos, o IBM Power PC e foi assim de 2000 até 2006.





O NextStep foi a parte da Next que sobreviveu. Muitos talvez reconheçam a Next por causa da workstation Cube onde Tim Berners Lee desenvolveu o primeiro protótipo de um navegador web e o protocolo HTTP. Ou onde John Carmack desenvolveu o lendário Doom. As capacidades de desenvolvimento num Next eram reconhecidas como de fato as melhores da época. Se você abrir um Interface Builder do Xcode de hoje, é algo muito parecido com que eles usavam no fim dos anos 80 num Next.



Enquanto a linha de hardware morreu, o NextStep foi padronizado como OpenStep junto com a Sun. No mundo Linux surgiu o desktop manager chamado WindowMaker que tinha o look and feel do NextStep mas na verdade foi feito em C. E teve o GNU Step que era uma tentativa de implementação dos frameworks em Objective-C. A idéia é que um dia um app de NextStep podia ser compilado em GNU Step e rodar em Linux. Recentemente descobri um projeto que está incompleto e eu não testei ainda mas que se chama NextSpace e é uma tentativa mais moderna de ter um ambiente NextStep em Linux. Ele tem a cara do antigo WindowMaker mas implementando da forma certa os frameworks todos em Objective-C. Se ele for bem sucedido, seria até possível pegar códigos fonte de aplicativos simples feitos pra Mac e recompilar em Linux usando esse framework. Ele está fazendo o caminho certo: em vez de tentar reimplementar os frameworks e o visual de um Mac moderno, ele está fazendo o mesmo caminho que a Next fez pra dentro da Apple em 1998.




Voltando pra história, quando anunciaram o beta do novo sistema operacional, codenome Rhapsody, a idéia era um NextStep onde você podia rodar só aplicativos novos feitos em Objective-C e os apps antigos do Mac classic rodariam num Yellow Box que era basicamente uma camada de emulação. Claro, os desenvolvedores ficaram muito bravos. Eles queriam que os aplicativos deles funcionassem nativamente no novo sistema operacional, mas ninguém estava muito a fim de reescrever tudo que se tinha antes em Object Pascal ou C pra Objective-C. Por isso a Apple resolveu desenvolver um framework intermediário, mais compatível com a API do Mac classic. Esse conjunto de APIs intermediários foi chamado de Carbon. Você precisava modificar algumas partes do seu código antigo e recompilar usando o framework novo que dava acesso aos recursos modernos do OS X, como permitir multi tarefa preemptiva e modo de memória protegido. Era o processo de carbonização.




Daí em 2006 eles fizeram um dos movimentos mais interessantes que eu vi no mundo de tecnologia até então: mudar os Macs dos processadores Power PC pra Intel. Eu lembro quando assisti o Keynote e fiquei muito impressionado com a estratégia. Mais ainda porque desde 2001 nós ouvíamos mesmo rumores de que o OS X, por ter a estrutura UNIX e tudo mais, não deveria ser tão difícil de recompilar em Intel. E Jobs anunciou exatamente assim, foi sensacional. Na prática, a IBM provavelmente estava mais interessada nos processadores que estava vendendo simultaneamente pra Sony nos PS2, pra Microsoft nos Xbox originais e pra Nintendo nos GameCubes. A promessa que eles fizeram de um processador G5 de 3Ghz passou 2 anos e eles não entregaram pra Apple, e isso obviamente fez Steve Jobs ficar com cara de bobo por ter prometido isso 2 anos atrás. E um Jobs bravo não é exatamente fácil de negociar. 




Frigir dos ovos, fora IBM, olá Intel. Alguém na IBM deve ter pensado pfff foda-se, duvido que eles nos abandonem, vão fazer o que, ter a dor de cabeça de migrar tudo pra Intel? É exatamente o que um Jobs bravo faria, e fez. Pra isso funcionar eles fizeram uma estratégia em etapas. Binários antigos de Power PC rodariam sobre uma camada de emulação chamada Rosetta, de uma pequena empresa que a Apple comprou. Essa camada traduzia as instruções RISC de PowerPC em instruções x86 em tempo real. Óbvio que era mais lento, mas era muito impressionante.




Toda aplicação mais nova, já desenvolvida no framework derivado do NextStep, que a essa altura tinha sido renomeado de Cocoa, só precisava assinalar um checkbox na IDE XCode. Fizeram uma apresentação de como pediram o código fonte do lendário Mathematica que rodava em Power PC e com algumas horas de tweaks no código e assinalando o tal checkbox, já se tinha um binário pronto pra rodar nativo em Intel. Aliás, esse keynote inteiro é de longe uma das melhores apresentações de transição de roadmap de produto que eu já vi, é uma aula que eu recomendo que vocês assistam. Vou deixar linkado o keynote nas descrições abaixo.




Até esse ponto muita gente preferia desenvolver no antigo CodeWarrior da MetroWerks, que era o que se usava pra escrever código pra Mac classic. Pra migrar pra Intel era preciso compilar via o novo XCode 2 e foi assim que o CodeWarrior morreu e todo mundo passou a adotar XCode. Ironicamente o CodeWarrior ganhou notoriedade quando a Apple migrou dos processadores Motorola 68000 pra PowerPC, e agora perdeu o bonde na segunda transição. 




Todo aplicativo antigo que já tinha sido carbonizado também era praticamente só recompilar. Ao recompilar eles trouxeram outra tecnologia do NextStep: os Fat Binaries que foram renomeados como Universal Binaries. Um dos recursos mais interessantes pra mim no OS X e NextStep era o conceito de bundles. Tecnicamente em vez de você dar duplo clique em cima de um binário executável, você manda executar um bundle, que é simplesmente uma pasta especial com um arquivo de manifesto e algumas convenções de subpastas e nomes. Daí o OS X procura dentro dessa pasta o binário pra Power PC ou pra Intel dependendo de onde está rodando e executa o certo. Daí quando precisou migrar de 32-bits pra 64-bits foi a mesma coisa: recompilar e gerar os binários e fica tudo no mesmo bundle. Esse conceito de universal binary foi outra coisa inteligente na época que me deixou impressionado, porque eu estava vendo no Windows começar a aparecer coisas como o diretório Program Files (x86) ao lado do diretório Program Files, que é um troço que ainda existe no Windows até hoje. Isso sem contar o buraco negro radioativo que são os diretórios System32 e WOW64.





A Apple só conseguiu fazer isso porque a quantidade de pessoas usando Macs era muito pequena, só alguns poucos milhões. Então não tinha tanto problema se uma porcentagem pequena dos usuários ficasse alienada sem conseguir atualizar por conta de aplicativos legados que não iriam mais rodar. O ideal era todo novo aplicativo ser feito já usando os frameworks do Cocoa, em Objective-C, com XCode. E pra facilitar mais ainda, 2 anos depois desse anúncio eles lançam o iPhone, e nem 2 anos depois o Xcode passa a suportar compilar pra processadores ARM, usando frameworks derivados de Cocoa, em Objective-C, então mesmo se a maioria das pessoas não fosse adotar XCode e Objective-C, a urgência de querer desenvolver pra iPhone automaticamente criou essa necessidade e foi assim que Objective-C passou de uma linguagem obscura que quase ninguém usava além de desenvolvedor de Mac pra uma das linguagens mais reconhecidas nos anos 2010. E aqui eles demonstraram novamente, que não importa se você acha que uma linguagem é bonita ou feia, o que trás adoção pra linguagem é um killer app, no caso o iPhone e sua App Store. Sem um killer app, uma boa linguagem está morta.





Nesse sentido, acabou dando tudo certo pra Apple. Eles tiveram a possibilidade de começar praticamente do zero com o OS X, migrar os principais aplicativos aos poucos via carbonização ou reescrever direto em Cocoa. Ajudou que a fundação era baseada em UNIX então havia muito código aberto que podia ser reusado no processo, vindo tanto dos ecossistemas de BSD e de Linux. Vocês podem ver que esse processo de nascimento e evolução do OS X foi extremamente fascinante de se ver, e com os novos hardwares, qualquer programador antenado queria muito entrar nesse ecossistema o quanto antes, e por isso eu migrei pra Mac em 2004 e me senti ainda mais justificado com tudo isso que aconteceu.




Quando a adoção de iPhone aumentou a adoção de Macs, ao mesmo tempo comunidades web como Ruby on Rails já haviam entrado nesse vagão. O fato de Ruby vir pré-instalado em Macs ajudou muito. O fato de muitos aplicativos de Linux serem compatíveis no nível do código fonte também ajudou. Daí nasceram muitas ferramentas que são usadas até hoje e são parte fundamental do desenvolvimento tanto Web como Mobile. No começo era muito chato usar ferramentas open source no OS X porque a gente precisava baixar os fontes e compilar tudo na mão e torcer pra compilar. Aos poucos surgiram ferramentas automatizadas como o antigo Fink que tentava imitar o apt-get do Debian pra ser um repositório pra baixar pacotes em formato DEB, mas teve muito pouca adoção e suporte e morreu. Outra tentativa foi o MacPorts que tentava simular o Ports do BSD pra baixar pacotes de código fonte e compilar toda vez que baixava. Esse até durou alguns anos mas morreu também.




O que sobreviveu e existe até hoje é o Homebrew que é o gerenciador de pacotes que todo desenvolvedor de Mac usa e é feito em Ruby. No mundo mobile mesma coisa, a gente precisava organizar dependências ou manualmente usando coisas como submódulos de git, ou baixando as bibliotecas manualmente e jogando em pastas no projeto. Mas então surgiu o CocoaPods pra gerenciar dependência de projetos pra iOS, e ele também foi feito em Ruby. Outro dia vou falar mais de Ruby, mas os rubistas foram os que começaram a ajeitar o Mac pra ficar boa pra ser usada por qualquer desenvolvedor. O pacote Oh-my-ZSH pra trocar Bash por ZSH, de novo, foi feita por outro rubista. 




Eu falei no começo que no mundo Linux e Windows a linguagem visual dos aplicativos é toda misturada. No mundo Mac, essas transições meio que forçaram o desenvolvimento de novos aplicativos usando os frameworks mais modernos e os guias HIG da Apple. E com a adoção de parte do mundo open source, e o desenvolvimento acelerado de apps iOS, a gente tinha um app bom atrás do outro surgindo. Editores de texto como o TextMate 2 que nós da comunidade Ruby começamos a usar dita a linguagem de todo novo editor de texto até hoje. A idéia de um editor rápido e simples que pode ser extendido via plugins, com recursos pra fazer pesquisa fuzzy em nome de arquivos, diversos shortcuts e macros pra expandir templates de código.




Se você usa Sublime Text, ou Atom ou Visual Studio Code e abrir o TextMate 2 com os diversos plugins instalados, vai ver como a gente tinha exatamente a mesma coisa que se tem hoje só que em 2004. Nenhum outro sistema operacional tinha um TextMate. E foi assim que surgiu a nova geração de plugins de Vim e Emacs que elevaram esses editores ao que eles são hoje também. O renascimento de vim como editor mais moderno veio muito dos plugins feitos pra Rails por outro rubista, o Tim Pope. Pela primeira vez as tendências principais de desenvolvimento de software estavam iniciando primeiro nos Macs e sendo levados pra Linux e Windows depois. Só considere que quase toda ferramenta que você usa hoje, de GitHub a Heroku, foi feito por desenvolvedores usando Macs. 



A estética da Apple influenciou a web moderna, começando com o visual do Aqua original com seus elementos parecendo plástico translúcido, como os iMacs antigos, e depois se tornando mais metalizado como os PowerMac Titanium, e finalmente se tornando mais minimalista seguindo a identidade de aplicativos de iPhone. Hoje eu diria que o design e estrutura de apps e sites meio que convergiu e está mais estável, mas não havia lugar melhor pra estar entre 2006 a 2010 se você fosse desenvolvedor de software. E se você assistiu meu video da Apple e GPL que vou deixar linkado aqui em cima, também sabe que nesse período foi quando eles contrataram o Chris Lattner que evoluiu o LLVM até o clang substituir o GCC e desenhou a nova linguagem Swift. Desenvolvimento de software no mundo Apple era realmente empolgante com tudo isso.





Você tinha um pacote muito atraente: na época os Macs tinham preços até que competitivos mesmo se comparado aos PCs. Com a vantagem que os PCs eram objetivamente piores. O design industrial era desastroso pra dizer o mínimo. As configurações padrão eram fracas. Iniciativas como netbooks foram um fracasso. O Windows Vista da época não estava exatamente atraindo novos usuários. Pensa que o Windows 7 só veio a sair em 2009, ano que todo mundo queria Mac pra desenvolver apps pra iPhone. E pensa que só um ano antes tinha acabado de sair o Macbook Air que obliterou a imagem que a gente tinha de notebooks e iniciou a categoria de ultrabooks.




Sério, os PCs de antes de 2011 eram ruinzinhos, e muito feios. Os da Apple por outro lado, era um modelo melhor que o outro saindo frequentemente. Dava vergonha abrir um notebook PC do lado de um Macbook. Mas foi a partir de 2012 que as coisas começaram a virar. Steve Jobs estava mais ou menos certo: as tecnologias da Apple estavam uma média de 5 anos à frente do mercado. Incluindo I/O mais veloz com coisas como Lightning e Thunderbolt, o conceito de unibody enclosure, tecnologia de baterias, as telas Retina num mundo que ainda vendia monitores 720p todas descalibradas, o melhor trackpad até hoje ainda, e os melhores teclados em notebooks.




Mas, Steve Jobs morreu em 2011, e com ele foi enterrado também a visão e estratégia da Apple. O Mac Pro trashcan em 2013 iniciou um período de idade média dos hardwares Pro da Apple. A bolha de apps pra iPhone já estava estabilizando por 2014, então isso não ia mais acelerar venda de novos Macs. E pra piorar a partir de 2015 eles começaram a errar a mão nos Macbooks. Os teclados com switches butterfly são a pior construção que eu já vi, além de na prática serem rasos e desagradáveis pra longos períodos de digitação. O touchbar removendo teclas que são úteis pra desenvolvedores não ajudou em nada. Manter o mesmo unibody enclosure e ir entuxando CPUs que esquentam mais e mais como os Core i7 e os Core i9 causando thermal throttling não ajudou também. Eles esqueceram como em 2005 eles decidiram até mudar de CPU porque os G5 esquentavam demais pros produtos que a Apple queria fazer.




A Apple foi aumentando os preços e entregando menos. E nesse vácuo todos os outros fabricantes foram ficando melhores, em todos os segmentos, tanto em smartphones, como notebooks, como desktops. A Dell veio lançando um XPS melhor que outro faz uns 4 ou 5 anos já. A Lenovo veio lançando Thinkpads cada vez melhores e retornando à antiga glória. Mesma coisa com HP, Acer e outras marcas tradicionais. As marcas chinesas começaram a aparecer mais e mais com Xioami, Huawei e novas marcas começaram a pegar nichos mais premium com os notebooks da Razer. Chegou a hora de explorar a 3a parte deste episódio e pisar no mundo PC um pouco.




O mundo gamer explodiu por conta das iniciativas do governo da Coréia do Sul desde o ano 2000. Os torneios de eSports foram crescendo de meros 10 torneios no início do século pra 260 em 2010 a quase 700 em 2012. O Twitch foi lançado em 2011 e em 2015 já tinha mais de 4.5 milhões de visualizações únicas. Foi quando começou a sair as principais franquias de hoje como LOL, Dota 2, CS:Go, cada um atraindo milhões de novas pessoas a eSports. A Nvidia estava com placas ficando cada vez melhores como a GeForce 600 na arquitetura Kepler. A AMD que a Apple adotou como padrão entrou num vácuo até recentemente. A Apple perdeu o bonde do mundo gamer.




Se você não for gamer pode não parecer, mas a profissionalização de eSports ajudou em muito a evoluir mais rápido todos os componentes de PC. Antigamente era de fato fácil montar um PC equivalente mais barato que um Mac, mas eu sempre tive a sensação de que o resultado final não chegava perto. Por exemplo, não era comum montar PCs com porta Firewire 800. Mas hoje é comum PCs com Thunderbolt 3. Hoje eu diria que existem configurações de hardware superiores e não parece mais que eu estou perdendo alguma coisa. Pelo contrário, agora parece que ficando no Mac eu estou perdendo muita coisa boa no mundo PC.




Pra facilitar, o Windows 10 apareceu pra limpar a zona que foi do Vista até o 8. Conseguiram consertar o start menu, tiraram a porcaria da barra de Charms, otimizaram o suficiente pra não ficar pesado em máquinas mais fracas. E pra completar a partir de 2012 a própria Microsoft começou a entrar no nicho de tablets e ultrabooks com a linha Surface. E aqui eles acertaram bastante. E de fato, fazer o próprio hardware definitivamente ajuda a Microsoft tanto a ter uma linha de referência pros parceiros quanto a otimizar melhor o sistema pra um hardware de verdade em vez de depender só do feedback dos OEMs.




Uma nova geração de desenvolvedores começou a entrar na Microsoft. Foi recente que eles pularam de um headcount de aproximadamente 2 mil desenvolvedores pra 20 mil. Isso trouxe um exército de jovens programadores que cresceram sem o viés de achar que tudo que não é Windows é inimigo. Ajudou muito que eles resolveram se aventurar no mercado de infraestrutura como serviço pra competir com a AWS e fizeram o Azure. O Azure expôs todas as fraquezas do Windows como servidor. E eles se viram na necessidade de aprender com o que o Linux já tinha conquistado até então. Tecnologias como Hyper-V evoluíram muito desde então, o suficiente pra se tornar úteis no mundo desktop também.




A migração de 32-bits pra 64-bits ajudou a Microsoft porque muitos novos dispositivos de segurança se tornaram possíveis com essa mudança, como ASLR ou Address Space Layout Randomization. Explicando de forma simples, eu ensinei no meu episódio sobre gerenciamento de memória sobre endereçamento. Se um hacker sabe em que endereço determinada função com bug de segurança é sempre carregado, fica fácil de atacar. Em 32-bits eu posso mudar de lugar, mas você lembra como tem poucos endereços no final pra aplicação. Então mesmo mudando de lugar, via força bruta, dá pra achar ainda. Em 64-bits a dificuldade aumentou exponencialmente. Esse é um dos recursos habilitados em Windows de 64-bits dentre outras e isso ajudou a diminuir muito a superfície de ataque dos hackers. Apesar de ainda existir centenas de vetores de ataque você pode ver como não é mais tão frequente ouvir falar de Windows 10 em 64-bits sendo atacado de forma tão vergonhosa como foi Windows XP.





E com Hyper-V se tornando componente padrão pra segurança criando coisas como secure enclosures em hypervisor, por exemplo, no novo Windows Defender. Não é difícil ver que as coisas realmente mudaram dentro da Microsoft. Hoje em dia eu tenho um Malwarebytes instalado mas me dá a impressão que só o Windows Defender é suficiente pra maioria dos casos. E pros casos mais exóticos eu ainda tenho a opção de abrir o Windows Sandbox, que é um Windows virtualizado em Hyper-V pra rodar coisas inseguras. Ele sobe um Windows vazio, eu posso instalar até um virus ali, e ele não tem acesso à máquina hospedeira. E quando eu fecho o sandbox, tudo dentro dele morre.




Esse tipo de uso de tecnologia me empolga bastante e, claro, eu posso fazer tudo isso num Mac ou Linux também. Mas de novo, eu gosto de coisas que vêm por padrão, oferecendo consistência. E falando nisso, uma coisa que o Windows nunca pôde fazer, foi começar do zero. Ele ainda é obrigado a trazer diversos binários antigos pra manter compatibilidade com programas velhos. Em seu mérito, é possível pegar um programa binário que rodava até em Windows 98, e provavelmente vai executar no Windows 10. Nenhum outro sistema operacional tem esse nível de retrocompatibilidade binária.




Porém isso também significa que existem muitos vetores inseguros pré-instalados. Muitos aplicativos que obviamente tem cara de que foram feitos nos anos 90. Claro que eu preferia que eles parassem de suportar e forçassem todo mundo a escrever em frameworks mais novos. Mas do tamanho que Windows já era no ano 2000 e o tamanho que é hoje, não seria realista. Ironicamente antigamente todo mundo só fazia apps pra Windows, mas hoje a Microsoft tem mais dificuldade em convencer desenvolvedores a fazer novos apps pra Windows. O Windows Store parece um deserto se comparado à Apple App Store. Mas dentro dessas restrições, eu diria que o Windows 10 está andando numa velocidade até razoável.





No caso do Mac, logo quando o OS X surgiu, eles fizeram três coisas muito importantes. Primeiro foi manter as parcerias originais. Trazer a Microsoft pra dentro pra eles fazerem uma versão do Office e do então Internet Explorer 5 foi muito importante. Com a demora da entrada da Adobe, a própria Apple se viu obrigada a cobrir o buraco. Primeiro com produtos da linha profissional como Final Cut e Logic Pro. Mas depois com o conceito de hub multimídia e os produtos da suíte iLife como iPhoto, iMovie e iDVD. Esses produtos ainda são bons hoje nas novas versões, mas naquela época eles eram imbatíveis. Sem exageros, muita gente comprava iMacs pra ter o iLife.




Muitos dos primeiros YouTubers aprenderam a lidar com multimídia via iMovie. No Windows tínhamos uma zona chamada Windows Movie Maker, um Windows Player que não decidia o que queria ser, se um jukebox ou um tocador. As tecnologias multimídia dos Mac sempre foram superiores. Nessa época os desktop managers do Linux também estavam babando pra interface Aqua dos novos OS X.



E isso foi outro fator que me interessava. Trazer o NextStep pra dentro da Apple como OS X trouxe outras tecnologias que ninguém mais tinha. Na década de 80 ex-funcionários da Apple fundaram a Adobe e inventaram o Postscript. Pense em Postscript como um HTML, com a intenção de possibilitar o famoso WYSIWYG ou What you see is what you get, ou seja, o que está aparecendo na tela ser igual o que vai aparecer quando mandar pra impressora. Isso foi revolucionário porque criou o mercado de desktop publishing.



Essa tecnologia evoluiria pra Display Postscript e depois Display PDF que virou o Quartz no OS X. O desktop manager do novo OS X, em vez de seguir a zona que é o X no mundo UNIX, foi criado do zero pra ser um monolítico que desenha todas as janelas de todos os programas como elementos de composição num PDF. Tudo que poderia ser acelerado via OpenGL em placa gráfica, que era novidade na época. Isso possibilita adicionar elementos de pós-produção, como transparências, sombras e animações fluidas. Em 2000 isso funcionava bem no iMacs, apesar de um pouco lento. Mas os processadores G3 da época conseguiam suportar.




Isso se pagaria poucos anos depois, quando processar esse tipo de coisa passou a ser barato pras novas placas gráficas. Eles tomaram a decisão de ser um pouco mais lentos no começo mas sabendo que em 1 ou 2 gerações estaria na velocidade correta, tanto por otimizações de software quanto pela própria evolução do hardware. Em 2000 qualquer um diria "isso é desnecessário". Eu acho que o fato deles estarem no fundo do poço e desesperadamente precisando se recuperar fez a Apple de 1998 tomar muitos riscos que nenhuma empresa tomaria hoje em dia.



Se você não sabe o que é compositing. Pense num sistema primitivo. Você tem janelas de vários programas. Eles vão sendo desenhados por cada programa numa certa área de um buffer, tipo uma matrix, que chamamos de frame buffer. Em 1/60 avos de tempo o sistema operacional pega o que está nesse buffer e manda pro monitor mostrar. Se eu mexo uma janela na frente da outra, as duas precisam redesenhar tudo. E pra ficar fazendo sombra de uma janela na frente da outra, 60 vezes por segundo, custa muito tempo. Em vez disso pense agora organizar uma nova abstração, tipo um canvas virtual, onde cada janela fica em layers e a janela de cima não sobrescreve a imagem da janela de baixo. E como num photoshop podemos ir aplicando efeitos como sombra num layer de cima e dinamicamente ele vai aplicar a sombra nos layers de baixo. Mas tudo isso feito via OpenGL na época, falando com a GPU, que foi feito pra aplicar efeitos em quadros muito rápido, o suficiente pra renderizar 60 quadros por segundo, e sem precisar que a CPU se meta. Com isso ganhamos animação fluida usando a GPU em vez da CPU. 



Fazer um desktop manager com compositing não é trivial, especialmente se você já tem um jeito legado de fazer e agora ter que mudar. A Apple teve a visão de implementar isso em 2000. Foi mais uma daquelas coisas que você não sabia que precisava até ter visto. Só que depois de ver as animações fluidas, sem engasgos, sem fritar sua CPU, você olhava pro seu Linux e Windows que ainda desenhavam do frame buffer direto pra tela via CPU, e não tinha como ter aqueles efeitos e animações sem fritar sua CPU que ia precisar processar 30 quadros por segundo pelo menos. 




Eles precisavam delegar isso pra GPU como a Apple estava fazendo. Mas levou até 2005 pra surgir o Compiz e Kwin no Linux, depois de muita experimentação, e mesmo assim ainda não 100%. E levou até 2007 pra lançar o Windows Vista com o mesmo sistema de compositing, que só ficaria completo e passou a ser obrigatório no Windows 8. Ou seja, na prática, nessa primeira década, só num Mac você tinha visuais agradáveis e lisos. Hoje em dia felizmente tanto os novos Linux quanto Windows 10 já usam sistemas de compositing e até High DPI que é pra monitores com alta densidade de pixels escalar os elementos da tela da forma correta, coisa que a Apple até hoje ainda é a única que faz 100% direito.




O que a Apple fez entre 2000 e 2009 nenhuma outra conseguiu fazer. Eles conseguiram rebootar o ecossistema inteiro, começar do zero com uma plataforma realmente à frente do seu tempo, criando um novo ecossistema consistente de ponta a ponta, incluindo ao lançar novos produtos como o iPhone que manteve a programação muito consistente mesmo que os binários fossem executar em arquiteturas tão diferentes quanto ARM e x86. 




Eles evoluíram o LLVM ao ponto de conseguir se desvincular do GCC como compilador, coisa que em Linux ainda não está 100%. E com isso mudar de linguagens de Objective-C pra Swift, sem perder compatibilidade binária. Como eles conseguiram manter uma API unificada com os frameworks Cocoa, fica muito mais fácil de manter as coisas. Do lado da Microsoft eles foram fazendo tentativa em cima de tentativa e cada tentativa errada foi gerando mais dependências que hoje estão todas acumuladas no Windows 10 ainda. A Apple foi cortando fora as coisas velhas. Por exemplo, o suporte a 32-bits no MacOS já acabou em 2017. No Windows isso ainda vai durar alguns bons anos porque tem milhões de pessoas ainda presas em máquinas velhas só de 32-bits.




Então dos anos 2000 até 2005 a Apple estava se recuperando, reconstruindo as fundações quase do zero. OS X novo, novos iMac e a sorte grande de terem conseguido fazer o iPod dar certo. De 2005 a 2007 eles tiveram o trabalho de migrar tudo de PowerPC pra Intel. E de 2009 a 2012 foi a consolidação graças ao boom do iPhone. De 2013 em diante foi sentar nos louros e seguir a receita.




Dos anos 2000 até 2010 o mundo PC ficou correndo atrás sem saber muito pra onde ir. Todo mundo foi afetado com o crash da bolha da internet em 2001. Mas com a presença da Apple tão claramente demonstrando porque tudo que eles faziam estava errado, demorou uma geração inteira até finalmente eles começarem a copiar e finalmente ultrapassar a Apple de novo. Em 2019 as diferenças são mais do tipo: a caixinha de som do Macbook ainda é melhor. O SSD da Apple realmente ainda é um pouco mais rápido. E a integração do sistema operacional com o hardware ainda é muito bom. Tirando isso, qualquer combinação de hardware PC com Windows ou Linux está praticamente igual pra todos os efeitos práticos.




A grande virada pra desenvolvedores eu acho que vai ser o lançamento do Windows Subsystem for Linux versão 2 daqui alguns meses. Eu estou usando hoje em versão alfa. Em resumo é uma máquina virtual Hyper-V mais leve do que o normal porque ele não vai precisar pré-reservar CPU ou RAM e parece que consegue gerenciar recursos sob demanda. Então o custo inicial é razoavelmente barato e com start rápido, especialmente pra rodar tudo em linha de comando. Então se você sobe Docker pra Windows hoje, que também usa Hyper-V por baixo, vai ficar melhor.




Na prática o Windows 10 com WSL2 vai se tornar um sistema operacional com duas cabeças. Mas a cabeça Linux ainda vai rodar isolado. No MacOS a fundação inteira foi trocada pra UNIX e ele vem colhendo os benefícios disso até hoje. Isso não vai acontecer no Windows, eu diria talvez nunca. Então rodar oficialmente virtualizado é a segunda melhor coisa. Por outro lado, como o MacOS é um UNIX não compatível com Linux, não tem como baixar um binário de Linux e rodar direto no Mac. Isso vai ser possível no WSL que é literalmente um kernel de Linux rodando virtualizado, então em termos práticos, o mundo Windows vai ter acesso a muito mais do mundo Linux do que o Mac tem hoje.




Graças à Apple hoje temos PCs e notebook muito melhores. São mais leves, construídos com materiais muito mais elegantes e sofisticados do que só plástico e ferro. A Apple introduziu alumínio ao mundo e todo mundo vem experimentando com novos materiais como magnésio ou fibra de carbono. Os fabricantes aprenderam que a gente paga mais pra não ter que ter plástico. Os componentes hoje funcionam muito melhor integrados. Os firmwares das placas mães ficaram mais inteligentes, PCI-express facilitou a vida de todo mundo. SSDs e RAM ficaram muito mais baratos e acessíveis. E até a porcaria da placa gráfica integrada da Intel já serve pra maioria das coisas que precisamos hoje como assistir Netflix em 4K.




Se você está começando agora deve ficar mesmo confuso porque desenvolvedores mais experientes como eu passaram por esses períodos que eu falei. Muito do que se fala mal de Windows hoje é porque a gente sofreu com Windows XP. Muito do que se fala bem dos Macs é a fase de ouro até o lançamento dos iPads. A mesma coisa dos Linux, muito desenvolvedor que hoje usa Mac não consegue se ver tendo que sofrer pra instalar e customizar um Linux até ficar agradável pra usar, mas naquela época a gente não tinha Elementary ou Deepin. E pra mim, eu tenho gostos superficiais e pra mim visual faz diferença, e não ter a opção de desktop managers com compositing fazia muita diferença. No Windows a gente teve que esperar até sei lá, depois de 2009 pro Aero funcionar de verdade quando o Windows 7 ficou mais estável. E levou do Windows 8 até o 10 pra nova linguagem de interface Metro finalmente começar a ser mais adotada. Ou seja, eu realmente não recomendava e ainda não recomendaria usar Vista, 7 ou 8. O Windows 10 é o primeiro Windows que demonstrou interesse em cortar coisas fora e gastar tempo limpando a casa em vez de só ficar adicionando inutilidades como aquela horrível barra de Charms. 




Eu disse que se você precisa desenvolver pra iOS, não tem o que escolher, você é obrigado a ter um Mac. Porém, não se preocupe em comprar os mais novos. Mesmo se você comprar um Macbook Pro usado de 2016 ainda vai funcionar razoavelmente bem. É muito difícil de justificar o custo de um Mac, especialmente com o dólar caro em relação ao Real. Mas a boa notícia é que hoje em dia comprar um bom PC não dá mais aquela sensação de estar escolhendo uma opção de segunda linha. Se você precisa desenvolver em .NET fique esperto, na prática, vai ser obrigado a usar Windows mesmo, mas dependendo do tipo de desenvolvimento, com o novo .NET Core você pode ter praticamente tudo que precisa num Linux e desenvolver com o Visual Studio Code. Caso você não saiba disso hoje é possível instalar SQL Server no Linux também e compilar e rodar programas .NET feitos em C# ou F# nativamente num Linux, é uma opção suportada depois que eles compraram a Xamarin. E com os frameworks da Xamarin ainda é possível fazer aplicações tanto pra iOS quanto pra Android, então existem várias opções ainda a serem exploradas no mundo Linux.



E por tudo isso, eu diria: se você tem dinheiro sobrando, na real tanto faz. Macbook Pro, Thinkpad X1 Extreme ou Carbon, Razer Blade, Asus Zephirus S, tem uma variedade muito boa. Se você for jogar ou criar conteúdo, escolha alguma com uma GTX topo da série 10 como as 1080 ou 1070 ou os mid-tier com 1660. Ou se quiser mesmo rasgar dinheiro, compra com as novas RTX série 20.



Se você não tem dinheiro sobrando, não se sinta mal em não estar comprando um Macbook. Procure os Dell Inspiron, Acer Switch, os HP Presario com Core i3 pelo menos. Antes pesquise no Google sobre a compatibilidade desses modelos com Linux. Escolha uma boa distro como um Ubuntu, Manjaro. E mesmo nessas máquinas dá pra ser criador de conteúdo, com um pouco mais de paciência, você consegue rodar Blender, Gimp, Kdenlive, Inkscape, Da Vince Resolve, Audacity e pra maioria dos casos você deve conseguir trabalhar normalmente.



Em 2016 meu objetivo de migrar pra Linux depois de mais de 10 anos usando Macs foi porque primeiro eu não tenho lealdade nenhum com a Apple. Não havia mais nada que me empolgava na Apple o suficiente pra ficar lá. E eu não ia ser aquele cara com Mac falando pras pessoas “usa lá Linux, dizem que funciona”. Eu só recomendo o que eu pessoalmente já usei como ferramenta primária por algum tempo, senão prefiro não recomendar. Eu não tenho lealdade com a Apple, também não tenho lealdade com a Microsoft e apesar de ter elogiado, ainda tá longe, mas bem longe do que eu gostaria que o Windows fosse. E também não sou ativista então nesse episódio longo veja que eu não disse nenhuma vez que você devia usar Linux por causa do aspecto de software livre. Estou sendo bem pragmático: do ponto de vista de produtividade, programação, gaming e criação de conteúdo, hoje em dia você tem PC antes de Mac e Windows e Linux antes de MacOS. Mas, mas, se você tem acesso a todas as opções, tanto faz na real.




E por hoje é isso aí, já fiz muito bikeshedding pra um episódio só. No final isso tudo foi um pouco uma desculpa pra eu contar alguns dos episódios da história da Apple que eu gosto, a migração do Mac Classic pro OS X, depois a migração de Power PC pra Intel. Acho uma pena que a Apple de hoje não se parece muito com a Apple daquela época, mas pelo lado bom, ainda bem que a Microsoft de hoje está muito melhor que a Microsoft daquela época. E como eu sempre digo: o mercado anda em ciclos. Espero que tenham gostado da história. Se ficaram com dúvida mande nos comentários abaixo, se curtiram mandem um joinha, assinem o canal, cliquem no sininho pra não perder os próximos episódios e continuem compartilhando com seus amigos pra ajudar o canal. A gente se vê semana que vem, até mais!

No episódio de hoje, pegando carona que eu fiz um vídeo sobre instalar ambiente de desenvolvimento em Ubuntu () eu queria aproveitar pra contar vários pequenos momentos e conceitos sobre sistemas operacionais que eu gosto de ficar discutindo.

No geral eu poderia dizer que é um vídeo “comparando” Linux, Mac e Windows mas a idéia não é escolher um no final mas sim delinear o que aconteceu nos últimos 20 e tantos anos que me fez ficar mudando de sistemas e hardware ao longo do tempo e porque existem algumas opiniões formadas hoje que quem está só começando não consegue entender porque as recomendações são extremas em muitos casos.

Antigamente a gente pedia “pelamor” pros desenvolvedores darem uma chance pros Macs. Hoje em dia o povo não entende porque tem tanta gente ainda recomendando Macs tão veementemente. E no fim, qual é a melhor escolha pra desenvolvedores de software? Vamos descobrir isso hoje.
