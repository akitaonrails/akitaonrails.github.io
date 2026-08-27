---
title: "[Off-Topic] #noEstimates Debunked"
date: '2013-10-07T11:35:00-03:00'
slug: off-topic-noestimates-debunked
translationKey: noestimates-debunked
description: "The author separates projects from ongoing operations to defend estimates, objectives, and constraints in projects. To him, constraints drive innovation, but competent execution matters more than any methodology."
tags:
- agile
- management
- software-engineering
- off-topic
draft: false
---

**Update:** One thing I forgot to mention. If you didn't want to read all this, or you disagree altogether, ask yourself the following. You don't want due dates, so are you willing to give up your salary's due date as well? Why can't you estimate what you'll deliver and yet your client still has to pay you?

Let's make this even: you do #noEstimates if, and only if, you're willing to do #noSalary. Your employer holds your pay until you deliver, and in that scenario the amount gets depreciated the longer you take. Labor law doesn't allow that, unfortunately. But it would be an interesting scenario.

There are a lot of people talking about #noEstimates lately. I've read most of the arguments in its favor, and anyone can run a quick Google search, so I won't keep referencing each of them. The gist is this: estimates will never be good enough, and the more specification and planning you do, the less the quality of the estimates seems to improve. In a dynamic market the specs change all the time, and the bigger the estimation effort, the bigger the waste. If estimation is that much of a waste, why not throw it all out at once?

It feels like a noble idea, especially for software developers. Software is malleable, it's abstract, and it just seems not to fit the traditional notions of project management. And while we're at it, why not throw out the entire notion of projects too? That's how another trend came along, #noProjects.

My intention here isn't to answer every argument, and that isn't even the point. What I'll do is explain why the whole idea is absurd right at the root. So let's start with the basics.

One thing I've argued since at least 2008 is looking at project management and markets in general through the models of Complex Adaptive Systems, Chaos Theory, and Evolutionary Biology. I've been heavily influenced by the ideas of Nassim Nicholas Taleb and his magnum opus "The Black Swan". The idea is incredible: markets are driven by chaotic agents that influence a complex system, far from any linear path.

Every company is managed to deal with averages, with limited sigmas as the margin of operational error. But once something big happens, a "Black Swan" like the 2008 economic crisis, most aren't prepared. No model can predict it, and the whole system locks up and collapses.

If you don't know the idea, Google it for a second and you'll see that companies, markets, and human relationships in general are dynamic systems that obey the rules of evolutionary biology. Decentralized systems seem to be the way to go, and those concepts influence many of the Lean movements we see today. So, yes, I'm well aware of these effects.

To sum it up, the ones with the most chance of surviving in a complex system like that are the most adaptable, far more than the ones who stick rigidly to plans. Following long-term plans with rigidity is the easiest way to fall down when the Black Swans show up.

That led me to another concept: Einstein's General Theory of Relativity. In modern cosmology it superseded Newton's Theory. When I first learned that, my first thought was: if Newton is "wrong", why aren't we using Relativity to calculate everything in our daily lives?

The answer is that Newton is only "wrong" if you demand that it calculate anything. It doesn't apply to the very very large, to gravitational calculation, to galaxy-level calculations. But at Earth-like sizes, computing the path of an airplane or the trajectory of a bullet, it still holds, because the margins of error are negligible. In day-to-day life you can reduce the problem to Newton and leave General Relativity aside. It's a crude simplification, of course, but bear with me.

The same applies to companies. We're all subject to Power Law distributions, to Evolutionary Biology, to the relentless forces of Chaos that make everything behave like Complex Adaptive Systems. But in a constrained environment I'll argue that you can reduce the calculation back to Bell Curves. That's the hardest part to "prove", so I won't try right now, but the explanation that follows may get you there.

Let's define what a company is: a set of operations. Operations are repetitive activities, like "pay a supplier", "send a purchase order", "process the payroll", or "transport products". The set of all those activities defines what a company is.

