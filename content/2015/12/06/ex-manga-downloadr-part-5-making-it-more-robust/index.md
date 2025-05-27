---
title: 'Ex Manga Downloadr - Part 5: Making it more robust!'
date: '2015-12-06T19:20:00-02:00'
slug: ex-manga-downloadr-part-5-making-it-more-robust
tags:
- learning
- beginner
- elixir
- exmangadownloadr
- english
draft: false
---

And there I go again. I know some of you may be bored by this tool already, but as a playground project, I still want to make this a good code. But there are 2 big problems right now.

When I was testing only with MangaReader.net as a source, everything worked almost flawlessly. But adding MangaFox in [Part 3](http://www.akitaonrails.com/2015/12/02/ex-manga-downloadr-part-3-mangafox-support), with its more restrictive rules towards scrapper tools like mine (timing out more frequently, not allowing too many connections from the same place, etc), the process just kept crashing and I had to manually restart it (the resuming features I added in [Part 4](http://www.akitaonrails.com/2015/12/03/ex-manga-downloadr-part-4-learning-through-refactoring) payed off, but it's not a reliable tool anymore).

To recap, the Workflow just organizes each step of the process. It's functions are similar to this:

```ruby
def process_downloads(images_list, directory) do
  images_list
    |> Enum.map(&Worker.page_download_image(&1, directory))
    |> Enum.map(&Task.await(&1, @await_timeout_ms))
  directory
end
```

It deals with a large list, maps over each element sending it to a Worker function to run, like this:

```ruby
def page_download_image(image_data, directory) do
  Task.async(fn ->
    :poolboy.transaction :worker_pool, fn(server) ->
      GenServer.call(server, {:page_download_image, image_data, directory}, @genserver_call_timeout)
    end, @task_async_timeout
  end)
end
```

It returns an asynchronous Task waiting for 2 things: for Poolboy to release a free process to use, and for the Worker/GenServer function to finish running inside that process. As I explained in [Part 2](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue) this is so we can limit the maximum number of connections to the external source. If we didn't have this restriction, sending tens of thousands of asynchronous requests at once, the external source would just fail them all.

First thing to bear in mind is that a "<tt>Task.async/2</tt>" links itself to the caller process, so if something goes wrong, the parent process dies as well.

The correct thing to do is to add a [Task.Supervisor](http://elixir-lang.org/docs/stable/elixir/Task.Supervisor.html) and make it deal with each Task child. To do that, we can just add the Supervisor in our supervised tree at "pool_management/supervisor.ex":

```ruby
defmodule PoolManagement.Supervisor do
  use Supervisor
  ...
  children = [
    supervisor(Task.Supervisor, [[name: Fetcher.TaskSupervisor]]),
    :poolboy.child_spec(:worker_pool, pool_options, [])
  ]
  ...
end
```

And we can replace the "<tt>Task.async/2</tt>" calls to "<tt>Task.Supervisor.async(Fetcher.TaskSupervisor, ...)</tt>" like this:

```ruby
def page_download_image(image_data, directory) do
  Task.Supervisor.async(Fetcher.TaskSupervisor, fn ->
    :poolboy.transaction :worker_pool, fn(server) ->
      GenServer.call(server, {:page_download_image, image_data, directory}, @genserver_call_timeout)
    end, @task_async_timeout
  end)
end
```

This still creates Tasks that we need to await on, and as before, if the function inside crashes, it still brings down the main process. Now my refactoring found a dead end.

This is the 2nd problem I mentioned in the beginning of the article: a **flaw in my design**.

Instead of just mapping through each element of a large list, I should have created an Agent based GenServer to keep the list as the state and make the the entire Workflow system a new supervised GenServer. If fetching one URL crashed the GenServer, its supervisor would restart it and pick up the next element in list.

But, as I am in no mood for this refactoring right now (it's Sunday afternoon) I will concentrate on a quick fix (yes, jerry-rigged patch), just so the function in the async call does not raise exceptions.

### OMG! It's a Try/Catch block!

Turns out that everything I run inside the Poolboy processes are HTTP get requests through HTTPotion. Fortunately I had already refactored every HTTPotion get call into a neat macro:

```ruby
defmacro fetch(link, do: expression) do
  quote do
    Logger.debug("Fetching from #{unquote(link)}")
    case HTTPotion.get(unquote(link), ExMangaDownloadr.http_headers) do
      %HTTPotion.Response{ body: body, headers: headers, status_code: 200 } ->
        { :ok, body |> ExMangaDownloadr.gunzip(headers) |> unquote(expression) }
      _ ->
        { :err, "not found"}
    end
  end
end
```

Now I only need to replace 1 line in this macro:

```ruby
-    case HTTPotion.get(unquote(link), ExMangaDownloadr.http_headers) do
+    case ExMangaDownloadr.retryable_http_get(unquote(link)) do
```

And define this new retryable logic in the main module:

```ruby
defmodule ExMangaDownloadr do
  require Logger

  # will retry failed fetches over 50 times, sleeping 1 second between each retry
  @max_retries  50
  @time_to_wait_to_fetch_again 1_000
  ...
  def retryable_http_get(url, 0), do: raise "Failed to fetch from #{url} after #{@max_retries} retries."
  def retryable_http_get(url, retries \\ @max_retries) when retries > 0 do
    try do
      Logger.debug("Fetching from #{url} for the #{@max_retries - retries} time.")
      response = HTTPotion.get(url, ExMangaDownloadr.http_headers)
      case response do
        %HTTPotion.Response{ body: _, headers: _, status_code: status } when status > 499 ->
          raise %HTTPotion.HTTPError{message: "req_timedout"}
        _ ->
          response
      end
    rescue
      error in HTTPotion.HTTPError ->
        case error do
          %HTTPotion.HTTPError{message: message} when message in @http_errors ->
            :timer.sleep(@time_to_wait_to_fetch_again)
            retryable_http_get(url, retries - 1)
          _ -> raise error
        end
    end
  end
  ...
end
```

I strongly [stated](http://www.akitaonrails.com/2015/12/01/the-obligatory-why-elixir-personal-take) that in Elixir we should **not** use "try/catch" blocks, but there you have it.

This is the consequence of the flaw in my initial Workflow design. If I had coded the Workflow module to be a GenServer, with each list managed by an Agent, each failed HTTPotion call would allow the supervisor to restart it and try again. Without resorting to the ugly "try/catch" code.

Maybe this will force me to write Part 6 as being the code to remove this ugly try/catch later, so consider this a **Technical Debt** to make everything work now so we can refactor later and pay the debt back.

"<tt>HTTPotion.get/2</tt>" calls can raise "HTTPotion.HTTPError" exceptions. I am catching those errors for the time being, matching the messages against a list of errors I had already, sleeping for a certain amount of time (just a heuristic to see if the external sources respond better that way) and I recurse to itself through a limited number of "retries", until it reaches zero, in which case it may even be the case that the internet connection is down or some other severe error that we would not be able to recover soon.

With this code in place, now even fetching from MangaFox, without tweaking down the POOL_SIZE, will run until the end, and this solves my needs for now. If anyone is interested in suggesting a better, GenServer based Workflow design, I would really appreciate a Pull Request.

Cheers.
