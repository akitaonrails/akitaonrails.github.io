---
title: Rails Podcast Brasil, QCon Special - John Straw (YellowPages.com) and Matt
  Aimonetti (Merb)
date: '2008-11-21T04:06:00-02:00'
slug: rails-podcast-brasil-qcon-special-john-straw-yellowpages-com-and-matt-aimonetti-merb
tags:
- qcon2008
- interview
- english
draft: false
---

 **Brasileiros:** cliquem [aqui](/2008/11/21/rails-podcast-brasil-qcon-special-john-straw-yellowpages-com-and-matt-aimonetti-merb#john_matt)

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/johnstraw.jpg)

Today was a pretty busy day of interviews. This afternoon I was able to first interview **John Straw**. He is the responsible for what he calls [The Big Rewrite](http://uploads.en.oreilly.com/1/event/6/Surviving%20the%20Big%20Rewrite_%20Moving%20YELLOWPAGES_COM%20to%20Rails%20Presentation%201.pdf) project. The project about replacing 150k LOC from Java, with no tests, to around 13k LOC of Ruby on Rails, with almost 100% test coverage, and without reducing the scope. The original project was developed unders 22 months and the rewrite took place in 4 months of development, with 4 developers (though they had 4 months of preparation and planning, but still …).

In this interview he talks about the motivations, how it was with the team to move from Java to Ruby, how they chose Rails, what’s the size of their infrastructure. It is a great case study for any company using Java to be reassured that changing to Ruby will only bring you benefits.

After that I finally interviewed [**Matt Aimonetti**](http://wiki.merbivore.com/). He is the main Merb Evangelist. He has a training and consulting firm in San Diego, he was also responsible for [MerbCamp](http://www.merbcamp.com/), the first Merb event around. And he is also one of the main contributors to Merb.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/2934507309_f5973aee53.jpg)](http://www.slideshare.net/mattetti/merb-for-the-enterprise-presentation/v1)

He was kind enough to spend a long time showing me the nuts and bolts of Merb. I was not aware of its current state and I have to tell you that it is pretty compelling. Very well thought out, it has everything you need to start developing web applications with almost the same easy of use and convenience of Ruby on Rails.

Among the best things I saw in Merb is: it can be pretty close to Rails, so you will feel right at home. It has “Slices” which is feature that I expected Rails to have for a long time – it works almost the same way as Engines, but it is built-in and feels much better. It has a neat feature of a “master process”, so you can instruct it to load N workers processes (such as a mongrel cluster) and it will monitor those workers, so if one goes down, the master will respawn it automatically, which is pretty convenient. And finally, it’s modularity is top-notch. It feels weird at first having lots of gems around, but it makes sense very fast.

And according to Matt, Merb is way faster than Rails – at least in a “Hello World” benchmark :-) All in all, I highly recommend it, specially if you’re already an advanced Ruby developer that wants more (or less) than Rails can offer out of the box right now.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/Picture_2.png)](http://www.slideshare.net/mattetti/merb-for-the-enterprise-presentation/v1)

Download John’s audio file from [here](/files/john_straw.mp3) and Matt’s file from [here](/files/matt_aimonetti.mp3).


## John Straw (YellowPages.com) e Matt Aimonetti (Merb)

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/johnstraw.jpg)

Hoje foi mais um dia longo de entrevistas. Esta tarde eu entrevistei primeiro o **John Straw**. Ele é o responsável pelo que ele chama de [A Grande Reescrita](http://uploads.en.oreilly.com/1/event/6/Surviving%20the%20Big%20Rewrite_%20Moving%20YELLOWPAGES_COM%20to%20Rails%20Presentation%201.pdf). O projeto de reescrita de 150 mil linhas de código Java, sem testes, por cerca de 13 mil linhas de código Ruby on Rails, com quase 100% de cobertura de testes (metade do código escrito são de testes), e sem reduzir o escopo. O projeto original foi desenvolvido em 22 meses e a reescrita levou 4 meses de 4 desenvolvedores (embora eles tenham gasto 4 meses de preparação e planejamento, mas mesmo assim …).

Nessa entrevista ele fala sobre as motivações, como foi com a equipe mover de Java para Ruby, como eles escolheram Rails, qual o tamanho da infraestrutura. É um grande estudo de caso para qualquer empresa usando Java para se assegurar que mudar para Ruby só vai trazer benefícios.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/2934507309_f5973aee53.jpg)](http://www.slideshare.net/mattetti/merb-for-the-enterprise-presentation/v1)

Depois disso eu finalmente entrevistei [**Matt Aimonetti**](http://wiki.merbivore.com/). Ele é o principal evangelista de Merb. Ele tem uma empresa de treinamento e consultoria em San Diego, ele também foi responsável pelo [MerbCamp](http://www.merbcamp.com/), o primeiro evento de Merb. E também é um dos principais colaboradores do Merb.

Ele foi muito gentil de gastar muitas horas me mostrando os detalhes sobre o Merb. Eu não estava ciente do estado atual e tenho que dizer que está muito interessante. Muito bem pensado, ele tem tudo que você precisa para começar a desenvolver aplicações web com quase a mesma conveniência e facilidade de uso do Ruby on Rails.

Algumas das melhores coisas do Merb são: ele é bem próximo do Rails, então você vai se sentir em casa. Ele tem “Slices” que é uma funcionalidade que eu esperava em Rails por muito tempo – ele funciona quase como os Engines, mas já está pré-embutido e a sensação é muito melhor. Ele tem uma funcionalidade muito legal de “processo master”, então você pode instruí-lo para carregar N processos workers (como um cluster mongrel) e ele vai monitorar esses workers, então se um deles cair, o master irá recarregá-lo automaticamente, o que é bem conveniente. E finalmente, sua modularidade é muito boa. Parece estranho a princípio ter um monte de gems por aí, mas faz sentido bem rápido.

E de acordo com Matt, Merb é muito mais rápido do que Rails – pelo menos no benchmark de “Hello World” :-) Isso tudo dito, eu recomendo muito, especialmente se você já é um desenvolvedor Ruby avançado que quer mais (ou menos) do que o Rails pode oferecer agora.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/Picture_2.png)](http://www.slideshare.net/mattetti/merb-for-the-enterprise-presentation/v1)

Faça o download do arquivo de áudio do John [aqui](/files/john_straw.mp3) e o do Matt [daqui](/files/matt_aimonetti.mp3).

