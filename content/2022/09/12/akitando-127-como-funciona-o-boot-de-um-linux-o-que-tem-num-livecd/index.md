---
title: "[Akitando] #127 - Como Funciona o Boot de um Linux? | O que tem num LiveCD?"
date: '2022-09-12T18:05:00-03:00'
slug: akitando-127-como-funciona-o-boot-de-um-linux-o-que-tem-num-livecd
tags:
- ubuntu
- calamares
- livecd
- fstab
- systemd
- sysv
- distro
- linux
- akitando
draft: false
---

{{< youtube id="5F6BbhgvFOE" >}}

Instalar distros Linux hoje em dia é muito fácil. Só bootar do pendrive, clicar em "próximo", "próximo" e pronto, tá tudo instalado e funcionando. Qualquer um consegue instalar na maioria das configurações modernas de hardware.

Porém, isso não te ensina nada e ao final você continua não sabendo absolutamente nada sobre o que é um Linux e o que de fato ele faz. Como é o processo de boot? Quais softwares estão envolvidos nesse processo? E mais importante: o que posso fazer quando alguma coisa dá errado? Quais ferramentas tenho à minha disposição? 

Hoje é o dia de finalmente você começar a entender como sua máquina realmente funciona.


== Conteúdo

* 00:00 - Intro
* 01:11 - CAP 1 - Instalar Linux é Fácil | Ubuntu 22.04
* 06:11 - CAP 2 - O que é um Mount Point? | Tudo em Linux são Arquivos
* 11:45 - CAP 3 - Firmwares e UEFI | Quem começa o boot?
* 15:43 - CAP 4 - O que é uma “imagem” ou ISO? | O que tem num LiveCD?
* 26:03 - CAP 5 - O “meta-Linux” antes do Linux | Init RAM
* 31:26 - CAP 6 - Depois do Linux: Daemons | Systemd
* 33:31 - CAP 7 - O que são “Run Levels”? | O jeito SysV antigo
* 40:40 - CAP 8 - O fim do Init SysV? | O jeito novo do Systemd
* 45:04 - Bloopers

== Links

