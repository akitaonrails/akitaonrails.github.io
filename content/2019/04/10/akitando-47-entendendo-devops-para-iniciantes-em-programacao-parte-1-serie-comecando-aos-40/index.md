---
title: '[Akitando] #47 - Entendendo "Devops" para Iniciantes em Programação (Parte
  1) | Série "Começando aos 40"'
date: '2019-04-10T17:00:00-03:00'
slug: akitando-47-entendendo-devops-para-iniciantes-em-programacao-parte-1-serie-comecando-aos-40
tags:
- chef
- puppet
- cfengine
- cpanel
- freebsd
- linux
- hypervisor
- virtualbox
- vmware
- hyper-v
- microsoft
- google
- vps
- xen
- citrix
- devops
- sysadmin
- cloud
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/bwO8EZf0gLI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


Finalmente chegamos no tema final da série! Vamos falar um pouco sobre o tal do "devops".

Esta parte meio que depende dos conceitos que vimos nos últimos episódios então se você é iniciante, e ainda não assistiu os anteriores, recomendo que faça isso.

No episódio de hoje quero dar um pouco do contexto histórico, dos anos 90 até os anos 2000, indo de configuração manual de máquinas, hospedagens compartilhadas, virtualização até os VPS. Vamos entender como uma coisa foi levando pra próxima.

Muita gente confunde muitos termos, virtualização, paravirtualização, jails, containers, hypervisors e não sabe o que é o que, então eu vou distinguir tudo pra vocês finalmente entenderem.

=== Script


Olá pessoal, Fabio Akita

Depois de muitas semanas, finalmente terminamos o tema de Back-end semana passada. Mas continuando na série Começando aos 40, décimo-segundo episódio já, precisamos entrar no tema de infraestrutura e devops. É bom eu já deixar claro desde já que minha formação e experiência principal é desenvolvimento de software, mas ao longo dos anos eu tive que lidar com infraestrutura várias vezes então digamos que eu tenho muitas opiniões a respeito. Mas é bom lembrar que eu nunca atuei como administrador de sistemas em tempo integral.


Aliás, durante esses próximos episódios você vão ver que vou ficar o tempo todo complementando “como eu já expliquei antes” e eu já expliquei mesmo, nos episódios anteriores. Então eu realmente recomendo que você tenha assistido todos os últimos 11 vídeos antes de começar esse se você ainda for iniciante. Se já é programador, vamos lá, e talvez você veja que mesmo trabalhando na área ainda tem coisas que você não sabe e, nesse caso, recomendo que tente ver os vídeos anteriores também, eu sempre escolho falar coisas que eu vejo que a maioria das pessoas não conhece, independente quantos anos já trabalha.


Devops é um daqueles termos chatos de definir e que você provavelmente está usando errado. É a mesma coisa com Agile. Agile não é só ter sprints ou backlogs ou rituais. Devops também não é um título, não são ferramentas, não é uma metodologia, não é uma cultura. É tudo isso e nada disso. Pois é, é uma merda mesmo esse termo, eu detesto coisas difíceis de definir. Pra entender melhor devops é mais fácil começar delineando os problemas e no final talvez chegar na conclusão.




(...)




Eu diria que se eu fosse detalhar tudo que eu gostaria sobre o tal devops, eu ficaria até o fim do semestre. Em vez disso, assim como fiz com front-end, quero dar mais um apanhado geral da linha do tempo e alguns conceitos e ferramentas. Vocês tem que entender que a área é gigantesca, você pode passar anos lidando com infraestrutura e nunca ver tudo. Por exemplo, eu nunca operei diretamente num data center, eu conheço vários dos conceitos mas o hardware moderno de data centers é uma coisa que eu só conheço na teoria, portanto eu não vou entrar muito nesse assunto. A área específica de redes é outro mundo a parte. Uma coisa é rede caseira ou de pequenas empresas, outra coisa completamente diferente é lidar com redes físicas em data centers, lidar com fibra ótica e roteadores nível “industrial” que você vai encontrar em provedores. Também existem os data centers privados em grandes corporações que usam muitas das mesmas coisas. 


Na prática, metade do mundo de infraestrutura você nunca vai ter acesso, pelo simples fato que os hardwares e componentes nível data center você nunca vai chegar a colocar as mãos. Os tipos de componentes que temos no mundo de varejo consumidor, os PCzinhos xing lings que montamos ou mesmo os notebooks, usam componentes muito mais baratos e menos confiáveis do que você usa num data center. Apesar dos conceitos serem similares, os componentes que você tem acesso não se comparam com os de um data center. Então não é o seu CPU Core i7 ou i9 só que centenas deles num servidor. Nossos componentes de varejo desperdiçam muito espaço físico e são muito pouco confiáveis pra ficar ligados 24 por 7. Servidores sérios usam processadores com dezenas de cores que conseguem ficar ligados meses a fio sem desligar. Inclusive muitos desses componentes podem ter até menos performance se comparado com similares mais baratos que você compra no mercadolivre, mas é o trade-off de sempre: trocamos um pouco de performance por confiabilidade. Aliás, a coisa mais importante no mundo de infraestrutura é confiabilidade e segurança.


Nos anos 90, quando os data centers estavam começando a nascer, não era incomum muitas empresas que queriam ter presença na internet comprar seus próprios servidores ou até mesmo PCs caseiros, contratar a tal internet dedicada que era super caro porque estamos falando de uma época que internet era um troço opcional, a maioria das pessoas sequer usava ainda, e quem usava discava por modem de madrugada pra pagar menos pulsos. Felizmente a Lei de Moore estava no seu período mais acelerado e o início da Bolha da Internet do meio pro fim dos anos 90 acelerou o desenvolvimento da infraestrutura geral. Quando eu estava na faculdade acho que o Brasil tinha tipo uns 3 backbones que ligavam o país com o resto do mundo. Não era incomum ter problema num backbone tipo o da Fapesp e metade do Brasil ficava ilhado do resto do mundo. Era assim rudimentar no começo dos anos 90.


