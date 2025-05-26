---
title: 'Ex Manga Downloadr - Part 3: Mangafox Support!'
date: '2015-12-02T16:27:00-02:00'
slug: ex-manga-downloadr-part-3-mangafox-support
tags:
- learning
- beginner
- elixir
- exmangadownloadr
- english
draft: false
---

I thought [Part 2](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue) would be my last article about this tool, but turns out its just too much fun to let it go easily. As usual, all the source code is on my [Github repository](https://github.com/akitaonrails/ex_manga_downloadr). And the gist of the post is that now you can do this:

---
git pull
mix escript.build
./ex_manga_downloadr -n onepunch -u http://mangafox.me/manga/onepunch_man/ -d /tmp/onepunch -s mangafox
---

And there you go: download from Mangafox built-in! \o/

It starts when I wanted to download manga that is not available at MangaReader but exists under Mangafox.

So, the initial endeavor was to copy the MangaReader parser modules (IndexPage, ChapterPage, and Page) and paste them at a specific "lib/ex_manga_downloadr/mangafox" folder. Same thing done to the unit tests folder. Just a matter of copying and pasting the files and change the "MangaReader" module name to "Mangafox".

Of course the URL formats are different, the Floki CSS selectors are a bit different, so that's what have to change in the parser. For example, this is how I parse the chapter links from the main page at MangaReader:

--- ruby
defp fetch_chapters(html) do
  Floki.find(html, "#listing a")
  |> Enum.map fn {"a", [{"href", url}], _} -> url end
end
---

And this is the same thing but for Mangafox:

--- ruby
defp fetch_chapters(html) do
  html
  |> Floki.find(".chlist a[class='tips']")
  |> Enum.map fn {"a", [{"href", url}, {"title", _}, {"class", "tips"}], _} -> url end
end
---

Exactly the same logic but the pattern matching structure is different because the returning HTML DOM nodes are different.

Another difference is that MangaReader returns everything in plain text by default, but Mangafox returns everything Gzipped regardless if I send the "Accept-Encoding" HTTP header (curiously, if I retry several times it changes behavior and sometimes send plain text).

What I did different was to check if the returned <tt>%HTTPotion.Response{}</tt> structure had a "Content-Encoding" header set to "gzip" and if so, gunzip it using the built-in Erlang "zlib" package (nothing to import!):

--- ruby
def gunzip(body, headers) do
  if headers[:"Content-Encoding"] == "gzip" do
    :zlib.gunzip(body)
  else
    body
  end
end
---

I would've preferred if HTTPotion did that out of the box for me (#OpportunityToContribute!), but this was easy enough.

Once the unit tests were passing correctly after tuning the scrapper (HTTPotion requests) and parser (Floki selectors) it was time to make my Worker aware of the existence of this new set of modules.

The Workflow module just call the Worker, which in turn does the heavy lifting of fetching pages and downloading images. The Worker called the MangaReader module directly, like this:

--- ruby
defmodule PoolManagement.Worker do
  use GenServer
  use ExMangaDownloadr.MangaReader
  require Logger
  ...
  def chapter_page(chapter_link) do
    Task.async fn -> 
      :poolboy.transaction :worker_pool, fn(server) ->
        GenServer.call(server, {:chapter_page, chapter_link}, @timeout_ms)
      end, @transaction_timeout_ms
    end
  end
  ...
  def handle_call({:chapter_page, chapter_link}, _from, state) do
    {:reply, ChapterPages.pages(chapter_link), state}
  end
  ...
end
---

That "<tt>use ExMangaDownloadr.MangaReader</tt>" statement up above is just a macro that will alias the corresponding modules:

--- ruby
defmodule ExMangaDownloadr.MangaReader do
  defmacro __using__(_opts) do
    quote do
      alias ExMangaDownloadr.MangaReader.IndexPage
      alias ExMangaDownloadr.MangaReader.ChapterPage
      alias ExMangaDownloadr.MangaReader.Page
    end
  end
end
---

So when I call "<tt>ChapterPages.pages(chapter_link)</tt>" it's a shortcut to use the fully qualified module name like this: "<tt>ExMangaDownloadr.MangaReader.ChapterPages.pages(chapter_link)</tt>".

An Elixir module namespace is just an Atom. Nested module names have the full, dot-separated name, prefixed with it's parent. For example:

--- ruby
defmodule Foo do
  defmodule Bar do
    defmodule Xyz do
       def teste do
       end
    end
  end
end
---

You can just call "<tt>Foo.Bar.Xyz.teste()</tt>" and that's it. But there is a small trick. Elixir also transparently prefixes the full module name with "Elixir". So in reality, the full module name is "Elixir.Foo.Bar.Xyz", in order to make sure no Elixir module ever conflicts with an existing Erlang module.

This is important because of this new function I added to the Worker module first:

--- ruby
def manga_source(source, module) do
  case source do
    "mangareader" -> String.to_atom("Elixir.ExMangaDownloadr.MangaReader.#{module}")
    "mangafox"    -> String.to_atom("Elixir.ExMangaDownloadr.Mangafox.#{module}")
  end
end
---

This is how I map from "mangafox" to the new "ExMangaDownloadr.Mangafox." namespace. And because of the dynamic, message passing nature of Elixir, I can replace this code:

--- ruby
def handle_call({:chapter_page, chapter_link}, _from, state) do
  {:reply, ChapterPages.pages(chapter_link), state}
end
---

With this:

--- ruby
def handle_call({:chapter_page, chapter_link, source}, _from, state) do
  links = source
    |> manga_source("ChapterPage")
    |> apply(:pages, [chapter_link])
  {:reply, links, state}
end
---

I can now choose between the "Elixir.ExMangaDownloadr.Mangafox.ChapterPage" or "Elixir.ExMangaDownloadr.MangaReader.ChapterPage" modules, call the <tt>pages/1</tt> function and send the same argument as before. I just have to make sure I can receive a "source" string from the command line now, so I change the CLI module like this:

--- ruby
defp parse_args(args) do
  parse = OptionParser.parse(args,
    switches: [name: :string, url: :string, directory: :string, source: :string],
    aliases: [n: :name, u: :url, d: :directory, s: :source]
  )
  case parse do
    {[name: manga_name, url: url, directory: directory, source: source], _, _} -> process(manga_name, url, directory, source)
    {[name: manga_name, directory: directory], _, _} -> process(manga_name, directory)
    {_, _, _ } -> process(:help)
  end
end
---

Compared to the previous version I just added the "<tt>:source</tt>" string argument to the OptionParser and passed the captured value to <tt>process/4</tt>. I should add some validation here to avoid strings different than "mangareader" or "mangafox", but I will leave that to another time.

And in the Workflow module, instead of starting from just the manga URL, now I have to start with both the URL and the manga source:

--- ruby
[url, source]
  |> Workflow.chapters
  |> Workflow.pages
  |> Workflow.images_sources
---

Which means that each of the above functions have to not only return the new URL lists but also pass through the source:

--- ruby
def chapters([url, source]) do
  {:ok, _manga_title, chapter_list} = source
    |> Worker.manga_source("IndexPage")
    |> apply(:chapters, [url])
  [chapter_list, source]
end
---

This was the only function in the Workflow module hardcoded to MangaReader so I also make it dynamic using the same <tt>manga_source/2</tt> function from the Worker, and notice the return value being "<tt>[chapter_list, source]</tt>" instead of just "<tt>chapter_list</tt>".

And now, I can finally test with "<tt>mix test</tt>" and create the new executable command line binary with "<tt>mix escript.build</tt>" and run the new version like this:

---
./ex_manga_downloadr -n onepunch -u http://mangafox.me/manga/onepunch_man/ -d /tmp/onepunch -s mangafox
---

The Mangafox site is very unreliable to several concurrent connections and it quickly timeout sometimes, dumping ugly errors like this:

---
15:58:46.637 [error] Task #PID<0.2367.0> started from #PID<0.124.0> terminating
** (stop) exited in: GenServer.call(#PID<0.90.0>, {:page_download_image, {"http://z.mfcdn.net/store/manga/11362/TBD-053.2/compressed/h006.jpg", "Onepunch-Man 53.2: 53rd Punch [Fighting Spirit] (2) at MangaFox.me-h006.jpg"}, "/tmp/onepunch"}, 1000000)
    ** (EXIT) an exception was raised:
        ** (HTTPotion.HTTPError) connection_closing
            (httpotion) lib/httpotion.ex:209: HTTPotion.handle_response/1
---

I did not figure out how to retry HTTPotion requests properly yet. But one small thing I did was add an availability check in the Worker module. So you can just re-run the same command line and it will resume downloading only the remaining files:

--- ruby
defp download_image({image_src, image_filename}, directory) do
  filename = "#{directory}/#{image_filename}"
  if File.exists?(filename) do
    Logger.debug("Image #{filename} already downloaded, skipping.")
    {:ok, image_src, filename}
  else
    Logger.debug("Downloading image #{image_src} to #{filename}")
    case HTTPotion.get(image_src,
      [headers: ["User-Agent": @user_agent], timeout: @http_timeout]) do
      %HTTPotion.Response{ body: body, headers: _headers, status_code: 200 } ->
        File.write!(filename, body)
        {:ok, image_src, filename}
      _ ->
        {:err, image_src}
    end
  end
end
---

This should at least reduce rework. Another thing I am still working on is this other bit at the main "CLI.process" function:

--- ruby
defp process(manga_name, url, directory, source) do
  File.mkdir_p!(directory)
  dump_file = "#{directory}/images_list.dump"
  images_list = if File.exists?(dump_file) do
                  :erlang.binary_to_term(File.read(dump_file))
                else
                  list = [url, source]
                    |> Workflow.chapters
                    |> Workflow.pages
                    |> Workflow.images_sources
                  File.write(dump_file, :erlang.term_to_binary(list))
                  list
                end
  images_list
    |> Workflow.process_downloads(directory)
    |> Workflow.optimize_images
    |> Workflow.compile_pdfs(manga_name)
    |> finish_process
end
---

As you can see the idea is to serialize the final images URL links to a file using the built-in serializer "<tt>:erlang.binary_to_term/1</tt>" and check if that dump file exists, and deserialize with "<tt>:erlang.term_to_binary/1</tt>"  before fetching all pages all over again. Now the process can resume directly from the <tt>process_downloads/2</tt> function after.

Mangafox is terribly unreliable and I will need to figure out a better way to retry timed out connections without having to crash and manually restart from the command line. It's either a bad site or a clever one that shuts down scrappers like me, although I am guessing it's just a bad infrastructure on their side.

If I downgrade from 50 process to 5 in the pool, it seems to be able to handle it better (but the process slows down, of course):

--- ruby
    pool_options = [
      name: {:local, :worker_pool},
      worker_module: PoolManagement.Worker,
      size: 5,
      max_overflow: 0
    ]
---

If you see time out errors, change this parameter. MangaReader still supports 50 or more for concurrency.

And now you know how to add support for more manga sources. Feel free to send me a Pull Request! :-)
