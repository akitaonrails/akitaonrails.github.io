---
title: "[Off-Topic] Thinking Makes You Better"
date: '2009-09-26T16:17:00-03:00'
slug: off-topic-procurar-raciocionar-faz-bem
tags:
- off-topic
- principles
- career
- agile
draft: false
---

[![Rails Summit 2009](http://railssummit.com.br/imgs/43/original/728x90.gif)](http://www.railssummit.com.br?utm_campaign=Railssummit&utm_source=banner_parceiros&utm_medium=banner&utm_content=por_728x90)

This week some interesting articles emerged, all related in some way to "Agile" software development thinking.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/Screen_shot_2009-09-26_at_6.51.42_PM_original.png)

The first, which I thought was very good, was [10 Reasons Why Pair Programming Is Not for the Masses](http://blog.obiefernandez.com/content/2009/09/10-reasons-pair-programming-is-not-for-the-masses.html) that Obie Fernandez wrote about his own experience with pair programming and why it is difficult to implement in most places.

These points boil down to physical limitations (cubicles are so twentieth century...), corporate conventions still in vogue (interviews done by HR based on resume, prioritizing certification, for example). For me, two of the most important points are the 6th and the 2nd. As with any concept, interpreted the wrong way, it will give wrong results.

The first thing a programmer needs to understand about pair programming is that there are always pilot and co-pilot. There's the image that the pilot is the productive individual at that moment and the co-pilot just looks and follows, passive, silent. Far from it: this is the wrong way to pair and is the way that, correctly, non-programmers (managers, etc.) imagine they're paying for 2 people but getting only 1's service. In pair programming, **both** must necessarily be participating. The co-pilot must be alert to the pilot's errors. The co-pilot must be thinking ahead, already imagining better alternatives, they must both be engaged in finding the best solutions. More than that: the keyboard and mouse must be able to switch hands constantly. There is no pairing where the co-pilot spends the whole day just watching. If the co-pilot is passive and silent, the pilot is flying alone, it's as if he were alone, period.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/ying_eric_pair_programming_original.jpg)

There are at least two types of pairs: where both are reasonably equivalent in terms of capabilities or where one of the two is less experienced or has somewhat different capabilities. In the first case, the dynamics must be more obvious, ideas will bounce off each other more, they will be able to decide things more quickly. In the second case, one of them has the goal of learning quickly. More than that, the one who knows less has the obligation to take more risks, always under the supervision of the more experienced. And he must never be passive, he must seek knowledge outside when they're not pairing, and he must never expect that everything he will learn is the pilot's obligation to teach. That's wrong: the one who knows less is the one who always has the obligation to chase after it, or else assume that he won't succeed and give up the position.

Remembering that the fundamental value of Agility is called _"Accountability"_, I can't translate that literally to Portuguese, but it would be something beyond "responsible." An Agile team is a team that is consciously "accountable" for what they do. When they decide, together with the client, the product owner, about the Sprint Backlog, for example, they are not receiving "orders" like "_this sprint will have these 10 user stories because the boss ordered it._" No, the team that commits to 10 stories is actually "committing," that is, they are aware of their speed, their capabilities and their weaknesses and make a rational decision based on that. A team that later says "_we couldn't deliver because they asked too much,_" is shirking their responsibility. They should have said at the beginning, "_no, we'll only be able to do 8 of these user stories, 10 is too much._" Agreed doesn't get expensive. It's all about getting expectations right and negotiating, collaborating to find the best solution, not "any" solution.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/pair_programming_original.jpg)

The same applies in the reduced world between 2 programmers pairing. Both need to be committed to what they're producing and to their colleague. If one of them is less experienced, he should not be the dead weight. On the other hand, of course, if the more experienced sees that the other is trying, he should help him. There is a limit, of course, between "helping" and "carrying on one's back." Here honesty applies, and that's why there's a phase at the end of the Sprint called "Retrospective," it's exactly the moment to discuss this and leave everything open, out in the open. "_I don't like the fact that I'm producing alone, while my partner isn't helping._"

Pair Programming, by itself, is just a technique. But remember that before that there are the values of the [Agile Manifesto](http://agilemanifesto.org/). Everyone always forgets: _"Individuals and Interactions over Processes and Tools."_ If you're still asking yourself "_which Agile techniques should I choose to use_," you still haven't gotten it. Above all: are you committed to your project? Is your team committed to the project and to their peers? What are the problems you want to solve? Agility, by itself, is not a magic recipe. It has purposes, if you're not aiming at these purposes, but just randomly choosing 2 or 3 practices, that doesn't make you Agile, that just makes you random.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/493px-Joel_spolsky_on_20_sept_2007_original.jpg)

Then comes Joel Spolsky's article on [The Duct Tape Programmer](http://www.joelonsoftware.com/items/2009/09/23.html). In this article he celebrates a programmer named Jamie Zawinski, indeed a great programmer, who worked at Netscape producing software that helped change the world, literally. Zawinski, according to Spolsky, is the type "_let's ship software as fast as possible, no matter how._" and also the type "_unit tests are beautiful, but when the deadline is tight, what matters is to ship fast, and tests get in the way._" Read the wrong way, it becomes an excuse for bad programmers to say: "_Yay! I'm confirmed! Joel Spolsky said it's beautiful to be a cowboy programmer!_" Worse still: "_Joel Spolsky said I don't need to worry about tests._"

Before jumping to any precipitate conclusion — damn "fast-food" generation — read the response to this post written by the good and old [Uncle Bob Martin](http://blog.objectmentor.com/articles/2009/09/24/the-duct-tape-programmer) where he refutes these arguments. In reality Spolsky and Bob have already "clashed" a few times in the past when in a podcast [Spolsky belittled TDD and SOLID principles](http://www.infoq.com/news/2009/02/spolsky-vs-uncle-bob).

Robert Martin, if you don't know him, was the one who originated the meeting of about 10 years ago, together with the main thinkers in software development like Kent Beck, Martin Fowler, Dave Thomas, Jeff Sutherland, among so many others, that gave rise to the Agile Manifesto. He is an active programmer since before any of us were even born and still programs today. And I'm not saying a senior who only programs in Cobol, quite the contrary, who has gone through the main technological platforms, understands object-oriented programming like no one else, programs in Java, and is a defender of [Clean Code](http://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882). In fact, if you are a Github user, you can find some of [Bob's projects](http://github.com/unclebob) there too.

Some time ago, I would probably have been [cursing and cursing](/2006/9/27/flame-war-joel-spolsky-vs-rails) Spolsky, but I think I understand his position. Giving the context, Spolsky is indeed a great businessman, has a successful company, with successful niche products, doesn't fail to be an earlier generation 37signals. Ex-Microsoft employee, he was one of the people responsible for the existence of Visual Basic for Applications, which to this day is the heart of Excel and the darling of any accountant, analyst, etc. who basically can't live without Excel macros. Together with Jeff Atwood he maintains the famous site [StackOverflow](http://stackoverflow.com/). Besides that he has the excellent book [Joel on Software](http://www.amazon.com/Joel-Software-Occasionally-Developers-Designers/dp/1590593898).

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/photo_martin_r_original.jpg)

At this point I'm assuming I don't need to explain to you what [Agility](http://en.wikipedia.org/wiki/Agile_software_development) is, nor what some of the main good practices of [Extreme Programming](http://www.extremeprogramming.org/) are, nor what the [SOLID principles](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod) of Bob Martin are. I'm also assuming you've read at least some of [Spolsky's articles](http://www.joelonsoftware.com/) to get an idea of what he usually talks about.

Normally an agilist looks like he's in a position of "convincing" others of why being agile is better. More than that: that being "agile" and being "fast" are not synonyms. Being fast is a side effect of being agile. These interpretations are subtle.

That's why what I curse is the fast-food generation: a generation that got used to thinking that things are simple and superficial. That it's enough to buy a "lose weight in 7 days" book to actually lose weight. Surprise: if this kind of thing really worked, there would be no obese people in the world. Duh.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/BurningTheWitch_original.jpg)

This same generation reads what Spolsky says and, superficially, comes to the conclusions I mentioned above: "_Spolsky agrees I should be a cowboy._" And I think many of us, agilists, are victims of this too. In the haste to answer this superficiality, we even end up crossing the line. Bob Martin, for example, could have simply ignored this post instead of responding.

Passive people, conformists, wait to be validated. They don't understand why they do what they do, they just do. Of course, they do what seems simplest to them, easiest, safest, and not what has a chance of being better, which could bring more benefits, or that is new. They want people to like them. It doesn't matter if they're doing the right things or not. It doesn't matter if there's a better way. That's why this thirst for validation. That's what I translated in the article [The Cult of Gray Morality](/2009/09/08/off-topic-o-culto-da-moral-cinzenta).

When someone of "caliber" — at least perceptible "caliber" — like Spolsky posts something like this, thousands of obviously bad programmers around the world feel validated, justified. It's a sad scenario.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/BRILLIANT_original.jpg)

And Spolsky is not wrong. What he puts in each of his articles are pieces of his own experience. Each piece, individually, means absolutely nothing. And it should not be taken literally. In fact, neither is what Bob Martin writes in an article. Nor even what I write in an article. The result of the sum of the parts is orders of magnitude greater than the simple sum of the individual values of each part. This is how chaos works.

Both, Spolsky and Bob, are not antagonistic. What one says doesn't invalidate what the other says. That's the trick. Both are "pragmatic," at least according to William James's definition of Pragmatism, where something is true for a person if it has utility for her, regardless of whether that truth remains true for another person. (of course, there still exists Peirce and Dewey's interpretation of pragmatism, but that's another story). Both try to explain what they do that works for them. Within a context, within the understanding of the premises, within the understanding of the values, this might perhaps work for you too.

What I mean is that what Spolsky says makes sense to him. What Bob Martin says makes sense to him. If what they say makes sense to me, or to you, that is **not** their problem, it's not their fault, it shouldn't even be in their interest. Likewise, don't use their names to justify what you do or say without understanding why you're saying it. "_I do TDD because Kent Beck said it's good_" is as bad to say as "_I do glue-code because Zawinski said it's better._"

You should say: "_I do TDD because I **know** what benefits it brings me._" Or, "_I do glue-code from time to time because I'm **aware** of the consequences this will bring me and accept paying the price for it._" Or, "_I don't do pair programming all the time because I've already **analyzed** and concluded that in my case it doesn't work very well._"

In fact, everything I say here — in my blog — are musing, personal reflections, that by chance find their way into written form. Some think I "_think I'm the owner of the truth._" Well, that's a problem for whoever thinks that, not mine.

Truth be told: just as Bob says in his article, I don't do tests all the time, nor first tests as TDD dictates. I got to know Extreme Programming practices many years after I started as a programmer. I was an extremely cowboy programmer for most of my career. And, even understanding why all agile practices are good and why I should use them, I still reason where and when I should use what. Meaning, I understand the principles, the premises and the expected results. Otherwise this would be [dogmatization](http://en.wikipedia.org/wiki/Dogma) and, by definition, everything that is dogmatized is bad. **Dogmas are the source of all evil.** Everything must be questioned, tried, measured, analyzed and only then can some conclusion arise and, even then, it can be refuted in the future by new evidence. The opposite of Dogma or even Cargo Cult is the [Scientific Method](/2008/12/16/off-topic-m-todo-cient-fico-vs-cargo-cult) as I explained before.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/world-trade-center_original.jpg)

Just because it was Martin Fowler who said it, doesn't make it an uncontested truth. Just because [Ward Cunningham](http://en.wikipedia.org/wiki/Ward_Cunningham) said it doesn't make it absolute truth. All of them, all of us, are human beings and, as such, we are very fallible. We fail, and we fail much more than we'd like.

In a world where people fail, what works best is collective knowledge, where one's possibility of error is compensated by the complementary intelligence of the other. That's why communities — only those that prioritize knowledge and evolution, of course — tend to be orders of magnitude less fallible than a single individual.

If one individual has knowledge "A," if another individual has knowledge "B," neither of them has "total" knowledge, but the set of the two, the "community," has both knowledges. Alone they know only part of the information. However the "entity" called "community" is as close as we'll get to [omniscience](http://rubyurl.akitaonrails.com/SiAN).

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/charles_darwin_l_original.jpg)

By the way, sharing knowledge with others brings us benefits, and that's why we do it, not because we're purely altruistic. Giving without having anything to receive doesn't make sense, many give simply because it brings them "peace of mind" or "personal satisfaction." Very well, that's a kind of return, also works. People like Kent Beck, Martin Fowler, Ken Schwaber, are not "giving" anything. They're sharing, by helping to foster agile values, they receive back, either in the form of more knowledge, more recognition, more opportunities, etc. This leads us to good old Darwinian evolution, the only thing that effectively works for continuous improvement.

The goal is not to "sell" Agile. When I evangelize the Agile philosophy, I have no intention of convincing anyone to use it. I don't get dividends if more people use it. Some even charge me: "_if I use Agile, can you guarantee I'll get better results?_" And I answer, "_of course not, I guarantee nothing._" I share what works for me, if it's going to work for others is really not my problem. What I do hope, yes, is that whoever is using and discovers new things, share it so I can improve more too. And, of course, if someone gives me bad code, full of duct tape, with no tests, and expects me to live with that in silence, they're completely mistaken, because that doesn't work for me and I'm not going to stay quiet. Agreeing with Bob Martin, [Mess is Not Technical Debt, It's Just Mess](http://blog.objectmentor.com/articles/2009/09/22/a-mess-is-not-a-technical-debt)

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/10commandments_original.jpg)

Some tips: anything that is "_written in stone_," that is, something that one day was the summary of collective knowledge of a group, but that was immortalized in the form of a dogma, is bad. Because this, without a doubt, was useful for the people at the time it was written, but probably doesn't apply anymore today. For example, if we still follow 50-year-old software development dogmas, we're probably leaving things undone in the way that today's technology and knowledge allow. On the other hand, a body of knowledge that allows itself to evolve, refine, throw away what no longer works, add what we learn anew, has a much better chance of being right. The Agile community works more or less like this. The Open Source community works more or less like this. Neither is perfect, but it's the pursuit of perfection that makes the path more interesting.

Be skeptical.
