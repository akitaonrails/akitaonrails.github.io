---
title: Examinando o Vazamento do Twitch
date: '2021-10-21T11:18:00-03:00'
slug: examinando-o-vazamento-do-twitch
tags:
- twitch
- vazamento
- leak
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/IBWdTuc6vDg" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## DESCRIÇÃO

No começo de Outubro de 2021 vazou um "arquivão" de 120 gigas de coisas do Twitch que incluia MUITO código-fonte. Hoje vou dar minha opinião sobre esse vazamento e dar uma olhada no que tinha nesses códigos.

Avisando: eu NÃO apoio vazamentos ilegais. Se alguém postar o link pra esses arquivos, será banido.

### Conteúdo

* 00:00 - Intro
* 01:04 - Avisos Legais
* 02:33 - Streamers não entenderam
* 03:47 - Twitch + Amazon
* 04:10 - O que é o vazamento?
* 05:41 - Scriptando a avaliação
* 06:33 - Limpando repositórios
* 07:03 - Indexando os arquivos
* 08:04 - Vendorização e dependências
* 13:12 - Limpando vendorização
* 15:13 - Depois da Limpeza
* 16:14 - Do Justin.tv ao Twitch
* 22:04 - Protobufs
* 23:50 - Infraestrutura
* 24:54 - Projetos ativos hoje
* 26:42 - Como startups evoluem
* 28:11 - Quando usar Microsserviços?
* 30:25 - Ranking de Linguagens
* 32:21 - Conclusão


## SCRIPT

Olá pessoal, Fabio Akita

Eu normalmente não faço videos sobre assuntos da moda porque esse tipo de video tende a envelhecer muito rápido. Mas um episódio que aconteceu alguns dias atrás chamou minha atenção e acho que todo mundo ficou sabendo. O vazamento de 120 gigabytes de dados de ninguém menos que o Twitch.




A primeira semana de Outubro de 2021 vai ficar marcado na história porque no começo dessa semana, alega-se que por problemas de DNS o Facebook e seus outros apps como Instagram e Whatsapp ficaram fora do ar por metade do dia, coincidentemente um dia antes de um vazamento de outra natureza que expôs suas táticas de negócios. Mas esse assunto não me interessa tanto pra discutir no canal, deixo isso pros twiteiros.




E logo na sequência veio o vazamento do Twitch. E eu quero falar sobre esse último episódio porque acho fascinante pra quem nunca trabalhou numa tech startup grande ter uma noção de como é o software por trás. Talvez quebrar algumas concepções erradas que muitos iniciantes ainda tem.





(...)





Obviamente tenho que começar com um disclaimer gigante aqui: eu não apoio atividades ilegais como vazar dados de qualquer empresa ou pessoa. Eu não admiro nem um pouco quem fez isso, muito pelo contrário, eu condeno como um criminoso comum. Nem mais, nem menos. Se for pego e condenado só vou pensar que não foi mais que merecido.





E não adianta vir nos comentários perguntar como se pega esses arquivos. Se alguém compartilhar links, qualquer um, eu vou banir na mesma hora, então já fiquem avisados. E nem fiquem me enchendo o saco por DM, vou só ignorar. Quem tá interessado, se vira.





Possuir os arquivos é uma zona cinzenta. Dependendo da jurisdição, das circunstâncias, pode não ser bom. Por isso eu não pretendo manter esses arquivos, depois do video vou dar o bom e velho `rm -Rf`. Usar o código é totalmente fora de cogitação. É propriedade intelectual de terceiros. Você nunca pode usar código que você mesmo fez se foi dentro de um contrato com outra empresa. Se não gosta dos termos, não assine o contrato e nem o pagamento. Se você tem dúvidas com relação à lei, consulte um advogado.






Eu conheço as leis, e pra garantir eu consultei meu advogado pra ter certeza. Se alguém tem interesse comece estudando a Lei de Software, Lei 9.609/1998. Mas a parte que me interessa é que não constitui ofensa aos direitos do titular de programa de computador a citação parcial do código-fonte para fins didáticos, desde que identificados o programa e o titular dos direitos respectivos. E também nada do que vou dizer neste video deve ser interpretado como tentativa de difamação ao Twitch. 







Eu brinquei no Twitter sobre o que vocês achariam se alguém hipotético que tem esse código fizesse um code review ao vivo num streaming. Obviamente eu tava brincando. Talvez não seja totalmente ilegal mostrar trechos, mas eu considero anti-ético. Qualquer um que tentou fazer isso e foi banido do Twitch ou outras plataformas, mereceu. Isso é molecagem, coisa de criança de 5 anos mesmo cheirando a leite. 







Além disso, eu duvido que qualquer um que ficou biscoitando tentando fazer live entendeu qualquer coisa útil dessa montanha de código. Só quem já trabalhou num ambiente assim e lidou com projetos desse tamanho sabe o que procurar e como. E já antecipo que apesar de não ter tido tempo de ver 100%, não tem nada de mais nesse código. Nenhum grande segredo. Nenhuma mágica especial. É muito parecido com dezenas de outros projetos que eu já vi ao longo dos anos.







