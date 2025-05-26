---
title: "[Akitando] #128 - Entendendo Pacotes com Slackware | Deb, Apt, Tarbals"
date: '2022-09-25T12:49:00-03:00'
slug: akitando-128-entendendo-pacotes-com-slackware-deb-apt-tarbals
tags:
- slackware
- linux
- apt
- debian
- tarball
- cfdisk
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/iQkBbRPkASo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Como gerenciadores de pacotes como APT funcionam? O que tem num pacote? Vamos instalar um Slackware, uma das distros de Linux mais antigas, e ver como evoluímos de gerenciar tarballs pra gerenciar resolução de dependências com pacotes modernos como formato DEB.

Hoje você vai começar a entender como software num Linux é organizado de verdade.


== Conteúdo

* 00:00 - Intro
* 01:21 - CAP 1 - Como nós, reviewers, trapaceamos
* 04:15 - CAP 2 - Instalação como nos Anos 90: Slackware
* 06:24 - CAP 3 - Particionando o Drive: CFDISK
* 10:32 - CAP 4 - Filesystems e Mount Points
* 16:36 - CAP 5 - Como APT instala pacotes? Formato DEB
* 25:14 - CAP 6 - Formato de Pacotes Original: pacotes no Slackware
* 31:57 - CAP 7 - Mantenedores de Distros = Mantenedores de Pacotes Binários: SlackBuilds.org
* 40:31 - CAP 8 - Slackware nos dias de hoje: Nostalgia
* 43:02 - Bloopers

== Links

