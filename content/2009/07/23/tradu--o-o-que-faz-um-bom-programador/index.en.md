---
title: "[Translation] What Makes a Good Programmer?"
date: '2009-07-23T10:35:00-03:00'
slug: tradu--o-o-que-faz-um-bom-programador
tags:
- off-topic
- career
translationKey: what-makes-a-good-programmer
draft: false
---

Many people have asked me how to become a good programmer. They're usually more concerned with which language to learn, which course to take, which technical books to read. But, just like the authors of these two articles I'm going to translate, I'd say there are more important qualities to consider.

The first article is [What makes a good programmer?](http://www.techfounder.net/2009/07/22/what-makes-a-good-programmer/)


### An Analytical Thinker

Programmers need to be problem solvers. The programming process requires us to systematically break down complicated problems, plan and implement solutions, and find/eliminate small inconsistencies in code (bugs).

Analytical thinking also manifests in the ability to follow and understand complex logic across disparate code segments. This allows us to grasp abstract concepts like Object-Oriented methodologies and design patterns and implement them in practice.

### Has Clear Priorities

If I asked you to order the following items by priority, how would you order them?

- Security
- Maintainability
- Usability
- Performance
- LOC count (lines of code)

Take a moment to think about it, and then consider:

1. If you picked **LOC count** first, you failed completely by my criteria. In fact, LOC optimization can often go directly against the other metrics (like maintainability). A low LOC count should never be the objective, only the result of carefully applying good architecture.
2. If you picked **Performance** first, you're probably the person who writes articles about why you should use a _while_ loop instead of a _for_ loop because it was a few milliseconds faster in your benchmarks. You may suffer from premature optimization.  
  

> We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. – [Donald Knuth](http://en.wikipedia.org/wiki/Optimization_%28computer_science%29#When_to_optimize)

Performance needs to be good enough to satisfy application requirements. Outside of well-known pitfall cases (like running queries inside each iteration of a long loop), performance optimizations should be left until the end and even then done when appropriate (measure … measure … measure … optimize).

The only exception to this is if you are primarily developing performance-dependent applications (like low-level system drivers).

3. **Security** is more or less in the middle. Depending on the application and distribution model, this can be completely irrelevant or mission-critical. It falls mostly in the middle, and therefore can't be number 1.
4. **Maintainability** is definitely one of the most important attributes of a software application. High maintainability allows you to improve other attributes (like performance), _when it becomes necessary._  
  
Maintainability is the most important factor in keeping productivity high and costs low. For a long time I strongly believed this was **the** most important attribute of software design. However…
5. The most important attribute is **usability**. At the end of the day, the value of your application is what it delivers to the end user.  
  
We should always remember — software is not written to serve its developers or the systems it runs on. It's written to solve problems. If those problems are not solved, then the project is a failure.  
  
I wrote usability here as a more general term than just User Interface/UX effectiveness. Even a command-line application or a background service has its usability factors in terms of how well it addresses a specific need.

### Gets Things Done

> In principle, you are looking for people who are:  
> 
>   
> - smart, and,
> - get things done. 
> 
> [Joel Spolsky](http://www.joelonsoftware.com/articles/GuerrillaInterviewing3.html)

Perhaps the most important thing in a developer. You could be perfect at all the previous attributes and still be a mediocre programmer if you **don't get things done.** A mediocre but productive developer could easily replace several highly talented developers who move slowly, depending on their responsibilities.

At the end of the day you definitely want highly productive developers more than those who are great in theory but not in practice.

### Does More Than "Just Enough"

Getting things done is important. Getting things done "the right way" is even more important.

Constantly paying down your technical debt is crucial — if you keep accumulating debt by making quick-fix "hacks" that work but aren't maintainable, you're only creating the appearance of progress. In reality, the cost of paying off large technical debt could become prohibitive before you realize it.

Spending time to constantly refactor code into a more maintainable form is the best way to prevent the downward spiral that leads a project to its end.

### Accountable

A person could be a capable programmer in terms of technical skills alone, however if they don't own their own mistakes and don't respect deadlines they could become a liability very quickly.

Accountability means knowing when to leave your ego behind for the good of the project. We normally develop large egos as we consider ourselves experts in many things. Putting the project first is a sign of a good developer.

### Good Human Relations

Another important one, and this applies to programmers too. There's a stereotype that programmers are reclusive, anti-social creatures — but programmers are still people ;-)

To be part of a team or deal with clients, a programmer needs basic social skills. Rudeness, arrogance, short patience — there's no room for these in a professional work environment. All it takes is one rotten apple to ruin everyone's mood.

### That's It

If you answered positively to all of the above, you're probably a good programmer.

You may notice I didn't mention passion or technological diversity as qualifying attributes. Briefly, I don't think they're very relevant to programmer quality.

Passion is good to have, however I've known many high-quality professionals and developers who were perfectly satisfied going to work professionally from 9 to 5 and then going home to have meaningful and complete lives with their families. A programmer can definitely be completely professional without being passionate about programming.

Technological diversity is another good thing to have but is not a prerequisite — as long as you're in control of the technologies you work with, a lack of diversity shouldn't affect you that much. Decision-makers need to be well aware of all options before starting a project, however these days the choice of technologies simply isn't that important.

You can achieve good results regardless of the programming language and database, among other considerations. The most important consideration should be the type of skills available in your people.

## [Translation] Why Good Programmers Are Lazy and Dumb

**Source:** [blogoscoped](http://blogoscoped.com/archive/2005-08-24-n14.html)

I've noticed, paradoxically enough, that good programmers need to be both _lazy_ and _dumb._

**Lazy**, because only lazy programmers will want to write the kinds of tools that can replace themselves in the end. Lazy, because only a lazy programmer will avoid writing monotonous, repetitive code — thus avoiding redundancy, the enemy of software maintainability and flexibility. Moreover, the tools and processes that come out of this, driven by _laziness_, will increase production.

Of course, this is only half the truth. For a lazy programmer to be a good programmer, they (he or she) must also be extremely _not-lazy_ when it comes to learning how to be _lazy_ — that is, which software tools make their job easier, which techniques avoid redundancy, and how they can make their work more maintainable and easily refactored.

Second (and I'll elaborate more on this because I think this concept is less well-known than the first), a good programmer needs to be **dumb**. Why? Because if they're smart, and they know they're smart, they will:

1. stop learning
2. stop being critical about their work

Point a) will make it harder for them to try to find new techniques to allow them to work faster. Point b) will make it harder to debug their own work and refactor it. In the never-ending battle between a programmer and the compiler, it's better for the programmer to give up quickly and admit it's always _them_ and never the compiler that's at fault (unless it's character encoding, which is the part where even compilers make mistakes.)

But there's a more crucial point to why good programmers need to be dumb. To find the best solutions to a problem, they need to keep an open mind and think outside the box (or better, know its _actual_ shape). In a way, this leads to a child-like mentality — incredibly creative because they've never heard "no" as an answer.

The direct opposite would not be very constructive: being knowledgeable of the parameters at hand and accepting them. Because who knows how many limits you think exist that really don't? The less you know, the more radical your choices will be; the better the tools you develop, and the better the product you develop _with_ them.

I know from my work that a good programmer, when confronted with a management problem, will adopt this _dumb_ mentality — they'll start asking the most simple and childish questions. Because they don't accept the suggested parameters that someone _thinks_ define the problem. Here's a typical conversation from the lost land of web development:

- "Since yesterday, our client can't see the logo on the website."
- "Did he restart the browser?"
- "Yes."
- "Did he restart the computer?"
- "Yes."
- "Did he clear his cache?"
- "Yes."
- "Is he running Internet Explorer 6?"
- "Yes."
- "Is he sure he can't see it?"
- "Yes."
- "Is he looking at the website on his screen?"
- "What?"
- "Well, he might have printed it."
- "No, he was looking at the screen."
- "He also couldn't see other images besides the logo?"
- "What? Well, let me ask him."

Just for the sake of argument (this was entirely hypothetical) let's say the client had turned off images in their browser. Or their kid did. Whatever the case, this answer would never have been found if you were working with a programmer in<sup class="footnote" id="fnr1"><a href="#fn1">1</a></sup> "smart" mode. None of the questions asked by the programmer required any programming skill. No — simply because the problem is so stupid, only stupidity can solve it.

> <sup class="footnote" id="fnr1"><a href="#fn1">1</a></sup> A few years ago, I had a long phone discussion about the website having broken since my last update… it turned out the person had disabled stylesheets in their browser. At the time I would have suspected everything **except** such a simple solution and I spent half an hour listening to complaints about quality standards, etc. In the end, the premise that my update was to blame was just that… a premise. Better to hear **only the facts** when starting to debug, and never what people **think** might be the reason.

Similarly, when one of my programmer colleagues asks me "Why isn't this working?" most of the time it's because they're working on the wrong file (e.g., they linked to library 1, but edited library 2, and their changes don't show up, or they simply didn't link to the library at all). When you ask your colleague for help, particularly about programming, you expect them to know less about the project… so they ask stupid questions that you subconsciously avoided asking yourself, because you thought you knew the answers, when in fact you didn't.

There's another side to this. The person who's too dumb will just run off and, without thinking twice, do something wrong. The person who's too smart will sit and plan something correctly, without taking any action. A pragmatic programmer is somewhere in the middle — they know that making the wrong decision 1 time in 10 doesn't hurt the goals as badly as 5 right decisions in 10, and _deciding nothing_ the other 5 times.

It's like the story of the centipede. The centipede was very good at walking with its hundred legs. It never thought about how it managed to walk. Until one day, when a large black insect asked it "How do you _walk_ with so many feet? Don't you find it hard to coordinate your rhythm?" The large black insect had already walked away, while the centipede was still sitting there, pondering _how_ it managed to walk, wondering and (for the first time in its life) even worrying a bit. From that day on, the centipede could no longer walk.

So, better not to think too much if you want to get anything done. And of course, that's only half the truth too…
