---
title: "[Off-Topic] The 5 Team Dysfunctions in Code"
date: '2009-05-31T16:10:00-03:00'
slug: off-topic-as-5-disfun--es-de-equipes-em-c-digo
translationKey: off-topic-as-5-disfun--es-de-equipes-em-c-digo
description: "Five team dysfunctions appear in anti-patterns such as null checks, duplication, untested code, and hard-to-understand solutions. Isolated techniques cannot fix a command-and-control organization."
tags:
- software-engineering
- testing
- management
- off-topic
draft: false
---

I keep repeating to every team I manage that 99% of the problems on any project come down to "communication." Stresses that drag on for days and could have been settled in a 30-second hallway chat. I say "communication," but it's a little more than that: a lack of respect, a lack of trust, a lack of [empathy](http://en.wikipedia.org/wiki/Empathy) (empathy, mind you, not "sympathy"). Here's a **translation** of [Mark Needham's](http://www.markhneedham.com/blog/2009/05/28/the-5-dysfunctions-of-teams-in-code/) article.

I recently came across an [interesting post by my colleague Pat Kua](http://www.thekua.com/atwork/2009/05/evidence-in-favour-of-conways-law/) where he talks about how some patterns he's noticed in code can be linked to [Conway's Law](http://en.wikipedia.org/wiki/Conway%27s_Law), which suggests that the structure of systems designed in organisations will mirror the communication structure of that organisation. (AkitaOnRails: also read [The Mythical Man-Month](http://en.wikipedia.org/wiki/The_Mythical_Man-Month), where Conway's topic is also explored, and understand [Cross Functional Teams](http://www.infoq.com/articles/scaling-lean-agile-feature-teams) to understand one of the solutions.)

I recently read a book called [The Five Dysfunctions of Teams](http://www.markhneedham.com/blog/2009/04/22/the-five-dysfunctions-of-a-team-book-review/) which describe some behaviours in teams which aren't working in an effective way.

Playing the devil's advocate I became intrigued as to if there is some sort of link between these dysfunctions and whether they manifest themselves in our code as anti patterns.

The five dysfunctions are:

1. Absence of Trust – team members are unwilling to be vulnerable within the group
2. Fear of Conflict – team cannot engage in unfiltered and passionate debate of ideas
3. Lack of Commitment – team members rarely have buy in or commit to decisions
4. Avoidance of Accountability – team members don't call their peers on actions/behaviours which hurt the team
5. Inattention to Results – team members put their individual needs before those of the team


## Absence of Trust

I think having **null checks all over the code** is the most obvious indicator that people don't trust the code that they are working with.

If the person writing the code had faith in their colleagues who had written the code they now need to interact with then I think it would be more likely that they would trust the code to do the right thing and they wouldn't feel driven to such a [defensive approach](http://www.thekua.com/atwork/2008/08/defensive-programming-depends-on-context/).

## Fear of Conflict

Fear of conflict in a team seems to manifest itself most obviously in code when we have **a lot of duplication happening** (the "copy & paste" syndrome) - there are several reasons why duplication can happen but I think one of them is when people aren't engaging in discussions when they disagree with something that a colleague has written and therefore end up writing their own version of something that's already been done.

This probably manifests itself even more obviously when you end up with multiple different frameworks all in the same code base and all doing the same thing just because people don't want to engage in a conversation to choose which one the team is going to use.

## Lack of Commitment

This is one which seems to overlap a lot with the previous two although perhaps one specific way that this would manifest itself in the code might be if we see **sloppy mistakes or lack of care being shown with the code** (the "sloppy job" syndrome) - an example of this could be changing the name of a class but then not ensuring that all the places where the old name was used in variables have been changed accordingly.

This leaves the code in a half baked state which becomes quite difficult for other people to work with and they have to do some clean up work before being able to effectively make changes to the code.

## Avoidance of Accountability

The coding anti pattern that stands out for me here is **when we allow people to write code without tests** and then check those into source control.

From my experience so far this never seems to work out well and I think it shows a lack of respect for the rest of the team since we don't have an easy way of verifying whether this code actually works and other people can't make use of it elsewhere in the code base with any degree of confidence.

## Inattention to Results

Team members putting their individual needs before the team manifests itself in code when we end up with **code that has been written in such a way that only the person who wrote it is really able to understand it**.

I think this manifests itself in "clever code" which is fine in your own projects but in a team context is very detrimental as you become a bit of a bottleneck when people want to make changes in this area of the code and can't do it because they can't understand what's going on.

Something else that falls under this dysfunctions is **when there is a convention for how to do certain things in the code but we decide to go off and do it our own way**. Now granted sometimes it's fine to do this if you're working the code towards a better state and the rest of the team are aware you're trying to work towards this goal but otherwise it's not a very effective approach.

## In Summary

I found it quite intriguing that in my mind at least some of the problems we see in code do seem to have some correlation to the problems that we see in teams.

One thing I remember from reading Gerald Weinberg's [The Secrets of Consulting](http://www.amazon.com/Secrets-Consulting-Giving-Getting-Successfully/dp/0932633013/ref=sr_1_1?ie=UTF8&s=books&qid=1243452602&sr=1-1) is his claim that [no matter what the problem is it's always a people problem](https://web.archive.org/web/20090606022501/http://www.codinghorror.com/blog/archives/001033.html) - if indeed this is true then in theory problems that we see in code should be indicative of a people problem which I think probably to an extent is true.

I think certainly not all problems in code are linked to the dysfunctions of teams - certainly some anti patterns creep into our code due to a lack of experience of team members of how to do things better but then again maybe that's indicative of the team not having senior members working closely enough with their colleagues!

Maybe we can therefore work out how we can identify ways to improve our team by starting with a look at the code.

## Rant

**by AkitaOnRails:** Honestly, I'm thoroughly convinced that the problems that show up in code are just symptoms of structural problems in teams and organizations.

It starts with a lack of respect. When the team watches the boss (don't call a hierarchical boss a "leader"; they're almost never real leaders) pull rank to get what he wants out of other teams, the developers themselves turn it into an arm-wrestling match: _"I did my part, and if the other guy complains I'll have my boss talk to his and that's that."_ In my experience, almost every problem in an inefficient, dysfunctional team traces back to the manager.

Managers who run on _"command-and-control"_ are exactly the types who should be run out of an organization. They're the ones who don't trust the team, who yell, who lean on the power of the title, who insist on being the communication bottleneck and demand that everything pass through them. They have no real knowledge, and it shows the moment they have to actually argue a point.

Then there's the manager who never gives honest, daily feedback, good or bad, and instead saves it all up to throw in your face months later. To me, that's the loudest display of **cowardice** from someone who is supposed to be a _"leader."_

There's the manager who loves to _"micro-manage"_ whenever it suits him but never spells out what he expects. His feedback tracks his mood that day instead of the work you delivered, which keeps things nice and comfortable on his end. And there's the manager who, to look a little less bad, spends his time trying to make the other teams look worse. These are the nitpickers, the ones who dig up trivial stuff (what time you showed up, what you wore, some hallway chat) as an excuse to badmouth people, instead of looking at real results like profit and cost.

If you're genuinely worried about why your teams aren't performing the way they should, look at the management layer. Especially the ones who've spent **many years** in the same organization, hooked on it, who already know every _"workaround"_ in the place. They're dangerous: they smile at everyone, they seem confident, they seem efficient, and most of their reports praise them (under coercion, obviously).

The team reflects the system and the structure dropped on top of it. Strip away their autonomy, treat them like children, leave them confused and afraid, and this is exactly what you get: sloppy work, poor quality, defects all the time, high cost.

Some people call that an exaggeration, especially a distant, barely present upper management (anything short of every day isn't presence) when it comes to what happens on the shop floor. Then they're shocked to find their employees have gone stagnant, incompetent, and obsolete, and grown distant and indifferent to the future of the organization. At that point the only thing they care about is their own job.

Meanwhile those "managers" stay comfortable. When things go well (by luck, and only luck), they take the credit. When things go wrong, the blame lands on the team members he was going to get rid of anyway, or on the other teams, or on the whole organization that didn't back him up, or on historical decisions that can't be undone now. The blame is never his.

Remember this: years of tenure can't buy immunity. Years of tenure should be irrelevant when an organization wants to be efficient. And don't be afraid to let a manager like that go out of some fear that _"only he knows how things work."_ Things won't fall apart. Trust the teams, give the autonomy back, they know what to do.

So yes: the vast majority of a team's dysfunctions are a direct result of the organization's dysfunctions. There's no point applying localized techniques, preaching pair programming, test-driven development, refactoring and the like, if the organization stays the same. Want to change? Change everything. Or don't even bother.
