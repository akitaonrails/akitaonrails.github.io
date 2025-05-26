---
title: Chatting with Evan Phoenix
date: '2008-02-11T22:42:00-02:00'
slug: chatting-with-evan-phoenix
tags:
- interview
- english
draft: false
---

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/524655980_8e68a871a0.jpg)

It was [Avi](/2007/12/15/chatting-with-avi-bryant-part-1) [Bryant](/2007/12/22/chatting-with-avi-bryant-part-2) that evangelized the neat idea of “turtles all the way”, meaning that for a language to be called ‘complete’ it should be able to extend itself. So, the ideal world would have Ruby being extended in Ruby, not in C. JRuby goes as far as it can building up a sandbox for Ruby code to run under the JVM. As cool as it is, we still rely on Java to fully extend it.

Enter [Rubinius](http://rubini.us/) and its author **Evan Phoenix** , currently a full-time employee for [EngineYard](http://www.engineyard.com/). Rubinius borrows heavily from Smalltalk’s concepts of a virtual machine and does as little as possible in C just for the bootstrap and all the rest is developed over pure Ruby.

Rubinius answers lots of questions about going forward over the current Ruby MRI but also raises several other questions that I hope we can nail down today in this interview with Evan himself.

So let’s get started.


 **AkitaOnRails:** It is a tradition now in my interviews to ask about the background of the programmer. What was your path? I mean, what made you come in to the programming world and how did you get into Ruby?

**Evan Phoenix:** I started programming in high-school with a friend of mine. We started a small computer company doing odds and ends and I really got into it. I had gotten into Linux a few years before that, so programming became a natural extension of using Linux.

When I applied to college, I declared myself as a Computer Science major on the application, so I’ve been doing this since about then I guess.

As for Ruby, I got into it in about 2002, when I first moved to Seattle. A friend had just found it and was writing some fun stuff in it and I picked it up on his suggestion. Eventually, I found the seattle.rb, and have been working in Ruby since.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/ey_logo.png)](http://www.engineyard.com/)

**AkitaOnRails:** EngineYard seems to have great faith in the future of Rubinius. How did this relationship start? Can you tell us what are EngineYard’s expectations regarding your work for them?

**Evan Phoenix:** The relationship started mainly with them approaching me about working for them, on Rubinius. So they saw promise in Rubinius on their own, from my presentations and such, and approached me.

Their expectations are that I make Rubinius the best Ruby VM it can be. Thats my basic mandate with them. They’re pretty much the ideal stewards of the project. They allow me to work at the pace I want, they understand the rigors of the work I’m doing, and give me a lot of freedom.

**AkitaOnRails:** Now let’s get into Rubinius. For non-starters how would you define Rubinius? We all know that this is an alternative Ruby implementation, so maybe it would be good to point out what makes it different than the MRI. What are the project main goals?

**Evan Phoenix:** One of the primary goals is to have as much of the system written in Ruby itself. With MRI, none of the core class are implemented in Ruby, all are in C. So we wanted a system that was easier to work with, and thus written in Ruby itself.

Another thing we’ve done is enrich the number of things which are objects, which adds considerable power. An easy example is the CompiledMethod class which Rubinius has. It contains the bytecode representation of a method and can be inspect, manipulated, etc, just like any other object. This opens a lot of new doors with regard to how problems can be solved.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/Picture_1_1.png)

**AkitaOnRails:** It is not so obvious for the brazilian audience to speak of “Squeak”, “Garnet”. Smalltalk is probably less known here than Ruby. The point is that it is well known that you were inspired by the way Squeak is implemented. This led to features like “Cuby”. Can you explain what is so great about the way Squeak is implemented and how it is helping you in the Rubinius project?

**Evan Phoenix:** Well, we’re currently in the process of developing Garnet/Cuby, so those tools aren’t in use really yet. But almost the entire system architecture of Rubinius is modeled off the original Smalltalk-80 Virtual Machine. It defined things like CompiledMethod, etc, which I took name for name into Rubinius.

