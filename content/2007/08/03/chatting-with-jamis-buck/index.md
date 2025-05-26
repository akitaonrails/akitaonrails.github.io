---
title: Chatting with Jamis Buck
date: '2007-08-03T22:46:00-03:00'
slug: chatting-with-jamis-buck
tags:
- interview
- english
draft: false
---



 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/245186199_71f55cc3c7.jpg)

This is another big interview. This time with Jamis Buck, the programmer that helped David Hansson himself right at the beggining of Rails, at 37signals.

Today most renowned for his achievements in Capistrano and a lot of other Ruby libraries as sqlite-ruby bindings and Net::SSH. Jamis was very kind to give us the opportunity to know more about his career and the beginnings of the Ruby on Rails story.

**AkitaOnRails:** Ok, so let’s get started. first thing I always ask my guests: what’s your background? I mean, when, how, why did you start on computer programming? Did it began the classic way, as a hobby, or was it a more recent thing because of career or something else?

**Jamis Buck:** I started programming when I was in the 10th grade, when my mom got a brand-spanking-new Tandy personal computer. It had all of 20 megs of disk space, and came with [GW-BASIC](http://en.wikipedia.org/wiki/GW-BASIC). I’d done some programming before, turtle-graphics and a bit of BASIC, but that Tandy was when I got serious about it. I taught myself GW-BASIC from the little reference book the computer came with and wrote a few simple games and utilities. Then I taught myself Turbo Pascal and Turbo C++ in 11th and 12th grades, and it’s gone from there :)

**AkitaOnRails:** Then you decided to go for CS in college? I read at your profile in [WorkingWithRails](http://www.workingwithrails.com/person/5309-jamis-buck) that you’re a repentant Java programmer? How long have you programming in Java?

**Jamis Buck:** Yeah, I then jumped into Computer Science when I got to college. I graduated a bit late, in 1999, after working full-time for the university ([BYU](http://www.byu.edu/webapp/home/index.jsp)) as a programmer for a couple of years. That was where I did all my Java work. We were actually doing web-apps in C, which was not as insane as it sounds! But then we had a change of leadership when a new CIO came in, and he basically issued a blind mandate: _“learn Java, ditch C!”_ So we had to massively retool and get certified and so forth. I was on the team that led the research into what Java tools we should use, and so got a lot of experience that way. I did Java work full-time there for about 2 years, until [37signals](http://37signals.com/) came along in Feb 2005 and made me a better offer, and I’ve never looked back!

**AkitaOnRails:** Wow, so you jumped right in from Java in the university to Rails at 37signals? This is a little earlier than I expected, but as you already mentioned it: how did you get in touch with the 37signals guys? How did you start on Ruby being so overwhelmed with Java before?

**Jamis Buck:** Well, I’d been involved with Ruby (primarily as a hobby) since about 2001. I’d written a few libraries, like the [sqlite](http://sqlite-ruby.rubyforge.org/) and sqlite3 bindings, and at RailsConf 2004, I met DHH. I did a bit of work at the conference there to make Rails speak to sqlite databases. After that, around November 2004, I think, David asked if I would be interested in doing some consulting for 37signals. In December and January I did a few odd jobs for them like adding SFTP and time zone support to Basecamp. And then in February they flew me to Seattle to attend the [Building of Basecamp](http://www.37signals.com/workshop-062504.php) workshop there and they made me an offer.

**AkitaOnRails:** I understand that 37signals is a small company in terms of number of employees and most of its inner power comes from this very fact. Did it change much since you began, I mean, in the last 2 ~ 3 years? What did you like the most back then and what do you like the most right now?

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/conf_room.jpg)

**Jamis Buck:** Well, when I came on, I was the 5th employee, and the second programmer. Previous to my coming, David did all the programming and sysadmin work, so I think it was a big relief to him to have someone to share the load! About a year later, we hired two more programmers, and we’ve since hired two more people, including a full-time sysadmin. The changes have been for the better :) I like having a real sysadmin. I can’t tell you how much I hated being a sysadmin, since I had little idea what I was doing!

**AkitaOnRails:** You seem to be the kind of guy that like the _kitchen-sink_ because you’ve been involved with ‘low-level’ stuff like sqlite-bindings, Net::SSH and so on. Is this the kind of thing that excites you the most? Or it’s just a coincidence and you actually rather do GUI work as well?

**Jamis Buck:** I actually swore, some years ago, that I would never be a web-app developer :) I’ve always preferred writing the tools as opposed to writing the apps. But I’ve really enjoyed writing web-apps at 37signals. The team is great and the toolset (Rails!) is amazing. I still do enjoy writing libraries (working on [Net::SSH](http://raa.ruby-lang.org/project/net-ssh/) and [Net::SFTP](http://raa.ruby-lang.org/project/net-sftp/) v2 right now, in fact) but apps aren’t so bad either :)

**AkitaOnRails:** But back then when you were literally second-in-command you didn’t have much choice, did you? I bet you did some of the Basecamp interfaces? And you mentioned that you didn’t like much of the sysadmin work because you didn’t know what you were doing, but now you probably are an expert because Capistrano rocks in this field. I remember it being called SwitchTower before. Can you tell us its story?

**Jamis Buck:** I’ve done quite a bit of the work on all of the apps, some more than others. I don’t actually write the UI’s (that’s the domain of Jason Fried and Ryan Singer), but I’ve plugged them in and made them work.

I learned a ton about sysadmin work from when I had to do it. I’m still a major newbie at it but I learned more than I ever thought I’d learn about how mysql really works, for instance :)

When I first released Capistrano, a year and a half ago or so, it was called SwitchTower, but around March 2006 I got a [C&D](http://en.wikipedia.org/wiki/Cease_and_desist) from a company that had the name trademarked, and so I had to scramble for a new name. The Rails Core Team helped immensely at that time, they offered a TON of suggestions for names. Marcel eventually IM’d me and suggested “Capistrano” which just clicked for me and I went with it. I got some flack from some people, who thought the name was lousy, but I laugh now because most people that use cap today probably came to it after the name change and never knew any other name, and they don’t even think twice about it.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/logo-big.png)

**AkitaOnRails:** You are probably very overwhelmed now because of the Capistrano 2.0 release. It is a major departure from the 1.4.1 if I understand correctly. You rewrote a lot of stuff, had to break backward compatibility. Do you feel you got what you wanted with this release or are you aiming for more in a 3.0 release?

**Jamis Buck:** Cap2 is pretty much just what I wanted it to be. There are few minor tweaks in the pipeline, but nothing significant. It is about 90% backwards compatible with Cap1, so most people should have no problems switching. And since the 2.0 release, the maintenance load for cap has been really small. I’m very pleased with it. I still need to get busy with documentation though :) That’s the thing that still holds a lot of people back.

**AkitaOnRails:** What is it that you like the most about cap? You obviously use it at your own deployments at 37signals. I fantasize you having a bunch of shell scripts more than a year ago and then weaving them together to build what was the first release of Capistrano.

**Jamis Buck:** Prior to SwitchTower/Capistrano, we had a tool that David had written for deploying Basecamp. Back then, Basecamp ran on a single server, so deployment was little more than “svn up”. Later, we moved Basecamp to multiple servers and launched Backpack, and we realized we needed something more powerful for deployments. So I was tasked with writing something and Capistrano was the result. The thing I like most about it is how it takes the tedium out of being a sysadmin. The “cap shell”, in particular, lets you immediately and easily execute arbitrary commands on multiple servers, simultaneously, which is really handy. Of course, “cap deploy” is nice too :)

**AkitaOnRails:** I remember one episode where David reported about a 72 hours glitch that let Basecamp out. Were you involved in that episode? :-) Headaches like this seems funny when you remember about them now, but obviously not so funny at the time.

**Jamis Buck:** ha, yeah, that actually happened a few days after I was hired :) We were adding UTF-8 support to Basecamp and the database migration did not go well. We pulled an all-nighter. Quite the introduction to 37signals’ culture :) Fortunately, that kind of thing hasn’t happened since, though we’ve had our share of other emergencies, of course.

