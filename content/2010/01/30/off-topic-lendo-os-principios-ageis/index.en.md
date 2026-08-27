---
title: "[Off-Topic] Reading the Agile Principles"
date: '2010-01-30T19:32:00-02:00'
slug: off-topic-lendo-os-principios-ageis
translationKey: off-topic-lendo-os-principios-ageis
description: "The 12 Agile principles need to be read together: delivering value quickly does not excuse quality, simplicity, collaboration, or continuous improvement. The Manifesto is not a ready-made recipe."
tags:
- agile
- software-engineering
- off-topic
draft: false
---

The Agile Manifesto rests on [4 values](http://agilemanifesto.org/). I've repeated that more times than I can count. On top of that, it rests on [12 important principles](http://agilemanifesto.org/principles.html) that a lot of people treat like the ten commandments.

I'm against anything turned into dogma. But if you insist on dogmatizing the Manifesto, never pull a single sentence out of it in isolation. If you're going to take one principle literally, take all of them literally, otherwise it's the same as dogmatizing the ten commandments and saying _"I obey the ten commandments: I've committed adultery, but it doesn't matter because I never killed anyone, never stole, and it wasn't with the neighbor's wife that I committed adultery."_

A few of the principles:

> "Our highest priority is to satisfy the customer through early and continuous delivery of valuable software."

This one principle alone has fueled years of debate. Worth reading [Our Highest Priority](https://www.pavley.com/2009/10/08/our-highest-priority/) and [Why Satisfy the Customer?](http://web.archive.org/web/20100201014014/http://stevebockman.com:80/blog/2010/01/27/why-satisfy-the-customer/).

I like to think like [Eliyahu Goldratt](http://en.wikipedia.org/wiki/Theory_of_Constraints), who says, in simplified terms, that the priority of any company is _to make money._ Now, calm down, anti-capitalists and on-duty populists :-) Nobody is talking about _"making money at the expense of people, customers, and society"_ or anything like that.

The priority is to make money. Creating innovation, creating products, and generating jobs are means to get there, and we keep confusing the **means** with the **goals**.

_"Delivering fast and continuously"_ is important to keep in mind. It isn't always possible, for example, when you depend on suppliers or other external factors. But let me pull in other principles tied to this first one:

> "Deliver working software frequently, from a couple of weeks to a couple of months, with a preference to the shorter timescale."

Time is never fixed, because every professional knows you can't predict the future. Delivering value quickly is a principle that guides the work, and nobody should treat it as a rigid rule. It means doing everything possible to deliver something that works, with quality, in the shortest viable timeframe.

For that, you try to remove impediments, improve processes, optimize procedures, and improve communication. It's a reminder for every agilist whenever deliveries start taking longer than normal.

> "Working software is the primary measure of progress."

Same idea in different words: software that hasn't been delivered is useless. An agilist should feel bad working for months on software nobody uses.

Every piece of software is different. Sometimes it takes a whole day to find a one-line solution, and sometimes you can write a hundred lines in an hour. It's the old productivity dilemma the industry tried to solve with failed techniques like LOC (lines of code), Function Points, and other nonsense.

I imagine Martin Fowler was one of the people who suggested this principle, mostly because of his article [Cannot Measure Productivity](https://martinfowler.com/bliki/CannotMeasureProductivity.html). Software is measured by value. Raw productivity says very little, and whoever defines the value to be reached in development is the client or the company.

If the delivered software brings no value, the problem is in the definition of that value. The software did what it was told. A tool, on its own, has no value.

That's why I say LOC and function points are useless. I can have a team shipping ten thousand function points per sprint, and it means nothing if what was requested brings no value to the client.

This is one of a Product Owner's jobs: making sure whatever enters the development queue will actually bring value, short or long term, depending on the future vision they have. A PO with no vision, no strategy, and no clear direction reaps exactly that: lots of software and little value. The blame there lands on the PO's and the company's lack of vision, never on the technical team.

And speaking of POs, we can't leave out stakeholders in general, the people interested in the value the project will generate:

> "Business people and developers must work together daily throughout the project."

Personally, I'd hate bureaucrats around a development environment every day :-) Cynicism aside, this is another reminder that whoever cares about the value of a project is the one who should seek out the team and check if anything is missing. A stakeholder who never approaches the technical team shows they don't care about the result.

And I'm not talking about a daily meeting. Five or ten minutes of conversation a day are enough, no ritual like a Daily Scrum required. An interested stakeholder gets up from the chair and walks over to the teams. An uninterested stakeholder stays seated, waiting for things to happen on their own.

Guess which of the two is more efficient? If the stakeholder, who should be the most interested, shows no interest in what's being produced, why would anyone on the team bother?

Teams are a reflection of the company's organization. If the upper layers are disorganized, indecisive, uncommunicative, and irresponsible, the teams will be the same. What are teams but sub-systems, copies of the larger complex adaptive system called "company"?

A company can hire a hundred Linus Torvalds, a hundred Guido van Rossums, a hundred John Resigs, and even then don't expect them to come up with iPods, iPhones, and other products that sell millions all on their own. Apple works because, I speculate, a Steve Jobs gets out of his chair and gets personally involved in the day-to-day of the research and development teams, even as CEO.

Put this way, it sounds like one side is off the hook for the other's responsibility. Of course not. The best way to work is **collaboratively**, but arriving at the best technological solutions, with technical quality and efficiency, is the technical team's job. Stakeholders, in turn, answer for market studies, marketing research, and product vision.

One side can and should collaborate with the other, but not everyone can do everything equally. Stakeholders bring the vision and the technical team does what it can to fulfill it. Except the vision isn't authoritarian, just as some technological decisions shouldn't be either.

The criticism shows up when orders come from a single direction, with no discussion. The technical team can be doing everything right and still head the wrong way, and in the end the criticism comes back on them for the failure of a vision nobody ever discussed.

> "The most efficient and effective method of conveying information to and within a development team is face-to-face conversation."

To me, this is a corollary of the previous principle. Forget automated communication systems, information-flow systems, and all that nonsense. Everyone has seen 80s and 90s movies mocking "memos," that technique for spreading information. To this day people still try something similar, only now they call it a spreadsheet, an email, a wiki, and so on.

What matters is sitting next to the person who's going to deliver value to you, clearly stating the expectations, what changed, what stayed, and then getting out of the way. A stakeholder who can't talk live with the teams shows, again, no interest in the result. And the message is clear: what's being developed has no value, because if it did, they'd show interest.

As long as a stakeholder keeps the old-fashioned mentality of _"these people who work for me are obligated to guess what I'm thinking and deliver what I want, when I want it,"_ they'll never get any value, and they'll keep asking themselves _"are my teams so incompetent they can't deliver anything?"_ The obvious conclusion would be the other one: _"maybe if I just 'tell' them what I'm thinking, they can deliver what I want."_

And there's nothing worse than an absent stakeholder who only shows up when something goes wrong, to yell, threaten, and terrorize. Where was he during the whole process that led to this accident in the first place?

> "At regular intervals, the team reflects on how to become more effective, then tunes and adjusts its behavior accordingly."

Every agile methodology has a "Retrospective" phase, one of the rituals created for teams that weren't used to talking. No process is a silver bullet, and every process needs constant refinement. Ideally, each retrospective, at the end of each sprint, points at something to change. There's no perfect scenario; what there is is continuous, uninterrupted improvement. If nothing changes after a retrospective, if nobody suggests adjustments at the end of the sprint, something is wrong.

The other principles speak for themselves:

> "Welcome changing requirements, even late in development. Agile processes harness change for the customer's competitive advantage."

Changes are welcome, as long as they bring competitive advantage to the customer. Random changes based on the mood of the people involved stay out.

> "Build projects around motivated individuals. Give them the environment and support they need, and trust them to get the job done."

Obvious again: either you trust your teams, or you don't. If you don't, fire them. If you do, stop micro-managing and demanding reports all the time. Simple as that. Anyone who doesn't trust them and still thinks they can control everything through micro-management is a terrible manager, and should fire themselves first.

About the environment, remember [Maslow's Hierarchy of Needs](http://en.wikipedia.org/wiki/Maslow's_hierarchy_of_needs). If the environment is cramped, hot, dirty, and disorganized, don't expect motivated, proactive, organized teams. Nobody motivates anybody, but demotivating is very easy. Don't demand the top of the pyramid while not even the base is satisfied.

> "Agile processes promote sustainable development. The sponsors, developers, and users should be able to maintain a constant pace indefinitely."

It means all the principles above are being respected: there's a good environment, stakeholders are involved, live and frequent communication happens, and priorities are clear. With that, you can have frequent deliveries at a constant pace and, better still, accelerating.

> "Continuous attention to technical excellence and good design enhances agility."

The first principle, in isolation, sometimes gives the false impression that value has to be delivered at any cost, sacrificing quality, maintainability, and good design. That's false, and that's exactly why I keep insisting on considering all the principles together.

Valuable software should be delivered as fast as possible, but never at the cost of wrecking future maintainability, right when the Return on Investment starts happening. Each case is its own case, and that's why stakeholders and teams need to talk often and decide based on cost-benefit.

> "Simplicity--the art of maximizing the amount of work not done--is essential."

Together with the previous principle, this means not getting stuck on _"maybe they'll need this in the future"_ and cranking out "bloat" software, fat, heavy, and complex to try to make it _"future-proof"_. That's impossible and only leads to software that takes too long to deliver and shows up with dubious value.

Again, it's a matter of communication, negotiation, and cost-benefit, starting from the value the stakeholder said they need.

> "The best architectures, requirements, and designs emerge from self-organizing teams."

This topic I've explained dozens of times, in all sorts of ways, but I recommend reading my article [Agility, Chaos, Self-Organization](/en/2009/07/08/off-topic-agilidade-caos-auto-organizacao).

Anyone who doesn't understand Emergence and Self-Organization doesn't understand Agility. That brings me back to my article [You Don't Understand Anything About Scrum](/en/2009/12/10/off-topic-voce-nao-entende-nada-de-scrum), which I also recommend reading now.

As you can see, the world of Agility rests on important principles. None of them holds up in isolation: either you consider them all together, or you'll have none of them.

But be careful: a lot of people confuse Agility, Self-Organization, and Participatory Management with [the Search for Consensus](http://en.wikipedia.org/wiki/Consensus). Nothing could be further from that. I'm taking longer than I'd like to finish the book [Systems Thinking](https://www.amazon.com/Systems-Thinking-Second-Complexity-Architecture/dp/0750679735), but here's an excerpt I like:

> "Finally, fear of rejection and a strong tendency toward conformity among members of a social system and others are obstacles to social changes. An example is the experiment in a city with a dry law (which doesn't allow the sale of alcohol) whose constituents were to vote on the ban against alcohol. A pre-voting poll indicated that 75% of voters were in favor of abolishing the ban. However, each of the voters thought that the majority preferred the dry law. When the results were tabulated, 60% of voters voted to keep the dry law. Not surprisingly, after the poll was published, the next election on the subject produced a 65% majority in favor of abolishing the ban."

Democracy based on the [Tyranny of the Majority](http://en.wikipedia.org/wiki/Tyranny_of_the_majority) is useless. This subject is much more complicated than just having people vote on the options, and it can't be treated lightly. Political scientists, philosophers, and various researchers have been studying it for a long time, and I guarantee there's vast literature on it.

And this whole subject is more complex than just reading the twelve principles. An engineer, a doctor, or a lawyer study for years and are still far from being masters of their fields. A manager, on the other hand, studies almost nothing, and so decides based more on folklore than anything else. It's terrible: in these cases, when they're right it's by luck, and when they're wrong it's just what you'd expect.

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Akitaonrails-DanPinkMotivao160.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Akitaonrails-DanPinkMotivao160.mp4)
</source></video>
