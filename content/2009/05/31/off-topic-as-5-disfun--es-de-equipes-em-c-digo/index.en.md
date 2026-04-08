---
title: "[Off-Topic] The 5 Team Dysfunctions in Code"
date: '2009-05-31T16:10:00-03:00'
slug: off-topic-as-5-disfun--es-de-equipes-em-c-digo
tags:
- off-topic
- management
draft: false
---

I tend to repeat to every team I manage that 99% of problems in any project are especially due to "communication." Stresses that last days and could be resolved in a 30-second hallway conversation. I use "communication" but it's a bit more than that — it's a lack of respect, a lack of trust, a lack of [empathy](http://en.wikipedia.org/wiki/Empathy) (not "sympathy" — "Empathy"). Here's a **translation** of [Mark Needham's](http://www.markhneedham.com/blog/2009/05/28/the-5-dysfunctions-of-teams-in-code/) article.

I recently came across an [interesting post by my colleague Pat Kua](http://www.thekua.com/atwork/2009/05/evidence-in-favour-of-conways-law/) where he talks about some patterns he noticed in code that could be linked to [Conway's Law](http://en.wikipedia.org/wiki/Conway%27s_Law), which suggests that the structure of systems developed by organizations will mirror the communication structure of that organization. (AkitaOnRails: also read [The Mythical Man-Month](http://en.wikipedia.org/wiki/The_Mythical_Man-Month), where Conway's topic is also explored, and understand [Cross Functional Teams](http://www.infoq.com/articles/scaling-lean-agile-feature-teams) to understand one of the solutions.)

I also recently read a book called [The Five Dysfunctions of a Team](http://www.markhneedham.com/blog/2009/04/22/the-five-dysfunctions-of-a-team-book-review/) which describes some behaviors in teams that don't function effectively.

Playing devil's advocate, I was intrigued as to whether there was some kind of link between these dysfunctions and whether they manifest in our code as anti-patterns.

The 5 dysfunctions are:

1. Absence of Trust – team members are unwilling to be vulnerable within the group
2. Fear of Conflict – the team is unable to engage in honest debate of ideas
3. Lack of Commitment – team members rarely commit to decisions
4. Avoidance of Accountability – team members don't call their peers' attention to actions/behaviors that hurt the team
5. Inattention to Results – team members who put their individual needs before those of the team


## Absence of Trust

I think having **null checks all over the code** is the most obvious indicator that people don't trust the code they're working with.

If the person writing the code had faith in their colleagues who wrote the code they need now, I think it would be more likely that they would trust that the code will do the right thing and not feel the need to [be so defensive](http://www.thekua.com/atwork/2008/08/defensive-programming-depends-on-context/).

## Fear of Conflict

Fear of conflict in a team seems to manifest most obviously in code when we have **a lot of duplication happening** (the "copy & paste" syndrome) — there are various reasons for duplication but I think one of them is when people aren't engaging in discussion when they disagree with something a colleague wrote and so end up writing their own versions of something that's already been done.

This probably manifests even more obviously when you end up with multiple different frameworks in the same codebase all doing the same things just because people didn't want to engage in conversations to decide which one the whole team would use.

## Lack of Commitment

This one seems to crossover a lot with the previous two, although a specific way this manifests in code is when we see **basic mistakes or lack of care demonstrated in code** (the "sloppy job" syndrome) — an example of this could be renaming a class and then not ensuring that all the places where the old name was used have been updated.

This leaves the code in a half-baked state and makes it really difficult for other people to work with and they need to spend time cleaning things up before they can actually get any work done.

## Avoidance of Accountability

The code anti-pattern that stands out most to me is **when we allow people to write code without tests** and check it into the code repository.

In my experience so far this has never worked out well and I think it shows a lack of respect for the rest of the team since we don't have a simple way to verify whether the code actually works and other people can't use it elsewhere with any degree of confidence.

## Inattention to Results

Team members putting their individual needs before the team manifests in code when we end up with **code that has been written in such a way that only the person who wrote the code is able to understand it.**

I think this manifests in "clever code" which is fine if the project belongs to you alone, but in the context of a team is very detrimental as you become the bottleneck when other people want to make changes in that area of the code and can't because they don't understand what's going on.

Another thing that falls into this same situation is **when there are conventions to be followed but we decide to go off on our own and do it our own way**. It's fine sometimes if we're working to genuinely improve the code and the rest of the team knows and agrees. Otherwise it's not a smart thing to do.

## Summary

I find it intriguing that in my mind, at least, some of the problems we see in code seem to have some correlation with the problems we see in teams.

One thing I remember from reading [The Secrets of Consulting](http://www.amazon.com/Secrets-Consulting-Giving-Getting-Successfully/dp/0932633013/ref=sr_1_1?ie=UTF8&s=books&qid=1243452602&sr=1-1) by Gerald Weinberg is his assertion that [no matter what the problem is, it's always a people problem](http://www.codinghorror.com/blog/archives/001033.html) — if that's true then in theory the problems we see in code should be indicative of problems with people, which I think to a certain extent really is true.

I certainly don't think that every code problem is linked to team dysfunctions — certainly some anti-patterns enter your code due to inexperience of team members, but even then this would demonstrate a lack of senior engineers on the team working more closely with their colleagues!

Perhaps we can identify ways to improve our teams by starting with a look at your code.

## Rant

**by AkitaOnRails:** Indeed, I'm very convinced that problems that happen in code are merely symptoms of structural problems in teams and organizations.

It starts with a lack of respect: when team members see their boss (don't use "leader" to refer to hierarchical bosses — they're never real "leaders") pulling rank to get things done with other teams, among developers it also becomes an arm-wrestling match: _"I did my part, if the other team complains I'll have my boss talk to theirs and that's it."_ In my experience, almost all the problems in inefficient and dysfunctional teams come back to the manager.

Managers who exercise _"command-and-control"_ are exactly the types who should be expelled from an organization. Managers who don't trust the team, who shout, who use the power of their position, who insist on being the communication bottleneck, who insist that everything must go through them, who lack real knowledge — which is evident in their inability to argue effectively. Managers who don't know how to give honest, daily feedback — for better or worse — and save it all up to dump on people months later. To me, that's the greatest demonstration of **cowardice** from someone who is supposed to be a _"leader."_

The manager who likes to _"micro-manage"_ whenever it suits them, but doesn't explain their expectations, and whose feedback is positive or negative not based on the work done but on their mood that day — which makes things very convenient for them, obviously. The managers who, to appear less bad, spend their time trying to make other teams look bad: the infamous nitpickers, those who go looking for trivial reasons like time of arrival, dress code, small conversations — using those as excuses to badmouth, rather than focusing on real results like profit and cost.

If you're genuinely concerned about why your teams aren't performing as they should, look at the management layer. Especially — or primarily — those who have been **in the same organization for many years**. Junkies who already know all the organizational "tricks." They're dangerous: they smile at everyone, seem confident, seem efficient, and most of their subordinates praise them (because they're under coercion, obviously).

The team reflects the system and structure imposed upon them. Strip them of autonomy, treat them like children, leave them confused and afraid, and that's exactly the result you'll get: sloppy work, poor quality, constant defects, high cost. Some think this is an exaggeration — especially senior management that's distant and barely participative (anything less than every day isn't participation) to what happens on the shop floor. They're surprised to see that their employees have become not just stagnant, incompetent, and obsolete, but also distant and unconcerned about the organization's future. The only thing they care about at that point is their jobs.

Meanwhile, those "managers" remain in comfortable positions: when things go well — by luck, and only luck — they take the credit. When things go wrong, the blame falls on team members they were going to deal with anyway, or the blame is on other teams, or the organization as a whole that didn't support them, or historical decisions that can no longer be undone. But the blame is never on them. Remember: years of tenure cannot mean immunity. Years of tenure should be irrelevant if the organization's intent is to be efficient. And don't worry about firing a manager like that out of fear that _"only he knows how things work"_; things won't fall apart — trust the teams, give them back their autonomy, they'll know what to do.

So yes, the vast majority of team dysfunctions are a direct result of organizational dysfunctions. There's no point trying to apply localized techniques like preaching pair programming, test-driven development, refactoring, etc. if the organization remains the same. Want to change? Change everything. Or don't bother.
