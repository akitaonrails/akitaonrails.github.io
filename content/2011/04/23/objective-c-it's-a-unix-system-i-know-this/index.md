---
title: "[Objective-C] É um sistema Unix! Eu sei mexer nisso!"
date: '2011-04-23T22:47:00-03:00'
slug: objective-c-e-um-sistema-unix-eu-sei-mexer-nisso
translationKey: objc-its-a-unix-system
aliases:
- /2011/04/23/objective-c-its-a-unix-system-i-know-this/
tags:
- learning
- beginner
- apple
- objective-c
- traduzido
draft: false
---

Enquanto experimentava formas de usar Objective-C de um jeito mais parecido com como eu programo em Ruby, duas coisas me incomodaram um pouco. Primeiro, formatação de datas e, segundo, expressões regulares.

O framework Cocoa tem ambos implementados como [NSDateFormatter](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html%23//apple_ref/doc/uid/TP40002369-SW1) e [NSRegularExpression](http://developer.apple.com/library/iOS/#documentation/Foundation/Reference/NSRegularExpression_Class/Reference/Reference.html), que por acaso também estão disponíveis para desenvolvimento iOS.

Você pode formatar datas assim:

* * *

```objc
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];  
[dateFormatter setTimeStyle:NSDateFormatterNoStyle];

NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:162000];

NSString *formattedDateString = [dateFormatter stringFromDate:date];  
NSLog(`"formattedDateString: %`", formattedDateString);  
// Saída para o locale en_US: “formattedDateString: Jan 2, 2001”  
```

E você pode usar expressões regulares assim:

* * *

```objc

NSError *error = NULL;  
NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\b(a|b)(c|d)\\b"
 options:NSRegularExpressionCaseInsensitive  
 error:&error];

NSUInteger numberOfMatches = [regex numberOfMatchesInString:string  
 options:0  
 range:NSMakeRange(0, [string length])];  
```

Mas eu tenho problemas com os dois. O equivalente em Ruby para o exemplo de formatação de datas seria:

* * *

```ruby
require ‘activesupport’  
date = Time.parse(“2001-01-01”) + 162000.seconds  
date.strftime(“%b %d, %Y”)  
```

E o exemplo de expressão regular seria assim:

* * *

```ruby

number_of_matches = /\W*[a|b][c|d]\W*/.match(string).size  
```

Tem 2 coisas específicas que me incomodam:

- as versões em Obj-C parecem desnecessariamente verbosas. Eu entendo que elas são de mais baixo nível e provavelmente permitem mais flexibilidade, mas acho que deveriam ter versões mais "porcelana", mais diretas.
- em Obj-C, a formatação de datas usa o padrão [Unicode TR-35](http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns) e as expressões regulares usam o padrão [ICU](http://userguide.icu-project.org/strings/regexp), que é inspirado nas expressões regulares de Perl com suporte a Unicode e vagamente baseado no java.util.regex do JDK 1.4.

Então, a solução ideal para mim seria:

- ter versões de mais alto nível dessas funcionalidades;
- ter formatação de datas com strftime compatível com C e expressões regulares no nível do Oniguruma do Ruby 1.9.

## É um sistema Unix

Foi aí que me caiu a ficha do óbvio: Objective-C nada mais é que um superset de C, então qualquer coisa compatível com C é automaticamente compatível com Objective-C. Mais que isso, o **iOS é um sistema Unix**! Ou seja, ele tem todas as gostosuras do suporte Posix.

<http://www.youtube.com/embed/dFUlAQZB9Ng>

Então, como eu pego o [strftime compatível com C](http://www.cplusplus.com/reference/clibrary/ctime/strftime/)? Fácil:

* * *
C

```objc
# import “time.h”  

…  

