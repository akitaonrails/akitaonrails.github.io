---
title: "[Off-Topic] Procurar Raciocionar Faz Bem"
date: '2009-09-26T16:17:00-03:00'
slug: off-topic-procurar-raciocionar-faz-bem
tags:
- off-topic
- principles
- career
- agile
draft: false
---

[![Rails Summit 2009](http://railssummit.com.br/imgs/43/original/728x90.gif)](http://www.railssummit.com.br?utm_campaign=Railssummit&utm_source=banner_parceiros&utm_medium=banner&utm_content=por_728x90)

Esta semana surgiram alguns artigos interessantes, todos relacionados de alguma forma ao pensamento “Agile” de desenvolvimento de software.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/Screen_shot_2009-09-26_at_6.51.42_PM_original.png)

O primeiro, que eu achei muito bom, foi o [10 razões porque Pair Programming não é para as massas](http://blog.obiefernandez.com/content/2009/09/10-reasons-pair-programming-is-not-for-the-masses.html) que o Obie Fernandez escreveu a respeito de sua própria experiência com programação pareada e porque ela é difícil de ser implementada na maioria dos lugares.

Esses pontos se resumem em limitações físicas (cubículos são tão século XX …), convencionalismos corporativos ainda em voga (entrevistas feitas por RH baseado em currículo, primando por certificação, por exemplo). Para mim, dois dos pontos mais importantes são o 6o. e o 2o. Como qualquer conceito, interpretado da forma errada, dará resultados errados.

A primeira coisa que um programador precisa entender sobre programação pareada é que existem sempre piloto e co-piloto. Há a imagem de que o piloto é o indivíduo produtivo naquele instante e o co-piloto apenas olha e acompanha, passivo, silencioso. De jeito nenhum: esta é a forma errada de se parear e é a forma que, corretamente, os não-programadores (gerentes, etc) imaginam estar pagando 2 pessoas mas tendo apenas o serviço de 1. Em programação pareada, **ambos** precisam obrigatoriamente estar participando. O co-piloto deve estar atento aos erros do piloto. O co-piloto deve estar pensando à frente, já imaginando alternativas melhores, eles devem estar ambos engajados em encontrar as melhores soluções. Mais do que isso: o teclado e o mouse devem conseguir trocar de mãos constantemente. Não existe pareamento onde o co-piloto fica o dia inteiro apenas observando. Se o co-piloto é passivo e silencioso, o piloto está pilotando sozinho, é como se ele estivesse sozinho, ponto.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/ying_eric_pair_programming_original.jpg)


Existem pelo menos dois tipos de pares: onde ambos são razoavelmente equivalentes em termos de capacidades ou onde um dos dois é menos experiente ou tem capacidades um pouco diferentes. No primeiro caso, a dinâmica deve ser mais óbvia, as idéias vão bater mais vezes, eles vão conseguir decidir coisas mais rapidamente. No segundo caso, um deles tem o objetivo de aprender rápido. Mais do que isso, o que sabe menos tem a obrigação de arriscar mais, sempre sob a supervisão do mais experiente. E jamais deve ser passivo, ele deve buscar conhecimento fora, quando não estão pareando, e nunca deve esperar que tudo o que ele vai aprender é o piloto quem tem a obrigação de ensinar. Isso é errado: quem sabe menos é quem sempre tem a obrigação de correr atrás, ou então assumir que não vai conseguir e abdicar da posição.

Lembrando que o valor fundamental da Agilidade se chama _“Accountability”_, não consigo traduzir isso ao pé-da-letra em português, mas seria algo além do que “responsável”. Uma equipe Ágil é uma equipe conscientemente “accountable” pelo que faz. Quando eles se decidem, junto com o cliente, o product owner, sobre o Sprint Backlog, por exemplo, eles não estão recebendo “ordens” do tipo _“este sprint terá estas 10 user stories porque o chefe mandou.”_ Não, a equipe que se compromete com 10 stories está de fato se “comprometendo”, ou seja, ela tem consciência da sua velocidade, das suas capacidade e das suas fraquezas e toma uma decisão racional baseada nisso. Uma equipe que depois diz _“não deu para entregar porque pediram demais,”_ está se esquivando da sua responsabilidade. Ela deveria ter dito, no começo, _“não, só conseguiremos fazer 8 dessas user stories, 10 é demais.”_ Combinado não sai caro. É tudo uma questão de acertar expectativas e negociar, colaborar em buscar a melhor solução, não “qualquer” solução.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/pair_programming_original.jpg)

