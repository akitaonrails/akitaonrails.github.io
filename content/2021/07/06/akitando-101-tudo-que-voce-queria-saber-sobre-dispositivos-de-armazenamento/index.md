---
title: "[Akitando #101] Tudo que Você Queria Saber Sobre Dispositivos de Armazenamento"
date: '2021-07-06T11:08:00-03:00'
slug: akitando-101-tudo-que-voce-queria-saber-sobre-dispositivos-de-armazenamento
tags:
- UEFI
- SSD
- NVME
- NAS
- Thunderbolt
- USB
- RAID
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/c3hOS8BGbZo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

### DESCRIÇÃO

É dia de falar tudo que você sempre quis saber sobre todas as sopas de letrinhas do mundo de dispositivos de armazenamento, desde MBR, GPT, EFI/UEFI, RAID, DAS, NAS, SAN, SSD, NVME, USB, Thunderbolt e muito mais!

### Conteúdo

* 00:00 - Intro
* 01:01 - Master Boot Record
* 03:32 - GPT
* 06:39 - EFI/UEFI
* 09:27 - processo de boot
* 10:41 - Secure Boot
* 13:40 - HDs como Livros
* 16:02 - Partições e Volumes
* 17:08 - RAID 0
* 17:51 - RAID 1
* 19:03 - RAID 1+0
* 19:43 - RAID 5
* 19:59 - DAS
* 20:42 - Entendendo SSD
* 21:57 - Protocolos USB
* 22:53 - NVME
* 23:50 - Conectores USB
* 24:50 - Thunderbolt
* 25:17 - HDMI
* 26:22 - Tipos de SSD
* 28:43 - Cabos Ethernet
* 30:31 - NAS
* 31:59 - Video ocupa MUITO espaço
* 34:30 - SAN e Cloud
* 36:20 - Character vs Block Device e BSD
* 39:33 - Conclusão


### SCRIPT

 Olá pessoal, Fabio Akita


No episódio anterior eu contei um pouco sobre meus servidores de arquivos, o Drobo e o Synology, algumas noções sobre RAID, e desci um pouco no detalhe sobre fdisk, sistema de coordenadas CHS e LBA. Hoje vou continuar essa saga falando sobre boot. Como um computador entende seus HDs. 




No episódio anterior eu parei a instalação daquele RedHat de 1997 explicando sobre cilindros e como do sistema de coordenadas de cilindro-cabeça-setor chegamos no LBA que é um endereçamento linear. Acho que o mais importante era entender que num HD ou pendrive ou qualquer dispositivo de armazenamento a gente não lê e escreve dados bit a bit ou byte a byte e sim em blocos, no caso em setores, que normalmente são blocos de 512 bytes. Mas beleza, particionamos o HD com `fdisk` e agora, como o computador boota minha máquina?





(...)






No nível do sistema operacional você ainda tem as opções de escolha de como particionar o disco. Falando rapidamente, antigamente e até em algumas máquinas não atualizadas de hoje, o sistema mais usado era MBR ou Master Boot Record. É um setor especial no primeiro cilindro reservado como setor de boot. Os primeiros 512 bytes.







Quando o computador boota, precisa iniciar algum programa, uma primeira instrução. Essa vai ser a BIOS, um firmware que hoje é atualizável. É um chip persistente que independe do seu sistema operacional. A BIOS vai detectar o hardware, configurar sua máquina e deixar disponível pra uso. No final desse programa vai ter uma instrução de JUMP pra um endereço fixo no primeiro HD que ele encontrar. No caso o endereço com segmento 0000 e offset 7C00.







Parêntese, se você assistiu o episódio da CPU montada em protoboard do Ben Eater que expliquei no Guia Mais hardware de Introdução à computação e um dos mais recentes que foi explicando sobre os 640 kilobytes de RAM, você entendeu 100% do que acabei de falar. Instrucões, jump, segmentos. Se não entendeu, recomendo assistir esses episódios depois.







Depois ele vai checar o cabeçalho da estrutura até achar 55 AA. Essa sequência identifica um MBR. Daí vai encontrar uma estrutura, literalmente como uma struct de structs de C. A estrutura do MBR permite registrar até no máximo 4 partições. 






Era o que cabia no espaço que foi definido e pra época provavelmente acharam que era suficiente. E as configurações nessa struct tem tamanho fixo. Por isso que não dá pra plugar qualquer HD moderno num computador antigo e por isso que no fdisk antigo você vê que ele só deixa cadastrar 4 partições.






O máximo que dá pra ter é 2 elevado a 32 vezes o tamanho padrão do setor que são quinhentos e doze bytes. Isso dá 2 terabytes. Então máquinas antigas com MBR não conseguem ter partições maiores. 






Ah sim, falei 2 elevado a 32. Lembram do tal LBA que falei no episódio anterior? É uma lista de 32-bits. Então só vai ter endereços pra 2 elevado a 32 setores. A distinção aqui é importante. Em outros episódios eu falava de listas ou arrays onde cada endereço apontava pra um byte. 






Mas a gente pode apontar qualquer coisa e um LBA é uma lista onde cada elemento aponta pra um setor. E cada setor tem X bytes. Quanto maior o setor maior a partição que daria pra usar. Acho que MBR não suportava setores de 4 kilobytes por exemplo. Então o máximo vai ser esse mesmo.






Tem jeito de gambiarrar isso um pouco com partições extendidas. Mas é gambiarra, nem vou explicar, mesmo porque hoje em dia ninguém mais usa MBR em computadores e laptops, o normal é usar GPT ou GUID Partition Table que, como o nome diz, vai usar GUIDs pra identificar as partições.






