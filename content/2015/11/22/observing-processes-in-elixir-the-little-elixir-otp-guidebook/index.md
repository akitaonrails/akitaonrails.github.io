---
title: Observing Processes in Elixir - The Little Elixir & OTP Guidebook
date: '2015-11-22T14:57:00-02:00'
slug: observing-processes-in-elixir-the-little-elixir-otp-guidebook
tags:
- learning
- beginner
- elixir
- english
draft: false
---

In my journey to really understand how a proper Elixir application should be written I am exercising through Benjamin Tan Wei Hao's excelent [The Little Elixir & OTP Guidebook](https://www.manning.com/books/the-little-elixir-and-otp-guidebook). If you're just getting started, this is a no-brainer: buy and study this guidebook. Yes, it will help if you already read Dave Thomas' [Programming Elixir](https://pragprog.com/book/elixir/programming-elixir) book first.

In my [Ex Manga Downloadr Part 2](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue) article I explored adding better process pool control using the excelent and robust Poolboy library. One of the guidebook main exercises is to build a simpler version of Poolboy in pure Elixir (Poolboy is written in good, old, Erlang).

This main goal of this article is to introduce what **Fault Tolerance** in Erlang/Elixir mean and it is also an excuse for me to show off Erlang's observer:

![Observer](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/528/big_observer-kill.png)

Yes, Erlang allows us to not just see what's going on inside its runtime environment but we can even take action on individual Processes running inside it! How cool is that?

But before we can show Fault Tolerancy and the Observer I need to explain what Processes are, and why they matter. You **must** understand the following concepts to successfully understand Elixir programming:

1. You don't have "objects", which are runtime instances of classes (or prototipical objects, which are copies of other objects). Instead of "Classes" you have collections of functions organized in modules, without dependency in internal state. And instead of "objects" we have, roughly speaking, "processes". For example:

```ruby
defmodule MyProcess do
  def start do
    accepting_messages(0)
  end

  def accepting_messages(state) do
    receive do
      {:hello, message} ->
        IO.puts "Hello, #{message}"
        accepting_messages(state)
      {:counter} ->
        new_state = state + 1
        IO.puts "New state is #{new_state}"
        accepting_messages(new_state)
      _ ->
        IO.puts "What?"
        accepting_messages(state)
    end
  end
end
```

2. We can execute a function inside another process. This is how we can spawn a brand new, concurrent, lightweight process:

```ruby
iex(2)> pid = spawn fn -> MyProcess.start end
#PID<0.87.0>
```

When the <tt>accepting_messages/1</tt> is called, it stops at the <tt>receive/0</tt> block, waiting to receive a new message. Then we can send messages like this:

```ruby
iex(3)> send pid, {:hello, "world"}
Hello, world
```

It receives the <tt>{:hello, "world"}</tt> atom message, it pattern matches the value <tt>"world"</tt> into the <tt>message</tt> variable, and concatenates the <tt>"Hello, world"</tt> string, which it prints out with <tt>IO.puts/1</tt> and recurse to itself again. We call the <tt>receive/0</tt> block again, and block, waiting for further messages:

```ruby
iex(4)> send pid, {:counter}
New state is 1
{:counter}
iex(5)> send pid, {:counter}
New state is 2
{:counter}
iex(6)> send pid, {:counter}
New state is 3
{:counter}
iex(7)> send pid, {:counter}
New state is 4
```

We send the <tt>{:counter}</tt> message to the same process pid again and when it receive this message, it gets the <tt>state</tt> value from the function argument, increments it by 1, prints out the new state, and calls itself again passing the new state as the new argument. It blocks again, waiting for further messages, and for each time it receives the <tt>{:counter}</tt> message, it increases the previous state by one again and recurses.

This is basically how we can maintain state in Elixir. If we kill this process and spawn a new one, it restarts with zero (which is what the <tt>start/0</tt>) function does.

3. So, while you don't have "objects" you do, however, have Processes. Superficially, a process behaves like an "object". Careful not to think that a Process is like a heavyweight Thread though. Erlang has its own internal scheduler that controls the concurrency of parallels and you can load as many as 16 billion lightweight processes if your hardware allows it. Threads are super heavy, Erlang processes are super light.

4. As we saw in the example, each process has its own internal mechanism to receive messages from other processes. Those messages accumulate in an internal "mailbox" and you can choose to <tt>receive</tt> and pattern match through those messages, recursing to itself again in order to receive new messages if you want.

