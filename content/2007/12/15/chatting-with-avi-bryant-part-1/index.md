---
title: Chatting with Avi Bryant - Part 1
date: '2007-12-15T12:15:00-02:00'
slug: chatting-with-avi-bryant-part-1
tags:
- interview
- english
draft: false
---

Someone once challenged all other frameworks implying that no one would get close to what we are doing in Rails … except for Avi.Seaside is such a departure from the status quo that Avi himself describes it of a ‘heretic’ framework. And he is right. He looked back in history and took what is considered ‘the’ father – and arguably ‘the’ best implementaton – of object-oriented languages: Smalltalk.

Taking clues from the venerable Apple WebObjects he set his way to implement Seaside and his very successful web product, [Dabble DB](http://www.dabbledb.com). Check it out who is the man, what are his opinions and why he is so relevant to the Ruby and Rails community even though he advocates another language and another framework. Sounds strange, but when Avi speaks, you listen.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/n517961878_373676_1188.jpg)

He was very kind to provide me a very long interview. It is so long I divided it in 2 parts. This is the first Part. I will release the second one in a few days. Hope you all enjoy it.


 **AkitaOnRails:** Great. I am kind of nervous. Up until now I only interviewed Ruby and Rails advocates including Matz and DHH, this is the first time I am looking for an outside point of view.

And I know you’re very opinionated about Smalltalk and Seaside, but at the same time you have very strong binds to the Ruby community. May I start asking you more about Avi Bryant, the person? Meaning, what’s your history in the programming field?

**Avi Bryant:** I started programming quite young; it was something I did with my brother and father for fun, mostly writing games in C on the early Mac. As I got closer to college age, my interests turned more to theatre and film, and so when I started university it was essentially as a film major.

But in the long run computer science sucked me in, and I ended up graduating with a CS degree and working in a software engineering lab on campus. That was when I first started programming seriously, and particularly where I got especially interested in software tools.

This was around the time that the very first builds of Mac OS X – when it was essentially still just NeXTStep, without Aqua or Carbon or anything – started to become available, and since I had always programmed for the Mac I set out to learn Objective-C and Cocoa. That was my first exposure to “real” OO, and it was intoxicating.

At the same time, I was doing some web consulting on the side for some extra money, and so I was looking for a language that reminded me of Objective-C but was more dynamic and better suited for the web, and so eventually stumbled across Ruby, which fit the bill nicely.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/n517961878_39359_1867.jpg)

I was still enamored with all things NeXT and Objective-C, and so when I started to work on web tools for Ruby I took NeXT’s WebObjects framework as my model, and ended up with IOWA, which is very close to being a port of WebObjects to Ruby. I presented that at the first RubyConf, which was, I think, in 2000.

RubyConf was collocated with OOPSLA that year, which I was also attending to give a talk on my research from the software engineering lab. Now, when OOPSLA started out, it was full of Smalltalkers, and even though the mainstream of OO software development – and thus the main focus of OOPSLA – moved on to Java and C#, the Smalltalkers kept coming. But instead of participating in the rest of the conference, they’d just set of a semi-official “Camp Smalltalk” with their own projector and their own schedule and hack and demo Smalltalk stuff all day.

I had of course been aware of Smalltalk, as the source of a lot of the ideas behind things I was interested in – Objective-C and Ruby, obviously, but also TDD, wikis, even the Mac to some extent – but I had never gotten anywhere with actually using it; the environments were too different, the documentation too sparse, etc.

Sitting for a day at Camp Smalltalk was the boost I needed to get past that. And once I got a taste of Smalltalk, I couldn’t let go – I started right away on a port of IOWA to Smalltalk, and convinced my next couple of clients on web projects that I should use Smalltalk instead of Ruby. This port became Seaside, and over the next several years I built up a consulting business around Seaside training and development.

