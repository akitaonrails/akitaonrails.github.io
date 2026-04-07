---
title: "[Off-Topic] Desmontando o #noEstimates"
date: '2013-10-07T11:35:00-03:00'
slug: off-topic-desmontando-o-noestimates
translationKey: noestimates-debunked
aliases:
- /2013/10/07/off-topic-noestimates-debunked/
tags:
- off-topic
- principles
- management
- agile
- traduzido
draft: false
---

**Update:** Uma coisa que esqueci de mencionar. Se você não quis ler tudo isso ou se discorda por completo, faça a si mesmo a seguinte pergunta: você não quer prazos. Então está disposto a abrir mão do prazo do seu salário também? Por que você não consegue estimar o que vai entregar e mesmo assim seu cliente tem que pagar? Vamos deixar isso parelho: você adota #noEstimates se, e somente se, estiver disposto a adotar #noSalary. Seu empregador deve segurar seu pagamento até você entregar e, nesse cenário, seu pagamento precisa ser depreciado quanto mais tempo demorar. Infelizmente a CLT não permite isso. Mas seria um cenário interessante.

Tem muita gente falando sobre #noEstimates ultimamente. Já li boa parte dos argumentos a favor e qualquer um pode fazer uma busca rápida no Google, então não vou ficar referenciando cada um deles. A essência é a seguinte: estimativas nunca vão ser boas o bastante, quanto mais especificação e planejamento você faz menos a qualidade das estimativas parece melhorar, principalmente porque num mercado dinâmico as especificações mudam o tempo todo e quanto mais esforço de estimativa, mais desperdício. E como estimativas parecem ser tanto desperdício assim, por que não jogar tudo fora de uma vez?

Soa como uma ideia nobre, especialmente para desenvolvedores de software. Software é maleável, é abstrato, parece simplesmente não caber nas noções tradicionais de gerenciamento de projeto. E já que estamos nessa, por que não jogar fora a ideia inteira de projetos também? E aí surgiu outra moda: o #noProjects.

Minha intenção aqui não é responder cada um dos argumentos, esse não é o ponto. O que vou fazer é explicar por que a ideia toda é absurda já na origem. Então vamos começar pelo básico.

Uma coisa que eu defendo desde pelo menos 2008 é a ideia de gerenciamento de projetos e mercados em geral pelos modelos de Sistemas Adaptativos Complexos, Teoria do Caos e Biologia Evolutiva. Fui muito influenciado pelas ideias de Nassim Nicholas Taleb e seu magnum opus "A Lógica do Cisne Negro". É uma ideia incrível: os mercados não estão presos a caminhos lineares, e sim a agentes caóticos que influenciam um sistema complexo. Todas as empresas são gerenciadas para lidar com médias, com sigmas limitados como margem de erro operacional. Mas quando algo grande acontece, um "Cisne Negro", como a crise econômica de 2008, a maioria não está preparada, nenhum modelo consegue prever e o sistema inteiro trava e desaba.

Se você não conhece a ideia, dá uma googlada rápida e vai perceber que empresas, mercados e relações entre pessoas em geral são sistemas dinâmicos que obedecem às regras da biologia evolutiva. Sistemas descentralizados parecem ser o caminho. E esses conceitos influenciam vários dos movimentos Lean que vemos hoje. Então, sim, eu estou bem ciente desses efeitos.

Mas, resumindo, a essência é: quem tem mais chance de sobreviver num sistema complexo desses são os mais adaptáveis, e não os que se prendem rigidamente a planos. Cumprir planos de longo prazo com rigidez é o jeito mais fácil de cair quando os Cisnes Negros aparecem.

Dito isso, isso me fez pensar em outro conceito: a Teoria da Relatividade Geral de Einstein. Na cosmologia moderna, ela substituiu a Teoria de Newton. Quando aprendi isso, meu primeiro pensamento foi: se Newton está "errado", por que não usamos a Relatividade para calcular tudo no nosso dia a dia? A resposta é que a teoria de Newton só está "errada" se você definir como sendo capaz de calcular tudo, mas não é isso. Ela não pode ser aplicada ao muito muito grande, ao cálculo gravitacional, a cálculos no nível de galáxias. Mas se você limita a tamanhos da Terra, calculando a trajetória de um avião, a trajetória de uma bala etc, ela continua aplicável, porque as margens de erro são desprezíveis. Então, no dia a dia, dá para reduzir o problema a Newton e não usar Relatividade Geral. Isso é uma simplificação grosseira, claro, mas me acompanhe.

