---
title: 'Ex Manga Downloadr - Part 6: The Rise of FLOW'
date: '2017-06-13T15:59:00-03:00'
slug: ex-manga-downloadr-part-6-the-rise-of-flow
tags:
- beginner
- learning
- elixir
- english
- exmangadownloadr
draft: false
---

It's been way more than a year since I posted about my pet project [Ex Manga Downloadr](https://github.com/akitaonrails/ex_manga_downloadr). Since then I just did small updates to keep up with the current Elixir and libraries versions.

As a quick recap, the exercise is that I want to web scrap from MangaReader.net, a bunch of images, organized in pages and chapters, and in the end it should compile organized PDFs so I can load them on a Kindle device.

Web scrapping, is a simple loop of HTTP GETs over a ton of URLs, scrapping the HTML, and fetching more URLs to download.

In many simple languages, people usually solve this naively in 2 ways:

* A simple nested loop. One single thread, sequencial fetches. So if you have 5,000 links and each links takes 10 seconds to fetch, it's basically 10 * 5,000 = 50,000 seconds, which is a stupid long time.
* A simple spawn of processes, fibers, threads or parallel I/O in a reactor, all at once. An attempt to paralelize all fetches at once.

Everybody probably agree that the first option is stupid. Now, the second one is tricky.

The tricky part is **CONTROL**.

Anyone in Go would say _"oh, this is easy, just put a loop and spawn a bunch of goroutines"_ or anyone in Node.js would say _"oh, this is easy, just put a loop, make the fetch - they all will run asynchronously - and add callbacks, a basic async/await."_

They're not wrong, but this is still too naive an implementation. It's trivial to trigger hundreds or thousands of parallel requests. Now, what happens if one fails and you have to retry? What happens if the MangaReader has a throttling system that will either start cutting down connections or timing them out? Or if your internet bandwidth is just not enough, and after a certain amount of requests you start having diminishing returns and time outs?

The message is: it's damn trivial to spawn parallel stuff. it's damn complicated to control paralle stuff.

This is why, in my first implementation in Elixir, I introduced a complicated implementation using a combination of a custom GenServer, Elixir's own Task infrastructure for async/await pattern, and [Poolboy](https://github.com/devinus/poolboy) to control the rate of the parallelism. This is how you control the bottleneck out to slow resources: using pools and queues (which is why every good database has a connection pool, remember [C3P0](https://sourceforge.net/projects/c3p0/)?)

This is one snippet of my older implementation:

```ruby
def chapter_page([chapter_link, source]) do
  Task.Supervisor.async(Fetcher.TaskSupervisor, fn ->
    :poolboy.transaction :worker_pool, fn(server) ->
      GenServer.call(server, {:chapter_page, chapter_link, source}, @genserver_call_timeout)
    end, @task_async_timeout
  end)
end
```

Yes, it's very ugly, and there are boilerplates for the GenServer, the custom Supervisor to initialize Poolboy and so on. And the higher level workflow code looks like this:

```ruby
def pages({chapter_list, source}) do
   pages_list = chapter_list
     |> Enum.map(&Worker.chapter_page([&1, source]))
     |> Enum.map(&Task.await(&1, @await_timeout_ms))
     |> Enum.reduce([], fn {:ok, list}, acc -> acc ++ list end)
   {pages_list, source}
end
```

So, inside the `Worker` module each public method wraps the GenServer internal calls into a `Task async` and in the collection iteration we add `Task.await` to actually wait for all parallel calls to finish, so we can finally reduce the results.

Elixir now comes with this very interesting [`GenStage`](https://elixir-lang.org/blog/2016/07/14/announcing-genstage/) infrastructure that promises to replace `GenEvent` and the use case is when you have a producer-consumer situation with back-pressure. Basically when you have slow endpoints and you would end up having to control bottlenecks.

Then, [Flow](https://github.com/elixir-lang/flow) is an easier high abstraction that you can use almost the same way you would use `Enum` in your collections, but instead of sequential mapping, it takes care of parallel traversing and control of batches. So the code is very similiar but without you having to control the parallelization controls manually.

This is the [full commit](https://github.com/akitaonrails/ex_manga_downloadr/commit/b117f5236098f6d37e332633acb787be46a09d84) where I could remove Poolboy, remove my custom GenServer, reimplement the Worker as simple module of functions and then the workflow could get rid off the async/await pattern and use Flow instead:

```ruby
def pages({chapter_list, source}) do
   pages_list = chapter_list
     |> Flow.from_enumerable(max_demand: @max_demand)
     |> Flow.map(&MangaWrapper.chapter_page([&1, source]))
     |> Flow.partition()
     |> Flow.reduce(fn -> [] end, fn {:ok, list}, acc -> acc ++ list end)
     |> Enum.to_list()
   {pages_list, source}
end
```

The only boilerplate left is the `Flow.from_enumerable()` and `Flow.partition()` wrapping the `Flow.map`, and that's it!

Notice I configured `@max_demand` to be 60. You must tweak it to be larger or smaller depending on your internet connection, you have to experiment it. By default, Flow will trigger 500 processes in parallel, which is way too much for a web scrapping on a normal home internet connection and you will suffer diminishing returns. That's what I had to do previously with Poolboy, by initiating a pool of around 60 transactions at most.

Unfortunately not everything is as straight forward as it seems. Running this new version on the test mode I get this result:

```
58,85s user 13,93s system 37% cpu 3:13,78 total
```

So a total time of more than 3 minutes, using around 37% of the available CPU.

My immediate previous version using all the shenanigans of Poolboy, Task.Supervisor, GenServer, etc still gives me this:

```
100,67s user 20,83s system 152% cpu 1:19,92 total
```

Less than **HALF** the time, albeit using all my CPU cores. So my custom implementation still uses my resources to the maximum. There is still something in the Flow implementation I didn't quite get right. I already tried to bump up the `max_demand` from 60 up to 100 but that didn't improve anything. Leaving it to the default 500 slows everything down to more than 7 minutes. 

All in all, at least it makes the implementation far easier on the eyes (hence, way easier to maintain), but either the Flow implementation has bottlenecks or I am using it wrong at this point. If you know what it is, let me know in the comments section below.
