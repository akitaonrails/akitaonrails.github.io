---
title: "Translation: I Don't Know What I Want, But I Know How to Get It"
date: '2008-02-10T17:18:00-02:00'
slug: tradu-o-n-o-sei-o-que-quero-mas-sei-como-conseguir
translationKey: tradu-o-n-o-sei-o-que-quero-mas-sei-como-conseguir
description: "The translation separates iterative development, which expects a solution to be validated and changed, from incremental development, which adds functionality. The point is to plan room to discover, refine, and discard."
tags:
- agile
- software-engineering
- off-topic
draft: false
---

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/patton_headshot_small.jpg)

This [article](https://web.archive.org/web/20151112195815/http://www.agileproductdesign.com/blog/dont_know_what_i_want.html) is really interesting and got me thinking. I'm an amateur when it comes to Agile techniques, and it was the first time I saw a different take on certain Agile terms, in particular "iteration" vs "incremental."

According to the profile on the author's site: **Jeff Patton** has worked with Agile techniques since 2000 and specializes in applying user-centered design techniques to improve Agile requirements, planning, and products. Some of his recent articles are at AgileProductDesign.com and in Alistair Cockburn's Crystal Clear. His next book is coming out in Addison-Wesley's Agile Development series, with tactical advice for anyone looking to deliver useful, usable, valuable software.

He currently works as an independent consultant, founded and moderates the agile-usability list on Yahoo Groups, writes columns for StickyMinds.com and IEEE Software, and won the Agile Alliance's 2007 Gordon Pask Award for contributions to Agile development.

And here is my translation of the article:


## Don't know what I want, but I know how to get it

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/johnny_rotten.jpg)](http://en.wikipedia.org/wiki/John_Lydon)

It all started with one of those weird trains of thought that come to you in the wee hours of the morning when you're half way between asleep and awake. The first lines of the Sex Pistols' [Anarchy in the UK](https://web.archive.org/web/20090523133452/http://www.lyricsfreak.com/s/sex%20pistols/anarchy%20in%20the%20uk_20123592.html) song were playing in my head. (This may be a hint at both my age, and the type and volume of music I listen to.) On that morning, [Johnny Rotten's words](https://web.archive.org/web/20090523133452/http://www.lyricsfreak.com/s/sex%20pistols/anarchy%20in%20the%20uk_20123592.html) seemed particularly wise - and seemed to precisely describe a recurring problem I've had helping people really [grok](http://en.wikipedia.org/wiki/Grok) Agile development. Shortly after declaring himself an antichrist, Johnny says:

**"Don't know what I want, but I know how to get it."**

And, why this is relevant is because I constantly run into a couple problems that make my [spider sense](http://en.wikipedia.org/wiki/Spider-Man's_powers_and_equipment#Spider-sense) tingle. In software development, have you ever heard something like this?

**"We know what we want. Can you estimate how long it will take to build?"**

If you felt a shiver, that was your spider sense tingling. The other problem goes a little like this:

**"We need to get these requirements nailed down before we can start development."**

In short strokes, I run into situations where people on the specifying side of software development, "customers" or "product owners" in Agile terms, either believe they know what they need, or feel they need to know before we can start development. What's more, I still run into a number of developers in Agile environments with the same old annoying complaint about "customers not knowing what they want" or "customers always changing their mind."

All these sentiments for me seem to spring from not knowing what "iteration" means, and is used for in Agile development.

### Iterating and incrementing are separate ideas

I most often see people in Agile development use the term **iteration**, but really they mean **increment**.

By incremental development I mean to incrementally add software a little at a time. Each increment adds more software - sorta like adding bricks to a wall. After lots of increments, you've got a big wall.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/incrementing.jpg)

By iterative development I mean that we build something, then evaluate whether it'll work for us, then we make changes to it. We build **expecting to change it.** We never expected it to be right. If it was, it's a happy accident. Because we don't expect it to be right, we often build the least we have to to then validate whether it was the right thing to build.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/iterating.jpg)

I've used the two figures above for a number of years now to help illustrate the concept. Artists work iteratively. They often create sketches, decide to create a painting, create an under-painting showing colors and form, then eventually begin finishing the painting. They stop when it's "good enough" or they run out of time or interest.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/rembrandt_paint_by_number.jpg)

Paint-by-number artists work incrementally. When I was a kid I did some pretty good paint-by-number art. The problem with paint-by-number art was that some real artist had to actually paint the thing, figure out what all the colors were, then draw all the lines and number the areas – which takes more time than just creating the painting. Using a strategy of _only_ incrementing means you more or less have to get it right the first time.

### We Iterate for multiple reasons

After talking about iteration during a talk at [XP Day 2007](https://web.archive.org/web/20080211214814/http://www.xpday.org/), someone correctly pointed out to me that it wasn't as simple as "changing things" each iteration. He pointed out that:

- we iterate to **find the right solution.**

- Then given some good candidate solution, we might then iterate to **improve a candidate solution.**

### We Increment for multiple reasons

We add to software incrementally for lots of reasons as well.

- We use incrementing to **gradually build up functionality** so _if_ development takes longer than we expect, we can release what we've incrementally built so far. ("If" is in italics because I honestly can't remember a project I've been on where development took less time than expected.)

- We release incrementally so that we actually **get that business value we're chasing**. Because, we don't really get return on investment till people begin to use the software we've built. Until then, the expected business value is just an estimate. And, if you think software development estimation is tough, try estimating return on investment.

### We conjoin iteration and incrementing

In Agile development we actually conjoin these two tactics. During a development "iteration" where we build several [user stories](https://web.archive.org/web/20071008161941/http://www.agileproductdesign.com/blog/the_shrinking_story.html) some may be adding new functionality incrementally, others may be iterating to improve, change, or remove existing functionality.

Where things really fall apart in Agile development is when no one plans to iterate.

### The gun-shy customer

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/gun_shy_customer_small.jpg)

Perhaps you've been on this Agile project:

Customers meet with the team and successfully write a number of user stories. After a lot of conversation between developers and customers, developers estimate the stories. Customers prioritize them, highest value first, and choose the most important stories for the first release scheduled after six iterations.

Development starts, and things seem to go very well. In the fantasy world this story occurs in, all the development estimates were accurate. In the first couple iterations all scheduled stories are finished. But, that's where things go wrong.

After looking at the resulting software the customer says "Now that I see this, we're missing a few things. And, although the things you've built meet the acceptance criteria, we, well.. uh… weren't really sure about that acceptance criteria and now that we see it, it needs to change."

"No problem" says the team. "Just write more stories. But, you'll have to remove some of the others from this release in order to get them done on time."

The customer's shocked and angry. "What you're saying is that I needed to get the requirements right up front! This smells just like waterfall - except without the up front time I'd need to even try to get the requirements right in the first place."

I've worked with these teams and customers many times. I know of many organizations where "Agile Development" has been labeled a process that simply doesn't work and ejected from the organization.

I know of other customers who've adapted by spending more and more time on requirements. They've introduced prolonged "Iteration 0" or "Sprint 0" phases where they actually write those big requirements. They work 1, 2, or 3 iterations ahead to really craft the details of their stories before they get introduced. They try hard to get them right. And, when inevitably they fail to get them right, they're deflated, disillusioned, disappointed - and any other "dis" you can think of.

It's not their fault. They were mislead.

### It doesn't mean what you think it means

There's a nasty little phrase Agile people often use. They often say "at the end of every iteration you'll have potentially shippable software." The commonly used [Scrum Snowman model](http://www.mountaingoatsoftware.com/scrum) that all the tens of thousands of certified Scrum Masters saw clearly says that.

| ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/scrum_snowman_model.gif) | ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/potentially_shippable_product.gif) |

In the movie the Princess Bride one of the villains exclaims "Inconceivable!" each time one of his plans is thwarted by the hero. It happens so often that one of his sidekicks says "You keep saying that word. I do not think it means what you think it means."

![](https://web.archive.org/web/20071010140455im_/http://www.agileproductdesign.com/blog/images/inigo.jpg)

_"Shippable. You keep saying that word.   
I do not think it means what you think it means."_

For a customer, someone who intends to sell or use the software, shippable means they could actually sell and use the software. This means the minimal number of features all need to be present. The software needs to be useful for its intended purpose - at least as useful as the old software or paper process it replaces. The software needs to look and behave well - have a high quality of fit and finish - particularly if this is commercial software and you've got competitors breathing down your back.

Shippable means done. Completely done and dusted. There's no need to iterate on something done - really shippable done.

Saying "shippable" to people in the customer role implies they'd better get the requirements right because that's the way Agile development works.

Now, I believe Agile people had something else in mind when they said it. I think they mean keep code quality very high. Keep the code supported with unit and acceptance tests. Take steps to validate each and every user story. It tells testers to get involved earlier and more continuously. It tells developers to develop with a higher attention to quality. (Apparently developers would be developing crap otherwise?)

### YAGRI: You aint gunna release it

I propose we, the Agile community, clarify what we mean by iterative and incremental. We need to explain to those in customer and product owner role that it's important to write user stories that they don't intend to release. To write stories that they intend to evaluate, learn from, improve, or toss out as a failed experiment.

In conversations with my friend Alistair, he proposed [writing three story cards instead of just one](https://web.archive.org/web/20080202055916/http://alistair.cockburn.us/index.php/Three_cards_for_user_rights). The first story card has the actual story on it. The second one is a placeholder for the inevitable changes to the story after we see it. The third for the fine-tuning after we see those changes.

This is an example of planning to iterate. It would relieve a lot of stress from the hand-wringing gun-shy customer worried about getting it right because the story needs to be "shippable."

### You can always get what you want, but is it what you need?

Where we can apply Sex Pistols lyrics to software development, we can't necessarily apply the Rolling Stones.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/mick_jagger.jpg)

_"You can't always get what you want. But if you try sometime,  
you just might find, you get what you need."_

In software development, sadly if you specify something, and everyone is doing their best, you'll get what you want - at least what you specified. But, is it what you need? You'll only know after you look at it and try it.

Don't listen to Mick.

In fact, try hard to not be too sure about what you want. If you leverage iteration, you'll get it even if you didn't know what it was to start with. Johnny's got it right.

"Don't know what I want, but I know how to get it."

### Please leverage the explanation if you'd like

This is a bit of the story I told during my [XP Day 2007 talk Embrace Uncertainty](https://web.archive.org/web/20101025085113/http://agileproductdesign.com/downloads/patton_embrace_uncertainty_preso_only.zip). It's rare when you get to quote Johnny Rotten, Roger Waters, Paul Simon, Pete Townsend, John Lennon, and the Spice Girls in the same talk.

Feel free to [download the talk](https://web.archive.org/web/20101025085113/http://agileproductdesign.com/downloads/patton_embrace_uncertainty_preso_only.zip).

Here's the talk [with music clips](https://web.archive.org/web/20101025085044/http://agileproductdesign.com/downloads/patton_embrace_uncertainty.zip).

Feel free to use the examples using a creative commons license. Let people know you borrowed them from me.

If you'd just like the [Mona Lisa slides](https://web.archive.org/web/20101025085108/http://agileproductdesign.com/downloads/patton_iterating_and_incrementing.ppt), you can [grab those here](https://web.archive.org/web/20101025085108/http://agileproductdesign.com/downloads/patton_iterating_and_incrementing.ppt).

The general ideas here are written in a [StickyMinds.com article](https://www.stickyminds.com/article/neglected-practice-iteration) with a little less ranting. You might share that version with your boss.

### Stay tuned

<object width="425" height="373"><param name="movie" value="http://www.youtube.com/v/4bM_l443VV4&rel=1&border=1">
<param name="wmode" value="transparent">
<embed src="http://www.youtube.com/v/4bM_l443VV4&rel=1&border=1" type="application/x-shockwave-flash" wmode="transparent" width="425" height="373"></embed></object>

If you want to get more about specific strategies for iterating sensibly in Agile development, please visit me at a tutorial I'll be teaching at a conference. Also pay attention to this site and blog as I resurrect my long overdue book from its current purgatory.

Finally, if you've read this blog in [ThoughtBlogs](https://web.archive.org/web/20080207054146/http://blogs.thoughtworks.com/) (and my web analytics tell me most of you do) this may be the last time my blog appears there. Please subscribe directly, or look for me on [ThoughtWorks alumni blogs](https://web.archive.org/web/20080222074209/http://blogs.thoughtworks.com/alumni/). I've had a great time at ThoughtWorks for the last several years, but it's time to set out on my own.

Thanks for reading.
