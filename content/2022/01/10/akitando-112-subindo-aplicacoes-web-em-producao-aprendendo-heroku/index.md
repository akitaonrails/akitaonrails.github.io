---
title: "[Akitando] #112 - Subindo Aplicações Web em Produção | Aprendendo HEROKU"
date: '2022-01-10T12:15:00-03:00'
slug: akitando-112-subindo-aplicacoes-web-em-producao-aprendendo-heroku
tags:
- heroku
- web
- deployment
- php
- kubernetes
- docker
- dokku
- 12 factors
- continous deployment
- continuous integration
- akitando
draft: false
---

{{< youtube id="TLRW_xTnQwY" >}}

Finalmente vou mostrar o que é o Heroku e como é o fluxo de trabalho mínimo de um projeto web ideal. Se você já usa Heroku, aproveite pra compartilhar o video com conhecidos que ainda não usam. Se nunca viu Heroku, prepare-se pra ficar surpreso!

## Conteúdo

* 00:00 - Intro
* 00:41 - Mega Sena da Virada
* 02:33 - Concorrência
* 04:11 - Intro a Heroku
* 04:46 - Deploy antigo
* 06:24 - Iniciando Tutorial Heroku
* 06:49 - Setup: Git é Básico!
* 07:22 - Heroku Login
* 08:18 - Primeiro Deploy
* 10:03 - Buildpack? Dockerfile?
* 10:35 - Entendendo Dynos e Containers
* 11:30 - Escalando Dynos
* 13:16 - Entendendo Load Balancer
* 16:41 - Vendo logs dos Dynos
* 17:22 - Entendendo Procfiles
* 18:58 - Mais sobre escalar dynos
* 20:21 - Entendendo Gerenciamento de Dependências
* 24:37 - Adicionando nova dependência
* 26:40 - Adicionando Addons
* 28:16 - Conectando num shell remoto
* 29:41 - Configurando com variáveis de ambiente
* 33:39 - Adicionando Banco de Dados
* 37:13 - Database Migrations
* 37:47 - Conectando no Banco de Dados
* 39:22 - Releases e Rollback
* 40:34 - Conclusão

## Links

