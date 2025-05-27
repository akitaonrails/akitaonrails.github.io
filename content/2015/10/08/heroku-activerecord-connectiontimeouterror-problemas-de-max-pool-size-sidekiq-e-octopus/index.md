---
title: "[Heroku] ActiveRecord::ConnectionTimeoutError: Problemas de Max Pool Size,
  Sidekiq e Octopus"
date: '2015-10-08T15:41:00-03:00'
slug: heroku-activerecord-connectiontimeouterror-problemas-de-max-pool-size-sidekiq-e-octopus
tags:
- learning
- rails
- sidekiq
- heroku
- postgresql
draft: false
---

**TL;DR**: o problema pode estar na sua configuração de Octopus!

**TL;DR 2**: tem várias 'contas de padeiro' que fiz pelo artigo e algumas coisas que podem não estar 100%, então se você ver alguma coisa que precise melhorar, não deixe de colocar nos comentários! Esse assunto fica mudando de tempos em tempos.

Você talvez já tenha esbarrado nesta mensagem de erro algumas vezes, especialmente quando sua aplicação está sob alta demanda de tráfego ou rodando workers pesados de Sidekiq:

<blockquote>
ActiveRecord::ConnectionTimeoutError: could not obtain a database connection within 5 seconds (waited 5.000134325 seconds). The max pool size is currently 5; consider increasing it.
</blockquote>

Antes de mais nada, vale uma pequena explicação. Todo banco de dados tem um limite máximo de número de conexões, num Postgresql que você não fez tuning o default são [100 max_connections](https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server).

Apps Ruby on Rails implementam a arquitetura de ["shared-nothing"](https://blog.engineyard.com/2014/scale-everything) onde cada processo Web é independente de estado. O estado fica no banco de dados ou outro storage externo.

Cada instância de uma App Rails vai precisar responder a uma requisição Web. Para conseguir concorrência, precisamos de múltiplas instâncias da App. Podemos conseguir isso de 2 maneiras: via threads (como Puma faz) ou via fork de processos (como Unicorn faz). O [Heroku tem uma excelente documentação](https://devcenter.heroku.com/articles/concurrency-and-database-connections) de como você deve configurar em um desses casos.

No caso de Unicorn, basicamente o número de Workers será o número de conexões que seu banco precisa aceita, um connection pool não serve de muita coisa. Se usar Puma, com threads, daí dentro do processo você configura o connection pool para compartilhar um número limitado de conexões com as diversas threads. Segure este pensamento para a próxima seção.

Resumindo:

1) Se for usar [Puma](https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server), com Rails 4.1+ ou superior, configure seu <tt>database.yml</tt> assim:

```yml
production:
  url:  <%= ENV["DATABASE_URL"] %>
  pool: <%= ENV["DB_POOL"] || ENV['MAX_THREADS'] || 5 %>
```

2) Se for usar Puma, com Rails inferior a 4.1, adicione o initializer <tt>config/initializers/database_connection.rb</tt>:

```ruby
# Use config/database.yml method if you are using Rails 4.1+
Rails.application.config.after_initialize do
  ActiveRecord::Base.connection_pool.disconnect!

  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool']              = ENV['DB_POOL']      || ENV['MAX_THREADS'] || 5
    ActiveRecord::Base.establish_connection(config)
  end
end
```

3) Se for usar [Unicorn](https://devcenter.heroku.com/articles/rails-unicorn), com Rails 4.1+ ou superior, configure o <tt>config/unicorn.rb</tt> adicionando:

```ruby
before_fork do |server, worker|
  # other settings
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  # other settings
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
```

4) Se for usar Unicorn, com Rails inferior a 4.1+, altere o trecho acima com o seguinte:

```
after_fork do |server, worker|
  # other settings
  if defined?(ActiveRecord::Base)
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['DB_POOL'] || 5
    ActiveRecord::Base.establish_connection(config)
  end
end
```

## Preciso usar Sidekiq

Com Sidekiq a coisa começa a ficar mais complicada porque temos que lidar com configuração de Redis também. Tanto um processo Rails web quanto um worker Sidekiq vão precisar falar com o Redis e com um Banco de Dados (dependendo do que é o worker).

