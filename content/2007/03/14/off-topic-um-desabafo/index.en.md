---
title: 'Off Topic: A Rant'
date: '2007-03-14T03:02:00-03:00'
slug: off-topic-um-desabafo
tags:
- off-topic
- career
draft: false
translationKey: a-rant-2007
---



Fair warning: this post will probably end up a bit "philosophical" again. I don't have the resources for a more rigorous approach — field research, statistical analysis of a large sample — so I'm left trusting my practical experience and whatever data is publicly available.

One piece of that data is this survey: [Survey says 75% of IT professionals want to change jobs](http://idgnow.uol.com.br/carreira/2006/08/21/idgnoticia.2006-08-21.7048942010/IDGNoticia_view). It's old — from the middle of last year — but I see this in practice. A few days ago some friends came to me with exactly this situation: _"I'm unhappy with what I'm doing."_

We need to take these articles with a grain of salt — most are based on US market data. For instance, another one says [Programmers are the highest-paid in tech](http://idgnow.uol.com.br/carreira/2006/08/15/idgnoticia.2006-08-15.9911074683/IDGNoticia_view). In Brazil that isn't necessarily true. Programmers earn "enough"; the ones pulling larger salaries are analysts — people with degrees in other fields who use technology as a work tool. And those analysts and consultants making up to R$100,000 a year are usually the loudest complainers.

[![](/files/neumannface_en.jpg)](http://en.wikipedia.org/wiki/Von_Neumann)

Another complaint I hear constantly: _"I'm not enjoying my workplace anymore because it doesn't 'add' anything to me. I want to move on to other projects to learn more."_ A laudable impulse toward change, but I think most people are misdirected. A colleague of mine once summed it up: _"The vast majority of projects are all the same: CRUD screens, over and over."_ And that's exactly right — it's the descendant of the old field called _Data Processing_, which we now call _Information Systems_.

There should be more than that. In the non-programmer space you have Business Intelligence, Customer Relationship Management, Supply Chain, and various other cutting-edge areas that differentiate companies that already have the basics under control: accounting, sales, purchasing, manufacturing, maintenance, quality control.

In Brazil, the vast majority of "programmers" are doing customizations on existing processes or add-ons. A department wants to automate employee record management: they buy or build their own forms. Another wants a sales form that feeds their sales system and notifies an external partner for inventory updates. Another needs a few screens to control a customer service workflow. Forms and more forms — it's almost always some variation on data entry.

[![](/files/zuse.jpg)](http://en.wikipedia.org/wiki/Konrad_Zuse)

No wonder so many programmers are dissatisfied. Usually they don't know _why_, but they sense something is "off." Of course — please, _don't take any of this too literally_. There are dozens of fascinating projects involving the coding of complex algorithms for process control, aerospace, engineering. I'm talking about _the majority_, not _everyone_.

This systematic process of data entry upon data entry is nothing new. Since COBOL, since the 70s, data processing was a hugely important field for bringing dynamism to the modern world, eliminating tons of paper and dozens of bureaucrats whose only function was to fill out and manage all that paper. And it will never end — unless computers become smart enough to stop needing "mere" programmers. You never know.

In the meantime, the market will still need this category of professional: the "CRUD programmer." It doesn't matter whether you use Struts, Spring, Rails, or Symfony — you'll be building user records, client records, material records, content records, complaint records, service records, contract records, address records, partner records, vendor records. The list is enormous. Especially in places where "modernization" hasn't yet arrived, where companies still have many bureaucrats and where processes haven't been stabilized, let alone automated.

I remember starting out building CRUD screens in the late 80s with dBase and Clipper. Most of it was Client-Server (2-tier): a database on the server, data entry screens on the client. When the Web arrived, we saw seductive applications — search engines, webmail. Suddenly everyone wanted to build a Website. The people who invented the technologies — TCP/IP, HTTP, HTML, SMTP, POP3 — must have had a lot of fun, but for the rest of us: more CRUD. Screens to write emails = CRUD. Screens for e-commerce = more CRUD. Suddenly companies replaced the Visual Basic screen model with browsers. CRUD dressed up as web pages.

[![](/files/hoppergrace_big.jpg)](http://en.wikipedia.org/wiki/Grace_Hopper)

It's no coincidence that so many frameworks keep appearing: Struts, Velocity, Lucene, JackRabbit, Spring, Guice. Real programmers love the plumbing. We love understanding how this mesh of code works, how to optimize it, how to make it stable, how to connect things together. There are many people in Brazil who think this way, but far fewer than in the United States. We have nothing even close to a repository like Apache Jakarta. We have Brazilian contributors to various open source projects, but it's a small fraction.

I see this through the Rails case. It emerged not that long ago, and not in the US. Even so, it spread very quickly over there. Here, aside from small communities like the competent RubyOnbr, we have nothing. Nothing interesting in the media, nothing interesting at conferences (of which we have very few, by the way). Nothing, zip, nada. My book, "Repensando a Web com Rails," barely sold its first edition of 1,000 copies. The [excellent] "Agile Web Development with Rails" sold tens of thousands abroad. It's not just a matter of one book being "better" or "worse" — the meteoric sales figures and the launch of dozens of others there, versus mine being the only one here, are a thermometer for the cultural difference both in the market and among programmers.

Fair enough — we had a dark period of closed markets, years of delay. But today I see no reason for programmers, especially the younger ones, to be so _apathetic_ toward technology.

[![](/files/Herman-Hollerith.gif)](http://en.wikipedia.org/wiki/Herman_Hollerith)

At times like these I miss the late 80s a bit (that's my era; more experienced folks will feel the same about the late 70s). Back then we knew we were very few. It was rare to find someone who was a programmer or even a technology enthusiast. But we thought differently. Even in the mid-90s, just before the internet boom, our friends and colleagues were all technology lovers. We always talked about what was new, what we'd learned, what we were testing. We exchanged ideas, debated techniques. The goal was always to learn more and more. I knew people whose hobby was writing small animations in Assembly. I knew others who bought electronic components to build their own mp3 players (no iPods back then). Some spent hours building tools for this "internet" that was still new to us. Those were good times.

Then the Brazilian IT market exploded, for various reasons. Suddenly many people saw the IT field as a quick way to make money. Suddenly the universities filled up with students learning not technology, but tools. Becoming not bachelors in computer science, but technicians in information systems. Suddenly everyone "knew" Java. And finally, suddenly the market became saturated: with hundreds of "programmers."

Now all I hear from current "programmers" is: _"Which language do you think I should learn that will pay the most?"_ You can imagine how frustrating that is for me, already feeling like part of the _old guard_. I never thought about the cost-benefit ratio of learning time. I always considered learning something I should do constantly — if I made money in the process, great, but it was never the main point.

[![](/files/150px-Marvin_Minsky.jpg)](http://en.wikipedia.org/wiki/Marvin_Minsky)

Because of the current state of market absurdity I witness things that scare me. At one client, they "integrated" a sales system with an activation system for a certain piece of equipment. The logic is straightforward: once a sale is made, the customer's equipment should be activated. Even without using a two-phase commit solution (everyone knows what Atomic Transactions are, right?) there should have been safeguards in the requirements to guarantee exactly this. Obviously there weren't — nobody ever questioned it, not the programmers, not the analysts, and certainly not the managers. Result: there are now several people employed whose only job is to format spreadsheets with errors and make manual corrections. More CRUD screens were built to handle those errors. Was there an automation gain from the project? Sure, but nowhere near what it should have been. And nobody cares. I've seen worse. It saddens me to see how the "bulk" of programmers and the entire chain above them — programmers-turned-analysts, programmers-turned-managers — have such limited knowledge and, as a consequence, produce such poor architectures and solutions.

And I return to the questions people brought me: _"I'm unhappy with what I'm doing"_, _"I don't think I'm living up to my 'potential'"_, _"I want to learn something new to earn more money."_ I have no answers for these because I can't think that way. More than that: I believe these questions are fundamentally wrong. There's no right answer to a wrong question.

I try to spread the culture I encountered when I was a young programmer: learning. The excuses I hear are always the same: _"I don't have time to learn when I need to work to support myself"_, _"I can't read English so I need to take courses, meaning I can only learn one thing at a time"_, _"there's no point in me learning 'X' if I don't know whether I'll use it at work"_, _"I'm stressed enough at work, in my free time I just want to rest."_ And so on. A long list of exactly that: excuses. I think it's part of human nature to not want to leave your comfort zone — and worse, to complain when you become obsolete. _"It's the government's fault"_, _"it's capitalism's fault"_, _"it's my boss's fault."_ More excuses.

[![](/files/turing.jpg)](http://en.wikipedia.org/wiki/Alan_Turing)

When I wrote my book, for instance, I had two motivations: to learn something new and to help others learn along the way. **Learning** and **Teaching** are the two fundamental motivators of every good programmer. I understand that in Brazilian reality, not thinking about money is not an option. I found a balance between the two — it can't be that nobody else can manage. Standing still, sitting on the little you learned years ago and just complaining, complaining, complaining, has never taken anyone anywhere.

If it's worth anything, here are a few personal suggestions:

- The more you learn, the better your solutions will be. Clients can recognize a professional who knows exactly what they're talking about. Everyone can tell when someone is just bluffing.

- The demands that will grow the most have to do with systems integration and analysis of large amounts of data. The only way to handle that is to know dozens of concepts and technologies. Learning a single tool in a course won't help.

- The technology cycle keeps getting shorter. A new version used to take years to arrive. That time has shrunk to a few months. By the time you finish your course, what you learned is already obsolete. Deal with it. Get ahead. Learn as much as possible even before the technology becomes available.

- Jumping between jobs doesn't help, for two reasons: a new project won't necessarily bring new things (the odds it's just another CRUD screen are high). And waiting until you actually need something — on a project — is already too late. You'll be overtaken by others who know what you should have known already. A good programmer's obligation is to know things beforehand, not afterward: once a poor-quality product hits production, the result is bad both for your client and for your reputation.

- Try to innovate within your own project. I'm not encouraging anyone to risk a project by bringing in things so new they might blow up the next day. There's always a better way to do what you're doing without impacting the timeline or the project cost. Learning to be efficient with quality takes a lot of practice. That's part of a programmer's obligation.

- You think you're a good programmer but feel underutilized? Then utilize yourself better: create or contribute in some way to open source projects. That's one of the qualities of open source — it gives you not only the opportunity to use for free what others built, but to learn from a solid foundation and to give back.

- Stop complaining. Complaining creates a negative mindset, irritates others, and leads to no solution. Complaining is just another excuse — noise that hides the real problem. The real problem is this: you're complaining about the work, the project, the boss, but really you'd like to be complaining about yourself. Complaining is just the externalization of the frustration of being who you are and not being able to become more. That's not a physical incapacity — it's just mental laziness.

- Forget translated courses and books. They're always outdated. In the 80s we didn't have certifications and all those similar games. We slept with an algorithms book on the nightstand and woke up to a new language specification over breakfast.

[![](/files/charles-babbage.jpg)](http://en.wikipedia.org/wiki/Charles_Babbage)

Good cooks appreciate fine food on vacation. Good engineers analyze their own car on a road trip. Good artists sketch their new ideas on a restaurant napkin. Good professionals **LOVE** what they do — not just at work. That doesn't mean _bringing work home_. It means appreciating, respecting, and wanting to learn more about your craft. Da Vinci didn't need to take courses. Mozart didn't need to take courses. Courses only help those who are already on track and know exactly what they want to get from the course.

When I buy my iPod I want to know how it's made (did you know it uses a hard drive with perpendicular bit recording, which increases data density?). When a spam filter blocks something I want to know how it works (did you know some of the most efficient ones are based on Bayesian statistical algorithms?). When I install an operating system I need to understand exactly how it works (did you know your new hardware supports DEP protection but it's probably disabled on your Windows? And has anyone stopped to find out what DEP actually is?). When I use someone else's network, I want to make sure nobody is snooping on what I'm doing (have you used an external SSH server to create dynamic tunnels?). When I buy a new TV I want to get the most out of it (has anyone bought a plasma TV and connected an antenna to it? Or worse — connected a DVD player with a composite cable and can't figure out why the quality is so bad?).

And these aren't just bar-conversation curiosities. I read a lot — nearly 100 feeds on the most diverse topics, all aggregated in a reader. More than 100 posts per hour, every day. I don't read all of them. In a day I might read a dozen good pieces. First, it takes experience and knowledge to distinguish junk from useful things. Second, it takes dynamic reading — just scanning and moving on. I can go through 100 news items in 15 minutes, and I guarantee I don't miss anything important.

Sounds like a lot? Of course it isn't. It takes a substantial part of my time, but it's a systematic routine. As natural as brushing your teeth or taking a shower: when you skip it, you probably feel uncomfortable for the rest of the day. Same thing. This is what separates Olympic athletes from weekend warriors: dedication. Everyone who wants to achieve something needs to step out of mediocrity and do things that, to the mediocre, seem like too much, impossible, unattainable.

I have one more argument. When I meet someone with more knowledge or skill in my area than I have, I just think: _he's as human as I am_ — so whatever he did to know more, I can do too. Everything is achievable. There is no ceiling. Because for every ceiling there's always a higher one. It's simply a matter of stopping saying _No_, _more or less_, _maybe_.

[![](/files/podcast_10.jpg)](http://www.twit.tv/KFI)

Start saying _Yes_, and don't look back. If you turn back it will be harder to start again. Every step backward means two steps forward just to get back to where you were.
