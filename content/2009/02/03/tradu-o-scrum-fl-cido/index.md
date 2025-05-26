---
title: 'Tradução: Scrum Flácido'
date: '2009-02-03T03:32:00-02:00'
slug: tradu-o-scrum-fl-cido
tags:
- off-topic
- agile
- management
- translation
draft: false
---

5 dias atrás, Martin Fowler [escreveu um artigo](http://martinfowler.com/bliki/FlaccidScrum.html) que pode ser um pouco polêmico para Scrummers, mas não vejam isso como uma crítica ao Scrum e sim como uma crítica a quem aplica Scrum da maneira errada e a quem não se preocupar em tornar isso aparente. A seguir eu traduzi o artigo dele na íntegra, e no final coloquei alguns comentários meu mesmo.


[![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/Picture_1.png)](http://martinfowler.com/bliki/FlaccidScrum.html)

Existe uma bagunça que eu ouço em muitos projetos recentemente. Funciona assim:

- Eles querem usar um processo ágil, e escolhem Scrum
- Eles adotam as práticas Scrum, e talvez até os princípios
- Depois de um tempo o progresso é lento porque a **base de código é uma bagunça**

O que acontece é que eles não prestaram atenção à **qualidade interna** de seu software. Se você cometer esse erro irá rapidamente descobrir que seu progresso foi desacelerado porque é muito difícil adicionar novas funcionalidades que você gostaria. Você caiu no problema de [Débito Técnico](http://martinfowler.com/bliki/TechnicalDebt.html) e seu scrum caiu de joelhos. (E se você esteve num scrum real, saberá que isso é uma Coisa Ruim).

Mencionei Scrum porque quando vemos esse problema, Scrum parece ser particularmente comum como o processo nominativo que a equipe segue. Para muitas pessoas, a situação é exacerbada pelo Scrum porque Scrum é um processo centrado em técnicas de gerenciamento de projetos e deliberadamente omite qualquer prática técnica, em contraste (por exemplo) com Extreme Programming.

Defendendo o Scrum, é importante apontar que só porque ele não inclui nenhuma atividade técnica dentro de seu escopo isso não deve levar ninguém a concluir que ele não acha isso importante. Sempre que ouvi Scrummers prominentes eles sempre enfatizaram que você deve ter **boas práticas técnicas** para ter sucesso com um projeto Scrum. Eles não dizem quais práticas técnicas devem ser, mas você precisa delas. Afinal projetos enfrentam problemas por causa de qualidade interna pobre o tempo todo, e o fato que muitos entram abaixo da bandeira do Scrum parece ser mais pelo fato de Scrum ser popular no momento do que qualquer coisa particular no Scrum. Popularidade e [Difusão Semântica](http://martinfowler.com/bliki/SemanticDiffusion.html) tendem a andar juntos.

Então, o que fazer a respeito?

A comunidade Scrum precisa redobrar seus esforços em garantir que as pessoas entendam a importância de práticas técnicas fortes. Certamente qualquer tipo de revisão de projeto deve incluir o exame de quais práticas técnicas estão presentes. Se você estiver envolvido ou conectado a esse tipo de projeto, faça um barulho se o lado técnico estiver sendo negligenciado.

Se estiver apresentando Scrum, garanta que está prestando atenção às práticas técnicas. Tendemos a aplicar muitas do Extreme Programming e eles se encaixam muito bem. Os XPers costumam brincar que, com alguma justificativa, Scrum é apenas XP sem as práticas técnicas que a fazem funcionar. De qualquer forma, as práticas de XP são um bom ponto para se começar – e certamente serão muito melhores do que nada.

Eu sempre gosto de apontar que não são metodologias que levam ao sucesso ou fracasso. Usar um processo pode ajudar uma equipe a subir no jogo, mas no fim é a equipe que importa e que carrega a responsabilidade de fazer o que funciona para elas. Estou certo que muitos dos projetos Scrum Flácidos em andamento prejudicarão a reputação do Scrum, e provavelmente a reputação maior de Ágil. Mas já que vejo [Difusão Semântica](http://martinfowler.com/bliki/SemanticDiffusion.html) como algo inevitável não estou desproporcionadamente alarmado. Equipes que fracassam provavelmente vão fracassar seja lá qual metodologias eles – erradamente – apliquem, equipes que tem sucesso construirão suas práticas sobre boas idéias e o papel da comunidade scrum é espalhar essas boas idéias.

Muitas pessoas estão olhando para Lean como a _Próxima Grande Coisa Ágil_. Mas quanto mais popular lean se tornar mais vai incorrer nos mesmos problemas que Scrum está enfrentando agora mesmo. Isso não torna Lean (ou Scrum) sem valor, apenas nos lembra que Indivíduos e Interações são mais valiosos que Processos e Ferramentas.

### Observações do Akita

Em termos práticos, no meu caso, já percebi que coisas de planejamento e gerenciamento como [User Stories](http://www.extremeprogramming.org/rules/userstories.html), [Release Planning](http://www.extremeprogramming.org/rules/planninggame.html), [Small Releases](http://www.extremeprogramming.org/rules/releaseoften.html), [Project Velocity](http://www.extremeprogramming.org/rules/velocity.html), [Iterations](http://www.extremeprogramming.org/rules/iterative.html), [Iteration Planning](http://www.extremeprogramming.org/rules/iterationplanning.html), [Stand Up Meeting](http://www.extremeprogramming.org/rules/standupmeeting.html), são as partes que parecem ter menos resistência de implementação. A razão é que, quando uma empresa decide adotar Scrum, já é algo que veio de algum nível de cima para baixo – ou não seria implementado. E gerentes e chefes costumam entender e engolir esses conceitos mais ou menos bem, especialmente se já passaram por metodologias tradicionais de gerenciamento de projeto sem êxito. E é aqui onde a maioria **erra** : se as equipes ainda não tem maturidade para serem auto-gerenciável (ou seja, gerar código de qualidade de maneira independente) é obrigação da alta chefia liderar para essa direção. Isso é difícil porque muitos gerentes não são técnicos, o que os torna alienados ao problema do não uso das boas práticas técnicas.

A bagunça a que Martin Fowler se refere está no Design, Codificação e Testes. A maioria dos desenvolvedores que: 1) veio de jeitos antigos de desenvolvimento (ex. estilo “cowboy suicida”); 2) têm pouca experiência e estudo de desenvolvimento de software em geral; tem dificuldade de entender essas práticas.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/22124.jpg)

A maioria dos desenvolvedores não entende [Simplicidade](http://www.extremeprogramming.org/rules/simple.html), o famoso “fazer a coisa mais simples que funciona” ou [YAGNI](http://en.wikipedia.org/wiki/You_Ain%27t_Gonna_Need_It) (You Ain’t Gonna Need it). Especialmente se são jovens, o espírito “cowboy” é difícil de domar e sempre querem fazer as coisas de forma mais complexa do que precisam. Isso leva justamente ao problema de [adicionar coisas cedo demais](http://www.extremeprogramming.org/rules/early.html), ou complexidade pelo prazer da complexidade. A equipe precisa de auto-policiar contra isso. Felizmente [Spike Solutions](http://www.extremeprogramming.org/rules/spike.html) não parece tão ruim hoje em dia, onde a equipe pára um instante, entende o problema e estuda alternativas de solução. Outro problema, por muitas vezes já vi pessoas confundirem [Refactor](http://www.extremeprogramming.org/rules/refactor.html) com [Rewrite](http://www.neilgunton.com/doc/rewrites_harmful). Rewrite em si não é um problema, mas se torna um problema se aplicado com a noção de “só porque é novo, é melhor”. Antes de mais nada, Refactoring é uma série de técnicas que tem como objetivo rejuvenescer o código, torná-lo mais gerenciável, sem modificar seu comportamento.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/2/3/cowboy.jpg)

Isso leva ao calcanhar de aquiles da maioria dos desenvolvedores amadores: a aversão à testes. _“Sou bom demais para errar, não preciso de testes.”_ É o desenvolvedor que efetivamente levará seu trabalho ao fracasso certo. [Testar antes](http://www.extremeprogramming.org/rules/testfirst.html) é uma maneira efetiva de refinamento do design e também leva à Simplicidade, fazendo apenas o que realmente se precisa. Sem bons testes, é impossível fazer um refactoring efetivo pois como você pode garantir que a mudança não levou a mudança no comportamento do código. O corolário disso é que os desenvolvedores também **não** praticam Refactoring, o que leva à massa de código bagunçado. A ironia disso é que até em rewrites – onde se assumiu que o novo seria melhor – acaba se tornando um “legado” bem rápido.

Pior ainda, quando um [bug é encontrado](http://www.extremeprogramming.org/rules/bugs.html), raramente se criam testes para evitar a regressão ao mesmo bug. E todos já devem ter visto bugs que supostamente já estavam corrigidos retornando pouco tempo depois. Outro problema é que muitas equipes não encontraram uma boa definição para o “história finalizada” e portanto também tem dificuldades em ter e manter [testes de aceitação](http://www.extremeprogramming.org/rules/functionaltests.html) dessas histórias. Uma das razões disso são equipes que, em vez de escreverem User Stories (“como X, quero Y por causa de Z”, definindo o que implementar, para quem e qual valor isso trás), escrevem Tarefas (“fazer X”, pulando para quem é e qual valor isso trás).

Ainda no espírito de “cowboy”, novamente, programadores sem experiência, não entendem o conceito de [propriedade coletiva do código](http://www.extremeprogramming.org/rules/collective.html). O que acontece é que cada desenvolvedor tenta se limitar apenas ao código que ele acha que é responsabilidade dele e não se preocupa com o todo. Porém o contrário deveria acontecer: todo desenvolvedor tem que se sentir responsável por todo o código. Isso também explica mais um motivo da importância de testes unitários: sem eles é impossível ajudar em código que você não fez, também é impossível saber se seu próprio código não quebra algo que outra pessoa fez. Em resumo: isso leva a um acúmulo imensurável de “Débito Técnico” que só se vê quando já é tarde demais, tornando seu “novo sistema”, prematuramente um “legado” ingerenciável. Ainda nesse espírito, os desenvolvedores “cowboys” não [integram com frequência](http://www.extremeprogramming.org/rules/integrateoften.html) como deveriam. Não é raro ver desenvolvedores que fazem um novo trecho de código a semana toda apenas na sua máquina e só no final da semana apenas fazem o commit no repositório e consideram terminado. Nada de criar testes, nada de rodar a suíte completa de testes. Mais um desenvolvedor criando Débito Técnico deliberadamente.

Para piorar, não é difícil encontrar equipes que sequer entendem o valor de um repositório: para eles, basta alterar direto no servidor de produção ou editar arquivos diretamente lá. É a pré-história do desenvolvimento. Um repositório de versionamento de código não é opcional: é mandatório. Tratá-lo como um santuário é a maior responsabilidade de uma equipe e isso significa que todo código no repositório deve ser sempre código sem absolutamente nenhum problema que foi acrescentado de forma deliberada (por não fazer testes, não integrar frequentemente, não refatorar onde precisa, etc). Bugs sempre vão existir e devem ser corrigidos, mas erros deliberados torna o desenvolvedor um irresponsável e um problema à toda a equipe.

Finalmente, é comum ver desenvolvedores que se acham muito espertos [otimizando](http://www.extremeprogramming.org/rules/optimize.html) muito cedo no projeto, baseado apenas em “chute”, sem medições. Aliás, a maioria dos programadores que conheci tem aversão à medições tanto quanto tem aversão à testes. E otimizar sem estar baseado em métrica é a mais pura perda de tempo. Você pode fazer um certo trecho de código ficar 100 vezes mais rápido, mas se no tempo geral isso não representa um ganho nem de 0.5%, foi uma perda de tempo. Novamente, falta de experiência.

Ainda sobre os “cowboys suicidas”, normalmente eles são apegados às suas – limitadas – ferramentas, às quais estão já acostumados, tem preguiça – incapacidade, ou falta de vontade – de aprender coisas novas, e sempre tentam ir pelo caminho imediatamente – e aparentemente – mais fácil, como usar geradores automáticos de código, que geralmente geram código difícil de dar manutenção e também normalmente fora dos padrões mais modernos aceitos como boas práticas.

No final, o resultado é o mesmo: desenvolvedores inexperientes que acham que sabem tudo, ou desenvolvedores com muito tempo de casa viciados em anti-práticas e teimosos demais para aprender as boas práticas. Montar uma equipe eficiente e verdadeiramente Ágil de desenvolvimento é muito difícil. E a realidade é que simplesmente nem todo mundo serve para o trabalho. Um desenvolvedor Ágil é alguém pró-ativo, autodidata, sociável e comunicativo. E tudo isso é mais importante que sua suposta competência técnica.

PS: algumas pessoas podem achar que isso é algo direto e elas. Mas na realidade, isso é mais comum do que se imagina, já vi em muitos clientes e vou continuar vendo. Sendo justo, eu mesmo já fiz muito projeto (mais do que gostaria) que imediatamente se tornou um “legado”, um código mal testado e difícil de manter. Reclamar é fácil, fazer algo para melhorar é que é o difícil, e o desenvolvedor cowboy de ontem tem todas as condições de se tornar um bom programador amanhã, basta querer.

