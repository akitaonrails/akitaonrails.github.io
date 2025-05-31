---
title: Cuidado com suas Closures
date: '2007-12-21T14:52:00-02:00'
slug: cuidado-com-suas-closures
tags:
- learning
- beginner
- ruby
draft: false
---

Recentemente eu [escrevi um artigo](http://www.akitaonrails.com/2007/11/30/anatomia-de-ruby-blocks-closures) explicando como funcionam os blocos/fechamentos em Ruby. É um recurso muito poderoso de algumas linguagens dinâmicas como Ruby.

Porém todo recurso poderoso deve ser usado com algum cuidado. E nesse caso é a utilização excessiva em casos que podem levar a alguns problemas. Mas não se preocupem, não é algo que deve afetar a grande maioria das aplicações. De qualquer forma vale a pena entender a mecânica de blocos conforme explicado por [Ola Bini](http://ola-bini.blogspot.com/2007/12/ruby-closures-and-memory-usage.html) que, aliás, recomendo muito a leitura de seu blog que trás muitos _behind-the-scenes_ das mecânicas de Ruby.

Vamos à tradução:

Você já deve ter visto a tendência – venho gastando tempo olhando para uso de memória em situações com grandes aplicações. Em especial, as coisas que tenho olhado são na maioria sobre instalações onde um grande número de runtimes JRuby são necessários – mas não deixe isso o assustar. Essa informação é exatamente válida para Ruby normal quanto JRuby.

Uma das coisas que podem realmente causar alto uso de memória de forma não intencional em programas Ruby são blocos que vivem demais e que fecham sobre coisas que você não pretendia. Lembre-se, um fechamento (closure) de fato precisa fechar sobre todas as variáveis, os blocos ao redor e também o self no momento.

Digamos que você tenha um objeto de algum tupo que tem um método que retorna um Proc. Esse proc será salvo em algum lugar e viverá por um longo período – talvez até se tornando um método com o define\_method:

* * *

```ruby

class Factory  
 def create_something  
 proc { puts “Hello World” }  
 end  
end

block = Factory.new.create_something  
```

Note que este bloco não se importa com o ambiente em que é criado. Mas enquanto a variável do bloco estiver viva, ou alguma outra coisa apontar para a mesma instância de Proc, a instância de Factory continuará viva. Pense numa situação onde você tem uma instância ActiveRecord de algum tipo que retorna um Proc. Não é uma situação incomum em aplicações médias ou grandes. Mas um efeito colateral será que todas as variáveis de instância (e objetos ActiveRecord costumam ter alguns) e variáveis locais nunca desaparecerão. Não importa o que você faça no bloco. Agora, da forma como eu vejo, existem três diferentes tipos de blocos em código Ruby:

1. Blocos que processam alguma coisa sem necessidade de acessar variáveis externas. (Coisas como [1,2,3,4,5].select {|n| n%2 == 0} não precisam de fechamento nenhum)

1. Blocos que processam ou fazem alguma coisa baseadas em variáveis vivas.

1. Blocos que precisam modificar variáveis externas.

O interessante é que 1 e 2 são muito mais comuns do que 3. Eu imaginaria que isso é porque 3 é realmente um design ruim em muitos casos. Existem situações em que isso é realmente útil, mas dá para ir bem longe apenas com as duas primeiras alternativas.

Então, se você está se vendo usando blocos que vivem demais e que podem vazar memória (memory leak), considere isolar a criação delas no menor escopo possível. A melhor maneira de fazer isso é algo assim:

* * *

```ruby

o = Object.new

class << o  
 def create_something  
 proc { puts “Hello World” }  
 end  
end

block = o.create_something  
```

Obviamente, isso é demais se você não sabe se o bloco vai viver muito ou não e se vai capturar coisas que não deveria. A maneira que isso funciona é simples – apenas defina uma instância nova e limpa de Object, defina um método singleton nessa instância, e use esse método singleton para criar o bloco. A únicas coisa que será capturada é a instância “o”. Já que “o” não tem nenhuma variável de instância isso funciona, e a única variável local capturada será aquela no escopo do método create\_something – que nesse caso não tem nenhuma.

Claro, se você realmente precisa de valores de fora, pode ser seletivo e apenas colocar no escopo os valores que precisa – a menos que precise modificá-las, claro:

* * *

```ruby

o = Object.new

class << o  
 def create_something(v, v2)  
 proc { puts “#{v} #{v2}” }  
 end  
end

v = “hello”  
v2 = “world”  
v3 = “foobar” # não será capturada pelo bloco

block = o.create_something(v, v2)  
```

Nesse caso, somente “v” e “v2” estarão disponíveis para o bloco, através do uso de argumentos regulares de método.

Esse jeito de definir blocos é meio barra pesada, mas absolutamente necessária em alguns casos. Também é a melhor maneira de conseguir uma amarração de campo limpo, se precisar. De fato, para conseguir um campo limpo, você também precisa remover todos os métodos do Object da instância “o”, e o ActiveSupport tem uma biblioteca para campos limpos. Mas essa é a idéia por trás disso.

Pode parecer estupidez se preocupar com memória nos nossos dias, mas uso alto de memória é um dos preços que pagamos por linguagens com maior nível de abstração. Mas é perda de tempo ir muito longe disso.
