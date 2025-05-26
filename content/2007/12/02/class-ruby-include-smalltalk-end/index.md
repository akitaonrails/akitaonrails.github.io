---
title: class Ruby; include Smalltalk; end
date: '2007-12-02T15:15:00-02:00'
slug: class-ruby-include-smalltalk-end
tags:
- learning
- beginner
- ruby
- smalltalk
draft: false
---



Não, não! Não é mais um daqueles artigos “Ruby vs Smalltalk”. Estava hoje lendo um fórum e caí nesse dilema novamente. Quando se fala que Smalltalk é _mais_ orientado a objetos que Ruby o exemplo mais usado é que em Ruby fazemos condicionais de maneira imperativa (uma das maneiras):

* * *
ruby

a = if expression  
 1  
else  
 2  
end  
-

E em Smalltalk se faz passando mensagens ao objeto True ou False:

<macro:code>
<p>expression ifTrue:[a := 1] ifFalse:[a := 2]<br>
<del>-</del></p>
<p>Onde ifTrue e ifFalse são representados como se fossem ‘envio de mensagens’ ao objeto true ou false. A primeira diferença é que se o objeto não for true ou false isso normalmente pode dar uma exception do tipo MustBeBoolean. Em Ruby tudo é true e apenas os objetos ‘nil’ e ‘false’ são considerados ‘não-true’.</p>
<p>Outra coisa é que em Smalltalk podemos enviar várias mensagens ao mesmo objeto de uma só vez, em Ruby o método precisa devolver a si mesmo para encadear mensagens, mas fica parecido.</p>
<p>Então, e se em Ruby pudéssemos fazer assim:</p>
<hr>
ruby
<p>expression.if_true { a = 1 }.if_false { a = 2 }<br>
<del>-</del></p>
<p>Hm, acontece que podemos! Vejamos como ficaria isso:</p>
<hr>
ruby
<p>class Object<br>
  def if_true(&amp;block)<br>
    block.call if self<br>
    self<br>
  end</p>
def if_false(&amp;block)
block.call unless self
self
end
<p>end<br>
<del>-</del></p>
<p>Podemos fazer isso graças aos blocos, que expliquei em detalhes no <a href="http://www.akitaonrails.com/2007/11/30/anatomia-de-ruby-blocks-closures">artigo anterior</a>. Além disso já sabemos que todas as classes no Ruby são abertas, em especial a Object que é a pai de todas. Nesse caso todas as classes do Ruby passam a ter esta funcionalidade, não apenas TrueClass ou FalseClass.</p>
<p>Vejamos como ficaria com a notação de do..end em vez de chaves:</p>
<hr>
ruby
<p>expression.if_true do<br>
  a = 1<br>
end.if_false do<br>
  a = 2<br>
end<br>
<del>-</del></p>
<p>Feinha. </p>
<p>Isso é apenas um exercício de metaprogramação no Ruby porque esta implementação não tem absolutamente nenhuma vantagem sobre a notação nativa de if; else; end. Como apontado em inúmeras discussões a respeito como <a href="http://www.sagewire.org/ruby-programming/If-like-smalltalk-201523.aspx">esta</a> a notação imperativa atual do Ruby não é ambígua e o interpretador não precisa trabalhar dispatch de métodos. Em <a href="http://talklikeaduck.denhaven2.com/articles/2006/10/10/boolean-implementations-ruby-smalltak-and-self">algumas</a> implementações de Smalltalk ifTrue;ifFalse é mais um syntatic sugar porque internamente eles também não fazem dispatching de métodos e fazem o branch condicional normal. Motivo: performance.</p>
<p>Existe outra diferença, em Ruby e Smalltalk podemos enviar múltiplos blocos a um mesmo método, mas Smalltalk tem uma sintaxe mais simples para isso, como é o caso do próprio ifTrue;ifFalse. No fundo o efeito é o mesmo. Se eu quiser muito mesmo posso não usar o ‘if’ imperativo do Ruby, mas não há nenhum ganho ao fazer isso. O Ruby poderia colocar um ‘syntatic sugar’ semelhante que permitisse usar a notação ‘puramente de objetos’ mas que internamente reconvertesse num if imperativo para não impactar a performance.</p>
<p>Outra coisa que Ruby faz de maneira ‘imperativa’: herança de classes. Em Ruby fazemos assim:</p>
<hr>
ruby
<p>class Carro &lt; Veiculo<br>
end<br>
<del>-</del></p>
<p>Em Smalltalk (sem usar a <span class="caps">IDE</span>) se faz:</p>
<macro:code>
<p>Veiculo subclass: #Carro<br>
<del>-</del></p>
<p>Ok, ok, se realmente quisermos fazer assim em Ruby podemos usar mais metaprogramação:</p>
<hr>
ruby
<p>class Object<br>
  def self.subclass name<br>
    eval “class #{name} &lt; #{self}; end”<br>
  end<br>
end</p>
<p>Veiculo.subclass :Carro<br>
<del>-</del></p>
<p>Pronto, conceitualmente parecido novamente. As características de metaprogramação de Ruby nos permitem criar praticamente qualquer nova sintaxe e é o motivo dele ser uma linguagem tão poderoda para Domain Specific Languages (<span class="caps">DSL</span>). E nunca se esqueçam da maior diferença: Smalltalk não é apenas uma linguagem, é um ambiente, coisa que Ruby não é e não planeja ser. Então não se trata apenas de sintaxe, são filosofias completamente diferente de programação que vai além de simples ‘ser <span class="caps">OOP</span>’ ou não.</p>
<p>No fundo, tanto faz, pessoalmente prefiro algo pragmático do que apenas ‘intelectualmente puro’, e nesse caso tanto Ruby quanto Smalltalk se encaixam, pois ambos fazem compromissos em alguma das etapas. Existem mais alguns <a href="http://c2.com/cgi/wiki?RubyIsSmalltalkMinusMinus">Ruby vs Smalltalk</a> interessantes, mas não os leve muito a sério a menos que você pretenda se engajar na tarefa de ajudar a codificar o compilador do Ruby. Caso contrário <em>whatever</em>.</p>
<p><strong>Update:</strong> Na realidade, para ficar um pouco mais parecido com o jeito Smalltalk de passar dois blocos ne mesma mensagem, a versão Ruby deveria ser parecida com esta:</p>
<hr>
ruby
<p>class Object<br>
  def if(true_block = nil, false_block = nil)<br>
    if self<br>
      true_block.call if true_block<br>
    else<br>
      false_block.call if false_block<br>
    end<br>
  end<br>
end</p>
<p>n = 10<br>
puts ( n &gt; 1 ).if( proc { “true” }, proc { “false” } )<br>
<del>-</del></p>
<p>Novamente, a performance decai. Comparei os tempos de 500 mil operações, na primeira vez com ‘if’ condicional e nesta versão via passagem de método e a diferença foi de 2 a 4 vezes mais devagar passando como métodos, portanto não se atenham a essas versões exóticas além de apenas servir como curiosidade acadêmica.</p></macro:code></macro:code>
