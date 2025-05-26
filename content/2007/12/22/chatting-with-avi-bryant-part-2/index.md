---
title: Chatting with Avi Bryant - Part 2
date: '2007-12-22T20:36:00-02:00'
slug: chatting-with-avi-bryant-part-2
tags:
- interview
- english
draft: false
---

If you didn’t read it, take a look at [Part 1](/2007/12/15/chatting-with-avi-bryant-part-1) where we get to know more about Avi Bryant and his amazing product [Dabble DB](http://www.dabbledb.com). In **Part 2** Avi goes a little bit more in elaborating his technology opinions and points of view. It’s a very insightful reading for every programmer.

As I always say – and Avi is competent pointing out -, Ruby has its drawbacks – most of them being improved on Ruby 1.9, JRuby and Rubinius. Avi gives us good reasons why Smalltalk is yet another great platform to learn, bringing back decades of evolution and maturity. So, here goes, the unabridged version of the interview.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/539949594_f012918cd3.jpg)

And stay tuned! I hope to have Evan Phoenix, Hal Fulton, Peter Cooper and Adrian Holovaty as my next guests. Lot’s of material to begin 2008 in great style.


 **AkitaOnRails:** Some people still try to make the case in favor of Smalltalk as it being the _“purest OO language out there”_. Even this being a fact, do you think that this alone is compelling enough to make a case against every other language, like Ruby which is kind of a multi-paradigm language? I hope you’re not pesky about ‘language pureness’ :-)

**Avi Bryant:** Actually, I am pesky about it – not from an academic or aesthetic point of view, but from a pragmatic one. “Pure” languages make a lot of things easier: development tools, VMs, and infrastructure like distributed object systems or transparent persistence all get much simpler and better when you have a small, consistent language.

One experience I had, for example, was being hired to port my client library for the GOODS object database from Smalltalk to Python; I spent a huge amount of time dealing with special cases in the Python semantics (is this a class? a type? a new-style class? implemented in python or in C?) that simply never came up in Smalltalk.

Ruby does pretty well here, better than most in the scripting language space – I wouldn’t call Ruby “multi-paradigm”, by the way – but it could stand to do better.

**AkitaOnRails:** I think you once said that you only consider a language “finished” when it is fast enough to extend itself. This is very true for Smalltalk, Java and other platforms. Ruby is undoubtedly lacking in its current position. That was one of the reasons we now have parallel efforts like John Lam’s IronRuby, Charles and Thomas’ JRuby and Evan’s Rubinius. One of the most criticized points is that Ruby doesn’t have a formal spec for the language or its core libraries. You also said that the Java VM is not suited enough for Ruby as Strongtalk would be, for example. Does this still hold today as we see JRuby 1.1 in the horizon?

**Avi Bryant:** It still holds. JRuby currently seems to benchmark on par with MRI, and the best numbers from any Ruby implementation are maybe 3X MRI on average. I think we can do **25X MRI** for basic language feature benchmarks (message sends, block evaluation, etc), which should be enough to make Ruby implementations of the standard libraries feasible. Even if the net result was a similarly performing system, the side benefits would be extremely valuable.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/200126067_a2fc0a9fec.jpg)

