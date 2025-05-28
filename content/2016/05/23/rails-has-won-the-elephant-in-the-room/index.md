---
title: 'Rails has won: The Elephant in the Room'
date: '2016-05-23T17:21:00-03:00'
slug: rails-has-won-the-elephant-in-the-room
tags:
- off-topic
- open source
- rants
draft: false
---

I just read a very [well written and important article](http://solnic.eu/2016/05/22/my-time-with-rails-is-up.html) from OSS contributor Solnic and I have to agree with him in almost every technical point.

First of all, it's inevitable but I still hate dramatic headlines, even though I write like this myself sometimes. "My time with Rails is up" like it's saying "And you should leave Rails now too if you're smart". I dismissed the article entirely because of that. I was about to post a counter-rant to that without reading it properly, but now that I have, I wrote this new article from scratch.

Solnic is right: Ruby, by itself, has little to no future alone. Rails is a real monopoly in this community and most OSS projects are targeting Rails. And yes, Rails do encourage some bad practices and anti-patterns. This can be very discouraging to many OSS contributors, specially because to change the direction of a huge Elephant takes humongous effort.

To make it clear, the dialectic technical arguments he makes are all true. But half the article - as he stated himself - is just rant, pure rethoric. And I think it would be good to balance it out, which is what I will try to do in this post.

### Accepting Reality

The reality is this: Rails is tailor made for Basecamp.

We all know that, or we should. Basecamp-like apps are not too difficult to make, at least in terms of architecture. You don't need fancy super performant languages with super duper highly concurrent and parallel primitives. Also a reality is that 80% of the web applications are Basecamp-like (disclosure: my feelings for years of experience in consulting). Which is why Rails has endured so far.

It's like content management systems, or CMS. Most of them are blog-like systems. And for that you should go ahead and install Wordpress. The very same arguments made against Rails can be done against Wordpress. And you should never, ever, tweak Wordpress to be anything but a blog-system. Try to make it into an e-commerce for high traffic, and you will suffer.

To make it clear: Wordpress has one of the most offensive source codes I've ever seen. I would hate having to maintain that codebase. I'm sorry if anyone from the Wordpress base of contributors is reading this, I say this without malevolence. And you know what? Possibly half of all CMSs in the world are Wordpress. Over a million websites.

Then you have the case for Magento2. Big rewrite over the original Magento, written using all the dreaded Zend stuff that everybody else dislikes. But it's huge. If you need a fast turn-key solution for e-commerce, look no further.

Do Wordpress plugins work with Magento? Nope. They are 2 fragmented, independent and isolated communities. But they both generate a lot of revenue, which is what covers the cost of redundancy between them. And this is not even counting Drupal, Joomla. PHP is one big ocean of disconnected islands. Countries with severe immigration laws.

Fragmentation is no stranger to the Javascript world. But it's a different kind of value generation. Facebook, Google, Microsoft, they all want to be the thought-leaders in the fast evolving Millenials generation. It's a long term strategy. And one of the elements of this game is the Browser. But not only in terms of Chrome vs Firefox vs IE, but also on how applications are implemented.

Facebook came up with React. Google came up with Polymer and Angular. The Node guys went through a power struggle with Joyent which almost resulted in further fragmentation but they settled for the [Node Foundation](http://readwrite.com/2015/02/10/joyent-node-js-foundation/). 

Apple went all on war against Adobe's Flash and then only now Google is [turning them off in Chrome](http://www.theinquirer.net/inquirer/news/2458329/googles-chrome-browser-will-switch-off-flash-content-by-default), but they are all looting on the consequences for all the attention it brings in the Web Development communities.

Apple wants native to succeed and Swift to be the one language to lead it all. Google has conflicting strategies because they want native [Instant Apps](http://techcrunch.com/2016/05/18/google-takes-a-new-approach-to-native-apps-with-instant-apps-for-android/) to succeed but if it fails, plan B continues to be for them to dominate HTML5/CSS3 based web apps with Angular. Facebook don't want to have their fate being decided by the power struggle between Apple and Google.

It's a complex power struggle unfolding, and you can see that it's not about technical prowess, it's not about value generation. It's about ego, influence and power. Very fitting for the YouTuber generation. And the web technologies are being held _hostage_ in this siege, if you havent's noticed.

Then there is the issue that Ruby's future is now tightly coupled with Rails. This is a reality and if you're a Rubyist that don't like Rails, I feel bad for you. But not so much. For example, if Hanami is interesting I believe at least one company invested on it. If no one is using it, then it doesn't matter how technically superior it is. If Rom.rb is great someone should be using it, otherwise what's the point? Why create a technical marvel that no one wants? But if there is at least one company using it, it's **enough reason** to keep going, regardless of what happens to Rails or what DHH says or does.

> People think that because something is "technically superior" everybody else should blindly adopt. But this is not how the market works.

Of all the cosmic-size events going on out there, I really don't sweat it that much if Ruby stays tied to Rails. What would it do without it?

All communities face fragmentation at some point. It's very difficult and expensive to maintain cohesiveness for a long time. The only community that I think achieved that through sheer force of regulation is Microsoft's .NET stack. It doesn't mean that there were no pressure from the outside. Rails itself played a big role into influencing the move from old-ASP.NET to ASP.NET MVC. Now they finally [acquired Xamarin](http://blogs.microsoft.com/blog/2016/02/24/microsoft-to-acquire-xamarin-and-empower-more-developers-to-build-apps-on-any-device/) before .NET could steer out of their control in open source platforms they don't control.

Ruby on Rails is the only other "cohesive" community I've seen. With the upside that Basecamp doesn't need hundreds of thousands of developers to exist. A niche market would suffice, enough for the framework to evolve gradually through OSS processes. Which is why I always question the history and origins of tools and technologies to make my decisions on where to use them, not just technical prowess.

Rails works because it doesn't have to play politics with Apple, Facebook, Microsoft, Google or any other committees (by the way, by default, I never trust committees). Those who depend on Rails will do the house-keeping, directly. Heroku, Github, New Relic, Shopify, and many talented developers.

### 3 Laws of Market Reality

1. It's easy to over-analyse something after the fact. 10 years down the road, I can easily trace back an optimal path, avoiding all boobtraps and obstacles along the way. Doesn't make me any genius, just shows that I can connect the - now clearly visible - dots.

2. No solution implementation is perfect. If it actually solves a real problem it's bound to be imperfect. If it solves a real problem in a fast paced changing market, the more imperfect.

3. Either you build tools because your core business applications depend on it or you build tools to sell. The former will usually be better - in terms of market-fit - than the latter. So if you have to blindly choose, go with the former.

So, first of all, I will always prefer tools that solve a real problem made by those that actually depend on them. Otherwise, the shoemaker's son will end up barefoot. Case in point: I will definitely use Angular, if I have to. But I would never, ever, begin a new business that depends solely on Angular to survive. Why? Because Google doesn't need it. It didn't blink to give up GWT, it didn't have to think twice to decide to rewrite Angular 2 in an incompatible way to Angular 1, and so on.

Second of all, I will always see what other external factors will influence the fate of the technology. Imagine that I spent a whole lot of time writing scripts, libraries, tools for Grunt. Then people decide it's bad. Now Gulp is the better choice - and you will find plenty of technical reasons. Now you invest a lot of time writing everything you had for Grunt to Gulp. Then, for plenty of other reasons people decide that Webpack is the best choice. And there you go again. NIH (Not-invented-here) syndrome gallore.

This is clearly a small bubble. It's tulips all over again. There are too many big players (Facebook, Google, Apple, Microsoft, Mozilla, etc) with big pockets, plenty of time and resources. This is how an experimental lab works in public. Lots and lots of experimental alternatives and several businesses blindly choosing depending on the best sales pitch of the week.

Sometimes this kind of situation makes the monopoly of ASP.NET on the Microsoft camp and the Rails monopoly on the Ruby camp seen innocuous. And yes, I compared Rails to .NET here. They are the 2 most comparable stacks. Possibly comparable to Spring faction in the Java camp. If you remember the history, Spring was like Rails in the Java community, rising up against the humongous complexity of the official J2EE stack back in 2002. And then Spring itself became the new J2EE-like behemoth to beat.

This is a millenia old dillema:

> "You either die a hero, or live long enough to see yourself become the villain."

### Why is Rails a problem now?

As I said before, I agree to almost every technical problem that Solnic outlined.

Rails is indeed the brainchild of David Hansson (DHH). DHH is a person, with a very big ego, and a business to run. You can't expect any person to be reasonable all the time, specially one that pushed something up from zero, both a business and a technology platform.

When it started, people defected from Java, .NET, PHP even Python, in droves and they all acknowledged how interesting Rails was compared to J2EE, ASP.NET, Plone. It offered not only productivity but technical enjoyment. We were discussing the wondreous world of dynamic languages, open classes, injecting behavior on the fly (aka [monkey patching](https://m.signalvnoise.com/provide-sharp-knives-cc0a22bf7934#.zcxl5lbh8)), we all stood up and aplauded dropping all unnecessary abstrations.

We could not have enough of our Ruby fix, spitting out all the Perl-like magic we would accomplish in a language that didn't feel ugly as PHP or bureacratic like Java or C#. And they all laughed.

The Golden Age from 2004 to 2006 saw a never ending stream of celebratory masturbation of Perl-like coding prowess. We learned Ruby through [Why, the Lucky Stiff](http://poignant.guide/) most obscure black magic, remember that? It was everything but clean and modular architectures.

Then we entered the Silver Age, from 2007 to around 2011. Rails actually went too far, too fast. Suddenly we saw big companies popping up from everywhere! Twitter, Github, Engine Yard, Heroku, Zendesk, Airbnb, everybody drunk the Rails cool aid. The opportunity was there to offer something for the enterprise. Merb was ahead of its time and it was pitched the wrong way. I do think that confronting the almighty Rails upfront, at that point, was not smart. You should expect overreaction and it did came and it was a swift blow. I will be honest and say that I was very aprehensive in 2009 and 2010 to see if the Rails 3 pseudo-rewrite, pseudo-Merb-merge would actually come through.

2011 to 2016 was the Bronze Age, a bittersweet period. That's because many new languages have emerged and finally reached "usable" state. From JS's V8 and Node.js, to Rust, to Clojure, to Elixir, and even some gems from the past started to get attention, such as Scala and even Haskell. The most important change of all: 2010 saw the advent of the Walled Garden App Store, commercially available native applications for smartphone and tablets. Forget web development: mobile was getting it all.

And that's when all the big companies started to show their deep pockets. Apple releases Swift. Google released Dart, Angular, Go. Microsoft released Typescript, ASP.NET MVC then vNext and had it's hands full working on Windows 10. Facebook entered the game late by releasing React and then React Native.

Rails can now be considered a "problem" for the very same reasons that made it popular in the first place. And this is bound to happen to any technology.

But you can't change the architecture of Rails too much, otherwise you risk breaking down very big chunks of the projects that are deployed in production now. And when someone has to rewrite big chunks of a project you might as well consider rewriting it in something else entirely.

Many people are doing exactly that, specially for APIs and web applications implemented as SPAs talking to APIs. The APIs can be written in Go, Elixir, Scala and avoid Ruby altogether. You lose the fast turn around of the Rails ecosystem, but if you can afford it (you're a Unicorn startup with deep pockets), why not?

But again, for the 90% of small to medium projects out there, you can still get the best punch for the buck using Rails and all the libraries available for Rails. It's like saying, if you want to build a blog, go for Wordpress and you will get the best benefit for the limited resources you have. Don't try to be fancy and write an SPA blog using Go APIs with React from scratch. Feasible, but not worth it.

If you're a medium company already using Rails for some time, first of all make sure you adhere to basic best practices. Add tests and specs if you haven't already. Steadily refactor code, remove duplication, upgrade gems. Then you should consider adding an abstration layer such as [Trailblazer](http://trailblazer.to/) and possibly consider componentizing parts of your application as [Rails Engines](https://leanpub.com/cbra) or removing those parts into separated [Rails-API](https://github.com/rails-api/rails-api) applications to be consumed, if possible. But do one step at a time, as needed.

> One rarely benefits from big bang rewrites from scratch.

### Conclusion

So yes, for developers such as Solnic the Rails community is probably a frustrating place to be. But it's also an addiction that's hard to drop because Rails is so much larger than any other competitor in any other new and fancy platform, you always feel bad for being the underdog.

Rails went from underdog to mainstream in 5 years. Possibly the fastest growth any web framework ever achieved. The life of a web developer from 1995 to 2003 was not particularly interesting. Rails did a lot to improve it. And if anyone thinks they can do better, just do it. What's the point of writing about Rails? More than just code competing against code, results should compete against results.

Active Record's architecture will indeed hurt hard maybe 10% of the cases out there. Active Support does not have a better alternative so far, and just removing it won't bring anything of value for the end user. Replacing a big component such as Active Record for something "better" such as an improved version of DataMapper or Rom.rb as the default again won't bring so much value, specially for the hundreds of applications out there. You're telling everybody to just rewrite everything. And if I would have to rewrite, I would definitely do a new application using Rails + Trailblazer or go straight to Hanami. But most people would decide in favor of ditching Ruby altogether.

Could Active Record be better? Sure! We have old Data Mapper, Sequel and ROM.rb to prove it. But the real question is: could it be done better back in 2004 when it was first created? I don't think so. Now even the creator of DataMapper advocates for No-ORM. In 2004 "NoSQL" wasn't even a thing. The best we had back then was Hibernate, way before JPA! And for all intents and purposes, Active Record still does much better than average. But if you're big, you should be careful. That's all.

The other communities will face the same predicaments we are now facing in the Rails community. It's inevitable. Everything is so much easier when you have a small community that even if you break things it won't be too bad. It's much harder to maintain something that actually became big beyond your most optimistic scenarios.

I do understand the conservative approach DHH is taking by not making big disruptions. If this is something he is doing because he believes in conservative moves or because he doesn't understand better architectural options is not up to me to judge, but it's a valid move that will alienate advanced developers like Solnic but still allow for beginners to jump right into it without worrying too much right now about too many abstractions.

Update: DHH commented on this section later:

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr"><a href="https://twitter.com/AkitaOnRails">@akitaonrails</a> It’s not out of conservatism. But a difference of opinion and values. I love Active Record. Love callbacks.</p>— DHH (@dhh) <a href="https://twitter.com/dhh/status/735051111141396480">May 24, 2016</a></blockquote>

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr"><a href="https://twitter.com/AkitaOnRails">@akitaonrails</a> Will everyone love the same techniques and methods as me? Of course not (see RSpec for just one popular example!). That’s fine</p>— DHH (@dhh) <a href="https://twitter.com/dhh/status/735051237071171584">May 24, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

People forget that abstractions are very nice for advanced developers that had suffered the lack of them. But beginners will always suffer if presented with too many architectural choices upfront. Understanding GoF Design Patterns, Data-Driven Design, SOLID, Enterprise Architectures, etc is very overwhelming. Experienced people often forget the learning curve when they were themselves beginners, and at that time Rails was so attractive, so sexy. Remember that feeling? Of accomplishment in the face of the knowledge that some nice witch left super useful black magic behind?

**Rails has won** for it's simplicity for beginners, having a "rails"-like guidance for experienced people as well, and _somewhat acceptable_ flexibility for more advanced developers. Will it be able to maintain another 10 years in face of the many smaller alternatives out there trying to recreate everything from scratch? Time will tell.

I think it would be a good fit to finish with Bob Dylan:

> Come gather 'round people

> Wherever you roam

> And admit that the waters

> Around you have grown

> And accept it that soon

> You'll be drenched to the bone.

> If your time to you

> Is worth savin'

> Then you better start swimmin'

> Or you'll sink like a stone

> For the times they are a-changin'.

> ...

