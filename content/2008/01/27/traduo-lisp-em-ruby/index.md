---
title: 'Tradução: Lisp em Ruby'
date: '2008-01-27T05:42:00-02:00'
slug: traduo-lisp-em-ruby
tags:
- learning
- beginner
- ruby
- lisp
draft: false
---

Cá estou eu, trabalhando no meio da madrugada, quando apareceu [este post](http://onestepback.org/index.cgi/Tech/Ruby/LispInRuby.red) de ninguém menos que Jim Weirich. Ele literalmente implementou um pequeno interpretador de Lisp … em Ruby!! Achei o feito tão interessante que resolvi traduzir o post para os interessados. Vamos lá:

### Manual do Programador de Lisp 1.5

Eu esbarrei [nisto](http://bc.tech.coop/blog/080101.html) no blog do Bill Clementson e lembrei de usar o manual do programador de Lisp 1.5 na época da faculdade. Tenho fortes memórias dessa página em particular no manual e eu tentando entender suas nuances.

Se você nunca leu o Manual do Programador de Lisp 1.5, a página 13 é a entranha de um interpretador Lisp, as funções “eval” e “apply”. É escrito em Lisp, embora a notação usada seja um pouco estranha. O interpretador inteiro (menos duas funções utilitárias) é apresentado em uma única página do livro. Isso que é definição concisa de linguagem!

### Em Ruby?

Eu frequentemente penso sobre implementar um interpretador Lisp, mas antigamente, o pensamento de implementar um garbage collector e todo o runtime era um pouco demais. Isso foi numa época antes do C, então minha linguagem de implementação teria sido assembler … eca.

Mas enquanto eu revia a página, percebi que com as linguagens modernas de hoje eu provavelmente poderia simplesmente converter as estranhas Expressões-M usadas na página 13 diretamente em código. Então … por que não?

### O Código

Aqui vai o código fonte completo em Ruby do interpretador Lisp da página 13 do manual do programador de Lisp:

* * *

```ruby
class Object  
 def lisp_string  
 to_s  
 end  
end

class NilClass  
 def lisp_string  
 “nil”   
 end  
end

class Array

#1. Convert an Array into an S-expression
#2. (i.e. linked list).
#3. Subarrays are converted as well.  
 def sexp  
 result = nil  
 reverse.each do |item|  
 item = item.sexp if item.respond_to?(:sexp)  
 result = cons(item, result)  
 end  
 result  
 end  
end

#1. The Basic Lisp Cons cell data structures.
#2. Cons cells consist of a head and a tail.  
class Cons  
 attr_reader :head, :tail

def initialize(head, tail) @head, @tail = head, tail end def (other) return false unless other.class Cons return true if self.object_id other.object_id return car(self) car(other) && cdr(self) == cdr(other) end

#1. Convert the lisp expression to a string.  
 def lisp_string  
 e = self  
 result = “(”
 while e  
 if e.class != Cons  
 result << ”. ” << e.lisp_string  
 e = nil  
 else  
 result << car(e).lisp_string  
 e = cdr(e)  
 result << ” ” if e  
 end  
 end  
 result << “)”
 result  
 end  
end

#1. Lisp Primitive Functions.

#1. It is an atom if it is not a cons cell.  
def atom?(a)  
 a.class != Cons  
end

#1. Get the head of a list.  
def car(e)  
 e.head  
end

#1. Get the tail of a list.  
def cdr(e)  
 e.tail  
end

#1. Construct a new list from a head and a tail.  
def cons(h,t)  
 Cons.new(h,t)  
end

#1. Here is the guts of the Lisp interpreter.
#2. Apply and eval work together to interpret
#3. the S-expression. These definitions are taken
#4. directly from page 13 of the Lisp 1.5
#5. Programmer’s Manual.

def apply(fn, x, a)  
 if atom?(fn)  
 case fn  
 when :car then caar(x)  
 when :cdr then cdar(x)  
 when :cons then cons(car(x), cadr(x))  
 when :atom then atom?(car(x))  
 when :eq then car(x) cadr(x)  
 else  
 apply(eval(fn,a), x, a)  
 end  
 elsif car(fn) :lambda  
 eval(caddr(fn), pairlis(cadr(fn), x, a))  
 elsif car(fn) :label  
 apply(caddr(fn), x,
 cons(cons(cadr(fn), caddr(fn)), a))  
 end  
end

def eval(e,a)  
 if atom?(e)  
 cdr(assoc(e,a))  
 elsif atom?(car(e))  
 if car(e) :quote  
 cadr(e)  
 elsif car(e) :cond  
 evcon(cdr(e),a)  
 else  
 apply(car(e), evlis(cdr(e), a), a)  
 end  
 else  
 apply(car(e), evlis(cdr(e), a), a)  
 end  
end

#1. And now some utility functions used
#2. by apply and eval. These are
#3. also given in the Lisp 1.5
#4. Programmer’s Manual.

def evcon(c,a)  
 if eval(caar©, a)  
 eval(cadar©, a)  
 else  
 evcon(cdr©, a)  
 end  
end

def evlis(m, a)  
 if m.nil?  
 nil  
 else  
 cons(eval(car(m),a), evlis(cdr(m), a))  
 end  
end

def assoc(a, e)  
 if e.nil?  
 fail “#{a.inspect} not bound”
 elsif a caar(e)  
 car(e)  
 else  
 assoc(a, cdr(e))  
 end  
end

def pairlis(vars, vals, a)  
 while vars && vals  
 a = cons(cons(car(vars), car(vals)), a)  
 vars = cdr(vars)  
 vals = cdr(vals)  
 end  
 a  
end

#1. Handy lisp utility functions built on car and cdr.

def caar(e)  
 car(car(e))  
end

def cadr(e)  
 car(cdr(e))  
end

def caddr(e)  
 car(cdr(cdr(e)))  
end

def cdar(e)  
 cdr(car(e))  
end

def cadar(e)  
 car(cdr(car(e)))  
end  
```

### O Exemplo

E para provar, aqui vai um exemplo de programa em Lisp. Eu não me incomodei em escrever um parser de Lisp, então preciso escrever as listas em notação de Array padrão de Ruby (que é convertido em uma lista ligada via o método ‘sexp’).

Aqui vai o programa ruby usando o interpretador Lisp. O sistema Lisp é muito primitivo. A única maneira de definir uma função necessária é colocá-la em uma estrutura de ambiente, que é simplesmente uma lista de associação de chaves e valores.

* * *

```ruby

require ‘lisp’

#1. Create an environment where
#2. the reverse, rev_shift and null
#3. functions are bound to an
#4. appropriate identifier.

env = [  
 cons(:rev_shift,  
 [:lambda, [:list, :result],  
 [:cond,  
 [[:null, :list], :result],  
 [:t, [:rev_shift, [:cdr, :list],  
 [:cons, [:car, :list], :result]]]]].sexp),  
 cons(:reverse,  
 [:lambda, [:list], [:rev_shift, :list, nil]].sexp),  
 cons(:null, [:lambda, [:e], [:eq, :e, nil]].sexp),  
 cons(:t, true),
 cons(nil, nil)  
].sexp

#1. Evaluate an S-Expression and print the result

exp = [:reverse, [:quote, [:a, :b, :c, :d, :e]]].sexp

puts “EVAL: #{exp.lisp_string}”
puts " =\> #{eval(exp,env).lisp_string}"  
```

O programa imprime:

<p>$ ruby reverse.rb<br>
<span class="caps">EVAL</span>:

```ruby
  (reverse (quote (a b c d e)))<br>
  => (e d c b a)<br>
```

<p>Tudo que preciso fazer é escrever um parser Lisp e um <span class="caps">REPL</span>, e pronto!</p>
<h3>O Exemplo em Notação Padrão Lisp</h3>
<p>Se achou o código Lisp “rubizado” difícil de ler, aqui vai a função reversa escrita em uma maneira mais “lispeira”:</p>
<hr>

```lisp
(defun reverse (list)
  (rev-shift list nil))
(defun rev-shift (list result)
  (cond ((null list) result)
        (t (rev-shift (cdr list) (cons (car list) result))) ))
```
