---
title: "[Off-Topic] Adendo à controvérsia HAML, SASS, Coffeescript: Tamanho do Documento"
date: '2011-04-19T19:25:00-03:00'
slug: off-topic-adendo-a-controversia-haml-sass-coffeescript-tamanho-do-documento
description: "Akita argumenta que escolher HAML, SASS ou CoffeeScript exige mais que gosto pessoal: manutenção, contrato, fornecedores e contexto do cliente também definem se a troca vale a pena."
tags:
- engenharia-de-software
- negocios
- off-topic
draft: false
---

Nos últimos artigos eu descrevi algumas controvérsias que rolaram pela comunidade recentemente, primeiro a decisão do [Twitter de trocar Ruby por Java](http://akitaonrails.com/2011/04/16/twitter-muda-de-ruby-para-java-ruby-e-3x-mais-lento-que-java), depois [a decisão do Rails Core Team de adotar SASS e Coffeescript](http://akitaonrails.com/2011/04/16/a-controversia-coffeescript), finalmente [a discussão entre Rspec e Test::Unit](http://akitaonrails.com/2011/04/17/a-controversia-test-unit-vs-rspec-cucumber).

Em todos esses casos existem ainda outras variáveis a considerar. Primeiro, as discussões são de desenvolvedor para desenvolvedor. Na maioria delas vamos cair em estética, que é basicamente questão de gosto.

Quem gosta de Less vai dizer que é melhor que Sass, quem gosta de Sass vai dizer o contrário. Quem prefere ERB acha HAML ruim, quem se acostumou com HAML acha ERB feio, e assim por diante. E agora o ponto crucial: nenhum dos dois está certo nem errado.

Sei que essa resposta não ajuda, mas quem disse que a vida é fácil? Quero discutir dois argumentos por trás dessas discussões todas, o primeiro mais conceitual e filosófico (vocês me conhecem) e o segundo mais comercial e de negócio.


## A Explicação Filosófica

Eu já discuti isso num artigo de 2006 intitulado [Evolução pela Concorrência](http://akitaonrails.com/2006/09/27/evolução-pela-concorrência), e aqui é essencialmente a mesma coisa. Entre Java e C#, por exemplo, na menor das hipóteses existem pelo menos duas pessoas convictas de que o seu é melhor: os criadores. E quem pode dizer que eles estão errados?

Nenhum dos dois precisa discutir abertamente. Mas o fato de cada um seguir na sua criação original já indica que acredita ter mais vantagens do que a do outro. Entre um Gosling e um Hejlsberg, quem está certo?

Daí começam pelo menos três tipos de comparação: performance (sempre!), produtividade e suporte, ou seja, quantos desenvolvedores dominam mais um lado ou o outro. Cansei de ver [comparações como esta](https://web.archive.org/web/20110123013859/http://java.dzone.com/news/productivity-race-ruby-rails-v) tentando mostrar quem desenvolve mais rápido, um usando Rails e outro usando Java. E tem gente que usa isso como “prova” de que um argumento está certo ou errado.

Isso demonstra, pra variar, que as pessoas não sabem a diferença entre **“prova”** e **“evidência”**, e que não entendem o método científico, como expliquei num artigo de 2008 intitulado [Método Científico vs Cargo Cult](http://akitaonrails.com/2008/12/16/off-topic-m-todo-cient-fico-vs-cargo-cult). Via de regra, duvide de qualquer um que diz ter “provas” ou que “provou” alguma coisa. Normalmente ele apenas encontrou uma “evidência favorável”, que de jeito nenhum significa “prova”.

Agora, para um estar certo, o outro precisa necessariamente estar errado? Isso me leva a outro artigo, de 2007, intitulado [Para eu ganhar, o outro precisa perder…](http://akitaonrails.com/2007/10/23/para-eu-ganhar-o-outro-precisa-perder). É uma grande bobagem. Defender uma coisa porque você gosta dela é ótimo, só que isso não significa que o outro lado não tenha valor ou que deveria desaparecer.

Ruby não é melhor do que C, Lisp, Python ou Perl. Pelo contrário, Ruby só é bom porque Lisp, C, Perl e Python vieram antes dele mostrando possibilidades que o Matz, sozinho, provavelmente nem imaginaria. E o Matz entende isso. Justamente por isso você não o vê evangelizando Ruby às custas de denegrir os outros.

**Cuidado:** não estou fazendo apologia a ficar em cima do muro, ser conivente ou conformista. Quando você já sabe que um lado está errado, não há porque ficar no meio. Releia meu artigo de 2009 intitulado [O Culto da Moral Cinzenta](http://akitaonrails.com/2009/09/08/off-topic-o-culto-da-moral-cinzenta).

Uma coisa é discutir entre comida e veneno, onde o meio do caminho só faz o veneno ganhar. O que estou descrevendo aqui são discussões do tipo: qual comida é melhor, maçã ou laranja?

 ![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/19/penis-size_original.jpg?1303251476)

Eu não sou psicólogo, então não vou dizer que a conclusão a seguir é comprovada. Mas o que consigo [inferir](http://en.wikipedia.org/wiki/Inference) de inúmeras discussões desse tipo é que todas elas se parecem com a milenar questão do **tamanho do seu documento**. Todo macho-alfa parece ter uma necessidade fisiológica de “medir” para se auto-afirmar: _“ah, o meu é maior”_, e então suspira em silêncio, _“ufa!”_.

E vou dizer mais: eu sou japonês. Vocês imaginam quantas piadas infames eu já não tive que ouvir desde a infância, do sujeito que se acha engraçado: _“ah, sabe aquela piada do eletricista japonês?”_

Quem vive querendo medir e comparar para descobrir qual é o maior demonstra aquilo que a maioria das mulheres já sabe: _“esse homem é muito inseguro, praticamente uma criança.”_ São pessoas com pouca fundação e pouca segurança em si mesmas, que precisam se agarrar em resquícios. Resumindo: discussão de _“o meu é maior que o seu, e por isso o seu é necessariamente inferior, pior e desnecessário”_ é discussão de quem tem insegurança.

É por isso que tanta gente tem dificuldade de aprender coisas novas ou diferentes: preconceito e insegurança. Mesmo que você goste infinitamente de maçã, comer uma laranja de vez em quando não faz mal nenhum. Ninguém está falando em trocar a comida por veneno, ou em misturar veneno na comida.

E, como sempre, eu também entro nesse tipo de discussão. Às vezes é simplesmente divertido, e também é uma reação natural. Não pensem que por causa desse “sermão” eu nunca caio nessa.

## A Explicação Comercial

Eu sou consultor, sempre fui. Mesmo quando era funcionário CLT, com cargo e tudo, nunca deixei de pensar como consultor. A tarefa de um consultor é ser um **provedor de solução**. E uma solução é, por definição, a resposta a um problema, ou o processo para chegar a essa resolução.

Claro, para o problema _“quero um site”_ existem centenas de maneiras diferentes de resolver. Um consultor precisa avaliar o passado, o presente e até o possível futuro de uma solução, as circunstâncias internas e externas. Tem muito mais em jogo do que simplesmente escolher tecnologias e escrever código.

E aqui entra meu adendo, especificamente ao caso de HAML, SASS, CoffeeScript ou qualquer outro pré-processador que serve de intermediário para gerar as estruturas originais, no caso HTML, CSS e Javascript.

A argumentação é simples. Se um aplicativo vai ser mantido por você mesmo, o desenvolvedor que escolheu tais ferramentas, ou se é uma aplicação que dificilmente terá qualquer modificação (olha você aí, especulando sobre o futuro!), ou ainda uma aplicação que vai morrer rápido (por exemplo, o hotsite de uma campanha de marketing), então você praticamente tem passe livre para usar as ferramentas e métodos que quiser.

A exceção é quando existem requerimentos ou motivos fortes para limitar isso, digamos, a política da empresa do cliente.

Agora, se já sabemos que o produto será desenvolvido por nós e depois entregue ao cliente, porque ele quer dar manutenção por conta própria, ou prefere que outra empresa cuide disso, aí temos um problema.

No back-end, escolher entre Ruby, Python, Java ou C# tem prós e contras, e sempre há bons argumentos (que não exigem denegrir as outras alternativas) para convencer um cliente em potencial, sempre levando em conta os requerimentos do projeto e do cliente. Já o front-end costuma ser fluido e volátil. Ele precisa acompanhar a demanda dos usuários finais e do mercado, muitas vezes tem manutenção separada do back-end, e não deveria ser tão complicado de mexer.

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/19/509_original.jpg?1303251744)

No tempo de ASP e PHP, com HTML misturado ao código, era ruim, mas a maioria dos desenvolvedores de interface já sabe o que dá ou não dá para fazer ali. Agora, se esse desenvolvedor contrata um terceiro e recebe um site com o front-end todo montado numa estrutura que ele nunca viu antes (e deixe de fora a discussão sobre se ele deveria conhecer), é claro que ele vai reclamar, surtar, xingar.

Isso piora se, como nós, ele também fechou um projeto de escopo e tempo fechados com o cliente e recebe tudo em HAML e SASS. Dá para argumentar que todo mundo deveria ser capaz de aprender. Mas não diga isso a quem acabou de fechar um projeto de custo fechado e leva uma surpresa dessas.

Pior, o cliente pode voltar exigindo que você dê o suporte, já que você limitou as opções de fornecedores que ele teria para contratar. E fornecedores podem usar isso contra você de propósito, dependendo do caso. Por isso mesmo eu sempre defino em contrato o que vou usar e o que vou entregar.

Não é o fim do mundo. Se fosse, estaríamos todos escrevendo CGI em C até hoje. É arriscando e experimentando que passamos a usar Perl, depois PHP e ASP, depois Java, depois C#, até chegar ao Ruby por causa do Rails. Só que isso não acontece do dia para a noite, nem acontece na base da intransigência.

**Cuidado:** de novo, não estou fazendo apologia à baixa qualidade, nem defendendo quem não quer aprender coisas novas. A questão aqui não é do tipo “devo fazer testes ou não?” ou “devo escrever código macarrônico ou não?”. Numa conversa de desenvolvedor para desenvolvedor, eu sempre vou defender coisas novas, evoluções e tudo mais.

Mas quando a conversa envolve clientes e projetos que não são meus, os critérios ficam mais amplos. Entram a oportunidade de novos negócios e o próprio timing para oferecer ou não certas coisas.

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/19/angry_man1_original.jpg?1303251651)

Por exemplo, com o movimento de colocar o CoffeeScript dentro do Rails, ele automaticamente ganha exposição a um mercado maior, que talvez nem tivesse antes. Com isso, mais e mais gente, até de fora do Rails, vai começar a adotá-lo. Em pouco tempo um nicho considerável de desenvolvedores já estará acostumado, e muitos clientes vão pedir CoffeeScript por vontade própria.

É um dilema que eu, como evangelizador de Ruby, preciso pesar todos os dias. Quando vale dar uma forçadinha para o cliente usar Rails, e quando é melhor reconhecer que o custo-benefício não compensa, ou que o requisito é incompatível com Rails, e recomendar Wordpress ou outra coisa?

Eu já fiz isso várias vezes. No lugar de recomendar um projeto em Rails, já recomendei PHP, Java e .NET, escrevi as propostas e dei suporte de pré-vendas. E não faço cara feia.

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/19/sm-client-satisfaction_original.jpg?1303251519)

Uma história que eu sempre conto: certa vez fui mandado a um cliente para dar manutenção pontual num sisteminha feito em ASP. Isso foi por volta de 2003, e o site, em bom francês, era uma porcaria. E não era culpa do ASP. O código em si é que era horrível, todo bugado, altamente acoplado e embolado, sem organização nenhuma.

O diretório estava lotado de arquivos asp que sequer eram usados, coisas do tipo “config.asp”, “config2.asp”, “config_novo.asp”, “config_old.asp” (e o certo era justamente o “config_old.asp”, pasmem!). Eu poderia xingar, querer mudar tudo, reescrever, ou simplesmente decidir não fazer.

Em vez disso, eu tinha uns 4 dias, algo assim. Olhei o código, entendi como funcionava o fluxo que eu precisava mexer, pesei o tempo limitado contra o que dava para fazer no período, resolvi o essencial que atendia o pedido do cliente e entreguei. Ele ficou muito satisfeito, e no fim até corrigi um pouco mais do que ele esperava. Na verdade a expectativa dele era baixa, porque outros já tinham tentado e não conseguiram consertar.

Meses depois fui chamado de novo, dessa vez para um projeto de SAP com Java, onde gerenciei uma equipe maior num trabalho que durou quase 2 anos. Lição aprendida: não é fechando a porta, sendo intransigente e imediatista, que se conseguem as coisas. E a lição principal: não importa se por baixo você escreveu um algoritmo digno de Donald Knuth, se o cliente não ficou satisfeito, o seu sistema é uma droga, por definição.

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/19/hands_original.jpg?1303251485)

E, como sempre digo, não estou dizendo para deixar de discutir. Pelo contrário, é bom que existam discussões, questionamentos e críticas, porque sem isso não há evolução e nenhum lado ganha. Só estou avisando o seguinte. A menos que você tenha certeza de que do outro lado está o veneno, e saiba demonstrar isso de forma objetiva, é melhor se segurar um pouco. Caso contrário, a discussão só tem um lugar para terminar: cada um tentando medir o documento do outro.

E lembrem de mais uma coisa: eu linkei ali em cima artigos de 2006, 2007, 2008 e 2009, onde já discuti muito do que falei aqui. Se desde 2006 a minha posição fosse _“use Ruby porque o resto é uma porcaria”_, vocês acham que eu teria conseguido chegar até aqui?

