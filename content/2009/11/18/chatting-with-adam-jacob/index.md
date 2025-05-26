---
title: Chatting with Adam Jacob
date: '2009-11-18T11:46:00-02:00'
slug: chatting-with-adam-jacob
tags:
- interview
- english
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/Opscode_logo_final_full_aspect_medium_original.png)

Configuration Management is a tricky subject. For non-starters, when you’re a developer and you have few boxes to take care of, you can usually get away with just managing them manually. People are probably just used to pop in a CD, double-click the “install” program and click “next”, “next” until the end, then you manually log in to backup (when you remember it), and sometimes you do apply some security updates when you remember about them.

But then you have more than a dozen machines, things start to get uglier, you end up making more mistakes, forgetting important steps, and all of a sudden managing machines become a nightmare. You end up being woken up in the middle of the night because you forgot to install some crucial component, and so on and so forth.

The same way you need testing, continuous integration tools when you’re a developer, you also need automated, reliable and flexible tools for the system administrator role. That’s where tools such as **Chef** kick in to help.

From [Opscode Inc.](http://opscode.com/), we have [Adam Jacob](http://twitter.com/adamhjk) (CTO) and [Jesse Robbins](http://twitter.com/jesserobbins) (CEO) to talk about the new contender in the automated system administration field, [Chef](http://www.opscode.com/chef/), already in use by many companies which are striving with the cutting edge to maintain their datacenters.


 **AkitaOnRails:** To kick start this interview, it would be great to have more background info about you guys. So, how did you end up in the configuration management space?

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/adam_jacob_original_original.png)

**Adam:** I’ve been a systems administrator for 13 years, and for a majority of that time I was working for companies who did a lot of mergers and acquisition work. Every couple of months we would acquire a new company, and it was my job to help figure out how to absorb those companies into the whole. I got really good at looking at an application I had nothing to do with creating, and figuring out what needed to be done to make it scale (or at least make it run.)

One thing we couldn’t do was tell the people who had built the applications that they needed to be radically altered (in many cases, they weren’t even around anymore.) What that meant in practice was we needed to have a very flexible, modular underlying architecture – everything we did had to be in service of the application, not the other way around. By necessity that meant becoming a tools developer – if we didn’t have the tools we needed, we would never be able to do the job in front of us.

Eventually I co-founded a consulting firm called HJK Solutions. We built fully automated infrastructure for startups – everything from OS installation to application deployment, all fully automated (including Identity Management, Monitoring and Trending, etc.) Over the course of the next two years we built infrastructure for 12 different startups, whose products ranged from electrical car fleet management to online dating.

So I come to configuration management through the trenches – as a line-level systems administrator trying to make my life easier, as a consultant helping others to reap the benefits, and now as a tool builder trying to move the state of the art forward.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/Jesse_Robbins_original_original.png)

**Jesse:** Jesse Robbins is CEO of Opscode (makers of Chef) and a recognized expert in Infrastructure, Web Operations, and Emergency Management. He serves as co-chair of the Velocity Web Performance & Operations Conference and contributes to the O’Reilly Radar. Prior to co-founding Opscode, he worked at Amazon.com with a title of “Master of Disaster” where he was responsible for Website Availability for every property bearing the Amazon brand. Jesse is a volunteer Firefighter/EMT and Emergency Manager, and led a task force deployed in Operation Hurricane Katrina. His experiences in the fire service profoundly influence his efforts in technology, and he strives to distill his knowledge from these two worlds and apply it in service of both.

**AkitaOnRails:** What’s the story behind Opscode, what’s its mission, and what’s the story for Chef’s creation?

**Opscode:** The story behind Opscode really starts when we met Jesse. He had written an article for O’Reilly Radar about [Operations being the new secret sauce](http://radar.oreilly.com/2007/10/operations-is-a-competitive-ad.html) for startups. He and I met for coffee, became friends, and stayed in touch. Jesse understands operations culture at a visceral level, and he’s very well connected to a huge community of like-minded people that I didn’t even know existed.

As our consulting company grew, we reached a crossroads – we clearly had a nice business going, and it wasn’t difficult for us to find more work. What was difficult was finding people who had the skills to actually deploy a new infrastructure, and to adapt the stack we had developed for a new application. We couldn’t avoid the fact that there was a couple of weeks of very high-touch work that was required to get the entire infrastructure up and running for a new client.

We tried to recruit Jesse during this period, since he was one of those rare people who could do that initial high-touch engagement. He turned us down – primarily because he saw what we did: we could build a consulting company that was huge, but it would still be down to us in the trenches every day. Unless we could get over that hump, there were probably less stressful ways to make a living. :)

