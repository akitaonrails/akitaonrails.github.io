---
title: 'Ex Manga Downloadr - Parte 4: Aprendendo Através do Refactoring'
date: '2015-12-03T17:40:00-02:00'
slug: ex-manga-downloadr-parte-4-aprendendo-atraves-do-refactoring
translationKey: ex-manga-downloadr-part-4
aliases:
- /2015/12/03/ex-manga-downloadr-part-4-learning-through-refactoring/
tags:
- learning
- beginner
- elixir
- exmangadownloadr
- traduzido
draft: false
---

[Ontem adicionei suporte ao Mangafox](http://www.akitaonrails.com/2015/12/02/ex-manga-downloadr-parte-3-suporte-ao-mangafox) na minha ferramenta de download e isso também acabou jogando um pouco de código sujo no meu código que já não estava lá essas coisas. Hora de uma faxina pra valer.

Você consegue ver tudo o que fiz desde ontem pra limpar a casa através da [excelente página de compare do Github](https://github.com/akitaonrails/ex_manga_downloadr/compare/59694565592f8a3bea95115b858dd2ddfdc89873...3ae7dd98a8fd7bae47ffd7a24c0c42a2c3777fad)

Antes de mais nada: agora a escolha de ter adicionado uma quantidade razoável de testes vai pagar dividendos. Neste refactoring eu mudei assinaturas de funções, formatos de resposta, movi uma boa quantidade de código de lugar, e sem os testes essa empreitada teria me tomado o dia inteiro ou mais, deixando o esforço de refactor questionável desde o início.

A cada passo do refactoring eu podia rodar "<tt>mix test</tt>" e trabalhar até chegar no status verde:

```
Finished in 13.5 seconds (0.1s on load, 13.4s on tests)
12 tests, 0 failures
```

Os testes estão demorando bastante porque fiz a escolha de que os testes unitários do MangaReader e do Mangafox fossem de fato online, buscando direto dos sites. Demora mais pra rodar a suíte mas eu sei que se ela quebrar e eu não tiver mexido naquele código, então os sites de origem mudaram seus formatos e eu preciso mudar o parser. Eu poderia ter adicionado fixtures pra fazer os testes rodarem mais rápido, mas o objetivo do meu parser é estar correto.

### Macros pro Resgate!

Cada módulo de fonte tem 3 sub-módulos: ChapterPage, IndexPage e Page. Todos eles tem uma função principal que parece com este pedaço de código:

```ruby
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
```

(Listing 1.1)

Ele chama "<tt>HTTPotion.get/2</tt>" mandando um monte de opções HTTP e recebe uma struct "<tt>%HTTPotion.Response</tt>" que então é decomposta pra pegar o body e os headers. Aplica gunzip no body se necessário e vai parsear o HTML em si.

Código parecido existe em 6 módulos diferentes, com links diferentes e funções de parser diferentes. É muita repetição, mas e se a gente fizesse o código acima ficar parecido com o snippet abaixo?

```ruby
defmodule ExMangaDownloadr.Mangafox.ChapterPage do
  require Logger
  require ExMangaDownloadr

  def pages(chapter_link) do
    ExMangaDownloadr.fetch chapter_link, do: fetch_pages(chapter_link)
  end
  ...
end
```

(Listing 1.2)

Mudei 9 linhas pra apenas 1. E aliás, essa mesma linha pode ser escrita assim:

```ruby
ExMangaDownloadr.fetch chapter_link do
  fetch_pages(chapter_link)
end
```

Parece familiar? É como todo bloco na linguagem Elixir, você pode escrevê-lo no formato de bloco "do/end" ou da maneira que ele realmente é por baixo dos panos: uma keyword list com uma chave chamada ":do". E a forma como esse macro é definido é assim:

```ruby
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
```

(Listing 1.3)

Tem um monte de detalhes pra considerar quando se escreve um macro e eu recomendo ler a documentação sobre [Macros](http://elixir-lang.org/getting-started/meta/macros.html). O código está basicamente copiando o corpo da função do "<tt>ChapterPage.pages/1</tt>" (Listing 1.1) e colando dentro do bloco "<tt>quote do .. end</tt>" (Listing 1.3).

Dentro daquele código a gente tem "<tt>unquote(link)</tt>" e "<tt>unquote(expression)</tt>". Você também precisa ler a documentação sobre ["Quote and Unquote"](http://elixir-lang.org/getting-started/meta/quote-and-unquote.html). Ele simplesmente expande esse código "externo" dentro do código do macro pra adiar a execução até o código do quote do macro de fato ser executado, em vez de rodar naquele exato momento. Eu sei, complicado de embrulhar a cabeça em volta disso na primeira vez.

A linha de fundo é: qualquer código que estiver dentro do bloco "quote" vai ser "inserido" onde a gente chamou "<tt>ExMangaDownloadr.fetch/2</tt>" na função "pages/1" da Listing 1.2, junto com o código unquoted que você passou como parâmetro.

O código resultante vai parecer com o código original da Listing 1.1.

Pra simplificar, se você estivesse em Javascript isso seria um código parecido:

```javascript
function fetch(url) {
    eval("doSomething('" + url + "')");
}
function pages(page_link) {
    fetch(page_link);
}
```

"Quote" seria como o corpo de string num eval e "unquote" só concatenando o valor que você passou dentro do código que está sendo eval-ado. É uma metáfora grosseira porque "quote/unquote" é **muito** mais poderoso e mais limpo que o feio "eval" (que você não deveria estar usando, aliás!) Mas essa metáfora serve pra você entender o código acima.

Outro lugar onde usei um macro foi pra salvar a lista de imagens num arquivo de dump e carregá-la depois caso a ferramenta dê crash por algum motivo, pra não ter que começar tudo do zero. O código original era assim:

```ruby
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
```

(Listing 1.4)

E agora que você entende macros, vai entender o que eu fiz aqui:

```ruby
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
```

E pronto! E agora você vê como blocos "do .. end" são implementados. Ele simplesmente passa a expressão como o valor na keyword list da definição do macro. Vamos definir um macro bobo:

```ruby
defmodule Foo
  defmacro foo(do: expression) do
     quote do
       unquote(expression)
     end
  end
end
```

E agora as seguintes chamadas são todas equivalentes:

```ruby
require Foo
Foo.foo do
  IO.puts(1)
end
Foo.foo do: IO.puts(1)
Foo.foo(do: IO.puts(1))
Foo.foo([do: IO.puts(1)])
Foo.foo([{:do, IO.puts(1)}])
```

Isso é macros combinados com [Keyword Lists](http://elixir-lang.org/getting-started/maps-and-dicts.html) que eu expliquei em artigos anteriores e é simplesmente uma List com tuplas onde cada tupla tem uma chave atom e um valor.

### Mais Macros

Outra oportunidade pra refatorar foram os módulos "mangareader.ex" e "mangafox.ex" que eram só usados nos testes unitários "mangareader_test.ex" e "mangafox_test.ex". Esse é o código antigo do "mangareader.ex":

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

E é assim que ele era usado no "mangareader_test.ex":

```ruby
defmodule ExMangaDownloadr.MangaReaderTest do
  use ExUnit.Case
  use ExMangaDownloadr.MangaReader
  ...
```

Era só um atalho pra fazer o alias dos módulos pra usá-los diretamente dentro dos testes. Eu simplesmente movi o módulo inteiro como um macro no módulo "ex_manga_downloadr.ex":

```ruby
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
```

E agora posso usá-lo assim no arquivo de teste:

```ruby
defmodule ExMangaDownloadr.MangaReaderTest do
  use ExUnit.Case
  use ExMangaDownloadr, :mangareader
  ...
```

O macro especial "__using__" é chamado quando eu dou "use" num módulo, e eu posso até passar argumentos pra ele. A implementação então usa "apply/3" pra chamar dinamicamente o macro correto. É exatamente assim que o Phoenix importa os behaviors apropriados pra Models, Views, Controllers, Router, por exemplo:

```ruby
defmodule Pxblog.PageController do
  use Pxblog.Web, :controller
  ...
```

Os macros estão abertos num arquivo Phoenix e disponíveis no módulo "web/web.ex", então só copiei o mesmo comportamento. E agora tenho 2 arquivos a menos pra me preocupar.

### Pequenos refactorings

No código anterior eu usava o "<tt>String.to_atom/1</tt>" pra converter a string do nome do módulo num atom, pra ser usado depois em chamadas "apply/3":

```ruby
defp manga_source(source, module) do
  case source do
    "mangareader" -> String.to_atom("Elixir.ExMangaDownloadr.MangaReader.#{module}")
    "mangafox"    -> String.to_atom("Elixir.ExMangaDownloadr.Mangafox.#{module}")
  end
end
```

Mudei pra isto:

```ruby
    "mangareader" -> :"Elixir.ExMangaDownloadr.MangaReader.#{module}"
    "mangafox"    -> :"Elixir.ExMangaDownloadr.Mangafox.#{module}"
```

É só um atalho pra fazer a mesma coisa.

No parser eu também estava usando o [Floki](https://github.com/philss/floki) de forma errada. Então dá uma olhada nesse pedaço de código antigo:

```ruby
defp fetch_manga_title(html) do
  Floki.find(html, "#mangaproperties h1")
  |> Enum.map(fn {"h1", [], [title]} -> title end)
  |> Enum.at(0)
end
defp fetch_chapters(html) do
  Floki.find(html, "#listing a")
  |> Enum.map fn {"a", [{"href", url}], _} -> url end
end
```

Agora usando as funções helper melhores que o Floki provê:

```ruby
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
```

Esse foi um caso de não ter lido a documentação como eu deveria. Bem mais limpo!

Fiz outras pequenas limpezas mas acho que isso cobre as mudanças principais. E finalmente, subi a versão pra "1.0.0" também!

```ruby
   def project do
     [app: :ex_manga_downloadr,
-     version: "0.0.1",
+     version: "1.0.0",
      elixir: "~> 1.1",
```

E falando em versões, estou usando Elixir 1.1 mas preste atenção porque [Elixir 1.2](https://github.com/elixir-lang/elixir/blob/ef5ba3af059f76489631dc26b52ecaeff09af3fe/CHANGELOG.md) está logo aí na esquina e traz algumas gracinhas. Por exemplo, aquele macro que fazia o alias de alguns módulos poderia ser escrito assim agora:

```ruby
def mangareader do
  quote do
    alias ExMangaDownloadr.MangaReader.{IndexPage, ChapterPage, Page}
  end
end
```

E essa é só 1 feature entre muitas outras melhorias de sintaxe e suporte ao mais novo [Erlang R18](http://www.erlang.org/news/88). Fique de olho nos dois!