In addition, the execution model of Rubinius is almost identical to Squeak. A good example is the way in which the system calls methods and figures out how to keep track of where to return control to when a method call returns. All that information is kept in first class objects called MethodContexts. In a language such as C, that information is stored on a processes memory stack. By keeping the data in first class objects, we’re able to query them directly to find out information about the running system. It also vastly simplifies how the garbage collector works.

**AkitaOnRails:** Today you have shotgun. I read somewhere that you consider it ‘cheating’ because this is not an interpreter for Ruby written in Ruby, which will lead to Cuby. It’s more kind of a bootstrapping to ease development. What’s the current state of shotgun, can we use it outside its purpose of developing Rubinius?

**Evan Phoenix:** Shotgun is a virtual machine written in C that provides instructions and primitive operations for running a Ruby-like language. Shotgun itself actually has no knowledge of parsing, compiling etc. It has a very simple way to load code in, and a way to execute it. You could easily write a new language which targets shotgun, in fact, [Ola Bini](/2007/6/21/chatting-with-ola-bini-jRuby-core-team-member) and I have talked a few times about writing a simple lisp-style language that would run directly on shotgun.

The primitive operations it provides are kinda like syscalls in a unix system. They provide very low level operations which are built on. For example, there is an add primitive which adds to Fixnum objects together and puts the result on the stack.

**AkitaOnRails:** This is a personal curiosity. The MRI today uses a simple mark and sweep garbage collector (GC) whereas Java uses a highly customizable generational GC. What did you choose for memory management on the Rubinius VM?

**Evan Phoenix:** Rubinius uses a generational GC, combining a copy collector for the young objects, with a mark/sweep collector for the old. It’s proved to work quite well for us. The trick has been tuning how long an object exists before it is promoted to the old object space. We’ve only tuned it a little. There is a lot more work that could be put into the GC, and it’s architected to only interact with the rest of the system at a few places, so it’s logic can be completely replaced if need be without disturbing anything else.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/421875792_79acde1fba.jpg)

**AkitaOnRails:** We have parties that favors green threads, we have parties that are all go native threads. How are you dealing with threading issues in Rubinius? Will we still have the same kind of global locking that MRI has today?

**Evan Phoenix:** At the moment, Rubinius only has green threads, built on the first class MethodContext objects. It currently uses libevent to allow threads to wait on IO objects quickly.

The plan (likely for 2.0) is to support native threads as well as the current green threads. You’ll be able to allocate a pool of native threads that the green threads can all share. So perhaps you have 100 green threads, you could allocate 10 native threads for them to split time between. Because of the architecture, it’s trivial to migrate a green thread between native threads.

As for the global lock on native threads, no, we don’t consider a global lock a solution for using native threads. If there is a global lock, there is no reason to use them over green threads. Because so much of Rubinius is written in Ruby, we have an easier time of figuring out how to properly lock things to keep all the objects in the system safe. We haven’t really even started this work, but it’s been talked about quite a bit.

**AkitaOnRails:** The current goal is probably to make Rubinius as compatible with the MRI 1.8 as possible. Did you already start any work toward YARV compatibility already? And speaking of YARV, it is the official virtual machine and bytecode compiler for the next release of Ruby. Is there any chance to make Rubinius and YARV byte-code compliant or this is not a short-term goal?

**Evan Phoenix:** We’re actively working toward being 1.8.6 compliant. This a big goal because there is a lot of functionality in there. We’re going to do a 1.0 release of Rubinius once it’s able to run all the specs that 1.8.6 runs and properly runs Rails 1.2, which is a good benchmark.

No, we haven’t done any work yet toward YARV compatibility, but because of how things are architected, we’ll likely just be able to have —yarv flag that you pass to Rubinius to have it use YARV compatible versions of things.

