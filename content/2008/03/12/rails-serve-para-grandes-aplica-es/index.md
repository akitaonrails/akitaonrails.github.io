---
title: Rails serve para grandes aplicações?
date: '2008-03-12T02:17:00-03:00'
slug: rails-serve-para-grandes-aplica-es
tags:
- rails
- pitch
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/12/illustration2006061201.jpg)

Hoje recebi mais um e-mail de uma pessoa perguntando _“Será que Ruby on Rails serve para criar aplicações grandes e robustas, como um ERP?”_

Me perguntam muito isso. Sendo direto ao assunto, se alguém me perguntasse isso no meio do caminho e precisasse de uma resposta rápida acho que o mais coerente seria dizer _“Não”_. Mas não parem aqui! A resposta mais longa seria _“Talvez”_.


### ERPs

Enterprise Resource Planning. Essa palavra chega a ser meio alienígena dentro de certos círculos de desenvolvedores. Para começar não é muito fácil encontrar desenvolvedores que tenham real experiência do que é realmente um ERP. O [definição da Wikipedia](http://en.wikipedia.org/wiki/Enterprise_resource_planning) não é suficiente para entender do que isso se trata.

Porém ERPs estão por aí há décadas, literalmente. O maior de todos, a SAP, já tem mais de 30 anos. Compare com a Web que atingiu o público para valer mesmo só depois de 1995, ou seja, pouco mais de 1 década. Mas não vamos subestimá-la! As tecnologias de internet permitiram aos ERPs darem um grande salto de qualidade, coisa que com certeza ajudou a acelerar a globalização e o capitalismo moderno.

Comece com uma pequena empresa. Ela fabrica alguns produtos e quer um sistema que os ajude a controlar suas vendas. Existem centenas com esse perfil, vide as enormes quantidades de tutoriais de “Shopping Carts”. Para muitos, isso é um grande sistema. Vejamos as coisas mais óbvias:

- Listar diversos produtos, permitir procuras rápidas, hierarquização, etc
- Permitir ao usuário escolher e colocar tudo num “carrinho de compras” virtual
- Ter um processo simples de fechamento da compra
- Talvez ter alguma integração com o sistema financeiro, por exemplo, para compras com cartão de crédito
- Emitir uma recibo e um e-mail de confirmação

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/12/51FGAQS6T9L._BO2_204_203_200_PIsitb-dp-500-arrow_TopRight_45_-64_OU02_AA240_SH20_.jpg)

São os comportamentos óbvios. Agora vejamos o que tem por trás disso:

- Controle de estoque e demanda, para saber quais produtos podem ser listados ou quais podem ser prometidos (ex. não disponível agora, estimado para daqui 2 semanas)
- Precificação flexível e customizável: diferentes impostos dependendo dos locais de entrega (ICMS, que varia de estado para estado), preços ‘corporativos’ para vendas a diferentes clientes (alguns clientes preferenciais poderiam ter mais descontos que outros), promoções sazonais (ex. natal, liquidações)
- Controle de demanda: forecast para o futuro sobre demanda de produtos. Os dados de vendas, numa empresa que também as manufatura, são importantes para prever quanto precisam fabricar para o futuro, isso significa integração entre os processos de venda e de fabricação
- Feedback de clientes, suporte, controle de qualidade. O ciclo de venda não se fecha quando o cliente termina de comprar. Ele continua quando o cliente volta tanto para comprar mais quanto para reclamar. O processo de qualidade, por sua vez, deveria influenciar mudanças e melhorias no processo de fabricação
- Novamente, a venda não acaba no e-mail de confirmação: uma vez vendido agora o produto precisa ser entregue. Se o alcance for nacional então, o processo logístico é ainda mais complexo sendo necessário também manter relacionamento com diversas empresas que fornecem serviços de logística, rotas otimizadas, etc
- Vender significa receita, produção, entrega, salário dos funcionários, relacionamento com cliente, é custo. Um processo financeiro robusto é indispensável e deve ser o coração da empresa. Serviços de contabilidade, livros fiscais, fiscalização do pagamento dos impostos, etc
- Falando em finanças há ainda outro aspecto de um negócio: ativos. Uma empresa precisa controlar seu maquinário da fábrica, computadores, imóveis, investimentos, etc. Controlar ativos, depreciação, realocação, inventário, etc.
- Ter um negócio significa ter funcionários: do faxineiro ao presidente da empresa. Contratar é a parte fácil, mantê-los é o difícil. Planejamento de férias, benefícios, licenças maternidade, pagamento de salários, planos de carreira, investimento em capacitação. Não é fácil manter um processo sadio de recursos humanos.
- Colocar um produto na lista do website é apenas o passo final. Se você fabrica determinado produto precisa compor um projeto: investimentos iniciais projetando possíveis receitas no futuro, recursos necessários, tempo, matérias-primas, fornecedores. O processo de manufatura é muito mais complexo do que simplesmente ‘botar a mão na massa’.
- Relacionamento com Clientes, ou CRM, é uma palavra da moda. Outra palavra igualmente importante é SRM, ou Relacionamento com Fornecedores. As duas pontas precisam fechar e Supply Management eficiente, ligando a ponta que começa no fornecedor e segue seu longo caminho por todos os processos da empresa até chegar ao cliente.

