---
title: "[Off-Topic] Procurar Raciocinar Faz Bem"
date: '2009-09-26T16:17:00-03:00'
slug: off-topic-procurar-raciocionar-faz-bem
translationKey: off-topic-procurar-raciocionar-faz-bem
description: "Programação em par exige piloto e co-piloto ativos, agilidade é accountability, e a discórdia entre Spolsky e Bob Martin vira mote para testar práticas ágeis, entender seus motivos e recusar dogmas."
tags:
- engenharia-de-software
- agile
- off-topic
draft: false
---

[![Rails Summit 2009](http://railssummit.com.br/imgs/43/original/728x90.gif)](http://www.railssummit.com.br?utm_campaign=Railssummit&utm_source=banner_parceiros&utm_medium=banner&utm_content=por_728x90)

Esta semana surgiram alguns artigos interessantes, todos ligados de alguma forma ao pensamento "Agile" de desenvolvimento de software.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/Screen_shot_2009-09-26_at_6.51.42_PM_original.png)

O primeiro, que achei muito bom, foi [10 razões porque Pair Programming não é para as massas](http://web.archive.org/web/20090927081120/http://blog.obiefernandez.com/content/2009/09/10-reasons-pair-programming-is-not-for-the-masses.html), que o Obie Fernandez escreveu sobre a própria experiência com programação pareada e por que ela é difícil de implementar na maioria dos lugares.

Os pontos se resumem a limitações físicas (cubículos são tão século XX...) e a convencionalismos corporativos ainda em voga, como entrevistas de RH baseadas em currículo e certificação. Para mim, os dois mais importantes são o 2º e o 6º. Como qualquer conceito, se interpretado da forma errada, dá resultados errados.

A primeira coisa a entender sobre programação pareada é que sempre existem piloto e co-piloto. A imagem comum é a do piloto produzindo enquanto o co-piloto apenas observa, passivo e silencioso. Essa é a forma errada de parear, e é justamente ela que faz um gerente achar que paga por duas pessoas e recebe o trabalho de uma.

Em programação pareada, os dois participam o tempo todo. O co-piloto fica atento aos erros do piloto, pensa à frente e já imagina alternativas melhores. Mais do que isso, teclado e mouse trocam de mão constantemente. Não existe pareamento em que o co-piloto passa o dia só olhando. Se ele fica passivo e calado, o piloto está pilotando sozinho, ponto.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/ying_eric_pair_programming_original.jpg)


Existem pelo menos dois tipos de par: um em que ambos têm capacidades parecidas, e outro em que um é menos experiente ou tem habilidades diferentes. No primeiro caso a dinâmica é mais óbvia, as ideias batem mais e as decisões saem mais rápido.

No segundo caso, um deles tem o objetivo de aprender rápido, e quem sabe menos tem a obrigação de arriscar mais, sempre sob a supervisão do mais experiente. Ele nunca deve ser passivo: precisa buscar conhecimento por fora, fora das sessões de pareamento, e não esperar que o piloto ensine tudo. Quem sabe menos é quem corre atrás, ou então assume que não vai dar e abre mão da posição.

Vale lembrar que o valor fundamental da Agilidade se chama _"accountability"_. Não dá para traduzir ao pé da letra, mas é algo além de "responsável". Uma equipe ágil é conscientemente accountable pelo que faz.

Quando ela decide o Sprint Backlog junto com o cliente e o product owner, não está recebendo ordens do tipo _"este sprint terá estas 10 user stories porque o chefe mandou."_ A equipe que se compromete com 10 stories está de fato se comprometendo: tem consciência da própria velocidade, das capacidades e das fraquezas, e decide com base nisso.

A equipe que depois diz _"não deu para entregar porque pediram demais"_ está fugindo da responsabilidade. Ela deveria ter dito, no começo, _"não, só conseguimos fazer 8 dessas stories, 10 é demais."_ Combinado não sai caro. É tudo questão de acertar expectativas, negociar e colaborar para achar a melhor solução, não qualquer solução.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/pair_programming_original.jpg)

