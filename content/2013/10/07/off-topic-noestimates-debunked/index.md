---
title: "[Off-Topic] Desmontando o #noEstimates"
date: '2013-10-07T11:35:00-03:00'
slug: off-topic-desmontando-o-noestimates
translationKey: noestimates-debunked
aliases:
- /2013/10/07/off-topic-noestimates-debunked/
description: "O autor separa projetos de operações contínuas para defender estimativas, objetivos e restrições em projetos. Para ele, restrições impulsionam inovação, mas execução competente pesa mais que qualquer metodologia."
tags:
- agile
- gestao
- engenharia-de-software
- off-topic
draft: false
---

**Update:** Esqueci de mencionar uma coisa. Se você não quis ler tudo isso, ou discorda por completo, faça a si mesmo a seguinte pergunta. Você não quer prazos, então está disposto a abrir mão do prazo do seu salário também? Por que você não consegue estimar o que vai entregar e, mesmo assim, seu cliente tem que pagar?

Vamos deixar isso parelho: você adota #noEstimates se, e somente se, estiver disposto a adotar #noSalary. Seu empregador segura o seu pagamento até você entregar, e nesse cenário o valor precisa ser depreciado quanto mais tempo demorar. A CLT não permite isso, infelizmente. Mas seria um cenário interessante.

Tem muita gente falando sobre #noEstimates ultimamente. Já li boa parte dos argumentos a favor, e qualquer um pode fazer uma busca rápida no Google, então não vou ficar referenciando cada um. A essência é a seguinte: estimativas nunca vão ser boas o bastante, e quanto mais especificação e planejamento você faz, menos a qualidade delas parece melhorar. Num mercado dinâmico as especificações mudam o tempo todo, e quanto maior o esforço de estimativa, maior o desperdício. Se estimativa é tanto desperdício assim, por que não jogar tudo fora de uma vez?

Soa como uma ideia nobre, especialmente para desenvolvedores de software. Software é maleável, é abstrato, e parece simplesmente não caber nas noções tradicionais de gerenciamento de projeto. E já que estamos nessa, por que não jogar fora a ideia inteira de projetos também? Foi assim que surgiu outra moda, o #noProjects.

Minha intenção aqui não é responder a cada argumento, e esse nem é o ponto. O que vou fazer é explicar por que a ideia toda é absurda já na origem. Então vamos começar pelo básico.

Uma coisa que eu defendo desde pelo menos 2008 é olhar o gerenciamento de projetos e os mercados em geral pelos modelos de Sistemas Adaptativos Complexos, Teoria do Caos e Biologia Evolutiva. Fui muito influenciado pelas ideias de Nassim Nicholas Taleb e seu magnum opus "A Lógica do Cisne Negro". A ideia é incrível: os mercados são movidos por agentes caóticos que influenciam um sistema complexo, longe de qualquer caminho linear.

Todas as empresas são gerenciadas para lidar com médias, com sigmas limitados como margem de erro operacional. Mas quando algo grande acontece, um "Cisne Negro" como a crise econômica de 2008, a maioria não está preparada. Nenhum modelo consegue prever, e o sistema inteiro trava e desaba.

Se você não conhece a ideia, dá uma googlada rápida e vai perceber que empresas, mercados e relações entre pessoas são sistemas dinâmicos que obedecem às regras da biologia evolutiva. Sistemas descentralizados parecem ser o caminho, e esses conceitos influenciam vários dos movimentos Lean que vemos hoje. Então, sim, eu estou bem ciente desses efeitos.

Resumindo, quem tem mais chance de sobreviver num sistema complexo desses são os mais adaptáveis, muito mais do que os que se prendem rigidamente a planos. Cumprir planos de longo prazo com rigidez é o jeito mais fácil de cair quando os Cisnes Negros aparecem.

Isso me levou a outro conceito: a Teoria da Relatividade Geral de Einstein. Na cosmologia moderna, ela substituiu a Teoria de Newton. Quando aprendi isso, meu primeiro pensamento foi: se Newton está "errado", por que não usamos a Relatividade para calcular tudo no dia a dia?

