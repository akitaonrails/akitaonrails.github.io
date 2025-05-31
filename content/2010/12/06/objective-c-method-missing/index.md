---
title: "[Objective-C] Method Missing!"
date: '2010-12-06T02:55:00-02:00'
slug: objective-c-method-missing
tags:
- learning
- beginner
- apple
- objective-c
draft: false
---

 **Obs:** Código disponível no [Github](https://github.com/akitaonrails/ObjC_XmlBuilder)

Uma das funcionalidades mais interessantes do Ruby é sem dúvida o famoso <tt>method_missing</tt>. Graças a ele podemos enviar mensagens arbitrárias a um objeto e ainda assim fazer com que responda como queremos. Por exemplo, o seguinte código dará uma exceção:

* * *

```ruby

> obj = Object.new  
 => #<object:0x0000010092ac60> <br>
> obj.foo
NoMethodError: undefined method `foo’ for #<object:0x0000010092ac60><br>
 from (irb):2<br>
 from /Users/akitaonrails/.rvm/rubies/ruby-1.9.2-p0/bin/irb:17:in `<main>’<br>
</object:0x0000010092ac60></object:0x0000010092ac60>
```

Agora, podemos redefinir o método <tt>method_missing</tt> do <tt>Object</tt> e veja o que acontece:

* * *

```ruby

> def method_missing(method, *args)  
> “#{method}:#{args.size}”  
> end

> obj.foo  
=> “foo:0”

> obj.foo(1,2,3)  
=> “foo:3”  
```

Este foi um resumo rápido, recomendo que se ainda não estiver familiarizado com esse conceito leia meu [Micro-Tutorial de Ruby – Parte II](/2008/11/10/micro-tutorial-de-ruby-parte-ii) onde eu explico isso em mais detalhes.

Um exemplo que gosto de usar é a classe Builder::XmlMarkup. Diferente de plataformas que fazem ou concatenação manual de Strings (péssimo) ou manipulação burocrática de nós (DOM), em Ruby temos essa excelente classe que minimiza a quantidade de código e ao mesmo tempo gera XML bem formatado e válido. Este é um exemplo:

* * *

```ruby
require ‘builder’  
x = Builder::XmlMarkup.new(:target => $stdout, :indent => 1)  
x.html do |h|  
 h.body do |b|  
 b.h1 “Hello World”  
 b.p “This is a paragraph.”  
 b.table do |t|  
 t.tr do |tr|  
 tr.td “column”  
 end  
 end  
 end  
end  
```

Esse código irá gerar diretamente este XML:

* * *
xml

# Hello World

This is a paragraph.

| column |

* * *

Se nunca tinha visto isso, pare por um segundo e contemple a beleza desta API. A partir do objeto XmlMarkup enviamos mensagens como <tt>html</tt> e ele vai acumulando as tags. Usamos blocos exatamente para blocos de XML, garantindo que eles terão as tags corretas de fechamento.

Pensando nisso, resolvi tentar fazer algo semelhante em Objective-C. A funcionalidade que permite esse tipo de API no Ruby é o <tt>method_missing</tt>, algo que imaginamos que somente linguagens dinâmicas conseguem ter. Porém, ao final deste artigo, quero fazer este código funcionar:

* * *

```objc
XmlBuilder* xml = [[XmlBuilder alloc] init];  
[xml htmlBlock:^(XmlBuilder* h) {  
 [h bodyBlock:^(XmlBuilder* b) {  
 [b h1:`"Hello World"];
        [b p:`“This is a paragraph.”];  
 [b tableBlock:^(XmlBuilder* t) {  
 [t trBlock:^(XmlBuilder* tr) {  
 [tr td:@"column"];  
 }];  
 }];
 }];  
}];
```

É bem mais _verbose_ do que Ruby, obviamente, mas ainda assim bem mais interessante do que o jeito de manipular DOMs com métodos como <tt>createElement</tt>, <tt>appendElement</tt>, etc. De uma certa maneira dá pra ficar bastante semelhante à versão em Ruby. Mas como isso é possível?

Antes de continuar, leia meu artigo sobre [Categorias e Blocos](/2010/11/28/objective-c-brincando-com-categorias-e-blocos) pois este artigo usará blocos.

## Seletores

Recapitulando, em Ruby, quando chamamos um método de um objeto, por exemplo:

* * *

```ruby
obj.foo(“Hello World”)
```

Na realidade podemos dizer que estamos _“enviando a mensagem :foo ao objeto ‘obj’”_ ou seja, seria o mesmo que:

* * *

```ruby

obj.send(:foo, “Hello World”)  
```

Em Obj-C temos algo semelhante. Quando fazemos:

* * *

```objc

[obj foo:@"Hello World"];  
```

Seria o equivalente a fazer:

* * *

```objc

[obj performSelector:`selector(foo:) withObject:`“Hello World”];  
```

A diferença é que em Ruby temos Symbols e em Obj-C temos [Selectors](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjectiveC/Articles/ocSelectors.html), que é semelhante, uma forma de não desperdiçar espaço com Strings. Porém, selectores são mais do que apenas métodos: eles representam o nome do método e seus atributos que em Obj-C são nomeados. Por exemplo, um método <tt>foo</tt>, com dois argumentos, poderia ser assim:

* * *

```objc
- (void) foo:(NSString*)bar value:(NSString*)xyz;  
```

Esse método seria enviado ao objeto assim:

* * *

```objc
[obj foo:`"Hello" value:`“World”];  
```

E seu seletor seria assim:

* * *

```objc
SEL t = @selector(foo:value:);  
```

Se o método tivesse apenas o primeiro argumento (que não tem nome), o seletor seria assim: <tt>foo:</tt> – note o “:” no final. Se não tiver nenhum argumento, não tem nenhum “:”. Isso é importante não confundir. Alguns erros podem passar em branco pela falta desse “:” na hora de montar o seletor.

Agora, quando se envia uma mensagem a um objeto e o método correspondente não está implementado, o Obj-C fará duas coisas: primeiro vai chamar o método <tt>methodSignatureForSelector:</tt>, que devolve um objeto <tt><a href="http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSMethodSignature_Class/Reference/Reference.html%23//apple_ref/doc/c_ref/NSMethodSignature">NSMethodSignature</a></tt>. Em seguida vai criar um objeto <tt><a href="http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSInvocation_Class/Reference/Reference.html">NSInvocation</a></tt> a partir disso e passará como argumento ao método <tt>forwardInvocation:</tt>. Este último é quem mais ou menos faz o papel do <tt>method_missing</tt> de Ruby.

Na realidade, em Obj-C essa técnica é chamada de [Message Forwarding](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtForwarding.html). O objetivo na realidade é criar objetos que são Proxy para outros objetos. Nesse caso o framework facilita as coisas para passar mensagens que realmente existem no objeto de destino.

O pseudo-código seria mais ou menos assim:

* * *

```objc
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {  
 return [anotherObject methodSignatureForSelector:aSelector];  
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {  
 [anotherObject performSelector:[anInvocation selector]];  
}  
```

Os métodos são chamados nessa sequência mesmo. No primeiro ele consegue a assinatura do método no objeto destino com o método <tt>methodSignatureForSelector</tt>. A assinatura é um array que representa o tipo do valor de retorno e os tipos dos argumentos. Essa assinatura é usada em conjunto com o seletor para criar o <tt>NSInvocation</tt>. Daí no segundo método o seletor é enviado ao objeto de destino, sendo assim executado.

Se precisar criar Proxies ou Adapters, esse é o padrão para fazê-lo.

## Proxy Dinâmico

O problema é que o padrão anterior pressupõe que o objeto de destino possui os métodos definidos a partir dos quais podemos extrair suas assinaturas. Porém, no nosso caso queremos um objeto que aceite qualquer tipo de mensagem representando tags arbitrários de um XML.

Para começar, quero definir uma classe chamada <tt>XmlBuilder</tt> e as variáveis internas que vão acumular o XML e controlar o nível de indentação:

* * *

```objc
# import <Foundation/Foundation.h>

@interface XmlBuilder : NSObject  
{  
 NSMutableString* buffer;  
 int indentationLevel;  
}  
@property (retain) NSMutableString* buffer;  
@property (assign) int indentationLevel;  
@end

@implementation XmlBuilder  
@synthesize buffer, indentationLevel;  

- (id) init {  
 self = [super init];  
 if (self) {  
 self.buffer = [[NSMutableString alloc] init];  
 self.indentationLevel = 0;  
 }  
 return self;  
}

- (void) dealloc {  
 [buffer release];  
 [super dealloc];  
}  
…  
@end  
```

Até aqui nada de mais, apenas definição de interface, implementação, propriedades, construtor e destrutor. Coisa padrão.

Agora a coisa começa a esquentar:

* * *

```objc
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {  
 // não importa o retorno porque não vamos usar essa assinatura  
 return [NSMethodSignature signatureWithObjCTypes:“v@:@”];  
}  
```

Esta primeira versão de implementação não precisa se preocupar com a assinatura. Vamos usar uma convenção para extrair os argumentos e não precisamos de assinaturas, então apenas devolvemos uma genérica qualquer.

Para começar, quero entender mensagens mais ou menos desse tipo:

* * *
 Convenção para métodos dinâmicos:

```objc

- (id) entity:(NSString*)value; - (id) entityBlock:(id (^)(id))block; */
```

* * *

Ou seja, mensagens assim:

* * *

```objc
[xml p:@"Hello World"];  
[xml tableBlock:^(XmlBuilder* t) { … }];  
```

Agora, vamos definir o método principal:

* * *

```objc

- (void)forwardInvocation:(NSInvocation **)anInvocation {  
 // #1  
 NSString** method = NSStringFromSelector([anInvocation selector]);

// #2BOOL hasBlock = [method hasSuffix:@"Block:"]; method = [method stringByReplacingOccurrencesOfString:@"Block" withString:@""]; method = [method stringByReplacingOccurrencesOfString:@":" withString:@""]; // #3 int tabsLength = self.indentationLevel * 2; NSMutableString* tabs = [NSMutableString stringWithCapacity:tabsLength]; int i; for ( i = 0 ; i \< tabsLength; i ++ ) { [tabs appendString:@" "]; } …
```

* * *

Vamos ver até a metade do método:

1. Primeiro extraímos o nome do seletor em forma de String para conseguirmos manipulá-lo
2. Nesta primeira versão, por convenção, assumimos que se seletor terminar com “Block:” significa que receberemos um bloco como argumento. Em seguida limpamos isso no nome do seletor para ficar só o nome da tag. Por exemplo: “htmlBlock:” ficaria “html” apenas. Eu faço isso porque ainda não aprendi a identificar o tipo do argumento recebido, pois se eu puder identificar que recebi um bloco, não preciso da convenção (fica como um TODO).
3. Aqui geramos uma String com espaços em branco representando o nível de identação atual do XML, para que o resultado final esteja bonito.

* * *

```objc
… if (hasBlock) { 
// #4 id (^block)(id); 
[anInvocation getArgument:&block atIndex:2]; 
// #5 [buffer appendFormat:`"%`\<%@\>\n", tabs, method]; 
self.indentationLevel = self.indentationLevel + 1; 
block(self); 
self.indentationLevel = self.indentationLevel – 1; 
[buffer appendFormat:`"%`\</%@\>\n", tabs, method]; } 
else { 
// #6 NSString* value; 
[anInvocation getArgument:&value atIndex:2]; [buffer appendFormat:`"%`\<%`>\n%`%`%`\n%`</%`\>\n", tabs, method, tabs, @" ", value, tabs, method]; }
}  
```

Continuando a partir da metade do código:

1. Se a convenção disser que existe um bloco, assumimos que ele foi passado como argumento no 3o ítem do array do <tt>NSInvocation</tt>. Por convenção o primeiro elemento desse array (0) é o self e o segundo (1) o método, portanto o 3o. elemento (2) é o equivalente ao primeiro argumento.
2. Agora vem a sequência para criar a tag que abre o bloco, depois aumentamos o nível de identação para o bloco; daí chamamos o bloco passado passando nós mesmos como parâmetro; o bloco é executado e quando retorna podemos diminuir o nível de identação; finalmente criamos a tag que fecha o bloco.
3. Caso não tenha sido passado um bloco então é uma tag simples com um valor simples dentro. Agora no 3o. elemento do array, em vez de esperar um bloco podemos esperar um String. Finalmente basta criar a tag com o valor String dentro e acertar a identação de acordo.

Fazendo isso, podemos agora fazer chamadas assim:

* * *

```objc
int main (int argc, const char * argv[]) {  
 NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

XmlBuilder* xml = [[XmlBuilder alloc] init]; [xml htmlBlock:^(XmlBuilder* h) { [h bodyBlock:^(XmlBuilder* b) { [b h1:@"Hello World"]; 

[b p:@"This is a paragraph."]; 
[b tableBlock:^(XmlBuilder* t) { [t trBlock:^(XmlBuilder* tr) { [tr td:@"column"]; }]; }]; }]; }]; 
NSLog(`"%`", [xml buffer]); [pool drain]; return 0;
}
```

Impressionantemente, se abrirmos o Console (Shift+Command+R) ao executar teremos exatamente esta saída do comando <tt>NSLog</tt>:

* * *
XML

# Hello World

This is a paragraph.

| column |

* * *

Que é o que queríamos e é semelhante ao gerado pelo equivalente Builder::XmlMarkup do Ruby. Claro, esta é uma versão hiper-simplificada, mas que pode ser o esqueleto para uma versão completa. O próximo passo é fazer a classe aceitar atributos de tags. E outra coisa é ver se é possível não precisar da convenção de “tableBlock:” para identificar se o argumento passado é um bloco e checar se é possível verificar o tipo do argumento passado em tempo de execução.

De qualquer forma, com isso podemos ver o quanto o Obj-C pode ser dinâmico e flexível mesmo em se tratando de uma linguagem de baixo nível como é C. Com um pouco de criatividade podemos criar bibliotecas que lembram em muito o que usamos em Ruby.
