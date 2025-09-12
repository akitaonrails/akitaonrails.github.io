---
title: "[Akitando] #129 - Apanhando do Gentoo | Melhor Linux???"
date: '2022-10-11T09:47:00-03:00'
slug: akitando-129-apanhando-do-gentoo-melhor-linux
tags:
- linux
- gentoo
- systemd
- openrc
- kernel
- distro
- gnome
- webkit
- segurança
- akitando
draft: false
---

{{< youtube id="cSyTjCUFx2A" >}}

Finalmente vamos tentar instalar e configurar uma das distros Linux mais trabalhosas de todas. O lendário Gentoo foi pensado pra você tirar o máximo proveito do seu hardware, customizando e compilando tudo do zero especificamente pra sua máquina. A primeira parte do video vai cobrir um pouco o que significa instalar uma distro assim. E na segunda e última parte vamos discutir se vale a pena todo o trabalho.

== Errata

Os capítulos 9 e 10 aparecem errado no video mas está correto no índice de tempo abaixo.

== Conteúdo

* 00:00 - Intro
* 01:03 - CAP 1 - Mesma coisa que Slackware - Instalando Gentoo
* 06:22 - CAP 2 - CHROOT - Quebrando a Prisão
* 11:32 - CAP 3 - Depois do Stage3 - Terminando a instalação
* 17:59 - CAP 4 - Compilando a Kernel - Customizando seu Gentoo
* 25:34 - CAP 5 - Resolvendo seu Primeiro Problemão - Não boota!
* 29:24 - CAP 6 - Tentando Instalar GNOME - Mais um Problemão
* 35:49 - CAP 7 - GDM, WebKit, Reflexões - Final da Instalação
* 37:35 - CAP 8 - Mais um Problema de SystemD - OpenRC
* 39:33 - CAP 9 - Por que e Quando usar Gentoo? É pra mim?
* 42:52 - CAP 10 - Qual a Melhor Distro? Eu sei "Linux"?
* 45:57 - Bloopers

== Links

