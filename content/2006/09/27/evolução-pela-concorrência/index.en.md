---
title: Evolution Through Competition
date: '2006-09-27T16:13:00-03:00'
slug: evolução-pela-concorrência
translationKey: evolução-pela-concorrência
description: "The author argues that criticism and competition drive technology forward. In Rails, limitations around internationalization, legacy systems, and asynchronous tasks have already encouraged community solutions."
tags:
- rails
- software-engineering
- economics
- off-topic
draft: false
---

 ![](/files/402px-AdamSmith.jpg)

I don't remember whether I wrote about this in a post or in my book, but there's a piece of common sense I call **"Evolution Through Competition"**. Debates like _"Ruby VS Java"_ or _"Rails VS J2EE"_ are not exclusive to the Ruby on Rails crowd. Look at the other recent fights in computing:

- Firefox VS Internet Explorer
- Macs VS PCs
- Windows VS Linux
- C# VS Java

Microsoft is the favorite for the villain role. It plays in practically every computing market, so it will always take criticism: _"Windows is bad"_, _"Office is junk"_, _"Internet Explorer is worthless"_, _"Visual Basic is not a professional language"_. Some of those arguments are valid; others are just narrow-minded grumbling.

Criticism is constructive when someone acts on it. Radicals are useless in this world. People who only curse and never do anything are irrelevant, as the saying goes: **_"if you're not part of the solution, you're part of the problem"_**.

Hats off to everyone who turned their frustration with the status quo into high-quality alternatives to Microsoft's criticized products. None of them is perfect, but the dedication deserves recognition. These days I only use Firefox (or [Camino](http://www.caminobrowser.org/) on the Mac, which runs the same Gecko engine).

