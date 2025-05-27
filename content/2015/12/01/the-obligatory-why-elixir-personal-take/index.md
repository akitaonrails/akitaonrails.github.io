---
title: The Obligatory "Why Elixir?" Personal Take
date: '2015-12-01T13:26:00-02:00'
slug: the-obligatory-why-elixir-personal-take
tags:
- learning
- beginner
- elixir
- english
draft: false
---

So, I've been studying and exercisizing quite a bit with Elixir. José Valim recently announced the new features of the upcoming [Elixir 1.2](https://twitter.com/josevalim/status/670595716776116224). The language design is already elegant, lean, and it keeps gradually polishing itself.

First and foremost, I am a Web Applications Developer. I deal with Ruby on Rails applications and infrastructure. So, I am not a Desktop developer, a Mobile developer, Games developer or a Tools developer. This is very important to get out of the way right from the start.

And by the way, as I will focus my programming efforts more and more into Elixir, and it does not mean I am "switching" from Ruby to Elixir. I don't need to make exclusive choices, and in my mind, at least for a period of time, Rails joining forces with Phoenix will be a very difficult to beat combo for my web development strategies.

I know, Phoenix is built like Rails so why not just switch altogether: because most content-based sites don't need the concurrency aspects of Phoenix, and I said "for a period of time" because Rails still has a humongous ecosystem with more mature gems that make development easier and faster. This can change in the future, but for now the combo makes sense as I can build a normal website in Rails as I would normally do (with Devise, ActiveAdmin, Spree or whatever) and add Phoenix for stuff like WebSockets (real-time notifications, real-time chatting, background jobs that can be run more efficient than Sidekiq, etc).

This article will summarize my personal take on 2 fronts: 