Smalltalk web development may seem like a small niche to build a business around, but the fact is that **nobody** else was doing it at the time (for that matter, nobody else was doing web development in Ruby at the time either – that situation is a little different now.

Some people to mention in this history – Julian Fitzell was my early partner on the web projects, and we worked together on the first version of Seaside. Colin Putney was one of my early clients, who had come to me based on my work in Ruby and I had to work hard to convince to use Smalltalk; he’s now a confirmed Smalltalker and works with me on Dabble DB. Andrew Catton worked with me at the software engineering lab, and was a frequent collaborator on various other projects over the years.

A few years in, a little fed up with consulting, Andrew and I started to work on a product on the side, and that project became Dabble DB. Last summer, we were lucky enough to get funded to work on that full time, and that’s what I’ve been doing since.

**AkitaOnRails:** I see that you like the fact that Smalltalk is not “mainstream” in the Java-sense of the word. I can see the advantages and I agree with it. It’s like _“we are a small group of very smart people”_. Much like Apple’s own _“Think Different”_ campaign. On the other hand the masses tend to like big bang marketing and support. What do you think of this culture clash? The most important part is: here in Brazil the market is very closed to non-widely-commercially-supported tech. Meaning most of them don’t like anything different than Java or .NET. How do you convince your customers about using Smalltalk – if this is actually a matter there in the US?

**Avi Bryant:** Yes, that’s a tricky balance. Some of the people I knew in the early days of Ruby’s popularity – post-Pickaxe, but pre-Rails – have complained about how much more popular Ruby has gotten lately, because inevitably the signal-to-noise ratio goes down on the mailing lists and at the conferences. Smalltalk doesn’t have that problem – in particular, Smalltalk has a nice mix of very experienced hackers – people like Dan Ingalls, who has been writing language implementations for more than 30 years, and has just an amazing depth of knowledge to share – and young troublemakers like myself. When you get too popular too quickly, you get a huge influx of young, inexperienced, energetic people, and the voice of experience tends to get drowned out. Not that new ideas aren’t valuable – they’re essential – but I think in this field we tend to overlook history far too much.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/198438575_ff982238f7.jpg)

As for using non-standard tech, I think the best way to look at it is as a competitive advantage. Paul Graham points out that on average, startups fail, and the same could probably be said about software projects in general. So if you want not to fail, you have to do **something** different from the average, and using better technology is a great way to do that.

But you clearly have to be in a situation where results matter more than policy – it’s almost impossible to sell an enterprise IT department on a Smalltalk project. On the other hand, a small business owner couldn’t care less what technology you use when building a custom app for him – it’s not like he has an army of Java developers who are going to maintain it.

In general, the closer the alignment between the person who will be using the app, and the person who is writing the checks, the more they’ll care about having something that actually works, and the less about the buzzwords it involves.

That was my strategy when doing Smalltalk consulting, and that’s also our strategy with Dabble DB – we sell to users, not to CIOs.

**AkitaOnRails:** That’s exactly how I think. Which boils down to you having a startup. I can understand being fed up by consulting work, but what led you to choose to open your own company to sell your own products? I heard that Tim Bray is also an investor for your company? Many people wouldn’t like to lose their comfortable job positions for something as risky as this. What was the reason for this direction in your career?

**Avi Bryant:** When we were consulting, it became clear to Andrew and me that a) most companies, especially small businesses, couldn’t afford to hire us, and b) even those who could, they could only hire us for the very most important projects. The only way we were going to scale our business, and help as many people as possible, would be to effectively replace ourselves with software: build a product that would let them do the simple projects themselves.

We didn’t abandon everything to go and build this, however – we kept our existing clients (in fact, we took on some new ones to get a little extra capital to hire a web designer, etc), and we worked on the product on evenings and weekends, where we could.

As the product got further along, and it became more and more clear that there might be something worthwhile there, we started to work on it more in earnest, but still keeping some cash coming in with consulting.

Eventually, when the product was ready to launch, we knew we couldn’t handle Dabble DB customers at the same time as our consulting clients, and so we had to drop them entirely. That was when we took some investment from Ventures West and from Tim Bray.

