---
title: 'The New Kid on the Block for Ruby Servers: Raptor!'
date: '2014-10-19T15:00:00-02:00'
slug: the-new-kid-on-the-block-for-ruby-servers-raptor
tags:
- learning
- passenger
draft: false
---

*Update (25/11/2014):* We can finally confirm that yes, the awesome Raptor project is the codename for the next release of Phusion Passenger itself! Read the [announcement](http://blog.phusion.nl/2014/11/25/introducing-phusion-passenger-5-beta-1-codename-raptor/)

If you're a seasoned Ruby web developer you're probably familiar and comfortable using the usual suspects to deploy your applications. You're either deploying something simple through good old Thin, or you're orchestrating several Ruby processes through Unicorn workers, or you're trying out JRuby and want better concurrency and thread management, and therefore you're using either Puma or Torquebox.

And even though it feels like we are already at the peak of what's possible with Ruby, we do want more. Ruby 2.1.3 was just released, 3.0 is in development. But until then it should be possible to squeeze some more performance out of your boxes.

In fact, a new contender, with some new approaches just showed up. I have little details so far, but it's a brand new product - not derived from the others - from an unknown team. This product is named ["Raptor"](http://www.rubyraptor.org) and they claim that it can squeeze the extra juice out of our boxes.

And this is their claim:

![Raptor Chart](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/475/chart-1.png)

Fortunately, I had the chance to experiment it's beta release in a controlled Vagrant environment and check those claim! Bear in mind that those are synthetic benchmarks and real world throughput of real applications should give us different behavior. With that having being said, let's see how the main Ruby servers perform a very simple Rack app returning a simple HTTP 200 with "Hello World":

```
 ==> Benchmark parameters:
     Application         : hello_app
     Operating system    : Ubuntu 14.04 LTS (x86_64)
     Virtual CPU cores   : 4
     MRI Ruby            : ruby 2.1.3p242 (2014-09-19 revision 45877) [x86_64-linux-gnu]
     JRuby               : jruby 1.7.13 (1.9.3p392) 2014-06-24 43f133c on OpenJDK 64-Bit Server VM 1.7.0_65-b32 [linux-amd64]

     Unicorn workers     : 8
     Puma workers (MRI)  : 8 (16 threads each)
     Puma workers (JRuby): 1 (32 threads each)
     Torquebox threads   : 32
     Raptor workers      : 8

     Concurrent clients  : 16

 ==> Benchmark summary:
     Unicorn (MRI Ruby)         : 23015.36 req/sec
     Puma (MRI Ruby)            : 32538.62 req/sec
     Puma (JRuby)               : 399.14 req/sec
     Torquebox (JRuby)          : 29773.21 req/sec
     Raptor (MRI Ruby)          : 95309.35 req/sec
     Raptor (JRuby)             : 87523.65 req/sec
```

Now, this sounds very impressive indeed! And what about a more complex example: a simple Rails 4.1.6 application rendering a default scaffold index page with a model fetching 20 rows from MySQL:

```
==> Benchmark summary:
    Unicorn (MRI Ruby)         : 326.49 req/sec
    Puma (MRI Ruby)            : 327.36 req/sec
    Puma (JRuby)               : 221.78 req/sec
    Torquebox (JRuby)          : 226.57 req/sec
    Raptor (MRI Ruby)          : 79617.78 req/sec
    Raptor (JRuby)             : 73948.59 req/sec
```

Again, **super** impressive. My first impression when reading these numbers is that Raptor must have builtin response caching (which is great!). So I tweaked the example to make it much heavier than what's considered "normal" for a small cache, rendering a table of 100 rows from the database in the index page, and the  results are still competitive:

```
==> Benchmark summary:
    Unicorn (MRI Ruby)         : 85.98 req/sec
    Puma (MRI Ruby)            : 89.93 req/sec
    Puma (JRuby)               : 79.42 req/sec
    Torquebox (JRuby)          : 77.98 req/sec
    Raptor (MRI Ruby)          : 82.63 req/sec
    Raptor (JRuby)             : 88.92 req/sec
```

This could mean that at the best case scenario, you could get almost **4 times** the throughput from your application, and in the worst case scenario, you're still getting similar throughputs. This means that Raptor is adaptable and reasonably "smart". So overall it's a win-win situation!

The way they are able to achieve these superior numbers can be explained by the way they approached the implementation. This is the breakdown that they have released so far:

* **Protection against slow clients**: Slow clients on the Internet can block your app, like people standing still in front of your door. Unicorn only has a single small door, so it [requires](http://unicorn.bogomips.org/PHILOSOPHY.html) you to attach a buffering reverse proxy in front of it, like Nginx. Puma has as many small doors as you configure threads, so you still need to attach Nginx in front to be safe. But Raptor has a door that's almost infinitely wide, and fully protects your app against slow clients without additional software.
* **Optional integration with Nginx**. Nginx is a great web server and provides useful features like compression, security, etc. But using Puma and Unicorn with Nginx requires you to configure Puma/Unicorn separately, to configure Nginx separately, to configure monitoring separately, and to manage each component separately. Doesn't it make sense to consolidate all these moving parts into a single package? Enter Raptor's optional Nginx integration mode: configuration, management and daemon monitoring all directly from Nginx.
* **Multitenancy**. If you run multiple apps on a same server, then managing all those Puma and Unicorn instances quickly becomes tedious. Raptor's Nginx integration mode allows you to manage all your apps from a single Nginx instance.
* **Security**. Improve your server's security by easily running multiple apps under multiple user accounts. This way, a vulnerability in one app won't affect all your other apps.
* **JRuby support**. Like Puma (and unlike Unicorn), Raptor has great JRuby support.

So it's not only a different implementation but also features for the future, supporting transparently handling slow clients without causing bottlenecks to your application and avoiding having extra layers of protection. And everything in an easy to use package (according to their release: you will be able to replace your current server in the Gemfile and bundle install it!)

Raptor is about to be released, so keep tuned for more news and when it's available for everybody to test their applications with. From what we have seen so far, this one looks like a winner!

Go to [their website](http://www.rubyraptor.org) to know more about it and if you're like me and feel like this is the real deal, [Thunderclap it!](https://www.thunderclap.it/projects/17748-raptor-fast-ruby-web-server)

![Raptor](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/473/raptor_square.png)
