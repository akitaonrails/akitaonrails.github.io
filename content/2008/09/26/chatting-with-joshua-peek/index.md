---
title: Chatting with Joshua Peek
date: '2008-09-26T02:32:00-03:00'
slug: chatting-with-joshua-peek
tags:
- interview
- english
draft: false
---

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/8/1/468x60.gif)](http://www.locaweb.com.br/railssummit)

This time I had some time with [**Joshua Peek**](http://joshpeek.com/). He was recently [announced](http://weblog.rubyonrails.org/2008/8/16/josh-peek-officially-joins-the-rails-core) as a new member of the Rails Core Team.

He got the honor because of his hard work for the upcoming Rails 2.2, solving the **thread-safety** issue within Rails. Because of his Google Summer of Code project, guided by Michael Koziarski, they were able to make Ruby on Rails truly Thread-Safe, which could be a great boost for virtual machines with native-threading support, such as JRuby.

The interesting bit: he is just 19 years old and 4 years ago he wasn’t a programmer. He started on Ruby with [Learn to Program](http://pine.fm/LearnToProgram/) and he is now a Rails Core member. Let’s get to know him.


 **AkitaOnRails:** Ok, so let’s get started. First of all, it would be good to know more about yourself. Like how did you find Ruby, why you got hooked by it, and what are your “hobbies” in the tech area ￼

**Josh Peek:** Like most people, I originally found Ruby through Rails. At the time, I was only doing simple web design like html, css, js. I had no programming experience. I think I bought some php book, but I could never get into it. So I heard about this “Rails” thing and looked into it. I learned quickly that I really needed to learn how to program and learn Ruby, so I got the [Pickaxe](http://pragprog.com/titles/ruby/programming-ruby) and [Agile Web Development with Rails](http://pragprog.com/titles/rails3/agile-web-development-with-rails-third-edition) book and went from there.

**AkitaOnRails:** This is interesting, one of my goals of interviewing you is because I figured you are pretty young and there are lots of young programmers that feels that learning Ruby is difficult. And you say you never programmed before Ruby, so how was this learning curve for you?

**Josh Peek:** Yeah, I’m currently **19** and I started programming Ruby about 3 years ago. Before I read the pickaxe, I found this little Ruby programming book by [Chris Pine](http://pine.fm/LearnToProgram/). It was really helpful to get into programming. The hardest thing about programming for me, was wrapping my head around OOP. It’s really something you just need to work with to truly understand.

**AkitaOnRails:** Oh, and I forgot to ask, where are you from? Do you study CS?

**Josh Peek:** I’m currently living up in Chicago, IL where I attend college as well. Yes, my current major is Computer Science

**AkitaOnRails:** When you started programming with Rails, what were the things that most annoyed you, if any?

**Josh Peek:** Hmm, I can’t really think of anything that “annoyed” me. It was never a problem because you could either [monkey patch](http://en.wikipedia.org/wiki/Monkey_patch) the issue or fix it and get it out to the entire Rails community.

**AkitaOnRails:** So you started working with Rails as a freelancer? Did you build any open source gems, plugins as well?

**Josh Peek:** Yeah, I started as a freelancer. I technically still am. I used to publish a ton of Rails plugins. I think I went a bit overboard at first. I really don’t have any of those around anymore, but it would be fun to go through them and see how much my views on programming have changed since.

Right now, all my current plugins and code are at [github.com/josh](http://github.com/josh). I tend to just post any personal project I’m working on, on Github even if it’s not done or I think it will be useful at all.

**AkitaOnRails:** Ok, so the main dish Thread-safety! You said you were not particularly ‘annoyed’ by anything about Rails, but you decided to tackle on this challenge anyway, how did it all started?

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/9/26/TwextGoogleSOC2008.png)

**Josh Peek:** I did want to do a [Google Summer of Code](http://code.google.com/soc/2008/ruby/appinfo.html?csaid=AE462A3EF48107C3) project for a while now. However when it came to signing up I did things really last second. I asked around the core team and a few ideas came up, one of them was thread safety.

I wasn’t really even that interested in doing it, I actually wanted to work in [ActiveModel](http://github.com/rails/rails/tree/master/activemodel/README) as my project. However the thread safe project was the only one that was accepted, so I was stuck with it. Before the project started, I had zero experience with threads.

I didn’t even know what a mutex was for, however I welcomed it as a learning experience.

**AkitaOnRails:** Maybe it would be interesting if you could give us an overview of how the Google Summer of Code works, I mean, what are their goals, how do you participate, how difficult it is. Some Brazilians are probably not familiar with it.

**Josh Peek:** Google Summer of Code is a program setup by Google that sponsors students to work on open source projects. The student creates a project proposal for the organization they want to work with, Ruby Central in my case, and it gets approved by them.

You also work with a mentor from the organization. Michael Koziarski (Rails Core) originally suggested that I do the project and so we “arranged” for us to work together.

At the end of the program, you submit your code and if you have completed the project you get paid $5000. And I think $500 of that goes to the open source organization.

**AkitaOnRails:** And you completed the project?

**Josh Peek:** Yes.

**AkitaOnRails:** Cool, and how long is the program?

**Josh Peek:** Around 3 months I think.

**AkitaOnRails:** Ok, back to the more technical stuff. There is something that bothers me a little bit. Of course it is a lot of work to make Rails thread-safe and this is something people were really looking forward to. But on the other hand, the MRI doesn’t use native threads, which essentially means that they are never truly concurrent, is that correct? Maybe other projects such as JRuby could benefit? Is there any real benefits for the MRI itself?

**Josh Peek:** Correct. JRuby is the only true solution if you want real thread concurrency. Ruby 1.9 does support “real” threads. However most of the internal C code is not thread-safe so there is an interrupter around those methods, but I’m hoping that maybe Ruby 2.0 will be fully thread-safe.

**AkitaOnRails:** You probably ran tests for both MRI and JRuby? Did you get improved performance/responsiveness because of the new thread-safe code? Or does it add up some new overhead instead?

**Josh Peek:** Our tests showed some slight improves in MRI, however the app we were testing was a simple test app. We didn’t have a real app we could benchmark since nothing else was thread-safe at the time. JRuby did show some nice improvements, again it wasn’t a real app though.

**AkitaOnRails:** Did you only aim for the thread-safe parts or did you also found and fixed other kinds of bottlenecks in the framework? You probably went through the entire code over and over and you already know it upside down, right? ￼

**Josh Peek:** I did a lot of work on preloading caches on boot up. The easy way out would be to just put a mutex around those caches and call it done. However, I had some extra time so I rewrote a ton of ActionView code.

Preloading means that we are building the cache on boot so it doesn’t need to be modified (or synchronized) while it’s serving requests and this should also benefit non threaded apps as well.

And it’s a huge win for Passenger, if you are using the copy on write feature, since caches built during Rails boot will be shared across multiple process.

**AkitaOnRails:** Awesome, the [Phusion](http://www.modrails.com/) guys will like to hear about that. And I know some people will be lost about [mutexes](http://en.wikipedia.org/wiki/Mutual_exclusion), could you explain a little bit about it for the audience?

**Josh Peek:** The big issue about running multiple threads is shared memory. If two threads try to access and modify the same object, it can cause some major problems. A “mutex” is a type of lock that “synchronizes” your threads so only one thread can access that piece of memory at a time.

However, this does have a performance impact because other threads have to stop while one is accessing the shared memory.

**AkitaOnRails:** I think it is awesome work, specially for JRuby. Did you talk to Charles, Nick or someone from the JRuby Core? I remember that I interviewed Charles and he said that even though they were pushing harder on the optimization of the JRuby runtime, the performance of Rails apps were not improving that much, so the next step would be to try to figure out how to modify Rails itself to behave better. Have you heard anything about this?

**Josh Peek:** Yes, we worked with Charles on some JRuby specific optimizations. He was a lot of help and he answered any of my questions relating to how JRuby synchronizes threads and what operations are atomic.

[Nick Sieger](http://blog.nicksieger.com/) actually volunteered (before GSoC) to tackle the ActiveRecord [connection pool](http://ryandaigle.com/articles/2008/9/7/what-s-new-in-edge-rails-connection-pools). Really a big thanks to Nick, I really didn’t have the experience to tackle that problem and he did a great job on it.

**AkitaOnRails:** Ok, even though the Ruby VM can’t have true concurrent threads, they actually have to deal with concurrent resources, in this case database connections, so a pool was necessary. Was it too much trouble to implement? Was it something that you had to do from scratch or there were prior work on connection pools for Ruby?

**Josh Peek:** Well, I think you better of asking Nick this question. But here is what I understand about it: The previous AR connection implementation did support threads, however it was easy to max out on the allowed number of db connections if a server got blasted.

The connection pool basically recycles old connections and prevents AR from establishing too many. You can actually set his max in your database.yml file with the “pool” option. I think the default is 3.

**AkitaOnRails:** And how does the mentor role work? I mean, did [Koziarski](http://www.koziarski.com/) guide you on specific points he wanted you to take a look on?

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/9/26/506281043_419fd4e72d.jpg)

**Josh Peek:** Koz really help me stay on track. He did a lot of code auditing, and pointed out specific places I should look for problems in the large Rails code base.

**AkitaOnRails:** From the outside it probably feels ‘easy’ to say _‘ok, we just added thread-safety into Rails’_, but this is not something like an external gem or plugin, you actually have to tackle the guts of the framework. How can you be sure you actually touched every part of the code that needed concurrency safety measures?

**Josh Peek:** That’s really what is hard about making code “thread safe”: there is no real way to be sure. You can write a bunch of unit tests and say _‘look, I can prove it’s fine’_. However, the big issues are out of the way. From now on, we’ve decided to classify any further thread safe issues just like normal bugs.

**AkitaOnRails:** Do you think it is ready for prime-time? Or are you still tweaking it?

**Josh Peek:** I think it is ready for those people who have been waiting for a thread-safe Rails. People should start to audit and test their own apps for thread-safe issues and if something comes up, we’ll fix it in core. It’s really hard to test this stuff unless real people are testing real apps against it.

**AkitaOnRails:** At least, _“Rails is not thread-safe”_ is not a good enough reason anymore to not use Rails. This should shut up a few pundits. This Rails 2.2 is going to be interesting, debunking some of these criticisms. Another one is _“Rails doesn’t support i18n”_, thanks to [Sven](http://www.artweb-design.de/2008/9/6/the-future-of-i18n-in-ruby-on-rails-railsconf-europe-2008). What else do you like the most about the next Rails release?

**Josh Peek:** My next little project within Rails is switching over to [Rack](http://rack.rubyforge.org/). Rails 2.2 will include a Rack processor which lets your use it with any Rack server. However we are not fully switching over to Rack, yet. In 2.2 rack is opt-in.

./script/server will still run the old CGI processor. I hope to see CGI deprecated in the next release so we can be Rack only for 3.0.

**AkitaOnRails:** What are the benefits of going for Rack? It may not be so obvious for some people on why change code that is working already (the CGI bit).

**Josh Peek:** There should be some performance benefits, however that wasn’t enough to convince. Right now we have a ton of CGI hacks in Rails. This should clean up a lot of that.

What I really love is the standardized interface to Rails. This means a more universal API for writing ActionController related plugins that will work on any compatible Rack framework. I hope this means more Rails plugins will just work with Merb and vice versa.

**AkitaOnRails:** Having finished your GSoC project granted you the keys for the Rails official repo, is that correct? How does the Rails Core organize itself? Is each person responsible for some particular bit, or everybody else looks after everything?

**Josh Peek:** It seems like everyone has their own little responsibilities depending on what they were just working on. Since I just rewrote a ton of ActionView, I pretty much assume any issues or tickets related to it. I don’t think anyone has a pre-determined area though. People change their interests and that’s fine.

**AkitaOnRails:** But now can you ‘git push’ anything you want into Edge? And by the way, you mentioned you messed a lot with ActionView, but what exactly you changed there?

**Josh Peek:** Yeah, I’ve had commit access a while before the GSoC project (just before we switched to git). ActionView had to be refactored to support the preloading approach I was talking about earlier. So ERB templates are pre-compiled and cached on boot instead of at runtime.

**AkitaOnRails:** So, in 3 years you went from zero to Rails Core, solving the “thread-safety issue” and still having time to study and work on your freelance projects. How does it feel, looking back in retrospective? Did you ever thought you would contribute so much?

**Josh Peek:** 4 years ago, I really never even saw myself programming. I definitely never thought I end up on the Core Team of Rails.

**AkitaOnRails:** After so much you learned, what are the areas in computing that interests you the most? Web Development, any other area such as compilers, OS, etc? What do you intend to do next?

**Josh Peek:** I still really love Web Development. I recently tried some iPhone programming, but I’m not sure how I feel about it yet.

I’d love to try some lower level stuff. I still haven’t had a chance to use the Ruby C API, and I hear it’s really nice. Lately I’ve been doing a lot of work on a javascript project that’s soon to be announced and open sourced.

**AkitaOnRails:** Oh, and by the way, are you also a Mac user? :-) And I think this is it! Any other remarks about what we talked or something you would say to the Brazilian Ruby community?

**Josh Peek:** Yeah, I’ve been using Macs for about 6 years now. I’m not one of those people who switched after they discovered Ruby :-)

**Josh Peek:** And think thats pretty much it, … I was suckered into doing a talk at RubyConf this year, for the GSoC thing. So you’ll probably hear about about “thread safety” there. It’s probably the last time I’ll ever want to talk about Rails and threads again.

Thanks for the questions.

