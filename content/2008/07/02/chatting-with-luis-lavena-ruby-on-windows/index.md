---
title: Chatting with Luis Lavena (Ruby on Windows)
date: '2008-07-02T14:16:00-03:00'
slug: chatting-with-luis-lavena-ruby-on-windows
tags:
- interview
- english
draft: false
---

This time I interviewed [**Luis Lavena**](http://blog.mmediasys.com/). If you’re a Ruby developer working on Windows, you owe him a lot! After all he is the maintainer of [One-Click Ruby Installer](http://github.com/luislavena/rubyinstaller/tree), the main Windows Ruby distribution. It is a lot of work to maintain such a distro and Luis explains all the hoops necessary to achieve this. The main message: we need more collaborators! Anyone can rant, but there are a few that actually step down from the pedestal and get their hands dirty.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/7/2/325572435_f1f1382372.jpg)](http://www.flickr.com/photos/diegal/325572435/)


 **AkitaOnRails:** Ok. So, let’s start. First of all thank you for your time. This is very funny because we are like 5 hours apart. You’re in Paris right now, but I understand you were in Argentina. Can you tell us what you are doing now?

**Luis Lavena:** Yeah, funny indeed. Right now I’m Technical director of an interactive and design agency with offices in NY and Paris. My job is to bridge the design field with the technology one, mostly on web based application development.

I’m from Argentina, live there, family and friends. Now moved a few months to boost some developments and get first steps of the new organization in place.

I’m from a small province named Tucuman, northwest area of Argentina (1200 kms from Buenos Aires to be exact)

**AkitaOnRails:** Awesome, have you ever been in Brazil? Do you have contact with other Latin America Railers?

**Luis Lavena:** Even though Brazil is so close from Argentina I had never been there, which is bad. I have several friends that lived there over the years.

I keep in touch with several Rubists and Railers of Latin America, but most with the ones in Argentina due to several meetings we had during the years [RubyArg](http://lista.rubyargentina.com.ar) mailing list has been working.

**AkitaOnRails:** I am very interested in understanding how the Railers are organizing themselves in Argentina as we, in Brazil, are a growing community as well. Do you see new programmers going straight to Rails or is it the usual move from Java/others to Rails? Are companies adopting it, or Rails (and Ruby in general) still has a long way to go there as well?

**Luis Lavena:** Well, there is a huge number of developers that came from Java and dotNET stuff (mostly Java) and they are playing with Rails, there is also lot of developers that do Ruby for administrative stuff or even creating games with it.  
Companies that develops software still need to adopt Ruby/Rails for their business, the biggest problem with that is the lack of support shaped as companies like Sun or some consulting services for Java. (or even Microsoft).

**AkitaOnRails:** Going back to the past, how did you start in programming in general? Did you study computer science, or were you dragged in there in some other way? And, finally, how did you stumble upon Ruby and Rails?

**Luis Lavena:** It’s funny, I started programming back in 1989, playing with sprites and GOTO’s with BASIC on a Z80 computer.

I officially didn’t finish my degree on CS, since job and fun stuff distracted me away from it. I firstly meet Ruby back in 2001, loved its syntax, enjoyed it’s verbosity but it was not mature enough for my needs, at least not in Windows.

Even though I was using Python for so many years, I internally used Ruby to manage several stuff, from simple scripts to later rake tasks that helped us build our tools.

With Rails it was kind of different, since we started to look for alternatives to Zope and we bet on Rails at that time (0.10 or 0.12 at that time, if memory plays nice with me).

I can say I don’t regret the bet on Rails at that time.

**AkitaOnRails:** It is very interesting to see professionals like you moving out from your zone of comfort toward something ‘unknown’ as Ruby and Rails. Most programmers are very defensive and even aggressive on trying to find justifications for not using neither. Did you feel like that back then? What drove you towards Ruby?

**Luis Lavena:** Well, I’m used to change languages to fit my needs.  
Keep in consideration that our first choice was pre-J2EE era or dotNET stuff, we analyzed which would provide us better solutions in the long run and we decided to avoid them.

Java stuff sounded at that time, and until today, expensive for business. Argentina is not a country where you will find customers with huge budgets to invoice them the cost of using tools designed for other markets.

Banks and such can pay the luxury of have everything running with J2EE, but that doesn’t work when you try to go smaller and agile. (mostly based on experiences with the market flow in Argentina).

**AkitaOnRails:** It is even more daunting considering that you decided that you wanted Ruby on Windows, you probably didn’t find anything reasonable and decided to tackle the problem yourself. Is that how it happened?

**Luis Lavena:** I’ve been forced to use Windows for many years, mostly related to hardware development in the video broadcast field. Moreover, I’m a BSD user and Linux one, even played some years with Macs and lately with OSX.

So that restriction forced me to build most of my tools around that limitation.  
Ruby allowed me to enjoy that limitation by been expressive, which made me more productive in that field.

Ruby is not capable to handle my main requirements for video processing, but it still powers 70% of my environment, along with Open Source Software and Freeware.

I’ve been using Ruby for so long, that I thought the community, now that it’s growing, would maybe value the experience and the willing to help in this particular scenario.

So instead of keep scratching my itch in the shadow, I decided to contribute back and help others that search for the same stuff. So you can say I’m trying to balance my karma.

**AkitaOnRails:** Americans probably don’t understand this but in emerging countries such as Brazil, people don’t actually have much choice, most are not educated enough (_cof_ english _cof_) and so they find lots of barriers. The last resort for everybody is Windows. I think it is the same thing in Argentina. Railers here don’t simply migrate to Macs or Linux, I would say that at least 90% of all developers are locked in to Windows for one reason or another. Is it the same in Argentina, I presume?

**Luis Lavena:** Even though I don’t like it, I must agree. Thankfully the Universities started to change that some years ago, giving talks and been more open to Linux community, which grew a lot.

Still, there are plenty of users and developer that are locked in to some corporate / mid-size environments or they require to run Windows for some proprietary hardware or such.

So, we (as the community) can’t get to those developers without being more open minded or provide tools that ease the path between their current environment and alternative tools.

**AkitaOnRails:** But for some reason there seems to be near to zero interest from the community on supporting Ruby on Windows. I mean, there are people like you, some RubyGem developers that go through all the trouble of making available a binary for win32, but it is not enough it seems. How did the [One-Click Ruby Installer](http://rubyforge.org/projects/rubyinstaller/) began, did you create it or you inherited it?

**Luis Lavena:** Yeah, I agree with you, but I cannot blame them, after all, everybody just scratch it’s own itch ;-)

I’ve inherited One-Click Installer from [Curt Hibbs](http://curthibbs.wordpress.com/), who also inherited from [Andy Hunt](http://en.wikipedia.org/wiki/Andy_Hunt_(author)) and other contributors.

The truth is that for many years I’ve been using my own version of Ruby, compiled in-house, so we had control over it. We didn’t patch it in any way, we like to have the whole process documented and automated, so we can take a look to the specific components updated that introduced conflicts.

One-Click Installer, on the other hand, relies on some builds made by the current ruby-core developers and maintainers, which make the process of finding the proper dependencies a bit hard. That build also imposed other problems, but that will require more time to explain

**AkitaOnRails:** Haha, I want to dive in to the more technical stuff so people can better understand the current situation on Windows. How different is Ruby on Windows compared to Ruby on Linux, for instance? The most obvious thing is that any Gem with C Extensions without proper binaries for Windows will fail. Trying to execute shell commands will fail and [RubyInline](http://www.zenspider.com/ZSS/Products/RubyInline/) as well. What else?

**Luis Lavena:** Hehe, that’s just the tip of the iceberg, let me show you one example. Let’s say that you have a package ABC that was build for your current distribution of Linux. That specific version of Linux links to a common runtime that handles the basic commands like file handling, console, etc. That is often called CRT (C Runtime) and on Linux, glibc.

So, your distro of Linux is linked to this glibc version A.B.C. If your distribution upgrades glibc version (like from 2.2 to 2.5) then you’re forced to:

1. upgrade all your installed packages, or
2. build everything from scratch.

I’ve even heard of some of these upgrades go so bad that users are forced to start from scratch. Windows, on the other hand, cannot break 2 billion applications just because of a change of CRT, so they keep old versions and maintain compatibility in the MSVCRT.dll file (where the base version is 6.0).

A plus for Windows is that you can have several CRT co-existing in your OS, the bad thing is that you cannot safely link to one CRT and use components that link to another version without worrying about segfaults and such stuff.

I tried to condense this information in [a post](http://blog.mmediasys.com/2008/01/17/ruby-for-windows-part-1/) some time ago. So you can see, the lack of development tools is not the worst problem dealing with Windows development.

**AkitaOnRails:** Interesting. And another thing is the Visual Studio compiler vs [MinGW](http://www.mingw.org/). Can you give us a glimpse on why you chose MinGW? Is it just because VS is commercial and developers would have to pay?

**Luis Lavena:** Visual Studio is great, but only when you can pay for it. The free versions lack some stuff that is very useful, like Profile-Guided Optimization (PGO) which is being used to build Windows binaries of Python, as an example.

The thing with VS, even the free versions, is that you’re not allowed to distribute them, I think it is even illegal to link to the download URL/page of it. So even for our automated sandbox project, Visual Studio would be required to be manually downloaded, installed and configured.

Thankfully in the latest versions you don’t need to install Platform SDK kit, which was 1GB. VS versions link only to the latest version of MSVCRT, which then force us to relink every library that ruby depends on with it (and Ruby source code depends on lots of externals).

Also, Ruby doesn’t use the safe CRT version of string copy functions, so you need to use a compiler flags just to avoid them… So after weeks of hard work getting it built with VC8 and every dependency, you end with something that performs almost the same, since there is no performance gain (but now you have less hair).

MinGW, on the other hand, was closer to a Linux environment, so most of the tools worked out of the box. The good part was that we didn’t require to build all the dependencies with it, since by default everything links with MSVCRT (the default CRT on Windows). MinGW also provides some cross-compilation tools that lets you build, using Linux environment, share libraries (dll) and executables for Windows.  
I can consider that a plus, dunno what others think about it

**AkitaOnRails:** Wow, this is really overwhelming and I recommend anyone interested in the details to take a look at your [blog](http://blog.mmediasys.com/). But all that said, you now have everything in place, a proper process and such, I assume. If I am a Windows C developer and I want to contribute, where should I go first, I mean, so I can know what tools to use, how to build stuff and so on?

**Luis Lavena:** That’s the good part! [Gordon Thiesfeld](http://blog.robustlunchbox.com/) and I have been working on two packages for new One-Click Installer: Runtime and Developer Kit.

Runtime ships the minimum Ruby+RubyGems so you get started, and it can also be used as modules for other installations. The DevKit provides the MinGW environment so you create Ruby extensions or even install the ones that are not pre-built for Windows but they are easy to get it.

This DevKit will not only let you get easily working with Ruby on Windows (and have access to some great and cool Rubygems) but also lets you contribute back to Ruby project. How? Easily, the Ruby Installer project (on [Github](http://github.com/luislavena/rubyinstaller/tree/master)) is self-hosted. What does it mean? It is possible for you to replicate our development environment anywhere, hack your changes or even debug Ruby’s own C code and contribute back to the community. We have been doing that for several months, and it’s working, how cool is that?

**AkitaOnRails:** That sounds awesome, I didn’t know that, and I bet lots of developers didn’t also. So I hope C developers reading this can get up to speed with this now. Another detail: RubyGems. How difficult it is to port a Gem with C Extensions to provide a Windows binary when you install it?

**Luis Lavena:** Oh, that requires that some developers don’t fall into platform specific tricks to make their tools work. One example, that is also a bad practice, is to use hardcoded paths…

Another one is to rely on the existence of some external tools, which sometimes are not available or developers/users didn’t install it. And I’m not talking about Linux-Windows platform issues, even between Linux distros that is a problem.

<object width="506" height="382">	<param name="allowfullscreen" value="true">	<param name="allowscriptaccess" value="always">	<param name="movie" value="http://www.vimeo.com/moogaloop.swf?clip_id=1266418&server=www.vimeo.com&show_title=1&show_byline=1&show_portrait=0&color=&fullscreen=1">	<embed src="http://www.vimeo.com/moogaloop.swf?clip_id=1266418&server=www.vimeo.com&show_title=1&show_byline=1&show_portrait=0&color=&fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="506" height="382"></embed></object>  
[Installing Gems on RubyInstaller](http://www.vimeo.com/1266418?pg=embed&sec=1266418) from [Luis Lavena](http://www.vimeo.com/luislavena?pg=embed&sec=1266418) on [Vimeo](http://vimeo.com?pg=embed&sec=1266418).

**AkitaOnRails:** So it is pretty much dependent on the quality of the original Gem, right? The cleaner the code the easier to port it, of course. But does your DevKit provide some shortcuts to achieve that? And what about RubyInline, does it simply break down?

**Luis Lavena:** Yeah, I’ve learned over the years that you shouldn’t assume anything about the environment your application is supposed to run, in that way, you avoid those mistakes.

Thankfully RubyInline is playing nice with Ruby Installer (One-Click Installer that uses MinGW) for a few versions back (Thanks goes to Ryan Davis to include those patches).

The current, VC6 build of One-Click Installer is not safe, since you need VS6 to work, which is no longer available. I’ve heard of users enjoying Sequel, Ambition and ImageScience on Windows thanks to those patches.

**AkitaOnRails:** Correct me if I am wrong, but isn’t it a way to embed C code snippets mixed in Ruby code? This means it will natively compile this snippet to run? How does it achieve this in a Windows environment that doesn’t have compilers by default?

**Luis Lavena:** We managed to sneak some patches to Hoe and RubyInline that “bundles” the pre-built extensions into the gems, so users don’t need a compiler in those cases.

Anyway, right now using VC6 build of Ruby requires man power to maintain those gems and keep up with new releases, which takes time. Up until now I was the only man in the show (since we own some VC6 licenses). Building everything for everyone is a burden I’m looking forward to drop into DevKit.

**AkitaOnRails:** Are you the ones maintaining the Windows versions of Gems or each Gem developer takes care of his own project? Is there a central repository for Windows-ready Gems? Is the DevKit already available, by the way?

**Luis Lavena:** For some projects I’m the only one maintaining gems for Windows, for others I only had contributed patches and other users manage the builds. There is no central repository for Windows gems since I want RubyForge to be the central one.  
In any case, I’m pushing MinGW specific ones based on github forks here:

<macro:code>
<p>gem list <del>-remote —source http://gems.rubyinstaller.org<br>
-</del>-</p>
<p>The devkit is already available, but we are wrapping it into a good Windows Installer package. You can get your hands dirty and grab the sandbox project from <a href="http://github.com/luislavena/rubyinstaller">Github</a> to get your environment, or simply <a href="http://www.rubyinstaller.org/sandbox/">download the packages</a>.</p>
<p><strong>AkitaOnRails:</strong> So, as far as tools and processes are concerned you’re doing a great job. But then there is the Ruby code that, by itself, is a big challenge from what I hear. You mentioned to me that it doesn’t even look like C. What are the biggest problems? Technical or getting help from the Ruby-Core mailing list, or both? And what about test suites, how are you squashing compatibility bugs?</p>
<p><strong>Luis Lavena:</strong> To be honest, sometimes peeking into Ruby C code gives me headaches. There are lot of macros and definitions and macro conditions that happens in the middle of a if .. else block… The hardest part, besides tracing the bug is getting feedback from ruby-core. Several times I’ve <a href="http://blog.mmediasys.com/2008/03/06/is-windows-a-supported-platform-for-ruby-i-guess-not/">expressed</a> my concerns about it on mailing lists, #irc and on my blog.</p>
<p>Several times I asked if it was OK to get some errors in the unit tests of Ruby itself and sometimes got answers, but sometimes didn’t. Thankfully we no longer need to base our testing quality in bundled unit tests of Ruby. We started to find issues with the Ruby implementation on Window using the Ruby Specs created by the guys at the Rubinius project and that most of the Implementations (IronRuby and jRuby) actively contribute and use as foundation of their interpreters.</p>
<p><strong>AkitaOnRails:</strong> So, speaking of which, <a href="http://blog.emptyway.com/2008/04/06/the-rubyspecs-quick-starting-guide/">RubySpecs</a> how far is Ruby on Windows from passing it through? Or is it already?</p>
<p><strong>Luis Lavena:</strong> Well, that’s a big tasks. First we started making MSpec to work properly on Windows, since RubySpec require some audit to remove some hardcoded paths in it. So we started to add guards around things that are not supported or don’t even work on Windows in <span class="caps">MRI</span>.</p>
<p>That takes longer since we need to review the results on each platform, dig into the Ruby documentation (that is sometimes lacking) or take a deep breath and look at the C code to find what is actually doing.</p>
<p>If we had <strong>more man power</strong>, maybe we could finish guarding all the code and get a clear running specs on Windows. Right now there are many that just break or segfault.</p>
<p><strong>AkitaOnRails:</strong> You should document this process so people can help, if you didn’t already :-) Now speaking of more practical stuff: Ruby on Windows, today, is it a viable runtime to run Rails apps on Windows? Even production apps? You worked with Zed Shaw on Mongrel for Windows, right? Did you try the newest FastCGI support from Microsoft for <span class="caps">IIS</span>?</p>
<p><strong>Luis Lavena:</strong> Hehee, documentation, documentation, it’s totally overrated. We planned to have several screencasts in the RubyInstaller website, but it just remains as <em>‘coming soon’</em> for now.</p>
<p>Not only you can develop Rails applications in Windows (as I do too), but I know several companies that run it side-to-side with <span class="caps">IIS</span> or even Tomcat.</p>
<p>Even 2 years after Zed created it, Mongrel still rules the scene of Ruby web servers. I didn’t do too much to Mongrel itself, since Zed created something that worked out of the box on Windows with small tweaks.</p>
<p>I created something to run Mongrel as a service (mongrel_service), which helped several people to sneak in Ruby and Rails into their corporate environments, even talking to <span class="caps">MSSQL</span> Servers.</p>
<p>I personally didn’t test the <a href="http://mvolo.com/blogs/serverside/archive/2007/02/18/10-steps-to-get-Ruby-on-Rails-running-on-Windows-with-IIS-FastCGI.aspx"><span class="caps">FCGI</span> support on <span class="caps">IIS</span></a>, but I was the one fixing it to be bundled with One-Click Installer so some users could enjoy it. We could say it works.</p>
<p><strong>AkitaOnRails:</strong> About performance, Windows seems to have an inherent condition: in the same machine when I start, let’s say, a simple <span class="caps">IRB</span> in Windows, then I dual boot to Linux and run it, it seems to open up much faster (not exactly a scientific experiment :-). What is your experience around Ruby performance on Windows?</p>
<p><strong>Luis Lavena:</strong> There are performance issues related to the C code being generated by the compiler, and issues related to the OS and I/O handled by it. Loading <span class="caps">IRB</span> on Windows could be requiring RubyGems in the background, which in turn needs to scan and load all the gems specifications. I try to keep <code>RUBYOPT=rubygems</code> out of my environment variables.</p>
<p><strong>AkitaOnRails:</strong> By the way, why I have the impression that I see <span class="caps">RUBYOPT</span>=rubygems being recommended in every windows tutorial I see?</p>
<p><strong>Luis Lavena:</strong> <code>RUBYOPT=rubygems</code> is the part of the magic we must avoid.<br>
On Linux, if you start creating a script and you need a gem, you start with:</p>
<hr>
ruby
<p>require ‘rubygems’<br>
require ‘some_gem’<br>
<del>-</del></p>
<p>The same should be done for Windows, it is not painful, it’s good practice. <span class="caps">RUBYOPT</span> is a shortcut that I dislike, I haven’t seen a Linux distro that enables that by default, and I dislike that being set on Windows. (of course, that’s my personal point of view)</p>
<p>So to avoid falling into standard testing procedures, I keep using a simple but good sudoku solver that exercise recursion, array and conditions of the VM instead of being IO bound.</p>
<p>You can see that, with funny results on <a href="http://blog.mmediasys.com/2008/04/24/contributions-speedup-and-less-quirks-for-us/">my blog</a> (see <em>“Rubinius, RubySpecs, and speed.”</em> section of the post).</p>
<p>The main thing is that VC6 make it slow. Then you have I/O bound stuff (I/O stuff on Windows is not as good as Linux). I consider the default VC6 build of Ruby on Windows painfully slow. On the other hand, the MinGW one is snappier but I still think that there is a huge path for improvement.</p>
<p><strong>AkitaOnRails:</strong> So, overall, Ruby on Windows is always evolving which is great, runs great on Windows, which is remarkable, but it could use some more help, right? Do you think more Windows C developers would help? I mean, adding more hands would help improve its quality?</p>
<p><strong>Luis Lavena:</strong> Definitely!</p>
<p><strong>AkitaOnRails:</strong> What kind of developers, I mean what one should know to help?</p>
<p><strong>Luis Lavena:</strong> Dunno if Ruby “core” will accept that, I lately only hear the fork word around <span class="caps">MRI</span> ruby. Moreover, we can squash bugs in the Ruby for Windows implementation, but we cannot improve the quality too much since those changes would affect other platforms too.</p>
<p>The bad thing is that there is no clear separation by platform of specific code, everything is around a series of macros and compilation conditions that makes it hard to track (for the non-sadistic developers).</p>
<p><strong>AkitaOnRails:</strong> Which reminds me of the Phusion guys with their <a href="http://www.rubyenterpriseedition.com/">Enterprise Edition</a> which is a fork of <span class="caps">MRI</span>. Did you try to take a look on the copy-on-write GC patches from them? Maybe have it on the Windows version? Ruby on Windows itself is a ‘fork’. You end up having to synchronize your trunk with theirs, is that how it works?</p>
<p><strong>Luis Lavena:</strong> Honestly I didn’t had time to look at Enterprise Edition, even though I followed all the posts and the discussion of those patches in ruby-core. The funny thing is that the latest releases of the Ruby 1.8.6 branch are giving me headaches (more than looking at the C code). They cannot even complete the self-tests and segfault with some extensions like the mysql gem.</p>
<p><strong>AkitaOnRails:</strong> Yes, it has been causing a lot of fuzz around the community, and it should. Hope they can get around it soon. Well, I think I already took a lot of your time. Is there any subject you would like to tackle, or at least some message for your younger brazilian community?</p>
<p><strong>Luis Lavena:</strong> Yeah, don’t be afraid to ask questions, don’t feel ashamed for using Windows as Platform. You can accomplish great applications using Windows, and you can infiltrate more easily into corporate environments with it.</p>
<p><strong>AkitaOnRails:</strong> Oh, which reminds me of one last question that everybody asks me all the time – and I shall forward it to you, as you’re a Windows developer: what are your tools of choice to edit Ruby/Rails projects?</p>
<p><strong>Luis Lavena:</strong> I mostly use Free or Open Source stuff, so I’ve been using <a href="http://www.activestate.com/store/download.aspx?prdGUID=20f4ed15-6684-4118-a78b-d37ff4058c5f">Komodo Edit</a> (not Pro) and <a href="http://www.pnotepad.org/">Programmer Notepad</a>, since sometimes I use them to work on C, FreeBASIC and Assembler code for embedded hardware.</p>
<p>Lately I’ve been using a lightweight Editor called <a href="http://intype.info/home/index.php">Intype</a> that ships with some bundles to mimic TextMate, but I really don’t take advantage of them. I used NetBeans for a while, but after 500MB I just closed it :-)</p>
<p><strong>AkitaOnRails:</strong> Haha, and what would you recommend for a beginner Rails programmer?</p>
<p><strong>Luis Lavena:</strong> To get started NetBeans is good, but with practice they will learn that even notepad is enough to code.</p>
<p>(PS: We are already including Enterprise patches for latest issues on MinGW build! :-)</p>
<p><strong>AkitaOnRails:</strong> Haha, right. Well, I think this is it. I think this will reach a broader audience and call the attention of Windows developers out there. Thanks a lot!</p>
<p><strong>Luis Lavena:</strong> Thanks to you Fabio.</p>
<p style="text-align: center; margin: 5px"><a href="http://www.flickr.com/photos/diegal/325555121/"><img src="http://s3.amazonaws.com/akitaonrails/assets/2008/7/2/325555121_e6e22ea444.jpg" alt=""></a></p></macro:code>
