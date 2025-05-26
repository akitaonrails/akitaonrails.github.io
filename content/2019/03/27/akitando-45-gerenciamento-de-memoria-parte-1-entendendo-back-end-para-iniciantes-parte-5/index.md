---
title: "[Akitando] #45 - Gerenciamento de Memória (Parte 1) | Entendendo Back-end
  para Iniciantes  (Parte 5)"
date: '2019-03-27T17:01:00-03:00'
slug: akitando-45-gerenciamento-de-memoria-parte-1-entendendo-back-end-para-iniciantes-parte-5
tags:
- tcmalloc
- jemalloc
- ptmalloc2
- linux
- rust
- golang
- memory
- RAM
- intel
- threadripper
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/9AK_1gqEfkQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


Eu disse no episódio anterior que não sabia se ia falar sobre Gerenciamento de Memória, mas acho que não dá pra terminar a série e não falar disso. Então hoje vamos escovar bits um pouco. Como a série é pra iniciantes, vale revisitar um pouco sobre representações binárias e hexadecimal e entender mais sobre como o computador e seus programas enxergam essa tal de "memória".

Hoje quero explicar como os principais alocadores de memória do Linux funcionam e ensinar o que são os principais desafios que envolvem o gerenciamento de memória. Tudo isso vai ser importante pra semana que vem que vou explicar sobre garbage collectors.

Erratas:

* aos 11:39 min o áudio fica ruim por 1 minuto. Eu gravo o áudio num gravador externo e mantenho o áudio da câmera pra sincronizar. Mas meu gravador parou nesse minuto e fiquei só com o áudio da câmera, por isso que a qualidade cai, mas é só 1 minuto.

* a 26:50 min aparece um typo "Stacjk" que na verdade é "Stack"



Links

