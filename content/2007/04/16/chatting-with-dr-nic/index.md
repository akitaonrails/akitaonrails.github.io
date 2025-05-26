---
title: Chatting with Dr. Nic
date: '2007-04-16T13:01:00-03:00'
slug: chatting-with-dr-nic
tags:
- interview
- english
draft: false
---



### Chatting with Dr. Nic

 ![](/files/130749539_89959dd059.jpg)

Today Carlos Eduardo, from [e-Genial](http://www.egenial.com.br), proposed me to interview Dr. Nic Williams himself. The man of the hour. And I accepted right away and we started ‘skyping’ for a couple of hours. He is a nice guy and as educated and well informed as I expected. So, with no further ado, here it goes:

#### Who is Dr. Nic?

**AkitaOnRails** : So, let’s start by telling our readers, who is Dr. Nic – I know, too generic, but let’s start from here :-)

**Dr Nic** : I eat meat, am married, have a small boy, and I write software. In no specific order. I actually stopped writing software for a year or so – left my job and did other things. But everything I did had a software solution, so I found myself writing software for it. So, eventually, I learnt to love my inner nerd. Now I am happy :-)

**AkitaOnRails** : So, let’s do a combo set of questions. Where are you from? What’s your current day job, is it Rails related? And what’s your history with Rails?