O mesmo vale no mundo reduzido entre 2 programadores pareando. Ambos precisam estar comprometidos com o que estão produzindo e com o colega. Se um deles é menos experiente, ele não deve ser o peso morto. Por outro lado, claro, se o mais experiente vê que o outro está tentando, ele deve ajudá-lo. Há um limite, claro, entre “ajudar” e “carregar nas costas”. Aqui vale a honestidade, e por isso existe uma fase no fim do Sprint chamado “Retrospectiva”, é exatamente o momento para se discutir isso e deixar tudo aberto, às claras. _“Eu não gosto do fato de estar produzindo sozinho, enquanto meu par não está ajudando.”_

Programação em Par, por si só, é apenas uma técnica. Mas lembrem-se que antes disso existem os valores do [Manifesto Ágil](http://agilemanifesto.org/). Todos sempre se esquecem: _“Indivíduos e Interações mais do que Processos e Ferramentas.”_ Se você está ainda se perguntando “quais das técnicas Ágeis eu devo escolher usar”, você ainda não entendeu. Antes de mais nada: você está comprometido com seu projeto? Sua equipe está comprometida com o projeto e com seus pares? Quais são os problemas que você quer resolver? Agilidade, por si só, não é uma receita mágica. Ela tem propósitos, se você não está mirando nesses propósitos, mas apenas escolhendo aleatoriamente 2 ou 3 práticas, isso não o torna Ágil, isso apenas o torna aleatório.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/493px-Joel_spolsky_on_20_sept_2007_original.jpg)

Daí vem o artigo do Joel Spolsky, sobre [O Programador Fita Adesiva](http://www.joelonsoftware.com/items/2009/09/23.html). Nesse artigo ele celebra um programador chamado Jamie Zawinski, de fato um grande programador, que trabalhou na Netscape produzindo software que ajudou a mudar o mundo, literalmente. Zawinski, segundo Spolsky, é do tipo _“vamos lançar software o mais rápido possível, não importa como.”_ e também do tipo _“testes unitários são bonitos, mas quando o prazo aperta, o que importa é fazer rápido, e testes atrapalham.”_ Lido da maneira errada, ela se torna uma desculpa para maus programadores dizerem: _“Viva! Estou confirmado! Joel Spolsky disse que é bonito ser um programador cowboy!”_ Pior ainda: _“Joel Spolsky disse que eu não preciso me preocupar com testes.”_

Antes de pular para alguma conclusão precipitada – maldita geração “fast-food” – leia a resposta a esse post escrita pelo bom e velho [Uncle Bob Martin](http://blog.objectmentor.com/articles/2009/09/24/the-duct-tape-programmer) onde ele refuta esses argumentos. Na realidade Spolsky e Bob já andaram se “pegando” algumas vezes no passado quando num podcast o [Spolsky menosprezou TDD e os princípios SOLID](http://www.infoq.com/news/2009/02/spolsky-vs-uncle-bob).

Robert Martin, que se você não conhece, foi quem originou a reunião de uns 10 anos atrás, junto com os principais pensadores em desenvolvimento de software como Kent Beck, Martin Fowler, Dave Thomas, Jeff Sutherland, dentre tantos outros, que deu origem ao Manifesto Ágil. Ele que é programador ativo desde antes ainda de qualquer um de nós ter nascido e que ainda programa até hoje. E não estou dizendo um sênior que ainda só programa em Cobol, muito pelo contrário, que já passou pelas principais plataformas tecnológicas, entende orientação a objetos como ninguém, programa em Java, e é um defensor de [Código Limpo](http://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882). Aliás, se você é usuário do Github, pode encontrar alguns [projetos do Bob](http://github.com/unclebob) por lá também.

Algum tempo atrás, eu provavelmente estaria [xingando e amaldiçoando](/2006/9/27/flame-war-joel-spolsky-vs-rails) o Spolsky, porém eu acho que entendo a posição dele. Dando o contexto, o Spolsky é de fato um grande empresário, tem uma empresa bem sucedida, com produtos de nicho bem sucedidos, não deixa de ser uma 37signals da geração anterior. Ex-funcionário da Microsoft, ele foi um dos responsáveis pela existência do Visual Basic for Applications, que até hoje é o coração do Excel e a menina-dos-olhos de qualquer contador, analista, etc que basicamente não vivem sem as macros do Excel. Junto com Jeff Atwood ele mantém o famoso site [StackOverflow](http://stackoverflow.com/). Além disso tem o excelente livro [Joel on Software](http://www.amazon.com/Joel-Software-Occasionally-Developers-Designers/dp/1590593898).

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/photo_martin_r_original.jpg)

Neste ponto eu estou assumindo que não preciso lhes explicar o que é [Agilidade](http://en.wikipedia.org/wiki/Agile_software_development), nem quais são algumas das principais boas práticas de [Extreme Programming](http://www.extremeprogramming.org/), nem o que são os [princípios SOLID](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod) do Bob Martin. Também estou assumindo que você já leu pelo menos alguns dos [artigos](http://www.joelonsoftware.com/) do Spolsky para ter uma idéia do que ele costuma falar.

Normalmente um agilista parece que está numa posição de “convencer” os outros de porque ser ágil é melhor. Mais do que isso: de que ser “ágil” e ser “rápido” não são sinônimos. Ser rápido é um efeito colateral de ser ágil. Essas interpretações são sutis.

Por isso mesmo o que eu amaldiçôo é a geração fast-food: uma geração que se acostumou a pensar que as coisas são simples e superficiais. Que basta comprar um livro de “emagreça em 7 dias” para realmente emagrecer. Surpresa: se esse tipo de coisa realmente funcionasse, não haveria obesos no mundo. Duh.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/BurningTheWitch_original.jpg)

Essa mesma geração lê o que o Spolsky fala e, superficialmente, chega às conclusões que falei acima: _“o Spolsky concorda que eu devo ser cowboy.”_ E eu acho que muitos de nós, agilistas, somos vítimas disso também. Na ânsia de responder à essa superficialidade, acabamos até ultrapassando a linha. O Bob Martin, por exemplo, poderia simplesmente ter ignorado esse post em vez de ter respondido.

Pessoas passivas, conformistas, esperam ser validadas. Elas não entendem porque fazem o que fazem, apenas fazem. Claro, fazem o que lhes parece mais simples, mais fácil, mais seguro, e não o que tem chances de ser melhor, que pode trazer mais benefícios, ou que seja novo. Elas querem que as pessoas gostem delas. Não importa se estão fazendo as coisas certas ou não. Não importa se há maneira melhor. Por isso essa ânsia em validação. Foi sobre isso que traduzi no artigo [Culto da Moral Cinzenta](/2009/09/08/off-topic-o-culto-da-moral-cinzenta).

Quando alguém do “calibre” – pelo menos do “calibre” perceptível – de um Spolsky lança um post como esse, milhares de programadores nitidamente ruins ao redor do mundo se sentem validadas, justificadas. É um cenário triste.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/BRILLIANT_original.jpg)

E o Spolsky não está errado. O que ele coloca em cada um de seus artigos são pedaços de sua própria experiência. Cada pedaço, individualmente, não significa absolutamente nada. E não deve ser levado ao pé-da-letra. Aliás, nem mesmo o que o Bob Martin escreve num artigo. Nem mesmo o que eu escrevo num artigo. O resultado da soma das partes é ordens de grandeza maior do que a simples soma dos valores individuais de cada parte. É assim que funciona o caos.

Ambos, Spolsky e Bob, não são antagônicos. O que um diz não invalida o que o outro diz. Esse é o truque. Ambos são “pragmáticos”, pelo menos segundo a definição de Pragmatismo de William James, onde algo é verdade para uma pessoa se ela tem utilidade para ela, independente se essa verdade continua sendo verdade para outra pessoa. (claro, ainda existe a interpretação de pragmatismo de Peirce e Dewey, mas isso é outra história). Ambos tentam explicar o que fazem que funcionam para eles. Dentro de um contexto, dentro do entendimento das premissas, dentro do entendimento dos valores, isso pode talvez funcionar para você também.

O que quero dizer é que o que o Spolsky diz faz sentido para ele. O que Bob Martin diz faz sentido para ele. Se o que eles dizem fazem sentido para mim, ou para você, isso **não** é problema deles, não é culpa deles, não deveria ser sequer do interesse deles. Da mesma forma, não usem o nome deles para justificar o que você faz ou diz sem entender porque está dizendo isso. _“Eu faço TDD porque o Kent Beck disse que é bom”_ é tão ruim de se dizer quanto _“Eu faço código-grude porque o Zawinski disse que é melhor.”_

Você deve dizer: _“Eu faço TDD porque eu **sei** quais são os benefícios que isso trás para mim.”_ Ou, _“Eu faço código-grude de vez em quando porque tenho **consciência** das consequências que isso vai me trazer e aceito pagar o preço por isso.”_ Ou, _“Eu não faço programação em par o tempo todo porque eu já **analisei** e concluí que no meu caso isso não funciona muito bem.”_

Aliás, tudo que eu digo aqui – no meu blog – são elocubrações, reflexões pessoais, que porventura encontram seu caminho na forma escrita. Alguns acham que eu “me acho o dono da verdade”. Pois bem, isso é um problema de quem acha isso, não meu.

Verdade seja dita: assim como o Bob diz no artigo dele, eu também não faço testes o tempo todo, muito menos testes primeiro como dita o TDD. Conheci as práticas de Extreme Programming apenas muitos anos depois que comecei como programador. Fui um programador extremamente cowboy a maior parte da minha carreira. E, mesmo entendendo porque todas as práticas ágeis são boas e porque eu deveria usá-las, eu ainda raciocino onde e quando devo usar o que. Quer dizer, eu entendo os princípios, as premissas e os resultados esperados. Caso contrário isso seria [dogmatização](http://en.wikipedia.org/wiki/Dogma) e, por definição, tudo que é dogmatizado é ruim. **Dogmas são a origem de todo o mal**. Tudo deve ser questionado, experimentado, medido, analisado e só então alguma conclusão pode surgir e, mesmo assim, pode ser refutado no futuro por novas evidências. O oposto de Dogma ou mesmo Cargo Cult é o [Método Científico](/2008/12/16/off-topic-m-todo-cient-fico-vs-cargo-cult) como eu já expliquei anteriormente.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/world-trade-center_original.jpg)

Só porque foi o Martin Fowler quem falou, não torna isso uma verdade incontestável. Só porque o [Ward Cunningham](http://en.wikipedia.org/wiki/Ward_Cunningham) falou não é verdade absoluta. Todos eles, todos nós, somos seres humanos e, como tal, somos muito falíveis. Nós falhamos, e falhamos muito mais do que gostaríamos.

Num mundo onde as pessoas falham, o que funciona melhor é o conhecimento coletivo, onde a possibilidade do erro de um é compensada pela inteligência complementar do outro. Por isso mesmo comunidades – apenas as que primam pelo conhecimento e evolução, claro – tendem a ser ordens de grandeza menos falíveis do que um único indivíduo.

Se um indivíduo tem o conhecimento “A”, se outro indivíduo tem o conhecimento “B”, nenhum dos dois tem o conhecimento “total”, mas o conjunto dos dois, a “comunidade”, tem ambos os conhecimentos. Sozinhos eles sabem apenas parte da informação. Porém a “entidade” chamada “comunidade” é o mais próximo que conseguiremos chegar de [omnisciência](http://rubyurl.akitaonrails.com/SiAN).

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/charles_darwin_l_original.jpg)

Por acaso, compartilhar conhecimento com os outros nos trás benefícios, e é por isso que o fazemos, não porque somos puramente altruístas. Dar sem ter nada para receber não faz sentido, muitos dão simplesmente porque isso lhes trás “paz de espírito” ou “satisfação pessoal”. Muito bem, isso é um tipo de retorno, também funciona. Pessoas como Kent Beck, Martin Fowler, Ken Schwaber, não estão “dando” nada. Elas estão compartilhando, ao ajudar a fomentar os valores ágeis, eles recebem de volta, seja na forma de mais conhecimento, mais reconhecimento, mais oportunidades, etc. Isso nos leva à boa e velha evolução darwinista, a única coisa que efetivamente funciona para melhoria contínua.

O objetivo não é “vender” Ágil. Quando eu evangelizo a filosofia Ágil, não tenho nenhuma intenção de convencer ninguém a usar. Não ganho dividendos se mais pessoas usarem. Alguns até me cobram: _“se eu usar Ágil, você me garante que vou ter resultados melhores?”_ E eu respondo, _“claro que não, eu não garanto nada.”_ Eu compartilho o que funciona para mim, se isso vai funcionar para os outros realmente não é problema meu. O que eu espero, sim, é que quem esteja usando e descubra coisas novas, que compartilhe para que eu possa melhorar mais também. E, claro, se alguém me der um código mal feito, cheio de fita adesiva, sem nenhum teste, e espera que eu conviva com isso em silêncio, está redondamente enganado, porque isso não funciona para mim e eu não vou ficar quieto. Concordando com o Bob Martin, [Bagunça não é Dívida Técnica, é apenas Bagunça](http://blog.objectmentor.com/articles/2009/09/22/a-mess-is-not-a-technical-debt)

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/10commandments_original.jpg)

Algumas dicas: qualquer coisa que é _“escrita em pedra”_, ou seja, algo que um dia foi o resumo do conhecimento coletivo de um grupo, mas que foi imortalizado na forma de um dogma, é ruim. Porque isso, sem dúvida, foi útil para as pessoas da época em que foi escrito, mas possivelmente não vale mais hoje. Por exemplo, se ainda seguimos os dogmas de desenvolvimento de software de 50 anos atrás, possivelmente estamos deixando de fazer as coisas da forma que a tecnologia e o conhecimento atual permitem. Por outro lado, um corpo de conhecimento que se permite evoluir, refinar, jogar fora o que não funciona mais, adicionar o que se aprende de novo, tem muito mais chances de estar certo. A comunidade Ágil funciona mais ou menos assim. A comunidade Open Source funciona mais ou menos assim. Nenhuma delas é perfeita, mas é a busca pela perfeição que torna o caminho mais interessante.

Seja cético.