Se ficou confuso, no MBR você identificava as partições com 4 números, de 1 a 4. Mas no GPT você vai identificar a partição com um numerozão de 128-bits. Não só partição, mas tipo de partição também. Se você assistiu meu episódio sobre criptografia, eu explico GUIDs lá. Mas em resumo, quando a gente quer dar um número que tem alta probabilidade de ser único, usamos ou UUID ou GUID, no caso GUID é a versão da Microsoft do conceito de Universally Unique Identifier, GUID é Globally Unique Identifier. Quase mesma coisa.







Usar números inteiros sequenciais pequenos é garantido que alguém já vai estar usando. É que nem quando você tenta cadastrar seu apelido numa plataforma qualquer. Certeza que já tem um joão cadastrado e você é obrigado a cadastrar tipo um joão99123 e até isso já deve existir. Por isso muitas plataformas pegam seu apelido e concatenam um número aleatório no final, como o Discord. 








Não usar números sequenciais é uma boa prática e outro dia eu falo sobre isso em particular, mas o ponto é que suas partições são identificadas com um GUID. O GUID é um número binário de 128-bits. E ele é representado em 5 blocos legíveis em hexadecimal. Por convenção a gente separa esses blocos com hífen pra ficar mais fácil se precisar digitar manualmente.








Vamos recapitular porque foi muita letrinha de uma vez só. Toda a explicação sobre cilindros e cabeças foi só pra relembrar como era antigamente, mas hoje é LBA, uma lista linear de endereços de 32-bits em máquinas antigas com MBR e 64-bits em máquinas modernas com GPT. Elas representam o mapeamento de setores no seu HD. Com 32-bits e setores de 512 bytes daria pra no máximo endereçar 2 terabytes de HD. Mas com 64-bits a gente tem capacidade pra ir até um HD de vários Zetabytes. Um zetabyte é tão grande que se você pegar todo o conteúdo da Internet, não ia chegar perto disso.








A gente quer conseguir endereçar tamanhos absurdos porque mesmo não tendo um único HD de mais do que terabytes, você sabe que existem recursos como stripe ou RAID-0. Nada impede alguém de tentar ir ligando vários HDs gigantes num único volume. 





No fim da vida de MBR a gente tava limitado no tamanho do HD porque não tinha endereços suficientes, mesmo problema dos 640 kilobytes de RAM, mas depois que migramos pra LBA e GPT agora temos endereços sobrando e quantidade de partições sobrando.







MBR ou GPT são estruturas de dados, como structs de C, que tem campos de tamanho fixo pra armazenar a configuração do seu HD e das partições. O HD é dividido em partições e as partições são divididas em setores. Daí os primeiros setores do primeiro cilindro são ocupados com essas estruturas. Na verdade você começa a partição propriamente dita mais pra frente na lista LBA. Mas é tudo o mesmo linguição de bytes no HD, é tudo uma questão de quantos setores você quer perder pra guardar esses metadados.








No caso de GPT, ele precisa de uma partição ESP que é EFI system partition. Aí fodeu, que GPT existe mais uma sigla junto que é EFI e UEFI. Em resumo é o seguinte, o esquema BIOS e MBR ficou velho muito rápido na virada do século daí surgiu Extensible Firmware Interface ou EFI da Intel que define uma nova interface pro sistema operacional conseguir falar com o firmware.








Mas em 2005 o EFI foi atualizado pra virar UEFI. No mundo open source, quando você boota um virt-manager da vida, pra rodar uma máquina virtual vai ver que o logo que aparece é da TianoCore que desenvolve uma implementação de UEFI aberta chamada EDK2. Se você é das antigas, o que a gente chama de firmware hoje é o que antigamente era mais conhecido como BIOS. Na prática é o primeiro código que qualquer computador executa.








No caso de HD, o primeiro setor é o boot sector ocupado pela estrutura MBR. E continua sendo assim por motivos de compatibilidade. Vai ter a estrutura de dados antiga, mas se você tentar rodar ferramentas velhas tipo o fdisk de 1997, ele ainda vai encontrar o MBR lá, mas as partições de verdade não estão mais lá, vão estar em setores mais pra frente. Acho que são uns 32 setores pelo menos, com 512 bytes cada, significa que os primeiros 16 megabytes do seu HD você já não tem, porque é lá que ficam as informações pro resto.










A idéia do GPT é facilitar fabricantes e desenvolvedores de extender os metadados. Digamos que o Windows precisasse identificar uma partição como sendo de Windows, que número ele usa? Se escolher 1, e se agora a Apple também quiser usar 1 pro tipo dele? Daí que usar GUID é mais prático. Eles podem escolher um GUID qualquer e a chance de alguém já ter escolhido o mesmo é muito baixa. Em qualquer documentação sobre GPT você vai achar tabelas como essa que listam os GUIDs pra tipos de partição por exemplo. 
















E em sistemas UEFI tem essa partição especial pequena que  se chama EFI system partition ou ESP. Se você é de linux já deve ter visto um /boot fora da sua partição principal. Pra ser universal ela costuma ser formatada em FAT, normalmente VFAT ou FAT32. E quando o UEFI termina de bootar, ela aponta pra essa partição e carrega o que tiver lá, que no caso do Linux é onde vai ter o bootloader e a kernel mais drivers.







No caso de Mac ele força que essa partição seja em HFS+ que é o filesystem antigo deles, e no caso do Windows em vez de ser /boot costuma ser /EFI/Microsoft/Boot, mas é a mesma coisa. Essa partição especial costuma ficar escondida, mas sabendo que ela existe você pode montar ela num diretório usando comandos como `mount`. Inclusive num Linux, quando você baixa e instala uma kernel mais nova, ao rodar comandos como `update-grub` da vida, ele vai atualizar a imagem vmlinuz que contém a kernel e drivers, nessa partição.









