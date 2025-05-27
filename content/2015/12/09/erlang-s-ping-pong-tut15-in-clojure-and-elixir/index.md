---
title: Erlang's Ping Pong (tut15) in Clojure and Elixir
date: '2015-12-09T14:42:00-02:00'
slug: erlang-s-ping-pong-tut15-in-clojure-and-elixir
tags:
- learning
- beginner
- elixir
- english
draft: false
---

This is a very short post just because I thought it was fun. I was reading [this very enlightening article](http://blog.paralleluniverse.co/2013/05/02/quasar-pulsar/) on Clojure's Quasar/Pulsar compared to Erlang and how they are trying to plug the holes on the JVM shortcomings.

When you're learning Erlang through its official documentation, the first thing you build in the [chapters on Processes](http://www.erlang.org/doc/getting_started/conc_prog.html#id67347) is a very simple Ping Pong code that looks like this:

```erlang
-module(tut15).

-export([start/0, ping/2, pong/0]).

ping(0, Pong_PID) ->
    Pong_PID ! finished,
    io:format("ping finished~n", []);

ping(N, Pong_PID) ->
    Pong_PID ! {ping, self()},
    receive
        pong ->
            io:format("Ping received pong~n", [])
    end,
    ping(N - 1, Pong_PID).

pong() ->
    receive
        finished ->
            io:format("Pong finished~n", []);
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,
            pong()
    end.

start() ->
    Pong_PID = spawn(tut15, pong, []),
    spawn(tut15, ping, [3, Pong_PID]).
```

It's not pretty, it's Prolog-ish. The Clojure article claims how close they got with lightweight threads (true green threads) and this is the same exercise done in Clojure:

```lisp
(defsfn pong []
 (if (== n 0)
    (do
      (! :pong :finished)
      (println "ping finished"))
    (do
      (! :pong [:ping @self])
      (receive
       :pong (println "Ping received pong"))
      (recur (dec n)))))

(defsfn pong []
  (receive
   :finished (println "Pong finished")
   [:ping ping] (do
                  (println "Pong received ping")
                  (! ping :pong)
                  (recur))))

(defn -main []
  (register :pong (spawn pong))
  (spawn ping 3)
  :ok)
```

People that like the Lisp-y aesthetics of programming directly in the AST representation through the structure of parenthesis based blocks will find this very pretty.

I personally spent years looking into code like this (Common Lisp, Elisp, Scheme, etc) and I still can't get used to it. Once you have a competent editor such as Emacs, that can deal with the proper parenthesis handling, it's easier, yes, but I still can't find the joy in doing this kind of hackish syntax.

Elixir is not just a new syntax on top of Erlang, as the great book [Metaprogramming Elixir](https://pragprog.com/book/cmelixir/metaprogramming-elixir) will teach you, it opens up the entire Erlang BEAM AST through the usage of the [quote/unquote](http://elixir-lang.org/getting-started/meta/quote-and-unquote.html) mechanics, making programming directly into the AST through ["Hygienic Macros"](http://elixir-lang.org/getting-started/meta/macros.html) a breeze. It's really the best of both worlds of having a modern, good looking, joyful syntax and the same power a Lisp-y language gives you in terms of well behaved macros.

Now, this is the same example as above, in Elixir:

```ruby
defmodule ExPingPongTut15 do
  def ping(0, pong_pid) do
    send pong_pid, :finished
    IO.puts("ping finished")
  end

  def ping(n, pong_pid) do
    send pong_pid, {:ping, self}
    receive do
      :pong -> IO.puts("Ping received pong")
    end
    ping(n - 1, pong_pid)
  end

  def pong do
    receive do
      :finished -> IO.puts("Pong finished")
      {:ping, ping_pid} ->
        IO.puts("Pong received ping")
        send ping_pid, :pong
        pong()
    end
  end

  def start do
    pong_pid = spawn(fn -> pong end)
    spawn(fn -> ping(3, pong_pid) end)
  end
end
```

Because of the power of pattern matching in the functions arguments signature, you can define 2 separated functions, avoiding the "if" as in the Clojure example. Of course, because it's Clojure and it has a complete macro system, and because it's [core.match](https://github.com/clojure/core.match) has the proper pattern matching mechanisms, you can emulate the same thing through external libraries such as [defun](https://github.com/killme2008/defun) though.

This was just a simple exercise, I hope it shed some light on the basic similarities between these 3 languages. And as "ugly" as Erlang may feel, I still feel more comfortable with its quirks then nested parenthesis.
