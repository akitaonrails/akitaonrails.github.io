---
title: "[Off-Topic] Agile: a Verdade por trás do Método"
date: '2014-09-28T23:18:00-03:00'
slug: off-topic-agile-a-verdade-por-tras-do-metodo
translationKey: off-topic-agile-a-verdade-por-tras-do-metodo
description: "Defendo que Scrum, XP e outras práticas Ágeis não salvam equipes ruins: elas expõem riscos e problemas rapidamente. Agilidade depende de pessoas comprometidas, prática contínua e mudanças concretas de comportamento."
tags:
- agile
- gestao
- engenharia-de-software
- off-topic
draft: false
---

Este ano, além da [discussão sobre TDD](http://www.akitaonrails.com/2014/08/23/small-bite-um-pouco-tarde-o-grande-debate-sobre-tdd) (que não está morto!), ninguém menos que um dos signatários do Manifesto Ágil, Dave Thomas, declarou a morte de "Ágil" como conhecemos hoje.

Alguns artigos que podem dar base ao resto da discussão:

* de Dave Thomas [Agile Is Dead (Long Live Agility)](https://pragdave.me/blog/2014/03/04/time-to-kill-agile/)
* de Richard Bishop [Agile Is Dead: The Angry Developer Version](http://web.archive.org/web/20140908134511/http://rubiquity.com/2014/03/12/agile-is-dead-angry-developer.html)
* de Giles Bowkett: [Why Scrum Should Basically Just Die In A Fire](http://gilesbowkett.blogspot.com/2014/09/why-scrum-should-basically-just-die-in.html)

Na minha empresa, desde a concepção, não usamos a palavra "Ágil", "Scrum" nem qualquer outro buzzword. Temos "sprints", sim, mas coisas como grooming e planning poker (brincadeira!) não são de jeito nenhum "impostas". As práticas são usadas, com ou sem os nomes, sempre que necessárias. Não gosto de usar "Scrum", "Kanban" ou qualquer outro rótulo, me dá uma leve vergonha mencionar esses nomes.

Para quem de fato aplica as práticas de agilidade no dia a dia, isso não é nenhuma novidade. Não há dúvidas sobre coisas como Collective Code Ownership (Github!), Continuous Integration (Jenkins, Travis, Semaphore, etc), Test Driven Development (Rspec, Jasmine, Capybara, etc), Refactoring, YAGNI, User Stories/Requirements/Use Cases (ou tanto faz a nomenclatura: basicamente, escopo). Veja os processos de projetos open source: em termos de práticas de programação, não é muito mais do que isso.

O problema é o processo: o gerenciamento de projeto em si. Fala-se muito em Waterfall vs Agile, mas isso é um grande bullshit. O que se lamenta é como o mundo das consultorias "especializadas" em "processos Ágeis" **prostituiu** a Agilidade.

E é verdade. É por isso que eu não "vendo" coisas como "implementação de metodologias", e na verdade não recomendo que ninguém contrate um terceiro para isso. Se precisar muito, avalie quanto de hands-on direto no código e no dia a dia o candidato realmente tem. A maioria acumula mais horas "verbais" do que de ação.

Neste artigo não vou dar a solução, isso fica para um próximo. Aqui quero apenas dizer a única grande verdade que ninguém avisa, e por isso qualquer tentativa de implementação vai falhar: a implementação de quaisquer práticas, processos e métodos Ágeis **exige** uma boa equipe, tanto programadores quanto gerentes e todo o resto.

"Boa equipe" significa uma equipe só de "sêniors"? Não. Exige gente comprometida com sua prática, sejam juniores ou sejam sêniores. Aliás, os que muitos hoje consideram "sêniores" ou "ninjas" (argh, seja porque palestram, seja pelos muitos anos de "experiência") são quase todos bem pouco comprometidos e meramente arrogantes. De novo, mais verbo do que ação.

Este ponto é crucial: muita gente vai tentar implementar "Ágil" na esperança de transformar uma equipe ruim, ou uma empresa ruim, em algo melhor. Isso não vai acontecer. No começo vai parecer que "melhorou" ou, pelo menos, que alguma coisa "mudou". Mas é óbvio: você está implementando algumas práticas meramente "diferentes", claro que por algum tempo alguma coisa vai mudar.

Programação é uma profissão de prática. Não dá para transformar um programador ruim num bom só adicionando métodos, da mesma forma que fazer um jogador de futebol novato assistir a um treinamento de dois dias nunca vai transformá-lo num fazedor-de-gols. Somente a prática árdua, ininterrupta, consistente, feita de pequenas melhorias contínuas, talvez o leve a ser um goleador. No meu cinismo, [eu disse diretamente a Bob Martin](http://www.akitaonrails.com/2010/06/16/railsconf-2010-video-entrevista-robert-martin) minha teoria sobre o que motivou Ken Schwaber a criar algo tão idiota quanto a Certificação de Scrum, na Railsconf 2010.

Quem programava nos anos 80 e 90 não viu nada tão disruptivo quando as descrições dos princípios e práticas chamados "Ágeis" apareceram no fim dos anos 90, até a publicação do manifesto em 2001. O que foi diferente é que finalmente alguém condensou tudo num pacote comercial marketável, principalmente o Scrum (que sozinho não inclui nenhuma das importantes práticas de programação do Extreme Programming). Quer ver como as práticas vêm evoluindo há muito mais tempo? Leia [The Cathedral and the Bazaar](http://www.amazon.com/Cathedral-Bazaar-Musings-Accidental-Revolutionary-ebook/dp/B0026OR3LM/ref=sr_1_1?s=books&ie=UTF8&qid=1411957445&sr=1-1&keywords=the+cathedral+and+the+bazaar) e [The Mythical Man Month](http://www.amazon.com/The-Mythical-Man-Month-Engineering-Anniversary/dp/0201835959).

Portanto não: implementar Scrum ou mesmo começar a implementar XP **não** vai salvar uma equipe ruim. Um ou outro, que já tinha pré-disposição, talento e vontade, vai conseguir se tornar ágil, depois de praticar, errar e praticar mais. Os outros, que não têm o talento nem a pré-disposição, ou pior ainda, são de fato mal-caráter, não vão mudar.

Nenhuma metodologia do mundo jamais vai mudar a personalidade de uma pessoa, pelo menos não em tão pouco tempo. Pense assim: a mãe dele não conseguiu fazer o cara deixar de ser preguiçoso e enrolador, você também não vai conseguir, e nem é essa a sua função. Sua função é entregar valor.

A verdade não dita do mundo Ágil é que a aplicação das práticas ágeis nasce naturalmente entre bons programadores já com experiência. Ela não será útil numa equipe novata, que ainda precisa praticar muito, com ou sem princípios ágeis.

Eu disse que basta ver como funciona o mundo open source. Ao contrário do que muitos brasileiros novatos imaginam, open source não tem nada, a princípio, a ver com inclusão ou movimentos esquerdistas. Eu resumiria open source como "a forma capitalista mais eficiente de se manter commodities". Ele é altamente exclusivo para desenvolvedores.

Sem nenhum vínculo empregatício, de forma puramente voluntária, os interesses giram em torno de marketing: exposição da empresa, exposição do desenvolvedor, redução de custos, oportunidades. Você realmente precisa ser "bom" para se manter no topo da lista. A opinião de todo mundo tem o mesmo peso? [Pergunte a Linus Torvalds](http://linux.slashdot.org/story/13/07/15/2316219/kernel-dev-tells-linus-torvalds-to-stop-using-abusive-language) o que ele faz quando uma ideia ruim aparece.

O mundo open source expõe problemas imediatamente. Só porque você acha o seu projeto "legal" isso não se traduz automaticamente em voluntários e exposição. A taxa de projetos que morrem é ordens de grandeza maior do que a de projetos que ganham tração. Comparado ao mundo comercial, o open source mata projetos muito mais rápido.

Ágil foi feito para **expor** os problemas o quanto antes. Entenda: as práticas Ágeis são mecanismos de exposição de problemas! Ágil é um mecanismo de redução e gerenciamento de **Risco**! Encontrar os obstáculos no momento em que acontecem e tratá-los imediatamente para mitigar riscos futuros desnecessários, que só levam a desperdício.

Só que ninguém quer fazer isso. Se o problema for o gerente, que consultoria vai conseguir removê-lo do cargo, a menos que o dono acima dele esteja comprometido em cortar na própria carne? Se o problema é o programador mal-caráter que todo mundo gosta (o tipo mais perigoso: o que sabe se articular e criar zonas de influência entre pares e superiores), como mandar esse cara embora?

Sim: consertar uma equipe em pouco tempo significa **necessariamente** substituir seus membros. No pior dos casos, trocar todos eles. Se o método for bem aplicado, ele imediatamente demonstra e expõe os problemas. E como na grande maioria dos casos o problema está no comportamento, e não na prática, é preciso resolver na hora. Se você, stakeholder e responsável pela sua empresa, não está mandando ninguém embora depois de começar a implementar Ágil, está fazendo errado.

E aqui está o grande problema: ninguém entende esse compromisso. Não há almoço de graça. Não há como fazer omeletes sem quebrar alguns (ou todos) os ovos. Sem esse entendimento e esse compromisso, não há agilidade. Aliás, não é a primeira vez que eu digo isso, se você leu meu artigo de 2009: [Net Negative Producing Programmer](http://www.akitaonrails.com/2009/03/30/off-topic-net-negative-producing-programmer). Mas como a maioria parece ainda não ter entendido, resolvi deixar mais claro.

Esta foi uma introdução. Dependendo dos comentários, talvez eu desça mais alguns degraus para explicar exatamente os mecanismos do que apresentei muito rapidamente aqui.
