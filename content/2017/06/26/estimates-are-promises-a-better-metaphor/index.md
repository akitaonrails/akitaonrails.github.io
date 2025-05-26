---
title: Estimates are Promises - A Better Metaphor
date: '2017-06-26T17:44:00-03:00'
slug: estimates-are-promises-a-better-metaphor
tags:
- off-topic
- principles
- management
- agile
- english
draft: false
---

If you didn't know, I am frequently answering questions over Quora. [Follow me there](https://www.quora.com/profile/Fabio-Akita), so far I wrote almost 600 answers, many of which resemble my longest blog posts here.

One of the most popular answer regards the subject of ["What is the hardest thing you do as a software engineer?"](https://www.quora.com/What-is-the-hardest-thing-you-do-as-a-software-engineer/answer/Fabio-Akita). I wrote a similar answer in Brazilian Portuguese in the post ["Estimativas são Promessas. Promessas devem ser cumpridas."](http://www.akitaonrails.com/2013/08/23/off-topic-estimativas-sao-promessas-promessas-devem-ser-cumpridas).

> In a nutshell, you can never give an estimate that is "correct". If you could, it would not be an "estimate", it would be a "prediction".

Let us assume that we have neither precognition powers nor magic crystal balls to tell us the future.

To estimate something is to "guess" the value of something. It's always a guess. It's the same thing as a valuation. And as any guess, it can never be deemed "correct". It's just a likely candidate among an infinite range of possible values.

> There is zero connection between a guess and the outcome. Understand this simple truth: saying something can happen does not MAKE it happen.

Estimating tomorrow's weather as rainy does not MAKE it rain. Estimating the results of the Super Ball does not MAKE it happen. Therefore, there is zero correlation between an estimate and the actual outcome.

I stated in the aforementioned articles that **"Estimates are Promises"**. The intention was to provoke a reaction as most people assume that estimates can never be promises exactly because of what was just explained.

What makes promises special is that once you promise something it is expected that you **ACT** upon realizing it.

![Skin in the Game](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/643/Skin-in-the-Game.png)

> No one that has no "skin in the game" should give estimates.

If you're not an active player in the game, you should not give any guesses. The same way no one makes promises for someone else. 

Can you actually make credible promises and meet them? Yes, you can, but first, you must understand a few more truths about reality.

You probably already saw many articles explaining many methodologies and project management techniques. I believe most of them succeed in explaining the Whats and the Hows, but as usual, they all fail in explaining the Whys.

Why do we need those methodologies? Why are they even needed? Why do they work? What are the hidden mechanisms that they put in motion?

What makes Agile techniques different from your usual Homeopathy or budget Self-Help cliché?

### It's always all about Paretto

There is no such thing as a **precise** project scope. There is a limit to add details after which you just get [**diminishing returns**](http://www.investopedia.com/terms/l/lawofdiminishingmarginalreturn.asp).

The most precise level of detail one feature scope can have is the actual coding of the feature. This is important: the lines of code from programming is **NOT** the outcome. The execution of that code in runtime is what end users will actually experience.

The programming itself is the **ACTUAL blueprint**. The diagrams, the use cases, the user stories or any other non-programming before that is just draft, a mere sketch.

A naive architect or designer might think that the detailed diagrams or use case documents, fancy powerpoint slides, have the same worth as an engineering blueprint. But they do not: they're the equivalent **sketch in a napkin**. Volatile, mostly worthless actually.

![Napkin Sketch](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/644/Screenshot_from_2017-06-26_16-19-14.png)

_"But isn't the programming the same as the construction phase itself, laying bricks on top of bricks?¨_ - **NO**, this is not what a programmer does. The brick work is the task of the so-called language interpreter or the compiler spitting out the binary that executes.

This is the metaphor that make non-programmers crazy: in engineering, the construction itself is the most expensive and time consuming parts. In programming, the blueprinting (the coding) is the expensive part, and the "construction" is actually trivial (just compiling the code, which is automatic).

The same way, a project scope is just a set of sketches. We should dump the notion that there will ever exist a **"complete"** scope of a project. There is no way to say "100% of the scope" or "closed scope", because a software project scope is, by definiton, always incomplete.

Moreover, I will argue that approximately 80% of this so called "scope" - what I prefer to call sketch - is mostly worthless to most of the end users activities (the admin section, institutional pages that no one reads, complicated signing up processes, etc).

This is why every feature list MUST be prioritized. You usually can get by with 20% of the features (this is roughly what people mean when they say "MVP
 or "most viable product"). **Release as early as you can,** get user feedback and refine the rest of the "sketch" you call backlog.

So, instead of aiming for an all-or-nothing proposition of having to find stupid ass complex equations to figure out a "precise" estimate for an incomplete sketch, assume you can actually deliver EARLY, the first 20% that actually matters and figure out the rest in iterations.

Oh yeah, this is what we call "Agile" by the way.

### Agile is about Risk Management

People assume Agility is about project management in terms of managing the "project management" instruments themselves: the backlog, the rituals, the metrics.

Having Agile-like instruments don't make you Agile.

Being Agile is keeping **Risk** under control.

Instead of thinking about projects as an all-or-nothing endeavor. You must start thinking about it as an investor would think about his **portfolio of stocks**. You don't expect the entire portfolio to yield profits, you actually assume that some stock will underperform. You just don't know which, so you dillute your risk.

![Portfolio stocks](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/645/635824249336942840-ThinkstockPhotos-152955327.jpg)

Trying to predict the stock market is an exercise in futility.

Trying to predict the precise implementation of a project - specially the long ones - is also an exercise in futility.

So you must deal with uncertainty the correct way: by becoming [**Antifragile**](https://www.amazon.com/Antifragile-Things-That-Disorder-Incerto/dp/0812979680).

> "Some things benefit from shocks; they thrive and grow when exposed to volatility, randomness, disorder, and stressors and love adventure, risk, and uncertainty. Yet, in spite of the ubiquity of the phenomenon, there is no word for the exact opposite of fragile. Let us call it antifragile. Antifragility is beyond resilience or robustness. The resilient resists shocks and stays the same; the antifragile gets better" - Nassim Taleb

Instead of the preposterous exercise in futility of trying to predict uncertainty and random events you do the reasonable thing: you assume Black Swans exist and you can't predict them. So you prepare for the uncertainty in the only reasonable way: by not trying to predict them.

Expose the small mistakes early, correct them often. Implementing everything in a black-box and do a Big Bang deployment is the easiest path to **failure**. Delivering often, exposing the bugs and fixing them constantly is accepting that mistakes will happen and gaining strength in the process as you go.

[![Antifragile](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/646/Antifragile-3.jpg)](https://www.amazon.com/Antifragile-Things-That-Disorder-Incerto/dp/0812979680)

### A Better Metaphor

![Iron Ore Furnace](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/642/steel_mill_blast_furnace_coking_coal_iron_ore_600.jpg)

Imagine that you - the non-programmer client or you, the programmer that has no clue how to explain the process to your non-programmer client - have an iron ore furnace to manage.

Thing about those furnaces is that if you heat it too much, they can explode in your face. If you cool it down too much, the ore will harden.

Your job is to add coal to the furnace. You decide in which rate. If you go too fast it gets exploding hot. If you go too slow you may extinguish the fire and lose your furnace.

Now, try to make an estimate of a constant intake of coal to keep your furnace in good shape.

You can't.

The easiest way out is to install a **thermometer** that keeps track of the current temperature of the furnace.

You're safe within a certain margin of temperatures and you speed up or slow down the coal intake by check the thermometer all the time.

ALL THE FREAKING TIME.

![Iron Furnace](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/647/iron-4.jpg)

This is what Agile-based "Velocity" (or any of the fancier Monte Carlo simulations) actually is: a thermometer.

If the Velocity is too high, your team is probably working either extra time or delivering lower quality code. This will backfire because either your team will burn out too fast or the code is accumulating [technical debt](http://www.akitaonrails.com/2017/06/22/the-economics-of-software-development) too fast and you won't be able to pay back. Velocity will drop to a halt if you keep this high (furnace explode).

If the Velocity is too low, your team is slacking off, your backlog is a useless piece of shit that no one can understand even after 10 hour meetings, or you already left the Velocity get too high and now you're paying back technical debt or your team is dead after burn out (fire extinguised).

You want to keep Velocity **steady**, constant. This is what being Agile is all about: keeping an eye on the thermometer and responding.

### The Triforce of Projects

![Iron Triangle](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/650/ironTriangle.jpg)

Welcome to the Iron Triagle of Project Management.

> Repeat after me: if I want to lock down the time, the cost, and the scope, **I am a moron**.

Repeat again.

You should lock down time and cost, and if you read this far, you know you can never lock down "scope", you can just make it fat (and not necessarily more valuable). This is why I always say that the very definition of a Product Manager or Product Owner is to be the bastion of ROI (Return on Investment).

Now, why?

Because the Iron Triangle has the following corollary:

![Project Triangle](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/651/320px-Project-triangle.svg.png)

* If you want it fast and good, it can't be cheap
* If you want it fast and cheap, it can't be good
* If you want it good and cheap, it can't be fast

This is a Law, you can't fiddle with it. Pick your choice.

![Make your choice](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/652/keep-calm-and-make-your-choice-9.png)

### How do I keep Promises then?

Now, with those 3 truths in hand:

* You can't have your lunch and eat it too (cheap, fast, and good)
* You're managing the temperature of the furnace
* You only need 20% of the "sketch" you call "scope"

Yes, any experienced developer can give you a "ballpark" estimate. A ballpark goes like this:

* 1 month (maybe 1 month and a half, but definitely less than 2)
* 3 months (it's more than 2 months, less than 6 months)
* 6 months (it's more than 4 months, less than 9 months)
* it's more than 6 months, probably less than 1 year

Don't even try to granulate more than that. It's useless.

**Lock the time.** And **lock the cost** (that being the amount of developers times the hourly rate times the total amount of estimated hours). That's it.

Now jot down what the client call "scope" as user stories in a backlog and have him prioritize it.

Start the iterations. After each iteration release to a staging environment. Non-programmers, beware: ALWAYS make sure whoever programmer you hire to ALWAYS deliver testable versions of the delivered stories to a publicly available URL that you can actually visit and test.

If your programmer refuses to do that or give excuses: **FIRE HIM**.

If your programmer or company or whatever promises you a certain "closed scope" price, promises to do everything and you believe them, you're too gullible.

Do you think it's funny to play this stupid game of _"I'll pretend to tell you that I know the truth and you will pretend that you believe what I tell you."_

![Actions and Words](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/648/e433998315b73da036e65884b67eba43.jpg)

No serious professional has time to play stupid games and the only honest thing anyone can say about any software project is: _"given my experience I believe the ballpark for this kind of project is within X months, given the Y and Z assumptions"._

Now, you don't have to believe him. You just need to start checking the thermometer. Any non-programmer will be able to assess the quality of the delivery based on the frequent deliveries of the prioritized features.

_"But what if after 2 weeks I don't like the results?"_ Easy: **FIRE HIM**.

And sometimes "firing" is not even the correct word. Sometimes the relationship is difficult and the best thing to do is to go separate ways.

You need to accept losing 2 weeks - or any short period of time - as part of the Risk Management. It's better to accept losing 2 weeks worth of your project budget than having to blindly believe someone for 6 months and having to lose the entire project budget and some more.

Paretto again: Agility is about Risk Management. You accept that losing 20% of your budget is ok. And you play with that. But that's also okay, because you only actually need a bit more than 20% of the sketchy scope you have.

See what I just did with the Math here?

We stop playing around the pretend game and actually manage the risks of the project. You collaborate on the equivalent thermometer which is a combination of the prioritized backlog (the scale), the velocity (the temperature), and you keep an eye on the partial deliveries on the staging environment.

### Conclusion

So yes, Estimates should be taken as seriously as Promises. You can give reasonable Estimates granted that you can manage the Risks and the Client accepts the rules of the game (there is no "closed, complete, scope", and "priorities first", and "testing and accepting delivered features every week").

The idea behind Promises is that you have to **MANAGE** in order to meet them. The best way to do that is to frequently stop, re-assess and then keep going. It feels like you're wasting time, but you're actually saving yourself from wasting time.

If you don't have a skin in the game, back off.

Velocity is meant to be kept steady. Not always increasing. Not always volatile and unpredictable. Keep velocity in a predictable rate and use the variance as indication of being too fast or too slow, adjust the other variable, measure again and go. Just like a furnace thermometer.

There are several versions of "thermometers" from Joel Spolsky's [Evidence Based Scheduling](https://www.joelonsoftware.com/2007/10/26/evidence-based-scheduling/) all the way to fancy Monte Carlo simulations and other stochastic processes (they are all thermometers and NOT estimation tools).

What stops you from doing that is using the wrong metaphors and the wrong references.

Instead of trying to find equivalent metaphors in the construction business, factories and other "hard"-ware assemblies, you should look elsewhere, where you will find other "soft"-ware processes.

Musicians have deadlines. Painters have deadlines. Choreographers have deadlines. Sports have deadlines. Research laboratories have deadlines. How do they meet them? By constantly checking the current state and comparing to the goals, assessing if what they are doing is actually working and changing what doesn't work.

![Conducting Star Wars](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/649/conducting_starwars.jpg)

Hollywood has deadlines. They have far worse variables to control than any software project you might ever encounter, and they manage to deliver. And profit.

And accept that you can't control all variables, so stop trying. Think of it as the financial markets. One day you have [Ethereum skyrocketting 4,000%](https://motherboard.vice.com/en_us/article/zme78x/why-the-value-of-ethereum-has-skyrocketed-4000-percent) and the very next day you have it [falling down to ashes in a flash-crash](http://www.cnbc.com/2017/06/22/buyers-beware-lessons-from-the-ethereum-flash-crash.html).

Don't aim to become resistent or resilient. Prepare to become Antifragile.
