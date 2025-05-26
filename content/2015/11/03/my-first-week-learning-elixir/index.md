---
title: My first week learning Elixir
date: '2015-11-03T11:07:00-02:00'
slug: my-first-week-learning-elixir
tags:
- beginner
- learning
- elixir
- english
draft: false
---

I set myself to try to learn enough Elixir to be comfortable tackling some small projects. After 1 entire week studying close to 6 hours a day (around 42 hours) I'm still not entirely comfortable but I think the main concepts were able to sink in and I can fully appreciate what Elixir has to offer.

This is not my first time touching Erlang though. I was fortunate enough to be able to participate in a small workshop at QCon San Francisco 2009 with no other than [Francesco Cesarini](http://www.oreilly.com/pub/au/3373). Thanks to him I was able to understand some of Erlang's exquisite syntax, the correct concept of Erlang processes, how immutability and pattern matching governs their programming flow. It was very enlightening. Unfortunately I couldn't see myself doing Erlang full time. I just hoped those mechanisms were available in a language such as Ruby ...

Between 2007 and 2009 Erlang had a new renaissance between the languages aficionados because of the ["Programming Erlang"](https://pragprog.com/book/jaerlang/programming-erlang) book released by The Pragmatic Programmers, written by no other than Joe Armstrong himself, the Erlang's creator. Dave Thomas [tried to push Erlang](http://pragdave.me/blog/2007/04/15/a-first-erlang-program/) a lot in 2007, but even he wasn't able to sell Erlang's powerful engine because of the strange presentation of the syntax.

After 2009, José Valim had a long run to release the controversial Rails 3.0 big rewrite (which was fortunately a success) and he decided to step aside and try something else. His own research led him to Erlang for the reasons I mentioned above, but he decided that he could solve the "quirk syntax" problem. You can see some of this very first talks about Elixir in the Rubyconf Brasil [2012](https://www.eventials.com/locaweb/jose-valim-vamos-falar-sobre-concorrencia/) and [2013](https://www.eventials.com/locaweb/elixir-uma-aproximacao-pragmatica-e-concorrente-a-programacao/) recordings. The very early beta was released in 2012 and he finally released the stable 1.0 in 2015. Chris McCord was able to release Phoenix stable soon after.

When I first heard about this, Elixir found its place under my radar. I didn't jump right in though, between 2009 and 2015 we had a surge in "functional programming" interest because of the Javascript renaissance, the release of Scala, Go Lang, Clojure, the promise of Rust, and so on. So I waited, carefully following every one of them.

Then, 2014 came and suddenly everybody else found out about Erlang, with their spartan infrastructure that enabled Whatsapp to serve half a billion users with absurdly low costs and made Facebook buy them for a hefty USD 19 billion! We all knew about the Whatsapp case since at least 2011 but it was not until 2014 that everybody noticed. But not even this was able to steer Erlang to the fore front just yet.

When Elixir stable was released this year, followed by Phoenix stable, I knew it was time for me to start investing some quality time with it. Erlang's core sell itself: everybody else is doing concurrency by means of immutability and lightweight threads (or green threads, NxM strategy between green threads and real threads). It is actually quite trivial to max out the machine just shooting up millions of light processes nowadays. What makes it difficult is to create a system that has the potential to actually achieve [99.9999999% reliability](http://stackoverflow.com/questions/8426897/erlangs-99-9999999-nine-nines-reliability). Spawning processes is easy, how do you coordinate them in the same machine? How do do you coordinate them between different machines? How do you update a living system without bringing it down? How do you handle failures? How to you supervise everything?

These are the questions that Erlang solved decades ago ([20 years ago](http://www.erlang.org/download/armstrong_thesis_2003.pdf)) with the now famous OTP, Ericsson's Open Telecom Platform. Something that was created to meet the performance and reliability needs of telecommunications in large scales. When we say it like this it feels that it will be a royal pain to learn, something akin to the JEE (Java Enterprise Edition), but worse.

And I can tell you that to learn enough OTP to be productive is actually **very** easy (you won't achieve the legendary 99.9999999% reliability out of the blue, but you'll be able to build something reliable enough). Think of it as a collection of half a dozen modules, with a couple of function interfaces to implement, a few words of configuration and you're basically done. It's so easy and lightweight that in fact many small libraries are written with OTP in mind and it's easy to just "plug and play". It's not a heavyweight server-side only thing.

To harness that power you will need to learn Elixir, unofficially, a language that has an uncanny resemblance to Ruby, built to spill out Erlang bytecode for its BEAM virtual machine. You can't find a better combination.

### One Week

Having said all that, let's cut to the chase. You definitely want to get acquainted with the Functional Programming concepts such as immutability, higher order functions, pattern matching. I made a list of links for those concepts in [my previous post](http://www.akitaonrails.com/2015/10/28/personal-thoughts-on-the-current-functional-programming-bandwagon), I recommend you read it.

Assuming you're already a programmer in a dynamic language (Ruby, Python, Javascript, etc) and you want the fast crash course. Start buying ["Programming Elixir"](https://pragprog.com/book/elixir/programming-elixir) by Dave Thomas and actually do each piece of code and the exercises in order. It's a book so easy to read that you will be able to finish it in less than a week. I did it in 3 days. The Elixir-Lang official website has a [very good documentation](http://elixir-lang.org/getting-started/introduction.html) as well and they link many [good books](http://elixir-lang.org/learning.html) you want to read later.

Then subscribe to Josh Adam's [Elixir Sips](http://elixirsips.com). If you're a Rubyist, it's like watching Ryan Bates Railscasts from the beginning all over again. Although it's more akin to Avdi Grimm's RubyTapas show, with very short episodes just for you to have your weekly fix on Elixir.

You can watch some of the episodes for free in low resolution, but I highly recommend you subscribe and watch the HD versions. It's well worth it. But about the episodes, there are more than 200 episodes. I've watched more than 130 in 12 hours :-) So I figure I would take another 2 days to watch everything. 

You should definitely watch everything if you can, but if you can't, let me list the ones I think are the essentials. First of all, keep in mind that Josh has been doing this for quite a while, when he started Elixir was version 0.13 or below and Erlang was version 17 or below.

For example, episode [171 - Erlang 18 and time](https://elixirsips.dpdcart.com/subscriber/post?id=815) highlights the new Time API. You must know about this. Episode [056 - Migrating Records to Maps](https://elixirsips.dpdcart.com/subscriber/post?id=460) shows a new feature in Erlang 17 and Elixir where it makes Maps more preferable than the previous Records. Maps are explained in episodes [054](https://elixirsips.dpdcart.com/subscriber/post?id=453) and [055](https://elixirsips.dpdcart.com/subscriber/post?id=454). If you learn the Phoenix web framework, it used the ORM Ecto underneath and Ecto models are Maps, so you must know this.

It means that the first 180 episodes, at least, are using previous versions of Erlang, Elixir, Phoenix, etc and you must keep in mind that new versions will have different APIs. This was one of the reasons I waited for the stable releases, because it was only natural that projects evolve and take time to have stable APIs and chasing several moving targets is really difficult for the uninitiated.

Having said that, watch this list first:

* 001 - Introduction and Installing Elixir.mp4
* 002 - Basic Elixir.mp4
* 003 - Pattern Matching.mp4
* 004 - Functions.mp4
* 005 - Mix and Modules.mp4
* 006 - Unit Testing.mp4
* 010 - List Comprehensions.mp4
* 011 - Records.mp4
* 012 - Processes.mp4
* 013 - Processes, Part 2.mp4
* 014 - OTP Part 1_ Servers.mp4
* 015 - OTP Part 2_ Finite State Machines.mp4
* 016 - Pipe Operator.mp4
* 017 - Enum, Part 1.mp4
* 018 - Enum, Part 2.mp4
* 019 - Enum, Part 3.mp4
* 020 - OTP, Part 3 - GenEvent.mp4
* 022 - OTP, Part 4_ Supervisors.mp4
* 023 - OTP, Part 5_ Supervisors and Persistent State.mp4
* 024 - Ecto, Part 1.mp4
* 025 - Ecto, Part 2_ Dwitter.mp4
* 026 - Dict, Part 1.mp4
* 027 - Dict, Part 2.mp4
* 028 - Parsing XML.mp4
* 031 - TCP Servers.mp4
* 032 - Command Line Scripts.mp4
* 033 - Pry.mp4
* 041 - File, Part 1.mp4
* 042 - File, Part 2.mp4
* 044 - Distribution
* 045 - Distribution, Part 2
* 054 - Maps, Part 1.mp4
* 055 - Maps, Part 2_ Structs.mp4
* 056 - Migrating Records To Maps.mp4
* 059 - Custom Mix Tasks.mp4
* 060 - New Style Comprehensions.mp4
* 061 - Plug.mp4
* 063 - Tracing.mp4
* 065 - SSH.mp4
* 066 - Plug.Static.mp4
* 067 - Deploying to Heroku.mp4
* 068 - Port.mp4
* 069 - Observer.mp4
* 070 - Hex.mp4
* 073 - Process Dictionaries.mp4
* 074 - ETS.mp4
* 075 - DETS.mp4
* 076 - Streams.mp4
* 077 - Exceptions and Errors.mp4
* 078 - Agents.mp4
* 079 - Tasks.mp4
* 081 - EEx.mp4
* 082 - Protocols.mp4
* 083 - pg2.mp4
* 086 - put_in and get_in.mp4
* 090 - Websockets Terminal.mp4
* 091 - Test Coverage.mp4
* 106 - Text Parsing.mp4
* 109 - Socket.mp4
* 112 - Benchfella.mp4
* 113 - Monitoring Network Traffic.mp4
* 124 - Typespecs.mp4
* 125 - Dialyzer.mp4
* 126 - Piping Into Elixir.mp4
* 127 - SSH Client Commands.mp4
* 131 - ExProf.mp4
* 132 - Randomness in the Erlang VM.mp4
* 135 - Benchwarmer.mp4
* 138 - Monitors and Links.mp4
* 139 - hexdocs.mp4
* 141 - Set.mp4
* 142 - escript.mp4
* 144 - Erlang's `calendar` module.mp4
* 145 - good_times.mp4
* 153 - Phoenix APIs and CORS.mp4
* 155 - OAuth2_ Code Spelunking.mp4
* 156 - Interacting with Amazon's APIs with erlcloud.mp4
* 157 - Playing with the Code Module Part 1 - eval_string.mp4
* 159 - Simple One for One Supervisors.mp4
* 160 - MultiDef.mp4
* 171 - Erlang 18 and Time.mp4
* 172 - Arc File Uploads.mp4
* 174 - ElixirFriends_ Saving Tweets with Streams and Filters.mp4
* 175 - Pagination with Ecto and Phoenix using Scrivener.mp4
* 176 - Prettying Up ElixirFriends.mp4
* 178 - Memory Leaks.mp4
* 179 - Rules Engine.mp4
* 180 - Collectable.mp4
* 182 - Phoenix API.mp4
* 183 - React with Phoenix.mp4
* 184 - React with Phoenix Channels.mp4
* 185 - Mix Archives.mp4
* 186 - Automatically Connecting Nodes.mp4
* 187 - Compiling a Custom AST Into Elixir Functions.mp4
* 190 - Testing Phoenix Channels.mp4
* 193 - Linting with Dogma.mp4
* 194 - Interoperability_ Ports.mp4
* 196 - Crashing the BEAM.mp4
* 200 - Custom Types in Ecto.mp4
* 201 - Tracing and Debugging with erlyberly.mp4
* 202 - Exception Monitoring with Honeybadger.io.mp4
* 203 - plug_auth.mp4
* 204 - Behaviours.mp4

This is roughly half of what's available in Elixir Sips. All the other episodes are also interesting, but if you're just getting started, this list should be enough to wet your fingers in the language.

Railers will enjoy Phoenix and the ecosystem that is growing around it. You can already authenticate through [OAuth2](https://github.com/scrogson/oauth2), do pagination will_paginate style with [Scrivener](https://github.com/drewolson/scrivener), file uploads carrierwave style with [Arc](https://github.com/stavro/arc), deploy to [Heroku](http://wsmoak.net/2015/07/05/phoenix-on-heroku.html).

For more exercises, you can easily connect to HTTP endpoints using [HTTPoison](https://github.com/edgurgel/httpoison), parse HTML with [Floki](https://github.com/philss/floki), parse JSON with [Poison](https://github.com/devinus/poison). For more libraries, you can follow this Github page called [Awesome Elixir](https://github.com/h4cc/awesome-elixir) which lists many new Elixir packages that you can use. But make sure you walk yourself through the basic concepts first. Elixir has a Rake-like task management system with built-in Mix, you can add dependencies in a Gemfile-like file called Mix.exs, which every projects has. You can add dependencies through Github urls or from [Hex.pm](https://hex.pm) which is like Rubygems.org.

In this learning process, the concepts that I find more important to learn first are:

* Elixir basic syntax and concepts (pattern matching, loops through recursion, immutable state, primitive types including Maps, the pipe operator)
* The concept of processes, nodes, and intercommunication between processes and nodes, including Monitors and Links.
* OTP Basics, learn what GenServer, GenEvent, GenFSM are.

After you learn that you can figure out how to build OTP applications and do something practical for the Web using Phoenix, particularly you will want to learn everything about Phoenix's Channels, the infrastructure for robust, fast and [highly concurrent](http://www.akitaonrails.com/2015/10/29/phoenix-experiment-holding-2-million-websocket-clients) WebSockets.

This is it. This is my first week learning Elixir, and my next step is to train myself by doing more exercises and also learning more about Phoenix. Even though Phoenix is inspired by Rails, it is not a clone, it has its own set of unique concepts to learn and this is definitely going to be a very interesting ride.

If you have more tips and tricks for beginners, feel free to comment below.
