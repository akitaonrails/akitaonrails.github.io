---
title: '[Akitando] #38 - Conhecimentos Básicos para Iniciantes em Programação | Série
  "Começando aos 40"'
date: '2019-02-06T17:00:00-02:00'
slug: akitando-38-conhecimentos-basicos-para-iniciantes-em-programacao-serie-comecando-aos-40
tags:
- git
- linus torvalds
- github
- linux
- ubuntu
- mint
- fedora
- manjaro
- arch
- programação
- developer
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


{{< youtube id="sx4hAHhO9CY" >}}


### Descrição no YouTube

Neste terceiro episódio da série "Começando aos 40" vou finalmente começar a tocar em assuntos mais práticos, pra começar o que eu considero que é o absolutamente básico que você precisa começar a dominar o quanto antes.

Neste e nos próximos 2 episódios, pelo menos, vou dar uma visão mais estruturada do que considero que a carreira de "desenvolvedor Web" envolve para que você tenha uma idéia 'macro' do que deve planejar para estudar e treinar.

Agora é a hora de arregaçar as mangas e treinar!


Links:

* Developer Roadmap (https://github.com/kamranahmedse/developer-roadmap)
* git-remote-dropbox (https://github.com/anishathalye/git-remote-dropbox)
* Building a Continuous Delivery Pipeline with Git & Jenkins (https://stackify.com/continuous-delivery-git-jenkins/)
* A beginner's guide to continuous integration (https://about.gitlab.com/2018/01/22/a-beginners-guide-to-continuous-integration/)
* TodoMVC (http://todomvc.com/)
* Arch Linux (https://www.archlinux.org/)

AkitaOnRails Blog:

* Jogar Pedra em Gato Morto: por que Subversion não presta (https://www.akitaonrails.com/2007/09/22/jogar-pedra-em-gato-morto-por-que-subversion-no-presta)
* GIT: Muito Promissor (https://www.akitaonrails.com/2007/09/22/git-muito-promissor)
* Micro Tutorial de Git (https://www.akitaonrails.com/2008/04/02/micro-tutorial-de-git)
* Dicas de Git (https://www.akitaonrails.com/2009/07/05/dicas-de-git)
* [Screencast] Começando com Git (https://www.akitaonrails.com/2010/08/17/screencast-comecando-com-git)
* Chatting with Chris Wanstrath (Err the Blog/Github) (http://www.akitaonrails.com/2008/04/21/chatting-with-chris-wanstrath-err-the-blog-github)
* Arch Linux - Best distro ever? (http://www.akitaonrails.com/2017/01/10/arch-linux-best-distro-ever)
* Optimizing Linux for Slow Computers (https://www.akitaonrails.com/2017/01/17/optimizing-linux-for-slow-computers)
* From the Macbook Pro to the Dell XPS. Arch Linux for Creative Pro Users (http://www.akitaonrails.com/2017/01/31/from-the-macbook-pro-to-the-dell-xps-arch-linux-for-creative-pro-users)
* Running Arch Linux over Windows 10! (http://www.akitaonrails.com/2018/04/29/running-arch-linux-over-windows-10)

## Script

Olá pessoal, Fabio Akita

Neste terceiro episódio da série “Começando aos 40” vamos finalmente começar a falar sobre o currículo básico pra quem quer se tornar um desenvolvedor Web. Veja que não existe somente Web, você pode escolher desenvolvimento mobile para fazer apps para smartphones ou mesmo algo mais tradicional como aplicativos nativos Desktop

Todo mundo que tá iniciando tem que começar do zero, um pouco de HTML, um pouco de CSS, um pouco de Javascript. Quem está fazendo algum curso de tecnólogo começa com um pouco de Java, talvez um pouco de C# ou PHP.

Mas praticamente todos esses cursos falham em mostrar TUDO que você realmente vai precisar pra montar uma carreira. Claro, como eu já disse antes, sabendo um pouco do básico, você já começa a ser capaz de começar a trabalhar. E a importância de trabalhar numa empresa com uma equipe é porque justamente você ainda não vai ser capaz de fazer um projeto do começo ao fim sozinho, simplesmente porque em 1 ou 2 anos é impossível saber tudo que se precisa.

E o que exatamente é esse TUDO que se precisa? Eu disse que essa série vai ser bem longa. No episódio de HOJE vamos começar com os conhecimentos mais básicos que você vai precisar. Vamos lá.



(...)



Um ou dois anos atrás eu esbarrei num repositório no GitHub chamado Developer Roadmap, ele tem sido atualizado uma vez por ano e a versão 2019 está lá. O autor por acaso é de uma empresa de cursos chamada Hackr.io que eu nunca parei pra ver então não sei dizer se os cursos são bons ou não. Esse roadmap é um mindmap, que é uma representação gráfica de idéias em conceitos, na prática é um monte de caixinhas ligadas num gráfico. O que eu achei interessante é que ele lista caixinhas obrigatórias pra cada carreira e caixinhas opcionais mas desejáveis e, no geral, eu concordo com as divisões e prioridades que ele colocou, então é uma boa referência pra vocês.


E note que eu disse que ele atualiza todo ano. Nos últimos 2 anos não mudou tanto, mas se ele tivesse começado 5 ou 10 anos atrás, vocês iriam ver que a carreira mudou bastante nesse período. Lembra no episódio anterior que eu falo sobre o tempo? Pois é, considere que esse roadmap pode mudar muito ainda daqui 2 anos ou mais. Se você for aprender TUDO que está nesse roadmap, se estudar e treinar com afinco, vai precisar de uns 3 a 5 anos, no mínimo. E eu diria que esse roadmap é básico, tem muito mais além disso ainda. Mas não se assuste, você não precisa saber tudo de uma vez só, mas tenha na cabeça que nossa carreira vai exigir que você esteja estudando constantemente. Não existe fazer um curso de 6 meses e achar que já sai tudo.


Este roadmap se divide em QUATRO partes. Primeiro, e o tema deste episódio, são conhecimentos gerais que todo mundo precisa saber. Daí ele separa em carreira de desenvolvedor Front-end que se preocupa mais com a parte visual que as pessoas normalmente vêem, o HTML e CSS final, Javascript e tudo que envolve usabilidade. Então você tem Back-end que é a carreira mais complexa em termos de coisas pra aprender e se preocupa com o software que roda por trás, as regras de negócio, as integrações, os bancos de dados. Finalmente uma carreira nova que chamamos erroneamente de Devops, vou explicar porque em outro episódio. E como eu disse antes, essas não são as únicas carreiras, só as primeiras TRES dentro do mundo de Web.


A idéia é você usar esse Roadmap como um checklist. Cada caixinha amarela é um corpo de conhecimentos grande. Você vai encontrar cursos inteiros pra cada caixinha. Mas lembre-se do que eu já falei no meu episódio sobre Faculdade: você não deve tentar aprender 100% de cada assunto de uma só vez. Aprenda no máximo 20%. 
Os primeiros 20% que vai te permitir resolver 80% dos problemas. Vou dar um exemplo. Na primeira parte, de conhecimentos gerais, a primeira caixinha é GIT.


GIT é um versionador de arquivos. Essa ferramenta foi desenvolvida inicialmente pelo criador do kernel do Linux, o famoso Linus Torvalds e o atual mantenedor é Junio Hamano. Pense assim: como centenas de desenvolvedores podem editar os mesmos códigos num projeto como o Linux e não virar uma bagunça colossal? É por causa de ferramentas como o GIT. 


Nos anos 90 e começo dos 2000 haviam várias, como CVS que era uma grande porcaria mas era o que tinha, substituído pelo Subversion ou SVN que era menos porcaria e eu usei muito e inclusive fiz um patch pra ferramenta TortoiseSVN pra ele funcionar em Windows em projetos com Visual Studio que não suportava diretórios que começa com ponto. Haviam ferramentas comerciais bem porcaria como Rational Clearcase ou a droga do Microsoft SourceSafe. Eram todos versionadores centralizados, e daí nos anos 2000 começamos a ir para versionadores distribuídos como BitKeeper, Perforce, Darcs, Bazaar que era usado pela Canonical, Mercurial.


Eu comecei a evangelizar Git no Brasil por volta de 2007 como você pode ver em meus blog posts mais antigos linkados na descrição abaixo. E nós da comunidade Ruby on Rails ajudamos muito o GitHub - que é feito em Ruby on Rails - a crescer rapidamente. Por causa disso GIT se tornou o padrão embora em ambientes comerciais alguns ainda fiquem presos a ferramentas como o Microsoft Team Services. Mas esquece, 99% do mundo de desenvolvimento usa GIT pelo simples fato que a maior parte dos melhores software open source do mundo estarem lá no GITHUB.


O GIT em si possui centenas de comandos e permutações. Você usa GIT pra baixar código dos repositórios preservando um histórico de “commits” que são trechos de alteração de código. Você pode navegar pra trás no tempo num sistema desses e recuperar o estado do código como ele era ontem ou semana passada ou ano passado. E cada modificação que você faz você empacota nesses “commits” e empurra (ou dá push) pra um repositório elegido como central que todos usam, embora GIT em si não precise de um servidor central. O fluxo de trabalho com GIT que a maioria dos desenvolvedores Web usam é derivado do que nós da comunidade Rails desenvolvemos junto com o GitHub, o mecanismo que chamamos de Pull Requests e Forks. A comunidade do Kernel do Linux usa um fluxo de trabalho diferente por exemplo.


Agora, os tais 20% que eu falei antes? Você precisa saber talvez uma dúzia só de comandos como “git init” pra iniciar um repositório, “git add” pra acumular as modificações que fez agora, “git commit” pra empacotar essas modificações, “git push” pra enviar as modificações pra outro repositório de origem, “git pull” pra puxar as últimas modificações desse repositório. 
Se você dominar esses comandos já consegue participar de um projeto. Só que isso é o ultra básico, porque existem vários coisas importantes que você vai precisar aprender como o que são branches e como trocar de branches, como fazer cherrypicking, como reescrever commits, as diferenças entre rebasing e merge, o que é stage, pra que serve squash de commits, pra que serve bisect, pra que serve reflog, diferenças entre reset e clean, e assim por diante. 


Mas você pode ir aprendendo um comando de cada vez. O Git é praticamente um sistema de arquivos avançado, sua estrutura de dados é baseado num DAG que é um Direct Acyclic Graph e se você entender como ele funciona internamente você pode usar o GIT pra fazer coisas avançadas. Por exemplo, você poderia criar um produto que é um mini-clone do Dropbox usando GIT. Você pode integrar o GIT com sistemas de deployment, ou seja, que toda vez que você dá push no repositório ele toma uma ação como atualizar o servidor ou rodar os testes do repositório num sistema de Continuous Integration. As opções são infinitas.


Mas atenha-se em aprender os primeiros 20%, a primeira uma dúzia de comandos. Não se preocupe, se você for curioso, você vai aprender tudo do GIT eventualmente. Mas se tentar aprender TUDO de uma só vez, você vai ficar meses estudando a teoria e não vai entender tudo. Gaste uma semana em tutoriais iniciais do GIT. O próprio GitHub tem o site Github Guides que vai te dar o básico. E obviamente treine em dezenas de arquivos na sua própria máquina. Erre dezenas de vezes pra ver o comportamento de cada comando, teste os limites de cada comando. Mas de onde vamos arranjar esses arquivos e projetos pra você treinar?


O Roadmap está correto em colocar GIT em primeiro lugar porque uma das coisas que você logo no começo PRECISA fazer é fuçar MUITO o GitHub. Agora, entenda uma GRANDE verdade de qualquer curso ou tutorial: TODOS os passos que eles mostram SEMPRE funcionam, porque a demonstração foi preparada pra funcionar. Começa com algum exercício do tipo, “vamos fazer um aplicativo de lista de tarefas” daí ele vai te dando passo a passo tudo na ordem certa pra no final você ter um pequeno aplicativo. Mas os passos só funcionam dentro de um ambiente muito controlado, quase de laboratório, se divergir um pouquinho vai dar errado e você não vai saber o que tem que fazer.


Pra quem só está iniciando, claro que é importante ver as coisas sendo construídas de forma ordenada. Só entenda que isso é irreal. Todo tutorial e curso não tem absolutamente nada a ver com a vida real. Na vida real você quase sempre vai participar de um projeto que já existe, ou começar com outras pessoas, e vai baixar código que já existe e ter que participar do código dos outros. E esse código não vai estar perfeito, aliás, normalmente vai estar MUITO longe de perfeito, as coisas vão quebrar, as instruções não vão funcionar, e você vai ficar em dúvida se é o código do projeto que tá quebrado ou você que não tá entendendo alguma coisa trivial.


Muito do processo de programação é tentativa e erro. Um dos grandes defeitos de cursos e tutoriais é que eles mostram só o passo a passo perfeito. Tutoriais não ensinam a lidar com erros e isso é um enorme problema. Eu mesmo cansei de receber mensagens de pessoas que falam “Akita, tava seguindo esse tutorial e deu um erro, você sabe como resolve?” 
Daí eu falo “me manda a mensagem de erro que tá aparecendo aí”. Daí eu pego essa mensagem, jogo no Google, e mando o primeiro link que aparece e pergunto “e aí, era isso?”, aí a pessoa responde “puuuuuta Akita você é foda mesmo, resolveu!”  …. Aí eu fico …
“filho da mãe, eu virei proxy do Google”!!


Sério, se você é iniciante, assuma que 99% de todos os erros que você encontrar, você certamente não é o primeiro. Muita gente já passou pelo mesmo erro que você tá passando e eles já foram documentados nas Issues do GitHub, ou em sites como Stackoverflow, Stackexchange, fóruns como Reddit. Antigamente, nos anos 80 e começo dos 90, a gente simplesmente não tinha onde procurar online, porque nem tinha internet!! Então quando tinha um erro, a gente precisava aprender a descobrir tudo sozinho. Por isso o povo dependia de empresas como Microsoft, BEA, IBM ou outros que costumavam ter uma comunidade interna somente pra quem pagava a assinatura e você tinha acesso a bancos de conhecimento que vinham em CDs como o MSDN. Mas hoje em dia, o Google vai te responder 90% das coisas que você vai precisar.


Isso tudo dito, em vez de ficar só fazendo passo a passo de vários tutoriais, vá no GitHub e procure alguma coisa como “clone instagram javascript”, vai aparecer vários. Alguns muito parecidos, alguns uma porcaria. Não importa. E agora que você já aprendeu o básico de Git, clone o projeto na sua máquina e tente rodar. Você vai sofrer um bocado da primeira vez e vai cair na segunda caixinha amarela do Roadmap que diz “Basic Terminal Usage”.


Essa caixinha junto com outras como “SSH” vai te dar MUITO trabalho. Entenda outra verdade: quando você for subir seu primeiro projeto de verdade para o público, ele não vai estar na sua máquina, vai estar num servidor. Seja você um programador front-end ou back-end você PRECISA o quanto antes aprender mais sobre sistemas operacionais.


A maioria de vocês provavelmente está usando Windows. E não tem nenhum problema. Eu uso Windows também. Porém você obrigatoriamente deve aprender sobre distribuições baseadas em Linux. Você pode fazer isso do jeito difícil ou do jeito ultra difícil. O jeito difícil, se sua máquina aguentar é baixar e usar o programa Virtualbox ou versões pagas como VMWare ou Parallels.


Hoje em dia se tornou muito comum rodar Linux em máquinas virtuais. Todo novo CPU suporta o que chamamos de instruções VT-X no caso da Intel ou AMD-V no caso da AMD que são funções da CPU para fornecer o máximo de performance de acesso ao hardware quanto possível em ambientes virtualizados. Significa que você consegue rodar uma distribuição de Linux como Ubuntu, Fedora ou Arch inteira dentro de um Virtualbox. 


A maioria das pessoas nunca instala seu próprio sistema operacional, nem configura nada. Simplesmente compra a máquina e usa do jeito que veio. Isso é horrível. Um programador escreve software. Software é código que diz à máquina o que fazer. A máquina é controlada por um sistema operacional. Se você não conhece o sistema operacional, sua programação sempre vai ter muito achismo e chutes. Você acaba se tornando supersticioso e em vez de resolver os problemas procura alguma mandinga.


É impossível aprender tudo só em poucos dias ou semanas, por isso o melhor caminho pra começar é de cara tirar a rodinha da bicicleta e começar a apanhar. Não comece com uma distribuição fácil como Mint ou Ubuntu. Comece instalando um sistema operacional manualmente do zero e pra isso não há nada melhor do que uma distribuição Linux como o Arch Linux, que me lembra um pouco minha época de Slackware 1.0 no meio dos anos 90.

Se você ainda não sabe disso, Linux é o nome do kernel, o binário responsável por iniciar a máquina, configurar os dispositivos e oferecer serviços pros aplicativos podem falar com a máquina. Existem dezenas de distribuições que usam o kernel Linux. O que varia em cada uma é a seleção de aplicativos, formas de configuração, gerenciamento de pacotes e ecossistema. Na dúvida você vai acabar escolhendo algo como Ubuntu, Mint, Elementary, Fedora, CentOS, openSUSE, Manjaro, dentre outros.


Um Ubuntu ou mesmo Fedora são muito simples, eles já fazem tudo pra você e no final é como se tivesse instalado um Windows ou MacOS, você vai só apertando “próximo”, “próximo” e no final não aprendeu nada porque os instaladores estão bons o suficiente pra fazer quase tudo sozinhos. Mas o Arch Linux não, ele vai exigir que você realmente preste atenção, estude e vá configurando cada componente sozinho. A cada passo você não vai saber o que precisa fazer e pra ajudar existe o site ArchWiki que tem páginas inteiras detalhando cada pequeno componente do sistema em detalhes.


O Arch vai te forçar a ficar na linha de comando e digitar comandos que, mesmo que você não entenda exatamente o que está fazendo, vai te dar a primeira sensação de que você está colocando as mãos de verdade no computador. Vai ver dezenas de mensagens de erro e vai perder horas em tentativa e erro a cada passo, e quando chegar ao final vai ter aquela satisfação de que você fez alguma coisa funcionar sozinho.


Quando eu falo que as pessoas ficam supersticiosas imagina quando alguma coisa não funciona, e o que é a primeira coisa que todo mundo pensa? Ahh reboota a máquina que volta a funcionar. Nãaaao porque você vai rebootar? Primeiro tenta entender se precisa rebootar. Normalmente é quando você muda alguma configuração que algum serviço precisa, um daemon por exemplo.


Falando em daemons você vai precisar entender que você sempre tem pelo menos 2 níveis de permissão no sistema, o acesso geral de administrador ou root e o mais limitado, do seu usuário. Um Spotify roda sob os privilégios do seu usuário e não tem privilégios pra afetar coisas importantes do núcleo do sistema, como rebootar a máquina. Mas existem serviços ou daemons - e nao DA-E-MONS daemons, que aliás, não tem nada a ver com diabo mas com antigos demônios que performam tarefas em background -, que o sistema operacional começa a iniciar depois do boot e rodam sob privilégios maiores pra poder controlar coisas como sua rede, seu sistema de arquivos geral, tudo em background sem você perceber. 


Um programa que você manualmente abriu como seu editor de textos você pode matar a qualquer momento. Mas daemons, precisam de privilégios pra reiniciar, e aí você começa a aprender sobre ferramentas como o “sudo” que você vai ver em vários tutoriais, que permitem que seu usuário temporariamente tenha privilégios de administrador. No Windows isso é aquela janela de confirmação que escurece sua tela toda pedindo uma confirmação e que obviamente você nunca lê e só dá ok.


Mais do que isso, pra rodar linguagens como Javascript, Ruby, Python, PHP, Java, você precisa saber quais versões instalar porque códigos antigos podem precisar de versões mais antigas de cada linguagem. Se tentar rodar na mais nova provavelmente vai falhar. Se você tem o Python mais novo instalado na sua máquina como a versão 3, mas você entra numa empresa que precisa dar manutenção num projeto mais antigo que ainda não foi atualizado, usando digamos Python 2.6, como você faz pra ter múltiplas versões rodando na máquina ao mesmo tempo? Você vai ter que aprender que quando digita o comando “python” na linha de comando ele vai olhar uma coisa chamada PATH, uma variável de ambiente, que diz em quais diretórios procurar pelo executável. Se quiser ter múltiplas versões, basta instalar algum gerenciador dessas variáveis VIRTUALENV ou o mais poderoso ASDF que vai gerenciar o PATH e outras variáveis do ambiente pra você. Mas pra isso você precisa ter essa noção que cada linguagem é um conjunto de executáveis, coisas como interpretador, compilador, debugger, bibliotecas. Onde eles ficam na sua máquina? Como você, como programador, não sabe onde fica cada componente da linguagem que está usando? Você PRECISA saber, então corre atrás disso.


Portanto, as duas coisas mais importantes que você PRECISA aprender e treinar logo de cara é como gerenciar código usando ferramentas como GIT e serviços como GitHub e onde fica cada ferramenta que você vai usar no sistema operacional. Você precisa aprender a ter controle sobre sua própria máquina, porque a principal função de um programador é controlar as máquinas para que façam exatamente o que você quer, e a forma de dar essas ordems é através de programas gerados com o código que você escreve. Se você não consegue controlar seu sistema operacional e sequer sabe onde estão suas ferramentas e porque elas funcionam, é a máquina que vai controlar você e não o contrário. Sem isso você sempre vai fazer algum código, muitas vezes vai chutar e se realmente funciona você continua sem saber porque, e desse jeito nunca vai evoluir como programador. Coloque isso na sua cabeça, a máquina serve a você e não o contrário. Domine suas ferramentas e faça com que elas sirvam a você.


E como podem ver, hoje falamos somente das duas primeiras caixinhas. Durante a série algumas serão mais curtas, algumas serão mais longas, mas o assunto claramente é longo. Aproveitem pra dar uma olhada no Developer Roadmap e já joguem dúvidas nos comentários abaixo, talvez eu possa aproveitar algumas nos próximos episódios. Se curtiram o vídeo deixem um joinha, compartilhem com seus amigos, assinem o canal e cliquem no sininho. A gente se vê semana que vem, até mais!



 
