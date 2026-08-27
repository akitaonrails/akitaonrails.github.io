---
title: 'Off-Topic: O Manifesto Ágil, ou Como se Tornar o Google'
date: '2008-10-07T03:39:00-03:00'
slug: off-topic-o-manifesto-gil-ou-como-se-tornar-o-google
translationKey: off-topic-o-manifesto-gil-ou-como-se-tornar-o-google
description: "Agilidade de verdade nasce de filosofia, confiança e equipes auto-organizadas; metodologia sozinha não basta. Do Manifesto Ágil a Conway, Pareto, Wikipedia e Google: por que cultura open source produz inovação."
tags:
- agile
- gestao
- engenharia-de-software
- off-topic
draft: false
---

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/8/1/468x60.gif)](http://www.locaweb.com.br/railssummit)

Não sou um dos melhores estudiosos de metodologias Ágeis que existe, nem de longe. Por isso vou me dar ao luxo de seguir uma visão talvez "ingênua" do que eu pessoalmente enxergo sobre o assunto. E eu sei, eu sei, a palavra "Google" no título é para chamar atenção. No final eu explico ;-)

Antes de mais nada, quero separar duas coisas: **metodologia** e **filosofia**. A parte mais relevante sempre é a filosofia. Se uma empresa ou profissional não absorveu a **filosofia Ágil**, dificilmente será verdadeiramente Ágil, por mais que implemente uma metodologia, ou seja, uma série de procedimentos.

Você pode até ler receitas de pratos franceses, mas até entender como um cozinheiro de verdade pensa, até absorver a cultura francesa, dificilmente fará pratos franceses decentes. Vai produzir apenas cópias mecânicas de baixa qualidade.

