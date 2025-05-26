---
title: Chatting with Adrian Holovaty
date: '2008-01-01T02:01:00-02:00'
slug: chatting-with-adrian-holovaty
tags:
- interview
- english
draft: false
---

**TraducciÃ³n en [EspaÃ±ol](http://www.marcelor.com/2008/01/conversando-con-adrian-holovaty-creador-del-proyecto-django-traduccion.html)**

As I promised after the [Avi Bryant](http://www.akitaonrails.com/2007/12/15/chatting-with-avi-bryant-part-1) interview, here’s a great conversation with [Adrian Holovaty](http://www.holovaty.com/), well known creator of the [Django](http://www.djangoproject.com/) web framework written in Python.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/387373570_870fa6257c.jpg)

For me this is an important piece because I always say that technology doesn’t have to be about divorce. Technology is about integration. I am a full-time Ruby on Rails developer and evangelist, but above all, I try to be a ‘good’ programmer. And good programmers acknowledge good technology and their creators achievements. And Adrian’s Django is such a remarkable achievement that deserves the attention and success.

So, as my very first post of the year (published at 0:01hs!), I would like to celebrate the great minds of our ‘development’ community, wishing that the good developers use their time creating great technology instead of wasting it in useless flame wars.


 **AkitaOnRails:** As I always do, let’s start by talking a little bit about yourself. How long have you been a programmer?

**Adrian Holovaty:** Let’s see — I’ve been tinkering with computers since I was a little boy playing with the Commodore 64 in the mid ’80s.

One early program I wrote was for the TI-85 calculator in my high-school math class. By the time I graduated, a whole bunch of students were using it, because it had all the formulas and stuff.

I didn’t take any of this stuff seriously until college, when I minored in computer science. But I didn’t end up finishing the minor, which is something I’ve always been bummed about.

My college major was journalism, as I originally wanted to be a newspaper reporter, but after I took a job with the Web site of the campus newspaper ([The Maneater](http://www.themaneater.com/) – best name for a newspaper ever!), I realized I would have a lot more fun working online than with a dead-tree product.

So I ended up finding a way to combine journalism/news and computer programming, and I’ve had a number of jobs doing exactly that!

**AkitaOnRails:** And what led you to the computer world?

**Adrian:** I guess it was in my upbringing, as my dad has been a computer programmer since the ’70s, back in the punchcard days. I remember seeing all sorts of those punchcards in our house when I was growing up.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/247456700_94dbcdbf86.jpg)

**AkitaOnRails:** And, of course, how did you met and fell in love with Python?

**Adrian:** My Web development path was (I think) pretty typical, at least based on the experiences of my friends and colleagues. I originally learned how to write Perl CGI scripts in a college Web development course. Then I taught myself PHP because somebody recommended it to me.

After doing Web development with PHP for a few years, I got kind of tired of it. At that time, I was working with Simon Willison at a newspaper Web site in Lawrence, Kansas. Simon and I were both getting tired of PHP and decided to “dive into Python” (pun intended) by reading [Mark Pilgrim](http://en.wikipedia.org/wiki/Mark_Pilgrim) ‘s excellent book of the same name, which was released around that time. This must’ve been late 2002.

We immediately fell in love with Python. And when I say “immediately,” I really do mean it. It was like a revelation, some sort of divine moment. It was the programming equivalent of love at first sight.

So Simon and I decided that, from then on, we were going to code everything in Python. That’s one of the perks of working for a small Web development shop — we could make those kinds of snap decisions! ï¿¼

**AkitaOnRails:** I was first introduced to Python around 2000 as well. But it was through web development using [Zope](http://www.zope.org/). I think it got a lot of attention at the time. Did you ever tried it?

**Adrian:** No, I never tried Zope. Still, to this day, I’ve never tried it. And I’ve been told that’s a good thing, because evidently it turned some people off of Python back then, for whatever reason. (Their newest version is supposed to be a ton better, but I haven’t tinkered with it, either.)

**AkitaOnRails:** You’re right, and it is kind of amusing because a lot of pythonists from Brazil still use [Plone](http://plone.org/) (I think it evolved from Zope but I didn’t try it as well). So, We all know that Django was born out of necessity when you were developing websites for World Online. Please describe how did you begin there and how is the everyday work there. Maybe what led you to Django during your work day?

**Adrian:** Sure! Well, generally when people think of newspapers, they think of crotchety, old-fashioned editors and reporters scribbling in paper notebooks with pencils. This Kansas newspaper that I worked at was the completely opposite of that. It’s beyond the scope of this interview, but for a number of reasons that newspaper Web site attracted (and still attracts, to this day) a really great development team – one that I would stack up against any team 10 times its size.

We were doing “Web 2.0” stuff back in 2002 and 2003, and we were building Web apps in days, not weeks or months. This was mostly due to the journalism environment – newspaper people like deadlines. ï¿¼

So we were in this culture of _“Web development on journalism deadlines,”_ and we needed some tools that let us create Web applications quickly. We looked around at some existing Python libraries at the time (2003), and we ended up deciding to write our own stuff.

We didn’t set about to make a framework – it was a very classic, clichÃ©d path, actually! What happened was, we built a site with Python. Then we built another one, and we realized the sites had a fair amount of code in common, so we did the right thing and extracted the common bits into a library.

We kept doing this – extracting and extracting, based on each new Web application that we created – and eventually we had a framework.

**AkitaOnRails:** As a side-note, actually this is kind of interesting! I would love to hear what do you think World Online has that attracts good developers like yourself there! Just a summary would be ok. That’s the kind of insight brazilian companies have to learn better. Letting you do Python is probably one of them ï¿¼

**Adrian:** Yeah, it kind of comes down to **empowering the employees**. My boss, who led the Web team, delegated all the technology decisions to me and Simon. That kind of culture really encourages quality work, because it makes everybody on the team more invested.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/1454328380_6b6053d1c9.jpg)

ï¿¼  
**AkitaOnRails:** You’re right. Traditional companies would rather have a more hierarchical (and bureaucratic) approach, with a dumb manager holding the whip. But I digress. So, I particularly dislike language x VS language y or framework a vs framework b kind of comparisons. Instead I’d like to hear what do you think is great about Python – the language and the platform – and Django. What are the features in Django that you hold dear to yourself, I mean, those bits of functionality that you actually think for yourself as ‘the’ greatest ideas?

**Adrian:** Well, I love abstractions – like, I suspect, any programmer. At its core, Django is just a set of abstractions of common Web development tasks. It gives me joy to create high-level abstractions, to encapsulate a large problem in such a way that is made simple.

What I really like about Django is the depth and breadth of abstractions that it provides. And in most cases (I hope!), they’re clean, easy to use and understandable.  
Let me give you an example of an abstraction: creating an RSS feed.

When you create an RSS feed, you don’t want to have to deal with remembering angle brackets, and the exact formatting of the feed — you just care about the items in the feed. So Django provides a very simple library that lets you give it a bunch of items and creates a feed from them.

So that’s an obvious example, but what really excite me are the higher-level abstractions, like the concept of an “admin site.” Django comes with a completely dynamic application that makes a beautiful, production-ready CRUD site for your database. There’s no code to write – it’s only a small bit of optional configuration.  
There’s also something called [**Databrowse**](http://www.djangoproject.com/documentation/databrowse/), which is an abstraction of the concept _“Show me my data, as intelligent hypertext.”_

So whenever I’m explaining Django to someone, I always end up saying, _“It’s just a bunch of abstractions of common Web development tasks”_ – from low-level HTTP wrapping to higher – and higher-level concepts. The higher you get, the more productive you can be. I apologize if this is too conceptual!

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/1496211063_262b298650.jpg)

As for Python — what can I say? It’s gorgeous. It’s like poetry. It’s so clean, so logical, so regular, so obvious. And the import system is to-die-for.

A lot of people say Python code is easy to read/understand because of the consistent whitespace and simplicity of the language. I agree with that, but I think it’s also due to the elegant import system. Why? Because if you want to know how **any** Python module works, just look at the code, and look at the modules it imports. As the [Zen of Python](http://www.python.org/dev/peps/pep-0020/) says, _“Namespaces are one honking great idea – let’s do more of those!”_

**AkitaOnRails:** Tech communities are great because they are so energetic and passionate. On one hand you have those that contribute and make the technology grow faster. On the other hand you have the pundits and trolls that like flame wars. Do you burn yourself sometimes, or do you tend to avoid this kind of discussion? Specifically, some time ago you and DHH were together at the [Snakes and Rubies](http://www.djangoproject.com/snakesandrubies/) presentation. I think it was great because it didn’t end in yet another flame war. What’s your opinion on this kind of open (not flamed) discussion?

**Adrian:** The answer to this one is obvious – clearly constructive discussion is more productive.

At times, I’ve had my passion for Python/Django get the best of me, but I’ve gotten a lot better over the years. I’ve realized something: At the end of the day, what really matters is the sites people create with these tools, not the tools themselves. If youâ€™re going to judge someone, judge the sites that person makes, instead of the tools that person uses.

These days, if I am involved in any sort of discussion like that, it’s usually to try to calm people down. ï¿¼

**AkitaOnRails:** Well said. Going back to features, you mentioned ‘Databrowse’ before, I would like to know more about it. I think Django didn’t have it by the time I first tried it. Is it a new feature (or am I the one lagging behind? ï¿¼ Can you elaborate more on this construct?

**Adrian:** Databrowse is still quite under the radar! Here’s the use case.

Say you have a lot of data in your database, and all you want to do is **look** at it.  
Here are your current options: You can drop into the psql or mysql prompts and run a bunch of SELECT queries, but that gets tiresome. You could run something like PHPMyAdmin, but that’s more of an administration tool than a tool for **browsing**. You could use some sort of external application that lets you browse your database tables, MS Access-style, but that’s in the realm of the desktop app.

Databrowse automatically creates a Web site that displays your data, so you can click around to your heart’s content.

The other thing it does is pointing out interesting, non-obvious queries. For example, if you have a table that has a DATE column in it, it will automatically create a calendar view of that table.

The point isn’t for people to use this to make public-facing sites – the point is for people to use this to explore their own data, with no effort required.

Another use case comes from the journalism world. I used to work with a guy named Derek Willis at the Washington Post newspaper. His job at the time was to acquire huge datasets and place them on the newspaper’s intranet, so that reporters could search and browse the data in their research.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/179099354_6199af510a.jpg)

Derek didn’t want to have to hand-roll a Web app each time he got a new dataset, so he used Databrowse to make intranet sites that displayed his databases — with little-to-no effort.

This comes back to what I was saying earlier about high-level abstractions. Databrowse is a particular type of abstraction, and it’s really cool that we include something like that for people to use, if they need it.

**AkitaOnRails:** Sounds great, I am looking forward to use it. In a degree it feels like [Dabble Db](http://dabbledb.com) – albeit inside your own app. I think you already met [Avi Bryant](http://www.akitaonrails.com/2007/12/15/chatting-with-avi-bryant-part-1) ? I just interviewed him and it was a very insightful conversation. Have you ever tried Seaside? (out of curiosity I have a photo of you and Avi looking at his macbook sitting down in the grass, what was that?)

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/627957460_48e4181526.jpg)

**Adrian:** Yes, it was inspired by DabbleDB – it’s essentially a very toned-down DabbleDB-ish thing for your own data. But I shouldn’t even say that, because DabbleDB is a whole universe more sophisticated than Databrowse. DabbleDB is awesome. ï¿¼

Yes, I’ve met Avi a number of times and always enjoy his company. We even played some music together – he is a fantastic harmonica player!

The photo you’re referring to was taken at Foo Camp in 2007.  
I haven’t tried Seaside, but it’s on my to-do list. If I were ever developing an application like DabbleDB that needed to maintain a **ton** of state, I would turn to Seaside first.

**AkitaOnRails:** I see, I feel that good musicians tend to be good programmers as well. So, my first congratulations for you is about your [new book on Django](http://www.amazon.com/Definitive-Guide-Django-Development-Right/dp/1590597257) that was just released. I think it is a very big milestone for the Django community. More than that you were able to make it [available online](http://www.djangobook.com) under a Creative Commons license.

How did you get involved in this book? Was it difficult to convince the publisher to have the book readily available online? I ask this because at least in Brazil this is one idea that is VERY hard to push over to publishers. Tell us more about your writing experience, challenges and quirks along the way.

**Adrian:** Thanks very much. There’s not much to the story here – co-conspirator Jacob and I got contacted by the Apress folks, who were interested in publishing a Django book, and we did it. Well, I should amend that: It took us **a long time** , but we did it. ï¿¼  
It wasn’t difficult to convince Apress to let us make the book available online. They had previous experience doing so with Mark Pilgrim’s [Dive Into Python](http://www.diveintopython.org/) book, and they’re generally cool people.

In retrospect, publishing the book online was a fantastic decision. Not only is the final book available online, but we made chapters available online as we wrote them, with a really nice per-paragraph commenting feature that let readers submit typos, corrections and suggestions on a very granular basis. We got a **ton** of fantastic feedback for which we’re immensely grateful. Having experienced this, I wouldn’t want to publish a technology book any other way.

**AkitaOnRails:** Now, my second congratulations is because of that [Batten Award](http://www.j-lab.org/batten05winners.shtml) for outstanding achievement in online journalism. [ChicagoCrime.org](http://www.chicagocrime.org/) looks great and is a very good example of a [mashup](http://en.wikipedia.org/wiki/Mashup_(web_application_hybrid)) done right. Unfortunately our local government and public institutions have very little to almost no data available online for us to use. Where did the idea come from? How was its development?

**Adrian:** Thanks – and don’t let that site scare you away from visiting the beautiful city of Chicago. ï¿¼

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/adrian_oscon_2006.png)

**AkitaOnRails:** haha, I live in SÃ£o Paulo. Can’t be worse ;-)

**Adrian:** The idea for chicagocrime.org came when I was bumming around the official [Chicago Police Department](http://www.cityofchicago.org/police) Web site and found that they publish crime data – although in an interface that’s more suited for searching than for browsing. I thought, _“Wow, this is some great data!”_ and was writing a screen scraper within about 10 minutes.

Around that same time, I was tinkering with the Google Maps site, which had just launched, to see if I could embed Google map tiles into my own Web pages. I figured the crime data would make for a great mapping application, so I put the two together, and one of the original Google Maps mashups was born. While I was developing the site, [HousingMaps.com](http://www.housingmaps.com) ([Craigslist](http://www.craigslist.org/) + Google Maps) came out, so it beat me to the punch of being the **first** real Google Maps mashup – but chicagocrime.org came soon afterward.

The thing I’m most proud of is the fact that chicagocrime.org was one of the sites that influenced Google to open its mapping API. Back when HousingMaps, chicagocrime.org and the original crop of mashups came out, we were all reverse-engineering Google’s JavaScript!

**AkitaOnRails:** I know that you probably have 2 great passions in your career: one is Python-based development, or course, and the other is journalism (dunno the correct order here ï¿¼) You’ve made yourself quite a reputation on the online media. You’re working at the Washington Post right now, is that correct? I read an article at the [OJR](http://www.ojr.org/ojr/stories/060605niles/) where you explained about technology being used to empower the journalist. Do you intend to be a reporter someday or you’re more into the back-end of journalism? I think you have a strong opinion about the future of journalism in the Internet Era, don’t you?

**Adrian:** Well, I would say my **main** passion is music, but it’s hard to make a living doing that. (Django is named after the famous jazz idol [Django Reinhardt](http://en.wikipedia.org/wiki/Django_Reinhardt))  
 ï¿¼  
I’m no longer working at the Washington Post. In mid 2007, I was awarded a two-year grant from the [Knight Foundation](http://www.holovaty.com/blog/archive/2007/05/23/1145) to create a local-news site. So I founded [EveryBlock](http://everyblock.com) in July. We’re a team of four people and are working hard to make a really cool application.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/Picture_2.png)

But, yes, going back to your question, I certainly have some strong opinions about how journalism is practiced on the Internet. This is probably out of the scope of this interview, but you can read my essay/rant awkwardly titled [A fundamental way newspaper sites need to change](http://www.holovaty.com/blog/archive/2006/09/06/0307/) for a taste.

**AkitaOnRails:** Now, that’s news to me ï¿¼ Didn’t know you started your own company (sorry, I still have to catch up with the Python community). Can you tell us about your new endeavor?

**Adrian:** Hey, I can’t blame ya – we’re staying under the radar. There’s not much to say about EveryBlock at this point other than it’s chicagocrime.org on steroids. It’s like chicagocrime, but for more cities than just Chicago and more information than just crime. ï¿¼

**AkitaOnRails:** You should try it for Brazil :-)

**Adrian:** Thanks to Django’s internationalization framework, that is entirely possible. ï¿¼

**AkitaOnRails:** Yeah, and by the way, (digressing a little) I would recommend the brazilian movie [Elite Squad](http://en.wikipedia.org/wiki/Tropa_de_Elite) now that I know you’re interested in crime related data ;-)

**Adrian:** Noted! I’ve added “Elite Squad” to my MOVIES\_TO\_WATCH.TXT :-)

[![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/1529992544_f8e9fc67b2.jpg)](http://leahculver.com/)

**AkitaOnRails:** Going on. Many great websites are already deployed over Django. Your own works at World Online, Washington Post being some of them. Another big name is [Kevin Rose’s](http://en.wikipedia.org/wiki/Kevin_Rose) [Pownce](http://pownce.com/leahculver/) (the creator of [Digg](http://digg.com)). You, Kevin and other influential people usually meet during conferences, don’t you? What do you think influenced him to try Django? Another great thing about Pownce has to be [Leah Culver](http://leahculver.com/). A programmer like her is simply unheard of here in Brazil, which is a pity. You should make her the official Django cheerleader!

**Adrian:** I’ve never met Kevin Rose, but from what I’ve read, I believe Leah chose to use Django because either it had been recommended to her, or she liked Python, or something. I don’t know the backstory. I haven’t met Leah, either, but she was cool enough to travel to Lawrence, Kansas, for our last [Django sprint](http://leahculver.com/2007/12/01/django-sprint-part-2/) a few weeks ago (which I couldn’t attend in person, unfortunately).

**AkitaOnRails:** It is not a rule written in stone, but in Rails community we ‘tend’ to praise Mac related tech. Of course, it is not a requirement for any language and Linux is as good. But what can I say? I am an Apple fanboy ï¿¼ I would like to know what’s your development environment. What tools do you use to develop your Django-based websites?

**Adrian:** I recently switched to a Mac after several years of using Linux on the desktop, but don’t read anything into that — I’m not a fanboy by any means, of either Linux or Mac. I miss Linux, to be honest, and in a number of ways I’ve been unimpressed by OS X’s Unix features. (Basic stuff such as readline support in the default Python is broken, etc.)

The nice things about the Mac make it worth the switch, though. Even after having used the Mac as my primary machine for 6 months, I’m still impressed that I can just close the laptop and it’ll go to sleep automatically. That never worked with Linux!

**AkitaOnRails:** I ask this because many people looking at Rails and Django are Java and C# programmers that are used to have a full blown IDE. I usually say that any common text editor does the job, and if you really want power vim and emacs are a perfect fit. What do you say?

**Adrian:** I’ve never used an IDE to program, so I’m the wrong person to ask.  
Actually, I misspoke – I used an IDE-ish thing in college to program assembly. It showed the contents of the accumulators and that stuff.

**AkitaOnRails:** Oh, I almost forgot to ask: did you and [Guido van Rossum](http://www.python.org/~guido/) ever met? I would like to know your opinion about the [Python 3000](http://www.python.org/dev/peps/pep-3000/) development. Is there anything that’s in the new version that you really anticipate?  
ï¿¼

**Adrian:** Yes, I’ve met Guido a number of times and was even lucky enough to have dinner with him once! It’s almost silly and unnecessary to say this, but he is incredibly smart.

I really like the new concepts and features in Python 3000, and I had the opportunity to participate in a [sprint at Google](http://www.artima.com/weblogs/viewpost.jsp?thread=212259) Chicago a couple of months ago. My favorite feature is the migration to Unicode strings by default, because it forces the encoding issue front and center.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/Picture_3.png)

**AkitaOnRails:** Finally, what was all the fuss about Django being versioned 1.0 or jumping straight to 2.0? I didn’t follow the discussions, just read some headlines a while back. And what can people expect for the next release of Django? I understand that you don’t go big bang releases that changes the game, but what do you see getting released in the next few months in terms of new features?

**Adrian:** Ha – this is an amusing story. I’ve gotten worn out by people constantly asking “When is 1.0 coming out? When is 1.0 coming out?” My response always is, _“Why do you need an arbitrary number assigned to the product? Many people are using the current version, so don’t hold back. Version numbers are pretty meaningless.”_

So I suggested on the [django-developers](http://groups.google.com/group/django-developers/browse_thread/thread/b4c237ad76f9eeca/86e2d86b9fa8280f?lnk=gst&q=version+2.0#86e2d86b9fa8280f) mailing list that we assign the version number “2.0,” as if to reinforce the fact that version numbers are indeed arbitrary. But, having given it some more thought, I’ve changed my mind on that. The amount of confusion it would cause would not be justified by the amount of rebellious pleasure I would get out of it.

As far as upcoming features, there are a number of ongoing branches of the Django codebase that will all eventually be folded into the main trunk. One is a branch called [newforms-admin,](http://code.djangoproject.com/wiki/NewformsAdminBranch) which dramatically improves the amount of customization developers can make to the Django admin site. Another is [queryset-refactor,](http://code.djangoproject.com/wiki/QuerysetRefactorBranch) which is a refactoring of our database layer, again, to make it more extensible. Other than that, there are a few small features that we need to wrap up, and it’ll be time for 1.0.

**AkitaOnRails:** Haha, I think you’re right, I don’t like this ‘cult of the dot-oh’ as well, it’s pretty meaningless for an open source project that’s constantly evolving. But some people do have some concerns specially in a more enterprisey-like environment. Anyway, and for those that want to see Django in action, what are the websites that you recommend people visit? Some of the Washington Post, maybe? Of course, some of the great features – as the admin site – are only for admins (duh) ï¿¼ But people like to see ‘living’ things instead of a bunch of tutorials.

**Adrian:** As an aside, I see that Rails David just [wrote a rant](http://www.loudthinking.com/posts/20-dont-overestimate-the-power-of-versions) about the same topic.

Good Django-powered sites? Let’s see – there’s [Tabblo](http://www.tabblo.com/), a photo-sharing and editing site that has some really nice interactive features. There’s [Curse.com](http://curse.com), the massive online-gaming site. There’s [lawrence.com](http://lawrence.com), a site I helped build, which is one of the best local-entertainment sites in the world (if I may say!). And there’s a site (I forget its name) that will print a paper book from a series of Wikipedia articles that you specify – that blew my mind, the first time I saw it.

**AkitaOnRails:** So, I think we are done ï¿¼:-) That was a very pleasant conversation. I wish you have a great New Year.

**Adrian:** Thanks for the great questions and conversation, and happy new year!

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/Picture_1.png)

