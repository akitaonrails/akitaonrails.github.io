---
title: "[Akitando] #136 - Python? Java? Rust? Qual a Diferença? | Discutindo Linguagens"
date: '2023-01-18T08:00:00-03:00'
slug: akitando-136-python-java-rust-qual-a-diferenca-discutindo-linguagens
tags:
- python
- javascript
- java
- erlang
- elixir
- golang
- rust
- csharp
- php
- ruby
- apache
- cassandra
- kafka
- akitando
draft: false
---

{{< youtube id="MI9cdxETA4c" >}}

Finalmente vou falar sobre linguagens que você goste ou use, mas vou fazer isso do meu jeito: escovando bits e explicando como muita coisa funciona por baixo de Python, Javascript e outras linguagens que talvez você não sabia antes de concluir na segunda metade onde discuto onde cada linguagem pode ser melhor aproveitada e porque.

## Capítulos

* 00:00 - Intro
* 01:36 - Cap 1 - Perl e Regex | Anos 90
* 06:18 - Cap 2 - Estilo C e ICU | strftime
* 10:25 - Cap 3 - Tudo de Python é em C! | Linguagem "Grude"
* 17:54 - Cap 4 - Tudo de Node.js é em C! | LibUV
* 22:31 - Cap 5 - Compilado vs Interpretado | ABI de C
* 28:21 - Cap 6 - Interoperabilidade: Marshalling/Unmarshalling | FFI
* 36:21 - Cap 7 - Onde cada Linguagem é mais Forte? | Rust
* 38:09 - Cap 8 - Sistemas Distribuídos | Apache Java
* 42:41 - Cap 9 - Produtividade &gt; Performance? | Apps Comerciais
* 48:31 - Bloopers


## Links

* https://github.com/python/cpython/search?p=2&q=ifdef+MS_WINDOWS
* https://github.com/python/cpython/blob/a87c46eab3c306b1c5b8a072b7b30ac2c50651c0/Modules/_ssl.c
* https://github.com/pandas-dev/pandas/blob/main/requirements-dev.txt
* https://github.com/numpy/numpy/wiki/Building-with-MSVC
* https://github.com/scipy/scipy
* https://github.com/jupyter/notebook
* https://github.com/openjdk/jdk/search?l=c%2B%2B&p=99
* https://github.com/libuv/libuv
* https://github.com/tensorflow/tensorflow
* https://github.com/tensorflow/tfjs
* https://github.com/pytorch/pytorch
* https://github.com/nodejs/node/search?q=libuv
* https://www.npmjs.com/package/async-await-retry
* https://stackoverflow.com/questions/11996988/how-good-is-oniguruma-compared-to-other-cross-platform-regexp-libraries
* https://www.baeldung.com/jni
* https://www.elastic.co/blog/found-zookeeper-king-of-coordination
* https://github.com/akitaonrails/ObjC_Rubyfication
* https://zaiste.net/posts/shell-commands-rust/#

## SCRIPT

Olá pessoal, Fabio Akita

Hoje é dia de fazer um episódio que vinha postergando faz anos: falar sobre as principais linguagens de programação em uso no momento. Quem acompanha o canal sabe que evito ao máximo mostrar código dessa ou daquela linguagem, de vez em quando mostro uns trechos de javascript porque sei que a maioria sabe um pouco pelo menos, e em muitos casos uso pseudo-código que não existe quando o foco é o conceito.







Eu tenho algumas linguagens favoritas, obviamente Ruby, um pouco de Elixir, Crystal, todas linguagens meio parecidas em sintaxe, embora  diferentes por baixo, e mesmo assim  acho que nunca mostrei código delas em nenhum video. Mas hoje quero compartilhar algumas curiosidades técnicas e opiniões pessoais que muitos assistindo provavelmente nunca pararam pra pensar. A intenção não é fazer prós e contras, falar bem ou mau de qualquer linguagem. A idéia é fazer você enxergar sua linguagem favorita com outros olhos.






(...)





Já vou avisar: meu objetivo não é dizer que linguagem X é melhor que linguagem Y nem nada disso. Então os macacos de auditório de torcida organizada podem se retirar. Programação não é pra isso e código não liga pra sua "lealdade" a essa ou aquela tecnologia. Na verdade tecnologia e inovação recompensam a deslealdade. Quem conhece mais tecnologias diferentes sempre vai ser melhor e na verdade esse video é pra mostrar isso. Iniciantes vão ter seus níveis de ansiedade indo pras alturas porque vou mostrar um monte de coisas que nunca viram. Não se aflijam, anotem os termos que não conhecem, estudem, depois voltem pra assistir de novo.









A primeira coisa que quero levantar é o seguinte: Python. Nos últimos anos aumentou rápido de popularidade, principalmente por causa de projetos como Jupyter Notebooks, Pandas, Tensorflow, PyTorch e outros projetos relacionados a data science e machine learning. Se você se interessa por essas duas áreas, acho que é seguro dizer que maioria dos cursos e artigos a respeito vai usar uma ferramenta feita em Python. Por isso parece que Python é a linguagem que se deve aprender, certo?







Não está errado e não me entenda mau: apesar de não ser minha linguagem favorita, não tenho nenhum problema com Python. O que quero demonstrar hoje é mais dar uma perspectiva pé no chão. Primeiro de tudo, na minha opinião, Python estava no lugar certo na hora certa. Nos anos 90 a linguagem de script mais popular no nascente mundo de Linux foi Perl. 






Acho que muitos iniciantes aqui nunca ouviram falar, mas muitos scripts de configuração e administração de sistemas Linux eram escritos em Perl. E quando a web começou a surgir, as primeiras aplicações interativas web, o que conhecemos hoje como programação back-end, era ou em C ou em Perl, porque essa linguagem era mais flexível pra lidar com strings, com um HTML, por causa da sua principal funcionalidade: Regular Expressions ou Regex.







Mais especificamente PCRE ou Perl Compatible Regular Expressions. Quem programa em Objective-C ou Swift pra iOS e Mac e já tentou usar regex, deve ter notado como é um pouco diferente do regex compatível com Perl. Isso porque a Apple, a Microsoft usam regex com sintaxe baseado em ICU que é International Components for Unicode. Eles são parecidos mas tem pequenas diferenças que podem confundir quem não sabe que existem dois padrões diferentes de regex.







Enfim, por causa de regular expressions, Perl sempre foi muito usado pra processar textos, logs, até coisas como sequências de DNA em pesquisa de genoma e coisas assim, já que envolve muito pattern matching de sequências. Porém, na virada do século, o pessoal de Perl quis dar passos maiores que as pernas. Eu lembro que queriam desenvolver um novo Perl, o Perl 6, como uma virtual machine que suportasse múltiplas sintaxes de linguagem por cima, o projeto Parrot.







Esse ciclo de desenvolvimento levou anos e nunca chegou no fim. O Perl 5, que foi a última grande versão de Perl ficou estagnado e sem novidades por muito tempo. Enquanto isso outras linguagens evoluíram mais rápido e de forma mais pragmática, e uma delas foi o Python. Não sei se foi a RedHat quem adotou primeiro, mas o fato é que com a incerteza no futuro do Perl, acredito que muitos começaram a migrar pra Python.







