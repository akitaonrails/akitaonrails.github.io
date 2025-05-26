---
title: The Ruby Community and Reputation
date: '2016-08-19T11:02:00-03:00'
slug: the-ruby-community-and-reputation
tags:
- community
- rails
- ruby
- ranting
draft: false
---

I've just read the posts from [Adam Hawkins](http://hawkins.io/2015/05/the-ruby-community-the-next-version/) and the support from [Alan Bradburne](http://www.alanbradburne.com/Rubys-reputation) over Ruby Weekly.

As a disclaimer, I don't know them, and I respect their points of view, it's not supposed to start a flame war, just to paint an alternative point of view.

Both articles represent the point of view of many veteran Ruby developers in this community. Some of whom already left to other technologies or stopped public appearances.

I already made my stand very clear in the ["Rails has Won: The Elephant in the Room"](http://www.akitaonrails.com/2016/05/23/rails-has-won-the-elephant-in-the-room). But let me simplify here.

There is clearly a faction being formed. Apart from great developers like Solnic (dry-rb), Nick (Trailblazer), and Luca (Hanami), most people are complaining that Rails and some of the closest pieces of the ecosystem around it don't conform to their newly found vision of what "good" should be.

In their view of the world, a "better" Rails should be way simpler, way more explicit, composed of super small libraries, super explicit external APIs, and super composability to take it apart back and forth.

And here lies my problem: if DHH complied and took that direction, that would be "Ruby OFF the Rails." The whole point of "Ruby **ON** Rails" is precisely because it is defined by being a coherent, opinionated full stack with coarse-grained libraries that are meant to work together in tandem.

Let me present the true Elephant in the Room:

* Discussions like this are just inflammatory link baits. They serve no point but create a cloud of animosity against something without actually presenting an objective good alternative. Writing bullet points is easy, but writing complete solutions and maintaining them is not.

* There are indeed good alternatives popping up already, such as the aforementioned Trailblazer, Hanami, and the dry-rb collection of libraries, just to name a few. The complaint is that they don't have as much traction right now. What's the solution? Bad-mouthing Rails? Writing ranting articles of how life is unjust? Or, actually, are you writing more tutorials on how to use Trailblazer? Recording screencasts on how to use Hanami? Going to a conference and presenting more talks on importing dry-rb into your projects?

* Ruby on Rails was meant for programmers tired of super composability, super configuration, super explicit, super fine-grained libraries. It was meant for Java programmers coming out straight from the nightmare that was J2EE 1.x in 2004, remember that? Now, the "proposal", is to go back to that? Waste enormous amounts of time fine-tuning your tailor-made mini-stack? We have that already. It's called Javascript. And let me tell you: configuring the current breed of `package.json` brings me back really bad memories from `pom.xml`, `hibernate.cfg.xml` to `struts-config.xml`.

* Beginners are not interested in fine-grained solutions. Most people forget how it was to be a beginner. Actually, I'd argue that 80% of the world's developers benefit greatly from a Rails-like approach. It's no coincidence that many platforms conformed to an opinionated, convention-over-configuration approach after it proved its point.

The fact that people are complaining against Rails makes it feel like it is Rails fault somehow. Actually not, it's just a reflection of the frustration of the very people that **failed** (and are failing) to pitch the alternatives. Everybody wants a free lunch.

Let me tell you a short story.

Back in 2005 I was the only Rails developer I knew in my country (Brazil). I googled around and found perhaps half a dozen other hobbyists doing Ruby for fun, and a couple are doing it professionally already.

People would make fun of us everywhere I looked because they thought we were just crazy. _"Of course, J2EE is the way to go." "Of course, every project should conform to Eric Evan's DDD approach." "Of course, every project should conform to all of the Gang of Four's Design Patterns, the more, the merrier." "Of course, we should have very isolated deployment packages with very explicit API boundaries between them, no matter how it makes productivity decrease."_

We've been there before. In 2004, I already had more than ten years of experience in professional programming.

It took me another ten years of pilgrimage. 9 years organizing my own conference. More than 1,000 blog posts. Almost 200 talks, several of which I paid from my own pocket to buy bus and airplane tickets. I put my money where my mouth was.

The promise was to replace all the complexity and bureaucracy with an opinionated stack where most of the basic decisions were already made. It would be out of our way so we could focus on the most important part: the business.

<div class="video-container">
    <video controls>
        <source src="https://s3.us-east-2.amazonaws.com/blip.tv/Java_is_not_evil.mp4" type="video/mp4">
        Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Java_is_not_evil.mp4)
    </video>