So it was a fairly gradual transition, which made it a lot easier to do.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/dabbledb.gif)

**AkitaOnRails:** But even then, were you doing Smalltalk/Seaside consulting only? Or you were working on different languages/frameworks for customers and Smalltalk afterwork? And for non-starters how would you briefly describe [Dabble DB](http://www.dabbledb.com)? I hear that you’re about to release a companion product for it, isn’t it? Can you describe them?

**Avi Bryant:** During that period, the consulting was all around Seaside, yes – there were some dark times earlier when I had to take some Java work :-)

Dabble DB is a hosted web app for small businesses and teams who need some kind of custom data management – maybe they need custom project management, or a custom contact database, or a custom HR application, or event planning, or just their DVD collection, but for whatever reason the off the shelf software doesn’t do what they need. Dabble lets them interactively build very rich reports on their data, with structured grouping and filtering, simple calculations and subtotals, and display it as a table, or a chart, or a map, or a calendar. You can then share these reports with people, or invite them in to enter or modify the data itself.

The companion product you’re referring to is, I think Dabble Pages. This is really just a new feature set on top of Dabble DB, which all Dabble customers get. What we’ve found is that in any organization there are usually a small number of people who want the full power of the Dabble DB user interface, and want to build new reports or add fields or restructure their data, etc. But there are also a much larger number of people who just want a simple web page where they can enter new data or view a report. So Pages lets that small core group build something for the larger group. It’s sort of like a souped up version of WuFoo or other form builders, but with Dabble DB as the administrative back-end.

It makes Dabble DB **almost** into a web development tool, in the sense that the administrative users really are building simple applications for the other people in their organizations – but without any whiff of programming, so of course the applications are very limited.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/Picture_2.png)

**AkitaOnRails:** Changing subjects a lil’ bit, one thing that I do admire about you is your relationship with the Ruby/Rails community. Those are different paradigms and technologies, but you never dive in flame wars like ‘Smalltalk is better than Ruby’ just for the sake of it. On the contrary, to me it feels like you do like Ruby, as you presented at RailsConf about the possibility of running Ruby empowered by a modern VM like GemStone’s. But, you did switch from Ruby to Smalltalk. What was it the ‘clicked’ for you about Smalltalk? Continuations? The whole coding-in-runtime? The tighter environment integration?

**Avi Bryant:** So, first of all, I very much do like Ruby, and Dabble DB includes about 3000 lines of Ruby code (I just checked) along with however much Smalltalk (and a sprinkling of Python).

What clicked about Smalltalk was a few things: one was simply the maturity, both of the community and of the technology. Smalltalk implementations have been refined over the last 25 years, and they’ve really benefited from it.

One of the major benefits, in my opinion, is that Smalltalk VMs are fast enough that it’s reasonable to implement all of the standard libraries – Array, Hash, Thread, and so on – in Smalltalk itself. So there’s no barrier where you switch from your Ruby code to the underlying C implementation; it’s “turtles all the way down”. This may not seem like a big deal but once you have it, it’s really hard to give it up.

Rubinius, of course, is moving in this direction for Ruby, and mad props to Evan and everyone else working on that project. For me, the Smalltalk environment is also key.

In some ways it’s the same things I talk about with Dabble DB: you don’t have to choose one way to organize your data, you can have one view that’s grouped by date and another filtered by customer and another where a map is the only way to understand. In Smalltalk, you don’t have to choose one file layout or order of methods and classes in your code; you’re constantly switching views on what’s basically a database of code.

My friend Brian Marick hates this, because you lose any “narrative” that might have existed by putting the code in a certain order in the file, and it’s hard to get used to, but for me, it’s the ultimate power tool for hacking on a large code-base.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/15/n517961878_38879_9189.jpg)

* * *

That’s it for Part 1. Stay tuned for more Avi, talking about Smalltalk and Ruby on Part 2 of this interview, to be released in a few days.

