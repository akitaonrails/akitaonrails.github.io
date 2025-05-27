---
title: 'Ex Manga Downloadr - Part 7: Properly dealing with large Collections'
date: '2017-06-16T15:10:00-03:00'
slug: ex-manga-downloadr-part-7-properly-dealing-with-large-collections
tags:
- beginner
- learning
- elixir
- english
- exmangadownloadr
draft: false
---

In my [previous post](http://www.akitaonrails.com/2017/06/13/ex-manga-downloadr-part-6-the-rise-of-flow) I was able to simplify a lot of the original code through the use of [Flow](https://github.com/elixir-lang/flow). But the downside is that the running time actually increased a lot.

José Valim kindly stepped in and posted a [valuable comment](http://www.akitaonrails.com/2017/06/13/ex-manga-downloadr-part-6-the-rise-of-flow#comment-3360301947), which I will paste here:

> Have you tried reducing the `@max_demand` instead? `@max_demand` is how much data you exchange between stages. If you set it to 60, it means you are sending 60 items to one stage, 60 items to the other and so on. That gives you poor balancing for small collections as there is a chance all items end-up in the same stage. You actually want to reduce `max_demand` to 1 or 2 so each stage gets small batches and request more than needed. Another parameter you usually tune is the `stages: ...` option, you should set that to the amount of connections you had in poolboy in the past.

> However, I believe you don't need to use Flow at all. Elixir v1.4 has something called [`Task.async_stream`](https://hexdocs.pm/elixir/Task.html#async_stream/5) which is a mixture of poolboy + task async, which is a definitely better replacement to what you had. We have added it to Elixir after implementing Flow as we realized you can get a lot of mileage out of `Task.async_stream` without needing to jump to a full solution like Flow. If using `Task.async_stream`, the `max_concurrency` option controls your pool size.

And, obviously, he is right. I misunderstood how Flow works. It's meant to be used when you have a bazillion items to process in parallel. Particularly processing units that can have high variance and, hence, a lot of back-pressure not only because there is a lot of items to process, but because their running times can vary dramatically. So, it's one of those cases of having a canon, but I only have a fly to kill.

What I wasn't aware is the existence of `Task.async_stream` and it's companion [`Task.Supervisor.async_stream`](https://hexdocs.pm/elixir/Task.Supervisor.html#async_stream/4) if I need to add more control.

Let's backtrack a bit.

### Dealing with collections in Elixir

Erlang is a beast. It provides all the building blocks of a real-time, highly-concurrent, operating system! Really, what it provides out of the box is way more than any other language/platform/virtual machine, ever. You don't get that much for free on Java, or .NET or anything. You have to assemble the pieces manually, spend hundreds of hours tweaking, and still pray a lot to have everything working seamlessly.

So, you have distributed systems to build? There is no other option, really. Do Erlang, or suffer in hell.

Then, Elixir steps this up a notch creating a very reasonable and simple to use standard library that makes the coding part actually enjoyable. This is a killer combo. You need to do the next Whatsapp? You need to do the next Waze? You need to rebuild Cassandra from scratch? You need to create stuff like Apache Spark? Do Elixir.

In Erlang, you need to solve everything using GenServer. It's a neat abstraction from OTP. You are [required to understand OTP](http://www.akitaonrails.com/2015/11/22/observing-processes-in-elixir-the-little-elixir-otp-guidebook) intimately. There is no shortcut here. There is no Erlang without OTP.

That said, you can start simple and scale without so much hassle.

Usually, everything starts with Collections, or more correctly, some kind of [Enumeration](https://hexdocs.pm/elixir/Enum.html#content).

Just like my simple `Workflow.pages/1` function which iterates through a list of chapter links, fetch each link, parse the returning HTML and extracts the collection of page links within that chapter, reducing the sub-lists into a full list of page links.

If I know the collection is small (less than 100 items, for example) I would just do this:

--- ruby
def pages({chapter_list, source}) do
   pages_list = chapter_list
     |> Enum.map(&Worker.chapter_page([&1, source]))
     |> Enum.reduce([], fn {:ok, list}, acc -> acc ++ list end)
   {pages_list, source}
end
```

And that's it. This is linear. It will sequentially process just one link at a time. The more chapter links, the longer it will take. Usually I want to process this in parallel. But I can't fire a parallel process for each chapter link, because if I receive 1,000 chapter links and fire them all, it will be a Denial of Service and I will certainly receive hundreds of time outs.

You can run into 2 main problems when you need to iterate through a big collection.

* If your collection is humongous (imagine a gigabyte long text file that you need to iterate line by line). For that you use [`Stream`](https://hexdocs.pm/elixir/Stream.html#content) instead of `Enum`. All functions look almost exactly the same, but you will not have to load the entire collection into memory and you will not keep duplicating it.

* If your processing unit takes a long time. Now that you solved not blowing off your memory usage, what if you have slow jobs while iterating through each item in the collection? That's our case, where the collection is rather small, but the processing time is long as it's fetching from an external source on the internet. It can take milisseconds, it can take a few seconds.

One way to control this is through the use of "batches", something along these lines:

--- ruby
def pages({chapter_list, source}) do
  pages_list = chapter_list
	|> Enum.chunk(60)
	|> Enum.map(&pages_download(&1, source))
	|> Enum.concat
  {pages_list, source}
end

def pages_download(chapter_list, source)
   results = chapter_list
     |> Enum.map(&Task.async(fn -> Worker.chapter_page([&1, source]) end))
     |> Enum.map(&Task.await/1)
     |> Enum.reduce([], fn {:ok, list}, acc -> acc ++ list end)
   {pages_list, source}, results	
end
```

This is just for the example, I have not compiled this snippet to see if it works, but you get the idea of chunking the big list and processing each chunk through `Task.async` and `Task.await`.

Again, for small lists, this should be ok (thousands) and where each item does not take too much to process.

Now, this is not very good. Because each chunk must finish before the next chunk begins. Witch is why the ideal solution is to keep a constant amount of jobs running at any given time. To that end, we need a Pool, which is what I explained in [Part 2: Poolboy to the rescue!](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue).

But implementing the proper way to keep the pool entirely filled requires some boring juggling between Poolboy transactions and `Task.Supervisor.async`. Which is why I was interested in the new `Flow` usage.

The code does come clean, but as I explained before, this is not the proper use case for Flow. It's better you have to iterate over tens of thousands of items or even infinite (you have a incoming traffic of requests in need of parallel processing, for example).

So, finally, there is a compromise. The solution between the simple `Task.async` and `Flow` is `Task.async_stream` which works like a pool implementation, where it keeps a `max_concurrency` of jobs running in a stream. The final code becomes way more elegant like this:

--- ruby
def pages({chapter_list, source}) do
  pages_list = chapter_list
    |> Task.async_stream(MangaWrapper, :chapter_page, [source], max_concurrency: @max_demand)
    |> Enum.to_list()
    |> Enum.reduce([], fn {:ok, {:ok, list}}, acc -> acc ++ list end)
  {pages_list, source}
end
```

And this is the [final commit](https://github.com/akitaonrails/ex_manga_downloadr/commit/517183261e998ab40f6e5bc793b4db9adcf899e3) with the aforementioned changes.

### Conclusion

The implementation with `Task.async_stream` is super simple and the times finally became the same as before.

```
84,16s user 20,80s system 138% cpu 1:15,94 total
```

Way better than the more than 3 minutes it was taking with Flow. And this is not because Flow is slow, it's because I was not using it correctly, probably shooting a big chunk into a single GenStage and creating a bottleneck. Again, only use Flow if you have enough items to put hundreds of them into several parallel GenStages. We are talking about collections with tens of thousands of items, not my meager pages list.

There is a small tweak though. To fetch all chapter and page links I am using a `max_concurrency` of 100. Timeout is the default at 5000 (5 seconds). That works because the returning HTML is not so big and we can parallelize that much on a high bandwidth connection.

But the images downloading procedure at `Workflow.process_downloads` I had to cut `max_concurrency` in half and increase the `timeout` up to 30 seconds to make sure it wouldn't crash.

Because this is a simple implementation there is no crash recovery and no retry routine. I would have to replace this implementation with `Task.Supervisor.async_stream` to regain some control. My original implementation was more cumbersome but I had places to add retry mechanisms. So again, it's a compromise between ease of use and control, always. The more control you have, the worse the code becomes.

This is a simple example exercise, so I will keep it at that for the time being.
