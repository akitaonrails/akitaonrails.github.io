---
title: How NOT to zero out your Pusher development quota
date: '2017-10-27T13:43:00-02:00'
slug: how-not-to-zero-out-your-pusher-development-quota
tags:
- beginner
- rubyonrails
- rails51
- pusher
- rspec
draft: false
---

If you're doing development with WebSockets (real-time notifications, real-time chat, etc), one of the best SaaS options out there is still [**Pusher**](pusher.com). It was always reliable.

For each application, you create it even offers you separated development, staging, production environments, with separated key/secret tokens.

One problem I stumbled upon these days is that I was quickly zero'ing out the free development environment message quota (200,000 messages a day). That's because all my team was using the same key and also the Continuous Integration server was doing live connections whenever it ran in the same environment. That can quickly consume all you have and block both your development and CI.

It's actually not a good practice to do live connections to external systems in testing situations. The tests can fail randomly for a number of reasons, so we should always mock those. But mocking a complex system (WebSockets and HTTP) like Pusher is not trivial.

Fortunately, I found this [Pusher Fake](https://github.com/tristandunn/pusher-fake). It basically implements all the necessary APIs and WebSocket endpoints to mimic Pusher and fool both server and js/client to communicate with it.

The idea is for your Rails app, in development mode, to fork a separated server process for the Pusher client to connect to. This gem is both a simple Pusher-clone server and a series of wrappers to load it up in your setup.

First things first.

In your application, you will have both a Ruby side Pusher client connection setup to push messages to a channel in the Pusher server. And a Javascript, client-side, Pusher instance mainly to subscribe to a channel in a WebSocket connection and receive messages.

First we need to setup the Ruby side. Usually it's in a `config/initializers/pusher.rb` configuration like this:

--- ruby
Pusher.app_id = ENV['PUSHER_APP']
Pusher.key    = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
Pusher.cluster = ENV['PUSHER_CLUSTER']
# never set Pusher.host or Pusher.port
```

Notice that I am using environment variables to hold the configuration. You should use something like the [figaro gem](https://github.com/laserlemon/figaro) or the [dotenv-rails gem](https://github.com/bkeepers/dotenv). For example:

--- yaml
PUSHER_APP: "xpto"
PUSHER_KEY: "abcd1234"
PUSHER_SECRET: "abcd1234"
PUSHER_CLUSTER: "us2"
```

At the very least you must have an application ID, a key, a secret, and a cluster name. All of these are provided by Pusher whenever you register a new application there.

Second, we need to setup the Javascript instance. Usually, you have something in the `assets/javascripts` directory like this:

--- javascript
// .js.erb example
window.pusher = new Pusher(<%= ENV['PUSHER_APP] %>, {
  cluster: <%= ENV['PUSHER_KEY'] %>,
  encrypted: <%= ENV['PUSHER_ENCRYPTED'] %>})
```

In a Chrome Development Console, you can inspect this instance by typing:

```
Pusher.instances[0]
```

This way you can make it's picking up the correct configurations for the connection and also do debug problems.

The dependencies are the pusher gem in your `Gemfile` and the javascript client.

--- ruby
# Gemfile
gem 'pusher'
```

In the case of the javascript file you can either add it to your project and rely on [Webpacker](http://www.akitaonrails.com/2017/10/24/beginner-trying-out-rails-5-1-x):

```
yarn add pusher
```

Then, in your ES6 javascript file, you can do:

--- javascript
const Pusher = require('pusher-js');
```

Or you can link it directly in your layout:

--- html
<script src="https://js.pusher.com/4.2/pusher.min.js"></script>
```

For more information on the Pusher-js client, read it's [README file](https://github.com/pusher/pusher-js).

## Adding Pusher Fake

At this point, you should be able to connect to the real Pusher account and see the real-time magic happening.

You're also already consuming the free quota you have available in your development environment on Pusher. For most people, this should suffice.

But we want to NOT connect to Pusher over the internet and keep everything local for development and testing. Let's start by adding the [Pusher Fake](https://github.com/tristandunn/pusher-fake) to our `Gemfile`:

--- ruby
group :development, :test do
  gem 'pusher-fake'
end
```

Now, this is where the Pusher Fake setup can get convoluted if you don't understand what's happening. As I said before, PusherFake must fork a new process to load a local server that mimics Pusher.

To load it up you must point to the local server. Remember our `config/initializers/pusher.rb` ? We just need to require a simple file like this:

--- ruby
Pusher.app_id = ENV['PUSHER_APP']
Pusher.key    = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
Pusher.cluster = ENV['PUSHER_CLUSTER']

if Rails.env.development?
  require "pusher-fake/support/base"
end
```

This alone presents a LOT of problems if you're not careful. This `require` will **fork** a new process. If you're using a single-process web server like Webrick or Thin, you should be ok. If you're using Puma, Unicorn, or Passenger with a maximum of just one process, you should also be good. But if you load a web server that itself forks new processes, you will have trouble.

In practice, I'd rather load the Pusher Fake server separately, in stand-alone more. Fortunately it provides a command line command to start it up. And it's good practice to setup that in a `Procfile.dev` file and use [foreman](https://github.com/ddollar/foreman) to start everything for you. The `Procfile.dev` looks like this:

```
web: bundle exec rails s -p 3000
db: postgres -D /usr/local/var/postgres
redis: redis-server /usr/local/etc/redis.conf
mailcatcher: mailcatcher -f
pusherfake: pusher-fake -i ${PUSHER_APP:-xpto} --socket-host 0.0.0.0 --socket-port ${PUSHER_WS_PORT:-45449} --web-host 0.0.0.0 --web-port ${PUSHER_PORT:-8888} -k ${PUSHER_KEY:-abcd1234} -s ${PUSHER_SECRET:-abcd1234}
```

As a bonus, look how I configure other services such as PostgreSQL, Redis, etc.

If you didn't know, you can use `${VARIABLE_NAME:-default_value}` to use an environment variable or have a default value in case the variable doesn't exist. This means that your environment variable configured with Figaro or Dotenv must have the same values.

--- yaml
PUSHER_APP: "xpto"
PUSHER_KEY: "abcd1234"
PUSHER_SECRET: "abcd1234"
PUSHER_CLUSTER: "us2"
PUSHER_HOST: "127.0.0.1"
PUSHER_PORT: "8888"
PUSHER_WS_HOST: "127.0.0.1"
PUSHER_WS_PORT: "45449"
```

Now your `config/initializers/pusher.rb` should be something like this:

--- ruby
Pusher.app_id = ENV['PUSHER_APP']
Pusher.key    = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
Pusher.cluster = ENV['PUSHER_CLUSTER']

if Rails.env.development?
  Pusher.host = ENV['PUSHER_HOST']
  Pusher.port = ENV['PUSHER_PORT']
end
```

And Pusher-js config somewhere in your `app/assets/javascripts/` directory will resemble something like this:

--- javascript
<% if defined?(PusherFake) %>
    <% if Rails.env.test? %>
    var pusher = <%= PusherFake.javascript(cluster: ENV["PUSHER_CLUSTER"]) %>
    <% else %>
    window.pusher = new Pusher(<%= ENV['PUSHER_KEY'] %>, {
      cluster: <%= ENV['PUSHER_CLUSTER'] %>,
      wsHost: <%= ENV['PUSHER_WS_HOST'] %>,
      wsPort: <%= ENV['PUSHER_WS_PORT'] %>,
      encrypted: <%= ENV['PUSHER_ENCRYPTED'] %>})    
    <% end %>
<% else %>
    window.pusher = new Pusher(<%= ENV['PUSHER_KEY'] %>, {
      cluster: <%= ENV['PUSHER_CLUSTER'] %>,
      encrypted: <%= ENV['PUSHER_ENCRYPTED'] %>})
<% end %>
```

Remember that this is a Javascript+ERB file, so we can fetch the same environment variables for the configuration.

Now, whenever you `foreman start -f Procfile.dev -p 3000` it will load the Pusher Fake server with the proper development configurations and both your ruby server-side and javascript client-side should connect to it without any problems.

Also, notice the `if Rails.env.test?` bit. This is for your RSpec test suite. In the case of the testing environment, we won't load the fake server manually, instead, we will create something like `spec/support/pusher-fake.rb` with:

--- ruby
require "pusher-fake/support/rspec"
```

And that's it. The `PusherFake.javascript` will define default WebSocket connection configuration and the `require` above will both fork the fake server and set Rspec to clean the channels on each test run (through `PusherFake::Channel.reset`).

This way your testing environment will also avoid connecting to the external, real, Pusher server.

The key to all this are the environment variables. You must make sure that every piece is loading the same configuration, otherwise you will have the fake server binding to a different port than the Pusher-js is connecting to, and you will have errors. Debug with care.

Most importantly: if you did it all correctly, you are now independent of the real Pusher server for development and testing environments, you won't ever reach any quota limits, and your team and your CI will be able to work uninterruptedly, with a deterministic behavior.
