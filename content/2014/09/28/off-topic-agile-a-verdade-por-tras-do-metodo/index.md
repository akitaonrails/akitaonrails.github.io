---
title: "[Off-Topic] Agile: a Verdade por trás do Método"
date: '2014-09-28T23:18:00-03:00'
slug: off-topic-agile-a-verdade-por-tras-do-metodo
tags:
- off-topic
- principles
- management
- career
- agile
- carreira
draft: false
---

Este ano, além da [discussão sobre TDD](http://www.akitaonrails.com/2014/08/23/small-bite-um-pouco-tarde-o-grande-debate-sobre-tdd) (que não está morto!), ninguém menos que o próprio signatário do Manifesto Ágil, Dave Thomas, declarou a morte de "Ágil" como conhecemos hoje.

Alguns artigos que podem dar base ao resto da discussão:

* de Dave Thomas [Agile Is Dead (Long Live Agility)](http://pragdave.me/blog/2014/03/04/time-to-kill-agile/)
* de Richard Bishop [Agile Is Dead: The Angry Developer Version](http://rubiquity.com/2014/03/12/agile-is-dead-angry-developer.html)
* de Giles Bowkett: [Why Scrum Should Basically Just Die In A Fire](http://gilesbowkett.blogspot.com.br/2014/09/why-scrum-should-basically-just-die-in.html)

Na minha empresa, desde sua concepção, não usamos a palavra "Ágil", "Scrum" nem nenhum buzzword. Temos sim, "sprints", mas coisas como grooming, planning poker (brincadeira!), e outros "rituais" não são de jeito nenhum "impostos", mas as práticas são usadas (com ou sem os nomes), sempre que necessárias. Não gosto de usar a palavra "Scrum", "Kanban" ou qualquer outro, me dá uma leve vergonha de mencionar esses nomes.

Para quem de fato aplica as práticas de agilidade no dia a dia, isso não é nenhuma novidade. Não há dúvidas sobre coisas como Collective Code Ownership (Github!), Continuous Integration (Jenkins, Travis, Semaphore, etc), Test Driven Development (Rspec, Jasmine, Capybara, etc), Refactoring, YAGNI, User Stories/Requirements/Use Cases (ou tanto faz a nomenclatura: basicamente, escopo). Veja os processos de projetos open source: em termos de práticas de programação, não é muito mais do que isso.

O problema é o processo: o gerenciamento de projeto em si. Fala-se muito em Waterfall vs Agile, mas isso é um grande bullshit. O que se lamenta muito é como o mundo das consultorias "especializadas" em "processos Ágeis" **prostituiu** a Agilidade. E é verdade, é por isso que eu não "vendo" coisas como "implementação de metodologias", na verdade eu não recomendo que ninguém tente contratar um terceiro para isso. Se precisar muito, avalie quanto de hands-on direto no código e no dia-a-dia o candidato que você quer contratar realmente tem. A maioria tem mais horas "verbais" do que de ação.

Neste artigo não vou dar a solução (fica para um próximo), neste quero apenas dizer a única grande verdade que ninguém avisa e por isso qualquer tentativa de implementação vai falhar: a implementação de quaisquer práticas, processos e métodos Ágeis **exige** uma boa equipe, tanto programadores quanto gerentes e tudo mais. "Boa equipe" significa uma equipe só de "sêniors"? Não: exige pessoas comprometidas com sua prática, sejam juniores ou sejam sêniores. E, aliás, os que muitos hoje consideram como "sêniores" ou "ninjas" (argh - seja porque palestram, tem muitos anos de "experiência") são quase todos bem pouco comprometidos e meramente arrogantes. Novamente, mais verbal do que ação.

Este ponto é crucial: muita gente que tentar implementar "Ágil" na esperança de transformar uma equipe ruim, ou uma empresa ruim, em algo melhor. Isso não vai acontecer. No começo vai parecer que "melhorou" ou, pelo menos, que alguma coisa "mudou". Mas é óbvio, você está implementando algumas práticas meramente "diferentes", claro que por algum tempo alguma coisa vai mudar.

Programação é uma profissão de prática. Não há como transformar um programador ruim num bom meramente adicionando métodos, da mesma forma que fazer um jogador de futebol novato assistir um treinamento de 2 dias nunca vai transformá-lo num fazedor-de-gols. Somente a prática, árdua, ininterrupta, consistente, de pequenas melhorias contínuas e constantes, vai - talvez! - levá-lo a ser um goleador. No meu cinismo, [eu disse diretamente a Bob Martin](http://www.akitaonrails.com/2010/06/16/railsconf-2010-video-entrevista-robert-martin) sobre minha teoria pra motivação do Ken Schwaber criar algo tão idiota quanto a Certificação de Scrum na Railsconf 2010.

Programadores que praticaram durantes os anos 80 e 90, quando vimos as descrições dos princípios e práticas chamadas "Ágeis" durante o fim dos anos 90 até a publicação do manifesto em 2001, não vimos nada tão disruptivo. O que foi diferente é que finalmente alguém condensou tudo num pacote comercial marketável, principalmente o Scrum (que em si só, não inclui nenhuma das importantes práticas de programação do Extreme Programming). Quer ver como as práticas vem evoluindo a muito mais tempo? Leia [The Cathedral and the Bazaar](http://www.amazon.com/Cathedral-Bazaar-Musings-Accidental-Revolutionary-ebook/dp/B0026OR3LM/ref=sr_1_1?s=books&ie=UTF8&qid=1411957445&sr=1-1&keywords=the+cathedral+and+the+bazaar) e [The Mythical Man Month](http://www.amazon.com/The-Mythical-Man-Month-Engineering-Anniversary/dp/0201835959).

Portanto não: implementar Scrum ou mesmo começar a implementar XP **Não** vai salvar uma equipe ruim. Um ou outro, que já tinha pré-disposição, talento e vontade, vão conseguir se tornar ágeis, depois de praticar, errar, e praticar mais. Outros, que não tem o talento, nem a pré-disposição ou - pior ainda - são de fato mal caráteres, não vão mudar. Nenhuma metodologia do mundo jamais vai mudar a personalidade de uma pessoa, pelo menos não em tão pouco tempo. Pense assim: a mãe dele não conseguiu fazer o cara não ser preguiçoso e enrolador, você não vai conseguir, e nem é essa sua função. Sua função é entregar valor.

A verdade não dita do mundo Ágil é que a aplicação das práticas ágeis nasce naturalmente entre bons programadores já com experiência. Ela não será útil numa equipe novata - que precisa praticar muito ainda, com ou sem princípios ágeis.

Eu disse que basta ver como funciona o mundo open source. Ao contrário do que muitos brasileiros (novatos) imaginam, open source não tem nada, a princípio, nada a ver com inclusão, movimentos esquerdistas. Na verdade eu resumiria open source como "a forma capitalista mais eficiente de se manter commodities". Ela não é inclusiva: é altamente exclusiva para desenvolvedores. Em não tendo nenhum vínculo empregatício, sendo puramente voluntário, os interesses estão em volta de marketing (exposição da empresa, exposição de desenvolvedores, diminuição de custos, oportunidades) e você realmente precisa ser "bom" para se manter no topo da lista. As opiniões de todos não são automaticamente válidas, pelo contrário, [pergunte a Linus Torvalds](http://linux.slashdot.org/story/13/07/15/2316219/kernel-dev-tells-linus-torvalds-to-stop-using-abusive-language) o que ele faz quando uma idéia ruim aparece. O mundo open source expõe problemas imediatamente: só porque você acha que seu projeto é "legal", não vai automaticamente se traduzir em voluntários e exposição. Na verdade, a taxa de projetos que morrem é ordens de grandeza maior do que projetos que ganham exposição. O mundo open source, ao contrário do mundo comercial, mata projetos muito mais rapidamente.

Ágil foi feito para **expor** os problemas o quanto antes. Entenda: as práticas Ágeis são mecanismos de exposição de problemas! Ágil é um mecanismo de redução e gerenciamento de **Risco**! Encontrar os obstáculos no momento em que eles acontecem, e tratá-los imediatamente para mitigar riscos futuros desnecessários - que levam a desperdícios.

Só que ninguém quer fazer isso. Se o problema for o gerente, que consultoria vai conseguir remover esse gerente de seu cargo - a menos que o dono acima dele esteja comprometido em cortar na própria carne? Se o problema é o programador mal caráter que todo mundo gosta (o tipo mais perigoso: o que sabe se articular e criar zonas de influência, entre pares e superiores), como mandar esse cara embora? 

Sim: consertar em pouco tempo uma equipe significa **necessariamente** substituir seus membros. No pior dos casos, trocar todos os membros. Se o método for bem aplicado ele imediatamente vai demonstrar e expor os problemas, e se o problema não for a prática e sim o comportamento (que é a grande maioria dos casos), é necessário resolver imediatamente. Se você, stakeholder e responsável pela sua empresa não está mandando ninguém embora depois de começar a implementar Ágil, está fazendo errado.

E aqui está o grande problema: ninguém entende esse compromisso. Não há almoço de graça. Não há como fazer omeletes sem quebrar alguns (ou todos) os ovos. E sem esse entendimento e compromisso, não há agilidade. Aliás, isso não é a primeira vez que eu digo isso se você leu meu artigo de 2009: [Net Negative Producing Programmer](http://www.akitaonrails.com/2009/03/30/off-topic-net-negative-producing-programmer). Mas como a maioria parece que ainda não entendeu, resolvi deixar mais claro ainda.

Esta foi uma introdução. Dependendo dos comentários talvez eu desça mais alguns degraus para explicar exatamente os mecanismos do que apresentei muito rapidamente aqui.
