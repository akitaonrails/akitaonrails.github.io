---
title: "Translation: I Don't Know What I Want, But I Know How to Get It"
date: '2008-02-10T17:18:00-02:00'
slug: tradu-o-n-o-sei-o-que-quero-mas-sei-como-conseguir
tags:
- off-topic
- principles
- agile
- management
- career
draft: false
translationKey: i-dont-know-what-i-want
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/patton_headshot_small.jpg)

This [article](http://www.agileproductdesign.com/blog/dont_know_what_i_want.html) is very interesting and left me intrigued because I — an amateur in Agile techniques — saw for the first time a different approach to explaining certain Agile terms, in particular "iterating" vs "incrementing."

According to his site profile: **Jeff Patton** has been focused on Agile techniques since 2000 and has specialized in applying user-centered design techniques to improve Agile requirements, planning, and products. Some of his more recent articles can be found at www.AgileProductDesign.com and in Alistair Cockburn's Crystal Clear. His upcoming book will be released in Addison-Wesley's Agile Development series and will offer tactical advice for those looking to deliver useful, usable, valuable software.

He currently works as an independent consultant, is the founder and moderator of the agile-usability list on Yahoo discussion groups, a columnist at StickyMinds.com and IEEE Software, and the 2007 Gordon Park Award winner from the Agile Alliance for contributions to Agile development.

Here is my translation of the article in question:


## I Don't Know What I Want, But I Know How to Get It

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/johnny_rotten.jpg)](http://en.wikipedia.org/wiki/John_Lydon)

It started with one of those strange thought-training moments that come to you when you're halfway between sleeping and waking. The opening lines of the Sex Pistols song [Anarchy in the UK](http://www.lyricsfreak.com/s/sex+pistols/anarchy+in+the+uk_20123592.html) were playing in my head. (That might be a clue about both my age and the type and volume of music I listen to.) That morning, [Johnny Rotten's words](http://www.lyricsfreak.com/s/sex+pistols/anarchy+in+the+uk_20123592.html) seemed particularly wise — and seemed to perfectly describe a recurring problem I've been struggling with helping people truly [understand](http://en.wikipedia.org/wiki/Grok) Agile development. Shortly after declaring himself an anti-christ, Johnny says:

**"I don't know what I want, but I know how to get it."**

And that's relevant because I constantly run into problems that make my [spider sense](http://en.wikipedia.org/wiki/Spider-Man's_powers_and_equipment#Spider-sense) tingle. In software development, have you ever heard something like this?

**"We know what we want. Could you estimate how long it will take to build?"**

If you felt a chill down your spine, that was your spider sense tingling. The other problem goes something like this:

**"We need to finalize the requirements detail before we start development."**

In short, I keep running into situations where the people on the specification side of software development — "customers" or "product owners" in Agile terms — either believe they know what they need, or feel they need to know before we can start developing. On top of that, I still bump into all sorts of Agile environments with the same old boring complaint about "customers who don't know what they want" or "customers who keep changing their minds."

All of these feelings, to me, seem to arise from not understanding what "iteration" means and how it's used in Agile development.

### Iterating and Incrementing Are Separate Ideas

I often see people in Agile development use the term **iterate**, when they really mean **increment**.

By incremental development I mean incrementally adding software piece by piece. Each increment adds more software — sort of like adding bricks to a wall. After several increments, you have a big wall.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/incrementing.jpg)

By iterative development I mean that we build something, then evaluate whether it will work for us, then make changes. We build **expecting to change.** We never expect to get it right the first time. If we do get it right, that's a happy accident. Because we don't expect to get it right, we normally do the minimum necessary to validate whether it was the right thing to do.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/iterating.jpg)

I've used these two figures for several years to help illustrate the concept. Artists work iteratively. They typically create sketches, decide to create a painting, create an overpaint showing colors and shapes, then eventually begin finishing the painting. They stop when it's "good enough" or when they run out of time or interest.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/rembrandt_paint_by_number.jpg)

Paint-by-numbers artists work incrementally. When I was a child I made some great paint-by-numbers art. The problem with paint-by-numbers is that some real artist had to actually paint the thing, understand what all the colors were, then draw all the lines and number the areas — which takes more time than just creating the painting. Using a _only_ incremental strategy means more or less having to get it right the first time.

