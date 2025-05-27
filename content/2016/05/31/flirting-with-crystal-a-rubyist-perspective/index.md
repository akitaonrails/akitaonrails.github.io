---
title: Flirting with Crystal, a Rubyist Perspective
date: '2016-05-31T18:21:00-03:00'
slug: flirting-with-crystal-a-rubyist-perspective
tags:
- crystal
draft: false
---

If you're following me you will see that I have been sidetracking to [Elixir](/elixir) recently. I will write a big introduction before diving into Crystal, so bear with me.

I'll say that the Erlang OTP and it's internals do intrigue me more than just the novelty of the language syntax. I believe that if you want to build highly distributed and also highly reliable systems you will either use Erlang (through Elixir) or you will end up replicating most of what Erlang already has with OTP.

This is true if you see that there are many Java/Scala-based distributed systems such as Hadoop, Spark, Cassandra, and they all could have benefitted from Erlang's OTP architecture. On the other hand, if you follow Cassandra you will see that even Java still has a hard time competing with C++ if you compare the clone called [ScyllaDB](http://www.scylladb.com/).

I believe Elixir (perhaps with HiPE) can compete in the same league as Java for distributed systems avoiding people to leave the Erlang platform for C or Java as [has happened with CouchDB](https://www.infoq.com/news/2012/01/Katz-CouchDB-Couchbase-Server) back in 2012 because of lack of interest and exotic syntax. And because Java already has a big ecosystem, Clojure is in the game primarily because it can interface directly with it.

I think Go is also a Java contender but for other use cases, particularly in the systems tools space where you have lots of C/C++ and also glue code in Perl and Python. An obvious example being Docker orchestration. Yes, you can do microservices, crawlers and other stuff but I am not so keen to build big "applications" in it, althought there is nothing preventing it. Again, it's just a personal opinion.

Rust is a big contender to low-level systems development. I think it can replace C in many use cases and be used to implement libraries and components to be used by other languages, with the added benefits of a modern language that tries to avoid security hazards such as the recent [Heartbleed debacle](https://tonyarcieri.com/would-rust-have-prevented-heartbleed-another-look). But because of it's "Borrow system" I find it extremely bureacratic, specially if you're coming from highly dynamic languages such as Ruby, Python or even Swift or Elixir. I'm not saying it's a bad thing, just something that take way more time to become comfortable with than I expected.

Crystal is something between Rust and Go. LLVM is something you must have in your radar, because of [Apple's support](http://appleinsider.com/articles/08/06/20/apples_other_open_secret_the_llvm_complier) towards Swift it's better than ever. Crystal is _similar_ to RubyMotion in terms of both being similar to Ruby but not fully compatible and both being front-end parsers to LLVM. RubyMotion, on the other hand, is closer to Ruby and can even use some Ruby libraries almost without changes.

You do have to take your hats off to Ary Borenszweig and his contributors. It's very impressive how far they got in such a short period of time and without having deep pockets from Mozilla, Apple or Google.

### Limitations

Crystal borrows heavily from Ruby but it's not a goal to reach any level of compatibility. It's a strong and static type language with Type Inference. It does not have any runtime component such as RubyMotion or Swift, so it has no notion of introspection or reflection over objects.

Mainly, you have neither "#eval" nor "#send". The lack of runtime evaluation is not so bad as you do have compilation-time AST manipulation through a good enough system of Macros (more on that later).

But the lack of "#send" does hurt a bit. It's the one thing that makes Crystal farther away from Ruby dynamic object flexibility. But it's also understandable why it's not a priority to have it.

As of version 0.17.0, Crystal has one huge limitation: it's using a [Boehm-Demers-Weiser conservative garbage collector](http://crystal-lang.org/2013/12/05/garbage-collector.html).

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/asterite">@asterite</a> <a href="https://twitter.com/headius">@headius</a> I assumed as much... the Boehm GC, although handy for starting a new language, will only get you so far</p>&mdash; Jason Frey (@Fryguy9) <a href="https://twitter.com/Fryguy9/status/736990644082757632">May 29, 2016</a></blockquote>

The language is currently implemented as a single-threaded process. This means that you _probably_ can't max out all CPUs of your machine with just a single process. Although I may be wrong here, it's just my first impressions.

Charles Nutter (from JRuby fame) gives a warn about this:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/Fryguy9">@fryguy9</a> From their site: <a href="https://t.co/uOjIT0c8ji">https://t.co/uOjIT0c8ji</a> It does say something about &quot;when&quot; parallelism happens. Risky to start single-threaded.</p>&mdash; Charles Nutter (@headius) <a href="https://twitter.com/headius/status/736982955239870464">May 29, 2016</a></blockquote>

It's a double-edged sword. Using a "generic" plug-and-play GC such as Boehm - which is not a bad thing in itself, but it's possibly not nearly as powerful as the JVM's own set of high performance GC such as the brand new G1GC.

Making the language be single-threaded by default also means that the entire standard library and all the ecosystem is built assuming there is no parallelism. So there are no race-conditions and hence, no usage of proper synchronization anywhere. If one day they decide to add multi-threading, all existing code will not be thread-safe. This is probably the meaning of Charles' warning.

I don't think it's a pressing problem though. You probably won't have a highly parallel system built with Crystal but maybe it's not the use case. In that case you should be using Elixir + OTP, Scala + Akka, for example.

### Concurrency

Not having access to native Threads doesn't mean that you can't have Concurrency. [Concurrency is not Parallelism](https://blog.golang.org/concurrency-is-not-parallelism). Since [version 0.7.0](http://crystal-lang.org/2015/04/30/crystal-0.7.0-released.html) they have added support for non-blocking I/O and also Fibers and Channels.

In a nutshell, a Fiber is a special kind of coroutine. It's a "piece of execution" that can "pause" itself and yield control of the execution back to its caller. It can pause itself but it can't be paused from the outside like Erlang's Scheduler can pause its running processes, for example.

In this case we can have a "Fiber Scheduler" of sorts, that can "resume" other Fibers. It is currently single-threaded, of course. And it works as an Event Loop. Whenever you have a non-blocking I/O operation waiting for file reading, network packet sending and stuff like that, it can yield control back to other fibers to resume work.

This makes it work more or less like Node.js. Javascript is also a single-threaded language and Node.js is basically an implementation of an event loop. Functions declare other anonymous functions as callbacks and it works based on the I/O triggers to callback those functions on every tick of the reactor.

On top of that you can add ["Channels"](https://github.com/crystal-lang/crystal/issues/1967) as popularized by Google's Go language. You can start as many channels as you like. Then you can spawn Fibers in the Scheduler. Fibers can execute and keep sending messages through the Channels. Execution control is yielded to whoever is expecting to receive from the same Channels. Once one of them receives and executes, control is sent back to the Scheduler to allow other spawned Fibers to execute, and they can keep "pinging" and "ponging" like this.

Speaking of ping-pong, you have [this snippet in the "Go by Example"](https://gobyexample.com/channel-directions) site:

```go
package main
import "fmt"
func ping(pings chan<- string, msg string) {
    pings <- msg
}
func pong(pings <-chan string, pongs chan<- string) {
    msg := <-pings
    pongs <- msg
}
func main() {
    pings := make(chan string, 1)
    pongs := make(chan string, 1)
    ping(pings, "passed message")
    pong(pings, pongs)
    fmt.Println(<-pongs)
}
```

And this is mostly the same thing but implemented in Crystal:

```ruby
def ping(pings, message)
  pings.send message
end

def pong(pings, pongs)
  message = pings.receive
  pongs.send message
end

pings = Channel(String).new
pongs = Channel(String).new
spawn ping pings, "passed message"
spawn pong pings, pongs
puts pongs.receive
# => "passed message"
```

Same thing, but more pleasant to my eyes, again a personal opinion - which is expected if you're also a Rubyist.

So Crystal has Node.js/Javascript-like Event Loop in the form of a Fiber Scheduler and a Go-like Channel/CSP mechanism to coordinate concurrent processing. It's a "cooperative multitasking" mechanism. It's not good if you have CPU intensive processing, such as heavy number crunching, data processing. It works best for I/O intensive processing.

If you have a Fiber doing super heavy processing, it will block the Scheduler, as is also true for Node.js. The current implementation of the Scheduler is bound to a single native thread so it can't use other available native threads of the system for now.

Because the Channel implementation is quite new, it's not used throughout the standard library. But the standard implementation for `HTTP::Server` uses Fibers. And because it is compiled down to a native binary it's **way faster** than Javascript, as this ["fast-http-server"](https://github.com/sdogruyol/fast-http-server) shows:

* fast-http-server (Crystal)  18348.47rpm at 8.67ms avg. response time
* http-server (Node.js)   2105.55rpm at 47.92ms avg. response time
* SimpleHTTPServer (Python)   785.14rpm at 1.91ms avg. response time

We're talking about an order of magnitude of 8 times faster than Node.js and more than 20 times faster than Python.

As usual, you shouldn't blindly trust [synthetic benchmarks](https://github.com/kostya/benchmarks) but depending on which kind of processing you decide to compare against, you will see Crystal being pretty on par with Rust, Go, Swift, D.

### Type Inference

Crystal is a statically typed language. But it won't require you to declare every single type beforehand. It's quite smart in its Type Inference so if you just type:

```ruby
a = 1
b = "HELO"
```

It will know that "a" is an "Int32" and that "b" is a "String". By the way, contrary to Ruby, all Strings must be double-quoted. But it becomes particularly more complicated when you're dealing with complicated data structures such as JSON.

In Ruby I can just parse a JSON String and immediatelly explore its structure like this:

```ruby
parsed_json = JSON.parse(response.body)["files"].first["id"]
```

I can't do this in Crystal, instead the [recommended approach](http://crystal-lang.org/api/JSON.html#mapping%28properties%2Cstrict%3Dfalse%29-macro) is to declare a schema-like structure like this:

```ruby
class FilesResponse
  JSON.mapping({
    ok: {type: Bool},
    files: {type: Array(FilesItemResponse)}
  })
end
class FilesItemResponse
  JSON.mapping({
    id: {type: String},
    name: {type: String},
    filetype: {type: String},
    created: {type: Time, converter: Time::EpochConverter}
    timestamp: {type: Time, converter: Time::EpochConverter}
    permalink: {type: String}
  })
end
...
# parsed_json = JSON.parse(response.body)["files"].first["id"]
parsed_json = FilesResponse.from_json(@body).files.first.id
```

I am very used to Ruby's duck typing and the ability to query objects in runtime. It's just not the same in Crystal and it can become quite tedious to change your mindset to think about types beforehand. The compiler will scream a hell of a lot during your development cycle until you become acquainted with this concept.

I did an experiment with JSON parsing and the result is a project I called ["cr_slack_cleanup"](https://github.com/akitaonrails/cr_slack_cleanup) which showcases both this idea of JSON Schemas as well as Fibers and Channels as I explained in the previous section.

Update: after I posted this article @LuisLavena stepped in to correct me: you can do it like Ruby, without schemas:

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr"><a href="https://twitter.com/AkitaOnRails">@AkitaOnRails</a> <a href="https://twitter.com/CrystalLanguage">@CrystalLanguage</a> re: JSON, you can parse it kinda-like Ruby, see JSON::Any: <a href="https://t.co/MD7PYy5AVH">https://t.co/MD7PYy5AVH</a></p>&mdash; Luis Lavena (@luislavena) <a href="https://twitter.com/luislavena/status/738005493189316608">June 1, 2016</a></blockquote>

And it will be like this:

```ruby
require "json"

data = <<-JSON
  {
    "files": [
        {
          "id": 1,
          "name": "photo.jpg"
        },
        {
          "id": 99,
          "name": "another.jpg"
        }
    ]
  }
  JSON

obj = JSON.parse(data)

obj["files"].each do |item|
  puts item["id"].as_i
end
```

So yeah, JSON parsing can be almost identical to what you would do with Ruby, although he also recommends Schemas as it's a bit faster anyway.

### Macros

The last important feature worth mentioning is the presence of Macros. As you don't have control over your code in runtime, you don't have "eval", you don't have "send", then you would not have any way to do proper metaprogramming.

Macros bring back some of Ruby's metaprogramming. For example, in Ruby, when you include a Module to a Class, there is the "included?" hook in the Module where you can add some metaprogramming such as "class_eval" stuff.

In Crystal, a Module does have an "included" hook but now it's a Macro. You can do something like this:

```ruby
module Foo
  macro included
    {% if @type.name == "Bar" %}
    def self.hello
      puts "Bar"
    end
    {% else %}
    def self.hello
      puts "HELLO"
    end
    {% end %}
  end
end

module Bar
  include Foo
end

module Something
  include Foo
end

Bar.hello # => "Bar"
Something.hello # => "HELLO"
```

It feels like having "ERB" templates but for code. A macro is code building code in compile time. In the resulting AST it's as if you wrote the boring repetitive code yourself. The compiled native binary doesn't care. If you're from C it's like pre-processing but having control of an AST tree of Nodes instead of just manipulating the source code. You can even have something akin to the venerable "#method_missing".

```ruby
class Foo
  macro method_missing(name, args, block)
    {{pp name}}
  end
end

Foo.new.hello_world
# => name = "hello_world"
Foo.new.bla_bla("bla")
# => name = "bla_bla"
```

Any macro function can receive an AST as the argument and you can manipulate this AST in any way as you see fit. For example:

```
module Foo
  macro teste(ast)
    puts {{ast.stringify}}
  end
end

Foo.teste "Hello World".split(" ").join(" - ")
# => ("Hello World".split(" ")).join(" - ")
```

In this example you just get a normalized version of the code you passed as argument. And the code won't be "executed" at that location.

So, you can define new methods and call different versions of methods depending on the combination of elements that you get from the AST. One example of what is possible is this experiment from developer Oleksii that I bundles in this small project I called ["cr_chainable_methods"](https://github.com/akitaonrails/cr_chainable_methods) and we can build code that is very different from either Crystal or Ruby:

```ruby
result = pipe "Hello World"
  .>> Foo.split_words
  .>> Foo.append_message("Bar")
  .>> Bar.add_something
  .>> Foo.join
  .>> unwrap
```

(Yes, a subset of what a real Elixir Pipe can do.)

### Crystal Shards

Finally, one aspect I like about Crystal is that it has task management and dependency management already figured out. No pointless discussions on which implementation of packages and dependencies we "should" be using.

You can just write a simple script into a file such as "test.cr" and run this file like this:

```
crystal test.cr
```

Or, you can build and compile to a native binary before executing like this:

```
crystal build test.cr --release
./test
```

And you can also start in a proper project structure and development lifecycle like this:

```
crystal init app test
cd test
crystal build src/test.cr --release
./test
git add .
git commit -m "initial commit"
git push -u origin master
```

It sets up a proper project directory structure, a Git repository is pre-initialized for you (why would you be programming without Git!?) with proper ".gitignore" file.

You will also find a "shard.yml" file where you can declare your application or library name, version, author, and also its dependencies like this:

```yaml
name: kemal
version: 0.12.0

dependencies:
  radix:
    github: luislavena/radix
    version: 0.3.0
  kilt:
    github: jeromegn/kilt
    version: 0.3.3
author:
  - Serdar Dogruyol <dogruyolserdar@gmail.com>
```

This example is from the [Kemal web framework](https://github.com/sdogruyol/kemal) by Serdar. It depends on the Radix and Kilt libraries. You must run `crystal deps` and it will fetch from Github before you can compile.

More than that: every project receives a proper "spec" directory where you can write Rspec-like tests and you can run them using `crystal spec`. And the spec runner results will look like this:

```
$ crystal spec
........................................................

Finished in 8.28 milliseconds
56 examples, 0 failures, 0 errors, 0 pending
```

All built-in, no external libraries needed.

And 8 milliseconds to run the entire test suite of a micro web framework? Not too shabby. If you add up start up time for the executable, it still is around 1 second of total running time. Pretty impressive.

### Conclusion

Crystal is not meant to be a Ruby replacement like JRuby. So it will never run existing and complicated Ruby projects such as Ruby on Rails or even Sinatra for that matter.

To me Crystal fills a gap in some use cases where I would use Rust or Go. It has the raw performance of an LLVM-optimized native binary, a reasonably fast Go-like concurrency system (and much faster and less resource intensive than Node.js), and the added benefit of a much more enjoyable Ruby-like syntax set.

You can even start experimenting with Crystal to build Ruby native extensions without the need of FFI and without having to write C. There is an attempt [port of ActiveSupport](https://github.com/startram/activesupport.cr) as a native extension to MRI Ruby, written as a proof of concept in Crystal.

If you're a Rubyist you will find yourself pretty much at home with most of the standard library. You will miss a thing or two but most of the time it will feel like Ruby. The [official Guide](http://crystal-lang.org/docs) is  good enough to get started and there is a comprehensive [API documentation](http://crystal-lang.org/api) just to check if that favorite Ruby API is there or not, and if not what the replacements are. Most of the time you will think _"hmm, in Ruby I would use Enumerator#each ... and yes, sure enough, there is Enumerator#each as expected."_ The API documentation could use some more love, so if you want to contribute this is a good place to start.

If you want to check out a curated list of Crystal libraries and application, go straight to ["Awesome Crystal"](http://awesome-crystal.com/). You can also see the more dynamic ["Trending Projects in Github"](https://github.com/trending/crystal).

For the most part, your proficiency in Ruby will payoff to build small systems where raw performance and concurrency are really necessary. This is exactly the use case for Mike Perham's port of [Sidekick.cr](https://github.com/mperham/sidekiq.cr). Say you have gigabytes of files to crunch. Or you have thousands of external websites to crawl, parse and organize. Or you have petabytes of data in your database waiting to be number crunched. Those are tasks that MRI Ruby won't help but Crystal may well be the quick answer.

You can even get one of the many micro web frameworks such as Kemal and deploy your HTTP API providers [directly to Heroku](http://crystal-lang.org/2016/05/26/heroku-buildpack.html) now. This will give you Go-levels of performance, and this is **very** compelling for me as I really also dislike Go's archaic smelling syntax.

So, Rust, Go, Javascript, all very fast, but with very questionable syntaxes and not so enjoyable. They are way more mature, and their ecosystems are much larger. But unless I really need to, I'd rather choose Crystal for the use cases I described above, and I think you will find some good use for it too.

Update: after I posted, the creator of Crystal, @Asterite had a few things to add as well:

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr"><a href="https://twitter.com/AkitaOnRails">@AkitaOnRails</a> <a href="https://twitter.com/waj">@waj</a> so it&#39;s likely that we&#39;ll have something similar. We aren&#39;t there yet because we are not Google, Mozilla nor Apple</p>&mdash; Ary Borenszweig (@asterite) <a href="https://twitter.com/asterite/status/737778080085868545">May 31, 2016</a></blockquote>

<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
