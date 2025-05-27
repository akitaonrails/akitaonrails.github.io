---
title: Dynamic Site as fast as a Static Generated One with Raptor
date: '2015-05-20T11:51:00-03:00'
slug: dynamic-site-as-fast-as-a-static-generated-one-with-raptor
tags:
- learning
- passenger
- rails
- english
draft: false
---

If you ask what's the best way to do a fast content site, many people will point you to [Jekyll](http://jekyllrb.com) or a similar tool.

The concept is simple: nothing will be faster than a statically generated website. But writing a complete website statically is not viable because you will be repeating HTML code for headers, footers, sidebars, and more across all pages. But current tools such as Markdown, SASS, Sprockets (or Gulp/Grunt tasks if you're using a Javascript clone of Jekyll) will make it a whole lot easier to properly structure, organize and separate concerns on what are reusable snippets and what is just content. Then it will "compile" the content and the snippets into complete HTML pages ready to just transfer to any web server.

Because it's already static files, the web server doesn't need to reverse proxy to an application server or have any other kind of dynamic processing, just serve the files as it would serve any other asset. And this is **Fast**.

If you're doing a personal blog, a simple and temporary hotsite, something that you know won't change too much, and if you're a developer, this is possibly the way to go: fire up Jekyll, write your content in Markdown, compile, copy assets to S3 or Github Pages, and you're up.

Problem is: what if I want more from my content web site? What if I don't want to have developer tools around to compile my pages and I just want a plain simple Administrative section to edit my content? What it I want to mix a static content section with my dynamic web application (an ecommerce, social network, etc)?

Then I have to use Rails and Rails is very slow compared to a static web site. Or is it?

![Static vs Dynamic](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/493/static-vs-dynamic.png)

I've fired up [Blitz.io](https://www.blitz.io/) to a small Heroku website (Free Plan, 1 dyno) with Heroku Postgresql and [Memcached Cloud](https://redislabs.com/memcached-cloud). The [code for this test web](https://github.com/akitaonrails/static_site_demo) site is on my Github account and it's a plain Rails 4.2 project with Active Admin and all the perks of having a Rails based code structure.

So, the graphs on the left side of the image is Blitz.io hitting hard on the poor small Heroku dyno more than 7,000 times in 60 seconds and getting a response of 12ms in average for the <tt>404.html</tt> static page. This is quite good and it's the fastest you will get from a single 512Mb web dyno. More importantly: it keeps quite consistent even increasing the number of concurrent simulated users hitting the same page without ever timing out or erroring out.

Now, the surprise: the graphs on the right side is content generated in Rails and served through Raptor (Passenger 5). It's the same Blitz.io default configuration running almost 7,300 requests within 60 seconds, increasing from 1 up to 250 concurrent simulated users and receiving no timeouts or errors with an average response time of around **20ms**!

That's not too shabby! More importantly is the similarity between the 2 sets of graphs: it means that response time does not increase with the added concurrent users and more simultaneous requests over time, so it means that this setup scales!

Yes, Rails can Scale!

## How is it done?

So, this is obviously a very specific situation: replacing a statically generated website with a dynamic web app that outputs static content. There are different moving parts to consider.

The very first trick to consider: generate proper Etags:

```ruby
class PagesController < ApplicationController
  def index
    @pages = fetch_resources
    if stale?(resources_etag(@pages))
      respond_to do |wants|
        wants.html
      end
    end
  end

  def show
    @page = fetch_resource(params[:id])
    fresh_when last_modified: @page.updated_at.utc,
      etag: "#{deploy_id}/#{@page.cache_key}",
      public: true
  end
...
end
```

This is what's done in the <tt>PagesController</tt>. [Learn more](http://guides.rubyonrails.org/caching_with_rails.html#conditional-get-support) about the <tt>#stale?</tt> and <tt>#fresh_when</tt> methods that set proper <tt>Cache-Control</tt>, <tt>Last-Modified</tt>, <tt>Age</tt> and <tt>Etag</tt> HTTP headers.

The idea is simple: if the generated content does not change between requests, the application does not have to process all the views and helpers and models to output the very same HTML again. Instead, it will simply stop processing at that point and return a simple <tt>HTTP 304 Not Modified</tt> header to the browser.

Now, even if this works, each user will have to receive a complete HTTP 200 response with the generated HTML. So if 250 users connect, at least 250 HTML responses will have to be generated so the next request will get only the HTTP 304 response. That's where <tt>Passenger 5 (a.k.a. Raptor)</tt> kicks in!

It has an internal small cache to keep tabs on the content and cache control headers. So, after the 1st user requests the page, it gets cached. The next users and requests will get the stale content from the cache instead of having Rails regenerate it. In practice it's almost as if Passenger is serving a static file which is why performance and throughput behaviors are quite similar in the graphs.

There is another problem: to check if a content is fresh or not, it needs to check the source content itself: the database data. And fetching from the database to check it is slow and doesn't scale as well.

One workaround is to cache this information in a faster storage, such as Memcached:

```ruby
class PagesController < ApplicationController
...
  private

  def fetch_resources
    cache_key = "#{deploy_id}/pages/limit/10"
    Rails.cache.fetch(cache_key, expires_in: 1.day) { 
	  Page.recent.limit(10)
	}
  end

  def resources_etag(pages)
    recent_updated_at = pages.pluck(:updated_at).max || Time.current
    etag = "#{deploy_id}/pages_index/#{recent_updated_at.iso8601}"
    { last_modified: recent_updated_at.utc, etag: etag, public: true }
  end

  def fetch_resource(id)
    cache_key = "#{deploy_id}/page/#{id}"
    Rails.cache.fetch(cache_key, expires_in: 1.hour) {
	  Page.friendly.find(id)
	}
  end
end
```

This is what those methods do in the <tt>PagesController</tt>. The <tt>index</tt> action is trickier as it's just a list of pages. I can cache the 10 most recent items. I can generate the etag based on the item that was most recently updated. I can combine those two. It depends on how often you change your content (most static web sites don't add new content all the time, if you're a heavily updated website you can decrease the expiration time for 1 hour instead of 1 day, and so on).

For the <tt>show</tt> action it's more straightforward as I can just cache the single resource for an hour or any range of time and that's it. Again, it depends on how often you change this kind of content.

Now, the controller won't hit the database all the time. It will hit Memcached instead. Because Memcached Cloud or Memcachier are external services, it's out of the Heroku dyno premises so it will have network overhead that can go all the way to 30ms or more. Your mileage may vary.

After the content is fetched from the cache, it generates the ETags to compare with what the client sent through the <tt>If-None-Match</tt> header. Notice that I'm customizing the etag with something called <tt>deploy_id</tt>. This is a method defined in the <tt>ApplicationController</tt> like this:

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

    def deploy_id
      if Rails.env.production?
        ENV['DEPLOY_ID'] || '0'
      else
        rand
      end
    end
end
```

It's an environment variable. Because the Etag only checks if the content changed, what if I change my stylesheets or anything about the layout or HTML structure? Then the client won't receive this change. Because I only make those changes through a new deployment to Heroku I can also manually change it (or add a Capistrano task, or something similar for automation). Then all Etags will change at once, forcing Rails to generate the new pages and cache them again. This is the fastest way if you want to invalidate all the cache at once.

The important part is for Passenger to receive a <tt>Cache-Control: public</tt> to kick in its internal cache. Beware that you can't cache everything, only what's publicly visible. If you have authenticated areas, you don't want to cache those as the content will probably be different for different users. In that case you will need to know about Fragment Caching and other techniques to cache snippets within the logged in pages.

The best thing is that you can rely on Rails alone to serve both blazing fast public pages that don't need a separated pipeline to generate static files and the usual dynamic stuff you love to do.

## Extras

I won't add details here because the code I made available on Github already shows how it's done but this is the extra stuff I'd like to highlight:

* [ActiveAdmin](http://activeadmin.info) is the best administration engine out there for your projects, use it.
* [Bourbon](http://bourbon.io) together with Neat and Bitters is the best option to fast and clean stylesheets. Avoid Bootstrap if you can.
* [FriendlyId](https://github.com/norman/friendly_id) is still the best way to generate slugs for your resources, don't write yet another slug generator from scratch.
* [Redcarpet](https://github.com/vmg/redcarpet) is still the best Markdown processor.
* [Rouge](https://github.com/jneen/rouge) is the surprise: it's far better than the good old CodeRay or Python's Pygments for code syntax highlighting. It's compatible with Pygments CSS themes and it's easily pluggable with Redcarpet, making it a nice combo.

## Conclusion

Making a fast web site is a matter of understanding the basics of the HTTP protocol and taking advantage of web servers' ability to deliver cached content. The more you cache, the better!

There are more to come from the Passenger camp, [they're researching](https://blog.phusion.nl/2015/01/06/researching-http-caching-optimization/) ways to cache content based on user's profiles. Serving speficic cached content for anonymous users and different content for Administrators, for example. You should check it out and contribute if you can.

You can also serve a generic cached page through this method and use Javascript to fetch small snippets to fill in specific user content as well, such as Notification badges or something similar, so you can still take advantage of a full page cache and have some user-specific dynamic content.

And before someone asks, yes I tried Puma with Rack::Cache in the Web App. In the Blitz.io test, it blows up fast, timing out and erroring out all request after a while as its request queue blow up. Seems like the time to fetch from Memcached over the network is too much for it's queues to hold and getting all the way down to Rack::Cache was not fast enough as well. I've replaced Puma for Raptor and took off Rack::Cache and the results were dramatically better in this particular scenario. But by all means, more tests and data would be welcome.

Now it's up to your creativity: once you get this concept you can bend it to your needs. Do you have any other suggestion or technique? Comment down below and share! And as the example site code is available I'll be more than happy to accept Pull Requests to improve it.
