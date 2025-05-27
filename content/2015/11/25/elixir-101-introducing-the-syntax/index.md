---
title: Elixir 101 - Introducing the Syntax
date: '2015-11-25T17:25:00-02:00'
slug: elixir-101-introducing-the-syntax
tags:
- learning
- beginner
- elixir
- english
draft: false
---

I've been posting a lot of articles in the last few weeks, check out the ["Elixir" tag](http://www.akitaonrails.com/elixir) to read all of them.

Many tutorial series start introducing a new language by its syntax. I subverted the order. Elixir is not interesting because of its syntax. Erlang is interesting all by itself, because of its very mature, highly reliable, highly concurrent, distributed nature. But its syntax is not for the faint of heart. It's not "ugly", it's just too different for us - from the C school - to easily digest. It derives from Prolog, and this is one small example of a Prolog exercise:

--- prolog
% P03 (*): Find the K'th element of a list.
%     The first element in the list is number 1.
%     Example:
%     ?- element_at(X,[a,b,c,d,e],3).
%     X = c

% The first element in the list is number 1.

% element_at(X,L,K) :- X is the K'th element of the list L
%    (element,list,integer) (?,?,+)

% Note: nth1(?Index, ?List, ?Elem) is predefined

element_at(X,[X|_],1).
element_at(X,[_|L],K) :- K > 1, K1 is K - 1, element_at(X,L,K1).
```

Erlang has a similar syntax, with the idea of phrases divided by commas and ending with a dot.

José Valim played very smart: he chose the best of the available mature platforms and coated it with a layer of modern syntax and easier to use standard libraries. This is the same problem implemented in Elixir:

--- ruby
defmodule Exercise do
  def element_at([found|_], 1), do: found
  def element_at([_|rest], position) when position > 1 do
    element_at(rest, position - 1)
  end
end
```

If I copy and paste the code above in an IEx shell I can test it out like this:

```
iex(7)> Exercise.element_at(["a", "b", "c", "d", "e"], 3)
"c"
```

This simple exercise shows us some of the powerful bits of Erlang that Elixir capitalizes upon, such as pattern matching and recursion.

First of all, every function **must** be defined inside a module, which you name with the <tt>defmodule My.Module do .. end</tt>. Internally it becomes the atom "Elixir.My.Process". Nesting modules is just a larger name concatenated with dots.

Then you can define public function with the <tt>def my_function(args) do .. end</tt> block which is just a macro to the same <tt>def my_function(args), do: ...</tt> construct. Private methods are declared with <tt>defp</tt>.

A function is actually identified by the pair of its name and its arity. So above we have <tt>element_at/2</tt> which means it accepts 2 arguments. But we have 2 functions with the same arity: the difference is the **pattern matching**.

--- ruby
def element_at([found|_], 1), do: found
```

Here we are saying: the first argument will be an array, decompose it. The first element of the array will be stored in the "found" variable, the rest "_" will be ignored. And the second argument must be the number "1". This is the description of the so called "pattern", it should "match" the input arguments received. This is **"call-by-pattern"** semantics.

But what if we want to pass a position different than "1"? That's why we have this second definition:

```
def element_at([_|rest], position) when position > 1 do
```

Now, the first argument again **need** to be an array, but this time we don't care about the first element, just the rest of the array without the first element. And any position different than "1" will be stored in the "position" variable.

But this function is special, it is **guarded** to only allow a <tt>position</tt> that is larger than 1. What if we try a negative position?

```
iex(8)> Exercise.element_at(["a", "b", "c", "d", "e"], -3)
** (FunctionClauseError) no function clause matching in Exercise.element_at/2
    iex:7: Exercise.element_at(["a", "b", "c", "d", "e"], -3)
```

It says that none of the clause we passed doesn't match any of the defined ones above. We could have added a third definition just to catch those cases:

--- ruby
def element_at(_list, _position), do: nil
```

Adding the underscore "_" before the variable name is the same as having just the underscore but we are naming it just to make it more readable. But any arguments passed will just be ignored. And this is the more generic case if the previous 2 don't match.

The previous line is the same as writing:

```
def element_at(_list, _position) do
  nil
end
```

I won't dive into macros for now, just know that there is more than one way of doing things in Elixir and you can define those different ways using Erlang's built-in support for macros, dynamic code that is compiled in runtime. It's the way of doing metaprogramming with Elixir.

Now, going back to the implementation, the first function still can look weird, let's review it:

