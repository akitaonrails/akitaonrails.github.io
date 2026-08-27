---
title: 'Off Topic: Why Programmers Should Play Go'
date: '2008-07-15T01:07:00-03:00'
slug: off-topic-por-que-programadores-devem-jogar-go
translationKey: off-topic-por-que-programadores-devem-jogar-go
description: "A Jon Dahl translation: Go has simple rules and near-infinite complexity, and shapes, proverbs, and joseki mirror design patterns, agile principles, and programming exercises."
tags:
- learning
- programming
- gaming
- off-topic
draft: false
---

It's been a while since I did a translation, but this article felt quite nostalgic to me, so I made a point of sharing it. It's by [Jon Dahl](http://web.archive.org/web/20080720152831/http://railspikes.com/2008/7/14/why-programmers-should-play-go) from the **RailSpikes** blog. Read my [notes](#akitas-notes) at the end. Here it is:

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/7/15/2539473895_47418f2049.jpg)](http://flickr.com/photos/andres-colmen/2539473895/)

[Go](http://en.wikipedia.org/wiki/Go_(board_game)) is an ancient strategy game with simple rules and a profound degree of complexity.

Software development is the art of managing complexity using a limited number of rules, structures, and patterns.

Programmers should play Go.


### Go in 2<sup>8</sup> words or less

The beauty of Go is its combination of simplicity and complexity. On the one hand, go has only a handful of rules. Place stones, don't get completely surrounded, control territory. Like chess, the mechanics can be picked up in a few minutes, though Go only has a single type of "move", and only one edge case (the [ko](http://en.wikipedia.org/wiki/Rules_of_Go#Ko_.28no_repetition_of_the_same_shape.29) rule). And like chess, one can spend a lifetime discovering the strategic and tactical layers of the game.

While chess is quite complex and rich, such that it took a 30-node supercomputer to defeat the reining chess champion, no computer comes close to defeating even a skilled amateur Go player. There are 361 positions on a Go board, and with two players, there are 2.08168199382×10<sup>170</sup> valid positions. That's quite a bit bigger than a [googol](http://en.wikipedia.org/wiki/Googol) (yes, that is the correct spelling). Realistically, there are something on the order of 10<sup>400</sup> possible ways that a typical game could play out. And the number of possible moves roughly follows 361!, which means that only 20 moves in, there are many googols of possible ways that the game could shake down. (As a fun exercise, try plugging 361! into an online [factorial calculator](http://web.archive.org/web/20240416232143/https://www.cs.uml.edu/~ytran/factorial.html).)

### Managing complexity

So how does one play Go, given this near-infinite complexity? On a tactical level, a player approaches Go like chess, thinking several moves ahead. But this only works in small spaces, like a tight battle in a small sector of the board. Beyond there, there are just too many possibilities. So on a strategic level, a player must think in [shapes](http://en.wikipedia.org/wiki/Shape_%28Go%29) or patterns. These shapes provide shorthand ways of managing the complexity of Go. As a non-master, I may have no idea how things will proceed in one sector of the board, but I may be able to recognize strong and weak patterns of stones, vulnerable shapes and effective formations.

But there's more: Go has several sorts of patterns. Beyond shapes, there are [Go proverbs](http://senseis.xmp.net/?GoProverbs). These can be general: _"Your opponent's good move is your good move"_; specific: _"Don't try to cut the one-point jump"_; funny: _"Even a moron connects against a peep"_; and meta: _"Don't follow proverbs blindly."_ These proverbs are principles which help a player make good decisions. They are less specific than shapes, and so they provide guidelines for whatever situations may arise on the Go board. Proverbs often conflict, and a player must determine when and how to apply them.

Finally, there are [joseki](http://en.wikipedia.org/wiki/Joseki). Joseki are patterns of play that are considered even for both sides. They typically happen in the corners of the board, and typically at the beginning of the game. Interestingly, there is a Go proverb that says _"Learning joeski costs two stones,"_ meaning that memorizing these patterns isn't helpful. Instead, a player should learn _from_ joseki by understanding what is going on in each move.

### Patterns in Go, patterns in software design

Each of these Go patterns has a rough programming analogue.

Shapes in Go aren't unlike software [design patterns](http://c2.com/cgi/wiki?DesignPatterns). While there is nothing preventing you from placing logic in your views, this shape is [recognized](http://www.vimeo.com/1050804) to be a weak one. Think of Gang-of-Four design patterns: the MVC, Adapter, and Factory patterns are recognized to be helpful in some circumstances (and not appropriate in others). On a lower level, iteration and recursion have commonly recognized shapes, as do database normalization vs. denormalization. Even if you can't hold an entire program or algorithm in your head at once, recognizing common shapes helps you to understand what is going on.

Go proverbs are like another type of pattern in software: CapitalizedPrinciples (for lack of a better term) made popular by Extreme Programming. Think DontRepeatYourself, YouArentGonnaNeedIt, CollectiveCodeOwnership, DailyBuild, TestFirst. These aren't specific code "shapes", like a singleton class – they are general principles that guide the practice of programming.

Because joseki is about exchange between competing parties, its programming parallel is a little less clear. The closest comparison, in my mind, is programming exercises. [This article](http://binstock.blogspot.com/2008/04/perfecting-oos-small-classes-and-short.html), for instance, suggests 9 exercises to help you become a better OO programmer, like:

- Use only one dot per line
- Use only one level of indentation per method
- Don't use setters, getters, or properties

In a real-world program, you're unlikely to stick to these principles 100% of the time. But forcing yourself to write code in this way can be an eye-opening experience and can make you a better developer.

### So what can Go really do for you?

Obviously, these parallels are structural. Specific Go proverbs ("Your opponent's good move is your good move") may not have direct relevance to software development. So can Go really make you a better developer?

I think it can, and I'll go one further. I think Go can make you smarter. There is a lot of anecdotal evidence to this effect [<sup class="footnote" id="fnr1"><a href="#fn1">1</a></sup>](http://web.archive.org/web/20170616121831/http://www.godiscussions.com/forum/archive/index.php/t-6061.html), [<sup class="footnote" id="fnr2"><a href="#fn2">2</a></sup>](http://news.ycombinator.com/item?id=133178), [<sup class="footnote" id="fnr3"><a href="#fn3">3</a></sup>](http://news.ycombinator.com/item?id=228356), for example, [<sup class="footnote" id="fnr4"><a href="#fn4">4</a></sup>](http://www.china.org.cn/english/features/Archaeology/131298.htm):

> In fact, all of our minds can benefit from playing Go, which officially has the capacity to make you smarter. Research has shown that that children who play Go have the potential for greater intelligence, since it motivates both the right and left sides of the brain.

The research mentioned isn't footnoted, unfortunately, so take statements like this with a grain of salt.

But it makes sense: like chess, Go requires pattern recognition, a mix of strategic and tactical thinking, and comprehension of complex structures, though in Go the patterns are larger and the complexity is greater. A mind trained to think in these ways is going to have an easier time attacking similar problems in other spheres.

Like software development.

### Akita's Notes

I've liked Go for a long time. As someone of Japanese descent, of course I'd been exposed to Go, Shogi, and other oriental games. But, like any good westernized Japanese, I paid very little attention to them. Because of this, today I know no more than the basic rules and philosophies behind Go.

My interest was particularly renewed when I read the [Hikaru no Go](http://en.wikipedia.org/wiki/Hikaru_no_Go) series, which is an entire story built around Go, and one of my favorite series, by the way. I even bought a Go board and some joseki books, but didn't get very far. These days I just peek at online games on the [IGS](https://pandanet-igs.com/) servers.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/7/15/1hikaru800.jpg)](http://web.archive.org/web/20080725154909/http://www.onemanga.com/Hikaru_no_Go/)

I don't remember where I read this, but someone once mentioned something interesting: chess is primarily a game of destruction. Go is essentially a game of conquest and expansion. Not literally true, but there are nuances in Go that bring this to mind.

And in the parallel to software development, design patterns aren't just structures you copy and paste wherever you "think" they're needed. A handful of design patterns doesn't make good software.

What Jon was getting at makes a lot of sense. Just like a Go player, a software developer needs to be an artist. Playing is a creative activity. Strategy is a creative activity. Given a set of constraints, what's the best path forward?

More than that: the only way to learn Go is by playing, hundreds of thousands of times over many, many years. Go professionals are formed around age 10 and climb from there into old age. The only way to learn is by failing, failing, and failing again. Which circles back to what Ryan said about [Hurting Code](http://www.akitaonrails.com/2008/6/14/machucando-c-digo-por-divers-o-e-lucro).

Refactoring is something similar to this: conquest and expansion. Only a good developer understands the real reasons for refactoring. Nobody refactors because someone told them to, just as an artist doesn't make a certain stroke because someone told them to.

A good developer values the form and philosophy of what is being built. Acronyms, brands, and fashionable names say nothing to them.

There's a lack of eastern philosophy in today's programmers. Being a brick-stacking coder is very easy: any grunt can do it. But reaching the [10th dan](http://en.wikipedia.org/wiki/Go_ranks_and_ratings) of programming is only for those who have put in the work in the art.