O importante não é o "como" e sim o "porquê". O [Manifesto Ágil](http://agilemanifesto.org/) diz isso já no seu **primeiro** valor. Vamos relembrar os quatro valores Ágeis:

> Estamos descobrindo melhores maneiras de desenvolver software fazendo isso e ajudando outros a fazê-lo. A partir desse trabalho temos os seguintes valores:
>
> - Indivíduos e interações mais que processos e ferramentas
> - Software que funciona mais que documentação completa
> - Colaboração do cliente mais que negociação de contratos
> - Responder à mudança mais que seguir um plano
>
> Quer dizer, mesmo que exista valor nos itens da direita, nós valorizamos mais os itens da esquerda.

O primeiro valor já diz tudo: _indivíduos_ mais que _processos_. Neste artigo quero mostrar por que a grande maioria das empresas não é efetivamente Ágil, mesmo quando implementa "metodologias" Ágeis.

## Princípios por trás do Manifesto Ágil

Para recapitular, vale citar os 12 Princípios por trás do Manifesto. Muita gente já leu todos esses itens, mas "ler" e "entender" são duas coisas completamente diferentes. Para efeitos da minha explicação, vou colocar algumas palavras-chave em negrito para me referir a elas mais tarde.

Nós seguimos estes princípios:

- Nossa maior prioridade é satisfazer o cliente através de entregas rápidas e contínuas de software que agrega valor.

- Recebemos bem **mudanças de requerimentos**, mesmo mais tarde no desenvolvimento. Processos ágeis gerenciam mudanças para a vantagem competitiva do cliente.

- Entregamos software que funciona frequentemente, de algumas semanas a poucos meses, com preferência para intervalos mais curtos.

- Pessoas de negócio e desenvolvedores devem trabalhar juntos diariamente pelo projeto.

- Construímos projetos através de **indivíduos motivados**. Damos a eles o **ambiente e suporte** de que precisam, e **confiamos** neles para executar o trabalho.

- A maneira mais eficiente e efetiva de transportar informação para dentro e para fora da equipe de desenvolvimento é a conversa face a face.

- Software que funciona é a medida principal de progresso.

- Processos ágeis promovem **desenvolvimento sustentável**. Patrocinadores, desenvolvedores e usuários devem ser capazes de manter um ritmo constante indefinidamente.

- Atenção contínua à excelência técnica e ao bom design melhora a agilidade.

- Simplicidade – a arte de maximizar a quantidade de trabalho não feito – é essencial.

- As melhores arquiteturas, requerimentos e designs emergem de **equipes auto-organizadas**.

- Em intervalos regulares, a equipe reflete sobre como se tornar mais efetiva, e então **ajusta** seu comportamento de acordo.

## O Quinto Elemento

> "Construímos projetos através de **indivíduos motivados**. Damos a eles o **ambiente e suporte** de que precisam, e **confiamos** neles para executar o trabalho."

Eu não sei como os fundadores do Manifesto chegaram a estes princípios, mas, baseado apenas neste ponto, imagino que sejam pessoas muito experientes. Este elemento, para mim, é o mais denso de todos os Princípios.

Corolários do Quinto Elemento são o 11o e o 12o princípios. Vou explicar por quê.

## Escalando Agilidade

Recentemente eu citei um capítulo do livro [Scaling Lean and Agile Development](http://web.archive.org/web/20160405011957/http://www.infoq.com/resource/articles/scaling-lean-agile-feature-teams/en/resources/Larman%20Vodde%20Feature%20Teams%20-%20InfoQ.pdf), de Craig Larman e Bas Vodde. Acredito que muita gente não teve paciência de ler, então vou resumir a parte que me interessa.

O PDF discute as diferenças entre **Feature Teams** e **Component Teams**. De forma simplificada, uma equipe Ágil é necessariamente uma Feature Team: uma equipe o mais independente possível, que assume um produto ou uma _feature_ completa de um produto, do começo ao fim, dos requerimentos até o contato com o cliente.

Uma Component Team é o estilo tradicional e departamental. Cada equipe responde apenas por um pedaço de vários produtos: equipe de interface, equipe de infraestrutura, equipe de arquitetura, equipe de componentes visuais, equipe de banco de dados, equipe de qualidade e assim por diante.

Feature Teams são cross-funcionais, formadas normalmente por generalistas. Component Teams são limitadas, formadas normalmente por especialistas. Uma **Equipe Scrum** é, **por definição**, uma Feature Team, capaz de realizar todo o trabalho de um item do Product Backlog.

Como eu disse antes, esqueça o "como" por enquanto.

## Lei de Conway

[Melvin Conway](http://en.wikipedia.org/wiki/Conway's_Law), em abril de 1968, escreveu um artigo onde um trecho entraria para os anais da história da computação:

> "Qualquer organização que faz design de sistemas (definição ampla) produzirá um design cuja estrutura é uma cópia da estrutura de comunicação da empresa."

Como está explicado no [site dele](https://www.melconway.com/Home/Conways_Law.html), o famoso [Frederick Brooks](http://en.wikipedia.org/wiki/Fred_Brooks) citou essa ideia no clássico [The Mythical Man Month](http://www.amazon.com/Mythical-Man-Month-Software-Engineering-Anniversary/dp/0201835959) (que **todo** profissional de tecnologia deveria ler), batizando-a de **Lei de Conway**. Brooks reconheceu que a lei tinha corolários importantes em teorias de gestão. Aqui vai uma afirmação dele:

> "Como o design que acontece primeiro quase **nunca** é o melhor possível, o conceito de sistema vigente pode precisar de **mudanças**. Portanto, flexibilidade da organização é importante para um design efetivo."

Como eu já disse em [Matando a Média](http://web.archive.org/web/20231004031021/https://www.akitaonrails.com/2008/9/13/off-topic-matando-a-m-dia), até hoje aplicamos metodologias e processos gaussianos. Ainda não consegui escrever um material mais completo sobre isso, então assista ao vídeo que gravei e leia os materiais de referência que indico nele. Por enquanto basta entender que a maioria das "verdades incontestáveis" da Teoria das Organizações não se aplica mais.

Essas teorias antiquadas, com suas cadeias de comando rígidas, departamentos "feudais" e cultura de cargo e poder político, foram feitas para dar controle a chefes de seção em fábricas do século XIX, onde o máximo que se esperava de um trabalhador era apertar parafusos.

Como diz a Lei de Conway, as equipes criam estruturas que espelham a estrutura da organização. O corolário: uma empresa que incentiva trabalho medíocre terá equipes medíocres. Lembre do **Quinto Elemento**: _"... dê-lhes o ambiente e o suporte de que precisam ..."_

O PDF de Larman e Vodde menciona Brad Silverberg, ex-VP sênior do Windows e Office na Microsoft, que enfatizou:

> "O software tende a refletir a estrutura da organização que o construiu. Se você tiver uma organização grande e lenta, você tende a construir software grande e lento."

Uma afirmação irônica, mas verdadeira.

## Generalistas vs Especialistas

Empresas tradicionais que se iludem achando que terão controle total sobre as equipes só conseguem criar funcionários pouco produtivos, sem atitude, acomodados, limitados e que nunca aprenderão nada de novo.

Isso porque o estilo Controle Total prefere a divisão de trabalho de chão de fábrica, onde cada equipe faz uma parte do todo. Nesse estilo de gestão, quem reina é o incentivo aos **Especialistas**.

Especialista é aquele funcionário que começou determinado pedaço do sistema e só ele sabe como aquele pedaço funciona. Ele não se sente confortável em dividir esse conhecimento e menos ainda em aceitar mudanças externas. Costuma ser tratado como **herói**: quando há urgência, ninguém mais tem tempo de aprender aquele pedaço, e só ele resolve o problema.

Se você tem _heróis_ desse tipo na sua empresa, eles devem ser os primeiros a ser despedidos.

Não é à toa que equipes Scrum são, por definição, Feature Teams. Caso contrário, o primeiro efeito que vem à tona é este:

![](http://s3.amazonaws.com/akitaonrails/assets/2008/10/7/Picture_1.png)

Reconhece? Cada Component Team faz seu Sprint, sua iteração, e a iteração da equipe seguinte só começa quando a anterior termina. Isso porque nenhuma equipe comanda a _feature_ completa e todas dependem de pedaços das outras.

Isso tem nome: bem-vindos de volta ao **Waterfall**! Não importa que chamem de _mini-waterfall_: cascata é cascata, não importa o tamanho.

Há outro efeito colateral grave: como ninguém é efetivamente dono do produto, nenhuma equipe se sente responsável pelo todo, só pela sua parte. Naturalmente emerge o comportamento de _"a minha parte eu fiz, a culpa é da outra equipe."_

E tem mais. Component Teams lidam com um tipo só de problema, o que força seus integrantes a virarem especialistas. Esse profissional limita o próprio conhecimento e não recebe absolutamente nenhuma **motivação** para aprender coisas novas.

Lembram do **Quinto Elemento**? _"Construímos projetos através de **indivíduos motivados** ..."_ Onde estão os indivíduos motivados numa organização que força todos à mediocridade? Claro que ninguém precisa saber tudo de tudo: cada profissional sempre terá disciplinas em que se encaixa melhor. Mas todos devem ser incentivados a saber um pouco do resto.

Por isso Feature Teams são importantes: você tem vários especialistas, e cada um sabe um pouco do que o colega do lado sabe fazer. Com isso, **Pair Programming** ganha novo significado.

E **Test Driven Development** começa a fazer muito mais sentido quando a equipe é realmente responsável por um produto ou feature que agrega valor ao cliente final. Sem dependência entre equipes, fica claro como realizar os testes completos. Mas há outra questão sobre testes que explico mais abaixo.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/10/7/charlie_chaplin02.jpg)

## Auto-Organização

Este é o ponto crucial das novas teorias organizacionais. Don Tapscott e Anthony D. Williams chamariam isso de [Wikinomics](http://www.wikinomics.com/book/), a economia da colaboração.

Organizações tradicionais têm horror ao caos e perseguem controle absoluto de forma patológica, a ponto de ser prejudicial.

E elas deveriam mesmo ter horror ao caos. O que precisam entender é que existe o fenômeno de **ordem que emerge a partir do caos**.

Estamos acostumados a pensar em eventos isolados, em resultados que são a soma de eventos independentes. Coloque uma colher de açúcar e o chá fica doce. Coloque duas e o chá fica duas vezes mais doce.

Sistemas dinâmicos não funcionam assim. Certos sistemas são muito sensíveis às condições iniciais e dão resultados [não lineares](http://en.wikipedia.org/wiki/Nonlinearity). Fenômenos naturais como relacionamentos sociais, cadeias alimentares e eventos econômicos são todos sistemas não lineares.

Isso volta à minha palestra sobre [Distribuições Power Law](http://en.wikipedia.org/wiki/Power_law), ou [Distribuições de Pareto](http://en.wikipedia.org/wiki/Pareto_distribution). Recapitulando: um mundo platônico e linear pode ser modelado segundo [Gauss](http://en.wikipedia.org/wiki/Normal_distribution). Esse tipo de distribuição é confortável para analistas porque tem **média definida** e **desvio padrão estável**. Power Laws são o oposto: caracterizadas pela **ausência** de média e por um desvio padrão que tende ao infinito.

O ponto mais óbvio: curvas de sino como a Normal exigem eventos **independentes** e **isolados**, como jogar dados ou tirar cara ou coroa numa moeda não viciada. Comportamento humano pode ser tudo, menos independente: por definição, humanos se relacionam entre si, e formamos sistemas altamente dependentes.

E aqui vem o contraintuitivo. Redes dinâmicas não formam conexões aleatórias, cuja distribuição seria Normal. Elas exibem distribuição de Pareto. [Albert-László Barabási](http://web.archive.org/web/20160409231523/http://www3.nd.edu/~networks/Publication%20Categories/01%20Review%20Articles/ScaleFree_Scientific%20Ameri%20288,%2060-69%20(2003).pdf) explica em detalhes a formação de [redes scale-free](http://en.wikipedia.org/wiki/Scale-free_network).

Se pensarmos em nós (pessoas, animais, neurônios, vírus) e conexões (amizade, transmissão, sinapse), o natural é imaginar que os nós se conectam de forma aleatória e caótica. Os estudos de Barabási e as observações detalhadas dos fenômenos naturais mostraram o contrário: essas redes tendem a ser scale-free, com poucos nós concentrando a grande maioria das conexões e muitos nós dividindo as poucas que sobram, formando algo assim:

![](http://s3.amazonaws.com/akitaonrails/assets/2008/10/7/Picture_2.png)

Para nós de tecnologia, isso lembra a representação da Internet, onde os nós são websites e as conexões são, literalmente, os _links_ entre eles. E é isso mesmo: a Internet segue uma distribuição de Pareto.

Para os que têm tendências socialistas, esqueçam Marx, que estava obviamente errado ao tentar rebaixar toda a sociedade à média. O pensamento de _"tirar dos ricos para dar aos pobres"_ é antinatural. O natural é o oposto: poucas pessoas sempre deterão a grande maioria da riqueza do mundo, enquanto a maioria terá menos. A única forma de os pobres enriquecerem é fazer o **sistema inteiro** enriquecer, incluindo os próprios ricos. A natureza privilegia a **meritocracia**, nunca a **mediocridade**.

Assumindo que todos estudem um pouco mais sobre Barabási, Poincaré, Mandelbrot, Zipf, Pareto, Bak e assuntos como redes scale-free, power laws, self-organized criticality, phase transition, caos e fractais, dá para concluir rápido: a ordem costuma sim emergir do caos. Redes se formam como Barabási descreveu, por mecanismos como [preferential attachment](http://en.wikipedia.org/wiki/Preferential_attachment), e no final temos redes scale-free **auto-organizadas**.

## 80/20

A famosa regra 80/20 não veio do nada. Num estudo na Itália, Vilfredo Pareto constatou que 80% do território italiano estava nas mãos de não mais que 20% da população. Daí o "80/20".

Essa divisão é justamente o que uma distribuição de Pareto mostra:

![](http://s3.amazonaws.com/akitaonrails/assets/2008/10/7/300px-Long_tail.svg.png)

Como **Chris Anderson** explica em [The Long Tail](http://web.archive.org/web/20091012083320/http://www.changethis.com/pdf/10.01.LongTail.pdf), pense na [Wikipedia](http://wikipedia.org). Na época da publicação do livro, em 2006, a Wikipedia já tinha cerca de um milhão de artigos, uma ordem de grandeza acima da Enciclopédia Britannica.

A ideia de [Jimmy Wales](http://en.wikipedia.org/wiki/Jimmy_Wales) foi ousada e controversa, apesar da boa intenção: fornecer uma enciclopédia rica, extensa e gratuita a todas as pessoas do mundo, incluindo crianças pobres em países subdesenvolvidos que talvez nunca tivessem acesso à informação de outra forma.

Wales começou com o projeto Nupedia em 2000, com poucos verbetes e uma ideia que já tinha se popularizado com Linus Torvalds e seu Linux: uma plataforma totalmente aberta, onde qualquer pessoa poderia contribuir, revisar, refinar.

Olhando de 2008, todos diriam que Jimbo (como é conhecido) é um gênio. Em 2000, ele era tido como louco. Em retrospectiva, sempre é fácil criar uma narrativa que se encaixa perfeitamente nos eventos que já aconteceram. Como [Nassim Nicholas Taleb](http://web.archive.org/web/20240619095330/http://fooledbyrandomness.com/ARTE.pdf) diria: depois que um **Cisne Negro** acontece, é fácil explicá-lo; antes que aconteça, é impossível prevê-lo.

Seguindo o exemplo de Torvalds, Jimbo criou um **ambiente** adequado para **colaboradores**. Ele soube **motivar** as pessoas e, principalmente, **confiar** nelas: ao contrário do sistema editorial tradicional, não haveria editores nem filtros, e tudo que qualquer um digitasse estaria disponível na hora. A esperança era que erros grosseiros fossem corrigidos rapidamente pelos próprios colaboradores, como **Eric S. Raymond** descreve no clássico [The Cathedral and the Bazaar](http://www.catb.org/~esr/writings/cathedral-bazaar/):

> "Dada uma quantidade suficiente de olhos, todos os bugs são superficiais."

Eric chamou isso de "Lei de Linus", que também pode ser explicada assim: _"dada uma base grande o suficiente de beta-testers e co-desenvolvedores, quase todo problema será caracterizado rapidamente e a correção será óbvia para alguém."_

![](http://s3.amazonaws.com/akitaonrails/assets/2008/10/7/1139845442_1927.jpg)

A Wikipedia se valeu dessa mesma lei. Num sistema dinâmico e aberto, onde os colaboradores chegam aos poucos e evoluem para uma rede scale-free auto-organizada, erros vão acontecer, mas a maioria será corrigida rápido. O benefício de reunir informação de milhares de pessoas pelo mundo é ordens de grandeza maior que os pequenos defeitos que aparecem de vez em quando.

No modelo de controle tradicional, pensa-se como a Britannica: poucos verbetes, todos muito corretos. Qual vale mais: uma enciclopédia menor com taxa de erro perto de zero, ou outra dez vezes maior com uma pequena taxa de erros? Alguns críticos retrógrados continuam achando que um pequeno erro na Wikipedia invalida um milhão de acertos.

## Software como Arte

Pete McBreen já escreveu em 2001 sobre [Software Craftsmanship](http://www.mcbreen.ab.ca/SoftwareCraftsmanship/), e eu sou um defensor dessa definição.

Muita gente pensa em software, em programação, como **Engenharia**. Sinto informar que não é. Software é música: desenvolver software é muito próximo de compor uma música.

Software também é pintura: desenvolver é como pintar um quadro. Sem querer diminuir a engenharia, que já nos trouxe maravilhas como a Muralha da China e as pirâmides do Egito, mas no caso do software muita gente acha mais simples pensar nele como engenharia do que como arte.

O motivo é o mesmo de sempre: a tentativa de controle. Engenharia é previsível, controlável, mensurável. Arte é criativa, rebelde, imprevisível, caótica. Acho muito interessante que grandes nomes do passado como Pitágoras e Da Vinci foram grandes **generalistas**, **artistas** com muitos trabalhos em **ciência** e **matemática**. É exatamente isso que um desenvolvedor de software precisa ser: um artista da Renascença.

Como eu disse antes, um membro de uma _Feature Team_ tem suas especialidades, mas mantém a mente absolutamente aberta para tentar coisas novas, aprender novos ofícios, explorar e criar.

Arte não se implementa lendo procedimentos. E é exatamente isso que muitos dos que se intitulam "desenvolvedores" ou "programadores" fazem: aprendem uma ou poucas maneiras de fazer as coisas e repetem para sempre o que lhes ensinaram. Artistas aprendem com mentores, treinam incansavelmente num longo processo de tentativa e erro, inspiram-se no trabalho de outros mestres, entendem suas técnicas e tentam mesclá-las às suas.

Sem ser verdade absoluta, eu tendo a achar que desenvolvedores que participam ativamente de projetos open source, como o Linux, são programadores muito mais completos do que os que saíram da faculdade direto para _Component Teams_ em organizações tradicionais. Especialmente se ficaram anos demais na mesma organização.

Um programador especialista, membro de uma Component Team numa organização gaussiana tradicional, é como um pintor de parede: sabe apenas passar o rolo de cal de cima para baixo, simetricamente, sem um pingo de criatividade e sem nenhum talento para aprendizado e autoevolução.

80% do perfil profissional de um funcionário é reflexo direto da organização onde trabalha. Os outros 20% são culpa do próprio funcionário, que não aceita sair da zona de conforto. Ambos têm 100% da culpa por apenas 29% dos projetos de software serem considerados sucessos, e pelos USD 55 bilhões gastos em projetos cancelados. (fonte: [Standish Chaos Reports](http://web.archive.org/web/20150211100346/http://www.galorath.com/wp/software-project-failure-costs-billions-better-estimation-planning-can-help.php))

## Mundo Open Source

Acredito que não seja preciso explicar muito mais sobre projetos open source. Não há milagre: um projeto não terá sucesso automático só por ser código aberto. Muito pelo contrário, centenas de projetos nunca veem a luz do dia.

Novamente, estamos falando de Pareto: talvez só 20% dos projetos open source tenham grande sucesso. Porém, os outros 80% são identificados como fracasso muito mais rápido: alguns se mesclam em projetos maiores, alguns simplesmente param. A decisão de parar é muito mais rápida e efetiva do que em projetos corporativos tradicionais, que já investiram recursos, tempo, dinheiro e a reputação dos envolvidos.

Com tudo que expliquei acima, fica fácil entender que projetos open source começam com condições iniciais simples: uma ideia, uma pequena implementação, poucas pessoas. E começa a fazer sentido como eles evoluem do _caos_ para redes scale-free através de **auto-organização**.

Consenso prévio rígido não existe nesse ambiente: esses projetos só podiam evoluir para Feature Teams, onde os colaboradores têm habilidades diferentes e complementares.

Também não é difícil entender que, como na Wikipedia, os verbetes mais importantes ou conhecidos são preenchidos primeiro, e os mais obscuros, com o tempo. No melhor estilo Pareto, 20% das prioridades acontecem primeiro. Num ambiente de recursos escassos, sem presença física, com colaboradores voluntários, motivar pessoas é ainda mais importante, e as prioridades que dão mais valor ao grupo como um todo são implementadas primeiro.

Entendendo software como arte, fica simples entender que desenvolvedores que participam de vários projetos open source estão automaticamente expostos a muitas expressões diferentes de arte e, com isso, a diferentes maneiras de implementar software. Um bom desenvolvedor começa a incorporar essas diferenças no próprio estilo, melhorando muito a qualidade do seu trabalho.

Um desenvolvedor sozinho, ou numa equipe conhecida, tem pouco motivo para criar testes do próprio código. Mas quando ele colabora numa comunidade onde qualquer desconhecido pode ver seu código e aferir sua reputação, a motivação para escrever código de qualidade, decentemente coberto por testes, fica óbvia. Daí eu ter dito antes que Test Driven Development passa a fazer ainda mais sentido e vira uma necessidade real.

O idealizador do projeto, o desenvolvedor ou grupo de programadores que o iniciou, será obrigado a gerenciá-lo. Num ambiente aberto, sem cargos, sem salários, sem chefes nem clientes diretos, qualquer tentativa de usar técnicas gaussianas de gerenciamento tradicional vai por água abaixo. Agora estamos falando de projetos de verdade, sem a zona de conforto do cubículo.

O **mantenedor** do projeto se verá numa posição em que será obrigado a tomar decisões. Ele entenderá rápido que unanimidade é impossível e vestirá o chapéu de **ditador benevolente**: se for rígido e autoritário demais, afastará todos os colaboradores, que não têm obrigação nenhuma de segui-lo; se for flexível demais, demonstrará insegurança, indecisão, morosidade, e poderá motivar um _coup_, uma espécie de golpe de estado em que o projeto é clonado e um mantenedor mais carismático e efetivo toma seu lugar. Ou pior: o projeto pode simplesmente parar e deixar de existir.

Não existe ambiente mais hostil e ao mesmo tempo mais recompensador para um verdadeiro gerente de projetos do que o open source. Tire de um gerente o cargo e o poder, e só então você poderá avaliar se ele sabe o que significa "gerenciar".

## Princípios Ágeis, Redux

Tudo isso dito, acho que podemos recapitular o 5o, o 11o e o 12o princípios:

> - Construímos projetos através de **indivíduos motivados**. Damos a eles o **ambiente e suporte** de que precisam, e **confiamos** neles para executar o trabalho.
>
> - As **melhores arquiteturas**, requerimentos e designs emergem de **equipes auto-organizadas**.
>
> - Em intervalos regulares, a equipe reflete sobre como se tornar mais efetiva, e então **ajusta** seu comportamento de acordo.

Os outros princípios são consequência.

Dado um **ambiente** adequado, com profissionais elevados acima da média e **motivados**, podemos realmente **confiar** em sua capacidade de **auto-organização**. A estrutura orgânica, não hierarquizada, levará seus membros a **reajustarem** a rotina de acordo com os problemas enfrentados. Isso gera código de qualidade, com apenas o essencial sendo produzido, atenção a refatoração, testes e integração contínua, o que leva naturalmente às **melhores arquiteturas**.

O sistema como um todo se retroalimenta num ciclo contínuo de feedback positivo, criando um ambiente **sustentável** e sempre produtivo, com profissionais pesquisando e implementando inovações que, de tempos em tempos, dão saltos de qualidade e produtividade para a empresa como um todo.

Como resultado, o cliente recebe produtos que agregam valor real, e **mudanças de requerimentos** podem ser aceitas sem maiores problemas, porque a organização é flexível e cada membro se sente responsável pelo todo. Nesse ciclo virtuoso, os profissionais estão em aprendizado constante, aumentando suas habilidades em ritmo crescente. O resultado é uma empresa inovadora, acima da média, que não depende do passado para tentar prever o futuro: seus profissionais estão preparados para qualquer futuro que chegar. Mudanças constantes não os assustam mais; pelo contrário, eles querem mudanças.

## Como chegar Lá?

Não foi à toa que eu falei sobre:

- [Matando a Média](http://web.archive.org/web/20231004031021/https://www.akitaonrails.com/2008/9/13/off-topic-matando-a-m-dia)
- [O Poder do Mito, Redux](http://www.akitaonrails.com/2008/09/20/off-topic-o-poder-do-mito-redux)
- [Colaborando no Github](http://web.archive.org/web/20221210044111/https://www.akitaonrails.com/2008/9/21/colaborando-no-github)
- [Entendendo Git e Instalando Gitorious](http://web.archive.org/web/20241102214031/https://www.akitaonrails.com/2008/10/2/entendendo-git-e-instalando-gitorious-git-via-web).

Os dois primeiros artigos focam na figura do profissional: uma tentativa de acordar os funcionários-batedores-de-cartão de que o mundo não é estático, o futuro não é estável e o mundo gaussiano é uma ilusão.

Os dois últimos falam especificamente de uma ferramenta: Git. É uma dica para criar o **ambiente** que o desenvolvedor precisa, como está no Quinto Princípio. Mas ferramenta, assim como metodologia, não serve para nada se empresa e funcionário não incorporarem os Valores e Princípios Ágeis.

Daí este artigo.

Como eu disse no começo, não me considero nenhum grande estudioso dessa filosofia, mas por alguma razão me identifico com suas bases e observo claramente sua aplicação prática em projetos open source. Também está claro que, no mundo de Pareto, esse modelo sobreviveu e deu frutos impressionantes, como a Wikipedia e o fato de a maioria dos servidores web do mundo rodar Apache.

Sua empresa tem software como parte do core business? Aplique o modelo "open source", ou o modelo "bazaar", segundo Eric Raymond. Sem necessariamente abrir seu código para o público na internet, claro.

Crie um repositório simples, ao qual todos os funcionários tenham acesso irrestrito, com barreira de adoção baixa. Incentive-os a participar de projetos fora de seus departamentos tradicionais. No começo, código malfeito, de baixa qualidade, sem testes e com todo tipo de defeito virá à tona. Mas apontar dedos não resolve: o objetivo é quebrar o ciclo vicioso que gera esse tipo de software.

**"Programador ruim fará código ruim, não importa a linguagem ou ferramenta que você dê a ele."** Portanto, o objetivo é criar programadores excelentes, não trocar de ferramenta. De forma impressionante, um programador bom fará código bom até em ASP ou Perl (novamente, sem querer denegrir o Perl, falo apenas pela reputação, criada principalmente por programadores ruins).

Como numa escultura, é hora de aparar as pontas, refazer alguns pedaços, remoldar o que não parece certo e levar essa peça a virar uma obra de arte, de forma colaborativa. É a melhor maneira de evitar desperdício: quem tem tempo sobrando numa equipe pode ajudar os colegas mais atarefados da outra.

No começo haverá desordem e sinais de caos. Haverá duplicação de trabalho, dessincronia e problemas de comunicação, afinal ninguém estava habituado a realmente se comunicar. As deficiências de habilidade e conhecimento ficarão óbvias. Todos os problemas existentes virão à tona, e isso será feio e desconfortável.

Porém, se houver um pouco de insistência e confiança nas pessoas, o grupo como um todo sairá do caos. Os verdadeiros líderes vão emergir como hubs na rede scale-free. O fenômeno de preferential attachment começará a delinear a ordem. Com tempo suficiente, as pessoas se auto-organizarão de forma orgânica.

A partir daí, sim, poderemos começar a falar em crescimento **sustentável**, com ritmo constante ou crescente de produtividade.

## Um dia de Inovação

No Google existe aquela velha história de que todo funcionário tem direito a um dia por semana para fazer o que bem entender.

Dita assim, a primeira imagem que me vem à cabeça é um monte de garotos passeando de bicicleta, jogando videogame e tomando caipirinha à beira da piscina do campus.

Mas, assumindo que você leu todo o artigo, imagine o **Orkut Büyükkökten** num desses dias. Ele tem o ambiente certo, a cultura certa, a motivação certa, o conhecimento certo. Ele resolve iniciar um projeto pessoal para experimentar conceitos de redes sociais.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/10/7/orkut.jpg)

Ele tem um local onde colocar seu código e entende que deve se desapegar dele. Entende naturalmente como funciona a colaboração no estilo open source e, por causa disso, sabe se comunicar.

Ele divulga o projeto internamente. Os membros de sua equipe e de outras, todos sintonizados na cultura de proatividade, inovação, aceitação de mudanças e colaboração, entendem imediatamente o valor da ideia. Mais que isso: sabem de onde baixar o código e como começar a colaborar.

Eu não sei como o Google funciona de verdade, nunca trabalhei lá e provavelmente ele tem tantos problemas quanto qualquer empresa normal. Mesmo assim, fantasio que muitos produtos deles começaram assim: num ambiente permissivo, voltado à inovação. Não basta contratar PhDs do MIT ou de Stanford se não houver ambiente e cultura adequados para fazê-los produzir de verdade. Como Larry e Sergey começaram nesse mundo permissivo do open source, fico imaginando se eles não criaram uma organização que segue exatamente esse modelo, mesmo que por instinto.

Muitas empresas querem ser o próximo Google. Vale lembrar que é preciso muito mais do que sofás confortáveis, mesas de pebolim, salas de videogame e restaurante de comida japonesa dentro da empresa. Isso é fácil: basta comprar.

O difícil é **cultivar** uma cultura. Muitas empresas reclamam que bons profissionais pedem demissão e procuram outras empresas. Óbvio: pessoas realmente inteligentes não aceitam uma cultura gaussiana por muito tempo. Nós não gostamos da mesmice, do pensamento retrógrado e da falta de atitude. Artistas de verdade precisam de ambientes que inspirem criatividade.

O cubículo da maioria das empresas é um péssimo lugar para se criar.

## Bibliografia

Finalmente, uma vez entendida a **filosofia**, podemos voltar à **metodologia**. Agora faz sentido aplicar as ferramentas que metodologias como XP ou Scrum advogam: Pair Programming, Planning Game, Test Driven Development, Continuous Integration, Refactoring, Small Releases, Collective Code Ownership, Simple Design, Sustainable Pace e assim por diante.

Leiam com outros olhos minhas recomendações de leitura:

- Larman, Craig & Vodde, Bas – [Scaling Lean & Agile Development: Thinking and Organizational Tools for Large-Scale Scrum](http://www.amazon.com/Scaling-Lean-Agile-Development-Organizational/dp/0321480961)
- Fowler, Chad – [My Job Went to India: 52 Ways to Save Your Job](http://www.amazon.com/Job-Went-India-Pragmatic-Programmers/dp/0976694018)
- Christensen, Clayton M. – [The Innovator's Dilemma: The Revolutionary Book that Will Change the Way You Do Business](http://www.amazon.com/Innovators-Dilemma-Revolutionary-Business-Essentials/dp/0060521996)
- Beck, Kent – [Extreme Programming Explained: Embrace Change](http://www.amazon.com/Extreme-Programming-Explained-Embrace-Change/dp/0201616416)
- Poppendieck, Mary – [Lean Software Development: An Agile Toolkit](http://www.amazon.com/Lean-Software-Development-Agile-Toolkit/dp/0321150783)
- Brooks, Frederick P. – [The Mythical Man-Month: Essays on Software Engineering](http://www.amazon.com/Mythical-Man-Month-Software-Engineering-Anniversary/dp/0201835959)
- McBreen, Pete – [Software Craftsmanship: The New Imperative](http://www.amazon.com/Software-Craftsmanship-Imperative-Pete-McBreen/dp/0201733862)
- Raymond, Eric S. – [The Cathedral & the Bazaar: Musings on Linux and Open Source by an Accidental Revolutionary](http://www.amazon.com/Cathedral-Bazaar-Musings-Accidental-Revolutionary/dp/0596001088)
- Tapscott, Don & Williams, Anthony D. – [Wikinomics: How Mass Collaboration Changes Everything](http://www.amazon.com/Wikinomics-Mass-Collaboration-Changes-Everything/dp/1591841933)
- Anderson, Chris – [The Long Tail, Revised and Updated Edition: Why the Future of Business is Selling Less of More](http://www.amazon.com/Long-Tail-Revised-Updated-Business/dp/1401309666)
- Gladwell, Malcolm – [The Tipping Point: How Little Things Can Make a Big Difference](http://www.amazon.com/Tipping-Point-Little-Things-Difference/dp/0316346624)
- Gladwell, Malcolm – [Blink: The Power of Thinking Without Thinking](http://www.amazon.com/Blink-Power-Thinking-Without/dp/0316010669)
- Taleb, Nassim Nicholas – [Fooled by Randomness: The Hidden Role of Chance in Life and in the Markets](http://www.amazon.com/Fooled-Randomness-Hidden-Chance-Markets/dp/1400067936)
- Taleb, Nassim Nicholas – [The Black Swan: The Impact of the Highly Improbable](http://www.amazon.com/Black-Swan-Impact-Highly-Improbable/dp/1400063515)
- Mandelbrot, Benoit – [The Misbehavior of Markets: A Fractal View of Risk, Ruin & Reward](http://www.amazon.com/Misbehavior-Markets-Fractal-View-Reward/dp/0465043577)
- Sagan, Carl – [The Demon-Haunted World: Science as a Candle in the Dark](http://www.amazon.com/Demon-Haunted-World-Science-Candle-Dark/dp/0345409469)
- Sagan, Carl – [Pale Blue Dot: A Vision of the Human Future in Space](http://www.amazon.com/Pale-Blue-Dot-Vision-Future/dp/0345376595)
- Dawkins, Richard – [The Selfish Gene](http://www.amazon.com/Selfish-Gene-Anniversary-Introduction/dp/0199291152)

Dica: a maioria desses livros tem tradução em português.

Sei que alguns desses livros não têm relação direta com este assunto (como os de Carl Sagan), mas acredite: fazem muita diferença na maneira como formamos nossas **ideias**.