Se você é iniciante, este video vai ser mais uma lista de coisas que vocês precisam estudar. Se você já é experiente, o video vai ser mais uma confirmação do que vocês já tinha deduzido. Não é muito difícil de deduzir porque todo mundo sabe que ela foi comprada pela Amazon, portanto tem todo o interesse de usar tudo que a Amazon Web Services, a AWS oferece, e sim, de fato ela usa o máximo possível de tudo do AWS, em particular o Kinesis porque é streaming. 






Assim como todo mundo ela também usa o S3 pra servir arquivos, o Redshift que é uma base de dados colunar usada pra datastore de big data, Route53 pro DNS, SNS pra notificações, SQS pra fila, DynamoDB pra dados que precisam acessar rápido, Redis pra cache rápido, Postgres como banco de dados estruturada, CloudWatch pra métricas e por aí vai. Nada de novo até aqui.







Antes de continuar vale a pena eu falar um pouco sobre a natureza desse código e o que de fato tem nesse arquivão. Como já expliquei, isso foi chamado de "parte um". Talvez tenha uma parte 2, talvez não. Independent, a gente teria que assumir que o que vazou não foi 100%, porque quem vazou não se identificou e não sabemos que nível de conhecimento e de acessos tinha. Por isso é seguro afirmar que esse vazamento é com certeza incompleto. Mas mesmo assim dá pra tirar alguns insights.








Se você não tá acostumado, pode pensar, "caraca, é incompleto e mesmo assim tem 120 gigas de material?" Na verdade não. O que vazou foram 159 arquivos zipados que dão 120 giga. Se descompactar tudo dá mais de 180 gigas. E não é mais porque misturado tem muito arquivo binário, como imagens, que não compacta bem. Se fosse só texto, a taxa de compactação seria de quase 10 pra 1, mas aqui é menos de 2 pra 1. Pra mergulhar nisso tudo, precisa de um bom SSD porque vasculhar tudo manualmente é impossível. Estamos falando de milhares de diretórios e quase na ordem de centenas de milhares de arquivos. 








Sinceramente, eu não tenho paciência pra ficar olhando um a um cada diretório. Um time inteiro precisaria de meses pra auditar linha a linha na mão. Eu me limitei a não mais uns 3 dias nisso. Então eu tive que usar a estratégia de jack, o estripador. Ir por partes. Abrir tudo isso de uma só vez num Visual Studio Code da vida e tentar procurar palavras é uma estupidez. Cada procura demora minutos ou mais. De novo, são literalmente milhões de arquivos. Mais exatamente 3.5 milhões de arquivos.







Em vez disso eu fiz um script que usa a ferramenta `find` que tem em qualquer Linux e montei um banco de dados em SQLite3. Só pra guardar coisas básicas: o caminho completo ou path, a extensão do arquivo, quantos bytes ele tem de tamanho, coisas assim. Meu script ingênuo levou mais de 30 horas pra indexar tudo e gerou um SQlite de quase 2 gigabytes. Mas com isso agora eu posso fazer queries SQL que responsem em milissegundos pra achar o que eu quero.






Um script pra isso pode ser feito no que você quiser, em Bash mesmo do seu shell, em Python, no caso eu fiz rapidinho em Ruby. Pra fazer esse tipo de coisa é ótimo usar linguagens como Python ou Ruby. Inclusive, uma boa parte do Python que tem nesse código vazado é exatamente isso: scripts pra automatizar tarefas mundanas como limpar arquivos, conectar em serviços de logs ou analytics pra limpar os dados e mandar pra um banco de dados ou outro armazenamento como Spark.






Na verdade antes de indexar tudo eu fiz uma primeira limpeza. Eu notei que muitos projetos ainda tinham o diretório `.git`, que se você assistiu meus videos sobre Git, sabe que é um basicamente um banco de dados de commits que contém o histórico das mudanças desse projeto. E esse diretório ocupa bastante espaço. Então eu fiz primeiro um script que move todos os `.git` pra outro lugar. E como eu esperava, isso removeu mais de 60 gigas. Então em vez de 180 gigas descompactado, na verdade o que temos pra trabalhar são 126 gigas. 






Uma vez feito isso, daí eu rodei o script pra indexar num sqlite3 e isso que totalizou os 3.5 milhões de arquivos, já removido todos os arquivos dos diretórios `.git`, mas tem ainda um monte de coisa que não é código fonte. Inclusive eu tenho uma suspeita que seja lá quem foi o perpetrador que saiu copiando as coisas, eu acho que é ou ex-funcionário ou ele entrou nas máquinas de desenvolvimento de funcionários, porque não são clones de git limpos, eles tem um monte de arquivos temporários, como builds de android, builds de go, coisas de javascript depois que rodou `npm install` porque tem coisas como diretórios `node_modules`, diretórios de dependências, um monte de binários que sobra depois de baixar bibliotecas open source e compilar.






