---
title: "[Manga-Downloadr] Portando de Crystal para Ruby (e um pouco de JRuby)"
date: '2016-06-06T18:06:00-03:00'
slug: manga-downloadr-portando-de-crystal-para-ruby-e-um-pouco-de-jruby
translationKey: manga-downloadr-crystal-to-ruby
aliases:
- /2016/06/06/manga-downloadr-porting-from-crystal-to-ruby-and-a-bit-of-jruby/
tags:
- manga-downloadr
- crystal
- jruby
- traduzido
draft: false
---

Eu tenho um projetinho pessoal antigo chamado [Manga Downloadr](http://www.akitaonrails.com/2014/12/17/small-bites-downloader-para-mangareader-kindle-edition) que publiquei em 2014. Era uma versão bem tosca. Eu estava experimentando com requisições assíncronas usando Typhoeus e no final o código acabou ficando uma bagunça absurda.

A natureza do Manga Downloader original é a de um web crawler: ele baixa páginas HTML, faz parse para encontrar coleções de links e segue baixando até que um conjunto de imagens seja salvo. Depois eu organizo tudo em volumes, otimizo para caber na resolução de tela do Kindle e compilo em arquivos PDF. Isso faz desse projeto um exercício interessante para tentar fazer requisições HTTP concorrentes e processar os resultados.

Um ano depois eu estava aprendendo Elixir. O Manga Downloadr era um bom candidato para eu descobrir como implementar a mesma coisa em outra linguagem. Você pode acompanhar o meu processo de aprendizado [nessa série de posts](http://www.akitaonrails.com/exmangadownloadr).

Finalmente, venho aprendendo mais sobre Crystal, uma plataforma inspirada em Ruby que compila código fonte parecido com Ruby em binários nativos otimizados via LLVM. E de bônus oferece canais e fibras no estilo CSP, parecido com Go, para permitir código concorrente.

Então adaptei minha versão Elixir para Crystal e o resultado é esse código que você encontra no Github como [akitaonrails/cr_manga_downloadr](https://github.com/akitaonrails/cr_manga_downloadr).

Funciona muito bem e roda bem rápido, limitado principalmente por quantas requisições o MangaReader consegue responder concorrentemente e pela velocidade/confiabilidade da conexão de Internet. E como minha versão Ruby original era um código terrível, era uma boa hora para reescrevê-la. E como Crystal é surpreendentemente próximo de Ruby, decidi portar.

> A portagem foi quase trivial demais

Foi praticamente copiar e colar o código Crystal sem as anotações de tipo. E tive que substituir a implementação leve de Fibers e Channel para concorrência pelas tradicionais Threads de Ruby.

A nova versão 2.0 da ferramenta em Ruby pode ser encontrada nesse repositório no Github: [akitaonrails/manga-downloadr](https://github.com/akitaonrails/manga-downloadr).

### Ruby, Ruby por todo lado!

Transitar entre Ruby e Crystal não é tão difícil. O time do Crystal fez um trabalho fantástico implementando uma Standard Library (stdlib) muito sólida, que se assemelha bastante à do MRI Ruby.

Por exemplo, vamos comparar primeiro um trecho da minha versão Crystal:

```ruby
def fetch(page_link : String)
  get page_link do |html|
    images = html.xpath("//img[contains(@id, 'img')]").as(XML::NodeSet)
    image_alt = images[0]["alt"]
    image_src = images[0]["src"]
    if image_alt && image_src
      extension      = image_src.split(".").last
      list           = image_alt.split(" ").reverse
      title_name     = list[4..-1].join(" ")
      chapter_number = list[3].rjust(5, '0')
      page_number    = list[0].rjust(5, '0')
      uri = URI.parse(image_src)
      CrMangaDownloadr::Image.new(uri.host as String, uri.path as String, "#{title_name}-Chap-#{chapter_number}-Pg-#{page_number}.#{extension}")
    else
      raise Exception.new("Couldn't find proper metadata alt in the image tag")
    end
  end
end
```

Agora vamos olhar a versão portada para Ruby:

```ruby
def fetch(page_link)
  get page_link do |html|
    images = html.css('#img')

    image_alt = images[0]["alt"]
    image_src = images[0]["src"]

    if image_alt && image_src
      extension      = image_src.split(".").last
      list           = image_alt.split(" ").reverse
      title_name     = list[4..-1].join(" ")
      chapter_number = list[3].rjust(5, '0')
      page_number    = list[0].rjust(5, '0')

      uri = URI.parse(image_src)
      Image.new(uri.host, uri.path, "#{title_name}-Chap-#{chapter_number}-Pg-#{page_number}.#{extension}")
    else
      raise Exception.new("Couldn't find proper metadata alt in the image tag")
    end
  end
end
```

É impressionante como são parecidos, até mesmo nas chamadas de stdlib como `URI.parse` ou métodos de Array como `split`.

> Quando você remove as anotações de tipo da versão Crystal, é 99% Ruby.

Ruby pouco se importa se você está chamando um método em um objeto Nil - em tempo de compilação. Crystal faz checagens em tempo de compilação e, se ele acha que a chamada de método pode acontecer sobre Nil, simplesmente não compila. Isso é uma grande vitória para evitar bugs sutis.

Em Rails estamos acostumados com o famigerado método `#try`. O Ruby 2.3 introduziu o [safe navigation operator](http://mitrev.net/ruby/2015/11/13/the-operator-in-ruby/).

Então, em Ruby 2.3 com Rails, ambas as linhas a seguir são válidas:

```ruby
obj.try(:something).try(:something2)
obj&.something&.something2
```

Em Crystal podemos fazer assim:

```ruby
obj.try(&.something).try(&.something2)
```

Então, é parecido. Use com cuidado.

Como mencionei antes, Crystal é próximo de Ruby, mas a intenção dele é ser uma linguagem própria, então não dá para simplesmente carregar Rubygems sem portar. Nesse exemplo eu não tenho Nokogiri para fazer parse de HTML. E é justamente aí que a stdlib brilha: Crystal vem com parsers de XML/HTML e JSON suficientemente bons. Então podemos fazer parse do HTML como XML e usar XPath puro.

No lugar do `Net::HTTP` do Ruby temos `HTTP::Client` (mas seus métodos e semântica são surpreendentemente similares).

Existem outras diferenças, por exemplo, esse é o arquivo principal que faz `require` de todos os outros em Ruby:

```ruby
...
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")

require "manga-downloadr/records.rb"
require "manga-downloadr/downloadr_client.rb"
require "manga-downloadr/concurrency.rb"
require "manga-downloadr/chapters.rb"
require "manga-downloadr/pages.rb"
require "manga-downloadr/page_image.rb"
require "manga-downloadr/image_downloader.rb"
require "manga-downloadr/workflow.rb"
```

E essa é a versão Crystal do mesmo manifesto:

```ruby
require "./cr_manga_downloadr/*"
...
```

Por outro lado, precisamos ser um pouco mais explícitos em cada arquivo de código fonte Crystal e declarar as dependências específicas onde forem necessárias. Por exemplo, no arquivo `pages.cr` ele começa assim:

```ruby
require "./downloadr_client"
require "xml"

module CrMangaDownloadr
  class Pages < DownloadrClient(Array(String))
  ...
```

Crystal tem menos espaço para "mágica", mas ainda assim consegue manter um alto nível de abstração.

### Uma palavra sobre Tipos

> Podemos passar a próxima década masturbando sobre tudo que existe sobre Tipos, e vai ser extremamente chato.

A única coisa que você precisa entender: o compilador precisa conhecer a assinatura dos métodos das classes antes de poder usá-las. Não existe um componente em Runtime que possa introspectar objetos em tempo real, como em Ruby e em outras linguagens dinâmicas (até Objective-C/Swift consegue fazer mais coisa dinâmica do que Crystal).

Na maior parte do tempo o compilador do Crystal é inteligente o bastante para inferir os tipos para você, então você não precisa ser absolutamente explícito. Você deve seguir o que o compilador indica para saber quando usar Type Annotations.

O que pode te assustar de início é a necessidade de Type Annotations, entender Generics e por aí vai. O compilador vai cuspir cada dump de erro assustador, e você vai precisar se acostumar. A maioria dos erros assustadores costuma ser ou uma Type Annotation faltando, ou você tentando chamar um método em um possível objeto Nil.

Por exemplo, se eu mudar a linha a seguir no arquivo de teste `page_image_spec.cr`:

```ruby
# linha 8:
image = CrMangaDownloadr::PageImage.new("www.mangareader.net").fetch("/naruto/662/2")

# linha 10:
# image.try(&.host).should eq("i8.mangareader.net")
image.host.should eq("i8.mangareader.net")
```

A linha comentada reconhece que a instância `image` pode vir como Nil, então adicionamos uma chamada explícita de `#try` no spec.

Se tentarmos compilar sem esse reconhecimento, esse é o erro que o compilador vai despejar em você:

```
$ crystal spec                                                        [
Error in ./spec/cr_manga_downloadr/page_image_spec.cr:10: undefined method 'host' for Nil (compile-time type is CrMangaDownloadr::Image?)

    image.host.should eq("i8.mangareader.net")
          ^~~~

=============================================================================

Nil trace:

  ./spec/cr_manga_downloadr/page_image_spec.cr:8

        image = CrMangaDownloadr::PageImage.new("www.mangareader.net").fetch("/naruto/662/2")
...
```

Tem um stacktrace gigante depois desse trecho, mas você só precisa prestar atenção nas primeiras linhas, que já dizem o que está errado: "undefined method 'host' for Nil (compile-time type is CrMangaDownloadr::Image?)". Se você sabe ler, na maior parte do tempo não vai ter problema nenhum.

Agora, `Chapters`, `Pages`, `PageImage` (todos subclasses de `DownloadrClient`) são basicamente a mesma coisa: fazem requisições com `HTTP::Client`.

É assim que a classe `Pages` é implementada:

```ruby
...
module CrMangaDownloadr
  class Pages < DownloadrClient(Array(String))
    def fetch(chapter_link : String)
      get chapter_link do |html|
        nodes = html.xpath_nodes("//div[@id='selectpage']//select[@id='pageMenu']//option")
        nodes.map { |node| [chapter_link, node.text as String].join("/") }
      end
    end
  end
end
```

`#get` é um método da superclasse `DownloadrClient` que recebe uma String `chapter_link` e um bloco. O bloco recebe uma coleção de nós `html` já parseada e podemos brincar com ela, retornando um Array de Strings.

É por isso que temos o `(Array(String))` ao herdar de `DownloadrClient`. Vejamos como a superclasse `DownloadrClient` é implementada.

```ruby
module CrMangaDownloadr
  class DownloadrClient(T)
    ...
    def get(uri : String, &block : XML::Node -> T)
      response = @http_client.get(uri)
      case response.status_code
      when 301
        get response.headers["Location"], &block
      when 200
        parsed = XML.parse_html(response.body)
        block.call(parsed)
      end
      ...
    end
  end
end
```

Você pode ver que essa classe recebe um Generic Type e usa ele como o tipo de retorno do bloco yieldado no método `#get`. O `XML::Node -> T` é a declaração da assinatura do bloco, enviando `XML::Node` e recebendo aquilo que `T` for. Em tempo de compilação, imagine esse `T` sendo substituído por `Array(String)`. É assim que dá para criar classes capazes de lidar com qualquer número de Tipos diferentes sem precisar fazer overload para polimorfismo.

Se você vem de Java, C#, Go ou qualquer outra linguagem moderna estaticamente tipada, provavelmente já sabe o que é um Generic.

Você pode ir bem longe com Generics, veja como começa o nosso `Concurrency.cr`:

```ruby
class Concurrency(A, B, C)
  ...
  def fetch(collection : Array(A)?, &block : A, C? -> Array(B)?) : Array(B)?
    results = [] of B
    collection.try &.each_slice(@config.download_batch_size) do |batch|
      engine  = if @turn_on_engine
                  C.new(@config.domain)
                end
      channel = Channel(Array(B)?).new
      batch.each do |item|
      ...
```

E é assim que usamos no `workflow.cr`:

```ruby
private def fetch_pages(chapters : Array(String)?)
  puts "Fetching pages from all chapters ..."
  reactor = Concurrency(String, String, Pages).new(@config)
  reactor.fetch(chapters) do |link, engine|
    engine.try( &.fetch(link) )
  end
end
```

Nesse exemplo, imagine `A` sendo substituído por `String`, `B` também sendo substituído por `String` e `C` sendo substituído por `Pages` na classe `Concurrency`.

Essa é a "primeira-versão-que-funcionou", então provavelmente está pouco idiomática. Talvez dê para resolver com menos exercício de Generics ou, quem sabe, eu pudesse simplificar com o uso de Macros. Mas está funcionando bem assim.

A versão pura em Ruby acaba ficando assim:

```ruby
class Concurrency
  def initialize(engine_klass = nil, config = Config.new, turn_on_engine = true)
    ...
  end
  def fetch(collection, &block)
    results = []
    collection&.each_slice(@config.download_batch_size) do |batch|
      mutex   = Mutex.new
      threads = batch.map do |item|
      ...
```

Essa versão é muito "mais simples" em termos de densidade de código fonte. Em compensação, teríamos que testar essa versão Ruby muito mais, porque ela tem várias permutações diferentes (a gente até injeta classes via `engine_klass`) e precisamos garantir que tudo responda corretamente. Na prática, deveríamos adicionar testes para todas as combinações dos argumentos do inicializador.

Na versão Crystal, como todos os tipos foram checados em tempo de compilação, foi mais exigente em termos de anotações; mas podemos ter bastante certeza de que se compilou, vai rodar como esperado.

> Não estou dizendo que Crystal dispensa specs.

Compiladores só vão até certo ponto. Mas até onde é "certo ponto"? Sempre que você é "forçado" a adicionar Type Annotations, eu afirmo que essas partes ou estão tentando ser espertas demais, ou são intrinsecamente complexas. Essas são as partes que exigiriam camadas extras de testes em Ruby e, se conseguirmos adicionar as anotações direito, podemos ter menos testes (não precisamos cobrir a maior parte das permutações) na versão Crystal (uma complexidade exponencial de permutações poderia cair para uma complexidade linear, eu acho).

### Uma palavra sobre Threads em Ruby

Os principais conceitos que você precisa entender sobre concorrência em Ruby são esses:

* MRI Ruby tem um GIL, um Global Interpreter Lock, que proíbe código de rodar concorrentemente.
* MRI Ruby tem acesso e expõe Threads nativas desde a versão 1.9. Mas mesmo se você disparar várias Threads, elas vão rodar sequencialmente, porque só uma thread pode segurar o Lock por vez.
* Operações de I/O são a exceção: elas liberam o Lock para que outras threads rodem enquanto a operação está esperando completar. O SO sinaliza o programa via poll de nível de sistema.

Isso significa que se sua aplicação é **I/O intensiva** (requisições HTTP, leituras ou escritas em arquivos, operações de socket etc), você terá _alguma_ concorrência. Um servidor web, como Puma por exemplo, pode tirar algum proveito de Threads, porque uma boa parte das operações envolve receber requisições HTTP e mandar respostas HTTP pela rede, o que deixa o processo Ruby ocioso enquanto espera.

Se sua aplicação é CPU intensiva (algoritmos pesados, processamento de dados, coisas que realmente esquentam o CPU), aí Threads nativas não ajudam, só uma roda por vez. Se você tem múltiplos cores no seu CPU, pode dar Fork no seu processo para o número de cores disponíveis.

Dê uma olhada em [grosser/parallel](https://github.com/grosser/parallel) para facilitar.

É por isso que Puma também tem um modo "worker". "Worker" é o nome que normalmente damos para processos filhos forkados.

No caso desse processo de download, ele vai fazer milhares de requisições HTTP para raspar os metadados necessários das páginas do MangaReader. Então é muito mais I/O intensivo do que CPU intensivo (as partes CPU intensivas são o parsing do HTML e, mais tarde, o redimensionamento das imagens e a compilação do PDF).

Uma versão sequencial do que precisa ser feito, em Ruby, fica assim:

```ruby
def fetch_sequential(collection, &block)
  results = []
  engine  = @turn_on_engine ? @engine_klass.new(@config.domain) : nil
  collection&.each_slice(@config.download_batch_size) do |batch|
    batch.each do |item|
      batch_results = block.call(item, engine)&.flatten
      results += ( batch_results || [])
    end
  end
  results
end
```

Se temos 10.000 links na `collection`, primeiro fatiamos no tamanho que `@config.download_batch_size` define e iteramos sobre essas fatias menores, chamando algum bloco e acumulando os resultados. Esse é um algoritmo ingênuo, como você vai descobrir na próxima seção, mas vamos seguir.

Em Elixir você pode disparar micro-processos para fazer as requisições HTTP em paralelo. Em Crystal você pode disparar Fibers e esperar as requisições HTTP completarem e sinalizar os resultados via Channels.

Os dois são leves e você pode ter centenas ou até milhares rodando em paralelo. O Manga Reader provavelmente vai reclamar se você mandar tudo isso de uma vez, então o limite não está no código, e sim no serviço externo.

Para transformar a versão sequencial em uma concorrente, é isso que podemos fazer em Crystal:

```ruby
def fetch(collection : Array(A)?, &block : A, C? -> Array(B)?) : Array(B)?
  results = [] of B
  collection.try &.each_slice(@config.download_batch_size) do |batch|
    channel = Channel(Array(B)?).new
    batch.each do |item|
      spawn {
        engine  = if @turn_on_engine
                    C.new(@config.domain)
                  end
        reply = block.call(item, engine)
        channel.send(reply)
        engine.try &.close
      }
    end
    batch.size.times do
      reply = channel.receive
      if reply
        results.concat(reply.flatten)
      end
    end
    channel.close
    puts "Processed so far: #{results.try &.size}"
  end
  results
end
```

Pegar uma coleção enorme e fatiar em 'batches' menores é fácil. Agora temos uma coleção `batch` menor. Para cada item (geralmente uma URI) damos `spawn` em uma Fiber e chamamos um bloco que vai requisitar e processar os resultados. Quando termina o processamento, envia os resultados por um `channel`.

Quando terminamos de iterar sobre o batch e disparar todas essas Fibers, podemos "esperar" por elas chamando `channel.receive`, que vai começar a receber os resultados conforme as Fibers vão terminando de requisitar/processar cada URI.

Acumulamos os resultados e seguimos para o próximo batch da coleção até terminar. A quantidade de concorrência é determinada pelo tamanho do batch (é parecido com [o que fiz com 'poolboy' em Elixir](http://www.akitaonrails.com/en/2015/11/19/ex-manga-downloadr-parte-2-poolboy-ao-resgate/) onde iniciamos um número fixo de processos rodando em paralelo para evitar fazer um Denial of Service no Manga Reader).

A propósito, essa implementação em Crystal é parecida com o que você faria em Go usando Channels.

Na versão Ruby você pode disparar Threads nativas - que têm bastante overhead para spawnar! - e assumir que as requisições HTTP vão rodar quase todas em paralelo. Como é I/O intensivo, dá para ter todas em paralelo. Fica assim:

```ruby
def fetch(collection, &block)
  results = []
  collection&.each_slice(@config.download_batch_size) do |batch|
    mutex   = Mutex.new
    threads = batch.map do |item|
      Thread.new {
        engine  = @turn_on_engine ? @engine_klass.new(@config.domain) : nil
        Thread.current["results"] = block.call(item, engine)&.flatten
        mutex.synchronize do
          results += ( Thread.current["results"] || [] )
        end
      }
    end
    threads.each(&:join)
    puts "Processed so far: #{results&.size}"
  end
  results
end
```

As Threads são todas inicializadas em estado "pausado". Depois de instanciar todas essas Threads, podemos chamar `#join` em cada uma e esperar todas terminarem.

Quando cada Thread termina o mesmo processo de requisição/processamento de URI, os resultados precisam ser acumulados em um armazenamento global, nesse caso um simples array chamado `results`. Mas como existe a chance de duas ou mais threads tentarem atualizar o mesmo array, a gente sincroniza o acesso (não tenho certeza se o acesso a Array em Ruby já é sincronizado, mas acho que não). Para sincronizar o acesso usamos um Mutex, que é um lock fino, garantindo que só 1 thread possa modificar o array global por vez.

Para provar que Ruby suporta operações de I/O concorrentes, adicionei 2 métodos na classe `Concurrent`, o primeiro é só `#fetch` e é a implementação com Threads acima. O segundo se chama `#fetch_sequential` e é a versão sequencial mostrada no início dessa seção. E adicionei o seguinte spec:

```ruby
it "should check that the fetch implementation runs in less time than the sequential version" do
  reactor = MangaDownloadr::Concurrency.new(MangaDownloadr::Pages, config, true)
  collection = ["/onepunch-man/96"] * 10
  WebMock.allow_net_connect!
  begin
    concurrent_measurement = Benchmark.measure {
      results = reactor.fetch(collection) { |link, engine| engine&.fetch(link) }
    }
    sequential_measurement = Benchmark.measure {
      results = reactor.send(:fetch_sequential, collection) { |link, engine| engine&.fetch(link) }
    }
    /\((.*?)\)$/.match(concurrent_measurement.to_s) do |cm|
      /\((.*?)\)/.match(sequential_measurement.to_s) do |sm|
        # esperado que a versao concorrente seja proxima de 10 vezes mais rapida que a sequencial
        expect(sm[1].to_f).to be > ( cm[1].to_f * 9 )
      end
    end
  ensure
    WebMock.disable_net_connect!
  end
end
```

Como ele usa WebMock, eu primeiro desabilito durante esse spec. Crio uma coleção falsa de 10 links reais para o MangaReader. E aí faço benchmark da versão concorrente baseada em Threads e da versão sequencial pura. Como temos 10 links e são todos iguais, dá para assumir que a versão sequencial vai ser quase **10 vezes mais lenta** que a versão baseada em Threads. E é exatamente isso que esse spec compara e prova (o spec falha se a versão concorrente não for pelo menos 9x mais rápida).

Para comparar todas as versões dos Manga Downloadrs, deixei baixar e compilar uma coleção inteira de mangá, nesse caso "One-Punch Man", que tem quase **1.900 páginas/imagens**. Estou medindo só os processos de fetching e scraping, pulando o download das imagens em si, redimensionamento e geração do PDF, porque eles tomam a maior parte do tempo e o redimensionamento e a parte do PDF são feitos pelo `mogrify` e `convert` do ImageMagick.

Esse é o tempo que essa nova versão Ruby leva para baixar e raspar quase 1.900 páginas (usando MRI Ruby 2.3.1):

```
12,42s user 1,33s system 23% cpu 57,675 total
```

Esse é o tempo que a versão Crystal leva:

```
4,03s user 0,40s system 7% cpu 59,207 total
```

Só por diversão tentei rodar a versão Ruby sob JRuby 9.1.1.0. Para rodar com JRuby basta adicionar a linha a seguir no `Gemfile`:

```ruby
ruby "2.3.0", :engine => 'jruby', :engine_version => '9.1.1.0'
```

Bundle install, roda normalmente, e esse é o resultado:

```
47,80s user 1,99s system 108% cpu 45,967 total
```

E esse é o tempo que a versão Elixir leva:

```
11,38s user 1,04s system 85% cpu 14,590 total
```

### Reality Check!

Se você só olhar os tempos acima, pode chegar a conclusões erradas.

Antes de mais nada, é uma **comparação injusta**. A versão Elixir usa um algoritmo bem diferente das versões Ruby e Crystal.

Em Elixir eu subo um pool de processos, mais ou menos 50 deles. Aí disparo 50 requisições HTTP de uma vez. Quando cada processo termina, ele se libera de volta para o pool e eu posso disparar outra requisição HTTP da fila de links. Então é um **fluxo constante** de no máximo 50 requisições HTTP, constantemente.

As versões Crystal e Ruby/JRuby fatiam os 1.900 links em batches de 40 links e aí eu disparo 40 requisições de uma vez. Essa implementação espera todas as 40 terminarem para disparar mais 40. Ou seja, nunca é um fluxo constante, são rajadas de 40 requisições. Cada batch é freado pela requisição mais lenta do batch, sem dar chance para as outras requisições passarem.

É uma diferença de arquitetura. Elixir torna muito mais fácil fazer streams e Crystal, com seu estilo CSP, torna mais fácil fazer rajadas. Uma abordagem melhor seria enfileirar os 1.900 links e usar algo como Sidekiq.cr para ir consumindo um link por vez (spawnando 40 fibers para servir como um "pool", por exemplo).

A versão Elixir tem uma arquitetura mais eficiente, e é por isso que ela leva no máximo 15 segundos para baixar todos os links de imagens, enquanto a versão Crystal leva quase um minuto inteiro para terminar (a soma das requisições mais lentas em cada batch).

Agora, você vai se surpreender ao ver que a versão Crystal é, na verdade, um pouco mais lenta que a versão Ruby! E você não vai ficar tão surpreso ao ver o JRuby mais rápido aos 45 segundos!

Essa é mais uma evidência de que você não deve descartar Ruby (e que deveria experimentar JRuby com mais frequência). Como expliquei antes, ele suporta concorrência em operações de I/O e as aplicações que testei são todas pesadas em I/O.

A diferença provavelmente está na maturidade da biblioteca `Net::HTTP` do Ruby contra a `HTTP::Client` do Crystal. Tentei vários ajustes na versão Crystal, mas não consegui ficar muito mais rápido. Tentei batches maiores, mas por algum motivo a aplicação simplesmente trava, pausa, e nunca libera. Tenho que dar Ctrl-C e tentar de novo até finalmente passar. Se alguém souber o que estou fazendo de errado, não se esqueça de escrever na seção de comentários abaixo.

Parte disso provavelmente é por conta dos servidores instáveis do MangaReader, eles devem ter algum tipo de prevenção contra DoS, throttling de conexões ou algo do tipo.

De qualquer forma, quando passam, como o algoritmo do Ruby e do Crystal são essencialmente o mesmo, eles levam aproximadamente o mesmo tempo para completar. O que falta é eu evoluir esse algoritmo para usar algo como Sidekiq ou implementar um esquema interno de fila/pool de workers.

### Conclusão

O objetivo desse experimento era aprender mais sobre as capacidades do Crystal e o quão fácil seria ir e voltar com Ruby.

Como você pode ver, existem muitas diferenças, mas não é tão difícil. Posso estar deixando algo passar, mas esbarrei em algumas dificuldades quando empurrei `HTTP::Client` + Fibers para o limite, como expliquei acima. Se você sabe o que estou fazendo de errado, me avise.

A diferença entre os algoritmos do Elixir e do Ruby/Crystal mostra mais do que diferenças de performance entre linguagens, mostra também a importância da arquitetura e dos algoritmos na performance geral. Esse teste foi pouco conclusivo, apenas um indício de que minha implementação ingênua de Fibers precisa de mais trabalho, e que a forma natural do Elixir lidar com processos paralelos facilita atingir níveis mais altos de paralelismo.

Isso serve como um aperitivo do que Crystal pode fazer, e também de que Ruby continua no jogo. E também de que Elixir certamente é algo para se acompanhar de perto.
