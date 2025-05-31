---
title: "[Objective-C] Entendendo NSAutoreleasePool"
date: '2010-11-25T01:13:00-02:00'
slug: objective-c-entendendo-nsautoreleasepool
tags:
- learning
- beginner
- apple
- objective-c
draft: false
---

Ultimamente ando brincando de desenvolvimento iPhone e pra isso caí no Objective-C. Gosto muito da linguagem. Já conhecia um pouco do básico dele mas foi a primeira vez que comecei a codificar de verdade. Alguns podem não gostar da sintaxe ou de algumas das ferramentas (realmente o XCode não é completo nem robusto o suficiente, mas dá pro gasto). Mas no geral acho o fluxo de desenvolvimento bastante agradável.

Logo de cara uma coisa que confunde os que sempre trabalharam com plataformas com Garbage Collector é o gerenciamento manual de memória. Vou me abster da discussão sobre se é melhor ou pior e os trade-offs. Na prática, é simples manter isso manualmente.

Uma coisa que confunde no início é o <tt>NSAutoreleasePool</tt>. Todo projeto Cocoa começa com algo parecido com isto, no <tt>main.m</tt>:

* * *

```objc
int main(int argc, char \*argv[]) {   
 NSAutoreleasePool \* pool = [[NSAutoreleasePool alloc] init];  
 int retVal = UIApplicationMain(argc, argv, nil, nil);  
 [pool release];  
 return retVal;  
}
```

O Obj-C trabalha com contagem de referência para limpar memória. Toda vez que se chama o método <tt>alloc</tt> ou <tt>new</tt> memória é alocada, um novo objeto é instanciado e seu contador sobe para 1. Toda vez se envia a mensagem <tt>retain</tt> a esse objeto o contador é incrementado, toda vez que se envia a mensagem <tt>release</tt> o contador é decrementado. Quando o contador chega a zero, o sistema pode destruir o objeto (chamando também seu método <tt>dealloc</tt>) e a memória é devolvida ao sistema.

O sistema devolve memória liberado ao sistema ao final de uma execução, mas existe um caso em específico que pode dar picos de consumo de memória antes do sistema ter chance de limpá-la. Veja este trecho:

* * *

```objc
- (IBAction) onClick:(id)sender {  
 int i;  
 for (i = 0; i \< 50000; i++) {  
 NSString \* teste = [NSString stringWithFormat:`"Teste %i", i];
      NSLog(`“X: %@”, teste);  
 }  
}  
```

Imagine situações onde você está consumindo um stream de dados como de um arquivo, um web service, um parser, um tweet stream ou coisas assim, com cada ítem sendo processado em loop. Não é difícil sair criando milhares de Strings sem liberá-los.

No caso, estamos criando Strings usando o método <tt>stringWithFormat</tt> que, por convenção, devolve o String criado depois de ter já chamado o método <tt>autorelease</tt>. Explicando, você é responsável por criar e destruir objetos. Porém, quando você repassa um objeto que você criou para outro objeto, quem é o responsável por mandar <tt>release</tt> ao objeto?

Esse é o caso do <tt>stringWithFormat</tt>. Nesse caso não é nem a classe <tt>NSString</tt> nem nosso código que o chamou que vai liberar a memória ocupada por esse String. Quando você tem essa situação, em vez de mandar um <tt>release</tt>, deve enviar <tt>autorelease</tt>. Isso colocará o objeto no último <tt>NSAutoreleasePool</tt> criado. Os pools são empilháveis: os objetos sempre são colocados sob a responsabilidade do último pool criado.

Assim, como no <tt>main.m</tt> criamos um pool, os Strings serão todos colocados lá. Porém, eles serão apenas liberados depois do loop de 50 mil voltas. Por isso teremos um pico de consumo de memória até o término do loop. Dependendo do que está processando, você pode consumir toda a memória do sistema sem saber. Veja quando rodamos esse código num aplicativo via Instruments:

![](http://s3.amazonaws.com/akitaonrails/assets/2010/11/25/Screen%20shot%202010-11-25%20at%201.03.24%20AM_original.png?1290654557)

Note quanto de memória está sendo usada somente por <tt>CFString</tt>, mais de 1MB (!) Precisamos melhorar isso. E essa memória vai crescer quanto mais Strings forem criados dentro desse loop.

Esse padrão é fácil de identificar, basta procurar por loops que podem ser muito longos (centenas ou milhares de interações). Para “consertar” isso, podemos fazer o seguinte:

* * *

```objc
- (IBAction) onClick:(id)sender {
 int i;  
 // cria novo pool  
 NSAutoreleasePool\* pool = [[NSAutoreleasePool alloc] init];  
 for (i = 0; i \< 50000; i++) {  
 NSString \* teste = [NSString stringWithFormat:`"Teste %i", i];
        NSLog(`“X: %@”, teste);  
 if (i % 1000 == 0) {  
 // limpa o pool a cada mil interações  
 [pool release];  
 // cria um novo pool vazio  
 pool = [[NSAutoreleasePool alloc] init];  
 }  
 }  
 // limpa o último pool criado  
 [pool release];  
}  
```

É o mesmo código, porém criamos um novo <tt>NSAutoreleasePool</tt> especialmente para os objetos criados pelo loop. Dentro do loop limpamos o pool depois de alguma certa quantidade de interações que faça sentido, no exemplo, a cada 1000 interações. Uma vez que o pool é liberado, criamos outro vazio para poder continuar o loop. E no final garantimos que estamos liberando o último pool criado.

Com isso o consumo de memória nunca passará de um certo teto bem mais baixo que o pico causado pelo exemplo anterior. Vejamos rodando esse novo código via Instruments:

![](http://s3.amazonaws.com/akitaonrails/assets/2010/11/25/Screen%20shot%202010-11-25%20at%201.05.04%20AM_original.png?1290654550)

Muito melhor! Não muito mais do que 100Kb. E esse consumo é constante e não crescente como antes, o que é mais importante. Mais do que consumir pouca memória é importante conseguir comportamentos onde o consumo não passe de um certo teto.

Esse é apenas um dos aspectos do gerenciamento de memória do Objective-C que é importante que os programadores se atentem. Vou fazer mais artigos sobre esse assunto, aguardem.
