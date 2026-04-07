---
title: Evolution Through Competition
date: '2006-09-27T16:13:00-03:00'
slug: evolução-pela-concorrência
translationKey: evolution-through-competition
tags:
- off-topic
- principles
- markets
draft: false
---

 ![](/files/402px-AdamSmith.jpg)

I don't remember whether I wrote about this in a previous post or in my book, but there's a common sense principle I call **"Evolution Through Competition"**. Debates like _"Ruby VS Java"_, _"Rails VS J2EE"_ are not exclusive to the Ruby on Rails (RoR) community — not by a long shot. Let's list some recent discussions in the tech world:

- Firefox VS Internet Explorer
- Macs VS PCs
- Windows VS Linux
- C# VS Java

Microsoft is the perennial villain. It operates in practically every segment of the computing market, so it will always be a target for criticism. _"Windows is bad"_, _"Office sucks"_, _"Internet Explorer is garbage"_, _"Visual Basic isn't a real professional language"_, etc. Some arguments are valid; others are just narrow-minded grudges.

Criticism is constructive when people actually do something about it. Radicals serve no purpose in this world. People who only rant and never act are irrelevant: **_"if you're not part of the solution, you're part of the problem"_**.

Kudos to everyone who channeled their dissatisfaction with the status quo into creating high-quality alternatives to Microsoft's criticized products. None of them are perfect, but the dedication deserves recognition. Today I use only Firefox (or [Camino](http://www.caminobrowser.org/) on Mac, which uses the same Gecko engine). Linux, thanks to technological backing from giants like IBM, gained advanced filesystems like AIX's JFS, Irix's XFS (Silicon Graphics), support for [NUMA](http://lse.sourceforge.net/numa), clusters, more advanced [thread](http://www.onlamp.com/pub/a/onlamp/2002/11/07/linux_threads.html) management, virtualization like [Xen](http://kerneltrap.org/node/4168), and much more — all of which made it a credible alternative for large servers.

Apple is no longer an intransigent company either. It learned to acknowledge its mistakes and make increasingly efficient transitions. From Motorola processors to IBM PowerPC, from the obsolete MacOS 9 to the advanced Unix-kernel-based MacOS X, and now moving from IBM PowerPC to Intel Core Duo and Core 2 Duo. Change in order to evolve.

Microsoft, for its part, isn't sitting still. Watching competitors rise against it, the company built a system to address most of the criticism: Windows Vista. Despite several stumbles and delays, it promises to be a robust and modern system. Better than Linux? Better than MacOS X? Who knows. But evolution is happening. Same story on the development platform front: threatened by Java, they created .NET as an alternative. Both have strengths and weaknesses, but .NET has fantastic features that cannot be ignored.

