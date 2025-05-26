---
title: "[Akitando] #34 - Você não sabe nada de Enterprise. Conhecendo a SAP!"
date: '2018-12-26T17:00:00-02:00'
slug: akitando-34-voce-nao-sabe-nada-de-enterprise-conhecendo-a-sap
tags:
- sap
- netweaver
- hana
- s/4
- r/3
- hasso platner
- larry ellison
- oracle
- adabas
- ibm
- accenture
- pwc
- capgemini
- xerox parc
- mainframe
- erp
- enterprise
- corporations
- consultor
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


<iframe width="560" height="315" src="https://www.youtube.com/embed/FXhcfJnlD2k" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


### Descrição no YouTube

Certamente ninguém ia ver video ontem, então fica meu presente de natal hoje mesmo :-) (26/12)

Finalmente, um dos episódios mais longos da minha carreira. Vamos entender um dos mercados menos compreendidos por toda a comunidade de programação. 

Quase nenhum programador de agência, startup, tem idéia do que realmente é o tão temido mercado "enterprise". 

Então em vez de ficar falando mal sem saber, vou explicar o que diabos realmente é a SAP, tanto do ponto de vista de história quanto tecnologias.

## Script

Olá pessoal, Fabio Akita

Finalmente chegou o dia de eu contar uma das minhas histórias mais longas. Eu falei um pouco no vídeo de "O que estudar" sobre o que é ser um consultor. Então HOJE eu quero explorar mais sobre isso e também sobre um mercado que a grande maioria das pessoas não conhece: o famigerado mundo Enterprise, mais especificamente a vertente da SAP que eu conheci no começo dos anos 2000.

Eu já falei algumas vezes de quando eu estava trabalhando na ponto com PSN que fazia sites de esportes na América Latina. Todo mundo sabe que em 2001 a bolha das ponto com estourou com força, muitos acharam que a internet ia até acabar e eu estava numa dessas ponto com. De repente eu estava na rua, mas não por muito tempo. 

Exatamente na semana que tudo explodiu eu recebi uma ligação, meu amigo e mentor Antélio Abe, que eu tinha conhecido anos antes lá por 1997 quando estava trabalhando pela minha agência num projetinho de intranet pra Camargo Corrêa. Em 2001 ele tinha saído da Camargo e estava numa pequena consultoria enterprise chamada Balance e eles estavam precisando de alguém que entendesse de tecnologias Web, coisa que ainda era meio alienígena no mundo enterprise. Ele me ofereceu pra aprender esse tal de SAP, e eu pensei, "por que não?"



(...)



Pra fazer esse episódio eu pedi ajuda de novo pro Antélio e somado com o que eu lembro, vou tentar organizar algumas informações que podem ser interessantes. Pra vocês entenderem o Antélio é um consultor “asterisco”, coisa rara quando um consultor é bom em múltiplos módulos funcionais de um ERP. Ele já participou de grandes projetos em empresas como Monsanto, Telemar/OI, Claro, Diageo e dezenas de outras.

Vamos dar uma recapitulada. Embora a SAP não seja nem de longe do tamanho do market cap de uma Microsoft, Google ou Apple, ela está instalada no coração das maiores empresas do mundo. Uma hipérbole que acho que não está muito longe da realidade é que eu digo que pra entender SAP, pegue a lista das 500 maiores empresas do mundo. Eu poderia apostar a maioria, ou quase todas, rodam soluções da SAP no seu backend.

SAP SE significa, do alemão pro inglês, Systems, Applications & Product in Data Processing. Seu quartel general é em Walldorf na Alemanha com escritórios em 180 países e mais de 335 mil clientes. Sua gestão já foi muito centralizada, mas agora está espalhada pelo mundo inteiro, conseguindo suportar clientes 24x7 em qualquer fuso horário.

Em 2017 a receita da SAP foi de mais de 23 bilhões de dólares com lucro de mais de 4 bilhões. Ela tem quase 100 mil funcionários pelo mundo. Dentre as principais figuras da SAP ainda está um de seus co-fundadores, Hasso Platner. Não sei se ainda hoje é assim mas Hasso sempre foi o arqui-inimigo de outro titã do mundo enterprise, o famigerado Larry Ellison, da Oracle. Diz uma lenda urbana que eles disputaram uma corrida de iates e quando o Hasso passou na frente abaixou a calça e mostrou a bunda pro Larry. :-D

