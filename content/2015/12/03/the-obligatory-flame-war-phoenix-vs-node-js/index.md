---
title: 'A Obrigatória "Flame War": Phoenix vs Node.js'
date: '2015-12-03T12:01:00-02:00'
slug: a-obrigatoria-flame-war-phoenix-vs-nodejs
translationKey: phoenix-vs-nodejs-flame
aliases:
- /2015/12/03/the-obligatory-flame-war-phoenix-vs-node-js/
tags:
- learning
- beginner
- elixir
- phoenix
- node
- traduzido
draft: false
---

Já vou avisando logo de cara: este post vai ser muito injusto. Não só sou suspeito por não gostar de Javascript e Node.js, como neste momento estou animadíssimo e fascinado com Elixir e Erlang.

Comparações são sempre injustas. Não existe isso de benchmark sintético "justo", o autor está **sempre** enviesado para chegar em algum resultado pré-determinado. É o velho caso da pseudociência onde você já tem a conclusão na cabeça e sai catando dados que confirmam essa conclusão. As variáveis são muitas demais. As pessoas acham que fica justo quando você roda na mesma máquina contra dois tipos "parecidos" de aplicação, mas não fica. E também não confie em mim, faça seus próprios testes.

Dito tudo isso, vamos nos divertir um pouco, certo?


### O Obrigatório Aquecimento "Hello World"

Para este post bem curto, criei só um "hello world" com Node.js + Express, vou apontar para o endpoint raiz, o Express renderizando um template HTML supersimples com um título e um parágrafo.

Para Elixir, fiz o bootstrap de um projeto Phoenix básico e adicionei um endpoint extra chamado "/teste" no Router. Esse endpoint chama o PageController, depois a função "teste", e renderiza um template EEX com o mesmo título e parágrafo do exemplo em Express.

Bem simples. O Phoenix faz mais coisa que o Express, mas isso aqui de qualquer forma não é para ser um julgamento justo. Escolhi o [Siege](https://www.joedog.org/siege-home/) como ferramenta de teste sem nenhum motivo especial. Você pode escolher a ferramenta que mais gostar. Estou rodando isso no meu Macbook Pro 2013 com 8 cores e 16GB de RAM, então esse benchmark nunca vai estourar a minha máquina.

O primeiro teste é uma rodada simples de 200 conexões concorrentes (o número de CPUs que tenho) disparando 8 requisições cada, totalizando 1.600. Primeiro, os resultados do Node.js + Express:

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Node+8+x+200.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Node+8+x+200.mp4)
</source></video>

A primeira rodada já quebrou algumas conexões, mas a segunda rodada se recuperou e terminou as 1.600 requisições. E estes são os resultados do Phoenix:

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Phoenix+8+x+200.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Phoenix+8+x+200.mp4)
</source></video>

Como dá para ver, o Node.js leva vantagem em tempo total gasto. Um único processo Node.js só consegue rodar uma única thread real do SO. Por isso ele teve que usar apenas um core de CPU (apesar de eu ter outros 7 cores sobrando). Por outro lado, o Elixir consegue alcançar todos os 8 cores da minha máquina, cada um rodando um Scheduler em uma thread real do SO. Então, se esse teste fosse CPU bound, deveria ter rodado 8 vezes mais rápido que a versão Node.js. Como o teste é majoritariamente um caso de operações I/O bound, a construção async esperta do Node.js dá conta do recado.

Esse não é um teste impressionante nem de longe. Mas estamos só esquentando.

Ah, e aproveitando, repare como os logs do Phoenix mostram os tempos de processamento das requisições em MICROssegundos em vez de milissegundos!

### A Diversão de Verdade

Agora vem a diversão de verdade. Nesta segunda rodada, adicionei uma chamada bloqueante de "sleep" nos dois projetos, então cada requisição vai dormir por um segundo inteiro, e isso não é absurdo. Muitos programadores escrevem código ruim que bloqueia por esse tempo, processam dados demais do banco, renderizam templates complexos demais, e por aí vai. Nunca confie que um programador vai fazer as melhores práticas o tempo todo.

