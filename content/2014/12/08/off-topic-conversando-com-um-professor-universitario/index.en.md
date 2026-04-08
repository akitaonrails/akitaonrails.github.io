---
title: "[Off-Topic] Talking with a University Professor"
date: '2014-12-08T19:56:00-02:00'
slug: off-topic-conversando-com-um-professor-universitario
tags:
- off-topic
- career
draft: false
---

A few days ago, professor Rosenclever Gazono, from the University Center of Volta Redonda, sent me an email asking for some opinions that I thought were worth sharing. I've already met many professors during my visits to several universities around the country, and many have the same questions, so I hope this helps a little.

Below, I'll transcribe the professor's questions and my answers.

**Professor:** My name is Rosenclever, I'm a university professor currently teaching Object-Oriented Analysis and Design (basically UML, Design Patterns, and Agile methodologies) and Object-Oriented Programming 2 (Java for Web with JPA and JSF).

Well, since you're a developer who today also plays the role of an entrepreneur, and I, on the other hand, am in academia trying to prepare professionals to work in the market, I always try to update my content with market demand, and it's very common to hear from IT managers, through the media, that there's a very big gap between what's taught in academia and what the market needs...

So I'd like to ask for your contribution so that I can help my students leave better prepared for the market. I'd like to know your opinion on the syllabuses of the courses I mentioned at the beginning of this email...

**Professor:** 1) Does it make sense today to master UML diagrams?

**AkitaOnRails:** "Master" perhaps not (in the sense of knowing every little detail of every diagram). But knowing they exist, having a general notion of each, and knowing the most useful ones like Use Cases, Sequence Diagram, State Diagram, Class Diagram, I think is appropriate and useful. And never as a way to design ALL the software, but a few parts that maybe become clearer if you diagram first.

Adding here in the post: many who haven't learned to program professionally think that "any and every" type of diagramming and planning is unnecessary, and still believe (without knowing) that the so-called "corporate" world is all driven by mountains of diagrams and plans. And that's not true. Of course there are exceptions, but in the common case a programmer needs to be able to communicate an idea more than just through code, especially when trying to explain a complex architecture to a team before starting to code. It doesn't mean making diagrams for 100% of classes, 100% of states, 100% of sequences, etc., but rather diagramming what's most critical, most difficult to understand, and letting the rest emerge naturally during programming.

**Professor:** 2) Which Design Patterns and Agile concepts do you consider fundamental to be taught in academia? Or is that also not considered important?

**AkitaOnRails:** Design Patterns are important, but as a reference. They exist, are possible solutions but should be evaluated case by case. As for Agile techniques, only worry about Extreme Programming. All XP techniques are important. Scrum, Kanban, can be introduced but are unnecessary. About patterns:

* [Brazilian Portuguese Can Confuse Us: Standard vs Pattern](http://www.akitaonrails.com/en/2013/05/10/a-lingua-portuguesa-brasileira-e-pessima-standard-vs-pattern)
* [GoF Design Patterns - Did it survive the test of time?](http://www.akitaonrails.com/2007/07/30/gof-design-patterns-sobreviveu-ao-teste-do-tempo)
* [Design Patterns represent defects in Languages](http://www.akitaonrails.com/2006/10/30/design-patterns-representam-defeitos-nas-linguagens)

Adding here in the post: the important thing is to teach that you don't need to invent everything from scratch all the time (which would be a redundant effort, given that someone has already done it before). At the same time, it's important to explain that what we know today isn't perfect, it's just what seems to work better, and if someone thinks they have a result that surpasses what we know, please show us. It's very fashionable to keep talking about "Inversion of Control" and few people know what this really means, only that it seems to improve "modularization" — also without knowing why modularizing is a benefit sometimes, or not so much at others.

And speaking of Agile, I recommend reading these posts of mine:

* [Lean is Dead, Long Live Efficiency](http://www.akitaonrails.com/en/2014/03/27/off-topic-lean-esta-morto-longa-vida-a-eficiencia)
* [Agile: the Truth Behind the Method](http://www.akitaonrails.com/en/2014/09/28/off-topic-agile-a-verdade-por-tras-do-metodo)

**Professor:** 3) Does the OO Analysis and Design discipline still make sense today? What would be interesting to be addressed in it?

**AkitaOnRails:** Of course, but today you have to emphasize that OO (object orientation) isn't the only one and not necessarily the "best." By the way, OO is only interesting in academia if it's through the eyes of languages that really explore OO (Smalltalk, Ruby), class-oriented programming is Java and C#, functional programming (Lisp, Scheme), prototype-oriented programming (part of JavaScript, IO), programming with concurrency and actor aspects (Go, Scala, Elixir/Erlang).

Adding to the post, I should say that this is the kind of subject that doesn't have a "right" answer — any attempt to measure forces of one side or the other will always become merely a flamewar or a mediocre bikeshedding. The reality is that software factories will continue using languages that have good commercial tooling support like IBM Websphere, Microsoft Visual Studio.NET, etc. Tech startups, or smaller and more "best of breed" technology-oriented companies, will prefer open source solutions that, many times, may even seem like a "patchwork quilt." Agencies and small producers will continue using whatever offers the shortest possible delivery time, even if it's dirty (since advertising campaigns last very little), "quick and dirty," WordPress derivatives, and so on.

**Professor:** 4) Is it definitely still worth teaching Java in academia? Do you think Ruby and Rails or even Python and Django are more appropriate?

**AkitaOnRails:** Yes, it's worth it, but not as the only solution to everything. Nor as a good example of an OO language. Just as a commercially more viable language. Ruby and Python can be explored in the sense of dynamically typed languages (and explaining the difference between static and dynamic). But in academia, especially in Computer Science, I've always been in favor of teaching dead languages (Smalltalk, Lisp, Eiffel) precisely so that the student doesn't fall into the temptation of staying only with the language they learned in college. A bachelor's degree should prioritize foundation and not the aspect of "commercial use," which is the focus of technical and technologist schools.

Adding to the post, I believe Academia, especially in Computer Science chairs, must emphasize science. Going 100% to the market is creating a generation that will become obsolete very quickly and, worse, that won't know how to update themselves on their own. In a hypothetical scenario, if 100% of universities turned 100% to what the "market" needs, in 10 years we'd have our entire computing area completely junked. Universities need to elevate the "Science" of Computer Science.

Let me leave posts I wrote about university and career topics:

* [Should I go to college?](http://www.akitaonrails.com/en/2009/04/17/off-topic-devo-fazer-faculdade)
* [Career in Programming - Coding isn't Programming](http://www.akitaonrails.com/en/2014/05/02/off-topic-carreira-em-programacao-codificar-nao-e-programar)
* [Letter to a Young Programmer Considering a Startup](http://www.akitaonrails.com/en/2013/10/31/traducao-carta-para-um-jovem-programador-considerando-uma-startup#.VIYdkNYkMvs)

**Professor:** Sorry for the long email, but unfortunately there was no opportunity for us to talk at the event...

**AkitaOnRails:** Not at all, if the subject is relevant, it's worth discussing it. And I encourage everyone who attends events I'm at to call me if they want to discuss ways we can help improve education. This subject will never be irrelevant.