(aham) Uma curiosidade é que todo mundo se lembra do lendário laboratório da Xerox Parc, que foi a semente da revolução dos micro computadores dos anos 80, a fonte onde tanto a Apple quanto a Microsoft beberam para sair com coisas como o mouse e a interface gráfica. Mas além deles a Xerox ainda ia deixar outro legado pra indústria.

Segundo nossa amiga Wikipedia, a Xerox estava querendo sair da indústria de computadores até 1975 e pediu à IBM para migrar seus sistemas de negócios para tecnologia IBM. Então, cinco engenheiros da IBM que estavam trabalhando no software do sistema enterprise e lhes foi dito que esse software não seria mais necessário. Em vez de jogar tudo fora, eles decidiram sair da IBM Tech e começar outra empresa.

SAP é mais um dos casos em que o nome da empresa sobrepõe ao nome de seus produtos e sistemas. O nome da empresa inicialmente foi System Analysis and Program Development ou SAPD e seu primeiro cliente foi a Imperial Chemical Industries em Ostringen onde fizeram o software de folha de pagamento de contabilidade para mainframe. Mas em vez de guardar os dados em cartões perfurados como a IBM fazia na época, eles armazenavam locamente num banco de dados lógico. Por isso chamaram o sistema de "real-time" e é de onde vem a letra R do principal sistema integrado deles que, em 1973, foi lançado como R/98.

Em 1979 lançaram o SAP R/2 estendendo para outros módulos como gerenciamento de materiais e planejamento de produção. Daí, do mainframe eles pularam pra arquitetura cliente/servidor nos anos 90, o que chamávamos de arquitetura em 3 camadas, e com isso o nome foi de R/2 para R/3 em 1995.

No Brasil algumas das primeiras instalações de SAP foi na Dow Química e Dupont, ambas usando o R/2 de mainframe que serviriam de base para construção da localização Brasil. Em termos de SAP, localização envolve não só o óbvio que é traduzir todos os textos do sistema em português, mas também a Tropicalização que envolve regras de negócio específicas do nosso país como as regras tributárias, fiscais, CLT e tudo mais.

A primeira instalação do SAP R/3 no Brasil foi na Philips, que veio via a consultoria francesa Atos Origin que por si só tem uma história interessante, sendo originada do merge de duas empresas francesas e da holandesa Origin. Foi adquirida pela KPMG em 2002 e depois a Atos Origin anunciou a compra da Siemens IT que foi finalizada em 2011 sob o nome só de Atos.

Enfim, no Brasil a Atos Origin tinha sede onde hoje é o prédio da Locaweb em São Paulo. A própria Origin foi tipo uma spin off da área de TI da Philips e quem passou a representar a SAP no Brasil.

Uma coisa que vocês devem ter ouvido falar que aconteceu no fim dos anos 90 foi a corrida desenfreada pelo Bug do Milênio. Eu lembro disso porque eu mesmo trabalhei consertando esse bug em 1999, mas isso pode ser história pra outro dia. De qualquer forma as empresas baseadas em Mainframe analisaram a possibilidade de implementar SAP. Já que ia precisar lidar com o tal Bug do Milênio já aproveita pra substituir o legado por SAP.

Mas aí começou um empurra-empurra entre a então SAP AG da Alemanha e a Origin pra investir na localização Brasil. Ou seja extrair o que se tinha na Philips como um conjunto reusável de templates e customizações para ser o scaffold pra novas instalações. Vou mencionar localização depois mas entenda que isso não é uma coisa barata de fazer. Com esse impasse as multinacionais ameaçaram desistir da SAP, o que forçou a SAP a abrir a SAP Brasil e colocar a Origin de escanteio.

Durante a virada do século, eu vi uma das grandes transições da SAP, do mundo client/server para integrar tecnologias Web. Esse era um dos meus trabalhos. Na minha época estávamos no R/3 versão 4.6c.

Eu costumo explicar o R/3 da seguinte forma: comece imaginando uma máquina virtual, como um JVM. Essa camada parasita e se sobrepõe ao sistema operacional e também ao banco de dados relacional por baixo, como Oracle, DB/2 ou SQL Server. 99% dos consultores não sabem se é um UNIX ou um Windows ou o que rodando, eles só viam o R/3.

Essa máquina virtual é tão completa que ela abstrai o banco de dados relacional inteiro, incluindo a linguagem de acesso, permissões, schemas, dicionário de dados, e todas as ferramentas de administração. Essa é a camada que chamávamos de "Basis", em linguajar do mercado o cara de Basis costuma ser tipo o sysadmin ou devops nos dias de hoje. E você acha que já viu banco de dados grande? Não, na minha época uma instalação padrão já pré-configurava mais de 40 mil tabelas (acho que hoje já é dobro disso). 