Daí, disparo o Siege com dez conexões concorrentes e só uma requisição cada, para começar.

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Node+1+x+10+Sleep.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Node+1+x+10+Sleep.mp4)
</source></video>

É por isso que no meu artigo anterior "Why Elixir?" (http://www.akitaonrails.com/2015/12/01/the-obligatory-why-elixir-personal-take), repeti várias vezes o quão **"rudimentar"** é uma solução baseada no padrão Reactor. É facílimo bloquear um event loop single-threaded.

Se você ainda não sabia, como o Node.js funciona? Em resumo, é um simples loop infinito. Quando uma função Javascript roda, ela bloqueia esse event loop. A função tem que explicitamente devolver o controle para o loop para que outra função tenha a chance de rodar. Chamadas de I/O demoram e ficam paradas esperando uma resposta, então ela pode devolver o controle e esperar um callback para continuar rodando, e é por isso que você acaba na temida _"pirâmide do callback hell"_.

Agora, com tudo o que expliquei nos artigos anteriores, você já deve imaginar como Elixir + Phoenix vai se sair:

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Phoenix+2+x+400+-+Sleep.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Phoenix+2+x+400+-+Sleep.mp4)
</source></video>

Como esperado, isso é um passeio no parque para o Phoenix. Ele não tem um loop single-thread rudimentar esperando que as funções em execução devolvam o controle por boa vontade. Os Schedulers conseguem suspender à força corrotinas/processos rodando se acharem que estão demorando demais (a contagem de 2.000 reductions e configurações de prioridade), então cada processo em execução tem uma fatia justa de recursos para rodar.

Por causa disso, posso ir aumentando o número de requisições e conexões concorrentes, e continua **rápido**.

No Node.js, se uma função demora 1 segundo para rodar, ela bloqueia o loop. Quando finalmente retorna, a próxima função de 1 segundo pode rodar. É por isso que se eu tenho dez requisições demorando 1 segundo cada para rodar, o processo inteiro vai linearmente levar 10 segundos!

O que obviamente não escala! Se você "fizer do jeito certo", consegue escalar. Mas para que se dar ao trabalho?

### "Node" feito direito

Como nota lateral, acho irônico que "Node" se chame "Node". Eu suporia que conectar múltiplos Nodes que se comunicam entre si fosse fácil. E na prática, [não é](http://www.sitepoint.com/how-to-create-a-node-js-cluster-for-speeding-up-your-apps/).

Se eu tivesse subido 5 processos Node, em vez de 10 segundos, tudo demoraria 2 segundos, já que cinco requisições bloqueariam os 5 processos Node por 1 segundo, e quando retornassem, as próximas cinco requisições bloqueariam de novo. Isso é parecido com o que precisamos fazer com Ruby ou Python, que têm os temidos Global Interpreter Locks (GIL) que, na realidade, só conseguem rodar uma computação bloqueante por vez. (Ruby com Eventmachine e Python com Tornado ou Twisted são parecidos com a implementação de event loop reactor do Node.js).

O Elixir consegue fazer muito melhor para coordenar de fato nodes diferentes, e são as bases de Erlang que permitem que sistemas altamente distribuídos como [ejabberd](https://www.ejabberd.im/) ou [RabbitMQ](https://www.rabbitmq.com/) façam o que fazem com toda eficiência.

Olha como é simples para um Elixir Node detectar a presença de outros nodes Elixir e fazer com que mandem e recebam mensagens entre si:

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/7+-+Nodes.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/7+-+Nodes.mp4)
</source></video>

Isso, é simples assim. A gente usa Remote Procedure Calls (RPC) há décadas; isso não é novidade. Erlang implementou isso há anos, e está embutido e disponível para uso fácil out-of-the-box.

Nos sites deles, o ejabberd se autointitula um "Robust, Scalable, and Extensible XMPP Server", e o RabbitMQ se autointitula "Robust messaging for applications". Agora sabemos que eles merecem os rótulos "Robust" e "Scalable".

Então, estamos nos matando para fazer coisas que estão polidas e prontas há anos. O Elixir é a chave para destravar toda essa bondade do Erlang agora mesmo. Vamos só usar e parar de dar de ombros.
