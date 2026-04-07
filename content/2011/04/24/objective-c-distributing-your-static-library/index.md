---
title: "[Objective-C] Distribuindo sua Static Library"
date: '2011-04-24T00:46:00-03:00'
slug: objective-c-distribuindo-sua-static-library
translationKey: objc-distributing-static-lib
aliases:
- /2011/04/24/objective-c-distributing-your-static-library/
tags:
- learning
- beginner
- apple
- objective-c
- traduzido
draft: false
---

Se você não leu meus [dois](http://www.akitaonrails.com/2011/04/23/objective-c-it's-a-unix-system-i-know-this) [últimos artigos](http://www.akitaonrails.com/2011/04/23/objective-c-categories-static-libraries-and-gotchas), recomendo fortemente que leia antes de continuar, porque vou usar o mesmo pet project, [ObjC Rubyfication](http://www.akitaonrails.com/2011/04/23/objective-c-it's-a-unix-system-i-know-this), como exemplo neste artigo. A ideia é simples: você está escrevendo código reutilizável e quer aproveitar isso em mais de um projeto.

A maior parte do que vou mostrar foi baseada no artigo do [Cocoanetics](http://www.cocoanetics.com/2010/04/universal-static-libraries/) sobre universal static libraries. Então, se você prestou atenção no [artigo anterior](http://www.akitaonrails.com/2011/04/23/objective-c-categories-static-libraries-and-gotchas), viu este screenshot:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2011.41.27%20PM_original.png?1303613619)

Eu disse que tinha apenas estes targets configurados: CocoaOniguruma, Kiwi, Rubyfication e RubyficationTests. Mas existem mais 3: CocoaOniguruma SIM, Rubyfication SIM e Build & Merge Libraries. O motivo é simples:

- O Target "CocoaOniguruma" gera o binário <tt>libCocoaOniguruma.a</tt>, compatível com o processador ARM do iOS
- O Target "CocoaOniguruma SIM" gera o binário <tt>libCocoaOnigurumaSimulator.a</tt>, compatível com o processador i386 do iPhone Simulator local
- O Target "Rubyfication" gera o binário <tt>libRubyfication.a</tt>, compatível com o processador ARM do iOS
- O Target "Rubyfication SIM" gera o binário <tt>libRubyficationSimulator.a</tt>, compatível com o processador i386 do iPhone Simulator local
- O Target "Build & Merge Libraries" junta os binários específicos de cada target em um único Universal (Fat) Binary, fácil de distribuir e reutilizar.

## Conceitos e História

Cabe uma explicação aqui. Quando você desenvolve aplicações iOS, pode testar diretamente no seu iPhone ou dentro do Simulator. Apple foi muito esperta nesse ponto: qualquer outro fabricante do mercado começaria criando um emulador de processador ARM para rodar em cima do seu i386. Aí pegaria os binários ARM e os executaria dentro desse emulador. O sistema operacional continuaria compilado para ARM, rodando dentro do emulador.

Só que isso é absurdamente lento, impraticável. Quem já experimentou um ambiente de emulação assim sabe o quanto é ridículo. E não confunda com soluções tipo VMWare ou Parallels, que são rápidas porque emulam **o mesmo processador**. Você consegue rodar Windows em cima do Mac porque os processadores e sistemas operacionais hoje suportam VT-x, ou seja, você quase não precisa emular o processador. Agora, todo smartphone e tablet do mercado usa processador ARM, que não tem nada a ver com i386.

Então, como a Apple entregou um emulador de iPhone/iPad super rápido que roda em tempo real no seu Mac? Simples: ela não entregou. Ele se chama "Simulator" e não "Emulator" por um motivo: tudo que roda dentro do Simulator é compilado para i386, e não para ARM. Ou seja, o que está rodando ali é um binário real, executando nativamente no seu Mac! Sem emulação alguma. O iOS é bem portável. Da mesma forma que o Mac OS X conseguiu fazer a transição do PowerPC para Intel lá em 2005, o iOS faz o mesmo truque, já que basicamente são o mesmo sistema operacional.

Quando você escolhe o scheme do iPhone no XCode, ele compila para ARM e sobe os bits no seu iPhone para rodar a aplicação. Quando você escolhe o scheme do Simulator no XCode, ele compila para i386, sobe os bits no Simulator e roda nativamente como qualquer outra aplicação no seu Mac.

Voltando ao ponto principal: quando eu distribuo um binário da minha Static Library, tenho que lembrar que o desenvolvedor vai linkar contra ela tanto para deploy no device ARM (iPhone/iPad) quanto no Simulator (i386). Ou seja, eu teria que entregar pelo menos 2 arquivos binários. Mas a Apple foi ainda mais esperta. Aliás, a NeXT foi. Quando eles fizeram a primeira transição do NeXTStep dos processadores Motorola para Intel lá no fim dos anos 80, criaram os [Fat Binaries](http://en.wikipedia.org/wiki/Fat_binary), que basicamente são um único binário contendo os bits específicos de cada processador num só pacote. Quando a Apple fez a transição do PowerPC para Intel, rebatizaram para [Universal Binaries](http://en.wikipedia.org/wiki/Universal_binary). E é exatamente isso que precisamos construir agora.

## Operações

Já entendemos o que é um Universal Binary. Para facilitar, eu cliquei com o botão direito sobre os targets "Rubyfication" e "CocoaOniguruma" e dupliquei. Eles aparecem como "Rubyfication copy" e "CocoaOniguruma copy". Podemos mudar o "Product Name" nas build settings de cada um para algo mais razoável:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/24/Screen%20shot%202011-04-24%20at%2012.21.02%20AM_original.png?1303615270)

No meu caso, renomeei para "RubyficationSimulator" e "CocoaOnigurumaSimulator". Isso vai me dar tanto "libRubyficationSimulator.a" quanto "libCocoaOnigurumaSimulator.a". Como dá para ver no grupo Products:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/24/Screen%20shot%202011-04-24%20at%2012.23.16%20AM_original.png?1303615348)

**Importante:** lembre que o target Rubyfication tinha o CocoaOniguruma como dependência. Você vai precisar mudar o target "Rubyfication SIM" para apontar para o novo target "CocoaOniguruma SIM"! Outra coisa: você precisa forçar os dois novos targets a compilar para "Latest Mac OS X" na opção <tt>"Base <span class="caps">SDK</span>"</tt> do Build Settings de cada um, e "32-bit Intel" na opção <tt>"Architectures"</tt>. Isso faz com que sejam compilados para processadores i386. Os targets originais devem ter o <tt>"Base <span class="caps">SDK</span>"</tt> em "Latest iOS" e <tt>"Architectures"</tt> em "Standard (armv6 armv7)".

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/24/Screen%20shot%202011-04-24%20at%2012.54.21%20AM_original.png?1303617223)