A resposta é que Newton só está "errado" se você exigir dele calcular qualquer coisa. Ele não se aplica ao muito muito grande, ao cálculo gravitacional, a cálculos no nível de galáxias. Mas em tamanhos da Terra, calculando a trajetória de um avião ou de uma bala, ele continua valendo, porque as margens de erro são desprezíveis. No dia a dia dá para reduzir o problema a Newton e deixar a Relatividade Geral de lado. É uma simplificação grosseira, claro, mas me acompanhe.

O mesmo se aplica às empresas. Estamos todos sujeitos a distribuições de Lei de Potência, à Biologia Evolutiva e às forças implacáveis do Caos que fazem tudo se comportar como Sistemas Adaptativos Complexos. Mas num ambiente restrito eu vou argumentar que dá para reduzir o cálculo de volta para Curvas de Sino. Essa é a parte mais difícil de "provar", então não vou tentar agora, mas a explicação a seguir talvez te leve até lá.

Vamos definir o que é uma empresa: um conjunto de operações. Operações são atividades repetitivas, como "pagar um fornecedor", "enviar um pedido de compra", "processar a folha de pagamento" ou "transportar produtos". O conjunto dessas atividades define o que uma empresa é.

A ideia central de uma empresa é executar essas operações da forma mais eficiente possível. Você faz isso refinando o processo continuamente, em pequenos passos, ou através de um breakthrough que muda totalmente a forma de fazer uma operação específica.

Um exemplo: antigamente havia grupos inteiros de pessoas dedicadas a preencher formulários de papel e organizá-los para a informação fluir dentro da empresa. Com o surgimento dos sistemas digitais, dos ERPs, essa papelada toda deixou de ser necessária. Eliminamos uma profissão inteira de digitadores e agregamos eficiência e precisão ao sistema. Breakthroughs costumam ser a automação digital de trabalho manual, ou a eliminação completa de um processo.

Para alcançar esses breakthroughs existem os Projetos. Projetos são empreitadas temporárias, onde um grupo de pessoas se concentra para atingir um objetivo pré-estabelecido. Costumam ter data fixa de início e de entrega, orçamento fixo e quantidade fixa de pessoas envolvidas.

E aqui chegamos na parte da Estimativa. Todo projeto quer atingir algum objetivo, e no caso de um projeto de software escrevemos código para chegar lá. Para isso, criamos features e as quebramos em Casos de Uso, User Stories, Requisitos ou qualquer artefato que descreva o que precisa ser construído. Depois estimamos quanto recurso (tempo, dinheiro, pessoas) é necessário para implementar cada peça e integrá-las numa "solução" que resolve o problema.

A reclamação dos desenvolvedores é que não dá para estimar essas peças com precisão, e que projetos sempre vão sair atrasados e estourando o orçamento. Daí a ideia de não estimar nada, simplesmente começar a codar, entregar valor o mais rápido possível e considerar pronto só quando estiver pronto.

Alguns desenvolvedores ficam tão de saco cheio dessa noção que querem largar suas empresas para abrir suas próprias startups, onde vão poder fazer o que quiserem sem nenhum controle. Aí saem atrás de investidores, porque precisam de muito dinheiro e muito tempo. Claro que precisam. O que eles não percebem é que **TODO MUNDO** precisa de muito dinheiro e muito tempo.

E os investidores sabem disso: a ideia é irrelevante, execução é que é tudo. Quem merece mais dinheiro e mais tempo são exatamente os que conseguem se pressionar para entregar abaixo do orçamento e na frente de todo mundo. Fazer alguma coisa sem se preocupar com restrições é o reino do medíocre. E medíocre não merece nada.

