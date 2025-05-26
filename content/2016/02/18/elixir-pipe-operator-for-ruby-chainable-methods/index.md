---
title: 'Elixir Pipe Operator for Ruby: Chainable Methods'
date: '2016-02-18T16:28:00-02:00'
slug: elixir-pipe-operator-for-ruby-chainable-methods
tags:
- ruby
- elixir
draft: false
---

There has been [recent](http://blog.molawson.com/elixir-pipes-in-ruby/) [discussions](https://gist.github.com/pcreux/2f87847e5e4aad37db02) about how nice it would be to have something like the awesome Elixir Pipe Operator for Ruby.

If you don't know what the "Pipe Operator" is in Elixir, take the following code:

--- ruby
Enum.sum(Enum.filter(Enum.map(1..100_000, &(&1 * 3)), odd?))
---

It's ugly, we all know that. In an Object Oriented language like Ruby we would do something like this:

--- ruby
(1..100_000).
  map { |i| i * 3 }.
  select(&:odd?).
  reduce(&:+)
---

But Elixir does not have objects, only functions, so how can we code more elegantly? The solution came up in the form of the so called "Pipe Operator" which takes the last returning value and pass it through as the first argument of the next function call, like this:

--- ruby
1..100_000
  |> Stream.map(&(&1 * 3))
  |> Stream.filter(odd?)
  |> Enum.sum
---

So Ruby and Elixir "feels" the same when we are able to "chain" methods. In the Ruby world we don't have the "need" for an operator like that. But it would be nice to have a mechanism that we could use to make our codes more expressive, or more testable, or more readable. For example, what if we would write something like this:

--- ruby
(1..100_000).
  multiple_each_element_by_three.
  filter_out_odd_elements.
  give_the_sum_of_all_elements
---

Of course, this is a very constrained example with really bad method naming. But if we get Mo Lawson's article I linked above, it becomes more interesting:

--- ruby
keywords
  .map { |kw| kw.gsub(/(^[^[:alpha:]]+|[^[:alpha:]]+$)/, '') }
  .map { |kw| LegacySpanishCorrector.new.correct(kw) }
  .map { |kw| kw.gsub(/[^[:alpha:]\d'_\-\/]/, '') }
  .reject { |kw| STOP_WORDS.include?(kw) }
---

Ruby allows us to chain Enumerable methods one after the other, transforming the initial keywords list into "something" that is very difficult to infer just by looking at this code.

What about this other version?

--- ruby
class KeywordNormalizer
  def call(keywords)
    Collection.new(keywords)
      .strip_outer_punctuation
      .fix_spanish
      .clean_inner_punctuation
      .remove_stop_words
      .to_a
  end

  # ...
end
---

This is where we gets by the end of his article: much more readable and each new isolated method is unit testable, resulting in more robust code.

The whole idea of this post is to present you to my new little gem ["Chainable Methods"](https://rubygems.org/gems/chainable_methods). The [source code](https://github.com/akitaonrails/chainable_methods) is on Github, as usual, so please contribute.

My gem will allow you to write the Lawson's last code like this:

--- ruby
KeywordNormalizer
  .chain_from(keywords)
  .strip_outer_punctuation
  .fix_spanish
  .clean_inner_punctuation
  .remove_stop_words
  .to_a
  .unwrap
---

You add the <tt>chainable_methods</tt> to your Gemfile as usual (you know the drill), then you can write Lawson's module like this:

--- ruby
module KeywordNormalizer
  extend ChainableMethods
  
  def self.strip_outer_punctuation(array)
    array.map { |el| el.gsub(/(^[^[:alpha:]]+|[^[:alpha:]]+$)/, '') }
  end
  def self.fix_spanish(array)
    array.map { |el| LegacySpanishCorrector.new.correct(el) }
  end
  def self.clean_inner_punctuation(array)
    array.map { |el| el.gsub(/[^[:alpha:]\d'_\-\/]/, '') }
  end
  def self.remove_stop_words(array)
    array.reject { |el| STOP_WORDS.include?(el) }
  end
end
---

And that's it, now you can chain everything like I showed previously. The pattern is:

1) Write a Module with class-level methods that receive at least one argument and extend the 'ChainableMethods' module:

--- ruby
module MyModule
  extend ChainableMethods

  def self.method_a(argument1)
    # ...
  end

  def self.method_b(argument1, argument2)
    # ...
  end

  def self.method_c(argument1)
    # yield a block passing the received argument
  end
end
---

2) Wrap an initial state that will be passed to the first method as it's first argument:

--- ruby
some_initial_state = "Hello World"
MyModule
  .chain_from(some_initial_state)
  # ...
---

3) Chain as many methods from the module or methods that the returning state recognizes:

--- ruby
MyModule
  .chain_from(some_initial_state)
  .upcase
  .method_a
  .method_b(argument2)
  .method_c { |foo| foo }
  .split(" ")
  .join(", ")
  .unwrap
---

Notice that we do not need to pass the first argument to the methods within the 'MyModule' module, it will get the result from the last call automatically.

4) Do not forget to call <tt>#unwrap</tt> as the last call to get the last result from the chain.

### An Experiment

And that's it! I isolated this behavior only into modules that explicitly extend the 'ChainableMethods' module instead of automagically enabling it in the BasicObject level as many would initially think because we don't want a global 'method_missing' dangling around unchecked.

This behavior makes use of 'method_missing' so it's not going to be fast in a synthetic benchmark against a direct method call, for obvious reasons. The purpose is not to be fast, just expressive. So keep that in mind.

The use case is: whenever you have some kind of transformation, you will want a chain of unit testable, isolated, functions, and this is how you can get it without too much hassle.

This is an experiment. Because I'm using 'method_missing' there may be side-effects I am not seeing right now, so please let me know in the [Github Issues](https://github.com/akitaonrails/chainable_methods/issues) and send feedback if it helped you out in some project.

Pull Requests are most welcome!
