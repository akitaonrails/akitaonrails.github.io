---
title: 'Ex Manga Downloadr - Part 2: Poolboy to the rescue!'
date: '2015-11-19T14:35:00-02:00'
slug: ex-manga-downloadr-part-2-poolboy-to-the-rescue
tags:
- learning
- beginner
- elixir
- exmangadownloadr
- english
draft: false
---

If you read my [previous article](http://www.akitaonrails.com/2015/11/18/ex-manga-downloader-an-exercise-with-elixir) I briefly described my exercise building a MangaReader downloader. If you didn't read it yet, I recommend you do so before continuing.

In the mid-section of the article I described how I was still puzzled on what would be the best way to handle several HTTP requests to an unstable external source where I can't control timeout or other network problems.

A big Manga such as Naruto or Bleach have dozens of chapters with dozens of pages each, accounting for thousands of necessary HTTP requests. Elixir/Erlang do allow me to fire up as many parallel HTTP requests as I want. But doing that makes the HTTP requests timeout very quickly (it's like doing a distributed denial of service attack against MangaReader).

By trial and error I found that firing up less than a 100 HTTP requests at once allows me to finish. I capped it down to 80 to be sure, but it really depends on your environment.

Then I had to manually chunk my list of pages to 80 elements and process them in parallel, finally reducing the resulting lists into a larger list again to pass it through to the next steps in the Workflow. The code gets convoluted like this:

--- ruby
def images_sources(pages_list) do
  pages_list
    |> chunk(@maximum_fetches)
    |> Enum.reduce([], fn pages_chunk, acc ->
      result = pages_chunk
        |> Enum.map(&(Task.async(fn -> Page.image(&1) end)))
        |> Enum.map(&(Task.await(&1, @http_timeout)))
        |> Enum.map(fn {:ok, image} -> image end)
      acc ++ result
    end)
end
```

Now I was able to reimplement this aspect and the same code now looks like this:

--- ruby
def images_sources(pages_list) do
  pages_list
    |> Enum.map(&Worker.page_image/1)
    |> Enum.map(&Task.await(&1, @await_timeout_ms))
    |> Enum.map(fn {:ok, image} -> image end)
end
```

Wow! Now this is a big improvement and it's way more obvious what it is doing. 

Best of all: downloading a Manga the size of Akira (around 2,200 pages long) took less than **50 seconds**. And this is not because Elixir is super fast, it's because MangaReader can't keep up if I extend the Pool size. It's hitting at a constant rate of 50 concurrent connections!

This just makes my 4 cores machine, sitting down over a connection of 40Mbs use less than 40% ~ 30% of CPU and using no more than around 3,5 Mbs. If MangaReader could keep up we could easily fetch all pages 2 or 3 times faster without breaking a sweat.

It was fast with the previous strategy, but I guess it got at least twice as fast as a bonus. But how did I accomplish that?

### Open Telecom Platform

In the previous article I also said that I didn't want to dive into "OTP and GenServers" just yet. But if you're a beginner like me you probably didn't understand what this means.

OTP is what makes Erlang (and consequently, Elixir) different from pretty much every other language platform but, maybe, Java.

Many new languages today make it do many tasks in parallel through convoluted Reactor patterns (Node.js, EventMachine/Ruby, Tornado/Twisted/Python, etc) or through (cleaner) green threads (Scala, Go).

But none of this matters. It's not difficult to launch millions of lightweight processes, but it is not trivial to actually **CONTROL** them all. It doesn't matter how fast you can exhaust your hardware if you can't control it. Then you end up with millions of dumb minions wreaking havoc without an adult to coordinate them.

Erlang solved this problem decades ago through the development of OTP, initially called Open Systems, within Ericsson in 1995. By itself OTP is a subject that can easilly fill an entire fat book and you will still not be able to call yourself an expert.

Just so I don't get too boring here: 

* Start with [this very brief summary](http://learnyousomeerlang.com/what-is-otp);
* Then read [Elixir's tutorial on Supervisors](http://elixir-lang.org/getting-started/mix-otp/supervisor-and-application.html) and the page on [Processes](http://elixir-lang.org/getting-started/processes.html) first if you haven't already;
* Finally, you can go further with [The Elixir & OTP Guidebook](https://www.manning.com/books/the-little-elixir-and-otp-guidebook) from Manning Publications.

Now, below is my personal point of view. As I am a beginner myself, let me know in the comments section below if I got some concept wrong.

OTP is a collection of technologies and frameworks. The part that interests us the most is to understand that this is a sophisticated collection of patterns to achieve the Nirvana of highly reliable, highly scalable, distributed systems. You know? That thing every new platform promises you but fails to actually deliver.

For our very simple intents and purposes, let's pick up what I said before: it's trivial to fire up millions of small processes. We call them "workers". OTP provides the means to control them: Supervisors. And then it also provides the concept of Supervisor Trees (Supervisors that supervise other Supervisor). This is the gist of it.

Supervisors are responsible for starting up the workers and also to recover from exceptions coming from the workers (which is why in Erlang/Elixir we don't do ugly try/catch stuff: let the error be raised and caught by the Supervisor). Then we can configure the Supervisor to deal with faulty worker by, for example, restarting them.

We already touched this OTP stuff before. An Elixir [Task](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/task.ex) is just a high level abstraction. It internally starts its own [supervisor](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/task/supervisor.ex) and supervised to monitor over asynchronous tasks.

There are so many subjects and details that it's difficult to even get started. One concept that is important to know is about **state**. There is no global state! (Yay, no Javascript globals nightmare.) Each function has its own state and that's it. There is no concept of an "object" that holds state and then methods that can modify that state.

But there is the concept of Erlang processes. Now, a process do have state, it's a lightweight piece of state that exists only in runtime. To execute a function in a separated, parallel process, you can just do:

--- ruby
iex> spawn fn -> 1 + 2 end
#PID<0.43.0>
```

Different from an object, a process does not have a set of methods that access its inner "this" or "self" states. Instead each process has a **mailbox**. When you start (or "spawn" in Erlang lingo) a new process, it returns a pid (process ID). You can now send messages to the process through its pid. Each process has a mailbox and you can choose to respond to incoming messages and send responses back to the pid that sent the message. This is how you can send a message to the IEx console and receive the messages in its mailbox:

--- ruby
iex> send self(), {:hello, "world"}
{:hello, "world"}
iex> receive do
...>   {:hello, msg} -> msg
...>   {:world, msg} -> "won't match"
...> end
"world"
```

In essence, it's almost like an "object" that holds state. Each process has its own garbage collector, so when it dies it's individually collected. And each process is isolated from other processes, they don't bleed state out, which makes them much easier to reason about.

The [Getting Started page on Processes](http://elixir-lang.org/getting-started/processes.html) from the Elixir website show examples of what I just explained and I recommend you follow it throughly.

In summary, a process can hold internal state by locking indefinitely waiting for an incoming message in its mailbox and then recursing to itself! This is a mindblowing concept at first.

But, just a simple process is just too dawn weak. This is where you get [OTP's GenServer](http://elixir-lang.org/getting-started/mix-otp/genserver.html), which is a much more accomplished process. OTP exposes Behaviours for you to implement in order to add your own code but it takes care of the dirty infrastructure stuff so you don't have to.

### Deferring the Heavy Workflow calls to a Worker

All that having being said, we know that in the Workflow we implemented before, we have trouble with the <tt>Page.image/1</tt> and <tt>Workflow.download_image/2</tt> functions. This is why we made them asynchronous processes and we wait for batches of 80 calls every time.

Now, let's start by moving away this logic to a GenServer Worker, for example, in the <tt>ex_manga_downloadr/pool_management/worker.ex</tt> file:

--- ruby
defmodule PoolManagement.Worker do
  use GenServer
  use ExMangaDownloadr.MangaReader

  @timeout_ms 1_000_000
  @transaction_timeout_ms 1_000_000 # larger just to be safe

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def handle_call({:page_image, page_link}, _from, state) do
    {:reply, Page.image(page_link), state}
  end

  def handle_call({:page_download_image, image_data, directory}, _from, state) do
    {:reply, Page.download_image(image_data, directory), state}
  end
end
```

I first moved the <tt>Workflow.download_image/2</tt> to <tt>Page.download_image/2</tt> just for consistency's sake. But this is a GenServer in a nutshell. We have some setup in the <tt>start_link/1</tt> function and then we have to implement <tt>handle_call/3</tt> functions to handle each kind of arguments it might receive. We separate them through pattern matching the arguments.

As a convention, we can add public functions that are just prettier versions that call each <tt>handle_call/3</tt>:

--- ruby
  def page_image(page_link) do
    Task.async fn -> 
      :poolboy.transaction :worker_pool, fn(server) ->
        GenServer.call(server, {:page_image, page_link}, @timeout_ms)
      end, @transaction_timeout_ms
    end
  end

  def page_download_image(image_data, directory) do
    Task.async fn -> 
      :poolboy.transaction :worker_pool, fn(server) ->
        GenServer.call(server, {:page_download_image, image_data, directory}, @timeout_ms)
      end, @transaction_timeout_ms
    end
  end
```

But we are not just calling the previous <tt>handle_call/3</tt> functions. First there is the <tt>Task.async/1</tt> we were already using in the Workflow functions to make the parallel batches. But inside the Task calls there is this other strange thing: <tt>:poolboy</tt>.

### Controlling Pools of Processes through Poolboy

The entire OTP ordeal I wrote here was just an introduction so I could show off [Poolboy](https://github.com/devinus/poolboy).

Repeating myself again: its trivial to fire up millions of processes. OTP is how we control failures to those processes. But there is another problem: the computation within each process may be so heavy we can either bring down the machine or, in our case, do a Distributed Denial of Service (DDoS) against poor MangaReader website.

My initial idea was to just do parallel requests in batches. But the logic is convoluted.

Instead, we can use a process pool! It queues up our requests for new processes. Whenever a process finishes it is returned to the pool and a new computation can take over the available process. This is how pools work (you probably have an intuition of how it works from traditional database connection pools). Pools and queues are useful software constructs to deal with limited resources.

By doing this we can remove the chunking of the large list into batches and do it like we would process every element of the large list in parallel at once, repeating again the initial version:

--- ruby
pages_list
  |> chunk(@maximum_fetches)
  |> Enum.reduce([], fn pages_chunk, acc ->
    result = pages_chunk
      |> Enum.map(&(Task.async(fn -> Page.image(&1) end)))
      |> Enum.map(&(Task.await(&1, @http_timeout)))
      |> Enum.map(fn {:ok, image} -> image end)
    acc ++ result
  end)
```

Now, removing the chunking and reducing logic:

--- ruby
pages_list
  |> Enum.map(&(Task.async(fn -> Page.image(&1) end)))
  |> Enum.map(&(Task.await(&1, @http_timeout)))
  |> Enum.map(fn {:ok, image} -> image end)
```

And finally, replacing the direct <tt>Task.async/1</tt> call for the GenServer worker we just implemented above:

--- ruby
pages_list
  |> Enum.map(&Worker.page_image/1)
  |> Enum.map(&Task.await(&1, @await_timeout_ms))
  |> Enum.map(fn {:ok, image} -> image end)
```

Now, Poolboy requires will require a Supervisor that monitors our Worker. Let's put it under <tt>ex_manga_downloadr/pool_management/supervisor.ex</tt>:

--- ruby
defmodule PoolManagement.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    pool_options = [
      name: {:local, :worker_pool},
      worker_module: PoolManagement.Worker,
      size: 50,
      max_overflow: 0
    ]

    children = [
      :poolboy.child_spec(:worker_pool, pool_options, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
```

More OTP goodness here. We had a rogue Worker, now we have a responsible Supervisor deferring responsability to Poolboy. We start with a pool that can hold a maximum of 50 process within (without overflowing). This number comes from trial and error again. And the Supervisor will use a strategy of <tt>:one_for_one</tt>, which means that if the Worker dies it restarts it.

Now, we must add Poolboy to the <tt>mix.exs</tt> as a dependency and run <tt>mix deps.get</tt> to fetch it:

--- ruby
defp deps do
  [
    ...
    {:poolboy, github: "devinus/poolboy", tag: "1.5.1"},
    ...
  ]
end
```

In the same <tt>mix.exs</tt> we make the main Application (surprise: which is [already a supervised OTP application](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/application.ex)) start the PoolManagement.Supervisor for us:

--- ruby
def application do
  [applications: [:logger, :httpotion, :porcelain],
   mod: {PoolManagement, []}]
end
```

But we also need to have this <tt>PoolManagement</tt> module for it to call. We may call it <tt>pool_management.ex</tt>:

--- ruby
defmodule PoolManagement do
  use Application

  def start(_type, _args) do
    PoolManagement.Supervisor.start_link
  end
end
```

### Summary

Let's summarize:

1. the <tt>ExMangaDownloadr</tt> application will start up and fire up the <tt>PoolManagement</tt> application;
2. the <tt>PoolManagement</tt> application fires up the <tt>PoolManagement.Supervisor</tt>;
3. the <tt>PoolManagement.Supervisor</tt> fires up Poolboy and assigns <tt>PoolManagement.Worker</tt> to it, configuring it's pool size to 50 and responding to the pool name <tt>:worker_pool</tt>
4. now we start to fetch and parse through the Manga's chapters and pages until the <tt>ExMangaDownloadr.Workflow.images_sources/1</tt> is called;
5. it will call the <tt>PoolManagement.Worker.page_image/1</tt> function which in turn fires up a <tt>Task.async/1</tt>, calling <tt>:poolboy.transaction(:worker_pool, fn -> ... end)</tt>;
6. if a process is available in Poolboy's pool it starts right away, otherwise it awaits for a process to become available, it will wait until the <tt>@transaction_timeout_ms</tt> timeout configuration.
7. the process maps the entire <tt>pages_list</tt>, creating one async Task for each page in the list, we end up with a ginourmous list of Task pids, then we <tt>Task.await/2</tt> for them all to return.

Now, this application is much more reliable and faster as it fires up a new HTTP connection as soon as the first one responds and it return the process back to the pool. Instead of firing up 80 connections at a time, in batches, we start with 50 at the same time and then we fire up  one at a time for each process returned to the pool.

Through trial and error I set the <tt>@http_timeout</tt> to wait at most 60 seconds. I also set the <tt>timeout_ms</tt> which is the time to wait for the GenServer worker call handle to return and <tt>transaction_timeout_ms</tt> which is the time Poolboy awaits for a new process in the pool, both to around 16 minutes (1,000,000 ms).

This is putting 25 years of Erlang experience in the Telecom industry to good use!

And to make it crystal clear: OTP is the thing that sets Erlang/Elixir apart from all the rest. It's not the same thing, but it's like if the standard would be to write everything in Java as an EJB, ready to run inside a JEE Container. What comes to mind is: heavy.

In Erlang, an OTP application is lightweight, you can just build and use it ad hoc, without bureacracy, without having to set up complicated servers. As in our case, it's a very simple command line tool, and within it, the entire power of a JEE Container! Think about it.
