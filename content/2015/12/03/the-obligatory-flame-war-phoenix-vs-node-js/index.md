---
title: The Obligatory "Flame War" Phoenix vs Node.js
date: '2015-12-03T12:01:00-02:00'
slug: the-obligatory-flame-war-phoenix-vs-node-js
tags:
- learning
- beginner
- elixir
- phoenix
- node
- english
draft: false
---

I’ll warn you upfront: this will be a very unfair post. Not only am I biased for disliking Javascript and Node.js, but at this moment, I am very excited and fascinated by Elixir and Erlang.

Comparisons are always unfair. There is no such a thing as a “fair” synthetic benchmark comparison, the author is **always** biased towards some targetted result. It’s the old pseudo-science case of having a conclusion and picking and choosing data that backs those conclusions. There are just too many different variables. People think it’s fair when you run it in the same machine against 2 “similar” kinds of applications, but it is not. Please don’t trust me on this as well, do your own tests.

All that being said, let’s have some fun, shall we?


### The Obligatory “Hello World” warm-up

For this very short post, I just created a Node.js + Express “hello world,” I will point to its root endpoint, Express, rendering a super simple HTML template with one title and one paragraph.

For Elixir, I just bootstrapped a bare-bone Phoenix project and added one extra endpoint called “/teste” in the Router. This endpoint will call the PageController, then the “teste” function, and render an EEX template with the same title and paragraph as in the Express example.

Simple enough. Phoenix does more than Express, but this is not supposed to be a fair trial anyway. I chose [Siege](https://www.joedog.org/siege-home/) as the testing tool for no particular reason. You can pick the testing tool you like the most. I am running this over my 2013 Macbook Pro with 8 cores and 16GB of RAM, so this benchmark will never max out my machine.

The first test is a simple run of 200 concurrent connections (the number of CPUs I have) firing just 8 requests each for 1,600. First, the Node.js + Express results:

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Node+8+x+200.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Node+8+x+200.mp4)
</source></video>

The first run already broke a few connections, but the 2nd run picked up and finished all 1,600 requests. And this is the Phoenix results:

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Phoenix+8+x+200.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Phoenix+8+x+200.mp4)
</source></video>

As you can see, Node.js has the upper hand in terms of the total time spent. One single Node.js process can only run one single real OS thread. Therefore it had to use just a single CPU core (although I had 7 other cores to spare). On the other hand, Elixir can reach all 8 cores of my machine, each running a Scheduler in a single real OS thread. So, if this test was CPU bound, it should have run 8 times faster than the Node.js version. As the test is largely a case of I/O bound operations, the clever async construction of Node.js does the job just fine.

This is not an impressive test by any stretch of the imagination. But we’re just warming up.

Oh, and by the way, notice how Phoenix logs show the request processing times in MICROseconds instead of milliseconds!

### The Real Fun

Now comes the real fun. In this second run, I added a blocking “sleep” call to both projects, so each request will sleep for one full second, and this is not absurd. Many programmers will use poor code that blocks for that time, process too much data from the database, render templates that are too complex, and so on. Never trust a programmer to do the right best practices all the time.

Then, I fire up Siege with ten concurrent connections and just one request each, for starters.

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Node+1+x+10+Sleep.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Node+1+x+10+Sleep.mp4)
</source></video>

This is why in my previous article" Why Elixir?" (http://www.akitaonrails.com/2015/12/01/the-obligatory-why-elixir-personal-take), I repeated many times how **“rudimentary”** a Reactor pattern-based solution is. It is super easy to block a single-threaded event loop.

If you didn’t know that already, how does Node.js work? In summary, it is a simple infinite loop. When a Javascript function runs, it blocks that event loop. The function has to explicitly yield control back to the loop for another function to have a chance to run. I/O calls take time and just sit back idly waiting for a response, so it can yield control back and wait for a callback to continue running, which is why you end up with the dreaded _“callback pyramid hell”_.

Now, with what I explained in all my previous articles, you may already know how Elixir + Phoenix will perform:

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Phoenix+2+x+400+-+Sleep.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/Phoenix+2+x+400+-+Sleep.mp4)
</source></video>

As expected, this is a walk in the park for Phoenix. It doesn’t have a rudimentary single-thread loop waiting for the running functions to yield control back willingly. The Schedulers can forcefully suspend running coroutines/processes if they think they are taking too much time (the 2,000 reductions count and priority configurations), so every running process has a fair share of resources to run.

Because of that, I can keep increasing the number of requests and concurrent connections, and it’s still **fast**.

In Node.js, if a function takes 1 second to run, it blocks the loop. When it finally returns, the next 1-second function can run. That’s why if I have ten requests taking 1 second each to run, the entire process will linearly take 10 seconds!

Which obviously does not scale! If you “do it right,” you can scale. But why bother?

### “Node” done right

As a side note, I find it ironic that “Node” is called “Node.” I would assume that connecting multiple Nodes that communicate with each other should be easy. And as a matter of fact, [it is not](http://www.sitepoint.com/how-to-create-a-node-js-cluster-for-speeding-up-your-apps/).

If I had spun up 5 Node processes, instead of 10 seconds, everything would take 2 seconds as five requests would block the 5 Node processes for 1 second, and when returned, the next five requests would block again. This is similar to what we need to do with Ruby or Python, which have the dreaded big Global Interpreter Locks (GIL) that, in reality, can only run one blocking computation at a time. (Ruby with Eventmachine and Python with Tornado or Twisted are similar to Node.js implementation of a reactor event loop).

Elixir can do much better in terms of actually coordinating different nodes, and it is the Erlang underpinnings that allow highly distributed systems such as [ejabberd](https://www.ejabberd.im/) or [RabbitMQ](https://www.rabbitmq.com/) to do their thing as efficiently as they can.

Check out how simple it is for one Elixir Node to notice the presence of other Elixir nodes and make them send and receive messages between each other:

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/7+-+Nodes.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Elixir/7+-+Nodes.mp4)
</source></video>

Yep, it is this simple. We have been using Remote Procedure Calls (RPC) for decades; this is not new. Erlang has implemented this for years, and it is built-in and available for easy usage out-of-the-box.

On their websites, ejabbed calls itself a “Robust, Scalable, and Extensible XMPP Server,” and RabbitMQ calls itself “Robust messaging for applications.” Now we know they deserve the labels “Robust” and “Scalable.”

So, we are struggling to do things that have been polished and ready for years. Elixir is the key to unlocking all this Erlang goodness right now. Let’s just use it and stop shrugging.

