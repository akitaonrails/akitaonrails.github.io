---
title: "[Off-Topic] Agile: the Truth Behind the Method"
date: '2014-09-28T23:18:00-03:00'
slug: off-topic-agile-a-verdade-por-tras-do-metodo
tags:
- off-topic
- principles
- management
- career
- agile
draft: false
---

This year, in addition to the [discussion about TDD](http://www.akitaonrails.com/2014/08/23/small-bite-um-pouco-tarde-o-grande-debate-sobre-tdd) (which isn't dead!), no one less than the very signatory of the Agile Manifesto, Dave Thomas, declared the death of "Agile" as we know it today.

A few articles that can give a basis for the rest of the discussion:

* by Dave Thomas: [Agile Is Dead (Long Live Agility)](http://pragdave.me/blog/2014/03/04/time-to-kill-agile/)
* by Richard Bishop: [Agile Is Dead: The Angry Developer Version](http://rubiquity.com/2014/03/12/agile-is-dead-angry-developer.html)
* by Giles Bowkett: [Why Scrum Should Basically Just Die In A Fire](http://gilesbowkett.blogspot.com.br/2014/09/why-scrum-should-basically-just-die-in.html)

In my company, since its conception, we don't use the word "Agile," "Scrum," or any buzzword. We do have "sprints," but things like grooming, planning poker (just kidding!), and other "rituals" are by no means "imposed" — but the practices are used (with or without the names) whenever necessary. I don't like to use the word "Scrum," "Kanban," or any other — it gives me a slight embarrassment to mention these names.

For those who actually apply agile practices day to day, this is no novelty. There are no doubts about things like Collective Code Ownership (Github!), Continuous Integration (Jenkins, Travis, Semaphore, etc.), Test Driven Development (Rspec, Jasmine, Capybara, etc.), Refactoring, YAGNI, User Stories/Requirements/Use Cases (or whatever the nomenclature: basically, scope). Look at the processes of open source projects: in terms of programming practices, it's not much more than that.

The problem is the process: project management itself. People talk a lot about Waterfall vs Agile, but that's a huge bullshit. What is much lamented is how the world of consultancies "specialized" in "Agile processes" has **prostituted** Agility. And it's true — that's why I don't "sell" things like "methodology implementation." Actually, I don't recommend that anyone try to hire a third party for this. If you really must, evaluate how much hands-on directly in the code and day-to-day the candidate you want to hire really has. Most have more "verbal" hours than action.

In this article I won't give the solution (that's for a future one) — in this one I just want to tell the one big truth that no one warns about, and that's why any attempt at implementation will fail: implementing any Agile practices, processes, and methods **requires** a good team, both programmers and managers and everything else. Does "good team" mean a team only of "seniors"? No: it requires people committed to their practice, whether juniors or seniors. And, by the way, those whom many today consider as "seniors" or "ninjas" (argh — whether because they speak, have many years of "experience") are almost all very little committed and merely arrogant. Again, more verbal than action.

This point is crucial: many people try to implement "Agile" in the hope of transforming a bad team, or a bad company, into something better. That's not going to happen. At the beginning it'll seem that things "got better" or, at least, that something "changed." But it's obvious — you're implementing some merely "different" practices, of course something will change for some time.

Programming is a profession of practice. There's no way to transform a bad programmer into a good one merely by adding methods, just like having a rookie soccer player attend a 2-day training will never turn him into a goal-scorer. Only practice — arduous, uninterrupted, consistent, of small continuous and constant improvements — will, perhaps!, lead him to be a goal-scorer. In my cynicism, [I told Bob Martin directly](http://www.akitaonrails.com/2010/06/16/railsconf-2010-video-entrevista-robert-martin) about my theory for what motivated Ken Schwaber to create something as silly as Scrum Certification at Railsconf 2010.

Programmers who practiced during the 80s and 90s, when we saw the descriptions of the principles and practices called "Agile" during the late 90s up to the publication of the manifesto in 2001, didn't see anything that disruptive. What was different is that someone finally condensed everything into a marketable commercial package, especially Scrum (which by itself doesn't include any of the important programming practices of Extreme Programming). Want to see how the practices have been evolving for much longer? Read [The Cathedral and the Bazaar](http://www.amazon.com/Cathedral-Bazaar-Musings-Accidental-Revolutionary-ebook/dp/B0026OR3LM/ref=sr_1_1?s=books&ie=UTF8&qid=1411957445&sr=1-1&keywords=the+cathedral+and+the+bazaar) and [The Mythical Man Month](http://www.amazon.com/The-Mythical-Man-Month-Engineering-Anniversary/dp/0201835959).

So no: implementing Scrum or even starting to implement XP **will not** save a bad team. One or another, who already had pre-disposition, talent, and willingness, will manage to become agile, after practicing, erring, and practicing more. Others, who don't have the talent, the pre-disposition, or — worse still — are actually bad-character, won't change. No methodology in the world will ever change a person's personality, at least not in such a short time. Think of it this way: his mother couldn't get the guy to not be lazy and a slacker, you won't either, and that's not your job. Your job is to deliver value.

The unspoken truth of the Agile world is that the application of agile practices arises naturally among good programmers already with experience. It will not be useful in a rookie team — which still needs to practice a lot, with or without agile principles.

I said you just have to look at how the open source world works. Contrary to what many (newbie) Brazilians imagine, open source has nothing, in principle, to do with inclusion or leftist movements. Actually I'd summarize open source as "the most efficient capitalist way to maintain commodities." It isn't inclusive: it's highly exclusive to developers. Without any employment ties, being purely voluntary, the interests revolve around marketing (company exposure, developer exposure, cost reduction, opportunities), and you really need to be "good" to stay at the top of the list. Everyone's opinions aren't automatically valid — quite the opposite, [ask Linus Torvalds](http://linux.slashdot.org/story/13/07/15/2316219/kernel-dev-tells-linus-torvalds-to-stop-using-abusive-language) what he does when a bad idea shows up. The open source world exposes problems immediately: just because you think your project is "cool" won't automatically translate into volunteers and exposure. Actually, the rate of projects that die is orders of magnitude higher than projects that gain exposure. The open source world, contrary to the commercial world, kills projects much more quickly.

Agile was made to **expose** problems as soon as possible. Understand: Agile practices are problem-exposure mechanisms! Agile is a **Risk** reduction and management mechanism! Find obstacles the moment they happen and treat them immediately to mitigate unnecessary future risks — which lead to waste.

But no one wants to do this. If the problem is the manager, what consultancy will manage to remove that manager from his position — unless the owner above him is committed to cutting his own flesh? If the problem is the bad-character programmer that everyone likes (the most dangerous type: the one who knows how to articulate himself and create zones of influence among peers and superiors), how do you fire that guy?

Yes: fixing a team in a short time **necessarily** means replacing its members. In the worst case, replacing all the members. If the method is well applied, it will immediately demonstrate and expose the problems, and if the problem isn't the practice but the behavior (which is the vast majority of cases), it's necessary to resolve it immediately. If you, stakeholder and responsible for your company, are not firing anyone after starting to implement Agile, you're doing it wrong.

And here's the big problem: no one understands this commitment. There's no free lunch. There's no way to make omelets without breaking some (or all) of the eggs. And without that understanding and commitment, there's no agility. By the way, this isn't the first time I'm saying this if you read my 2009 article: [Net Negative Producing Programmer](http://www.akitaonrails.com/2009/03/30/off-topic-net-negative-producing-programmer). But since most still seem not to have understood, I decided to make it even clearer.

This was an introduction. Depending on the comments, maybe I'll go down a few more steps to explain exactly the mechanisms of what I presented very quickly here.