Quando a UEFI termina o que tinha pra fazer, no final do procedimento de POST que é sigla pra Power-on self-test, daí vai lá nos primeiros setores do primeiro disco e acha a tabela de partições. E dentro procura se tem uma partição com um tipo especial de GUID que começa com C12A e termina em C93B. Em todo computador com sistema operacional instalado vai ter ela, que é o ESP ou partição de boot.







Encontrado essa partição então consegue montar e ler os arquivos dentro. Se você tiver mais de um sistema operacional na mesma máquina, vai ter mais de uma configuração de bootloaders ali. Encontrado o bootloader, também acha a imagem do sistema operacional. No caso do Linux acho que cria uma ramdisk ou initial ramdisk, onde vai carregar um filesystem mínimo e continuar o processo de boot.






É o mínimo do mínimo que precisa carregar pra continuar lendo as outras partições que estão na tabela e montar com os filesystems adequados, como ext4 no caso de Linux ou NTFS no caso de Windows. Agora ele consegue abrir a partição principal, montar a raíz e ler as configurações num diretório como /etc ou o Registry no caso do Windows e segue subindo serviços, daemons, e tudo mais pra completar o boot do sistema até chegar na tela de login.







Aliás, se você tá prestando atenção deveria estar se perguntando, mas se no processo de boot ele vai pegar seja lá que bootloader e seja lá que imagem estiver nessa partição aberta de FAT, não é perigoso? Alguém malicioso ou algum virus não poderia modificar essa imagem e fazer ele carregar alguma coisa ruim? 







Este não é um episódio sobre segurança então detalhes ficam pra outro dia. Mas sim, isso inclusive acontece de verdade e quando um virus ou programa carrega antes da sua kernel, ela consegue se injetar e ter privilégios de kernel. É isso que faz um rootkit. Se conseguir se injetar na kernel antes do boot, seu sistema operacional não vai conseguir detectar e ele teria a capacidade de enganar os antivirus que carregam depois, ou até comprometer os executáveis dos antivirus. Quando um programa malicioso se carrega no espaço privilegiado da kernel, ele tem acesso a basicamente tudo, é game over.








Na prática você precisou ser bem imprudente com o que instala na própria máquina. Nesse caso, rootkit ou não você tá inseguro de qualquer jeito já. Ou, você já deixa sua máquina desprotegida, qualquer um pode usar, e aí também é inseguro. Se alguém tem acesso a sua partição de boot, sua máquina tá escancarada por definição. Se você faz trabalho importante não deveria deixar aberto.









Tem gente que não sabe disso, mas conexão Thunderbolt e USB tem defeitos e bugs, e um pendrive preparado com software malicioso, só de plugar na sua máquina vai conseguir injetar malwares ou no mínimo causar um monte de problemas. Por isso em corporações tem até políticas pra proibir espetar um pendrive no notebook. Além disso UEFIs mais novas tem uma coisa chamada Secure Boot.








Resumindo, na instalação do sistema operacional, ela permite registrar um certificado digital numa área segura e assinar os binários que precisam carregar no boot como kernel e drivers. Daí em todo boot a UEFI vai checar se o binário foi modificado ou não. Se algum rootkit da vida ou alguém manualmente tentou trocar os binários então a checagem da UEFI vai falhar e ele não vai deixar bootar. Procure saber sobre isso.








Aliás, se você é gamer de jogos da Riot por exemplo, já teve que desligar o Secure Boot da sua máquina porque o sistema de anti-cheats ou anti-trapaça deles funciona como um rootkit, um driver que carrega junto com a kernel, alterando seu boot justamente pra você não ser capaz de desligar o anti-trapaça. E não é só a Riot que faz isso. Foi uma controvérsia boa porque desligar o secure boot é desligar segurança da sua máquina e isso é super intrusivo. Não sei se ainda funciona assim, mas isso é bem tosco, pra dizer o mínimo.










Parece complicado, mas ainda estamos só começando. Durante a primeira década dos anos 2000 a gente tava em transição da arquitetura de 32-bits pra 64-bits, e ao mesmo tempo fazendo a transição da BIOS com MBR antigo pra GPT e EFI e depois UEFI. Foi uma bela de uma zona pelo que me lembro, mas hoje em dia tá mais normalizado e estável. Depois de ter passado todas essas transições, eu diria que a era de 64-bits finalmente parece bem mais com o conceito de "plug and play" que vinham prometendo pra gente desde os anos 90.








Voltando pro HD, deixa eu tentar ilustrar o conceito. Os primeiros setores dessa fita é como se fossem o índice de um livro, dizendo de qual página até qual página fica cada capítulo, que seria a partição. Faz de conta que meu livro tem um índice que diz que da página 1 até a página 50 é o primeiro capítulo e da página 51 até a página 100 é o segundo capítulo.








Pra apagar o segundo capítulo, basta apagar do índice que esse capítulo existe. As páginas em si continuam no livro, mas ela só não é mais identificada. Eu não sei se da página 51 até o fim é uma partição só, ou se antes tinha dois capítulos de 25 páginas cada por exemplo. Mas o que tinha escrito nas páginas continua lá. Quando a gente apaga alguma coisa, não é que o HD foi nessas páginas e apagou tudo que tava escrito. Ela só tirou do índice.







Por isso que é possível reparticionar um disco sem perder dados. Voltando no exemplo dos dois capítulos, digamos que eu quero aumentar a segunda partição. Pra isso eu poderia ir no índice e escrever que o primeiro capítulo é só da página 1 até a 25 e da 26 até o 100 é o novo segundo capítulo.







