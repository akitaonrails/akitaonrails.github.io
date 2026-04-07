---
title: '[Off-Topic] The Myth of the "Legacy"'
date: '2012-08-15T12:28:00-03:00'
slug: off-topic-o-mito-do-legado
tags:
- off-topic
- principles
- career
- management
draft: false
---

If there's a recurring story in any software development, it's what I call the "Myth of the Legacy." If you're a programmer, you've been through this: you inherited code done by another person or another team, you see that it's all very badly done, and your recommendation is to throw it all out and start over. You're sure this is the only healthy alternative, and not doing it would be a huge mistake.

This behavior is what I also call "Amateur Hysteria." And I say this with total peace of mind because I myself have had moments like this.

First of all, let's define what is commonly called "Legacy": basically any code done up until yesterday, especially if you weren't the one who made it, is considered "Legacy."

But what most programmers fail to understand is very simple: with that definition, any code will always automatically become "legacy" the minute after it's finished: including your own.

The neighbor's garden always looks greener? For programmers, the neighbor's code always looks worse. How many times have we heard?

- _"How could it take all this time to make this code? I would have done it in less time."_
- _"How could the code have been made this ugly way? I would have done it better."_

![Building the Legacy System of Tomorrow](http://s3.amazonaws.com/akitaonrails/assets/image_asset/image/19/BuildingLegacy.png)

### Context, context, context

Why did a certain project take _"more time than I think it should have?"_ Dozens of reasons: departments that didn't collaborate, poorly defined business rules that changed several times, and so on.

Why isn't the code as _"elegant"_ or _"well done"_ as _"I would do it?"_ Because it was developed with a goal in mind, the goal changed — as it always changes — the code accumulated, deadlines tightened, refactorings didn't happen as they should, technical debt accumulated — despite the warning of the programmers involved — and the current code ended up much worse than it should be.

Another thing that should be obvious: every programmer will always find something they don't like in any code, whether it's effectively bad and poorly made or even well-made and well-structured. Software is so complex you can find a flaw in anything. It's like pointing out flaws in a human being: everyone is imperfect. The fallacy of whoever is listening is to understand that just because someone pointed out a few flaws, it automatically means _everything_ is bad. That's a common fallacy: _"my new programmer said they found this flaw and this other poorly done thing, so the system is bad."_ Except you didn't point out the qualities and didn't analyze whether the flaws actually are greater in volume, criticality, and severity than the qualities. More than that: any new code will also have points another programmer won't like, and this cycle is infinite.

Now the truth: the programmer who arrived later and questioned all these points, had they been at the exact same moment when everything started, would have delivered the same bad code as the final result, or even worse.

### Fear

Now the challenge is to understand the following: in most cases, "Legacy" code, that is, code that is in production, currently in use, is generating results: something your "new and elegant" code isn't. Another type of story that many programmers prefer to ignore is precisely the case of the _"Big Rewrite"_ that was never concluded and never went live, especially if you were the one who did it.

The worst type of software is that which doesn't generate value. And a factor that differentiates a professional programmer from an amateur is exactly how they deal with others' code. Talking yesterday with [Rodrigo Yoshima](http://blog.aspercom.com.br), he dropped a pearl: dealing with legacy is for adults — any child can do "greenfield" (project done from scratch).

It takes much more technique, much more skill, much more capability, to take a legacy and make it better, even if in some cases it is actually necessary to redo some parts — but that shouldn't be the first automatic alternative without justification. _"Because I would do it better"_ isn't justification.

![Dilbert](http://s3.amazonaws.com/akitaonrails/assets/image_asset/image/18/2006-12-08.gif)

### The Environment

The process that facilitates teams generating bad code is always one of the hardest problems to solve. Bosses, clients who ask for _"urgent last-minute changes"_ is one of the symptoms. Departments with different priorities. In environments like this, any new software will quickly be made worse to the point where it seems necessary to redo everything again.

I won't repeat everything the Agile communities have already said to this day, but the "fix" most of the time doesn't just involve programming techniques, but rather programmers who can see beyond the code and understand how to help fix the environment around them. This includes the programmer colleagues around, the bosses above, the demands coming from surrounding departments, and all the feedback coming from the market in the outside world.

In the real world, software is made by people for people. Understanding that people aren't difficult means the challenge for a professional is much greater than following good practices or being specialized in this or that technique. A good professional knows that just complaining and sulking doesn't lead anywhere.

### Opportunities

As always, stories aren't rules, but they serve to illustrate a point. Years ago I was allocated alone to a big client who had a small "legacy" system that was extremely poorly made. A one-off allocation. And I can say "poorly made" because it effectively didn't execute as it should — that is, it was technically flawed and returned many errors. It was exactly the kind of code that would make any programmer say, immediately, _"throw it out and do it again!"_

I had 2 weeks to do something. Others had already tried, the client was already convinced to make a new one. No one would think it bad if I said nothing could be done besides starting from scratch. It was an attempt. And I hate saying I can't solve a problem.

They needed the current one to work minimally. I was a Java programmer at the time — the system was one of the worst ASPs I had ever seen up to that point, mixed with several DCOM components that miraculously executed somehow.

In 2 weeks I understood what the business rule they wanted was. I understood why the code didn't work according to these rules. I understood where the data feeding it came from, how it was handled and stored, what results were expected, and how I should intervene to implement that processing.

I used exactly the same code, did a minimal sanity cleanup, removed what was unnecessary, and inserted the minimum necessary to reach the goals expected by the client within the deadline that was stipulated for me.

During those 2 weeks I understood more about the process, understood more about the client, understood more about the environment. Besides fixing the software I managed to build a good relationship. This good relationship, in a few months, led me to return to work for this client but this time on a 1-and-a-half-year project with a team of almost 10 people, where I could coordinate the development my way.

![Save our Code](http://s3.amazonaws.com/akitaonrails/assets/image_asset/image/20/big_url.jpeg)

In this case, it was clear that the code was done in bad faith by a programmer who didn't really know what they were doing. Many pieces of software are really done by simply bad programmers. But I understand that many cases are also good programmers who had to solve a problem within a series of restrictions they had to deal with.

To me, "legacy" is software done precisely by those who call others' software "legacy." For me, "legacy" can often be an opportunity — precisely because few can handle it. And for me, people who judge others' code without knowledge of the whole context are just another amateur wanting to show off.

Of course, this isn't a defense that all legacy software is justified and good. Not at all — my point in this article is focused on the automatic behavior of programmers who use this as an excuse.
