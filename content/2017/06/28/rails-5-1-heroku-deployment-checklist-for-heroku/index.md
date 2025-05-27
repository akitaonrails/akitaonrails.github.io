---
title: Rails 5.1  Deployment Checklist for Heroku
date: '2017-06-28T15:12:00-03:00'
slug: rails-5-1-heroku-deployment-checklist-for-heroku
tags:
- learning
- rails
- heroku
- postgresql
- letsencrypt
- cdn
draft: false
---

I released [THE CONF](http://www.theconf.club) yesterday. I hope you enjoy the conference program and take advantage of the limited early-bird discount!

Anyway, the website itself is super simple. A single page site. I chose to use Rails 5.1 as the site structure because it takes care of all the stuff I'd have to add manually in any other framework. Specially now that that it brings native Yarn and Webpack support it's a breeze to use by any competent front-end developer.

But even with the many built-in niceties, a full production setup still requires extra steps that most beginners will not know. So I decided to compile a small checklist of things you must take care of before deploying to production. It's not an extensive and complete list for all use cases, but this should be enough for most small cases.

* [Setting up the project](#setup)
* [Adding a CDN and configuring CORS support](#cdn) (to be able to load fonts for example)
* [Adding Memcached](#cache)

<a name="setup"></a>

## Setting up the project

One thing that most people forget, even experienced developers is that the `rails new` command used to bootstrap the initial project structure accepts many option flags. Instead of having to manually tweak files later, you can start like this:

```
rails new your_project \
--database=postgresql \
--webpack=react \
--skip-action-cable \
--skip-coffee
--skip-turbolinks
```

If you're building with React or another full-featured javascript framework, you will probably want to skip Turbolinks. Otherwise, if it's a simple site, do use [Turbolinks](https://sevos.io/2017/02/27/turbolinks-lifecycle-explained.html).

Start using Postgresql from the get go, don't use Sqlite3.

Skip Action Cable. Prefer a real solution such as [Pusher.com](https://pusher.com/). If you really need something done in-house, consider something like my solution with Elixir, the [Ex Pusher Lite](http://expusherlite.cm42.io/). Take this recommendation with a grain of salt, of course, for small things Action Cable is more than enough. I may write another post just elaborating on this point if people indicate they want to in the comments section.

Anyway, I digress. Make sure you have 2 boot files, first the canonical `Procfile` to be used by Heroku in production:

```
web: bin/rails server -p $PORT -b 0.0.0.0
```

Second, a `Procfile.dev` to be used only in your development environment:

```
web: ./bin/rails server
webpacker: ./bin/webpack-dev-server
```

This is how you fire up the webpack server that will compile your assets in real-time during development. You need to also remember to run these two dependency commands now:

```
yarn install
bundle install
```

Install javascript dependencies with `yarn add [package]` and that's it! In production you don't use the webpack server (which is why we don't add it to the production `Procfile`), instead Heroku automatically detects the [webpacker](https://github.com/rails/webpacker) gem then it installs the nodejs buildpack, runs `yarn install` for you and when `rails assets:precompile` runs it will also execute `yarn run` which will pre-compile all the assets (javascript, stylesheets, images) with the proper fingerprinting for cache busting and everything else we are used to in the normal Rails Asset Pipeline.

So, for Heroku, you basically don't have to do anything. And in a custom deployment server you just need to remember to run the `assets:precompile` task and have it do everything for you.

<a name="cdn"></a>

### Adding a CDN and configuring CORS

This is really super easy. There is no reason why anyone wouldn't add a CDN to any website. Please just do it.

Open your AWS Management Console and [open CloudFront](https://console.aws.amazon.com/cloudfront/). From there click on "Create Distribution" and just follow the defaults in the Wizard. The requirement is that you MUST know that domain and sub-domain you want to point to (for example "www.theconf.club") in the "Origin Domain Name" field.

The only customization you MUST do is to change the ["Forward Headers"](http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/header-caching.html#header-caching-web-cors) option to "Whitelist" in the "Default Cache Behavior Settings". Then you need to add "Origin", "Access-Control-Request-Headers", and "Access-Control-Request-Method" to the Whitelist. And that's it, now your distribution is CORS enabled.

It will take some time to create (it has to configure many data centers around the world), but you will end up with a URL representing your distribution, something like `doz7rtw2u3wg4.cloudfront.net`. I recommend you add it as a Heroku environment variable like this:

```
heroku config:set CDN_URL=doz7rtw2u3wg4.cloudfront.net
```

Now, edit your `config/environments/production.rb` and add the following:

--- ruby
config.action_controller.asset_host = ENV['CDN_URL'] if ENV['CDN_URL']
```

To actually use the CDN you must declare every asset you use across your view templates using Rails View Helpers such as `image_tag`, `asset_path`, `javascript_pack_tag`, `stylesheed_pack_tag`, `stylesheet_link_tag`, etc. The Rails bootstrap will already create layout template with such helpers, you just need to follow them.

When webpack runs, it will generate all static, optimized and pre-compiled assets in the `public/packs` with a manifest file declaring the full URL pointing to the CDN. For example, if I fetch the `/app/public/packs/manifest.json` from the Heroku dyno directly, I will get something like this:

```
{
  "Roboto-Bold.woff": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Bold-eed9aab5449cc9c8430d7d258108f602.woff",
  "Roboto-Bold.woff2": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Bold-c0f1e4a4fdfb8048c72e86aadb2a247d.woff2",
  "Roboto-Light.woff": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Light-ea36cd9a0e9eee97012a67b8a4570d7b.woff",
  "Roboto-Light.woff2": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Light-3c37aa69cd77e6a53a067170fa8fe2e9.woff2",
  "Roboto-Medium.woff": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Medium-cf4d60bc0b1d4b2314085919a00e1724.woff",
  "Roboto-Medium.woff2": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Medium-1561b424aaef2f704bbd89155b3ce514.woff2",
  "Roboto-Regular.woff": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Regular-3cf6adf61054c328b1b0ddcd8f9ce24d.woff",
  "Roboto-Regular.woff2": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Regular-5136cbe62a63604402f2fedb97f246f8.woff2",
  "Roboto-Thin.woff": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Thin-44b78f142603eb69f593ed4002ed7a4a.woff",
  "Roboto-Thin.woff2": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Thin-1f35e6a11d27d2e10d28946d42332dc5.woff2",
  "application.css": "//doz7rtw2u3wg4.cloudfront.net/packs/application-09b53ce9ca3dd595ee99.css",
  "application.css.map": "//doz7rtw2u3wg4.cloudfront.net/packs/application-09b53ce9ca3dd595ee99.css.map",
  "application.js": "//doz7rtw2u3wg4.cloudfront.net/packs/application-799300612ff6d6595198.js",
  "application.js.map": "//doz7rtw2u3wg4.cloudfront.net/packs/application-799300612ff6d6595198.js.map",
  "home_page.js": "//doz7rtw2u3wg4.cloudfront.net/packs/home_page-ff3b49407a1d01592ad5.js",
  "home_page.js.map": "//doz7rtw2u3wg4.cloudfront.net/packs/home_page-ff3b49407a1d01592ad5.js.map"
}
```

So, if for some reason I had to create a new CDN distribution, you have to remember to update the `CDN_URL` variable on Heroku and redeploy your app so it regenerates the assets and this manifest file. It will just those URLs when rendering the final HTMLs.

When a user opens your site, it will receive the HTML with URLs pointing to the CDN. The very first time it won't have any cached assets, so it will ask your site for them. Your site must return the assets WITH the correct CORSs headers so the CDN caches them with the headers and forward those headers to the browser. The browser needs those headers because it will open from domain `www.theconf.club`, for example, but fonts are loading from `doz7rtw2u3wg4.cloudfront.net`, so it would raise a security warning and not load the fonts because they are in different domains. Hence the CORS headers the font provides indicating that they are safe to load.

For your Rails app to return the proper headers, you need to add the `rack-cors` gem to your Gemfile. Then you must add a new configuration file at `config/initializers/rack-cors.rb` with:

--- ruby
if defined? Rack::Cors
  Rails.configuration.middleware.insert_before 0, Rack::Cors do
    allow do
      origins %w[
        https://theconf.club
        http://theconf.club
        https://www.theconf.club
        http://www.theconf.club
        https://theconf.herokuapp.com
        http://theconf.herokuapp.com
      ]
      resource '/assets/*'
    end
  end
end
```

When you deploy, you know it's working correctly when you Curl an asset and it returns the Access-* headers like this:

```
$ curl -I -s -X GET -H "Origin: www.theconf.club" http://www.theconf.club/packs/Roboto-Regular-5136cbe62a63604402f2fedb97f246f8.woff2
HTTP/1.1 200 OK
Server: Cowboy
Date: Wed, 28 Jun 2017 17:44:41 GMT
Connection: keep-alive
Access-Control-Allow-Origin: www.theconf.club
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Expose-Headers: 
Access-Control-Max-Age: 1728000
Access-Control-Allow-Credentials: true
Last-Modified: Wed, 28 Jun 2017 17:06:03 GMT
Content-Type: application/font-woff2
Cache-Control: public, max-age=2592000
Vary: Origin
Content-Length: 64832
Via: 1.1 vegur
```

And if everything above is already in place, you should be able to see the headers being forwarded through the CDN, like this:

```
$ curl -I -s -X GET -H "Origin: www.theconf.club" http://doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Regular-5136cbe62a63604402f2fedb97f246f8.woff2
HTTP/1.1 200 OK
Content-Type: application/font-woff2
Content-Length: 64832
Connection: keep-alive
Server: Cowboy
Date: Wed, 28 Jun 2017 17:45:18 GMT
Access-Control-Allow-Origin: www.theconf.club
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Expose-Headers: 
Access-Control-Max-Age: 1728000
Access-Control-Allow-Credentials: true
Last-Modified: Wed, 28 Jun 2017 17:06:03 GMT
Cache-Control: public, max-age=2592000
Via: 1.1 vegur, 1.1 86e9abdb4c15b9d3a542f9b93245e87e.cloudfront.net (CloudFront)
Vary: Origin
X-Cache: Miss from cloudfront
X-Amz-Cf-Id: tVkZ41RRr66iBT6atWTO_oeTY_jG0zCBFuXU8bKyClZDQ8kl-hDegA==
```

A CDN is the secret sauce that allows any content-based website to scale way beyond what your server can provide. It's a huge cost-saving and it also makes for a way more smooth user experience for your users.

One last caveat. The many Rails View Helpers such as `image_tag` allows you to add the image file name without an extension in development and it will correctly find the image. But on the server it will fail to render the template this way. As a rule of thumb **ALWAYS** fill in the entire filename and extension, for example `image_tag("logo.png")` instead of just `image_tag("logo")`.

You can see how this fails if you open a console in Heroku and check out how it fails to derive the full image URL:

```
$ heroku run rails c                                                                                                                  
Running rails c on ⬢ theconf... up, run.8271 (Hobby)
Loading production environment (Rails 5.1.2)

irb(main):001:0> ActionController::Base.helpers.asset_path("icon-goals")
Sprockets::Rails::Helper::AssetNotFound: The asset "icon-goals" is not present in the asset pipeline.
    from (irb):1

irb(main):002:0> ActionController::Base.helpers.asset_path("icon-goals.png")
=> "//d134ipy19a646x.cloudfront.net/assets/icon-goals-b969b3b7325d33ad85a88dbb5b894832909ed738eea9964b9cf535646b93674b.png"
```

<a name="cache"></a>

### Adding Memcached

Talking about cache is always a complicated thing. Which is the reason many people avoid even trying. Even though you can go really crazy with super granular configurations such as using [Russian Doll Caching](http://edgeguides.rubyonrails.org/caching_with_rails.html#russian-doll-caching), just adding cache in a few spots can greatly benefit you. And it's super easy to boot.

The first thing to do is add [Memcachier](https://devcenter.heroku.com/articles/memcachier) to your Heroku application. It has a free-tier and for most small apps it should be enough.

Configuration is also trivial. Start by adding the following gems to your `Gemfile`:

--- ruby
group :production do
  gem 'rack-cors', require: 'rack/cors'
  gem 'rack-cache'
  gem 'dalli'
  gem 'kgio'
  gem 'memcachier'
end
```

Now you must edit your `config/environments/production.rb` like this:

--- ruby
config.cache_store = :dalli_store

client = Dalli::Client.new((ENV["MEMCACHIER_SERVERS"] || "").split(","),
                           :username => ENV["MEMCACHIER_USERNAME"],
                           :password => ENV["MEMCACHIER_PASSWORD"],
                           :failover => true,
                           :socket_timeout => 1.5,
                           :socket_failure_delay => 0.2,
                           :value_max_bytes => 10485760)
config.action_dispatch.rack_cache = {
  :metastore    => client,
  :entitystore  => client
}
```

Now, let's say you have a block in your template that requires a bunch of records from your database. But you know that those records barely change. What can you do? One alternative is cache the ActiveRecord query entirely like this:

--- ruby
class HomePageController < ApplicationController
  def index
    @selected_proposals = Rails.cache.fetch('selected_proposals', expires_in: 1.day) do
      Proposal.includes(:authors).where(selected: true).to_a
    end
  end
end
```

The `#to_a` is necessary because ActiveRecord queries are lazy. The `#to_a` forces it to fetch and it will be cached. Next time, it will not touch the database for an entire day!

I could also have added a `cache do ... end` block in the template itself. There are many options. Point is that it's not as difficult as most people would think.

What makes caching difficult is adding expiration logic. And the rule of thumb is: never try to manually expire any cache. Just change the lookup key for something else and let the old data just die (memcached will take care of getting rid of unused old data).

You really want to read the [Rails Guides on Caching](http://edgeguides.rubyonrails.org/caching_with_rails.html). It really is not as difficult as you think and you can cache only the few snippets where you know is performance-sensitive and leave the other parts that are highly dynamic and you're unsure how to properly cache.

But as it's super cheap, just use it right now.

<a name="ssl"></a>

### Adding SSL support

If you have any security sensitive transaction going on (ex. purchases) you want to use SSL. Again, many people avoid it because it's usually difficult to even understand how to properly get a certificate.

[Let's Encrypt](https://letsencrypt.org/) made the process super trivial. Kudos to them! And even better: it's free! So, you don't have any excuses to not have SSL.

And over Heroku, it's [even easier](https://devcenter.heroku.com/articles/automated-certificate-management)! 

> ACM (Automated Certificate Management) is enabled by default for all applications created after March 21, 2017 that are running on Hobby or Professional dynos. The following steps are for applications currently running on Free dynos, and for applications created before that date.

On the Free Tier Dynos, this is what you do:

```
heroku certs:auto:enable
```

Check status with `heroku certs:auto`.

Done, there is no step 2.

We used to have to use the complicated gem [letsencrypt-rails-heroku](https://github.com/pixielabs/letsencrypt-rails-heroku), but now it's just too easy.

### Conclusion

I believe this cover the very basics of stuff you should be doing before deploying your small app to Heroku. For larger apps there are many more concerns that are beyond the scope of this post.

If you remember about more tips and tricks, please share in the comments section below.
