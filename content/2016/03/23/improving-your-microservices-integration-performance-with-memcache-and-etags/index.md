---
title: Improving your Microservices Integration Performance with Memcache and ETAGs
date: '2016-03-23T14:46:00-03:00'
slug: improving-your-microservices-integration-performance-with-memcache-and-etags
tags:
- learning
- rails
- otimization
- performance
- heroku
- memcached
draft: false
---

Everybody is into microservices. There is no way around it. In the Rails world we are well equipped to satisfy any trending Javascript Framework's crave for API consumption.

In summary, most people are just exposing their contents through simple JSON API endpoints and consuming them from other microservices through simple HTTP GETs. The more microservices they add to the chain, the longer the last endpoint takes to return. There are many techniques to improve this situation, but I want to show just a simple one that can solve many common situations without too much hassle.

First of all, if you're dealing with caching, never try to expire cache entries. The most important thing to learn about caching is how to generate proper cache keys. Do it right and most problems with caching are gone.

Second, if you're using HTTP, try to use everything you can from it, instead of reinventing the wheel.

The "TL;DR" version is: make your APIs return proper ETAGs and handle "If-None-Match" headers properly, return the correct 304 status code instead of full blown 200 with full content body in the responses everytime. And in the consumer end, cache the ETAG with the corresponding response body and use it from cache when you receive 304s. You will save at least expensive rendering time in the consumed end and slow bandwidth from the consumer end. In the end you should be able to at least be 100% faster, or more, with just a few tweaks.

### The Example Applications

In a very very contrived example we could have a Rails API controller like this:

--- ruby
## 1st application
class Api::ProductsController < ApplicationController
  def index
    @products = Product.page (params[:page] || 1)
    render json: [num_pages: @products.num_pages, products: @products]
  end
  ...
end
```

For the purposes of this contrived post example, we load it up on localhost port **3001**. Now, whenever we call "http://localhost:3001/api/products?page=1" the API server dumps something like this in the log:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 13:29:34 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"1"}
   (0.3ms)  SELECT COUNT(*) FROM "products"
  Product Load (0.9ms)  SELECT  "products".* FROM "products" LIMIT 100 OFFSET 0
Completed 200 OK in 26ms (Views: 23.0ms | ActiveRecord: 1.2ms)
```

In summary, it's taking around **26ms** to send back a JSON with the first page of products of this application. Not too bad.

Then we can create another Rails API application that consumes this first one. Something also very contrived and stupid like this:

--- ruby
# 2nd application
class Api::ProductsController < ApplicationController
  def index
    # never, ever, hard code hostnames like this, use dotenv-rails or secrets.yml
    url = "http://localhost:3001/api/products?page=?" % (params[:page] || "1")
    json = Net::HTTP.get_response(URI(url)).body

    response.headers["Content-Type"] = "application/json"
    render plain: json
  end
  ...
```

We load this other app in localhost port **3000** and when we call "http://localhost:3000/api/products?page=1" the server dumps the following log:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 13:31:59 -0300
Processing by Api::ProductsController#index as HTML
  Parameters: {"page"=>"1"}
  Rendered text template (0.0ms)
Completed 200 OK in 51ms (Views: 7.1ms | ActiveRecord: 0.0ms)
```

Now, this second application is taking twice the time compared to the first one. We can assume that part of those 51ms are the 26ms of the first application.

The more APIs we add on top of each other, the more time the entire flow will take. 26ms for the first, another 25ms for the second, and so on.

There are many things we could do. But I'd argue that we should start simple: by actually using a bit more of the HTTP protocol.

### Sending proper ETAGs and handling "If-None-Match"

In a nutshell, we can tag any HTTP response with an ETAG, an identifier for the content of the response. If the ETAG is the same, we can assume the content hasn't changed. Web browsers receive the ETAGs and send them back if we choose to refresh the content as a "If-None-Match" header. When a web server receives this header it compares against the ETAG of the response and doesn't send back any content, just a "304 Not Modified" HTTP header, which is much, much lighter and faster to transport back.