Aliás, além de bibliotecas de dependências baixadas, também tinha um monte de bibliotecas open source vendorizadas manualmente. Isso é uma má prática e você deve evitar ao máximo fazer isso. Aqui vale uma tangente. Se você nunca ouviu falar de vendorização, ouça o tio Akita: não vendorize coisas de terceiros no seu projeto. E o que é vendorizar?







Digamos que você esteja fazendo um script que vai encriptar arquivos no seu sistema. Pelo menos você não é um burro completo e não vai tentar criar seu próprio algoritmo caseiro de criptografia, o que seria uma estupidez sem tamanho se você não for estritamente um pesquisador renomado e com anos de experiência na área. Se não entendeu isso, assista meus episódios sobre criptografia, mas em resumo, 100% das vezes que um programador comum tenta criar criptografia do zero, é 100% de certeza que é um lixo cheio de buracos de segurança.







Daí você resolve baixar o código fonte do OpenSSL ou alternativas como o BoringSSL, que são bibliotecas reconhecidas, com diversas funcionalidades de criptografia, geração de par de chaves e tudo mais. Daí você evitou uma catástrofe de usar uma criptografia caseira escolhendo uma das bibliotecas mais usadas do mundo, portanto ordens de grandeza mais seguro do que o que você faria sozinho. Mas acabou criando outra catástrofe esperando pra acontecer: você copiou o código do OpenSSL dentro do seu projeto e embutiu ele no seu sistema. Essa é um péssima decisão.






Digamos que a versão do OpenSSL que você embutiu foi a 1.0. Ah, que mau pode fazer? Pelo menos assim eu sei que tudo funciona, eu não dependo de ter que baixar a biblioteca quando for buildar nem quando instalar num servidor, facilitou minha vida. Errado. Vira e mexe descobrem bugs de segurança, agora mesmo em agosto foi descoberto mais um, que foi corrigido nas versões 1.1.1 e 1.0.2.






Só que você não é um especialista em segurança, você terminou aquele código e já esqueceu dele. E agora sobrou um software em produção rodando com OpenSSL 1.0 com buracos de segurança que todo mundo já conhece. A versão mais recente já é a 3.0. E como você é esperto pra caramba, saiu embutindo o código do openssl em todas as dezenas de projetos que precisava de alguma coisa de criptografia. Agora tem dezenas de projetos, cada um rodando uma versão diferente de openssl e nenhum sendo atualizado.







Isso é pior ainda quando você usa uma biblioteca "wrapper" como a cryptography de Python que por baixo dos panos é só uma casca pro OpenSSL nativo. E você nem sabia disso de openssl, só vendorizou a biblioteca cryptography dentro do projeto e não pensou duas vezes que podia vir uma bomba relógio junto. Projetos mal feitos de Python vira e mexe tem esse problema. Em vez de usar um gerenciador de pacotes como um PIP da vida, tem gente que ainda baixa e deixa estático no projeto.







E de fato, eu achei dezenas de lugares com a biblioteca cryptography, openssl, além de várias outras como url3lib, setuptools e mais. Aliás, em vários lugares eu achei as instalações inteiras de python2.7, python3.6 e 3.7 mas eu acho que nesse caso foi diretórios de build de pacotes de linux ou algo assim. Acho que não tava embutido nos projetos, e por isso eu disse que o vazamento foi não direto dos servidores de repositórios, mas sim da máquina de desenvolvimento de algum programador.









Enfim, a tangente foi mais pra ilustrar que a gente usa um troço chamado gerenciador de dependências por uma razão: não desperdiçar espaço baixando bibliotecas externas e também pra termos controle pra atualizar essas bibliotecas no futuro. Fazendo direitinho, ou seja, declarando a biblioteca e qual versão seu projeto precisa em arquivos como `package.json`, num projeto de Node.js, num `Gemfile` num projeto de Ruby, num `requirements.txt` num projeto de Python e assim por diante, depois temos como criar ferramentas de auditoria que conseguem ver se algum projeto tá usando uma versão muito antiga de alguma coisa que pode ser um problema de segurança. A ferramenta dependabot do GitHub faz exatamente isso.









Algumas comunidades como Go e Python tem problemas históricos de gerenciar versões de bibliotecas. Em python nem todo mundo usa coisas como PIP, muitos dependem de pacotes da distribuição de Linux que usam, o que pode gerar várias dores de cabeça se usar em distros diferentes. O Go antigamente era uma porcaria pra gerenciar versões, só a partir da 1.11 que isso melhorou um pouco, porque antes você declarava a biblioteca e ele baixava e vendorizada direto do github, mas não marcava a versão, então era um saco de gerenciar dependências. Esse foi um erro grave que os autores cometeram nas primeiras versões e isso gerou diversas ferramentas de terceiros com jeitos diferentes de resolver esse problema e muita falta de consenso por muito tempo.