Se as páginas estavam todas em branco, não vai fazer nenhuma diferença. Mas e se já tinha coisa do primeiro capítulo escrito lá pela página 40? A diferença de HD pra livros é que a gente não vai escrevendo necessariamente em ordem sequencial, tipo preenche toda a página 1, depois vai pra página 2 e assim por diante. A gente cria arquivos, apaga arquivos, atualiza, então vai ficando fragmentado. Pode ter metade da página 1 usada, página 2 em branco, página 3 cheia e assim vai. Portanto toda página, em média, vai ter espaço sobrando se o HD não estiver totalmente cheio.








Então eu vejo o que tem na página 26 até a 50 e se o que tem escrito lá couber nas páginas anteriores, posso copiar tudo pra lá e agora sim, reescrever o índice pro capítulo 1 ser da página 1 até a 25 e o capítulo 2 ser da página 26 até a 100. E é assim que se redimensiona partições. Só não vai dar pra reparticionar se o primeiro capítulo já tava quase cheio, daí não tem como.








No MBR antigo, nosso livro só podia ter até 2 terabytes, e só podia ter 4 capítulos ou partições. Com GPT, agora podemos ter milhares de partições e cada uma com praticamente quanto espaço a gente quiser, porque o hardware ainda não chegou nos limites estabelecidos no GPT. Lembra? zetabytes. Agora, o sistema operacional, sabendo onde começa e onde termina cada partição, quantos setores tem, toma conta e se encarrega de formatar a partição.









Vou falar de filesystems no próximo episódio. Mas a história de partições não acaba aqui. Se você presta atenção a nomenclaturas já deve ter visto a palavra "partição" mas também a palavra "volume". Como a gente já viu, uma partição é uma divisão lógica de um HD ou qualquer outro dispositivo de armazenamento, como um pen drive. Um pen drive também pode ter mais de uma partição.








Já um volume é uma abstração do sistema operacional. No caso mais comum a gente pode ter uma partição de boot EFI, uma partição principal do sistema operacional e todos os seus programas e dados, e talvez uma terceira partição pra swap no caso de um Linux. Aliás, essa terceira partição hoje em dia é opcional porque é mais comum um swap ser só um arquivão na partição principal mesmo.







Então a gente tá acostumado a ter só uma partição que por sua vez é um único volume. Num Windows cada volume costuma ser uma letra, tipo C:, D:, e assim por diante. Quando você espeta um pen drive no seu computador, vai aparecer um novo volume montado como um E:. No caso do Linux volumes são montados como diretórios e podem aparecer como em /run/media/pendrive por exemplo. 







Mas lembrem-se do caso que eu expliquei lá no começo do video, sobre RAID, e o caso mais simples como o RAID-0 que é stripe. Você instala dois HDs de 1 terabyte no seu computador. No caso normal, vai formatar um como volume C: e o outro como volume D:. Mas digamos que você não queira um segundo volume e na verdade quer que os dois HDs sejam combinados. Dá pra fazer isso, você cria um volume lógico que é a combinação dos dois HDs.







Pro Windows, mais espeficificamente pro sistema de arquivos NTFS, vai ser um único volume de 2 terabytes. O volume é uma forma de organizar partições no mesmo HD ou até em HDs diferentes como um único armazém de dados. Lógico, você já entendeu que nunca deve fazer isso porque se der pau num dos HDs você perde o volume inteiro.








O segundo jeito que eu ainda não falei é RAID-1, que é como alguns sistemas caseiros de backup com 2 HDs podem vir configurados. Mesmo exemplo, imagina os dois HDs de 1 tera cada. Podemos configurar um pra ser backup quente do outro. Ambos ficam ativos mas pra você só aparece um volume C: de 1 terabyte. 







Por baixo seja um hardware de RAID na sua placa mãe ou um módulo de software RAID que seu sistema operacional carrega no boot vai identificar os dois HDs mas organizar como um único volume. Diferente do RAID-0 que você ia enxergar como um único volume com a soma do espaço dos dois HDs, no RAID-1 você enxerga só como se um dos HDs estivesse ligado e o outro não. Metade do espaço total.









Parece desperdício, mas essa é a redundância mais simples. Toda vez que você escreve um arquivo, por baixo vai escrever igual nos dois. Um vai ser uma cópia exata do outro e por isso RAID-1 é chamado de mirroring, ou espelhamento. Digamos que daqui alguns meses um dos HDs resolve dar pau. O sistema de RAID vai identificar o problema e você não vai perder nada porque o outro HD ainda tá intacto e com 100% dos seus dados. Basta trocar o HD defeituoso e o sistema de RAID vai reconstruir esse novo HD fazendo uma cópia do outro.









A gente pode combinar o espelhamento do RAID 1 com o stripping do RAID 0. Se eu tiver agora quatro HDs de 1 tera cada, ou seja, total de 4 tera, eu posso organizar como dois conjuntos de stripe: dois HDs de 1 tera viram um volume de 2 teras. E agora eu pego esses dois volumes maiores e mando um espelhar no outro. Eu continuo perdendo metade do espaço pra backup, mas também tenho a vantagem de mais performance de ter HDs em stripe. É tipo juntar o melhor dos dois esquemas: redundância e performance.








Você vai ver esse arranjo sendo chamado de RAID 10, mas não é número 10 e sim 1 mais 0 porque é Raid 1 combinado com Raid 0. Em qualquer dos casos estou perdendo bastante espaço pra backup. E existe um jeito mais inteligente, e aí voltamos pro RAID-5 do meu Drobo e do Synology e da maioria dos bons servidores de armazenamento. Aliás, no mundo de storages ou armazenamento, existem 3 siglas que você precisa saber: DAS, NAS e SAN.








