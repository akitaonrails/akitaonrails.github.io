---
title: '[Akitando] #39 - A História do Front-End para Iniciantes em Programação |
  Série "Começando aos 40"'
date: '2019-02-13T17:00:00-02:00'
slug: akitando-39-a-historia-do-front-end-para-iniciantes-em-programacao-serie-comecando-aos-40
tags:
- front-end
- programação
- usabilidade
- UX
- design responsivo
- flash
- javascript
- coffeescript
- sass
- css
- bootstrap
- navegadores
- internet explorer
- netscape
- java
- webpack
- npm
- asset pipeline
- tcp/ip
- http
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


{{< youtube id="VKmPGmFY7H4" >}}


### Descrição no YouTube

Este episódio vai testar a paciência de vocês. Desta vez quero explorar um pouco os diversos assuntos que são associados com a tal carreira de "Front-End" no mundo de desenvolvimento Web.

Se já começaram a estudar o assunto devem ter visto que existe uma infinidade de sopas de letrinhas, coisas como SASS, CSS, React, Vue, e muito mais. Por que existem tantas letrinhas assim? Quais escolher?

Obs: eu fico falando "Webpacker" o tempo todo mas na verdade é "Webpack" sorry :-)

Links:

* History of Web Fonts: (https://thehistoryoftheweb.com/web-fonts/)
* A brief history of CSS until 2016 (https://www.w3.org/Style/CSS20/history.html)
* Responsive Web Design: Media Queries (http://blog.chrismaxwell.com/responsive-web-design-media-queries)
* Front-End Developer Handbook 2018 (https://frontendmasters.com/books/front-end-handbook/2018/)
* Eloquent JavaScript (https://eloquentjavascript.net/)
* Mastering Regular Expressions (http://shop.oreilly.com/product/9780596528126.do)

* Juliana Negreiros (https://github.com/juunegreiros/utilities) - página cheia de boas referências.

## Script

Olá pessoal, Fabio Akita



Estamos no quarto episódio desta série, semana passada começamos com algumas coisas básicas do Developer Roadmap onde eu discuti porque saber Git e aprender Linux de verdade são as duas coisas mais importantes pra começar. Mas eu me lembrei no caso de Linux que eu disse que tinha duas formas, você aprender do jeito difícil que é instalar e configurar uma distro como Arch Linux num ambiente virtualizado como Virtualbox. Ou aprender do jeito ultra difícil, que eu esqueci de mencionar no final do episódio, e que é instalando direto como sistema operacional principal da sua máquina! Sim, vai ser bem difícil se for sua única máquina e você só tiver acesso ao site do Arch Wiki pelo celular. Mas vai por mim, hoje tá bem fácil porque a gente fazia essas coisas nos anos 90 só confiando que tinha tudo certo nos disquetes e sem internet pra baixar alguma coisa caso tivesse esquecido, e Wikis sequer haviam sido inventados, aliás, Google não tinha sido inventado. Então considere que hoje tá muito fácil e instale Arch Linux como seu sistema operacional principal. Se conseguir fazer isso sozinho, você está no caminho certo.




No episódio de HOJE vamos falar sobre um dos assuntos mais desnecessariamente complicados da carreira de programador Web, o guarda-chuva que chamamos de Front-end. Porém, em vez de seguir o Roadmap, neste episódio vou fazer uma longa tangente hoje. Aliás, vai ser um dos meus episódios mais longos, então não deixem de dizer nos comentários se preferiam que eu tivesse quebrado esse episódio em duas partes ou se nesses casos está ok ser longo mesmo.



Se você está entrando hoje no mercado de front-ends vai esbarrar em dezenas de letrinhas, coisas como Sass, Vue, React, Angular, Ember, Bootstrap, Npm, Yarn, Webpacker, Flow, TypeScript, Dart, BEM, SMACSS, PWAs, SPAs, RAIL, e por aí vai. Eu entendo porque alguém que está iniciando os estudos agora vai ficar extremamente confuso sobre por onde começar. E como sempre o melhor jeito de entender como começar é do começo.




(...)




A tangente que eu me referi é que eu vou fazer o contrário da maioria dos tutoriais ou guias que falam de front-end. Em vez de dizer logo de cara o que eu acho que você devia estudar, eu pessoalmente acho mais fácil explicar porque aquelas sopas de letrinhas existem e daí vocês mesmos podem começar a chegar em algumas conclusões. A história do front-end é a própria história da Web e algumas coisas que você tem hoje só fazem sentido no contexto dos anos 90 ou dos anos 2000, sem saber disso você meio que tem que engolir como as coisas são sem entender porque. No fim do episódio eu espero que vocês tenham muito mais perguntas do que neste momento. 



A estrutura mais simples que você precisa ter na cabeça é a seguinte: quando você abre um navegador e digita um endereço tipo https : // meusite.com.br ele vai fazer dezenas de operações mas no mínimo ele precisa primeiro traduzir o domínio num endereço IP, e quem faz esse trabalho inicial é o tal servidor de DNS ou Domain Name Server que você já deve ter ouvido pelo menos o nome, pra onde a configuração de rede do seu computador está apontando. DNS é como se fosse uma lista telefônica, traduzindo nomes pra números.



Agora é tarefa da tal rede, roteadores, provedores, conectar seu navegador a um servidor. A internet funciona porque todas as pontas falam o mesmo formato de mensagens e trafegam de uma determinada maneira, que é o que chamamos de protocolo, e o padrão que nos interessa é o famoso TCP/IP. Por agora só entenda que com o endereço ele encontra o servidor certo no mundo. Bem em resumo estamos falando de um programa ou aplicação que é um cliente de TCP ligando a um servidor TCP, que fica escutando no que chamamos de uma porta. Todo servidor web que serve páginas HTML é um programa que quando você carrega ele se liga a uma porta, que é representado por um número que vai de 1 a mais de 65 mil. 

A convenção é que um servidor Web ouve conexões na porta 80. Um servidor SSH ouve na porta 22. Um servidor Web também escuta na na porta 443 quando recebe requisição de conexão segura via HTTPS, e muitos servidores de desenvolvimento como Node.js, Rails ou Java ouvem em portas como 3000 ou 5000 ou 8080, respectivamente. Não há nada de mágico nesses números, são arbitrários e foram escolhidos anos atrás e por isso é só uma convenção, mas na prática, qualquer número de porta serve, contanto que exista alguma coisa “escutando” nessa porta.




Nesse minuto de explicação eu simplifiquei bastante. Na faculdade você faria exercícios simples de escrever um programinha que escuta numa porta e outro que conecta nessa porta. É assim que começa a nascer a semente de um servidor web e de um navegador. Agora o que é o servidor Web mais simples de todos? Ele simplesmente lê um arquivo da máquina e serve esse arquivo. O endereço completo que você digita no navegador se chama URL ou Universal Resource Locator que é composto pelo protocolo, pelo domínio e pelo caminho de um arquivo, no caso mais simples. Então antigamente você veria endereços como esse http://sitedafaculdade.edu/~jose/arquivo.html 

E esse til jose, se você estudou Linux como eu disse no episódio anterior, vai saber que é um atalho pro diretório /home/jose. E é assim que você faz o servidor web mais simples de todos e, como hoje em dia sabemos, o mais bugado em termos de segurança porque se ele traduz direto da URL pra um caminho de arquivos no seu sistema operacional, sem nenhuma checagem, você poderia ficar tentando achar maneiras de vasculhar todos os arquivos do usuário, mesmo os que ele achou que não seriam servidos publicamente. E fazíamos isso mesmo antigamente pra achar brechas.



E quando o navegador, que é um exemplo de um programa que é cliente de TCP, recebe esse arquivo.html agora ele traduz as marcações pra elementos visuais. E como existe o elemento que chamamos de LINK que é o <a href=”http://….> onde “A” significa anchor ou âncora e href é hypertext reference, nasce o conceito de hipertexto onde um texto possui links pra outros textos. No começo ninguém estava interessado em visual, simplesmente em disponibilizar textos linkando com outros textos. E assim nasce a tal World Wide Web ou WWW. É um conceito que nasceria naturalmente dados esses elementos que eu mencionei até agora, era inevitável.



No próximo passo alguém pensou, e se em vez de digitar o nome de um arquivo eu digitar o nome de um programa executável? Um binário que é um programa, que no caso do Windows são aqueles arquivos que terminam o nome com .exe, tipo um Word.exe ou Excel.exe em vez de um hipertexto cujo nome termina com a extensão .html? 

Num navegador bem antigo não ia acontecer nada. Provavelmente poderia dar erro porque o servidor não saberia interpretar algo que não é texto. Mas aí alguém fez um dos primeiros servidores web reconhecer quando alguém pede um executável e em vez de só ler o arquivo e cuspir o conteúdo pro navegador, ele primeiro tenta rodar esse executável no servidor e cospe pro navegador o resultado dessa execução, que esperamos que seja um texto em HTML.



Ou seja, pro navegador não faz diferença se pedimos um executável ou um arquivo texto ao servidor, contanto que o que volte pra ele como resposta seja um conteúdo texto em HTML. E se considerarmos que pedir arquivos texto, que nunca mudam é algo estático, assim nasce a primeira geração de sites dinâmicos, ou seja, que dinamicamente podem mudar o resultado dependendo do que o executável faz. Isso começa com programas binários feitos em C mesmo, e o padrão foi nomeado como CGI ou Common Gateway Interface. Mas fazer C ficar cuspindo HTML é como usar um canhão pra matar uma mosca, mas felizmente havia outra linguagem mais simples em ambientes UNIX e Linux e melhor adaptada pra manipular cadeias de texto, ou strings, e foi assim que Perl se tornou a principal linguagem para fazer CGIs e foi assim que o mundo começou a conhecer mais sobre essa sub-linguagem que o Perl trazia chamada Regular Expressions ou REGEX pra manipular strings. Se você ainda não sabe o que é REGEX coloque na sua lista de coisas obrigatórias pra estudar.



E depois do surgimento de alguns servidores web como o da NCSA, ou da Netscape, dentre outros, um começou a despontar pela sua facilidade de uso e por ser open source, ou seja de código aberto, o famoso Apache, cujo nome eu sempre ouvi a história de que foi inspirado em “A Patch”, que traduz em português como “remendo” já que ele não deixa de ser um puxadinho de remendos de código que foram sendo adicionados, um patch de cada vez. Pra quem não sabe, você pode comparar duas versões do mesmo arquivo de código, um mais antigo e outro mais novo usando uma ferramenta de linha de comando que vem na maioria das distribuições Linux chamada “diff” pra tirar a “diferença” entre eles e colocar num arquivo de remendo ou “patch”, e usar outra ferramenta, a linha de comando “patch” pra aplicar essa diferença.



E falando em remendos de arquivos, uma das coisas mais irritantes da Web no começo dos anos 90 era que se eu quisesse fazer um site com 10 páginas e algum layout ou estilo visual, eu precisava copiar e colar o HTML inteiro de uma página pra outra, dez vezes e daí editar o conteúdo diferente entre cada uma. Se depois eu quisesse mudar o layout pra outro formato, eu precisava abrir as 10 páginas e mudar uma a uma. Originalmente a idéia não era que o HTML ditasse como o conteúdo seria visualmente estilizado, a idéia era que cada navegador estilizasse as páginas do jeito que quisesse. O motivo disso foi porque HTML foi inspirado em outras linguagens de marcação de conteúdo como SGML, voltados estruturar documentos governamentais que pudessem ser lidos por um computador. A função do HTML era marcar o que era um cabeçalho, um parágrafo, uma lista, e os perfis de impressão decidiam fonte, espaçamentos e tudo mais pra comportar esse conteúdo numa página de papel, e os navegadores é decidiriam como apresentar esse conteúdo num monitor, inclusive o usuário do navegador poderia customizar escolhendo que não queria o padrão de fontes Times New Roman e sim Arial e todas as páginas mostrariam Arial. Por isso se você viu exemplos de páginas do começo da web, ela eram todas bem sem sal, com fundo cinza, fontes pretas e links azuis, tudo meio igual.



Você já podia embutir um jeito rudimentar de forçar o controle de estilo direto no HTML com o atributo chamado style, mas foi com CSS que separamos o estilo do conteúdo e ganhamos mais controle sobre como o navegador pinta o visual na tela, coisas como escolher fontes, tamanhos, espaçamentos, alinhamentos, e muito mais. Isso foi no começo dos anos 90, até lá por 95 ou 96 quando CSS apareceu pela primeira vez. Nessa época você já tinha Netscape superando o antigo Mosaic, mas o Internet Explorer sairia na frente porque implementava melhor o primeiro CSS, ao contrário da Netscape. Foi quando surgiram páginas de teste como o famoso ACID pra checar a compatibilidade de CSS entre navegadores. Tem uma página com a história completa da novela em cima do CSS que estou deixando nos links na descrição abaixo. 



Essa briga deu início à Guerra dos Navegadores, as ferozes batalhas entre a Microsoft e a Netscape pela hegemonia da Web com cada versão de um navegador tentando ser melhor, principalmente em termos visuais e de interatividade do que o anterior. Recomendo muito que você procure pelo documentário da Discovery, The True Story of the Internet onde o primeiro episódio narra em mais detalhes como foi essa guerra. Eu falei sobre isso num dos primeiros episódios desse canal quando dei dicas de séries e filmes pra programadores.



No fim dos anos 90, a Netscape estava perdendo a guerra e resolveu mudar seu modelo de negócio que envolvia vender o navegador, e abriu seu código fonte, criando a fundação Mozilla. O Opera apareceu também mostrando como redimensionar conteúdo pros dispositivos móveis da época como os Palms, Pocket PC e os primeiros dumb-fones de marcas famosas na época como Nokia ou Siemens, a primeira geração de pseudo-“smartphones” vamos assim dizer, isso antes ainda do surgimento da Blackberry e foi quando vimos o primeiro uso de media types, que evoluiriam pra media queries e viriam a se tornar oficiais só no CSS3 em 2012, mas os primeiros rascunhos datam desde pelo menos 1997. Se você não sabe o que são media types, lembre-se que layout de conteúdo era mais especializado para impressão em papel, pra editorar revistas, jornais ou livros. E tínhamos agora que adaptar para monitores de computador, mas além disso ainda havia outras formas de mostrar conteúdo. Imagine dispositivos tácteis como braille para cegos ou que geram som para surdos. Cada um deles é um “tipo de mídia” ou media types. E o Opera começou a popularizar o uso do atributo @media que evoluiria para as media queries que usamos hoje onde o CSS pergunta ao navegador que tipo de mídia estamos lidando, se é uma tela de celular, tela de tablet ou tela de computador.



Com o boom do Internet Explorer foi quando a Microsoft começou a embutir o máximo possível da Web no Windows, e com o Windows 98 vimos pela primeira vez a integração dessas tecnologias direto no sistema operacional, como a utilização de MIME-types, uma tecnologia que surgiu primeiro em e-mails para possibilitar embutir arquivos binários em e-mails que eram somente texto puro. MIME que significa Multipurpose Internet Email Extensions e que você conhece como pares que determinam o tipo de arquivo como text/html ou image/png ou video/mpeg. É uma forma mais avançada do que no Windows são as extensões de arquivo como .html ou .png ou .mpg.



O File Explorer foi mesclado ao Internet Explorer que possibilitava explorar os arquivos da máquina ou explorar os arquivos na Web. Hoje em dia todos os navegadores de arquivos usam MIME types. E isso foi um dos estopins para caracterizar prática monopolista da Microsoft em forçar as pessoas a usar Internet Explorer. A comissão européia na época forçou a Microsoft a deixar os fabricantes de computador escolher se deixariam pré-instalado o Netscape ou Opera. Mas o argumento da Microsoft era que era impossível separar o Internet Explorer do Windows porque ele era parte fundamental de como você navegava no sistema. Foi uma controvérsia enorme na época do Windows 98.




Voltando ao assunto dos servidores web, quando servidores como Apache se tornaram capazes de coisas como executar um script que manipulava o HTML antes de mandar para os navegadores eu poderia escrever o HTML do layout como se fosse um template, um modelo, e fazer só o conteúdo diferente daquelas 10 páginas separadas, e se precisasse mudar o layout, bastava mudar nesse template e todas as 10 automaticamente seriam modificadas.



Com esse conceito começamos a evoluir o mundo de escrever páginas de texto com hiperlink pra algo mais dinâmico e visualmente mais agradável do que textos em fontes Times New Roman ou Courier New com fundo cinza. A diferenciação passou a ser a customização gráfica e de design dos sites e começava a nascer a profissão de web designers que começou com designers gráficos de revista tentando entender como traduzir a linguagem visual de revistas e livros no formato digital da Web. A gente via muito design muito bizarro nessa época, eu diria que foi a época da esplendor exuberante barroco do design Web.



E não é só isso, dado que linguagens no servidor, seja em C ou Perl poderiam ter acesso a recursos como bancos de dados, de repente uma nova possibilidade se abre: aplicações Web em vez de só sites Web. E se eu pudesse fazer um formulário onde o usuário pudesse digitar seu cartão de crédito e enviar para esse script Perl no servidor e gravar no banco de dados? É como se inicia a semente para coisas como e-commerces. A Microsoft novamente não deixou passar a oportunidade e criou seu próprio servidor web, o IIS ou Internet Information Services que adicionou tecnologias proprietárias como o Frontpage Server Extensions que, junto com o programa Frontpage, permitir criar páginas dinâmicas, com validações complicadas de formulário, de maneira simples. Porém páginas feitas com essas extensões só podiam rodar em IIS e serem interpretados por Internet Explorer, aumentando ainda mais a pressão em cima de Apache ou Netscape. Você encontra resquícios disso em produtos atuais da Microsoft como o servidor Sharepoint.



Em paralelo ao Perl e os CGIs, nasceu outra forma de criar páginas dinâmicas com extensões embutidas diretamente dentro do núcleo do Apache, e seu principal proponente foi o PHP. Agora, em vez do servidor web chamar um programa externo pra gerar os HTMLs, o próprio servidor web ganhou a capacidade de interpretar lógica de programação pra cuspir HTML. A Microsoft seguiu lado a lado adicionando em 1996 a extensão de ASP no IIS. E então nasceu a guerra server-side entre PHP e ASP pela hegemonia do mundo servidor. Na sequência ainda ganhamos aberrações como Coldfusion, representando o pico do mau uso do então inovador XML não só como forma de representar dados em formato de tags, mas usar tags como linguagem de programação, inspirado pelo famigerado JSP no mundo J2EE.



Isso coincidiu com a evolução do Java no lado do servidor, e outra categoria de servidores Web, os application servers ou servidores de aplicação. Entenda que um servidor de aplicação é um servidor web, mas nem todo servidor Web como Apache ou NGINX de hoje é um servidor de aplicação. Servidores Web tem como principal função servir páginas HTML e servidores de aplicação tem como principal função executar programas que cospem HTML. Essa época também coincidiu com a abertura inicial de capital ou IPOs da Netscape e Yahoo que marcam o início da famosa Bolha da Internet do meio pro fim dos anos 90. Com a entrada de programadores mais experientes do que meros designers fazendo HTML, tecnologias que permitiam o tráfego de informações seguras como o SSL da Netscape, nasceram as primeiras aplicações Web como content management systems ou CMS como o histórico FileNet, o monstruoso Vignette que todo portal de conteúdo usava, versões open source como PHP Nuke, Mambo que viriam a inspirar a próxima geração como Drupal, Joomla, ou Zope em Python, que daria origem ao Plone, e finalmente o nascimento do Wordpress no começo dos anos 2000 que ajudaria a iniciar a era dos blogs.



Uma vez que começou a ficar claro que era possível programar aplicações interativas, controlar o visual se tornou mais e mais importante. A evolução do CSS1 pro CSS2 que inaugurou também a época das Web Fonts, e moveu os layouts ou estruturas de páginas de usar tabelas e células para a era Tableless e design fluido também viu o nascimento de outras 2 tecnologias fundamentais para a Web de hoje: Dynamic HTML ou DHTML com o HTML versão 4 e uma tecnologia inaugurada pela Mozilla na forma de Asynchronous Javascript ou AJAX. E seu principal garoto propaganda, o GMAIL que começou a ser desenvolvido em 2001 e foi lançado só no dia primeiro de abril de 2004, também inaugurando a era dos memes do dia da mentira.



O GMAIL foi a personificação de tudo que Bill Gates temia nos anos 90: que os navegadores Web se tornassem substitutos dos sistemas operacionais, no caso do Windows, na função de executar programas. Ele previu corretamente que sem padrões proprietários você não teria como segurar os usuários no Windows, porque eles poderiam rodar o mesmo programa num navegador como Netscape em qualquer sistema como MacOS ou distribuições Linux. O GMAIL foi provavelmente a primeira aplicação Web que substitui com sucesso um dos programas nativos mais importantes num sistema operacional: o cliente de e-mails como o Outlook da Microsoft. E isso ameaçava tudo, incluindo o monopólio sobre programas como o Office.



Neste ponto da história, estamos entrando em 2004. Em termos de tecnologias de front-end avançamos o HTML até a versão 4 que comporta coisas como Dynamic HTML e AJAX. Derivado do SGML tivemos o HTML mas também surgiria o XML para estruturar qualquer tipo de dados e como uma estrutura mais geral onde HTML, ou mais especificamente, XHTML seria um caso especial. HTML é especializado em estruturar conteúdo de texto. XML é especializado em estruturar dados, como cadastros. CSS versão 2.1 é o cascading style sheet, que passou a suportar web fonts, internacionalização, posicionamento relativo e absoluto que permite que os elementos na tela de ajustem dinamicamente de acordo com o tamanho total da tela, ao contrário do que fazíamos no meio dos anos 90 onde considerávamos um comprimento fixo de tela pra encaixar os elementos, especialmente dentro de tabelas e usando muito recorte de imagens porque CSS não era poderoso o suficiente para alguns designs gráficos. Além disso, é importante entender que CSS é uma linguagem declarativa, onde declaramos regras visuais que são aplicadas no HTML e essas regras são cascateadas onde uma regra herda as características da regra pai, numa hierarquia de regras. Aliás, tenham sempre em mente a estrutura de uma árvore ou hierarquia. Quase tudo na Web é baseado nessa estrutura. HTML são árvores de elementos. CSS são árvores de atributos de estilo. Sites são árvores de páginas uma linkando na outra. E agora que evoluímos de simples sites de conteúdo hipertexto, pra gerenciadores de conteúdo CMS, pra e-commerces e com o início da era de aplicativos Web como Gmail e redes sociais como Orkut, MySpace e Friendster, abriu-se uma nova fase de desenvolvimento.



Em paralelo, na era Java do começo dos anos 2000 popularizou-se o conceito de Frameworks, que mais do que linguagens fornecem uma estrutura pré-definida para ajudar a desenvolver aplicativos, fornecendo coisas como segurança, validação de dados, autenticação e autorização granular, templates visuais, e que determinavam meio que um “guia” de lugares onde você deveria colocar cada tipo diferente de código. Antes disso cada aplicativo como Joomla ou Drupal fazia tudo do zero. No mundo PHP começaram a surgir frameworks inspirados em J2EE ou Struts, como o Zend Framework. E finalmente abrimos a era do Ruby on Rails pro fim de 2004 e o agora lendário demo do blog em 15 minutos que David Hansson gravou no evento FISL de 2005 no Brasil, inaurando a era dos frameworks que herdam os conceitos de Agilidade inaugurado pelo Manifesto Ágil de 2001.



Por causa de Ruby on Rails começou a surgir a primeira geração de sub-frameworks Javascript e CSS. Até então escrever HTML ou CSS ou mesmo Javascript era algo trabalhoso, que não funcionava exatamente da mesma forma em todos os navegadores. Lembrando que estamos na época do famigerado Internet Explorer 6 do também famigerado Windows XP e do Netscape 7. Com isso em mente, alguém pensou: porque não unificar essas coisas? Por que não fazer um framework via Javascript pra homogeneizar e evitar que o programador tenha que fazer código específico para Internet Explorer ou Netscape? Daí surge a primeira geração de micro-frameworks especializados em visual do lado do navegador como Mootools, Dojo, o próprio JQuery, e os que o Ruby on Rails tornou popular na época, no caso o Prototype e o Scriptaculous. Scriptaculous que popularizou novas formas de elementos de interação como drag and drop de elementos no HTML, onde podíamos arrastar as coisas como podemos arrastar e-mails no inbox do GMAIL.




Pouco tempo depois, em 2007 surge uma nova revolução na área de design visual e usabilidade. Vemos o nascimento dos smartphones a partir do primeiro iPhone lançado em julho de 2007. Com ele temos o navegador Safari, que é uma evolução do navegador chamado Konqueror do KDE no Linux, que usava o núcleo KHTML que viria a se tornar o que conhecemos hoje como WebKit. Só que telas de celular tinham resolução muito menor do que um desktop. Em 2007 o mais comum eram monitores com resolução de 1024 pixels por 768, mas o iPhone tinha meros 320 por 480 pixels.



Uma coisa que se tornou popular nos anos 90 e que eu não falei ainda, foi uma forma de simplesmente não usar nada de HTML nem CSS nem Javascript. Pra tentar tomar a dianteira, empresas como a Microsoft não fizeram só componentes proprietários pro servidor como o Frontpage Server Extensions ou ASP. A Sun criou o Java e queria dar um jeito de colocar Java em tudo. O Java servia pra muitas coisas incluindo fazer aplicativos pra Desktop, como os malditos aplicativos de Imposto de Renda que você usa até hoje. Mas eles queriam dar um jeito de colocar Java nos navegadores, mas sendo uma linguagem geral ela virar um problema de segurança se de repente você rodasse Java no navegador e ele pudesse acessar seus arquivos. Por isso criou-se o conceito de sandboxing, um container que permite executar código Java com baixos privilégios ou seja, sem privilégios pra acessar arquivos ou a própria rede, ele devia rodar dentro desse container e assim nascem os aplets. 



Quem dessa época não lembra do famigerado applet de demonstração que mostrava água se mexendo num tipo de animação que era impossível de fazer só com CSS ou mesmo com GIF animado. E seguindo nessa tendência a Microsoft criou o padrão ActiveX que era o mesmo que applets mas em vez de usar Java você programava em C++ ou mesmo Visual Basic 6. Felizmente Applets Java e ActiveX já não existem mais, mas a Macromedia também fez seu sandbox na forma do famigerado plugin Flash que trazia tecnologias realmente legais pra época como ilustrações vetoriais com curvas de Bezier que já era usado em programas como CorelDraw ou Adobe Illustrator para conseguir embutir ilustrações de melhor qualidade e tamanho muito menor do que imagens bitmap como JPEG ou GIF. E mais do que isso, adicionar o conceito de linha do tempo para animar essas ilustrações. Adicionando uma linguagem bem tosca e simples chamada ActionScript e você podia fazer coisas interativas como joguinhos. Todo mundo jogou alguma coisa em Flash no começo dos anos 2000.



Em 2019 o processador de um iPhone, o famoso A12 Bionic nos novos iPhone XS é quase tão potente quanto um processador Intel Core em um Macbook Pro. Um processador em um iPhone original de 2007 era um processador ARM11 de meros 412Mhz e tinha só meros 128 MEGAbytes de RAM. E a bateria tinha não mais que 1400 miliamperes, hoje celulares tem até 4000 miliamperes. Entre pouco processamento e pouca bateria, sem teclado, sem mouse, só com touch, rodar Flash era um exercício de futilidade. Os primeiros Androids queriam se destacar deixando rodar Flash mas rapidamente foi provado que isso só deixava celulares Android extremamente lentos e a bateria acabava num piscar de olhos. Flash já não tinha boa reputação por causa do tanto de bugs e principalmente buracos graves de segurança em sua programação porca. A gente dava um jeito de aguentar com CPUs mais potentes e muita RAM em desktops, mas em smartphones não tinha pra onde correr. A Apple se recusou a rodar Flash e não só isso demonizou o Flash publicamente na famosa carta aberta de Steve Jobs que selou o destino do fim do Flash.



Só que a partir de 2005 a única forma decente de ver videos do YouTube ou outros sites era via o plugin de Flash ou via o plugin de Silverlight que era tipo uma evolução do ActiveX da Microsoft, mas também não durou muito. Sem esses plugins não havia video. A Apple ajudou a evoluir o HTML para suportar playback de vídeo acelerado por hardware, e popularizou o envelope MP4 de vídeo com compressão H.264 e com isso nascia novas tags de vídeo pra HTML. Somado ao fim do Flash também aumentou a pressão por adicionar funcionalidades de animação também acelerado pela nova classe de GPUs e assim surgem coisas como o atual canvas controlado por CSS e WebGL. 



A revolução dos smartphones, a queda da Sun que foi adquirida pela Oracle pondo também um ponto final em applets, as ingerências da Microsoft pós julgamento anti-truste nos anos 2000 desacelerando os desenvolvimentos do Internet Explorer e tecnologias como Silverlight. Tudo isso forçou a W3C e seu consórcio de empresas a acelerar uma coisa que já estava muitos anos atrasado: a evolução pro HTML5 e CSS3 que só aconteceu em 2014 onde alguns anos antes disso todos os navegadores, começando com o surgimento do Google Chrome em 2008 começaram a implementar uma funcionalidade de cada vez.



Ficamos de 2008 a 2015 num período muito chato de transição. Tínhamos que desenvolver Web em meio a HTML, CSS, Javascript estando no meio do caminho e mudando o tempo todo em cada nova versão de cada navegador. Era impossível fazer um site que funcionasse em todos os navegadores e em todos os dispositivos ao mesmo tempo com os padrões ainda não oficializados e cada navegador implementando partes da especificação. E por conta disso surgiram meta-linguagens pra nos blindar essa bagunça. Foi quando JQuery deixou de ser opcional e passou a ser uma necessidade pra lidar com Javascript e CSS. Com o fim do Flash, Javascript voltou a ser a única alternativa viável pra animação e interação, uma linguagem extremamente ruim que não via uma evolução significativa desde o começo dos anos 2000. Então começou a surgir uma gambiarra na forma de transpilers, linguagens que não são compiladas em instruções nativa de uma máquina real ou uma máquina virtual, mas que traduzem de uma linguagem para outra linguagem.



Novamente, o mundo Ruby on Rails veio tentar ajudar. O rubista Hamptom Caitlin escreveu o SASS ou Syntathically Awesome Stylesheets, usando Ruby. SASS é tipo um dialeto de CSS que permite estruturar melhor o CSS, dando funcionalidade de reusar código, e esconder detalhes específicos de navegadores. O Twitter resolveu criar sua própria versão e daí surgiu o LESS. SASS e LESS ficaram concorrendo por anos mas SASS é superior hoje em dia.



Também do mundo Ruby, em 2009 Jeremy Ashkenas escreveu um compilador em Ruby chamado Coffeescript. Uma nova linguagem cujo resultado da compilação era Javascript. Ele adicionou dezenas de conceitos de linguagens como Ruby e Python para criar uma nova linguagem muito mais agradável de trabalhar e que geraria a porcaria do Javascript por baixo. Isso ajudou muito a evitar termos que usar algo como JQuery ou ficar nós mesmos nos preocupando em adicionar código específico pra cada navegador. Hoje em dia todo mundo demoniza Coffeescript porque a sintaxe dele é um pouco agressivo e pouco ortodoxo, mas foi dele que saíram diversos conceitos como interpolação de strings, melhor controle sobre enumerators e iteradores, a agora famosa sintaxe de fat arrow pra funções anônimas e muito mais que foi incorporado ao Javascript versão ES6 que só foi sair em 2015, tornando o Coffescript obsoleto.



Mais do que só matar o Flash, o surgimento de smartphones com telas verticais e resoluções diferentes de um monitor de computador, também surgiu a necessidade de criar estilos que se adequassem automaticamente ao formato da tela e com o movimento de tableless, ou seja, parar de usar tabelas pra estruturar layout em HTML, e a consolidação de elementos flutuantes com espaçamento relativo do CSS2 transicionamos pro tal design responsivo que tanto se fala em hoje em dia. Layouts que automaticamente se adequam ao dispositivo e com o advento da interação via touch uma nova classe de pesquisa foi iniciada, o que hoje chamamos de UX ou usabilidade. Pense que até então o normal eram teclado e mouse, como criar telas interativas que só usam o dedo? Hoje em dia isso é um problema resolvido, mas principalmente entre 2009 e 2015 isso foi assunto de muita discussão.



E como o primeiro smartphone de verdade do mundo foi o iPhone da Apple, além das tecnologias ela trouxe outra coisa do seu DNA: seu estilo de design e linguagem de usabilidade. Se o fim dos anos 90 foi a época barroca do design Web, a Apple trouxe a linguagem de Bauhaus: o que hoje chamamos de design minimalista, que valoriza os espaços em branco entre elementos, linhas simples sem o escândalo de cores bregas e tudo desalinhado que se via em páginas de redes sociais como MySpace. E em cima dessa linguagem as empresas pararam de reinventar a roda em cada site e passaram a criar bibliotecas de estilo reusáveis e daí nascem os frameworks de CSS, escritos nas linguagens SASS e LESS que falei acima. O mais famoso deles sendo o Twitter Bootstrap. Por isso muitos sites parecem que foram feitos pelo mesmo designer, porque todo mundo usa o Bootstrap em vez de partir do zero e ficar reinventando a roda redesenhando o visual de botões e outros elementos. Daí criamos elementos novos com o hamburguinho pra menus, os Jumbotrons e Scrollspy que toda landing page usa.



Com tantos novos elementos de Javascript e CSS surgiu outra necessidade. Agora não era mais só escrever um arquivo de CSS, linkar no HTML e pronto. Passamos a reusar dezenas de bibliotecas como um JQuery da vida, código pra Google Analytics, frameworks de CSS gigantes, enfim muitos e muitos assets. Primeiro, precisávamos dar um jeito de baixar todos esses assets e bibliotecas nos nossos projetos sem ficar indo de site em site, clicando no link de download e descomprimindo zips manualmente nos diretórios. No mundo Perl já tinhamos coisas como o CPAN que permitia baixar bibliotecas de um servidor central. No mundo Ruby, depois de várias tentativas finalmente consolidamos no Bundler pra não só baixar as bibliotecas mas gerenciar corretamente as versões corretas que nossos projetos precisariam. E no mundo Javascript as coisas começaram meio devagar com o advento do NPM que só ficaria realmente usável quando concorrentes como YARN tentaram tomar seu lugar. Mas no mundo Javascript o NPM pelo menos se tornou o padrão de fato para gerenciar os assets no lado da máquina do desenvolvedor.



Mas só isso não é suficiente. Como eu expliquei no começo do episódio, um servidor web cospe HTML e todos esses assets pro navegador. E como agora colocarmos dezenas deles nos nossos projetos você devia imaginar que quanto mais arquivos e quanto maior eles forem, mais lento vai ser pro navegador baixar e renderizar tudo. E isso se tornou ainda mais óbvio nos primeiros smartphones. Hoje em dia temos alta velocidade em conexões 4G e já estamos próximos de ir pra 5G, mas em 2009 o normal ainda era 2G e poucos com 3G. Como otimizar esses assets pra ficarem menor? Alguém parou pra pensar: esses assets de Javascript e CSS são tudo texto. Nós programadores sabemos fazer texto ficar menor. Por exemplo, nós escrevemos código com tabulação, espaços, usamos nomes grandes e descritivos pra ficar mais fácil outro programador conseguir editar esse código. Mas um navegador não se importa com espaços em branco ou nomes descritivos, computadores sabem ler dados sem formatação. E espaços em branco ou nomes grandes ocupam espaço desnecessário. Mais do que isso, quanto mais arquivos separados tivermos, mas lento vai ser. Então porque não juntar vários arquivos num único arquivo e porque não filtrarmos e tirarmos fora espaços em branco e reduzir nomes de variáveis e funções ao menor tamanho possível, dentre outros truques? Esse é o conceito que chamamos de minificação, minificar textos humanamente legíveis em textos menores horrorosos mas que navegadores conseguem ler. E com tantas atividades agora pra chegar nos arquivos de HTML, CSS e Javascript finais otimizados, temos que transpilar de SASS pra CSS, de Coffeescript ou ES6 pra Javascript ES5 que na época era mais usado. É o que chamamos de um canos de processamento de assets ou Asset Pipeline como chamamos no Ruby on Rails onde o conceito nasceu. E no mundo Javascript surgiram coisas similares como Grunt, Gulp e hoje em dia Webpacker somado a ferramentas como Babel que fazem exatamente esse tipo de coisa. Por causa disso, todo novo framework que se preza tem algum tipo de integração com coisas como Webpacker pra ter esse pipeline de processamento. Isso ficou um pouco menos necessário desde que evoluímos pro padrão HTTP/2, mas isso é assunto pra outro dia.




Evoluindo em cima da herança do GMAIL, só AJAX não era mais suficiente e passamos a experimentar em tirar lógica dos servidores de aplicação e transferir o controle do estado da aplicação pra mais próximo da tela gráfica, e assim surgem os frameworks Javascript. Em vez de ficar controlando cada elemento da tela individualmente via Javascript e ficar controlando os estilos globais com CSS, por que organizar uma tela de uma aplicação direto só em seus menores elementos? Por exemplo, num Spotify em vez de falarmos em botões ou listas, podemos separar em coisas maiores como Playlist, Menu de Usuário, dashboard de playback, lista de resultados de pesquisa de música. São todos grandes “componentes” que interagem entre si. E cada um deles tem uma representação gráfica que depende de um estado. Por exemplo, no dashboard de playback, temos estados como tocando, pausado, shuffle ativado ou Não. E pra criar esses componentes e gerenciar os estados no lado do cliente, aproveitando tecnologias do HTML5 como web storage que permite guardar esse estado no navegador, surgem frameworks como Ember, Angular, React + Redux ou Vue.js. E assim também surge o conceito de uma única página que carrega toda essa aplicação que é composta de javascript e assets como CSS e imagens, sem precisar mudar de página pra atualizar entre cada estado. Pra fazer isso usamos Ajax por baixo e rodamos tudo numa única página e por isso temos o conceito que vocês já devem ter ouvido de SPAs ou Single Page Apps.



Isso aconteceu a partir do nascimento de aplicações mais complexas em interação e estado como o próprio Google Docs, Slack, Spotify e outros. E é por isso que hoje você tem esses frameworks. Na época que a Apple estava na dianteira desse tipo de aplicativos por conta do iCloud ela tinha um framework próprio chamado Sproutcore. Dali veio a semente que viria a se tornar Ember, que também saiu da comunidade Ruby on Rails e por isso Ember se parece um pouco em estrutura com o Rails. O Google tinha o antigo GWT que foi muito usado no mundo Java pra fazer aplicativos parecidos com o Gmail, mas depois criou o Angular e depois o Polymer que não deu muito certo em adoção. E com o crescimento do Facebook e necessidade de criar aplicativos como o Facebook Messenger, surgiu o React que torna mais veloz o desenho de partes da tela cujo estado foi modificado com seu Virtual DOM. Ou seja, em vez de ficarmos redesenhando explicitamente um elemento na tela, tipo mudar a cor de um botão pra vermelho, só mudamos o estado do botão e deixamos esse Virtual DOM redesenhar o que precisar na tela, de forma que podemos evitar redesenhar o que não se precisa e ao mesmo tempo otimizar a velocidade total do redesenho. E na tentativa de fazer concorrência e evoluir em cima da experiência do Angular e React, no mundo open source surgiu o Vue.js que começou a ganhar algum momento graças à sua inclusão como padrão no framework Laravel no mundo PHP.



E nos dias de hoje, com a evolução do Javascript ES6, a dominância do Chrome como navegador mais usado e a decadência do Internet Explorer, e também o surgimento de processadores multi-core mais rápidos e mais eficientes nos smartphones, com RAM mais barata que permite que desktops e dispositivos consigam ter 6GB ou 8GB ou mais de RAM, começou a surgir uma nova classe de aplicativos: os híbridos. Aplicativos de desktop ou de mobile que tecnicamente tem uma estrutura nativa que liga com o hardware como camera, touch, audio e muito mais mas são controlados por uma fina camada de Javascript e outras tecnologias Web como HTML5 e CSS3. Então podemos usar a mesma estrutura que descrevi acima pra fazer aplicativos desktop ou mobile como é o caso de coisas que usamos todo dia como o próprio Spotify ou Slack ou editores de código como Atom ou Visual Studio Code. E assim surgem também frameworks híbridos como o Electron que é uma forma de encapsular tecnologias do Chrome e abrir como se fosse um aplicativo nativo ou então React Native que torna possível você desenvolver um aplicativo simples pra iOS ou Android como se estivesse desenvolvendo um site web em React.



Caraca!! Eu sei que eu pincelei bem por cima de dezenas de assuntos e mais de 25 anos de história. Já disse em outros episódios que eu sinto que nasci na hora certa porque eu pude ver cada evento que eu narrei aqui acontecendo em tempo real. Isso me ajudou muito porque eu pude ir aprendendo cada nova tecnologia à medida que elas foram aparecendo. Algumas delas morreram já, como ASP clássico, Flash, Silverlight, Active X, Applets Java, Coffeescript, GWT, e ao mesmo tempo muitas novidades apareceram na forma dos atuais padrões HTML 5, CSS 3 e Javascript ES6 e as ferramentas por cima delas como React, SASS e assim por diante. Mas eu espero que ao ouvir sobre essa linha do tempo você consiga ter uma noção melhor de onde cada coisa se encaixa. E eu recomendo que você assista este episódio mais vezes, não agora, mas de tempos em tempos pra ver se o que eu estou falando vai fazendo mais sentido à medida que você vai estudando e treinando.



Sempre que tiver dúvidas sobre uma tecnologia comece do começo: pesquise sua história. A história vai te dizer, porque essa tecnologia existe? Que problemas ela foi desenhada pra resolver? Ela ainda resolve esse problema da melhor forma ou já surgiram substitutos? Ainda vale a pena aprender ou já tem coisa melhor na frente? Por onde anda o autor original da tecnologia? Ou a empresa que patrocinou essa tecnologia? São perguntas como essas que vão te dar o norte sobre o que estudar e como estudar.



Se eu fiz meu trabalho direito, você começou este episódio com dúvidas sobre o que estudar. E deve ter terminado este episódio com mais dúvidas ainda! E esse é o objetivo. Se você tem poucas perguntas, não está se esforçando o suficiente. Faça a pergunta errada e vai receber a resposta errada. Reveja seus conceitos, veja a lista de coisas que tem pra estudar, coloque na linha do tempo, veja quais problemas você vai resolver com quais ferramentas. Encontre problemas pra resolver e vá aprendendo dessa forma: na tentativa e erro. Quais problemas? Eu não disse no episódio anterior que você precisa aprender a fuçar os projetos open source que estão no Github? É por ali mesmo, você vai achar o tal clone do Instagram que alguém fez. Ele vai estar feito em Angular, que eu falei aqui. Você já entendeu pra que ele serve, procure um tutorial online sobre Angular. Daí vai ver que tem arquivos com extensão .scss que é SASS e agora você sabe o que é SASS e que deve ter algum pipeline, como Webpacker, então procure um tutorial de SASS e outro tutorial de Webpacker. E quando for rodar, você já sabe pelo menos em conceito a diferença de um servidor web e um servidor de aplicações, e se levou a sério meu episódio anterior você está estudando distribuições Linux, agora procure um tutorial de como instalar, configurar e subir um NGINX por exemplo. 



Cada um desses assuntos não é pra levar anos pra aprender. Se você for devagar, gaste 1 mês em cada item. Aprenda os 20% que eu vivo falando. E aprenda treinando. Teoria e prática. A parte avançada vai aparecendo à medida que você realmente coloca a mão no código e faz rodar na sua máquina. Qualquer coisa antes disso é perda de tempo. E apesar de eu não gostar de recomendar diretamente sites de tutoriais ou cursos, vou deixar linkado alguns que conhecidos meus recomendaram, então não deixe de ver esses links na descrição do vídeo abaixo.



E por hoje é isso aí, o objetivo de hoje foi colocar as tecnologias de front-end dentro da história. Semana que vem quero tentar fazer a mesma coisa com tecnologias back-end e na seguinte finalmente um pouco sobre devops. Eu sei que vocês ficaram com dúvidas, e eu mesmo não sou o melhor programador de front-end, então mandem suas dúvidas nos comentários abaixo pra todo mundo poder ajudar a responder. Se curtiram mandem um joinha, compartilhem com seus amigos, assinem o canal e cliquem no sininho pra não perder os próximos episódios. A gente se vê, até mais pessoal!



Este episódio vai testar a paciência de vocês. Desta vez quero explorar um pouco os diversos assuntos que são associados com a tal carreira de "Front-End" no mundo de desenvolvimento Web.

Se já começaram a estudar o assunto devem ter visto que existe uma infinidade de sopas de letrinhas, coisas como SASS, CSS, React, Vue, e muito mais. Por que existem tantas letrinhas assim? Quais escolher?



