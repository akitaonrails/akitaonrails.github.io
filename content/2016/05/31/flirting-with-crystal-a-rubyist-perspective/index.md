---
title: "Flertando com Crystal, a Perspectiva de um Rubyista"
date: '2016-05-31T18:21:00-03:00'
slug: flertando-com-crystal-perspectiva-de-um-rubyista
translationKey: flirting-with-crystal-rubyist
aliases:
- /2016/05/31/flirting-with-crystal-a-rubyist-perspective/
tags:
- crystal
- traduzido
draft: false
---

Quem me acompanha sabe que ando me distraindo com [Elixir](/elixir) ultimamente. Vou fazer uma introdução grande antes de mergulhar no Crystal, então tenham paciência.

Vou logo dizer: o Erlang OTP e suas entranhas me intrigam mais do que apenas a novidade da sintaxe da linguagem. Acredito que se você quer construir sistemas altamente distribuídos e também altamente confiáveis, ou você vai usar Erlang (via Elixir), ou vai acabar replicando boa parte do que o Erlang já tem com OTP.

Isso fica claro quando você olha para os vários sistemas distribuídos baseados em Java/Scala como Hadoop, Spark, Cassandra, e percebe que todos eles teriam se beneficiado da arquitetura OTP do Erlang. Por outro lado, se você acompanha o Cassandra, vai ver que mesmo o Java ainda sofre para competir com C++, basta comparar com o clone chamado [ScyllaDB](http://www.scylladb.com/).

Acredito que Elixir (talvez com HiPE) consegue competir na mesma liga do Java em sistemas distribuídos, evitando que as pessoas abandonem a plataforma Erlang em favor de C ou Java como [aconteceu com o CouchDB](https://www.infoq.com/news/2012/01/Katz-CouchDB-Couchbase-Server) lá em 2012, por falta de interesse e pela sintaxe exótica. E como o Java já tem um ecossistema gigante, Clojure entrou no jogo principalmente porque consegue interfacear diretamente com ele.

Vejo Go também como concorrente do Java, mas para outros casos de uso, particularmente no espaço de ferramentas de sistema onde você tem muito C/C++ e código de cola em Perl e Python. Um exemplo óbvio é a orquestração de Docker. Sim, dá pra fazer microsserviços, crawlers e outras coisas, mas eu não estou tão animado em construir grandes "aplicações" nele, embora nada impeça. De novo, é só opinião pessoal.

Rust é um forte concorrente para desenvolvimento de sistemas de baixo nível. Acho que ele pode substituir C em muitos casos de uso e ser usado para implementar bibliotecas e componentes a serem consumidos por outras linguagens, com o benefício adicional de ser uma linguagem moderna que tenta evitar problemas de segurança como o recente [fiasco do Heartbleed](https://tonyarcieri.com/would-rust-have-prevented-heartbleed-another-look). Mas por causa do "Borrow system" eu acho ele extremamente burocrático, especialmente vindo de linguagens altamente dinâmicas como Ruby, Python ou mesmo Swift ou Elixir. Não estou dizendo que isso seja ruim, é só algo que leva muito mais tempo para ficar confortável do que eu esperava.

Crystal é algo entre Rust e Go. LLVM é algo que você precisa ter no radar, e por causa do [apoio da Apple](http://appleinsider.com/articles/08/06/20/apples_other_open_secret_the_llvm_complier) ao Swift está melhor do que nunca. Crystal é _similar_ ao RubyMotion no sentido de que ambos são parecidos com Ruby mas não totalmente compatíveis, e ambos são front-end parsers para o LLVM. RubyMotion, por outro lado, está mais próximo do Ruby e até consegue usar algumas bibliotecas Ruby quase sem mudanças.

Você tem que tirar o chapéu para o Ary Borenszweig e seus contribuidores. É muito impressionante o quanto eles avançaram em tão pouco tempo, sem ter os bolsos fundos da Mozilla, Apple ou Google.

### Limitações

Crystal toma bastante emprestado do Ruby, mas não é objetivo dele atingir qualquer nível de compatibilidade. Ele é uma linguagem fortemente e estaticamente tipada com Inferência de Tipos. Não tem nenhum componente de runtime como RubyMotion ou Swift, então não tem qualquer noção de introspecção ou reflexão sobre objetos.

Resumindo: você não tem "#eval" nem "#send". A falta de avaliação em runtime acaba não sendo tão grave porque você tem manipulação de AST em tempo de compilação através de um sistema bom o bastante de Macros (mais sobre isso adiante).

Mas a falta de "#send" dói um pouco. É a única coisa que afasta o Crystal da flexibilidade dinâmica dos objetos do Ruby. Mas dá para entender por que isso não é prioridade.

Na versão 0.17.0, Crystal tem uma grande limitação: ele usa um [garbage collector conservador Boehm-Demers-Weiser](http://crystal-lang.org/2013/12/05/garbage-collector.html).

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/asterite">@asterite</a> <a href="https://twitter.com/headius">@headius</a> I assumed as much... the Boehm GC, although handy for starting a new language, will only get you so far</p>&mdash; Jason Frey (@Fryguy9) <a href="https://twitter.com/Fryguy9/status/736990644082757632">May 29, 2016</a></blockquote>

A linguagem está atualmente implementada como um processo single-threaded. Isso significa que você _provavelmente_ não consegue usar 100% de todas as CPUs da sua máquina com um único processo. Posso estar enganado aqui, é só a minha primeira impressão.

Charles Nutter (do JRuby) faz um alerta sobre isso:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/Fryguy9">@fryguy9</a> From their site: <a href="https://t.co/uOjIT0c8ji">https://t.co/uOjIT0c8ji</a> It does say something about "when" parallelism happens. Risky to start single-threaded.</p>&mdash; Charles Nutter (@headius) <a href="https://twitter.com/headius/status/736982955239870464">May 29, 2016</a></blockquote>

É uma faca de dois gumes. Usar um GC "genérico" plug-and-play como o Boehm - o que em si não é ruim, mas talvez não seja nem de longe tão poderoso quanto o conjunto de GCs de alta performance da própria JVM, como o novíssimo G1GC.

Fazer com que a linguagem seja single-threaded por padrão também significa que toda a biblioteca padrão e todo o ecossistema foi construído assumindo que não há paralelismo. Então não há race-conditions e, consequentemente, nenhum uso de sincronização adequada em lugar nenhum. Se um dia eles decidirem adicionar multi-threading, todo o código existente vai estar inseguro para threads. Provavelmente é isso que o Charles está alertando.

Também acho que não é um problema urgente. Você provavelmente não vai construir um sistema altamente paralelo com Crystal, mas talvez esse não seja o caso de uso. Para isso, você deveria estar usando Elixir + OTP, Scala + Akka, por exemplo.

### Concorrência

Não ter acesso a Threads nativas não significa que você fica sem Concorrência. [Concorrência não é Paralelismo](https://blog.golang.org/concurrency-is-not-parallelism). Desde a [versão 0.7.0](http://crystal-lang.org/2015/04/30/crystal-0.7.0-released.html) eles adicionaram suporte para I/O não-bloqueante e também Fibers e Channels.

Em poucas palavras, uma Fiber é um tipo especial de corotina. É um "pedaço de execução" que pode "pausar" a si mesmo e devolver o controle de execução para quem o chamou. Ele pode pausar a si mesmo, mas não pode ser pausado por fora como o Scheduler do Erlang consegue pausar seus processos em execução, por exemplo.

Nesse caso temos uma espécie de "Fiber Scheduler" que consegue "retomar" outras Fibers. Ele é, claro, atualmente single-threaded. E funciona como um Event Loop. Sempre que você tem uma operação de I/O não-bloqueante esperando leitura de arquivo, envio de pacote de rede, esse tipo de coisa, ele consegue devolver o controle para outras fibers retomarem o trabalho.

Isso faz com que ele funcione mais ou menos como o Node.js. Javascript também é uma linguagem single-threaded e o Node.js é basicamente uma implementação de event loop. Funções declaram outras funções anônimas como callbacks e tudo funciona com base em triggers de I/O para chamar de volta essas funções a cada tick do reactor.

Em cima disso você pode adicionar ["Channels"](https://github.com/crystal-lang/crystal/issues/1967) como popularizados pela linguagem Go do Google. Você pode iniciar quantos channels quiser. Aí você pode dar spawn em Fibers no Scheduler. As Fibers podem executar e ficar enviando mensagens pelos Channels. O controle de execução é cedido para quem estiver esperando receber dos mesmos Channels. Quando uma delas recebe e executa, o controle volta para o Scheduler, permitindo que outras Fibers executem, e assim ficam "pingando" e "pongando".

Falando em ping-pong, tem [este snippet no site "Go by Example"](https://gobyexample.com/channel-directions):

```go
package main
import "fmt"
func ping(pings chan<- string, msg string) {
    pings <- msg
}
func pong(pings <-chan string, pongs chan<- string) {
    msg := <-pings
    pongs <- msg
}
func main() {
    pings := make(chan string, 1)
    pongs := make(chan string, 1)
    ping(pings, "passed message")
    pong(pings, pongs)
    fmt.Println(<-pongs)
}
```

E isso é basicamente a mesma coisa, mas implementada em Crystal:

```ruby
def ping(pings, message)
  pings.send message
end

def pong(pings, pongs)
  message = pings.receive
  pongs.send message
end

pings = Channel(String).new
pongs = Channel(String).new
spawn ping pings, "passed message"
spawn pong pings, pongs
puts pongs.receive
# => "passed message"
```

Mesma coisa, mas mais agradável aos meus olhos, opinião pessoal de novo - o que é esperado se você também é um Rubyista.

Então, Crystal tem um Event Loop estilo Node.js/Javascript na forma de um Fiber Scheduler e um mecanismo de Channel/CSP estilo Go para coordenar processamento concorrente. É um mecanismo de "multitarefa cooperativa". Não é bom para processamento intensivo de CPU, como cálculos pesados ou processamento massivo de dados. Funciona melhor para processamento intensivo de I/O.

Se você tem uma Fiber fazendo processamento super pesado, ela vai bloquear o Scheduler, igual acontece no Node.js. A implementação atual do Scheduler está atrelada a uma única thread nativa, então por enquanto ela não consegue usar outras threads nativas disponíveis no sistema.

Como a implementação dos Channels é bem nova, ela ainda não é usada por toda a biblioteca padrão. Mas a implementação padrão do `HTTP::Server` usa Fibers. E como ele é compilado para um binário nativo, é **muito mais rápido** que Javascript, como mostra este ["fast-http-server"](https://github.com/sdogruyol/fast-http-server):

* fast-http-server (Crystal)  18348.47rpm a 8.67ms de tempo médio de resposta
* http-server (Node.js)   2105.55rpm a 47.92ms de tempo médio de resposta
* SimpleHTTPServer (Python)   785.14rpm a 1.91ms de tempo médio de resposta

Estamos falando de uma ordem de magnitude de 8 vezes mais rápido que Node.js e mais de 20 vezes mais rápido que Python.

Como sempre, você não deve confiar cegamente em [benchmarks sintéticos](https://github.com/kostya/benchmarks), mas dependendo do tipo de processamento que você decida comparar, você verá Crystal bem no mesmo patamar de Rust, Go, Swift, D.

### Inferência de Tipos

Crystal é uma linguagem estaticamente tipada. Mas ela não vai exigir que você declare cada tipo de antemão. Ela é bem inteligente na Inferência de Tipos, então se você só digitar:

```ruby
a = 1
b = "HELO"
```

Ela vai saber que "a" é um "Int32" e que "b" é uma "String". A propósito, ao contrário do Ruby, todas as Strings precisam usar aspas duplas. Mas a coisa fica particularmente mais complicada quando você está lidando com estruturas de dados complexas como JSON.

Em Ruby eu posso simplesmente parsear uma String JSON e imediatamente explorar sua estrutura assim:

```ruby
parsed_json = JSON.parse(response.body)["files"].first["id"]
```

Não dá para fazer isso em Crystal, ao invés a [abordagem recomendada](http://crystal-lang.org/api/JSON.html#mapping%28properties%2Cstrict%3Dfalse%29-macro) é declarar uma estrutura tipo schema assim:

```ruby
class FilesResponse
  JSON.mapping({
    ok: {type: Bool},
    files: {type: Array(FilesItemResponse)}
  })
end
class FilesItemResponse
  JSON.mapping({
    id: {type: String},
    name: {type: String},
    filetype: {type: String},
    created: {type: Time, converter: Time::EpochConverter}
    timestamp: {type: Time, converter: Time::EpochConverter}
    permalink: {type: String}
  })
end
...
# parsed_json = JSON.parse(response.body)["files"].first["id"]
parsed_json = FilesResponse.from_json(@body).files.first.id
```

Eu sou muito acostumado com o duck typing do Ruby e a habilidade de consultar objetos em runtime. Em Crystal a coisa é diferente, e pode ficar bem cansativo mudar seu mindset para pensar em tipos de antemão. O compilador vai gritar muito durante seu ciclo de desenvolvimento até você se acostumar com esse conceito.

Fiz um experimento com parsing de JSON e o resultado é um projeto que chamei de ["cr_slack_cleanup"](https://github.com/akitaonrails/cr_slack_cleanup), que mostra tanto essa ideia de Schemas JSON quanto Fibers e Channels como expliquei na seção anterior.

Update: depois que postei este artigo o @LuisLavena entrou em campo para me corrigir: dá para fazer como em Ruby, sem schemas:

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr"><a href="https://twitter.com/AkitaOnRails">@AkitaOnRails</a> <a href="https://twitter.com/CrystalLanguage">@CrystalLanguage</a> re: JSON, you can parse it kinda-like Ruby, see JSON::Any: <a href="https://t.co/MD7PYy5AVH">https://t.co/MD7PYy5AVH</a></p>&mdash; Luis Lavena (@luislavena) <a href="https://twitter.com/luislavena/status/738005493189316608">June 1, 2016</a></blockquote>

E fica assim:

```ruby
require "json"

data = <<-JSON
  {
    "files": [
        {
          "id": 1,
          "name": "photo.jpg"
        },
        {
          "id": 99,
          "name": "another.jpg"
        }
    ]
  }
  JSON

obj = JSON.parse(data)

obj["files"].each do |item|
  puts item["id"].as_i
end
```

Então, parsing de JSON pode ser quase idêntico ao que você faria em Ruby, embora ele também recomende Schemas porque acaba sendo um pouco mais rápido.

### Macros

A última feature importante que vale mencionar é a presença de Macros. Como você não tem controle do seu código em runtime, não tem "eval", não tem "send", então você ficaria sem como fazer metaprogramação de verdade.

Macros trazem de volta um pouco da metaprogramação do Ruby. Por exemplo, em Ruby, quando você inclui um Module em uma Class, existe o hook "included?" no Module onde você pode adicionar metaprogramação como coisas com "class_eval".

Em Crystal, um Module também tem o hook "included" mas agora é uma Macro. Você pode fazer algo assim:

```ruby
module Foo
  macro included
    {% if @type.name == "Bar" %}
    def self.hello
      puts "Bar"
    end
    {% else %}
    def self.hello
      puts "HELLO"
    end
    {% end %}
  end
end

module Bar
  include Foo
end

module Something
  include Foo
end

Bar.hello # => "Bar"
Something.hello # => "HELLO"
```

É como ter templates "ERB" para código. Uma macro é código construindo código em tempo de compilação. Na AST resultante é como se você tivesse escrito o código repetitivo e chato na mão. O binário nativo compilado não se importa. Se você vem do C, é como pré-processamento, mas com controle sobre uma árvore AST de Nodes ao invés de só manipular código-fonte. Você até consegue fazer algo parecido com o venerado "#method_missing".

```ruby
class Foo
  macro method_missing(name, args, block)
    {{pp name}}
  end
end

Foo.new.hello_world
# => name = "hello_world"
Foo.new.bla_bla("bla")
# => name = "bla_bla"
```

Qualquer macro pode receber uma AST como argumento e você pode manipular essa AST como bem entender. Por exemplo:

```
module Foo
  macro teste(ast)
    puts {{ast.stringify}}
  end
end

Foo.teste "Hello World".split(" ").join(" - ")
# => ("Hello World".split(" ")).join(" - ")
```

Nesse exemplo você só pega uma versão normalizada do código que passou como argumento. E o código não vai ser "executado" naquela posição.

Então, você pode definir novos métodos e chamar versões diferentes de métodos dependendo da combinação de elementos que você pega da AST. Um exemplo do que é possível é este experimento do desenvolvedor Oleksii que empacotei neste pequeno projeto que chamei de ["cr_chainable_methods"](https://github.com/akitaonrails/cr_chainable_methods), e a gente consegue construir código bem diferente tanto de Crystal quanto de Ruby:

```ruby
result = pipe "Hello World"
  .>> Foo.split_words
  .>> Foo.append_message("Bar")
  .>> Bar.add_something
  .>> Foo.join
  .>> unwrap
```

(Sim, um subconjunto do que um Pipe de verdade do Elixir faz.)

### Crystal Shards

Por fim, um aspecto que eu gosto no Crystal é que ele já tem gerenciamento de tarefas e gerenciamento de dependências resolvidos. Sem discussões sem fim sobre qual implementação de pacotes e dependências a gente "deveria" usar.

Você pode simplesmente escrever um script simples num arquivo como "test.cr" e rodar esse arquivo assim:

```
crystal test.cr
```

Ou você pode buildar e compilar para um binário nativo antes de executar:

```
crystal build test.cr --release
./test
```

E também dá para começar com uma estrutura de projeto adequada e ciclo de desenvolvimento assim:

```
crystal init app test
cd test
crystal build src/test.cr --release
./test
git add .
git commit -m "initial commit"
git push -u origin master
```

Ele monta uma estrutura de diretórios de projeto adequada, um repositório Git já vem pré-inicializado para você (por que diabos você programaria sem Git!?) com um arquivo ".gitignore" decente.

Você também vai encontrar um arquivo "shard.yml" onde você declara o nome da sua aplicação ou biblioteca, versão, autor, e também as suas dependências assim:

```yaml
name: kemal
version: 0.12.0

dependencies:
  radix:
    github: luislavena/radix
    version: 0.3.0
  kilt:
    github: jeromegn/kilt
    version: 0.3.3
author:
  - Serdar Dogruyol <dogruyolserdar@gmail.com>
```

Esse exemplo é do [framework web Kemal](https://github.com/sdogruyol/kemal) do Serdar. Ele depende das bibliotecas Radix e Kilt. Você precisa rodar `crystal deps` e ele vai buscar do Github antes de você poder compilar.

E mais: todo projeto vem com um diretório "spec" adequado onde você pode escrever testes no estilo Rspec e rodá-los usando `crystal spec`. E o resultado do runner de specs vai ser parecido com isso:

```
$ crystal spec
........................................................

Finished in 8.28 milliseconds
56 examples, 0 failures, 0 errors, 0 pending
```

Tudo embutido, sem precisar de bibliotecas externas.

E 8 milissegundos para rodar a suíte de testes inteira de um micro framework web? Nada mau. Se você somar o tempo de inicialização do executável, ainda dá em torno de 1 segundo de tempo total de execução. Bem impressionante.

### Conclusão

Crystal não tem como objetivo ser um substituto do Ruby como o JRuby. Então ele nunca vai rodar projetos Ruby existentes e complicados como Ruby on Rails ou mesmo Sinatra.

Para mim, Crystal preenche uma lacuna em alguns casos de uso onde eu usaria Rust ou Go. Ele tem o desempenho bruto de um binário nativo otimizado por LLVM, um sistema de concorrência razoavelmente rápido no estilo Go (e muito mais rápido e menos intensivo em recursos que Node.js), com o benefício adicional de uma sintaxe muito mais agradável estilo Ruby.

Você pode até começar a experimentar Crystal para construir extensões nativas Ruby sem precisar de FFI e sem ter que escrever C. Existe uma tentativa de [port do ActiveSupport](https://github.com/startram/activesupport.cr) como uma extensão nativa para o MRI Ruby, escrita como prova de conceito em Crystal.

Se você é Rubyista vai se sentir bastante em casa com a maior parte da biblioteca padrão. Vai sentir falta de uma coisa ou outra, mas na maior parte do tempo vai parecer Ruby. O [Guia oficial](http://crystal-lang.org/docs) é bom o suficiente para começar e tem uma [documentação de API](http://crystal-lang.org/api) abrangente, suficiente para checar se aquela API favorita do Ruby está lá ou não, e se não estiver, quais são os substitutos. Na maioria das vezes você vai pensar _"hmm, em Ruby eu usaria Enumerator#each ... e sim, com certeza, tem Enumerator#each como esperado."_ A documentação da API está precisando de mais carinho, então se você quer contribuir, esse é um bom lugar para começar.

Se você quer dar uma olhada em uma lista curada de bibliotecas e aplicações Crystal, vá direto no ["Awesome Crystal"](http://awesome-crystal.com/). Você também pode ver os mais dinâmicos ["Trending Projects in Github"](https://github.com/trending/crystal).

Na maior parte, sua proficiência em Ruby vai compensar para construir sistemas pequenos onde performance bruta e concorrência sejam mesmo necessárias. Esse é exatamente o caso de uso para o port do [Sidekiq.cr](https://github.com/mperham/sidekiq.cr) do Mike Perham. Imagine que você tem gigabytes de arquivos para processar. Ou você tem milhares de sites externos para crawlear, parsear e organizar. Ou você tem petabytes de dados no seu banco esperando para serem processados. Essas são tarefas em que MRI Ruby não vai te ajudar, mas Crystal pode muito bem ser a resposta rápida.

Você até pode pegar um dos vários micro frameworks web como o Kemal e fazer deploy dos seus provedores de API HTTP [direto no Heroku](http://crystal-lang.org/2016/05/26/heroku-buildpack.html) agora. Isso te dá níveis de performance estilo Go, e isso é **muito** atraente para mim, pois também detesto a sintaxe arcaica do Go.

Então, Rust, Go, Javascript, todas muito rápidas, mas com sintaxes bem questionáveis e nem tão agradáveis. Elas são bem mais maduras, e seus ecossistemas são muito maiores. Mas, a menos que eu realmente precise, prefiro escolher Crystal para os casos de uso que descrevi acima, e acho que você também vai encontrar bons usos para ele.

Update: depois que postei, o criador do Crystal, @Asterite, teve algumas coisas a acrescentar também:

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr"><a href="https://twitter.com/AkitaOnRails">@AkitaOnRails</a> <a href="https://twitter.com/waj">@waj</a> so it&#39;s likely that we&#39;ll have something similar. We aren&#39;t there yet because we are not Google, Mozilla nor Apple</p>&mdash; Ary Borenszweig (@asterite) <a href="https://twitter.com/asterite/status/737778080085868545">May 31, 2016</a></blockquote>

<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