An ETAG can be as complicated as an entire SHA256 hexdigest of the entire response content or as simple as just the "updated_at" timestamp if this indicates that the record has changed (in a "show" controller action, for example). It must be a digest that represents the content and it must change if the content changes.

Rails has support for ETAGs for a long time in the [ActionController::ConditionalGet](http://api.rubyonrails.org/classes/ActionController/ConditionalGet.html) API.

In our contrived example, the 1st application on port 3001 fetches a page of ActiveRecord objects and send back an array represented in JSON format. If we choose to digest the final content we would have to let ActionView do it's job, but it is by far the most expensive operation so we want to avoid it.

One thing that we could do is just check the "updated_at" fields of all the records and see if they changed. If any one of them changed, we would need to re-render everything and send a new ETAG and a new response body. So the code could be like this:

--- ruby
class Api::ProductsController < ApplicationController
  layout false
  def index
    @products = Product.page (params[:page] || 1)

    if stale?(freshness @products)
      render json: [num_pages: @products.num_pages, products: @products]
    end
  end
  ...
  private

  def freshness(collection)
    dates = collection.map(&:updated_at).sort
    etag = dates.map(&:to_i).reduce(&:+)
    {etag: Digest::MD5.hexdigest(etag.to_s), last_modified: dates.last, public: true}
  end
```

Now, when we try to "curl -I http://localhost:3001/api/products\?page\=1" we will see the following headers:

```
HTTP/1.1 200 OK 
X-Frame-Options: SAMEORIGIN
X-Xss-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Etag: "ccf372c24cd259d0943fa3dc99830b10"
Last-Modified: Wed, 23 Mar 2016 16:25:53 GMT
Content-Type: application/json; charset=utf-8
Cache-Control: public
X-Request-Id: 601f22bc-72a9-4960-97cb-c30a0b56dbf4
X-Runtime: 0.053529
Server: WEBrick/1.3.1 (Ruby/2.3.0/2015-12-25)
Date: Wed, 23 Mar 2016 17:00:13 GMT
Content-Length: 0
Connection: Keep-Alive
```

Great! We have an ETAG that uniquely represents this page of products. Now we can go one step further and add the following:

--- ruby
# Gemfile
gem 'dalli'
gem 'rack-cache'

# config/environments/[development|production].rb
...
config.cache_store = :dalli_store
client = Dalli::Client.new
config.action_dispatch.rack_cache = {
  :metastore    => client,
  :entitystore  => client
}
config.static_cache_control = "public, max-age=2592000"
...
```

This configuration is assuming that we have Memcached installed and running in the same localhost machine (our development environment), but in production you can follow this [good documentation from Heroku](https://devcenter.heroku.com/articles/rack-cache-memcached-rails31).

Now, our 1st application has an internal HTTP cache, with the same role as something more advanced such as Varnish in front of it. It will cache all HTTP 200 responses from the application, together with the ETAGs. Whenever a new call comes for the same URI, it will check the cache first, and if the application sends back the same ETAG, it will send the content back from the cache.

So if we call the above "curl" command multiple times, we will see this from the Rails server log:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 14:05:16 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"1"}
  Product Load (0.8ms)  SELECT  "products".* FROM "products" LIMIT 100 OFFSET 0
  Couldn't find template for digesting: products/index
   (1.0ms)  SELECT COUNT(*) FROM "products"
Completed 200 OK in 31ms (Views: 16.3ms | ActiveRecord: 1.8ms)
cache: [HEAD /api/products?page=1] miss, store
```

Notice the last line: it says that it tried to find the returning ETAG in the cache and it "missed", so it "stored" the new content. Now, if we run the came "curl" command again, we will see this:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 14:05:59 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"1"}
  Product Load (0.5ms)  SELECT  "products".* FROM "products" LIMIT 100 OFFSET 0
  Couldn't find template for digesting: products/index
Completed 304 Not Modified in 12ms (ActiveRecord: 0.5ms)
cache: [HEAD /api/products?page=1] stale, valid, store
```

The simple curl command is not sending the "If-None-Match" header, so it expects to receive the full response body. But because we have Rack Cache it is adding the "If-None-Match" ETAG digest from the cache to the request before hitting the Rails app. The Rails app now compares the received "If-None-Match" digest through the "stale?" methods with the ETAG it just computed and because they match, it just send an empty body response with the status code of 304. Rack Cache receives the 304 and fetches the cached JSON from Memcached and changes the HTTP response from the 304 to a normal 200 with the full body, which is what Curl can receive.

Because we are skipping the expensive ActionView rendering, the response time went from the previous 26ms to around 12ms: we are now **twice** as fast!

### Consuming APIs with ETAGs

But we can go one step further. If we change nothing about the 2nd application, it will keep receiving just HTTP 200 with full body responses from Rack Cache of the 1st application. Let's see the code again

--- ruby
# 2nd application
class Api::ProductsController < ApplicationController
  def index
    # never, ever, hard code hostnames like this, use dotenv-rails or secrets.yml
    url = "http://localhost:3001/api/products?page=?" % (params[:page] || "1")
    json = Net::HTTP.get_response(URI(url)).body

    response.headers["Content-Type"] = "application/json"
    render plain: json
  end
  ...
```

We can do better. How about the following:

--- ruby
# 2nd application - upgrade!
class Api::ProductsController < ApplicationController
  def index
    page = params[:page] || "1"
    url = "http://localhost:3001/api/products?page=?" % page
    # 1 - fetch the ETAG for the URL
    etag = Rails.cache.fetch(url)
    # 2 - fetch from external API or fetch from internal cache
    json = fetch_with_etag(url, etag)

    response.headers["Content-Type"] = "application/json"
    render plain: json
  end
  ...
  private

  def fetch_with_etag(url, etag)
    uri = URI(url)

    req = Net::HTTP::Get.new(uri)
    # 3 - add the important If-None-Match header
    req['If-None-Match'] = etag if etag

    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }

    etag = res['ETAG']
    etag = etag[1..-2] if etag.present?
    if res.is_a?(Net::HTTPNotModified)
      # 4 - if got a 304, then we already have the content in the internal cache
      Rails.cache.read(etag)
    elsif res.is_a?(Net::HTTPSuccess)
      # 5 - if we got a 200 it's new content to store in internal cache before returning
      Rails.cache.write(url, etag)
      Rails.cache.write(etag, res.body)
      res.body
    else
      "{}"
    end
  end
end
```

I know, feels overwhealming, but it's actually quite simple. Let's go over it step-by-step:

1. First we see if we already have an ETAG associated to the URL we want to fetch (be aware of query parameters!)

2. Now we call the separated "fetch_with_etag" method

3. This is all boilerplate "Net::HTTP" setup, but the important piece is that we add the "If-None-Match" header if we found an ETAG for the URL in the cache.

4. After we make the external call we can have 2 responses. The first being the very very short, body-less, header-only, "304 Not Modified". In this case, it means that we already have the full content in the internal cache and it is still valid, so we use it.

5. In case we receive the normal HTTP "200" status code, we either didn't send any ETAG or the one we sent was invalidated and a new ETAG and content body was returned, so we must update them in our internal cache before exiting.

Now, the first time we call "curl http://localhost:3000/api/products\?page\=1" for the 2nd application endpoint we will see this log:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 14:14:05 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"1"}
  Rendered text template (0.0ms)
