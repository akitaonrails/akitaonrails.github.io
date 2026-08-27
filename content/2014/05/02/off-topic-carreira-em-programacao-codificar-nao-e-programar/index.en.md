---
title: "[Off-Topic] Career in Programming — Coding Isn't Programming"
date: '2014-05-02T15:57:00-03:00'
slug: off-topic-carreira-em-programacao-codificar-nao-e-programar
translationKey: off-topic-carreira-em-programacao-codificar-nao-e-programar
description: "Programming is not just building websites with frameworks. The author argues for studying English, Computer Science, and fundamentals such as algebra, statistics, algorithms, and compilers to create valuable solutions."
tags:
- career
- learning
- computer-science
- off-topic
draft: false
---

A subject I always discuss is the training of programmers. The vast majority of articles you find on the internet today only list "techniques": how to be an assembler, how to take existing pieces and snap them together. There's value in that, but it's a tiny fraction of the "programming" career, not the whole career.

You can take some initial knowledge, say web and HTML, throw in a few frameworks and libraries (Rails, Django, WordPress), and actually put something functional online. But that's little. Very little.

The fact that it's so simple, bordering on trivial, to put "something functional" online hides all the potential in a programming career. Worse, the immediacy of the result creates the illusion that this alone is enough and that any more advanced knowledge is unnecessary.

The result shows up in the growth of technical programming courses and the low demand for Computer Science bachelor's degrees. The fewer people we have working on the fundamentals, at the origin of everything, the more the market decays from here on.

You have a coder job today: Photoshop cutter, HTML assembler, WordPress plugin-sticker. Stop and think about how your career is going to evolve from here. Are you always going to be just an assembler? Are you going to take the easy path and become a half-baked "manager" of assemblers?

In a single post it's impossible to list and explain every important aspect of Computer Science. But I want to try naming at least some of the subjects most people think are unnecessary, just to provoke you into digging further.

## Learn to at least "READ" English fluently

I love the Portuguese language, and it will always be my first language. But pseudo-patriotism and laziness don't change one fact: if you don't commit right now to reading English fluently, you'll live behind, at a sorry level.

The first reason is that in the Western world, everything new comes out in English first. (I'm leaving out the East because I don't read Chinese, and the market there is enormous too.) Waiting for someone to bother translating it costs work and time.

If you rely on the Portuguese version, you'll be reading stale material. And by the time the subject finally grabs you, it may already be obsolete. At that point the gap stops being one step and turns into hundreds of kilometers.

The second reason is that the internet is globalized. It's common to pick up code written in other countries and carry it forward, and it's common for the code you write to be shared with programmers abroad. Do yourself a favor: don't embarrass yourself.

## Religious Wars

Programming is science. It has no horoscope, no guru, no soccer team, no numerology, no astrology. Remember the name: Computer **SCIENCE**. Nobody calls it Computer **Astrology**.

Everyone has subjective tastes. Turning taste into dogma is stupid. The laziness of having to learn something new produces the famous _"I'm good at Clipper, this language will evolve in the future and will always exist, I just have to defend it tooth and nail no matter what comes along later."_

Swap "Clipper" for anything else: Cobol, Basic, Pascal, Algol, Eiffel, Smalltalk, all the way to the newest ones like Java, C#, JavaScript, Python. Something existing today guarantees nothing about tomorrow. Think about how ridiculous whoever said that line must feel now.

Don't play that role. In Science we're not loyal to "teams": we root for whoever is winning and switch the moment they're proven wrong. That's why Science always evolves.

