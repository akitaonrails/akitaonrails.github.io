---
title: 'Tradução: Scrum Flácido'
date: '2009-02-03T03:32:00-02:00'
slug: tradu-o-scrum-fl-cido
translationKey: tradu-o-scrum-fl-cido
description: "Tradução do 'Flaccid Scrum', de Martin Fowler: adotar Scrum sem práticas técnicas afunda o time numa base de código bagunçada. Comento testes, refatoração, integração frequente e propriedade coletiva."
tags:
- agile
- engenharia-de-software
- testes
- off-topic
draft: false
---

5 dias atrás, Martin Fowler [publicou um artigo](http://martinfowler.com/bliki/FlaccidScrum.html) que pode soar polêmico para Scrummers. O alvo dele, porém, é quem aplica Scrum da maneira errada e quem não se preocupa em tornar esse problema aparente. A seguir, a tradução do artigo na íntegra; no final, comentários meus.

[![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/Picture_1.png)](http://martinfowler.com/bliki/FlaccidScrum.html)

Existe uma bagunça que eu ouço em muitos projetos recentemente. Funciona assim:

- Eles querem usar um processo ágil, e escolhem Scrum
- Eles adotam as práticas Scrum, e talvez até os princípios
- Depois de um tempo o progresso é lento porque a **base de código é uma bagunça**

O que acontece é que eles não prestaram atenção à **qualidade interna** de seu software. Se você cometer esse erro irá rapidamente descobrir que seu progresso foi desacelerado porque é muito difícil adicionar novas funcionalidades que você gostaria. Você caiu no problema de [Dívida Técnica](http://martinfowler.com/bliki/TechnicalDebt.html) e seu scrum caiu de joelhos. (E se você esteve num scrum real, saberá que isso é uma Coisa Ruim).

Mencionei Scrum porque quando vemos esse problema, Scrum parece ser particularmente comum como o processo nominativo que a equipe segue. Para muitas pessoas, a situação é exacerbada pelo Scrum porque Scrum é um processo centrado em técnicas de gerenciamento de projetos e deliberadamente omite qualquer prática técnica, em contraste (por exemplo) com Extreme Programming.

Defendendo o Scrum, é importante apontar que só porque ele não inclui nenhuma atividade técnica dentro de seu escopo isso não deve levar ninguém a concluir que ele não acha isso importante. Sempre que ouvi Scrummers prominentes eles sempre enfatizaram que você deve ter **boas práticas técnicas** para ter sucesso com um projeto Scrum. Eles não dizem quais práticas técnicas devem ser, mas você precisa delas. Afinal projetos enfrentam problemas por causa de qualidade interna pobre o tempo todo, e o fato que muitos entram abaixo da bandeira do Scrum parece ser mais pelo fato de Scrum ser popular no momento do que qualquer coisa particular no Scrum. Popularidade e [Difusão Semântica](http://martinfowler.com/bliki/SemanticDiffusion.html) tendem a andar juntos.

Então, o que fazer a respeito?

A comunidade Scrum precisa redobrar seus esforços em garantir que as pessoas entendam a importância de práticas técnicas fortes. Certamente qualquer tipo de revisão de projeto deve incluir o exame de quais práticas técnicas estão presentes. Se você estiver envolvido ou conectado a esse tipo de projeto, faça um barulho se o lado técnico estiver sendo negligenciado.

Se estiver introduzindo Scrum, garanta que está prestando atenção às práticas técnicas. Tendemos a aplicar muitas do Extreme Programming e elas se encaixam muito bem. Os XPers costumam brincar que, com alguma justificativa, Scrum é apenas XP sem as práticas técnicas que o fazem funcionar. Provocações à parte, as práticas de XP são um bom ponto de partida – e certamente serão muito melhores do que nada.

Eu sempre gosto de apontar que não são metodologias que levam ao sucesso ou fracasso. Usar um processo pode ajudar uma equipe a subir no jogo, mas no fim é a equipe que importa e que carrega a responsabilidade de fazer o que funciona para elas. Estou certo que muitos dos projetos Scrum Flácidos em andamento prejudicarão a reputação do Scrum, e provavelmente a reputação maior de Ágil. Mas já que vejo [Difusão Semântica](http://martinfowler.com/bliki/SemanticDiffusion.html) como algo inevitável não estou desproporcionadamente alarmado. Equipes que fracassam provavelmente vão fracassar seja qual for a metodologia que apliquem mal; equipes que têm sucesso construirão suas práticas sobre boas ideias e o papel da comunidade scrum é espalhar essas boas ideias.

Muitas pessoas estão olhando para Lean como a _Próxima Grande Coisa Ágil_. Mas quanto mais popular lean se tornar mais vai incorrer nos mesmos problemas que Scrum está enfrentando agora mesmo. Isso não torna Lean (ou Scrum) sem valor, apenas nos lembra que Indivíduos e Interações são mais valiosos que Processos e Ferramentas.

### Observações do Akita

Na prática, o que percebo é que as partes de planejamento e gerenciamento encontram menos resistência na implementação: [User Stories](http://www.extremeprogramming.org/rules/userstories.html), [Release Planning](http://www.extremeprogramming.org/rules/planninggame.html), [Small Releases](http://www.extremeprogramming.org/rules/releaseoften.html), [Project Velocity](http://www.extremeprogramming.org/rules/velocity.html), [Iterations](http://www.extremeprogramming.org/rules/iterative.html), [Iteration Planning](http://www.extremeprogramming.org/rules/iterationplanning.html), [Stand Up Meeting](http://www.extremeprogramming.org/rules/standupmeeting.html). A razão é simples. Quando uma empresa decide adotar Scrum, a decisão veio de algum nível de cima; sem isso, nem sai do papel. E gerentes e chefes costumam entender e engolir esses conceitos razoavelmente bem, principalmente se já passaram por metodologias tradicionais de gerenciamento de projeto sem êxito.

E é aqui que a maioria **erra**: se a equipe ainda não tem maturidade para ser autogerenciável, ou seja, para gerar código de qualidade de maneira independente, é obrigação da alta chefia liderar nessa direção. Isso é difícil porque muitos gerentes não são técnicos, o que os deixa alheios ao problema da falta de boas práticas técnicas.

A bagunça a que Martin Fowler se refere está no design, na codificação e nos testes. Quem mais tem dificuldade com essas práticas é o desenvolvedor que veio dos jeitos antigos de desenvolver, no estilo "cowboy suicida", ou que tem pouca experiência e pouco estudo de desenvolvimento de software em geral.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/22124.jpg)

A maioria dos desenvolvedores não entende [Simplicidade](http://www.extremeprogramming.org/rules/simple.html), o famoso "fazer a coisa mais simples que funciona", ou [YAGNI](http://en.wikipedia.org/wiki/You_Ain%27t_Gonna_Need_It) (You Ain't Gonna Need It). Nos mais jovens, o espírito "cowboy" é difícil de domar: querem sempre fazer as coisas de forma mais complexa do que precisam. Isso leva justamente ao problema de [adicionar coisas cedo demais](http://www.extremeprogramming.org/rules/early.html), complexidade pelo prazer da complexidade. A equipe precisa se autopoliciar contra isso. Felizmente as [Spike Solutions](http://www.extremeprogramming.org/rules/spike.html) ajudam: a equipe para um instante, entende o problema e estuda alternativas de solução.

Outra confusão que já vi muito é misturar [Refactoring](http://www.extremeprogramming.org/rules/refactor.html) com Rewrite. Rewrite em si não é um problema, mas se torna um quando aplicado com a noção de "só porque é novo, é melhor". Antes de mais nada, Refactoring é uma série de técnicas que tem como objetivo rejuvenescer o código, torná-lo mais gerenciável, sem modificar seu comportamento.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/cowboy.jpg)

Isso leva ao calcanhar de aquiles da maioria dos desenvolvedores amadores: a aversão a testes. _"Sou bom demais para errar, não preciso de testes."_ É o desenvolvedor que efetivamente levará seu trabalho ao fracasso certo. [Testar antes](http://www.extremeprogramming.org/rules/testfirst.html) é uma maneira efetiva de refinamento do design e também leva à simplicidade, fazendo apenas o que realmente se precisa.

Sem bons testes, é impossível fazer um refactoring efetivo: como você garante que a mudança não alterou o comportamento do código? O corolário disso é que esses desenvolvedores também **não** praticam Refactoring, o que leva à massa de código bagunçado. A ironia é que até em rewrites, onde se assumiu que o novo seria melhor, o código acaba virando um "legado" bem rápido.

Pior ainda, quando um [bug é encontrado](http://www.extremeprogramming.org/rules/bugs.html), raramente se criam testes para evitar a regressão ao mesmo bug. E todos já devem ter visto bugs que supostamente já estavam corrigidos retornando pouco tempo depois. Outro problema é que muitas equipes não encontraram uma boa definição de "história finalizada" e portanto também têm dificuldade em manter [testes de aceitação](http://www.extremeprogramming.org/rules/functionaltests.html) dessas histórias. Uma das razões: em vez de escreverem User Stories ("como X, quero Y por causa de Z", definindo o que implementar, para quem e qual valor isso traz), escrevem tarefas ("fazer X"), pulando o para quem e o porquê.

Ainda no espírito de "cowboy", programadores sem experiência não entendem o conceito de [propriedade coletiva do código](http://www.extremeprogramming.org/rules/collective.html). O que acontece é que cada desenvolvedor tenta se limitar apenas ao código que ele acha que é responsabilidade dele e não se preocupa com o todo. Deveria acontecer o contrário: todo desenvolvedor tem que se sentir responsável por todo o código. Isso também explica mais um motivo da importância de testes unitários: sem eles é impossível ajudar em código que você não fez, e impossível saber se seu próprio código não quebra algo que outra pessoa fez. Em resumo: isso leva a um acúmulo imensurável de "Dívida Técnica" que só se vê quando já é tarde demais, tornando seu "novo sistema", prematuramente, um "legado" ingerenciável.

Nesse mesmo espírito, os desenvolvedores "cowboys" não [integram com frequência](http://www.extremeprogramming.org/rules/integrateoften.html) como deveriam. Não é raro ver desenvolvedores que passam a semana toda com código novo apenas na própria máquina e só no final da semana fazem o commit no repositório e consideram terminado. Nada de criar testes, nada de rodar a suíte completa de testes. Mais um desenvolvedor criando Dívida Técnica deliberadamente.

Para piorar, não é difícil encontrar equipes que sequer entendem o valor de um repositório: para elas, basta alterar direto no servidor de produção ou editar arquivos diretamente lá. É a pré-história do desenvolvimento. Um repositório de versionamento de código é mandatório, e tratá-lo como um santuário é a maior responsabilidade de uma equipe. Isso significa que todo código no repositório deve ser sempre código sem nenhum problema acrescentado de forma deliberada, por não fazer testes, não integrar frequentemente, não refatorar onde precisa. Bugs sempre vão existir e devem ser corrigidos, mas erros deliberados tornam o desenvolvedor um irresponsável e um problema para toda a equipe.

Finalmente, é comum ver desenvolvedores que se acham muito espertos [otimizando](http://www.extremeprogramming.org/rules/optimize.html) muito cedo no projeto, baseados apenas em "chute", sem medições. Aliás, a maioria dos programadores que conheci tem aversão a medições tanto quanto tem aversão a testes. E otimizar sem estar baseado em métrica é a mais pura perda de tempo. Você pode fazer um certo trecho de código ficar 100 vezes mais rápido, mas se no tempo geral isso não representa um ganho nem de 0,5%, foi uma perda de tempo. Novamente, falta de experiência.

Ainda sobre os "cowboys suicidas", normalmente eles são apegados às suas limitadas ferramentas, às quais já estão acostumados. Têm preguiça de aprender coisas novas, seja por incapacidade ou por falta de vontade, e sempre tentam ir pelo caminho aparentemente mais fácil, como usar geradores automáticos de código, que geralmente geram código difícil de dar manutenção e fora dos padrões mais modernos aceitos como boas práticas.

No final, o resultado é o mesmo: desenvolvedores inexperientes que acham que sabem tudo, ou desenvolvedores com muito tempo de casa viciados em anti-práticas e teimosos demais para aprender as boas práticas. Montar uma equipe eficiente e verdadeiramente ágil de desenvolvimento é muito difícil. E a realidade é que simplesmente nem todo mundo serve para o trabalho. Um desenvolvedor ágil é alguém proativo, autodidata, sociável e comunicativo. E tudo isso é mais importante que sua suposta competência técnica.

PS: algumas pessoas podem achar que isso é algo direto a elas. Mas na realidade, isso é mais comum do que se imagina, já vi em muitos clientes e vou continuar vendo. Sendo justo, eu mesmo já fiz muito projeto (mais do que gostaria) que imediatamente se tornou um "legado", um código mal testado e difícil de manter. Reclamar é fácil, fazer algo para melhorar é que é o difícil. E o desenvolvedor cowboy de ontem tem todas as condições de se tornar um bom programador amanhã, basta querer.
