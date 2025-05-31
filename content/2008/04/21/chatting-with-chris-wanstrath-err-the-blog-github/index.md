---
title: Chatting with Chris Wanstrath (Err the Blog/Github)
date: '2008-04-21T19:12:00-03:00'
slug: chatting-with-chris-wanstrath-err-the-blog-github
tags:
- interview
- english
draft: false
---

Chris is a very accessible and easy-going guy, and I just got him out of AIM and started the interview right away. For those of you who never heard of **‘Chris Wanstrath’** , he is also known for Err the Blog and recently as one of the guys behind the **Github** phenomenon.

He answered everything in color detail and we speak a lot about his open source projects, performance, scalability and, of course, lots of Git and Github stuff. Hopefully it will make people even more excited with how the Ruby/Rails community is moving things forward all the time.

**aos leitores brasileiros:** assim que tiver tempo irei traduzir esta entrevista.


 **AkitaOnRails:** Ok, so, where are you from?

**Chris Wanstrath:** Right now I live in San Francisco but I grew up in Cincinnati, Ohio. I moved to San Francisco in 2005 to work for C|NET where I did PHP for a while on sites like [gamespot.com](http://gamespot.com), [mp3.com](http://mp3.com), and [tv.com](http://tv.com)

In 2006 I moved over to the [chowhound.com](http://chowhound.com) site within C|NET to work on Rails, which is something I had been doing on the side for a while. While I was there **P.J. Hyett** and myself worked on chowhound.com then built [chow.com](http://chow.com), which we launched later that year. Then in April of 2007 we both left C|NET to form our consulting company, Err Free.

In December of 2007 we launched [FamSpam](http://famspam.com/), which is a site for keeping in touch with your family. It’s basically a simplified version of Google Groups with emphasis on participating in a thread at least once a week and easily finding photos or other file uploads.

While P.J. and I were working on FamSpam, **Tom Preston-Werner** and I were working on GitHub on the side. We started in October working nights and weekends on it. We basically wanted an easy, pretty, and feature-rich way to throw our Git repos up and share them with people. Then as we got more into it, we realized how things like the dashboard could change the way we deal with open source contributions. After that, all the social features began to fall into place. Github private beta launched in january, and in april we saw the public launch

**AkitaOnRails:** Wow, Cool, you are a very busy guy indeed, I want to go on in details within each topic you mentioned but first I knew you worked for C|Net because of your memcached keynotes. I have 2 questions: you were a PHP programmer, what made you switch to Ruby on Rails? And then, working for a high profile network like C|Net exposed you to very demanding public websites. How did you figured out about leveraging memcached with Rails and then your cache_fu plugin?

**Chris Wanstrath:** I started doing Rails at the start of 2005 and got my first PHP job in February of 2005. (before that I was doing asp and Perl, which I don’t like to talk about). So really, I never considered myself a “PHP programmer” over a Rails programmer. I really liked websites and I knew I could get paid doing PHP, so that’s what I did. In the meantime, I was constantly doing Ruby on the side.

When C|Net started doing Rails, I knew it would be a perfect fit for me. I really liked PHP and loved Gamespot, but it was just silly for me to spend all night playing with Ruby while doing PHP professionally.

In fact, one of the things that got me hired at Gamespot was my pure PHP yaml parser called [SPYC](http://spyc.sourceforge.net/) (simple PHP yaml class). It was inspired (obviously) by _why’s syck yaml parser. I wanted an easy, extension-free way to deal with YAML in PHP because I was so spoiled by Ruby.

I think today the CakePHP and Symfony frameworks use it, and do their config stuff in yaml. But even when writing PHP I wanted to be writing Ruby. The main reason I picked up ruby in the first place is because I knew PHP, and I knew Perl, but I wanted something I could use to write both websites and command line scripts. Perl was great for scripts, and PHP was great for sites, but I was just tired of using them both

So while I was learning Python, Rails popped up.

As far as [cache_fu](http://errtheblog.com/posts/57-kickin-ass-w-cachefu) goes, I was very interested in some of the “scaling” aspects of running a website while working at Gamespot.

While good OOP design and stuff like that can be learned by anyone writing enough code, you can’t really learn about scaling unless you’re working on a big website. There are just too many tricks and moving parts, and it’s too hard to simulate the load in a controlled environment.

So while at Gamespot, like I said, I tried to learn as much as possible about things like MySQL replication, clustering databases, sharding databases, and memcached based on how the smart guys at C|Net had set it all up over the years. They had a lot of machines serving a lot of traffic so it was perfect

At Chowhound, we were re-writing an old static html site in Rails and were worried about the transition from flat files to dynamic database calls and page generation. It had a fair amount of traffic from a group of rabid fans, and we knew the new “web 2.0” look of the site would not sit well with the old school users, so we at least wanted the site to be performant in order to give them one less thing to complain about. So we basically took a lot of what I had learned at Gamespot, and what information was freely available on the internet in mailing lists and discussions, and tried to do a more Rails friendly way of object caching with memcached.

Ruby is just so good at cleaning up repetition and creating friendly apis. So cache_fu does fragment caching and object caching, because in bigger sites you end up using both for different purposes which is how it was at Gamespot too, basically.

**AkitaOnRails:** Nice. And it is not very common for me to find people that have dealt with really big websites. Can you give us a glimpse of what kind of load your Rails apps did have to handle? Some pundits I know complain about the vanilla Rails distribution and recommend lots of tweaks like dumping ActiveRecord altogether and several other hacks. Do you have to hack Rails a lot in order to achieve the scalability you need or do you think most of it is good enough so you can avoid too much tweaking?

**Chris Wanstrath:** I wouldn’t really consider Chowhound to be a big Rails site anymore. Now that you’ve got scribd and twitter and friends for sale and Yellowpages, Chowhound doesn’t really make the list.

We ended up doing a lot of premature optimization on that site, and not enough real world optimization. I learned a lot of lessons there that I’ve applied to other sites along the way. However, I recently had the chance to work with the friends for sale guys on their Facebook app which gets millions of page views a day and handles an insane amount of db records.

To my knowledge, the only AR hack we did was apply Pratik Naik’s partial updates patch. This was because, with so many rows and such large indexes, you want to avoid modifying indexes when you don’t need to, so saving only the changed columns/attributes can have a real big performance gain. Luckily, partial updates are now in Rails Core.

In my experience, you spend a lot more time trying to scale SQL before you even need to address AR. And once you get to the AR part, it’s usually your application code. Fetching and saving too many records in before/after_save callbacks, full row writes like I was just describing, and generally not being a good SQL citizen. I would only ditch AR completely if I felt like I had no control over the SQL it generated. Which, as anyone knows, is not the case – you have a lot of control over it.

There are times, however, when AR is overkill and you really do need speed. On Github, we need to authenticate you every time you try and pull or push a repository over ssh. Loading an entire Rails environment, or even activerecord, was noticeably slow, so we switched to using sequel in a simple ruby script. Because we don’t need AR’s massive featureset and nice OOP capabilities for such a simple single row find, this made a lot of sense for us.

**AkitaOnRails:** I agree with that, that’s what I experienced too with regards to AR. So, and you’re also the author of several other famous Rails plugins like will_paginate, Ambition, the original Sexy Migrations. Can you comment briefly about each. Am I forgetting any other plugins? Some of what you did became the ‘de facto’ standards for Rails development, some people here use these plugins without really knowing you made them all.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/21/113964679_23c106ba1b.jpg)   
_P.J Hyett at SXSW’06_

**Chris Wanstrath:** [Err the blog](http://errtheblog.com) is actually two people, P.J. Hyett and myself. I did not write [will_paginate](http://errtheblog.com/posts/56-im-paginating-again) – P.J. wrote the original version then Mislav Marohnić re-wrote it. Mislav is now the maintainer. But I still get all the credit, which is fine by me.

As far as the other plugins go, there’s mofo, ambition, sexy migrations, cache_fu, acts_as_textiled, fixture_scenarios_builder, and gibberish.

[Mofo](http://errtheblog.com/posts/35-me-and-uformats) is a microformat parser based on Hpricot. It’s up on Github and unfortunately doesn’t get enough love from me these days, but as far as I know it’s still the gold standard for microformat parsing in Ruby.

It was the first gem that I released which doubled as a Rails plugin, which is how I think most plugins should be distributed in the future. Gems already have a solid distribution system and versioning scheme, and if Github becomes a gem source then there’s almost no reason not to release plugins as gems

[Sexy migrations](http://errtheblog.com/posts/51-sexy-migrations) were inspired by Hobo. Unfortunately their version was hobo-specific, so I wrote a plugin-friendly version. DHH later wrote his own version and rolled it into core, making a grand total of 3 distinct sexy migration implementations.

[Gibberish](http://errtheblog.com/posts/55-ya-talkin-gibberish) is a pretty fun localization plugin I wrote _pro bono_ for a client, just because I felt like the APIs of all the existing localization plugins were so difficult to work with. Hopefully, with the help of anyone interested, we can begin localizing Github in the near future.

[Ambition](http://errtheblog.com/posts/64-even-more-ambitious) was inspired by dabbling in Erlang. I read a blog post explaining that [mnesia’s](http://www.infoq.com/news/2007/08/mnesia) query syntax, which is all list comprehension (basically Ruby’s version of the Enumerable module), was made possible by the ability to walk the parse tree and build an mnesia query that way.

So I started playing with the parse_tree gem to see if I could do the same for Ruby. It’s now, of course, a full fledged framework for generating arbitrary queries for any RubyGem based on Enumerable. For simple queries, I really like treating tables as arrays, it feels very natural.

[Acts_as_textiled](http://errtheblog.com/posts/12-actsastextiled) was the first Rails plugin I released. It’s a testament to Rails that the plugin still works on edge today. The only other notable thing that Err started is the “vendor everything” term, which is now a part of Rails through [config.gems](http://ryandaigle.com/articles/2008/4/1/what-s-new-in-edge-rails-gem-dependencies).

That, and the [Cheat](http://errtheblog.com/posts/21-cheat) gem (and site).

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/21/322610984_f5d9e82bda.jpg)   
_Tom Preston-Werner_

**AkitaOnRails:** (Of course, pardon me P.J.!) And this raises another curiosity of mine: where did the name “Err” come from? It is both for [Err the Blog](http://errtheblog.com/) and [Err Free](http://errfree.com/) which is your company. And you mentioned P.J. and Tom. And you’re all full time Railers, right? How did you teamed up with them and decided starting your own company? Many times people ask me about entrepreneurship and you’re another good example.

**Chris Wanstrath:** “err” is kind of a play on “Typo,” which was the popular Rails blogging engine when we started our blog, so it may be kind of confusing, but I actually am cofounder of two distinct companies.

There is **Err Free** and **Logical Awesome**. Err Free is Ruby & Rails consulting and training. P.J. and I own the company, and we use it to do client work, speaking gigs, corporate training, that sort of thing. It also owns and operates FamSpam, which we use with our own families.

Logical Awesome, however, was founded by me and Tom. This is because I was developing FamSpam with P.J. and GitHub with Tom at the same time, separately. Today, however, P.J. is a part of Logical Awesome and is one of the GitHub developers.

Tom works at **Powerset** and doesn’t actually do much Rails for GitHub, he mainly does flash, haxe, C, css, design, and ruby. And because he’s the author of [God](http://god.rubyforge.org/), I make him write all the config files, too. As far as deciding to start a company, I am someone that needs to be involved in whatever I’m involved with on every level. At C|Net, there is only so much input you can have on a website that employs 30 people especially when there are dedicated product and “vision” people, whereas with Github, it’s just me Tom and P.J.

If the site is slow, confusing, sucks, or doesn’t improve your workflow, I can take responsibility for that. But if it’s fast, simple, awesome, and life changing, I get to take responsibility for that, too. Which is very rewarding.

It also means, when you’re cofounder of a mostly technical company, the discussions are a lot more logical. I saw decisions made at C|Net that directly contradicted a/b statistics we had gathered. At Logical Awesome, that would never happen. It is neither logical nor awesome. Basically: I wanted to find the ideal company so I found good people and started it.

**AkitaOnRails:** Ok, so we come to the main dish of the day: [Github](http://github.com)! I can’t think of a better example of an innovative product that leverages so well the power of Git. I am very curious to understand how did you come with this idea? At the same time, lots of people still can’t understand why Railers as a whole started using Git so massively all of a sudden. Mercurial, Bazaar guys are very uncomfortable. What do you think Git has that attracted Railers in flocks like that? Or at least what do you think Git has that no other have? I started evangelizing Git here in Brazil last year after listening Randall Schwartz, and recently someone asked be about what would me my pick for a Rails killer-app and Github popped out of my mind, right away. So you do have good mind share as well.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/21/Picture_1.png)](http://github.com)

**Chris Wanstrath:** Github is super exciting to me because it’s really a website just for me. Tom and I are pretty similar in that we both have a fair amount of open source projects, all of which get used and patched by people we’ve never met.

Handling this the old fashion way was fine until me and P.J. started working on FamSpam… as my free time decreased, so did my ability to maintain my open source projects. And really, that’s a definite workflow problem. Sometimes when you can’t find enough time to do something, you just need to make the something take less time.

Github was literally written for chronic, god, ambition, will_paginate, and the rest of our projects. We wanted to make it dead simple for people to contribute, and really, it’s just not possible without Git.

I had started using Git right after viewing the [Linus tech talk](http://www.youtube.com/watch?v=4XpnKHJAok8) in May 2007, which is really good at explaining Git from a very high conceptual level. So when this time problem came up, I had already been using Git for a few months and Tom had serendipitously been trying to solve the same problem.

We talked after a local San Francisco Ruby meetup, at a bar of course (where all great ideas and partnerships begin), and decided to work on the problem together. I’d been playing with an err-specific Gitweb, but Github is obviously much more ambitious in its scope.

As far as the adoption of Git, I have no idea what single thing tipped it. When we began working on the app in October, we were worried about ./script/plugin and tarballs and windows and svn mirroring. we weren’t even sure we could build a business around Git, because subversion was still so utterly dominant.

As we all know, however, Git tipped at the start of 2008 and everyone somehow found the time to try it out. It maybe takes, like, two seconds to realize how much faster it is, and then a few more seconds after that to realize how much more awesome it is. So it’s not much of a surprise that it is grabbing converts.

As for the Rails community, it’s definitely because of the projects. When Merb, Rubinius, and Ruby on Rails all switch to Git, you have no choice. This is where the community is headed. As for other languages, we have a large number of non-ruby projects on Github. PHP, Java, Javascript, Lisp, Python — there are a handful of Django forks, for instance, the [io](http://www.iolanguage.com/) and [nu](http://programming.nu/) programming languages are also hosted on Github.

So really what it comes down to is early adopters, I think. Nu is a lisp written on Objective-C, very new and very cutting edge. The people using it right now are people who realize how powerful and awesome it is to run such a dynamic language on such a mature and stable platform. And naturally, the forward thinkers behind nu know that Git (and distributed source control) is an equally powerful, equally cutting edge concept.

With Prototype and Scripatculous moved over, and rumors of other Javascript frameworks switching, it’s only a matter of time before Git becomes even more widespread.

I think the Railers just like to blog a lot.

As far as other solutions go, it’s Rails vs Django all over again. If you use Mercurial, that’s fine. The two are so similar (yes, [Git does work great on Windows](http://kylecordes.com/2008/03/22/git-windows-works/)) that as long as people move to distributed source control, it’s still a win.

Oh, but wait, Mercurial doesn’t have Github :-)

![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/21/Picture_3.png)

**AkitaOnRails:** There you go :-) And I wonder what were the challenges of putting something as Github together. It is not a simple Rails web app, with very fast, pure Ruby code. You’re probably dealing with thousands of system calls to Git command liners, several background jobs, maintenance, security. What do you think were the biggest challenges while assembling Github before recently releasing it to the public?

**Chris Wanstrath:** Well you pretty much nailed it right there… scaling Rails is the easy part. scaling sshd, Git, Git-daemon, and our background jobs is the hard part.

We call Git directly many times per page, we need to process jobs that get entered from many different places (create a repo on the website, push a repo through ssh), we need to be secure (ssl and ssh for all private repos at all times), we need to make sure it all runs fast (memcached for both Git calls and the db), we need to make sure you’re _“in the loop”_ with a news feed aggregating information from all different sources within our system (almost 1m rows in the feed table when we launched).

So it definitely has not been easy. Not to mention that ssl is essentially the “slow flag” for http, so we need to make sure we’re going fast because things like your dashboard already have a speed handicap. As an example, sshd stores its keys in an authorized_keys file. Well, we weren’t even done with our beta yet and the keys file was over 4 megs of just plain text. So we had one of the C gurus at Engine Yard patch sshd for us to do mySQL based lookups, giving us faster searches and no pricey appending / writing of a massive file

Matthew Palmer is the said guru, and we plan to make that code open source in the near future.

We’ve also got post-receive (when you “Git push”) hooks running that we host and deliver – so if you push, we’ll POST to an arbitrary url for you with json of the commits. But you can also give us some info and we’ll post to campfire, irc, twitter, or lighthouse for you with custom payloads.

Since we have flash, flash with haxe, Python, c, ruby, bash scripts, lots of Javascript, and some forthcoming erlang under the hood, it’s definitely an interesting mix.

We are fortunate to be hosted on **Engine Yard** , though. If we didn’t have them we’d be screwed. Their awesome cluster setup with GFS means we can host our potentially 100s of gigs of repositories on a shared, raid’d drive with redundancy and backups. If we were running Github on a barebones VPS, I dont even know how we’d share access to those repos. It wouldn’t be fun.

They also have a lot of experts available 24/7, which is great because I have a tendency to forget to sleep and work until 7am. A lot of the pain of running a heavily unix-dependent site is taken away by those guys.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/21/Picture_5.png)](http://www.flickr.com/photos/ozmm/487496000/)

**AkitaOnRails:** Interesting, Erlang? I’d like to know what are you up to with it Going back, I think I saw a Rails trunk Git clone at Github way before DHH announced it a few days ago. I think it was Michael Koziarski who first did it, without much fuzz. Were you planning this together with the 37signals guys, or the switch of the Rails Core to Github was something that happened naturally? And do you have any kind of partnership with the Lighthouse guys as well, because you already have some hooks to manage Lighthouse tickets through Github commit messages, right?

**Chris Wanstrath:** The Erlang stuff will be very cool, I promise. We’ll make a big fuss about it when it’s ready. As far as the Rails thing goes, koz did indeed have a mirror of his Git-svn repo at Github during the beta. It was unofficial. Then in february he wrote a [post explaining](http://www.koziarski.net/archives/2008/2/23/on-Git) that the core was thinking about moving to Git.

When I saw the post I emailed him and we talked a bit about what it would take to move Rails to Github, which was obviously something I love on a huge number of levels. He said he would get back to me, and then a few weeks later the Core team contacted us and wanted to discuss the move. The rest is history.

I really respect the work the [Lighthouse](http://www.lighthouseapp.com/) team does. The bug tracker is great, and the new redesign is even better, but we don’t have any official partnership with them. We wrote the post-receive lighthouse hook because we wanted it, Rails wanted it, and a huge number of our users wanted it.

**AkitaOnRails:** Many others started moving to Github during the Beta. I think Merb was more obvious because of Ezra’s being involved in Engine Yard. Dr. Nic started using it for the Textmate bundles. Can you point any other high profile Rails related projects hosted at Github right now?

**Chris Wanstrath:** Merb was actually the reason Github went into beta. We launched the beta so they could start using the site for their 0.9 rewrite of merb-core. As far as popular projects, the best thing to do is check [http://Github.com/popular/watched](http://Github.com/popular/watched) and [http://Github.com/popular/forked](http://Github.com/popular/forked). Datamapper, Rspec, and Mephisto are some of the popular ones.

**AkitaOnRails:** Are you using vanilla Git code, or did you customize it in anyway to better fit your environment? Have you ever talked to Junio Hamano or any other Git core maintainer? With Github probably eating up a lot of your time, how is Chow and FamSpam going right now? How are you managing all those products all at once?

**Chris Wanstrath:** We’ve patched Git-daemon to record statistics, which we’ll soon be surfacing on the website soon in the form of better, more granular activity. You’ll be able to see how many times your project was cloned, popular projects in the last 24 hours, all time most cloned projects, that sort of thing.

We’ve emailed the core Git guys about the site, just to say thanks for writing Git and to let them know about Github, but haven’t really had an occasion to chat with them about anything in particular. If I ever run into any of them, I’ll definitely be buying them a few drinks, though.

I don’t actually work at Chow anymore. My last day at C|NET was almost exactly one year ago, so my Ruby time is spent on FamSpam, Github, open source, and doing occasional client work.

FamSpam is going well. Now that Github is launched, there are a handful of features we want to get in and all. Luckily, however, the site is very polished and has been running smoothly without the need for much intervention. What we’d really love to do, because it’s really just a great Rails-based mailing list, is try out some different concepts.

Maybe one for open source, or a version for little league teams – anyone who needs to keep in touch and have their email workflow and document sharing streamlined. For right now, however, I try to spend as much time as possible on Github. There are so many places we want to take it.

**AkitaOnRails:** I probably more than exceeded my interview time (sorry about that), but this conversation is super-interesting. One project I just remembered is Sake. To me Sake is very neat because many people complain about “how difficult and complex” the Git command line is, and Sake-like solutions make the workflow a lot easier. For instance, my entire Git workflow for Rails projects are only 4 small sake tasks like Git:update and Git:push. If I am not mistaken someone at Err did Sake, right? Are you still evolving it?

**Chris Wanstrath:** Yeah, I wrote [Sake](http://errtheblog.com/posts/60-sake-bomb). It’s not a Rails plugin but it was written to help in Rails development. The “Git tasks” for Sake are becoming quite popular, as Git really just facilitates a better workflow. If you want to implement it, or different branches of that workflow, you can pretty easily just wrap up a few commands into a rake task or bash script.

And while bash scripts are great, sake tasks are portable. A lot of sake was inspired, very loosely, on Git – you can pull in sake tasks from any text file, whether it’s on the web or local, and sake comes with its own daemon for serving your tasks.

So you could share tasks over wifi, or something, the same way you could share Git repositories over an adhoc network. Sake is up on Github, so feel free to add features you feel should exist.

**AkitaOnRails:** Another thing I would like to hear your opinion about. I recently made a presentation on Rails Deployment strategies for beginners. The most common simple architecture revolves around Apache/Nginx/Litespeed + Mongrel/Evented Mongrel/Thin/Ebb. It is usually a matter of load balancing between a Web server using some kind of IPC to distribute the load back to Ruby VMs running your Rails app.

Now we have mod_Rails. What’s your opinion on having all those choices, do you have any particular recipe you like or it depends on each application’s needs? Did you have time to test mod_Rails? I think Hongli Lai is doing great stuff in regards to things like mongrel_light_cluster and his efforts on making Ruby’s GC more copy-on-write friendly, did you take a look at that?

**Chris Wanstrath:** The nice thing about Engine Yard is they get to take care of all that stuff for me. So while I used to spend a lot of time benchmarking and playing with different solutions, like Mongrel vs Emongrel, I just let the experts take care of it so I can focus on Github..

So no, I haven’t played with mod_Rails yet because I’m not in the situation where I could deploy it even if I wanted to use it. Which is in my opinion the best situation to be in, and pretty much the reason mod_Rails was written.

**AkitaOnRails:** And by the way, are you going to make any presentation at RailsConf this year?

**Chris Wanstrath:** I am. I’ll be talking about _“Beyond cap deploy”_, which will pretty much be an in-depth look at the Github architecture, and then I’ll be on a panel with Ben Curtis, Geoff Grosenbach, P.J., and Tom about being a “profitable programmer” w/ side projects.

**AkitaOnRails:** I am very pleased to have the opportunity to talk to you.

**Chris Wanstrath:** Yes, you too. Thanks!

