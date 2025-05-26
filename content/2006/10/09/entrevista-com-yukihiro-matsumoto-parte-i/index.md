---
title: 'Entrevista com Yukihiro Matsumoto: parte I'
date: '2006-10-09T05:03:04-03:00'
slug: entrevista-com-yukihiro-matsumoto-parte-i
tags:
- interview
- matz
- translation
draft: false
---

 ![](/files/matz.png)

Calma! Esta não é a entrevista exclusiva que está disponível no meu livro. Esta foi feita pelo site [Artima](http://www.artima.com/intv/ruby1.html), entre Bill Venners e Yukihiro Matsumoto. Ela é bem antiga, de 2003. Porém a visão de Matz continua sendo muito relevante principalmente para aqueles que ainda não conhecem bem a linguagem. Se souberem ler em inglês, sigam o link anterior para o artigo original, senão acompanhem minha tradução.

Esta entrevista foi dividida em três partes, por isso também quebrarei em três posts diferentes, começando hoje com a primeira: **“A Filosofia de Ruby”**.


### Uma Conversa com Yukihiro Matsumoto, Parte I

> **Sumário** – Yukihiro Matsumoto, o criador da linguagem de programação Ruby, conversa com Bill Venners sobre a filosofia do design de Ruby, incluindo imperfeições de design, os perigos da ortogonalidade e a importância dos esforços humanos na computação.

Yukihiro Matsumoto, ou _“Matz”_ como é conhecido online, é o criador da linguagem de programação Ruby. Ruby é uma linguagem orientada-a-objetos que serve para escrever tanto scripts rotineiros quanto grandes aplicativos. Matz começou a trabalhar em Ruby em 1993, porque queria uma linguagem que o tornasse produtivo e ainda fosse divertido de usar. Inicialmente popular no Japão, Ruby tem encontrado seu lugar nos corações de programadores por todo o mundo.

Em 24 de setembro de 2003, Bill Venners se encontrou com Yukihiro Matsumoto na conferência JAOO em Aarhus, Dinamarca. Nessa entrevista, que será publicada em múltiplas partes na Artima.com, Yukihiro Matsumo discute a filosofia do design de Ruby, as funcionalidades da linguagem e como se tornar um programador melhor. Nesta primeira parte, Matz filosofa sobre imperfeições no design, os perigos da ortogonalidade, dar liberdade com orientação, o princípio da menor surpresa e a importância do ser humano nos esforços em computação.

#### Linguagem Não-Perfeita

**Bill Venners:** Dave Thomas, co-autor de Programming Ruby: A Pragmatic Programmers’s Guide, me disse que você não acha que o design de uma linguagem deva ser perfeita. Por que não?

**Yukihiro Matsumoto:** Designers de linguagens querem projetar a linguagem perfeita. Eles querem poder dizer _“minha linguagem é perfeita, ela pode fazer tudo”_. Mas é simplesmente impossível projetar uma linguagem perfeita, porque existem duas maneiras de se olhar para uma linguagem. Uma forma é olhando o que pode ser feito com essa linguagem. A outra é olhando como nos sentimos usando essa linguagem – como nos sentimos enquanto estamos programando.

Por causa da Teoria da Integralidade de Turing, tudo que uma linguagem Turing-complete pode fazer, teoricamente, outra linguagem Turing-complete também pode. Você pode fazer tudo em assembler, mas ninguém quer programar mais em assembler. Do ponto de vista do que se pode fazer, portanto, linguagens diferem – mas as diferenças são limitadas. Por exemplo, Python e Ruby dão praticamente o mesmo nível de poder ao programador.

Em vez de enfatizar o _“o quê”_, eu quero enfatizar a parte do _“como”_: como nos sentimos enquanto estamos programando. Essa é a maior diferença de Ruby para outros projetos de linguagens. Eu enfatizo a sensação, em particular, como _Eu_ me sinto usando Ruby. Eu não trabalhei muito para tornar Ruby perfeito para todos. Tentei fazer Ruby perfeito para mim, mas talvez não seja perfeito para você. A linguagem perfeita para Guido van Rossum provavelmente é Python.

#### Ortogonal VS Harmonioso

**Bill Venners:** Dave Thomas também afirma que se eu te pedir para adicionar uma funcionalidade que é ortogonal, você não me atenderá. O que você quer é algo que seja harmonioso. O que isso significa?

**Yukihiro Matsumoto:** Eu acredito que consistência e ortogonalidade são ferramentas de design, não o objetivo principal do design.

**Bill Venners:** O que _ortogonalidade_ significa, nesse contexto?

**Yukihiro Matsumoto:** Um exemplo de ortogonalidade é permitir qualquer combinação de pequenas funcionalidades ou sintaxe. Por exemplo, C++ suporta tanto valores de parâmetro padrões para funções e sobrecarga de nomes de função baseadas em parâmetros. Ambas são boas funcionalidade de se ter em uma linguagem. O compilador sabe como aplicar ambas ao mesmo tempo. Se for ambígua, o compilador dará um erro. Mas se eu olhar o código, preciso aplicar essa regra com meu cérebro também. Preciso adivinhar como o compilador trabalha. Se estiver certo, e eu for esperto o suficiente, não há problema. Mas eu não sou esperto o suficiente, não mesmo, e isso me causa confusão. O resultado será inesperado para uma pessoa comum. Esse é um exemplo de como ortogonalidade é ruim.

**Bill Venners:** Em outra palavras, as funcionalidades ortogonais funcionarão enquanto o escritor do compilador entendê-las e fazê-las funcionar. Mas isso dificulta o entendimento do programador quando ele olha para isso, porque é complicado, porque eu tenho que adivinhar como essas duas coisas trabalham juntas.

**Yukihiro Matsumoto:** As funcionalidades ortogonais, quando combinadas, podem explodir em complexidade.

**Bill Venners:** Então quais as alternativas? O que seria mais harmonioso?

**Yukihiro Matsumoto:** Apenas escolha um dos dois para colocar na linguagem. Você não precisa fazer tudo que pensa. Precisa escolher uma, mesmo que ambas sejam boas.

#### Liberdade e Conforto

**Bill Venners:** Uma das filosofias de design na comunidade Python é fornecer uma e apenas uma maneira de fazer as coisas. Se você fornecer cinquenta maneiras diferentes de fazer a mesma coisa, então você deu conveniência para os escritores de código. As pessoas podem escrever as coisas da sua maneira favorita. A contra-partida é para os leitores de código. Quando eu leio seu código, você pode ter escrito de uma maneira. Quando eu leio o código de outra pessoa, ele pode ter escrito de outro jeito. Então, enquanto leitor, acabo precisando estar familiarizado com todas as maneiras de realizar uma tarefa, não apenas minha maneira favorita de escrevê-la. Essa é a contra-partida do design. A comunidade Python parece preferir a maneira de uma e apenas uma maneira, mas Ruby parece fornecer múltiplas maneiras de fazer a mesma coisa.

**Yukihiro Matsumoto:** Ruby herdou a filosofia Perl de ter mais de um jeito de fazer a mesma coisa. Eu herdei essa filosofia de Larry Wall, que é meu herói, de fato. Quero tornar os usuários de Ruby livres. Quero lhes dar a liberdade de escolher. Pessoas são diferentes. Pessoas escolhem diferentes critérios. Mas se existe uma maneira melhor entre todas, quero encorajar essa maneira tornando-a confortável. Pelo menos é o que tentei fazer. Talvez o código Python seja um pouco mais legível. Todos podem escrever o mesmo estilo de código Python, então ele poder simples de ler, talvez. Mas a diferença de uma pessoa para outra é muito grande. Fornecer apenas uma maneira é de pouca ajuda mesmo usando Python, eu acho. Prefiro fornecer muitas maneiras se for possível, mas encorajar ou orientar os usuários a escolher a melhor maneira, se possível.

#### O Prazer de Ruby

**Bill Venners:** Em um artigo introdutório de Ruby, você escreveu _“Para mim o propósito da vida é parcialmente em ter prazer. Programadores às vezes sentem prazer quando podem se concentrar na parte criativa da programação. Então Ruby foi projetado para fazer programadores felizes”_. Como Ruby pode tornar os programadores felizes?

**Yukihiro Matsumoto:** Você quer aproveitar a vida, não quer? Se conseguir terminar seu trabalho mais rápido e seu trabalho for divertido, isso é bom, não é? Esse é o propósito da vida, em parte. Sua vida é melhor.

Quero solucionar problemas que encontro no cotidiano usando computadores, então preciso escrever programas. Usando Ruby, quero me concentrar nas coisas que faço, não nas regras mágicas da linguagem, como começar com public void alguma coisa alguma coisa para dizer “print hello world”. Apenas quero dizer “print this!”. Não quero todas as diversas palavras mágicas. Quero me concentrar na tarefa. Essa é a idéia básica. Por isso tenho tentado fazer o código Ruby conciso e suscinto.

**Bill Venners:** Permitir aos programadores escrever código conciso e suscinto é uma maneira de torná-los felizes.

**Yukihiro Matsumoto:** Sim, para que possam se concentrar nos problemas. Algumas vezes as pessoas rascunham pseudo-código no papel. Se esse pseudo-código rodar diretamente em seus computadores, é melhor, não é? Ruby tenta fazer isso, ser como pseudo-código que roda. O pessoal de Python diz a mesma coisa.

**Bill Venners:** Sim, o pessoal de Python diz que Python é pseudo-código executável. O que mais tem em Ruby para tornar os programadores felizes?

**Yukihiro Matsumoto:** Em nosso dia-a-dia como programadores, processamos muito texto. Então tentei trabalhar duro em processamento de texto, especificamente na classe string e expressões regulares. Expressões Regulares estão construídos dentro da linguagem e estão bem acertadas para uso. Também precisamos chamar muito o sistema operacional. Ruby pode chamar todas as chamadas de sistema em Unix e a maioria do API do Windows. Isso traz o poder e função do sistema operacinal para o ambiente de linguagem interpretada. Assim você pode fazer a administração diária de sistemas e programar processadores de texto. Esse é o maior domínio pelo menos da minha vida, então trabalhei duro em torná-la bom.

**Bill Venners:** Então, basicamente Ruby me ajuda a aproveitar minha vida me ajudando a fazer meu trabalho mais rápido e com mais diversão?

**Yukihiro Matsumoto:** Ele me ajuda a fazer isso. Não tenho certeza se Ruby funciona para você, mas espero que sim.

#### O Fator Humano

**Bill Venners:** Em uma entrevista, você disse, _“não subestime o fator humano”. Mesmo estando na frente de computadores, eles são meios. Estamos trabalhando para humanos, com humanos"_. O que quis dizer com isso?

**Yukihiro Matsumoto:** Imagine que você está escrevendo um e-mail. Você está na frente de um computador. Está operando o computador, clicando um mouse e digitando em um teclado, mas a mensagem será enviada a um humano, através da internet. Então você está trabalhando na frente de um computador, mas com um humano atrás do computador. A maioria das tarefas que fazemos é para humanos. Por exemplo, cálculo de impostos é contar números para que o governo possa tirar dinheiro do meu bolso, mas o governo é formado por humanos.

A maioria de nossas tarefas é relacionada com humanos, afinal de contas. Então, em programação, ou pedimos a um computador para trabalhar para um humano, ou descrevemos nossos pensamentos a um computador de uma forma não ambígua que ele possa executar. No primeiro caso, fazer o computador trabalhar para humanos, o alvo é o humano através do computador. No segundo caso, expressar nossos pensamentos de maneira clara o suficiente para ser entendida e executada por computadores, expressamos intenção de nosso cérebro humano e, como resultado, ele é executado por computadores. Então, em ambos os casos, o objeto aqui é humano.

**Bill Venners:** Qual a importância de pensar dessa forma? Você diz _“Não subestime o fator humano”_. Por que?

**Yukihiro Matsumoto:** Porque computadores não se importam se é fácil ou difícil me comunicar com eles. Não se importam se eu colocar sequências de bytes de instruções em um arquivo e os alimente ou se uma linguagem de alto nível gerou essas instruções. Os computadores não se importam. Nós humanos nos importamos pelo esforço que pagamos. Normalmente, as pessoas, especialmente engenheiros de computador, focam na máquina. Eles pensam _“fazendo isso, a máquina rodará mais rapidamente. Fazendo isso, a máquina rodará mais eficientemente. Fazendo isso a máquina alguma coisa alguma coisa alguma coisa”_. Eles focam na máquina. Mas de fato precisamos focar em humanos, em como humanos se importam em programar ou operar a aplicação das máquinas. Somos os mestres. Eles são os escravos.

**Bill Venners:** Por enquanto, pelo menos.

**Yukihiro Matsumoto:** Por enquanto, pelo menos, até a era do Exterminador do Futuro.

#### O Princípio da Menor Surpresa

**Bill Venners:** Em uma entrevista, você disse _“Eu projetei Ruby para minimizar minha surpresa. Fiquei muito impressionado quando pessoas por todo o mundo me disseram que Ruby reduzia suas surpresas e aumentaram seu prazer por programar. Agora estou certo que as mentes de programadores são parecidas por todo o mundo”_. Por que o princípio da menor surpresa?

**Yukihiro Matsumoto:** Na verdade, não afirmei que Ruby segue esse princípio. Alguém sentiu que o designd e Ruby seguia essa filosofia, então começaram a dizer isso. Não fui eu quem trouxe isso, de verdade.

Queria minimizar minha frustração enquanto programava, então quis minimizar meu esforço em programar. Esse foi meu objetivo principal em projetar Ruby. Queria ter diversão na programação. Depois que lancei Ruby e muitas pessoas pelo mundo começaram a conhecê-la, eles disseram que se sentiam como eu me sentia. Eles chegaram à frase do princípio da menor surpresa. Mas na realidade, isso é normalmente interpretado errado.

**Bill Venners:** Como é interpretado errado?

**Yukihiro Matsumoto:** Cada um tem seu background. Alguém pode vir de Python, alguém pode ter vindo de Perl, e eles podem ficar surpresos com diferentes aspectos da linguagem. Então eles chegam até mim e me dizem, _“fiquei surpreso por esta funcionalidade da linguagem, portanto Ruby viola o princípio da menor surpresa”_. Espere, espere. O princípio da menor surpresa não é apenas para você. O princípio da menor surpresa significa o princípio da _minha_ menor surpresa. E isso significa “menor surpresa depois de aprender Ruby muito bem”. Por exemplo, fui um programador C++ antes de começar a projetar Ruby. Programei em C++ exclusivamente por dois ou três anos. E depois de dois anos de C++, ele ainda me surpreendia.