Direct Attached Storage é o mais simples. Um pendrive ou HD externo é um DAS, que é storage anexado direto no seu computador, seja via USB ou Thunderbolt hoje em dia. Aliás, USB é outro ninho de siglas que confundem. Fazendo uma pequena tangente, tudo que é USB antigo de uns 10 anos pra trás é USB 2.0 que tem velocidade máxima de uns 480 megabits por segundo ou 60 megabytes por segundo.









Quando você só tem HDs mecânicos, um USB 2.0 tá mais que bom. Mas desde 2008 existe USB 3.0 que opera na faixa de 400 megaBytes por segundo, bem mais que o melhor HD mecânico. E isso é necessário porque nesse ponto a gente já tava começando a adotar mais SSDs.









Acho que todo mundo pelo menos tem idéia do que é um Solid State Drive. SSD é uma placa com chips de NAND Flash. Modelos mais sofisticados tem chips de RAM também pra operar com cache e melhorar os piores casos. Como eles foram feitos pra conectar na interface Serial ATA ou SATA 3, que tem velocidade teórica máxima de 750 megabytes por segundo, não espere um SSD comum ser muito melhor que isso.








Na prática um bom SSD vai operar na faixa de 500 megabytes por segundo, que já é pelo menos 10 vezes melhor que a velocidade média de um HD mecânico. Se for lidar com milhares de arquivos pequenos então, o HD mecânico pode cair pra velocidades ridículas de 3 ou 2 megabytes por segundo. Num SSD o tempo de procura é muito mais rápido porque é que nem um chip de memória, não tem que lidar com um motor e ficar reposicionando cabeças em cima de discos. 









Se a gente judiar do SSD a velocidade dele pode cair pela metade, mas mesmo assim ainda estamos falando da faixa de 200 megabytes por segundo. Notebooks não tão velhos já devem pelo menos ter um SSD numa caixinha de 2.5 polegadas igual um HD mecânico de notebook mais antigo. Tanto que é fácil trocar um pelo outro e você vai ganhar 10 vezes mais performance. Nenhum upgrade num notebook velho vale mais a pena do que colocar um SSD. 










De qualquer forma, um USB 2.0 agora é porcaria, daí pulamos pra série 3. Toda vez que você vê um conector USB que é azul é porque é da série 3. E eu falo série porque desde 2008 ele virou 3.1 e 3.2. Na prática quando se fala USB 3, quer dizer pelo menos 3.2 Gen 1. E são quatro tipos, a Gen 1 que é de 5 gigabits por segundo, gen 2 é 10 gigabits, gen 1 x 2 é 10 gigabits, gen 2 x 2 é 20 gigabits. A nomenclatura de USB é uma droga assim mesmo.









5 gigabits que é o USB 3.2 gen 1, é 5 dividido por 8 que dá na faixa máxima de 600 megabytes por segundo. Que é próximo da velocidade máxima de um SSD SATA-3 de qualidade. E 20 gigabits do USB 3.2 gen 2 por 2 é 2.5 gigabytes por segundo. E pra que tudo isso? Porque o mundo de HDs não é só mecânico e SSD. Hoje em dia o melhor são os NVME.








NVME é Non-volatile Memory Express. Assim como SSDs eles continuam usando chips NAND flash, mas em vez de ser limitado pelo barramento SATA-3, o NVME usa lanes de PCI Express. Pensa assim, a série ATA e SATA de interfaces foi pensada pra HDs mecânicos. Então os SSDs mais comuns que usam SATA-3 tem uma série de obstáculos de tecnologia legada. PCI Express é o mesmo barramento onde você liga coisas como sua placa gráfica. Trocando SATA-3 por PCIe, a gente ganha menos overhead e menos obstáculos.









Se um bom HD mecânico faz na faixa de 50 megabytes por segundo, se um bom SSD SATA-3 faz na faixa de 500 a 600 megabytes por segundo. Um bom NVME que usa PCIe e se conecta em slots que chamamos de M.2, faz na faixa de 2 a 3 gigabytes por segundo que, por acaso, é a faixa de velocidade do USB 3.2 Gen 2 por 2 que eu falei antes.









O que todo mundo fica confuso é não saber que USB 3 é um protocolo e que tem várias gerações que variam bastante de velocidade. Aí tem a gente confunde o protocolo USB 3 com o conector USB Type C. Isso é outro problemão porque agora estamos falando de conector e cabos. 






O conector mais comum sempre foi o USB type A que é aquele retângulo maior. Tem o Type-B que é menor e mais quadrado que liga em impressora e que existe pra você não inverter os lados do cabo. Cabo USB transmite energia só pra um lado. Normalmente do Type-A sai energia e no Type-B recebe. Se fosse tudo Type A você podia acabar invertendo o cabo e queimar alguma coisa.










Enfim, Type C é novo conector que saiu uns 3 ou 4 anos atrás pra justamente arrumar um pouco essa zona. Todo mundo só pensa que com o Type-C não tem jeito certo pra encaixar. Mas não só isso, você pode ter cabo com as duas pontas sendo Type-C, porque ele é multi-direcional pra energia e o protocolo vai garantir que você não vai queimar nada se inverter o cabo.









O cabo Type-C, junto com o protocolo 3.2 Gen 2 x 2 tem capacidade máxima de 20 Gigabits por segundo, que são os mais de 2 gigabytes por segundo de velocidade. Mas tem acima disso. Computadores Intel e Mac, ou seja, menos a AMD, tem Thunderbolt 3, com velocidade máxima de 40 gigabits por segundo ou 5 gigaBytes por segundo. E aí você pode pensar, mas ué, o NVME mais rápido é na faixa de 2 a 3 gigabytes, pra que precisa do dobro?








