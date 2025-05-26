---
title: 'Tradução: Dívida Técnica'
date: '2008-12-18T01:55:00-02:00'
slug: tradu-o-d-vida-t-cnica
tags:
- off-topic
- principles
- career
- management
- translation
- carreira
draft: false
---

Conheci **Steve McConnell** há muitos anos, primeiro com os livros [After the Gold Rush](http://www.stevemcconnell.com/gr.htm) e [Software Project Survival Guide](http://www.stevemcconnell.com/sg.htm). Muitos o conhecem mais pelo [Code Complete](http://www.stevemcconnell.com/cc1.htm). Ano passado ele escreveu um excelente artigo sobre o assunto **Dívida Técnica**. Discutindo esse assunto recentemente, resolvi retornar a esse texto e traduzí-lo. Novamente, depois de anos de experiência eu ainda me surpreendo que este é mais um conceito que pouca gente discute e incorre no mesmo erro o tempo todo.

Antes de mais nada, o conceito de “Dívida Técnica”, é uma metáfora para indicar que toda vez que você toma um atalho técnico (o bom e velho _“não importa que saia sujo, o importante é lançar o produto rápido!”_). Isso não sai de graça. Toda vez que fazemos isso, é como fazer um empréstimo num banco, ou seja, é como assumir uma dívida. E como toda dívida, essa também corre juros e um dia será devidamente cobrada!

Extremistas costumam dizer _“paguem tudo à vista, pois cartões de crédito são do mal.”_ Isso também não é verdade. Empréstimos podem ser bons e importantes. Que comerciante nunca teve um aperto de fluxo de caixa, onde um pequeno empréstimo não lhe deu um fôlego? O problema, como sempre, é o exagero, como o comprador compulsivo que inclusive paga um cartão de crédito com outro cartão de crédito! Muitas empresas agem exatamente assim com software: assumem centenas de dívidas e depois de alguns anos se assustam com o montante acumulado de dívidas a pagar.

E você: assumiu dívidas técnicas recentemente? Está preparado para começar a quitá-las? Segue a tradução do [artigo original](http://blogs.construx.com/blogs/stevemcc/archive/2007/11/01/technical-debt-2.aspx) do Steve:


## Dívida Técnica

O termo “dívida técnica” foi cunhada por Ward Cunningham para descrever a obrigação que uma organização de software incorre quando escolhe um design ou um tipo de construção que é prático no curto prazo mas que aumenta a complexidade e é mais custoso no longo prazo.

Ward não explicou a metáfora muito a fundo. As poucas pessoas que discutiram dívida técnica parecem usar a metáfora principalmente para comunicar o conceito à equipes técnicas. Eu concordo que é uma metáfora útil para comunicar com equipes técnicas, mas estou mais interessado na incrível e rica habilidade da metáfora de explicar um conceito técnico crítico para stakeholders de projeto não-técnicos.

## O que é uma Dívida Técnica? Dois Tipos Básicos

_O primeiro tipo de dívida técnica é o tipo em que se incorre sem intenções._ Por exemplo, um tipo de design se torna passível de erro ou um programador júnior simplesmente escreve código ruim. Esse dívida técnica é o resultado não-estratégico de um **trabalho ruim**. Em alguns casos, esse tipo de dívida pode ser incorrido sem conhecimento, por exemplo, sua empresa pode adquirir outra que acumulou dívida técnica significativa que não se identificou até depois da aquisição. Algumas vezes, ironicamente, essa dívida pode ser criada quando uma equipe tropeça em seus esforços de **reescrever** uma plataforma endividada e sem querer cria mais dívidas. Vamos chamar essa categoria geral de **Tipo I** de dívida.

_O segundo tipo de dívida técnica é o tipo em que se incorre intencionalmente._ Isso acontece normalmente quando uma organização toma uma **decisão consciente** de otimizar para o presente do que para o futuro. _“Se não conseguirmos lançar à tempo, não haverá próximo lançamento”_ é um refrão comum – e normalmente um bem convincente. Isso leva a decisões como _“Não temos tempo para reconciliar esses dois bancos de dados, então vamos escrever alguma gambiarra que os mantenha sincronizados por agora e vamos reconciliar depois de lançar.”_ Ou _“nós temos algum código escrito por consultores que não seguem padrões; nós podemos limpar depois.”_ Ou _“não tivemos tempo para escrever todos os testes unitários para o código que escrevemos nos últimos 2 meses do projeto. Vamos escrever depois do lançamento.”_ (Chamaremos isso de **Tipo II** ).

O resto dos meus comentários focam no tipo de dívida técnica incorrido por razões estratégicas (Tipo II).

## Dívidas de Curto prazo vs de Longo prazo

Com dívidas reais, uma empresa manterá ambas dívidas de curto e longo prazos. Você usa dívida de curto prazo para cobrir coisas como _gaps_ entre seus recebíveis (pagamentos dos clientes) e despesas (folha de pagamento). Você assume uma dívida de curto prazo quando tem o dinheiro, você apenas não o tem _agora._ É esperado que dívidas de curto prazo sejam pagas frequentemente. O equivalente técnico parece bem direto. Dívida de curto prazo é a dívida que é tomada _taticamente e reativamente_ normalmente como medida de último caso para conseguir lançar um produto. (Chamaremos isso de **Tipo II.A**.)

Dívida de longo prazo é a dívida que uma empresa assume _estrategicamente e próativamente_ – investimento em novos equipamentos de capital, como uma nova fábrica, ou um novo campus corporativo. Novamente, o equivalente técnico parece direto: _“Não achamos que precisaremos dar suporte a uma segunda plataforma por pelo menos 5 anos, então este lançamento pode ser construído na premissa que estaremos dando suporte a apenas uma plataforma.”_ (Chamaremos isso de **Tipo II.B**.)

A implicação é que dívida de curto prazo deve ser paga rapidamente, talvez como a primeira parte do próximo ciclo de lançamento, ao passo que dívida de longo prazo pode ser levada por alguns anos ou mais.

## Incorrendo em Dívida Técnica

Quando dívida técnica é incorrida por razões estratégicas, a razão fundamental é sempre que o custo do trabalho de desenvolvimento hoje é visto como mais caro do que irá custar no futuro. Isso pode ser verdade por uma de diversas razões.

_Tempo de Mercado._ Quando tempo de mercado é fundamental, incorrer em $1 extra no desenvolvimento pode equivaler a um prejuízo de $10 no lucro. Mesmo que o custo de desenvolvimento para o mesmo trabalho suba para $5 depois, ou seja, seja mais caro depois, incorrer no dívida de $1 agora é uma boa decisão de negócios.

_Preservação do Capital de Startup._ Em um ambiente de startup você tem uma quantia fixa de dinheiro-semente, e cada dólar conta. Se você pode atrasar uma despesa por um ano ou dois, pode pagar por essa despesa a partir de uma quantia maior de dinheiro depois do que pagar com preciosos fundos de startup agora.

_Atrasar Despesa de Desenvolvimento._ Quando um sistema é aposentado, todo a dívida técnica de um sistema é aposentada de uma só vez com ele. Uma vez que um sistema é retirado de produção, não existe diferença entre uma solução “limpa e correta” e outra “rápida e suja”. Ao contrário de dívida financeiro, quando um sistema é aposentado toda seu dívida técnica é aposentada com ele. Consequentemente, perto do fim da vida de um sistema se torna muito mais difícil justificar o custo do investimento em qualquer coisa do que o que for mais prático e imediato.

## Garanta que está Incorrendo no Tipo Certo de Dívida Técnica

Alguns dívidas são tomadas em grandes pedaços: _“Não temos tempo de implementar isso agora mesmo; apenas faça um hack e vamos corrigir depois que lançarmos.”_ Conceitualmente é como comprar um carro – é um dívida grande que pode ser acompanhada e gerenciada (Chamaremos de **Tipo II.A.1**.)

Outros dívidas acumulam por assumir centenas ou milhares de pequenos atalhos – nomes de variáveis genéricas, comentários escassos, criar uma classe onde deveria ter criado duas, não seguir convenções de código, e assim por diante. Esse tipo de dívida é como uma dívida de cartão de crédito. É fácil de incorrer sem intenção, ela se acumula mais rápido do que se imagina, e é difícil de rastrear e gerenciar depois que já se incorreu nelas. (Chamaremos de **Tipo II.A.2**.)

Ambos os tipos de dívidas são comumente incorridas em resposta à diretiva _“Lancem o mais rápido possível.”_ Entretanto, o segundo tipo (Tipo II.A.2) não se paga no curto prazo de um ciclo inicial de desenvolvimento e **deve ser evitado**.

## Serviço da Dívida

Uma implicação importante de dívida técnica é que ela deve ser _servida._ isto é, uma vez que incorrer no dívida haverá **cobrança de juros**.

Se a dívida crescer o suficiente, eventualmente a empresa gastará mais em servir a dívida do que investir em crescer o valor de seus ativos. Um exemplo comum é base de **código legado** onde dá tanto trabalho manter o sistema em produção (isto é, “servir o dívida”) que sobra pouco tempo para adicionar novas capacidades ao sistema. Com dívida financeira, analistas falam de “taxa de dívida”, que é igual ao total do dívida dividido pelo total de ativos. Taxas de dívida altas são vistos como mais arriscadas, o que parece verdade para dívidas técnicas também.

## Atitudes Frente a Dívidas Técnicas

Como dívidas financeiras, diferentes empresas tem diferentes filosofias sobre sua utilidade. Algumas querem evitar assumir qualquer tipo de dívida, outras vêem a dívida como ferramentas úteis e apenas querem saber como usá-las com sabedoria.

Descobri que equipes de negócios geralmente parecem ter uma tolerância alta para dívida técnica do que equipes técnicas. Executivos de negócios tendem a querer entender as trocas (_tradeoffs_) envolvidas, enquanto algumas equipes técnicas parecem acreditar que a única quantidade correta de dívida técnica é zero.

A razão normalmente citada pela equipe técnica para evitar dívida totalmente é o desafio de **comunicar a existência de dívida técnica** à equipe de negócios e o desafio de ajudá-las a se lembrar das implicações da dívida técnica que foi incorrida anteriormente. Todos concordam que é uma boa idéia incorrer em dívida mais tarde no ciclo de lançamento, mas as equipes de negócios podem algumas vezes resistir na conta do tempo necessário para pagar a dívida no próximo ciclo de lançamento. O problema principal parece ser que, ao contrário de dívida financeira, dívida técnica é muito menos visível, e por isso as pessoas tem mais facilidade em ignorá-la.

## Como você torna a Carga da Dívida de uma Organização Mais Visível?

Uma organização em que trabalhamos mantém uma lista de dívidas dentro de seu sistema de rastreamento de defeitos. Toda vez que se incorre numa dívida, as tarefas necessárias para pagá-la são registradas no sistema junto com uma estimativa de esforço e um cronograma. O backlog de dívida é então rastreada, e qualquer dívida não paga em mais do que 90 dias são tratadas como críticas.

Outra organização mantém sua lista de dívidas como parte do Product Backlog de Scrum, como estimativas similares de esforço necessário para pagar cada dívida.

Cada um desses jeitos podem ser utilizados para aumentar a **visibilidade** da carga da dívida e do trabalho do serviço da dívida que precisa ocorrer pelos próximos ciclos de lançamento. Cada um também dá uma segurança contra acumulação de “dívidas de cartão de crédito” de uma montanha de pequenos atalhos como mencionado antes. Você pode simplesmente dizer à equipe: _“se o atalho que estão considerando assumir é muito pequeno para adicionar à lista/product backlog de serviço de dívida, então é pequeno demais para fazer qualquer diferença; não tomem esse atalho. Queremos apenas atalhos que podemos rastrear e reparar depois.”_

## Habilidade de Assumir Dívidas de Forma Segura Varia

Diferentes equipes terão diferentes avaliações de crédito para se envididar. A avaliação de crédito reflete a habilidade de uma equipe em pagar dívida técnica depois que ela foi incorrida.

Um fator chave na habilidade de pagar dívidas técnicas é o nível de dívidas que uma equipe toma sem intenções, isto é, quanto é do Tipo I? Quanto menos dívida uma equipe criar para si mesma através de trabalho de baixa qualidade, tanto mais dívida ela consegue absorver de forma segura por razões estratégicas. Isso é verdade independentemente se estamos falando de assumir dívidas Tipo I vs Tipo II ou se estamos falando de assumir dívidas do Tipo II.A.1 vs Tipo II.A.2.

Uma empresa rastreia dívidas vs. velocidade da equipe. Uma vez que a velocidade da equipe começa a cair como resultado de servir sua dívida técnica, ela foca em reduzir sua dívida até que a velocidade se recupere. Outro jeito é rastrear retrabalho, e usar isso como medida de quanta dívida uma equipe está acumulando.

## Aposentando a Dívida

“Acabar com a Dívida” pode ser motivacional e bom para a moral da equipe. Um bom jeito quando dívida de curto-prazo foi incorrido é tomar a primeira iteração de desenvolvimento depois de um lançamento e devotar para pagar a dívida técnica de curto prazo.

A habilidade de pagar dívidas depende pelo menos em parte do tipo de software que a equipe está trabalhando. Se uma equipe incorrer em dívida de curto prazo numa aplicação web, um novo lançamento pode facilmente ser instalado depois que a equipe fizer o trabalho de redução da dívida. Se a equipe incorrer em dívida de curto prazo em firmware de aviões – o pagamento, que requer substituir uma caixa no avião – essa equipe terá um critério muito maior para assumir _qualquer_ dívida de curto prazo. É como pagamento mínimo – se seu pagamento mínimo é 3% do seu balanço, não tem problema. Se o pagamento mínimo é $1000 independente do seu balanço, você terá que pensar muito mais antes de assumir qualquer dívida.

## Comunicando sobre Dívidas Técnicas

O vocabulário de dívida técnica fornece uma maneira de se comunicar com equipes não-técnicas em uma área que tem tradicionalmente sofrido pela falta de **transparência**. Mudar o diálogo de vocabulário técnico para financeiro fornece um framework muito mais claro e entendível para essas discussões. Embora a terminologia de dívida técnica ainda não esteja em muito uso, eu descobri que ela ressoa imediatamente com cada executivo para quem apresentei assim como para outros stakeholders não-técnicos. Também faz sentido para equipes técnicas que normalmente estão muito conscientes da carga da dívida que sua organização carrega.

Aqui vão alguma sugestões para comunicar sobre dívida com stakeholders não-técnicos:

_Use o orçamento de manutenção da organização como um proxy aproximado para seu serviço de dívida técnica._ Entretanto você precisará diferenciar entre manutenção que mantém o sistema de produção rodando vs. manutenção que extende as capacidades do sistema de produção. Somente a primeira categoria conta como dívida técnica.

_Discutir dívida em termos monetários do que em termos de funcionalidade._ Por exemplo, _“40% de nosso orçamento em P&D vai para suportar lançamentos anteriores”_ ou _“estamos atualmente gastando $2.3 milhões por ano servindo nossas dívidas técnicas.”_

_“Garanta que está assumindo os tipos corretos de dívidas.”_ Nem todas as dívidas são iguais. Algumas dívidas são o resultado de boas decisões de negócios; outras são o resultado de práticas técnicas descuidadas ou má comunicação sobre qual dívida o negócio pretende assumir. Os únicos tipos que são realmente saudáveis são Tipos II.A.1 e II.B.

Trate a discussão sobre dívida como um diálogo constante em vez de uma única vez. Você pode precisar de diversas discussões antes que as nuances da metáfora realmente sejam absorvidas.

## Taxonomia de Dívida Técnica

Aqui vai um resumo dos tipos de dívidas técnicas:

_Nenhuma Dívida_

Backlog de Funcionalidade, funcionalidades deixadas para depois, cortar funcionalidades, etc. Nem todo trabalho incompleto é dívida. Elas não são dívidas porque não requerem pagamento de juros.

_Dívida_

- I. Dívida incorrida sem intenção por trabalho de baixa qualidade
- II. Dívida incorrida intencionalmente
- II.A. Dívida de curto-prazo, normalmente incorrida reativamente, por razões táticas.
- II.A.1. Atalhos individualmente identificáveis (como financiamento de um carro)
- II.A.2. Numerosos pequenos atalhos (como dívida de cartão de crédito)
- II.B. Dívida de longo prazo, incorrida próativamente, por razões estratégicas

## Resumo

O que você acha? Você gosta da metáfora de dívida técnica? Acha que ela é útil para comunicar as implicações de decisões técnicas/negócios para stakeholders de projetos não-técnicos? Qual sua experiência? Espero ver suas opiniões.

## Recursos

- [OOPSLA’92 Experience Report](http://c2.com/doc/oopsla92.html) de Ward Cunningham que primeiro mencionou sobre dívida técnica
- Curto [artigo do Bliki](http://www.martinfowler.com/bliki/TechnicalDebt.html) do Martin Fowler sobre dívida técnica
- Discussões no wiki c2 sobre [Complexidade como Dívida](http://www.c2.com/cgi/wiki?ComplexityAsDebt) e [Dívida Técnica](http://www.c2.com/cgi/wiki?TechnicalDebt)

