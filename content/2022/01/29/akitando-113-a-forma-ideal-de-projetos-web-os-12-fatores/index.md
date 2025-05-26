---
title: "[Akitando] #113 - A Forma Ideal de Projetos Web | Os 12 Fatores"
date: '2022-01-29T16:59:00-03:00'
slug: akitando-113-a-forma-ideal-de-projetos-web-os-12-fatores
tags:
- heroku
- 12 fatores
- testes
- continuous integration
- continuous deployment
- arquitetura
- agilidade
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/gpJgtED36U4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## DESCRIPTION

Finalmente vou mostrar o que é o Heroku e como é o fluxo de trabalho mínimo de um projeto web ideal. Se você já usa Heroku, aproveite pra compartilhar o video com conhecidos que ainda não usam. Se nunca viu Heroku, prepare-se pra ficar surpreso!

## Conteúdo

* 00:00 - Intro
* 01:16 - Recapitulando Heroku
* 05:04 - Os 12 Fatores
* 06:02 - I - Codebase
* 07:11 - II - Dependencies
* 08:24 - III - Config
* 09:30 - IV - Backing Services
* 10:47 - V - Build, release, run
* 12:25 - VI - Processes
* 14:50 - VII - Port Binding
* 16:09 - VIII - Concurrency
* 17:40 - IX - Disposability
* 19:07 - X - Dev/Prod parity
* 21:59 - XI - Logs
* 22:31 - RANT: log4j
* 23:39 - XII - Admin Processes
* 24:33 - Heroku - alternativas e custo-benefício
* 28:37 - Escalabilidade não é automática
* 30:33 - 1. Farás Testes!
* 31:05 - 2. Integrarás Continuamente!
* 31:59 - 3. Usarás um Sistema de CI!
* 32:44 - 4. Farás Deploy Contínuo!
* 33:16 - Conclusão: equipes saudáveis

## Links