The core idea of a company is to run those operations as efficiently as possible. You do that by continuously refining the process in small steps, or through a breakthrough that completely changes the way you run a particular operation.

An example: back in the day there were entire groups of people dedicated to filling out paper forms and organizing them so information could flow inside the company. With the rise of digital systems, of ERPs, all that paperwork stopped being necessary. We got rid of an entire profession of typists and added efficiency and precision to the system. Breakthroughs are usually the digital automation of manual labor, or getting rid of a process entirely.

To reach those breakthroughs there are Projects. Projects are temporary endeavors where a group of people concentrate to hit a pre-established goal. They usually have a fixed start and due date, a fixed budget, and a fixed number of people involved.

And here we get to the Estimation part. Every project wants to hit some goal, and in the case of a software project we write code to get there. To do that, we come up with features and break them into Use Cases, User Stories, Requirements, or any artifact that describes what has to be built. Then we estimate how much resource (time, money, people) it takes to implement each piece and integrate them into a "solution" that solves the problem.

What developers complain about is that you can't estimate those pieces with precision, and that projects will always come out late and over budget. Hence the idea of estimating nothing, just starting to code, delivering value as fast as possible, and calling it done only when it's done.

Some developers get so fed up with this whole notion that they want to leave their companies and start their own startups, where they'll get to do whatever they want with no controls at all. Then off they go looking for investors, because they need a lot of money and a lot of time. Of course they do. What they don't realize is that **EVERYBODY** needs a lot of money and a lot of time.

And investors know this: the idea is irrelevant, execution is everything. The ones who deserve more money and more time are exactly the ones who can pressure themselves into delivering under budget and ahead of everyone else. Just doing something without worrying about constraints is the realm of the mediocre. And the mediocre deserve nothing.

Back to basics: there's a thing called [Economy](https://en.wikipedia.org/wiki/Economy) precisely because resources aren't infinite. Everything that has value has a price, whether it's a physical product or working hours.

Understand this: in the services business, where we developers all live, whether as an employee or a co-founder, value has only two variables, quality and efficiency. We tend to see quality as the only thing that matters. Worse: we tend to see what *we* think is quality as the only thing that matters.

This brings us back to **CONTEXT**. Most programmers are bad at estimates, and the root of it is that they're usually utterly incompetent at understanding context. As someone with a Math background, I read all those articles about processes, methodologies, and things like "#noEstimates" as if they were "formulas".

Formulas alone don't mean a thing. Any mathematician knows you have to define a [Domain and an Image](https://en.wikipedia.org/wiki/Domain_of_a_function), the source and the destination of every input and output. If I show you a formula like <tt>"f(x) = 1 / x"</tt>, you can say it's invalid, because you can't divide when x is zero. But if I tell you the Domain is every Natural number except zero, now it's a perfectly valid formula for the Image of the Rationals.

So when someone says "#noEstimates", the natural question is: in which Domain and for what Image? That's the origin of the confusion in most Internet arguments. People argue for or against an idea because each one is in a different Domain. Same goes for Agile in general, Lean Startups, Lean Manufacturing, and so on: they tend to define only practices, procedures, formulas, but they rarely define Domain and Image. That creates confusion and misses the point.

What I'll define is this: Projects are necessary every time there's a defined goal to hit. That's the domain. And I'll also state that whoever says "#noEstimates" is thinking about the Domain of "Ongoing Operations", while Projects are a separate Domain. That's exactly where Lean Manufacturing in general fits too.

I already explained Operations above, and it's where the small improvement steps (Kaizen) emerge. Sometimes the feedback from an operation gives enough input to justify a Project and take a bigger step, a breakthrough.

Projects, on the other hand, remain temporary endeavors. The whole idea is to set boundaries, like time and cost constraints. And we come back to the original question: is it impossible to predict the effort needed for something as malleable as software development?

First of all, yes, it's impossible to predict with exact precision. Let's define it again: it's impossible to predict a number with zero margin of error. Estimation is prediction with a margin of error. And why do some projects cost more than twice as much and take more than twice as long as the estimate?

