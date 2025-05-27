---
title: Swift para Rubistas, Funções e Closures
date: '2014-06-07T12:38:00-03:00'
slug: swift-para-rubistas-funcoes-e-closures
tags:
- learning
- beginner
- apple
- swift
- objective-c
draft: false
---

Se tem uma coisa que nós rubistas estamos muito acostumados e gostamos bastante são closures, blocos ou fechamentos. Expliquei esse mecanismo pela primeira vez em 2007 aqui no blog, então se ainda não conhece bem o conceito, releia [meu post](http://www.akitaonrails.com/2007/11/30/anatomia-de-ruby-blocks-closures#.U5MdTBYduzA).

Em 2010 a Apple adicionou a funcionalidade de closures ao Objective-C também e modificou muitas de suas APIs para aproveitar esse recurso. Também postei sobre isso 3 anos atrás, então releia [meu post](http://www.akitaonrails.com/2010/11/28/objective-c-brincando-com-categorias-e-blocos#.U5MdhxYduzA) para aprender sobre isso.

Finalmente, Swift é basicamente Objective-C melhorado então temos o mesmo recurso.

<h2>Entendendo Funções e Blocos</h2>

A idéia é poder criar funções "customizáveis", ou seja, um pedaço de código que espera outro pedaço de código. Existem duas formas de se fazer isso. No mundo C podemos passar diretamente uma função como parâmetro para ser executada dentro de outra função. Isso não é uma closure, é o que chamamos de "callback". Em Objective-C e Swift, podemos passar uma função como parâmetro ou mesmo fazer uma função retornar uma função.

```C
func soma(x: Int, y: Int) -> Int {
    return x + y
}

func calculadora(calculo: (Int, Int) -> (Int), a: Int, b: Int) {
    let resultado = calculo(a, b)
    println(resultado)
}

calculadora(soma, 10, 20)
// "30"
```

Veja o código acima, definimos uma função de soma, que recebe dois inteiros como parâmetro e retorna um inteiro. Depois definimos uma função genérica chamada "calculadora" que recebe como parâmetro uma função com a assinatura <tt>(Int, Int) -> Int</tt> que significa "uma função que receba dois inteiros e retorne um inteiro" e depois dois parâmetros inteiros.

Ao executar <tt>calculadora(soma, 10, 20)</tt>, passamos a função soma, os números 10 e 20 e internamente atribuímos a função soma a uma variável chamada "calculo" e executamos passando os dois inteiros, que, obviamente, serão somados. E a resposta no final será 30.

```C
func multiplicacao(x: Int, y: Int) -> Int {
    return x * y
}

calculadora(multiplicacao, 3, 5)
// "15"
```

Podemos agora criar quaisquer funções com a mesma assinatura e depois mandar para a calculadora. Em Ruby não temos a mesma funcionalidade:

```ruby
def soma(x, y)
  x + y
end

def calculadora(calculo, a, b)
  puts calculo(a, b)
end

calculadora(soma, 10, 20)
# ArgumentError: wrong number of arguments (0 for 2)
# 	from (irb):1:in `soma'
# 	from (irb):9
# 	from /usr/bin/irb:12:in `<main>'
```

Em Ruby, parênteses são opcionais e ao tentar passar o método "soma" como parâmetro, na verdade ele está já tentando executar o método. Existe uma forma, não ortodoxa, que podemos ter um efeito similar, mas não é a mesma coisa, seria assim:

```ruby
def calculadora(calculo, a, b)
  puts send(calculo, a, b)
end

calculadora(:soma, 10, 20)
```

O método [<tt>send</tt>](http://ruby-doc.org/core-2.1.1/Object.html#method-i-send) é uma das formas de se enviar mensagens a objetos (Objective-C também tem isso, na forma de seletores e do método <tt>performSelector</tt> que expliquei [neste outro post](http://www.akitaonrails.com/2010/12/06/objective-c-method-missing#.U5MhaRYduzA)). Então, em vez de passar diretamente o método, passamos apenas o nome dele como um symbol e internamente executamos o método passando os parâmetros. Isso é só "similar" porque na prática o método em si nunca foi passado como parâmetro.

O que podemos fazer em Ruby é não usar métodos, mas blocos:

```ruby
soma = lambda do |x, y|
  x + y
end

def calculadora(calculo, a, b)
  puts calculo.(a, b)
end

calculadora(soma, 10, 20)
```

Aqui a semântica é diferente. Primeiro criamos um bloco, literalmente o que seria o "corpo de um método" usando <tt>lambda</tt>. Depois passamos o bloco com parâmetro ao método <tt>calculadora</tt>. E dentro dela executamos o bloco com um "ponto" antes dos parênteses, que é a forma curta de se fazer <tt>soma.call(a, b)</tt>

Um bloco, em Ruby, é diferente de uma método ou função. Isso porque ele também é um fechamento do estado ao redor do bloco. Blocos não são métodos. Em Ruby, o método está associado ("binding") à classe que a define (mesmo sem definir um <tt>class</tt>, estamos dentro sempre dentro de um objeto, diferente de Swift ou Objective-C ou mesmo outra linguagem). Um bloco está associado à uma variável e por isso podemos mais facilmente repassá-la para outros métodos.

Em Swift também podemos devolver funções ou ter "Nested Functions", por exemplo:

```C
func calculo(tipo: String) -> (Int, Int) -> Int {
    func soma(x: Int, y: Int) -> Int {
        return x + y
    }
    func multiplicacao(x: Int, y: Int) -> Int {
        return x * y
    }
    if tipo == "soma" {
        return soma
    } else {
        return multiplicacao
    }
}

func calculadora(calculo: (Int, Int) -> Int, a: Int, b: Int) {
    println(calculo(a, b))
}

calculadora(calculo("soma"), 10, 20)
// 30
```

Em Ruby, o mais próximo, usando blocos, seria:

```ruby
def calculo(tipo)
  soma = lambda { |x, y| x + y }
  multiplicacao = lambda { |x, y| x * y }
  if tipo == :soma
    soma
  else
    multiplicacao
  end
end

def calculadora(c, a, b)
  puts c.(a, b)
end

calculadora(calculo(:soma), 10, 20)
# 30
```

<h2>Entendendo Blocos em Swift</h2>

Sabendo dessa base podemos prosseguir para o próximo passo, blocos em Swift.

Primeiro, vejamos o uso mais comum de blocos em Ruby:

```ruby
def numero(bla)
  yield(bla) if block_given?
end

numero 20 do |x|
  x * 10
end
# 200
```

Definimos um método chamado <tt>numero</tt> que recebe um parâmetro "bla". Internamente chamamos <tt>yield</tt> que pega o bloco passado como último parâmetro do método e repassa o parâmetro "bla" a ele. Fora, executamos o método frase, passando 20 como parâmetro e um bloco (delimitado por "do..end") que recebe uma variável x e apenas multiplica ela por 10.

Podemos reescrever o mesmo código da seguinte forma:

```ruby
def numero(bla, &bloco)
  bloco.(bla) if bloco
end

numero(20) { |x| x * 10 }
# 200
```

É exatamente o mesmo código mas agora o bloco está definido como parâmetro mais explicitamente. O "&" diz que vamos passar o bloco fora dos parênteses do método. Executamos o bloco dentro com o "ponto" (no lugar de "call", como explicamos antes). E ao executar o método, desta vez deixei os parênteses opcionais e no lugar de "do..end" usei "{}", que é a mesma coisa. Por convenção, em Ruby, usamos "{}" quando um bloco tem somente uma linha de implementação e usamos "do..end" quando tem múltiplas linhas.

Obs, o [@josevalim](http://twitter.com/josevalim) me explicou que há outra sintaxe que podemos usar e são equivalentes (embora pareça que só funcione em one-lines):

```C
numero.map { (var x: Int) -> Int in return x * 10 }
numero.map { $0 * 10 } // equivalente ao de cima
```

Confinuando, podemos fazer a mesma coisa em Swift, assim:

```C
func numero(bla: Int, bloco: (Int) -> Int) {
    println(bloco(bla))
}

numero(20, { (x: Int) -> Int in return x * 10 } )
```

Por causa da necessidade de definir o seletor/assinatura, com parâmetros e tipo de retorno, a execução da closure em Swift é bem mais verbosa do que em Ruby. A sintaxe é semelhante, usando chaves "{}" para delimitar o bloco, a assinatura para delimitar a função anônima e o corpo do bloco depois de "in". Na prática é quase a mesma coisa.

Do livro oficial da Apple temos o seguinte exemplo que pode demonstrar um pouco melhor (eu mudei o exemplo pois no livro ele usa um Dictionary para "digitNames" mas as chaves são exatamente a posição num Array, então achei melhor usar diretamente um Array):

```C
let digitNames = [
	"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"
]
let numbers = [16, 58, 510]

let strings = numbers.map {
    (var number) -> String in
    var output = ""
    while number > 0 {
        output = digitNames[number % 10] + output
        number /= 10
    }
    return output
}
// strings is inferred to be of type String[]
// its value is ["OneSix", "FiveEight", "FiveOneZero"]
```

A mesma coisa em Ruby ficaria assim:

```ruby
digit_names = [
  "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"
]
numbers = [16, 58, 510]
strings = numbers.map do |number|
  output = ""
  while number > 0 
    output = digit_names[number % 10] + output
    number = number / 10
  end
  output
end
# ["OneSix", "FiveEight", "FiveOneZero"]
```

Veja como a lógica em si é bastante semelhante, se ignorar a definição mais exata de tipos do Swift, os dois códigos são praticamente idênticos.

No [meu post de 2010](http://www.akitaonrails.com/2010/12/06/objective-c-method-missing#.U5MhaRYduzA) sobre como implementar o equivalente a "method_missing" em Objective-C eu parti deste exemplo comum de DSL do mundo Ruby:

```ruby
require 'builder'
x = Builder::XmlMarkup.new(:target => $stdout, :indent => 1)
x.html do |h|
  h.body do |b|
    b.h1 "Hello World"
    b.p "This is a paragraph."
    b.table do |t|
      t.tr do |tr|
        tr.td "column"
      end
    end
  end
end
```

E cheguei neste equivalente em Objective-C:

```C
XmlBuilder* xml = [[XmlBuilder alloc] init];
[xml htmlBlock:^(XmlBuilder* h) {
    [h bodyBlock:^(XmlBuilder* b) {
        [b h1:@"Hello World"];
        [b p:@"This is a paragraph."];
        [b tableBlock:^(XmlBuilder* t) {
            [t trBlock:^(XmlBuilder* tr) {
                [tr td:@"column"];
            }];
        }];            
    }];
}];
```

Absolutamente verborrágico! Não era divertido usar blocos em Objective-C pela quantidade de delimitadores com chaves, parênteses, colchetes. Em Ruby é bem mais simples porque parênteses são todos opcionais e blocos são delimitados quase como métodos.

Ainda não reimplementei esse experimento que fiz em Objective-C para Swift (fica como lição de casa). Farei isso num próximo artigo sobre metaprogramação e seletores em Swift. Mas se tivéssemos reescrito, provavelmente o código ficaria mais ou menos assim:

```C
// Swift:                            // Ruby:
xml = XmlBuilder()                   // x = Builder::XmlMarkup.new
xml.html({ (var h) -> Void in        // x.html do |h|
    h.body({ (var b) -> Void in      //   h.body do |b|
        b.h1("Hello World")          //     b.h1 "Hello World"
        b.p("This is a paragraph")   //     b.p "This is a paragraph."
        b.table({ (var t) -> Void in //     b.table do |t|
            t.tr({ (var tr) -> Void  //       t.tr do |tr|
                tr.td("column")      //         tr.td "column"
            })                       //       end
        })                           //     end
    })                               //   end
})                                   // end
```

Veja que comparado à versão em Objective-C é "muito" melhor. Mesmo assim, se comparado ao que fazemos em Ruby, continua sendo mais verboso do que gostaríamos por causa dos parênteses obrigatórios e declaração de tipos das funções, mas agora sim fica muito mais prático ver que podemos fazer DSLs em Swift também.

Isso deve dar uma luz sobre como a nova sintaxe do Swift é de fato um real ganho de legibilidade e produtividade para programadores acostumados a Objective-C e como nós, de Ruby, podemos rapidamente nos adaptar a essa nova linguagem para produzir bibliotecas e frameworks. Uma vantagem do Swift é que ele é imediatamente compatível com toda a API escrita em Objective-C, portanto onde antes era chato escrever as closures, agora fica imediatamente mais simples.