**AkitaOnRails:** I remember that you started the [Smalltalk.rb](http://rubyforge.org/projects/smalltalk/) initiative a while ago, and if I am not mistaken it was an effort to make Ruby translate into equivalent Smalltalk code so it could run in any of the available Smalltalk VM implementations out there. Is this project still going on, do you still think it is feasible to pursue such a goal?

**Avi Bryant:** I still think it’s a worthwhile and realistic goal. The project is still going in the sense that I’m still taking to people about how to make this happen, but I’m not able to spend time writing code for it myself at the moment. I have some reason to hope this project will progress more concretely next year, but we’ll see.

**AkitaOnRails:** Some time ago I read a snippet of an IRC transcript between you, Evan, Chad and even Charles. You started talking about standardizing primitives (they are C-based in MRI today). My bet is that Rubinius is the project destined to be the “next big thing” for the Ruby community. To me it seems that you and Evan collaborate a lot, is that correct?

**Avi Bryant:** I wouldn’t say that, but [Rubinius](http://rubini.us/) is certainly the Ruby project that most closely aligns with my own interests and goals at the moment, and it’s great to see how much effort is being put into it. Engine Yard also deserves a lot of kudos for their financial support of the project.

I have high hopes that the work Evan and crew are doing will be of great benefit not just to Rubinius but to all of the Ruby implementations – which is why I was advocating for a standard primitive set.

**AkitaOnRails:** You know a lot of people, I wonder if you ever talked with Koichi Sasada himself to input some of your ideas for the YARV project as it’s going to be the “official” Ruby virtual machine out there a few months from now.

**Avi Bryant:** No, I don’t believe we’ve never spoken. I would certainly love to meet him some day.

**AkitaOnRails:** Then, we get one level up to applications. Your Seaside framework is pretty amazing. You’re very right about [WebObjects](http://developer.apple.com/tools/webobjects/) as well. As a Java programmer I always pitied that it never got mainstream. Today it’s mostly relegated to Apple related websites, while lesser Java frameworks took the front. Tapestry and Cayenne are trying to top WebObjects’ features but seems they are nowhere near yet. Do you still program some Java? What are your opinion on current mainstream frameworks as Spring, JSF? For non-starters, what was it in WebObjects that makes it different than the rest?

**Avi Bryant:** I don’t do any work in Java any more (thankfully), so I can’t really give a qualified opinion on the state of frameworks there right now. However, the main thing I think WebObjects did right was to focus on the state and behavior of the application, rather than on the mechanics of URLs and HTML and HTTP requests.

So rather than worry about what a field was named, you would just say _“this field is bound to this instance variable in my model”_, and rather than worry about what URL a link went to, you’d say _“this link triggers this method on my page object”_.

Transitioning between pages was done by constructing a new page object and setting it up directly in Java, rather than constructing a URL that was going to be parsed to build a page. That directness and general style is something that very heavily influenced Seaside.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/504096000_40e4e00b75.jpg)

**AkitaOnRails:** Many people may not immediately understand as it as a word that is new to most of them: _“continuations”_. Meaning that instead of manually controlling the flow between events, with manual marshaling and unmarshaling of objects, you program as a cohesive and continuing flow. Can you explain this in a way that a novice would understand? What are the benefits and drawbacks of this approach?

**Avi Bryant:** Well, it’s really all about being able to get modal behavior in a web app. In a desktop application, for example, you might occasionally have a call like _“file = chooseFile()”_ or _“color = pickColor()”_ that opens a modal dialog, gets a result from the user, and keeps going from there.

Seaside’s use of continuations is just to allow exactly that kind of interaction in the context of the web. The tricky bit is that because of the backbutton, the user might go pick a different color from the same dialog later, and the _“pickColor()”_ call has to return a second time. This is confusing to think about, but mostly it Just Works.

From an implementation point of view, what we’re doing is saving a copy of the stack at the point the call is made so that we can come back to it later, more than once if need be.

**AkitaOnRails:** You started these concepts in the Ruby land with IOWA. Once upon a time there was a framework called Borges that was also discontinued. Then Koichi mentioned taking continuation support from the next Ruby. Do you think the Ruby land is giving a step back with lack of support for continuations?

**Avi Bryant:** Continuations are a great abstraction, and allow a lot of interesting experimentation with language semantics. However, I wouldn’t consider it a tragedy if they disappeared from Ruby; there are more important things to worry about. From a web perspective, I think that AJAX is starting to replace a lot of the use cases where having server-side modal logic used to be important – Dabble DB, for example, **barely** uses Seaside’s continuation features at all.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/106824107_67074eaf0b.jpg)

**AkitaOnRails:** Your blog has a peculiar name, [HREF considered harmful](http://www.cincomsmalltalk.com/userblogs/avi/View.ssp). You probably got your inspiration from Edsger Dijkstra/Niklaus Wirth’s [Goto Statement Considered Harmful](http://en.wikipedia.org/wiki/Considered_Harmful) paper where Edsger made his famous case against GOTO. At the assembler level it is impossible to not JMP all the time (at least not without some macro help) but at a C level you can avoid GOTO’s altogether. Even Basic had both GOTO and GOSUB and you could just ignore the former. I am being simplistic here, but now you’re kind of saying that URLs play a similar role in a way that they disrupt the normal flow, going back in unpredictable ways and so on. On the other hand the Internet would not be what it is without URLs. How do we deal with this conundrum?

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/461207306_3f23831032.jpg)

**Avi Bryant:** I don’t think it’s a conundrum. I think your analogy is a good one: it’s impossible to not JMP all the time, and it’s also impossible not to use URLs all the time, but we don’t have to always be aware of either one. Back when everyone wrote in assembler, people probably obsessed about having meaningful or “pretty” JMP labels the same way they obsess about having pretty URLs today. I think we need to allow ourselves to make the same leap up in abstraction level on the web that we did with higher level programming languages.

That’s not to say we should **never** be thinking about URLs: any website needs to export meaningful URLs to be referenced and used externally, just like any C library needs to export meaningfully labelled function names so that it can be linked into other programs. But that’s as far as it needs to go.

**AkitaOnRails:** Components were a big deal in the early 90’s, with RAD tools and so forth. Today it seems that they are showing up slowly, with initiatives as JSF and ASP.NET. Rails initially packed a very crude support for ‘components’ but it was dropped very early on as a bad thing (because of the jury rigged way it was implemented). Nothing new came to replace it what feels like there wasn’t enough need for it at the Rails level. On the other hand Seaside is heavy in componentization. Can you expose a little bit about the differences in this approach?

**Avi Bryant:** “Component” is one of those terms like “MVC” or “open” that gets used to mean so many different things it’s hard to talk seriously about it. One concrete feature of Seaside’s approach is that each piece of UI is quite independent of what other pieces of UI may be on the page.

There’s no central controller which is responsible for request processing, choosing a template, or so on – all of those responsibilities are distributed among many smaller objects. There’s also no chance of naming conflicts because you don’t directly name links or form fields, so you can have many copies of the same form/widget/etc on the same page without any confusion.

This allows a level of modularity that’s very hard to reproduce in most traditional frameworks.

**AkitaOnRails:** Another thing that might shock some people is that there is no traditional templating system in Seaside, no code mangling between HTML tags all over the place. Instead all HTML is abstracted in a object hierarchy that renders itself. In the Rails world there are a few alternatives that attempts some of that like HAML, Markaby. What do you think are the fundamental differences?

**Avi Bryant:** The HTML rendering API is a very core piece of Seaside, and a huge amount of the framework was designed with that underlying approach in mind. I think that’s the main difference when compared with HAML or Markaby, which are meant to be dropped into other frameworks.

Once you get rid of templates and switch to programmatic HTML generation, the design space just completely changes, and you need to re-evaluate almost every other decision that you made – this was a process that I went through with Seaside between the initial release, which used templates, and the 2.x versions, which don’t.

So I think we’ll have to see a framework that takes, say, Markaby as a starting point and asks “where can we go from here” before we can make any real comparisons.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/627957460_48e4181526.jpg)  
with Adrian Holovaty, from Django fame

