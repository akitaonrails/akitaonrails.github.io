---
title: "Pequeno Experimento com Rails sobre JRuby 9.x no Heroku"
date: '2016-06-03T18:12:00-03:00'
slug: pequeno-experimento-com-rails-sobre-jruby-9-x-no-heroku
translationKey: rails-jruby-9x-heroku-experiment
aliases:
- /2016/06/03/small-experiment-with-rails-over-jruby-9-x-on-heroku/
tags:
- jruby
- heroku
- traduzido
draft: false
---

Depois de brincar com linguagens diferentes de Ruby (como [Elixir](/elixir) ou [Crystal](/crystal)), chegou a hora de voltar para o Ruby e ver como o JRuby está se saindo nos dias de hoje.

O JRuby sempre perseguiu o objetivo de ser um substituto competente para o MRI. Se você não acompanhou o que andou rolando, o JRuby mudou o esquema de versões quando saiu da série 1.7 para a série 9.x. Vale a pena ler [este post](blog post) que explica isso.

Em resumo, se você quer compatibilidade com o MRI 2.2, precisa usar o JRuby 9.0.x; e se quer compatibilidade com o MRI 2.3, precisa usar a série 9.1.x. A versão mais atual é a 9.1.2.0. Para qualquer coisa anterior, dá pra consultar esta [tabela de versões](https://devcenter.heroku.com/articles/ruby-support#ruby-versions) da documentação do Heroku.

Existem algumas recomendações importantes também:

* O ideal é usar Rails 4.2. Tente ficar pelo menos acima de 4.0, e você pode ligar o `config.threadsafe!` por padrão no arquivo "config/environments/production.rb". Para entender o assunto, dá uma olhada na [excelente explicação do Tenderlove](http://tenderlovemaking.com/2012/06/18/removing-config-threadsafe.html).

* Se você está fazendo deploy no Heroku, esquece o dyno gratuito ou o 1X, que só te dá 512Mb de RAM. Apesar disso ser suficiente para a maioria das aplicações Rails pequenas (mesmo com 2 ou 3 workers concorrentes do Puma), eu percebi que até as menores apps facilmente passam disso. Então o mínimo que você deve considerar é o dyno 2X. Em qualquer configuração de servidor, pense sempre em mais de 1Gb de RAM.

### Gems

Existem várias gems com extensões em C que simplesmente não funcionam. Algumas têm substitutas drop-in, outras não. Dá uma olhada no [Wiki deles](https://github.com/jruby/jruby/wiki/C-Extension-Alternatives) para ver a lista de casos.

No meu pequeno aplicativo de exemplo - que nada mais é do que um site de conteúdo apoiado em um banco Postgresql, com ActiveAdmin para gerenciar o conteúdo, RMagick + Paperclip (sim, é uma app antiga) para upload e redimensionamento de imagens - não havia muito o que mudar. As partes importantes do meu "Gemfile" acabaram ficando assim:

```ruby
source 'https://rubygems.org'

ruby '2.3.0', :engine => 'jruby', :engine_version => '9.1.1.0'
# ruby '2.3.1'

gem 'rails', '~> 4.2.6'

gem 'devise'
gem 'haml'
gem 'puma'
gem 'rack-attack'
gem 'rack-timeout'
gem 'rakismet'

# Database
gem 'pg', platforms: :ruby
gem 'activerecord-jdbcpostgresql-adapter', platforms: :jruby

# Cache
gem 'dalli'
gem "actionpack-action_caching", github: "rails/actionpack-action_caching"

# Admin
gem 'activeadmin', github: 'activeadmin'
gem 'active_skin'

# Assets
gem 'therubyracer', platforms: :ruby
gem 'therubyrhino', platforms: :jruby

gem 'asset_sync'
gem 'jquery-ui-rails'
gem 'sass-rails'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'compass-rails'
gem 'sprockets', '~>2.11.0'

# Image Processing
gem 'paperclip'
gem 'fog'
gem 'rmagick', platforms: :ruby
gem 'rmagick4j', platforms: :jruby

group :test do
  gem 'shoulda-matchers', require: false
end

group :test, :development do
  gem "sqlite3", platforms: :ruby
  gem "activerecord-jdbcsqlite3-adapter", platforms: :jruby

  # Pretty printed test output
  gem 'turn', require: false
  gem 'jasmine'

  gem 'pry-rails'

  gem 'rspec'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner', '< 1.1.0'

  gem 'letter_opener'
  gem 'dotenv-rails'
end

group :production do
  gem 'rails_12factor'
  gem 'rack-cache', require: 'rack/cache'
  gem 'memcachier'
  gem 'newrelic_rpm'
end
```

Repare como pareei as gems para as plataformas `:ruby` e `:jruby`. Depois dessa mudança e de rodar `bundle install`, executei minha suíte de Rspec e - felizmente - todos os testes passaram de primeira sem precisar de nenhuma alteração adicional! O resultado vai variar dependendo da complexidade da sua aplicação, então tenha seus testes prontos.

### Puma

No caso do Puma, a configuração é um pouco mais delicada, a minha ficou assim:

```ruby
web_concurrency = Integer(ENV['WEB_CONCURRENCY'] || 1)
if web_concurrency > 1
  workers web_concurrency
  preload_app!
end

threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
```

É um pouco diferente do que você vai encontrar em outras documentações. A parte importante é desligar workers e preload_app quando estiver carregando sobre JRuby. Caso contrário ele reclama e quebra. No meu deploy original com MRI estou usando um dyno 1X pequeno e posso deixar `WEB_CONCURRENCY=2` e `RAILS_MAX_THREADS=5`, mas no deploy com JRuby coloquei `WEB_CONCURRENCY=1` (para desligar os workers) e `RAILS_MAX_THREADS=16` (porque parto do princípio que o JRuby aguenta mais multithreading do que o MRI).

Outro ponto importante: muita gente ainda assume que o MRI não consegue tirar proveito de threads paralelas nativas por causa do tal GIL (Global Interpreter Lock), mas isso é uma meia verdade. O MRI Ruby consegue paralelizar threads em esperas de I/O. Então, se uma parte da sua app está esperando o banco processar e devolver linhas, por exemplo, outra thread pode assumir e fazer outra coisa, em paralelo. O modelo tem alguma concorrência, ainda que limitada, então configurar uma quantidade pequena de threads para o Puma pode ajudar um pouco.

Não esqueça de configurar o Pool size para pelo menos o mesmo número de `RAILS_MAX_THREADS`. Você pode usar o `config/database.yml` para Rails 4.1+ ou adicionar um initializer. Siga a [documentação do Heroku](https://devcenter.heroku.com/articles/concurrency-and-database-connections#threaded-servers) para ver como fazer.

### Benchmarks Iniciais

Bom, consegui fazer o deploy de uma versão secundária em JRuby da minha app Rails original baseada em MRI.

A app original ainda está em um Hobby Dyno, com 512Mb de RAM. A app secundária precisou de um Standard 1X Dyno, com 1Gb de RAM.

A app em si é super simples e como eu uso cache - [como você sempre deveria fazer!](http://www.akitaonrails.com/2015/05/20/dynamic-site-as-fast-as-a-static-generated-one-with-raptor) -, o tempo de resposta é bem baixo, na casa das dezenas de milissegundos.

Tentei usar a ferramenta [Boom](https://github.com/rakyll/boom) para fazer benchmark das requisições. Aqueci bastante a versão JRuby, rodei os benchmarks várias vezes e até usei o Loader.io para colocar mais pressão.

Estou rodando este teste:

```
$ boom -n 200 -c 50 http://foo-my-site/
```

A versão MRI se comporta assim:

```
Summary:
  Total:    16.4254 secs
  Slowest:  9.0785 secs
  Fastest:  0.8362 secs
  Average:  2.6551 secs
  Requests/sec: 12.1763
  Total data:   28837306 bytes
  Size/request: 144186 bytes

Status code distribution:
  [200] 200 responses

Response time histogram:
  0.836 [1] |
  1.660 [57]    |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  2.485 [57]    |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  3.309 [33]    |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  4.133 [22]    |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  4.957 [16]    |∎∎∎∎∎∎∎∎∎∎∎
  5.782 [6] |∎∎∎∎
  6.606 [3] |∎∎
  7.430 [1] |
  8.254 [3] |∎∎
  9.079 [1] |

Latency distribution:
  10% in 1.2391 secs
  25% in 1.5910 secs
  50% in 2.1974 secs
  75% in 3.4327 secs
  90% in 4.5580 secs
  95% in 5.6727 secs
  99% in 8.1567 secs

```

E a versão JRuby se comporta assim:

```
Summary:
  Total:    15.5784 secs
  Slowest:  7.4106 secs
  Fastest:  0.5770 secs
  Average:  2.3224 secs
  Requests/sec: 12.8383
  Total data:   28848475 bytes
  Size/request: 144242 bytes

Status code distribution:
  [200] 200 responses

Response time histogram:
  0.577 [1] |
  1.260 [23]    |∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  1.944 [62]    |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  2.627 [51]    |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  3.310 [24]    |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  3.994 [26]    |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  4.677 [8] |∎∎∎∎∎
  5.361 [1] |
  6.044 [0] |
  6.727 [1] |
  7.411 [3] |∎

Latency distribution:
  10% in 1.1599 secs
  25% in 1.5154 secs
  50% in 2.0781 secs
  75% in 2.8909 secs
  90% in 3.7409 secs
  95% in 4.2556 secs
  99% in 6.7685 secs
```

No geral, eu diria que estão por aí, mais ou menos no mesmo patamar. Como esse não é um processamento particularmente intensivo de CPU, e a maior parte do tempo é gasta atravessando a stack do Rails e batendo no Memcachier para puxar de volta sempre o mesmo conteúdo, talvez seja justo esperar resultados parecidos.

Por outro lado, não tenho certeza se estou usando a ferramenta da melhor maneira possível. O log fala algo assim para cada requisição:

```
source=rack-timeout id=c8ad5f0c-b5c1-47ec-b88b-3fc597ab01dc wait=29ms timeout=20000ms state=ready
Started GET "/" for XXX.35.10.XXX at 2016-06-03 18:54:34 +0000
Processing by HomeController#home as HTML
Read fragment views/radiant-XXXX-XXXXX.herokuapp.com/en (6.0ms)
Completed 200 OK in 8ms (ActiveRecord: 0.0ms)
source=rack-timeout id=c8ad5f0c-b5c1-47ec-b88b-3fc597ab01dc wait=29ms timeout=20000ms service=19ms state=completed
source=rack-timeout id=a5389dc4-9a1a-46b7-a1e5-53f334ca0941 wait=35ms timeout=20000ms state=ready

Started GET "/" for XXX.35.10.XXX at 2016-06-03 18:54:36 +0000
Processing by HomeController#home as HTML
Read fragment views/radiant-XXXX-XXXXX.herokuapp.com/en (6.0ms)
Completed 200 OK in 9ms (ActiveRecord: 0.0ms)
source=rack-timeout id=a5389dc4-9a1a-46b7-a1e5-53f334ca0941 wait=35ms timeout=20000ms service=21ms state=completed
at=info method=GET path="/" host=radiant-XXXX-XXXXX.herokuapp.com request_id=a5389dc4-9a1a-46b7-a1e5-53f334ca0941 fwd="XXX.35.10.XXX" dyno=web.1 connect=1ms service=38ms status=200 bytes=144608
```

Os tempos reportados pelo Boom são bem maiores (2 segundos?) do que os tempos de processamento nos logs (10ms?). Mesmo considerando algum overhead do roteador e por aí vai, ainda é uma diferença grande, fico me perguntando se as requisições estão ficando tempo demais na fila porque a app não está conseguindo responder mais das requisições concorrentes.

A quantidade de requisições dividida pelo número de conexões concorrentes vai puxar a performance e o throughput geral para baixo se você aumentar demais, e eu não consegui passar muito de 14 rpm com essa configuração.

Se você tem mais experiência com benchmark de http e consegue identificar algo errado que estou fazendo aqui, por favor, me avise nos comentários abaixo.

### Conclusão

O JRuby continua evoluindo, e você pode se beneficiar se já tiver um conjunto grande de Dynos ou de servidores robustos. Para aplicações pequenas ou médias, eu não recomendaria.

Já vi melhorias de várias ordens de magnitude em casos de uso específicos (acho que era um endpoint de API com tráfego muito alto). Esse caso particular que testei provavelmente não é o ponto forte dele, e mudar do MRI para o JRuby não me deu muita vantagem, então nesse caso eu recomendaria continuar com o MRI.

Tempo de inicialização ainda é um problema. Existe uma entrada no [Wiki deles](https://github.com/jruby/jruby/wiki/Improving-startup-time) com algumas recomendações, mas mesmo no deploy do Heroku eu acabei tendo erros R10 (Boot Timeout) de vez em quando para essa app pequena.

Não cheguei a tentar aumentar os dynos para a [tier Performance](https://blog.heroku.com/archives/2015/8/20/introducing-improved-performance-dynos) lançada no ano passado. Apostaria que o JRuby se sairia melhor nesses e seria mais capaz de aproveitar o poder extra de ter de 2.5GB até 14GB se você tem tráfego realmente grande (na ordem de milhares ou dezenas de milhares de requisições por minuto). Com MRI, a recomendação seria usar dynos pequenos (2X ou no máximo Performance-M) e escalar horizontalmente. Com JRuby você poderia ter menos dynos com tamanhos maiores (Performance-L, por exemplo). De novo, depende do seu caso.

Não encare os benchmarks acima como "fatos" para generalizar para qualquer lugar, eles estão ali só para te dar uma noção de um caso de uso específico meu. O resultado vai variar, então você precisa testar por si mesmo.

Outro caso de uso (que não testei) é, ao invés de simplesmente "portar" uma app MRI para JRuby, alavancar as forças únicas do JRuby como [este post](https://blog.heroku.com/archives/2016/5/24/reactive_ruby_building_real_time_apps_with_jruby_and_ratpack) do Heroku explica, no caso de usar JRuby com Ratpack, por exemplo.

Resumindo, o JRuby continua sendo um ótimo projeto para experimentar. O próprio MRI também avançou bastante e o 2.3.1 é bem decente. Na maior parte do tempo, tudo depende das suas escolhas de arquitetura como um todo, e a linguagem é só uma peça do quebra-cabeça. Se você ainda não experimentou, com certeza deveria. Ele "simplesmente funciona".
