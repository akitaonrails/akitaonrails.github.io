---
title: Personal Thoughts on the Current Functional Programming Bandwagon
date: '2015-10-28T17:14:00-02:00'
slug: personal-thoughts-on-the-current-functional-programming-bandwagon
tags:
- learning
- career
- elixir
- english
draft: false
---

Today, Git is unanimously the only best way to manage source code. Back in 2009, when it was still gaining traction, there were some detractors. Some would say that they wouldn't use Git because it was written in C, instead of C++. To that, Linus Torvalds famously [retorted](http://article.gmane.org/gmane.comp.version-control.git/57918):

<blockquote>
*YOU* are full of bullshit.
</blockquote>

<blockquote>
C++ is a horrible language. It's made more horrible by the fact that a lot 
of substandard programmers use it, to the point where it's much much 
easier to generate total and utter crap with it. Quite frankly, even if 
the choice of C were to do *nothing* but keep the C++ programmers out, 
that in itself would be a huge reason to use C.
</blockquote>

To this day, [many still try to reason against Linus' arguments](http://insights.dice.com/2015/03/10/linus-torvalds-was-sorta-wrong-about-c/?CMPID=AF_SD_UP_JS_AV_OG_DNA_). I am of the opinion that one of the reasons Git and the Linux kernel are good is exactly because of the choice of C (and, for better or worse, the bullying culture of their benefactor dictator, Linus).

Languages have features, they have ancestors, they are imbued with some sense of philosophy and purpose. Because of that it's easy to see why young people choose languages in an attempt to fit in to some group. It's not so much because a language has some style of syntax or because it's insanely fast or because it's elegantly implemented.

Some people like Google and feel more compelled to justify their choice of Go. Some people like Apple and feel more compelled to justify their choice of Swift or Objective-C. Some people are naturally more academic, and don't feel so much the need to justify their choice of Haskell - which, by the way, has an [unofficial motto](https://www.quora.com/Why-dont-more-programmers-use-Haskell) of _"Avoid success at any costs."_

In particular, young programmers feel the need to justify their choices using some sort of logical reasoning. Trying to explain language choices because of features is a **fallacy**. You don't need to explain why you listen to Bruno Mars, if you like him just do. You don't need to explain why you eat Thai food, if you like it just do.

Which is why, most blog posts and articles trying to justify the choice of a language or tool are very unreliable: because they can't escape being biased. There is no logical reasoning that can unambiguously define one language as the winner over other languages. Any language that is in use today has applications, some more than others, of course.

Easier said then done, I know. Bear with me.

Each new generation struggles to find **identity**, they have the need to not just follow what the previous generation left behind.

And we, programmers, are naturally averse to "legacy" anyway. It's in our DNA to try to rewrite history every time. It's easy to write new stuff, it's very difficult to make something that lasts. Because of that, many of us go back to the longer past in order to justify our new choices as "rediscoveries". It may be one reason the Lisp people are so persistent.

## The Hype

1. You don't only have a dozen languages to fight against if you're a language extremist. You have [hundreds](https://en.wikipedia.org/wiki/List_of_programming_languages).

2. There are not only imperative, object-oriented, funcional paradigms in programming. There are [many more paradigms](https://en.wikipedia.org/wiki/Comparison_of_programming_paradigms).

3. It's rare to have a language that implements only one paradigm, most languages are multi-paradigm.

4. Functional paradigm - the current new kid on the block - is not the best. It's just another paradigm. Electing one over the other is denying a long history of computer science research and achievements.

Why the current trend in functional languages? Because it is a departure from the previous generation, very compelling for new folk trying to make a dent in history.

It makes you feel special to be able to discuss about [functional purity](https://en.wikipedia.org/wiki/Purely_functional), [monad vs unique type](http://lambda-the-ultimate.org/node/1180), and other oddities. That's all there is to most of the discussions.

* You have the credibility track of a [Paul Graham's essays](http://www.paulgraham.com/lisp.html).
* You have the coincidental choice of Javascript gaining sudden traction and having some [functional aspects](http://www.sitepoint.com/introduction-functional-javascript/).
* You start realizing that managing mutable state generates a lot of hassles and make parallel programming difficult and then realize that some functional languages offer [immutable state](http://miles.no/blogg/why-care-about-functional-programming-part-1-immutability) and that triggers an epiphany.
* You hear stories, [Bank Simple using some Clojure](https://www.quora.com/What-languages-and-frameworks-is-Simple-built-with), a Clojure-based machine learning startup, [Prismatic, getting a hefty Series A](https://www.crunchbase.com/organization/prismatic#/entity), or the amazing story of the small Erlang-based startup, [Whatsapp, being bought by USD 19 billion](http://highscalability.com/blog/2014/2/26/the-whatsapp-architecture-facebook-bought-for-19-billion.html). How can you not pay attention?

## Some Benefits

The functional style of programming, of dealing with the transformation pipeline of immutable things without shared state, do actually improve our way of thinking about problem resolutions. But so does any other programming paradigm. Declarative programming, for example, where you define computation logic without defining a detailed control flow leading to SQL, regular expressions. 

There are indeed benefits of so many discussions around functional programming. At the very least the new generation is getting the chance to grasp **old** and really useful concepts such as:

* [First Class Functions](http://c2.com/cgi/wiki?FirstClass) - when there is no restrictions on how a function can be created and used.
* [Higher Order Functions](http://c2.com/cgi/wiki?HigherOrderFunction) - a function that can take a function as an argument and return functions.
* [Lexical Closures](http://c2.com/cgi/wiki?LexicalClosure) or just Closures - the definition is bit difficult but it's usually there when you can define a function within a function.
* Single Assignment (from which you can have Immutability) - when a variable is assigned once, at most.
* [Lazy Evaluation](https://en.wikipedia.org/wiki/Lazy_evaluation) - when execution is deferred until really necessary.
* [Tail Call Optimization](http://c2.com/cgi/wiki?TailCallOptimization) (Tail Recursion) - in practice, if the last expression of a recursive function is itself, it can just jump back to the beginning instead of creating a new stack frame overhead.
* [List Comprehensions](http://c2.com/cgi/wiki?ListComprehension) - creating lists based on existing lists. Python programmers are more acquainted with the term, at least.
* [Type Inference](http://c2.com/cgi/wiki?TypeInference) (Hindley-Milner Type System) - in practice it allow you to write code without having to declare static types all the time and leave it to the compiler to infer the correct types. Gives the best of both dynamic and static world.
* [Pattern Matching](http://c2.com/cgi/wiki?PatternMatching) - dispatching mechanism to choose between variants of a function (which is also important for Logic Programming and to differentiate between declarative and imperative paradigms)
* [Monadic Effects](http://bit.ly/1WjbXuS) - now, this is one of the most difficult concepts to really understand.

Dynamic languages such as Ruby, Python, Javascript already made us comfortable with the notions of first class functions, higher order functions, closures, list comprehensions. Existing languages such as Java and C# have been deploying some of those features such as closures, comprehensions.

Type Inference has been quickly gaining adoption since at least 2004 when Scala, Groovy, F# brought it to mainstream discussion. Then C# 3.0+ adopted it, now Rust, Swift were designed with it in mind.

We are used to String Patterns because of Regular Expressions, but the Pattern Matching paradigm feels alien at first. Erlang is probably the most recognizable language that uses it, and now Elixir and Rust sport this feature and you should start to paying attention.

There are many more concepts but the list above should be a fair enough list. But out of all of them the most difficult to wrap one's head around is Monads. A Monad can be defined as a functional design pattern to describe a computation as a sequence of steps.

Pure functional languages are supposed to not have [side-effects](http://bit.ly/1N8LeAU). This simple statement can spur quite a lot of [heated discussions](http://programmers.stackexchange.com/questions/179982/misconceptions-about-purely-functional-languages). You will come into contact with other concepts such as [referential transparency](https://en.wikipedia.org/w/index.php?title=Referential_transparency&redirect=no) (where you can safely replace an expression with its value). You will probably hear about how purely functional languages wrap side-effects such as I/O consequences using Monads, and that there are several [different kinds of Monads](http://functionaljavascript.blogspot.in/2013/07/monads.html) (Identity, Array, State, Continuation, etc).

Regardless of Haskell Monads and the intricasies of the mathematics behind it, you have probably already bumped into Monads one way or the other. One could argue that [Javascript Promises is a kind of Monad](http://functionaljavascript.blogspot.com.br/2013/04/the-promise-monad-in-javascript.html). And you also have [ML inspired Option Types](https://en.wikipedia.org/wiki/Option_type) which are of the same family of Haskell's Maybe Monads.

Rust is all built around the [Option Monad](http://hoverbear.org/2014/08/12/option-monads-in-rust/) (also known as Maybe Monad, from Haskell, but the ML language came before and named this pattern as 'Option'). Even Java 8 recently obtained this new feature and named it [Optional](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html). In Swift it's also named [Optional](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/OptionalChaining.html). It's the best way we know today to deal with errors, vastly superior than dealing with returning error codes, or (argh), raising exceptions or dealing with Null.

Ruby is known as a multi-paradigm object-oriented and functional language, an amalgam between Smalltalk and Lisp, and the next version 3.0 will probably see the official inclusion of an [optional operand](https://bugs.ruby-lang.org/issues/11537) inspired by the [#try method](http://apidock.com/rails/v4.2.1/Object/try) we already use for safe method chaining. And we might also see [immutable strings](https://bugs.ruby-lang.org/issues/11473), making it easier to write more functional constructs while being more efficient for the garbage collector to boot.

## Conclusion

Functional programming is not the end game for programming paradigms. It's a hell of a good one, and the current needs fit in nicely with the aforementioned techniques. But don't be fooled, we have been scaling very large applications that lasted years with no functional language features. C, C++, COBOL, ADA, have been driving very large systems for decades. Functional is great to have, but it's not utterly necessary if we didn't.

We are in need of transforming large amounts of data points into more useful aggregates, we are in need to reason about those transformations a bit better and be able to execute volumes of small transformations in parallel and in distributed infrastructures. Functional techniques reasoning do help.

Haskell is widely acclaimed as the language that represents the functional programming ideals. But it is meant to be an academic language, a compilation of the best research in the field. It's supposed to not be mainstream, but to give an implementation for those more inclined to dive deeper into the rabbit hole. There were many older languages that preceded it and you could be interested such as [ISWIM](https://en.wikipedia.org/wiki/ISWIM), [Miranda](http://bit.ly/1Gxvnuq), [ML](http://bit.ly/1kSM4GO), [Hope](http://bit.ly/1jRZd2R), [Clean](http://bit.ly/1MUmAzw). Haskell kind of compiles the best of them in one place.

Clojure is [trying to bring those functional concepts](http://stackoverflow.com/questions/6008313/clojure-vs-other-lisps) to the Java world. The Java legacy integration is one of its strength but also the source of its [weaknesses](https://www.quora.com/What-are-the-downsides-of-Clojure). It stil remains to be seen how far it can go.

Elixir is my personal bet as it drives the industrial strength battle tested Erlang to the forefront. It's undeniably a Ruby for the functional world. It's actor model is what inspired what you have today in [Scala/Akka](https://www.quora.com/Go-programming-language/How-are-Akka-actors-are-different-than-Goroutines-and-Channels). Go's goroutines and channels are a close match.

Many other languages are receiving the functional sugar coating these days. Javascript and Ruby have some of the functional features mentioned above. [Java](http://www.infoq.com/articles/How-Functional-is-Java-8) and [C#](https://functionalcsharp.codeplex.com) didn't have functional influences in their inceptions so they are receiving a few features just to remain competitive. But even without being a pure functional language, many of those features have been adapted and implemented in one way or another.

In the near future we will probably have more **hybrid** languages leading the pack. Go, Swift and Rust are good examples of modern and **very young** languages that get inspiration in many different paradigms. They avoid pureness in order to be actually accessible to more developers. Pureness ends up alienating most people. We will find the more mainstream languages somewhere in the middle.

In the meantime, by all means, do dive deeper into the functional programming concepts, they are quite interesting and finally today we can have more practical applications instead of just academic experimentation. But don't try to make a cult out of this, this is not a religion, it's just one small aspect of the computer science field and you will benefit if you incorporate this with other aspects to have a better picture of our field.
