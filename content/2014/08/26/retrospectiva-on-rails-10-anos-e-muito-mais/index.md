---
title: Retrospectiva on Rails - 10 Anos e Muito Mais!
date: '2014-08-26T16:17:00-03:00'
slug: retrospectiva-on-rails-10-anos-e-muito-mais
tags:
- retrospective
- rails
draft: false
---

Finalmente consegui fazer uma retrospectiva com os principais acontecimentos não só da última década de Ruby on Rails mas eventos em anos anteriores e durante que influenciaram nosso ecossistema de alguma forma significativa.

Como base eu pedi permissão ao [Luke Francl](http://luke.francl.org) que publicou o artigo original [Looking Backward: Ten Years on Rails](http://www.recursion.org/looking-backward/). Sobre ele, adicionei diversas novas datas que não estavam lá mas que foram significativas.

Certamente tem diversos outros que eu não coloquei ou me esqueci mesmo (vou adicionando aos poucos). Se quiserem contribuir eu [coloquei um Gist](https://gist.github.com/akitaonrails/2bda2df1f3252ff81fec) para que todos possam fazer fork e me mandar mudanças.

Quando vocês começaram a programar com Rails/Ruby e por que? Coloque nos comentários abaixo! Eu devo fazer um outro post separado também contando um pouco do meu começo com Rails mais pra frente.

### 1972 

* cerca de Janeiro - Lançado [Smalltalk-72](http://en.wikipedia.org/wiki/Smalltalk#History), a primeira versão usada em pesquisa.

### 1978 

* cerca de Janeiro - Pattern MVC criado pela primeira vez por Trygve Reenskaug na Xerox Parc.

### 1995 

* 21 de Dezembro - Ruby 0.95 é lançado. (Primeira versão pública)

### 1997

* 27 de Maio - Eric S. Raymond lança os artigos que se tornariam o livro [The Cathedral and the Bazaar: Musings on Linux and Open Source by an Accidental Revolutionary](http://www.catb.org/esr/writings/cathedral-bazaar/) que delineiam a revolução open source que ganhou fôlego na década de 90, principalmente depois que a combinação GNU/Linux começou a fazer sucesso.

### 1998 

* cerca de Janeiro - [XML-RPC](http://www.xml.com/pub/a/ws/2001/04/04/soap.html) é lançado, baseado no draft da especificação do protocolo SOAP.

### 1999

* cerca de Janeiro - SOAP (“Simple Object Access Protocol”) 1.1 é lançado. Ele se torna o jeito padrão de se fazer chamadas de web services em Java e .NET.

* 22 de Outubro - Dan Kegel escreve o canônico artigo [The C10K Problem](http://www.kegel.com/c10k.html) que se torna o marco para a implementação de I/O assíncrono nos diferentes sistemas operacionais para finalmente a web conseguir escalar. Isso se tornará as raízes de projetos como NGINX e Node.js no futuro.

* 30 de Outubro - The Pragmatic Programmer: From Journeyman to Master por Dave Thomas e Andy Hunt é publicado. Recomenda que programadores aprendam uma linguagem de scripting.

* cerca de Novembro - SourceForge é lançado, fornecendo CVS hosting de graça para projetos de código aberto.

### 2000	

* cerca de Janeiro - Roy Fielding define “REST” em sua dissertação de Ph.D.

* 10 de Março - A [bolha das ponto-com explode](http://en.wikipedia.org/wiki/Dot-com_bubble#The_bubble_bursts).

### 2001	

* cerca de Janeiro - Microsoft lança o Outlook Web Access, a primeira grande aplicação a usar a [biblioteca XMLHTTP](http://en.wikipedia.org/wiki/XMLHTTP) que vem no Internet Explorer.

* cerca de Janeiro - Programming Ruby (primeira edição) por Dave Thomas e Andrew Hunt é publicado.

* cerca de Fevereiro - Agile software manifesto é criado.

* cerca de Abril - State Software (empresa do Douglas Crockford) começa a trabalhar num “JavaScript Message Language” para intercâmbio de dados. É rapidamente renomeado para JSON.

* 22 de Outubro - Glyph Lefkowitz [lança o Twisted](http://twistedmatrix.com/pipermail/twisted-python/2002-August/001493.html), um dos primeiros frameworks de programação event-driven em Python. Node.js (lançado em 2009) seria um dos muitos sucessores que se seguiram ao Twisted.

### 2002

* cerca de Janeiro - website JSON.org é lançado.

* 11 de Fevereiro - Struts 1.0.2 é lançado.

### 2003

* cerca de Janeiro - Patterns of Enterprise Application Architecture por Martin Fowler é publicado; inclui a descrição do pattern Active Record.

* cerca de Janeiro - RubyForge é lançado para fornecer hosting para a comunidade Ruby; é baseado num fork da plataforma SourceForge.

* 7 de Dezembro - [PEP 333](http://legacy.python.org/dev/peps/pep-0333/) que define o Web Server Gateway Interface é publicado; ele fornece uma interface HTTP comum para frameworks web Python. 

* 5 de Fevereiro - [Basecamp é lançado](http://signalvnoise.com/archives/000542.php).

* 10 de Fevereiro - Flickr é lançado; sua animação de edição "yellow fade" é amplamente copiado.

* cerca de Março - Java Server Faces 1.0 é lançado; é o jeito "do futuro" para desenvolvimento de aplicações web em Java.

### 2004	

* 1 de Abril - [Google lança GMail](http://googlepress.blogspot.com/2004/04/google-gets-message-launches-gmail.html), demonstrando recarregamento ao vivo de aplicações web.

* 14 de Março - [Lançamento público inicial do Rubygems](https://github.com/rubygems/rubygems/blob/master/History.txt).

* 24 de Julho - [Primeiro lançamento do Ruby on Rails](http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/107370) (0.5)

<blockquote>
Eu venho falando (e propagandeando) Rails por tanto tempo que é estranho finalmente vê-lo no mundo. Imaginem vocês, ainda não estamos falando de um lançamento 1.0, mas o pacote atualmente em oferta é algo que eu me sinto bem confortável compartilhando com o mundo. Sem dúvida, poderia ter mais documentação e mais exemplos, mas Artistas de Verdade Entregam, e esta peça vai crescer em público. Aproveitem Rails!
</blockquote>

* 2 de Outubro - [DHH apresenta na Rails at RubyConf 2004](http://weblog.jamisbuck.org/2004/10/2/rubyconf-day-two). Francis Hwang [estima 60 pessoas na audiência](http://fhwang.net/2004/10/01/RubyConf-2004-Day-1).

* 5 de Outubro - a conferência apenas por convite Web 2.0 da O'Reilly populariza o termo "Web 2.0".

* 25 de Outubro - [Primeiro lançamento do Ruby on Rails como Rubygem](http://rubygems.org/gems/rails/versions) (0.8)

* 10 de Dezembro - [Google lança o Google Suggest](http://googleblog.blogspot.com/2004/12/ive-got-suggestion.html), que usa XMLHTTP para atualizar as sugestões de busca de forma assíncrona enquanto você digita. Desenvolvedores rapidamente fazem [engenharia reversa da técnica](http://serversideguy.blogspot.com/2004/12/google-suggest-dissected.html).

### 2005

* 1 de Janeiro - A Robot Co-op lança o 43 Things; o site é é um early adopter de Ruby on Rails.

* 20 de Janeiro - Rolling with Ruby on Rails é publicado.

* 27 de Janeiro - Carlos Riberio discute o problema dos frameworks web Python.

<blockquote>
No mundo Python, existem diversos frameworks web competindo. É interessante ver como muitos deles são muito mal documentados, ou nem mesmo documentados. Mas mesmo projetos que tem um bom volume de documentação ainda falham em endereça o problema do modelo mental. Um manual que toca somente em problemas práticos - principalmente, especificações de APIs - é perto de inútil nesse sentido.
</blockquote>
<blockquote>
Gostaria de ver mais esforços gastos na documentação dos problemas de arquitetura de um framework. Não somente 'como eu chamo este método', mas 'como eu estruturo minha aplicação'. Essa é a pergunta difícil, e a falta de uma resposta satisfatória para isso é normalmente uma boa razão para escrever mais outro framework.
</blockquote>

* 2 de Fevereiro - Primeira menção de Ruby on Rails no meu blog (do Luke Francl)

<blockquote>
A comunidade Java tem falado sobre esse Ruby on Rails por alguns meses já.

Hoje eu finalmente dei uma olhada nisso.
</blockquote>
<blockquote>
Parece bem legal. Um framework REST-ful para criar aplicações web dinâmicas com quantidade mínima de código. Escrever aplicações REST-ful com URLs limpas em outros frameworks pode ser uma enorme dor (experimente fazer isso só com servlets - você vai implorar por misericórdia).

Fora isso, o que eu gostei é que ele é uma stack inteira, integrada junto de maneira bonita. Isso é algo que eu realmente sinto falta em Python. Python tem um milhão de frameworks web, mas nenhum deles tem um pacote completo como Rails.
</blockquote>
<blockquote>
Considerei usar Python para alguns projetinhos meus, e eu ainda não encontrei o "melhor" framework web Python. Devo usar mod_python ou FastCGI? Qual mapeamento objeto-relacional é o melhor? Que linguagem de template devo usar? Qual framework de view vai me dar URLs bonitas, com bom SEO, que parecem profissionais? Finalmente, desses montes de frameworks, qual deles eu posso contar por uma comunidade ativa para boa documentação e suporte?
</blockquote>
<blockquote>
É uma puta dor de cabeça.
</blockquote>
<blockquote>
O mesmo problema se aplica ao mundo Java, mas lá você sempre pode se virar através do Servlet/JSP padrão, que tem suporte institucional da Sun, ou ir para frameworks como Struts, Spring, e Hibernate que tem milhares de desenvolvedores, boa documentação, livros publicados, etc.

Mas no fim ... será que Rails vale o preço de ter que aprender Ruby? Hmmm ...
</blockquote>

* 5 de Fevereiro - Sam Stephenson lança o [Prototype.js](http://en.wikipedia.org/wiki/Prototype.js)

* 8 de Fevereiro - [Google Maps lança](http://en.wikipedia.org/wiki/Google_Maps#History) para Internet Explorer e Firefox, redefinindo o nível de interação possível em um web browser.

* 15 de Fevereiro - Jesse James Garrett [cunha o termo Ajax](http://www.adaptivepath.com/ideas/ajax-new-approach-web-applications/) para descrever as novas aplicações web ricas como Flickr, Google Suggest, ou Google Maps.

* 16 de Fevereiro - Rodrigo Caffo cria a primeira mailing list brasileira de Rails, a [Rails-BR](https://groups.google.com/forum/#!forum/rails-br)

* 7 de Abril - [Lançamento inicial](http://en.wikipedia.org/wiki/Git_(software)) do sistema de controle de versão distribuída git.

* 2 de Julho - David Heinemeier Hansson grava o demo do blog de 15 minutos, demonstrando a velocidade do desenvolvimento rápido com Rails.

* cerca de Julho - Lançamento inicial do [Groovy on Grails](http://en.wikipedia.org/wiki/Grails_(framework)), um framework inspirado no Rails para a linguagem Groovy que roda na JVM.

* 7 de Julho - [script.aculo.us 1.0.0](http://en.wikipedia.org/wiki/Script.aculo.us) é [lançado](http://script.aculo.us/dist/), tornando fácil adicionar os efeitos de estilo Web 2.0 às suas aplicações.

* 21 de Julho - [Django é lançado](http://www.djangobook.com/en/2.0/chapter01.html#django-s-history) depois de ficar em desenvolvimento por mais de 2 anos.

* cerca de Agosto - Locomotive é lançado; torna fácil a configuração de um ambiente de desenvolvimento Rails no Mac.

* 4 de Agosto - Agile Web Development with Rails, primeira edição publicada.

* 20 de Agosto - [Foundations of Ajax](http://www.amazon.com/gp/product/1590595823/) publicado; um livro inteiro sobre como usar Ajax.

* 26 de Outubro - Primeiro encontro do [Ruby Users de Minnesota](http://ruby.mn/) (Luke).

* 3 de Dezembro - Conferência [Snakes and Rubies](https://www.djangoproject.com/weblog/2005/dec/04/snakes_and_rubies/) trás juntos os criadores do Django e do Rails ([video](https://www.youtube.com/watch?v=cb9KDt9aXc8)).

* 13 de Dezembro - [Rails 1.0 é lançado](http://weblog.rubyonrails.org/2005/12/13/rails-1-0-party-like-its-one-oh-oh/).

### 2006

* 21 de Março - Jack Dorsey [posta primeiro tweet](http://en.wikipedia.org/wiki/Timeline_of_Twitter): “[just setting up my twttr](https://twitter.com/jack/status/20)”

* 23 de Março - Eustáquio Rangel [lança primeiro livro de Ruby](http://eustaquiorangel.com/posts/255) no Brasil.

* 5 de Abril - Escrevo [meu primeiro post](http://web.archive.org/web/20060707015239/http://balanceonrails.blogspot.com/2006/04/bem-vindos.html) no que viria a se tornar o blog AkitaOnRails.com.

* 22 de Junho - A primeira RailsConf acontece em Chicago.

* 30 de Junho - Hamptom Caitlin sobe o [primeiro commit do SASS](https://github.com/sass/sass/commit/35f7e17de5485e1e21e731297761b670a8fddce2#diff-d41d8cd98f00b204e9800998ecf8427e) e inicia uma nova era de meta-linguagens para tornar possível codificar decentemente em linguagens ruins como CSS.

* 5 de Julho - [JRuby 0.9 consegue rodar](http://en.wikipedia.org/wiki/JRuby#Ruby_on_Rails) Rails.

<blockquote>
Vamos ver até onde essa comunidade pode chegar. 

Ruby on Rails poderá ser muito ou nada, tudo vai depender de como o mercado vai encarar a novidade. Mas muita coisa pode ser feita agora. Para começar, aprendendo sobre o assunto.

Vou postar os principais assuntos sobre a plataforma aqui e espero que todos colaborem com idéias e sugestões ou mesmo críticas e opiniões.

Infelizmente ainda existem muitos desafios a serem vencidos. Para começar, materiais de Rails em português virtualmente inexistem. Sites brasileiros idem. Portanto quando digo "começar do zero", estou falando sério.

O maior desafio será convencer o mercado. E isso não se faz da noite para o dia. Significa que ainda não será possível deixar o legado do Java totalmente de lado. Vamos começar um período de transição onde tentaremos as duas coisas em paralelo.
</blockquote>
<blockquote>
Os pioneiros sempre caminham por território árduo, mas a recompensa dos primeiros sempre será maior também. Esse é o sentido do investimento.
</blockquote>

* 29 de Julho - Django 0.95 é lançado, incluindo mudanças de "remoção de mágica".

* 25 de Agosto - Amazon Web Services lança o Elastic Compute Cloud (EC2) e inicia de fato a Era do "Cloud Computing" como conhecemos hoje.

* 26 de Agosto - John Resig lança o jQuery

* 6 de Outubro - Meu livro ["Repensando a Web com Rails" saiu da gráfica](http://www.akitaonrails.com/2006/10/06/nasceu#.U_zUFbxdVqc), o primeiro de Rails no Brasil.

* 9 de Outubro - Ronaldo Ferraz lança o [primeiro grande tutorial](http://logbr.reflectivesurface.com/2006/10/09/rails-para-sua-diversao-e-lucro/) de Rails no Brasil.

* cerca de Outubro - Merb 0.03 é lançado ("Mongrel+Erb")

* 11 de Dezembro - Eu (Luke) começo novo emprego com Rails.

### 2007

* 9 de Janeiro - O mundo da tecnologia recebe um novo marco: [o lançamento do primeiro iPhone](https://www.apple.com/pr/library/2007/01/09Apple-Reinvents-the-Phone-with-iPhone.html).

* 18 de Janeiro - [Rails 1.2 lançado](http://weblog.rubyonrails.org/2007/1/18/rails-1-2-rest-admiration-http-lovefest-and-utf-8-celebrations/) com RESTful resources.

* 20 de Fevereiro - [Christian Neukirchen define a interface Rack](http://chneukirchen.org/blog/archive/2007/02/introducing-rack.html), inspirado pelo WSGI.

* 16 de Maio - Eu inicio meu [primeiro emprego](http://www.akitaonrails.com/2007/05/16/novidade-akita-na-surgeworks#.U_zcC7xdVqc) oficial como Railer full-time na Surgeworks.

* cerca de Abril - Inicia a famigerada [controvérsia do "Rails não Escala"](http://www.akitaonrails.com/2007/04/15/a-polemica-twitter#.U_zWxbxdVqc) iniciada pelo Alex Payne, do Twitter. Essa controvérsia seguiria o Rails por anos (finalmente nos livramos disso!)

* cerca de Maio - Framework Play para Java é lançado.

* 4 de Outubro - Lançamento inicial do microframework Sinatra; ele é largamente copiado em outras linguagens.

* 19 de Outubro - Chris Wainstraith e Tom Preston-Werner [começam a trabalhar no GitHub](http://tom.preston-werner.com/2008/10/18/how-i-turned-down-300k.html).

* 22 de Outubro - A primeira vez que organizo um evento, em São Paulo, o [RejectConf SP](http://www.akitaonrails.com/2007/10/19/rejectconf-sp-07-lotado#.U_zU-bxdVqc) que teve praticamente todos os nomes do Ruby brasileiro que você reconhece até hoje como Carlos Brando (Enjoei), Danilo Sato (ThoughtWorks), Fabio Kung (Heroku), Vinicius Teles (HE:Labs), Carlos Villela (ThoughtWorks), George Guimarães (Plataformatec) e [mais](http://www.akitaonrails.com/2007/11/14/rejectconf-sp-07-palestrantes).

* cerca de Dezembro - Rails 2.0 é lançado.

### 2008

* 1 de Janeiro - o primeiro grande RubyDrama acontece com a [declaração bombástica de Zed Shaw](http://www.akitaonrails.com/2008/01/01/zed-shaw-vs-rails#.U_zWlrxdVqc) de sua saída da comunidade Ruby.

* 1 de Janeiro - Heroku recebe seu [primeiro seed de USD 20k](http://www.crunchbase.com/funding-round/6f177c5b43b5ef7cd178d2a60b4858dd) da Y/Combinator.

* 2 de Abril - Desenvolvimento do Rails [move para o GitHub](http://weblog.rubyonrails.org/2008/4/2/rails-is-moving-from-svn-to-git/).

* 10 de Abril - [GitHub lança](https://github.com/blog/40-we-launched) fora do beta.

* 1 de Junho - Lançados o [Ruby Enterprise Edition e Phusion Passenger](http://www.akitaonrails.com/2008/06/04/railsconf-2008-phusion-passenger-enterprise-edition-unleashed#.U_zXaLxdVqc). Pela primeira vez ganhamos uma forma robusta de fazer deployment de aplicações Rails e rodar múltiplos processos Ruby (na versão 1.8.6 ainda!) usando menos recursos do servidor.

* 15 de Outubro - Organizei o primeiro grande evento de Rails do continente, o [Rails Summit Latin America 2008](http://www.akitaonrails.com/2008/07/04/est-chegando-a-hora-rails-summit-brazil-2008), no Auditório Elis Regina, no Anhembi em São Paulo. Tivemos ninguém menos que Chad Fowler, Ninh Bui, Hongli Lai, David Chelimsky, Chris Wanstrath, Dr. Nic Williams, Obie Fernandez e mais. Ninguém achava a) que um evento desses fosse possível, nem b) que ele seria **consistente** e perduraria até hoje (2014)!

* 23 de Dezembro - [Merge do Rails/Merb anunciado](http://weblog.rubyonrails.org/2008/12/23/merb-gets-merged-into-rails-3/); equipe do Merb se junta ao Rails core team.

### 2009	

* 16 de Março - [Rails 2.3 é lançado](http://weblog.rubyonrails.org/2009/3/16/rails-2-3-templates-engines-rack-metal-much-more/); Rails agora é uma aplicação Rack.

* 27 de Maio - [Lançamento inicial do Node.js](http://en.wikipedia.org/wiki/Node.js), um ambiente de programação web para a máquina virtual V8. Ela permite que programadores escrevam Javascript client side e server side.

* 13 de Dezembro - Jeremy Ashkenas sobe o primeiro commit do [Coffeescript](http://www.akitaonrails.com/2010/03/27/brincando-com-coffee-script#.U_zYx7xdVqc), um dos primeiros transpilers para tentar tornar programar em Javascript algo mais agradável.

### 2010	

* 1 de Agosto - Rails 3.0 lançado com contribuições do Merb core team; havia passado um ano desde o lançamento do Rails 2.3.

* cerca de Abril - Steve Jobs publica o prego no caixão do Adobe Flash com o artigo [Thoughts on Flash](https://www.apple.com/hotnews/thoughts-on-flash/) e sedimenta o caminho para HTML 5 + CSS 3 + Javascript não só em dispositivos móveis mas também em desktops. O Flash se tornou um morto-vivo desde então.

### 2011

* 12 de Julho - Criador do Ruby, Yukihiro Matsumoto (Matz), é [contratado pelo Heroku](https://blog.heroku.com/archives/2011/7/12/matz_joins_heroku).

* 31 de Agosto - [Rails 3.1 é lançado](http://weblog.rubyonrails.org/2011/8/31/rails-3-1-0-has-been-released/); jQuery agora é a biblioteca Javascript padrão.

* 19 de Setembro - Anuncio a criação da minha primeira empresa de desenvolvimento de software própria, a [Codeminer 42](http://www.akitaonrails.com/2011/09/19/off-topic-minha-carreira-fase-5-codeminer-42#.U_zcNrxdVqc)

### 2013

* cerca de Junho - Rails 4.0 é lançado com funcionalidades como Turbolinks e caching para tentar fazer aplicações web "clássicas" tão rápidas quanto aplicações com front-end baseado em Javascript.