Quando estávamos fazendo os primeiros sites dinâmicos, com ASP ou PHP ou Perl, eu expliquei que o mais popular era rodar algo como Apache com coisas como mod_php ou Windows NT 4 com a primeira versão do IIS pra rodar ASP. Os bancos de dados não eram grande coisa e o mundo enterprise só rodava coisas como Oracle ou IBM DB2. O mundo open source tinha acabado de começar e um MySQL nem podia ser considerado um banco de dados de verdade ainda. O SQL Server estava iniciando depois que a Microsoft adquiriu a Sybase. Então as opções não eram muitas.




Um Apache funcionava inicialmente fazendo fork de si mesmo pra cada nova requisição. As requisições HTTP caíam em algum virtual host. Um virtual host é uma configuração do servidor Web indicando quem vai responder a requisição. Podia ser mapeando a URL pra uma pasta no disco que tem HTMLs estáticos ou podia ser mapeando a URL pra ativar algum programa CGI ou um modulo como mod_perl ou mod_php. Seja no Apache antigo ou num NGINX moderno, você sempre vai estar configurando virtual hosts.


Os virtual hosts ficavam num arquivo de configuração do Apache e toda vez que você mexia nesse arquivo precisava restartar o servidor pra carregar essas configurações e habilitar novos sites. Assim um único servidor Apache podia servir múltiplos sites de uma só vez. Nas faculdades era comum você ter servidores Unix como HP-UX ou Solaris com Apache e cada usuário do UNIX tinha uma pasta onde ele podia jogar arquivos que automaticamente ficavam disponíveis no servidor da faculdade. Com o tempo alguns alunos podiam ter contas nesses servidores e também compartilhar coisas no mesmo servidor. Foi assim que eu comecei a experimentar com web e aprender Unix em 1996.


Entendam que até o fim os anos 80 não era comum uma pessoa ter um computador inteiro só pra ela. Especialmente computadores potentes já que mesmos os caseiros dos anos 80 eram super limitados e fracos. A maioria não era muito mais potente que um nintendinho 8-bits. Por isso os grandes mainframes usavam sistemas operacionais que permitiam o tal time-sharing que já expliquei. E a geração UNIX evoluiu sendo um sistema multi-usuário. Quando nos anos 80 e 90 as comunidades de desenvolvimento quiseram tentar trazer a experiência do UNIX pra plataforma baixa, culminando no Linux, também ganhamos essas características de multi-usuários e multi-tarefa. Ou seja, no mesmo sistema operacional era possível ter múltiplos usuários guardando seus dados e documentos digitais na sua conta e seus programas não afetam o de outros usuários. Já sabemos como o sistema operacional isola os processos de afetar uns aos outros, mas também tínhamos esse isolamento no nível do usuário.


Somado ao fato que servidores sempre foram coisas caras, que o sistema operacional tinha a habilidade de ter múltiplos usuários, e que a maioria dos programas não roda consumindo 100% dos recursos o tempo todo, permitindo multi-tarefa preemptiva, foi natural começarmos a ter PCs montados com Linux, Apache e MySQL preparados pra rodar múltiplos sites de múltiplos usuários tudo na mesma máquina. Quando PHP começou a se popularizar, começaram a surgir vários painéis de gerenciamento pra facilitar cadastrar e gerenciar novos usuários e novos sites, produtos como o famoso cPanel criado em 1996.


Assim começa a era dos servidores corporativos web que sempre foram relegados a um recurso secundário frente aos gigantes ERPs como os da Oracle ou SAP. Pouca gente sabia mexer em Unix ou Linux, então painéis como cPanel tiveram um papel muito importante. Mas algumas pessoas foram um passo além: criaram um modelo de negócios onde era possível qualquer pessoa pagar uma mensalidade e ganhar um usuário numa máquina dessas e uma conta num derivado de um cPanel. Assim eles podiam criar um banco de dados restrito dentro de um MySQL, podiam configurar virtual hosts pros seus sites e podiam hospedar aplicações escritas em CGI com Perl ou PHP que era a opção mais performática. E assim se popularizou a primeira grande stack de tecnologias da web: o LAMP ou Linux, Apache, MySQL e PHP. E com uma stack aceita pela maioria, empresas puderam ser fundadas pra oferecer serviços, e assim começam a nascer as famigeradas hospedagens compartilhadas como as que você vê até hoje em empresas como Locaweb ou Godaddy.


O conceito é simples: dividir os recursos da máquina pra dezenas ou centenas de sites pequenos. Cada site pequeno tem pouco tráfego e só durante algumas horas do dia, então era possível apertar vários deles na mesma máquina. Até hoje temos centenas de milhares de sites funcionando assim. E com isso criou-se um ecossistema de pequenas agências e freelancers que podiam desenvolver esses sites pequenos, e foi assim que a primeira geração de sites começou a expandir rápido.


Por causa disso também, essa primeira geração de programadores se preocupou muito pouco com infraestrutura. Os únicos lugares onde precisava dos tais webmasters ou administradores de sistemas ou o que eu gosto de chamar: sysadmins, eram nas grandes empresas que mantinham seus próprios pequenos servidores, seja localmente no prédio da empresa ou em regime de co-location que era o aluguel de espaço e energia dentro de um data center onde você levava seu PC e instalava na internet dedicada deles, ou mesmo dentro dos provedores que forneciam o serviço de hospedagem compartilhada.