* Mega da Virada: Loterias Caixa colocam fila em app, e site fica fora do ar (https://tecnoblog.net/noticias/2021/12/31/mega-da-virada-loterias-caixa-colocam-fila-em-app-e-site-fica-fora-do-ar/)
* Getting Started on Heroku with PHP (https://devcenter.heroku.com/articles/getting-started-with-php#set-up)

## SCRIPT

Olá pessoal, Fabio Akita


Bem vindos ao primeiro video de 2022. O video de hoje vai ser parte 1 de 2 videos. Eu queria falar sobre os famosos 12 fatores pra criar projetos escaláveis modernos. Pra fazer isso eu preciso que todo mundo já tenha visto pelo menos uma vez como é trabalhar com uma plataforma chamada Heroku. Se você já trabalha com Heroku, o que vou falar hoje é o arroz com feijão, mas vocês podem usar pra apresentar a plataforma pra amigos seus que ainda não conhece. Pra todo o resto, esse é o modelo de trabalho que você deveria almejar se nunca usou essa plataforma.




(...)





Antes de começar deixa eu responder algumas coisas que vi online depois dos últimos vídeos. No caso do exemplo que dei do ingresso.com eu terminei concluindo que se eles não tem controle sobre o sistema de reserva de assentos dos cinemas - que imagino que sejam aplicativos super antigos que não foram feitos pra escala de internet - então deveriam controlar o acesso a esses sistemas usando uma fila virtual. Ninguém acessa diretamente a reserva de assentos, cai primeiro numa página mais fácil de escalar de fila e fica esperando a vez.







Por acaso foi exatamente isso que a Caixa Econômica Federal fez pra Mega Sena da virada que ia sortear mais de 300 milhões de reais. E eles implementaram justamente uma fila virtual pra ver se aguentavam a multidão que ia tentar acessar tudo no último dia. Eu não perco meu tempo apostando em loteria porque é só garantia que vou estar dando dinheiro de graça pros outros, mas quem tentou parece que teve muita dor de cabeça mesmo tendo esse sistema de fila implementado.








Mas é óbvio. Só porque você implementou algum pattern ou arquitetura não existe nenhuma garantia que implementou certo ou que não exista nenhum outro problema que ficou pra trás. Eu não sei como eles fizeram, mas imagino pelo menos 2 problemas. O primeiro e mais óbvio é que o tráfego gerado por uma Mega Sena dessas deve ter sido absurdamente alto. No nível que até uma Amazon da vida sofreria um pouco. Então dou o benefício da dúvida que eles tentaram o máximo mas mesmo assim o tráfego foi ainda maior do que era imaginado.









O segundo problema, que acho que é o mais factível, é que o sistema foi mal feito mesmo. Não me entendam mal. Eu acho que existem sim, bons programadores, com boas capacidades técnicas e boas intenções que tentaram o máximo pra fazer isso funcionar. Porém, a grande maioria dos funcionários públicos que trabalham nos diversos departamentos e sistemas integrados provavelmente não tavam dando a mínima e foram obstáculos pros poucos que tentaram fazer as coisas direito.








Entenda a seguinte verdade: nenhum sistema feito pelo estado jamais vai ser tão bom quanto os melhores sistemas feitos na iniciativa privada. É uma impossibilidade. O motivo é muito simples: não tem concorrência. A mesma coisa vale pra empresas privadas que tem conluio com governos, que passam a ser basicamente empresas públicas com fachada de empresa privada. A maioria dos grandes monopólios só existem porque foram auxiliados pelos governos. 







Sem concorrência, pra que eu preciso fazer um sistema melhor? As pessoas têm outra opção? Não, então foda-se, vai ser obrigado a usar o que tem. Mesmo se for uma merda. E eu, que trabalho aqui, vou ser mandado embora se não funcionar? Também não, então foda-se de novo. E vai ser sempre assim. Eu sinto pena dos poucos que trabalham lá que querem fazer as coisas funcionar direito, mas vão sempre esbarrar em um monte de departamento que tá pouco se fodendo e um monte de burocracia que impede melhorias. Mas é isso aí.








Software nunca tá “pronto”. Se o lugar tem mentalidade de "terminar" o software e não mexer mais, sempre vai ser uma porcaria. O Software precisa estar constantemente atualizado, constantemente consertado, constantemente expandindo e remodelado. O problema em lugares como uma Caixa é que deve ter dezenas de sistemas que tá no esquema "tá funcionando? então não mexe!" só que eventualmente vai precisar integrar, se comunicar. Mas não tem como, daí vai nascendo dezenas de gambiarras pra fazer as coisas funcionarem ao redor dessas ilhas radioativas. Deixe passar alguns anos assim e você tem a experiência bosta que foi a Mega da virada. É simples assim.








E isso me lembrou de um assunto que eu queria explicar faz algum tempo. No video sobre a história do Ruby on Rails eu mencionei rapidamente sobre Heroku e a metodologia de 12 fatores do Adam Wiggins, um dos co-fundadores do Heroku. Objetivo hoje vai ser dar uma repassada nesses conceitos pra quem nunca viu. Se você é um programador sênior certamente já sabe de tudo isso e certamente já usa no seu dia a dia. Eu não chamaria ninguém que não segue no mínimo os 12 fatores de sênior. E eu digo o mínimo porque isso é o básico do básico e na parte final do video vou até complementar mais algumas coisas que todo mundo já deveria saber.







Os 12 fatores em si vou falar no próximo video. Pra entender os 12 fatores você precisa saber o que é Heroku. Se nunca usou Heroku faça um favor a você mesmo e veja qualquer tutorial básico de como subir um aplicativo nele. Pra um iniciante é uma experiência que muda sua forma de pensar em deploys. Pra quem é das antigas e nunca se atualizou também vai ser um choque. Quando precisava subir um projeto web pra produção, como a gente fazia nos anos 90 e começo dos anos 2000? A gente configurava um servidor remoto Linux, num Virtual Private Server ou VPS como um Linode da vida. 







Nesse servidor a gente configurava tudo manualmente via telnet ou SSH. Instalava um banco de dados como MySQL, um servidor web como Apache, alguma linguagem interpretada como Perl ou PHP, copiava os arquivos da aplicação, normalmente feita em Perl ou PHP, via FTP ou hoje em dia SFTP e pronto, tava tudo no ar. Essa stack inclusive tinha um nome, chamado LAMP, que é acrônimo pra Linux, Apache, MySQL e Perl ou PHP. Isso é tecnologia do fim dos anos 90. Entenda, se alguém fizer isso hoje em 2022, você tá parado no tempo mais de 20 anos. Ninguém em sã consciência atualiza código direto no servidor assim via FTP mais.








Eu já tinha dito no episódio do ingresso.com que o jeito errado é fazer tudo rodar numa única máquina, configurar tudo manualmente. Atualizar código direto lá é a pior forma possível de colocar uma aplicação no ar. Agora vamos ver como é o estado da arte, a melhor forma de fazer deploy tanto do ponto de vista de escalabilidade quanto de segurança. E pra isso eu vou seguir um tutorial oficial do próprio Heroku pra vocês verem como é absurdamente simples.







O tutorial começa com o básico. Você obviamente precisa ter uma conta criada no Heroku. Se ainda não fez isso, vai lá depois de assistir o video e cria a conta. Eles tem tutoriais pra quem usa Rails, Node, Java e muito mais, mas já que falei da stack LAMP, vamos ver como se sobe uma aplicação PHP. Vamos assumir que se você é de PHP já tem tudo instalado e obviamente usa Composer pra gerenciar suas dependências.








Se você for de outras linguagens como Python ou Elixir, não importa. Se nunca viu Heroku funcionando não interessa a linguagem, se atenha ao passo a passo e o raciocínio. Qualquer bom programador tem que ser capaz de no mínimo seguir o raciocínio mesmo se for em outra linguagem. Também vamos assumir que você já sabe usar minimamente Git. Se ainda não sabe, assistam meus vídeos sobre Git depois. E vocês se lembram que no video de Conhecimentos Básicos eu falo que saber Git é básico? Pois é, repito, é básico. Não tem como trabalhar em projetos modernos sem saber Git.








Agora, pra usar Heroku precisamos instalar a linha de comando do heroku. Praticamente tudo que vai precisar tem nessa linha de comando. Num archlinux da vida basta fazer um `yay -S heroku-cli`, num Ubuntu da vida dá pra instalar com Snap. Procure como instalar pra sua distro mas no final você deve ser capaz de abrir um terminal, digitar `heroku login` e vai abrir um navegador pra logar na conta que acabou de criar. E, claro, sempre habilite autenticação de duas etapas, é o mínimo.







No próximo passo ele vai mandar você fazer o clone de um projetinho de exemplo feito em PHP Symfony, que é um dos muitos frameworks web pra PHP. Symfony tem muita inspiração tanto em Rails quanto Django. Pra projetos novos recomendo usar Laravel, que tem uma comunidade mais ativa e um ecossistema que cresceu bem em torno dele. De qualquer forma, se você sabe Git, clonar um projeto é arroz com feijão. Tudo vai acontecer dentro do diretório desse projeto, então só dar `cd` pra ele.








Agora vamos subir essa aplicação de exemplo. Pra isso precisamos cadastrar uma nova aplicação no Heroku. Você pode subir quantas aplicações quiser na sua conta e pode começar com opções gratuitas. Depois pode transferir a propriedade das aplicações que subiu pra outra conta, como do seu cliente. Pra cadastrar é simples, do diretório do projeto, num terminal, só usar a linha de comando que instalamos e fazer `heroku create`. Se não disser que nome quer, ele vai inventar um aleatório. O nome em si não interessa tanto porque depois você vai registrar um domínio de verdade e apontar pra esse nome, o CNAME, então o usuário final mesmo nunca vai ver esse nome. Mas vai servir pra gente testar no domínio do Heroku.










Uma vez a aplicação registrada na sua conta, agora é só subir o código. Quando rodou o comando anterior, ele também criou um branch remoto no Git do seu projeto. Então agora é só subir o que tem na branch principal `main` que antigamente se chamava `master` pra esse remote chamado `heroku`. Relembrando, todos os remotes ficam no arquivo `.git/config`, dá um `cat` nele pra ver o conteúdo, olha o remote lá. Agora é só fazer `git push heroku main`. Olha o que vai acontecer no seu terminal. 







Se você ainda não entendeu, o Heroku criou um repositório Git remoto associado com sua nova aplicação, esse é o remote. É como se fosse um projeto novo no GitHub que você vai dar push. Mas o Git tem uma funcionalidade que você pode configurar que ele detecte quando você faz um `push` e rodar algum script. No caso, o Heroku detectou que tá subindo código PHP e por isso vai automaticamente instalar a buildpack pra ter as ferramentas de PHP que vai precisar como o próprio interpretador PHP, o Composer, Apache, NGINX e tudo mais. O que o Heroku chama de buildpack é mais ou menos o que você chamaria de Dockerfile.







Aqui vale um adendo se você já usa Docker. Por que o Heroku reinventou a roda com esses buildpacks em vez de usar Dockerfiles? Na verdade é o contrário: o Heroku precede a invenção do Docker. Na realidade, muito do Docker foi inspirado no que o Heroku fez anos antes dele. O Heroku foi lançado por volta de 2008, o Docker foi lançado só em 2013. O objetivo da vida do Docker e tudo que saiu em torno de containers como Docker Compose, Docker Machine, Dokku, até Kubernetes, é conseguir imitar o que o Heroku fez antes de todo mundo.







Vamos considerar o que tá acontecendo nesse ponto. O comando `git push` que fizemos tá mandando o Heroku fazer o equivalente a criar uma imagem de Docker, é semelhante a um `docker build`. Nos servidores deles rodam diversos containers, que eles chamam de `dynos`. Tem de diversos tamanhos, a versão gratuita são dynos de 512 megabytes de RAM, se não me engano com uns 4 cores ou núcleos virtuais fraquinhos. Se precisar, dá pra subir pra versões de 1 giga até 14 giga de RAM se precisar muito.







Mas cuidado, a grande maioria das aplicações deveria conseguir rodar suficientemente bem em 512 mega de RAM, se precisa de mais que isso precisa ver se não tá com vazamento de memória, ou você programou muito porcamente e tá enchendo a memória de lixo. Trabalhar em um ambiente mais restrito do que sua máquina local é uma boa prática. Qualquer notebook hoje tem 8 giga ou mais de RAM e você muitas vezes nem percebe que sua aplicação tá usando muito mais memória do que deveria. 







Seguindo o tutorial a próxima coisa que ele manda fazer é escalar a aplicação com o comando `heroku ps:scale web=1` que basicamente manda o Heroku subir sua aplicação num único dyno. Se mudar pra web igual a 2, ele vai subir dois dynos. O que significa isso? Vamos fazer uma conta de padeiro. Eu disse que o dyno gratuito tem uns 4 cores virtuais. Se eu configurar o apache pra pendurar um fork de processo por núcleo significa que consigo ter até 4 requisições simultâneas. Se subir 2 dynos eu posso ter até 8 requisições simultâneas. Simultâneo significa exatamente no mesmo instante. Nessa conta de padeiro estou considerando 1 requisição por processo, sem considerar opções de threads ou I/O assíncrono.








Digamos que a aplicação leve 100 milissegundos pra responder uma requisição. Então em 1 segundo daria pra responder até 10 requisições. Com 1 dyno então seria teoricamente possível responder até 40 requisições por segundo e com 2 dynos até 80 requisições por segundo, entenderam? Isso é teórico porque estou assumindo que cada core conseguiria responder 10 requisições todo segundo, mas depende se durante o processamento de cada requisição se não bloqueia algum recurso que outra requisição pode precisar, como banco de dados e coisas assim, por isso o tempo real pode variar bastante.





Containers, como Docker, como Dynos de Heroku, não são máquinas virtuais. Eu explico sobre isso no meu episódio sobre Devops. Se você não sabe a diferença recomendo que assista depois. Mas na prática só entenda que é uma forma de particionar os recursos da sua máquina e cada programa rodar isoladamente achando que está sozinho nessa máquina. Assim é possível particionar uma máquina real grandona em diversos containers menores, dividir os recursos, e te cobrar de uma forma mais fácil.






Mais do que isso, o Heroku já deixa muita coisa de infraestrutura preparada pra você. Por exemplo, eu expliquei que tem esse comando `ps:scale` que permite subir a imagem da sua aplicação em múltiplos dynos. Significa que você tem vários servidores web de pé ao mesmo tempo. Agora, quando um usuário digitar a URL pra sua aplicação ele não cai direto no servidor web da sua aplicação e sim num balanceador de carga, ou load balancer, proprietário do Heroku, que vai pegar as requisições e distribuir nos dynos que você tem de pé provavelmente usando uma estratégia como round robin. 







Se você é iniciante isso pode parecer estranho. Quando sobe um processo de servidor web na sua máquina local, seja nginx, seja apache, seja um webpy de python, tomcat de java, puma de rails, vai ser um processo pendurado em uma porta. Toda vez que no seu navegador você carrega `localhost:3000` ele vai direto pra quem responde nessa porta 3000 e é isso. Mas quando você sobe vários containers, cada um com seu próprio servidor na porta 3000, cada um dos containers tem um IP interno próprio. Faz de conta, 172.16.0.10 e 172.16.0.11.






No seu navegador você não pode mais usar localhost porque não tem mais ninguém no ip local 127.0.0.1 na porta 3000, que seria o localhost. Quando você sobe containers de Docker localmente, ele cria uma rede virtual local. Cada container de Docker que sobe ganha um IP virtual privado e nele que o servidor web da sua aplicação vai se pendurar na porta 3000 por exemplo. Se achou confuso recomendo que estude e treine Docker na sua máquina local, em particular usando Docker Compose pra orquestar cada serviço num container separado.






Você pode naturalmente digitar direto o ip privado de um dos containers como 172.16.0.10:3000 e aí vai carregar sempre só desse container, mas o segundo container vai ficar lá parado sem trabalhar. Pra conseguir acessar os dois containers, em vez de acessar direto, pode subir um terceiro container, com um load balancer como o NGINX ou HAProxy ou vários outros. Nesse load balancer você configuraria uma regra dizendo, toda vez que alguém mandar uma requisição na porta 80 eu envio pra porta 3000 de um dos dois containers que tenho cadastrado.








Isso que se chama um proxy reverso. Digamos que o container do load balancer subiu com IP virtual 172.16.0.13. Agora você pode ir no navegador e digitar `172.16.0.13` que por default vai conectar na porta 80. O load balancer vai pegar essa requisição e mandar pra um dos dois containers web respondendo nas suas portas 3000. Pro navegador é transparente. Ele não tem idéia de quantos containers web tem por baixo, nem em que portas eles respondem de verdade, nem que IPs tem. Load balancer é tanto uma forma de distribuir requisições pra mais servidores web quanto anonimizar os IPs dos servidores para que os usuários não saibam quem são.








O objetivo do episódio não é ensinar redes, mas como tem muito iniciante assistindo achei melhor pelo menos dar o resumo do resumo. Pra saber mais procurem artigos sobre load balancer, em particular tentem fazer exatamente esse cenário que eu falei: subir com Docker Compose 2 ou mais containers com uma aplicação web qualquer e outro container com NGINX configurado como load balancer e veja na prática suas requisições sendo distribuídas pelos seus containers. Tem dezenas de tutoriais que você acha no Google pra fazer isso, só não ter preguiça de procurar, pra treinar qualquer um serve.






Falando nisso, voltando pro tutorial do Heroku, o próximo passo é ver se sua aplicação subiu direito e está respondendo como deveria. Pra isso você precisa conseguir ver os logs em tempo real. Se fosse uma aplicação local era só fazer tipo um `tail log/application.log` pra ficar monitorando o que entrar no log em tempo real. Tail é inglês pra rabo, e como o nome diz a gente fica seguindo o rabo, ou seja, o final do arquivo. Pro Heroku é parecido mas só usar a linha de comando deles fazendo `heroku logs --tail`. Lógico, o `--tail` é opcional, mas se usar vai manter o log aberto e tudo que for sendo logado vai aparecendo no seu terminal. De novo, se você tá acostumado a usar Linux isso é algo super comum.







Fizemos o clone da tal aplicação de exemplo mas nem vimos o que tem nele. O principal é entender que toda aplicação que sobe no Heroku precisa ter pelo menos um arquivo na raíz do projeto chamado `Procfile`. Nele definimos que no container de tipo `web` vai executar o binário executável do apache apontando pra pasta `web`. Isso é específico de cada framework. Se fosse um Rails o executável seria `bin/rails server` e assim por diante. É assim que o Heroku sabe o que é pra executar dentro do container. Se fosse um `Dockerfile` seria o equivalente ao parâmetro `CMD`.






Não vou mostrar isso hoje, mas além de web existem outros tipos de containers que você pode declarar como `queue` ou `job` se quiser montar imagens que sobem workers pra uma fila assíncrona, por exemplo. Eu expliquei um pouco sobre filas assíncronas no episódio do ingresso.com e no de concorrência e paralelismo. O importante é saber que Heroku não sobe só aplicações web. Além disso, o formato de arquivo `Procfile` meio que virou universal. No mundo Rails você pode usar uma ferramenta como o `foreman` que vai ler esse arquivo e localmente subir sua aplicação pra simular como rodaria no Heroku. 







Você pode usar o foreman escrito em Ruby pra rodar localmente sua aplicação mesmo se for escrita em PHP, ou usar o node-foreman que faz a mesma coisa ou o goreman ou forego que são outros clones de foreman escritos em Go. Tanto faz no que é escrito porque só vai ler o que tem no arquivo `Procfile` e executar o que está lá. É uma boa prática testar localmente antes de subir pro Heroku ou outra plataforma que também suporte Procfiles.







O próximo passo do tutorial foi o que expliquei agora pouco. Como escalar sua aplicação subindo mais containers web. Só usar o comando `heroku ps:scale` e fazer `web=2` ou mais. Se quiser desligar a aplicação, tirar da web, só fazer igual a zero que vai desligar todos os containers. Você pode aumentar ou diminuir o número de containers manualmente com esse comando ou contratar um serviço de auto-escala que usa algumas estratégias pra fazer esse ajuste automaticamente dependendo da carga que sua aplicação tá recebendo.







Dizendo assim pode parecer que escalar sua aplicação é algo tão simples quanto rodar esse comando e subir 100 dynos de uma só vez em horário de pico. Mas isso não é uma bala de prata. Lembre-se que se subir 100 dynos vai precisar que recursos embaixo dele, como seu banco de dados, tanto consiga aguentar esse tanto de conexões simultâneas e ter CPU e RAM suficientes pra processar tanta coisa de uma só vez.  Escalabilidade nunca é automática, você precisa estar preparado pra isso. Na prática, essa funcionalidade é mais pra você economizar custos. Digamos que no máximo, os recursos que instalou suportariam 100 dynos de pé ao mesmo tempo. Mas de madrugada seu tráfego cai um monte e só 10 dynos seriam suficientes. Então você pode fazer um script que derruba 90 dynos de madrugada pra economizar custos e de manhã cedo sobe 90 dynos novos pra aguentar o tráfego do dia.







Agora vamos falar de dependências. Se você programa em Rails, obrigatoriamente usa a ferramenta Bundler pra gerenciar dependências. Toda nova biblioteca que precisa adicionar no seu projeto, primeiro você declara no arquivo `Gemfile` e instala a tal biblioteca com o comando `bundle update`. Você jamais vai no site da biblioteca, baixa um zip e descompacta dentro do diretório do seu projeto, isso seria uma barbárie e algo totalmente inaceitável numa sociedade civilizada moderna em 2022.






Se você programa em Javascript, Node.js, obviamente adiciona todas as suas dependências com o comando `npm install` e a opção `--save-dev` por exemplo. Ou se usa `yarn` usa o comando `yarn add`. Em ambos os casos isso vai atualizar o arquivo `package.json`, que todo projeto civilizado de Javascript tem obrigação de ter.






Se você é de Java, certamente conhece Maven e usa a ferramenta Gradle, e tudo vai estar declarado no arquivo `build.gradle` ou `pom.xml`. Se você é de Python, eu sei que é chato e ainda não é uma solução perfeita, mas deveria estar usando `pip` e todas as dependências deveriam estar no arquivo `requirements.txt`.





Se é de Go, só recentemente começaram a ficar mais civilizados e agora fazendo `go mod init` você cria um arquivo `go.mod` que é onde se declara dependências. Daí rodando o comando `go mod tidy` vai baixar as dependências que precisa pra compilar e executar sua aplicação. O Rust sempre veio com o utilitário Cargo e você sempre tem um arquivo `Cargo.toml` que declara os crates, que é como povo de Rust chama suas bibliotecas.





Entenderam? Não importa que linguagem você usa, toda linguagem civilizada tem um gerenciador de dependências padrão, sempre tem um arquivo onde se declara essas dependências, e você nunca, jamais, deve baixar bibliotecas manualmente e jogar dentro do seu repositório. Mais do que isso, todo gerenciador competente costuma ter um arquivo de tranca, de lock. Por exemplo, projetos de Javascript tem o `package.json` onde você declarou as bibliotecas e versões que queria, mas quando o `npm` ou `yarn` realmente baixam e instalam ele gera um outro arquivo chamado `package-lock.json` que você nunca deve editar manualmente, que declara exatamente quais bibliotecas e exatamente quais versões baixou.







Esse arquivo de lock é especialmente importante porque quando outro desenvolvedor dá pull e clona o repositório do projeto ou quando você dá `git push` pro Heroku, ele roda o `npm install` e vai baixar exatamente o que estiver nesse arquivo de lock. 1.0.0 é diferente de 1.0.2. Isso é importante pra todo mundo baixar exatamente a mesma versão de tudo. Basta uma biblioteca que era pra ser, faz de conta, versão 1.0.1 e no servidor baixar a 1.0.2 que um bug pode ser introduzido sem ninguém saber. Gerenciamento de dependências é uma ciência exata. Ela só fica caótica quando você não segue essas regras.








Essa longa explicação foi só pra pular pro próximo passo do tutorial onde ele rapidamente explica que nosso projeto PHP de exemplo usa um gerenciador de dependências chamado Composer. E como esperado, existe um arquivo chamado `composer.json` na raiz do projeto junto com um arquivo `composer.lock`. No caso do PHP, no arquivo `web/index.php` tem uma linha com o comando `require` carregando um `autoload.php` que é quem se responsabiliza por carregar as bibliotecas declaradas no `composer.json`.






Na sua máquina local, se fizer `compose update` vai baixar todas as dependências localmente e agora pode rodar o projeto na sua máquina. E quando fazemos `git push` pro Heroku os scripts no buildpack de PHP vão procurar o arquivo `composer.json` e se achar, vai rodar o `compose update` pra montar a imagem. E é por isso que você precisa gerenciar as dependências dessa forma, pra que outro desenvolvedor não tenha problemas quando baixar na máquina dele, e pra quando subir num Heroku ou máquina de produção sabemos que não vai faltar nenhuma dependência. Isso é crucial pra vivermos numa sociedade civilizada. Imagina como era na época da barbárie quando não tínhamos ferramentas como essas.








Vamos simular que esse projeto ainda está em desenvolvimento. Vamos adicionar uma nova funcionalidade. Pra isso começamos usando o comando `compose require` que vai declarar e puxar a biblioteca `cowsayphp` que é um programinha besta que só desenha uma vaca com caracteres ASCII. Depois disso só rodar `compose update` pra garantir que foi baixada e instalada. Se abrirmos o arquivo `composer.json` veja que ela foi declarada automaticamente pelo Composer.







Agora, no `index.php` podemos criar uma rota chamada `/cowsay` que vai usar essa biblioteca `Cowsayphp` e mandar ela desenhar a vaca dizendo "Cool beans". Vamos só copiar e colar esse trecho do tutorial no nosso projeto, e pronto. Agora precisamos adicionar tudo isso que modificamos no repositório Git. Pra isso basta fazer `git add .`. Lembrem-se que nos vídeos de Git eu falo pra tomar cuidado pra não adicionar coisas que não precisam. Por acaso esse projeto tem um `.gitignore` e se dermos `git status` podemos ver que só vamos adicionar os arquivos do Composer e o `index.php` que modificamos. Na dúvida sempre rode `git status` antes de dar `git commit`.







Finalizamos com o `git commit -m` adicionando uma mensagem descritiva da modificação que fizemos e executamos um novo `git push heroku main` pra subir a modificação e gerar uma nova imagem. Olhem o Heroku recebendo, rodando `compose update` que vai baixar a biblioteca que mandamos, vai regerar a imagem, daí ele sozinho vai desligar os dynos que estavam rodando antes e subir novos dynos com a imagem nova.






Se usarmos o comando `heroku open cowsay` ele vai abrir o navegador pra gente, já apontando pra URL da aplicação /cowsay. Não precisa desse comando, você podia abrir o navegador e digitar a URL manualmente, mas assim é mais rápido. Demora um segundo pra abrir porque o Heroku está atualizando os dynos, mas voilá, tá funcionando. E é assim que subimos versões novas da nossa aplicação. Lembram deploy contínuo que eu falei? É assim que faz.






Além de toda essa infraestrutura de containers, load balancers, facilidade de subir atualizações usando Git, o Heroku tem parceria com dezenas de empresas que oferecem serviços que são úteis pras nossas aplicações. No tutorial, o próximo passo é justamente instalar uma delas, o addon pra ferramenta chamada Papertrail. Addon é sinônimo de plugin e Papertrail é um serviço que recebe os logs da nossa aplicação e oferece uma interface web que podemos monitorar e, principalmente, fazer pesquisas.







A maioria dos addons oferece uma versão gratuita pra gente testar e pra aplicações pequenas costuma ser suficiente também. Pra instalar basta ir no terminal e fazer `heroku addons:create papertrail`. Esses comandos têm várias opções, por exemplo pra já instalar com um plano pago mais parrudo. Sempre leia a documentação de cada addon antes de sair instalando. De qualquer forma, com o comando `heroku addons` podemos listar quais já temos instalado e veja como o Papertrail já aparece.







Pra abrir a interface web no seu navegador, via terminal podemos rodar `heroku addons:open papertrail` e voilá, agora temos como fazer pesquisas nos nossos logs. Isso é mais importante se considerarmos que podemos ter mais de um dyno rodando ao mesmo tempo e no Papertrail vai concentrar os logs de todos os dynos ativos. Assim podemos pesquisar os logs de todos ao mesmo tempo. Por acaso esse é um addon que eu recomendo sempre instalar em toda aplicação. Papertrail e também o Rollbar que você pode configurar pra te notificar por e-mail se alguma mensagem de erro crítico aparecer no log.








O próximo passo do tutorial é um pouco mais avançado e eu não recomendo que você use isso se não for um desenvolvedor mais experiente. A linha de comando do Heroku permite abrir um container novo pra onde ele vai abrir uma conexão SSH segura. Dentro dele você pode rodar o shell interativo do seu framework como o `php -a` no caso de PHP ou o `rails console` no caso de Rails ou simplesmente abrir um shell bash caso queira checar alguma coisa no nível do sistema operacional. Tudo que carrega nos containers de web também carrega nesse container de console, então pode ser bom pra debugar algum bug que não acontece na máquina de desenvolvimento mas aparece quando sobe a aplicação no Heroku. Use com cuidado, mas essa opção já salvou minha vida diversas vezes.







Esclarecendo, esse comando não abre SSH direto pra um dos containers web rodando. Ele abre um novo container, com a mesma imagem que sobe nos containers web, só isso. A vantagem é que de lá você tem os mesmos acessos ao banco de dados se precisar muito rodar alguma query de emergência ou algo assim. E justamente por isso eu falo pra tomar muito cuidado, porque o que você rodar no banco vai ser permanente. Quando desconecta do shell interativo, esse container é destruído, por isso não crie ou baixe arquivos pra lá porque esse container vai sumir tão logo você se desconecte dele. É especificamente pra tarefas administrativas especiais.






Outro conceito que pra iniciantes pode não ser muito óbvio são variáveis de ambiente. Por exemplo, imagino que a maioria que usa Linux no mínimo já lidou com variáveis como `PATH` num arquivo local como `.profile` ou `.bashrc` da vida. Você faz alguma coisa como `export ABC=blabla`. Isso declara uma variável global na sua sessão e você pode ver o conteúdo da variável fazendo `echo $ABC` e vai imprimir o `blabla` no seu terminal.






Pois bem, é considerado uma boa prática declarar configurações assim como variáveis de ambiente, particularmente em containers. Se você já viu um arquivo `.env` na raíz do seu projeto, ele serve pra declarar e simular variáveis de ambiente do projeto. De novo, a gente inventou isso no Rails e todo framework web meio que adotou a mesma funcionalidade. Fazemos a configuração num arquivo pra cada desenvolvedor não precisar manualmente ficar escrevendo um monte de `exports` no seu profile local de Bash. Além disso é boa prática ter um arquivo como `.env.example` que quando clonamos o projeto fazemos uma cópia dele pra `.env`, assim não precisamos adivinhar quais variáveis existem pra usar.







E mais importante, é boa prática colocar `.env` no arquivo `.gitignore` pra nunca entrar no repositório Git. Isso porque os frameworks que suportam essa convenção, se existir o arquivo `.env` ele tem prioridade sobre as variáveis de ambiente de verdade configuradas no seu sistema operacional. Mas quando subimos pra produção não queremos que a aplicação carregue desse arquivo e sim das variáveis de verdade no sistema operacional. Então sempre se lembre dessa regra: `.env` sempre declarado no `.gitignore`.







Entendido isso, localmente na sua máquina de desenvolvimento você edita o que precisa no arquivo `.env` que só existe na sua máquina, mas em produção configura variáveis de verdade. No Heroku fazemos isso com o comando `heroku config:set`. Vamos fazer um exemplo pra ilustrar isso. Naquele arquivo `index.php` vamos adicionar mais uma rota, no caso substituir a rota raiz do site. Vamos repetir a palavra "Hello" X vezes, e essas X vezes vai estar declarado na variável de ambiente chamada `TIMES`. Pra ler essa variável, em PHP, se usa a função `getenv`.







Agora, não temos como editar um `export` no arquivo de profile de um dyno, pra isso usamos a linha de comando `heroku config:set TIMES=20`. Pra listar todas as variáveis que existem só usar o comando `heroku config`. Olhem como tem uma variável do Papertrail que foi criado pela linha de comando que usamos pra adicionar o addon, esse é o token secreto de acesso. Não tem problema ter coisas como tokens e senhas em variáveis de ambiente, porque elas só existem dentro do container. Se alguém conseguiu ver esse token é porque ganhou acesso ao seu container de produção e seu problema é bem maior do que só ter o token exposto, você está com tudo exposto. Ninguém jamais deve ter acesso direto aos containers.







E pra reforçar, é exatamente por isso que nunca se deve adicionar arquivos como `.env` no repositório Git, porque normalmente guardamos coisas como senhas e tokens em variáveis de ambiente, e esse tipo de informação, jamais, sob nenhuma hipótese, pode aparecer dentro de um repositório Git. Nenhuma credencial ou segredo jamais deve estar no código fonte do projeto. Tem que ser um tosco de proporções bíblicas pra pensar em colocar segredos num versionador de código que todo mundo tem acesso.





E pronto. Agora podemos fazer `git add .`, `git commit -m` e uma mensagem e finalmente `git push heroku main` de novo. Ele vai criar uma nova imagem com as modificações que acabamos de fazer e se abrirmos o navegador com `heroku open`, esperamos um segundo pro Heroku derrubar os dynos e subir com a imagem nova e, voilá, veja "Hello" repetido 20 vezes.






E como mencionamos “banco de dados” algumas vezes, o último passo do tutorial é justamente adicionar Postgres na nossa aplicação. Assim como o Papertrail, Postgres é um addon que tem diversos tamanhos e preços e você deve checar as opções antes de adicionar. Isso porque se pegar um muito pequeno e precisar dar upgrade, o processo não é simples e muito menos trivial. Leia a documentação do Heroku sobre isso. Uma das melhores coisas do Heroku é justamente o serviço de banco de dados, que é um dos melhores que existem, mas você precisa ter um mínimo de noção do que tá fazendo. Eles não fazem mágica nem são à prova de idiotas.







Avisos dados, pra adicionar a versão gratuita menor, que se chama `hobby-dev`, basta digitar no terminal `heroku addons:create heroku-postgresql:hobby-dev`. Agora vamos adicionar uma funcionalidade no nosso projeto PHP pra conectar no banco e listar o conteúdo de uma tabela em HTML, o arroz com feijão só. Pra isso começamos usando o Composer pra adicionar a biblioteca de PDO que é PHP Data Objects. Se você é de Java ou .NET da vida, é a mesma coisa que um DAO da vida.







Fazemos `compose require csanquer/pdo-service-provider=~1.1dev` que vai baixar uma versão compatível mas não necessariamente exata com 1.1dev dessa biblioteca, lembram? Por isso precisamos ter um arquivo de lock que vai registrar a versão exata que ele achou e baixou. Rodamos um `compose update` pra garantir que baixou tudo e agora podemos alterar o arquivo `index.php` de novo pra configurar o acesso ao banco de dados. Vamos copiar e colocar do tutorial.






O importante é saber que é uma convenção do Heroku ter a URL de acesso ao banco declarado numa variável de ambiente chamada `DATABASE_URL`. Podemos ver ela usando o comando `heroku config` e olha só. E esse trecho de código que copiamos e colamos é pra pegar o conteúdo dessa variável com a função `getenv` e parsear os diversos componentes dessa string e passar pra biblioteca de PDO configurar coisas como username, password, host, porta e path pra conseguir conectar no novo banco de dados Postgres. E simples assim, subimos um banco de dados seguro e funcional na nossa infraestrutura.







Agora vamos criar uma nova rota lá embaixo chamada '/db'. Ele vai usar esse PDO pra mandar uma query pro banco e fazer um loop com `while` pra ir montando um array com todos os nomes que voltaram da query. E pra montar o HTML, o framework Symfony oferece um sistema de template chamado Twig. Passamos o array de nomes pro template chamado de `database.twig`.






Então precisamos criar um novo arquivo `views/database.twig` e vamos copiar e colar o template do tutorial nele. Ele vai pegar cada nome que veio no array que passamos pra ele e montar uma lista em HTML, nada de mais, arroz com feijão. Isso tudo feito, vamos adicionar as modificações no Git com `git add .`. Com `git status` podemos ver que modificamos os arquivos do Composer, o `index.php` e criamos um arquivo novo `database.twig`. Está correto então podemos fazer `git commit -m` com uma mensagem descritiva e finalmente `git push heroku main` pra mandar as modificações pro Heroku.







Espero que a essa altura você já esteja acostumado com o processo de criar uma nova funcionalidade, adicionar no Git, mandar pro Heroku e conseguir testar de verdade. O Heroku recebe a modificação, monta uma nova imagem, derruba os dynos que estavam rodando e sobe de novo com a nova imagem. Só tem um probleminha.







Note que criamos um novo banco de dados, mas ele está vazio. Em qualquer framework web moderno existe um recurso chamado Migrations, mais uma coisa que nasceu no Ruby on Rails e todos os outros frameworks imitaram, onde criamos scripts que vão criar as tabelas e índices que precisamos, caso já não existam, e também já pré-cadastram coisas como conta de administrador, se precisar. Isso tudo fica em scripts que declaramos pro Heroku executar na próxima vez que subir dynos novos. Procure a documentação do seu framework e aprenda sobre Migrations porque é super importante.







Como isso é só um tutorial simples, tentando ser didático pra ensinar sobre o Heroku e não sobre seu framework, ele pula qualquer coisa sobre Migrations e manda você abrir um novo container de shell, lembra? Que nem abrimos o bash remoto? Só que no caso agora é abrindo o console do Postgresql que é o `psql`, então vamos fazer isso usando o comando `heroku pg:psql`.






Agora abriu o console remoto lá no servidor do Heroku já conectado no nosso novo banco de dados. Só precisamos fazer isso uma vez, mas vamos copiar do tutorial o comando pra criar a tabela chamada test_table e em seguida vamos dar insert em alguns valores aleatórios como esse 'hello database' e também um 'hello world', por que não? Pronto, pra sair do console do Postgres é só digitar `\q`.







Podemos abrir o navegador de novo usando o comando `heroku open db` que é a nova rota que criamos e voilá, veja que conseguiu executar a query no banco, trazer as duas linhas que acabamos de inserir, e montar o HTML com elas. E pronto, nesse estágio fomos capazes de criar uma nova aplicação no Heroku, ir subindo novas funcionalidades à medida que fomos codificando, configurando o ambiente e cadastrando novos addons como o Papertrail e Postgres. Esse é o básico do básico sobre Heroku que todo mundo deveria saber. Mas o Heroku faz bem mais que isso. No fim do tutorial, no último passo, ele dá links pra outros artigos como o "How Heroku Works" que vai começar a explicar muito mais detalhes sobre o ciclo de vida de uma aplicação em dynos.








Por exemplo, lembram que durante o tutorial repetimos `git push heroku` várias vezes? Todas as vezes ele cria uma nova imagem com as últimas modificações, derruba os dynos rodando a versão antiga e sobe tudo de novo com a imagem nova. O que eu não expliquei é que as imagens antigas continuam disponíveis se precisar. O Heroku chama isso de releases ou lançamentos. Se rodar o comando `heroku releases` podemos ver tudo que subimos desde a primeira vez. Ele vai numerando cada release e acho que você pode cadastrar tags nelas também pra facilitar achar depois.






A vantagem mais imediata é: digamos que você subiu uma nova versão que não testou muito bem e, surpresa, começou a dar pau em produção. Em vez de ficar tentando consertar na tentativa e erro durante o sufoco, podemos rapidamente dar rollback pra última release que sabemos que tava funcionando, por exemplo `heroku releases:rollback v10`. A versão 11 que acabamos de subir dá pau, mas a versão 10 funcionava, então voltamos pra ela. É o tipo de coisa que você nunca ia conseguir fazer rápido e organizado assim se estivesse atualizando código fonte manualmente usando FTP. E é por isso que você paga mais por isso também.








Eu normalmente não gosto de fazer videos de tutoriais de ferramentas específicas porque elas envelhecem muito rápido. Mas assim como no caso de Git, o Heroku existe faz mais de dez anos e continua funcionando basicamente do mesmo jeito. Esse mesmo tutorial que funcionaria em 2010 continua funcionando em 2022 e provavelmente vai continuar funcionando por muitos mais anos do mesmo jeito e toda nova solução de devops que aparece é pra tentar se aproximar desse ideal de fluxo de trabalho. Por isso, mesmo que você não use no seu trabalho atual, acho muito importante que se familiarize com esse jeito de trabalhar.





No próximo episódio vamos pegar o que aprendemos hoje pra discutir um pouco mais sobre arquitetura e gerenciamento de projetos ágeis de verdade. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e compartilhem o video com seus amigos. A gente se vê, até mais!