Porque Thunderbolt não é feito só pra dispositivos de armazenamento, mas pra tudo, incluindo monitores. Um cabo HDMI 2.0 que é o mais comum e que você deve ter na sua TV, sozinho, tem banda de 18 gigabits, perto do máximo de uma USB Type C. Você consegue transmitir no máximo 4K a 60 quadros por segundo.








Sem entrar muito no assunto de video, mas só pra complementar, pra jogar Playstation 5 ou Xbox Series X em 4K a 120 hertz em HDR, precisa de cabo HDMI 2.1 que tem banda de 48 gigabits por segundo. Então, num USB 3.2 Gen 2 x 2 não dá pra ligar mais de um monitor 4K e ainda ter boa velocidade pra copiar arquivos pra um SSD externo. Thunderbolt serve pra isso. 






E isso porque estamos pra receber já já USB 4 e Thunderbolt 4. Só mencionei porque tanto USB 3.2 quanto Thunderbolt usam cabos com o mesmo conector Type-C. Por isso é uma zona. Quando a entrada Type-C suporta Thunderbolt, costuma ter um ícone de raio do lado. Mundo Mac tá mais acostumado com tudo Thunderbolt, no mundo PC a gente tá um pouco mais atrasado na adoção.







Voltando a falar de SSDs e NVMEs, laptops e placas mãe modernas já vem com pelo menos um slot M.2 que dá pra colocar um NVME. E se não tiver, no mínimo você deveria jogar fora o HD mecânico e colocar um SSD SATA-3. Qualquer coisa vai ser no mínimo 10 vezes melhor que um HD mecânico. No caso de NVME vai ser quase 100 vezes melhor.








Agora, SSDs e NVMEs não são todos iguais. NAND Flash tem em diversas variedades. Você tem chips que suportam 1 bit de dados que é single-level cell ou SLC. Você pode ter um chip que suporta 2 bits, que é multi-level cell ou MLC. Entendeu? O próximo tipo suporta 3 bits e se chama triple-level cell ou TLC e o último suporta 4 bits ou quad-level cell ou QLC. Então SLC, MLC, TLC e QLC. Quanto mais bits melhor? Na realidade não, o melhor é o single level cell, SLC.







Quanto mais bits você entuchar numa célula, menos espaço  ocupa. Então tem drives com maior capacidade no mesmo espaço. Porém, quanto mais bits ele tem, mais lento ele fica e, pior, menos tempo ele dura. Chips NAND tem capacidade máxima de escrita. Todo SSD tem uma quantidade máxima de vezes que dá pra usar antes das células pifarem.






Chips SLC, de 1 bit por célula, vão durar na faixa de 50 a 100 mil ciclos de program e erase ou PE que é a unidade que se usa. Um chip QLC vai suportar 100 vezes menos, talvez uns 1000 ciclos de PE. Então, no mesmo preço, ou você escolhe um SSD de menor capacidade mas que vai durar muito tempo ou um de maior capacidade que vai durar menos tempo. Mais um trade-off.







Nenhum SSD vai durar pra sempre. Apesar de não ter peças móveis ele também deteriora com o uso. A vantagem é que  não vai estragar antes do tempo porque você derrubou e estragou o motor ou riscou o disco. E justamente porque a gente sabe que tanto HDs, quanto SSDs ou NVMEs uma hora vão todos morrer, que você precisa de tempos em tempos garantir que tem backup. 







A tangente toda começou porque eu comecei falando de DAS. Um HD externo mecânico ligado via USB 2 é um DAS porque tá anexado direto no seu PC. Se usar um SSD externo, provavelmente vai ser via USB 3. Se usar um NVME externo vai ter conexão Thunderbolt. E mesmo soluções de RAID com múltiplos drives também pode ser de SSDs, e se for você pode conectar via Thunderbolt também.







Mas não é sempre prático ter uma caixona grande com múltiplos drives na sua mesa. Às vezes você pode preferir colocar esse servidor em algum lugar mais escondido. Dentro do seu closet, no porão ou algo assim. E aí tem uma desvantagem de cabos como USB ou Thunderbolt. Eles não foram feitos pra serem longos assim.








Mas existem cabos que foram feitos pra ser bem longos, são cabos Ethernet de rede. E indo direto ao assunto, adivinhem, só porque um cabo é azul ou amarelo, e tem o mesmo conector RJ-45 de rede, não quer dizer que são iguais. Mesma coisa que eu falei dos diferentes tipos de USB 3.2. Cabos ethernet são divididos em categorias. Hoje não é episódio sobre redes, mas deixa eu só explicar os cabos.







Existem categorias como cat5E, cat6, cat6A, cat7, cat8. De cat5 a cat6 é velocidade máxima de 1000 megabits por segundo, que é uns 125 megabytes. Isso é o dobro de USB 2.0 mas é 5 vezes mais lento que USB 3.2 Gen 1.






Cat6A e Cat7 é categoria dos 10 gigabits por segundo. Agora igualamos com USB 3 Gen 1. Se o comprimento for menos de 50 metros, ainda pode subir pra 100 gigabits e aí já ficou melhor que Thunderbolt. Um cabo cat8 já entra em território de velocidade de fibra ótica. Além de velocidade varia a construção do cabo, resistência, blindagem. Acho que Cat 6 ou 7 são mais comuns, eu nunca vi um Cat8, vai ser mais em data center.








Quem lembra de física elétrica básica do colégio lembra que num fio que passa eletricidade gera um campo magnético ao seu redor, por todo o comprimento. Se colocar vários fios em paralelo um do lado do outro, eles vão dar interferência entre eles. Um cabo Ethernet é um conjunto de vários cabos mais finos dentro, organizados em twisted pair, ou par trançado. Se você já clipou um cabo de rede já deve ter visto isso.