Completed 200 OK in 62ms (Views: 5.6ms | ActiveRecord: 0.0ms)
```

Caches are cold, it is taking the same "around 50ms" like we had before, in this case, it's more like 62ms.

Just to recap, this call to the 2nd application made it call the 1st application API, which shows the following it its log:

```
Started GET "/api/products?page=?" for 127.0.0.1 at 2016-03-23 14:14:05 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"?"}
/"32b82ebbd99854ea2ca0d49ff4a7c07c
  Product Load (0.9ms)  SELECT  "products".* FROM "products" LIMIT 100 OFFSET 0
  Couldn't find template for digesting: products/index
   (1.2ms)  SELECT COUNT(*) FROM "products"
Completed 200 OK in 37ms (Views: 21.5ms | ActiveRecord: 2.2ms)
cache: [GET /api/products?page=?] miss, store
```

Cache miss, new content stored!

Now, we call "curl" against the same URL for the 2nd application again and we now see what we wanted in the log:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 14:14:10 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"1"}
  Rendered text template (0.0ms)
Completed 200 OK in 24ms (Views: 0.3ms | ActiveRecord: 0.0ms)
```

Down from 62ms to 24ms!! And in the 1st application log we see:

```
Started GET "/api/products?page=?" for 127.0.0.1 at 2016-03-23 14:14:10 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"?"}
"ccf372c24cd259d0943fa3dc99830b10", ccf372c24cd259d0943fa3dc99830b10
  Product Load (1.2ms)  SELECT  "products".* FROM "products" LIMIT 100 OFFSET 0
  Couldn't find template for digesting: products/index
Completed 304 Not Modified in 12ms (ActiveRecord: 1.2ms)
cache: [GET /api/products?page=?] stale, valid, store
```