- (NSString*) toFormattedString:(NSString*)format {  
 time_t unixTime = (time_t) [self timeIntervalSince1970];  
 struct tm timeStruct;  
 localtime_r(&unixTime, &timeStruct);

char buffer[30]; 
strftime(buffer, 30, [[NSDate formatter:format] cStringUsingEncoding:[NSString defaultCStringEncoding]], &timeStruct); NSString* output = [NSString stringWithCString:buffer encoding:[NSString defaultCStringEncoding]]; 
return output;

}
```

-

Referência: [NSDate+helpers.m](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/Rubyfication/NSDate+helpers.m#L71-80)

Agora siga cada linha pra entender:

- Na linha 4 ele retorna o tempo atual representado como o número de segundos desde 1970. Esse método na verdade retorna um <tt>NSTimeInterval</tt>, que é um número essencialmente igual ao equivalente em C <tt>time_t</tt>
- Na linha 6 a função C <tt>localtime_r</tt> converte o número <tt>unitTime</tt> na estrutura C <tt>timeStruct</tt>
- Na linha 9 chamamos um método customizado que criei chamado <tt>formatter</tt>, que apenas devolve uma string de formato compatível com <tt>strftime</tt>. A string Obj-C (quando criamos com o símbolo "@") é um objeto que precisamos converter para um array de chars usando <tt>cStringUsingEncoding:</tt>. Funções C não entendem string Obj-C, daí a conversão. Aí finalmente chamamos o próprio <tt>strftime</tt>, que vai armazenar o resultado no array de char <tt>buffer</tt> que declaramos antes.
- Na linha 10 fazemos o caminho inverso e convertemos a C-string resultante (array de chars) de volta em uma String Obj-C.

Agora isso fica muito bom. Adicionei alguns outros métodos auxiliares que agora me permitem usar assim:

* * *

```objc
it(`"should convert the date to the rfc822 format", ^{
    [[[ref toFormattedString:`“rfc822”] should] equal:@"Fri, 01 Jan 2010 10:15:30"];  
}); 
```

-

Referência: [DateSpec.m](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/RubyficationTests/DateSpec.m#L69)

E a string <tt>“rfc822”</tt> vai ser internamente convertida para <tt>@"%a, %d %b %Y %H:%M:%S"</tt> pelo seletor [<tt>formatter:</tt>](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/Rubyfication/NSDate+helpers.m#L82-100) na classe <tt>NSDate</tt>.

Agora, pra ter expressões regulares no nível do Ruby 1.9 você pode ir direto na fonte e usar o próprio [Oniguruma](http://www.geocities.jp/kosako3/oniguruma/) original baseado em C, exatamente o que o Ruby faz. Existem várias formas de integrar uma biblioteca C em um projeto Cocoa, mas alguém já fez todo o trabalho pesado. Satoshi Nakagawa escreveu um wrapper em Obj-C chamado [CocoaOniguruma](http://limechat.net/cocoaoniguruma/) que torna a integração no seu projeto absurdamente fácil.

Existem várias formas de integrar uma biblioteca externa no seu projeto. A forma mais fácil (embora não exatamente a melhor) que mostro aqui é criando um novo Static Library Target dentro do meu projeto, chamado _CocoaOniguruma_:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2010.33.47%20PM_original.png?1303608817)

Isso vai criar um novo Group chamado _CocoaOniguruma_ no seu projeto. Depois é só adicionar todos os arquivos da [pasta core do CocoaOniguruma](https://github.com/psychs/cocoaoniguruma/tree/master/framework/core) nesse grupo, selecionar o novo target e todos os arquivos fonte e headers serão devidamente adicionados ao projeto, assim:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2010.37.19%20PM_original.png?1303608987)

Por fim, você precisa ir no target principal original da sua aplicação e adicionar tanto o novo target nas dependências de target quanto o binário <tt>.a</tt> na seção de linking de binários, assim:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2010.39.07%20PM_original.png?1303609098)

Com tudo isso configurado, recomendo explorar o <tt>OnigRegexp.m</tt> e o <tt>OnigRegexpUtility.m</tt>, que são wrappers Obj-C para a biblioteca Oniguruma. O autor já deixou uma sintaxe bem ao estilo Ruby pra você usar.

Embrulhei esses helpers nas minhas próprias classes assim:

* * *

```objc
- (NSString*) gsub:(NSString*)pattern with:(id)replacement {  
 if ([replacement isKindOfClass:[NSString class]]) {  
 return [self replaceAllByRegexp:pattern with:replacement];
 } else if ([replacement isKindOfClass:[NSArray class]]) {  
 __block int i = -1;  
 return [self replaceAllByRegexp:pattern withBlock:^(OnigResult* obj) {  
 return [NSString*](replacement objectAtIndex:(++i));  
 }];
 }  
 return nil;  
}

- (NSString*) gsub:(NSString*)pattern withBlock:(NSString* (^)(OnigResult*))replacement {  
 return [self replaceAllByRegexp:pattern withBlock:replacement];  
}
```

Referência: [NSString+helpers.m](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/Rubyfication/NSString+helpers.m#L176-190)

O que agora me permite usar essa sintaxe mais agradável:

* * *

```objc
context(`"Regular Expressions", ^{
    it(`“should replace all substrings that match the pattern”, ^{  
 [[[`"hello world, heyho!" gsub:`“h\\w+” with:`"hi"] should] equal:`“hi world, hi!”];  
 });

it(@"should replace each substrings with one corresponding replacement in the array", ^{ NSArray* replacements = [NSArray arrayWithObjects:@"hi", @"everybody", nil]; [[[`"hello world, heyho!" gsub:`“h\\w+” with:replacements] should] equal:@"hi world, everybody!"]; }); it(@"should replace each substring with the return of the block", ^{ [[[`"hello world, heyho!" gsub:`“h\\w+” withBlock:^(OnigResult* obj) { return @"foo"; }] should] equal:@"foo world, foo!"]; });
});
```

Referência: [StringSpec.m](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/RubyficationTests/StringSpec.m#L86-102)

Se você está achando estranho um trecho de código Objective-C ter palavras-chave como <tt>context</tt> ou <tt>it</tt>, elas vêm do [Kiwi](http://www.kiwi-lib.info/), que constrói um framework de testes BDD ao estilo RSpec em cima do SenTesting Kit para desenvolvimento Objective-C, e que você definitivamente deveria conferir. Mas o código acima deve ser fácil de entender mesmo sem conhecer o Kiwi. Se você é desenvolvedor Ruby, provavelmente vai notar que a sintaxe tem certa semelhança com o que você já está acostumado.

Então, linkar com bibliotecas C padrão existentes ou até com bibliotecas C open source de terceiros é moleza pra esses casos simples, sem precisar recorrer a nenhum tunelamento de "Native Interface" entre máquinas virtuais ou qualquer outra encanação. Se você quer C, ele está aí pra você integrar e usar facilmente.