Most of the time, in 90% of cases, because the team is incompetent. The problem isn't the estimate, it's the execution. Estimation is the establishment of an expectation, and expectations have to be managed. An estimate is only good if the context is taken into account.

Most people don't like to estimate because of the "what if" scenarios. What if the client changes their mind? What if we hit a hard obstacle? What if a meteor strikes the Earth and all living creatures perish? "What if" can't be managed; what can be managed is what you know, by creating constraints. A project's constraints start with its goal. To hit that goal, we also set the rules of engagement, the premises. Without goals and without premises, there's no game.

None of that guarantees a Prediction. An estimate is only as good as the execution. Now we have to manage it, and everybody has to manage it.

It's no use setting clear rules and then suddenly seeing a programmer sitting idle. You ask why he's idle, and the answer is "_oh, because I emailed the client about some requirements and he never replied, so I was waiting_". You ask "_and did you try calling him?_", and the answer is usually "_No, I didn't_". No amount of process or methodology "fixes" an incompetent employee. Lack of technical skill can be fixed. Bad faith cannot.

The #noEstimates advocates can argue they're not like that, and I believe them. But 90% of the projects that failed had employees like that. Programmers tend to blame the client, the bosses, the market, but never themselves. And as a programmer I'll argue that most projects fail because of lazy employees, far more than because of changing requirements or limited time. Want to make projects go right? Start with Human Resources, then go find methodologies and practices.

The trouble with methodologies that don't state the Domain their formulas work in is that most people don't see where that Domain begins: at __"having competent, committed, and skilled employees"__. Most adopt methodologies hoping to turn incompetent employees into competent ones, and that just doesn't happen.

With that settled, why do we need estimates? Or, more generally, why do we need constraints? Because that's the essence of the value of any system. Nature puts pressure on every living species: changing climate, limited food, predators. The most adaptable species evolve, and the ones that can't adapt perish.

When someone says "_it's impossible to do X_", that's probably the most valuable goal to chase. Because the full sentence is "_it's impossible to do X with what we know today_". It was impossible to go around the globe in 24 hours, now it isn't. It was impossible to talk to the other side of the world in real time, now it isn't.

Constraints are the foundation of innovation. If I had to define innovation, I'd say it's "the process by which you accomplish something that was deemed impossible before".

If you have infinite resources, or you simply don't need to worry about constraints, which is what happens in bubbles, you don't innovate. This is so important that I'll repeat it:

<blockquote>Innovation is the byproduct of Constraints.</blockquote>

We estimate based on past knowledge. If we can't outdo our own past selves, how incompetent are we? You can argue that software isn't predictable, and I agree. But being off by orders of magnitude when recreating similar software just smells of incompetence to me.

Most of the software we produce is the same old thing: content websites, ecommerce, elearning, social networks, social commerce, forums, polls. It's rarely a brand-new idea or a breakthrough algorithm. Unless you work in research programs, what kind of truly different software have you built lately?

Estimation is rarely the problem. Every estimate starts from a set of premises, and the problem is not managing those premises. If the requirements change, fine, that we can always manage. What we can't manage is the pile of problems on the last day of the project, after the programmers kept pushing everything under the rug. Again, this is a Human Resources problem.

Meritocracy only exists in a system of scarcity, where one stands out against another in the face of a constraint. In a system of pure abundance, there's no need to innovate or to have merit. Companies that just got a humongous pile of cash invariably show symptoms of laziness, far more than of innovation.

The confusion comes from some of the "practices" being pushed coming out of this temporary, unreal bubble situation, and they can't take the pressure of time. Give it enough time and you'll ask yourself: "how did we, with so much money and so much time, get so little done, and that little startup, with such limited resources, managed to outdo us?". That's the answer to why a Yahoo! buys a Tumblr, why a Facebook buys an Instagram, why a [Google buys a Waze](https://en.wikipedia.org/wiki/List_of_mergers_and_acquisitions_by_Google).

If you advocate #noEstimation, why not go one step further and advocate #noWork? It's just one more step.