Python também tinha uma sintaxe e ergonomia muito mais modernas. Perl não era originalmente orientado a objetos, embora tivesse como gambiarrar classes com `bless`. Era uma linguagem dinâmica de tipagem fraca, então bugs por causa de coerção de valores e tipos errados não era incomum. Mas Perl influenciou todas as linguagens de script que vieram depois, incluindo Python, Ruby e o mais óbvio, PHP. De onde vocês acham que variáveis com cifrão vieram? De Perl.






O principal legado de Perl, na minha opinião, foi popularizar a viabilidade de linguagens dinâmicas pra aplicações web e popularizar o uso de regular expressions pra pattern matching de textos. Várias linguagens até hoje usam a sintaxe específica de Perl, como em Ruby, Node.js, acho que Go também porque usa a biblioteca "re2" que é compatível com PCRE.






Na realidade, nem todas são 100% compatível com Perl. Por exemplo, em Python, se usar a biblioteca "re", o método `match` tem comportamento como se toda regex começasse com crase, que em Perl significa dizer pra começar o matching do começo do string. Ele também não tem o operador global "/g", pra isso se usa o método "re.sub()".  São pequenas diferenças, mas pode confundir quem conhecia regex de Perl, por exemplo, se costuma usar Vim como editor, que suporta regex Perl.






De qualquer forma, linguagens que quase totalmente suportam a sintaxe de regex de Perl são Python, Javascript, PHP, Ruby. Como falei antes, a biblioteca "re" de Python é só uma casca pra biblioteca Oniguruma, que em japonês significa carro do demônio, sei lá porque. A gem Oniguruma de Ruby é a mesma coisa. A classe RegExp de Javascript também. Oniguruma é uma das melhores e mais rápidas bibliotecas de regex que existem. Mas não é a única. Linguagens como C#, C++, Go usam outra biblioteca, a "RE2". Não confundir com Resident Evil 2.






Acho que nem a Oniguruma e nem a RE2 forçam a sintaxe de Perl. Eles oferecem o motor, mas os detalhes da sintaxe, cada linguagem pode configurar como quiser. Por exemplo, C# tem a opção de usar "verbatim string literal" que é escrever a regex com arroba na frente, assim não precisa escapar caracteres especiais dentro do regex com barra ao contrário. 






Algumas linguagens não usam o estilo Perl e sim a sintaxe ICU, de International Components for Unicode. Exemplos disso são a classe `java.util.regex` de Java, a classe `icu::RegexPattern` de C++, a classe `NSRegularExpression` de Swift da Apple, as funções "preg_*" de PHP. Eu pessoalmente gosto mais da sintaxe Perl. Quando precisava usar ICU pra programar mobile de iOS em Swift ou Objective-C, lembro que vira e mexe tropeçava na sintaxe.






11 anos atrás fiz um pequeno experimento em Objective-C pra importar o Oniguruma e adicionar sintaxe de regex de Perl pra programar iOS. É uma das poucas coisas que ainda sobrou no meu GitHub. Maioria dos meus códigos sempre foi pra projetos de cliente por isso tenho bem pouca coisa aberta. Essa foi uma delas. 11 anos atrás foi 2011, pouco mais de 2 anos depois que a App Store abriu oficialmente. 







Além do regex não ser compatível com Perl, formatação de data e hora também não era compatível com a biblioteca Time de Linux. Sabe a função strftime? Onde podemos pedir pra formar data e hora usando uma string de template como "%d/%m/%Y %H:%M:%S"? 




Em Objective-C e depois Swift, usando a classe `DateFormatter` com o método `dateFormat`, o mesmo template fica assim: "dd/MM/yyyy HH:mm:ss". É bem diferente e isso me incomodava porque Ruby usa o mesmo padrão de C mas de novo, Objetive-C e Swift usam o padrão ICU.






Diferente de Regex onde a sintaxe Perl ainda é forte em muitas linguagens em vez do formato ICU, no caso de formatação de data e hora, o formato ICU é mais forte do que strftime de C. C++, Python, Ruby, Elixir ainda usam o formato de C, mas Swift, Java, C#, até PHP e JavaScript usam o formato ICU. Tecnicamente, por serem padrões internacionais de Unicode, o formato ICU é quem deveria ser considerado o "correto", mas por direito, formatos derivados do mundo Unix e Linux continuam sendo usados.






E de novo, naquele projetinho de biblioteca que fiz pra Objective-C, além de importar Oniguruma, também implementei uma versão de formatador de data e hora usando a função "strftime" da biblioteca "time" de C. Assim eu poderia usar os formatos de Linux e contrariar o formato ICU. E por que? Só pra mostrar que era possível.






E eu contei essas duas histórias pra ilustrar um ponto. Não sei se vocês entendem que muita coisa de Javascript ou Python não são escritos em Javascript ou Python e sim em C. A classe RegExp de Javascript ou "re" de Python são meras casquinhas mas por baixo chamam bibliotecas escritas em C. 






Eu digo isso porque muitas linguagens são escritas nelas mesmas. O compilador de Rust é escrito em Rust. O compilador de Go é escrito em Go. Muito do OpenJDK de Java é escrito em Java. Linguagens compiladas costumam muitas vezes ser escritos nelas mesmas. Isso não torna automaticamente uma linguagem melhor ou pior. Apenas facilita pros desenvolvedores das linguagens não ter que ficar mudando de linguagem o tempo todo. Por exemplo, escrever o compilador em C mas as bibliotecas em Rust. Lembrei disso quando conversei com os criadores e mantenedores de Ruby e eles comentando que escrevem mais C que Ruby.







Isso é mais uma curiosidade, não comecem a brigar em Reddit dizendo que sua linguagem é melhor porque é bootstrapped, ou seja, escrita nela mesma. Mais importante é o seguinte: linguagens interpretadas de script como Python, Ruby, Javascript ou PHP herdam muitas características da plataforma onde nasceram: do C. Diferente de Java ou Go que é na maior parte escrita nelas mesmas, linguagens de scripts costumam parecer mais "cascas" pras funcionalidades de C.







Veja a função de formatação de data e hora "strftime" de Ruby ou "datetime.strftime" de Python. Por que acha que tem esses nomes? Porque herdaram da função strftime da biblioteca time, cujo cabeçalho se chama "time.h". Se num Linux, abrir um terminal e digitar "man strftime" vai dar os detalhes da função original de C. Essa função fica disponível numa biblioteca compartilhada chamada "libc" ou "glibc", que praticamente todo programa que roda em Linux carrega e usa.