Pior ainda, no caso de um processo Web, a idéia é que a requisição seja executada o mais rápido possível, então ele prende a conexão ao banco pelo menor tempo possível, milissegundos. No caso de um worker Sidekiq a idéia é que ele seja usado justamente para as coisas pesadas como importar arquivos grandes e carregar dados no banco, o que vai pendurar a conexão por muito tempo.

## Quantas conexões vou precisar?

Um plano Heroku Postgresql Hobby Basic (de USD 9/mês) suporta um máximo de 20 conexões simultâneas.

Na prática, você pode subir 20 workers de Unicorn recebendo até 20 requisições simultâneas. Pode parecer pouco, mas se cada requisição levar 200ms pra processar (que é lento), isso são 5 requisições por segundo por processo. Com 20 processos, isso seriam 100 requisições por segundo ou 360 mil requisições numa hora, que é um número respeitável para qualquer aplicação pequena/média.

Se sua app consumir uns 200mb, isso seriam 2 processos por dyno, ou um máximo de até 10 dynos 1x (de USD 25/mês) para estourar o banco de dados. Essa a conta de padeiro, na prática não é exatamente isso porque penduramos a conexão em tempos diferentes por requisição e não é tão linear assim, mas pra efeitos de ilustração isso deve servir, no geral.

## Como calcular o pool pro Sidekiq

Com Sidekiq a coisa começa a ficar mais complicada porque temos que lidar com configuração de Redis também. Tanto um processo Rails web quanto um worker Sidekiq vão precisar falar com o Redis e com um Banco de Dados (dependendo do que é o worker).