Normalmente esses cabos conseguem atingir distâncias de até 100 metros e se precisar mais longo existem extensores pra isso. Mas o ponto é que você pode tranquilamente puxar cabos de dezenas de metro pela sua casa sem problemas. É o que eu faço: em vez de usar um DAS conectado direto no meu PC eu tenho um NAS, um network attached storage do lado do meu roteador e do meu PC sai um cabo ethernet cat7 que vai até o roteador.








Meu Synology DS420j é um NAS de entrada. Tá configurado com 4 HDs mecânicos de 4 terabytes cada, reservando uns 5 giga espalhado pelos drives. É uma porção de cada drive reservado pra redundância. Um NAS é só um nome mais bonitinho pra um PC pequeno com Linux. Ele tem uma CPU Celeron antiga, uns 1 giga de RAM e só.







Um NAS mais sofisticado vai ter um processador melhor, muito mais RAM e até opção de colocar um SSD, normalmente formato mSATA ou talvez até M.2. Você mesmo pode montar um NAS caseiro num PC velho que tiver sobrando com placa de rede ou até Wifi. Como a gente acaba usando HDs mecânicos, velocidade de Wifi acaba sendo suficiente.







Eu ainda não coloquei um NAS melhor porque não preciso editar arquivos grandes direto dele, só uso como backup mesmo. Mas existem casos que você precisa trabalhar direto do NAS. Exemplo disso são estúdios que editam videos profissionais. Aí você tem vários editores trabalhando de computadores bons mas todos precisam acessar os mesmos arquivos ou os arquivos são tão grandes que não é prático ter na máquina de cada um. 








Se você não tem noção, video ocupa muito espaço. Mesmo na minha produção caseira, um video de 30 minutos em 4K ocupa nada menos que 3 gigabytes e meio. Um dos meus últimos videos longos, antes de editar, foram 4 arquivos que dá quase 2h de gravação e ocupa quase 40 gigabytes no total. Pra um video de YouTube! Tudo bem que é um video que editado deu uns 45 minutos, mas mesmo assim. 10 episódios nesse formato já seria quase meio terabyte. Menos de 20 videos e acabou um terabyte. Lembrem que meu canal já tem 100 videos.








Numa produção profissional bem mais cara, usando uma câmera RED Monstro, gravando no formato Redcode com compressão de 8 pra 1 e video de 8K custaria nada menos que 1 terabyte pra cada 30 minutos. Ouviram? Se eu tivesse gravado as mesmas duas horas que eu falei nesse formato ia me custar mais de 3 terabytes. Num único video! Imagina 100!







Ah, mas depois de editar o video final é só jogar fora os originais. Não, isso é pensamento de amador. A gente NUNCA joga fora originais de nada. Você nunca sabe quando precisa voltar nos originais pra re-editar, ajustar, talvez fazer um remaster amanhã. Profissionais guardam tudo em servidores. 






Por isso você vai num canal como Linus Tech Tips e ele fala tanto em servidores de armazenamento como esse aqui dele montando 1 petabyte num servidor com 60 HDs, 256 Giga de RAM controlado por uma CPU AMD Epic Threadripper acho que de 24 cores. E eles tem mais de um desses servidores.








Nossos computadores domésticos e laptops costumam vir no máximo com um plug Ethernet de 1 gigabit, que é suficiente pra no máximo 128 megabytes por segundo de transferência. Pra navegar na Web e copiar arquivos pequenos pela rede tá mais que bom. Quase nenhum plano de Internet doméstico que você achar vai saturar isso, nem perto, especialmente se for uma porcaria como NET da vida. Meu NAS Synology e o Drobo não fazem muito mais que 25 megabytes por segundo. Mas pra conseguir editar video de 8K em tempo real, direto num drive montado na rede, precisa ser Ethernet 10 gigabit, pra ter velocidades de mais de 1 gigabyte por segundo.









Um servidor desses, aliás, provavelmente vai ter múltiplas saídas de ethernet 10 gigabit pra conseguir lidar com múltiplos computadores editando video ao mesmo tempo. Aí a brincadeira começa a fica interessante. Recomendo procurar por videos dos bastidores do Linus Tech Tips que ele detalha bastante disso. O ponto importante é que a gente imagina computador como sendo só o HD interno e no máximo um HD externo via USB. Mas tem muito mais opção que isso.








Falando em opção a última coisa que eu queria comentar é sobre storage em cloud. Seja seu Dropbox ou AWS da vida. Num container virtual você não tem nenhum controle sobre os HDs por baixo. Quando você cria uma instância tipo um AWS EC2 da vida e monta um volume de EBS, provavelmente por baixo é um SAN ou Storage Area Network, que é o terceiro tipo que faltava falar mesmo.








NAS você já entendeu, é um servidor com HDs, em alguma configuração de RAID. O servidor de 60 HDs do Linus por exemplo, provavelmente tá configurado com filesystem ZFS e uns 8 HDs são reservados pra paridade. Parece bastante mas 8 de 60 é uma perda de pouco mais de 10% comparado aos 20% que eu perco no meu RAID-5, é bem justo. Significa que ele pode ter até 8 HDs crasheando ao mesmo tempo sem perder nenhum bit de dados. Nos próximos episódios vou falar de ZFS mas só entenda pra hoje que é o melhor filesystem pra configurações assim de múltiplos HDs. 








Um SAN é uma infraestrutura mais complexa. Num NAS a gente cria um volume virtual em cima dos 4 HDs ativos e enxergamos tudo como se fosse um único drivezão em vez de enxergar. Um SAN é um volume virtual bem maior, que pode agrupar o equivalente a vários NAS por baixo. A grosso modo pense num SAN como um conjunto de NAS, um rackzão de data center com vários servidores ainda maiores que o do Linus. É em cima de hardware assim que funciona um Dropbox ou Google Drive.