O mesmo se aplica às empresas. Estamos todos sujeitos a distribuições de Lei de Potência, à Biologia Evolutiva, às forças implacáveis do Caos que fazem tudo se comportar como Sistemas Adaptativos Complexos. Mas num ambiente restrito eu vou argumentar que dá para reduzir o cálculo de volta para Curvas de Sino. Essa é a parte mais difícil de "provar", então não vou tentar agora, mas a explicação a seguir talvez te leve até lá.

Vamos definir o que é uma empresa: é um conjunto de operações. Operações são atividades repetitivas. Você tem atividades como "pagar um fornecedor", "enviar um pedido de compra", "processar a folha de pagamento", "transportar produtos" etc. O conjunto dessas atividades define o que uma empresa é.

A ideia central de uma empresa é executar essas operações da forma mais eficiente possível. Você faz isso refinando o processo continuamente em pequenos passos ou através de um breakthrough, mudando totalmente a forma como você faz uma operação específica. Por exemplo, antigamente havia grupos inteiros de pessoas dedicadas a preencher formulários de papel e organizá-los para fazer a informação fluir dentro da empresa. Com o surgimento dos sistemas digitais, ERPs, hoje toda essa papelada não é mais necessária. Conseguimos eliminar uma profissão inteira de digitadores e agregamos eficiência e mais precisão ao sistema. Breakthroughs costumam ser a automação digital de trabalho manual ou a eliminação completa de um processo.

Para alcançar esses breakthroughs existem os Projetos. Projetos são empreitadas temporárias onde um grupo de pessoas se concentra para atingir um objetivo pré-estabelecido. Projetos normalmente têm data fixa de início e de entrega, orçamento fixo e quantidade fixa de pessoas envolvidas.

E aqui chegamos na parte da Estimativa: todo projeto quer atingir algum objetivo. No caso particular de um projeto de software, implementamos código para atingir esse objetivo. Para atingir um objetivo, criamos features de software e as quebramos em Casos de Uso, User Stories, Requisitos ou qualquer artefato que descreva o que precisa ser construído. E aí estimamos quanto recurso (tempo, dinheiro, pessoas) é necessário para implementar cada uma dessas peças e integrá-las numa "solução" que resolve o problema e atinge o objetivo.

A reclamação dos desenvolvedores de software é que não dá para estimar essas peças com precisão e que projetos sempre vão ser entregues atrasados e estourando o orçamento. Então a melhor ideia seria não estimar nada e simplesmente começar a codar e entregar valor o mais rápido possível, considerando pronto só quando estiver pronto.

Alguns desenvolvedores ficam tão de saco cheio dessa noção toda que querem largar suas empresas para abrir suas próprias startups de tecnologia, onde vão poder fazer o que quiserem sem nenhum controle. Aí saem procurando investidores porque precisam de muito dinheiro e muito tempo. Claro que precisam. O que eles não percebem é que **TODO MUNDO** precisa de muito dinheiro e muito tempo. E os investidores sabem disso: a ideia é irrelevante, execução é que é tudo. As pessoas que merecem mais dinheiro e mais tempo são exatamente as que conseguem se pressionar para entregar abaixo do orçamento e na frente de todo mundo. Apenas fazer alguma coisa sem se preocupar com restrições é exatamente o reino do medíocre. E medíocre não merece nada.