* Build & Install Slackware Packages Automatically (https://medium.com/netdef/build-install-slackware-packages-automatically-b2986d2f86f9)
* SlackBuilds.org (https://slackbuilds.org/)
* SBOPKG (https://sbopkg.org/)

## SCRIPT

Olá pessoal, Fabio Akita

Vamos continuar a minissérie de Linux falando mais sobre o que tem por baixo do capô. No video anterior vimos um pouco sobre como é a sequência de boot, desde ligar o computador até chegar na tela de login. E hoje quero apresentar mais conceitos de Linux destacando alguns trechos da instalação da distribuição Linux mais antiga ainda em funcionamento hoje: o lendário Slackware. Vamos lá.


(...)




Eu vinha dizendo em redes sociais e até alguns videos anteriores que eu recomendo Arch Linux pra você começar a aprender um pouco mais sobre como Linux funciona. Tanto porque a instalação de um Arch é menos fácil que de um Ubuntu ou Fedora, mas também porque o Wiki do Arch é uma das documentações online mais completa sobre todos os aspectos de um Linux.





Distros modernas como Ubuntu, PopOS, Mint e coisas assim são hiper triviais de instalar, graças a LiveCDs e instalador gráfico como Calamares, que já fazem o grosso do trabalho pra você. Mas mesmo o Arch não é tão complicado assim e na verdade ele já esconde muito da complexidade. Portanto, instalar Linux moderno hoje em dia não ensina quase nada, a menos que seu hardware seja muito exótico e tenha pouco suporte, daí você vai ser obrigado a descer mais fundo nas suas pesquisas até conseguir fazer tudo funcionar. 







Canais de reviews também trapaceiam um pouco, e eu vou fazer a mesma coisa. A coisa mais chata na instalação de qualquer sistema operacional, seja Windows ou qualquer distro Linux, é suporte a hardware porcaria que não tem drivers bons disponíveis. Dispositivos de marcas chinesas duvidosas compradas numa Shopee ou AliExpress, webcam baratinha que, quando você conecta, seu sistema nem detecta automaticamente e coisas assim. O maior problema em qualquer sistema operacional é ter bons drivers que desestabilizem tudo.






Mas a trapaça que eu falo é que a gente que grava video, não vai ficar testando instalação em vários tipos diferentes de combinações de hardware. Normalmente temos uma máquina separada só pra isso que não é nosso PC primário. Claro, sem nenhum componente muito exótico, que a maioria dos instaladores vai auto detectar de primeira sem problema. Ou vamos usar máquinas virtuais. E a vantagem de usar um VirtualBox, VMWare, QEMU/KVM é que o hardware virtual dessas máquinas é bem documentado e tem bons drivers disponíveis. Qualquer instalador de Linux detecta que tá numa máquina virtual e instala os corretos sem nenhum problema. Por isso que você assiste video de canal de YouTube e parece que foi tão fácil.








Entenda que hoje em dia, mesmo Windows, até que funciona direitinho. Quando você tem problemas, normalmente são drivers ruins, ou atualização automática que baixou uma versão nova de driver com bugs. Campeão de bugs são drivers de placas de video como NVIDIA. Saem atualizações com bastante frequência, são pacotes grandes, e vira e mexe chega um bug novo que te fode. Gamers sabem bem o que é isso. E por isso também notebooks de boas marcas costumam ter poucos problemas, porque os fabricantes tendem a arredondar bem os drivers dos componentes da máquina, e fazem pouca ou nenhuma atualização depois que tudo já funciona. 







Aí você só vai ter problema se o sistema operacional ganhar um upgrade que quebra compatibilidade com seus drivers. Mas no fim, o problema sempre são drivers. Por isso sempre pesquise se todos os componentes que você compra costuma ter drivers disponíveis que são atualizados com uma frequência razoável pra corrigir bugs. Se você tá pesquisando, digamos, uma placa de captura de video, vai no site deles. Se descobrir que a última vez que eles lançaram um driver novo foi uns 3 anos atrás, desiste dessa compra.






Isso tudo dito, eu já tinha mostrado no video anterior uma instalação rápida de Ubuntu numa máquina virtual, e em poucos minutos tava tudo detectado e instalado. Zero problemas. Por isso quero instalar um Slackware hoje. Slackware foi a primeira distro que eu tentei instalar, lá por volta de 1995, acho que ainda era 1.0, que vinha num CD junto com um livro importado ensinando sobre Linux. Eu acho que na época não consegui instalar e foi super frustrante, eu só voltei a tentar Linux de novo quando um amigo da faculdade me emprestou um Red Hat versão 4, com um instalador um pouco menos difícil e consegui ir até subir o X pela primeira vez.






Se você só instalou Linux modernos, hoje vai ter um choque, porque o Slackware moderno ainda é muito parecido com o que eu lembro de mais de 20 anos atrás. E como disclaimer, o video de hoje não é um tutorial. Não dá pra seguir passo a passo. Quero aproveitar a instalação pra ir destacando alguns conceitos que acho importante saber. Então vamos bootar o Slackware numa máquina virtual, e logo de cara você já vai tomar um susto. Não abre interface gráfica, cai direto numa linha de comando. E sim, LEIA a porra dos textos que aparecem. 90% dos erros de iniciantes é ser preguiçoso e não ler com atenção o que tá escrito. Se alguma coisa escreve na sua tela é porque você deveria ler.







Pessoal pensa que LiveCDs que são esses Linux que bootam de pendrive servem só pra instalar a distro no seu HD. Mas na realidade, todo LiveCD tem uma segunda utilidade: ser usado pra conseguir recuperar o Linux do seu PC caso faça alguma bobagem e não consiga mais bootar dele. Essa máquina virtual, por exemplo, tá vazia, mas já estamos dentro de um ambiente Linux. Como ele explica aqui no texto, daqui você pode montar o HD da sua máquina que já tinha uma instalação e no mínimo ter acesso aos seus arquivos, caso não esteja conseguindo bootar normalmente. Aqui ele ensina como fazer isso.









Damos enter e olha o que expliquei no episódio anterior: executa o binariozão da kernel do Linux, cria uma partição em RAM que é o initramfs e descomprime a imagem initrd nela pra fazer o segundo estágio do boot. Aí a kernel executa um gerenciador de serviços, um init system, que é processo número 1 que vai iniciar os serviços do runlevel certo. Lembram? Expliquei tudo isso no video anterior. E quando terminar o boot, vai perguntar se quer trocar o layout do seu teclado, caso esteja usando um layout brasileiro, por exemplo.








Como é um LiveCD, tem só o usuário root sem senha e de novo, leia a porra do texto, porque já te dá a dica que o próximo passo pra continuar é que vai precisar criar uma partição e formatar antes de conseguir instalar qualquer coisa. E uma coisa que imagino que ninguém vai ter é problema de pouca memória, mas digamos que seu PC seja tão velho que tenha menos de 4 gigas de RAM, daí ele recomenda também criar uma partição de swap. E vamos fazer as duas coisas agora.






Pra criar partições, nos anos 90 eu seria obrigado a usar a antiga ferramenta `fdisk`. Era horrível, porque precisava calcular manualmente a quantidade de megas baseado na multiplicação de coisas como tamanho de setor, cilindros, cabeças, coisas que expliquei no video sobre partições. Mas hoje em dia temos uma ferramenta melhor, o bom e velho `cfdisk`. A opção mais padrão agora é escolher a etiqueta de GPT, que também explico no video que falei.








Normalmente um Linux dá o nome de "/dev/sda" pro primeiro HD que detecta. Se tiver um segundo HD o nome seria "/dev/sdb". No caso temos 80 giga de espaço livre e vamos criar a primeira partição que vai se chamar "/dev/sda1". Com setinhas, mudo os itens de menu abaixo, escolho "new" e digito que tamanho quero que essa partição tenha. Posso digitar "100M", onde "M" quer dizer "megabytes". Essa vai ser a partição de boot. 100 mega acho que chutei pouco, poderia ser mais. Pra estar seguro, digita uns 150 megas num PC de verdade. 







Daí no menu embaixo, movo pra direita pra escolher a opção de "tipo" e mudo pra "EFI System". Tá vendo? Se você assistiu meus videos sobre armazenamento, tudo isso de fdisk, partição, tipos, EFI, já expliquei tudo antes. Agora eu movo a setinha pra baixo pra escolher o resto do espaço livre, escolho a opção de nova partição, e chuto uns 4G, onde "G" significa "gigabytes". Essa vai ser a partição "sda2", daí mudo o tipo pra ser Linux Swap. Não existe tamanho certo pra essa partição. Se tem bastante RAM, um swap pequeno só pra emergência tá bom. Se tem pouca RAM, recomendo comprar mais RAM. Pouca RAM é abaixo de 8 giga. Um swap de 4 giga ou menos tá de bom tamanho. 








Finalmente, selecionamos o espaço que sobrou e criamos a maior partição, que aqui vai ser a "sda3" com mais de 70G e escolhemos o tipo de "Linux filesystem". Esses tipos são só etiquetas. Elas não mudam nada, é que nem uma hashtag de twitter. Só pra depois ficar mais fácil saber o que é cada partição. E notem como a ordem dessas partições não faz diferença. Só a partição de boot que é bom ser a primeira, mas eu poderia ter invertido e deixado a principal como "sda2" e o swap como "sda3". Poderia ter criado uma quarta partição pra ser onde ficaria meu diretório home, pra facilitar coisas como backup e recuperação depois. Tem várias estratégias, mas o que fiz agora é o hello world, o mais simples. A maioria dos instaladores gráficos, por baixo dos panos, faz a mesma coisa sem você saber.










Partição é só uma forma de deixar gravado nos primeiros bytes do HD que do byte X até o byte Y está reservado pra partição 1, do byte Y até o byte Z é a partição 2, e assim por diante. É só isso. Mas pra usar essas partições, o sistema operacional precisa saber que formato é pra usar dentro dela, e pra isso que formatamos. E em linux, cada sistema de arquivos tem uma ferramenta "mkfs" que é literalmente "make filesystem", por exemplo, vamos formatar a primeira partição de boot "sda1" como FAT32 com o comando `mkfs.fat -F 32 /dev/sda1`. Pronto, apesar desses avisos, não deu erro e agora tá formatado. 








A segunda partição "sda2" é o swap. Lembram? Swap é usado quando tamos ficando com pouca memória RAM, daí o Linux passa a mapear parte do disco como memória adicional pra não crashear tudo. Só que HD é sempre MUITO mais lento que RAM, por isso um bom sistema operacional como Linux só vai usar swap se realmente precisar muito. Swap só vale a pena se estiver usando um SSD NVME, que é rápido o suficiente pra não deixar sua máquina muito lenta. De qualquer forma, precisamos formatar essa partição com um sistema de arquivos especial que vai simular memória, e pra isso usamos o comando `mkswap /dev/sda2` que é literalmente "make swap".







Mas não basta formatar, temos que dizer pro sistema que é pra usar como swap e pra isso tem o comando `swapon /dev/sda2`, que é literalmente "swap on", de ligar. Se quisermos desligar pro sistema não usar mais essa partição tem o comando oposto que é `swapfoff`. E pronto, temos swap configurado. Finalmente, vamos formatar a partição principal que é onde o Slackware vai se instalar e onde vai ficar os arquivos do sistema. A opção padrão mais fácil é formatar em ext4.








Se for um notebook, recomendo antes encriptar a partição com LUKS e dentro criar um volume formatado com ext4 ou usar um sistema de arquivos mais moderno como btrfs ou ZFS que começou a vir nos Ubuntu a partir da versão 19 ou 20. Vou falar um pouco mais sobre isso em outro video. Mas na dúvida, escolha ext4 que é o filesystem mais usado no mundo Linux e todo ferramental que vem em todas as distros já assume que está usando ext4. De novo, se nunca ouviu falar de ext4, btrfs, zfs, fat, é porque não assistiu meu video sobre sistemas de arquivos. Anota aí pra assistir depois.








Pronto, agora o HD foi particionado, e cada partição foi formatada com sistemas de arquivos que um Linux entende. Agora precisamos dar acesso a essas partições. E a forma de fazer isso é criando um mount point. Vou falar mais de mount points no próximo video, mas por hoje entenda o seguinte. Um "/dev/sda3" é só o caminho pra um linguição de bits. O sistema não entende arquivos e diretórios, só entende ler blocos de bits e gravar blocos de bits. Lembra o que eu sempre falo? Um dispositivo de armazenamento é um block device, um dispositivo de blocos. O sistema operacional precisa carregar um intérprete pra traduzir conjuntos de blocos em arquivos. Esse é o papel de um sistema de arquivos como ext4.








E pra carregar esse intérprete, fazemos um ponto de montagem. Um mount point é só um diretório onde digo: a partir deste diretório, interprete os blocos do dispositivo como uma árvore de diretórios. Use o formato ext4 pra ler e gravar diretórios e arquivos. Então podemos usar o comando `mount /dev/sda3 /mnt`. Tá implícito aqui, mas o comando mais completo seria `mount -t ext4 /dev/sda3 /mnt`. De qualquer forma, a partir de "/mnt" é a raíz da partição sda3.








A partir daqui, tudo que gravar em "/mnt" na realidade vai gravar dentro da partição sda3. E dentro crio o diretório "/boot/efi", onde vou montar a primeira partição de boot, o sda1 com `mount /dev/sda1 /mnt/boot/efi`. Isso realmente não teria como você saber de cabeça se nunca configurou EFI. E, de novo, se não sabe a diferença de BIOS e EFI, de MBR e GPT, é porque não assistiu meu outro video sobre isso. Mas saiba que toda instalação automática de Linux tá criando esses mount points por baixo dos panos pra você. Só que o Slackware me obriga a fazer isso manualmente.








Sendo honesto, eu não precisava ter formatado as partições na linha de comando com os comandos de "mkfs". O Slackware tem um instalador rudimentar que sabe fazer essas coisas. Mas eu quis mostrar como é manualmente. Apesar que partição de boot EFI você ia ter que fazer na mão de qualquer jeito porque o instalador do Slackware não configura isso, então não fizemos nada muito extra. Mas agora podemos digitar `setup` e vai abrir esse menu de opções. Na opção TARGET, olha só, detectou minhas partições e sabe que "sda2" é o swap porque no cfdisk demos o tipo de "linux swap", lembra? Daí ele se oferece pra fazer o mkswap e swapon, mas como já fizemos isso antes, só dar "não" pra continuar.







Agora ele achou a partição principal "sda3" e diz que vai usar pra ser o mount point "/" que é a raíz do sistema de arquivos, o diretório "/" principal. Se tivesse feito outras partições, aqui poderia escolher pra montar como "/home", por exemplo. O que essa ferramenta tá fazendo é preparando o arquivo "/etc/fstab", que é como o sistema init no boot sabe como montar as partições do seu HD automaticamente. De novo, ele se oferece pra formatar essa partição, mas como já fizemos isso, damos "no" de novo.






Depois de ter as partições devidamente configuradas é hora de copiar os arquivos do sistema pra lá. A primeira opção é justamente copiar tudo a partir do seu pendrive que usou pra bootar, ou no caso da minha máquina virtual, direto a partir do arquivo de ISO que baixamos. Mas de curiosidade veja essas outras opções aqui embaixo. Ele tem opção de instalar a partir de um diretório compartilhado na rede ou via servidor de arquivos FTP. Quem é dos anos 90 vai se lembrar disso, porque nos anos 90 não ia ter como dar boot via pendrive como fazemos hoje. Pendrive nem existia ainda. 







Normalmente ia ter 2 disquetes ou floppy disks de 1.44 megabytes cada. Um era o disco de boot, que carrega a kernel e o segundo era o disco de root, que acho que é onde tinha o initrd e as ferramentas de instalação. Daí precisava ter o resto dos pacotes num CD ou DVD. Veja o tamanho deste arquivo de ISO, mais de 3 gigabytes. Um CD na época tinha menos de 700 megabytes, então esse Slackware ia precisar de mais de 4 CDs pra instalar completo.







Lá pelo meio dos anos 90, DVD também não era acessível. Então íamos precisar de 2 disquetes, mais uns 4 CDs. Mas se estivéssemos numa boa faculdade ou empresa moderna, talvez tivesse os pacotes num servidor FTP. Daí dava pra instalar pela rede em vez de ter que ficar trocando CD. A gente que curtia Linux tinha tubos com dezenas de CDs. E CD é lento, levava horas pra instalar. Por isso eu falo que hoje tá fácil. Em menos de 1 hora dá pra sair do zero pra um Linux todo configurado e funcionando. Bons tempos.









Enfim, agora é só ir escolhendo as opções padrão, que é basicamente não ficar tirando nada e deixar o Slackware instalar tudo completo. O objetivo todo de instalar Slackware foi justamente pra falar um pouco sobre os primórdios do que chamamos de pacotes. Olha só o instalador, ele tá nervoso instalando um pacote atrás do outro, mas o que diabos é isso de pacote? Vamos fazer uma tangente.







Se você é programador e já usou um Ubuntu da vida, deve estar acostumado a copiar e colar comandos como `apt install docker`, acender uma vela, e torcer pra não dar nenhum erro, porque você não tem idéia do que fazer se der erro. Se estiver num Fedora, já deve ter digitado `dnf install docker`, se estiver num openSuse, digita `zypper install docker`, ou se estiver num Arch Linux vai ser `yay -S docker`. Apt, Dnf, Zypper, Yay, Pacman, Portage, Apk, são o que chamamos de "gerenciadores de pacotes", justamente porque eles sabem como baixar e instalar ou desinstalar os softwares que vem dentro desses pacotes. Cada distro diferente costuma ter gerenciadores diferentes.







Slackware vem de uma época que precede o conceito de gerenciar pacotes. Vamos entender pacotes primeiro. Enquanto o Slackware fica ali instalando pacotes, vamos abrir outra máquina virtual com o Ubuntu 22 que mostrei no episódio anterior. Eu tenho instalado aqui um programa que todo programador já deve ter visto, o htop. Olha só ele mostra informações do sistema, quanto de carga cada core da minha CPU tá puxando, quanto de memória tá sobrando, e embaixo uma lista com todos os processos rodando na máquina, quanto de recursos cada um tá usando. É uma excelente ferramenta de monitoramento pra você saber o que tá acontecendo na sua máquina.









Onde fica o binário executável do htop? Do terminal podemos usar o comando `which htop`, que vai vasculhar os PATHs que tão configurados no seu shell e ele acha o binário em `/usr/bin/htop`. Se não tivesse essa variável PATH configurada, precisaria digitar o caminho completo `/usr/bin/htop` pra executar. O PATH é uma conveniência pra facilitar nossa vida na hora de digitar comandos. Enfim, o htop não tá todo contido nesse binário. Ele tem dependência com outros objetos binários, bibliotecas instaladas no sistema. A gente pode saber quais são usando o comando `ldd /usr/bin/htop` e olha só, ele depende desse objeto binário libtinfo.so.6, a mais comum em todos os binários que é a libc ou libc.so.6 e assim por diante.









Vamos estragar o htop. Deixa eu mover o libncursesw.so.6 pro diretório /tmp e tentar executar o htop ... e olha só, reclama que não consegue localizar a biblioteca compartilhada libcurses e crasheia. Então vamos mover o ncurses de volta pro lugar com o comando `mv` inverso ... e pronto, agora o htop consegue carregar como antes. Mas o exercício aqui foi pra vocês terem noção que um executável tem o que chamamos de dependências. E resolução de dependências é um problema recorrente que vai acompanhar sua vida inteira de programador. Quanto mais cedo entender sobre isso, melhor.









Agora, como instalar um software como htop? Simples, vai no terminal e digita `sudo apt install htop` e pronto. Mas você sabe o que tá acontecendo? Já parou pra pensar nisso? Como esse comando `apt` sabe de onde baixar e o que instalar no seu sistema? Deixa eu dar um resuminho. No caso de todo derivado de Debian, como um PopOS ou este Ubuntu, tudo começa no arquivo "/etc/apt/sources.list", vamos dar `cat` pra ver o conteúdo. E temos uma lista com várias URLs. Ele já foi inteligente pra deixar pré-configurado domínios brasileiros, que são servidores espelho, ou seja, cópias dos servidores oficiais da Canonical, que ficam aqui no Brasil, pra ser mais rápido fazer download.









Quando você executa aquele comando que parece que não faz nada, o `apt update`, o que ele faz é baixar um zip de um desses servidores listados. Esse zip é um arquivo texto com a lista de todos os pacotes oficialmente suportados pela Canonical. O que faz um programador bom de verdade? Ele é curioso, se tem uma URL, a gente abre. Vamos abrir aqui essa primeira URL e carrega uma página com diretórios. Agora navegamos aqui em dists, que acho que é distribuições. E dentro temos os codenomes das distros de Ubuntu. Como mostra aqui no arquivo sources.list ele declara pra procurar o codenome "jammy". Sabemos que Jammy Jellyfish é o codenome do Ubuntu 22.







Dentro temos o diretório "main", depois "binary-amd64", que são binários de 64-bits compatíveis com AMD ou Intel, então escolhemos ele e finalmente achamos um arquivo suspeito de 1.7 mega chamado "Packages.gz". Vamos baixar. "gz" é a extensão de um arquivo compactado com "gzip", então vamos pro terminal e fazemos `gunzip Packages.gz` e bingo, descompacta um arquivo de 6 mega que podemos abrir num editor de textos como meu vim.







Agora vamos procurar o htop que queremos, não é esse, não é esse outro, ah, achamos, olha só esse trecho. Várias informações sobre o htop, mas o que nos interessa é esse "Filename" aqui embaixo, que é o caminho pro pacote htop bla bla ponto deb. Mas onde fica esse diretório "pool"? Acho que já vi antes. Vamos voltando algumas páginas. Aha, olha só, tá aqui nesse servidor mesmo. A gente foi no "dists" lá em cima, mas tem esse "pool" aqui embaixo. Então vamos copiar a URL do servidor e ir pro terminal. Podemos usar a ferramenta `wget` pra facilitar, colando o endereço do servidor e copiando e colando esse caminho poll etc pro arquivo deb.








Pronto, baixamos o pacote do htop. Mas o que diabos é um arquivo ponto deb? Não é a mesma coisa mas é como se fosse um arquivo zip. Só que em vez de usar o comando "gzip" o padrão pra deb é usar o comando "ar", que literalmente significa "archive". Vamos fazer `ar x htop bla bla ponto deb`. Opção "x" significa extract. Olha só o que abriu, apareceu arquivos "debian-library" mas mais importante, temos esse "control.tar.zst" e "data.tar.zst". Tar eu já expliquei no video de Ubuntu, é o comando de Tape Archive, que foi criado na época que se usava fitas magnéticas pra gravar arquivos.







Em resumo, o tar serve pra concatenar arquivos um atrás do outro num único linguição de bits, um único arquivão, pra mandar pra fita. É que nem um zip, mas sem necessariamente compactar. Mas nesse caso ele tá compactado, e de novo, não é um zip e sim um zstd. Se nunca ouviu falar, zstd é mais uma alternativa a gzip. Por ser mais moderno, usa algoritmos mais refinados de compressão e faz arquivos menores que gzip e é mais performático. Perfeito pra um gerenciador de pacotes.







Podemos descompactar fazendo `tar -I unzstd -xvf control.tar.zst` e bingo, ganhamos um arquivo chamado "control". Podemos ver o conteúdo com o comando `cat` e olha só? Parece familiar? Sim, é exatamente o que tinha naquele arquivo Packages que baixamos antes. O arquivo Packages é montado automaticamente com o conteúdo desse arquivo control dos vários pacotes da distro. Agora descompactamos o outro arquivo com `tar -I unzstd -xvf data.tar.zst`. Esse é o arquivo que vai ter o binário executável do htop e outros arquivos que depende. Olha só, surgiu um diretório "usr" e vasculhando vemos que em "usr/bin" temos o binário do "htop".









De curiosidade, naquele arquivo de control, veio também um arquivo chamado "md5sum", vamos ver dentro. É uma lista de hashes md5 dos arquivos que tava no data.tar. Vamos checar? Só rodar `md5sum usr/bin/htop` e pronto, é exatamente o mesmo hash. Isso garante que o binário que temos aqui não foi corrompido nesse processo todo de download, descompressão. Lembra do episódio sobre detecção e correção de erros? Poderia ter um raio cósmico que flipou um bit, ou o meu HD poderia estar velho e falhado na hora de gravar um bit. Com essa checagem podemos garantir que o binário que está no meu disco tem 100% dos seus bits intactos.








Mas note uma coisa. Lembra que quando apagamos a biblioteca libncurses o htop não funciona? Cadê essa biblioteca? Não aparece nessa lista, se listamos os sub-diretórios que descomprimimos do data.tar, não existe "lib", só "usr". E é pra isso que serve aquele arquivo "control". Vamos listar o conteúdo dele de novo e olhar com mais calma. Olha só como tem um item chamado "Depends". Aqui mostra quais outros pacotes precisam ser instalados juntos e quais versões mínimas. Por baixo dos panos o comando `apt` vai também fazer esse mesmo processo que fizemos manualmente pra todos esses outros pacotes.








Se o apt não fosse inteligente pra fazer resolução dessas dependências, precisaríamos fazer na mão um comando bem maior, por exemplo `apt install htop libc6 libncursesw6 libnl-3-200, libnl-gen-3-200 libtinfo6`, mas como o apt sabe encontrar essa lista de dependências dentro do arquivo de "control", dentro do pacote deb do htop, já instala automaticamente pra gente. A única coisa que resta é copiar os arquivos dentro desse diretório "usr" pra cima do diretório "/usr" do nosso HD, e é assim que o binário vai parar em "/usr/bin/htop".







Em resumo bem resumido, essa é a anatomia de um pacote deb de Ubuntu. Um arquivão que dentro tem dois outros arquivões. Um é o data.tar que tem os binários do software. O outro é o control.tar que são metadados, informações como a descrição do software, autores, mantenedores, e dependências de outros pacotes. Num Fedora se usa pacotes em outro formato, o RPM que significa "Red Hat Package Manager" e foi criado na época das distros comerciais da Red Hat. Hoje o formato RPM ainda é usado pelo CentOS, Fedora, openSuse. As distros Arch Linux como Manjaro ou Garuda usam o formato PKG de pacote. E agora vamos voltar a falar do Slackware, que pacotes ele usa?







Na realidade, o Slackware original não usa nenhum formato especial de pacotes. Deixa eu mostrar o jeito antigo, o jeito padrão e o jeito moderno de instalar software num Slackware. Primeiro, vamos ver como anda a instalação. Olha só, ainda tá instalando como se não houvesse amanhã, é pacote pra caramba. O Slackware é disparado a instalação que mais ocupa espaço em disco comparado com qualquer outro. Quando terminar de instalar e baixar as atualizações todas, vai ocupar quase 20 gigabytes no disco.







Em comparação, o Ubuntu que instalei na versão mínima, sem softwares tipo Office, ocupa menos de 4 gigabytes. Mesmo se instalar os softwares opcionais, uma distro tipo Ubuntu ou Manjaro vai ocupar menos de 10 gigas, menos da metade do Slackware completo. E porque o Slack ocupa tanto espaço? Porque a filosofia é a seguinte: pra que ter uma ferramenta complicada tipo Apt ou Pacman pra ficar resolvendo dependências? Basta já ter tudo pré-instalado, todas as bibliotecas como aquela libncurses que o htop precisava, daí quando for instalar o htop, já vai ter o que precisa e não tem que se preocupar. E mesmo se não tiver tudo, dá pra instalar manualmente o pouco que falta.








Alguém poderia dizer "porra, quer dizer que vai desperdiçar mais de 10 giga de coisas que talvez nem use?". Sim, vai mesmo. Se fosse uns 10 anos ou mais pra trás, essa reclamação teria mais peso, mas hoje em dia, 10 gigas a mais, 10 gigas a menos, meio que não faz diferença nenhuma. Com menos de 200 reais você compra um SSD barato de 240 gigabytes. Estamos literalmente falando de 10 real a mais ou 10 real a menos. Literalmente não faz diferença.






Especialmente se considerar que qualquer jogo Triple A no Steam, como um Red Dead Redemption 2 ou GTA 5 ocupam mais de 100 gigabytes. O remaster do Spider-man que saiu faz pouco tempo, um God of War ou Cyberpunk 2077 custam mais de 60 gigabytes cada. O que é 10 gigas a mais do Slackware? Nada. Merreca. Então, o argumento de desperdiçar espaço, em 2022, meio que tanto faz.







O problema é que mesmo tendo um monte de pacotes já pré-instalados, isso ainda não resolve o problema de dependências. A partir daqui vou adaptar o exemplo de um blog post que esbarrei 2 anos atrás. Vou deixar o link na descrição abaixo pra referência. O exercício é instalar a biblioteca "jq", que é um processador de JSON de linha de comando. Quem mexe com APIs provavelmente já usou essa ferramenta, e se não usou, recomendo pesquisar depois.







Mas vamos lá, digamos que estamos nos anos 90, quando o conceito de gerenciador de pacotes ainda não era comum. Não temos APT nem Pacman nem nada disso. Não temos repositórios pra baixar pacotes. Como fazemos? Primeiro, procuramos o repositório de código. Antigamente estaria em sites como Sourceforge.net, hoje em dia provavelmente vai estar num GitHub. E de fato, aqui está a página. Agora vamos no link de releases e baixamos o tarball, que é o arquivo tar compactado com gzip do código fonte. Esse é o jeito antigo, nem existia Git nos anos 90, por isso não vamos usar Git.








Vamos pro terminal, diretório de downloads e fazemos o bom e velho `tar xvfz jq.tar.gz`. Entramos no diretório e olha só, temos o código fonte completo dessa ferramenta. E quem é das antigas já sabe o que tem que fazer. Rodar o bom e velho `./configure`. Todo código fonte de C costuma vir com um script executável chamado "configure", que vai checar se temos todas as dependências de compilação nos lugares certos e gerar um arquivo de "Makefile" que rodamos com o comando "make" pra realmente pegar todo o código fonte, usar o compilador GCC e gerar o binário. Veja que o configure vai checando e em toda linha vai dizendo "yes", "yes", pra reportar que tá tudo ok. É isso que esperamos ver.








Mas antes do fim, erro. Fala que não achou o Oniguruma. Quem é experiente conhece o Oniguruma, que é uma biblioteca de Regex. Vamos listar o que tem nesse "modules/oniguruma" e, por coincidência, o autor desse projeto foi legal e já deixou copiado o código fonte do Oniguruma nesse diretório. Se não tivesse feito isso eu precisaria ir caçar o repositório do Oniguruma, baixar o tarball e descompactar aqui. Mas o erro aconteceu porque ele não achou o script de configure atualizado lá. E isso porque eu não li a documentação do README, como deveria. Se tivesse lido ia ver que o autor me manda rodar o comando `autoreconf` ANTES de rodar o `./configure`.








Autoreconf vai rodar outras ferramentas por baixo como autoconf, autoheader e mais. Quem é desenvolvedor de C e C++ conhece isso. Autoreconf vai gerar o script atualizado de configure. Então vamos rodar `autoreconf -fi` como manda. E agora sim, repetimos o `./configure`. Esperamos um pouquinho e pronto: agora sim, terminou sem problema. Significa que nosso Makefile tá pronto, então é só rodar o comando `make`. Pra quem é de Ruby o make é o avô de `rake`. Pra quem é de Javascript rodar make é tipo rodar `npm build` ou `yarn`. É um executador de tarefas. Ele vai automatizar rodar o GCC pra cada arquivo de código fonte C, depois pegar os objetos binário e linkeditar num binariozão executável.








E pronto, terminou de compilar. Se listarmos os arquivos, olha aqui o binário "jq". Pra terminar de instalar precisa copiar esse binário pra um diretório do sistema como "/usr/local/bin". Mas não precisa fazer manualmente, no Makefile tem uma tarefa chamada "install" justamente pra isso. Como precisa instalar em diretórios do sistema, o certo seria rodar com `sudo`, mas como é só um exemplo, eu não quero instalar de verdade. Vamos rodar `make install` sem sudo e olha só, dá erro, claro, porque não tem permissão pra copiar arquivos pra diretórios como "/usr/local/lib". Ele tentou copiar a libonig que é a biblioteca do oniguruma que foi compilado junto. 







Se executasse com `sudo`, iria copiar o libonig.so.4.0.0 pro /usr/local/lib e no final o jq pra /usr/local/bin. E pronto, finalizado. Era assim que a gente instalava software antigamente. Baixava o tarball com o código fonte, rodava direto `./configure` ou `autoreconf` antes pra gerar o script de configure. Checava se faltava alguma dependência. Caçava a dependência, baixava o tarball dele, e ia fazendo assim na munheca. Roda `./configure`. Compila tudo com `make`, instala os binários com `sudo make install`.








Antigamente isso de compilar tudo a partir do código fonte era mais necessário porque além de Intel x86 tinha vários tipos de CPUs diferentes. Tinha chips RISC Power da IBM. Chips Sparc de workstations Sun. PA-RISC da HP. DEC, Motorola. Fora a transição de 32-bits pra 64-bits. Como a comunidade de Linux era pequena, não tinha como ficar mantendo binários especializados de todas as versões pra todos esses chips. Era mais fácil fornecer o código fonte, todo mundo tinha compilador GCC, então cada um compilava o binário pra sua arquitetura de CPU.








Mas felizmente a gente evoluiu. Empresas como Red Hat apareceram e começaram a manter servidores com repositórios de binários já pré-compilados. E em vez de baixar código fonte, a gente passou a baixar pacotes RPM direto com os binários. Melhor ainda, como tinha um gerenciador de pacotes como o antigo Yum, dava pra manter um banco de dados com todos os pacotes instalados. Se quisesse desinstalar, tinha o manifesto com os arquivos de cada software, era só automatizar apagar. Por exemplo, pra apagar esse "jq" que acabamos de tentar instalar, antigamente, tinha que manualmente apagar o "/usr/local/bin/jq" e lembrar que também copiou arquivos "libonig*" em "/usr/local/lib", e apagar manualmente. Sempre ficava coisa sobrando.









Hoje em dia, todo novo software povo já deixa preparado pra gerar pacotes como RPM ou DEB pelo menos. Daí um servidor automatizado baixa o tarball mais novo, compila os binários no servidor, e atualiza a lista de pacotes. É isso que empresas como Red Hat ou Canonical fazem pra manter suas distros. É pra isso que eles servem. O autor do jq se cadastra lá e fala: "toda vez que sair versão nova, vocês podem baixar o tarball dessa URL aqui", e pronto. Daí em outros servidores eles montam a distro, rodam testes automatizados, e garantem que a versão nova dos pacotes não quebra nada. Se quebrar, dá rollback e descarta.






Vamos voltar pro Slackware. Como disse antes, não tem oficialmente nenhum equivalente de Apt ou Dnf pra gerenciar pacotes. No máximo tem scripts pra lidar com pacotes como pkgtool ou installpkg, que são bem simples. Ele assume que tudo que vamos precisar já tá instalado. Mas a realidade é que tem um monte de software que não vem na instalação. Esse "jq" é um exemplo.







Pra instalar software por fora, poderíamos fazer o que acabei de mostrar, que é baixar os tarballs, compilar e tals. Mas a comunidade Slack criou um site chamado Slackbuilds.org. Ele é um repositório que cadastra softwares como o "jq" e oferece um script em formato SlackBuild. No tal blog post que falei que vou usar de referência, em 2020 que é quando foi escrito, o jq declarava que tinha dependência com o oniguruma, como pode ver nessa foto de tela que tinha no blog.








Mas em 2022, se navegarmos pro site slackbuilds.org e pesquisar "jq", vemos que não tem mais essa dependência. E já sabemos porque. Quando baixamos o tarball do jq, vimos que o autor já copia o codigo fonte do oniguruma junto. Daí não precisa mais compilar separado. O ponto do blog post era mostrar que pra instalar o jq, era necessário instalar o oniguruma separado na mão. Isso ainda é verdade pra vários outros softwares, mas por acaso pra esse exemplo não é mais verdade e menciono aqui justamente pra mostrar que blog posts envelhecem e software muda. Por isso você não pode ser um tapado que só vai copiando e colando, tem que saber o que tá acontecendo.









Agora sei que posso pular esse trecho todo do blog post e ir direto no slackbuild do jq. Eu tenho que baixar o código fonte original, que já fizemos agora pouco, e baixar esse jq.tar.gz que é o script pra gerar o pacote. Voltamos pro terminal, `tar xvfz jq.tar.gz`, entramos nesse diretório "jq" e movemos o tarball do código fonte aqui pra dentro. O segredo é esse script "jq.SlackBuild". O que fazemos com ele? Vamos ver o que tem dentro ué.







É um scriptzão que configura variáveis de ambiente aqui no começo, acerta permissão dos arquivos e olha só, vai executar `./configure` com algumas opções a mais, rodar `make` pra compilar, depois `make check` que vai rodar os testes automatizados pra garantir que compilou certo. Pra você, babaca que acha que testes são desnecessários, o mundo open source só é estável como é hoje graças a testes automatizados. Versões mais novas do seu Ubuntu conseguem sair mais rápido, porque ele roda os testes de todos os pacotes antes de gerar a ISO que você faz download.







Finalmente o script roda aquele `make install`, mas manda instalar num sub-diretório, que é o que vai usar pra gerar o pacote final. Vamos executar aqui. `./jq.SlackBuild`. Só reclama que precisa de sudo, então repetimos com sudo. E pronto, no final fala que gerou um pacote jq bla bla ponto tgz. Pacote de SlackBuild é nada mais, nada menos que um zipão. E pra instalar, abrimos um shell de root com `sudo su`.






Aqui podemos rodar o script `installpkg /tmp/jq bla bla ponto tgz` e pronto, tá instalado. O "jq" roda bonitinho. Se dermos `which jq` fala que tá em "/usr/bin". E a grande vantagem de instalar dessa forma em vez de fazer `sudo make install` na mão é que pra desinstalar fica mais fácil também. Vamos desinstalar. Só rodar `removepkg jq` e olha só, apagou todos os arquivos direitinho. Além do binário "jq" tinha arquivos de documentação, tinha libs, tudo que ia ficar pra trás sujando meu sistema se não tivesse uma forma automatizada de apagar.







E eu falei script, e não programa, porque installpkg é só um script de shell. Damos um `which installpkg` pra ver onde tá. Agora podemos fazer `cat /sbin/installpkg` e olha só. Só um script. Por exemplo, podemos ver que esse script suporta pacotes em 4 formatos diferentes de compressão. O nosso foi final tgz, mas ele suporta extensões como tbz, tlz e txz que respectivamente podem usar bzip, lzip ou xz em vez de gzip. Existem várias variações do lempel-ziv que zip usa, incluindo o zst que é o zstandard que o Debian usa em pacotes ponto deb. Se quiser aprender mais sobre scripts de shell, leia e tente entender esse script. Não é muito difícil.








Esses scripts installpkg e removepkg e pkgtool que eu não mostrei, são o equivalente à ferramenta dkpg do Debian e rpm dos derivados de RedHat. Um Apt usa dkpg por baixo. Um Dnf ou Zypper usa o rpm por baixo. Dpkg serve pra, dado que já tenho um arquivo ponto deb, ele sabe como abrir o pacote, como instalar e como desinstalar. O apt serve pra procurar e baixar o pacote, daí chama o dpkg pro resto.







Como falei antes, Slackware tem equivalente ao dkpg mas não tem equivalente ao Apt. Mas não significa que a única solução é ficar indo manualmente no site slackbuilds.org pra procurar os softwares que precisamos e gerar os pacotes manualmente. Já que o Slackware não tem nada oficial, a comunidade criou uma ferramenta, chamada de sbopkg. Sbo que significa SlackBuilds.org. Vamos instalar. No momento que estou escrevendo esse episódio, é a versão 0.38.2.







Só pegar o link, ir no terminal e baixar com wget. Agora entramos no shell de root e instalamos o pacote tgz com `installpkg`, como fizemos antes com o jq. E agora é só rodar `sbopkg -r`. Esse traço "r" vai fazer um rsync com o site slackbuilds.org pra ter uma cópia local dos pacotes disponíveis lá, pra possibilitar procurar pacotes sem ter que abrir o site num navegador. Por exemplo. Vamos instalar o mesmo "jq" usando essa ferramenta.







Ainda no shell de root podemos fazer `sbopkg -p jq`. Vai criar um arquivo em "/var/lib/sbopkg/queues". Ele tem o conceito de fila, onde podemos ir enfileirando vários pacotes pra instalar de uma só vez. Mas aqui vamos direto já rodar `sbopkg -B -i jq.sqf` e pronto. Tá instalado. Se fosse um pacote com várias dependências, não precisaríamos instalar uma por uma na mão como antes, o sbopkg vai se encarregar de instalar tudo sozinho. Vamos instalar algo mais complexo, como um neovim, mas um pouco diferente agora. Digite só o comando `sbopkg` sem nenhum parâmetro e olha só, abre uma interface interativa em ncurses.







Podemos dar search pra achar o neovim, selecionar o pacote que quero, e dar install. E pronto. Ele se vira. É tipo a loja de software do seu Ubuntu só que em modo texto. Tem opções pra desinstalar, pra atualizar todos os pacotes e mais. Com isso o slackware também fica um pouco mais moderno e parecido com outras distros. 







E a quantas anda nossa instalação de Slackware? Vamos ver, puts, continua copiando pacotes. Eu vou parar por aqui, porque no final a única coisa que vai sobrar é ele me perguntando que gerenciador de janelas queremos usar, se queremos KDE ou XFCE mas a curiosidade é que ele vem também instalado com o antigo Window Maker, que é a base da interface de MacOS desde a primeira versão "X" ou "10", a versão open source do que vinha nos computadores da Next do Steve Jobs. E também vem com Motif, que é interface gráfica que vinha em workstations UNIX como da Sun ou Silicon Graphics. Vale testar de curiosidade, mas são bem rudimentares. No final escolhe um KDE da vida que tá de bom tamanho. Reboota e pronto, tá igual qualquer outra distro.







O Slackware é provavelmente a distro mais antiga ainda em atividade hoje e eu escolhi falar dela pela oportunidade de explicar vários conceitos que acontecem por baixo dos panos, escondido, em distros mais modernas, e que vocês dificilmente iam aprender sozinhos. Eu sei tudo isso porque comecei literalmente usando Slackware e Red Hat nos anos 90 quando nenhuma das distros modernas existia. Ubuntu só viria a aparecer lá por 2005 ou 2006. Arch só aparece depois de 2001. Todas as distros derivadas de Ubuntu como PopOS só aparecem depois de 2010. 







Pra mim sempre tudo fez sentido justamente porque aprendi numa época em que a única coisa que a gente tinha era um tarball de código fonte e o GCC pra compilar e mais nada. Por isso foi mais fácil pra mim do que é pra vocês. É muito mais difícil entender as ferramentas de hoje porque tem misturado ferramentas do passado e é confuso saber o que é pra usar quando. Um usuário novato que escolher Slackware vai bater cabeça sem saber como instalar software, porque não entende a filosofia de tarballs e ia ter dificuldade de entender a diferença do script `installpkg` pro projeto `sbopkg`, sem saber que o primeiro é fundação pro segundo.






De qualquer forma, eu acho interessante a idéia de já ter um monte de coisa pré-instalada. Espaço hoje em dia é barato. E mesmo assim ele não fica pesado porque apesar de estar instalado, nada que você não pedir vai carregar. Por exemplo, se já tiver apache instalado mas eu não habilitar o serviço pra carregar, então não vai consumir memória ou CPU a mais só por estar lá. Porém, do ponto de vista de segurança eu não gosto. Em segurança queremos sempre ter o mínimo possível de software pré-instalado, porque não dá pra saber se um software antigo, sem manutenção, não tem um bug de segurança que pode ser usado pra algum hacker escalar privilégios pra root e tomar conta da nossa máquina. Eu recomendo sempre só ter instalado o que realmente precisa usar.






De qualquer forma, vale tentar instalar e usar por um tempo, pra aprender mais uma distro diferente de Linux. Tendo um sbopkg, o uso é parecido com um apt de Ubuntu ou dnf de Fedora, então não deve dar muito trabalho de usar no dia a dia. Muitos de vocês já instalaram dezenas de software num Ubuntu da vida, sem saber que tava baixando pacotes DEB, sem saber que esses pacotes nada mais são que um zipão. No próximo episódio vamos falar mais conceitos de Linux. Se ficaram com dúvidas, mandem nos comentários abaixo. Se curtiram o video deixem um joinha, assinem o canal pra não perder a continuação, e compartilhem o video com seus amigos. A gente se vê, até mais!


