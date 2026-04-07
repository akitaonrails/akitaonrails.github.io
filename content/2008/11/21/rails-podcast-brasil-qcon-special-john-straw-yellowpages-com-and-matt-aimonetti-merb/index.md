---
title: "Rails Podcast Brasil, Especial QCon - John Straw (YellowPages.com) e Matt Aimonetti (Merb)"
date: '2008-11-21T04:06:00-02:00'
slug: rails-podcast-brasil-especial-qcon-john-straw-yellowpages-com-e-matt-aimonetti-merb
translationKey: qcon2008-john-straw-matt-aimonetti
aliases:
- /2008/11/21/rails-podcast-brasil-qcon-special-john-straw-yellowpages-com-and-matt-aimonetti-merb/
tags:
- qcon2008
- interview
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/johnstraw.jpg)

Hoje foi mais um dia longo de entrevistas. Esta tarde eu entrevistei primeiro o **John Straw**. Ele é o responsável pelo que ele chama de [A Grande Reescrita](http://uploads.en.oreilly.com/1/event/6/Surviving%20the%20Big%20Rewrite_%20Moving%20YELLOWPAGES_COM%20to%20Rails%20Presentation%201.pdf). O projeto de reescrita de 150 mil linhas de código Java, sem testes, por cerca de 13 mil linhas de código Ruby on Rails, com quase 100% de cobertura de testes (metade do código escrito são de testes), e sem reduzir o escopo. O projeto original foi desenvolvido em 22 meses e a reescrita levou 4 meses de 4 desenvolvedores (embora eles tenham gasto 4 meses de preparação e planejamento, mas mesmo assim …).

Nessa entrevista ele fala sobre as motivações, como foi com a equipe mover de Java para Ruby, como eles escolheram Rails, qual o tamanho da infraestrutura. É um grande estudo de caso para qualquer empresa usando Java para se assegurar que mudar para Ruby só vai trazer benefícios.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/2934507309_f5973aee53.jpg)](http://www.slideshare.net/mattetti/merb-for-the-enterprise-presentation/v1)

Depois disso eu finalmente entrevistei [**Matt Aimonetti**](http://wiki.merbivore.com/). Ele é o principal evangelista de Merb. Ele tem uma empresa de treinamento e consultoria em San Diego, ele também foi responsável pelo [MerbCamp](http://www.merbcamp.com/), o primeiro evento de Merb. E também é um dos principais colaboradores do Merb.

Ele foi muito gentil de gastar muitas horas me mostrando os detalhes sobre o Merb. Eu não estava ciente do estado atual e tenho que dizer que está muito interessante. Muito bem pensado, ele tem tudo que você precisa para começar a desenvolver aplicações web com quase a mesma conveniência e facilidade de uso do Ruby on Rails.

Algumas das melhores coisas do Merb são: ele é bem próximo do Rails, então você vai se sentir em casa. Ele tem “Slices”, que é uma funcionalidade que eu esperava em Rails por muito tempo – ele funciona quase como os Engines, mas já está pré-embutido e a sensação é muito melhor. Ele tem uma funcionalidade muito legal de “processo master”, então você pode instruí-lo para carregar N processos workers (como um cluster mongrel) e ele vai monitorar esses workers, então se um deles cair, o master irá recarregá-lo automaticamente, o que é bem conveniente. E finalmente, sua modularidade é muito boa. Parece estranho a princípio ter um monte de gems por aí, mas faz sentido bem rápido.

E de acordo com Matt, Merb é muito mais rápido do que Rails – pelo menos no benchmark de “Hello World” :-) Isso tudo dito, eu recomendo muito, especialmente se você já é um desenvolvedor Ruby avançado que quer mais (ou menos) do que o Rails pode oferecer agora.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/Picture_2.png)](http://www.slideshare.net/mattetti/merb-for-the-enterprise-presentation/v1)

Faça o download do arquivo de áudio do John [aqui](/files/john_straw.mp3) e o do Matt [daqui](/files/matt_aimonetti.mp3).