Agora precisamos criar um novo target do tipo "Aggregate":

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/24/Screen%20shot%202011-04-24%20at%2012.24.00%20AM_original.png?1303615407)

Eu chamei de "Build & Merge Libraries". Na aba "Build Phases", você começa apenas com a fase "Target Dependencies". Basta adicionar os novos targets "Rubyfication SIM" e "CocoaOniguruma SIM". Em seguida, adicione mais 3 fases: uma "Run Script", uma "Copy Files" e mais uma "Run Script" no final.

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/24/Screen%20shot%202011-04-24%20at%2012.25.13%20AM_original.png?1303615678)

Na fase "Copy Files" eu adicionei todos os public headers que quero distribuir junto com a universal binary library. O motivo é que outros desenvolvedores vão precisar adicionar esses headers nos próprios projetos para conseguir compilar contra a minha biblioteca. Repare que estou copiando para um "Absolute Path" definido como <tt>${TARGET_BUILD_DIR}/../Rubyfication</tt>.

E é aí que entra a fase "Run Script" anterior, que deve ter o seguinte código:

* * *

```bash
# 1. cria uma nova pasta de saída
mkdir -p ${TARGET_BUILD_DIR}/../Rubyfication

# 2. combina os arquivos lib das várias plataformas em um só
lipo create "${TARGET_BUILD_DIR}/../Debug-iphoneos/libRubyfication.a" "${TARGET_BUILD_DIR}/../Debug-iphonesimulator/libRubyfication.a" -output "${TARGET_BUILD_DIR}/../Rubyfication/libRubyfication${BUILD_STYLE}.a"
```

