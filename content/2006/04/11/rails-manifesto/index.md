---
title: Rails Manifesto
date: '2006-04-11T12:09:00-03:00'
slug: rails-manifesto
tags:
- narrativa
- rails
- pitch
draft: false
---

Um desenvolvedor, certa vez, definiu Ruby como duas partes de Perl, uma parte de Python e outra parte de Smalltalk.

Quando [Yukihiro Matsumoto](http://www.artima.com/intv/ruby.html) criou o Ruby como substituto ao Perl e ao Python, com inspiração no Smalltalk, em 1993, mal poderia imaginar a dimensão que sua linguagem poderia alcançar fora do Japão.

Mas em meados de 2004, quando [David Heinemeier Hansson](http://www.loudthinking.com/about.html) liberou seu framework “Rails” a partir dos produtos que desenvolveu na sua empresa 37signals, acredito que ele já sabia onde queria chegar.


Ruby on Rails é um produto do atual movimento [Web 2.0](http://www.blogger.com/post-create.g?blogID=25846821). Garanto que a maioria ainda não entendeu, mas estamos no ponto de curva de uma nova geração.

É um fato: a Sun errou com J2EE. Uma implementação falha de um conjunto de requerimentos errôneos. Quem acompanhou esta história vai se lembrar do pesadelo que são EJB 1 e 2, a demora e o suporte ruim a Web Services, mais demora na promessa do EJB 3 e assim por diante.

Estamos perdendo muito tempo para desenvolver coisas simples. Web Applications não deveriam ser complexos. A Web foi criada para ser simples. Mas J2EE foi criado para resolver 100% dos problemas “Enterprise”. E todos sabemos que ao se tentar consertar tudo acaba-se não consertando nada direito.

Com Rails, finalmente nos tornamos compatíveis com o espírito dinâmico da Web 2.0. Web Services, Ajax nada disso é difícil. E o tradicional: camadas de persistência, controle de versão, MVC, templates, caching, segurança tornam-se o que sempre deveriam ser: triviais.

Quando alguém quer mudar os requerimentos, torcemos o nariz: é preciso muito esforço para implementar modificações. Afinal, inventamos toda uma família de parafernálias, como UML, justamente para engessar e dificultar toda e qualquer mudança. Convenhamos: UML foi criado para consultorias cobrarem mais caro por seus trabalhos.

Com Rails, elas são bem vindas. Rails é a primeira plataforma realmente compatível com o pensamento Agile defendido no [Agile Manifesto](http://agilemanifesto.org/principles.html). J2EE tornou o termo famoso, mas essa promessa nunca chegou para ela.

Para começar meus artigos, acho que é importante deixar claro dois conceitos que o Rails tornou famoso:

- _DRY – Don’t Repeat Yourself_. O Rails possui suporte nativo e simples a Helpers, Templates, Engines, Plugins, tudo muito bem integrado de tal maneira que você possa se tornar produtivo sem ser sujo. Copy e paste é ruim, temos que parar com isso e Rails nos dá as ferramentas para isso.

- _Convention over Configuration_. Em vez de termos que editar dezenas de arquivos XML, properties, a arquitetura do Rails prefere usar convenções: coloque seu controller com o nome correto, no diretório correto e ele será localizado. Coloque seu model no lugar correto ele será encontrado.

Dois conceitos simples, implementados por todo o framework, e que fazem toda a diferença.

E não se deixem levar pelos preconceitos. Já ouvi gente dizendo: _“Ruby é uma linguagem não-compilada, portanto deve ser lenta”_, _“tudo que o Ruby faz posso fazer em Java”_, _“Ruby não escala bem”_, _“não preciso aprender outra linguagem”_, _“Java nunca vai sumir”_.

Substitua _“Ruby”_ por _“Java”_ e _“Java”_ por _“C”_ – ou outra linguagem. Parece que estamos ouvindo exatamente as mesmas coisas que 10 anos atrás, quando o Java era uma novidade.

Parece que existe uma tendência em primeiro criticarmos para só depois olharmos para as partes boas e, quando fazemos isso, notamos que chegamos tarde demais à festa.

Que tal fazer diferente desta vez, para variar?