E isso é apenas um resumo altamente grosseiro e curto. Cada um desses bullet points compõe enormes e intrincados processos e procedimentos que, na sua soma, formam uma Empresa. Em maior ou menor grau, toda empresa tem esses processos, algumas micro-empresas talvez apenas não tenham uma separação tão clara porque uma única pessoa acaba acumulando funções de gestor, contador, vendedor tudo ao mesmo tempo. Por exemplo, um profissional autônomo, como consultores, médicos, ou qualquer pessoa jurídica é essencialmente uma empresa de uma pessoa só. Controlar finanças, investimentos, projetos, relacionar com clientes, contatos, translado, viagens, etc são todos processos.

Antigamente só havia uma forma de controlar isso: vastas cadeias hierárquicas com diversos caciques em diversos departamentos controlando tudo literalmente no grito e no papel. De 60 anos para cá, os computadores automatizados permitiram achatar as hierarquias, diminuir a burocracia do controle manual e tornar as empresas mais e mais competitivas. O desafio de toda empresa é enxugar seus processos para que eles sejam mais velozes e mais maleáveis ao ritmo do mercado.

### Automatizando o Caos

Sem entrar na parte na parte puramente de processos, como automatizar esses processos?

Bom, você pode começar como todos começam: comprando um pedaço de cada vez. Hoje você precisa controlar suas finanças, então vai no mercado e adquire um sistema financeiro. Agora você precisa controlar seu estoque, então volta ao mercado e compra um sistema de estoque. Agora você contratou mais pessoas e precisa gerenciar seus funcionários, então compra um sistema de recursos humanos. Sua empresa tem grande enfoque em atendimento ao cliente, com call center próprio e tudo mais, então vai ao mercado e compra um sistema de CRM. Desse suporte você envia muitos técnicos às ruas, por exemplo, para reparos e suporte técnico, daí volta ao mercado e adquire um sistema de fields force automation. E assim por diante.

E finalmente, você descobre que tem muitos sistemas e contrata um gerente de TI que terá a amarga tarefa de fazer todos esses sistemas conversarem entre si. E quando o mais recém-contratado chega ele fantasia _“como seria bom se já existisse tudo isso integrado …”_

Claro que existe, e esse é o papel dos ERP: Planejamento de Recursos de uma Empresa. E daí figuram nomes grandes como SAP, Oracle (que é um conglomerado com empresas como J.D.Edward e Peoplesoft). No Brasil existem ERPs nacionais para pequenas e médias empresas como Microsiga e Datasul.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/12/2068438.jpg)

E por que as empresas, quando começam, já não adquirem produtos completos como esse? Simples: porque não compensa. Sistemas pesados como esse só fazem sentido quando sua empresa já tem processos consolidados e estáveis, nem que sejam na base do papel. Se sua empresa cresceu sendo paternalista, centralizada, sem valores e missões consolidadas, um ERP pode ser uma catástrofe.

