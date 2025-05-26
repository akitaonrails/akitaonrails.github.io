---
title: '[Akitando] #41 - Entendendo Back-End para Iniciantes em Programação (Parte
  2) | Série "Começando aos 40"'
date: '2019-02-27T17:00:00-03:00'
slug: akitando-41-entendendo-back-end-para-iniciantes-em-programacao-parte-2-serie-comecando-aos-40
tags:
- groovy
- scala
- grails
- ruby
- ruby on rails
- python
- java
- ".net"
- lambda
- lambda calculus
- alan turing
- alonzo church
- JVM
- componentização
- OOP
- programação orientada a objetos
- programação funcional
- haskell
- ocaml
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


<iframe width="560" height="315" src="https://www.youtube.com/embed/N6vgZr1k03g" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


### Descrição no YouTube

Esta é a Parte 2 do tema de Back-end para Iniciantes. Desta vez vamos olhar com mais cuidado sobre gerenciamento de dependências, o que diabos são dependências, e linguagens como Groovy, Scala, Elixir, Go e um pouco de Ruby e Ruby on Rails também.

Provavelmente este vai ser o episódio mais difícil deste canal até agora, se você é iniciante, e você vai precisar ver e rever várias vezes, mas se você está levando a sério se tornar um programador, o que vou dizer hoje é de extrema importância pra você entender e estudar bastante.

Além de tudo este é o episódio mais longo deste canal até hoje. Nesta mini-série de "Começando aos 40" eu estou resumindo e dando o contexto geral do que você aprenderia (ou não) em meses de faculdade e trabalhando na prática. Aproveitem pra entender a idéia geral e puxar todos os assuntos para estudar em mais detalhes sozinho. Mandem suas dúvidas nos comentários também! E não deixem de compartilhar com seus amigos. 


Akitando:

