---
title: RailsConf 2008 - Phusion Passenger Enterprise Edition Unleashed!
date: '2008-06-04T15:01:00-03:00'
slug: railsconf-2008-phusion-passenger-enterprise-edition-unleashed
tags:
- railsconf2008
- passenger
- english
draft: false
---

Uma das parcerias mais engraçadas que já fiz até então foi com o pessoal da Phusion. Desde que os [entrevistei](http://www.akitaonrails.com/2008/5/7/chatting-with-hongli-lai-and-ninh-bui-phusion) algumas semanas atrás meio que fizemos amizade e trocamos idéias o tempo todo via IM.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06130.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06130&bgcolor=black)

Desde então eles fizeram várias coisas:

- Lançaram a primeira versao do Phusion Passenger (a.k.a. mod\_rails)
- Lançaram o quiz do [Ruby Enterprise Edition](http://www.rubyenterpriseedition.com)
- Lançaram a campanha de doação para ganhar licenças Enterprise Edition.

O que vocês vão ler agora é o _Inside Story_ de como muitas dessas coisas aconteceram :-)


Foi engraçado porque nossa comunidade brasileira foi a primeira a identificar que as licenças na realidade eram de mentira :-) Por alguma razão ninguém blogou sobre isso até agora e eu também segurei porque eles pediram (vocês não imaginam como é difícil para um blogueiro segurar uma informação como essas que vou contar!!). Se não me engano começou com o [**Julio Monteiro**](http://www.monteiro.eti.br/), que havia doado via duas empresas diferentes e, por isso recebeu duas vezes a licença, mas aí veio o interessante: duas licenças iguais a esta:

> 08abe6e5d8ae5e932e4a2808b484e41c

O script [passenger-make-enterprisey](http://github.com/FooBarWidget/passenger/tree/master/bin/passenger-make-enterprisey) mostra claramente que isso é nada mais nada menos do que o digest MD5 da string:

> Saying “Rails doesn’t scale” is like saying “my car doesn’t go infinitely fast”.

Eles me contaram que estão tirando muito sarro de quem fala _“Rails não escala”_. É uma não-afirmação (non-statement). E ao mesmo tempo estão tirando sarro das pessoas “enterprisey” que, para considerar um produto a sério, precisam pagar por ele e receber uma “chave-secreta” que ninguém mais tem. Fala sério, ninguém suspeitou de um script “make enterprisey”?? Eu falei com o Ninh sobre isso e ele confirmou que ninguém mais tinha descoberto/publicado sobre isso.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC05883.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05883&bgcolor=black)  
A Phusion pegando dicas  
com Jim Weinrich

Portanto, a versão 1.0.5 que estava no ar até então, obviamente, não continha o “Enterprise Edition”. Ela foi liberada primeiro para os que doaram e estavam presentes na platéia. Eles haviam prometido liberar a versão 2.0 poucas horas depois da apresentação, mas eles não só não tiveram muito tempo como também a internet no evento estava meio ‘lenta’, vamos dizer. Portanto, os que doaram antecipadamente receberam uma versão em DVD e devem ser os únicos que já puderam testar em produção. Conforme eles explicam no [blog deles](http://blog.phusion.nl/2008/06/02/railsconf-2008-was-great/) quem quiser já ainda não tem as gems oficiais mas já pode baixar do [github](http://github.com/FooBarWidget/passenger/tree/master) deles.

Durante nossas conversas via IM surgiu a idéia de eu fazer uma aparição surpresa durante a apresentação (um _cameo_). Eles apresentariam o Passenger, daí abririam para uma sessão falsa de perguntas e respostas, eu levantaria a mão e eles me “escolheriam”. Nesse instante seria revelado o primeiro grande segredo:

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06121.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06121&bgcolor=black)

Minha pergunta foi algo assim: _“mod\_rails é legal mas muitos criticam dizendo que o futuro do desenvolvimento web com Ruby requer Rack. O que vocês tem a dizer sobre isso?”_

Todo mundo deu risada porque o slide seguinte foi assim:

![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/Picture_5.png)

E a resposta no slide seguinte foi: _“Não, Passenger não **vai** suportar Rack … "_, e no terceiro slide: _“… porque ele **já** suporta!”_

Poucas pessoas pessoas sabiam disso, incluindo eu e ninguém menos do que **Ryan Bates** que fez um screencast sobre o suporte a Rack, demonstrando neste vídeo:

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Akitaonrails-PhusionPassengerTheReturnOfRyanBates712.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Akitaonrails-PhusionPassengerTheReturnOfRyanBates712.mp4)
</source></video>

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06116.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06113&bgcolor=black)

