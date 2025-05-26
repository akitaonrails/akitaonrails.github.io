---
title: Conversando com Avi Bryant - Parte 1
date: '2007-12-15T10:18:00-02:00'
slug: conversando-com-avi-bryant-parte-1
tags:
- interview
draft: false
---

**Read the Interview in English [here](http://www.akitaonrails.com/2007/12/15/chatting-with-avi-bryant-part-1)**

Alguém uma vez desafiou todos os outros frameworks implicando que ninguém conseguiria chegar ao nível de Rails … exceto por Avi. Seaside é tão diferente do status quo que o próprio Avi o descreve como um framework herético. E ele está certo. Ele voltou na história e pegou o que é considerado “o” pai – e provavelmente “a” melhor implementação – das linguagens orientadas a objeto: Smalltalk.

Pegando dicas do venerável Apple WebObjects, ele implementou Seaside e seu produto de grande sucesso, [Dabble DB](http://www.dabbledb.com). Vejam aqui quem é o homem, quais suas opiniões e porque ele é tão relevante na comunidade Ruby e Rails mesmo sendo defensor de outra linguagem e outro framework. Parece estranho, mas quando Avi fala, você ouve.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/n517961878_373676_1188.jpg)

Ele foi muito gentil de me dar uma longa entrevista. Tão longa que eu dividi em 2 partes. Esta é a primeira. Vou liberar a segunda em alguns dias. Espero que todos gostem.


 **AkitaOnRails:** Legal. Eu estou meio nervoso. Até agora somente entrevistei o pessoal de Ruby on Rails, incluindo Matz e DHH, esta é a primeira vez que estou procurando por um ponto de vista de fora.

E eu sei que você tem muitas opiniões a respeito de Smalltalk e Seaside, mas ao mesmo tempo tem conexões fortes com a comunidade Ruby. Posso começar perguntando mais sobre Avi Bryant, a pessoa? Quero dizer, qual sua história no campo de programação?

**Avi Bryant:** Comecei a programar quando era bem jovem; foi uma coisa que eu fazia com meu irmão e meu pai de brincadeira, na maior parte escrevendo jogos em C nos primeiros Mac. Quando fui chegando próximo à faculdade, meu interesse se voltou mais ao cinema e filmes, então quando comecei a universidade foi essencialmente no curso de filmes.

Mas com o passar do tempo, ciências da computação me sugou, e eu terminei me graduando em computação e trabalhando e um laboratório de engenharia de software no campus. Foi quando comecei a programar sério, e particularmente onde me tornei especialmente interessado em ferramentas de software.

Foi na época quando as primeiras construções do Mac OS X – quando era essencialmente ainda apenas NeXTStep, sem Aqua ou Carbon ou qualquer coisa – começaram a se tornar disponíveis, e como eu sempre programei para Mac me coloquei a aprender Objective-C e Cocoa. Essa foi minha primeira exposição à OO “real”, e foi viciante.

Ao mesmo tempo, estava fazendo consultoria web por fora para ganhar um extra, então estava procurando por uma linguagem que me lembrasse de Objective-C mas fosse mais dinâmico e mais indicado para a web, e então eventualmente cruzei com Ruby, que se encaixava muito bem.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/n517961878_39359_1867.jpg)

Eu ainda estava enamorado com tudo sobre NeXT e Objective-C, então comecei a trabalhar em ferramentas web para Ruby. Eu peguei o framework WebOjects da NeXT como meu modelo, e terminei com IOWA, que é muito próximo de ser um port do WebObjects para Ruby. Eu o apresentei na primeira RubyConf, que foi, acho, em 2000.

RubyConf aconteceu próximo com a OOPSLA nesse ano, que eu também estava participando para falar da minha pesquisa no laboratório de engenharia de software. Agora, quando o OOPSLA começou, estava cheio de Smalltalkers, e mesmo que o mainstream de desenvolvimento de software OO – e portanto o foco principal da OOPSLA – moveu de Java para C#, os Smalltalkers continuaram comparecendo. Mas em vez de participar do resto da conferência, eles faziam um semi-oficial “Camp Smalltalk” com seus próprios projetores e cronograma e hackeavam e demonstravam coisas de Smalltalk o dia todo.

Claro que eu conhecia Smalltalk, como a fonte de um monte de idéias por trás de coisas que eu me interessava – Objective-C e Ruby, obviamente, mas também TDD, wikis, mesmo o Mac até certo ponto – mas eu nunca realmente o usei; os ambientes eram muito diferentes, a documentação muito esparsa, etc.

Sentado por um dia no Camp Smalltalk foi o empurrão que eu precisava para ultrapassar isso. E uma vez que senti o gostinho de Smalltalk, eu não consegui mais largar – eu comecei imediatamente um port do IOWA para Smalltalk, e convenci meus próximos clientes em projetos web que eu deveria usar Smalltalk em vez de Ruby. Esse port se tornou Seaside, e nos muitos anos seguintes construí um negócio de consultoria ao redor de treinamento de Seaside e desenvolvimento.

Desenvolvimento web com Smalltalk pode parecer um pequeno nicho onde construir um negócio, mas o fato é que **ninguém** mais estava fazendo isso na época (também, ninguém estava fazendo desenvolvimento web com Ruby na época – esta situação é um pouco diferente agora).

Algumas pessoas para mencionar nesta história – Julian Fitzell foi meu antigo parceiro de projetos web, e trabalhamos juntos na primeira versão do Seaside. Colin Putney foi um dos primeiros clientes, que veio até mim baseado no meu trabalho com Ruby e eu tive que trabalhar duro para convencê-lo a usar Smalltalk; ele agora é um Smalltalker e trabalha comigo no Dabble DB. Andrew Catton trabalhou comigo no laboratório e foi um colaborador freqüente em vários projetos pelos anos.

Alguns anos depois, um pouco cansado de consultoria, Andrew e eu começamos a trabalhar em um projeto por fora, e isso se tornou Dabble DB. No verão passado, tivemos sorte para conseguir funding para trabalhar nisso tempo integral, e é o que estamos fazendo desde então.

**AkitaOnRails:** Vejo que você gosta do fato que Smalltalk não é “mainstream” como Java. Posso ver as vantagens e concordo com você. É como dizer _“somos um pequeno grupo, mas de pessoas muito inteligentes.”_ Muito parecido com a campanha da Apple _“Think Different”_. Por outro lado as massas tendem a gostar de grande marketing e suporte. O que acha dessa diferença cultural? A parte mais importante é: aqui no Brasil o mercado é muito fechado para tecnologia não-largamente-comercialmente-suportadas. O que significa que a maioria não gosta de nada diferente de Java ou .NET. Como você convence seus clientes sobre Smalltalk – se isso de fato for um problema aí nos EUA?

**Avi Bryant:** Sim, isso é um equilíbrio complicado. Algumas das pessoas que conheci nos primeiros dias da popularidade de Ruby – após-Pickaxe, mas pré-Rails – reclamavam sobre quão popular Ruby ficou ultimamente, porque inevitavelmente a taxa de sinal claro vs. barulho vai pra baixo nos mailing lists e conferências. Smalltalk não tem esse problema – em particular, Smalltalk tem uma boa mistura de hackers muito experientes – pessoas como Dan Ingalls, que escreve implementações de linguagens por mais de 30 anos, e tem um profundo conhecimento para compartilhar – e jovens encrenqueiros como eu. Quando você se torna muito popular muito rápido, recebe um grande fluxo de jovens, inexperientes, pessoas enérgicas, e a voz da experiência tende a afundar. Não que novas idéias não tenham valor – elas são essenciais – mas acho que nesta área tendemos a ignorar a história demais.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/198438575_ff982238f7.jpg)