Falando em falta de consenso, Javascript até poucos anos atrás também era uma dor de cabeça. Quem lembra de coisas como Bower? Os eternos bikeshedding sobre formato de pacotes? A lentidão na evolução do NPM antigo, tanto que o Facebook criou a própria dela, o Yarn, e isso forçou o NPM a andar mais rápido. E uma das coisas que mais me deixa irritado é desenvolvedor que não coloca o diretório `node_modules` no arquivo `.gitignore` como deveria e aí quando baixo o projeto vem uma tonelada de arquivos inúteis. Pessoal, bota a mão na consciência, não commita `node_modules`, é pra isso que existe o `npm` ou `yarn`. Aprende a usar.







Isso tudo foi só pra argumentar porque eu disse que esse código vazado talvez seja da máquina de desenvolvimento de alguém, porque tá cheio de diretórios de coisas vendorizadas, ou seja, depois que alguém rodou um `npm install` da vida e baixou as bibliotecas. Portanto, eu tinha que primeiro sair apagando essas bibliotecas do caminho. E tinha um monte de coisas. 






No começo eu fiz um script que vasculhava os arquivos de LICENSE. Daí se dentro tinha palavras como "Apache License" ou "BSD License" ou "GNU" ou coisas assim, eu sabia que eram bibliotecas open source. O problema é que isso você acha no repositório oficial num GitHub da vida, mas depois que eles empacotam pra distribuir num servidor de NPM ou Maven da vida, o script de build costuma excluir arquivos que não são essenciais, incluindo os de licença, então a maioria das coisas vendorizadas não tinha esse arquivo. Então isso dificultou um pouco na minha limpeza.






Daí não teve muito jeito, eu fui listando arquivos de terminadas extensões como .C ou .CPP que é C++ e isso me levou a bibliotecas fáceis de reconhecer como ffmeg, libxml, zlib, tcmalloc, libpng, boringssl e muito mais. Se você mexe como desenvolvimento faz tempo, tem centenas de nomes assim que imediatamente você sabe que é open source. Tudo isso eu apaguei do meu banco de dados. No final meu script ficou com uma lista de padrões que eu ia pesquisando no caminho completo de cada arquivo e marcando pra apagar. Olha só como ficou.






Pra achar esses padrões, foram algumas horas, só vasculhando, fazendo queries no meu índice, e apagando tudo que eu achei que fosse open source, coisas vendorizadas, artefatos temporários de builds automatizadas. E isso faz diferença, por exemplo, tinha código fonte dos apps de iOS, Xbox, Android e dentro tinha diretórios como `android-dev-tools`, diretório dos SDKs, e quem já desenvolveu Android sabe que só um diretório de SDK ocupa por volta de 1 giga de espaço. 







Eu acho que limpei pelo menos a grande maioria, mas muita coisa ainda pode ter sobrado. Pode ser que eu tenha apagado uma coisa ou outra que não era open source por acidente, mas isso deve ser suficiente pra dar uma idéia geral. Recapitulando, o total do vazamento foram 120 gigas compactados que dão uns 180 descompactados. Daí eu ignorei diretórios como `.git` e depois de uma primeira limpeza de bibliotecas open source, cheguei a um total de mais de 3.5 milhões de arquivos que somam uns 110 gigabytes. 





Daí limpando o que eu achei que era open source, builds, coisas como backups de banco de dados, imagens, e tudo mais, no final sobraram ainda mais de 600 mil arquivos totalizando uns 11 gigabytes. Ou seja, deu pra jogar quase 90% fora pra conseguir separar o que é realmente proprietário do que era open source e coisas temporárias. Como já disse, a limpeza manual que eu fiz não foi 100% preciso, mas acho que cheguei próximo o suficiente pra conseguir tirar as informações que eu queria.






Se você não entendeu isso de sqlite3 ainda, é uma tabela com o caminho completo de cada arquivo, diretórios, subdiretórios, nome do arquivo e extensão, além do tamanho de cada arquivo. fazendo isso eu consigo fazer, por exemplo, `select count(*), sum(size) from files where extname = '.go'` ou em português, pesquise na tabela `files` a quantidade de arquivos e o tamanho total deles em bytes onde os arquivos tem extensão `.go`. E com isso eu consigo saber quantos arquivos de Go existem e quanto bytes ocupam. E posso fazer isso pra todas as linguagens que achei.







Sim, linguagens no plural. Se você é iniciante, isso pode ser um choque. Sim: toda grande tech startup usa mais de uma linguagem. Sem nem ver o código fonte, não é difícil de imaginar quais linguagens se usa e por quais razões. Por exemplo, eu já sabia que o Twitch era originalmente feito em Ruby on Rails, quando ela ainda se chamava Justin.TV. Aliás, no código hoje ainda tem muitos pacotes com namespace justin.tv. 








