---
title: Small Experiment with Rails over JRuby 9.x on Heroku
date: '2016-06-03T18:12:00-03:00'
slug: small-experiment-with-rails-over-jruby-9-x-on-heroku
tags:
- jruby
- heroku
draft: false
---

After playing around with languages different than Ruby (such as [Elixir](/elixir) or [Crystal](/crystal)), it was time to go back to Ruby and see how JRuby is performing nowadays.

JRuby always pursued the goal of being a competent MRI replacement. If you have not followed what's going on, JRuby changed version schemes when they switched from the 1.7 series to the 9.x series. You should read [this blog post](blog post ) that explains it.

In summary, if you want MRI 2.2 compatibility you must use JRuby 9.0.x and if you want MRI 2.3 compatibility you must use JRuby 9.1.x series. The most current release being 9.1.2.0. Anything prior to that you can refer to this [table of versions](https://devcenter.heroku.com/articles/ruby-support#ruby-versions) from Heroku's documentation.

There are important recommendations as well:

* Ideally you should use Rails 4.2. Try to be at least above 4.0, and you can turn on `config.threadsafe!` by default in the "config/environments/production.rb" file. To understand this subject, refer to [Tenderlove's excellent explanation](http://tenderlovemaking.com/2012/06/18/removing-config-threadsafe.html).

* If you're deploying to Heroku, don't bother trying the free or 1X dyno, which only gives you 512Mb of RAM. While it is enough for most small Rails applications (even with 2 or 3 Puma concurrent workers), I found that even the smallest apps can easily go above that. So you must consider at least the 2X dyno. In any server configuration, always consider more than 1Gb of RAM.

### Gems

There are several gems with C extensions that just won't work. Some of them have drop-in replacements, some don't. You should refer to [their Wiki](https://github.com/jruby/jruby/wiki/C-Extension-Alternatives) for a list of cases.

In my small sample application - which is nothing more than a content website backed by a Postgresql database, ActiveAdmin to manage content, RMagick + Paperclip (yes, it's an old app) to handle image upload and resizing, there was not a lot to change. The important bits of my "Gemfile" end up looking like this:

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

Notice how I paired gems for the `:ruby` and `:jruby` platforms. After doing this change and `bundle install` everything, I ran my Rspec suite and - fortunatelly - they all passed on the first run without any further changes! Your mileage will vary depending on the complexity of your application, so have your tests ready.

### Puma

In the case of Puma, the configuration is a bit trickier, mine looks like this:

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

It's a bit different than you might find in other documentations. The important part is to turn off workers and preload_app when loading over JRuby. It will complain and crash. On my original MRI deploy I am using a small 1X dyno and I can leave `WEB_CONCURRENCY=2` and `RAILS_MAX_THREADS=5` but on the JRuby deploy I set it to `WEB_CONCURRENCY=1` (to turn off workers) and `RAILS_MAX_THREADS=16` (because I am assuming JRuby can handle more multithreading than MRI).

Another important bit, most people still assume that MRI can't take advantage of native parallel threads at all because of the dared GIL (Global Interpreter Lock), but this is not entirely true. MRI Ruby can parallelize threads on I/O waits. So, if a part of your app is waiting for database to process and return rows, for example, another thread can take over and do something else, in parallel. It's not totally multi-threaded, but it can do some concurrency so setting a small amount of threads for Puma might help a bit.

Do not forget to set the Pool size to at least the same number of `RAILS_MAX_THREADS`. You can either use the `config/database.yml` for Rails 4.1+ or add an initializer. Follow [Heroku's documentation](https://devcenter.heroku.com/articles/concurrency-and-database-connections#threaded-servers) on how to do so.

### Initial Benchmarks

So, I was able to successfully deploy a secondary JRuby version of my original MRI-based Rails app.

The original app is still in a Hobby Dyno, sized at 512Mb of RAM. The secondary app needed a Standard 1X Dyno, sized at 1Gb of RAM.

The app itself is super simple and as I'm using caching - [as you always should!](http://www.akitaonrails.com/2015/05/20/dynamic-site-as-fast-as-a-static-generated-one-with-raptor) -, the response time is very low, on the tens of milliseconds.

I tried to use the [Boom](https://github.com/rakyll/boom) tool to benchmark the requests. I did a lot of warming up on the JRuby version, running the benchmarks multiple times and even using Loader.io for added pressure.

I am running this test:

```
$ boom -n 200 -c 50 http://foo-my-site/
```

The MRI version performs like this:

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

And the JRuby version performs like this:

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

In general, I'd say that they are around the same. As this is not a particularly CPU-intensive processing, and most of the time is spent going through the Rails stack and hitting Memcachier to pull back the same content all the time, maybe it's only fair to expect similar results.

On the other hand, I'm not sure I'm using the tool in the best way possible. The log says something like this for every request:

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

The times reported by the Boom tool are much larger (2 seconds?) than the processing times in the logs (10ms?). Even considering some overhead for the router and so on, still it's a big difference, I wonder if it's being queued for too long because the app is not being able to respond more of the concurrent requests.

The amount of requests divided by the number of concurrent connections will bring the overall performance and throughput down if you increase it too much, I wasn't able to go too much above 14 rpm with this configuration, though.

If you have more experience with http benchmarking and you can spot something wrong I am doing here, please let me know in the comments section below.

### Conclusion

JRuby continues to evolve, and you might benefit if you already have a large set of Dynos of large servers around. I wouldn't recommend it for small to medium applications.

I've seen many orders of magnitude improvements in specific use cases (I believe it was a very high traffic API endpoint). This particular case I tested is probably not its sweet spot and changing from MRI to JRuby didn't give me too much advantage, so in this case I would recommend sticking to MRI.

Startup time is still an issue. There is an entry in [their Wiki](https://github.com/jruby/jruby/wiki/Improving-startup-time) giving some recommendations, but even in the Heroku deploy I ended up having R10 errors (Boot Timeout) every once in a while for this small app.

I didn't try increasing the dynos to the [Performance tier](https://blog.heroku.com/archives/2015/8/20/introducing-improved-performance-dynos) introduced last year. I would bet that JRuby would be better at those and more able to leverage the extra power of having from 2.5GB up to 14GB if you have really big traffic (on the order of thousands or tens of thousands of requests per minute). With MRI the recommendation would be using small-ish dynos (2X or at most Performance-M dynos) and scale horizontally. With JRuby you could have less dynos with larger sizes (Performance-L, for example). Again, depends on your case.

Don't take the benchmarks above as "facts" to generalize everywhere, they are just there to give you a notion of an specific use case of mine. Your mileage will vary, so you must test it out yourself.

Another use case (that I did not test) is not to just "port" an MRI app to JRuby but leverage JRuby's unique strenghts as [this post](https://blog.heroku.com/archives/2016/5/24/reactive_ruby_building_real_time_apps_with_jruby_and_ratpack) from Heroku explains, in the case of using JRuby with Ratpack, for example.

All in all, JRuby is still a great project to experiment. MRI itself came a long way as well and 2.3.1 is not bad at all. Most of the time it's down to your entire architecture choices, not just the language. If you didn't try it yet, you definitely should. It "just works".
