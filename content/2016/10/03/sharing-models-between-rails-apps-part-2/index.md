---
title: Compartilhando models entre apps Rails - Parte 2
date: '2016-10-03T15:57:00-03:00'
slug: compartilhando-models-entre-apps-rails-parte-2
translationKey: sharing-models-between-rails-apps-2
aliases:
- /2016/10/03/sharing-models-between-rails-apps-part-2/
tags:
- rails
- database
- traduzido
draft: false
---

Vamos continuar de onde parei na [Parte 1](http://www.akitaonrails.com/2016/10/03/sharing-models-between-rails-apps-part-1), onde descrevi rapidamente como extrair lógica reusável de models de uma app Rails para um Rubygem testável.

Se eu fosse construir uma segunda app Rails conectando direto ao mesmo banco da primeira, bastaria adicionar a dependência do gem extraído:

```ruby
gem 'central-support', github: 'Codeminer42/cm42-central-support', branch: 'master', require: 'central/support'
```

Aí recriar os models incluindo os mesmos Concerns, e remover a capacidade de rodar `bin/rails db:migrate` na app secundária (criando tasks vazias com o mesmo nome, por exemplo).

Aliás, esse é um grande detalhe que deixei de fora na Parte 1: até aqui, o schema estava **congelado** no [gem central-support](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/support/rails_app/db/schema.rb).

Daqui pra frente, você precisa controlar a evolução das tabelas mapeadas no gem a partir do próprio gem. A melhor abordagem é usar o `spec/support/rails_app` e criar normalmente migrations novas com `bin/rails g migration` por lá. Depois você move a migration para a pasta `lib/generators/central/templates/migrations`.

O [`lib/generators/central/install_generator.rb`](https://github.com/Codeminer42/cm42-central-support/blob/master/lib/generators/central/install_generator.rb) cuida de disponibilizar uma task `central:install` que joga as migrations novas na pasta `db/migrate` da sua aplicação como de costume. Basta rodar `bundle update central-support` para pegar as últimas mudanças, rodar `bin/rails g central:install` para criar as migrations novas (ele pula automaticamente as existentes) e rodar o `bin/rails db:migrate` normal. O código de um gerador de migration é bem simples, dá pra fazer assim:

```ruby
require 'securerandom'
require 'rails/generators'
require 'rails/generators/base'
require 'rails/generators/active_record'

module Central
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)

      def create_migrations
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name}", skip: true
          sleep 1
        end
      end
    end
  end
end
```

O `migration_template` cuida de adicionar o timestamp correto no arquivo de migration, então você não precisa colocar manualmente, e o nome do arquivo template pode ser algo simples como [`migrations/add_role_field_to_user.rb`](https://github.com/Codeminer42/cm42-central-support/blob/master/lib/generators/central/templates/migrations/add_role_field_to_users.rb).

Dito isso, tem um segundo desafio que adicionei na minha app secundária interna: eu queria que ela tivesse o seu próprio banco principal e usasse o banco do Central como fonte secundária somente leitura.

Então as migrations da app secundária (vamos chamar de Central-2) vão rodar contra o seu próprio banco principal, e não contra o banco principal do Central. Isso traz o seguinte problema: a suíte de testes precisa conseguir criar e migrar os dois bancos de teste, isolados do Central. Só em produção é que o Central-2 deve conectar no banco do Central.

Toda aplicação Rails tem um `config/database.yml.sample` e um `db/schema.rb`, então comecei criando um `config/database_central.yml.sample` e um `db_central/schema.rb`.

O `config/database_central.yml.sample` já fica interessante:

```yaml
development:
  adapter: postgresql
  encoding: unicode
  timeout: 5000
  database: fulcrum_development
  pool: 5

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  adapter: postgresql
  encoding: unicode
  timeout: 5000
  <% if ENV['DATABASE_CENTRAL_URL'] %>
  url: <%= ENV['DATABASE_CENTRAL_URL'] %>
  <% else %>
  database: central_test
  <% end %>
  pool: 5

production:
  adapter: postgresql
  encoding: unicode
  timeout: 5000
  url: <%= ENV['DATABASE_CENTRAL_URL'] %>
  pool: <%= ENV['DB_POOL'] || 5 %>
```

Em produção, ele vai usar a variável de ambiente `DATABASE_CENTRAL_URL` para conectar no banco principal do Central.

Rodando os testes localmente, ele simplesmente conecta num banco local chamado `central_test`.

Agora, ao rodar testes no Gitlab-CI (ou qualquer outro CI), eu preciso configurar o `DATABASE_CENTRAL_URL` para apontar para um banco Postgresql secundário de testes.

No Gitlab, eu configuro o script de build assim:

```yaml
image: codeminer42/ci-ruby:2.3

services:
  - postgres:latest

cache:
  key: central-bot
  untracked: true
  paths:
    - .ci_cache/

variables:
  RAILS_ENV: test
  DATABASE_URL: postgresql://postgres:@postgres
  DATABASE_CENTRAL_URL: postgresql://postgres:@postgres/central_test

before_script:
  - bundle install --without development production -j $(nproc) --path .ci_cache
  - cp config/database.yml.sample config/database.yml
  - cp config/database_central.yml.sample config/database_central.yml
  - bin/rails --trace central:db:create central:db:schema:load
  - bin/rails --trace db:create db:schema:load

test:
  script:
    - bundle exec rspec
```

Repare como eu copio os arquivos ".sample" para garantir que existam. E como eu rodo tasks que você conhece como `db:create db:schema:load` para criar o banco de teste normal, mas também tasks que você não conhece como `central:db:create central:db:schema:load`.

Eu defini essas tasks em `lib/tasks/db_central.rake` assim:

```ruby
task spec: ["central:db:test:prepare"]

namespace :central do

  namespace :db do |ns|

    task "environment:set" do
      Rake::Task["db:environment:set"].invoke
    end

    task :drop do
      Rake::Task["db:drop"].invoke
    end

    task :create do
      Rake::Task["db:create"].invoke
    end

    task :setup do
      Rake::Task["db:setup"].invoke
    end

    task :reset do
      Rake::Task["db:reset"].invoke
    end

    task :migrate do
      Rake::Task["db:migrate"].invoke
    end

    task :rollback do
      Rake::Task["db:rollback"].invoke
    end

    task :seed do
      Rake::Task["db:seed"].invoke
    end

    task :version do
      Rake::Task["db:version"].invoke
    end

    namespace :schema do
      task :load do
        Rake::Task["db:schema:load"].invoke
      end

      task :dump do
        Rake::Task["db:schema:dump"].invoke
      end
    end

    namespace :test do
      task :prepare do
        Rake::Task["db:test:prepare"].invoke
      end
    end

    # append and prepend proper tasks to all the tasks defined here above
    ns.tasks.each do |task|
      task.enhance ["central:set_custom_config"] do
        Rake::Task["central:revert_to_original_config"].invoke
      end
    end
  end

  task :set_custom_config do
    # save current vars
    @original_config = {
      env_schema: ENV['SCHEMA'],
      config: Rails.application.config.dup
    }

    # set config variables for custom database
    ENV['SCHEMA'] = "db_central/schema.rb"
    Rails.application.config.paths['db'] = ["db_central"]
    Rails.application.config.paths['db/migrate'] = ["db_central/migrate"]
    Rails.application.config.paths['db/seeds'] = ["db_central/seeds.rb"]
    Rails.application.config.paths['config/database'] = ["config/database_central.yml"]

    ActiveRecord::Tasks::DatabaseTasks.database_configuration = CM(Rails.root)
      .join("config", "database_central.yml")
      .File.read
      .ERB.new
      .result
      .YAML.load
      .unwrap.freeze
  end

  task :revert_to_original_config do
    # reset config variables to original values
    ENV['SCHEMA'] = @original_config[:env_schema]
    Rails.application.config = @original_config[:config]
  end
end
```

É assim que defino um namespace de tasks Rake que começam com `central:`, e cada uma delas conecta no banco secundário descrito no `database_central.yml`. A sintaxe estranha vem do meu [`chainable_methods`](https://github.com/akitaonrails/chainable_methods), não dê muita atenção.

O `db_central/schema.rb` é basicamente uma cópia do `spec/support/rails_app/db/schema.rb` do gem central-support, com as mesmas tabelas. O runner de specs tanto do gem quanto dessa app secundária só carrega o schema no banco de teste.

Agora que temos os fundamentos básicos para os specs no lugar, podemos focar em como a aplicação em si consome esses models externos.

Começamos adicionando um initializer como `config/initializer/db_central.rb`:

```ruby
DB_CENTRAL = CM(Rails.root)
  .join("config", "database_central.yml.sample")
  .File.read
  .ERB.new
  .result
  .YAML.load
  .unwrap.freeze
```

Nesse caso eu leio do arquivo sample porque, diferente do build de CI, quando eu faço deploy no Heroku eu não tenho um script para copiar o sample para o yaml final. Isso popula a constante `DB_CENTRAL` com a URL do banco armazenada na variável de ambiente `DATABASE_CENTRAL_URL` que eu preciso configurar.

Aí crio um arquivo novo chamado `app/models/remote_application_record.rb` mais ou menos assim:

```ruby
class RemoteApplicationRecord < ApplicationRecord
  establish_connection DB_CENTRAL[Rails.env]
  self.abstract_class = true

  unless Rails.env.test?
    default_scope -> { readonly }
  end
end
```

É assim que você cria um novo connection pool para a configuração do banco secundário. Você deve ter esse `establish_connection` em um único lugar e fazer os models herdarem daqui. O `abstract_class = true` faz com que o ActiveRecord deixe de tentar carregar de uma tabela com o mesmo nome dessa classe.

Em seguida temos um `default_scope` travando o model como `readonly`. A gente quer abrir mão disso no ambiente de teste, porque eu ainda quero deixar o Factory Girl popular o banco de teste com dados falsos para os specs. Mas é uma boa ideia ter isso em produção só para garantir.

Por fim, posso criar todos os models que preciso, como `app/models/central/team.rb`:

```ruby
module Central
  class Team < RemoteApplicationRecord
    self.table_name = 'teams'

    include Central::Support::TeamConcern::Associations
    include Central::Support::TeamConcern::Validations
    include Central::Support::TeamConcern::Scopes
  end
end
```

A partir daqui posso fazer queries Arel normais como `Central::Team.not_archived.limit(5)`.

### Conclusões

Se ainda não viu, dá uma olhada na [Parte 1](http://www.akitaonrails.com/2016/10/03/sharing-models-between-rails-apps-part-1) para mais detalhes.

Essa é uma receita simples para compartilhar lógica de model entre uma app Rails principal de leitura e escrita e uma app Rails secundária de só leitura. Elas compartilham a maioria (não todos) dos mesmos models, compartilham a mesma lógica (através de alguns Concerns) e compartilham o mesmo banco.

Nesse caso particular, a abordagem recomendada é criar um [Follower database](https://devcenter.heroku.com/articles/heroku-postgres-follower-databases), que é como o Heroku chama um banco secundário replicado, e fazer minha aplicação secundária conectar nele (já que ela só precisa de uma fonte somente leitura).

Para cenários mais complicados, você vai precisar de uma solução mais elaborada como uma camada de API HTTP para garantir que apenas uma App gerencie as migrations dos models. Mas a abordagem do Rubygem deve ser "boa o suficiente" para muitos casos.

Se eu realmente precisar ir por esse caminho, não vai ser difícil transformar esse pequeno gem numa app Rails API completa. Se você nem consegue separar a lógica em Concern, também não vai conseguir separar como APIs, então encare isso como um exercício rápido, um primeiro passo para criar uma [Anti Corruption Layer](http://programmers.stackexchange.com/questions/184464/what-is-an-anti-corruption-layer-and-how-is-it-used).

E como bônus, considere contribuir com os projetos open source [Central](https://github.com/Codeminer42/cm42-central) e [central-support](https://github.com/Codeminer42/cm42-central-support). Pretendo construir uma alternativa competitiva ao Pivotal Tracker/Trello e estamos chegando lá!
