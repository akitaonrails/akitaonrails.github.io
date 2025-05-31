---
title: Algumas Dicas da Linguagem Ruby
date: '2012-06-29T18:35:00-03:00'
slug: algumas-dicas-da-linguagem-ruby
tags:
- learning
- beginner
- ruby
- tutorial
draft: false
---

A linguagem Ruby permite escrever código que faz coisas semelhantes de maneiras diferentes. É um dos fatores que comumente se atribui ao famoso [Principle of Least Surprise](http://www.artima.com/intv/ruby4.html). Ruby permite que se escreva código de forma semelhantes ao que um programador que vem de Java ou Python estaria acostumado, algumas dessas formas não são consideradas “rubismos”.

Por outro lado, muito da inspiração vem de Perl, permitindo alguns [one-liners](http://en.wikipedia.org/wiki/One-liner_program) que surpreendem e outros que até assustam.

Vamos dar uma olhada em alguns exemplos, dos mais triviais até alguns mais estranhos.

## Variáveis

Alguma vez você já teve que trocar os valores de duas variáveis? Não é difícil encontrar código assim:

* * *

```ruby
sobrenome = “Fabio”  
nome = “Akita”

temporario = nome  
nome = sobrenome  
sobrenome = temporario

puts “#{nome} #{sobrenome}”

# Fabio Akita
```

Ruby permite simplificar a mesma coisa da seguinte forma:

* * *

```ruby
sobrenome = “Fabio”  
nome = “Akita”

nome, sobrenome = sobrenome, nome

puts “#{nome} #{sobrenome}”

# Fabio Akita  
```

## Strings

Aliás, quem está iniciando pode não entender a última linha dos exemplos anteriores. Como exemplo, digamos que temos duas variáveis e queremos concatená-las. Em algumas linguagens, o seguinte seria normal:

* * *

```ruby
nome, sobenome = “Fabio”, “Akita”  
puts nome + " " + sobrenome

#Fabio Akita  
```

Porém em Ruby, preferimos usar interpolação de strings:

* * *

```ruby
nome, sobrenome = “Fabio”, “Akita”  
puts “#{nome} #{sobrenome}”  
```

Ou quem vem de linguagens como C pode querer [strings formatadas](http://ruby-doc.org/core-1.9.3/String.html#method-i-25), nesse caso podemos fazer:

* * *

```ruby

puts “O %s custa R$ %0.2f” % [produto, valor]
# O Livro custa R$ 35.99  
```

Falando em interpolação, você precisa usar necesariamente aspas duplas. Agora quando se tem aspas duplas dentro da string, precisa “escapar”, por exemplo:

* * *

```ruby
id, method, action, length, size = “search”, “get”, 140, 28  
 html = ”hsearch“>
 ”#{search}" action=“#{action}” method=“#{method}”
 autocomplete=“off”>

<input autocomplete=“off” name=“q” class=“textbox”
 placeholder=“search” tabindex=“1” type=“text”
 maxlength=“#{length}” size=“#{size}” value=“\”>  
```

Isso é muito feio. Existe a opção de [heredocs](http://blog.jayfields.com/2006/12/ruby-multiline-strings-here-doc-or.html) mas outra forma melhor simplesmente assim:

* * *

```ruby
id, method, action, length, size = %w(search get 140 28)
html = %{

<form id="#{id}" action="#{action}" method="#{method}" autocomplete="off">  <br>
    <div>  <br>
      <input autocomplete="off" name="q" class="textbox" placeholder="search" tabindex="1" type="text" maxlength="#{length}" size="#{size}" value="">
</div>
</form>

 }
```

Usar “%” com praticamente qualquer outro operador como “[]” ou “{}” costuma funcionar da mesma forma. Aproveitando, para quem não sabia, na primeira linha desse exemplo está outro jeito alternativo de declarar Arrays de strings, usando “%w()”. O exemplo abaixo, as duas linguas são equivalentes:

* * *

```ruby
array = [“foo”, “bar”, “hello”, “world”]  
array = %w(foo bar hello world)  
```

Especialmente se forem muitos elementos diferentes pra inicializar, a segunda forma é bem mais legível.

## Condicionais

O exemplo a seguir deve ser fácil de entender pra qualquer programador:

* * *

```ruby
dinheiro = 600  
 imposto = 0  
 if dinheiro > 10000
 imposto = 100
elsif dinheiro <= 10000 and dinheiro > 500
 imposto = 10  
 else  
 imposto = 1
end  
  #=> 10
```

Assumo que independente de qual linguagem você veio, esse trecho não deve ter nenhuma dúvida. Agora, algumas coisas que podemos fazer diferente. Primeiro uma dica simples. Números em Ruby podem ser delimitador no campo de milhar com “\_”. As linhas seguintes são equivalentes:

* * *

```ruby

a = 1000000000000  
b = 1\_000\_000\_000\_000  
a == b

# true  
```

Mas vocês vão concordar que a segunda forma é bem mais legível. Então já podemos melhorar o exemplo anterior assim:

* * *

```ruby

dinheiro = 600  

imposto = if dinheiro > 10_000
 100
elsif dinheiro <= 10_000 and dinheiro > 500
 10  
 else  
 1
end  
  #=\ 10  
```

Note outra diferença: normalmente dentro do resultados de uma condicional você atribui alguma valor à uma variável. Se o objetivo do bloco “if” e suas condicionais for preencher a mesma variável, podemos utilizar o fato que todas as construções de bloco no Ruby, como “if”, “while”, “case”, “for” e outros sempre devolvem o valor da última expressão executada. Então o “if” todo vai devolver um valor e podemos atribuí-la à variável que queremos. Lembrem também que em Ruby não precisamos usar “return” ao sair de métodos, pois também todo método sempre retorna o valor da última expressão executada. Assim, o exemplo acima equivale ao primeiro desta seção.

* * *

```ruby
dinheiro = 600  
  imposto = case dinheiro  
 when (0..500) then 1
when (500..10_000) then 10  
 else 100  
 end

 #=> 10
```

Agora, 3 coisas. Primeiro, trocamos o “if” por um “case”, que nesse caso é bem melhor. Segundo, usamos o mesmo fato de “case” também devolver um resultado e atribuir à variável “imposto”. Finalmente, resolvi usar um “Range” para a comparação.

Falando sobre o “case”, os dois exemplos a seguir não são equivalentes, apesar do efeito ser o mesmo:

* * *

```ruby

# exemplo 1  
if a == b  
 …  
end

# exemplo 2  
case a  
when b then …  
end  
```

O “when” na realidade não executa “==” mas sim “===”. No caso original, quando fazemos <tt>case dinheiro; when (0..500)</tt> o método “===” na realidade está fazendo <tt>(0..500).include?(dinheiro)</tt>. O exemplo a seguir ilustra essa funcionalidade mas deixo a cargo do leitor descobrir como esse código funciona:

* * *

```ruby

def multiplo_de(x)  
 Proc.new { |produto| produto.modulo(x).zero? }
end

numero = 10  
case numero  
when multiplo_de(3) then puts “múltiplo de 3”  
when multiplo_de(5) then puts “múltiplo de 5”  
when multiplo_de(7) then puts “múltiplo de 7”  
end

#  múltiplo de 5  

```

Caso tenha dado nó na cabeça, a dica pra entender é que as chamadas a seguir são equivalentes:

* * *

```ruby
multiplo_de(10).call(10)  
multiplo_de(10)-=(10) multiplo_de(10) = 10  
```

## Ranges e Enumerators

Divaguei um pouco em relação ao exemplo original da seção anterior. Lembrem que mencionei vagamente sobre [Range](http://ruby-doc.org/core-1.9.3/Range.html). Para quem não sabe, um Range é uma classe que representa um intervalo. Veja a documentação, pois um Range não precisa ser um intervalo apenas numérico, pode ser intervalo entre strings ou entre quaisquer objetos que implementem o protocolo com os métodos <tt><=></tt> e <tt>succ</tt>.

Vejamos alguns exemplos:

* * *

```ruby
for i in (5..100)  
 …  
end

5.upto(100) do |i|  
 …  
end

(5..100).each do |i|  
 …  
end  
```

Os três exemplos acima são equivalentes. No caso do método <tt>upto</tt>, lembrar que existe o oposto:

* * *

```ruby
100.downto(5) do |i|  
 …  
end  
```

Agora, podemos expandir um Range em um Array. Duas formas para isso:

* * *

```ruby
array = (5..100).to\_a  
array = [\*(5..100)]  
```

O segundo exemplo é uma coerção usando splat, vamos ver splats mais abaixo.

Como exercício, podemos ver um exemplo onde queremos somar todos os números entre 5 e 100. Todos os exemplos abaixo são equivalentes:

* * *

```ruby

#1. iniciantes fazem algo assim:  
total = 0  
for i in (5..100)  
 total += i  
end  
puts total
2. 5040

#2. quem aprendeu um pouco mais de métodos de Enumerator, faz assim:  
total = 0  
(5..100).each do |i|  
 total += i  
end  
total
2. 5040

#1. o ideal é aprender sobre #reduce e #inject (que são a mesma coisa):  
(5..100).reduce(0) { |total, i| total += i }
2. 5040

#1. e o jeito melhor ainda de #reduce, se for só um método pra reduzir  
(5..100).reduce(0, :+)
2. 5040

#1. se o valor inicial for zero mesmo, o seguinte é a mesma coisa:  
(5..100).reduce(:+)
2. 5040  

```

## Hashes

Uma das estruturas de dados mais úteis do Ruby depois dos Arrays é sem dúvida o Hash. Ele é basicamente um dicionário, uma coleção de pares de chaves (key) ligando a valores. Ele pode ser inicializado de várias formas, mas as mais conhecidas são:

* * *

```ruby

#. versões 1.8 e 1.9  
hash = { :chave_a => “valor a”, :chave_b => “valor b” }

#1. somente versão 1.9 e superior  
hash = { chave_a: “valor a”, chave_b: “valor b” }  
```

Uma coisa que normalmente não é tão lembrado é que posso utilizar um Array para popular um Hash, sendo que o Array contém elementos intercalados de chave e valor, por exemplo:

* * *

```ruby
array = [:chave_a, “valor a”, :chave_b, “valor b”]  
```

Agora, podemos usar o [operador splat](http://www.jacopretorius.net/2012/01/splat-operator-in-ruby.html) com o método <tt>[]</tt> da class Hash:

* * *

```ruby
hash = Hash[*array]

1. {:chave_a=>"valor a", :chave_b=>"valor b"}
```

Veja o artigo no link para mais exemplos de como usar o operador splat. Mas voltando ao assunto, vemos como é simples pegar um Array interpolado de chaves e valores e gerar um Hash. Não é tão comum, por outro lado, ter arrays nesse formato. Normalmente temos pelo menos dois arrays de mesma quantidade de elementos, um com chaves e outro com valores, e digamos que queremos gerar um Hash a partir delas. Eis alguns exemplos:

* * *

```ruby

chaves = [:chave_a, :chave_b]  
valores = [“valor a”, “valor b”]

#1. jeito que a maioria começa fazendo: (feio)  
hash = {}  
for i in (1..chaves.size)  
 hash[chaves[i – 1]] = valores[i – 1]  
end  
hash
{:chave_a=>"valor a", :chave_b=>"valor b"}

#1. melhor:  
hash = Hash[chaves.zip(valores)]
{:chave_a=>"valor a", :chave_b=>"valor b"}  
```

Para lembrar da utilidade do método <tt>zip</tt>, literalmente pensem num zíper de uma jaqueta. Além disso, falamos um pouco de coerção via operador splat, o oposto da operação que fizemos acima é o seguinte:

* * *

```ruby
hash = { chave_a: “valor a”, chave_b: “valor b” }  
array = *hash

1. [[:chave_a, “valor a”], [:chave_b, “valor b”]]

array.flatten

1. [:chave_a, “valor a”, :chave_b, “valor b”]  
```

## Arrays e Splat

Recapitulando, vamos esquentar vendo formas diferentes de inicializar o mesmo tipo de Array:

* * *

```ruby
lista = [“foo”, “foo”, “foo”, “foo”, “foo”]
lista = %w(foo foo foo foo foo)
lista = Array.new(5, “foo”)
lista = Array.new(5) { “foo” }
lista = [“foo”] * 5  

# [“foo”, “foo”, “foo”, “foo”, “foo”]  
```

Todos já estiveram numa situação onde cortaram uma string em diversos “tokens” e tiveram que atribuir cada token a uma variável diferente, certo? Vejamos primeiro o exemplo mais ingenuo disso:

* * *

```ruby
texto = “2012 Agosto 26 Hello World”
palavras = texto.split(" ")  # cortando por espaço

# atribuindo por posiçao no array  
ano = palavras[0]
mes = palavras[1]
dia = palavras[2]

# acumulador, uma variável que vai conter todo o “restante”  
lixo = []
i = 3  
 while i < palavras.size
 lixo << palavras[i]
 i += 1
end

 puts lixo.join(", ")  
  #=> “Hello, World”  
```

Novamente, quem veio de outras linguagens provavelmente não achará nada estranho nesse trecho. Vejamos como poderíamos rubificá-lo:

* * *

```ruby
texto = “2012 Agosto 26 Hello World”
palavras = texto.split(" ")

ano, mes, dia, *lixo = palavras

puts lixo.join(", ")  

# “Hello, World”  
```

Pois é, já tínhamos visto que podemos atribuir múltiplas variáveis ao mesmo tempo usando um Array, mas além disso usando um splat podemos pegar aquele “resto do Array” como gostaríamos, tudo de uma só vez.

Outro exemplo para explorar isso, vejamos o seguinte:

* * *

```ruby

def formatar_data(dia, mes, ano)  
 “#{dia}/#{mes}/#{ano}”
end

 args = [27, 8, 2012]  
 formatar_data(args[0],args[1], args[2])  
  #=> 27/8/2012  
```

Temos uma função que recebe 3 parâmetros. Por acaso temos os 3 parâmetros num Array. Em outras linguagens, podemos atribuir parâmetro a parâmetro usando posição do Array. Ou podemos usar o splat para expandir o Array nos parâmetros do método diretamente, assim:

* * *

```ruby
args = [27, 8, 2012]
formatar_data(*args)  

# 27/8/2012 
```

No link sobre splats que passei acima, esse e outros exemplos estão explicados em mais detalhes.

Existe uma situação que muitos já devem ter visto, vejamos:

* * *

```ruby

def algum_metodo(foo, bar, args)  
 args = [args] unless args.is_a? Array  
 args.each do |elem|  
 …  
 end  
end  
```

Não é o melhor exemplo, mas digamos que você acabe com uma variável que possa ser tanto uma string quanto um array e a sequência assume um array (por exemplo, vai iterar nela, como no exemplo), então se só tiver um elemento, primeiro precisa convertar ela num array. Ou podemos usar o splat assim:

* * *

```ruby
def algum_metodo(foo, bar, args)  
 [*args].each do |elem|  
 …  
 end  
end  
```

Se for um elemento só a coerção resulta nele mesmo. Se for um Array, em vez de acabar com um Array dentro de outro Array, a coerção vai expandir os elementos do array <tt>args</tt> dentro do novo array, ou seja, vai dar no mesmo. E o mesmo código vale pra ambos.

## Miscelânea

Já precisaram juntar todos os elementos de um Array num String? Fácil, método <tt>join</tt>, certo? Vejamos:

* * *

  ```ruby

[1, 2, 3, 4, 5].join(", ")

1. “1, 2, 3, 4, 5”

[1, 2, 3, 4, 5] * ", "

1. “1, 2, 3, 4, 5”  
  ```

Finalmente, a última dica, uma coisa que eu eventualmente me esqueço e me lembro de novo:

* * *

```ruby

# numero aleatório, esse é simples  
numero = rand(10_000_000_000)
# 9773914651

# transformar um inteiro base 10 em base 2  
 numero.to_s(2)
# "1001000110100100100001101000011011"

# transformar um inteiro base 10 em base 8  
numero.to\_s(8)  
# => "110644415033"

#. transformar um inteiro base 10 em base 36  
numero.to_s(36)  
#=> "4hn4wt7"
```

E esta é a volta:

* * *

```ruby

#. transformar da base 36 na base 10 de novo  
“4hn4wt7”.to_i(36) #=> 9773914651  
```

Gostaram das dicas? Evitei aqueles mais cabeludos que chegam a ser ilegíveis e mais parecidos com one-liners de Perl :-) Se lembrarem de outros truques de Ruby diferentes, não deixem de colocar nos comentários.
