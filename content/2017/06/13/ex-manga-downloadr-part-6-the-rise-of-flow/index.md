---
title: 'Ex Manga Downloadr - Parte 6: A Ascensão do FLOW'
date: '2017-06-13T15:59:00-03:00'
slug: ex-manga-downloadr-parte-6-a-ascensao-do-flow
translationKey: ex-manga-downloadr-6
aliases:
- /2017/06/13/ex-manga-downloadr-part-6-the-rise-of-flow/
tags:
- beginner
- learning
- elixir
- exmangadownloadr
- traduzido
draft: false
---

Faz bem mais de um ano desde que escrevi sobre meu projeto pessoal [Ex Manga Downloadr](https://github.com/akitaonrails/ex_manga_downloadr). Desde então fiz apenas pequenas atualizações para acompanhar as versões mais recentes do Elixir e das bibliotecas.

Para recapitular rapidamente: o exercício é fazer web scraping no MangaReader.net, baixar um monte de imagens organizadas em páginas e capítulos e, no final, compilar PDFs organizados para poder ler num Kindle.

Web scraping é basicamente um loop de HTTP GETs em cima de toneladas de URLs, raspando o HTML e coletando mais URLs para baixar.

Em linguagens mais simples, as pessoas costumam resolver isso de dois jeitos ingênuos:

* Um loop aninhado simples. Uma única thread, fetches sequenciais. Se você tem 5.000 links e cada um leva 10 segundos para buscar, são 10 * 5.000 = 50.000 segundos — um tempo ridiculamente longo.
* Spawn de processos, fibers, threads ou I/O paralelo em um reactor, tudo de uma vez. Uma tentativa de paralelizar todos os fetches simultaneamente.

Todo mundo concorda que a primeira opção é ingênua. Mas a segunda tem seus problemas.

O ponto complicado é o **CONTROLE**.

Qualquer pessoa em Go diria _"ah, é fácil, é só fazer um loop e disparar um monte de goroutines"_, ou qualquer pessoa em Node.js diria _"ah, é fácil, é só fazer um loop, chamar o fetch — tudo roda assincronamente — e adicionar callbacks, um async/await básico."_

Não estão errados, mas ainda é uma implementação ingênua demais. Disparar centenas ou milhares de requisições paralelas é trivial. O problema vem depois: o que acontece se uma falha e você precisar fazer retry? E se o MangaReader tiver um sistema de throttling que começa a derrubar ou travar conexões? E se sua banda de internet simplesmente não der conta e, a partir de um certo ponto, você começar a ter retornos decrescentes e timeouts?

A mensagem é: disparar coisas em paralelo é trivialmente fácil. Controlar coisas em paralelo é complicado de verdade.

Por isso, na minha primeira implementação em Elixir, introduzi uma solução mais elaborada: uma combinação de um GenServer customizado, a infraestrutura de Task do próprio Elixir para o padrão async/await, e o [Poolboy](https://github.com/devinus/poolboy) para controlar a taxa de paralelismo. É assim que você controla o gargalo de recursos lentos: usando pools e filas (por isso todo banco de dados decente tem um connection pool — lembra do [C3P0](https://sourceforge.net/projects/c3p0/)?)

Um trecho da minha implementação mais antiga:

```ruby
def chapter_page([chapter_link, source]) do
  Task.Supervisor.async(Fetcher.TaskSupervisor, fn ->
    :poolboy.transaction :worker_pool, fn(server) ->
      GenServer.call(server, {:chapter_page, chapter_link, source}, @genserver_call_timeout)
    end, @task_async_timeout
  end)
end
```

Feio, né? E ainda tem todo o boilerplate do GenServer, do Supervisor customizado para inicializar o Poolboy e por aí vai. O código de workflow de alto nível ficava assim:

```ruby
def pages({chapter_list, source}) do
   pages_list = chapter_list
     |> Enum.map(&Worker.chapter_page([&1, source]))
     |> Enum.map(&Task.await(&1, @await_timeout_ms))
     |> Enum.reduce([], fn {:ok, list}, acc -> acc ++ list end)
   {pages_list, source}
end
```

Dentro do módulo `Worker`, cada método público encapsulava as chamadas internas ao GenServer em um `Task async`, e na iteração da coleção adicionávamos `Task.await` para aguardar todas as chamadas paralelas terminarem — só então reduziamos os resultados.

O Elixir agora vem com uma infraestrutura muito interessante chamada [`GenStage`](https://elixir-lang.org/blog/2016/07/14/announcing-genstage/), que promete substituir o `GenEvent`. O caso de uso ideal é quando você tem uma situação de produtor-consumidor com back-pressure — exatamente quando há endpoints lentos e você precisa controlar gargalos.

Aí vem o [Flow](https://github.com/elixir-lang/flow), uma abstração de alto nível que você usa de forma quase idêntica ao `Enum` nas suas coleções — mas em vez de mapeamento sequencial, ele cuida do traversal paralelo e do controle de lotes. O código fica muito parecido, só que sem você precisar gerenciar os controles de paralelização na mão.

Esse é o [commit completo](https://github.com/akitaonrails/ex_manga_downloadr/commit/b117f5236098f6d37e332633acb787be46a09d84) onde consegui remover o Poolboy, remover o meu GenServer customizado, reimplementar o Worker como um módulo simples de funções e fazer o workflow descartar o padrão async/await em favor do Flow:

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

O único boilerplate que sobrou é o `Flow.from_enumerable()` e o `Flow.partition()` envolvendo o `Flow.map` — e pronto!

Repara que configurei `@max_demand` como 60. Você precisa ajustar esse valor para mais ou para menos dependendo da sua conexão com a internet — é questão de experimentar. Por padrão, o Flow dispara 500 processos em paralelo, o que é demais para web scraping numa conexão residencial normal: você vai sofrer retornos decrescentes. Era exatamente isso que eu controlava antes com o Poolboy, limitando o pool a cerca de 60 transações simultâneas no máximo.

Infelizmente, nem tudo é tão simples quanto parece. Rodando essa nova versão no modo de teste, o resultado foi:

```
58,85s user 13,93s system 37% cpu 3:13,78 total
```

Mais de 3 minutos no total, usando cerca de 37% da CPU disponível.

Minha versão anterior imediata, com toda aquela engenharia do Poolboy, Task.Supervisor, GenServer e companhia, ainda me dá isso:

```
100,67s user 20,83s system 152% cpu 1:19,92 total
```

Menos da **METADE** do tempo, ainda que usando todos os núcleos da CPU. Minha implementação customizada ainda aproveita melhor os recursos disponíveis. Tem algo na implementação com Flow que ainda não acertei. Já tentei aumentar o `max_demand` de 60 para 100 e não melhorou nada. Deixar no padrão 500 piora tudo — mais de 7 minutos.

De qualquer forma, pelo menos a implementação ficou muito mais fácil de ler (e consequentemente de manter). Mas ou a implementação com Flow tem gargalos que ainda não identifiquei, ou estou usando ele de forma errada. Se você souber o que é, deixa nos comentários.
