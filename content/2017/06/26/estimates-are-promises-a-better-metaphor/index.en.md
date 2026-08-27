---
title: Estimates are Promises - A Better Metaphor
date: '2017-06-26T17:44:00-03:00'
slug: estimates-are-promises-a-better-metaphor
translationKey: estimates-are-promises
description: "Estimates can become promises when risk is managed: lock in time and cost, prioritize the first 20% of the scope, and use staging deliveries and velocity as gauges for adjusting course."
tags:
- agile
- management
- software-engineering
- off-topic
draft: false
---

If you didn't know, I frequently answer questions over on Quora. [Follow me there](https://www.quora.com/profile/Fabio-Akita); I've written almost 600 answers so far, many of them close to my longest posts here on the blog.

One of the most popular ones answers the question ["What is the hardest thing you do as a software engineer?"](https://www.quora.com/What-is-the-hardest-thing-you-do-as-a-software-engineer/answer/Fabio-Akita). I wrote something similar in Brazilian Portuguese in the post ["Estimativas são Promessas. Promessas devem ser cumpridas."](http://www.akitaonrails.com/en/2013/08/23/off-topic-estimativas-sao-promessas-promessas-devem-ser-cumpridas).

> In a nutshell, you can never give an estimate that is "correct". If you could, it would not be an "estimate", it would be a "prediction".

Let us assume we have neither precognition powers nor magic crystal balls to tell us the future.

To estimate something is to "guess" the value of something. It's always a guess, the same thing as a valuation. And like any guess, it can never be deemed "correct": it's just a likely candidate among an infinite range of possible values.

> There is zero connection between a guess and the outcome. Understand this simple truth: saying something can happen does not MAKE it happen.

Estimating tomorrow's weather as rainy does not MAKE it rain. Estimating the result of the Super Bowl does not MAKE it happen. There is zero correlation between an estimate and the actual outcome.

I stated in those articles that **"Estimates are Promises"**. The intention was to provoke a reaction, since most people assume that estimates can never be promises, exactly because of what I just explained.

What makes a promise special is that once you promise something, you're expected to **ACT** on delivering it.

![Skin in the Game](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/643/Skin-in-the-Game.png)

> No one that has no "skin in the game" should give estimates.

If you're not an active player in the game, you shouldn't be handing out guesses. The same way no one makes promises on someone else's behalf.

Can you actually make credible promises and keep them? You can, but first you have to understand a few more truths about reality.

You've probably already seen plenty of articles explaining project management methodologies and techniques. Most of them manage to explain the Whats and the Hows, but as usual, they fail on the Whys.

Why do we need those methodologies? Why are they necessary? Why do they work? What hidden mechanisms do they set in motion?

What makes Agile techniques any different from your usual homeopathy or a budget self-help cliché?

### It's always all about Pareto

There is no such thing as a **precise** project scope. There is a limit to adding detail, and past it you just get [**diminishing returns**](http://www.investopedia.com/terms/l/lawofdiminishingmarginalreturn.asp).

The most precise level of detail a feature scope can have is the actual code of the feature. And this matters: the lines of code are **NOT** the outcome. What end users actually experience is the execution of that code at runtime.

The programming itself is the **actual blueprint**. The diagrams, the use cases, the user stories, and anything else that comes before the programming are just a draft, a mere sketch.

A naive architect or designer might think that detailed diagrams, use case documents, and fancy PowerPoint slides are worth as much as an engineering blueprint. They're worth less: they're the equivalent of a **sketch on a napkin**. Volatile and, in practice, mostly worthless.

![Napkin Sketch](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/644/Screenshot_from_2017-06-26_16-19-14.png)

_"But isn't the programming the same as the construction phase itself, laying bricks on top of bricks?"_ **NO**, that's not what a programmer does. The bricklaying is the job of the language interpreter or the compiler that spits out the executable binary.

This is the metaphor that drives non-programmers crazy. In engineering, the construction itself is the most expensive and time-consuming part. In programming, the expensive part is the blueprint (writing the code), and the "construction" is trivial: just compiling, which is automatic.

In the same way, a project scope is just a set of sketches. We have to drop the notion that a **"complete"** scope will ever exist. There's no way to say "100% of the scope" or "closed scope", because a software project scope is, by definition, always incomplete.

On top of that, I'll argue that roughly 80% of this so-called "scope", what I prefer to call a sketch, is mostly worthless to most end-user activities: the admin section, the institutional pages nobody reads, convoluted sign-up flows, and so on.

This is why every feature list **MUST** be prioritized. You can usually get by with 20% of the features, which is roughly what people mean when they say "MVP" or "minimum viable product". **Release as early as you can**, get user feedback, and refine the rest of the "sketch" you call a backlog.

So instead of aiming for an all-or-nothing proposition, hunting for stupidly complex equations to figure out a "precise" estimate of an incomplete sketch, assume you can actually deliver EARLY the first 20% that really matters and figure out the rest in iterations.

Oh yeah, this is what we call "Agile", by the way.

### Agile is about Risk Management

People assume Agility is about managing the project management instruments themselves: the backlog, the rituals, the metrics.

Having Agile-like instruments doesn't make you Agile.

Being Agile is keeping **Risk** under control.

Instead of treating projects as an all-or-nothing endeavor, start thinking about them the way an investor thinks about a **portfolio of stocks**. You don't expect the whole portfolio to turn a profit; you assume some stocks will underperform. You just don't know which ones, so you dilute your risk.

![Portfolio stocks](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/645/635824249336942840-ThinkstockPhotos-152955327.jpg)

Trying to predict the stock market is an exercise in futility.

Trying to predict the precise implementation of a project, especially the long ones, is also an exercise in futility.

So you have to deal with uncertainty the right way: by becoming [**Antifragile**](https://www.amazon.com/Antifragile-Things-That-Disorder-Incerto/dp/0812979680).

> "Some things benefit from shocks; they thrive and grow when exposed to volatility, randomness, disorder, and stressors and love adventure, risk, and uncertainty. Yet, in spite of the ubiquity of the phenomenon, there is no word for the exact opposite of fragile. Let us call it antifragile. Antifragility is beyond resilience or robustness. The resilient resists shocks and stays the same; the antifragile gets better" - Nassim Taleb

Instead of the preposterous exercise in futility of trying to predict uncertainty and random events, you do the reasonable thing: you assume Black Swans exist and you can't predict them. So you prepare for uncertainty the only reasonable way there is, by not trying to predict them.

Expose the small mistakes early and correct them often. Implementing everything in a black box and doing a Big Bang deployment is the easiest path to **failure**. Delivering often, exposing the bugs, and fixing them constantly is accepting that mistakes will happen and gaining strength along the way.

[![Antifragile](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/646/Antifragile-3.jpg)](https://www.amazon.com/Antifragile-Things-That-Disorder-Incerto/dp/0812979680)

### A Better Metaphor

![Iron Ore Furnace](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/642/steel_mill_blast_furnace_coking_coal_iron_ore_600.jpg)

Imagine that you, whether the non-programmer client or the programmer who has no clue how to explain the process to that client, have an iron ore furnace to manage.

The thing about those furnaces is that if you heat them too much, they can explode in your face. If you cool them down too much, the ore hardens.

Your job is to add coal to the furnace, and you decide the rate. Too fast and it gets exploding hot. Too slow and you might put out the fire and lose your furnace.

Now try to estimate a constant intake of coal to keep the furnace in good shape.

You can't.

The easiest way out is to install a **thermometer** that tracks the furnace's current temperature.

You stay safe within a certain margin of temperatures, speeding up or slowing down the coal intake by checking the thermometer all the time.

ALL THE FREAKING TIME.

![Iron Furnace](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/647/iron-4.jpg)

This is what Agile-based "Velocity" (or any of the fancier Monte Carlo simulations) actually is: a thermometer.

If the Velocity is too high, your team is probably working extra hours or delivering lower-quality code. This will backfire: either your team burns out too fast, or the code piles up [technical debt](http://www.akitaonrails.com/en/2017/06/22/the-economics-of-software-development) too fast and you won't be able to pay it back. Keep that pace and Velocity drops to a halt (the furnace explodes).

If the Velocity is too low, your team is slacking off, your backlog is a useless piece of shit no one can understand even after 10-hour meetings, or you already let Velocity run too high and now you're paying back technical debt, or your team is dead from burnout (fire extinguished).

You want to keep Velocity **steady**, constant. This is what being Agile is all about: keeping an eye on the thermometer and responding.

### The Triforce of Projects

![Iron Triangle](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/650/ironTriangle.jpg)

Welcome to the Iron Triangle of Project Management.

> Repeat after me: if I want to lock down the time, the cost, and the scope, **I am a moron**.

Repeat again.

You should lock down time and cost. If you've read this far, you know you can never lock down "scope"; you can only make it fat, and not necessarily more valuable. This is why I always say the very definition of a Product Manager or Product Owner is to be the bastion of ROI (Return on Investment).

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

**Lock the time.** And **lock the cost** (that being the number of developers times the hourly rate times the total amount of estimated hours). That's it.

Now jot down what the client calls "scope" as user stories in a backlog and have him prioritize it.

Start the iterations. After each one, release to a staging environment. Non-programmers, beware: ALWAYS make sure whichever programmer you hire delivers testable versions of the finished stories to a publicly available URL you can actually visit and test.

If your programmer refuses to do that or gives excuses: **FIRE HIM**.

If your programmer or company or whatever promises you a "closed scope" price, promises to do everything, and you believe them, you're too gullible.

Do you think it's funny to play this stupid game of _"I'll pretend to tell you that I know the truth and you will pretend that you believe what I tell you."_

![Actions and Words](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/648/e433998315b73da036e65884b67eba43.jpg)

No serious professional has time for stupid games, and the only honest thing anyone can say about any software project is: _"given my experience I believe the ballpark for this kind of project is within X months, given the Y and Z assumptions"._

You don't have to believe him. You just need to start checking the thermometer. Any non-programmer can assess the quality of the delivery based on the frequent deliveries of the prioritized features.

_"But what if after 2 weeks I don't like the results?"_ Easy: **FIRE HIM**.

And sometimes "firing" isn't even the right word. Sometimes the relationship is difficult and the best thing to do is to part ways.

You have to accept losing 2 weeks, or any short period of time, as part of Risk Management. It's better to accept losing 2 weeks of your project budget than to blindly trust someone for 6 months and lose the entire project budget and then some.

Pareto again: Agility is about Risk Management. You accept that losing 20% of your budget is okay, and you play with that. And that's fine, because you only really need a bit more than 20% of the sketchy scope you have.

See what I just did with the Math here?

We stop playing the pretend game and actually manage the project's risks. You collaborate on the equivalent thermometer, which combines the prioritized backlog (the scale) and the velocity (the temperature), and you keep an eye on the partial deliveries in the staging environment.

### Conclusion

So yes, Estimates should be taken as seriously as Promises. You can give reasonable Estimates as long as you can manage the Risks and the Client accepts the rules of the game: there is no "closed, complete scope", priorities first, and testing and accepting delivered features every week.

The idea behind Promises is that you have to **MANAGE** in order to meet them. The best way to do that is to frequently stop, re-assess, and keep going. It feels like you're wasting time, but you're actually saving yourself from wasting it.

If you don't have skin in the game, back off.

Velocity is meant to be kept steady, at a predictable rate. Use the variance as a sign of being too fast or too slow, adjust the other variable, measure again, and go. Just like a furnace thermometer.

There are several versions of "thermometers", from Joel Spolsky's [Evidence Based Scheduling](https://www.joelonsoftware.com/2007/10/26/evidence-based-scheduling/) all the way to fancy Monte Carlo simulations and other stochastic processes (they are all thermometers, and NOT estimation tools).

What stops you from doing that is using the wrong metaphors and the wrong references.

Instead of hunting for equivalent metaphors in construction, factories, and other "hard"-ware assemblies, look elsewhere, where you'll find other "soft"-ware processes.

Musicians have deadlines. Painters have deadlines. Choreographers have deadlines. Sports have deadlines. Research laboratories have deadlines. How do they meet them? By constantly checking the current state, comparing it to the goals, assessing whether what they're doing is actually working, and changing what doesn't.

![Conducting Star Wars](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/649/conducting_starwars.jpg)

Hollywood has deadlines. They have far worse variables to control than any software project you'll ever run into, and they still manage to deliver. And profit.

And accept that you can't control every variable, so stop trying. Think of it as the financial markets. One day you have [Ethereum skyrocketing 4,000%](https://web.archive.org/web/20170705022520/https://motherboard.vice.com/en_us/article/zme78x/why-the-value-of-ethereum-has-skyrocketed-4000-percent) and the very next day you have it [falling down to ashes in a flash-crash](http://www.cnbc.com/2017/06/22/buyers-beware-lessons-from-the-ethereum-flash-crash.html).

Don't aim to become resistant or resilient. Prepare to become Antifragile.
