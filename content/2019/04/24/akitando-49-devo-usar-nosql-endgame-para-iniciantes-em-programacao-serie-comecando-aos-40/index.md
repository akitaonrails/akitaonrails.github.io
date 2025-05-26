---
title: '[Akitando] #49 - Devo usar NOSQL? | "ENDGAME" para Iniciantes em Programação
  | Série "Começando aos 40"'
date: '2019-04-24T17:00:00-03:00'
slug: akitando-49-devo-usar-nosql-endgame-para-iniciantes-em-programacao-serie-comecando-aos-40
tags:
- faas
- aws
- google cloud
- functions
- function as a service
- heroku
- nosql
- mongodb
- postgresql
- mysql
- cassandra
- database
- endgame
- devops
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/EdOkYEE1J_Y" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


Finalmente chegamos ao décimo-quarto e último episódio da série "Começando aos 40". E eu quis coincidir o término da série com o dia da pré-estreia de Avengers: Endgame, porque eu sou geek assim mesmo :-)

No episódio de hoje vou dar um pequeno overview sobre o que eu considero como alguns dos principais aspectos de bancos de dados relacionais, NoSQL, e as melhores escolhas pra sua aplicação.

Vou aproveitar pra complementar a discussão de máquinas virtuais, containers, IaaS, PaaS adicionando minhas opiniões sobre FaaS ou Function as a Service.

E no final quero deixar um pensamento sobre esse mundo cloud e o impacto quanto ao mundo de código livre pra todos pensarem.

Se você ainda não assistiu todos os episódios, não esqueçam que tem a playlist com todos os episódios pra maratonar: https://www.youtube.com/watch?v=O76ZfAIEukE&list=PLdsnXVqbHDUc7htGFobbZoNen3r_wm3ki

Desta vez quero tirar uma folga de uma ou duas semanas antes de retornar então é o melhor momento pra ver todos os vídeos do canal que ainda não assistiu.

Ajudem o canal compartilhando pra todo mundo!

Pular direto pra FaaS: 20:56

Pular direto pra Conclusão: 26:46


Links:

* Was MongoDB Ever the Right Choice? (https://www.simplethread.com/was-mongodb-ever-the-right-choice/)
* Redis Labs changes its open-source license - again (https://techcrunch.com/2019/02/21/redis-labs-changes-its-open-source-license-again/)
* NoSQL Databases: An Overview (https://www.thoughtworks.com/insights/blog/nosql-databases-overview)
* A SHORT HISTORY OF DATABASES: FROM RDBMS TO NOSQL & BEYOND (https://www.3pillarglobal.com/insights/short-history-databases-rdbms-nosql-beyond)
* Redis has a license to kill: Open-source database maker takes some code proprietary (https://www.theregister.co.uk/2018/08/23/redis_database_license_change/)
* MySQL Performance: MyISAM vs InnoDB (https://www.liquidweb.com/kb/mysql-performance-myisam-vs-innodb/)
* Why Amazon DynamoDB isn’t for everyone (https://read.acloud.guru/why-amazon-dynamodb-isnt-for-everyone-and-how-to-decide-when-it-s-for-you-aefc52ea9476)
* SQLite vs MySQL vs PostgreSQL: A Comparison Of Relational Database Management Systems (https://www.digitalocean.com/community/tutorials/sqlite-vs-mysql-vs-postgresql-a-comparison-of-relational-database-management-systems)
* When Should I Use Amazon Aurora and When Should I use RDS MySQL? (https://www.percona.com/blog/2018/07/17/when-should-i-use-amazon-aurora-and-when-should-i-use-rds-mysql/)
* Why Uber Engineering Switched from Postgres to MySQL (https://eng.uber.com/mysql-migration/)
* MySQL Might Be Right for Uber, but Not for You (https://dzone.com/articles/on-ubers-choice-of-databases)
* Showdown: MySQL 8 vs PostgreSQL 10 (http://blog.dumper.io/showdown-mysql-8-vs-postgresql-10/)
* Apache Cassandra Architecture Fundamentals (https://blog.yugabyte.com/apache-cassandra-architecture-how-it-works-lightweight-transactions/)
* Highly available Redis Architecture (https://medium.com/kokster/highly-available-redis-architecture-613c89f887b4)
* Paper Review: Dynamo: Amazon’s Highly Available Key-value Store (https://sookocheff.com/post/databases/dynamo/)

* Using the HTC G1, 10 years later: 2008's smartphone is effectively a dumbphone in 2018 (https://www.androidpolice.com/2018/12/24/using-htc-g1-10-years-later-2008s-smartphone-effectively-dumbphone-2018/)

=== Script


Olá, Fabio Akita

Este é o terceiro episódio do tema de devops pra encerrarmos o assunto e ao mesmo tempo vamos finalmente encerrar a série "Começando aos 40" neste décimo quarto episódio. 

No episódio da semana passada eu disse que iria explicar sobre bancos de dados. Eu tentei escrever esse script diversas vezes de diversas formas nos últimos dias, mas é um assunto muito mais complexo do que caberia num único episódio. Eu não vou entrar em detalhes de como eles são implementados, os algoritmos e arquitetura. Eu queria falar sobre clustered indexes, bloom filters, write ahead logs, mvcc, consistent hashing e muito mais. Em vez disso quero só compartilhar algumas opiniões que talvez nem todos concordem, mas que deve ser o mais útil pra maioria das pessoas.

Então quero aproveitar pra falar muito rapidamente de uma coisa que não mencionei no episódio anterior quando falei sobre máquinas virtuais e containers, o tal de Function as a Service ou FaaS que muitos ficam hypando hoje em dia. Finalmente vou fechar com um pensamento de como tudo isso que eu expliquei nos últimos episódios afeta o mundo de código livre. Hoje é dia do Endgame, fiquem comigo!



(...)



Como primeiro assunto, vamos falar rapidamente sobre bancos de dados e arquitetura. Se você estiver mais interessado em ir direto pra parte de Function as a Service vá pra esse tempo indicado aqui embaixo. E se quiser ir direto pra conclusão, vá pra este outro tempo aqui embaixo.


Se você é iniciante eu não recomendo tentar instalar e configurar manualmente nenhum banco de dados sozinho. Nem os bancos relacionais como MySQL ou Postgres e nem os NoSQL como Redis, MongoDB ou Cassandra. Não adianta só seguir um tutorial e fazer rodar. Garantir que você não vai perder dados importantes é muito mais do que meramente fazer um servidor rodar. Seguir um tutorial é absolutamente trivial.


Todos os bancos tem dezenas de configurações diferentes que devem ser planejadas exclusivamente pro uso da aplicação. Não existe uma única configuração que serve universalmente pra tudo. E não, NoSQLs não são mais fáceis de configurar ou dar manutenção do que os bancos relacionais. Se você tem essa noção de algum lugar, tire isso da sua cabeça. Eu diria que uma infraestrutura NoSQL de verdade dá tanto trabalho ou mais do que bancos relacionais. Especialmente se realmente formos eliminar pontos únicos de falha e tivermos requerimento de estratégias de recuperação de desastres com zero downtime, ou seja, o banco sempre estar disponível mesmo que um dos servidores do cluster sofra algum problema.


Se você for programador aprenda SQL e o modelo relacional corretamente. Você precisa saber como fazer queries decentes. A pior parte de uma aplicação é quando o desenvolvedor acredita que a biblioteca de mapeamento objeto-relacional que ele está usando, seja Hibernate no Java, SQLAlchemy no Python, ActiveRecord no Ruby, Eloquent ORM no PHP, nenhum deles vai fazer queries eficientes pra você. E queries ineficientes é um dos principais ofensores em desperdício de memória e performance. Não adianta trocar de banco se seu código é uma porcaria, nenhum banco vai fazer mágica.


Muita gente acha que usar um MongoDB é bala de prata pra combinar facilidade de uso e performance, especialmente pra iniciantes. Se você não assistiu meu episódio sobre o livro The Mythical Man Month, aqui vai um resumo: não existe bala de prata!


Pra começar, se você subir uma instância de MongoDB e deixar ele sozinho, você já começou errado. MongoDB não tem garantias de 100% de durabilidade. O melhor caso de uso do Mongo é que o dataset caiba inteiro em RAM. Todas as operações são feitas em RAM, é o que garante sua performance. Mas isso significa que se a máquina der pane antes da RAM ter chance de dar flush pro disco, você vai perder dados. Você pode configurar pra que ele garanta mais durabilidade. Por exemplo, hoje quando você manda gravar alguma coisa no Mongo ele devolve ok antes de ter realmente gravado. O ok do Mongo é mais tipo "bele, recebi a ordem pra gravar, quando der eu gravo". Diferente de um banco relacional que só dá ok se garantidamente o dado foi gravado. Você pode configurar o Mongo pra fazer o mesmo, devolver ok só se garantidamente uma outra instância de replica master recebeu o dado. Mas aí você perde a performance que era justamente o que te fez escolher Mongo em primeiro lugar.



Aliás, uma instalação mínima de Mongo precisa de pelo menos duas instâncias em replica set. Eu disse que o sweet spot é o dataset caber em RAM, mas você não tem RAM infinita, se você pretende armazenar ordens de grandeza mais dados do que cabe em RAM, talvez precise fazer shards. Mas configuração de shard precisa ser planejada do começo. Mudar de uma configuração sem shard pra ter shard não é só ligar ou desligar uma chave, você vai ter que refazer toda a infraestrutura do zero e mover todos os dados de lugar se escolher errado. Some replicação e sharding pra configurar e você criou um emaranhado de gato pra resolver. Portanto não, um MongoDB não é mais simples do que qualquer outro banco se você realmente vai usar da forma certa. Instalar na sua máquina só pra brincar, qualquer banco é simples, não só o Mongo.



Um NoSQL wide column store como Cassandra, apesar de ter similaridades com bancos relacionais só na superfície, especialmente nos schemas e no CQL que é similar a SQL, não tem absolutamente nada a ver. Eles são como key-value stores multi dimensionais com column families e foram feitos pra serem bancos altamente distribuídos, com múltiplos nós num cluster, de preferência em múltiplas regiões diferentes. Cassandra não foi feito pra usar numa única instância, como banco de um blog. O sweet spot dele é funcionar em cluster, com múltiplos nós, e com muita escrita.


Aliás, a maioria dos NoSQL é alguma derivação de uma estrutura de chave e valor, os key-value stores, como um Hash ou um Dicionário que qualquer linguagem de programação tem. O próprio Mongo pra mim é um key-value onde o value é um documento JSON, por isso chamamos de Document store. O sweet spot deles é localizar um valor tendo a chave em mãos. Diferente de um banco relacional, a maioria não é nem um banco transacional e nem um banco analítico, ou seja, que você pode sair fazendo queries como em SQL com qualquer critério e a qualquer momento. Pesquisas em bancos NoSQL precisam ser planejadas, indexadas com antecedência. NoSQLs tendem a ser bancos que você quer que funcionem em cluster, com shards, ou seja, nenhum servidor tem todos os dados que você precisa ao mesmo tempo, e se sua pesquisa for mal planejada, ela vai ter que ir vasculhando em todos os nós da rede, e isso custa processamento e custa tempo, muito tempo.



E um aviso muito importante que eu já dei em outros episódios: você não é o Facebook, nem o Google, nem o Netflix, nem o Uber. As experiências de engenharia dentro do Uber só tem valor pra outro produto com o mesmo nível de escala do Uber. Aceite a seguinte realidade: os 99,999% de nós jamais vai chegar a uma fração da escala do Uber. Portanto as decisões mais críticas de infraestrutura que eles relatam e que dão excelentes blogs posts e palestras são quase como ficção científica pra gente: é legal de ver, mas não nos impacta de nenhum jeito.


Um exemplo disso foi um blog post incendiário de um engenheiro do Uber de 2016 intitulado: "Por que a engenharia do Uber migrou de Postgres pra MySQL" acusando o Posgres de ter uma "arquitetura ineficiente pra escritas". Se você ler só isso vai sair que nem um idiota dizendo "puuts, temos que migrar nossos Postgres pra MySQL porque ele tem defeitos de escrita". Tem idéia de qual imbecil isso soa? Pra começo de conversa, o teor do artigo se refere a limitações do Postgres em casos extremos de grande volume de updates ou atualizações. E novamente, na escala do Uber. Tanto MySQL quanto Postgres são excelentes escolhas pra todos os casos que você precisa de um banco relacional, e que por acaso é a grande maioria dos casos. Programador é muito crédulo, fica acreditando em conto do vigário toda hora, é impressionante. Parem com isso! 


Na prática a maioria de nós vai sempre acabar usando uma combinação de um banco relacional com um cache, usando algo como um Redis. Nessa configuração o Redis pode até ser um pouco mais relaxado porque o certo é fazer com que os dados sejam consultados no Redis e o que não estiver lá você carrega do banco relacional e grava no Redis à medida que for precisando. Portanto o Redis pode ser reconstruído do zero mesmo se der pane e precisar derrubar tudo. E você usa o Redis pra manter coisas pesadas de calcular e gravar num banco relacional como agregações, coisas com contadores, médias e outras métricas que agregam múltiplas linhas do banco.


Num banco relacional, o que mais custa performance é escrever, mais do que ler. A escrita precisa ter o tal ACID garantido: atomicidade, consistência, isolamento e durabilidade. Dados escritos precisam garantidamente estar no disco de tal forma que uma pane inesperada não faça você perder dados. Múltiplas conexões escrevendo ao mesmo tempo não podem um pisar no pé do outro, você precisa de um esquema de concorrência como multiversion concurrency control ou MVCC que a maioria dos bancos usa hoje em dia. E você precisa de transaction logs pra conseguir dar rollback ou voltar ao estado original dos dados se uma transação de múltiplas operações dá pau na metade.


Numa aplicação com grande pressão de escrita, digamos um ecommerce em dia de Black Friday, fechando várias compras por segundo. Você deve programar sua aplicação pra usar filas. Toda nova compra entra na fila e vai sendo escrito no banco à medida que der. Você nunca pode só aumentar a quantidade de servidores de aplicação web e deixar conectar todo mundo no mesmo banco ao mesmo tempo, isso só vai aumentar a contenção e no final ninguém consegue escreve. Então é melhor todo mundo entrar numa fila e só a fila gerenciar o banco. As leituras usam caches de Redis e isso tira a carga de pesquisa no banco. O grande gargalo numa aplicação web é o banco de dados, porque mesmo com replicação e sharding, você sempre vai ter contenção por causa das garantias ACID.


Além disso, num banco relacional você aprende na faculdade a idéia de normalização, onde separa os fatos em tabelas e faz referências entre as tabelas, de forma a diminuir ao máximo a redundância dos dados entre tabelas. Do ponto de vista de modelagem, assim é mais bonito. Mas uma verdade é que do ponto de vista de performance, quanto mais você normalizar, pior pode ser a performance. Tanto bancos relacionais quanto NoSQL privilegiam tabelas denormalizadas. Você faz trade-off de redundância e mais uso de disco pra ter mais performance. Uma coisa cara no processamento de pesquisas é justamente fazer joins entre tabelas, por isso bancos como Postgres oferecem recursos como views materializadas. Views é como se fosse uma tabela lógica, que não existe, porque é o resultado dinâmico de uma query, mas uma view materializada é como se fosse uma tabela denormalizada de verdade.


Ou seja, numa aplicação de verdade, você talvez se veja obrigado a denormalizar algumas tabelas. Um jeito errado de usar um MongoDB ou Cassandra por exemplo, é granular as coisas demais e tentar fazer o equivalente a joins. NoSQL não foi feito pra ter joins e relacionamentos. E você vai descobrir que muitos problemas de performance que você tem com bancos relacionais é normalização demais. Pense em sharding e se você deixar uma tabela num servidor, outra tabela com dependências em outro servidor, como você vai fazer joins rápida entre tabelas em servidores diferentes? Como tudo em computação, não existe uma forma de quanto é normalizar demais. É uma arte, muita tentativa e erro em diferentes casos de uso.


Um exemplo bem idiota, a famosa tabela de estados. A grande maioria dos programadores faz uma tabela separada chamada estados com uma coluna de código pra colocar por exemplo SP e outra coluna de nome pra colocar São Paulo. Daí numa outra tabela de cadastro você tem um campo estado_id que é uma referência pra linha da tabela de estados. Agora toda vez que você puxar o cadastro precisa fazer um join com a tabela de estados. Eu acho isso desnecessário. Eu colocaria SP e São Paulo direto na linha da tabela de cadastros e um select simples, sem join, vai devolver tudo que eu preciso. Mas aí toda linha vai duplicar São Paulo toda vez. Foda-se. A probabilidade do estado de São Paulo mudar de nome é praticamente zero. Se um dia mudar sim, vai custar um pouco caro dar update em todas as linhas de todas as tabelas que ficou com isso duplicado, mas isso é uma possibilidade remota. Pra que eu vou normalizar dados que nunca mudam?



Mas isso significa que não pode haver o caso de alguém mandar gravar São Paulo com til e de outro lugar alguém mandar gravar um Sao Paulo sem acento. A letra C de consistência do ACID vem migrando do banco pra aplicação faz algum tempo e se você começar a denormalizar, vai ter que garantir essa parte da consistência na aplicação. Vamos assumir que seu código não é porco, que você colocou enums no seu código e validações antes de mandar gravar no banco. Lógico, novamente é um trade-off, vou trocar performance por mais trabalho. Como eu disse, computação é uma arte, não existe almoço de graça, se pra você performance é mais importante, vai ter mais trabalho. Se pra você conveniência é mais importante, você paga tendo menos performance. Aliás, pra ter mais segurança, mais disponibilidade, mais durabilidade, mais integridade, tudo isso você paga tendo menos performance. Se quiser aumentar a performance, alguns desses fatores devem cair, por isso fica esperto!


E no final o que você vai ter com mais frequência é uma solução híbrida. Independente da sua linguagem favorita ou framework web, o mais comum é você usar um banco relacional. Eu pessoalmente gosto de Postgres mas não há nenhum motivo pra não usar MySQL com InnoDb ou mesmo seus forks como as versões da Percona ou o MariaDB. Você vai acabar movendo a consistência pra aplicação, com boas validações e bons testes no seu código. Também vai acabar denormalizando algumas tabelas pra evitar joins desnecessários, sempre criar índices corretamente, mas também evitar criar índices demais porque quanto mais índices pior a performance de escrita no banco. 


Você também quer evitar gargalos de leitura e gargalos de escrita. Pra otimizar a leitura, você quer colocar um cache na frente do banco relacional. Você vai programar pra primeiro procurar o que quer num Redis. Se não achar lá, ou seja, tiver um cache miss, daí vai no banco relacional puxar os dados e gravar no Redis pra estar lá da próxima vez; com algum período de tempo pra expirar esse dado. E opcionalmente, se não quer o risco de parar o banco caso venham escritas demais, você vai programar sua aplicação pra colocar o pedido de escrita numa fila, seja no próprio sistema de publish/subscribe do Redis ou numa fila de verdade como RabbitMQ. Significa que o tempo geral de escrita deve ser mais lento do que mandar direto pro banco, mas se por acaso vier um pico inesperado que o banco não está preparado pra receber, em vez dele dar timeout e perder as operações, é sempre melhor ficar mais lento mas que garantidamente uma hora vai executar.


E não, programar com um framework assíncrono, seja Node.js ou qualquer outro que hoje em dia suporte async/await também não é uma bala de prata. Ajuda um pouco, mas não resolve o problema de picos e gargalo de concorrência no banco. No dia da Black Friday o que resolve o problema são filas, estruturas que você consegue controlar. async/await são boas pra ajudar, mas são só mais uma ferramenta e nunca a única solução que vai resolver tudo.


E se você precisar fazer uma coisa chamada Full text Search, que é pesquisas como você faz numa Amazon, onde você encontra produtos similares e tem resultados por relevância, você tem suporte a isso tanto no MySQL quanto no Postgres, mas na idéia de tirar o máximo de processamento do banco, o certo é manter um outro serviço só pra isso, no caso um Elasticsearch que é um dos melhores pra full text search. Toda vez que você escrever no banco relacional, também manda escrever no Elastic. Novamente vamos gastar mais recursos pra ganhar performance dos dois lados. Trade-off.


Se você usar Heroku, significa sua aplicação web rodar em um ou mais dynos web, e você ter um ou mais workers assíncronos que rodam em dynos de workers. Daí um Heroku Postgres, configurado com um follower pra onde você vai redirecionar as queries mais pesadas. Adicione também o Heroku Redis ou outro SaaS como Redis Cloud pra cache. Eu adicionaria um Cloudinary se sua aplicação precisar armazenar e processar uploads, um SendGrid se precisar mandar e-mails, um Rollbar pra guardar logs de erro, um New Relic RPM pra monitorar a performance da aplicação e um Bonsai Elasticsearch pra funcionalidades de pesquisa avançada. Espere gastar algo em torno de 200 a 300 dólares ou uns 1000 reais por mês. Parece muito? Não é, porque se você pretende instalar e configurar e manter tudo sozinho, você precisa de um sysadmin que vai te custar 5 a 10 vezes isso por mês. E isso só compensa se você for manter pelo menos 10 aplicações iguais a essa.


Se você realmente for manter parte disso sozinho, você que é sysadmin vai acabar usando um IaaS como a AWS ou Google Cloud. Nesse caso vai configurar as coisas com Kubernetes, Helm, Terraform e mesmo assim o ideal vai ser manter o banco de dados gerenciado em produtos como o AWS RDS ou AWS Aurora ou Google Cloud SQL. O banco de dados é a pior parte pra se manter, acredite. O trabalho simplesmente não compensa a menos que você seja muito grande. Não estou nem dizendo tamanho do Uber, mas você precisa estar lidando com terabytes diários de dados críticos pra compensar uma solução sob medida.


É tudo uma questão de gerenciamento de risco, um trade-off entre pagar mais pra ter mais segurança. Quanto custa pro seu negócio ficar fora do ar por 2 dias numa Black Friday? Quanto custa pro seu negócio perder os dados financeiros de meio dia de negociações? Na verdade, quanto custa perder 1 dia dos seus dados? Se você disser que não tem nenhum problema, eu questionaria a importância da existência do seu produto.


Uma última dica de infraestrutura: independente se você colocar sua aplicação numa máquina virtual de um VPS ou no AWS EC2 ou em containers via Kubernetes, ou mesmo numa plataforma como serviço como o Heroku ou Openshift, em qualquer dos casos contrate a Cloudflare. Ele é um serviço que vai substituir seu DNS, toda vez que alguém digitar seu domínio num navegador, o tráfego vai todo pra Cloudflare primeiro, e ele vai tanto servir como CDN que é um cache pra coisas como as imagens e outros assets do seu site como vai servir de detecção e prevenção de ataques. Se algum hacker ou algum moleque com um script tentar invadir seu site, o Cloudflare vai ser sua primeira linha de defesa e por experiência vou dizer que eles são muito bons. Altamente recomendado. Custa caro, mas de novo, quanto custa pra você se alguém entrar no seu site e roubar os dados dos seus clientes? Ou causar um Denial of Service no seu ecommerce no pico da Black Friday? 



Como segunda seção deste vídeo, deixa eu explicar Function as a Service ou FaaS, que são produtos recentes como o AWS Lambda ou Microsoft Azure Functions ou Google Cloud Functions. Eles são basicamente containers. Se você já usou coisas containers de Docker ou dynos de workers do Heroku, a idéia é similar. A implementação varia entre os diferentes fornecedores então cuidado porque não é um padrão! Você configura um evento ou um trigger, que pode ser várias coisas, uma chamada HTTP, um pub/sub de algum serviço de fila como o AWS SQS, ou o Firebase no caso do Google Cloud. Quando esse evento vier, ele vai subir um container pequeno que vai executar essa sua tal lambda ou função que está englobada num frameworkzinho específico pra plataforma. Dizer lambda ou functions é mais marketing do que qualquer outra coisa, se você ainda não tinha notado, pra aproveitar esse hype em cima de linguagens funcionais, mas não tem nenhuma relação.


Os containers já vem pré-configurados com imagens pra diversos frameworks como Node.js, ou Ruby, ou Go, ou Python, ou Java, ou C#. A idéia não é rodar um framework web monolítico como Ruby on Rails, ou ASP.NET MVC, ou Play Framework. Repetindo: sim, como é um container comum, que roda uma linguagem conhecida, que inclusive permite você instalar dependências externas, então tecnicamente você pode rodar o quiser nesses containers. Mas só porque você pode, não quer dizer que você deve. Sempre existe a ferramenta certa pro problema certo e na minha opinião FaaS não foram feitos pra hospedar sites grandes inteiros.


Máquinas virtuais de um IaaS como AWS EC2 ou mesmo num VPS tendem a ter um SLA alto. Eles não garantem que a máquina vai ficar de pé pra sempre, mas a intenção é ficar de pé por um longo período de tempo. Semanas ou meses. Num PaaS como Heroku, os containers que ele chama de dynos também tendem a ficar de pé por longos períodos, dias ou semanas. Mas não é uma garantia, por isso ele força você a não depender de gravar coisas no disco local, porque os dynos são containers voláteis. Você deve programar de tal forma que se um dyno restartar, a aplicação reinicie sem problemas e tudo que você precisa está em banco de dados ou caches externos.


Um container de função tende a ser menor e a ficar de pé por períodos ainda menores, horas, no máximo dias. A intenção é que você não se preocupe de manualmente ter que subir esses containers. Eles vão sendo iniciados a partir desses triggers ou eventos. A função deveria receber os dados do evento, processar o que precisar o mais rápido possível, e assumir que ele pode desligar depois disso. Na prática o AWS ou Google vai manter o container de pé por mais algum tempo caso outros eventos estejam esperando na fila. Mas se ficar sem fazer nada por muito tempo ele deveria desligar pra não desperdiçar recursos.


Como é possível receber um trigger de tipo HTTP ou seja, você poderia apontar seu navegador pra uma URL que seja gatilho pra ativar uma função, e de dentro da função você poderia conectar num banco de dados e devolver um HTML, você pode ficar tentado a colocar um site, ou pior, uma aplicação web inteira. E vai funcionar. Existem alguns frameworks web mais enxutos feitos pra tentar tirar vantagem disso.


Se você não tem problema em ter alta latência e tempo de resposta demorado de tempos em tempos, pode funcionar sim. Mas você precisa garantir que sua aplicação seja pequena. Como os containers de funções podem desligar a qualquer momento, quanto maior for sua aplicação mais vai demorar pra ele levantar um novo container no próximo evento. Eu pessoalmente acho que usar AWS Lambda e outros FaaS pra servir aplicações web é o uso errado da tecnologia.


Lembram como eu falei agora pouco que uma das formas de evitar gargalos no banco de dados é jogar o pedido de escrita numa fila e depois um worker que ouve essa fila ir escrevendo no banco? Esse seria um jeito. Você enfileira os pedidos no AWS SQS que é uma fila, conecta ele como event source no AWS Lambda, faz uma função que conecta no AWS Aurora e aí grava no banco. Ou outras coisas pesadas pra sua aplicação como processar imagens ou vídeos. Você manda uploads da sua aplicação pro AWS S3, daí manda enfileirar a ordem no AWS SQS de novo, que vira event source pra um Lambda que vai puxar o arquivo do S3, processar e jogar de volta no S3 ou manda arquivar no AWS Redshift.



Eu diria, de maneira simplória, que o AWS Lambda está pra AWS como um dyno de worker está pro Heroku. Ele não é nenhuma grande revolução como muito palestrante ou blog post faz parecer. Ele é mais um sub-produto do uso de containers pra tentar desperdiçar menos recursos. Em vez de você subir um EC2 inteiro e deixar ele esperando sem fazer nada até vir alguma coisa pra rodar, melhor criar um container que vai ficar simplesmente desligado se não tiver nenhuma atividade. Ele é melhor pra aplicações que não tem tanta atividade assim o tempo todo, por exemplo, quando de noite ou de fins de semana não vem nenhum novo evento ou vem muito pouco.


E nos casos onde sua aplicação tem picos difíceis de prever, com esse sistema ele pode subir múltiplos containers se a fila estiver com muita pressão. Então Function as a Service é só isso: um container com um código simples dentro de uma função, preferencialmente, que vai responder a eventos pré-configurados, seja de uma fila, seja um gatilho via HTTP, com o mínimo possível de configuração. 


Como terceiro e último tema de hoje, quero compartilhar um pensamento com vocês. Eu não sou um idealista, eu não sou um ativista: eu gosto de pensar que sou mais uma testemunha da história. Se possível eu prefiro tentar explicar as coisas da forma como eu vejo, mas não julgo ninguém por estar de um lado ou de outro porque só a história vai realmente dizer quem estava certo. Eu prefiro estar atento e me mantendo anti-frágil às mudanças. Quem leu Nassim Taleb, sabe o que isso significa.


Faz uns 30 anos que estamos vivendo num mundo de tecnologia dividido entre o mundo de código livre e o de código proprietário. Todos sabem que até o fim dos anos 90 o mundo de código proprietário sempre foi dominante. Mas principalmente a partir do novo século que o mundo de código livre evoluiu muito rápido. Hoje em dia todo desenvolvedor que se preza usa ferramentas derivadas do mundo de código aberto. Tudo que eu vim falando nessa série toda, incluindo distribuições Linux, Docker, Kubernetes, MySQL, Redis, tudo isso é mundo de código livre. 


Em 1995 Bill Gates soltou o famoso memorando interno na Microsoft explicando a ameaça do navegador à hegemonia do sistema operacional Windows e outros produtos como o Office. Em breve o navegador substituiria o sistema operacional. E ele estava certo.


Considere o seguinte: antigamente precisaríamos comprar um servidor de e-mails como um Microsoft Exchange. Finalmente surgiram opções de código aberto como Zimbra, Open Xchange e vários outros. A mesma coisa foi acontecendo com todo software proprietário. E por um tempo pareceu que o modelo estava funcionando e o mundo open source foi ganhando força até que as versões abertas passaram a superar as fechadas em muitos lugares, em particular em tecnologias de web, redes, servidores e infraestrutura.


Então surgiu o Gmail em 2006 e na sequência a Amazon e seu AWS, que inaugurou o conceito de empacotar as coisas como serviço, e expor esses serviços como APIs, em uma escala que não se imaginava. E muitas empresas seguiram o mesmo modelo, oferecendo software como serviço. Antes você pagava licenças caras pra comprar ou assinar pelo uso de software proprietário. O que mudou agora é que com os canais de distribuição da internet podemos fazer a mesma coisa que antes, que era comprar software encaixotado de prateleira ou via consultoria ou vendedores. Então o que realmente mudou foi o preço ser muito menor porque o software consegue chegar em mais pessoas e empresas. 


Mas note: voltamos ao mesmo modelo dos anos 90. Você paga uma assinatura mas não é proprietário do software. Pior: você não tem acesso ao código do software, porque ele funciona fechado atrás do que chamamos de um walled garden ou jardim emparedado. É um jardim bonito, mas lembre-se que ele não é aberto. Apesar da Amazon, Google, Facebook, Netflix, Uber e todos os outros de fato colaborarem ainda com software livre porque seria burrice não fazer isso, já que todos usam Linux e outras ferramentas.


Mas o software que torna a Amazon a Amazon ou o Google o Google jamais vai ser aberto. O AWS é o Windows da Amazon. O Google G Suite é o Office do Google. Custa muito caro criar uma versão aberta que seja igualmente competitiva, especialmente porque estamos falando de larga escala. Quanto mais eles crescerem, mais difícil vai ser pra qualquer outra empresa conseguir competir com eles. Então é um mercado com uma barreira de entrada enorme. E você basicamente trocou o Microsoft Office proprietário pelo Google Docs que também é proprietário.


Na prática, a maior parte do software que realmente dependemos no nosso dia a dia é proprietário, mas achamos que está tudo bem porque roda num navegador e não no Windows, mas tudo que tem acesso livre na verdade é pago com os dados da sua privacidade - e eu nem sou necessariamente contra, mas se você de alguma forma achava que é idealista de software livre usando tecnologias do Google ou Facebook, hoje já está num mundo fechado na sua maior parte, e você é equivalente a ser evangelista da Microsoft nos anos 90. De novo, nenhum problema nisso, só esclarecendo que não é o que você achava.


Considere que muito do que hoje é mantido como software livre não são nada mais do que bibliotecas que consomem APIs. Eles sozinhos não servem pra nada, são apenas cascas em cima de clientes de HTTP. Toda biblioteca da Amazon, do Google, do Facebook conectam com os serviços deles e só servem pra isso. Muitos desenvolvedores de software livre como o Salvatore que criou o Redis tem reclamado disso faz meses. Eles chegaram a mudar a licença pra uma mais controversa que impede que empresas como Amazon ou Google possam usar produtos como o RedisSearch, RedisGraph, RedisJSON e outros produtos. 


Aos poucos você vê uma Amazon agindo como a Microsoft dos anos 90, adotando software de fora, e criando modificações que atraiam as pessoas pra sua versão proprietária e depois fechar as pessoas dentro de seu walled garden. Veja o AWS Aurora que é um MySQL modificado e cuja modificação não é open source. Daí eles lançam um AWS Lambda e uma gama de outros produtos que basicamente vão prender você dentro da AWS. Uma vez que você adotar esses produtos e seu negócio realmente der certo, você não vai mais sair de lá. Lembra o que os desenvolvedores reclamavam de Windows e Office? A AWS é o novo Windows e Office caso ainda não tenham percebido.


Eu comecei a pensar em outra coisa por causa de retrogaming e meu hobby gostando de tecnologias antigas. Se eu pegar um computador dos anos 80, um Commodore 64, eu consigo rodar todos os softwares daquela época. Se eu pegar um Gameboy, ainda consigo rodar todos os cartuchos. E como foram feitos dumps dos cartuchos, CDs e DVDs, então todos os jogos foram preservados em algum site. Essa parte do passado está preservada pra sempre.


Mas se eu pegar um celular Android de primeira geração, o HTC G1, muitos dos serviços nele não funcionam. Porque eles são só cascas pra software as a service que já não existe mais. Vários hardwares de 10 anos atrás vão começar a falhar sem serviços pra conectar. Consoles de videogame é outro exemplo. Se a Playstation Network decidir que nenhum PS3 pode mais logar na rede deles, você basicamente perdeu o uso desse hardware. Todo jogo online daqui a 20 anos, sem os servidores proprietários, não vão servir pra mais nada. Não há como preservar mais esse software. Daqui 40 anos uma geração não vai ter como saber o que se usava nos anos 2010 a não ser por fotos de tela. Eu posso rodar o Office de 1995 hoje se quiser, mas não poderemos mais rodar o Google Docs de 2019 daqui a alguns anos.


E a direção dos software as a service indicam uma mudança de paradigma. Um mundo ideal de um Uber é onde a maioria das pessoas não precisasse mais comprar carros. Uber é carro como serviço. Pra um AirBnb o mundo ideal é onde a maioria das pessoas não precisasse mais comprar casas. AirBnb é casa como serviço. iFood é comida como serviço. Netflix é entretenimento como serviço. Spotify é música como serviço, você não tem mais propriedade sobre sua mídia de música ou filmes. E assim por diante.


Como eu disse antes, em tecnologia tudo é um trade-off. Estamos trocando propriedade por conveniência. Eu não digo que isso é bom ou ruim, o veredito ainda não foi definido. Mas eu achei interessante colocar como pensamento final desta série. O mundo da tecnologia desta década é diferente de 10 anos atrás, que foi diferente de 20 anos atrás, então não espere que daqui a 10 anos vai ser igual agora, você pode esperar uma mudança geral de ecossistema e tecnologias mais ou menos a cada 10 anos.


E com esse pensamento, eu tenho o prazer de finalmente encerrar esta série! Eu realmente não pensei muito quando comecei. Imaginava que fosse encerrar em 3 ou 4 episódios e acabou se tornando uma mini-série de 14 episódios! Eu publiquei o primeiro episódio em 22 de Janeiro e não pulei nenhuma semana. E eu quis encerrar exatamente hoje porque coincidiu de ser o dia do Endgame, claro!


Depois desse projeto eu quero tirar uma ou duas semanas de folga do canal e ver o que quero gravar a seguir. Não tenho dúvidas que só toquei na ponta do iceberg ainda, mas espero que tenha atiçado a curiosidade de todo mundo que queira se tornar um desenvolvedor. Mandem dúvidas nos comentários abaixo e sugestões de novos assuntos. Se curtiram o vídeo mandem um joinha, e por favor compartilhem o video pra ajudar o canal. Não esqueçam de assinar abaixo e clicar no sininho pra saberem quando eu voltar. A gente se vê na próxima, até mais!!
