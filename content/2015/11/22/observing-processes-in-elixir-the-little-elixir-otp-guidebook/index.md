---
title: "Observando Processos em Elixir - The Little Elixir & OTP Guidebook"
date: '2015-11-22T14:57:00-02:00'
slug: observando-processos-em-elixir-the-little-elixir-otp-guidebook
translationKey: observing-processes-elixir
aliases:
- /2015/11/22/observing-processes-in-elixir-the-little-elixir-otp-guidebook/
tags:
- learning
- beginner
- elixir
- traduzido
draft: false
---

Na minha jornada para entender de verdade como uma aplicação Elixir decente deve ser escrita, estou me exercitando com o excelente [The Little Elixir & OTP Guidebook](https://www.manning.com/books/the-little-elixir-and-otp-guidebook), do Benjamin Tan Wei Hao. Se você está começando agora, é decisão óbvia: compre e estude esse guia. E sim, ajuda muito se você tiver lido antes o [Programming Elixir](https://pragprog.com/book/elixir/programming-elixir) do Dave Thomas.

No meu artigo [Ex Manga Downloadr Parte 2](http://www.akitaonrails.com/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue) eu explorei como adicionar um controle melhor de pool de processos usando a excelente e robusta biblioteca Poolboy. Um dos exercícios principais do guia é justamente construir uma versão mais simples do Poolboy em Elixir puro (o Poolboy é escrito no bom e velho Erlang).

O objetivo principal deste artigo é introduzir o que **Tolerância a Falhas** significa no Erlang/Elixir, e também é uma desculpa pra eu mostrar o observer do Erlang:

![Observer](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/528/big_observer-kill.png)

Sim, o Erlang permite que a gente veja o que está acontecendo dentro do seu runtime e ainda tome ações sobre Processos individuais rodando lá dentro! Que coisa mais legal, não?

Mas antes de mostrar Tolerância a Falhas e o Observer eu preciso explicar o que são Processos e por que eles importam. Você **precisa** entender os seguintes conceitos pra conseguir programar bem em Elixir:

1. Você não tem "objetos", que são instâncias em runtime de classes (ou objetos prototípicos, que são cópias de outros objetos). No lugar de "Classes" você tem coleções de funções organizadas em módulos, sem dependência de estado interno. E no lugar de "objetos" temos, falando grosseiramente, "processos". Por exemplo:

```ruby
defmodule MyProcess do
  def start do
    accepting_messages(0)
  end

  def accepting_messages(state) do
    receive do
      {:hello, message} ->
        IO.puts "Hello, #{message}"
        accepting_messages(state)
      {:counter} ->
        new_state = state + 1
        IO.puts "New state is #{new_state}"
        accepting_messages(new_state)
      _ ->
        IO.puts "What?"
        accepting_messages(state)
    end
  end
end
```

2. Podemos executar uma função dentro de outro processo. É assim que damos spawn em um processo novo, concorrente e leve:

```ruby
iex(2)> pid = spawn fn -> MyProcess.start end
#PID<0.87.0>
```

Quando o <tt>accepting_messages/1</tt> é chamado, ele para no bloco <tt>receive/0</tt>, esperando receber uma nova mensagem. Aí podemos enviar mensagens assim:

```ruby
iex(3)> send pid, {:hello, "world"}
Hello, world
```

Ele recebe o átomo <tt>{:hello, "world"}</tt>, faz pattern match do valor <tt>"world"</tt> na variável <tt>message</tt>, concatena a string <tt>"Hello, world"</tt>, imprime com <tt>IO.puts/1</tt> e recursa pra si mesmo. Chamamos o bloco <tt>receive/0</tt> de novo e bloqueamos, esperando novas mensagens:

```ruby
iex(4)> send pid, {:counter}
New state is 1
{:counter}
iex(5)> send pid, {:counter}
New state is 2
{:counter}
iex(6)> send pid, {:counter}
New state is 3
{:counter}
iex(7)> send pid, {:counter}
New state is 4
```

Mandamos a mensagem <tt>{:counter}</tt> pro mesmo pid de novo e, quando ele recebe essa mensagem, pega o valor de <tt>state</tt> do argumento da função, incrementa em 1, imprime o novo estado, e chama a si mesmo passando o novo estado como novo argumento. Ele bloqueia de novo, esperando novas mensagens, e cada vez que recebe a mensagem <tt>{:counter}</tt>, incrementa o estado anterior em mais um e recursa.

É basicamente assim que mantemos estado em Elixir. Se matarmos esse processo e dermos spawn em um novo, ele recomeça do zero (que é o que a função <tt>start/0</tt> faz).

3. Então, mesmo sem ter "objetos", você tem Processos. Superficialmente, um processo se comporta como um "objeto". Cuidado pra não pensar que um Processo é como uma Thread pesada. O Erlang tem seu próprio scheduler interno que controla a concorrência dos paralelos e você pode carregar até 16 bilhões de processos leves se o seu hardware permitir. Threads são super pesadas, processos Erlang são super leves.

4. Como vimos no exemplo, cada processo tem seu próprio mecanismo interno pra receber mensagens de outros processos. Essas mensagens se acumulam numa "caixa de mensagens" interna e você pode escolher dar <tt>receive</tt> e fazer pattern match nelas, recursando em si mesmo pra receber novas mensagens, se quiser.

5. Processos podem ser linkados a outros processos ou monitorá-los. Por exemplo, dentro de um shell IEx, estamos dentro de um processo Elixir, então podemos fazer:

```ruby
iex(1)> self
#PID<0.98.0>
iex(2)> pid = spawn fn -> MyProcess.start end
#PID<0.105.0>
iex(3)> Process.alive?(pid)
true
iex(4)> Process.link(pid)
true
```

Com <tt>self</tt> conseguimos ver que o id do processo atual do shell IEx é "0.98.0". Aí damos spawn num processo que chama o <tt>MyProcess.start/0</tt> de novo, ele vai bloquear no receive. Esse processo novo tem um id diferente, "0.105.0".

Podemos confirmar que o novo processo está vivo e linkar o shell IEx com o pid "0.105.0". Agora, qualquer coisa que aconteça com esse processo vai cascatear pro shell.

```ruby
iex(5)> Process.exit(pid, :kill)
** (EXIT from #PID<0.98.0>) killed

Interactive Elixir (1.1.1) - press Ctrl+C to exit (type h() ENTER for help)
/home/akitaonrails/.iex.exs:1: warning: redefining module R
iex(1)> self
#PID<0.109.0>
```

E de fato, se mandarmos uma mensagem de kill à força pro processo "0.105.0", o shell IEx também é morto no processo. O IEx reinicia e seu novo pid é "0.109.0" no lugar do antigo "0.98.0". A propósito, essa é uma maneira em que um processo difere de um objeto comum. Ele se comporta mais como um processo de sistema operacional, onde um crash em um processo não afeta o sistema inteiro, já que não segura estado externo compartilhado que possa corromper o estado do sistema.

O conceito importante é que agora temos um mecanismo pra definir um Processo Pai (o IEx, neste exemplo) e Processos Filhos linkados a ele.

6. Processos pais não precisam suicidar-se de forma idiota só porque os filhos pisaram na bola. Em vez disso, eles podem capturar exits e decidir o que fazer depois:

```ruby
iex(2)> Process.flag(:trap_exit, true)
false
iex(3)> pid = spawn_link fn -> MyProcess.start end
#PID<0.118.0>
iex(4)> send pid, {:counter}
New state is 1
{:counter}
```

Primeiro declaramos que o shell IEx vai capturar exits e não simplesmente morrer. Aí damos spawn num novo processo e o linkamos. A função <tt>spawn_link/1</tt> tem o mesmo efeito de fazer <tt>spawn/1</tt> seguido de <tt>Process.link/1</tt>. Mandamos uma mensagem pro novo pid e confirmamos que ele continua funcionando.

```ruby
iex(5)> Process.exit(pid, :kill)
true
iex(6)> Process.alive?(pid)
false
iex(7)> flush
{:EXIT, #PID<0.118.0>, :killed}
:ok
```

Agora forçamos o kill no novo processo de novo, mas o IEx não trava dessa vez, porque está explicitamente capturando esses erros. Se checarmos o pid morto, confirmamos que ele realmente está morto. E agora também podemos inspecionar a caixa de mensagens do próprio processo do IEx (no caso, só dando flush no que está enfileirado no inbox) e ver que ele acabou de receber uma mensagem dizendo que seu filho foi morto.

A partir daí podemos fazer o processo do IEx tratar essa mensagem e decidir só lamentar a morte do seu filho falecido e suicidar-se também, ou seguir em frente e dar spawn_link num novo. Temos **escolha** em meio ao desastre.

### OTP Workers

Deixando a metáfora macabra de lado, aprendemos que temos processos Pai e Filho, mas, mais importante, eles podem assumir os papéis de Supervisores e Workers supervisionados, respectivamente.

Workers é onde colocamos nosso código. Esse código pode ter bugs, pode depender de coisas externas que podem fazer nosso código crashar por motivos inesperados. Numa linguagem normal a gente começaria a usar os temidos blocos <tt>try/catch</tt>, que são feios e **errados**! Não capture erros em Elixir, deixe quebrar!!

Como expliquei no meu artigo anterior, tudo em Elixir acaba sendo o que se chama de "OTP application". O exemplo acima é só uma engenhoca bem simples que podemos expandir. Vamos reescrever a mesma coisa como um OTP GenServer:

```ruby
defmodule MyFancyProcess do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  ## Public API

  def hello(message) do
    GenServer.call(__MODULE__, {:hello, message})
  end

  def counter do
    GenServer.call(__MODULE__, :counter)
  end

  ## GenServer callbacks

  def init(start_counter) do
    {:ok, start_counter}
  end

  def handle_call({:hello, message}, _from, state) do
    IO.puts "Hello, #{message}"
    {:reply, :noproc, state}
  end

  def handle_call(:counter, _from, state) do
    new_state = state + 1
    IO.puts "New state is #{new_state}"
    {:reply, :noproc, new_state}
  end
end
```

Esse novo <tt>MyFancyProcess</tt> é essencialmente o mesmo que o <tt>MyProcess</tt>, só que com OTP GenServer por cima. Tem funções da Public API e callbacks do GenServer.

O livro do Benjamin se aprofunda em cada bit do que acabei de implementar. Mas por agora entenda algumas coisas básicas:

1. O módulo faz "<tt>use GenServer</tt>" pra importar todas as partes necessárias do GenServer pra sua conveniência. Em essência, uma das coisas que ele faz é criar aquele bloco <tt>receive</tt> que fizemos na primeira versão pra esperar por mensagens.

2. A função <tt>start_link/1</tt> vai criar a instância desse GenServer e devolver o processo linkado. Internamente ela faz callback pra função <tt>init/1</tt> pra setar o estado inicial desse worker. Essa é uma linguagem flexível, temos várias maneiras de fazer a mesma coisa, e isso é bom; ter só uma única forma de escrever código é chato.

3. A convenção é ter uma função pública que chama o <tt>handle_call/3</tt> interno (pra chamadas síncronas), <tt>handle_cast/2</tt> (pra chamadas assíncronas), e <tt>handle_info/2</tt>. Você poderia simplesmente chamar <tt>handle_call</tt> direto de fora, mas é feio, então você vai encontrar essa convenção em todo lugar.

Com isso no lugar, podemos começar a chamá-lo direto:

```ruby
iex(11)> MyFancyProcess.start_link(0)
{:ok, #PID<0.261.0>}
iex(12)> MyFancyProcess.hello("world")
Hello, world
:noproc
iex(13)> MyFancyProcess.counter
New state is 1
:noproc
iex(14)> MyFancyProcess.counter
New state is 2
:noproc
iex(15)> MyFancyProcess.counter
New state is 3
:noproc
```

E isso é muito mais limpo do que a versão onde fizemos <tt>spawn_link</tt> manual e mandamos <tt>send</tt> de mensagens pra um pid. Tudo isso é tratado de forma elegante pelo GenServer por baixo. E como eu disse, os resultados são os mesmos do exemplo cru do <tt>MyProcess</tt>.

Na verdade, essa convenção faz a gente digitar muita boilerplate várias vezes. Existe uma biblioteca chamada [ExActor](https://github.com/sasa1977/exactor) que simplifica bastante uma implementação de GenServer, fazendo nosso código anterior virar algo assim:

```ruby
defmodule MyFancyProcess do
  use ExActor.GenServer, initial_state: 0

  defcall hello(message), state do
    IO.puts "Hello, #{message}"
    noreply
  end

  defcall counter, state do
    new_counter = state + 1
    IO.puts "New state is #{new_counter}"
    new_state(new_counter)
  end
end
```

Bem mais limpo, mas como estamos só usando o IEx, não vou usar essa versão na próxima seção. Fique com a versão mais longa do <tt>MyFancyProcess</tt> listada no começo desta seção!

## OTP Supervisor

Agora que temos um worker, podemos criar um Supervisor pra supervisioná-lo:

```ruby
defmodule MyFancySupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      worker(MyFancyProcess, [0])
    ]

    opts = [strategy: :one_for_one]

    supervise(children, opts)
  end
end
```

Esse é só um boilerplate simples que a maioria dos Supervisors vai ter. Tem muitos detalhes que você precisa aprender, mas pra fins deste artigo as partes importantes são, primeiro, a definição da especificação dos <tt>children</tt>, dizendo que esse Supervisor deve iniciar o GenServer <tt>MyFancyProcess</tt> em vez de termos que fazer <tt>MyFancyProcess.start_link</tt> manualmente. E a segunda parte importante é a lista de <tt>opts</tt> que define a estratégia <tt>:one_for_one</tt>, ou seja, se o Supervisor detecta que o filho morreu, deve reiniciá-lo.

A partir de um IEx limpo, podemos copiar e colar tanto o <tt>MyFancyProcess</tt> quanto o <tt>MyFancySupervisor</tt> acima e começar a brincar com isso no shell IEx:

```ruby
iex(3)> {:ok, sup_pid} = MyFancySupervisor.start_link   
{:ok, #PID<0.124.0>}
iex(4)> MyFancyProcess.hello("foo")
Hello, foo
:noproc
iex(5)> MyFancyProcess.counter     
New state is 1
:noproc
iex(6)> MyFancyProcess.counter
New state is 2
:noproc
```

É assim que iniciamos o Supervisor e dá pra ver que de cara já podemos mandar mensagens pro GenServer <tt>MyFancyProcess</tt>, porque o Supervisor o iniciou pra gente com sucesso.

```ruby
iex(7)> Supervisor.count_children(sup_pid)
%{active: 1, specs: 1, supervisors: 0, workers: 1}
iex(8)> Supervisor.which_children(sup_pid)
[{MyFancyProcess, #PID<0.125.0>, :worker, [MyFancyProcess]}]
```

Usando o PID do Supervisor que capturamos quando o iniciamos, podemos pedir pra ele contar quantos filhos está monitorando (1, neste exemplo) e podemos pedir os detalhes de cada um também. Dá pra ver que o <tt>MyFancyProcess</tt> começou com o pid "0.125.0".

```ruby
iex(9)> [{_, worker_pid, _, _}] = Supervisor.which_children(sup_pid)
[{MyFancyProcess, #PID<0.125.0>, :worker, [MyFancyProcess]}]
iex(14)> Process.exit(worker_pid, :kill)
true
```

Agora, podemos pegar o pid do Worker e forçá-lo a crashar manualmente como fizemos antes. Devíamos estar ferrados, certo? Não:

```
iex(15)> Supervisor.which_children(sup_pid)                          
[{MyFancyProcess, #PID<0.139.0>, :worker, [MyFancyProcess]}]

iex(16)> MyFancyProcess.counter
New state is 1
:noproc
iex(17)> MyFancyProcess.counter
New state is 2
:noproc
```

Se perguntarmos ao Supervisor de novo a lista de filhos, vamos ver que o velho processo "0.125.0" sumiu mesmo, mas um novo, "0.139.0", foi spawnado em seu lugar pela estratégia <tt>:one_for_one</tt> do Supervisor que definimos antes.

Podemos continuar fazendo chamadas pro <tt>MyFancyProcess</tt>, mas você vai ver que o estado anterior foi perdido e ele recomeça do zero. Podemos adicionar gerenciamento de estado no GenServer usando vários storages persistentes diferentes, como o [ETS](http://elixir-lang.org/getting-started/mix-otp/ets.html) embutido (pense no ETS como um Memcache embutido), mas acho que você já pegou a ideia.

### Visualizando Processos Graficamente

Esse artigo inteiro foi motivado por essa coisinha simples no livro do Benjamin: lá pelo final da página 139 do livro você terá construído um sistema de pool bem simples capaz de iniciar 5 processos no pool, guardados por um supervisor. E daí ele parte pra mostrar o Observer.

O Erlang tem uma ferramenta inspetora embutida chamada Observer. Você pode usar as funções built-in do Supervisor pra inspecionar processos como demonstrei antes, mas é bem mais legal ver isso visualmente. Assumindo que você instalou o Erlang Solutions corretamente, no Ubuntu você precisa:

```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
```

Só então você pode iniciar o observer direto do shell IEx assim:

```
:observer.start
```

E uma janela gráfica vai aparecer com algumas estatísticas pra começar.

![Observer](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/530/big_observer-system.png)

Isso é **muito** poderoso porque você tem visibilidade e controle sobre todo o runtime do Erlang! Veja que essa janela de status mostra até "uptime", é como um sistema UNIX: foi feito pra ficar de pé não importa o que aconteça. Os processos têm seu próprio garbage collector e todos se comportam direitinho dentro do sistema.

Você também pode acoplar um Observer remoto a runtimes Erlang remotos, caso esteja se perguntando. Agora dá pra pular pra aba Applications pra ver como o exercício "Pooly" fica com 5 filhos no pool:

![Pooly](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/527/big_observer-pooly.png)

Como esses filhos são supervisionados com estratégias de restart corretas, podemos matar visualmente um deles, o que tem o pid rotulado como "0.389.0":

![Kill process](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/528/big_observer-kill.png)

E como o Observer mostra na hora, o Supervisor entrou em ação, deu spawn num novo filho e o adicionou ao pool, trazendo a contagem de volta pra 5:

![Respawn](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/529/big_observer-restart.png)

É isso que **Tolerância a Falhas** com controles adequados significa usando OTP!

Com as partes que expliquei neste artigo você deve ter conceitos suficientes pra finalmente entender do que se trata todo esse alarde sobre alta confiabilidade do Erlang. Os conceitos básicos são bem simples, plugar sua aplicação no OTP também é molezinha; o que o OTP tem implementado por baixo dos panos é o que torna sua aplicação muito mais confiável.

Há diretrizes claras sobre como projetar sua aplicação. Quem supervisiona o quê. O que deve acontecer com o estado da aplicação se workers forem reiniciados? Como dividir responsabilidades entre diferentes grupos de Supervisor/Children?

Sua aplicação deveria parecer uma Árvore, uma **Árvore de Supervisão**, onde uma falha em uma folha não derruba os outros galhos e tudo sabe como se comportar e como se recuperar, com elegância. É realmente como um sistema operacional UNIX: quando você dá <tt>kill -9</tt> num processo, isso não derruba o sistema, e se for um serviço monitorado pelo <tt>initd</tt>, ele é respawnado.

Mais importante: isso não é uma feature opcional, uma biblioteca de terceiros, que você escolhe usar. É embutido no Erlang, você precisa usar se quiser jogar. Não há outra escolha e essa é a melhor escolha. Qualquer padrão desses que não esteja implementado numa linguagem concorrente, pra mim, representa uma grande falha da linguagem. Essa é a força do Elixir.

Esse é um nível de controle alto que você não vai encontrar em outro lugar. E ainda nem falamos sobre como aplicações OTP podem trocar mensagens pela rede em sistemas realmente distribuídos, e como o runtime do Erlang consegue recarregar código enquanto a aplicação está rodando, com zero downtime, parecido com o que o próprio IEx é capaz e como o Phoenix permite o modo de desenvolvimento com code reloading! O OTP dá tudo isso de graça, então vale muito a pena aprender todos os detalhes.

Passamos por processos, pids, mandar uma mensagem de kill pra um processo, capturar exits, processo pai tendo processos filhos. Parece bem similar ao funcionamento do UNIX. Se você conhece UNIX, fica fácil entender como tudo isso se encaixa, incluindo o operador pipe do Elixir "|>" comparado ao próprio pipe "|" do UNIX, é parecido.

Pra fechar, o The Little Elixir & OTP Guidebook é um livro bem fácil de ler, bem mão na massa, pequeno. Você consegue ler em alguns dias e absorver tudo que resumi rapidamente aqui e muito mais. Recomendo demais que você compre agora.