Pense tabelas cujos nomes são acrônimos de palavras em alemão, então você tem tabelas como VBAK e VBAP pra cabeçalho de ordem de venda e ítens. Você em BUKRS pra código de empresa. Ou LIFNR pra fornecedor e assim por diante. Depois de algum tempo você decora muitos acrônimos, é bizarro que mais de 10 anos depois eu ainda lembro de muitos de cabeça.

Os acrônimos originalmente deveriam ser curtos: 4 caracteres para tabelas e 5 caracteres para nomes dos campos, tudo isto para economizar espaço em memória e banco de dados, afinal de contas em 1997 em pleno boom de SAP R/3 o processador mais top na época é um Pentium-II, sistemas unix mais fortes rodavam em 32 bits.

Na minha época havia o minisap que era só a camada Basis com as ferramentas de ABAP mas sem os módulos funcionais. Era mais pros sysadmin e devs poderem ter um sandbox pra brincar e treinar. Ainda existem versões mais novas disponíveis no SAP Trials, acessivel pra quem tem conta na SCN a SAP Community Network, qualquer pessoa pode-se increver, vou explicar isso mais abaixo. Mas pra entender, sem os módulos funcionais, ainda assim pesa nada menos que 15GB pra baixar e precisa de no mínimo 4GB de RAM e 100GB de HD pra instalação. ??? Existem algumas versões alternativas que podem ser instaladas via docker, mas ainda precisam do mesmo espaço → bizarro 

Sobre essa máquina virtual roda uma linguagem proprietária chamada ABAP que é um acrônimo em alemão absurdo que significa "general report creation processor" ou processador de criação de relatório gerais. Ou seja, em muitos aspectos não é muito diferente de um PL/SQL da Oracle ou T-SQL do SQL Server, mas como linguagem ela é bem mais completa e hoje em dia tem recursos como orientação a objetos.

Como gerador de relatórios e também de formulários existe ainda o SAP GUI que é um cliente burro. Via ABAP eu posso construir telas e o que é mandado para o client são as instruções de como desenhar essa tela. Do lado cliente não roda nenhuma lógica de negócio, só lógica de apresentação. Você usa um derivado desse conceito todo dia: o navegador web, que é só um cliente burro que não roda nada e recebe instruções pra desenhar a tela. Pelo menos era assim até embutirem tanto Javascript … enfim, o SAP GUI é o navegador.

(telas)
Por exemplo, esta é a tela de Login, o SAP Logon, vc pode cadastrar login pra vários SAP.
Aqui você ver o Easy Access, os menus pra acessar os programas ou transações, mas na prática ninguém usa isso, todo mundo sabe o código da transação e digita direto. E código de transação é um acrônimo em alemão, SE80 por exemplo é o Object Explorer.

Sobre esse runtime você tem as ferramentas de desenvolvimento, o ABAP Workbench que é o conjunto de ferramentas como editor, dicionário de dados, painter de tela e tudo mais, que é como se fosse seu Visual Studio ou Eclipse de hoje. Falando em Eclipse existe até o ADT que é o ABAP Development Tools que são plugins pro Eclipse, pouca gente usa, por incompatibilidade de servidores, funcionalidades ou por serem reacionários a mudanças e além de demandar uma curva de aprendizado..

Como mencionei antes, os programas são chamados por transações no SAP, o mesmo conceito de shortcuts do windows. E pra mim a coisa mais importante nessa infraestrutura é o Dicionário de Dados (tela) que contém todos os metadados do sistema que você acessa via o Object Navigator ou transaction SE80. Todas as transações são identificadas por um código como esse, é tipo a URL pros programas.

Vou tentar resumir bastante agora, mas por exemplo, no dicionário você tem tabelas. Mas você lembra que eu falei que o Basis abstrai o banco por baixo? Uma tabela em ABAP é uma representação 1 pra 1 com uma tabela no banco se ela for uma tabela que chamamos de "transparente" mas existem "pools" que são entidades independentes no dicionário mas agrupados em tabelas físicas maiores ou "pools" no nível do banco de dados. Você tem cluster tables que são fisicamente agrupadas em clusters baseados em suas chaves primárias, são alternativas para limitações de banco de dados, por exemplo, um tamanho de registro maximo ou de número de campos. Os dados de um registro lógico é guardado em mais do que uma linha no banco de dados, fora as chaves os demais campos ficam serializados em um campo raw. Obviamente com o pior conceito de performance, mas de novo, fica transparente para o workbench de abap o mesmo select. O trade-off para isto é a criação de tabelas secundárias particionadas. não lembro se na prática funcionam como views materializadas em bancos como postgresql.

