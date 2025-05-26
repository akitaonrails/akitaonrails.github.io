---
title: "[Manga-Downloadr] Improving the Crystal/Ruby from bursts to pool stream"
date: '2016-06-07T17:13:00-03:00'
slug: manga-downloadr-improving-the-crystal-ruby-from-bursts-to-pool-stream
tags:
- manga-downloadr
- crystal
- jruby
draft: false
---

Yesterday [I posted](http://www.akitaonrails.com/2016/06/06/manga-downloadr-porting-from-crystal-to-ruby-and-a-bit-of-jruby) how I build a new implementation of the Manga Reader Downloader in Crystal, ported to Ruby, tested on JRuby and compared against Elixir. Just to recap, these were the results to fetch chapters, pages and image links of a sample manga:

* MRI Ruby 2.3.1: 57 seconds
* JRuby 9.1.1.0: 45 seconds
* Crystal 0.17.0: 59 seconds
* Elixir: 14 seconds

I also said how it was an unfair comparison as the Elixir version uses a different - and obviously more efficient - algorithm.

It was the "first-version-that-worked" so I decided to go ahead and improve the implementations. In the Ruby/JRuby version I added the [thread](https://github.com/meh/ruby-thread) gem to have a good enough implementation of a Thread pool that works for Ruby and JRuby. I probably should have used Concurrent-Ruby but I was having some trouble to make FixedThreadPool to work.

Anyway, now all versions will have a constant pool of requests running and we can make a better comparison.

Another thing that may have skewed the results against Crystal is that it seems to have a [faulty DNS resolver](https://github.com/crystal-lang/crystal/issues/2660) implementation, so for now I just added the Manga Reader IP address directly to my `/etc/hosts` file to avoid `getaddrinfo: Name or service not known` exceptions.

To begin, let's test the same Elixir implementation, and as expected the result is still the same:

---
11,49s user 0,82s system 77% cpu 15,827 total
---

Now, the MRI Ruby with the "batch burst" algorithm was taking 57 seconds and this new implementation using a ThreadPool runs much better:

---
12,67s user 0,92s system 50% cpu 27,149 total
---

In Crystal, it's a bit more complicated as there is no way to implement the equivalent of a "Fiber Pool". What we have to do is do an infinite loop until the last process signals a loop break. Within the loop we create a maximum number of fibers, wait for each one to signal that it finished through an individual channel and loop again to create a new fiber, and so on. Compared to yesterday's 59 seconds, this is much better:

---
5,29s user 0,33s system 26% cpu 21,166 total
---

The JRuby version is not so fast though. Still better than yesterday's 45 seconds but now it's losing even to MRI:

---
49,24s user 1,41s system 146% cpu 34,602 total
---

I tried to use the `--dev` flag for [faster start up time](https://github.com/jruby/jruby/wiki/Improving-startup-time) and it does improve a bit, getting it closer to MRI:

---
22,26s user 0,99s system 76% cpu 30,320 total
---

Not sure if it can be improved more though, any tips are welcome - don't forget to comment below.

So, Elixir is still at least twice as fast than Crystal at this point. But this also demonstrates how a different algorithm does make a huge difference where it matters. I can probably tweak it a bit more but this should suffice for now.

### Changing the Ruby implementation to use ThreadPool

--- ruby
require "thread/pool"

module MangaDownloadr
  class Concurrency
    ...
    def fetch(collection, &block)
      pool    = Thread.pool(@config.download_batch_size)
      mutex   = Mutex.new
      results = []

      collection.each do |item|
        pool.process {
          engine  = @turn_on_engine ? @engine_klass.new(@config.domain) : nil
          reply = block.call(item, engine)&.flatten
          mutex.synchronize do
            results += ( reply || [] )
          end
        }
      end
      pool.shutdown

      results
    end
    ...
---

The idea is that we will have a fixed number of spawn native threads (in this case, determined by `@config.download_batch_size`). As one thread finishes it will pop a new link from the `collection` Array, essentially working as a "queue" to be depleted.

The results are accumulated in the `results` Array. Because many threads may want to modify it at once we have to synchronize access through a Mutex.

This way we always have a fixed amount of workers performing requests constantly instead of slicing the `collection` Array and doing bursts as in the previous version.

### Changing the Crystal implementation to simulate a Fibers Pool

The Crystal version became a bit more complicated as I didn't find a pool library to pull. I found a rough implementation of a pool in [this stackoverflow post](http://stackoverflow.com/a/30854065/1529907) and I was able to implement an improved version into a new shard so you can take advantage of it in your projects. Check out the source code at [akitaonrails/fiberpool](https://github.com/akitaonrails/fiberpool). This is how I added it to my project:

--- yaml
dependencies:
  ...
  fiberpool:
    github: akitaonrails/fiberpool
---

And this is how I used it. Notice that the logic itself is very close to the MRI Ruby version, but using a "Fiber Pool" instead of a Thread Pool.

--- ruby
require "fiberpool"

module CrMangaDownloadr
  struct Concurrency
    def initialize(@config : Config, @turn_on_engine = true); end

    def fetch(collection : Array(A)?, engine_class : E.class, &block : A, E? -> Array(B)?) : Array(B)
      results = [] of B
      if collection
        pool = Fiberpool.new(collection, @config.download_batch_size)
        pool.run do |item|
          engine = if @turn_on_engine
                     engine_class.new(@config.domain, @config.cache_http)
                   end
          if reply = block.call(item, engine)
            results.concat(reply)
          end
        end
      end
      results
    end
  end
end
---

But again, this is very I/O intensive and both the Ruby and Crystal versions take advantage of the fact that they can do more work while waiting for one HTTP request to finish.

<a name="reproducing-tests"> </a>

### Reproducing the Tests

I implemented a "Test Mode" in all 3 implementations. You can clone from my repositories:

* [Crystal version](https://github.com/akitaonrails/cr_manga_downloadr)
* [Ruby/JRuby version](https://github.com/akitaonrails/manga-downloadr)
* [Elixir version](https://github.com/akitaonrails/ex_manga_downloadr)

And you can run the test mode like this:

---
# crystal:
time ./cr_manga_downloadr --test

# MRI:
time bin/manga-downloadr --test

# JRuby (you have to edit Gemfile to uncomment the JRuby engine):
time jruby --dev -S bin/manga-downloadr --test

# Elixir:
time ./ex_manga_downloadr --test
---

This will run only the fetching of chapters, pages and image links, skipping the actual downloading of the images, optimization through mogrify and PDF compilation. Those skipped parts take too long and don't say anything about the tested languages.

And if you want to test just the CPU intensive parts and avoid all networking interference altogether, you can turn on HTTP Cache mode and run the tests twice so the first run will cache everything first, like this:

---
# crystal:
time ./cr_manga_downloadr --test --cache

# MRI:
time bin/manga-downloadr --test --cache

# JRuby (you have to edit Gemfile to uncomment the JRuby engine):
time jruby --dev -S bin/manga-downloadr --test --cache

# Elixir:
time CACHE_HTTP=true ./ex_manga_downloadr --test
---

So, **with all requests already cached** these are the results:

Elixir:

---
7,13s user 0,24s system 331% cpu 2,227 total
---

MRI Ruby:

---
5.590000   0.180000   5.770000 (  5.678714)
5,87s user 0,21s system 101% cpu 5,996 total
---

JRuby:

---
10.580000   0.180000  10.760000 (  3.184472)
14,54s user 0,44s system 262% cpu 5,716 total
---

Crystal:

---
1.610000   0.050000   1.660000 (  1.344123)
1,62s user 0,06s system 124% cpu 1,350 total
---

The Ruby/JRuby/Crystal versions have internal benchmarks to take away startup time (this is why they have 2 lines of times).

So, Elixir is very fast. It takes roughly 2 seconds to parse all the 1,900 HTML files to find the links.

Ruby is the slowest, obviously. It takes almost 6 seconds.

The JRuby version also takes almost 6 seconds but internally it processes in 3 seconds, the rest is startup time and warming up of the JVM underneath.

And Crystal is the fastest, as you would expect because it's  a super otimized binary doing CPU bound operations, clocking in at a bit more than 1 second.

### Conclusion

Even though the algorithms are roughly similar, Elixir is still winning by a very large margin in the total process (with the external HTTP requests).

There is more than just interpreter/compiler speeds, there is more than single-thread, multi-thread, fibers infrastructure.

We also have the maturity of the respective standard libraries (including TCP stack, HTTP client libraries, String/Array/Regex operations, etc) and 3d party libraries (libXML, Nokogiri, etc). So there is a lot that can interfere to the tests. I'd guess that Crystal's standard library, specially the networking parts, are not battle tested enough at this point (pre 1.0!).

So, the summary with the new results is this:

* MRI Ruby 2.3.1: 27 seconds
* JRuby 9.1.1.0: 30 seconds
* Crystal 0.17.0: 21 seconds
* Elixir: 15 seconds

Let me know if you have ideas to make them even faster!
