---
title: The Economics of Software Development
date: '2017-06-22T10:56:00-03:00'
slug: the-economics-of-software-development
tags:
- off-topic
- agile
- lean
- methodologies
- startup
draft: false
---

The software development community is boiling nowadays with so many options all at once. You have dozens of active and very good languages such as Go, [Elixir](/elixir), Clojure. Dozens of very good frameworks, both in the back-end and front-end including React, Elm. Dozens of sound methodologies from good old Agile stuff all the way to Continuous Deployment with microservices.

Now, you're a small tech startup or even a small team in a big corporation. How to even start?

And the recommendation is: do the smallest thing that works first. Always. Of course, avoid "quick and dirty" as much as you can. But don't get paranoid and over-engineer too much.

Over-engineering is as expensive as doing things "dirty".

### Add "Time" to your equation

What most people do very wrong is disregarding the variable of "Time".

Everybody goes to tech conferences or read fancy blog posts or watch flashy screencasts. Their wrong conclusion is: _"Netflix uses it, therefore it should be good for me, because I want to become Netflix"_.

The wrong assumption is that Neflix - or Google, or Facebook, or Spotify - is a static system and they always functioned the way they advertise it.

People forget that every unicorn company had a **day-1**. And on day-1 they did not use microservices. They did not had React.js. They did not have Go or Elixir. Some of them didn't even have good programmers to begin with. Netflix started as a VHS renting service, remember that? Google started off in a dorm-room with off-the-shelf hardware components assembled in a [Lego-based rack](http://www.complex.com/pop-culture/2013/02/50-things-you-didnt-know-about-google/lego-server-rack).

You are a fan of some celebrity. That celebrity has a Lamborghini car. So you want to be like that celebrity one day. What do you do? Do you buy the same Lamborghini he has?

If you are that stupid, the only thing you will end up with is a HUGE debt to pay.

Stop envying the rich guy's Lamborghini.

### (Technical) Debt

This is neither a new term nor a new theme. Every decision you make in programming is a **compromise** between what the "future-ideal" should be and what you can actually do right now. Loan to buy the equivalent Lamborghini too soon, and you will have to deal with an unpayable (Technical) Debt. And you will stale, you will stop, you will do nothing BUT pay that debt from now on.

You want to "code faster" therefore you skip writing automated tests, because you assume it will slow you down. And you're right. Test-driven development is not about making you fast at first. It's about protecting your future self from your present self. It's about not accumulating Technical Debt.

Again, you forget the "Time" variable.

You write and deliver fast for the 1st month. After the first version is deployed, now you will abliged to start paying the debt. Your productivity will slow down. Regression bugs will show up. Every new feature you try to add breaks something in unexpected ways. Because you don't have automated tests, you will keep fixing the same things many times over. Debt will catch up, and you will pay. One way or the other.

Minimal test suites are like **Insurance**. You don't need it right now, on day-1. But on day-100 you will be so glad you have it.

Doing too much microservices on day-1 is debt. It feels great that you're doing that fancy thing you read in a blog post. On day-100, with your 3 people team and a dozen microservices, from now on you will do nothing but pay the accumulated debt, with **Interest**. Every new microservices deployment breaks your system. And of course you didn't add monitoring, you didn't add integrated tests. So every time you code something, something else unexpectedly breaks.

Enjoying that early Lamborghini now?

### The Mythical Man-Month

Philip Calçado writes very good posts and presents about microservices in the right way. If you're serious about that subject I strongly recommend that you read his posts, such as his ["Prerequisites"](http://philcalcado.com/2017/06/11/calcados_microservices_prerequisites.html) post or his ["Economics"](https://www.infoq.com/news/2017/05/economics-microservices) presentation.

He correctly remembers Fred Brooks' **The Mythical Man-Month**. I urge developers to read this small book. It's uncanny how the entire industry is still repeating the very same mistakes Brooks reports in his book from projects in the 60's!