This isn't unique to IT. It's an inherent characteristic of [capitalism](http://en.wikipedia.org/wiki/Capitalism) — the intelligence built into the competition system is that it inevitably drives evolution. Companies today are better than they were ten or twenty years ago. That's the exact reason monopolies need to be broken up.

Look at Brazil's telecommunications market. When we suffered under the inefficient state monopoly known as Telebrás, getting a phone line took months and cost obscene amounts of money. Today, with competitors like Telefonica and Embratel, a line can be acquired practically overnight at a reasonable price. The service is far from perfect (just check the Procon complaints), but it's undeniable that things only started improving after privatization.

So what does any of this have to do with Rails? A corollary of this pattern is that technologies that are rarely discussed, rarely criticized, tend to stagnate — or worse, get forgotten. It's the same effect as monopolies: if a company goes too long without competition, it experiences the opposite effect — it gets comfortable, deteriorates, destabilizes, until finally a competitor comes along to unseat it. That's why, in a healthy market, competition is essential.

Look up technologies like [BeOS](http://en.wikipedia.org/wiki/BeOS), languages like [Nemerle](http://nemerle.org/Main_Page), [Scheme](http://www-swiss.ai.mit.edu/projects/scheme/). Despite small niches, they were forgotten by the market at large. That doesn't mean they were bad — but for various reasons, they weren't criticized enough, weren't scrutinized enough.

I've gone through all of that to get to this point: Ruby and Rails are under constant criticism, being observed with precision, being examined without ceremony. And that's excellent. All the gears of evolution are in motion. Thanks to all this attention — all the criticism, doubts, and skepticism — smart people from the community stepped up to fill the gaps, pushing RoR rapidly to levels it wouldn't have reached on its own. Let's look at some examples:

##### RoR doesn't support Internationalization

For some, this is a serious shortcoming. Even more serious because the Ruby language itself isn't very Unicode-friendly. Remember that Ruby was built in Japan, for the Japanese, in the early 1990s. I went into detail on this in the book, but in short, today we have solutions like [Globalize](http://wiki.rubyonrails.org/rails/pages/Internationalization).

##### RoR doesn't have an equivalent to EJBs

True, despite being extremely bureaucratic, current EJB containers are quite robust. RoR is essentially equivalent to just the servlet container in a complete J2EE system. But thanks to **Ezra Zygmuntowicz** we now have [BackgrounDRb](http://www.infoq.com/articles/BackgrounDRb). It works somewhat like a Message Bean for executing asynchronous tasks. Not necessarily better, but it's a solution.

##### RoR is nothing but a template generator

It's the same old scaffolding conversation. Many newcomers or poorly informed critics believe Rails is just the scaffold method. Of course, they're completely wrong. We can't deny it's an incredible concept, difficult or impossible to achieve in static languages. However, Rails' default Scaffold is very basic. It lacks features like interpreting relationships between tables, for example. Several alternatives have emerged, but the most interesting are Streamlined and AjaxScaffold, as I [mentioned](http://www.akitaonrails.com/2006/09/27/snakes-vs-rubies-scaffold-on-steroids) in a few earlier posts.

##### RoR only works well for Green Field projects

_"Green Field"_ is what we call projects started from scratch — no legacy, where we have the freedom to choose the implementation. Where we can start a project using Rails conventions. The problem arises when you try to implement a Rails module on top of an existing database that's completely outside of Rails conventions. In that case, you have work to do. To ease things, Robby Russell is writing the [Acts as Legacy](http://www.robbyonrails.com/articles/2006/04/14/sneaking-rails-through-the-legacy-system) plugin, an Active Record extension that should make things easier.

##### RoR uses scriptlets: code mixed with HTML — that's terrible

This debate never ends. Rails' view rendering engine, ERb, does in fact use the equivalent of JSP or PHP scriptlets, where we mix raw Ruby code directly into HTML. In Rails' specific case, it's actually a great feature. But there are those who prefer something closer to taglibs: HTML free of programming logic, especially when you want to involve Web Designers. A great alternative is the [Liquid](http://home.leetsoft.com/liquid) project, which brings functionality similar to the Velocity framework from the Java world. That way we can keep everyone happy.

##### RoR alone is too raw. Python, for example, has Zope/Plone

Rails is a framework. Some want to extend the fight by implying Rails loses to, say, Zope. For those unfamiliar, Zope is an excellent content management system (CMS) written in Python. Of course, a CMS and a framework is comparing apples and oranges. But several smart solutions are being written in Rails. In the CMS space (content, blogs) we have products like the well-known [Typo](http://typosphere.org/) or [Mephisto](http://mephistoblog.com/). As an eCommerce solution there's [Shopify](http://shopify.com/).

##### RoR can use good Design Patterns but doesn't implement newer concepts like Rules Engines

A Rules Engine, or Business Rules Engine, is a layer of intelligence for managing business rules. It's a relatively recent concept still maturing, which means different vendors will implement it differently. In the Java world one of the most famous is JBoss Rules (Drools), but in the Ruby world we already have an alternative called [Rools](http://rools.rubyforge.org/).

##### RoR doesn't have as many libraries as Java

True. Despite the Ruby language being over 10 years old, despite Rails gaining new plugins all the time, it's undeniable that Java has an enormous library ecosystem — rivaled perhaps only by C/C++. A new development could change that: **[Sun recently hired the creators of JRuby](http://weblog.rubyonrails.com/2006/9/7/sun-hires-the-jruby-team)**, a way to run Ruby code directly on the JVM, opening the door for Ruby code to access all of Java's libraries. If Sun does its homework right, we'll soon have a version of Ruby running on the JVM with high performance, robustness, internationalization support, and access to an enormous library ecosystem.

##### Finally, why was Rails built in Ruby? Couldn't there be a "Jails" or something similar?

Indeed, many question why Rails is written in Ruby. At first glance it seems like nothing more than a programmer's grudge against Java. But when you study the characteristics of the most popular languages, it becomes clear that Rails can only be Rails if it's in Ruby. To prove it, just look at the most recent frameworks (mostly still incomplete) written in other languages copying Rails' concepts. In Java/Groovy we have [Grails](http://grails.codehaus.org/), in PHP we have [CakePHP](http://www.cakephp.org/), in .NET we have [Castle](http://www.castleproject.org/index.php/Main_Page). Read their docs, try the code. After that you'll see that all of them try but none of them have the same "feel" as Ruby on Rails.

But that doesn't matter because, as I said before, it's part of the competition game. These alternatives need to exist. There are two reasons. First, competing frameworks force the Rails community to innovate and evolve faster, without getting complacent. Second, it helps justify the choice of Ruby for building Rails.

The message is simple: don't be bothered by criticism. Accept it, understand it, and evolve. In the real world there is no fantasy Highlander motto — _"there can only be one"_. Technologies that reign alone should be afraid: there's nowhere left to go but down. Evolution works in cycles, like everything in life: things are born, grow, and die.

As a consultant, my job is precisely to choose the _"best of breed"_ — the best in each sector, at that moment. A solution that's good today may already be superseded tomorrow, which is why we, as systems professionals, must stay updated every minute. Making choices based purely on brand names, or out of ignorance of alternatives, is a recipe for inefficiency and obsolescence.

Open your eyes.