No caso do Redis, você deve ler [esta página do Wiki do Sidekiq](https://github.com/mperham/sidekiq/wiki/Advanced-Options) e usar esta [**calculadora**](http://manuel.manuelles.nl/sidekiq-heroku-redis-calc/) para saber que tipo de plano de serviços como Redis Cloud você vai precisar (sendo o limitante a quantidade máxima de conexões). De acordo com a calculadora, num cenário de 10 dynos, com 2 web threads, 10 workers de Sidekiq, precisaria configurar concorrência do Sidekiq para 21, e ter 23 conexões do lado do servidor de Sidekiq. Comece configurando o <tt>config/sidekiq.yml</tt> assim:

```yml
:concurrency: 21
```

E o <tt>config/initializers/sidekiq.rb</tt> assim:

```ruby
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis.example.com:7372/12', namespace: 'mynamespace' }

  database_url = ENV['DATABASE_URL']
  if database_url
    ENV['DATABASE_URL'] = "#{database_url}?pool=25"
    ActiveRecord::Base.establish_connection
    # Note that as of Rails 4.1 the `establish_connection` method requires
    # the database_url be passed in as an argument. Like this:
    # ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  end
end
```

O <tt>config.redis[:size]</tt> é calculado automaticamente de acordo com o valor de concorrência no <tt>sidekiq.yml</tt> então não precisa adicionar manualmente.

Agora nosso exercício fica mais complicado porque no caso de um processo Web, a idéia é que a requisição seja executada o mais rápido possível, então ele prende a conexão ao banco pelo menor tempo possível, milissegundos. No caso de um worker Sidekiq a idéia é que ele seja usado justamente para as coisas pesadas como importar arquivos grandes e carregar dados no banco, o que vai pendurar a conexão por muito tempo.

Daí a conta que fizemos anteriormente fica ruim. Porque se eu tiver os 10 workers de Sidekiq processando coisas pesadas ao mesmo tempo, e mexendo no banco de dados ao mesmo tempo, acabei de perder 10 das 20 conexões máximas que eu tinha no plano Hobby Basic. Agora ou eu diminuo o número de Web Dynos de 10 para 5 ou aumento o plano do banco de dados ou otimizo para não precisar usar tantas conexões acima.

## Connection Pool

Para minimizar esses problemas existem connection pools.

No caso do connection pool do Active Record ele existe dentro de uma instância Rails. No caso do Unicorn não serve pra muita coisa. No caso do Puma, que é multi-thread (com [caveats](https://github.com/phusion/passenger/wiki/Puma-vs-Phusion-Passenger)), ajuda um pouco. As threads dentro de um mesmo processo compartilham as conexões nesse pool. Você pode mandar um número de threads maior que o número de conexões no pool, a idéia sendo que dificilmente todas as threads precisam de conexão o tempo todo.

O problema é que cada processo independente de Rails vai ter seu próprio pool. Se usar o padrão de 5 conexões por pool, e tiver 5 Web dynos com Puma, você vai precisar de _até_ 25 conexões ao banco de dados. Isso sem contar o Sidekiq que tem seu próprio connection pool.

Às vezes você não viu que sua configuração ultrapassou o limite do banco porque seu site tem pouco throughput (poucas requisições realmente concorrendo simultaneamente). Mas quando tiver mais concorrência acontecendo, vai começar a sentir os problemas.

Muito rapidamente o problema é que quando você escalar a quantidade de Web ou Worker Dynos vai esbarrar no número máximo de conexões do plano do Postgresql mesmo quando não estiver de fato executando em todas essas conexões, mas elas estão penduradas nos diversos pool, ficando idle, desperdiçando conexões que poderiam estar sendo usadas.

Uma coisa que você pode tentar é adicionar o PgBouncer como a [própria documentação do Heroku ensina](https://devcenter.heroku.com/articles/concurrency-and-database-connections). Pense nela como uma connection pool que é compartilhada por todos os seus processos de Rails, minimizando o desperdício.

Se estiver usando Rails 4.1 configure seu ambiente para desabilitar prepared statements primeiro:

```
heroku config:set PGBOUNCER_PREPARED_STATEMENTS=false
```

Se estiver usando Rails 4.0 nem tente, não vai funcionar.

Se estiver usando Rails 3.2 adicione o arquivo <tt>config/initializers/database_connection.rb</tt>:

```ruby
require "active_record/connection_adapters/postgresql_adapter"

class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  alias initialize_without_config_boolean_coercion initialize
  def initialize(connection, logger, connection_parameters, config)
    if config[:prepared_statements] == 'false'
      config = config.merge(prepared_statements: false)
    end
    initialize_without_config_boolean_coercion(connection, logger, connection_parameters, config)
  end
end
```

Agora para configurar o próprio Heroku execute:

```
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-pgbouncer
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-ruby
```

E altere o <tt>Procfile</tt> para:

```
web: bin/start-pgbouncer-stunnel bundle exec puma -C config/puma.rb
```

## Sharding e Octopus

Finalmente, existe outro cenário que eu até recomendo - com prudência. Normalmente quando usamos Sidekiq numa aplicação, eventualmente fazemos Workers pesados para gerar relatórios por exemplo. Um cenário onde você precisa fazer queries pesadas e lentas e você já esgotou todo seu conhecimento de otimização de SQL (criou índices, removeu N+1, denormalizou onde podia, etc).

Quando um worker desses roda, como expliquei antes, a conexão no banco vai ficar travada por muito tempo. Se muitos workers rodarem ao mesmo tempo, você vai engargalar o banco rapidamente, tanto em quantidade de conexões penduradas quanto próprio processamento geral do banco.

Uma solução rápida é criar uma configuração "master-slave" (ou "primary-follower", na nomenclatura mais politicamente correta). No mundo do Heroku isso é feito criando um [banco "Follower"](https://devcenter.heroku.com/articles/heroku-postgres-follower-databases) que é **read-only** (somente de leitura) e para onde você vai direcionar apenas as queries pesadas!

Para isso você deve configurar a [gem Octopus](https://devcenter.heroku.com/articles/distributing-reads-to-followers-with-octopus) no seu projeto. Em resumo, comece adicionando a gem no seu <tt>Gemfile</tt>:

```ruby
gem 'ar-octopus', require: 'octopus'
```

Agora **Cuidado** até pouco tempo atrás a documentação no Heroku estava defasada mas você deve criar o arquivo <tt>config/shards.yml</tt> com o exato seguinte conteúdo:

```ruby
<%
require 'cgi'
require 'uri'

def attribute(name, value, force_string = false)
  if value
    value_string =
      if force_string
        '"' + value + '"'
      else
        value
      end
    "#{name}: #{value_string}"
  else
    ""
  end
end

configs = case Rails.env
when 'development', 'test'
  # use dev and test DB as feaux 'follower'
  Array.new(2){YAML::load_file(File.open("config/database.yml"))[Rails.env]}
else
  # staging, production, etc with Heroku config vars for follower DBs
  master_url = ENV['DATABASE_URL']
  slave_keys = ENV.keys.select{|k| k =~ /HEROKU_POSTGRESQL_.*_URL/}
  slave_keys.delete_if{ |k| ENV[k] == master_url }

  slave_keys.map do |env_key|
    config = {}
    begin
      uri = URI.parse(ENV["#{env_key}"])
    rescue URI::InvalidURIError
      raise "Invalid DATABASE_URL"
    end

    raise "No RACK_ENV or RAILS_ENV found" unless ENV["RAILS_ENV"] || ENV["RACK_ENV"]
    config['color'] = env_key.match(/HEROKU_POSTGRESQL_(.*)_URL/)[1].downcase
    config['adapter'] = uri.scheme
    config['adapter'] = "postgresql" if config['adapter'] == "postgres"

    config['database'] = (uri.path || "").split("/")[1]

    config['username'] = uri.user
    config['password'] = uri.password

    config['host'] = uri.host
    config['port'] = uri.port

    config['params'] = CGI.parse(uri.query || "")
    config
  end
end

whitelist = ENV['SLAVE_ENABLED_FOLLOWERS'].downcase.split(', ') rescue nil
blacklist = ENV['SLAVE_DISABLED_FOLLOWERS'].downcase.split(', ') rescue nil

configs.delete_if do |c|
  ( whitelist && !c['color'].in?(whitelist) ) || ( blacklist && c['color'].in?(blacklist) )
end
%>
octopus:
  replicated: true
  fully_replicated: false
  environments:
  <% if configs.present? %>
    <%= "- #{ENV["RAILS_ENV"] || ENV["RACK_ENV"] || Rails.env}" %>
  <%= ENV["RAILS_ENV"] || ENV["RACK_ENV"] || Rails.env %>:
    <% configs.each_with_index do |c, i| %>
    <%= c.has_key?('color') ? "#{c['color']}_follower" : "follower_#{i + 1}" %>:
      <%= attribute "adapter",  c['adapter'] %>
      <%= attribute "database", c['database'] %>
      <%= attribute "username", c['username'] %>
      <%= attribute "password", c['password'], true %>
      <%= attribute "host",     c['host'] %>
      <%= attribute "port",     c['port'] %>
      <% (c['params'] || {}).each do |key, value| %>
      <%= key %>: <%= value.first %>
      <% end %>

    <% end %>
  <% else %>
    - none
  <% end %>
```

Outra coisa, a documentação defasada instrui a criar um <tt>config/initializers/octopus.rb</tt>. Veja esta [issue no Github](https://github.com/tchandy/octopus/issues/317#issuecomment-129480539) para mais detalhes. Em vez disso coloque esta versão simplificada no <tt>config/initializers/octopus.rb</tt> apenas para conseguirmos escolher followers aleatórios (caso tenha mais de 1):

```ruby
module Octopus
  def self.shards_in(group=nil)
    config[Rails.env].try(:[], group.to_s).try(:keys)
  end
  def self.followers
    shards_in(:followers)
  end
  def self.random_follower
    followers.sample.to_sym
  end
  class << self
    alias_method :followers_in, :shards_in
    alias_method :slaves_in, :shards_in
  end
end
```

**Pequeno adendo, by Gabriel Sobrinho, um dos mantenedores do projeto Octopus que mandou um feedback a este post:**

<blockquote>
Na verdade a documentação não está defasada, o cara que documentou usou um recurso chamado slave groups mas que é bem específico.

Slave groups você cria grupos de slaves e na hora de fazer as consultas você especifica qual grupo quer usar, e nessa hora um round-robin é usado para balancear entre os slaves.

Provavelmente se você tiver mais de um follower e quiser fazer round-robin como tu fez com o initializer, slave groups devem se encaixar melhor.

Também note que o initializer da documentação quebrava ao ajustar o shards.yml porque ele tentava acessar os slave groups que não existem mais depois do ajuste que sugeri, por isso precisa remover ele.
</blockquote>

Se você não fizer mais nada, todo model ActiveRecord vai, por padrão, continuar lendo e escrevendo do banco primário. Eu não recomendo colocar o método <tt>replicated_model</tt> às cegas como a documentação básica ensina pois isso manda os writes (insert/update/delete) pro banco primário e reads (select) pro banco follower. Isso pode causar efeitos colaterais estranhos, condições de corrida onde você vai tentar ler alguma coisa que acabou de escrever mas ainda não foi replicado pro follower se for rápido demais.

Em vez disso recomendo separar manualmente onde você quer ler do follower, por exemplo, do worker do Sidekiq você faria:

```ruby
User.using(Octopus.random_follower).find(params[:user_id])
```

Isso é o equivalente a fazer <tt>User.find(params[:user_id])</tt> no banco primário, mas vai mandar a query pra um dos seus followers. Daí você pode conectar Relations normalmente para fazer queries pesadas (lembre-se de usar [#find_each](http://api.rubyonrails.org/classes/ActiveRecord/Batches.html) para queries que retornam objetos demais antes de iterar sobre uma coleção grande demais).

Agora vem o pulo do gato que falei no "TL;DR" acima. Se você usa Sidekiq, pode começar a receber as mensagens de erro que é o título deste post. Você vai notar que o pool padrão de 5 é pequeno pra muitos workers de Sidekiq mas o que fizemos até aqui parece não funcionar, em particular a configuração do <tt>config/sidekiq.rb</tt> que mostramos acima, que sobrescreve a variável padrão <tt>DATABASE_URL</tt> com <tt>?pool=25</tt> (ou outro número, teste sua configuração).

Para passar o valor correto pro connection pool de ActiveRecord do Sidekiq, modifique seu <tt>config/sidekiq.rb</tt> pra ficar assim:

```ruby
Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

Sidekiq.configure_server do |config|
  sidekiq_concurrency = config.options[:concurrency]
  config = ActiveRecord::Base.connection.config
  pool_size = ENV['SIDEKIQ_DB_POOL'] || sidekiq_concurrency

  Octopus.config[Rails.env]['master'] = config.merge!(pool: pool_size)

  Octopus.config[Rails.env].each_key do |follower|
    Octopus.config[Rails.env][follower].merge!(pool: pool_size)
  end

  ActiveRecord::Base.connection.initialize_shards(Octopus.config)
end
```

Isso porque você precisa modificar a configuração do Octopus e não somente do ActiveRecord diretamente. Fazendo isso a configuração correta de pool de banco deve passar corretamente pros workers de Sidekiq e evitar que você fique sem conexões rápido demais por ter um pool muito pequeno. Mas lembre-se do número máximo de conexões do seu banco de dados, quantos Web Dynos e quantos Worker Dynos você tem.

Este é um processo de tentativa e erro em como sempre, depende da sua aplicação. Mas espero que este post tenha o suficiente para deixar você aquecido no assunto para saber onde procurar. Nunca deixe uma aplicação crítica com tráfego pesado num plano como Hobby Basic, o próximo plano que é o Standard-0 já sobe o máximo de conexões de 20 para 120, o Standard-2 já sobe para 400 conexões. Um follower precisa ser do mesmo plano então ao adicionar um banco follower você dobra a quantidade de conexões, daí pode deixar os Web Dynos pendurados no banco primário e os workers pesados de Sidekiq pendurados nos followers. Com a configuração correta de pools, fica menos complexo de gerenciar assim.

Experimente o PgBouncer logo que puder, coloque um banco follower com Octopus e mande seu Sidekiq ficar separado da Web. Já é um bom começo. E nada substitui queries bem feitas (procure gems como o [Bullet](https://github.com/flyerhzm/bullet) para ajudar a achar N+1) e não esquecer os índices corretos (tente usar a gem [lol_dba](https://github.com/plentz/lol_dba) para achar alguns dos índices faltando - mas cuidado, nem todos são necessários)!

Monitoraramento em produção é essencial! New Relic é obrigatório, [não deixe de instalar](https://devcenter.heroku.com/articles/newrelic#ruby-installation-and-configuration) e acompanhar!

Agradecimentos aos meus companheiros Miners Luiz Varela, André Pereira e Carlos Lopes por dividir muito tempo debugando esses problemas comigo.
