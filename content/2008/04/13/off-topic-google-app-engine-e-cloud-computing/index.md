---
title: 'Off-Topic: Google App Engine e Cloud Computing'
date: '2008-04-13T01:27:00-03:00'
slug: off-topic-google-app-engine-e-cloud-computing
tags:
- cloud-computing
- google
draft: false
---

Assim como _Web 2.0_, outro termo usado o tempo todo é **Cloud Computing**. Muita gente usa para designar muitas coisas. Outro termo usado como sinônimo – mas não sendo exatamente a mesma coisa – é **Web Services** (não o padrão XML), que na realidade não é nada novo, é o que antigamente chamávamos de ASPs (Application Service Providers). Exemplos disso são serviços como Basecamp para gerenciar projetos sem que a empresa precise gastar em manutenção ou mesmo seu Webmail favorito. São serviços online onde você paga para não precisar se preocupar com infraestrutura. É um tipo de outsourcing de serviços.

Esta semana o Google causou um pequeno furor ao lançar sua resposta a Cloud Computing: o [Google App Engine](http://code.google.com/appengine/). Vocês podem ver um review do Techcrunch [aqui](http://www.techcrunch.com/2008/04/08/techcrunch-labs-our-experience-building-and-launching-app-on-google-app-engine/). Mas o que é [Cloud Computing](http://en.wikipedia.org/wiki/Cloud_computing)? Antes de mais nada, vamos explicar os termos mais usados no mercado:


Nós, que somos desenvolvedores, em algum momento vamos querer colocar nossa aplicação em produção. Eis quando chega a parte mais cabeluda do processo: Deployment!

Existem várias opções. Primeiro vejamos sobre software:

- Comprar uma aplicação comercial. Casos de [commodities](http://en.wikipedia.org/wiki/Commodity) como Exchange Server. Você precisa de um pacote de software para sua empresa, existem diversos no mercado. Você escolhe, compra, instala e começa a usar. Você pode comprar uma aplicação onde você o usa como quiser, ou aplicações maiores que vendem em regime de licenças, por exemplo, licenças por usuário ou licenças por processador. Alguns softwares permitem ser extendidos e customizados, mas normalmente você precisa se adaptar ao software e não o contrário.

- Adquirir uma solução open source. Baixar da internet você mesmo, configurar e usar, ou contratar uma empresa de serviços que faça esse trabalho para você. A vantagem, obviamente, é ser livre de custos, a desvantagem é que administrar esse tipo de configuração pode representar um custo que normalmente não é levado em conta. O [TCO](http://en.wikipedia.org/wiki/Total_cost_of_ownership) não é trivial, a aplicação pode ou não ser fácil de ser modificada. Varia de caso a caso.

- Fazer o sistema in house. Ou seja, programar o sistema você mesmo, customizado às suas necessidade. É o modelo alfaiate, onde você tem uma equipe de desenvolvedores ou contrata uma software house que fará o sistema como você precisa. Costuma ser mais caro, mas por outro lado pode ser necessário se não existem softwares comerciais que façam o que você precisa. Teoricamente deveria ser o tipo de software que mais se adequa à sua empresa. Obviamente a prática não é bem assim. O TCO costuma ser alto, o software costuma não ser tão bom, você como empresa precisa mudar bastante para se adequar a qualquer tipo de sistema (seja comercial, open source ou in house). Tudo depende da maturidade da própria empresa e do terceiro contratado para desenvolvê-la. Sua milhagem vai variar bastante e os resultados são incertos.

- Usar um ASP, ou seja, você ‘aluga’ uma aplicação de mercado, em planos de licenças, mas não precisa se preocupar em como fazer o deployment, instalar, manter atualizado, etc. Exemplos disso são aplicações como SalesForce.com, É uma solução menos customizável, mas costuma ter um custo muito menor se considerar o custo total de propriedade (TCO). Em muitos casos faz sentido. Apenas é necessário uma conexão estável à internet. Pode não ser o ideal, mas mantém seus custos baixos. O modelo de serviços é uma tendência simplesmente porque a atual infra-estrutura de internet como um todo possibilita isso. Enquanto desenvolvedor você desenvolve um software que pode servir para muitas empresas diferentes mas sem o problema de ter que instalar e dar manutenção a cada um deles separadamente: uma correção no sistema central beneficia toda sua base de clientes instantaneamente.

Sobre opções de hardware, vejamos:

- Fazer o hosting você mesmo, comprando máquinas, montando redes, enfim, administrando você mesmo in loco, ou seja, fisicamente dentro do seu perímetro. À medida que sua empresa cresce, você compra mais máquinas. É mais indicado para aplicações de intranet, que apenas dizem respeito à sua empresa e não devem crescer a escalas muito difíceis de administrar. É mais indicado para empresas que tem setor de TI maduro para administrar tudo. Atualmente, toda empresa tem uma equipe mínima de TI, mas nem todas. TI normalmente não é o core-business da empresa, é considerado como custo, assim como pagar impostos. Faz sentido cuidar de tudo se seu core-business são esses sistemas.

- Fazer o hosting você mesmo, mas entendendo que crescimento não é linear. Você pode precisar de mais recursos apenas num período e não em outro, ou seja, comprar máquinas pode ser necessário apenas por um pequeno período, mas não sempre. Comprar novas máquinas o tempo todo apenas aumenta seu TCO. Nesse caso você pode “comprar” máquinas em regime de **on-demand** , como algumas linhas de servidores IBM, a chamada ‘on-demand’. Toda vez que você precisa de mais potência, liga pra IBM e pede que ela libere mais processadores na máquina que fisicamente fica no seu local. É uma solução limitada.

- Fazer co-location, onde você tem máquinas suas mas utilizando a infra-estrutura de terceiros, num CPD externo ao perímetro físico de sua empresa. É um jogo de custo-benefício, pois você normalmente não tem o expertise para manter uma infra-estrutura estável e robusta como um terceiro. Mas as máquinas são suas e é sua responsabilidade comprar mais se precisar. Em certos casos as empresas tem recursos para comprar mais máquinas, mas acabam não tendo espaço físico para concentrar tudo. Ou então a empresa tem filiais e todas precisam acessar o mesmo sistema. É mais fácil quando suas máquinas ficam num CPD responsável por manter suas máquinas ligadas o tempo todo, com rede estável e rápida, com suporte 24×7. Muitas empresas tem equipes de TI locais e sistemas fora do seu espaço físico.

- Usar _Shared Hostings_, literalmente hostings compartilhados, utilizando não somente a infra-estrutura de um terceiro, mas alugando um ‘pedaço’ da mesma máquina, compartilhada com outros clientes desse terceiro. Diversos planos podem ajudar a começar com custo mínimo de infra-estrutura, mas com a desvantagem de ser afetado negativamente quando um outro cliente usando a mesma máquina demandar mais recursos e sua aplicação sofrer gargalos, além de outros problemas como bibliotecas de sistema compartilhados e coisas assim. É um balaio de gato onde os provedores buscam soluções para melhorar isso, mas a natureza desse tipo de pacote impede algo realmente à prova de balas. Crescer num ambiente desses costuma ser limitado. Isso costuma favorecer programadores/freelancers ou pequenas empresas que precisam colocar seu website na internet mas não tem recursos para configurações muito parrudas.

- Usar _VPS_, ou Virtual Private Servers, ou seja, ainda compartilhar a mesma máquina que outros clientes desse terceiro, mas ao mesmo tempo ter a ‘sensação’ de ter uma máquina inteira apenas para você, mas virtual, isolada dos outros. É como se fosse um “Shared Co-Location”, onde a máquina não é sua, você a compartilha, mas ainda parece que tem uma máquina só sua. A vantagem é que esse isolamente o deixa livre de coisas como atualizações na máquina de um Shared Hosting ameaçando a estabilidade da sua aplicação. Costuma ser mais barato que um co-location pois você não está comprando uma máquina e sim alugando um slice (pedaço) de uma máquina que usa soluções como Xen ou VMWare. É o segundo passo para empresas que querem manter seus custos baixos mas precisam de mais flexibilidade. Mesmo assim ainda é um problema, como na situação de co-location, quando você precisa de mais slices apenas por um pequeno período mas não o tempo todo. Colocar um slice no ar costuma requerer tempo, e nesse caso você pode perder o time-to-market.

## Cloud Computing

Entendido quais são os termos usados por aí, vamos ver agora o termo da moda. Não sei se foi o primeiro, mas com certeza o que tem feito mais barulho é o modelo dos produtos da [Amazon Web Services](http://www.amazon.com/aws) como Elastic Cloud Computing ou EC2; Simple Storage Support ou S3 e SimpleDB.

Em todos eles, o principal chamariz é o conceito de **elastic** on-demand. Ou seja, você paga por quanto usa, mas não precisa manualmente ficar reconfigurando tudo toda vez que precisar de mais. Se usar mais paga mais, se voltar a usar menos, ‘elasticamente’ se paga menos. É pagamento por uso de recursos, não mensalidade fixa por recursos fixos.

Esses produtos da Amazon respondem pelos seguintes serviços:

- Storage, ou armazenamento (Amazon S3). Num modelo tradicional você compraria ou alugaria um servidor de arquivos. Storages online já existem há algum tempo, mas o S3 cria um modelo diferente de um file system normal, baseado no conceito de ‘buckets’. A vantagem da Amazon é o preço e a estabilidade. A desvantagem é que ele se baseia num modelo diferente de file system que não é inicialmente mapeável. Hoje existem dezenas de bibliotecas em diferentes linguagens, que facilitam a transição.

- Banco de dados (Amazon SimpleDB). Em vez de um Oracle, MySQL ou outros bancos de dados relacionais, a Amazon trouxe um banco de dados não-estruturado baseado em Documentos. A principal característica é a ausência de schemas fixos e, portanto, ausência da necessidade de administração custosa sobre seu domínio de dados. Logo, diminuindo a manutenção. Por outro lado ele também introduz barreiras de adoção pois ainda não existem muitos modelos, frameworks ou bibliotecas que permitam migrar trivialmente uma aplicação feita para ser relacional (usando SQL) para o modelo do SimpleDB. Novamente, a vantagem pode ser o preço.

- Virtual Private Server ou VPS (Amazon EC2). É como se você usasse VPS dinâmicas, ou elásticas. Se por algum motivo seu sistema requerer mais recursos (se houver um pico de vistas e transações no seu website), você pode ‘facilmente’ habilitar mais slices dinamicamente e derrubá-las quando não precisar mais delas. Você paga pelos recursos usados, não pela quantidade de slices que tem. Eles são dinâmicos. Você pode ter 5 slices pela manhã, 20 à tarde e voltar a ter 5 de noite. A pegadinha é que não serão necessariamente os mesmos 5 slices. É um modelo diferente que garante slices mas não quais. Sua aplicação precisa armazenar os dados fora do EC2, (ou no S3 ou no SimpleDB) para que outro slice possa assumir sem depender de dados locais. É Shared-Nothing levado às últimas consequências.

Qual a vantagem? Você pode ter o que precisa, quando precisa. Em vez de se comprometer a planos caros de co-location ou VPS, você pode colocar sua aplicação aos cuidados da Amazon e ter mais dinamicidade no seu negócio sem se preocupar se suas máquinas ‘vão aguentar’. É como se você pudesse pagar academia pela quantidade de horas que você efetivamente frequentou, em vez de pagar uma mensalidade fixa. Se parar no meio do mês, você não perde a mensalidade inteira. É uma tendência no mercado de serviços.

Qual a desvantagem? No caso da Amazon você precisa preparar sua aplicação segundo suas limitações e requerimentos. Principalmente se considerar que é normal seu slice ser derrubado. Os dados locais a esse slice são perdidos se não forem persistidos fora dele antes disso. Isso não é um problema se for levado em consideração como premissa desde o início, mas é um paradigma diferente do que estamos acostumados com co-location ou VPS clássica, onde seus dados locais são sempre permanentes e é uma responsabilidade do hosting fazer o backup para eventuais problemas.

### Google App Engine

Chegamos à novidade da semana: o Google App Engine. Na prática, é uma solução que mapeia um a um os serviços da Amazon.

- Amazon Simple DB vs Google BigTable – nenhum dos dois são bancos de dados relacionais, portanto em nenhum você poderá pensar em seus dados como um RDBMS clássico.

- Amazon S3 vs Google GFS – novamente, não é um FS clássico, como o que tem na sua máquina.

- Amazon EC2 vs App Engine – parecido mas diferente, veremos a seguir.

A vantagem do Google é que ela fez o marketing desse produto como sendo: _“Sua aplicação rodando dentro de nossa infra-estrutura”, ou seja, todos sabemos que os famosos produtos do Google como o site de procura propriamente dito, Google Reader, Gmail, Orkut, etc todos rodam numa infra-estrutura proprietária altamente escalável que tornou o Google famoso e agora ela está ‘aberta’ ([grátis mas não libre](http://en.wikipedia.org/wiki/Gratis)versus_Libre) para que outros usufruam disso. Vejamos vantagens e desvantagens:

- A desvantagem dos dois é que eles quebram paradigmas e portanto exigem aplicações feitas exclusivamente para um desses ambientes. Ou seja, escolher tanto um quanto o outro significa ficar fechado a um deles no sentido de que suportar ambos pode representar mais custos de desenvolvimento.

- A vantagem da Amazon é que seus serviços são independentes, ou seja, se você quiser apenas storage, então use o S3 sozinho. A desvantagem da Amazon é que seus serviços exigem mais conhecimento de integração que qualquer outro.

- A desvantagem do Google é que é uma proposição tudo-ou-nada: sua aplicação vai ficar toda lá dentro, não apenas pedaços. A vantagem é que o Google está proporcionando um ambiente online para administrar sua aplicação que o coloca um passo à frente em relação à Amazon quanto à usabilidade.

Neste momento o Google apenas tem suporte a aplicações escritas em Python. Particularmente ele já vem com Django pré-disponível e com APIs que facilitam o manuseio dos recursos de dados e storage. Com certeza uma grande notícia para a comunidade Python.

Isso gerou certa [comoção](http://www.profy.com/2008/04/08/google-jumps-shark-with-app-engine/) entre desenvolvedores de outras linguagens, mas isso é normal. Se não fosse o Google, passaria despercebido como “mais um provedor de serviços”. Mas sendo o Google eles obviamente sabem que sempre receberão elogios e críticas massivas. Portanto, nada mais do que o esperado. Falar bem é democrático, falar mal também. Se eles não previram isso, alguém do departamento de Public Relations precisa ser demitido.

De qualquer forma, não dêem ouvido a mais essas guerrinhas de linguagens:

- elas são fogo de palha: é apenas divertido agora

- elas não representam muita coisa: se o Google de fato previu isso e tem um bom PR, eles sairão ilesos

- o Google gosta de Python: isso é público e notório e não há nenhum problema nisso. Eles são uma empresa e empresas decidem o que querem, quando querem e como querem. O dia que vocês tiverem suas empresas, vão entender isso.

- na realidade, o Google nunca disse que o App Engine é exclusivo para Python, vejamos:

No [press release](http://www.google.com/intl/en/press/annc/20080407_app_engine.html) eles prometem suportar outras linguagens no futuro e que – como toda aplicação Web 2.0 que se preze – esta é uma versão “Beta”. Grande novidade :-) Não é uma solução perfeita mas, como tudo que vem de uma corporação massiva como o Google, tem grandes potenciais. De novo, como uma aplicação Web 2.0, ela também tem uma conta livre para que você possa fazer o test-drive do ambiente antes de decidir por um upgrade de planos. Neste momento de Beta, porém, ela ainda não é liberada.

## O que isso representa?

Em pouco tempo, quando o App Engine evoluir, passar a suportar mais ambientes de desenvolvimento além de Python, ela se torne a principal ameaça aos Web Services da Amazon, já que ela é uma cópia descarada de seus serviços. É óbvio que é seu concorrente comercial é a Amazon.

Também pode se tornar uma ameaça a serviços menores como da Joyent ([Joyent Accelerator](http://www.joyent.com/accelerator)) que é um hosting que implementa o mesmo conceito de recursos elásticos ou o recém-chegado [Heroku](http://heroku.com/) que, no fundo, é um App Engine para Rails, ou seja, ela é uma ponte entre os serviços da Amazon, configurados de uma maneira mais simples para desenvolvedores de Ruby on Rails. Claro, ela ainda não está pronta e não tem nada perto da escala do Google.

Nem os serviços do Google e nem os da Amazon são perfeitos. Aliás, falei algo óbvio: nenhum serviço é perfeito. Tudo vai depender dos seus requerimentos e como quer se comprometer. A regra continua a mesma: quanto mais você se comprometer, menos caro será no curto prazo, mais caro no longo. Quanto menos quiser se comprometer, mais caro será no curso prazo mas, talvez, seja melhor no futuro.

Ou seja, você quer algo barato mas flexível, a Amazon e o Google podem ajudar. Mas, com sorte, se um dia você crescer e quiser ficar independente, pode ser mais difícil se desvincular deles, já que sua aplicação ficou intimamente amarrada a seus serviços. Se usar um serviço mais tradicional como co-location ou VPS, pode ser mais caro agora mas no futuro você continua isolado de terceiros e pode custar menos para migrar para outros hostings que ofereçam melhores preços/qualidade.

O que pode acontecer se o App Engine do Google for bem sucedido é causar uma pressão maior no mercado de hostings para oferecer serviços mais criativos, mais baratos, com mais qualidade. Ou seja, é a lei de mercado, onde concorrência pode gerar mais benefícios para nós, consumidores. Eles que se matem enquanto nós assistimos. A curto prazo, para quem quer colocar uma aplicação no ar, é apenas mais uma variável a se considerar.

Qual o objetivo do Google nisso? Não sei se o objetivo é o mesmo dos hostings: ganhar dinheiro terceirizando sua infra-estrutura num mercado de commodities (o Google se especializou em transformar bons produtos em commodities, o que é bom e ruim ao mesmo tempo, dependendo do seu ponto de vista). Ou se for um serviço grátis, um dos objetivos é facilitar que mais e mais websites apareçam: clientes potenciais para o verdadeiro core business do Google: Ad Sense, claro. Agora, claro que eu não esperaria fazer hosting do meu equivalente-Twitter num serviço gratuito. Aliás, se seus dados são importante para você **nunca** use serviços gratuitos. Eles são bons enquanto funcionam, mas quando não funcionam e você toma um prejuízo, o problema é única e exclusivamente seu. É como andar de carro sem fazer seguro.

(off topic do off topic: eu uso Gmail, mas todo e-mail que que cai no inbox tem um forward automático para meu e-mail pago no Apple .Mac, e todo e-mail do .Mac cai na minha máquina, e minha máquina tem dois backups redundantes. Apenas para exemplificar. Eu gosto do Gmail, mas não apostaria sequer meus e-mails nisso.)

## Entendendo o Google

Sempre que se analisa um movimento do Google, nunca se deve pensar em ‘altruísmo’ ou qualquer bobagem dessas. Eles são uma empresa de capital aberto cujo objetivo principal é deixar seus acionistas felizes. Novamente: é uma empresa lucrativa, não uma instituição de caridade.

Por acaso o core business deles envolve atingir pessoas que ficam felizes ao ouvir frases-feitas como _“Don’t be evil”_, o que é bom para nós, claro, mas não significa que isso não seja um gerador de conflito de interesses.

(off topic do off topic – não sejamos ingênuos: [não fazer o mal](http://mashable.com/2008/04/10/orkut-pedophilia/) é muito vago porque ‘bem’ e ‘mal’ são conceitos relativos. O que é bom pra mim pode ser ruim para alguém e vice-versa. Bem e Mal mudam conforme o local e o tempo. Ninguém nunca vai dizer ‘faça o mal’, óbvio, não seria muito esperto. ‘Fazer o bem’, ou pelo menos o que é percebido atualmente como ‘bem’ para a maioria, é uma maneira muito inteligente de se fazer publicidade positiva frente à opinião pública de consumidores. Além de ser uma publicidade barata também pode ter isenção de impostos, o que para empresas grandes é uma economia considerável. A Lei Rouanet é um exemplo disso. Ambos ganham, mas sem leis desse tipo não haveria muita motivação para uma empresa ‘investir’ fora de seu core business da mesma maneira. Bah, what do I know. E, claro, eu gosto do Google também, até agora faz parte dos meus interesses.)

Só para entender melhor, leia [isto](http://www.wired.com/wired/archive/11.01/google_pr.html). Parte interessante:

> “Evil,” says Google CEO Eric Schmidt, “is what Sergey says is evil.”

Wired: _“Compromisso moral é apenas um custo para se fazer grandes negócios.”_

O App Engine é mais um canal para o Ad Sense, assim como um Android, um Gmail, etc. Uma das razões de existir uma empresa como Mozilla é a linha de receita que vem do Google para que ela traga no seu toolbar uma procura default para o Google, claro. A Apple também ganha para ter o campo de search do Google no Safari. Não é uma ‘venda-casada’ porque ambos os browsers são de ‘graça’, mas o custo é indireto porque interessa aos anunciantes no Ad Sense aparecer na maioria dos browsers, claro. O Yahoo! também [vai se juntar](http://afp.google.com/article/ALeqM5jEgHRf-Zi_z785TetNNwtg2V5a9w) ao mercado Ad Sense do Google, aumentando ainda mais seu market share.

Isso significa visitas indiretas que, por sua vez, gera os bilhões de receita ao Google, agradando seus acionistas. E os usuários geeks, que contribuem para a propaganda gratuita do boca-a-boca, obviamente gostam do pensamento de que apoiar um Google ou um Firefox significa _‘a Microsoft perder’_. Eu posso estar sendo pessimista, mas aconteceu com Rockfeller, um grande filantropo e sua Standard Oil. Aconteceu com Bill Gates, outro grande filantropo e sua Microsoft. Há possibilidade de acontecer com um Google. Para se ter uma idéia, leiam [este artigo](http://mashable.com/2008/04/10/orkut-pedophilia/) e um trecho interessante:

> Blogger and Mashable reader Constantine von Hoffman at Collateral Damage probably put it best when he said: “At this point, it would take a mashup of Wittgenstein, Quantum mechanics and LSD to make sense of Google’s various explanations for what it will and won’t censor and why.”

Enfim, o Google App Engine, por si só, não representa nenhuma revolução ou algo particularmente grande agora, é apenas mais um player no mercado de hosting. Cloud Computing é apenas mais um termo de marketing para uma solução derivada de outras que já existiam (granulamento de preços de serviços). Assim como o Android, o Google está commoditizando mais um segmento de mercado.

A regra de sempre continua valendo: [análise de custo x benefício](http://en.wikipedia.org/wiki/Cost-benefit_analysis). E esse tipo de análise não é receita-de-bolo e nem vem com o clique de um botão.

