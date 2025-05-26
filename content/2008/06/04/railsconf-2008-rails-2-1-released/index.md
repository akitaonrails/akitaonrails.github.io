---
title: RailsConf 2008 - Rails 2.1 Released!
date: '2008-06-04T19:44:00-03:00'
slug: railsconf-2008-rails-2-1-released
tags:
- railsconf2008
- english
draft: false
---

No segundo dia, o keynote de abertura foi do Jeremy Kemper, um dos Core Mainteiners do Rails. Para mim o mais interessante foi o David Hansson explicando como ele entrou para a equipe. Lá por 2004, quando o Rails ainda era 0.7 ou 0.8, o Jeremy começou contribuindo. Mas não foi 1 ou 2 patches, foram pelo menos uns 20 patches, devidamente testados e documentados. Naquela época, quase 1/3 do código do Rails já era do Jeremy.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC05992.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05992&bgcolor=black)


Achei mais interessante porque o keynote de fechamento foi uma mesa redonda com os demais do Rails Core Team, não estavam todos, mas David, Koziarski, Rick e Jeremy estavam respondendo perguntas da platéia. Uma das perguntas foi algo do tipo _“Acho que REST é muito legal e tal, mas e quanto a SOAP? Acho que seria bom o ActiveWebService ser mais completo.”_ Eles concordam. _“Alguém aí se habilita a abraçar essa gem?”_ O motivo é simples: eles não precisam dela, mas há quem precise. Qualquer um que precise de SOAP poderia contribuir e se tornar o mantenedor.

O próprio Jeremy, em sua apresentação, deu as boas vinda ao [Pratik Naik](http://m.onkey.org/), que resolveu abraçar a proposta de melhorar a documentação do Rails e, graças a isso, se tornou um Core Committer também.

Outra pessoa perguntou algo como _“vocês do Core Team costumam observar o que os outros frameworks tem feito, por exemplo, Django, Seaside?”_ Todos disseram que sim, mas o David foi categórico: _“eu gosto muito de Seaside, algumas idéias acabam entrando, porém o objetivo do Rails não é copiar o que os outros estão fazendo. Se você acha que Seaside vai lhe beneficiar mais, por favor, use Seaside. Não há nenhum problema nisso. Aliás, não consigo entender todos esses outros frameworks tentando clonar Rails. Se quer usar Rails, use Rails. Isso não faz sentido algum!”_

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC05995.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05995&bgcolor=black)

Não sei se apenas com palavras consigo expressar o que eles quiseram dizer. Rails é um projeto open source que só está onde está graças à ajuda massiva da comunidade. Na apresentação do primeiro dia da “Andrea O.K. Wright”, ela discutiu sobre thread-safety. Um dos pontos que me chamou a atenção foi o projeto do Josh Peek em refatorar o código do Rails para que ele se torne verdadeiramente thread-safe. Seu mentor é o Core Maintainer Michael Koziarski. Vocês podem ver a aplicação dele [aqui](http://code.google.com/soc/2008/ruby/appinfo.html?csaid=AE462A3EF48107C3) e o seu fork no [Github](http://github.com/josh/rails/tree/master).

Novamente, volto a tocar no ponto dos _pundits_. Existem dois tipos de pessoas, as ativas e as acomodadas. As acomodadas todos conhecemos, e normalmente conhecemos mais do que gostaríamos porque muito fazem barulho, como um bando de urubus disputando a carniça. Os ativos normalmente conhecemos pouco, pessoas como Josh. Eles fazem a diferença porque identificam problemas e automaticamente resolvem fazer alguma coisa a respeito. E normalmente são bem sucedidos!

Um exemplo disso foi o [Fabio Kung](http://fabiokung.com/2008/05/31/jetty_rails-at-railsconf-2008/), da Caelum. Ele encontrou problemas na maneira como se desenvolver com JRuby hoje: tendo que usar o Warbler para gerar arquivos .war e ficar fazendo redeployment o tempo todo. Em tempo de desenvolvimento isso é, literalmente, um saco.

O Jeremy concorda com isso. Na parte final da sua apresentação ele começou mostrando as diversas implementações de Ruby rodando Rails, incluindo Rubinius, Yarv e, claro JRuby. Mas nesse último caso ele explicou a mesma dor de cabeça de deployment e explicou como Nick Sieger (um dos Core Maintainers do JRuby) lhe indicou o projeto [jetty-rails](http://jetty-rails.rubyforge.org/).

Daí, ele mostrou um slide com esse nome e mais, mostrou o bicho funcionando em tempo real! Mais um excelente exemplo de como os brasileiros se menosprezam, poucos acham que podem subir ao palco, mas o Fabio subiu, e com louvor, indicado pelo Jeremy e pelo Nick como uma excelente solução para JRuby. Que tal?

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06008.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06008&bgcolor=black)

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06009.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06009&bgcolor=black)

Quanto às novidades em si do Rails 2.1, o Jeremy foi bastante rápido e apenas pontuou as principais. Acho que todos que acompanham meu blog já sabem, uma vez que eu escrevi o tutorial completo faz algum tempo já. [Aqui](/2008/5/25/rolling-with-rails-2-1-the-first-full-tutorial-part-1) está a Parte 1 e [aqui](/2008/5/26/rolling-with-rails-2-1-the-first-full-tutorial-part-2) a Parte 2. Portanto não vou repetir tudo novamente :-)

Aliás, uma coisa que para mim foi muito gratificante, além dos brasileiros que encontrei por lá que me conheciam, ainda cruzei com diversos outros leitores, do Canadá, do México, do Uruguai, dos EUA mesmo. Foi muito engraçado porque nunca esperei que alguém lá fosse me chamar _“você é o Akita?”_ Foi mais interessante porque encontrei com esse uruguaio na hora do almoço e ele me disse _“Akita, o Obie está te procurando!”_ Eu pensei, _“caramba! Eu é quem estou procurando ele!”_

Fico muito contente que meu trabalho esteja sendo reconhecido lá fora também e espero que isso também ajude a trazer visibilidade para o Brasil. Já soube de algumas empresas e consultorias que enxergaram que podem contratar railers de boa qualidade aqui do Brasil.

E, pouco antes do último keynote, eu estava sentado no salão principal e, por coincidência, ainda consegui flagrar esta cena:

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06151.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06151&bgcolor=black)   
 Someone reading my Rails 2.1 tutorial. Anyone knows him?

How cool is that!?

E eu quase ia me esquecendo! No evento havia um “Speaker Lounge”, uma grande sala onde os conferencistas se reuniam. Eu, claro, com minha famosa ‘cara-de-pau’ andei invadindo essa sala várias vezes. Inclusive no primeiro dia ainda almoçamos junto com o David, o Koziarski e o pessoal do Phusion:

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/5/DSC05862.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05862&bgcolor=black)

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/5/DSC05863.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05863&bgcolor=black)

Mas eu estou mudando de assunto! Pois bem, depois da apresentação do Rails 2.1 do Jeremy, fui falar com o Chad Fowler quando presenciei esta cena na Speaker Lounge:

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/5/DSC06048.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06048&bgcolor=black)

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/5/DSC06049.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06049&bgcolor=black)

Parece que deu algum pau no empacotamento do Rails 2.1 em Gems. Estavam todos do Rails Core reunidos tentando resolver o pepino, incluindo Chad e Jim Weinrich. Eu chamei essa cena de _“Situation Room.”_ Quer algo mais _cool_ do que ter problemas com gems e poder recorrer diretamente e ao vivo com alguns dos maiores contribuintes ao sistema de RubyGems como Chad e Jim? Muito legal!

