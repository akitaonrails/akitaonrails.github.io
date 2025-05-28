---
title: Locos x Rails Wrap up
date: '2009-04-07T13:55:00-03:00'
slug: locos-x-rails-wrap-up
tags:
- locosrails2009
draft: false
---

 **Brasileiros:** tradução [abaixo](/2009/04/07/locos-x-rails-wrap-up#locosxrails_pt_br).

[![](http://s3.amazonaws.com/akitaonrails/assets/2009/4/7/logo-locosxrails_original.png)](http://www.locosxrails.com)

This last weekend I had a wonderful time in Buenos Aires, Argentina, at the [Locos x Rails](http://locosxrails.com) event which I think is the first big Ruby and Rails community gathering there. They did an extraordinary job making a very compelling and exciting event that I am sure people liked a lot. I don’t have any official numbers but I think there were more than a 100 attendees and a stellar international speaker roster including Obie Fernandez, Desi McAdam, Yehuda Katz, Evan Phoenix, Evan Henshaw Plath.

<script type="text/javascript">
    jwplayer('playerJYcQgeMyOwiq').setup({
        file: 'https://s3.amazonaws.com/videos-akitaonrails/Akitaonrails-LocosXRails760.flv',
        title: 'Locos x Rails (2009)',
        width: '100%',
        aspectratio: '4:3',
        fallback: 'false'
    });
</script>

<small>(see it on <a href="http://www.youtube.com/watch?v=14VPW7PucqQ&feature=player_embedded">YouTube!</a> as well)</small>


In the first day we had Obie Fernandez opening keynote where he presented the same talk he did at Rails Summit in Brazil, about the 4 Agile principles and the “Hashrocket-way” on implementing them. As always, a very inspiring talk. Then Fabián Ramírez, from Chile, talked about Ruby on Rails on real projects with his real life experiences and why companies should be looking seriously toward adopting Rails. Evan Henshaw Plath (aka Rabble), from ENTP, followed with an explanation on privacy issues on the Web and the OAuth solution toward web services interoperability and authorization.

After lunch, Carla Ares and Claudio Zamoszczyk demonstrated how to control Arduino hardware using Ruby – and for those who are interested, Randal Schwartz recently interviewed Massimo Banzi, co-founder of Arduino in the [FLOSS Weekly podcast](http://twit.tv/floss61). Evan Phoenix, from Engine Yard, didn’t talk about Rubinius this time, but his talk was nonetheless important because he was pointing out code smells in Ruby (such as using ‘rescue nil’), I think it was very informative. And the first day closed with a video conference with David Hansson himself, answering the audience’s questions. Unfortunately this session had some internet connection drawbacks but all in all I think the audience was able to have a good chat with DHH.

The second day opened with Luis Lavena talking about Ruby cross compatibility, the One-Click Ruby Installer challenges and his Rake compiler project, which allows even Linux developers to cross compile Windows compatible binaries. After that Emilio Tagua, who is also a Rails Core Contributor, talked about ruby-debug and techniques on debugging Rails applications. Nicolás Sanguinetti gave an introduction about Sinatra and non-Rails light web frameworks. Desi McAdam, also from Hashrocket and leader for [devchix.com](http://www.devchix.com/), gave a tutorial on how to create web applications with Rails for Facebook, using the Facebooker gem.

After lunch we had Adrian Mugnolo, one of the organizers, replacing Ben Scofield – who unfortunatelly was unable to fly to Argentina. Adrian talked about Sequel as an alternative to ActiveRecord to talk to databases. Chad DePue followed talking about ActiveResource and Restful web services in Rails. Finally, we had the final talk with Yehuda Katz, also from Engine Yard, who talked about the Rails and Merb merge, the challenges and what we should expect. His main point: merging Rails and Merb does not end healthy competition in the community: on the other hand, it should increase it, but instead of focusing on big chunks as an entire web framework, people can compete on smaller pieces such as ActiveRecord vs DataMapper vs Sequel. He did a great job on explaining the evolution of the merge.

To finish the event, Tom Aadland conducted a raffle of 10 books from O’Reilly. All in all, I think this event was very well organized, the talks were compelling, the audience was full of Railers, we had real-time translators from English to Spanish as well so I think no one missed anything. They also recorded all the talks and they will release it very soon. Follow them at Twitter as [@locosxrails](http://twitter.com/locosxrails) and their [website](http://locosxrails.com). Congratulations to all the organizers and staff for a well done event, and we hope to see you all, first at Rails Summit in Brazil this year, and again in Argentina next year!

## Locos x Rails

Este último fim de semana tive uma excelente estadia em Buenos Aires, Argentina, no evento [Locos x Rails](http://locosxrails.com) que eu acho que foi o primeiro grande encontro da comunidade Ruby e Rails de lá. Eles fizeram um trabalho extraordinário criando um evento interessante e empolgante que tenho certeza que as pessoas gostaram. Não tenho números oficiais mas acho que foram mais de 100 pessoas além de uma seleção internacional estelar incluindo Obie Fernandez, Desi McAdam, Yehuda Katz, Evan Phoenix, Evan Henshaw Plath.

[Locos x Rails](http://www.slideshare.net/akitaonrails/locos-x-rails?type=presentation "Locos x Rails")<object style="margin:0px" width="425" height="355"><param name="movie" value="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=locos-090407161915-phpapp02&stripped_title=locos-x-rails">
<param name="allowFullScreen" value="true">
<param name="allowScriptAccess" value="always">
<embed src="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=locos-090407161915-phpapp02&stripped_title=locos-x-rails" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="355"></embed></object>
View more [presentations](http://www.slideshare.net/) from [Fabio Akita](http://www.slideshare.net/akitaonrails).

No primeiro dia tivemos Obie Fernandez abrindo com a mesma palestra que ele fez no Rails Summit no Brasil, sobre os 4 princípios Ágeis e a “maneira Hashrocket” de implementá-las. Como sempre, uma palestra inspiradora. Então Fabián Ramírez, do Chile, falou sobre projetos reais de Ruby on Rails com suas experiências reais e porque empresas devem olhar seriamente em adotar Rails. Evan Henshaw Plath (Rabble), da ENTP, seguiu com uma explicação sobre problemas de privacidade na Web e a solução OAuth interoperabilidade de serviços web.

Depois do almoço, Carla Ares e Claudio Zamoszczyk demonstraram como controlar hardware Arduino usando Ruby – e para os interessados, Randal Schwartz recentemente entrevistou Massimo Banzi, co-fundador do Arduino no [podcast FLOSS Weekly](http://twit.tv/floss61). Evan Phoenix, da Engine Yard, não falou sobre Rubinius desta vez, mas sua palestra foi muito importante porque ele explicou sobre código ruim em Ruby (como usar ‘rescue nil’), eu acho que foi muito informativo. E o primeiro dia fechou com uma vídeo conferência com o David Hansson, respondendo perguntas da platéia. Infelizmente essa sessão teve alguns problemas de conexão mas no final acho que a platéia teve chance de ter uma boa conversa com o DHH.

O segundo dia abriu com Luis Lavena falando sobre compatibilidade de Ruby em múltiplas plataformas, os desafios do One-Click Ruby Installer e seu projeto Rake Compiler, que permite até a desenvolvedores em Linux de compilar binários compatíveis com Windows. Depois disso Emilio Tagua, que também é Rails Core Contributor, falou sobre ruby-debug e técnicas de debugging em aplicações Rails. Nicolás Sanguinetti deu uma introdução sobre Sinatra e web frameworks leves não-Rails. Desi McAdam, também da Hashrocket e líder do [devChix.com](http://www.devchix.com/), deu um tutorial sobre como criar aplicações web com Rails, para Facebook, usando a gem Facebooker.

Depois do almoço tivemos Adrian Mugnolo, um dos organizadores, substituindo Ben Scofield – que infelizmente não conseguiu chegar a tempo por problemas aéreos. Adrian falou sobre Sequel como uma alternativa para ActiveRecord para conversar com bancos de dados. Chad DePue seguiu palestrando sobre ActiveResource e serviços web Restful em Rails. Finalmente, tivemos a palestra final com Yehuda Katz, também da Engine Yard, que falou sobre o merge do Rails com Merb, os desafios e o que deveríamos esperar. Seu principal ponto: mesclar Rails e Merb não acaba com a competição saudável na comunidade: do contrário, deve aumentá-la, mas em vez de focar em pedaços grandes como um framework web inteiro, as pessoas devem competir em pedaços menores como ActiveRecord vs DataMapper vs Sequel. Ele fez um bom trabalho explicando a evolução do merge.

Para finalizar o evento, Tom Aadland conduziu um sorteio de 10 livros da O’Reilly. No geral, acho que o evento foi muito bem organizado, as palestras foram interessantes, a platéia estava cheia de Railers, tivemos tradutoras em tempo real de Inglês para Espanhol então acho que ninguém perdeu nada. Eles também gravaram todas as palestras e devem lançá-las em breve. Siga-os no Twitter como [@locosxrails](http://twitter.com/locosxrails) e seu [website](http://locosxrails.com). Parabéns aos organizadores e equipe por um evento bem feito, e esperamos vê-los todos, primeiro na Rails Summit no Brasil este ano, e novamente na Argentina ano que vem!