Vamos ver mais exemplos? Em Python, claro, muitos dos métodos do módulo "os" são derivados da libc. Temos "os.mkdir()" pra criar diretórios, não por acaso, é o mesmo nome do comando que você usa em qualquer terminal de linha de comando pra criar diretórios, porque ambos usam a mesma função da libC. Ou "os.getenv()" que é o mesmo nome da função da libC pra pegar variáveis de ambiente. Tem funções do módulo "ctypes" que, como o nome diz são "tipos de C", como "ctypes.memcmp()" que compara dois blocos de memória e retorna um inteiro. Em particular vários métodos do módulo "math" herdam funções do cabeçalho "math.h" da libC como "math.sin()" pra calcular seno ou "math.pow()" pra calcular a potência de um número.








A mesma coisa vale pra Javascript, Ruby, PHP. E eu quero pegar esse gancho pra voltar pros projetos mais populares de Python. Vamos pegar o Pandas que é uma ferramenta muito poderosa, flexível e razoavelmente amigável de usar pra fazer análise e manipulação de dados. Povo de data science acho que começa aprendendo Pandas. Se abrirmos a página do projeto no GitHub, podemos ver que a maior parte é escrita em Python mesmo.







Mas essa não é a história toda. Como todo bom projeto moderno de Python, tem um arquivo de "requirements" que lista as dependências que o projeto precisa carregar pra funcionar, vamos dar uma fuçada. Tem uma quantidade enorme de bibliotecas, mas 2 das principais incluem o numpy e scipy. Vamos começar pelo numpy que é importantíssimo porque fornece coisas como array multidimensional, funções de álgebra linear, transformada de Fourier e mais.






Vamos abrir o projeto no GitHub e olha só: um terço é código C. Um dos pontos fortes do numpy é justamente facilitar integrar com bibliotecas em C e Fortran. É por isso que pra gerar o pacote pra Mac, por exemplo, o script que tá na wiki manda instalar o pacote de Fortran. Ou na página de wiki pra Windows, precisa do MSVC que é o pacote de compiladores de C e C++ do Visual Studio da Microsoft. Sim, pra gerar o pacote de um projeto de Python, precisa de compiladores de C, C++ e Fortran. Sabiam disso?







O numpy é requisito pra usar o scipy que é um conjunto de módulos científicos pra estatística, otimização, integração, álgebra linear, processamento de sinais e imagens e muito mais. Ele usa os arrays multidimensionais de numpy por exemplo. E no que SciPy é feito? Quase um quinto do código é Fortran e quase outro quinto é C e C++. Ou seja, pelo menos dois quintos do projeto todo também não é em Python e também precisa de compiladores de Fortran, C e C++.







Todo projeto de data science feito em Python precisa usar numpy e scipy, que são os grandes diferenciais, e eles são feitos em boa parte em Fortran, C e C++ e não em Python. E isso não é pra minimizar, denegrir, ou falar mal de Python, mas sim pra quem não sabia entender que só porque a cara da frente é numa linguagem, não significa que por baixo do capô também é.







E o Tensorflow que todo mundo fica hypado pra machine learning? Vamos ver a página no GitHub? Olha só, bem mais da metade do código é em C++, só um quinto dele é Python. O grosso, o motor mesmo, é todo em C++. E o PyTorch que é redes neurais acelerado por GPU? Metade desse código é em C++. E isso porque eu não estou olhando as dependências no arquivo de requirements. 







Uma parte significativa que não tá contando aqui é a biblioteca de CUDA da NVIDIA e os shaders pra aceleração em GPU, que podem ser escritos em várias linguagens, incluindo Python mas compilam pra HLSL ou GLSL que é o OpenGL Shader Language. Eu falo sobre linguagens de shaders e GPU no video da longa história de CPUs e GPUs, depois dêem uma olhada.






Pra usar esses projetos, sabendo um pouco de Python é suficiente, mas se alguém queria realmente entender como redes neurais,  aceleração via GPU pra esse tipo de computação realmente funciona, obrigatoriamente não é Python e sim C++ e linguagens de shaders pra GPU. Eu estou sendo pedante nisso porque da forma como muita gente faz propaganda, parece que é tudo feito em Python e basta saber Python pra resolver tudo nessa área, o que não é verdade.







E de novo, meu objetivo não é pegar no pé do Python. Como contei no começo, ele estava no lugar certo na hora certa quanto Perl 5 foi desaparecendo. Linguagens de script como Perl ou Python, que foram feitos pra funcionar muito perto do sistema operacional, são ótimos pra funcionar como cascas pras bibliotecas de alta performance feitos em C ou C++.





Era esse tipo de coisa que se fazia com  Perl, que era menos ruim do que escrever scripts de SH ou Bash, e depois passamos a usar Python que, com sua sintaxe bem simples e espartana, caiu como uma luva pra administradores de sistemas que precisavam fazer coisas rápidas.






Com o tempo passou a ser adotado em distros com programas como o Conda que é escrito em Python e serve pra instalar e gerenciar pacotes. Não confundir com Anaconda que é outro projeto pra computação científica. Daí o pessoal de pesquisa do Google passa anos desenvolvendo um Tensorflow da vida em C++. Nesse estágio ele é difícil de usar, precisa saber C++. Em cima dele fizeram scripts em Python e um ferramental com mais usabilidade e mais simples de usar pra maioria das pessoas. Essa é vantagem do Python.







Diferente do Tensorflow de Python, o tfjs ou Tensorflow.js é na maior parte escrito realmente em TypeScript e Javacript. Assim como em Python as partes que exigem performance e falar diretamente com o hardware como GPUs, são feitos em C++, mas na versão de Javascript ele pode rodar no navegador e utiliza o suporte a WebGL e Web Assembly. A versão de Javascript não faz tudo que a de Python mas é suficiente. Tem o Tensorflow Lite pra rodar em smartphones também. Enfim, o principal é entender que quando precisamos de performance normalmente precisamos mais do que Python.







E pra não pegar só no pé do Python, Javascript é similar. Tudo que é impressionante e roda rápido no navegador não é mérito do Javascript e sim do navegador que oferece APIs como WebGL pra dar acesso à aceleração via GPU. E todo navegador é feito em C++. Entendam, toda linguagem interpretada depende muito do sistema operacional e outras bibliotecas instaladas.







Voltando ao ponto onde linguagens como Python, Javascript ou PHP dependem de bibliotecas como a LibC, - tanto que os nomes das funções são as mesmas das versões em C -, e se a LibC costuma vir em toda distro Linux mas não em Windows ou Mac, como que faz pra rodar Python em Windows? Vamos pro GitHub do CPython e vou te mostrar o que tem embaixo do tapete. Se procurarmos dentro desse repositório por "ifdef MS_WINDOWS" temos 8 páginas de resultados e olhem esses trechos.






Se nunca programou em C e não sabe o que é pré-processamento, deixa eu pegar um arquivo aleatório desse resultado. Vamos abrir o arquivo "_ssl.c". Olha aqui na linha 628 tem um "ifdef MS_WINDOWS". Se não existisse pré-processamento seria como se tivéssemos duas versões desse arquivo. Um chamado "_ssl.c" que teria esse trecho assim e outro arquivo chamado "_ssl.c-ms_windows" cujo trecho seria escrito dessa outra forma aqui. Conseguem ver a diferença? 