Uma empresa moderna precisa de “Planejamento”, precisa de “Previsibilidade”. Toda boa empresa de diversas estratégias de negócio e elas não vem simplesmente ao acaso ou pelo bom ou mau humor do seu presidente (leiam mais sobre [Balanced Scorecards](http://en.wikipedia.org/wiki/Balanced_scorecard), por exemplo, de Kaplan e Norton). Exatamente por isso usa-se Enterprise Resource **Planning**. Isso vem do entendimento que não existem recursos infinitos, nem capital infinito e muito menos tempo infinito. A empresa que melhor souber aproveitar a escassez desses recursos é que se tornará mais competitiva dentro de seu mercado. É o princípio da Economia.

Processos de negócio, apesar de serem cobertos por uma ampla gama literária, não são receitas de bolo que podem ser facilmente seguidas passo a passo. Existem vários guidelines, linhas mestras, que não se pode negligenciar, mas existe um amplo vazio que precisa de muito fine tuning, tweaking, ajustes diários até até que todas as engrenagens girem com o menor atrito possível.

Uma empresa que está começando do zero não tem esse know-how, esse conhecimento nem essa experiência. Por isso que sistema automatizados não fazem bem a elas: não há o que automatizar ainda. Fora do básico, como contabilidade, uma planilha o resto é tempo. Entre consultores até temos uma piada sobre ERP = Excel Resource Planning, querendo dizer que um dia o Microsoft Excel seria o líder de ERPs já que tantas empresas controlam tudo sobre dezenas e dezenas de planilhas. Aliás, um adendo, não existe planilha melhor que o Excel, talvez o melhor produto que a Microsoft já lançou. Dela dependem o bem estar de centenas de empresas pelo mundo. E não pensem que apenas pequenas empresas tem processos caóticos. Mesmo empresas multi-milionárias ainda tem sérios problemas de processos, mandos e desmandos, ‘jeitinhos’ e toda gama de más atitudes que eventualmente podem acabar por limá-la do mercado. A menos, claro, que tenha a dinheiro do governo por trás, _cof_ Petrobrás _cof_. Sem brincadeira, empresas públicas estão entre as mais desorganizadas e ineficientes de todas, salvo raras exceções. É o único caso onde se tem virtualmente ‘dinheiro infinito’ e, como todos sabemos, só nos tornamos eficientes quando temos escassez de recursos. Abundância sempre nos torna preguiçosos e ineficientes.

Pois bem. Sua empresa prosperou, cresceu, abriu filiais, contratou pessoas, aumentou a produção, investiu em capacitação, melhoria de processos, etc. Chegou a hora de dar continuidade nesse processo de fine tuning e integrar e automatizar os diversos processos para torná-los mais ágeis. Eis que entra a decisão: escrever in house, ou adquirir no mercado? O movimento mais seguro para corporações gigantes é unir várias estratégias: adquirir no mercado o que é considerado commodity e desenvolver in house o que é considerado crítico.

### In House?

Na área de pequenas empresas existem os sistemas proprietários, ou _in house_, desenvolvidas dentro da própria empresa que as utiliza. Nesse nicho figurou durante muito tempo plataformas como dBase, Clipper, Dataflex, Powerbuilder, FoxPro, Visual Basic e, até o começo deste século, Delphi. Agora com todos esses fora da jogada, os olhos se voltaram aos novos players: Microsoft .NET e Java J2EE.

Finalmente, de volta à pergunta original: _“Ruby on Rails serve para desenvolver um ERP?”_ A resposta é _“Não”_ . Primeiro de tudo: se alguém está me perguntando isso, não tem idéia do que é um ERP nem o que é um “sistema robusto”. São palavras abstratas de quem nunca se encontrou preso no meio das engrenagens de processos de grandes empresas.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/12/konica-minolta-fig01.gif)

O cerne por trás do sucesso de sistemas como as da ERP está em uma palavra-chave: “Integração”. “Processos integrados”. Integração significa que não existem 10 sistemas, cada um com 10 tabelas repetindo os mesmos clientes, os mesmos produtos, as mesmas contas contábeis, as mesmas regras de precificação, as mesmas listas de funcionários. Duplicação de dados é o primeiro problema crítico que acontece quando você adquire diversos pequenos sistemas separados. E não estou falando de duplicação como backup, mas literalmente em sistemas separados onde atualizar os dados de clientes significa entrar manualmente em 10 sistemas e redigitá-los o tempo todo, ou mesmo recarregar arquivos textos de lá para cá. Erros humanos e erros de procedimento são uma das causas de ineficiência.

As pessoas subestimam os ERPs e as empresas que as fabricam. _“Oras, é apenas um banco de dados, meia dúzia de tabelas e algumas telinhas para entrar dados. Deve ser absolutamente trivial construir algo assim no fim de semana.”_ 30 anos entregando processos em mercados tão variados, indo desde a Aeroespacial até o Varejo massivo (redes de hipermercados) é algo que meia dúzia de programadores precisariam de algumas vidas para compreender.

Claro, ninguém está falando em substituir uma SAP. Estamos falando de mini-ERPs, processos simples, de baixa escala, para micro e pequenas empresas. Isso sim é viável, e mesmo assim ainda é um desafio. Estou sendo bastante repetitivo nisso para que o conceito fique bem claro: não subestime processos de negócios. Corolário: o programador mais inteligente provavelmente será um péssimo analista de negócios. Entender um algoritmo de computador e entender um processo de vendas são coisas completamente distintas e que exigem um corpo de conhecimentos vasto e totalmente diferentes.

Isso dito, no nicho das pequenas empresas existem várias, dezenas, que começaram a desenvolver seus sistemas há cerca de 10 ou 15 anos atrás. Hoje eles tem sistemas em Clipper ou em Delphi, rodando em produção e controlando a empresa diariamente. Já tentaram ao máximo dar sobrevida a esses sistemas, mas está cada vez mais difícil expandir a empresa sentada sobre sistemas arcaicos que já deram o que tinham que dar. Sua equipe de clipeiros ou delpheiros está obsoleta mas você não quer se desfazer deles já que, neste ponto, o programador finalmente já incorporou os processos da empresa onde trabalha há tanto tempo. O que fazer?

### De Java a Ruby on Rails

Programei muito em dBase/Clipper entre 1989 e 1994, fiz pequenos sistemas contábeis, sistemas de controle de estoque, o arroz com feijão da época. Comecei a aprender Delphi em 1995, na versão 1.0 de 16-bits. Em paralelo ao Delphi também aprendi Visual Basic 3.0.

Até hoje essas plataformas ainda existem de uma forma ou de outra. Já aprender Java é difícil. Muito difícil. Eu pessoalmente comecei a aprender Java na versão 0.9x em 1995. Acompanhei toda sua evolução e todo o espantoso mercado que se formou à sua volta. Até hoje, “orientação a objetos” é uma abstração que desafia muitos delpheiros e vbzeiros.

Pela minha experiência, na média, um bom programador Java (ou seja, um programador minimamente útil) não se forma em menos de 2 anos. Estamos falando em aprender todos os principais truques do livro, Design Patterns, J2EE, tudo que se deve usar e tudo que não se deve usar. Segurança, Escalabiliade, Performance, Modularização, Mensagens assíncronas, Integração de sistemas, protocolos, etc, etc. A lista é longa.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/12/sap.jpg)