* The Twelve-Factor App (https://12factor.net/)
* Guidance for preventing, detecting, and hunting for exploitation of the Log4j 2 vulnerability  (https://www.microsoft.com/security/blog/2021/12/11/guidance-for-preventing-detecting-and-hunting-for-cve-2021-44228-log4j-2-exploitation/)

## SCRIPT

Olá pessoal, Fabio Akita.


No episódio anterior me dei ao trabalho de fazer o passo a passo de um tutorial simples de primeiros passos usando o Heroku pra fazer deploy de um projetinho de exemplo em PHP. O objetivo foi mostrar o processo de deployment de uma aplicação moderna pra iniciantes que talvez nunca nem tenham ouvido falar de Heroku. Qualquer desenvolvedor que já trabalha com certeza já conhecia. Então, se você não sabe o que é Heroku assista o episódio anterior antes de ver este, porque precisa saber o que eu disse lá pra entender este.





Hoje quero falar sobre um troço conhecido como os “12 fatores” que é meio uma metodologia que pode ser aplicada a projetos web escritos em qualquer linguagem de programação e qualquer framework web. Além disso quero complementar com alguns fatores que originalmente não se menciona mas meio que ficam implícitos. Se você quer um projeto web que tenha capacidade de escalar é meio obrigatório que no mínimo esses 12 fatores estejam satisfeitos. Satisfazer os 12 fatores não torna nenhuma aplicação automaticamente escalável, mas não satisfazer eles quase garante que não vai escalar de jeito nenhum.




(...)




Se você já é programador de sistemas legados, tenho certeza que quando viu o tutorial de Heroku pela primeira vez, brilhou seus olhos de vontade de poder trabalhar desse jeito. Se você é de agenciazinhas porcaria - e eu defino como porcaria todas que ainda atualizam sites via FTP como falei antes - mesma coisa, deve estar se coçando de vontade de poder trabalhar assim. Todo mundo que trabalha em tech startups hoje em dia ou empresas grandes que se modernizaram já trabalham desta forma. Mas cuidado, se você não trabalha assim e mesmo assistindo até aqui achou tudo desnecessário ou mesmo ruim, eu repensaria a carreira. Você vai se tornar obsoleto muito em breve.






E quem acha que isso tudo é só mais uma novidade passageira, que vai acabar daqui a pouco, está bem enganado. Eu trabalho desse jeito desde aproximadamente 2010, portanto mais de uma década. Eu ajudei o quanto pude a difundir esse estilo de trabalho por anos e finalmente isso se tornou o padrão. Muitos tentaram imitar o Heroku, mas até hoje acho impressionante que poucos conseguiram chegar perto.







Só resumindo se você não lembra do episódio passado, o grande lance é você não configurar um servidor manualmente, ser tudo automatizado. E principalmente não instalar todos os componentes da aplicação no mesmo lugar, deixar cada coisa num container separado, como serviços externos independentes. Além disso conseguir fazer deploys frequentes a cada nova funcionalidade ou correção de bug. Tudo tão fácil quanto fazer um `git push`, literalmente. 








Na mesma época que o Heroku surgiu, o Google tinha acabado de lançar um produto que fez muito barulho, o Google App Engine pra rodar aplicações feita em Python usando serviços do Google. O problema é que você não podia usar componentes padrão de Linux como banco de dados Postgres. Precisava usar o banco do Google que era o BigTable, um NoSQL que só existe no Google e não dá pra rodar em outro lugar. Além disso precisava programar de formas específicas pro App Engine. Então, uma vez que funcionasse não dava pra rodar em nenhum outro lugar. Era super simples de subir a aplicação mas era super limitado, restritivo e você ficava preso.








A grande sacada do Heroku foi abrir os padrões e ajudar a criar uma forma onde ao mesmo tempo você queria ficar no Heroku porque tudo era muito simples e seguro, mas não precisava lobotomizar seu código pra fazer rodar. Se quisesse sair e instalar sua própria infraestrutura, sua aplicação não tinha nada proprietário te prendendo. Além disso, eles criaram o conceito de marketplace de software as a service pra desenvolvedores. Você podia sair do Heroku, instalar sua aplicação manualmente num VPS do Linode e ainda usar o mesmo serviço de Papertrail que mostrei antes lá, por exemplo. Os addons também são independentes do Heroku.








Mas se ainda não ficou óbvio, você não escolhe infraestrutura querendo que seja barata demais, porque você recebe exatamente aquilo que paga. Se paga barato, não espere ter garantia de nada, aliás, espere que seu sistema vai cair quando mais precisa dele e vai sair super caro colocar tudo no ar de novo pra aguentar a carga. É por isso que sempre que possível, a recomendação é começar no Heroku. No outro extremo, se tem dinheiro sobrando, não recomendo ir direto pra um Kubernetes, começa no Heroku. Só faz infra customizada quando tem dados de uso que realmente justificam isso.







O Heroku mantém as coisas atualizadas. Patches de segurança e tudo mais são aplicados na sua infra, e na maioria dos casos você não precisa fazer nada. O jeito como o Heroku te obriga a organizar seu projeto, não insere nada de proprietário, mas ao mesmo tempo te força a fazer as coisas do jeito certo é a principal vantagem. Quando alguma coisa não funciona no Heroku normalmente não é um problema do Heroku, é problema da sua aplicação que foi feita de um jeito porco.








E pra facilitar a educação do jeito certo de programar aplicações web, o co-fundador Adam Wiggins escreveu um site chamado The 12 Factors que lista os 12 fatores que todo projeto web deve ter pra ser minimamente possível instalar numa infraestrutura escalável como o Heroku. É como se fossem 12 patterns de gerenciamento de arquitetura de projetos. Esse site foi publicado acho que em 2011 e tudo que está nele continua válido igualzinho até hoje.







Quem acompanha este canal e conseguiu acompanhar o tutorial de Heroku até aqui já entende a maioria, mas quero comentar ponto a ponto desses doze fatores. Se você é iniciante, preste muita atenção. É isso que se espera que todo programador web saiba de cor e salteado, independente da linguagem ou framework que escolher. Aliás, todos os frameworks web modernos de hoje facilitam você implementar esses 12 fatores. Um framework que não é compatível com esses fatores é um péssimo framework e você não deveria estar usando.








Vamos lá, o ponto 1 declara que todo código-fonte deve estar num repositório de versionamento de código. Hoje em dia isso só tem uma resposta e se chama Git. Tudo pode estar num único repositório Git, se for um projeto gigantesco talvez esteja dividido em múltiplos repositórios ou monorepos. Não importa, contanto que esteja em Git que todo mundo da equipe tenha acesso e que se faça deploys com frequência. Esse ponto é chave. 








No próprio tutorial do episódio passado eu fiz pelo menos uma meia dúzia de deploys enquanto ia adicionando novas funcionalidades. Antigamente fazer deploys era um processo demorado, manual, cheio de erros humanos. Hoje em dia o certo é que se faça deploys contínuos. Múltiplos por semana, múltiplos por dia. No mínimo em ambiente que chamamos de staging, que é tipo um ambiente de testes onde tudo roda como se fosse ambiente de produção. Não pode existir uma dúzia de desenvolvedores fazendo código semanas inteiras e levar mais semanas pra subir esse código numa infraestrutura de testes. É inadmissível e é sinal claro de incompetência da gerência dessa equipe. 








O segundo fator se chama Dependências e foi por isso que me alonguei tanto falando de gerenciamento de dependências durante o tutorial. É fator fundamental que todas as dependências de um projeto web não dependam de pacotes específicos de sistema operacional instalado na máquina. Isso porque o sistema operacional dos containers do servidor e o sistema na máquina de cada desenvolvedor sempre vão ser diferentes. E versões diferentes de cada pacotes vão estar sendo usados em cada lugar, aí a gente nunca sabe de onde está vindo muitos bugs, se é problema no código ou se é dependência com versões erradas.








Repetindo: toda dependência deve estar declarada num arquivo de manifesto como `composer.json` no nosso projeto de exemplo, ou `package.json` num projeto Node. E tanto na máquina do desenvolvedor quanto no script de deploy como do Heroku, vamos rodar o mesmo comando pra baixar as dependências, como o `compose update` ou `npm install` da vida. E em todos os lugares vamos garantidamente ter exatamente as mesmas dependências nas exatas versões necessárias. Isso é essencial e novamente, projetos que não estão assim demonstram incapacidade da gerência do projeto.








O terceiro fator se chama Configuração. Em resumo, foi o que expliquei no tutorial sobre a diferença de configuração na máquina de desenvolvimento usando recursos do framework que carrega arquivos como `.env` ou algum arquivo JSON da vida e variáveis de ambiente. Todo framework competente permite executar a aplicação em ambientes distintos pra desenvolvimento, testes e produção, no mínimo. Isso porque em desenvolvimento queremos mais detalhes de erros, mais bibliotecas de debugging e monitoramento, mas em produção não queremos divulgar nenhum detalhe de erros e nem desperdiçar memória carregando bibliotecas que só servem em desenvolvimento.








Em cada um desses ambientes precisamos de variáveis de configuração diferentes, pro ambiente de testes precisamos conectar num banco de dados de teste, por exemplo. Ou não mandar SMS ou notificações de verdade e só logar que tentou mandar. Tudo isso precisa estar facilmente configurável em variáveis de ambiente. Leia os detalhes sobre configuração do seu framework, tem muitas nuances que você precisa estudar e testar com calma.







O fator 4 é mais relevante se você já é um programador das antigas que instalava tudo num servidor como já expliquei inúmeras vezes que não deveria, com stacks como LAMP. Pra você havia diferença num banco de dados que roda no mesmo localhost da sua aplicação web e um serviço externo de enviar e-mails, por exemplo. Numa aplicação 12 fatores não existe essa distinção. Tudo é um serviço externo, ou um recurso externo, acessível via uma URL. Nada roda junto do container da sua aplicação web, tudo roda externamente. Esse é o quarto fator, backing services.
 






É extritamente proibido instalar um servidor MySQL junto com um Redis ou um sistema de filas como RabbitMQ. No mínimo do mínimo, se tiver um hardware parrudo, cada serviço deve estar rodando isolado no seu próprio container ou máquina virtual. Mesmo na sua máquina de desenvolvimento, se possível não instale tudo junto. Rode cada coisa num container Docker e orquestre tudo com Docker Compose. Estude sobre Docker Compose e experimente transformar seu projeto tradicional num conjunto de containers. É até uma boa forma de garantir que você não largou conexões hardcoded pra localhost, que vai funcionar na sua máquina de desenvolvimento mas vai falhar em produção.






O fator 5 é mais específico pra quem mexe com infra, mas é sobre separar a fase de build da fase de execução. Lembra como toda vez que fazemos `git push heroku` eu falei que o Heroku criava uma nova imagem, semelhante ao que o Docker faz quando executamos `docker build`? É isso que quero dizer. Antigamente a gente faria o equivalente build manualmente copiando arquivos via FTP e logo na sequência já executaríamos a aplicação e deixaríamos lá rodando.







Pior, se tivesse algum bugzinho, o normal era abrir um SSH pro servidor ou, Deus me livre, via Telnet, editar algum arquivo manualmente direto lá e pronto. Era super fácil e também a raíz de milhares de problemas. Primeiro porque tudo que você editou na mão direto no servidor não está no repositório de código. Se der pau no servidor, você perde a modificação e tudo pára de funcionar e ninguém sabe porque. Voltamos ao fator 1 que declara que 100% de tudo deve sempre estar num repositório Git.







Segundo porque digamos que queremos voltar uma release, como expliquei que o Heroku faz. Não tem como, porque todo novo deploy sobrescreve em cima da versão antiga de maneira permanente. Mas gerando builds, sempre vamos ter uma cópia da imagem antiga e podemos facilmente voltar pra ela. E como cada imagem não depende de pacotes específicos do sistema operacional, tudo que ela precisa pra rodar está na imagem. Portanto trocar imagens é uma operação trivial que pode ser feita dezenas de vezes e vai funcionar em todas as vezes, sem depender de nenhuma pessoa entrando nos servidores e subindo coisas manualmente.








O fator 6 provavelmente é um dos mais difíceis de entender se você for um iniciante. Ela se chama Processos mas na verdade é o fator que define que sua aplicação deve ser share-nothing, ou mais corretamente, stateless, sem estado. O exemplo mais simples é que sua aplicação nunca deve gravar nada no sistema de arquivos. Por exemplo, digamos que você faça uma página pra fazer upload de fotos pra colocar na página de perfil de cada usuário.








Você segue um tutorial qualquer que manda ir gravando tudo num diretório chamado uploads no servidor. E tudo vai funcionar perfeitamente. Até você fazer um novo deploy no Heroku ou outro sistema de containers e aí vai descobrir que todas as suas fotos sumiram. Os únicos arquivos que existem na sua aplicação são aqueles que existiam na fase de build da imagem, que é o código fonte que baixou do Git, as bibliotecas que um gerenciador de dependências como o Composer baixou, e outros arquivos gerados por scripts executados no build, como arquivos de javascript compilados por um Webpack.







Uma vez que a build foi fechada, ela não pode mais ser modificada, é pra ser considerada read-only. Daí vocês vão lembrar que eu falei durante o tutorial que o Heroku vai derrubar os dynos que estavam executando a versão antiga e subir novos dynos com a imagem nova. Entenderam? Quando o container é desligado, tudo que estava nele é perdido, por exemplo as fotos no diretório uploads. Quando um novo dyno subir, os únicos arquivos que vão ser carregados são os que estão na imagem que acabamos de construir. 






No caso de um Docker na sua máquina local é a mesma coisa, mas você tem a opção de mapear um diretório externo fora do container e remontar esse diretório quando subir o container de novo, daí os arquivos ainda persistem, mas sempre fora do container. Tudo dentro de um container deve ser considerado efêmero.











Todo dado que você quer que sobreviva a um deploy deve obrigatoriamente estar num armazenamento externo, um backing service como descrito no fator 4. Por exemplo num banco de dados como Postgres ou Redis e, no caso de arquivos, num serviço como o AWS S3 ou Azure Blob ou Google Cloud Storage da vida. Tem várias outras opções. Mesma coisa logs, por isso o certo é adicionar addons como um Papertrail. Qualquer log que for gravado como arquivo dentro do container vai ser perdido no próximo deploy, e esse é o jeito certo de se fazer aplicações web. Vamos falar mais sobre log no final.







O fator 7 não é tanto uma preocupação pra nós desenvolvedores, especialmente hoje em dia. Ele só declara que todo serviço que precisamos deve estar exposto numa porta de rede. Como nossa aplicação web que costuma estar exposta em portas como 3000 ou 8080, ou MySQL que costuma estar na porta 3601 e assim por diante. 







Isso eu acho que é mais pra dizer que não devemos usar serviços que não estejam expostos em portas. Por exemplo, pense no serviço cron que existe em todo Linux e serve pra schedular tarefas. A gente configura num arquivo pra executar algum comando em alguma determinada hora do dia ou periodicamente, tipo todo dia às 4 da manhã se for um backup. O único ponto de contato com esse serviço é via um arquivo de configuração, por isso não podemos usar cron numa infraestrutura dessas, com vários containers que não permite modificar arquivos localmente.






Em vez disso vamos usar um software as a service, um SaaS, que adiciona uma aplicação web na frente do cron, ele vai ser instalado como um backing service, um serviço externo e nossa aplicação web vai interagir com esse serviço via HTTP, conectando na porta web dele. Assim, a requisição pode sair de qualquer um dos nossos containers web e todos vão consistentemente chegar no mesmo serviço sempre, assim como já chegam em outros serviços como o banco de dados.







O fator 8 se chama Concorrência e meio que só deriva dos fatores anteriores. Ele declara que a forma de escalar é horizontal. Ou seja, como nossa aplicação é share-nothing, ou seja, não depende de nenhum estado específico da máquina onde está, e como já é tudo organizado como builds que podemos subir como containers em qualquer máquina, podemos rapidamente aumentar ou diminuir a quantidade de containers horizontalmente.







Esse fator é inspirado no jeito UNIX de pensar onde tudo são processos e a forma de escalar é dar fork em mais processos. Mesmo quando usamos alguma linguagem como Javascript ou Elixir, que permite fazer multiplexing via threads ou I/O assíncrono dentro de cada processo, ainda assim sempre vai estar limitada pelo tamanho da máquina onde está rodando e quando esse recurso se exaurir, vai precisa escalar horizontalmente de qualquer jeito. Escalabilidade exige expansão e contração horizontal, que é mexer na quantidade de containers e/ou na quantidade de máquinas físicas.






Particularmente um Heroku facilita isso porque quando você escala horizontalmente containers web, vai precisar de um load balancer na frente pra distribuir a carga de requisições. É algo que se você só subiu aplicações pequenas nunca teve que pensar, porque só tinha um servidor web e todas as requisições iam direto pra ele. Com mais um servidor web, você precisa de um balanceador de carga como NGINX ou HAProxy na frente. Um Heroku da vida já te dá esse balanceador por padrão de forma transparente. 








O fator 9 é um pouco mais avançado de entender e eu recomendo estudar sobre sinais de processos como SIGTERM e o que é shutdown gracioso e conceitos como rolling restart. Mas na prática esse fator fala sobre Descartabilidade. Você já viu isso na prática no tutorial toda vez que fizemos `git push heroku`. Ele faz a build de uma nova imagem e descarta os containers antigos pra subir novos. É isso que significa ser descartável. Uma vez que garantimos que não dependemos de nada dentro do container, todos os dados estão seguros num banco de dados ou outros serviços como o AWS S3 pra arquivos remotos, podemos facilmente descartar containers pra fazer deploy de uma nova release ou dar rollback pra releases anteriores.








Antigamente, quando a gente instalava tudo num mesmo servidor, não dava pra fazer isso. E se a máquina era invadida por um hacker? É impossível recuperar uma máquina comprometida, o certo é jogar tudo fora e remontar do zero. Mas se você editava coisas via SSH direto no servidor, se parte do que rodava não estava no Git, e se sua aplicação gravava uploads e logs localmente como arquivos. E agora? Como você vai conseguir reinstalar essa máquina o mais rápido possível? E a resposta é simples: não vai. Um sistema robusto precisa ser descartável. Você precisa conseguir apagar o servidor inteiro e reinstalar tudo automaticamente via script sem perder 1 bit de dados e em poucos segundos. 






O ponto 10 é pra reforçar o que acabei de falar, que é manter ambientes de desenvolvimento, staging e produção o mais similares quanto possível. E isso obviamente significa tudo em repositório Git, significa builds automatizados e significa jamais editar arquivos direto no servidor. Os benefícios de fazer as coisas dessa forma é que gerenciar infraestrutura se torna muito mais fácil e quase trivial em alguns casos. É assim que nasce a área de devops de verdade.






Mais do que isso, esse fator significa fazer deploys pra staging e produção o mais rápido quanto possível pra estar próximo do que está rodando na máquina dos desenvolvedores. Nada disso de demorar um mês ou mais pra fechar uma release e mandar pra produção. Estude sobre Continuous Deployment. Plataformas como GitHub e GitLab tem configurações pra criar builds e rodar os testes da sua aplicação a cada novo commit que aparece. E se tudo passar eles fazem automaticamente o `git push heroku` pra staging ou pra produção.








Parece perigoso isso de subir pros servidores automaticamente mas só é perigoso se sua gerência é uma droga. A quantidade de bugs em produção reflete inversamente a qualidade de comunicação da sua equipe. Uma equipe disfuncional vai subir porcaria pra produção não importa quantos mecanismos de gerenciamento você coloque em cima deles.







Uma equipe saudável revisa o código um do outro antes de mergear um pull request na branch `main` do Git. Uma equipe saudável sempre adiciona testes pra cada nova funcionalidade e sempre adiciona testes que simulam um bug recém reportado, dessa forma esse bug não vai aparecer de novo no futuro. Uma equipe saudável implementa novas funcionalidades atrás um "feature flag". Seja via variável de ambiente ou via permissão pra determinados usuários testarem e pros demais usuários não conseguirem enxergar essa nova funcionalidade até toda equipe ter chance de testar e aprovar. Ou seja, mesmo a desculpa que uma nova funcionalidade vai levar semanas pra ficar pronto não é justificativa suficiente pra não estar integrando o código no repositório com frequência e não estar fazendo deploys com frequência. Quanto mais se demora pra integrar e deployar mais rápido aumenta a quantidade de bugs e conflitos, é inevitável.







Existem diversas estratégias de comunicação e organização que uma equipe saudável pode aplicar e eu acabei de descrever algumas. Estude sobre Testes, Integração Contínua e Deploy Contínuo. Só equipes disfuncionais e/ou com péssima gerência são incapazes de trabalhar de forma integrada e contínua. Lembrem-se, não importa a linguagem ou framework, produtividade, bugs, tudo isso é reflexo da qualidade de comunicação de uma equipe. Sempre.







O fator 11 de novo é meio específico pra quem desenvolve frameworks, mas fala sobre logs serem streams em vez de arquivos. Todo bom sistema manda logs pro STDOUT. Se por acaso você começou a aprender sobre logs, rotação de logs e coisas assim, esquece. Num container todo serviço deve escrever logs pro STDOUT, sempre. Daí a plataforma de infraestrutura, como um Heroku, vai capturar esses streams e mandar pra algum serviço externo de logs, como o Papertrail que mostrei antes.







Fica a dica que um sistema de log que tenta fazer coisas demais uma hora vai dar catástrofe. Que foi o que aconteceu com o caso recente do Log4j. É bem coisa de javeiro enterprise fazer uma mísera biblioteca de Log que, por alguma razão do além, permite executar comandos que vem no log e ainda vem junto com bibliotecas como de lookup de JNDI que se conecta com o mundo exterior. É o cúmulo da estupidez, pra dizer o mínimo. 








Um log4j nem precisa muito existir, pelo menos não do jeito como é hoje. Todo log deveria ir pro STDOUT e um serviço externo, separado, como Logstash, Kibana e coisas assim que deveriam consumir esses logs e organizar. Isso é fruto daquela mentalidade de arquiteto chimfrin que pensa, "ah, e se amanhã eu precisar dessa opção?" E isso tá errado. Nunca faça coisas que não precisa pra hoje. O dia que a necessidade aparecer aí pensa qual a melhor forma de resolver, mas não faça nada porque tem chances de amanhã precisar. Isso é software desnecessário, e todo software desnecessário é um buraco de segurança esperando pra ser descoberto.







Finalmente o fator 12, que fala de processos de administração, que eu já mostrei no tutorial pra vocês. A idéia é que você nunca abre um SSH direto pra um dos containers web. Toda tarefa administrativa fora do comum deve ser executado num container isolado e separado dos demais, sem concorrer os mesmos recursos com as requisições de usuários. 






Lembram quando rodei `heroku run bash` que abriu um container direto no bash? Ou quando rodei `heroku pg:psql` que abriu o console do Postgres pra criar a tabela que faltava? Em ambos os casos o Heroku subiu um novo container com a imagem da última release, ou seja, idêntico ao conteúdo dos containers web, mas fora do load balancer. Assim eu rodo no mesmo ambiente e quando terminar e desconectar, esse container é automaticamente destruído. E isso é importante, lembra o fator sobre descartabilidade?





Os 12 fatores foram muito influentes quando foram lançados porque na época o único framework que implementava com sucesso todos os fatores era o Ruby on Rails. Levou um tempão pros outros alcançarem esse mínimo. Produtos open source que não usavam nenhum framework como Wordpress ou Magento não implementavam todos os 12 fatores por padrão e também levou um tempo pra se adequarem.






O Heroku foi lançado entre 2008 e 2009, só uns 2 anos depois que a Amazon AWS apareceu. Naquela época a maioria de nós só tinha mentalidade de servidor virtual, no máximo, VPS. Ninguém pensava em particionar recursos da mesma máquina em containers e muito menos precificar por containers. Docker ainda estava a anos de ser lançado e na verdade muito do Docker foi influenciado pelo Heroku.






A Amazon estava muito a frente do seu tempo, tanto que ninguém sabia exatamente qual a melhor forma de tirar proveito dessa idéia de infraestrutura elástica. O que significava ser elástico? Como lidar com máquinas voláteis e descartáveis que quando reiniciam apagam tudo que tinha dentro? O Heroku foi a primeira plataforma como serviço ou PaaS que de fato soube aproveitar a infraestrutura que a AWS estava oferecendo.







O sonho de muitas empresas é ter um Heroku privado, o famoso private cloud, onde equipes internas poderiam facilmente dar `git push` e o deploy aconteceria automaticamente. E muitas empresas já trabalham assim. É o que todo mundo que tenta instalar Kubernetes busca. O que o Heroku chama de dynos, o Kubernetes chama de pods. A linha de comando `kubectl` da vida é inspirado na linha de comando do Heroku. Enfim, se você lida com devops de alguma forma hoje em dia, tenha certeza que muita coisa foi inspirado no Heroku.
 




Se parece fanboy falando, pode dizer que sou mesmo, porque em mais de 10 anos entregando projetos de verdade pra clientes, ainda não vi outra solução que chega perto em termos de simplicidade, flexibilidade, organização e custo benefício. Muitos acham caro a faixa de 30 dólares por dyno e é mesmo, e fazem a conta comparando com o preço bruto da hora de uma máquina no EC2. Mas a conta tá errada. A conta certa é calcular quanto custa ter uma pessoa experiente de devops de plantão todo dia pra manter sua infra. O cálculo certo não é da máquina mas do cara de devops que você não precisa ter quando usa o Heroku.






Aliás, antes que alguém vá nos comentários dizer sim, eu sei que existem soluções como o Dokku que implementa um Heroku light que você mesmo pode instalar num VPS da vida. Você também pode usar direto Docker Machine pra orquestar suas VPS. Mas de novo, você precisa adicionar o custo de alguém de infra pra dar manutenção nessa infraestrutura. Nunca vai ser plug and play que uma vez instalado ninguém mais precisa mexer. Não caia nessa armadilha. 






Além disso tem soluções como o Google Firebase que, como o Google App Engine antes dele, você programa especificamente pra essa plataforma, e vai depender pra sempre do que o Google te oferecer. Esquece querer mudar pro Azure ou AWS depois. E esquece querer usar qualquer ferramenta open source e bibliotecas que a plataforma não suporta. Tudo tem prós e contras e meu ponto é que o Heroku oferece o melhor custo benefício entre conveniência, segurança e independência do seu projeto.






Também vale relembrar que Heroku e 12 fatores não são balas de prata, eu tenho um caso pra ilustrar. Lá por 2014 estava pessoalmente trabalhando num projeto pra cliente que envolvia uma ferramenta que seria usada por vestibulandos. Era uma plataforma de educação e os donos tinham a expectativa que ia vir uma montanha de alunos de cursinho por causa de algum evento que eu não lembro mais o que era. Mas em resumo eles pediram especificamente pro sistema ser escalável.








Eu e minha equipe fizemos tudo em Ruby on Rails, que é o framework que funciona melhor no Heroku, especialmente naquela época, porque o próprio Heroku é em boa parte feito em Rails também. Fizemos deployment mas na hora do vamos ver sofremos um gargalo. Obviamente foi culpa minha que não estimou direito o tamanho do bancos de dados Postgres.








O problema é o seguinte: todo servidor de banco de dados tem um máximo de conexões simultâneas que aguenta. Faz de conta que são 100. Mesmo implementando um connection pool, se eu escalar horizontalmente a aplicação, ou seja, aumentar o número de dynos web rodando, todos vão se pendurar no banco de dados e rapidamente 100 conexões vão ficar ocupados e novos dynos vão ficar travados esperando conseguir uma conexão.






Pra lidar com isso a gente tenta mover o que não precisa pegar direto do banco em caches como Redis. E se precisa muito do banco, o certo é subir vários outros servidores que são réplicas só de leitura do principal. Assim cada nova réplica aguenta mais 100 conexões simultâneas, por exemplo. Mas não dá pra colocar réplicas infinitamente porque quanto mais réplicas tem, maior o trabalho de replicação dos dados, aí vai dar gargalo na sincronia de replicação.






Muito iniciante que entra em plataformas como Heroku achando que vai colocar um addon de auto-scale e tudo vai escalar infinitamente sozinho, se decepciona que não funciona mágico assim. Escalabilidade é uma combinação de funcionalidades de infraestrutura e arquitetura bem implementada. Depende mais do programador do que da infraestrutura. Mas se você for um bom programador, um Heroku dá tudo que você precisa com o mínimo de esforço. É impressionante o que eu consigo fazer sozinho num ambiente desse em 5 min, coisa que no começo dos anos 2000 ia me custar dias de configuração. Já se você for um programador ruim, nenhum Heroku ou solução de cloud vai te ajudar, só vai ser um band-aid temporário.








Eu já venho repetindo isso faz alguns episódios e vou repetir de novo. Eu tenho projetos pra clientes que funcionam assim, mas o certo como já disse antes é que os ambiente de staging e produção não estejam muito longe da versão em desenvolvimento na máquina dos desenvolvedores. Pra que isso seja possível, precisa obrigatoriamente existir os seguintes passos.






Primeiro passo, toda nova funcionalidade e toda correção de bugs deve vir acompanhado no mínimo de testes unitários. Todo pull request sem testes deve ser automaticamente rejeitado. Sem exceções. Essa é a principal regra que vai garantir que seu projeto sobreviva por muitos anos. No começo, com pouca gente, com pouco código e com prazos apertados, parece que é uma grande perda de tempo. E é assim que amadores pensam e é assim que amadores se ferram quando o projeto rapidamente cresce fora de controle.







Quando você satisfaz essa primeira condição agora precisamos do segunda passo: que é integrar o código constantemente e frequentemente. Ou seja, nenhum desenvolvedor deve ficar dias e dias com código que só existe na sua máquina, demorando pra dar push pro repositório no GitHub ou GitLab. Todo desenvolvedor deve, no mínimo uma vez por dia, dar pull, ou seja, puxar as últimas atualizações do repositório pra pegar tudo que todo mundo da equipe andou trabalhando e dar rebase com seu branch de desenvolvimento e corrigir conflitos. E com sua suite de testes unitários, rapidamente ver o que quebrou e consertar imediatamente. Se você faz isso com frequência, os conflitos são simples de resolver, se der conflitos. Quanto mais tempo demora pra integrar, mais difícil vai sendo pra resolver os conflitos do seu código com dos outros programadores da equipe, e maiores as chances de fazer bosta e subir bugs.







Isso é integração contínua. Facilita muito se como regra número três você estiver usando algo como GitLab que tem suporte a rodar testes automaticamente no servidor, ou usar qualquer outra solução como CircleCI. Você deixa um Dockerfile configurado no projeto, o GitLab vai buildar toda vez que alguém der push pro repositório e colocar numa fila pra rodar todos os testes automatizados. Se falhar já notifica pra todo mundo e assim garantimos que todo código que está na branch `main` sempre tem todos os testes rodando e passando. O objetivo é esse: que sempre que alguém der clone do branch `main`, tudo sempre vai funcionar. O branch `main` tem que ser sagrado. Tudo que está inacabado deve estar em branches de desenvolvimento separados.







É essa condição que permite a próxima regra número quatro que é, toda vez que todos os testes automatizados passarem, deve ser feito deployment pra um ambiente de staging. O Heroku suporta criar pipelines de staging e production, assim você sempre tem uma infraestrutura idêntica de testes e de produção. Daí um GitLab da vida mesmo faz o `git push heroku` automaticamente pra staging e sua equipe pode imeditamente testar no navegador como um usuário normal pra ver se realmente nada quebrou, se as novas funcionalidades estão mesmo funcionando.








Recapitulando: uma equipe saudável e produtiva vai sempre desenvolver código com testes automatizados, vai sempre integrar continuamente, vai sempre ter um servidor de testes como GitLab que roda a cada push, de cada desenvolvedor. E finalmente, vai sempre ter deployments automáticos pra ambiente de staging toda vez que todos os testes automatizados passam. E fica como opção subir pra produção automaticamente ou deixar alguém de QA,
 por exemplo, responsável por fazer testes manuais no final e apertar o botão pra deployar pra produção e liberar pros usuários. 








Um modelo similar ao Heroku, com um projeto arquitetado pra atender os 12 fatores, e com minhas 4 últimas regras é o que eu chamo do framework mínimo pra toda equipe de desenvolvimento verdadeiramente Ágil. Toda outra metodologia, sistema de backlog e controles, é opcional e não relevante pra produtividade de verdade. Lembrem-se, a qualidade do software é diretamente proporcional à qualidade da comunicação da equipe. Não tem como fugir disso. Se sua equipe se comunica mau e porcamente, seu software vai ser necessariamente uma grande droga.








A idéia hoje foi só apresentar pra quem é iniciante como que profissionais de verdade trabalham ou gostariam de trabalhar. E é esse nível que vocês deveriam almejar alcançar. Se você trabalhar num lugar que não funciona assim, tente evangelizar o jeito certo. Vai implementando um aspecto de cada vez, vai fazendo limpeza um pedaço de cada vez. Mesmo nos projetos mais antigos e mais porcos é possível transformar num projeto eficiente se, primeiro, a equipe entende que dá pra melhorar e se compromentem a fazer limpeza e não aumentar mais a sujeira. Por hoje é isso aí. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e compartilhem o video com seus amigos. A gente se vê, até mais.