Nessa primeira geração, a segurança ainda era muito ruim. Na verdade, como tudo nasceu dentro de ambientes governamentais ou acadêmicos décadas atrás, você meio que podia contar com uma etiqueta e acordo de cavalheiros. Mas quando esses sistemas passaram a ser expostos na internet, isso abriu a caixa de pandora pra hackers do mundo inteiro começar a brincar. E naquela época era muito fácil hackear os servidores, já que os sysadmins da época sabiam no máximo seguir o procedimento do manual ou dos cursos pra instalar os Linux e cPanel e colocar na internet. E acredite, naquela época ou hoje, só fazer um curso não é 10% do que você realmente vai precisar no mundo real.


Não era difícil achar servidores pelo mundo com porta de Telnet aberta, com usuários sem senha que você podia entrar e vasculhar a máquina e era possível até ver arquivos como /etc/passwd que tinha senhas abertas usando criptografia fraca. Em poucas horas ou dias você podia invadir um servidor. A gente baixava arquivos de senhas de servidores, usava contas em outros servidores pra deixar um programinha de brute force rodando, com rainbow tables que são basicamente tabelas de palavras pré-criptografadas que podíamos só comparar com os valores criptografados nos arquivos de senha, o que é muito mais rápido do que tentar descriptografar. Em outro episódio explico mais sobre isso.


E no lado do servidor web tínhamos um problema. Já sabemos que um Apache funciona fazendo forks de si mesmo ou usando threads. Também sabemos que pra um Apache rodar PHP bastava rodar como CGI ou instalar coisas como um mod_php. Já sabemos como CGI puro é extremamente lento, onde cada requisição precisava subir o binário do PHP, executar o script e terminar. Então a opção do mod_php sempre foi a preferida no começo.


Quando viesse uma requisição, a execução desse script se dava dentro do espaço de memória do processo do Apache. Pelos virtual hosts o processo Apache sabe como responder a requisições de diferentes sites. Embora os usuários no Linux sejam isolados, o processo do Apache é compartilhado, ou seja, o Apache roda com um usuário e grupo, por exemplo chamado “apache”. Daí a pasta na home do usuário precisava dar permissão pra esse grupo e era assim que o Apache acessava os arquivos dos usuários pra servir nos virtual hosts. Entenda que o servidor web é um processo único que ouve na mesma porta 80 pra todo site que ele serve, e coisas como o nome do domínio ou sub-domínio ou sub-pasta é que diferencia de que usuário buscar os html ou php.


E nesse começo de web onde tanto Apache, quanto PHP quando o mod_php eram bem mal feitos, ou melhor dizendo, ingenuamente mal feitos, era muito comum descobrir um bug no num desses componentes que acabava permitindo executar coisas ou acessar dados da memória do processo que o script não deveria. E fazendo isso podíamos de um usuário chegar nos dados de outro usuário usando o Apache como ponte. Hospedagens compartilhadas passaram anos sofrendo desse problema.


Uma forma de limitar esse problema era não executar o php via mod_php e dentro do espaço de memória do Apache inteiro. Foram construídas outras versões do executável do php como o suphp que era servido pelo mod_suphp do Apache, que executava o script como o usuário e não como o apache. Havia a opção de chroot que mudava a raíz do root ou raíz de diretório, de tal forma que o script não conseguisse acessar o root de verdade do sistema e acabar acessando arquivos que não deveria. Depois de várias tentativas ao longo dos anos, no final a opção menos pior era rodar os scripts como FastCGI com a vantagem que diferente de CGI ele mantém o executável rodando, evitando ter que reiniciar toda hora, e ele podia rodar sob a permissão do usuário em vez da permissão mais global do Apache.


Eu expliquei tudo isso pra explicar que nesse período tínhamos um dilema pra resolver: o hardware e internet eram muito caros. Então você queria usar o máximo possível dos poucos recursos disponíveis. Rodar a opção mais performática como mod_php causava problemas de segurança. Mas a opção menos pior que é FastCGI usava muito mais memória porque agora você precisava ter no mínimo uma instância do PHP por usuário com sites. E em ambientes de hospedagem compartilhada você gostaria de minimizar o uso de memória pra enfiar o máximo possível de usuários por servidor. É uma grande dilema e ficamos presos nisso por muitos anos, do fim dos anos 90 e a década dos anos 2000 inteiro.


E isso foi um problema porque pra muita gente, essa foi a escola mais acessível pra aprender sobre web. Você pagava, sei lá, 10 reais, e tinha um espaçozinho pra jogar um site no ar. E você tinha basicamente coisas como ASP clássico e PHP, configurados em algo como FastCGI que significava que seu site era rápido mais ou menos e de vez em quando o servidor precisava matar seu processo FastCGI se tivesse pouco uso, pra conservar memória e deixar outros usuários rodarem, ou seja, de vez em quando sua requisição ficava lenta esperando um novo processo carregar.


Nesse caso você gostaria de fazer apps leves, com pouco código, porque quanto mais código mais demorado ia ficar. E fora isso o único jeito que se tinha na época pra subir suas apps era conectar via FTP e ficar jogando seus scripts php e imagens em alguma pasta do seu usuário onde o virtual host do apache estava configurado pra ler. Além disso você sempre estava limitado à versão do php e bibliotecas do sistema operacional que o provedor de hospedagem compartilhada oferecia. Se precisasse de alguma biblioteca binária compartilhada do sistema, teria que pedir pro suporte instalar pra você, talvez.


Então até a virada do século você tinha a opção barata e ultra limitada de hospedagens compartilhadas ou precisava se virar com seu próprio servidor, seja numa empresa com infraestrutura própria, o que era raro, ou colocando seu servidor em co-locations em data centers. Nesses casos precisava você mesmo configurar tudo manualmente do zero e largar uma porta de telnet, ftp ou ssh abertos pra conseguir conectar de fora via internet, numa época em que internet 24 por 7 ainda não era uma realidade pra grande maioria das pessoas. Nessa época também era muito comum você ter os papéis dos administradores de banco de dados e administradores de rede. 