Sobre usar tecnologias não-padrão, acho que a melhor forma de olhar para isso é como uma vantagem competitiva. Paul Graham aponta que na média, startups falham, e o mesmo pode provavelmente ser dito sobre projetos de software em geral. Então se você não quiser falhar, você precisa fazer **alguma coisa** diferente da média, e usar tecnologias melhores é uma grande forma de fazer isso.

Mas você claramente precisa estar numa situação onde resultados importam mais do que política – é praticamente impossível vender Smalltalk para departamentos corporativos de TI. Por outro lado, um dono de um negócio pequeno não está nem aí para qual tecnologia você usa para lhe construir a aplicação – não é que ele tem um exército de desenvolvedores Java que irão dar manutenção nele.

Em geral, quanto mais próximo o alinhamento entre a pessoa que usa a aplicação, e a pessoa que assina os cheques, mais irão se importar em ter alguma coisa que de fato funcione, e menos sobre palavrinhas de marketing.

Essa foi minha estratégia quando fazia consultoria de Smalltalk, e essa é nossa estratégia com Dabble DB – vendemos para usuários, não CIOs.

**AkitaOnRails:** É exatamente como penso. O que me leva às startups. Posso entender se cansar de consultoria, mas o que o levou a escolher abrir sua própria empresa para vender seus próprios produtos? Ouvi dizer que Tim Bray também é um investidor para sua empresa? Muitas pessoas não gostariam de perder seus empregos confortáveis por algo tão arriscado como isso. Qual foi a razão para essa direção na sua carreira?