O compilador, se estiver em Windows, vai compilar o código com esse "if" a mais chamando essa função "SetFromWindowErr" que só precisa no Windows. Em Linux ou Mac esse código não existe. E isso acontece em dezenas de arquivos, 8 páginas de resultados no GitHub. Ocódigo do CPython pra Windows é diferente da versão de Linux. 







Por isso o CPython de Windows não é igual ao CPython de Linux que não é igual ao CPython de Mac. Isso vale pra tudo PHP de Windows, Javascript de Windows. Então vamos falar de Node.js. O Node é basicamente um projeto de C++. Um quinto desse projeto é só C++ mas precisamos falar de uma das dependências, o libuv. O coração da principal funcionalidade do Node, que é o famoso eventloop, o reactor, é implementado quase 100% em C. Vamos abrir a página dele no GitHub. Olha só aqui embaixo, 97% de C, mas o resto é só coisas administrativa, por isso é 100%.







E o que é a libuv. Novamente, sendo uma biblioteca de C, num terminal de Linux podemos usar o comando "man" que, se alguém tinha dúvida, significa "manual" e não "homem". Normalmente bibliotecas de C instalam sua documentação nesse formato. E como diz aqui, esse projeto foi feito pelos desenvolvedores do Node.js pra ser uma biblioteca com capacidade pra rodar em diversas plataformas como Windows, Mac, BSD e é quem abstrai as funcionalidades de I/O assíncrono que o Node precisa pro seu reactor.







Cada sistema operacional implementa I/O assíncrono diferente. Linux costuma ter suporte a epoll, UNIX BSD tem Kqueue, Windows tem IOCP que é I/O Completion Ports, que muitos argumentam que é superior a epoll ou kqueue. Ou seja, a principal funcionalidade do Node só é possível porque quem de fato fornece o músculo é o sistema operacional. O libuv é mais uma casca em C++ pra abstrair essas diferentes formas de fazer I/O assíncrono e tornar possível o Node rodar em qualquer sistema operacional. 








E o Deno, o competidor que muitos consideram melhor que o Node? Eu nem quero tentar entrar nessa discussão de quem é melhor. Mas se abrirmos a página GitHub do Deno, vemos que mais da metade, mais de 60% é escrito em Rust. Ahhh será que é por isso que ele é melhor que o Node então? Na verdade não. Se procurarmos por libuv nesse repositório, vemos que o Rust importa as mesmas funções do libuv do Node, então em termos do eventloop, ambos fazem a mesma coisa. Claro que podem parametrizar pra se comportar diferente, mas a fundação é a mesma e, de novo, é C++.








Eu poderia passar o dia todo dando exemplos em Ruby, em PHP, e até mesmo em Java. Mas ué, tudo que é de Java não era escrito todo em Java? Na realidade não. Como último exemplo, vamos abrir a página do OpenJDK e olha aqui embaixo, 13% do Java é escrito em C++. Mas o que? Vamos ver, olha só, muita coisa do HotSpot que é o motor do JIT ou Just in Time Compiler da JVM é escrito em C++.  Nem mesmo o Java, que nasceu nos anos 90 com a frase de "Write Once, Run Anywhere" é puramente feito em Java. E se isso não ficou claro, olha a página de resultados de arquivos C++: tem pelo menos 100 páginas de resultados, uma parte considerável da JVM não é feito em Java.









E isso não é perseguição. Ruby, PHP, DotNet, Go, Rust, Swift, e todo o resto tem partes consideráveis que depende de C e C++, coisas como a LibC, coisas de criptografia como OpenSSL ou alternativas como libsodium. Imagina se toda linguagem tivesse que fazer criptografia do zero? O mundo já tem bugs de segurança demais. É melhor todo mundo reusar o que já existe de melhor e mais maduro. 








E isso só falando em Linguagens. Quem fez Ciências da Computação decentemente não perde muito tempo com discussões de melhor linguagem. Mas pessoal de desenvolvimento web, por alguma razão vira e mexe entra nesse tipo de argumento. Então só pra complementar, além de linguagens, no mundo web temos diversos outros serviços e componentes que precisamos usar no nosso dia a dia. 






Por exemplo, no que é escrito o banco de dados Postgres? É mais de 85% de C. E o MySQL, mais especificamente o MariaDB? Metade é C++ e quase 40% é C. Bom, mas isso deve ser porque são velhos né, um banco de dados mais novo como MongoDB deve ser em outra coisa mais moderna? Não, 72% é C++.






E o Redis que usamos pra cache ou filas o tempo todo? É quase 80% de C. Mas não significa que tudo é em C ou C++. Vejamos o banco de dados distribuído Cassandra, esse é quase 100% feito em Java e não é o único. O Apache Kafka que é o sistema de filas que falei no episódio passado, é quase 75% em Java e 22% em Scala, que é outra linguagem que roda na JVM então 97% é Java. E falando em sistemas de fila, outro com excelente reputação e maturidade e que, se não me engano, era uma das estrelas por trás de serviços como Whatsapp, é o RabbitMQ que é escrito em Erlang, a plataforma por trás da moderna linguagem Elixir.








E aqui vem outra coisa que eu queria explicar. Tanto Java quanto Erlang são muito bons pra construir sistemas distribuídos, de forma mais produtiva do que fazer em C ou C++. Go também serviria, mas ele ainda é muito novo comparado com os outros, talvez o próximo grande banco de dados seja em Go, não sei. Ele ainda não se provou nesse espaço. Então deixa eu dar minha perspectiva sobre onde cada linguagem tem mais força.









Todo sistema operacional hoje é feito numa mistura de C e C++. E quando eu falo sistema operacional ou OS quero dizer coisas como a kernel e drivers de dispositivos, os componente que rodam no Ring Zero de maior privilégio. Todo o resto, nossos programas e scripts rodam no Ring 3, que tem menos privilégios, o que chamamos de userland. Todo programa em userland precisa usar o kernel do OS como intermediador pra falar com dispositivos como SSD, placa de rede, placa de video, teclado, mouse e tudo mais. O único que tem permissão pra falar com o hardware diretamente costuma ser o kernel e seus drivers, que rodam no mesmo espaço de memória.








Isso não vai mudar por muito tempo. A kernel XNU da plataforma Darwin do Mac, a kernel NT do Windows, a kernel do BSD UNIX, que eu não lembro se tinha codinome. Dispositivos Android usam a kernel do Linux. Dispositivos iOS como iPhone usam uma kernel derivada do MacOS. Existem outras de nicho, mas essas são as principais e vão continuar sendo por muito tempo. E todas elas tem uma coisa em comum: são escritos em C e C++. E porque isso importa já que no final, depois de compilar, vira tudo um binário?








Porque essas kernels expõe suas funcionalidades como funções de C, que podemos interfacear com os diversos arquivos de cabeçalho com extensão ".h". Pra realmente entender isso, precisa entender um pouquinho de como compilação de C funciona. Eu expliquei parte disso em episódios como do Hello World, a diferença de arquivos texto e binário e o episódio de linguagem interpretada versus compilada. Depois assistam pra entender.







