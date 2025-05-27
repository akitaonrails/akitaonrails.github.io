---
title: Quais são algumas das piores práticas para aplicações Ruby on Rails?
date: '2013-03-24T12:45:00-03:00'
slug: quais-sao-algumas-das-piores-praticas-para-aplicacoes-ruby-on-rails--2
tags:
- learning
- rails
draft: false
---

Alguns dias atrás me pediram para responder no Quora a pergunta ["Ruby on Rails: Quais são algumas das piores práticas para aplicações Ruby on Rails?"](http://qr.ae/TkQ3N). Foi uma resposta que teve muitos votos positivos então resolvi que seria um bom post para meu blog. Segue minha versão extendida.

Existem diversas práticas ruins em desenvolvimento de aplicações em geral e em particular em Ruby on Rails. Eu mesmo já cometi e aprendi sobre várias elas na prática e em particular tive que pegar alguns projetos de resgate onde continuo vendo os mesmos erros acontecendo repetidamente, então vamos tentar resumir as principais que mais me irritam.

**1)** Primeiro de tudo é a ausência de testes, ou cobertura muito pequena, ou testes que são muito frágeis. Pessoal, isso é uma coisa básica! Se ainda não fazem isso comecem imediatamente a adicionar os malditos testes! Quanto pior for a qualidade e cobertura dos testes proporcionalmente mais caro fica manter e expandir uma aplicação, ponto final. Codificadores que não escrevem testes demonstram muito pouco respeito pela sua própria prática. 

