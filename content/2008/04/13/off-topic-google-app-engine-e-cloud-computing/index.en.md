---
title: 'Off-Topic: Google App Engine and Cloud Computing'
date: '2008-04-13T01:27:00-03:00'
slug: off-topic-google-app-engine-e-cloud-computing
tags:
- cloud-computing
- google
draft: false
translationKey: google-app-engine-cloud-computing
---

Just like _Web 2.0_, another term thrown around constantly is **Cloud Computing**. A lot of people use it to mean a lot of different things. Another term used as a synonym — but not exactly the same thing — is **Web Services** (not the XML standard), which in reality is nothing new: it's what we used to call ASPs (Application Service Providers). Examples include services like Basecamp for project management, where companies don't need to worry about maintenance, or your favorite Webmail. These are online services where you pay so you don't have to worry about infrastructure. It's a form of service outsourcing.

This week Google caused a small stir by launching its answer to Cloud Computing: [Google App Engine](http://code.google.com/appengine/). You can see a TechCrunch review [here](http://www.techcrunch.com/2008/04/08/techcrunch-labs-our-experience-building-and-launching-app-on-google-app-engine/). But what is [Cloud Computing](http://en.wikipedia.org/wiki/Cloud_computing)? Before anything else, let's explain the most commonly used terms in the market:


We, as developers, will at some point want to put our application into production. That's when the most complicated part of the process arrives: Deployment!

There are several options. First, let's look at software:

- Buy a commercial application. Commodity cases like Exchange Server. You need a software package for your company, there are several on the market. You choose, buy, install, and start using it. You can buy an application to use however you want, or larger applications sold under licensing schemes, for example, per-user or per-processor licenses. Some software can be extended and customized, but normally you have to adapt to the software and not the other way around.

- Acquire an open source solution. Download it yourself from the internet, configure, and use it — or hire a services company to do that work for you. The advantage is obviously no licensing costs, the disadvantage is that managing that kind of configuration can represent a cost that normally isn't accounted for. The [TCO](http://en.wikipedia.org/wiki/Total_cost_of_ownership) is not trivial, and the application may or may not be easy to modify. It varies case by case.

- Build the system in-house. That is, code the system yourself, customized to your needs. It's the tailored approach, where you have a development team or hire a software house to build the system as you need it. It tends to be more expensive, but on the other hand it may be necessary if no commercial software exists to do what you need. Theoretically it should be the type of software that best fits your company. In practice, of course, it's not quite like that. TCO tends to be high, the software tends not to be that good, and you as a company need to change quite a bit to accommodate any type of system (whether commercial, open source, or in-house). Everything depends on the maturity of the company itself and of the third party hired to develop it. Your mileage will vary considerably and results are uncertain.

- Use an ASP, meaning you 'rent' a market application under a licensing plan, but don't need to worry about deployment, installation, keeping it updated, etc. Examples include applications like SalesForce.com. It's a less customizable solution, but it typically has a much lower cost when you factor in total cost of ownership (TCO). In many cases it makes sense. You just need a stable internet connection. It might not be ideal, but it keeps your costs low. The services model is a trend simply because the overall internet infrastructure today makes it possible. As a developer, you build software that can serve many different companies without the problem of having to install and maintain each one separately: a fix to the central system immediately benefits your entire customer base.

As for hardware options:

- Host it yourself, buying machines, building networks, managing everything on-site — that is, physically within your own premises. As your company grows, you buy more machines. This is better suited for intranet applications that only concern your company and won't grow to scales that are hard to manage. It's best for companies that have a mature IT department to handle everything. These days every company has a minimal IT team, but not all do. IT is normally not the company's core business, it's considered a cost, like paying taxes. It makes sense to handle everything yourself if your core business is those very systems.

- Host it yourself but understanding that growth isn't linear. You might need more resources only during certain periods and not others — buying machines might only be necessary for a short period, not continuously. Constantly buying new machines only increases your TCO. In that case you can "buy" machines on-demand, like some IBM server lines, the so-called 'on-demand' model. Every time you need more power, you call IBM and ask them to unlock more processors on the machine that's physically at your location. It's a limited solution.

- Do co-location, where you own the machines but use third-party infrastructure, in an external data center outside your company's physical premises. It's a cost-benefit calculation, since you typically don't have the expertise to maintain an infrastructure as stable and robust as a third party. But the machines are yours and it's your responsibility to buy more if needed. In some cases companies have the resources to buy more machines but end up running out of physical space. Or the company has branches and all of them need to access the same system. It's easier when your machines are in a data center responsible for keeping them running 24/7, with a stable and fast network and 24/7 support. Many companies have local IT teams and systems outside their physical premises.

- Use _Shared Hosting_, meaning you use not only a third party's infrastructure but rent a 'piece' of the same machine, shared with that third party's other clients. Various plans can help you get started at minimal infrastructure cost, but with the disadvantage of being negatively affected when another client on the same machine demands more resources and your application hits bottlenecks, plus other issues like shared system libraries. It's a free-for-all where providers try to find solutions but the nature of this type of package prevents something truly bulletproof. Growing in such an environment is typically limited. This typically favors freelancer programmers or small companies that need to put their website online but don't have the resources for more robust configurations.

- Use _VPS_, or Virtual Private Servers — still sharing the same machine with other clients of that third party, but with the 'feeling' of having an entire machine to yourself, virtually, isolated from others. It's like a "Shared Co-Location", where the machine isn't yours, you share it, but it still feels like you have a machine all to yourself. The advantage is that this isolation frees you from things like updates on a shared hosting machine threatening your application's stability. It's typically cheaper than co-location because you're not buying a machine but rather renting a slice of one that uses solutions like Xen or VMware. It's the second step for companies that want to keep costs low but need more flexibility. Even so it's still a problem, as with co-location, when you only need more slices for a short period. Spinning up a new slice takes time, and in that case you might lose your time-to-market window.

## Cloud Computing

Now that we understand the terms in use, let's look at the trendy term. I don't know if it was the first, but the one that's made the most noise is certainly the model of [Amazon Web Services](http://www.amazon.com/aws) products: Elastic Cloud Computing (EC2), Simple Storage Service (S3), and SimpleDB.

In all of them, the main appeal is the concept of **elastic** on-demand. That is, you pay for what you use, but you don't have to manually reconfigure everything every time you need more. If you use more you pay more; if you go back to using less, you 'elastically' pay less. It's payment for resource consumption, not a fixed monthly fee for fixed resources.

These Amazon products cover the following services:

- Storage (Amazon S3). In a traditional model you'd buy or rent a file server. Online storage has existed for a while, but S3 creates a different model from a normal file system, based on the concept of 'buckets'. Amazon's advantages are price and stability. The disadvantage is that it's based on a different model from a traditional file system that isn't immediately mappable. Today there are dozens of libraries in different languages that ease the transition.

- Database (Amazon SimpleDB). Instead of Oracle, MySQL, or other relational databases, Amazon introduced a document-based, unstructured database. The main characteristic is the absence of fixed schemas and, therefore, the absence of costly administration overhead over your data domain, reducing maintenance. On the other hand it introduces adoption barriers since there aren't yet many models, frameworks, or libraries that allow trivially migrating an application built for a relational model (using SQL) to SimpleDB's model. Again, the advantage may be price.

- Virtual Private Server or VPS (Amazon EC2). It's like using dynamic, or elastic, VPS instances. If for some reason your system needs more resources (if there's a spike in visits and transactions on your website), you can 'easily' enable more slices dynamically and take them down when you no longer need them. You pay for the resources used, not for the number of slices you have. They're dynamic: you can have 5 slices in the morning, 20 in the afternoon, and go back to 5 at night. The catch is they won't necessarily be the same 5 slices. It's a different model that guarantees slices but not which ones. Your application needs to store data outside EC2 (either in S3 or SimpleDB) so that another slice can take over without depending on local data. It's Shared-Nothing taken to its ultimate conclusion.