A explicação que vou fazer agora acho é um pouco errado, mas é pra simplificar o modelo na cabeça. Se alguém tiver uma explicação de forma mais simples, mandem nos comentários abaixo. Mas pense num driver, como driver da NVIDIA pra placa de video, ou driver pra placa de rede e coisas assim com uma DLL de Windows ou uma biblioteca .SO de Linux. A kernel depois que boota começa a carregar esses drivers. Pense um "import" em Python ou Javascript.






As estruturas de dados e funções que esses drivers implementam vão existir no mesmo espaço de memória que as outras estruturas da própria kernel. É como se a kernel já viesse embutida com esses drivers. Uma vez carregado, o driver enxerga tudo que a kernel enxerga e vice versa. Lembra ponteiros? A kernel pode manipular diretamente uma struct de uma placa de rede, por exemplo. 






Isso é necessário porque no nível da kernel gostaríamos de ter a maior performance possível, o menor número de abstrações. A kernel ideal não desperdiça recursos fazendo indireções e abstrações. Por causa disso você nunca vai conseguir fazer um driver em Javascript, Python, Java ou Erlang. 






O interpretador de Javascript, como o Google V8 ou o Spidermonkey da Mozilla, assim como a JVM de Java ou a BEAM de Erlang, poderíamos classificar mais ou menos como máquinas virtuais. A intenção delas é abstrair o sistema operacional por baixo, a kernel. Assim um programador de Python pode escrever praticamente o mesmo código pra rodar em Mac ou Windows ou Linux e o interpretador do Python vai se virar pra fazer funcionar embaixo. A JVM é a que mais esconde o OS por baixo, Python ou Javascript escondem menos e às vezes precisa fazer um "if windows faça X else if Linux faça Y" mas é raro precisar.







Pra ser capaz de criar um driver de dispositivo que consiga interagir direto com a kernel, em particular carregar no mesmo espaço de memória, precisa ser uma linguagem compilada que gera binários com a mesma ABI de C, ou seja cujo binário seja compatível com binários gerados pelo compilador de C em termos de tipos de dados básicos terem o mesmo tamanho, mesmo alinhamento, mesmo layout de structs e unions e chamadas de funções sigam as mesmas convenções, tipo uma compatibilidade de API no nível binário.







Outra coisa que talvez você não saiba de linguagens compiladas como C, C++, Rust, Nim, D ou Go e linguagens tecnicamente interpretadas como Python, Ruby, Javascript, PHP, e até Java, C# ou Erlang e Elixir. Eu digo "tecnicamente interpretadas" porque Java não gera binário nativo. Sim, Java ou Javascript tem coisas como JIT na JVM ou V8, que no final pode gerar binário de alguns trechos, mas originalmente não são binários nativos. Só em tempo de execução.






O problema de não ter binário nativo de antemão é que não sabemos o endereço de funções e estruturas de dados. Por isso não temos como fazer um código de C que aponta diretamente pra essas estruturas usando coisas como ponteiros. Mesmo assim é possível integrar binário feito em Rust ou C com programas em Java ou Javascript. Por exemplo, um JavaScript consegue importar bibliotecas como OpenSSL, só que um String de Javascript não é um tipo de dados igual a um String de C. Um String de Python não é igual a um String de C#, então como faz pra uma linguagem falar com outra?







A única forma do binário gerado por uma linguagem conseguir usar um tipo de dados diretamente via ponteiro de outra linguagem, só é possível se são binariamente iguais, tenham a mesma ABI. Quando não tem, precisa existir um processo de conversão. Você já deve ter ouvido falar dos termos serializar e desserializar ou marshalling e unmarshalling. A grosso modo, no mundo de web seria mais ou menos como converter uma estrutura XML num JSON ou vice versa. 






O que acontece quando se chama uma API que só devolve XML mas precisa passar pra uma classe ou outra biblioteca que só entende JSON? Precisa converter, só que conversão tem o seguinte defeito. Veja este exemplo de XML que a API hipotética devolveria, ela tem  845 bytes.


```xml
<product>
  <name>Playstation 5</name>
  <sku>PS5</sku>
  <manufacturer>Sony</manufacturer>
  <category>Video Games</category>
  <description>
    The Playstation 5 is the next-generation gaming console from Sony, featuring lightning-fast loading, stunning graphics, and immersive gameplay.
  </description>
  <specifications>
    <specification name="CPU">AMD Zen 2</specification>
    <specification name="GPU">AMD RDNA 2</specification>
    <specification name="Memory">16 GB GDDR6</specification>
    <specification name="Storage">1 TB NVMe SSD</specification>
    <specification name="Dimensions">39 x 10 x 26 cm</specification>
    <specification name="Weight">4.5 kg</specification>
  </specifications>
  <pricing>
    <price currency="USD">499.99</price>
  </pricing>
  <inventory>
    <quantity>50</quantity>
  </inventory>
</product>
```



Digamos que fizemos um código pra converter de XML pra JSON ou seja, faz marshall entre os dois formatos, e eis o JSON equivalente:



```json
{
  "product": {
    "name": "Playstation 5",
    "sku": "PS5",
    "manufacturer": "Sony",
    "category": "Video Games",
    "description": "The Playstation 5 is the next-generation gaming console from Sony, featuring lightning-fast loading, stunning graphics, and immersive gameplay.",
    "specifications": {
      "specification": [
        { "name": "CPU", "value": "AMD Zen 2" },
        { "name": "GPU", "value": "AMD RDNA 2" },
        { "name": "Memory", "value": "16 GB GDDR6" },
        { "name": "Storage", "value": "1 TB NVMe SSD" },
        { "name": "Dimensions", "value": "39 x 10 x 26 cm" },
        { "name": "Weight", "value": "4.5 kg" }
      ]
    },
    "pricing": {
      "price": {
        "currency": "USD",
        "value": 499.99
      }
    },
    "inventoryQuantity": 50
  }
}
```



Esse JSON é um pouco menor, com 808 bytes. O importante é o seguinte: nesse instante a função que converte tem em memória as duas versões, ocupando o total de 845 + 808 que dá mais de 1600 bytes. Agora pense no nível de uma struct de C versus um objeto JSON de Javascript. Não tem como criar um ponteiro pra um objeto JSON a partir de um código C e tentar usar como se fosse uma struct. Se fossem compatíveis, não precisaria duplicar memória, mas como não são compatíveis, precisamos fazer marshalling, duplicando a memória usada.








Eu acho que muito iniciante não pensa assim, mas comece a enxergar onde memória é duplicada. Por exemplo, quando você abre seu navegador e pede uma página web pra amazon.com por exemplo, sabemos que o servidor web da Amazon vai processar o que precisar pra no final gerar um string gigante que é o conteúdo HTML pra te responder. Esse HTML está ocupando memória no servidor. Quando ele envia pra você, e chega no seu navegador, o navegador tem uma cópia dessa string. Tanto o servidor web quanto seu navegador tem uma cópia do mesmo HTML, duplicando memória nos dois lugares. Isso é inevitável. 








