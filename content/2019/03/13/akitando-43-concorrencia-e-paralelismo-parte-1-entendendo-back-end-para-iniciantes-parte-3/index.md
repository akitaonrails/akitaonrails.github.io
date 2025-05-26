---
title: "[Akitando] #43 - Concorrência e Paralelismo (Parte 1) | Entendendo Back-End
  para Iniciantes (Parte 3)"
date: '2019-03-13T17:00:00-03:00'
slug: akitando-43-concorrencia-e-paralelismo-parte-1-entendendo-back-end-para-iniciantes-parte-3
tags:
- concorrência
- paralelismo
- multi-core
- multi-tarefa
- threads
- reactor
- async
- twisted
- nginx
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/cx1ULv4wYxM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


De volta à série Começando aos 40, estamos já no oitavo episódio! E ela é a Parte 3 do tema de Back-end, mas desta vez vou precisar me alongar mais explicando conceitos antes de retornar às ferramentas.

Concorrência e Paralelismo é algo que todo iniciante hoje em dia já esbarra logo cedo. Nós vivemos num mundo que é naturalmente paralelo e concorrente. Já estamos no ponto onde nos definimos como "multi-tarefas".

Mesmo assim, ainda existe mais superstição e "misticismo" do que real noção do que esse conceito realmente significa. E ao contrário do que possa parecer, na realidade o básico não é tão complicado assim.

Preste bastante atenção na explicação de hoje, porque isso vai ser base pra todo o resto que vou explicar até o fim desta série.

Se você já conhece os detalhes do que estou explicando, obviamente pra caber num vídeo para iniciantes, estou simplificando BASTANTE muitos conceitos pra ilustrar. Infelizmente não cabe tudo num episódio só, mas não deixem de comentar se achar que faltou alguma coisa muito importante!


Links:

* The Linux Scheduler: a Decade of Wasted Cores (https://blog.acolyer.org/2016/04/26/the-linux-scheduler-a-decade-of-wasted-cores/)
* The C10K problem (http://www.kegel.com/c10k.html)

=== Script


Olá pessoal, Fabio Akita

Vamos voltar à Parte 3 do tema de Back-end. Recapitulando já expliquei os conceitos básicos do computador e do sistema operacional, sobre processos e threads. Expliquei sobre compilação e bibliotecas estáticas e dinâmicas. Já expliquei sobre máquinas virtuais e interpretadores. Demos uma rápida passada em características de algumas linguagens, a história do Java, um pouco do lado .NET, até dei uma tangente na história inicial de desenvolvimento mobile e mais um pouco sobre licenças de software.

Estamos já no oitavo episódio da série Começando aos 40. E hoje acho que é hora de começar a tratar de um tema que é muito discutido mas eu acho que os iniciantes tem dificuldade pra visualizar na cabeça. Concorrência e Paralelismo. Mas antes entrarmos nos assuntos mais óbvios como Go ou Elixir ou Node.js precisamos voltar na história como sempre pra que todos finalmente comecem a entender esse assunto de verdade!

Infelizmente explicar concorrência e paralelismo só falando é muito difícil. Vocês ainda vão precisar praticar programando centenas de vezes coisas diferentes pra começar a entender de verdade como as coisas funcionam. Eu espero que a explicação que eu dê agora pelo menos ajude um pouco vocês terem uma imagem na cabeça do que esperar quando realmente colocarem as mãos no metal. Vamos lá!


(...)


Hoje em dia todo mundo tem um computador potente. Mesmo o mais fraco Intel i3 é dual core com 3 Ghz ou mais. E se você tiver a bufunfa pra comprar os novos Intel i9 ou AMD Threadripper com 8 cores e mais de 4 Ghz, você tem mais poder de computação do que os mais poderosos computadores dos anos 60, combinados. E se falarmos de processadores de servidor, como os Intel Xeon E7 temos até 24 cores. E vocês sabem que a Intel tem a tal tecnologia hyperthreading que faz você enxergar 2 threads simultâneas num mesmo core, então esse Xeon E7 de 24 cores pode ter até 48 threads de execução. Isso é bastante paralelismo. Até mesmo seu celular Android, com o chipset Qualcomm 845, é nada menos que octa-core com 2.8 Ghz cada.



E isso porque não estamos falando de GPUs que tem propósitos diferentes de um CPU, mas possuem cores que processam em paralelo também, no caso da NVIDIA o que chamamos de CUDA cores. E na nova RTX 2080 temos nada mais, nada menos, que 2.944 CUDA cores. Sendo que em placas mães melhores podemos colocar 2 placas dessas rodando em paralelo e poder ter acesso a quase 6 mil CUDA cores ao mesmo tempo. Isso sim é processamento paralelo massivo.


Então, do seu celular, a desktop, servidores, estamos claramente num mundo massivamente paralelo. Mas não foi sempre assim. Considere que acesso a esse mundo paralelo só começou de verdade pra nós programadores a coisa de pouco mais de uma década. Pra entender como tudo mudou, vou resumir como foi do fim dos anos 50 até agora.


Nos anos 50 talvez vocês já tenham ouvido falar do meme que a IBM dizia que o mundo não precisa de mais do que cinco computadores. Eles estavam falando do IBM 701. E se você não sabia disso, essa frase foi tirada de contexto e é fake news, pra variar. A frase em contexto foi numa reunião de acionistas que dizia que a IBM tinha planos de vender talvez cinco IBM 701 mas voltaram com pedidos pra 19. Estamos falando de uma máquina que, se fosse alugar na época, não custaria menos que 15 mil dólares, em dólares dos anos 50. E a potência? Era uma máquina de 18-bits. Lembrando que seu celular hoje é 64-bits. E essa máquina vinha com nada menos que 1 quilobyte de memória e podia suportar um máximo de 9 quilobytes. E ainda foi a primeira que vinha com … gravador de fita, que podia gravar nada menos que 1.2 megabytes a uma velocidade estrondosa de 5.6 kilobytes por segundo. Lembrando que sua placa de rede ethernet porcaria trafega dados a pelo menos 1 gigabits por segundo, e isso é considerado lento hoje em dia dado que existem placas de 10 gigabits.



Então você imagina que numa máquina cara dessas, basicamente uma calculadora glorificada, você gostaria de usá-la da forma mais eficiente possível. Era uma época onde a linguagem mais avançada era Fortran pra fazer cálculos. E onde você carregava programas com cartões perfurados, numa máquina que conseguia ler no máximo 150 cartões por minuto e perfurar no máximo 100 cartões por minuto. Então a forma mais eficiente de usar essa máquina era os programadores serem extremamente cuidadosos pra escrever programas de cálculo muito precisos e sem erros, que chamamos de jobs, e organizar esses jobs em batches ou grupos de programas similares, e deixar numa fila pra ir processando dia e noite. Foi a época dos jobs em batch. Se tivesse um erro no seu programa, você só ia saber no dia seguinte e ter que repetir todo o processo.


Então dos anos 50 pros anos 60, alguns grandes nomes que já falei antes como John Backus, criador do Fortran, ou John McCarthy que é considerado o pai da inteligência artificial e o criador do garbage collector do Lisp, começaram a trabalhar um conceito para aumentar a eficiência dos programadores. Em vez de terem que colocar seus jobs numa fila e ficar só esperando de braços cruzados, e se fosse possível usar as ineficiências do computador, como o tempo que ele fica lendo ou escrevendo nas fitas e outras pausas, pra permitir que múltiplos programadores pudessem trabalhar concorrentemente no mesmo computador? 


O conceito básico era que fosse possível salvar o contexto do ambiente de um programador e trocar pelo contexto de outro programador. Entenda contexto como o que define o ambiente de trabalho do programador, o que está na memória basicamente. Se você trocar muito rápido entre um contexto e outro, ou seja fazer switch, para os programadores “parece” que ele está sozinho na máquina, mas na verdade a máquina está gerenciando entre múltiplos contextos. A máquina oferece um pedaço de tempo, ou time-slice, para cada ambiente e vai dando a vez pra outro ambiente, sucessivamente. Esse é o conceito de time-sharing baseado em context switching.


Esse conceito nasceu na época dos IBM 704 e IBM 709 e foi incorporado aos mainframes dos anos 60. O conceito de time-sharing existiu mais no mundo corporativo, em mainframes e mini-computadores dos anos 60 até 70. Nos anos 80 principalmente começou a aparecer nos UNIX usados em workstations. E só nos anos 90 começou a de fato a aparecer no mundo dos desktops. Se você usou micro-computadores nos anos 70 e 80, lidou com micros muito simples, com CPUs como o Z80 ou Motorola 68000 ou mesmo Intel 8088. Todos CPUs de um único core, que só sabiam executar uma instrução de cada vez a cada giro do clock.


Se você já teve um Sinclair, MSX, Commodore 64, Apple II ou outras máquinas 8 bits ou 16 bits da década de 80, você se viu na mesma situação dos computadores dos anos 50: só conseguir executar uma tarefa ou um job de cada vez. Num MS-DOS você podia executar um programa, mas pra executar outro precisava sair do primeiro e só depois carregar o segundo. Ou usar um truque de interrupção, a famosa INT 21H que era o recurso de Terminate and Stay Resident ou TSR. De uma forma rudimentar você podia carregar um segundo programa, chamar essa interrupção pra devolver controle pro DOS mas deixar residente em memória de forma que podia ser chamado de volta. Era como utilitários pequenos com o Borland Sidekick funcionavam na época. E isso meio que simulava um tipo de multi-tarefa.


Foi só com o Windows 3.1 que a maioria das pessoas realmente experimentou mais esse conceito de multi-tarefa, mas no caso era multi-tarefa cooperativa. Quando falamos em multi-tarefa num computador com CPU de um único core, pensa numa mesa de escritório sendo dividida entre mais de uma pessoa. A primeira pessoa chega, coloca as coisas dela na mesa e começa a trabalhar. Pra outra pessoa usar, a primeira precisa tirar todas as coisas dela da mesa e deixar a outra colocar as coisas dela. As coisas da primeira pessoa é o tal contexto e a troca é o switching. É o mesmo conceito de time-sharing que falei antes. Mas se a segunda pessoa se recusar a sair da mesa, ninguém mais consegue usar a mesa, então ela precisa cooperar pra todo mundo poder usar. Esse é o conceito de multi-tarefa cooperativa, que é o que tinha no Windows 3.1. Se um programa fizesse alguma coisa que bloqueasse o sistema como imprimir, todos os outros programas ficavam impedidos de ter sua vez pra rodar.


Isso veio a mudar em sistemas operacionais 32-bits como OS/2 ou Windows 95, Windows NT e também nas distribuições Linux que começaram a aparecer do começo pro meio da década de 90. Nesse caso temos o que já expliquei antes: cada processo era iniciado pelo sistema operacional num espaço de memória protegido, ou seja, onde um programa não consegue escrever em cima da memória do outro. Além disso agora não é o programa que tem que cooperar pros outros poderem rodar. Na metáfora da mesa, imagine que agora tenha um supervisor, que tira a pessoa da mesa pra deixar a outra usar mesmo se a pessoa não quiser sair naquele momento. Esse supervisor é que chamamos de scheduler do sistema operacional. Ele aloca um pedaço de tempo, ou time-slice pra cada programa e interrompe pra deixar outro rodar. A forma de fazer isso é pegar o que está na tal mesa, separar do lado e colocar as coisas da outra pessoa na mesa. E quando der o tempo, ele tira as coisas da mesa e devolve o que tava antes e vai fazendo esse switching de contexto. Isso é multi-tarefa preemptiva.


Isso é feito no nível do processo, que na metáfora é o que está executando na tal mesa naquele determinado momento. Mas digamos que quiséssemos ter tarefas em paralelo na mesma mesa ao mesmo tempo. Por definição, cada processo tem uma única thread de execução, pense numa thread como sendo uma tarefa sendo executada na mesa. Mas podemos ter multi-thread que seria o equivalente a ter 2 pessoas usando a mesma mesa e os mesmos materiais na mesa ao mesmo tempo. Pra isso acontecer o tal supervisor faz a mesma coisa: ele força uma das pessoas a parar de usar o material da mesa pra deixar a outra pessoa sentada do lado usar o mesmo material.


Multi-thread é mais ou menos isso: duas pessoas começando com o mesmo material ao mesmo tempo. Cada pessoa pode até usar seu próprio material, mas ela tem acesso ao material todo que está na mesa, que na metáfora é o espaço de memória do processo. Um processo pode ter uma ou mais threads. Num processador com um único core, não é possível que as duas pessoas trabalhem exatamente ao mesmo tempo, porque só tem um único espaço na mesa, então a única forma de haver concorrência é o tal supervisor ficar fazendo uma das pessoas pausar o trabalho pra dar um tempo pra outra pessoa continuar o trabalho dela.


Quando falei de um processador moderno como o Intel i3, ela tem 2 cores. Pense em 2 cores como duas mesas. Nesse caso cada thread ou cada pessoa realmente pode trabalhar verdadeiramente em paralelo. Mas nos anos 90 o comum era um processador 486 ou Pentium de um único core. Só servidores tinham processadores com dois ou mais cores. Então você tinha multi-tarefa preemptiva que fica pausando threads pra outra poder rodar, e agora você tem multi-processamento paralelo onde cada thread roda separadamente em um processador separado.


Quando são dois processos independentes, eles podem rodar 100% em paralelo. Se não estiverem usando nada que é compartilhado pelos dois como um arquivo ou outro recurso de hardware como impressora ou rede. Se um deles estiver usando a impressora, obviamente o segundo processo é obrigado a esperar ou fazer outra coisa enquanto espera. Mesma coisa se forem 2 threads dentro do mesmo processo. Seria o equivalente às duas pessoas uma em cada mesa mas onde ambos dependem do mesmo material pra trabalhar. E é nessa situação que multi-threading começa a ficar complicado.


Se ambas as pessoas quiserem escrever no mesmo pedaço compartilhado de papel ao mesmo tempo, imagine a zona que ia ser. Cada linha ou cada palavra de uma pessoa ia ficar misturado com o que a outra pessoa tá querendo escrever por cima. Ou seja, seja lá o que eles gostariam de escrever no papel ia virar um monte de dados misturados. Na realidade você talvez gostaria que a primeira pessoa usasse o papel, e só quando terminasse a segunda pessoa usasse na sequência. Mas como eles estão disputando ao mesmo tempo, pode ser que o inverso aconteça, e como não sabemos quem vai ganhar a disputa de quem começa a usar o papel na frente do outro literalmente temos uma condição de corrida, ou o que se chama de race condition, que pode levar a resultados inesperados ou não-determinísticos. 


Então como fazer nesses casos? Pra isso precisamos de um sinalizador. Quando a primeira pessoa quiser escrever, ele coloca uma placa dizendo “ocupado”. Quando a segunda pessoa for escrever também ele vê a placa e espera. Quando a primeira pessoa termina o que queria, ele tira a placa de “ocupado”. Agora a segunda pessoa pode colocar a placa dela e escrever sua parte, e depois tirar a placa. Se ela vai embora e esquece de tirar a placa, aquele pedaço de papel fica bloqueado e ninguém mais consegue escrever nele. Agora pense que a primeira pessoa bloqueia o pedaço de papel, então a segunda pessoa resolve bloquear outro pedaço de papel que a primeira vai precisar na sequência. Mas ambos esquecem de tirar as placas de ocupado de seus respectivos papéis e cada um quer usar o papel do outro. Temos um impasse, onde nenhum sinaliza pro outro que já terminou e ambos param de trabalhar esperando. Eles estão literalmente mortos por causa do bloqueio, ou seja, o que chamamos de dead-lock.


Essa placa de “ocupado” é o que em programação multi-thread chamamos de lock ou mutex, que significa mutuamente exclusivo. É um sinalizador de exclusividade. E como no exemplo, quem bloqueia o recurso também tem a responsabilidade de desbloquear quando acabar. E com isso você consegue ver como duas threads, mesmo se tiver dois cores na CPU onde eles teoricamente poderiam trabalhar independentes em paralelo, se tiver um recurso compartilhado como o tal pedaço de papel, um é obrigado a esperar o outro terminar. 


Eu tentei usar metáforas aqui mas você só vai entender realmente o que tudo isso significa o dia que realmente começar a programar usando esses recursos. Entenda alguns fatos primeiro: toda CPU moderna é feita pra rodar threads, é como se fosse a menor unidade de execução. Cada thread executa uma sequência de instruções e tem um contexto, que é seu material de trabalho, que fica nos registradores da CPU. Quando o CPU faz o tal context switching, ele guarda o que está nos registradores naquele momento e deixa outra thread executar. Fazer essa troca de contexto não sai de graça, porque tem o trabalho de tirar o material da mesa e colocar o material do outro na mesa. Então quanto mais threads você tenta executar num core, mais devagar o trabalho geral vai ficar. Então não adianta ficar criando threads como um idiota achando que tudo vai rodar em paralelo e ficar mais rápido, lógico que não. O ideal é ter o mesmo número de threads que número de cores no seu CPU. Por outro lado não é porque você tem 2 cores e inicia 2 threads que ambos vão rodar da forma mais eficiente, porque eles podem estar compartilhando o mesmo recurso e esperando liberar o mutex que o outro colocou. Nesse caso uma terceira thread poderia se aproveitar desse período de espera e executar enquanto isso, caso não precise usar o mesmo recurso. Então você vê como também ter exatamente o mesmo número de threads que cores não é um regra. Em muitos casos determinar qual o número ideal de threads que você pode subir naquela determinada máquina é uma questão de tentativa e erro.



Criar processos é um procedimento que custa pro sistema operacional, não é de graça. Ele precisa carregar o binário do programa, alocar memória do sistema, checar permissões de segurança, etc. Esse procedimento inclusive é diferente entre sistemas operacionais. Em particular, sistemas Linux são mais rápidos pra criar processos do que um MacOS e uma ordem de grandeza mais rápido do que um Windows. Já falei em outro episódio que no Linux muitos programas como o Apache tomam vantagem de fazer o tal FORK que cria uma cópia rápida do processo atual pra gerar outro processo que vai rodar concorrentemente. E fazer forks em Linux é uma operação comparativamente mais barata do que no Windows. Ou seja, só porque ambos fazem a mesma coisa não quer dizer que fazem do mesmo jeito. Qualquer sistema que dependa de forks vai rodar ordens de grandeza pior num Windows.


Por isso mesmo desenvolvimento em Windows privilegia e recomenda criar um único processo por aplicação mas usar mais threads dentro do mesmo processo. Como uma thread compartilha a memória interna do processo com outras threads, a ação de criar threads é ordens de grandeza mais barato do que criar novos processos. Por outro lado isso também é uma troca. Processos são isolados de outros processos e um não vai pisar no calo do outro. Você não tem race conditions, você não precisa manualmente gerenciar mutexes e nem se preocupar com dead-locks, mas processos em Windows são mais caros pra criar. Por outro lado threads são bem mais baratas, só que agora temos o trabalho de nos preocuparmos em ter que manualmente codificar mutexes e tudo mais.


Programação é sempre o ato de se comprometer, você aceita uma vantagem em troca de uma desvantagem. Tudo sempre depende e nunca tem uma resposta certa pra tudo. Alguém poderia dizer que porque threads são mais rápidas de criar e usam menos recursos, eles são obviamente melhores do que fazer forks de processos. Por outro lado alguém pode argumentar que como temos que gerenciar mutexes e coisas assim manualmente, você tem muito mais bugs e situações não-determinísticas com threads e, portanto, processos são infinitamente mais fáceis de programar com menos bugs. Ambos estão certos.


Na prática você vai encontrar mais soluções baseadas em fork de processos em sistemas Linux ou UNIX como no MacOS e mais soluções multi-thread no Windows. Mas isso não é uma regra e em alguns casos, a melhor opção não necessariamente é a mais óbvia. Por exemplo, um navegador web como Firefox ou Chrome. Acho que se você é desenvolvedor já sabe que eles usam recursos de multi-processos. Antigamente um navegador só abrir uma única página de cada vez. Mas aí inventaram a idéia de abas e abrir múltiplos sites diferentes em múltiplas abas. Como um navegador é razoavelmente pesado e consome muita memória pra guardar tantas imagens e javascript que cada página carrega, você quer tentar usar a menor quantidade de memória quanto possível. Então o primeiro instinto de um programador é fazer cada aba ser uma thread.


De fato você vai usar menos recursos, mas à medida que os navegadores vão ficando mais e mais complexos, a quantidade de bugs por causa de threads aumentam exponencialmente. Agora um bug numa thread pode desestabilizar o navegador inteiro porque dentro do processo do navegador, uma thread tem acesso a tudo que as outras threads tem acesso. Então era muito comum você abrir um site qualquer e de repente seu navegador inteiro com 20 abas dava pau e você perdia tudo.


Pra piorar, alguns desses bugs eram bugs de segurança. Imagine uma aba que abre um site conseguir vasculhar a memória da outra aba que está com um e-commerce aberto e com seus dados de cartão de crédito na memória global. Cada vez que você tenta consertar um bug, pode acabar acidentalmente largando um bug novo no lugar. Então é como tentar tampar o sol com a peneira. Some a isso a possibilidade de instalar plugins que ganham acesso à memória do navegador como os plugins de Java ou os antigos de Flash e você tem um desastre esperando pra acontecer.


Por isso muitos navegadores começaram a separar certas partes em processos independentes como o Safari que iniciou separando coisas como Flash e Java em processos mas ainda manteve muita coisa em threads pra usar menos memória. Mas no caso do Google Chrome ele resolveu separar completamente cada aba em seu próprio processo. Por um lado isso trouxe muito mais estabilidade. E você já deve ter visto muitas vezes uma aba inteira crashear, mas o navegador continuar rodando sem nenhum problema. E você pode ver cada processo separado num Task Manager do Windows por exemplo, e inclusive pode matar um processo por lá mesmo, na mão. É a grande vantagem de se separar tudo em processos como eu já falei antes. Por outro lado todo mundo sabe como o Chrome hoje é um dos aplicativos que mais come RAM do seu sistema e essa separação é uma das razões já que código comum entre as diversas abas precisa ser copiada em outro processo a cada nova aba.


Conceitualmente falando, um fork de um processo é como se você pausasse esse processo e fizesse uma cópia de tudo que ele tem na memória pra outro espaço isolado e resumisse os dois, e a partir daí cada um tem vida independente. Se um processo está consumindo 1 MB de RAM, com um fork você deveria estar agora usando 2 MB. Mas no Linux temos um recurso chamado copy-on-write ou CoW, onde o segundo processo não usa praticamente nenhuma memória adicional e fica apontando pra memória do processo original assim que é criado. Se a memória não for modificada, ambos podem reaproveitar o mesmo dado em vez de fazer cópias desnecessárias e só coisas que o segundo processo começa a gravar começa a usar mais memória e fica invisível ao processo original e vice-versa. No Windows o equivalente ao fork realmente duplica a memória, que é outro motivo de porque criar processos no Windows é considerado mais caro.


Um fork com copy-on-write no Linux cada processo tem acesso a uma cópia da memória do processo pai, mas diferente de threads dentro do processo que compartilha tudo, não existe a necessidade de mutexes ou outro tipo de controle de acesso porque a partir do ponto do fork, cada processo tem sua cópia da memória pai e um não escreve em cima da memória do outro. Isso faz as coisas serem muito mais simples de programar. Claro, threads ainda são mais leves e usam muito menos memória no total.


Você pensa no Linux como um sistema estático que é sempre igual, mas ele mudou radicalmente dos anos 90 pros anos 2000 e até agora. A interface que você interage com o sistema, que seria os shells de linha de comando, ou as APIs, são parecidas, muito porque ele segue o que chamamos de padrão POSIX que é sigla de Portable Operating System Interface onde o X no final denota sua herança de UNIX. Teoricamente os UNIX e seus clones como Linux deveriam seguir esse padrão pros programas serem portáveis entre eles, no nível do código fonte, porque os binários não são compatíveis. 


No mundo POSIX você tem a abstração de Posix threads ou pthreads implementado como LinuxThreads anos atrás. Threads em Linux eram bugados e nunca foram grande coisa até que finalmente alguns projetos começaram a surgir pra reimplementar o suporte de threads no Linux, como o Next Generation Posix Threads ou NGPT da IBM que eu me lembro que uma característica marcante era ser um mapeamento M pra N, ou seja uma thread em Linux não seria equivalente um pra um com uma thread de verdade. 



Mas o projeto que ganhou foi o Native Posix Thread Library ou NPTL de Ulrich Drapper que era mantenedor do glibc e Ingo Molnár que vou citar de novo a seguir. O NPTL é uma implementação um pra um em vez de ser M pra N como o NGPT, portanto era bem mais simples de ser implementado. Esse projeto corrige as falhas do LinuxThreads e só a partir desse ponto dá pra se dizer que threads em Linux ficaram decentes. E isso só é um fato a partir da kernel 2.6 mais ou menos por volta de 2007. Pra ver como as coisas são diferentes entre diferentes Unix, o Solaris usava uma estratégia M pra N até o Solaris 9. O FreeBSD e NetBSD eram M pra N também mas acho que o FreeBSD também ia ou foi pra uma pra um. Parece que um pra um começou a ganhar terreno mas vamos voltar nisso em breve, guarde esse ponto.



Eu já expliquei sobre o tal scheduler na metáfora das mesas sendo o supervisor que força uma pessoa a sair da mesa pra dar lugar pra outra. Existem diferentes estratégias que um scheduler pode tomar. Quando você só tem uma mesa, você é obrigado a deixar uma pessoa trabalhando e mandar as outras esperarem a vez, e o supervisor manda trocar de lugar com o próximo pra ir dando chance das outras trabalharem também. Mas imagine se o supervisor resolve deixar uma pessoa que ainda não está pronta sentar na mesa e ela fica sem fazer nada, enquanto as outras estão esperando. 


E se você adicionar uma segunda mesa, parece que fica mais fácil, mas na verdade fica mais difícil. Imagina se você tem três pessoas pra usar as duas mesas. Mesma coisa, você vai rotacionando uma pessoa em cada mesa. Mas imagina o trampo de uma pessoa ficar transportando seu trabalho de uma mesa pra outra se o supervisor não for muito legal e não deixar ficar na mesma mesa. Quando você tem duas mesas, não dá pra deixar seu trabalho no canto da mesa pra voltar pra ela rápido na próxima rodada necessariamente, você pode ter que ficar transportando suas coisas de um lado pro outro, e obviamente isso é mais lento.


E se você não tomar cuidado, e seu scheduler for meio burrinho, ele vai dando vez pra threads que não precisam, ou deixa threads com pouco trabalho ocupando tempo demais na sua vez, ou pior, cortando no meio o trabalho de quem realmente precisa rodar. E por isso no começo dos anos 2000 um Linux era ruim pra coisas como tocar um vídeo. O vídeo ficava engasgando, mesma coisa com áudio. Foi só em 2007 com a Kernel 2.6 que ganhamos o Completely Fair Scheduler ou CFS que implementa um algoritmo melhor, de autoria do Ingo Molnár que já mencionei antes, que se inspirou nas idéias de Con Kolivas. Em resumo esse CFS maximiza o uso da CPU e tenta dar preferência pra programas interativos, como aplicativos desktop, que diferente de processamento intensivo, tende a ficar ocioso por períodos de tempo e de repente precisar de prioridade pra coisas como tocar vídeo. 


Cada sistema operacional implementa estratégias diferentes de scheduler, MacOS, Windows, BSDs, Linux e outros priorizam coisas diferentes e usam algoritmos diferentes. O próprio Windows demorou anos pra chegar no nível de granularidade do MacOS que sempre foi considerado melhor principalmente em criação multimídia porque ele não engasgava no gerenciamento de threads. Por isso músicos e DJs sempre preferiram Macs, especialmente em apresentações ao vivo: porque eles sabiam que o áudio não ia engasgar do nada porque o scheduler resolveu do nada dar a vez pra outra thread à toa. Isso acontecia com Windows e com Linux por isso eles eram bem inúteis em situações assim. 


De novo, entenda que threads também tem comportamentos diferentes em diferentes sistemas operacionais. Quem saiu na frente na estratégia de threads foram os Macs no começo dos anos 2000 com o OS X. Windows era o segundo melhor, mais ou menos, e foi passado pelos Linux com o CFS só depois de 2007. Ou seja, o Linux moderno que conhecemos hoje só tomou forma de verdade a partir de 2007. Em termos de engasgos você vai notar que o Windows ainda é menos polido que MacOS e também desktop Linux. E esse fator do scheduler antigo foi mais um motivo de porque no mundo Linux processos continuaram sendo importantes. 


De 2007, agora vamos voltar quase uma década, em 1999 surgiu um paper que começou a ajudar a mudar a forma como pensamos sobre concorrência no mundo de redes e web. Estamos falando do lendário paper sobre o problema dos C10K de Dan Kegel do antigo site cdrom.com discutindo quando os servidores de FTP da Simtel conseguiam servir até 10 mil conexões simultâneas sobre uma ethernet de 1 gigabit. Começamos a usar esse termo pra discutir como servir grandes quantidades de conexões simultaneamente. 10 mil parece muita coisa, mas um só servidor do Whatsapp hoje serve mais de 2 milhões de conexões simultâneas. O problema é que existem diversas estratégias pra fazer isso.


Eu já mencionei I/O mas agora vou definir um pouco melhor. I/O é qualquer entrada e saída do sistema, arquivos, rede, USB, teclado, monitor. Agora pense nos mainframes antigos que usavam dispositivos de fita, como os do IBM 701 que eu falei que gravavam dados a fantásticos 5.6 quilobytes por segundo. Se ele tivesse que ficar esperando a operação toda acabar o computador não ia fazer mais nada a não ser esperar. Por isso mainframes lendariamente tem milhares de canais paralelos de I/O. Mas o mesmo não acontece no barramento de computadores comuns como o que usamos.


Ou seja, mesmo que você consiga ter paralelismo disponível na sua CPU e sistema operacional, se você só tem um HD, não tem como milhares de threads escreverem ao mesmo tempo. O barramento de I/O vira gargalo. É como se você dividir o trabalho de escrever um livro entre 500 pessoas, onde cada uma escreve uma página. Então você vai acabar o livro no tempo que leva pra escrever uma única página. Porém, se todo mundo tiver que escrever no mesmo livro, não adiantou nada, só dá pra escrever uma página de cada vez. 


Lembra quando falei de locks em memória global do processo compartilhado entre múltiplas threads? Algo semelhante acontece quando threads tentam acessar recursos restritos do sistema. É o que chamamos de operações que bloqueiam ou bloqueantes. Então se uma thread resolve escrever alguns gigabytes num arquivo, essa thread fica bloqueada até terminar, nesse caso outra thread pode executar outra coisa que não depende do HD enquanto a primeira fica bloqueada. 


Conexões de rede também são bloqueantes, imagine uma thread fazendo download de alguma coisa ou algum cliente de rede pendurado numa thread. Essas operações são bloqueantes e a sequência de instruções da thread vai esperar até a operação terminar e desbloquear o processamento. Com o tempo os sistemas operacionais passaram a implementar algo chamado I/O assíncrono. Ou seja, em vez de bloquear o processamento, a thread pode pedir pra escrever alguma coisa num arquivo, mas o sistema operacional não vai bloquear a thread. Em vez disso a thread pede pra escrever e indica na função do sistema pra quando ele terminar, enviar um evento de término. Daí a thread pode configurar pra quando receber esse evento daí executar alguma outra sequência de instruções. 


Ou seja, a programação fica dependente do evento de término da operação de I/O, seja operação de leitura ou de escrita, e é isso que muitos chamam de orientação a eventos. Isso não é nada novo, qualquer linguagem de programação dos anos 90 usada pra fazer aplicativos gráficos sempre usou programação orientada a eventos. Por exemplo, o código que é executado quando você tem o evento de clicar num botão, ou o evento de arrastar uma janela. Num Linux podemos enviar sinais a um processo, que é uma forma rudimentar de comunicação inter processos, como os sinais de kill como SIGTERM ou SIGINT. Aqui estamos estendendo para eventos de I/O do sistema operacional.


Mesmo sem I/O assíncrono podemos atender múltiplas conexões como no problema do C10K fazendo cada conexão ao servidor ser servida por forks do processo servidor. É como a primeira versão de um Apache resolvia isso. Cada nova requisição era gatilho pra um fork do processo principal que gerava um processo filho. Já expliquei que isso é pesado, especialmente em Windows. 


A segunda alternativa é cada nova conexão recebida no processo servidor ser servida por uma nova thread dentro desse processo. Também já expliquei como threads são bem mais leves que um processo, mas temos o problema de gerenciar o compartilhamento da memória interna do processo entre múltiplas threads e os bugs que isso pode causar como race conditions e dead locks. Além disso quando estamos falando de 10 mil conexões ou mais, seria necessário mais de 10 mil threads, e eu já expliquei como context switching entre threads não é algo tão simples assim nem barato, você precisa de um scheduler muito bom e mesmo assim cada thread também consome recursos do sistema operacional. Versões subsequentes do Apache e outros servidores web como o IIS no Windows se valeram de threads pra servir milhares de conexões, mas não era o bastante.


A terceira opção como já imaginaram é usar esse tal recurso de I/O assíncrono, que permite que uma única thread ordene múltiplas operações de I/O ao sistema operacional sem que ele fique bloqueado. E o sistema operacional se vira pra realizar essas operações e vai notificando à thread a medida que cada operação vai terminando.


Cada sistema operacional implementa esse sistema de filas de eventos para I/O de formas diferentes. Sistemas derivados de BSD como o FreeBSD ou mesmo o MacOS tem uma syscall chamada kqueue. O Windows usa uma coisa chamada I/O Completion Port ou IOCP. E os Linux tinham syscalls chamada select, depois poll e finalmente a mais usada agora que é a epoll. Assim como gerenciamento de threads e schedulers, cada uma dessas implementações se comportam de formas diferentes. Estão vendo como os sistemas operacionais são mais diferentes do que só uma interface gráfica diferente?


Como resultado de toda a discussão no fim dos anos 90 e começo dos 2000 em cima do paper do C10K de Dan Kegel surgiu um projeto que nasceu com o objetivo de superar o Apache em conseguir servir dezenas de milhares de conexões simultâneas usando o mínimo possível de recursos do sistema, ou seja, sem usar a estratégia de uma conexão por processo ou thread e sim usando uma combinação de processos e chamadas de I/O assíncrono. É assim que nasce o projeto do servidor web mais rápido e escalável que temos até hoje, o NGINX de Igor Sysoev que começou a ser desenvolvido a partir de 2002 com lançamento da versão estável em 2004. 


O NGINX tem um processo master que carrega outros processos que ele chama de “workers” e você vai ver que a palavra “worker” é um termo muito usado em arquiteturas com concorrência. Cada worker consegue gerenciar milhares de sockets de conexões de navegadores requisitando páginas web, por exemplo. Em vez de gerar um fork ou uma thread por conexão, ele registra a requisição via epoll num Linux e implementa um loop de eventos. Pense que o programa do worker é um loop que fica fazendo syscalls não bloqueantes de I/O e cada vez que o loop repete ele checa se veio o evento de término e aí executa o que precisa e devolve a página de volta pro requisitante. É uma forma de numa única thread conseguir servir milhares ou dezenas de milhares de conexões simultaneamente.


Não sei se fica claro e isso é importante. Se fosse como era antigamente, e eu fizesse um loop com chamadas de I/O, digamos que ler o arquivo HTML do HD levasse 1 segundo e enviar o HTML pela rede pro navegador levasse 1 segundo - é bem menos que isso na realidade, claro. E agora digamos que esse processo recebesse 10 requisições da mesma página. Levaria pelo menos 20 segundos pra servir todo mundo. Com I/O assíncrono poderia levar pouco mais do que os 2 segundos pra servir as 10 páginas. 


Numa metáfora, do jeito antigo é como se no restaurante todo cliente pedisse direto pro chef o prato que quer, ele só consegue atender e fazer um prato de cada vez e cada cliente na fila precisaria esperar o prato do cliente anterior ficar pronto pra pedir o seu. Ou seja, o último cliente da fila precisa esperar todos os clientes anteriores ter o prato pronto antes de poder pedir o seu. Agora adicione um garçom, todos os clientes fazem o pedido pro garçom um atrás do outro e podem se sentar. Agora o último cliente da fila é atendido bem mais rápido. E o garçom vai passando os pedidos pro chef, que daí vai devolvendo os pratos à medida que forem ficando prontos, é como o evento de término que eu falei antes, mas os clientes já todos foram atendidos, fizeram os pedidos e podem ficar sentados fazendo outra coisa. É mais ou menos a diferença entre só ter I/O bloqueantes e ter I/O não-bloqueante. Não fica todo mundo bloqueado esperando em sequência.


Voltando ao NGINX, como cada worker é uma única thread, o master sobe na média um worker por core disponível na CPU então numa CPU quad-core subiríamos 4 workers. Cada worker com um loop de eventos que fica esperando os eventos de término de cada requisição de I/O que ele recebe, com capacidade de servir dezenas de milhares de conexões simultaneamente. E como ele não precisa criar uma thread por conexão, ele não perde tempo nem recurso fazendo context switching. Então um NGINX num bom servidor consegue servir até milhões de conexões simultaneamente, especialmente se for servir coisas simples como ler uma página HTML estática e só devolver sem processar lógica nenhuma. Se você vem de Javascript talvez já tenha ouvido falar desse pattern de arquitetura, isso se chama um Reactor, porque dentro do loop ele reage aos eventos de I/O que vão terminando.


Na mesma época, por volta de 2002 outro framework também implementou o mesmo pattern de Reactor com um event loop e usando I/O assíncrono, Node.js? Nope, ainda não. Esse foi o framework Twisted implementado em Python em 2002. Assim além de servir páginas HTML muito rápido, a cada loop do Reactor você podia executar processamento escrito em Python. Twisted introduziu ainda outro conceito: os Deferreds ou Futures. Mas vou explicar isso no próximo episódio.


Nesta primeira parte eu queria deixar bem explícito conceitos que acho que a maioria dos programadores tem problemas em entender logo no começo: concorrência e paralelismo e como os sistemas foram evoluindo pra resolver esse problema. Aliás, eu não expliquei isso antes mas vamos definir agora: concorrência e paralelismo. Simplificando, lembram dos computadores até os anos 90? Você podia ter tarefas que pausam e deixam outras executarem no seu lugar e ficam trocando de lugar, fazendo o tal context switching. Elas são concorrentes mas não são paralelas. Quando você tem dois ou mais cores na CPU aí sim, você realmente tem paralelismo, porque duas tarefas concorrentes, por exemplo threads, podem ser executadas verdadeiramente em paralelo. Seja em uma CPU com capacidade pra somente uma thread ou uma CPU com capacidade pra múltiplas threads, ainda assim você precisa de um scheduler, porque seu programa pode modelar e gerenciar mais threads concorrentes do que existem cores físicas pra executá-las. 


É importante também que todos entendam como os sistemas operacionais são muito diferentes especialmente nesses aspectos de concorrência, como implementam threads de maneiras diferentes, como existem diferentes schedulers e no Linux você pode inclusive escolher schedulers diferentes pra casos diferentes. E como I/O assíncrono é outro recurso implementado de formas diferentes. Sabendo desses conceitos no próximo episódio vamos falar de coisas mais abstratas como corotinas, fibers e o conceito de deferreds ou futures. 


Esse assunto é bem cabeludo, concorrência e paralelismo não tem uma resposta única que resolve todos os problemas. Cada tipo de problema vai precisar de uma solução diferente. Forks de processos funcionam. Multi-threads funcionam. I/O assíncrono é só mais uma opção nessa caixa de ferramentas e ainda vamos explorar outras opções. Além disso no mundo Linux o suporte a threads só ficou realmente bom a partir de 2007. Por isso você vê tanta coisa interessante no mundo de concorrência dando as caras principalmente na década de 2010. Muitos acham que event loops, o pattern de Reactor nasce com Node.js a partir de 2009, mas não, NGINX e Twisted pelo menos, já implementavam isso em 2002, derivados diretamente do objetivo de resolver o problema C10K de Dan Kegel de 1999 e esses conceitos mesmo já vinham pesquisas de anos antes. 


Se tiverem dúvidas não deixem de mandar nos comentários abaixo, se curtiram o vídeo mandem um joinha, compartilhem com seus amigos, assinem o canal e não deixem de clicar no sininho pra não perderem os próximos episódios. A gente se vê semana que vem, até mais.

Links:

* The Linux Scheduler: a Decade of Wasted Cores (https://blog.acolyer.org/2016/04/26/the-linux-scheduler-a-decade-of-wasted-cores/)
* The C10K problem (http://www.kegel.com/c10k.html) 
