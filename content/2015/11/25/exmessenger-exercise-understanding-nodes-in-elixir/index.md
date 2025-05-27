---
title: 'ExMessenger Exercise: Understanding Nodes in Elixir'
date: '2015-11-25T13:19:00-02:00'
slug: exmessenger-exercise-understanding-nodes-in-elixir
tags:
- learning
- beginner
- elixir
- english
draft: false
---

I was exercising through this [2014's old blog post](http://drew.kerrigan.io/ditributed-elixir/) by Drew Kerrigan where he builds a bare bones, command line-based, chat application, with a client that send messages and commands to a server.

This is Elixir pre-1.0, and because it's an exercise I refactored the original code and merged the server (ex_messenger) and client (ex_messenger_client) projects into an [Elixir Umbrella](http://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-apps.html) project and you can find my code on [Github here](https://github.com/akitaonrails/ex_messenger_exercise/blob/master/apps/ex_messenger_client/lib/ex_messenger_client.ex).

If you have multiple applications that work together and share the same dependencies you can use the Umbrella convention to have them all in the same code base. If you <tt>mix compile</tt> from the umbrella root, it compiles all the apps (which are independent Elixir mix projects as well), it's just a way to have related apps in the same place instead of in multiple different repositories.

The code shown here is in [my personal Github repository](https://github.com/akitaonrails/ex_messenger_exercise) if you want to clone it.

### Nodes 101

Before we check out the exercise, there is one more concept I need to clear out. In the previous article I explained about how you can start processes and exchange messages and how you can use the OTP GenServer and Supervisor to create more robust and fault tolerant processes.

But this is just the beginning of the story. You probably heard how Erlang is great for distributed computing as well. Each Erlang VM (or BEAM) is network enabled.

Again, this is one more concept I am still just beginning to properly learn, and you will want to read Elixir's website documentation on [Distributed tasks and configuration](http://elixir-lang.org/getting-started/mix-otp/distributed-tasks-and-configuration.html), that does an excellent job explaining how all this works.

But just to get started you can simply start 2 IEx sessions. From one terminal you can do:

```
iex --sname fabio --cookie chat

Erlang/OTP 18 [erts-7.1] [source] [64-bit] [smp:4:4] [async-threads:10] [kernel-poll:false]

Interactive Elixir (1.1.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(fabio@Hal9000u)1> 
```

And from a different terminal you can do:

```
iex --sname akita --cookie chat

Erlang/OTP 18 [erts-7.1] [source] [64-bit] [smp:4:4] [async-threads:10] [kernel-poll:false]

Interactive Elixir (1.1.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(akita@Hal9000u)1> 
```

Notice how the IEx shell shows different Node names for each instance: "fabio@Hal9000u" and "akita@Hal9000u". It's the sname concatenated with your machine name. From one instance you can ping the other, for example:

```
iex(akita@Hal9000u)2> Node.ping(:"fabio@Hal9000u")
:pong
```

If the name is correct and the other instance is indeed up, it responds the ping with a <tt>:pong</tt>. This is correct just for nodes in the same machine, but what if I need to connect to an instance in a remote machine?

```
iex(akita@Hal9000u)3> Node.ping(:"fabio@192.168.1.13")

11:02:46.152 [error] ** System NOT running to use fully qualified hostnames **
** Hostname 192.168.1.13 is illegal **
```

The <tt>--sname</tt> option sets a name only reachable within the same subnet, for a fully qualified domain name you need to use the <tt>--name</tt>, for example, like this:

```
iex  --name fabio@192.168.1.13 --cookie chat
```

And for the other node:

```
iex --name akita@192.168.1.13 --cookie chat
```

And from this second terminal you can ping the other node the same way as before:

```
iex(akita@192.168.1.13)1> Node.ping(:"fabio@192.168.1.13")
:pong
```

And you might be wondering, what is this "<tt>--cookie</tt>" thing? Just spin up a third terminal with another client name, but without the cookie, like this:

```
iex --name john@192.168.1.13
```

And if you try to ping one of the first two nodes you won't get a <tt>:pong</tt> back:

```
iex(john@192.168.1.13)1> Node.ping(:"fabio@192.168.1.13")
:pang
```

The cookie is just an atom to identify relationship between nodes. In a pool of several servers you can make sure you're not trying to connect different applications between each other. And as a result you get a <tt>:pang</tt>. Instead of an IP address you can use a fully qualified domain name instead.

And just by having the node "akita@" pinging "fabio@" we can see that they are aware of each other:

```
iex(fabio@192.168.1.13)2> Node.list
[:"akita@192.168.1.13"]
```

And:

```
iex(akita@192.168.1.13)2> Node.list
[:"fabio@192.168.1.13"]
```

If one of the node crashes or quits, the Node list is automatically refreshed to reflect only nodes that are actually alive and responding.

You can check the official API Reference for the [Node](http://elixir-lang.org/docs/stable/elixir/Node.html#summary) for more information. But this should give you a hint for the next section.

### Creating a Chat Client

Back to the exercise, the ExMessenger server has "ExMessenger.Server", which is a GenServer and the "ExMessenger.Supervisor" that starts it up. The ExMessenger.Server is globally registered as <tt>:message_server</tt>, started and supervised by the "ExMessenger.Supervisor".

The "ExMessengerClient" starts up the unsupervised "ExMessengerClient.MessageHandler", which is also a GenServer, and globally registered as <tt>:message_handler</tt>.

The Tree for both apps look roughly like this:

```
ExMessenger
- ExMessenger.Supervisor
    + ExMessenger.Server
ExMessengerClient
- ExMessengerClient.MessageHandler
```

We start them separately, first the message server:

```
cd apps/ex_messenger
iex --sname server --cookie chocolate-chip -S mix run
```

Notice that for this example we are starting with a simple name "server", for the local subnet, and a cookie. If will respond as "server@Hal9000u" (Hal9000u being my local machine's name).

Then, we can start the client app:

```
cd apps/ex_messenger_client
server=server@Hal9000u nick=john elixir --sname client -S mix run
```

Here we are setting 2 environment variables (that we can retrieve inside the app using <tt>System.get_env/1</tt>) and also setting a local node name "client". You can spin up more client nodes using a different "sname" and a different "nick" from another terminal, as many as you want, linking to the same "server@Hal9000u" message server.

I'm starting up like this instead of a command line escript like I did in the ExMangaDownloadr because I didn't find any way to set the <tt>--sname</tt> or <tt>--name</tt> the same way I can set <tt>--cookie</tt> using <tt>Node.set_cookie</tt>. If anyone knows how to set it up differently, let me know in the comments section down below.

Notice that I said "linking" and not "connecting". From the "ExMessengerClient" we start like this:

--- ruby
defmodule ExMessengerClient do
  use Application
  alias ExMessengerClient.CLI
  alias ExMessengerClient.ServerProcotol

  def start(_type, _args) do
    get_env
      |> connect
      |> start_message_handler
      |> join_chatroom
      |> CLI.input_loop
  end
  ...
end
```

The <tt>get_env</tt> private function is just a wrapper to treat the environment variable "server" and "nick" that we passed:

--- ruby
defp get_env do
  server = System.get_env("server")
    |> String.rstrip
    |> String.to_atom
  nick = System.get_env("nick")
    |> String.rstrip
  {server, nick}
end
```

Now, we try to connect to the remote server:

--- ruby
defp connect({server, nick}) do
  IO.puts "Connecting to #{server} from #{Node.self} ..."
  Node.set_cookie(Node.self, :"chocolate-chip")
  case Node.connect(server) do
    true -> :ok
    reason ->
      IO.puts "Could not connect to server, reason: #{reason}"
      System.halt(0)
  end
  {server, nick}
end
```

The important piece here is that we are setting the client's instance cookie with <tt>Node.set_cookie/1</tt> (notice that we didn't pass it in the command line options like we did with the server instance). Without setting the cookie the next line with <tt>Node.connect(server)</tt> would fail to connect, as I explained in the previous section.

Then, we start the "ExMessengerClient.MessageHandler" GenServer, linking with the Message Server instance:

--- ruby
defp start_message_handler({server, nick}) do
  ExMessengerClient.MessageHandler.start_link(server)
  IO.puts "Connected"
  {server, nick}
end
```

The Message Handler GenServer itself is very simple, it just sets the server as the state and handle incoming messages from the server and prints out in the client's terminal:

--- ruby
defmodule ExMessengerClient.MessageHandler do
  use GenServer

  def start_link(server) do
    :gen_server.start_link({ :local, :message_handler }, __MODULE__, server, [])
  end

  def init(server) do
    { :ok, server }
  end

  def handle_cast({ :message, nick, message }, server) do
    message = message |> String.rstrip
    IO.puts "\n#{server}> #{nick}: #{message}"
    IO.write "#{Node.self}> "
    {:noreply, server}
  end
end
```

Going back to the main "ExMessengerClient" module, after starting the (unsupervised) GenServer that receives incoming messages, we proceed to join the pseudo-chatroom in the server:

--- ruby
defp join_chatroom({server, nick}) do
  case ServerProcotol.connect({server, nick}) do
    {:ok, users} ->
      IO.puts "* Joined the chatroom *"
      IO.puts "* Users in the room: #{users} *"
      IO.puts "* Type /help for options *"
    reason ->
      IO.puts "Could not join chatroom, reason: #{reason}"
      System.halt(0)
  end
  {server, nick}
end
```

I defined this "ServerProcotol" module which is just a convenience wrapper for <tt>GenServer.call/3</tt> and <tt>GenServer.cast/2</tt> calls, to send messages for the remote GenServer called <tt>:message_server</tt>:

--- ruby
defmodule ExMessengerClient.ServerProcotol do
  def connect({server, nick}) do
    server |> call({:connect, nick})
  end

  def disconnect({server, nick}) do
    server |> call({:disconnect, nick})
  end

  def list_users({server, nick}) do
    server |> cast({:list_users, nick})
  end

  def private_message({server, nick}, to, message) do
    server |> cast({:private_message, nick, to, message})
  end

  def say({server, nick}, message) do
    server |> cast({:say, nick, message})
  end

  defp call(server, args) do
    GenServer.call({:message_server, server}, args)
  end

  defp cast(server, args) do
    GenServer.cast({:message_server, server}, args)
  end
end
```

Pretty straight forward. Then, the main ExMessengerClient calls the recursive <tt>input_loop/1</tt> function from the CLI module, which just receives user input and handles the proper commands using pattern matching, like this:

--- ruby
defmodule ExMessengerClient.CLI do
  alias ExMessengerClient.ServerProcotol

  def input_loop({server, nick}) do
    IO.write "#{Node.self}> "
    line = IO.read(:line)
      |> String.rstrip
    handle_command line, {server, nick}
    input_loop {server, nick}
  end

  def handle_command("/help", _args) do
    IO.puts """
    Available commands:
      /leave
      /join
      /users
      /pm <to nick> <message>
      or just type a message to send
    """
  end

  def handle_command("/leave", args) do
    ServerProcotol.disconnect(args)
    IO.puts "You have exited the chatroom, you can rejoin with /join or quit with /quit"
  end

  def handle_command("/quit", args) do
    ServerProcotol.disconnect(args)
    System.halt(0)
  end

  def handle_command("/join", args) do
    ServerProcotol.connect(args)
    IO.puts "Joined the chatroom"
  end

  def handle_command("/users", args) do
    ServerProcotol.list_users(args)
  end

  def handle_command("", _args), do: :ok

  def handle_command(nil, _args), do: :ok

  def handle_command(message, args) do
    if String.contains?(message, "/pm") do
      {to, message} = parse_private_recipient(message)
      ServerProcotol.private_message(args, to, message)
    else
      ServerProcotol.say(args, message)
    end
  end

  defp parse_private_recipient(message) do
    [to|message] = message
      |> String.slice(4..-1)
      |> String.split
    message = message
      |> List.foldl("", fn(x, acc) -> "#{acc} #{x}" end)
      |> String.lstrip
    {to, message}
  end
end
```

And this wraps up the Client.

### Creating a Chat Server

The Chat Client sends GenServer messages to a remote <tt>{:message_server, server}</tt>, and in the example, <tt>server</tt> is just the sname "server@Hal9000u" atom.

Now, we need this <tt>:message_server</tt> and this is the "ExMessenger.Server" GenServer:

--- ruby
defmodule ExMessenger.Server do
  use GenServer
  require Logger

  def start_link([]) do
    :gen_server.start_link({ :local, :message_server }, __MODULE__, [], [])
  end

  def init([]) do
    { :ok, HashDict.new }
  end
  ...
end
```

And this is it, when the "ExMessenger.Supervisor" starts this GenServer it register globally in this instance as <tt>:message_server</tt>. And this how we address messages from what we called "clients" (the ExMessengerClient application).

When the ExMessengerClient calls the <tt>ServerProtocol.connect/1</tt>, it sends the <tt>{:connect, nick}</tt> message to the server. In the Server we handle it like this:

--- ruby
def handle_call({ :connect, nick }, {from, _} , users) do
  cond do
    nick == :server or nick == "server" ->
      {:reply, :nick_not_allowed, users}
    HashDict.has_key?(users, nick) ->
      {:reply, :nick_in_use, users}
    true ->
      new_users = users |> HashDict.put(nick, node(from))
      user_list = log(new_users, nick, "has joined")
      {:reply, { :ok, user_list }, new_users}
  end
end
```

First, it checks if the nick is "server" and disallows it. Second, it checks if the nickname already exists in the internal [HashDict](http://elixir-lang.org/docs/stable/elixir/HashDict.html) (a key/value dictionary) and refuses if it already exists. Finally, in third, it puts the pair of nickname and node name (like "client@Hal9000u") in the HashDict and broadcasts through the <tt>log/3</tt> private function to all other nodes in the HashDict dictionary.

The <tt>log/3</tt> is just to create a log message concatenating the nick names of all clients and printing it out, then broadcasting this to the Message Handler of all the clients listed in the HashDict:

--- ruby
defp log(users, nick, message) do
  user_list = users |> HashDict.keys |> Enum.join(":")
  Logger.debug("#{nick} #{message}, user_list: #{user_list}")
  say(nick, message)
  user_list
end

def say(nick, message) do
  GenServer.cast(:message_server, { :say, nick, "* #{nick} #{message} *" })
end

def handle_cast({ :say, nick, message }, users) do
  ears = HashDict.delete(users, nick)
  Logger.debug("#{nick} said #{message}")
  broadcast(ears, nick, message)
  {:noreply, users}
end
```

Up to this point it just casts a message to itself, the <tt>{:say, nick, message}</tt> tuple, that is handled by the GenServer and calling the <tt>broadcast/3</tt> function defined like this:

--- ruby
defp broadcast(users, nick, message) do
  Enum.map(users, fn {_, node} ->
    Task.async(fn ->
      send_message_to_client(node, nick, message)
    end)
  end)
  |> Enum.map(&Task.await/1)
end

defp send_message_to_client(client_node, nick, message) do
  GenServer.cast({ :message_handler, client_node }, { :message, nick, message })
end
```

It maps the list of users and fire up an asynchronous Elixir <tt>Task</tt> (that is itself just a GenServer as I explained before in the Ex Manga Downloader series). Because it's a broadcast it makes sense to make all of them parallel.

The important bit is the <tt>send_message_to_client/3</tt> which casts a message to the tuple <tt>{ :message_handler, client_node }</tt> where "client_node" is just "client@Hal9000u" or any other "--sname" you used to start up each client node.

Now, this is how the clients send GenServer message calls/casts to <tt>{:message_server, server}</tt> and it send messages back to <tt>{:message_handler, client</tt>.

### This is not your traditional TCP Client/Server example!

Now, we are calling the "ExMessenger.Server" a Chat "Server" and the "ExMessengerClient" a Chat "Client". Although we have been calling them as  "Server" and "Client" they don't refer to the usual "TCP Server" and "TCP Client" examples you may be familiar with!

The ExMessenger.Server is indeed a Server (an OTP GenServer) but the ExMessengerClient.MessageHandler is also a Server (another OTP GenServer)! But because they **both** have Node behavior, it's more like they are 2 peer-to-peer nodes instead of your old school, simple client->server relationship. They can have client behavior (the Server sends messages to the MessageHandler) and server behavior (the Server receiving messages from ExMessengerClient).

Let this concept sink in for a moment, built-in with the language you get a full blown, easy to use, peer-to-peer network distribution model. You don't need to have one single node to be elected as the sole "node", you could have all nodes in a ring to coordinate between them, avoiding single points of failure.

I believe this is maybe how Erlang based services such as [ejabberd](http://manpages.ubuntu.com/manpages/hardy/man8/ejabberd.8.html) and [RabbitMQ](https://www.rabbitmq.com/clustering.html) work.

In the [case of ejabberd](https://github.com/processone/ejabberd/blob/master/src/ejabberd_cluster.erl), I can see that it keeps the state of the cluster in Mnesia tables (Mnesia being one other component of OTP, it's a distributed NoSQL database built-in!) and it indeed use the Node facilities to coordinate distributed nodes:

--- erlang
...
join(Node) ->
    case {node(), net_adm:ping(Node)} of
        {Node, _} ->
            {error, {not_master, Node}};
        {_, pong} ->
            application:stop(ejabberd),
            application:stop(mnesia),
            mnesia:delete_schema([node()]),
            application:start(mnesia),
            mnesia:change_config(extra_db_nodes, [Node]),
            mnesia:change_table_copy_type(schema, node(), disc_copies),
            spawn(fun()  ->
                lists:foreach(fun(Table) ->
                            Type = call(Node, mnesia, table_info, [Table, storage_type]),
                            mnesia:add_table_copy(Table, node(), Type)
                    end, mnesia:system_info(tables)--[schema])
                end),
            application:start(ejabberd);
        _ ->
            {error, {no_ping, Node}}
    end.
```

This is how a snippet of pure Erlang source code looks like, by the way. You should have enough Elixir in your head right now to be able to abstract away the ugly Erlang syntax and see that it's a <tt>case</tt> pattern matching on the <tt>{_, :pong}</tt> tupple, using Node's ping facilities to assert the connectiviness of the node and updating the Mnesia table and other setups.

Also in the [source code of the RabbitMQ-Server](https://github.com/rabbitmq/rabbitmq-server/blob/6f70dcbe05dbba35f7d950674d293a4c7d867d44/src/rabbit_control_main.erl) you will find a similar thing:

--- erlang
become(BecomeNode) ->
    error_logger:tty(false),
    ok = net_kernel:stop(),
    case net_adm:ping(BecomeNode) of
        pong -> exit({node_running, BecomeNode});
        pang -> io:format("  * Impersonating node: ~s...", [BecomeNode]),
                {ok, _} = rabbit_cli:start_distribution(BecomeNode),
                io:format(" done~n", []),
                Dir = mnesia:system_info(directory),
                io:format("  * Mnesia directory  : ~s~n", [Dir])
    end.
```

Again, pinging nodes, using Mnesia for the server state. Erlang's syntax is uncommon for most of us: variables start with a capitalized letter (we intuitively think it's a constant instead), statements end with a dot, instead of the dot-notation to call function from a module it uses a colon ":", different from Elixir the parenthesis are not optional, and so on. Trying to read code like this show the value of having Elixir to unleash Erlang's hidden powers.

So, up to this point, you know how internally processes are spawn, how they are orchestrated within the OTP framework, and now how they can interact remotely through the **Node** peer-to-peer abstraction. And again, this is all built-in to the language. No other language come even close.