À medida que a plataforma começa a dar certo você começa a expandir pra outras coisas. Por exemplo, o Twitch consegue exportar videos pro YouTube. Pra fazer isso você usa ferramentas open source como `ffmpeg`, o software mais importante de encoding e decoding de video, que todo mundo usa e, adivinha, o Twitch também usa. Pra processar áudio de voz, tem a biblioteca `speex` e assim vai, tem dezenas de ferramentas pré-prontas e não só o Twitch mas qualquer um vai usar todas elas. E depois de um certo tamanho você quer entender como esse código funciona, e eles são feitos em C++.







Se sua startup sobrevive e cresce, agora você tem milhões de requisições, precisa subir dezenas de servidores, e vai precisar otimizar performance. Uma das primeiras coisa que a gente faz em linguagens como Ruby e Python é se preocupar com o gerenciador de memória, que deriva de C, o malloc padrão. Em vez dele a gente tenta outros gerenciadores como jcmalloc do Facebook ou tcmalloc do Google. Eu falei disso no episódio de gerenciamento de memória. E de fato, vi rastros de tcmalloc no projeto.






Pra diminuir o tempo de cada requisição web, tem duas coisas que a gente faz logo de cara. Primeiro joga tudo que tá gerando gargalo em jobs em background. No mundo Rails a gente usa bibliotecas como Sidekiq ou Resque. Eles mantém uma fila separada num banco como Redis, ou mesmo no Postgres - o que eu não recomendo, a não ser que conecte numa instância de banco separada da instância principal, ou conecta num serviço de filas como o SQS da Amazon. Daí a requisição web só tem o trabalho de gravar na fila do banco e ir embora muito rápido, e deixar o trabalho mais demorado pra um worker em background, que vai pegar o job da fila e processar depois. Isso é padrão, todo mundo faz isso. Eu falei um pouco disso no episódio sobre Concorrência e Paralelismo.







A segunda coisa é separar queries demoradas, pesquisas que custam mais caro que estão sendo feitas no seu banco de dados tradicional como Postgres e jogar os dados mais acessados, já pré-calculados e consolidados, num banco de dados mais rápido NoSQL como Redis ou DynamoDB. E adivinhem, é o que o Twitch está fazendo. Eu falei mais disso no episódio sobre NoSQL. E não, jogar tudo num NoSQL não é a solução. Alguns bancos são otimizados pra escrever rápido, mas as pesquisas são lentas. Como um Cassandra. Outros são otimizados pra leituras rápidas, mas a escrita é lenta, como um MongoDB. Outros ainda são otimizados pra não perder dados, mas a leitura e escrita podem ser lentos, como um Postgres. Cada caso precisa de um banco diferente ou uma combinação deles, o que é mais comum.







Mas só isso não é o suficiente quando você chega num certo patamar de audiência, milhões de pessoas penduradas o dia inteiro assistindo ASMR e moleques jogando Fortnite. Apesar de ser altamente produtivo, uma plataforma dessas não tem como ser 100% em Rails, e agora você começa a gerar microserviços em outra coisa, como Go. Mas nesse estágio, agora você tem tamanho, experiência e dinheiro pra começar a criar ferramentas proprietárias pra lidar com coisas como WebSockets e WebRTC pra conseguir manter seus chats no ar.








Mas não é só isso. Com Rails você pode continuar fazendo coisas como painéis de administração, suporte, configuração e funcionalidades do site que vão ser estáticas e podem ser servidas por cache. Nesse estágio você começa a ter volume grande de dados, big data, e precisa lidar com isso. Então começa a criar ferramentas pra consumir esses dados. Logs pra auditoria, logs pra ads, logs pra analytics, e precisa tratar, consolidar e processar esses dados em coisas como Redshift, Spark, monitorar a infra com coisas como Ganglia, notificações de Rollbar, criar dashboards que mostram esses dados com coisas como Grafana. Novamente, tudo que todo mundo nesse tamanho usa, e o Twitch não é diferente.







À medida que você vai adicionando mais peças, mais serviços externos, mais microserviços internos, vai aparecer um volume grande de um tipo comum de código: wrappers, ou clientes de APIs. Uma boa parte do código dos projetos é só um codigozinho que chama uma API e trata o resultado de alguma forma. E sendo o Twitch parte da Amazon, não é surpresa que a maior parte é código pra integrar com Cloud Watch, com o SNS, SQS, enfim tudo que a AWS oferece. E de fato, muito do que eu falei que precisei apagar pra fazer a contagem eram diretórios como `aws-sdk`.







