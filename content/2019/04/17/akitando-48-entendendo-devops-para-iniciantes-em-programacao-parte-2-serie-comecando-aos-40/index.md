---
title: '[Akitando] #48 - Entendendo "Devops" para Iniciantes em Programação (Parte
  2) | Série "Começando aos 40"'
date: '2019-04-17T17:00:00-03:00'
slug: akitando-48-entendendo-devops-para-iniciantes-em-programacao-parte-2-serie-comecando-aos-40
tags:
- heroku
- docker
- kubernetes
- cgroups
- linux
- devops
- cloud
- aws
- akitando
draft: false
---

{{< youtube id="mcwnQVAn0pw" >}}


Hoje finalmente vamos usar tudo que aprendemos até agora pra explicar as diferenças entre hypervisors e containers, e agora sim, falar um pouco mais de Docker e Kubernetes.

Precisamos explicar o que foi essa mudança no mundo de sysadmins de ter que lidar com hardware pra um mundo onde hardware essencialmente se tornou software pra muitos casos, especialmente em Web e como empresas como a Amazon AWS e Heroku ajudaram a mudar inclusive a forma como programamos.

Links:

* Goodbye Docker and Thanks for all the Fish (https://technodrone.blogspot.com/2019/02/goodbye-docker-and-thanks-for-all-fish.html)
* The Twelve-Factor App (https://12factor.net)

=== Script


Olá pessoal, Fabio Akita

Este é o décimo terceiro episódio da série Começando aos 40, e parte 2 do tema de devops. Recapitulando, semana passada eu expliquei como saímos das hospedagens compartilhadas e colocations dos anos 90 para as VPSs e opções baseadas em tecnologias de virtualização. Entendemos as diferenças de full virtualization, paravirtualização e um pouco de containers e hoje vamos entrar na melhor década do século XXI até agora pra gente. Pra muita gente a revolução na área veio com Docker e pra outras pessoas esse período pode estar chegando ao seu fim. Vamos ver como!


(...)


Como eu disse no episódio anterior, o mundo de infraestrutura não estava preparado para o boom que começou a acelerar principalmente a partir de 2005. Unicórnios estavam se proliferando, crescendo em demanda muito rápido e nenhum data center estava preparado para eles. Aliás, no episódio anterior eu mencionei VPS mas não expliquei direito o que são. Virtual Private Servers, basicamente são serviços onde você escolhe um tipo de máquina virtual, quanto de CPU, quanto de memória, de disco e que sistema operacional e paga uma mensalidade por máquina. Na época eu gostava de usar os da Linode mas tinha vários outros. Era como alugar uma máquina num data center, só que virtual, então mais barato e mais fácil.


A própria Amazon, no começo dos anos 2000 estava passando por problemas de escala. Cada novo projeto levava 3 meses só pra configurar a infraestrutura, as máquinas, os bancos de dados, a rede. E fazendo tudo do zero toda vez. Sendo um ecommerce estamos falando de um negócio de margem baixa, por isso cada centavo conta. E nesse caso foi natural juntar anos de experiência criando essa infraestrutura do zero pra criar um serviço pra automatizar e gerenciar todos esses recursos, mitigando essa necessidade de fazer tudo do zero o tempo todo e foi assim que em 2006 a Amazon lança os produtos EC2 pra máquinas virtuais, o S3 pra blob storage e o SQS que é o Simple Queue pra filas - um componente importante pra escalabilidade como já expliquei nos episódios sobre concorrência. Logo depois a AWS lança o EBS que é o Elastic Block Storage que são volumes montáveis nas máquinas EC2 pra ser a segunda opção de armazenamento.


A grande vantagem de máquinas EC2 é você poder criar, ou provisionar uma máquina, criar um volume EBS, anexar esse volume à máquina EC2, e de dentro dela montar o volume no sistema operacional, formatar e usar como se fosse um disco normal. Dessa forma tudo que você instalar ou configurar ficaria persistido nesse volume. Se amanhã você quisesse criar uma segunda máquina bastava criar um snapshot da máquina e carregar num segundo EC2 ou se quisesse aumentar a capacidade computacional da máquina, podia literalmente apagar a máquina, criar outra maior e anexar o mesmo volume e tudo funcionaria praticamente plug and play.  Descrevendo desse jeito se parece com qualquer VPS, então o que foi tão diferente assim?


A AWS fez duas coisas muito diferentes dos VPS: cobrança e controle. Primeiro foi o modelo de bilhetagem onde você pagaria por hora de uso dos recursos, ou por megabytes usados no caso do S3. Em vez de pagar uma mensalidade pela máquina você pagaria pelo uso real. Esse tipo de granularidade, mais próxima da minutagem de celulares nunca tinha sido tentada em hospedagens. Ou seja, se você decidisse que só esta semana precisa de uma máquina maior, podia fazer a mudança, depois voltar pro tipo de máquina menor, com facilidade e pagando só pelas horas usadas. 


Mais importante: você podia controlar tudo via APIs, sem precisar entrar num dashboard. De repente você queria criar e apagar máquinas com mais frequência, pra tirar vantagem desse modelo. Uma vantagem de ser a Amazon é que eles começaram rapidamente a replicar o modelo em múltiplas regiões geográficas diferentes, permitindo que grandes empresas pudessem escalar rapidamente e com redundância entre diferentes data centers, com a facilidade de enviar um comando numa API. Esse tipo de granularidade de cobrança e de controle simplesmente não existia.


Acho que aqui podemos dividir a história da infra de web em 2. O antes e depois da AWS, com o advento de lidar comercialmente com máquinas da mesma forma como lidamos com software. Deixa eu explicar. Desde sempre na história da informática tínhamos uma polarização: desenvolvedores de software gostam e precisam mexer no software o tempo todo, pra corrigir bugs, pra adicionar novas funcionalidades que vão atrair mais pessoas. Já um sysadmin, ou dba ou administrador de redes, depois que terminam de configurar tudo, eles querem mexer na infraestrutura o menos possível, de preferência nunca mais. Software vs Hardware, soft vs hard.


Isso porque infraestrutura como vocês puderam ver até agora sempre foi um House of Cards … não, não esse … esse outro, isso, literalmente. Racks, roteadores, cabeamento, HDs, metal e parafusos. Um monte de peças de lego montados um em cima do outro. Assopre muito perto e a casa despenca. Basta uma linha de configuração errada e você comprometeu a segurança e integridade de tudo. Basta um comando de formatar o drive errado e você perdeu todos os dados. 


Isso me lembrou de um caso que eu vi acontecer anos atrás. Um operador de data center fez um script às pressas pra resolver um problema. No Bash você tem várias variáveis globais que começa com cifrão, não lembro o que ele queria fazer mas no final ele digitou uma letra errado. Esse script foi enviado via SSH pra dezenas de servidores reais. Talvez tenha sido o $0 que pega o último comando rodado. De repente dezenas de máquinas ficaram sem o Bash! Logar remoto via SSH não funcionava porque não tinha mais o Bash pra abrir um novo terminal. A única forma de voltar a ter acesso nas máquinas foi ir até o data center e várias pessoas com pen drives conectarem fisicamente, espetar os pen drives, e copiar o binário do bash de volta. Foi meio tenso.


Por isso um bom sysadmin precisa ser uma pessoa paranóica, que checa e recheca o que está fazendo, que vai fazer o possível pra ter redundância de tudo, que vai fazer backup do backup, que vai checar que o backup de fato funciona pra restaurar, que vai monitorar cada minuto de cada servidor pra ver se alguma coisa está acontecendo. E mesmo assim, num momento de emergência, depois de varar 2 noites, uma letra errada num script pode gerar uma catástrofe.


Enfim, dependendo do seu projeto, podia levar dias ou até meses pra coordenar a configuração de uma nova infraestrutura pra um projeto. Mexer nesse house of cards … depois de tudo pronto era proibido, você tinha que tratar essas coisas como se fosse material nuclear: só pessoal autorizado podia criar um novo índice numa tabela num banco de dados ou instalar qualquer pacote novo. Rodar scripts direto no servidor, nem pensar. No fim dos anos 90 era caos, mas à medida que entramos nos anos 2000 e o mundo enterprise começou a adotar tecnologias de web, a cultura corporativa foi sendo adotada primeiro. 


Foi só depois da recuperação da crise da internet de 2001, depois que os unicórnios que falei antes começaram a aparecer, que essa cultura entrou em conflito com as necessidades de escalar mais rápido. A cultura de infraestrutura dessa época, regada a coisas como ITIL era insuficiente. Não é a mesma coisa mas ITIL era como se fosse o Waterfall no mundo de software ou os atuais Pseudo Agile pra gestão de projetos, um conjunto de processos e rituais burocráticos e corporativistas.


Dentro de um lugar como Twitter ou Amazon você teria guerra civil entre desenvolvedores e sysadmins se as coisas continuassem do mesmo jeito. Em projetos pequenos, os VPS ajudaram porque era fácil dar máquinas virtuais pra desenvolvedores, mas eles ainda não tinham tudo que se precisava pra escalar. As ferramentas de gestão de configuração como Chef ou Puppet também ajudaram os sysadmins porque agora o que levava dias pra configurar levaria horas ou minutos. 


Mas a divisão entre os dois lados continuaria, um desenvolvedor de software simplesmente não tem conhecimento ou experiência suficiente pra ganhar acesso de entrar numa máquina de produção. Ninguém quer correr o risco de alguém não autorizado entrar e deixar uma brecha de segurança pra trás. E da forma como se fazia software até esse ponto, você fazia deployment da aplicação no servidor e alguém precisava entrar na máquina via um terminal pra acertar arquivos de configuração, acertar tabelas e índices no banco, rodar alguma rotina extra pra instalar dependências que faltaram e coisas assim.


Mas quando a AWS liberou máquinas virtuais como um serviço tivemos uma quebra de paradigma. A somatória das tecnologias que falei até agora facilitaram uma coisa que antes era muito difícil: destruir e recriar máquinas em poucos segundos. Pra começar, a AWS era muito maior que qualquer VPS. Só isso já eliminou a necessidade de precisar ter máquinas físicas pra maioria das médias e até grandes empresas que não tinham políticas antiquadas e aceitavam mais riscos. 


Agora os sysadmins ganharam a capacidade de criar imagens e oferecer essas imagens aos desenvolvedores rapidamente. Era muito fácil criar ambientes de teste separados do ambiente de produção mas ambos configurados exatamente iguais, de forma que o que funcionava em ambiente de teste garantidamente funcionaria nas máquinas de produção. E o melhor, a custos muito menores e com menos necessidade de planejar com tanta antecedência porque não havia coisas como mensalidades que são compromissos longos.


Entenda uma mudança de papéis: antes os sysdadmins lidavam diretamente com bare metal. Instalavam os servidores reais em racks físicos e ligavam cabos de redes e configuravam direto na máquina com teclado e monitor conectado no hardware. Com as VPS e depois a AWS, nasceu uma segunda categoria de sysadmins que não precisavam mais ter contato com equipamento físico, a menos que trabalhassem em data centers. As empresas não precisavam mais se preocupar em comprar hardware e sim em contratar serviços.


Com as tecnologias de virtualização e containerização que falei no episódio anterior, nós essencialmente empacotamos uma máquina virtual como um software. E foi criado um novo modelo de negócios em cima dessa nova categoria de software. Por agora vamos só entender que no momento em que o provisionamento de máquinas virtuais se tornou programático, via APIs, passamos a tratar a infraestrutura como software. Assim nasce a Infraestrutura como Serviço ou IaaS. 


Surgiram esforços open source pra clonar os conceitos proprietários da AWS como o Eucalyptos que a Canonical adotou mas hoje já meio que morreu, e o OpenStack que foi adotado por centenas de empresas e veio evoluindo bastante nos últimos anos e é composto por dezenas de componentes como o Nova que orquestra hypervisors como o Hyper-V ou vSphere, o Neutron que cuida de tudo relacionado com rede incluindo detecção de invasão, enfim, dezenas de componentes. 


E o OpenStack só iniciou mesmo a partir de 2010, ou seja 4 anos depois da AWS, só pra vocês entenderem que o que a AWS inventou em 2006 era difícil de replicar. Levou anos pra aparecer concorrentes de verdade. Foi só depois de 2010 que ganhamos boas opções comerciais como Microsoft Azure e Google Cloud. Eles estão competindo bem e as opções são equiparáveis na maioria dos produtos. Como a gama de opções de cada uma é muito grande então diferentes pessoas vão ter críticas de coisas diferentes em diferentes cenários. Não tem um vencedor hegemônico.


Até aqui eu dei uma rápida passada pelos conceitos de paravirtualização e virtualização acelerada por hardware como as instruções VT-X além das ferramentas de gestão de configuração como Chef e finalmente a primeira geração de orquestração de infraestrutura como OpenStack que ajuda a levar um ambiente como a AWS pra dentro de grandes empresas que precisem de garantias totais de segurança como agências governamentais ou empresas que lidam com dados de alta periculosidade ou privacidade como dados médicos ou financeiros sensíveis. Ou sei lá, os projetos de uma bomba nuclear. Você certamente não deveria colocar essas coisas no Dropbox. 


Essa vertente de IaaS privado é mais conhecido como Cloud Privado e existem várias empresas que oferecem soluções como o OpenShift da RedHat, o CloudFoundry da Pivotal. Assim você consegue ter a flexibilidade de infraestrutura virtualizada que pode ser rapidamente utilizada pelos projetos internos sem precisar da antiga burocracia de infraestrutura e se mantendo num perímetro controlado fora da internet pública.


Até aqui vimos até onde as tecnologias de virtualização chegaram no mundo comercial. Mas containers ainda não entraram na história. Vamos voltar um pouco pra 2006, que foi quando o Google desenvolveu outro projeto, o Process Container que foi uma evolução em cima dos Jails de BSD ou Zonas de Solaris ou mesmo os OpenVZ e Vserver de Linux. Repetindo: a ideia não é virtualização como Vmware ou Parallels ou Virtualbox, e sim isolamento dos processos e dos recursos da máquina. 


Esse projeto foi renomeado depois pra Control groups ou cgroups. A ideia ainda é fazer a kernel mentir pros processos. Desse jeito você pode ter dois processos rodando na mesma máquina, no mesmo sistema operacional, mas um sem saber da existência do outro, quase como se estivessem em máquinas completamente diferentes. Se o objetivo é só isolar um processo, todas as opções de jail que culminaram no cgroups são ordens de grandeza mais leves do que virtualização, porque você ainda está rodando somente uma kernel em vez de múltiplas kernels virtualizadas.


Vamos rever conceitos: um sistema operacional é um conjunto de binários. A primeira coisa depois do boot loader é a kernel, é o primeiro grande binário que carrega com os privilégios máximos do Ring-0 e é responsável por carregar todo o resto do sistema, que por sua vez são conjuntos de programas como os drivers, supervisores como systemd, daemons e assim por diante. Em distribuições Linux, mesmo rodando praticamente o mesmo binário de kernel, o que diferencia um RedHat de um Ubuntu ou Arch é esse conjunto de binários que vai empacotado na distribuição e como eles são configurados, incluindo preferências em estrutura de diretórios ligeiramente diferentes, sistema de pacotes como yum ou apt ou pacman. Mas tudo começa com o kernel e os drivers, daí ele monta o volume de disco como o “barra” que é o root e de lá vai carregando todo o resto no userland ou Ring-3.


O tal cgroups consegue isolar os recursos da máquina e fazer os processos em userland enxergar só o que ele mandar enxergar. Ele vai dizer quanto de CPU, de memória o processo vai enxergar mas em particular, assim como o conceito do chroot que falei antes, ele pode mascarar o volume de disco e carregar um root diferente do sistema hospedeiro. Se você carregar um outro root com outro conjunto de programas userland, na prática você pode ter um hospedeiro que é um RedHat e dentro do jail do cgroups carregar os binários que formam um Ubuntu ou qualquer outra distro.


Voltando ao cgroups do Google, em 2008 tivemos o lançamento do LXC ou Linux Containers, que é um conjunto que inclui coisas como daemons e ferramentas de linha de comando que engloba não só o cgroups que passou a vir no kernel do Linux como namespaces que permite etiquetar processos. O cgroups consegue criar os limites pra grupos inteiros de processos. Quando você cria um namespace de processos, seu processo vira o PID, ou process ID, número 1 e os filhos desse processo vão seguindo nessa sequência. Diferentes namespaces vão ter diferentes processos PID 1. Você tem namespaces de rede, daí seu processo pode se ligar a uma porta virtual, assim vários processos podem responder numa porta 80 virtual, na mesma máquina, e uma bridge ou ponte virtual de rede vai cuidar pra que isso seja possível, fazendo tipo um NAT entre os containers e a rede externa. E tem namespaces de mounts, onde você pode montar e desmontar volumes dentro do container, sem afetar os mounts do sistema hospedeiro. 


Lembram como eu expliquei que o sistema operacional mascara os endereços reais de memória pra uma memória virtual e o endereço virtual 0 de memória que um processo vê não é o endereço 0 real da memória? Ou como um chroot mascara o filesystem e cada processo enxerga roots no disco em lugares diferentes? Assim dois processos nunca vão pisar um em cima do outro? Pense em cgroups e namespaces como o equivalente pra todos os outros recursos da máquina, incluindo recursos de rede e I/O. Eu sei que estou sendo repetitivo mas é importante deixar claro: os containers de LXC parecem muito com um sistema operacional, mas eles compartilham a kernel do mesmo sistema, muito diferente de hypervisors que gerenciam máquinas virtuais inteiras, cada um com seu kernel. Um jail que restringe processos e compartilha o mesmo kernel entre vários jails é o que chamamos hoje de um container.


Esses anos entre 2006 e 2008 pra mim foram muito interessantes. Não quero entrar em muitos detalhes aqui mas eu acho que hoje em dia não preciso mais explicar o que é o GitHub ou GitLab, porque qualquer desenvolvedor que se preza já sabe usar Git. Se você ainda tinha alguma dúvida, Git é obrigatório, tem que saber! Mas antes de 2006 isso não era verdade, muitos usavam Subversion ou outras alternativas como BitKeeper, as porcarias de SourceSafe ou Clearcase, ou mesmo CVS. Mas a partir de 2007 o Git, que é uma ferramenta para gerenciar repositórios de código fonte versionados e distribuídos começou a ganhar terreno rápido, e com o início da popularização do Github em 2008 na comunidade Ruby on Rails, ela criou as sementes não só pra versionar código de aplicações mas também pra servir como mecanismo para automatizar muita coisa.


Também em 2008 outra empresa surgiu na comunidade Ruby on Rails pra resolver o problema que eu vim discutindo até agora de instalar, configurar e manter infraestruturas em máquinas virtuais. Pense somar um provedor de VPS com as capacidades de Linux containers via os cgroups e integrando com um processo de deployment usando repositórios Git. Esse é o Heroku. Se você nunca usou, deveria. É a recomendação pra todo mundo que não tem um sysadmin trabalhando tempo integral ou pra desenvolvedores que não tem experiência com infraestrutura. 


Como já disse antes, o AWS EC2, principalmente em 2008, ainda não é muito diferente de um VPS do ponto de vista de um desenvolvedor. São máquinas virtuais. Você programa em PHP, ou Python ou Ruby. Mas pra subir sua aplicação precisa saber instalar e configurar banco de dados, servidor web, rede e tudo mais. Ou seja, ou vai entrar manualmente via SSH e configurar tudo na mão, ou vai usar um Capistrano ou Puppet pra fazer isso. E se você é iniciante isso não é trivial.


Mas e se existisse um serviço por cima desse AWS onde você pudesse simplesmente criar uma conta, cadastrar uma nova aplicação, daí rodar um “git push heroku” que é o comando de git pra subir seu código num repositório Git, e de repente toda sua aplicação é instalada, configurada e está pronta pra rodar, inclusive com banco de dados e outros serviços? Isso é o Heroku. Eles conseguiram tirar vantagem de cgroups e criar seu próprio padrão de containers e montar um modelo de negócios, 5 anos antes de um Docker aparecer. O que você chama de Dockerfile hoje, mais ou menos é o que o Heroku chamou de buildpacks. Todo mundo tentou fazer algo parecido mas levou anos pra chegar perto. Como o Heroku nunca abriu seu padrão de containers pro mundo open source, precisou o Docker aparecer anos depois pra finalmente termos um concorrente.


O que o Heroku conseguiu fazer foi tornar a infraestrutura trivial pra desenvolvedores. Lembram como eu passei o episódio inteiro da semana passada falando como era complicado montar uma infra com confiabilidade e segurança? É o melhor meio do caminho entre uma VPS ou AWS puro e um Kubernetes porque eles acertaram a usabilidade e foram inteligentes no modelo de negócios. 


A partir de 2006 o mundo de tech startups explodiu, inspirada por todos os novos unicórnios crescendo como se não houvesse amanhã. Todo mundo queria conseguir subir suas coisas nas novidades da AWS mas ninguém tinha conhecimento suficiente de infraestrutura pra ficar lidando com CF Engine ou Puppet. Pior ainda, um desenvolvedor não sabe como de fato configurar um banco de dados. Não basta só instalar porque a configuração padrão costuma ser ruim, então você precisa saber tunar esse banco pra caber no seu servidor corretamente. Ninguém sabe configurar replicação master slave. E por aí vai.


Por causa disso se abriu um nicho pra tech startups que não existia até então. Se você quer enviar e-mails, jamais tente montar seu próprio servidor de e-mail como a gente fazia no começo dos anos 2000. Em vez disso contrate um serviço como Sendgrid ou Mailgun. Em vez de montar seu próprio servidor de Redis, com redundância, backup e tudo, contrate uma RedisLabs. Em vez de montar seu próprio servidor de cache com Memcached, contrate a Memcachier. Em vez de ter que lidar com repositório pra upload de imagens ou outros arquivos e ter que programar coisas como processamento de imagens, contrate a Cloudinary. E por aí vai.


Se a AWS inaugurou a categoria de IaaS ou infraestrutura como serviço, o Heroku inaugurou a categoria de PaaS ou plataforma como serviço e finalmente, empresas como New Relic, Papertrail, CloudAMQP, Sendgrid, Cloudinary, e centenas de outros inauguraram a terceira categoria: o famoso SaaS ou Software as a Service. 


E o que o Heroku fez de inteligente foi desde o começo integrar esses diversos SaaS em sua plataforma de tal forma que fosse simples tanto via o dashboard web quanto via linha de comando adicionar esses serviços aos nossos projetos, além de integrar a cobrança de tudo numa fatura só. Mas eles mantiveram pra eles alguns dos serviços mais críticos como o banco de dados Postgresql e depois o Redis. E por isso era tão difícil tentar implementar um clone de Heroku você mesmo. A parte de containers, buildpacks e deployment usando um comando como git push não era tão difícil subir algo parecido num VPS como Linode ou DigitalOcean. Mas não adiantava nada fazer deployment da sua aplicação e não ter um banco de dados confiável. Daí você caiu no mesmo problema de antes de ter que configurar o banco de dados e, principalmente, manter ele rodando.


Eu diria o seguinte, se você é desenvolvedor de software, não tem experiência real como sysadmin, e precisa subir sua aplicação web mas não sabe nem como começar a configurar um Kubernetes, vá pro Heroku. É muito menos dor de cabeça. E não faça a conta de centavos por hora vezes horas por mês e comparar com o preço do Heroku e dos outros SaaS. Considere quanto custa um sysadmin pra configurar e dar manutenção na infra toda por toda a vida da sua aplicação. Não tente fazer infra sozinho se nunca fez isso antes, é sempre um desastre. E se sua aplicação web não monetiza o suficiente pra pagar a conta, você está fazendo alguma coisa muito errada.


Mas, além de ficar aqui fazendo propaganda de graça pro Heroku eu queria falar de outra coisa importante. O Heroku foi inteligente também educando os desenvolvedores. Nós desenvolvedores que crescemos no fim dos anos 90, com coisas como Java ou mesmo PHP, em ambiente corporativo, estávamos mais preocupados em codar de qualquer jeito dentro do prazo e não se preocupar tanto com a qualidade ou peso da aplicação. A métrica era praticamente linhas de código por hora. Se a aplicação ficasse pesada era só culpar a infra e mandar instalar numa máquina maior e foda-se.


Em 2008, no Heroku os containers ou dynos como eles chamavam vinham em vários tamanhos, contanto que esse tamanho fosse 512Mb de RAM e acho que só depois colocaram 1GB de RAM e anos depois opções maiores. Nós rapidamente começamos a fazer aplicações web mais e mais complexas e de repente não cabia em 512Mb!! Código mal feito roda na máquina do desenvolvedor, mas quebra em produção, em particular em recursos mais restritos como nos dynos do Heroku. Aliás, dynos é como o Heroku chama seus containers. 


Eu sempre achei isso sensacional, porque é muito fácil fazer um código porco. E é sempre bom não contar com a muleta de só aumentar a máquina e mostrar imediatamente que a aplicação que tá mal feita mesmo. Quando você não tem outra opção, vai precisar programar direito. Então o Heroku ajudava a separar programador bom de programador ruim. Inclusive o co-fundador do Heroku, Adam Wiggins publicou um guia chamado the twelve factors ou os 12 fatores, que vou deixar nos links na descrição abaixo, que descreve como uma aplicação web deveria ser programada e organizada pra ser escalável. O framework Ruby on Rails desde sempre seguia esses 12 fatores e com a popularização do Heroku todo framework web que se preza passou a seguir, independente de rodar no Heroku ou não porque esses 12 fatores são universais pra apps minimamente bem feitas. E não era tão simples, um Wordpress da vida dava trabalho pra se adequar em todos os fatores na época.


Graças a isso uma nova geração de técnicas, otimizações, procedimentos e convenções começaram a mudar a forma como a gente programava. Em vez de pensar em rodar numa única máquina grande, tínhamos que parar pra pensar em rodar em múltiplos containers menores. Entendemos que a forma de escalar massivamente não é verticalmente aumentando a máquina, mas sim horizontalmente com mais containers. E na intenção de quebrar aplicações grandes pra escalar que nasceu também a idéia de micro-serviços. Eu sou contra quebrar sua aplicação em dezenas de micro-serviços sem motivos. Mas um bom motivo é quando uma aplicação grande não cabe num container, então fica óbvio que precisa ou cortar fora a gordura que não precisa, ou particionar em mais de uma aplicação em containers diferentes.


Pulando a história pra 2013 finalmente surge o tal Docker que inicialmente usou o Linux Containers ou LXC e adicionou novas ferramentas. Em particular, ele se aproveita do fato de você poder montar um root separado do sistema hospedeiro no container e passou a usar o Union File System. Pense um filesystem que consegue montar uma imagem que é somente de leitura como o novo root desse container, e toda vez que você tenta escrever ele cria uma segunda camada por “cima” vamos dizer assim. 


Lembram quando expliquei sobre o conceito de Copy on Write pra memória no caso de processos que fazem fork no Linux? É a mesma coisa só que pra disco. Por isso as imagens de Docker são incrementais. Se você usa Git, pense se você pudesse montar um repositório de Git como o root do seu container e toda vez que você modifica ou escreve alguma coisa é como se fizesse um novo commit. Assim você consegue inclusive voltar um desses commits pra versão anterior. Mais importante: você consegue empacotar esse filesystem inteiro num arquivo, que são as imagens que seu cliente de docker baixa.


O Docker depois trocou o LXC, que se usava via a biblioteca libvirt, por uma que eles mesmos fizeram, a libcontainer. Mas acho que o mais importante do Docker foi padronizar a receita pra descrever as imagens no que hoje conhecemos como Dockerfiles. Esses Dockerfiles são parecidos com as promessas de um CF Engine ou as receitas de um cookbook de Chef. É um arquivo onde você declara como essa máquina vai ser configurada, que pacotes vão ser instalados, você pode inclusive declarar que comandos rodar da primeira vez que a imagem é criada ou toda vez que ela é inicializada. E também padronizar a interface de uso de linha de comando que hoje até o Kubernetes meio que copia.


Tem gente que ainda confunde Docker com alguma coisa parecida com um Virtualbox, mas espero que com o que expliquei até agora tenha ficado mais claro. Docker não é full virtualization, não é paravirtualization e não é um hypervisor. Virtualização é literalmente falsificar o hardware físico. Nesse hardware virtual você pode rodar múltiplos sistemas operacionais diferentes, ou seja, múltiplas kernels diferentes, incluindo kernels que não são do Linux como Windows ou BSD ou Mac e inclusive de processadores diferentes de Intel ou AMD como os fazem os emuladores de videogame. 


Docker é um conjunto de ferramentas pra organizar e facilitar o uso de de cgroups, namespaces e union filesystem, tudo que você podia usar sozinho, mas a casca do Docker por cima obviamente torna tudo ordens de grandeza mais simples. Portanto você deve ter entendido que a idéia toda é rodar os programas de todo mundo no mesmo sistema operacional, na mesma máquina, sem rodar outro sistema operacional por cima. Na prática é uma máquina só, um sistema só, rodando os programas lado a lado mas com a kernel mentindo pra todos eles acharem que não tem ninguém mais. 


Mas se você já usou Docker já deve ter instalado em cima de um RedHat ou Ubuntu e dentro dos containers ter conseguido instalar e rodar outra distro Linux, totalmente diferente, como Arch ou Alpine e inclusive rodar um pacman e instalar pacotes, ou seja, fica parecendo que é um VMware ou outro hypervisor onde você instala outro sistema operacional. Como isso é possível se eu acabei de dizer que não é virtualização e estamos compartilhando o mesmo sistema operacional? 


Falando de forma bem simplificada, uma distro Linux é o conjunto do binário da kernel do Linux e de programas como o gerenciador de pacotes, o binário do Bash e outros utilitários e serviços. Tirando a kernel que roda no Ring-0, o tal kernel space, todo o resto roda em userland. Agora pense uma distro que eu removo o kernel, só sobra os programas em userland. E eu falei que num container nós compartilhamos a mesma kernel. Ou seja, se o container montar um diretório pra onde estão os programas de userland que definem um Ubuntu, então dentro desse container, pra todos os efeitos e propósitos, é um Ubuntu, mesmo que do lado de fora estamos rodando o Docker num Fedora. O Ubuntu dentro do container vai usar a kernel compartilhada do Fedora. Essa é a mágica dos containers.


Obviamente rodar todos os programas userland de um Ubuntu inteiro dentro de um container é pesado e um desperdício de recursos, especialmente se eu for inventar de querer rodar 10 containers, todos com os mesmos userland de Ubuntu repetidos. Por isso temos outras distros mais adequadas pra rodar num container como o CoreOS ou Alpine, que são userlands ordens de grandeza menores e só com os binários essenciais pra rodar a maioria dos programas que precisamos. A idéia do Docker é que o seu programa dentro do container não dependa de nada do sistema operacional hospedeiro e rode suas próprias dependências. A idéia de um container não é rodar dezenas de programas dentro dele, mas sim somente em um. Um container só pro Postgres, outro container só pro Redis, outro container só pro NGINX. 


Por isso mesmo que não existe Docker de Windows ou de Mac. A kernel do Windows não tem cgroups e namespace nem union file system, nem o Mac e acho que nenhum UNIX BSD também. Mas então como eu consigo rodar Docker no Windows ou no Mac? Na realidade você primeiro tem que iniciar um hypervisor, seja tipo 1 como o Hyper-V ou o novo Hypervisor Framework no MacOS a partir da versão 10.10 Yosemite, ou mesmo um hypervisor tipo 2 como Virtualbox ou Vmware workstation. 


Daí você cria uma máquina virtual no hypervisor e daí instala uma distro Linux com Docker. Agora, de dentro dessa máquina virtual você pode criar containers e compartilhar a kernel desse Linux. Daí o cliente de Docker rodando no Windows se comunica com o Docker rodando dentro da máquina virtual, por exemplo, via a rede interna TCP. Esse é o truque todo! Por isso, em hardwares físicos equivalentes, o Docker vai ser mais performático se o sistema operacional hospedeiro for também um Linux. Se for um Windows ou Mac você vai perder performance porque vai precisar também rodar um Linux num hypervisor antes.


A idéia de um container não é ser um sistema operacional independente. Como já disse o correto é rodar somente um único processo por container. Por isso você tem hoje soluções como o Docker Compose que permite que você declare num arquivo texto pra subir vários containers, cada qual com seu Dockerfile e dizer que volumes eles vão montar pra compartilhar arquivos, ou que portas eles vão expor que o outro container vai conseguir enxergar.


Em paralelo a isso, digamos que você montou seu Dockerfile e seu container funciona bonitinho na sua máquina de desenvolvimento, mas agora eu quero subir essa mesma imagem na minha conta na AWS EC2 ou DigitalOcean ou outro provedor de máquinas virtuais. Pra isso existe o Docker Machine, que vai facilitar o processo de subir ou fazer deployment dos seus containers num servidor na internet. Nesse caso o provedor precisa fornecer o suporte a Docker em suas máquinas virtuais ou você mesmo instalar o serviço de Docker na máquina virtual que provisionar.


Só fazer alguns containers não é suficiente. Você quer ter controle maior pra subir uma infraestrutura inteira com dezenas de máquinas virtuais e containers, além de configuração de rede, políticas de segurança e outras coisas. Organizar todos esses recursos virtuais e não virtuais de uma forma coordenada requer mais que só um vmware ou docker, por isso existem as soluções que chamamos de orquestradores, como o Docker Swarm, ou o Mesos, ou Marathon ou Nomad. Mas em 2019 quem realmente se tornou o padrão de fato é o Kubernetes do Google, que está disponível em todo provedor de infraestrutura como serviço, desde o Google Cloud, Microsoft Azure ou AWS.


Essas soluções se confundem com o próprio Docker já que num Kubernetes você instala imagens compatíveis com as de Docker e o runtime de containers por um tempo foi o próprio Docker. Na prática imagine que você está no Google Cloud, que é concorrente da Amazon AWS. Você tem máquinas virtuais rodando em cima de alguma coisa como o Citrix XenServer, que do ponto de vista de um servidor, é como se fosse seu Virtualbox ou Vmware que você roda no seu desktop ou notebook. O Kubernetes enxerga isso como Nodes ou nós. E dentro desses nodes você pode rodar múltiplos containers Docker que o Kubernetes enxerga como containers, agrupados dentro de Pods. Mais do que isso você tem um registro central de toda a infraestrutura de tal forma que se um container tiver problemas e cair ou node cair, o sistema central sabe como reconstruir. 


Se você está iniciando, parece algo que um Docker compose e Docker machine resolveriam, mas o Kubernetes, ou seus concorrentes como o Swarm ou Mesos, são mais complexos que isso. Além de containers, temos que lidar com storage, com endereços de IP externos e internos, regras de firewall, clusters. Ele está preparado pra cenários com múltiplas zonas; por exemplo distribuir parte dos seus containers na zona Estados Unidos Central e outros containers na zona Asia sul caso você tenha público tanto na América quanto na Ásia e quer oferecer a melhor performance pros dois públicos. E existe o suporte a cluster de federações, dessa forma você pode manter parte da sua infraestrutura no Kubernetes do Google Cloud que é GKE e outra parte no Kubernetes da AWS que é o EKS. Ou seja, em provedores diferentes de cloud. 


Em resumo o Docker se tornou uma organização, um ecossistema, e um conjunto de ferramentas, mas por baixo dos panos os componentes que realmente importam e possibilitam isso vem na kernel do Linux, que é o cgroups e o namespace. Todo o resto é só uma convenção de uso e um padrão. Inclusive surgiu uma iniciativa do próprio Docker pra padronizar o runtime de containers e o formato das imagens, que é o Open Container Initiative ou OCI. Diversos projetos concorrentes ao Docker surgiram por conta do runtime-spec e image-spec como gvisor, clearcontainers ou katacontainers. Eu mencionei que o Kubernetes usa o runtime de containers do próprio Docker mas pouco a pouco já se vê instalações de Kubernetes que não usam mais o Docker.


O Heroku teve um papel importante em educar e demonstrar como montar uma plataforma como serviços viável. E o Docker teve um papel importante em consolidar o uso de containers Linux e padronizar seu manuseio. Mas com a abrupta popularização do Kubernetes, se não tomar cuidado, o futuro do próprio Docker é incerto já que o Kubernetes está comendo a fatia de mercado de orquestração. De qualquer maneira, se você quer ser um bom sysadmin nos tempos modernos, no mínimo precisa saber como funciona Docker e seus outros produtos e Kubernetes. E não basta treinar só na sua máquina com minikube, você precisa entrar num Google Cloud e usar o kubernetes lá. Isso é o mínimo hoje, além do que eu já venho falando desde o começo desta série: estude e aprenda Linux de verdade!


E por hoje vamos parar por aqui, eu falei rapidamente de como saltamos do mundo primitivo de hospedagens compartilhadas e deployment de sites via FTP pras evolução das tecnologias de virtualização e containers, até chegar no Docker e Kubernetes. Mas isso ainda é só o pico do iceberg. Eu acho que pra fechar o tema de devops, semana que vem vou tentar falar especificamente sobre banco de dados e outro termos hipster, os famigerados NoSQL e talvez uma pincelada na arquitetura moderna de Web e o comportamento das diferentes linguagens de programação nessa arquitetura de cloud.


Mesmo estando num mundo de Kubernetes, as opções todas que eu falei desde o começo como hospedagens compartilhadas, servidores físicos em colocation, VPS, todas ainda existem e muita gente ainda programa do jeito antigo e tem muita dificuldade de entender porque as coisas são diferentes hoje. Por isso eu precisava que vocês entendessem onde esse monte de nomes como cgroups, hypervisors se encaixa no contexto geral. Se ficaram com dúvidas - e eu imagino que ficaram - mandem nos comentários abaixo pra galera ajudar, se curtiram mandem um joinha, continuem ajudando o canal compartilhando com seus amigos, não deixem de assinar o canal e clicar no sininho pra não perder a continuação dessa história! A gente se vê semana que vem, até mais!
