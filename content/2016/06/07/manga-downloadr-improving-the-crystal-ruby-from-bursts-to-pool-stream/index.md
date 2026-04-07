---
title: "[Manga-Downloadr] Melhorando o Crystal/Ruby de rajadas para fluxo de pool"
date: '2016-06-07T17:13:00-03:00'
slug: manga-downloadr-melhorando-o-crystal-ruby-de-rajadas-para-fluxo-de-pool
translationKey: manga-downloadr-bursts-to-pool
aliases:
- /2016/06/07/manga-downloadr-improving-the-crystal-ruby-from-bursts-to-pool-stream/
tags:
- manga-downloadr
- crystal
- jruby
- traduzido
draft: false
---

Ontem [eu publiquei](http://www.akitaonrails.com/2016/06/06/manga-downloadr-portando-de-crystal-para-ruby-e-um-pouco-de-jruby) como construí uma nova implementação do Manga Reader Downloader em Crystal, portado para Ruby, testado em JRuby e comparado com Elixir. Só pra recapitular, esses foram os resultados pra buscar capítulos, páginas e links de imagens de um mangá de exemplo:

* MRI Ruby 2.3.1: 57 segundos
* JRuby 9.1.1.0: 45 segundos
* Crystal 0.17.0: 59 segundos
* Elixir: 14 segundos

Eu também disse que era uma comparação injusta, já que a versão Elixir usa um algoritmo diferente - e obviamente mais eficiente.

Era a "primeira-versão-que-funcionou", então resolvi ir adiante e melhorar as implementações. Na versão Ruby/JRuby adicionei a gem [thread](https://github.com/meh/ruby-thread) pra ter uma implementação razoável de Thread pool que funciona tanto em Ruby quanto em JRuby. Eu provavelmente deveria ter usado Concurrent-Ruby, mas estava tendo problemas pra fazer o FixedThreadPool funcionar.

Enfim, agora todas as versões vão ter um pool constante de requisições rodando e podemos fazer uma comparação melhor.

Outra coisa que pode ter prejudicado os resultados do Crystal é que ele parece ter uma [implementação defeituosa de DNS resolver](https://github.com/crystal-lang/crystal/issues/2660), então por enquanto eu só adicionei o IP do Manga Reader direto no meu `/etc/hosts` pra evitar exceções de `getaddrinfo: Name or service not known`.

Pra começar, vamos testar a mesma implementação Elixir e, como esperado, o resultado continua o mesmo:

```
11,49s user 0,82s system 77% cpu 15,827 total
```

Agora, o MRI Ruby com o algoritmo de "rajada em lote" estava levando 57 segundos e essa nova implementação usando ThreadPool roda muito melhor:

```
12,67s user 0,92s system 50% cpu 27,149 total
```

Em Crystal é um pouco mais complicado, porque não tem como implementar o equivalente a um "Fiber Pool". O que temos que fazer é um loop infinito até o último processo sinalizar a quebra do loop. Dentro do loop criamos um número máximo de fibers, esperamos cada uma sinalizar que terminou através de um channel individual e voltamos ao loop pra criar uma nova fiber, e por aí vai. Comparado aos 59 segundos de ontem, isso é bem melhor:

```
5,29s user 0,33s system 26% cpu 21,166 total
```

A versão JRuby não está tão rápida. Ainda melhor que os 45 segundos de ontem, mas agora está perdendo até pro MRI:

```
49,24s user 1,41s system 146% cpu 34,602 total
```

Tentei usar a flag `--dev` pra [tempo de inicialização mais rápido](https://github.com/jruby/jruby/wiki/Improving-startup-time) e melhora um pouco, ficando mais perto do MRI:

```
22,26s user 0,99s system 76% cpu 30,320 total
```

Não sei se dá pra melhorar mais, mas qualquer dica é bem-vinda - não esqueçam de comentar abaixo.

Então, Elixir continua pelo menos duas vezes mais rápido que Crystal nesse momento. Mas isso também demonstra como um algoritmo diferente faz uma diferença enorme onde importa. Eu provavelmente consigo ajustar mais um pouco, mas isso já basta por enquanto.

### Mudando a implementação Ruby pra usar ThreadPool

```ruby
require "thread/pool"

module MangaDownloadr
  class Concurrency
    ...
    def fetch(collection, &block)
      pool    = Thread.pool(@config.download_batch_size)
      mutex   = Mutex.new
      results = []

      collection.each do |item|
        pool.process {
          engine  = @turn_on_engine ? @engine_klass.new(@config.domain) : nil
          reply = block.call(item, engine)&.flatten
          mutex.synchronize do
            results += ( reply || [] )
          end
        }
      end
      pool.shutdown

      results
    end
    ...
```

A ideia é que vamos ter um número fixo de threads nativas spawnadas (nesse caso, determinado por `@config.download_batch_size`). Conforme uma thread termina, ela puxa um novo link do Array `collection`, funcionando essencialmente como uma "fila" a ser esvaziada.

Os resultados são acumulados no Array `results`. Como várias threads podem querer modificá-lo ao mesmo tempo, temos que sincronizar o acesso através de um Mutex.

Dessa forma sempre temos uma quantidade fixa de workers fazendo requisições constantemente em vez de fatiar o Array `collection` e fazer rajadas como na versão anterior.

### Mudando a implementação Crystal pra simular um Pool de Fibers

A versão Crystal ficou um pouco mais complicada porque não achei nenhuma biblioteca de pool pra usar. Encontrei uma implementação rústica de pool [neste post do stackoverflow](http://stackoverflow.com/a/30854065/1529907) e consegui implementar uma versão melhorada num shard novo, pra que vocês possam aproveitar nos seus projetos. Confiram o código fonte em [akitaonrails/fiberpool](https://github.com/akitaonrails/fiberpool). Foi assim que adicionei no meu projeto:

```yaml
dependencies:
  ...
  fiberpool:
    github: akitaonrails/fiberpool
```

E foi assim que usei. Repare que a lógica em si é bem próxima da versão MRI Ruby, mas usando um "Fiber Pool" em vez de Thread Pool.

```ruby
require "fiberpool"

module CrMangaDownloadr
  struct Concurrency
    def initialize(@config : Config, @turn_on_engine = true); end

    def fetch(collection : Array(A)?, engine_class : E.class, &block : A, E? -> Array(B)?) : Array(B)
      results = [] of B
      if collection
        pool = Fiberpool.new(collection, @config.download_batch_size)
        pool.run do |item|
          engine = if @turn_on_engine
                     engine_class.new(@config.domain, @config.cache_http)
                   end
          if reply = block.call(item, engine)
            results.concat(reply)
          end
        end
      end
      results
    end
  end
end
```

Mas, de novo, isso é muito intensivo em I/O e tanto a versão Ruby quanto a Crystal aproveitam o fato de poderem fazer mais trabalho enquanto esperam uma requisição HTTP terminar.

<a name="reproducing-tests"> </a>

### Reproduzindo os Testes

Implementei um "Modo de Teste" nas 3 implementações. Vocês podem clonar dos meus repositórios:

* [Versão Crystal](https://github.com/akitaonrails/cr_manga_downloadr)
* [Versão Ruby/JRuby](https://github.com/akitaonrails/manga-downloadr)
* [Versão Elixir](https://github.com/akitaonrails/ex_manga_downloadr)

E vocês podem rodar o modo de teste assim:

```
# crystal:
time ./cr_manga_downloadr --test

# MRI:
time bin/manga-downloadr --test

# JRuby (você precisa editar o Gemfile pra descomentar a engine JRuby):
time jruby --dev -S bin/manga-downloadr --test

# Elixir:
time ./ex_manga_downloadr --test
```

Isso vai rodar só o fetch de capítulos, páginas e links de imagens, pulando o download real das imagens, otimização via mogrify e compilação do PDF. Essas partes puladas demoram demais e não dizem nada sobre as linguagens testadas.

E se quiserem testar só as partes intensivas em CPU e evitar qualquer interferência de rede, vocês podem ligar o modo HTTP Cache e rodar os testes duas vezes pra que a primeira execução cacheie tudo, assim:

```
# crystal:
time ./cr_manga_downloadr --test --cache

# MRI:
time bin/manga-downloadr --test --cache

# JRuby (você precisa editar o Gemfile pra descomentar a engine JRuby):
time jruby --dev -S bin/manga-downloadr --test --cache

# Elixir:
time CACHE_HTTP=true ./ex_manga_downloadr --test
```

Então, **com todas as requisições já cacheadas** esses são os resultados:

Elixir:

```
7,13s user 0,24s system 331% cpu 2,227 total
```

MRI Ruby:

```
5.590000   0.180000   5.770000 (  5.678714)
5,87s user 0,21s system 101% cpu 5,996 total
```

JRuby:

```
10.580000   0.180000  10.760000 (  3.184472)
14,54s user 0,44s system 262% cpu 5,716 total
```

Crystal:

```
1.610000   0.050000   1.660000 (  1.344123)
1,62s user 0,06s system 124% cpu 1,350 total
```

As versões Ruby/JRuby/Crystal têm benchmarks internos pra remover o tempo de startup (por isso elas têm 2 linhas de tempos).

Então, Elixir é muito rápido. Leva mais ou menos 2 segundos pra parsear todos os 1.900 arquivos HTML procurando os links.

Ruby é o mais lento, obviamente. Leva quase 6 segundos.

A versão JRuby também leva quase 6 segundos, mas internamente processa em 3 segundos; o resto é tempo de startup e warm up da JVM por baixo.

E Crystal é o mais rápido, como vocês esperariam, porque é um binário super otimizado fazendo operações CPU bound, marcando pouco mais de 1 segundo.

### Conclusão

Mesmo com algoritmos mais ou menos parecidos, Elixir continua ganhando por uma margem muito grande no processo total (com as requisições HTTP externas).

Tem mais coisa em jogo além de velocidade de interpretador/compilador, além de infraestrutura de single-thread, multi-thread e fibers.

Também temos a maturidade das respectivas bibliotecas padrão (incluindo stack TCP, bibliotecas HTTP client, operações de String/Array/Regex, etc.) e bibliotecas de terceiros (libXML, Nokogiri, etc.). Então tem muita coisa que pode interferir nos testes. Eu chutaria que a stdlib do Crystal, especialmente as partes de rede, ainda não está bem testada em batalha nesse momento (pré 1.0!).

Então, o resumo com os novos resultados é esse:

* MRI Ruby 2.3.1: 27 segundos
* JRuby 9.1.1.0: 30 segundos
* Crystal 0.17.0: 21 segundos
* Elixir: 15 segundos

Me avisem se tiverem ideias pra deixar tudo ainda mais rápido!