Linux, backed by technology giants like IBM and Silicon Graphics, gained advanced filesystems such as JFS and XFS, [NUMA](http://lse.sourceforge.net/numa) support, clusters, more advanced [thread](http://web.archive.org/web/20180415043221/http://www.onlamp.com/pub/a/onlamp/2002/11/07/linux_threads.html) management, virtualization like [Xen](http://web.archive.org/web/20111019173305/http://kerneltrap.org/node/4168), and much more. That made it a trustworthy choice for serious servers.

Apple stopped being a stubborn company too. It learned to admit its mistakes and pull off ever cleaner transitions: from Motorola processors to IBM's PowerPC, from the obsolete MacOS 9 to MacOS X, built on a Unix core, and now from PowerPC to Intel's Core Duo and Core 2 Duo. Change in order to evolve.

Microsoft, for its part, is not sitting still. Watching competitors rise against it, the company built an answer to most of the criticism: Windows Vista. Despite the stumbles and delays, it promises to be a robust, modern system. Better than Linux? Better than MacOS X? Who knows. But evolution is happening. Same story on the development platform: under threat from Java, it created .NET. Both have strengths and weaknesses, but .NET has fantastic features nobody should ignore.

This phenomenon goes well beyond IT: it is built into [capitalism](http://en.wikipedia.org/wiki/Capitalism). The genius of competition is that it inevitably drives evolution. Companies today are better than they were ten or twenty years ago. That is exactly why monopolies need to be eradicated.

Take Brazil's telecom market. Back in the days of the inefficient state monopoly known as Telebrás, getting a phone line took months and cost an obscene amount of money. Today, with competitors like Telefonica and Embratel, a line is installed practically overnight at a reasonable price. The service is far from perfect (ask Procon), but things only started improving after privatization. That much is undeniable.

So what does any of this have to do with Rails? One corollary of this reasoning: technologies that are rarely discussed and rarely criticized tend to stagnate or, worse, to be forgotten. It is the monopoly effect again. A company that goes too long without competition gets comfortable, gets worse, falls apart, until someone finally shows up to dethrone it. In a healthy market, competition is a must.

Look at cases like [BeOS](http://en.wikipedia.org/wiki/BeOS), or languages like [Nemerle](http://web.archive.org/web/20130529032811/http://nemerle.org/Main_Page) and [Scheme](http://www-swiss.ai.mit.edu/projects/scheme/). They all keep small niches, but the market at large forgot them. That does not mean they were bad; for various reasons, they were never criticized or grilled enough.

I explained all of that to get to this point: Ruby and Rails are under constant criticism, watched closely, grilled without ceremony. And that is excellent. Every gear of evolution is turning. Thanks to all this attention, smart people in the community stood up to fill the gaps, pushing RoR quickly to levels it would never reach alone. Some examples:

##### RoR doesn't support Internationalization

For some, this is a serious flaw, made worse by the fact that Ruby itself is not very Unicode-friendly. Remember, Ruby was born in Japan, for the Japanese, in the early 90s. I covered the subject in the book; long story short, today we have solutions like [Globalize](http://web.archive.org/web/20120209000503/http://wiki.rubyonrails.org/rails/pages/Internationalization).

##### RoR has no equivalent to EJBs

True, despite being extremely bureaucratic, current EJB containers are quite robust. RoR amounts to just the servlet container of a full J2EE stack. But thanks to **Ezra Zygmuntowicz** we now have [BackgrounDRb](http://www.infoq.com/articles/BackgrounDRb). It works roughly like a Message Bean for running asynchronous tasks. Not necessarily better, but it is a solution.

##### RoR is nothing more than a template generator

The same old scaffolding talk. Plenty of newcomers and ill-informed critics believe Rails is just the scaffold method. They are flat out wrong, though scaffolding is an incredible concept, difficult or impossible to pull off in static languages. Rails' default scaffold is too simple: it does not, for example, interpret the relationships between tables. Several alternatives showed up, and the most interesting are Streamlined and AjaxScaffold, as I [mentioned](http://web.archive.org/web/20240223172630/https://www.akitaonrails.com/2006/09/27/snakes-vs-rubies-scaffold-on-steroids) a few posts ago.

##### RoR only favors Green Field projects

_"Green Field"_ is what we call a project started from scratch, no legacy, where we get to pick the implementation and follow Rails conventions from day one. The problem is building a Rails module on top of a database that already exists, completely outside the conventions. That takes work. To make it easier, Robby Russell is writing the [Acts as Legacy](http://www.robbyonrails.com/articles/2006/04/14/sneaking-rails-through-the-legacy-system) plugin, an Active Record extension that promises to smooth things out.

##### RoR uses scriptlets: code mixed with HTML, and that is terrible

A never-ending debate. Rails' view engine, Erb, does use the equivalent of JSP or PHP scriptlets, with raw Ruby code mixed into the HTML. In Rails' case, it is a great feature. But some people prefer something closer to taglibs: HTML free of programming, especially when Web Designers join the project. A great alternative is [Liquid](https://shopify.github.io/liquid/), which brings functionality similar to Velocity from the Java world. That way we can please Greeks and Trojans alike.

##### RoR alone is too raw. Python, for example, has Zope/Plone

Rails is a framework. Some people want to extend the fight and claim Rails loses to Zope. For the uninitiated, Zope is an excellent application server with a CMS, written in Python. Sure, comparing a CMS to a framework is apples and oranges. Even so, smart solutions are already being written in Rails. In the CMS space (content, blogs) we have the famous [Typo](http://typosphere.org/) and [Mephisto](http://mephistoblog.com/). For eCommerce, [Shopify](http://shopify.com/).

##### RoR uses good Design Patterns but doesn't implement newer concepts like Rules Engines

A Rules Engine, or Business Rules Engine, manages business rules. The concept gained traction recently and is still maturing, so every vendor implements it differently. In the Java world, one of the most famous is JBoss Rules (Drools). In the Ruby world, an alternative called [Rools](http://web.archive.org/web/20170203232526/http://rools.rubyforge.org/) already exists.

##### RoR doesn't have as many libraries as Java

True. Even though Ruby is over 10 years old and Rails gains new plugins all the time, Java undeniably has a huge library collection, perhaps second only to C/C++. A new development could change that: **[Sun just hired the creators of JRuby](https://rubyonrails.org/2006/9/7/sun-hires-the-jruby-team)**, a way to run Ruby code directly on the JVM, opening the door for Ruby to reach every Java library out there. If Sun does its homework, we'll soon have a JVM Ruby with high performance, robustness, internationalization support, and access to an endless supply of libraries.

##### Finally, why was Rails written in Ruby? Couldn't there be a "Jails"?

Many people question the fact that Rails is written in Ruby. At first glance it looks like the programmer's grudge against Java. Study the most popular languages and it becomes clear that Rails is only Rails if it's Ruby. The proof is in the recent frameworks (most still unfinished) that copy the same concepts in other languages: [Grails](https://grails.org/) in Groovy/Java, [CakePHP](http://www.cakephp.org/) in PHP, [Castle](http://web.archive.org/web/20061024010829/http://www.castleproject.org/index.php/Main_Page) in .NET. Read the docs, try the code. They all try, but none of them has the same "feel" as Ruby on Rails.

And that is part of the game. Those alternatives need to exist, for two reasons. First, competing frameworks force the Rails community to innovate and evolve faster, never getting comfortable. Second, they help justify the choice of Ruby for building Rails.

The message is simple: don't let criticism bother you. Accept it, understand it, evolve. The real world has no room for the Highlander fantasy, _"there can be only one"_. A technology that reigns alone should be afraid: there is nowhere left to go but down. Evolution works in cycles, like everything in life: born, grow, die.

As a consultant, my job is to pick the _"best of breed"_, the best of each sector at that moment. A solution that is good today may be replaced tomorrow, so we systems professionals need to stay current every single minute. Choosing by brand name, or out of ignorance of the alternatives, is a recipe for inefficiency and obsolescence.

Open your eyes.
