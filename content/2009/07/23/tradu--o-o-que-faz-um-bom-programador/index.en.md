---
title: "[Translation] What Makes a Good Programmer?"
date: '2009-07-23T10:35:00-03:00'
slug: tradu--o-o-que-faz-um-bom-programador
translationKey: tradu--o-o-que-faz-um-bom-programador
description: "Two translations argue that good programmers prioritize usability, responsibility, collaboration, and delivery. The second adds creative laziness and the humility to ask simple questions while debugging."
tags:
- software-engineering
- career
- learning
- off-topic
draft: false
---

Many people have asked me how to become a good programmer. They're usually more concerned with which language to learn, which course to take, which technical books to read. But, just like the authors of these two articles I'm going to translate, I'd say there are more important qualities to consider.

The first article is [What makes a good programmer?](http://web.archive.org/web/20090723103949/http://www.techfounder.net/2009/07/22/what-makes-a-good-programmer/)


### An Analytical Thinker

Programmers need to be problem solvers. The process of programming requires that we systematically break complicated problems down, plan and implement solutions and find / eliminate small inconsistencies in code (bugs).

Analytical thinking also manifests in the ability to follow complicated logic through disparate code segments and understand it. It allows us to grasp abstract concepts such as Object Oriented methodology and design patterns and implement it in practice.

### Has Clear Priorities

If I would ask you to rate the following according to priority, how would you order them?

- Security
- Maintainability
- Usability
- Performance
- LOC (lines-of-code) count

Take a moment to think about that, and then consider:

1. If you picked **LOC count** first, you failed big time in my book. In fact, LOC optimization can often go directly against the other metrics (such as maintainability). A lower LOC count should never be a goal, only a result of careful application of well factored architecture.
2. If you picked **performance** first, you are probably the guy who keeps writing articles about how you should use a _while_ loop instead of a _for_ loop since it came out a few milliseconds faster in your benchmarks. You might be inflicted with a case of premature optimization.  
  

> We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. – [Donald Knuth](http://en.wikipedia.org/wiki/Optimization_%28computer_science%29#When_to_optimize)

Performance should only be good enough to satisfy the requirements of the application. Aside from caveats to well-known pitfalls (such as executing queries in each iteration of a long loop), performance optimizations should be deferred to the very last and even then should be used appropriately (profile ... profile ... profile ... optimize).

The only exception to this is if you are primarily developing performance dependent applications (such as low-level system drivers).

3. **Security** is on somewhat of a middle ground. Depending on the application and distribution model it can be completely useless or mission critical. It's mostly somewhere in between, and thus can't be ranked as number one.
4. **Maintainability** is definitely one of the most important attributes of a software application. High maintainability allows you to improve other attributes (such as performance), _when it is needed._  
  
Maintainability is the single most important factor for keeping productivity up and costs down. For a long time I strongly believed this to be **the** most important attribute of software design. However…
5. The most important attribute is **usability**. In the end, the worth of your application is only as much value as it delivers to the end-user.  
  
We should always remember - software is not written to serve its developers or the systems they run on. They are written to solve problems. If those problems are not solved, then the project is a failure.  
  
I wrote usability here as a more general term than just UI/UX effectiveness. Even a command line application or a background service has its usability factor in the sense of how well it answers a specific need.

### Gets Things Done

> In principle, it's simple. You're looking for people who are  
> 
> 1. Smart, and  
> 2. Get things done.  
> 
> [Joel Spolsky](http://web.archive.org/web/20090727035257/http://www.joelonsoftware.com/articles/GuerrillaInterviewing3.html)

Quite possibly the single most important trait in a developer. You can excel at all the previous attributes and still be a mediocre programmer if you just **can't get things done.** One average but productive developer could easily replace several highly talented but slowly moving developers, depending on his responsibilities.

At the end of the day you definitely want more highly-productive developers than those who are high on theory but not actual work.

### Does More Than "Just Enough"

Getting things done is important. Getting things done "the right way" is even more important.

Constantly paying off your technical debt is crucial - if you keep accruing debt by "hacking" quick fixes that work now but are not maintainable, you only create the appearance of progress. In reality, the cost of getting rid of a large technical debt could become prohibitive before you know it.

Taking the time to constantly refactor code into a more maintainable state is the best way to prevent the spiral into project oblivion.

### Accountable

A person could be a very capable programmer on technical ability alone, however if he does not own up to his mistakes and does not respect deadlines he could become a liability very quickly.

Responsibility also means to know where to let go of your ego for the good of the project. We developers often have large egos as we consider ourselves experts on many things. Putting the project first is a sign of a good developer.

### Good Human Relations

Another all-around useful trait, this one applies to programmers as well. There is some stereotype that programmers are reclusive, unsociable creatures - programmers are still _people_.

In order to be a part of a team or handle clients, a programmer must have above basic social skills. Rudeness, arrogance, short-temper - do not have a place in a professional work environment. All it takes is one bad apple to ruin the mood for everybody.

### That's It

If you answer to all of the above, you are probably a pretty good programmer.

You might notice I didn't mention passion or technological diversity as qualifying traits. Simply put, I don't think they're very relevant to the quality of a programmer.

Passion is nice to have, however I've known many very professional and high-quality developers who were just content to go about their work professionally from 9 to 5 and then go home and have a meaningful and fulfilling family life. A programmer can definitely be completely professional without being passionate about programming.

Technological diversity is another nice to have but not a prerequisite - as long as you are in command of the technologies you work with, a lack of diversity shouldn't affect you too much. Decision makers need to be well aware of all the options before starting a project, however nowadays the choice of technology simply is not that important.

You can achieve good results regardless of the programming language and database engine among other consideration. The biggest consideration should be the type of skills available to your personnel.

## [Translation] Why Good Programmers Are Lazy and Dumb

**Source:** [blogoscoped](http://blogoscoped.com/archive/2005-08-24-n14.html)

I realized that, paradoxically enough, good programmers need to be both _lazy_ and _dumb_.

**Lazy**, because only lazy programmers will want to write the kind of tools that might replace them in the end. Lazy, because only a lazy programmer will avoid writing monotonous, repetitive code – thus avoiding redundancy, the enemy of software maintenance and flexible refactoring. Mostly, the tools and processes that come out of this endeavor fired by laziness will speed up the production.

Of course, this is only half the truth; for a lazy programmer to be a good programmer, he (or she) also must be incredibly unlazy when it comes to learning how to stay lazy – that is, which software tools make his work easier, which approaches avoid redundancy, and how he can make his work be maintained and refactored easily.

Second (and I will elaborate a bit more on this because I find the concept to be less known than the first) a good programmer must be **dumb**. Why? Because if he's smart, and he knows he is smart, he will:

a) stop learning
b) stop being critical towards his own work

Point a) will make it hard for him to try to find new techniques to allow him to work faster. Point b) will give him a hard time debugging his own work, and refactoring it. In the endless battle between a programmer and the compiler, it's best for the programmer to give up early and admit that it's always him and never the compiler who's at fault (unless it's about character encoding issues, which is the part even the compiler gets wrong).