Mais interessante são os Domains, que armazenam o registro dos elementos de dados. Acho muito engraçado que muito pouca gente sabe que qualquer banco de dados relacional que se preza tem coisas como User-defined types ou custom types. Por exemplo, se eu falo vamos representar um preço numa tabela, a primeira coisa que um programador pensa é: vou criar um campo FLOAT ou INT. No SAP você tem um tipo chamado PRICE e toda tabela que precisa de preço vai ter o tipo PRICE e ponto. Se amanhã o tipo primitivo de PRICE mudar, ela muda pra todo o sistema replicando a alteração para todos os demais objetos dependentes.

Mais ainda, internamente no ABAP digamos que eu queira uma variável no programa pra armazenar o preço que eu puxo de uma tabela. Que tipo vai ser essa variável? Vai ser tipo PRICE, igual o que vem da tabela. E como ABAP compila tipo uma AST mas sua execução é dinâmica, se o tipo PRICE muda, não só as tabelas, mas os programas passam a usar o tipo novo, é plug and play assim. Você acha que já viu boas modelagens de dados, mas comparado com o que se tem numa instalação SAP, chega a ser primitivo como um hello world.

Sendo ainda mais específico, uma tabela tem campos, campos tem elementos de dados, elementos de dados tem domínios, e o domínio contém o tipo de dado para armazenamento de banco de dados, valores permitidos, rotinas de conversão. Por exemplo, o elemento Centro de Custo valor string "1000" é convertido pra "0000001000" 

então se um usuário preencher "0001000" ou "01000" 

vai ser tudo reduzido a exatamente o mesmo valor. Então o elemento de dados já traz embutido não só o tipo primitivo mas regras como validação, conversão e inclusive a internacionalização do nome. Basta você falar que o campo é determinado domínio e ele já herda tudo.


Uma aplicação prática:
Um campo pro exemplos, o domínio email: os espaços no início e no fim são suprimidos, o campo é convertido para minúsculo, implementa-se uma regra de validação tipo regex em ABAP e um tamanho máximo.
Qualquer campo que seja exibido na tela do usuário já irá implementar todas estas regras.
Caso um dia o campo precise ser ampliado ou implementar uma regra do tipo @exemplo.com não é mais permitido, TODAS as referências utilizadas são automaticamente herdadas sem a necessidade de search, copy & paste, etc. 

---> Foi o primeiro tapa na minha cara, onde eu aprendi que dar manutenção em programas é muito mais difícil do que escrever programas. E a SAP criou um fluxo de trabalho extremamente eficiente. Permitindo um código base existir e evoluir por quase meio século.

Eu falei de localização antes, e aqui entra domínios e elementos de dados de novo. 
Pra quem acha que localização é só traduzir texto na verdade estamos falando de todos os cenários e regras de negócio particulares de um país para atender as necessidades fiscais e contábeis, por exemplo livros fiscais, cálculo e contabilização de impostos, retenção de impostos, obrigações acessórias como SPED contábil, contribuições, REINF, além de cálculo de folha de pagamentos e outras regras derivadas de CLT por exemplo.

Como eu disse que existe essa abstração de elemento de dados, num designer de tela, como você veria num Visual Basic, você não precisa arrastar um Label, editar o texto e daí arrastar um campo de texto e criar as validações. Você arrasta o elemento de dados inteiro e ele já vem certinho o texto internacionalizado, o tipo de campo de input correto e todas as validações e regras de negócio relacionados. É um nível acima do que você imagina como Rapid Application Development ou RAD que um Visual Basic ou Delphi nunca atingiram.

Pois é, lembra que eu falei que nomes de tabelas e campos no banco são tudo acrônimos em alemão? Não em importância porque graças aos elementos de dados no dicionário, cada campo além de tudo tem as traduções nas diversas línguas suportadas, então todas as telas traduzem automaticamente também.

Eu acho interessante porque se você começar a olhar todos os componentes em detalhes, é absolutamente surpreendente que um sistema como esse existe, e faz você, enquanto programador, enxergar o quanto nós somos ruins. Por exemplo, um programador amador, se precisasse fazer um sistema de vendas, começaria pensando um troço besta como uma tabela de produtos, que tem campos como código do produto, nome, quantidade e preço.

