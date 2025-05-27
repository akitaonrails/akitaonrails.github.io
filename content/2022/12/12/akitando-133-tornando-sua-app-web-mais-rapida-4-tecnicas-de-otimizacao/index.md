---
title: "[Akitando] #133 - Tornando sua App Web Mais Rápida! | 4 Técnicas de Otimização"
date: '2022-12-12T09:30:00-03:00'
slug: akitando-133-tornando-sua-app-web-mais-rapida-4-tecnicas-de-otimizacao
tags:
- otimização
- frameworks
- caching
- cdn
- database
- banco de dados
- nosql
- aws
- azure
- heroku
- rds
- sqs
- redis
- memcache
- new relic
- akitando
draft: false
---

{{< youtube id="KyqFXVVgvIs" >}}

Por que a aplicação que você tem feito vendo tutoriais e cursos online é BEM diferente do que equipes profissionais realmente fazem de verdade? Por que só "estar funcionando" não é o suficiente? 

Se você já é um profissional da área, tudo que vou dizer é o arroz com feijão,  mas estou facilitando seu trabalho: compartilhe com os júniors ao seu redor. E se você é iniciante, é hora de começar a ver o que diferencia sua pequena aplicação das de verdade.

O episódio de hoje não vai focar em nenhuma linguagem nem framework específicos. Os conceitos de otimização de aplicações web servem pra qualquer um. Cada uma das técnicas é assunto pra um curso inteiro. Tem muitos detalhes, muito caso-a-caso, mas a idéia hoje é dar uma visão geral da importância de não só "sair codando" e prestar atenção no que está se codando.


## Capítulos

* 00:00 - Intro
* 01:19 - CAP 1 - Recapitulando como Requisição Web Funciona
* 04:55 - CAP 2 - Multi-processos e Proxy Reverso - Balanceando Carga
* 11:35 - CAP 3 - Calculando Uso de Recursos - Pool de Conexões
* 18:00 - CAP 4 - Estratégia de Caching - Economizando Recursos
* 21:46 - CAP 5 - Bancos de Dados Relacionais, NoSQL, difenças e quando usar - Replicas
* 28:23 - CAP 6 - Jobs Assíncronos - Devolvendo Rápido
* 37:05 - CAP 7 - Resumo Até Agora - Diagramas
* 41:32 - CAP 8 - Calculadoras e Monitores - Dados Analíticos
* 43:58 - CAP 9 - CDN - Assets mais Rápidos
* 48:31 - Bloopers


## Links:

* Heroku DB Connection Calculator (https://judoscale.com/heroku-postgresql-connection-calculator/)

## SCRIPT

Olá pessoal, Fabio Akita

Hoje vai ser um tema bem complicado de acompanhar, mas é pra vocês programadores iniciantes fazendo cursos superficiais ou aprendendo a fazer suas primeiras aplicações Web. O objetivo é tentar explicar qual a diferença do seu app que acabou de conseguir fazer subir na sua máquina depois de ver alguns tutoriais e o que se faz em aplicações de empresas de verdade como Amazon ou Mercado Livre da vida. Por que o ecommerce que você fez passo a passo assistindo um video no YouTube não se parece com nada com uma aplicação de verdade? Qual a diferença? Vamos entender.




(...)





O que vou mostrar hoje existe detalhado em diversos tutoriais, blog posts, documentação, pra cada framework web. Eu poderia mostrar exatamente qual o jeito que se faz em Ruby on Rails, ou em Spring Boot, mas eu quero que o foco não seja a linguagem ou framework, mas sim os conceitos. Em outro episódio talvez explore um pouco mais no nível do código, mas pra hoje os conceitos são mais importantes do que o código em si, que você pode achar facilmente no Google. Tudo que eu disser aqui é válido pra qualquer framework web. Não existe nada que uma linguagem ou framework faça que outra também não faça. Muita gente pensa que o segredo é escolher a linguagem certa, mas não, é saber como as coisas funcionam além do passo a passo.







Vamos recapitular rapidinho. Você abre seu navegador e chama amazon.com.br. O navegador empacota esse pedido no que chamamos de um HTTP Request, uma estrutura de dados que segue o protocolo HTTP. Esse pacote sai da sua máquina via rede, cai na internet, como expliquei nos episódios sobre redes, e chega até um dos servidores da Amazon. Seja lá no que é feito a aplicação web deles, possivelmente Java, recebe essa requisição. Ele monta a página HTML, empacota num HTTP response, de resposta, e devolve pela mesma conexão de volta pro seu navegador que, finalmente, renderiza a homepage deles pra você ver.







Se abrir o Developer Tools e ir na aba de Rede dá pra ver exatamente o cabeçalho do pacote de requisição aqui, olha só o endereço que pedimos e outros detalhes como que navegador está usando. E em seguida temos o pacote de resposta, que contém um cabeçalho com um código de resposta 200, que significa que deu tudo certo e no corpo vem o HTML.







Se estiver estudando front-end ou mesmo se baixar um template pré-pronto, acho que todo estudante assistindo aqui consegue imaginar fazendo essa página em Laravel, Express, Spring, Django ou Rails. Basta ter um banco de dados qualquer seja em MySQL ou Postgres ou Mongo, montar o HTML e devolver. Um pseudo código seria mais ou menos assim: um template HTML, e uma lógica que faz select na tabela de produtos, pega os 10 ou 20 primeiros, e monta a lista de produtos em HTML. 







Qualquer um que tenha assistido qualquer curso online sabe fazer até aqui, certo? Se for uma aplicação em Rails você sobe ela com o comando `rails server`, se for Django sobe com `python manage.py runserver`, se for express pode subir com `npm run dev` ou seja lá como chamou a task. Se for Laravel vai subir com `php artisan serve`. Se for Spring vai subir com `gradlew bootRun`. Se for Elixir Phoenix vai subir com `mix phx.server`. Todo framework tem uma forma de iniciar o servidor web que vai servir a aplicação.







Se funciona assim na sua máquina, provavelmente já imaginou que bastaria então criar um servidor remoto na DigitalOcean, Linode, AWS, Azure, instalar a linguagem, clonar o código fonte do seu projeto e executar o mesmo comando no servidor, e pronto, tá terminado né? Você já é um programador web. Fácil. Basta agora registar um domínio, apontar pra esse servidor e pronto, seu site está no ar. E sim, esse é o jeito errado de fazer. Agora que a coisa começa.







Já notou que quando sobe uma aplicação web na sua máquina, o framework costuma subir numa porta como 3000 ou 4000 ou 8080? Tudo menos porta 80? Mas acho que até o mais iniciante, ou se assistiu meus videos de rede, sabe que o navegador, por padrão, manda requisições HTTP na porta 80 ou 443 dos servidores. Então porque o framework já não deixa sua aplicação rodando na porta 80 direto? Dois motivos. Primeiro porque pra subir na porta 80 precisa ter privilégios de administrador, daí você seria obrigado a subir usando o comando `sudo` toda hora, o que não é recomendado. Mas em segundo lugar, porque nenhum framework web foi feito pra rodar diretamente exposto na internet na porta 80.








Por exemplo. Tirando Java e Elixir, que são linguagens com suporte a threads reais e multi-thread, todas as linguagens de script, Javascript, PHP, Python e Ruby, são feitos pra rodar primariamente numa thread só. Sim, eles tem um certo suporte a múltiplas threads, mas via de regra, assuma que cada processo que sobe, tem capacidade de saturar somente um dos núcleos da CPU da sua máquina ou do servidor. Pode fazer o teste, faça um código que fica sei lá, fazendo um loop infinito fazendo qualquer coisa, e rode. Agora abra um monitorador de CPU como htop, e vai ver que sua máquina tem várias CPUs, mas a maioria delas não está sendo usada.







Se for instalar num servidor digamos, de 4 núcleos, o certo é subir sua aplicação web 4 vezes, um processo por núcleo. Talvez um pouco menos, depende da carga, já falo disso, mas só um processo vai desperdiçar sua CPU. Um dos processos pode subir na porta 3000, o segundo na porta 3001, a outra na 3002 e assim por diante. Cada processo precisa dar bind numa porta diferente. Mas aí fodeu, como que o navegador do usuário vai saber com que porta conectar? Você nunca teve que digitar amazon.com.br dois pontos 3002, por exemplo.







Como eu disse, nenhum framework web foi feito pra ser exposto direto na internet. Processos web sempre ficam atrás de um balanceador de carga, um outro programa como HAProxy ou, o mais comum hoje em dia, NGINX. Eles fazem um processo chamado Proxy Reverso. Quem fica exposto na porta 80 ou 443 é um NGINX. Os usuários mandam requisições pra esse balanceador de carga que, por sua vez, sabe que tem 4 processos nas portas 3000 a 3003 de pé no servidor por trás e fazem round robin ou alguma outra estratégia de balanceamento pra mandar uma requisição pra cada processo, tentando manter todos igualmente ocupados.








O usuário final não sabe que na primeira vez caiu no processo na porta 3002, quando clicou num link pedindo outra página, caiu na porta 3003 e assim por diante, pra ele é transparente, porque só enxerga o balanceador de cargas. E o processo atrás, também não sabe que existe um balanceador na frente, ele recebe a requisição HTTP como se o usuário tivesse conectado direto nele, como se faz na sua máquina local de desenvolvimento quando pede "localhost:3000" no navegador. Mas esse é o primeiro jeito mais simples do que chamamos de escalabilidade.







Faz de conta que a lógica que você fez no seu código, pra puxar produtos do banco de dados, montar o HTML e tudo mais leve em média 100 milissegundos. Significa que esse um processo que você subiu na porta 3000 tem capacidade de responder até 10 requisições por segundo, já que um segundo tem mil milissegundos. Se vier mais do que 10 requisições no mesmo segundo, os que vieram depois ficam numa fila esperando o processo desocupar. Por isso subimos mais de um processo na mesma máquina. Se subirmos 4 processos nos servidor, a grosso modo, passamos a suportar 40 requisições por segundo. É isso que chamamos de throughput do servidor, que é a capacidade de quantas requisições ela consegue responder por segundo.









Nenhum programador iniciante pensa nisso, mas o código que você faz tem um limite de quanto consegue responder por período de tempo. Não é mágica. Quanto mais gente for usar sua aplicação, ou subimos mais processos, em mais servidores, ou damos um jeito de fazer a requisição ser respondida mais rápido que 100 milissegundos pra ter mais capacidade no mesmo processo. Por isso que a gente tira tanto sarro de programador copy-e-paste de stackoverflow, porque vocês que fazem isso às cegas, estão adicionando código que diminui a capacidade de resposta de cada processo.








Um proxy reverso como NGINX serve como primeira barreira de segurança. Ele é um software mais simples, melhor otimizado, mais seguro, e que muda muito menos que o servidor web que vem com seu framework, seja o Tomcat de Java ou o Puma de Ruby ou o Cowboy de Elixir. É boa prática esconder eles atrás do NGINX. Mas não só isso, além de servir pra balancear a carga de requisições entre vários processos, é nele que também instalamos coisas como o certificado SSL pra abrir conexões seguras via HTTPS. O navegador fecha uma conexão encriptada com o NGINX, mas atrás dele, o NGINX manda HTTP não criptografado pra sua aplicação. Dessa forma, sua aplicação não precisa se preocupar em lidar com coisas com certificados, o que facilita muito mais o gerenciamento de infraestrutura pros devops.









Sem entrar em detalhes, no mundo Kubernetes esse é o papel do controlador Ingress, que pode usar o NGINX como proxy reverso também. Em resumo, uma aplicação de verdade vai ter NGINX balanceando carga pra múltiplos processos da sua aplicação web, possivelmente em múltiplos servidores. Só que mesmo NGINX também não escala infinitamente. E se meu balanceador de carga estiver no limite?







Tem vários jeitos de resolver isso e um deles é direto no DNS. Quem assistiu meus videos de rede vai lembrar que quando pedimos pro DNS resolver um domínio, o DNS devolve um endereço IP. Esse é o endereço IP pro servidor que tem o NGINX ou equivalente. Mas no caso de serviços muito grandes como Google ou Amazon, eles devolvem múltiplos endereços IPs. E essa é a razão: porque tem vários servidores de balanceamento de carga. Inclusive tem um conjunto de servidores específicos pra cada região geográfica. Se pedirmos amazon.com do Brasil, vai voltar um conjunto de endereços pra servidores daqui. Mas se estiver no Japão, vai receber um conjunto de endereços diferentes pra servidores da Ásia. É assim que uma Amazon da vida consegue escalar em nível mundial.








Lógico, pra maioria de nós, um único servidor de NGINX costuma ser mais que suficiente, mas é bom saber que essas técnicas existem. E aí você pensa. Beleza, entendi. Se eu fiz uma homepage que responde em 100 milissegundos, e eu subir 4 processos num droplet da DigitalOcean, significa que consigo responder até 40 requisições por segundo. Se ver no Analytics que minha campanha de marketing deu certo e o tráfego está subindo pra 80 requisições por segundo, das duas uma, ou eu faço upgrade na máquina pra ter 8 núcleos pra subir o dobro de processos, ou subo um segundo servidor pra subir 4 processos novos. Reconfiguro o NGINX pra saber que existem esses 4 novos processos e ele passa a balancear a carga pra lá também. 








Quando fazemos upgrade da mesma máquina, chamamos de "escalabilidade vertical", quando colocamos máquinas novas embaixo do balanceador de carga, chamamos de "escalabilidade horizontal". E falando desse jeito parece simples. Se o tráfego aumentar pra 400 requisições por segundo, é só subir 10 servidores embaixo do NGINX certo? Só que não, quem dera fosse fácil assim. O que vou falar agora tem muitas nuances por causa do comportamento de múltiplas threads, mas vou tentar simplificar pra ficar fácil de visualizar, só entenda que é mais complicado que isso.








Lembram do video de Heroku? Eu ainda recomendo como melhor lugar pra iniciar, mesmo tendo cancelado os planos gratuitos. Pra só brincar, precisa achar outro lugar, mas se pretende colocar um ecommerce no ar e queria colocar num plano gratuito, você precisa repensar seu negócio. Uma aplicação que sequer consegue pagar a própria infraestrutura, tem problemas muito mais sérios do que custo de máquina. Uma das vantagens é que essa parte toda de balanceador de carga NGINX é transparente. Eles gerenciam, você só precisa mandar subir os processos no servidores deles, que eles chamam de dynos. E o balanceador é automaticamente reconfigurado.








Tem uma calculadora online que vai nos ajudar a ilustrar o que eu quero dizer aqui. Olha só. Digamos que estamos naquele cenários de 400 requisições por segundo. Num dyno pequeno de 4 cores, a recomendação é subir 3 processos. Se pegar um dyno maior o recomendado é subir o total de cores menos um. Lembra que o sistema operacional também precisa de um pouco de CPU pra gerenciar o que roda por cima, por isso não queremos saturar tudo só com nossa aplicação. Você tem que saber pensar essas coisas. Então vamos subir 3 processos, só que aí, pra responder 400 requisições por segundo, 10 requisições por processo, dividido por 3 processos, vamos precisar de pelo menos 13 dynos.








Eu disse que linguagens de scripts lidam com múltiplas threads diferente de Java ou Elixir. Eles tem threads, só não conseguem rodar todas em paralelo o tempo todo. Eu falo sobre isso no episódio sobre concorrência e paralelismo. Mas na prática podemos configurar cada processo pra aceitar, digamos, 5 threads, ou seja, 5 conexões simultâneas. Não pensem muito sobre isso agora. Mas o importante é o número a seguir: 5 conexões a banco de dados no pool de conexões. O que diabos é um pool de conexões?








Conexão a banco de dados é uma operação que custa recursos do banco de dados. Não dá pra ficar abrindo conexão infinitamente. Estão notando um tema no video de hoje: nada é infinito em programação. Você como iniciante só não sabe disso porque só testando seu programinha do tutorial sozinho é muito pouco pra chegar no limite. Mas na internet, com milhares de usuários de verdade usando, toda hora vai esbarrar em limites e sua função, como programador, é saber como gerenciar esses limites. Pensa assim, cada sessão de uma conexão no banco de dados precisa ser registrada em algum lugar. Esse registro vai gastar memória e CPU. Quanto mais conexões, mais memória e CPU vai se gastar pra gerenciar todo mundo. 








Seja o processo da sua aplicação web ou o processo do banco de dados, sem um limite, uma de duas coisas vai acontecer: ou vai acabar memória, ou vai acabar processamento. Mas um dos dois vai acabar. Quando isso aconteder, tudo trava e pára de responder. Não queremos que isso aconteça, então configuramos limites, pra conseguirmos pelo menos ter processamento pra rejeitar e devolver erro caso um dos limites seja atingido. Antigamente a gente deixava rodando até passar do limite e era o caso onde páginas na web ficavam com ampulheta de "carregando" por minutos, sem resposta. Hoje tomamos um timeout pelo menos. 







Uma das técnicas que adotamos lá na virada do século foi pool de conexões. Digamos que minha aplicação Java mal feita saísse abrindo conexões e esquecendo de fechar elas. Rapidamente o limite do banco ia estourar. Se o mesmo banco fosse usado por várias aplicações diferentes, bastava uma mal feita, pra saturar todas as conexões. Em vez disso limitamos a quantidade que cada aplicação pode usar. A aplicação deixa de conectar direto no banco, em vez disso ela se conecta num pool, e esse pool mantém um certo número fixo de conexões abertas.







No exemplo da calculadora, cada processo da sua aplicação pode ser configurado com 5 conexões. Se tiver 3 processos no mesmo dyno, cada dyno vai consumir 15 conexões com o banco. Se o banco suportar até 150 conexões, dá pra subir até 10 dynos, em teoria. E isso deveria ser suficiente. Se cada processo aceita até 5 threads simultâneas, e cada thread precisar de uma conexão, vai ter pelo menos 1 pra cada. Quando a thread terminar de usar a conexão, ela devolve pro pool, pra poder ser reusada por outra thread. 







O pool faz meio que o papel do NGINX entre o navegador do usuário e sua aplicação, é um intermediário de balanceamento. No caso, a função do pool de conexões é permitir múltiplas threads da aplicação reusar conexões já existentes em vez de toda hora tentar abrir novas conexões. E com isso conseguimos controlar a quantidade máxima de conexões sendo utilizadas ao mesmo tempo.







Serviços como o Heroku Posgres ou AWS RDS tem diversos planos de tamanhos e preços diferentes. Um iniciante pensa num plano de banco de dados mais como dólares por capacidade de armazenamento de dados. Sei lá, 10 dólares pra 1 terabyte, 100 dólares pra 10 terabytes ou algo assim. Mas mais importante que total de armazenamento é qual o máximo de conexões que cada plano oferece. Um plano básico de Heroku Postgres, pode oferecer, digamos 120 conexões no máximo.








Ou seja, de acordo com a simulação que fizemos na calculadora. Subindo minha aplicação em 13 dynos, com 5 threads cada, com um pool de 5 conexões, 13 vezes 5 vezes 5, significa que preciso de no mínimo 195 conexões pro banco de dados. Ou seja, um plano básico de 120 conexões máximas, já não vai dar. Se realmente tiver as tais 400 requisições por segundo, das duas uma, ou eu pago mais e aumento meu plano de Postgres, ou uso um paliativo que é colocar um gerenciador de conexões como o pgbouncer na frente do Postgres.








A grosso modo funciona assim. Antes, na sua máquina, sua aplicação conectava direto no banco de dados. Não fazemos mais isso, todo framework decente já trás um pool de conexões pra você usar e é ele quem se conecta no banco. Mas podemos colocar uma camada a mais e o pool também não fala mais direto com o banco e sim com outro intermediário, o pgbouncer. O pgbouncer vai usar no máximo uns 75% do máximo de conexões do banco, nesse exemplo seriam 90 conexões. Mas ele tem capacidade de deixar até 10 mil pedidos de conexão pendurados em cima dele antes de dar erro. 







Significa que não vamos tomar erro de falta de conexão, mas as requisições precisam esperar mais tempo e se ficar pesado demais, tomar timeout de qualquer jeito, só estamos tentando esticar um pouco mais. É como se fosse a fila de um Poupatempo ou cartório da vida. Só tem 90 atendentes, mas tem 195 pessoas na fila. As primeiras 90 são atendidas imediatamente, o pgbouncer são as cadeiras de espera pras outras 105 ficarem esperando com a senha pra serem atendidos. A solução de todos os limites em programação é a mesma de uma repartição pública: fazer fila e esperar a vez.








Só que isso é um paliativo. Significa que se antes cada requisição era respondida em até uns 100 milissegundos, agora pode levar mais tempo, talvez 120 milissegundos. Isso muda a conta toda que fizemos até agora. Se o número de processos por dyno é fixo, precisamos subir mais dynos. Mas se subirmos mais dynos e carregarmos mais processos, isso vai pressionar mais o pool de conexões, que vai exigir mais conexões ao banco de dados. Estão ententendo como as coisas não são fáceis?








Existem várias formas de resolver isso. Chegamos ao limite do que só configurando infraestrutura pode fazer. Será que não dá pra resolver isso no código? Opa, talvez sim. Dos 100 milissegundos que sua aplicação web leva pra montar a homepage, 50 é gasto só mandando a query de select pro banco, recebendo as linhas de resposta e processando esses dados. Mas pensa comigo, no seu ecommerce pequeno, literalmente todo mundo que pedir a homepage vai acabar vendo os mesmos produtos, não vai? Se vieram 400 requisições de homepage, você fez 400 pesquisas no banco de dados que ficou respondendo 400 vezes a mesma coisa. Isso é um puta desperdício.








Todo framework web que se preza já tem embutido recursos pra fazer cache. Cache é guardar a última resposta pra não reprocessar tudo de novo a mesma coisa. Se fizermos a implementação mais simples e tosca, fazemos um código pro seguinte: procure por um arquivo local chamado "cache-homepage". Se não tiver, faça a mesma coisa de antes: solicite uma conexão ao banco pro pool, mande o select pra fazer a pesquisa, receba as linhas de resposta, processe e monte o HTML baseado nos produtos recebidos. Mas agora, antes de devolver pro usuário, grave um arquivo local chamado "cache-homepage". Pronto.








Na segunda requisição por homepage que vier, agora ele vai encontrar esse arquivo, podemos checar que esse arquivo não é mais velho que 5 minutos, faz de conta, e pulamos toda a parte de falar com o banco de dados, devolvendo direto o que estiver nesse cache. Entenderam? Vamos fazer as contas. Digamos que subimos só 8 dynos, com 3 processos cadas, 5 threads e 5 conexões no pool, o que vai consumir todas as 120 conexões que o banco Postgres que contratei suporta no máximo desse plano. Daí começa a vir requisições. Digamos que o NGINX balanceou perfeitamente e as primeiras 8 requisições que chegaram mandou um pra cada um dos 8 dynos.







Em cada dyno, o processo que respondeu primeiro fez conexão com o banco e deixam esse arquivo "cache-homepage" pra trás. Agora chegou o resto das 392 requisições durante 1 segundo. Sabe quantas conexões pro banco foram abertas nesse segundo? Antes precisava de 195. Agora precisou de zero. Sacaram? Zero! Porque toda requisição que veio depois que o arquivo de cache foi gravado, leram direto desse arquivo e não precisaran conectar nem no pool, nem no banco. E se arbitrariamente estabelecermos que a lista de produtos não corre risco de sofrer alterações durante 5 minutos, por 5 minutos, essa homepage passa a consumir zero conexões com o banco de dados.








Esse é o tipo de otimização simples com alto impacto. Antes precisávamos de 195 conexões com o banco por segundo, agora precisamos de não mais que uns 10 a cada 5 minutos. E como 50 milissegundos por requisição era gasto só nesse trabalho com o banco, significa que na média eu diminuí o tempo de cada requisição pela metade! Sem trocar linguagem, sem trocar framework, sem reescrever a aplicação. Eu poderia diminuir pela metade a quantidade de dynos pra responder as mesmas 400 requisições por segundo. Ou deixo como está e posso fazer mais marketing pra dobrar o tráfego e ainda consigo responder todo mundo com folga. 






Vou insistir no conceito pra martelar na cabeça de vocês. Trocar de linguagem ou framework, sair de Python e ir pra Javascript, ou sair de Dotnet e ir pra Java, sair de Laravel e ir pra Express, ou qualquer coisa assim, pode dar alguma diferença pequena em algumas partes. 5%, 10%. Mas técnicas como essa de cache, colocadas em lugares inteligentes de alto tráfego, podem economizar recursos em ordens de grandeza, 5x, 10x, ou até mais. É esse o tipo de otimização que vale a pena fazer. Gastar semanas, pra ter ganho de 1%, 2%, não vale a pena. Gastar horas pra ganhar 5x, 10x, isso sim vale a pena.








Eu falei arquivo só pra explicar o conceito mais fácil, mas na realidade não usamos arquivos pra cache. Usamos um segundo banco de dados mais leve, como um Memcache ou Redis. São bancos que não tem as garantias de um Postgres de atomicidade, consistência, integridade ou durabilidade, ou seja, pode ser que eu mande gravar e ele não grave um registro, pode ser que grave mas quando for ler não está lá ainda, pode ser que grave duas vezes. 







Se fosse um banco de dados de pagamento isso seria um problema. Mas pra cache não. Não tem problema, porque a lógica da aplicação que fizemos é: se existir no cache e não expirou, usa, se não existir, conecta no banco, remonta o HTML e grava um novo cache. 








Não ter essas garantias significa que o Memcache ou Redis conseguem executar muito mais rápido e aceitam uma ordem de grandeza mais conexões simultâneas. Por isso configuramos um Memcache, que é um serviço barato, e fazemos essa lógica de cache pra ler e gravar do memcache em vez de um arquivo. A desvantagem é que precisamos pagar mais um serviço. Mas ele é barato e economiza mais ainda os recursos do banco, porque antes cada dyno precisava gerar seu próprio arquivo de cache, então quanto mais dynos, mais continua precisando puxar do banco na primeira vez. Agora só precisa uma vez e todos os dynos lêem do mesmo memcache.









Memcache como o próprio nome diz, é Memory Cache. É literalmente um cache em memória. Por isso que quando o servidor de memcache reinicia, perde tudo que tinha armazenado. Mas não tem problema, porque toda aplicação que depende do cache sabe como reaquecer esse cache, ou seja, reconstruir os dados que precisa em cache pra próxima requisição. Um Redis é parecido, mas com a vantagem que também grava em disco, daí se reiniciar, ele sabe reaquecer sozinho. Ele é pouca coisa mais lento mas tem durabilidade. De novo, é um trade-off. Em ambos os casos, significa que não precisamos aumentar o plano de banco de dados.








Mas a coisa não termina aqui. Isso foi só Hello World do Hello World. Bancos de dados é outro assunto infinito que daria pra fazer um canal inteiro só sobre esse assunto, mas o importante é que todo banco de dados tem perfis de performance de escrita e de leitura. Um banco de dados relacional como MySQL, Postgres, SQL Server, Oracle, costuma ter perfil de leitura rápida mas escrita lenta, justamente porque tem como característica as tais garantias ACID que falei antes. É lento pra escrever, porque se ele diz que escreveu, é porque escreveu e escreveu garantidamente correto. Ninguém vai receber um pedido duplicado, ou ser cobrado duas vezes, ou deixar de receber porque deu erro na gravação e ninguém ficou sabendo.








Os tais bancos NoSQL, tem outras características. Um Redis, Mongo, Cassandra, te dão menos garantias, por isso podem ser mais rápidos pra escrever. Eu já fiz um video sobre NoSQL, depois assistam. Mas quando faz sentido ser rápido mas não ter garantias? Pensa um tipo de aplicação que se perder um registro não faz diferença. Por exemplo, um Google Analytics. Todo site que tem configurado vai mandando pro Analytics cada clique e cada visita dos usuários no site. Se uma dessas visitas se perder e não registrar no Analytics, não vai fazer diferença. Ou seu Apple Watch, que fica monitorando batimentos cardíacos a cada X segundos. Ele manda pro servidor pra ir montando um perfil da sua saúde. Se um desses batimentos se perder e não gravar, não importa, o importante é a média ao longo do tempo. São casos onde não ter as garantias ACID permite usar um outro banco mais rápido.









Um MongoDB pode ser quase ACID se configurar  pra esperar pra dar ok na escrita, pra garantir que realmente gravou. Só que aí perdemos a característica de ter escrita mais rápida e vai ter que esperar de qualquer jeito. Um Cassandra tem escrita atômica, mas consistência eventual. Ou seja, até garante que escreveu, mas se consultarmos imediatamente talvezresponda que ainda não está lá, porque a leitura caiu num outro node que ainda não sincronizou. Isso é útil quando o que queremos é replicação do banco em múltiplos servidores. 








Não existe um tamanho que serve tudo. Por isso que pra decidir qual banco usar, precisa entender a diferença nesses perfis de todos em detalhes. Não vai ter uma resposta fácil pra tudo. Mas no geral, pra grande maioria da população que não é uma startup unicórnio, você realmente só precisa de um banco de dados relacional como Postgres sendo auxiliado por um servidor de cache como Memcache ou Redis. Mais do que isso e não é vendo um video que vai ajudar.









E mesmo quando falamos leitura. Existem leituras simples, como puxar uma lista de produtos pra montar uma página, e leituras complicadas que é gerar um relatório das vendas do semestre organizado por região e tudo mais, que cruza os dados de todos os pedidos feitos no semestre, com os dados de todos os clientes, e seja lá quantas outras tabelas pa montar um único relatóriozão. Quem entende de SQL é aquela query com 500 joins, outer joins, sub-selects. Se já trabalhou em algo assim, já viu esse problema: quando seu ecommerce ou sistema fica lento ou até pára de responder toda vez que precisa gerar esses relatórios gigantes.









Uma coisa é uma pesquisa simples que responde em poucos milissegundos. Outra coisa são relatórios que podem levar múltiplos segundos travando o banco inteiro. E se você tiver um tráfego de 400 requisições por segundo, de repente, todo mundo tendo que esperar na fila até o relatório terminar, e levar 10 segundos pra terminar, são 4000 requisições que estamos deixando de responder, centenas de pessoas tomando timeout no navegador e ficando irritados que o site não responde. 








Por isso que num sistema de verdade, dividimos essas coisas em múltiplos servidores. Temos o banco principal, que está ocupado gravando pedidos de pessoas de verdade e não pode ser interrompido quando algum gerente pede um relatório gigante. Por isso que em serviços como Heroku Postgres ou AWS RDS tem fácil pra se gerar servidores de réplica só pra leitura. É uma cópia que pode estar até alguns segundos atrasado do banco principal e que não deixa ninguém gravar nele, mas como fica num servidor separado do banco principal, mesmo se rodarmos coisas pesadas nele, não interrompemos o tráfego do site, que conecta em outro servidor. 








Na verdade é bem comum ter um banco principal só pra escrita e uma réplica só pra servir dados pra montar as páginas do site, e outra réplica exclusiva pra tarefas administrativas como gerar relatórios. Quem fala que quer usar um NoSQL porque bancos relacionais não escalam, não sabem o que estão falando. Em escala de empresas normais não-unicórnios, não precisa. De novo, soluções exotéricas de NoSQL só são necessários se você for o Netflix. Mas pros resto da população, um banco de dados tradicional relacional com réplicas de leitura, já resolve a grande maioria dos problemas. Lembra? Soluções simples de alto impacto que não exige reescrever tudo. É isso que sempre queremos.








Mas ainda temos um último problema de banco de dados. Até que não é tão difícil ter réplicas só de leitura. E eu digo só de leitura porque ter replicação bi-direcional de leitura e escrita, é pouco prático e só deve ser considerado em situações especiais. No geral é melhor ter um único servidor que concentra todas as escritas e envia os dados pra réplicas só de leitura. Mas isso significa que em algum momento, se o tráfego do site aumentar, numa situação de semana de Natal, Black Friday da vida, vai ter mais gente tentando gravar pedidos do que o servidor principal consegue suportar. 








Uma lógica comum numa página de checkout de ecommerce é mais ou menos assim: a lógica do carrinho de compras já checou que tem disponibilidade dos produtos, seu front-end já coletou os dados de entrega, os dados de pagamento, e agora iniciamos a transação pra gravar o pedido. Dentro da lógica dessa transação, conectamos com o meio de pagamento, seja MercadoPago, Paypal, ou o que for, e esperamos responder ok. Se foi confirmado, terminamos a transação e fechamos o commit na tabela do banco de dados e, finalmente, respondemos o HTML pro usuário com o número do pedido que acabamos de gerar. Durante esse período todo o navegador do usuário ficou pendurado, com ampulhetinha rodando, esperando carregar.








Num dia normal de pouco movimento, ou na sua máquina de desenvolvimento, isso funciona perfeitinho. Mais um exemplo de coisa que parece simples só porque você não tem noção da realidade. Mas agora imagina. Você não controla coisas externas como o meio de pagamento. E num dia de Black Friday, ele também pode ficar mais lento. Num dia anormal, tem um monte de gente pendurado nos seus servidores, todo mundo tentando dar checkout nos pedidos. O banco de dados tem limite de conexões, tem limite de transações, e chega uma hora que mesmo tendo fila, o tempo é tão longo que ele é obrigado a começar a desconectar as pessoas pra conseguir trabalhar. É quando o cartório tá tão cheio que não cabe mais gente dentro. O que você faz, manda todo mundo embora?








Parte disso já expliquei no video sobre o Ingresso.com. Onde resolvemos a primeira parte do problema, na parte da frente da loja, que é dar senha pras pessoas e manter uma fila muito mais longa do tipo "volta mais tarde pra ver se já chegou sua vez". E pelo menos o navegador dos usuários não ficam ativamente pendurados nos servidores web, consumindo recursos. Eles podem desconectar, e uma lógica no navegador conecta de tempos em tempos pra checar ou usa protocolos apropriados pra isso como Web Sockets. Mas e depois que as pessoas estão na loja e querem pagar o pedido?









E, pra surpresa de ninguém, não é diferente, a solução é fazer mais filas. Muita gente associa o número do pedido com o ID da gravação da linha na tabela que o banco de dados auto-incrementa e devolve quando deu tudo certo na gravação. Mas se já estamos no cenário onde passamos do limite físico de gravações por segundo que o banco aguenta, não podemos depender disso. O correto é ter uma API ou um microserviço cuja única função é me dar um número que é garantidamente único e não duplicado. Tem várias formas de fazer isso. Mas só entenda o conceito que desassociamos o número do pedido do ID da tabela de pedidos.








Em seguida, não gravamos mais o pedido direto no banco. Em vez disso pegamos os dados do pedido, com esse número e jogamos num serviço de fila. Já falo disso, mas ao fazer isso, quando o usuário preenche seus dados no formulário de checkout e clica em pagar, imediatamente devolvemos a página HTML de resposta dizendo "obrigado, o número do seu pedido é XYZ, e assim que confirmarmos você receberá um e-mail". E pronto, liberamos essa pessoa pra ir embora, e ela pára de consumir recursos no nosso sistema tendo que ficar esperando. É o equivalente de fazer a pessoa ir embora do cartório ou correios e dar espaço pra outra pessoa entrar logo, fazendo a fila andar mais rápido.









Existem vários serviços de fila. Podemos usar o próprio Redis que usamos pra cache pra ser o gerenciador da fila. Podemos usar um serviço feito exclusivamente pra filas como o RabbitMQ ou Apache Kafka ou ActiveMQ ou vários desses MQ que significa Message Queue ou Message Brokers. A AWS oferece o ActiveMQ ou RabbitMQ como serviço ou podemos usar o pŕoprio dele que é o AWS SQS de Simple Queue Service. Todos são Queues, ou filas. A vantagem de serviços de fila é que podemos ficar enviando milhares de mensagens pra eles enfileirarem, que vai ser muito mais rápido e eficiente do que gravar no nosso banco de dados que já tá no limite de processamento.







Eu falei Redis, ele funciona direitinho, mas não é tecnicamente feito pra ser uma fila de verdade. Protocolos de fila de verdade, como implementado num RabbitMQ tem garantias como um banco de dados relacional tem ACID. Um serviço de fila de verdade precisa nos dar garantia de entrega, ou seja, se ele responde que entregou, precisa ter entregue de verdade, e não pode duplicar a mensagem ou coisa assim. Além disso um erro que alguns cometem é criar uma tabela no banco de dados pra usar como fila. Mas se estamos querendo justamente tirar pressão do banco de dados usando uma fila, não faz nenhum sentido botar a fila no banco.









Uma vez na fila, daí nós programadores precisamos fazer uma segunda aplicação separada, que chamamos de workers. Workers são programinhas curtos que ficam de pé esperando alguma coisa aparecer numa fila dessas. Eles ficam escutando essas filas, normalmente falamos que assinam um canal dessas filas. Uma fila pode ter um canal de recebimento de pedidos, outro canal de envio de emails, canal de realizar pagamentos. Cada canal vai ter um worker que sabe o que fazer com a mensagem que tiver naquele canal. O Worker que assina o canal de realizar pagamento sabe como se conectar com o meio de pagamento. 









A vantagem é que separamos as atividades que não controlamos, como confirmação de pagamento, e não precisamos deixar o usuário pendurado esperando uma resposta. Mandamos o usuário embora o quanto antes, e mesmo que o meio de pagamento resolva demorar bem mais que o normal, tudo bem, só vamos demorar um pouco mais pra mandar o email de confirmação pro usuário. E não precisamos torturar o nosso banco de dados com várias transações abertas penduradas que começam a dar timeout e rollback sem parar. 







De novo, cada framework web moderno tem sua forma de lidar com isso que chamamos de asynchronous jobs. No Ruby on Rails tem ActiveJob, que é uma classe que herda de ApplicationJob e implementa um método chamado `perform`. Na configuração geral dizemos que vai escutar de um Redis ou outro serviço de fila. No Node Express podemos usar a biblioteca Bull, onde configuramos um objeto de Queue que também diz de que fila consumir e os workers, que ele chama de consumers, onde temos uma função chamada `process` pra processar cada job que vier da fila. 







Em Spring podemos integrar com Apache Kafka, fazendo uma classe consumer com um método `consume`. Em PHP o Laravel tem suporte nativo, onde fazemos uma classe que herda de ShouldQueue e implementa um método `handle`. Acho que deu pra entender. E cada um tem estratégias de como configurar esses workers, como fazer deploy e tudo mais. Vocês precisam estudar a documentação oficial. Em qualquer outro framework, pesquise no google por "asynchronous jobs".







Mas claro, nem tudo são flores. Você poderia pensar. "Boa, então é só eu pendurar 500 workers atrás dessas filas que tudo vai ser processado rapidinho então". Mas não. Alguns desses workers, no final, continuam precisando gravar coisas como o pedido na tabela do banco de dados principal. Eles podem demorar mais do que a aplicação web, porque não tem um usuário pendurado esperando, mas o pedido final precisa ser consolidado no banco e aí caímos de novo no problema de máximo de conexões e processamento do servidor de banco.







Se voltarmos naquela calculadora do Heroku, note que embaixo tem uma parte que eu não tinha mostrado. O Heroku suporta subir workers, mas cada worker vai consumir conexões no banco também. Se subir 10 dynos, com 1 processo cada, 10 threads por processo e 10 conexões no pool, vai precisar de 100 conexões no banco de dados, além das conexões que já precisava pros dynos de web. Por isso, de novo, não é mágica. Temos que ficar balanceando quantos processos web versus quantos processos workers queremos ter pra um certo orçamento que estou disposto a pagar pela infraestrutura. 






Sacaram? Organizar esses recursos é parecido com jogar RPG, quantos pontos queremos de vida, quantos pontos queremos de mágica, quanto quero gastar em upgrade  de arma. Não adianta ter a melhor arma, mas pouca vida. Configurar arquitetura web é que nem jogar RPG.






Mas como começamos a colocar cache na camada web, o que diminui a necessidade de dynos web, sobra mais conexões pra colocarmos mais workers. E é assim que vamos evoluindo de uma aplicação de um único processo que roda na sua máquina pra uma que divide os recursos e nos dá oportunidades de balancear onde queremos usar mais do que. 







Vamos ver o que acabei de falar num diagrama pra facilitar. Começamos assim: uma caixinha que representa um processo da nossa aplicação web, aquela que você sobe na sua máquina com comandos como `npm run dev` ou `gradlew bootRun`. Esse processo vai configurado pra conectar num banco de dados como Postgres. Seu navegador se conecta direto nessa caixinha, via `localhost:3000`. E na sua máquina tudo funciona.







Mas numa infraestrutura de verdade, como AWS, Azure, Google Cloud ou Heroku que gosto de usar de exemplo pela simplicidade, já começa que na frente da caixinha da sua aplicação vai ter um balanceador de carga, como um NGINX. É nele que seu navegador vai se conectar quando digitar o domínio da sua aplicação. É o endereço IP dele que você configura no registro do seu domínio pra DNS. No painel de todos  tem como configurar certificados SSL e tudo mais. Ele que vai pegar o tráfego dos usuários e direcionar pra containers web, os dynos. DigitalOcean chama de droplets. Em Kubernetes chamamos de pods. Mas enfim, é onde roda o processo da sua aplicação. 







Na realidade, em produção não vai ter só uma caixinha da sua aplicação. Vai ter vários. Cada um numa porta separada no tal container ou dyno. E o balanceador de carga vai distribuindo uma requisição pra cada uma delas, tentando manter todos ocupados por igual, se possível. Agora, todas essas caixinhas continuam precisando se conectar no banco de dados. Mas já sabemos que existe um limite máximo dependendo do plano que pagamos. Pra não perder controle, cada caixinha vai ter um pool de conexões, com um máximo de conexões reusáveis que ele pode manter.







Pra não desperdiçar recursos do banco de dados, a técnica mais importante é estrategicamente colocar cache nos lugares ou mais pesados ou que são acessados com mais frequência e cujos dados não mudem muito, ou que pelo menos não mude muito no espaço de alguns minutos que seja. 5 minutos que suas caixinhas não se conectam no banco faz muita diferença. Lembrem-se, temos muitas caixinhas ativas ao mesmo tempo! Então subimos um novo serviço, um Memcache. Um serviço de cache também tem um limite de quantos megabytes ou gigabytes de RAM queremos usar de cache. 







E não precisamos nos preocupar se encher esse espaço porque o Memcache é inteligente de ir apagando cache mais velho pra dar espaço pra cache mais novo. E eu só dei exemplo de cachear algo que todo mundo vê igual, como lista de produtos numa homepage, mas podemos fazer cache por usuário. Assim se o usuário ficar dando refresh na página de perfil dele, não precisa ficar toda hora indo no banco pra pegar os mesmos dados. Vai estar no cache dele. Estratégias de cache são importantíssimos, vale estudar em detalhes.








Mas à medida que nossa aplicação cresce, temos funcionalidades pesadas, integrações com serviços de terceiros, como meios de pagamento, sistemas de gestão como um ERP, várias coisas que aumentam o tempo de resposta e fazem nossos usuários esperar tempo indeterminado. E nosso banco de dados também não tem processamento infinito. Mesmo colocando cache, ainda assim precisamos controlar esses recursos.







Pra isso podemos começar distribuindo a leitura em servidores de réplica desse banco. Todo bom framework tem como configurar pra toda leitura ser feita num banco de dados e toda escrita ser feita em outro banco de dados. E esse banco de escrita é responsável por atualizar as réplicas. Mesmo se as réplicas ficarem um pouco atrasadas, alguns segundos, pra coisas como relatório semestral de vendas ou algo assim, não vai fazer diferença. E pra coisas como confirmação de número de pedido, podemos até deixar no cache do usuário, enquanto os bancos de dados ainda não se sincronizaram. Assim ninguém vai notar a diferença de tempo.








Mas só isso não é suficiente. O mundo ideal é que toda requisição HTTP feita por um usuário seja devolvido imediatamente, sem precisar esperar ninguém. Por isso não chamamos serviços externos como pagamento ou outras APIs no mesmo processamento de requisição HTTP do usuário. Devolvemos imediatamente pra ele um "aguarde, depois mandamos um email confirmando". E criamos uma tarefa assíncrona que jogamos numa fila como SQS, Kafka ou mesmo Redis, então instalamos uma nova caixinha aqui que vai ser responsável só por isso.







E por fim, criamos workers ou consumers pra essas filas, pra fazer o processamento a posteriori, realizar pagamento, integrar com ERP, integrar com nota fiscal eletrônica, envio de e-mails e tudo mais, e só aí confirmamos gravando no banco de dados principal. Como essas tarefas podem demorar um pouco mais, também não saturamos o banco de dados principal e tudo continua funcionando de forma mais estável. 







Mas não é só ir subindo caixinhas aleatoriamente. Pra isso é bom ter em mente aquela calculadora que mostrei antes. Existem várias calculadoras assim pra coisas como AWS, só procurar. Mas não espere que alguém te dê uma resposta exata. Tempo médio de uma requisição não o único número que você precisa. Numa aplicação web, páginas de conteúdo como lista de produtos, detalhes de produtos, perfil do usuário, são coisas facilmente cacheáveis e que respondem rápido. 







Mas páginas de gerenciamento de carrinho que checa disponibilidade de produtos, checkout com integração de pagamentos, são páginas que demoram muito mais. Chutando, numa página de conteúdo conseguimos responder em menos de 50 milissegundos, mas uma página mais complicada de checkout poderia levar 500 milissegundos. São diferenças assim de 10x que se encontra em diversas partes de uma aplicação Web.







Se tirar a média, vamos chegar num número tipo 100 milissegundos, que não serve pra muita coisa, porque estamos escondendo as páginas pesadas que precisaríamos otimizar, e talvez estejamos otimizando páginas de conteúdo que já são rápidas o suficiente. Por isso eu sempre recomendo que se instale uma ferramenta online de monitoramento. A melhor que conheço é o produto RPM da New Relic. 






Tem boas alternativas como o Scout e outros que não conheço. Mas o New Relic dá um raio X mais detalhado. Ele mostra quem são os principais ofensores, e se ele suportar o framework web que você usa, como Ruby on Rails, é capaz de dizer qual controller, qual model, qual query que realmente tá pesada. Assim não precisamos ficar adivinhando.







Otimização nunca deve ser feita no chutômetro. "Ah, eu acho que é essa classe, ah eu acho que se refatorar esse job fica melhor". Olhem os números. 80% dos problemas de performance costumam ser causados por 20% da sua aplicação. Não precisa reescrever tudo. Em 10 funcionalidades, deve ter 2 que precisamos focar e conseguir economizar metade dos recursos da infraestrutura inteira. Como no exemplo do cache que mostrei no começo. 






Toda otimização deve ser baseada em dados analíticos de uso real em produção, dados de uso de usuários de verdade usando sua aplicação. Por isso precisa de um New Relic. Uma vez estabelecido quem é o ofensor, sabemos quanto tempo tá consumindo. E quando fizer a correção e subir em produção, basta medir algumas horas e dá pra saber quanto foi efetivo ou não. Por isso não basta funcionar só na sua máquina, testando só com um usuário. Assuma que você não sabe nada até medir em produção.








Pro pessoal de front tem uma última otimização importante: aprender a usar CDN. O problema é o seguinte. Quando se monta o HTML e o servidor devolve pro navegador, esse HTML vai conter várias tags de imagens, css, scripts. Agora o navegador precisa voltar pro servidor e ir pedindo todos esses assets. Então uma requisição se multiplica em 20, 50, sejá lá quão complexo é o HTML que você fez. Normalmente um servidor web é bem rápido pra devolver essas coisas, já que não envolve conectar com banco de dados, APIs nem nada disso, mas mesmo assim, em grande volume, também pesa. Aquelas caixinhas da sua aplicação tão perdendo tempo devolvendo imagens sendo que podiam estar usando esse tempo pra gravar mais um pedido da sua loja.








Cada framework web, de novo, tem formas de integrar com um CDN como o AWS CloudFront ou Azure CDN ou Fastly. CDN funciona assim: em vez de escrever uma tag de imagem com o source relativo ao seu domínio, explicitamente escrevemos a URL do serviço de CDN tipo "minhalojablabla.cloudfront.com" ou seja lá qual URL que o serviço te der. E reescrevemos a tag de imagem usando um source absoluto. Só que isso seria um saco por dois motivos. Enquanto se está desenvolvendo a aplicação, nem tem o CDN configurado ainda, daí você,  desenvolvedor front-end, nem ia conseguir visualizar o que tá fazendo. O segundo problema é se escrever na mão as URLs pro CloudFront mas aí o pessoal de infra decide que prefere mudar pro Azure. E aí? Sai mudando todas as URLs na mão?








Lógico que não. Pra isso usamos helpers. Funções que escrevem a URL pra você. Em vez de escrever URL relativa ou absoluta pro CDN, use a linguagem de templates do seu framework e chame funções. Por exemplo, no Node Express, usando EJS, poderia escrever a tag de imagens assim como nesse exemplo. Essa função vai checar se está rodando na sua máquina local, daí escreve a URL relativa normal. E quando estiver em produção, fazemos uma configuração que indica pra função qual é a URL do CDN e ele reescreve usando URL absoluta.









Esse exemplo é usando express-cdn mas tem várias bibliotecas que fazem a mesma coisa. É importante que todo desenvolvedor de front saiba fazer isso pra depois não ter que ficar caçando URL hard-coded pra sair mudando em massa um dia antes do primeiro deploy. A vantagem de fazer isso é que a partir de agora, se feito direito, sua aplicação web devolve o HTML pro navegador. O navegador encontra essa tag de imagem apontando pro servidor de CDN e vai pedir pra lá. O servidor de CDN vai checar "hum, eu tenho essa imagem? Não", daí ele vai pedir só uma vez pra sua aplicação web e vai cachear a imagem de resposta. Todo mundo que pedir a mesma imagem vai pegar do cache do CDN e não vai mais pesar na sua aplicação.








De novo, é outra coisa que remove uma quantidade grande de requisições feitas na sua infra e move tudo pra infra de CDN com outra vantagem: CDNs grandes costumam sincronizar seus dados em servidores de diversas regiões geográficas pelo mundo. Então, mesmo que você tenha feito deploy da sua aplicação num servidor do Brasil, se alguém do Japão acessar, pelo menos todas as imagens, css, arquivos de javascript, podem ser puxados de servidores de CDN do Japão, o que vai proporcionar uma experiência melhor pros usuários. No final todo mundo ganha e sua infraestrutura fica melhor balanceada.










Finalizando, estude estratégias de cache usando componentes como Memcache ou Redis. Estude jobs assíncronos usando serviços como AWS SQS ou Kafka. Estude como monitorar e conseguir métricas reais da sua aplicação em produção. E estude como integrar CDNs no seu front-end. São 4 das principais técnicas de otimização que toda aplicação web precisa. E isso porque eu pulei, mas vale mencionar, que saber fazer queries SQL otimizadas, instalar índices adequados, também melhora tudo uma ordem de grandeza. Só porque seu framework esconde o SQL não significa que você pode ignorar SQL. Um monte de problemas de performance são causados por SQL mau feito.









Mas por hoje vou acabar aqui. Eu só queria rapidamente mostrar alguns dos aspectos que separam uma aplicação web que funciona só na sua máquina, mas que não escala de verdade em produção, e como isso não tem nada a ver com sua escolha de linguagens, frameworks, mas sim do seu não-entendimento de como uma aplicação de verdade realmente funciona. Eu mostrei só o pico do iceberg e tenho certeza que muita gente experiente vai complementar o que falei nos comentários então se ficaram com dúvidas não deixem de mandar aqui embaixo, se curtiram o video deixem um joinha, assinem o canal e compartilhem o video com seus amigos. A gente se vê, até mais.