And surprises happen. In the 80s and 90s nobody gave Objective-C a second look; it seemed doomed to failure. Then, in 2007, the iPhone shows up and, surprise, you needed to know Objective-C. Suddenly it became one of the most successful languages of the end of the first decade of the 21st century. Every ten years the market transforms in some way. It's [Bell's Law](http://en.wikipedia.org/wiki/Bell's_law_of_computer_classes).

## Accept It: Your Solutions Today Are Bad

Back to the theme of **"Ignore the Religious Wars"**: how do you figure out what to do? Stick to the principles. Throw out what the gurus say, don't idolize anyone, don't blindly follow anyone. Go down to the fundamental questions and the more obvious direction shows up.

When you know how things work, strip the varnish, pop the hood, take the engine apart, understand the chemistry of combustion, only then do you master the craft. If you barely remember what the hell changing the oil is for, you'll always be a mediocre driver, at best. What's your goal? If it's to be the car's engineer, listening to gurus talk about the color of the steering wheel won't take you far.

Computer Science usually gets ignored because learning Math looks both boring and useless.

Let's run through a few examples. If I ask a beginner how to search for words inside a text, the most obvious things that should come to mind are:

* use substring functions and a loop to scan the text (brute-force solution)
* use a regular expression, or in a database use a "LIKE" (generic solution)
* install a SOLR or Elasticsearch (correct solution in many cases, but "black magic" in terms of understanding)

Most people wouldn't even think of the third solution. And whoever does doesn't know why. What if I told you that, in an absolutely raw and boiled-down way, the solution is to turn the document and the search terms into vectors and compute the relevance between them by [cosine similarity](http://en.wikipedia.org/wiki/Cosine_similarity)? That's exactly what the [Vector Space Model](http://en.wikipedia.org/wiki/Vector_space_model) (VSM) means, which you'll find in several search engines.

<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; height: auto; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'>{{< youtube id="o5nflzfX5tw" >}}</div>

The knowledge behind that is called [**Linear Algebra**](http://en.wikipedia.org/wiki/Linear_algebra). Remember it, from the FIRST year of Computer Science? On this topic I recommend a talk I gave, ["How not to do searches using LIKE"](https://www.eventials.com/akitaonrails/como-nao-fazer-pesquisas-usando-like/).

And when you need to build a process to filter inappropriate content? Most people would think like this:

* create a blacklist of words and keep adding to it as offensive words come to mind. And use the first or second option I listed before to search for those words.

As you can already imagine, the most "obvious" or "simple" answer (given the lack of knowledge) is usually the wrong one, and here it also isn't the most efficient.

Get to know machine learning and one of its simplest forms, the [Naive Bayes Classifier](http://en.wikipedia.org/wiki/Naive_Bayes_classifier). Someone might think _"damn, but this machine learning stuff is way too advanced for the day-to-day."_ Not at all. In fact, any cheap anti-spam filter you find on a free-downloads site uses a classifier.

The idea is that isolated words aren't enough to tell whether content is inappropriate. The way sentences are built, the "tone" of the writing, all of that forms a pattern that can be classified and learned. The more inappropriate content gets classified, the more efficient the algorithm becomes.

If you want to try a simple version [in Ruby, see this blog](http://web.archive.org/web/20140423094927/http://blog.logankoester.com/bayesian-classification-on-rails). If you want to learn about more advanced classifiers, see the [Apache Mahout](https://mahout.apache.org/) project.

{{< youtube id="OhLosjXM-Fg" >}}

And what is that? It's a subject of [**Statistics and Probability**](https://www.khanacademy.org/math/probability). The fundamentals for understanding it are, again, in the FIRST year of Computer Science.

_"Oh, but you're talking about things nobody needs to know. To make websites this is unnecessary."_

A good web framework needs to map routes to the underlying programming (the controllers) efficiently. Ruby on Rails has a routing component called [Journey](https://github.com/rails/journey), which we configure through the "config/routes.rb" file. Below is an excerpt:

```ruby
ImageUploadDemo::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :photos

  authenticated :user do
    root :to => 'photos#index'
  end
  root :to => "photos#index"
  devise_for :users

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  ActiveAdmin.routes(self)
end
```

How hard can this be? What might most people imagine?

* Easy, just make a set of arrays or a hash (dictionary), and when the URL arrives, break the terms with a regular expression and find the controller, passing the parameters to run it.

Let me repeat myself: yes, this works, for very small applications. Anything much bigger than the example above already runs into performance problems.

How about a look at a snippet of the Journey code?

```ruby
class Journey::Parser

token SLASH LITERAL SYMBOL LPAREN RPAREN DOT STAR OR

rule
  expressions
    : expressions expression  { result = Cat.new(val.first, val.last) }
    | expression              { result = val.first }
    | or
    ;
  expression
    : terminal
    | group
    | star
    ;
  group
    : LPAREN expressions RPAREN { result = Group.new(val[1]) }
    ;
  or
    : expressions OR expression { result = Or.new([val.first, val.last]) }
    ;
  star
    : STAR       { result = Star.new(Symbol.new(val.last)) }
    ;
  terminal
    : symbol
    | literal
    | slash
    | dot
    ;
  slash
    : SLASH              { result = Slash.new('/') }
    ;
  symbol
    : SYMBOL             { result = Symbol.new(val.first) }
    ;
  literal
    : LITERAL            { result = Literal.new(val.first) }
  dot
    : DOT                { result = Dot.new(val.first) }
    ;

end
```

In plain English, now **you're screwed**. Part of Journey uses [Racc](https://github.com/tenderlove/racc), a parser generator.

If you made it at least through the SECOND year of Computer Science, then you went through [**Algorithms and Data Structures**](http://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs) and Assemblers. And if you reached the THIRD year, you learned about [**Compilers**](http://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools) (and saw the famous Dragon book). Racc should have reminded you of Yacc, Flex, Bison.

{{< youtube id="QPCC2sbukeo" >}}

To wrap up, you probably think you know what [**Object Orientation**](http://c2.com/cgi/wiki?NobodyAgreesOnWhatOoIs) is, right? I bet you consider your favorite language (whether Java, C#, or JavaScript) object-oriented. If I ask you to define what that means, it's on the tip of your tongue:

* My language supports Encapsulation, Inheritance, and Polymorphism, therefore it's object-oriented.

And what if I told you that procedural, imperative, and functional languages also support encapsulation, inheritance (via delegation or not), and polymorphism? And if that's the case, then [what defines object orientation?](http://c2.com/cgi/wiki?NobodyAgreesOnWhatOoIs)

Whoever got into the subject might remember [Alan Kay](http://en.wikipedia.org/wiki/Alan_Kay), who coined the term "object orientation." But how many stopped to research the Simula 67 language? What did Simula introduce in 1967? Objects, classes, inheritance, subclasses, virtual methods, [coroutines](http://en.wikipedia.org/wiki/Coroutine), discrete event simulation, garbage collection.

And how many have heard of the creators of Simula 67, [Kristen Nygaard](http://en.wikipedia.org/wiki/Kristen_Nygaard) and [Ole-Johan Dahl](http://en.wikipedia.org/wiki/Ole-Johan_Dahl)?

You don't know who they are? I'm sure you don't. Well, let me introduce you to the fathers of object orientation.

## On the Shoulders of Giants

What I mentioned in the previous section is a drop of water on the tip of the iceberg. What matters is for you to realize that everything you think you know is close to nothing. I want you to accept that everything you think you know is either wrong or totally incomplete.

That matters because whoever thinks they already know everything, or close to it, will never learn anything. You need to empty the cup to fill it. (by Bruce Lee)

![Bruce Lee Quote](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/406/big_quote-emptiness-the-starting-point-in-order-to-taste-my-cup-of-water-you-must-first-empty-your-cup-bruce-lee-246247.jpg)

Beyond that, I want you to understand you're not alone. Before you came dozens of great minds. And I'm not talking about those superficial gurus who merely teach techniques and tools. Forget them, everyone will forget them soon too.

Everyone knows who Linus Torvalds, Bill Gates, Steve Jobs, Zuckerberg are. Forget them for now. Stick to the immortals, the names who really made a difference in the history of Computer Science. A few examples:

* [Charles Babbage](http://en.wikipedia.org/wiki/Charles_Babbage)
* [Ada Lovelace](http://en.wikipedia.org/wiki/Ada_Lovelace)
* [George Boole](http://en.wikipedia.org/wiki/George_Boole)
* [Alan Turing](http://en.wikipedia.org/wiki/Alan_Turing)
* [Alonzo Church](http://en.wikipedia.org/wiki/Alonzo_Church)
* [John von Neumann](http://en.wikipedia.org/wiki/John_von_Neumann)
* [John McCarthy](https://en.wikipedia.org/wiki/John_McCarthy_(computer_scientist))
* [Niklaus Wirth](http://en.wikipedia.org/wiki/Niklaus_Wirth)
* [Bertrand Meyer](http://en.wikipedia.org/wiki/Bertrand_Meyer)
* [Dan Ingalls](http://en.wikipedia.org/wiki/Dan_Ingalls)
* [Donald Knuth](http://en.wikipedia.org/wiki/Donald_Knuth)
* [Edsger W. Dijkstra](http://en.wikipedia.org/wiki/Edsger_Dijkstra)

And that's just a sample. Science is a broad field, where one scientist's work complements the previous one's. Step by step, always moving forward. It's a cumulative work of tens, hundreds of years. Our advantage? Hundreds of people already walked this path in the past, and we can use what they learned and left us, instead of making the same mistakes ourselves until we learn on our own.

{{< youtube id="6dME3wgaQpM" >}}

Almost everything you see out there called ["innovation"](http://web.archive.org/web/20140506054007/http://startups.ig.com.br/2013/restricoes-sao-libertadoras-menos-e-mais/) is the rediscovery of things already documented in the past, but that were ahead of their time. It was like that with the mouse: [Douglas Engelbart](http://en.wikipedia.org/wiki/Douglas_Engelbart), who created it in 1968, had to wait sixteen years, until Steve Jobs launched the Macintosh, to see his invention go mainstream. Stop and think: how many discoveries are sitting in the past, just waiting for someone to dig them up and finally make them real?

Want to know about the immortal books of Computer Science? Here are a few:

* [Structure and Interpretation of Computer Programs (SICP)](http://en.wikipedia.org/wiki/Structure_and_Interpretation_of_Computer_Programs)
* [The C Programming Language (K&R)](http://en.wikipedia.org/wiki/The_C_Programming_Language)
* [Algorithms + Data Structures = Programs](http://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs)
* [Compilers: Principles, Techniques and Tools](http://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools), the Dragon book
* [Modern Operating Systems](http://en.wikipedia.org/wiki/Modern_Operating_Systems)
* [Computer Networks](http://en.wikipedia.org/wiki/Computer_network)
* [The Art of Computer Programming](http://en.wikipedia.org/wiki/The_Art_of_Computer_Programming), which even I haven't read, and I don't know anyone who has read and understood it, but I'll leave it here because of its importance.

[Don't want to go to college?](http://www.akitaonrails.com/en/2009/04/17/off-topic-devo-fazer-faculdade) No problem, try to follow the material MIT makes available online on [Electrical Engineering and Computer Science](http://web.archive.org/web/20140430225124/http://ocw.mit.edu/courses/). If you're still a complete amateur even in the programming world, see this introductory Computer Science course on [Coursera](http://web.archive.org/web/20140517025706/https://www.coursera.org/course/cs101).

Note that I'm not citing in this article any of the names many might expect, like Martin Fowler, Bruce Eckel, Robert Martin, Michael Feathers, Kent Beck, Steve McConnell, Tom DeMarco, Dave Thomas. Forget them for now. Without the earlier ones, these make little difference.

Don't put the cart before the horse. Go one step at a time.

## Career in Programming

One thing I always repeat is this:

<blockquote>"Programming isn't writing any code, the same way cooking isn't throwing any ingredient into a pan."</blockquote>

Understand: writing code is very simple. Anyone with the minimum motor coordination not to try shoving a square peg through a round hole, or who has at least stacked one Lego brick on top of another, is capable of writing code. There's no merit in it at all.

Downloading a Twitter Bootstrap, using a Yeoman generator, installing MySQL on Ubuntu, copying and pasting a jQuery snippet: anyone can do it.

In career terms, what "anyone" can do is a mere ["commodity"](http://en.wikipedia.org/wiki/Commodity). Being a commodity means the value the market is willing to pay will only drop. Every so often some novelty shows up trying to create a differentiation (_"look, Angular JS,"_ _"look, HTML 5"_), but it quickly dissolves into the downward trend in value.

Value lives in the creativity of the solution: extracting the greatest result for the lowest cost. And creativity only exists when you master all the elements around you. When one hour of work swaps an idiotic word-search algorithm for a vector space model, cuts your fleet from ten machines to two, and answers your user in a fifth of the time, that's applied knowledge. And knowledge like that has value, and it grows.

A full toolbox makes you a "jack-of-all-trades with many tools." The engineer or architect capable of building the next World Trade Center or Freedom Tower is a different thing.

But, like everyone who wants to grow, we all start as jacks-of-all-trades. There's nothing wrong with that. Just don't fool yourself into thinking that a box with more tools turns you into anything different from that.
