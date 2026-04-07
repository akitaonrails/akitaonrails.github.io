---
title: 'Exercício ExMessenger: Entendendo Nodes em Elixir'
date: '2015-11-25T13:19:00-02:00'
slug: exercicio-exmessenger-entendendo-nodes-em-elixir
translationKey: exmessenger-nodes-elixir
aliases:
- /2015/11/25/exmessenger-exercise-understanding-nodes-in-elixir/
tags:
- learning
- beginner
- elixir
- traduzido
draft: false
---

Eu estava me exercitando seguindo este [post antigo de 2014](http://drew.kerrigan.io/ditributed-elixir/) do Drew Kerrigan, onde ele constrói um chat bem simplório, baseado em linha de comando, com um cliente que envia mensagens e comandos para um servidor.

Isso é Elixir pré-1.0, e como é um exercício eu refatorei o código original e juntei os projetos do servidor (ex_messenger) e do cliente (ex_messenger_client) em um projeto [Elixir Umbrella](http://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-apps.html). Você pode encontrar meu código [aqui no Github](https://github.com/akitaonrails/ex_messenger_exercise/blob/master/apps/ex_messenger_client/lib/ex_messenger_client.ex).

Se você tem várias aplicações que trabalham juntas e compartilham as mesmas dependências, dá pra usar a convenção Umbrella pra ter todas elas no mesmo code base. Se você roda <tt>mix compile</tt> a partir da raiz do umbrella, ele compila todas as apps (que são projetos mix Elixir independentes também). É só uma forma de ter apps relacionadas no mesmo lugar em vez de em vários repositórios diferentes.

O código mostrado aqui está no [meu repositório pessoal no Github](https://github.com/akitaonrails/ex_messenger_exercise) caso você queira clonar.

### Nodes 101

Antes de checarmos o exercício, tem um conceito que eu preciso esclarecer. No artigo anterior eu expliquei como você pode iniciar processos e trocar mensagens, e como pode usar GenServer e Supervisor do OTP pra criar processos mais robustos e tolerantes a falhas.

Mas isso é só o começo da história. Você provavelmente já ouviu falar como Erlang também é ótimo pra computação distribuída. Cada VM Erlang (ou BEAM) já vem habilitada pra rede.

De novo, esse é mais um conceito que eu ainda estou começando a aprender direito, e você vai querer ler a documentação do site do Elixir sobre [Distributed tasks and configuration](http://elixir-lang.org/getting-started/mix-otp/distributed-tasks-and-configuration.html), que faz um excelente trabalho explicando como tudo isso funciona.

Mas só pra começar, você pode simplesmente abrir 2 sessões de IEx. De um terminal você pode fazer:

```
iex --sname fabio --cookie chat

Erlang/OTP 18 [erts-7.1] [source] [64-bit] [smp:4:4] [async-threads:10] [kernel-poll:false]

Interactive Elixir (1.1.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(fabio@Hal9000u)1> 
```

E de outro terminal diferente você pode fazer:

```
iex --sname akita --cookie chat

Erlang/OTP 18 [erts-7.1] [source] [64-bit] [smp:4:4] [async-threads:10] [kernel-poll:false]

Interactive Elixir (1.1.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(akita@Hal9000u)1> 
```

Repare como o shell do IEx mostra nomes de Node diferentes pra cada instância: "fabio@Hal9000u" e "akita@Hal9000u". É o sname concatenado com o nome da sua máquina. De uma instância você pode dar ping na outra, por exemplo:

```
iex(akita@Hal9000u)2> Node.ping(:"fabio@Hal9000u")
:pong
```

Se o nome estiver correto e a outra instância estiver de fato no ar, ela responde o ping com um <tt>:pong</tt>. Isso funciona pra nodes na mesma máquina, mas e se eu precisar conectar numa instância em uma máquina remota?

```
iex(akita@Hal9000u)3> Node.ping(:"fabio@192.168.1.13")

11:02:46.152 [error] ** System NOT running to use fully qualified hostnames **
** Hostname 192.168.1.13 is illegal **
```

A opção <tt>--sname</tt> define um nome alcançável apenas dentro da mesma subnet. Pra um nome de domínio totalmente qualificado você precisa usar <tt>--name</tt>, por exemplo, assim:

```
iex  --name fabio@192.168.1.13 --cookie chat
```

E pro outro node:

```
iex --name akita@192.168.1.13 --cookie chat
```

E desse segundo terminal você pode dar ping no outro node da mesma maneira que antes:

```
iex(akita@192.168.1.13)1> Node.ping(:"fabio@192.168.1.13")
:pong
```

E você deve estar se perguntando, que negócio é esse de "<tt>--cookie</tt>"? Suba um terceiro terminal com outro nome de cliente, mas sem o cookie, assim:

```
iex --name john@192.168.1.13
```

E se você tentar dar ping num dos dois primeiros nodes, não vai receber um <tt>:pong</tt> de volta:

```
iex(john@192.168.1.13)1> Node.ping(:"fabio@192.168.1.13")
:pang
```

O cookie é só um atom pra identificar relação entre os nodes. Em um pool de vários servidores, você consegue garantir que não está tentando conectar aplicações diferentes umas com as outras. E como resultado você recebe um <tt>:pang</tt>. No lugar de um endereço IP você pode usar um nome de domínio totalmente qualificado.

E só pelo node "akita@" ter dado ping no "fabio@" dá pra ver que eles agora estão cientes um do outro:

```
iex(fabio@192.168.1.13)2> Node.list
[:"akita@192.168.1.13"]
```

E:

```
iex(akita@192.168.1.13)2> Node.list
[:"fabio@192.168.1.13"]
```

Se um dos nodes crashar ou sair, a lista de Node é automaticamente atualizada pra refletir somente os nodes que de fato estão vivos e respondendo.

Você pode checar a Referência oficial da API do [Node](http://elixir-lang.org/docs/stable/elixir/Node.html#summary) pra mais informações. Mas isso já deve dar uma dica pro próximo trecho.

### Criando um Cliente de Chat

Voltando ao exercício, o servidor ExMessenger tem o "ExMessenger.Server", que é um GenServer, e o "ExMessenger.Supervisor" que sobe ele. O ExMessenger.Server é registrado globalmente como <tt>:message_server</tt>, iniciado e supervisionado pelo "ExMessenger.Supervisor".

O "ExMessengerClient" sobe o "ExMessengerClient.MessageHandler" (sem supervisão), que também é um GenServer, e registrado globalmente como <tt>:message_handler</tt>.

A Tree pra ambas as apps fica mais ou menos assim:

```
ExMessenger
- ExMessenger.Supervisor
    + ExMessenger.Server
ExMessengerClient
- ExMessengerClient.MessageHandler
```

Nós subimos eles separadamente, primeiro o message server:

```
cd apps/ex_messenger
iex --sname server --cookie chocolate-chip -S mix run
```

Repare que pra esse exemplo estamos subindo com um nome simples "server", pra subnet local, e um cookie. Vai responder como "server@Hal9000u" (Hal9000u sendo o nome da minha máquina local).

Em seguida, podemos subir o app cliente:

```
cd apps/ex_messenger_client
server=server@Hal9000u nick=john elixir --sname client -S mix run
```

Aqui estamos definindo 2 variáveis de ambiente (que podemos recuperar dentro da app usando <tt>System.get_env/1</tt>) e também definindo o nome local do node como "client". Você pode subir mais nodes cliente usando um "sname" diferente e um "nick" diferente em outro terminal, quantos você quiser, todos linkando no mesmo message server "server@Hal9000u".

Estou subindo desse jeito em vez de usar um escript de linha de comando como fiz no ExMangaDownloadr porque eu não achei nenhuma forma de definir o <tt>--sname</tt> ou <tt>--name</tt> da mesma forma que dá pra definir o <tt>--cookie</tt> usando <tt>Node.set_cookie</tt>. Se alguém souber como configurar isso de outro jeito, me avisa nos comentários aí embaixo.

Repare que eu disse "linkando" e não "conectando". Do "ExMessengerClient" começamos assim:

```ruby
defmodule ExMessengerClient do
  use Application
  alias ExMessengerClient.CLI
  alias ExMessengerClient.ServerProcotol

  def start(_type, _args) do
    get_env
      |> connect
      |> start_message_handler
      |> join_chatroom
      |> CLI.input_loop
  end
  ...
end
```

A função privada <tt>get_env</tt> é só um wrapper pra tratar as variáveis de ambiente "server" e "nick" que passamos:

```ruby
defp get_env do
  server = System.get_env("server")
    |> String.rstrip
    |> String.to_atom
  nick = System.get_env("nick")
    |> String.rstrip
  {server, nick}
end
```

Agora, tentamos conectar no servidor remoto:

```ruby
defp connect({server, nick}) do
  IO.puts "Connecting to #{server} from #{Node.self} ..."
  Node.set_cookie(Node.self, :"chocolate-chip")
  case Node.connect(server) do
    true -> :ok
    reason ->
      IO.puts "Could not connect to server, reason: #{reason}"
      System.halt(0)
  end
  {server, nick}
end
```

A parte importante aqui é que estamos definindo o cookie da instância do cliente com <tt>Node.set_cookie/1</tt> (repare que não passamos ele nas opções de linha de comando como fizemos com a instância do servidor). Sem definir o cookie, a próxima linha com <tt>Node.connect(server)</tt> falharia em conectar, como expliquei na seção anterior.

Em seguida, subimos o GenServer "ExMessengerClient.MessageHandler", linkando com a instância do Message Server:

```ruby
defp start_message_handler({server, nick}) do
  ExMessengerClient.MessageHandler.start_link(server)
  IO.puts "Connected"
  {server, nick}
end
```

O GenServer Message Handler em si é bem simples, ele só guarda o servidor como estado e trata mensagens recebidas do servidor, imprimindo no terminal do cliente:

```ruby
defmodule ExMessengerClient.MessageHandler do
  use GenServer

  def start_link(server) do
    :gen_server.start_link({ :local, :message_handler }, __MODULE__, server, [])
  end

  def init(server) do
    { :ok, server }
  end

  def handle_cast({ :message, nick, message }, server) do
    message = message |> String.rstrip
    IO.puts "\n#{server}> #{nick}: #{message}"
    IO.write "#{Node.self}> "
    {:noreply, server}
  end
end
```

Voltando pro módulo principal "ExMessengerClient", depois de subir o GenServer (não supervisionado) que recebe as mensagens entrantes, partimos pra entrar na pseudo-chatroom no servidor:

```ruby
defp join_chatroom({server, nick}) do
  case ServerProcotol.connect({server, nick}) do
    {:ok, users} ->
      IO.puts "* Joined the chatroom *"
      IO.puts "* Users in the room: #{users} *"
      IO.puts "* Type /help for options *"
    reason ->
      IO.puts "Could not join chatroom, reason: #{reason}"
      System.halt(0)
  end
  {server, nick}
end
```

Eu defini esse módulo "ServerProcotol" que é só um wrapper de conveniência pra chamadas <tt>GenServer.call/3</tt> e <tt>GenServer.cast/2</tt>, pra mandar mensagens pro GenServer remoto chamado <tt>:message_server</tt>:

```ruby
defmodule ExMessengerClient.ServerProcotol do
  def connect({server, nick}) do
    server |> call({:connect, nick})
  end

  def disconnect({server, nick}) do
    server |> call({:disconnect, nick})
  end

  def list_users({server, nick}) do
    server |> cast({:list_users, nick})
  end

  def private_message({server, nick}, to, message) do
    server |> cast({:private_message, nick, to, message})
  end

  def say({server, nick}, message) do
    server |> cast({:say, nick, message})
  end

  defp call(server, args) do
    GenServer.call({:message_server, server}, args)
  end

  defp cast(server, args) do
    GenServer.cast({:message_server, server}, args)
  end
end
```

Bem direto. Em seguida, o ExMessengerClient principal chama a função recursiva <tt>input_loop/1</tt> do módulo CLI, que só recebe input do usuário e trata os comandos apropriados usando pattern matching, assim:

```ruby
defmodule ExMessengerClient.CLI do
  alias ExMessengerClient.ServerProcotol

  def input_loop({server, nick}) do
    IO.write "#{Node.self}> "
    line = IO.read(:line)
      |> String.rstrip
    handle_command line, {server, nick}
    input_loop {server, nick}
  end

  def handle_command("/help", _args) do
    IO.puts """
    Available commands:
      /leave
      /join
      /users
      /pm <to nick> <message>
      or just type a message to send
    """
  end

  def handle_command("/leave", args) do
    ServerProcotol.disconnect(args)
    IO.puts "You have exited the chatroom, you can rejoin with /join or quit with /quit"
  end

  def handle_command("/quit", args) do
    ServerProcotol.disconnect(args)
    System.halt(0)
  end

  def handle_command("/join", args) do
    ServerProcotol.connect(args)
    IO.puts "Joined the chatroom"
  end

  def handle_command("/users", args) do
    ServerProcotol.list_users(args)
  end

  def handle_command("", _args), do: :ok

  def handle_command(nil, _args), do: :ok

  def handle_command(message, args) do
    if String.contains?(message, "/pm") do
      {to, message} = parse_private_recipient(message)
      ServerProcotol.private_message(args, to, message)
    else
      ServerProcotol.say(args, message)
    end
  end

  defp parse_private_recipient(message) do
    [to|message] = message
      |> String.slice(4..-1)
      |> String.split
    message = message
      |> List.foldl("", fn(x, acc) -> "#{acc} #{x}" end)
      |> String.lstrip
    {to, message}
  end
end
```

E isso encerra o Cliente.

### Criando um Servidor de Chat

O Chat Client manda mensagens GenServer pra um <tt>{:message_server, server}</tt> remoto, e no exemplo, <tt>server</tt> é só o atom do sname "server@Hal9000u".

Agora, precisamos desse <tt>:message_server</tt> e ele é o GenServer "ExMessenger.Server":

```ruby
defmodule ExMessenger.Server do
  use GenServer
  require Logger

  def start_link([]) do
    :gen_server.start_link({ :local, :message_server }, __MODULE__, [], [])
  end

  def init([]) do
    { :ok, HashDict.new }
  end
  ...
end
```

E é isso, quando o "ExMessenger.Supervisor" sobe esse GenServer, ele registra globalmente nessa instância como <tt>:message_server</tt>. E é assim que endereçamos mensagens vindas do que chamamos de "clientes" (a aplicação ExMessengerClient).

Quando o ExMessengerClient chama o <tt>ServerProtocol.connect/1</tt>, ele manda a mensagem <tt>{:connect, nick}</tt> pro servidor. No Servidor, tratamos assim:

```ruby
def handle_call({ :connect, nick }, {from, _} , users) do
  cond do
    nick == :server or nick == "server" ->
      {:reply, :nick_not_allowed, users}
    HashDict.has_key?(users, nick) ->
      {:reply, :nick_in_use, users}
    true ->
      new_users = users |> HashDict.put(nick, node(from))
      user_list = log(new_users, nick, "has joined")
      {:reply, { :ok, user_list }, new_users}
  end
end
```

Primeiro, ele checa se o nick é "server" e proíbe. Segundo, checa se o nickname já existe no [HashDict](http://elixir-lang.org/docs/stable/elixir/HashDict.html) interno (um dicionário chave/valor) e recusa caso já exista. Por fim, em terceiro, coloca o par de nickname e nome do node (tipo "client@Hal9000u") no HashDict e faz broadcast através da função privada <tt>log/3</tt> pra todos os outros nodes no dicionário HashDict.

O <tt>log/3</tt> só monta uma mensagem de log concatenando os nicks de todos os clientes e imprime ela, depois faz broadcast disso pro Message Handler de todos os clientes listados no HashDict:

```ruby
defp log(users, nick, message) do
  user_list = users |> HashDict.keys |> Enum.join(":")
  Logger.debug("#{nick} #{message}, user_list: #{user_list}")
  say(nick, message)
  user_list
end

def say(nick, message) do
  GenServer.cast(:message_server, { :say, nick, "* #{nick} #{message} *" })
end

def handle_cast({ :say, nick, message }, users) do
  ears = HashDict.delete(users, nick)
  Logger.debug("#{nick} said #{message}")
  broadcast(ears, nick, message)
  {:noreply, users}
end
```

Até esse ponto ele só faz cast de uma mensagem pra ele mesmo, a tupla <tt>{:say, nick, message}</tt>, que é tratada pelo GenServer chamando a função <tt>broadcast/3</tt> definida assim:

```ruby
defp broadcast(users, nick, message) do
  Enum.map(users, fn {_, node} ->
    Task.async(fn ->
      send_message_to_client(node, nick, message)
    end)
  end)
  |> Enum.map(&Task.await/1)
end

defp send_message_to_client(client_node, nick, message) do
  GenServer.cast({ :message_handler, client_node }, { :message, nick, message })
end
```

Ele mapeia a lista de usuários e dispara uma <tt>Task</tt> Elixir assíncrona (que ela mesma é só um GenServer, como expliquei antes na série Ex Manga Downloader). Como é um broadcast, faz sentido fazer todas elas em paralelo.

A parte importante é o <tt>send_message_to_client/3</tt> que faz cast de uma mensagem pra tupla <tt>{ :message_handler, client_node }</tt> onde "client_node" é só "client@Hal9000u" ou qualquer outro "--sname" que você usou pra subir cada node cliente.

Pronto, é assim que os clientes mandam calls/casts de GenServer pra <tt>{:message_server, server}</tt> e ele manda mensagens de volta pra <tt>{:message_handler, client</tt>.

### Esse não é o seu exemplo tradicional de Cliente/Servidor TCP!

Agora, estamos chamando o "ExMessenger.Server" de "Servidor" de Chat e o "ExMessengerClient" de "Cliente" de Chat. Apesar de termos chamado eles de "Servidor" e "Cliente", eles não se referem aos exemplos comuns de "Servidor TCP" e "Cliente TCP" com os quais você talvez esteja familiarizado!

O ExMessenger.Server é de fato um Servidor (um GenServer OTP) mas o ExMessengerClient.MessageHandler também é um Servidor (outro GenServer OTP)! Mas como **ambos** têm comportamento de Node, eles são mais como 2 nodes peer-to-peer do que aquela velha relação simples de cliente->servidor da escola antiga. Eles podem ter comportamento de cliente (o Server manda mensagens pro MessageHandler) e comportamento de servidor (o Server recebendo mensagens do ExMessengerClient).

Deixa esse conceito assentar por um momento: já embutido na linguagem você ganha um modelo completo de distribuição de rede peer-to-peer, fácil de usar. Você não precisa ter um único node eleito como o "node" exclusivo. Você poderia ter todos os nodes em um anel se coordenando entre si, evitando pontos únicos de falha.

Eu acredito que talvez seja assim que serviços baseados em Erlang como [ejabberd](http://manpages.ubuntu.com/manpages/hardy/man8/ejabberd.8.html) e [RabbitMQ](https://www.rabbitmq.com/clustering.html) funcionam.

No [caso do ejabberd](https://github.com/processone/ejabberd/blob/master/src/ejabberd_cluster.erl), dá pra ver que ele mantém o estado do cluster em tabelas Mnesia (Mnesia sendo mais um componente do OTP, é um banco NoSQL distribuído já embutido!) e ele de fato usa as facilidades de Node pra coordenar nodes distribuídos:

```erlang
...
join(Node) ->
    case {node(), net_adm:ping(Node)} of
        {Node, _} ->
            {error, {not_master, Node}};
        {_, pong} ->
            application:stop(ejabberd),
            application:stop(mnesia),
            mnesia:delete_schema([node()]),
            application:start(mnesia),
            mnesia:change_config(extra_db_nodes, [Node]),
            mnesia:change_table_copy_type(schema, node(), disc_copies),
            spawn(fun()  ->
                lists:foreach(fun(Table) ->
                            Type = call(Node, mnesia, table_info, [Table, storage_type]),
                            mnesia:add_table_copy(Table, node(), Type)
                    end, mnesia:system_info(tables)--[schema])
                end),
            application:start(ejabberd);
        _ ->
            {error, {no_ping, Node}}
    end.
```

É assim que um trecho de código fonte Erlang puro fica, aliás. Você já deve ter Elixir suficiente na cabeça pra conseguir abstrair a sintaxe feia do Erlang e ver que é um <tt>case</tt> fazendo pattern matching na tupla <tt>{_, :pong}</tt>, usando as facilidades de ping do Node pra atestar a conectividade do node e atualizar a tabela Mnesia e outras configurações.

Também no [código fonte do RabbitMQ-Server](https://github.com/rabbitmq/rabbitmq-server/blob/6f70dcbe05dbba35f7d950674d293a4c7d867d44/src/rabbit_control_main.erl) você vai encontrar uma coisa parecida:

```erlang
become(BecomeNode) ->
    error_logger:tty(false),
    ok = net_kernel:stop(),
    case net_adm:ping(BecomeNode) of
        pong -> exit({node_running, BecomeNode});
        pang -> io:format("  * Impersonating node: ~s...", [BecomeNode]),
                {ok, _} = rabbit_cli:start_distribution(BecomeNode),
                io:format(" done~n", []),
                Dir = mnesia:system_info(directory),
                io:format("  * Mnesia directory  : ~s~n", [Dir])
    end.
```

De novo, dando ping em nodes, usando Mnesia pro estado do servidor. A sintaxe do Erlang é incomum pra maioria de nós: variáveis começam com letra maiúscula (intuitivamente a gente acha que é uma constante), comandos terminam com ponto, em vez da notação com ponto pra chamar funções de um módulo ele usa dois pontos ":", diferente de Elixir os parênteses não são opcionais, e por aí vai. Tentar ler código assim mostra o valor de ter Elixir pra desbloquear os poderes escondidos de Erlang.

Então, até esse ponto, você sabe como internamente os processos são spawnados, como eles são orquestrados dentro do framework OTP, e agora como eles podem interagir remotamente através da abstração peer-to-peer de **Node**. E de novo, isso tudo já vem embutido na linguagem. Nenhuma outra linguagem chega nem perto.