**Avi Bryant:** Quando fazíamos consultoria, ficou muito claro para Andrew e eu que a) a maioria das empresas, especialmente negócios pequenos, não podiam nos pagar, e b) mesmo os que podiam, apenas nos contratariam para os projetos realmente importantes. A única maneira de escalar nosso negócio, e ajudar o máximo de pessoas possível, seria efetivamente nos substituir com software: construir um produto que os deixariam fazer os projetos simples eles mesmos.

Não abandonamos tudo para construir isso, entretanto – mantivemos nossos clientes (de fato, pegamos alguns novos para conseguir um capital extra para contratar um web designer, etc), e trabalhamos no produto à noite, aos fins de semana, onde podíamos.

À medida que o projeto avançava, e se tornava mais e mais claro que seria alguma coisa que valia a pena, começamos a trabalhar com mais afinco, mas ainda mantendo alguma renda entrando com consultoria.

Eventualmente, quando o produto estava pronto para ser lançado, sabíamos que não poderíamos lidar com clientes Dabble DB ao mesmo tempo que nossos clientes de consultoria, então os abandonamos completamente. Foi quando pegamos algum investimento da Ventures West e Tim Bray.

Então foi uma transição razoavelmente gradual, o que foi mais fácil para nós.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/dabbledb.gif)

**AkitaOnRails:** E na época, vocês faziam apenas consultoria de Smalltalk/Seaside? Ou trabalhavam em diferentes linguagens/frameworks para clientes e Smalltalk depois do trabalho? E para os iniciantes como você brevemente descreveria [Dabble DB](http://www.dabbledb.com)? Ouvi dizer que estão para lançar um produto companheiro para ele, não é? Como o descreveria?

**Avi Bryant:** Durante esse período, a consultoria era toda ao redor de Seaside, sim – houve períodos negros no começo quando eu tinha que pegar trabalhos em Java :-)

Dabble DB é uma aplicação web para empresas pequenas e equipes que precisam de algum tipo de gerenciamento customizado de dados – talvez precisem de gerenciamento customizado de projetos, ou um banco de dados de contatos, ou uma aplicação customizada de RH, ou planejamento de eventos, ou suas coleções de DVD, seja qual for a razão os softwares de caixinha não tem o que eles precisam. Dabble permite a eles interativamente construir relatórios muito ricos dos seus dados, com agrupamento estruturado e filtro, cálculos simples e sub-totais, e os mostra como uma tabela, ou um gráfico, ou um mapa, ou um calendário. Daí você pode compartilhar esses relatórios com pessoas, ou convidá-los a entrar e modificar os próprios dados.