**AkitaOnRails:** Lessons learned? I think that’s the most important outcome of these situations :-)

**Jamis Buck:** The main lesson I learned that time: when you’re mucking with charsets, make sure you test it on as many non-Latin1 alphabets as possible :) Naturally, we tested it a lot before we deployed, but we didn’t really think to check any Russian or Japanese data that was in our database after the test, which seems obvious in hindsight. We did try some non-Latin1 alphabets during testing but the ones we tried just happened to work in spite of the bugs. Another lesson learned: no matter how hard you prepare, something’s going to fall through the cracks!

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/245186199_71f55cc3c73.png)

**AkitaOnRails:** I headed a group of very committed volunteers and got your [Getting Real](http://gettingreal.37signals.com/GR_por.php) book translated into Brazilian Portuguese a while back. I believe you were involved in it too? This book is iconic to picture the 37signals spirit I guess. Do you really move the way it’s written? :-)

**Jamis Buck:** I was actually not too involved in the composition of the book, though I gave some feedback during the writing process. But yes, that book describes our own processes. There really isn’t anything in that book that we don’t actually do.

**AkitaOnRails:** How do you operate? I believe that not everybody work in the same physical location? Do you do a lot of remote work? How many programmers/sysadmins/designers are there now?

**Jamis Buck:** Chicago is definitely the “heart” of 37signals: Jason, Ryan, David, and Sam all live and work there. We have an office there as well, and the Chicagoites go there pretty regularly to work (though they also work from home some, too) Matt Linderman is our writer, he lives and works in NYC. Mark Imbriaco, our sysadmin, lives and works in Chesapeake, Virginia and Jeremy Kemper is another programmer, living in Pasadena, California now. The distributed nature of it works very well for us. I really love working from home, it lets me be more involved in my kids’ lives, for instance, than I would otherwise be.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/building_djd.jpg)

