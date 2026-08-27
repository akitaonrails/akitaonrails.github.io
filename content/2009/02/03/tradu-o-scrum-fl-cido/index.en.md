---
title: 'Translation: Flaccid Scrum'
date: '2009-02-03T03:32:00-02:00'
slug: tradu-o-scrum-fl-cido
translationKey: tradu-o-scrum-fl-cido
description: "A translation of Martin Fowler's 'Flaccid Scrum': adopting Scrum without technical practices sinks the team into a messy codebase. Notes on testing, refactoring, frequent integration, and collective ownership."
tags:
- agile
- software-engineering
- testing
- off-topic
draft: false
---

5 days ago, Martin Fowler [published an article](http://martinfowler.com/bliki/FlaccidScrum.html) that may sound controversial to Scrummers. His target, though, is the people who apply Scrum the wrong way and the ones who don't bother to make that problem apparent. Below is the full translation of his article; my own comments come at the end.

[![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/Picture_1.png)](http://martinfowler.com/bliki/FlaccidScrum.html)

There's a mess I've heard about with quite a few projects recently. It works out like this:

- They want to use an agile process, and pick Scrum
- They adopt the Scrum practices, and maybe even the principles
- After a while progress is slow because the code base is a mess

What's happened is that they haven't paid enough attention to the internal quality of their software. If you make that mistake you'll soon find your productivity dragged down because it's much harder to add new features than you'd like. You've taken on a crippling [Technical Debt](http://martinfowler.com/bliki/TechnicalDebt.html) and your scrum has gone weak at the knees. (And if you've been in a real scrum, you'll know that's a Bad Thing.)

I've mentioned Scrum because when we see this problem, Scrum seems to be particularly common as the nominative process the team is following. For many people, this situation is exacerbated by Scrum because Scrum is process that's centered on project management techniques and deliberately omits any technical practices, in contrast to (for example) Extreme Programming.

In defense of Scrum, it's important to point out that just because it doesn't include technical activities within its scope should not lead anyone to conclude that it doesn't think they are important. Whenever I've listened to prominent Scrummers they've always emphasized that you must have good technical practices to succeed with a Scrum project. They don't mandate what those technical practices should be, but you do need them. After all projects get into trouble for poor internal quality all the time, the fact that a lot crop up under Scrum's flag may be more due to the fact that Scrum is so popular at the moment then anything particular to Scrum. Popularity and [Semantic Diffusion](http://martinfowler.com/bliki/SemanticDiffusion.html) tend to go together.

So what to do about it?

The scrum community needs to redouble its efforts to ensure that people understand the importance of strong technical practices. Certainly any kind of project review should include examining what kinds of technical practices are present. If you're involved or connected to such a project, make a fuss if the technical side is being neglected.

If you're looking to introduce scrum, make sure you pay good attention to technical practices. We tend to apply many of those from Extreme Programming and they fit just fine. XPers often joke, with some justification, that Scrum is just XP without the technical practices that make it work. Sniping aside, the XP practices make a good starting point - and are certainly going to be much better than doing nothing at all.

I always like to point out that it isn't methodologies that succeed or fail, it's teams that succeed or fail. Taking on a process can help a team raise its game, but in the end it's the team that matters and carries the responsibility to do what works for them. I'm sure that the many Flaccid Scrum projects being run will harm Scrum's reputation, and probably the broader agile reputation as well. But since I see [Semantic Diffusion](http://martinfowler.com/bliki/SemanticDiffusion.html) as an inevitability I'm not unduly alarmed. Teams that fail will probably fail whatever methodology they mis-apply, teams that succeed will build their practices on good ideas and the scrum community's role is to spread these good ideas around widely.

Many people are looking to Lean as the _Next Big Agile Thing_. But the more popular lean becomes the more it will run into the same kind of issues as Scrum is facing now. That doesn't make Lean (or Scrum) worthless, it just reminds us Individuals and Interactions are more valuable than Processes and Tools.

### Akita's Notes

In practice, what I've noticed is that the planning and management parts meet the least resistance: [User Stories](http://www.extremeprogramming.org/rules/userstories.html), [Release Planning](http://www.extremeprogramming.org/rules/planninggame.html), [Small Releases](http://www.extremeprogramming.org/rules/releaseoften.html), [Project Velocity](http://www.extremeprogramming.org/rules/velocity.html), [Iterations](http://www.extremeprogramming.org/rules/iterative.html), [Iteration Planning](http://www.extremeprogramming.org/rules/iterationplanning.html), [Stand Up Meetings](http://www.extremeprogramming.org/rules/standupmeeting.html). The reason is simple. When a company decides to adopt Scrum, the decision came from some level above; without that, it never gets off the ground. And managers and bosses tend to understand and swallow these concepts well enough, especially if they've already been through traditional project management methodologies without success.

And this is where most people **go wrong**: if the team isn't yet mature enough to be self-managing, that is, to produce quality code on its own, it's up to upper management to lead in that direction. That's hard because many managers aren't technical, which leaves them blind to the problem of missing good technical practices.

The mess Martin Fowler refers to lives in design, coding, and testing. The ones who struggle most with these practices are developers who came from the old ways of building software, the "suicidal cowboy" style, or who have little experience and little study of software development in general.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/22124.jpg)

Most developers don't understand [Simplicity](http://www.extremeprogramming.org/rules/simple.html), the famous "do the simplest thing that works," or [YAGNI](http://en.wikipedia.org/wiki/You_Ain%27t_Gonna_Need_It) (You Ain't Gonna Need It). In the younger ones, the "cowboy" spirit is hard to tame: they always want to build things in more complex ways than necessary. This leads precisely to the problem of [adding things too early](http://www.extremeprogramming.org/rules/early.html), complexity for the pleasure of complexity. The team needs to police itself against this. Fortunately [Spike Solutions](http://www.extremeprogramming.org/rules/spike.html) help: the team stops for a moment, understands the problem, and studies solution alternatives.

Another mix-up I've seen a lot is confusing [Refactoring](http://www.extremeprogramming.org/rules/refactor.html) with rewriting. A rewrite in itself isn't a problem, but it becomes one when applied with the notion that "just because it's new, it's better." First and foremost, Refactoring is a set of techniques aimed at rejuvenating code, making it more manageable, without modifying its behavior.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/cowboy.jpg)

This leads to the Achilles' heel of most amateur developers: the aversion to testing. _"I'm too good to make mistakes, I don't need tests."_ That's the developer who will effectively lead his own work to certain failure. [Testing first](http://www.extremeprogramming.org/rules/testfirst.html) is an effective way to refine design, and it also leads to simplicity, doing only what is truly needed.

Without good tests, effective refactoring is impossible: how do you guarantee that a change didn't alter the code's behavior? The corollary is that these developers also **don't** practice Refactoring, which leads to the mass of messy code. The irony is that even rewrites, where it was assumed the new version would be better, end up becoming "legacy" very quickly.

Worse yet, when a [bug is found](http://www.extremeprogramming.org/rules/bugs.html), tests to prevent a regression to the same bug are rarely created. And everyone must have seen bugs that were supposedly already fixed coming back shortly after. Another problem is that many teams never settled on a good definition of "story done" and therefore also struggle to maintain [acceptance tests](http://www.extremeprogramming.org/rules/functionaltests.html) for those stories. One of the reasons: instead of writing User Stories ("as X, I want Y because of Z," defining what to implement, for whom, and what value it brings), they write tasks ("do X"), skipping the for-whom and the why.

Still in the "cowboy" spirit, inexperienced programmers don't understand the concept of [collective code ownership](http://www.extremeprogramming.org/rules/collective.html). What happens is that each developer tries to limit himself to the code he thinks he's responsible for and doesn't worry about the whole. It should work the other way around: every developer must feel responsible for all the code. This also explains one more reason for the importance of unit tests: without them it's impossible to help with code you didn't write, and impossible to know if your own code doesn't break something someone else made. In summary: this leads to an immeasurable accumulation of "Technical Debt" that only becomes visible when it's already too late, turning your "new system" prematurely into an unmanageable "legacy."

In that same spirit, "cowboy" developers don't [integrate frequently](http://www.extremeprogramming.org/rules/integrateoften.html) as they should. It's not uncommon to see developers spend the whole week with new code only on their own machine and, at the end of the week, commit to the repository and consider it done. No tests created, no full test suite run. One more developer deliberately creating Technical Debt.

To make matters worse, it's not hard to find teams that don't even understand the value of a repository: for them, it's enough to change things directly on the production server or edit files right there. That's the prehistory of development. A code versioning repository is mandatory, and treating it as a sanctuary is the greatest responsibility of a team. That means all code in the repository must always be code with no deliberately introduced problems, from not writing tests, not integrating frequently, not refactoring where needed. Bugs will always exist and must be fixed, but deliberate errors make the developer irresponsible and a problem for the entire team.

Finally, it's common to see developers who think they're very clever [optimizing](http://www.extremeprogramming.org/rules/optimize.html) very early in the project, based on nothing but guesswork, without measurements. By the way, most programmers I've met have as much aversion to measurement as they do to testing. And optimizing without being based on metrics is the purest waste of time. You can make a certain piece of code 100 times faster, but if in overall time that doesn't represent even a 0.5% gain, it was a waste of time. Again, inexperience.

Still regarding "suicidal cowboys," they're normally attached to their limited tools, the ones they're already used to. They're too lazy to learn new things, whether from inability or lack of will, and they always try to take the apparently easiest route, like using automatic code generators, which generally produce code that's hard to maintain and outside the most modern standards accepted as good practices.

In the end, the result is the same: inexperienced developers who think they know everything, or long-tenured developers addicted to anti-practices and too stubborn to learn the good ones. Building an efficient and truly agile development team is very hard. And the reality is that simply not everyone is cut out for the job. An agile developer is someone proactive, self-taught, sociable, and communicative. And all of that matters more than their supposed technical competence.

PS: some people might take this personally. But in reality, this is more common than you'd imagine; I've seen it at many clients and will keep seeing it. To be fair, I myself have done many projects (more than I'd like) that immediately became "legacy," code poorly tested and hard to maintain. Complaining is easy; doing something to improve is the hard part. And yesterday's cowboy developer has everything it takes to become a good programmer tomorrow; they just need to want it.
