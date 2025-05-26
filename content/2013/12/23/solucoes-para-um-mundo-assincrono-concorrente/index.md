---
title: Soluções para um Mundo Assíncrono/Concorrente
date: '2013-12-23T14:34:00-02:00'
slug: solucoes-para-um-mundo-assincrono-concorrente
tags:
- learning
- rails
- presentation
draft: false
---

Se você é minimamente informado sobre os últimos desenvolvimentos no mundo de linguagens e frameworks web, vai lembrar que algumas das coisas mais discutidas são sobre o fator "concorrência",  "paralelismo", ["I/O assíncrono"](http://en.wikipedia.org/wiki/Asynchronous_I/O). Todos os termos são associados com ser ou não ser "escalável".

Nesse cenário, vamos lembrar que nem Ruby, nem o framework Rails se encaixam nesses termos. Por isso muitos chegam à conclusão que é hora de ir para Node.js, Go, Elixir, Scala, Clojure.

Como eu repito essa mesma resposta faz algum tempo, vou descrever aqui em linhas gerais. Para 90% de nós, programadores de aplicações web, isso não é necessário e sequer é prático.

Uma requisição web, quando chega ao servidor e à sua aplicação, precisa executar muita coisa até terminar de montar o HTML de resposta. Esse tempo tem que ser o menor possível para que o mesmo servidor possa responder o máximo possível por período de tempo (throughput).

Em linhas gerais, se uma requisição demora porque precisa ficar esperando operações de leitura/escrita (ou, "I/O"), por exemplo escrever no banco, uma query pesada, uma chamada de web service pela internet, etc, dizemos que essa requisição é "I/O bound", limitada por I/O.

Por outro lado se o que mais faz a requisição demorar é o processamento em si, por exemplo processar um array de objetos que retornou do banco, transformando-a em outra estrutura, como o HTML de resposta, ou gerar um PDF, ou qualquer coisa que seja limitada por CPU, dizemos que a requisição é "CPU bound".

Não é uma coisa "binária", ou é I/O bound ou é CPU bound, mas é uma forma de descrever em linhas gerais qual é o gargalo principal. No caso de CPU bound, por exemplo, não tem jeito, precisa ter ou CPUs mais rápidas, ou várias CPUs em paralelo e daí sua aplicação suportar ou multithread ou multi-processos para utilizar todas as CPUs.

No caso de I/O o sistema operacional precisa suportar I/O assíncrono (e na prática, todos suportam hoje). No caso de um Linux, você terá chamadas de notificações de eventos de I/O de baixo nível chamado [epoll](http://linux.die.net/man/4/epoll). Todo mundo vai usar isso para ter o recurso de I/O assíncrono, e isso inclui Python, Ruby (sim, Ruby também suporta), Node.js, Java (NIO), etc. Não há nada específico de uma linguagem que contribua para isso: o OS suporta ou não.

Portanto, a lição número 1 é que tanto problemas de CPU bound e I/O bound são conhecidos e resolvidos faz anos. Não há novidades aqui.

Porém a novidade é que agora algumas linguagens tem sido criadas primariamente para tentar criar abstrações mais confortáveis para esses problemas. Daí surgem coisas como [Actor Model ](http://en.wikipedia.org/wiki/Actor_model), conceitos que já existiam como "estado não compartilhado". Em particular, no mundo Ruby você vai encontrar os melhores avanços desse modelo no projeto [Celluloid](http://celluloid.io), cujo principal caso de uso é o sistema de filas assíncrono [Sidekiq](http://sidekiq.org). Use o [Amazon AWS SQS](http://aws.amazon.com/sqs/) se quiser algo realmente robusto.

Aliás, tudo que é CPU bound, deve ao máximo ser jogado para servidores de fila para processamento paralelo em background, sem segurar o tempo de resposta de uma requisição. Processamento de imagens, processamento de dados, conexões com web services, geração de relatórios, indexação de dados, tudo isso deve ser trabalho para jobs em background. Faça sua aplicação web gravar a tarefa na fila e configure workers para executá-los. Se você usar Heroku, por exemplo, ele já tem dynos específicos para workers. Configurar o [Sidekiq no Heroku](https://github.com/mperham/sidekiq/wiki/Deployment) é quase trivial. 

<script async class="speakerdeck-embed" data-id="dd79c500c6d8013035935aca16dbe60c" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

Fazendo isso é possível literalmente cortar segundos inteiros de requisições web lentas e jogar tudo para tarefas assíncronas. É assim que se começa a resolver processos intensivos de CPU na web. A segunda etapa, quando necessário, é migrar para [JRuby](https://github.com/jruby/jruby/wiki/Home), isso resolve quase todo o resto dos outros problemas.

No caso de um Node.js, por exemplo, o principal caso de uso para ele sempre foi um [socket.io](http://socket.io), implementar servidor que serve [HTML 5 WebSockets](http://www.html5rocks.com/en/tutorials/websockets/basics/) que, por sua natureza, são conexões que não se fecham rápido. E isso é justamente um problema para ser resolvido com I/O assíncrono. Eu sei, eu sei, tem muito mais que se pode fazer com um Node.js, mas na prática esse era um grande diferencial comparado aos outros.

Para a maioria de nós - isso já foi resolvido de forma mais simples, como serviços. Enviar e receber notificações, manter conexões persistentes em altas quantidades (milhares ou milhões), pode ser totalmente resolvido simplesmente contratando serviços por preços tão baixos quanto USD 1 por **milhão de mensagens** e **10 mil conexões simultâneas** na [Realtime.co](http://framework.realtime.co/messaging/). E além dele você ainda pode escolher entre o [Pusher](http://pusher.com) e o [PubNub](http://www.pubnub.com). Esse caso de uso pode ser estendido para os casos de chat, notificações em mobile, notificações real-time na web, etc. Esqueça a idéia de montar sua própria máquina de Node no EC2 para isso. Simplesmente não precisa.

Eu repito "para a maioria de nós" porque não estou considerando os casos excepcionais onde você trabalha com infraestrutura especial, que atende milhões ou dezenas de milhões de pessoas, onde estamos falando de centenas de milhares de conexões simultâneas, bilhões de requisições por mês. Se você não lida com esses números, faz parte da "maioria de nós". E a maioria de nós tem soluções simples hoje em dia. Olhe primeiro na Amazon AWS antes de sequer pensar em fazer algo do zero. Certamente seu problema se resolve com Elastic Beanstalk, OpsWorks, RDS, SQS, SES, DynamoDB, Elasticache, etc.

<div class="embed-container">
<iframe src="//www.youtube.com/embed/fOI3EjsUEww" frameborder="0" allowfullscreen></iframe>
</div>

E por isso mesmo, ecossistemas como o Rails continuam fortes e crescendo: porque o que muitos ainda estão batendo cabeça para resolver (Asset Pipeline, por exemplo), nós já temos resolvido faz tempo. Não temos mais muitas dúvidas quanto a [processos de deployment](https://devcenter.heroku.com/articles/git), [ciclo de vida](http://travis-ci.com) de projetos, melhores [padrões](https://www.codeschool.com/courses/rails-4-patterns) de desenvolvimento, melhores [boas práticas](http://codeclimate.com), etc.

A intenção deste artigo é mais dar uma referência a quem está iniciando ou tem pouca experiência em Ruby e Rails, pois superficialmente pode parecer que há algo com o que se preocupar que na verdade já está resolvido. As coisas continuam tão escaláveis ou mais do que sempre foram, não há nenhuma grande novidade hoje em dia, os casos de uso não mudaram e nem suas soluções. Antes de novos use cases aparecerem, a maioria das coisas que vemos hoje em dia são soluções procurando um problema para resolver.
