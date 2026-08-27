---
title: "[Off-Topic] Thinking Makes You Better"
date: '2009-09-26T16:17:00-03:00'
slug: off-topic-procurar-raciocionar-faz-bem
translationKey: off-topic-procurar-raciocionar-faz-bem
description: "Pair programming needs an active pilot and co-pilot, Agility is accountability, and the Spolsky versus Bob Martin spat becomes a case for testing Agile practices, grasping their reasons, and refusing dogma."
tags:
- software-engineering
- agile
- off-topic
draft: false
---

[![Rails Summit 2009](http://railssummit.com.br/imgs/43/original/728x90.gif)](http://www.railssummit.com.br?utm_campaign=Railssummit&utm_source=banner_parceiros&utm_medium=banner&utm_content=por_728x90)

A few interesting articles showed up this week, all tied in some way to "Agile" software development thinking.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/Screen_shot_2009-09-26_at_6.51.42_PM_original.png)

The first, which I really liked, was [10 Reasons Pair Programming Is Not For the Masses](http://web.archive.org/web/20090927081120/http://blog.obiefernandez.com/content/2009/09/10-reasons-pair-programming-is-not-for-the-masses.html), where Obie Fernandez writes about his own experience with pairing and why it is hard to pull off in most shops.

The points boil down to physical limits (cubicles are so twentieth century...) and corporate conventions still in fashion, like HR interviews built around résumés and certifications. For me, the two most important are #2 and #6. Like any concept, read the wrong way, it gives you the wrong results.

The first thing a programmer has to understand about pairing is that there is always a pilot and a co-pilot. The common picture has the pilot doing the work while the co-pilot just watches along, passive and silent. That is the wrong way to pair, and it is exactly the picture that lets a manager think he is paying for two people and getting the work of one.

In pair programming, both are in it the whole time. The co-pilot watches for the pilot's mistakes, thinks ahead, and is already imagining better options. On top of that, the keyboard and mouse should keep changing hands. There is no such thing as pairing where the co-pilot spends the day just looking on. If he goes passive and quiet, the pilot is flying solo, period.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/ying_eric_pair_programming_original.jpg)


There are at least two kinds of pair: one where both have roughly the same skills, and one where a person is less experienced or simply brings something different. In the first case the dynamic is more obvious, ideas bounce around more, decisions come faster.

In the second case, one of them is there to learn fast, and the one who knows less has an obligation to take more risks, always under the more experienced one's watch. He can never be passive: he has to go find knowledge on his own, away from the pairing sessions, and never expect the pilot to teach him everything. The one who knows less is the one who chases it down, or else admits it won't work and gives up the seat.

Worth remembering that the core value of Agility is called _"accountability."_ It doesn't translate cleanly into Portuguese, but it is something beyond "responsible." An Agile team is consciously accountable for what it does.

When it settles the Sprint Backlog together with the client and the product owner, it isn't taking orders like _"this sprint gets these 10 user stories because the boss said so."_ A team that commits to 10 stories is genuinely committing: it knows its own velocity, its strengths and its weaknesses, and decides based on that.

A team that later says _"we couldn't deliver because they asked for too much"_ is dodging its responsibility. It should have said, up front, _"no, we can only do 8 of these stories, 10 is too many."_ A deal set in advance is cheap. It is all about setting expectations, negotiating, and working together toward the best solution, not just any solution.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/pair_programming_original.jpg)

The same holds in the smaller world of two programmers pairing. Both have to be committed to what they are producing and to each other. If one is less experienced, he can't be dead weight; and if the more experienced one sees the other is trying, he should help.

There is a line between helping and carrying someone on your back. This is where honesty comes in, and that is what the Retrospective at the end of the Sprint is for: the moment to put everything out in the open. _"I don't like producing on my own while my partner isn't helping."_

Pair programming, on its own, is just a technique. Before it come the values of the [Agile Manifesto](http://agilemanifesto.org/), and everyone forgets the first one: _"Individuals and Interactions over Processes and Tools."_

If you are still asking yourself "which Agile techniques should I pick," you still don't get it. First things first: are you committed to your project? Is your team committed to the project and to each other? What problems are you trying to solve?

Agility is not a magic recipe. It has a purpose. If you aren't aiming at that purpose and just grab two or three practices at random, that doesn't make you Agile, only random.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/493px-Joel_spolsky_on_20_sept_2007_original.jpg)

Then comes Joel Spolsky's piece, [The Duct Tape Programmer](http://www.joelonsoftware.com/items/2009/09/23.html). In it, Spolsky celebrates Jamie Zawinski, a great programmer who worked at Netscape shipping software that helped change the world, literally.

Zawinski, per Spolsky, is the _"let's ship as fast as possible, no matter how"_ type, and the _"unit tests are nice, but when the deadline bites what matters is shipping, and tests get in the way"_ type. Read the wrong way, that becomes a permission slip for the bad programmer to say: _"Yes! Joel Spolsky confirmed that being a cowboy is beautiful!"_ Or worse: _"Spolsky said I don't need to worry about tests."_

Before you jump to some rushed conclusion, and damn this fast-food generation, read the response written by good old [Uncle Bob Martin](http://blog.objectmentor.com/articles/2009/09/24/the-duct-tape-programmer), where he takes those arguments apart. Spolsky and Bob have gone at it before: on a podcast, [Spolsky belittled TDD and the SOLID principles](http://www.infoq.com/news/2009/02/spolsky-vs-uncle-bob).

In case you don't know him, Robert Martin is the one who called the meeting, about eight years ago, that gave rise to the Agile Manifesto, alongside the field's biggest names, people like Kent Beck, Martin Fowler, Dave Thomas, and Jeff Sutherland. He has been programming since before a lot of us here were even born, and he is still at it today.

And I don't mean some senior who only touches Cobol. He has been through the major platforms, understands object orientation like few others, programs in Java, and champions [Clean Code](http://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882). If you use GitHub, you'll find some of [Bob's projects](http://github.com/unclebob) there too.

Some time ago I probably would have been [cursing and damning](http://web.archive.org/web/20091002042618/http://www.akitaonrails.com:80/2006/9/27/flame-war-joel-spolsky-vs-rails) Spolsky, but I think I get where he stands. Spolsky is a serious businessman, with a company and successful niche products, practically an earlier-generation 37signals.

Ex-Microsoft, he was one of the people behind the existence of Visual Basic for Applications, which to this day is the heart of Excel and the apple of every accountant's and analyst's eye who can't live without those macros. With Jeff Atwood, he runs [StackOverflow](http://stackoverflow.com/). And he wrote the excellent [Joel on Software](http://www.amazon.com/Joel-Software-Occasionally-Developers-Designers/dp/1590593898).

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/photo_martin_r_original.jpg)

At this point I'll assume I don't have to explain what [Agility](http://en.wikipedia.org/wiki/Agile_software_development) is, nor the good practices of [Extreme Programming](http://www.extremeprogramming.org/), nor Bob Martin's [SOLID principles](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod). I'll also assume you've read at least a few of Spolsky's [articles](http://www.joelonsoftware.com/) to get a sense of what he tends to say.

An agilist usually looks like he's trying to "convince" everyone that being agile is better. And that agility and speed are two different things: speed is a side effect of agility. The reading is subtle.

What I do curse is the fast-food generation, used to thinking everything is simple and shallow. That buying a "lose weight in 7 days" book is enough to actually lose the weight. If that kind of thing worked, there would be no obese people in the world. Duh.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/BurningTheWitch_original.jpg)

That same generation reads Spolsky and, on the surface, lands on the conclusion I mentioned: _"Spolsky agrees I should be a cowboy."_ And we agilists fall for it too. In our rush to answer the shallowness, we sometimes go too far. Bob Martin, for instance, could have ignored the post instead of responding.

Passive, conformist people wait to be validated. They don't understand why they do what they do, they just do it. They pick whatever seems simplest, easiest, safest, and not what stands a chance of being better or new.

They want to be liked. It doesn't matter whether they're doing the right thing, or whether there's a better way. Hence the craving for validation. That is what I covered in the article [The Cult of Gray Morality](/en/2009/09/08/off-topic-o-culto-da-moral-cinzenta).

When someone of Spolsky's perceived "caliber" posts something like this, thousands of plainly bad programmers around the world feel validated, justified. It's a sad picture.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/BRILLIANT_original.jpg)

And Spolsky isn't wrong. Each of his articles carries a piece of his own experience. On its own, each piece means almost nothing, and shouldn't be taken literally. Neither should what Bob Martin writes. Neither should what I write.

The sum of the parts is orders of magnitude bigger than the sum of each one's individual value. That's how chaos works.

Spolsky and Bob aren't opposites. What one says doesn't invalidate the other, and that's the trick. Both are pragmatic, at least by William James's definition of pragmatism: something is true for a person if it is useful to her, whether or not it stays true for someone else. (There is still Peirce and Dewey's pragmatism, but that's another story.)

Both are trying to explain what works for them. Within a context, understanding the premises and the values, it might work for you too.

What Spolsky says makes sense to him. What Bob Martin says makes sense to him. If it makes sense to me, or to you, that's **not** their problem, not their fault, and shouldn't even be their concern. And don't use their names to justify what you do without understanding why. _"I do TDD because Kent Beck said it's good"_ is as bad as _"I write glue-code because Zawinski said it's better."_

The right way to put it is: _"I do TDD because I **know** what it does for me."_ Or, _"I write glue-code now and then because I'm **aware** of the consequences and accept the price."_ Or, _"I don't pair all the time because I've **thought it through** and, in my case, it doesn't work well."_

By the way, everything I write here on the blog is musing, personal reflection that happens to find its way into words. Some people think I "act like I own the truth." That's their problem, not mine.

Truth be told: just like Bob says in his article, I don't test all the time either, much less test-first the way TDD dictates. I only learned Extreme Programming's practices many years after I started programming, and I was an extremely cowboy programmer for most of my career.

Even knowing why the agile practices are good and why I should use them, I still reason about where and when to apply each one. I understand the principles, the premises, and the expected results. Otherwise it would turn into [dogmatization](http://en.wikipedia.org/wiki/Dogma), and every dogma is bad by definition. **Dogmas are the source of all evil.**

Everything has to be questioned, tried, measured, and analyzed, and only then can a conclusion emerge, one that new evidence can still overturn. The opposite of dogma, or of cargo cult, is the [Scientific Method](/en/2008/12/16/off-topic-m-todo-cient-fico-vs-cargo-cult), as I explained before.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/world-trade-center_original.jpg)

Just because Martin Fowler said it doesn't make it an uncontested truth. Just because [Ward Cunningham](http://en.wikipedia.org/wiki/Ward_Cunningham) said it doesn't make it absolute truth. All of them, all of us, are human, and humans fail. We fail far more than we'd like.

In a world where people fail, what works best is collective knowledge, where one person's error is offset by another's complementary intelligence. That's why communities, at least the ones that prize knowledge and evolution, tend to be orders of magnitude less fallible than any single individual.

If one person holds knowledge "A" and another holds "B," neither has the whole, but the two together, the community, have both. Alone, each one knows only a slice. The entity we call a community is the closest we get to omniscience.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/charles_darwin_l_original.jpg)

Sharing knowledge brings us benefits, and that's why we do it, not out of pure altruism. Giving with nothing coming back doesn't hold up; plenty of people give because it brings them peace of mind or personal satisfaction, and that's already a kind of return.

Kent Beck, Martin Fowler, and Ken Schwaber aren't "giving" anything. They're sharing: by fostering agile values, they get it back as knowledge, recognition, and opportunities. That's good old Darwinian evolution, the only thing that actually drives continuous improvement.

The goal isn't to "sell" Agile. When I evangelize the agile philosophy, I have no intention of talking anyone into it, and I gain nothing if more people adopt it. People sometimes press me: _"if I use Agile, can you guarantee better results?"_ And I answer: _"of course not, I guarantee nothing."_

I share what works for me; whether it works for others is really not my problem. What I do hope is that whoever uses it and discovers something new will share it back, so I can improve too.

And of course, if someone hands me sloppy code, all duct tape and not a single test, and expects me to live with it in silence, they're dead wrong, because that doesn't work for me. Agreeing with Bob Martin: [A Mess Is Not Technical Debt, It's Just a Mess](http://blog.objectmentor.com/articles/2009/09/22/a-mess-is-not-a-technical-debt).

![](http://s3.amazonaws.com/akitaonrails/assets/2009/9/26/10commandments_original.jpg)

One tip: anything "written in stone," something that was once a group's collective knowledge but got frozen into a dogma, is bad. It was useful for the people of its time, but it probably doesn't hold up today. If we still followed the software development dogmas of 50 years ago, we'd be leaving on the table what today's technology and knowledge allow.

A body of knowledge that lets itself evolve, refine, throw out what no longer works, and fold in what it learns has a far better shot at being right. The agile community works more or less like this. The open source community does too. Neither is perfect, but it's the pursuit of perfection that makes the road interesting.

Be skeptical.