E ao longo do tempo da startup, vão surgindo campanhas temporárias. Uma campanha patrocinada, colaboração com marcas, promoções e tudo mais. Código que só vai servir por alguns meses e depois sai do ar. E de fato, tem vários projetos desse tipo que claramente estão arquivados e não são mais usados. Esbarrei em alguns wordpress, com um tanto de plugins. Mas não sei se era código ativo. PHP é uma das coisas menos usadas no Twitch. Depois da limpeza só achei uns 2 mil arquivos que não dava 11 megabytes, do total de 11 gigas. E felizmente muitos deles foram feitos como projetos em repositórios separados dos principais, o que ajuda a não poluir demais o código do dia a dia. 






Pra que seja possível separar as coisas em micro projetos diferentes, uma outra parte do código vai ser pra expôr seus serviços internos como APIs, tanto APIs HTTP, web services, que normalmente respondem JSON da vida e aí fica mais fácil criar sites separados de campanhas. Dá pra facilmente integrar no front-end um sistema de autenticação, puxar dados do perfil do usuário e tudo mais. Isso é bem comum também e aqui não é diferente. Mas o que é diferente é um cuidado que pouca gente toma e só faz sentido em sistemas grandes: a comunicação entre micro serviços.






Só quando a startup vai chegando mais perto do tamanho de um Twitch, cada milissegundo, cada kilobyte conta, porque são milhões de operações por segundo na plataforma inteira. Sistemas menores não devem se preocupar com isso, mas neste caso eles usam muito Protobuf. Em resumo, um microserviço é basicamente uma aplicação web pequena que expõe APIs e se integra com outros micro serviços chamando as APIs deles. Sendo uma aplicação web, o protocolo de comunicação é HTTP e o pacote de resposta costuma ser JSON ou XML.






JSON é ótimo pra um ser humano entender, por isso toda grande plataforma expõe APIs que respondem JSON ou similar pra facilitar pro pequeno desenvolvedor integrar sem muito trabalho. Mas é um tradeoff porque protocolos em texto desperdiçam muito espaço. Internamente na plataforma, o protocolo precisa ser rápido, mas sem perder totalmente as características de ser conveniente de implementar e integrar. E por isso o Google inventou o Protobuf, que é uma forma fácil de criar protocolos binários de RPC, ou Remote Procedure Call.







Uma estrutura de dados convertida em texto desperdiça muito espaço, mesmo se compactar com gzip, o que adiciona tempo de processamento pra ficar compactando e descompactando. Um protocolo binário é muito mais eficiente porque você não fica convertendo números em string, daí ter que reconverter de volta em número. Em binário ainda dá pra montar vetores de bits e muito mais. Existe um padrão chamado gRPC que muita gente usa com Protobuf, mas o Twitch inventou o dele, que é open source e se chama Twirp. Vale a pena dar uma estudada, mas o ponto é que muita coisa usa esse protocolo binário internamente em vez de APIs HTTP. Eu sei disso porque na limpeza esbarrei com várias cópias da biblioteca de protobuf e twirp vendorizadas.







Como tem muito microserviço, começa a ficar complicado pro desenvolvedor rodar e testar cada um. Por isso normalmente todo projetinho desses acompanha instruções num arquivo README da vida, o que é uma boa prática e se você não faz, deveria se acostumar a fazer. E também costuma vir junto pelo menos um arquivo `Dockerfile` pra facilitar subir um container local pra rodar. Também é boa prática escrever arquivos como INSTALL ou BUILD ou até mesmo um `Makefile` de uma vez pra automatizar o build dos pacotes. Achei muito disso em vários dos diretórios que vasculhei.







Feito tudo isso, o problema agora é subir esse tanto de coisa em produção. E aqui eu fiquei um pouco na dúvida. Não achei absolutamente nada de Kubernetes. Sendo na Amazon o normal seria ter configurações de Terraform pra subir tudo no EKS que é o serviço de Kubernetes da Amazon. Mas nada. O que eu achei foi um monte de arquivos de configuração de Terraform (main, variables, output), mas parece que o provider é conectando direto nos serviços da AWS pra configurar coisas como RDS, EC2, Beanstalk e tudo mais.









Pode ser que eu não tenha olhado direito, ou faltou isso no vazamento, talvez uma das coisas que devem sair na parte 2. Eu cheguei a cogitar que talvez o vazamento saiu agora mas ele pegou as coisas faz tempo e só resolveu vazar muito tempo depois, mas não. Eu fiz outro script pra vascular todos os repositórios Git, os diretórios `.git` locais. Nem todo diretório tinha um `.git` mas rodando meu script eu encontrei quase 5 mil e 700 repositórios. Daí fiz um script pra rodar `git log` em cada um e conseguir a data do último commit. De novo, fiz meu script jogar tudo num outro SQLite3.









Quando meu script terminou, eu fiz um select agrupando o ano da data desses últimos commits e de fato, quase 2000 deles tem commits recentes de 2021, os mais recentes são de 4 de outubro deste ano, poucos dias antes do vazamento. Então são repositórios ativos neste momento mesmo. Tem repositórios que não tem commits novos faz tempo, mas mesmo assim quase 890 tem commits em 2020, 844 em 2019 e assim por diante. Mas mais da metade dos repositórios tem commits entre 2021 e 2020, ou seja, recentes. Aliás, fazendo essa query eu consigo saber quais projetos estão ativos neste momento e quais são projetos antigos que não se usa mais.