So we started looking at what was stopping us from being able to get that initial part of the engagement done as quickly as possible. What was stopping us from literally having a customer fill out a questionnaire, and letting that data drive 95% of the decisions about the infrastructure?

It turned out the answer was, in a word, “everything”. The entire stack of open source tools we were using had been built in a different era, and they saw the world through a very different lens. We needed everything to have an API, we needed everything to be more open with it’s data, and we needed everything to be flexible enough to handle the next evolution of application architectures (whatever that may be.)

Once we had that revelation, the next step was figuring out what a ‘new stack’ would really look like. If we could start from scratch, what would we take with us, and what would we leave behind? Amazon had done such a great job showing us what an API over the bootstrapping process could look like, and the kind of benefits that could be had from the approach. So assuming something like that existed for bootstrapping, what about the next layer of the stack (configuration)?

We started experimenting with Chef during this period of questioning. We started working on Chef with the goal of putting ourselves out of business – making the barrier to entry to having a fully automated infrastructure so low that any developer or systems administrator could just do it. We built a prototype, showed it to Jesse, and he agreed to come on board.

Opscode was born then, and our mission came out of those experiments: we are bringing Infrastructure Automation to the Masses. We want to tear down the barriers to entry that stop people from having really great, repeatable, automated infrastructure. Our role is to bring developers and systems administrators the best tools possible, so that they can build the systems they have always wanted.

We raised 2.5 million from DFJ in January of 2009 on that vision, and have been at it ever since.

**AkitaOnRails:** I’d like to say that only amateur sysadmins do everything manually, but I think most small to medium corporations at least still do everything manually or with random scripts spread all over the place. The notion of “configuration management” is still new to a lot of people. Could you briefly explain what it is, and why it is important?

**Opscode:** To me, “Configuration Management”, at it’s core, is all the stuff you have to do to take a system from “running an operating system” to “doing it’s job”. When a systems administrator configures a system by hand, and posts her notes on a Wiki, she’s practicing the most primitive form of Configuration Management.

Now, having those notes is better than nothing – when she needs to do that task again, she can at least go back and read them to remember what she did last time. She still has to do it over again, though – and the repetition gets tiresome. So she starts writing scripts that encapsulate that knowledge in code, so that now she only has to run a series of smaller commands.

Time passes, though, and entropy sets in. The systems begin to drift from where they were when the systems administrator wrote the scripts. Next thing you know, the scripts don’t run anymore, or if they did, the configuration they build is wrong. Our intrepid admin then starts editing the scripts, or making new ones, to deal with the system when it’s in this new state. This is the stage we call “tool sprawl” – you have a tool for each different phase of a systems observable life-cycle.

Modern configuration management tools solve this problem by providing a framework for describing the final state a system should be in, rather than the discrete steps we should take to get there at any given time. Rather than writing a script that lists the commands to install Apache, write the configuration file, and start the service, you would describe that “apache should be installed”, the configuration file “should look like this”, and the service “should be running”.