Esse é obviamente o jeito idiota de se fazer. Se você for um pouco mais avançado, vai pensar em variante de produtos, SKUs e modificadores de preço como descontos, preço de campanha.

Mas se você for no módulo de vendas do SAP, o famoso SD, você vai ter um sistema de precificação que é uma matriz multidimensional programática que leva em conta as variantes todas (que por si só são outras matrizes) e todos os aspectos geográficos, como setor de atividade, centro de distribuição, e tantos outros parâmetros que modificam desde custo até imposto que vai na composição dos preços. Um produto na verdade são N produtos que custam M preços diferentes dependente de quem faz o pedido, pra onde entrega, como foi manufaturado ou comprado, onde está armazenado, em que cidade, em que estado, de que país.

Eu tive a oportunidade de lidar com diversos módulos do R/3, incluindo sales and distribution ou SD, materials management ou MM, projects ou PS, financials ou FI, human resources ou HR. Como eu disse, eu não era um consultor funcional, eu era um integrador, principalmente pra sistemas Web. O R/3 tinha o equivalente a RPC pra integração ou Remote Procedure Calls, se você for de Java pense em algo como RMI ou Remote Method Invocation, pense a época de DCOM, COM+ ou CORBA. Tudo tecnologia pré-JSON-RPC que temos hoje em Web.

Na minha época, a SAP começou a tentar modernizar tudo pra Web, seguindo a tendência do mundo Java. A SAP compra muitas empresas o tempo todo, o portfólio de aquisição deles é enorme. Uma das empresas foi a In-Q-My de outra figura que ficou muito famosa na época, o Shai Agassi, empreendedor israelense. Muito antes de Elon Musk era Shai Agassi que estava iniciando a tendência de carros elétricos com sua empresa Better Place, que desenvolvia baterias pra carros elétricos e foi fundada em 2007, faliu em 2013, mas pense que foi tipo um pré-Tesla. Acho que meio por isso eu também não fiquei muito surpreso com um Elon Musk tendo conhecido Shai Agassi antes. Com a aquisição ele virou presidente de produtos da SAP e foi um forte candidato a suceder Henning Kagermann como CEO em 2007. Mas nessa batalha o Kagermann se estendeu como CEO até 2009 e Agassi renunciou.

Sob a liderança de Agassi surgiu a plataforma SAP NetWeaver, um pacote complementar ao ERP R/3, que adicionava componentes Web ao legado corporativo. Isso incluiu pacotes como o SAP Enterprise Portals, que foi onde eu me certifiquei e virei especialista. Era um conjunto de aplicações J2EE que rodava no servidor de aplicações da In-Q-My. Diversos outros produtos foram saindo nessa época, os xApps, o Exchange Infrastruture ou XI que era o sistema de filas, a versão menor do ERP pra empresas menores que foi o Business One e muito mais. Foi uma pequena revolução e todo mundo ficava confuso porque era o mundo legado recebendo a porrada do mundo Web. E exatamente nesse momento um cara como eu, que era de Web e aprendendo o legado, virei mosca branca.


Nessa época estávamos entrando na versão 4.7 do R/3. Quando eu estava saindo do mundo SAP eles estavam mudando o nome do produto principal de ERP de novo. De R/3 passou a ser ECC ou Enterprise Core Components. Então hoje em dia você não ouve mais falar de R/3 e sim de ECC.

Além disso eu falei que o Hasso Platner e o Larry Ellison não se bicam, mas uma das combinações mais fortes do mundo Enterprise sempre foi o R/3 rodando com banco de dados Oracle. Era bem bizarro, é meio como é hoje os iPhones da Apple usando telas OLED da Samsung embora eles sejam concorrentes. Hoje o cliente que gerar maior receita de banco de dados oracle no mundo é a própria SAP, que vende sua licença SAP adicionada do custo de licenciamento que é repassado para a Oracle. Houve uma litígio jurídico entre ambas sobre o valor do repasse, a primeira sentença foi de 1,3 Bilhões de USD. 

