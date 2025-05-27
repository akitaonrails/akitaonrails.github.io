---
title: Ex Manga Downloader, an exercise with Elixir
date: '2015-11-18T17:26:00-02:00'
slug: ex-manga-downloader-an-exercise-with-elixir
tags:
- learning
- beginner
- elixir
- exmangadownloadr
- english
draft: false
---

**Update 11/19/15:** In this article I mention a few doubts I had, so read this and then follow through [Part 2](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue) to see how I solved it.

As an exercise (and also because I'm obviously an [Otaku](https://en.wikipedia.org/wiki/Otaku)) I [implemented](https://github.com/akitaonrails/ex_manga_downloadr/blob/master/lib/ex_manga_downloadr/mangareader/index_page.ex) a simple Elixir based scrapper for the great [MangaReader](http://www.mangareader.net/) website. One can argue if it's ok to scrap their website, and one might also argue if they providing those mangas are ok in the first place, so let's not go down this path.

I had an older version [written in Ruby](https://github.com/akitaonrails/manga-downloadr). It still works but it's in sore need of a good refactoring (sorry about that). The purpose of that version was to see if I could actually do parallel fetching and retry connections using Typhoeus.

![OnePunch Man downloaded](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/525/big_ex_manga_downloadr.png)

As I've been evolving in my studies of Elixir that tool felt like a great candidate to test my current knowledge of the platform. It would make me test:

1. Fetch and parse ad hoc content through HTTP ([HTTPotion](https://github.com/myfreeweb/httpotion) and [Floki](https://github.com/philss/floki)).
2. Test parallel/asynchronous downloads (Elixir's built-in [Task](http://elixir-lang.org/docs/stable/elixir/Task.html) module).
3. The build-in command line and [option parser](http://elixir-lang.org/docs/stable/elixir/OptionParser.html) support.
4. Basic testing through ExUnit and mocking the workflow ([Mock](https://github.com/jjh42/mock)).

The exercise was very interesting, and a scrapper is also an ideal candidate for TDD. The initial steps had to go like this:

1. Parse the main manga page to fetch all the chapter links.
2. Parse each chapter page to fetch all the individual pages.
3. Parse each page to parse the main embedded image (the actual manga page).

For each of those initial steps I did a simple unit test and the <tt>IndexPage</tt>, <tt>ChapterPage</tt> and <tt>Page</tt> modules. They have roughly the same structure, this is one example:

--- ruby
defmodule ExMangaDownloadr.MangaReader.IndexPage do
  def chapters(manga_root_url) do
    case HTTPotion.get(manga_root_url, [timeout: 30_000]) do
      %HTTPotion.Response{ body: body, headers: _headers, status_code: 200 } ->
        {:ok, fetch_manga_title(body), fetch_chapters(body) }
      _ ->
        {:err, "not found"}
    end
  end

  defp fetch_manga_title(html) do
    Floki.find(html, "#mangaproperties h1")
    |> Enum.map(fn {"h1", [], [title]} -> title end)
    |> Enum.at(0)
  end

  defp fetch_chapters(html) do
    Floki.find(html, "#listing a")
    |> Enum.map fn {"a", [{"href", url}], _} -> url end
  end
end
```

Here I am already exercising some of Elixir's awesome features such as pattern matching the result of the <tt>HTTPotion.get/2</tt> function to extract the body from the returning record.

Then I pass the HTML body to 2 different functions: <tt>fetch_manga_title</tt> and <tt>fetch_chapters</tt>. They both use the Floki package which can use CSS selectors to return a List. Then I need to walk through the list (using <tt>Enum.map/2</tt> for example) and pattern match on it to extract the values I need.

[Pattern Matching](http://elixir-lang.org/getting-started/pattern-matching.html) is one of the most important concepts to learn about Elixir/Erlang. It's different from simply assigning a value to a variable, it can be used to dismount a structure into its components and get their individual parts.

Then I just went through building the skeleton for the command line interface. This is already explained in other tutorials such as [this](http://asquera.de/blog/2015-04-10/writing-a-commandline-app-in-elixir/) and [this](https://speakerdeck.com/st23am/writing-command-line-applications-in-elixir), so I won't waste time explaining it again. At the core I needed to have the following workflow:

1. Starting from the Manga main URL at MangaReader, extract the chapters
2. Then loop through the chapters and fetch all the pages
3. Then loop through the pages and fetch all the image sources
4. Then loop through the images and download them all to a temporary directory
5. Then sort through files in the directory and move them to sub-directories of 250 images each (I think it is a good size for each volume)
6. Finally, resize and convert all the images of each sub-directory into a PDF file for my Kindle to consume.

This workflow is defined like this:

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

This is one place where the pipeline notation from Elixir really shines. It's much better than having to write this equivalent:

--- ruby
Workflow.compile_pdfs(Workflow.optimize_images(directory))
```

This notation is just syntatic sugar where the returning value of the previous statement is used as the first argument of the following function. Combine that with other syntatic sugars such as parenthesis being optional (just like beloved Ruby) and you have a clear exposure of "transforming from a URL into compiled PDFs".

I separated the Workflow into its own module and each step is very similar, each taking a list and walking through it. This the simplest of them:

--- ruby
def pages(chapter_list) do
  chapter_list
    |> Enum.map(&(Task.async(fn -> ChapterPage.pages(&1) end)))
    |> Enum.map(&(Task.await(&1, @http_timeout)))
    |> Enum.reduce([], fn {:ok, list}, acc -> acc ++ list end)
end
```

If you're new to Elixir here you will find another oddity, this <tt>"&(x(&1))"</tt>, this is just a shortcut macro to this other similar statement:

--- ruby
Enum.map(fn (list) ->
  Task.async(fn ->
    ChapterPage.pages(list)
  end)
end)
```

[Enum](http://elixir-lang.org/docs/stable/elixir/Enum.html) is one of the most useful modules you need to master. If you come from Ruby it feels like home, you must learn all of its functions. You're usually having to transform one collection into another, so it's important to study it throughly.

### A few problems understanding parallel HTTP processing (W.I.P.)

Then there is this <tt>Task.async/await</tt> deal. If you're from a language that have Threads, it's quite similar: you start several different Threads and await for all of them to return before continuing. But a Task in Elixir is not a real thread, it's ["green thread"](https://en.wikipedia.org/wiki/Green_threads#Green_threads_in_other_languages) or, in Erlang lingo, a very lightweight "process". Erlang uses processes for everything, thus does Elixir. Under the hood, the "Task" module encapsulates the entire OTP framework for supervisors/workers. But instead of having to deal right now with [OTP GenServer](http://elixir-lang.org/getting-started/mix-otp/genserver.html) I decided to go the simpler route for now, and the "Task" module accomplishes just that.

Then, I ended up with a problem. If I just kept going like this, spawning hundreds of async HTTP calls, I quickly end up with this exception:

```
17:10:55.882 [error] Task #PID<0.2217.0> started from #PID<0.69.0> terminating
** (HTTPotion.HTTPError) req_timedout
    (httpotion) lib/httpotion.ex:209: HTTPotion.handle_response/1
    (ex_manga_downloadr) lib/ex_manga_downloadr/mangareader/page.ex:6: ExMangaDownloadr.MangaReader.Page.image/1
    (elixir) lib/task/supervised.ex:74: Task.Supervised.do_apply/2
    (elixir) lib/task/supervised.ex:19: Task.Supervised.async/3
    (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
Function: #Function<12.106612505/0 in ExMangaDownloadr.Workflow.images_sources/1>
    Args: []
```

That's why there is <tt>@maximum_fetches 80</tt> at the top of the <tt>Workflow</tt> module, together with this other odd construction:

--- ruby
def images_sources(pages_list) do
  pages_list
    |> chunk(@maximum_fetches)
    |> Enum.reduce([], fn pages_chunk, acc ->
      result = pages_chunk
        |> Enum.map(&(Task.async(fn -> Page.image(&1) end)))
        |> Enum.map(&(Task.await(&1, @http_timeout)))
        |> Enum.map(fn {:ok, image} -> image end)
      acc ++ result
    end)
end
```

This gets a huge list (such as all the pages of a very long manga like Naruto), breaks it down to smaller 80 elements list and then proceed to fire up the asynchronous Tasks, reducing the results back to a plain List. The <tt>chunk/2</tt> private function just get the smaller size between the list length and the maximum fetches value.

Sometimes it breaks down if the maximum is larger, sometimes it doesn't, so my guess is my code not dealing with network instabilities (with some retry logic) or even the MangaReader site queueing up above my designated timeout (which I set to 30 seconds). Either way, keeping the maximum value lower than 100 seem to be a good balance without crashing the workflow down.

This is one part I am not entirely sure what to do to deal with uncertainties in the external website not responding or network falling down for a little while. HTTPotion has support for asynchronous calls, but I don't know what's the difference between using that or just making synchronous calls within parallel processes with Task, the way I'm doing. And in either case, they are supervised workers, how do I handle the exceptions, how should I implement logic to retry the call once it fails? If anyone has more knowledge about this, a comment below will be really appreciated.

Finally, there is one dirty trick under the reason of why I like to use MangaReader: it's very friendly to scrappers because on each page of the manga the image is annotated with an "alt" attribute with the format "[manga name] [chapter number] - [page number]". So I just had to reformat it a bit, adding a pad of zeroes before the chapter and page number so a simple sort of the downloaded files will give me the correct order. MangaFox is not so friendly. This is how to reformat it:

--- ruby
defp normalize_metadata(image_src, image_alt) do
  extension      = String.split(image_src, ".") |> Enum.at(-1)
  list           = String.split(image_alt)      |> Enum.reverse
  title_name     = Enum.slice(list, 4, Enum.count(list) - 1) |> Enum.join(" ")
  chapter_number = Enum.at(list, 3) |> String.rjust(5, ?0)
  page_number    = Enum.at(list, 0) |> String.rjust(5, ?0)
  {image_src, "#{title_name} #{chapter_number} - Page #{page_number}.#{extension}"}
end
```

Once I have all the images, I spawn another external process using [Porcelain](https://github.com/alco/porcelain) to deal with shelling out to run ImageMagick's Mogrify and Convert tools to resize all the images down to 600x800 pixels (Kindle Voyage resolution) and pack them together into a PDF file. This results in PDF files with 250 pages and around 20Mb in size. Now it is just a matter of copying the files to my Kindle through USB.

The ImageMagick code is quite boring, I just generate the commands in the following format for Mogrify:

```
"mogrify -resize #{@image_dimensions} #{directory}/*.jpg"
```

And compile the PDFs with this other command:

```
"convert #{volume_directory}/*.jpg #{volume_file}"
```

(By the way, notice the Ruby-like String interpolation we're used to.)

![OnePunch Man in Kindle](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/526/big_11249911_10153742264949837_7817568172948440418_n.jpg)

Technically I could copy the MangaReader module files into a new MangaFox module and repurpose the same Workflow logic once I tweak the parsers to deal with MangaFox page format. But I leave that as an exercise to the reader.

The MangaReader module tests do real calls to their website. I left it that way on purpose because if the test fails it means that they changed the website format and the parser needs tweaking to conform. But after a few years I never saw they changing enough to break my old Ruby parser.

Just as a final exercise I imported the Mock package, to control how some inner pieces of the Workflow implementation returns. It's called Mock but it's more like stubbing particular functions of a module. I can declare a block where I override the <tt>File.rename/1</tt> so it doesn't actually try to move a file that doesn't exist in the test environment. This makes the test more brittle because it depends on a particular implementation, which is never good, but when we are dealing with external I/O, this might be the only option to isolate. This is how the Workflow test was done. Again, if there is a better way I am eager to learn how, please comment down below.

This is how a unit test with Mock looks like, stubbing both the HTTPotion and File modules:

--- ruby
test "workflow tries to download the images" do
  with_mock HTTPotion, [get: fn(_url, _options) -> %HTTPotion.Response{ body: nil, headers: nil, status_code: 200 } end] do
    with_mock File, [write!: fn(_filename, _body) -> nil end] do
      assert Workflow.process_downloads([{"http://src_foo", "filename_foo"}], "/tmp") == [{:ok, "http://src_foo", "/tmp/filename_foo"}]
      assert called HTTPotion.get("http://src_foo", [timeout: 30_000])
      assert called File.write!("/tmp/filename_foo", nil)
    end
  end
end
```

### Conclusion

This has been a very fun experience, albeit very short, and good enough to iron out what I have learned so far. Code like this make me smile:

--- ruby
[destination_file|_rest] = String.split(file, "/") |> Enum.reverse
```

The way I can pattern match to extract the head of a list is a different way of thinking. Then there is the other most important way of thinking: everything is a transformation chain, an application is a way to start from some input argument (such as a URL) and go step by step to "transform" it into a collection of PDF files, for example.

Instead of thinking on how to architect classes and objects, we start thinking about what is the initial arguments and what is the result I want to achieve, and go from there, one small transformation function at a time.

The Workflow module is an example. I actually started writing everything in a single large function in the CLI module. Then I refactored into smaller function and chained them together to create the Workflow. Finally, I just moved all the functions into the Workflow module and called that from the CLI module.

Because of no global state, thinking in smaller and isolated small functions, both refactoring and test-driven development are much smoother than in OOP languages. This way of thinking is admitedly slow to get a grip, but then it starts to feel very natural and it quickly steers your way of programming into leaner code.

And the dynamic aspects of both Erlang and Elixir make me feel right at home, just like having an "improved Ruby".

The code of the downloader is all on [Github, please fork it](https://github.com/akitaonrails/ex_manga_downloadr/blob/master/lib/ex_manga_downloadr/mangareader/index_page.ex).

I am eager to exercise more. I hope this motivates you to learn Elixir. And if you're already an advanced programmer in Elixir or Erlang, don't forget to comment below and even send me a Pull Request to improve this small exercise. I am still a beginner and there is a lot of room to learn more. All contributions are greatly appreciated.
