---
title: "[Off-Topic] Conversando com um Professor Universitário"
date: '2014-12-08T19:56:00-02:00'
slug: off-topic-conversando-com-um-professor-universitario
tags:
- off-topic
- career
draft: false
---

Alguns dias atrás o professor Rosenclever Gazono, do Centro Universitário de Volta Redonda, me enviou um email pedindo algumas opiniões que achei interessante compartilhar. Já conheci muitos professores durante minhas visitas a diversas faculdades do país e muitos tem as mesmas dúvidas, então espero que isso ajude um pouco.

A seguir, vou transcrever as perguntas do professor e minhas respostas.

**Professor:** Meu nome é  Rosenclever, sou professor universitário atualmente ministrando as disciplinas de Análise e Projeto Orientado a Objetos (Basicamente UML, Padrões de Projeto e Metodologias ágeis) e Programação Orientada a Objetos 2 (Java para Web com  JPA e JSF)

Pois bem, como você além de desenvolvedor hoje também exerce um papel de empresário e eu, por outro lado, estou na academia, buscando preparar profissionais para atuarem no mercado, sempre busco tentar atualizar meu conteúdo com a demanda do mercado e é muito comum ouvir de gerentes de TI, por meio da mídia, que existe um gap muito grande entre o que se ensina na academia e o que o  mercado necessita...

Desta forma, gostaria de pedir sua contribuição no sentido de que eu possa ajudar meus alunos a saírem mais preparados para o mercado. Assim, gostaria de saber a sua opinião sobre as ementas das disciplinas que falei no início deste email...

**Professor:** 1) Faz sentido atualmente dominar os diagramas UML?

**AkitaOnRails:** “Dominar” talvez não (no sentido de saber cada detalhezinho de cada diagrama). Mas saber que existem, ter uma noção geral de cada um, e saber os mais úteis como Casos de Uso, Diagrama de Sequência, Diagrama de Estado, Diagrama de Classes, acho adequado e útil. E nunca como uma forma de desenhar TODO o software, mas algumas partes que talvez fiquem mais claras se diagramar primeiro.

Acrescendo aqui no post que muitos que não aprenderam a programar profissionalmente achem que "todo e qualquer" tipo de diagramação e planejamento seja desnecessário, e ainda acreditam (sem saber) que o tal mundo "corporativo" é todo dirigido por montanhas de diagramas e planos. E isso não é verdade. Claro que existem exceções mas no caso comum um programador precisa conseguir comunicar uma idéia mais do que somente por código, especialmente ao tentar explicar uma arquitetura complexa para uma equipe antes de começar a codificar. Não significa fazer diagramas pra 100% das classes, 100% dos estados, 100% das sequências, etc, mas sim diagramar o que for o mais crítico, o mais difícil de entender, e deixar o resto que vai emergir naturalmente durante a programação.

**Professor:** 2) Quais Design Patterns e conceitos de agile considera fundamentais para serem ministrados na academia? Ou isso também não é considerado importante?

**AkitaOnRails:** Design Patterns são importantes sim, mas como referência. Elas existem, são possíveis soluções mas devem ser avaliadas caso a caso. Já técnicas Agile só se preocupe com Extreme Programming. Todas as técnicas de XP são importantes. Scrum, Kanban, pode ser introduzido mas são desnecessárias. Sobre patterns:

* [A Língua Portuguesa-Brasileira Pode Nos Confundir: Standard vs Pattern](http://www.akitaonrails.com/2013/05/10/a-lingua-portuguesa-brasileira-e-pessima-standard-vs-pattern)
* [GoF Design Patterns - Sobreviveu ao teste do tempo?](http://www.akitaonrails.com/2007/07/30/gof-design-patterns-sobreviveu-ao-teste-do-tempo)
* [Design Patterns representam defeitos nas Linguagens](http://www.akitaonrails.com/2006/10/30/design-patterns-representam-defeitos-nas-linguagens)

Acrescentando aqui no post: o importante é ensinar que não é necessário inventar tudo do zero o tempo todo (que seria um esforço redundante, dado que alguém já fez isso antes). Ao mesmo tempo é importante explicar que o que sabemos hoje não é perfeito, é apenas o que parece que funciona melhor e se alguém achar que tem um resultado que supera o que conhecemos, por favor nos mostre. Está muito em moda ficar falando em "Inversão de Controle" e pouca gente sabe o que isso realmente significa, apenas que isso parece melhorar a "modularização" - também sem saber porque modularizar é um benefício algumas vezes, ou nem tanto em outras.

E falando de Agile, recomendo ler estes meus posts:

* [Lean está Morto, longa vida à Eficiência](http://www.akitaonrails.com/2014/03/27/off-topic-lean-esta-morto-longa-vida-a-eficiencia)
* [Agile: a Verdade por trás do Método](http://www.akitaonrails.com/2014/09/28/off-topic-agile-a-verdade-por-tras-do-metodo)

**Professor:** 3) Será que a disciplina de Análise e Projeto OO faz sentido ainda hoje? O que seria interessante de ser abordado na mesma?

**AkitaOnRails:** Claro que sim, mas hoje em dia tem que ressaltar que OO (orientação a objetos) não é a única e nem necessariamente a “melhor”. Aliás OO só é interessante na academia se for pelos olhos de linguagens que de verdade exploram OO (Smalltalk, Ruby), programação orientada a classes é Java e C#, programação funcional (Lisp, Scheme), programação orientada a protótipos (parte de Javascript, IO), programação com aspectos de concorrência e atores (Go, Scala, Elixir/Erlang).

Acrescentando ao post, devo dizer que esse é o tipo de tema que não tem uma resposta "certa", qualquer tentativa de medir forças de uma lado ou de outro sempre vai virar meramente flamewar ou um medíocre bikeshedding. A realidade é que as fábricas de software vão continuar usando linguagens que tem bom suporte ferramental comercial como IBM Websphere, Microsoft Visual Studio.NET, etc. Tech startups, ou empresas menores e mais orientadas a tecnologias "best of breed" vão preferir soluções open source que, por muitas vezes, pode parecer até uma "colcha de retalhos". Agências e pequenas produtoras vão continuar usando o que oferecer o menor tempo possível de entrega, mesmo que seja sujo (pois campanhas publicitárias duram muito pouco), "quick and dirty", derivados de Wordpress e assim por diante. 

**Professor:** 4) Definitivamente, ainda vale a pena ensinar Java na academia? Acha que Ruby e Rails ou mesmo Python e Django são mais adequados?

**AkitaOnRails:** Sim, vale a pena, mas não como a única solução pra tudo. Nem como um bom exemplo de linguagem OO. Apenas como linguagem comercialmente mais viável. Ruby e Python podem ser explorados no sentido de linguagens com tipagem dinâmica (e explicar a diferença de estática e dinâmica). Mas na academia, principalmente em Ciência da Computação eu sempre fui a favor de ensinar linguagens mortas (Smalltalk, Lisp, Eiffel) para justamente o aluno não cair na tentação de ficar somente com a linguagem que aprendeu na faculdade. Bacharelado deveria primar pela fundação e não pelo aspecto de “usar comercialmente”, que é foco de escola técnica e tecnólogo.

Acrescentando ao post, acredito que a Academia, principalmente nas cadeiras de Ciência da Computação, devem enfatizar a ciência. Se voltar 100% ao mercado é criar uma geração que vai se tornar obsoleta muito rápido e, pior, que não vai saber se atualizar sozinha. Num cenário hipotético, se 100% das universidades se voltassem 100% ao que o "mercado" precisa, em 10 anos teríamos toda nossa área de computação completamente sucateada. As universidades precisam elevar a "Ciência" da Ciência da Computação.

Aproveito para deixar posts que escrevi sobre os assuntos de faculdade e carreira:

* [Devo fazer faculdade?](http://www.akitaonrails.com/2009/04/17/off-topic-devo-fazer-faculdade)
* [Carreira em Programação - Codificar não é Programar](http://www.akitaonrails.com/2014/05/02/off-topic-carreira-em-programacao-codificar-nao-e-programar)
* [Carta para um Jovem Programador Considerando uma Startup](http://www.akitaonrails.com/2013/10/31/traducao-carta-para-um-jovem-programador-considerando-uma-startup#.VIYdkNYkMvs)

**Professor:** Desculpe-me pelo longo email, mas infelizmente não houve oportunidade de conversarmos no evento...

**AkitaOnRails:** De forma nenhuma, se o assunto é relevante, vale a pena discutí-lo. E incentivo todos que forem em eventos que eu estiver, que me chamem se quiserem discutir formas que podemos ajudar a melhorar o ensino. Esse assunto nunca vai ser irrelevante.
