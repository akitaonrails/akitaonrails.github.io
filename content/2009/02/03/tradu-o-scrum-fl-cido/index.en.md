---
title: 'Translation: Flaccid Scrum'
date: '2009-02-03T03:32:00-02:00'
slug: tradu-o-scrum-fl-cido
tags:
- off-topic
- agile
- management
translationKey: flaccid-scrum
draft: false
---

5 days ago, Martin Fowler [wrote an article](http://martinfowler.com/bliki/FlaccidScrum.html) that might be a bit controversial for Scrummers, but don't see it as a criticism of Scrum itself — see it as a criticism of those who apply Scrum the wrong way and of those who don't bother making that apparent. Below I've translated his article in full, and at the end I added some comments of my own.


[![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/Picture_1.png)](http://martinfowler.com/bliki/FlaccidScrum.html)

There's a mess I hear about in many projects recently. It works like this:

- They want to use an agile process, and choose Scrum
- They adopt the Scrum practices, and maybe even the principles
- After a while progress is slow because the **codebase is a mess**

What happens is that they paid no attention to the **internal quality** of their software. If you make this mistake you'll quickly find that your progress has slowed because it's very hard to add new features that you want. You've fallen into the trap of [Technical Debt](http://martinfowler.com/bliki/TechnicalDebt.html) and your scrum has gone to its knees. (And if you've been in a real scrum, you'll know that's a Bad Thing.)

I mention Scrum because when we see this problem, Scrum seems to be particularly common as the named process the team is following. For many people, the situation is exacerbated by Scrum because Scrum is a process centered on project management techniques and deliberately omits any technical practices, in contrast (for example) to Extreme Programming.

In defense of Scrum, it's important to point out that just because it doesn't include any technical activities within its scope this shouldn't lead anyone to conclude that it doesn't think they're important. Whenever I've heard prominent Scrummers they've always emphasized that you need to have **good technical practices** to succeed with a Scrum project. They don't say what those technical practices should be, but you need them. After all, projects run into trouble due to poor internal quality all the time, and the fact that many do so under the Scrum banner seems to be more a reflection of Scrum's popularity at the moment than anything particular to Scrum. Popularity and [Semantic Diffusion](http://martinfowler.com/bliki/SemanticDiffusion.html) tend to go together.

So what to do about it?

The Scrum community needs to redouble its efforts in ensuring people understand the importance of strong technical practices. Certainly any kind of project review should include examination of what technical practices are present. If you're involved or connected with this kind of project, make a noise if the technical side is being neglected.

If you're presenting Scrum, make sure you're paying attention to technical practices. We tend to apply many from Extreme Programming and they fit in very nicely. The XPers like to joke, with some justification, that Scrum is just XP without the technical practices that make it work. Anyway, XP's practices are a good starting point — and will certainly be much better than nothing.

I always like to point out that it's not methodologies that lead to success or failure. Using a process can help a team up their game, but in the end it's the team that matters and that carries the responsibility of doing what works for them. I'm sure that many of the Flaccid Scrum projects will hurt the reputation of Scrum, and probably the wider reputation of Agile. But since I see [Semantic Diffusion](http://martinfowler.com/bliki/SemanticDiffusion.html) as inevitable I'm not disproportionally alarmed. Teams that fail will probably fail whatever methodologies they — erroneously — apply, teams that succeed will build their practices on good ideas and the role of the scrum community is to spread those good ideas.

Many people are looking to Lean as the _Next Big Agile Thing_. But the more popular lean becomes the more it will run into the same problems that Scrum is running into right now. This doesn't make Lean (or Scrum) without value, it just reminds us that Individuals and Interactions are more valuable than Processes and Tools.

### Akita's Notes

In practical terms, for my part, I've already noticed that planning and management things like [User Stories](http://www.extremeprogramming.org/rules/userstories.html), [Release Planning](http://www.extremeprogramming.org/rules/planninggame.html), [Small Releases](http://www.extremeprogramming.org/rules/releaseoften.html), [Project Velocity](http://www.extremeprogramming.org/rules/velocity.html), [Iterations](http://www.extremeprogramming.org/rules/iterative.html), [Iteration Planning](http://www.extremeprogramming.org/rules/iterationplanning.html), [Stand Up Meetings](http://www.extremeprogramming.org/rules/standupmeeting.html) are the parts that seem to meet the least resistance when implementing. The reason is that when a company decides to adopt Scrum, it's already something that came from some level above — otherwise it wouldn't be implemented. And managers and bosses tend to understand and swallow these concepts more or less well, especially if they've already gone through traditional project management methodologies without success. And this is where most people **go wrong**: if teams don't yet have the maturity to be self-managing (that is, to independently produce quality code), it's the responsibility of upper management to lead in that direction. This is hard because many managers aren't technical, which makes them oblivious to the problem of not using good technical practices.

The mess Martin Fowler is referring to lies in Design, Coding, and Testing. Most developers who: 1) came from old ways of development (e.g., the "suicidal cowboy" style); 2) have little general experience and study in software development; have difficulty understanding these practices.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/22124.jpg)

