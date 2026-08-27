---
title: "[Off-Topic] Conversando com um Professor Universitário"
date: '2014-12-08T19:56:00-02:00'
slug: off-topic-conversando-com-um-professor-universitario
translationKey: off-topic-conversando-com-um-professor-universitario
description: "Ao responder a um professor, o autor defende UML seletiva, Design Patterns como referência, XP e múltiplos paradigmas. Java continua útil, mas a universidade deve priorizar fundamentos."
tags:
- aprendizado
- linguagens-de-programacao
- carreira
- off-topic
draft: false
---

Alguns dias atrás o professor Rosenclever Gazono, do Centro Universitário de Volta Redonda, me enviou um email pedindo algumas opiniões que achei interessante compartilhar. Já conheci muitos professores durante minhas visitas a diversas faculdades do país e muitos têm as mesmas dúvidas, então espero que isso ajude um pouco.

A seguir, vou transcrever as perguntas do professor e minhas respostas.

**Professor:** Meu nome é Rosenclever, sou professor universitário atualmente ministrando as disciplinas de Análise e Projeto Orientado a Objetos (Basicamente UML, Padrões de Projeto e Metodologias ágeis) e Programação Orientada a Objetos 2 (Java para Web com JPA e JSF)

Pois bem, como você além de desenvolvedor hoje também exerce um papel de empresário e eu, por outro lado, estou na academia, buscando preparar profissionais para atuarem no mercado, sempre busco tentar atualizar meu conteúdo com a demanda do mercado e é muito comum ouvir de gerentes de TI, por meio da mídia, que existe um gap muito grande entre o que se ensina na academia e o que o  mercado necessita...

Desta forma, gostaria de pedir sua contribuição no sentido de que eu possa ajudar meus alunos a saírem mais preparados para o mercado. Assim, gostaria de saber a sua opinião sobre as ementas das disciplinas que falei no início deste email...

**Professor:** 1) Faz sentido atualmente dominar os diagramas UML?

**AkitaOnRails:** “Dominar” talvez não (no sentido de saber cada detalhezinho de cada diagrama). Mas saber que existem, ter uma noção geral de cada um, e saber os mais úteis como Casos de Uso, Diagrama de Sequência, Diagrama de Estado, Diagrama de Classes, acho adequado e útil. E nunca como uma forma de desenhar TODO o software, mas algumas partes que talvez fiquem mais claras se diagramar primeiro.

Acrescento aqui no post que muita gente que nunca programou profissionalmente acha que "todo e qualquer" tipo de diagramação e planejamento é desnecessário. Essas pessoas ainda imaginam (sem saber) que o tal mundo "corporativo" é dirigido por montanhas de diagramas e planos. Isso quase nunca é verdade.

Claro que existem exceções, mas no caso comum um programador precisa comunicar uma ideia por algo além de código. Isso vale principalmente na hora de explicar uma arquitetura complexa para a equipe, antes de começar a codificar.

Não significa diagramar 100% das classes, 100% dos estados, 100% das sequências. Significa diagramar o que for mais crítico e mais difícil de entender, e deixar o resto emergir naturalmente durante a programação.

**Professor:** 2) Quais Design Patterns e conceitos de agile considera fundamentais para serem ministrados na academia? Ou isso também não é considerado importante?

**AkitaOnRails:** Design Patterns são importantes sim, mas como referência. São soluções possíveis, e precisam ser avaliadas caso a caso. Em Agile, preocupe-se só com Extreme Programming, porque todas as técnicas de XP são importantes. Scrum e Kanban podem ser introduzidos, mas são dispensáveis. Sobre patterns:

* [A Língua Portuguesa-Brasileira Pode Nos Confundir: Standard vs Pattern](http://www.akitaonrails.com/2013/05/10/a-lingua-portuguesa-brasileira-e-pessima-standard-vs-pattern)
* [GoF Design Patterns - Sobreviveu ao teste do tempo?](http://www.akitaonrails.com/2007/07/30/gof-design-patterns-sobreviveu-ao-teste-do-tempo)
* [Design Patterns representam defeitos nas Linguagens](http://www.akitaonrails.com/2006/10/30/design-patterns-representam-defeitos-nas-linguagens)

Acrescento aqui no post que o importante é ensinar que ninguém precisa inventar tudo do zero o tempo todo. Isso seria um esforço redundante, já que alguém provavelmente já resolveu o problema antes.

Ao mesmo tempo, vale explicar que o que sabemos hoje é apenas o que parece funcionar melhor, e nada disso é definitivo. Se alguém tiver um resultado que supera o que conhecemos, ótimo, que mostre para todo mundo.

Virou moda falar em "Inversão de Controle", e pouca gente sabe o que isso realmente significa. Sabem apenas que parece melhorar a "modularização", também sem entender por que modularizar é um benefício em alguns casos e nem tanto em outros.

E falando de Agile, recomendo ler estes meus posts:

* [Lean está Morto, longa vida à Eficiência](http://www.akitaonrails.com/2014/03/27/off-topic-lean-esta-morto-longa-vida-a-eficiencia)
* [Agile: a Verdade por trás do Método](http://www.akitaonrails.com/2014/09/28/off-topic-agile-a-verdade-por-tras-do-metodo)

**Professor:** 3) Será que a disciplina de Análise e Projeto OO faz sentido ainda hoje? O que seria interessante de ser abordado na mesma?

**AkitaOnRails:** Claro que sim, mas hoje é preciso ressaltar que OO (orientação a objetos) é uma abordagem entre várias, e nem sempre a “melhor”.

Aliás, OO só fica interessante na academia pelos olhos de linguagens que exploram OO de verdade, como Smalltalk e Ruby. Vale mostrar o panorama inteiro: programação orientada a classes em Java e C#, funcional em Lisp e Scheme, orientada a protótipos em Javascript e Io, e programação com concorrência e atores em Go, Scala e Elixir/Erlang.

Acrescento ao post que esse é o tipo de tema sem resposta "certa". Qualquer tentativa de medir forças de um lado ou de outro sempre vira flamewar ou um bikeshedding medíocre.

A realidade é que as fábricas de software vão continuar usando linguagens com bom suporte ferramental comercial, como IBM Websphere e Microsoft Visual Studio.NET. As tech startups e empresas menores, mais orientadas a tecnologias "best of breed", vão preferir soluções open source que às vezes parecem uma "colcha de retalhos".

Agências e pequenas produtoras vão continuar usando o que entregar no menor tempo possível, mesmo que seja sujo. Campanhas publicitárias duram muito pouco, então sobra o "quick and dirty", os derivados de WordPress e por aí vai.

**Professor:** 4) Definitivamente, ainda vale a pena ensinar Java na academia? Acha que Ruby e Rails ou mesmo Python e Django são mais adequados?

**AkitaOnRails:** Sim, vale a pena, desde que Java entre como o que ele realmente é: a linguagem comercialmente mais viável. Ela não é a única solução para tudo nem o melhor exemplo de linguagem OO.

Ruby e Python podem ser explorados como linguagens de tipagem dinâmica, aproveitando para explicar a diferença entre tipagem estática e dinâmica. Mas na academia, principalmente em Ciência da Computação, sempre fui a favor de ensinar linguagens mortas como Smalltalk, Lisp e Eiffel. Isso evita que o aluno caia na tentação de ficar só com a linguagem que aprendeu na faculdade. Um bacharelado deveria primar pela fundação, e o uso comercial fica a cargo da escola técnica e do tecnólogo.

Acrescento ao post que a Academia, principalmente nas cadeiras de Ciência da Computação, precisa enfatizar a ciência. Voltar 100% ao mercado cria uma geração que fica obsoleta muito rápido e, pior, que não aprende a se atualizar sozinha.

Num cenário hipotético, se 100% das universidades se voltassem 100% ao que o "mercado" pede, em dez anos teríamos toda a nossa área de computação sucateada. As universidades precisam elevar a "Ciência" da Ciência da Computação.

Aproveito para deixar posts que escrevi sobre os assuntos de faculdade e carreira:

* [Devo fazer faculdade?](http://www.akitaonrails.com/2009/04/17/off-topic-devo-fazer-faculdade)
* [Carreira em Programação - Codificar não é Programar](http://www.akitaonrails.com/2014/05/02/off-topic-carreira-em-programacao-codificar-nao-e-programar)
* [Carta para um Jovem Programador Considerando uma Startup](http://www.akitaonrails.com/2013/10/31/traducao-carta-para-um-jovem-programador-considerando-uma-startup)

**Professor:** Desculpe-me pelo longo email, mas infelizmente não houve oportunidade de conversarmos no evento...

**AkitaOnRails:** De forma nenhuma, se o assunto é relevante, vale a pena discuti-lo. E incentivo todos que forem em eventos que eu estiver, que me chamem se quiserem discutir formas que podemos ajudar a melhorar o ensino. Esse assunto nunca vai ser irrelevante.