* [Other Developer Roles than just the Web](#developer-roles)
* ["Functional" Concepts that Really Matter](#functional-concepts)
    - [Immutability and Opaque Message Passing are VERY important](#immutability)
    - [Coroutines and Schedulers](#coroutines)
    - [Static vs Dynamic Typing is still controversial](#static-dynamic)
    - [Fault Tolerance: Don't fear your code](#fault-tolerance)
* [Summary](#summary)

As anything that I want to argue about, this is **lengthy**, but it wouldn't be nice to just state something without further elaboration. In this quest for understanding, I may have confused a bit or two, so let me know in the comments section below if there are things to fix or to explain in more detail.

Let's get started.


<a name="developer-roles"></a>

### Other Developer Roles than just the Web

In a Desktop environment, you will definitely want to make a combination of [Node-Webkit](https://github.com/nwjs/nw.js/) with native libraries. If you're in specific corporate environments, you won't have any more choices than plain WFC based .NET development of Java Swing. Your options have been set for quite some time, and even Visual Basic.NET still has its place. Specific toolchains will be dictated by Microsoft and Oracle/Java Community Process

In Linux environments you will still use wrappers around GTK+, Qt ot similar toolkits. There is not a lot of ways around this.

If you're a Mobile-first developer, you **do** need to learn your way into Swift and Objective-C (to some extent) for iOS and the specific Java flavor for Android's Dalvik/ART. But I will argue that you have a lot to gain in native development if you use [**RubyMotion**](http://www.rubymotion.com/). Or, you can simply keep following Facebook's [React Native](https://facebook.github.io/react-native/) endeavor. There's a lot of fragmentation in this environment, you can do as little as possible with Web Mobile and Phonegap/Cordova, and build compelling apps with tools such as Ionic Framework. The only consensus is that if you really want to build the advanced next gen stuff, you want to dive deep into the native frameworks each platform has to offer.

If you're a Game Developer you want to be as close to the metal as possible. It's definitelly feasible to write perfectly playable mobile games using any number of Javascript libraries together with HTML 5's technologies such as the Canvas and WebGL. But for the next gen blockbuster you will either use mature engines such as Unity or Unreal or even build your own if you're really invested in this field. This will require you to actually know your way into C/C++ programming. Really depends on how deep you want to go down the rabbit hole.

If you're a Tools Developer you will have the benefits from both old and new generation of languages. If you're closer to the Linux Kernel you will really need C/C++ in your baggage. But for the new generation of light containers (LXC), Docker, you can benefit from **Go**, an application development environment suited to make life easier than having to handle C/C++ idiosyncrasies. **Rust** is another great new choice to make it easier to - among other things - to write memory-leak free small libraries and tools (I am mentioning that in particular because it's important for languages like Ruby or Python to be able to add performance by binding to C-based native libraries and Rust make this task easier).

Different languages have different teams and different long term goals, which is why it's not apples and oranges to compare languages. Go, for instance, is heavier than Rust, but both are good for command-line tools, specialized daemons, and in the case of Go, networking-heavy and concurrency-heavy endeavors.

In my eyes, Go is a "better" Java or C++. And don't interpret this wrong: Java is still a very fine language and platform. There is hardly anything that come close to the maturity of the JVM and the extensive ecosystem behind it. I would not think for a second in trying to rewrite complex systems written in Java such as the Lucene library or Elasticsearch/SOLR solutions, for example.

But the power of Standard Java is difficult to unleash without some warming up for the HotSpot to pick up steam. It makes it not a great solution for command-line tools. But now you have a good middle ground with Go. You also don't have a good time embedding Java into other platforms, and then you would need to go back to C, but now you have another good middle ground with Rust.

If you want to unleash different programming models, specially those more suited to concurrent abstractions such as the [Hoare's CSP](https://en.wikipedia.org/wiki/Actor_model_and_process_calculi_history) like Actor model, you can try **Scala** with [Akka](http://akka.io/) (which is now the standard actor library) and **Clojure**'s [Pulsar/Quasar](http://blog.paralleluniverse.co/2013/05/02/quasar-pulsar/). Akka and Quasar are the ones that come "close" (but can never match) Erlang's built-in OTP platform.

For the Web at large, you can do just fine with the current (ever changing, unstable) Node.js ecosystem, Python (Django, Plone), Ruby (Ruby on Rails, Sinatra), PHP (Zend, Laravel), even Perl has it's place. Combined with mature services in different platforms (Elasticsearch in Java, PostgreSQL in C, RabbitMQ in Erlang), any big and complex Web Application can be written with any number of best-of-breed tools and combinations that best suit your needs.

This is an unfair, short overview, of course. I didn't cover every aspect of computer science or industry. There are several other active and useful languages such as Lua, Haskell, Fortran, Ada, Julia, R,  The message being: you don't need to choose a single language, it will really depend on what you're going to deliver. And a true craftsman will master many tools to the the job done in the best way possible.

<a name="functional-concepts"></a>

### "Functional" Concepts that Really Matter

[I wrote about my opinions](http://www.akitaonrails.com/2015/10/28/personal-thoughts-on-the-current-functional-programming-bandwagon) on the current surge in the so called Functional style of programming. I recommend you read it before continuing.

There are some aspects that are adamant if you really want to go beyond the academic research and into the real world of productivity.

<a name="immutability"></a>

#### Immutability and Opaque Message Passing are VERY important

In order for computation to be fast, we are used to share data between routines. We move pointers around and change data in place.

It's not particularly fast to make things immutable and not shared. The more you make data mutable and the more you share, the harder it is to make your code run concurrently.

It is an important **trade-off**: if you see mutable data and shared state, you're optimizing for performance.

One can't say that a language is essentially good or bad for having mutable or immutable data. But for what it's worth, my personal opinion is that it's harder to convince users to follow conventions like _"share a little as possible, mutate as little as possible."_ Most will not even know about it if it's not built-in and enforced. I prefer having immutability enforced by default.

In Erlang, data is **immutable**. Similar to Java it [pass values by reference](http://erlang.org/pipermail/erlang-questions/2013-March/072760.html) in routine calls (it is not copying values between calls, as many misunderstand it). 

And in the case of recursion it optimizes through [Tail Cail Optimization](http://learnyousomeerlang.com/recursion) to make it faster. By the way, this is one optimization that the Java VM just can't quite do it yet. Clojure needs special 'recur' and 'trampoline' calls, for example. Scala can rewrite the tail recursion to a loop in compile time, with the '@tailrec' annotation. [Erlang has its own traps](http://ferd.ca/erlang-s-tail-recursion-is-not-a-silver-bullet.html) as well, so not so black and white at the moment.

In Erlang, as I explained before, you run functions within completely isolated processes. If the function recurs or blocks, it stays isolated. Processes can only communicate by sending (immutable and opaque) messages to each other. Messages get queued in a "run queue" or "mailbox" and the function can choose to receive and respond to those messages. That's it.

So, you can pass values by reference between routines, or you can share data in a third party process as the mediator of data. One such infrastructure built-in to Erlang is the **ETS**, the [Erlang Term Storage](http://elixir-lang.org/getting-started/mix-otp/ets.html), which is part of the so called OTP platform. Think of ETS as a very simple and very fast built-in key value storage like Memcached. You use it for the same use cases as a cache and it's as simple as just doing this:

--- ruby
table = :ets.new(:my_fancy_cache, [:set, :protected])
:ets.insert(table, {"some_key", some_value})
:ets.lookup(table, "some_key")
```

Many might argue that Erlang's **rigid process isolation** and communication strictly restricted to opaque message passing are overkill and that you can pass by using something akin to Clojure's [MVCC Software Transaction Memory](http://clojure.org/refs), or STM. You do have STM in Erlang, with the other built-in OTP tool, built on top of the ETS, called **Mnesia**. It offer the equivalent of ACID database transactions in-memory. It's not a new concept, but STM is not available as a language feature and it's still uncertain if it really is a good choice to have it.

An inspired result, I believe, from Clojure's choice of having transactional memory with history queue and snapshot isolation is shown in its crown jewel, [Datomic](http://www.datomic.com/). The idea is not revolutionary by any stretch of the imagination as you have many other [prior art](http://www.xaprb.com/blog/2013/12/28/immutability-mvcc-and-garbage-collection/) such as RethinkDB, CouchDB, and extensions for existing databases. Good for a service, still I don't think it's a good thing to share state, even if you have a transactor around that state. Erlang's immutability with rigid process isolation still has no match.

<a name="coroutines"></a>

#### Coroutines and Schedulers

You already know sub-routines, you do it all the time by partitioning large portions of code into smaller functions or methods that call each other. You may already know about a specialized kind of Coroutines in the form of [Fibers](http://bit.ly/1lVuLFJ) (as first implemented in Windows circa 1997). 

Fibers offer a way for your current function execution to "yield" back to its caller, preserving its current state, and then the caller can "resume" the suspended Fiber to continue its execution from where it last yielded. This allows for non-preempted, cooperative multitasking. We have Fibers in Python, Ruby, and other languages and it allows the creation of constructions like Generators. Even Javascript can have some form of Fibers if you add libraries like [node-fibers](https://github.com/laverdet/node-fibers):

--- javascript
var Fiber = require('fibers');

function sleep(ms) {
    var fiber = Fiber.current;
    setTimeout(function() {
        fiber.run();
    }, ms);
    Fiber.yield();
}
```

The call to 'yield' suspends the current execution until the function in the 'setTimeout' is called. Then it calls 'run', which resumes the previously yielded function. This is still "rudimentary" compared to coroutines: because the function itself has to yield control out to the reactor event loop, in the case of a Node.js application. If you don't, you will block the event loop in a single threaded Node.js process, and therefore you block everything until the function finishes, defeating the whole purpose. And this is one of those "conventions" that "good" programmers should follow, but most will forget.

Fibers are useful to make it less ugly to program in a rudimentary Reactor environment, where you depend on callbacks calling callbacks and you end up with the anti-pattern of [callback pyramid of doom](https://bjouhier.wordpress.com/2012/03/11/fibers-and-threads-in-node-js-what-for/). With Fibers you can program as you would in a synchronous imperative language transforming this ugly Javascript code:

--- javascript
function archiveOrders(date, cb) {
  db.connect(function(err, conn) {
    if (err) return cb(err);
    conn.query("selectom orders where date < ?",  
               [date], function(err, orders) {
      if (err) return cb(err);
      helper.each(orders, function(order, next) {
        conn.execute("insert into archivedOrders ...", 
                     [order.id, ...], function(err) {
          if (err) return cb(err);
          conn.execute("delete from orders where id=?", 
                       [order.id], function(err) {
            if (err) return cb(err);
            next();
          });
        });
      }, function() {
        console.log("orders been archived");
        cb();
      });
    });
  });
}
```

Into this more manageable thing:

--- javascript
var archiveOrders = (function(date) {
  var conn = db.connect().wait();
  conn.query("selectom orders where date < ?",  
             [date]).wait().forEach(function(order) {
    conn.execute("insert into archivedOrders ...", 
                 [order.id, ...]).wait();
    conn.execute("delete from orders where id=?", 
                 [order.id]).wait();
  });
  console.log("orders been archived");
}).future();
```

The entire [Promises, Futures](https://en.wikipedia.org/wiki/Futures_and_promises) debacle depends in part on proper Fibers. Javascript, being a very poor design, does not come with anything built-in and hence the proliferation of Fibers, Deferreds, Promises, Futures implementations that can never reach neither consensus nor people actually using them at large.

So, Fibers are ok. Coroutines are better because you have multiple points of suspending a function and more. And even better, in Erlang one doesn't need to even think about rudimentary Reactor loops (yes, reactors are a rudimentary construction for concurrency when you have no other good choice): it has **transparent asynchronous calls**. Everything in Erlang is asynchronous and non-blocking but you don't deal with callback pyramids because there is something better underneath: the **Scheduler**.

By the way, I find it very frustrating that [Go's "goroutines" **are not** proper "coroutines"](http://stackoverflow.com/questions/18058164/is-golang-goroutine-a-coroutine).

For each Erlang process with SMP (symmetric multiprocessing) support there will be **one** real thread per CPU core available in your system, and for each thread there will be one single Scheduler to manage the internal green threads (processes) and run-queue.

As a programmer, I don't have to "remember" to yield control back to a passive event loop. The scheduler will take care of balancing computation time to each concurrent process. If a process is taking too long the Scheduler can choose to suspend it and give time to other routines. Erlang defines a ["reduction"](http://erlang.org/pipermail/erlang-questions/2001-April/003132.html) and that there are different priority levels of functions. If a function takes more than 2,000 reductions, the Scheduler can choose to suspend it. If you have 8 CPU cores, but the computation on the processes are not heavy, the VM can choose to just use 1 or 2 Schedulers and leave the other 6 idle so the hardware can turn the cores off to save energy (!!). Yep, Erlang is even Eco Friendly!

And we need to repeat this again: because each process is **rigidly isolated**, with immutable data and no shared state, it's easier to suspend a running process. In the case of the JVM this is usually implemented by raising checked exceptions and have everybody implement some Suspendable interface. It can be done using this [3rd party Java continuation library](http://www.matthiasmann.de/content/view/24/26/) where you yield by raising an Exception (!) Nasty stuff.

Rust is [still implementing](https://github.com/rustcc/coroutine-rs) something for coroutines as well, but still nothing as mature. But again, coroutines is just part of the story, you would need a heavier system with userland schedulers for it to make sense. Go is better candidate to incorporate such a system in its runtime, but it also come short on being able to implement all this. There is [Suture](http://www.jerf.org/iri/post/2930), an attempt to have some of OTP in Go, but it can't be done. Even Akka, the first mainstream OTP clone for Scala, can't come close because of the JVM shortcomings. [Clojure with Pulsar/Quasar](http://blog.paralleluniverse.co/2013/05/02/quasar-pulsar/), come **closer**, but not there yet.

Now, the Erlang Scheduler is not only capable of suspending and resuming processes but it also takes care of message passing between them. So each Scheduler has its own run-queue to queue and dispatch messages. Again, because data is immutable, you only need some form of locking when you want another Scheduler (in another real thread) to take over a few processes in order to balance processing between cores. Erlang support SMP [since OTP R12B](http://erlang.org/pipermail/erlang-questions/2008-September/038231.html) (we are at R18 right now, and still evolving).

Most languages still rely on the OS real threads preemptive model to do multitasking. And this is heavy and slow because of all the context switching involved and all the locking logic most programmers will do wrong (the best practice for concurrency is: do not use threads, chances are you will screw up). Again, we make the right assumptions first: programmers can't do proper multithreading, so let a Scheduler do it, when necessary, and avoiding slow OS context switching as much as possible. Suspendable green threads combined with a userland Scheduler coordinating cooperative switching is a way faster and safer choice.

If you want to learn more about coroutines this [Lua Paper](http://www.inf.puc-rio.br/~roberto/docs/corosblp.pdf) on the subject explains in more details what I just elaborated:

<blockquote>
Implementing a multitasking application with Lua coroutines is straightforward.Concurrent tasks can be modeled by Lua coroutines. When a new task is created, it is inserted in a list of live tasks. A simple task dispatcher can be implemented by a loop that continuously iterates on this list, resuming the live tasks and removing the ones that have finished their work (this condition can be signalled by a predefined value returned by the coroutine main function to the dispatcher). Occasional fairness problems, which are easy to identify, can be solved by adding suspension requests in time-consuming tasks.
</blockquote>

<a name="static-dynamic"></a>

####  Static vs Dynamic Typing is still controversial

We saw a heavier movement from bureacratic static typed systems (mainly Java prior to 6, C# prior to 4, C++) to purely dynamic languages such as Perl in the late 80's, Python in the late 90's, Ruby in mid 2000's. We tried to go from _"making the compiler happy"_ to _"making programmers happy"_, which makes more sense if you ask me.

Scala, Groovy, Haskell, Swift brought a very practical middle ground with [Hindley-Milner](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system) derived **Type Inference** systems, in a way that we can code kinda like in dynamic languages but with the compiler doing more work to infer types for us before generating the final executable bytecode.

But there is a **big** catch: it's very difficult to **hot swap** code inside the runtime if you have static signatures. I'm not saying that it is impossible, but a lot more difficult. You do can reload code in Java (one example being [Spring Loaded](https://github.com/spring-projects/spring-loaded)) or Haskell (there is a hotswap plugin and other alternatives). You don't do granular reloads in a statically typed language because if you want to change the signature of a method, you have to change the graph that depends on that signature. It's doable, albeit, cumbersome.

In Erlang, because there is no such hard dependencies, and again because of inherent advantages of it only having immutable data with no shared state, and dependencies limited to opaque message passing, you can granularly reload one single module and most important of all: you can implement simple callbacks to **transform the old state of a process into a new state structure**, because just reloading the code is half the story if you will have hundreds of old processes restarting into the new code but having to deal with previous state. In an Erlang GenServer, you just implement this single callback:

--- ruby
code_change(OldVersion, CurrentState, _Extra) -> {ok, NewState}.
```

So, while Type Inference is a nice middle ground, the flexibility of Dynamic Typing goes beyond being easy for programmers to use. As with Python, Ruby, Javascript, Perl and other dynamic typed languages, you will want to cover your code with proper test suites - which should not be optional in strong typed languages anyway. There is no doubt a compiler's static analysis help a lot, but it's my personal take that dynamic typing allows me more flexibility.

<a name="fault-tolerance"></a>

### Fault Tolerance: Don't fear your code

With Dynamic Typing we will end up again in the endless discussion of _"programmers never do it right, we need a compiler to enforce static rules"_. And you are almost right: programmers screw up, but a compiler will not save you day anyway, and worst: it might give you a false sense of security. There is no worse security hole than false sense of security. A test suite is way better to assert proper implementation, and it's still no hard guarantee.

I said that this is controversial, as a more rigid static typing system is more productive than having to unit tests every input and output types of every function. But if you thought that, you're at least wrong in that this is not what unit tests are for: it's for testing unit behaviors, in spite of what the types are. Testing types is what we call "chicken typing" and it's another form of defensive programming. You must test for behavior, not for stuff that a compiler would check. And again, having the static typing hinges my flexibility because now I have to constantly fight the typing, add more boilerplate, and ultimately if the behavior is wrong, the code is wrong, despite the type checks.

For a system to be **"tolerant to buggy code or uncaught failures"** is the opposite of littering your code with guarding statements like "try/catch" or "if err == x" or having some form static level checking with Result monads (that most people will just unwrap anyway). Guards can only go so far. And yes, this is anedoctal as there is not statistics that "everybody will unwrap" and most good programmers won't, but if experience tells me one thing is that bad programmers will fall for "try/catch" the whole thing when they don't know what to do anyway.

You need a system that allows any buggy code to fail and not crash the environment around it, which would bring it into an inconsistent, corrupt, state.

The problem with faulty code is that it leaves the state in a position where it has nowhere else to go. And if this state is shared, you leave every other bit of code in a position where they can't decide where to go next. You will need to shut everything down and restart from the last known good state. Almost all "continuous delivery" workflows are implemented around restarting everything.

Instead of having to bring everything down in case you forget to try/catch something, you can rely on Erlang's underpinnings of not sharing state, having immutable data, and - most importantly - having the rigidly isolated lightweight process system to make the process that is holding the faulty code to **shut down and warn it's Supervisor**. This is the general idea behind the so called OTP in Erlang.

The idea of a Supervisor is to have a small process that monitors other processes. The Supervisor has as little code as possible in order to rarely (or never) fail (the best kind of code is "no code"). Once a faulty process crashes because of uncaught exception or other underterministic reasons, it  sends a notification message to the Supervisor run-queue mailbox, and then die cleanly. The Supervisor then chooses what to do based on it's underlying restart strategy.

Let's say you have a list of URLs you're scrapping. But you didn't anticipate dirty structures in your parsing logic. The process doing the scrapping crashes and dies. The Supervisor is notified and choose to restart the process, giving the new process the previous state - the URL list - and now that the faulty URL is not there anymore, the new process can happily continue the job with the next URL in the list.

This is a simple example of the dynamic between the Erlang VM, the Supervisor and its children workers. You can go further and have several Applications, which in turn start up new Supervisors, which in turn start up children processes. And you have a Supervisor Tree that can trap exits and restart granular bits of your runtime code without bringing the rest of the system into an inconsistent state.

Such is the beauty of the rigid process isolation concept.

Every I/O in the system is wrapped in [Ports](http://www.erlang.org/doc/tutorial/c_port.html), which obeys Async/callback logic transparently without you having to create pyramids of callbacks. The process consuming such ports just gets suspended by the Scheduler until the Async call returns and it can resume work. No callback pyramid hell. No need for rudimentary Fiber implementations to allow for rudimentary Promises/Futures systems. Just coroutines inside processes that can be suspended and resumed by the Scheduler. Less opportunities for programmer errors to stack up.

So, a programmer will forget to code every possible branch of execution and because he knows that, the **very worst thing** that can happen is not if he forgets an uncaught exception, but if he decides to program **deffensivelly** and add general conditions to trap **any** error and never raise it. You've seen it before, when you find code that is trapped inside generic try/catch blocks, trying to avoid every error possible. But what really happens is that the system may not crash but your logic and your processing is faulty at its core. And you won't find about it, because it doesn't crash, therefore no one is ever notified! You will not end up with less bugs, you will end up with a mountain of logic bugs that are never noticed because they are all swallowed!!

This is the core of Fault Tolerance: do not fear Erlang, fear the programmers! Instead, we should do what Joe Armstrong presented in his seminal paper ["Making reliable distributed systems in the presence of software errors"](http://www.erlang.org/download/armstrong_thesis_2003.pdf). This is both a detailed guide into Erlang and OTP but also his arguments on how to write fault tolerant systems by making the programmer write code as clearly as he originally intended, without the need to be defensive, with the confidence that if he misses something, OTP will be there to catch it and not let the system die, but instead to give a chance to fix it and reload it without disrupting other good parts of the system.

This is the ultimate goal of good programming: not being deffensive, not putting try/catch everywhere because you're afraid.

<a name="summary"></a>

### Summary

This short summary is the reason why Erlang sounds very compelling for my Web Development needs, or for any scalable complex system, at least for me.

Every other language had to make trade-offs. Every new language on top of the JVM has to deal with limitations inherent to how the JVM was originally architected. Rust still can build better abstractions, but it's scope is for smaller tools and libraries, not distributed complex systems. Yes, eventually it can do whatever C/C++ can do, and Mozilla is actually basing the core of its next generation browser core on Rust. This will bootstrap better higher level libraries and frameworks, the same way Apple using Objective-C created the entire set of Core frameworks that make implementing complex applications much easier.

Go made a choice for keeping familiarity with its C++ inheritance. Of course, it has tons of useful features, in particular the built-in goroutines that make concurrent coding much easier than in previous languages.

Haskell is too strict for most programmers (yes, Monads, still difficult for the average programmer to fully grasp) and despite contraty opinions, to me it still feel like it appeal more to researchers than everyday developers. Other dynamic languages such as Ruby, Python, may still go the way of Erlang with Ruby adding some immutability ([in 2.3](https://bugs.ruby-lang.org/issues/11473) with immutable String by default), but it's still a long way to go.

Erlang has everything, as Joe Armstrong envisioned a fault tolerant system to be. It started as an exercise implemented in Prolog in 1986. It migrated from the previous JAM compiler to the current BEAM VM in 1998. It added SMP around 2008. It has been gradually evolving, polishing its rough edges, being really battle tested in really mission critical systems for decades. It's ready for us, right now.

It has Fault Tolerance guaranteed by the principles of immutable data, no shared state, pure opaque message passing, and suspendable processes, all managed by Schedulers. This guarantees that faulty routines can crash one single process but not the entire system and definitely not bringing state of other process to inconsistent, corrupted, states.

Then you can instrument your virtual machine and check that Supervisors are restarting children more than you want and decide to fix the buggy code. And once you do, you can choose **not** to shut down and restart the entire system to reload the code fixes, you can do it granularly, on the fly, with running processes that will pick up the fixes once the Supervisor restarts it. The granular hot swap of code is guaranteed because there is no hierarchy of types to care about.

And because you have proper coroutines with no hierarchy of shared state dependencies, you can have **asynchronous exceptions** that can forcefully shut down processes without creating side effects to other running processes. A Supervisor may choose to restart its entire children list when one of its child crashes and another of its child depended on that previous process. You can switch from "one for one" restart strategy to "one for all" (like the Musketeers).

There is only one problem with Erlang: it was not designed for "programmer happiness", a concept we got used to have for granted because of Ruby and newer languages.

Erlang has its roots in Prolog and it shows. Once you step up and really dive deep exercising with the language you can possibly get used to it. But if you came from more modern dynamic languages such as Ruby, Python, Groovy, you will definitely miss the comfortable modern constructions.

Elixir is the missing piece, the Philosopher's Stone if you will, that can unlock all the 30 years of refinements, maturity, industry battle tested technologies in large scales, to the average programmer.

It brings many modern construct such as making macros easier in order to allow for Domain Specific Languages, having testable comments in your code, adding a more modern standard library that is easily recognizable from a Ruby or Clojure point of view, polymorphism through Protocols, and so on.

This is one example of Elixir straight from its source code tests:

--- ruby
Code.require_file "../test_helper.exs", __DIR__

defmodule Mix.ArchiveTest do
  use MixTest.Case

  doctest Mix.Archive

  test "archive" do
    in_fixture "archive", fn ->
      File.write ".elixir", "~> 1.0.0"
      Mix.Archive.create(".", "sample.ez")
      archive = 'sample.ez'
      assert File.exists?(archive)
      assert has_zip_file?(archive, 'sample/.elixir')
      assert has_zip_file?(archive, 'sample/priv/not_really_an.so')
      assert has_zip_file?(archive, 'sample/ebin/Elixir.Mix.Tasks.Local.Sample.beam')
      assert has_zip_file?(archive, 'sample/ebin/local_sample.app')
    end
  end

  defp has_zip_file?(archive, name) do
    {:ok, files} = :zip.list_dir(archive)
    Enum.find(files, &match?({:zip_file, ^name, _, _, _, _}, &1))
  end
end
```

Code that can be written like this automatically makes me grin.

This is the perfect combination. Again, it is not without shortcomings. Erlang is by no means a fast language. It is way faster than Ruby, Python, or other interpreted languages. It can be made a bit faster with native compilation through the HIPE compiler, but still nowhere near the speeds of Go, Rust, or any Java derivative such as Scala, Groovy or Clojure.

So, if you really need raw power of computation, you will want Go or Java. Again, I'm not saying there are only those 2, but it's the usual choices if you don't want to go down to C/C++. Haskell has terrific performance, but it's learning curve is less than stellar.

Erlang is a whole system, it has its own scheduling system, it controls living, breathing processes that each has its own garbage collector, it controls system signal trapping and so on. It was designed to be a full server. It is much smaller than a full blown Java Enterprise Edition container, so small that you can actually package command line tools that do start up fast enough. But this is not the sweet spot. For that purpose you will better off with Go or even Rust.

For the same reasons it was not made to be an embeddable language the way Lua is. It was not made to create libraries that can be easily linked to via FFI or C-like function exports, the way Rust can.

There are ways to create desktop-class applications, specially with cross-platform [wxWidgets](http://www.erlang.org/doc/apps/wx/chapter.html), the way the built-in Observer intrumentation application is done, but Erlang was not built to be a desktop toolkit.

Also because it prioritizes correctness, rigidly isolated processes communicating just by opaque messages, immutable and non-shared states, it means that Erlang is not suited to hard data science processing. So I doubt it's the best choice for Big Data analytics, DNA sequencing and other hard stuff that tools like Julia, R, Fortran, are better choices. It's not the same thing to say that it can't be a good database core, Riak and CouchDB proved that already. But complex queries on top of high volumes of data is not the sweet spot as well.

So, Erlang is good for distributed systems, with high concurrency of opaque message exchange and proxing. The exact scenario where the Web is. Web Applications heavy load of throughput that need real time chats and notifications, heavy and time consuming payment transactions, gathering of data from many sources in order to reduce them to consumable HTML or JSON responses.

But for the average Web developer (and by "average" I mean minimally able to architect the kinds of complex systems we deal with everyday in web development, not simple static website contruction), Erlang was a real challenger, and now we can have the comfort of a real modern language with hints of Ruby and Clojure, without the complexities of strong typing but with the security of its built-in Fault Tolerance constructions in order to deliver highly reliable, highly scalable, modern Web applications.