**AkitaOnRails:** You also touted the shared-nothing vs share-all dilemma. And you obviously have a strong case because this is not just techno-babble but you do have a successful product running on top of that vision. Do you still think it pays off to sacrifice a little bit of performance for more clean code and productivity? In a way it’s sort of what DHH himself said about Rails when people said it was slower than PHP or Perl. Actually this also has to do with your talk as being a “heretic” in a way that you’re doing things in a different way than we all are now. Can you elaborate on that?

**Avi Bryant:** _“Share nothing”_ is great advice for making the maximum use of your server resources. For sites like yahoo.com or Facebook, that’s clearly very important because your business depends on serving millions of users every day.

_“Share everything”_ is really hard on your servers, but it makes maximum use of your developer resources. For a startup like Dabble DB, where we have 4 developers, that’s really important. And since our revenue model only requires serving thousands of users every day, not millions, it’s ok to spend a little more per user on server hardware. It’s been a very worthwhile tradeoff for us.

**AkitaOnRails:** And speaking of DHH, you probably met in several occasions. You’re both opinionated guys with antagonist visions. Smalltalk vs Ruby. Seaside vs Rails. Share-all vs Share-nothing. One could feel tempted to draw you two as Superman vs Batman kind of dispute. Though I know that smart people don’t fight over pesky stuff. What do you think of him and his ideas, how do you think both communities could cooperate if there’s any chance for that?

**Avi Bryant:** I have a lot of respect for David. The only time I’ve felt antagonistic towards him was this last summer at Foo Camp. We were playing a game of [Werewolf](http://en.wikipedia.org/wiki/Mafia_(game)), and I was a werewolf and he was a villager. Now, as a werewolf the best thing you can do is get the person nearest you to trust you, and that happened to be DHH. And it worked – Kevin Rose was totally on to me but David managed to persuade him not to lynch me, and I ate them both and won the game. Pn3d!

Anyway. There’s probably a lesson in there somewhere. Also, in a fight between me and DHH, [Neal Stephenson](http://en.wikipedia.org/wiki/Neal_Stephenson) would win.

**AkitaOnRails:** Finally, Brazil still has a young and growing community. Any closing regards for our audience?

**Avi Bryant:** OlÃ¡ and good luck! I’ve been told Rio is even more beautiful than my home of Vancouver, and I hope to visit some day.

[![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/1057077803_3bd0155620.jpg)](http://twit.tv/floss21)   
_Don’t miss the TWiT podcast interview with Avi!_

