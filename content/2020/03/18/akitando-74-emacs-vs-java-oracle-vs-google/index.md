---
title: "[Akitando] #74 - Emacs vs Java | Oracle vs Google"
date: '2020-03-18T10:30:00-03:00'
slug: akitando-74-emacs-vs-java-oracle-vs-google
tags:
- emacs
- richard stallman
- java
- james gosling
- gpl
- oracle
- google
- android
- openjdk
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/2q4WN-sIN6s" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## DESCRIPTION

Esta é uma história de coincidências e erros que moldaram o mundo de programação como você conhece hoje e que possivelmente mudem completamente esse mesmo mundo.


Richard Stallman e James Gosling são dois gigantes da computação e as ações que eles tomaram colocaram em movimento uma série de eventos que culmina com o processo da Oracle contra o Google. Quem está certo? 


Links:


* Richard Stallman - ILC 2002 (https://www.youtube.com/watch?v=4Jjhmc3Txv0)
* My Lisp Experiences and the Development of GNU Emacs (https://www.gnu.org/gnu/rms-lisp.en.html)
* Free Software: Freedom and Cooperation (https://www.gnu.org/philosophy/rms-nyu-2001-transcript.txt)
* James Gosling on Richard Stallman (https://news.ycombinator.com/item?id=21251109)
* James Gosling on how Richard Stallman stole his Emacs source code and edited the copyright notices (https://www.reddit.com/r/programming/comments/dhrcxw/james_gosling_on_how_richard_stallman_stole_his/)
* Open Source History: Why Didn’t BSD Beat Out GNU and Linux? (https://www.channelfutures.com/open-source/open-source-history-why-didnt-bsd-beat-out-gnu-and-linux)
* Sun is using the GPL as a weapon...but against whom and for what purpose? (https://dzone.com/articles/sun-using-gpl-a-weaponbut-agai)
* Emacs violates GPL since 2009 (https://news.ycombinator.com/item?id=2820986)
* CAN JAVA STILL BE FREE AFTER JANUARY 2019? (https://www.snowsoftware.com/int/blog/2019/03/07/can-java-still-be-free-after-january-2019)
* Free but Shackled - The Java Trap (https://www.gnu.org/philosophy/java-trap.en.html)
* The Oracle-Google Case Will Decide the Future of Software (https://www.wired.com/2016/05/oracle-google-case-will-decide-future-software/)

## SCRIPT

Olá pessoal, Fabio Akita


No último video eu tentei quebrar algumas ingenuidades que as pessoas costumam ter sobre software livre. Tem uma história em particular que eu queria contar mas que não cabia no vídeo então resolvi fazer um separado. E tem a ver com dois assuntos que nem todo mundo associa. Sobre a origem do GPL e sobre um dos motivos de porque Java demorou tanto pra ser aberto como GPL e algumas ramificações disso.





A idéia deste episódio é também ensinar sobre outro ponto importante: não existem empresas perfeitas e não existem pessoas perfeitas. Por alguma razão as pessoas gostam de escolher celebridades que são excelentes em uma coisa e daí os fãs esperam que tudo que essa pessoa faça seja perfeito também. E ficam chateadas quando descobrem que na realidade essa pessoas não eram perfeita, era só pessoas. Você sabe que ainda é um adolescente se quando isso acontece sua reação é falar "Nossa, eu esperava mais dessa pessoa".





Eu não me frustro com essas coisas porque eu não coloco nada nem ninguém num pedestal. Eu admiro o resultado de seus trabalhos e só. Meu mundo seria chato demais se eu ficasse perdendo tempo julgando coisas irrelevantes. Exemplo disso, a despeito do que muita gente pode imaginar, eu gosto de Java, ou melhor, eu respeito as milhões de horas homem colocada no Java. E por consequência eu respeito o trabalho de seus criadores como James Gosling ou Bill Joy. Eu gosto de Linux, sempre vou respeitar o trabalho hercúleo que o Linus Torvalds precisou executar pra conseguir isso. E eu também gosto de usar todo o ferramental GNU e tiro o chapéu pro Richard Stallman. Eu não pretendo cagar regra na cabeça de nenhum deles, porque eu não consigo me ver realizando nem metade do que esses nomes e vários outros conseguiram entregar. Por outro lado, é só até esse o limite que eles me interessam: o software.






Se o Stallman ou o Torvalds são socialistas ou capitalistas, se são democratas ou republicanos, o que eles dizem ou deixaram de dizer, nada disso muda a qualidade do software. Se realmente me interessasse cagar regra nisso, cadê eu desenvolvendo um projeto melhor que o deles? Seria muito hipócrita da minha parte achar que sou melhor que eles e ao mesmo tempo continuar usando o que eles criaram. Eu sou pragmático, não sou evangelista de software livre e nem de Microsoft e por isso vou seguir rodando Windows com Linux em cima dele. E pra demonstrar porque é perda de tempo achar que o mundo é maniqueísta e separado entre o Bem e o Mal, deixa eu contar uma história ...



(...)






Se você não conhece Richard Stallman nem sua reputação controversa, basta dizer que ele é o criador do conceito de software livre, da licença GPL e diversos softwares importantes que estão em toda distro Linux como o compilador GCC ou o editor de textos Emacs. E eu diria que é só isso que você precisa saber. Mas se você tem interesse em assuntos de software livre deveria pelo menos ler todos os textos no site gnu.org. Foi o que eu fiz quando era estudante na faculdade.





Em 2002 o Stallman fez uma palestra na International Lisp Conference. Você que é fã de programação funcional, deveria saber que dezenas de programadores já programavam em linguagens funcionais como Lisp décadas antes de você descobrir o termo que, obviamente, não nasceu agora. Nessa palestra ele começa contando seu primeiro contato com Lisp nos anos 70, quando ele tinha acabado de entrar em Harvard e escreveu seu primeiro interpretador Lisp pra um PDP-11, uma máquina pequena que tinha uns 8 kilobytes de memória. E ele escreveu esse interpretador só com umas mil instruções. Lisp é um software fascinante que se você ainda não conhece, deveria.





Anos depois ele se aventurou a escrever um Lisp de verdade quando começou a trabalhar no MIT, no laboratório de Inteligência Artificial. Parece termos que você associa como modernos né? Lisp, programação funcional, inteligência artificial. Estamos falando do meio dos anos 70. De novo, você não está descobrindo nada de novo, é tudo derivado de mais de 4 décadas atrás.






De qualquer forma ele resolveu escrever um editor de textos chamado Emacs. Mas esse não é o Emacs que conhecemos hoje, era um editor escrito em linguagem de máquina, assembler de PDP-10. Pra quem não sabe, o Emacs é um editor de textos famoso porque ele contém uma linguagem de programação embutida, o Emacs Lisp ou elisp que é um dialeto de Lisp usado pra escrever código que manipula o editor. Toda vez que você instala uma extensão num Sublime Text, Atom ou VS Code, a idéia original vem do Emacs e muitos vão argumentar que Emacs ainda é superior nisso.






Porém, essa primeira versão ainda não tinha um interpretador Lisp. A idéia na verdade veio de outro editor que eles usavam, o TECO que significa Text Editor and Corrector, que tinha uma linguagem super feia porque ele não foi originalmente pensado pra ser programável. Era um editor que acabou ganhando funcionalidades de ser extensível via script.






De qualquer maneira, várias versões diferentes começaram a ser feitas. O próprio Stallman começou a desenvolver uma versão de Emacs em cima desse Teco. Outros desenvolvedores como Dan Weinreb e Bernie Greenberg tiveram a idéia de escrever Emacs usando o MacLisp do Multics. A idéia era tentar desenvolver um editor que fosse super flexível, com suas estruturas de dados internas como o buffer de edição, acessível a um Lisp e dessa forma fazer um meta-editor, ou seja, você podia editar o próprio editor.





Na sequência, o primeiro Emacs escrito em C que rodava em Unix veio de ninguém menos que James Gosling, que muitos hoje ainda devem reconhecer como um dos criadores do Java. Foi quando o Gosling também estava na faculdade. E essa versão foi conhecida como GosMacs. A palestra do Stallman é focada mais na história de como a pequena comunidade Lisp dos anos 70 foi desmantelada por uma briga comercial entre duas empresas que se derivaram do laboratório de inteligência artificial do MIT, a Lisp Machines Inc e a Symbolics.






O final dessa briga feia motivou Stallman a criar um sistema operacional livre que ele acreditava que seria necessário pra recriar uma comunidade livre de Lisp. Porém, diferente das máquinas especializadas de Lisp, que tinham instruções em nível de máquina que tornavam Lisp robusto e rápido, máquinas mais gerais não iam conseguir rodar Lisp de forma eficiente. Então, embora a intenção original fosse fazer um sistema operacional em Lisp, ele optou em fazer o sistema GNU em C e sobre esse sistema ele poderia rodar Lisp como um programa. 





E assim, nos anos 80, começa o desenvolvimento do sistema GNU que você usa até hoje. Se você não sabia, - e isso todo mundo de software livre vai repetir na sua orelha até você cansar -, o que você roda é um sistema GNU com a kernel do Linux e por isso eles insistem que o sistema todo deveria no mínimo ser chamado de GNU/Linux.  Eu sou a favor de nomenclaturas corretas mas esse acabou virando um daqueles casos que o nome popular significa mais do que o original. Quando falamos que estamos rodando “Linux” normalmente a gente quer dizer uma distribuição inteira, que inclui a kernel do Linux, o sistema GNU e vários outros software que compõe um pacote completo "Linux". Usar Linux basicamente quer dizer um sistema que não é Windows nem Mac.






De qualquer forma, pra escrever o sistema nasce o GNU Emacs. E como o sistema GNU seria em C, ele precisava também de um editor Emacs escrito em C. Ele poderia escrever um do zero mas naquela época já existia o Gosling Emacs. Segundo os relatos do próprio Stallman, um amigo dele disse que tinha contribuído pro GosMacs e ele tinha uma permissão por e-mail do Gosling dizendo que ele podia distribuir a versão dele. Entendam, naquela época não havia ainda os conceitos modernos de software livre e licenças. Os hackers dos anos 70 simplesmente distribuiam o código por fita ou outros meios pra quem pedisse.






O Gosling, sendo um hacker daquela época, estava no mesmo espírito de colaboração e distribuia o código do GosMacs pra quem tivesse interesse em contribuir. Então quando o amigo do Stallman disse que era ok usar o GosMacs o Stallman embarcou. Só como tangente técnica, o GosMacs não era um Emacs como o feito em MacLisp por Greenberg pro Multics. Ele implementou uma linguagem de script muito mais simples chamada de mocklisp que parecia Lisp mas não tinha o conceito mais poderoso de tudo ser dados no interpretador e ser fácil manipular qualquer estrutura de dados do editor.






Pra quem não entende isso, se você for de Javascript por exemplo, seria o equivalente a você abrir o console do navegador e injetar novos códigos Javascript e conseguir inspecionar os dados em memória da página e tudo sem precisar recompilar ou recarregar a página. É o que o Emacs fazia nos anos 70 graças ao MacLisp. E hoje em dia é o que um editor como Atom ou VS Code faz também, é o mesmo conceito. De qualquer forma o mocklisp era muito mais simplório e o Stallman decidiu que não dava pra usar aquilo e ele resolveu substituir o mocklisp por um Lisp de verdade. Segundo Stallman o mocklisp não tinha um tipo de dados de estrutura, não tinha listas, não tinha arrays, não tinha symbols que são objetos com nomes.






Ao mesmo tempo que ele substituiu o mocklisp por um Lisp de verdade, ele precisou ir substituindo várias partes das estruturas internas do editor para que se tornassem objetos de Lisp e assim pudessem ser manipulados por script. Ele queria que a interface entre o Lisp e o editor fossem limpas, o que significava que objetos como buffer de edição, sub-processos, janelas, posição no buffer, tudo precisava ser objetos de Lisp, de forma que as primitivas do editor fossem chamáveis através de funções em Lisp. Esse trampo todo significou que seis meses depois ele praticamente reescreveu o GosMacs no que viria a ser o GNU Emacs.






Agora, a reviravolta aconteceu que depois disso. Aparentemente o Gosling vendeu o GosMacs pra uma empresa chamada UniPress. Pra piorar o tal amigo do Stallman que disse que tinha autorização de distribuição do Gosling perdeu o backup da mensagem. Então o Gosling Emacs se tornou Unipress Emacs que eles passaram a vender. No começo, vendo o GNU Emacs eles se interessaram em distribuir e até contratar o Stallman. Mas depois mudaram de idéia e em vez disso passaram a dizer na rede que ele não estava autorizado a distribuir o Emacs. Eles não disseram que iam processar ninguém nem nada, só que podiam pensar nisso um dia. E segundo o Stallman, isso foi suficiente pra fazer as pessoas pararem de usar o GNU Emacs com medo de serem processadas.








Como o Stallman já tinha reescrito uma boa parte do Gosling Emacs pra colocar Lisp e transformar em GNU Emacs, ele resolveu continuar o trabalho e substituir o que faltava, e assim não ter mais nenhum bit do código fonte do antigo GosMacs e não ser mais um problema contra a Unipress. Segundo ele, foi o trabalho de pouco mais de uma semana pra terminar. Mas por causa desse episódio, diz a lenda que assim nasceu a primeira licença copyleft na forma do Emacs General Public License. A primeira vez que o nome GNU General Public License apareceu foi em junho de 1988. E dali ele veio evoluindo pra ser um pouco menos restrita pra bibliotecas com o advento do LGPL junto com o GPL v2 lá por 1999. Durante esse período nasceu a kernel do Linux que se uniu ao sistema GNU e possibilitou as distros Linux que você usa até hoje.







E o GPL v3 foi o assunto do meu video de Apple e GPL que eu recomendo que vocês assistam. E assim termina a página da história do GPL do site free soft.org que eu falei. mas não seria um video no meu canal se fosse só isso. A história tem uma outra reviravolta.



(video gosling)



Em 15 de março de 2019 o canal Computer History Museum gravou uma entrevista com James Gosling. Eu vou voltar nessa entrevista em outro episódio, mas o trecho que nos interessa hoje foi quando ele foi questionado sobre o episódio do Emacs e num 180 graus de evento ele resolveu acusar o Stallman de ter roubado o GosMacs.






Segundo sua versão da história, o GosMacs como eu disse estava sendo desenvolvido no espírito de software aberto e distribuído quando ele estava na faculdade, em Carnegie Mellon, mas num belo dia ele parou pra pensar "bom, eu posso continuar sendo o Mr. GosMacs ou eu posso me focar e me formar de uma vez da faculdade". Ele procurou pessoas que quisessem continuar mantendo o GosMacs mas ninguém tinha muito tempo pra assumir o projeto. Diz ele que chegou a oferecer até pro próprio Stallman e nem ele tava muito a fim porque na época ele era total anti coisas Unix. No final ele achou dois caras que estavam a fim de manter o projeto, mas eles iam precisar ganhar algum dinheiro com isso.






Como background, o Gosling explica uma coisa que parece que era comum em muitas universidades americanas, de que se o aluno cria alguma coisa dentro da universidade, essa criação parcialmente pertence à universidade. Então você não pode comercializar e nem mesmo dar de graça o que foi produzido enquanto era aluno. Carnegie Mellon no começo era mais frouxo com isso e o aluno era dono do que criava. Na época Carnegia era uma universidade pequena mas que tinha dois departamentos que se destacavam mundialmente, uma era a de artes e a outra a de computação. Daí aconteceu que um dos alunos de artes pro seu projeto de mestrado criou uma opera rock que acabou se tornando um puta sucesso financeiro e aí parece que a universidade tentou mudar retroativamente as regras de propriedade intelectual, supostamente pra tentar pegar um pedaço desse bolo.










Pra piorar no departamento de computação aconteceu algo similar onde um desenvolvedor chamado Brian Reed criou um software que se tornou muito popular chamado Scribe, um formatador de textos. E de novo, a universidade supostamente tentou algo similar com ele. E por conta desses episódios os alunos e professores tomavam muito cuidado com assuntos de propriedade intelectual. O Gosling conta isso na entrevista pra dizer que sob os conselhos do professor Mike Shamus ele adicionou cabeçalhos de textos de copyright em todos os arquivos do código fonte do GosMacs e ele tomava o cuidado de pedir uma carta de toda pessoa que quisesse uma cópia do GosMacs, basicamente dizendo que aceitavam a licença. Apesar que algumas pessoas daquela época reportam que pediram a tal cópia mas nunca tiveram que mandar nenhuma carta. Seria o equivalente hoje de você apertar o checkbox aceitando Termos e Condições quando instala um software.







Então, quando ele resolveu não ser mais o Mr. GosMacs e os tais dois caras apareceram, o acordo era que o GosMacs precisava ser grátis pra universidade e ao mesmo tempo não ser ridiculamente caro pra todo o resto. Os dois, segundo Gosling, eram tipo empreendedores de garagem e o novo Unipress Emacs parece que ganhou alguma tração e eles conseguiram algum dinheiro pra pagar ir pagando as contas.






Agora, segundo a versão do Gosling, quando o Unipress Emacs estava de boa no seu canto, pagando as contas, o Stallman ficou doidão. Assim mesmo que ele fala na entrevista “freak out” e saiu editando todos os cabeçalhos de copyright do código fonte do antigo GosMacs e liberou como GNU Emacs. Na cabeça do Gosling foi só isso que o Stallman fez com o código. E aí a IBM e a Digital Equipment, a DEC, pegaram essa versão e começaram a distribuir de graça, o que basicamente matou o mercado da Unipress. Daí eles resolveram processar a IBM e a DEC e isso virou um puta caso cabeludo. No final parece que eles ganharam e a IBM e DEC pagaram danos pra Unipress. Só que o GNU Emacs não desapareceu e depois disso a Unipress teve que mudar de modelo de negócio e fazer outra coisa. 



(.. final da entrevista)





Como eu não estava lá presente no começo dos anos 80, minha opinião de hoje é que Stallman, Gosling, a Unipress, a IBM e DEC todos foram vítimas do não entendimento das leis de copyright. Sem precisar acusar ninguém de má índole, a resposta mais simples parece ser que foi ingenuidade mesmo. Eram todos basicamente recém formados de faculdade. O próprio Gosling não estava muito aí, ele ouviu falar dessa idéia interessante de Emacs, que já existia na forma de um monte de macros do editor TECO que começou com Guy Steele, o Emacs de Greenberg feito em MacLisp e a própria primeira versão mais simples do Stallman em Assembly de PDP-10 feito uns 7 anos antes do GosMacs. O que o Gosling fez foi a primeira versão em C.






Quando o Stallman começou a desenvolver o sistema GNU no começo dos anos 80 ele de fato pegou o GosMacs e fez todas as modificações que eu falei, como trocar o mocklisp por elisp e assim por diante. Mas durante o período que a Unipress distribuiu a versão do Gosling, o GNU Emacs de fato continua ainda contendo algum código do GosMacs. Contrário do que o Gosling acredita, não foi só uma versão sem os textos de copyright. Portanto sim, faz sentido a IBM e DEC perderem porque a versão do GNU Emacs que eles distribuíram ainda continua código original do GosMacs conforme testemunhas técnicas puderam atestar comparando arquivos dos dois. E faz sentido que o GNU Emacs em si ainda existiu depois porque faltava pouco pra substituir o resto, que foi o que o Stallman fez, e a partir desse ponto já não infringia mais a licença da Unipress. E esse é o GNU Emacs que você muita gente usa até hoje.







Mas o Gosling não estava muito interessado nisso porque no fim dos anos 80 quando esse episódio se desenrolou ele foi recrutado pela Sun Microsystems. Um dos fundadores é ninguém menos que Bill Joy que veio de Berkeley e trabalhou no que hoje você conhece como o Berkeley Software Distribution ou BSD UNIX, na forma de distros como FreeBSD, OpenBSD ou NetBSD que muita gente usa até hoje, sendo o atual MacOS da Apple meio que um derivado do FreeBSD. O SunOS 4 era baseado em BSD e depois o Solaris viria a ser derivado de outro Unix, o System V. E ironicamente Bill Joy também tendo sido o inventor de outro editor de textos, o lendário VI que depois foi reescrito como Vi Improved ou VIM do Brian Moolenar.






De qualquer forma, na Sun eles perseguiram outro projeto o Star7, um tipo de set top box, pense os Roku ou Apple TV ou Chromecast que você tem hoje, mas no fim dos anos 80. Já é uma lenda que desse projeto foi que nasceu a linguagem derivada de Simula, Pascal, Mesa e outros, codenome Oak que se tornaria o Java que todo mundo usa hoje. Mas a parte importante é que no fim dos anos 80 e começo dos anos 90, ninguém sabia muito bem o que fazer com código fonte aberto. O Linux ainda não era o sucesso que é hoje, e era muito experimental e razoavelmente apavorante adotar uma licença nova como a GPL.







E você pode imaginar que não ajudou nem um pouco o Gosling ter raiva do Stallman por causa do incidente da Unipress. E você pode ver que ele ainda guarda rancor porque ele mesmo disse isso agora em 2019. Pro Stallman ele é a vítima por ter trabalhado em cima do código do Gosmacs e pra ele o Gosling traiu todo mundo que colaborou no código do GosMacs quando ele resolveu unilateralmente vender pra Unipress. Ele se sentiu atacado e temendo novos episódios semelhantes no futuro daí que lendariamente ele teve a idéia de criar o conceito de copyleft e inventar a General Public License ou licença GPL.





Por outro lado o Gosling se sente a vítima porque na visão dele o Stallman roubou o código dele e prejudicou o negócio dos seus amigos da Unipress. Tanto ele se sente assim que ele foi contra adotar o GPL pro Java logo no começo. Precisou de mais de 10 anos e muita pressão da comunidade e do mercado pra ele apoiar a iniciativa do OpenJDK. Em vez disso a Sun tinha uma licença semi-proprietária. O código fonte era aberto mas você não podia usar esse código. Porém, a propaganda da Sun sempre foi que eles eram bonzinhos e apesar de segurarem a propriedade de tudo que é derivado do Java, eles nunca iam fazer nenhuma maldade.






Esse problema é grave e foi uma discussão longa do fim dos anos 90 até o começo dos anos 2010. Entenda, no mundo jurídico a palavra verbal não significa muita coisa. Sempre se lembre disso: tenha tudo por escrito em papel, assinado e com testemunha, senão você é o trouxa da história. O Stallman não gostou do posicionamento da Sun. E por conta de episódios como o Bug do Milênio que levou à adoção de linguagens e tecnologias que fossem imunes a esse bug e à Bolha da Internet que também ajudou muito a adoção do Java, agora um monte de empresas estava à mercê da boa vontade da Sun. Eu lembro que acho que foi por volta de 2004 que ele escreveu o famoso artigo Libre mas Algemado, a Armadilha Java, ou Java Trap como ficou conhecido. Eu era programador Java e acompanhava essa novela na época e lembro que fiquei pensando: uma hora isso vai dar merda.






A comunidade de software livre não ficou parada, e desde os anos 90 já existiam engenharia reversa do Java com projetos como o GCJ que é o compilador Java em cima do GCC, o GCC Classpath que é a reimplementação das bibliotecas Java padrão de forma aberta. Mas era uma corrida de gato e rato difícil. O Java ficava cada vez maior, e mesmo você reimplementando uma versão cleam room, a versão da Sun era mais testado e tinha mais investimento então sempre era mais performático. Nenhuma versão aberta era 100% compatível porque a Sun não liberava os testes pra validar. Finalmente nasceu o projeto IcedTea só em 2006, mais de 10 anos depois do Java ter sido inventado, que se tornou o projeto OpenJDK.





Mesmo a introdução do OpenJDK na JavaOne de 2006 não foi exatamente um mar de rosas. Como eu já expliquei não basta abrir usando uma licença de software livre. Por exemplo, de cara eles mudaram pro OpenJDK ser GPK com uma cláusula de exclusão de classpath. Se fosse GPL puro todo projeto Java que linkasse com bibliotecas Java seria contaminado com GPL e precisaria abrir seu código. Por isso existe a cláusula de exclusão que é uma versão mais leve do LGPL que é feito justamente pra bibliotecas. Porém eles não fizeram isso pra tudo, levou um tempo ainda pra coisas como o JavaFX ganhar a cláusula de exclusão, então no dia um você ainda estava arriscando se contaminar com GPL. Não foi uma transição suave. Eventualmente as coisas estabilizaram mas levou um tempo. Eu fico imaginando se já em 2006 existia a informação interna de serem vendidos pra alguém e antes disso eles deixaram esse cavalo de tróia ativo.






“Ah, mas a Sun é boazinha e nunca vai dar ruim.” Essa era a postura até o mundo ficar chocado quando a Oracle comprou a Sun e passou a ser a nova dona do Java. E se alguém acreditou que a Oracle comprou a Sun pra ajudar o Java, pense de novo. Recapitulando a histórica o projeto Android começou lá por 2003. Segundo a Wikipedia, o Google tentou negociar com a Sun comprar licenças pra usar o Java mas a Sun recusou porque segundo o testemunho da Oracle, o objetivo do Google era fazer um fork proprietário e incompatível do Java, coisa que a Sun já sofreu antes como no caso do J++ da Microsoft nos anos 90.






Como naquela época o OpenJDK ainda não era o que é hoje o Google se voltou pra outro projeto open source, o Apache Harmony, que era outra engenharia reversa aberta, ou implementação clean room - que é o que se chama uma reimplementação do zero sem olhar o código fonte original pra garantir que você não vai cair em plágio. Esse desenvolvimento se tornou a virtual machine Dalvik que saiu nos Android. Ao que parece, o Apache Harmony incluía 37 chamadas de API e 11 mil e quinhentas linhas de código que supostamente eram centrais ao Java e esse é estopim do caso contra o Google. A Apache Foundation na época tinha tentado conseguir licença da Sun mas de novo a Sun não concordou por divergências nas licenças.





Quando o Google lançou o Android em novembro de 2007 o CEO da Sun resolveu publicamente congratular o Google pra comunidade achar que o Android continua fazendo parte do ecossistema do Java. Mas aí veio o soco no estômago, quando a Oracle anunciou em abril de 2009 que estava completando a aquisição da Sun por 7.4 bilhões de dólares no que o CEO da Oracle, Larry Ellison chamou a aquisição da linguagem Java "do mais importante ativo de software que ela já adquiriu".





Menos de um ano depois, em agosto de 2010 a Oracle entra com processo contra o Google por infringir copyright e patentes. Esse caso é complicado e eu não tenho paciência de seguir cada reviravolta,  e entenda que este caso continua ativo até hoje. Em 2020 ainda não temos um veredito. E esse é o Java Trap que o Stallman avisou em seu artigo em 2004. Porém a discussão foi mais longe porque estão questionando se você implementar uma API que já existe é infringir copyright. Um exemplo tosco, System.out.println todo mundo sabe que é uma API do Java, essa e outras milhões que fazem parte da JVM e das classes standard que vem no JDK, se você reimplementar a API isso é considerado “fair use” ou isso é infringir propriedade intelectual? 






Uma ramificação, Linux é software livre, mas ele também é a implementação de um outro padrão o POSIX que é a API do UNIX original, que não é livre. Já foi passada pra SCO, depois pra Novell e agora está na mão da Micro Focus. Se a Oracle ganhar e criar este precedente, então todo mundo que usa Linux se encontra numa posição ruim? A Micro Focus poderia processar todo mundo que usa Linux sobre o argumento que o Linux infringe copyright do UNIX ao reimplementar as mesmas APIs?






Pro Google a grande vantagem de ter implementado as APIs do Java e não ser o Java e sim uma implementação independente, foi porque ele achou que podia burlar as patentes e copyright da Sun e ao mesmo tempo se aproveitar de todo o ecossistema de código aberto, ferramentas e, principalmente, desenvolvedores de Java que poderiam potencialmente adotar o Dalvik do Android com mínimo esforço, se comparado à Microsoft ou Apple que precisaram convencer os desenvolvedores a adotar C# ou Objective-C. Mas se ele perder esse caso, além de ter que pagar até 80 bilhões de dólares de danos pra Oracle, pode gerar ramificações pra todo o mundo de código aberto.






Lembram que eu falei que definir fair use é complicado no episódio anterior? Este é um caso real e gigante, que alguns consideram o maior do século. E se você é um hater de Trump, deve odiar mais ainda a Oracle já que seu CEO Larry Ellison é um apoiador declarado. Apesar de tudo isso o julgamento não é trivial, por um lado, muitos argumentam e eu concordo que APIs não deviam ser objeto de copyright. Por outro lado, o caso da Oracle é que o Google não só implementou as APIs em cleanroom como eu falei, eles de fato usaram código do Java original. Como eu falei antes, o código fonte era aberto embora você não devesse usar porque a licença da Sun não era aberta. E se eu não entendi errado o projeto Apache Harmony que o Google usou, continha esses códigos também. Então não é um caso binário de certo ou errado. A forma como o suprema corte verbalizar a conclusão do caso pode ter efeitos em toda a indústria.








Na prática nenhum dos dois é totalmente certo nem totalmente errado. O Google escolheu se colocar nessa situação, ele poderia ter feito como a Microsoft, que depois que apanhou no caso do J++ da Sun, levou ao desenvolvimento do .NET e C#. Mas isso daria muito mais trabalho. Copiar a API do Java e até mesmo partes do código e criar um concorrente incompatível é muito mais simples e eles apostaram que iam sair ilesos disso. Foi uma aposta arriscada e eles sabiam disso, além do que eles não previram que a Sun seria obrigada a vender justo pra Oracle. Como eu já disse, você não pode se declarar ignorante da lei e dar de joão sem braço depois, foi uma aposta, eles blefaram e a Oracle pagou pra ver.






É impossível prever o futuro e vendo de trás pra frente sempre as coisas parecem mais simples. Mas veja que interessante, tudo isso está acontecendo porque o Java nunca foi realmente software livre. Durante sua história ele teve reimplementações como GCC Classpath ou Apache Harmony, mas eles nunca foram completos nem competitivos. Demorou até 2006 pra começar a iniciativa OpenJDK, e só por volta de 2008 que o OpenJDK começou de fato a ficar usável. Durante esse período todo mundo só confiou que mesmo o Java não sendo aberto, a Sun seria boazinha e ninguém viu a Oracle chegando um dia, nem o Google.





Se lá no meio dos anos 80, o Gosling não tivesse ficado com raiva do Stallman e tivesse comprado a idéia de software livre, talvez o Java tivesse tido a chance de ser aberto muito mais cedo, talvez desde o começo já que Bill Joy também veio do mundo dos hackers trocando código aberto. O que aconteceu em universidades como MIT, Carnegie Mellon, Berkeley e outras foi a origem dos conceitos de software livre. Mas, por outro lado, se o Stallman não tivesse se sentido prejudicado pelo Gosling e a Unipress, talvez não teríamos o GPL a tempo e software cruciais como Linux não teriam adotado essa licença no começo dos anos 90, estando a mercê de ser fechado num episódio similar ao da Unipress.






Aliás, o almoço grátis já acabou ano passado, em janeiro de 2019. Pra ter atualizações, negócios que vivem de Java precisam adquirir licença da Oracle diretamente ou via parceiros como a Oracle WebLogic ou SAP Netweaver. Ou usar OpenJDK e ficar por conta da comunidade. Ou pagar uma empresa que dá suporte ao OpenJDK como a Azul Systems, dentre outras alternativas. Mas não existe mais aquela idéia de "confie na Sun e use Java". Essa é uma das razões de porque muitas empresas preferem não usar Java se não for realmente necessário, o que é uma infelicidade porque de fato a plataforma Java até hoje é uma das melhores que já foi criada. Resumo pra hoje em dia, se precisa usar Java, use OpenJDK.







Se você é novo em programação acho que vale a pena entender o quê é o quê nesse mundo que ainda está em constantes mudanças. Uma tecnologia não existe num vácuo. É importante entender a história das coisas que você usa. O mundo não é nem estático e nem preto no branco. Aliás, como última ironia, em 2011 descobriram que o Emacs, sim o software livre original, estava liberando binários sem liberar o código fonte completo por quase 2 anos, entre 2009 e 2011. Claro, parece que foi um erro da automação de releases e o Stallman se desculpou e já consertou isso, mas é pra ilustrar como é fácil cometer erros também. Todo mundo comete erros. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, não deixem de assinar o canal, clicar no sininho pra não perder os próximos episódios e compartilhem o video com seus amigos pra ajudar o canal. A gente se vê, até mais.

