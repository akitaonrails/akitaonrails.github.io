---
title: 'Off Topic: Por que programadores devem jogar Go'
date: '2008-07-15T01:07:00-03:00'
slug: off-topic-por-que-programadores-devem-jogar-go
tags:
- go
draft: false
---

Faz tempo que não faço traduções, mas este artigo foi bastante nostálgico para mim, então fiz questão de divulgá-lo. É pelo [Jon Dahl](http://railspikes.com/2008/7/14/why-programmers-should-play-go) do blog **RailSpikes**. Leiam minhas [notas](#akita_go) no final. Aqui vai:

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/7/15/2539473895_47418f2049.jpg)](http://flickr.com/photos/andres-colmen/2539473895/)

[Go](http://en.wikipedia.org/wiki/Go_(board_game)) é um antigo jogo de estratégia com regras simples e um profundo grau de complexidade.

Desenvolvimento de software é a arte de gerenciar complexidade usando um número limitado de regras, estruturas e padrões.

Programadores deveriam jogar Go.


### Go em 2<sup>8</sup> palavras ou menos

A beleza do Go é sua combinação de simplicidade e complexidade. Por um lado, Go tem somente poucas regras. Coloque as pedras, não fique completamente cercado, controle o território. Como xadrez, a mecânica pode ser aprendida em alguns minutos, embora Go tenha somente um único tipo de “movimento”, e somente um caso extremo (a regra [Ko](http://en.wikipedia.org/wiki/Rules_of_Go#Ko_.28no_repetition_of_the_same_shape.29)). E como xadrez, uma pessoa pode gastar a vida toda descobrindo as camadas estratégicas e táticas do jogo.

Enquanto xadrez é bem complexo e rico, tal que levou um supercomputador de 30 nós para derrotar o campeão de xadrez, nenhum computador chega próximo de derrotar mesmo um jogador amador de Go. Existem 361 posições no tabuleiro de Go e, com dois jogadores, existem 2,08168199382×10<sup>170</sup> posições válidas. Isso é pouco maior do que um [googol](http://en.wikipedia.org/wiki/Googol) (sim, é assim que se escreve). Realisticamente, existe algo na ordem de 10<sup>400</sup> jeitos diferentes que um típico jogo pode ser jogado. E o número de movimentos possíveis mais ou menos segue 361! (361 fatorial), o que significa que com somente uns 20 movimentos, existem muitos googols maneiras possíveis que um jogo pode continuar. (Como curiosidade, experimente calcular 361! em uma [calculadora fatorial](http://www.cs.uml.edu/~ytran/factorial.html) online).

### Gerenciando Complexidade

Então, como uma pessoa pode jogar Go, dada a complexidade quase infinita? Em um nível tático, um jogador encara Go como xadrez, pensando vários movimentos à frente. Mas isso somente funciona em pequenos espaços, como uma batalha apertada em um pequeno setor do tabuleiro. Mais do que isso, existem possibilidades demais. Então, de maneira estratégica, um jogador precisa pensar em padrões de [formas](http://en.wikipedia.org/wiki/Shape_%28Go%29). Essas formas dão atalhos para o gerenciamento de complexidade do Go. Como um não-mestre, posso não ter nenhuma idéia de como as coisas vão acontecer em um setor do tabuleiro, mas posso ser capaz de reconhecer padrões fortes e fracos de pedras, formas vulneráveis e formações efetivas.

Mas há mais: Go tem diversas formas de padrões. Mais do que formas, existem [provérbios de Go](http://senseis.xmp.net/?GoProverbs). Eles podem ser generalistas: _“O bom movimento de seu oponente é seu bom movimento”_; específicos: _“Não tente cortar o salto de um ponto”_; e meta: _“Não siga provérbios cegamente.”_ Esses provérbios são princípios que ajudam um jogador a tomar boas decisões. Eles são menos específicos do que formas, e portanto fornecem guias para quaisquer situações que possam surgir no tabuleiro de Go. Provérbios podem entrar em conflito, e um jogador deve determinar quando e como aplicá-los.

Finalmente, existe [Joseki](http://en.wikipedia.org/wiki/Joseki). Joseki são padrões de jogo que são considerados iguais para ambos os lados. Eles tipicamente acontecem em cantos do tabuleiro, e tipicamente no começo do jogo. De forma interessante, existe um provérbio no Go que diz _“Aprender joseki custa 2 pedras”_ o que pode significar que memorizar esses padrões não é interessante. Em vez disso, um jogador deve aprender _a partir_ dos joseki entendendo o que está acontecendo a cada movimento.

### Padrões em Go, padrões em design de software

Cada um desses padrões de Go tem, mais ou menos, um análogo em programação.

Formas em Go não são como [design patterns](http://c2.com/cgi/wiki?DesignPatterns) em software. Enquanto não há nada que o previna de colocar lógica em suas views, essa forma é [reconhecida](http://www.vimeo.com/1050804) como uma forma fraca. Pense em design patterns do Gang-of-Four: os padrões MVC, Adapter e Factory são reconhecidas como úteis em algumas circunstâncias (e não apropriadas em outras). Em um nível mais baixo, iteração e recursão tem formas comumente reconhecidas, assim como normalização de bancos de dados vs. denormalização. Mesmo que você não possa ter um programa inteiro ou algoritmo de cabeça de uma vez, reconhecer formas padrão ajuda a entender o que está acontecendo.

Provérbios de Go são como outras formas de padrões em software: CapitalizedPrinciples (por falta de um termo melhor) que se tornou popular graças a Extreme Programming. Pense em DontRepeatYourself, YouArentGonnaNeedIt, CollectiveCodeOwnership, DailyBuild, TestFirst. Eles não são “formas” de código, como uma classe singleton – são princípios gerais que guiam a prática de programação.

Como joseki é sobre troca entre pares competidores, seu paralelo de programação é um pouco menos claro. A comparação mais próxima, na minha cabeça, são exercícios de programação. [Este artigo](http://binstock.blogspot.com/2008/04/perfecting-oos-small-classes-and-short.html), por exemplo, sugere 9 exercícios para ajudá-lo a se tornar um melhor programador OO, como:

- use apenas um ponto por linha
- use apenas um nível de identação por método
- não use setters, getters ou propriedades

Em um programa real, você não seguirá esses princípios 100% do tempo. Mas se forçar a escrever dessa maneira pode ser uma experiência de abrir os olhos e pode torná-lo um desenvolvedor melhor.

### Então o que Go pode realmente fazer por você?

Obviamente, esses paralelos são estruturais. Especificamente os provérbios de Go podem não ter relevância direta com desenvolvimento de software. Então, pode Go realmente torná-lo um melhor desenvolvedor?

Eu acho que pode, e vou mais fundo. Acho que Go pode torná-lo mais esperto. Existem muitas evidências não científicas sobre esse efeito [<sup class="footnote" id="fnr1"><a href="#fn1">1</a></sup>](http://www.godiscussions.com/forum/archive/index.php/t-6061.html), [<sup class="footnote" id="fnr2"><a href="#fn2">2</a></sup>](http://news.ycombinator.com/item?id=133178), [<sup class="footnote" id="fnr3"><a href="#fn3">3</a></sup>](http://news.ycombinator.com/item?id=228356), por exemplo, [<sup class="footnote" id="fnr4"><a href="#fn4">4</a></sup>](http://www.china.org.cn/english/features/Archaeology/131298.htm) :

> De fato, todas as nossas mentes podem se beneficiar com o aprendizado do Go, que oficialmente tem a capacidade de torná-lo mais esperto. Pesquisas demonstram que crianças que jogam Go tem o potencial de grande inteligência, já que motiva os dois lados do cérebro.

A pesquisa mencionada não tem bibliografia, infelizmente, portanto não leve esse tipo de afirmação ao pé-da-letra.

Mas faz muito sentido: como xadrez, Go requer reconhecimento de padrões, uma mistura de estratégia e pensamento tático, e compreensão de estruturas complexas, embora em Go os padrões são maiores e muito mais complexos. Uma mente treinada a pensar dessa maneira terá mais facilidade em atacar problemas similares em outras esferas.

Como desenvolvimento de software.

### Notas do Akita

Há muito tempo eu gosto de Go. Como descendente de japonês é claro que eu já vi Go, Shogi e outros jogos orientais. Mas, como todo bom japonês ocidental, eu dei muita pouca atenção a isso. Por causa disso, hoje não sei mais do que as regras e filosofias básicas por trás do Go.

Particularmente o interesse se renovou quando li a série [Hikaru no Go](http://en.wikipedia.org/wiki/Hikaru_no_Go) que é uma história inteira sobre Go – uma das minhas séries favoritas, por sinal. Cheguei a comprar um tabuleiro de Go, alguns livros de Joseki, mas não fui muito longe. Hoje em dia apenas dou umas espiadas nos jogos online nos servidores da [IGS](http://www.pandanet.co.jp/English/)

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/7/15/1hikaru800.jpg)](http://www.onemanga.com/Hikaru_no_Go/)

Não lembro onde li isso, mas alguém chegou a mencionar uma coisa que interessante: xadrez é um jogo primordialmente de destruição. Go é um jogo essencialmente de conquista e expansão. Não é literalmente verdade, mas há nuances em Go que me remetem a isso. E no paralelo a desenvolvimento de software, design patterns não são apenas estrutura que você copia e cola onde “acha” que são necessários. Um punhado de design patterns não faz um bom software.

O que o Jon quis dizer faz muito sentido. Assim como um jogador de Go, um desenvolvedor de software precisa ser um artista. Jogar é uma atividade criativa. Estratégia é uma atividade criativa. Dada uma série de limitações, qual o melhor caminho a seguir?

Mais do que isso: a única maneira de aprender Go é jogando, centenas de milhares de vezes durante muitos e muitos anos. Profissionais de Go se formam lá entre os 10 anos de idade e sobem dali até a velhice. A única forma de aprender é errando, errando e errando. O que volta ao que o Ryan falou sobre [Machucar Código](http://www.akitaonrails.com/2008/6/14/machucando-c-digo-por-divers-o-e-lucro).

Refatoramento é algo parecido com isso: conquista e expansão. Somente um bom desenvolvedor entende os reais motivos de refatoramento. Ninguém refatora porque alguém mandou refatorar, da mesma forma que um artista não faz um certo traço porque alguém mandou fazer. Um bom desenvolvedor não dá valor a siglas, marcas e nomes da moda. Ele dá valor à forma e à filosofia do que se constrói.

Falta algo de filosofia oriental nos programadores de hoje. Ser um codificador no estilo empilhador-de-tijolos é muito fácil: qualquer peão pode fazer. Agora, chegar ao [10<sup>o</sup> dan](http://en.wikipedia.org/wiki/Go_ranks_and_ratings) de programação, é somente para os que se esforçaram muito na arte.

