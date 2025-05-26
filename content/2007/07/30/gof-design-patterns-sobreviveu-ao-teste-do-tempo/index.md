---
title: GoF Design Patterns - Sobreviveu ao teste do tempo?
date: '2007-07-30T18:45:00-03:00'
slug: gof-design-patterns-sobreviveu-ao-teste-do-tempo
tags:
- design-patterns
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/7/30/DesignPatterns.jpg)

**Original:** [InfoQ](http://www.infoq.com/news/2007/07/GoFCriticism)

Faz algum tempo que não traduzo artigos, mas este trouxe à baila um assunto que já discuti [neste artigo](/2006/10/30/design-patterns-representam-defeitos-nas-linguagens).

Mais de uma década atrás, tendo Erich Gamma, Richard Helm, Ralph Johnson e John Vlissides, conhecidos como Gang of Four (GoF), publicaram seu livro seminal “Design Patterns: Elements of Reusable Object-Oriented Software”. O livro do GoF, que é considerado o prelúdio de todo o movimento de patterns de software, recentement recebeu críticas como não sendo mais relevante, resolvendo problemas que são melhor solucionados por novas linguagens e introduzindo complexidade desnecessária.

**Update 31/07/2007:** [Jim Weirich](http://onestepback.org/index.cgi/Tech/Ruby/DependencyInjectionInOneSentence.red) escreveu um comentário interessante. Alguém fez uma pergunta a ele via IM nessa linha:

_Se você tivesse que explicar em uma frase a um programador Java porque Dependency Injection (também conhecido como Inversion of Control, IoC) é raramente necessário em Ruby, o que diria?_

Depois de pensar um pouco ele respondeu:

_Dependency Injection dá flexibilidade vital em Java e overhead desnecessário em Ruby._

Alguém tem sugestões? ;-)


Tudo começou no início do mês quando [Jeff Atwood (Coding Horror) criticou](http://www.codinghorror.com/blog/archives/000899.html) o livro [Design Patterns do GoF](http://www.amazon.com/exec/obidos/ASIN/0201633612). Jeff escreveu que, mesmo achando que todo programador deveria ler, ele ainda tem dois problemas com o livro:

1. Design patterns são uma forma de complexidade. E como toda complexidade, eu preferia ver desenvolvedores focando em soluções simples antes de ir direto a uma receita complexa de design patterns.
2. Se você se encontra frequentemente escrevendo um punhado de código de design patterns clichês para lidar com um “problema de design recorrente”, isso não é boa engenharia – é um sinal de que sua linguagem está fundamentalmente quebrada.

Jeff também cita Mark Dominus que acha que [o livro do GoF obstrui totalmente as idéias de Cristopher Alexander](http://perl.plover.com/yak/design/samples/note.html) que escreveu o livro de (construção de) arquitetura [Uma Linguagem de Patterns – cidades, Construção Predial](http://www.amazon.com/exec/obidos/ASIN/0195019199) (que é considerado como inspiração para todo o movimento de design pattern na ciência da computação).

Steve Rowe concorda que os patterns deveriam ser usados como exemplos de bom design e princípios a serem aplicados e não como um livro de referência mas [ele diz que](http://blogs.msdn.com/steverowe/archive/2007/07/11/are-design-patterns-a-bad-idea.aspx) Jeff está por fora porque ele ataca o conceito em vez de culpas corretamente as pessoas que estão usando esse conceito da forma errada. Ele conclui que patterns deveriam ser tratados como exemplos para bom design e não como dogmas:

_Design Patterns são muito úteis quando estudamos como funcionam para que possamos criar patterns similares. Eles são ruins quando tentamos copiá-los diretamente. Se alguém lê o GoF, ele vai notar que os autores normalmente dão diversos exemplos de cada pattern e são todos um pouco diferentes. Também deve-se notar que há muita conversa sobre os conceitos de OO que levam aos patterns._

Cedric Otaku responde às críticas tanto de Jeff quanto Mark em um post que chamou [Em defesa dos Design Patterns](http://beust.com/weblog/archives/000453.html). Cedric diz que Jeff (e Mark antes dele) estão errados criticando o livro do GoF, sem oferecer nenhuma alternativa. Cedric continua explicando o problema de fazer um paralelo entre o design pattern de construção de Alexander e design pattern de software:

_Existe uma razão de porque é importante estabelecer uma clara separação entre o Design Pattern de Alexander e o do GoF: engenharia de software não chega aos pés dos avanços da engenharia civil. Ainda estamos trabalhando nas engrenagens, e sempre que um novo projeto de software começa, ainda não podemos ter certeza que não vai entrar em colapso sob seu próprio peso daqui um ano. Para fazer um paralelo: imagine um mundo onde toda vez que uma nova construção começa (digamos, uma ponte), o futuro da ponte dependa da equipe de engenheiros e trabalhadores que você escolhe para construí-la …_

Cedric diz que como construção é muito mais avançada (em sua predicabilidade e estabilidade) do que software, ainda estamos nos esforçando pelo básico e deveríamos nos focar nisso.

Por outro lado, como diz o comentário de Aristotle Pagaltzis no blog de Cedric, racionalizando a crítica de Mark:

_Dominus diz que design patterns são um sinal de deficiência de uma linguagem para o propósito que o design pattern endereça. Em outras palavras, o pattern Visitor usado no Java aponta ao fato de que Java é deficiente em termos de processamento de listas: as construções ‘map’ e ‘filter’ precisam ser emuladas com encantações OO compridas._

Ele **não** está dizendo que o uso de design patterns é ruim. Ele está dizendo que são um sinal de deficiência.

Parece que a maioria (se não todos) concordam que patterns como ferramentas em engenharia de software são úteis, o debate é no valor do livro do GoF hoje. O que vocês acham? O Design Pattern do GoF é uma peça imortal ou já viveu o suficiente para seu propósito?

