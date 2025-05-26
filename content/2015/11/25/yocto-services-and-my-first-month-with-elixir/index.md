---
title: '"Yocto Services"! And My First Month with Elixir!'
date: '2015-11-25T18:04:00-02:00'
slug: yocto-services-and-my-first-month-with-elixir
tags:
- learning
- beginner
- elixir
- english
draft: false
---

Wow, for the past month (almost, from Oct 27 to Nov 25) I decided that it was past time to dive deep and actually learn Elixir. I did just that, I am still a beginner but I feel very confident that I can tackle Elixir based projects now.

For my learning process:

1. I read the entire [oficial Elixir Documentation](http://elixir-lang.org/getting-started/introduction.html);
2. I read the entire Dave Thomas' [Programming Elixir](https://pragprog.com/book/elixir/programming-elixir) book;
3. I watched almost all [Elixir Sips](http://elixirsips.com/) screencats
4. I read the entire Benjamin Tan Wei Hao's [The Little Elixir & OTP Guidebook](https://www.manning.com/books/the-little-elixir-and-otp-guidebook) book;
5. I did a number of tutorials and exercises, and 

And finally, I documented everything I learned almost every day in the following articles:

* [How Fast is Elixir/Phoenix?](http://www.akitaonrails.com/2015/10/27/how-fast-is-elixir-phoenix)
* [Personal Thoughts on the Current Functional Programming Bandwagon](http://www.akitaonrails.com/2015/10/28/personal-thoughts-on-the-current-functional-programming-bandwagon)
* [Phoenix Experiment: Holding 2 Million Websocket clients!](http://www.akitaonrails.com/2015/10/29/phoenix-experiment-holding-2-million-websocket-clients)
* [My first week learning Elixir](http://www.akitaonrails.com/2015/11/03/my-first-week-learning-elixir)
* [Ex Manga Downloader, an exercise with Elixir](http://www.akitaonrails.com/2015/11/18/ex-manga-downloader-an-exercise-with-elixir)
* [Ex Manga Downloadr - Part 2: Poolboy to the rescue!](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue)
* [Phoenix "15 Minute Blog" comparison to Ruby on Rails](http://www.akitaonrails.com/2015/11/20/phoenix-15-minute-blog-comparison-to-ruby-on-rails)
* [Observing Processes in Elixir - The Little Elixir & OTP Guidebook](http://www.akitaonrails.com/2015/11/22/observing-processes-in-elixir-the-little-elixir-otp-guidebook)
* [ExMessenger Exercise: Understanding Nodes in Elixir](http://www.akitaonrails.com/2015/11/25/exmessenger-exercise-understanding-nodes-in-elixir)
* [Elixir 101 - Introducing the Syntax](http://www.akitaonrails.com/2015/11/25/elixir-101-introducing-the-syntax)

Yes, I am prolific, and highly focused. I did the learning and writing all within less than a month (it would've been less if I could have used night time and weekends). So I'd say that the average developer would take at least 3 to 4 months to cover the same material.

### Initial Thinking: Yocto Services!

For good of for worse, we are in the dawn of the Micro Services architecture. In summary it's fragmenting your monolith into smaller applications that responds to HTTP based endpoints - that people call "APIs" - and that are responsible for a very narrow set of responsabilities. Then you create a "front-end" web application that will consume those services, such as analytics, payment methods, user authentication directories, and so on.

This is no novelty, of course, having HTTP APIs that return JSON structures is just a fancier way of doing the same, good, old **Remote Procedure Calls**, or RPCs, a technology we have for decades to interconnect clients and servers in a network. But I digress.

If this is what people call "Micro" services, I think of Elixir processes as **"Yocto"** Services! (Milli > Micro > Nano > Pico > Femto > Atto > Zepto > Yocto, by the way - I may have just invented a new term here!)

I described a bit of the Processes infrastructure, how to spawn them, how to exchange messages between them, and how to link them together. So, go read [my previous post](http://www.akitaonrails.com/2015/11/22/observing-processes-in-elixir-the-little-elixir-otp-guidebook) if you haven't already.

Inside an Elixir app you will find many processes, some from the VM running the show and some from your own app. If you architected it correctly, you've implemented an OTP application, with proper groups of Supervisors and Children, all organized in a Supervision Tree. A small worker dies, its supervisor knows how to deal with it.

Now, here's the mental model: think of an Elixir process as a tiny micro-service - a **Yocto service**, if you will! - inside your application, . In a Phoenix application, for example, you don't import a "database library" you actually spin up a "Database Service" (which is an Ecto Repo) that runs in parallel with the Endpoint application that responds to HTTP requests coming from the internet. The code in your controllers and models "consume" and send messages to the Ecto Repo "Service". This is how you can visualize what's going on.

I have shown the Observer in the previous article as well. You will find a large tree if you open it up inside the IEx shell of a Phoenix application:

![Observer Phoenix](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/531/big_phoenix-observer.png)

In summary you will find the following section in the Pxblog Phoenix App Supervision Tree:

---
Pxblog.Supervisor
- Pxblog.Endpoint
    + Pxblog.Endpoint.Server
    + Pxblog.PubSub.Supervisor
        * Pxblog.PubSub
        * Pxblog.PubSub.Local
- Pxblog.Repo
    + Pxblog.Repo.Pool
---

This is the Pxblog I explained in the [Phoenix and Rails comparison article](http://www.akitaonrails.com/2015/11/20/phoenix-15-minute-blog-comparison-to-ruby-on-rails) I published a few days ago.

I still didn't read the source code of Phoenix, but if I am interpreting the Observer correctly, the Endpoint.Server controls a pool of processes that are TCP listeners that the application is ready to accept requests from, concurrently, with overflowing to accept more connections (I believe it's a pool implementation like Poolboy, which I explained in [Part 2 of the Ex Manga Downloader article](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue)).

Then, you have the PubSub.Supervisor and PubSub.Local applications that I believe support the WebSocket channels.

The Repo alone controls 10 initial processes in its pool, possibly a database connection pool. Notice how Endpoint and Repo groups are in parallel branches in the supervision tree. If Repo fails for some external database problems, the Endpoint group does not have to fail. This is what's declared in the Pxblog Application definition at <tt>lib/pxblog.ex</tt>:

---
defmodule Pxblog do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Pxblog.Endpoint, []),
      # Start the Ecto repository
      worker(Pxblog.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Pxblog.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pxblog.Supervisor]
    Supervisor.start_link(children, opts)
  end
  ...
end
---

See how it defines Endpoint and Repo under the Pxblog.Supervisor.

I can go on and forcefully kill the entire Pxblog.Repo node from the Supervision Tree using the Observer, like I did in the previous article, and the proper strategy kicks in, the Phoenix Supervisor successfully restarts the Repo, and no one will ever notice something crashed underneath.

![Kill Repo](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/532/big_phoenix_kill_repo.png)

From the IEx I can still make more calls to the Repo like this and it it responds as if it had never crashed:

---
iex(4)> Pxblog.Repo.all(Pxblog.User)
[debug] SELECT u0."id", u0."username", u0."email", u0."password_digest", u0."inserted_at", u0."updated_at" FROM "users" AS u0 [] OK query=78.2ms queue=3.2ms
[%Pxblog.User{__meta__: #Ecto.Schema.Metadata<:loaded>,
  email: "akitaonrails@me.com", id: 1,
  inserted_at: #Ecto.DateTime<2015-11-20T14:01:09Z>, password: nil,
  password_confirmation: nil,
  password_digest: "...",
  posts: #Ecto.Association.NotLoaded<association :posts is not loaded>,
  updated_at: #Ecto.DateTime<2015-11-20T14:01:09Z>, username: "akitaonrails"}]
---

And the way I think about this is: my IEx shell is sending a message to the Yocto Service called Pxblog.Repo (in reality it's forwarding messages to the database adapter that then checks out a process from the pool). Just like I would consume external Micro Services through HTTP APIs.

So the landscape of your application is comprised of a series of processes and groups of supervised processes all working to compose a larger structure. As I said in previous articles, should one group of process collapse, its Supervisor kicks in, traps the error and uses its strategy to, for example, restart all of its children processes, bringing the app to a consistent state once more, and without you having to restart the entire Elixir application.

So each process can be a full blown Yocto Service, running online and waiting for other services to consume it, such as the Repo's workers.

### Divide and Conquer

Again, as a disclaimer, I am still new to Elixir but the way I find easier to understand it, is like this:

* If you must deal with external resources, be it a File, or a Network Connections, or anything outside of the Erlang VM, you will want it to be a GenServer.

* Then, if you have a GenServer, you want to start it up under a Supervisor (usually, the simple boilerplate that defines the children and restart strategy).

* The number of GenServer processes you want to start up depends on how many parallel processes you want to have running. For example, if it is a database service, there is no point in starting up more than the available number of maximum connections your database allows. If you have several files to process, you want at most the number of available files or - in practice - just a few process to deal with batches of files. You will usually want a pool of GenServer processes, and in this case you want to use Poolboy.

* One GenServer may call other GenServers. You don't want to use a try/catch exception handling mechanism because you just need the particular GenServer process to crash if something goes wrong: if the file is corrupted or doesn't exist or if the network goes unstable or disconnects. The Supervisor will replace that process with a new GenServer process in its place and refill the Pool if needed.

* You can make GenServers [talk remotely](http://www.akitaonrails.com/2015/11/25/exmessenger-exercise-understanding-nodes-in-elixir) using the Node feature I explained 2 posts ago, with the ExMessenger example. Then it would be like a normal Micro Services architecture, but where the inside Yocto Services are actually doing the talking.

* Any transformation with no side-effects (transforming a simple input into a simple output), like getting an HTML body string and parsing into a List of tuples, can be organized in a normal Module. Refer to libraries like [Floki](https://github.com/philss/floki), to see how they are organized.

Each Erlang VM (called BEAM) is a single OS process, that manages a single real thread per CPU core available in your machine. Each real thread is managed by its own BEAM Scheduler, which will slice processing time between the lightweight processes inside.

Each BEAM process has its own mailbox to receive messages (more correctly called a **run-queue**). I/O operations such as file management will run asynchronously and not block the schedule, which will manage to run other processes while waiting for I/O.

Each BEAM process also has its own separated heap and garbage collector (a generational, 2 stage copy collector). Because each process has very little state (variables in a function) each garbage collector stop is super short and runs fast.

So, each BEAM VM can be thought of as an entire application infrastructure, with many Yocto Services available for your application to call.

And as I said in the [previous article](http://www.akitaonrails.com/2015/11/25/exmessenger-exercise-understanding-nodes-in-elixir), each BEAM VM can remotelly call other BEAM VMs and exchange messages between them as if they were in the same VM. The semantics are almost the same and you have distributed computing the easier way.

Erlang implemented a fantastic set of primitives that quickly scale as large as you want or need, with the proper wirings to not let you down. And Elixir fixes the only problem most people have with Erlang: it's [old Prolog-inspired weird syntax](http://www.akitaonrails.com/2015/11/25/elixir-101-introducing-the-syntax). Elixir is a thin and effective coat of modern language design, partly inspired by Ruby (although not a port by any means, it's still Erlang underneath).

I hope this series helped shed some light on why Elixir is the best choice among the new generation of high concurrency enabled languages and I also hope I made myself clear on why just high concurrency is not enough: you want high reliability as well. And in this aspect, the OTP architecture, built-in with Erlang, has no competition.
