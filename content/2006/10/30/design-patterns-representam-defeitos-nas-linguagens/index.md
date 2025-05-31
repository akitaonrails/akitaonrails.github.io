---
title: Design Patterns representam defeitos nas Linguagens
date: '2006-10-30T08:27:00-03:00'
slug: design-patterns-representam-defeitos-nas-linguagens
tags:
- principles
- design-patterns
draft: false
---

Este é um longo artigo postado no blog [The Universe of Discourse](http://newbabe.pobox.com/~mjd/blog/2006/09/11/#design-patterns), por Mark Dominus.

O artigo explica porque a filosofia do que conhecemos hoje como “Movimento de Design Patterns” gasta esforços numa direção equivocada e porque **Ruby on Rails** é uma resposta na direção certa. Também fica mais simples entender porque RoR é comumente chamado de _“DSL de aplicativos Web”_, ou seja, uma Linguagem de Domínio Específico (DSL) voltado a aplicativos Web que seguem o Design Pattern MVC.

Desde o começo da genealogia das linguagens de programação, saltamos de linguagens de máquina (Assembly), para Fortran, Lisp, Simula, Haskell, Perl, Java, Ruby onde cada nova linguagem melhora deficiências das anteriores. É um pensamento que muitos programadores não entendem, mas deveriam, porque estão à mercê do movimento de Design Patterns, acreditando que eles são a única solução dos problemas, ou seja, que a solução é entender que o problema existe e que, infelizmente, é necessário aprender a conviver com ele, em vez de realmente resolver o problema.

#### Design Patterns de 1972

“Patterns” (padrões) que são recorrentes em uma linguagem podem ser invisíveis ou triviais em outra linguagem.

#### Exemplo Extendido: “classe orientada a objeto”

Programadores de C tem um pattern que poderia ser chamado “classe orientada a objeto”. Nesse pattern, um objeto é uma instância de um struct C.

* * *

```c
struct st_employee_object *emp;  
```

Ou, dado um typedef apropriado:

* * *

```c
EMPLOYEE emp;  
```

Alguns dos membros da struct são ponteiros de função. Se “emp” é um objeto, então podemos chamar um método do objeto procurando pelo ponteiro de função apropriado e chamando essa função:

* * *

```c
emp→method(emp, args…);
```

Cada struct define uma classe; objetos na mesma classe tem os mesmos dados como membros e suportam os mesmos métodos. Se a definição da struct é declarada em um arquivo header, o layout da estrutura pode mudar; métodos e campos podem ser adicionados e nenhum dos códigos que usam o objeto precisam saber disso.

Existem diversas variações em cima disso. Por exemplo, você pode ter uma implementação opaca definindo dois arquivos header para cada classe. Uma que define a implementação:

* * *

```c
struct st_employee_object {  
 unsigned salary;  
 struct st_manager_object *boss;  
METHOD fire, transfer, competence;  
};
```

E outra que define a interface:

* * *

```c
struct st_employee_object {  
 char __SECRET_MEMBER_DATA_DO_NOT_TOUCH
 struct st_manager_object *boss;
METHOD fire, transfer, competence;
};  
```

Então os arquivos incluem um ou outro conforme for apropriado. Aqui “boss” é um dado público mas “salary” é privado.

Você consegue classes abstratas definindo uma função construtora que configura todos os métodos como NULL ou para:

* * *

```c
void _abstract() { abort(); }  
```

Se quiser herança, você faz uma das structs ser o prefixo de outra:

* * *

```c
struct st_manager_object; //Forward Declaration

#define EMPLOYEE_FIELDS

 unsigned salary;
 struct st_manager_object *boss;
METHOD fire, transfer, competence;

struct st_employee_object {
 EMPLOYEE_FIELDS
};

struct st_manager_object {
 EMPLOYEE_FIELDS
 unsigned num_subordinates;
 struct st_employee_object **subordinate;
METHOD delegate_task, send_to_conference;
};  

```

E se `obj` é um objeto `manager`, você ainda pode tratá-lo como um `employee` e chamar métodos de `employee` dele.

Isso pode parecer estranho ou limitado, mas a técnica é usada largamente. O padrão C contém garantias que os campos comuns de `struct st_manager_object` e `struct st_employee_object` serão colocados na memória de maneira idêntica, especialmente de tal maneira que essa técnica de classe orientada a objetos funcione. O código do sistema X Window tem essa estrutura. O código do toolkit de widgets Athena tem essa estrutura. O código do filesystem na kernel do Linux tem essa estrutura.

Rob Pike, um dos principais arquitetos do sistema operacional Plan 9 (o sucessor do Unix feito pela Bell Labs) e co-autor (with Brian Kernighan) do _The Unix Programming Environment_, recomenda essa técnica em seu artigo [Notes on Programming in C](http://www.lysator.liu.se/c/pikestyle.html)

#### Isso é um pattern

Há apenas uma maneira onde essa técnica não se qualifica como um pattern, de acordo com a definição de Gamma, Helm, Johnson e Vlissides. Eles dizem:

> Um design pattern sistematicamente nomeia, motiva e explica um design geral que endereça um problama recorrente de design em sistemas orientados a objeto. Ele descreve o problema, a solução, quando aplicar a solução e suas consequências. Ele também dá dicas de implementação e exemplos. A solução é um arranjo geral de objetos e classes que resolvem o problema. A solução é customizada e implementada para resolver o problema em um contexto em particular.

A definição deles arbitrariamente restringe “design patterns” para endereçar problemas recorrentes de design “em sistemas orientados a objeto”, e como sendo arranjos gerais de “objetos e classes”. Se ignorarmos essa restrição arbitrária, o padrão de “classe orientada a objetos” se encaixa perfeitamente nessa definição.

A definição da Wikipedia é:

> Em engenharia de software, um design pattern é uma solução geral para um problema comum em design de software. Um design pattern não é um design finalizado que pode ser transformado diretamente em código; é uma descrição ou um template de como resolver um problema que pode ser usado em muitas situações diferentes.

E a solução de “classe orientada a objetos” certamente se qualifica.

#### Codificação de patterns

A apresentação de Peter Norvig sobre [Design Patterns em Linguagens Dinâmicas](http://www.norvig.com/design-patterns/) descreve três “níveis de implementação de um pattern” :

- Invisível – praticamente uma parte da linguagem, que você nem nota.
- Formal – implementa o pattern propriamente dito dentro da linguagem. instancia-se ou chama-se para cada uso. usualmente implementada com macros.
- Informal – Design Pattern em prosa; referido pelo nome, mas Precisa ser reimplementado do zero para cada uso.

Em C, a “classe orientada a objetos” é um pattern informal. Ele precisa ser reimplementado do zero para cada uso. Se você quiser herança, precisa configurá-lo manualmente. Se quiser abstração, precisa configurá-lo manualmente.

O principal motivo para a invenção do C++ foi para codificar esse pattern na linguagem para se tornar “invisível”. Em C++, você não precisa pensar na forma de structs e não precisa se preocupar em manter dados e métodos privados. Você apenas declara a “class” (usando sintaxe que se parece exatamente como a declaração de uma struct) e anota os ítens como “public” ou “private” conforme apropriado.

Mas por baixo dos panos, ele está fazendo a mesma coisa. Os primeiros compiladores C++ simplesmente traduziam código C++ em código C equivalente e chamavam o compilador C. Existe uma razão porque a sintaxe de chamada de método do C++ é `object->method(args...)`: é praticamente a mesma coisa do código equivalente em C para implementar esse pattern. A única diferença é que o objeto é passado implicitamente ao método, em vez de explicitamente como o primeiro argumento.

Em C, você precisa tomar uma decisão consciente de usar o estilo OO e implementar cada funcionalidade de seu sistema OOP enquanto trabalha. Se um programa tem cinquenta módulos, você precisa decidir, cinquenta vezes, se vai fazer o próximo módulo ser no estilo OO. Em C++, não precisa fazer isso e não precisa implementá-lo: já está construído dentro da linguagem.

#### Sherman, configura a máquina do tempo para 1957

Se escavarmos para trás na história, podemos encontrar todo tipo de patterns. Por exemplo:

> Problema recorrente: duas ou mais partes de uma linguagem de máquina precisam fazer a mesma operação complexa. Duplicar o código toda vez cria problemas de manutenção quando uma cópia é atualizada e a outra não.  
>
> Solução: coloque o código dessa operação no final do programa. Reserve alguma memória extra (um “frame”) para esse uso exclusivo. Quando outro código (o “caller”, “chamador”) quiser executar essa operação, ele deve armazenar os valores correntes dos registradores da máquina, incluindo o contador do programa, no frame, e tranferir controle para a operação. A última coisa que essa operação deve fazer é restaurar os valores dos registradores a partir dos valores gravados no frame e pular de volta (jump) para a instrução exatamente depois do valor PC gravado.

Essa é uma descrição no estilo de uma pattern que nós conhecemos como “sub-rotina”. Ele endereça um problema recorrente de design. Ela é um arranjo genérico de instruções de máquina para resolver um problema. E a solução é customizada e implementada para resolver o problema em um contexto em particular. Variações: “sub-rotina com passagem de parâmetros”, “chamada de sub-rotina com valor de retorno”, “sub-rotina re-entrante”.

Para programadores de linguagem de máquina dos anos 50 e começo dos anos 60, isso era um pattern, reimplementado do zero para cada uso. Quando os assemblers melhoraram, o pattern se tornou formal, implementado com macros de linguagens assembly. Logo depois disso, o pattern foi absorvido no Fortran e Lisp e seus sucessores, e agora é invisível. Você não precisa pensar mais sobre a implementação: você apenas chama funções.

#### Iteradores e model-view-controller

Na [última vez](http://perl.plover.com/yak/design/) que escrevi sobre design patterns, foi para apontar que embora o movimento tenha sido inspirado pelo trabalho de “linguagem de pattern” de Christopher Alexander, não é parecido com nada que Alexander tenha sugerido, e que de fato o que Alexander sugeriu é mais interessante e provavelmente teria sido mais útil para programadores do que o movimento de design pattern escolheu seguir.

Uma das coisas que eu apontei foi essencialmente o que Norvig disse: que muitos patterns não estão realmente endereçando problemas recorrentes de design em programas orientados a objetos. Eles estão, na realidade, endereçando **deficiências** em linguagens de programação orientadas a objetos e que em linguagens melhores, esses problemas simplemente não aparecem ou são resolvidos de maneira tão fácil e trivial que a solução não requer um pattern. Em linguagem assembly, “chamada de sub-rotina” pode ser um pattern; em C, a solução é escrever `result = function(args ...)`, que é simples demais para se qualificar como pattern. Em uma linguagem como Lisp ou Haskell ou mesmo Perl, com um bom tipo de lista e poderosas primitivas para operar em valores de listas, o pattern “Iterator” (iterador) é aliviado em um grande degrau ou tido como invisível. Henry G. Baker pegou esse ponto em seu artigo [Iterators: Sinais de Fraqueza em Linguagens Orientadas a Objetos.](http://home.pipeline.com/~hbaker1/Iterator.html)

Recebi muitas mensagens sobre isso, e curiosamente, alguns chegaram à mesma conclusão da mesma forma: eles disseram que embora eu estivesse certo sobre Iterator, era um exemplo pobre porque era um pattern muito simples, mas que era impossível imaginar um pattern mais complexo como Model-View-Controller ser absorvido e se tornar invisível dessa maneira.

Essa observação é chocante por diversas razões. Isso é um exemplo do que talvez seja a maior falácia da filosofia comum: o escritor não pode imaginar alguma coisa, portanto ela só pode ser impossível. Bem, talvez seja mesmo impossível – ou talvez o escritor simplesmente não tenha imaginação. É importante lembrar que Edgar Allan Poe foi motivado a investigar e expôr o fraudulento autômato jogador de xadrez de Johann Maezel. Isso porque ele “sabia” que ele tinha que ser fraudulento porque era _inconcebível_ que uma máquina que jogasse xadrez realmente pudesse existir. Não meramente impossível, mas inconcebível! Poe estava errado, e as pessoas que afirmaram que MVC não poderia ser absorvido em uma linguagem de programação estavam errados também. Desde que dei minha palestra em 2002, muitos sistemas de programação, como [Ruby on Rails](http://www.rubyonrails.org/) e [Subway](http://subway.python-hosting.com/) deram um passo à frente na tentativa de codificar e integrar MVC exatamente da maneira como foi sugerida.

#### Progresso em linguagens de programação

Se o movimento de “Design Patterns” tivesse sido popular nos anos 60, seus objetivos teriam sido de treinar programadores para reconhecer situações onde o pattern de “sub-rotina” poderia ser aplicado e para implementá-lo habitualmente quando necessário. Embora isso pudesse ter sido uma grande melhoria sobre não usar sub-rotinas, ainda teria sido muito inferior ao que realmente aconteceu, que foi ter o pattern de “sub-rotina” codificado e integrado em linguagens subsequentes.

Identificação de patterns é um importante fator de progresso em linguagens de programação. Como em toda programação, a idéia é notar quando uma mesma solução está aparecendo repetidamente em diferentes contextos e entender as partes comuns. Isso é admirável e de muito valor. O problema com o movimento de “Design Patterns” é o uso que o pattern é colocado depois: programadores são treinados a identificar e aplicar os patterns onde for possível. Em vez disso, os patterns deveriam ser usados como marcas de falhas na linguagem de programação. Como em toda programação, a identificação de partes comuns deveria ser seguida de um passo de abstração onde essas partes comuns seriam mescladas em uma única solução.

Múltiplas implementações de uma mesma idéia são quase sempre um erro em programação. O local correto para implementar uma solução comum a um problema recorrente de design é na própria linguagem de programação, se possível.

A visão do movimento de “Design Patterns” dita que de alguma forma é inevitável que programadores tenham que implementar Visitors, Abstract Factories, Decorators e Facades. Mas isso não é mais inevitável do que a necessidade de implementar Chamadas de Sub-Rotinas ou Classes Orientadas a Objetos na fonte da linguagem. Esses patterns deveriam ser vistas como defeitos ou funcionalidades que faltam em Java e C++. A melhor resposta para a identificação desses patterns é perguntar quais defeitos nessas linguagens resultam na necessidade de um pattern, e como a linguagem poderia prover um suporte melhor para resolver esse tipo de problema.

Como Design Patterns como usualmente entendidos, você nunca pára de pensar nos patterns depois de encontrá-los. Toda vez que você escreve uma Chamada de Sub-Rotina, precisa pensar na maneira como os registradores são salvos e como o valor de retorno é comunicado. Toda vez que escreve uma Classe Orientada a Objetos, você precisa pensar sobre implementação de heranças.

As pessoas dizem que está tudo bem que Design Patterns ensinem as pessoas a fazer isso, porque o mundo está cheio de programadores que são forçados a usar C++ e Java, e eles precisam de toda ajuda possível para vencer os defeitos nessas linguagens. Se essas pessoas precisam de ajuda, está tudo certo. O problema é com a filosofia do movimento. Ajudar pobres programadores de C++ e Java é admirável, mas esse não deveria ser o objetivo final. Em vez de pensar que o uso dos Design Patters tem valor e parar nisso, deveria ser largamente reconhecido que cada design pattern é uma expressão de uma falha na fonte da linguagem.

Se o movimento de Design Patterns tivesse sido popular nos anos 80, nós nem teríamos C++ ou Java; nós ainda estaríamos implementando Classes Orientadas a Objetos em C com structs e o argumento seria de que como os programadores são forçados a usar C, de qualquer forma, nós deveríamos ajudá-los o máximo que for possível. Mas a maneira de prover a máxima ajuda não foi de treinar pessoas a se habiturem a implementar Classes Orientadas a Objetos quando necessário; mas sim foi desenvolver linguagens como C++ e Java que tinham o pattern construído dentro de si, de forma que os programadores pudessem se concentrar em usar o estilo OOP em vez de implementá-lo.

#### Sumário

Patterns são sinais de fraquezas nas linguagens de programação.

Quando identificamos e documentamos uma, este não deve ser o fim da história. Em vez disso, nós devemos ter o objetivo de longo prazo de entender como melhorar a linguagem de tal forma que o pattern se torne invisível ou desnecessário.
