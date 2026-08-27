---
title: "[Off-Topic] Programadores são péssimos Comunicadores (UDP vs TCP)"
date: '2013-11-02T13:49:00-02:00'
slug: off-topic-programadores-sao-pessimos-comunicadores-udp-vs-tcp
translationKey: off-topic-programadores-sao-pessimos-comunicadores-udp-vs-tcp
description: "Usando UDP e TCP como metáfora, o texto diz que programadores confundem informar com comunicar. Projetos reais exigem confirmar conexão, contexto, ordem, entendimento e entrega da mensagem."
tags:
- comunicacao
- carreira
- off-topic
draft: false
---

Nós, programadores, vivemos na Matrix: achamos que sabemos o que estamos fazendo e que o resto do mundo é idiota demais para nos entender. Afinal, todos sabemos entrar num Github, ler código, discutir no Hacker News e no Reddit, enquanto o resto do mundo só sabe postar no Instagram e no Facebook. Portanto, _obviamente_ somos melhores, e quem não nos entende é que deve se esforçar para mudar.

Tendo vivido em todos os lados por muito tempo, tenho uma novidade para vocês: programadores são **péssimos** comunicadores. Existe uma impedância de comunicação que está virando uma incapacidade séria. A impressão dentro das comunidades de programação é que o código é a única linguagem universal.

Só que _"show me the code"_ não é tudo. Algum tempo atrás eu [respondi no Quora](https://www.quora.com/Software-Engineering/What-is-the-hardest-thing-you-do-as-a-software-engineer/answer/Fabio-Akita?share=1) que a coisa mais difícil para todo Engenheiro de Software entender é que 90% dos problemas de um projeto não se resolvem com código.

Sem querer generalizar, só para ilustrar: no mundo open source dá a impressão de que é o contrário. Mas note que a grande maioria faz pequenas contribuições, esporádicas, e mesmo quem participa mais ativamente ainda vive uma experiência fragmentada. O software fica pronto só quando fica pronto. E, no fim, a grande maioria dos projetos open source fracassa.

Para cada jQuery que dá certo, dezenas de outras bibliotecas Javascript nem são reconhecidas, mesmo tendo alguns aspectos tecnicamente melhores. Os grandes e melhor coordenados, com força bruta e colaboradores de sobra, costumam andar melhor. Só que força bruta apenas aparenta eficiência. E os que crescem mostram uma organização bem diferente, com datas de lançamento e roadmap de features, começando a convergir para o que conhecemos como "projetos" de verdade.

No mundo real, o tempo é curto, as pessoas são poucas, os riscos diretos são muito maiores e queremos mais controle sobre os resultados. Não vou entrar no mérito das melhores maneiras, mas, no fundo, no mundo real a comunicação é a diferença entre o fracasso e o sucesso.

## Informar não é Comunicar!

A primeira coisa a entender é simples: só porque a informação "existe", ou você a colocou em algum lugar compartilhado, isso não significa que você comunicou.

A comunicação tem 4 pontas: o comunicador, o recipiente, a mensagem e o meio de transmissão. Os programadores normalmente assumem só 2, o comunicador (ele mesmo) e a mensagem, e ignoram o resto. Vamos definir isso melhor:

<blockquote>
"Comunicação só acontece quando o recipiente recebe e entende a mensagem. Se isso não aconteceu, não existiu comunicação."
</blockquote>

Vamos descer um nível e falar em "geek": existe um cliente, um servidor, um protocolo e um meio de transmissão. Se você empacotou a mensagem conforme o protocolo, abriu a conexão com o servidor e tentou enviar, mas a transmissão não terminou e voltou com erro, sabemos que a comunicação não aconteceu.

No mundo do [TCP/IP](http://web.archive.org/web/20131105125105/http://packetlife.net:80/blog/2010/jun/7/understanding-tcp-sequence-acknowledgment-numbers/), primeiro mandamos um SYN, que inicia a comunicação. Recebemos de volta um SYN-ACK, o acknowledgement do servidor dizendo que recebeu o SYN, e enviamos um ACK para indicar que a conexão está estabelecida. Com esse handshake, conseguimos sequenciar o envio e o recebimento dos pacotes e garantir que tudo o que foi enviado foi inteiramente recebido.

Nessa metáfora, eu diria que a maioria dos programadores entende melhor o UDP. Eles enviam datagramas de informação e não se preocupam se o recipiente recebeu todos os pacotes, simplesmente vão enviando. Dá mesmo a impressão de que programadores pensam em UDP, olhem só:

* não querem esperar um handshake pra garantir que a conexão foi estabelecida
* mandam pacotes pequenos de informações fragmentadas, pouco overhead de protocolo
* TCP se preocupa com [congestion control](https://en.wikipedia.org/wiki/TCP_congestion-avoidance_algorithm) e faz throttling, UDP vai mandando mesmo se o roteador dropar os pacotes
* se um pacote se perde, UDP não se preocupa em reenviar
* pensa que parece mais eficiente fazer broadcast e multicast

Funciona bem para comunicação com grandes grupos, em broadcast, onde basta uma porcentagem receber a mensagem. Eu diria que o UDP funciona até bem no mundo fragmentado do open source. Mas num mundo onde estabelecer conexão e garantir a entrega da mensagem importa, vamos de TCP.

O TCP funciona porque, mesmo com uma conexão ruim, mesmo com um servidor meia-boca, você controla o stream de dados e garante que tudo chegou, na sequência correta, com 100% do que foi enviado recebido. No UDP, se o meio de transmissão é ruim, se o servidor recebe a informação corrompida, ele não se importa e continua enviando.

Ambos os protocolos têm utilidade. Mas, se precisamos ter certeza de que a informação foi recebida certa e por inteiro, precisamos do TCP. No mundo open source, tudo bem usar UDP para se comunicar, baixar a latência e ser mais "eficiente". No mundo fora do open source, e isso vale para muito além de software, precisamos ser mais TCP. As vantagens do TCP?

* garantir que a conexão foi estabelecida antes de mandar informações
* garantir a ordem da informação, rearranjando pacotes se necessário
* moderar a velocidade da transmissão pra não floodar o outro lado
* garantia da entrega da mensagem, não só da transmissão
* checagem de erro, pra garantir que a informação não foi corrompida
* "acknowledment", garantir que o outro lado recebeu e entendeu a informação

Veem a diferença? Parece que demora mais, mas é aquela velha história: entregar rápido e depois ter que reentregar várias vezes acaba saindo mais lento do que garantir que na primeira vez a mensagem foi entendida. É que nem escrever código sem testes, parece mais rápido, mas depois vêm as consequências.

Portanto, programadores, ajustem seus protocolos. Sejam mais TCP do que UDP.