Muita gente reclamou disso sobre o “mod\_rails”. O próprio Ezra comentou [neste post](http://brainspl.at/articles/2008/04/25/hey-rails-nice-rack)

> As far as mod\_rails goes… I think they made a huge mistake by not using rack as their interface, so I’d hope they will realize this and add rack support.

Parece que as preces deles foram atendidas. Esta [outra discussão](http://www.eribium.org/blog/?p=188) mostra como as pessoas assumem coisas sem saber como elas são feitas. O próprio Hongli Lai comentou que suportar Rack seria mais difícil do que Rails. Passenger não é apenas um conector burro de Apache para Rails, ele faz muito mais:

> “Rails-specific framework pre-loading logic” is clearly explained in our [architectural overview](http://www.modrails.com/documentation/Architectural%20overview.html). It explains what it is, the motivation behind it, and how it works.  
> In a nutshell: it can decrease Rails spawn time by as much as 90%. On a busy web host where spawn time is normally 25 seconds, it can be brought down to 2.5 seconds. Preloading also makes memory sharing between processes possible.

Duas coisas importantes que o Passenger faz é trazer o tempo de startup uma ordem de grandeza para baixo. Isso é relevante porque num shared hosting você quer que processos que não estão sendo usados sejam derrubados para economizar memória, mas quando forem necessário você não quer que seu usuário espere mais de 20 segundos para carregar uma nova instância. O spawner deles consegue diminuir absurdamente esse tempo de loading porque ele sabe que muita coisa entre instâncias é exatamente igual e, portanto, pode ser colocado num cache. O [documento de arquitetura](http://www.modrails.com/documentation/Architectural%20overview.html) deles explica isso em detalhes.

A segunda coisa é [copy-on-write](http://en.wikipedia.org/wiki/Copy-on-write), que o Hongli já havia blogado a respeito em seu blog. Essencialmente um mongrel\_cluster faz as coisas na força bruta: cada instância mongrel sobe uma cópia do framework Rails e da sua aplicação, duplicando tudo em memória. Ou seja, se você tem memória sobrando, tanto faz, mas normalmente nós queremos economizar o máximo possível.

O Passenger é esperto em relação a isso: ele sobre a primeira instância Ruby/Rails e as seguintes são forks da primeira. Se a primeira consome 50Mb de RAM da segunda em diantes se consome quase **zero**. Claro, à medida que a aplicação é exercitada, partes da aplicação precisará ser ‘copiada’ em outro espaço de memória isolado para que possa ser ‘sobrescrita’. Na prática, isso pode significar uma economia de pelo menos 1/3 da memória consumida total. Veja este slide sobre memória:

![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/Picture_1.png)

E não é só isso, devido às diversas otimizações que eles fizeram, isso também tornou usar Passenger mais rápido do que a concorrência. Vejam este slide sobre performance:

![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/Picture_2.png)

Ou seja, ele é mais rápido até mesmo do que Nginx + Thin, e mais do que isso: ele consome menos memória e roda mais rápido sobre Apache, que nunca foi um bom exemplo de baixo consumo de memória nem de performance. E ainda mais: diferente de um mongrel\_cluster você não precisa limitar a quantidade de processso, não precisa se preocupar em subir uma instância caso ela dê crash por alguma razão, o Passenger faz tudo isso e com o plus de que cada nova instância que ele carrega, sobe com uma ordem de grandeza mais rápido do que a primeira, graças ao spawner.

A estratégia desses garotos foi muito boa: muita gente pediu para que eles lançassem uma versão alpha muito antes do tempo. Porém isso seria **burrice** , porque daí eles teriam que perder tempo com dúzias de bug reports com coisas que eles já sabiam que teriam que resolver. Daí, em vez de gastar o tempo corrigindo esses bugs, teriam que perder tempo gerenciando as pessoas.

Eles trabalharam com alguns parceiros com a [Soocial](http://www.soocial.com/), [iLike](http://www.ilike.com), [Dreamhost](http://www.dreamhost.com). Para quem usa sites sociais como Facebook já deve conhecer a iLike, que é uma aplicação Rails com mais de 20 milhões de usuários e que contabiliza centenas de milhões de page views mês e, agora, tudo rodando sobre Passenger.

Outra coisa que surgiu literalmente como uma brincadeira via IM acabou virando algo interessante na apresentação. Muitos brasileiros que me acompanham no Twitter viram quando eu lancei uma tirada que é: _“A arma secreta do Python contra o Ruby: Leah Culver!”_ Muita gente entrou na brincadeira, o Fabio Kung não sabia sobre ela e tirou sarro no Twitter também. Foi engraçado :-)

Mas o Ninh Bui, da Phusion, também não sabia! E para os que ainda estão sem entender do que se trata, [**Leah Culver**](http://www.flickr.com/photos/tags/leahculver/) é praticamente uma lenda viva! Ela é uma jovem **programadora** de 25 anos e Líder do projeto [Pownce](http://www.pownce/com) de Kevin Rose. Sinceramente, eu **nunca** vi uma programadora linda como ela. Isso não existe, é praticamente uma Lei dos Programadores: _“mulheres bonitas nunca serão programadoras.”_ Porém, ela programa em **Python** , e o Pownce é feito em Django.

Portanto, Ninh disse nos slides:

![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/Picture_3.png)

Sobre isso eu quero meus créditos! :-) hehehe. Na realidade eles já pretendiam colocar suporte a WSGI (que é o que o Django usa, por exemplo), mas por causa disso esse suporte ganhou nova prioridade e, em 2 dias, Passenger já suportava WSGI. Ele disse que mandou e-mail pra Leah, mas ainda não teve resposta. Boa sorte!

Claro, Passenger primariamente foi feito para suportar Rails. Diversas inteligências como o spawner, o copy-on-write, dependem exclusivamente do comportamento de dependencies do Rails. Portanto para obter os números dos slides anteriores, considere sempre Rails. Como o Hongli disse, apenas o Rack não é suficiente para ‘adivinhar’ esse tipo de detalhes.

Tanto Rack quanto WSGI ainda vão evoluir nas próximas versões, mas eles fizeram isso para demonstrar a flexibilidade da arquitetura do Passenger. Aliás, o código será finalmente aberto nos próximos dias e qualquer um poderá contribuir, pois será open source. O Hongli mesmo disse que a maior parte do source code é mais comentários e documentação do que propriamente código, portanto vocês não devem ter dificuldades em entender.

Uma das coisas que pode acontecer (ainda é uma possibilidade apenas!) é o Passenger passar a fazer parte do Mac OS X. No Leopard tanto Ruby, Rails e diversas gems já vem pré-instaladas. Mas com o Passenger, o Mac se tornaria o pacote mais simples para se desenvolver em Rails.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/honglininhapple.jpg)](http://blog.phusion.nl/2008/06/04/35th-of-phusion-at-apple/)

Eles voaram para Cupertino logo depois da RailsConf para uma reunião direto na mother-ship! Espero que boas novas apareçam em breve!

Finalmente vocês entenderam porque eu bloguei tão pouco durante a RailsConf: pela metade do evento meu notebook ficou na mão do Ninh. Isso porque ele havia lido que a alfândega americana poderia querer revistar notebooks e não devolver, então ele deixou o mac dele em casa e havia pedido se eu não emprestaria minha máquina a eles.

Eu disse que sim, mas com direito a uma entrevista exclusiva logo em seguida à apresentação. Ainda preciso compilar isso, mas eu gravei um audio podcast e o Carl gravou o vídeo dessa entrevista, que pretendemos liberar em breve.

Nesta foto vocês vêem o Gregg Pollack os entrevistando para [este video](http://www.vimeo.com/1104493) :

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06047.JPG)](http://www.vimeo.com/1104493)   
  
<object width="400" height="300">	<param name="allowfullscreen" value="true">	<param name="allowscriptaccess" value="always">	<param name="movie" value="http://www.vimeo.com/moogaloop.swf?clip_id=1104493&server=www.vimeo.com&show_title=1&show_byline=1&show_portrait=0&color=&fullscreen=1">	<embed src="http://www.vimeo.com/moogaloop.swf?clip_id=1104493&server=www.vimeo.com&show_title=1&show_byline=1&show_portrait=0&color=&fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="400" height="300"></embed></object>  
[Ninh Bui at Railsconf 2008](http://www.vimeo.com/1104493?pg=embed&sec=1104493) from [Gregg Pollack](http://www.vimeo.com/user504460?pg=embed&sec=1104493) on [Vimeo](http://vimeo.com?pg=embed&sec=1104493).

Foi muito engraçado acompanhar esses garotos durante a RailsConf, eles são muito engraçados e espirituosos. O mais importante, são jovens estudantes de ciências da computação na Holanda, eles pegaram um problema que ninguém resolveu e em vez de blogar bobagens a respeito como _“Ruby é uma droga porque o garbage collector deles não deixa suportar copy-on-write”_ ou _“Apache é uma droga porque é pesado”_ ou _“Rails é uma porcaria porque mod\_ruby não funciona com ele”_, etc eles pegaram todos esses problemas e codificaram uma excelente solução!

O próprio “Ruby Enterprise Edition” na realidade é um binário de Ruby customizado com os patches que modificam o GC e possibilita os ganhos de memória e performance. O instalador torna o processo transparente, copiando tudo num diretório isolado que, caso você não queira mais, pode simplesmente apagar ele fora. O Passenger pode ser configurado para usar seu Ruby padrão ou o “Ruby Enterprise”. Em breve talvez esses patches entrem no trunk do MRI mas isso ainda não aconteceu.

Tudo que eles fizeram segue o Ruby License, por isso mesmo o nome “Enterprise” é só uma brincadeira, tudo que eles fizeram sobre o Ruby precisa voltar à comunidade e é isso que vai acontecer.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06143.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06143&bgcolor=black)   
Conversando com Michael Koziarski  
depois da apresentação da Phusion.

No mesmo dia, no painel de fechamento, o Rails Core Team se juntou para responder perguntas da platéia. Estavam o David Hansson, o Michael Koziarski, Rick Olson e Jeremy Kemper. Durante a sessão aconteceu algo interessante: de repente o Vinicius Telles sumiu do nosso lado e eu escuto alguém falando no microfone que se parece muito com ele!!

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06161.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06161&bgcolor=black)

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06156.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06156&bgcolor=black)

Ele basicamente perguntou o que o Core Team achava sobre o Passenger, daí o próprio Koziarski disse que já estava usando em seus próprios sites e que estava muito contente com os ganhos de performance e redução no consumo de memória, dando um testemunho muito positivo. Não preciso dizer que o pessoal da Phusion ficou **extremamente** feliz por ter recebido elogios diretamente do Rails Core Team numa das apresentações com lotação quase total da platéia. Foi muito legal!

Finalmente, no final, ainda pude capturar um pequeno momento engraçado. Como eu disse antes, quem fez a doação estava presente, levou uma caixa (literalmente uma “caixa”) Enterprise, com camiseta e um DVD com a versão 2.0 do Passenger. E vejam quem estava levando uma caixa para Tim Bray:

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06177.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06177&bgcolor=black)   
Charles e Thomas levando Phusion Enterprise para Tim Bray :-)

Enfim, foi **muito** legal conhecer esse pessoal todo e acho que a apresentação do Passenger foi de longe a mais divertida da RailsConf. Talvez se não houvesse o MagLev também teria sido a mais importante, mas elas ficaram muito próximas. A diferença: Passenger funciona hoje, em produção!

