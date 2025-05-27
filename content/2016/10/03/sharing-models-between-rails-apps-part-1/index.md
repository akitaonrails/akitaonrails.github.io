---
title: Sharing models between Rails Apps - Part 1
date: '2016-10-03T15:00:00-03:00'
slug: sharing-models-between-rails-apps-part-1
tags:
- rails
- database
draft: false
---

_"Build a microservice and expose an API."_

That would be the quick answer if you ask any developer how to share business logic between applications.

Although it makes sense in many number of situations, it's not a good answer all the time.

My TL;DR for some situations is that you can organize your models logic as [ActiveSupport::Concerns](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html) (or plain Ruby Modules if you will) and move them out to a Rubygem that your applications can consume.

Notice that I am only speaking of Models, not Controllers or Views. To share those you would need a full blown Rails Engine instead. But many cases I've seen wanted to just share the business logic between applications while having separated front-end logic.

A small example of this scenario is the open sourced project I've been working on in the last few weeks. [Central](https://github.com/Codeminer42/cm42-central), which is a Pivotal Tracker/Trello alternative - if you're interested.

A few days ago I started a new project (for internal use only) that would query the same models as Central. I didn't want to implement HTTP APIs at this point, and the new application would itself have models with relationships to the models in Central (while treating them as read-only).

After a few refactorings, most of Central's models look like this one:

--- ruby
class Team < ActiveRecord::Base
  include Central::Support::TeamConcern::Associations
  include Central::Support::TeamConcern::Validations
  include Central::Support::TeamConcern::Scopes
  include Central::Support::TeamConcern::DomainValidator
  ...
end
```

And I have this dependency in the `Gemfile`:

--- ruby
gem 'central-support', github: 'Codeminer42/cm42-central-support', branch: 'master', require: 'central/support'
```

Whenever I change the concerns, I do a `bundle update central-support` in the projects (this is the one caveat to have in mind to avoid dealing with outdated models).

This was possible because most of those models were mature and stable and I will not be changing them often. I don't recommend exposing unstable dependencies (as gems or APIs, it doesn't matter), because this is a recipe for huge headaches of cascading breaking changes due to outdated dependencies that are changing too often.

> You should ONLY expose business logic that is reasonably stable (changes only every week or so).

The whole endeavor was to build a certain Rubygems structure, organize the original models into Concerns (which breaks no behavior), make sure specs are still passing, and them move the content (models and specs) over to the new Rubygems and make sure the specs pass there.

That's how I built a secondary open source dependency for Central, called [Central Support](https://github.com/Codeminer42/cm42-central-support). As many gems, it's main file [lib/central/support.rb](https://github.com/Codeminer42/cm42-central-support/blob/master/lib/central/support.rb) is nothing but a bunch of 'require's to load all the dependencies.

So I methodically organized logic as concerns, such as [lib/central/support/concerns/team_concern/association.rb](https://github.com/Codeminer42/cm42-central-support/blob/master/lib/central/support/concerns/team_concern/associations.rb), which is just the extraction of the Active Record associations from the 'Team' model.

Cut from Central, Paste into Support. When all relevant logic has been moved, I could move the entire Team model spec, mostly without any changes, and make it run. Every time I moved a bit, I `bundle update`d the gem and ran the main spec suite to make sure nothing broke.

And this is the difficult part: make a sandbox where those concerns could run and be tested.

To begin, I needed to build a minimal Rails app inside the spec folder, at `spec/support/rails_app`. And there I could put fake models that include the concerns I had just extracted from Central.

There is scarse documentation on how to do that, but I think you can just do `rails new` and start from there, or copy my `rails_app` folder for the bare minimum. My case is simpler because this gem is not to be general purpose, so I don't need to run it against different Rails versions, for example.

This internal test app must have a carefully crafted [`Gemfile`](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/support/rails_app/Gemfile):

--- ruby
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

You don't have to add the gems from the main [gemspec](https://github.com/Codeminer42/cm42-central-support/blob/master/central-support.gemspec). But you can remove the development dependencies that you would put in the gemspec and keep them in the test app Gemfile.

Now, from the [main `Gemfile`](https://github.com/Codeminer42/cm42-central-support/blob/master/Gemfile) you can do:

--- ruby
source 'https://rubygems.org'

eval_gemfile File.join(File.dirname(__FILE__), "spec/support/rails_app/Gemfile")
```

Most tutorials to build a Rubygem will add a line to load dependencies from the gemspec, but here we are replacing it for the test app's Gemfile. This is the manifest that will be loaded when we run `bundle exec rspec`, for example.

Speaking of which, this is the [`spec/rails_helper.rb`](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/rails_helper.rb):

--- ruby
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

To wrap your head around it:

* `bundle exec rspec` will load the main `Gemfile`
* the main `Gemfile` will load from the internal test app's `Gemfile`
* that internal test app's `Gemfile` will require the gemspec from `../../../..` and the development and test groups of gems (including Rspec, Factory Girl, etc)
* the gemspec will require the runtime dependencies such as "activesupport", "enumerize", etc
* finally, the `rails_helper.rb` listed above will load.

There at line 11, the runner will execute a command to `cd` into the internal test app's root folder and run the `db:schema:load`, therefore you need a `db/schema.rb` ready to load, as well as `config/database.yml`.

The [`spec/spec_helper.rb`](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/spec_helper.rb) is more standard, with optional configurations for test coverage, etc.

The models inside the internal test app are the important parts, because they are the means to include the extracted concerns into a runnable format. The ['spec/support/rails_app/app/models/team.rb'](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/support/rails_app/app/models/team.rb) is such an example:

--- ruby
class Team < ActiveRecord::Base
  include Central::Support::TeamConcern::Associations
  include Central::Support::TeamConcern::Validations
  include Central::Support::TeamConcern::Scopes
  include Central::Support::TeamConcern::DomainValidator
end
```

And with that, I could move the unmodified specs directly from the main project (Central), such as [`spec/central/support/team_spec.rb`](https://github.com/Codeminer42/cm42-central-support/blob/master/spec/central/support/team_spec.rb):

--- ruby
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

If you go back in the Central project, some commits back, you will find the very same file as [`spec/models/team_spec.rb`](https://github.com/Codeminer42/cm42-central/blob/a80eefadf233f4a8c5f88829836c872b199798cd/spec/models/team_spec.rb). And the main advantage of this approach is exactly being able to move most of the code out of the main project, together with their specs, into a dependency gem, without having to "rewrite" anything.

If I had to rewrite all or a big chunk of the code, it would've been a more expensive choice and I would probably have deferred it to another time and focus on more valuable features first.

This approach is not perfect but it was super cheap. I could move all the relevant business logic out of the main project without having to rewrite anything but a few wiring code. The new dependency gem received all the relevant bits and specs, and everything just runs.

So, if you have 2 or more Rails apps that could share the same models, this is how you can start it. Of course, there are always a lot of caveats to keep in mind.

In my case, the Central project is the one that can read-and-write to the database. My internal secondary app is just using the models as read-only. When 2 different apps write to the same database, you may have a number of conflicts to deal with.

This approach is useful if your secondary application is akin of an Administration dashboard, for example. You need to have some of the same associations, scopes, even validations for eventual editing, but it's limited to a few, controlled users.

This is also useful if you're doing data analysis, and again you can use the same associations, scopes, to build reports and dashboards. Essentially, if you need read-only access, this is a no-brainer.

In the [next article](http://www.akitaonrails.com/2016/10/03/sharing-models-between-rails-apps-part-2) I will explain how I wired a secondary application, using the central-support gem and dealing with 2 different databases at the same time.