De qualquer forma, parece que pode ser só Terraform direto ligando na AWS sem usar Kubernetes no meio, controlando EC2 na mão mesmo. E não, eu não gosto de Kubernetes, na verdade acho horrível pra qualquer um que não seja do tamanho de um Twitch pra cima. Eu sempre penso que o Google inventou Kubernetes pra resolver o problema de datacenters do tamanho dos deles. Projetos pequenos e mesmo médios deveriam ficar longe de Kubernetes. A grande maioria dos projetos devem ficar num Heroku da vida, e já tá mais que ótimo. A maioria das pessoas inexperientes ignora os custos elevados de se gerenciar e manter uma infra toda em Kubernetes.








O que me leva ao ponto que falei lá no começo, uma grande tech startup, até mesmo média, vai usar mais de uma linguagem: a linguagem certa pra coisa certa. Normalmente vai ser ou Rails ou Node.js ou Django ou Laravel pra aplicações mais visuais, que usuários interagem. Isso porque no estágio inicial de uma startup, frameworks desse tipo são super produtivos, tem um ecossistema rico com soluções pré-prontas pra você não ficar reinventando a roda, e muita documentação e guias pra orientar o desenvolvimento. Ninguém deveria estar fazendo do zero autenticação, login, esqueci minha senha do zero, isso é pré-pronto em todo framework decente.








Depois disso começa a entrar coisas como Go ou Elixir, pra pedaços que precisam obrigatoriamente de baixíssima latência ou suportar milhares de pessoas penduradas em conexões de longa duração como WebSockets ou WebRTC, como é o caso de um Twitch, Discord, Messengers e coisas assim.






O front-end obviamente é sempre em Javascript. No caso como o Twitch foi feito em Rails lá atrás, ainda tem muita coisa usando o framework Ember. Não só isso, eu achei um monte de jquery vendorizado. Como nos últimos 15 anos o mundo javascript foi inventando um monte de bibliotecas e frameworks, qualquer startup com 10 anos ou mais vai ter uma torre de babel misturando jquery, ember, angular, react e tudo mais. Não fiquei fuçando muito a parte de Javascript, mas parece que é muito diferente disso. É difícil de ter uma contagem do que é javascript que eles fizeram e o que é coisa baixada misturada.







Muita gente tem dúvidas sobre organização de microserviços, quando deveria fazer, como deveria organizar. E isso não tem resposta exata. Micro serviços aparecem em duas ocasiões principais: quando você tem um endpoint específico que precisa de características muito especiais de baixa latência e alto throughput. E o segundo caso é quando você precisa dividir suas equipes internas pra facilitar o gerenciamento, daí divide o sistema em microserviços, um pra cada equipe, que é o caso clássico da Lei de Conway, que observou que com o tempo, a estrutura de um software tende a replicar a estrutura de comunicação da empresa.






Com algumas ressalvas, eu diria que quanto menos micro serviços você tem sempre é melhor. Muita gente gosta de ficar falando mau de monolitos, mas existem monolitos e monolitos. Outra tech startup gigante feita em Rails e que faz questão de se orgulhar de ser um monolito é o Shopify. Claro que também tem micro serviços, mas eles querem dizer que não saem dividindo o software em milhões de serviços à toa. A vantagem de um monolito é que a complexidade da infra tende a ser mais baixa, mas a complexidade do software pode dificultar a produtividade. O problema é quando o código é sujo, macarrônico, onde passou um monte de programador porco que largou um monte de dívida técnica, com quase nenhum teste automatizado, nenhum build automatizado, ou seja, um inferno de dar manutenção.







Um monolito bem cuidado pode durar muito tempo e costuma ser sinal de uma empresa que tem boa comunicação entre suas equipes e mantém boas práticas de código limpo. Eu não sei quantos programadores existem no Twitch hoje, mas eles tem muito mais microserviços do que eu gostaria de ver. Talvez tenham sido mais uma vítima da Lei de Conway. Mas sendo justo, uma parte do código que eu vi tem testes automatizados. E pelo menos a parte de infra parece decente, com scripts que automatizam muita coisa. 






Falando nisso, só de bater o olho aleatoriamente, eu não vi código muito sujo além do normal de qualquer projeto. Nada excessivamente macarrônico, funções com dezenas de linhas, nomes de variáveis difíceis de identificar, números mágicos, complexidade ciclomática e coisas assim. Inclusive eles tem um guia de boas práticas de como escrever o código, o que costuma ser uma boa coisa pra ser criar internamente, pra todo mundo saber o que é esperado do código.