Most developers don't understand [Simplicity](http://www.extremeprogramming.org/rules/simple.html), the famous "do the simplest thing that works" or [YAGNI](http://en.wikipedia.org/wiki/You_Ain%27t_Gonna_Need_It) (You Ain't Gonna Need It). Especially if they're young, the "cowboy" spirit is hard to tame and they always want to do things in more complex ways than necessary. This leads precisely to the problem of [adding things too early](http://www.extremeprogramming.org/rules/early.html), or complexity for the pleasure of complexity. The team needs to self-police against this. Fortunately [Spike Solutions](http://www.extremeprogramming.org/rules/spike.html) don't seem so bad today, where the team stops for a moment, understands the problem, and studies solution alternatives. Another problem: I've seen people confuse [Refactoring](http://www.extremeprogramming.org/rules/refactor.html) with [Rewriting](http://www.neilgunton.com/doc/rewrites_harmful). Rewriting in itself isn't a problem, but it becomes one when applied with the notion that "just because it's new, it's better." First and foremost, Refactoring is a set of techniques aimed at rejuvenating code, making it more manageable, without modifying its behavior.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/cowboy.jpg)

This leads to the Achilles' heel of most amateur developers: the aversion to testing. _"I'm too good to make mistakes, I don't need tests."_ That's the developer who will effectively lead their work to certain failure. [Testing first](http://www.extremeprogramming.org/rules/testfirst.html) is an effective means of design refinement and also leads to Simplicity, doing only what is truly needed. Without good tests it's impossible to do effective refactoring — how can you guarantee that the change didn't alter the code's behavior? The corollary is that developers also **don't** practice Refactoring, which leads to the mass of messy code. The irony is that even in rewrites — where it was assumed the new version would be better — it ends up becoming "legacy" very quickly.

Worse yet, when a [bug is found](http://www.extremeprogramming.org/rules/bugs.html), tests to prevent regression to the same bug are rarely created. And everyone must have seen bugs that were supposedly already fixed coming back shortly after. Another problem is that many teams haven't found a good definition of "story done" and therefore also struggle to have and maintain [acceptance tests](http://www.extremeprogramming.org/rules/functionaltests.html) for those stories. One of the reasons for this is teams that, instead of writing User Stories ("as X, I want Y because of Z," defining what to implement, for whom, and what value it brings), write Tasks ("do X," skipping who it's for and what value it brings).

Still in the "cowboy" spirit, inexperienced programmers don't understand the concept of [collective code ownership](http://www.extremeprogramming.org/rules/collective.html). What happens is that each developer tries to limit themselves to the code they think they're responsible for and doesn't worry about the whole. But the opposite should happen: every developer must feel responsible for all the code. This also explains one more reason for the importance of unit tests: without them it's impossible to help with code you didn't write, and it's also impossible to know if your own code doesn't break something someone else made. In summary: this leads to an immeasurable accumulation of "Technical Debt" that only becomes visible when it's already too late, turning your "new system" prematurely into an unmanageable "legacy." Still in this spirit, "cowboy" developers don't [integrate frequently](http://www.extremeprogramming.org/rules/integrateoften.html) as they should. It's not uncommon to see developers who write a new piece of code all week just on their machine and only at the end of the week commit to the repository and consider it done. No tests created, no full test suite run. One more developer deliberately creating Technical Debt.

To make matters worse, it's not hard to find teams that don't even understand the value of a repository: for them, it's enough to change things directly on the production server or edit files there directly. That's the prehistory of development. A code versioning repository isn't optional: it's mandatory. Treating it as a sanctuary is the greatest responsibility of a team, and that means all code in the repository must always be code with absolutely no deliberate problems introduced (through not writing tests, not integrating frequently, not refactoring where needed, etc). Bugs will always exist and must be fixed, but deliberate errors make the developer irresponsible and a problem for the entire team.

Finally, it's common to see developers who think they're very clever [optimizing](http://www.extremeprogramming.org/rules/optimize.html) very early in the project, based on nothing but guesswork, without measurements. By the way, most programmers I've met have as much aversion to measurement as they do to testing. And optimizing without being based on metrics is pure waste of time. You can make a certain piece of code 100x faster, but if overall it doesn't represent even a 0.5% gain, it was a waste of time. Again, inexperience.

Still regarding "suicidal cowboys," they're normally attached to their — limited — tools, which they're already comfortable with, too lazy — or incapable, or unwilling — to learn new things, and always try to go the immediately — and apparently — easiest route, like using automatic code generators, which generally produce code that's hard to maintain and usually outside the most modern standards accepted as good practices.

In the end, the result is the same: inexperienced developers who think they know everything, or long-tenured developers addicted to anti-practices and too stubborn to learn good ones. Building an efficient and truly Agile development team is very hard. And the reality is that simply not everyone is cut out for the job. An Agile developer is someone proactive, self-taught, sociable, and communicative. And all of that matters more than their supposed technical competence.

PS: some people might take this personally. But in reality, this is more common than you'd imagine — I've seen it at many clients and will keep seeing it. To be fair, I myself have done many projects (more than I'd like) that immediately became "legacy," code poorly tested and hard to maintain. Complaining is easy; doing something to improve is the hard part. The cowboy developer of yesterday has everything it takes to become a good programmer tomorrow — they just need to want it.