O começo da sua história a SAP não lidou com bancos próprios, sendo como princípio fundamental multiplataforma e multi-banco. Para mitigar esta dependência uma das alternativas foi o famoso ADABAS D, que eles liberaram como open source com licença GPL no ano 2000. Em 2003 a SAP AG e a MySQL AB se uniram e lançaram um novo banco próprio pra SAP chamado de MaxDB. A MySQL saiu da jogada depois de alguns anos e a SAP continuou sozinha com o MaxDB que hoje é closed source. Para “controlar” a dependência sobre o sistema operacional a SAP é uma das acionistas da(o) Suse. Hoje o caminho da SAP é todo direcionado para o SAP HANA que é o novo banco de dados que roda como núcleo dos produtos de inteligência da SAP, é como se fosse um mantra ou uma lavagem celebral, tudo hoje na SAP gira em torno do Hana.

SAP HANA é um produto que vale a pena dar uma olhada, em resumo ele é um banco de dados in-memory (pensa um Redis), orientado a colunas (pensa um Cassandra) e com duas coisas absolutamente importantes: suporte a OLTP e OLAP.
OLTP pense em transações de bancos relacionais: a integridade dos dados é absolutamente importante num sistema enterprise. 
E OLAP é a parte analítica, que é suporte a análise multi-dimensional, que é o caso pra Big Data, Data Mining, Data Warehouse. Se você nunca ouviu falar em dimensões, modelo estrela, cubos, não sabe o que é análise de dados ainda. Você acha que com uma mísera query SQL vai conseguir chegar de forma eficiente nos dados de uma multinacional tipo uma Nestlé e agregar os resultados de vendas de todos os países do mundo de uma só vez? Com capacidade de dar drill down do faturamento anual da marca e ir descendo - drill down - até chegar no faturamento de uma loja? Pensa no que significa esse tipo de query, e agora pensa centenas delas pra ter a visão do MUNDO de uma multinacional. Quando virar data scientist não era hipster como é hoje, já se lidava com Big Data em multinacionais.

O S/4 HANA é o primeiro re-code da SAP. Onde o antiquado, combalido mas ativo e forte cinquentão R/3 e suas repaginações segue finalmente para o caminho de legado.
O trocadilho S/4 é proposital da evolução do R para S e do 3 para 4.

Por muitos anos os sistemas SAP foram especializados em lidar com grande quantidade de transações. Vendas, compras, contratos, projetos, manufatura, etc. Onde a prioridade foi funcionalidade com o tradeoff de performance.  Agora que as empresas que implementaram tem essa quantidade massiva de dados, o foco tem sido em tornar esse dados inteligentes. Já que tem todos os dados vitais de uma empresa, porque o sistema já não pode tomar muitas decisões estratégicas? Daí entra o HANA ligado a diversos outros produtos como o TREX o próprio Hadoop e assim por diante.

Voltando a falar do mercado nacional, eu lembro que quando comecei no mercado SAP o mercado top tier era altamente concentrado no que chamávamos de Big Five. Pra explicar, haviam as grandes consultorias de renome que eram quem conseguia fechar contratos gigantes como Petrobrás, Vale. E existiam as quarteirizadas menores como onde eu trabalhava que prestavam serviço via essas grandes. No começo do século as Big Five eram IBM, Arthur Andersen, Price WaterhouseCoopers, Ernst & Young e KPMG.

Mas não demorou muito e a parte de consultoria Arthur Andersen virou Accenture, a Price foi comprada pela IBM, a Ernst & Young foi comprada pela Capgemini. No fim as Big 5 foram consolidadas mais ainda em Big 3.

Digamos que você quer se tornar um consultor, o que fazer? Você precisa passar pela academia, são os cursos de certificação licenciados pela SAP. Existem dois motivos de porque você não tem como ser autodidata no mundo SAP. Primeiro, tenta ir no Google, você não vai achar nada de muito útil online. Toda a base de conhecimento da SAP é fechada, só consultores certificados tem acesso a essa base. Existe tipo uma Deep Web da SAP que ninguém tem acesso, que é a SCN que mencionei no começo.

Fora isso pra acessar essa base e também pra conseguir acessar o sistema das empresas, você tem um SAP ID que é seu RG de consultor e é reconhecido mundialmente e cadastrado na SAP da Alemanha. Sem isso você não tem autorização pra atuar como consultor. Parece que diminuiu um pouco a dificuldade, antes você precisava fazer a academia, hoje tem um tal de Certification Day. Fragmentou um pouco o conceito de academias e bootcamps, hoje tem mais cursos não-oficiais pra assuntos específicos. A época de ouro da SAP no Brasil foi do meio dos anos 90 até o começo dos 2000 eu acho, quando as taxa hora eram exorbitantes. Mas até esse mercado se comoditizou um pouco hoje em dia, mas a exclusividade ainda garante boas taxas.

