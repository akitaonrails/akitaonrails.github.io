---
title: Rails Podcast Brasil, QCon Special - John Straw (YellowPages.com) and Matt Aimonetti (Merb)
date: '2008-11-21T04:06:00-02:00'
slug: rails-podcast-brasil-qcon-special-john-straw-yellowpages-com-and-matt-aimonetti-merb
translationKey: qcon2008-john-straw-matt-aimonetti
tags:
- qcon2008
- interview
- english
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/johnstraw.jpg)

Today was a pretty busy day of interviews. This afternoon I was able to first interview **John Straw**. He is the responsible for what he calls [The Big Rewrite](http://uploads.en.oreilly.com/1/event/6/Surviving%20the%20Big%20Rewrite_%20Moving%20YELLOWPAGES_COM%20to%20Rails%20Presentation%201.pdf) project. The project about replacing 150k LOC from Java, with no tests, to around 13k LOC of Ruby on Rails, with almost 100% test coverage, and without reducing the scope. The original project was developed under 22 months and the rewrite took place in 4 months of development, with 4 developers (though they had 4 months of preparation and planning, but still …).

In this interview he talks about the motivations, how it was with the team to move from Java to Ruby, how they chose Rails, what’s the size of their infrastructure. It is a great case study for any company using Java to be reassured that changing to Ruby will only bring benefits.

After that I finally interviewed [**Matt Aimonetti**](http://wiki.merbivore.com/). He is the main Merb Evangelist. He has a training and consulting firm in San Diego, he was also responsible for [MerbCamp](http://www.merbcamp.com/), the first Merb event around. And he is also one of the main contributors to Merb.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/2934507309_f5973aee53.jpg)](http://www.slideshare.net/mattetti/merb-for-the-enterprise-presentation/v1)

He was kind enough to spend a long time showing me the nuts and bolts of Merb. I was not aware of its current state and I have to tell you that it is pretty compelling. Very well thought out, it has everything you need to start developing web applications with almost the same ease of use and convenience of Ruby on Rails.

Among the best things I saw in Merb is: it can be pretty close to Rails, so you will feel right at home. It has “Slices”, which is a feature that I expected Rails to have for a long time – it works almost the same way as Engines, but it is built-in and feels much better. It has a neat feature of a “master process”, so you can instruct it to load N worker processes (such as a mongrel cluster) and it will monitor those workers, so if one goes down, the master will respawn it automatically, which is pretty convenient. And finally, its modularity is top-notch. It feels weird at first having lots of gems around, but it makes sense very fast.

And according to Matt, Merb is way faster than Rails – at least in a “Hello World” benchmark :-) All in all, I highly recommend it, especially if you’re already an advanced Ruby developer that wants more (or less) than Rails can offer out of the box right now.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/21/Picture_2.png)](http://www.slideshare.net/mattetti/merb-for-the-enterprise-presentation/v1)

Download John’s audio file from [here](/files/john_straw.mp3) and Matt’s file from [here](/files/matt_aimonetti.mp3).