We aren’t currently working toward a common bytecode format between Rubinius and YARV, mainly because there is nothing to be gained by doing that. YARV’s bytecode format is largely internal to YARV only, last I looked, you couldn’t easily save it out to a file. Rubinius operates primarily off .rbc files, which contain a serialized CompiledMethod, and thus contain bytecodes. That being said, they are actually similar and could be unified if we saw the need to.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/2211693208_bf14710240.jpg)

**AkitaOnRails:** Performance is always subject for a lot of discussion and it is still premature to talk about performance under Rubinius, as it is still work in progress. But I read in your blog that it is quite fast already, even surpassing MRI in many tests. How is performance evolving?

**Evan Phoenix:** Currently, our performance is evolving slowly. This is mainly because it’s not a priority for people writing the kernel of Rubinius (the majority of the Ruby code which makes it up). As we get closer and closer to being compliant, we’ll begin tuning things. That being said, I do write code to make Rubinius faster here and there. We went ahead and implement fast math operations to speed of the simple math that people commonly do. We have a simple profiler which can easily be turned on to give developers feedback about how their code is run.

**AkitaOnRails:** One of the main problems for any alternative implementation to Ruby is that it has a lot of C-based extensions, including a handful of core libraries. So if you want to stay “pure-Ruby” you have to re-implement all of them in Ruby. The JRuby guys had to go through something similar. Are there any cross-project collaborations already in this regard?

**Evan Phoenix:** Actually, thats not entirely true. We also saw that the landscape of Ruby includes a lot of C extensions. To make migration to Rubinius faster, we’re written a layer into Rubinius which allows all those C extensions to run (nearly) unmodified, only requiring a simple recompile. These are so that things such as ImageScience, RMagick, postgres bindings, etc can all be used under Rubinius without having to be rewritten.

**AkitaOnRails:** Still about C code, I know it is difficult to deliver a bytecode virtual machine and still be dependent on non-managed C code. Java has some jury rigging toward JNA, .NET as pinvoke. Do you plan something similar for Rubinius so that it can more or less easily speak with C libraries?

**Evan Phoenix:** We actually directly support a mechanism called FFI (Foreign Function Interface), which allows a developer to bind a C function directly as a method call. Here is a simple example:

<macro:code lang="Ruby">module LibC<br>
 attach_function nil, :puts, [:string], :void<br>
end<br>
<br>
LibC.puts “hello!”</macro:code>

The attach\_function line is the primary interface into FFI. You simple indicate which library the function is in (in this case, nil is used because it’s include in the existing process), the name of the function (puts), the types of arguments it takes (just 1, a string), and finally, the type it returns (void, ie, nothing).

