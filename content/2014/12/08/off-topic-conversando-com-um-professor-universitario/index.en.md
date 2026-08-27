---
title: "[Off-Topic] Talking with a University Professor"
date: '2014-12-08T19:56:00-02:00'
slug: off-topic-conversando-com-um-professor-universitario
translationKey: off-topic-conversando-com-um-professor-universitario
description: "In response to a professor, the author argues for selective UML, Design Patterns as reference material, XP, and multiple paradigms. Java remains useful, but universities should prioritize fundamentals."
tags:
- learning
- programming-languages
- career
- off-topic
draft: false
---

A few days ago, professor Rosenclever Gazono, from the University Center of Volta Redonda, sent me an email asking for some opinions that I thought were worth sharing. I've already met many professors during my visits to several universities around the country, and many have the same questions, so I hope this helps a little.

Below, I'll transcribe the professor's questions and my answers.

**Professor:** My name is Rosenclever, I'm a university professor currently teaching Object-Oriented Analysis and Design (basically UML, Design Patterns, and Agile methodologies) and Object-Oriented Programming 2 (Java for Web with JPA and JSF)

Well, since you're a developer who today also plays the role of an entrepreneur, and I, on the other hand, am in academia trying to prepare professionals to work in the market, I always try to update my content with market demand, and it's very common to hear from IT managers, through the media, that there's a very big gap between what's taught in academia and what the market needs...

So I'd like to ask for your contribution so that I can help my students leave better prepared for the market. I'd like to know your opinion on the syllabuses of the courses I mentioned at the beginning of this email...

**Professor:** 1) Does it make sense today to master UML diagrams?

**AkitaOnRails:** "Master" perhaps not (in the sense of knowing every little detail of every diagram). But knowing they exist, having a general notion of each, and knowing the most useful ones like Use Cases, Sequence Diagram, State Diagram, Class Diagram, I think is appropriate and useful. And never as a way to design ALL the software, but a few parts that maybe become clearer if you diagram first.

Adding here in the post: plenty of people who never programmed professionally think that "any and every" type of diagramming and planning is unnecessary. They still imagine (without knowing it) that the so-called "corporate" world runs on mountains of diagrams and plans. That's almost never true.

Of course there are exceptions, but in the common case a programmer needs to communicate an idea through something beyond code. That matters most when explaining a complex architecture to the team before starting to code.

It doesn't mean diagramming 100% of the classes, 100% of the states, 100% of the sequences. It means diagramming what's most critical and hardest to understand, and letting the rest emerge naturally during programming.

**Professor:** 2) Which Design Patterns and Agile concepts do you consider fundamental to be taught in academia? Or is that also not considered important?

**AkitaOnRails:** Design Patterns are important, but as a reference. They're possible solutions, and they need to be evaluated case by case. In Agile, only worry about Extreme Programming, because all XP techniques matter. Scrum and Kanban can be introduced, but they're dispensable. About patterns:

* [Brazilian Portuguese Can Confuse Us: Standard vs Pattern](/en/2013/05/10/a-lingua-portuguesa-brasileira-e-pessima-standard-vs-pattern)
* [GoF Design Patterns - Did it survive the test of time?](http://www.akitaonrails.com/2007/07/30/gof-design-patterns-sobreviveu-ao-teste-do-tempo)
* [Design Patterns represent defects in Languages](http://www.akitaonrails.com/2006/10/30/design-patterns-representam-defeitos-nas-linguagens)

Adding here in the post: the important thing is to teach that nobody needs to invent everything from scratch all the time. That would be a redundant effort, since someone has probably already solved the problem before.

At the same time, it's worth explaining that what we know today is just what seems to work best, and none of it is final. If someone has a result that beats what we know, great, show it to everyone.

It became fashionable to talk about "Inversion of Control," and few people know what it really means. They only know it seems to improve "modularization," also without understanding why modularizing is a benefit in some cases and not so much in others.

And speaking of Agile, I recommend reading these posts of mine:

* [Lean is Dead, Long Live Efficiency](/en/2014/03/27/off-topic-lean-esta-morto-longa-vida-a-eficiencia)
* [Agile: the Truth Behind the Method](/en/2014/09/28/off-topic-agile-a-verdade-por-tras-do-metodo)

**Professor:** 3) Does the OO Analysis and Design discipline still make sense today? What would be interesting to be addressed in it?

**AkitaOnRails:** Of course, but today you have to emphasize that OO (object orientation) is one approach among several, and not always the "best."

By the way, OO only gets interesting in academia through the eyes of languages that really explore OO, like Smalltalk and Ruby. It's worth showing the whole landscape: class-oriented programming in Java and C#, functional in Lisp and Scheme, prototype-oriented in JavaScript and Io, and programming with concurrency and actors in Go, Scala, and Elixir/Erlang.

Adding to the post: this is the kind of subject with no "right" answer. Any attempt to measure the strength of one side or the other always turns into a flamewar or a mediocre bikeshedding.

The reality is that software factories will keep using languages with good commercial tooling support, like IBM Websphere and Microsoft Visual Studio.NET. Tech startups and smaller, more "best of breed" technology-oriented companies will prefer open source solutions that sometimes look like a "patchwork quilt."

Agencies and small producers will keep using whatever delivers in the shortest possible time, even if it's dirty. Advertising campaigns last very little, so you're left with the "quick and dirty," the WordPress derivatives, and so on.

**Professor:** 4) Is it definitely still worth teaching Java in academia? Do you think Ruby and Rails or even Python and Django are more appropriate?

**AkitaOnRails:** Yes, it's worth it, as long as Java comes in as what it really is: the commercially most viable language. It isn't the only solution to everything nor the best example of an OO language.

Ruby and Python can be explored as dynamically typed languages, taking the chance to explain the difference between static and dynamic typing. But in academia, especially in Computer Science, I've always been in favor of teaching dead languages like Smalltalk, Lisp, and Eiffel. That keeps the student from falling into the temptation of staying only with the language they learned in college. A bachelor's degree should prioritize foundation, and commercial use is the job of technical and technologist schools.

Adding to the post: Academia, especially in Computer Science chairs, must emphasize science. Going 100% toward the market creates a generation that becomes obsolete very quickly and, worse, that never learns to update itself on its own.

In a hypothetical scenario, if 100% of universities turned 100% toward what the "market" wants, in ten years we'd have our entire computing field junked. Universities need to elevate the "Science" of Computer Science.

Let me leave posts I wrote about university and career topics:

* [Should I go to college?](/en/2009/04/17/off-topic-devo-fazer-faculdade)
* [Career in Programming - Coding isn't Programming](/en/2014/05/02/off-topic-carreira-em-programacao-codificar-nao-e-programar)
* [Letter to a Young Programmer Considering a Startup](/en/2013/10/31/traducao-carta-para-um-jovem-programador-considerando-uma-startup)

**Professor:** Sorry for the long email, but unfortunately there was no opportunity for us to talk at the event...

**AkitaOnRails:** Not at all, if the subject is relevant, it's worth discussing it. And I encourage everyone who attends events I'm at to call me if they want to discuss ways we can help improve education. This subject will never be irrelevant.