Uma empresa que tem uma equipe de delpheiros que trabalham lá há anos não quer se desfazer deles. Alguns viram gerentes ou recebem algum cargo administrativo, mas nem sempre dá para fazer isso com todos. Fazer um sistema na plataforma Java (J2EE + todos os outros projetos complementares open source) é muito mais complexo do que a maioria dos gerentes de TI imagina. Quero dizer, codificar uma primeira versão que minimamente funciona é fácil, ela até talvez rode. Incrementá-la, expandí-la já é outra história. Normalmente, uma empresa vai gastar um bom tempo capacitando seus funcionários, contratando outros no mercado, criando uma primeira versão, usá-la por algum tempo e no final ela precisará jogar tudo fora e começar novamente ou desistir e finalmente comprar algo mais pronto no mercado. Já vi isso acontecer muitas vezes.

Tudo que eu disse exemplificando com Java também vale para .NET, apesar que .NET já é um pouco mais produtivo do que Java, na média.

Atualmente, alguns leram por aí (talvez aqui? :-) sobre esse tal de Ruby on Rails. Como ele é altamente produtivo, como é muito fácil para qualquer programador aprender a usá-la, etc. A **promessa RoR** começou a se espalhar. Antes que isso se torne um problema já aviso: Ruby on Rails não é Java, não vai substituir o Java. RoR equivale ao Java Spring+Hibernate, mas não chega nem perto da complexidade de um J2EE. RoR é apenas o front-end.