5. Processes can be linked to or monitor other processes, for example, within an IEx shell, we are within an Elixir process, so we could do:

```ruby
iex(1)> self
#PID<0.98.0>
iex(2)> pid = spawn fn -> MyProcess.start end
#PID<0.105.0>
iex(3)> Process.alive?(pid)
true
iex(4)> Process.link(pid)
true
```

With <tt>self</tt> we can see that the current process id for the IEx shell is "0.98.0". Then we spawn a process that calls <tt>Myprocess.start/0</tt> again, it will block in the receive call. This new process has a different id, "0.105.0".

We can assert that the new process is indeed alive and we can link the IEx shell with the "0.105.0" pid process. Now, whatever happens to this process will cascade to the shell.

```ruby
iex(5)> Process.exit(pid, :kill)
** (EXIT from #PID<0.98.0>) killed

Interactive Elixir (1.1.1) - press Ctrl+C to exit (type h() ENTER for help)
/home/akitaonrails/.iex.exs:1: warning: redefining module R
iex(1)> self
#PID<0.109.0>
```

And indeed, if we forcefully send a kill message to the "0.105.0" process, the IEx shell is also killed in the process. IEx restarts and its new pid is "0.109.0" instead of the old "0.98.0". By the way this is one way a process is different from a normal object. It behaves more like an operating system process where a crash in a process does not affect the whole system as it does not hold external shared state that can corrupt the system's state.

The important concept is that we now have a mechanism to define a Parent Process (IEx in this example) and Children processes linked to it.

6. Parent processes don't need to stupidly suicide itself because their children screwed up. Instead, they can trap exits and decide what to do later:

```ruby
iex(2)> Process.flag(:trap_exit, true)
false
iex(3)> pid = spawn_link fn -> MyProcess.start end
#PID<0.118.0>
iex(4)> send pid, {:counter}
New state is 1
{:counter}
```

First, we declare that the IEx shell will trap exists and not just die. Then we spawn a new process and link it. The <tt>spawn_link/1</tt> function has the same effect of <tt>spawn/1</tt> and then <tt>Process.link/1</tt>. We can send a message to the new pid and check that it is indeed still working.

```ruby
iex(5)> Process.exit(pid, :kill)
true
iex(6)> Process.alive?(pid)
false
iex(7)> flush
{:EXIT, #PID<0.118.0>, :killed}
:ok
```

Now we forcefully kill the new process again, but IEx does not crash this time, as it is explicitly trapping those errors. If we check the killed pid, we can assert that it is indeed dead. But now we can also inspect IEx's own process mailbox (in this case, just flushing whats queued in the inbox) and see that it just received a message saying that its child was killed.

From here we could make IEx process treat this message and decide to just mourn for its deceased child and commit suicide itself, or move on and spawn_link a new now. We have **choice** in the face of disaster.

### OTP Workers

Letting aside the grim metaphor, we learned that we have Parent and Child processes, but more importantly they can fit the roles of Supervisors and Workers that are supervised, respectivelly.

Workers is where we put our code. This code can have bugs, it can depend on external stuff that can make our code crash for unexpected reasons. In a normal language we would start using the dreaded <tt>try/catch</tt> blocks, which are just ugly and **wrong**! Don't catch errors in Elixir, just let it crash!!

As I explained in my previous article, everything in Elixir ends up being a so called "OTP application". The example above is just a very simple contraption that we can expand upon. Let's rewrite the same thing as an OTP GenServer:

```ruby
defmodule MyFancyProcess do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  ## Public API

  def hello(message) do
    GenServer.call(__MODULE__, {:hello, message})
  end

  def counter do
    GenServer.call(__MODULE__, :counter)
  end

  ## GenServer callbacks

  def init(start_counter) do
    {:ok, start_counter}
  end

  def handle_call({:hello, message}, _from, state) do
    IO.puts "Hello, #{message}"
    {:reply, :noproc, state}
  end

  def handle_call(:counter, _from, state) do
    new_state = state + 1
    IO.puts "New state is #{new_state}"
    {:reply, :noproc, new_state}
  end
end
```

This new <tt>MyFancyProcess</tt> is essentially the same as <tt>MyProcess</tt> but with OTP GenServer on top of it. There are Public API functions and GenServer callbacks.

Benjamin's book go to great lenghts to detail every bit of what I just implemented. But for now just understand some basics:

1. The module does "<tt>use GenServer</tt>" to import all the necessary GenServer bits for your convenience. In essence one of the things it will do is create that <tt>receive</tt> block we did in the first version to wait for messages.

2. The <tt>start_link/1</tt> function will create the instance of this GenServer and return the linked process. Internally it will call back to the <tt>init/1</tt> function to set the initial state of this worker. This is a flexible language, we have multiple ways of doing the same thing, and this is good, having just a single way of writing code is boring.

3. The convention is to have one public function that calls the internal <tt>handle_call/3</tt> (for synchronous calls), <tt>handle_cast/2</tt> (for asynchronous calls), and <tt>handle_info/2</tt>. You could just call <tt>handle_call</tt> from the outside, but it's just ugly, so you will find this convention everywhere.

Once we have this in place, we can start calling it directly:

```ruby
iex(11)> MyFancyProcess.start_link(0)
{:ok, #PID<0.261.0>}
iex(12)> MyFancyProcess.hello("world")
Hello, world
:noproc
iex(13)> MyFancyProcess.counter
New state is 1
:noproc
iex(14)> MyFancyProcess.counter
New state is 2
:noproc
iex(15)> MyFancyProcess.counter
New state is 3
:noproc
```

And this is much cleaner than the version where we manually <tt>spawn_link</tt> and <tt>send</tt> messages to a pid. This is all handled nicely by the GenServer underneath it. And as I said, the results are the same as the initial crude <tt>MyProcess</tt> example.

