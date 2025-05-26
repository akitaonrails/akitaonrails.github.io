---
title: Chatting with Luke Kanies
date: '2009-11-18T11:45:00-02:00'
slug: chatting-with-luke-kaines
tags:
- interview
- english
draft: false
---

Configuration Management is a tricky subject. For non-starters, when you’re a developer and you have few boxes to take care of, you can usually get away with just managing them manually. People are probably just used to pop in a CD, double-click the “install” program and click “next”, “next” until the end, then you manually log in to backup (when you remember it), and sometimes you do apply some security updates when you remember about them.

But then you have more than a dozen machines, things start to get uglier, you end up making more mistakes, forgetting important steps, and all of a sudden managing machines become a nightmare. You end up being woken up in the middle of the night because you forgot to install some crucial component, and so on and so forth.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/pic2_original.jpg)

The same way you need testing, continuous integration tools when you’re a developer, you also need automated, reliable and flexible tools for the system administrator role. That’s where tools such as **Puppet** kick in to help.

This time I’ve interviewed [Luke Kanies](http://twitter.com/puppetmasterd), from [Reductive Labs](http://reductivelabs.com/), former contributor to the famous CFEngine tool and creator of [Puppet](http://github.com/reductivelabs/puppet), one of the most acclaimed configuration management tool for 21st century datacenters.


 **AkitaOnRails:** To kick start this interview, it would be great to have more background info about you. So, how did you end up in the configuration management field? I understand that you have a long history with CFEngine development, right?

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/luke_kanies_portrait_original.jpg)

**Luke:** I was a Unix admin going back to 1997, always writing scripts and tools to save myself time, and around 2001 I realized that I shouldn’t have to write everything myself – that someone somewhere should be able to save me time. After a lot of research and experimentation, I settled on Cfengine, and had enough success with it that I started consulting, publishing, and contributing to the project.

**AkitaOnRails:** What’s the story behind Reductive Labs, what’s its mission, and what’s the story for Puppet’s creation?

**Luke:** After a couple of years with Cfengine, I had a lot more insight but was frustrated because it still seemed to be too hard – no one was sharing Cfengine code, and there were some problems it made you work really hard to solve. The biggest issue, though, was that its development was very closed – it was difficult to contribute much more than just bug fixes.

I got frustrated enough that I stopped consulting and looked for other options. I worked briefly at BladeLogic, a commercial software company in this space, but in the end I decided that the insight I had and the lack of a great solution were a good enough start for a business that I decided to morph my consulting company into a software company and write a new tool.

**AkitaOnRails:** I’d like to say that only amateur sysadmins do everything manually, but I think most small to medium corporations at least still do everything manually or with random scripts spread all over the place. The notion of “configuration management” is still new to a lot of people. Could you briefly explain what it is, and why it is important?

**Luke:** It’s surprisingly difficult to describe it succintly, but for me, there are two key rules: You shouldn’t need to connect directly to a given machine to change its configuration, and you should be able to redeploy any machine on your network very quickly.

These two rules combine to require comprehensive automation and/or centralization for everything that goes into making a machine work. Annoyingly, they also immediately introduce dependency cycles, because your automation server needs to be able to build itself, which is always a bit of a challenge.

**AkitaOnRails:** I think one of the most widely used system is CFEngine2. How does Puppet compare with it? Meaning, what do I have as value added when switching to Puppet, and what are the known caveats?

**Luke:** There are multiple important functional differences. The biggest is Puppet’s **Resource Abstraction Layer** , which allows Puppet users to avoid a lot of the detail they don’t really care about, like how rpm, adduser, or init scripts work – they talk about users, groups, and packages, and Puppet figures out the details.

We also have explicit dependency support, which makes a huge difference – it’s easy to order related resources and restart services when their configuration files change, for instance.

The language is also a bit more powerful. Like Cfengine, we have a simple custom language, but Puppet’s language provides better support for heterogeneity, along with a composite resource construct that allows you to easily build in-language resource types like Apache virtual hosts that model more complex resources consisting of multiple simple resources.

**AkitaOnRails:** Puppet has a lot of components. Could you briefly describe some of the main ones that work together? The client side, the server side, recipes?

**Luke:** Most people use Puppet in client/server mode, where the central server is the only machine that has access to all of the code, and it runs a process capable of compiling that code into host-specific configurations. Then each machine runs a client (including the server), which then retrieves and applies that host-specific configuration. This has nice security implications because you’ve not shipped your code to every machine on your network.