* The 640K memory limit of MS-DOS (https://www.xtof.info/blog/?p=985)
* The difference between booting MBR and GPT with GRUB (https://www.anchor.com.au/blog/2012/10/the-difference-between-booting-mbr-and-gpt-with-grub/)
* How Linux system boots up? (https://medium.com/@garimajdamani/how-linux-system-boots-up-f15c9e0f7a96)
* Rebasing Win32 DLLs (http://www.drdobbs.com/rebasing-win32-dlls/184416272)
* Commodore 64 memory map (http://www.awsm.de/mem64/)
* Physical Address Extension - PAE Memory and Windows (https://docs.microsoft.com/en-us/previous-versions/windows/hardware/design/dn613975(v=vs.85)
* A visual guide to Go Memory Allocator from scratch (Golang) (https://blog.learngoprogramming.com/a-visual-guide-to-golang-memory-allocator-from-ground-up-e132258453ed)
* Scalable memory allocation using jemalloc (https://www.facebook.com/notes/facebook-engineering/scalable-memory-allocation-using-jemalloc/480222803919)
* Understanding glibc malloc (https://sploitfun.wordpress.com/2015/02/10/understanding-glibc-malloc/)

Olá pessoal, Fabio Akita

Finalmente, estamos pertos de concluir o tema de Back-end dessa série Começando aos 40. Já estamos no décimo episódio pra falar sobre Gerenciamento de Memória. Mas diferente dos episódios passados que estavam dando quase 1 hora de duração, este eu resolvi quebrar em duas partes. Tá bem trabalho editar esse tanto de vídeo toda semana, e mesmo assim vai ser comprido hoje, então prestem atenção! 

Durante os últimos episódios eu meio que dei uma introdução a coisas que vocês aprenderiam em  matérias como de sistemas operacionais numa faculdade de Ciências da Computação, então espero que aproveitem os tópicos que eu mencionei pra se aprofundar mais nos estudos desses temas.


Vou dizer que fiquei em dúvidas se deveria ou não me estender no tema de hoje, ele é ainda mais escovação de bits do que os temas anteriores. Mas eu sinto que é outro assunto que a grande maioria dos programadores, não só os iniciantes, até hoje não entendem direito. E o assunto é gerenciamento de memória. Todo mundo acha que porque suas linguagens costumam ter coisas como garbage collector, então é um assunto irrelevante. Mas isso não é verdade. Um programador amador realmente não vai prestar atenção nisso e em várias outras coisas, mas se você realmente tem a intenção de ser um verdadeiro profissional então sim, você precisa dominar esse assunto.



(...)



Recapitulando, eu já expliquei várias vezes como seu código fonte compila num binário e esse binário é carregado em memória. Também já rapidamente expliquei como CPUs e sistemas operacionais modernos alocam espaços de memória isolados pra cada processo, com endereços virtuais de tal forma que um processo não tem como acessar a memória de outro processo. Como eu já disse antes, se você realmente pretende levar a sério a profissão, precisa entender como seu computador realmente funciona.


Uma coisa que eu nunca mencionei por exemplo é o processo de boot em si, que é bem fascinante. Em hiper resumo, tem diversas etapas, do momento que você aperta o botão de ligar, segue o processo de Power on self test ou POST que você vai ouvir falar bastante se acompanha canais de montar seu computador, tem o teste de memória e outros dispositivos, até chegar no Master Boot Record que é o antigo MBR ou o atual GUID Partition Table ou GPT pra carregar o boot loader, que no caso do Linux seria um GRUB2 por exemplo, e finalmente carregar o binário do Kernel propriamente dito que, por sua vez, vai carregar um systemd, que por sua vez finalmente vai carregar todos os daemons pra terminar de tornar disponível os recursos da máquina pros programas, como montar suas partições do disco.  Se você está estudando Linux, veja os links que deixei na descrição abaixo que detalham esse processo em mais detalhes. 


Eu estava pensando em quanto de detalhes quero mostrar hoje, mas se eu for realmente minucioso o episódio vai ficar com horas e horas de duração e vai ser extremamente tedioso. Em vez disso vou delinear os pontos principais e explicar resumidamente, você precisa pesquisar mais detalhes depois nos seus estudos. 


Em termos de memória, entenda que você tem os pentes de RAM, o que você normalmente vê como pente de 16GB DDR4, DDR que significa Double Data Rate. De curiosidade eu já falei rapidamente antes que tudo no computador funciona segundo o clock da CPU. Sabe quando a gente fala em CPU de 4 Ghz? Sendo hertz um ciclo, 4 Ghz significa 4 bilhões de ciclos por segundo, pense em clock literalmente como um ciclo ou uma ida e volta de um pendulo, uma frequencia. Double Data Rate significa que é possível puxar dados da memória no topo do ciclo e na parte de baixo do ciclo, em vez de só conseguir puxar dados uma vez por ciclo como era antigamente, então ele tem a chance de puxar duas vezes, por isso é mais rápido, mas hoje em dia a gente só usa DDR de qualquer forma.  Uma diferença pra memórias de servidor são as memórias ECC que significa Error Correcting Code. É uma memória bem mais cara mas que garante que a memória nunca vai ser corrompida, pentes de RAM normais como as que usamos tem chances de devolver 1 bit errado de tempos em tempos, mas é raro, memória ECC de servidor tem uma proteção extra e menos chances.



O que o seu simples programa vê não é só RAM, é mais um “espaço de memória”, a CPU vai cuidar do que vai aonde. Você tem caches L1, L2 e L3 que são memórias pequenas e hiper rápidas que ficam no mesmo chip, pra fora dele você tem um barramento, que vai conectar com dispositivos como os pentes de RAM e com seu HD mecânico ou SSD que também pode servir de memória se conter um arquivo de SWAP. Se você não sabia disso memória é dividida normalmente entre acesso rápido e devagar. L1, L2 e L3 são memórias ultra rápidas. Quanto mais rápido mais caro, lógico, por isso eles são muito pequenos da ordem de até 64 quilobytes de L1, até meio megabyte de L2 e até 8 megabytes de L3. Eles não são memórias pra você usar, o CPU vai usar principalmente como cache pra manter seus pipelines cheios. Depois disso vem a RAM propriamente dita, seus pentes de DDR4, ordens de grandeza mais lentos que os caches, mas de uso geral. E depois vem coisas como o SWAP do seu SSD que é ordens de grandeza mais lento que a RAM.


Eu gostaria muito de explicar em detalhes o que são portas lógicas, como se chega num flip-flop, e como flip-flops podem ser usados pra armazenar bits. Pra ter um modelo na cabeça, pense em memória como um livro, com um espaço reservado pra um índice, e cada linha apontando pra uma página desse livro. Essas linhas são as linhas de endereço. Vamos entender essas linhas de endereço e como elas são organizadas.


Quando falamos que uma CPU é de 64-bits significa que os tais registradores da CPU acomodam números de até 64-bits de tamanho, e além disso temos barramentos, ou seja as rodovias de comunicação entre a CPU e a memória e dispositivos de I/O que também tem um tamanho máximo. 64-bits significa que a CPU consegue lidar com words ou palavras de 64-bits inteiros, que equivale a 2 elevado a 64 que seria o absurdo número de 16 Exabytes.  Pense assim, você tem bytes, quilobytes, megabytes, gigabytes, terabytes, petabytes e exabytes. 16 Exabytes é este numerazão aqui embaixo se for em bytes (18.446.744.073.709.551.616).


Agora, esse numerozão está representado no sistema decimal, que é o que estamos mais acostumados a lidar, mas quando falamos em computador, ele representa tudo em 1 ou 0. Vamos escovar bits um pouco. O número 1 é só 1, o número 2 é 1-0. O número 11 é 1-0-1-1. Pense em binário como a tabuada do 2, o número mais pra direita é 1, o segundo da direita pra esquerda é 2, na sequência vem 4 e depois 8 então 1011 é 8 + 0 + 2 + 1 que é 11, entenderam? Portanto o menor número de 64 bits é basicamente 64 zeros em sequência e o maior número seria 64 1s em sequência. 


Obviamente ficar representando tudo em binário no papel é muito longo. Como lidamos com bytes que são conjuntos de 8 bits, é mais fácil lidar com uma representação que é múltipla de 8 ou, melhor ainda, múltipla de 16, que é o que chamamos de hexadecimal. É um sistema que em vez do nosso decimal que vai só até 10 ele vai até 16, mas como números arábicos só tem caracteres de 0 a 9, precisamos usar as letras do alfabeto de A até F pra ir até 16. O mesmo número máximo de 64 bits que eu falei que é 64 vezes o caracter “1”, em hexa seria quatro grupos de quatro Fs. 


Tão vendo? Aquele numerozão horroroso em decimal que você jamais vai decorar é muito mais simples em hexadecimal e você consegue literalmente saber de cabeça que vai de 0 até 16 Fs. É muito mais curto. E em binário você tem propriedades matemáticas interessantes, por exemplo, multiplicar um número binário por 2, é simplesmente um shift left, tipo mover tudo uma casa pra esquerda e colocar um zero. Por exemplo o número 11 que eu falei que é 1-0-1-1 vira 1-0-1-1-0 que é 16 + 0 + 4 + 2 + 0 que é 22. Algumas coisas ficam mais simples de calcular.



Você precisa entender que usamos o sistema decimal que vai de 1 até 10 por motivos históricos. Vale pesquisar a história da matemática, você vai encontrar outros sistemas. Um exemplo, se você usar o relógio como parâmetro, é mais fácil contar de 1 até 60. Computadores são 1 ou 0 porque é o sistema mecânico mais simples, pense o interruptor de luz da sua casa, em todo instante ele armazena uma de duas informações: ligado ou desligado. 10 interruptores guardam 10 bits de informação. E os computadores mais rudimentares do passado usavam lâmpadas a vácuo, como o que ilumina seu quarto neste instante. Luz ligada ou desligada. Coloque 10 lâmpadas e você pode visualizar 10 bits de informação. 


Continue estudando mais sobre representação binária e hexadecimal, é importante você ter essas ordens de grandeza na cabeça de forma natural, mesmo que seu trabalho não seja fazer aritmética direto nesses sistemas. De qualquer forma, estávamos falando sobre computadores 64-bits. Este número abaixo (16 Fs) é o maior número inteiro que é possível armazenar em uma palavra de 64-bits e voltando às linhas do índice do nosso livro, significa que cada linha de endereço pode apontar números só até esse tamanho e, por consequência, esse tamanhão máximo de RAM ou páginas do nosso livro. Só que isso é teórico. 


Nenhuma máquina que eu saiba tem capacidade pra realmente comportar esse tanto de memória real. Um dos motivos é porque embora o processador tenha registradores de 64-bits, o barramento entre a CPU e a memória em processadores Intel, se não me engano, é de 42-bits, e na AMD é de 48-bits, portanto o máximo endereçável é 2 elevado a 48 que seria 256 Terabytes. 2-bits fazem muita diferença, porque é o quadrado do quadrado, então na Intel você conseguiria endereçar no máximo 4 Terabytes.


Isso é ordens de grandeza maior do que em computadores 32-bits da geração passada. E não, 64 não é o dobro de 32-bits, é o quadrado. Lembrando que 32-bits significa 2 elevado a 32, que limita o endereçamento a no máximo 4GB de RAM. Se você tinha computador nos anos 2000 vai lembrar que não dava pra colocar mais que isso de RAM. Se você chegou a ter acesso a servidores com Windows Server 2003 Service Pack 2 Datacenter Edition dava pra ter até 64 GB. 


Isso porque havia um truque da Intel em processadores 32-bits chamado PAE ou Physical Address Extension, e dependendo da configuração de hardware e sistema operacional, dava pra ir acho que até um máximo de 128 Gigas mesmo num computador 32-bits. Na prática, os processos num sistema desses continuavam só enxergando 4GB mas era possível ter mais processos ativos porque com PAE você podia swapar alguns processos pra essas áreas extendidas de memória e evitar usar swap de disco por exemplo.


Tudo isso dito, vamos tentar explicar mais sobre como o sistema operacional enxerga essa memória. Até agora sabemos que a memória é como um livro, com linhas de endereço no índice, cada endereço representando uma página do livro, com o endereço máximo dependendo se o computador tem barramento de 48-bits, 42-bits, 36-bits, ou 32-bits e assim por diante. O sistema operacional pode ler e escrever em qualquer endereço de memória. Num sistema operacional muito simples, tipo um Basic num Commodore 64, dava pra acessar diretamente esses endereços pra escrever ou ler. Na verdade existe um porém, você poderia achar que seu programa tem acesso a tudo do endereço 0000 até o endereço FFFF por exemplo, num computador de 16-bits. Mas quando você boota um Commodore, apesar dele poder endereçar 64KB, porque tinha barramento de 16-bits, você vai ver que ele diz que só tem 38.911 bytes livres. Isso porque como em qualquer máquina, nem todos os endereços estão livres pro usuário. 


Um pedaço dos endereços é reservado pra kernel, outro pedaço são funcionalidades como endereços de I/O, outro pedaço no caso do Commodore é o próprio interpretador Basic, e o que sobra é onde você pode carregar seus programas. O programa Basic só pode carregar a partir do endereço $0801 até o $A000, se você fizer a conta, A000 é o decimal 40,960 e 0801 é o decimal 2049. Então 40,960 menos 2049 são os 38911 bytes que o sistema declara como disponível.



Isso era na época em que tudo usava endereços reais, até o fim dos anos 80, antes dos processadores Intel 80286. Os computadores modernos a partir dos anos 90 tem o tal modo protegido e memória virtual. Quando o sistema operacional carrega seu programa ele dá pra ele um índice virtual, que vai do endereço virtual 0000 0000 até o FFFF FFFF. Só que o endereço virtual 0000 0000 desse processo, na memória real pode ser um endereço nada a ver, faz de conta, DCBA 9876, mas seu processo não tem idéia disso, só o sistema operacional sabe mapear entre os dois. 


Daí você carrega outro programa, ele também ganha outro índice virtual que vai de 0000 0000 até FFFF FFFF só que o 0000 0000 desse programa mapeia pro endereço real BA98 7654 por exemplo. Ambos os programas enxergam o 0000 0000 mas cada um aponta pra um lugar diferente. E por isso os dois programas são ditos isolados, porque não importa que endereço eles tentem apontar, nunca vai ser em cima do endereço do outro processo porque o sistema operacional garante que um endereço real usado não é apontado por mais do que um índice virtual.


A grande vantagem disso é que você pode ter 10 programas, cada um “enxergando” 4 GB de memória inteiro só pra ele, ou seja endereços virtuais de 0000 0000 a FFFF FFFF mas seu computador real pode ter bem menos memória que isso. Na prática a maioria dos programas não vai usar toda a memória disponível, então o sistema operacional compartilha a memória real entre os diversos programas até acabar a memória real. Então seu processo tem só a ilusão de que tem toda essa memória. E o que acontece quando acaba 100% da memória real do sistema, ou seja, toda a RAM e todo o swap no HD? Antigamente seu computador ou ia ficar lento ao ponto de ser inusável, ou programas iam começar a crashear por falta de memória, ou alguma combinação disso. 


Num sistema operacional de smartphones você já sabe o que acontece. Num iPhone ou qualquer Android moderno, você vai abrindo programas e não precisa fechar. Quando acaba a memória, os programas menos usados ou os abertos à mais tempo e sem uso, fecham sozinhos, dando espaço pra abrir mais programas. Num Android, que é um derivado de Linux, e mesmo iOS que é derivado de BSD UNIX, existe o OOM Killer ou Out of Memory Killer. Todo Linux tem isso, e é isso que evita que seu celular fique sem memória. É por isso que falamos que em celulares modernos você não precisa ficar fechando manualmente os programas, o OOM Killer vai fazer isso por você.


Voltando aos seus processos, o sistema operacional começa dando zero bytes de memória real pro seu processo. À medida que o processo vai pedindo memória, ele vai alocando memória real, sob-demanda, e mapeando os endereços reais pra endereços virtuais que o processo enxerga. E quando o processo vai devolvendo memória ou quando você fecha o programa, esses endereços reais voltam a ficar disponíveis pra outros processos poderem usar.  Se você simplesmente abre programas de Linux como ps, top ou htop ou o Task Manager no Windows, vai quanto cada programa está alocando. Pra simplificar digamos que você tem 2 programas, cada programa você vê ocupando 1.5 GB. Ou seja, cabe tudo em 3 GB de RAM. Daí na sua cabeça você acha que porque tem 4 GB de RAM, tem memória de sobra, certo? Errado. Um desses programas pode estar muito perto de crashear.


Pra simplificar, vamos considerar ainda um computador de 32-bits nesse exemplo. Eu disse que seu programa enxerga do endereço virtual 0000 0000 até FFFF FFFF. Mas ele Não vai poder usar tudo isso. Num Windows 32-bits de mais de 10 anos atrás, você começa tendo só 2 GB disponível, do começo até a metade, ou seja de 0000 0000 até 7FFF FFFF. Daí pra cima é reservado ao sistema operacional. Lembra como eu falei no Commodore 64 que partes dos endereços são reservados pro Kernel, Basic, I/O e outras coisas? Mesmo coisa em sistemas operacionais modernos. Mesmo num Linux, ele vai reservar de 512MB a 1 GB de endereços. Num Windows Server você podia bootar com um flag especial e compilar os programas com a flag /largeaddressspace pra permitir usar um pouco mais além da metade dos endereços. Não quer dizer que o Windows está realmente usando 2 GB, mas sim que os endereços estão reservados pra ele usar.


Ou seja, num computador 32-bits, apesar de poder mapear até 4GB e mesmo se você tivesse 4GB reais de RAM, nenhum processo seu iria conseguir usar mais que 2GB. Hoje em dia você tem problemas de memória em computadores 64-bits? Imagina quando a gente tinha que programar servidores em 32-bits. Pior ainda, imagina como era na época dos 16-bits. Saber usar memória é até hoje o que diferencia um amador de um profissional de verdade. Pra dar um exemplo, lembram do episódio que eu falei de SAP? Nessa época, acho que era 2003, eles tinham um servidor de aplicações Java, o In-Q-My, ainda em beta, pra carregar aplicações J2EE pesadas como o Enterprise Portals. No boot do Java com os programas SAP por cima, ele carregava tranquilamente um giga e meio.


Se você fosse amador, pensaria, “ah, sussa, máquinas 32-bits carregam até 4GB então tem sobrando”. Se você fosse intermediário pensaria “puta que pariu, só mais 500 Mb e vai bater no limite de 2 GB”. Porém, eu não conseguia fazer esse servidor subir, ele crasheava por falta de memória. Mas eu descobri porque. Lembram que eu falei que o sistema operacional usa parte da memória do processo? Seus programas reusam muitas bibliotecas que o sistema operacional compartilha com os processos, então você tem endereços virtuais que mapeiam pros endereços reais dessas bibliotecas do sistema, incluindo muitas DLLs que todos os processos usam como a LibC da Microsoft ou o Foundation Classes. Pra você entender, o sistema não está duplicando essas bibliotecas em todos os processos, mas os endereços virtuais dos processoa mapeiam pras mesmas bibliotecas. Os processos são isolados, então pra eles enxergarem alguma coisa de fora, os endereços virtuais precisam mapear pra esses recursos compartilhados.


Ainda pensando de forma ingênua, você imaginaria que essa bibliotecas carregam bonitinhas sequencialmente uma atrás da outra, sem desperdiçar nenhum endereço. Lógico que não, não necessariamente. E de fato, algumas dessas bibliotecas apareciam com endereços na primeira metade dos endereços virtuais do processo, ou seja, em cima dos 2 GB reservado pro seu programa. Isso se chama fragmentação de memória. A JVM precisava alocar memória contígua no boot, ou seja com endereços sequenciais, sem buracos no meio. Aliás, alocação de memória sempre aloca pedaços inteiros, sequenciais. Como a memória estava fragmentada, não havia um trecho sequencial limpo de 1.5 GB. E agora?


Felizmente, no Windows você tem como fazer rebase das DLLs, pense mais ou menos, como defragmentar a memória. Exatamente isso, você pode mudar o endereço de carregamento dessas DLLs. Como são bibliotecas dinâmicas, o binário não mapeia um endereço fixo, então você pode mudar elas de lugar. E foi assim que eu consegui subir os programas Java que eu precisava. Quem já trabalhou com servidores 32-bits e programas realmente pesados de Java, com certeza esbarrou com isso, é um problema sabido desde o ano 2000 pelo menos. E pense que em 2003 o site StackOverflow ainda não existia.


Aceite este fato: a memória total do seu sistema não está à disposição do seu processo. Felizmente em máquinas 64-bits de hoje, você tem muito mais que 2 GB de endereços virtuais disponíveis, então pelo menos esse problema já não afeta mais. Tanto que mesmo na época uma das soluções que a SAP falava era: migre pra máquinas 64-bits. Espero que em 2019 ninguém mais esteja usando máquinas 32-bits. O segundo fato que você precisa aceitar: memória fragmenta. A razão é simples. Digamos que sua memória total seja de 10 kb, dividida em chunks ou pedaços de 1 kb. Você começa alocando 3 variáveis de 1 kb cada. Digamos que o alocador aloque os primeiros 3 chunks. Agora digamos que você resolva liberar a segunda variável. Você ficou com 1 kb ocupado, 1 kb livre, e o terceiro kb ocupado. 


Agora seu programa resolve que precisa de uma variável de 2 kb. Como o espaço vago do meio não cabe os 2 kb, e repetindo, grave essa regra: o alocador sempre precisa alocar pedaços contíguos, com endereços sequenciais. Então ele só vai ter espaço depois do terceiro chunk. Agora você ficou com um espaço fragmentado. Pense numa escala maior, com milhares de alocacões e desalocações, sua memória vai ficando com buracos no meio do caminho e toda vez que você precisa alocar mais memória do que cabe nesses buracos ele precisa ir lá pra frente. Então um programa que internamente ele enxerga que está alocando só 4 KB na verdade está potencialmente bloqueando 5 KB nesse momento. Fragmentação é uma das coisas que alocador de memória quer evitar.


Quem faz esse trabalho é o alocador de memória. No caso do Linux, mais especificamente da biblioteca glibc, você tem o famoso “malloc”. Eu expliquei nos episódios anteriores que no Linux você pode escolher entre diferentes schedulers de threads como o CFS que hoje é o padrão ou outros como o BFS dependendo de pra que vai usar a máquina. Alocador de memória também, você pode escolher.


O malloc do glibc na verdade é o ptmalloc2 que por sua vez é baseado no dlmalloc, DL porque quem criou essa versão foi o professor Doug Lea. Um alocador de memória é um conjunto de algoritmos e estruturas para manter metadados dessa memória. Um alocador moderno tem vários de problemas importantes pra resolver. Primeiro de tudo, alocar memória precisa ser rápido, estamos falando de frações de milissegundos, ou seja, nanossegundos, porque é uma operação que acontece o tempo todo. Um ptmalloc2 leva uns 300 nanossegundos por operação. Mas não adianta ser rápido se ele “vaza” memória ou seja, usa mais memória do que o necessário, em parte porque não foi inteligente e deixou a memória fragmentar demais. Existem várias syscalls mas em C você normalmente chama pelas funções malloc, passando um tamanho que precisa alocar, e a função free que sinaliza ao sistema operacional que esse endereço pode ser liberado quando puder. 


Quando você chama a função malloc, o único parâmetro que passa é quanto de memória quer alocar, e ele devolve como retorno o endereço que ele achou onde cabe um pedaço de dados do tamanho que você pediu. Se você tiver pouca RAM e vários processos fragmentando memória, você vai notar que teoricamente era pra caber mais programas na RAM mas por alguma razão falta memória. Um programa mal escrito pode estar alocando mais memória do que deveria, e não devolvendo. E mesmo devolvendo o sistema ainda pode não ter colocado essa memória à disposição. 


Pra piorar, eu já expliquei sobre concorrência e paralelismo e todos os problemas que você enfrenta ao lidar com threads reais, lembra? Existe um outro problema: e se várias threads pedem ao alocador pra reservar memória ao mesmo tempo? Acabamos de criar uma contenção, ou seja, um gargalo. Se o alocador não suportar threads corretamente, o que acontece é um lock do alocador e cada thread tendo que esperar o anterior receber seu pedaço de memória. Na verdade o tal ptmalloc que eu falei é um fork do antigo dlmalloc justamente pra suportar threads.


Só de entender o problema de fragmentação e agora o problema de threads, você deveria começar a entender que fazer uma chamada em malloc não é um troço simples. Pra começar a forma de suportar threads é dividir o índice de endereços disponíveis no que o malloc chama de Arenas. Num Linux 32-bits o padrão é 2 vezes o número de cores. Então num computador quad-core com hyper threading você pode ter até 8 threads e por isso até 16 arenas. De forma simplista se todas as threads pudessem ter qualquer endereço do espaço de 32-bits, o alocador ia precisar criar um lock global e as threads perderiam totalmente sua performance e ficaram mais tempo em fila esperando o alocador do que realmente trabalhando em paralelo. Mas se você tem 4 cores e disser que do endereço 0000 0000 a 3FFF FFFF é da thread 1, do endereço 4000 0000 até 7FFF FFFF é da thread 2 e assim por diante, agora elas não compartilham endereços e você não precisa de um lock. Lembra que eu dei a dica já que a forma de você não ter que lidar com mutexes e locks em concorrência é não compartilhar nada entre as threads?


Agora as Arenas ainda são sub-divididas em Heaps ou montes. Seu programa quando executa pode armazenar dados na stack ou pilha ou no heap. A pilha é literalmente a pilha de execução, seu programa carrega as instruções na stack e pequenas quantidades de dados cabem no stack, se usar demais ou de forma errada vai ter o famoso Stack overflow. Se a memória fosse uma página de papel, pense na stack crescendo de cima pra baixo e o Heap começando de baixo pra cima. Não é exato mas é uma forma de visualizar. Na prática seu programa vai armazenar a maior parte dos dados que precisa pra trabalhar no Heap e na stack podem ficar coisas como valores constantes ou coisas assim.


Uma heap é ainda sub-dividido em múltiplos chunks. Podemos ter chunks muito pequenos de até 80 bytes, chunks de até 512 bytes e chunks grandes de mais de 512 bytes, que é como o ptmalloc organiza. Podemos agrupar os chunks menores em caixas ou bins, no caso os de até 80 bytes no que se chama Fast Bin, os de até 512 bytes num Small bin e os maiores que 512 bytes num Large bin. Por que isso? Pra minimizar fragmentação. Você fragmenta a memória mais rápido se tentar misturar pedaços grandes no meio de pedaços pequenos. É melhor agrupar pedaços de tamanhos similares mais próximos, porque se você desaloca um chunk de 16 bytes no Fast Bin, quando precisar alocar 16 bytes de novo, é mais fácil procurar direto no Fast bin. E se tentar alocar alguma coisa de 1 MB é melhor ir no Large Bin. E no começo você aloca poucos bins, e vai alocando mais à medida que precisar.


Lembre que toda essa organização ainda não está na prática “usando” a memória ainda. Está só criando estruturas que representam caixas de endereços. Daí a alocador vai pegar desses bins, dependendo de que thread está pedindo e que tamanho de memória pediu. Se você tem boa intuição está entendendo que seu processo sempre vai usar um pouco mais de memória do que ele realmente precisa por causa dessa organização e estruturas de suporte que o alocador precisa. Quanto mais tempo um processo fica vivo trabalhando, mais essas atividades de alocar e desalocar memória podem is expandindo, crescendo o heap e causando leaks se o programa for mal escrito, causando fragmentação demais.


Mas o pior não é isso, eu disse que Arenas são divisões para evitar contenção de lock de threads. E se sua aplicação inicialmente carregar 300 MB de estruturas na primeira arena. Mas agora numa segunda fase outra thread precisa trabalhar essas estruturas mas ela vai usar outra arena? Os 300 Mb vão ser copiados de uma arena pra outra porque o ptmalloc não suporta mover memória entre arenas. De repente seu programa inicia usando o dobro do que ele realmente precisa. Esse é um problema real relatado por engenheiros do Google e por causa disso eles criaram um outro alocador de memória, chamado de tcmalloc, que justamente permite cachear dados entre threads e por isso se chama Thread-Caching malloc ou tcmalloc. 


Se algum dia esbarrar num tutorial que fala de tcmalloc, lembre que ele é do Google. Ele é mais rápido que o ptmalloc2 do glibc, chegando a ser até 6 vezes mais rápido e usando estruturas de dados mais eficientes, então também usando bem menos memória no geral. E como o tcmalloc implementa as mesmas funções POSIX como o malloc(), free(), calloc(), realloc() e outros. O Google mesmo diz que ele não é necessariamente 100% compatível e alguns programas podem ter problemas, mas na grande maioria, você consegue carregar o tcmalloc e seus programas devem funcionar mais rápido, usando menos memória e, se for um programa que fica de pé por dias seguidos como um servidor de aplicação, ele também deve tender a alocar menos memória no geral.


Tcmalloc foi criado mais de 10 anos atrás, e na mesma época, com o Firefox 3 o alocador de memória do Windows da época fragmentava demais, ou seja, o navegador tendia a crescer no uso de memória como eu já expliquei que acontece, numa ordem de pelo menos 20% ou mais de desperdício. Se o processo usar 1 GB ele vai desperdiçar 200 Mb só em fragmentação. Nessa época um engenheiro chamado Jason Evans queria resolver o problema de gerenciamento de memória de uma linguagem experimental que ele estava criando e pra isso fez um novo alocador. Esse alocador passou a ser usado no Firefox e foi um dos motivos de porque Firefox no Windows conseguia desperdiçar menos memória. Com o tempo esse alocador foi adotado pelo Facebook porque seus servidores também estavam desperdiçando muita memória. Esse alocador foi devidamente nomeado de jemalloc por causa de Jason Evans. Com o tempo o jemalloc se tornou mais rápido, mais robusto e confiável e desperdiçando ainda menos memória que o tcmalloc do Google. Inclusive acho que ele é mais compatível com o ptmalloc2 e você poderia trocar o alocador do seu Linux por jemalloc e tudo vai funcionar melhor. 


De curiosidade, a linguagem Rust, assim como o Firefox, são da mesma fundação Mozilla e por isso o Rust desde o começo sempre usou o jemalloc, que é um dos motivos de porque ele é eficiente com memória. A grande maioria das outras linguagens ainda usam o ptmalloc2 do glibc. Linguagens como Python, Ruby também se beneficiam se você fizer o interpretador usar o jemalloc. Vou deixar nas descrições abaixo como fazer isso no Ruby. 


Agora, isso vale pra linguagens que ativamente usam o alocador do sistema operacional. C, ou C++, ou Rust que já falei, todos que compilam pra binários nativos vão usar o ptmalloc2 ou o jemalloc hoje em dia. Pra variar, o Go não usa nenhum que já existia. Um ptmalloc2 usa funções de mais baixo nível ainda do sistema operacional como mmap, madvise, munmap, sbrk. O Go reinventa a roda e implementa seu próprio alocador meio inspirado, claro, no tcmalloc do Google. O Go também divide a memória em várias arenas. Esse conjunto de arenas é o que ele chama de Heap. Ele organiza as arenas em páginas de 8kb. Ele também divide esses blocos em bins pra tamanhos diferentes de chunks mas no caso do Go os nomes são diferentes ele tem um Tiny pra objetos menores que 16 bytes, um Small pra objetos menores que 32 kb e um Large pra coisa maiores que 32 kbytes. Esse valores dependem da versão do Go, então não decorem isso, só lembrem que o alocador agrupa blocos de tamanhos similares, como o ptmalloc2 já fazia também. E que é uma das estratégias pra diminuir a fragmentação.


Escovamos bits demais por hoje, vou ter que dividir esse episódio em duas partes de novo. Neste episódio tivemos mais noção de como o sistema operacional realmente organiza a memória, as diferenças de arquiteturas 32-bits ou 64-bits, e os diferentes tipos de alocadores. E como um bônus de termos já discutido sobre threads nos últimos episódios, vimos agora como eles afetam o gerenciamento de memória também. Na semana que vem vamos falar sobre os famosos garbage collectors, que muita gente ainda acha que é mágica, mas na prática não tem idéia de como funcionam.