</div>

Every talk I pitched to Rails since 2006 had the above section. And with every single person who ever watched any of my talks as my witness, I always said:

> "Many of you have heard that Java is bad because it's so complex and so bureaucratic. And many will try to pitch their alternatives at the expense of Java. Not us. We embrace what Java has to offer. Solr, Elasticsearch, and Hadoop are all made with Java. What will we do? Rewrite everything in Ruby? Of course not. For Rails to Win, Java doesn't have to Lose." (I put the "evil edition" image on fire, on stage).

I wrote an article (in pt-BR, sorry) in October of 2007 titled ["For me to win, the other has to lose ..."](http://www.akitaonrails.com/2007/10/23/para-eu-ganhar-o-outro-precisa-perder) where I explained why this way of thinking is so lame. I also took inspiration from the famous 1998 Macworld talk by Steve Jobs, where he called Bill Gates on stage, on the big screen, to announce their collaboration. The Apple fans went nuts, they were horrified by that sight, it was like sleeping with Satan.

Almost 20 years later, Apple is one of the most valuable companies in the world. Because it didn't matter. Jobs left pure ideology behind and became pragmatic. They needed Microsoft's endorsement, got it, and proved their points by results: they spent the 90s masturbating over why classic OS 7 to 9 were better than Windows 3.1 up to NT 4. But it took them ten years to prove the worth of OS X over the first decade of the 21st century. One step at a time, one release after the other, frequently delivering instead of spending years closed in the labs until the "perfect" solution arose. Baby steps. It culminated when they squeezed OS X into iOS in 2007.

That's how you prove a point: through sheer pain and sweat, by putting it out there in the streets, pitching it, selling it, and creating true value one small release at a time.

And then this happened:

![Macbooks everywhere](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/559/big_mac-school.jpg)

Remember when Apple took over the world? One entire decade to come back from [bleeding 1 billion a year](http://money.cnn.com/1998/10/14/technology/apple/) up until becoming the [most valuable company in the world](http://fortune.com/2016/02/03/apple-facebook-amazon-google/), whose effects are still going on 5 years after Jobs' passing.

Some of us understand that engineers want to masturbate over irrelevant things.

> "- My algorithm runs 0.1 milliseconds faster than yours".

> "- Ha, but my design has fewer dependency points than yours!"

Rails did to Ruby what Apple did to Unix and Canonical did to Linux-based distros. People complaining about Rails remind me of people trying to argue why Archlinux is way superior to OS X or Ubuntu, but it's just that people in general are stupid not to perceive that value.

And for some, it's not exactly flattering to be in the same league as Apple or Canonical, but the results are undeniable.

Remember the legendary "15-minute blog"? Why did it surprise us so much in 2005? It was not what Rails could do; it was all the work we didn't need to do. And Rails has stayed true to that until now.

If you're a beginner programmer, Rails still has plenty to teach, and you can learn the details later.

If you're the average programmer, Rails' ecosystem will take you from point A to point B much faster, with better productivity and maintainability.

Why are you complaining if you're the tech star programmer funded by a unicorn?

Programmers ranting are not following one of our own old favorite quotes: "Premature Optimization is the Root of All Evil." And as the "UNIX way" already had:

> The strategy is definitely:

> Make it work,

> Then make it right,

> and, finally, make it fast.

There is nothing wrong with having alternatives to Rails, but the Rails bashing is getting very old very fast. It's difficult to pitch alternatives, I know. I've spent many show soles in the last 10 years advocating Ruby, so I really know it.

I never believed in free lunch. I believe in targeted, hard work, and that's been my philosophy for the last 25 years in programming.
