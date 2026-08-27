---
title: 'Off-Topic: Google App Engine e Cloud Computing'
date: '2008-04-13T01:27:00-03:00'
slug: off-topic-google-app-engine-e-cloud-computing
translationKey: off-topic-google-app-engine-e-cloud-computing
description: "De hosting próprio a co-location, VPS, AWS e Google App Engine: o atrativo dos recursos elásticos sob demanda e o preço de adaptar a aplicação a paradigmas que dificultam a migração futura."
tags:
- cloud
- arquitetura-de-software
- off-topic
draft: false
---

Assim como _Web 2.0_, outro termo usado o tempo todo é **Cloud Computing**. Muita gente usa para designar muitas coisas. Outro termo usado como sinônimo, sem ser exatamente a mesma coisa, é **Web Services** (não o padrão XML). Na realidade isso é antigo: é o que chamávamos de ASPs (Application Service Providers).

Exemplos disso são serviços como Basecamp, para gerenciar projetos sem que a empresa precise gastar em manutenção, ou mesmo seu Webmail favorito. São serviços online onde você paga para não precisar se preocupar com infraestrutura. Um tipo de outsourcing de serviços.

Esta semana o Google causou um pequeno furor ao lançar sua resposta a Cloud Computing: o [Google App Engine](http://code.google.com/appengine/). O Techcrunch publicou um review [aqui](http://www.techcrunch.com/2008/04/08/techcrunch-labs-our-experience-building-and-launching-app-on-google-app-engine/). Mas o que é [Cloud Computing](http://en.wikipedia.org/wiki/Cloud_computing)? Antes de mais nada, vamos explicar os termos mais usados no mercado.

Nós, desenvolvedores, em algum momento vamos querer colocar nossa aplicação em produção. Eis quando chega a parte mais cabeluda do processo: deployment!

Existem várias opções. Primeiro, sobre software:

- Comprar uma aplicação comercial. Casos de [commodities](http://en.wikipedia.org/wiki/Commodity) como Exchange Server: você escolhe, compra, instala e começa a usar. Aplicações maiores vendem em regime de licenças, por usuário ou por processador. Alguns softwares permitem ser estendidos e customizados, mas normalmente você precisa se adaptar ao software, e não o contrário.

- Adquirir uma solução open source. Baixar da internet, configurar e usar, ou contratar uma empresa de serviços que faça esse trabalho por você. A vantagem óbvia é a ausência de custo de licença. A desvantagem é que administrar esse tipo de configuração tem um custo que normalmente ninguém leva em conta: o [TCO](http://en.wikipedia.org/wiki/Total_cost_of_ownership) não é trivial. A facilidade de modificar a aplicação varia de caso a caso.

- Fazer o sistema in house. Programar o sistema você mesmo, customizado às suas necessidades, com uma equipe própria ou uma software house contratada. É o modelo alfaiate. Costuma ser mais caro, mas pode ser necessário se não existem softwares comerciais que façam o que você precisa. Na teoria seria o software que mais se adequa à empresa; na prática o TCO costuma ser alto e o resultado, incerto. Tudo depende da maturidade da empresa e de quem foi contratado para desenvolver. Sua milhagem vai variar bastante.

- Usar um ASP. Você 'aluga' uma aplicação de mercado, como o SalesForce.com, sem se preocupar com deployment, instalação e atualizações. É menos customizável, mas o custo total de propriedade costuma ser bem menor. Em muitos casos faz sentido: basta uma conexão estável à internet. O modelo de serviços é tendência porque a infra-estrutura atual da internet permite. E há um ganho claro para o desenvolvedor: uma correção no sistema central beneficia toda a base de clientes instantaneamente, sem instalar nada cliente por cliente.

Sobre opções de hardware:

- Fazer o hosting você mesmo. Comprar máquinas, montar redes, administrar tudo dentro do seu perímetro físico. À medida que a empresa cresce, você compra mais máquinas. Funciona melhor para intranets e para empresas com um setor de TI maduro. TI normalmente é tratado como custo, como pagar impostos; cuidar de tudo internamente só faz sentido se seu core business são esses sistemas.

- Fazer o hosting você mesmo, mas entendendo que crescimento não é linear. Às vezes você precisa de mais recursos apenas por um período curto, e comprar máquinas o tempo todo só infla o TCO. Para isso existem servidores 'on-demand', como algumas linhas da IBM: quando precisa de mais potência, você liga para a IBM e ela libera mais processadores na máquina que fica fisicamente no seu local. É uma solução limitada.

- Fazer co-location. As máquinas são suas, mas ficam na infra-estrutura de terceiros, num CPD fora do perímetro da empresa. É um jogo de custo-benefício: você raramente tem a expertise de manter uma infra-estrutura tão estável quanto a de um terceiro, mas as máquinas continuam sendo sua responsabilidade. Serve para quem tem recursos para máquinas mas não tem espaço físico, ou para quem tem filiais que precisam acessar o mesmo sistema. O CPD mantém tudo ligado o tempo todo, com rede estável e suporte 24×7.

- Usar _shared hosting_. Você aluga um pedaço de uma máquina compartilhada com outros clientes. O custo inicial é mínimo, mas você sofre quando outro cliente da mesma máquina demanda mais recursos, além de problemas como bibliotecas de sistema compartilhadas. É um balaio de gato que os provedores tentam melhorar, mas a natureza desse tipo de pacote impede algo à prova de balas. Crescer num ambiente desses é limitado. Favorece freelancers e pequenas empresas que precisam colocar um site no ar sem recursos para configurações parrudas.

- Usar _VPS_ (Virtual Private Server). Você ainda divide a máquina com outros clientes, mas tem a sensação de uma máquina inteira só sua, virtual e isolada. É um 'shared co-location': a máquina é alugada em slices, com soluções como Xen ou VMWare, e sai mais barato que co-location. O isolamento protege sua aplicação das atualizações dos vizinhos. É o segundo passo para quem quer custo baixo com mais flexibilidade. O problema continua quando você precisa de mais slices só por um período curto: colocar um slice no ar leva tempo, e você pode perder o time-to-market.

## Cloud Computing

Entendidos os termos usados por aí, vamos ao termo da moda. Não sei se foi o primeiro, mas com certeza o que tem feito mais barulho é o modelo da [Amazon Web Services](http://www.amazon.com/aws): Elastic Compute Cloud (EC2), Simple Storage Service (S3) e SimpleDB.

O principal chamariz é o conceito de **elastic** on-demand. Você paga por quanto usa, sem precisar reconfigurar tudo manualmente a cada mudança. Usou mais, paga mais; voltou a usar menos, paga menos. É pagamento por uso de recursos, em vez de mensalidade fixa por recursos fixos.

Os produtos da Amazon cobrem três serviços:

- Armazenamento (Amazon S3). Num modelo tradicional você compraria ou alugaria um servidor de arquivos. O S3 criou um modelo diferente de file system, baseado no conceito de 'buckets'. As vantagens são preço e estabilidade; a desvantagem é que esse modelo não é mapeável de imediato para um file system comum. Hoje já existem dezenas de bibliotecas em diferentes linguagens que facilitam a transição.

- Banco de dados (Amazon SimpleDB). Em vez de um Oracle ou MySQL relacional, a Amazon oferece um banco de dados não-estruturado baseado em documentos. Sem schemas fixos, some a necessidade de administração custosa sobre seu domínio de dados, e a manutenção diminui. Por outro lado, ainda quase não existem frameworks ou bibliotecas que migrem trivialmente uma aplicação relacional (SQL) para o modelo do SimpleDB. De novo, a vantagem pode ser o preço.

- VPS (Amazon EC2). São VPS dinâmicas, elásticas. Se o seu sistema requer mais recursos num pico de visitas e transações, você habilita mais slices dinamicamente e os derruba quando não precisa mais. De manhã podem ser 5 slices, à tarde 20, à noite 5 de novo. A pegadinha: não serão necessariamente os mesmos 5 slices. O modelo garante slices, mas não quais. Sua aplicação precisa armazenar os dados fora do EC2, no S3 ou no SimpleDB, para que outro slice assuma sem depender de dados locais. É Shared-Nothing levado às últimas consequências.

Qual a vantagem? Você tem o que precisa, quando precisa. Em vez de se comprometer com planos caros de co-location ou VPS, você deixa a aplicação aos cuidados da Amazon e ganha dinamicidade sem se preocupar se suas máquinas 'vão aguentar'. É como pagar academia pelas horas que você efetivamente frequentou, em vez de uma mensalidade fixa. Parou no meio do mês, não perde a mensalidade inteira. É uma tendência no mercado de serviços.

Qual a desvantagem? No caso da Amazon, você precisa preparar sua aplicação segundo as limitações e os requerimentos deles. Principalmente porque é normal seu slice ser derrubado: os dados locais se perdem se não forem persistidos fora antes. Levado em conta como premissa desde o início, isso deixa de ser problema. É um paradigma diferente do co-location ou da VPS clássica, onde os dados locais são permanentes e o backup é responsabilidade do hosting.

### Google App Engine

Chegamos à novidade da semana. Na prática, o App Engine mapeia um a um os serviços da Amazon:

- Amazon SimpleDB vs Google BigTable: nenhum dos dois é banco de dados relacional; esqueça o RDBMS clássico.

- Amazon S3 vs Google GFS: de novo, nada de file system clássico como o da sua máquina.

- Amazon EC2 vs App Engine: parecido, mas diferente, como veremos a seguir.

O marketing do Google vendeu o produto como _"sua aplicação rodando dentro da nossa infra-estrutura"_. Todos sabemos que Google Search, Reader, Gmail e Orkut rodam numa infra-estrutura proprietária altamente escalável, que tornou o Google famoso e agora está 'aberta' ([grátis, mas não libre](http://en.wikipedia.org/wiki/Gratis_versus_libre)) para que outros usufruam. Vejamos vantagens e desvantagens:

- A desvantagem dos dois lados é a quebra de paradigmas: as aplicações precisam nascer exclusivas para um desses ambientes. Escolher um significa ficar fechado nele, porque suportar os dois custa mais desenvolvimento.

- A vantagem da Amazon é a independência dos serviços: quer apenas storage? Use o S3 sozinho. A desvantagem é que eles exigem mais conhecimento de integração que qualquer outro.

- A desvantagem do Google é a proposição tudo-ou-nada: sua aplicação fica toda lá dentro, não apenas pedaços. A vantagem é o ambiente online de administração, que coloca o Google um passo à frente da Amazon em usabilidade.

Neste momento o Google só suporta aplicações escritas em Python. Já vem com Django pré-disponível e com APIs que facilitam o manuseio de dados e storage. Com certeza uma grande notícia para a comunidade Python.

Isso gerou certa [comoção](http://web.archive.org/web/20090108161617/http://profy.com/2008/04/08/google-jumps-shark-with-app-engine/) entre desenvolvedores de outras linguagens, mas isso é normal. Se não fosse o Google, passaria despercebido como "mais um provedor de serviços". Sendo o Google, eles sabem que sempre receberão elogios e críticas massivas. Falar bem é democrático, falar mal também. Se eles não previram isso, alguém do departamento de Public Relations precisa ser demitido.

De qualquer forma, não deem ouvidos a mais essas guerrinhas de linguagens:

- elas são fogo de palha: só divertem agora

- elas não representam muita coisa: se o Google previu isso e tem um bom PR, sai ileso

- o Google gosta de Python: isso é público e notório, e não há problema nenhum nisso. Empresas decidem o que querem, quando querem e como querem. O dia que vocês tiverem suas empresas, vão entender isso.

- e o Google nunca disse que o App Engine seria exclusivo para Python

No [anúncio oficial](http://www.google.com/intl/en/press/annc/20080407_app_engine.html) o Google apresenta o serviço como "preview release", o famoso Beta de toda aplicação Web 2.0 que se preze. Grande novidade :-) A promessa é suportar outras linguagens no futuro. Não é uma solução perfeita, mas, como tudo que vem de uma corporação do tamanho do Google, tem grandes potenciais. E, como toda aplicação Web 2.0, tem uma conta gratuita para você fazer o test-drive do ambiente antes de decidir por um upgrade de planos. Neste momento de Beta, porém, ela ainda não é liberada para todo mundo.

## O que isso representa?

Quando o App Engine evoluir e passar a suportar mais ambientes de desenvolvimento além de Python, ele pode se tornar a principal ameaça aos Web Services da Amazon: é uma cópia descarada dos serviços deles, e o concorrente comercial óbvio é a Amazon.

Também pode se tornar uma ameaça a serviços menores, como o [Joyent Accelerator](http://web.archive.org/web/20081228161600/http://www.joyent.com:80/accelerator), um hosting que implementa o mesmo conceito de recursos elásticos, ou o recém-chegado [Heroku](http://heroku.com/), que no fundo é um App Engine para Rails: uma ponte sobre os serviços da Amazon, configurada de uma maneira mais simples para desenvolvedores de Ruby on Rails. Claro, ele ainda não está pronto e não tem nada perto da escala do Google.

Nem os serviços do Google e nem os da Amazon são perfeitos. Aliás, falei algo óbvio: nenhum serviço é perfeito. Tudo depende dos seus requerimentos e de como você quer se comprometer. A regra continua a mesma: quanto mais compromisso, mais barato no curto prazo e mais caro no longo; quanto menos compromisso, mais caro agora e, talvez, melhor no futuro.

Resumindo: quer algo barato e flexível? Amazon e Google podem ajudar. Mas, com sorte, se um dia você crescer e quiser ficar independente, desvincular pode ser difícil, porque sua aplicação ficou intimamente amarrada aos serviços deles. Com um serviço mais tradicional, como co-location ou VPS, você paga mais agora, mas continua isolado de terceiros e a migração futura para outros hostings sai mais barata.

Se o App Engine for bem sucedido, o efeito provável é pressionar o mercado de hostings a oferecer serviços mais criativos, mais baratos, com mais qualidade. É a lei de mercado: concorrência gera benefícios para nós, consumidores. Eles que se matem enquanto nós assistimos. A curto prazo, para quem quer colocar uma aplicação no ar, é apenas mais uma variável a considerar.

Qual o objetivo do Google nisso? Não sei se é o mesmo dos hostings: ganhar dinheiro terceirizando infra-estrutura num mercado de commodities. O Google se especializou em transformar bons produtos em commodities, o que é bom e ruim ao mesmo tempo, dependendo do seu ponto de vista. Se for um serviço grátis, um dos objetivos é facilitar que mais e mais websites apareçam: clientes potenciais para o verdadeiro core business do Google, o AdSense.

Claro que eu não faria hosting do meu equivalente-Twitter num serviço gratuito. Aliás, se seus dados são importantes para você, **nunca** use serviços gratuitos. Eles são bons enquanto funcionam; quando não funcionam e você toma um prejuízo, o problema é única e exclusivamente seu. É como andar de carro sem fazer seguro.

(off topic do off topic: eu uso Gmail, mas todo e-mail que cai no inbox tem um forward automático para meu e-mail pago no Apple .Mac, todo e-mail do .Mac cai na minha máquina, e minha máquina tem dois backups redundantes. Apenas para exemplificar. Eu gosto do Gmail, mas não apostaria sequer meus e-mails nisso.)

## Entendendo o Google

Ao analisar um movimento do Google, nunca pense em 'altruísmo' ou bobagens do tipo. Eles são uma empresa de capital aberto cujo objetivo principal é deixar os acionistas felizes. Novamente: o negócio deles é lucro, e caridade não paga dividendo.

Por acaso o core business deles envolve atingir pessoas que ficam felizes ao ouvir frases-feitas como _"Don't be evil"_. Ótimo para nós, claro, mas isso também gera conflito de interesses.

(off topic do off topic, sem ingenuidade: [não fazer o mal](http://mashable.com/2008/04/10/orkut-pedophilia/) é vago demais, porque 'bem' e 'mal' são conceitos relativos. O que é bom pra mim pode ser ruim para alguém, e vice-versa; bem e mal mudam conforme o local e o tempo. Ninguém nunca vai dizer 'faça o mal', óbvio, não seria muito esperto. 'Fazer o bem', ou pelo menos o que a maioria percebe hoje como 'bem', é uma maneira muito inteligente de fazer publicidade positiva junto à opinião pública. Além de barata, essa publicidade pode render isenção de impostos, o que para empresas grandes é uma economia considerável. A Lei Rouanet é um exemplo disso: ambos ganham, mas sem leis desse tipo não haveria muita motivação para uma empresa 'investir' fora de seu core business. Bah, what do I know. E, claro, eu gosto do Google também; até agora faz parte dos meus interesses.)

Só para entender melhor, leia [isto](http://web.archive.org/web/20081221135058/http://www.wired.com:80/wired/archive/11.01/google_pr.html). Parte interessante:

> "Evil," says Google CEO Eric Schmidt, "is what Sergey says is evil."

Wired: _"Comprometer princípios morais é simplesmente o custo de se fazer grandes negócios."_

O App Engine é mais um canal para o AdSense, assim como um Android, um Gmail. Uma das razões de existir uma empresa como a Mozilla é a linha de receita que vem do Google para que ela traga no seu toolbar uma procura default para o Google, claro. A Apple também ganha para ter o campo de search do Google no Safari. Não chega a ser 'venda-casada', porque ambos os browsers são de graça, mas o custo é indireto: interessa aos anunciantes do AdSense aparecer na maioria dos browsers. O Yahoo! também anunciou um [teste para exibir anúncios do AdSense](http://web.archive.org/web/20080516124707/http://afp.google.com:80/article/ALeqM5jEgHRf-Zi_z785TetNNwtg2V5a9w) nos próprios resultados de busca, o que pode aumentar ainda mais o market share do Google.

Isso significa visitas indiretas que geram os bilhões de receita do Google e agradam seus acionistas. E os usuários geeks, que contribuem com a propaganda gratuita do boca-a-boca, obviamente gostam do pensamento de que apoiar um Google ou um Firefox significa _'a Microsoft perder'_. Eu posso estar sendo pessimista, mas aconteceu com Rockefeller, um grande filantropo, e sua Standard Oil. Aconteceu com Bill Gates, outro grande filantropo, e sua Microsoft. Pode acontecer com um Google. Para se ter uma idéia, leiam [este artigo](http://mashable.com/2008/04/10/orkut-pedophilia/) e um trecho interessante:

> Blogger and Mashable reader Constantine von Hoffman at Collateral Damage probably put it best when he said: "At this point, it would take a mashup of Wittgenstein, Quantum mechanics and LSD to make sense of Google's various explanations for what it will and won't censor and why."

Enfim, o Google App Engine, por si só, ainda não representa revolução nenhuma: é apenas mais um player no mercado de hosting. Cloud Computing é mais um termo de marketing para uma solução derivada de outras que já existiam: a granularidade de preços nos serviços. Assim como fez com o Android, o Google está commoditizando mais um segmento de mercado.

A regra de sempre continua valendo: [análise de custo x benefício](http://en.wikipedia.org/wiki/Cost-benefit_analysis). E esse tipo de análise não é receita-de-bolo e nem vem com o clique de um botão.