What's the advantage? You can have what you need, when you need it. Instead of committing to expensive co-location or VPS plans, you can put your application in Amazon's care and have more dynamism in your business without worrying whether your machines "can handle it." It's like being able to pay for a gym by the actual hours you attended, instead of a fixed monthly fee. If you stop going mid-month, you don't lose the entire month's membership. It's a trend in the services market.

What's the disadvantage? With Amazon, you need to prepare your application according to their limitations and requirements. Especially considering that it's normal for your slice to be taken down. Data local to that slice is lost if it wasn't persisted outside it beforehand. This isn't a problem if it's taken as a premise from the start, but it's a different paradigm from what we're used to with co-location or classic VPS, where local data is always permanent and it's the hosting's responsibility to back up for any eventual problems.

### Google App Engine

Here's the week's news: Google App Engine. In practice, it's a solution that maps one-to-one with Amazon's services.

- Amazon SimpleDB vs Google BigTable — neither is a relational database, so in neither one can you think of your data as a classic RDBMS.

- Amazon S3 vs Google GFS — again, not a classic FS like you have on your machine.

- Amazon EC2 vs App Engine — similar but different, as we'll see.

Google's advantage is that they marketed this product as: _"Your application running inside our infrastructure"_ — meaning, everyone knows that Google's famous products like the search engine itself, Google Reader, Gmail, Orkut, etc., all run on a proprietary, highly scalable infrastructure that made Google famous, and now it's 'open' ([free but not libre](http://en.wikipedia.org/wiki/Gratis_versus_libre)) for others to benefit from. Let's look at the advantages and disadvantages:

- The disadvantage of both is that they break paradigms and therefore require applications built exclusively for one of these environments. That is, choosing either one means being locked in to it, since supporting both could represent higher development costs.

- Amazon's advantage is that its services are independent — if you only want storage, just use S3 alone. Amazon's disadvantage is that its services require more integration knowledge than anything else.

- Google's disadvantage is that it's an all-or-nothing proposition: your entire application lives there, not just pieces of it. The advantage is that Google is providing an online environment to manage your application that puts them a step ahead of Amazon in terms of usability.

At this point Google only supports applications written in Python. It comes pre-packaged with Django and with APIs that ease handling of data and storage resources. Certainly great news for the Python community.

This generated some [commotion](http://www.profy.com/2008/04/08/google-jumps-shark-with-app-engine/) among developers in other languages, but that's normal. If it weren't Google, it would pass unnoticed as "just another hosting provider." Being Google, they obviously know they'll always receive massive praise and massive criticism. So nothing beyond what was expected. Praising is democratic, so is criticizing. If they didn't anticipate this, someone in their Public Relations department needs to be fired.

Either way, don't pay too much attention to these language wars:

- they're a flash in the pan: it's just fun right now

- they don't amount to much: if Google indeed anticipated this and has good PR, they'll emerge unscathed

- Google likes Python: this is public knowledge and there's nothing wrong with it. They're a company and companies decide what they want, when they want, and how they want. When you have your own companies, you'll understand this.

- in reality, Google never said App Engine is exclusive to Python, as their [press release](http://www.google.com/intl/en/press/annc/20080407_app_engine.html) promises support for other languages in the future and — like any self-respecting Web 2.0 application — this is a "Beta" version. Big news :-) It's not a perfect solution but, like everything from a massive corporation like Google, it has great potential. Again, like a Web 2.0 application, it also has a free account so you can test-drive the environment before deciding on a plan upgrade. At this Beta stage, however, it's not yet open to everyone.

## What Does This Represent?

In time, when App Engine matures and starts supporting more development environments beyond Python, it will become the main threat to Amazon's Web Services, since it's a blatant copy of their services. Obviously its direct commercial competitor is Amazon.

It could also become a threat to smaller services like Joyent ([Joyent Accelerator](http://www.joyent.com/accelerator)) which is a hosting service implementing the same elastic resources concept, or the newcomer [Heroku](http://heroku.com/) which, at its core, is an App Engine for Rails — a bridge between Amazon's services configured in a simpler way for Ruby on Rails developers. Of course it's still not ready and nothing close to Google's scale.

Neither Google's nor Amazon's services are perfect. But I said something obvious: no service is perfect. Everything depends on your requirements and how you want to commit. The same rule applies: the more you commit, the cheaper it is in the short term but more expensive long term. The less you want to commit, the more expensive in the short term but possibly better in the future.

In other words, if you want something cheap but flexible, Amazon and Google can help. But if you grow someday and want independence, it may be harder to detach since your application became tightly coupled to their services. If you use a more traditional service like co-location or VPS, it may be more expensive now but in the future you remain isolated from third parties and it might cost less to migrate to other hosts offering better prices/quality.

What may happen if Google App Engine succeeds is create more pressure on the hosting market to offer more creative, cheaper, higher-quality services. In other words, it's market law, where competition can generate more benefits for us, the consumers. Let them fight it out while we watch. In the short term, for anyone wanting to deploy an application, it's just one more variable to consider.

What's Google's objective here? I'm not sure if the goal is the same as hosting companies — making money by outsourcing their infrastructure in a commodity market (Google has specialized in turning good products into commodities, which is good and bad simultaneously, depending on your point of view). Or if it's a free service, one objective is to make more and more websites appear: potential customers for Google's real core business: AdSense, of course. Now, obviously I wouldn't expect to host my Twitter-equivalent on a free service. And actually, if your data matters to you, **never** use free services. They're great while they work, but when they don't and you take a loss, the problem is entirely yours. It's like driving without insurance.

(off-topic within off-topic: I use Gmail, but every email that hits my inbox has an automatic forward to my paid Apple .Mac account, and every .Mac email lands on my machine, and my machine has two redundant backups. Just to illustrate. I like Gmail, but I wouldn't bet even my emails on it.)

## Understanding Google

Whenever you analyze a Google move, you should never think in terms of 'altruism' or any such nonsense. They're a publicly traded company whose main objective is to keep their shareholders happy. Again: it's a profitable company, not a charity.

By coincidence their core business involves reaching people who are happy hearing phrases like _"Don't be evil"_, which is good for us, of course, but doesn't mean it isn't a conflict of interest generator.

(off-topic within off-topic — let's not be naive: [not doing evil](http://mashable.com/2008/04/10/orkut-pedophilia/) is very vague because 'good' and 'evil' are relative concepts. What's good for me may be bad for someone else and vice versa. Good and Evil change across place and time. Nobody ever says 'do evil', obviously — that wouldn't be very smart. 'Doing good', or at least what is currently perceived as 'good' by most people, is a very intelligent way of generating positive publicity with consumer opinion. It's also cheap advertising that may come with tax exemptions, which for large companies represents considerable savings. Brazil's Lei Rouanet is an example of this. Both sides win, but without laws like this there wouldn't be much motivation for a company to 'invest' outside its core business in the same way. What do I know. And, of course, I like Google too — so far it's in my interest.)

Just to understand it better, read [this](http://www.wired.com/wired/archive/11.01/google_pr.html). An interesting part:

> "Evil," says Google CEO Eric Schmidt, "is what Sergey says is evil."

Wired: _"Moral commitment is just a cost of doing great business."_

App Engine is one more channel for AdSense, like Android, Gmail, etc. One reason a company like Mozilla exists is the revenue line that comes from Google so Mozilla keeps Google search as the default in its toolbar. Apple also gets paid to have Google's search field in Safari. It's not a 'bundle deal' because both browsers are 'free', but the cost is indirect because it's in advertisers' interest on AdSense to appear in as many browsers as possible. Yahoo! is also [joining](http://afp.google.com/article/ALeqM5jEgHRf-Zi_z785TetNNwtg2V5a9w) Google's AdSense market, increasing its market share even further.

That translates to indirect visits which in turn generates the billions in revenue for Google, keeping shareholders happy. And geek users, who contribute to free word-of-mouth advertising, obviously enjoy the thought that supporting Google or Firefox means _'Microsoft losing'_. I might be being pessimistic, but it happened with Rockefeller, a great philanthropist and his Standard Oil. It happened with Bill Gates, another great philanthropist and his Microsoft. There's a possibility of it happening with Google. For a sense of scale, read [this article](http://mashable.com/2008/04/10/orkut-pedophilia/) and this interesting excerpt:

> Blogger and Mashable reader Constantine von Hoffman at Collateral Damage probably put it best when he said: "At this point, it would take a mashup of Wittgenstein, Quantum mechanics and LSD to make sense of Google's various explanations for what it will and won't censor and why."

In short, Google App Engine on its own doesn't represent any revolution or anything particularly large right now — it's just one more player in the hosting market. Cloud Computing is just one more marketing term for a solution derived from others that already existed (price granularity of services). Like Android, Google is commoditizing yet another market segment.

The always-applicable rule still holds: [cost-benefit analysis](http://en.wikipedia.org/wiki/Cost-benefit_analysis). And that kind of analysis doesn't come as a recipe or with the click of a button.