A partir do ano 2000 algumas linhas de pesquisa e experimentação começaram a dar frutos. Eu falei rapidamente do chroot que era uma forma de limitar até onde no filesystem seus processos poderiam acessar. Um conceito maior se chama “Jail” literalmente prisão e foi no FreeBSD em 2000 que começou a ser possível particionar os recursos do mesmo sistema operacional nessas jails, de forma a isolar os processos, fazendo eles pensarem que estavam sozinhos na máquina, sem ter acesso a outras jails. E ele implementou isso de tal forma que jails podiam ter seu próprio endereço IP separado.


Em 2001 tivemos o Linux VServer, que eram patches na kernel do Linux que permitiam algo parecido com os Jails de FreeBSD pra particionar o sistema. Esse sistema durou até 2006 mais ou menos. Novamente o objetivo era limitar o que um processo pode fazer, que recursos e quais recursos pode acessar, de tal forma que um processo mal intencionado ou bugado não conseguisse derrubar o sistema operacional inteiro.


Quase no fim da sua vida, em 2004 a Sun lançou os containers de Solaris. Em conceitos é também parecido com os Jails de FreeBSD ou o VServer de Linux, criando o que ele chama de zonas, que são restrições ao que se podia fazer no sistema no nível do sistema operacional. Solaris naquela época ainda era uma referência tendo recursos como zonas somado ao lendário filesystem ZFS. E no mundo Linux surgiu algo similar chamado Open VZ, o famoso Virtuozzo.


Jails, Containers, Zonas, nenhum deles é o que a maioria das pessoas pensa quando falamos em virtualização. Tudo isso que eu vou chamar só de containers são basicamente patches na kernel do sistema operacional para possibilitar restringir os recursos do sistema aos processos. Na verdade a gente faz a kernel literalmente mentir pros processos. Se a máquina real tem 10 cores, a kernel mente pro processo e diz que só tem 1 pra ele. Se a máquina tem 64GB de RAM, a kernel mente de novo e diz que só tem 4 GB. Se tem outros 50 processos rodando na máquina, quando o processo pedir a lista, a kernel mente e esconde todos os outros processos. Então o processo é basicamente enganado e a essa mentira da kernel damos o nome de container.


Mas se falarmos de virtualização de verdade, a história vai bem mais longe, pra década de 60 e os mainframes. Como já expliquei, nessa época as máquinas eram proibitivamente caras e inacessíveis e a única forma de múltiplas pessoas conseguirem usar a mesma máquina era aproveitar as diversas pausas que o sistema operacional precisa fazer como esperar um arquivo gravar ou dados serem transferidos na rede e aproveitar pra computar outra coisa de outro usuário, o conceito de time sharing. Mas os pesquisadores de mainframe foram um passo além. Quando as máquinas começaram a ficar mais poderosas, eles começaram a particionar a máquina pra rodar mais de uma kernel de cada vez, essencialmente tendo múltiplos sistemas operacionais rodando em paralelo. 


No caso de mainframes, cada máquina virtual tinha acesso a recursos reais próprios como canais de I/O, dessa forma eles são extremamente eficientes. Nos anos 80 era praticamente impossível falar de virtualização nos computadores caseiros de 8 ou 16 bits. Simplesmente não havia nem poder computacional e nem recursos suficiente pra se pensar em rodar múltiplos sistemas operacionais na mesma máquina. Não tinha recurso suficiente male male pra rodar 2 programas de uma só vez.


Nos anos 90 começamos a brincar mais com esse conceito à medida que as máquinas foram ficando mais poderosas e mais acessíveis. Pense que no fim dos anos 80 as máquinas mais poderosas do mundo doméstico tinham 33Mhz e no fim dos anos 90 estávamos pra quebrar a barreira do 1Ghz. Ou seja, em uma década o poder computacional teórico ficou 30 vezes maior a um preço similar. Além disso nos anos 90 tivemos o nascimento do Linux o que abriu as portas pra desenvolvedores poderem experimentar os conceitos que já existiam no mundo dos mainframes na plataforma baixa.


O conceito é razoavelmente simples. Todo processo faz as tais syscalls como já expliquei. Além disso processos normais rodam num ambiente mais restrito, o tal Ring-3 que também já expliquei antes. Ou seja, um processo no Ring-3 não tem permissão pra chamar funções da CPU que só a kernel no Ring-0 tem acesso. Porém, e se fizéssemos um programa especial que por sua vez carrega seus programas? E se esse programa especial respondesse a syscalls restritas mentindo as respostas? O conceito todo de virtualizar é responder uma mentira. Por exemplo, se você tentar carregar uma kernel no Ring-3 ela não vai funcionar porque vai querer fazer chamadas de Ring-0 pra acessar o hardware real, que não existem na Ring-3.


Mas se esse programa especial responder a essas chamadas e mentir, a tal kernel no Ring-3 ou user land vai “acreditar” que está com acesso à máquina real. Fazendo uma tangente na filosofia isso me lembra o demônio malicioso de Descartes ou a Alegoria das Cavernas de Platão ou simplesmente o experimento do cérebro no jarro. Nosso cérebro é como se fosse um computador, e seu I/O ou input e output são nossos 5 sentidos, o tato, audição, visão, paladar e olfato. Nosso corpo humano funciona como os teclado e mouse desse computador. E se fosse possível tirar o cérebro do nosso crânio e colocar num jarro. E agora fosse possível ligar o I/O do cérebro ao de um computador, mandando sinais elétricos criados por esse computador.


