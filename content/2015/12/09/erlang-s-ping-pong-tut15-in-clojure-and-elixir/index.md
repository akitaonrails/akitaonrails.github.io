---
title: Ping Pong de Erlang (tut15) em Clojure e Elixir
date: '2015-12-09T14:42:00-02:00'
slug: ping-pong-de-erlang-tut15-em-clojure-e-elixir
translationKey: erlang-ping-pong-tut15
aliases:
- /2015/12/09/erlang-s-ping-pong-tut15-in-clojure-and-elixir/
tags:
- learning
- beginner
- elixir
- traduzido
draft: false
---

Esse vai ser um post bem curto, só porque achei divertido. Eu estava lendo [esse artigo bem esclarecedor](http://blog.paralleluniverse.co/2013/05/02/quasar-pulsar/) sobre o Quasar/Pulsar do Clojure comparado ao Erlang e como eles estão tentando tapar os buracos das limitações da JVM.

Quando você está aprendendo Erlang pela documentação oficial, a primeira coisa que você constrói nos [capítulos sobre Processos](http://www.erlang.org/doc/getting_started/conc_prog.html#id67347) é um código bem simples de Ping Pong que se parece com isso:

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

Não é bonito, tem cara de Prolog. O artigo sobre Clojure afirma o quão perto eles chegaram com lightweight threads (green threads de verdade) e esse é o mesmo exercício feito em Clojure:

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

Quem curte a estética Lisp de programar diretamente na representação da AST através da estrutura de blocos baseados em parênteses vai achar isso muito bonito.

Eu particularmente passei anos olhando para código desse tipo (Common Lisp, Elisp, Scheme, etc) e ainda não consigo me acostumar. Quando você tem um editor competente como o Emacs, que lida com o casamento adequado de parênteses, fica mais fácil, sim, mas eu ainda não consigo achar graça nesse tipo de sintaxe meio hackeada.

Elixir vai muito além de só uma sintaxe nova em cima de Erlang, como o ótimo livro [Metaprogramming Elixir](https://pragprog.com/book/cmelixir/metaprogramming-elixir) vai te ensinar. Ele abre toda a AST da BEAM do Erlang através do mecanismo de [quote/unquote](http://elixir-lang.org/getting-started/meta/quote-and-unquote.html), tornando a programação direta na AST através de ["Macros Higiênicas"](http://elixir-lang.org/getting-started/meta/macros.html) algo trivial. Você ganha o melhor dos dois mundos: uma sintaxe moderna, bonita e prazerosa, junto com o mesmo poder que uma linguagem Lisp te dá em termos de macros bem comportadas.

Agora, esse é o mesmo exemplo acima, em Elixir:

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

Por causa do poder do pattern matching na assinatura dos argumentos das funções, dá pra definir 2 funções separadas, evitando o "if" como no exemplo em Clojure. Claro, como é Clojure e tem um sistema completo de macros, e como o [core.match](https://github.com/clojure/core.match) tem mecanismos adequados de pattern matching, dá pra emular a mesma coisa através de bibliotecas externas como o [defun](https://github.com/killme2008/defun).

Esse foi só um exercício simples, espero que tenha jogado alguma luz nas semelhanças básicas entre essas 3 linguagens. E por mais "feio" que o Erlang possa parecer, eu ainda me sinto mais confortável com as suas esquisitices do que com parênteses aninhados.
