---
title: Sharing models between Rails Apps - Part 2
date: '2016-10-03T15:57:00-03:00'
slug: sharing-models-between-rails-apps-part-2
tags:
- rails
- database
draft: false
---

Let's continue from where I left off in [Part 1](http://www.akitaonrails.com/2016/10/03/sharing-models-between-rails-apps-part-1) where I quickly described how you can extract reusable model logic from a Rails app into a testable Rubygem.

If I were building a secondary Rails app connecting directly to the same database as the first, I could just add the dependency to the extracted gem:

--- ruby
gem 'central-support', github: 'Codeminer42/cm42-central-support', branch: 'master', require: 'central/support'
---

Then recreate the models including the same Concerns, and make sure I remove the ability to `bin/rails db:migrate` from the secondary app (by creating empty db tasks with the same name, for example).

By the way, this is one big caveat that I didn't address in Part 1: up to this point, the schema was **frozen** in the [central-support gem](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/support/rails_app/db/schema.rb).

From now on, you must control the evolution of the tables mapped in the gem from within the gem. The best approach is to use the `spec/support/rails_app` and normally create new migration with `bin/rails g migration` from there. Then you must move the migration to the `lib/generators/central/templates/migrations` folder.

The [`lib/generators/central/install_generator.rb`](https://github.com/Codeminer42/cm42-central-support/blob/master/lib/generators/central/install_generator.rb) will take care of making a `central:install` task available that will dutifully put new migrations into your application's `db/migrate` folder as usual. You just have to `bundle update central-support` to get the newest changes, run `bin/rails g central:install` to create the new migrations (it will automatically skip existing ones) and run the normal `bin/rails db:migrate`. A migration generator code is very simple, you can do it like this:

--- ruby
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
---

The `migration_template` will take care of adding the proper timestamp to the migration file, so you don't have to add it manually and the template file name can something plain such as [`migrations/add_role_field_to_user.rb`](https://github.com/Codeminer42/cm42-central-support/blob/master/lib/generators/central/templates/migrations/add_role_field_to_users.rb).

All that having being said, there is a second challenge I added to my internal secondary app: I wanted it to have it's own main database and use Central's database as a secondary read-only source.

So migrations in the secondary app (let's just call it Central-2) will run against it's own main database, not against the main Central's database. This add the following problem: the test suite must be able to create and migrate both test databases, in isolation from Central. Only in production should Central-2 connect to Central's database.

Every Rails application has a `config/database.yml.sample` and a `db/schema.rb`, so I started by creating a `config/database_central.yml.sample` and a `db_central/schema.rb`.

The `config/database_central.yml.sample` is already interesting:

--- yaml
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
---

In production, it will use the `DATABASE_CENTRAL_URL` environment variable to connect to Central's main database.

When running tests locally, it will simply connect to a local database named `central_test`.

Now, while running tests at Gitlab-CI (or any other CI for that matter), I have to configure the `DATABASE_CENTRAL_URL` to point to a secondary Postgresql test database.

For Gitlab, this is how I configure the build script:

--- yaml
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
---

Notice how I copy the ".sample" config files to make sure they exist. And then how I run tasks you know such as `db:create db:schema:load` to create the normal test database, but tasks you don't know such as `central:db:create central:db:schema:load`.

I defined those tasks in `lib/tasks/db_central.rake` like this:

--- ruby
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
---

This is how I define a namespace of Rake tasks that start with `central:`, and every one of those connect to the secondary database as described in `database_central.yml`. The weird syntax in line 81 is from my [`chainable_methods`](https://github.com/akitaonrails/chainable_methods), don't mind it too much.

The `db_central/schema.rb` is basically a copy of the `spec/support/rails_app/db/schema.rb` from the central-support gem, with the same tables. The spec runner of both the gem and this secondary app will just load the schema into the test database.

Now that we have the basic underpinnings for specs in place, we can focus on how the application itself can consume those external models.

We start by adding an initializer like `config/initializer/db_central.rb`:

--- ruby
DB_CENTRAL = CM(Rails.root)
  .join("config", "database_central.yml.sample")
  .File.read
  .ERB.new
  .result
  .YAML.load
  .unwrap.freeze
---

In this case I am reading from the sample file because different from the CI build, when I deploy to Heroku I don't have a script to copy the sample to the final yaml file. This will populate the constant `DB_CENTRAL` with the database URL stored in the `DATABASE_CENTRAL_URL` environment variable that I have to set.

Then I create a new file called `app/models/remote_application_record.rb` that looks like this:

--- ruby
class RemoteApplicationRecord < ApplicationRecord
  establish_connection DB_CENTRAL[Rails.env]
  self.abstract_class = true

  unless Rails.env.test?
    default_scope -> { readonly }
  end
end
---

This is how you create a new connection pool for the secondary database configuration. You must only have this `establish_connection` in one place and have the models inherit from here. The `abstract_class = true` will make ActiveRecord not try to load from a table of the same name as this class.

Then we have a `default_scope` locking down the model as `readonly`. We don't want that in the test environment because I still want to have Factory Girl populate the test database with fake data for the specs. But it's good idea to have it in the production environment just to make sure.

Finally, I can create all the models I need, such as `app/models/central/team.rb`:

--- ruby
module Central
  class Team < RemoteApplicationRecord
    self.table_name = 'teams'

    include Central::Support::TeamConcern::Associations
    include Central::Support::TeamConcern::Validations
    include Central::Support::TeamConcern::Scopes
  end
end
---

From here I can just call normal Arel queries such as  `Central::Team.not_archived.limit(5)`.

### Conclusions

If you didn't already, refer to [Part 1](http://www.akitaonrails.com/2016/10/03/sharing-models-between-rails-apps-part-1) for more details.

This is a simple recipe to share model logic between a main read-write Rails app and a secondary read-only Rails app. They share most (not all) of the same models, they share the same logic (through some of the Concerns), and they share the same database.

In this particular case, the recommended approach is to create a [Follower database](https://devcenter.heroku.com/articles/heroku-postgres-follower-databases), which is how Heroku calls a secondary replicated database and make my secondary application connect to that (as it only needs a read-only source).

For more complicated scenarios, you will need a more complicated solution such as an HTTP API layer to make sure only one App manages model migrations and such. But the Rubygem approach should be "good enough" for many cases.

If I really need to go that way, it won't be too difficult to transform this small gem into a full blown Rails API app. If you can't even separate the logic as a Concern, you won't be able to separate them as APIs either, so consider this a quick exercise, a first step towards creating an [Anti Corruption Layer](http://programmers.stackexchange.com/questions/184464/what-is-an-anti-corruption-layer-and-how-is-it-used).

And as a bonus, consider contributing to the [Central](https://github.com/Codeminer42/cm42-central) and [central-support](https://github.com/Codeminer42/cm42-central-support) open source projects. I intend to build a competitive Pivotal Tracker/Trello alternative and we are getting there!