E se você não conhecia, EBS é o serviço da Amazon Web Services pra criar volumes virtuais, que você pode montar na sua máquina virtual Linux como se fosse um drive. Máquinas da Amazon EC2 são voláteis. Quando desliga a máquina, tudo que tinha dentro se perde. Pra persistir dados, você monta um volume do EBS e vai gravando lá. Quando desligar a instância, os dados no volume do EBS continuam lá até você remontar em outra instância. 









Outra hora eu explico mais sobre porque a AWS funciona dessa forma. Mas a curiosidade é o nome. EBS é Elastic Block Storage. Existem dois tipos de dispostivos, character devices e block devices. Character devices quando você conecta ele vai imediatamente transmitindo byte a byte individualmente pro seu software. Block devices recebem ou enviam bytes literalmente em blocos. Por exemplo, setor a setor de uma partição ou melhor, clusters de vários setores ao mesmo tempo.








Um character device ou também chamado de raw device, "raw" de crú, onde a gente recebe e envia byte a byte imediamente. Um block device tem uma espera, porque a kernel do sistema operacional vai manter um cache em memória. Blocos é mais eficiente quando o dispositivo é lento. Lembra do trabalho que é o motor mover as cabeças por um disco que fica em rotação? Por outro lado, coisas como teclado, mouse, você não quer que demore, pelo contrário, você quer a menor latência possível. Por isso tem dois tipos.







Em Linux pelo menos, a distinção deve ter motivos históricos, quando o normal era ter que lidar com HDs bem lentos, ou mesmo os antigos disquetes e CDs. Ao contrário de Linux a família de UNIX BSD não trata HDs como block devices e sim como raw devices, hoje em dia. Isso porque o fato do cache existir pra tentar melhorar a performance do HD trás uma desvantagem que usuários domésticos como a gente não vai notar. Mas num servidor com muito uso pode ser fatal.






Tudo que tá num cache é volátil. Memória RAM depende de energia e se a energia caiu, perdeu o que tinha lá. Você quer RAM porque acelera a transmissão, mas quanto mais demorar lá, maiores as chances de perder. O BSD quer partir da premissa que ele não vai interferir, e seu aplicativo pode implementar cache por cima e gerenciar o risco que está disposto a assumir em vez de tentar melhorar performance ao custo de um risco escondido.







Essa situação é raro de acontecer, mas não impossível. Quantas vezes no ano caiu energia bem quando você acabou de mandar salvar alguma coisa? É raro, mas comigo mesmo ao longo dos anos aconteceu algumas vezes. Mas o ganho de performance graças aos caches automáticos do sistema operacional tem mais validade pra mim do que talvez perder um arquivo uma vez por década.







Num servidor a história é outra. Lembra o servidor do Linus com 60 HDs? Pensa servidores muito maiores, centenas de servidores, com milhares de HDs. Num data center vai ser bem mais comum ter problemas, provavelmente até múltiplas vezes por dia. Num conjunto de dezenas de milhares de HDs, certamente alguns HDs vão dar pau. Algum servidor pode dar pane de algum tipo. E se seus dados estiverem num cache na memória, você pode perder arquivos importantes de algum cliente. 









Talvez por isso os BSDs, cujo maior uso é em aplicações de servidor e muito menos como desktop, não suportam mais block devices, todos são character devices ou raw devices. Não quer dizer que block devices são ruins. Num laptop, que tem bateria, você corre muito menos risco de perder alguma coisa por conta de uma falta de energia aleatória. Por outro lado, a performance extra por ter o cache vai faciltar seu dia a dia. 






Mas servidores é diferente, eles ficam ligados 24 horas por dia, 7 dias por semana, com milhares de pessoas realmente lendo e gravando dados sem parar. E você não pode perder um byte, ou já já vai ter usuários muito bravos com você.







Tem muito mais que isso pra se falar sobre dispositivos de armazenamento, mas eu acho que com o que falei hoje já deve cobrir a maioria dos casos de uso que um programador médio vai precisar. Você precisa entender o que está usando e não confiar numa abstração. 






Eu lembro que antigamente a gente sabia que o programa tava funcionando e lendo ou gravando porque a gente colocava a orelha no gabinete e ouvia o som do motor e das cabeças trabalhando. Pra diferenciar se um programa tava travado ou só demorando pra acabar, era só ouvir o HD. Se estivesse em silêncio e o programa ainda pausado, é porque travou. Se desse pra ouvir o HD trabalhando, então tinha que esperar mais um pouco. 







Hoje em dia, especialmente se você tá conectado numa máquina virtual em cloud, não tem mais esse contato com a máquina. Então é mais importante ainda saber como essas coisas estão estruturadas, pra saber em que parte pode estar com problema: na sua aplicação, no sistema operacional, num dos caches, na camada de rede se for um NAS, e assim diagnosticar o lugar certo. 







A pior coisa que um programador pode fazer é acreditar em superstições porque não entende como as coisas funcionam. Daí quando realmente precisa resolver um problema difícil vai ficar achando receitas homeopáticas e ficar tacando tudo na parede pra ver se algum gruda. Não precisa ser programador pra fazer as coisas às cegas assim.






Espero que tenha dado pra aumentar o interesse de vocês em estudar mais sobre o hardware. No próximo episódio vou falar sobre o que vai dentro dos volumes: o sistema de arquivos. Cada sistema operacional usa um diferente e eles tem vantagens e desvantagens. Se ficaram com dúvida mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal, clique no sininho e compartilhem o video com seus amigos. A gente se vê, até mais.


