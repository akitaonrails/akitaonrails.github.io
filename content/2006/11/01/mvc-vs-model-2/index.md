---
title: MVC vs Model 2
date: '2006-11-01T08:30:05-03:00'
slug: mvc-vs-model-2
tags:
- principles
- mvc
draft: false
---

Meu post sobre [Design Patterns representam defeitos nas Linguagens](http://www.balanceonrails.com.br/articles/2006/10/30/design-patterns-representam-defeitos-nas-linguagens) gerou uma pequena e saudável discussão no [GUJ](http://www.guj.com.br/posts/list/44869.java). Claro, o objetivo do meu post foi exatamente esse: instigar uma discussão sobre um assunto que muitos acreditam que já é absoluto e imexível. Nada é imexível. Além disso existe outro problema: muitos tem visões equivocadas sobre alguns conceitos. Um deles é o MVC.

Em um dos últimos comentários nessa discussão no GUJ surgiu um ponto interessante: _“por que chamam o Rails de MVC? O Rails seria Model 2, não?”_. Excelente observação, foi a primeira vez que ouvi isso e ele está certo: Rails, academicamente falando, pelo menos, não é MVC. Para explicar isso cabe uma explicação sobre o que é MVC o que é Model 2.

Brian McCallister explica isso de uma forma simples e direta, por isso resolvi citá-lo aqui. Em seu artigo [MVC, Model 2, Java WebApps,](http://kasparov.skife.org/blog/2004/11/05/#mvc "and callcc, why not") ele tira essas dúvidas.

Vamos para a tradução (eu sei, eu sei, mais uma tradução, mas vocês tem que concordar que pelo menos a fonte do material é de qualidade).


#### Blog: Brian’s Waste of Time

<small>05/11/2004</small>

Primeiro, uma breve história de MVC e suas convoluções, para que eu possa apontar as pessoas a ela no futuro ;-)

Os Smalltalkers brigaram por anos sobre os detalhes do jeito certo de fazer isso, mas resumindo … UI (User Interface – View) intimamente conhece o Model. Ele pode observá-lo, e puxar quaisquer valores dele, mas não pode modificá-lo. A View também conhece intimamente o Controller. Ele o usa. É isso mesmo, o View é altamente acoplado com ambos o Controller e o Model.

 ![](/files/smalltalk-mvc.png)

O Controller conhece o Model intimamente. No mundo Smalltalk o controller não era mais que um punhado de delegações opacas que redirecionavam mensagens para o Model. O Controller é altamente acoplado com o Model.

O Model representa o domínio do problema. Ele não sabe nada sobre o View ou o Controller. O Model tem a capacidade de poder ser observado (se a observação é _fine grained_ ou _coarse grained_ é fonte de profundas brigas, e realmente depende no custo de examinar o model). Quando o estado do Model muda, ele dispara mensagens a observers (observadores) dizendo que foi modificado. Esses observers são (normalmente) Views que então sabem que precisam atualizar o que estão mostrando.

Implementar uma View tipicamente envolve fazer subclasses de classes de Views existentes que sabem como desenhar o que você quer. Na subclasse você provê o encanamento necessário para registrar a instância para se auto-redesenhar quando o model sinalizar que seu estado mudou, e você aponta eventos interessantes (mouse click, etc) no Controller. Se você mudar seu model, provavelmente precisará mudar suas Views.

Implementar um Controller significa prover receptáculos para receber mensagens interessantes e mapeá-las diretamente para maçanetas interessantes no Model. O Controller é muito muito magro.

 ![](/files/nextstep-mvc.png)

Então chega a NeXT, Objective-C e uma variação no MVC. Esse pessoal da NeXT se cansou de ficar criando subclasses de componentes de View e decidiram que views realmente poderosas deveriam ser facilmente reusáveis. Por isso fizeram views padrão mais espertas, e adicionaram ganchos para empurrar dados à View em vez de fazer a View puxar os dados do Model. Mais ainda, eles fizeram a View apresentar as mensagens que podia disparar, tornando-a uma caixa preta. De fato, eles fizeram um formato de caixa preta encapsulada o suficiente para conseguir formar um mercado de terceiros fabricantes de componentes view, que podiam ser enganchados a controllers arbitrários.

O Controller NeXT, por outro lado, ficou muito mais complicado. Ele agora é um observer da View _e um observer do Model_. A observação da View é _fine grained_ (clique do mouse em _XPTO_) e a observação do Model pode continuar sua guerra santa sobre fine ou coarse grained. O Controller agora é dependente da View e dependente do Model. Ele observa a View e quando coisas interessantes acontecem que necessitam de atualização da UI, alimenta essa informação de volta aos receptáculos na View.

O Model não é diferente, conceitualmente, do design do MVC do Smalltalk.

Desenvolver o MVC da NeXT significa escrever controllers grandes e gordos, mas eles ainda são, na maior parte, encanamento. São apenas um encanamento mais complicado porque precisam entender a View e empurrar informações apropriadas a ela, alem de direcionar mensagens ao Model. Boas ferramentas (InterfaceBuilder no OS X é um descendente direto) foram criados para fazer disso algo trivial e, por sinal, funcionou tão bem que o NeXT ainda tem vários seguidores leais.

 ![](/files/model2-mvc.png)

Então, a Web aconteceu e a Sun começou a falar sobre o Model 2 em termos de MVC. Model2, basicamente, tenta recriar o MVC da NeXT para uma interface de usuário ruim (a web). Se pegarmos o sistema Model 2 canônico, Struts, a requisição Web vem para um Controller que é mapeada para uma Action. Esta precisa ser o encanamento como no controller NeXT — disparar a mensagem interessante para o Model (seu domain model), e disparar dados interessantes para a View (sua JSP, template velocity).

Como JSPs e templates não podem exatamente “receber” mensagens com os dados interessantes do model, os dados são acumulados em um FormBean e passados adiante, onde podem ser usados para preencher os slots nos templates. De modo similar, como templates não podem ser facilmente interrogados (bem, ele pode, mas não é agradável) pelo seu estado de uma maneira útil, o form bean é usado para passar informações dos eventos interessantes de UI para o controller. Ele tem um papel duplo.

Isso seguiu em frente, mas as pessoas não gostavam muito disso. Existem muito poucos componentes de interface de usuário para web que são bem acabadas, bem encapsuladas, caixas pretas. Pior, não existem maneira para esses componentes guardarem seu estado (ou seja, não mudar até que seja necessário). Isso significa que toda iformação necessária para redesenhar a interface do usuário precisa ser passada ao sistema de template toda vez que a interface precisa ser atualizada (toda chamada de página). Você não pode realmente usar algo como o drag-and-drop de um InterfaceBuilder com JSP (sim, existem algumas coisas que podem, vamos chegar lá), e puxar os pedaços interessantes envolve construir um model que será quase a mesma coisa que o domain model. Então, as pessoas tendem a apenas usar diretamente o domain model nas suas Views. É _muito_ mais fácil do que criar uma camada separada de DTO (Data Transfer Objects).

 ![](/files/model2_5-mvc.png)

Então, o aplicativo que resulta disso, que é supostamente para se parecer, logicamente pelo menos, como o MVC da NeXT, de fato possui dependência da View até o Model. Isso é tão mais útil e poderoso do que adicionar outra camada de mapeamento para mapear da classe _Foo_ para _FooUmPoucoDireferente_ que os aplicativos fazem isso mesmo. É quase sempre mais fácil mudar o template da view quando o model muda do que criar as camadas de mapeamento, e mudar essa camada quando o model muda.

Agora, temos, recentemente, mais algumas ferramentas, que conceitualmente derivam do estilo MVC da NeXT. Um dos candidatos é provavelmente o Tapestry, mas JSF e RIFE são candidados meio sucateados (WebObjects, da NeXT/Apple de fato tiveram a primeira ferramenta popular da web). O problema principal com o sistema Model2 é que não existiam componentes de View. Havia um template que não conseguia segurar estado, que precisava ser logicamente reconstruída toda hora, e que normalmente precisava ser totalmente consciente do Model para ser qualquer próxima de produtiva.

Essas ferramentas tem o conceito NeXT de componentes view ricas que são reusáveis entre aplicativos, um controller gordo que gerencia empurras dados ao redor, e um domain model que pode modelar o domínio do problema sem estar consciente de nada mais. Legal. Nada chegou perto da beleza do InterfaceBuilder ainda, mas fornecedores de JSF estão tentando.

Todos esses modelos são baseados em interfaces de usuário interativas, orientada a eventos (menu, mouse click, etc). A web na realidade é orientada a workflow (orientada a páginas). Muitos aplicativos se beneficiam de um design orientado a eventos, mas uma interface orientada a workflow (requisição == transição) se encaixa, em muitos casos (não a todos), mais logicamente ao modelo de páginas requisição/resposta da web (veja o Gmail para observar um aplicativo web não-workflow). Interfaces de usuário Workflow, num mundo de clientes ricos, envolve coisas como Wizards. Várias ferramentas tentam modelar isso (Seaside, Cocoon, Struts-Flow, RIFE — na realidade RIFE e Cocoon tem a idéia de componentes ricos também!) e existem muitas variações de design aqui, ainda.

Design de sistemas nesse mundo é um tanto diferente de design de sistemas em aplicativos orientados a eventos. Pegue a ferramenta certa para seu trabalho =)

