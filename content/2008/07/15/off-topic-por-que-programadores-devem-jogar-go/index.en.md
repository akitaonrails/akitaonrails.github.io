---
title: 'Off Topic: Why Programmers Should Play Go'
date: '2008-07-15T01:07:00-03:00'
slug: off-topic-por-que-programadores-devem-jogar-go
tags:
- off-topic
- go
draft: false
---

It's been a while since I did a translation, but this article was quite nostalgic for me, so I made a point of sharing it. It's by [Jon Dahl](http://railspikes.com/2008/7/14/why-programmers-should-play-go) from the **RailSpikes** blog. Read my [notes](#akita_go) at the end. Here it is:

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/7/15/2539473895_47418f2049.jpg)](http://flickr.com/photos/andres-colmen/2539473895/)

[Go](http://en.wikipedia.org/wiki/Go_(board_game)) is an ancient strategy game with simple rules and a profound degree of complexity.

Software development is the art of managing complexity using a limited number of rules, structures, and patterns.

Programmers should play Go.


### Go in 2<sup>8</sup> Words or Less

The beauty of Go is its combination of simplicity and complexity. On one hand, Go has only a few rules. Place the stones, don't be completely surrounded, control the territory. Like chess, the mechanics can be learned in a few minutes, although Go has only a single type of "move" and only one edge case (the [Ko](http://en.wikipedia.org/wiki/Rules_of_Go#Ko_.28no_repetition_of_the_same_shape.29) rule). And like chess, a person can spend a lifetime discovering the game's strategic and tactical layers.

While chess is quite complex and rich — it took a 30-node supercomputer to defeat the chess champion — no computer comes close to defeating even an amateur Go player. There are 361 positions on the Go board and, with two players, there are 2.08168199382×10<sup>170</sup> valid positions. That's a little more than a [googol](http://en.wikipedia.org/wiki/Googol) (yes, that's how it's spelled). Realistically, there are on the order of 10<sup>400</sup> different ways a typical game can be played. And the number of possible moves roughly follows 361! (361 factorial), meaning that with just about 20 moves in, there are many googols of possible ways a game can continue. (As a curiosity, try calculating 361! on an online [factorial calculator](http://www.cs.uml.edu/~ytran/factorial.html).)

### Managing Complexity

So how can a person play Go, given the near-infinite complexity? At a tactical level, a player approaches Go like chess, thinking several moves ahead. But this only works in small spaces, like a tight battle in a small sector of the board. Beyond that, there are too many possibilities. So strategically, a player needs to think in patterns of [shapes](http://en.wikipedia.org/wiki/Shape_%28Go%29). These shapes provide shortcuts for managing Go's complexity. As a non-master, I may have no idea how things will unfold in a sector of the board, but I may be able to recognize strong and weak stone patterns, vulnerable shapes, and effective formations.

But there's more: Go has multiple levels of patterns. Beyond shapes, there are [Go proverbs](http://senseis.xmp.net/?GoProverbs). They can be generalist: _"Your opponent's good move is your good move"_; specific: _"Don't try to cut the one-point jump"_; and meta: _"Don't follow proverbs blindly."_ These proverbs are principles that help a player make good decisions. They're less specific than shapes, and therefore provide guidance for whatever situations might arise on the Go board. Proverbs can conflict, and a player must determine when and how to apply them.

Finally, there is [Joseki](http://en.wikipedia.org/wiki/Joseki). Joseki are patterns of play considered equal for both sides. They typically occur in the corners of the board, typically at the beginning of the game. Interestingly, there is a proverb in Go that says _"Learning joseki costs 2 stones,"_ which may mean that memorizing these patterns is not worthwhile. Instead, a player should learn _from_ joseki by understanding what's happening at each move.

### Patterns in Go, Patterns in Software Design

Each of these Go patterns has, more or less, an analogue in programming.

Shapes in Go are like [design patterns](http://c2.com/cgi/wiki?DesignPatterns) in software. While nothing prevents you from putting logic in your views, that shape is [recognized](http://www.vimeo.com/1050804) as a weak form. Think of Gang-of-Four design patterns: the MVC, Adapter, and Factory patterns are recognized as useful in certain circumstances (and inappropriate in others). At a lower level, iteration and recursion have commonly recognized forms, as does database normalization vs. denormalization. Even if you can't hold an entire program or algorithm in your head at once, recognizing standard shapes helps you understand what's happening.

Go proverbs are like other forms of patterns in software: CapitalizedPrinciples (for lack of a better term) that became popular thanks to Extreme Programming. Think DontRepeatYourself, YouArentGonnaNeedIt, CollectiveCodeOwnership, DailyBuild, TestFirst. They're not "forms" of code like a singleton class — they're general principles that guide programming practice.

As joseki is about equal exchange between competing players, its programming parallel is a bit less clear. The closest comparison, in my mind, is programming exercises. [This article](http://binstock.blogspot.com/2008/04/perfecting-oos-small-classes-and-short.html), for example, suggests 9 exercises to help you become a better OO programmer, such as:

- use only one dot per line
- use only one level of indentation per method
- don't use setters, getters, or properties

In a real program, you won't follow these principles 100% of the time. But forcing yourself to write this way can be an eye-opening experience and can make you a better developer.

### So What Can Go Actually Do for You?

Obviously these parallels are structural. Specifically, Go proverbs may not have direct relevance to software development. So can Go actually make you a better developer?

I think it can, and I'll go further. I think Go can make you smarter. There is a lot of anecdotal evidence of this effect [<sup class="footnote" id="fnr1"><a href="#fn1">1</a></sup>](http://www.godiscussions.com/forum/archive/index.php/t-6061.html), [<sup class="footnote" id="fnr2"><a href="#fn2">2</a></sup>](http://news.ycombinator.com/item?id=133178), [<sup class="footnote" id="fnr3"><a href="#fn3">3</a></sup>](http://news.ycombinator.com/item?id=228356), for example, [<sup class="footnote" id="fnr4"><a href="#fn4">4</a></sup>](http://www.china.org.cn/english/features/Archaeology/131298.htm):

> Indeed, all our minds can benefit from learning go, which has been officially credited with the ability to make you smarter. Research demonstrates that children who play go have the potential for great intelligence, as it stimulates both sides of the brain.

The mentioned research has no bibliography, unfortunately, so don't take this kind of claim at face value.

But it makes a lot of sense: like chess, Go requires pattern recognition, a mix of strategic and tactical thinking, and comprehension of complex structures — although in Go the patterns are larger and far more complex. A mind trained to think this way will find it easier to attack similar problems in other domains.

Like software development.

### Akita's Notes

I've liked Go for a long time. As someone of Japanese descent it's obvious I'd been exposed to Go, Shogi, and other oriental games. But, like any good westernized Japanese-Brazilian, I paid very little attention to them. Because of this, today I know no more than the basic rules and philosophies behind Go.

My interest was particularly renewed when I read the [Hikaru no Go](http://en.wikipedia.org/wiki/Hikaru_no_Go) series, which is an entire story built around Go — one of my favorite manga series, by the way. I even bought a Go board and some Joseki books, but didn't get very far. These days I just glance at online games on the [IGS](http://www.pandanet.co.jp/English/) servers.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/7/15/1hikaru800.jpg)](http://www.onemanga.com/Hikaru_no_Go/)

I don't remember where I read this, but someone once made an interesting observation: chess is primarily a game of destruction. Go is essentially a game of conquest and expansion. That's not literally true, but there are nuances in Go that remind me of it. And in the parallel to software development, design patterns aren't just structures you copy and paste wherever you "think" they're needed. A handful of design patterns doesn't make good software.

What Jon was getting at makes a lot of sense. Just like a Go player, a software developer needs to be an artist. Playing is a creative activity. Strategy is a creative activity. Given a set of constraints, what's the best path forward?

More than that: the only way to learn Go is by playing, hundreds of thousands of times over many, many years. Go professionals start developing around age 10 and move upward from there into old age. The only way to learn is by failing, failing, and failing again. Which brings us back to what Ryan said about [Hurting Code](http://www.akitaonrails.com/2008/6/14/machucando-c-digo-por-divers-o-e-lucro).

Refactoring is something similar to this: conquest and expansion. Only a good developer truly understands the real reasons for refactoring. Nobody refactors because someone told them to, just as an artist doesn't make a certain stroke because someone told them to. A good developer doesn't put stock in acronyms, brands, and fashionable names. They put stock in the form and philosophy of what is being built.

There's a lack of eastern philosophy in today's programmers. Being a brick-stacker coder is easy: any grunt can do it. But reaching the [10th dan](http://en.wikipedia.org/wiki/Go_ranks_and_ratings) of programming is only for those who have put in the work in the art.
