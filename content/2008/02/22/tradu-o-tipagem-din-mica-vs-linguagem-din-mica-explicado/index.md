---
title: 'Tradução: Tipagem Dinâmica vs Linguagem Dinâmica Explicado'
date: '2008-02-22T19:38:00-03:00'
slug: tradu-o-tipagem-din-mica-vs-linguagem-din-mica-explicado
tags:
- learning
- beginner
- translation
draft: false
---

Estou na minha temporada de traduções :-) Felizmente a blogosfera produz muitos artigos interessantes. Desta vez foi [Steven Devijver](http://groovy.dzone.com/news/dynamic-typing-vs-dynamic-lang) que fez um artigo explicando sobre as diferenças entre os termos **tipagem** dinâmica e **linguagem** dinâmica.

Vamos à tradução:

Eu acabei de ler [um post muito interessante sobre as virtudes de tipagem estática comparado com tipagem dinâmica](http://pinderkent.blogsavy.com/archives/157) ( **nota do Akita** : o artigo desse link foi especialmente tecido com a intenção de pegar os despreparados). Levou um tempinho para eu entender os exemplos de código de Ruby, Python, OCaml e Haskell. Mesmo assim consegui concluir algumas coisas desse artigo:

- Ruby e Python são linguagens com tipagem dinâmica. Eles não suportam tipagem estática.

- OCaml e Haskell são linguagems com tipagem estática. Eles não suportam tipagem dinâmica.

Entretanto a diferença é clara o suficiente. VB Script (Visual Basic Script) tem tipagem dinâmica e mesmo assim não é uma linguagem dinâmica. O código abaixo é VB Script válido (roda no Windows com cscript.exe):

* * *

```vb

dim x  
dim y

x = 1  
y = 2

x = “ABC”  
y = “XYZ”
```

-

Ruby e Python usam tipagem dinâmica e eles também são linguagens dinâmicas. Aqui vai um trecho de código demonstrando o mecanismo de despacho dinâmico do Ruby:

* * *

```ruby
class Dummy
 def method_missing(m, *args)
 args + args1
 end
end

raise “Error” unless Dummy.new.test(1, 2) == 3  
```

O método test() chamado na classe Dummy na última linha é despachado pelo Ruby ao método method_missing(). ( **nota do Akita** : note que dizemos “despachado” – dispatched – e não “chamado”. Não ‘chamamos métodos’, mas sim ‘enviamos mensagens’, a diferença é muito grande.) Python e Groovy também suportam Despacho Dinâmico. Em geral, linguagens dinâmicas como Ruby, Python e Groovy tem um Protocolo de Meta-Objeto ou MOP (Meta-Object Protocol).

De volta ao post que mencionei no começo. O autor tenta provar que tipagem estática é superior à tipagem dinâmica. Para provar isso ele usa este código em Ruby (também há exemplos em Python, OCaml e Haskell):

* * *

```ruby

def test(a, b)  
 a + b  
end

def main()  
 if ARGV.length \> 3  
 test(1, test)  
 else  
 test(1, 2)  
 end  
end

Process.exit(main())  
```

Esse código funciona bem quando passamos 0, 1, 2 ou 3 argumentos na linha de comando:

* * *

```bash

$ ruby w -W2 t.rb; echo $?  
3  
$ ruby -w -W2 t.rb 0; echo $?  
3  
$ ruby -w -W2 t.rb 0 1; echo $?  
3  
$ ruby -w -W2 t.rb 0 1 2; echo $?  
3  
```

Entretanto, quando passamos 4 argumentos na linha de comando o script Ruby falha:

* * *

```bash
$ ruby w -W2 t.rb 0 1 2 3; echo $?  
t.rb:7:in `test’: wrong number of arguments (0 for 2) (ArgumentError)  
 from t.rb:7:in`main’  
 from t.rb:13  
1
$
```

--

Baseado nesse script Ruby, o (famigerado) autor chega à seguinte conclusão:

> Como é esperado de uma linguagem com tipagem dinâmica como Ruby, o erro não foi detectado até o momento de execução (runtime) […] Mesmo se testes unitários tivessem sido utilizados, é bem possível que esse cenário não seria coberto, e um usuário perplexo encararia um erro como o mostrado acima.

Bem, não podemos argumentar contra isso. Ele vai adiante com as versões de OCaml e Haskell do mesmo script. Na conclusão o autor diz:

> Como vimos claramente acima, linguagens com tipagem dinâmica como Ruby e Python podem permitir que código estragado seja escrito facilmente. Mas mais perigoso, é possível que esse código rode bem, até que uma certa condição aconteça e aí vai acontecer um erro de runtime. […] Ainda bem que linguagens de tipagem estática fornecem uma maneira muito natural de evitar muitos problemas de runtime, em vez disso pegando-os no momento de compilação.

E eis quando a confusão se firmou, misturando tipagem dinâmica com linguagem dinâmica. O autor nunca menciona “linguagem dinâmica” em seu post (somente “linguagens de tipagem dinâmica”) e ainda assim ele clama que linguagens de tipagem estática detectam confusão de tipos no momento de compilação, logo são mais seguras para os desenvolvedores usar.

Aqui vai um script tipado estaticamente em Groovy que vai falhar em tempo de compilação:

* * *

```java
int x = "test"
```

Este é o erro em runtime:

* * *

```bash

Caught: org.codehaus.groovy.runtime.typehandling.GroovyCastException: Cannot cast object ‘test’ with class ‘java.lang.String’ to class ‘java.lang.Integer’  
at typesafe.run(typesafe.groovy:1)  
at typesafe.main(typesafe.groovy)  
```

Hmm, Groovy sem sombra de dúvida tem tipagem estática (note, entretanto, que não há erro em tempo de compilação). Ainda assim ele também é uma linguagem dinâmica. Aqui vai o script Ruby anterior re-escrito em Groovy:

* * *

```groovy

def test(int a, int b) {  
 a + b  
}

if (args.length \> 3) {  
 println test(1, “test”)  
} else {  
 println test(1, 2)  
}  
```

Veja a declaração do método test() nas primeiras 3 linhas e seus argumentos tipados estaticamente. Esse script vai compilar? Sim. Esse script vai falhar quando 3 ou menos argumentos forem passados na linha de comando? Não. Aqui vão as saídas para 0 até 4 argumentos na linha de comando:

* * *

```bash

C:\\>groovy type_safe  
3  
C:\\>groovy type_safe 0  
3  
C:\\>groovy type_safe 0 1  
3  
C:\\>groovy type_safe 0 1 2  
3  
C:\\>groovy type_safe 0 1 2 3  
Caught: groovy.lang.MissingMethodException: No signature of method: type_safe.test() is applicable for argument types: (java.lang.Integer, java.lang.String) values: {1, "test"}  
 at type_safe.run(type_safe.groovy:6)  
 at type_safe.main(type_safe.groovy)  
C:\\>
```

Por que esse script compila quando o método test() tem argumentos tipados? A chamada a test() na última linha é claramente incorreta!

Groovy é uma linguagem dinâmica com um Protocolo de Meta-Objeto. O compilador Groovy não tem nenhuma maneira de saber como a chamada da última linha acima será despachada. Talvez seja despachada para o método test() declarado nas primeiras 3 linhas. Mas configuração dinâmica em tempo de execução também pode significar que a chamada seja despachada para outro lugar.

Groovy suporta tipagem estática, Ruby e Python não. Como são linguagens dinâmicas seus compiladores ou interpretadores não podem saber como as chamadas de métodos serão despachados (essa informação está disponível apenas em tempo de execução). Suas implementações do Protocolo de Meta-Objeto são o poder dessas linguagens dinâmicas.

Para os designers de Ruby e Python suportar tipagem estática provavelmente não fazia muito sentido já que não pode ser usado para reforçar o tempo de compilação de qualquer forma. Groovy suporta tipagem estática para suportar, por exemplo, overloading de métodos e construtor.

Fazer pouco de Ruby, Python e Groovy porque eles não checam tipos em momento de compilação não leva em conta o poder das linguagens dinâmicas. Eu entendo que linguagens não-dinâmicas são desejáveis por muitas razões, mas assim também é com linguagens dinâmicas.

Da próxima vez que ouvir pessoas reclamando sobre linguagens dinâmicas por sua falta de tipagem estática você estará melhor informado para entender porque eles reclamam. Talvez eles não gostem de linguagens dinâmicas, ou gostem muito de tipagem estática. Mas pelo menos você saberá que existem diferenças entre tipagem dinâmica e linguagens dinâmicas. E também entenderá que eles preferem linguagens não-dinâmicas de tipagem estática.

Feliz codificação!