A certificação é do consultor, e ligado à consultoria que pagou pelo curso ou prova. E são cursos caros. Na minha época acho que uma academia era na casa dos 10 ou 20 mil reais. Pra consultoria isso é importante porque ela precisa de um número mínimo de consultores ligados ao seu CNPJ. Se o consultor trocar de consultoria ele precisa pedir a transferência. É uma burocracia da SAP que ainda mantém um certo controle de como organiza seu mercado. É meio parecido com o que a Microsoft tem com seus MCPs ou MCSEs.

Em começo de carreira o melhor é iniciar como trainee de uma das Big que mencionei, entrar no programa da IBM, Accenture, Deloitte, Capgemini e outras. Elas são pouco divulgadas então tem que cavar um pouco. E não é só pra programadores, na verdade os consultores funcionais são especializados em cada módulo de negócio. Um contador pode virar consultor do módulo financeiro, alguém que se formou em direito trabalhista pode trabalhar no módulo de HR, por exemplo.

Outro ponto que eu achava interessante antigamente era o que a gente coloquialmente chamava de Z/3. Uma das convenções de programação é que tudo que você desenvolvia em ABAP que não era standard a gente começava o nome com Y ou Z, muito mais Z. E um dos principais problemas de consultorias ruins é que em vez de resolver os problemas do jeito certo, via customização dos módulos funcionais, eles resolvem fazer via força-bruta, basicamente um copy e paste de uma transação que já existe em um Z pra mudar duas linhas. Que nem antigamente quem fazia web tosco tinha index.php e index2.php ou coisas assim.

Faça isso por muito tempo e você basicamente perde a habilidade de conseguir fazer upgrade do sistema porque as transações originais vão ser atualizadas, mas as cópias Z vão ficar pra trás. Então se formou um mercado paralelo pra dar manutenção nesses malditos Z/3. E você acha que só empresa pequena que faz isso, não empresas grandes fazem Z demais também. Eu vi vários.

Pra evitar esse cenários, depois da minha época a SAP inventou uma forma melhor pra estender os programas padrão sem ter que clonar em Zs, e isso é chamado de SAP Fiori ou SAP na Web. Eu mesmo ainda não vi como isso funciona, mas deve ajudar a evitar as dores de cabeça de manter um Z/3.

E falando em suporte, um dos grandes mercados pra consultorias de SAP ou Oracle é a parte de suporte. Eles vendem horas de suporte pra grandes empresas. Na minha época não tinha mas agora tem opções como a Rimini Street.

Fazer tudo by the book custa caro. Mas na prática não existe nenhuma trava de funcionamento do sistema, como chave de ativação ou algo assim. E mesmo que tivesse daria pra bypassar porque o código fonte do sistema em ABAP vem no sistema, ele é modificável. Mas só isso não é suficiente, sem o suporte da SAP seu sistema deteriora.

Mas em vez de pagar os 22% de valor de aquisição da licença pra efeito de manutenção muitas empresas optam por não evoluir o SAP, porque os processos em si ficam estáveis e não mudam tanto. Os demais gaps de desenvolvimento eles contratam de suporte alternativo, literalmente mercado negro mesmo. Fica a cargo de empresas como a Remini Street manutenções desse tipo.

Durante minha carreira enterprise eu passei por diversas empresas diferentes. Eu mencionei como ganhei o projeto de SAP Enterprise Portals na Suzano Papel e Celulose no meu vídeo de O que Estudar, mas além disso eu passei quarteirizado por consultorias como Atos Origin, e participei do projeto de merge de telecoms que gerou a Vivo, depois o merge que gerou a Claro, Ultrafértil Fosfértil, C&A, Copersucar, ESAB, Embratel, e outras.

Apesar de ter sido um dos períodos mais estressantes foi também um dos mais interessantes. O trabalho era longe de ser glamuroso. Absolutamente longe de qualquer ideal de tech startup que você já tenha visto, na verdade acho que o total oposto. Não tem hora. Não tem lugar. Uma vez eu estava na Atos Origin falando de não sei que projeto e literalmente numa conversa de bebedouro troquei idéia com um gerente de não sei aonde, e ele falou de um problema que estava tendo no módulo de viagens na instalação da Embratel e, por acaso, eu tinha uma suspeita do que podia ser o problema. Ele disse que ninguém estava conseguindo resolver e quando falei da minha suspeita ele só disse: “porra, você pode ir pro Rio amanhã?” E assim eu fui pro Rio, passei 3 dias e resolvi o problema. 

