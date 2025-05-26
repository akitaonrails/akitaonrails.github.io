---
title: "[Akitando] #46 - Gerenciamento de Memória (Parte 2) | Entendendo Back-end
  para Iniciantes (Parte 6)"
date: '2019-04-03T17:01:00-03:00'
slug: akitando-46-gerenciamento-de-memoria-parte-2-entendendo-back-end-para-iniciantes-parte-6
tags:
- ptmalloc2
- tcmalloc
- jemalloc
- ruby
- java
- jvm
- garbage collector
- python
- golang
- memory
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/DGU1awKrNiA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


Finalmente, chegamos no último episódio do tema de Back-End! 

Devo dizer que este foi um dos episódios que eu mais queria explicar. Toda nova linguagem hoje em dia tem Garbage Collector. Mas a maioria dos programadores não tem a mínima idéia de como eles funcionam.

Mais importante: todos acreditam que garbage collectors são mágicos e "simplesmente funcionam" mas não entendem quais são os reais motivos de porque eles existem, quais problemas eles resolvem, e quanto eles CUSTAM pro seu programa. Sim! Nenhuma mágica vem de graça.

Hoje vamos usar o que aprendemos até agora pra finalmente olhar linguagens como Objective-C/Swift, Python, Ruby, Java, Erlang/Elixir, Go e entender como eles diferem no gerenciamento de memória.


Links:

* Sun Java System Application Server 9.1 Performance Tuning Guide (https://docs.oracle.com/cd/E19159-01/819-3681/abeio/index.html)
* Garbage collection in Python: things you need to know (https://rushter.com/blog/python-garbage-collector/)
* What causes Ruby memory bloat? (https://www.joyfulbikeshedding.com/blog/2019-03-14-what-causes-ruby-memory-bloat.html)
* Demystifying the Ruby GC (https://samsaffron.com/archive/2013/11/22/demystifying-the-ruby-gc)
* Erlang Garbage Collector (https://www.erlang-solutions.com/blog/erlang-garbage-collector.html)
* Go, don't collect my garbage (https://blog.cloudflare.com/go-dont-collect-my-garbage/)
* Tuning glibc Memory Behavior (https://devcenter.heroku.com/articles/tuning-glibc-memory-behavior)
* The status of Ruby memory trimming & how you can help with testing (https://www.joyfulbikeshedding.com/blog/2019-03-29-the-status-of-ruby-memory-trimming-and-how-you-can-help-with-testing.html)
* HOW THREE GUYS REBUILT THE FOUNDATION OF FACEBOOK (https://www.wired.com/2013/06/facebook-hhvm-saga/)
* Ruby Memory Environment Variables - Simpler Than They Look. (http://engineering.appfolio.com/appfolio-engineering/2018/6/27/ruby-memory-environment-variables-simpler-than-they-look)
* "WEAK, STRONG, UNOWNED, OH MY!" - A GUIDE TO REFERENCES IN SWIFT (https://krakendev.io/blog/weak-and-unowned-references-in-swift)

Olá pessoal, Fabio Akita

Este é o décimo primeiro episódio da série começando aos 40, parte 2 do tema de Gerenciamento de Memória, parte 6 e conclusão do tema de Back-end, finalmente!! Semana passada eu dei uma escovada de bits, expliquei um pouco sobre as diferenças de arquiteturas 64-bits e 32-bits, entendemos rapidamente sobre notação binária e hexadecimal, os diferentes tipos de memória e como os diferentes alocadores fazem seu trabalho pra resolver os problemas de fragmentação e alocação eficiente em ambientes com múltiplas threads reais.


No episódio de hoje vamos uma camada pra cima e explorar mais sobre os famosos garbage collectors, que muita gente ainda associa mais com Java, mas que a maioria das linguagens interpretadas e baseadas em máquinas virtuais possuem. O grande truque é balancear processamento e uso de memória. Se ficar tentando economizar memória, o collector precisa trabalhar mais e, por consequência isso diminui a performance geral da sua aplicação. Por outro lado, se o collector rodar pouco pra aumentar a performance geral, você vai acabar usando mais memória do sistema e em ambientes de servidor onde os processos ficam de pé por dias ou semanas sem descarregar, isso pode ser um problema também. Então, como eles fazem pra balancear os dois?




(...)



Recapitulando, no episódio anterior falamos um pouco das diferenças de alocadores como o ptmalloc2, tcmalloc do Google e o jemalloc que o Facebook usa. No fim, todo alocador vai querer resolver o problema de fragmentação, o problema de contenção de threads, o problema de cache entre threads. E agora temos os garbage collectors. Pense em garbage collectors como sendo um alocador em user-land. Ele faz syscalls pro sistema operacional, como o malloc() pra pedir blocos grandes de memória e internamente gerencia como esse pedação vai ser usado. Python, Ruby, Erlang, Javascript, .NET, Java e por consequência toda linguagem que roda em cima de Java como Scala, Clojure, Kotlin, usam o mesmo garbage collector da JVM. Assim como schedulers the coroutines em user-land são mais rápidos como eu já expliquei em episódios anteriores, um alocador em user-land também é mais rápido do que fazer syscalls pra funções no kernel-space como mmap ou munmap que é o que funções como malloc() fazem.


Todo garbage collector faz algumas coisas meio básicas. Não dá pra explicar no detalhe como o collector de cada linguagem funciona, mas vamos ver os conceitos comuns. Pra começar, existem linguagens que lidam com ponteiros, ou seja os tais endereços virtuais diretamente, e os que lidam com referências que são como se fossem atalhos pros endereços. Garbage collectors existem principalmente porque nós programadores somos muito ruins em liberar memória manualmente.


Se você teve que lidar com C, sabe que precisa chamar a função free() pra toda memória que deu malloc() antes. Esqueça de dar free e seu programa vai começar a ter leaks ou vazamentos e vai ficar crescendo sem parar. Parece super simples, mas toda regrinha desse tipo você pode ter certeza que vai esquecer. Basta esquecer de digitar uma linha ou apagar uma linha do código com free por acidente. Ou pior, se você der free numa memória que ainda não era pra dar free, vai ficar com um Invalid Pointer por exemplo e seu programa pode crashear. Quando você adiciona classes e objetos em cima do C e gera um C++ a coisa fica pior ainda porque você vai passando ponteiros de objetos pra outros objetos numa árvore gigante de dependências. Quando que você pode destruir um objeto sem deixar outro que dependia dele corrompido?


Uma das formas de resolver esse problema é adicionar a todo objeto um contador. E toda vez que você passar esse objeto pra outro objeto ou função, incrementar o contador. Quanto mais objetos apontarem pra esse primeiro, maior vai ficando o contador. À medida que os objetos que apontam pro primeiro também forem sendo liberados, o contador vai decrementando. E quando o contador voltar a ser zero, daí você sabe que ninguém está mais usando e pode liberar esse objeto. Como estamos falando de contagem de referências, você vai ouvir falar nessa estratégia como Reference Counting. Linguagens como Python e Objective-C e, por consequência, Swift usam essa estratégia.


No caso do Objective-C ele vai um passo além, ele inclui uma classe chamada NSAutoreleasePool, um tanque de alocação. Você instancia um pool e à medida que vai alocando novos objetos esse pool fica sabendo deles. Diferente de um garbage collector, em Objective-C você manualmente instância quantos pools quiser, e tem que manualmente chamar release no objeto que, diferente da tal função free(), vai só decrementando o contador de referência. E quando quiser pode chamar o método release do pool, que por sua vez dá free de verdade nos objetos com contador zerado.


Nas versões mais novas do Objective-C e no Swift, coisa da última década, a Apple adicionou o ARC ou Automatic Reference Counting. Na prática ele vai cuidar de adicionar o código pra dar release do contador usando algumas dicas no seu código, durante a compilação. Vale a pena estudar em detalhes como o ARC funciona se você faz programas pra iPhone ou Mac, mas 90% dos casos você não se preocupa tanto com a memória e vai precisar saber mais quando tiver bugs ou quiser otimizar o uso de memória, por exemplo forçando a limpeza do pool mais vezes. Digamos que você está lendo um arquivo com 500 linhas, em vez de fazer o loop e só no final limpar tudo de uma vez, você pode ir dando release no pool manualmente a cada 50 linhas por exemplo e evitar que o sistema aloque mais memória do que precisa. Se você desaloca memória com muita frequência, vai usar mais CPU e diminuir a performance geral, por outro lado vai consumir menos memória. Se você desalocar com pouca frequência, aumenta a performance, mas também aumenta o uso de memória.


Um problema de contagem de referências é o caso de reference cycle ou seja, você tem objeto A com uma referência pro objeto B daí no B fazemos uma referência pro objeto A, agora ambos os contadores de A e de B nunca vão ser menores que 1, e o pool não vai conseguir desalocar a memória desses objetos mesmo que ninguém mais esteja usando, porque os contadores não são zero. Por isso em Objective-C e Swift você tem a diferença entre strong references que são as referências normais. Mas também temos referências weak e unowned, nenhuma das duas incrementa o contador e isso quebra o ciclo de referências. No caso a referência do objeto B pro objeto A poderia ser declarada como Weak e daí o contador de A chegaria a zero normalmente e ambos poderiam ser limpos. Novamente, você precisa ler em mais detalhes a diferentes de uma referência Weak e Unowned que vou deixar nas descrições abaixo. Linguagens com contadores de referência como Python costumam ter a opção de referências fracas ou Weak.


Controlar os contadores de uso de cada objeto é uma forma de você não precisar manualmente liberar objeto a objeto quando não precisa mais. Basta ter um controlador como o NSAutoreleasePool que consegue limpar todo objeto com contador zerado de uma vez só. Em C++ temos smart pointers que funcionam mais ou menos parecido. Um garbage collector muito simples poderia simplesmente ser uma thread que, de tempos em tempos, manda limpar esse pool. Seria uma forma rudimentar de garbage collector. Mesmo Python trabalha com contador de referências também, mas seu collector é mais sofisticado do que só isso.


Eu falei que em Objective-C você pode criar quantos pools quiser e controla eles manualmente. Outra forma é esse Pool ser tipo uma estrutura global e única, é como funciona em Ruby e em Java e acho que em .NET também. Pense numa lista gigante, onde sempre que precisarmos de memória pedimos pro alocador que vai adicionando nessa lista também, catalogando todos os elementos que vão sendo alocados. Toda vez que você passa a referência desse elemento pra outro objeto, ele vai criando uma árvore de dependência. Objeto A pode ter referências pros objetos B e C, e o objeto C tem referência pro objeto D. Depois de algum tempo, a variável que aponta pra A deixa de existir, por exemplo o método retornou ou você passou nulo pra variável e então ninguém mais aponta pro objeto A.


Com o tempo vários objetos vão ficando nesse estado, onde ninguém mais aponta pra eles a não ser a lista global que falei. Então de tempos em tempos um processo especial chamado collector, numa thread no interpretador ou na VM, poderia ir vasculhando essa lista por todos os objetos que ninguém mais está apontando e ir só marcando. Depois um segundo processo poderia ir na mesma lista, elemento a elemento, desalocando os objetos que foram marcados. Então se a lista tinha 1000 objetos, cada um ocupando 1 slot da memória, na fase de marcação 500 objetos foram marcados como não usados, e na fase de limpeza esses são liberados os 500 slots pra uso. Sendo ultra simplista é isso que chamamos de um garbage collector Mark and Sweep. É um collector de duas fases, onde em cada fase ele precisa vascular elemento a elemento da lista de alocação, fazendo um mark na primeira fase e sweep na segunda.


Porém, quando eu falo desalocar não quer dizer devolver memória pro sistema operacional. Lembra do problema de fragmentação? Se eu ficar devolvendo memória toda hora, muito rapidamente a memória do processo vai ficar fragmentado. Linguagens como Ruby ou Java começam pedindo um certa quantidade de blocos de memória pro sistema operacional. No caso de Ruby tem o equivalente de chunks que ele chama de slots, cada slot tem um tamanho fixo de 40 bytes onde cabe toda a estrutura que define um objeto de Ruby. 


Então ele só lida com slots fixos de 40 bytes. Um conjunto desses slots é chamado de Heap. Não confundir com o Heap do malloc de C, é o mesmo nome mas tanto Java quanto Ruby chamam conjuntos de slots ou chunks de Heaps. No caso do Ruby existem várias variáveis de sistema pra configurar o alocador, como por exemplo o RUBY_GC_HEAP_INIT_SLOTS, que por padrão o valor é 1000. Um heap de Ruby costuma ter 16 kbytes. Ou seja, ele vai alocar de 40 bytes x 1000 que seria quase 40 kbytes ou pelo menos 2 heaps.


Se acabar os slots disponíveis, o alocador do Ruby vai pedindo pra alocar mais heaps, vários slots de uma só vez. Digamos que ao carregar seu programa ele precisou de 10 mil heaps, ou seja, uns 156 megabytes. Agora digamos que depois de rodar por um tempo, uns 500 mil slots de objetos foram marcados como não usados mais. Na fase de Sweep você imaginaria que ele vai devolver 500 mil x 40 bytes que dá quase 20 megabytes, de volta pro sistema e em vez de ocupar 156 megabytes ele vai passar a usar 136 megabytes. Mas não, no final do Sweep seu programa vai continuar usando os mesmos 156 megabytes. Por que? Porque ele só vai liberar os slots da lista global, mas a memória de verdade continua alocada. Quando você criar novos objetos nos slots livres, ele vai reusar e escrever em cima do mesmo trecho de memória de antes. 


De cara temos estratégias diferentes entre o Heap de uma linguagem como Ruby  ou o Heap de uma linguagem como Java. No caso de Java, todos os objetos ocupam espaço no Heap. No caso de Ruby só a estrutura e dados muito pequenos ocupam os slots de 40 bytes. Mas um array ou um string costuma ser muito maior que 40 bytes, então o Ruby chama a syscall malloc do sistema operacional e guarda o endereço alocado no slots de 40 bytes apontando pro espaço fora do Heap. A vantagem do Ruby é que todo objeto tem o mesmo tamanho dentro do Heap e isso ajuda a não fragmentar tanto, mas ele depende do alocador do sistema operacional pros blobs de dados maiores. No caso do Java ele não tem que se preocupar com o sistema operacional, porque ele usa só sua memória interna do Heap, mas outro lado isso vai causar fragmentação interna e ele tem uma forma de evitar isso, que vamos ver já já. Mas só pra entender que diferentes collectors organizam seus dados internamente de formas diferentes.


Do ponto de vista de programação, se você ainda não entendeu, alocar memória desnecessariamente vai aumentar o tamanho dos heaps ou a quantidade de heaps, dependendo do alocador, e isso vai bloquear memória do sistema operacional e causar fragmentação desnecessária também. Você não pode achar que vai alocar 1 giga de dados, devolver esses 1 giga, e vai continuar tendo bonitinho 1 giga de novo sobrando. Você vai fazer o alocador ter que trabalhar muito pra evitar a fragmentação e se seu sistema tiver pouca memória geral, provavelmente não vai conseguir ter esse espaço livre de volta.


Exemplos de má programação é o famoso caso de abrir um arquivo gigante de vários gigas na memória, ou conectar num banco de dados e não fazer o select com os critérios de where certos e acabar puxando muito mais linhas da tabela do que precisava. Tudo isso vai ocupar espaço, o alocador vai ter que esticar os heaps, mais memória do sistema vai ser consumido, e não necessariamente ele vai liberar essa memória de volta pro sistema. Mesmo depois que o collector limpar os slots ocupados por esses dados, você ficou com um heap inchado e fragmentado. E se seu servidor for pequeno, você vai começar a ter problemas de memória mesmo que teoricamente tenha “memória sobrando” ainda.


Se seu programa rodando em produção tem leaks de memória, normalmente são dados que vem da rede, como dados do banco de dados, ou processamento de arquivos grandes. O ideal é sempre seu código tentar usar memória até um limite. E quando precisa puxar dados externos, ter algumas checagens pra ver se não vai usar memória desnecessariamente. Tipo checar o tamanho de um arquivo antes de carregar ele inteiro na memória. Se for arquivos pequenos de alguns kbytes, dá pra ler tudo e armazenar numa variável de string. Mas se for um arquivo de gigabytes, é melhor abrir como um Stream e ir lendo pedaços do arquivo de cada vez. Ou quando precisa puxar dados de uma tabela num banco de dados, usar coisas como um limit no select pra limitar quantas linhas vai puxar de uma só vez. Famoso caso que o amador fala que na máquina dele funciona, só que na máquina dele ele só testou com arquivos pequenos e com tabelas com 10 linhas de teste. Por isso quando vai pra produção tem esse comportamento. Isso porque é um programador que não tem noção de gerenciamento de memória.


Voltando, outro problema é se seu programa é grande e aloca milhões de objetos. Toda vez que o processo de Mark e Sweep rodar, eles precisam passar por todos eles, um por um, toda vez. Mesmo que só leve uma fração de milissegundo pra marcar e sweepar cada objeto, ainda assim vai levar dezenas de segundos pro processo todo se contar milhões de objetos alocados. É muita coisa. Pior ainda, toda vez que você vai marcar os objetos ou limpar, precisa pausar o programa todo, é o que chamamos de Stop the World. Isso porque você tem que garantir que o programa rodando ao mesmo tempo que o collector não se corrompa tentando acessar um objeto que acabou de ser desalocado. Só que se você pausar seu programa por muitos segundos, ele vai ficar muito lento. 


Ou seja, carregar dados desnecessários não só desperdiça memória como desperdiça performance. Agora você só tem 2 escolhas. A primeira é rodar poucas vezes o Mark e Sweep, mas aí você arrisca consumir muita memória e fazer seu heap crescer demais já que sempre que precisa de mais memória e não tem slots pra reusar ele vai pedir mais pro sistema operacional. E eu já disse que toda memória que ele aloca do sistema ele não devolve mais ou vai demorar pra devolver pra evitar fragmentação, daí seu processo vai crescer mais do que devia. A segunda escolha, se você quer evitar isso então tem que rodar mais vezes o Mark e Sweep só que daí a performance geral do programa vai ficar lento. Ou seja, agora você tem que escolher entre performance ou uso de memória.


Pra resolver esse problema é que existe a idéia de Generational Garbage Collectors. Ele vai dividir a memória interna do interpretador ou da máquina virtual em 2 ou mais gerações. Java divide seus heaps em grupos chamados Young, Old e Permanent (por isso você vira e mexe vê configuração em tutorial de JVM pra configurar coisas como o Permsize que é o tamanho desse espaço permanente). O garbage collector G1GC novo do Java chama de Eden, Survivor e Old. Python chama só de geração zero, um e dois. 


A idéia vem de uma hipótese chamada Weak Generational Hypothesis. Em linhas gerais essa hipótese diz que objetos novos tendem a morrer jovens e objetos velhos tendem a ficar ativos por muito tempo. Parece óbvio quando falamos assim, né? Eu já expliquei como o sistema operacional divide a memória em arenas por exemplo, pra evitar contenção de threads. Agora vamos dividir mais ainda pra evitar passagens desnecessárias por objetos que não vão morrer tão cedo.


O problema que um generational garbage collector quer resolver é diminuir ao máximo as pausas da fase de mark and sweep. A forma de fazer isso é evitar ficar olhando objetos que nunca vão ser limpos. Por exemplo, objetos singleton que seu programa carrega no começo e vai usar até morrer. Num Ruby, toda classe é um objeto. Mas as classes raramente precisam ser limpas, então pra que perder tempo olhando pra elas toda vez? Em resumo, na primeira vez que o mark passar, ele vai ter que olhar tudo. Objetos que sobrevivem a múltiplas passagens da fase de mark podem ser promovidos da geração Nova pra geração Velha e se sobreviverem mais algumas passadas de mark, podem ser promovidas pra geração permanente.


Podemos dividir as fases de Mark em Minor e Major. O Minor só olha pros objetos mais novos e ativos na geração Nova. O Major olha também pra geração Velha pra ver se algum precisa ser limpo. Mas uma ver promovido pra permanente, podemos esquecer desses objetos. Digamos que um programa normal tenha 100 mil objetos, e que depois de algumas passadas da fase de Mark 50 mil deles tenham sido promovidos pra geração permanente. Os outros 50 mil são objetos que morrem, e novos que são criados e na média ficam sempre uns 20 mil na geração nova, uns 30 mil na geração velha. A performance total da fase de mark é pelo menos o dobro, porque você no mínimo vai passar por metade dos objetos toda vez. E tende a ser mais rápido que isso porque você passa menos vezes na geração velha também. Então é um ganho enorme de performance.


Numa linguagem como Ruby ou Python, esses segmentos como eu disse são só listas com ponteiros pros slots ocupados. Como por baixo é tudo estrutura em C temos endereços e como as extensões em C podem precisar do endereço exato de determinada estrutura não podemos mover os dados de lugar.


Eu menciono isso porque em Java temos uma coisa extra. Java não lida diretamente com ponteiros, ele trabalha com referências no nível da linguagem. Uma variável em Java aponta pra uma referência e a referência, por baixo dos panos, é indexada num endereço. Mas o endereço pode mudar. Diferente de Ruby ou Python, em baixo nível o alocador pode mover o objeto de um slot pra outro nos heaps. Mover fisicamente vai mudar o endereço e aí eu mudo na referência. Mas no alto nível a variável no Java só vê a referência então pra ele nada mudou. Uma coisa é eu dar um produto na mão de uma pessoa. Agora não posso mais tirar o produto da mão dela sem ela reclamar. Outra coisa é eu dar um vale produto pra pessoa. Agora no estoque tanto faz se eu mudar o produto de lugar, o que vale é a referência.


Isso é importante porque na JVM quando acontece a fase de promover os objetos da geração jovem pra geração velha, em vez de só mover o ponteiro de um segmento pra outro de uma lista, na verdade eu estou movendo o objeto de um slot da geração jovem pra um slot da geração velha, fisicamente falando. Estou copiando de um slot pro outro e depois liberando o primeiro slot. Então fisicamente na memória, os heaps de Java tendem a ser menos fragmentados que num Python ou Ruby. 


E os objetos de Java podem alocar tudo dentro do objeto em vez de usar a estratégia de dividir o objeto em 2 partes, sendo uma estrutura de tamanho fixo e o resto dos dados alocados fora dos heaps via malloc do sistema operacional. Nesse caso os objetos de Java tem tamanho variável, o que causaria fragmentação como eu já falei mas como ele pode mover os objetos de lugar e ir defragmentando a cada passada do collector, então evitamos fragmentação. É como se o collector do Java fosse também ao mesmo tempo um defragmentador e de fato ele tem uma fase chamada compaction, que move objetos de lugar pra defragmentar se o coletor perceber que o heap acumulou muita fragmentação.


Se não ficou claro, nos diagramas que mostrei até agora, parece que todos os objetos estão movendo de um espaço de memória pra outro. Isso é verdade no Java. Mas num Ruby os objetos não se movem de lugar, os endereços são fixos. Faz de conta que existam listas como uma lista ligada ou um array grande. Cada elemento da lista é um endereço pra memória real, e as listas são as gerações. Então quando eu falo que o objeto é promovido de uma geração pra outra, na memória real nada acontece, só o endereço que sai de uma lista e vai pra outra lista. Num Java, a estratégia de gerações a ajuda a diminuir fragmentação porque à medida que os objetos são promovidos eles movem de lugar na memória e isso vai defragmentando. Mas num Ruby a fragmentação se mantém a mesma, o que vai melhorar é a velocidade do Mark and Sweep.


Esse tipo de processo é o que chamamos de um Compact Copying Collector. A principal função é diminuir a fragmentação da memória. Se você tinha curiosidade, os garbage collectors do Erlang e do .NET são similares. Eles são generational, e tem copy collectors. Os princípios são os mesmos. Só linguagens que lidam com ponteiros e endereços físicos diretamente como as linguagens que compilam nativamente sem um runtime que abstrai a memória ou os interpretadores, não tem como fazer compact ou copy e tendem a fragmentar mais. Não quer dizer que é impossível fazer a parte de copy. Se você mudar um objeto de lugar, ele ganha um novo endereço, agora você precisa garantir que quem tente acessar o endereço antigo caia no novo, algo como uma barreira de leitura. Um dos meus problemas com acesso a ponteiros não é só por aritmética de ponteiro, mas porque dificulta defragmentação via compact copying. Era o que o Go pretendia fazer, mas se não me engano até agora eles não implementaram a fase de copy.


Além disso podemos executar partes dessas fases concorrentemente e paralelamente usando threads reais. Por isso em JVM você ouve falar de nomes como Parallel GC ou ConcurrentMarkSweep GC. O primeiro usa múltiplas threads. O segundo só uma thread, mas ele pausa o mundo só na fase inicial de mark e sweep, mas depois ele roda paralelamente à aplicação. JVM pra servidor usava o Parallel GC por exemplo. Hoje em dia temos o G1GC que usa gerações menores de segmentos 0, 1 e 2 ou Eden, Survivor e Old como expliquei acima, mas ele usa múltiplos segmentos de cada geração em vez de segmentos contíguos e outros algoritmos. 


O problema de rodar concorrentemente é a fase de Mark and Sweep, que exige a tal pausa do programa ou Stop the World. Pra evitar isso, linguagens como Erlang implementam uma versão melhor que é mais custosa mas evita a pausa, chamada Tracing collector. Pense uma fase de mark dividida em 3 fases, como se fossem gerações, usando alguma variação do algoritmo chamado Tri-color, onde determinamos cores como preto, cinza e branco e no mark os objetos são movidos pra preto ou branco, e no final quando nenhum objeto for cinza, podemos fazer sweep de todos os objetos que sobraram com a cor branca. A vantagem disso é que podemos fazer essa marcação sem precisar pausar o programa. O Incremental Mark and Sweep do Ruby usa estratégia de Tri-color pro que se chama de Minor GCs ou fases de mark mais rápidas.


O collector do Java tem vários outras estratégias além do que expliquei até agora. De qualquer forma, o que chamamos de um garbage collector, completo, poderia ser um “Parallel Concurrent Generational Incremental Mark and Sweep Copy Compactor Collector”. Ruby e Python fazem algo similar, com a limitação de não poderem ser copy collectors nem rodar collectors concorrentemente. Javascript faz a mesma coisa também.


Generational garbage collectors tendem a usar mais memória pra manter todas as estruturas e segmentos pra cada geração. Ou seja, é um overhead mais alto do que o jeito do Objective-C e Swift. Linguagens compiladas nativamente com um runtime pequeno como C ou Objective-C tendem a depender principalmente do alocador do sistema operacional como o ptmalloc2 ou jemalloc. Linguagens interpretadas são híbridos, ele tem um espaço de heaps alocados com alocador em user-land pra gerenciar os objetos mas usam o alocador do sistema operacional pra blobs maiores como blocos de texto ou arrays grandes. 


Uma JVM, se não me engano, pede pro sistema operacional alocar um espaço grande no começo do boot, mas depois ele se vira só em user-land. Vai usar mais memória, mas como não depende de syscalls, tende a ser mais rápido. Ao mesmo tempo, linguagens compiladas e interpretadas dependem do alocador do sistema operacional pra gerenciar a fragmentação de memória como já expliquei no episódio anterior. Uma JVM controla a fragmentação ele mesmo via o processo de copy collector onde ele consegue mover os objetos de lugar.


Falando no alocador do sistema operacional, o ptmalloc2 que é o malloc do glibc que a maioria das linguagens usa, aloca arenas pra cada thread real como já expliquei no episódio anterior. Pior ainda, ele não tem thread-cache ainda como o tcmalloc ou jemalloc. Portanto quanto mais arenas ele alocar, mais memória vai desperdiçar. E o multiplicador pra máquinas 32-bits são de 2 vezes o número de threads reais ou seja, máquinas quad-core com hyperthreading que dá 2 threads por core significa pelo menos 16 arenas. Mas em máquinas 64-bits o multiplicador é 8 então são 8 vezes 4 cores vezes 2 threads que dá 64 arenas!! É muita arena. Em estudos do Heroku que é uma plataforma de serviços para deployment de aplicações em ambiente virtualizado eles recomendam diminuir o teto de arenas. Em máquinas pequenas, com 2 cpus virtuais, em testes empíricos ficou notável que configurar o teto pra 2 arenas é mais que suficiente.


Segundo Hongli Lai, CTO da Phusion, o motivo desse multiplicador ser tão alto pode ser porque o principal desenvolvedor do alocador de memória é da Red Hat que vende produtos e serviços pro mundo enterprise. Lá a prioridade é aumentar performance mesmo que isso custe desperdiçar muita RAM. 10% a mais de performance por 30 vezes mais memória é uma conta que o mundo Enteprise topa pagar. Mas pra gente que precisa balancear performance com uso de memória pra escalar, a recomendação é simples, basta exportar a variável MALLOC_ARENA_MAX pra 2 e pronto. Só isso já vai evitar muitos vazamentos de memória por mau uso de arenas.


Gerenciamento de memória é um assunto absurdamente longo. Até este ponto eu expliquei tudo em linhas gerais. Cada parágrafo deste episódio tem uma literatura gigante que você vai precisar procurar pra entender em mais detalhes. Eu falei de copy collectors numa linha, como se fosse algo trivial, mas não é. Eu falei de thread-cache de malloc como se fosse uma correção simples do ptmalloc2 pro tcmalloc, mas não é. Eu falei como o jemalloc é mais rápido que o tcmalloc, mas procure os relatos de Jason Evans pra ver o tanto de trabalho que eles tiveram pra reescrever várias partes, várias vezes, até realmente chegar na versão atual. Alocadores de memória são super fáceis de escrever errado, de um jeito que vai ser super lento e consumir gigabytes de RAM à toa e ficar vazando em servidores. Nunca tente escrever seu próprio alocador a menos que tenha toneladas de dinheiro e tempo pra jogar fora.


Por outro lado, você precisa se interessar em estudar todas as formas que seu alocador funciona. Não basta ver quanto seu processo consome quando sobe. À medida que ele roda o garbage collector vai movendo objetos entre gerações, vai alocando memória do sistema operacional pras suas heaps internas que ele não vai devolver pro sistema operacional ou vai demorar pra devolver. Você precisa achar os pontos no seu programa que geram picos de consumo de memória, porque eles que vão pressionar o tamanho do heap e desperdiçar memória do sistema operacional.


Em última instância, você vai lembrar que todo collector tem dezenas configurações pra fazer tuning. Tamanho inicial do heap, fator de crescimento dos heaps, frequência pra rodar os collectors, quantidade de arenas, etc. Normalmente a configuração que já vem é o suficiente pra 99% das aplicações. Não seja ingênuo de achar que seu programa vai ficar muito melhor fazendo tuning dos alocadores ou garbage collectors, praticamente em todos os casos é seu código que desperdiça memória e tuning nenhum vai resolver isso. Mas no 1% dos casos que você já mediu exaustivamente o comportamento da aplicação em produção com dados reais, já corrigiu todo buraco de código possível, então talvez exista alguma chance de um tuning ajudar um pouco. Foi assim que na comunidade Ruby por exemplo descobrimos sobre o tuning de arenas do ptmalloc2 ou trocar pra jemalloc.


Em ambientes móveis, smartphones, é pior ainda, porque você não tem disco pra fazer swap. Significa que diferente de desktops e servidores, se seus programas foram mal feitos e alocarem memória de pico demais sem desalocar, o OOM ou Out of Memory Killer vai entrar em ação e matar seu programa com muita frequência, tornando a experiência do usuário uma droga. Por isso eu particularmente não gosto das soluções antigas de abrir aplicações que são só casca pra um navegador web e dentro carregar uma aplicação Javascript. No Javascript você não tem controle sobre o garbage collector e não tem acesso ao pool de memória como no num app nativo de iOS onde você pode mexer nos NSAutoreleasePool, significa que você está à mercê de um generational garbage collector, que usa mais memória que um app nativo, vai ter pausas de mark and sweep, e um Just in time compiler que também está alocando memória e usando mais CPU o tempo todo, porque otimizar código não sai de graça. Tudo tem um preço. Quanto mais alguma coisa é conveniente, menos ele tende a ser eficiente.


Quando você está programando pra desktop, que hoje em dia é tudo 64-bits, com muitos endereços virtuais sobrando, mesmo que falte RAM, seu sistema operacional vai jogar tudo pra arquivos de swap em disco. Fica lento, mas nada crasheia, por isso hoje em dia ficou comum fazer todo aplicativo desktop ser uma casca de navegador também e rodar apps web dentro. É o que Spotify, ou Slack ou os editores de texto Atom fazem. Consome memória pra caramba e quanto mais tempo eles ficam rodando mais memória vão consumindo. Por outro lado são super convenientes de fazer e você não precisa controlar memória manualmente. Eu ainda tenho preferência por programas nativos bem feitos que alocam memória de formas eficientes sem a necessidade de usar um garbage collector custoso. Um garbage collector é conveniente, mas não é necessário, especialmente em programas desktop.


Como eu já disse antes, tudo é uma questão de trade-off, você troca conveniência por mais lentidão e mais memória. Quanto menos conveniente for, mais você ganha performance e usa menos memória. Não existe um vencedor óbvio, cada caso é um caso. É um aplicativo pra servidor? Pra desktop? Pra smartphone? É grande? É pequeno? Precisa trabalhar quantidades grandes de dados com muita frequência? Precisa coordenar o processamento desses dados paralelamente? Ou de forma distribuída? Tudo isso afeta o que você vai escolher.


Com isso você também deve entender porque eu disse no episódio passado que linguagens com máquinas virtuais como Java ou Erlang preferem tomar conta de todos os recursos da máquina, porque o ideal é deixar eles alocarem toda a memória disponível pra gerenciarem os recursos internamente com seus garbage collectors. Percebam que eles levam pra user-land todas as atribuições do sistema operacional no kernel space. Eles fazem poucas syscalls porque conseguem gerenciar coisas como corotinas e gerenciar memória tudo em user-land.


O Go usa as funções de alocação como um malloc faz e prefere ficar mais baixo nível, mas ao mesmo tempo evitando depender demais do sistema operacional. Ele evita um pouco da fragmentação porque divide a memória em slabs dependendo do tamanho dos chunks como o ptmalloc e outros mallocs fazem. Mas diferente de Java e Erlang ele não tem e vai ter trabalho pra implementar um copy collector porque expõe ponteiros. É o mesmo motivo de porque Python ou Ruby também Não tem copy collectors. Generalizando um pouco, linguagens interpretadas ou com máquinas virtuais tendem a usar mais memória. Linguagens que não expõe ponteiros podem implementar compact copying collectors e evitar mais fragmentação ao custo de usar mais processamento.


E finalmente, chegamos ao último episódio do tema de Back-end! Gerenciamento de Memória era o último assunto pra vocês finalmente terem mais entendimento do funcionamento da máquina e sistema operacional. A discussão sobre linguagens só faz sentido se você entende essas coisas, senão a discussão fica mais parecendo fofoca de telenovela, sem argumentos e só repetindo frases de efeito que alguém disse num tweet ou blog post. Todo mundo só sabe até o ponto que a linguagem tem ou não garbage collector. E todo mundo só acredita que ter um generational garbage collector é bom. Mas ninguém sabe explicar porque é bom e o que você paga tem troca. 


Mais do que isso, sem entender concorrência, paralelismo e gerenciamento de memória, você também não consegue entrar direito em devops e lá também vai ficar só seguindo superstições, mandingas, e repetindo o que ouviu os outros falar sem realmente saber o que está fazendo. Entender como a máquina e o sistema operacional realmente funcionam, pra mim, é o que começa a dividir as crianças dos adultos.


Se você tem dúvida mande nos comentários abaixo, se curtiu mande um joinha, compartilhe com seus amigos, não esqueça de assinar o canal e clicar no sininho pra não perder os próximos episódios. A gente se vê semana que vem, até mais.

