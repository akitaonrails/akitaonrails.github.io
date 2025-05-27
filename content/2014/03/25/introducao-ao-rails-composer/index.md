---
title: Introdução ao Rails Composer
date: '2014-03-25T17:19:00-03:00'
slug: introducao-ao-rails-composer
tags:
- learning
- beginner
- rails
draft: false
---

Este é um artigo bem curto para uma dica que é útil tanto para quem está começando como para quem cria muitos projetos o tempo todo. Todos conhecemos o bom e velho comando <tt>rails new novo_projeto</tt> que vai criar uma estrutura padrão de projetos. Porém, poucos de nós realmente usamos a estrutura padrão, sempre precisamos de muito mais hoje em dia. Em virtude desse requerimento, o Rails suporta um arquivo de [templates](http://edgeguides.rubyonrails.org/rails_application_templates.html) onde você pode modificar o comportamento do <tt>rails new</tt> logo em seguida. Mas esse arquivo é um script chato de manter, chato de configurar.

Em vez disso podemos usar uma outra ferramenta que existe há algum tempo chamado [Rails Composer](https://github.com/RailsApps/rails_apps_composer). Assumindo que você já tenha RVM ou Rbenv instalado e configurado:

```
gem install rails
gem install rails_apps_composer
```

Agora, crie um diretório para seu projeto e chame o comando <tt>rails_apps_composer</tt>:

```
mkdir novo_projeto
cd novo_projeto
rails_apps_composer new . -r core
```

Ao executar esse comando ele vai começar a criar a nova estrutura de projeto e ao longo do caminho vai lhe fazer diversas perguntas para que você possa customizar seu projeto. Vamos ver as principais perguntas:

```
Would you like to skip Test::Unit? (yes for RSpec) (y/n) y
```

Certamente, queremos Rspec. Não nade contra a maré, já discuti o assunto [Test::Unit vs RSpec](http://www.akitaonrails.com/2011/04/17/a-controversia-test-unit-vs-rspec-cucumber) anos atrás. Aprenda Rspec de uma vez!

```
Would you like to skip Active Record? (yes for MongoDB) (y/n) n
```

Essa vai ser mais controversa mas confie em mim: se você tem alguma dúvida sobre NoSQL, não use NoSQL. 99,99% dos casos você vai se dar muito melhor usando um SQL decente (ou seja, Postgresql). Já [discuti brevemente](http://www.akitaonrails.com/2013/03/24/quais-sao-algumas-das-piores-praticas-para-aplicacoes-ruby-on-rails--2#.UzHgWK1dXd0) esse assunto também.

```
What gem would you like to add? (blank to finish)
```

Se tiver dúvidas, pode deixar esta em branco. Algumas das coisas que você pensar provavelmente vão aparecer nas próximas perguntas. Mas de cabeça, certamente gems como [simple_form](https://github.com/plataformatec/simple_form), [friendly_id](https://github.com/norman/friendly_id), [high_voltage](https://github.com/thoughtbot/high_voltage), [kaminari](https://github.com/amatsuda/kaminari), [rails_12factor](https://github.com/heroku/rails_12factor), [better_errors](https://github.com/charliesome/better_errors) são alguns bons exemplos de gems a se acrescentar. Mas novamente, dependendo do template que escolher a seguir, muitas dessas gems já virão juntas.

```
 question  Build a starter application?
       1)  Build a RailsApps example application
       2)  Build a contributed application
       3)  I want to build my own application
railsapps  Enter your selection: 1

 question  Please upgrade to Rails 4.1 for more starter apps.
       1)  learn-rails
railsapps  Enter your selection: 1
```

Esta é mais complicada e depende da versão de Rails que escolheu usar. A versão 3.x tem mais templates de aplicativos, a versão 4.1 também, mas a 4.0 só tem a "learn-rails". Veja diretamente na [receita do composer](https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/railsapps.rb) para entender. Vou escolher a primeira opção neste exemplo, vale a pena experimentar vários deles pra ver a diferença aqui.

```
  question  Web server for development?
      1)  WEBrick (default)
      2)  Thin
      3)  Unicorn
      4)  Puma
      5)  Phusion Passenger (Apache/Nginx)
      6)  Phusion Passenger (Standalone)
   setup  Enter your selection: 2
```

Aqui é uma questão de preferência. Alguns preferem usar exatamente o mesmo servidor em development que em production. Eu particularmente sempre escolho Thin, mas mais por costume.

```
  question  Web server for production?
      1)  Same as development
      2)  Thin
      3)  Unicorn
      4)  Puma
      5)  Phusion Passenger (Apache/Nginx)
      6)  Phusion Passenger (Standalone)
   setup  Enter your selection: 3
```

Novamente, aqui é mais por costume também que escolho Unicorn. Mas em production o [Puma](http://blog.codeship.io/2013/10/16/unleash-the-puma-on-heroku.html) tem se provado uma excelente opção. O Phusion Passenger também está bastante competitivo contra o Unicorn. Vale instalar o New Relic e fazer testes em produção experimentando e tunando essas opções.

```
  question  Template engine?
      1)  ERB
      2)  Haml
      3)  Slim
   setup  Enter your selection: 3
```

Esta vai ser controversa, normalmente vai depender da qualidade e motivação dos seus programadores front-end. Na prática, hoje eu prefiro Slim. Por um motivo simples: ele tem quase a mesma performance do ERB e é mais legível e agradável de editar do que ERB. HAML pode ser duas vezes mais lento que ERB ou Slim, então prefiro não usá-lo.

```
  question  Continuous testing?
      1)  None
      2)  Guard
   setup  Enter your selection: 1
```

Eu não uso muito o [Guard](https://github.com/guard/guard), mas novamente é uma questão de gosto. Normalmente me faz perder mais tempo do que ganhar só na configuração dele, conflitos de coisas que deveriam ter recarregado e não recarregou, specs que passam quando o Guard está rodando mas quando rodo a suite toda dá pau e outros mistérios que desisti de tentar resolver.

```
  question  Front-end framework?
      1)  None
      2)  Bootstrap 3.0
      3)  Bootstrap 2.3
      4)  Zurb Foundation 5.0
      5)  Zurb Foundation 4.0
      6)  Simple CSS
   setup  Enter your selection: 2
```

Novamente, uma questão de gosto. Um projeto para cliente, sério, certamente vai ser CSS do zero. Para coisas pequenas, protótipos, aplicativos pra jogar fora depois, tanto faz Bootstrap ou Zurb. Como aqui é um demo, então vou de Bootstrap 3.

```
extras  Set a robots.txt file to ban spiders? (y/n) y
extras  Create a GitHub repository? (y/n) n
extras  Use or create a project-specific rvm gemset? (y/n) n
...
extras  Add 'therubyracer' JavaScript runtime (for Linux users without node.js)? (y/n) y
```

As extras acima são simples. E depois disso **bang** você tem uma nova aplicação Rails mais completa e pronta para realmente começar a trabalhar do que o esqueleto padrão do Rails que é espartano demais e você iria acrescentar tudo isso manualmente de qualquer jeito.

E, claro, esta foi só a introdução para quem nunca viu esta gem e talvez tenha ficado em dúvida de o que ela faz. Mas além de poder escolher suas opções interativamente você pode criar suas próprias receitas. A documentação do arquivo [README](https://github.com/RailsApps/rails_apps_composer) vai mostrar muito mais opções. Este artigo apenas mostra o pico do iceberg.

Divirtam-se!
