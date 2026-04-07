---
title: 'Ex Manga Downloadr - Parte 3: Suporte ao Mangafox!'
date: '2015-12-02T16:27:00-02:00'
slug: ex-manga-downloadr-parte-3-suporte-ao-mangafox
translationKey: ex-manga-downloadr-part-3
aliases:
- /2015/12/02/ex-manga-downloadr-part-3-mangafox-support/
tags:
- learning
- beginner
- elixir
- exmangadownloadr
- traduzido
draft: false
---

Eu achava que a [Parte 2](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue) seria meu último artigo sobre essa ferramentinha, mas no fim das contas é divertido demais para largar tão rápido. Como sempre, todo o código fonte está no meu [repositório do Github](https://github.com/akitaonrails/ex_manga_downloadr). E o resumo do post é que agora dá pra fazer isso:

```
git pull
mix escript.build
./ex_manga_downloadr -n onepunch -u http://mangafox.me/manga/onepunch_man/ -d /tmp/onepunch -s mangafox
```

E pronto: download direto do Mangafox embutido! \o/

Tudo começou quando eu quis baixar um mangá que não existe no MangaReader mas está disponível no Mangafox.

Então a empreitada inicial foi copiar os módulos do parser do MangaReader (IndexPage, ChapterPage e Page) e colar numa pasta específica "lib/ex_manga_downloadr/mangafox". A mesma coisa na pasta de testes unitários. Só copiar e colar os arquivos e trocar o nome do módulo "MangaReader" por "Mangafox".

Claro que os formatos de URL são diferentes, os seletores CSS do Floki são um pouquinho diferentes, então é isso que precisa mudar no parser. Por exemplo, é assim que eu faço o parsing dos links de capítulo da página principal no MangaReader:

```ruby
defp fetch_chapters(html) do
  Floki.find(html, "#listing a")
  |> Enum.map fn {"a", [{"href", url}], _} -> url end
end
```

E essa é a mesma coisa, só que para o Mangafox:

```ruby
defp fetch_chapters(html) do
  html
  |> Floki.find(".chlist a[class='tips']")
  |> Enum.map fn {"a", [{"href", url}, {"title", _}, {"class", "tips"}], _} -> url end
end
```

Exatamente a mesma lógica, mas a estrutura de pattern matching muda porque os nodes do DOM HTML retornados são diferentes.

Outra diferença é que o MangaReader devolve tudo em texto puro por padrão, enquanto o Mangafox devolve tudo Gzipado independente de eu mandar o header HTTP "Accept-Encoding" (curiosamente, se eu tento várias vezes ele muda de comportamento e às vezes manda texto puro).

O que eu fiz de diferente foi checar se a estrutura <tt>%HTTPotion.Response{}</tt> retornada tinha o header "Content-Encoding" setado como "gzip" e, se sim, descomprimir usando o pacote "zlib" embutido do Erlang (sem precisar importar nada!):

```ruby
def gunzip(body, headers) do
  if headers[:"Content-Encoding"] == "gzip" do
    :zlib.gunzip(body)
  else
    body
  end
end
```

Eu teria preferido que o HTTPotion já fizesse isso pronto pra mim (#OpportunityToContribute!), mas foi fácil o suficiente.

Depois que os testes unitários começaram a passar corretamente, com o scrapper (requisições HTTPotion) e o parser (seletores Floki) ajustados, chegou a hora de fazer meu Worker reconhecer a existência desse novo conjunto de módulos.

O módulo Workflow só chama o Worker, que por sua vez faz o trabalho pesado de buscar páginas e baixar imagens. O Worker chamava o módulo MangaReader diretamente, assim:

```ruby
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
```

Aquele "<tt>use ExMangaDownloadr.MangaReader</tt>" lá em cima é só uma macro que cria os aliases para os módulos correspondentes:

```ruby
defmodule ExMangaDownloadr.MangaReader do
  defmacro __using__(_opts) do
    quote do
      alias ExMangaDownloadr.MangaReader.IndexPage
      alias ExMangaDownloadr.MangaReader.ChapterPage
      alias ExMangaDownloadr.MangaReader.Page
    end
  end
end
```

Então quando eu chamo "<tt>ChapterPages.pages(chapter_link)</tt>" é um atalho pra usar o nome qualificado completo do módulo, tipo: "<tt>ExMangaDownloadr.MangaReader.ChapterPages.pages(chapter_link)</tt>".

Um namespace de módulo Elixir é só um Atom. Nomes de módulos aninhados têm o nome completo separado por pontos, prefixado com seu pai. Por exemplo:

```ruby
defmodule Foo do
  defmodule Bar do
    defmodule Xyz do
       def teste do
       end
    end
  end
end
```

Você pode chamar "<tt>Foo.Bar.Xyz.teste()</tt>" e pronto. Mas tem uma pequena pegadinha. O Elixir também prefixa transparentemente o nome completo do módulo com "Elixir". Então na real, o nome completo do módulo é "Elixir.Foo.Bar.Xyz", pra garantir que nenhum módulo Elixir conflite com algum módulo Erlang existente.

Isso é importante por causa dessa nova função que eu adicionei primeiro no módulo Worker:

```ruby
def manga_source(source, module) do
  case source do
    "mangareader" -> String.to_atom("Elixir.ExMangaDownloadr.MangaReader.#{module}")
    "mangafox"    -> String.to_atom("Elixir.ExMangaDownloadr.Mangafox.#{module}")
  end
end
```

É assim que eu mapeio de "mangafox" pro novo namespace "ExMangaDownloadr.Mangafox.". E por causa da natureza dinâmica e baseada em troca de mensagens do Elixir, eu consigo trocar esse código:

```ruby
def handle_call({:chapter_page, chapter_link}, _from, state) do
  {:reply, ChapterPages.pages(chapter_link), state}
end
```

Por esse:

```ruby
def handle_call({:chapter_page, chapter_link, source}, _from, state) do
  links = source
    |> manga_source("ChapterPage")
    |> apply(:pages, [chapter_link])
  {:reply, links, state}
end
```

Agora eu posso escolher entre os módulos "Elixir.ExMangaDownloadr.Mangafox.ChapterPage" ou "Elixir.ExMangaDownloadr.MangaReader.ChapterPage", chamar a função <tt>pages/1</tt> e mandar o mesmo argumento de antes. Só preciso garantir que consigo receber a string "source" pela linha de comando agora, então mudo o módulo CLI assim:

```ruby
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
```

Comparado com a versão anterior eu só adicionei o argumento string "<tt>:source</tt>" no OptionParser e passei o valor capturado para <tt>process/4</tt>. Eu deveria adicionar alguma validação aqui para evitar strings diferentes de "mangareader" ou "mangafox", mas vou deixar isso pra outro momento.

E no módulo Workflow, em vez de começar só com a URL do mangá, agora preciso começar com a URL e a fonte do mangá:

```ruby
[url, source]
  |> Workflow.chapters
  |> Workflow.pages
  |> Workflow.images_sources
```

O que significa que cada uma dessas funções precisa não só retornar a nova lista de URLs como também passar a source adiante:

```ruby
def chapters([url, source]) do
  {:ok, _manga_title, chapter_list} = source
    |> Worker.manga_source("IndexPage")
    |> apply(:chapters, [url])
  [chapter_list, source]
end
```

Essa era a única função do módulo Workflow hardcoded pro MangaReader, então eu também a deixei dinâmica usando a mesma função <tt>manga_source/2</tt> do Worker, e repare que o valor de retorno é "<tt>[chapter_list, source]</tt>" em vez de só "<tt>chapter_list</tt>".

E agora eu finalmente posso testar com "<tt>mix test</tt>" e criar o novo binário executável de linha de comando com "<tt>mix escript.build</tt>" e rodar a nova versão assim:

```
./ex_manga_downloadr -n onepunch -u http://mangafox.me/manga/onepunch_man/ -d /tmp/onepunch -s mangafox
```

O site do Mangafox é bem instável com várias conexões concorrentes e dá timeout rapidinho às vezes, cuspindo erros feios assim:

```
15:58:46.637 [error] Task #PID<0.2367.0> started from #PID<0.124.0> terminating
** (stop) exited in: GenServer.call(#PID<0.90.0>, {:page_download_image, {"http://z.mfcdn.net/store/manga/11362/TBD-053.2/compressed/h006.jpg", "Onepunch-Man 53.2: 53rd Punch [Fighting Spirit] (2) at MangaFox.me-h006.jpg"}, "/tmp/onepunch"}, 1000000)
    ** (EXIT) an exception was raised:
        ** (HTTPotion.HTTPError) connection_closing
            (httpotion) lib/httpotion.ex:209: HTTPotion.handle_response/1
```

Ainda não descobri como fazer retry de requisições HTTPotion direito. Mas uma coisinha que eu fiz foi adicionar um check de disponibilidade no módulo Worker. Assim você pode simplesmente rodar o mesmo comando de novo e ele vai retomar baixando só os arquivos que faltam:

```ruby
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
```

Isso pelo menos reduz retrabalho. Outra coisa que ainda estou trabalhando é nesse outro pedaço da função principal "CLI.process":

```ruby
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
```

Como dá pra ver, a ideia é serializar os links finais das URLs das imagens num arquivo usando o serializador embutido "<tt>:erlang.binary_to_term/1</tt>" e checar se esse arquivo de dump existe, e desserializar com "<tt>:erlang.term_to_binary/1</tt>" antes de buscar todas as páginas de novo. Agora o processo pode retomar direto da função <tt>process_downloads/2</tt>.

O Mangafox é terrivelmente instável e eu vou precisar descobrir uma forma melhor de fazer retry de conexões que deram timeout, sem precisar quebrar e reiniciar manualmente da linha de comando. Ou é um site ruim ou um site esperto que derruba scrappers como o meu, embora eu chute que seja só infraestrutura ruim do lado deles.

Se eu reduzo de 50 processos para 5 no pool, parece que ele consegue lidar melhor (mas o processo fica mais lento, claro):

```ruby
    pool_options = [
      name: {:local, :worker_pool},
      worker_module: PoolManagement.Worker,
      size: 5,
      max_overflow: 0
    ]
```

Se você ver erros de timeout, mude esse parâmetro. O MangaReader ainda aguenta 50 ou mais de concorrência.

E agora você sabe como adicionar suporte pra mais fontes de mangá. Fique à vontade pra mandar um Pull Request! :-)
