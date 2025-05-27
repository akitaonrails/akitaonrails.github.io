---
title: "[Akitando] #149 - Configurando Docker Compose, Postgres, com Testes de Carga
  - Parte Final da Rinha de Backend"
date: '2023-12-16T09:30:00-03:00'
slug: akitando-149-configurando-docker-compose-postgres-com-testes-de-carga-parte-final-da-rinha-de-backend
tags:
- rinhabackend
- docker
- podman
- gatling
- pgadmin
- postgres
- portainer
- nginx
- php
- node.js
- java
- sql
- akitando
draft: false
---

{{< youtube id="-yGHG3pnHLg" >}}

Não podia terminar o ano com pendências, então eis a parte final da Saga da Rinha de Backend. Neste video vou aproveitar os temas da rinha pra demonstrar em mais detalhes como configurar um Docker Compose de verdade, como funciona testes de carga com Gatling, como usar esses dados pra configurar coisas como o Postgres melhor. Também vamos ver como avaliar exatamente quanto pesa rodar SQL num Postgres, como determinar coisas com tamanho de pool de conexões e muito mais!

Hoje é dia de aprender ferramentas que todo programador deveria mesmo saber no dia a dia de projetos de verdade.

## Capítulos

* 00:00:00 - Intro
* 00:01:03 - CAP 01 - Minhas Pendências da Rinha - Como Começar?
* 00:03:28 - CAP 02 - Entendendo Docker Compose - PHP do Lauro
* 00:07:38 - CAP 03 - Aprendendo a Lidar com Poucos Recursos - Configurando NGINX
* 00:15:33 - CAP 04 - Gargalos de Docker - Network Mode: Host
* 00:21:41 - CAP 05 - Prefira Docker em Linux - Problemas em Mac e Windows?
* 00:26:51 - CAP 06 - Algumas Dicas de Docker Compose - Node do Lucas Weis
* 00:30:21 - CAP 07 - Básico de Testes de Carga - Gatling
* 00:44:26 - CAP 08 - Comparando com Network Mode HOST - Faz diferença??
* 00:52:53 - CAP 09 - Entendendo PostgreSQL - Banco era Gargalo??
* 01:01:12 - CAP 10 - Full Text Search no PostgreSQL - Faz diferença??
* 01:07:35 - CAP 11 - Estratégia de SQL com EXPLAIN ANALYZE - SQL por baixo dos panos
* 01:16:11 - CAP 12 - Quantas Conexões Configuro no Banco? - Medindo com pgAdmin
* 01:23:34 - CAP 13 - Discutindo sobre Linguagens - Kotlin e Crystal
* 01:31:05 - CAP 15 - Como Linguagens afetam Recursos do Banco? - Só a saber, sobre threads vs fibers
* 01:35:00 - Bloopers

## Links