A cache hit! Content is stale and valid, so return just 304, the 2nd application acknowledges and fetch the still valid content from its own cache and return to Curl.

### Conclusion

If you remove ETAGs from the 1st application, the 2nd one will not break and vice-versa, because it's optional. If "ETAG" and "If-None-Match" headers are present in received HTTP response, we can use, otherwise they will work as before.

If the 2nd application is itself another API you should also add ETAGs for it, and so on. In this example we didn't, just because I wanted to simplify the scenario. But instead of being just a simple one-to-one proxy, it could be one of those "porcelain" APIs that fetch data from several other smaller microservices, compile down in a single structure and return it. You should create ETAGs that could be the returning ETAGs from all the other microservices digested together in a single ETAG, for example. Because you're just receiving headers and fetching their content from an internal cache, it's quite cheap. Something like this pseudo-code:

--- ruby
def index
  url1 = "http://somehost1.foo/some_endpoint/1"
  url2 = "http://somehost1.foo/some_endpoint/2"
  etag1 = etag_from(url1)
  etag2 = etag_from(url2)
  etag = Digest::MD5.hexdigest(etag1 + etag2)
  if stale?(etag: etag, public: true)
    body1 = JSON.parse fetch_from(url1)
    body2 = JSON.parse fetch_from(url2)
    result = do_some_processing(body1, body2)
    render json: result.to_json
  end
end
```

Another thing: you can add any vanilla HTTP Cache between your microservices, to add authorization, security, or just plain extra caching, it's just HTTP with proper headers. But the more you exchange "304" between your services, the less processing and the less bandwidth you're spending. It should be noticeably efficient in most cases. But again, it's not always cheap or trivial to generate the cache keys/ETAGs to begin with, so this is the point to take more care.

And if you're creating heavy Javascript apps that also consume those APIs, I "believe" the Ajax calls properly cache HTTP content and send back the correct "If-None-Match" and in case they receive 304s, your application should get the normal "success" triggers. I didn't test this when I was writing this post but I think this is the case indeed. So you should automatically get better performance in your front-end application for free if you add proper ETAGs in your APIs.

This is particularly useful for APIs that return data that don't change too often. If it changes every second, or every minute, you should not see too much gains. But if it's something like this example: products lists that only change once every day or every week, or ZIP code lists, or Previous Orders in an e-commerce. Any data that change infrequently is a good candidate. And the larger the dataset, the larger the benefits you will see (if it's a megabyte long listing, for example). As usual, this is also no Silver Bullet, but in this case it is not so much work to add ETAGs and there are near to zero side-effects, so why not?

ETAG is just one of many other HTTP feature you should be using, CORS is another one (Research [Rack Cors](https://github.com/cyu/rack-cors)).

If you're from Brazil, you should watch Nando Vieira's entire course on the broad subject of [Rails Caching](http://howtocode.com.br/cursos/rails-caching).

To be honest, I'm not sure how effective this technique can actually be in all kinds of scenarios so I am very interested in hearing your feedback in case you use something like this in your applications.