But there's a more crucial point why a good programmer must be dumb. That's because for him to find the best solutions to problems, he must keep a fresh mindset and manage to think out of the box (or rather, know its _actual_ shape). In a way, this leads to the mindset of a child; incredibly creative because he never heard "no" for an answer.

The direct opposite approach would not be very constructive; to be knowledgeable about the parameters at hand, and accept them. Because who knows how many limits you think are there for real? The less you know, the more radical will your approaches be; the better the tools you develop, and the better the product you develop _with_ them.

I know from my work that a good programmer, when confronted with a problem from management, will adopt this mindset of being _dumb_; he will start asking the most simple, child-like questions. Because he doesn't accept the parameters suggested to him that someone _thinks_ make up the problem. Here's a typical conversation from the lost land of web development:

- "Since yesterday, our client can't see the logo on the web site."
- "Did he restart his browser?"
- "Yes."
- "Did he restart his computer?"
- "Yes."
- "Did he empty his cache?"
- "Yes."
- "Does he run Internet Explorer 6?"
- "Yes."
- "Is he sure he can't see it?"
- "Yes."
- "Did he look at the web site on the screen?"
- "What?"
- "Well, he might have printed it out."
- "No, he was looking on it on the screen."
- "Did he also not see other images besides the logo?"
- "What? Well, I will ask him."

For the sake of argument (and this was entirely hypothetical) let's say the client indeed turned off images in his browser. Or his son did. Whatever the case, this answer could not have been found if you would work in "smart" mode<sup class="footnote" id="fnr1"><a href="#fn1">1</a></sup>. None of the questions asked by the programmer required any programming skills. No; simply because the problem is so stupid, only stupidity can tackle it.

> <sup class="footnote" id="fnr1"><a href="#fn1">1</a></sup> Some years ago, I had a long telephone discussion about the whole web site being messed up since my last update... it turned out the guy disabled stylesheets in his browser. Back then, I would have suspected everything but such a simple solution and was listening to half an hour of complaints about quality standards etc. In the end, the assumption that my update was at fault was just that... an assumption. You better listen to facts only if you start debugging, and never to what people think might be the reason.

In similar fashion, when one of my co-programmers asks me: "Why isn't this working?" most of the time it's because they're working on the wrong file (e.g., they linked to library 1 but they've altered library 2, and their revision isn't showing, or they simply didn't link the library at all). When you ask a colleague for help, particularly in programming, you want him to know less about your project... so he will ask the stupid questions you sub-consciously avoided asking yourself because you thought you knew the answer, when in fact you didn't.

There's another side to it. The too-stupid person will just run off and, without a second thought, do something wrong. The too-smart person will sit down and plan something right, without taking any action. A pragmatic programmer is sort of in-between; he knows making the wrong decision 1 out of 10 times doesn't hurt the goal as bad as making only right decisions 5 out of 10 times, and making no decision at all the other 5 times.

It's like the story of the centipede. The centipede was very good at walking with its hundred legs. It never spent a thought on just how it could walk. Until one day, when a big black bug asked the centipede "How can you manage to walk with all those feet? Don't you find it hard to coordinate their rhythm?" The black bug already left, when the centipede was still sitting down, pondering how it could walk, wondering, and (for the first time in his life) even worrying a little bit. From that day on, the centipede couldn't walk anymore.

So you better not think too much if you want to achieve something. And of course this is only half the truth, too...
