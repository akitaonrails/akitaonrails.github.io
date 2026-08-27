---
title: "[Off-Topic] Restaurants and Technology"
date: '2009-11-18T16:51:00-02:00'
slug: off-topic-restaurantes-e-tecnologia
translationKey: off-topic-restaurantes-e-tecnologia
description: "The restaurant analogy separates companies whose core business is technology from those that merely use it for support. In the former, programmers should experiment and create tools, as at GitHub."
tags:
- management
- software-engineering
- business
- off-topic
draft: false
---

There are developers and there are developers. There are companies and there are companies. Just to illustrate, I'll split companies into two types. In the first, technology is the _core business_, and money spent on it actually counts as "investment."

In the second, technology is an accessory, treated as "operational cost." It's there only to support the business, much of what we call "back office." For lack of better terms, I'll call the first kind **"tech companies"** and the rest **"enterpriseys."**

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/A_Busy_Restaurant_Kitchen.JPG_original.jpeg)

Why am I bringing this up? Because plenty of decisions get made out of context. Choices that fit an _enterprisey_ end up applied at a tech company, and vice versa. That's the source of a lot of pointless arguments.

I get why a bank would hesitate to swap some of its DB2 for a CouchDB today, say. I also get why a medical company would balk at trading its embedded C programs for something like the .NET micro framework. A few of them do try. It just isn't the norm, and that doesn't mean the technologies wouldn't work.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/cheftony_original.jpg)

The same can't be said of "tech companies." In that context, reaching for the newest and most advanced should be normal. Better yet: rolling your own technologies should be normal.

The obvious worry is that this turns into something random, disordered, chaotic. It doesn't. That's exactly why companies like Google, Microsoft, Novell, RedHat, and plenty of smaller ones keep something resembling a Research & Development department, or at least the habit of researching and experimenting. It's why they work hard to hire the people on the cutting edge of new tech, which makes no sense at a bank, an insurer, or a trucking company.

This reasoning seems obvious, and it is, yet for some reason I keep seeing people deciding and arguing things out of context. That one really gets on my nerves. Recent open-source technologies make all the sense in the world at a tech company. And having employees contribute to open source projects makes even more sense.

To make the analogy easier, I said that at a "tech company" the _core business_ is technology (duh). Now picture a restaurant, a company whose _core business_ is cooking good food. If I decide out of context, as if the food were just an accessory, I could say: _"why don't we outsource the kitchen and start buying hamburgers from McDonald's? It cuts operational cost and guarantees delivery in the quantities we need. And the whole market already knows and likes them."_

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/chaplin-charlie-modern-times_01_original.jpg)

Worse still would be cooks with this mindset: _"nah, I don't want to test that new ingredient because it's more work. I'd rather grab the ready-made seasoning at the supermarket."_ That's what I call "scrambled-eggs cooks," because anybody can make scrambled eggs.

At an enterprisey, most of the work is usually, literally, "form and report development." That's what justifies Software Factories and the hiring of "coders," the classic restaurant worker who just microwaves somebody else's frozen food.

And I always separate a "coder" from a "developer." A developer needs the head of a "chef," a real cook, trying new things, taking chances on new ingredients and new dishes. That's what sets an award-winning chef apart from the guy who just heats up a grill.

I'm not trying to run down the profession, only to illustrate the concept. The problem shows up when the microwave guy thinks he's a cook and that what he does is gastronomy. It isn't.

One caveat: I'm not saying there are no "cooks" in consultancies or enterpriseys. What I'm pointing at is how the company views this kind of service or expense. As an ex-consultant, I know full well there are great minds out there trying to shift the mindset of entire industries. Thoughtworks is a clear example.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/kitchen_original.jpg)

So, first of all, look at the context you're in. If you're in a real restaurant, you're expected to be a cook. Don't assume that acting like a microwave guy is fine, unless you're trying to run the restaurant into the ground.

Another example from our world: I figure everyone who reads my blog knows [Github](https://github.com), one of the most innovative open source repositories around. Wrap your head around this: it was the work of literally 4 programmers, some of them fresh out of college. They could have stuck to whatever the "market" calls "acceptable."

Read this post of theirs: [How we made Github fast](https://github.blog/news-insights/the-library/how-we-made-github-fast/). If you aspire to be a "chef," none of the technologies they list should be new to you: ldirectord, nginx, unicorn, rails, drbd, proxymachine, haproxy, redis, ernie, memcached. Want more? Around the same time, they shipped two technologies of their own, [Resque](https://github.blog/news-insights/the-library/introducing-resque/) and [BERT-RPC](https://github.blog/news-insights/the-library/introducing-bert-and-bert-rpc/). I'll say it again: not much more than 4 people.

Want more? Remember [Phusion Passenger](https://www.phusionpassenger.com/) and [Ruby Enterprise Edition](http://www.rubyenterpriseedition.com/)? Those are two boys who hadn't even left university. They're "chefs."

At a tech company, that's the goal. At an enterprisey, it isn't. Where are you?
