---
title: Updating my Old Posts on Uploads
date: '2016-07-28T11:56:00-03:00'
slug: updating-my-old-posts-on-uploads
tags:
- uploads
- carrierwave
- cdn
- cloudfront
- cloudinary
- heroku
draft: false
---

Fortunately things usually change for the best, and practices that "worked ok" in the past might be obsolete by now.

That happens to old blog posts, including my own as I've been posting for several years.

In this post I will fix what I posted (in pt-BR):

* [Direct Upload para S3: a Solução Definitiva!](http://www.akitaonrails.com/2014/12/18/small-bites-direct-upload-para-s3-a-solucao-definitiva)
* [S3 Direct Upload + Carrierwave + Sidekiq](http://www.akitaonrails.com/2014/03/26/heroku-tips-s3-direct-upload-carrierwave-sidekiq)
* [Upload de Arquivos](http://www.akitaonrails.com/2010/06/23/akita-responde-upload-de-arquivos)
* [Enciclopédia do Heroku](http://www.akitaonrails.com/2012/04/20/heroku-tips-enciclopedia-do-heroku)

They are still good posts to understand the mechanics of what I will propose here, so you should read them if you're interested in how things work.

**TL;DR** is: use Cloudinary (with Attachinary) and install a CDN (Cloudfront) right now as it's super trivial to do.

> Uploading files is not a task to be taken lightly. It's one of those tasks that you must not consider that it "works" just because it works in your development machine, for a few trivial uploads. Production level behavior changes drastically and it can bring your entire project down depending on how heavy it depends on user generated content.

There are a lot of moving parts to understand. But in the most basic solutions you just create an HTML multipart form with a file input field and submit it to some controller endpoint directly. This controller receives the blob binary and you save it to some local directory in the server.

This is the **worst possible solution** and unfortunatelly this is the one you will find the most through the web.

There are many problems to deal with this simple implementation:

* We are in the era of 12+ megapixel cameras. Those are multi-megabyte sized files. Each upload will take a long time, specially if the user is trying to upload using unreliable or slow wireless networks.

Once the user's browser connects to the web application it will hold that connection and block the entire process through the duration of the request-response cycle. Making this simple to understand, if you only have 1 single process in the server, it will be unable to respond to any other request until the upload finishes.

Fortunately most deployments will use NGINX at the front of the web application - as they should -, so this effect is minimized as NGINX will receive the entire blob before passing it to the web application process underneath, making it not so problematic in most cases.

But if you're on Heroku, the router layer has a **30 seconds timeout** limit. If the upload takes more than that (which is common with users in unreliable networks) this layer will cut the connection down before it finishes. Users will retry and this can cause your request queues to grow very fast.

Avoid uploading anything to Heroku. I consider this a **feature** as it forces application deployed on Heroku to use **good practices** as I will explain below.

* You should also NOT save files to the local filesystem if you want to scale horizontaly, as one server will not be able to see what's in the other server unless you're in AWS EC2 or other IaaS, with shared mounted volumes, for example. In Heroku, you can't rely on anything in the filesystem as the machines are volatile and whenever a dyno restarts it loses whatever was not there during the deployment.

So you must upload what you received to an external storage, such as AWS S3, and this is also slow if you receive lots of uploaded files. You can rely on NGINX or Heroku's router layer to handle the heavy receiving of the files but you will make the request-response cycle super slow if you synchronously process and upload the files to S3.

The next option you think of is to add Sidekiq or some other Async Job mechanism to do this other heavy lifting. Now you have to create front-end placeholders to show to the users while the background job is not finished sending the files to S3.

The last option, if you dig deeper, is browser-based **direct uploads to S3** and just posting the URLs to your web application. This is the ideal solution, but it's not easy to implement in your stack.

* Once you nail everything above, you still do the mistake of putting the S3 URLs directly in the IMG tags in your HTML, which is not recommended by Amazon as S3 is recommended just for "storage" purposes. This is the easy part to fix, but most projects forget about that.

### Cloudinary or Carrierwave Direct

In my previous posts I explained each of the above issues in more detail and I offer some (complicated) solutions, such as using the Refile project. At that time the Carrierwave plugins for Direct Upload were not ready.

Nowadays the solution is actually super easy and this is what I recommend: go straight to [Cloudinary](http://cloudinary.com/documentation/rails_integration). This is a Software as a Service solution for proper direct uploads and dynamic image processing. You should definitelly explore the [Attachinary](https://github.com/assembler/attachinary) gem to make the process easier.

If you have legacy Carrierwave, Paperclip, Shrine, Dragonfly, Refile or others, one jerry rigged - but reasonable - alternative is to just add Attachinary to the mix.

Let's say you have an old `user.avatar` uploader. You can just create a new `user.new_avatar` with Attachinary/Cloudinary. In the HTML form upload you start using just the Attachinary helpers. And in the HTML where you show the image itself, you can make a helper to check for `@user.new_avatar?` and show using `cl_image_tag(@user.avatar.path` instead, otherwise you show the old URLs.

You don't need to totally migrate everything to Cloudinary, just keep the old assets where they are and start putting the new assets in the Cloudinary configuration. It has a Free tier that can hold up to 75 thousand images and allow a traffic of up to 5GB. And with just USD 44 a month you have 10 times that. So it's really cheap if your application is serious about file uploading.

If you don't want to commit to an external service yet, and you're using Carrierwave, another option you must consider is testing out [CarrierwaveDirect](https://github.com/dwilkie/carrierwave_direct) to test direct uploading to S3 from the browser. This will at least avoid the complexities of setting up async uploads from the web application to S3.

Update: [Janko Marohnić](https://github.com/janko-m) posted a very good comment that I think is important to quote directly:

> Great writeup, I wholeheartedly agree that we probably don't "just want something simple", especially concerning synchronous uploads and CDNs.

> Shrine actually has a [Cloudinary integration](https://github.com/janko-m/shrine-cloudinary), and it's pretty advanced too; it supports direct uploads, setting upload options, storing Cloudinary metadata (hello [responsive breakpoints](http://cloudinary.com/blog/introducing_intelligent_responsive_image_breakpoints_solutions)) etc :). Also, the Cloudinary gem ships with a CarrierWave integration. I think it's beneficial to use Shrine or CarrierWave with Cloudinary, because then you get to keep your file attachments library, and just change the underlying storage service.

> As for CarrierwaveDirect, I don't think it's actually very useful, because backgrounding you need to do all by yourself anyway, so basically all it gives you is the ability to generate a direct-upload form to S3. But generating request parameters and URL to S3 is something that's already built in into the official [aws-sdk](https://github.com/aws/aws-sdk-ruby) gem, CarrierwaveDirect just seems to be reimplementing th at logic. And the advantage of generating this through aws-sdk is that it's not HTML-specific, so you could setup an endpoint which returns this information as JSON, and now you have your multiple file uploads directly to S3 :)

As a disclaimer I didn't test CarrierwaveDirect myself and I remember it being quite broken 2 years ago. And I've heard good things about Shrine along the way but never did a proper testing. I'd recommend giving it a try if you want to migrate away from Carrierwave.

### Don't serve assets from S3, use a CDN, any CDN

If you're sticking to S3 uploading, at the very least avoid serving those files from S3. In my "Heroku Encyclopedia" post I recommend using "S3 Assets Sync". DO NOT DO IT: use a CDN instead, it's faster, easier and the correct solution

The first thing you want to do is sign up to AWS's Cloudfront CDN service. Always use a CDN for all your assets, not only the ones [internal to your web application](http://www.algonauti.com/posts/speed-up-ugc-with-cloudfront) but also every user uploaded content. It's [super simple](https://devcenter.heroku.com/articles/using-amazon-cloudfront-cdn) to create a new CDN endpoint pointing to your S3 bucket.

Carrierwave will default to the S3 bucket host, but once you have the Cloudfront endpoint you can [easily change](https://dzone.com/articles/carrierwave-heroku-cloudfront) all the uploaded files URLs like this:

```ruby
# ./config/initializers/carrierwave.rb
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider => "AWS",
    :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  }
  config.fog_directory = ENV['S3_BUCKET']

  # use only one of the following 2 settings
  # config.fog_host = "http://#{ENV['S3_BUCKET']}.s3.amazonaws.com"
  config.fog_host = ENV['S3_CDN'] # for cloudfront
end
```

You must obviously configure the environment variable `S3_CDN` to point to the Cloudfront endpoint specific to the particular S3 bucket you're using.

The important part is: serve ALL ASSETS from a CDN, no matter what. Never directly from your web application, avoid directly serving from S3. It's almost trivial to implement and if you don't like AWS for any reason, you can choose Fastly, Cloudflare and many others.

They all work the same way. There is NO excuse to not use a CDN no matter the size of your application.