### We Iterate for Multiple Reasons

After talking about iteration during [XP Day 2007](http://www.xpday.org/) someone correctly pointed out to me that it wasn't as simple as "changing things" in each iteration. He pointed out that:

- we iterate to **find the right solution.**

- then, given a good candidate solution, we iterate to **improve that candidate solution.**

### We Increment for Multiple Reasons

We incrementally add to software for several reasons too.

- We use incrementing to **gradually build functionality** so that _if_ development takes longer than expected, we can release what we've incrementally built so far. ("If" in italics because I honestly can't remember a project where development took less time than expected.)

- We release incrementally so that we actually **get the business value we're seeking**. Because we don't really get return on investment until people start using the software we built. Until then, the expected business value is just an estimate. And, if you think software development estimation is hard, try estimating return on investment.

### We Combine Iteration and Incrementing

In Agile development we really combine both tactics. During a development "iteration" where we build several [user stories](http://www.agileproductdesign.com/blog/the_shrinking_story.html) some may be incrementally adding new functionality, while others may be iterating to improve, change, or remove existing functionality.

Where things really go wrong in Agile development is when nobody plans to iterate.

### The Gun-Shy Customer

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/gun_shy_customer_small.jpg)

Maybe you've been on Agile projects like this:

Customers meet with the team and successfully write several user stories. After much discussion between developers and customers, the developers estimate the stories. The customers prioritize them, highest value first, and choose the most important stories for the first release, estimated at six iterations out.

Development starts and things seem to be going well. In a fantasy world where this story could occur, all development estimates were accurate. In the first iterations all scheduled stories are completed. But that's when things go wrong.

After looking at the software the customer says "Now that I see this, it's missing some things. And even though the things you built match the acceptance criteria, we, well... hmm... weren't very sure about the acceptance criteria and now that we see it, this needs to change."

"No problem," says the team. "Just write more user stories. But you'll need to take some others out of this release so we can finish on time."

The customer is shocked and nervous. "What you're saying is that I need to have requirements right up front!! This smells like waterfall — except without the up-front time I'd need to at least try to get the requirements right from the start."

I've worked with these teams and customers many times. I know many organizations where "Agile Development" has been labeled a process that simply doesn't work and has been ejected from the organization.

I know other customers who adapted by spending more and more time on requirements. They introduced extended "Iteration 0" or "Sprint 0" phases where they actually write out those big requirements. They work 1, 2, or 3 iterations ahead to really nail down the details of their stories before they're introduced. They try hard to get them right. And when they inevitably fail to get them right, they become deflated, disillusioned, disappointed — and various other "dis-" words you can imagine.

It's not their fault. They were misdirected.

### That Word Doesn't Mean What You Think It Means

There's a miserable little phrase that Agile people use frequently. They often say "at the end of each iteration you'll have potentially shippable software." The commonly-used [Scrum Snowman model](http://www.mountaingoatsoftware.com/scrum), which the tens of thousands of certified Scrum Masters have seen, clearly states this.

| ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/scrum_snowman_model.gif) | ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/potentially_shippable_product.gif) |

In the film "The Princess Bride" one of the villains exclaims "Inconceivable!" every time one of his plans is foiled by the hero. This happens so frequently that one of his partners says "You keep using that word. I do not think it means what you think it means."

