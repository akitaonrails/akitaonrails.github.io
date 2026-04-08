---
title: "[Off-Topic] Career in Programming — Coding Isn't Programming"
date: '2014-05-02T15:57:00-03:00'
slug: off-topic-carreira-em-programacao-codificar-nao-e-programar
tags:
- off-topic
- career
- insights
draft: false
---

A subject I always discuss is the training of programmers. The vast majority (if not all) of the articles you find on the internet today only list "techniques," or "how to be an assembler," "how to take existing pieces and put them together." Although there's a lot of value in that, let's be very clear that this doesn't constitute the entire career of "programming" — only a tiny fraction.

You can always take some initial knowledge, for example, web and HTML, add a few frameworks and libraries (Rails, Django, Wordpress) and actually put something functional online. But that's little, very little.

The fact that it's so "simple," bordering on trivial, to put "something functional" online hides all the potential that exists in a programming career. Worse than that, the immediacy of getting a result leads to the illusion that this alone is enough and that any more "advanced" knowledge is completely unnecessary. The reflection of this is the growth of technical programming courses and the low adherence to Computer Science bachelor's courses. That's terrible because the fewer people we have working on the fundamentals, at the origin of everything, the more decayed the market becomes from here on.

Just because you right now have a job as a coder (Photoshop cutter, HTML assembler, Wordpress plugin-sticker, etc.), stop to think about how your career will evolve from here. Are you always going to be just an assembler? Are you going to take the easy path of becoming a half-baked "manager" of assemblers?

Unfortunately, in a single post, it's impossible to list and explain all the important aspects of Computer Science. But I want to try to list at least some of the subjects that most people think unnecessary, to provoke you to seek more.

## Learn to at least "READ" English fluently

Sorry, I love the Portuguese language — it will always be my first language. But pseudo-patriotism or pure laziness won't eliminate the fact that if you don't dedicate yourself from now on to being fluent at reading English, you'll always be deficient at a lamentable level.

The first reason is that in the Western world (I'm excluding what happens in the East, because I don't read Chinese and the market there is also enormous), everything new that comes out comes out first in English. If you're going to wait for someone to take an interest in translating it, think about the work that involves and the time it takes. You'll necessarily be seeing outdated material if you wait for it to come out in Portuguese. And when you start to be interested in the material it may already even be obsolete. You won't be one step behind — you'll be hundreds of kilometers behind.

The second reason is that the internet world is globalized. It's not uncommon to take code made in other countries to continue from, and it's not uncommon for the code you make to have to be shared with programmers from other countries. Do yourself a favor: don't embarrass yourself.

## Religious Wars

Programming isn't a soccer team, nor numerology, nor astrology. It has no horoscope, it has no guru. Remember, this is called Computer **SCIENCE**, not Computer **Astrology**.

Everyone has subjective tastes — it's just stupid to turn taste into dogma. The laziness of having to learn something new produces the famous _"I'm good at Clipper, this language will evolve in the future and always exist — I just have to defend it tooth and nail no matter what comes up afterward."_

Replace "Clipper" with anything else, from Cobol, Basic, Pascal, Algol, Eiffel, Smalltalk, etc., up to the most recent, Java, C#, JavaScript, Python, etc. Just because something exists today there is absolutely no guarantee it will continue to exist. Think how ridiculous someone who said the above phrase must be feeling now. Don't play that role. In Science we're not loyal to "teams" — we always root for whoever is winning and switch as soon as they're proven wrong. That's why Science always evolves.

And surprises happen. During the 80s and 90s nobody paid attention to Objective-C. It was doomed to failure. Out of nowhere, in 2007, the iPhone comes out and — surprise, you need to know Objective-C. Suddenly it becomes one of the most successful languages of the end of the first decade of the 21st century. Every 10 years the market transforms itself in some way. [Bell's Law](http://en.wikipedia.org/wiki/Bell's_law_of_computer_classes).

## Accept: Your Solutions Today Are Bad

