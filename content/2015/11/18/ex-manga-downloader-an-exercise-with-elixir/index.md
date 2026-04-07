---
title: "Ex Manga Downloadr, um exercício com Elixir"
date: '2015-11-18T17:26:00-02:00'
slug: ex-manga-downloadr-um-exercicio-com-elixir
translationKey: ex-manga-downloadr-exercise
aliases:
- /2015/11/18/ex-manga-downloader-an-exercise-with-elixir/
tags:
- learning
- beginner
- elixir
- exmangadownloadr
- traduzido
draft: false
---

**Update 19/11/15:** Neste artigo eu menciono algumas dúvidas que tive, então leia este e depois acompanhe na [Parte 2](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-parte-2-poolboy-ao-resgate) para ver como resolvi.

Como exercício (e também porque, obviamente, sou um [Otaku](https://en.wikipedia.org/wiki/Otaku)) eu [implementei](https://github.com/akitaonrails/ex_manga_downloadr/blob/master/lib/ex_manga_downloadr/mangareader/index_page.ex) um scrapper simples em Elixir para o ótimo site [MangaReader](http://www.mangareader.net/). Dá pra discutir se é certo fazer scrap do site deles, e dá pra discutir também se eles oferecerem esses mangás é certo em primeiro lugar, então vamos deixar essa discussão de lado.

Eu tinha uma versão mais antiga [escrita em Ruby](https://github.com/akitaonrails/manga-downloadr). Ela ainda funciona, mas precisa muito de uma boa refatoração (desculpem por isso). O propósito daquela versão era ver se eu conseguia fazer fetch paralelo e retry de conexões usando Typhoeus.

![OnePunch Man baixado](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/525/big_ex_manga_downloadr.png)

Conforme fui evoluindo nos meus estudos de Elixir, essa ferramenta pareceu uma ótima candidata para testar meu conhecimento atual da plataforma. Ela me obrigaria a testar:

1. Fetch e parse de conteúdo ad hoc via HTTP ([HTTPotion](https://github.com/myfreeweb/httpotion) e [Floki](https://github.com/philss/floki)).
2. Testar downloads paralelos/assíncronos (módulo [Task](http://elixir-lang.org/docs/stable/elixir/Task.html) embutido no Elixir).
3. O suporte embutido para linha de comando e [option parser](http://elixir-lang.org/docs/stable/elixir/OptionParser.html).
4. Testes básicos via ExUnit e mock do workflow ([Mock](https://github.com/jjh42/mock)).

O exercício foi muito interessante, e um scrapper também é candidato ideal para TDD. Os passos iniciais tinham que ser assim:

1. Fazer parse da página principal do mangá para pegar todos os links dos capítulos.
2. Fazer parse de cada página de capítulo para pegar todas as páginas individuais.
3. Fazer parse de cada página para extrair a imagem principal embutida (a página real do mangá).

Para cada um desses passos iniciais eu fiz um teste unitário simples e os módulos <tt>IndexPage</tt>, <tt>ChapterPage</tt> e <tt>Page</tt>. Eles têm mais ou menos a mesma estrutura, este é um exemplo:

```ruby
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

Aqui eu já estou exercitando algumas das features mais legais do Elixir, como pattern matching no resultado da função <tt>HTTPotion.get/2</tt> para extrair o body do record que retorna.

Depois eu passo o body do HTML para 2 funções diferentes: <tt>fetch_manga_title</tt> e <tt>fetch_chapters</tt>. As duas usam o pacote Floki, que aceita seletores CSS para retornar uma List. Aí eu preciso percorrer essa lista (usando <tt>Enum.map/2</tt> por exemplo) e fazer pattern match nela para extrair os valores que preciso.

[Pattern Matching](http://elixir-lang.org/getting-started/pattern-matching.html) é um dos conceitos mais importantes para aprender em Elixir/Erlang. É diferente de simplesmente atribuir um valor a uma variável: dá pra usar para desmontar uma estrutura nos seus componentes e pegar as partes individuais.

Daí eu fui montar o esqueleto da interface de linha de comando. Isso já é explicado em outros tutoriais como [este](http://asquera.de/blog/2015-04-10/writing-a-commandline-app-in-elixir/) e [este](https://speakerdeck.com/st23am/writing-command-line-applications-in-elixir), então não vou perder tempo explicando de novo. No núcleo eu precisava do seguinte workflow:

1. Partindo da URL principal do mangá no MangaReader, extrair os capítulos
2. Depois loopar pelos capítulos e pegar todas as páginas
3. Depois loopar pelas páginas e pegar todos os sources de imagem
4. Depois loopar pelas imagens e baixar todas para um diretório temporário
5. Depois ordenar os arquivos no diretório e movê-los para subdiretórios de 250 imagens cada (acho um bom tamanho para cada volume)
6. Por fim, redimensionar e converter todas as imagens de cada subdiretório em um arquivo PDF para o meu Kindle consumir.

Esse workflow é definido assim:

```ruby
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

Esse é um lugar onde a notação de pipeline do Elixir realmente brilha. Fica muito melhor do que ter que escrever este equivalente:

```ruby
Workflow.compile_pdfs(Workflow.optimize_images(directory))
```

Essa notação é só açúcar sintático onde o valor de retorno do statement anterior é usado como primeiro argumento da função seguinte. Combine isso com outros açúcares sintáticos como parênteses opcionais (assim como o amado Ruby) e você tem uma exposição clara de "transformar uma URL em PDFs compilados".

Separei o Workflow no seu próprio módulo e cada passo é bem parecido, cada um pegando uma lista e percorrendo ela. Este é o mais simples deles:

```ruby
def pages(chapter_list) do
  chapter_list
    |> Enum.map(&(Task.async(fn -> ChapterPage.pages(&1) end)))
    |> Enum.map(&(Task.await(&1, @http_timeout)))
    |> Enum.reduce([], fn {:ok, list}, acc -> acc ++ list end)
end
```

Se você é novo em Elixir, aqui vai encontrar outra esquisitice, esse <tt>"&(x(&1))"</tt>, que é só um macro de atalho para este outro statement equivalente:

```ruby
Enum.map(fn (list) ->
  Task.async(fn ->
    ChapterPage.pages(list)
  end)
end)
```

[Enum](http://elixir-lang.org/docs/stable/elixir/Enum.html) é um dos módulos mais úteis que você precisa dominar. Se você vem de Ruby vai se sentir em casa, e tem que aprender todas as funções dele. Você normalmente vai estar transformando uma coleção em outra, então é importante estudar a fundo.

### Alguns problemas para entender o processamento HTTP paralelo (W.I.P.)

Aí tem esse lance de <tt>Task.async/await</tt>. Se você vem de uma linguagem que tem Threads, é bem parecido: você inicia várias Threads diferentes e espera todas retornarem antes de continuar. Mas uma Task em Elixir não é uma thread real, é uma ["green thread"](https://en.wikipedia.org/wiki/Green_threads#Green_threads_in_other_languages) ou, no jargão de Erlang, um "process" bem leve. Erlang usa processes para tudo, e Elixir também. Por baixo dos panos, o módulo "Task" encapsula todo o framework OTP de supervisors/workers. Mas em vez de ter que lidar agora com [OTP GenServer](http://elixir-lang.org/getting-started/mix-otp/genserver.html) decidi ir pelo caminho mais simples por enquanto, e o módulo "Task" cumpre essa função.

Daí, acabei caindo num problema. Se eu continuasse assim, disparando centenas de chamadas HTTP assíncronas, rapidamente caía nessa exception:

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

Por isso existe o <tt>@maximum_fetches 80</tt> no topo do módulo <tt>Workflow</tt>, junto com essa outra construção esquisita:

```ruby
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

Isso pega uma lista enorme (como todas as páginas de um mangá bem longo tipo Naruto), quebra em listas menores de 80 elementos e aí dispara as Tasks assíncronas, reduzindo os resultados de volta para uma List simples. A função privada <tt>chunk/2</tt> só pega o menor tamanho entre o comprimento da lista e o valor máximo de fetches.

Às vezes quebra se o máximo é maior, às vezes não, então meu chute é que meu código não está lidando com instabilidades de rede (com alguma lógica de retry) ou então o site MangaReader está enfileirando acima do meu timeout designado (que setei para 30 segundos). De qualquer forma, manter o valor máximo abaixo de 100 parece ser um bom equilíbrio sem derrubar o workflow.

Essa é uma parte que ainda não tenho certeza do que fazer para lidar com incertezas no site externo não respondendo ou a rede caindo por um tempinho. HTTPotion tem suporte para chamadas assíncronas, mas eu não sei qual a diferença entre usar isso ou só fazer chamadas síncronas dentro de processes paralelos com Task, do jeito que estou fazendo. E em qualquer dos casos, eles são supervised workers, como lidar com as exceptions, como implementar lógica para tentar de novo quando falha? Se alguém tem mais conhecimento sobre isso, um comentário aí embaixo seria bem apreciado.

Por fim, tem um truque sujo por trás do motivo pelo qual eu gosto de usar o MangaReader: ele é bem amigável a scrappers porque em cada página do mangá a imagem é anotada com um atributo "alt" no formato "[nome do mangá] [número do capítulo] - [número da página]". Então só tive que reformatar um pouco, adicionando um pad de zeros antes do número do capítulo e da página para que um sort simples dos arquivos baixados me dê a ordem correta. MangaFox não é tão amigável. Assim que reformato:

```ruby
defp normalize_metadata(image_src, image_alt) do
  extension      = String.split(image_src, ".") |> Enum.at(-1)
  list           = String.split(image_alt)      |> Enum.reverse
  title_name     = Enum.slice(list, 4, Enum.count(list) - 1) |> Enum.join(" ")
  chapter_number = Enum.at(list, 3) |> String.rjust(5, ?0)
  page_number    = Enum.at(list, 0) |> String.rjust(5, ?0)
  {image_src, "#{title_name} #{chapter_number} - Page #{page_number}.#{extension}"}
end
```

Uma vez que tenho todas as imagens, disparo outro processo externo usando [Porcelain](https://github.com/alco/porcelain) para fazer shell out e rodar as ferramentas Mogrify e Convert do ImageMagick para redimensionar todas as imagens para 600x800 pixels (resolução do Kindle Voyage) e empacotá-las num arquivo PDF. O resultado são arquivos PDF com 250 páginas e cerca de 20Mb. Agora é só copiar os arquivos para o meu Kindle via USB.

O código do ImageMagick é bem chato, eu só gero os comandos no seguinte formato para o Mogrify:

```
"mogrify -resize #{@image_dimensions} #{directory}/*.jpg"
```

E compilo os PDFs com este outro comando:

```
"convert #{volume_directory}/*.jpg #{volume_file}"
```

(Aliás, repare na interpolação de strings ao estilo Ruby a que estamos acostumados.)

![OnePunch Man no Kindle](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/526/big_11249911_10153742264949837_7817568172948440418_n.jpg)

Tecnicamente eu poderia copiar os arquivos do módulo MangaReader para um novo módulo MangaFox e reaproveitar a mesma lógica de Workflow uma vez que tweaksse os parsers para lidar com o formato de página do MangaFox. Mas deixo isso como exercício para o leitor.

Os testes do módulo MangaReader fazem chamadas reais ao site deles. Deixei assim de propósito porque se o teste falhar significa que mudaram o formato do site e o parser precisa de ajuste para se adaptar. Mas depois de alguns anos eu nunca vi eles mudarem o suficiente para quebrar o meu velho parser em Ruby.

Só como exercício final eu importei o pacote Mock, para controlar como algumas peças internas da implementação do Workflow retornam. Chama-se Mock mas é mais como stub de funções específicas de um módulo. Posso declarar um bloco onde sobrescrevo o <tt>File.rename/1</tt> para que ele realmente não tente mover um arquivo que não existe no ambiente de testes. Isso deixa o teste mais frágil porque depende de uma implementação específica, o que nunca é bom, mas quando estamos lidando com I/O externo, pode ser a única opção para isolar. Foi assim que o teste do Workflow foi feito. De novo, se houver um jeito melhor estou ansioso para aprender, por favor comente aí embaixo.

Assim fica um teste unitário com Mock, fazendo stub dos módulos HTTPotion e File:

```ruby
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

### Conclusão

Tem sido uma experiência muito divertida, ainda que muito curta, e boa o suficiente para colocar em prática o que aprendi até agora. Código como este me faz sorrir:

```ruby
[destination_file|_rest] = String.split(file, "/") |> Enum.reverse
```

A forma como posso fazer pattern match para extrair o head de uma lista é uma maneira diferente de pensar. Daí tem a outra forma de pensar mais importante: tudo é uma cadeia de transformação, uma aplicação é uma forma de partir de algum argumento de entrada (como uma URL) e ir passo a passo "transformando" ele em uma coleção de arquivos PDF, por exemplo.

Em vez de pensar em como arquitetar classes e objetos, começamos a pensar em quais são os argumentos iniciais e qual o resultado que quero atingir, e vamos daí, uma pequena função de transformação por vez.

O módulo Workflow é um exemplo. Eu na verdade comecei escrevendo tudo numa única função grande no módulo CLI. Aí refatorei em funções menores e encadeei elas para criar o Workflow. Por fim, só movi todas as funções para o módulo Workflow e chamei a partir do módulo CLI.

Por causa da ausência de estado global, pensar em funções pequenas e isoladas, tanto refatorar quanto fazer test-driven development ficam muito mais suaves do que em linguagens OOP. Esse jeito de pensar é, admito, lento de pegar o jeito, mas depois começa a parecer muito natural e rapidamente direciona a sua forma de programar para um código mais enxuto.

E os aspectos dinâmicos tanto de Erlang quanto de Elixir me fazem sentir em casa, como se fosse um "Ruby melhorado".

O código do downloader está todo no [Github, podem fazer fork](https://github.com/akitaonrails/ex_manga_downloadr/blob/master/lib/ex_manga_downloadr/mangareader/index_page.ex).

Estou ansioso para exercitar mais. Espero que isso motive você a aprender Elixir. E se você já é um programador avançado em Elixir ou Erlang, não esqueça de comentar aí embaixo e até mandar um Pull Request para melhorar este pequeno exercício. Ainda sou iniciante e tem muito espaço para aprender mais. Todas as contribuições são muito apreciadas.