If this model doesn’t work for you, though, it’s also easy to run Puppet stand-alone, where each machine has all of the code and compiles it separately. Multiple Puppet users do this for various reasons. This stand-alone ‘puppet’ executable is a standard interpreter – it can be used to run 1 line scripts or thousands of lines in a complete configuration.

Beyond this, we’ve got a few other interesting executables, such as to access our certificate authority functionality, and an interesting executable called ‘ralsh’ that provides a simple way to directly manage resources from the Unix shell, without having to write a separate script.

**AkitaOnRails:** What would you say about Puppet’s maturity? CFEngine has more than a decade of usage, which is difficult to beat. Would you say that it’s “mature enough”? Meaning, it’s already in production in companies of many sizes, its APIs don’t change too much and my recipes will probably work if I upgrade to a newer version of Puppet? I think the 0.x version makes some people nervous :-)

**Luke:** Really we should have called a version from 2007 1.0, but it’s hard to know how stable a release is going to be until it’s been out for a while. :)

It’s obviously tough to match Cfengine’s long life, although they’re somewhat forcibly migrating to Cfengine 3, which is a complete rewrite, so that maturity isn’t worth quite as much right now.

However, Puppet’s been in production usage around the world since 2006, and it’s currently used by more large companies than I could reasonably name – Twitter, Digg, Google, Sun, Red Hat, and lots more – and our community and customer base consider it to be mature. For the line came some time early last year, when I found that the vast majority of issues people had were user issues on their part, rather than some flaw or shortcoming in Puppet.

In general the APIs are quite stable, and we’ve done quite well, I think, at maintaining backward compatibility when the APIs have had to change. The point about API stability in a 1.0 release isn’t so much to differentiate it from previous efforts as to make a promise for the future. This especially matters for companies like Canonical, who want a release that they can support on Ubuntu for five years.

**AkitaOnRails:** Puppet has its own language and you can use Ruby for the advanced cases. It’s probably perfect for Rubists, but I feel that most sysadmins are used to Bash, Python and are not very flexible on change. Why did you choose to use Ruby instead of a more widespread language? What do sysadmins need to realize to shift paradigms?

**Luke:** Part of it is that most people don’t really need to know any ruby to be effective with Puppet. Sure, you can get some more power if you do, but if you’re not a language person, you’re perfectively functional with just Puppet.