* [Repositório Oficial da Rinha](https://github.com/zanfranceschi/rinha-de-backend-2023-q3)
* [GitHub Versão Node.js do Lucas Poole](https://github.com/lukas8219/rinha-be-2023-q3)
* [GitHub Versão PHP do Lauro Appelt](https://github.com/lauroappelt/rinha-de-backend-2023)
* [GitHub - akitaonrails/rinhabackend-rails-api](https://github.com/akitaonrails/rinhabackend-rails-api)
* [Docker Network Mode Host](https://docs.docker.com/network/drivers/host/)
* [Gatling](https://gatling.io/docs/gatling/tutorials/installation/)
* [Vegeta](https://github.com/tsenart/vegeta)
* [HAProxy - The Reliable, High Perf. TCP/HTTP Load Balancer](https://www.haproxy.org/)
* [Envoy proxy - home](https://www.envoyproxy.io/)
* [Reverse proxy quick-start — Caddy Documentation (caddyserver.com)](https://caddyserver.com/docs/quick-starts/reverse-proxy)
* [GitHub - jesseduffield/lazydocker: The lazier way to manage everything docker](https://github.com/jesseduffield/lazydocker)
* [How to Insert Bulk Data in PostgreSQL - CommandPrompt Inc.](https://www.commandprompt.com/education/how-to-insert-bulk-data-in-postgresql/)
* [pgAdmin - PostgreSQL Tools](https://www.pgadmin.org/)
* [Spring Initializer](https://start.spring.io/)
* [Kotlin Programming Language (kotlinlang.org)](https://kotlinlang.org/)
* [The Crystal Programming Language (crystal-lang.org)](https://crystal-lang.org/)
* [Lucky - Web framework for Crystal (luckyframework.org)](https://luckyframework.org/)
* [O que é a pilha ELK? | Explicação sobre a pilha Elasticsearch, Logstash, Kibana | AWS (amazon.com)](https://aws.amazon.com/pt/what-is/elk-stack/)
* [O que é Elasticsearch – Explicação sobre o mecanismo Elasticsearch – AWS (amazon.com)](https://aws.amazon.com/pt/what-is/elasticsearch/)
* [Redis and Memcached-Compatible Cache – Amazon ElastiCache – Amazon Web Services](https://aws.amazon.com/elasticache/)
* [Apache Kafka totalmente gerenciado | Amazon MSK | Amazon Web Services](https://aws.amazon.com/pt/msk/)
* [Working with read replicas for Amazon RDS for PostgreSQL - Amazon Relational Database Service](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PostgreSQL.Replication.ReadReplicas.html)
* [Improve database performance with connection pooling - Stack Overflow](https://stackoverflow.blog/2020/10/14/improve-database-performance-with-connection-pooling/)
* [How Postgres Makes Transactions Atomic (brandur.org)](https://brandur.org/postgres-atomicity)

## SCRIPT

Olá pessoal, Fabio Akita

Antes de ir pro assunto de hoje, só confirmando que sim, o último video foi um experimento de fazer um episódio totalmente gerado por IA. Maioria sacou, mas muitos demoraram bastante ou nem se tocaram. Mas não se preocupem, foi só uma vez pra ver como fica. Não é nem um pouco prático fazer videos via ferramentas de IA como o HeyGen. Eu expliquei o processo na descrição do video, que vocês sempre pulam. Então leiam lá.



Assunto de hoje, finalmente, vai ser a prometida Parte 2 da Rinha de Backend. Sim, o video das 16 Linguagens em 16 dias foi lançado em Setembro e eu prometi uma parte 2. Estamos em dezembro, quase virando o ano e só agora estou soltando. Mas é assim que este canal funciona: me deu vontade de falar de outras coisas antes. 



Objetivo deste video é complementar algumas dicas e informações que podem auxiliar nos seus estudos. Em particular algumas das técnicas que diferenciam projetinho de tutorial de projeto de verdade. Então, vamos lá ...

(...)



Um dos motivos de porque demorei tanto pra fazer esse episódio é por causa destes dois itens que eu tinha colocado pra falar neste episódio: Resolvendo a Rinha em 5 minutos e O que é um framework web? Esses dois itens seriam um video inteiro de 2 horas e sinceramente, não estou com paciência pra esse tema porque já tem documentação suficiente online. Abra o site de qualquer framework web, seria o primeiro tutorial de como usa. Eu só estaria repetindo o que já existe online. Em vez disso vou só resumir alguns pontos principais.





Resolvendo a Rinha em 5 minutos. Sim, eu poderia fazer um speed run e editar um video demonstrando passo a passo como fazer uma versão das APIs. Eu acho inútil. Speed run de código só pra mostrar que sei fazer, realmente não me motiva. É óbvio que eu sei fazer. Flex desnecessário. Aliás, o video de 16 linguagens em 16 dias já foi flex o suficiente.





Se você é iniciante e tem dificuldade de resolver esse exercício, obviamente ainda falta estudar mais e treinar mais. O que eu sempre repito? Não existe uma única forma de resolver um problema de código. Não existe um único passo a passo de tutorial ou curso que consiga cobrir todas as permutações. O que vocês tem que fazer? Abrir o GitHub do evento e ir no diretório de participantes. Por isso achei este evento interessante: pela quantidade de versões diferentes que os participantes publicaram pra resolver o mesmo problema.






Vou dar um exemplo. Fiz clone do repositório principal da rinha na minha máquina. Peguem o link na descrição abaixo. Indo no diretório de participantes, temos 94 versões. Eu analisei a maioria delas no outro video, depois assistam lá. Mas digamos que esteja estudando PHP e queira ver como se resolve esse problema em PHP. A partir do diretório de participantes, só abrir um terminal e digitar `grep "php" */README.*` e olha só, aparecem 4 sub-diretórios, dois do Lauro Appelt e dois de um tal de Predator. No video anterior eu expliquei uma das versões do Lauro, que é feito em Hyperf com Swoole.





Vamos abrir o README de um dos diretórios e olha só, temos o link do repositório com o código em PHP do Lauro. Podemos clonar em qualquer outro lugar e fuçar pra ver como foi que ele implementou a versão dele. A parte mais interessante desse evento, é que um dos requerimentos foi pra todo participante criar Dockerfiles e Docker Compose pra tudo. Então é super fácil de executar, sem precisar adivinhar como configurar o ambiente pra cada projeto.





Hoje em dia eu considero de boa educação, boa etiqueta, que todo projeto, não importa quão pequeno ou quão grande, sempre deve ter um Dockerfile e um docker-compose. O Dockerfile demonstra como fazer pra rodar sua aplicação e o docker compose demonstra como subir as dependências desse projeto, como banco de dados. Vamos olhar o Dockerfile do projeto do Lauro.





Primeiro, ele inicia baixando uma imagem preparada pelo pessoal do framework Hyperf, que já trás tudo que você vai precisar. Em seguida, faz algumas configurações de timezone. Maioria das imagens boota com tempo UTC de Greenwich, timezone zero, como padrão. Pra ter os horários corretos da sua região geográfica, precisa colocar algo como "America/Sao_Paulo", sempre. Ninguém vai adivinhar. 



```

FROM hyperf/hyperf:8.2-alpine-v3.18-swoole

ARG timezone

ENV TIMEZONE=${timezone:-"America/Sao_Paulo"} \
    APP_ENV=prod \
    SCAN_CACHEABLE=(true)

```


Esse trecho seguinte grandão aqui é opcional e eu não testei o suficiente pra saber se era ou não necessário pra melhorar os tempos do benchmark. Tudo que ele está fazendo é criando um arquivo de variáveis de configuração, pra mexer em configurações como tamanho máximo de upload, que é desnecessário neste projeto, ou limite de memória, que talvez possa ser útil ou não, não medi pra saber. 



```

RUN set -ex \

    && php -v \
    && php -m \
    && php --ri swoole \

    && cd /etc/php* \

    && { \
        echo "upload_max_filesize=128M"; \
        echo "post_max_size=128M"; \
        echo "memory_limit=1G"; \
        echo "date.timezone=${TIMEZONE}"; \
    } | tee conf.d/99_overrides.ini \

    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \

    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"
```


Não saia copiando e colando achando que vai automaticamente melhorar alguma coisa. Vá na documentação e entenda item a item daqui. Daí rode uma versão sem isso, e outra versão com isso, rodando o mesmo benchmark, daí compare se faz alguma diferença. O fato de coisas que não importam pra este desafio, como tamanho máximo de upload, me diz que o Lauro copiou o Dockerfile de exemplo no site da imagem desse Hyperf, e colou aqui.





Finalizando, adicionamos drivers de postgres pra PHP, mudamos o diretório de trabalho pra /app, que é pra onde vamos copiar os arquivos do projeto na sequência. O que eu achei estranho é que não tem um último comando de ENTRYPOINT indicando como rodar a aplicação, também senti falta de rodar "composer install" pra baixar as bibliotecas. Isso é uma peculiaridade desta versão do Lauro, guardem isso que já já explico porque tá faltando.


```
RUN set -ex \
    && apk --no-cache add \
    && apk add php82-pdo_pgsql

WORKDIR /app

COPY . /app
```



Agora vamos ver o docker-compose.yaml. Docker compose é a descrição de uma mini-infraestrutura. Do que instalar, configurar e subir Redis, Postgres, Nginx, tudo na mão, podemos automatizar tudo num único comando. É muito mais fácil pra um novo desenvolvedor que entra no seu projeto, aprender como as coisas funcionam, se tiver um docker compose já pronto. Funciona com uma documentação viva da infra do projeto. É de bom tom, todo projeto de verdade, ter docker compose configurado que funciona. 






Nunca fez um docker compose na vida? Como faz? Simples, começa pegando qualquer um dos 90 e tantos exemplos que tem neste evento como base. Vamos abrir o do Lauro e ir de baixo pra cima. Olha só, já sabemos que esse projeto depende de Redis estar de pé. Esse nome "redis" na primeira linha é qualquer nome que quiser. Por convenção colocamos o nome do que vamos rodar, mas poderia ser "cache_server" ou algo assim.


```
    redis:
        container_name: rinha-backend-redis
        image: redis:latest
        command: redis-server --save "" --appendonly no --maxclients 20000
        network_mode: host
        deploy:
            resources:
                limits:
                    cpus: '0.1'
                    memory: '0.2GB'
```



A única linha obrigatória mesmo é o nome da imagem. Docker, por padrão, vai baixar tudo de dockerio.com. Se quiser baixar de outro lugar, tem que colocar a URL inteira, senão só o nome e a versão da imagem é suficiente. Aqui está "latest", que é a versão mais recente. Não gosto de usar latest porque se amanhã mudar a versão, e sua app não foi adaptada e teve mudanças que quebram compatibilidade, seus desenvolvedores vão começar a ter problemas. Se forem muito júniors, não vão associar que foi porque mudou a versão do redis e por isso as coisas quebraram do nada. É melhor colocar a versão fixa, como 7.2.3-alpine3.19, que significa Redis versão 7.2.3 rodando em cima da distro Alpine versão 3.19.






As outras opções são específicas da Rinha, em particular os limites de recursos na seção de deploy. Esse foi um dos critérios, que achei inteligente. Tínhamos no máximo 1.5 CPUs e 3 Gigabytes de RAM pra usar. À primeira vista, parece muito pouco. Não é fácil de imaginar como esses recursos encaixam em cada componente. Se você é um iniciante e tem uma máquina fraca, já aprendeu a ter que lidar com isso: como faz pra tirar o máximo proveito do seu Dual Core com 2 gigabytes de RAM? Todo programador que ficou bom, começou tendo que fazer rodar programas pesados em máquinas fracas. 






Se você é um iniciante e já começou com oportunidade de usar máquinas novas e parrudas pra trabalhar, qualquer coisa acima de um quad core, acima de 8 gigabytes de RAM, tipo um Macbook da vida, e não teve que lidar com máquinas fracas, cuidado. Você vai pode acabar ficando complacente, preguiçoso. Vai achar que o mundo é igual sua bolha: que tem CPU sobrando, que tem RAM sobrando, e nunca vai entender o valor de otimizar as coisas. Pra que otimizar? Se tá tudo sobrando? Na hora que ficar difícil, você vai ser o tipo que desiste fácil.






Por isso eu repito que na minha teoria de Aprendendo a Aprender, tem que ter a Dor de Aprender. Não importa se você cai, importa como se levanta. Não importa quantas vezes cai, importa que toda vez se levanta mais rápido. Quem nunca sentiu dor, nunca aprendeu nada. E nesta rinha, a versão disso é essa limitação de recursos, senão, claro, o participante com uma máquina como a minha, com 64 giga de RAM, Ryzen 9 de 32 threads, facilmente conseguiria gerar resultados com números muito melhores que todo mundo. Mas com esse limite, o participante com um quad core de 4 giga de RAM poderia ultrapassar minha máquina, se soubesse administrar melhor os recursos limitados. 







E isso de limitar recursos no Docker, não foi feito pra concursos. Foi feito pro caso de alguém realmente precisar rodar dois processos numa mesma máquina, e caso um deles seja fominha demais e consuma recursos demais, não deixar o outro processo morrendo de fome. Se o servidor tem 4 giga de RAM, eu subo dois programas, cada um no seu container de docker. Digamos que o primeiro resolva alocar toda a memória disponível, mesmo que não vá usar. Daí quando o segundo container tentar rodar, vai crashear, por falta de recursos.






Existem processos que alocam mais memória do que deveriam? Sim, por exemplo, um Node.js tem recurso de cluster, que eu mencionei no episódio anterior. O que muita gente faz? Vai no Google pesquisar e só copia um trecho parecido com esse de algum stackoverflow da vida. Esse script roda "os.cpus.length" e vê que sua máquina tem 4 cores, ou seja, 4 cpus, então faz 4 forks da aplicação. Cada fork pode ocupar, digamos, meio gigabyte. Então 4 forks daria 2 gigabytes. Como sua máquina tem 8 gigabytes, você nem se preocupa. Funciona tudo direitinho.




```javascript
const numForks = require('os').cpus().length || 4;

if(cluster.isPrimary && process.env.CLUSTER === 'true'){
    logger.info(`index.js: Primary ${process.pid} is running`);

    for (let i = 0; i < numForks; i++) {
      cluster.fork();
    }
```


Aí você aloca um servidor num cloud qualquer, com 8 giga de RAM. Mas resolve pegar um CPU potente, de 16 cores. Seu script de cluster vai ver 16 cpus e subir 16 forks. Cada fork ocupando meio giga de RAM. Ou seja, vai ocupar todos os 8 giga de uma só vez. E você não tem 8 giga sobrando, seu sistema operacional e outros serviços ocupam RAM. Alguns desses forks vão crashear logo no boot. 






O certo é consertar esse script e trocar a chamada de os.cpus e usar uma variável de ambiente no lugar. Assim podemos declarar essa variável, como CLUSTER_WORKERS, no yaml do docker compose, e ter controle sobre quantos processos realmente vai subir. Como desenvolvedor você sempre precisa ter controle sobre o que exatamente vai rodar, quantos recursos vai usar. Um bom jeito de se exercitar é acertando script de docker compose. 


```js
const numForks = Number(process.env.CLUSTER_WORKERS) || 4;
```


Continuando, depois do redis tempos nginx. Esse foi outro pré-requisito nas instruções da rinha: ter um proxy reverso pra servir de balanceador de carga entre, no mínimo,  duas instâncias da sua aplicação. Quando um estudante segue um tutorial de web qualquer, ele só entende que tem um único processo, o servidor da aplicação. Sobe numa porta como 4000 e no navegador coloca localhost:4000 e pronto, acabou.


```
    nginx:
        container_name: rinha-backend-nginx
        image: nginx:alpine
        volumes:
            - ./docker/nginx/nginx.conf:/etc/nginx/nginx.conf
        network_mode: host
        depends_on:
            - api-01
            - api-02
        deploy:
            resources:
                limits:
                    cpus: '0.1'
```


Esse é o nível zero no aprendizado. O nível logo acima desse hiper básico, tem que aprender que em projetos de verdade, subimos múltiplos processos em paralelo, seja na mesma máquina, seja em múltiplas máquinas. Se for na mesma máquina, um sobe na porta 3000, outro na porta 3001, outro na 3002. Em qualquer dos casos, sempre colocamos um balanceador de cargas na frente, na forma de um proxy reverso. Explico isso no episódio "Tornando sua Web App Mais Rápida".





Alguns mais experientes poderiam criticar a escolha de NGINX, sendo que existem ou programas mais especializados pra isso como HAProxy ou mais modernos como o Envoy ou Caddy. Mas de jeito nenhum é uma escolha ruim, especialmente porque é um dos que tem mais documentação, é simples de usar, e pra esta rinha, está mais que bom. Nesta seção de docker compose temos duas coisas importantes, a primeira é a imagem. No caso estamos usando a versão de Alpine, que é uma das mais leves. Mais importante é o mapeamento de volume.





Precisamos mapear o arquivo de configuração que fica no nosso projeto do lado de fora, para que o container tenha acesso quando bootar. Lembrem-se, um container é só uma forma de mentir pro processo que roda dentro, pra ele achar que está sozinho, numa máquina vazia. Ele não enxerga nenhum arquivo de fora se nós não declararmos pra dentro, da seguinte forma.


```
volumes:
	- ./docker/nginx/nginx.conf:/etc/nginx/nginx.conf
```



O que tem nesse arquivo de configuração? Vamos dar uma olhada. Se nunca viu, parece complicado, mas vamos por partes. Esta primeira parte do topo tem a ver com a escalabilidade do serviço. Nginx funciona numa arquitetura de master e workers. Esse "worker_processes" como "auto" de automático quer dizer que ele vai avaliar quantas cpus sua máquina tem e subir 1.5 vezes. Então, se tiver 4 cpus, ele vai subir 6 workers.


```c
worker_processes auto;
```


Por que não 1 worker por 1 cpu? Primeiro, uma cpu não é exclusiva de 1 processo. Quem controla qual processo vai rodar em qual cpu durante um período x de tempo, é o scheduler da kernel. Se seu processo é leve e precisa de pouco tempo pra fazer o que precisa, não tem porque bloquear uma cpu inteira só pra ele. Dá pra dividir com outros processos. Depois assista meus episódios sobre concorrência e paralelismo pra entender como schedulers funcionam.





Em seguida temos worker_connections como 4096. Isso indica quantas conexões simultâneas cada worker vai tentar aguentar. Não confunda conexões simultâneas com processamento paralelo. Se realmente vier 4096 requisições web, exatamente no mesmo instante, esse parâmetro só significa que o worker vai aceitar as 4096 conexões, mas uma boa parte vai ficar esperando numa fila, até ser atendido. Se demorar mais do que certo tempo, que podemos configurar, ele pode rejeitar e devolver erro de timeout. Como o nome diz, erro de tempo expirado.


```c
events {
    worker_connections 4096;
}
```


No primeiro episódio que fiz da rinha eu expliquei como muitos ficaram tentando mexer nesse número meio que no chute. Só o Leandro, que fez a versão em Ruby, entendeu que o truque não era aumentar esse número e sim diminuir. Eu explico o raciocínio no outro video, então não deixem de assistir depois.





O Nginx é só o tirador de pedidos, lembram da analogia do caixa de restaurante fast food? Ele tira os pedidos, mas quem realmente executa, os cozinheiros, são estes servidores declarados nesta seção upstream. No caso apontando pra localhost, portas 9501 e 9502. Se já mexeu com docker compose antes, isso poderia parecer um pouco estranho.


```c
http {
    access_log off;
    error_log /dev/null emerg;

    upstream api {
        server localhost:9501;
        server localhost:9502;
        keepalive 400;
    }
```



Normalmente, pra subir um nginx via docker compose, eu teria uma configuração mais ou menos assim: declararia dois serviços web, as instâncias da minha aplicação, como app1 e app2. Ambos carregando na porta 8080. Daí, na configuração do nginx, essa seção upstream estaria apontando pra app1 porta 8080 e app2 também porta 8080.





Mas como que dá pra ter dois serviços subindo na mesma porta? Não tem conflito? E não tem, porque na prática é como se cada container representasse um servidor externo separado. E sua aplicação está carreagando num servidor fora, só que virtual. Daí, cada servidor tem uma porta 8080 livre. Cada instância pode se pendurar na porta 8080 do seu respectivo "servidor virtual". Acontece que o nginx e esses servidores virtuais se comunicam na mesma rede, também virtual, daí o nginx consegue fazer o balanceamento entre esses dois serviços.






No episódio anterior eu expliquei a descoberta que alguns de nós fizemos durante nossos experimentos, o Vinicius Ferraz fez a descoberta de que se usarmos o modo de rede de ponte virtual, que é o padrão, isso introduzia um gargalo pesado e os resultados dos benchmarks ficavam bem errados. Mas se colocarmos o modo de rede pra host, ou seja, sem virtualizar a rede, aí os tempos finalmente ficam corretos.





Não sei se notaram, mas na configuração do redis que mostrei antes, ou nesse de nginx, note que ambos já tem a opção network_mode igual a host, indicando que é pra pendurar o container nas portas da rede de verdade do sistema operacional nativo. Nesse modo não podemos pensar que temos "servidores virtuais separados" mas sim que estamos subindo realmente tudo na mesma máquina, na rede de verdade. Portanto, precisamos nos preocupar com conflitos de portas. Por isso no upstream do nginx, apontando pra dois servidores em localhost, cada um deles precisa estar numa porta diferente, 9501 e 9502.







É muito importante entender o que é modo de rede ponte e a diferença com modo de rede host. Estudem se não sabiam disso. Mas já que falamos do servidor de aplicação. Note que na configuração do nginx, tem esse seção de depends_on. Ele quer dizer: só suba o serviço nginx quando detectar que os serviços api-01 e api-02 estejam de pé. Então vamos pular pro começo do arquivo do docker compose, pra ver como essa aplicação está configurada.



```
services:

    #api1
    api-01:
        container_name: rinha-backend-api-01
        build:
            context: .
            dockerfile: Dockerfile
        environment:
            HTTP_PORT: 9501
            APP_NAME: skeleton
            APP_ENV: dev
            DB_DRIVER: pgsql
            DB_HOST: localhost
            DB_PORT: 5432
            DB_DATABASE: rinha-backend-db
            DB_USERNAME: rinha
            DB_PASSWORD: postgres
            REDIS_HOST: localhost
            REDIS_PORT: 6379
        volumes:
            - ./:/app
        depends_on:
            - db
            - redis
        command: bash -c "php bin/hyperf.php start"
        network_mode: host
        deploy:
            resources:
                limits:
                    cpus: '0.4'
                    memory: '0.3GB'
```


Precisamos dar um jeito de configurar a mesma aplicação duas vezes, como api-01 e depois como api-02 e, como estamos usando modo de rede host, precisamos declarar portas direrentes pra cada uma, que normalmente fazemos via variáveis de ambiente, como esse HTTP_PORT logo no começo. O jeito mais fácil é configurando esse bloco de configuração do serviço api-01 e depois fazendo um copy e paste embaixo pra ser o api-02, só mudando o HTTP_PORT pra 9502.





Existem outras formas de fazer isso. Como exemplo, que pegar o docker compose do projeto de Node.js do Lucas Poole, porque ele ainda está usando o modo de rede padrão, via ponte virtual, daí não precisou se preocupar em configurar portas diferentes, só precisou fazer hostnames diferentes. Vamos dar uma olhada. 



```
services:
  app1: &app
    # image: lukas8219/rinha-be-2023-q3:latest
    build: .
    hostname: app1
    environment:
      DB_URL: "postgres://postgres:12345678@postgres:5432/postgres"
      DB_POOL: 35
      PINO_LOG_LEVEL: "debug"
      REQ_TIMEOUT: "2000"
      NODE_ENV: production
      CLUSTER: true
      CLUSTER_WORKERS: 5
    expose:
      - "8080"
    depends_on:
      - postgres
    ulimits:
      nproc: 1000000
      nofile:
        soft: 1000000
        hard: 1000000
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: '0.6GB'
  app2:
    <<: *app
    hostname: app2
```




Ele declarou o serviço de nome "app1" e em seguida anexou uma etiqueta com esse & comercial, chamando de "app". Descendo pro próximo serviço no mesmo arquivo, observem, temos app2. E na linha seguinte é como se fosse um "include" ou "import", dizendo pra copiar tudo que tinha no app1. A única coisa que muda é o nome do hostname. Entenderam? É assim que podemos reusar as mesmas configurações entre diferentes serviços. Isso é uma características de arquivos de configuração em formato YAML, não é coisa do docker compose. Qualquer outro programa que use YAML, dá pra fazer a mesma coisa.






Como falei antes, o projeto do Lucas não está usando o modo de rede host e sim o de ponte, por isso na configuração do app2, ele mantém o mesmo número de porta. Se fosse no modo host, precisaria declarar pelo menos um número de porta diferente, pra não conflitar no localhost. Se nunca viu isso antes, sei que pode ser confuso, mas se lembre dessa diferença entre ponte de rede virtual e rede host nativa.





A parte mais importante na configuração da nossa aplicação de API é este parâmetro "build". Aqui está mais completo do que precisa. Bastaria ter escrito o valor ".", mas o Lucas preferiu declarar o contexto como "ponto" e o arquivo como sendo "Dockerfile" mesmo, que é o padrão. 






É aqui que ele vai usar o arquivo de Dockerfile que já vimos antes, pra construir a imagem pra este container. Todos os outros serviços, nós apontamos pra imagens já prontas no serviço do site Docker Hub. Aquelas imagens foram todas feitas com algum Dockerfile também. A diferença é que nossa aplicação não foi publicada no Docker Hub, estamos construindo ela aqui, então apontamos direto pro Dockerfile. No futuro, quando a aplicação estiver terminada, podemos dar upload da última imagem gerada e passar a apontar pra ela via parâmetro image em vez de build. No arquivo do Lucas, tem até comentado essa opção, porque pra participar da rinha, precisava ter publicado a imagem de verdade.






O Dockerfile do Lauro, que mostrei antes, usa de base a imagem do repositório do Hyperf e também incluímos coisas como o PDO de Postgres. Todos esses elementos podem ser configurados via variáveis de ambiente, que é o que estamos declarando na seção "environment", como o HTTP_PORT, que indica em qual porta o servidor de Hyperf vai subir, ou DB_HOST ou REDIS_HOST que declara o nome do servidor que vai ter o banco de dados e o cache. Neste caso, em modo de rede host, vai ser tudo localhost.






No projeto do Lauro, quando fizemos as otimizações de performance que expliquei no outro episódio, ele fez alguns ajustes depois e preferiu não deixar tudo 100% automatizado. Lembram que falei que no Dockerfile dele estava faltando o comando ENTRYPOINT, que define que executável iniciar no container? Pra saber o que fazer, tem que ler o README dele. Ao subir o Docker Compose, os containers vão estar de pé, mas internamente quem vai rodar é este comando de "sleep infinity", que é um truque só pro container ficar de pé e não morrer.






A razão disso foi porque ele não adicionou os próximos passos no Dockerfile, não sei por que, mas o README pede pra rodar manualmente, via "docker exec" o comando de "composer install" pra instalar as dependências. Como ele mapeia o diretório inteiro como "/app" pra dentro do container, se não me engano, "composer install" vai baixar e gravar as dependências no sub-diretório "/app/vendor". Por isso tanto faz rodar em qualquer um dos dois containers, o outro vai enxergar automaticamente, já que compartilham do mesmo volume no disco.






Só depois de fazer isso que, via docker exec de novo, podemos rodar o hyperf em cada container, e vai subir direitinho. Durante desenvolvimento, dependências como bibliotecas de node, ou neste caso, do composer, não queremos deixar dentro da imagem, porque ocupam muito espaço e mudam o tempo todo. Seria trabalhoso toda vez reconstruir a imagem. O melhor é mapear um volume pra dentro do container e mandar instalar nesse volume. Só quando for gerar a imagem final pra publicar, aí sim, era bom mudar pra gravar as dependências dentro da imagem. Senão quem for baixar depois, vai precisar fazer isso manualmente, o que não é ideal.







Feito tudo isso, do terminal, basta subir tudo com "docker compose up". Isso vai baixar as imagens que ainda não tem, construir essa da aplicação e subir tudo certinho, na ordem certa, graças aos depends_on que todos os serviços declaram. Olhem só, da primeira vez demora um pouquinho pra subir. Vou acelerar aqui um pouquinho e ... pronto. Como expliquei antes, só pra esse projeto do Lauro, temos que rodar o composer install manualmente, aceleramos mais um pouco e ... pronto. Finalmente, podemos subir o Hyperf em cada um dos containers.







Pra testar que tudo deu certo, podemos consultar o endpoint da API de contagem de pessoas, que é usado pelo script de benchmark pra mostrar quantas pessoas foram inseridas no teste de carga. Basta chamar do próprio terminal com "curl http://localhost:9999/contagem-pessoas". E.. deu pau. O que aconteceu?






Se estiver rodando em alguma distro Linux, ia retornar bonitinho. Mas se estiver rodando em Mac ou Windows, como neste meu caso, via WSL 2, aquela configuração de network mode host não vai funcionar. Por que?





Se não entendem como um container funciona por baixo, não deixe de assistir o episódio sobre containers. Em resumo, Docker precisa da kernel Linux pra funcionar. Docker não é uma máquina virtual, é uma infraestrutura que pede pra kernel mentir pros processos, fazendo eles acreditarem que estão rodando sozinhos na máquina. 





No caso de Mac, o problema é que Macs não rodam kernel de Linux. Apesar de rodarem programas que parecem de Linux, na realidade são todos recompilados pra serem compatíveis com a versão Darwin do BSD UNIX. Macs são UNIX e não Linux. Eu já contei essa história no episódio sobre as diferenças de Mac, Windows e Linux. Programas de Linux não rodam nativamente em Macs, todos precisam ser no mínimo recompilados. Mac e Linux são binariamente incompatíveis.





Windows, obviamente, também não é uma distro Linux. A kernel do Windows é fundamentalmente diferente de Linux e Macs. Mas hoje em dia existe o WSL 2, que é basicamente uma máquina virtual Linux super leve, rodando por cima do Windows usando a infraestrutura de hypervisor do Hyper-V. Essa é a única solução pra Macs e Windows: rodar Linux numa máquina virtual e, dentro dela, rodar Docker.






Tanto no caso de Mac, quanto Windows, uma das opções mais populares é baixar o pacote Docker Desktop, que vai instalar a máquina virtual pro Docker e uma interface gráfica, que é opcional, pra facilitar gerenciar os diversos elementos de Docker, como redes virtuais, imagens e containers. E aqui está o problema de porque não funciona localhost:9999 em modo de rede host. Segundo a própria documentação: o driver de rede modo host só funciona em Linux, rodando na VM do Docker Desktop, o container não vai receber nenhum endereço IP e a publicação de portas vai ser ignorada, tornando o container inacessível.






Quer dizer que Docker Desktop de Windows e Mac são uma droga, então? Recapitulando, porque estávamos usando modo de rede host? Porque no cenário de teste de carga, o modo padrão gera gargalo, então mudamos pro modo host. Isso é só pra situação de teste de carga. Pro dia a dia, enquanto você está programando, em situações normais, não vai sentir diferença nenhuma. Nesse caso, não precisa usar esse modo host e deixar tudo no padrão. No modo ponte virtual, Docker de Mac e Windows vai funcionar direitinho.



No caso do WSL 2, você pode instalar o Docker ou Podman dentro do WSL em vez de usar uma VM separada, como o Docker Desktop faz.


Falando de Docker Desktop, uma pequena tangente, se você quiser muito uma interface gráfica pra gerenciar imagens, containers e tudo mais, experimente outra opção: o Portainer, que por si só é uma aplicação que roda em container Docker, então é trivial de instalar, e te dá uma interface web de administração muito mais avançada do que Docker Desktop. Mas também é legal aprender a ficar na linha de comando e experimentar coisas como Lazy Docker. Dá pra fazer tudo só com o comando "docker", mas às vezes não lembramos como fazer coisas que não se usa todo dia, tipo, "como era mesmo, pra apagar imagens que não estão sendo usadas?", daí tanto Portainer como Lazy Docker podem ajudar. Dêem uma fuçada.






Na verdade, é muito mais fácil usar o NAT de portas, que é a opção padrão. Vamos pegar o arquivo de nginx do projeto do Lucas, que não optou pelo modo de rede host. Olha a declaração de servidores de upstream. Em vez de estar localhost com duas portas diferentes, tempos aqui dois hostnames diferentes usando as mesmas portas. É como se  estivéssemos declarando dois servidores separados, cada um com uma cópia da aplicação na porta 8080.


```c
    upstream api {
        server app1:8080;
        server app2:8080;
        keepalive 500;
    }
```


No docker compose, podemos declarar o app1, expor a porta 8080, etiquetar com & comercial "app" e lá embaixo declarar o app2 usando a mesma configuração, só sobrescrevendo o hostname. Todo o resto fica igual. Não precisamos nos preocupar em conflito de portas, porque é como se fossem servidores em máquinas diferentes. Essa é a vantagem do NAT de portas e por isso ele é o modo padrão. É muito mais intuitivo. Se não ficou claro isso, assista de novo meu episódio sobre containers e a série de redes.






A versão em PHP do Lauro é uma das mais complicadinhas pra subir, por causa daqueles passos extras no README, que ele preferiu não automatizar. Pra prosseguir a explicação, vamos usar o projeto de Node do Lucas daqui pra frente. O dele é mais simples, basta executar "docker compose up", esperar tudo baixar e pronto. Mesmo em Docker de Windows ou Mac não deve ter problemas porque a versão dele usa NAT de portas padrão, então tudo deveria funcionar plug and play, que é o ideal de um docker compose.






Antes que eu me esqueça, se não está acostumado a usar docker compose, sempre se lembre que se não iniciar o comando "up" com a opção "-d" de daemon, ele vai ficar prendendo seu terminal. Com control-c dá pra derrubar todo mundo. E garanta que os containers desligaram executando "docker compose down". Se modificar seu código e subir depois com "up" mas sentir que não apareceram suas modificações, dá pra forçar o build da imagem da aplicação com "docker compose up --build" ou "docker compose up --force-build".





De outro terminal, dá pra ver os containers que estão de pé fazendo "docker ps". Olha só como aparece bonitinho, daí dá pra abrir o shell em qualquer um deles usando "docker exec -it". Enquanto estiver trabalhando num projeto, pode só ficar derrubando com o comando "down" e subindo com o comando "up". Mas quando terminar o projeto e não for mais mexer nele, vale derrubar uma última vez com "docker compose down --rmi all". Essa opção vai apagar os containers e as imagens. Imagens de docker usam muito espaço em disco e se ficar esquecendo de limpar de projetos que não vai mais usar, vai estar desperdiçando espaço. Depois pesquise sobre como limpar containers e imagens que não está mais usando.






Voltando, chegou a hora de entender um pouco esse negócio de teste de carga. Entenda, foda-se que linguagem você escolheu, que framework usa, as toneladas de javascript que enfiou no front-end. Svelte, Tailwind, nada disso importa. A única coisa que interessa é que entre seu navegador favorito e sua aplicação, trafegam mensagens em formato texto, obedecendo o protocolo HTTP. Mensagens divididas em cabeçalhos e corpo de texto.







O teste que sugeri antes, curl http://localhost:9999/contagem-pessoas é um exemplo disso. O Curl ou Wget são navegadores de linha de comando. Navegadores simples, que não tem front-end e por isso não precisam interpretar nem html, nem css, nem javascript. Eles só listam o que recebem. Fiquei pensando se perdia tempo explicando curl, como mandar e receber mensagens HTTP. Mas isso seria uma tangente desnecessária. Todo desenvolvedor web, tem que saber como enviar e receber mensagens HTTP manualmente, seja via curl na linha de comando, seja via web developer tools em qualquer navegador. Sem saber isso, sinto muito, você nem começou a entender web ainda. Volte vários passos, estude mais, só depois retorne.






Estou sendo bem cuzão quanto a isso porque é sério: HTTP é simples, os cabeçalhos principais dá pra saber de cabeça, os encodings de mensagem, como URL encode, são simples. E se não entender como funciona essa troca de mensagens, tudo daqui pra frente não vai fazer nenhum sentido. Sem saber isso você não entende nem o que é uma API. Sem saber isso não tem nem como começar a falar de problemas de segurança triviais como request forgery, nem otimizações de performance como conditional get requests. 80% da parte mais interessante e mais importante, você nunca vai ter acesso. Então pare aqui e vá estudar antes.







Isso tudo dito, vamos pular direto pro Gatling, que é a ferramenta de stress test, ou teste de carga, que a rinha escolheu. Eles até deram uma pequena patrocinada, acho que com alguns prêmios pros ganhadores. É uma ferramenta que aceita scripts feitos em Scala ou Kotlin. Primeiro de tudo é ter Java instalado na sua máquina. Cuidado, saiu não faz muito tempo o Java 21, e dependendo da sua distro, com um Arch, que instala tudo que tem de novo, vai ter problemas. Escolha manualmente o OpenJDK 17 ou versões mais antigas como versão 11.





Como eu sei que estou com o java correto? Porra, abre o terminal e digita 'java -version'. Se tiver mais de uma jdk instalada, no caso de um Arch, tem o script 'archlinux-java set java-17-openjdk' pra forçar usar a versão 17, por exemplo. Consulte a documentação do pacote de JDK da sua distro. Se for Windows ou Mac, baixe direto o instalador da versão 17 e já era.





Depois disso precisa baixar o Gatling propriamente dito. Só ir no site e baixar o zip. Depois deszipe onde quiser. Eu pessoalmente prefiro deszipar no diretório "/opt/gatling" mas você pode deszipar na sua home. Enfim, o importante é entrar no repositório da rinha, no diretório chamado "stress-test". Lá vai achar o script principal, "run-test.sh". Tem versão de Powershell também, mas honestamente, não perdi meu tempo com isso.





Edite esse script e garanta que a variável GATLING_BIN_DIR está apontando pro diretório bin que veio dentro do zip que baixou. Olhe a linha de baixo, é como ele executa o gatling, passando o script da simulação que é esse RinhaBackendSimulation, que já vamos ver. Em seguida declara os diretórios principais de trabalho. Fica tudo dentro de "stress-test/user-files". Em resources temos planilhas com dados de teste. Vamos dar uma olhada.





O arquivo "pessoas-payloads.tsv" tem os dados de pessoas falsas que ele vai enviar pra API de cadastrar pessoas. Como podem ver, cada linha é um JSON, e os dados são super aleatórios mesmo.  Você acha que todo mundo envia dados bonitinhos pra sua aplicação? Pelo contrário, com o tanto de bots que tem por aí, sua aplicação está recebendo dados parecidos com esse o tempo todo. Nunca assuma que sua aplicação vai ser usada só por pessoas inteligentes que sabem ler e escrever direito. 





Pelo contrário, assuma que a maior parte do uso vai vir de bots zoados ou pessoas zoadas que male male sabem escrever o próprio nome e vão preencher tudo errado. Sua aplicação precisa estar preparada para os piores inputs, sempre. Esse é um bom exemplo de ataque pra ver se coisas inválidas acabam conseguindo burlar suas validações, ou o mais comum, você esqueceu de implementar algumas validações.





O segundo arquivo é o "termos-busca.tsv" que vai ser usado na API de procura por termos. É outra lista de bobagens aleatórias. Mesma coisa, é pra estressar suas APIs e ver como se comportam. Precisa ter validações conforme explicado nas instruções da rinha. Pra um projeto de verdade, é bom ter teste de carga com dados completamente aleatórios como esses, mas também é bom ter dados um pouco mais próximos do que pessoas medianas mandariam, pra ficar mais fácil de analisar depois. Criar dados de teste é, em si, uma arte também. 





Testes com inputs aleatórios como esse são chamados de Fuzz Test. Fuzz é tipo barulho, bagunça, que é um jeito de dizer aleatório. Se você só fizer testes com dados que parecem de verdade, está perdendo a oportunidade de ver os limites das validações. 




Finalmente, temos o script do teste de carga propriamente dito, neste arquivo RinhaBackendSimulation.scala. Mesmo se você nunca escreveu Scala antes, pra fazer scripts simples com esse não é difícil. Qualquer bom programador deve ser capaz de no mínimo ler e entender sem grandes dificuldades. Vamos lá, por partes.





Gatling tem o conceito de Simulation e nossa classe herda dela. Em seguida começamos definindo pra onde mandar nossa carga. No caso a URL base é localhost porta 9999, onde configuramos o NGINX no Docker Compose, lembram? Como nossa aplicação não tem tratamento pra nenhum cabeçalho, só isso já basta. Só de brincadeira, colocaram um user agent fake aqui.



```scala
class RinhaBackendSimulation
  extends Simulation {

  val httpProtocol = http
    .baseUrl("http://localhost:9999")
    .userAgentHeader("Agente do Caos - 2023")
```






Seguimos declarando uma variável "criacao E consulta pessoas" que é um "scenario". Imagino que essa função "scenario" tenha na classe abstrata Simulation que estou estendendo. Ela devolve um objeto onde podemos sair encadeando várias chamadas de configuração. A API de configuração é bem legível. Olha só: no cenário criação e talvez consulta de pessoas, alimente com o arquivo formato tsv "pessoas-payloads.tsv" e considere  sendo circular, ou seja, se chegarmos no fim do arquivo, recomece da primeira linha de novo. Pra cada linha execute o bloco a seguir.


```scala
  val criacaoEConsultaPessoas = scenario("Criação E Talvez Consulta de Pessoas")
    .feed(tsv("pessoas-payloads.tsv").circular())
    .exec(
		.... // bloco
    )
```


Nesse bloco começamos chamando outro método da simulação, "http", que imagino que controla uma chamada http. Configuramos com uma chamada POST pra endpoint "/pessoas", onde o corpo vai ser o payload, que é uma linha do arquivo de carga que estamos lendo. Como único cabeçalho configuramos "Content-type" pra ser o mime-type "application/json". Todo framework que se preza, checa content type.


```scala
.exec(
  http("criação")
  .post("/pessoas").body(StringBody("#{payload}"))
  .header("content-type", "application/json")
  // 201 pros casos de sucesso :)
  // 422 pra requests inválidos :|
  // 400 pra requests bosta tipo data errada, tipos errados, etc. :(
  .check(status.in(201, 422, 400))
  // Se a criacao foi na api1 e esse location request atingir api2, a api2 tem que encontrar o registro.
  // Pode ser que o request atinga a mesma instancia, mas estatisticamente, pelo menos um request vai atingir a outra.
  // Isso garante o teste de consistencia de dados
  .check(status.saveAs("httpStatus"))
  .checkIf(session => session("httpStatus").as[String] == "201") {
	header("Location").saveAs("location")
  }
)
```


Essa função "check" não tenho muita certeza do que faz e não tive paciência pra ir ler na documentação, mas não me parece importante pra agora. Deve ser algo como, "considere que está certo se o resultado da requisição voltar com código de status 201, 422 ou 400". Se voltar um crash com erro 500, ou página não encontrada que é 404, ou outra coisa, considere como um erro e reporte em vermelho.





Depois temos um novo check, pedindo pra salvar alguma coisa chamada "http status". Podemos ver que vai ser usado na chamada checkIf abaixo. Essa linha parece dizer o seguinte: execute o bloco seguinte se o código http de status que gravamos na linha anterior for código 201, que é o código http correto quando um recurso é criado no servidor. Se for esse o caso, o bloco seguinte deve salvar o valor que voltar no cabeçalho de Location, dentro dessa sessão chamada "location". Lembre-se disso em design de APIs: sempre que um recurso é criado no servidor, retornando código 201, também deve retornar um cabeçalho chamado Location com a URL completa para este novo recurso. É isso que estamos guardando.






Saindo desse bloco, o cenário dá uma pausa de 1 a 30 milissegundos. Em seguida, caso uma sessão de location tenha sido gravado, ele pede pra executar uma nova requisição http para esta location. Se for encontrado, o servidor deveria retornar código http 200 e o json do registro. Se for retorno 200 a simulação deve considerar como verde OK. Se voltar qualquer outro código, deve considerar vermelho knock out.



```c
    .pause(1.milliseconds, 30.milliseconds)
    .doIf(session => session.contains("location")) {
      exec(
        http("consulta")
        .get("#{location}")
      )
    }
```


Como o comentário explica, o Zanfrancheschi, que desenhou o desafio da rinha, fez a coisa certa. Pro desafio ser minimamente interessante, só criar uma API que grava uma nova pessoa no banco, seria muito simples. Qualquer um que já tenha terminado pelo menos um tutorial de curso deveria conseguir. Mas, subir duas instâncias da mesma aplicação e colocar embaixo de um proxy reverso cria uma situação um pouco mais interessante. 






Digamos que você tenha feito otimização prematura. Vamos tentar ser mais espertos. Ao receber o JSON via POST em /pessoas. Guardamos em memória, sem mandar insert pro banco, pra gravar assincronamente mais tarde, e assim podemos responder imediatamente código http 201. Como geramos um UUID aleatório antes de mandar pro banco, dá pra gerar a URL de Location. Seria algo como "http://localhost:9999/pessoas/:uuid"




O script do Gatling dá uma pausa de 1 a 30 milissegundos e manda puxar essa URL que voltou no cabeçalho de Location. Se antes desses 30 milissegundos, nossa aplicação não conseguir realmente gravar no banco, tem chance da consulta cair na segunda instância. Se o registro não teve tempo de ser gravado, não vai ser encontrado e vamos receber 404 not found. A simulação iria registrar um erro. Então, só segurar o registro em memória pra responder mais rápido iria quebrar essa condição de pesquisa do teste, tem que ser mais esperto que isso.






A expectativa da rinha, com os limites de CPU e RAM impostos, o requerimento de colocar duas ou mais instâncias, e impor uma carga pesada, enganaria programadores mais calejados a caírem no erro de tentar otimização prematura, colocando coisas como caches ou filas, como expliquei no episódio passado. Se fizer do jeito mais ingênuo que é primeiro escrever no banco e depois devolver código 201 com a URL de Location, vai tudo funcionar corretamente. Mas será que aí o tempo de espera de gravar no banco não vai fazer o NGINX dar timeout em muitas requisições?






E não, foi isso que descobrimos na exploração do episódio de 16 linguagens: todos nós subestimamos o banco de dados Postgres. Acontece que pra casos simples como esse, de inserts simples, ele é tão rápido quanto um servidor de cache como Redis. Qualquer otimização extra não faz diferença. A otimização de usar modo de rede host em vez de NAT de portas virtuais fez mais diferença do que tentar otimizar o Postgres com alguma solução de cache. Já vou voltar nisso, vamos só terminar de ler o arquivo de simulação.





O cenário de criação de pessoas, seguido da consulta dessa pessoa recém-criada, é o cenário mais comprido. Nem é difícil, só comprido. Os outros dois cenários são mais curtos. No "busca pessoas", o cenário se alimenta do arquivo tsv "termos-busca.tsv", novamente em modo circular, e pra cada linha do arquivo, faz uma requisição GET no endpoint "/pessoas" passando a variável "t=", concatenando o parâmetro de busca.


```c
  val buscaPessoas = scenario("Busca Válida de Pessoas")
    .feed(tsv("termos-busca.tsv").circular())
    .exec(
      http("busca válida")
      .get("/pessoas?t=#{t}")
      // qq resposta na faixa 2XX tá safe
    )
```


Acho que se não configurar explicitamente, o cenário considera que respostas 200 são OK e qualquer coisa diferente é erro. Por fim, temos o cenário de busca inválida de pessoas, que é o mesmo endpoint, só não passando nenhum termo de procura. Segundo a instrução da rinha, isso deveria retornar código de erro 400, que é o que o script vai checar mesmo. Se devolver 400, marca como verde, OK.


```c
  val buscaInvalidaPessoas = scenario("Busca Inválida de Pessoas")
    .exec(
      http("busca inválida")
      .get("/pessoas")
      // 400 - bad request se não passar 't' como query string
      .check(status.is(400))
    )
```


Com os 3 cenários declarados, agora o script define um bloco que chama de "setup". Literalmente, configurar como os cenários devem rodar. Em todos os casos, começa dizendo "comece com 2 usuários constantes por segundo, durante 10 segundos", na sequência fala "prossiga agora com 5 usuários por segundo, durante 15 segundos". É uma carga leve, só de warm up, ou aquecimento mesmo.


```c
setUp(
	criacaoEConsultaPessoas.inject(
	  constantUsersPerSec(2).during(10.seconds), // warm up
	  constantUsersPerSec(5).during(15.seconds), // are you ready?
	
	  rampUsersPerSec(6).to(600).during(3.minutes) // lezzz go!!!
	),
	...
).protocols(httpProtocol)
```


Em seguida começa a carga de verdade, olha só "ramp", que quer dizer ir aumentando, como numa rampa mesmo. Vá aumentando, começando com 6 usuários por segundo, até atingir 600 usuários por segundo, acelerando constantemente durante 3 minutos, mantendo um crescimento linear. Agora sim, isso vai gerar uma carga pesada até o final. Entenderam? 





Mas não é só isso, em paralelo vai rodar também os cenários de busca e busca inválida. Ambos fazem um aquecimento pequeno pelos mesmos 25 segundos. Daí já começa, ramp de 6 usuários por segundo, até atingir 100 usuários fazendo buscas válidas por segundo, durante os mesmos 3 minutos. E por fim, ramp de 6 usuários por segundo até 40 fazendo buscas inválidas por segundo, durante 3 minutos.


```c
	buscaPessoas.inject(
	  constantUsersPerSec(2).during(25.seconds), // warm up
	
	  rampUsersPerSec(6).to(100).during(3.minutes) // lezzz go!!!
	),
	buscaInvalidaPessoas.inject(
	  constantUsersPerSec(2).during(25.seconds), // warm up
	
	  rampUsersPerSec(6).to(40).during(3.minutes) // lezzz go!!!
	)
```


Em cada cenário, só configuramos que busca é um get pra "/pessoas" ou criação é um post pra "/pessoas", mas como ele sabe pra onde mandar essas requisições? Pra isso serve aquela configuração que fizemos lá no começo do script, declarando que a URL base é "localhost" porta 9999 lembram? No final do setup, plugamos essa configuração. E pronto, é isso! Vamos ver rodando.






Pra ficar claro, tenho um terminal dividido em dois, usando split horizontal do TMUX. Na metade de cima, estamos no projeto do Lucas Poole em Node. Podemos chamar "docker compose up" e esperar os serviços todos subirem. Na metade de baixo, estou no diretório de "stress-test" do repositório da rinha, onde tem o script "run-test.sh", que vamos rodar agora. Pronto, passa aqueles 25 segundos de aquecimento e aí começa a brincadeira. Agora é esperar os 3 minutos dos cenários.





Lembram que o script configura 3 cenários? Estão aqui: Busca Inválida, Busca Válida e Criação. Em cima tem um resumo, embaixo tem um pouco mais detalhado. O principal: OK são requisições que devolveram códigos http válidos de resposta, como 200, 400 ou 422. Tudo que devolveu erro, código 500, timeout, acho que ele considera como KO ou Knock Out. São as requisições perdidas.









Voltando, depois de algum tempo rodando, quando a carga apertar mais pro fim, em vários dos projetos participantes, vamos ver este erro sendo reportado: java.io.IOException: Premature Close. Esse é o erro que o Vinicius Ferraz descobriu como consertar mudando de network_mode bridge pra host. Olha só o que essa mensagem está dizendo: mais de 9 mil requisições perdidos nesse exceção. 9 mil, num total de pouco mais de 100 mil requisições, é um número considerável, quase 10% de erro.






Vamos abrir o gráfico que o Gatling gera. No mundo ideal gostaríamos de ver somente essa barra verde, sem nada vermelho do lado. Mas temos vermelho. Olhando aqui na tabela veja só, de um total de 108 mil requisições, tivemos quase 99 mil que deram OK, mas quase 10 mil em vermelho, que deram knock out. Já volto nessa tabela, vamos olhar mais pra baixo os gráficos.






Lembram como configuramos pra iniciar os três cenários em paralelo, pra ir subindo de 6 usuários pra mais de 600 simultâneos por segundo? Um ramp up? Por isso o formato do gráfico é um triângulo. Começa com 6 usuários por segundo e vai subindo, ramping up, com aceleração constante, aumentando a velocidade linearmente, até mais de 600 usuários. Por mais de 2 minutos, mais de dois terços do tempo, cresce sem problemas. Mas aí olha essa parte final.







O final é cheio de "sobes e desces", esse serrilhado. Aqui a aplicação tá claramente engasgando. Muitas requisições em fila não conseguem ser atendidos, ou demoram demais pra responder, ou dão timeout de tanto esperar. Por isso, no último gráfico, começamos a ter várias áreas vermelhas. Lembrando que muitos desses vermelhos são os IOException de Java que mencionei antes.






Mas será que realmente faz tanta diferença assim? Pra demonstrar, podemos modificar o código do Lucas pra usar network mode host. Começamos mudando o "index.js" que carrega o node.js na porta 8080, hardcoded, e trocar por uma variável de ambiente chamada "HTTP_PORT", que podemos configurar no docker compose. 


```diff
@@ -62,6 +62,7 @@ app.get('/contagem-pessoas', (_, res) => {
 app.use(errorHandler);

 const numForks = Number(process.env.CLUSTER_WORKERS) || 1;
+const httpPort = Number(process.env.HTTP_PORT) || 8081;

 if(cluster.isPrimary && process.env.CLUSTER === 'true'){
     logger.info(`index.js: Primary ${process.pid} is running`);
@@ -74,8 +75,8 @@ if(cluster.isPrimary && process.env.CLUSTER === 'true'){
         logger.info(`index.js: worker ${worker.process.pid} died: code ${code} signal ${signal}`);
     });
 } else {
-    const serverApp = app.listen(8080, () => {
-        logger.info(`index.js:${process.pid}:Listening on 8080`);
+    const serverApp = app.listen(httpPort, () => {
+        logger.info(`index.js:${process.pid}:Listening on ${httpPort}`);
     });
```



Agora adicionamos essa variável no docker compose e colocamos network_mode host em todos os serviços, como neste trecho de código. Veja como também mudamos a URL de conexão com o banco de dados pra ser localhost. Não vai mais ter NAT pra um host virtual chamado "postgres". A rede virtual do Docker possui um DNS interno, que traduz nomes como "postgres" pro endereço virtual, no modo de rede virtual. Em modo host, o container se pendura direto no localhost, por isso temos que nos preocupar com conflito de portas agora.


```diff
@@ -1,17 +1,19 @@
 version: '3.4'
 services:
-  app1: &app
+  app1:
     # image: lukas8219/rinha-be-2023-q3:latest
     build: .
     hostname: app1
     environment:
-      DB_URL: "postgres://postgres:12345678@postgres:5432/postgres"
+      DB_URL: "postgres://postgres:12345678@localhost:5432/postgres"
       DB_POOL: 35
       PINO_LOG_LEVEL: "debug"
       REQ_TIMEOUT: "2000"
       NODE_ENV: production
       CLUSTER: true
       CLUSTER_WORKERS: 5
+      HTTP_PORT: 8080
+    network_mode: host
     expose:
       - "8080"
     depends_on:
@@ -27,8 +29,32 @@ services:
           cpus: '0.5'
           memory: '0.6GB'
```


A última coisa, depois de ajustar o docker compose, é ajustar a configuração do nginx. Repetindo, não tem o DNS interno da rede virtual, tudo é localhost, então temos que mudar os servidores upstream do proxy reverso pra ser localhost. Subimos uma instância da aplicação na porta 8080 e outra na 8081, pra não conflitar.


```diff
@@ -11,8 +11,8 @@ http {
     error_log /dev/null emerg;

     upstream api {
-        server app1:8080;
-        server app2:8080;
+        server localhost:8080;
+        server localhost:8081;
         keepalive 500;
     }
```




Pronto, não mostrei configuração dos demais serviços no docker compose mas já deve ter dado pra entender, né? Fica de exercício repetir essa modificação em um dos projetos da rinha. Eu mesmo contribuí pull requests em vários dos projetos participantes justamente pra adicionar essa pequena otimização. Se eu consegui, vocês também conseguem. Agora podemos subir com "docker compose up" de novo e, se não tiver nenhuma mensagem de erro, no outro terminal podemos rodar o Gatling de novo. Não vou mostrar rodando tudo de novo, vamos direto pro final. 





A última coisa que o script de Gatling faz é chamar o endpoint "/contagem-pessoas". Da última vez tinha voltado que conseguiu gravar no banco uns 40 mil registros. Mas agora, olha a diferença, devolveu  quase 47 mil registros. É uma diferença considerável. Se voltarmos nos resultados que estavam aparecendo no terminal, olhem, não tem mais aquela mensagem de Premature Close do IOException de Java. Vamos abrir os gráficos.






Vou colocar o anterior na esquerda e o novo na direita. Mesmo aplicativo, única coisa que mudou na direita é que subimos docker compose com os serviços em modo de rede host. De cara já podemos ver que a barrinha vermelha sumiu. Ótimo sinal. Apareceu um pouco de laranja. O que antes tava dando vermelho, agora demora mais, mas vai até o fim e responde. Isso que é laranja. Olha a tabelinha mais pra baixo, antes conseguíamos só um total de 108 mil requisições, agora conseguimos mais de 115 mil requisições. Mais importante: antes teve um total de quase 10 mil knockouts, mas agora foram só uns 150. Diferença brutal.







Dando um zoom aqui do lado, tem um conceito que acho importante que todos entendam. Praticamente todo iniciante pensa em tempo de resposta médio. Média é esta coluna aqui pro fim, "mean". O que é média? É tabular quanto que levou pra responder cada uma dessas 115 mil requisições, somar tudo e dividir pelo total de requisições. Esse tempo deu 879 milissegundos. Quase 1 segundo por requisição. Se tinha alguma dúvida, esse tempo de resposta é absurdamente lento. Qualquer coisa acima de meio segundo é inaceitável em qualquer aplicação. O certo é sempre manter menos que 100 ou 50 milissegundos.






Veja logo do lado, desvio padrão de 1.7 segundos. O desvio padrão é maior que a média. Só um desvio padrão pro lado e já estamos falando de mais de 2 segundos por requisição. É uma ordem de grandeza inteira. O que isso diz sobre sua aplicação? Nada importante. Vamos entender os números das colunas anteriores, que são mais interessantes.





Olha aqui, 99th percentile. Essa coluna diz o tempo que levou pra responder o 1% das requisições mais lentas nesse teste. Isso dá mais ou menos 1.150 requisições. Soma o tempo delas, divide por 1.150 e isso dá quase 8 segundos. E faz sentido, provavelmente são as últimas mil e tantas requisições desse teste de carga, quando nos aproximamos dos 600 usuários por segundo que configuramos no cenário do Gatling.






Descemos pro 95th percentile, os 5% mais lentos. Já cai pra pouco mais de 5 segundos por requisição. Vamos pro 75th percentile, os 15% mais lentos, já cai pra faixa de 1 segundo por requisição. Veja como os tempos caem drasticamente. No 50th percentile, a média da metade mais lenta de requisições, é na faixa de 2 milissegundos. Vamos olhar nos gráficos lá embaixo pra ter uma noção melhor disso.






Olha esse primeiro gráfico, vejam com os tempos de resposta por requisição se mantiveram super baixo, lá na casa dos 2 milissegundos por quase todo o teste de carga. Lembrando que configuramos o Gatling pra ir subindo de 6 usuários por segundo até 600 ao longo de 3 minutos. Por mais de 2 minutos, nosso setup segurou super bem, quase não varia esse tempo, mesmo aumentando quantidade de pessoas. Mas aí começa o desespero. Veja como os tempos de resposta aumentam drasticamente, salta pra faixa de 5 segundos, tenta cair, mas volta a subir até quase 10 segundos.







No gráfico logo abaixo temos o número de requisições por segundo. De novo, como estamos subindo número de usuários linearmente, o número de requisições também sobe linearmente e, se tivesse recursos sobrando, esse gráfico seria perfeitamente linear até o fim. Mas naquele mesmo trecho, onde os tempos de resposta sobem, começa a ficar serrilhado, até dar um crash drástico na quantidade de requisições por segundo que conseguimos responder.





O gráfico em azul é o número de requisições que conseguimos aceitar, já o gráfico abaixo é o número de respostas que nossa aplicação conseguiu devolver. Verde são os OK, vermelho são os knockouts. Graças ao modo de rede host, veja como quase não tem vermelho, mas se olharmos o gráfico anterior, veja como tinha muito mais vermelho nessa faixa de respostas. 






Voltando pra tabelinha, entendam: média de tempo de resposta por requisição não diz nada. Média de 879 milissegundos por requisição. Não diz nada. Agora, lendo o gráfico sabemos que a requisição que mais demorou pra ser respondida demorou mais de 9 segundos, que é essa coluna de máximo. Sabemos que apesar de 5% das requisições ter demorado pra caramba, na faixa de 5 segundos, a grande maioria conseguiu ter resposta na faixa de 2 milissegundos, o que é excelente. 





O que causou essa lentidão de segundos na faixa do 95th percentile, não é problema de código, mas limitação de recursos da infraestrutura mesmo. Não tem muito mais que se possa fazer em código pra encurtar tempo de forma significativa. Eu sei, porque eu tentei, em 16 linguagens, lembram do outro video? É mais fácil aumentar os recursos, um pouco mais de CPU, um pouco mais de RAM.






Por outro lado, se no 50th percentile os tempos estivessem na faixa de 1 segundo ou mais. Aí sim, o problema seria definitivamente no código, um gargalo que precisaria ser corrigido. Vocês precisam rodar benchmarks assim em diversos tipos de projetos, diversos tipos de endpoints, pra começar a ter noção de que tipos de tempos de resposta mínimo, máximo, 95th percentile e 50th percentile, são considerados bons ou ruins. 





Esses números são importantes pra ajudar a decidir se vale a pena perseguir otimização de código ou simplesmente alocar mais hardware. Seu "achômetro", sem números, não vale nada. "Ah, eu acho que temos que reescrever esse código em outra linguagem". Me mostre os números. Se não é capaz de gerar estes números, eu sei que também é incapaz de reescrever qualquer coisa pra ficar melhor. 






Achei bacana esta rinha ter dado ênfase em um desafio de backend baseado em benchmark e teste de carga. Eu acho que todo bom programador sempre tem uma ferramenta de benchmark guardado na manga pra usar justamente em momentos de decisão como o que falei antes: vale a pena parar pra otimizar? Quanto de melhoria estamos esperando ter ao custo de quanto tempo pra arrumar? Só aumentar máquina resolveria? Faça medições pra saber.






Eu não conhecia o Gatling, mas achei uma ferramenta muito boa, especialmente porque gera gráficos fáceis de ler e de mostrar pros outros. Existem outras ferramentas que eu usava mais antes, como o antigo Apache Bench ou o WRK que acho que fala "work". Pra mim esses dois eram tão essenciais quanto saber usar wget ou curl. Recentemente mexi um pouco no tal de Vegeta também, que parece ser mais na categoria do Gatling. E tem dezenas de outros, open source e comerciais. Não deixem de fuçar as opções e testar todas que puder.







Espero que tenham entendido até aqui, porque agora acho que vai ficar um pouco mais complicado, no sentido que vou discutir conceitos de mais alto nível. Se começar a achar que complicou, é a mesma coisa de sempre, anotem os termos que não entenderam e pesquisem. Depois voltem e vejam se conseguem acompanhar o raciocínio até o fim. Até agora foi mais um aquecimento.






Eu deixei de lado banco de dados até agora pra poder atacar esse assunto de uma só vez agora. Eu já fiz um video falando mais sobre como bancos de dados funcionam por baixo, então recomendo que assistam lá se não viram ainda. Ter na cabeça essa estrutura vai ser importante pra entender o que vou explicar agora.





Como disse no primeiro video da rinha, o erro que quase todo mundo cometeu neste desafio foi subestimar o Postgres. Se fosse MySQL teria sido a mesma coisa: nós teríamos achado que seria o gargalo. Isso porque na nossa experiência em projetos de verdade, na maior parte do tempo, o gargalo costuma ser o banco de dados. Por que?




Porque em sistemas mais realistas, com centenas de tabelas, milhares de índices, milhares de relacionamentos entre tabelas, qualquer operação de insert ou update costuma mexer não só em uma linha de uma única tabela, mas pode acionar triggers, gatilhos, pra rodar procedures em outras tabelas. Pode acionar gatilho pra atualizar múltiplos índices. Então nenhuma operação é "simplesmente" só mexer uma linha, normalmente são múltiplas operações acontecendo em múltiplos lugares diferentes. Isso custa tempo, às vezes pode levar dezenas de milissegundos.





Mesma coisa queries, selects. Em sistemas complexos normalmente temos queries com vários inner joins, outer joins, sub-selects, unions. Toda consulta, na realidade, precisa acionar diversos índices, fazer alguns table scans, então pode demorar, talvez dezenas de milissegundos. Pra piorar temos o custo por conexão. No caso de um postgres, cada conexão ao banco pode custar na faixa de 2 a 4 megabytes. 100 conexões poderiam exigir quase meio gigabyte de RAM. 





Por isso precisamos usar pools de conexão pra reciclar conexões. Quando uma requisição termina de ser respondida, o framework devolve a conexão livre pro pool. Assim, outra requisição pode reusar a mesma conexão, sem precisar alocar mais 4 megabytes extras toda vez. Quando estamos falando de milhares de requisições por segundo, megabytes se tornam gigabytes muito rápido, se não tomarmos cuidado.





Lembram do nosso gráfico? Eu disse que uma resposta levar 2 milissegundos é muito bom. Mas se levar 10 milissegundos só pra inserir um registro numa tabela, não vai ser ruim? Vai sim. Por isso em projetos de verdade usamos diversas estratégias pra economizar processamento no banco o máximo possível. Usamos pelo menos dois tipos de estratégia: uma pra leitura, onde cacheamos resultados, pra evitar toda hora repetir as mesmas queries pesadas, e estratégia de filas de jobs assíncronos, pra evitar metralhar o banco com operações demais de gravação e modificação.







Lembrando: toda operação de modificação bloqueia um ou mais registros em uma ou mais tabelas no banco. Por cima desses locks temos transações, logs transacionais pra, caso de aconteça alguma pane, a gente não tenha perda de dados, sem deixar nada corrompido. Toda essa proteção custa processamento e custa tempo. Toda pesquisa sendo feita em tabelas que estão constantemente sendo modificadas significa que uma operação de leitura fica concorrendo com uma operação de escrita por esses locks. Ou seja, se não tivermos controle e recebermos um volume grande demais de escritas, ao mesmo tempo várias leituras, tudo vai ficar lento até parar.







Por isso precisamos desafogar o banco de dados. Dá pra criar servidores separados de réplicas somente de leitura. Dessa forma, podemos separar um banco mestre só pra escrita e bancos só de leitura, pra onde podemos mandar as queries. Mas réplicas não saem de graça: quanto mais réplicas colocar, maior o peso pra manter eles sincronizados. Quando falamos em cache estamos falando em serviços em paralelo como Memcache ou Redis. Até na AWS existe o serviço ElastiCache, que é uma interface pra memcache ou redis como serviço.






No caso de filas, alguns usam Nats ou Redis como gerenciador de fila. Funcionam, mas não recursos avançados. Não oferecem muitas das garantias de um sistema de filas maior. Assim como um banco relacional deve oferecer as proteções ACID, uma fila de verdade precisa de garantias, por exemplo, garantindo que um elemento na fila nunca vai ser duplicado. Filas de verdade são coisas como o lendário RabbitMQ ou o mais popular Apache Kafka. AWS também tem um serviço, o SQS, que é o Simple Queue Service.




No caso do cache a ideia é simples: primeiro pergunta pro cache se ele tem a resposta. Se não tiver, aí manda a query pro banco de dados, daí guarda o resultado no cache pra próxima vez. Dessa forma, o banco não precisa ficar sendo redundante e gastar processamento pra responder o que já acabou de responder. O Cache é uma memória temporária pra diminuir a carga de pesquisa.




No caso de filas a ideia é um pouco mais complicada: em vez de metralhar o banco de dados com operações de modificação, jogue todas essas operações numa fila. Configure um número limitado e controlado de trabalhadores, workers, que ficam escutando essa fila, e vão puxando essas operações. O número de workers é o número de conexões que sabemos que o banco aguenta sem começar a ficar muito lento.






Tudo isso eu já expliquei no episódio de "Tornando sua App Web mais rápida" e também no episódio onde sugiro como o site Ingresso.com poderia melhorar sua arquitetura. E sabendo de tudo isso, claro, como as instruções da rinha pediam pra limitarmos o uso de recursos do Docker pra no máximo 1.5 CPU e 3 giga de RAM, e sabendo que vai rodar um teste de carga com milhares de inserts e pesquisas simultâneas, o primeiro instinto foi pensar: bora já garantir e colocar cache nas pesquisas e filas e jobs pros inserts.






Eu fiz isso na minha primeira versão de Ruby on Rails, que vocês podem ver no meu GitHub, e como vimos no episódio anterior, diversos projetos que eu avaliei fizeram algo similar. Alguns colocaram só cache de redis. Alguns tentaram adicionar algum tipo de fila. Mas o fato é que se pararmos pra pensar friamente no que exatamente é este projeto e qual é a carga, já dá pra saber que qualquer coisa mais sofisticada assim era matar uma mosca com bazuca.






Esses projetinho inteiro tem uma única tabela. Só uma. Não tem relacionamento nenhum, não tem chave estrangeira, não tem joins, nada. Lembram daquela planilha de dados aleatórios que o script de Gatling usa pra fazer os inserts? Quantas linhas tinha? 100 mil? Eu diria, "só" 100 mil, e durante os 3 minutos de carga, qual é o total de requisições? Umas 100 mil mesmo. Qual é a contagem final de registros inseridos? Faixa de 45 a 50 mil registros. Entenda, isso é absurdamente pouco. Ordem de poucos milhares de registros é quase nada. Qualquer computador furreca dos anos 80 sabe lidar com milhares de registros. 






Um banco com uma única tabela de míseras 50 mil linhas, sofrendo não mais que 100 mil tentativas de inserts, é algo miseravelmente pequeno. Bancos de dados de verdade tem centenas de tabelas, a maioria com centenas de milhares de linhas, muitas com milhões, dezenas de milhões de linhas. Isso sim começa a parecer "grande". Uma única tabela é um hello world.





Portanto, apesar de ser divertido de implementar, nem cache de leitura, nem fila de jobs de escrita era realmente necessário. Bastava usar o banco normalmente. Um Postgres é mais do que capaz de fazer inserções simples assim de forma extremamente rápida. Na verdade vai ser na mesma ordem de grandeza de tempo do que escrever num banco de cache como Redis, por isso não faz diferença nesse caso. Só faz diferença usar Redis quando a escrita for ordens de grandeza mais rápido porque o Postgres está tendo que lidar com operações muito pesadas em cima de um volume realmente grande de dados.








Entenderam? Muita gente ainda pensa que Redis ou Memcache é automaticamente mais rápido do que qualquer banco de dados. Isso não é verdade. Um banco de dados quase vazio vai ser tão rápido quanto um Redis. Mesma coisa se você exagerar e colocar coisa demais no Redis, ele vai ficar lento também. Nada é automático em programação. Se você encarar dessa forma, tudo que fizer sempre vai sair uma droga. "Ah, mas o Redis não devia cuidar de tudo sozinho e ser mais rápido??" Lógico que não, idiota.






Mas havia de fato um pequeno fator de preocupação. Na API de pesquisa por termos, a rinha pede pra pesquisar ou no campo de nome ou no campo de apelido ou no campo de tecnologias. Ficaria um select com ILIKE "%blabla%" OR ILIKE "%blabla%", que é simplesmente um dos piores tipos de pesquisa que se pode fazer em SQL. 






Por causa desses porcentos no começo e no fim, significa que não temos como usar um índice. Índices funcionam pra pesquisas exatas. Pesquisa parcial, o único jeito é fazer pattern matching em todas as linhas da tabela. Uma vez pra cada campo depois de "OR". Como temos três campos pra pesquisar, vão ser três table scans por todas as linhas da tabela até aquele ponto. Isso pode ficar pesado muito rápido sem você perceber. Se num determinado momento a tabela tiver 10 mil linhas, vamos ter que fazer 30 mil operações de comparação. E quanto maior fica a tabela, mais longa fica a pesquisa. E qual a solução?






Recomendo assistirem depois o episódio do código vazado do algoritmo do Twitter, onde eu faço uma tangente pra explicar o que é full-text search, ou pesquisa por embeddings em espaço vetorial. Não vou repetir o que expliquei lá, mas é o que está por baixo de como um Google ou Bing conseguem responder qualquer pesquisa tão rápido e com os resultados mais relevantes logo no topo da primeira página de resposta. Todo banco de dados moderno tem suporte a algo similar, e isso é chamado de "full text search".





No caso do Postgres existem duas técnicas mais conhecidas: GIN e GIST. GIN significa Generalized Inverted Index ou Índice Invertido Generalizado e é mais recomendado pra estruturas de dados complexas como arrays, JSONB, hstore. É otimizado pra pesquisas de múltiplas chaves e permite indexação dos valores individuais de um array, chaves de um JSONB e assim por diante. O índice GIN é construído ao extrair chaves dos valores indexados e criando uma lista de postagem, uma lista ordenada de ponteiros para as linhas indexadas. 





GIST vem de Generalized Search Tree ou Árvore de Procura Generalizada. GIST é uma técnica de indexação de uso mais geral e requer a implementação de métodos de procura customizadas. Pode ser usado pra indexar praticamente qualquer tipo de dados no Postgres, incluindo dados espaciais, tipos de dados customizados e qualquer tipo de texto. Índices GIST são caracterizados por uma estrutura hierárquica de nós. 





Podemos somar GIST com o suporte a uma extensão de trigramas. LEu explico sobre n-grams no video do Twitter. Vamos mostrar na prática o que todo esse mambo jambo significa. Pra isso vou abrir o código que cria a tabela no banco. O Lucas fez bem em adicionar esse código no Node.js. Ele inicia importando a biblioteca "pg" e cria um Pool de conexões usando a URL de conexão que vem da variável de ambiente DB_URL no docker compose.


```js
const pg = require('pg');
const { logger } = require('./logger');

const URL = process.env.DB_URL || 'postgres://postgres:12345678@localhost:5432/postgres';

const pool = new pg.Pool({ connectionString: URL,
    max: (Number(process.env.DB_POOL) || 200),
    idleTimeoutMillis: 0,
    connectionTimeoutMillis: 10000
    });
```


Daí registra um evento no pool, o evento "connect", que diz: assim que conectar, execute a função anônima a seguir, que vai enviar uma query pro pool. Essa query são comandos em SQL. Como temos duas instâncias de Node subindo ao mesmo tempo, em ambos vai executar essa função, então precisamos escrever os comandos pra, caso já exista o que queremos criar, só ignora e segue em frente.


```js
pool.once('connect', () => {
    logger.info(`database.js: Connected  to db ${URL}`)
    logger.info(`Creating table "pessoas" if not exists`);
    return pool.query(`
        CREATE EXTENSION IF NOT EXISTS pg_trgm;

        CREATE OR REPLACE FUNCTION generate_searchable(_nome VARCHAR, _apelido VARCHAR, _stack JSON)
            RETURNS TEXT AS $$
            BEGIN
            RETURN _nome || _apelido || _stack;
            END;
        $$ LANGUAGE plpgsql IMMUTABLE;
```


Por exemplo, o primeiro comando diz: "se já não existir, crie a extensão pg_trgm", que é a extensão que dá suporte a tokenizar textos em trigramas. Em seguida, "crie ou substitua caso já exista, a função generate_searchable, que recebe os parâmetros nome, apelido e stack, todos de tipo varchar". Lembram? Varchar é variable characters, uma lista de caracteres de tamanho variável, basicamente uma string.





A função retorna um valor de tipo texto, e esse texto vai ser a concatenação dos campos nome, apelido e stack, tudo junto. Mas pra que isso? Paciência que já vai entender. Na sequência, caso não exista, criamos uma tabela com nome "pessoas", que é a tabela principal. Primeiro campo se chama "id" de tipo UUID. Opcionalmente podemos declarar que se não passarmos um valor explicitamente, pra gerar um uuid aleatório usando a função gen_random_uuid(), além disso a constraint é que esse campo deve ser único e não nulo.



```sql
CREATE TABLE IF NOT EXISTS pessoas (
	id uuid DEFAULT gen_random_uuid() UNIQUE NOT NULL,
	apelido TEXT UNIQUE NOT NULL,
	nome TEXT NOT NULL,
	nascimento DATE NOT NULL,
	stack JSON,
	searchable text GENERATED ALWAYS AS (generate_searchable(nome, apelido, stack)) STORED
);
```


Em seguida, declaramos o campo apelido como sendo tipo texto, também único e não nulo. Campo nome deve ser tipo texto e não nulo. Campo nascimento deve ser tipo Date e não nulo. Campo stack deve ser tipo JSON, que é uma das vantagens de usar Postgres, porque ele permite tipos de dados mais complexos como JSON. Não precisa de MongoDB pra isso. E, finalmente, declaramos uma coluna especial, de nome "searchable" e tipo text.





Só que esse campo declaramos como um campo "generated". É um campo cujo valor vai ser gerado automaticamente em toda operação de insert ou update e vai usar o retorno desta função que declaramos antes, o generate_searchable. Lembram o que ela faz? Devolve os valores de nome, apelido e stack concatenados. É isso que esse campo vai ter. Mas por que?





O próximo comando SQL é, caso não exista, pra criar um novo índice chamado idx_pessoas_searchable, na tabela pessoas, usando GIST. Ao GIST dizemos pra indexar aquela coluna "searchable" usando o operador de classe "gist_trgm_ops", que é especificamente desenhado pra tokenizar esse campo em trigrams, que são conjuntos de 3 caracteres, quebrados, ou tokenizados, de cada palavra da string. É isso que permite pesquisas parciais.


```sql
CREATE INDEX IF NOT EXISTS idx_pessoas_searchable ON public.pessoas USING gist (searchable public.gist_trgm_ops (siglen='64'));
```


 



O objetivo dessa coluna é evitar ter que fazer nome like blabla "OR" apelido like blabla "OR" stack like blabla. Não precisamos mais de "OR". Basta fazer searchable like blabla e pronto. Se qualquer um desses campos conter o blabla, vai retornar. "OR" custa caro, sempre que puder evitar, evite, mesmo que signifique desperdiçar espaço. Pode ser um tradeoff que vale a pena. Pesquisa com porcento, wildcard, também custa caro. Agora vamos ver a função no projeto do Lucas pra pesquisa de termos. Fica mais pra baixo, a função "findByTerm".



```js
module.exports.findByTerm = async function findByTerm(term) {
    const query = `
    SELECT
        id,
        apelido,
        nome,
        to_char(nascimento, 'YYYY-MM-DD') as nascimento,
        stack
    FROM
        pessoas
    WHERE
        searchable ILIKE $1
    LIMIT 50;`
    return pool.query(query, [`%${term}%`]);
}
```



Olha só, definimos o template da query com um string. Select os campos id, apelido, etc, from tabela pessoas, where searchable like $1, limitado a 50 linhas de resposta. Esse "$1" vai ser substituído por esse valor aqui embaixo, que é o termo concatenado com porcentagem no começo e no fim. Ué, mas isso não era lento de pesquisar? Vamos entender.






Todo banco de dados relacional possui um comando pra explicar como que uma query vai ser executada, a estratégia de pesquisa. Pra ver isso, podemos conectar com o cliente de linha de comando do postgres, o psql. Então podemos nos conectar com "docker exec -it node-postgres-1 psql -U postgres -d postgres" e pronto.






Vale lembrar que estou conectando no postgres logo depois de rodar o teste de carga, portanto a tabela já está com mais de 46 mil linhas inseridas com sucesso. Vamos começar analisando uma query simples. Eu mando "explain analyze" seguido da query "select * from pessoas where apelido = 'foo'". Como esperado, essa coluna apelido já tem um índice, então ele corretamente diz que vai fazer um "index scan" no índice "pessoas_apelido_index". Pesquisa utilizando índice costuma ser muito rápido e podemos ver o Execution Time aqui no final dizendo que levou só 0.037 milissegundos, 37 microssegundos, super rápido.





Esses outros números aqui em cima, por exemplo em cost, ou custo, o primeiro é o custo relativo pra puxar a primeira linha do resultado, esse 0.41 e esse 8.43 é o custo relativo pra puxar o resto das linhas. Mesma coisa esse actual time, é o tempo pra puxar a primeira linha e depois o tempo pra puxar o resto das linhas. Uma das razões pra ele distinguir a primeira linha do resultado pro resto é pra dar noção da latência que sua aplicação vai ter entre mandar fazer a pesquisa e o primeiro resultado que volta no streaming e que já poderia ser mostrado.





Como esta query usa um índice e a quantidade de linhas é absurdamente pequeno, leva 16 microssegundos até puxar a primeira linha e pouco mais de 16 microssegundos pra puxar todo o resto. É muito rápido mesmo. Mas agora vamos ver quão mais lento seria a pesquisa por termos do jeito que a grande maioria dos programadores iniciantes faria. Olha só: `explain analyze select * from pessoas where apelido ilike '%foo%' or nome ilike '%foo%' or stack::text ilike '%foo%'`.





Olha o tempo que leva pra executar essa query: 42 milissegundos, ou 42 mil microssegundos. Comparado com a query simples anterior estamos falando de um tempo de resposta mais de mil vezes mais lento. Sim, 42 milissegundos ainda é relativamente rápido, mas considerando que eu falei que essa tabela é absurdamente pequena, e queries baseadas em índice conseguem acabar na ordem de microssegundos, 42 milissegundos é um tempo longo.






Olha só a estratégia que ele diz que essa query vai ser obrigada a usar: "seq scan" que é scan sequencial, literalmente um full table scan. Imagine um loop com for indo da linha 0 até a linha 46 mil e tanto e checando os campos linha a linha. É o pior caso pra uma pesquisa em banco, que é checar tudo, sem poder usar índices. Você quer evitar esse tipo de query como diabo foge da cruz, porque quanto maior ficar sua tabela, mais lento sua pesquisa vai ficar. Com índice não, você pode dobrar o tamanho da tabela e o tempo da query quase não muda. 






Será que tudo isso que fizemos de criar o campo searchable concatenando os campos nome, apelido e stack e depois indexando usando Gist com Trigrams faz alguma diferença? Não podemos só chutar e dizer que sim sem testar. Então vamos lá: explain analyze `select * from pessoas where searchable ilike '%foo%'` e olha só, é mais rápido sim.






Caímos de 42 milissegundos pra só 4 milissegundos. É pelo menos 10 vezes mais rápido. E olha a estratégia de pesquisa. Não tem mais um sequential scan como antes. Em vez disso tempos um Bitmap Heap Scan. Essa estratégia é dividida em duas e começa primeiro com um Bitmap Index Scan, que vai usar o índice que fizemos usando Gist com Trigram. Nessa fase teremos uma certa quantidade de linhas de resultado. Essas linhas vão ser marcadas num mapa de bits, um bitmap, e na segunda fase de pesquisa, ela vai filtrar só as linhas marcadas, usando essa condição de rechecagem que mostra na estratégia.






Ou seja, ainda tem uma fase de scan de linhas, mas não é na tabela inteira, só nas linhas retornadas na primeira etapa de pesquisa pelo índice. Neste caso, o índice sozinho não dá a resposta toda, por isso existe o Bitmap Heap Scan. É mais lento do que um Index Scan, como no primeiro exemplo que testamos, mas é bem mais rápido do que um full sequential scan.








Portanto sim, valeu a pena tudo isso de GIST. E é uma boa dica pra qualquer projeto. Em projetos maiores, onde estaríamos usando coisas como cache em Redis, também poderíamos delegar pesquisa full text pra outro serviço externo. Eu sempre recomendo o bom e velho ElasticSearch. O Elastic é como se fosse um banco de dados NoSQL especializado em full text search. Povo de monitoramento e devops também costuma integrar ElasticSearch com serviços como Kibana, Logstash, pra fazer pesquisa em logs, por exemplo.





Elastic é pra quando seu projeto crescer e recursos como GIST já não estarem segurando a carga de processamento no banco. Nunca faça overengineering nos primeiros dias de um projeto. Só especialize em serviços externos quando tiver carga pra justificar isso. Quanto mais serviços externos, mais difícil vai ser pra dar manutenção em tudo. É um trade-off. Tudo tem seu tempo, e não é no dia 1.






De qualquer forma, vocês começaram a entender? Uma operação simples SQL num Postgres sem tuning nenhum, rodando na minha máquina, é da ordem de microssegundos. Muito menos de 1 milissegundo. Bancos de dados foram feitos pra serem rápidos. Assistam meus episódios sobre Árvores e Banco de Dados. É muito mais do que só apendar uma linha nova no final de um arquivo.






Outra técnica que eu tinha deixado pra comentar neste episódio foi sobre o tal SQL Bulk Insert. Muitos dos projetos ganhadores com do Vinicius em Rust ou do André e Albert em C#, fizeram o truque de acumular os inserts ou numa fila externa ou em memória e um job em background ir pegando grupos de inserts e mandando de uma só vez pro banco. Mas realmente não tem muito o que comentar. O conceito é bem simples.






Em vez de toda requisição ter que conectar no banco, mandar um insert, esperar o resultado e daí responder, podemos fazer ele responder sem saber se vai gravar com sucesso ou não. E ir acumulando. Depois que acumular uma quantidade razoável, sei lá, uns 100 inserts, daí manda tudo de uma vez só, dentro de uma única transaction. Só de não ter que criar uma nova transação pra cada insert individual, fora mandar pela rede tudo de uma vez, economiza bastante tempo. Mas como já repeti mil vezes neste episódio, 100 mil tentativas de inserts simples é pouca carga. Acho que pra quase nenhuma dos projetos participantes, realmente precisava ter usado essa técnica, no máximo teria feito pouca diferença não usar.







Bulk insert e também upserts são técnicas importantes. Povo de data warehouse, business intellingence, data science e tudo mais que precisa limpar dados e carregar volumes grandes de uma só vez, sabe que precisa fazer bulk insert, senão desperdiça tempo. Cada banco de dados tem peculiaridades de sintaxe, por isso é melhor que vocês pesquisem no google "postgres bulk insert" ou "postgres batch insert" que os primeiros links explicam direitinho. Não vou ficar repetindo o que já tem fácil em tutoriais simples.






Mais importante é voltarmos pro docker compose e falar da configuração de postgres. Cada participante da rinha fez essa parte de maneiras ligeiramente diferentes, mas no geral todo mundo estava preocupado em mudar este parâmetro: max_connections. A maioria chutava nessa faixa de 450 conexões. Lembram que uma conexão custa uns 2 megabytes? Se realmente usarmos todas as 450 conexões máximas, o container de postgres poderia usar quase 900 megabytes. Isso é coisa demais, considerando que temos só 3 gigabytes pra caber tudo. Por isso não adianta querer subir esse número todo.







Tem algumas formas diferentes de mudar essa configuração. A mais simples é desse jeito mesmo: mudando a linha de comando do postgres e adicionando o parâmetro direto. Outra forma é que nem fizemos com o nginx e criar um arquivo postgres.conf pra mapear como volume pra dentro do container. E outra forma é como criamos a tabela e índices: direto na aplicação, quando ela se conectar pela primeira vez, manda comandos SQL, e um desses comandos seria pra mandar aumentar o máximo de conexões.





Mas a pergunta mais importante é: quantas conexões de fato precisa suportar pro tipo de carga que nosso teste de Gatling vai executar? 450 é mesmo suficiente? Ou menos daria? E se for menos, quanto menos? Se configurar o pool de conexões da aplicação pra deixar já aberto 450 conexões, estaria desperdiçando muita RAM. Se alocar poucas conexões, daí as primeiras requisições vão gastar mais tempo esperando abrir novas conexões. Tem um balanço aqui, e justamente testes de carga servem pra validar se nossas premissas realmente valem na prática.






Pra facilitar nossa vida, já vimos que dá pra conectar na linha de comando do cliente psql pra fazer queries direto no banco. Mas podemos adicionar algumas ferramentas mais visuais pra facilitar tanto sua vida, quanto minha vida aqui de mostrar. A que deixei pra mostrar por último é o pgAdmin, um velho de guerra que usamos faz mais de década, desde antes de Docker ter sido inventado. É muito simples, basta adicionar este serviço no seu docker compose: 


```
  pgadmin:
    image: dpage/pgadmin4
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: admin
      PGADMIN_LISTEN_PORT: 5050
    network_mode: host
    depends_on:
      - postgres
```


Email e senha tanto faz, é só porque vai subir uma interface web de administração. Importante é declarar essa porta 5050, porque senão ele vai tentar subir na porta 80, e como estamos em modo de rede host, vai tentar subir na porta 80 de verdade do localhost, e não vai ter permissão sem ser root, então vai falhar no boot. Mude pra uma porta acima de 1000 qualquer, como 5050.





Agora podemos subir "docker compose up" e esperamos alguns segundos. Vamos acelerar e pronto, no navegador do lado podemos carregar localhost 5050 e olha só que bonito. Só colocar o mesmo email e senha que configuramos e estamos dentro. Depois fucem essa interface e leiam a documentação no site deles pra saber o que é o quê. Mas já deixo um aviso importante: apesar de útil, nunca, jamais, deixe um serviço como esse exposto na internet pública. 





Seria uma tremenda burrice deixar isso desprotegido porque se alguém conseguir entrar, vai ter acesso ao seu banco de dados de produção. Nada de nenhum banco de dados de produção jamais pode aparecer na internet pública. É pedir pra ser invadido. Suba temporariamente em produção pra alguma tarefa em específico, mas retire do ar o quanto antes. Use em ambiente de staging, em ambiente de desenvolvimento, em rede privada da empresa, dentro de uma DMZ, mas nunca na internet pública. Sem mais, nem menos, vocês foram avisados.






Enfim, eu já tinha cadastrado o postgres que estávamos usando nos testes, mas deixa eu cadastrar de novo pra vocês verem como é. Dêem um nome qualquer, endereço é localhost, usuário é postgres, senha é a mesma que você configurou no docker compose e pronto, conectado. Mas e daí, o que podemos fazer com isso? Vamos no terminal do lado e rodar o teste de carga do Gatling de novo.






Aqui estou acelerando na edição, mas olhem só que bacana, conseguimos ver em tempo real o monitoramento de coisas como transações por segundo. Vou avançar mais pro meio do teste. Note como o total de transações está em azul mas temos, mais ou menos, meio a meio entre transações que deram commit ok e transações que deram rollback por ter falhado. Isso é simples de explicar.






Lembram que o teste de carga faz um total de umas 100 mil requisições, mas só 46 mil são de fato gravadas? Os outros dão erro porque campos como apelido, nome tem constraints pra serem unique, nunca duplicar. Quando tentamos inserir duplicado, rejeita e dá rollback. Por isso, mais ou menos, meio a meio. 





Embaixo podemos ver gráficos pra ter noção do volume de dados entrando e saindo. Cada conjunto de campos, a linha em si, é uma tupla. Temos tuplas entrando, que são os inserts, temos tuplas saindo, que são resultados de queries, temos gráfico de I/O que não tenho certeza da unidade de medida, se são operações de leitura e gravação ou quantidade de bytes ou algo assim.






Mais importante é este primeiro gráfico no topo. Acompanhe em azul, é o total de conexões no banco neste momento. Em verde são conexões onde estão acontecendo operações, como nossos inserts ou selects. Em vermelho são conexões abertas sem fazer nada. Veja como é mais ou menos estável a quantidade de conexões, mesmo sabendo que no teste de carga estamos aumentando gradativamente o número de usuários por segundo, subindo até 600 usuários por segundo.






E essa é a importância de um bom pool de conexões. A mesma conexão é reusada, reciclada, entre várias requisições. Por isso não precisa de tantas. Só bem no finalzinho, bem no final mesmo, quando caímos no território do 95th percentile, talvez 75th percentile, aquele 5 a 15% que demora mais de 1 segundo pra responder, aí aumenta drasticamente o número de conexões abertas ao mesmo tempo. Nesse finalzinho dá impressão que a requisição no Node está tão lenta que não dá tempo de devolver a conexão pro pool, daí precisa ficar abrindo mais e mais conexões.







Essas últimas requisições que demoram mais de 5 segundos, são completamente fora da realidade. Se num produto real estivéssemos tendo tempos nessa ordem de grandeza com frequência, ou precisava ver se falta otimizar alguma coisa, ou precisa urgentemente aumentar os recursos da infra. Não devemos configurar o máximo de conexões no banco, nem o tamanho do pool de conexões baseados nesse pico final. 





Ao contrário do que muitos poderiam imaginar, durante quase o teste de carga todo, nunca passou de 40 conexões, ativas ao mesmo tempo, era faixa de 20 conexões. Não é 450, nem 300, nem mesmo 100. Só mesmo no finalzinho, mas aí já era repescagem. Portanto, se alguém chutava que máximo de conexões ao banco seria um gargalo, chutou errado também.





E porque são menos de 40 ao mesmo tempo? Se voltarmos ao docker compose, na configuração da aplicação, veja na seção de variáveis de ambiente. Tem esse DB_POOL que passamos pro pool da biblioteca "pg" usada pelo Node. Neste caso está 35. No caso temos duas instâncias, então seria um máximo de 70. Mesmo assim, durante a maior parte do teste, nenhum dos dois pool nunca é saturado. Só no final. Aí meio que não importa muito se tivéssemos colocar mais ou não. O pico final a infra não aguenta mesmo.





E qual é o melhor número pra colocar no pool de conexões? Cada blog post e stackoverflow que procurar vai vir com alguma fórmula mágica pra tentar chutar. Mas não tem jeito, pra saber de verdade, só fazendo um teste de carga, monitorando via pgAdmin e, via tentativa e erro, rodar o teste de carga pra diferentes valores de tamanho de pool. Esse é o único jeito certo de saber se estamos chutando um número apertado demais ou sobrando demais. Não acredite em nada a não ser testes que você mesmo rodou pra saber.





Isso tudo dito, muitos de vocês assistindo que tem experiência, incluindo vários dos participantes, e eu mesmo, tínhamos certeza que o Postgres seria um problema. Mas agora que medimos e temos dados de verdade, temos certeza que estávamos errados. As técnicas em si funcionam, mas a aplicação e a carga do teste eram muito menores do que imaginávamos. Superestimamos o problema e fizemos overengineering. Típico de programadores fazer overengineering. A lição é simples: faça o código mais simples que resolve o problema dado, faça medições e, só depois disso, decida onde realmente precisa otimizar, e vá medindo pra ver se a otimização realmente melhorou, ou se não piorou.







E isso nos leva aos tópicos finais que faltou discutir da minha lista de pendências. Eu falei que ia comentar sobre Crystal, sobre Kotlin, daí sobre threads e fibers. Mas quero ser breve nesses pontos. Durante o video de 16 linguagens eu quis mostrar que sim, com praticamente todas as linguagens, era possível bater o máximo do teste de carga. Alguns com um pouco mais de trabalho que outros, mas todo mundo era capaz de passar ou chegar muito perto.






Significa que todas as linguagens são igualmente válidas? Ou igualmente performáticas? Claro que não. Vamos usar o bom senso aqui. Obviamente, todas as linguagens compiladas em binário nativo levam vantagem em performance, Rust e Go, principalmente, seguido de C++, Java e seus derivados como Kotlin ou Scala, C#, Crystal, Zig, até Bun. Essa é uma categoria clara de performance nível A.





Linguagens interpretadas, como PHP, Javascript e seus derivados como Typescript, Ruby, Python, todos fazem parte da mesma categoria B de performance. Não é possível atingir o mesmo nível de performance bruta da categoria A. É sim, possível escalar aplicações web pra números parecidos, ao custo de um pouco mais de hardware. Isso porque boa parte de uma aplicação web depende I/O, e I/O vai ser mais lento independente se a aplicação é compilada ou interpretada.




Portanto sim, a infra pra linguagens da categoria B precisa ser um pouco maior do que da categoria A. Mas não é ordens de grandeza maior, esse é o ponto. Do outro lado da equação está a facilidade ou em encontrar bons profissionais ou treinar novos profissionais, e é aí que linguagens da categoria B ultrapassam muito os da categoria A.





Pergunte a qualquer entusiasta de Rust e ele vai dizer que eu estou equivocado, que Rust é muito fácil, que ele aprendeu super fácil. Mas sinto dizer: eu acredito em você, mas seu perfil é diferente da maioria da população. As pessoas não são iguais. Quem acha ficar fluente em Rust algo "fácil" é uma fração minúscula da população. A grande maioria não tem nem a vontade e nem a capacidade pra ficar fluente em linguagens de baixo nível, que exigem um entendimento muito mais detalhado de como tudo por baixo funciona, a rede, o sistema operacional, o hardware.





E isso não é algo inerente só a Rust. Nos anos 80 e 90 nós sempre tivemos, Assembly, C, C++, Objective-C. Mas quais foram as linguagens que ficaram populares? Nos anos 80 eram coisas como Cobol ou dBase. Nos anos 90 eram coisas como Visual Basic ou Delphi. Delphi até era compilado nativo, mas o que atraiu as pessoas era o ferramental, a IDE, o banco de dados Interbase que vinha no pacote. Ninguém usava Delphi pra programar drivers de sistema operacional ou coisas assim.





Agora é a mesma coisa. Tem uma categoria de pessoas que desde sempre achava fácil programar em C, C++, até Assembly, e agora Rust, Go. Pra realmente tirar proveito desse tipo de linguagem, você precisa ser o tipo de pessoa que gosta de aprender intimamente como funciona o hardware por baixo, o sistema operacional inteiro por baixo. Pra categoria B, uma pessoa que não está nem aí e nem sabe a diferença entre memória RAM e SSD, ainda consegue produzir alguma coisa. A curva de aprendizado é nitidamente menor e por isso tem mais gente nessas linguagens da categoria B.





Duh, antes que apareça comentário idiota: óbvio que tem programadores avançados na categoria B também. Mas alguém medíocre, não sobrevive na categoria A. Portanto, é sim possível fazer uma web startup inteira só com Rust ou Go, mas boa sorte em manter uma equipe de dezenas ou centenas de pessoas que escala junto com o crescimento da empresa. Em breve não vai acompanhar. Por isso toda grande empresa de tecnologia usa um misto de tecnologias. Não existe empresa gigante que consegue usar uma única linguagem pra tudo.  





E isso sem contar o ecossistema. Produtividade não vem só da linguagem. Vem das bibliotecas, produtos, serviços, documentação, cursos, livros, eventos e tudo mais que circula ao redor da linguagem. É muito mais difícil comparar uma linguagem e dizer só "ah, é compilado" ou "ah, é interpretado". Essa é a parte que menos importa na comparação.





Tem uma questão cultural também. Deixa eu dar um exemplo bem besta. Todo mundo que é de Javascript está acostumado a ir no terminal e digitar algo como "npx create-react-app my-app". Quem é de Ruby on Rails está acostumado a ir no terminal e digitar "rails new my-app". Quem é de Python está acostumado a fazer "django-admin startproject my-app" e assim por diante.





Como que alguém de Java inicia um novo projeto? Vai no site start.spring.io, preenche um fucking formulário, que vai gerar o projeto e te dar um zip pra baixar. Daí você manualmente deszipa e esse é o começo do seu projeto. Quase em 2024, pra mim isso tem cheiro de 2004. Outras linguagens como C# tem opções de linha de comando com dotnetcore, mas como a maioria dessa comunidade prefere realmente fazer? Sim, abrir o Visual Studio Enterprise e clicar em Novo Projeto e ir preenchendo. 





Pra gente de Javascript, Ruby, Python, PHP, isso parece super ultrapassado. Mas pra quem é de Java ou C#, parece uma super frescura ter uma linha de comando pra gerar as coisas se o site ou a IDE já fazem tudo. E é aquele caso que depende do ponto de vista. Nenhum dos dois lados nunca vai concordar nisso. Mas é esse tipo de discordância em ponto de vista que vai garantir que nunca tenhamos uma única linguagem e um único ecossistema que vai ser o padrão pra tudo. Eu detesto ter que usar uma IDE. Do que ter que usar IntelliJ ou Visual Studio, eu prefiro mudar pra qualquer linguagem que eu possa ser produtivo só da linha de comando, usando NeoVim. Não é negociável pra mim.






Eu já fiz um video só explicando as diferenças entre linguagens compiladas e interpretadas e explico mais a fundo sobre essas coisas, recomendo que assistam depois. Mas sobre Crystal e Kotlin em particular que eu analisei na rinha. Ambos são linguagens mais novas, com comunidade pequena. No caso de Kotlin, ele já foi criado por uma empresa grande, a JetBrains e depois apoiado pelo próprio Google. E mesmo assim a adoção não é tão grande quanto eu gostaria de ver a esta altura.





De novo, quem está acostumado só com Java não vê grande valor em migrar pra Kotlin. No final o bytecode é compatível, pra que mudar? Pra nós que estamos acostumados com linguagens mais modernas, o Kotlin é uma excelente opção pra quando formos obrigados a fazer alguma coisa na plataforma Java. Vale a pena ficar de olho e ter no seu arsenal. Mas sempre vai haver essa divisão. Eu sinto que Kotlin é mais atraente pra quem não é de Java, do que pra quem já é experiente em Java.




Crystal é muito menor e bem mais de nicho. Mesmo assim eu acho uma linguagem super competente, estável, com um ecossistema mínimo já funcional. Eu acho a sintaxe de Ruby muito superior à de um Go Lang. Me cancelem, mas é verdade. Porém, obviamente Ruby é uma categoria de performance muito inferior a Go. Mas Crystal é realmente a sintaxe de Ruby com performance de Go, mesma ordem de grandeza. Sim, Go ainda é melhor otimizado e por ser uma linguagem mais primitiva, também é mais rápido de compilar.





Mas pra coisas como microsserviços web, eu acho Crystal e frameworks como o Lucky, bem mais prazerosos de usar do que similares em Go ou Rust. Se produtividade for importante e evitar fadiga também, Crystal pode ser uma boa alternativa, especialmente pra equipes pequenas. A curva de aprendizado é menor. Vale ter no arsenal. E eu reforço isso depois de ter experimentado linguagens como Nim, que existe há muito mais anos, mas continua péssimo de usar, super mal documentado, com poucas bibliotecas usáveis e muitos bugs. Parece uma linguagem experimental, que eu não recomendaria pra usar em produção de jeito nenhum.






Dá pra ficar o dia todo só falando das diversas linguagens, e eu já comentei bastante sobre elas no episódio original da rinha, então assistam lá depois. Mas voltando ao assunto de conexões no banco, só queria deixar um comentário sobre a diferença de linguagens compiladas como Rust e interpretadas como Javascript. Ou mais especificamente, linguagens que tem capacidade de escalar com threads nativas e linguagens que não podem por causa de lock global de interpretador, que todas as linguagens da categoria B tem.





Eu explico isso no episódio de linguagens compiladas e interpretadas. Mas na nossa situação de uso com banco de dados costuma significar o seguinte: além de serem mais performáticos pelo fato de serem compilados, linguagens como Rust ou mesmo Java, tem a vantagem de precisar de menos conexões simultâneas. Um pool de conexões de Java é thread-safe, ou seja, pode ser utilizado por múltiplas threads nativas em paralelo.





Numa linguagem como Javascript ou Ruby, ou qualquer interpretada, cada thread nativa precisa ter seu próprio pool de conexões. Em resumo é mais ou menos assim: em Java poderíamos configurar o pool de conexões pra ter um máximo de 100 conexões, e é isso que a aplicação vai ter no total: 100 conexões.





Já num Javascript, depende. Se rodar com um processo só, vai subir só um pool de conexões, se colocar o máximo de 100, é isso que vai ter: até 100 também. O reactor do Node.js é single threaded. Toda chamada assíncrona roda numa mesma thread nativa e vai acessar um único pool de conexões. 




No caso de Node.js em modo cluster, ele pode subir múltiplos forks de processos de Node. Cada um com um pool de conexões separado. Então se for subir 5 forks no cluster, devemos configurar o pool pra ter no máximo 20 conexões, se eu quiser manter o mesmo máximo. 5 vezes 20 é o máximo de 100, entenderam? Por isso não dá pra subir forks infinitos no cluster, porque cada fork vai tendo menos e menos conexões que pode usar no pool. 





Estou pulando vários detalhes. Em cada linguagem vai ter alguma peculiaridade na implementação de threads, co-rotinas, pools. Você precisa entender como I/O não bloqueante funciona e como sua linguagem favorita lida com isso. Fica de lição de casa, caso ainda não tenham estudado sobre isso. A dica é começar assistindo meu antigo episódio sobre concorrência e paralelismo pra entender essa base.






Mas o ponto foi só pra vocês saberem que existem diferenças grandes em como se configura coisas como pool de conexões em Java e em Node.js, por exemplo. A configuração de coisas como pool de conexões vai ser diferente. A melhor forma de aprender a diferença é monitorando com um pgAdmin da vida e criando cenários de teste de carga com Gatling ou Vegeta da vida, pra ver na prática quais números funcionam e quais não funcionam. 





Quando se é júnior, você faz tudo às cegas, no achismo, achando que vai dar tudo certo. Mas à medida que ganha experiência e vai ficando mais sênior, começa a entender que chutômetro é o caminho mais rápido pra software ruim. Sempre parece que o software faz coisas que você não previa. Pra ganhar controle sobre isso, só tem um caminho: aprendendo sobre benchmarks, profiling, carga, monitoramento, medição, estatística e finalmente começar a enxergar e interpretar corretamente o comportamento do software de acordo com diferentes níveis de carga e estresse.






E com isso, acho que consegui cobrir todos os tópicos que tinha deixado pendente. Não queria fechar o ano com pendências. Com isso posso finalmente dar por encerrado esse assunto de rinha. Vamos começar o ano com temas novos. Em Janeiro de 2024 eu vou tirar férias e passar três semanas no Japão, então acho que não vai ter video em Janeiro. Ainda não sei se volto a publicar antes ou depois do Carnaval, então pode ser ser que eu só volte entre Fevereiro e Março. Aproveitem pra maratonar o canal. Devo ficar postando sobre a viagem no Instagram, então me sigam lá. Se ficaram com dúvidas, mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal, e não deixem de compartilhar o video com seus amigos. A gente se vê em 2024, Feliz Natal e Bom Ano Novo! Até mais!
