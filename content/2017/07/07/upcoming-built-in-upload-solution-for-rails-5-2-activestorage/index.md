---
title: Upcoming built-in Upload Solution for Rails 5.2 (ActiveStorage)
date: '2017-07-07T14:40:00-03:00'
slug: upcoming-built-in-upload-solution-for-rails-5-2-activestorage
tags:
- heroku
- uploads
- carrierwave
- cloudfront
- cloudinary
- cdn
- activestorage
draft: false
---

**Update 07/11/2017**: Just after our twitter brainstorm, DHH and @gauravtiwari stepped up and started a [new branch](https://github.com/rails/activestorage/pull/35) to add Direct Upload to Cloud support right away. Of course, it's still work in progress but it will be great that it will come with the support out of the box.

**Update 07/20/2017:** I need to clarify a few points. First, I am recommending Cloudinary's proprietary solution, but there are caveats. You're trading off ease of use for vendor lock-in. And I only recommend it for photos/images. If you need to upload super-large files (videos, or arbitrary binaries such as big tarballs) you need to research more and perhaps build a custom solution with Shrine or similar. Another statement I make is that if you use Heroku your only option is Direct Upload to Cloud services such as AWS S3. I delivered several apps which did hit the [H12 Routing Timeout](https://devcenter.heroku.com/articles/request-timeout#uploading-large-files). It's in the official documentation. But right now I deployed a simple dumb Rails 5.1 app with vanilla Carrierwave and an HTML form multipart. I was able to upload a 2+GB video file and it went through Heroku's routing layer. It seems the router picks up the file and lets it finish then passes the finished uploaded file to the Rails app. Now, if you block the request (such as uploading from the Rails app to S3 or doing something else that is time intensive) then the routing layer will H12/timeout the request after 30sec. So you will eventually hit random disconnects if you allow any kind of large file to be uploaded. Even though you can receive it, you can't keep it in the file system (as it's volatile in a Heroku Dyno), so you still need to upload it somewhere and that is the part that can hit the timeout. So Direct Upload is still the way to go on Heroku.

DHH just announced a brand new feature for the upcoming Rails 5.2. This is [ActiveStorage](https://github.com/rails/activestorage).

It should become the default solution to support file uploads. It basically supersedes Paperclip, or Carrierwave, or some features of Dragonfly and Shrine (they do a lot more).

I am writing this small post not to introduce the solution but to clarify a few criticisms I did over Twitter. But Twitter is a terrible platform for more in-depth discussions, hence this post.

The original Twitter thread can be found [here](https://twitter.com/AkitaOnRails/status/882998977754537984).

The process has at least 3 important points to consider:

1. The upload of the file, from the end-user to your Rails controller.
2. An optional transformation step (that you should do, to resize images to be served to different devices and screen resolutions)
3. Serving the blob of the file back to the end-user as an image URL, for example.

### The Upload Step

Most simple upload solutions - such as ActiveStorage, and old ones such as the original Paperclip and the vanilla install of Carrierwave - basically set the HTML form as a multipart and add a vanilla HTML file field. This will upload the form directly to a Rails controller action, which will receive it in the `params` hash and you can deal with the binary blob from there.

Naively deployed, this will **block** the MRI through the entirety of the upload. If the file is very big, it can block any other incoming request for the duration of this upload. (Technically, because Rails supports MRI threads and MRI threads are theoretically non-blocking for IO operations, it shouldn't be as bad as it sounds.)

Fortunately, I believe no one in their right minds exposes an MRI process directly to the internet. We are usually behind a [reverse proxy](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-puma-and-nginx-on-ubuntu-14-04), such as Haproxy, NGINX, Apache HTTPD or something similar.

And usually those reverse proxies are the ones that receive the upload and they only proxy the request when the upload is finished. So the MRI/Rails application can continue to respond to requests in the meantime.

So, if you have a custom infrastructure, you're golden.

If you're using something like Heroku, you're basically screwed. The Heroku routing layer has a hard timeout of 30 seconds. I consider this a good thing because you shouldn't have requests that take this long to process. Heck, you shouldn't have a request responding in 1 second, let alone 30 seconds.

But file upload is the exception. A big file takes time to transfer over the internet. And then the Heroku timeout kicks in and interrupts the transmission. The end-user retries and if you have a large enough crowd, you will start filling up the HTTP queue until you have cascading timeouts over each other.

Which is why the only solution available for Heroku is to do "Direct Upload" to a cloud service such as AWS S3. You can add the [Carrierwave Direct](https://github.com/dwilkie/carrierwave_direct) add-on, or use a complete 3rd party solution such as [Cloudinary](http://www.akitaonrails.com/2016/07/28/updating-my-old-posts-on-uploads), with its client library Attachinary to make things easy. And that's it!

Active Storage, as it is right now, will work for any good enough custom deploy (NGINX + Rails/Puma) ~~but it won't work at all over Heroku~~ and when the [new branch](https://github.com/rails/activestorage/pull/35) is finished it will be a good choice to use over Heroku as well.

### The Transformation Step

This can be done just after the upload or just before serving the file back to the user.

The first one can be done synchronously or asynchronously.

Synchronously is "bad" (I mean, in the controller action itself, because this step is CPU-intensive and takes time). It's basically transforming the image (using something like Rmagick or MiniMagick) into other versions of different sizes (thumbnail, mobile version, high-dpi version, etc) and storing the paths to the different versions in the storage.

Asynchronously is deferring this costly transformation to ActiveJob so something like a Sidekiq worker picks up later and do the processing. Meanwhile, you can serve a placeholder if the particular version is not ready yet.

A caveat is that if you have cloud storage and an asynchronous job transformation, you will have lots of traffic because you will spend time uploading to a cloud storage, then the job will have to download from there, do the transformation and do new uploads.

The other solution is to do no processing whatsoever and defer the processing to be on-demand. This is what 3rd party [Cloudinary/Attachinary](http://cloudinary.com/documentation/image_transformations) does and you can do custom transformations using URI parameters. It will make the transformation once and cache the results for future usage. An example of a Cloudinary image transformation URL looks like this:

```
http://res.cloudinary.com/demo/image/upload/w_400,h_400,c_crop,g_face,r_max/w_200/lady.jpg
```

This is also what you get if you implement [Refile](https://github.com/refile/refile) or [Shrine](https://github.com/janko-m/shrine). It adds a Rack endpoint to your Rails application that will fetch the image binary, perform the transformation according to the parameters received in the URI, and cache the transformation before sending the binary.

### The Serving Step

This is making your Rails app serve the stored blob file. The file can be stored locally (or over a remote NFS mount) or over the internet from any cloud based storage such as AWS S3 (in which case you just link directly to their HTTP endpoint).

When your Rails app serves a local file it can just send a special Header to the reverse proxy (NGINX or Apache - `X-SendFile` or `X-Accel-Redirect`, which is the difference between `send_file` and `send_data` on `ActionController::DataStreaming`, by the way) and they will serve the file directly, avoiding locking the MRI for the duration of the file transfer.

If it's in a cloud storage, it's even easier because you just print their URL for the file directly in the HTML template and there is zero processing necessary.

You will have some processing if you make Rails read the blob and stream it directly (sometimes you need this because you have restrictive access to the files and you don't want to risk even using a randomized URL for the file).

### Conclusion

DHH is right, Basecamp does serve a lot of files and the ActiveStorage (as well as Paperclip, Carrierwave) works nicely, provided you have a proper NGINX reverse proxy in front of it and you added a proper CDN to cache the files back.

If you don't want to have to manage your own storage, you should use a Cloud Storage (AWS S3, Google Cloud, Azure, etc). ActiveStorage or other solutions will receive the file in the Rails controller level and you SHOULD use ActiveJob to POST the blob to the cloud service in the background - not blocking your application in the process. But the trade-off is that if you add asynchronous job transformation, you will end up having to fetch the original image from the cloud storage to do the transformations.

You should perform transformations on your images to send the best-sized image back to your end-users. Again, if you do it in your application consider either an ActiveJob worker or the Rack real-time transform-and-cache solutions available from Refile or Shrine. At least as it is right now, ActiveStorage doesn't provide a solution for the image transformations.

[My recommendation](http://www.akitaonrails.com/2016/07/28/updating-my-old-posts-on-uploads) of previous blog posts on the subject remains, if this is your first time or your business is just beginning, don't sweat it. Use a complete solution like Cloudinary/Attachinary. It will take care of everything in the most optimal way.

But this is NOT a definitive recommendation. If you have custom deploys, and you know your requirements and constraints, a solution like ActiveStorage, vanilla Carrierwave, etc works well. There are always trade-offs, and having so many moving parts always adds up complexity. The Cloudinary recommendation is just so you can start with as few moving parts as possible and then move to more complex scenarios later if you need to.

Dealing with all the possible combinations of file upload management is no small feat. And you probably have most pressing concerns in your business logic than dealing with files.

Oh, and repeating the same ol', same ol', use a damn CDN already! Regardless of the solution you should always [add a CDN](https://devcenter.heroku.com/articles/using-amazon-cloudfront-cdn) to serve your assets (javascripts, stylesheets, images, etc).
