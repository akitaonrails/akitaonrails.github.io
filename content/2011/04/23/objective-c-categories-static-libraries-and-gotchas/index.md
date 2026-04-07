---
title: "[Objective-C] Categories, Static Libraries e Pegadinhas"
date: '2011-04-23T23:44:00-03:00'
slug: objective-c-categories-static-libraries-e-pegadinhas
translationKey: objc-categories-static-libs
aliases:
- /2011/04/23/objective-c-categories-static-libraries-and-gotchas/
tags:
- learning
- beginner
- apple
- objective-c
- traduzido
draft: false
---

Como alguns de vocês já sabem, eu tenho um pequeno pet project chamado [ObjC Rubyfication](https://github.com/akitaonrails/ObjC_Rubyfication), um exercício pessoal de escrever uma sintaxe parecida com Ruby dentro de Objective-C. A maior parte do projeto se aproveita do fato de que dá pra reabrir as classes padrão do Objective-C – muito parecido com Ruby, diferente do Java – e inserir nosso próprio código – através de [Categories](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocCategories.html%23//apple_ref/doc/uid/TP30001163-CH20), que são parecidas com os módulos do Ruby.

A ideia desse pet project é ser uma Static Library que eu possa adicionar facilmente em qualquer outro projeto e ter todas as suas funcionalidades disponíveis. Nesse artigo eu queria mostrar como estou organizando os vários subprojetos dentro de um projeto só (e estou aberto a sugestões e dicas pra melhorar isso, já que ainda estou aprendendo a organizar as coisas dentro de projetos Obj-C) e falar sobre uma pegadinha que me tomou horas pra descobrir e que talvez ajude alguém.

Pra deixar esse exercício ainda mais divertido, eu também adicionei um target separado pra minha suíte de testes unitários (e ver como o XCode dá suporte a testes), depois outro target pro framework BDD [Kiwi](http://kiwi-lib.info/) pra Obj-C, e mais um pro [CocoaOniguruma](http://limechat.net/cocoaoniguruma/) que eu acabei de explicar no [artigo anterior](http://www.akitaonrails.com/2011/04/23/objective-c-it's-a-unix-system-i-know-this).

Eu venho brincando com formas de reorganizar o meu projeto e percebi que estava fazendo errado. Eu estava adicionando todos os arquivos fonte do meu target “Rubyfication” dentro do target Specs. Então tudo compilava direitinho, todas as specs passavam, mas a forma como eu definia as dependências estava errada. É meio complicado de entender no começo, mas deveria ser algo assim:

- Target CocoaOniguruma: deveria ser uma static library, sem dependências de target e sem bibliotecas binárias pra linkar, apenas com uma dependência do framework Foundation padrão. Ele expõe os headers OnigRegexp.h, OnigRegexpUtility.h e oniguruma.h como public headers.
- Target Kiwi: deveria ser outra static library, sem dependências de target e sem bibliotecas binárias pra linkar, apenas com as dependências dos frameworks Foundation e UIKit.
- Rubyfication: deveria ser outra static library, com CocoaOniguruma como dependência de target, linkando contra o binário libCocoaOniguruma.a e dependendo do framework Foundation também. Ele expõe todos os seus arquivos <tt>.h</tt> como public headers.
- RubyficationTests: deveria ser um Bundle criado junto com o target Rubyfication (você pode especificar se quer um target de testes unitários quando cria novos targets), com Kiwi e Rubyfication como dependências de target, linkando contra os binários libKiwi.a e libRubyfication.a, e os frameworks Foundation e UIKit também.

Se você ficar criando novos targets manualmente, o XCode 4 também vai criar um monte de Schemes que você nem precisa. Eu mantenho os meus limpos com apenas o scheme Rubyfication. Você pode acessar o menu “Product” e a opção “Edit Scheme”. Aí o meu Scheme fica assim:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2011.26.25%20PM_original.png?1303611943)

Eu costumo configurar todos os meus build settings pra usar “LLVM Compiler 2.0” pras configurações de Debug e “LLVM GCC 4.2” pras configurações de Release (na verdade, eu faço isso por precaução porque não sei se o pessoal está realmente fazendo deploy de binários em produção compilados com LLVM).

Eu também configuro o <tt>“Targeted Device Family”</tt> pra “iPhone/iPad” e tento deixar o <tt>“iOS Deployment Target”</tt> em “iOS 3.0” sempre que possível. O pessoal normalmente deixa o padrão, que vai ser o release mais recente – atualmente 4.3. Cuidado porque o seu projeto pode não rodar em dispositivos mais antigos desse jeito.

Por fim, eu também garanto que os <tt>“Framework Search Paths”</tt> apontem pra estas opções:

* * *

```
“$(SDKROOT)/Developer/Library/Frameworks”  
“${DEVELOPER_LIBRARY_DIR}/Frameworks”  
```

Tudo compila numa boa desse jeito. Aí eu posso apertar “Command-U” (ou ir no menu “Product”, opção “Test”) pra fazer o build do target “RubyficationTests”. Ele compila todas as dependências de target, linka tudo junto e roda o script final pra executar os testes (você precisa garantir que está selecionando o “Rubyfication – iPhone 4.3 Simulator” no menu de Schemes). Ele vai abrir o Simulator pra rodar as specs.

Mas aí eu estava recebendo:

* * *

```
Test Suite ‘/Users/akitaonrails/Library/Developer/Xcode/DerivedData/Rubyfication-gfqxbgyxicfpxugauehktilpmwzv/Build/Products/Debug-iphonesimulator/RubyficationTests.octest(Tests)’ started at 2011-04-24 02:16:27 +0000  
Test Suite ‘CollectionSpec’ started at 2011-04-24 02:16:27 +0000  
Test Case ‘-[CollectionSpec runSpec]’ started.  
2011-04-23 23:16:27.506 otest[40298:903] [__NSArrayI each:]: unrecognized selector sent to instance 0xe51a30  
2011-04-23 23:16:27.508 otest[40298:903] ***** Terminating app due to uncaught exception ‘NSInvalidArgumentException’, reason: ’[__NSArrayI each:]: unrecognized selector sent to instance 0xe51a30’  
```

Ele diz que uma instância de <tt>NSArray</tt> não está reconhecendo o selector <tt>each:</tt> enviado pra ela no arquivo <tt>CollectionSpec</tt>. Provavelmente é esse trecho:

* * *

```objc
# import “Kiwi.h”  

# import “NSArray+functional.h”  

# import “NSArray+helpers.h”  

# import “NSArray+activesupport.h”

SPEC_BEGIN(CollectionSpec)

describe(@"NSArray", ^{  
 __block NSArray* list = nil;

context(@"Functional", ^{ beforeEach(^{ list = [NSArray arrayWithObjects:@"a", @"b", @"c", nil]; }); 

it(@"should iterate sequentially through the entire collection of items", ^{ NSMutableArray* output = [[NSMutableArray alloc] init]; 

[list each:^(id item) { [output addObject:item]; }];

[[theValue([output count]) should] equal:theValue([list count])]; });
…
```

Referência: [CollectionSpec.m](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/RubyficationTests/CollectionSpec.m#L1-22)

Repare que na linha 3 está o import correto onde a category <tt>NSArray(Helpers)</tt> está definida com o método <tt>each:</tt> declarado certinho. O erro está acontecendo na spec da linha 18 do trecho acima.

Agora, isso não era um erro de compilação, era um erro de runtime. Então o import está achando o arquivo correto e compilando, mas algo na fase de linking não está indo bem e em runtime a category <tt>NSArray(Helpers)</tt>, e provavelmente outras categories, não estão disponíveis.

Levou algumas horas de pesquisa, mas finalmente descobri uma flag simples que mudou tudo, a flag de linker [-all_load](http://developer.apple.com/library/mac/#qa/qa1490/_index.html). Como a documentação diz:

> **Importante:** Para aplicações de 64-bit e iPhone OS, existe um bug no linker que impede o <tt>-ObjC</tt> de carregar arquivos de objeto de static libraries que contêm apenas categories e nenhuma classe. O workaround é usar as flags <tt>-all_load</tt> ou <tt>-force_load</tt>.
>
> <tt>-all_load</tt> força o linker a carregar todos os arquivos de objeto de cada archive que ele encontra, mesmo aqueles sem código Objective-C. <tt>-force_load</tt> está disponível no Xcode 3.2 e posteriores. Ele permite um controle mais granular do carregamento de archives. Cada opção <tt>-force_load</tt> deve ser seguida por um caminho pra um archive, e cada arquivo de objeto naquele archive vai ser carregado.

Então todo target que depende de static libraries externas que carregam Categories tem que adicionar essa flag <tt>-all_load</tt> em “Other Linker Flags”, na categoria “Linking” dentro de “Build Settings” do target, assim:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2011.41.27%20PM_original.png?1303613619)

Então tanto o meu target <tt>RubyficationTests</tt> quanto o <tt>Rubyfication</tt> tiveram que receber essa nova flag. E agora todos os testes passam sem problema!
