---
title: David Hansson e Opinionated Software
date: '2006-12-05T07:38:37-02:00'
slug: david-hansson-e-opinionated-software
tags:
- rails
- pitch
draft: false
---

Enviei ontem ao Ronie minha coluna de dezembro ( **link atualizado – 06/12** ) para a RubyOnbr entitulada [**Rails: Sucesso pela Arrogância?**](http://rubyonbr.org/articles/2006/12/06/rails-sucesso-pela-arrogncia/) que dá as bases para este artigo que David [postou no Loud Thinking](http://www.loudthinking.com/arc/000516.html). Quem ainda não ouviu falar ou não sabe o que é “Opinionated Software” deve ler minha coluna primeiro para entender isso. Vamos ao artigo:


#### Escolha uma única camada de esperteza

Christopher Petrilli repete um frequente mal-entendido sobre Active Record, o ORM de Rails, em [Menor Denominador Comum](http://blog.amber.org/2005/09/27/least-common-denominator/). O raciocínio diz que o MySQL está nos segurando de tomar vantagem de funcionalidades mais avançadas dos bancos de dados disponíveis no PostgreSQL, Oracle e outros. E que se pelo menos MySQL fosse mais esperto, tivesse mais funcionalidades, estaríamos abrançando-as de braços abertos. _Errado_.

Active Record é [opinionated software](http://www.oreillynet.com/pub/a/network/2005/08/30/ruby-rails-david-heinemeier-hansson.html?page=1), assim como o resto de Rails. Essa é uma questão de opinião, não restrições. E a opinião é a seguinte: eu não _quero_ meu banco de dados mais esperto! Mantenha [esses crayons](http://en.wikipedia.org/wiki/HOMR) firmes no lugar, por favor.

Ao contrário de Cristopher, eu considero que stored procedures e constraints são vilãs e destruidores imprudentes da coerência. Não, Sr. Banco de Dados, você não pode ter minha lógica de negócios. Suas ambições procedurais não darão frutos e só terá minha lógica sobre meu morto e frio cadáver orientado a objetos.

Antes que o lado induzido por DBA do seu cérebro exploda com essa afirmação, por favor leia o artigo de Martin Fowler sobre [a diferença entre bancos de dados de aplicação e de integração](http://martinfowler.com/bliki/DatabaseStyles.html). E perceba que minhas opiniões estão confinadas em lidar com bancos de dados de aplicação (e que fazer integração pelo banco de dados pertence a um tempo quando Barrados no Baile ainda era um sucesso na TV). Com sorte isso deve ter acalmado vocês novamente.

Em outras palavras, quero uma camada única de esperteza: meu domain model. Orientação a objetos tem tudo a ver com encapsulamento de esperteza. Deixá-lo metade espalhado pelo banco de dados é uma terrível violação dessas nobres intenções. E eu não quero fazer parte disso.

Dito tudo _isso_: vá com o que resolver seu problema. Active Record surpreedentemente perdoa suas transgressões. Isso enquanto não estiver apostando todas as suas fichas na esperança de que nós mudaremos as coisas quando MySQL “crescer” e adicionar todas essas Funcionalidades Enterprise para se tornar maior e melhor do que um “projeto de brinquedo”. Você morrerá pobre, estou lhe dizendo.

**Atualização** : Alex Bunardzic tem uma excelente sequência entitulada [Devem os Bancos de Dados Gerenciar o Significado?](http://lesscode.org/2005/09/29/should-database-manage-the-meaning/) – fique ligado.

**nota do Akita 1** : calma, Rails funciona com a grande maioria dos melhores bancos de dados do mercado. PostgreSQL, Oracle, DB2, SQL Server, etc. O ponto do David é que se você depende de muitos dos recursos como stored procedures, terá muito mais trabalho para que o Active Record trabalhe bem para você. Se seguir as Convenções, não terá trabalho algum. Nada é impossível, apenas mais trabalhoso. Leiam os comentários do artigo original para mais pontos de vista e dicas.

**nota do Akita 2** : preste bastante atenção ao uso do seu banco de dados. Eu expliquei isso no meu livro mas vou repetir: Bancos de dados de aplicação são usados para transações e pouco processamento maciço de dados. Se precisar de processamento maciço (transformações, cálculos, carga) de ordens de grandeza de gigabytes ou milhares de bilhões de linhas, por exemplo, então estamos falando de um conjunto de problemas completamente separados de um Domain Model de aplicação Web. Nesse caso não faz sentido trafegar essa quantidade-monstro de dados para um servidor de aplicação Rails, processar tudo e mandar de volta ao banco: é melhor realmente separar e isolar esse problema e resolvê-lo diretamente no banco, nesse caso, com stores procedures ou programas residentes no banco, onde ele poderá otimizar a melhor estratégia para esse processamento maciço.

**nota do Akita 3** : como um comentarista no artigo bem lembrou, todo banco de dados de aplicação, se crescer o suficiente e concentrar mais de uma aplicação sobre os mesmos dados, se tornará um banco de dados de integração. E nesse caso se faz necessário uma camada de negócios integrada aos N aplicativos. É onde EJBs no mundo Java começam a fazer sentido. Esse é um caso onde Rails ainda não se encaixa muito bem: compartilhar o Domain Model entre múltiplos aplicativos. Não é impossível, mas também não é trivial. Um exemplo de solução: uma aplicação Rails que serve de servidor de Web Service para outras aplicações Rails, por exemplo, ajudaria, principalmente com o novíssimo suporte REST/Active Resource do Rails 1.2.

