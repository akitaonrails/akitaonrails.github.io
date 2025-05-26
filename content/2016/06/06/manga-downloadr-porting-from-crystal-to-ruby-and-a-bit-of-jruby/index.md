---
title: "[Manga-Downloadr] Porting from Crystal to Ruby (and a bit of JRuby)"
date: '2016-06-06T18:06:00-03:00'
slug: manga-downloadr-porting-from-crystal-to-ruby-and-a-bit-of-jruby
tags:
- manga-downloadr
- crystal
- jruby
draft: false
---

I have this old pet project of mine called [Manga Downloadr](http://www.akitaonrails.com/2014/12/17/small-bites-downloader-para-mangareader-kindle-edition) that I published in 2014. It was a very rough version. I was experimenting with Typhoeus asynchronous requests and in the end the code ended up becoming super messed up.

The nature of the original Manga Downloader is no different from a web crawler, it fetches HTML pages, parses them in order to find collections of links and keeps fetching until a set of images are downloaded. Then I organize them in volumes, optimize them to fit the Kindle screen resolution, and compile them down into PDF files. This makes this project an interesting exercise in trying to make concurrent HTTP requests and process the results.

A year later I was learning Elixir. The Manga Downloadr was a nice candidate for me to figure out how to implement the same thing in a different language. You can follow my learning process in [this series of posts](http://www.akitaonrails.com/exmangadownloadr).

Finally, I've been learning more about Crystal, a Ruby-inspired platform that can compile Ruby-like source code into LLVM-optimized native binaries. And as a bonus it features a Go-like CSP channels and fibers to allow for concurrent code.

So I adapted my Elixir version to Crystal and the result is this code you can find over Github as [akitaonrails/cr_manga_downloadr](https://github.com/akitaonrails/cr_manga_downloadr).

It works very well and performs really fast, limited mainly by how many requests MangaReader can respond concurently and the speed/reliability of the Internet connection. So, as my original Ruby version was terrible code, it was a good time to rewrite it. And as Crystal is surprisingly close to Ruby I decided to port it over.

> The port was almost too trivial

It was mostly copying and pasting the Crystal code without the Type annotations. And I had to replace the lightweight Fibers and Channel implementation for concurrency over to traditional Ruby Threads.

The new version 2.0 for the Ruby version of the tool can be found in this Github repository: [akitaonrails/manga-downloadr](https://github.com/akitaonrails/manga-downloadr).

### Ruby, Ruby everywhere!

Moving between Ruby and Crystal is not so difficult. The Crystal team did a fantastic job implementing a very solid Standard Library (stdlib) that very closely resembles MRI Ruby's.

For example, let's compare a snippet from my Crystal version first:

--- ruby
def fetch(page_link : String)
  get page_link do |html|
    images = html.xpath("//img[contains(@id, 'img')]").as(XML::NodeSet)
    image_alt = images[0]["alt"]
    image_src = images[0]["src"]
    if image_alt && image_src
      extension      = image_src.split(".").last
      list           = image_alt.split(" ").reverse
      title_name     = list[4..-1].join(" ")
      chapter_number = list[3].rjust(5, '0')
      page_number    = list[0].rjust(5, '0')
      uri = URI.parse(image_src)
      CrMangaDownloadr::Image.new(uri.host as String, uri.path as String, "#{title_name}-Chap-#{chapter_number}-Pg-#{page_number}.#{extension}")
    else
      raise Exception.new("Couldn't find proper metadata alt in the image tag")
    end
  end
end
---

Now let's check the ported Ruby version:

--- ruby
def fetch(page_link)
  get page_link do |html|
    images = html.css('#img')

    image_alt = images[0]["alt"]
    image_src = images[0]["src"]

    if image_alt && image_src
      extension      = image_src.split(".").last
      list           = image_alt.split(" ").reverse
      title_name     = list[4..-1].join(" ")
      chapter_number = list[3].rjust(5, '0')
      page_number    = list[0].rjust(5, '0')

      uri = URI.parse(image_src)
      Image.new(uri.host, uri.path, "#{title_name}-Chap-#{chapter_number}-Pg-#{page_number}.#{extension}")
    else
      raise Exception.new("Couldn't find proper metadata alt in the image tag")
    end
  end
end
---

It's uncanny how similar they are, down to stdlib calls such as `URI.parse` or Array methods such as `split`.

> Once you remove the Type annotations from the Crystal version, it's 99% Ruby.

Ruby doesn't care if you're trying to call a method in a Nil object - at source code compiling time. Crystal does compile-time checkings and if it feels like the method call will be over Nil, it won't even compile. So this is one big win to avoid subtle bugs.

In Rails we are used to the dared `#try` method. Ruby 2.3 introduced the [safe navigation operator](http://mitrev.net/ruby/2015/11/13/the-operator-in-ruby/).

So, in Ruby 2.3 with Rails, both of the following lines are valid:

--- ruby
obj.try(:something).try(:something2)
obj&.something&.something2
---

In Crystal we can do the following:

--- ruby
obj.try(&.something).try(&.something2)
---

So, it's close. Use with care.

As I mentioned before, Crystal is close to Ruby but it's not meant to be compatible, so we can't just load Rubygems without porting. In this example I don't have Nokogiri to parse the HTML. But this is where the stdlib shines: Crystal comes with a good enough XML/HTML and JSON parsers. So we can parse HTML as XML and use plain XPath instead.

Instead of Ruby's `Net::HTTP` we have `HTTP::Client` (but their methods and semantics are surprisingly similar).

There are other differences, for example, this is the main file that requires all the others in Ruby:

--- ruby
...
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")

require "manga-downloadr/records.rb"
require "manga-downloadr/downloadr_client.rb"
require "manga-downloadr/concurrency.rb"
require "manga-downloadr/chapters.rb"
require "manga-downloadr/pages.rb"
require "manga-downloadr/page_image.rb"
require "manga-downloadr/image_downloader.rb"
require "manga-downloadr/workflow.rb"
---

And this is the Crystal version of the same manifest:

--- ruby
require "./cr_manga_downloadr/*"
...
---

On the other hand, we need to be a bit more explicit in each Crystal source code file, and declare the specific dependencies where needed. For example, in the `pages.cr` file it starts like this:

--- ruby
require "./downloadr_client"
require "xml"

module CrMangaDownloadr
  class Pages < DownloadrClient(Array(String))
  ...
---

Crystal has less room for "magic" but it's able to maintain a high level of abstraction anyway.

### A Word about Types

> We can spend the next decade masturbating over all there is about Types, and it will be extremelly boring.

The only thing you must understand: the compiler must know the method signature of classes before you can use them. There is no Runtime component that can introspect objects on the fly, like in Ruby and other dynamic languages (even Objective-C/Swift can do more dynamic stuff than Crystal).

Most of the time the Crystal compiler will be smart enough to infer the types for you, so you don't need to be absolutely explicit. You should follow the compiler's lead to know when to use Type Annotations.

What may really scare you at first is the need for Type Annotations, to understand Generics and so forth. The compiler will print out every scary error dumps that you will need to get used to. Most scary errors will usually be a Type Annotation missing or you trying to call a method over a possible Nil object.

For example, if I change the following line in the `page_image_spec.cr` test file:

--- ruby
# line 8:
image = CrMangaDownloadr::PageImage.new("www.mangareader.net").fetch("/naruto/662/2")

# line 10:
# image.try(&.host).should eq("i8.mangareader.net")
image.host.should eq("i8.mangareader.net")
---

The commented out line recognizes that the `image` instance might come as Nil, so we add an explicit `#try` call in the spec.

If we try to compile without this recognition, this is the error the compiler will dump on you:

---
$ crystal spec                                                        [
Error in ./spec/cr_manga_downloadr/page_image_spec.cr:10: undefined method 'host' for Nil (compile-time type is CrMangaDownloadr::Image?)

    image.host.should eq("i8.mangareader.net")
          ^~~~

=============================================================================

Nil trace:

  ./spec/cr_manga_downloadr/page_image_spec.cr:8

        image = CrMangaDownloadr::PageImage.new("www.mangareader.net").fetch("/naruto/662/2")
...
---

There is a large stacktrace dump after that snippet above, but you only need to pay attention to the first few lines that already says what's wrong: "undefined method 'host' for Nil (compile-time type is CrMangaDownloadr::Image?)". If you know how to read, you shouldn't have any problems most of the time.

Now, the `Chapters`, `Pages`, `PageImage` (all subclasses of `DownloadrClient`) are basically the same thing: they do `HTTP::Client` requests.

This is how the `Pages` class is implemented:

--- ruby
...
module CrMangaDownloadr
  class Pages < DownloadrClient(Array(String))
    def fetch(chapter_link : String)
      get chapter_link do |html|
        nodes = html.xpath_nodes("//div[@id='selectpage']//select[@id='pageMenu']//option")
        nodes.map { |node| [chapter_link, node.text as String].join("/") }
      end
    end
  end
end
---

`#get` is a method from the `DownloadrClient` superclass that receives a String `chapter_link` and a block. The block receives a parsed `html` collection of nodes and we can play with it, return an Array of Strings.

That's why we have the `(Array(String))` when inheriting from `DownloadrClient`. Let's see how the `DownloadrClient` superclass is implemented.

--- ruby
module CrMangaDownloadr
  class DownloadrClient(T)
    ...
    def get(uri : String, &block : XML::Node -> T)
      response = @http_client.get(uri)
      case response.status_code
      when 301
        get response.headers["Location"], &block
      when 200
        parsed = XML.parse_html(response.body)
        block.call(parsed)
      end
      ...
    end
  end
end
---

You can see that this class receives a Generic Type and it uses it as the return type for the yielded block in the `#get` method. The `XML::Node -> T` is the declaration of the signature for the block, sending `XML::Node` and receiving whatever the type `T` is. At compile time, imagine this `T` being replaced by `Array(String)`. That's how you can create classes that can deal with any number of different Types without having to overloading for polymorphism.

If you come from Java, C#, Go or any other modern static typed language, you probably already know what a Generic is.

You can go very far with Generics, check out how our `Concurrency.cr` begins:

--- ruby
class Concurrency(A, B, C)
  ...
  def fetch(collection : Array(A)?, &block : A, C? -> Array(B)?) : Array(B)?
    results = [] of B
    collection.try &.each_slice(@config.download_batch_size) do |batch|
      engine  = if @turn_on_engine
                  C.new(@config.domain)
                end
      channel = Channel(Array(B)?).new
      batch.each do |item|
      ...
---

And this is how we use it in the `workflow.cr`:

--- ruby
private def fetch_pages(chapters : Array(String)?)
  puts "Fetching pages from all chapters ..."
  reactor = Concurrency(String, String, Pages).new(@config)
  reactor.fetch(chapters) do |link, engine|
    engine.try( &.fetch(link) )
  end
end
---

In this example, imagine `A` being replaced by `String`, `B` also being replaced by `String` and C being replaced by `Pages` in the `Concurrency` class.

This is the "first-version-that-worked" so it's probably not very idiomatic. Either this could be solved with less Generics exercizing or maybe I could simplify it with the use of Macros. But it's working quite ok as it is.

The pure Ruby version ends up just like this:

--- ruby
class Concurrency
  def initialize(engine_klass = nil, config = Config.new, turn_on_engine = true)
    ...
  end
  def fetch(collection, &block)
    results = []
    collection&.each_slice(@config.download_batch_size) do |batch|
      mutex   = Mutex.new
      threads = batch.map do |item|
      ...
---

This version is much "simpler" in terms of source code density. But on the other hand we would have to test this Ruby version a lot more because it has many different permutations (we even inject classes through `engine_klass`) that we must make sure responds correctly. In practice we should add tests for all combinations of the initializer's arguments.

In the Crystal version, because all types have been checked at compile-time, it was more demanding in terms of annotations; but we can be pretty sure that if it compiles, it will run as expected.

> I'm not saying that Crystal doesn't need any specs.

Compilers can only go so far. But how much is "so far"? Whenever you're "forced" to add Type Annotations, I will state that those parts are either trying to be too smart or they are intrinsically complex. Those are parts that would require extra levels of tests in Ruby and, if we can add the annotations properly, we can have less tests (we don't need to cover most permutations) in the Crystal version (exponencial complexity of permutations could go down to a linear complexity, I think).

### A Word about Ruby Threads

The main concepts you must understand about concurrency in Ruby is this:

* MRI Ruby has a GIL, a Global Interpreter Lock, that forbids code to run concurrently.
* MRI Ruby does have access and exposes native Threads since version 1.9. But even if you fire up multiple Threads, they will run sequentially because only one thread han hold the Lock at a time.
* I/O operations are the exception: they do release the Lock for other threads to run while the operation is waiting to complete. The OS will signal the program through OS level poll.

This means that if your app is **I/O intensive** (HTTP requests, File reads or writes, socket operations, etc), you will have _some_ concurrency. A web server, such as Puma for example, can take some advantage of Threads because a a big part of the operations are involve receiving HTTP requests and sending HTTP responses over the wire, which would make the Ruby process idle while waiting.

If your app is CPU intensive (heavy algorithms, data crunching, stuff that really make the CPU hot) then you can't take advantage of native Threads, only one will run at a time. If you have multiple cores in your CPU, you can Fork your process to the number of cores available.

You should check out [grosser/parallel](https://github.com/grosser/parallel) to make it easy.

This is why Puma also has a "worker" mode. "Worker" is the name we usually give to forked children of processes.

In the case of this downloader process, it will perform thousands of HTTP requests to scrap the needed metadata from the MangaReader pages. So it's definitely much more I/O intensive than CPU intensive (the CPU intensive parts are the HTML parsing and later the image resizing and PDF compiling).

A sequential version of what has to be done, in Ruby, looks like this:

--- ruby
def fetch_sequential(collection, &block)
  results = []
  engine  = @turn_on_engine ? @engine_klass.new(@config.domain) : nil
  collection&.each_slice(@config.download_batch_size) do |batch|
    batch.each do |item|
      batch_results = block.call(item, engine)&.flatten
      results += ( batch_results || [])
    end
  end
  results
end
---

If we have 10,000 links in the `collection`, we first slice it to what `@config.download_batch_size` and we iterate over those smaller slices, calling some block and accumulating the results. This is naive algorithm, as you will find out in the next section, but bear with me.

In Elixir you can fire up micro-processes to make the HTTP requests in parallel. In Crystal you can fire up Fibers and wait for the HTTP requests to complete and signal the results through Channels.

Both are lightweight ways and you can have hundreds or even thousands running in parallel. Manga Reader will probably complain if you try that many at once, so the limit is not in the code, but in the external service.

To transform the sequential version in a concurrent one, this is what we can do in Crystal:

--- ruby
def fetch(collection : Array(A)?, &block : A, C? -> Array(B)?) : Array(B)?
  results = [] of B
  collection.try &.each_slice(@config.download_batch_size) do |batch|
    channel = Channel(Array(B)?).new
    batch.each do |item|
      spawn {
        engine  = if @turn_on_engine
                    C.new(@config.domain)
                  end
        reply = block.call(item, engine)
        channel.send(reply)
        engine.try &.close
      }
    end
    batch.size.times do
      reply = channel.receive
      if reply
        results.concat(reply.flatten)
      end
    end
    channel.close
    puts "Processed so far: #{results.try &.size}"
  end
  results
end
---

Fetching a huge collection and slicing it in smaller 'batches' is easy. Now we have a smaller `batch` collection. For each item (usually an URI) we `spawn` a Fiber and call a block that will request and process the results. Once it's finished processing it sends the results over a `channel`.

Once we finish iterating over the batch and spawning that many Fibers we can "wait" for them by doing `channel.receive`, which will start receiving results as soon as the Fibers finish requesting/processing each URI.

We accumulate the results and go over the next batch of the collection until finished. The amount of concurrency is determined by the size of the batch (it's like [what I did with 'poolboy' over Elixir](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue) where we start a fixed number of processes to run in parallel and avoid doing a Denial of Service to Manga Reader).

By the way, this Crystal implementation is similar to what you would do if you were in Go, using Channels.

In the Ruby version you can fire up native Threads - which has a lot of overhead to spawn! - and assume the HTTP requests will run almost all in parallel. Because it's I/O intensive, you can have them all in parallel. This is what it looks like:

--- ruby
def fetch(collection, &block)
  results = []
  collection&.each_slice(@config.download_batch_size) do |batch|
    mutex   = Mutex.new
    threads = batch.map do |item|
      Thread.new {
        engine  = @turn_on_engine ? @engine_klass.new(@config.domain) : nil
        Thread.current["results"] = block.call(item, engine)&.flatten
        mutex.synchronize do
          results += ( Thread.current["results"] || [] )
        end
      }
    end
    threads.each(&:join)
    puts "Processed so far: #{results&.size}"
  end
  results
end
---

Threads are all initialized in a "paused" state. Once we instantiate those many Threads, we can `#join` on each of them and await for them all to finish.

Once each Thread finishes the same URI request/process, the results must be accumulated in a global storage, in this case a simple array called `results`. But because we might have the chance of 2 or more threads trying to update the same array, we might as well synchronize the access (I'm not sure if Ruby's Array access is already synchronized, but I guess not). To synchronize access we use a Mutex, which is a fine-grained lock, to make sure only 1 thread can modify the global array at once.

To prove that Ruby can support concurrent I/O operations, I have added 2 methods to the `Concurrent` class, the first is just `#fetch` and it's the Thread implementation above. The second is called `#fetch_sequential` and it is the sequential version also shown at the beginning of this section. And I added the following spec:

--- ruby
it "should check that the fetch implementation runs in less time than the sequential version" do
  reactor = MangaDownloadr::Concurrency.new(MangaDownloadr::Pages, config, true)
  collection = ["/onepunch-man/96"] * 10
  WebMock.allow_net_connect!
  begin
    concurrent_measurement = Benchmark.measure {
      results = reactor.fetch(collection) { |link, engine| engine&.fetch(link) }
    }
    sequential_measurement = Benchmark.measure {
      results = reactor.send(:fetch_sequential, collection) { |link, engine| engine&.fetch(link) }
    }
    /\((.*?)\)$/.match(concurrent_measurement.to_s) do |cm|
      /\((.*?)\)/.match(sequential_measurement.to_s) do |sm|
        # expected for the concurrent version to be close to 10 times faster than sequential
        expect(sm[1].to_f).to be > ( cm[1].to_f * 9 )
      end
    end
  ensure
    WebMock.disable_net_connect!
  end
end
---

Because it uses WebMock, I first disable it during this spec. I create a fake collection of 10 real links to MangaReader. And then I benchmark the Thread-based concurrent version and the plain sequential version. Because we have 10 links and they are all the same you can assume that the sequential version will be almost **10 times slower** than the Thread-based version. And this is exactly what this spec compares and proves (the spec fails if the concurrent version is not at least 9x faster).

To compare all versions of the Manga Downloadrs I let download an compile an entire manga collection, in this case one "One-Man Punch", which has almost **1,900 pages/images**. I am just measuring the fetching and scrapping processes and skipping the actual image downloading, image resizing and PDF generation as they take the majority of the time and the resizing and PDF part are all done by ImageMagick's mogrify and convert tools.

This is how long this new Ruby version takes to fetch and scrap almost 1,900 pages (using MRI Ruby 2.3.1):

---
12,42s user 1,33s system 23% cpu 57,675 total
---

This is how long the Crystal version takes:

---
4,03s user 0,40s system 7% cpu 59,207 total
---

Just for fun I tried to run the Ruby version under JRuby 9.1.1.0. To run with JRuby just add the following line in the `Gemfile`:

--- ruby
ruby "2.3.0", :engine => 'jruby', :engine_version => '9.1.1.0'
---

Bundle install, run normally, and this is the result:

---
47,80s user 1,99s system 108% cpu 45,967 total
---

And this is how long the Elixir version takes:

---
11,38s user 1,04s system 85% cpu 14,590 total
---

### Reality Check!

If you just look at the times above you might get to the wrong conclusions.

First of all, it's an **unfair comparison**. The Elixir version uses a very different algorithm than the Ruby and Crystal versions.

In Elixir I boot up a pool of processes, around 50 of them. Then I start 50 HTTP requests at once. Once each process finishes, it releases itself back to the pool and I can fire up another HTTP request from the queue of links. So it's a **constant stream** of at most 50 HTTP requests, constantly.

The Crystal and Ruby/JRuby versions slice the 1,900 links into batches of 40 links and then I fire up 40 requests at once. This implementation waits all 40 to finish and they fire up another 40. So it's never a constant stream, it's bursts of 40 requests. So each batch is slowed down by the slowest request in the batch, not giving a chance for other requests to go through.

It's a difference in architecture. Elixir makes it much easier to do streams and Crystal, with it's CSP style, makes it easier to do bursts. A better approach would be to queue up the 1,900 links and use something like Sidekiq.cr to go over one link at a time (spawning 40 fibers to serve as a "pool", for example).

The Elixir version has a better efficient architecture, which is why it takes no more than 15 seconds to fetch all the image links while the Crystal version takes almost a full minute to finish (the accumulation of the slowest requests in each batch).

Now, you will be surprised that the Crystal version is actually a bit slower than the Ruby version! And you won't be too surprised to see JRuby being faster at 45 seconds!

This is another evidence that you should not dismiss Ruby (and that you should try JRuby more often). As I explained before, it does support concurrency in I/O operations and the applications I tested are all I/O heavy.

The difference is probably in the maturity of Ruby's `Net::HTTP` library against Crystal's `HTTP::Client`. I tried many tweaks in the Crystal version but I couldn't get much faster. I tried to do larger batches, but for some reason the applications just hangs, pauses, and never releases. I have to Ctrl-C out of it and retry until it finally goes through. If someone knows what I am doing wrong, please don't forget to write in the comments section below.

Some of this is probably due to MangaReader's unreliable servers, they probably have some kind of DoS preventions, throttling connections or something like this.

Anyway, when they go through, because the Ruby and Crystal algorithm are essentially the same, they take roughtly the same time to complete. So what's missing is for me to evolve this algorith to either use something like Sidekiq or implement an internal queue/pool of workers scheme.

### Conclusion

The goal of this experiment was to learn more of Crystal's ability and how easy would it be to go back and forth with Ruby.

As you can see, there are many differences, but it's not so difficult. I may be missing something, but I stumbled upon some difficulties when pushing `HTTP::Client` + Fibers too hard, as I explained above. If you know what I am doing wrong, please let me know.

The difference between the Elixir vs Ruby/Crystal algorithms shows not just language performance differences, but also the importance of architecture and algorithms in the overall performance. This test was not conclusive, just a hint that my naive Fibers implementation needs some more work, and that Elixir's natural handling of parallel processes make it easier to achieve higher levels of parallelism.

This serves as a taste of what Crystal can do, and also that Ruby is still in the game. But also that Elixir surely is something to look close.
