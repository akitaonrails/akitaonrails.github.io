---
title: '[Off-Topic] O Mito do "Legado"'
date: '2012-08-15T12:28:00-03:00'
slug: off-topic-o-mito-do-legado
tags:
- off-topic
- principles
- career
- management
- carreira
draft: false
---

Se existe uma história recorrente em qualquer desenvolvimento de software é o que eu chamo de "Mito do Legado". Se você é programador, já passou por isso: herdou código feito por outra pessoa ou outra equipe, vê que está tudo muito mal feito, e sua recomendação é jogar tudo fora e começar tudo de novo. Você tem certeza que esta é a única alternativa sadia e não fazer isso seria um enorme erro.

Esse comportamento é o que eu também chamo de "Histeria do Amador". E digo isso com total tranquilidade porque eu mesmo já tive momentos desse.

Antes de mais nada, vamos definir o que comumente é chamado de "Legado": basicamente todo código feito até ontem, especialmente se não foi você quem fez, é considerado um "Legado". 

Mas o que a maioria dos programadores falha em entender é muito simples: com essa definição, qualquer código sempre se tornará automaticamente um "legado" no minuto seguinte em que ele é concluído: incluindo o seu próprio.

O jardim do vizinho sempre parece mais verde? Pois para programadores, o código do vizinho sempre parece pior. Quantas vezes já não ouvimos?

- _"Como assim levou tudo isso pra fazer esse código? Eu teria feito em menos tempo."_
- _"Como assim o código foi feito desse jeito tosco? Eu teria feito melhor."_

