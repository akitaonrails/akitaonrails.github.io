---
title: 'Off-Topic: Google App Engine and Cloud Computing'
date: '2008-04-13T01:27:00-03:00'
slug: off-topic-google-app-engine-e-cloud-computing
translationKey: off-topic-google-app-engine-e-cloud-computing
description: "From self-hosting to co-location, VPS, AWS, and Google App Engine: the appeal of elastic on-demand resources and the price of adapting an application to paradigms that make future migration harder."
tags:
- cloud
- software-architecture
- off-topic
draft: false
---

Just like _Web 2.0_, another term thrown around all the time is **Cloud Computing**. A lot of people use it to mean a lot of different things. Another term used as a synonym, without being exactly the same thing, is **Web Services** (not the XML standard). In reality this is old news: it's what we used to call ASPs (Application Service Providers).

Think of services like Basecamp, for managing projects without the company spending on maintenance, or your favorite webmail. These are online services where you pay so you never have to think about infrastructure. A form of service outsourcing.

This week Google caused a small stir by launching its answer to Cloud Computing: [Google App Engine](http://code.google.com/appengine/). TechCrunch published a review [here](http://www.techcrunch.com/2008/04/08/techcrunch-labs-our-experience-building-and-launching-app-on-google-app-engine/). But what is [Cloud Computing](http://en.wikipedia.org/wiki/Cloud_computing)? First things first, let's go over the terms the market uses.

We developers will, at some point, want to put our application into production. That's when the hairiest part of the process arrives: deployment!

There are several options. First, software:

- Buy a commercial application. Commodity cases like Exchange Server: you pick, buy, install, and start using it. Bigger applications sell under licensing schemes, per user or per processor. Some software can be extended and customized, but usually it's you who has to adapt to the software.

- Get an open source solution. Download it from the internet, configure it, and use it, or hire a services company to do that work for you. The obvious advantage is zero license cost. The downside is that running that kind of setup has a cost nobody usually accounts for: [TCO](http://en.wikipedia.org/wiki/Total_cost_of_ownership) is not trivial. How easy the application is to modify varies case by case.

- Build the system in-house. Code the system yourself, tailored to your needs, with your own team or a hired software house. The bespoke model. It tends to cost more, but it may be necessary when no commercial software does what you need. In theory it should be the software that fits the company best; in practice the TCO is usually high and the outcome uncertain. Everything depends on the maturity of the company and of whoever was hired to build it. Your mileage will vary.

- Use an ASP. You 'rent' a market application, like SalesForce.com, without worrying about deployment, installation, or updates. It's less customizable, but the total cost of ownership is usually far lower. In many cases it makes sense: all you need is a stable internet connection. The services model is a trend because today's internet infrastructure allows it. And there's a clear win for the developer: one fix in the central system instantly benefits the whole customer base, with no per-client installs.

As for hardware options:

- Host it yourself. Buy machines, build networks, manage everything inside your own physical perimeter. As the company grows, you buy more machines. It works best for intranets and for companies with a mature IT department. IT is normally treated as a cost, like paying taxes; running everything in-house only makes sense if your core business is those very systems.

- Host it yourself, but understanding that growth isn't linear. Sometimes you need more resources only for a short window, and buying machines all the time just inflates your TCO. That's what 'on-demand' servers are for, like some IBM lines: when you need more power, you call IBM and they unlock more processors on the machine sitting physically at your site. A limited solution.

- Co-location. The machines are yours, but they live on a third party's infrastructure, in a data center outside your company's perimeter. It's a cost-benefit trade: you rarely have the expertise to keep infrastructure as stable as a third party's, but the machines remain your responsibility. It fits companies that have the money for machines but no physical space, or branches that all need to reach the same system. The data center keeps everything running around the clock, with a stable network and 24/7 support.

- _Shared hosting_. You rent a piece of a machine shared with other clients. The entry cost is minimal, but you suffer when another client on the same box demands more resources, plus issues like shared system libraries. It's a can of worms that providers keep trying to fix, but the nature of this kind of package prevents anything bulletproof. Growing in such an environment is limited. It favors freelancers and small companies that need a website online but lack the money for beefier setups.

- _VPS_ (Virtual Private Server). You still share the machine with other clients, but you get the feel of an entire machine of your own, virtual and isolated. A 'shared co-location': the machine is rented in slices, using solutions like Xen or VMware, and it comes out cheaper than co-location. The isolation shields your application from the neighbors' updates. It's the second step for anyone who wants low cost with more flexibility. The problem remains when you need extra slices only for a short period: spinning one up takes time, and you can miss your time-to-market.

## Cloud Computing

Terms settled, on to the trendy one. I don't know if it was first, but the one making the most noise is certainly the [Amazon Web Services](http://www.amazon.com/aws) model: Elastic Compute Cloud (EC2), Simple Storage Service (S3), and SimpleDB.

The main draw is the **elastic** on-demand concept. You pay for what you use, without manually reconfiguring everything at each change. Use more, pay more; scale back down, pay less. It's payment for resource consumption, instead of a fixed monthly fee for fixed resources.

Amazon's products cover three services:

- Storage (Amazon S3). In a traditional model you'd buy or rent a file server. S3 created a different kind of file system, based on the concept of 'buckets'. The advantages are price and stability; the downside is a model that doesn't map directly onto a regular file system. By now there are dozens of libraries in different languages that ease the transition.

- Database (Amazon SimpleDB). Instead of a relational Oracle or MySQL, Amazon offers an unstructured, document-based database. With no fixed schemas, the costly administration over your data domain disappears, and maintenance drops. On the other hand, there are still hardly any frameworks or libraries that migrate a relational (SQL) application to SimpleDB's model trivially. Once again, the advantage may be price.

- VPS (Amazon EC2). Dynamic, elastic VPS instances. If your system demands more resources during a spike in visits and transactions, you spin up more slices dynamically and kill them when you no longer need them. Five slices in the morning, twenty in the afternoon, five again at night. The catch: they won't necessarily be the same five slices. The model guarantees slices, but not which ones. Your application must store its data outside EC2, in S3 or SimpleDB, so another slice can take over without relying on local data. It's Shared-Nothing taken to its ultimate conclusion.

What's the advantage? You get what you need, when you need it. Instead of committing to expensive co-location or VPS plans, you leave the application in Amazon's care and gain dynamism without worrying whether your machines 'can take it'. It's like paying for the gym by the hours you actually attended, instead of a fixed monthly fee. Quit mid-month, and you don't lose the whole fee. It's a trend in the services market.

What's the disadvantage? With Amazon, you have to prepare your application around their limitations and requirements. Especially because having your slice killed is normal: local data is gone if it wasn't persisted elsewhere first. Taken as a premise from day one, that stops being a problem. It's a different paradigm from co-location or classic VPS, where local data is permanent and backups are the host's job.

### Google App Engine

Which brings us to the week's news. In practice, App Engine maps Amazon's services one to one:

- Amazon SimpleDB vs Google BigTable: neither is a relational database; forget the classic RDBMS.

- Amazon S3 vs Google GFS: again, no classic file system like the one on your machine.

- Amazon EC2 vs App Engine: similar, but different, as we'll see.

Google's marketing sold the product as _"your application running inside our infrastructure."_ Everyone knows that Google Search, Reader, Gmail, and Orkut run on a proprietary, highly scalable infrastructure, the one that made Google famous and is now 'open' ([gratis, not libre](http://en.wikipedia.org/wiki/Gratis_versus_libre)) for others to enjoy. Let's look at advantages and disadvantages:

- The downside on both sides is the paradigm break: applications must be born exclusive to one of these environments. Choosing one means locking yourself in, because supporting both costs more development.

- Amazon's advantage is service independence: want just storage? Use S3 alone. The disadvantage is that their services demand more integration knowledge than anyone else's.

- Google's disadvantage is the all-or-nothing proposition: your whole application lives in there, not just pieces. The advantage is the online administration environment, which puts Google a step ahead of Amazon in usability.

Right now Google only supports applications written in Python. It ships with Django pre-available and with APIs that make handling data and storage easier. Certainly great news for the Python community.

That caused some [commotion](http://web.archive.org/web/20090108161617/http://profy.com/2008/04/08/google-jumps-shark-with-app-engine/) among developers of other languages, which is normal. Coming from anyone else, it would have passed unnoticed as "just another hosting provider." Coming from Google, they know massive praise and massive criticism always follow. Praise is democratic, and so is criticism. If they didn't see this coming, someone in Public Relations needs to be fired.

Either way, don't pay attention to yet another round of language wars:

- they're a flash in the pan: only fun right now

- they don't amount to much: if Google anticipated this and has good PR, they walk away unscathed

- Google likes Python: that's public knowledge, and there's nothing wrong with it. Companies decide what they want, when they want, and how they want. The day you have your own company, you'll understand this.

- and Google never said App Engine would be Python-exclusive

In the official [announcement](http://www.google.com/intl/en/press/annc/20080407_app_engine.html), Google presents the service as a "preview release", the famous Beta of every self-respecting Web 2.0 application. Big news :-) The promise is to support other languages in the future. It's not a perfect solution, but like everything coming out of a corporation the size of Google, it has huge potential. And like every Web 2.0 application, there's a free account so you can test-drive the environment before deciding on a plan upgrade. At this Beta stage, though, it isn't open to everyone yet.

## What Does This Represent?

Once App Engine matures and starts supporting more development environments beyond Python, it can become the main threat to Amazon's Web Services: it's a blatant copy of their services, and Amazon is the obvious commercial competitor.

It can also threaten smaller services, like [Joyent Accelerator](http://web.archive.org/web/20081228161600/http://www.joyent.com:80/accelerator), a hosting provider built on the same elastic-resources concept, or the newcomer [Heroku](http://heroku.com/), which at its core is an App Engine for Rails: a bridge over Amazon's services, configured in a simpler way for Ruby on Rails developers. Granted, it's not ready yet and is nowhere near Google's scale.

Neither Google's nor Amazon's services are perfect. Which is an obvious thing to say: no service is. Everything depends on your requirements and on how you want to commit. The rule stays the same: the more commitment, the cheaper in the short term and the pricier in the long run; the less commitment, the pricier now and, maybe, the better later.

In short: want something cheap and flexible? Amazon and Google can help. But if one day you grow and want independence, detaching can be hard, because your application got intimately tied to their services. With a more traditional service, like co-location or VPS, you pay more now, but you stay isolated from third parties and a future migration to other hosts comes cheaper.

If App Engine succeeds, the likely effect is pressure on the hosting market to offer more creative, cheaper, higher-quality services. That's market law: competition benefits us, the consumers. Let them fight it out while we watch. In the short term, for anyone wanting to put an application in the air, it's just one more variable to consider.

What's Google's goal here? I'm not sure it's the same as the hosting companies': making money by outsourcing infrastructure in a commodity market. Google has specialized in turning good products into commodities, which is both good and bad, depending on your point of view. If it's a free service, one of the goals is to help more and more websites appear: potential customers for Google's real core business, AdSense.

Of course I wouldn't host my Twitter-equivalent on a free service. Actually, if your data matters to you, **never** use free services. They're great while they work; when they fail and you take a loss, the problem is uniquely and exclusively yours. It's like driving a car without insurance.

(off-topic within the off-topic: I use Gmail, but every email that lands in my inbox gets automatically forwarded to my paid Apple .Mac account, every .Mac email lands on my machine, and my machine has two redundant backups. Just to illustrate. I like Gmail, but I wouldn't bet even my emails on it.)

## Understanding Google

When analyzing a Google move, never think 'altruism' or any such nonsense. They're a publicly traded company whose main objective is keeping shareholders happy. Again: their business is profit, and charity pays no dividends.

Their core business happens to involve reaching people who get happy hearing stock phrases like _"Don't be evil."_ Great for us, sure, but that also generates a conflict of interests.

(off-topic within the off-topic, no naivety: [not doing evil](http://mashable.com/2008/04/10/orkut-pedophilia/) is too vague, because 'good' and 'evil' are relative concepts. What's good for me can be bad for someone else, and vice versa; good and evil shift with place and time. Nobody will ever say 'do evil', obviously; that wouldn't be very smart. 'Doing good', or at least what the majority currently perceives as 'good', is a very intelligent way to generate positive publicity with consumer opinion. Besides being cheap, that kind of publicity can come with tax exemptions, which for big companies is considerable savings. Brazil's Lei Rouanet is an example: both sides win, but without laws like this there'd be little motivation for a company to 'invest' outside its core business. Bah, what do I know. And of course, I like Google too; so far it's in my interest.)

To understand it better, read [this](http://web.archive.org/web/20081221135058/http://www.wired.com:80/wired/archive/11.01/google_pr.html). An interesting part:

> "Evil," says Google CEO Eric Schmidt, "is what Sergey says is evil."

Wired: "moral compromise is just the cost of doing big business."

App Engine is one more channel for AdSense, just like Android and Gmail. One reason a company like Mozilla exists is the revenue line from Google for keeping Google search as the default in its toolbar. Apple also gets paid to have Google's search field in Safari. It doesn't quite count as a 'bundle deal', since both browsers are free, but the cost is indirect: AdSense advertisers want to appear in most browsers. Yahoo! also announced a [test to show AdSense ads](http://web.archive.org/web/20080516124707/http://afp.google.com:80/article/ALeqM5jEgHRf-Zi_z785TetNNwtg2V5a9w) on its own search results, which could increase Google's market share even further.

That means indirect visits, which turn into the billions of revenue that keep Google's shareholders happy. And geek users, who contribute the free word-of-mouth advertising, obviously love the idea that supporting Google or Firefox means _'Microsoft losing'_. I may be being pessimistic, but it happened with Rockefeller, a great philanthropist, and his Standard Oil. It happened with Bill Gates, another great philanthropist, and his Microsoft. It can happen with Google. To get an idea, read [this article](http://mashable.com/2008/04/10/orkut-pedophilia/) and an interesting excerpt:

> Blogger and Mashable reader Constantine von Hoffman at Collateral Damage probably put it best when he said: "At this point, it would take a mashup of Wittgenstein, Quantum mechanics and LSD to make sense of Google's various explanations for what it will and won't censor and why."

Anyway, Google App Engine by itself represents no revolution yet: it's just one more player in the hosting market. Cloud Computing is one more marketing term for a solution derived from others that already existed: finer price granularity for services. Just as it did with Android, Google is commoditizing one more market segment.

The same old rule still applies: [cost-benefit analysis](http://en.wikipedia.org/wiki/Cost-benefit_analysis). And that kind of analysis doesn't come as a recipe, nor with the click of a button.
