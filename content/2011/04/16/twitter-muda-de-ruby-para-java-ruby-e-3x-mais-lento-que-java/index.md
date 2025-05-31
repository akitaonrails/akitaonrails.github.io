---
title: Twitter muda de Ruby para Java. Ruby é 3x mais lento que Java.
date: '2011-04-16T01:57:00-03:00'
slug: twitter-muda-de-ruby-para-java-ruby-e-3x-mais-lento-que-java
tags:
- twitter
- java
- scala
- fud
draft: false
---

Estava esperando ter um tempinho para falar sobre isso. Se você presta atenção já deve ter visto posts de blog, tweets e tudo mais falando sobre um [post recente](http://engineering.twitter.com/2011/04/twitter-search-is-now-3x-faster_1656.html) do próprio Twitter explicando sobre a migração dos seus front-ends feitos em Ruby on Rails para uma solução que eles mesmo fizeram, chamada Blender, que é construída com Java. Com isso eles reduziram o tempo de requisição de 800ms para 250ms e conseguiram fazer suas máquinas terem 10 vezes mais capacidade.

Este é o resumo que você vai ler em todas os canais de comunicação que noticiaram o ocorrido. E, claro, os mais atrevidos e sem noção não se inibiram de novamente dizer “Ruby é muito lento, por isso compensa usar Java mesmo”. Como faz algum tempo que não falo sobre o assunto, acho que vale a pena repetir. Sim, todos nós rubistas sabemos que Ruby é uma das linguagens mais lentas que existem em uso hoje. E nenhum de nós faz nenhum esforço para esconder esse fato. Isso não é novidade, nunca foi. E aí eu pergunto: _“e daí?”_ E a resposta continua: _“oras, por isso mesmo não compensa usar Ruby e devemos todos continuar com Java, que é muitas vezes mais rápido, afinal se o Twitter disse é porque deve ser verdade.”_

Como vocês me conhecem, sabem que eu vou desviar do assunto principal para ensinar alguns conceitos que todos já deveriam saber:

## Argumentações Falaciosas

Sim, novamente textos escritos com conclusões falaciosas (não vou linkar nenhum dos artigos falaciosos que o pessoal tem twitado porque não quero lhes dar tráfego de graça, mas usem o Google e facilmente encontrarão dezenas). Primeiro o bom e velho [Hasty Generalization](http://www.nizkor.org/features/fallacies/hasty-generalization.html) ou “Generalização Apressada”. Ela acontece assim:

- Uma amostra S, que é muito pequena (às vezes apenas 1 caso), é tirada de uma população bem maior P;
- Uma conclusão C é generalizada à população P baseada em S

No nosso caso:

- O Twitter trocou de Ruby on Rails para Java;
- Conclusão: Ruby é ruim e todos deveriam trocar para Java.

Além disso todos os artigos que falam sobre este assunto cometem quase todos as falácias de [Cognitive Bias](http://en.wikipedia.org/wiki/List_of_cognitive_biases) do livro:

- Anchoring: a tendência humana comum de depender demais numa “âncora” ou pedaço de informação quando toma decisões. _“Esta linguagem é lenta, portanto ela é inútil”_
- Bandwagon effect: a tendência de fazer (ou acreditar) em coisas porque muitas outras pessoas fazem (ou acreditam) na mesma coisa. _“O Twitter trocou Ruby por Java, portanto todo mundo deveria.” ou “Todo mundo diz que Ruby é ruim, portanto deve ser.”_
- Confirmation Bias: a tendência de procurar por ou interpretar informação de maneira a confirmar seu preconceito. _“Eu acho que Ruby deve ser ruim. O Twitter trocou Ruby. Aha, portanto estou certo, Ruby é ruim.”_
- Negative Bias: a tendência de prestar mais atenção ou dar maior peso a experiências negativas do que positivas. _“O Twitter trocou Ruby, portanto Ruby é ruim. O Groupon e centenas de outras startups usam Ruby, mas isso não quer dizer quase nada.”_
- Status quo Bias: a tendência de gostar que as coisas se mantenham relativamente as mesmas. _“Todo mundo sempre usou Java, pra que tentar outra coisa?”_

Tem mais, mas vou parar por aqui porque já deu para demonstrar meu ponto.

## Cum hoc ergo propter hoc e Nirvana

Meus dois favoritos tipos de falácias são: [Correlação não implica causa](http://en.wikipedia.org/wiki/Correlation_does_not_imply_causation) (Cum hoc ergo propter) e [Falácia da Solução Perfeita ou Nirvana](http://en.wikipedia.org/wiki/Perfect_solution_fallacy).

O princípio é que existe algum tipo de Cognitive Bias – como mostrei antes – que gera um preconceito _“Ruby tem que ser ruim.”_

Quem procura sempre acha, já dizia o ditado. E de fato, todos sempre encontrarão correlações, neste caso _“O Twitter trocou de Ruby para Java. O Ruby é lento. Portanto é melhor sempre usar Java e nunca usar Ruby. Portanto Ruby é ruim”_ – ou algo similar.

O aspecto “performance” é sempre usado de maneira acima do peso que merecia (Negative Bias) para justificar que o Ruby inteiro deve ser ruim. O aspecto Twitter ou qualquer outro que teve problemas com Ruby serve de justificativa para demonstrar que Ruby é ruim (Hasty Generalization Fallacy).

E finalmente, a crença de que _“existe solução perfeita para hoje e que vai aguentar até o futuro sem problemas.”_ (Perfect Solution Fallacy).

Pois bem, não existe.

## A Realidade

Antes de mais nada, vale dizer que o [artigo original no blog do Twitter](http://engineering.twitter.com/2011/04/twitter-search-is-now-3x-faster_1656.html) – não as republicações – é muito boa, concordo com ela e recomendo que todos leiam.

O título diz: “Pesquisas no Twitter agora são 3x mais rápidas”. E isso é um fato. Ela não diz: _“Twitter determina que Ruby é ruim, troca para Java e fica 3x mais lento.”_ Essa conclusão nos artigos que republicaram o original são apenas provocações sensacionalistas.

Agora, trechos do artigo traduzido em português:

> Para conseguir entender os ganhos de performance, você deve primeiro entender as ineficiências dos nossos servidores de front-end anteriores, que eram em Ruby on Rails (…) Nós sabemos há muito tempo que o **modelo síncrono** de responder requisições de forma usam nossos CPUs de forma ineficiente. Com o tempo, nós também acabamos acumulando um **débito técnico** significativo no nosso código Ruby, tornando muito difícil adicionar novas funcionalidades e melhorar a confiabilidade do nosso engine de pesquisa. Blender [a nova solução feita com tecnologias Java] endereçam esses problemas: criando um serviço de agregação totalmente **assíncrono** (…)

O que o artigo explica é como a **mudança de arquitetura** foi de grande benefício e como o **débito técnico que eles acumularam** facilitou a decisão de jogar o legado em Ruby fora e começar do zero. O resto do artigo explica como o Blender funciona, como eles usaram estruturas de DAGs ([directed acyclic graphs](http://en.wikipedia.org/wiki/Directed_acyclic_graph)) para facilitar e otimizar o fluxo de trabalho entre os diferentes serviços dependentes. Como eles também criaram um novo proxy multiplexador de requisições de entrada (ainda não vi ninguém concluindo “O Twitter trocou seus proxies X por código deles mesmo. Portanto X é ruim.”). Finalmente eles descrevem as mudanças no roteamento de requisições no back-end entre os serviços dependentes.

Eu criticaria o fato deles estarem reescrevendo do zero tantos componentes de infraestrutura em vez de usar tecnologias que já existem, em particular o sistema de workflow e de fila, os proxies, etc. Porém, eu não concluiria que isso é errado. O caso do Twitter é uma exceção, não a regra. E a única forma de determinar o que o caso do Twitter necessita é estando no dia-a-dia de operações e desenvolvimento dentro do Twitter. Eu nunca estive por lá, portanto não posso concluir nada.

Mas repita comigo: _“eu não sou o Twitter, eu não sou o Twitter, eu não sou o Twitter.”_ E sinceramente, você dificilmente um dia chegará a uma fração do que é o Twitter. Não é impossível, afinal existe 1 caso de Twitter.

Para ilustrar, veja este gráfico de CPU semanal do Munin de um aplicativo que minha equipe desenvolveu:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/16/weekly-CPU_original.png?1302928669)

Note uma coisa: a maior parte do gráfico é “idle”. Ou seja, a maior parte do tempo este hardware está apenas esperando, sem fazer nenhum processamento. Se esta aplicação fosse, sei lá, 20 vezes mais lento, ainda assim estaria sobrando algum processamento. Pense bem: minha máquina não está sequer saturada. Será que ficar 3x mais rápido vai trazer algum benefício? Acho muito difícil. Porém, se minha equipe fosse 3 vezes menos produtiva, o prazo para entrega desta aplicação simplesmente não teria sido possível para nosso cliente.

Agora, no caso do Twitter, se o gráfico das centenas de máquinas que eles tem fossem parecidas com este, seria um enorme problema. Pense 100 máquinas onde 90% do tempo ele não está fazendo nada. Significa que daria para trocar as 100 máquinas por apenas 1 ou 2 onde menos de 10% do tempo ele não estaria fazendo nada. Ou seja, estaria saturado a maior parte do tempo.

Só que aqui vem outra das cognitive bias: de que performance é a única variável de impacto na solução e de que todos deveriam estar preparados para um dia ter a escala do Twitter. Agora prestem atenção:

> **Performance** NÃO é a única variável de um problema!

Ruby on Rails sempre se vendeu nos seguintes fatores:

- Usar Ruby que é uma das linguagens mais elegantes e prazerosas de trabalhar (embora gosto é algo que não se discute, e tem gente que acha ler assembler algo bonito)
- Ruby on Rails ajuda a aumentar a produtividade (considerando que com boas ferramentas e técnicas adequadas, certos casos de uso, a produtividade poderia aumentar em 5 vezes ou mais) – a premissa aqui é que para a maioria dos projetos (onde a exceção são casos como Twitter, Google) o custo da improdutividade normalmente seria muito mais caro do que meramente alugar mais máquinas. Não é verdade que Ruby on Rails sempre compensará, mas é real que em muitos casos isso é verdade.
- Ruby on Rails faz diversos “trade-offs” que fazem sentido para muitos projetos: de que perder performance para ganhar me produtividade + mantenabilidade + prazer da equipe é uma troca mais do que justa.
- (e para hoje em dia) o Ecossistema cresceu exponencialmente e hoje existem ferramentas incríveis para diversos aspectos do ciclo de desenvolvimento. Especialmente na área de testes com coisas como Capybara, RSpec, Riot, Cucumber, Steak, Akephalos, Factory Girl e muito, muito mais.

Encare a realidade: a grande maioria dos desenvolvedores sequer sabe a diferença entre requisições síncronas e assíncronas, sequer sabem o que é um sistema de filas, sequer sabem o que é um Munin! (que gera informações como o histórico de uso do CPU pelo tempo como na figura anterior).

Inclusive, aprenda a aprender: Ruby on Rails não é a única tecnologia existente no ecossistema Ruby. Está precisando de mais throughput, precisa mudar do modelo síncrono para assíncrono? Existem várias opções, uma delas é o [Goliath](http://www.igvita.com/2011/03/08/goliath-non-blocking-ruby-19-web-server/) do Ilya Grigorik e utilizado há tempos em produção pelo [PostRank.com](http://www.postrank.com/).

## Performance é sempre mais importante

Se nenhum dos argumentos anteriores fez sentido para você, aqui vai uma última. Se para você, performance bruta é o único fator de decisão de uma linguagem + plataforma + ecossistema, Não use Ruby, não use Python, sequer use .NET ou Java.

> Vá direto para C!!

Este é um exemplo usando o framework web para C chamado [Raphters](https://github.com/DanielWaterworth/raphters). E este é um exemplo dele para um micro código à la “hello world”

* * *

```c
#include “raphters.h”

START_HANDLER (simple, GET, “simple”, res, 0, matches) {  
 response_add_header(res, “content-type”, “text/html”);  
 response_write(res, “hello world”);  
} END_HANDLER

START_HANDLER (default_handler, GET, "", res, 0, matches) {  
 response_add_header(res, “content-type”, “text/html”);  
 response_write(res, “default page”);  
} END_HANDLER

int main() {  
 add_handler(simple);  
 add_handler(default_handler);  
 serve_forever();  
 return 0;  
}
```

Consigo enxergar esse framework sendo usado em algum serviço web muito específico e muito pequeno que é muito crítico, o suficiente para ir para C.

Agora, quero ver quem é o “performance-macho” suficiente (ou se fosse Tropa de Elite 2, quem é o “pica-das-galáxias”) para escrever algo da complexidade dos front-ends do Twitter totalmente usando C ou C++ com perda mínima de produtividade e aumento de custo de desenvolvimento e manutenção por um longo período de tempo (pelo menos 3 anos). Se não for capaz, pra que diabos você está perturbando com conclusões falaciosas?

E sabe por que você usa Java e não C ou C++? Não é por performance, foi por produtividade! Porque escrever sistemas é coisa para C. Mas escrever aplicações funcionais é mais produtivo com Java. E nós estamos dizendo que para um certo nicho de aplicações web, é bem mais produtivo fazer em PHP, Ruby, Python. Esses são os argumentos corretos.

PS: e sim, esta última parte foi uma [#trollagem](http://pt.wikipedia.org/wiki/Troll_(internet))