In fact, this convention does make us type a lot of boilerplate many times over. There is a library called [ExActor](https://github.com/sasa1977/exactor) that grealy simplifies a GenServer implementation, making our previous code become something like this:

```ruby
defmodule MyFancyProcess do
  use ExActor.GenServer, initial_state: 0

  defcall hello(message), state do
    IO.puts "Hello, #{message}"
    noreply
  end

  defcall counter, state do
    new_counter = state + 1
    IO.puts "New state is #{new_counter}"
    new_state(new_counter)
  end
end
```

This is way cleaner, but as we are just using IEx, I'm not using this version for the next section, stick with the longer version of <tt>MyFancyProcess</tt> listed in the beginning of this section!

## OTP Supervisor

Now that we have a worker, we can create a Supervisor to supervise it:

```ruby
defmodule MyFancySupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      worker(MyFancyProcess, [0])
    ]

    opts = [strategy: :one_for_one]

    supervise(children, opts)
  end
end
```

This is just a simple boilerplace that most Supervisors will have. There are many details you must learn, but for this article's purposes the important bits are, first, the definition of the <tt>children</tt> specification, saying that this Supervisor should start the <tt>MyFancyProcess</tt> GenServer instead of us having to <tt>MyFancyProcess.start_link</tt> manually. And the second important bit is the <tt>opts</tt> list which defines the strategy of <tt>:one_for_one</tt>, meaning that if the Supervisor detects that the child has died, it should restart it.

From a clean IEx, we can copy and paste both the <tt>MyFancyProcess</tt> and <tt>MyFancySupervisor</tt> above and start playing with it in the IEx shell:

```ruby
iex(3)> {:ok, sup_pid} = MyFancySupervisor.start_link   
{:ok, #PID<0.124.0>}
iex(4)> MyFancyProcess.hello("foo")
Hello, foo
:noproc
iex(5)> MyFancyProcess.counter     
New state is 1
:noproc
iex(6)> MyFancyProcess.counter
New state is 2
:noproc
```

This is how we start the Supervisor and you can see that right away we can start sending messages to the <tt>MyFancyProcess</tt> GenServer because the Supervisor successfully started it for us.

```ruby
iex(7)> Supervisor.count_children(sup_pid)
%{active: 1, specs: 1, supervisors: 0, workers: 1}
iex(8)> Supervisor.which_children(sup_pid)
[{MyFancyProcess, #PID<0.125.0>, :worker, [MyFancyProcess]}]
```

Using the Supervisor PID that we captured right when we started it, we can ask it to count how many children it is monitoring (1, in this example) and we can ask the details of each children as well. We can see that the <tt>MyFancyProcess</tt> started with the pid of "0.125.0"

```ruby
iex(9)> [{_, worker_pid, _, _}] = Supervisor.which_children(sup_pid)
[{MyFancyProcess, #PID<0.125.0>, :worker, [MyFancyProcess]}]
iex(14)> Process.exit(worker_pid, :kill)
true
```

Now, we can grab the Worker pid and manually force it to crash as we did before. We should be screwed, right? Nope:

```
iex(15)> Supervisor.which_children(sup_pid)                          
[{MyFancyProcess, #PID<0.139.0>, :worker, [MyFancyProcess]}]

iex(16)> MyFancyProcess.counter
New state is 1
:noproc
iex(17)> MyFancyProcess.counter
New state is 2
:noproc
```

If we ask the Supervisor again for the list of its children, we will see that the old "0.125.0" process did indeed vanish but a new one, "0.139.0" was spawned in its place by the Supervisor strategy of <tt>:one_for_one</tt> as we defined before.

We can continue making calls do the <tt>MyFancyProcess</tt> but you will see that the previous state was lost and it restarts from zero. We can add state management in the GenServer using a number of different persistent storages such as the built-in [ETS](http://elixir-lang.org/getting-started/mix-otp/ets.html) (think of ETS as a built-in Memcache service), but I think you get the idea by now.

### Graphically visualizing Processes

This entire article was motivated by just this simple thing in Benjamin's book: by the end of page 139 of the book you will have built a very simple pool system that is able to start 5 process in the pool, guarded by a supervisor. And from there he goes on to show off the Observer.

Erlang has a built-in inspector tool called Observer. You can use the Supervisor built-in functions to inspect processes as I demonstrated before, but it's much cooler to see it visually. Assuming you installed Erlang Solutions propertly, in Ubuntu you have to:

```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
```

Only then, you can start the observer directly from the IEx shell like this:

```
:observer.start
```

And a graphical window will show up with some stats first.

![Observer](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/530/big_observer-system.png)

This is **very** powerful becuase you have insight and control over the entire Erlang runtime! See that this status window even show you "uptime", it's line a UNIX system: it is made to stay up no matter what. Processes have its own garbage collector and they all behave nicely towards the entire system.

You can hook a remote Observer to remote Erlang runtimes as well, if you were wondering. Now you can jump to the Applications tab to see how the "Pooly" exercise looks like with 5 children under its pool:

![Pooly](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/527/big_observer-pooly.png)

Because those children are supervised with proper restart strategies, we can visually kill one of them, the one with the pid labeled "0.389.0":

![Kill process](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/528/big_observer-kill.png)

And as the Observer immediatelly shows, the Supervisor took action, spawned a new child and added it to its pool, bringing the count back to 5:

![Respawn](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/529/big_observer-restart.png)

This is what **Fault Tolerance** with proper controls mean by using OTP!

With the bits I explained in this article you should have enough concepts to finally grasp what the Erlang's high reliabiliby fuzz is all about. The basic concepts are very simple, to hook your application to OTP is also a no-brainer, what OTP has implemented under the hood is what makes your application much more reliable.

There are clear guidelines on how to design your application. Who supervises what. What should happen to the application state if workers are restarted? How you divide responsabilities between different groups of Supervisor/Children?

Your application is supposed to look like a Tree, a **Supervision Tree**, where failure in one leaf does not bring the other branches down and everything knows how to behave and how to recover, elegantly. It's really like a UNIX operating system: when you <tt>kill -9</tt> one process, it doesn't bring your system down, and if it's <tt>initd</tt> monitored service, it gets respawned.

Most important: this is not an optional feature, a 3rd party library, that you choose too use. It's built-in in Erlang, you must use it if you want to play. There is no other choice and this is the best choice. Any such pattern that is not implemented in a concurrent language, to me, represents a big failure of the language. This is Elixir's strength.

This is high level control you won't find anywhere else. And we still didn't even talk about how OTP applications can exchange messages across the wire in really distributed systems, and how the Erlang runtime can reload code while an application is running, with zero downtime, akin of what IEx itself is capable of and how Phoenix allow development mode with code reloading! OTP gives all this for free, so it's well worth learning all the details.

We went through processes, pids, send a kill message to a process, trap exits, parent having child processes. Feels very similar to how UNIX works. If you know UNIX, you can easily grasp how all this fit together, including Elixir pipe operator "|>" compared to UNIX's own pipe "|", it's similar.

Finally, The Little Elixir & OTP Guidebook is a very easy to read, very hands-on small book. You can read it all in a couple of days and grasp everything I quickly summarized here and much more. I highly encourage you to buy it right now.