Para o cérebro, se os sinais fizerem sentido, ele não tem como saber que não está num corpo humano de verdade, ele “acredita” que tem um corpo, só que virtual. Nós poderíamos criar mentiras no computador e enviar esses sinais direto pro cérebro. Poderíamos inventar que estamos no Havaí e mandar as imagens do cenário de praia, o cheiro da água do mar, a brisa batendo na pele, a barulho das águas batendo nas pedras e pra todos os efeitos o cérebro vai acreditar que está no Havaí. E é exatamente isso que fazemos com o tal programa especial, ele vai mentir pro processo que é o cérebro e o processo vai acreditar que está onde esse programa especial disser que ele está.


O sistema operacional, pra todos os efeitos e propósitos, é um supervisor de processos. Ele é responsável por gerenciar os recursos da máquina e tornar esses recursos disponíveis pros processos da forma mais eficiente possível. Se o sistema operacional é um supervisor, o que seria um supervisor de um supervisor? Que tal um hyper visor? E é isso que o tal programa especial que eu falei é: um hypervisor.


Temos 2 grandes tipos de hypervisors, o tipo 1 que seriam instalados no bare metal, ou seja, na máquina real de verdade, antes do sistema operacional. Exemplos disso são o VMware vSphere, Citrix XenServer, ou Microsoft Hyper-V. Os hypervisors tipo 2 são os que rodam por cima do sistema operacional, como um programa normal, por exemplo os Virtualbox, VMware Workstation, Parallels Desktop, QEMU.


No lado do mainframe o tipo 1 já era comum nos anos 90, mas nos computadores domésticos começamos a explorar o tipo 2 primeiro já que era o mais simples de fazer. Basicamente simular uma CPU em software, um programa especial que responde a syscalls da Ring-0, mentindo pros outros programas. Se você prestou atenção nos episódios anteriores, sabe que fazer syscalls da Ring-3 pro Ring-0, passando de userland pra kernel-space toda hora é uma coisa custosa. E como você está simulando os recursos da máquina, vai precisar toda hora se comunicar com o sistema operacional pra efetuar a operação de verdade. Portanto é impossível simular um Pentium de 100Mhz em cima de um Pentium de 100Mhz. Talvez você consiga simular um Pentium de 10Mhz em cima de um Pentium de 100Mhz. Quando você virtualiza a CPU inteira e roda outro sistema operacional inteiro por cima, você ganha o peso de dois sistemas operacionais inteiros: o Guest ou convidado que é a kernel enganada, e o Host ou hospedeiro que é o sistema de verdade por baixo e entre eles você tem o programa especial, o Hypervisor Tipo-2. É bastante peso.


Em 1999 tivemos dois grandes lançamentos que eu acho interessantes: estávamos vendo o nascimento da VMWare trazendo produtos pra virtualizar um Linux em cima do Windows ou vice versa, virtualizando o sistema operacional: um hypervisor tipo 2. E em paralelo víamos o lançamento de um dos filmes mais influentes daquela geração que foi Matrix. Basicamente a Matrix virtualizou nosso mundo, eu poderia dizer que a Matrix era um hypervisor tipo 1, que podia rodar um sistema operacional chamado “mundo real”. E do jeito como eu gosto de pensar, também rodava Zion. Só que havia backdoors entre os dois mundos, então era um hypervisor com bugs propositais e os processos podiam atravessar entre os dois sistemas virtualizados. 


Deixando a nerdice de lado um pouco, a diferença entre os containers como os Jails de BSD ou OpenVZ é que você rodava os processos de forma restrita e isolada mas todos no mesmo sistema operacional. A vantagem da virtualização com hypervisors era recriar uma máquina virtual literalmente, onde um novo sistema operacional podia ser instalado e os programas rodam como se estivessem numa máquina de verdade. Obviamente a primeira solução é muito mais rápida, mas se você quisesse rodar um programa de Windows em cima de um Linux, isso só seria possível simulando o hardware, mas ao mesmo tempo seria extremamente lento.


Simular uma máquina inteira do zero é o que chamamos de Full Virtualization, ou seja, do ponto de vista do sistema operacional ele está na Matrix, ele não tem como saber que a máquina por baixo não é de verdade já que o hypervisor está mentindo nas syscalls pra ele. Só que a vida de um mentiroso é muito difícil, como já diria o senso comum. Você não devia mentir sozinho, em vez disso, podemos fazer um conluio, uma conspiração mesmo. No fim basta o processo rodando acreditar que está numa máquina de verdade. Então poderíamos modificar o sistema operacional pra só ele saber que está numa máquina virtual, criando um acordo entre ele e o hypervisor. Então nas syscalls mais difíceis de mentir, o sistema operacional pede ajuda direto pro hypervisor e assim as coisas ficam mais rápidas. No caso criou-se um padrão de interfaces do hypervisor que o sistema operacional tinha conhecimento. Versões de Windows e Linux foram modificadas diretamente pra acessar essas APIs e a isso demos o nome de Paravirtualização. 


Mas o problema é conluios dependem das duas partes fazerem sua parte na mentira, e nesse caso você não podia instalar qualquer sistema operacional de qualquer versão nesses hypervisors de paravirtualização como o Xen. O sistema operacional precisava saber mentir e ter patches pra participar do conluio. A VMware tinha o padrão Virtual Machine Interface ou VMI que por um tempo passou a vir na kernel do Linux. Mas ela foi removida por conta do próximo grande acontecimento a partir de 2005 e 2006.


Ao mesmo tempo quase, de forma independente, a Intel e a AMD resolveram estender o conluio pra dentro do hardware da CPU. No final, é muito lento deixar o hypervisor mentir sozinho, mas se a CPU participar da mentira, ela se torna quase tão rápido quanto a verdade. A AMD lançou extensões às instruções binárias da CPU que chamou de AMD-V e a Intel lançou a mesma coisa mas chamando de VT-X, parece mentira mas são apenas 10 novas instruções que fazem o sistema operacional virtualizado achar que está na Ring-0, que é todo o objetivo dos esforços de virtualização. Essas 10 instruções aqui embaixo 
(VMPTRLD, VMPTRST, VMCLEAR, VMREAD, VMWRITE, VMCALL, VMLAUNCH, VMRESUME, VMXOFF, and VMXON)