Só pra entender qual era o problema, uma transação SAP tem tela gráfica. Mas ela pode rodar headless. Pensa como rodamos hoje um Selenium, Capybara, com o Chrome headless. Mesma coisa. Eles chamam isso de Job, que roda em background. Agora imagina se uma tela headless de repente sobe um dialog box que não tem como dar cancel, daí obviamente o Job trava. Ninguém parou pra pensar nisso, daí eu achei onde abria dialog, não lembro se fiz algum ABAP uma exit ou algo assim pra tirar o dialog e aí tudo voltou a passar.

Um bom consultor, por definição, tem que pensar fora da caixa, como eu disse, nós temos menos tempo e menos recursos que todo mundo que tentou resolver antes da gente. Por isso que quando um consultor mosca branca troca de consultoria até o cliente tende a mudar de consultoria se precisar pra não perder o consultor. Nas consultorias menores, o consultor é mais importante do que a a consultoria. Isso eu sempre achei legal. Por outro lado gente que reclama demais nunca vai ser um solucionador de problemas - óbvio porque claramente gasta mais tempo reclamando que resolvendo - e, portanto, nunca será consultor porque nós éramos a elite, a swat, os navy seals, quando nos chamam é porque a casa já caiu. Quer trabalho facinho, vai trabalhar em fábrica.

Mas, uma coisa é certa, nenhum programador tem como saber as regras de negócio de grandes empresas sem ter passado por elas, de preferência por várias delas. Eu não sou especialista, mas ter tido a oportunidade de lidar com áreas completamente diferentes como vendas, recursos humanos, financeiro, manufatura, logística, controladoria, me deu uma visão de estrutura de empresas que nenhum MBA, e obviamente, nenhum evento ou workshop ou mentoria de startup jamais vai conseguir dar pra ninguém. Você precisa ter sofrido o mundo enterprise pra entender o mundo enterprise, é impossível saber disso de outra forma.

Como tangente eu acho engraçado quando o recém-formado ou mesmo drop-out “acha” que vai revolucionar qualquer coisa. Não vai. É uma loteria, é sorte, 1 em milhares. A razão é simples: o moleque chega e diz “vou revolucionar o mercado médico”, aí eu pergunto, beleza, quanto tempo você trabalhou na medicina? Em que especialidades? Em quantos hospitais? E ele fala “nunca fui médico”. Eu só balanço a cabeça e mando embora. Nem os próprios médicos entendem o sistema onde eles mesmos trabalham, estando dentro. Ou você tem um sócio médico que compreende os processos, ou esquece.

E não tente se comparar com os grandes. Você não é o Reid Hoffman. Você não é o Jack Ma. Você não é o Elon Musk nem o Shai Agassi. É um absurdo querer se comparar com eles.

Muitos dos processos que eu apliquei nas empresas seguintes que trabalhei, incluindo na minha própria, são derivados do que eu aprendi no mundo SAP. As partes boas eu trouxe, as que eu vi na prática que não funcionavam eu mudei, mas não saiu a idéia do zero da minha cabeça. Foram anos e anos tentando de tudo, falhando, aprendendo porque falhou e tentando de novo. E eu tive a oportunidade de fazer isso em grandes empresas. E mesmo com tudo isso quando comecei minha própria empresa tive problemas. Imagine você começar do absoluto zero e no risco? É como dizer “vou atravessar o Atlântico de caiaque, mas nem sei nadar ainda”. Minha cabeça explode ouvindo estupidez desse nível.

O mundo SAP serviu pra amadurecer minha visão de negócios, corporações e o mercado como um todo, uma nova dimensão que um programador recebendo ordem de serviço numa fábrica jamais vai ter. Minha recomendação é que se você tiver a oportunidade, tente, não vai perder nada. Se eu pudesse voltar no tempo será que eu passaria por todo esse stress de novo? Com certeza!

E é isso aí, hoje foi uma pincelada muito rápida no que eu aprendi em 5 anos nesse mercado, não dá pra detalhar tudo mas acho que isso deve dar uma visão geral, pelo menos uma visão geral segundo o que eu experimentei, tem muito mais que nem eu sei ainda. E vocês, já tiveram experiência no grande mercado enterprise? Compartilhem suas experiências nos comentários abaixo. Se curtiu mandem um joinha, compartilhem o vídeo, assine o canal e clique no sininho. A gente se vê, até mais.
