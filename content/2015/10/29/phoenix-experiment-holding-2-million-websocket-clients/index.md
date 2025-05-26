---
title: 'Phoenix Experiment: Holding 2 Million Websocket clients!'
date: '2015-10-29T11:28:00-02:00'
slug: phoenix-experiment-holding-2-million-websocket-clients
tags:
- learning
- elixir
- phoenix
- english
draft: false
---

**Update: 11/04/15** As I said in the article below, Gary Rennie, one of the people doing the experiment finally posted a very detailed account of how they were able to achieve this incredible milestone. Read all about it [here](http://www.phoenixframework.org/v1.0.0/blog/the-road-to-2-million-websocket-connections)

If you still don't follow the Phoenix Framework (Web framework written in Elixir) creator, [Chris McCord](http://twitter.com/chris_mccord), you should. In the last week he has been experimenting how far Phoenix can go. He was able to set up a commodity Rackspace server with 40 cores and 128GB of RAM (although it seems he only needed less than 90GB) and 45 other servers to create an astounding 2 million clients with long running Websocket connections and broadcasting messages to all of them at once!

The thread is very interesting so I decided to compile the most interesting bits directly from his Twitter feed. Take a close look!

Chris or someone from the team will probably [report the details](http://www.phoenixframework.org/v1.0.0/blog/the-road-to-2-million-websocket-connections) about this experiment soon, but because of those testings and benchmarks Phoenix master already got some bottleneck fixes and it is pretty ready for prime time! If you were not aware he is writing a book about Phoenix for The Pragmatic Programmer and I recommend you [buy the beta](https://pragprog.com/book/phoenix/programming-phoenix) as well.

To give some perspective, Websocket connections will probably sit idle and no real app will broadcast to all users at once all the time, this experiment is trying to exercise the most out of the metal. One comparison would be this [Node.js experiment](http://www.jayway.com/2015/04/13/600k-concurrent-websocket-connections-on-aws-using-node-js/) holding 600k connections in a small machine but CPU load going up faster. Apples to Oranges comparison, but just to keep perspective.

### 10/20/15

josevalim: 128k users connected. @chris_mccord broadcasts a message to all in the channel, @TheGazler receives it immediately on the other side.

chris_mccord: @j2h @josevalim @TheGazler yep! 4 cores, 16 gb memory. Single machine

### 10/21/15

chris_mccord: Heres what a Phoenix app & server look like with 128000 users in the same chatroom. Each msg goes out to 128k users!

<iframe width="420" height="315" src="https://www.youtube.com/embed/vZYG79VqXlM" frameborder="0" allowfullscreen></iframe>

### 10/22/15

chris_mccord: @andrewbrown @josevalim it’s basically this app with some optimizations on [phx master](https://github.com/Gazler/phoenix_chat_example/tree/bench)

### 10/23/15

chris_mccord: We just hit 300k channel clients on our commodity 4core 16gb @Rackspace instance. 10gb mem usage, cpu during active run < 40% #elixirlang

chris_mccord: @chantastic @bcardarella +1 to prag book. My [RailsConf Elixir workshop](http://www.chrismccord.com/blog/2014/05/27/all-aboard-the-elixir-express/) also might be a nice companion to the book

### 10/24/15

chris_mccord: @SkinnyGeek1010 these are 300k individual ws connections (joining a single channel)

chris_mccord: Calling it quits trying to max Channels– at 333k clients. It took maxed ports on 8 servers to push that, 40% mem left. We’re out of servers!

chris_mccord: @bratschecody 300k on a single server, with connections pushed from 8 servers

chris_mccord: To be clear, it was a single 4core server, 16gb. Traffic was pushed from 8 servers to open 333k conns. Out of ports, need more servers

chris_mccord: @perishabledave 30-40% under active load. Once 333k established, idle.

### 10/25/15

chris_mccord: @eqdw I’m sold on EEx. But Phoenix has template engines with 3rd party [haml](https://github.com/chrismccord/phoenix_haml)/[slim](https://github.com/doomspork/phoenix_slim) options

### 10/26/15

bratschecody: Whenever @chris_mccord speaks it's how they've increased clients a single Phoenix server is handling. 128k, 300k, 330k, 450k. DON'T STOP MAN

chris_mccord: @gabiz we also improved our arrival rate by 10x, now reliably establishing conns at 10k conn/s . Next up is reducing conn size

chris_mccord: Consider what this kind of performance in a framework enables. With Pusher you pay $399/mo for 10k conns. This box is $390/mo for 450k conns

chris_mccord: I’m sure comparable hardware on AWS is even cheaper

### 10/27/15

chris_mccord: On a bigger @Rackspace box we just 1 million phoenix channel clients on a single server! Quick screencast in action:

<iframe width="420" height="315" src="https://www.youtube.com/embed/N4Duii6Yog0" frameborder="0" allowfullscreen></iframe>

chris_mccord: @AstonJ accordingly to recent tests, ~ 2 million uses 58GB

chris_mccord: @perishabledave 40core / 128 gb. These runs consumed 38gb, cpu was very under-utilized. Ran out of ports, so spinning up more boxes

chris_mccord: Thanks to @mobileoverlord and @LiveHelpNow , they are spinning up 30 more servers to help us try for 2 million channel clients on one server

chris_mccord: @AstonJ just standard box with ulimit and file descriptors set higher

chris_mccord: @cbjones1 @Rackspace we are, but we using 45 separate servers to open the connections :)

chris_mccord: @cbjones1 @Rackspace 65k ports per remote ip right?

### 10/28/15

chris_mccord: Final results from Phoenix channel benchmarks on 40core/128gb box. 2 million clients, limited by ulimit

![2 Mi conn](https://pbs.twimg.com/media/CSbEsTiW0AARBzf.png)

chris_mccord: The chat app had 2M clients joined to one topic. We sharded pubsub & broadcasts go out in 1-3s. The app is totally snappy at these levels!

chris_mccord: @ashneyderman will publish writeup soon. Only knobs were about a dozen sysctrl/ulimit max files/ports. Stock ubuntu 15.10 otherwise

chris_mccord: One surprising thing with the benchmarks is how well stock ubuntu + dozen max limit options supports millions of conns. No kernel hack req’d

joeerl: @chris_mccord So now you understand why WhatsApp used Erlang :-) - obvious really.

chris_mccord: @lhoguin @felixgallo @joeerl @rvirding I accidentally forgot to set the ulimit higher than 2M, and we’re out of time on the servers now

chris_mccord: @lhoguin @felixgallo @joeerl @rvirding we had 45 tsung clients with capacity to send 2.5M. Every indication says it would’ve been just fine

chris_mccord: @felixgallo @lhoguin @joeerl @rvirding now that we know the gotchas, pretty quick turnaround (few hours with svr setup, coordinating nodes)?

chris_mccord: @felixgallo @lhoguin @joeerl @rvirding @ErlangSolutions devil is in the details tho. We find a bottleneck at 2.25M & spend 48 hours+ fixing

chris_mccord: @mentisdominus it’s a different story when we broadcast to 2M subscribers 

![2M](https://pbs.twimg.com/media/CSdaaHtWcAAMhdJ.png:large)
