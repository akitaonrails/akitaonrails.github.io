---
title: "[Off-Topic] The Humble Programmer, by Edsger W. Dijkstra"
date: '2010-04-12T08:49:00-03:00'
slug: off-topic-o-programador-humilde-por-edsger-w-dijkstra
translationKey: off-topic-o-programador-humilde-por-edsger-w-dijkstra
description: "Dijkstra argues for humility before the difficulty of programming: avoid bugs from the start, use abstractions and modest languages, because no tool eliminates complexity."
tags:
- software-engineering
- programming-languages
- off-topic
draft: false
---

[![](http://s3.amazonaws.com/akitaonrails/assets/2010/4/12/450px-Edsger_Wybe_Dijkstra_original.jpg)](https://www.cs.utexas.edu/~EWD/transcriptions/EWD03xx/EWD340.html)

After writing my article on Info, [Software Factory Is Nonsense](http://web.archive.org/web/20130723194737/http://info.abril.com.br:80/noticias/rede/gestao20/software/fabrica-de-software-e-uma-besteira/), I got a retweet with a very good link to a text I didn't know: [The Humble Programmer](https://www.cs.utexas.edu/~EWD/transcriptions/EWD03xx/EWD340.html).

The author is the great [Edsger W. Dijkstra](https://en.wikipedia.org/wiki/Edsger_W._Dijkstra), best known for the seminal paper [A Case against the GO TO Statement](https://www.cs.utexas.edu/~EWD/transcriptions/EWD02xx/EWD215.html). The Humble Programmer is the speech he gave when he received the 1972 Turing Award.

The text is fantastic and worth reading in full, but I pulled a few excerpts to comment on. The most interesting thing is to read it with the late 60s in mind and see how much of what he hoped for the future is something we, almost four decades later, are still waiting for. I didn't publish this one on Info for two reasons: first, it's more aimed at programmers, and second, it's one of my "Akita-sized" texts :-)

> Two opinions about programming date from those days. I mention them now, I shall return to them later. The one opinion was that a really competent programmer should be puzzle-minded and very fond of clever tricks; the other opinion was that programming was nothing more than optimizing the efficiency of the computational process, in one direction or the other.

Unfortunately, the image of the programmer has changed, but toward two extremes. On one side we have the super-programmers, the renowned authors. On the other, the profession itself became a commodity, an abundant and cheap consumer good, precisely because of what I discussed in the piece about software factories.

This artificial cheapening of the profession leads to decay and to a longer wait for research and progress in the field. The competition to lower the price almost always comes from globalization: shipping the task to regions where labor is cheaper, like India and China. Raising the technical quality of processes and technologies falls to second place.

That doesn't mean everyone in the profession is a line worker. Those who grew on their own and evolved hold respectable positions and tasks, but that owes more to individual effort.

> The latter opinion was the result of the frequent circumstance that, indeed, the available equipment was a painfully pinching shoe, and in those days one often encountered the naive expectation that, once more powerful machines were available, programming would no longer be a problem, for then the struggle to push the machine to its limits would no longer be necessary and that was all what programming was about, wasn't it? But in the next decades something completely different happened: more powerful machines became available, not just an order of magnitude more powerful, even several orders of magnitude more powerful. But instead of finding ourselves in the state of eternal bliss of all programming problems solved, we found ourselves up to our necks in the **software crisis**! How come?

At least today no one assumes programming will get simpler just because machines get better. But notice something I always repeat: plenty of people think software problems are recent, when the term "software crisis" was coined back in the 70s. And to this day it hasn't been solved.

> The vision is that, well before the seventies have run to completion, we shall be able to design and implement the kind of systems that are now straining our programming ability, at the expense of only a few percent in man-years of what they cost us now, and that besides that, these systems will be **virtually free of bugs**. These two improvements go hand in hand. In the latter respect software seems to be different from many other products, where as a rule a higher quality implies a higher price. Those who want really reliable software will discover that they must find means of avoiding the majority of bugs to start with, and as a result the programming process will become cheaper. If you want more effective programmers, you will discover that they should not waste their time debugging, they should not introduce the bugs to start with. In other words: both goals point to the same change.

_"More effective programmers ... should not waste their time debugging"_. That conclusion is almost four decades old. And yet today's programmers, trained in colleges to serve the "factory" and become tool workers, throw hysterical fits when their editor doesn't ship specific debugging features.

_"Those who want really reliable software will discover that they must find means of avoiding the majority of bugs."_ That is, efficiency lives in stopping the bug from ever entering the code. Chasing it down afterward, as fast as possible, is the wrong game.

I know it sounds pedantic, but we have techniques for this, and most programmers don't use them. They aren't even taught in college. Look up [Extreme Programming](http://web.archive.org/web/20100314121601/http://www.improveit.com.br/xp/livroxp).

To keep bugs from slipping in through carelessness (avoiding most of them, since zeroing out 100% is impossible), there are techniques like [Test First](http://www.extremeprogramming.org/rules/testfirst.html), [Pair Programming](http://www.extremeprogramming.org/rules/pair.html), [Continuous Integration](http://www.extremeprogramming.org/rules/dedicated.html), [Tests to Avoid Regression Bugs](http://www.extremeprogramming.org/rules/bugs.html), and [Acceptance Tests](http://www.extremeprogramming.org/rules/functionaltests.html). Simple, efficient methods, and a good chunk of the market doesn't even know they exist.

> Now for the economic need. Nowadays one often encounters the opinion that in the sixties programming has been an overpaid profession, and that in the coming years programmer salaries may be expected to go down. Usually this opinion is expressed in connection with the recession, but it could be a symptom of something different and quite healthy, viz. that perhaps the programmers of the past decade have not done so good a job as they should have done. Society is getting dissatisfied with the performance of programmers and of their products. But there is another factor of much greater weight. In the present situation it is quite usual that for a specific system, the price to be paid for the development of the software is of the same order of magnitude as the price of the hardware needed, and society more or less accepts that. But hardware manufacturers tell us that in the next decade hardware prices can be expected to drop with a factor of ten. If software development were to continue to be the same clumsy and expensive process as it is now, things would get completely out of balance. You cannot expect society to accept this, and therefore we must learn to program an order of magnitude more effectively. To put it in another way: as long as machines were the largest item on the budget, the programming profession could get away with its clumsy techniques, but that umbrella will fold rapidly.

And this has been our challenge for the last few decades: "cheapening" the task of programming. The problem is you can take that the wrong way. One path is cheapening the labor, and all it takes is grabbing poorer countries that charge less. Another is cheapening the technology.

That second path works up to an inflection point, when we'd need a new rung of sophistication and don't have it, because the cheapening itself cut the research and the innovation in the field. The whole argument turns on _"how not to make more expensive what is already expensive today"_. One way out is to advance the technology to automate manual tasks.

To this day there are still "programmers" who waste time opening the same windows and clicking the same "next, next, next" buttons every time they need to package a new version of the software. That's automatable, but since the guy was trained only to follow procedures, most don't think they're capable of turning that into a script. It's the case where the "cheapening" of labor and of training blocks the cheapening of processes and the advance of technology. It was a problem in the 70s and it still is in the 21st century.

> Argument three is based on the constructive approach to the problem of program correctness. Today a usual technique is to make a program and then to test it. But: program testing can be a very effective way to show the presence of bugs, but is hopelessly inadequate for showing their absence. The only effective way to raise the confidence level of a program significantly is to give a convincing proof of its correctness. But one should not first make the program and then prove its correctness, because then the requirement of providing the proof would only increase the poor programmer's burden. On the contrary: the programmer should let correctness proof and program grow hand in hand. Argument three is essentially based on the following observation. If one first asks oneself what the structure of a convincing proof would be and, having found this, then constructs a program satisfying this proof's requirements, then these correctness concerns turn out to be a very effective heuristic guidance.

I have to admit that here Dijkstra is talking about formal mathematical proofs. But I'd like to stretch the concept. What he says is that the right way would be to first create a "proof" and only then implement the code that meets that "proof's" requirements.

I'd venture that Dijkstra was practically a pioneer of the "Test First" idea in Extreme Programming, also known as TDD, or "Test Driven Development." The cycle is simple: 1) write a test that describes the requirement; 2) run the test and watch it fail, since the code doesn't exist yet; 3) implement the minimum to make the test pass; 4) move on to the next requirement. Dijkstra already knew, almost four decades ago, that this order of development is what minimizes the volume of bugs down the line, on top of dozens of other benefits we discovered later.

> Argument four has to do with the way in which the amount of intellectual effort needed to design a program depends on the program length. It has been suggested that there is some kind of law of nature telling us that the amount of intellectual effort needed grows with the square of program length. But, thank goodness, no one has been able to prove this law. And this is because it need not be true. We all know that the only mental tool by means of which a very finite piece of reasoning can cover a myriad cases is called "abstraction"; as a result the effective exploitation of his powers of abstraction must be regarded as one of the most vital activities of a competent programmer. In this connection it might be worth-while to point out that the purpose of abstracting is not to be vague, but to create a new semantic level in which one can be absolutely precise. (...) The by-product was the identification of a number of patterns of abstraction that play a vital role in the whole process of composing programs. Enough is now known about these patterns of abstraction that you could devote a lecture to about each of them.

This point is more complex and has to do with the programmer's capacity for abstraction. The concept itself is "abstract" and hard to define. The first part is talent: someone with no talent for programming won't become a programmer, period.

Starting from the premise that the spark of talent exists, in come the thousands of hours of practice. And I mean practicing real code, experimenting with the most varied situations possible. Repeating procedures doesn't count.

Only then does intuition emerge from experience, and that's what lets you spot patterns in code, opportunities for refactoring and optimization, higher-level constructs to simplify the program, and so on. The path starts with the programmer following procedures, but it has to evolve quickly into experimentation. This is fundamental.

As a curiosity, part of what he describes is what we also know today as "Design Patterns."

> Now for the fifth argument. It has to do with the influence of the tool we are trying to use upon our own thinking habits. I observe a cultural tradition, which in all probability has its roots in the Renaissance, to ignore this influence, to regard the human mind as the supreme and autonomous master of its artefacts. But if I start to analyse the thinking habits of myself and of my fellow human beings, I come, whether I like it or not, to a completely different conclusion, viz. that the tools we are trying to use and the language or notation we are using to express or record our thoughts, are the major factors determining what we can think or express at all! The analysis of the influence that programming languages have on the thinking habits of its users, and the recognition that, by now, brainpower is by far our scarcest resource, they together give us a new collection of yardsticks for comparing the relative merits of various programming languages. **The competent programmer is fully aware of the strictly limited size of his own skull**; therefore he approaches the programming task in full humility, and among other things he avoids clever tricks like the plague. (...) Another lesson we should have learned from the recent past is that the development of "richer" or "more powerful" programming languages was a mistake in the sense that these baroque monstrosities, these conglomerations of idiosyncrasies, are really unmanageable, both mechanically and mentally. I see a great future for very systematic and very modest programming languages.

A good programmer recognizes his own limitations and looks for the tools that best fit the problems. Most language wars start with arguments like this. The trouble is that insisting on a _"single language"_ and piling onto it everything everyone wants ends up creating a "baroque" monster, as Dijkstra puts it.

Programmers are people, and people have limited brains. We need to be able to express ourselves in code, and the more complicated the tool, the more of our mind goes into keeping the pieces in our head and the less is left for writing elegant code.

Look at Dijkstra himself. Up to the 70s he practically watched computers being born and followed almost everything up close, from machine language to Fortran, Lisp, and Algol. If back then he could know several languages in depth, I see no excuse today, with all the resources we have, for not knowing an order of magnitude more languages, technologies, and techniques.

He talks about more "modest" languages, and I'd say those are today's dynamic high-level languages, like Ruby or Python. Abstractions that allow even larger systems with less complexity.

> As an aside I would like to insert a warning to those who identify the difficulty of the programming task with the struggle against the inadequacies of our current tools, because they might conclude that, once our tools will be much more adequate, programming will no longer be a problem. Programming will remain very difficult, because once we have freed ourselves from the circumstantial cumbersomeness, we will find ourselves free to tackle the problems that are now well beyond our programming capacity.

And since the 70s we know there's **no silver bullet**. No new tool will magically make programming orders of magnitude more efficient. There's no free lunch.

> It has already taught us a few lessons, and the one I have chosen to stress in this talk is the following. We shall do a much better programming job, provided that we approach the task with a full appreciation of its tremendous difficulty, provided that we stick to modest and elegant programming languages, provided that we respect the intrinsic limitations of the human mind and approach the task as Very Humble Programmers.

Programmers need to be Humble in the right sense of the word: to own their own limitations and create new techniques, technologies, and ways to do the same work with more quality and more efficiency, breaking rules and traditions and creating new standards. The programmers who only follow what they were taught, just the procedures, are **arrogant**: they think everything worth discovering has already been discovered.

I always [repeat](https://blogoscoped.com/archive/2005-08-24-n14.html) that a good programmer is dumb and lazy. Dumb because if he thinks he's smart he'll also think he already knows everything, and whoever knows everything stops researching. And lazy because an overly hardworking programmer repeats the same procedure every day with great diligence, while the lazy one gets tired of it, automates the work, and still has time left to rest.

I think Dijkstra would agree with that ;-)
