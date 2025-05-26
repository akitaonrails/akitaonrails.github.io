---
title: "[Objective-C] Brincando com Categorias e Blocos"
date: '2010-11-28T18:58:00-02:00'
slug: objective-c-brincando-com-categorias-e-blocos
tags:
- learning
- beginner
- apple
- objective-c
draft: false
---

Continuando meus estudos com Objective-C, existem algumas funcionalidades que me deixam realmente surpreso. Duas delas são Categorias e Blocos.

Para facilitar, vamos ver um código Ruby para dar um exemplo do que quero fazer:

* * *
ruby

class Array  
 def each\_element  
 for elem in self  
 yield(elem)  
 end  
 end  
end  
-

Sabemos que em Ruby, todas as classes podem ser abertas e extendidas, incluindo classes padrão da linguagem como Array ou String. Isso permite extender a própria linguagem e é o que o pacote ActiveSupport do Rails faz, ao adicionar métodos como <tt>#days</tt> à classe <tt>Fixnum</tt>, permitindo operações como <tt>2.days – 1.day</tt>, por exemplo.

Em linguagens como Java isso não é possível porque as classes são fechadas, e inclusive muitas delas são _finals_ o que impedem criar sub-classes a partir delas. Por exemplo, não se pode criar uma classe herdando de <tt>String</tt>. Isso acaba dando origem a muitas classes acessórias como <tt><a href="http://commons.apache.org/lang/api-2.5/org/apache/commons/lang/StringUtils.html">StringUtils</a></tt>, o que eu acho particularmente não elegante.

No exemplo acima, reabri a classe padrão <tt>Array</tt> do Ruby e fiz minha própria versão do método <tt>each</tt>, que já existe, chamando-o de <tt>each_element</tt> somente com objetivos didáticos para este artigo. Agora podemos pegar um array normal e chamar esse método nele:

* * *
ruby

list = [“a”, “b”, “c”]  
list.each\_element do |elem|  
 puts elem  
end  
-