* gnome-cedilla-fix (https://github.com/marcopaganini/gnome-cedilla-fix)

== SCRIPT

Olá pessoal, Fabio Akita

Por hora, finalizei finalmente a minissérie sobre redes e internet e agora é hora de falar um pouco mais sobre Linux  pra complementar os videos de Ubuntu e WSL que já fiz aqui no canal. Tem uma playlist de Software Livre onde falo de assuntos relacionados, caso ainda não tenha assistido e vou adicionar os novos videos nessa mesma playlist. Nos próximos videos vou mostrar um pouco mais em detalhes sobre instalação de algumas distros consideradas mais exóticas, mas hoje quero explorar mais conceitos de Linux e software em geral que talvez vocês não conheçam usando como desculpa a explicação de como um Linux faz boot. Vamos começar a olhar um pouco mais debaixo do capô.



(...)





Pra escolher distros, hoje em dia é fácil. Basta ir em canais de reviews que tem de tonelada, como do camarada DioLinux ou outros que vem crescendo como do Chris Tut. O comportamento padrão vai ser você vendo qual tem o visual que mais te atrai e daí baixar um Deepin ou PopOS da vida, ou se quiser se sentir mais "edgy" e "gamer hipster" da vida, um Garuda. É assim que 99% de todo mundo que usa Linux faz pra escolher. 






Além disso, a instalação de qualquer distro tá super trivial. Você baixa o arquivo de ISO no Windows mesmo, usa um programa como o Rufus pra gravar essa ISO num pendrive. Faz boot pelo pendrive e boom, tem um ambiente ao vivo de Linux já funcionando. Ele detecta sozinho praticamente todo o seu hardware. Se nesse ambiente do pendrive parecer que tá tudo funcionando, daí tem um ícone de instalação. Vai abrir o Calamares, que é o programa de instalação que quase toda distro moderna usa. Por isso mesmo meio que tanto faz qual distro escolher, o processo de instalação é muito parecido.







O passo a passo que o Calamares abre é sempre o mesmo. Começa pedindo pra escolher que língua usa e que layout de teclado prefere. Eu sempre escolho inglês e o layout US international que, até hoje, continua com o mesmo problema de não suportar acento agudo no "c" pra gerar cedilha, mas isso é fácil de consertar com um script que se acha fácil no Google. No caso do Ubuntu, pede pra escolher se quer instalar um monte de aplicativos como LibreOffice, Gimp, aplicativo de fotos e coisas assim, ou uma instalação mínima, que é o que eu prefiro. Eu gosto de já escolher pra baixar os pacotes mais atualizados via internet e também instalar software proprietário de terceiros, como codecs multimídia e drivers de placa de video da NVIDIA.








Se você é iniciante, nem dá bola pra isso, mas no mundo de software livre é uma discussão importante. Por causa de licença de software, toda distro faz um esforço pra ter por padrão somente o que é de verdade software livre, com licenças como GPL ou BSD. Porém, muitos dispositivos, em particular a NVIDIA, não libera o código fonte dos drivers, somente o binário fechado. Mas se você instala isso no seu PC, está concordando com a licença restritiva da NVIDIA e contaminando seu ambiente com software fechado. Do ponto de vista filosófico, não é recomendado. Mas pra nós, usuários finais, meio que tanto faz isso. Por isso sempre habilito, porque eu não sou ativista de software livre. E antes que você vá nos comentários pra dizer que viu notícia que a NVIDIA liberou código dos drivers, nem perca tempo, pra variar é matéria de jornalista bosta que não sabe ler e não viu que eles liberaram só uma pequena parte do código só pra marketing. A parte importante continua fechada e, mais importante, com licença restritiva de uso.








Enfim, o próximo passo costuma ser pra escolher em qual SSD ou HD quer instalar, como quer criar partições e com qual sistema de arquivos. O Calamares costuma ter essa primeira opção que diz o seguinte "eu sei que você não tem idéia do que tá fazendo, então deixa que o papai aqui cuida de tudo pra você". É a opção pra idiotas, quero dizer, pessoas não-técnicas. Ele vai apagar o disco todo e criar as partições automaticamente pra você. No caso do Ubuntu, recomendo pelo menos tentar instalar com o sistema de arquivos ZFS em vez do ext4. Se você não tem idéia do que é isso, não esqueça que eu fiz uma minissérie inteira explicando o que são partições, volumes, como o PC faz boot via EFI, e o que diabos é ext4 ou ZFS. Então vai assistir depois.








Finalmente, o Calamares vai mandar preencher um formulário com seu nome e que usuário e senha quer cadastrar pra poder fazer login depois. Obviamente você deveria escolher uma senha aleatória e forte e não "senha123" ou "teste123". Também te dá a opção de criar uma senha diferente pro usuário "root" que é o administrador da máquina. Mas aqui estou escolhendo a opção preguiçosa que é usar a mesma pros dois usuários e fazer login automático porque só eu vou usar essa máquina mesmo.








E pronto. Acabou. Agora o Calamares vai copiar os arquivos do pendrive pra partição que acabou de criar. Vamos acelerar porque essa é a parte que demora mais, de 15 minutos a meia hora dependendo do seu PC. No final ele configura a carga do boot, e agora é só reiniciar e tá tudo instalado. É absurdamente fácil instalar qualquer distro Linux que usa Calamares hoje em dia. Olha só, vou acelerar aqui o boot, tirar o pendrive, e pronto. Um Ubuntu quentinho recém saído do forno, com tudo funcionando. Se seu PC não for muito bosta, já vai estar tudo detectado, placa de vídeo, som, seu teclado, mouse, wifi e tudo mais. Não precisa fazer mais nada.








Muita gente acha o Ubuntu feio, e eu não discordo muito. Apesar que eles tem melhorado o tema visual e até que hoje, pra mim, não cheira nem fede. Não teria nenhum problema de usar um Ubuntu sem mudar muita coisa. A partir daqui, se você nunca mexeu com Linux antes, veja primeiro o meu video só sobre Ubuntu onde também explico os comandos e conceitos mais básicos que vou assumir que todo mundo já sabe pra continuar este video.







Se escolher um Linux Mint, Elementary, Budgie, Zorin ou PopOS, o funcionamento não vai diferir porque todos são derivados de Ubuntu. Por isso que muito tutorial que funciona no Ubuntu vai funcionar neles também. Cada um tem alguma característica pra se diferenciar. Seja ter um gerenciador de janelas customizado diferente, seja já ter coisas pré-instaladas e pré-configuradas pro usuário não ter que configurar manualmente depois. Mas na prática, pra todos os efeitos e propósitos, é quase a mesma coisa que usar direto Ubuntu.







Antes de continuar, vamos olhar o que fizemos até agora. Um bom programador precisa se acostumar a fazer essas perguntas. Você baixou um arquivo de ISO, gravou num pendrive, e ele logou uma versão light de Ubuntu, sem nem ter instalado nada. Como isso é possível, já parou pra se perguntar isso? Vai, pensa alguns segundos. Como que faz pra bootar um Linux de um pendrive a partir de um mero arquivão com extensão ponto ISO no final?








Se você assistiu minha minissérie sobre armazenamento e sistemas de arquivos talvez já saiba parte da resposta. Deixa eu aproveitar pra mostrar alguns conceitos de Linux pra vocês. Um dos fundamentos inventados no UNIX original e herdado pelo Linux é a idéia de tentar fazer tudo num computador ser representado como se fossem diretórios e arquivos. Por exemplo, talvez já tenha usado o comando `ps` pra listar os programas rodando. Só `ps` sem nada mostra os processos que seu usuário iniciou, mas se usar opções como `ps aux` podemos ver todos os processos que foram iniciados desde o boot pelo usuário `root` também.







Já expliquei em outros videos sobre processos e como eles tem um PID, que é um process ID, um número que identifica um processo e como podemos mandar sinais sigterm, como `kill -9 pid` pra matar um processo forçadamente. Agora, lembrem que todo Linux costuma ter um diretório na raíz chamado `/proc`. Posso fazer `ls /proc/pid` e olha só, aparece um monte de arquivos e diretórios falsos. O que tem dentro desse diretório não são arquivos de verdade, são informações sobre esse processo representado como arquivos. Por exemplo, posso usar um comando normal de arquivos como o `cat` que se usa pra listar o conteúdo de um arquivo texto.








Fazendo `cat /proc/pid/status` temos várias informações sobre esse processo, como quanto de memória ele tá usando. Se eu quiser fazer uma ferramenta parecida com `ps, top ou htop` da vida, posso consultar as informações de cada processo nessa árvore embaixo de `/proc`. Fica de exercício pra vocês fazer uma versão parecida com o comando top ou htop, mas usando python ou javascript ou o que quiser, só lendo do diretório /proc, sem usar syscalls pra kernel. Esse diretório não tem arquivos de verdade, só representações virtuais. Quando der boot, esse diretório desaparece. Se você remover esse HD e ligar em outro PC como HD externo USB por exemplo, não vai ter nada dentro.







Esse diretório é o que chamamos de ponto de montagem, um mount point. Tente digitar o comando `mount` no terminal. Vai aparecer uma lista como essa. Esses são os pontos de montagem ativos atualmente. E que diabos é um ponto de montagem? Num Windows pontos de montagem costumam ser letras como C:, D:, E:. Em Linux são sub-diretórios. Pra explicar isso você precisa entender que, uma coisa é o hardware de armazenamento como um HD ou pendrive. Outra coisa é como o sistema operacional acessa esse hardware.







O que é um dispositivo de armazenamento? Cansei de repetir em vários videos que são dispositivos que gerenciam blocos de bits, ou block devices. Seja um CD, um pendrive USB ou um SSD, todos são dispositivos de bloco. E por acaso, num Linux temos comandos como `ls` que a essa altura você já sabe que significa `listar` e `blk` ou seja listar block devices. E agora sim temos os nomes dos dispositivos plugados no meu PC, por exemplo, o HD principal se chama `sda`. Um segundo HD se chama `sdb`, um pendrive, quando plugar vai aparecer como `sdc` ou `sde`. 







Além de `/proc` existe outro ponto de montagem que toda distro Linux monta automaticamente no boot, que é o `/dev`. De novo, o que tem dentro não são diretórios nem arquivos de verdade. Ele representa os dispositivos de armazenamentol. Por isso em muitos tutoriais por aí você já deve ter esbarrado num `/dev/sda` da vida. Isso não é um arquivo, é um canal pra falar com o HD físico “via” um arquivo virtual. No Windows funciona assim também, o HD principal costuma ter o nome de `\\.\PhysicalDisk1`. Abre um Powershell no Windows e digita `Get-PhysicalDisk`. Por exemplo, esse meu NVME Samsung 970 EVO Plus de 2TB se chama PhysicalDisk2. Num Linux um nome equivalente seria `/dev/sdc`. 









Beleza, o Linux tá enxergando os dispositivos, mas agora como navego dentro desses dispositivos? Agora eu preciso de um mount point. O ponto de montagem é justamente dizer que a partição 1 do drive `/dev/sda` vai ser o diretório raíz "/" e é pra interpretar os bits desse canal usando o sistema de arquivos ext4. Leia o arquivo "/etc/fstab" que significa tabela de file system. Em cada linha vai ter dizendo a partição do disco, o ponto de montagem, o sistema de arquivo e opções, por exemplo, pra abrir só pra leitura, caso seja um CD-ROM. 







Quando espeto um pendrive nesse meu Ubuntu, automaticamente aparece aqui no meu desktop. Isso porque tem um serviço rodando em background que vai rodar pra mim o comando `mount -t vfat /dev/sdc /run/media/akitaonrails/pendrive`, por exemplo. Em distros mais antigas, eu precisaria rodar esse comando manualmente no terminal se quisesse acessar o pendrive. E o equivalente a dar um eject é rodar o comando `umount /run/media/akitaonrails/pendrive`. 







Sacaram? Montar é dizer pro sistema operacional como esse dispositivo foi formatado e onde quero que ele apareça e com qual sistema de arquivos é pra interpretar os bits dentro. No Windows isso é feito em aplicativos com o Disk Management, onde posso mudar o ponto de montagem, que no caso é só uma letra de drive, como E:.









Vamos recapitular o que já expliquei nos videos sobre volumes e partições. Num computador moderno, logo que liga, quem vai carregar primeiro é um software chamado firmware, que muitos ainda chamam erroneamente de BIOS. Mas é o software que não está no HD e sim num chip de memória na placa mãe. Por isso que mesmo num PC sem HD nenhum, se você ficar apertando uma tecla como "delete" várias vezes, entra naquele software de configuração, onde pode atualizar a data e outras configurações do sistema. 






Antigamente esse software era chamado BIOS mesmo, que significa Basic Input/Output System, ou sistema básico de entrada e saída que literalmente tem o básico só pra conseguir identificar seu monitor, teclado e mouse pra você conseguir interagir com o computador antes de tentar carregar o sistema operacional do disco. Mas BIOS era um sistema básico até demais, que só conseguia lidar com identificadores de 16-bits, o que impossibilita usar HDs com mais do que 4 partições. Nos anos 90 isso já era pouco e representava um problema. 









Por isso hoje todo PC moderno tem um firmware UEFI que significa Universal Extensible Firmware Interface. UEFI é um padrão pra firmwares. Além disso antigamente partições eram organizadas com MBR ou Master Boot Record, que é o registro mestre de boot no HD, que são os bits de boot do sistema operacional que a BIOS vai tentar executar logo na sequência. Hoje em dia é UEFI e GPT que é o GUID Partition Table. Eu falei que antigamente estávamos limitados a 4 partições com identificadores de 16-bits. Em GPT, em vez de números, usamos GUIDs que é uma sequência de 32-bits. Números parecidos com esse aqui que você já deve ter visto. Parece aleatório e não são sequenciais. E com isso hoje podemos ter quantas partições de quantos tipos quisermos. Expliquei tudo isso em mais detalhes no video de tudo que você queria saber sobre dispositivos de armazenamento, depois assiste lá.









Gerenciadores de boot como LILO ou Grub foram criados pra conseguir lidar com as limitações de BIOS e MBR. Com UEFI e GPT nem precisa mais deles, o próprio firmware tem capacidade pra fazer boot de qualquer partição GPT, basta ter o bootloader numa partição que o UEFI consiga ler, formatado em fat32, por exemplo. E isso me faz voltar aqui pro nosso Linux de exemplo. Vamos ver o arquivo "/etc/fstab" de novo. Olha só, tem uma partição `/dev/sda1` cujo ponto de montagem é "/boot". E de um terminal normal mesmo, usando comandos mundanos como "ls" podemos ver que tem um diretório chamado `/boot/efi` e é aqui que fica o bootloader, ou literalmente o carregador de boot que o firmware UEFI vai carregar depois do POST.









É nesse ponto que o firmware UEFI pára de executar e dá controle pro bootloader. O bootloader é quem vai de fato carregar a kernel do sistema operacional, no caso o Linux. E é logo um diretório pra trás, em "/boot" que está o Linux de verdade. É um binário executável chamado “vmlinuz” até que pequeno, de pouco mais de 10 megabytes, já compilado com os principais drivers que precisa pra iniciar o sistema, como driver pra ler HD e abrir a partição formatada nele, onde vai estar o resto do sistema operacional. O bootloader vai se encarregar de executar o binário e é nesse estágio que a tal kernel do Linux finalmente vai começar a exercer controle sobre a máquina.







A kernel vai começar a carregar drivers pra ter acesso à memória, aos discos, a periféricos como teclados, monitor e tudo mais. Uma vez que agora a kernel tem controle, ela vai criar um espaço em memória com uma partição virtual, usando um initramfs, literalmente file system de ram de inicialização. Sabe seus diretórios de Linux na raíz do seu HD? Pensa uma versão menor disso, mas montado em RAM. Esse sistema de arquivos estava comprimido junto com a kernel naquele arquivo em "/boot", é esse outro arquivo chamado “initrd.img”, veja que ele é bem maior com uns 100 megabytes. Mas deixa eu fazer uma tangente pra ficar mais claro.








Vamos abrir o terminal de novo. Existe uma ferramenta que costumamos usar pra fazer clones de HDs ou pendrives no nível dos blocos, independente se tá formatado em ext4, ntfs ou fat32. É o comando "dd". E o que significa "dd"? Significa Copy and Convert .. eh, deveria ser "cc" só que CC em Linux já significa "C Compiler", então escolheram a letra seguinte .. eh, programador é uma bosta pra dar nome pras coisas. Mas enfim, dd funciona assim, tem um parâmetro "if" que não sei se era "input file", é onde coloco o caminho do dispositivo que quero copiar, tipo "/dev/sdc" e no parâmetro "of" que talvez seja "output file" coloco o path de pra onde quero copiar.








Aquele programa de Windows chamado Rufus? É mais ou menos a versão gráfica desse comando. Por exemplo, se do terminal de um Linux eu quiser gravar aquele arquivo de ISO no meu pendrive, poderia ter feito `dd if=ubuntu.iso of=/dev/sdc` e pronto. Lógico, tenho que garantir que “/dev/sdc” realmente é meu pendrive, porque se eu confundir com uma partição do meu HD, esse comando vai gravar a ISO por cima e já era meus arquivos que tavam lá. Agora, só pra complicar deixa mostrar mais alguns truques de Linux que talvez vocês não saibam. Naquele ponto de montagem "/dev" que tem representado dispositivos como meus HDs ou pendrives, também temos alguns dispositivos virtuais especiais como "/dev/null" ou "/dev/urandom". 








De novo, podemos usar comandos como `cat` com eles. Vamos fazer `cat /dev/null` e, uau, nada. Como o próprio nome diz, esse dispositivo devolve nulo. Mas muitos scripts gostam de usar ele pra mandar coisas que quero jogar no lixo. Por exemplo, digamos que eu rode um comando que imprima várias informações na tela que não estou interessado. Posso redirecionar o stdout do comando pra /dev/null pra ele ser engolido e mandado pro limbo. Um exemplo besta é o comando "echo" que só imprime na tela. Coloco um sinal de "maior" pra redirecionar pra "/dev/null" e pronto, engoliu o saída. Se começar a fuçar scripts de shell, vai esbarrar mais nisso.









O "/dev/urandom" por outro lado é um dispositivo que cospe bits aleatórios. Muitas funções de muitas linguagens, incluindo as funções da kernel do Linux e bibliotecas de criptografia usam esse dispositivo quando precisam gerar números aleatórios. Tecnicamente, isso é um PRNG ou pseudo random number generator. É um gerador de números pseudo aleatórios. Em computador não existe aleatoriedade verdadeira, só uma aproximação. Teríamos que explorar conceitos como entropia e tudo mais pra justificar isso, mas não é objetivo de hoje, só entenda que existe isso.







Pra hoje, mais importante é outro dispositivo virtual, o "/dev/zero". Assim como o "/dev/null" se eu redirecionar a saída stdout de qualquer comando pra ele, vai engolir tudo. Por outro lado se der um `cat` ou ficar lendo dele, vou receber literalmente nada, só caracteres nulos. Vai cuspindo nulos infinitamente até eu forçar a parada com Ctrl+C. E pra que diabos isso serve? Porque posso usar numa outra ferramenta que aceita dispositivos como parâmetro, como nossa ferramenta "dd".








E se em vez de ler de um arquivo de ISO, eu ler desse dispositivo "/dev/zero"? Vamos voltar ao comando "dd" e fazer `dd if=/dev/zero of=hello.img bs=1M count=10` que significa, leia bits do dispositivo "/dev/zero" e grave num arquivo chamado "hello.img" usando blocos de 1 megabyte de tamanho e contando até 10, ou seja, até gerar um arquivo de 10 megabytes. Pronto. Criei um arquivo cujo conteúdo é só de zeros. Olha só, `ls -la` e o arquivo tem mesmo 10 megabytes. Se usar o comando `cat`, não imprime nada, porque dentro é tudo bits vazios. E mesmo se usar um comando que lê binários como `hexdump`, ele mostra que os primeiros bits são todos 0 e esse asterisco significa que todo o resto é igualzinho à primeira linha até o endereço 10 megabytes.











E pra que diabos preciso de um arquivo totalmente vazio ocupando espaço com bits zero? Bom, em Linux temos comandos pra formatar partições do seu HD como `mkfs.ext4` ou `mkfs.vfat` onde "mkfs" literalmente quer dizer "make file system". Sabe no Windows quando espeta um pendrive, vai no explorar em cima da letra do drive e com o botão direito do mouse escolhe a opção de "formatar"? É a mesma coisa só que na linha de comando de Linux. Vamos formatar esse arquivo então.








No caso, vou formatar com o `mkfs.vfat` pra formatar em FAT32, como eu faria com um pendrive que gostaria de conseguir ler independente de que sistema operacional espetar ele. Só fazer `mkfs.vfat -F 32 hello.img`. Não sei se vocês estão conseguindo entender, normalmente se usa um comando como `mkfs.vfat` na partição de um dispositivo hardware de verdade, como em "/dev/sda1", mas dá pra formatar dentro de um arquivo. E lembra como usando comandos como `cat` ou mesmo `hexdump` só voltava vazio? E agora? O que tem nesse arquivo? Vamos ver.








E temos o cabeçalho de uma partição FAT32. Olha só do lado direito o que ele reconhece como caracteres ASCII com mensagens de erro e dizendo que é FAT32. Essa é exatamente a mesma sequência de bytes que encontraríamos lendo direto de um pendrive. Vamos ver? Vamos plugar o pendrive e fazer o mesmo comando de "hexdump" direto do "/dev/sdb1" e olha só, esse é o pendrive. São os mesmos tipos de bytes. E já sabemos que a partir de um "/dev/sdb1" podemos montar num diretório como "/run/media" da vida. E esse arquivo que acabamos de formatar, dá pra montar também?








Basta criar um diretório qualquer como `mkdir hello` e fazer `mount -t vfat hello.img hello`. Podemos dar `cd hello` e agora estamos DENTRO do arquivo hello.img. Sacaram? Deixa eu criar um arquivo texto qualquer chamado "blabla.txt" com qualquer coisa dentro e salvar. Vamos listar e olha só o arquivo. Agora vamos sair desse diretório com "cd .." e desmontar isso. Só fazer `umount hello`. Se tentarmos listar o conteúdo do diretório hello agora, não vai ter nada, porque o arquivo blabla ficou dentro do hello.img que acabamos de ejetar, como se fosse um pendrive que desconectamos. O arquivo blabla não foi criado dentro desse diretório. O diretório só tava servindo como ponto de montagem PRA DENTRO do hello.img.








Se eu fizer um hexdump no hello.img olha aqui no fim, os bytes do arquivo que criamos tá dentro dele. Este arquivo hello.img, do ponto de vista do sistema operacional é a mesma coisa que um pendrive, só que sem a parte hardware, só os bits, o linguição de bits. Se ficou confuso, vamos repetir. Lembra o arquivo de ISO que baixamos do site do Ubuntu e gravamos no pendrive? É um arquivão que chamamos de “imagem”. Vamos montar aqui no mesmo diretório hello. Só fazer `mount -t iso9660 -o ro ubuntu.iso hello`. No caso, um CD-ROM é formatado no padrão iso9660, não é fat nem ext4. E coloquei a opção de "ro" porque CD-ROM é read-only, só de leitura, não dá pra modificar nada dentro.








Vamos listar o que tem em hello e olha só, todos os arquivos que estão dentro do ISO. É isso que é gravado pelo Rufus num pendrive que queremos dar boot de Ubuntu. Tem o diretório "boot" com o bootloader, o kernel e tudo mais que precisa pra conseguir bootar. É isso que é um LiveCD. Mas o objetivo de toda essa história é pra vocês começarem a largar noções que existe uma entidade física chamada "dispositivo", como um HD ou pendrive, e entender que disposivo de bloco é literalmente qualquer sequência de bits, qualquer linguição de bits, como um arquivo, ou uma conexão de rede. Basta ser formatado de uma forma que dê pra montar com o comando `mount`.








O sistema operacional não tem preconceitos. Pra ele foda-se se você espetou um pendrive ou se montou um arquivão de imagem. Pra ele só interessa: eu consigo ler e gravar blocos de bits? Então tá, pra mim é um drive. E é assim que consigo montar coisas como um Google Drive ou Dropbox como se fosse um pendrive virtual também. Só que diferente de gravar os bits num arquivo local, o driver de sistema de arquivo do Google Drive vai mandar os bits pela rede pra sua conta no Google. Mas pro sistema operacional, foda-se. Ele mandou blocos, o driver de sistema de arquivos recebeu e disse que gravou. O sistema operacional tá pouco se lixando o que acontece com os bits, ele delega e só espera ouvir um "ok, tá gravado" e fica feliz.













O que fizemos com a ferramenta "dd" dá pra fazer o equivalente no Windows com a ferramenta Disk Management. Olha só, temos essa opção de "Criar VHD" que é virtual hard disk, que é o arquivão vazio. Vamos criar um simples de uns 10 megabytes. Uma vez criado posso anexar esse VHD e tornar ele disponível como um PhysicalDisk numerado. Agora ele aparece aqui embaixo, olha só. Ele vai se comportar como se fosse um pendrive ou HD externo. Eu posso escolher a opção pra formatar como NTFS e no final posso montar com um drive, digamos letra P. Agora o P: é um drive virtual e podemos mover arquivos, criar diretórios, o que quiser. E no final é só desanexar, que é o equivalente de ejetar.







De dentro do Linux posso usar aquele comando hexdump nesse arquivão VHD. E parecido com o arquivão hello.img que criamos com "dd", é basicamente um linguição de zeros igualzinho. Olha a linha de zeros e o asterisco embaixo. Mas lá embaixo no arquivo, do endereço a00020 hexa em diante, tem um metadado pra identificar esse arquivão como um VHD. Só por causa desses bytes, que o arquivão que criei com "dd" não se enquadra como um VHD. Mas na prática é quase a mesma coisa: um linguição de bits zeros.







Voltando pro boot do Linux, parei no ponto onde o bootloader EFI o binário do kernel no diretório “/boot”. Esse arquivo normalmente é chamado de vmlinuz, muitas vezes o nome segue com a versão da kernel, como 5.15. A gente costuma chamar uma distro como Ubuntu ou Fedora de “Linux”, mas na verdade Linux mesmo é só esse um arquivo binário, a kernel. O resto do sistema operacional, o certo é chamar de GNU/Linux, ou seja, ferramentas GNU que rodam em cima de um kernel Linux. Quando o bootloader tem acesso a esse arquivo é quando iniciamos a segunda fase de boot.







Normalmente, no mesmo diretório "/boot" vai ter um outro arquivo, um "initrd.img". Esses nomes vão variar de distro pra distro, mas no caso do Ubuntu e todo mundo que é derivado de Debian, o arquivo vmlinuz e o initrd.img são links simbólicos, tão vendo? O arquivo de verdade é esse que termina com "generic" no nome. A vantagem de ser link simbólico é porque posso querer deixar kernels mais antigas depois de um upgrade do sistema. Vai que a kernel mais nova veio com algum bug ou incompatibilidade e ferra meu sistema, impedindo bootar?








Não tem problema, se isso acontecer, basta resetar o PC. Vai voltar pro firmware UEFI da placa mãe que, por sua vez vai carregar o bootloader em "/boot/efi" ou o GRUB, que é aquela tela que tem no começo do boot da maioria das distros Linux. Eu sei que você só dá enter direto sem pensar muito em pra que ela serve. Nessa tela costuma ter uma opção pra justamente poder escolher outra kernel e outras opções de recuperação. Assim dá pra bootar na kernel da versão anterior, que sabemos que funcionava, e ter a oportunidade de consertar alguma coisa. Basta mudar o link simbólico pra kernel e initrd.img anterior e vai voltar a bootar normalmente até sair uma correção pra kernel mais nova. É raro acontecer, mas se acontecer existe essa opção.







Enfim, o arquivo initrd.img é um zipão comprimido, pode ser qualquer formato, a distro que decide. No caso do Ubuntu, eu falei “zipão”, mas não é exatamente um zip como feito pela ferramenta "gzip" mas sim um arquivo formato CPIO comprimido com LZ4, o Lempel-Ziv 4. Eu expliquei o que é Lempel-Ziv no video "De 5 Tera a 25 Giga", depois assiste lá pra saber como compressão funciona. Enfim, o importante é que em Ubuntu podemos usar a ferramenta `unmkinitramfs` pra descomprimir essa imagem em qualquer lugar. 







E olha só, se listarmos o que descomprimiu, vai parecer familiar com a estrutura de diretórios do seu Linux de verdade. Isso é o mínimo que a kernel precisa pra conseguir terminar o boot. Só que aqui descomprimimos essa imagem no nosso HD local. O grande lance é que depois do bootloader conseguir carregar a kernel, ela precisa ter acesso a esses arquivos pra conseguir carregar coisas como driver do seu HD. Por exemplo, e se seu HD tiver partição encriptada com LUKS? Ou se estiver em configuração de RAID dentro de um volume LVM? Como o kernel vai conseguir carregar o driver de RAID pra conseguir montar a partição se já não estiver compilada estaticamente?







São drivers como esse que estão nesse initrd. Só que o initrd em si precisa ser descomprimido em algum lugar. E aqui vou continuar simplificando, mas o que acontece é que a kernel pode não ter acesso ao seu HD no boot. Pode não ter os drivers pra isso. Mas ele tem acesso à RAM. Lembra o lance de criar um um arquivo com o comando "dd" vazio e formatar pra ser um pendrive virtual? Podemos fazer a mesma coisa na RAM, criar um espaço de bits que vai servir pra dar mount num sistema de arquivos e descomprimir o conteúdo do arquivo initrd pra lá. 







Por isso que mesmo se você mandar encriptar sua partição principal ou configurar volumes em RAID, sempre vai ter pelo menos essa pequena partição de boot logo no começo do HD que é formatado em FAT32. Aí o firmware da máquina consegue acesso. Não desperdiça muito espaço, é super pequeno, com não muito mais que uns 100 megabytes. Por isso o initrd é um arquivo compactado, pra caber nessa partição. No Windows mesmo, se você abrir a ferramenta de Disk Management e olhar seu HD, veja, tem essa partição maior onde fica o Windows, e seria o que um BitLocker encriptaria se você escolher. 







Mas olha aqui no começo, tem um partição pequena de EFI, que é o equivalente no Linux ao "/boot" que estamos analisando. Você não enxerga essa partição de boot EFI no Windows porque ele não monta com nenhuma letra de drive, pra não aparecer pros usuários e correr o risco deles estragarem o boot. No caso do Windows, lá no fim do HD tem outra partição escondida sem letra de drive que é a partição de recuperação. Ele é como se fosse o pendrive do Ubuntu que bootamos pra instalar. É o que boota quando você pede pro Windows iniciar em modo de recuperação pra conseguir diagnosticar algum problema que tá bloqueando o boot do Windows principal. É outro Windows, com kernel e drivers separados, em versão reduzida só com ferramentas de diagnóstico e recuperação.







No caso de Linux não temos uma partição assim, porque normalmente usamos pendrive mesmo. Mas é a mesma coisa, a gente gasta um espaço no HD pra ter a comodidade de não ter que sair procurando pendrive se uma hora seu Windows parar de bootar depois de um Windows Update. Já tá tudo no seu HD. Como espaço de HD é barato, podemos desperdiçar algumas centenas de megas. Se você tá pensando em apagar essa partição pra ter um pouco mais de espaço, é hora de pensar em comprar um HD maior, isso sim. Em Macs também tem uma partição escondida com um MacOS reduzido só com ferramentas de manutenção que você consegue acessar se na hora do boot deixar apertado Command + R.







Enfim. Nesse segundo estágio de boot, vamos acabar com um drive virtual em RAM, chamado initramfs ou file system de RAM de inicialização, onde o conteúdo do initrd.img vai ser descomprimido e com isso temos um mini Linux inicializado em memória. Agora sim, a kernel vai ter acesso a drivers extras que precisa e diversas outras ferramentas que pode precisar pra pular pra próxima fase.







Estamos na terceira e última fase do boot. Agora que começa aquela etapa que já viu no boot do seu Linux, quando vai correndo um monte de linhas que eu sei que você nunca parou pra ler. Aquele monte de linhas é o gerenciador de serviços reportando cada um dos serviços que tá conseguindo carregar naquele momento. Esse gerenciador pode ser o famigerado systemd que tem na grande maioria das distros modernas, ou o OpenRC que tem em distros como Slackware ou Gentoo, ou o Runit que acho que é um dos mais antigos, derivados da era dos UNIX originais. Acho que distros baseadas em BSD ainda usam também. Mas seja lá qual for, esse é o primeiro processo que a kernel vai carregar no seu sistema, o famoso processo com ID 1, o PID número 1. 









Agora sim, esse sistema de inicialização vai se encarregar de carregar todo o resto dos serviços necessários pra ter um sistema usável. Agora ele consegue acessar a partição principal do seu HD e ler o arquivo "/etc/fstab", que é a tabela de file systems onde tá declarado que partição é pra montar como "/", a raíz do seu sistema operacional. Ele vai dar mount em tudo que precisa, incluindo os mounts especiais como o /proc, /dev, /sys. Vai carregar os serviços de USB pra achar seu mouse ou sua webcam, serviço de bluetooth que vai conectar com seu fone de ouvido, serviço de network que vai carregar seu wifi, serviço de dhcp client que vai pedir IP pro servidor de DHCP do seu roteador de internet e assim por diante. 







Eu zoei que você nunca prestou atenção nesse monte de linhas subindo no boot porque vai rápido demais mesmo. Pra ver em detalhes o que aconteceu, use o comando `dmesg` depois do boot que lá vai ter essas linhas. Se um serviço deu pau, use o comando `systemctl statusad  e o nome do serviço pra ver se tem alguma dica. Esses serviços tem mais um detalhe na realidade. Logo que a kernel carrega um systemd ou runit, ele tem que ver em qual runlevel vai rodar. Isso também meio que varia, especialmente entre Linux e UNIX ou BSD, mas todos tem conjuntos diferentes de serviços que carregam em runlevels diferentes. Mas, Runlevel? Aí fodeu, deixa eu voltar na história um pouquinho.






Vamos voltar pro boot, a kernel tá carregada, ele carrega seu primeiro programa, de process ID 1, que antigamente era chamado simplemente de "init". Esse init ia num diretório como "/etc/rc3.d" e lá ia achar vários links simbólicos pra scripts que costumavam ficar em "/etc/init.d". Então cada sub-diretório "rc1.d" ou "rc3.d" podia ter coleções diferentes de links simbólicos de scripts.






Os scripts em si ficavam em "/etc/init.d". É o que a gente chama de serviços ou daemons. Eram scripts de shell, que aceitavam parâmetros como "start" ou "stop" e dentro configuravam e executavam algum binário, por exemplo, programa e impressora pra montar o spool de impressão, ou o programa X que carrega a interface gráfica e assim por diante. Um daemon é um programa executável normal, com a diferença que tem esse script que inicia ou termina o programa. E o sistema de init executa esses scripts pra inicializar os serviços durante o boot do sistema.






Agora, nesse tal de "/etc/rc3.d" o “rc” é acrônimo pra "run commands" ou rode comandos do "runlevel" ou nível de execução 3. Parece complicado mas originalmente cada runlevel tem uma função específica, o runlevel 0 é pra procedimento de shutdown, o runlevel 6 pra reboot. Runlevel 1 é pra bootar em modo de um usuário só. Runlevel 3 é pra multi-usuário com rede. Runlevel 5 costuma ser pra bootar com interface gráfica. 






Se você é de Windows, ele vem com pelo menos 2 runlevels, o do boot normal que cai no Windows e aquele "Modo de Segurança" ou "Safe Mode", lembra? Que boota o Windows sem carregar todos os drivers e serviços, daí você fica sem rede, com resolução baixa, tudo pra quando tiver algum problema no boot, ter um ambiente pra bootar sem carregar quase nada, pra te dar a oportunidade de diagnosticar e consertar o problema. Runlevel é isso, quais conjuntos de serviços vai carregar ou não.






Vamos ver isso na prática. Abrindo o terminal de novo, podemos digitar o comando `runlevel` e vai dizer que estamos com o runlevel 5 carregado. Digamos que instalamos algum programa gráfico instável que travou tudo. Teclado não funciona, mouse não funciona, nenhuma janela se mexe. Vou simular carregando o Firefox. Faz de conta que foi ele que travou tudo. Nesse ponto a maioria de vocês ia apertar o botão de reset e rebootar. Mas a gente que é de Linux tem outra saída: usar a combinação de teclas Ctrl + Alt + F3 pra mudar pro runlevel 3 que é de multi-usuário com rede em modo texto.







Olha isso, saímos do modo gráfico, que continua rodando no runlevel 5. Agora fazemos login em modo texto e podemos usar comandos como `ps aux | grep firefox`. Lembra? Na nossa historinha, ele travou tudo, então vamos matar forçadamente com o comando `kill -9` e o PID dele. Pronto, agora podemos voltar pro modo gráfico. Normalmente eu diria que é só apertar a combinação Ctrl + Alt + F5 mas por alguma razão quando tava escrevendo o script do episódio, isso não funciona, mas Ctrl + Alt + F1 funciona. Enfim, veja como o programa de terminal continua aqui, mas o Firefox morreu. A resolução que zoou aqui, mas deve ser porque tá rodando numa máquina virtual. Esse é um dos jeitos de tentar destravar alguma coisa antes de ser drástico e dar reset na máquina toda.








Dá pra mudar de runlevels no terminal também usando o comando `telinit` com o número do runlevel. O runlevel 1 na realidade é usado pra manutenção e diagnósticos. E se você mudar pro runlevel 6, isso vai dar reboot na máquina, vamos ver? `sudo telinit 6` e olha só, rebootou. Sabe quando você usa no terminal comandos como `shutdown` ou `reboot`? É isso que ele tá fazendo, mudando pro runlevel 6. E por que isso é importante? Runlevels determinam quais conjuntos de serviços iniciar ou desligar.






Você nunca quer forçadamente apertar reset. Tem vários programas rodando em background, coletando arquivos de log, tem partições montadas que podem ainda não ter feito flush de caches. Você quer notificar todos os programas rodando pra fechar e limpar as coisas antes de realmente desligar a máquina, é o que chamamos de graceful shutdown ou desligamento gracioso. Se ficar dando reset forçado, uma hora vai corromper arquivos ou partições no sistema, por isso nunca force desligar, sempre dê halt, que é mudar pro runlevel 0. Vamos desligar? `sudo shutdown -h now` ou simplesmente `sudo telinit 0`.








Na prática, quando o sistema boots, a kernel carrega e inicia um processo 1 como o antigo "init" ou o atual "systemd", ele vai carregar o conjunto de serviços declarados pro runlevel padrão, que costuma ser o runlevel 3 em servidores que não tem interface gráfica ou o runlevel 5 em desktops e PCs como de vocês assistindo, que vai bootar os serviços pro modo gráfico. Na prática significa que você tem diversas formas diferentes de bootar, só que o padrão pra maioria das instalações é entrar no runlevel 5 que é gráfico. 







Vamos fazer outro exercício. Digamos que de jeito nenhum consigo entrar no modo gráfico depois de um upgrade ou script mal feito que rodei na máquina, sei lá. Não boota. Nesse ponto a maioria das pessoas já ia pensar "que bosta, cadê meu pendrive, vou reinstalar tudo do zero". Calma! No Ubuntu, ele faz como o Windows, tenta ir direto pra tela gráfica. Mas se antes do computador ligar deixarmos a tecla shift apertada, a tela do GRUB vai aparecer. 







GRUB é acrônimo pra Grand Unified Bootloader. Como o nome diz, é um bootloader. É ele que o computador vai carregar no boot, e depois se encarregar de achar a kernel do Linux e passar o controle pra ele. O Ubuntu sempre boota com Grub, mas ele carrega quieto, por isso que nunca vemos. Com a tecla shift apertada forçamos a aparecer. Por padrão vai bootar com essa primeira opção aqui, mas podemos apertar a tecla "e" pra editar os comandos de boot da kernel. Daí vamos pra essa linha aqui embaixo e no final escrevemos o número 3, indicando que queremos bootar no runlevel 3 em vez do padrão que é o 5. Com ctrl + x saímos e vai bootar os serviços do runlevel 3, e olha só, não carrega mais o modo gráfico, podemos logar em modo texto e tentar consertar seja lá o que eu fiz de errado. Daí, no próximo boot vai normalmente pro runlevel padrão que é o 5, de modo gráfico.








Então a sequência é sempre essa: computador liga, carrega o firmware UEFI da placa mãe que vai inicializar o hardware e os dispositivos. Ele vai procurar a primeira partição no HD ou pendrive que tenha o diretório /boot/efi. No nosso caso, dali vai carregar o bootloader do GRUB. O GRUB por sua vez tem uma configuração, que foi o que editamos agora, que diz onde tá a kernel e onde tá a imagem do initrd. Executa a kernel, monta uma partição temporária na RAM chamada initramfs e descomprime a imagem do initrd lá. 







Finalmente, a kernel vai carregar um gerenciador de serviços como o systemd como processo número 1 que, por sua vez, vai começar a carregar o resto dos serviços, conforme declarado na runlevel padrão. Cada serviço tem declarado quais outros serviços ele precisa esperar carregar, qual dependência tem, e é isso que vai aparecendo naquele monte de linhas que vai subindo na sua tela no boot. Até finalmente terminar de carregar o servidor Xorg, e o gerenciador de login, no nosso caso, o GDM do GNOME e é aí que aparece a tela gráfica de login.











Esses conceitos de runlevels, diretórios de scripts de serviços em "/etc/init.d", links simbólicos pros scripts em diretórios como "/etc/rc5.d" e o processo chamado "init" que era o antigo gerenciador de serviços, é o sistema que chamamos System V ou SysV que nasceu nos UNIX originais. Foi assim que eu aprendi em UNIX dos anos 90, e é assim que gerenciadores como o Runit e acho que o OpenRC ainda funcionam. Mas em distros modernas, nada disso vale mais, pode esquecer tudo que eu falei.







Distros como Ubuntu, Fedora, OpenSuse, Manjaro e muitos outros, especialmente se usam gerenciador de janelas GNOME, aderiram ao SystemD e ele descarta todos esses conceitos. Não existe runlevels em systemd e sim targets. E apesar de ter diretórios como "rc3" ou "rc5" eles não são mais usados. Em vez disso existem diretórios como "graphical.target" ou "multi-user.target". E eles tão espalhados em diversos diretórios como "/etc/systemd/system" ou "/usr/lib/systemd/system" e assim vai. Ele tenta simular o comportamento dos runlevels pra manter compatibilidade com comandos como `telinit` que usamos antes.







É uma das razões de porque tanta gente odeia o systemd e você vai achar fios de reddit e grupos em discord de gente xingando. Eu mesmo não entendo o systemd a fundo, nem de perto. Ele faz bem mais que o Init de SysV antigo e tenta fazer muito mais coisas por baixo dos panos. Eu me acostumei a usar, mas quem desenvolve pra Linux deve ter mais motivos técnicos de porque isso incomoda. Só o fato de mudar conceitos tradicionais com runlevels pra targets, deve dar um trabalho extra pra manter software pra diferentes distros que não aderiram a esse novo padrão. 






Por exemplo, em "/usr/lib/systemd/system" tem esses links simbólicos que tenta equiparar o que seriam os antigos runlevel numerados com os atuais targets. Veja, o runlevel5 é um link simbólico pra graphical.target. O runlevel6 é link pro reboot.target. Vamos ver o que é o graphical.target e olha só, é uma configuração que fala que requer carregar a mesma coisa que o multi-user.target, o antigo runlevel 3, mas também quer carregar o display-manager.service. Faz sentido, o modo gráfico nada mais é do que o modo multi-usuário que carrega em texto, mas carregando o serviço de tela pra mostrar interface gráfica.







No terminal, com o comando "runlevel" ainda consigo ver os runlevels rodando agora, e com o novo comando `systemctl get-default` consigo ver que o target padrão de boot é o graphical.target. Se quiser mudar pra das próximas vezes bootar em modo texto, posso usar o comando `systemctl isolate multi-user.target`, que é mais ou menos o equivalente antigo a usar o comando "telinit". Cuidado ao fazer isso porque ele vai rebootar o sistema, mas não vai mudar o target padrão, que ainda vai ser graphical.target.







Pra todas as vezes bootar só em modo texto, posso mudar o target padrão fazendo `systemctl set-default multi-user.target`. Esse comando "systemctl" você vai ver em diversos tutoriais. Quando instala Docker por exemplo, o tutorial costuma mandar habilitar o serviço pra carregar em todo boot fazendo `systemctl enable docker`, que vai adicionar no target de graphical.target. E pra carregar o serviço na hora pode fazer `systemctl start docker`. Pra ver se o serviço tá carregado, basta fazer `systemctl status docker`, e pra ver todos os serviços que estão carregados agora é só rodar `systemctl --type service`.







A maioria dos tutoriais hoje assume que você está usando uma distro com systemd e por isso sempre vai pedir pra rodar comandos como `systemctl start`. O systemd em si faz bem mais coisas que iniciar ou rebootar serviços, então recomendo que leia sobre ele em wikis como do site do Arch ou Gentoo, que costumam ter exemplos de como usar e mais detalhes do funcionamento. Como disse antes, eu mesmo não sei todos os detalhes dele.







Enfim, o objetivo de hoje foi juntar o antigo video de Ubuntu e um pouco dos videos de WSL2 com a minissérie sobre armazenamento. Recomendo que assistam agora se ainda não viram. Pra continuar a minissérie, no próximo episódio quero explicar mais conceitos de Linux mostrando como uma instalação realmente funciona, então se ficaram com dúvidas, mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal pra não perder o próximo episódio e compartilhe o video com seus amigos. A gente se vê, até mais!
