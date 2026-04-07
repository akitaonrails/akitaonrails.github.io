---
title: "Compartilhando models entre aplicações Rails - Parte 1"
date: '2016-10-03T15:00:00-03:00'
slug: compartilhando-models-entre-aplicacoes-rails-parte-1
translationKey: sharing-models-between-rails-apps-1
aliases:
- /2016/10/03/sharing-models-between-rails-apps-part-1/
tags:
- rails
- database
- traduzido
draft: false
---

_"Cria um microservice e expõe uma API."_

Essa seria a resposta rápida se você perguntar para qualquer desenvolvedor como compartilhar lógica de negócio entre aplicações.

Apesar de fazer sentido em muitas situações, essa resposta deixa a desejar em vários outros casos.

Meu TL;DR para algumas situações é o seguinte: você pode organizar a lógica dos seus models como [ActiveSupport::Concerns](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html) (ou Modules Ruby puros, se preferir) e movê-los para uma Rubygem que suas aplicações podem consumir.

Repare que estou falando apenas de Models, não de Controllers ou Views. Para compartilhar essas outras coisas você precisaria de uma Rails Engine completa. Mas em muitos casos que vi a vontade era apenas compartilhar a lógica de negócio entre aplicações, mantendo o front-end separado.

Um pequeno exemplo desse cenário é o projeto open source em que venho trabalhando nas últimas semanas. [Central](https://github.com/Codeminer42/cm42-central), uma alternativa ao Pivotal Tracker/Trello - caso você se interesse.

Há alguns dias comecei um novo projeto (apenas para uso interno) que precisava consultar os mesmos models do Central. Eu não queria implementar APIs HTTP nesse momento, e a nova aplicação teria seus próprios models com relacionamentos com os models do Central (tratando-os como read-only).

Depois de alguns refactorings, a maioria dos models do Central ficou parecida com este:

```ruby
class Team < ActiveRecord::Base
  include Central::Support::TeamConcern::Associations
  include Central::Support::TeamConcern::Validations
  include Central::Support::TeamConcern::Scopes
  include Central::Support::TeamConcern::DomainValidator
  ...
end
```

E tenho essa dependência no `Gemfile`:

```ruby
gem 'central-support', github: 'Codeminer42/cm42-central-support', branch: 'master', require: 'central/support'
```

Sempre que mudo as concerns, rodo um `bundle update central-support` nos projetos (esse é o cuidado que você precisa ter para evitar lidar com models desatualizados).

Isso foi possível porque a maioria desses models já estava madura e estável e eu não vou mexer neles com frequência. Eu não recomendo expor dependências instáveis (como gems ou APIs, tanto faz), porque essa é a receita para uma dor de cabeça enorme com breaking changes em cascata por causa de dependências desatualizadas que mudam com frequência demais.

> Você deve APENAS expor lógica de negócio que esteja razoavelmente estável (mudanças apenas de semana em semana, mais ou menos).

A jornada toda foi montar uma certa estrutura de Rubygems, organizar os models originais em Concerns (o que não quebra nenhum comportamento), garantir que os specs continuassem passando, e então mover o conteúdo (models e specs) para a nova Rubygem e garantir que os specs passassem por lá.

Foi assim que construí uma dependência open source secundária do Central, chamada [Central Support](https://github.com/Codeminer42/cm42-central-support). Como muitas gems, o arquivo principal [lib/central/support.rb](https://github.com/Codeminer42/cm42-central-support/blob/master/lib/central/support.rb) é só um monte de 'requires' para carregar todas as dependências.

Então organizei metodicamente a lógica em concerns, como [lib/central/support/concerns/team_concern/association.rb](https://github.com/Codeminer42/cm42-central-support/blob/master/lib/central/support/concerns/team_concern/associations.rb), que é só a extração das associações de Active Record do model 'Team'.

Recortar do Central, colar no Support. Quando toda a lógica relevante já tinha sido movida, consegui mover o spec inteiro do model Team, basicamente sem alterações, e fazê-lo rodar. Toda vez que eu movia um pedacinho, dava `bundle update` na gem e rodava a suíte principal de specs para garantir que nada tinha quebrado.

E essa é a parte difícil: montar um sandbox onde essas concerns possam rodar e ser testadas.

Para começar, precisei construir uma aplicação Rails mínima dentro da pasta de specs, em `spec/support/rails_app`. E ali eu pude colocar models falsos que incluem as concerns que acabei de extrair do Central.

Existe pouca documentação sobre como fazer isso, mas acho que dá para fazer um `rails new` e começar dali, ou copiar a minha pasta `rails_app` para ter o mínimo necessário. Meu caso é mais simples porque essa gem não é de propósito geral, então não preciso rodá-la contra versões diferentes do Rails, por exemplo.

Essa app de teste interna precisa ter um [`Gemfile`](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/support/rails_app/Gemfile) cuidadosamente montado:

```ruby
...
gem 'central-support', path: File.expand_path("../../../..", __FILE__)

gem 'devise'
gem 'pg'
gem 'friendly_id'
gem 'foreigner'

group :test do
  gem 'test-unit'
  gem 'rspec-rails'
...
```

Você não precisa adicionar as gems do [gemspec](https://github.com/Codeminer42/cm42-central-support/blob/master/central-support.gemspec) principal. Mas você pode remover as dependências de desenvolvimento que iriam para o gemspec e mantê-las no Gemfile da app de teste.

Agora, a partir do [`Gemfile` principal](https://github.com/Codeminer42/cm42-central-support/blob/master/Gemfile) você pode fazer:

```ruby
source 'https://rubygems.org'

eval_gemfile File.join(File.dirname(__FILE__), "spec/support/rails_app/Gemfile")
```

A maioria dos tutoriais de como construir uma Rubygem coloca uma linha para carregar dependências do gemspec, mas aqui estamos substituindo isso pelo Gemfile da app de teste. Esse é o manifest que será carregado quando rodarmos `bundle exec rspec`, por exemplo.

Por falar nisso, esse é o [`spec/rails_helper.rb`](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/rails_helper.rb):

```ruby
ENV['RAILS_ENV'] ||= 'test'

require 'rails/all'

require 'factory_girl'
require 'factory_girl_rails'
require 'rspec/rails'
require 'shoulda/matchers'

`cd spec/support/rails_app ; bin/rails db:drop db:create db:schema:load RAILS_ENV=test`

require 'support/rails_app/config/environment'

require 'support/database_cleaner'
require 'support/factory_girl'
require 'support/factories'
require 'spec_helper'
```

Para visualizar como tudo se encaixa:

* `bundle exec rspec` carrega o `Gemfile` principal
* o `Gemfile` principal carrega a partir do `Gemfile` da app de teste interna
* esse `Gemfile` da app de teste interna requer o gemspec de `../../../..` e os grupos de gems de development e test (incluindo Rspec, Factory Girl, etc)
* o gemspec requer as dependências de runtime como "activesupport", "enumerize", etc
* finalmente, o `rails_helper.rb` listado acima é carregado.

Ali na linha 11, o runner executa um comando para fazer `cd` na pasta raiz da app de teste interna e rodar `db:schema:load`, então você precisa de um `db/schema.rb` pronto para ser carregado, assim como um `config/database.yml`.

O [`spec/spec_helper.rb`](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/spec_helper.rb) é mais padrão, com configurações opcionais para test coverage, etc.

Os models dentro da app de teste interna são as partes importantes, porque são o meio para incluir as concerns extraídas em um formato executável. O ['spec/support/rails_app/app/models/team.rb'](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/support/rails_app/app/models/team.rb) é um exemplo:

```ruby
class Team < ActiveRecord::Base
  include Central::Support::TeamConcern::Associations
  include Central::Support::TeamConcern::Validations
  include Central::Support::TeamConcern::Scopes
  include Central::Support::TeamConcern::DomainValidator
end
```

E com isso, consegui mover os specs sem modificações diretamente do projeto principal (Central), como [`spec/central/support/team_spec.rb`](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/central/support/team_spec.rb):

```ruby
require 'rails_helper'

describe Team, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many :enrollments }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :ownerships }
  it { is_expected.to have_many :projects }
  ...
end
```

Se você voltar no projeto Central, alguns commits atrás, vai encontrar exatamente esse mesmo arquivo como [`spec/models/team_spec.rb`](https://github.com/Codeminer42/cm42-central/blob/a80eefadf233f4a8c5f88829836c872b199798cd/spec/models/team_spec.rb). E a principal vantagem dessa abordagem é justamente conseguir mover a maior parte do código para fora do projeto principal, junto com os specs, para uma gem de dependência, sem precisar "reescrever" nada.

Se eu tivesse que reescrever todo ou um pedaço grande do código, teria sido uma escolha bem mais cara e eu provavelmente teria adiado isso para outro momento e focado em features mais valiosas primeiro.

Essa abordagem está longe de perfeita, mas saiu super barata. Consegui mover toda a lógica de negócio relevante para fora do projeto principal sem precisar reescrever nada além de algum código de "fiação". A nova gem de dependência recebeu todas as partes relevantes e os specs, e tudo simplesmente roda.

Então, se você tem 2 ou mais aplicações Rails que poderiam compartilhar os mesmos models, é assim que você pode começar. Claro, sempre tem um monte de ressalvas para manter em mente.

No meu caso, o projeto Central é o que pode ler e escrever no banco. Minha aplicação secundária interna usa os models apenas como read-only. Quando 2 aplicações diferentes escrevem no mesmo banco, você pode ter vários conflitos para lidar.

Essa abordagem é útil quando sua aplicação secundária se parece com um dashboard de Administração, por exemplo. Você precisa ter algumas das mesmas associações, scopes, e até validações para edição eventual, mas isso fica limitado a poucos usuários controlados.

Também é útil quando você está fazendo análise de dados, e novamente pode usar as mesmas associações, scopes, para construir relatórios e dashboards. Essencialmente, quando você precisa de acesso read-only, é decisão fácil.

No [próximo artigo](http://www.akitaonrails.com/2016/10/03/sharing-models-between-rails-apps-part-2) eu vou explicar como liguei uma aplicação secundária, usando a gem central-support e lidando com 2 bancos de dados diferentes ao mesmo tempo.
