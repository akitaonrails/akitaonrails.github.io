---
title: "[Jornada ao Japão #2] A RubyKaigi Final"
date: '2011-08-05T09:13:00-03:00'
slug: jornada-ao-japao-2-a-rubykaigi-final
translationKey: journey-to-japan-2
aliases:
- /2011/08/05/journey-to-japan-2-the-final-rubykaigi/
tags:
- rubykaigi2011
- traduzido
draft: false
---

Espero que você tenha curtido meu primeiro artigo da série, [Explorando a Cidade de Tokyo](http://www.akitaonrails.com/2011/07/26/journey-to-japan-1-exploring-tokyo-city). Agora vou contar minhas impressões sobre a [Conferência RubyKaigi](http://rubykaigi.org/2011/en/) em si.

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/3/Screen%20Shot%202011-08-03%20at%201.49.02%20AM_original.png?1312346806)](http://twitter.com/#!/takahashim)

O que muita gente talvez não saiba é que a RubyKaigi está na sua 6ª edição e sempre foi organizada pelo esforço puro de [voluntários](http://rubykaigi.org/2011/en/team). O líder deles é o [Masayoshi Takahashi-san](http://twitter.com/#!/takahashim). Ele também é o fundador do [Nihon Ruby-no-kai](https://github.com/ruby-no-kai) (Grupo Ruby do Japão), que mantém a e-zine [Rubyist Magazine](http://jp.rubyist.net/magazine/). Vale muito a pena dar uma olhada nesses recursos pra ver o que os Rubyistas japoneses estão fazendo. Ótima fonte.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/3/Screen%20Shot%202011-08-03%20at%201.53.25%20AM_original.png?1312347512)

O grupo principal parece girar em torno do Takahashi-san e do [Shintaro Kakutani-san](http://kakutani.com/), que trabalha na [Eiwa System Management](http://www.esm.co.jp/) e é o principal Ruby Evangelist do Japão. Ele faz palestras por todo o país, ajuda a criar e organizar as [RubyKaigis Regionais](http://regional.rubykaigi.org/), e traduz livros como o recém-lançado [Agile Samurai](http://ssl.ohmsha.co.jp/cgi-bin/menu.cgi?ISBN=978-4-274-06856-0) (da Pragmatic Programmers). Como evangelista eu mesmo, tenho que ser honesto: o Kakutani-san me envergonha (o que me inspira a me esforçar mais!). O trabalho que ele faz é notável, e se você ainda não o conhece, deveria.

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/3/Screen%20Shot%202011-08-03%20at%202.11.57%20AM_original.png?1312348131)](http://www.ci.i.u-tokyo.ac.jp/~sasada/index.en.html)

O Diretor de Programa da conferência não é outro senão o [Dr. Koichi Sasada](http://atdot.net/~ko1/activities/cv_sasada.pdf), PhD em Ciência e Engenharia da Informação pela Universidade de Tokyo, que comanda o [Sasada Labs](http://www.ci.i.u-tokyo.ac.jp/~sasada/index.en.html) pesquisando linguagens de programação e seus processadores. Ah, e já mencionei que ele é o criador e mantenedor atual do YARV, o coração da série Ruby 1.9? Dá pra ler uma [pequena entrevista](http://railsmagazine.com/articles/48) com ele na Rails Magazine.

Há vários [contribuidores individuais](http://rubykaigi.org/2011/en/team) na RubyKaigi que merecem um tempo seu para conhecê-los. São pessoas muito ativas e muito comprometidas. "Amizade", "esforço", "união" e especialmente "respeito" foram palavras que me vieram à mente ao conhecer alguns deles.

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/3/IMG_2388_original.jpg?1312348321)](http://gihyo.jp/news/report/01/rubykaigi2011/0003?page=7)


## O Programa

Sendo honesto, sei falar um pouco de japonês, mas só no nível casual — não consigo entender o vocabulário técnico mais avançado, minhas habilidades são fracas nisso, peço desculpas.

Então fica difícil acompanhar algumas das palestras mais interessantes apresentadas por palestrantes japoneses. Mas eles tinham uma solução inteligente e geek pra isso. Ambos os auditórios tinham a tela grande principal para projeção dos slides, mais duas telas estreitas e verticais para a projeção do stream do Twitter no lado esquerdo ([#kaigi1](http://twitter.com/#!/kaigi1) para o Auditório Grande e [#kaigi2](http://twitter.com/#!/kaigi2) para o Auditório Pequeno — que não era assim tão "pequeno") e streams do IRC no lado direito.

![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/3/Screen%20Shot%202011-08-03%20at%202.17.43%20AM_original.png?1312348538)

É uma ideia inteligente de tradução em tempo real conduzida pela comunidade. Quando um palestrante estrangeiro estava no palco, a equipe escrevia traduções de algumas das frases-chave no stream oficial do IRC, e qualquer pessoa podia contribuir tweetando no canal do auditório específico, que aparecia na outra tela.

Além disso, havia outro voluntário da equipe, o [Makoto Inoue](http://twitter.com/#!/makoto_inoue), que nos ajudou — palestrantes estrangeiros — a colocar legendas em japonês nos nossos slides escritos em inglês, o que ajuda muito. Vou voltar ao Makoto na última seção, aguente um pouco.

Infelizmente, embora ajude, ainda é difícil acompanhar palestras mais técnicas, como a palestra sobre a [classe ThreadGroup](http://rubykaigi.org/2011/en/schedule/details/17S05) que tentei assistir. Mas isso é algo que quero experimentar na nossa própria RubyConf Brasil. Aqui no Brasil, como temos a [Locaweb](http://www.locaweb.com) organizando a logística difícil do evento, conseguimos contratar narradores profissionais para fazer tradução simultânea falada de inglês para português brasileiro e vice-versa através de fones sem fio — e posso dizer que é um investimento caro. Vou falar mais sobre a RubyConf Brasil em outro artigo.

Graças ao Dr. Koichi Sasada e à equipe, o programa é muito bem balanceado. Tinha de tudo:

Palestras técnicas pesadas como:

- [The Real Time Profiler for Ruby](http://rubykaigi.org/2011/en/schedule/details/16S02)
- [Dynamic Component System and Memory Reduction of VM for Embedded Systems](http://rubykaigi.org/2011/en/schedule/details/16S03)
- [Parallel World of CRuby's GC](http://rubykaigi.org/2011/en/schedule/details/16S05)
- [How to read JIS X 3017](http://rubykaigi.org/2011/en/schedule/details/17S06)
- [CRuby lock design improvement and why it sucks](http://rubykaigi.org/2011/en/schedule/details/17S10)

![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/3/Screen%20Shot%202011-08-03%20at%202.22.02%20AM_original.png?1312348744)

Palestras de casos de negócio como:

- [Large-scale web service and operations with Ruby](http://rubykaigi.org/2011/en/schedule/details/16M03)
- [Issues of Enterprise Rubyist](http://rubykaigi.org/2011/en/schedule/details/16M06)
- [Critical mission system implemented in Ruby](http://rubykaigi.org/2011/en/schedule/details/16M08)

Palestras voltadas à comunidade e motivacionais como:

- a minha própria [Personal Dilemma: How to work with Ruby in Brazil?](http://rubykaigi.org/2011/en/schedule/details/18S06)
- [All About RubyKaigi Ecosystem](http://rubykaigi.org/2011/en/schedule/details/18M03)
- [The Gate](http://rubykaigi.org/2011/en/schedule/details/17M09)

Palestras técnicas um pouco menos pesadas como:

- [Advancing Net::HTTP](http://rubykaigi.org/2011/en/schedule/details/17M08)
- [Drip: Persistent tuple space and stream](http://rubykaigi.org/2011/en/schedule/details/17S02)
- [Actors on stage](http://rubykaigi.org/2011/en/schedule/details/17S01)
- [Use rails_best_practices to refactor your rails codes](http://rubykaigi.org/2011/en/schedule/details/17S04)
- [MacRuby on Rails](http://rubykaigi.org/2011/en/schedule/details/17S08)
- [Writing custom DataMapper Adapters](http://rubykaigi.org/2011/en/schedule/details/18S05)

![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/3/Screen%20Shot%202011-08-03%20at%202.23.21%20AM_original.png?1312348821)

E por fim algumas palestras sobre Agile que todo mundo já deveria conhecer a essa altura:

- [Efficient JavaScript integration testing with Ruby and V8 engine](http://rubykaigi.org/2011/en/schedule/details/17M07)
- [5 years know-how of RSpec driven Rails app. development](http://rubykaigi.org/2011/en/schedule/details/17M06)
- [BDD style Unit Testing](http://rubykaigi.org/2011/en/schedule/details/17M05)
- [Toggleable Mocks and Testing Strategies in a Service Oriented Architecture](http://rubykaigi.org/2011/en/schedule/details/16M05)

E tem [muito mais](http://rubykaigi.org/2011/en/schedule/grid) que você precisa ver. Falando nisso, existe até um grupo de voluntários chamado **KaigiFreaks** (provavelmente uma homenagem ao consagrado [Confreaks](http://confreaks.net/) que todo mundo conhece e ama) dedicado a transmitir os vídeos da conferência em tempo real, gravar, editar e depois organizar e integrar legendas em inglês feitas por voluntários. Editar vídeo dá um trabalhão, e ter voluntários fazendo isso é de aplaudir de pé.

Quer mais? Muitas gravações de sessões já estão disponíveis. Você pode assistir às sessões japonesas do [Auditório Principal](http://www.vimeo.com/rubykaigi) e do [Auditório Secundário](http://vimeo.com/iogi). É enorme — só queria que as empresas de gravação da RubyConf Brasil fossem tão eficientes! Mas espere, esse ano vamos melhorar os serviços de vídeo também.

## Keynote de Abertura – Bridging the Gap

O [Aaron Patterson](http://tenderlovemaking.com/), nosso amigável [@tenderlove](https://twitter.com/#!/tenderlove), entregou uma keynote de abertura excelente. É muito interessante porque vocês sabem que ele é provavelmente a única pessoa que é committer tanto do Ruby Core quanto do Rails Core. Além disso, ter a oportunidade de conversar com ele algumas vezes me fez sentir que ele realmente "entende" o jeito japonês. Assistam:

http://player.vimeo.com/video/26507951?portrait=0

[[16M01] Ruby Ruined My Life. (en)](http://vimeo.com/26507951) from [ogi](http://vimeo.com/iogi) on [Vimeo](http://vimeo.com).

O cerne da palestra dele foi sobre as diferenças de organização entre os times Ruby Core e Rails Core. O Ruby Core Team é orientado a papéis, onde cada committer geralmente tem responsabilidades bem específicas, sendo mantenedor de determinadas funcionalidades do Ruby. Existe até o importante papel de "Release Manager", atualmente exercido pela Yuki Sonoda, a.k.a. [@yugui](http://yugui.jp/), que tem feito um trabalho excelente. Você pode ver a [lista de mantenedores](http://redmine.ruby-lang.org/projects/ruby/wiki/Maintainers) na wiki oficial.

O próprio Aaron é responsável pelo parser YAML, Psych, Fiddle, DL. Ele observa que esse tipo de organização faz você ter mais cuidado quando vai mexer na área de outra pessoa. Não é uma barreira, mas exige mais atenção. Por outro lado, existem áreas sem um mantenedor de tempo integral. E o release cycle é longo, o que atrasa mudanças e correções chegando a um público maior.

![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/3/Screen%20Shot%202011-08-03%20at%202.24.47%20AM_original.png?1312348895)

O Rails Core, por outro lado, não tem papéis muito específicos — todo mundo meio que "possui" tudo. Mas o efeito colateral é que ao mesmo tempo ninguém é "responsável" por nenhuma parte em particular. Não têm um release manager, por exemplo, então não há ninguém organizando ativamente o que falta para fechar um release. Afinal, você viu o Release Candidate do Rails 3.1 ser anunciado na RailsConf lá em maio e estamos fechando julho sem um 3.1 final.

Mas ele não está dizendo que um modelo é melhor que o outro — e sim que eles podem aprender um com o outro. Por exemplo, ele argumentou que o Ruby Core poderia ser menos cerimonioso sobre commits e especialmente sobre reverts, e que as pessoas deveriam conseguir mexer no código sem medo de ofender alguém. E também que o Ruby Core poderia pensar mais sobre o que deveria ser mantido dentro do repositório subversion do Ruby e o que deveria ser removido e mantido separadamente como gems, pra facilitar que funcionalidades paralelas evoluam de forma independente.

[Assista à apresentação dele](http://vimeo.com/26507951) — ele desenvolve várias ideias, fala sobre DTrace, outras coisas técnicas e conta um monte de piadas engraçadas.

## [TL;DR] A Barreira do Idioma

Aaron nos lembrou novamente que muita gente ainda reclama das duas listas de discussão distintas de desenvolvimento do Ruby: a [ruby-core](http://groups.google.com/group/ruby-core-google) e a [ruby-dev](http://blade.nagaokaut.ac.jp/ruby/ruby-dev/index.shtml). A primeira em inglês, a outra em japonês. Alguns desenvolvedores mais paranoicos chegam ao ponto de imaginar que há alguma "conspiração" acontecendo na lista japonesa — decisões tomadas que nunca aparecem na lista em inglês. Como o Aaron disse, não tem nada disso.

A reclamação mais comum é sempre a mesma: _"por que os japoneses não se comunicam em inglês?"_ E aí volta o velho mau hábito de "tomar as coisas como garantidas". A realidade ignorada é que os japoneses, em geral, não têm boas habilidades em inglês. Não é arrogância, não é falta de esforço — é simplesmente falta de habilidade.

Sou do Brasil e aqui as pessoas também geralmente não falam bem inglês. Pra mim, parece que brasileiros e japoneses têm um nível parecido de compreensão do inglês. É muito frustrante. Mas por outro lado, também é frustrante ver americanos assumindo que todo mundo no mundo entende inglês. Me lembra aquela cena memorável do fantástico filme [Inglourious Basterds](http://www.imdb.com/title/tt0361748/) onde o personagem de Diane Kruger, [Bridget von Hammersmark](http://www.imdb.com/name/nm1208167/), diz sarcasticamente:

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/7/31/Screen%20Shot%202011-07-31%20at%208.00.22%20AM_original.png?1312109869)](http://www.youtube.com/watch?v=o-5JSX7jk5I)

Tem que amar o Tarantino :-)

Não sei a reação dos americanos a essa cena, mas tenho certeza que todo mundo fora dos EUA deu uma boa gargalhada. Agora, sério, eu não deveria rir porque nós normalmente só falamos português brasileiro, que é uma língua usada em quase nenhum outro país. Igual o japonês. Mas o sarcasmo era só pra provocar a discussão.

Não é bom quando um estrangeiro espera que você fale o idioma dele em vez do contrário. Mas também não é bom que a gente não faça mais esforço pra aprender outros idiomas, como os europeus parecem fazer. Vou falar mais sobre isso em outro artigo.

Dito isso, meu ponto é que existem muitas suposições na comunicação — e não me refiro só à gramática ou ao vocabulário diferentes. Mais importante ainda, existem protocolos específicos em cada cultura que também tomamos como garantidos e esperamos que todo mundo siga. Mas a comunicação entre pessoas de culturas diferentes pode gerar muitos mal-entendidos. Sendo geek: é a mesma coisa que um cliente MSN tentando se conectar a um servidor XMPP :-)

Depois do almoço tivemos o [Ruby Core Team no palco](http://vimeo.com/26508997) discutindo o que está acontecendo no desenvolvimento atual do Ruby. O Sonoda-san confirmou o 1.9.3 para agosto, com poucas funcionalidades novas — mais correções de bugs, atualizações de segurança, estabilidade no geral. Mas eles apresentaram algumas pequenas funcionalidades controversas. Uma em particular foi interessante.

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/IMG_0486_original.jpg?1312540424)](http://gihyo.jp/news/report/01/rubykaigi2011/0001?page=2)

Temos o método de classe <tt>private</tt> pra esconder métodos específicos no Ruby. Agora eles implementaram o <tt><a href="http://redmine.ruby-lang.org/issues/3908">private_constant</a></tt> pra esconder nomes de classes e módulos que não queremos expor publicamente. É uma funcionalidade interessante, embora tenha irritado um pouco algumas pessoas, como o Yehuda.

Foi divertido (sem conotação negativa, por favor) vê-lo levantar a mão na sessão de Q&A e declarar que o Ruby Core poderia discutir um pouco mais sobre novas funcionalidades assim com os outros desenvolvedores de bibliotecas antes de liberá-las. O time japonês do Ruby Core não entendeu completamente o que ele disse de início. Então o Matz tentou traduzir, mas ainda ficaram confusos, até o Matz acrescentar que era mais uma declaração do que uma pergunta. Aí o Ruby Core fez aquela cara de _"ah, entendi!"_ e seguiu em frente, mas o Yehuda ficou esperando alguma resposta, meio que se sentindo ignorado talvez.

De novo, não é minha intenção fazer piada da situação — essa foi apenas a minha interpretação pessoal. Mas foi um exemplo de uma situação onde as pessoas tentam se comunicar sem usar o mesmo idioma e os mesmos protocolos. Depois da sessão, estava conversando rapidamente com o Aaron, o Yehuda apareceu e disse que estava esperando alguma discussão — tentamos explicar que soou mais como uma declaração, por isso não foi respondido.

## O Ruby Core Team

Outra coisa interessante que não era exatamente uma novidade, mas que eu não sabia, foi a apresentação do [Shota Fukumori-kun](http://sorah.jp/), [@sora_h](http://twitter.com/#!/sora_h) no Twitter. Com apenas **14 anos de idade**, ele é o mais jovem committer do Ruby Core. Fez trabalho pra fazer a [suite de testes do Ruby rodar em paralelo](http://redmine.ruby-lang.org/issues/show/4415) quando múltiplos núcleos estão disponíveis. Parece simples quando explico assim, mas não é. Ele fez várias outras contribuições pro Ruby e outros projetos open source — deem uma olhada no site dele. Fico cada vez mais impressionado com a quantidade de desenvolvedores muito jovens se expondo pelo mundo afora. Fico me perguntando se isso é o começo de uma nova tendência. Fiquem atentos.

O senso de humor do Ruby Core também foi interessante de ver. A Yuki Sonoda-san, com sua postura meio séria, ficava fazendo vários comentários e piadinhas, quebrando um pouco o gelo entre os desenvolvedores no palco. Ela perguntou ao Matz se teriam um 1.9.4. Reclamou, de brincadeira, que não gostaria de lidar com a manutenção do 1.9.2, 1.9.3 e ainda do 1.9.1 que ainda tem suporte, mais um futuro 1.9.4. O Matz fez uma careta engraçada e brincou com a opção de delegar pro Shyouhei Urabe-san, um dos mantenedores da série 1.8. Assim como o Sonoda-san vai migrando pro 1.9.3, talvez o Urabe-san também pudesse se "graduar" do 1.8 pro 1.9. Também fizeram graça sobre lançar o 2.0 em vez do 1.9.4. O Matz concordou por um tempo, o Sasada-san era contra, e não chegaram a um consenso sobre o 2.0. Só uma sessão bem-humorada entre os desenvolvedores core. Mas não esperem o 2.0 tão cedo.

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/IMG_0520_original.jpg?1312539925)](http://gihyo.jp/news/report/01/rubykaigi2011/0001?page=2)

A única outra novidade sobre o Ruby é que Kirk Haines, o corajoso mantenedor da venerável versão 1.8.6, disse que haverá apenas mais um release nos próximos dois meses para fechar os bugs pendentes restantes, e então o 1.8.6 finalmente chegará ao fim da vida. Descanse em paz!

E por último, o Ruby vai mudar sua licença para BSDL + Ruby. Tem uma [discussão sobre esse tópico](http://www.ruby-forum.com/topic/216010) se você se interessa por questões de licença.

## Outras Sessões

Como já mencionei antes, a RubyKaigi teve um programa muito equilibrado com vários temas diferentes para todo mundo. Quero parabenizar a todos por um mix de sessões muito bem pensado. Como de costume, tive o mesmo dilema que tenho em toda conferência que frequento — ou perco sessões porque estou ajustando meus slides até o último minuto ou estou tentando conhecer pessoas novas, gravar entrevistas, fazer networking.

Felizmente, pessoas mais disciplinadas que eu não só assistiram à maioria das sessões como também as descreveram (por favor, mandem nos comentários links para outros blogs com relatos da Kaigi). Um deles é o Stoyan Zhekov, que escreveu três artigos: sobre o [Dia 1](http://bloggitation.appspot.com/entry/rubykaigi-2001-notes-day-1), sobre o [Dia 2 – Parte 1](http://bloggitation.appspot.com/entry/rubykaigi-2011-notes-day-2-part-1) e sobre o [Dia 2 – Parte 2](http://bloggitation.appspot.com/entry/rubykaigi-2011-notes-day-2-part-2).

Se você entende japonês, ou quer testar os limites do Google Tradutor, pode ler o enorme relatório no site Gihyo, que fez reportagens para o [Dia 1](http://gihyo.jp/news/report/01/rubykaigi2011/0001), [Dia 2](http://gihyo.jp/news/report/01/rubykaigi2011/0002) e [Dia 3](http://gihyo.jp/news/report/01/rubykaigi2011/0003). São **21 páginas**! (E [estou na Página 4 do Relatório do Dia 3](http://gihyo.jp/news/report/01/rubykaigi2011/0003?page=4), uhu!) Também recomendo que todo mundo fique de olho no [site da RubyKaigi 2011](http://rubykaigi.org/2011/en/) porque tenho certeza que vão postar links para os slides no Slideshare. E você já tem todas as [gravações](http://vimeo.com/iogi) [em vídeo](http://vimeo.com/rubykaigi) deste ano e dos anteriores também, então separe um tempo pra assistir ao máximo que puder.

## Livros à Venda

Não sei se isso é algo de toda RubyKaigi, mas eles montaram um pequeno estande de venda de livros com vários títulos interessantes. Como estavam lançando alguns títulos novos na Kaigi, também tiveram uma sessão de autógrafos no intervalo do almoço onde o Matz assinou vários livros. No outro dia, o Takahashi-san, o Morohashi-san e o Matsuda-san assinaram o livro novinho deles. Lançaram livros de Rails 3 e Ruby 3 Recipes.

![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/IMG_0157_original.JPG?1312540582)

Foi ótimo — consegui meu livro assinado por todos os quatro (uhu!). E eles têm vários livros sobre Ruby, alguns bem específicos, como um livro inteiro só sobre dRuby, outro específico pra desenvolvimento de apps desktop no Mac com Ruby. Também têm vários livros traduzidos da The Pragmatic Programmers, como o The Agile Samurai, pelo Kakutani-san. O Agile está crescendo no Japão — ainda longe do mainstream, mas as pessoas estão interessadas.

![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/IMG_0162_original.jpg?1312540662)

## (TL;DR) Lightning Talks

Merecem menção especial a _YamiRubyKaigi_ (algo como "RubyKaigi das Trevas") e as duas sessões seguintes de Lightning Talks. Como o evento durou três dias, havia tempo de sobra para várias palestras rápidas de 5 minutos. Fiquei surpreso com quantas pessoas falaram sobre assuntos tão variados — e às vezes só engraçados. Isso é algo que, infelizmente, no Brasil ainda estamos muito atrás. Tenho dificuldade com sessões de lightning talks porque geralmente há poucas pessoas dispostas a falar e os tópicos ainda costumam ser básicos em conteúdo. Depois de ver tantas sessões de lightning talks na RailsConf e na RubyKaigi, sei que ainda temos muito trabalho a fazer por aqui.

Alguns destaques e exemplos dessas lightning talks:

- [Zenpre](http://zenpre.net/) — uma ferramenta web pra facilitar o upload de slides no Slideshare, preparar uma transmissão no UStream e fazer uma apresentação de vídeo + slides online.
- [ODBA](http://odba.rubyforge.org/) ou "Object Database Access" — se define como um sistema de Object Cache não intrusivo para persistência transparente de objetos.
- [Rios Proxy](http://www.slideshare.net/stillpedant/riosproxy-a-framework-for-cli) — um framework para ferramentas de interface de linha de comando.
- [ActiveLDAP](http://ruby-activeldap.rubyforge.org/) — uma biblioteca compatível com Rails 3.1 para acessar diretórios LDAP.

Tem várias outras palestras interessantes que recomendo assistir. Algumas são só engraçadas, outras são motivacionais, mas é inegável que **39** lightning talks (17 da YamiRubyKaigi, 11 no 2º dia, 11 no 3º dia), totalizando cerca de **3 horas e 15 minutos** de conteúdo, é muita coisa. Parabéns à comunidade por dedicar tempo montando slides e conteúdo interessante e aparecendo no palco pra apresentá-los.

E como prometi aos meus novos e bons amigos da Austrália, [Andy Kitchen](http://twitter.com/#!/auastro) e [Jonathan Cheng](http://twitter.com/#!/jonochang), vou dar meu apoio à nova e revolucionária técnica de desenvolvimento de software deles, apresentada na YamiRubyKaigi, que faria até o Kent Beck repensar seus conceitos! :-) Eu apresento a vocês: **V.D.D.**

http://www.youtube.com/embed/lW16ykQ-heg

Agora sério — pensando bem nesse assunto, sempre me perguntei como é que vejo tanta gente na fila pra falar em conferências americanas como a RailsConf, e agora vi muita gente de novo na fila pra falar na RubyKaigi. Aqui no Brasil geralmente tenho dificuldade pra reunir palestras interessantes suficientes pra preencher uma única sessão.

É só mais uma teoria especulativa minha. Nos EUA existem vários grupos de usuários menores de Ruby que se reúnem com certa frequência, como o Seattle.rb. Especulo que as pessoas começam a "treinar" lá, fazendo pequenas palestras para audiências pequenas, testando a aceitação do conteúdo, e então vão para conferências maiores. No Japão, o Ruby Evangelist Kakutani-san e o Rails Evangelist Matsuda-san têm promovido "kaigis" regionais, grupos como o **Asakusa.rb**, inspirados nos grupos de usuários americanos. Esse modelo também ajuda a formar bons palestrantes, oferecendo espaço para praticar diante de audiências menores, e só então ir para conferências maiores.

No Brasil, a comunidade Ruby começou tarde, cresceu rápido, e de repente já tínhamos uma conferência grande como o Rails Summit, quebrando um período importante em que as comunidades regionais poderiam ter crescido e amadurecido. Hoje temos comunidades regionais, mas poucas delas se reúnem presencialmente para apresentar ideias entre si com frequência. A maioria das comunidades menores só se encontra online em listas de e-mail. Então a maioria das pessoas nunca apresentou para audiências menores, nunca recebeu feedback, e não sabe se o conteúdo delas engaja ou não.

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/IMG_1569_original.jpg?1312544599)](http://gihyo.jp/news/report/01/rubykaigi2011/0002?page=5)

Minha recomendação: comunidades regionais são ótimas. Se você é de algum lugar do mundo onde elas não existem, por favor inicie uma. Começa sempre assim: com uma pessoa, talvez duas. Por um tempo você vai se sentir muito pequeno, mas persistência e consistência atraem pessoas e de repente você tem algumas dezenas. E você está praticando habilidades sociais, testando ideias, recebendo feedback direto.

Em São Paulo, existem empresas como o [Caelum Training Center](http://www.caelum.com.br) que sempre apoiaram pequenas comunidades. Eles disponibilizam mensalmente um espaço nas suas instalações para que o grupo regional de Ruby se reúna e apresente suas ideias pelo menos uma vez por mês. Dá pra notar a diferença na qualidade dos palestrantes que treinaram em grupos como esse. Não importa que não seja perfeito — não é pra ser. Você se exercita exatamente porque ainda não está bom. Já apresentei quase 100 vezes em eventos, e ainda estou muito ruim em vários pontos que preciso melhorar. A perfeição vem com a prática. E a prática vem com repetição e feedback. Grupos regionais de usuários são um ótimo lugar pra praticar.

## Keynote de Encerramento

A keynote de encerramento do Matz foi particularmente interessante. Foi a primeira vez que o vi falando ao vivo, e a primeira vez que o vi falar sobre algo diferente de Ruby 2.0 ou RiteVM. Ele falou sobre 4 tópicos diferentes: primeiro sobre sua carreira, depois sobre pêndulos, sobre PG e os próximos 100 anos — exatamente como o título da palestra descreve. Em geral, foi a visão dele sobre o futuro.

http://player.vimeo.com/video/26633560?portrait=0

[[18M10] Pendulum, PG, and the hundred year language](http://vimeo.com/26633560) from [rubykaigi](http://vimeo.com/rubykaigi) on [Vimeo](http://vimeo.com).

Como todos sabem, o Matz agora é membro da Heroku. Vai ter suporte oficial para contratar alguns committers do Ruby e montar uma equipe de tempo integral para manter o desenvolvimento da plataforma Ruby. Ele confirmou que não vai se mudar para San Francisco e que o ritmo de desenvolvimento do Ruby não deve mudar muito — pelo menos não de início. Vai continuar trabalhando como sempre fez, de Matsue, sua cidade natal, e continuará como pesquisador associado na NaCl, a empresa japonesa onde trabalha há cerca de 10 anos.

O primeiro desenvolvedor contratado como funcionário de tempo integral nessa equipe foi o notável **mr. Nakata Nobuyoshi**, o maior committer, superando até o Matz em commits no trunk do Ruby, e um dos desenvolvedores mais antigos e seniores do Ruby. Ótima escolha — e esperem para ver uma entrevista que gravei com ele. Ele tem contribuído no seu tempo livre pelos últimos 15 anos, um desenvolvedor extraordinariamente comprometido que raramente se vê nos dias de hoje.

![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/Screen%20Shot%202011-08-05%20at%207.25.12%20AM_original.png?1312539731)

Depois o Matz explicou que programadores japoneses gostam de construir suas próprias linguagens pequenas, como um hobby. Eventos de Lightweight Language acontecem há muito tempo. Até estudantes do ensino médio tentam construir suas próprias linguagens. E ele tem visto muitas tentativas em vários lugares. Seria interessante se a próxima linguagem mainstream surgisse daí. Mas ele também mencionou uma característica pessoal sua: "負けず嫌い", que significa que ele odeia perder. Falando assim pode soar duro, mas simplesmente significa que ele não é o tipo de pessoa que vai ficar parado esperando. Vai estar sempre buscando novas formas de melhorar o design da sua linguagem. Recebe o desafio de braços abertos — é o que ele quer dizer, em termos gerais.

Ele na verdade primeiro mencionou que é "大人げない" — literalmente "imaturo", mas mais no sentido de "não agir como se espera de um adulto" ou simplesmente "infantil". Foi divertido quando ele mergulhou na seção "PG" da palestra, mencionando o famoso ensaísta e empreendedor [Paul Graham](http://www.paulgraham.com/articles.html), cujos ensaios fantásticos são leitura obrigatória para qualquer programador sério. O Matz lembrou que o Paul Graham criou uma linguagem parecida com Lisp chamada Arc, mas ela não foi muito popular. Mas imaginando a linguagem dos 100 anos, poderíamos melhorar as linguagens atuais para chegar ao gosto do Paul Graham. E existe essa linguagem parecida com Lisp chamada Ruby, inventada por um cara chamado Matz, e essa linguagem é popular. Então, talvez como designer de linguagem, o Matz seja melhor que o Paul Graham? Claro que era brincadeira, mas foi muito interessante ouvir o próprio Matz fazendo esse comentário específico, mostrando seus lados "大人げない" e "負けず嫌い".

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/Screen%20Shot%202011-08-05%20at%207.04.39%20AM_original.png?1312539570)](http://vimeo.com/26633560)

Ele continuou falando sobre seus pensamentos a respeito da linguagem dos 100 anos — que algo como Ruby ainda estaria por aí. Com a tendência atual de evolução do hardware seguindo a Lei de Moore, não construiríamos linguagens apenas para fins de performance bruta, mas com o objetivo de serem hospitaleiras para os humanos. Então o seu recado final para as gerações futuras foi "大人げない大人になろう", que literalmente significa _"Seja um adulto imaturo"_ ou também _"não se leve tão a sério"_ — ou uma analogia ainda melhor é a frase do Steve Jobs no famoso [Discurso de Formatura de Stanford de 2005](http://www.youtube.com/watch?v=UF8uR6Z6KLc), onde encerrou dizendo "Stay Hungry, Stay Foolish". É um conselho parecido.

Logo antes disso, ele mencionou mais uma vez que _"Rivais são sempre bem-vindos, claro"_... _"Mas eu vou te esmagar!"_ :-) De novo, não levem isso a sério — era explicitamente para soar cômico.

E foi interessante porque por muito tempo a comunidade Ruby propagou o meme _"Matz is nice and so we are nice."_ Não lembro onde isso começou, mas acho que todo mundo que está na comunidade há algum tempo conhece. Por isso foi divertido ver esse outro _"lado sombrio"_ do Matz — "imaturo" e "que odeia perder". Isso é ótimo. Acho que esse lado não contradiz o outro — é só que podemos ser mais ferrenhos sem perder a gentileza.

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/matz_is_nice_original.jpeg?1312539523)](http://codezine.jp/article/detail/4194)

## (TL;DR) A Última RubyKaigi

Como já mencionei, esse grande evento é organizado pela vontade pura e esforço de um grupo de voluntários muito dedicados. Eles se juntam todo ano, nos últimos 6 anos, para montar esse evento incrível. Dá pra sentir que é diferente de um evento organizado por empresa como a RailsConf ou a RubyConf Brasil. Não me entenda mal — a qualidade está no mesmo nível ou é superior em muitos aspectos. É o clima que é diferente.

Depois da keynote de encerramento do Matz, o Takahashi-san fez um pequeno discurso final. Agradeceu a todos os patrocinadores, participantes e equipe voluntária. Foi muito bonito vê-los todos se reunindo no palco. Eu não tinha ideia de que o grupo de staff era tão grande. Me senti muito humilhado por aquele espetáculo, e eles mereciam cada aplauso.

http://www.youtube.com/embed/vaKfDkU6i0g

Mas a conferência deste ano nasceu de uma semente plantada no ano passado. Não sei até onde o Takahashi-san e os outros líderes pensaram nisso, mas se for metade do que especulo, acho que é uma atitude corajosa.

Antes de continuar, deixa eu apresentar outro desenvolvedor Ruby do Japão: o [Makoto Inoue](http://twitter.com/#!/makoto_inoue). Esse ano ele se voluntariou para ajudar os palestrantes estrangeiros a terem seus slides traduzidos para o japonês, facilitando o trabalho dos tradutores em tempo real durante as palestras (obrigado pela ajuda, Makoto-san!). Ele começou sua carreira em Ruby por causa do Rails alguns anos atrás e conseguiu uma boa posição na [New Bamboo](http://new-bamboo.co.uk/), em Londres, a empresa que também entregou o incrível serviço [Pusher](http://pusher.com/).

O Makoto também esteve presente no ano passado e escreveu seus pensamentos em dois artigos que você deve ler antes de continuar ([Parte 1](http://blog.new-bamboo.co.uk/2010/9/14/ruby-divide-at-rubykaigi-2010-and-what-can-you-do-as-a-rubyist-part-1), [Parte 2](http://blog.new-bamboo.co.uk/2010/9/19/ruby-divide-at-rubykaigi-2010-and-what-can-you-do-as-a-rubyist-part-2)). Na segunda parte ele menciona outro artigo originalmente escrito pelo [Shyouhei Urabe](http://twitter.com/shyouhei), um desenvolvedor do Ruby Core. Esse artigo se chama [RubyKaigi must die](https://github.com/makoto/japanese_fine_software_writings/wiki/Rubykaigi-must-die "once at least") e parece ter inspirado o Takahashi-san no tema da RubyKaigi 2011. Por achar importante destacar, vou citar o artigo aqui:

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/R1001138_original.JPG?1312544586)](http://blog.new-bamboo.co.uk/2010/9/14/ruby-divide-at-rubykaigi-2010-and-what-can-you-do-as-a-rubyist-part-1)

> **1: A qualidade da RubyKaigi é desnecessariamente alta**  
>   
> A taxa da Ruby Kaigi (JPY 6000 por 3 dias) é muito baixa considerando as taxas médias de conferências, mas a qualidade é muito alta. Precisamos pensar em como isso é possível. Me parece que depende demais de voluntários. É como se estivéssemos queimando a motivação desses voluntários como combustível. Fico preocupado que as pessoas se esgotem e que no fim não sobre nada. Não acho que comprar a motivação de alguém com dinheiro (= pagar pela equipe ou contratar empresa profissional de eventos) seja necessariamente ruim, especialmente se ajuda a sustentar a comunidade.  
>   
> Para ser franco, não existe uma estrutura para a RubyKaigi continuar. Isso porque não tínhamos certeza se a Kaigi continuaria quando começamos. Pensamos "vamos tentar". Continuamos por causa da boa resposta contínua, mas isso não é sustentável.  
>   
> **2: A RubyKaigi deveria ser um ponto de partida, não o objetivo**  
>   
> O propósito inicial da Ruby Kaigi era encontrar pessoas (que contribuíram para o Ruby ou usam Ruby de formas interessantes) e colocar os holofotes sobre elas. Deve haver tantos Rubyistas que se mantiveram em baixo perfil a menos que frequentassem a Ruby Kaigi. Concordo que isso é ótimo, mas não deveria ser o ponto de partida. A RubyKaigi é quase como um berço para Rubyistas, mas esse não é o objetivo final. Sinto que o número e a qualidade dessas pessoas começam a superar a RubyKaigi, e que ela vai se tornar uma restrição para as pessoas à medida que cresce.  
>   
> Como evitar isso? Precisamos de algum tipo de estratégia de escala — como aumentar a capacidade da Kaigi, realizá-la com mais frequência, ou incorporar a RubyKaigi como uma organização sustentável — mas não tenho certeza se há alguém que queira fazer isso. Então a alternativa vai para "Pare já!!".  
>   
> **3: A RubyKaigi não é assustadora?**  
>   
> Estava esperando que alguém dissesse isso em algum momento. Por que vocês sempre mencionam "Amor" ou se sentem bem, e todo mundo fica tão emocionado? Isso é assustador. Precisam se acalmar um pouco. Não é anormal? Se você começa a ouvir algo que soa suave demais, significa que há outra coisa por trás.  
>   
> Para ser brutalmente honesto, a RubyKaigi é um instrumento para algumas pessoas líderes agitarem outras pessoas — isso é o que chamamos de "culto". Pode não ser tão ruim. Dito isso, sou de dentro da comunidade (NOTA: o autor é um dos committers do Ruby core), então posso até estar subestimando esse fenômeno.  
>   
> Isso é perigoso, porque é sinal de febre temporária e as pessoas logo vão embora quando o hype passa. É ótimo que o Ruby tenha se tornado tão popular, mas precisamos pensar em como ter uma comunidade sustentável, então a febre adicional deve parar. Chegou a hora de esfriar um pouco.  
>   
> É isso. Se você continua dizendo "É muito difícil (organizar)" ou "(a organização da RubyKaigi) é muito frágil", então você deveria parar agora. A RubyKaigi não é toda a sua vida, não é?

Então, no discurso de encerramento da RubyKaigi 2010, eles anunciaram que 2011 seria a RubyKaigi Final. A ideia é fechar esse ciclo, se reorganizar e voltar. O Takahashi-san vai fundar uma organização adequada para ser a guardiã de uma nova conferência ainda sem nome que deve voltar provavelmente em 2013. Então 2012 será a primeira lacuna em 6 anos de RubyKaigi. Ainda não se sabe como isso vai se reorganizar, mas parece claro que não é o fim.

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/Screen%20Shot%202011-08-05%20at%208.46.54%20AM_original.png?1312544851)](http://rubycentral.org/)

Não levem tudo ao pé da letra — são palavras sábias que merecem reflexão. Fiquem atentos.

Já é uma grande conquista conseguir realizar seis conferências consecutivas como essa. Estive envolvido em três conferências consecutivas de tamanhos similares e posso apreciar o esforço. Disse que é uma atitude corajosa porque exige coragem desmontar algo assim. Uma vez que você começa e realmente gosta, é difícil largar. Mas por outro lado você precisa ir para o próximo nível quando chega no primeiro teto — e acho que a RubyKaigi cumpriu seu propósito.

Nos EUA, Chad Fowler, Rich Kilmer, David Black organizaram a primeira RubyConf em 2001 e logo depois fundaram a RubyCentral, uma organização sem fins lucrativos, para organizar as conferências seguintes e apoiar eventos regionais. Foi muito "americano" e uma jogada inteligente que compensou enormemente, especialmente com o apoio subsequente da O'Reilly e outras empresas. Estão entregando a 11ª RubyConf e acabaram de entregar a 6ª RailsConf. Os "pais fundadores" da Comunidade Ruby americana foram capazes de fomentar um **ecossistema** sustentável. Voltarei a esse assunto em outro artigo.

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/8/5/4935820587_2169342225_b_original.jpg?1312544730)](http://blog.new-bamboo.co.uk/2010/9/14/ruby-divide-at-rubykaigi-2010-and-what-can-you-do-as-a-rubyist-part-1)

Existem várias semelhanças entre as comunidades Ruby japonesa e brasileira, existem desafios específicos e há muitas coisas que aprendi pessoalmente na minha viagem. Vou compartilhar alguns desses insights nos meus próximos artigos. Por ora, vou encerrar minhas impressões sobre essa RubyKaigi Final dizendo que ela superou minhas expectativas e que realmente aprecio todo o esforço dedicado pela equipe para montar essa grande conferência — e desejo a todos boa sorte no retorno.

Parabéns!
