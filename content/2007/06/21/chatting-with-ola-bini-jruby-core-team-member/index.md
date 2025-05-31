---
title: Chatting with Ola Bini (JRuby Core Team Member)
date: '2007-06-21T20:58:00-03:00'
slug: chatting-with-ola-bini-jruby-core-team-member
tags:
- interview
- english
draft: false
---



Its been a few days already, since the historical release of JRuby 1.0, the first stable implementation of an alternative Ruby interpreter. And what other platform than Java to hold the power of Ruby?

Meet **Ola Bini** , a young, dynamic and important contributor to this amazing project. Ola is member of the JRuby Core Team and currently work at ThoughtWorks to help assure the continuing success of JRuby.

I had the opportunity to chat for more than an hour with him. So, another great interview for our website.

![](/files/511173503_15ef7dc203.jpg)

**AkitaOnRails** : Hi. Ola, you’re ready?

**Ola Bini** : Hi there. Yeah, sure, let’s get started!

**AkitaOnRails** : Super! First of all, thank you very much for accepting my invitation, I understand you’re very busy. And that’s exactly why it will be interesting to talk to you, as you’re involved in a lot of exciting stuff.

**Ola Bini** : hehe. Yeah, hopefully I’ll be able to tell you about it too.

**AkitaOnRails** : Now, second, congratulations for both the achievement of the release of JRuby 1.0 and of you moving to London and becoming a [Thoughtworker](http://ola-bini.blogspot.com/2007/03/thoughtworks.html).

**Ola Bini** : Thank you! I’m very happy about both occurences.

**AkitaOnRails** : I always start my interviews with a little overview on the origin of the programmer, or how did you get into the tech world. Young programmers have lots of questions and doubts and I think this helps getting them in perspective. Could you tell us how you started? What made you choose programming?

**Ola Bini** : Well… I guess my father was an influence. I started programming Basic on an Apple IIc when I was 7 or 8 years old. I had fun from the beginning, so my father helped me out, he gave me my own computer and so on. So basic was what I did first, but C was the first real programming language I learned and actively used.

**AkitaOnRails** : Game programming?

**Ola Bini** : Yeah, game programming and demo programming the first few years. Picked up C, most of C++, Assembler and Pascal before I was 16. I actually dropped out of High School, since I got an offer to work as a programmer in Stockholm, which is how I started doing it professionally.

**AkitaOnRails** : Just for fun?

**Ola Bini** : Yes, the game and demo programming was just for fun.

**AkitaOnRails** : Oh, so you started working on programming very early in your life.

**Ola Bini** : Yes. I got a full time job programming Java at the age of 18.

**AkitaOnRails** : So you jumped very fast from C to C++, Pascal and Java.

**Ola Bini** : Yes. Java was easy after C and C++. Pascal I never really liked, but I had to learn it since most tutorials about graphics programming used it.

**AkitaOnRails** : So your first job was around graphics?

![](/files/img1098574794.jpg)

**Ola Bini** : Actually not. It was web programming with Java, JSP, PHP, ASP and other such technologies, for a department of [Karolinska Institutet](http://ki.se/), doing web systems for distance learning.

**AkitaOnRails** : Yes, by the way, you mentioned Stockholm. Are you from there? Sweden?

**Ola Bini** : No, I’m from a small place called Kode, which is about 60km north of Gothenburg. Yes, I’m from Sweden. Moved to Stockholm at 18.

**AkitaOnRails** : Wow, I believe your parents were very shocked having you dropping school to work so early. Have you ever graduated?

**Ola Bini** : Well, not shocked really. I didn’t really learn much during that school period, so it didn’t come as a surprise to my parents. And nope, no graduation for me.

**AkitaOnRails** : And I believe this was the 2000 internet bubble era? As you mentioned web tools.

**Ola Bini** : Actually, it was 2001, directly after that bubble, so I was lucky to get a job.

**AkitaOnRails** : I see. You have a lot of Java background, how did you start working on Java? And how did you become interested in Ruby?

**Ola Bini** : Yes, I’ve never been fond of Java as a language, and I’ve always been interested in other languages. So I learned [Lisp](http://en.wikipedia.org/wiki/Lisp_programming_language) quite early and fell in love with it. A few years back, 3 or 4 I think, I discovered Ruby and tried to convince my employer that we should replace various perl and bash scripts in our environment with Ruby. That didn’t work so well, but I continued talking about Ruby and using it in my spare time, and one and a half year ago they finally caved in, we made a Rails pilot and it was a clear success.

**AkitaOnRails** : Was there any particular event that led you to Ruby, or you found it by accident?

**Ola Bini** : I think it was accident. Especially since I don’t remember the exact point of it at all.

**AkitaOnRails** : Lisp has a completely different [heritage](http://www.levenez.com/lang/history.html) from structured languages like C. I guess you liked the [functional](http://en.wikipedia.org/wiki/Functional_programming) aspect of it?

**Ola Bini** : Yes. And the malleability. I’m very fond of the macros in [Common Lisp](http://en.wikipedia.org/wiki/Common_Lisp), and also like the very no-nonsense structure of a Lisp program. The fact that there is no real division between data and code. The functional aspects are pleasing, but not the main reason for my like of it.

![](/files/510521311_e2ca389c3e.jpg)

**AkitaOnRails** : Coming back to JRuby. I read from your [blog](http://ola-bini.blogspot.com/2005/12/homegrown-dao-to-hibernate-to-rails.html) that you’re working on JRuby since early 2005? How did you become a JRuby Core Team member? Did you know [Charles](http://headius.blogspot.com/) or [Thomas](http://www.bloglines.com/blog/ThomasEEnebo) before?

**Ola Bini** : Late 2005. And no, I didn’t know them from before. I started contributing small things first, and then last [March](http://ola-bini.blogspot.com/2007/03/jruby-regular-expressions.html) and [April](http://ola-bini.blogspot.com/2007/04/on-activerecord-jdbc-performance.html) I did some larger things. I continued helping out, and soon after [Charles and Tom got hired by Sun](http://www.tbray.org/ongoing/When/200x/2006/09/07/JRuby-guys) they decided that I would make a good addition to the core team.

**AkitaOnRails** : Were you still working in JRuby on your spare time or did it become a full-time endeavour?

**Ola Bini** : I have never been able to do JRuby full-time; sometimes I’ve been able to work on it during lulls in my regular work, but most of it has been strictly spare time. Until now, of course.

**AkitaOnRails** : There are a lot of doubt and fear in the mind of inexperienced Java programmers here. They “fear” to have lost time learning Java. They “think” that Ruby is a lesser language, and so on and so forth. I think the problem is that most of them think that they only need to learn one language only. This is a two-fold question: first, you mentioned that you dislike Java. Can you elaborate on what exactly? And second, what do you like about Ruby?

![](/files/504012154_839b1be79a.jpg)

**Ola Bini** : I would like to begin by saying this: it is very hard to be a good programmer while only knowing one language. Knowing several programming languages of different style is [imperative](http://media.pragprog.com/titles/mjwti/generalist.pdf) to use a language well. Knowing lisp makes me a better Java programmer. My former co-worker Lars have told me that learning Ruby makes him a better Java programmer. So, learning another language is in fact something you can do, and should do, to make you a better programmer in Java, for example.

**AkitaOnRails** : I couldn’t expect a better answer.

**Ola Bini** : So, Java: I think the language overly verbose, the type system is inconsistent and quite annoying at times, and there is no way to compress code. When refactoring, you end up with more lines of code for the same functionality. Also, there is lot of clutter in a typical program.

I don’t think [generics](http://weblogs.java.net/blog/arnold/archive/2005/06/generics_consid_1.html) have improved this situation. I think that Ruby have almost all the power I’m used to from Common Lisp. In some cases you can do amazing things with the [metaprogramming](http://ola-bini.blogspot.com/2006/09/ruby-metaprogramming-techniques.html) capabilities. Ruby is like clay, it can be formed into whatever you want, and Java is marble. Also, I like that Ruby have enough of a heritage from Perl to be pragmatic and easy to use; it’s fast to get started with and you are productive in a very short ammount of time.

**AkitaOnRails** : Ruby is an excellent language, no doubt. Ruby 1.9 is growing to become better. Are you updated in their development? I personally have a few things I’d like to have in a new version, as native UTF-16 top to bottom, a better and unified Datetime handling, at least less C dependency, a generational garbage collector, a better way for IDEs to introspect and debug into the code maybe as Smalltalk does. Now that you touched most of the language, what do you think you’d change if you had the opportunity? Or you’re satisfied with its current state?

**Ola Bini** : No, I’m not satisfied, which is one of the reasons I work on JRuby. There are some features of the Ruby language which I think makes it hard in some cases. The file system operations aren’t abstract enough; very unix-centric.

The threading system is dangerous since it provides features a “real” threading system and GC can never give you. (things like [critical=](http://jira.codehaus.org/browse/JRUBY-1157) and [ObjectSpace](http://www.rubycentral.com/book/ospace.html) I would like to see gone).

So, a better GC, more tunability, a better threading system, no global locking. But right now, I feel that the fact that we have several implementations of Ruby coming up, the features will prove themselves. If [Rubinius](http://blog.fallingsnow.net/rubinius/) makes the right choices for these things, Rubinius will get more users than MRI/KRI in the long run. I agree about better UTF support, of course. Anyone who’s not from the English countries know this.

 ![](/files/279242203_f1b6d306d9_m.jpg)

**AkitaOnRails** : I was trying to reach Evan Phoenix. Charles mentioned Rubinius as well. How do you think both projects can collaborate? What gaps Rubinius close for JRuby, for example?

**Ola Bini** : We are trying to cooperate. Especially with testing and implementing more of the core library in Ruby. Evan is moving to LA this week, so that’s why you won’t reach him.

**AkitaOnRails** : Yes, so I heard. And speaking of which, I would be personally terrified on working on something as big as JRuby. The part that frights me the most are the [C-coded](http://www.rubyinside.com/how-to-create-a-ruby-extension-in-c-in-under-5-minutes-100.html) ones. There are several core features of Ruby totally coded in C. How difficult was this to you? Can you tell us about some particular issue about this that left you scratching your head?

**Ola Bini** : Well, yeah, parts of MRI can be fairly “interesting”. They do things like modifying the [argc and argv](http://faq.cprogramming.com/cgi-bin/smartfaq.cgi?id=1043284392&answer=1046139290) to varargs methods. The problem with the C code is that they heavily use pointers, all over the place. Sometimes they wrap non-Ruby objects in a [VALUE](http://www.oreillynet.com/ruby/blog/2006/01/the_ruby_value_1.html) pointer, which is just hackery. But it’s usually not that hard to figure it out, since I’ve been doing lots of C code in my days.

**AkitaOnRails** : The JRuby implementation proved to be very successful but not without its hassles. [Unicode](http://headius.blogspot.com/2006/06/unicode-in-ruby-unicode-in-jruby.html), [SSL](http://ola-bini.blogspot.com/search/label/openssl), [Regex](http://jira.codehaus.org/browse/JRUBY-1046), [YAML](http://jira.codehaus.org/browse/JRUBY-561). For example, you described differences in the Java’s regex implementation and the Ruby MRI’s version at your blog. What were the most difficult parts on the porting process, feature-wise, from your point of view? Where was the heavy-lifting?

 ![](/files/511173733_e5680a0442.jpg)

**Ola Bini** : There are basically two things that were the “worst” in getting something that works. The first was all the corner cases. Strange behaviors that isn’t really specified, but just behaves that way because of the implementation.

Have you tried using super within a block, where the surrounding method takes * args and you modify args? Threading proved problematic too. And the other main area is, as you say, extensions. It’s basically impossible to run anything significant without porting several extensions. Just a few number of these we needed, for example: strscan, yaml, zlib, enumerable and regexps are problematic. We have three different engines right now. The Java one, the [JRegex](http://jregex.sourceforge.net/) (which is the one we use), and one called REJ, which is the MRI regexp engine ported to Java. (REJ isn’t used)

**AkitaOnRails** : Before JRuby actually started gaining traction (mainly because of Rails, I guess) they were pretty much stalled. It was trying to cover Ruby 1.8.2 if I remember correctly. So much of this stuff were not yet covered at that time?

**Ola Bini** : Yes, that’s true. Most of the progress we have made, was done from January of 2006 and forward. The support was there. Large parts of the parser was working fine, but almost no extensions, and many parts of the language were still at the 1.6 level.

**AkitaOnRails** : I remember reading in your blog about a way to run a [Mongrel Cluster](http://ola-bini.blogspot.com/search/label/mongrel) entirely inside a single JVM. Was that just a proof of concept or do you see Rails apps being deployed this way? What would be the advantage of using Mongrel in the JVM space? Or the main traction for Rails is the Goldspike plugin and the [JRuby-Extras](http://rubyforge.org/projects/jruby-extras/) tools?

**Ola Bini** : I did it first as a proof-of-concept, but I think it’s a viable solution. But mostly, I thought it was interesting to do as something for people coming from the Ruby crowd. People who are used to the Mongrel approach. I wanted to give them a better solution than starting 10 JVM’s. And that’s in core, the jruby server is a generalized tool that can be used in other circumstances too.

**AkitaOnRails** : But Goldspike doesn’t require Mongrel to run. So we have 2 ways of running Rails apps in the Java space.

**Ola Bini** : Absolutely. And I think that the Goldspike route is the superior one. But Ruby is all about [choice](http://headius.blogspot.com/2006/06/mongrel-in-jruby.html) and flexibility.

**AkitaOnRails** : I guess we will come to that again when talking about [Mingle](http://studios.thoughtworks.com/2007/5/7/mingle-to-run-on-jruby). Which brings me to [ThoughtWorks](http://studios.thoughtworks.com/). Tell us this story. How did you know them? How did you get on board?

**Ola Bini** : Well, the name have been familiar for a long while. They’ve got a good reputation, as you know. About last April a friend of mine got hired. We talked some and it seemed like a good place. We decided that I should apply. She did a recommendation and I was there and interviewed in August. Everything went quite well, except that they didn’t have enough revenue at that point, so they couldn’t hire me. Then we took up contact again in February, started talking about Ruby and ThoughtWorks Studios. I came back, did a quick interview with Cyndi, and the rest was basically logistics.

**AkitaOnRails** : [Cyndi Mitchell](http://studios.thoughtworks.com/2007/3/6/how-to-mingle)?

**Ola Bini** : Yes. She’s one of my bosses. (The structures here aren’t really clear… =)

**AkitaOnRails** : She presented a [keynote](http://conferences.oreillynet.com/cs/rails2007/view/e_sess/14493) at RailsConf if I remember correctly.

**Ola Bini** : Yep. She did. She was also the one who put my name and number on the big screen. =) I was there with her and Roy and [Martin Fowler](http://www.martinfowler.com/bliki/), and some other ThoughtWorkers.

![](/files/cyndy.png)

There’s a flat structure, yes, which means I don’t have explicit bosses, but bosses that manage over different areas of my time, so to speak. So Chad Wathington takes care of my [RubyWorks](http://studios.thoughtworks.com/rubyworks) work, Cyndi handled all employee logistics for Studios, and Alexei Vorontsov is Project Manager for [RubyWorks](http://rubyworks.rubyforge.org/). All of them bosses to me, so to speak.

**AkitaOnRails** : Nice. I also read that you’re working a lot in Mingle. This is another important milestone as this is probably the first commercial JRuby app with total support from a big company. Please elaborate on what is Mingle and what are your responsabilities in this project.

**Ola Bini** : Absolutely. So, Mingle is a an agile project management system. It aims to be more flexible and more close to the agile methods that agile people would love to practice more of. My responsibility is deceptively simple: it is my task to make sure that JRuby will work out, fix problems and help out when making the application bi-implementational, so it runs on both JRuby and MRI.

**AkitaOnRails** : Does it have anything to do with [CruiseControl](http://cruisecontrol.sourceforge.net/overview.html)?

**Ola Bini** : No, not at this point. As far as I know, there will be integration at some point, but I’m not involved in that.

**AkitaOnRails** : Ok. You’re also involved in every single Java and Ruby conferences out there. I always wondered how guys like you find enough time to 1) actually present good stuff at the conferences; 2) find enough time to bring exciting open source projects as JRuby; 3) still have a day-job and be productive. You have to have 48 hours each day (and I’m probably disrupting your workflow right now =) How do you get yourself organized?

**Ola Bini** : Actually, we try to share conferences between the core developers. For example, I will take [TSSJS](http://javasymposium.techtarget.com/europe/europe_info.html) while Charles and Tom take vacations. Presenting good stuff helps us share material among each other. Also, Charles and Tom, and now me, are actually working on this as our day job, where evangilizing is an important part.

Organization is harder. I usually keep lists on [tadalist](http://www.tadalist.com/). That works well enough for me. That’s all the organization I’m actually using. But I tend to be highly chaotic, which works fine for me.

**AkitaOnRails** : haha, but you have to be on the computer more hours than the average programmer to accomplish all this.

**Ola Bini** : hehe. Well, yes. I’m not far away from computers during my waking hours, that’s for sure. Especially not with the book writing, which eats seriously into my time for other things. =/

**AkitaOnRails** : And speaking of being workaholic and evangelization. You are also writing a new book about JRuby. It is scheduled to be released in a few months. Tell us more about it.

**Ola Bini** : Well, it’s a [book](http://ola-bini.blogspot.com/2007/06/book-update.html) about JRuby on Rails. It’s aimed to be quite practical, giving concrete examples on how do achieve things. There is quite a lot of JRuby information buried in it, of course, but it’s not a general book about JRuby.

 ![](/files/pat.jpg)

[APress](http://www.apress.com/category.html?nID=155) will publish it, and according to the current schedule, it will be released in October. [Pat Eyler](http://on-ruby.blogspot.com/) is my tech reviewer. And that’s about it. =) It’s going to be about 250 pages long, containing 4 JRuby on Rails projects developed from scratch.

**AkitaOnRails** : Haha, and I imagine that it is difficult to write about a moving target, isn’t it? JRuby is still evolving as well as plugins such as Goldspike, that you need for Java deployment.

**Ola Bini** : Of course. In some cases I had to revise parts substantially, and in other cases I had to write lots of stuff for JRuby, just to get it finished for the book. So, in some ways, me writing the book has improved my work on JRuby too, giving me input on things that need to be fixed, and so on.

**AkitaOnRails** : Yeah, do you see a JRuby 1.1 release coming soon?

**Ola Bini** : Hopefully a JRuby 1.1 release will be out within 2 months. It’s possible that it will take longer, due to the summer being down time for some of us. But JRuby have a tendency to move fast and have many releases, so I should count on it within 2 months.

**AkitaOnRails** : Rails brought a lot of interest in developing using Macs. [Textmate](http://www.pragmaticprogrammer.com/titles/textmate/) is the primary reason. I saw some of Charles presentations and I believe he was using Emacs. What are your primary tools for developing both JRuby and your Rails apps?

**Ola Bini** : Actually, Charles and Tom usually use [vi](http://wiki.rubyonrails.org/rails/pages/HowtoUseVimWithRails) for presentations, and [Netbeans](http://wiki.netbeans.org/wiki/view/RubyOnRails) when doing development. I’m more oldfashioned. I work on a Mac, but I’m too much of a Lispnic to use anything else than [Emacs](http://dima-exe.ru/rails-on-emacs). So Emacs, with my something like 10.000 lines of E-lisp code is my main tool.

**AkitaOnRails** : Hey, won’t you release your Emacs bundle as an open source project as well? :-)

**Ola Bini** : hehe. No, I don’t think so. It’s full of cruft and many things which are highly specialized for me. That’s really the point of Emacs: you create your own little world.

**AkitaOnRails** : I think that lack of stronger tools and IDEs are still an obstacle for mass adoption by switchers coming from Java or .NET. Do you feel the same way or do you see adoption growing regardless of that?

**Ola Bini** : I think you are right, but I don’t see it as a rational objection to switching. But there is coming lots of good support for Ruby now, if you want it. Eclipse, Netbeans, [IntelliJ](http://www.jetbrains.com/idea/training/demos/rails.html), jBuilder. There are many options and they seem to get better each day.

**AkitaOnRails** : But, you’re not dropping Emacs any time soon ;-)

**Ola Bini** : hehe. Nope. That’s not going to happen.

**AkitaOnRails** : And finally, what do you see in your future with JRuby? Any other personal project that you want to invest more time? Or you’re 100% full-time on JRuby for the time being?

**Ola Bini** : Well, I believe that JRuby and JRuby related projects is going to take much of my time. If I get some spare time, I would probably try to concentrate on my music; but if you wanted computer related [projects](http://ola-bini.blogspot.com/2006/09/limits-of-power-what-lisp-can-do-but.html) there are three things I would want to do: Jio, a Java implementation of Io; CLaJ, a new Common Lisp implementation on Java, based on [Lisp In Small Pieces](http://en.wikipedia.org/wiki/Lisp_in_Small_Pieces), with the explicit goal of being both performant, maintainable and compliant. And finally, I would love to be able to do more AI things.

**AkitaOnRails** : You say you don’t like Java that much, but 2 out of 3 are Java related :-)

**Ola Bini** : You have to make a difference between Java, the language and Java, the platform. The platform is outstanding, and I want all languages to have a base like that. And yes, the projects are Java based, which means I’ll sacrifice myself for the sake of others… =)

**AkitaOnRails** : Good point. And as Steve Jobs would say _“there’s One More Thing™”_: I try to bring a lot of advise from experienced people like you to programmers beggining their careers. They have lots of questions. What would you recommend for this new generation of programmers? (Although I think you are very young yourself.)

![](/files/515994249_5a5bc1b92d.jpg)

**Ola Bini** : This shouldn’t come as a big surprise after this interview: my advice would be to learn more than one language. Simple enough. Something functional, or with a desperately different concurrency model. Lisp, Smalltalk, Erlang and Ruby are all good choices for a Java/C/C++ programmer to learn. And yeah, I guess I am. I’m 25 now.

**AkitaOnRails** : As Dave Thomas said in the Pragmatic Programmer: leart at least one [new language every year](http://www.pragmaticprogrammer.com/loty/).

**Ola Bini** : Absolutely. That’s good advice. I can’t top it. =)

**AkitaOnRails** : By the way, out of curiosity, do you speak english in Sweden?

**Ola Bini** : No, not very much. I speak english when the other person doesn’t understand Swedish, or if someone in our company doesn’t understand Swedish (out of courtesy).

**AkitaOnRails** : I thought so, you have a very good english.

**Ola Bini** : Thanks. We work with english from the 4th grade in Sweden, so most have a passing ability at least.

**AkitaOnRails** : That’s another thing I [evangelize](/articles/2007/04/14/off-topic-seja-arrogante) here in Brazil: to learn english as best as you can. Liking it or not, english is the language of the technology world.

**Ola Bini** : Yes, without question. English is very important. And after that, I guess Chinese is. Based on simple numbers.

**AkitaOnRails** : Absolutely. How’s your mandarim? :-)

**Ola Bini** : hehe. My mandarin and cantonese are totally nonexistent. But I guess that’ll come… =)

**AkitaOnRails** : I guess ThoughtWorks has an office at China as well, doesn’t it?

**Ola Bini** : Yeah, we have two. It’s possible I’ll move there for 6 months next year. But I don’t have any facility for human languages. English is the only language I know well, except for Swedish.

**AkitaOnRails** : No way, tell me about it. That’s a scoop!

**Ola Bini** : Hehe, it’s possible, but not certain. We are looking at where the RubyWorks team should be placed, and China is probably the best location for me. I will move to San Francisco later on, but I need to work for ThoughtWorks for 1 year to get an L1 visa first.

**AkitaOnRails** : China? Best for you? how come?

**Ola Bini** : Since most of the RubyWorks team will be there or in Bangalore.

**AkitaOnRails** : Ruby, with JRuby, is getting near its birth place (Japan). Curious. Well, I guess I already disrupted your work hours a lot. Another great interview is finished ;-) Any closing remarks for the brazilian audience?

**Ola Bini** : hehe. Thanks. Nope, I think I’ve said it all now! =) I hope to get to Brazil at some point or another, so don’t be too harsh on me when I arrive!

**AkitaOnRails** : Cool. Its been very nice talking to you. I hope we can exchange more ideas later on. Thank you very much!

**Ola Bini** : Thanks! Keep me posted on what happens. Bye.

