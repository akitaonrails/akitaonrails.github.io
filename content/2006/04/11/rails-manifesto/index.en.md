---
title: Rails Manifesto
date: '2006-04-11T12:09:00-03:00'
slug: rails-manifesto
translationKey: rails-manifesto
tags:
- narrative
- rails
- pitch
draft: false
---

A developer once described Ruby as two parts Perl, one part Python, and one part Smalltalk.

When [Yukihiro Matsumoto](http://www.artima.com/intv/ruby.html) created Ruby as a replacement for Perl and Python, inspired by Smalltalk, in 1993, he could hardly have imagined how far his language would reach outside Japan.

But in mid-2004, when [David Heinemeier Hansson](http://www.loudthinking.com/about.html) released his "Rails" framework — born from the products he built at his company 37signals — I believe he already knew exactly where he was headed.

Ruby on Rails is a product of the current [Web 2.0](http://www.blogger.com/post-create.g?blogID=25846821) movement. I'm sure most people still haven't grasped it yet, but we are at the inflection point of a new generation.

It's a fact: Sun got it wrong with J2EE. A flawed implementation of a flawed set of requirements. Those who followed that story will remember the nightmare of EJB 1 and 2, the slow and poor Web Services support, more delays in the promise of EJB 3, and so on.

We are wasting enormous amounts of time building simple things. Web applications shouldn't be complex. The Web was created to be simple. But J2EE was built to solve 100% of "Enterprise" problems. And we all know that when you try to fix everything, you end up fixing nothing properly.

With Rails, we finally become compatible with the dynamic spirit of Web 2.0. Web Services, Ajax — none of that is hard. And the traditional stuff: persistence layers, version control, MVC, templates, caching, security — all become what they always should have been: trivial.

When someone wants to change the requirements, we cringe: it takes enormous effort to implement modifications. After all, we invented an entire family of paraphernalia — like UML — precisely to ossify and obstruct any kind of change. Let's be honest: UML was created so consultants could charge more for their work.

With Rails, changes are welcome. Rails is the first platform truly compatible with the Agile thinking advocated in the [Agile Manifesto](http://agilemanifesto.org/principles.html). J2EE made the term famous, but that promise never delivered for it.

To kick off my articles, I think it's important to clarify two concepts that Rails made famous:

- _DRY – Don't Repeat Yourself_. Rails has native, simple support for Helpers, Templates, Engines, Plugins — all well integrated so that you can be productive without being messy. Copy and paste is bad; we have to stop doing it, and Rails gives us the tools to do so.

- _Convention over Configuration_. Instead of editing dozens of XML and properties files, Rails architecture prefers conventions: put your controller with the right name in the right directory and it will be found. Put your model in the right place and it will be located.

Two simple concepts, implemented throughout the entire framework, and they make all the difference.

And don't let prejudice lead you astray. I've already heard people say: _"Ruby is an uncompiled language, so it must be slow"_, _"everything Ruby does I can do in Java"_, _"Ruby doesn't scale well"_, _"I don't need to learn another language"_, _"Java will never go away"_.

Replace _"Ruby"_ with _"Java"_ and _"Java"_ with _"C"_ — or any other language. Sounds like we're hearing the exact same things from 10 years ago, when Java was the novelty.

It seems there's a tendency to criticize first and only look at the good parts later — and when we finally do, we realize we've arrived too late to the party.

How about doing something different this time, for a change?
