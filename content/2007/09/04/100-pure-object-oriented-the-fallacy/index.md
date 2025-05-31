---
title: '100% pure Object-Oriented: The Fallacy'
date: '2007-09-04T16:22:00-03:00'
slug: 100-pure-object-oriented-the-fallacy
tags:
- principles
- career
- paradigms
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/9/4/ptr0121l.jpg)

Essa é uma das afirmações mais falaciosas quando queremos criar uma Guerra Religiosa: _“Sua linguagem não é 100% orientada-a-objetos, portanto, logo, por conseguinte, a minha é mais forte.”_ Quantas vezes já não ouvimos isso? Acho que desde que Simula (a primeira orientada a objetos) ou C with Classes (a primeira extenção de classes para C) foram lançados, décadas atrás, ouvimos a mesma coisa.

Ela parte de dois princípios argumentativos igualmente falaciosos:

1. _“Toda boa linguagem é orientada a objetos.”_
2. _“A quantidade de funcionalidades OO que uma linguagem suporta é diretamente proporcial à sua capacidade.”_


A primeira não pode ser considerada um axioma, porque possui muitos falsos positivos. A segunda é derivada da primeira e não podemos [provar uma negativa](http://en.wikipedia.org/wiki/Negative_proof) baseada em outra negativa. Foi o que eu expliquei no artigo [Inimigos da Razão](http://www.akitaonrails.com/2007/8/23/off-topic-inimigos-da-razo). Aliás, nenhum dos criadores de linguagens costuma usar esse tipo de afirmação.

Basta lembrar que orientação a objetos é apenas **uma** de dezenas de características que moldam uma linguagem e nenhuma implementa 100% delas (porque não seria prático). No [wikipedia](http://en.wikipedia.org/wiki/Categorical_list_of_programming_languages) há mais detalhes mas só como exemplos. Temos linguagens orientadas a aspectos (Java, Common Lisp), linguagens compiláveis (Ada, Algol, C), linguagens concorrentes – que enviam mensagens (Concurrent Pascal, Clik, E, Erlang), linguagens orientadas a dados (SQL, ABAP, Clipper), linguagens declarativas (Prolog), linguagens funcionais (Lisp, F#). E por aí vai. Isso sem contar as que tem tipagem forte/fraca ou estática/dinâmica.

12 anos atrás houve muita discussão se Java é ou não 100% orientada a objetos. O problema: não existe uma definição oficial para isso. Não existe um paper na ISO, no ECMA, nenhuma RFC, IEEE ou qualquer coisa que categoricamente defina _“isto **é** , sem sombra de dúvida 100% O.O., ou 50% O.O.”_. O que se considera – por consenso público – uma linguagem O.O?

- suporte encapsulamento
- suporte herança
- suporte polimorfismo
- faça chamadas através do envio de mensagens entre objetos
- todos os tipos básicos são objetos

[Alguns](http://forum.java.sun.com/thread.jspa?threadID=754518&tstart=466) [dirão](http://forum.java.sun.com/thread.jspa?threadID=5120371&messageID=9418761) que Java suporta herança simples, mas como não suporta herança múltipla, não é O.O. C++ suporta múltipla herança. Outros vão contra-argumentar que de fato Java suporta múltipla-herança de interfaces. Alguns dirão que Java tem tipos primitivos e isso não é O.O. C++ também tem, portanto também não é O.O. Outros vão atacar dizendo que só deveria haver tipos básicos como objetos. Ou seja, tipos primitivos com a ‘gambiarra’ de classes Wrappers não vale. E isso não tem fim, podemos passar anos discutindo isso (oras, já passamos anos discutindo isso!)

Vejamos uma definição (não oficial) na [Wikipedia](http://en.wikipedia.org/wiki/Object-oriented_programming_language) : _“Linguagens chamadas ‘puro’ O.O., porque tudo neles são tratados consistentemente como um objeto, de primitivas como caracteres e pontuações, subindo o caminho todo até classes, protótipos, blocos, módulos, etc. Foram desenhados especificamente para facilitar, até mesmo reforçar, métodos O.O.. Exemplos: Smalltalk, Eiffel, Ruby.”_

Como esquecer do venerado [Bertrand Meyer](http://en.wikipedia.org/wiki/Bertrand_Meyer) e seu [Eiffel](http://en.wikipedia.org/wiki/Eiffel_(programming_language)), inspiração para todas as linguagens modernas com aspectos de objetos principalmente por uma funcionalidade que quase nenhum linguagem tem: assertions ([Design by Contract](http://en.wikipedia.org/wiki/Design_by_Contract)), algo mais forte do que tipagem estática ou herança de interface.

Nessa definição de O.O., Java e Python não se encaixam porque elas preservam alguma natureza procedural. Esta [tabela de comparação](http://archive.eiffel.com/doc/manuals/technology/oo_comparison/), entre Eiffel, C++, Java e Smalltalk levaria muitos a crer que Eiffel é, de longe, a melhor linguagem. Fica obscuro porque ela não é a mais popular.

O máximo que podemos efetivamente afirmar sobre uma linguagem é se ela é [Turing Complete](http://en.wikipedia.org/wiki/Turing_completeness) ou não. C++, Java, Ruby, Smalltalk, Python são todas Turing Complete. SQL não é. Uma linguagem muito promissora, por exemplo, é [Scala](http://tinyurl.com/2n6o7g). ela é uma linguagem orientada a objetos (no sentido que todo valor é um objeto), funcional (no sentido de que toda função é um valor), com tipagem forte e estática, que roda sobre a JVM (novamente, uma das melhores VMs já feitas). Ruby é uma linguagem O.O., com aspectos funcionais, tipagem forte e dinâmica, e interpretada. Smalltalk é O.O., sem aspectos funcionais relevantes, mas com tipagem forte e dinâmica e compilada para uma VM. Visual Basic é uma linguagem procedura, com aspectos de O.O., tipagem fraca e dinâmica e pré-compilada para um interpretador.

No final, a linguagem/plataforma que melhor levar seu projeto até o final é a vencedora (levar até o final e sem deixar mortos no meio do caminho, de preferência). Todo projeto nasce diferente, tem requerimentos diferentes (performance, reliability, maintainability, security, size, scalability, manageability, learning curve, industry support, market support, etc). Nunca pense: _“só pode haver um”_. Esse pensamento Highlander leva as pessoas a enxergar todo problema como pregos, pois a única ferramenta que ele conhece é um martelo ([Hammer and Nail problem](http://www.everything2.com/index.pl?node)_id=987739). Ou alguém pode querer inventar o framework para bater todos os frameworks, a linguagem para bater todas as linguagens. Apenas implementar todas as funcionalidades listadas acima não garante um bom produto. Acaba-se no famoso problema de se criar uma solução procurando por um problema.

Por isso fica minha recomendação – constante, persistente e insistente em todo artigo: não se limitem, [aprender](http://en.wikipedia.org/wiki/Programming_language) mais e mais é o que nos torna melhores, em qualquer coisa. É o que chamamos de [Cultura](http://en.wikipedia.org/wiki/Culture) (que vem de “cultivar”).