**AkitaOnRails:** I hear you’re from Provo, Utah? It is a coincidence as my current boss, [Carl Youngblood](/2007/7/20/conversando-com-carl-youngblood), is also from there and also studied at BYU :-) You don’t possibly know each other, do you?

**Jamis Buck:** I actually live in Caldwell, Idaho now, but I was in Provo for about 8 years and yes, I do know Carl! We were both in the [Utah Ruby Users Group](http://groups.google.com/group/urug?hl=en). He’s a great guy.

**AkitaOnRails:** You attended many conference for the Ruby community. I don’t remember if you wrote any books. Are you writing some now?

**Jamis Buck:** I was originally going to write a book about Capistrano for Apress, but that’s fizzled. I’m not actively involved in any book writing at the moment, and don’t really have much interest in it, honestly. I much prefer writing software! And I try to post to my blog once in awhile, too.

**AkitaOnRails:** Yes, the [buckblog](http://weblog.jamisbuck.org/), it has lots of great tips that I like to read. Did you start it because of Rails or you already had a Java blog back then?

**Jamis Buck:** I started it pre-Rails. If you read the early articles, you’ll see they were pretty eclectic. I was still trying to figure out this whole “blog” thing :) I’ve since come to focus on software-development and use my [family blog](http://family.jamisbuck.org) for more personal posts these days.

**AkitaOnRails:** I was a Java programmer myself and I still try to maintain myself informed about what’s going on in other communities as Java, some PHP, Python. What do you think or feel about other frameworks and technologies as CakePHP, Avi Bryant’s [Seaside](http://www.seaside.st/) or even Django?

**Jamis Buck:** Honestly, I’m a bit ashamed to admit that I don’t keep up on other frameworks as much as I should. Seaside has some neat ideas and my desire to improve my Smalltalk programming skills has made me want to poke into that further. But other than that, I haven’t shopped around much (to my own personal detriment, I’m sure).

**AkitaOnRails:** And still about Java, I am very excited nowadays about JRuby. I interviewed [Ola Bini](/2007/06/21/conversando-com-ola-bini-jruby-core-team-member) and I’m also kind of stalking Charles Nutter. Did you know the guys? Did you got interested in trying it?

**Jamis Buck:** I know who they are, and I’ve met Charles at a few conferences, but I’ve never really had a chance to talk to them in depth. JRuby definitely sounds exciting. I’m very curious, in fact, to know whether it can support Net::SSH or not since that would mean you could run Capistrano under it. But I’ve not had a chance to actually try it out.

**AkitaOnRails:** Insisting on the Java subject, I posted a while back about some discussions about Design Patterns pointing to [flaws in languages](/2007/7/30/gof-design-patterns-sobreviveu-ao-teste-do-tempo), and I just read [a post](http://weblog.jamisbuck.org/2007/7/29/net-ssh-revisited) you wrote about Dependency Injection and your Net::SSH library. What do you think about Design Patterns now that you’re a full-time Ruby programmer?

**Jamis Buck:** Design Patterns are wonderful. They give us a language to talk more concisely about programming. It is so much easier to say “use a factory method” than to circumlocate and confuse each other. As for specific design patterns, some are more useful than others in different environments. As I wrote in my post, Dependency Injection is just not something you need in Ruby, but in environments like Java, it can be a life-saver.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/276456883_dd0ae43334.jpg)

**AkitaOnRails:** About 37signals again, you are very committed to Apple products. I saw that video on [Apple Education](http://www.apple.com/education/whymac/compsci/video.html) with Jason and David. And now we see that [Leopard](http://weblog.rubyonrails.org/2006/8/7/ruby-on-rails-will-ship-with-os-x-10-5-leopard) will bring not only Ruby but also Rails, Mongrel and even Capistrano. How is your relationship with Apple?

**Jamis Buck:** I wouldn’t say there is any “relationship” with Apple. We’re big fans of their designs and interfaces and I think that reflects in our own work. Apple itself is including Rails, Mongrel, and Capistrano in the wake of those tools’ successes. Mac OS X really is a powerful environment for programmers and adding those tools “out of the box” makes it even more so. It makes sense to include the popular Ruby tools, too, since Ruby is going to be a [first class citizen](http://rubycocoa.sourceforge.net/HomePage) when it comes to developing OS X applications, thanks to the adoption by Apple of the Cocoa bindings for Ruby.

**AkitaOnRails:** You obviously use a Mac for your work. What are the tools you use the most besides Textmate?

**Jamis Buck:** Well, Capistrano :) Firefox w/ Firebug, Parallels (for IE testing), iTerm (though I’m looking forward to the new Terminal.app in Leopard), [Campfire](http://www.campfirenow.com) is indispensable, AdiumX, NetNewsWire, Knox (for simpler encrypted filesystem access). I still fall back and use vim pretty often too, for quick edits. There are probably others :) But I can’t think of them off the top of my head.

**AkitaOnRails:** There are a lot of talk about [GTD](http://en.wikipedia.org/wiki/Getting_Things_Done) nowadays. I think I saw your profile at 43folders. Are you into this kind of organization philosophy as well? How do you maintain your routine organized? Many people (myself included) have a hard time differentiating work from hobby and keeping ourselves within the project’s deadlines and such.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/502950270_7175d894c8.jpg)

**Jamis Buck:** I’m not a GTD fanatic. I guess I try to be pretty pragmatic about it. I’m terrible about procrastinating, though. Mostly, from 8-5 I try to focus on the tasks that have been assigned to me and outside of that, I work on my hobbies… which happen to overlap work sometimes :) I’m really the wrong person to ask about being organized! If it weren’t for my wife, I think I’d get very little done, actually.

**AkitaOnRails:** What are you most interested nowadays besides Rails, Capistrano? Not only technology-wise. Any hobbies?

**Jamis Buck:** I’ve lately become very interested in military history, which has lead me to read about the American Civil War among other things. My wife and I are really enjoying Harry Potter #7 right now, too :) And I’ve become quite attached to my Nintendo Wii lately, as well! I used to be quite into role playing games, but haven’t done that for a few years. I’ve still got a ton of books for [D&D](http://en.wikipedia.org/wiki/Dungeons_&_Dragons), though, and maybe someday I’ll dust them off :) I enjoy spending time with my kids (Nathaniel is 5, and Katie is 3). We’ll be going camping for a few days in a week or two, actually. Always something to keep me busy!

**AkitaOnRails:** Haha, I see. And do you travel a lot? Outside of the US, I mean.

**Jamis Buck:** Not really. Last year I went to London for the first time, for RailsConf there, and this year I went to the Czech Republic. But aside from that, I’m really a homebody. I’d kind of like to do more traveling, but I don’t like to travel alone and having kids puts a damper on the spontaneous “get up and go” aspect of travel. We do occasional road trips and stuff, though, which is fun.

**AkitaOnRails:** Do you hear what’s going on the Ruby/Rails communities around the world? What do you feel about the meteoric rise of Rails in the US? 37signals, of course, was the fuel for all this and the reason we – both Rubyists now – are talking today.

**Jamis Buck:** I hear some news, but I’ve trimmed my newsfeed quite a bit. I think I only subscribe to 30 or 40 feeds these days. It was really exciting to go to the Czech Republic and see the excitement there about Rails. It reminded me a lot of how things were in the US a couple of years ago.

The rise of Rails has been incredible. There have been growing pains, of course. With wider adoption you begin to accumulate people who aren’t passionate about the tool, and only want to learn it for the resumÃ©, or because a client has asked for it, and I think that dilutes the waters quite a bit. But there will always be a core of passionate users and that’s what makes the community so wonderful. It’s been a really amazing experience to have been a part of that core, almost since the beginning of Rails.

**AkitaOnRails:** You have the rare opportunity of seeing all this from a VIP perspective near Jason and David. And of course, yourself, being one the propellers of the community. Many people think of David as an [arrogant](http://www.flickr.com/photos/eugevon/130610241/) :-) I can perfectly understand his opinionated point of view. What do you think of it, from the perspective of someone who actually know the man?

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/245186199_71f55cc3c72.png)

**Jamis Buck:** David is one of the most confident people I have ever met. My biggest frustration with him is that he’s RIGHT so often. He’s a very clear thinker and jumps right to the core of the issue, which can be very disconcerting if you aren’t used to that. All those attributes combine, I think, to make people who don’t know him consider him “arrogant”. But he’s not arrogant. He doesn’t put people down in order to raise himself up. He’s just extremely gifted, very smart, and doesn’t beat around the bush. I’m very honored to be able to know him. I’ve learned a lot from both him and Jason.

**AkitaOnRails:** I don’t know if I got it correctly but Jason Fried was the one that started 37signals? Can you give us a small glimpse on the origins of the company? I know that David is not from the US, how did they get to meet each other?

**Jamis Buck:** Jason co-founded 37signals, in the late 90’s. It was originally a design consultancy. In 2003, Jason started to work on a project in PHP, and asked around online whenever he got stuck. David responded to his queries several times and Jason finally just asked David if he would write the project. David came on part-time for awhile, then, since he was still finishing school. But eventually, Jason wanted to write Basecamp, and David did all the work on that, part-time, in Ruby. His experiences with that, of course, led to Rails. And eventually David become a partner in the company. That was in 2004, if I remember correctly.

**AkitaOnRails:** Great. And coming back about you. Now that Capistrano 2.0 is finally released, are you involved in some new open source tool?

**Jamis Buck:** With Cap2 out the door, I’m really focused on rewriting Net::SSH and Net::SFTP. Some frustrations with their limitations in writing cap2 has made this necessary :) The only “new” thing to come of this is Net::SCP, which is an implementation of an SCP client in Ruby and which I will release when I release v2 of Net::SSH and Net::SFTP.

**AkitaOnRails:** Oh, and speaking of which, I remember that the former Cap 1.4.1 didn’t play very well on Windows boxes. Is that correct? Any advances in this field or do you feel that supporting Windows is just too much?

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/506252072_642ad7ea39.jpg)

**Jamis Buck:** Well, as far as I know, cap 1.4.1 worked fine on Windows machines. The limitation was that you can not deploy TO Windows. Deploying FROM Windows works fine. And as for making cap deploy TO Windows, I have no plans. The difficulty is that Windows is not a POSIX environment, which is one of the fundamental assumptions of Capistrano, regarding the target machines.

**AkitaOnRails:** Ah, yes. I never tried that, therefore my confusion. You’re right. Well, I think I already got a lot from you. Anything that you would want to say to the Brazilian community? :-)

**Jamis Buck:** _“Stay passionate”_ :) Keep the passion for Rails burning, it’s what makes the community worth belonging to.

**AkitaOnRails:** Couldn’t be better. Any plans for coming here?

**Jamis Buck:** Ha, none in the immediately future :) I’ve got a baby coming in September, which puts a damper on travel plans :) I’d love to visit Brazil someday, though.

**AkitaOnRails:** Didn’t know that. Congratulations!

**Jamis Buck:** Thanks.

**AkitaOnRails:** Well, thanks a lot for your time. It was a very insightful conversation. I know people will enjoy this.

**Jamis Buck:** Thank you very much, Fabio. I’m grateful for the opportunity!

