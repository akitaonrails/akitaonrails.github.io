---
title: "[Tradução] Três Contextos Implícitos em Ruby"
date: '2009-11-16T15:28:00-02:00'
slug: traducao-tres-contextos-implicitos-em-ruby
tags:
- learning
- beginner
- ruby
- translation
draft: false
---

[Tradução] Três Contextos Implícitos em Ruby

A desenvolvedora japonês **@yugui** [escreveu um grande complemento](http://yugui.jp/articles/846) ao artigo anterior sobre metaprogramação do Yehuda, que traduzo logo abaixo:

Yehuda Katz escreveu [um artigo sobre `self` e metaclass](http://www.akitaonrails.com/2009/11/16/traducao-metaprogramacao-em-ruby-e-tudo-sobre-self). Nesse artigo ele disse que `Person.instance_eval` associa a **metaclass de Person** para `self` para uma classe `Person`, mas isso é obviamente errado.


* * *
ruby

class Person; end   
Person.instance\_eval{ p self } #=\> Person  
-

Como mencionei em um [artigo antigo](http://yugui.jp/articles/558), embora eu deva me desculpar por estar escrito em japonês, Ruby sempre tem 3 contextos implícitos: self, o chamado ‘klass’ e o ponto constante de definição. Yehuda está confundindo _self_ com ‘klass’.

## self

`self` é o `self` que você conhece. É o receptor padrão de invocação de método. Sempre existe um `self`.

* * *
ruby

p self # mostra “main”

class Foo   
 def bar(a = (p self)) end   
end   
foo = Foo.new   
foo.bar # mostra “#<foo:0x471004>”</foo:0x471004>

class Foo   
 class Baz \< (p self; self) # mostra “Foo”   
 end   
end  
-

No nível superior, uma instância especial de `Object` chamada “main” é o self. Onde quer que esteja, você pode recuperar o self a partir da pseudovariável `self`.

Se você invocar um método sem explicitar um receptor, `self` receberá essa invocação.

## o chamado ‘klass’

Eu chamei o conceito de ‘klass’ no artigo antigo, mas não sei se é o melhor nome. É a classe padrão sobre o qual o método é definido. Agora gostaria de chamá-lo “definidor padrão”.

Ruby sempre segura a referência a uma classe assim como ao `self`. Mas não há maneira de recuperá-lo diretamente. É mais implícito que `self`. Se você definir um método sem dar um receptor específico, em outras palavras, se definir um método com o jeito sintático normal de definir métodos, o definidor padrão terá o método como um método de instância.

### Exemplos:

No nível superior, `Object` é a classe. Então funções globais são igualmente métodos de instância na classe `Object` como você já sabe.

* * *
ruby

def hoge; end   
Kernel.instance\_method(:hoge) #=\> #\<UnboundMethod: Object#hoge\>  
-

Aliás, “hoge”, “fuga”, “piyo” é japonês para “foo”, “bar”, “baz”.

A sintaxe `class` muda ambos os `self` e o definidor padrão para a classe que está agora sendo definida.

* * *
ruby

class T   
 def hoge; end   
end   
T.instance\_method(:hoge) #=\> #\<UnboundMethod: T#hoge\>  
-

Em um corpo normal de método, `self` é o receptor de invocação de métodos e o definidor padrão é a classe sintaticamente fora dela, agora ela é `T`.

* * *
ruby

class T   
 def hoge   
 def fuga; end   
 end   
end   
t = T.new   
t.hoge   
t.method(:fuga) #=\> #\<Method: T#fuga\>   
T.instance\_method(:fuga) #=\> #\<UnboundMethod: T#fuga\>  
-

Não confunda isso com `def self.fuga`, uma definição de método singleton. Quando você dá uma definição de método a um receptor, o método será adicionado à eigenclass do receiver.

<script src="http://gist.github.com/236302.js"></script>

U não tem um método de instância chamado `fuga` porque `fuga` é um método singleton de `u`.

Onde quer que esteja, existe um definidor padrão. Quando executa um valor padrão, o definidor padrão é a classe externa assim como no corpo do método.

<script src="http://gist.github.com/236303.js"></script>

Em outras palavras, a definição `class` muda o definidor padrão mas não a definição de método.

## família eval

O que o `instance_eval` faz é:

- mudar o `self` para o receptor do `instance_eval`
- mudar o definidor padrão para o eigenclass do receptor
- se o receptor não tiver um eigenclass ainda, cria um.
- executa o bloco dado

* * *
ruby

o = Object.new   
o.instance\_eval do   
 p self #=\> #<object:0x454f24> <br>
  def hoge; end <br>
end <br>
o.method(:hoge) #=&gt; #&lt;Method: #<object:0x454f24>.hoge&gt; <br>
Object.instance_method(:hoge) # raises a NameError “undefined method `hoge’ for class `Object’”<br>
<del>-</del></object:0x454f24></object:0x454f24>

Vamos lá:

<script src="http://gist.github.com/236305.js"></script>

Como o `instance_eval` muda o definidor padrão do eigenclass para `$o`, então `fuga` e `piyo` serão métodos singleton de `$o`

Oops, esqueci de mencionar que:

* * *
ruby

RUBY\_VERSION #=\> “1.9.1”.   
-

Ruby 1.8 age de maneira mais léxica, então você acabará tendo o contrário:

* * *
ruby

$o.method(:fuga) # raises a NameError   
$o.method(:piyo) # raises a NameError   
T.instance\_method(:fuga) #=\> #\<UnboundMethod: T#fuga\>   
T.instance\_method(:piyo) #=\> #\<UnboundMethod: T#piyo\>  
-

Em Ruby 1.8, o definidor padrão no corpo do método é baseado lexicamente na definição da classe externa. De qualquer forma, tanto no Ruby 1.8 quanto 1.9, `instance_eval` muda `self` para o receptor, o definidor padrão a seu eigenclass.

Finalmente, `class_eval` muda ambos `self` e o definidor padrão para o receptor:

| | **self** | **definidor padrão** |
| class\_eval | o receptor | o receptor |
| instance\_eval | o receptor | eigenclass do receptor |

No meu [artigo antigo](http://yugui.jp/articles/558) eu discuti sobre `Kernel#eval` e `instance_eval/class_eval` com execução de Strings.

## definição de constantes

Quando você vê uma variável de instância, ela é uma variável da instância de `self`. Quando você usa uma variável de classe, ela é uma variável de classe da classe de `self`; ou o próprio `self` quando `self` é uma classe.

Mas constantes se comportam de maneira diferente. É outro contexto implícito de Ruby. O Ruby Core Team chama esse conceito de “cref”.

Discutiremos esse conceito de “cref” em outro artigo.