A primeira coisa que ele faz é criar esse novo diretório "Rubyfication". O segundo comando usa o [lipo](http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/lipo.1.html), que junta 2 binários dependentes de processador num único universal binary. Preste atenção nos PATHs se for reutilizar esse script em outro lugar. Pelo menos no XCode 4, é nesses caminhos que ele cria os binários de cada target:

- ${TARGET_BUILD_DIR}/../Debug-iphoneos/libRubyfication.a – a versão ARM
- ${TARGET_BUILD_DIR}/../Debug-iphonesimulator/libRubyfication.a – a versão i386
- ${TARGET_BUILD_DIR}/../Rubyfication/libRubyfication-Debug.a – o universal binary resultante que criamos

Por fim, o último "Run Script", depois da fase "Copy Files" descrita acima, precisa do seguinte script:

* * *

```bash
ditto c -k --keepParent "${TARGET_BUILD_DIR}/../Rubyfication" "${TARGET_BUILD_DIR}/../Rubyfication.zip"
```

--

Ele apenas cria um arquivo ZIP com a universal binary library e seus public headers companheiros. Qualquer outro desenvolvedor pode pegar esse zip, descompactar e adicionar os arquivos no próprio projeto. Se quiser saber onde esse ZIP foi parar, o jeito mais fácil é ir no project viewer (painel da esquerda) do XCode, abrir o grupo "Products", clicar com botão direito no arquivo "libRubyfication.a" (ou qualquer outro arquivo gerado) e escolher "Show in Finder". Daí navegue uma pasta acima na hierarquia (até a pasta "Products") e você vai ver algo assim:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/24/Screen%20shot%202011-04-24%20at%2012.39.02%20AM_original.png?1303616300)

E pronto: aí está o seu ZIP com seu universal binary redistribuível novinho em folha!

## Usando o Universal Binary

Para demonstrar como usar esse ZIP distribuível, eu criei um projeto iOS bem simples e enxuto chamado [ObjC_OnigurumaDemo](https://github.com/akitaonrails/ObjC_OnigurumaDemo), que você pode baixar do Github e rodar no seu próprio device iOS.

Como dá para ver no screenshot abaixo, eu simplesmente descompactei o ZIP dentro de uma pasta "Dependencies" no meu projeto iOS e adicionei o universal binary "libRubyfication-Debug.a" na Library Linking Build Phase:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/24/Screen%20shot%202011-04-24%20at%2012.42.09%20AM_original.png?1303616506)

Isso me permite usar qualquer coisa dessa biblioteca no meu projeto, em particular um trecho de código que usa as expressões regulares do Oniguruma:

* * *

```objc
- (IBAction)runRegex:(id)sender {
    OnigRegexp* regex = [OnigRegexp compile:[regexPattern text]];
    OnigResult* res = [regex match:[initialText text]];
    NSMutableString* tmpResult = [NSMutableString stringWithString:@""];
    for(int i = 0; i < [res count]; i++) {
        [tmpResult appendString:@"("];
        [tmpResult appendString:[res stringAt:i]];
        [tmpResult appendString:@")"];
    }
    [result setText:tmpResult];
}
```

Essa aplicação de demonstração tem um text-field chamado "initialText", onde você pode digitar qualquer string. Aí você prepara uma expressão regular no text-field "regexPattern" e, ao apertar o botão "Run", ele dispara a action acima, que roda a expressão regular contra o texto inicial e escreve os matches entre parênteses na text view "result". A aplicação fica assim:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/24/Screen%20shot%202011-04-24%20at%2012.46.19%20AM_original.png?1303616748)

E, _voilá_! Expressão regular ao estilo Ruby 1.9, direto do Oniguruma, dentro de uma aplicação iOS!
