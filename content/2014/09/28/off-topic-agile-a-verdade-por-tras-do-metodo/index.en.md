---
title: "[Off-Topic] Agile: the Truth Behind the Method"
date: '2014-09-28T23:18:00-03:00'
slug: off-topic-agile-a-verdade-por-tras-do-metodo
translationKey: off-topic-agile-a-verdade-por-tras-do-metodo
description: "I argue that Scrum, XP, and other Agile practices cannot save bad teams. They expose risks and problems quickly. Agility depends on committed people, continuous practice, and concrete behavior changes."
tags:
- agile
- management
- software-engineering
- off-topic
draft: false
---

This year, on top of the [discussion about TDD](http://www.akitaonrails.com/2014/08/23/small-bite-um-pouco-tarde-o-grande-debate-sobre-tdd) (which isn't dead!), none other than one of the Agile Manifesto signatories, Dave Thomas, declared the death of "Agile" as we know it today.

A few articles that can set up the rest of the discussion:

* by Dave Thomas: [Agile Is Dead (Long Live Agility)](https://pragdave.me/blog/2014/03/04/time-to-kill-agile/)
* by Richard Bishop: [Agile Is Dead: The Angry Developer Version](http://web.archive.org/web/20140908134511/http://rubiquity.com/2014/03/12/agile-is-dead-angry-developer.html)
* by Giles Bowkett: [Why Scrum Should Basically Just Die In A Fire](http://gilesbowkett.blogspot.com/2014/09/why-scrum-should-basically-just-die-in.html)

At my company, since day one, we don't use the word "Agile," "Scrum," or any other buzzword. We do have "sprints," but things like grooming and planning poker (just kidding!) are by no means "imposed." The practices get used, with or without the names, whenever they're needed. I don't like saying "Scrum," "Kanban," or any other label; mentioning these names gives me a mild sense of embarrassment.

For anyone who actually applies agile practices day to day, none of this is news. Nobody argues about things like Collective Code Ownership (Github!), Continuous Integration (Jenkins, Travis, Semaphore, etc.), Test Driven Development (Rspec, Jasmine, Capybara, etc.), Refactoring, YAGNI, User Stories/Requirements/Use Cases (or whatever you want to call it: basically, scope). Look at how open source projects run: in terms of programming practices, it's not much more than that.

The problem is the process: project management itself. People talk endlessly about Waterfall vs Agile, but that's a load of bullshit. What's worth lamenting is how the world of consultancies "specialized" in "Agile processes" has **prostituted** Agility.

And it's true. That's why I don't "sell" things like "methodology implementation," and I honestly don't recommend anyone hire a third party for it. If you really must, size up how much hands-on time in the actual code and the day-to-day the candidate really has. Most of them rack up more "verbal" hours than hours of action.

In this article I won't give the solution, that's for a future one. Here I just want to state the one big truth nobody warns you about, which is why any implementation attempt will fail: implementing any Agile practices, processes, and methods **requires** a good team, programmers and managers and everyone else.

Does "good team" mean a team of nothing but "seniors"? No. It requires people committed to their craft, whether juniors or seniors. And by the way, the folks many people today call "seniors" or "ninjas" (argh, whether it's because they give talks or because of their many years of "experience") are almost all barely committed and merely arrogant. Again, more talk than action.

This point is crucial: plenty of people will try to implement "Agile" hoping to turn a bad team, or a bad company, into something better. That's not going to happen. At first it'll look like things "improved" or at least that something "changed." But of course: you're implementing a few merely "different" practices, so naturally something will change for a while.

Programming is a profession of practice. You can't turn a bad programmer into a good one just by bolting on methods, the same way making a rookie soccer player sit through a two-day training will never turn him into a goal-scorer. Only hard, uninterrupted, consistent practice, made of small continuous improvements, will maybe get him there. In my cynicism, [I told Bob Martin directly](/en/2010/06/16/railsconf-2010-video-interview-robert-martin-english) my theory about what motivated Ken Schwaber to create something as silly as Scrum Certification, at Railsconf 2010.

Anyone who was programming in the 80s and 90s didn't see anything that disruptive when the descriptions of the principles and practices called "Agile" showed up in the late 90s, up to the publication of the manifesto in 2001. What was different is that someone finally condensed everything into a marketable commercial package, mostly Scrum (which on its own includes none of the important programming practices from Extreme Programming). Want to see how the practices have been evolving for far longer? Read [The Cathedral and the Bazaar](http://www.amazon.com/Cathedral-Bazaar-Musings-Accidental-Revolutionary-ebook/dp/B0026OR3LM/ref=sr_1_1?s=books&ie=UTF8&qid=1411957445&sr=1-1&keywords=the+cathedral+and+the+bazaar) and [The Mythical Man Month](http://www.amazon.com/The-Mythical-Man-Month-Engineering-Anniversary/dp/0201835959).

So no: implementing Scrum, or even starting to implement XP, **will not** save a bad team. One here or there, who already had the disposition, the talent, and the drive, will manage to become agile after practicing, screwing up, and practicing more. The rest, who don't have the talent or the disposition, or worse, are flat-out bad-character, won't change.

No methodology on Earth will ever change a person's personality, at least not in so little time. Think of it this way: his mother couldn't get the guy to quit being lazy and a stall-tactic artist, you won't either, and that's not your job anyway. Your job is to deliver value.

The unspoken truth of the Agile world is that applying agile practices comes naturally among good programmers who already have experience. It won't be useful on a rookie team, which still needs a lot of practice, with or without agile principles.

I said you just have to look at how the open source world works. Contrary to what a lot of newbie Brazilians imagine, open source has, in principle, nothing to do with inclusion or leftist movements. I'd sum up open source as "the most efficient capitalist way to maintain commodities." It's highly exclusive to developers.

With no employment ties, on a purely voluntary basis, the interests revolve around marketing: company exposure, developer exposure, cost reduction, opportunities. You really do need to be "good" to stay at the top of the list. Does everyone's opinion carry equal weight? [Ask Linus Torvalds](http://linux.slashdot.org/story/13/07/15/2316219/kernel-dev-tells-linus-torvalds-to-stop-using-abusive-language) what he does when a bad idea shows up.

The open source world exposes problems immediately. Just because you think your project is "cool" doesn't automatically translate into volunteers and exposure. The rate of projects that die is orders of magnitude higher than that of projects gaining traction. Compared to the commercial world, open source kills projects far faster.

Agile was built to **expose** problems as early as possible. Understand: Agile practices are problem-exposure mechanisms! Agile is a **Risk** reduction and management mechanism! Catch the obstacles the moment they happen and deal with them immediately to head off unnecessary future risk, the kind that only leads to waste.

Except nobody wants to do this. If the problem is the manager, what consultancy is going to remove him from his post, unless the owner above him is committed to cutting into his own flesh? If the problem is the bad-character programmer everyone likes (the most dangerous type: the one who knows how to work a room and build zones of influence among peers and superiors), how do you fire that guy?

Yes: fixing a team in a short window **necessarily** means replacing its members. Worst case, replacing all of them. If the method is applied well, it immediately demonstrates and exposes the problems. And since in the vast majority of cases the problem is behavior, not practice, you have to resolve it on the spot. If you, the stakeholder responsible for your company, aren't firing anyone after you start implementing Agile, you're doing it wrong.

And here's the big problem: nobody gets this commitment. There's no free lunch. There's no making an omelet without breaking some (or all) of the eggs. Without that understanding and that commitment, there's no agility. And this isn't the first time I say it, if you read my 2009 article: [Net Negative Producing Programmer](/en/2009/03/30/off-topic-net-negative-producing-programmer). But since most people still seem not to have gotten it, I decided to spell it out more clearly.

This was an introduction. Depending on the comments, maybe I'll walk down a few more steps to explain exactly the mechanisms of what I laid out very quickly here.