O produto companheiro que você se referem, acho que é Dabble Pages. Isso é realmente apenas uma nova funcionalidade sobre o Dabble DB, que todos os clientes atuais tem. O que descobrimos é que numa organização normalmente existe um pequeno número de pessoas que querem o poder total da interface de usuário do Dabble DB, e querem construir novos relatórios ou adicionar campos ou re-estruturar seus dados, etc. Mas também existem um grande número de pessoas que querem apenas uma simples página web onde possam entrar com novos dados ou ver relatórios. Então Pages permite um pequeno grupo construa alguma coisa para um grupo maior. É algo como uma versão misturada de construtor de forms como WuFoo, mas com Dabble DB como o backend administrativo.

Isso torna o Dabble DB **quase** como uma ferramenta de desenvolvimento web, no sentido que os usuários administrativos estão realmente construindo aplicações simples para as pessoas nas suas empresas – mas sem nenhuma programação, então claro que as aplicações são bem limitadas.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/Picture_2.png)

**AkitaOnRails:** Mudando de assunto um pouquinho, uma coisa que admiro a seu respeito é seu relacionamento com a comunidade Ruby/Rails. São paradigmas e tecnologias diferentes, mas você nunca mergulha em flame wars como ‘Smalltalk é melhor que Ruby’ do nada. Pelo contrário, para mim parece que você gosta de Ruby, e até apresentou na RailsConf sobre a possibilidade de rodar Ruby sobre uma VM moderna como da GemStone. Mas, você migrou de Ruby para Smalltalk. O que que ‘clicou’ para você sobre Smalltalk? Continuations? A história de codificar dentro do runtime? A integração mais estreita com o ambiente?

**Avi Bryant:** Então, primeiramente, realmente gosto de Ruby, tanto é que DabbleDB inclui mais ou menos 3000 linhas de código Ruby (acabei de confirmar), junto com todo o código Smalltalk (e um bocado de Python).

O que me chamou a atenção sobre Smalltalk foram algumas coisas: um foi simplesmente a maturidade, tanto da comunidade e da tecnologia. Implementações Smalltalk foram refinadas durante 25 anos, e eles realmente se beneficiaram disso.

Um dos maiores benefícios, na minha opinião, é que VMs Smalltalk são rápidas o suficiente que é razoável implementar todas as bibliotecas padrão – Array, Hash, Thread, etc – no próprio Smalltalk. Então não há barreiras onde você muda do código Ruby para a implementação C por baixo; é ‘tartaruga do começo ao fim’. Isso pode não parecer grande coisa mas uma vez que tem isso, é realmente difícil desistir.

Rubinius, claro, está se movendo nessa direção para Ruby, e muitos parabéns a Evan e todos trabalhando nesse projeto.

Para mim, o ambiente Smalltalk é também chave.

De alguma forma é a mesma coisa que falo com Dabble DB: você não tem que escolher um jeito de organizar seus dados, você pode ter uma visão agrupada por data e outra filtrada por cliente e outra onde um mapa é a única maneira de entender. Em Smalltalk, você não precisa escolher um layout de arquivo ou ordem dos métodos e classes no seu código; você está constantemente mudando visões sobre o que é basicamente um banco de dados de código.

Meu amigo Brian Marick odeia isso, porque você perde qualquer ‘narrativa’ que poderia ter existido colocando seu código em uma certa ordem em um arquivo, e é difícil se acostumar a isso, mas para mim, essa é a mais poderosa ferramenta para hackear grandes bases de código.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/n517961878_38879_9189.jpg)

* * *

Esta foi a Primeira Parte. Fiquem ligados para mais Avi falando sobre Smalltalk e Ruby na segunda parte da entrevista.