Another nice thing is that we have a pretty smooth scale in terms of Ruby knowledge – you can start out writing ERB templates or five line extensions to [Facter](http://github.com/reductivelabs/facter), which is our client-side querying system, and grow smoothly through to writing custom resource types.

In the end, I chose Ruby because I was most productive in it. I likely should have chosen Python, given its speed benefit and popularity at Red Hat and other places, but I found I just couldn’t write code in it. I started thinking in Ruby after only a few hours of usage, so it was impossible for me to turn away from it.

**AkitaOnRails:** Sysadmins used to CFEngine complain about Ruby’s dependencies and overall weight. Because for Puppet to run you need Ruby installed. Not all distros have Ruby in the same version (although most already migrated to 1.8.7). Then you have the problem of weight. Puppet can grow to hundreds of megabytes. What they don’t want is to have clusters of Puppet machines (which, by themselves, also need maintenance, adding to the overall complexity). How do you deal with datacenters with thousands of servers? I know it’s difficult to measure precisely, but what would be a reasonable ratio between Puppet servers x managed servers?

**Luke:** It’s as impossible to tell you how many clients a Puppet server can handle as it is to tell you how many clients a Rails server can handle – it all depends on the complexity of the tasks. Google scaled to 4500 client machines on a single server, but most people tend to add another server at around 500-1000 clients.

It’s true that it’s hard to keep memory usage down in a Ruby process, but we’ve made great strides in our recent releases by doing things like deduplicating strings in memory and being more efficient in our code paths. Really, though, we’ve spent a lot more time on features and bug fixing and less time on optimizing – until recently, we’ve been a small development team, and we just didn’t have the bandwidth for it.

Now that my company, Reductive Labs, has some investment, we’ve been able to add three full time developers, which is going to really help in this area.

As to dependencies, this is one area we break strongly from the Ruby community – we don’t require a single gem, other than our own Facter tool (and it’s usually not shipped as a gem). Rubyists tend not to worry too much about package dependencies – they just put it in vendor, as I’m fond of saying – but that doesn’t work when you have to deploy thousands of copies. So yes, you might have to install Ruby, but there won’t be any other dependencies you have to deal with, which greatly simplifies it.

It’s generally as tough to know how you’ll need to size your puppetmaster as it would be to size a web server – it depends on how complicated the workload is. In general, somewhere between 500 and 5000 clients, you’ll need to have a second server, but most people probably find it closer to 500. Really, though, if you’ve got 3000 clients hitting a service, you probably want to make it horizontally scalable for stability in additional to performance.

**AkitaOnRails:** Security is a big concern nowadays, Puppet was worried from the beginning on the handshake procedure between clients and server, can you describe it a little bit? Also, is there any built-in recipes for hardening machines, for example? Or at least any desires to add such tools in the future?

**Luke:** Puppet uses standard SSL certificates for authentication and encryption, including a certificate signing phase. By default, the client generates a key and a certificate request (CSR) and then uploads the CSR to its server. This upload, along with the later certificate download, are the only unauthenticated connections that are allowed by default.

From there, a human normally has to trigger the client’s certificate to be signed, but many organizations, including Google, automatically sign client certificates because they trust their internal network.

As to automatic hardening, there aren’t any recipes that I’m aware of right now, but it’s something that I’m definitely interested in. Years ago I was a big fan of TITAN, which is a hardening package for various \*NIX platforms, and it was part of the inspiration to write Puppet – I’ve always wanted a portable, executable security policy.

**AkitaOnRails:** The puppetmaster uses Webrick by default, but the documentation also describes using Mongrel or Passenger. Are there any real gains in using those? Is it more for convenience or do we have performance/robustness improvements?

**Luke:** Holy cow Webrick is slow. It’s really fantastic for proof of concepts – get up and running in minutes. Once you get beyond that proof of concept, though, you really need to switch to Mongrel or Passenger. If you get more than one concurrent connection in webrick, your clients start to suffer, but you can scale to far more with the other solutions out there.

**AkitaOnRails:** Are there any clients case you are allowed to talk about? Meaning, more details on the kind of infrastructure, difficulties, caveats, best practices?

**Luke:** The possibilities here are pretty open ended. Google uses Puppet to maintain their corporate IT, which means they’re running it on thousands of laptops and desktops which is pretty different. MessageOne, a division of Dell, is really interesting in that their developers have to ship Puppet code to manage the applications that they ship, so if an app isn’t trimming its logs or backing itself up, it’s a bug that the app developer has to fix rather than the sysadmin. This really helps to bridge the divide between dev and ops, which has worked out really well for them.

Otherwise, there are lots of stores and best practices, but I’m afraid that would be a whole second article. :)

**AkitaOnRails:** I’ve seen Andrew Shaffer talk about [Agile Infrastructure](http://www.slideshare.net/littleidea/agile-infra-agileroots-2009) for a couple of years now, but I still think most IT organizations are unaware of this concept. Can you elaborate on what does it mean to be Agile outside of the development field?

<embed src="http://agileroots2009.confreaks.com/player.swf" height="380" width="640" allowscriptaccess="always" allowfullscreen="true" flashvars="image=images%2F15-jun-2009-14-30-agile-infrastructure-andrew-shafer-preview.png&amp;file=http%3A%2F%2Fagileroots2009.confreaks.com%2Fvideos%2F15-jun-2009-14-30-agile-infrastructure-andrew-shafer-small.mp4&amp;plugins=viral-1"></embed>

**Luke:** I think Agile Infrastructure has even less adoption than Agile Development. The vast majority of IT shops haven’t changed practices significantly in years and are largely unprepared for the growth in server count that they’re experiencing. They mostly try to scale by adding more people, which we call the _meatcloud_, rather than scaling their tools and practice.

**AkitaOnRails:** Probably related to the previous question, seems like specially after Sarbanes Oxley there’s been an increasing interest in stuff such as ITIL, CoBit. Have you ever seen successful implementations of those in the Web-style infrastructure? I mean, I can see them succeeding in Banks, Aerospace and Defense, etc but I fail to see them working as advertised in a very dynamic environment such as Web services hosting. What are your experiences regarding this issue?

**Luke:** In general, I think these kinds of high-level policies are great for filings but aren’t so great for actually solving problems. The bigger a company is and the more public they are, the more likely they are to care about ITIL et al, but it doesn’t really help them solve problems outside of PR in my experience. You can be ITIL compliant and dysfunctional, or completely out of compliance but in fantastic shape. Considering that the best standards are derived from implementation and best practice, which few of these are, I don’t have a lot of hope for these being adopted by the best shops out there.

My personal experience is that very few companies ask or care about these standards, and the ones that do usually do so in a kind of checkbox way, in that they want to make sure they can check off things like CMDB but they aren’t really that concerned with the specifics.

**AkitaOnRails:** I think this is it! Thank you very much for this conversation!