Using this, you can tie directly to C functions without having to write C wrapper code.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/Picture_2.png)](http://rubini.us/)

**AkitaOnRails:** You are very right when you say that formal language specs too early in the game can make it difficult to evolve the language. Ruby as been growing for 10 years now, and it feels that this is the right time to start thinking of something like this, so that we can have a baseline from where every other alternative implementation could start. Do you see any efforts towards this end?

**Evan Phoenix:** We’ve been actively working to develop a set of specs (in [rSpec](http://rspec.info/) format) for 1.8. These form the primary mechanism with which we test how Rubinius is doing. These specs are being actively used by JRuby and IronRuby to test their respective Ruby environments. We’re currently in the process of moving these specs into a generic Ruby spec project to try and begin moving things toward a more formal standard.

**AkitaOnRails:** Another recurring question is about Rails, of course. Any new Ruby implementation today will have to face the inevitable question: does it run Rails already? :-) Rails is serving kinda like a ‘mini test suite’ and baseline for most implementations. How is Rubinius performing on this matter?

**Evan Phoenix:** When we run Rails, we know we’re close to a 1.0. :)

**AkitaOnRails:** You have a very interesting approach toward open source management: everyone that sent you a good patch gains commit access to the repository. How is this working for you? Isn’t it a bit ad hoc or people tend to follow your lead and your list of priorities?

**Evan Phoenix:** It’s actually working out great so far. By being spec/test oriented, new people have a place to start, either writing missing specs or making existing ones pass. Those become great intros into the whole system for them. They then begin to explore a bit more and commonly find more and more they’d love to help with. Because we have a lot of work to do in a lot of different places, people don’t have to worry about my priority list, since it’s usually involving things which others don’t need to be actively concerned with.

I really can’t say enough about the people who contribute. The one patch barrier has proved to work great because while we’ve now got over 60 committers, not once have I had to pull commit rights from someone. Sure, people mess up, but in every case, the person has corrected the behavior and/or code.

**AkitaOnRails:** One byproduct of this commit access approach of yours is the integration of rSpec into the Rubinius project so that you have a nice requirements tool and test suite. Do you practice Behavior Driven Development? Or this is covering just a small sub-set of the project?

**Evan Phoenix:** I’m largely a testing newbie, simply following the guidelines set by Brian Ford, the primary spec keeper of the project. It has proved to be a great tool for viewing how the project is progressing.

**AkitaOnRails:** As many other Ruby projects, Rubinius is also managed over GIT. There’s been a lot of fuzz around Git and Ruby these days. Do you think there is a new trend here? Why did you decide to go with GIT?

**Evan Phoenix:** Yeah, I think that GIT is picking up as a trend, because of the features it offers over subversion mainly.

The big reason we decided was it’s feature set. One big feature I love is local branches, allowing a person to manage a number of outstanding changes without trampling on each other.

We haven’t yet, but we plan to exercise the great merge / public branch capabilities.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/504590792_2819a866a8.jpg)

**AkitaOnRails:** We heard from Ezra’s [recent interviews](http://podcast.RubyonRails.org/programs/1/episodes/ezra-zygmuntowicz) about your new experiment on multi-VM. That would be a blessing for deployment without we having to deal with several processes in a mongrel cluster. Can you describe this feature and pin point its advantages?

**Evan Phoenix:** It’s pretty experimental currently, but it will only get more stable over time. The idea is that you can spin up a whole new VM in the current process. This new VM is completely separate from other VMs, living in it’s own native thread and having it’s own garbage collector, etc.

There is a mechanism for VMs to communicate with each other though, and this allows them to coordinate work. This would mean that a primary thread could accept new connections, then pass them off to a new VM to actually process. This allows you to process connections in actual parallel, in addition, because the VMs are completely separated, this even works for non-thread safe applications like Rails.

**AkitaOnRails:** Ezra also mentioned about a possible mod\_rubinius in the making. How is it going? This definitely makes the Rubinius stack even stronger. Together with Merb, Rubinius plus multi-VM capabilities plus mod\_rubinius would be a killer deployment package.

**Evan Phoenix:** Yes, a mod\_rubinius project is just beginning. The multi-VM code and mod\_rubinius overlap a bunch, so you’ll be able to have VM pools for sites, all managed through apache. We’re hoping that mod\_rubinius can really simplify the Rails/Ruby deployment picture. It will operate similarly to mod\_python, allowing a VM to remain running between requests, and likely even run background tasks.

**AkitaOnRails:** How long do you guess we are from a fully MRI-1.8 compatible release?

**Evan Phoenix:** We still don’t have a firm date, mainly because what fully complaint MRI-1.8 is is still unknown. We are still adding specs, working to properly define 1.8. That being said, we’re really hitting a stride and progress is advancing rapidly. We’re very close to properly running Rubygems. Ezra recently was able to run Merb on top of Rubinius, running under webrick.

I’m going to be doing a 0.9 release this week, because we’ve made so much progress since 0.8. My big hope is that by RailsConf in May, we’ll be running Rails. But don’t hold me to that. This is open source after all. :)

**AkitaOnRails:** Thanks, I think this is it.

**Evan Phoenix:** Thanks for your patience!