![](http://www.agileproductdesign.com/blog/images/inigo.jpg)

_"Shippable". You keep using that word.  
I don't think it means what you think it means._

To a customer, someone who intends to sell or use the software, 'shippable' means they could actually sell or use the software. It means the minimum number of features are all present. The software needs to be useful for its intended purposes — at least as useful as the old software or paper process it replaces. The software needs to look and behave well — have high quality fit and finish — particularly if it's commercial software and you have competitors breathing down your neck.

Shippable means finished. Completely done and polished. There's no need to iterate on something that's truly done — really done and shippable.

Saying "shippable" to people in the customer role means telling them it's good that they got requirements right because that's how Agile development works.

Now, I believe Agile people had something else in mind when they said this. I think they meant keeping code quality very high. Keeping code backed with unit and acceptance tests. Taking care to validate each user story. That tells testers to stay involved early and more continuously. That tells developers to develop with high attention to quality. (Apparently developers would build crap otherwise?)

### YAGRI: You Ain't Gonna Release It

I propose that we in the Agile community be clear about what we mean by iterative and incremental. We need to explain to these customers and product owners that it's important to write user stories that are not intended to be released. To write stories that they intend to evaluate, learn from, improve, or throw away as failed experiments.

In conversations with my friend Alistair, he proposed [writing three user story cards instead of just one](http://alistair.cockburn.us/index.php/Three_cards_for_user_rights). The first card has the actual story on it. The second is a placeholder for the inevitable changes to the story after we see it. The third for refinements after we see the changes.

This is an example of planning to iterate. This could take a lot of stress off the shaking hands of gun-shy customers worried about getting it right because the story needs to be "shippable."

### You Can Always Get What You Want, But Is It What You Need?

Where we apply Sex Pistols lyrics to software development, we can't necessarily apply the Rolling Stones.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/mick_jagger.jpg)

_"You can't always get what you want. But if you try sometime,  
you just might find, you'll get what you need."_

In software development, unfortunately if you specify something and everyone does their best, you'll get what you want — at least what was specified. But is that what you need? You'll only know after you look at it and experience it.

Don't listen to Mick.

In fact, try very hard not to be too certain about what you want. If you leverage iteration, you'll get what you need even if you didn't know what it was to begin with. Johnny was right.

"I don't know what I want, but I know how to get it."

### Please Leverage the Explanation If You'd Like

This is a story I told during the [Embrace Uncertainty talk at XP Day 2007](http://www.agileproductdesign.com/downloads/patton_embrace_uncertainty_preso_only.zip). It's rare when you need to cite Johnny Rotten, Roger Waters, Paul Simon, Pete Townsend, John Lennon, and the Spice Girls in the same talk.

Feel free to [download the presentation](http://www.agileproductdesign.com/downloads/patton_embrace_uncertainty_preso_only.zip).

Here's the presentation with [the musical clips](http://www.agileproductdesign.com/downloads/patton_embrace_uncertainty.zip).

Feel free to use the examples under the Creative Commons license. Let people know you borrowed from me.

If you liked the [Mona Lisa slides](http://www.agileproductdesign.com/downloads/patton_iterating_and_incrementing.ppt), you can [get them here](http://www.agileproductdesign.com/downloads/patton_iterating_and_incrementing.ppt).

The general ideas here are written up in an [article on StickyMinds.com](http://www.stickyminds.com/sitewide.asp?ObjectId=13178&Function=DETAILBROWSE&ObjectType=COL&sqry=%2AZ%28SM%29%2AJ%28COL%29%2AR%28createdate%29%2AK%28colarchive%29%2AF%28%7E%29%2A&sidx=2&sopp=10&sitewide.asp?sid=1&sqry=%2AZ%28SM%29%2AJ%28COL%29%2AR%28createdate%29%2AK%28colarchive%29%2AF%28%7E%29%2A&sidx=2&sopp=10) with a little less complaining. You can share that version with your boss.

### Stay Tuned

<object width="425" height="373"><param name="movie" value="http://www.youtube.com/v/4bM_l443VV4&rel=1&border=1">
<param name="wmode" value="transparent">
<embed src="http://www.youtube.com/v/4bM_l443VV4&rel=1&border=1" type="application/x-shockwave-flash" wmode="transparent" width="425" height="373"></embed></object>

If you want to know more about specific strategies for iterating sensibly in Agile development, please come visit me at a tutorial I'll be teaching at a conference. Also watch this site and the blog as I resurrect my old book from purgatory.

Finally, if you read this blog on [ThoughtBlogs](http://blogs.thoughtworks.com/) (and my web analytics tell me many of you came from there) this may be the last time my blog appears there. Please subscribe directly, or find me at the [ThoughtWorks alumni blogs](http://blogs.thoughtworks.com/alumni/). I've had a great stay at ThoughtWorks over the last few years, but it's time to fly solo.

Thanks for reading.
