---
title: 'Ex Manga Downloadr - Part 4: Learning through Refactoring'
date: '2015-12-03T17:40:00-02:00'
slug: ex-manga-downloadr-part-4-learning-through-refactoring
tags:
- learning
- beginner
- elixir
- exmangadownloadr
- english
draft: false
---

[Yesterday I added Mangafox support](http://www.akitaonrails.com/2015/12/02/ex-manga-downloadr-part-3-mangafox-support) to my downloader tool and it also added a bit of dirty code into my already not-so-good coding. It's time for some serious cleanup.

You can see everything I did since yesterday to clean things up through [Github's awesome compare page](https://github.com/akitaonrails/ex_manga_downloadr/compare/59694565592f8a3bea95115b858dd2ddfdc89873...3ae7dd98a8fd7bae47ffd7a24c0c42a2c3777fad)

First things first: now the choice to have added a reasonable amount of tests will pay off. In this refactoring I changed function signatures, response formats, moved a fair amount of code around, and without the tests this endeavor would have taken me the entire day or more, rendering the refactor efforts questionable to begin with.

At each step of the refactoring I could run "<tt>mix test</tt>" and work until I ended up with the green status:

---
Finished in 13.5 seconds (0.1s on load, 13.4s on tests)
12 tests, 0 failures
---

The tests are taking long because I made a choice for the MangaReader and Mangafox unit tests to actually go online and fetch from the sites. It takes longer to run the suite but I know that if it breaks and I didn't touch that code, the source websites changed their formats and I need to change the parser. I could have added fixtures to make the tests run faster, but the point in my parser is for them to be correct.

### Macros to the Rescue!

Each source module has 3 sub-modules: ChapterPage, IndexPage and Page. All of them have a main function that resembles this piece of code:

--- ruby
defmodule ExMangaDownloadr.Mangafox.ChapterPage do
  require Logger
  ...
  def pages(chapter_link) do
    Logger.debug("Fetching pages from chapter #{chapter_link}")
    case HTTPotion.get(chapter_link, [headers: ["User-Agent": @user_agent, "Accept-encoding": "gzip"], timeout: 30_000]) do
      %HTTPotion.Response{ body: body, headers: headers, status_code: 200 } ->
        body = ExMangaDownloadr.Mangafox.gunzip(body, headers)
        { :ok, fetch_pages(chapter_link, body) }
      _ ->
        { :err, "not found"}
    end
  end
  ...
end
---

(Listing 1.1)

It calls "<tt>HTTPotion.get/2</tt>" sending a bunch of HTTP options and receives a "<tt>%HTTPotion.Response</tt>" struct that is then decomposed to get the body and headers. It gunzips the body if necessary and goes to parse the HTML itself.

Similar code exists in 6 different modules, with different links and different parser functions. It's a lot of repetition, but what about making the above code look like the snippet below?

--- ruby
defmodule ExMangaDownloadr.Mangafox.ChapterPage do
  require Logger
  require ExMangaDownloadr

  def pages(chapter_link) do
    ExMangaDownloadr.fetch chapter_link, do: fetch_pages(chapter_link)
  end
  ...
end
---

(Listing 1.2)

Changed 9 lines to just 1. And by the way, this same line can be written like this:

--- ruby
ExMangaDownloadr.fetch chapter_link do
  fetch_pages(chapter_link)
end
---

Seems familiar? It's like every block in the Elixir language, you can write it in the "do/end" block format or the way it really is under the covers: a keyword list with a key named ":do". And the way this macro is defined is like this:

--- ruby
defmodule ExMangaDownloadr do
  ...
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
  ...
end
---

(Listing 1.3)

There is a lot of details to consider when writing a macro and I recommend reading the documentation on [Macros](http://elixir-lang.org/getting-started/meta/macros.html). The code is basically copying the function body from the "<tt>ChapterPage.pages/1</tt>" (Listing 1.1) and pasting into the "<tt>quote do .. end</tt>" block (Listing 1.3).

Inside that code we have "<tt>unquote(link)</tt>" and "<tt>unquote(expression)</tt>". You also must read the documentation on ["Quote and Unquote"](http://elixir-lang.org/getting-started/meta/quote-and-unquote.html). It just expands this "external" code inside the macro code to defer execution until the macro quote code is actually executed, instead of running it at that exact moment. I know, tricky to wrap your head around this the first time.

The bottom line is: whatever code is inside the "quote" block will be "inserted" where we called "<tt>ExMangaDownloadr.fetch/2</tt>" in the "pages/1" function in Listing 1.2, together with the unquoted code you passed as a parameter.

The resulting code will resemble the original code in Listing 1.1.

To make it simpler, if you were in Javascript this would be a similar code:

--- javascript
function fetch(url) {
    eval("doSomething('" + url + "')");
}
function pages(page_link) {
    fetch(page_link);
}
---

"Quote" would be like the string body in an eval and "unquote" just concatenating the value you passed inside the code being eval-ed. This is a crude metaphor as "quote/unquote" is **way** more powerful and cleaner than ugly "eval" (you shouldn't be using, by the way!) But this metaphor should do to make you understand the code above.

Another place I used a macro was to save the images list in a dump file and load it later if the tool crashes for some reason, in order not to have to start over from scratch. The original code was like this:

--- ruby
dump_file = "#{directory}/images_list.dump"
images_list = if File.exists?(dump_file) do
                :erlang.binary_to_term(File.read!(dump_file))
              else
                list = [url, source]
                  |> Workflow.chapters
                  |> Workflow.pages
                  |> Workflow.images_sources
                File.write(dump_file, :erlang.term_to_binary(list))
                list
              end
---

(Listing 1.4)

And now that you understand macros, you will understand what I did here:

--- ruby
defmodule ExMangaDownloadr do
  ...
  defmacro managed_dump(directory, do: expression) do
    quote do
      dump_file = "#{unquote(directory)}/images_list.dump"
      images_list = if File.exists?(dump_file) do
          :erlang.binary_to_term(File.read!(dump_file))
        else
          list = unquote(expression)
          File.write(dump_file, :erlang.term_to_binary(list))
          list
        end
    end
  end
  ...
end

defmodule ExMangaDownloadr.CLI do
  alias ExMangaDownloadr.Workflow
  require ExMangaDownloadr
  ...
  defp process(manga_name, directory, {_url, _source} = manga_site) do
    File.mkdir_p!(directory)

    images_list = 
      ExMangaDownloadr.managed_dump directory do
        manga_site
          |> Workflow.chapters
          |> Workflow.pages
          |> Workflow.images_sources 
      end
    ...
  end
  ...
end
---

And there you have it! And now you see how "do .. end" blocks are implemented. It just passes the expression as the value in the keyword list of the macro definition. Let's define a dumb macro:

--- ruby
defmodule Foo
  defmacro foo(do: expression) do
     quote do
       unquote(expression)
     end
  end
end
---

And not the following calls are all equivalent:

--- ruby
require Foo
Foo.foo do
  IO.puts(1)
end
Foo.foo do: IO.puts(1)
Foo.foo(do: IO.puts(1))
Foo.foo([do: IO.puts(1)])
Foo.foo([{:do, IO.puts(1)}])
---

This is macros combined with [Keyword Lists](http://elixir-lang.org/getting-started/maps-and-dicts.html) which I explained in previous articles and it's simply a List with tuples where each tuple has an atom key and a value.

### More Macros

Another opportunity to refactor were the "mangareader.ex" and "mangafox.ex" modules that were just used in the unit tests "mangareader_test.ex" and "mangafox_test.ex". This is the old "mangareader.ex" code:

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

And this is how it was used in "mangareader_test.ex":

--- ruby
defmodule ExMangaDownloadr.MangaReaderTest do
  use ExUnit.Case
  use ExMangaDownloadr.MangaReader
  ...
---

It was just a shortcut to alias the modules in order to use them directly inside the tests. I just moved the entire module as a macro in "ex_manga_downloadr.ex" module:

--- ruby
  ...
  def mangareader do
    quote do
      alias ExMangaDownloadr.MangaReader.IndexPage
      alias ExMangaDownloadr.MangaReader.ChapterPage
      alias ExMangaDownloadr.MangaReader.Page
    end
  end

  def mangafox do
    ...
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
---

And now I can use it like this in the test file:

--- ruby
defmodule ExMangaDownloadr.MangaReaderTest do
  use ExUnit.Case
  use ExMangaDownloadr, :mangareader
  ...
---

The special "__using__" macro is called when I "use" a module, and I can even pass arguments to it. The implementation then uses "apply/3" to dynamically call the correct macro. This exactly how Phoenix imports the proper behaviors for Models, Views, Controllers, Router, for example:

--- ruby
defmodule Pxblog.PageController do
  use Pxblog.Web, :controller
  ...
---

The macros are open in a Phoenix file and available in the "web/web.ex" module, so I just copied the same behavior. And now I have 2 less files to worry about.

### Tiny refactorings

In the previous code I used the "<tt>String.to_atom/1</tt>" to convert the string of the module name to an atom, to be later used in "apply/3" calls:

--- ruby
defp manga_source(source, module) do
  case source do
    "mangareader" -> String.to_atom("Elixir.ExMangaDownloadr.MangaReader.#{module}")
    "mangafox"    -> String.to_atom("Elixir.ExMangaDownloadr.Mangafox.#{module}")
  end
end
---

I changed it to this:

--- ruby
    "mangareader" -> :"Elixir.ExMangaDownloadr.MangaReader.#{module}"
    "mangafox"    -> :"Elixir.ExMangaDownloadr.Mangafox.#{module}"
---

It's just a shortcut to do the same thing.

In the parser I was also not using [Floki](https://github.com/philss/floki) correctly. So take a look at this piece of old code:

--- ruby
defp fetch_manga_title(html) do
  Floki.find(html, "#mangaproperties h1")
  |> Enum.map(fn {"h1", [], [title]} -> title end)
  |> Enum.at(0)
end
defp fetch_chapters(html) do
  Floki.find(html, "#listing a")
  |> Enum.map fn {"a", [{"href", url}], _} -> url end
end
---

Now using the better helper functions that Floki provides:

--- ruby
defp fetch_manga_title(html) do
  html
  |> Floki.find("#mangaproperties h1")
  |> Floki.text
end
defp fetch_chapters(html) do
  html
  |> Floki.find("#listing a")
  |> Floki.attribute("href")
end
---

This was a case of not reading the documentation as I should have. Much cleaner!

I did other bits of cleanup but I think this should cover the major changes. And finally, I bumped up the version to "1.0.0" as well!

--- ruby
   def project do
     [app: :ex_manga_downloadr,
-     version: "0.0.1",
+     version: "1.0.0",
      elixir: "~> 1.1",
---

And speaking of versions, I'm using Elixir 1.1 but pay attention as [Elixir 1.2](https://github.com/elixir-lang/elixir/blob/ef5ba3af059f76489631dc26b52ecaeff09af3fe/CHANGELOG.md) is just around the corner and it brings some niceties. For example, that macro that aliased a few modules could be written this way now:

--- ruby
def mangareader do
  quote do
    alias ExMangaDownloadr.MangaReader.{IndexPage, ChapterPage, Page}
  end
end
---

And this is just 1 feature between many other syntax improvements and support for the newest [Erlang R18](http://www.erlang.org/news/88). Keep an eye on both!