**Dr Nic** : I am an Australian citizen, currently living in Sweden, working for a Swedish telephone company – Tele2 – for their billing project. It has nothing to do with Ruby. Two years ago I was in India, and was looking for a way to write code fast. I have a lot of ideas and it was taking a lot of effort to write them up in .NET. I saw [this video](http://www.rubyonrails.org/screencasts) on Ruby on Rails and my initial reaction was _“I hate all the \<% … %\> syntax”_. So I ignored it. I tried to make Ajax work with ASP.NET but it was so ugly and laborious at the time. I re-watched the Rails video and ignored the ugly brackets, and fell in love ever since. That’d be September 2005 I think

**AkitaOnRails** : So, I think you have some serious concern about the brackets. What’s your position about them today, did you get used to them or tried something else?

**Dr Nic** : No, I don’t mind them at all now. I don’t think I’ve ever tried an [ERB replacement](http://haml.hamptoncatlin.com/) in Rails. I use Textile/Redcloth for the newgem website. It was just one of those initial reaction things. I saw the \<% … %\> and that was what might have stopped me learning Ruby. Oh, I also remember thinking _“I don’t want to learn another language, how unnecessary”_. I’m glad I was wrong. Learning Ruby was necessary.

#### Dr. Nic’s Magics

**AkitaOnRails** : I see that you like the ‘Magic’ side of the Ruby stuff. How did you come by with the [Magic Model](http://magicmodels.rubyforge.org) solution? I can guess that it felt quite natural, but what’s that story?

**Dr Nic** : At Railsconf 2006, [Dave Thomas](http://pragdave.pragprog.com/) outlined a bunch of things he saw as _“things we can work on”_ in Rails. One was lack of Composite Keys, another was the mysterious lack of DRYness in model files. I’d never released code to the Ruby community before (nor any community), but a few weeks later I just had these ideas for how to solve those two problems – both in the same week. I have no idea what possessed me to call the Magic Models that name. But I still like it. I just envisioned a magic show whereby you made the Model file disappear piece by piece yet it still worked. Thus the name. Ok, so I do know why I called it that. :-)

**AkitaOnRails** : From a marketing stand point, I find it fantastic. You could call it something fancy as ‘Houdini’ but Magic Models does the job. I have a feeling that this is your most famous open source Rails project. Am I right or is there any other plugin of yours that is more compeling to the community right now?

**Dr Nic** : I don’t think many people actually.. you know.. use the Magic Models. Deep down you need a model file as a placeholder for other functionality. So its more of a show-case of a concept. I have a 200 table schema that I use for a work. I use hooks to include additional stuff in the generated models. I hope that the [New Gem Generator](http://newgem.rubyforge.org) becomes popular. I’d like to see more people sharing code.

**AkitaOnRails** : So, what can you tell us about the Gem Generator. What does it do? What is it all about?

**Dr Nic** : Writing a gem from scratch isn’t simple/obvious. So ‘newgem’ creates a scaffolding for a gem, like the rails command creates a scaffolding for a rails app. It creates a folder containing a Rakefile, lib + test folders with some starter files, and a framework for managing a website on rubyforge.org. It uses the [hoe](http://seattlerb.rubyforge.org/hoe/) + rubyforge libraries as they are awesome. If people knew how good these two tools were they’d write more gems and less rails plugins.

**AkitaOnRails** : Sounds pretty nice. It should make the deployment of new Gems a breeze. I am not very well aware of the RubyGems process and the RubyForge website. Have you tried to make some kind of partnership about the Gem Generator and the current Gem project? Maybe merging the two together to create a one-fits-all package?

**Dr Nic** : When I first created it there was a bit of chat about it with the RubyGems guys, but I don’t think its important. ‘newgem’ is one gem scaffolding app; the hoe gem comes with ‘sow’ which creates a similar structure. And I think someone else is creating a gem scaffolding app. So the more the merrier. You see the same for rails. You have the ‘rails’ scaffolding, but now there are “mega-rails” apps, like [Hobo](http://hobocentral.net/), that give you so much more of a headstart in creating an app. I start gems/projects because I need the solution and I think other people will want it too. If someone makes a better version, that’s great. I can stop supporting my version :-)

**AkitaOnRails** : Yes, and Streamlined and AjaxScaffold. I was hoping to see both of them releasing new versions sooner. They [announced a merging collaboration](http://www.height1percent.com/articles/2006/08/17/ajaxscaffold-and-streamlined-developers-to-collaborate) but I never heard from them again. Have you?

**Dr Nic** : [AjaxScaffold](http://www.akitaonrails.com/2006/12/01/come%C3%A7ando-com-o-plugin-ajax-scaffold) became a plugin and has now been rebranded as [ActiveScaffold](http://activescaffold.com/). Its still under active development by [Richard White](http://www.height1percent.com/) + others. Actually, AjaxScaffold was the first project I ever helped with, before I wrote [CPK](http://compositekeys.rubyforge.org/) + [Magic Models](http://magicmodels.rubyforge.org/). So I learnt a lot about gems and rails generators from its code. I’ve never used [Streamlined](http://www.streamlinedframework.org/) but its still under active development as far as I know. I’m not a fan of open source projects merging. Often they are built around the inspiration of an individual. Those individuals mightn’t share nicely together :-) Plus, its a whole bunch of work to merge two blocks of code.

#### Open Sourcing

**AkitaOnRails** : Going back to your previous statement: don’t abandon your project. Fight for it! :-) But talking seriously, development and support require a lot of effort. Mainly with support, bug fixes and all. Do you get a lot of help from the community, maybe patches?

**Dr Nic** : Help + patches – that has turned out to be the best thing about open source (OSS) – people fix your code, or at the very least ask _“why didn’t you do it [an alternate] way?”_

**AkitaOnRails** : Hm, let me digress a little bit. I have mixed feelings about merging and forking. I usually don’t like forking unless the original team have gone numb like what happened to the [XFree86](http://pt.wikipedia.org/wiki/Fork) project. Alternatives should really be very different like KDE and Gnome, and they are fine. But components that does most of the same things or complement each other like the current [beryl and compiz](http://lwn.net/Articles/229690/) discussion, maybe it’s ok for them to merge and focus effort on a single direction. What do you think? For instance, I think that a multi connection support like yours or Rev.Health’s one should be in the main Rails tree. It’s as important as the database adapters. Or maybe not?

**Dr Nic** : There is a project [DRYSql](http://drysql.rubyforge.org/) that is for all intents and purposes similar to the Magic Models. It’s not a fork, but the code would be similar. But I’m glad he did it. I think OSS is driven by inspiration – and people like to have their name attached to code. If he writes more code because it has his name on it, then that’s great. Regarding more vs. less in Rails – I think more code should be extracted from Rails, rather than more code added to Rails. Unfortunately if you take things out, then the anti-rails movement say stupid things like _“Oh rails can’t do XXX”_ even if there is a plugin/gem that can do it, or even if you could do it in 5-100 lines of purpose built code. But we’re not here to make the anti-railers happy, just ourselves. So, extract code out of rails-core and set it free.

**AkitaOnRails** : Yes, like the current desire to cut out the Active Web Services support as it seems like fewer people are using it, and make it into a plugin. That’s right, the more it is in the core, the heavier it gets to load the process.

**Dr Nic** : Let people choose prototype/scriptaculous vs. jquery for example. But, no one will do that – not worth the effort. And right – no need for AWS anymore – its already packaged as a separate gem. You just stop making it a dependency in the rails gem. So that’s an easy one. But my attitude is that Rails is perfect given that it’s only a few years old, completely Open Source, and has a wonderful community of intelligent, caring developers who can _“scratch their own itches”_ and then share the results via blogs + forums.

**AkitaOnRails** : I am personally a little bit worried about this because Rails is becoming something as the Linux kernel. Linux doesn’t have an specific set of [stable APIs](http://www.kroah.com/log/linux/ols_2006_keynote.html), so each new version has to tweak some of it’s drivers. It works because all of the drivers’ source code are in the main tree. Rails is like the same: I asked DHH (refer to my book’s interview) about stable APIs and he is not very fond of limiting what he wants by providing stable APIs through out newer versions. So plugins are destined to fail someday unless they are delivered along side the main distribution. Maybe we’re going to see _‘Rails Distros’_ in long run?

**Dr Nic** : Fragmented rails – yep that’s a valid concern. I think you will see “rails distros”. I think they already exist. But they aren’t called that. [Hobo](http://hobocentral.net/) for example could be a rails distro. So one day we could have a HoboConf.

**AkitaOnRails** : Actually I just got into this _Distros_ conclusion. Maybe I should start assembling my own :-) The _Akita Rails Distro_.

**Dr Nic** : Just make sure you do screencasts. They sell software. Having given that pearl of wisdom, I’m not sure why I don’t do them. Writing blog articles is fun and time consuming, that’s probably why. But videos work. Rails success will be noted in the history books, in part, to [that 15 min video](http://rubyonrails.org/screencasts).

#### Twitter vs. DHH – Round 2

**AkitaOnRails** : Speaking of which, support, plugins, I have to ask you something delicate (_I don’t want it to become an excuse for another flame-war_): what do you think about the current [Twitter vs DHH](http://www.akitaonrails.com/2007/04/15/a-polemica-twitter) discussion? Twitter says: _Rails should have given us the solution_. DHH says: _Twitter could have contributed back with a solution_. I think this kind of arguments doesn’t do any good for the community, as I [posted](http://www.akitaonrails.com/2007/04/15/a-polemica-twitter) at my blog yesterday. What are your insights about it?

**Dr Nic** : The guys at Twitter have already contributed code to Ruby community ([Jabber API](http://romeda.org/blog/2006/11/announcing-jabbersimple.html)), and when they settle on a solution for their situation, I think they will be very happy to share it with us. That will be great. Remember: Rails is 2 years old. .NET + ISS is 7+ years old. Java is 10 years old. LAMP is very old. So, its all in front of us. Exciting times.

**AkitaOnRails** : And you didn’t [get your t-shirt](http://www.loudthinking.com/arc/000610.html#comments), or did you? :-)

**Dr Nic** : No one has asked my address – a query that preludes the sending of t-shirts.

**AkitaOnRails** : hahaha, and did you get feedback from the community about the magic multi connection (MMC) and the Twitter discussion? By the way, how did you come by the global array of connection modules solution?

**Dr Nic** : I think the most important aspect of the MMC is that it answers the doubts of whether Rails CAN connect to multiple databases. It is a silly thing to say _“Rails cannot connect to multiple databases”_ but the anti-railers like the way it sounds, I think. Even without the MMC, you can create your own connection pool, and manually assign the connections before each request. The MMC hides this via modules. Revolution Health’s solution moves the allocation of connections into the CRUD methods. All the same solution. Just different levels of control and different syntax.

**AkitaOnRails** : But did you think about that before, or was the heat of the discussion what motivated you to hack together a solution?

**Dr Nic** : I’d written the gem a week earlier to scratch an itch. The idea of using modules to control ActiveRecord model behaviour appeals to me from a “magic” sense. Its cute. For example, the latest Magic Models allows you to use Modules to specify table name prefixes. So, I had the gem, and Twitters issue turned up. So I wrote the blog article and the tutorial as a result. I was going to release the gem in a few days but not aimed at the master-slave issue. It was built with the aim of using it for admin websites that need to connect to 2+ different databases. I’ll blog about that later.

**AkitaOnRails** : Really excellent timing. Did you hear something from the Twitter guys? Now someone has to build a screencast explaining Railers how to set up a master-slave replication between MySQL databases first :-)

**Dr Nic** : I think more Railers are interested in how they get their Rails app into production in the first place :-) They dream of having scaling issues. _“Oh, my Google Ad-sense account is full. What should I do with all that money.”_

#### Community and Macs!

**AkitaOnRails** : Speaking of the community, do you attend to a lot of conferences, events? Have you been in the latest RailsConf EU? What are your opinion about what’s going on around the community?

**Dr Nic** : I met only a handful of people at the Railsconf 2006. I sat in the audience watching all the famous Rails bloggers speak, like everyone else in the audience. I felt very happy to be there. I was one of 50 people with a PC laptop. I did a lightning presentation on RadRails vs TextMate for a few laughs. Travelling from Europe to Chicago cost a bit of money, so even though RailsConf EU was across the channel in London it was vetoed by the Williams financial panel. But I’m off to RailsConf again in May, should be wonderful. The community of Rubists is awesome.

**AkitaOnRails** : (_I wish I could be there as well – sigh_) well, so it means your primary machine is Windows based. Are you still using RadRals or have you tried the newest contenders like “E” or even the NetBeans and IntelliJ’s Ruby integration?

**Dr Nic** : Ahh, it _was_ a PC. I bought a unix laptop, with an Apple logo :-) The PC was old and making a lot of whirring noises. I just couldn’t find a reason to stay with the PC vs. the possibilities with OSX. I’m not an Apple Fanboy, but I love my Mac.

**AkitaOnRails** : Let me guess: Macbook Pro 15" Core 2 Duo 2.33?

**Dr Nic** : Macbook 13" – I use it on the bus and train.

**AkitaOnRails** : Haha, I also say that: _“I’m not an Apple Fanboy”_. Maybe someone should create the category of _“the Deniers”_ :-)

**Dr Nic** : I love my wife, my son and my mac, officially, in that order.

**AkitaOnRails** : I wish I could use mine at the train, but I would be robbed in less than 10 seconds. No doubt about that.

**Dr Nic** : Ha. Its a big planet. You could move.

#### Dr. Nic’s Career Advice

**AkitaOnRails** : Nice proposition. I am thinking about it. By the way. At the beggining of this conversation you told us that you’ve been working at India? How come? Any kind of consultancy work for any of the major companies like Tata, Wipro, Satyam? What are your opinions about the recent discussions and worries, like the Chad Fowler’s book [My Job web to India](http://www.rubyonbr.org/articles/2006/10/18/por-que-aprender-ruby-o-torna-um-programador-pior-por-akita/)?

**Dr Nic** : I went to India for the same project I’m on now with the Swedish company. Back then it was for Accenture, who were doing the work at the time out of India. I have a copy of Chad’s e-book… damn, haven’t read it yet. But thanks for the reminder. I have lots of thoughts about _“outsourcing to India”_. But they aren’t positive, so I’ll take a pass. They are more the topic of conversation when alcohol is involved. :-)

**AkitaOnRails** : haha, if you ever think about doing outsourcing services, consider Brazil. Did you hear anything about us in outsourcing conversations?

**Dr Nic** : Never. People who I hear talking about outsourcing mention “India”, several asian countries, and eastern european countries. Never Brazil.

**AkitaOnRails** : Dawn, I knew it :-)

**Dr Nic** : So, just pretend you are American and ask for American rates.

**AkitaOnRails** : Good advice. I just [wrote an article](http://www.akitaonrails.com/2007/04/14/off-topic-seja-arrogante) about the importance of being fluent in english at my blog. That’s one compeling reason.

**Dr Nic** : Absolutely. Clients don’t pay per line of code. They kind of pay for results, and kind of pay for working with people they like and trust. I think.

**AkitaOnRails** : And I agree with that statement: people hire compentecy, in general. And have you ever consider flying down on vacation to Brazil?

**Dr Nic** : Absolutely, its on our list of places to visit.

**AkitaOnRails** : And what do you know or hear about our humble home country? (_default question to a foreigner, I had to ask._)

**Dr Nic** : Football, poverty, women, the big statue on the hill, and the Amazon.

**AkitaOnRails** : I bet it’s better than New Delhi or Bangalore.

**Dr Nic** : They have poverty, but no statue on a hill :-)

**AkitaOnRails** : Well, I guess I already took a lot of your time. What about calling it a day? Do you have anything you want to say to the brazilian audience? Career Recommendations? :-)

**Dr Nic** : Career advice… Learn English, be proud of being Brazillian, and enjoy writing code.

**AkitaOnRails** : ow, last question! Is _Nic_ short for _Nicholas_? Dr. Nicholas Williams?

**Dr Nic** : Correct. PhD in Computer Science. I just use the _Dr Nic_ name ‘cause it’s a bit different. I don’t mean to show off the “Dr” part.

**AkitaOnRails** : Very nice! Dr. Nic, then :-) Very glad for this opportunity. I look forward for more conversations like this. Too bad we can’t do it in a bar with beers.

