---
title: 'Operador Pipe do Elixir para Ruby: Chainable Methods'
date: '2016-02-18T16:28:00-02:00'
slug: operador-pipe-do-elixir-para-ruby-chainable-methods
translationKey: elixir-pipe-for-ruby-chainable
aliases:
- /2016/02/18/elixir-pipe-operator-for-ruby-chainable-methods/
tags:
- ruby
- elixir
- traduzido
draft: false
---

Rolaram [discussões](http://blog.molawson.com/elixir-pipes-in-ruby/) [recentes](https://gist.github.com/pcreux/2f87847e5e4aad37db02) sobre como seria legal ter algo parecido com o incrível Pipe Operator do Elixir no Ruby.

Se você não sabe o que é o "Pipe Operator" no Elixir, olha esse código aqui:

```ruby
Enum.sum(Enum.filter(Enum.map(1..100_000, &(&1 * 3)), odd?))
```

É feio, todo mundo sabe. Numa linguagem orientada a objetos como Ruby, a gente faria algo assim:

```ruby
(1..100_000).
  map { |i| i * 3 }.
  select(&:odd?).
  reduce(&:+)
```

Só que Elixir não tem objetos, só funções. Então como escrever código de forma mais elegante? A solução apareceu na forma do tal "Pipe Operator", que pega o último valor retornado e passa ele como primeiro argumento da próxima chamada de função, assim:

```ruby
1..100_000
  |> Stream.map(&(&1 * 3))
  |> Stream.filter(odd?)
  |> Enum.sum
```

Então Ruby e Elixir "parecem" a mesma coisa quando conseguimos "encadear" métodos. No mundo Ruby a gente não tem a "necessidade" de um operador desses. Mas seria bacana ter um mecanismo para deixar nosso código mais expressivo, mais testável, mais legível. Por exemplo, imagina escrever algo assim:

```ruby
(1..100_000).
  multiple_each_element_by_three.
  filter_out_odd_elements.
  give_the_sum_of_all_elements
```

Claro, esse é um exemplo bem limitado com nomes de métodos péssimos. Mas se você pegar o artigo do Mo Lawson que linkei acima, fica bem mais interessante:

```ruby
keywords
  .map { |kw| kw.gsub(/(^[^[:alpha:]]+|[^[:alpha:]]+$)/, '') }
  .map { |kw| LegacySpanishCorrector.new.correct(kw) }
  .map { |kw| kw.gsub(/[^[:alpha:]\d'_\-\/]/, '') }
  .reject { |kw| STOP_WORDS.include?(kw) }
```

Ruby permite encadear métodos de Enumerable um atrás do outro, transformando a lista inicial de keywords em "alguma coisa" que fica bem difícil de inferir só olhando para o código.

E essa outra versão, o que acha?

```ruby
class KeywordNormalizer
  def call(keywords)
    Collection.new(keywords)
      .strip_outer_punctuation
      .fix_spanish
      .clean_inner_punctuation
      .remove_stop_words
      .to_a
  end

  # ...
end
```

É aonde ele chega no fim do artigo: muito mais legível, e cada método isolado fica testável via unit test, resultando em código mais robusto.

A ideia desse post é apresentar minha nova gem ["Chainable Methods"](https://rubygems.org/gems/chainable_methods). O [código-fonte](https://github.com/akitaonrails/chainable_methods) está no Github, como sempre, então por favor contribua.

Minha gem permite escrever o último código do Lawson assim:

```ruby
KeywordNormalizer
  .chain_from(keywords)
  .strip_outer_punctuation
  .fix_spanish
  .clean_inner_punctuation
  .remove_stop_words
  .to_a
  .unwrap
```

Você adiciona o <tt>chainable_methods</tt> no seu Gemfile como sempre (já sabe o procedimento), e aí pode escrever o módulo do Lawson desse jeito:

```ruby
module KeywordNormalizer
  extend ChainableMethods
  
  def self.strip_outer_punctuation(array)
    array.map { |el| el.gsub(/(^[^[:alpha:]]+|[^[:alpha:]]+$)/, '') }
  end
  def self.fix_spanish(array)
    array.map { |el| LegacySpanishCorrector.new.correct(el) }
  end
  def self.clean_inner_punctuation(array)
    array.map { |el| el.gsub(/[^[:alpha:]\d'_\-\/]/, '') }
  end
  def self.remove_stop_words(array)
    array.reject { |el| STOP_WORDS.include?(el) }
  end
end
```

É isso, agora você pode encadear tudo como mostrei antes. O padrão é:

1) Escreva um Module com métodos de classe que recebam pelo menos um argumento e que extendam o módulo 'ChainableMethods':

```ruby
module MyModule
  extend ChainableMethods

  def self.method_a(argument1)
    # ...
  end

  def self.method_b(argument1, argument2)
    # ...
  end

  def self.method_c(argument1)
    # yield a block passing the received argument
  end
end
```

2) Envolva um estado inicial que será passado como primeiro argumento do primeiro método:

```ruby
some_initial_state = "Hello World"
MyModule
  .chain_from(some_initial_state)
  # ...
```

3) Encadeie quantos métodos quiser do módulo ou métodos que o estado retornado reconheça:

```ruby
MyModule
  .chain_from(some_initial_state)
  .upcase
  .method_a
  .method_b(argument2)
  .method_c { |foo| foo }
  .split(" ")
  .join(", ")
  .unwrap
```

Repare que não precisamos passar o primeiro argumento para os métodos dentro do módulo 'MyModule'. Ele pega o resultado da última chamada automaticamente.

4) Não esqueça de chamar <tt>#unwrap</tt> como última chamada para obter o resultado final da cadeia.

### Um Experimento

E é isso! Isolei esse comportamento apenas em módulos que explicitamente extendem o módulo 'ChainableMethods', em vez de habilitar automagicamente no nível de BasicObject como muitos pensariam de primeira, porque queremos evitar um 'method_missing' global solto por aí sem controle.

Esse comportamento usa 'method_missing', então não vai ser rápido num benchmark sintético contra uma chamada direta de método, por razões óbvias. O propósito aqui é expressividade, não velocidade. Tenha isso em mente.

O caso de uso é: sempre que você tiver algum tipo de transformação, vai querer uma cadeia de funções isoladas e testáveis via unit test. E é assim que dá para conseguir isso sem muita dor de cabeça.

Isso é um experimento. Como estou usando 'method_missing', podem rolar efeitos colaterais que ainda não enxerguei, então por favor me avise nas [Github Issues](https://github.com/akitaonrails/chainable_methods/issues) e mande feedback se ajudou em algum projeto.

Pull Requests são muito bem-vindos!
