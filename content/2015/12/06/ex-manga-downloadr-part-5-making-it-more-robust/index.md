---
title: 'Ex Manga Downloadr - Parte 5: Deixando mais robusto!'
date: '2015-12-06T19:20:00-02:00'
slug: ex-manga-downloadr-parte-5-deixando-mais-robusto
translationKey: ex-manga-downloadr-part-5
aliases:
- /2015/12/06/ex-manga-downloadr-part-5-making-it-more-robust/
tags:
- learning
- beginner
- elixir
- exmangadownloadr
- traduzido
draft: false
---

E lá vou eu de novo. Sei que alguns de vocês já podem estar entediados com essa ferramenta, mas como projeto de brincadeira, ainda quero deixar o código bom. Só que tem 2 problemas grandes agora.

Quando eu testava só com o MangaReader.net como fonte, tudo funcionava quase sem falhas. Mas ao adicionar o MangaFox na [Parte 3](http://www.akitaonrails.com/2015/12/02/ex-manga-downloadr-part-3-mangafox-support), com suas regras mais restritivas contra ferramentas de scrapping como a minha (timeouts mais frequentes, não permitindo muitas conexões da mesma origem, etc), o processo simplesmente quebrava o tempo todo e eu tinha que reiniciar manualmente (as features de retomada que adicionei na [Parte 4](http://www.akitaonrails.com/2015/12/03/ex-manga-downloadr-part-4-learning-through-refactoring) ajudaram bastante, mas a ferramenta deixou de ser confiável).

Recapitulando, o Workflow só organiza cada passo do processo. Suas funções são parecidas com isso:

```ruby
def process_downloads(images_list, directory) do
  images_list
    |> Enum.map(&Worker.page_download_image(&1, directory))
    |> Enum.map(&Task.await(&1, @await_timeout_ms))
  directory
end
```

Ele lida com uma lista grande, faz um map sobre cada elemento mandando para uma função Worker rodar, assim:

```ruby
def page_download_image(image_data, directory) do
  Task.async(fn ->
    :poolboy.transaction :worker_pool, fn(server) ->
      GenServer.call(server, {:page_download_image, image_data, directory}, @genserver_call_timeout)
    end, @task_async_timeout
  end)
end
```

Ele retorna uma Task assíncrona esperando por 2 coisas: o Poolboy liberar um processo livre para usar, e a função Worker/GenServer terminar de rodar dentro daquele processo. Como expliquei na [Parte 2](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue), isso é para limitar o número máximo de conexões com a fonte externa. Sem essa restrição, mandando dezenas de milhares de requests assíncronos de uma vez, a fonte externa simplesmente falharia todos.

A primeira coisa para se ter em mente é que um "<tt>Task.async/2</tt>" se linka com o processo chamador, então se algo der errado, o processo pai morre junto.

A coisa certa a fazer é adicionar um [Task.Supervisor](http://elixir-lang.org/docs/stable/elixir/Task.Supervisor.html) e deixar ele cuidar de cada Task filha. Para fazer isso, basta adicionar o Supervisor na nossa árvore supervisionada em "pool_management/supervisor.ex":

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

E podemos substituir as chamadas "<tt>Task.async/2</tt>" por "<tt>Task.Supervisor.async(Fetcher.TaskSupervisor, ...)</tt>" assim:

```ruby
def page_download_image(image_data, directory) do
  Task.Supervisor.async(Fetcher.TaskSupervisor, fn ->
    :poolboy.transaction :worker_pool, fn(server) ->
      GenServer.call(server, {:page_download_image, image_data, directory}, @genserver_call_timeout)
    end, @task_async_timeout
  end)
end
```

Isso ainda cria Tasks pelas quais precisamos esperar, e como antes, se a função lá dentro quebrar, ainda derruba o processo principal. Agora minha refatoração chegou num beco sem saída.

Esse é o 2º problema que mencionei no início do artigo: uma **falha no meu design**.

Em vez de só fazer um map sobre cada elemento de uma lista grande, eu deveria ter criado um GenServer baseado em Agent para manter a lista como estado e transformar todo o sistema do Workflow em um novo GenServer supervisionado. Se buscar uma URL quebrasse o GenServer, seu supervisor o reiniciaria e pegaria o próximo elemento da lista.

Mas, como não estou com pique para essa refatoração agora (é tarde de domingo), vou me concentrar num quick fix (sim, uma gambiarra), só para que a função dentro da chamada async não levante exceções.

### OMG! É um bloco Try/Catch!

Acontece que tudo o que rodo dentro dos processos do Poolboy são requests HTTP get através do HTTPotion. Felizmente eu já tinha refatorado toda chamada HTTPotion get em uma macro elegante:

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

Agora só preciso trocar 1 linha nessa macro:

```ruby
-    case HTTPotion.get(unquote(link), ExMangaDownloadr.http_headers) do
+    case ExMangaDownloadr.retryable_http_get(unquote(link)) do
```

E definir essa nova lógica de retry no módulo principal:

```ruby
defmodule ExMangaDownloadr do
  require Logger

  # vai tentar de novo fetches falhos por mais de 50 vezes, dormindo 1 segundo entre cada retry
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

Eu [afirmei](http://www.akitaonrails.com/2015/12/01/the-obligatory-why-elixir-personal-take) com convicção que em Elixir **não** devemos usar blocos "try/catch", mas aí está.

Essa é a consequência da falha no meu design inicial do Workflow. Se eu tivesse codificado o módulo Workflow como um GenServer, com cada lista gerenciada por um Agent, cada chamada HTTPotion que falhasse permitiria ao supervisor reiniciá-la e tentar de novo. Sem precisar recorrer ao código feio do "try/catch".

Talvez isso me force a escrever a Parte 6 sendo o código para remover esse "try/catch" feio depois, então considerem isto uma **Dívida Técnica** para fazer tudo funcionar agora e depois refatorar para pagar a dívida.

As chamadas "<tt>HTTPotion.get/2</tt>" podem levantar exceções "HTTPotion.HTTPError". Estou capturando esses erros por enquanto, casando as mensagens contra uma lista de erros que eu já tinha, dormindo por um certo tempo (só uma heurística para ver se as fontes externas respondem melhor desse jeito) e recurso na própria função através de um número limitado de "retries", até chegar a zero, caso em que pode até ser que a conexão de internet esteja caída ou algum outro erro grave do qual não conseguiríamos nos recuperar tão cedo.

Com esse código no lugar, agora até buscar do MangaFox, sem precisar diminuir o POOL_SIZE, roda até o fim, e isso resolve minhas necessidades por agora. Se alguém tiver interesse em sugerir um design de Workflow melhor, baseado em GenServer, eu agradeceria muito um Pull Request.

Abraços.
