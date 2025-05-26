---
title: RailsConf 09 - Exclusive Audio Interviews
date: '2009-05-08T05:07:00-03:00'
slug: railsconf-09-exclusive-audio-interviews
tags:
- railsconf2009
- interview
- english
draft: false
---



I’ve had a great time interviewing several interesting Rubysts and Railers on their new projects. I think you will like to hear what they have to say.

My first guest was Joshua Timberman. He is a fervorous evangelist for the [Chef](http://www.infoq.com/news/2009/01/chef-management-tool-announced) project. Chef could be seen as a more modern Puppet, which by itself, already is a modern systems configuration manager. Chef is composed of several pieces, cookbooks and details that Joshua explains in his interview.

<object type="application/x-shockwave-flash" data="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf" width="200" height="20"><br>
    <param name="movie" value="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf">
<br>
    <param name="bgcolor" value="#ffffff">
<br>
    <param name="FlashVars" value="mp3=http%3A//s3.amazonaws.com/akitaonrails/files/Joshua_Timberman_Chef.mp3">
<br>
</object>

[Download](http://s3.amazonaws.com/akitaonrails/files/Joshua_Timberman_Chef.mp3) (22:24)

One project that I am particularly very interested is [Spree](http://spreeecommerce.com/). Sean Schofield started this Rails based e-commerce system to support developers that had to reinvent the wheel all the time, and e-commerce systems are notoriously not easy to do. Spree is a fairly complete project, with many nice features, including integration with ActiveMerchant, shipping support, tax categories and so on. I helped a bit doing the Brazilian Portuguese internationalization of the project as well. Highly recommended.

<object type="application/x-shockwave-flash" data="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf" width="200" height="20"><br>
    <param name="movie" value="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf">
<br>
    <param name="bgcolor" value="#ffffff">
<br>
    <param name="FlashVars" value="mp3=http%3A//s3.amazonaws.com/akitaonrails/files/Sean_Schofield_Spree.mp3">
<br>
</object>

[Download](http://s3.amazonaws.com/akitaonrails/files/Sean_Schofield_Spree.mp3) (22:15)

By now I think we all know New Relic, Fiveruns and Rails monitoring systems. But there are more competition coming up, from the guys of Highgroove Studios we have [Scout](http://scoutapp.com/) a non-nonsense approach to Rails monitoring and data analysis. They are willing to go an step further: instead of just presenting raw data as reports, they are analyzing this data and giving you relevant recommendations so you can further optimize your application. And more than that: they are highly competitive in price. And the client agent that gathers data and send to their servers is open source and extensible through plugins, so you can add even more to what they already offer. Definitely worth checking out:

<object type="application/x-shockwave-flash" data="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf" width="200" height="20"><br>
    <param name="movie" value="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf">
<br>
    <param name="bgcolor" value="#ffffff">
<br>
    <param name="FlashVars" value="mp3=http%3A//s3.amazonaws.com/akitaonrails/files/Matt_Todd_Highgroove_Studios.mp3">
<br>
</object>

[Download](http://s3.amazonaws.com/akitaonrails/files/Matt_Todd_Highgroove_Studios.mp3) (13:43)

At RailsConf 2008, last year, I interviewed [James Lindenbaum](http://www.akitaonrails.com/2008/6/5/railsconf-2008-brazil-rails-podcast-special-edition) about Heroku. They were still in beta at that time. Now they finally released a commercial version with lots of new features. I was particularly surprised to find Ryan Tomayko at their booth, working for Heroku. I think Heroku really nailed easy deployment for Ruby applications over Amazon EC2. If you don’t want to worry about infrastructure, Heroku may be the answer:

<object type="application/x-shockwave-flash" data="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf" width="200" height="20"><br>
    <param name="movie" value="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf">
<br>
    <param name="bgcolor" value="#ffffff">
<br>
    <param name="FlashVars" value="mp3=http%3A//s3.amazonaws.com/akitaonrails/files/Ryan_Tomayko_Heroku.mp3">
<br>
</object>

[Download](http://s3.amazonaws.com/akitaonrails/files/Ryan_Tomayko_Heroku.mp3) (33:49)

Again, last year, everybody was blown away by the announcement of Gemstone – traditional Smalltalk software-house – showing a very preview version of Ruby actually running over a very mature Smalltalk VM. This is the [Maglev](http://maglev.gemstone.com/) project. Since then the development has been quite secretive. But they are finally disclosing more and more information on how the project is going. This year, they were able to show a small Sinatra application already running – albeit, with some tweaks. I think they are evolving very fast. Ruby is notoriously not an easy language to implement and Maglev will be incredible when released. In this interview we have Monty Williams, Peter McLain and Michael Latta discussing about the current development and future roadmap.

<object type="application/x-shockwave-flash" data="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf" width="200" height="20"><br>
    <param name="movie" value="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf">
<br>
    <param name="bgcolor" value="#ffffff">
<br>
    <param name="FlashVars" value="mp3=http%3A//s3.amazonaws.com/akitaonrails/files/Maglev_Team.mp3">
<br>
</object>

[Download](http://s3.amazonaws.com/akitaonrails/files/Maglev_Team.mp3) (36:42)

Finally, I think everybody knows Ilya Grigorik by now, from [igvita.com](http://www.igvita.com). He received last year’s Ruby Hero Awards, and it was well deserved. He is one of the few developers that can tackle very advanced subjects in a way that anyone can understand. He started a new company recently and they have a very very interesting product called [PostRank](http://www.postrank.com). The overall idea is fairly simple: they went a step further over Google’s own PageRank system. Instead of just considering link tracebacks, they now weigh in social network behavior. For example, a single Digg page traces back to a website with just one link. But this same page at Digg can have something like hundreds of comments, or “engagements” as Ilya calls it. This gives a totally different weigh to this traceback instead of just a simple link. So companies are starting to pay attention to social networks such as Digg, Reddit, Twitter and others and now Ilya comes up with the tool to deliver them the necessary metrics. I highly recommend you to test-drive this site, I think you will be impressed.

<object type="application/x-shockwave-flash" data="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf" width="200" height="20"><br>
    <param name="movie" value="http://s3.amazonaws.com/akitaonrails/files/player_mp3.swf">
<br>
    <param name="bgcolor" value="#ffffff">
<br>
    <param name="FlashVars" value="mp3=http%3A//s3.amazonaws.com/akitaonrails/files/Ilya_Grigorik_PostRank.com.mp3">
<br>
</object>

[Download](http://s3.amazonaws.com/akitaonrails/files/Ilya_Grigorik_PostRank.com.mp3) (21:43)

And this wraps up my series of interviews at RailsConf 2009. I wish I had more time to interview more people. There were very insightful and smart developers there, and I would have to _git clone_ myself many times to be able to talk to all of them. I hope you enjoy this set of interviews.