* Playlist de Programação (https://www.youtube.com/watch?v=WObC_2e0kZk&list=PLdsnXVqbHDUcrE56CH8sXaPF3TTqoBP2z)
* Playlist Começando aos 40 (https://www.youtube.com/watch?v=O76ZfAIEukE&list=PLdsnXVqbHDUc7htGFobbZoNen3r_wm3ki)
* Sua Linguagem NÃO é Especial - Parte 1 (https://www.youtube.com/watch?v=p9-WuJbVHHc)
* Sua Linguagem NÃO é Especial - Parte 2 (https://www.youtube.com/watch?v=XcTTajFENHI)


Links:

* So, What's wrong with SBT? (http://www.lihaoyi.com/post/SowhatswrongwithSBT.html)
* Reia (http://reia-lang.org/)
* Go is not Good (https://github.com/ksimka/go-is-not-good)
* Why Go is a Poorly Designed Language (https://medium.com/@tucnak/why-go-is-a-poorly-designed-language-1cc04e5daf2)
* Why Go is not Good (http://yager.io/programming/go.html)


Me sigam também em outras redes sociais:

* Twitter (https://twitter.com/akitaonrails)
* Instagram (https://instagram.com/akitaonrails)
* Facebook (https://facebook.com/akitaonrails)
* Quora (https://www.quora.com/profile/Fabio-Akita)
* Blog (https://www.akitaonrails.com)

## Script

Olá pessoal, Fabio Akita

Este já é sexto episódio da série Começando aos 40. O ideal é que vocês assistam todos os outros vídeos da série, e se possível os da playlist de programação que tem a rápida história das linguagens nos vídeos de Sua Linguagem Não é Especial. Eu vou deixar linkado nas descrições abaixo. Continuo bem contente com a repercussão dos últimos vídeos, parece que vocês estão gostando do formato então vou continuar assim até o fim desta série. Hoje por acaso estou sentindo minha garganta dando pra trás, é possível que minha voz comece a falhar até o fim do vídeo, mas vamos lá.

No episódio da semana passada eu expliquei os conceitos mais básicos da computação, sobre instruções de máquina, compilação, interpretadores, como os binários se linkam com suas dependências, lembra? Linkagem estática e dinâmica? Começamos a falar um pouco sobre Java e .NET e máquinas virtuais como JVM. Agora com os conceitos entendidos vamos entender porque eu disse que era importante entender tudo isso antes do que vou falar hoje. 

Uma das coisas mais importantes pra um programador iniciante entender é que você nunca vai fazer softwares de verdade totalmente do zero, ou seja, que 100% do código foi só você que escreveu. Você vai ser obrigado a usar bibliotecas dos outros. Vamos expandir o conceito de bibliotecas dinâmicas e entender quão fundo vai o buraco desse coelho.


(...)



Até esse ponto na história você tinha então linguagens estilo Java, que é muito inspirado em C++ e alguns pontos de Smalltalk com alguns, mas não todos os conceitos de orientação a objetos e o conceito de máquina virtual e gerenciador de memória que também havia em Lisp. Na prática, em vez de orientação a objetos eu argumentaria que Java é uma linguagem mais orientada a classes. Muita coisa em Java não são objetos, começando com a própria classe em si. A orientação a objetos veio evoluindo desde Simula, CLU, C com Classes que originou C++, Smalltalk que foi provavelmente a melhor representação de orientação a objetos, e Java que deu alguns passos pra trás.


Até esse ponto já entendemos o conceito de bibliotecas dinâmicas que podem ser reusada. Bibliotecas em geral são conjuntos de funções que fazem alguma coisa útil como processar imagens, converter datas, formatar PDFs ou qualquer coisa assim que possa ser reusada. Componentes são funcionalidades, como um componente de calendário que tem a parte visual e a programação que controla as datas. Uma biblioteca pode ter vários componentes, por exemplo. A parte visual começou a ficar importante com o advento das interfaces gráficas, com a crescente adoção de ambientes gráficos como o Macintosh original, o OS/2 que foi um filho bastardo da IBM com a Microsoft e finalmente o Windows 3.1. Por acaso modelar componentes como classes e objetos era interessante e foi quando esses dois conceitos começaram a se mesclar.


No começo dos anos 90 um dos conceitos ligados a orientação a objetos começou a aparecer mais que foi a componentização. Em particular na forma de RAD ou Rapid Application Development, Na categoria de RAD foi onde se popularizou o conceito de Integrated Development Environment ou IDEs como os antigos PowerBuilder, Visual Basic, Visual dBase, Access, Delphi. As linguagens por baixo ainda não eram realmente orientadas a objeto como conhecemos mas aí surgiu o Java que trouxe uma evolução. Ainda longe do que era o Smalltalk mas já melhor do que Visual Basic. 


Componentização também se tornou uma idéia importante primeiro para evitar reescrever software do zero toda vez e tornar mais fácil reusar software. Mas mais do que isso pra tornar mais fácil comercializar esses componentes. Hoje em dia se você quer uma biblioteca pra, sei lá, imprimir um PDF tem centenas disponíveis de graça no GitHub pra quase todas as linguagens. Mas naquela época a Internet só tava começando, nem 2% da população tinha acesso ainda. E o jeito pra se comercializar era distribuindo em disquetes, encaixotado, em prateleira de lojas. Pra começar, agora que tínhamos um ambiente gráfico mais sofisticado nos sistemas operacionais não dava pra todo programador toda hora ter que fazer tudo do zero. Desenhar um botão fazendo as linhas da borda pixel a pixel. Por isso linguagens como o Microsoft C++ já vem com um framework, o MFC ou Microsoft Foundation Classes e o Delphi vem como VCL ou Visual Components Library. Normalmente são conjuntos de DLLs como já expliquei antes.


Com C++ e MFC podemos criar aplicativos como um Word ou Excel. Mas daí a Microsoft foi além e criou outra tecnologia, o OLE ou Object Linking and Embedding que em resumo é uma forma de incluir componentes visuais complexos dinamicamente num aplicativo. Vocês já sabem o que são bibliotecas dinâmicas, mas do jeito como explicamos você precisa compilar o programa já com os bindings pras bibliotecas em tempo de compilação. Mas como fazer pra instalar um componente num programa que já existe sem recompilar? Uma demonstração impressionante na época era conseguir fazer uma tabela do Excel ser embutido dentro de um documento do Word e ser editável. Em cima do OLE surgiu o OLE control extensions ou OCX. Se você já instalou componentes num Access ou Delphi deve ter visto bibliotecas com extensão OCX que se tornou a principal forma de distribuir componentes em Windows.


Isso foi uma pequena revolução porque também permitia comercializar componentes num formato padrão que podia ser escrito em qualquer linguagem da época e embutida em qualquer aplicativo que suportasse o padrão, incluindo IDEs. Do OLE original pra OCX também se precisou de um modelo para linguagens interagirem com esses componentes. Então nasce o Component Object Model ou COM. É assim que componentização funcionou na época do Visual Basic e Delphi. No mundo Java o equivalente ao COM poderia ser um Java Bean. Hoje OCX é outra coisa, são componentes ActiveX. Assim como no Java toda classe herda de Object ou em Object Pascal toda classe herda de TObject, em COM você implementa a interface IUnknown.


Aqui vale entender a função de uma interface. Numa interface gráfica, tanto faz se você tem uma janela com um botão de OK em Windows, ou em MacOS, ou em GNOME do Linux, a interface é a mesma do ponto de vista do usuário, mas a programação, ou implementação por trás é completamente diferente. A interface garante que quem vai consumir o serviço por trás não precisa se preocupar como ele é construído. A mesma coisa são as interfaces para bibliotecas, nesse caso em vez de ser um elemento visual, se trata de um arquivo em um determinado formato que simplesmente declara que funções, com que argumentos, com que tipos de dados, e que tipo de resultados você espera. Daí você implementa como quiser por trás e quem consome essa biblioteca pode assumir que no mínimo ele vai implementar as funções conforme descritas na interface. Uma classe numa linguagem orientada a objetos é a implementação de alguma interface, como a tal IUnknown do padrão COM que falei antes.


Poderíamos argumentar que o modelo de componentes mais avançado na época, no começo dos anos 90, era a NextStep com sua linguagem Objective C que eu argumentaria que é mais simples, mais elegante e mais orientado a objetos do que C++ ou Object Pascal ou mesmo Java e tinha um conjunto de classes, que eles chamavam de kits como o Foundation Kit, melhor do que o MFC da Microsoft ou VCL da Borland. Pra vocês terem uma idéia de quão à frente do seu tempo ela estava, o desenvolvimento de iOS e MacOS de hoje ainda usa uma evolução direta das mesmas classes até hoje, por isso os nomes das classes como “NSString” ou “NSObject” começam com esse NS que é de NextStep. No fim dos anos 80 e começo dos anos 90, essa idéia de arrastar e soltar componentes direto numa janela gráfica pra criar programas era uma idéia revolucionária. No NextStep que surgiu o lendário primeiro navegador web de Tim Berners Lee, mas não só isso, pra nerds como eu é a Id Software desenvolveu a engine gráfica do jogo Doom. O também lendário John Carmack gostava dos NextCube.


A primeira geração de programas nessa época no fim dos anos 80 eram aplicativos desktop normais, como os feitos em PowerBuilder ou Access que rodavam só localmente em uma máquina. Esses programas normalmente tinham um binário da aplicação e outro arquivo que representava um banco de dados, muitos derivados do primitivo formato DBF (que literalmente significa database file) que usávamos em dBase ou Clipper ou FoxPro. O que a gente chamava de banco de dados era uma estrutura de dados muito simples, pense uma coisa parecida com uma lista ligada de estruturas e um índice primitivo. Numa época que empresas pequenas às vezes tinha só 1 computador pra empresa inteira, isso até funcionava. O banco inteiro era um único arquivo. E se dois usuários em duas máquinas quisessem compartilhar o mesmo banco de dados sem precisar ficar copiando o arquivo toda hora?


Com a popularização dos desktops, principalmente PCs e também com acesso a tecnologias de redes locais, antes ainda da Internet comercial realmente decolar, começa a surgir o conceito de aplicativos distribuídos. Foi com a popularização de tecnologias de redes como da Novell e do protocolo IPX/SPX e o Windows NetBios que permitiam compartilhar arquivos numa rede local que as coisas começaram a mudar. Com essa possibilidade, e se colocássemos o tal arquivo de banco de dados numa pasta compartilhada na rede, daí copiamos o programa na máquina de cada pessoa na rede e quando o programa abre ele pode apontar pro arquivo compartilhado e booom agora todo mundo pode acessar os mesmos dados! Sensacional né? Só que não ...    Puta idéia errada.


Lembram no episódio passado que falei da dor de cabeça que é programar multi-threads porque cada thread tem acesso à memória global e uma pode ficar pisando na memória da outra? Mesma coisa com programas acessando um arquivo compartilhado na rede. ?O que acontece quando um programa tenta escrever no mesmo registro, no mesmo arquivo, que outro programa na rede? Caos!   Foi a era dos arquivos de banco de dados que corrompiam toda hora. 


Essas linguagens primárias e as redes da época só tinham uma coisa pra fazer nessa época: bloquear o arquivo inteiro! Ou seja, se alguém decidisse gravar alguma coisa no banco de dados, todos os outros programas precisavam esperar a vez. Não era ideal mas em redes pequenas de 10 ou 20 máquinas não chegava a ser o fim do mundo. Mas o problema é que um arquivo compartilhado não é mágica. Tem um servidor onde fica o arquivo de verdade, na rede as pessoas não tem a cópia inteira do arquivo, ele vai lendo pedaços do arquivo em um stream de dados. 


Aliás, esse conceito de stream é importante você entender se ainda não estudou. Se você tem um arquivo de, digamos, 100 GB na rede, e você quer só um pedaço no meio dele, você não precisa baixar o arquivo todo. Você abre um stream, tipo uma corrente ou esteira mesmo e vai puxando um pedaço de cada vez até chegar na parte que quer e aí pode fechar esse stream. Ou você pode abrir o stream direto já no meio do arquivo e ir lendo de lá um pedaço de cada vez. Quem é bem iniciante se confunde com isso porque você consegue listar os arquivos na rede como se estivesse local na sua máquina, mas “ver” os arquivos e “ter” os arquivos são coisas diferentes.


 Mas se você tentar ler esse arquivo gigante inteiro, dependendo da velocidade da rede, que é sempre lento, pode levar muitos minutos. E na hora de gravar o servidor de rede precisava não errar onde ia gravar no meio do arquivo. ?E se seu programa dá pau na rede no meio de uma gravação? Ou se a rede dá pau? Ou se o servidor engasga? De repente a gente começou a ter um monte de variáveis a mais pra se preocupar onde antes era simplesmente abrir o arquivo, gravar e fechar.


Durante os anos 90 fomos evoluindo esse conceito de 2 camadas ou cliente-servidor primitivo. O próximo passo foi usar um servidor de banco de dados em vez de só compartilhar um arquivo na rede. Foi assim que começamos a usar bancos como Ingres, Caché, InterBase, IBM DB/2, Oracle e só depois que a Microsoft adquire a Sybase no meio dos anos 90 que ele constrói o SQL Server sobre ele. 


A diferença com arquivos compartilhados é que em vez do programa cliente tentar abrir um arquivo na rede ele se conecta antes a outro programa que está remoto, um servidor. Nesse caso um servidor de banco de dados. Isso evita quase totalmente que o arquivo de dados em si se corrompa tão fácil. Esse servidor vai servir como um mediador, os clientes pedem a ele pra fazer operações no arquivo e o mediador vai executando na ordem correta as coisas, e como só ele abre e escreve no arquivo, as chances dele corromper eram muito menores. 


Lembra no episódio sobre a história do front-end como eu expliquei que um navegador web é um cliente TCP e o servidor web é um servidor TCP? É a mesma coisa aqui, só que antes de começarmos a usar o protocolo TCP antes usávamos protocolos de rede local como o IPX que falei antes, então o programa em Delphi ou FoxPro podia ser um cliente IPX e o banco de dados era um servidor IPX. Pouco tempo depois que a Internet começou a se popularizar e o Windows finalmente começou a vir com uma pilha TCP/IP que começamos a trocar tudo por TCP.


Uma pequena evolução nessa arquitetura foi com bancos como Oracle ou SQL Server que permitem escrever programas que rodam dentro do servidor de banco de dados, os famigerados Stored Procedures em linguagens como PL/SQL ou T/SQL. Assim começamos a separar parte da lógica que ficava exclusivamente nos programas cliente para o lado do servidor. Isso ajuda em muito a diminuir a complexidade dos programas cliente, diminui a necessidade de ficar atualizando os programas nos desktops toda vez que a lógica de negócios muda. Mas por outro lado causa mais lentidão no banco de dados porque agora além de ter que fazer as operações básicas de ler e escrever dados ele vai precisar processar e computar cálculos e outras lógicas em cima desses dados.


De novo, lembre a dificuldade que era atualizar o programa cliente nos desktops. Você precisava gerar um novo binário e mandar todo mundo desligar tudo das máquinas, ir de máquina em máquina com um disquete pra instalar ou mandar todo mundo baixar do servidor de arquivos na rede. Pior ainda se a empresa tinha filiais em lugares geograficamente separados onde nem todas as filiais se comunicavam com as outras. Lembre-se, internet ainda era uma coisa opcional. A gente tinha redes locais dentro do escritório, mas não necessariamente internet entre os diferentes escritórios. ?E se uma filial começa a rodar o programa mais novo mas outra filial esquece e fica na versão mais velha?


Agora, alguém parou pra pensar: o banco de dados é um servidor de rede. Os programas são clientes que se conectam nesse servidor. Só que o banco faz duas funções: gerencia os dados e roda lógica de negócio com essas stored procedures. Porque não mais um servidor no MEIO do caminho? Daí o cliente se conecta nesse que tem lógica de processamento de dados primeiro, que por sua vez vai se conectar em um segundo servidor, que seria o de banco de dados. Dessa forma conseguimos tanto separar a lógica de negócio e diminuir o tamanho dos programas nos desktops e também tiramos a carga do servidor de banco de dados. Esse é o nascimento da arquitetura que conhecemos como três camadas ou three tiers. Se você assistiu o episódio sobre SAP é aqui que as soluções corporativas começam a se encaixar.


Com a idéia de um servidor de aplicação passamos a pensar mais em interoperabilidade e protocolos de rede. Junte a idéia de componentização, orientação a objetos e a necessidade de componentizar agora um conceito mais abstrato: chamar lógica de negócios em outro servidor. Assim nascem especificações como o COM e Distributed COM ou DCOM que depois seria renomeado como COM+ da Microsoft ou concorrentes como o famigerado CORBA. Na prática eram todas formas de chamadas de procedimento remotos ou o que chamamos hoje de RFC ou RPC, que é remote procedure calls.


Eu já expliquei que pra compilar um programa que depende de uma biblioteca dinâmica precisamos de um arquivo de cabeçalho que declara que funções essa biblioteca tem exposta para ser consumida, a tal da Interface. É exatamente a mesma coisa agora só que em vez de uma biblioteca dinâmica é uma biblioteca remota, mais precisamente um cliente de algum serviço remoto. Não temos como saber o que um servidor de aplicações tem de funções expostas então precisamos de algum tipo de interface que declara quaisfunções, com que argumentos, e que resultados esse servidor de aplicações expõe pra gente, através de que protocolo. Pra isso servem coisas como COM+ ou CORBA que tinham o protocolo IIOP ou Inter-ORB onde ORB significa object request broker, para especificar esse protocolo de comunicação, o formato das mensagens trocadas. 


Esse conceito coincide com a fase do Java onde começa a surgir o famigerado J2EE ou Java 2 Enterprise Edition que hoje é chamado só de JEE, sem o dois. Java 2 é engraçado porque tivemos o Java 1, daí ele foi pro Java 1.1 e depois 1.2 e aí nasceu J2EE mas depois as versões foram 1.3, depois 1.4 e acho que só na 1.5 que ele chamou de direto de versão 5. Hoje acho que estamos no Java 10 ou 11 certo? Enfim, o J2EE era uma especificação realmente interessante porque ela consolidava tudo que tínhamos inventado até então em tecnologias de desenvolvimento de aplicações em três camadas e agora também usando tecnologias de internet como o protocolo TCP e HTTP. 


Em resumo J2EE especifica o também famigerado servlet que é uma forma de encapsular as operações de HTTP, ele especifica uma forma complexa de gerar aplicações usando um modelo chamado Model 2 que é basicamente o Model - View - Controller ou MVC que você tanto ouve falar hoje. E na parte do model, que costuma ser uma abstração pra uma ou mais tabelas no banco de dados, temos os também famigerados EJB ou Enterprise Java Beans, além dos JMS ou Java Message Service, que encapsulam maneiras de acessar banco de dados remotos e outros tipos de serviços remotos como outros servidores de aplicação. E tudo isso conectado via arquivos de configuração. E nessa época se tornou moda formatar arquivos de configuração no novíssimo formato XML. Em breve a Microsoft ainda vai inventar Web Services usando o protocolo SOAP que trafega os dados todos formatados em XML também. Na verdade começamos a usar XML em tudo que é lugar. E assim começa a era onde passamos a associar tudo que tem XML com muito enterprise e passamos a odiar XML.


Em paralelo a isso, muita nova literatura começou a ser escrita pra ajudar a organizar toda essaa bagunça em metodologias e vocabulários pra conseguir desenhar sistemas complexos orientados a objetos. É quando surgem nomes com Os Tres Amigos, Grady Booch, James Raumbaugh, Ivar Jacobson, cada um com suas idéias de metodologias que se juntaram numa empresa chamada Rational e juntam suas idéias no famigerado Unified Modeling Language ou UML para representar soluções baseadas nessa idéias de programar objetos e componentes. Aliás, UML que podia ser representado em arquivos em que formato? Sim, em XML. A Rational que viria a desenvolver diversas ferramentas como Rose, ClearCase, ClearQuest, e outros. Depois teríamos a famosa gangue dos quatro ou Gang of Four que são Erich Gamma, Richard Helm, Ralph Johnson e John Vlissides que escreveram o agora clássico livro de Design Patterns. O que chamamos hoje de mundo enterprise começa a ganhar forma nessa fase do fim dos anos 90, e ele começa de verdade com J2EE e as metodologias monumentais de engenharia de software orientados a objetos.


Em uma década evoluímos muito rápido de pequenos programas que rodavam só em uma máquina, pra soluções cliente-servidor em 2 camadas e agora a arquitetura em 3 camadas e as sementes para aplicações realmente distribuídas com o advento da Internet. Em paralelo, como já contei antes, tivemos C# com a origem num híbrido de J++ e Object Pascal. Como C# é basicamente a Microsoft que controla e basicamente depende só do Windows, ele conseguiu evoluir bem mais rápido do que Java nos anos seguinte, adicionando muito mais funcionalidades à linguagem que a tornaram mais do que simplesmente uma cópia da sintaxe do Java, tanto em termo de novas sintaxes quanto mais bibliotecas e serviços. COM+ e ActiveX se tornam as formas principais de componentização tanto local quanto remota e CORBA vai começando a desaparecer.


No mundo mais próximo de Linux, Perl já era popular principalmente como linguagem para scriptar coisas como ferramentas para administração de sistemas Linux. Ele veio pouco a pouco sendo substituído por Python, que era uma linguagem mais limpa e mais moderna, que também herdou algumas funcionalidades de orientação a objetos. Ele teve a sorte de pegar o crescimento das distribuições Linux e acabou se tornando a linguagem padrão em muitas distribuições. PHP pegou a onda das aplicações Web e ganhou espaço sendo mais fácil que Perl como sintaxe de linguagem. PHP se uniu a outras tecnologias emergentes no mundo open source como rodar em sistemas Linux, usar o servidor web Apache, e o ainda novato banco de dados MySQL, e assim nasce a pilha de tecnologias ou stack chamado de LAMP. 


Mas o interpretador do PHP era realmente um puxadinho, bem ruim, sendo um dos piores em gerenciamento de memória e constantes bugs de segurança, numa época onde ainda estávamos aprendendo sobre segurança agora que começamos a colocar as coisas expostas na internet pública. Fora isso o estilo de programação derivado da filosofia de Larry Wall, criador do Perl, de “quick and dirty” ou “rápido pra desenvolver mas código sujo como resultado” não era atraente pra adoção mais séria da indústria. Mas a bolha da internet acelerou a adoção de todos eles ao mesmo tempo.


Com o crash da bolha demorou alguns anos pras pessoas voltarem a se interessar em novas linguagens. Como eu disse antes, o Manifesto Ágil só foi escrito bem no ano desse crash em 2001. Então o mercado de linguagens que já existiam não tinham muito interesse em adoção em massa de práticas como as ensinadas por metodologias como Extreme Programming ou Cristal. As metodologias num mundo como Java ou C# era ditado pelos fabricantes de ferramentas como a Rational que foi comprada pela IBM, BEA, Oracle, Microsoft. Google estava crescendo rápido mas ainda não tinha tanta influência nesse mercado. Facebook ainda não existia. O mercado passou a associar tecnologias enterprise como “sérias” e tecnologias open source como “amadoras”.


Mas a gente sabia que tinha jeitos mais simples de desenvolver, principalmente se olhar as linguagens interpretadas, mas ainda não havia uma adoção significativa a não ser do PHP, que pra muitos engenheiros era uma linguagem amadora e pouco sofisticada. Foi só quando Ruby começou a ser adotada por muitos dos signatários do Manifesto Ágil como Ward Cunningham, Martin Fowler, Andrew Hunt, Brian Marick, Robert C. Martin, Dave Thomas que as pessoas começaram a mostrar algum interesse e coincidentemente tivemos o lançamento do framework Ruby on Rails em 2004 e finalmente Ruby, que havia sido criado 10 anos antes em 1995 começou a ganhar tração. Diferente de Java ou C# ou PHP, em vez de ter origem na herança de sintaxe do C++ ele procurou inspiração no Smalltalk e Lisp. Isso a tornou diferente o suficiente e com o suficiente de sofisticação para atrair a atenção desses veteranos de cabelo branco. 


Já que era muito difícil parar a inércia de gigantes como Java, .NET e PHP, pareceu interessante começar uma comunidade do zero, com uma linguagem sofisticada mas obscura, mas já aplicando as práticas evangelizadas pelas metodologias que seguiam o Manifesto Ágil. Essa Era marca o início da profissionalização das tecnologias open source para desenvolvimento de aplicações, que poucos anos antes eram consideradas mais amadoras pelo mundo enterprise. Em vez de convencer o mundo enterprise, um novo mundo começou a crescer rápido para competir com elas: as tech startups.


O sucesso quase instantâneo do Ruby on Rails para criar os tipos de aplicações que pouco tempo antes só deveriam ser feitos em Java ou C# trouxe uma nova idéia pra indústria: que pra uma linguagem fazer sucesso ela não precisava ser um clone da sintaxe de C++ ou Java ou ter o suporte de grandes nomes como IBM ou Microsoft. Nesse ponto estamos entre 2003 e 2007. Eu diria que esse período de transição é importante porque nos anos 80 surgiu de fato o movimento open source e GNU. Nos anos 90 surgiu o primeiro grande projeto que tornou open source relevante: a kernel do Linux e as distribuições de Linux. 


Durante a bolha das ponto coms tivemos sucessos comerciais como o VA Linux e a RedHat. De repente open source não era só um hobby e tinha modelos de negócio viáveis que finalmente botaram pressão nas empresas tradicionais. Mas a manutenção e criação de novos projetos não era ainda uma coisa simples, haviam sites como SourceForge, CodeHaus e outros, mas contribuir em open source ainda tinha uma barreira de entrada muito alta. Lembre-se que GitHub só se torna realmente famoso a partir de 2008.


Em 2003 mesmo outra iniciativa estava começando com o surgimento do Groovy, uma nova linguagem que compila em bytecode pra JVM. Ela tem muita inspiração na sintaxe de linguagens como Python e Ruby e é uma linguagem muito mais agradável de trabalhar do que o Java original. E com o sucesso do Ruby on Rails, tivemos o Groovy on Grails. Mas nesse momento eu acho que a comunidade Java e mesmo a open source ainda não estava preparada pra se adaptar a uma nova linguagem. Um dos problemas de ser uma comunidade gigante é que é muito difícil mudar sua direção, especialmente quando essa direção ainda era meio incerta e experimental. Mesmo assim o Groovy teve um bom nicho e ainda hoje você vai ver Groovy se usa ferramentas como o Gradle. Groovy ganhou fôlego quando entrou no GitHub e quando ganhou patrocínio da Pivotal. 


Pra quem não conhece a PivotalLabs foi uma consultoria que, junto com outros nomes emergentes como ThoughtWorks, ajudou a tornar Agile comercial mais visível, tinha na sua base tecnologias Java e Ruby também. Ela cresceu rápido pós 2008 e foi adquirida pela VMWare e depois pela EMC e hoje é uma empresa pública que mudou da área de serviços de consultoria pra produtos corporativos, mais especificamente cloud corporativo. Por 2 anos ela patrocinou o Groovy.


Voltando um pouco na história, até os anos 80 popularizou-se linguagens que chamamos de imperativas como C ou Pascal ou Perl. Elas são simples em estrutura. Você escreve funções que recebem argumentos e devolvem alguma estrutura de dados. Você compõe seus programas com funções que chamam outras funções. Rapidamente você nota que um conjunto de funções que atua em cima de uma mesma estrutura podem ser agrupadas em módulos. Assim nasce a idéia de linguagens como MODULA, precursor do Pascal. Mas então alguém resolve criar um conceito, ou uma abstração que uma estrutura com um grupo de funções pode ser o que chamamos de classes. E podemos criar várias instâncias dessa classe, que chamamos de objetos. Assim começa a nascer programação orientada a objetos. 


Daí temos linguagens como Simula, Smalltalk, C++, Objective-C, Java, C#, Python. Organização de objetos pode ser implementada em cima de linguagens imperativas, então C com classes pode virar C++ ou Objective-C. Perl pode ganhar o equivalente a classes usando bless. PHP ganhou classes. Basic ganhou classes em Visual Basic. Pascal ganhou classes rudimentares em Turbo Pascal e depois em Object Pascal que é o Delphi. Até Cobol tem classes hoje em dia.


Em paralelo a isso havia outra área de pesquisas que deriva da linhagem de linguagens funcionais como Lisp, Scheme, ML, que lida com a matemática dessa composição de funções ou lambdas e é definida em Lambda Calculus, que se iniciou com o famoso Alonzo Church, conterrâneo de Alan Turing. Turing aliás, que foi aluno de Church, então você pode ver como as idéias dos dois se misturam e o trabalho de ambos é a fundação do que chamamos de Ciência da Computação. No caso da vertente de Church vamos simplificar assim, uma função recebe um argumento tipo um número ou uma string ou outra coisa, devolve outro tipo de elemento como resultado e, principalmente, tem um nome, e só. 


?Mas por que toda função tem que ter um nome? Por que não podemos ter funções sem nome, o que chamamos de funções anônimas, e por que funções não podem receber funções como argumento e devolver funções como resultado? Em C temos algo rudimentar onde podemos passar o que chamávamos de callbacks, ou ponteiros pra memória onde está outra função, mas como eu disse era uma forma rudimentar.


Provavelmente uma das coisas mais diferentes que Ruby trouxe da herança de Lisp foi o conceito de lambdas para o mundo web, mesmo que ainda não tão avançado como era em Lisp, que implementava as idéias de lambda calculus de Church. Podemos chamar de funções anônimas, ou um tipo mais avançado que chamamos de closures ou blocos. Groovy também trouxe lambdas pra Java dentre outras coisas. Mas esse tipo de composição abriu caminho pra coisas como metaprogramação e DSLs ou Domain Specific Languages, que é como se fossem mini-linguagens em cima da linguagem principal. Em vez de somente seguir o que a linguagem dita e se pudéssemos manipular a própria estrutura e sintaxe da linguagem? A capacidade de moldar a linguagem pra ficar com a “cara” que você quisesse. Isso tornou o chato estilo imperativo de programar, em algo bem mais maleável e flexível e divertido, embora isso tenha aumentado mais a complexidade para quem está iniciando. Lambdas vieram pra ficar e depois disso toda nova linguagem e mesmo as antigas adotaram esses recursos. Hoje Java, C# e outros também ganharam lambdas e alguma capacidade de metaprogramação.



Com a virada do século e a aceleração antes do crash que tivemos nesse período, o poder computacional cresceu exponencialmente desde os anos 80, era a consequência da Lei de Moore, que ditava que o poder computacional dobraria mantendo o mesmo preço a cada 12 a 18 meses. Antes nos preocupávamos bem mais com a performance crua dos nossos programas pra tirar o máximo de máquinas caras e fracas, mas agora as máquinas finalmente ficaram poderosas e acessíveis, então passamos a ter surplus ou sobra de processamento. É importante salientar essa mudança de perspectiva. Finalmente em vez de termos que sofrer com linguagens simplistas e burocráticas em nome de economizar performance, porque não passar a pensar em formas de tornar a programação mais agradável? 


Antes, linguagens mais simples de trabalhar era quase sinônimo de baixa performance, mas agora que a web provou que performance pura não era o único fator pra escolher uma linguagem, poderíamos começar a experimentar em funcionalidades e a escola de lambda calculus começou a aparecer novamente, graças aos programadores de cabelos brancos que haviam experimentado Lisp ou Scheme nas décadas de 70 a 80. E a tal orientação a objetos também veria uma evolução graças a quem experimentou Smalltalk no mesmo período.


Vale lembrar que Lisp já tinha o conceito de máquina virtual e garbage collector décadas antes de Java. E Smalltalk tinha o conceito de que tudo é realmente objeto e que objetos ficam vivos mesmo se a máquina virtual seja desligada. Pense num VirtualBox ou VMWare quando você sobre outro sistema operacional e então suspende a máquina. O Smalltalk tem esse conceito de suspender a execução sem bootar e limpar a memória, dentro do que ele chama de imagens ou no caso literalmente um banco de dados de objetos. Quando você abre uma imagem de Smalltalk ele pode ter objetos em memória que foram instanciados 30 anos atrás. E você vai compondo novos objetos usando os objetos vivos que já existem. Pensem que louco essa arquitetura.


E falando em arquiteturas exóticas. Uma editora de livros que ganhou notoriedade nessa virada de século foi a The Pragmatic Programmer, mesmo nome do clássico livro de 2 signatários do Manifesto Ágil e que ajudaram a dar credibilidade à adoção de Ruby: Dave Thomas e Andy Hunt. Eles também popularizaram o conceito de que todo programador deveria tentar aprender pelo menos uma nova linguagem por ano, e em 2007 eles publicaram suas experiências com a linguagem Erlang dos anos 80, de Joe Armstrong, de quando trabalhava na Ericsson. Erlang que como eu expliquei em outro episódio tem uma sintaxe muito diferente, herdada de Prolog, e que tinha uma arquitetura que ninguém no mundo web tinha visto ainda: o modelo de Atores. Erlang, como Java, tem uma máquina virtual. Mas diferente da JVM ele vai um passo além: ele tem partes do conceito de lambda calculus sem ser puramente funcional e partes das principais propriedades de objetos sem ser orientada a objetos. Mas em vez de organizar as coisas como classes e objetos, ele organiza como módulos e atores. 


Um ator é como se fosse um objeto com seu estado encapsulado e se comunicando com outros atores via passagem de mensagem, diferente do Java, C++ ou C# e mais similar a Smalltalk e Objetive-C. E mais do que isso, num sistema operacional, além de carregar o Kernel ele também carrega serviços ou daemons via um serviço de supervisão como systemd ou initd ou outros dependendo do seu sabor favorito de Unix ou Linux. O Erlang tem algo similar, um sistema de supervisores que iniciam atores e se encarregam do ciclo de vida dos mesmos. Erlang assim como a JVM ou Smalltalk são quase como sistemas operacionais inteiros. Ao contrário dos interpretadores como Perl ou Python ou Ruby que foram feitos pra iniciar rápido e terminar rápido, Erlang e Java funcionam melhor se você iniciar e deixar elas parasitar a máquina toda. 


Assim como Java a idéia é subir um único processo de Erlang e deixar que ele gerencie a máquina e seus programas rodando dentro dele. Erlang não foi feito pra ser reinicializado toda hora, e sim pra ficar de pé eternamente, inclusive essa era a grande funcionalidade pra indústria de telecomunicações: que você não estivesse numa ligação e de repente fosse cortado da sua conversa porque alguém precisou subir uma atualização. Ele tem inclusive o conceito de carregar código novo sem precisar necessariamente reinicializar tudo. Na prática é mais ou menos o que Java e J2EE também preferem: ficar de pé sem ficar reinicializando o tempo todo. Ficar de pé eternamente era o grande objetivo. Guardem essa característica porque vai ficar mais óbvio quando falarmos de infraestrutura e Devops mais pra frente. Mas o ponto é que essa linguagem super estranha despertou o interesse em arquiteturas muito diferentes do que estávamos usando.


Em 2009 Martin Odersky trouxe ao mundo o resultado das pesquisas que ele vinha fazendo no mundo de lambda calculus e Java desde os anos 80 e 90 na forma de outra linguagem que compilava em bytecodes Java como o Groovy. Essa linguagem foi Scala. E ele se popularizou muito rápido porque adicionava funcionalidades que tornavam o Java mais palatável, coisas como Traits que em Objective-C são o equivalente a Protocolos e alguns diriam que é uma forma mais limpa de se fazer herança de funcionalidades. Inferência de Tipos que eu já expliquei que vem de Hindley-Milner Type System de linguagens como ML, que levantou outro dilema da programação: a discussão se linguagens de tipagem estática são melhores ou não que tipagem dinâmicos.


Em um super resumo, todos os dados no seu código, variáveis, estruturas, listas, precisam ter tipos. Pense em tipos como moldes de biscoito. Você precisa dizer de antemão qual o tamanho do molde você vai querer, pequeno, grande. No caso de números, vai ser um inteiro de 32 bits? Um inteiro de 64 bits? Um inteiro sem sinal, ou seja, sem números negativos? Isso é importante pra um compilador saber quanto de memória precisa alocar pra cada coisa. Se fizer isso errado vai faltar memória e dar erro ou vai usar memória de forma desnecessária, causando leaks ou vazamentos. Em linguagens dinâmicas como Lisp, Python, Ruby a gente não determina isso no código, o interpretador pode determinar o molde, ou o tipo certo, durante a execução do código, por isso chamamos isso de tipos dinâmicos. Eles têm tipos, só que não estão estaticamente declarados no código como fazíamos em Java ou C#. 


Declarar tipos é super tedioso e você pode errar quando está programando também. Simplesmente não declarar e deixar o interpretador decidir só quando já está rodando é muito mais conveniente mas pode causar desperdícios e alguns erros porque ele pode assumir o tipo que você não esperava e você só vai descobrir quando estiver rodando. Inferência de tipos é meio que o meio do caminho dos dois mundos porque a gente não escreve todos os tipos estaticamente no código, ou seja, deixa de ser absurdamente tedioso. Mas o compilador vai tentar adivinhar os tipos em tempo de compilação, daí o binário ou bytecode no final vai conter os tipos certos antes do programa executar. Só isso já torna escrever em Scala muito mais conveniente do que escrever em Java antigo. E Inferência de tipos foi melhorando e hoje se encontra em linguagens novas como Rust, Swift, Kotlin, Typescript. 


Mesmo Java, desde a versão 5 você tinha possibilidade de omitir alguns tipos como quando usava a implementação rudimentar de Generics. No Java 8 você pode omitir tipos em declaração de lambdas. E no Java 10 ele ganha inferência de tipos locais como C# também. Como iniciante você vai notar que estudar tipos é muito importante, independente se você vai aprender uma linguagem dinâmica ou estática, se tem inferência de tipos ou não porque mesmo inferência não é mágica, o compilador ainda precisa de algum contexto ou anotação pra inferir o tipo certo. Na prática entenda: escolha o molde errado e seu biscoito vai sair do tamanho errado. 


Scala cresceu rápido por um momento mas estagnou. Um grande problema do Scala é que o binário bytecode que ele gera de uma versão de Scala pra outra são incompatíveis. Ou seja, se você tem uma biblioteca compilada pra bytecode de Scala 1 e você faz um programa com Scala 2 e tenta carregar a biblioteca antiga, vai tomar um LinkageError da JVM. Isso era uma puta dor de cabeça: incompatibilidade binária entre coisas compiladas em diferentes versões de Scala. A única forma de solucionar isso é você recompilar tudo de novo sem reusar os binários antigos. É uma escolha de design do criador pra que ele pudesse inovar a linguagem sem se preocupar em ficar dando suporte pra coisas antigas. Hoje em dia o Go meio que exige a mesma coisa: ele prefere que você baixe o código fonte de todas as dependências, em vez de baixar binários pré-compilados, e compile tudo junto de uma só vez.


Aliás, um comentário importante: eu falei lá atrás que você como programador vai precisar sempre se preocupar com as dependências e as versões certas dessas dependências. Lembra da discussão de compilação estática vs compilação dinâmica? Nos anos 80 e 90 fabricantes de ferramentas de desenvolvimento como Borland, Microsoft, BEA, Oracle, traziam tudo junto. Eles que se viraram pra ter todas as dependências que você iria precisar já instalado ou de forma organizada que você pudesse comprar um CD e instalar na sua máquina. E mesmo assim os anos 90 foram infestados do que chamamos de “DLL Hell” com programas diferentes que precisam da mesma DLL mas em versões diferentes mas tudo no mesmo sistema entrando em conflito, literalmente um inferno de DLLs. 


Com o advento do mundo open source, de repente você podia baixar bibliotecas gratuitas de código aberto e instalar você mesmo. Mas eles não estavam esperando por isso e virou uma grande bagunça no começo. Quem daquela época nunca copiou um site em PHP que na sua máquina tudo funciona mas quando copia pro servidor ele falha porque esqueceu de também copiar ou instalar as bibliotecas de dependência? Ou no caso de Java esquecia de copiar os tais Jars e a aplicação não queria nem iniciar?


Assim que nascem ferramentas como Maven no Java que é um grande banco de dados de bibliotecas binárias. Agora você tem um repositório centralizado onde quem escrevia bibliotecas poderia postar lá e você como desenvolvedor podia declarar num arquivo em XML, lógico, os nomes e versões das bibliotecas que precisava no seu projeto e o Maven se virava pra baixar tudo que você precisava. E como uma biblioteca pode precisar de outras bibliotecas, a gente costumava brincar que toda vez que precisávamos baixar todas as dependências do projeto, o Maven baixava a internet inteira … duas vezes. Hoje essa posição é do NPM do Javascript. No mundo Microsoft demorou mais pra algo similar aparecer mas no .NET você tem hoje NuGet que inclusive passou a vir pré-instalado no Visual Studio 2012 em diante.


No mundo de programação até esse ponto a gente tinha o Maven no mundo Java, e hoje muitos usam junto o Gradle que é feito em Groovy como eu disse antes. Temos o CPAN no mundo Perl até hoje. No mundo PHP era um híbrido, todo mundo baixava as dependências na mão mesmo tendo coisas como o Pear. Hoje em dia felizmente PHP tem algo mais moderno que é o PHP Composer. No mundo Ruby estávamos evoluindo a idéia de gerenciamento de versões com algo rudimentar implementado dentro do próprio Ruby on Rails, que baixava as dependências direto do GitHub e depois evoluímos pra ferramenta Bundler que na época se tornou o benchmark sobre o qual todo mundo se comparava.


 Python preferia usar o próprio sistema de pacotes das distribuições Linux, então era uma zona porque você precisava fazer pacotes RPM ou DEB ou outros pra cada distribuição e você ainda tinha a zona de ferramentas como setuptools e easy_install, que de easy não tinha nada. Aliás, pra uma linguagem que se orgulha de ter um único jeito pra fazer cada coisa, instalar pacotes não era assim. Felizmente o mundo Python tem o PIP agora. No mundo Javascript como já falei nasceu o NPM que ganhou concorrência com o Yarn, co-autorado pelo mesmo autor do Bundler de Ruby. No mundo Elixir existe o Hex. No mundo Rust existe o Cargo. O mundo Go tem o dep, mas aqui a coisa é um pouco mais controversa.


Declarar dependências no seu projeto, instalar de algum repositório e gerenciar os upgrades de versão é uma coisa extremamente importante. Você nunca pode simplesmente atualizar todas as bibliotecas pras versões mais novas, porque seu código vai quebrar. Por outro lado você não pode ficar pra sempre com versões velhas, principalmente se elas tiverem relatos de buracos de segurança. Então você vai precisar atualizar as versões e alterar seu código pra comportar as mudanças. Vai ter vezes que o autor da biblioteca simplesmente desiste de manter sua biblioteca, vai ter buraco de segurança, agora você precisa achar outra biblioteca pra substituir e aí vai precisar reescrever toda a parte do seu código que dependia daquela biblioteca. É uma parte considerável do trabalho de ser um programador e manter um projeto grande.


Isso tudo dito, eu estava falando da incompatibilidade binária do Scala. Assim como Python tem PIP, Ruby tem Bundler o Scala tem o SBT que assim como muitas ferramentas tem a função híbrida de ser um gerenciador de pacotes e também um executor de tarefas. O Scala jogou na mão dos desenvolvedores de bibliotecas gerenciar diferentes binários de cada versão e tem um guia pra tentar manter compatibilidade binária ou o que fazer quando isso não é possível. É meio uma zona porque toda vez que o Scala lança uma versão nova, todo mundo que faz bibliotecas precisa ficar recompilando uma nova versão. Só que é irreal achar que todo mundo vai fazer isso, então você como programador que depende dessas bibliotecas, ou tem que ficar meses esperando todo mundo alcançar a versão nova, ou você mesmo precisa lidar com recompilar manualmente e ver se nada quebra. 


Eu mencionei Go porque o Go é diferente da idéia de Java ou Scala, ele não é uma máquina virtual, nem é um interpretador. Ele é mais próximo de C++, ele compila direto num binário nativo e é feito para fazer aplicações e não drivers ou coisas mais baixo nível como fazemos em C. E ele prefere compilação estática pra criar binários que acabam ficando gigantes em tamanho mas que você pode mover pra outro lugar e ele simplesmente funciona. O Go fez uma coisa que a comunidade Ruby on Rails fez em 2008 ou 2009. Ele se integra direto com repositórios Git, em particular o GitHub. Todo desenvolvedor de bibliotecas mantém o código fonte no Github. Você usa o recurso de dep que eu falei pra baixar todas as dependências do GitHub e vai vir todos os código-fonte. 


Como o intuito do Go é compilação estática ele precisa de todos os fontes disponíveis pra gerar um binário único. Então a menos que a sintaxe da linguagem não mude de forma drástica de uma versão pra outra, você sempre consegue um binário que não quebra no final sem depender de linkagem dinâmica e LinkageError que o Scala sofre. O Elixir faz algo similar com o Hex, o Rust faz algo similar com o Cargo. A idéia é sempre baixar os código-fontes das dependências e deixar próximo do código do seu próprio projeto e compilar tudo junto depois que baixa em vez de baixar bibliotecas em formato binário como os Jars de Java.


A diferença é que em Java o compilador é notoriamente lento. Em vez de toda vez compilar binários a partir do código fonte, nós compilamos e empacotamos em zips que chamamos de JARs, é o que se publica num Maven por exemplo. Daí você ou manualmente ou via Maven ou SBT no caso do Scala, baixa os JARs pré-compilados. A mesma coisa é no mundo .NET, mas a Microsoft tende a ser melhor em manter compatibilidade binária das suas dependências e agora de gerenciar as diferentes versões de cada uma. Antigamente isso era importante porque não se tinha esse conceito de código aberto, as empresas vendiam bibliotecas e preferiam não abrir o código, na verdade eles faziam o máximo inclusive pra obfuscar os bytecodes gerados pra dificultar alguém fazer engenharia reversa e ver como que ele foi implementado. 


Por isso eu salientei a diferença na virada do século da explosão do mundo de código aberto e serviços como GitHub e linguagens interpretadas como PHP, Python, Ruby que precisam ter os códigos disponíveis. Scala ainda acaba herdando essa parte do Java, mas linguagens como Go, Rust e Elixir investiram em fazer compiladores bem mais velozes e baixar dependências na forma de pacotes que embutem o código-fonte e compilar seu programa e as dependências tudo localmente em vez de depender de versões binárias pré-compiladas.


Voltando ao papo de arquiteturas, Groovy e Scala trouxeram ao mundo Java uma sintaxe bem mais moderna do que o antigo Java e isso ajudou a linguagem a evoluir muito da versão 6 até agora. Scala também trouxe a arquitetura de Atores para o mundo Java e somado à The Pragmatic Programmer evangelizando Erlang, trouxe também a possibilidade de ir direto na fonte, já que foi ela que introduziu o conceito de Atores com seu framework OTP ou Open Telecom Platform. Softwares que foram escritos pra Erlang antes também começaram a ganhar a luz do dia, em particular ejabberd e RabbitMQ numa época onde produtos de comunicação como Facebook Messenger ou Whatsapp começaram a aparecer. Erlang, sendo um produto desenhado pra indústria de telecom era um par perfeito pra produtos de comunicação em massa. Mas sejamos honestos, a linguagem do Erlang é horrível de usar nos dias de hoje, talvez ok pros anos 80, mas não pro século XXI. 


A comunidade Ruby começou a olhar Erlang e rubistas como Tony Arcieri criou a linguagem Reia. Assim como a JVM do Java roda os bytecodes compilados de linguagens como Groovy e não só do Java puro, o Erlang também tem uma máquina virtual chamada BEAM com seus próprios bytecodes. O Reia foi o primeiro experimento de tentar modernizar a sintaxe do Erlang, nesse caso imitando quase diretamente a sintaxe do Ruby para compilar em bytecodes que rodam no BEAM. Em paralelo a ele surgir outra tentativa de fazer a mesma coisa, desta vez de outro rubista, o brasileiro José Valim com a linguagem Elixir.


O Elixir foi uma tentativa mais avançada de não imitar diretamente o Ruby mas de criar uma sintaxe moderna em cima das capacidades do BEAM do Erlang e também de criar um conjunto de bibliotecas base para possibilitar realmente criar aplicações de verdade. Levou quase 4 anos pra Elixir finalmente se tornar usável de verdade pra fazer aplicações de verdade em produção. Ele aproveita tudo que o Erlang já faz mas com uma sintaxe e um conjunto de bibliotecas que remetem a coisas como Ruby, aumentando muito a produtividade. Também por causa da influência do framework Ruby on Rails surgiu o framework Phoenix para desenvolvimento de aplicações Web. 


Ruby, como vocês já devem ter percebido, é uma linguagem que eu pessoalmente gosto. Ela ajudou a influenciar outras linguagens como Groovy, depois da comunidade saiu CoffeeScript que ajudou a influenciar o atual Javascript ES6, e também influenciou a sintaxe do Elixir e do estilo da programação de suas bibliotecas. Em paralelo começamos a experimentar mais com outras linguagens uma vez que o paradigma funcional, baseado no lambda calculus que falei acima começou a ganhar terreno. Linguagens obscuras como Haskell e OCAML começaram a ganhar um pouco mais de terreno, inclusive OCAML influenciando a linguagem F# no mundo .NET. Tudo isso também ajudou a evoluir a própria linguagem Java, agora com mais de 10 anos de idade.


Para finalizar este episódio preciso falar da linguagem Go mais um pouco, que eu já vim citando durante este episódio e o anterior. Todos sabem que é a linguagem do Google, mas eu não gosto muito de Go porque pra mim ela representa um passo pra trás. Ela foi criada em 2009 e ignorou muitos avanços que outras linguagens já estavam fazendo. Por exemplo, a inferência de tipos que eu falei que o Scala popularizou e linguagens modernas como Swift, Rust, C# e mesmo Java começaram a usar é menos poderosa em Go. Os tipos do Go são mais pobres, ele não implementa Traits como Rust. Em uma linguagem criada em 2009 que se poderia escolher tudo do melhor, ela preferiu o caminho mais fácil de escolher permitir o ponteiro nulo que é causa de muitos bugs em muitas linguagens. O sistema de tipos é mais pobre, os Generics são mais pobres. Ela não permite estender e redefinir a linguagem, não suporta sobrescrever coisas como operadores. Ela é de fato uma versão melhor do que um C++, que cresceu tão monstruoso e complexo que é realmente difícil de usar hoje em dia. Mas ela não evoluiu a linhagem das linguagens. Como linguagem ela representa um passo pra trás.


Nenhuma linguagem é perfeita mas cada nova linguagem veio evoluindo em cima dos seus antecessores e o Go é basicamente mais um caso da síndrome do Google de reinventar a roda. Eu quase diria que o Go é no back-end o que o Javascript se tornou no front-end: nós usamos mais porque existem softwares importantes escritos em Go, como o ultra famoso Docker, e agora ela está se tornando grande demais pra falhar, em breve não vai mais ser uma escolha não usarmos. Vou deixar linkado nas descrições abaixo um link com diversos artigos explicando todos os problemas dessa linguagem, ela compete com Javascript em críticas. Porém, não se pode negar que ela de fato trouxe algumas coisas importantes que vou explicar também no próximo episódio.


No próximo episódio eu vou continuar essa história com Go, mais Elixir, um pouco mais de Rust, mais de Javascript, talvez eu fale de Python e principalmente vou tentar explicar mais da importância da Apple nos últimos 20 anos para o desenvolvimento de software e como ela cruza com um evento importante no mundo open source. 


A história do Back-end não acabou, eu disse que ia ser longo. No episódio de hoje eu voltei à década de 90 e dei uma breve introdução da evolução das arquiteturas de desenvolvimento de software, retornei mais ao mundo Java e entendemos mais sobre a longa e inacabada novela chamada gerenciamento de dependências, uma praga que vai te perseguir por toda sua carreira de programação e finalmente começamos a ter um gosto das novas linguagens, começando com Groovy, Scala, Erlang, Elixir, e um pouco do Go. 


Acho que finalmente passamos da metade deste tema nesta série, não deixem de mandar suas perguntas nos comentários abaixo, se curtiu o vídeo mande um joinha, assinem o canal e pra não perder a continuação dessa história clique no sininho e não deixe de compartilhar com seus amigos. Como semana que vem temos Carnaval é possível que eu tire o feriado pra descansar, vamos ver. Se não nos vermos até lá, bom Carnaval pra todo mundo!