Voltando ao básico: existe uma coisa chamada [Economia](https://pt.wikipedia.org/wiki/Economia) justamente porque os recursos não são infinitos. Tudo que tem valor tem preço, seja um produto físico ou horas trabalhadas.

Entenda o seguinte: no negócio de serviços, onde nós desenvolvedores estamos todos, seja como empregado, seja como co-fundador, valor tem só duas variáveis, qualidade e eficiência. A gente costuma enxergar qualidade como a única coisa que importa. Pior: costuma enxergar aquilo que *nós* achamos que é qualidade como a única coisa que importa.

Isso nos traz de volta ao **CONTEXTO**. A maioria dos programadores é ruim de estimativa, e a raiz disso é que eles costumam ser absolutamente incompetentes em entender contexto. Como alguém com formação em Matemática, eu leio todos esses artigos sobre processos, metodologias e coisas como "#noEstimates" como se fossem "fórmulas".

Fórmulas sozinhas não significam nada. Qualquer matemático sabe que você precisa definir um [Domínio e uma Imagem](https://pt.wikipedia.org/wiki/Dom%C3%ADnio_de_uma_fun%C3%A7%C3%A3o), a origem e o destino de todas as entradas e saídas. Se eu mostro uma fórmula como <tt>"f(x) = 1 / x"</tt>, você pode dizer que ela é inválida, porque não dá para dividir quando x é zero. Mas se eu disser que o Domínio é todo número Natural exceto o zero, agora ela é uma fórmula totalmente válida para a Imagem dos Racionais.

Então, quando alguém fala "#noEstimates", a pergunta natural é: em qual Domínio e para qual Imagem? Essa é a origem da confusão na maior parte das discussões na Internet. As pessoas argumentam a favor ou contra uma ideia porque cada uma está num Domínio diferente. Vale para Agile em geral, Lean Startups, Lean Manufacturing e por aí vai: costumam definir só práticas, procedimentos, fórmulas, mas raramente definem Domínio e Imagem. Isso gera confusão e perde o ponto.

O que eu vou definir é o seguinte: Projetos são necessários toda vez que existe um objetivo definido a ser atingido. Esse é o domínio. E vou afirmar também que quem fala "#noEstimates" está pensando no Domínio de "Operações Contínuas", enquanto Projetos são um Domínio à parte. É justamente aí que o Lean Manufacturing em geral também se encaixa.

Já expliquei Operações acima, e é onde os pequenos passos de melhoria (Kaizen) emergem. Às vezes o feedback de uma operação dá insumo suficiente para justificar um Projeto e dar um passo maior, um breakthrough.

Projetos, por outro lado, continuam sendo empreitadas temporárias. A ideia toda é estabelecer fronteiras, como restrições de tempo e custo. E voltamos à pergunta original: é impossível prever os esforços necessários para algo tão maleável quanto desenvolvimento de software?

Antes de mais nada, sim, é impossível prever com precisão exata. Vamos definir de novo: é impossível prever um número com margem zero de erro. Estimativa é previsão com margem de erro. E por que alguns projetos custam mais que o dobro e demoram mais que o dobro do que foi estimado?

Na maior parte das vezes, em 90% dos casos, porque o time é incompetente. O problema não é a estimativa, é a execução. Estimativa é o estabelecimento de uma expectativa, e expectativas precisam ser gerenciadas. Uma estimativa só é boa se o contexto for levado em conta.

A maioria não gosta de estimar por causa dos cenários "e se". E se o cliente mudar de ideia? E se a gente esbarrar num obstáculo difícil? E se um meteoro atingir a Terra e todas as criaturas vivas perecerem? "E se" não dá para gerenciar; o que dá para gerenciar é o que você sabe, criando restrições. As restrições de um projeto começam pelo objetivo. Para atingir esse objetivo, também estabelecemos as regras de engajamento, as premissas. Sem objetivos e sem premissas, não tem jogo.

Nada disso garante uma Previsão. Uma estimativa é tão boa quanto a execução. Agora a gente tem que gerenciar, e todo mundo tem que gerenciar.

De nada adianta definir regras claras e de repente ver um programador parado. Você pergunta por que ele está parado, e a resposta é "_ah, porque eu mandei email pro cliente sobre uns requisitos e ele nunca respondeu, então fiquei esperando_". Você pergunta "_e você tentou ligar pra ele?_", e a resposta costuma ser "_Não, não tentei_". Não existe quantidade de processo ou metodologia que "conserte" um funcionário incompetente. Falta de habilidade técnica dá para consertar. Má-fé não.

Os defensores do #noEstimates podem argumentar que eles não são assim, e eu acredito. Mas 90% dos projetos que fracassaram tinham funcionários assim. Programadores tendem a colocar a culpa no cliente, nos chefes, no mercado, mas nunca em si mesmos. E como programador eu vou argumentar: a maioria dos projetos fracassa por causa de funcionários preguiçosos, muito mais do que por mudança de requisitos ou tempo limitado. Quer fazer projetos darem certo? Comece pelos Recursos Humanos, depois vá atrás de metodologia e práticas.

O problema das metodologias que não declaram o Domínio sob o qual suas fórmulas funcionam é que a maioria não percebe onde esse Domínio começa: em __"ter funcionários competentes, comprometidos e habilidosos"__. A maioria adota metodologias na esperança de transformar funcionários incompetentes em competentes, e isso simplesmente não acontece.

Resolvido isso, por que precisamos de estimativas? Ou, de forma mais geral, por que precisamos de restrições? Porque essa é a essência do valor de qualquer sistema. A natureza pressiona toda espécie viva: clima mudando, comida limitada, predadores. As espécies mais adaptáveis evoluem, e as que não conseguem se adaptar perecem.

Quando alguém fala "_é impossível fazer X_", esse é provavelmente o objetivo mais valioso a perseguir. Porque a frase completa é "_é impossível fazer X com o que sabemos hoje_". Era impossível dar a volta no globo em 24 horas, hoje não é mais. Era impossível se comunicar com o outro lado do mundo em tempo real, hoje não é mais.

Restrições são a base da inovação. Se eu tivesse que definir inovação, diria que "é o processo pelo qual você realiza algo que antes era considerado impossível".

Se você tem recursos infinitos, ou simplesmente não precisa se preocupar com restrições, que é o que acontece nas bolhas, você não inova. Isso é tão importante que vou repetir:

<blockquote>Inovação é o subproduto das Restrições.</blockquote>

A gente estima com base no conhecimento passado. Se não conseguimos superar o nosso próprio passado, o quão incompetentes somos? Dá para argumentar que software não é previsível, e eu concordo. Mas errar por ordens de grandeza ao recriar software parecido, para mim, cheira incompetência.

A maior parte do software que produzimos é a mesma coisa de sempre: site de conteúdo, e-commerce, e-learning, rede social, social commerce, fórum, enquete. Raramente é ideia nova ou algoritmo de ruptura. A não ser que você trabalhe em programa de pesquisa, que tipo de software realmente diferente você fez ultimamente?

Estimativa raramente é o problema. Toda estimativa parte de um conjunto de premissas, e o problema é não gerenciar essas premissas. Se os requisitos mudam, tudo bem, isso a gente sempre consegue gerenciar. O que não dá para gerenciar é o problema acumulado no último dia do projeto, quando os programadores empurraram tudo com a barriga. De novo, isso é um problema de Recursos Humanos.

Meritocracia só existe num sistema de escassez, onde um se destaca em relação ao outro diante de uma restrição. Num sistema de pura abundância, não há necessidade de inovar nem de mérito. Empresas que acabaram de receber uma quantidade absurda de grana invariavelmente mostram sintomas de preguiça, muito mais do que de inovação.

A confusão acontece porque algumas das "práticas" defendidas vêm dessa situação temporária e irreal de bolha, e não aguentam a pressão do tempo. Dá tempo suficiente e você vai se perguntar: "como é que a gente, com tanto dinheiro e tanto tempo, conseguiu tão pouco, e aquela startupzinha, com recursos tão limitados, conseguiu nos superar?". Essa é a resposta de por que um Yahoo! compra um Tumblr, por que um Facebook compra um Instagram, por que um [Google compra um Waze](https://en.wikipedia.org/wiki/List_of_mergers_and_acquisitions_by_Google).

Se você defende #noEstimation, por que não dar mais um passo e defender #noWork? É só um passo a mais.
