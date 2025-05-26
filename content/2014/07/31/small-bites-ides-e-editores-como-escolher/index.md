---
title: "[Small Bites] IDEs e Editores, como escolher?"
date: '2014-07-31T19:54:00-03:00'
slug: small-bites-ides-e-editores-como-escolher
tags:
- learning
- ide
draft: false
---

Todo ano, em toda lista de discussão, algum iniciante sempre vai perguntar: _"Que IDE devo usar?"_ E isso vai gerar sempre todo tipo de flame war.

[![RubyMine](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/458/Screen_Shot_2014-08-01_at_15.09.35.png)](http://www.jetbrains.com/ruby/)

O TL;DR para este post é o seguinte:

* Se quiser 100% open source e old school: Vim com [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh) ou [YADR](https://github.com/skwp/dotfiles).
* Se quiser 100% open source e hipster: [Atom.io](https://atom.io), que é o editor feito em Javascript pelo Github.
* Se quiser o melhor moderno, mas comercial: [Sublime Text](http://www.sublimetext.com). Não é barato, a USD 70, mas garanto que vale cada centavo, especialmente aliado ao [Package Control](https://sublime.wbond.net)
* Se quiser o melhor old school, mas comercial: [Textmate](http://macromates.com), está estagnado há anos desde que se tornou o favorito dos Railers na era 2006-2009, mas a versão 1.5.x (não a 2.0) é muito boa, e eu pessoalmente ainda uso para várias coisas ainda hoje.
* Se quiser uma IDE de verdade, com ferramentas mais avançadas para refactoring e debugging, definitivamente use [RubyMine](http://www.jetbrains.com/ruby/). Custa USD 99 e vale cada centavo, ou se você mantém projetos open source, pode requisitar uma licença gratuita
* Se for somente um montador de front-end, uma opção para Mac que parece interessante é o [Coda 2](https://panic.com/coda/), disponível na App Store.

Aliás, para entender uma diferença crucial de filosofias entre Vim e Atom/Sublime/Textmate, leia este ótimo artigo ["Why Atom Can’t Replace Vim"](https://medium.com/@mkozlows/why-atom-cant-replace-vim-433852f4b4d1). Vim, assim como Emacs, tem uma filosofia própria.

## Qual escolher?

Emacs, assim como Vim, é uma boa opção também, mas como não sou especialista em ELisp, vou deixar passar. Mas pra quem se interessa em se aprofundar em hacking old school, vai fundo! Aliás, o miner Andrew me indicou o pacote [Prelude](https://github.com/bbatsov/prelude), feito pelo [Bozhidar Batsov](https://github.com/bbatsov), o mesmo do Rubocop, ruby-style-guide, etc. Outros que não listei como Dreamweaver, obviamente é o extremo oposto: não use.

Textmate é somente para pessoas como eu, que pegaram Rails entre 2005 e 2009. É difícil largar ele mesmo com novas opções. Se você nunca usou, não vai sentir falta. O Sublime Text veio pra substituí-lo e faz tudo que o Textmate faz, com a vantagem que tem opções pra Windows e Linux. O Atom.io é a mesma coisa que o Sublime, mas um pouco mais lento, por outro lado é grátis, então é uma escolha de custo-benefício. E eu vou dizer que minha sensação é que é mais lento se considerar que estou acostumado com Vim. Se nunca usou Vim ou mesmo Sublime/Textmate, talvez não note.

![Textmate Classic](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/444/Screen_Shot_2014-07-31_at_19.32.32.png)

O RubyMine é da excelente família de IDEs da JetBrains, que desde os anos 90 se manteve como uma das melhores IDEs Java com o [IntelliJ](http://www.jetbrains.com/idea/), que sempre teve o melhor conjunto de auxílios para refatoramento. Depois da decaída dos fabricantes de IDEs, como Borland, a JetBrains foi quem se manteve firme e forte, implementando qualidade. Eles evoluíram e, se você for desenvolvedor .NET é quase obrigatório instalar o [ReSharper](http://www.jetbrains.com/resharper/) para vitaminar o magro Visual Studio. Se você é desenvolvedor Python, vai gostar muito do [PyCharm](http://www.jetbrains.com/pycharm/).

O RubyMine faz tudo que eu considero importante como editor (que é o que vamos listar abaixo) e mais, então vou deixar para um outro post exclusivamente sobre RubyMine. Aguardem!

Voltando ao assunto, um bom editor de textos precisa de poucas coisas pra funcionar decentemente:

Esqueça o Vim-mode onde você "acha" que vai se tornar um programador mais rápido porque sabe deletar 10 linhas pra baixo fazendo a combinação d10j em vez de selecionar as linhas com o mouse e apagar ou selecionar usando shift+setas e apagar. A maioria dos desenvolvedores não escrever uma média maior que 50 linhas de código por dia durante um ano. Tem dias que digita 1000, tem dias que digita 0. Se vai ficar se preocupando se digitou 10 caracteres a mais, ou a menos, faça alguma coisa sobre os dias que ficou procrastinando com Dota 2 ou YouTube. Quantidade de keystrokes, pra granda maioria dos desenvolvedores, é uma desculpa para tentar mostrar que entende mais do que acha que sabe.

Produtividade é uma questão de **FOCO**. Faça uma coisa de cada vez, prioridade no que está fazendo. Se está programando, desligue as notificações do sistema operacional, deixe seus comunicadores em "Away" ou "Busy" e elimine interrupções. Veja Facebook, YouTube e jogue Dota no fim do dia. Só assim você ganha produtividade, não economizando shortcuts de editor de texto. Por mais que você acredite no oposto preste atenção: você não é bom em multitasking, ninguém é. Uma coisa de cada vez, começo até o fim, é o **único** jeito de ser ágil.

Portanto, sim, eu gosto de usar o Vim-mode, mas não 100% do tempo. Eu prefiro usar MacVim porque se eu quiser, posso selecionar coisas com o mouse também e não estou sendo "menos produtivo" por causa disso. O Vim-mode é importante porque quando estou no Vim de Terminal, via SSH num servidor remoto, obviamente não posso usar o mouse. E esse é outro motivo de porque todo mundo tem que saber pelo menos o básico de Vim: para configurar servidores remotos, se necessário (normalmente não deveria ser, pra isso servem deployments automatizados, mas isso é assunto pra outro post).

Outra coisa importante é selecionar não só caracteres, palavras e linhas mas também colunas verticais. O Vim tem o bom e velho Ctrl-V (:help CTRL-V). Sublime Text tem [Column Selection](https://www.sublimetext.com/docs/2/column_selection.html) e Atom tem que instalar um pacote como o [Sublime Style Column Selection](https://github.com/bigfive/atom-sublime-select). Mas nem Sublime e nem Atom ainda são melhores que Textmate e Vim nesse departamento. Mas pelo menos todos eles tem o recurso: qualquer editor de texto que não permite selecionar colunas verticais de texto é obsoleto e não presta pra desenvolver. Nada supera o Ctrl-V do Vim, mas o do Atom e Sublime Text são funcionais o suficiente. O Sublime uma coisa extra que é melhor: edição em múltiplas partes do texto, basta selecionar uma variável, usar Command-D para selecionar as mesmas ocorrências e, quando for editar, ele vai editar em múltiplos lugares. É como um Find e Replace "in-place".

![Sublime Text Column Selection](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/445/Screen_Shot_2014-07-31_at_19.35.22.png)

Falando em Find e Replace, obviamente a coisa mais importante é suportar Regular Expressions. No Vim é o comando "%s/blabla/foofoo/g". Nos outros editores tem um ícone ".*" que muda de Find de texto para Find usando Regex. Textmate tinha isso e os outros também funciona razoavelmente bem. Extremamente importante!

![Atom Find com Regex](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/446/Screen_Shot_2014-07-31_at_19.36.59.png)

Customização de temas e code highlighting corretos são importantes, já que você vai passar o dia todo olhando pra código, é bom que ele seja agradável. Os dois melhores temas, de longe, são os [Solarized](http://ethanschoonover.com/solarized) Dark e Light (eu pessoalmente prefiro o Dark). Esse é tema "cientificamente" produzido, a paleta de cores com o melhor balanço de contraste e cor para desenvolvedores. Na dúvida, instale Solarized Dark. Todos os editores listados tem esse tema. 

Em particular, meu Textmate usa o tema "Mac Classic", é o melhor tema para screencasts e slides para projetor (em projetor sempre use letras escuras em fundo branco!) Falando nisso, lembre-se que LCD emite luz na sua cara. Branco é luz total. Tema branco é garantia de cansar sua vista muito mais rápido. Por isso algo como o Solarized Dark, para quem fica codificando o dia todo, é sempre o mais recomendado.

![Sublime Text Theme](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/447/Screen_Shot_2014-07-31_at_19.37.59.png)

Todo bom editor precisa ter um índice de arquivos e uma maneira "fuzzy" de encontrar. O Textmate foi quem imortalizou o hoje ubíquito "Command-T". O pacote YADR para Vim trás o excelente similar, [CtrlP](https://github.com/kien/ctrlp.vim). O Sublime e Atom, ambos tem um similar ativado com a combinação de teclas "Command-T". Isso é essencial para navegar rapidamente pelo seu projeto. Um "Project Pane", com a versão visual em árvore do seu diretório de projetos não é útil para navegar rapidamente, mas sim para encontrar coisas que você não lembra o nome mas tem uma idéia de onde fica na estrutura de sub-diretórios. Todo bom editor tem um Project Pane, o Vim tem o plugin [NerdTree](https://github.com/scrooloose/nerdtree).

![Atom Command T](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/441/Screen_Shot_2014-07-31_at_19.26.29.png)
![Sublime Text Command T](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/440/Screen_Shot_2014-07-31_at_19.24.36.png)
![Vim CtrlP](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/442/Screen_Shot_2014-07-31_at_19.28.05.png)

Finalmente, existem os "Snippets", trechos de código que funcionam como template. Novamente, todos os editores tem pacotes de snippets para cada linguagem. Foi outra coisa que o Textmate tornou famoso, com seus ["bundles"](https://github.com/drnic/ruby-on-rails-tmbundle) e agora todo mundo copiou. Não precisamos de muita coisa, apenas o suficiente para coisas como digitar "def", apertar "tab" e poder digitar o nome do método e o editor automaticamente identar e colocar o "end" pra fechar. Não fique muito viciado nisso, eles são úteis mas não devem ser utilizados para trechos grandes demais, senão seu código vira um grude de copy e paste. Para boilerplates, temos os diversos generators de frameworks como Rails e Yeoman para Javascript. Para HTML temos Slim e HAML para "economizar" simplificar burocracia de tags. No Sublime Text e Atom você pode usar o Package Control de cada um para procurar e instalar os bundles pra suas linguagens favoritas. O YADR já trás diversos plugins como o [Vim Rails](https://github.com/tpope/vim-rails) que criaram a fama do lendário Tim Pope.

![Sublime Text Snippets](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/448/Screen_Shot_2014-07-31_at_19.39.43.png)

Todos suportam "tabs" para abrir múltiplos arquivos. Mas se você é um desenvolvedor sério, provavelmente trabalha com [Split Screen ou Multiple Panes](http://www.macdrifter.com/2012/07/sublime-text-working-with-multiple-panes.html), que no Sublime são diversas combinações como Command-Alt-Shift-2 para split horizontal ou o Command-K e seta-pra-baixo no Atom, ou simplesmente ":sp" no Vim (Vim rulez!). É a única feature única que Textmate nunca suportou. É absolutamente essencial para que em um pane fique seu código e no outro pane fique o teste desse código! Lembre-se, TDD ou Test-After, não importa, faça testes! Ou no caso de Front-End, HTML de um lado e CSS do outro. E assim por diante. Neste aspecto, o do Vim e do Atom empatam porque eu posso ficar fazendo splits de cada pane invidualmente em qualquer direçao. O do Sublime Text é funcional mas ele tem layouts pré-definidos e não dá pra splitar além, o que eu não gosto.

![Atom Split](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/451/Screen_Shot_2014-07-31_at_19.43.42.png)
![Sublime Grid Layout](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/450/Screen_Shot_2014-07-31_at_19.43.17.png)
![Vim Split](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/449/Screen_Shot_2014-07-31_at_19.42.45.png)

Outras coisas que facilitam incluem funcionalidades como "Code Folding" para esconder blocos de código, como um método. Textmate tornou isso prático e os outros copiaram o recurso. É útil, mas cuidado para não virar uma "muleta" para arquivos que, na verdade, já deveriam ter sido refatorados em arquivos menores. Ou então métodos gigantes, que já deveriam ter sido refatorados em métodos menores.

![Atom Code Folding](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/452/Screen_Shot_2014-07-31_at_19.46.24.png)

Praticamente tudo isso também existe nos editores de IDEs como Eclipse ou NetBeans. Mesmo XCode tem boa parte disso. O pior de todos é o editor do Visual Studio (que verdade seja dita, vem evoluindo até que bem nos últimos anos, e fica melhor se adicionar o ReSharper) e outros editores simples de texto de Windows como UltraEdit ou Notepad++. Em Windows, se possível, use Sublime Text ou Atom, ou mesmo gVIM mas aí não vai ter YADR e outras ferramentas de linha de comando, como explico nas seções abaixo.

Finalmente, outra parte extremamente importante de todos esses editores: eles precisam ser rápidos. O suficiente para eu chamar da linha de comando (o Textmate tem o comando "mate .", o Sublime Text tem o "subl .", o Atom tem o "atom ." e o MacVim, obviamente "mvim") e eles abrirem quase instantaneamente. Uma IDE pesada como Eclipse Kepler (com plugins de Spring, etc) abre - no meu Macbook Pro com SSD - em mais de **17 segundos**!! O Atom, que eu considero o mais lento, abre em menos de 3 segundos. Todos os outros abrem em **1 segundo** ou menos. Faz muita diferença em como eu vou trabalhar.

Cada um dos editores tem dezenas de outras funcionalidades que vão te surpreender, então não deixe de ler a documentação de cada um deles. Em particular, no caso do Vim, você pode ler o README que normalmente cada bundle tem (procure a partir do diretório ".vim/bundle"). No caso do Sublime Text você tem o [Unofficial Documentation](https://sublime-text-unofficial-documentation.readthedocs.org/en/latest/). O Atom é a [documentação](https://atom.io/docs/latest/) do próprio site. Aliás, note que tem como converter bundles de Textmate para Atom.

## Pesquisa em Múltiplos Arquivos: Grep, Ack, Ag? 

O maior ponto fraco do Textmate é seu Find em múltiplos arquivos que, se esbarrar num log gigante, vai travar tudo. Substitua para usar o Ag. Em Mac, use Homebrew para instalar o [the_silver_searcher](https://github.com/ggreer/the_silver_searcher). Agora você precisa instalar o [AckMate](https://github.com/ggreer/AckMate) no Textmate e substituir pelo Ag:

---
rm ~/Library/Application Support/TextMate/PlugIns/AckMate.tmplugin/Contents/Resources/ackmate_ack
ln -s /usr/local/bin/ag "~/Library/Application Support/TextMate/PlugIns/AckMate.tmplugin/Contents/Resources/ackmate_ack
---

Para quem nunca ouviu falar disso, vamos resumir: todo mundo conhece o bom e velho Grep para fazer pesquisas usando regular expressions. Depois dele surgiu o Ack, como uma opção mais eficiente e veloz. E depois dele veio o Ag, como uma opção ainda melhor. O artigo ["The Silver Searcher: Better than Ack"](http://geoff.greer.fm/2011/12/27/the-silver-searcher-better-than-ack/) explica um pouco disso, mas resumindo:

---
% du -sh
250M    .

% time grep -r -i SOLR ~/cloudkick/reach | wc -l
     617
11.06s user 0.81s system 96% cpu 12.261 total

% time ack -i SOLR ~/cloudkick/reach | wc -l
     488
2.87s user 0.78s system 97% cpu 3.750 total

% time ag -i SOLR ~/cloudkick/reach | wc -l
     573
1.00s user 0.51s system 95% cpu 1.587 total
---

11 segundos no Grep. Quase 3 segundos no Ack. 1 segundo no Ag. Na dúvida, escolha sempre Ag!

## Windows, porque não usar

Para quem é de Windows, existe um [port to the silver searcher](http://jaxbot.me/articles/ag_the_silver_searcher_for_windows_6_8_2013). E aqui vem um ponto importante: não use Windows se não for necessário, como máquina de desenvolvimento de qualquer coisa que não seja Java ou .Net. Sim, PHP uma parte funciona. Python, Perl, uma parte funciona. Até [Ruby](http://rubyinstaller.org), uma parte funciona. E sempre vai ser assim: uma parte, nunca 100%.

.NET é óbvio que funciona porque foi feito para Windows. Apesar de existir uma máquina virtual CLR, uma parte significativa são chamadas a subsistemas de baixo nível do sistema operacional usando pontes como PInvoke (Platform Invocation Services, para permitir código gerenciado chamar código não-gerenciado ou não-seguro). No caso de Java, a filosofia era 100% Pure Java, com o tempo surgiram adaptações usando JNI (Java Native Interface, essencialmente algo como PInvoke no .NET), mas no caso de Java preferencialmente tudo é feito para rodar dentro da JVM. Mesmo scripts de linha de comando são sempre chamadas <tt>java -jar xxx.jar</tt> por dentro.

Perl, PHP, Ruby, Python, e outros interpretadores que nasceram no ambiente Unix dependem de APIs [POSIX](http://stackoverflow.com/questions/1780599/i-never-really-understood-what-is-posix) por baixo. Ditribuições GNU/Linux e BSD/Darwin (OS X) implementam essa família de padrões e seguem a filosofia UNIX. O Windows, obviamente, não é UNIX e muito menos POSIX. Existe, porém, como ter o sub-sistema POSIX sobre o Windows. É isso que são os projetos [Cygwin](https://www.cygwin.com) e [Windows Services for UNIX](http://www.microsoft.com/en-us/download/details.aspx?id=274). Apesar do grande esforço desses projetos em tentar prover as mesmas APIs POSIX, existem hoje diferenças nos ambientes Linux e Darwin que eles não cobrem, e por isso muita coisa ainda vai quebrar. É um trabalho homérico tentar fazer o Windows ficar compatível com um ambiente UNIX inteiro.

Por isso, a melhor forma de desenvolver com plataformas que dependem de UNIX é usar máquinas virtuais como VirtualBox, com a ajuda do bom e velho Vagrant, como falei no [post anterior](http://www.akitaonrails.com/2014/07/28/small-bites-vagrant-ubuntu-14-04-chef-solo#.U9q91IBdVqc).

_"Mas eu desenvolvo PHP e Python no Windows sem problemas!"_

É verdade, mas você nunca vai poder usar tudo dessas plataformas, sempre vai precisar existir gambiarras pra fazer uma ferramenta que é simples no UNIX funcionar no Windows. Veja o [PHP Composer Installer](https://github.com/composer/windows-setup), precisa trazer embutido o Git, Msys, Cygwin e tudo mais. Como no caso particular do PHP, uma parcela considerável de todos os desenvolvedores usam Windows, então projetos de Installers como esse ainda funcionam razoavelmente, mas é uma considerável redundância de esforços. Sempre vai ter conflitos de versões mais novas com installers velhos e toda a velha dor de cabeça de sempre. Como instala num Linux? Simples, um comando:

---
curl -sS https://getcomposer.org/installer | php
---

Vamos instalar o PIP do Python no Windows? Não é necessariamente trivial, como esta [thread no StackOverflow](http://stackoverflow.com/questions/4750806/how-to-install-pip-on-windows) indica. E depois você precisa lidar com o [Virtualenv](http://stackoverflow.com/questions/3271590/can-i-install-python-windows-packages-into-virtualenvs) no Windows. No Ubuntu?

---
sudo apt-get install python-pip
sudo apt-get install python-virtualenv
---

'nuff said.

## Atalhos, Shortcuts, Cheat sheets

Se você está acostumado a um conjunto de keybindings, se adaptar a outro é uma dor de cabeça mesmo. Uma coisa que muitos tentam fazer é adaptar o editor às keybindings que estava acostumado, tipo tentar simular [combinações do Textmate no Sublime](https://github.com/ebi/Sublime-TextMate-Shortcuts). Recomendação: não faça isso. Você precisa lembrar de meia dúzia de combinações principais, o resto é secundário e via menu você relembra.

Para ajudar, aqui vão alguns cheatsheets que podem ajudar (principalmente se você está tentando ainda se adaptar a Vim):

* [Vim Cheat sheet](http://vim.rtorr.com/)
* [Sublime Text 3 Cheat sheet](http://www.cheatography.com/martinprins/cheat-sheets/sublime-text-3-osx/)
* [Atom Cheat sheet](https://bugsnag.com/blog/atom-editor-cheat-sheet)
* [Textmate Cheat sheet](http://g-design.net/textmate.pdf)

## Por que Ruby (ou Python, ou Perl, etc) não precisam de IDE?

_"O que é uma IDE?"_ Tecnicamente "IDE" significa [Integrated Development Environment](http://en.wikipedia.org/wiki/Integrated_development_environment). Significa um editor de textos, automatização de compilação e debugging.

No mundo Ruby não há preocupação sobre compilação porque salvo os raros casos onde você está trabalhando com uma extensão em C, não há "compilação". No mundo Rails, em particular, temos preocupação de deployment. Pra maioria de nós, significa um mero <tt>git push heroku master</tt> e boom.

Debugging é outra tarefa que não nos preocupa muito, ou pelo menos não deveria. Se precisarmos muito, basta adicionar a gem [pry-rails](https://github.com/rweng/pry-rails) ao seu projeto e colocar a linha <tt>binding.pry</tt> onde quer debugar. O servidor web vai parar nessa linha no seu console e você pode debugar de lá. Mas como você deveria estar desenvolvendo orientado a testes (Test-First/TDD ou Test-After, não importa, apenas teste!), debugging perde importância. Front-end precisa de debugging visual e todo navegador decente (Safari, Chrome e Firefox) tem excelente debuggers e [web inspectors](https://developer.apple.com/library/mac/documentation/AppleApplications/Conceptual/Safari_Developer_Guide/GettingStarted/GettingStarted.html).

![Terminal oriented development](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/453/Screen_Shot_2014-07-31_at_19.49.15.png)

Isso nos deixa somente com um aspecto importante: o editor de textos! Por isso que no mundo Rails não falamos em "IDE", e sim em editores de texto. Mas quem vem de uma IDE como Eclipse ou NetBeans para Java, ou mesmo XCode para Objective-C sempre pensa em uma e apenas uma coisa: "auto-complete" e ficam pasmos que no mundo Ruby ou não usamos ou o auto complete é bem simples.

Para entender isso precisamos de perspectiva. Vamos pensar em coleções. Em Ruby, temos Array e Hash. Em Java precisamos escolher entre: Vector, HashTable, List, ArrayList, LinkedList, Queue, ArrayDeque, PriorityQueue, Deque, BlockingQueue, Set, HashSet, LinkedHashSet, TreeSet, HashMap, TreeMap, SortedSet, NavigableSet, Map, LinkedHashMap, NavigableMap. Pelo menos 21 classes (e eu acho que não listei todas!) E se incluirmos o Apache Commons, temos mais: ArrayStack, FastArrayList, BinaryHeap, BoundedFifoBuffer, UnboundedFifoBuffer, BeanMap, DoubleOrderedMap, FastHashMap, MultiHashMap, ReferenceMap, FastTreeMap, ArrayEnumeration, ArrayIterator, BagUtils, BufferUtils, CollectionUtils, CursorableLinkedList, etc (essa é só metade da lista!)

![Eclipse auto-complete](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/454/Screen_Shot_2014-07-31_at_19.50.52.png)

Isso deve dar uma perspectiva de porque não precisamos de "auto-complete". Use ferramentas como o [Dash](http://kapeli.com/dash) para ter acesso à documentação (e que no caso do Vim, tem integração do tipo selecionar a palavra-chave no seu código, digitar o comando [":Dash"](https://github.com/rizzatti/dash.vim) e ele vai abrir diretamente a documentação no Dash! Muito prático). Se não tem Mac e usa uma distro Linux ou até mesmo Windows (!!), talvez o [Zeal](http://zealdocs.org/) seja a melhor opção para documentação offline.

![Dash](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/455/Screen_Shot_2014-07-31_at_19.52.12.png)

E o mundo iOS/OS X com framework Cocoa não é muito diferente. Bem menos opções do que em Java, mas ainda muito mais do que Ruby.

No caso de Objective-C ou o novo Swift, o XCode continua sendo um IDE competente. Ele ainda tem crashes bizarros e é um pouco pesado mas ter acesso a ferramentas como Interface Builder, Instruments, Simulator, etc faz parte do workflow de desenvolvimento de aplicações Desktop ou Mobile. No caso de Windows, fazer aplicações para desktop também exige um Visual Studio. Fazer Swing com Java sem alguns bons plugins e debugging também é complicado, então realmente use Eclipse ou NetBeans.

![Xcode](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/456/Screen_Shot_2014-07-31_at_19.54.09.png)

Aliás, um Eclipse ou NetBeans demoram porque literalmente rodam sobre uma "máquina virtual" (que é leve, claro), que é a JVM. Nesse conceito, não é um grande salto rodar suas outras ferramentas de desenvolvimento de outra máquina virtual (mais pesada, sim) que é um Linux dentro de um Virtualbox. Ou se sua máquina de desenvolvimento já é Linux, rodar Vagrant com LXC.

O [RubyMine](http://www.jetbrains.com/ruby/) assim como outras IDEs, foge da minha opinião deste post de usar a combinação "Bom Editor" + "Terminal" + "Vagrant" como fluxo de trabalho para Web. Mas se quiser muito tentar uma IDE para Ruby, esta é obviamente a melhor opção. Em particular, diferente do Eclipse, ele é consideravelmente mais rápido e responsivo. Ele quase empata com o Atom.io em tempo de abertura, levando perto de 4 segundos. O Atom leva perto de 3 segundos e o Eclipse leva mais de 17 segundos. Quase entra na categoria de editores de texto que você pode abrir rápido. Por isso mesmo é uma boa opção.

![RubyMine](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/457/Screen_Shot_2014-08-01_at_14.42.27.png)

E aí, quais dicas legais vocês tem para cada um dos editores mostrados? Não deixem de colocar nos comentários!