Essa evolução dos processadores funcionou tão bem que a performance de muitas aplicações chegou a aproximar a performance nativa sem virtualização em alguns casos. Foi em 2005 que as plataformas baixas finalmente chegaram mais próximos dos mainframes dos anos 70 que rodavam sistemas como o System/370. 


Vamos recapitular, no meio da primeira década dos anos 2000 já começamos a ter hypervisors tipo 1 que podia rodar múltiplos sistemas operacionais em paralelo no bare metal. E também tínhamos a opção de hypervisors tipo 2 pra rodar um sistema hospedeiro leve e por cima dele rodar múltiplos sistemas operacionais também. Isso começou a se tornar extremamente importante pra data centers onde os servidores sempre foram difíceis de dar manutenção e dividir os recursos entre diferentes aplicações, de diferentes clientes, rodando na mesma máquina, com segurança e performance. Com as novas instruções VT-X e AMD-v dando performance suficiente, começou de fato o mercado de virtualização da infraestrutura.


De qualquer forma, voltando aos servidores dava trabalho montar um servidor novo. Houve uma época que se eu precisasse de um servidor, eu tinha que abrir uma ordem de serviço no data center da empresa ou do provedor. Eles iam levar 1 ou 2 dias, pra reservar um hardware, instalar e configurar um sistema operacional, ligar monitoramento, conectar na rede e deixar disponível pra mim. E essa máquina ia ficar a maior parte do tempo sem fazer nada, e mesmo quando estivesse fazendo nunca ia usar todos os recursos ao máximo. Por isso era tão caro: pra provisionar era caro, e a máquina era um grande desperdício na maioria do tempo.


Os VPS ajudaram a aliviar esses dois problemas. Como os hypervisors podem ser automatizados, agora bastava instalar o sistema operacional uma vez e fazer um snapshot, ou seja copiar os dados que compõe a instalação num arquivão, e a isso chamamos de Imagens. Como as máquinas são virtuais e são sempre as mesmas, as imagens são sempre compatíveis sem problemas de coisas como drivers. Quem tinha que se preocupar com drivers e hardware que podia mudar (tipo quando trocávamos uma placa de rede com defeito) era o sistema hospedeiro ou o hypervisor tipo 1, ou seja, só quem roda em bare metal. Portanto, via uma interface web simples e passando um número de cartão de crédito, em poucos minutos eu podia ter uma máquina virtualizada ligada na rede pronta pra usar. Foi uma evolução impressionante no começo dos anos 2000.


Tudo isso ajudava uma pessoa a criar uma máquina, mas ainda não ajudava tanto as grandes empresas que precisavam controlar coisas realmente complexas e distribuídas com múltiplos servidores. Quando era só uma máquina, alguém da empresa entrava nela de vez em quando pra ficar dando manutenção, instalando coisa nova e rodando atualização. Mas se você tinha 5, 10 ou 100 máquinas, precisava de uma equipe inteira pra ficar manualmente atualizando o sistema ou consertando problemas. Era tosco lidar com equipes de TI fazendo tudo na mão nessa época. A Microsoft tinha serviços no Windows Server pra tentar automatizar as coisas, mas vou te dizer que ter que lidar com Active Directory sempre foi um pé no saco e é até hoje uma das tecnologias que eu mais detestei ter que lidar, era tipo uma extensão do Registry pra servidor, ambas que só dão dores de cabeça. Eu entendo os motivos e a utilidade, mas continua sendo uma das soluções com a pior usabilidade desde a época dos mainframes.


Uma outra categoria de software começou a surgir, principalmente a partir de 1993 quando foi lançado pela primeira vez, ou a partir de 1998 quando saiu a versão 3 do software conhecido como CF Engine. Qualquer administrador de sistemas Linux trabalhando com vários servidores, por exemplo nos provedores de hospedagens compartilhadas como eu expliquei, usaram CF Engine 3 em algum momento. Claro, a maioria não sabia o que era isso porque as pessoas têm a tendência de não estudar ou querer fazer coisas complicadas repetidas vezes pra mostrar manja. Mas os realmente bons são preguiçosos: nós não gostamos de fazer a mesma coisa repetidas vezes e preferimos fazer um software pra fazer as coisas chatas por nós. CF Engine é isso: um estagiário de administrador de sistemas que tem as receitas pra instalar a mesma máquina do mesmo jeito todas as vezes, num único comando.


O CF Engine funciona com uma linguagem declarativa que descreve uma promessa. Na prática é a descrição do que o servidor deveria ter instalado (os diversos pacotes e binários) e como esses componentes deveriam ser configurados (ordens pra editar os arquivos de configuração como os que ficam no famoso diretório /etc) e quais serviços deveriam ser inicializados pelo systemd logo que a máquina inicia. O CF é um automatizador, em vez de você ter que entrar máquina a máquina e ficar digitando dezenas de comandos pra fazer tudo isso, e ficar esperando comando a comando executar; você instala no máximo um sistema operacional zerado, instala o agente do CF e faz ele conectar no servidor de CF. De lá o servidor por enviar essas promessas pra nova máquina e fazer tudo que precisa pra que fique do jeito que você precisa.


Avançando rapidamente na história, na sequência tivemos o Puppet lançado em 2005 e escrito em Ruby, o que possibilitou usar as capacidades de criar sub-linguagens, que chamamos de DSLs ou Domain Specific Languages pra criar o equivalente das promessas de CF. Em 2009 também em Ruby tivemos o lançamento do Chef que é o motor de produtos como o AWS Opscode por exemplo. 