Mais do que extender classes, o Ruby possui outra funcionalidade muito flexível chamada blocos ou closures/fechamentos (eu já escrevi sobre [blocos e closures](http://rubylearning.com/blog/2007/11/30/akitaonrails-on-anatomy-of-ruby-blocksclosures/) antes pra RubyLearning. Sugiro ler para entender o conceito)

Essas são duas funcionalidades que muitos poderiam imaginar que só seriam possíveis em linguagens altamente dinâmicas como Ruby, Python ou Smalltalk. Já Objective-C é uma extensão da linguagem C, algo considerado por muitos como tão baixo nível que nem se imaginariam ser possível. Será?


## Categorias

O Objective-C tem uma funcionalidade chamada [Categories](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjectiveC/Articles/ocCategories.html%23//apple_ref/doc/uid/TP30001163-CH20-SW1). Essencialmente isso permite “reabrir” classes já existentes e extendê-las com mais métodos.

Na minha interpretação o Obj-C, assim como Ruby, são linguagens orientadas a objeto mas, mais importante, eu diria que elas são **orientadas a protocolo**. Em vez de pensar em interfaces estáticas e “chamar um método” o correto é pensar em “enviar mensagens”. Protocolos definem quais mensagens o objeto sabe responder. A diferença é que você não busca uma coerência em tempo de compilação mas sim em tempo de execução. Você pode mandar mensagens que o objeto não entende se quiser sem receber um erro de compilação.

Uma convenção de nomenclatura que podemos usar é criar o arquivo header e a implementação usando o nome da classe a ser extendida, o símbolo “+”, e o nome da Categoria que queremos implementar. Por exemplo, digamos que eu queira a mesma funcionalidade do método <tt>each</tt> de Array do Ruby no equivalente <tt>NSArray</tt> do Obj-C, podemos fazer assim:

* * *
C

// NSArray+functional.h  
@interface NSArray (functional)

- (void) each:(void (^) (id))block;

@end  
-

E a implementação seria:

* * *
C

// NSArray+functional.m

#import “NSArray+functional.h”

@implementation NSArray (functional)  
- (void) each:(void (^) (id))block {  
 int i;  
 for (i = 0; i \< [self count]; i ++) {  
 block([self objectAtIndex:i]);  
 }  
}  
@end  
-

A sintaxe é exatamente a mesma se estivéssemos definindo uma nova classe, mas neste caso declaramos o mesmo nome da classe que já existe <tt>NSArray</tt> e entre parênteses colocamos o nome da nossa categoria que, neste caso, chamei arbitrariamente de “functional” para ter diversos métodos funcionais.

Categorias não podem ter variáveis de instância entre chaves na declaração da interface, ela só pode comportar novos métodos, por isso falei que não era não flexível, mas isso já seria o bastante.

Essa funcionalidade pode ser usada principalmente para duas coisas: substituir a necessidade de criar sub-classes e, com isso, evitar usar herança sempre que possível e que fizer sentido; e a outra é quebrar classes com implementações muito grande em múltiplos arquivos de forma a melhor organizar os arquivos do projeto.

## Blocos

Como vocês devem ter suspeitado, implementar o método <tt>each</tt> semelhante ao Ruby significa que deveríamos poder usar blocos. E o Obj-C também permite blocos, na forma de métodos anônimos (sem nome).

O parâmetro que implementamos é <tt>(void (^) (id))block</tt>. “block” é o nome da variável que vai receber o bloco. Seu tipo é de retorno “void” e parâmetro “id”. O “^” é o “nome” do bloco, no caso, sem nome algum, ou anônimo. Tendo em mãos o bloco podemos executá-la assim: <tt>block([self objectAtIndex:i])</tt>. O tipo <tt>id</tt> em Obj-C é um tipo genérico que denota um objeto arbitrário. Ele é usado por todo o framework Cocoa e seria, mais ou menos, o equivalente a dizer que o método recebe qualquer tipo de objeto.

E como podemos usar essa nova categoria com o novo método? Vejamos:

* * *
C

#import “NSArray+functional.h”

- (IBAction) foo:(id)sender {   
 NSMutableArray \*list = [NSMutableArray arrayWithObjects:`"a", @"b", @"c", nil];
  NSString *msg = @"elemento: %`";  
 [list each:^(id obj) {  
 NSLog(msg, obj);   
 }];  
}  
-

No caso, faça de conta que estamos numa aplicação de iPhone ou Mac, por isso criei um método que retorna <tt>IBAction</tt>. Para quem não sabe, <tt>IBAction</tt> é a mesma coisa que <tt>void</tt>, ou seja, que o método não retorna nada. A diferença é que o Interface Builder reconhece métodos que retornam <tt>IBAction</tt> como métodos que podem ser ligados diretamente a ações de um elemento visual na tela, por exemplo.

No corpo do método começamos criando um <tt>NSMutableArray</tt>. Fiz isso de propósito porque essa classe herda de <tt>NSArray</tt> e, portanto, também herdará o novo método <tt>each</tt> que implementamos.

Agora a parte importante é como chamamos o método nesse objeto: <tt>[list each:^(id obj) { … }]</tt>. Ou seja, estamos enviando a mensagem <tt>each</tt> ao objeto <tt>list</tt> passando como parâmetro um bloco anônimo “^” que tem parâmetro <tt>id obj</tt>. Se você não conhece blocos de Ruby ou de outra linguagem como Lisp, pode ser difícil entender o que está acontecendo, por isso recomendo novamente ler meu artigo sobre [blocos](http://rubylearning.com/blog/2007/11/30/akitaonrails-on-anatomy-of-ruby-blocksclosures/) antes.

Note que dentro do bloco o <tt>NSLog</tt> está usando a string <tt>msg</tt> que foi criada fora do bloco, exatamente como eu poderia fazer em Ruby, o bloco tem conhecimento do ambiente ao seu redor e eu posso usar variáveis criadas fora do bloco. Isso é uma das coisas que torna essa funcionalidade de blocos diferente de um simples “delegate” ou simplesmente passar um ponteiro de uma função.

Em Ruby, eu posso capturar um bloco em uma variável, assim:

* * *
ruby

bloco = lambda { |a| puts a }  
bloco.call(“bla”)

1. =\> “bla”  
-

No exemplo acima, criamos um bloco e em seguida executamos esse bloco usando o método <tt>call</tt>. Em Obj-C podemos fazer algo similar assim:

* * *
C

void (^bloco)(NSString\*) = ^(NSString\* msg) {  
 NSLog(msg);  
};  
bloco(@"bla");  
-

Veja que é muito parecido só que precisamos declarar os tipos. Na primeira linha definimos uma variável do tipo bloco, com o nome de “bloco” (o nome vem logo depois do “^”). Antes do nome temos o tipo de retorno, <tt>void</tt>, e depois o tipo do parâmetro que ele aceita, ponteiro de <tt>NSString</tt>. Daí criamos o bloco propriamente dito.

Em seguida basta chamar o bloco como se fosse uma função normal de C, usando a notação de passar parâmetros entre parênteses.

## Conclusão

Categorias e Blocos podem ajudar muito a tornar a programação em Obj-C mais flexível e mais próxima dos conceitos de linguagens mais dinâmicas como Ruby. Como exercício que tal completar a minha Categoria <tt>NSArray+functional.h</tt> e acrescentar métodos como <tt>select</tt>, <tt>map</tt>, <tt>sort</tt>, etc? Coloquem links para [Gist](http://gist.github.com) nos comentários com sugestões de implementação.

Para aprender mais sobre blocos, recomendo ler:

- [Using Blocks in iOS 4: The Basics](http://pragmaticstudio.com/blog/2010/7/28/ios4-blocks-1)
- [Using Blocks in iOS 4: Designing with Blocks](http://pragmaticstudio.com/blog/2010/9/15/ios4-blocks-2)

