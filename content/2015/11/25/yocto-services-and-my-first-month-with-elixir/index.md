---
title: '"Yocto Services"! E o Meu Primeiro Mês com Elixir!'
date: '2015-11-25T18:04:00-02:00'
slug: yocto-services-e-meu-primeiro-mes-com-elixir
translationKey: yocto-services-first-month-elixir
aliases:
- /2015/11/25/yocto-services-and-my-first-month-with-elixir/
tags:
- learning
- beginner
- elixir
- traduzido
draft: false
---

Cara, no último mês (quase, de 27 de outubro a 25 de novembro) eu decidi que já passou da hora de mergulhar fundo e aprender Elixir de verdade. E foi exatamente o que eu fiz. Ainda sou iniciante, mas já me sinto bem confiante de que consigo encarar projetos em Elixir agora.

O meu processo de aprendizado:

1. Li toda a [Documentação oficial do Elixir](http://elixir-lang.org/getting-started/introduction.html);
2. Li o livro [Programming Elixir](https://pragprog.com/book/elixir/programming-elixir) do Dave Thomas inteiro;
3. Assisti a quase todos os screencasts do [Elixir Sips](http://elixirsips.com/);
4. Li o livro [The Little Elixir & OTP Guidebook](https://www.manning.com/books/the-little-elixir-and-otp-guidebook) do Benjamin Tan Wei Hao inteiro;
5. Fiz uma porção de tutoriais e exercícios.

E, finalmente, documentei tudo o que aprendi quase todo dia nos seguintes artigos:

* [How Fast is Elixir/Phoenix?](http://www.akitaonrails.com/2015/10/27/how-fast-is-elixir-phoenix)
* [Personal Thoughts on the Current Functional Programming Bandwagon](http://www.akitaonrails.com/2015/10/28/personal-thoughts-on-the-current-functional-programming-bandwagon)
* [Phoenix Experiment: Holding 2 Million Websocket clients!](http://www.akitaonrails.com/2015/10/29/phoenix-experiment-holding-2-million-websocket-clients)
* [My first week learning Elixir](http://www.akitaonrails.com/2015/11/03/my-first-week-learning-elixir)
* [Ex Manga Downloader, an exercise with Elixir](http://www.akitaonrails.com/2015/11/18/ex-manga-downloader-an-exercise-with-elixir)
* [Ex Manga Downloadr - Part 2: Poolboy to the rescue!](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue)
* [Phoenix "15 Minute Blog" comparison to Ruby on Rails](http://www.akitaonrails.com/2015/11/20/phoenix-15-minute-blog-comparison-to-ruby-on-rails)
* [Observing Processes in Elixir - The Little Elixir & OTP Guidebook](http://www.akitaonrails.com/2015/11/22/observing-processes-in-elixir-the-little-elixir-otp-guidebook)
* [ExMessenger Exercise: Understanding Nodes in Elixir](http://www.akitaonrails.com/2015/11/25/exmessenger-exercise-understanding-nodes-in-elixir)
* [Elixir 101 - Introducing the Syntax](http://www.akitaonrails.com/2015/11/25/elixir-101-introducing-the-syntax)

Sim, eu sou prolífico e bastante focado. Estudei e escrevi tudo isso em menos de um mês (teria sido bem menos se eu pudesse ter usado as noites e finais de semana). Então eu diria que o desenvolvedor médio levaria pelo menos 3 a 4 meses para cobrir o mesmo material.

### Pensamento Inicial: Yocto Services!

Para o bem ou para o mal, estamos no alvorecer da arquitetura de Micro Serviços. Resumidamente, é fragmentar o seu monolito em aplicações menores que respondem a endpoints HTTP - que as pessoas chamam de "APIs" - e que são responsáveis por um conjunto bem restrito de responsabilidades. Aí você cria uma aplicação web "front-end" que vai consumir esses serviços, como analytics, métodos de pagamento, diretórios de autenticação de usuários, e por aí vai.

Isso não é novidade nenhuma, claro. Ter APIs HTTP que devolvem estruturas JSON é só uma forma mais bonitinha de fazer os bons e velhos **Remote Procedure Calls**, ou RPCs, uma tecnologia que temos há décadas para interconectar clientes e servidores numa rede. Mas estou divagando.

Se isso é o que as pessoas chamam de serviços "Micro", eu penso nos processos do Elixir como **"Yocto"** Services! (Milli > Micro > Nano > Pico > Femto > Atto > Zepto > Yocto, aliás - eu posso ter acabado de inventar um novo termo aqui!)

Eu já descrevi um pouco da infraestrutura de Processos, como dar spawn neles, como trocar mensagens entre eles e como linkar eles. Então, vai lá ler [meu post anterior](http://www.akitaonrails.com/2015/11/22/observing-processes-in-elixir-the-little-elixir-otp-guidebook) se ainda não leu.

Dentro de uma aplicação Elixir você vai encontrar muitos processos, alguns da própria VM tocando o show e outros da sua própria aplicação. Se você arquitetou direito, implementou uma aplicação OTP, com grupos próprios de Supervisors e Children, todos organizados numa Supervision Tree. Um pequeno worker morre, o supervisor dele sabe como lidar com isso.

Agora, o modelo mental é o seguinte: pense num processo Elixir como um pequeno micro-serviço - um **Yocto service**, se preferir! - dentro da sua aplicação. Numa aplicação Phoenix, por exemplo, você não importa uma "biblioteca de banco de dados", você na verdade dá start num "Database Service" (que é um Ecto Repo) que roda em paralelo com a aplicação Endpoint que responde aos requests HTTP que vêm da internet. O código nos seus controllers e models "consome" e envia mensagens para o "Service" Ecto Repo. É assim que você consegue visualizar o que está acontecendo.

Eu mostrei o Observer no artigo anterior também. Você vai encontrar uma árvore grande se abrir ele dentro do shell IEx de uma aplicação Phoenix:

![Observer Phoenix](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/531/big_phoenix-observer.png)

Resumindo, você vai encontrar a seguinte seção na Supervision Tree do Phoenix App Pxblog:

```
Pxblog.Supervisor
- Pxblog.Endpoint
    + Pxblog.Endpoint.Server
    + Pxblog.PubSub.Supervisor
        * Pxblog.PubSub
        * Pxblog.PubSub.Local
- Pxblog.Repo
    + Pxblog.Repo.Pool
```

Esse é o Pxblog que eu expliquei no [artigo de comparação entre Phoenix e Rails](http://www.akitaonrails.com/2015/11/20/phoenix-15-minute-blog-comparison-to-ruby-on-rails) que publiquei poucos dias atrás.

Eu ainda não li o código fonte do Phoenix, mas se eu estou interpretando o Observer corretamente, o Endpoint.Server controla um pool de processos que são listeners TCP que a aplicação está pronta para aceitar requests, concorrentemente, com overflow para aceitar mais conexões (acredito que seja uma implementação de pool tipo Poolboy, que eu expliquei na [Parte 2 do artigo do Ex Manga Downloader](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue)).

Aí você tem as aplicações PubSub.Supervisor e PubSub.Local que eu acredito que dão suporte aos canais WebSocket.

Sozinho, o Repo controla 10 processos iniciais no pool dele, possivelmente um pool de conexões com o banco de dados. Repare como os grupos Endpoint e Repo estão em ramos paralelos da árvore de supervisão. Se o Repo falha por causa de algum problema externo do banco, o grupo do Endpoint não precisa falhar junto. Isso é o que está declarado na definição da Application do Pxblog em <tt>lib/pxblog.ex</tt>:

```
defmodule Pxblog do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Pxblog.Endpoint, []),
      # Start the Ecto repository
      worker(Pxblog.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Pxblog.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pxblog.Supervisor]
    Supervisor.start_link(children, opts)
  end
  ...
end
```

Veja como ele define o Endpoint e o Repo debaixo do Pxblog.Supervisor.

Eu posso ir lá e matar à força o nó inteiro do Pxblog.Repo da Supervision Tree usando o Observer, como fiz no artigo anterior, e a estratégia certa entra em ação, o Phoenix Supervisor reinicia o Repo com sucesso, e ninguém vai perceber que algo quebrou por baixo dos panos.

![Kill Repo](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/532/big_phoenix_kill_repo.png)

Do IEx eu ainda consigo fazer mais chamadas para o Repo desse jeito e ele responde como se nunca tivesse caído:

```
iex(4)> Pxblog.Repo.all(Pxblog.User)
[debug] SELECT u0."id", u0."username", u0."email", u0."password_digest", u0."inserted_at", u0."updated_at" FROM "users" AS u0 [] OK query=78.2ms queue=3.2ms
[%Pxblog.User{__meta__: #Ecto.Schema.Metadata<:loaded>,
  email: "akitaonrails@me.com", id: 1,
  inserted_at: #Ecto.DateTime<2015-11-20T14:01:09Z>, password: nil,
  password_confirmation: nil,
  password_digest: "...",
  posts: #Ecto.Association.NotLoaded<association :posts is not loaded>,
  updated_at: #Ecto.DateTime<2015-11-20T14:01:09Z>, username: "akitaonrails"}]
```

E a forma como eu penso sobre isso é assim: o meu shell IEx está mandando uma mensagem para o Yocto Service chamado Pxblog.Repo (na verdade ele encaminha mensagens para o adapter de banco de dados que aí faz o checkout de um processo do pool). Exatamente como eu consumiria Micro Serviços externos via APIs HTTP.

Então o panorama da sua aplicação é composto por uma série de processos e grupos de processos supervisionados, todos trabalhando para compor uma estrutura maior. Como eu disse em artigos anteriores, se um grupo de processos colapsar, o Supervisor dele entra em ação, captura o erro e usa a sua estratégia para, por exemplo, reiniciar todos os processos filhos, trazendo a aplicação de volta para um estado consistente, e sem você ter que reiniciar a aplicação Elixir inteira.

Então cada processo pode ser um Yocto Service completo, rodando online e esperando outros serviços consumirem ele, como os workers do Repo.

### Dividir e Conquistar

De novo, como disclaimer, ainda sou novo em Elixir, mas a forma que eu acho mais fácil de entender é assim:

* Se você precisa lidar com recursos externos, seja um arquivo, conexões de rede ou qualquer coisa fora da Erlang VM, você vai querer que isso seja um GenServer.

* Aí, se você tem um GenServer, você quer dar start nele debaixo de um Supervisor (geralmente, o boilerplate simples que define os filhos e a estratégia de restart).

* O número de processos GenServer que você quer iniciar depende de quantos processos paralelos você quer ter rodando. Por exemplo, se for um serviço de banco de dados, não tem sentido iniciar mais do que o número máximo de conexões disponíveis que o banco permite. Se você tem vários arquivos para processar, você quer no máximo o número de arquivos disponíveis ou - na prática - só alguns processos para lidar com lotes de arquivos. Geralmente você vai querer um pool de processos GenServer e, nesse caso, você quer usar Poolboy.

* Um GenServer pode chamar outros GenServers. Você não quer usar mecanismo de tratamento de exceção do tipo try/catch porque o que você quer é justamente que aquele processo GenServer específico crashe se algo der errado: se o arquivo está corrompido, ou não existe, ou se a rede ficou instável ou caiu. O Supervisor vai substituir aquele processo por um GenServer novo no lugar dele e reabastecer o Pool se for preciso.

* Você pode fazer GenServers [conversarem remotamente](http://www.akitaonrails.com/2015/11/25/exmessenger-exercise-understanding-nodes-in-elixir) usando o recurso de Node que eu expliquei 2 posts atrás, com o exemplo do ExMessenger. Aí seria como uma arquitetura normal de Micro Serviços, mas onde os Yocto Services internos é que estão na verdade fazendo a conversa.

* Qualquer transformação sem efeitos colaterais (transformar uma entrada simples numa saída simples), tipo pegar uma string com o body de um HTML e fazer parse para uma Lista de tuplas, pode ser organizada num Module normal. Dá uma olhada em bibliotecas como [Floki](https://github.com/philss/floki) para ver como elas estão organizadas.

Cada Erlang VM (chamada de BEAM) é um único processo do SO, que gerencia uma única thread real por core de CPU disponível na sua máquina. Cada thread real é gerenciada pelo seu próprio BEAM Scheduler, que vai fatiar tempo de processamento entre os processos leves lá dentro.

Cada processo BEAM tem a sua própria caixa de mensagens para receber mensagens (mais corretamente chamada de **run-queue**). Operações de I/O como gerenciamento de arquivos vão rodar de forma assíncrona e não vão bloquear o scheduler, que vai conseguir rodar outros processos enquanto espera o I/O.

Cada processo BEAM também tem o seu próprio heap separado e o seu próprio garbage collector (um copy collector geracional, de 2 estágios). Como cada processo tem muito pouco estado (variáveis dentro de uma função), cada parada do garbage collector é super curta e roda rápido.

Então, cada VM BEAM pode ser pensada como uma infraestrutura inteira de aplicação, com vários Yocto Services disponíveis para a sua aplicação chamar.

E como eu disse no [artigo anterior](http://www.akitaonrails.com/2015/11/25/exmessenger-exercise-understanding-nodes-in-elixir), cada VM BEAM pode chamar remotamente outras VMs BEAM e trocar mensagens entre elas como se estivessem na mesma VM. As semânticas são quase as mesmas e você tem computação distribuída do jeito mais fácil.

A Erlang implementou um conjunto fantástico de primitivas que escalam rapidamente o quanto você quiser ou precisar, com as ligações certas para não te deixar na mão. E o Elixir conserta o único problema que a maioria das pessoas tem com Erlang: aquela [sintaxe estranha inspirada no velho Prolog](http://www.akitaonrails.com/2015/11/25/elixir-101-introducing-the-syntax). Elixir é uma camada fina e efetiva de design moderno de linguagem, em parte inspirada em Ruby (apesar de estar longe de ser um port, continua sendo Erlang por baixo).

Eu espero que essa série tenha ajudado a jogar alguma luz sobre por que Elixir é a melhor escolha entre a nova geração de linguagens preparadas para alta concorrência, e também espero ter deixado claro por que só alta concorrência não basta: você quer alta confiabilidade também. E nesse aspecto, a arquitetura OTP, embutida no Erlang, não tem competição.
