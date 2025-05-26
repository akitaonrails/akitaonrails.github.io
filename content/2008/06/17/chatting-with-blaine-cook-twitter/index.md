---
title: Chatting with Blaine Cook (Twitter)
date: '2008-06-17T00:29:00-03:00'
slug: chatting-with-blaine-cook-twitter
tags:
- interview
- english
draft: false
---

Ruby on Rails is **big**. Twitter is **big**. And because of that they became easy targets for the media and the frustrated pundits wanting a few more pageviews. “Blaine Cook” was one of Twitter’s developers and he kindly agreed to participate on one of my interviews. And, of course, he will answer the question _“Does Rails Scale?”_

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/2299866775_385f7af555.jpg)](http://www.flickr.com/photos/hyku/2299866775/)


 **AkitaOnRails:** So, let me first explain that my main goal when I interview high profile people like you is to bring good information for our growing Rails community in Brazil. It is always good to ask about your background, how did you get into Rails and what was your experience with it.

**Blaine Cook:** I started with Rails on a small personal project back in December 2004, after Evan Henshaw-Plath ([rabble](http://2008.xtech.org/public/schedule/speaker/283)) got really excited about Ruby & Rails.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/43021932_545efed570.jpg)](http://www.flickr.com/photos/foolswisdom/43021932/)

Shortly afterwards, I started working on [Odeo](http://www.odeo.com). I really like Rails, and I’ve really enjoyed my experience with it. Building web-apps used to be a real pain (i.e., boring) because you ended up building the same pieces over and over again.

Rails fixed that. There were frameworks before, but Rails reframed the question in a humane way, and we see that in all the other frameworks that have been created afterwards.

**AkitaOnRails:** So, what were you doing before Rails then? Enterprise Java? Microsoft stuff? Other open source projects?

**Blaine Cook:** I mostly did PHP and Perl, in the context of open source projects and consulting jobs.

**AkitaOnRails:** So, **Odeo** and **Twitter** are your biggest projects in Rails then? Before digging into Twitter, can you tell us how was your work for Odeo?

**Blaine Cook:** Sure – Odeo was fine – the big problem there was with focus. Podcasting hadn’t been proven (and the form that podcasting takes now is much different than what people envisioned in 2004 / 2005), so it was a struggle to gain traction for the product.

We had all sorts of cool things built, many of which are just becoming products now. Things like multi-track mixing on the web, video messaging (like [seesmic](http://www.seesmic.com/)), etc.

**AkitaOnRails:** This is an interesting side-subject: podcasting. I do a [Brazilian Rails podcast](http://podcast.rubyonrails.pro.br/) with a friend and nowadays people are very acquainted with podcasts. What was the vision 3, 4 years ago about what podcasting would become?

**Blaine Cook:** I think that’s fairly similar, but it seems like most of the traction (i.e., listeners) for podcasting is established thru radio shows that are seeking a wider distribution.

I think there was a sentiment that podcasting would be much more popular amongst bloggers in general. Everyone was going to have a podcast.

But in reality it’s a medium with far fewer publishers than blogging.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/2303816926_beafddbb5c.jpg)](http://www.flickr.com/photos/jolieani/2303816926/)

**AkitaOnRails:** You helped start Odeo, I mean were you one of the creators? Or were you hired to solve their problem? And why did you leave Odeo?

**Blaine Cook:** No – I started at Odeo a few months after development had started. I never really left Odeo – the product was sold, and the company continued on as Obvious. Twitter was a side-project at Odeo.

**AkitaOnRails:** Ok, and Twitter is big nowadays. Could you give us a glimpse of how the whole idea of _“What are you doing”_ started? Did you think at that time that it would become such a success as it is now?

**Blaine Cook:** Twitter was started as a side project at Odeo, but really it was an idea that [Jack](http://www.stonetemple.com/articles/interview-jack-dorsey.shtml) had been kicking around in various forms for several years.

He and **Noah Glass** (the founder of Odeo) created a small sub-company within Odeo to work on it, in spring 2006. Initially, I hated the idea, mostly because it was intended to be SMS-only.

It’s hard to say looking back, but at the time I’d say Twitter was a long shot; I think that it was successful had a lot to do with luck and openness.

**AkitaOnRails:** So, maybe one of the biggest reasons for Twitter’s success was also its Achilles’ heels? I mean the paramount API based access it has today?

**Blaine Cook:** Yes, absolutely.

**AkitaOnRails:** So, getting to the hairy stuff, it quite is obvious that [Michael Arrington](http://www.techcrunch.com/2008/04/23/amateur-hour-over-at-twitter/) dislikes Twitter, period. And specially he has something [against you](http://www.alleyinsider.com/2008/4/lead_architect_blaine_cook_out_at_twitter) personally, at least considering the tone of his articles on Techcrunch. Can you comment on that?

**Blaine Cook:** Not really; I don’t know why he has a grudge. It’s mildly annoying, but in the end it makes Techcrunch look more like a gossip rag and less like a respectable news outlet, so it’s his loss.

**AkitaOnRails:** And not only that but it also seems that some tech related news media wants to co-relate Twitter’s instability with the fact that part of its front-end is powered by Ruby on Rails, hence the discussion _“Does Rails scale?”_. As a Railer this seems quite obvious that relating Rails and instability generates lots of pageviews. Do you think that’s the case?

**Blaine Cook:** I think that’s at least part of it. Obviously page views are a huge draw.

**AkitaOnRails:** Maybe it would be good for someone like you to explain to our audience the difference between **‘performance’** and **‘scalability’** as it seems that most people don’t know the difference between the two.

**Blaine Cook:** Performance and scalability are very different things. Performance is like the speed limit; it’s a question of how quickly you can get from point A to point B. In this case, we’re talking about how quickly you can get a page rendered and delivered to the user.

Scalability is a question of how many users you can handle. Highways intrinsically don’t scale, for example, because when they’re full, you get traffic jams. In web architectures, what we aim to provide are systems that will expand (usually by adding more hardware) to handle more traffic.

Obviously they’re related – if you have a traffic jam, then the effective speed limit is lower than the theoretical limit. But increasing the speed limit won’t make traffic jams any better.

There are a whole bunch of ways to make traffic less congested – adding more lanes to the highway, encouraging people to use public transit, or better yet encouraging people to work closer to home.

Likewise, there are many techniques for making web sites more scalable, and most of them don’t involve making things much “faster”.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/2476619970_af72edc5ef.jpg)](http://www.flickr.com/photos/gavinbell/2476619970/)

**AkitaOnRails:** Great explanation. Twitter was involved in some not very good controversy since last year, and I think you were not involved in most of them, but maybe you could shed some light on those issues as some people don’t follow every news all the time. The first one being that interview where [Alex Payne](http://www.radicalbehavior.com/5-question-interview-with-twitter-developer-alex-payne/) complained about Rails not supporting multiple databases. **David Hansson** ranted about it. Then [Dr. Nic](http://drnicwilliams.com/2007/04/12/magic-multi-connections-a-facility-in-rails-to-talk-to-more-than-one-database-at-a-time/) came to the beginning of a solution. Can you explain this matter for our audience?

**Blaine Cook:** Sure – it’s true that Rails doesn’t support multiple databases out of the box, but this is easily fixed. I think the interview with Alex didn’t get into the details very well, and mis-represented our challenges.

If it was just a matter of supporting multiple database connections, that’s something that’s easily solved. The real problem was much more complex, and had to do with custom sharding for our particular dataset.

**Eran Hammer-Lahav** has an excellent series (parts [1](http://www.hueniverse.com/hueniverse/2008/03/on-scaling-a-mi.html), [2](http://www.hueniverse.com/hueniverse/2008/03/scaling-a-micro.html), [3](http://www.hueniverse.com/hueniverse/2008/04/scaling-a-micro.html)) in which he describes some of the challenges associated with building microblogging sites to scale.

None of the things he describes in the article are hard to do with Rails. In fact, I think that David (Hansson) is wrong when he says that Rails isn’t flexible – it’s actually much more flexible than most other frameworks.

**AkitaOnRails:** That’s right. And then the other recent controversy is, of course, because of [TechCrunch](http://www.techcrunch.com/2008/05/31/hey-twitter-i-have-a-few-questions-too/) again, where they state that Twitter only has like half a dozen servers and that’s why it falls down frequently. Can you roughly describe how is Twitter’s hardware architecture?

**Blaine Cook:** Twitter has a lot of servers, definitely more than half a dozen. I can’t go into more detail about the hardware setup, but I can say that the back end is an asynchronous messaging-based system. [Starling](http://rubyforge.org/projects/starling/) (the queue server that I wrote that Twitter released in January) is the mechanism used to pass messages between processes.

The biggest problem is that Twitter deals with many, many often expensive API requests due to the frequent polling required to stay up to date with your friends’ most recent tweets. The big challenge was to come up with an inexpensive way to make those expensive API requests cheap.

We used memcache extensively, and had a whole bunch of caching in place well over a year ago, but it wasn’t enough.

**AkitaOnRails:** Last year Alex and Britt spoke at RailsConf I think about [Scaling Rails](http://www.slideshare.net/eraz/scaling-rails-presentation/) where it felt like Twitter’s problem would end soon. It was mostly about caching and optimizations like that, and one of the main messages was _“cache the hell out of it”_. I saw you speaking this year about database sharding and how different it is to architect for 1k people and for 1 million people and that you can’t predict what to do before that. Twitter still goes down sometimes, so what changed between last year and now about Scaling Rails?

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/2329021397_3dde02123a.jpg)](http://www.flickr.com/photos/x180/2329021397/)

**Blaine Cook:** Yes – we knew for a long time that database sharding was important, but for various reasons weren’t able to move forward with it.

The thing with sharding is that until someone comes out with something like what Google has (and I don’t mean Bigtable), the sort of shape your application takes before sharding is very different than the shape afterwards. Sharding makes doing some things harder, and is generally expensive.

When people say “sharding” or “denormalization”, what they mean is _“duplicating data in particular ways to make certain lookups faster.”_

That always involves additional cost. If you’re building a new app that will either never see hundreds of thousands of users, or if you don’t know if it will or not, it’s generally not worth sinking lots of money into hardware and engineering time to build a “scalable” architecture.

The reality is that most developers know SQL and can build CGI applications using PHP or Rails or whatever, but relatively few have experience taking those straightforward, normalized data sets and breaking them up into much more complex sharded systems.

**AkitaOnRails:** Of course, sometimes people feel like they will actually build the ‘next’ Twitter. I [interviewed Ezra](/2008/6/5/railsconf-2008-brazil-rails-podcast-special-edition), from Engine Yard, at RailsConf and he seems to acknowledge that the friends-of-friends graph is a problem so complex that whoever figures it out will make a ton of money I mean, isn’t it the case that traditional SQL designs don’t work all the time?

**Blaine Cook:** Of course – the question is, what else are you going to use? Google has an architecture that lets them spend infinite amounts of money to build denormalized lists of everything, and access those lists quickly. There are a number of projects – HBase, Hypertable, CouchDB, and many others – that aim to solve these problems, but none of them are ready for production use.

The reality is that 10 years ago, people were building web applications with tcsh, and now we have better tools.

**AkitaOnRails:** Where is Twitter hosted? For some reason I saw Engine Yard pitching a lot about scalability issues throughout the whole RailsConf this year. Do you think this whole “Rails doesn’t scale” meme is making Railers worried about future prospects? Even though it was not supposed to scare that much as we do have higher traffic websites such as Scribd and YellowPages in the top of the list – though the architectures are world apart, of course. What do you think about this issue?

**Blaine Cook:** I’m not sure, but I think Twitter actually does more traffic than YellowPages or Scribd; the API is a really killer.

**AkitaOnRails:** Ah, I see, Alexa and others don’t account for API request, right?

**Blaine Cook:** Twitter is hosted at NTT / Verio. I think there was a blog post about it in February. Right, Alexa doesn’t account for API / SMS / XMPP traffic at all.

As far as the perspective that Rails doesn’t scale – I think it’s an unfortunate side-effect of Twitter’s issues, to be sure, and I think some people worry about it. To put things into perspective, though, Friendster was written in Java to start, and switched to PHP. Myspace was written in ColdFusion and transitioned to ASP.NET.

When people run into problems scaling sites they often think that the language is the problem, but I think it’s rarely the case.

Ruby is slower than PHP or Java (depending on which framework you use) or, well, most languages, but it’s getting faster. And “slower” really only translates to additional cost.

**AkitaOnRails:** Which reminds me of the last controversy which was [Twitter switching off from Rails](http://www.techcrunch.com/2008/05/01/twitter-said-to-be-abandoning-ruby-on-rails/). The case is that you already have a mixed environment, right? Most pundits think they ‘know’ how to solve Twitter’s problems, though they have absolutely no idea what they are talking about. Some blame Rails, others blame MySQL (_“go to Oracle”_, they say). Can you elaborate on that?

**Blaine Cook:** Right – the majority of our development was in Ruby / Rails, but there was code in other langauges. Python, Java, and there were some experiments with Scala. Which ignores the fact that we ran significant portions of our infrastructure on non-Ruby code – Apache, Mongrel, MySQL, memcached, ejabberd, etc. are all great applications and critical to building scalable sites.

Oracle definitely has some of these things figured out, but it’s much easier to hire for MySQL, and Oracle licensing and support fees are nothing to scoff at.

Building your architecture around a system that will only get cheaper with time, rather than more expensive, is always a good idea.

**AkitaOnRails:** And I have to ask, can you disclose some meaningful numbers, or orders of magnitude, such as tweets per day, average downtime, or something like this, just so we can have an idea of the size of Twitter’s problems? Coming from someone that has actually had to deal with such a huge situation – which most people probably will never have to face -, what would you say are Ruby/Rails’ strongest features for you?

**Blaine Cook:** Sadly, no – there are plenty of estimates on the web, most notably compete, and Dave Winer’s fan-out numbers.

I think Ruby’s best feature is that it’s **fun to develop** with. It never stops being fun, either. It’s an expressive and powerful language. Rails just makes web development painless, compared to doing everything by hand. That’s something that shouldn’t be underestimated, or whose value forgotten.

On top of that, they’re really flexible. We needed to build a denormalization tool, for example, and doing it in Ruby was just as easy / hard as any other language, except when it came to tying it in to the rest of the system – no search and replace, no subclassing or anything. Just turn it on, and it works.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/440202833_77152b8080.jpg)](http://www.flickr.com/photos/niallkennedy/440202833/)

**AkitaOnRails:** Finally can you tell us why you left Twitter? What are you new endeavors? Twitter survived WWDC last week which is saying a lot considering such huge events would usually bring it down in the past.

**Blaine Cook:** I’m moving to the UK, and Twitter is / has moved into a position where their primary focus is reliability. When I left, the hope was that their system was stabilized, and the roadmap was clear as far as putting them in a better position overall. At the time, they’d had an extended period of uninterrupted uptime, and had survived with flying colours [SXSW](http://sxsw.com/). Unfortunately, it didn’t last, but it looks like things are better again.

I’m not yet ready to reveal what’s next, but I have a number of exciting things going on. I’ll continue maintaining Starling and [xmpp4r-simple](http://code.google.com/p/xmpp4r-simple/), and I’m still active with the OAuth spec. working group.

**AkitaOnRails:** In the end, Twitter became almost part of our culture already (at least in our tech world). People complain when it is down because now they depend on it so much. People like Michael Arrington, Robert Scoble, Leo Laporte are always complaining, saying they would move to Pownce or Jaiku, but they are still around. Do you have any guess on why Twitter users are so loyal?

**Blaine Cook:** Nope! I think the really rich landscape of tools that you can use to interact with Twitter on your own terms is a really big part of it. A lot of the users are personally invested, and they want to see that investment pay out.

**AkitaOnRails:** Ok, I think this covers everything Any closing remarks for our young Brazilian Rails community?

**Blaine Cook:** The web is remarkably young, and there’s plenty of space for really amazing things to happen. I’m always excited to see what people are working on, and what’s possible with this whole Internet thing. For all of Arrington’s petty and misinformed comments, I think sites like Techcrunch and [Mashable](http://www.mashable.com) and [Silicon Alley Insider](http://www.alleyinsider.com) are interesting because they present a never ending stream of amazing things that people are building on the web.

The financial focus is unfortunate, as there are plenty of apps that survive and provide income for their founders without ever needing to scale to galactic proportions.

The bottom line is that there’s plenty to do, and don’t worry about scaling or business model or anything – unless you’re passionate about what you’re doing, none of it matters.

If you are passionate about what you’re doing, there’s a really good chance you’ll figure the details out.

**AkitaOnRails:** Fantastic! Thank you very much for you kindness, I am sure my audience will enjoy it. And just to let you know that we, Brazilians, **do** tweet a lot! :-) Thanks!

**Blaine Cook:** Excellent, glad to hear! No problem, thanks for being a great interviewer.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/2300104137_96c83ac13d.jpg)](http://www.flickr.com/photos/briandewitt/2300104137/)