Enfim, vamos fazer um pequeno ranking só de brincadeira. Como eu disse antes, eu limpei o código o máximo que dava. Joguei fora tudo que eu achei que era open source. Tudo que claramente era código duplicado entre projetos e fazia muito volume e no final achei o seguinte. Dos 11 giga que sobrou, tem quase 58 mil arquivos de Go que totalizam uns 300 megabytes.






O segundo colocado, que não é surpresa pelo tanto de front-end que uma plataforma dessas costuma ter é javascript. Mas como eu disse antes, eu acho que ainda tem muita coisa vendorizada que eu não consegui limpar. São mais de 18 mil arquivos que totalizam 68 megas. Tecnicamente HTML seria o segundo lugar com quase 21 mil arquivos ocupando 450 megas, mas tem centenas de diretórios de documentação de bibliotecas com HTML no meio e coisas assim, então esse número tá bem inflado ainda.






Achei curioso que tem bastante arquivo de C#, e aqui eu fiquei ainda em dúvida se eu não limpei bibliotecas externas o suficiente mas a razão de ter muito C# é porque o Twitch tem apps nativos pra tudo que é plataforma como Windows e XBox. Tinha até o executável do NuGet espalhado em vários diretórios, muitas DLLs que eu imagino que seja do SDK e outras dos builds automatizados, mas no final da limpeza sobrou mais de 9 mil arquivos de C# ocupando uns 51 megas.






Eu falei que eles usam muito Terraform? Só de arquivos .tf de configuração tem quase 22 mil arquivos que consomem 37 megabytes. Arquivos de configuração passaram na frente de arquivos de Ruby que tem só uns 16 mil arquivos ocupando 32 megas e depois dele vem Python com pouco mais de 17 mil arquivos ocupando 81 megas. Python era uma das coisas que mais tinha biblioteca estática baixada e descompactada no meio dos projetos. De novo, eu limpei o que deu, mas provavelmente uma boa parte disso é sujeira que eu não achei tudo. Ruby é de fato mais aplicações Rails mesmo. Mas Python a grande maioria são scripts, incluindo funções pra AWS Lambda pra ficar processando dados.







A conclusão é que foi uma pequena startup que começou com Rails, fez muito sucesso e foi adicionando scripts em Python, microserviços e ferramentas em Go, migrando de JQuery pra Ember pra React. E pra deploys começaram  com Elastic Beanstalk e Cloud Formation e foram migrando pra Terraform, integrando com tudo que tem na AWS, evitando reinventar a roda. Em resumo é o que posso dizer sem correr o risco de dar spoilers de confidencialidade do código fonte.







Pra você que é iniciante e achou esse volume de código grande, isso não é grande. Lembrando que pela data dos commits dos projetos, menos da metade tá realmente ativo hoje e muita coisa é projeto que foi ficando obsoleto e abandonado pelo caminho. Metade não recebem novos commits desde 2019. E isso é outra coisa normal: muito código vai ficando obsoleto, sendo substituído por projetos novos. Lembram como eu falei em videos anteriores que um software nunca tá 100% acabado? É isso que eu quero dizer. 2 repositórios viram 10, 10 viram 100, 100 viram 1000 e depois de 5 a 10 anos você acaba com 5 mil repositórios ocupando 100 gigas, sem contar os bancos de dados e tudo mais.







Eu não tenho muito a criticar no que eu vi. A única coisa foi que eles precisam melhorar o gerenciamento de pacotes e dependências. Mesmo tendo muita coisa automatizada, ainda deu pra achar muita coisa realmente estática. Isso são bombas relógio que se ninguém fizer auditoria uma hora vai estourar buracos de segurança e bugs inesperados por conta de bibliotecas estáticas velhas que ninguém sabia que ainda existiam. Vai saber se foi por conta de uma dessas coisas que deu o vazamento de agora.






A idéia do video de hoje não era expor o Twitch. Centenas de engenheiros trabalharam sério nisso por 10 anos. Esse trabalho merece respeito, são nossos colegas da nossa área. Sair expondo o trabalho dos outros não é profissional. Meu objetivo foi totalmente educacional pra dar uma noção de dimensão pra quem nunca viu. Mesmo porque o que todo mundo teve acesso nesse vazamento é no mínimo incompleto.






Eu espero que vocês tenham tido alguns insights com esse caso e que sirva pra dar perspectiva nos projetos que estão trabalhando hoje. Ninguém tem que tentar fazer nada igual a um Twitch da vida, nem uma fração de 1% dos projetos que existem hoje vai chegar a ter o mesmo nível de audiência massiva que eles tem. Cada software deve ser feito pra atender as necessidades de hoje e ir evoluindo de acordo com seu sucesso. Se ficaram com dúvidas mandem nos comentários abaixo e avisando de novo que links indevidos sendo divulgados serão sumariamente banidos. Não deixem de assinar o canal e compartilhar o video pra ajudar o canal. A gente se vê, até mais.