A grande vantagem de sistemas como CF Engine, Chef ou Puppet é descrever infraestrutura como código. Dessa forma, se os pré-requisitos fossem os mesmos, você podia não só mandar rodar a mesma receita várias vezes e garantidamente ter a mesma máquina no final como podia compartilhar essas receitas da mesma forma como compartilhamos código open source e a comunidade podia ajustar essas receitas, fazendo ficar melhor do ponto de vista de minimizar as coisas que eram instaladas ou como melhorar as configurações pra ficar mais seguras. Em vez de todo administrador de sistemas ter que reinventar a roda do zero, podia já partir de uma base comum.


Sistemas como o CF, Puppet ou Chef seguem uma arquitetura de cliente-servidor onde as novas máquinas ganham agentes que são processos que ficam rodando e escutando ordens vindas de um servidor. Assim era mais simples provisionar novas máquinas, bastava que no processo a imagem do sistema operacional viesse com o agente e quando ela plugasse na rede podia ser vista pelo servidor e iniciar o processo de enviar as receitas pra instalar o que fosse necessário. Uma coisa que muito iniciante reclamava e ainda reclama é que esses sistemas tinham pelo menos 2 componentes: os agentes e o servidor, então tinha bastante coisa pra configurar antes de ter a primeira máquina automaticamente configurada. Se seu trabalho era configurar dezenas de máquinas, tudo bem, mas se você só queria configurar uma única máquina, era mais trabalho do que você gostaria de ter.


Antes desses sistemas ficarem mais populares o mais comum era algum estagiário manualmente instalar o sistema operacional, configurar a rede e plugar a máquina rede, deixando pelo menos o Telnet ou mais recentemente o servidor de SSH configurado. Pra quem não sabe, a porta 23 sempre foi do Telnet que é uma forma de acessar o terminal do servidor remotamente. Telnet é o teletype network e na prática você podia se logar remotamente da sua máquina num servidor Unix ou Linux. 


Esse protocolo é antigo, do fim dos anos 60 então quando a internet começou a se popularizar ficou bem claro que era muito inseguro. Se você não sabe disso é muito simples fazer uma coisa chamada sniffing que é ouvir os pacotes TCP trafegando na rede e ver o que tem dentro deles, se o dado estiver aberto você pode facilmente interceptar e ler esses pacotes. Protocolos de TCP como Telnet, FTP, SMTP, HTTP todos são muito fáceis de sniffar e por isso viemos gradativamente substituindo o uso deles por outros mais seguros como o SSH, SFTP, SMTP com TLS, e HTTPS. SSH que todo mundo conhece hoje em dia e é exposto na porta 22.


Assim como Telnet, você pode abrir um terminal remoto interativo via SSH e ficar digitando comandos manualmente. Ou você pode automatizar o SSH e usar ele como um túnel. Ou seja, você pode criar um programa que envia comandos ao cliente de SSH sem que você precise abrir o terminal interativo; como um programa de linha de comando. Em cima desse conceito, podíamos criar arquivos de texto com vários comandos que queremos rodar no servidor. O SSH funciona também pra transferir arquivos de forma encriptada como um FTP melhorado. Então podemos mandar um script de comandos pro servidor e depois mandar executar esse script no servidor.


Se você pensou 2 segundos, isso possibilita outra coisa: automatizar a instalação e configuração de novos servidores. Todo novo sistema operacional de servidor que se preza já deixa pré-instalado um servidor como o OpenSSH. Com CF, Chef ou Puppet precisamos deixar também instalados os seus programas agentes. Mas só com SSH já dá pra fazer muita coisa. E assim em 2006 surge outra ferramenta do mundo Ruby, o Capistrano que antes se chamava SwitchTower. É um sistema de deployment sem agentes ou agentless. O agente no caso seria o próprio servidor de SSH. Com comandos simples você pode instalar sua aplicação em múltiplos servidores, configurados todos iguais porque você estava automatizando os mesmos comandos pra rodar em todos eles, e de quebra ele podia também configurar seu servidor de banco de dados, seu balanceador de carga e tudo mais, com a vantagem de ser mais simples que CF ou Puppet.


Se você que começou nos anos recentes pensa que o Ansible que foi lançado em 2015 foi uma grande novidade, na verdade ele foi só uma evolução do Fabric de Python que saiu antes dele e que por sua vez foi um clone de Capistrano. Em linhas gerais temos os gerenciadores de configuração de infraestrutura, mais complicados, que são cliente-servidor como CF, Puppet e Chef e os que são mais simples e agentless como Capistrano e Ansible. Eu diria que ambos servem propósitos diferentes pra públicos diferentes. Se você é um desenvolvedor de aplicações web que precisa subir uma aplicação simples numa máquina virtual num VPS e depois conseguir fazer deployments automatizados rápidos das atualizações e correções, você deveria usar Ansible.


Por outro lado, se você precisava manter 10 máquinas web, 3 máquinas de bancos de dados, 1 servidor de cache e coisas assim, era melhor organizar sua infraestrutura em conjuntos de receitas usar coisas como Chef pra criar e atualizar essas máquinas. As pessoas pensam que infraestrutura é só instalar a máquina, colocar na rede e acabou. Longe disso, você precisa atualizar o sistema operacional com correções de segurança, você precisa subir atualização das aplicações que rodam nelas. Mais importante: se uma máquina é invadida ou mesmo dá algum problema inexplicável, não vale a pena tentar consertar, você precisa preparar a arquitetura pra que seja possível destruir a máquina por completo e recriar uma nova pra colocar no lugar. Manualmente é um trabalho de corno e você vai errar muitas vezes esquecendo de instalar ou configurar alguma coisa, mas automatizado você sempre garante que a máquina vai ser montada da forma certa.


Essas ferramentas de automatização não só precisavam instalar máquinas mas também precisavam garantir que as premissas de segurança estão sendo cumpridas. Que as políticas certas estão aplicadas, que as permissões certas de usuários foram feitas, que as máquinas estão nas vlans corretas e que as regras de firewall também estão corretas. Esse conhecimento veio sendo automatizado também.