Voltando ao básico: existe uma coisa chamada [Economia](http://en.wikipedia.org/wiki/Economy) justamente porque os recursos não são infinitos. Tudo que tem valor tem preço, seja um produto físico ou horas trabalhadas.

Entenda isto: no negócio de serviços (onde nós, desenvolvedores de software, todos estamos, independente de ser empregado, co-fundador etc), valor tem só duas variáveis: qualidade e eficiência. Costumamos enxergar qualidade como a única coisa que importa. Pior: costumamos enxergar aquilo que *nós* achamos que é qualidade como a única coisa que importa.

Isso nos traz de volta ao **CONTEXTO**. A maioria dos programadores é ruim de estimativa. E a raiz da coisa é porque eles costumam ser absolutamente incompetentes em entender contexto. Como alguém com formação em Matemática, eu leio todos esses artigos sobre processos, metodologias e coisas como "#noEstimates" como "fórmulas".

Fórmulas sozinhas não significam nada. Qualquer matemático sabe que você precisa definir um [Domínio e uma Imagem](http://en.wikipedia.org/wiki/Domain_of_a_function), a origem e o destino de todas as entradas e saídas. Por exemplo, se eu mostro uma fórmula como <tt>"f(x) = 1 / x"</tt> você pode argumentar que ela é inválida e errada, porque eu não posso dividir se x for zero, por exemplo. Mas se eu disser que o Domínio é todo número Natural exceto o zero, agora ela é uma fórmula totalmente válida para a Imagem dos Racionais.

Então, quando alguém fala "#noEstimates", a pergunta natural é: em qual Domínio e para qual Imagem? Essa é a origem da confusão na maior parte das discussões na Internet: as pessoas vão argumentar a favor ou contra uma ideia porque cada uma está num Domínio diferente. É a mesma coisa para Agile em geral, Lean Startups, Lean Manufacturing etc. Geralmente eles definem só práticas, procedimentos, fórmulas, mas raramente definem Domínio e Imagem. Isso gera confusão e perde o ponto.

O que eu vou definir é o seguinte: Projetos são necessários toda vez que existe um objetivo definido a ser atingido. Esse é o domínio. E também vou afirmar que quando as pessoas falam "#noEstimates" elas não estão no Domínio de Projetos, e sim no de "Operações Contínuas". Aliás, é justamente nesse domínio que o Lean Manufacturing em geral também se encaixa. Já expliquei Operações acima, e é onde os pequenos passos de melhoria (Kaizen) emergem. Às vezes o feedback de uma operação dá insumo suficiente para justificar um Projeto e dar um passo maior, um breakthrough.

Projetos, por outro lado, continuam sendo uma empreitada temporária. A ideia toda é estabelecer fronteiras, como restrições de tempo e custo. E voltamos à pergunta original: mas é impossível prever os esforços necessários para algo tão maleável quanto desenvolvimento de software.

Antes de mais nada, sim, é impossível prever com precisão exata. De novo, vamos definir: é impossível prever um número com margem zero de erro. Estimativa é previsão com margem de erro. E por que alguns projetos custam mais que o dobro e demoram mais que o dobro do que foi estimado?

Na maior parte das vezes, porque o time é incompetente, em 90% dos casos. O problema não é a estimativa, é a execução. Estimativa é o estabelecimento de uma expectativa. Expectativas precisam ser gerenciadas. Uma estimativa só é boa se o contexto for levado em conta. A maioria não gosta de estimar por causa dos cenários "e se". E se o cliente mudar de ideia? E se a gente encontrar um obstáculo difícil? E se um meteoro atingir a Terra e todas as criaturas vivas perecerem? Não dá para gerenciar "e se", o que dá para gerenciar é o que você sabe e criar restrições. As restrições de um projeto começam pelo seu objetivo. Para atingir esse objetivo, também estabelecemos as regras de engajamento: as premissas. Sem objetivos e sem premissas, não tem jogo.

Nada disso garante uma Previsão. Uma estimativa só é tão boa quanto a execução. Agora a gente tem que gerenciar. Todo mundo tem que gerenciar. Não adianta nada definir regras claras e de repente você ver um programador parado e, quando pergunta por que ele está parado, a resposta é "_ah, porque eu mandei email pro cliente sobre uns requisitos e ele nunca respondeu, então fiquei esperando_". E quando você pergunta _"e você tentou ligar pra ele?"_, a resposta normalmente é _"Não, não tentei"_. Não existe quantidade de processo ou metodologia que "conserte" um funcionário incompetente. Falta de habilidade técnica dá para consertar. Má-fé não.

Os defensores do #noEstimates podem argumentar que eles não são assim, e eu acredito. Mas 90% dos projetos que fracassaram tinham funcionários assim. Programadores tendem a colocar a culpa no cliente, nos chefes, no mercado, mas nunca em si mesmos. E como programador eu vou argumentar: a razão pela qual a maioria dos projetos fracassa não tem nada a ver com mudança de requisitos ou com tempo limitado, tem a ver com funcionários preguiçosos. Quer fazer projetos darem certo? Comece pelos Recursos Humanos primeiro, depois vá atrás de metodologia e práticas.

O problema com todas as metodologias que não declaram o Domínio sob o qual suas fórmulas funcionam é que a maioria não percebe que o Domínio começa com __"ter funcionários competentes, comprometidos e habilidosos"__. A maioria adota metodologias na esperança de transformar funcionários incompetentes em competentes, e isso simplesmente não acontece.

Resolvido isso, por que precisamos de estimativas? Ou, mais genericamente, por que precisamos de restrições? Porque essa é a essência do valor de qualquer sistema. A natureza pressiona toda espécie viva: clima mudando, comida limitada, predadores. As espécies mais adaptáveis evoluem, as que não conseguem se adaptar perecem.

Quando alguém fala _"é impossível fazer X"_, esse é provavelmente o objetivo mais valioso a perseguir. Porque a frase completa é: _"é impossível fazer X com o que sabemos hoje"_. Era impossível dar a volta no globo em 24 horas, hoje não é mais. Era impossível se comunicar com o outro lado do mundo em tempo real, hoje não é mais.

Restrições são a base da inovação. Se eu tivesse que definir inovação, eu diria que "é o processo pelo qual você consegue realizar algo que antes era considerado impossível".

Se você tem recursos infinitos, ou se simplesmente não precisa se preocupar com restrições (que é o que acontece em bolhas), você não inova. Isso é tão importante que vou repetir:

<blockquote>Inovação é o subproduto das Restrições.</blockquote>

A gente estima com base no conhecimento passado. Se a gente não consegue superar a si mesmo no passado, o quão incompetente a gente é? Quer dizer, dá para argumentar que software não é previsível, e eu concordo. Mas errar por ordens de grandeza ao recriar software parecido, para mim, cheira incompetência. A maior parte do software que produzimos não é ideia nova, não é algoritmo novo de ruptura. É praticamente tudo a mesma coisa: site de conteúdo, e-commerce, e-learning, rede social, social commerce, fórum, enquete. A não ser que você trabalhe em programa de pesquisa, que tipo de software diferente você fez ultimamente?

Estimativa raramente é o problema. Toda estimativa parte de um conjunto de premissas. O problema é não gerenciar essas premissas. Se os requisitos mudam, isso não é problema. A gente sempre consegue gerenciar isso. O que a gente não consegue gerenciar é o problema acumulado no último dia do projeto. E geralmente o que acontece é que os programadores empurram os problemas com a barriga. De novo, isso não é problema de estimativa, é problema de Recursos Humanos.

Meritocracia só existe num sistema de escassez, onde um se destaca em relação ao outro comparado a uma restrição. Num sistema onde só existe abundância, não há necessidade de inovar, não há necessidade de mérito. Empresas que acabaram de receber uma quantidade absurda de grana invariavelmente vão mostrar sintomas de preguiça, e não de inovação. A confusão acontece porque algumas das "práticas" que estão sendo defendidas vêm dessa situação temporária e irreal de bolha, e não aguentam a pressão do tempo. Dá tempo suficiente e você vai perceber "como é que a gente, com tanto dinheiro e tanto tempo, conseguiu tão pouco, e essa outra startupzinha, com recursos tão limitados, conseguiu nos superar?". E essa é a resposta de por que um Yahoo! compra um Tumblr, por que um Facebook compra um Instagram, por que um [Google compra um Waze](http://en.wikipedia.org/wiki/List_of_mergers_and_acquisitions_by_Google).

Se você defende #noEstimation, por que não dar mais um passo e defender #noWork? É só um passo a mais.
