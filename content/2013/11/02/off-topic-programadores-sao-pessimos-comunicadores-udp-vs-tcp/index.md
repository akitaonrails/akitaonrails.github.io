---
title: "[Off-Topic] Programadores são péssimos Comunicadores (UDP vs TCP)"
date: '2013-11-02T13:49:00-02:00'
slug: off-topic-programadores-sao-pessimos-comunicadores-udp-vs-tcp
tags:
- off-topic
- career
- carreira
draft: false
---

Nós, programadores, vivemos na Matrix: achamos que sabemos o que estamos fazendo e que o resto do mundo é idiota demais para nos entender. Afinal, todos sabemos ir num Github, ler código, discutir no Hacker News e no Reddit e o resto do mundo só sabe postar no Instragram e no Facebook. Portanto, _obviamente_ somos melhores e quem não nos entende é que deve se esforçar para mudar.

Tendo vivido em todos os lados por muito tempo tenho uma novidade para vocês: programadores são **péssimos** comunicadores. Existe uma impedância de comunicação que está se tornando seriamente uma incapacidade. A impressão que temos nas comunidades de programação é que o código é a única linguagem universal. Só que _"show me the code"_ não é tudo. Algum tempo atrás eu [respondi no Quora](https://www.quora.com/Software-Engineering/What-is-the-hardest-thing-you-do-as-a-software-engineer/answer/Fabio-Akita?share=1) que a coisa mais difícil para todo Engenheiro de Software entender é que 90% dos problemas de um projeto não se resolvem com código.

Sem querer generalizar, mas só para ilustrar: no mundo open source (para quem participa) dá a impressão que é o contrário, mas note que a grande maioria faz pequenas contribuições, esporadicamente, e mesmo quem participa mais ativamente, ainda assim é uma experiência fragmentada. De fato o software estará pronto só quando estiver pronto. E com isso a grande maioria dos projetos open source, na verdade, fracassa. 

Para cada um JQuery que dá certo, dezenas de outras bibliotecas Javascript nem são reconhecidos - mesmo tendo alguns aspectos tecnicamente melhores. Os grandes e melhor coordenados, e que tem força bruta (colaboradores de sobra), costuma andar melhor. Mas não é eficiente, apenas aparenta ser. E os que são grandes demonstram uma organização bem diferenciada, com datas de lançamento, roadmap de features e começa a convergir para o que conhecemos como "projetos" de verdade.

No mundo real, não temos nem tanto tempo sobrando, nem tanta gente sobrando, os riscos diretos são muito maiores, e queremos ter mais controle sobre os resultados. Não vou nem entrar no mérito das melhores maneiras, mas fundamentalmente, no mundo real comunicação é a diferença entre fracasso e sucesso.

## Informar não é Comunicar!

A primeira coisa que você precisa entender é o seguinte: só porque a informação "existe" ou você colocou em algum lugar compartilhado, isso não é comunicar.

Comunicação tem 4 pontas: o comunicador, o recipiente, a mensagem e o meio de transmissão. Os programadores normalmente assumem 2: o comunicador (ele mesmo) e a mensagem, o resto é ignorado. Vamos definir isso melhor:

<blockquote>
"Comunicação só acontece quando o recipiente recebe e entende a mensagem. Se isso não aconteceu, não existiu comunicação."
</blockquote>

Vamos falar descer um nível e falar em "geek": existe um cliente, um servidor, um protocolo e um meio de transmissão. Se você empacotou a mensagem de acordo com o protocolo, abriu a conexão com o servidor, tentou enviar a mensagem, mas ele não terminou e voltou com erro, nós sabemos que a comunicação não existiu.

No mundo de [TCP/IP](http://packetlife.net/blog/2010/jun/7/understanding-tcp-sequence-acknowledgment-numbers/), primeiro mandamos um SYN (que inicia a comunicação), recebemos de volta um SYN-ACK (acknowledgement do servidor dizendo que recebeu o SYN) e enviamos um ACK para indicar conexão estabelecida. Realizamos esse handshake e conseguimos sequenciar o envio e recebimento de pacotes de forma que garantimos que o que foi enviado foi inteiramente recebido.

Nessa metáfora, eu diria que a maioria dos programadores entende melhor UDP, eles enviam datagramas de informação e não se preocupam se o recipiente recebeu todos os pacotes, simplesmente vai enviando. Dá mesmo a impressão que programadores pensam UDP, olhem só:

* não querem esperar um handshake pra garantir que a conexão foi estabelecida
* mandam pacotes pequenos de informações fragmentadas, pouco overhead de protocolo
* TCP se preocupa com [congestion control](http://en.wikipedia.org/wiki/TCP_congestion-avoidance_algorithm) e faz throttling, UDP vai mandando mesmo se o roteador dropar os pacotes
* se um pacote se perde, UDP não se preocupa em reenviar
* pensa que parece mais eficiente fazer broadcast e multicast

Funciona bem para comunicação para grandes grupos, broadcast, onde se uma porcentagem receber a mensagem já é suficiente. Eu diria que UDP até que funciona bem no mundo fragmentado de open source, mas num mundo onde estabelecer uma conexão e garantir a entrega da mensagem é importante, vamos de TCP.

TCP funciona porque mesmo com uma conexão ruim, mesmo com um servidor meia boca, você controla o stream de dados e garante que todos os dados foram recebidos, na sequência correta, e o 100% do que foi enviado foi recebido. Em UDP, se o meio de transmissão é ruim, se o servidor recebe a informação corrompida, ele não se importa, simplesmente vai enviando.

Ambos os protocolos tem utilidade, porém se precisamos ter certeza que a informação foi recebida corretamente e integralmente, precisamos usar TCP. Eu diria que no mundo open source, não tem problema você usar UDP pra se comunicar, diminuir a latência e ser mais "eficiente". Mas no mundo não-open source (e isso significa não só software, mas fora de software), precisamos ser mais TCP. As vantagens do TCP?

* garantir que a conexão foi estabelecida antes de mandar informações
* garantir a ordem da informação, rearranjando pacotes se necessário
* moderar a velocidade da transmissão pra não floodar o outro lado
* garantia da entrega da mensagem, não só da transmissão
* checagem de erro, pra garantir que a informação não foi corrompida
* "acknowledment", garantir que o outro lado recebeu e entendeu a informação

Vêem a diferença? Parece que demora mais, mas é aquela velha história: entregar rápido mas ter que ficar entregando diversas vezes acaba ficando mais lento do que garantindo que na primeira vez foi entendido. É que nem fazer código sem testes, parece que é mais rápido, mas depois vem as consequências.

Portanto, programadores, ajustem seus protocolos, sejam mais TCP do que UDP.