* Gentoo AMD64 Handbook (<https://wiki.gentoo.org/wiki/Handbook:AMD64/pt-br>)
* Quick Installation Checklist (<https://wiki.gentoo.org/wiki/Quick_Installation_Checklist#UEFI.2FGPT>)
* GNOME/Guide (<https://wiki.gentoo.org/wiki/GNOME/Guide>)
* GNOME/GNOME without systemd/Gentoo (<https://wiki.gentoo.org/wiki/GNOME/GNOME_without_systemd/Gentoo>)
* GCC optimization (<https://wiki.gentoo.org/wiki/GCC_optimization>)
* Gentoo Cheat Sheet (<https://wiki.gentoo.org/wiki/Gentoo_Cheat_Sheet>)
* Upgrading Gentoo (<https://wiki.gentoo.org/wiki/Upgrading_Gentoo#Updating_packages>)

## SCRIPT

Olá pessoal, Fabio Akita

Vamos continuar a saga de Linux por baixo do capô e como prometido, desta vez o video vai ser mostrando o lendário Gentoo. Mesmo quem nunca tentou instalar acho que já ouviu falar dele. A distro onde todo o sistema é compilado na sua máquina em vez de baixar pacotes binários pré-compilados.

Não é a distro mais difícil, mas certamente é chatinha, talvez ainda mais chatinha que o Slackware, e muito demorada, vocês vão ver. Só pra ter uma idéia, num ambiente controlado que é uma máquina virtual, mesmo assim eu recomecei a instalação do zero múltiplas vezes e ainda tive que fazer muita tentativa e erro até conseguir bootar.

(...)

O projeto original do Gentoo se chamava Enoch Linux, lá no começo deste século, e o objetivo era criar uma distro customizável que não instalava nenhum binário e sempre compila tudo direto na sua máquina. Consigo imaginar as vantagens disso. Mesmo assim, ainda não recomendo pra todo mundo. Esperem até o final que vou explicar porquê.

Sem mais delongas, mesma coisa que Ubuntu ou Slackware, vamos no site, baixar a ISO pra gravar no pendrive e bootar o instalador. No caso do Gentoo tem uma peculiaridade. Não esquece de baixar esse arquivo chamado stage3 aqui embaixo. Se quiser uma instalação pra servidor, ou seja, sem interface gráfica, baixe um dos dois primeiros arquivos. Se quiser instalar em desktop com gerenciador gráfico de janelas, escolha o profile de desktop. Em ambos os casos, você pode escolher se prefere usar systemd ou openrc.

Já expliquei um pouco sobre init systems e o systemd no episódio anterior de Slackware, mas de novo, se já está acostumado a usar uma distro mais popular como Ubuntu ou Fedora, eles usam systemd e talvez você prefira instalar systemd aqui também, pra não ter que reaprender muita coisa. Por outro lado, justamente porque estamos já tendo o trampo de instalar e configurar Gentoo, por que não usar OpenRC? Já que é uma das poucas distros que tem a opção de não usar systemd. Experimentar coisas novas e diferentes sempre vai agregar, no mínimo você vai ter outra perspectiva.

Eu resolvi escolher o stage3 de profile desktop com openrc por padrão. De resto, mesma coisa, colocamos a ISO no CD-ROM virtual da máquina virtual, bootamos e deixamos carregar. E diferente do Slackware, que cai no login em modo texto, aqui caímos em modo gráfico abrindo KDE. A tela está pequena porque não carregou serviço das ferramentas de guest da vmware pra ajustar resolução. Depois resolvemos isso.

Mas meio que tanto faz pra agora, porque vamos abrir o terminal e fazer tudo dele de qualquer jeito, já que Gentoo também não usa o instalador gráfico Calamares e nos obriga a configurar tudo na mão, bem old school mesmo, e por isso escolhi falar dele pra mostrar algumas coisas que não expliquei na instalação de Slackware.

Uma das grandes vantagens do Gentoo é que o site deles é muito bem documentado. Tem um wiki bem completo que, embora não seja do tamanho do wiki do Arch Linux, mesmo assim consegui encontrar quase tudo que queria. Vale a pena experimentar Gentoo só como desculpa pra estudar a wiki e aprender mais sobre Linux em geral. Em particular, como estou instalando dentro do VMWare, vou precisar usar a página de Wiki específica sobre VMWare, que também é meio válido pra VirtualBox. Então lembrem de ler caso queiram experimentar no VirtualBox de vocês.

Eu vou seguir primariamente esta página que é o "Quick Installation Checklist". Como disse no episódio passado, este video não é um tutorial pra seguir passo a passo. Vou usar a instalação como desculpa pra explicar conceitos de Linux e também uma parte do processo de tentativa e erro normal. Assistam tudo primeiro, depois leiam as páginas da wiki, e depois se aventure a instalar direto na sua máquina ou num VirtualBox.

E não se preocupe, você não vai acertar na primeira vez. Eu mesmo tiver que reinstalar umas três ou quatro vezes na minha máquina virtual até conseguir terminar, foi um dia inteiro de tentativas e erro. Errar e recomeçar faz parte do aprendizado. Se quiser uma instalação fácil que acerta tudo de primeira, e não aprender nada, baixa Ubuntu.

Enfim, a wiki já começa sendo legal com você. Se sua máquina for muito antiga, de mais de 10 anos pra trás, pode ser que tenha BIOS em vez de UEFI e só suporte boot com MBR. Se for um pouco menos velha talvez seja BIOS com GPT, e se for mais moderna vai ser UEFI e GPT. Já falei disso no video passado e na minissérie sobre armazenamento. Assistam depois. Se tiver assistido, já sabe a diferença de BIOS e UEFI e MBR e GPT. No meu caso vou escolher UEFI e GPT, só garantir que na minha máquina virtual selecionei UEFI também, por padrão ele simula uma BIOS antiga, cuidado com isso.

O resto é a mesma coisa que já mostrei no video de Slackware. Uso `cfdisk` pra particionar o HD e depois comandos como `mkfs.ext4` e `mkswap` pra formatar as partições. A única diferença é que no video de Slackware fui preguiçoso e só criei 3 partições, 1 de boot efi, 1 de swap e a principal. Esse wiki manda criar 4, que é mais correto, 1 partição separada pro mount point de "/boot", outra pra "/boot/efi" dentro, daí as mesmas de swap e outra pra principal.

Não vou explicar linha a linha tudo de novo. Veja o episódio anterior pra detalhes disto. Mas é esta sequência de comandos aqui do lado. Primeiro estas, depois do cfdisk, pra formatar as partições e depois esta outra sequência pra montar as partições dentro de "/mnt/gentoo", que vai ser a raíz da instalação.

Agora vem a hora daquele Stage3 que falei no começo, o zipão de 500 megas. O wiki manda entrar no diretório "/mnt/gentoo" e usar wget pra baixar o zipão. É o jeito mais fácil mesmo se o LiveCD detectou seu wifi ou sua rede cabeada e tá conectado na internet. Se não estiver, baixa em outro computador, coloca num pendrive, e copia do pendrive pra dentro desse diretório.

No meu caso, abro o firefox, e na página de download seleciono o stage3 pra desktop com openrc. Agora é descompactar com o comando `tar xpf stage3*`. Vai parecer que travou, mas é porque o arquivo é grandão e leva alguns minutos pra descompactar tudo, paciência.

Pronto. Se der um `ls`, olha só, tem os diretórios que você já deve ter visto em qualquer instalação de Linux, o "/usr", "/etc", "/bin", "/var" e tudo mais. Tecnicamente o Gentoo já tá instalado, agora vem a parte mais complicada, que é configurar tudo antes de bootar. E a próxima seção do Wiki se chama "Chroot". Então chegou a hora de fazer uma tangente pra explicar o que é isso.

Deixa eu bootar meu Ubuntu em outra máquina virtual e abrir um terminal. Agora vou criar um diretório qualquer e chamar de "jail" ou "prisão" mesmo. Tenha paciência que vou executar vários comandos que podem não fazer sentido, mas vai fazer. Lembra que executáveis de Linux costumam ter dependência de outros objetos binários ou bibliotecas compartilhadas? Que nem em Windows que você tem DLLs?

Lembra também quando falei sobre PATH? Quando executamos `ls`, onde que realmente tá esse executável? Podemos saber usando o comando `which ls` e descobrimos que o caminho completo é "/usr/bin/ls". Fazemos a mesma coisa pro shell Bash, que é a linha de comando onde estamos. `which bash` e tá em "/usr/bin/bash". Beleza, vou precisar desses binários.

Uma ferramenta que nunca tinha mostrado é o `ldd`. Ela analisa um binário e lista as bibliotecas compartilhadas que depende. Fazemos `ldd /usr/bin/bash` e `ldd /usr/bin/ls`. Estes são os objetos binários que eles precisam. Agora vem a parte estranha. Recriamos esses diretórios dentro do "jail" com `mkdir -p jail/bin` depois `mkdir -p jail/lib/x86_64-linux-gnu`, `mkdir -p jail/lib64`. Copiamos os binários do bash e ls pra "jail/bin" e depois, um a um, copiamos as bibliotecas pra dentro de "jail/lib" e "jail/lib64". Trabalhinho. Já entenderam o que vou fazer?

Pronto, listando com `ls jail`, temos todos os bits necessários pra rodar bash e ls. Mas qual o objetivo de duplicar essas coisas? Agora vem o truque: rodamos `sudo chroot jail /bin/bash`. E olha só, abriu um shell de bash. Duh, grande bosta. Mas presta atenção, estamos rodando o bash que copiamos dentro do diretório "jail".

Fazendo `ls /` pra listar a raíz, cadê meu Ubuntu, cadê todos os outros diretórios? Estou preso dentro do jail, enxergando como se esta prisão fosse a raíz do sistema. Parece uma máquina virtual né? Só que não é. `chroot` literalmente quer dizer "change root" ou "mude a raíz". Ele faz o sistema operacional mentir pro meu usuário achar que a raíz do drive agora é só isso. A grosso modo, é como se eu tivesse bootado pra dentro de outra máquina, sem realmente ter feito um boot de verdade.

Eu chamei o diretório de "jail" porque neste momento meu usuário está preso dentro dessa cadeia. Ele acredita que meu HD de verdade é o que está dentro da cadeia. Por isso copiei as bibliotecas do bash e ls pra dentro, senão eles nem iam conseguir executar. Se der exit, pronto, voltamos ao normal. `ls /` agora lista minha partição de verdade.

Sei que é um pouco confuso isso, mas vocês tem que perder a noção de associar a raíz do sistema com seu HD físico. A raíz do sistema é um ponto de montagem, por acaso eu associo "/" com a partição usando o sistema de arquivos ext4, é o que tá configurado no arquivo "/etc/fstab". Mas posso mudar isso dinamicamente mesmo depois do boot. Linux é um sistema dinâmico, não pense nele como algo congelado e fixo.

Chroot é bem útil pra várias aplicações, mas um uso errado é segurança. Se procurar no Google vai achar tutoriais, por exemplo, pra fazer um usuário se conectando via SSH cair dentro de um chroot. Alguns pensam que é uma boa forma de evitar que o usuário consiga enxergar o sistema de arquivos de verdade da máquina por baixo. Uma forma de segurança. Mas chroot nunca foi projetado pra ser usado pra segurança.

Antigamente, coisa de mais de 20 anos atrás, a gente usava chroot em processos como servidor web Apache, na esperança que se o apache fosse invadido, o invasor ia cair dentro de um chroot e não ter acesso à partição toda do servidor. De novo, chroot não é mecanismo de segurança. Deixa eu provar com o tiro pode sair pela culatra. Chroot é executado como root e permanece com o setuid de root dentro. Vamos tentar estourar essa prisão. Nada nessa manga, nada nessa outra. Minto na verdade eu tenho um programinha feito em C que achei no Google. Esse aqui.

`#include <sys/stat.h>
# include <stdlib.h>
# include <unistd.h>

//gcc break_chroot.c -o break_chroot

int main(void)
{
    mkdir("chroot-dir", 0755);
    chroot("chroot-dir");
    for(int i = 0; i < 1000; i++) {
        chdir("..");
    }
    chroot(".");
    system("/bin/bash");
}`

Vou compilar, copiar esse binário pra dentro do diretório jail/bin, entro no chroot de novo, estou preso, tá vendo? Não enxergo nada fora. Agora é só executar e .. boom, olha só, não só estourei pra fora do jail como invadi o usuário de root dessa máquina. Isso que se chama escalação de privilégios.

O que ele faz é simples. Esse programinha poderia ter sido feito em python, shell script ou o que quiser. Ele só cria um novo diretório com mkdir, dentro dele faz um loop com equivalente a `cd ..` mil vezes, e sabemos que ".." é pra voltar pro diretório anterior. Mas ele explora algum bug do chroot que ao fazer isso um tanto de vezes e depois criar outro chroot dentro desse chroot, ele estoura pra fora e mantém os privilégios do usuário que criou o primeiro chroot, que foi o root.

Enfim, essa tangente foi só apresentar chroot e pra ilustrar o ponto que apesar de parecer um mecanismo de segurança ao isolar o usuário num diretório mais limitado, na realidade não é, é uma conveniência que serve justamente pra coisas como instalar de Linux, que é justamente o que o tutorial do wiki do Gentoo vai nos mandar fazer no próximo passo.

Veja que na página de Wiki a próxima seção se chama justamente "Chroot". Entramos no diretório `cd /mnt/gentoo` que foi onde descompactamos aquele arquivão stage3 e instalamos todos os arquivos do sistema. Criamos pontos de montagem pra diretórios virtuais especiais de Linux usando parâmetros especiais do comando `mount`. Pra proc, sys, dev e run, tudo dentro do /mnt/gentoo.

Com tudo montado, no final copio o "/etc/resolv.conf" que tem configuração de DNS e faço um chroot pro diretório corrente, executando o `/bin/bash` que tá dentro desse chroot. A partir de agora, pro meu usuário, o novo "/" é o que tem no diretório "/mnt/gentoo", sacaram? Estou dentro do meu gentoo recém instalado, sem precisar bootar. Saí da partição do LiveCD e entrei na partição do novo Linux instalado no meu HD. Assim posso mexer lá dentro sem ter que bootar ainda. E nem daria pra bootar, porque essa instalação ainda não tem kernel e nem bootloader configurado, que é o que fazemos agora.

De novo, a partir deste ponto é como se eu já estivesse no novo Gentoo instalado no meu HD de verdade, sem ter precisado bootar. Isso é um jeito super rudimentar e incompleto de container, como um Docker. Você já está num Linux funcionando, a gente só muda a raíz do usuário pra outra raíz em outra partição e de lá de dentro é um Linux com ferramentas diferentes, embora usando a mesma kernel que já tava carregada. Ainda não é hoje que vou falar de containers, mas pra chegar lá achei útil explicar que chroot existe, e apesar de ter um efeito parecido, não é usado em containers de verdade.

Agora que estamos dentro do nosso novo Linux, o que todo mundo sempre fala pra fazer logo que instala um Linux novo? Atualizar os pacotes com o repositório online pra ver se tem pacotes novos pra instalar. Num Ubuntu da vida, no terminal, é só executar `apt update && apt upgrade`. Mas Gentoo não usa Apt e sim Portage e o comando é `emerge`. Gentoo não instala software, ele "emerge" software .. Enfim, o equivalente ao `apt update` é `emerge-webrsync`. Pra aprender outros comandos de emerge, a wiki tem outra página com um cheat sheet, explicando as principais opções. Vou deixar o link na descrição abaixo.

Feito isso, até agora só temos o usuário de root funcionando, mas sem senha. Então precisamos criar uma senha forte pro root com o comando `passwd`. Por acaso a política de senhas do Gentoo é mais restrita que de um Ubuntu, ele exige senhas um pouco mais fortes, então cuidado aqui. Depois disso, só criar um usuário normal não-administrador com o comando `useradd` e mudar a senha dele também.

Precisamos editar alguns arquivos de configuração, então próximo passo é instalar um editor de textos de linha de comando decente. Por isso `emerge -vq vim`. Se ainda não sabe usar vim, tudo bem, usa um nano da vida, qualquer editor serve, mas você precisa aprender a usar um editor de linha de comando. VSCode não vai te ajudar quando precisar dar SSH num servidor. Depois disso precisamos editar o arquivo "/etc/fstab", que já expliquei no video passado, é onde declaramos os pontos de montagem principais, ligando partições como "/dev/sda1" com pontos de montagem como "/boot".

Como expliquei no começo, o conceito todo do Gentoo é baixar pacotes de código-fonte dos softwares e compilar na hora de instalar. Significa que temos que configurar o compilador com parâmetros de compilação e a configuração global do Portage fica no arquivo "/etc/portage/make.conf". Lendo as páginas de instalação do Wiki, mantenho tudo igual e só no final adiciono as seguintes variáveis de ambiente:

`
ACCEPT_LICENSE="*"
GRUB_PLATFORMS="efi-64"
USE "-qt5 -kde X gtk gnome"
VIDEO_CARDS="vmware"
INPUT_DEVICES="libinput synaptics"
`

De novo, isto não é pra ser um tutorial completo de instalação, certamente tem mais configurações importantes que eu não vi, então faça sua pesquisa. Pra mim, nesse cenário de máquina virtual, isso foi o suficiente. E no meu caso vou instalar GNOME como gerenciador de janela, por isso tem "-qt5 -kde", pra priorizar opções em gtk e gnome.

Vale a pena explicar é esse Accept License pra asterisco. Acho que o emerge restringe instalar pacotes de softwares com licenças não livres, daí ele mascara esses pacotes e eu tive problema de não conseguir instalar por causa disso. Mas dizendo pro Portage aceitar as licenças, daí consigo instalar. E veja também em Video Cards que isso é necessário no meu caso porque estou num Vmware. Se você tiver placa de video NVIDIA teria colocado "nvidia" ou se fosse AMD seria "amdgpu" e assim por diante.

Além disso, o grande lance do Gentoo é baixar pacotes de código fonte e compilar, por isso nesse arquivo tem CFLAGS e CXXFLAGS, que são opções pro compilador GCC. Tem outra página no Wiki explicando essas e outras flags que eu recomendo que vocês leiam e não saiam só copiando e colando coisa aqui sem saber porque. Por exemplo, o flag "-O2" é o nível de otimização que o compilador vai usar. "-O1" é o mais básico e "-O3" é o máximo. Tem gente escrevendo em fórum que conseguiu um executável mais rápido usando um "-O9" da vida. É mentira, não existe esse nível, o máximo é 3.

Tem gente recomendando usar flags como "-funroll-loops" pra otimizar mais, e de novo, como o Wiki explica, o próprio manual do GCC fala pra não usar isso, porque você vai acabar com um binário maior e mais lento. Flags agressivas devem ser usadas só pro programadores que realmente sabe o que elas fazem, em software que foi escrito pra tirar vantagem disso. Não devem ser usadas em pacotes aleatórios e muito menos pro sistema inteiro. Se ficar usando flags aleatórias, vai acabar com binários mais pesados, mais lentos e mais instáveis e seu sistema vai ficar uma bosta. E a culpa não é o Gentoo, é você que sai copiando e colando coisa sem saber.

Seguindo nosso guia do Wiki, tem configurações opcionais que vou passar acelerado. É só seguir o que diz no Wiki. Mas seria configuração de locale, hostname, keymap, timezone. Nenhum detalhe importante pra agora.... E finalmente chegamos na parte importante que diferencia o Gentoo dos demais, na minha opinião, a seção de customização da Kernel agora na instalação. Na real, você pode customizar kernel em qualquer distro, mas no Gentoo isso faz parte do processo de instalação.

Pra isso precisamos do código-fonte. Executamos `emerge -av sys-kernel/gentoo-sources sys-kernel/linux-firmware`. Note que pacotes em Gentoo são organizados em namespaces como "sys-kernel". Enfim, quando terminar, entramos no diretório de código-fonte que é o "/usr/src/linux" e a versão.

Se nunca teve a oportunidade de fuçar o código fonte da kernel do Linux, eis sua chance. Depois abra um editor de textos qualquer e perca algumas horas vasculhando o código, talvez aprenda algo. Não tenha medo de código só porque parece complicado. Justamente porque parece complicado é que deveria ser fascinante. Na prática, uma boa parte do código vai ser de drivers de dispositivos.

Apesar do código fonte do Linux ser um enorme monolito, tudo organizado num mesmo repositório, o binário em si é mais ou menos modular. Existem vários drivers que são compilados estaticamente no mesmo binário da kernel. Acho que o driver do sistema de arquivos ext4, por exemplo, fica dentro do binário da kernel. Porém existem drivers que não são carregados imediatamente no boot. São compilados separadamente, como objetos ou bibliotecas, e podem ser carregados depois, com comandos como modprobe.

Sem mais delongas, do diretório de código fonte, vai ter um Makefile, como mostrei no episódio passado, lembram? Todo programador de C sabe lidar com Makefiles e aqui não é diferente. Vai ter uma tarefa chamada `menuconfig`, que carrega com `make menuconfig`. Abre esse programa interativo em modo texto, acho que usando ncurses. É uma lista de categorias de módulos de kernel.

Tudo que tá desmarcado, é porque não vai ser compilado. O que estiver com "*" vai ser compilado e linkado estaticamente, ou seja, vai estar dentro do binariozão da kernel. E o que estiver com "M" vai ser compilado e mantido desativado num arquivo separado até ser carregado por comandos como `modprobe`. Você quer manter o máximo de pacotes desmarcados, se possível.

Por exemplo, sei lá porque, por padrão vem marcado suporte pra PCCards, padrão PCMCIA ou Cardbus. Eu nunca mais vi esse tipo de dispositivo nos últimos 20 anos. Pra quem não sabe, antes de ter conectores como Thunderbolt ou USB, uma das formas de adicionar um hardware externo num notebook dos anos 90, era com cartão PCMCIA. Eram coisas como essas. Até imagino que deva ter hardware especializado em alguma indústria que ainda precise disso, mas pra pessoas normais como eu ou vocês aí, nunca vamos precisar disso. Não faz sentido a kernel sempre carregar esse driver e ficar ocupando espaço na RAM. Posso desmarcar.

Na real, vamos sair e fazer outra coisa antes. Note que estamos ainda no ambiente de LiveCD do pendrive. E tá tudo funcionando bonitinho, ou seja, a detecção automática de hardware funcionou até que bem. Seja lá quais drivers foram carregados, tá fazendo nossa máquina funcionar. Então, por que não selecionar os mesmos drivers que já estão carregados? Pra isso podemos rodar o comando `make localyesconfig` pra atualizar o arquivo `.config` com esses drivers. E aí sim, voltamos pro `make menuconfig` e tiramos suporte a PCMCIA e outras coisas que sabemos que não vamos precisar.

Podemos sair tirando mais coisas, como suporte a hardware de Chromebooks, ou suporte a notebooks Surface da Microsoft. Normalmente o que você mais vai mexer é a categoria de Device Drivers. Nas outras opções, a menos que tenha certeza absoluta, não mexa, especialmente em categorias como Criptografia, Gerenciamento de Memória. Isso é bom pra você fuçar se estiver pesquisando sobre sistemas operacionais mais a fundo. Mas pra usuários iniciantes, o ideal é mexer bem pouco.

No meu caso, agora entra aquela outra página de Wiki que falei no começo, que lista alguns módulos específicos pro caso onde estou numa máquina virtual VMWare. Então eu gostaria de carregar drivers de Vmware. Por exemplo, em Device Drivers, Network device support, preciso selecionar o driver VMware VMXNET3 ethernet. Nessa página tem essa listinha sugerindo módulos pra checar e ativar. Depois que terminar, só selecionar lá embaixo a opção de "Save" e sair.

De volta à linha de comando, agora é hora de compilar a kernel. Vamos compilar com o comando `make -j4`. No tutorial ele sugere "-j2". Essa opção "j" significa "jobs" ou trabalhos em paralelo, que é quantos arquivos vai compilar ao mesmo tempo. "j2" é o mínimo, vai usar só duas threads da sua CPU. No meu caso, eu dei 2 cores da minha CPU de verdade com 2 threads cada, então posso rodar com "-j4".

Se estivesse nativo no meu AMD Ryzen 9 de 32 threads, eu poderia rodar com "-j32". Quanto mais cores tiver pra gastar, mais rápido vai ser a compilação, porque vai tudo em paralelo. Porém, quanto mais rodar em paralelo, mais RAM precisa ter. Se for agressivo demais em jobs paralelos e tiver 4 giga ou menos de RAM, provavelmente vai crashear, então cuidado.

Esse arquivo vmlinuz que gera no final é o binário da kernel. Se nunca viu um Linux de verdade na sua frente, muito prazer, este é "O" Linux que todo mundo tanto fala mas ninguém nunca viu. E não só isso, esse é um kernel feito sob medida especialmente pra você, sem carregar muita coisa desnecessária. Numa distro normal como Ubuntu ou Manjaro, vem com uma kernel mais genérica que precisa suportar os mais diferentes tipos de hardware, então eles tentam manter mais drivers ativos do que realmente é necessário, consumindo mais RAM.

Esse é o custo da comodidade. Um usuário normal não quer ter que configurar sua própria kernel do zero, então se contenta em desperdiçar um pouco de RAM e um pouco até de processamento, carregando uma kernel mais gorda do que precisa, só pro caso de um dia precisar de um hardware mais exótico. Mas a filosofia do Gentoo é justamente compilar tudo do zero pra termos a oportunidade de escolher tirar tudo que sabemos que não vamos precisar.

Agora que temos a kernel, precisamos colocar na partição de boot junto com um bootloader. Lembram de dois episódios atrás que expliquei sobre boot? Vamos instalar o bootloader com `emerge --ask sys-boot/grub`. Uma vez instalado, como estamos num ambiente EFI, rodamos `grub-install --target=x86_64-efi --efi-directory=/boot/efi` pra instalar o bootloader na partição de boot. E instalamos a kernel com `grub-mkconfig -o /boot/grub/grub.cfg`.

E pronto. Pra terminar, só instalar o suporte a rede pra no próximo boot conseguir carregar wifi, rodar dhcp e tudo mais. O wiki sugere essa linha de comando grandão aqui, mas como estou numa máquina virtual, sei que não vai ter wifi, porque estou simulando uma rede cabeada na máquina virtual, por isso só rodo `emerge --ask sys-apps/iproute2 net-misc/dhcpcd`. E acabou a parte do LiveCD. Saímos com `exit` e damos um reboot de uma vez.

E que estranho. Cadê a opção da kernel que acabamos de bootar? O menu do Grub tá vazio. Ele entra no menu UEFI da máquina. Bom, obviamente fiz alguma coisa errada, mas por aqui podemos bootar de novo pelo LiveCD no CD-ROM virtual. Vamos voltar pro ambiente que estávamos antes. Lembra que eu falei que o LiveCD serve pra diagnosticar e resolver problemas caso o boot falhe? Vamos ver isso na prática.

De volta àquele KDE do LiveCD, abrimos o terminal e vamos criar os pontos de montagem das nossas partições de novo. Pra não ficar repetitivo é essa sequência igual tá no começo da página de wiki. Ir criando os diretórios, daí `mount` de coisas como proc, run, sys e finalmente o chroot de novo. E enquanto fazia isso que me toquei. Eu terminei de compilar a kernel e logo depois fui instalar o Grub, mas esqueci de instalar a kernel. Vamos voltar pro diretório "/usr/src/linux". Faltou rodar `make modules_install` e `make install`. Burro.

Sempre que compila e instala uma nova kernel, tem que lembrar de atualizar o Grub. Só rodar `grub-mkconfig -o /boot/grub/grub.cfg`. Pronto, podemos dar exit pra sair e reboot. Esperamos alguns segundos e agora sim, temos a opção do nosso Gentoo novinho. Escolhemos ele, começa a sequência de boot do sistema init. E ... caraca, que porra é essa?

A mensagem diz que a CPU foi desabilitada e a máquina parou de bootar. Literalmente ou a kernel deu crash ou deu uma instrução HLT de halt and catch fire. Nunca tinha visto isso em nenhuma outra instalação de Linux. Certamente fizemos alguma coisa errada na hora de compilar a kernel que agora ela não boota. Isso vai acontecer bastante nas primeiras vezes que você tentar compilar sua própria kernel e acabar desabilitando coisa que não devia.

E eu estou deixando esses erros aparecer no video de propósito pra vocês saberem que sim, esses erros acontecem o tempo todo. E sim, em videos como esse todo youtuber corta fora as partes de erro. Por isso parece que no video tudo é perfeito e só você que deve ser ruim porque no seu dá erro. Mas pra todo mundo dá erro, a gente corta senão o video ia ficar muito cansativo.

Temos que resetar à força de novo, escolher o menu da UEFI no Grub pra poder escolher bootar pelo LiveCD. E lá vamos nós outra fez, cair no KDE do LiveCD, abrir o terminal, refazer os pontos de montagem e dar chroot ...  Alguma coisa eu fiz errado quando desmarquei coisas do kernel. Vamos abrir o menuconfig outra vez ... (5 min later ...)

Se olharmos a página de Wiki sobre Vmware, fala que preciso checar se estes módulos aqui estão selecionados, e eu vi que estão. Muito estranho. Selecionei de volta tudo que lembro que tinha tirado. Vamos compilar de novo com `make -j4` .... (5 min later), pronto, agora é fazer outra vez `make modules_install` e `make install` e `grub-mkconfig`.

Pra garantir, acho que não faz diferença pra agora, mas vamos aproveitar pra instalar o pacote `open-vm-tools`, que é a versão open source do antigo pacote proprietário `vmware-tools`, as ferramentas da Vmware pra Guests. Ele configura coisas como resolução da tela, rede, clipboard compartilhado com o host, sincronia da hora com o host. Talvez tenha algum driver que falta. Pra instalar é só fazer `emerge --ask app-emulation/open-vm-tools`.

Se fosse systemd como num Ubuntu, precisaria fazer `systemctl start vmware-tools` mas como escolhi o stage3 com OpenRC precisamos fazer `rc-service vmware-tools start` e olha só, dinamicamente carregou o driver de video da Vmware e ajustou a resolução da máquina. Bom sinal. Pra garantir que vai carregar no próximo boot, só fazer `rc-service add vmware-tools`. Mas tá vendo, systemd ou openrc, pro usuário final, é mais diferença de sintaxe entre os comandos systemctl e o rc-service.

Podemos sair, rebootar e ... Caraca, mesma coisa. Crash. Vamos bootar outra vez pelo LiveCD .. (5 min later) .. pronto. Tudo que a gente modifica naquela tela interativa do menuconfig no final é gravado no arquivo `.config`. Deixa eu abrir direto ele. Comparando com a Wiki, ele fala NET_VENDOR_AMD, vamos procurar e sim, tá yes. AMD8111_ETH, tá yes também. Vamos checar um a um (5 min later), FUSION ... ué, tá comentado. Mas eu juro que no menuconfig o Fusion MPT que é driver de Scsi Host, tava habilitado. Estranho, vamos descomentar e dar yes.

Gravamos e damos `make -j4` de novo. E olha só, ele vai me dando opção de configurar outras opções novas, como Fusion SPI, que também precisa estar habilitado. Vamos lá então. Vai continuar a compilação como antes. No final, repetimos a mesma sequência, `module_install`, `install`, `grub-mkconfig` ... saímos com exit, e reboot com dedos cruzados.

Máquina rebootando ... e caraca, agora passou!! Como eu mexi mais coisas além do Fusion SPI, não sei se foi isso que resolveu ou não, mas pqp. Fiquem espertos, talvez vocês rodem num Vmware também e não tenham problema nenhum, talvez tenham problemas diferentes, mas enfim, vai ter problemas desse tipo e vai ter que ficar indo e voltando como eu fiz. Agora sim, termina o boot e chega até a o prompt de login em modo texto, ou seja, runlevel 3 de multi-user. Vamos instalar uma interface gráfica pra gente.

Entramos com `sudo su` pra continuar como root. Gentoo tem conceito de profiles, sets e coisas assim que ainda não sei muito bem os detalhes. Mas segundo o Wiki, preciso me certificar que estou no profile de desktop gnome com openrc. Pra isso posso ver os profiles disponíveis com `eselect profile list`. Seleciono o certo com `eselect  profile set default/linux/amd64/17.1/desktop/gnome/systemd`. Pronto.

Antes de continuar, vamos mexer na configuração do Portage em "/etc/portage/make.conf". Tinha faltado INPUT_DEVICES. Colocamos libinput e synaptics que é pra touch pads. E no final configuramos o parâmetro USE pra ignorar qt5 e kde e prioriza X, gtk e gnome. E é isso. Pra instalar o gnome é só fazer `emerge --ask gnome-base/gnome`.

Mas, já temos um erro. No caso um erro de dependência circular. Vira e mexe vai esbarrar nisso em Gentoo e não tem uma resposta automática. Nesse caso tem dois sistemas de áudio concorrentes e ele não sabe qual instalar. Mas como falei antes, leia a porra do erro. Já diz que é ou pra escolher "minimal" ou "pulseaudio". Pra corrigir basta mudar o comando pra `USE="minimal" emerge --ask gnome-base/gnome`.

Só que deu erro de novo. Leia com atenção, é um erro diferente. Agora fala que não consegue instalar o pacote `x11-base/xorg-server`. Gnome, Kde, Xfce e qualquer gerenciador de janelas roda em cima do servidor gráfico X11, ou em distros mais novas, em cima do Wayland. Então precisa instalar o X11, só que o erro diz que ele não consegue instalar com essa flag "minimal" que acabamos de colocar. Uma das formas de resolver é instalar o xorg-server sozinho com `emerge --ask x11-base/xorg-server`. Não sei se é a melhor forma mas, é isso, tá instalando. Temos que esperar alguns minutos porque o X11 é bem grandinho e compilar leva tempo ... (5 min later)

Com o xorg instalado, podemos tentar instalar o gnome de novo com o mesmo comando de antes e agora passa! Baixa o código fonte, começa a compilar e pode ir almoçar, vai na academia, vai ler um livro. Sério. Um gerenciador de janelas, Gnome, Kde ou qualquer um é composto por dezenas de pacotes, milhões de linhas de código, e o Gentoo vai compilar tudo do zero.

Eu configurei esta máquina virtual com 2 cores e 2 threads e 8 giga de RAM, uma configuração bem fraquinha. Se estivesse nativamente no meu Ryzen 9 de 32 threads com 64 giga de RAM, ia acabar em poucos minutos, mas numa máquina fraca dessas, vai levar mais de 2 horas fácil. Nem tô brincando ... Até logo, a gente se vê mais tarde

(1 year later ...)

Ufa, parece que agora terminou. Caraca, sério, é muito tempo. Nem tô brincando. Vamos no wiki ver o que falta fazer. Ele manda atualizar as variáveis de ambiente com `env-update && source /etc/profile`. Daí manda colocar nosso usuário no grupo plugdev com `getent group plugdev` primeiro pra checar, e sim, tá lá. Então `gpasswd -a akitaonrails plugdev`.

Finalmente, precisamos habilitar o DM, no caso o GDM. E o GDM precisa do elogind no boot. Opa, falei grego, eu sei. Que diabos é DM? É acrônimo pra Display Manager ou, mais corretamente, Login Manager ou gerenciador de Login. É aquela primeira tela gráfica que pede seu login e senha depois do boot. É ele que se encarrega de carregar o GNOME propriamente dito. Por padrão o X carrega o XDM, então precisamos trocar pro GDM porque o XDM não consegue carregar Gnome.

Pra isso primeiro precisamos configurar o serviço elogind pra carregar antes no boot com `rc-update add elogind boot`. Agora precisamos instalar o serviço que inicia o display manager com `emerge --ask --noreplace gui-libs/display-manager-init` e editamos o arquivo `/etc/conf.d/display-manager` com vim. Tá vendo? Lá embaixo o padrão é "xdm" então trocamos pra "gdm" e salvamos.

Por fim, configuramos o serviço pra iniciar automático, colocando no runlevel padrão com `rc-update add display-manager default`. Teoricamente é só isso, só rebootar agora ... e ... falhou, por alguma razão ainda tá tentando carregar o XDM, que não existe, e sai fora. E lá vamos de novo investigar. (5 min later) Fiquei fuçando aqui e checando se aquele arquivo de configuração tá com "gdm" mesmo, o serviço elogind também carregou normalmente, tá difícil.

Mas achei estranho que também não encontrei o gdm. Uma hipótese é que inicializador tenta carregar o GDM, não acha, e como alternativa tenta carregar o XDM, que também não tá instalado. Imaginei que o pacote "gnome-base/gnome" já automaticamente instalava, mas pelo jeito não, ou deu algum erro que eu passei batido e não vi, então vamos instalar com `emerge --ask gnome-base/gdm`. De novo, hora de mais um café, porque esse também demora pra compilar ... (1 year later)

(levanta .. CONTINUA ... volta ...)

Dessa vez estou cortando fora as várias horas que eu levei apanhando do GDM. Na real, da dependência do GDM e do GNOME que é o webkit-gtk. Puta pacote bosta. Ele ficava dando erro, eu tentava de novo e nada. Rechequei configuração, flags de compilação e gastei um tempo lendo fóruns que achei no Google, até num deles tive um insight. Lembra que falei que se tentar compilar muito agressivo, numa máquina fraca, pode faltar RAM? Acho que foi isso, o compilador crasheava por falta de memória, dava erro e parava. Só que o compilador não diz que faltou memória, ele fala que deu erro numa linha de um script que voltou false.

Mas sim, voltou false porque deu crash. Aumentei pra 16 giga e vamos compilar de novo. Nos vemos em duas horas ... (2 hours later) …

Será que agora vai? Opa, sem erro na deteção do GDM e ... e ... ha! Carregou o GDM!! Vamos logar ... opa, senha errada ... de novo. Pronto! Caraca, um dia inteiro pra no fim descobrir que era falta de memória. Vai se fuder. E olha só, isso é um GNOME zerado, sem nenhuma opção extra, sem nenhum aplicativo pré-instalado. Agora eu posso instalar exatamente só os programas gráficos que eu quiser, e não ter que ficar com aquele monte de lixo que toda distro já pré-instala pra mim. Eu não preciso de cliente de email, não preciso de gerenciador de foto. Nesse sentido, eu gosto disso de poder instalar minhas próprias coisas.

A moral da história é: não tente instalar um gerenciador de janela pesado como GNOME numa máquina fraca com menos de 8 giga de RAM. Provavelmente tinha flags de GCC que eu podia ficar mexendo, mas na prática só ia deixar a compilação ainda mais lenta. E sério, puta componente lento de compilar. Toda vez que tentava de novo era fácil mais de 1 hora até terminar em crash. Configurar um Gentoo não é pros fracos. E se você tem máquina fraca, escolha um gerenciador de janela mais leve, como XFCE. Apesar que a culpa nem foi do GNOME, foi do webkit. De curiosidade, vocês sabem o que é Webkit?

Webkit é o framework de navegadores, a engine de HTML, CSS que roda por trás do Safari de Mac e que inicialmente estava nos Chrome. Acho que o Chrome é meio que um fork ou rewrite de Webkit e evolui separado. Mas o Webkit não é o navegador, ele é usado dentro de navegadores como o Konqueror, e todo aplicativo desktop que exibe HTML, como cliente de email. Justamente por isso é provavelmente o componente mais pesado que você vai instalar na sua máquina. Sério, olha o tanto de hora que leva pra compilar essa porra. Uma engine de web não é um troço pequeno, porque a web hoje é desnecessariamente complicada. Valeu Apple e Google, por tornar a web pior.

Aliás, falei que não veio nenhum aplicativo instalado aqui. Inclusive não tem nem loja de aplicativos e nem terminal. Como que eu instalado um terminal sem ter o terminal? Lembrem dos meus videos anteriores, vocês tem 5 segundos pra adivinhar. 4, 3, 2, 1 ... vamos mudar pro runlevel 3. Ctrl + Alt + F3. Pronto, de volta pro console em modo texto. Agora daqui eu posso instalar qualquer aplicativo de terminal que eu quiser, como o Alacritty, que é meu preferido. E quando terminar, volto pro modo gráfico com Ctrl + Alt + F5.

Enfim, finalmente, temos GNOME bootando bonitinho neste Gentoo quentinho saído do forno, configurado com OpenRC em vez de systemd pra gente ter um ambiente pra estudar melhor OpenRC e se é melhor mesmo do que o Systemd. Falando nisso, tem essa outra página no Wiki que fala de GNOME sem Systemd. Lá explica que antes dava pra carregar GNOME sem problemas tanto com systemd quanto openrc. Mas isso mudou.

Como expliquei no episódio anterior, o systemd faz mais do que só gerenciar resolução de dependências e start de serviços. Agora gerencia também coisas como economia de energia e outras atividades do sistema, inclusive gerenciar o diretório /dev de dispositivos, lembra dele? Por causa disso surgiram dois projetos que extraem essas coisas do systemd, projetos como elogind que instalamos antes e eudev. Assim é possível usar só essas partes do systemd e substituir por OpenRC e conseguir subir o Gnome.

Essa é outra das críticas do systemd: que ele faz muito mais do que deveria. Um sistema de init deveria só gerenciar inicialização. Software pra controlar "/dev" deveria ser separado, em outro pacote, de tal forma que desse pra instalar um, sem instalar o outro. Mas o systemd é um código-fonte monolito, ou compila tudo junto, ou nada funciona.

Pra extrair projetos como elogind e eudev, dá um puta trampo, porque toda vez que o systemd atualiza e muda as coisas, esses outros projetos precisam extrair de novo o que mudou pra nada quebrar. É realmente uma grande perda de tempo e consigo entender porque muitos desenvolvedores de Linux estão putos com isso.

De qualquer forma, pra gente que contribui no desenvolvimento de distros, é bom saber que essa discussão existe e se tiver interesse depois procura fóruns de desenvolvimento pra ver como as coisas estão evoluindo. Eu pessoalmente não tenho muito interesse porque não contribuo com software livre, mas quem contribui precisa entender essa novela. No mínimo é um bom estudo pra saber como a comunidade lida com conflitos assim.

Sobre o Gentoo em si. É um excelente exercício se desafiar em controlar essa besta selvagem. É o extremo oposto de instalar um Ubuntu da vida. Você realmente vai perder muitas horas, muitos dias, em tentativas e erros, lendo muita documentação no Wiki deles, e no mínimo serão horas de muito estudo e aprendizado que uma hora vai ser útil em outras distros de Linux. Todo mundo que tem alguma vontade de brincar no mundo de devops, esse é o hello world do hello world. Se não consegue nem se virar com a instalação de um Gentoo, que tem documentação bem organizada, imagina clusters de servidores mais avançados ou sistemas embarcados mais restritos.

Porém, sobre a filosofia de sempre compilar tudo do zero, acho que é uma faca de dois gumes. Pensando exclusivamente no meu caso. Eu tenho uma máquina parruda, um Ryzen 9 com 64 giga de RAM e todo o espaço em disco que eu precisar no meu NAS de 10 gigabits, com velocidade superior a SSDs. Pra fazer os últimos episódios instalei dúzias de máquinas virtuais de teste. No final, o Gentoo é o que realmente dá sensação de mais responsivo, um pouco mais rápido, e isso provavelmente se deve a ter compilado tudo exclusivamente pra minha máquina, eliminando muita gordura no processo.

Mas como falei antes, instalar X11, Gnome, GDM, na verdade o pacote webkit, custou literalmente umas 3 horas, a CADA tentativa, e até eu descobrir o problema, foram VÁRIAS tentativas. Foi quase um dia inteiro repetindo esse processo até resolver o erro. Enquanto ficava esperando, escrevi quase o script inteiro desse episódio, com tempo sobrando pra revisão. Não tô brincando, é muito tempo. Tudo bem que foi numa máquina virtual. Se fosse no meu hardware nativo, num dual boot, teria sido ordens de grandeza mais rápido. Mas é justamente esse o ponto.

Quem tem hardware parrudo como o meu, não se importa tanto se tá ganhando 1 milissegundo a mais de performance por ter compilado tudo nativo. Os milissegundos que vou ganhar, não compensam a espera em compilar tudo do zero toda hora. Minha máquina já é rápida o suficiente. Mesmo se o binário for mau feito e pesado, vai rodar de boas. Quem realmente precisa da otimização é quem tem máquinas mais lentas ou antigas. Só que agora a compilação também vai ser ordens de grandeza mais lento, nessa faixa de levar mais de 3 horas pra conseguir instalar um simples GNOME.

Ou seja, quem mais precisa da performance extra, vai toda hora perder muita produtividade quando precisar instalar pacotes, porque todo novo software, precisa baixar o código fonte e esperar compilar tudo. Nem sempre é demorado assim, a maioria dos softwares são pequenos. Mas imagina agora quero instalar Firefox, lá se vai mais uma ou duas horas. Agora preciso instalar Ruby, ou Python, mais 1 hora. Você tem que ser disciplinado de não tentar instalar nada grande no meio do expediente, senão acabou o dia pra você. Sério. É meio duvidoso até onde tem vantagem.

O benefício de um Gentoo vem quando você tem uma máquina fraca que não vai ficar usando no dia a dia. Por exemplo, um PC fraco que quer usar como servidor multimídia, ou um roteador de rede, ou um NAS. Uma máquina com um único propósito, idealmente sem nem precisar de interface gráfica, que é a compilação mais pesada. Por isso falei em aplicações de sistemas embarcados, ou IoT. Aí sim, você precisa economizar o máximo de recursos, e quando terminar de instalar, não vai ficar adicionando mais nada. Um Gentoo é perfeito pra isso.

Outro objetivo dos exercícios dos últimos videos é mostrar o seguinte: qual é a melhor distro? Não existe essa resposta. Todas são boas, e em todas roda praticamente todos os mesmos software, é tudo software livre. Em alguns dá mais trabalho ou menos trabalho instalar esse ou aquele software, mas na prática dá no mesmo. Se tiver um dispositivo periférico muito exótico, no final vai ter que compilar kernel na mão de qualquer jeito, e em qualquer distro pode fazer isso. Não é só em Gentoo que pode customizar kernel. No Ubuntu também dá. Só baixar o código fonte, subir o menuconfig, compilar e mandar o grub configurar no boot.

Pra quem é iniciante, povo recomenda instalar Ubuntu ou PopOS da vida porque são triviais, por causa do Calamares, e por serem populares, tem documentação de tudo na internet. Tem fóruns de discussão ativos. Tem salas de chat com gente discutindo a respeito. Vai ser mais fácil de achar solução pra qualquer problema neles. Por outro lado, se usar um distro dessas, não vai aprender nada sobre Linux. Clicar com mouse e arrastar janela não te ensina absolutamente nada. Esquece colocar no currículo "Sei Linux" só porque instalou um Ubuntu. Sabe bosta nenhuma. Só sabe abrir o Chrome e navegar. Isso você faz em Windows ou Mac igual.

Saber Linux é no mínimo estar confortável com tudo que eu fiz nos últimos videos. Saber o que é chroot, o que são pontos de montagem, o que é escalonamento de privilégios, como se customiza a kernel, como configura um bootloader, como diagnostica dependências de binários, como monta um pacote. Olha só tudo que a gente viu até agora. Isso minimamente "saber Linux", e o que mostrei até agora, foi só o hello world, os conceitos básicos. Começa a ler a Wiki do Gentoo ou Arch. Aí você vai ver o quanto ainda falta pra realmente "saber Linux".

Por isso, sim, tente instalar Slackware, tente instalar Gentoo, tente instalar Arch. Esse é o exercício que todo aprendiz de Linux precisa passar. O fim de semana inteiro varando noite de sábado pra domingo, saindo de uma mensagem de erro pra outra mensagem de erro, até ter a satisfação de ver tudo bootando e funcionando no final. Aí sim você sabe que aprendeu alguma coisa de verdade.

Aliás, eu até entendo porque no final tem um grupo de pessoas que defente um Gentoo com unhas e dentes, porque depois de tantas horas e dias dedicado em fazer tudo funcionar na sua máquina, horas e horas esperando tudo compilar e tendo que repetir tudo de novo quando dá erro. Dá muita dó jogar fora e mudar de distro. É meio que síndrome de Estocolmo, já sofreu tanto, agora fica com ele. Mas eu sou um psicopata altamente funcional. Gastei dias configurando tudo, no final jogo tudo fora e pulo pra outra coisa. Quem consegue desapegar de coisas que investiu horas em cima, sempre vai ter mais vantagem, pense nisso.

E o assunto ainda não chegou ao fim, o próximo video vai ser mais conceitos de Linux que você não sabe. Então, se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e compartilhem o video com seus amigos. A gente se vê, até mais!