To me, microservices is a by-product of tech companies with too many developers. Once you break through the 5-developers team a "monolithic" system with poor organization and few automated tests can become cumbersome to deal with. So the consequence is the desire to break it down. You make 2 teams and 2 microservices and coordinate. And the teams start to isolate, and play the  finger-pointing sessions when new bugs are reported (_"it's the other team's microservice's fault"_).

That's [Conway's Law](http://www.melconway.com/Home/Conways_Law.html) if you do it wrong:

> Any organization that designs a system (defined broadly) will produce a design whose structure is a copy of the organization's communication structure.

Also in play is another chapter in Brooks book: The [Second System Effect](http://wiki.c2.com/?SecondSystemEffect). Every developer, tech startup, has to assume that the first version of anything is not the best design. And the second system (the first big rewrite) is **the most dangerous** system you will write. As Brooks state, it goes like this:

> An architect’s first work is apt to be spare and clean. He knows he doesn’t know what he’s doing, so he does it carefully and with great restraint.

> As he designs the first work, frill after frill and embellishment after embellishment occur to him. These get stored away to be used “next time.” Sooner or later the first system is finished, and the architect, with firm confidence and a demonstrated mastery of that class of systems, is ready to build a second system.

> This second is the most dangerous system a man ever designs. When he does his third and later ones, his prior experiences will confirm each other as to the general characteristics of such systems, and their differences will identify those parts of his experience that are particular and not generalizable.

> The general tendency is to over-design the second system, using all the ideas and frills that were cautiously sidetracked on the first one. The result, as Ovid says, is a “big pile.”

Then, what happens? The CEO, the board, the investors, or whatever, start doing the wrong thing: hiring more and more people. Loan more and more. Instead of paying the debts they end up making more debt. They fell for what Brooks reported in the first chapter and what gives the name to the book: The Mythical Man-Month.

> Adding manpower to a late software project makes it later.

> Complex programming projects cannot be perfectly partitioned into discrete tasks that can be worked on without communication between the workers and without establishing a set of complex interrelationships between tasks and the workers performing them.

> Therefore, assigning more programmers to a project running behind schedule will make it even later. This is because the time required for the new programmers to learn about the project and the increased communication overhead will consume an ever increasing quantity of the calendar time available. 

Again, it's foregoing the sense of the "Time" variable. And confusing "debt" for "investment".

First of all, do yourself a favor and [read the goddawn book](http://amzn.to/2sFbkWq) already, twice.

### Do Agile right! And no, it's not Kanban!

If there is one good thing the whole Lean noise generated is the notion of "Most Viable Product" or MVP. People call it "prototype". Some call it "launching Beta" or simply "version 1.0". Doesn't matter. It's the realization that you don't know much at the beginning so overengineering on the first version is a waste of time. Lean is about controlling "waste", so we do the minimal that work, gauge results and work from there.

The cynical will say that any prototype that reaches production will never die. And they're not wrong.

The balance is to not do the "quick and dirty" version. That's why we have Agile techniques for. Do the minimal, organize the minimal. That's why we have object-oriented design patterns, from GoF to DDD. You don't need to do EVERY pattern - that's what "overenginnering" means. But you can do the minimal monolith that will allow you to evolve later.

People criticize Ruby on Rails for not being organized "enough". [Nick Sutterer](https://apotonick.wordpress.com/2015/09/05/the-only-alternative-to-a-rails-monolith-are-micro-services-bullshit/), the creator of the high-level [Trailblazer](https://github.com/trailblazer/trailblazer) has a good point.

Rails done wrong is bad. The conclusion should NOT be: _"let's do microservices"_ though. That jump in faith is idiotic and makes no sense for all the reasons I mentioned above.

_"Let's do proper Agile stuff and proper object-oriented stuff"_ should be the initial answer.

And by "Agile" forget about idiotic post-its, idiotic numerology-based estimation equations (this is a whole post in itself, because story points and velocity are useful, but adding Montecarlo and other Gaussian-based stuff are not). The only "Agile" things you should be concerned about are the [Extreme Programming (XP) techniques](http://www.extremeprogramming.org/), **including** Iteration-based timeboxes.

You **MUST** do timeboxes. Stop, re-assess, change directions, and then keep going. The model of "Pull" is only reasonable when your directions is very, very clear, written in stone and unchangeable - like in a factory production line! (Where the concept of Pull - and Lean -- was actually born!)

Iterations, like automated tests, are like Insurance. You can never avoid all waste, but you can minimize it. You can afford to throw away an Iteration-worth of work. After the iteration you measure the results, and throw it way if necessary - changing direction in the process. Throwing useless stuff away is as important as adding new stuff. If you just add, you have a [hoarding disorder](https://en.wikipedia.org/wiki/Compulsive_hoarding)!

If in doubt, do XP. Yes, it feels more "difficult", and Kanban is "simpler" to explain. Now, is that a good reason?

### Forget about Raw Performance when you DON'T need it!

Another problem is choosing languages or framework because of performance.

If you're in the web development business, this is a huge WASTE.

Understand this truth: your servers will IDLE most of the time. And if you feel like using your web app is slow, it's not because of the language used, it's because of the POOR programming you did. And no good language will rescue a bad programmer. I always say that if performance was that important, we should all be doing C.

Most of what you serve in an HTTP-based apps, be it user-readable content, be it API GET results, can be **CACHED**! If you're not using a [CDN](http://www.akitaonrails.com/2015/08/25/small-bites-adicionando-um-cdn-ao-seu-site-a-forma-facil), you're doing it wrong.

Yeah, yeah, yeah, you think you're building the next Spotify. You're not, at least not 99% of you. And the 1% doing custom engineering, with custom techniques and custom stack,  successfully, you're the 1%. Actually I'd say you're a fraction of the 1%. Do not assume that what you do is good for the rest of the population.

90% of what most small companies and solo web developers need is just a Shopify account and a vanilla Wordpress installation. And that's it.

> Are you doing infrastructure development like building custom components to Docker, Kubernetes, Terraform? Command-line tools? Daemons? Then choose GO.

> Are you doing embedded libraries? Maybe the next generation OpenSSL? Drivers? Then choose RUST.

> Are you doing mobile development? Then don't have a lot of choice, do Swift for iOS, do Kotlin/Java for Android. Or do React Native for simpler apps.

> Are you really doing the next Whatsapp? The next Waze? The next Snap? You have hundreds or thousands of users in need of long-lived connections over unreliable network doing broadcasts of messages? Or you're building the next evolution of distributed NoSQL databases? Or anything that actually has the proper meaning of "Distributed" in it's definition? Then choose ELIXIR.

> Are you doing a CRUD based web application? Go RAILS and never look back.

> Are you doing all of the above? Use all the alternatives then. And I hope you have the budget, because you need a big team.

### Conclusion

The Economics only makes sense when you consider the day-1. Do not forget the "Time" variable. It makes all the difference.

You will always get Debt to pay. So be smart in which kind of debt you choose. Because you will have to pay it back eventually.

Again, read Brooks. He said it decades ago: [THERE IS NO SILVER BULLET](http://worrydream.com/refs/Brooks-NoSilverBullet.pdf). Don't bullshit yourself. A new language, a new framework, a new architecture. None of those will save you.

In any tech endeavor, code is not the only thing to worry about. I would go as far as to say that in a tech startup, code is only 20% of the problem. A tech startup is just a company, like any other. If you're the founder or CEO, you have to deal with all the remaining 80%: marketing, accounting, human resources, legal, etc. It's already difficult enough without your tech team getting you unwanted Technical Debt - the unneeded Lamborghini - that you won't be able to pay.

You can start humble on day-1. Keep evolving, continuously - this is the core of any Agile or Lean process: [KAIZEN](https://www.graphicproducts.com/articles/what-is-kaizen/). Choose smart debts, pay them a small bit at a time, continuously. It's the same reasoning as getting a loan in the bank.

> Netflix day-7,200 is NOT your day-1.

> Facebook day-4,800 is NOT your day-1.

> Goodle day-6,8090 is NOT your day-1.

> Be humble. Deliver fast. Pay your Debts. Keep evolving continuouly. Stop believing in fairy tales and silver bullets.