When the configuration management system runs it looks at each of these descriptions individually, and makes sure that they are in the proper state. We no longer care what the initial state of the system is – the configuration management system will only take action at each step in the process if the system is not in the state you described. If you run it again, and nothing has changed, the system takes no action. (Configuration management geeks call this property [idempotence](http://en.wikipedia.org/wiki/Idempotence))

This means that you can describe your systems once in code, and as they change over time, simply update that code to reflect what you want the state of those systems to be. The impact of this model on the daily life a systems administrator cannot be overstated – it makes everything easier.

It also has huge impacts outside the systems administrators world. You now have a living document that describes how all your servers are configured – you can share it, you can put it in revision control, you can print it out for an auditor. Business processes that previously required manual intervention frequently can be boiled down to discrete changes. The more you work in this way, the more the impacts spread throughout the organization.

**AkitaOnRails:** Even though the Ruby community probably compares Chef to Puppet, I think one of the most widely used system is CFEngine2. How does Chef compare with CFEngine2?

**Opscode:** Cfengine 2 is where almost everyone in the configuration management world cut their teeth. Mark Burgess is responsible for the academic papers that outlined the idea that each part of the system should be idempotent, and his work in studying how real-world systems can be managed at scale has done more to impact the evolution of configuration management than any other individual.

In addition to the idea of idempotent resources, Burgess introduced the larger concept of “convergence”. The basic idea here is that if you have the description of how every finite resource should be configured, given enough time, those resources will bring the system into a compliant state. The order in which the resources run fundamentally does not matter – eventually, they will all wind up in the right place.

While this model works at a fundamental level, it has some pretty dramatic inefficiencies. Cfengine applies resources based on their type – all the files are managed at once, then all the services, then all the packages. You can control the order they are run with the ‘actionsequence’, but each system gets only one order. So if you need to have a file copied, a package installed, and a service restarted, it’s easy enough to model. When you start getting into more complex configurations, however, it becomes more and more difficult to get an actionsequence assembled that allows you to configure your entire system in a single run.

This is not a bug in Cfengine – it’s by design. Convergence is the answer – it’s okay that it has to run more than once, it will get there eventually. If you are thinking too much about the order things should happen in, you’re probably not thinking about idempotent descriptions.

In my experience, though, this was frustrating at scale. It meant that the amount of time it took to configure a system increased as the configuration became more complicated, and your ability to model complicated interactions in the system became increasingly opaque.

For the era in which it was written, this problem mattered a lot less. If it takes you 6 to 8 weeks to get a server even ordered, then another week to get it racked, stacked, and the OS installed, the fact that Cfengine needs to run 3 times to configure it doesn’t matter very much. (You have lots of bigger problems!) In a world where many of us can go from bare-metal to running operating system in 5 minutes, either via our own install systems or an API call to AWS, it starts to matter a whole lot.

Chef takes a different approach. We start with the idea of an idempotent “resource” – a package, a service, etc. We add the idea of “actions” – these are all the different states you might want to request a resource to be in. Then you put these resources into “recipes”, which are evaluated in the order they are written. You can then have recipes rely on other recipes having completed before they are run, giving you the ability to say “make sure Apache is installed before you configure my Web Application”.

The goal is that, with Chef, you can always bring the system into the proper state with a single Chef run. It sees convergence as a response to a bug – a system that is 1/2 configured is, in fact, broken. If the cause of the bug is environmental – a network service is not available, for example – then running Chef again will likely fix things. If the issue is that you haven’t specified the order that you want resources to be configured in, though, then it’s a bug in your recipes. If you can’t write a recipe to configure your system in a single Chef run, it’s a bug in Chef.

This also has side-effects for reasoning about the system at scale. Given the same configuration and attributes, Chef will always behave the same way, on every system. As you add more and more things to the system, it’s still easy to reason about when, and how, they will be configured.

Interestingly enough, Cfengine 3 implements a system that is very similar to Chef. Rather than a single global actionsequence, it uses a ‘bundlesequence’, where bundles are roughly analogous to Chef’s concept of a recipe.

Another major difference is that Chef allows you to ‘look up’ at your entire infrastructure when configuring a system. This ability comes in handy when you want to do things like configure a monitoring system, or a load balancer. You can ask Chef questions like “what are all the servers running my application in production”, and use the response to configure your system. (You can see an example of this on [our blog](http://www.opscode.com/blog/2009/10/07/preview-chef-0-8-and-the-opscode-platform/))

From a systems architecture point of view, Chef and Cfengine are actually fairly similar. They both push the majority of the hard work of configuring a system out to the systems themselves. This is highly advantageous at scale – the Chef and Cfengine servers are really glorified file transfer systems.

We differ pretty deeply on our approach to what a language for configuration management should look like, but I’ll talk more about that in a later question.

Cfengine is at work in some of the largest data centers in the industry, and it fundamentally altered the landscape of systems management. While it’s not the tool I want anymore, you can’t understate the impact it’s had on the design of every configuration management tool that came after it – including Chef.

**AkitaOnRails:** Chef has a lot of components to it. Could you briefly describe all the main components that work together? The client side, the server side, cookbooks?

**Opscode:** Sure! The most important part of Chef is the cookbooks – they are where you actually describe your configuration. They collect recipes, and all the assets needed for the recipe to run (files, templates, etc.). [Cookbooks](http://cookbooks.opscode.com) are very often share-able, and lots of cookbooks already exist.

Chef can run your cookbooks in two modes – a client/server mode (chef-client), or a stand-alone mode (chef-solo). When you run chef-solo, you pass a URL to a tarball full of the cookbooks you want to have run. There is no more infrastructure than that – put your tarballs someplace you can download them, and go nuts.

In client/server mode, each Chef client is configured to talk to a Chef Server. The Server stores information about each client (a whole lot of it – things like IP addresses, loaded kernel modules, and more), and distributes the cookbooks they need to configure themselves. It also provides a REST API and an interactive Web UI, so you can easily alter the configuration of your systems centrally. Finally, all the data the server collects is indexed and searchable – you can then use this in your recipes to configure services that require complex, dynamic configuration. (Some examples would be dynamically discovering a master MySQL server, or finding all the memcached servers in a cluster)

**AkitaOnRails:** What would you say about Chef’s maturity? CFEngine has more than a decade of usage, which is difficult to beat. Would you say that it’s “mature enough”? Meaning, it’s already in production in companies of many sizes, its APIs don’t change too much and my cookbooks will probably work if I upgrade to newer version of Chef?

**Opscode:** Chef is a little over a year old – it was first released to the public on January 15th, 2009. Since then, 42 different developers have committed to the [project](https://www.ohloh.net/p/opscode-chef/factoids/2025809), around 5 of whom work for Opscode. It’s been in production use in the Engine Yard Cloud from the day it was released. Since then, it’s seen adoption by companies and universities of all different sizes, from small startups to huge enterprises with very heavy compliance requirements.

So it’s definitely “mature enough” for real world use – lots of people are using it, and relying on it, every day. Balancing that knowledge with the reality that the project is fast moving and evolving is important, and we try and do it in a number of ways:

1. The recipe syntax is considered basically “complete”. If we do make changes, they are backwards compatible to previous Chef releases. Short of something truly amazing coming along that radically alters the shape of the universe, this will remain true.
2. We test a lot. Chef has over 2000 unit tests, and functional tests that cover the entirety of the REST API, and much of the individual resources (we’re aiming for 100% feature test coverage.) There are more lines of code testing chef than there are lines of code in Chef proper.
3. If we do break backwards compatibility, we try and make it happen only when we bump the minor revision. If you have an 0.7.x version of Chef installed, it should always work with other versions of Chef in the same release cycle.

Most of the work in Chef currently is around adding more functionality, not in changing the way existing functionality works. It’s safe to use Chef today – in the future, you’ll just keep getting more good sauce to add to the mix, rather than having to deeply re-factor the way you do things.

Finally, the Chef Community is truly epically great – we have lots of people who are spending significant amounts of their time with Chef. Even if they aren’t contributing code, they are answering questions, they are writing documentation, they are hanging out on IRC and offering you cupcakes. It’s a group of people that are focused on solving real world problems, and helping each other to do the same. It’s by far what I’m proudest of, and I think it has a significant impact on whether Chef is ready for prime time. The bench is really, really deep.

**AkitaOnRails:** Chef uses Ruby directly, which some would say it’s both a blessing and a curse. It’s probably perfect for Rubists, but I feel that most sysadmins are used to Bash, Python and are not very flexible on change. Why did you choose to use Ruby instead of a simpler language?

**Opscode:** The answer to the question of why we use Ruby directly for the configuration language comes in two parts: why we extended a 3GL rather than build a declarative DSL or a complete modeling language, and why we chose Ruby as that 3GL.

First, why we extended a 3GL. Tools like Cfengine and Puppet build a declarative DSL for configuration management – a custom language, which provides a model within which systems administrators or software developers can work to automate their system. Other tools like Elastra’s EDML and ECML, OpsWare’s DCML, or Bcfg2 give you an XML schema to describe how the system should behave.

The issue with these approaches is that, by definition, they must build an abstraction for every task the end-user may want to perform: an impossible feat. The level of complexity inherent in automation, coupled with the inability to break out to 3GL language constructs when necessary, result in a system that can only target a subset of the total complexity, rather than enable users to find innovative solutions to their specific problems. By leveraging Ruby, adding support for other use cases is a matter of adding new sets of base classes while maintaining consistency and approachability in their interface design, because the full scope of the language is available.

Our goal with Chef was to keep the simplicity that comes from having the focus be on idempotent resource declaration, while giving you the flexibility of a full 3GL. In practical terms, anything you can do with Ruby you can do with Chef – and since Ruby is a 3GL, that amounts to essentially anything.

Larry Wall, the creator of Perl, has a quote that I love:

> “For most people the perceived usefulness of a computer language is inversely proportional to the number of theoretical axes the language intends to grind.”

Since we wanted Chef to have the maximum amount of usefulness, we have actively tried to remove as many theoretical axes as possible – a belief that we can imagine the total breadth of the problem space being one of them. There is more than one way to do it with Chef, and the only valid criteria for rating the success of your automation project is whether it solves your problems in a reliable way.

In practice, you need to know very little Ruby to use Chef. Here is an example of installing the program “screen”:

* * *
ruby

package “screen” do   
 action :install  
end  
-

The same thing in Puppet:

* * *

package { “screen”:   
 ensure =\> present   
}  
-

And in Cfengine 2:

* * *

packages:  
 screen action=install  
-

While all of these systems require learning the syntax, at a base level, there isn’t much difference between them in terms of raw learning required. The difference is that when you hit a limitation in Chef, you have the ability to innovate easily, and when you hit those same limitations in other tools, you do not.

We chose Ruby because of it’s fairly unique ability to create new syntax easily. Tools like Rspec are fine examples of ways you can manipulate Ruby for fun and profit that are very difficult to duplicate in other tools. We wanted to make sure that, even though you were “in” a 3GL, you didn’t have to go through any extra hoops to make the simple things work. Ruby was the language that I was comfortable enough in, that I knew had the ability, to make that a reality.

That said, one of our goals is to extend the ability to write Chef recipes into other 3GL’s. We have an example of doing this already with Perl – and we made no changes to the Chef source to accomplish it. You can see the [demo here on CPAN](http://search.cpan.org/~holoway/Chef-0.01/lib/Chef.pm). It works by using Chef’s JSON API to ship the compiled resources over to the Ruby library for execution, and over time we’ll be extending those interfaces. You’ll be able to have recipes written in Python interoperating with recipes written in Ruby and Perl.

**AkitaOnRails:** Does Chef have (or for that matter, need) something like Augeas, which Puppet is trying to support?

**Opscode:** Augeas is neat. Chef doesn’t have Augeas support today, and the reason is that nobody has needed it badly enough to write the integration. One reason is that, with Chef, it is quite easy to dynamically add to a resource (like, say, a template) or search for particular systems that match a criteria. This means that the use-case for Augeas (which edits files in place) is less necessary – you can often get the data you need to render a template, rather than needing to build it up over time with incremental edits.

We think this is a better practice in general, as it ensures that all the systems you are managing can always be restored to a working state from nothing but the cookbook repository. If you use Augeas to allow idempotent changes of individual lines of a configuration file, it encourages the behavior of individual administrators editing files in place, which is a configuration management anti-pattern.

**AkitaOnRails:** Sysadmins used to CFEngine complain about Ruby’s dependencies and overall weight. Because for Chef to run you need Ruby installed. Not all distros have Ruby in the same version (although most already migrated to 1.8.7). Then you have the problem of weight. I am not familiar with Chef, but Puppet can grow to hundreds of megabytes. What they don’t want is to have clusters of Chef machines (which, by themselves, also need maintenance, adding to the overall complexity). How do you deal with datacenters with thousands of servers? I know it’s difficult to measure precisely, but what would be a reasonable ratio between Chef servers x managed servers?

**Opscode:** When you are evaluating the scalability of configuration management systems, you want to look at two different axis. The horizontal one, which is the number of systems that can be managed by a single configuration management server at a particular rate of change, and the vertical, which is how much of your infrastructure can be automated by the tool.

On the vertical axis, I think Chef is the clear winner, for reasons I think are pretty well summed up by my answer to question 7. I would put Puppet second, and Cfengine last.

On the horizontal axis, Cfengine is the clear winner. It’s written in C, and it has the thinnest possible server component – it does nothing but authenticate clients and serve files, essentially. I know first hand of data-centers that are running huge numbers of servers off a single cfengine server.

One important metric to keep in mind when discussing the horizontal scalability of a configuration management solution is that the most important metric is the **rate of change**. All the tools we’ve been talking about are ‘pull’ based – the clients check in at an ‘interval’ with the server, and apply a _‘splay’_ to ensure that not all the systems check in at once. A common out of the box configuration is an interval of 30 minutes, with a splay of 15 minutes. (This means a server checks in every 30-45 minutes, depending.) If you are comfortable increasing that interval, you will get more scalability out of fewer resources (by lowering the amount of concurrency.)

So when anyone says “I have 10 thousand servers on a single configuration management server”, ask them “at what interval?”.

Chef scales like a web application. The server itself is quite thin, and is responsible for authenticating clients, transferring files, storing node state, and providing a search interface. It scales horizontally by adding new Chef Servers as necessary. The API is RESTful, and there is no session state between the clients and the server. (At least not in Chef 0.8+) When you encounter scalability problems with Chef, the tools you apply are the same ones you apply to any well designed web application.

You asked specifically about memory utilization – Chef does quite well in this regard. Individual server processes usually are between 14-50MB resident. The client itself, running in daemon mode, is usually around 28MB resident.

In our testing, the current bottleneck in a Chef server is CPU. Chef is smart about how it handles file transfers – we only transfer files that have changed on the server. To support this we calculate a checksum for each file requested, and we currently don’t cache the results. We’re planning on fixing this for the next major release of Chef (0.8.0) which should shift the bottleneck over to RAM.

With Chef 0.7, you should be able to support thousands of clients at a half-hour interval and fifteen minute splay on reasonable commodity hardware. The changes in Chef 0.8 should bring that number up dramatically – I’ll get back to you with some benchmarks once the patches are in. :)

**AkitaOnRails:** Probably related to the previous question, seems like specially after Sarbanes Oxley there’s been an increasing interest in stuff such as ITIL, CoBit. Have you ever seen successful implementations of those in the Web-style infrastructure? I mean, I can see them succeeding in Banks, Aerospace and Defense, etc but I fail to see them working as advertised in a very dynamic environment such as Web services hosting. What are your experiences regarding this issue?

**Opscode:** Well, I think you can think of ITIL in the same way you think about the classic ‘Waterfall’ model of software development. For some kinds of projects and companies, it is essential – it’s hard to imagine working a different way. Most often these are companies with huge manufacturing or quality control concerns – medical health, aerospace, banking and finance, etc.

The same thing applies to ITIL – the larger the concern, and the more stringent the requirements, and the longer the lead time, the more the processes they describe start to make sense. Like all large process, though, they tend to de-emphasize the human element – people have roles to play, and forms to file. :)

In the Web Ops culture, things are different. I’ve never seen a successful marriage of ITIL and Web Ops, and the reason is that the domains are so very different. If there is a bug on the website, it’s better to ship the fix now than wait for a release management process to ensure that the site won’t have any more issues based on your fix, for example. It’s also a bad cultural fit – in the best Web Ops teams, the focus is heavy on communication, agility, and respect, rather than process, formalism, and tooling. The shift you start too see in the really great Web Ops companies is that their operations personel become enablers of the organization, rather than end-line blockers of change (to keep stability high.)

In general, I think the 4 steps outlined in visible ops for emergency management are not bad ones, but the devil is always in the details. The guy you should really ask about this is Jesse – he’s largely responsible for Amazon’s operational culture, and knows what it means to start hacking on that sort of thing from within huge organizations.

**AkitaOnRails:** Awesome, I think this is a wrap. Thank you very much for this interview!