Agora pense assim, o começo do século XXI foi extremamente caótico com a bolha da internet que explodiu em 2001. Passamos uns 2 ou 3 anos de depressão, sem nada muito interessante realmente acontecendo. Mas então a controvérsia do Napster vs a indústria da música, o lançamento do iPod e iTunes, começou a trazer o entretenimento de massa pra internet, bandas independentes começaram a se lançar via internet e a hegemonia da MTV como influenciador começou a desaparecer quando as redes sociais de primeira geração, como MySpace, começaram a tomar a internet de assalto. Se você não tem noção desse efeito pense que em 2006 MySpace foi mais visitado do que o próprio Google, consegue imaginar isso?


Já em 2008 o Facebook destronou o MySpace, então imaginem dois titãs em disputa. 2008 que eu já expliquei que foi a época da maior crise econômica dos tempos modernos mas no lado da internet as coisas estavam esquentando absurdamente, principalmente em Silicon Valley. Foi em 2005 que o Netflix pivotou pra oferecer vídeo streaming em vez de entregar DVD, foi em 2006 que o Google comprou o YouTube, em 2007 que nasceu Twitter, em 2008 que Facebook despontou como a liderança das redes sociais, também em 2008 que a Apple inaugurou o iPhone App Store, em 2009 que surgiu o Uber, em 2010 que surgiu o monstro Groupon, que já praticamente morreu. Ou seja do meio pro final dos anos 2000 tivemos uma aceleração abrupta que não se via desde o fim dos anos 90. E é por isso que esse foi o período que mais tivemos evolução nas tecnologias.


Diferente dos anos 90, agora estávamos num ponto onde as pessoas comuns já tinham acesso à internet em casa e partir dos anos 2010 começamos a colocar a internet no bolso das pessoas, acesso de qualquer lugar, a qualquer momento. E com o advento dos smartphones e das redes sociais criamos uma massa gigantesca de pessoas que querem ficar online o tempo todo, e mesmo tendo coisas como ecommerce antes, a escala que os unicórnios atingiram exigiam muito. Ecommerces tem horário e dias pra picos. Redes sociais tem picos o tempo todo. Instalar máquinas na mão dentro de uma Netflix seria completamente inviável. Por isso muitas das novas tecnologias vieram exatamente desses unicórnios. Pra piorar a partir de 2011 ainda começamos a adotar mais e mais tecnologias que ajudavam a manter as pessoas online mais tempo, como WebRTC pra comunicações e WebSockets.


Até então a internet era feita pra ser desconectada. Você podia carregar um site com seus conteúdos, desconectar da internet e continuar lendo. Não era prático, mas o protocolo HTTP foi feito pra não ter estado. Você baixa, renderiza no navegador e acabou. Mas com WebRTC e WebSockets você passou a gerenciar estados e precisa estar online pra tudo funcionar, coisas como Messenger, Slack, Whatsapp, só fazem sentido num ambiente onde as pessoas estão online ao mesmo tempo na maior parte do tempo.


Entenda uma coisa importante: a grande maioria das boas práticas e recomendações que você vê na internet hoje vinda de engenheiros de um Netflix, de um Twitter, de um Facebook, ou de um Google, só fazem sentido pra eles na maior parte do tempo. Ouça isso com muita atenção: você não é o Netflix, tá muito longe. O Netflix levou anos pra ser o Netflix. Os unicórnios são chamados de unicórnios porque são quase impossíveis se você tentar replicar e precisam de vários fatores incontroláveis incluindo estar no lugar certo na hora certa, pra acontecer. Portanto não é porque você usa uma tecnologia do Google que vai te levar um pouco mais próximo de ser um mini Google. Não existe correlação, esqueça essas fantasias.


Portanto não, você não deveria usar um Apache Mesos, tecnologia criada pelo Twitter, na sua infraestrutura de 3 máquinas na sua micro-empresa que você gosta de chamar de tech startup. Toda vez que você ouvir o argumento “devíamos usar isso porque o Twitter usa” ignore completamente essa pessoa, ela não tem idéia do que está falando e é uma pessoa perigosa.


Isso tudo dito o fato é que de repente começaram a surgir empresas que estavam escalando absurdamente rápido num ambiente onde a maioria dos data centers disponíveis não sabiam como atender essa demanda. Era muito demorado manualmente instalar e configurar máquinas. Mesmo com ferramentas como CF, Chef eles estavam atingindo limites. Pense assim: num ambiente cliente e servidor, onde de repente você tem mil máquinas batendo num servidor de configurações como o CF e você vai engargalar a rede se precisar baixar um binário grande pra mil máquinas na rede interna, vai começar a engargalar o servidor de configurações. Novas arquiteturas precisaram ser criadas. 

Estamos chegando na era mais acelerada do mundo de infraestrutura web que eu argumentaria que foi a partir de 2006 até pelo menos 2015. Se você acompanhou os últimos episódios sabe o quanto de coisas saiu nessa década e se não assistiu agora é a hora de ver porque chegamos ao final deste episódio. No próximo episódio quero contar como as tecnologias que mencionei hoje vão culminar em coisas como Docker ou Kubernetes que você tanto ouve falar em tudo que é blog ou evento de tecnologia.


Eu espero que vocês tenham ganhado um contexto melhor quanto ouvirem sobre essas tecnologias. Eu falei de muitos conceitos então é natural que vocês tenham dúvidas, não deixem de mandar nos comentários pra galera poder ajudar também. Se curtiram o vídeo mandem um joinha, compartilhem com seus amigos, assinem o canal e não esqueçam de clicar no sininho pra não perder os próximos episódios. A gente se vê semana que vem, até mais!