O mesmo vale no mundo reduzido de dois programadores pareando. Os dois precisam estar comprometidos com o que produzem e com o colega. Se um é menos experiente, não pode ser peso morto; se o mais experiente vê que o outro está tentando, deve ajudar.

Existe um limite entre ajudar e carregar nas costas. Aqui vale a honestidade, e é para isso que existe a Retrospectiva no fim do Sprint: o momento de colocar tudo às claras. _"Não gosto de estar produzindo sozinho enquanto meu par não ajuda."_

Programação em par, sozinha, é só uma técnica. Antes dela vêm os valores do [Manifesto Ágil](http://agilemanifesto.org/), e todo mundo esquece o primeiro: _"Indivíduos e Interações mais do que Processos e Ferramentas."_

Se você ainda se pergunta "quais técnicas ágeis eu devo escolher", ainda não entendeu. Antes de tudo: você está comprometido com o projeto? Sua equipe está comprometida com o projeto e com os pares? Quais problemas você quer resolver?

Agilidade não é receita mágica. Ela tem propósitos. Se você não mira nesses propósitos e só escolhe duas ou três práticas ao acaso, isso não o torna ágil, apenas aleatório.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/493px-Joel_spolsky_on_20_sept_2007_original.jpg)

Aí entra o artigo do Joel Spolsky, [O Programador Fita Adesiva](http://www.joelonsoftware.com/items/2009/09/23.html). Nele, Spolsky celebra Jamie Zawinski, um grande programador que trabalhou na Netscape produzindo software que ajudou a mudar o mundo, literalmente.

Zawinski, segundo Spolsky, é do tipo _"vamos lançar o mais rápido possível, não importa como"_ e _"testes unitários são bonitos, mas quando o prazo aperta o que importa é entregar, e teste atrapalha."_ Lido da maneira errada, isso vira desculpa para o mau programador dizer: _"Viva, o Joel Spolsky confirmou que ser cowboy é lindo!"_ Ou pior: _"O Spolsky disse que eu não preciso me preocupar com testes."_

Antes de pular para uma conclusão precipitada, e maldita geração fast-food, leia a resposta escrita pelo bom e velho [Uncle Bob Martin](http://blog.objectmentor.com/articles/2009/09/24/the-duct-tape-programmer), onde ele refuta esses argumentos. Spolsky e Bob já se pegaram algumas vezes: num podcast, o [Spolsky menosprezou TDD e os princípios SOLID](http://www.infoq.com/news/2009/02/spolsky-vs-uncle-bob).

Se você não conhece, Robert Martin foi quem convocou a reunião de cerca de oito anos atrás que deu origem ao Manifesto Ágil, ao lado dos principais nomes da área, como Kent Beck, Martin Fowler, Dave Thomas e Jeff Sutherland. Ele programa desde antes de muita gente aqui ter nascido, e continua programando até hoje.

E não estou falando de um sênior que só mexe em Cobol. Ele passou pelas principais plataformas, entende orientação a objetos como poucos, programa em Java e defende [Código Limpo](http://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882). Se você usa GitHub, encontra alguns [projetos do Bob](http://github.com/unclebob) por lá também.

Algum tempo atrás eu provavelmente estaria [xingando e amaldiçoando](http://web.archive.org/web/20091002042618/http://www.akitaonrails.com:80/2006/9/27/flame-war-joel-spolsky-vs-rails) o Spolsky, mas acho que entendo a posição dele. Spolsky é um grande empresário, com uma empresa e produtos de nicho bem-sucedidos, quase uma 37signals da geração anterior.

Ex-Microsoft, foi um dos responsáveis pela existência do Visual Basic for Applications, que até hoje é o coração do Excel e a menina dos olhos de todo contador e analista que não vive sem as macros. Com Jeff Atwood, mantém o [StackOverflow](http://stackoverflow.com/). E ainda escreveu o ótimo [Joel on Software](http://www.amazon.com/Joel-Software-Occasionally-Developers-Designers/dp/1590593898).

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/photo_martin_r_original.jpg)

A esta altura, assumo que não preciso explicar o que é [Agilidade](http://en.wikipedia.org/wiki/Agile_software_development), nem as boas práticas de [Extreme Programming](http://www.extremeprogramming.org/), nem os [princípios SOLID](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod) do Bob Martin. Também assumo que você já leu pelo menos alguns [artigos](http://www.joelonsoftware.com/) do Spolsky para ter noção do que ele costuma dizer.

Normalmente o agilista parece estar tentando "convencer" os outros de que ser ágil é melhor. E de que agilidade e rapidez são coisas diferentes: a rapidez é efeito colateral da agilidade. São interpretações sutis.

O que eu amaldiçoo é a geração fast-food, acostumada a achar que tudo é simples e superficial. Que basta comprar o livro "emagreça em 7 dias" para de fato emagrecer. Se isso funcionasse, não existiriam obesos no mundo. Duh.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/BurningTheWitch_original.jpg)

Essa mesma geração lê o Spolsky e, na superfície, chega à conclusão que citei: _"o Spolsky concorda que eu devo ser cowboy."_ E nós, agilistas, também somos vítimas disso. Na ânsia de responder a essa superficialidade, às vezes passamos da conta. O Bob Martin, por exemplo, poderia ter ignorado o post em vez de responder.

Pessoas passivas e conformistas esperam ser validadas. Não entendem por que fazem o que fazem, só fazem. Escolhem o que parece mais simples, fácil e seguro, e não o que tem chance de ser melhor ou novo.

Elas querem que gostem delas. Não importa se estão fazendo o certo, nem se existe um jeito melhor. Daí a ânsia por validação. Foi disso que tratei no artigo [Culto da Moral Cinzenta](/2009/09/08/off-topic-o-culto-da-moral-cinzenta).

Quando alguém do "calibre" perceptível de um Spolsky publica um post assim, milhares de programadores nitidamente ruins pelo mundo se sentem validados e justificados. É um cenário triste.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/BRILLIANT_original.jpg)

E o Spolsky não está errado. Cada artigo dele traz um pedaço da própria experiência. Sozinho, cada pedaço não significa quase nada, e não deve ser levado ao pé da letra. Nem o que o Bob Martin escreve. Nem o que eu escrevo.

A soma das partes é ordens de grandeza maior do que a soma dos valores individuais de cada uma. É assim que o caos funciona.

Spolsky e Bob não são antagônicos. O que um diz não invalida o outro, e esse é o truque. Os dois são pragmáticos, pelo menos na definição de pragmatismo de William James: algo é verdadeiro para uma pessoa se tem utilidade para ela, independentemente de continuar verdadeiro para outra. (Existe ainda o pragmatismo de Peirce e Dewey, mas isso é outra história.)

Os dois tentam explicar o que funciona para eles. Dentro de um contexto, entendendo as premissas e os valores, isso talvez funcione para você também.

O que o Spolsky diz faz sentido para ele. O que o Bob Martin diz faz sentido para ele. Se faz sentido para mim, ou para você, isso **não** é problema deles, não é culpa deles, nem deveria ser do interesse deles. E não use o nome deles para justificar o que você faz sem entender por quê. _"Eu faço TDD porque o Kent Beck disse que é bom"_ é tão ruim quanto _"eu faço código-grude porque o Zawinski disse que é melhor."_

O certo é dizer: _"faço TDD porque **sei** quais benefícios isso me traz."_ Ou, _"faço código-grude de vez em quando porque tenho **consciência** das consequências e aceito pagar o preço."_ Ou, _"não faço programação em par o tempo todo porque **analisei** e concluí que, no meu caso, não funciona bem."_

Aliás, tudo que escrevo aqui no blog são elucubrações e reflexões pessoais que acabam encontrando forma escrita. Alguns acham que eu "me acho o dono da verdade". Isso é problema de quem acha, não meu.

Verdade seja dita: como o Bob diz no artigo dele, eu também não faço testes o tempo todo, muito menos testes primeiro como manda o TDD. Só conheci as práticas de Extreme Programming muitos anos depois de começar a programar, e fui um programador extremamente cowboy na maior parte da carreira.

Mesmo entendendo por que as práticas ágeis são boas e por que eu deveria usá-las, ainda raciocino onde e quando aplicar cada uma. Entendo os princípios, as premissas e os resultados esperados. Caso contrário, viraria [dogmatização](http://en.wikipedia.org/wiki/Dogma), e todo dogma é ruim por definição. **Dogmas são a origem de todo o mal.**

Tudo deve ser questionado, experimentado, medido e analisado, e só então uma conclusão pode surgir, sujeita a ser refutada por novas evidências. O oposto do dogma, ou do cargo cult, é o [Método Científico](/2008/12/16/off-topic-m-todo-cient-fico-vs-cargo-cult), como já expliquei antes.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/world-trade-center_original.jpg)

Só porque foi o Martin Fowler quem falou, não vira verdade incontestável. Só porque o [Ward Cunningham](http://en.wikipedia.org/wiki/Ward_Cunningham) falou, não é verdade absoluta. Todos eles, todos nós, somos humanos, e humanos falham. Falhamos muito mais do que gostaríamos.

Num mundo em que as pessoas falham, o que funciona melhor é o conhecimento coletivo, onde o erro de um é compensado pela inteligência complementar do outro. Por isso as comunidades, ao menos as que primam por conhecimento e evolução, tendem a ser ordens de grandeza menos falíveis do que um único indivíduo.

Se um indivíduo tem o conhecimento "A" e outro tem o "B", nenhum dos dois tem o conhecimento total, mas o conjunto dos dois, a comunidade, tem os dois. Sozinhos, cada um sabe só uma parte. A entidade chamada comunidade é o mais perto que chegamos da onisciência.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/charles_darwin_l_original.jpg)

Compartilhar conhecimento traz benefícios, e é por isso que fazemos, não por puro altruísmo. Dar sem receber nada não se sustenta; muita gente dá porque isso traz paz de espírito ou satisfação pessoal, e isso já é um tipo de retorno.

Kent Beck, Martin Fowler e Ken Schwaber não estão "dando" nada. Estão compartilhando: ao fomentar os valores ágeis, recebem de volta em conhecimento, reconhecimento e oportunidades. Isso é a boa e velha evolução darwinista, a única coisa que funciona de fato para a melhoria contínua.

O objetivo não é "vender" Agile. Quando evangelizo a filosofia ágil, não tenho intenção de convencer ninguém a usar, e não ganho nada se mais gente adotar. Às vezes me cobram: _"se eu usar Agile, você garante resultados melhores?"_ E eu respondo: _"claro que não, não garanto nada."_

Compartilho o que funciona para mim; se vai funcionar para os outros, não é problema meu. O que eu espero é que quem usa e descobre coisas novas compartilhe de volta, para eu melhorar também.

E, claro, se alguém me entrega código mal feito, cheio de fita adesiva e sem um teste sequer, e espera que eu conviva com isso calado, está muito enganado, porque isso não funciona para mim. Concordando com o Bob Martin: [Bagunça não é Dívida Técnica, é só Bagunça](http://blog.objectmentor.com/articles/2009/09/22/a-mess-is-not-a-technical-debt).

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/10commandments_original.jpg)

Uma dica: qualquer coisa "escrita em pedra", que um dia foi o resumo do conhecimento coletivo de um grupo mas virou dogma, é ruim. Foi útil para as pessoas da época, mas provavelmente não vale mais hoje. Se ainda seguíssemos os dogmas de desenvolvimento de software de 50 anos atrás, estaríamos deixando de lado o que a tecnologia e o conhecimento de hoje permitem.

Já um corpo de conhecimento que se permite evoluir, refinar, jogar fora o que não serve mais e incorporar o que se aprende tem muito mais chance de estar certo. A comunidade ágil funciona mais ou menos assim. A comunidade open source também. Nenhuma é perfeita, mas é a busca pela perfeição que torna o caminho interessante.

Seja cético.