--- ruby
def element_at([_|rest], position) when position > 1 do
  element_at(rest, position - 1)
end
```

What happens is: when we call <tt>Exercise.element_at(["a", "b", "c", "d", "e"], 3)</tt> the first argument will pattern match with <tt>[_|rest]</tt>. The first element "a" is disposed and the new list <tt>["b", "c", "d", "e"]</tt> is stored as "<tt>rest</tt>".

Finally, we recurse the call decrementing from the "<tt>position</tt>" variable. So it becomes <tt>element_at(["b", "c", "d", "e"], 2)</tt>. And it repeats until position becomes "1", in which case the pattern matching falls to the second function defined as: 

```
def element_at([found|_], 1), do: found
```

In this case the rest of the array is pattern matched and the first element, "c" is stored in the "<tt>found</tt>" variable, the rest of the array is discarded. It only got here because the position matched as "1", and so it just returns the variable "found", which contains the 3rd element of the original array, "c".

This is all nice and fancy, but in Elixir we could just have done this other version:

--- ruby
defmodule Exercise do
  def element_at(list, position), do: Enum.at(list, position)
end
```

And we are done! Several tutorials will talk about how recursion and pattern matching to decompose lists solve a lot of problems, but Elixir gives us the convenience of treating lists as Enumerables and provide us a rich [Enum](http://elixir-lang.org/docs/stable/elixir/Enum.html) module with very useful functions such as <tt>at/2</tt>, <tt>each/2</tt>, <tt>take/2</tt>, and so on. Just pick what you need and you're managing lists like a boss.

Oh, and by the way, there is something called a [Sigil](http://elixir-lang.org/getting-started/sigils.html) in Elixir. Instead of writing the List of String explicitly, we could have done it like this:

```
iex(8)> ~w(a b c d e f)
["a", "b", "c", "d", "e", "f"]
```

Or, if we wanted a List of Atoms, we could do it like this:

```
iex(9)> ~w(a b c d e f)a
[:a, :b, :c, :d, :e, :f]
```

### Lists, Tuples and Keyword Lists

Well, this was too simple. You really need the idea of pattern matching and basic type in your mind to make it flow. Let's get another snippet from the [Ex Manga Downloadr](http://www.akitaonrails.com/2015/11/18/ex-manga-downloader-an-exercise-with-elixir):

--- ruby
defp parse_args(args) do
  parse = OptionParser.parse(args,
    switches: [name: :string, url: :string, directory: :string],
    aliases: [n: :name, u: :url, d: :directory]
  )
  case parse do
    {[name: manga_name, url: url, directory: directory], _, _} -> process(manga_name, url, directory)
    {[name: manga_name, directory: directory], _, _} -> process(manga_name, directory)
    {_, _, _ } -> process(:help)
  end
end
```

The first part may puzzle you:

--- ruby
OptionParser.parse(args,
    switches: [name: :string, url: :string, directory: :string],
    aliases: [n: :name, u: :url, d: :directory]
  )
```

The <tt>OptionParser.parse/2</tt> receives just 2 arguments: 2 arrays. If you come from Ruby it feels like it's a Hash with optional brackets, translating to something similar to this:

--- ruby
# this is wrong
OptionParser.parse(args,
    { switches: {name: :string, url: :string, directory: :string},
      aliases: {n: :name, u: :url, d: :directory} }
  )
```

This works in Ruby but it is not the case in Elixir, there are optional brackets but not where you think they are:

--- ruby
# this is the correct, more explicit version
OptionParser.parse(args,
    [
      {
        :switches,
        [
          {:name, :string}, {:url, :string}, {:directory, :string}
        ]
      },
      {
        aliases:
        [
          {:n, :name}, {:u, :url}, {:d, :directory}
        ]
      }
    ]
  )
```

WHAT!?!?

Yep, the second argument is actually an array with elements that are **Tuples** paired with an atom key and value, and some of the values are themselves arrays with tuples.

1. in Elixir, Lists are what we usually call an Array, a Linked-List of elements. Linked-Lists, as you know from your Computer Science classes, are easy to insert new elements and remove elements.

2. in Elixir, Tuples are immutable fixed lists with fixed positions, with elements delimited by the brackets "{}"

If the previous example was just too much, let's step back a little:

--- ruby
defmodule Teste do
  def teste(opts) do
    [{:hello, world}, {:foo, bar}] = opts
    IO.puts "#{world} #{bar}"
  end
end
```

Now we can call it like this:

```
iex(13)> Teste.teste hello: "world", foo: "bar"
world bar
```

Which is the same as calling like this:

```
iex(14)> Teste.teste([{:hello, "world"}, {:foo, "bar"}])
world bar
```

This may confuse you, but it's very intuitive. You can just think of this combination of Lists ("[]") with Tuple elements containing a pair of atom and value ("{:key, value}") to behave almost like Ruby Hashes being used for optional named arguments.

Then, we have the Pattern Match section in both previous examples:

--- ruby
case parse do
  {[name: manga_name, url: url, directory: directory], _, _} ->
    process(manga_name, url, directory)
  {[name: manga_name, directory: directory], _, _} ->
    process(manga_name, directory)
  {_, _, _ } ->
    process(:help)
end
```

And

--- ruby
[{:hello, world}, {:foo, bar}] = opts
```

The last example is just decomposition. The previous example is pattern match and decomposition. You match based on the atoms and positions within the tuples within the list. You match from the more narrow case to the more generic case. And in the process, the variables in the pattern are available for you to use in the matching case clause.

Let's understand the meaning of this line:

--- ruby
{[name: manga_name, url: url, directory: directory], _, _} -> process(manga_name, url, directory)
```

It is saying: given the results of the <tt>OptionParser.parse/2</tt> function, it must be a tuple with 3 elements. The second and third elements don't matter. But the first element must be a List with at least 3 tuples. And the keys of each tuples must be the atoms <tt>:name</tt>, <tt>:url</tt>, and <tt>:directory</tt>. If they're there, store the values of each tuples in the variables <tt>manga_name</tt>, <tt>url</tt>, and <tt>directory</tt>, respectivelly.

This may really confuse you in the beginning, but this combination of a List of Tuples is what's called a [**Keyword List**](http://elixir-lang.org/getting-started/maps-and-dicts.html#keyword-lists) and you will find this pattern many times, so get used to it.

Keyword List feel like a Map, but a Map has a different syntax:

--- ruby
list = [a: 1, b: 2, c: 3]
map = %{:a => 1, :b => 2, :c => 3}
```

This should summarize it:

```
iex(1)> list = [a: 1, b: 2, c: 3]
[a: 1, b: 2, c: 3]
iex(2)> map = %{:a => 1, :b => 2, :c => 3}
%{a: 1, b: 2, c: 3}

iex(3)> list[:a]
1
iex(4)> map[:a]
1

iex(5)> list.a
** (ArgumentError) argument error
    :erlang.apply([a: 1, b: 2, c: 3], :a, [])
iex(5)> map.a
1

iex(6)> list2 = [{:a, 1}, {:b, 2}, {:c, 3}]
[a: 1, b: 2, c: 3]
iex(7)> list = list2
[a: 1, b: 2, c: 3]
```

Keyword Lists are convenient as function arguments or return values. But if you want to process a collection of key-value pairs, use a dictionary-like structure, in this case, a Map. Specifically if you need to search the collection using the key. They look similar but the internal structures are not the same, a Keyword List is not a Map, it's just a convenience for a static list of tuples.

Finally, if this pattern matches the <tt>parse</tt> variable passed in the <tt>case</tt> block, it executes the statement <tt>process(manga_name, url, directory)</tt>, passing the 3 variables captured in the match. Otherwise it proceeds to try the next pattern in the <tt>case</tt> block.

The idea is that the "=" operator is not an "assignment", it's a matcher, you match one side with the other. Read the error message when a pattern is not matched:

```
iex(15)> [a, b, c] = 1
** (MatchError) no match of right hand side value: 1
```

This is a matching error, not an assignment error. But if it succeeds this is what we have:

```
iex(15)> [a, b, c] = [1, 2, 3]
[1, 2, 3]
iex(16)> a
1
iex(17)> c
3
```

This is a List decomposition. It so happens that in the simple case, it feels like a variable assignment, but it's much more complex than that.

### Pipelines

We use exactly those concepts of pattern matching on the returning elements from the HTML parsed by Floki in my Manga Downloadr:

--- ruby
Floki.find(html, "#listing a")
|> Enum.map(fn {"a", [{"href", url}], _} -> url end)
```

The <tt>find/2</tt> gets a HTML string from the fetched page and matches against the CSS selectors in the second argument. The result is a List of Tuples representing the structure of each HTML Node found, in this case, this pattern: <tt>{"a", [{"href", url}], _}</tt>

We can then <tt>Enum.map/2</tt>. A map is a function that receives each element of a list and returns a new list with new elements. The first argument is the original list and the second argument is a function that receives each element and returns a new one.

One of the main features of the Elixir language that most languages don't have is the **Pipe** operator ("|>"). It behaves almost like UNIX's pipe operator "|" in any shell.

In UNIX we usually do stuff like "<tt>ps -ef | grep PROCESS | grep -v grep | awk '{print $2}' | xargs kill -9</tt>"

This is essentially the same as doing:

```
ps -ef > /tmp/ps.txt
grep mix /tmp/ps.txt > /tmp/grep.txt
grep -v grep /tmp/grep.txt > /tmp/grep2.txt
awk '{print $2}' /tmp/grep2.txt > /tmp/awk.txt
xargs kill -9 < /tmp/awk.txt
```

Each UNIX process can receive something from the standard input (STDIN) and output something to the standard output (STDOUT). We can redirect the output using ">". But instead of doing all those extra steps, creating all those extra garbage temporary files, we can simply "pipe" the STDOUT of one command to the STDIN of the next command.

Elixir uses the same principles: we can simply use the returning value of a function as the **first argument** of the next function. So the first example of this section is the same as doing this:

--- ruby
results = Floki.find(html, "#listing a")
Enum.map(results, fn {"a", [{"href", url}], _} -> url end)
```

In the same ExMangaDownloadr project we have this snippet:

--- ruby
defp process(manga_name, url, directory) do
  File.mkdir_p!(directory)
  url
    |> Workflow.chapters
    |> Workflow.pages
    |> Workflow.images_sources
    |> Workflow.process_downloads(directory)
    |> Workflow.optimize_images
    |> Workflow.compile_pdfs(manga_name)
    |> finish_process
end
```

And we just learned that it's the equivalent of doing the followng (I'm cheating a bit because the 3 final functions of the workflow are not transforming the input "directory", just passing it through):

--- ruby
  defp process(manga_name, url, directory) do
    File.mkdir_p!(directory)

    chapters  = Workflow.chapters(url)
    pages     = Workflow.pages(chapters)
    sources   = Workflow.images_sources(pages)
    Workflow.process_downloads(sources, directory)
    Workflow.optimize_images(directory)
    Workflow.compile_pdfs(directory, manga_name)
    finish_process(directory)
  end
```

Or this much uglier version that we must read in reverse:

--- ruby
defp process(manga_name, url, directory) do
  File.mkdir_p!(directory)
  finish_process(
    Workflow.compile_pdfs(
      Workflow.optimize_images(
        Workflow.images_sources(
          Workflow.pages(
            Workflow.chapters(url)
          )
        )
      ), manga_name
    )
  )
end
```

We can easily see how the Pipe Operator "|>" makes any transformation pipeline much easier to read. Anytime you are starting from a value, passing the results through a **chain of transformation**, you will use this operator.

### Next Steps

The concepts presented in this article are the ones I think most people will find the most challenging upon first glance. If you understand Pattern Matching, Keyword Lists, you will understand all the rest.

The official website offers a great [Getting Started](http://elixir-lang.org/getting-started/introduction.html) that you must read entirely.

From intuition you know most things already. You have "do .. end" blocks but you still don't know that they are just convenience macros to pass a list of statements as an argument inside a Keyword List. The following blocks are equivalent:

--- ruby
if true do
  a = 1 + 2
  a + 10
end

if true, do: (
  a = 1 + 2
  a + 10
)

if true, [{:do, (
  a = 1 + 2
  a + 10
)}]
```

Mind blowing, huh? There are many macros that add syntactic sugar using the primitives behind it.

On the most part, Valim made the powerful Erlang primitives more accessible (Lists, Atoms, Maps, etc) and added higher abstractions using macros (do .. end blocks, the pipe operator, keyword lists, shortcuts for anonymous functions, etc). This precise combination is what makes Elixir very enjoyable to learn. It's like peeling an onion: you start with the higher abstractions and discover macros of simpler structures underneath. You see a Keyword List first and discover Lists of Tuples. You see a block and discover another Keyword List disguised with a macro. And so on.

So you have a low curve of entry and you can go as deep as you want in the rabbit hole, until the point you're extending the language.

Elixir provides a very clever language design on top of the 25 year old mature Erlang core. This is not just clever, it's the intelligent choice. Keep learning!