Já discutimos ad nauseaum (dica pra começar: ["The RSpec Book"](http://pragprog.com/book/achbd/the-rspec-book)) sobre testes nos últimos anos então o que não falta é material para aprender e as melhores práticas. Não me importo se os testes são feitos "by the book" escrevendo testes antes do código ou se os testes são adicionados depois do código, contanto que no final existam testes que eu possa executar e ter segurança de que não estou criando bugs de regressão, quebrando coisas que não deveria. Não custa quase nada adicionar os testes mínimos, então adicionem. 

Ultimamente tivemos diversos problemas de segurança, muita gente simplesmente atualizou suas gems para as mais recentes para pegar as correções. Somente quem tinha bons testes viu que algumas dessas correções [introduziam regressões](http://blog.bugsnag.com/2013/03/20/rails-3-2-13-performance-regressions-major-bugs/). Quem não testou e só atualizou acabou colocando no ar versões com bugs.

**2)** Escreva nomes em inglês dentro do seu código. Não me importo se você é brasileiro, italiano, francês ou o que for. Nomes de classes, de variáveis, de métodos, tudo deve ser em inglês. Estamos num mundo globalizado, não é pensar muito longe que amanhã um americano vai mexer no seu código todo em português. Além do problema de consistência: a sintaxe da linguagem, todas as bibliotecas padrão, é tudo em inglês. É uma enorme dissonância cognitiva ter nomes em português no meio. É como você estar lendo uma revista em português com diversos parágrafos em inglês no meio. Não faz nenhum sentido. 

E aproveitando outra coisa que muitos não fazem: não é obrigatório usar o sistema de [localização do Rails](http://guides.rubyonrails.org/i18n.html). Porém no primeiro momento onde você se ver adicionando strings de mensagens dentro de models e controllers, pare! Existe local para isso, e é em <tt>config/locales</tt>. Não tem nada pior do que achar dezenas de mensagens espalhadas por todas as classes.

**3)** Hoje existem diversos frameworks e bibliotecas para front-end, seja para stylesheet (Bourbon, Bootstrap, Compass), para javascript (jQuery, Ember, Angular, Backbone), e diversas ferramentas (Sass, Coffeescript). Além disso temos toda uma [convenção e estruturas](http://akitaonrails.com/2012/07/01/asset-pipeline-para-iniciantes) em <tt>app/assets</tt> para organizar tudo issso. Parem de colocar styles e javascript inline espalhados pelas views! É sintoma de preguiça, de falta de conhecimento e tentativa de pular passos fazendo gambiarras. Não faça isso!

**4)** Não tente ser mais esperto do que seu ORM (Object Relational Model), no caso o ActiveRecord. Na enorme maioria dos casos, se você estiver usando <tt>find_by_sql</tt> por motivos de otimizar "performance", você está fazendo a coisa errada. Pior ainda, em quase todos os casos que já vi essa tentativa de otimizar na mão não só não havia esse ganho como ainda já vi adicionando buracos de segurança, como o famigerado ["SQL Injection"](http://rails-sqli.org). Aliás, esse é um tema frequente: otimização prematura e desnecessária adicionando bugs de segurança.

Talvez 1% dos maiores sites do mundo precisem de SQLs realmente específicos otimizados manualmente depois de muitos testes em produção, com volume de dados e métricas bem definidas para provar a diferença. Mas a maioria de nós está nos 99% que não precisa disso: apenas aprenda a usar o ActiveRecord corretamente.

Por exemplo, o problema fazer N+1 queries desnecessariamente, como está explicado no [guia oficial de ActiveRecord](http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations) e que eu copio aqui:

```ruby
clients = Client.limit(10)
 
clients.each do |client|
  puts client.address.postcode
end
```

Esse código vai fazer 11 queries no banco. A primeira para buscar 10 clientes e depois no loop para buscar o endereço de cada cliente. Isso é tão óbvio que ninguém deveria estar caindo mais nisso. O correto é fazer:

```ruby
clients = Client.includes(:address).limit(10)
 
clients.each do |client|
  puts client.address.postcode
end
```

Nesta versão já estamos puxando os endereços ao mesmo tempo que puxamos os clientes, em apenas 2 queries: uma para puxar os clientes e uma única pra puxar todos os endereços de todos os clientes. Não precisou escrever nenhum SQL na mão, bastou saber usar o ActiveRecord corretamente para cair de 11 para 2 queries.

Complementando e enfatizando: aprendam tudo sobre as as APIs do ActiveRecord e como as queries são montadas. Uma coisa horrorosa que já vi diversas vezes foram tentativas de ser "esperto" e fazer código como este:

```ruby
Subscription.all.select { |s| s.expired? }.each { |s| s.destroy }
```

Para ficar claro: isso **NÃO** é "usar as funcionalidades funcionais de Ruby". Isso é ser ignorante quanto bancos de dados e ORMs em geral. Só para ficar absolutamente claro, esse código deveria ser assim:

```ruby
Subscription.where(expired: true).destroy_all
Subscription.destroy_all(expired: true)
```

Lembrando que <tt>destroy</tt> permite chamar regras de negócio para cada objeto destruído e se usar <tt>delete</tt> é um comando simples SQL para apagar do banco apenas. Depende o que você pretende fazer ao destruir o objeto. Além disso o campo "expired" deveria ser um [escopo](http://guides.rubyonrails.org/active_record_querying.html#scopes) dentro do model. Como podem ver, uma simples linha pode ter múltiplas opções dependendo do que se pretende fazer. Novamente não tente ser mais esperto do que o ORM, ele provavelmente já tem tudo que você está imaginando, então não reinvente a roda e leia as APIs.

Outros sintomas básicos que já vi: chamar <tt>save(validate: false)</tt>. Se você está desativando a validação que você ou sua equipe colocou, o que está acontecendo? Existem sim, casos específicos de cargas de dados controlados que talvez possam precisar disso. Na maior parte dos casos não precisa. Na maior parte dos casos é o programador que teve preguiça de entender a aplicação fazendo uma gambiarra pra cumprir sua tarefa de forma "rápida" e largou uma bomba relógio pra trás (falta de testes esconde erros que esse tipo de ação causa).

**5)** Não use um banco de dados NoSQL a menos que você tenha uma explicação técnica objetiva com argumentos que justifiquem a qualquer um de forma incontestável o porquê dessa escolha. Digo isso porque a maioria das vezes que alguém me falou em usar um MongoDB a resposta cai nas linhas do "vai que um dia precisamos". E não, a maioria de vocês não precisa de um banco de dados NoSQL. Para começar a maioria sequer entende a diferença entre documentos com schema flexível (MongoDB, CouchDB), estruturas de chave-valor (Redis, Riak), ou estruturas orientadas a coluna (Cassandra). 

Primeiro que não sabem que existem esses diferentes tipos, então não sabem qual desses é o que realmente resolve seu problema, finalmente não tem idéia do trabalho que é dar manutenção em produção desse tipo de infraestrutura. Aprendam o seguinte: usem bancos de dados relacionais, de preferência PostgreSQL. Vocês não precisam de mais do que isso. Na maior parte do tempo é a preguiça de entender o modelo entidade-relacional e achar que o modelo NoSQL é "mais fácil". 

Na minha experiência, ainda não cruzei com um projeto onde a presença de um banco NoSQL fosse indispensável. Em todos os casos que vi, eles acabavam fazendo o que um PostgreSQL faria com as duas mãos nas costas. _"Ah, mas eu preciso fazer operações de geolocalização"_. Avaliem o [PostGIS](https://github.com/dazuma/activerecord-postgis-adapter). _"Ah, mas eu tenho alguns atritutos dinâmicos que variam, então preciso de uma schema flexível"_. Não necessariamente, provavelmente o suporte [HStore](https://github.com/engageis/activerecord-postgres-hstore) é tudo que você precisa.

Outros casos básicos: usar o banco de dados de produção pra produzir relatórios pesados. Ou o caso mais básico: ter apenas uma instância de banco para leitura e escrita. Não custa nada fazer o básico: uma instância master que é read-write e outra slave que é read-only. Mande as operações de escrita pra master e queries complicadas que consomem processamente para a slave. Mais do que isso, aprenda que a configuração padrão de todo banco de dados é ruim. Aprenda a fazer o tuning básico.

Em resumo: a maioria dos projetos ruins que peguei demonstravam baixo nível de entendimento tanto de bancos de dados relacionais em geral, baixo conhecimento de SQL (índices pessoal! índices!), e por consequência uso muito pobre do ActiveRecord.

**6)** Falando nisso, outra coisa irritante é pegar um projeto que precisa de mais do que um <tt>bundle</tt> e <tt>rake db:migrate</tt> pra começar a funcionar. Seja porque tem um SOLR a ser configurado, um Redis, alguns rake tasks customizados que precisam ser executados, etc. Pessoalmente, existe um arquivo chamado <tt>README</tt> na raíz de todo projeto que não está lá de enfeite! Não vai custar 1 minuto preencher as informações básicas do ambiente nesse arquivo e economizar horas da sua equipe e dos programadores que vão herdar seu sistema no futuro. Ou você mesmo, que vai passar um tempo sem mexer nesse sistema e quando voltar vai ter que se lembrar de todos os detalhes. 

Aliás, aprenda o básico de administração de sistemas Unix-like (Linux) antes de sair reclamando que Ruby é lento, que bancos de dados relacionais são lentos, que o framework é inseguro. Como você pode reclamar da segurança do framework se todas as portas dos seus servidores estão abertos publicamente?? 

**7)** E falando em qualidade de código, cobertura de testes e segurança, usem as ferramentas que a comunidade criou e que vão ajudar muito na manutenção dos projetos. O [CodeClimate](https://codeclimate.com) vai checar a qualidade geral do seu código e também da segurança. Cheque o tempo todo, qualquer coisa abaixo de nível 3 é ruim. Configurem seu projeto no [Travis-CI](https://travis-ci.org) e, finalmente, executem o [Brakeman](http://brakemanscanner.org) e atualize essa gem em particular constantemente. Isso vai garantir o mínimo do mínimo do seu projeto.

**8)** Eu gosto de usar os gráficos de projetos do Github. Ele conta muito sobre os programadores envolvidos no projeto. E antes que alguém diga, não, não é a comparação de quantidade de linhas de códigos ou quantidade absoluta de commits. É o comportamento individual comparado no tempo. Depois de algumas semanas é possível ver o que seria o "normal" desse programador. Então você começa a ver que a produtividade começa a cair, especialmente nas primeiras semanas, então próximo à entrega vê que dá picos. Normalmente isso é o programador que começou subestimando as tarefas do projeto e perto da entrega se desespera e começa a vomitar código. Comportamento muito ruim porque isso leva a pular passos como pular testes, escrever código sem cuidado, sem segurança e fazendo tudo que eu falei acima que não era pra fazer.

Quando esse comportamento começa a acontecer você vê o sintoma seguinte: programador reclamando do projeto, reclamando que o gerenciamento está ruim, que o cliente é ruim, que o projeto é ruim. São as desculpas mais comuns de péssimos programadores que cometeram erros e jogam seus erros nos outros. Impressionante como esse comportamento tem alta correlação com o tipo de gráfico que mencionei no Github. 

Nessa mesma linha vamos combinar: código que está somente na sua máquina não está "pronto". Pronto significa já no repositório, passando todos os testes no Travis-CI, feito deployment em produção e sem gerar bugs de regressão ou bugs de usabilidade que os clientes/usuários descobrem sozinhos na primeira vez que usam a nova versão. Aliás, por que diabos você saiu do escritório sem colocar o código em produção? Não há desculpa para isso. Cansei de ver programadores que "esquecem" de colocar o código em produção. O que você estava esperando? Um convite formal? Programador que demora pra colocar o código no repositório está fazendo as coisas erradas. Já mandei funcionários embora que depois dizem _"ah, faltou eu fazer push do código no repositório"_. O que é isso? Tentativa amadora de fazer código como refém? 

Bullshit!

Essas são algumas más-práticas. Existem mais, quais são as piores que você já viu? Comentem e eu vou incorporar as mais interessantes no artigo também.