![Building the Legacy System of Tomorrow](http://s3.amazonaws.com/akitaonrails/assets/image_asset/image/19/BuildingLegacy.png)

### Contexto, contexto, contexto

Por que determinado projeto demorou _"mais tempo do que eu acho que deveria?"_ Dezenas de motivos: departamentos que não colaboraram, regras de negócio mal definidas que mudaram diversas vezes, e assim por diante. 

Por que o código não está tão _"elegante"_ ou _"bem feito"_ como _"eu faria?"_ Por que ele foi desenvolvido com um objetivo em mente, o objetivo mudou - como sempre muda -, o código foi se acumulando, prazos foram apertando, refatoramentos não aconteceram como deveriam, débito técnico foi se acumulando - a despeito do aviso dos programadores envolvidos - e o código atual acabou ficando muito pior do que deveria.

Outra coisa que deveria ser óbvia: todo programador sempre vai encontrar algo que não gosta em qualquer código, seja ele efetivamente ruim e mal feito ou mesmo bem feito e bem estruturado. Software é tão complexo que você pode achar defeito em qualquer coisa. É como apontar defeitos num ser humano: todos são imperfeitos. A falácia de quem escuta é entender que só porque alguém apontou alguns defeitos não significa automaticamente que _tudo_ seja ruim. Isso é uma falácia comum: _"meu novo programador disse que achou esse defeito e essa outra coisa mal feita, portanto o sistema é ruim"_ Só que você não apontou as qualidades e não analisou se os defeitos de fato são em maior volume, criticidade e severidade do que as qualidades. Mais do que isso: qualquer novo código também vai ter pontos que outro programador não vai gostar, e esse ciclo é infinito.

Agora a verdade: o programador que chegou depois e que questionou todos esses pontos, se estivesse exatamente no mesmo momento em que tudo começou teria entregue como resultado final o mesmo código ruim, ou até pior.

### O Medo

Agora o desafio é entender o seguinte: na maioria dos casos, código "Legado", ou seja, código que está em produção, em uso atualmente, está gerando resultados: coisa que seu código "novo e elegante" não está. Outro tipo de história que muitos programadores preferem ignorar é justamente o caso do _"Big Rewrite"_ que nunca se concluiu e que nunca foi para o ar, especialmente se foi você quem fez. 

O pior tipo de software é aquele que não gera valor. E um fator que diferencia um programador profissional de um amador é exatamente em como ele lida com código dos outros. Conversando ontem com o camarada [Rodrigo Yoshima](http://blog.aspercom.com.br) ele soltou uma pérola: lidar com legado é para adultos, "greenfield" (projeto feito do zero) qualquer criança faz.

É preciso muito mais técnica, muito mais habilidade, muito mais capacidade, para pegar um legado e fazê-lo melhor, mesmo que em alguns casos seja necessário efetivamente refazer algumas partes, mas que isso não seja a primeira alternativa automática e sem justificativa. _"Porque eu faria melhor"_ não é justificativa.

![Dilbert](http://s3.amazonaws.com/akitaonrails/assets/image_asset/image/18/2006-12-08.gif)

### O Ambiente

O processo que facilita equipes a gerar código ruim sempre é um dos problemas mais difíceis de resolver. Chefes, clientes que pedem _"mudanças urgentes de última hora"_ é um dos sintomas. Departamentos com prioridades diferentes. Em ambientes como esse, qualquer novo software rapidamente será piorado até o ponto onde parecerá necessário refazer tudo de novo. 

Não vou repetir tudo que as comunidades Ágeis já disseram até hoje, mas o "conserto" na maior parte das vezes não envolve apenas técnicas de programação, mas sim programadores que consigam ver além do código e entender como ajudar a consertar o ambiente ao seu redor. Isso inclui os colegas programadores ao redor, os chefes acima, as demandas vindas de departamentos ao redor e todo o feedback vindo do mercado no mundo exterior.

No mundo real, software é feito por pessoas para pessoas. Entender que pessoas não díficeis significa que o desafio para um profissional é muito maior do que seguir boas práticas ou ser especializado nesta ou naquela técnica. Um bom profissional sabe que apenas reclamar e ficar emburrado não leva a lugar algum.

### Oportunidades

Como sempre, histórias não são regras, mas servem para ilustrar um ponto. Anos atrás eu fui alocado sozinho num grande cliente que tinha um pequeno sistema "legado" extremamente mal feito. Uma alocação pontual. E eu posso dizer "mal feito" porque efetivamente ele não executava como devia, ou seja, era tecnicamente falho e devolvia muitos erros. Era exatamente o tipo de código que faria qualquer programador dizer, imediatamente, _"jogue isso fora e faça de novo!"_

Eu tinha 2 semanas para fazer alguma coisa. Outros já haviam tentado, o cliente já estava convencido a fazer um novo. Ninguém acharia ruim eu dizer que não dava pra fazer nada além de começar do zero. Era uma tentativa. E eu odeio dizer que não consigo resolver um problema.

Eles precisavam que o atual funcionasse minimamente. Eu era programador Java na época, o sistema era um dos piores ASPs que já tinha visto até então, misturado com diversos componentes DCOM que milagrosamente executavam de alguma forma.

Em 2 semanas eu entendi o que era a regra de negócio que se queria. Entendi porque o código não funcionava conforme essas regras. Entendi de onde vinham os dados que alimentavam, como eles eram tratados e armazenados, quais resultados eram esperados e como eu deveria interferir para conseguir implementar esse processamento.

Eu usei exatamente o mesmo código, fiz uma limpeza mínima de sanidade, retirei o que era desnecessário e inseri o mínimo necessário para atingir os objetivos esperados pelo cliente dentro do prazo que me foi estipulado.

Durante essas 2 semanas entendi mais sobre o processo, entendi mais sobre o cliente, entendi mais sobre o ambiente. Além de consertar o software consegui criar um bom relacionamento. Esse bom relacionamento, em poucos meses, me levou a voltar a trabalhar para esse cliente mas desta vez num projeto de 1 ano e meio com uma equipe de quase 10 pessoas, onde eu pude coordenar o desenvolvimento do meu jeito.

![Save our Code](http://s3.amazonaws.com/akitaonrails/assets/image_asset/image/20/big_url.jpeg)

Nesse caso, estava claro que o código foi feito de má-fé por um programador que não sabia de verdade o que estava fazendo. Muitos softwares são mesmo feitos por programadores simplesmente ruins. Mas eu entendo que muitos casos também são bons programadores que tiveram que resolver um problema dentro de uma série de restrições que precisaram lidar.

Para mim, "legado" é software feito justamente por quem chama o software dos outros de "legado". Para mim, "legado" muitas vezes pode ser uma oportunidade - justamente porque poucos conseguem. E para mim, pessoas que julgam o código dos outros sem conhecimento do contexto todo, é só mais um amador querendo se mostrar.

Claro, isto não é uma defesa de que todo software legado é justificado e bom. De jeito nenhum, meu ponto neste artigo é focado ao comportamento automático de programadores que usam isso como desculpa.
