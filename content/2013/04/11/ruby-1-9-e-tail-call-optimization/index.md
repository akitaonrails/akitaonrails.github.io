---
title: Ruby 1.9 e Tail Call Optimization
date: '2013-04-11T00:25:00-03:00'
slug: ruby-1-9-e-tail-call-optimization
tags:
- learning
- ruby
draft: false
---

Se você sabe o que é [Tail Call Optimization](http://c2.com/cgi/wiki?TailCallOptimization) (TCO), provavelmente também já deve ter ouvido falar que Ruby não suporta TCO. Se você não sabe o que é ['tail call'](http://stackoverflow.com/questions/310974/what-is-tail-call-optimization) vale definir:

> Em ciência da computação, um 'tail call' é uma sub-rotina que acontece dentro de uma procedure como sua ação final; ela pode produzir um retorno que é então imediatamente retornada pela procedure que a chamou.

![Mito Detonado](http://s3.amazonaws.com/akitaonrails/assets/image_asset/image/332/busted.jpg)

TCO também é chamado às vezes de [Tail Recursion Elimination](http://stackoverflow.com/questions/1240539/what-is-tail-recursion-elimination), que é uma parte de TCO na verdade. Esse nome é mais simples de entender. Todo programador sabe o que é uma [recursão](http://bit.ly/154TwUO) - uma função que chama ela mesma em algum ponto - e como isso deve ser evitado sempre que possível por uma versão iterativa, para fugir do perigo de estourar a pilha pois recursão tem limite.

O equivalente _"hello world"_ de recursão é o bom e velho [fatorial](http://en.wikipedia.org/wiki/Factorial) que, em Ruby, poderíamos escrever desta forma:

--- ruby
def fact(n)
  n == 0 ? 1 : n * fact(n-1)
end
```

Dependendo da versão do Ruby que estiver usando ela vai estourar num número n não muito alto. No meu Macbook Pro, com Ruby 1.9.3-p392, essa execução recursiva estoura com <tt>stack level too deep (SystemStackError)</tt> no n = 8180.

Quem estudou Algoritmos e Estruturas de Dados aprendeu a tentar buscar a versão não-recursiva. No caso do Ruby temos a sorte dela ser expressiva para poder ser escrita da seguinte forma com a ajuda de closures:

--- ruby
def fact(n)
  sum = 1
  sum.upto(n) { |i| sum *= i }
  sum
end
```

Esta versão vai aguentar valores muito mais altos que o vergonhoso 8180 da versão recursiva. Uma discussão que vi hoje o [Rafael Rosa e o Henrique Bastos](https://twitter.com/rafaelrosafu/status/322144896217669633) twitando fala sobre porque [Python não suporta TCO](http://neopythonic.blogspot.com.br/2009/04/tail-recursion-elimination.html). Então, curioso, resolvi investigar o que eu achava que sabia: de que Ruby também não tem TCO. Mas acabei encontrando [esta issue de 5 meses atrás no Ruby Core](http://bugs.ruby-lang.org/issues/6602) sobre habilitar TCO que **já existe no MRI 1.9** mas não é ativada por padrão.

Para possibilitar essa otimização, precisamos modificar a versão recursiva que mostrei antes para que ela não precise de um [call stack](http://en.wikipedia.org/wiki/Call_stack), e para isso a última ação precisa ser direto a chamada recursiva. Então a nova versão (ainda recursiva) fica assim:

--- ruby
def self.fact(n, m = 1)
  n < 2 ? m : fact(n-1, m*n)
end
```

No Ruby 1.9 você pode ativar o TCO e executar o código com tail call desta forma:

--- ruby
RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}

RubyVM::InstructionSequence.new(<<-EOF).eval
  # código com tail call
EOF
```

Vamos fazer um teste com o seguinte código:

--- ruby
require 'benchmark'
module Test
  def self.fact_recursive(n)
    n == 0 ? 1 : n * fact_recursive(n-1)
  end

  def self.fact_tail_call(n, m = 1)
    n < 2 ? m : fact_tail_call(n-1, m*n)
  end

  def self.fact_iterative(n)
    sum = 1
    sum.upto(n) { |i| sum *= i }
    sum
  end
end

def fact1(n)
  Benchmark.bm do |x|
    x.report { Test.fact_iterative(n) }
    x.report { Test.fact_tail_call(n) }
    x.report { Test.fact_recursive(n) }
  end
end

fact1(8180)
fact1(10000)
```

Notem que vamos iniciar com o TCO **desligado** <tt>:tailcall_optimization => false</tt> e o resultado é o seguinte:

```
$ ruby factorial.rb
    user     system      total        real
0.030000   0.000000   0.030000 (  0.030289)
0.040000   0.010000   0.050000 (  0.056056)
0.030000   0.010000   0.040000 (  0.043861)
    user     system      total        real
0.050000   0.000000   0.050000 (  0.042917)
factorial.rb:14: stack level too deep (SystemStackError)
```

Vejam que rodando até o limite de 8180 temos pouca diferença entre as versões iterativa não-recursiva, recursiva com tail call e recursiva normal. Mas com o valor mais alto de 10000 as versões recursivas estouram como esperado.

Agora vamos ativar o TCO:

--- ruby
RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}

RubyVM::InstructionSequence.new(<<-EOF).eval
  require 'benchmark'
  module Test
    def self.fact_recursive(n)
      n == 0 ? 1 : n * fact_recursive(n-1)
    end

    def self.fact_tail_call(n, m = 1)
      n < 2 ? m : fact_tail_call(n-1, m*n)
    end

    def self.fact_iterative(n)
      sum = 1
      sum.upto(n) { |i| sum *= i }
      sum
    end
  end

  def fact1(n)
    Benchmark.bm do |x|
      x.report { Test.fact_iterative(n) }
      x.report { Test.fact_tail_call(n) }
      x.report { Test.fact_recursive(n) }
    end
  end
EOF

fact1(8180)
fact1(10000)
```

Agora temos o seguinte resultado:

```
$ ruby factorial.rb
    user     system      total        real
0.030000   0.000000   0.030000 (  0.030832)
0.030000   0.000000   0.030000 (  0.033130)
0.030000   0.000000   0.030000 (  0.029922)
    user     system      total        real
0.040000   0.000000   0.040000 (  0.043725)
0.050000   0.000000   0.050000 (  0.046619)
<compiled>:4: stack level too deep (SystemStackError)
```

Desta vez a versão com tail call sobrevive ao valor acima do meu limite de 8180 e a recursiva que não tem tail call estoura por causa da sequência de call stacks que ele é obrigado a fazer.

E podemos ir mais longe e chamar um valor bem maior como <tt>fact1(100_000)</tt>:

```
$ ruby factorial.rb
    user     system      total        real
5.190000   1.290000   6.480000 (  6.474756)
5.650000   2.010000   7.660000 (  7.676733)
<compiled>:4: stack level too deep (SystemStackError)
```

Novamente, podemos ver que a versão com recursão e tail call performance só um pouco pior que a versão iterativa não-recursiva.

Portanto, detonamos o mito de que Ruby não suporta Tail Call Optimization. Não sei ainda se existe algum efeito colateral mas pelo menos temos a opção de ativá-la e executá-la somente dentro da instância de <tt>RubyVM::InstructionSequence</tt>. Não consigo imaginar um caso de uso prático, então se souber de algum não deixe de comentar.