### Ruby on Rails não é Enterprise

Mas será que não consigo criar alguns processos em RoR? Controle de Finanças, Controle de Recursos Humanos, Vendas, etc em RoR? Claro que consegue. Mas não significa que você deva, pelo menos não da forma como está pensando.

Isso dito, é bem possível sim criar um pequeno ERP em RoR, mas eu preciso partir de algumas premissas: os programadores envolvidos precisam ser exímios programadores e ao mesmo tempo ter pelo menos noções de processos corporativos. Júnior e programadores baratos da Índia não servem. A empresa precisará de muita paciência e terá que ter processos maduros que possam ser facilmente descritos. A cultura da empresa não pode ser aversa a novidades.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/12/ruby-on-rails-dummies.jpg)

O programador precisa entender muito bem o que significa modularizar, particionar processos. Como criar múltiplas aplicações RoR e quais estratégias usará para fazer com todas elas se comuniquem entre si depois. Muito processamento precisará ser feito em background, ou seja, não dentro da aplicação Rails. Serviços extras como BackgroundRB ou cron jobs precisarão ser muito bem coordenados entre si.

Não é trivial, mas não é impossível chegar a uma arquitetura razoável para se criar um pequeno ERP em RoR. Com bons programadores, um projeto bem gerenciado e objetivos realistas, acho que é possível. Mas são muitos “se”, por isso, na dúvida, prefiro dizer “não” à pessoa que me pergunta, pois eu não conheço suas circunstâncias.

É o que eu sempre digo: sempre diga “não”. Na dúvida me contrate, daí entra o trabalho de um consultor: avaliar as necessidades do cliente, levantar os processos, levantar os buracos (gaps) desses processos, os pontos fracos, os pontos de melhoria, recursos disponíveis (custo, tempo e pessoas) e finalmente chegar a um plano de ação realista e somente nesse ponto pode começar a se definir o que seriam o **conjunto** de tecnologias necessárias para implementar a idéia.

Ninguém pergunta _“este trator serve para minha grande obra?”_ sem antes sequer ter a planta baixa da “grande” obra. Portanto não pergunte _“tecnologia X serve para minha grande aplicação?”_ sem antes ter uma idéia muito clara de onde se quer chegar. E isso não vale apenas para Ruby on Rails, vale para Java, vale para .NET, para qualquer coisa.

### Ruby on Rails como front-end

Mencionei isso antes, mas deixe-me elaborar. Os ERPs maduros do mercado, como SAP, foram surpreendidos pela Web. Por muito tempo não ficou claro como integrar as duas coisas: ERPs e Web. Uma das coisas atraiu certo mercado foi o de deixar as engrenagens robustas e pesadas no back-end e integrá-las a tecnologias mais flexíveis no front-end. Por exemplo, um painel HTML para call centers, que os atendentes poderiam usar para ter acessos mais rápidos aos diversos dados necessários para atender um cliente e anotar seus chamados. O front-end ou interface web, são terminais burros (dumb terminals) para coleta e pesquisa simples de dados. Esses dados são enviados para os grandes back-ends como os da SAP onde são efetivamente processados e integrados aos processos corporativos.

Esse é outro ponto onde Ruby on Rails pode ajudar. Você já tem um ERP que controla sua empresa, quer agora ter uma presença na Web para uma loja virtual, ou um atendimento ao cliente virtual, daí você faria um front-end Web em RoR e os dados coletados na página web seriam depois enviados de volta aos ERPs, que fariam o processamento de verdade.