Continuing the theme of **"Ignore the Religious Wars,"** how do you understand what to do? Stick to the principles. Throw out what the gurus say, don't idolize anyone, and don't blindly follow what someone says — go down to the fundamental questions and you'll find a more obvious direction.

When you know how things work, strip away the varnish, open the hood, disassemble the engine, understand the chemistry of combustion, only then will you be able to master the art. If you barely remember what the hell changing the oil is for, you'll always just be a mediocre driver, at best. What's your goal? Is it to be the car's engineer? Because if it is, simply listening to gurus talking about the color of the steering wheel won't take you very far.

Computer Science is usually ignored because it seems learning Math isn't only boring but useless.

Let's give some examples. If I ask a beginner how to search for words inside a text, the most obvious things that should come to mind are:

* use substring functions and a loop to scan the text (brute-force solution)
* use a regular expression, or in a database use a "LIKE" (generic solution)
* install a SOLR or Elasticsearch (correct solution in many cases, but "black magic" in understanding)

Most people wouldn't even think of the 3rd solution. And if they do, they don't know why. And what if I told you that — obviously in an absolutely raw and summarized way — the solution lies in transforming a document and the search terms into vectors and calculating the relevance between the search terms and the documents by [cosine similarity](http://en.wikipedia.org/wiki/Cosine_similarity)? That's exactly what the [Vector Space Model](http://en.wikipedia.org/wiki/Vector_space_model) (VSM) means, which you'll find in several search engines.

<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; height: auto; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'>{{< youtube id="ZEkO8QSlynY" >}}</div>

The knowledge that leads to this is called [**Linear Algebra**](http://en.wikipedia.org/wiki/Linear_algebra). Remember that from the FIRST year of Computer Science? On this topic specifically, I recommend watching a talk I gave about it called ["How not to do searches using LIKE"](https://www.eventials.com/akitaonrails/como-nao-fazer-pesquisas-usando-like/).

And when you need to create a process to filter content? To avoid inappropriate content? Most people would think of the following:

* create a blacklist of words and add to it as they remember offensive words. And use the first or second option I listed before to search for those words.

As you can already imagine, the most "obvious" or "simple" answer (considering the lack of knowledge) is probably wrong, and in this case it really isn't the most efficient.

Learn about machine learning and one of the simplest forms of it called [Naive Bayes Classifier](http://en.wikipedia.org/wiki/Naive_Bayes_classifier). Someone might think _"damn, but machine learning is too advanced for day-to-day."_ Not at all. In fact, any cheap anti-spam filter you find on a free downloads site uses a classifier.

The idea is that simply single words aren't enough to determine whether content is inappropriate. The way sentences are constructed, the "tone" of the writing. All of that forms a pattern that can be classified and learned. The more inappropriate content is classified, the more efficient the algorithm becomes. If you want to experiment with a simple way [in Ruby, see this blog](http://blog.logankoester.com/bayesian-classification-on-rails). If you want to learn about more advanced classifiers, see the [Apache Mahout](https://mahout.apache.org/) project.

{{< youtube id="DdYSMwEWbd4" >}}

And what is that? It's a subject of [**Statistics and Probability**](https://www.khanacademy.org/math/probability). The fundamentals for understanding that are again in the FIRST year of Computer Science.

_"Oh, but you're talking about things nobody needs to know. To make web sites this is unnecessary."_

One thing any good web framework needs to know how to do efficiently today is mapping routes to the underlying programming (controllers). Ruby on Rails has a routing component called [Journey](https://github.com/rails/journey), which we configure via the "config/routes.rb" file. Below is an excerpt:

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

* Easy, just make a set of arrays or a hash (dictionary), and when the URL arrives, break the terms via a regular expression and find the controller, passing the parameters to execute it.

Let me repeat myself? Yes, this works — for very small applications. Anything much bigger than the example above will already have performance problems.

How about seeing a snippet of the Journey code?

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

If you made it at least through the SECOND year of Computer Science, then you went through the subjects of [**Algorithms and Data Structures**](http://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs) and Assemblers. And if you reached the THIRD year, you should have learned about [**Compilers**](http://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools) (and seen the famous Dragon book). Racc should have reminded you of Yacc, Flex, Bison.

{{< youtube id="QPCC2sbukeo" >}}

To finish off, you must think you know what [**Object Orientation**](http://c2.com/cgi/wiki?NobodyAgreesOnWhatOoIs) is, right? You certainly think your favorite language (whether Java, C#, or JavaScript) is object-oriented. If I ask you to define what that means, it's on the tip of your tongue:

* My language supports Encapsulation, Inheritance, and Polymorphism, therefore it's object-oriented.

And what if I told you that procedural, imperative, and functional languages also support encapsulation, inheritance (either via delegation or not), and polymorphism? And if that's the case, then [what defines object orientation?](http://c2.com/cgi/wiki?NobodyAgreesOnWhatOoIs)

Some who've delved into the subject might remember [Alan Kay](http://en.wikipedia.org/wiki/Alan_Kay), who coined the term "object orientation." But how many have stopped to research the Simula 67 language? What did Simula introduce in 1967? Objects, classes, inheritance, subclasses, virtual methods, [coroutines](http://en.wikipedia.org/wiki/Coroutine), discrete event simulation, garbage collection.

And how many have heard of the creators of Simula 67, [Kristen Nygaard](http://en.wikipedia.org/wiki/Kristen_Nygaard) and [Ole-Johan Dahl](http://en.wikipedia.org/wiki/Ole-Johan_Dahl)?

You don't know who they are? I'm sure you don't. Well, let me introduce you to the fathers of object orientation.

## On the Shoulders of Giants

What I mentioned in the previous section isn't even the tip of the iceberg — it's a drop of water on that tip. What's important is for you to gain awareness that everything you think you know is close to nothing. I want you to accept that everything you think you know is either wrong or totally incomplete.

That's important because anyone who thinks they already know everything or close to it will never learn anything. You need to empty the cup to fill it. (by Bruce Lee)

![Bruce Lee Quote](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/406/big_quote-emptiness-the-starting-point-in-order-to-taste-my-cup-of-water-you-must-first-empty-your-cup-bruce-lee-246247.jpg)

Besides that, I want you to understand that you aren't alone. Before you came dozens of great minds. And I'm not talking about those superficial gurus merely teaching techniques and tools. Forget them — everyone will forget them soon too.

Everyone knows who Linus Torvalds, Bill Gates, Steve Jobs, Zuckerberg are. Forget them for now. Stick to the immortals. Names who really made a difference in the history of Computer Science. A few examples:

* [Charles Babbage](http://en.wikipedia.org/wiki/Charles_Babbage)
* [Ada Lovelace](http://en.wikipedia.org/wiki/Ada_Lovelace)
* [George Boole](http://en.wikipedia.org/wiki/George_Boole)
* [Alan Turing](http://en.wikipedia.org/wiki/Alan_Turing)
* [Alonzo Church](http://en.wikipedia.org/wiki/Alonzo_Church)
* [John von Neumann](http://en.wikipedia.org/wiki/John_von_Neumann)
* [John McCarthy](http://bit.ly/1rN6Kwe)
* [Niklaus Wirth](http://en.wikipedia.org/wiki/Niklaus_Wirth)
* [Bertrand Meyer](http://en.wikipedia.org/wiki/Bertrand_Meyer)
* [Dan Ingalls](http://en.wikipedia.org/wiki/Dan_Ingalls)
* [Donald Knuth](http://en.wikipedia.org/wiki/Donald_Knuth)
* [Edsger W. Dijkstra](http://en.wikipedia.org/wiki/Edsger_Dijkstra)

And that's just to list a few. Science is a broad field, where one scientist's work complements the previous one's. Step by step, always moving forward. It's a cumulative work of tens, hundreds of years. Our advantage? Hundreds of people have already walked this path in the past, and we can use what they learned and left us, instead of making the same mistakes ourselves until we learn.

{{< youtube id="6dME3wgaQpM" >}}

Almost everything you see out there called ["innovation"](http://startups.ig.com.br/2013/restricoes-sao-libertadoras-menos-e-mais/) is no more than the rediscovery of things that are already documented in the past but were ahead of their time. It was like that with the mouse: [Douglas Engelbart](http://en.wikipedia.org/wiki/Douglas_Engelbart), who created the mouse in 1968, had to wait until Steve Jobs launched the Macintosh, 16 years later, to see his invention popularized. Stop to think: how many discoveries are in the past just waiting for us to dig them up to finally realize them?

Want to know about the immortal books of Computer Science? Let's see some:

* [Structure and Interpretation of Computer Programs (SICP)](http://en.wikipedia.org/wiki/Structure_and_Interpretation_of_Computer_Programs)
* [The C Programming Language (K&R)](http://en.wikipedia.org/wiki/The_C_Programming_Language)
* [Algorithms + Data Structures = Programs](http://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs)
* [Compilers: Principles, Techniques and Tools](http://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools) — the Dragon book
* [Modern Operating Systems](http://en.wikipedia.org/wiki/Modern_Operating_Systems)
* [Computer Networks](http://en.wikipedia.org/wiki/Computer_network)
* [The Art of Computer Programming](http://en.wikipedia.org/wiki/The_Art_of_Computer_Programming) — even I haven't read these books, and I don't know anyone who has read and understood them, but I'll leave it here because of its importance.

[Don't want to go to college?](http://www.akitaonrails.com/2009/04/17/off-topic-devo-fazer-faculdade) No problem, try to follow the material available online from MIT on [Electrical Engineering and Computer Science](http://ocw.mit.edu/courses/#electrical-engineering-and-computer-science). If you're still completely amateur even in the programming world, see this introductory course to Computer Science on [Coursera](https://www.coursera.org/course/cs101).

Note that I'm not citing in this article any of the names many might expect, like Martin Fowler, Bruce Eckel, Robert Martin, Michael Feathers, Kent Beck, Steve McConnell, Tom DeMarco, Dave Thomas, etc. Forget them. If you don't see the previous ones, these will make little difference.

Don't put the cart before the horse — go one step at a time.

## Career in Programming

One thing I always repeat is:

<blockquote>"Programming isn't writing any code, just like cooking isn't throwing any ingredient into a pan."</blockquote>

Understand: it's very simple to write code. Anyone who has the minimum motor coordination not to try to put a square piece through a round hole, or who has minimally stacked a Lego piece on top of another, is capable of writing code. There's absolutely no merit in it.

Downloading a Twitter Bootstrap, using a Yeoman generator, installing MySQL on Ubuntu, copying and pasting a JQuery snippet — anyone can do it.

When we talk about a career, what "anyone" can do means it's a mere ["commodity"](http://en.wikipedia.org/wiki/Commodity). Being a commodity means the value the market is willing to pay will only decline, it won't rise. Temporarily, some novelty appears to try to create a differentiation (_"look, Angular JS,"_ _"look, HTML 5"_), but they quickly dissolve into the downward trend in value.

Value isn't in the assembly. It's in the creativity of the solution: managing to extract the greatest value for the lowest cost. And creativity only exists when you have mastery over all the elements around you. When 1 hour to replace an idiotic word search algorithm with a vector space model reduces your fleet of machines from 10 to 2, and responds to your user in 1/5 of the time. Then it's not brute force, it's actually knowledge. And that has value and grows.

Having a toolbox full of tools only makes you a "jack-of-all-trades with many tools" — it doesn't make you an engineer/architect capable of building the next World Trade Center/Freedom Tower.

But, like everyone who wants to evolve, we all start as jack-of-all-trades. There's nothing wrong with that — just don't fool yourself into thinking that having a toolbox with more tools makes you anything different from that.