O mesmo vale pra um script feito em Javascript ou Python. Lembra da tal função strftime pra formar data e hora que falei lá no começo do episódio? Por baixo é uma função em C. No Python criamos a String "%d/%m/%Y" pra formatar a data e chamamos "datetime.strftime". Por baixo essa função vai chamar a função da LibC que também chama "strftime", pra isso precisa criar uma String de C, mas a String de Python não é compatível com String de C, então precisa converter e isso vai duplicar esse String. 







Esse é um dos custos escondidos que tem em várias linguagens quando integram com bibliotecas locais feitas em C por exemplo, ou quando fazemos chamadas remotas pra APIs de microserviços ou servidores de banco de dados. Várias estruturas de dados como Strings estão o tempo todo sendo duplicados pra converter num formato que o outro lado entende. O exemplo que dei de XML e JSON são pequenos, nem 1 kilobyte, mas no mundo real, quem já trabalhou em projetos de verdade sabe que estamos transitando documentos muito maiores que isso, de centenas de usuários o tempo todo. É uma das razões de tanta diferença no uso de recursos entre diferentes linguagens ou diferentes bibliotecas. 









Quando Java tinha a noção de escrever tudo em Java, ou seja, tudo rodando dentro do mesmo processo da mesma JVM, onde todas as bibliotecas também seriam em Java, não era só pra ser bonito. Uma das vantagens é que se tudo fosse feito em Java, internamente não precisa ter marshalling e unmarshalling, poderia lidar diretamente com referências pras estruturas de dados. Sendo que se integrar como uma biblioteca feita em C usando o recurso de JNI ou Java Native Interface,  precisa existir uma tradução entre o layout do espaço de memória de Java pro espaço do C. O mesmo vale pra outras linguagens que não trabalham com os mesmos tipos de C.







Se ficou abstrato até aqui, deixa eu mostrar um exemplo super besta em Python. Considere o seguinte trecho de código em Python: 








```python
# Import the extension module
import c_extension

# Call the py_c_function function with a Python string argument
c_extension.py_c_function("Hello, C function!")
```









Aqui eu estou importando um módulo qualquer feito em C e em seguida chamo uma função declarada nesse módulo passando um String qualquer. Vamos ver como teríamos que fazer essa função em C.




```C
#include <Python.h>

// Declare a C function that expects a char* as a parameter
void c_function(const char* s) {
  // Do something with the C string here
  printf("C function received string: %s\n", s);
}

// Define a Python wrapper function for the C function
static PyObject* py_c_function(PyObject* self, PyObject* args) {
  // Extract the Python string argument from the Python tuple
  PyObject* py_s;
  if (!PyArg_ParseTuple(args, "O", &py_s)) {
    return NULL;
  }

  // Convert the Python string to a C string
  const char* s = PyBytes_AsString(py_s);
  if (s == NULL) {
    return NULL;
  }

  // Call the C function with the C string
  c_function(s);

  // Return None to indicate that the function succeeded
  Py_RETURN_NONE;
}
```





Primeiro declaro a tal função `c_function` que recebe uma string e imprime na tela. Um string em C é só um array de caracteres que termina com caracter nulo. Já uma string em Python é um objeto, uma estrutura de dados bem diferente. Por isso embaixo declaramos uma segunda função chamada `py_c_function` que recebe um objeto Python cujo tipo é um ponteiro pra `PyObject` chamado `args`. O primeiro parâmetro é o `self` que todo método de Python declara explicitamente, o equivalente `this` em Javascript, por exemplo.





O importante nessa função é essa `PyBytes_AsString` que vai devolver o ponteiro pro array de chars que está nessa variável `py_s`. Agora, praquele código em Python conseguir chamar esse código em C, precisamos de outro código que vai intermediar isso, escrito em Cython com extensão ".pyx" mais ou menos assim: 







```python
# c_extension.pyx

# Declare a C function that expects a char* as a parameter
cdef void c_function(const char* s) nogil:
    # Do something with the C string here
    printf("C function received string: %s\n", s)

# Define a Python wrapper function for the C function
def py_c_function(s: str) -> None:
    # Convert the Python string to a C string
    cdef const char* cs = s.encode()
    # Call the C function with the C string
    c_function(cs)
```








Esse é o código que faz o tal marshalling, ou conversão, do objeto de String do Python pra um array de char, é isso que faz o método "encode" da String, duplica a string. Isso é importante porque o objeto de String de Python está sob controle do garbage collector de Python. Digamos que ele decida que ninguém tá usando mais essa String e limpa da memória. Mas no lado do C, que o garbage collector não enxerga, a String ainda era necessária, daí iria crashear o programa. Mas passando uma cópia separada, agora cada um tem seu próprio string e um não pisa no pé do outro, mas o custo disso foi duplicar essa string.








É assim que linguagens como Python, Javascript, Ruby ou PHP fazem pra falar com funções de bibliotecas em C: via marshalling e unmarshalling de estruturas de dados, onde cada lado gerencia a memória do seu jeito. No lado do Python o garbage collector dele se vira com os objetos que ele criou. E do lado do C vai usar, por exemplo, malloc e free, pra lidar com seu espaço de memória. Por isso que precisa duplicar memória na comunicação entre eles e por isso é mais pesado.







E qual a diferença com uma linguagem que compila binário nativo compatível com C como Rust? Vamos fazer a mesma coisa usando Rust agora. Eis um exemplo de um código Rust que chama uma função de alguma biblioteca C qualquer que recebe uma String como parâmetro, e sendo em C, sabemos que String de C é sempre um ponteiro pra um array de chars terminado em nulo:






```rust
use std::ffi::CString;
use std::os::raw::c_char;

// Declare the C function using the extern keyword
extern "C" fn c_function(s: *const c_char) {
    // Do something with the C string here
    println!("C function received string: {}", unsafe {
        CStr::from_ptr(s).to_str().unwrap()
    });
}

fn main() {
    // Create a Rust string
    let s = "Hello, C function!".to_owned();

    // Convert the Rust string to a CString
    let c_string = CString::new(s).unwrap();

    // Call the C function with the CString
    unsafe { c_function(c_string.as_ptr()) };
}
```






Esse "extern C" é pra declarar a assinatura da função C externa que vamos chamar, cujo nome é `c_function` de novo e o parâmetro é o ponteiro pro array de char. Na função `main` começamos criando um String de Rust. Só que, assim como no caso do Python, um String de Rust é um objeto, uma estrutura de dados diferente de array de char, por isso criamos uma `CString` que existe no módulo "std::ffi" pra converter o String de Rust num String de C. Finalmente, dentro de um bloco inseguro, `unsafe` chamamos a função de C passando esse novo String de C como ponteiro. 








Assim como em Python, tivemos que duplicar a memória pra converter os strings. Mas em Rust podemos pular a parte de criar a string de Rust e direto já trabalhar com String de C. Pra demonstrar isso deixa eu começar fazendo uma nova função em Rust besta que recebe um String e converte tudo pra maiúsculo:








```rust
fn rust_function(s: &str) -> String {
    // Do something with the Rust string here
    s.to_uppercase()
}
```









Simples, recebe uma referência pra um String e retorna outro String. Agora vamos ver a mesma função mas usando direto String de C em vez do String de Rust:






```rust
use std::ffi::CString;

fn rust_function(s: CString) -> CString {
    // Convert the CString to a slice of c_char
    let s_slice: &[c_char] = s.as_ref();
    // Iterate over the slice and uppercase the characters
    let s_uppercase: Vec<c_char> = s_slice
        .iter()
        .map(|&c| c.to_ascii_uppercase())
        .collect();
    // Create a new CString from the uppercase characters
    CString::new(s_uppercase).unwrap()
}

```








Eu não sou super fluente em Rust então não sei se tem jeito melhor de fazer isso, mas veja a diferença. Agora o parâmetro é direto um string de C e devolve um string de C também. Um objeto de String de Rust tem métodos conveniente como "to_uppercase" pra transformar tudo em maiúsculo. Mas pra trabalhar em cima de um String de C, precisamos manualmente iterar caracter a caracter do array e transformar em maiúsculo com o método "to_ascii_uppercase".






Pra fazer código Rust compatível com estrutura de C sem ficar convertendo em objetos nativos de Rust, que são mais convenientes mas duplica memória, precisamos praticamente escrever C usando sintaxe de Rust. Não vai ser o código mais bonito do mundo, mas em casos mais complexos que esse certamente vai ser melhor do que escrever C na mão, porque podemos contar com os recursos mais avançados de gerenciamento de memória e segurança que o compilador do Rust nos fornece. Mas se alguém tinha dúvidas de como trabalhar com Rust e C, por exemplo, na kernel do Linux, esse é um exemplo besta que ilustra como é mais ou menos.







Agora é minha opinião, mas dado o que expliquei até agora, o que eu penso de linguagens é o seguinte: se quiser fazer programação de sistemas, ou seja, coisas de baixo nível como drivers de dispositivo ou mesmo componentes de infraestrutura como a stack TCP, o certo é usar C, C++ e agora Rust ou até linguagens meio desconhecidas mas  de mais alto nível e compiladas como Nim ou a linguagem D, que como o nome diz, foi pensado pra ser sucessor de C mas nunca conseguiu  popularidade, talvez porque Rust e Go surgiram no meio do caminho e meio que roubaram os holofotes.







Numa camada acima vem construção de ferramentas de administração e infraestrutura. Antes muitos faziam bibliotecas em C como um oniguruma pra regex, e pra facilitar o uso, criavam clientes com linguagens dinâmicas de script como Python ou Perl da vida. Mas Rust e Go tornaram menos dolorido escrever esse tipo de software. A sintaxe é mais moderna e limpa do que C ou C++ então não é incomum que não precise mais fazer scripts de Python por cima pra facilitar o uso. Exemplo disso é um Docker, feito em Go. Antigamente alguém poderia criar um libdocker em C e um script chamado Docker em Python que integra com essa lib pra ser a ferramenta de linha de comando. Agora podemos usar só Go ou só Rust.







Go e Rust geram binários quase tão eficientes quanto C ou C++ e no caso de Rust até mais eficientes e mais seguros em muitos casos. Nos últimos anos o mundo Linux ganhou várias ferramentas como o terminal Alacritty feito em Rust que eu gosto bastante, e tem esta página com várias ferramentas alternativas escritas em Rust que eu uso no dia a dia como o "exa" que substitui o "ls", o "procs" que substitui o "ps", "fd" que substitui o "find" e muito mais, depois dêem uma olhada.






Depois entramos na categoria que não expliquei muito que são sistemas distribuídos.  São softwares como bancos de dados ou sistemas de armazemento de volumes grandes de dados. Aqui eu vejo muitas soluções que saíram do ecossistema Apache, como Apache Hadoop, Apache Solr, Apache Spark, Apache Kafka, Apache Cassandra e muito mais, todos feitos em Java. Precisava ser em Java? Não, por exemplo, existem alternativas como a DataStax que é Cassandra escrito em C++.









Mas o que surgiu desse esforço massivo da Apache foi um ecossistema de bibliotecas e ferramentas que facilitam o desenvolvimento de sistemas distribuídos, como o famoso ZooKeeper que é o componente responsável pelo consenso entre diversos nodes de um sistema distribuído. Se isso soou grego, pensa assim. A grande vantagem de um banco de dados Cassandra é conseguir aumentar a capacidade adicionando novos servidores no cluster. O sistema se coordena pra receber esse node e passa a distribuir o armazenamento e processamento pra ele. Se um node falha, o sistema de consenso lida com isso também, via eleições por exemplo. São soluções pra quem precisa lidar com petabytes de dados, não é pra tech startup pequena sair usando.









A grande vantagem do Java é ser mais produtivo e menos doloroso do que C++. Uma coisa é fazer algo relativamente "pequeno" em quantidade de linhas de código como uma ferramenta de linha de comando ou driver, outra coisa é criar um software massivo com milhões de linhas de código pra lidar com processos complexos como coordenação de dados massivos em nós de um sistema distribuído. Java foi a escolha certa na época, talvez a única escolha. Pouca gente conhecia Erlang e a sintaxe também nunca foi muito familiar pra quem se acostumou a herança de sintaxe do C. Hoje em dia um novo Cassandra poderia ser feito ou em Elixir ou em Go, mas sendo sistemas super complexos e já maduros, não existe motivo pra reescrever tudo nessas linguagens.







Erlang foi uma oportunidade perdida e Elixir apareceu uns 5 ou 10 anos mais tarde do que deveria. Se tivesse aparecido no começo dos anos 2000, certamente seria uma das linguagens mais usadas hoje. O ZooKeeper que eu falei, boa parte de suas funcionalidades existem por padrão no Erlang, que também usa uma máquina virtual e foi feito pra criar serviços distribuídos no mercado de telecomunicações nos anos 80. Ele estava muito à frente do seu tempo, muito antes de começarmos a nos preocupar com escalabilidade horizontal em tamanho de internet no fim dos anos 90. 







Só que naquela época as opções era fazer tudo em C++, que é eficiente mas é masoquismo, ou C# mas aí  estava fechado no ecossistema de Windows da Microsoft, ou Java, que era multiplataforma e bem mais amigável do que C++. Por eliminação, escolhemos Java. Só que a JVM não foi criado pra sistemas distribuídos como Erlang, então empresas como Apache precisaram criar essa infraestrutura, componentes como o ZooKeeper, Storm, Flink. 





Eu posso estar superestimando, mas acredito que se fosse fazer tudo que tem no portfolio da Apache em Elixir, seria mais produtivo e menos difícil hoje. Mas nunca vamos saber, porque a essa altura do campeonato, não vale a pena tentar reescrever um ecossistema inteiro. A Apache já resolveu esses problemas com Java e equiparou as funcionalidades como Erlang. Pra entender qual é essa grande vantagem do Erlang, assista essa minha palestra onde explico como isso funciona dentro da VM do Erlang.







