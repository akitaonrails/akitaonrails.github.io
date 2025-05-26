---
title: "[Tradução] Metaprogramação em Ruby: é tudo sobre Self"
date: '2009-11-16T14:56:00-02:00'
slug: traducao-metaprogramacao-em-ruby-e-tudo-sobre-self
tags:
- learning
- beginner
- ruby
- translation
draft: false
---

Hoje o [Yehuda Katz](http://yehudakatz.com/2009/11/15/metaprogramming-in-ruby-its-all-about-the-self/) publicou um artigo muito didático sobre metaprogramação em Ruby que achei legal traduzir. Aí vai:

Depois de escrever [meu último post](http://yehudakatz.com/2009/11/12/better-ruby-idioms/) sobre idiomas de plugins Rails, eu percebi que metaprogramação Ruby, no fundo, é na realidade bem simples.


Tem a ver com o fato de que todo código Ruby é executado – não há separação entre fases de compilação e runtime, cada linha de código é executado contra um _self_ particular. Considere os próximos 5 trechos de código:

* * *
ruby

class Person  
 def self.species  
 “Homo Sapien”  
 end  
end

class Person  
 class \<\< self  
 def species  
 “Homo Sapien”  
 end  
 end  
end

class \<\< Person  
 def species  
 “Homo Sapien”  
 end  
end

Person.instance\_eval do  
 def species  
 “Homo Sapien”  
 end  
end

def Person.species  
 “Homo Sapien”  
end  
-

Todos os 5 trechos definem um `Person.species` que retornam `Homo Sapiens`. Agora considere outro conjunto de trechos:

* * *
ruby

class Person  
 def name  
 “Matz”  
 end  
end

Person.class\_eval do  
 def name  
 “Matz”  
 end  
end  
-

Todos esses trechos definem um método chamado `name` na classe Person. Então `Person.new` retornará “Matz”. Para aqueles familiarizados com Ruby, isso não é novidade. Quando se aprende sobre metaprogramação, cada um desses trechos é apresentado de forma isolada: outro mecanismo para colocar métodos onde eles “pertencem”. Na verdade, entretanto, existe uma única explicação unificada de porque todos esses trechos de cóigo funcionam da forma como funcionam.

Primeiro, é importante entender como a metaclasse de Ruby funciona. Quando você aprende Ruby, você aprende sobre o conceito de classe, e que cada objeto de Ruby tem um:

* * *
ruby

class Person  
end

Person.class #=\> Class

class Class  
 def loud\_name  
 “#{name.upcase}!”  
 end  
end

Person.loud\_name #=\> “PERSON!”  
-

`Person` é uma instância de `Class`, então qualquer método adicionado a `Class` está disponível em `Person` também. O que não lhes é dito, entretanto, é que cada objeto em Ruby também tem seu próprio **metaclass** , uma `Class` que pode ter métodos, mas está anexado apenas ao objeto.

* * *
ruby

matz = Object.new  
def matz.speak  
 “Place your burden to machine’s shoulders”  
end  
-

O que está acontecendo é que estamos adicionando o método `speak` à **metaclass** de `matz`, e o objeto `matz` herda de sua **metaclass** e depois de `Object`. A razão de porque isso não é tão claro é porque o metaclass é invisível em Ruby:

* * *
ruby

matz = Object.new  
def matz.speak  
 “Place your burden to machine’s shoulders”  
end

matz.class #=\> Object  
-

Na verdade, a “classe” de `matz` é sua metaclass invisível. Podemos ter acesso a essa metaclass assim:

* * *
ruby

metaclass = class \<\< matz; self; end  
metaclass.instance\_methods.grep(/speak/) #=\> [“speak”]  
-

Até este ponto, você provavelmente está tendo que se esforçar para ter tantos detalhes na cabeça; parece que existem regras demais. E que diabos é isso de `class << matz`?

Acontece que todas essas regras esquisitas se resumem em um conceito simples: controle sobre o `self` em uma determinada parte do código. Vamos retornar à um dos trechos que já vimos antes:

* * *
ruby

class Person  
 def name  
 “Matz”  
 end

self.name #=\> “Person”

end  
-

Aqui, estamos adicionando o método `nome` à classe `Person`. Quando dizemos `class Person`, o `self` até o fim do bloco é a própria classe `Person`.

* * *
ruby

Person.class\_eval do  
 def name  
 “Matz”  
 end

self.name #=\> “Person”

end  
-

Aqui, estamos fazendo exatamente a mesma coisa: adicionando o método `name` a instâncias da classe Person. Neste caso, `class_eval` deixa o `self` ser o `Person` até o fim do bloco. Isso é perfeitamento direto quando se lida com classes, e igualmente direto quando se lida com metaclasses:

* * *
ruby

def Person.species  
 “Homo Sapien”  
end

Person.name #=\> “Person”  
-

Como no exemplo do `matz` anteriormente, estamos definindo o método `species` à metaclass de `Person`. Nós não manipulamos `self`, mas você pode ver o uso de `def` num objeto anexa o método à metaclass desse objeto.

* * *
ruby

class Person  
 def self.species  
 “Homo Sapien”  
 end

self.name #=\> “Person”

end  
-

Aqui, abrimos a classe `Person`, fazendo o `self` ser `Person` pela duração do bloco, como no exemplo acima. Entretanto, estamos definindo um método à metaclasse de `Person` aqui, já que estamos definindo o método em um objeto (`self`). Você também pode ver que `self.name` enquanto dentro da classe Person é idêntico a `Person.name` enquanto fora dela.

* * *
ruby

class \<\< Person  
 def species  
 “Homo Sapien”  
 end

self.name #=\> ""

end  
-

Ruby dá uma sintaxe para acessar a metaclass de um objeto diretamente. Fazendo `class << Person`, estamos fazendo o `self` ser a metaclass de `Person` pela duração do bloco. Como resultado, o método `species` é adicionado à metaclass de `Person`, em vez da classe propriamente dita.

* * *
ruby

class Person  
 class \<\< self  
 def species  
 “Homo Sapien”  
 end

self.name #=\> "" end

end  
-

Aqui, combinamos diversas técnicas. Primeiro, abrimos `Person`, tornando `self` igual à classe `Person`. Em seguida, fazemos `class << self`, tornando `self` igual à metaclass de `Person`. Quando definimos o método `species`, ela é definida na metaclass de `Person`.

* * *
ruby

Person.instance\_eval do  
 def species  
 “Homo Sapien”  
 end

self.name #=\> “Person”

end  
-

O último caso, `instance_eval` na realidade faz algo interessante. Ela quebra o `self` no `self` que é usado para executar métodos e o `self` que é usado quando novos métodos são definidos. Quando `instance_eval` é usado, novos métodos são definidos na **metaclass** , mas o `self` é o próprio objeto.

Em alguns desses casos, as múltiplas formas de atingir a mesma coisa sai naturalmente da semântica de Ruby. Depois desta explicação, deve ficar claro que `def Person.species`, `class << Person; def species,` e `class Person; class << self; def species` não são três maneiras de fazer a mesma coisa que nasceram juntas, mas elas acabam saindo da própria flexibilidade do Ruby em relação a o que o `self` é em determinado ponto do seu programa.

Por outro lado, `class_eval` é um pouco diferente. Porque ele recebe um bloco, em vez de agir como uma palavra-reservada, ela captura as variáveis locais ao redor dela. Isso fornece a possibilidade poderosas capacidades de DSLs, em adição a controlar o `self` usado em um bloco de código. Mas além disso, ele é idêntico às outras construções aqui.

Finalmente, `instance_eval` quebra o `self` em duas partes, ao mesmo tempo que dá acesso a variáveis definidas fora dela.  
Na tabela a seguir, _define um novo escopo_ significa que código dentro do bloco **não** tem acesso a variáveis locais fora do bloco.

| **mecanismo** | **método de resolução** | **definição de método** | **novo escopo?** |
| **class Person** | Person | mesmo | sim |
| **class \<\< Person** | metaclass do Person | mesmo | sim |
| **Person.class\_eval** | Person | mesmo | não |
| **Person.instance\_eval** | Person | metaclass do Person | não |

Também note que `class_eval` está apenas disponível a `Modules` (note que Class herda de Module) e é um sinônimo para `module_eval`. Além disso, `instance_exec`, que foi adicionado ao Ruby 1.8.7, funciona exatamente como `instance_eval`, exceto que ele também lhe permite enviar variáveis a um bloco.

