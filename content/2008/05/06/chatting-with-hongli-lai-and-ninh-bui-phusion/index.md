---
title: Chatting with Hongli Lai and Ninh Bui (Phusion)
date: '2008-05-06T21:39:00-03:00'
slug: chatting-with-hongli-lai-and-ninh-bui-phusion
tags:
- interview
- english
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/Picture_4.png)

**Hongli Lai** and **Ninh Bui** , from Phusion, shaked the Rails world a few days ago. They unleashed the Holy Grail of Rails deployment: **mod\_rails** which was received with much fanfare, and they deserved it.

They finally settled the big issue that [embarrassed](http://www.rubyinside.com/no-true-mod_ruby-is-damaging-rubys-viability-on-the-web-693.html) Railers in the past. This will also relieve dozens of hosting services that were clueless on how to solve this equation. Now, those two computer science students are above them all with this clever solution. And they have more to come.

I was very fortunate to be able to interview them. I think this is the second interview, InfoQ broke the news first with this other [interview](http://www.infoq.com/news/2008/04/phusion-passenger-mod-rails-gc) which I highly recommend to understand more of the inner gears of Passenger. They are very easy going and it was a pleasure to talk to them.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/Picture_3.png)


 **AkitaOnRails:** I think the first thing I’d like to know are your backgrounds. Which one came first? [mod\_rails](http://www.modrails.com/) or [Phusion](http://www.phusion.nl)? Meaning, did you have a company named Phusion that ended up developing mod\_rails, or mod\_rails was the reason to build a business around it?

**Phusion:** Well, as you’ve probably read by now, we’re both computer science students at the [University of Twente](http://www.utwente.nl/en/) and we’re currently in the final stages of finishing our bachelor degrees. From the beginning, we had already inferred that study can’t teach you everything, so over the years, we’ve also been doing a lot of work both commercially as well as for the open source community.

After becoming familiar with each others skills, philosophies and personal traits and from our past experience in working in IT, we thought it would be a good idea to combine our forces into a company that we could call our own, and so Phusion came to be.

So Phusion actually came before Passenger (mod\_rails). More specifically, our intent was to start a company that strictly provides top-of-the-bill IT products, ideas and services to support our clients’ businesses. Passenger coincidentally happens to be our first product, and from what we’ve been hearing from both the community and companies, it seems to be perfectly in line with our company’s philosophy.

Also, after doing years of (web) development in other languages/frameworks such as PHP, J2EE, ASP.NET, etc. we’ve really come to appreciate Ruby on Rails. We think it’s really elegant and easy to use. Unfortunately deployment seemed to be out of line with the rest of the Rails experience, especially the convention over configuration part. This is why we’ve created Passenger: we want the deployment experience to be just as smooth.

**AkitaOnRails:** Is Phusion a consulting company or a product company? Right now you released one of the most interesting projects in Rails land so far, which is mod\_rails. Now you’re preparing to release Ruby Enterprise Edition. Any new products in your pipeline that you could tell us about?

**Phusion:** Well, Phusion is primarily a service oriented company and we think our mission statement answers this question best:

_“To exclusively provide top-of-the-line products, services and ideas, in order to support our clients’ businesses.”_

If our clients’ businesses require consultancy, then we’re able to provide that as well seeing as we’ve had quite a few years of experience in that particular line of business.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/Picture_1.png)

In order to achieve this mission, it is crucial for us to be well-versed in a variety of skills and we’re well aware of the saying _“jack of all trades, master of none”_. It is for this reason that our team comprises of only highly skilled people from those parts of the industry that are of particular interest to our clients’ businesses. The reader will probably note that this allows for a dynamic configuration in organization as well as keeping the work challenging: we don’t believe in [keeping people around forever for no rational reasons](http://thedailywtf.com/Articles/Up-or-Out-Solving-the-IT-Turnover-Crisis.aspx), so it is crucial for our employees to keep learning within our organization (hence the alias, _“the computer science company”_). This not only opens up a lot of doors on the innovation side, but also results in people becoming masters in several areas. So _“jack of all trades, master of none”_ may hold true, we believe _“master of a lot of areas”_ could just as easily hold true. Needless to say, this is crucial since computer science and IT cover such a wide area, and this particularly holds true for our clients’ businesses.

Ruby Enterprise Edition has actually been called to life as a result of Passenger: it strives to dramatically reduce memory usage of Ruby on Rails applications that are run through Passenger.

As for new products, we’re currently working on a few subscription-based web services. Our friend David Heinemeier Hansson has recently given a talk on startups which elaborates on the reasons why one would want to follow such a path. We’d highly recommend the reader to [check that out](http://www.justin.tv/hackertv/97862/DHH_Talk__Startup_School_2008) and for strategic reasons, we’d like to leave it at this for now.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/2400947055_2ce7bcf70b.jpg)  
Hongli Lai

**AkitaOnRails:** For a long time the whole Rails community was rather too much comfortable with the Mongrel solution. When Zed Shaw ranted about the community, it was a wake up call and from there we saw alternatives emerging overnight such as Thin and Ebb. What did you think about that situation back then?

**Phusion:** From what we understand, solutions such as Mongrel, Thin and Ebb fall under the same conceptual category. That is, for the end-user, they work in a similar way, even though they are technically different. In other words, Thin and Ebb seem to be like _“Mongrel, but faster/smaller”_.

Passenger however has taken an approach to deployment that’s different from Mongrel et al: it intends to make deployment as simple as possible, and to lower system maintenance overhead as much as possible. For example, while Passenger handles this automatically, Mongrel, Thin and Ebb all require the administrator to manage clusters. As you’ve stated, the tech savvy have already become quite familiar with the latter, but one also needs to take the newcomers into account. For them, it’s quite an obstacle to overcome to just simply deploy an application. If we were to consider the backgrounds of these newcomers, many of them are probably already familiar with the PHP way of deployment, that is, in an upload-and-go manner. With Passenger we’ve tried to accommodate these people, as we think that this is important to the growth of the Ruby on Rails market. That doesn’t however say that we haven’t taken issues such as robustness, performance and stability into account.

As a matter of fact, independent tests have already shown that Passenger is on par or faster than the aforementioned solutions. Another problem is that shared hosts are already running Apache as their main web server, and we’ve already seen what configuration needs to be done in order to get a Mongrel cluster up and running with Apache… Needless to say, this is quite tedious and error-prone, even for many tech savvy to say the least. Passenger literally reduces this process to a matter of seconds instead of minutes. This should not only save a hosting company a great deal of time but should also keep their server administrators sane (and from our [experience](http://blog.dreamhost.com/2008/01/07/how-ruby-on-rails-could-be-much-better/), they’re the last people you want to offend ;-)).

Also, setting up a Mongrel-like cluster requires quite some resources on a shared host, and it is for reasons such as these that the costs of shared Ruby on Rails hosting plans are usually higher than that of PHP hosts. Passenger however, takes on this issue as well by providing improved efficiency over the aforementioned solutions, especially in conjunction with Ruby Enterprise Edition. Early testing has already shown that the latter has resulted in a dramatic reduction in memory usage and we’ll elaborate on this soon.

If we consider these factors, it becomes apparent that Passenger (in conjunction with Ruby Enterprise Edition) has the potential to unleash a revolution within shared hosting. Not only in cost-reduction for hosting companies (and hopefully consumers), but also in increasing the popularity of Ruby on Rails.

**AkitaOnRails:** mod\_ruby seems to be staled for a long time and needs some love. It is said that it works reasonably well for small websites but lots of ‘black magic’ in Rails makes it not suitable for mod\_ruby. What makes mod\_rails different than mod\_ruby, in the fundamental way they operate with complex frameworks as Rails?

**Phusion:** We’re not really able to comment on that, because we’re not intimately familiar with mod\_ruby. However, mod\_ruby is not actively maintained, and there are a lot of negative comments about mod\_ruby in general (such as on the Ruby on Rails wiki). It also seems that nobody really uses it. It is for these reasons that we’ve never really given mod\_ruby a try.

From the aforementioned and what people often tend to forget, is that only delivering a(n excellent) product will not suffice. Marketing and promotion are really important for a product’s acceptance. We’ve not only done a lot of development, but also spent a lot of time in promoting Passenger. The fact that we’re having this interview right now is probably the result of our promotion campaign, so we’re quite happy with that. In this regard, mod\_ruby doesn’t seem to be actively promoted, and perhaps this is one of the reasons why it’s relatively unknown.

**AkitaOnRails:** why do you think it took so long for someone to come up with a solution for an Apache module that could operate similarly to the usual mod\_php or mod\_python? What did you think was the most challenging aspect in the development of mod\_rails?

**Phusion:** Well, as you’ve stated, we believe that experienced Ruby on Rails developers don’t consider deployment to be a problem; probably annoying at most. They’ve automated/standardized the deployment process for a great deal with Capistrano scripts. Newcomers however see deployment as an insurmountable problem. Consequently, we end up having a situation in which the people who can solve the problem either don’t see a problem or aren’t motivated enough to fix the problem, while the people who do see the problem cannot solve it.

Furthermore, from our personal experiences, newcomers usually want to see immediate results. It’s very demotivating for those people to continue using Ruby on Rails if they have to manage tons of obscure configurations and clusters to _‘just successfully deploy an application’_. This leads to very intelligent conclusions, such as that “Ruby on Rails sucks”. ;-)

The most challenging aspect is probably cross-platform support and to elaborate on this in a nutshell:

- We have to support a whole bunch of Unix-based systems, like Linux, BSD and OS X. Passenger works on a fairly low-level (i.e. it uses advanced Unix system features), and different systems tend to behave in subtly different ways such that they can break Passenger if we’re not careful.
- A lot of challenges are created by MacOS X and Apache. There are literally tons of different ways in which Apache can be compiled and installed, and this is especially true on MacOS X. Every single Apache installation can be slightly different, and we have to support all of them. We had to write hundreds of lines of Apache auto-detection code in order to make the installation as smooth as possible. And support for OS X-specific things such as universal binaries didn’t make the challenge any easier.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/134717629_6_Q1hc.jpeg)  
Ninh Bui

**AkitaOnRails:** the usual Shared Hosting approach with Rails involves FastCGI, I think that’s where mod\_rails will make a big impact first. In the VPS arena people are usually more comfortable just loading up a mongrel cluster, maybe a monit or god to monitor them or even use Swiftply to better control mongrel instances. There’s some tweaking involved in having permanent Ruby interpretors running, that’s mainly because of the fact that if at some point the VM needs more memory, it will allocate as much as it needs, but not return it back to the OS. Does mod\_rails has some thing to avoid a monitoring system like Monit or it is still needed?

**Phusion:** We’ve taken this challenge into account as well. Rails applications that have been idle for a while are shut down, thereby releasing all of their resources to the operating system. Furthermore, it is possible to use Passenger in conjunction with monitoring tools such as Monit. If Monit kills a Rails process, then Passenger will automatically (re)start it when needed, as if nothing bad ever happened.

**AkitaOnRails:** I understand that mod\_rails operates more or less like a manager for a pool of Ruby VMs. You have a minimum and maximum number of processes allowed, mod\_rails starts as many as it needs depending on load and if a process is sitting idle, it will kill it after a timeout period. Most of the time a minimum amount of processes will stay running. Is that how it operates?

**Phusion:** It is as you describe it, with the exception that there’s no such thing as a minimum amount of processes. The reason for this is that, once an application for a certain Rails directory is spawned, that application process cannot be reused for a different Rails directory. This makes the concept of a minimum amount quite useless, except in servers that only host a single Rails application.

Of course, not having a minimum amount of processes will mean that the first request after the idle timeout will undergo a performance penalty and be slow. We’ve solved this issue by using spawner servers. Spawner servers cache Ruby on Rails framework code and application code, and they can reduce the spawn time by about 50% and 90%, respectively. You might have noticed these spawner server processes in the output of ‘ps’. The secret in reducing spawn time would lie in altering the idle timeouts of these spawner servers. We are currently working on a series of articles, in which we elaborate on the spawn times of Rails applications, what the exact roles of the spawner servers are, and how system administrators can optimize server settings to reduce spawn time.

Much of the magic that resides in Passenger still needs to be unveiled and we’ve only just started, but this is mainly for the interested people out there, i.e. the tech savvy. There is a saying in Dutch that summarizes the thought behind why we haven’t done this up till now: _“Goede wijn behoeft geen krans”_, which would roughly translate to that a good product does not need any supporting elaboration. A scientific publication on the other hand does need this kind of elaboration and it is also for this reason that we’re writing these articles as well.

**AkitaOnRails:** By staying in the same memory space as Apache itself you don’t have the overhead of a FastCGI or HTTP call over to a mongrel instance. Does this difference account for much in your benchmarks? Usually, in your experience, how much faster is mod\_rails right now compared to a bare bone mongrel cluster running the same apps? Are the gainings in speed a constant or it varies enough that it is not really measurable?

**Phusion:** This is actually not true: the Rails processes don’t reside in the same memory space as Apache. Instead, they really are separate processes, that each can be individually shut down without affecting all the others. It is not a very good idea to embed a Ruby interpreter in Apache because of various issues, such as stability, heap fragmentation and unnecessary bloating of a process’s VM size. From what we understand, mod\_ruby takes the approach of embedding Ruby inside Apache, and we suspect that this is one of the reasons why people are reporting so many problems with it.

Our own tests have shown that Passenger’s performance is faster than a Mongrel cluster behind Apache+mod\_proxy\_balancer. Independent tests have shown that Passenger’s performance is either on par with or slightly faster than Mongrel cluster and this seems to be perfectly in line with what we’ve been able to infer. So far we haven’t seen any tests in which Passenger is slower than a Mongrel cluster. The speed gains are not constant: they are dependent on the specific application.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/2400947461_dfa24d2212.jpg)  
Phusion folks at [Fingertips](http://www.fngtps.com)

**AkitaOnRails:** Ruby Enterprise Edition, for what I understand, is the outcome of that ‘copy-on-write’ series we talked about. Essentially a way to patch the Ruby VM to enable a modified GC that won’t mark every object, thus allowing COW to do its work and save a considerable amount of memory. You stated 33%. I would assume that it is ‘up to 33%’, right? What’s the usual range of saved memory you experience in your tests? What affects this the most in typical Rails apps, any gotchas worth mentioning for Rails developers?

**Phusion:** The mentioned 33% is not a maximum, but an average. We’ve tested with real-life applications such as Typo, and so far we’ve inferred an average memory saving of 33%. The actual memory savings is dependent of the specific application so your mileage may vary.

There are no gotchas for application developers. If their application works with Passenger, then Ruby Enterprise Edition will work as well, without any need for complicated configuration options. In other words, it’s a transparent augmentation. In any case, we can guarantee you that memory usage will be no higher than when you use standard Ruby.

**AkitaOnRails:** I understand that you will talk more about the Enterprise Edition at RailsConf but I was hoping that you could disclose a little bit more about it. You are just finishing the second batch of donations for Enterprise licenses (I donated! :-). First things first: when are you going to release it? Is this product supposed to stay commercial only or do you intend to collaborate the GC patch back to the Ruby trunk one day?

**Phusion:** Thanks for donating, and as for the latter: yes, it is our intention that it will one day be merged back upstream. The alert reader will probably notice that we’ve dodged one question like Neo dodged Agent Smith’s bullets in the Matrix: skilled, except for the last bullet, that one actually hit, but enough about that ;-).

**AkitaOnRails:** “mod\_rails” is actually the alias for “Passenger”, some people are asking if this is going to stay Rails only or if you intend to make it Rack-compatible so other frameworks as Merb and Ramaze could run under its control. Is that possible? Are you considering it?

**Phusion:** Let’s just say that we would prefer you to call it Passenger instead of just mod\_rails eventually. ;-)

**AkitaOnRails:** Apache is the powerhouse for Web servers and it makes a lot of sense for an Apache module like that. Maybe I am speculating too much, but do you think it is possible to refactor it into other web server’s modules like nGinx or Litespeed? Because of the lack of a good mod\_rails in the past, the Rails community drifted away to other alternatives. Is it reasonable to expect non-Apache modules?

**Phusion:** It’s technically possible. To keep you guys in suspense and to keep you speculating on such matters, we won’t dive into this further for the time being. ;-)

![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/2401777262_a7fa751c79.jpg)  
Passenger being installed!

**AkitaOnRails:** The way it is right now, it feels like mod\_rails is a drop-in replacement for whatever strategy we had before using Apache. Are there any gotchas worth mentioning for anyone planning to migrate? I think complicated mod\_rewrite rules would be the first thing?

**Phusion:** There’s a minor gotcha. By default we override mod\_rewrite the best we can. This is because Rails project come with a .htaccess file by default, and this .htaccess contains mod\_rewrite rules, which result in all requests being forwarded to CGI or FastCGI.

This is trivially solved by deleting the default .htaccess and by enabling a configuration option which tells Passenger not to override mod\_rewrite. This allows the developer to use arbitrary mod\_rewrite rules to his liking.

Other than that, the remaining gotcha would be that rails deployment has become quite boring thanks to Passenger, or so people say. ;-)

On a final note, we’d like to thank all you guys out there for the love and (financial) support on Passenger. We really appreciate it!

With kind regards we are, your friends at Phusion,

Hongli Lai

Ninh Bui