Do ponto de vista de sistemas distribuídos, outra alternativa moderna é Go. Só que Go tem bem menos ferramentas do que Java ou Erlang, que tiveram muito mais tempo pra amadurecer. Assim como Java, primeiro precisaria criar a mesma infraestrutura. Algoritmos de consenso, sistema de arquivos distribuídos, sistema de processamento de batch, streams distribuídos, armazenamento em cluster e assim por diante, antes de conseguir fazer os equivalente Spark, Kafka ou Cassandra. De novo, é tudo especulação da minha parte, porque a realidade é que se eu precisar de sistemas distribuídos, vou olhar o ecossistema Java da Apache.








O que nos leva a criação de aplicações comerciais, como eu chamaria. Coisas que a maioria aqui assistindo provavelmente vai lidar mais. Aplicações web. Seja feito em Ruby on Rails, ou Django com Python, ou Laravel com PHP, ou Spring Boot com Kotlin, ou Express com TypeScript e assim por diante. Aqui vem uma divisor: os softwares que falei até aqui como uma kernel de OS, driver de dispositivo, ferramentas de linha de comando de Linux, ou até um Kafka ou Cassandra tem uma coisa em comum: o ideal é que eles mudem pouco, que a maior parte das melhorias sejam em pequenas otimizações de performance, segurança, estabilidade. Eu não quero meu banco de dados mudando tanto que a cada nova versão dá crash.









Já aplicações web, que lidam com consumidor final, seja um chat, ecommerce, rede social, ferramentas de produtividade como um Figma ou Canva, ele competem pela atenção e o dinheiro das pessoas. Pra competir, uma precisa adicionar rápido funcionalidades que superam do concorrente. Mesmo que apareça um bug novo que alguns vão reclamar, o importante é que dê pra subir correções rápido. Pra isso queremos linguagens que facilitem produtividade mais do que performance. Sim, daria pra fazer sistemas mais eficientes escrevendo 100% em Rust, ou Go, ou mesmo Java e Elixir, mas até certo ponto é mais fácil treinar pessoas em Python ou Javascript e elas se tornam mais rapidamente produtivas nessas plataformas. 









Esse é o motivo de porque não jogamos fora Python ou Javascript: porque taxa homem é mais caro do que custo de CPU por hora. Essas linguagens são mais limitadas como mostrei antes: não servem pra desenvolvimento de coisas com drivers ou protocolos de consenso nem processamento de imagem ou video, mas são ótimos pra fazer código cola mais fácil de usar, importando binários feitos em linguagens mais eficientes como C ou Rust. Portanto podemos usar um Python da vida pra 80% das funcionalidades mais "mundanas" e usamos C, Go ou Rust pra fazer as partes mais difíceis e integramos com uma extensão usando FFI.







Daí temos o mundo mobile, Android e iOS. Pra aplicativos simples, pense num iFood, AirBnb, até um Facebook ou Instagram, podemos apelar pra frameworks mais pesados mas, de novo, mais produtivos como React Native ou Flutter, que evita que a maioria dos desenvolvedores precisem saber como o baixo nível funciona e produzam mais rápido. A maioria dos smartphones hoje já tem mais de 2 gigabytes de RAM, e dá desperdiçar um pouco. 






Claro, se todo mundo usa React Native, todo mundo vai estar limitado nas mesmas coisas que ele suporta. Pra se diferenciar, fazemos a mesma coisa que falei no mundo Web: criamos componentes mais eficientes, de mais baixo nível em Swift pra iOS ou Kotlin pra Android e  integramos nesses frameworks. Quem souber o baixo nível sempre vai ser um profissional mais valioso. É obrigatório? Não. Mas você quer evoluir na carreira e ganhar mais no futuro? Então sim, precisa saber. Sabe tudo que vim mostrando de exemplo na primeira metade do episódio? Sim, aquilo tem que parecer arroz com feijão pra você se considerar um especialista no assunto.








Daí chegamos nas categorias mais hypadas e consideradas mais modernas como data science, machine learning e inteligência artificial. E aqui o mais importante é tirar o máximo proveito do hardware, em particular de conjuntos de instruções como AVX, SSE ou CUDA em GPUs NVIDIA ou OpenCL em GPUs AMD. Pra isso precisamos voltar pro nível de C++. Como expliquei antes, tudo de data science em cima de Python começa em bibliotecas como numpy e scipy, que são feitos em C e Fortran. Machine learning como um Tensorflow começa em coisas como CUDA e C++. Mesmo em javascript, depende de acesso à GPU via WebGL dos navegadores. Não é a linguagem a parte mais importante e sim acesso a esses componentes de computação paralela de vetores e matrizes de dados.









Eu disse no episódio anterior comentando sobre o ChatGPT que no mundo de deep learning, criar modelos como de geração de imagens do Dall-e 2 ou geração de textos como GPT3, custam astronomicamente caro e nenhum de nós vai ser capaz de criar nada perto disso. Só quem tiver acesso a conseguir trabalhar nos centros de pesquisa de uma OpenAI ou Microsoft da vida que vai ter essa oportunidade. Mas pra coisas úteis do dia a dia não precisamos de um GPT. Machine learning com tensorflow e modelos ordens de grandeza mais simples já são úteis pra escopos específicos. Detecção de movimento é um exemplo, pra aplicações de realidade aumentada. 









Muitos não pensam nisso, mas algoritmos mais "simples" como de relevância que é basicamente classificação estatística já é extremamente útil pra coisas como ecommerce conseguirem mostrar "produtos recomendados pra você". Ou sistemas como Elastic terem pesquisa fuzzy com relevância, como um mini Google, onde o usuário não precisa escrever os termos exatos, mas mesmo assim ele consegue devolver resultados relevantes. Tudo isso já existe e já usamos em diversos sistemas, de ecommerces a redes sociais. A maioria dos desenvolvedores nem sabe o que é um Elastic ou Solr e acha que vai entender como funciona um ChatGPT. Tá longe, bem longe.








Enfim, eu sei que o episódio de hoje talvez tenha sido denso, mas eram alguns pensamentos aleatórios que tinha na minha cabeça fazia tempo que queria dar dump. Se você é iniciante, não espere compreender tudo que eu disse de uma só vez, pesquise os termos que não conhecia, volte de novo. Quem já tem experiência já sabia tudo que eu falei, talvez dê alguns insights pra complementar. O objetivo não era dizer que essa ou aquela linguagem é a melhor ou a pior. 







Cada uma estava no lugar certo na hora certa, não necessariamente foram escolhidas por serem as melhores. E mesmo surgindo coisas novas consideradas melhores, não saímos reescrevendo. Maturidade é sempre mais importante que novidade. Se ficaram com dúvidas mande nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e não deixem de compartilhar o video com seus amigos. A gente se vê, até mais!