Ou então você já tem alguns sistemas mais novos feitos em Java/J2EE. Quer front-ends para todos os seus EJBs? Também podem ser feitos front-ends RoR. Front-ends Web são commodities. RoR pode ou não ajudar a baratear esses custos. Normalmente estamos falando de custos perdidos. Não se tem receita direta desse tipo de front-end (por isso os departamentos de TI parecem tão “muquiranas” às vezes). Para a empresa como um todo, esse aplicativozinho Web não é importante, é apenas um custo necessário. Por isso o desenvolvedor não deve se sentir muito frustrado se seu cliente não parece dar ao projeto a devida “importância”, porque o que pode lhe parecer “importante” a eles é “dispensável”. A maioria dos projetos são assim: os desenvolvedores, inicialmente, parecem dar mais importância a um projeto do que ele realmente é. Por isso tantos se frustram e eventualmente se conformam a ser [programadores de cadastros](http://www.akitaonrails.com/2007/3/14/off-topic-um-desabafo), como já descrevi uma vez.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/12/Activities_01.jpg)

### Para o futuro

JRuby e Rubinius parecem segurar a chave para maior viabilidade de Ruby on Rails dentro de um ambiente corporativo. Com JRuby você mantém o legado da empresa, os sistemas e processos que já existem, e aproveita a maior produtividade de Ruby on Rails usando JRuby. A vantagem é a integração imediata e automática com toda a enorme quantidade de bibliotecas Java disponíveis tanto no mundo open source quanto os ativos da própria empresa.

Com Rubinius talvez resolva-se o grande problema de performance, deployment e outros entraves que se opõe à boa produtividade do Rails. Com sorte, isso talvez ajude a tornar Ruby mais próximo de Java sem ser o Java.

Pelo menos para uma coisa Ruby e Rails já serviu: para acelerar a evolução e a concorrência dentro do mercado de plataformas. Levantou grandes discussões no mundo Java e incitou diversas mudanças para versões futuras e incentivou a criação de linguagens e frameworks concorrentes como Groovy e Grails. Mesmo que RoR não chegue ao mundo Enterprise para valer, pelo menos já deixou sua marca e cumpriu seu papel como catalizador de mudanças de paradigma.

Concluindo: _“RoR serve para o mundo Enterprise?”_, como consultor, a resposta é _“Talvez”_. Minha recomendação: analise criticamente o framework. Crie pequenas aplicações para alguma necessidade imediata da empresa. Entenda os pontos fortes e fracos. Avalie quais são as necessidades da empresa em curto e médio prazo, quais suas expectativas e quais os objetivos empíricos que se quer atingir. Depois de uma avaliação completa, tome sua própria decisão. Não ouça o que outros lhe dizem. Nem se incomode em perguntar: as pessoas normalmente respondem o que é melhor para elas mesmas e não para seu problema. O único que entende do próprio problema é você mesmo, e quem vai se responsabilizar por ela também é você, portanto é melhor que tome uma decisão educada.

A melhor decisão é que leva em consideração a melhor relação custo-benefício. E não digo isso apenas nas cifras entre custo imediato e receita imediata. Motivação dos funcionários é importante. Empreendedorismo. Riscos. Talvez você tenha estudado o suficiente e decidiu que vale a pena investir agora e colher os frutos quanto, por exemplo, o Rubinius se tornar maduro. A Engine Yard pensou assim já que está investindo tanto tempo e dinheiro nisso. Não estou dizendo que é “a” resposta, mas dentro de determinadas circunstâncias pode fazer sentido.

Alguns podem ter decidido que Oracle Applications ou Microsoft Dynamics fazem mais sentido. Tanto faz, contanto que seja uma decisão bem embasada. Negócios não é lugar para fanatismo, fanboys, ou decisões dogmatizadas e muito menos ignorantes. Se você for um empreendedor e também um programador – por gosto – e quer unir o útil ao agradável a você, tanto melhor, desde que não se traia a básica equação do custo-benefício: o lado empreendedor sempre tem que falar mais forte que o lado programador.

Depois de um longo texto, sinto muito por não ter uma resposta no estilo passo-a-passo, mas fazer o que? É por isso que o mundo precisa de consultores ;-)

