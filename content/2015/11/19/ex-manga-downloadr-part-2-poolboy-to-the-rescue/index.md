---
title: 'Ex Manga Downloadr - Parte 2: Poolboy ao resgate!'
date: '2015-11-19T14:35:00-02:00'
slug: ex-manga-downloadr-parte-2-poolboy-ao-resgate
translationKey: ex-manga-downloadr-part-2
aliases:
- /2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue/
tags:
- learning
- beginner
- elixir
- exmangadownloadr
- traduzido
draft: false
---

Se você leu o [meu artigo anterior](http://www.akitaonrails.com/2015/11/18/ex-manga-downloader-an-exercise-with-elixir), eu descrevi rapidamente meu exercício construindo um downloader pro MangaReader. Se ainda não leu, recomendo dar uma olhada antes de continuar.

No meio do artigo, eu falei que ainda estava me coçando pra entender qual seria a melhor forma de lidar com várias requisições HTTP simultâneas contra uma fonte externa instável, onde eu não consigo controlar timeout nem outros problemas de rede.

Um Mangá grande tipo Naruto ou Bleach tem dezenas de capítulos com dezenas de páginas cada, o que dá milhares de requisições HTTP necessárias. Elixir/Erlang me permitem disparar quantas requisições HTTP em paralelo eu quiser. Só que, fazendo isso, as requisições começam a dar timeout muito rápido (é praticamente um ataque distribuído de negação de serviço contra o MangaReader).

Por tentativa e erro descobri que disparar menos de 100 requisições HTTP de uma vez me permite terminar o trabalho. Eu travei em 80 só pra garantir, mas isso depende muito do seu ambiente.

Aí eu tinha que manualmente picar minha lista de páginas em pedaços de 80 elementos e processar em paralelo, depois reduzir as listas resultantes de volta numa lista maior pra repassar pros próximos passos do Workflow. O código fica meio enrolado assim:

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

Agora consegui reimplementar essa parte e o mesmo código ficou assim:

```ruby
def images_sources(pages_list) do
  pages_list
    |> Enum.map(&Worker.page_image/1)
    |> Enum.map(&Task.await(&1, @await_timeout_ms))
    |> Enum.map(fn {:ok, image} -> image end)
end
```

Uau! Que melhora absurda, e ficou muito mais óbvio o que ele tá fazendo.

E o melhor: baixar um Mangá do tamanho de Akira (em torno de 2.200 páginas) levou menos de **50 segundos**. E não é porque Elixir é super rápido, é porque o MangaReader não aguenta o tranco se eu aumentar o tamanho do Pool. Ele tá batendo numa taxa constante de 50 conexões simultâneas!

Isso faz minha máquina de 4 cores, sentada numa conexão de 40Mbs, usar menos de 40% ~ 30% de CPU e não mais que uns 3,5 Mbs. Se o MangaReader aguentasse o tranco, daria pra puxar todas as páginas 2 ou 3 vezes mais rápido sem suar a camisa.

Já era rápido com a estratégia anterior, mas acho que ficou pelo menos duas vezes mais rápido como bônus. E como foi que eu consegui isso?

### Open Telecom Platform

No artigo anterior eu também disse que ainda não queria mergulhar em "OTP e GenServers". Mas, se você é iniciante igual eu, provavelmente ainda nem entendeu direito o que isso quer dizer.

OTP é o que torna Erlang (e por consequência, Elixir) diferente de praticamente qualquer outra plataforma de linguagem, com a possível exceção de Java.

Muitas linguagens novas hoje em dia tentam fazer várias tarefas em paralelo através de padrões Reactor enrolados (Node.js, EventMachine/Ruby, Tornado/Twisted/Python, etc) ou através de green threads (mais limpas) como em Scala e Go.

Mas nada disso importa muito. Lançar milhões de processos leves até é fácil, o difícil é **CONTROLAR** todos eles. Não adianta nada conseguir esgotar seu hardware se você não consegue controlá-lo. Você acaba com milhões de minions burros causando o caos sem nenhum adulto pra coordenar.

Erlang resolveu esse problema décadas atrás através do desenvolvimento do OTP, inicialmente chamado de Open Systems, dentro da Ericsson em 1995. Por si só, OTP é um assunto que tranquilamente preenche um livro gordo inteiro e mesmo assim você ainda não vai conseguir se chamar de expert.

Só pra eu não ficar chato demais aqui:

* Comece com [esse resumo bem curtinho](http://learnyousomeerlang.com/what-is-otp);
* Depois leia o [tutorial de Supervisores do Elixir](http://elixir-lang.org/getting-started/mix-otp/supervisor-and-application.html) e a página sobre [Processos](http://elixir-lang.org/getting-started/processes.html), se ainda não tiver lido;
* Por fim, dá pra ir mais fundo com [The Elixir & OTP Guidebook](https://www.manning.com/books/the-little-elixir-and-otp-guidebook) da Manning Publications.

Agora, segue meu ponto de vista pessoal. Como eu também sou iniciante, me avisem nos comentários abaixo se eu peguei algum conceito errado.

OTP é uma coleção de tecnologias e frameworks. A parte que mais nos interessa é entender que isso é uma coleção sofisticada de padrões pra alcançar o Nirvana de sistemas distribuídos altamente confiáveis e altamente escaláveis. Sabe? Aquilo que toda nova plataforma promete pra você e não entrega.

Pros nossos propósitos bem simples, vamos retomar o que eu disse antes: é trivial disparar milhões de pequenos processos. Chamamos eles de "workers". O OTP fornece os meios pra controlar esses workers: os Supervisores. E também fornece o conceito de Árvores de Supervisores (Supervisores que supervisionam outros Supervisores). Esse é o ponto central.

Os Supervisores são responsáveis por iniciar os workers e também por se recuperar de exceções vindas dos workers (é por isso que em Erlang/Elixir a gente não fica fazendo aquela coisa feia de try/catch: deixe o erro acontecer e ser capturado pelo Supervisor). Aí dá pra configurar o Supervisor pra lidar com um worker problemático, por exemplo, reiniciando-o.

A gente já tinha tocado nessa coisa de OTP antes. Uma [Task](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/task.ex) do Elixir é só uma abstração de alto nível. Internamente, ela inicia o próprio [supervisor](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/task/supervisor.ex) pra monitorar tarefas assíncronas.

Tem tantos assuntos e detalhes que fica difícil até começar. Um conceito importante de saber é sobre **estado**. Não existe estado global! (Eba, nada de pesadelo de globais do Javascript.) Cada função tem o próprio estado e pronto. Sem aquele conceito de um "objeto" que segura estado e métodos que modificam esse estado.

Mas existe sim o conceito de processos do Erlang. Um processo tem estado, é um pedacinho leve de estado que existe só em runtime. Pra executar uma função num processo separado e paralelo, dá pra fazer só isso:

```ruby
iex> spawn fn -> 1 + 2 end
#PID<0.43.0>
```

Diferente de um objeto, um processo não tem um conjunto de métodos que acessam seus estados internos "this" ou "self". Em vez disso, cada processo tem uma **caixa de mensagens** (mailbox). Quando você inicia (ou faz "spawn", no jargão do Erlang) um novo processo, ele retorna um pid (process ID). A partir daí dá pra mandar mensagens pro processo através do pid. Cada processo tem sua mailbox e você pode escolher responder às mensagens que chegam e mandar respostas de volta pro pid que enviou. É assim que dá pra mandar uma mensagem pro console do IEx e receber as mensagens na mailbox dele:

```ruby
iex> send self(), {:hello, "world"}
{:hello, "world"}
iex> receive do
...>   {:hello, msg} -> msg
...>   {:world, msg} -> "won't match"
...> end
"world"
```

Em essência, é quase como um "objeto" que segura estado. Cada processo tem seu próprio garbage collector, então quando ele morre é coletado individualmente. E cada processo é isolado dos outros, eles não vazam estado entre si, o que torna tudo bem mais fácil de raciocinar.

A [página de Getting Started sobre Processos](http://elixir-lang.org/getting-started/processes.html) do site do Elixir mostra exemplos do que acabei de explicar e recomendo muito que você acompanhe direitinho.

Resumindo, um processo pode segurar estado interno travando indefinidamente esperando uma mensagem chegar na mailbox e depois recursando em si mesmo! Esse é um conceito que explode a cabeça à primeira vista.

Mas um processo simples sozinho é fraco demais. É aí que entra o [GenServer do OTP](http://elixir-lang.org/getting-started/mix-otp/genserver.html), que é um processo bem mais completo. O OTP expõe Behaviours pra você implementar com seu próprio código, enquanto ele cuida da parte chata da infraestrutura pra você não ter que se preocupar com isso.

### Delegando as Chamadas Pesadas do Workflow pra um Worker

Dito tudo isso, sabemos que no Workflow que implementamos antes a gente tem problema com as funções <tt>Page.image/1</tt> e <tt>Workflow.download_image/2</tt>. É por isso que tornamos elas processos assíncronos e esperamos por lotes de 80 chamadas a cada vez.

Agora, vamos começar movendo essa lógica pra um Worker GenServer, por exemplo, no arquivo <tt>ex_manga_downloadr/pool_management/worker.ex</tt>:

```ruby
defmodule PoolManagement.Worker do
  use GenServer
  use ExMangaDownloadr.MangaReader

  @timeout_ms 1_000_000
  @transaction_timeout_ms 1_000_000 # maior só por garantia

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def handle_call({:page_image, page_link}, _from, state) do
    {:reply, Page.image(page_link), state}
  end

  def handle_call({:page_download_image, image_data, directory}, _from, state) do
    {:reply, Page.download_image(image_data, directory), state}
  end
end
```

Primeiro movi o <tt>Workflow.download_image/2</tt> pra <tt>Page.download_image/2</tt> só por consistência. Mas esse é um GenServer em poucas palavras. Temos uma configuração inicial na função <tt>start_link/1</tt> e implementamos funções <tt>handle_call/3</tt> pra lidar com cada tipo de argumento que ele pode receber. A separação acontece através de pattern matching dos argumentos.

Por convenção, dá pra adicionar funções públicas que são versões mais bonitinhas que chamam cada <tt>handle_call/3</tt>:

```ruby
  def page_image(page_link) do
    Task.async fn ->
      :poolboy.transaction :worker_pool, fn(server) ->
        GenServer.call(server, {:page_image, page_link}, @timeout_ms)
      end, @transaction_timeout_ms
    end
  end

  def page_download_image(image_data, directory) do
    Task.async fn ->
      :poolboy.transaction :worker_pool, fn(server) ->
        GenServer.call(server, {:page_download_image, image_data, directory}, @timeout_ms)
      end, @transaction_timeout_ms
    end
  end
```

Mas a gente não está só chamando os <tt>handle_call/3</tt> anteriores. Primeiro temos o <tt>Task.async/1</tt> que já estávamos usando nas funções do Workflow pra fazer os lotes paralelos. Mas dentro das chamadas Task tem essa outra coisa estranha: <tt>:poolboy</tt>.

### Controlando Pools de Processos com Poolboy

Toda essa enrolação sobre OTP que escrevi aqui foi só uma introdução pra eu poder mostrar o [Poolboy](https://github.com/devinus/poolboy).

Repetindo de novo: é trivial disparar milhões de processos. OTP é como controlamos as falhas desses processos. Mas tem outro problema: a computação dentro de cada processo pode ser tão pesada que a gente acaba derrubando a máquina ou, no nosso caso, fazendo um Distributed Denial of Service (DDoS) contra o pobre site do MangaReader.

Minha ideia inicial foi só fazer requisições paralelas em lotes. Mas a lógica fica enrolada.

Em vez disso, podemos usar um pool de processos! Ele enfileira nossas requisições por novos processos. Sempre que um processo termina, ele é devolvido pro pool e uma nova computação pode tomar o processo disponível. É assim que pools funcionam (você provavelmente tem uma intuição de como funciona pelos pools tradicionais de conexão de banco de dados). Pools e filas são construções de software úteis pra lidar com recursos limitados.

Fazendo isso, dá pra remover o picotamento da lista grande em lotes e processar como se fôssemos atacar cada elemento da lista grande em paralelo de uma só vez, repetindo de novo a versão inicial:

```ruby
pages_list
  |> chunk(@maximum_fetches)
  |> Enum.reduce([], fn pages_chunk, acc ->
    result = pages_chunk
      |> Enum.map(&(Task.async(fn -> Page.image(&1) end)))
      |> Enum.map(&(Task.await(&1, @http_timeout)))
      |> Enum.map(fn {:ok, image} -> image end)
    acc ++ result
  end)
```

Agora, removendo o chunking e a lógica de redução:

```ruby
pages_list
  |> Enum.map(&(Task.async(fn -> Page.image(&1) end)))
  |> Enum.map(&(Task.await(&1, @http_timeout)))
  |> Enum.map(fn {:ok, image} -> image end)
```

E finalmente, substituindo a chamada direta de <tt>Task.async/1</tt> pelo worker do GenServer que acabamos de implementar:

```ruby
pages_list
  |> Enum.map(&Worker.page_image/1)
  |> Enum.map(&Task.await(&1, @await_timeout_ms))
  |> Enum.map(fn {:ok, image} -> image end)
```

Agora, o Poolboy vai exigir um Supervisor que monitore nosso Worker. Vamos colocar ele em <tt>ex_manga_downloadr/pool_management/supervisor.ex</tt>:

```ruby
defmodule PoolManagement.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    pool_options = [
      name: {:local, :worker_pool},
      worker_module: PoolManagement.Worker,
      size: 50,
      max_overflow: 0
    ]

    children = [
      :poolboy.child_spec(:worker_pool, pool_options, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
```

Mais bondades do OTP por aqui. Tínhamos um Worker descontrolado, agora temos um Supervisor responsável delegando a responsabilidade pro Poolboy. Começamos com um pool que comporta no máximo 50 processos dentro (sem overflow). Esse número também veio de tentativa e erro. E o Supervisor vai usar uma estratégia <tt>:one_for_one</tt>, o que quer dizer que se o Worker morrer, ele reinicia o coitado.

Agora, precisamos adicionar o Poolboy no <tt>mix.exs</tt> como dependência e rodar <tt>mix deps.get</tt> pra baixar:

```ruby
defp deps do
  [
    ...
    {:poolboy, github: "devinus/poolboy", tag: "1.5.1"},
    ...
  ]
end
```

No mesmo <tt>mix.exs</tt>, fazemos a Application principal (surpresa: que [já é uma aplicação OTP supervisionada](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/application.ex)) iniciar o PoolManagement.Supervisor pra gente:

```ruby
def application do
  [applications: [:logger, :httpotion, :porcelain],
   mod: {PoolManagement, []}]
end
```

Mas também precisamos ter esse módulo <tt>PoolManagement</tt> pra ser chamado. Podemos chamá-lo de <tt>pool_management.ex</tt>:

```ruby
defmodule PoolManagement do
  use Application

  def start(_type, _args) do
    PoolManagement.Supervisor.start_link
  end
end
```

### Resumo

Vamos resumir:

1. a aplicação <tt>ExMangaDownloadr</tt> sobe e dispara a aplicação <tt>PoolManagement</tt>;
2. a aplicação <tt>PoolManagement</tt> dispara o <tt>PoolManagement.Supervisor</tt>;
3. o <tt>PoolManagement.Supervisor</tt> dispara o Poolboy e atribui o <tt>PoolManagement.Worker</tt> pra ele, configurando o tamanho do pool em 50 e respondendo pelo nome de pool <tt>:worker_pool</tt>;
4. agora começamos a buscar e fazer parsing dos capítulos e páginas do Mangá até que <tt>ExMangaDownloadr.Workflow.images_sources/1</tt> é chamado;
5. ele vai chamar a função <tt>PoolManagement.Worker.page_image/1</tt> que por sua vez dispara um <tt>Task.async/1</tt>, chamando <tt>:poolboy.transaction(:worker_pool, fn -> ... end)</tt>;
6. se tem um processo disponível no pool do Poolboy, ele inicia na hora, senão fica aguardando até que um processo fique disponível, esperando até o timeout configurado em <tt>@transaction_timeout_ms</tt>.
7. o processo mapeia toda a <tt>pages_list</tt>, criando uma Task assíncrona pra cada página da lista, terminamos com uma lista gigantesca de pids de Task, e aí fazemos <tt>Task.await/2</tt> pra todas elas retornarem.

Agora, essa aplicação ficou bem mais confiável e mais rápida, já que ela dispara uma nova conexão HTTP assim que a primeira responde e devolve o processo pro pool. Em vez de disparar 80 conexões de uma vez, em lotes, começamos com 50 ao mesmo tempo e depois disparamos uma de cada vez pra cada processo devolvido ao pool.

Por tentativa e erro deixei o <tt>@http_timeout</tt> esperando no máximo 60 segundos. Também coloquei o <tt>timeout_ms</tt>, que é o tempo de espera pra chamada handle do worker GenServer retornar, e o <tt>transaction_timeout_ms</tt>, que é o tempo que o Poolboy aguarda por um novo processo no pool, ambos em torno de 16 minutos (1.000.000 ms).

É colocar 25 anos de experiência da Ericsson no setor de Telecom pra trabalhar a nosso favor!

E pra deixar bem claro: OTP é a coisa que separa Erlang/Elixir de todo o resto. Não é a mesma coisa, mas é como se o padrão fosse escrever tudo em Java como um EJB, pronto pra rodar dentro de um Container JEE. O que vem à mente é: pesado.

Em Erlang, uma aplicação OTP é leve, dá pra simplesmente construir e usar ad hoc, sem burocracia, sem ter que configurar servidores complicados. Como no nosso caso, é uma ferramenta de linha de comando bem simples e, dentro dela, todo o poder de um Container JEE! Pensa comigo.
