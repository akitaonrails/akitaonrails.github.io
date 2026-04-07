---
title: "Minhas Notas sobre Deploy Produção do Ruby on Rails no Google Cloud Kubernetes Engine"
date: '2018-01-09T20:13:00-02:00'
slug: minhas-notas-deploy-producao-ruby-on-rails-google-cloud-kubernetes
tags:
- googlecloud
- kubernetes
- rubyonrails
- linux
- nginx
- traduzido
translationKey: rails-kubernetes-gke
aliases:
- /2018/01/09/my-notes-about-a-production-grade-ruby-on-rails-deployment-on-google-cloud-kubernetes-engine/
draft: false
---

Estou usando o Google Cloud com Kubernetes Engine há dois meses e pouco, do zero à produção. Na prática, não levei um mês para montar tudo, mas levei mais um mês para descobrir algumas arestas bem chatas.

TL;DR: O Google está fazendo um trabalho razoavelmente bom como contrapeso para a AWS não se acomodar. Se você já sabe tudo sobre AWS, eu te encorajo a testar o Google Cloud. Provavelmente por memória muscular, eu ainda me sentisse mais confortável com a AWS, mas agora que me forcei a passar pelo processo de aprendizado, estou bastante confiante com Google Cloud e Kubernetes para a maioria dos meus cenários.

Aviso completo: não sou especialista, então leve o que digo com um grão de sal. É um daqueles assuntos que tenho muita vontade de falar, mas também sou muito cuidadoso com a escolha das palavras para você não ter uma ideia errada sobre as soluções propostas.

O objetivo desse exercício é principalmente guardar alguns trechos e pensamentos para consulta futura. Então tenha em mente que isso também não é um tutorial passo a passo. Minha primeira intenção foi ir por esse caminho, mas aí percebi que seria quase como escrever um livro inteiro, então não dessa vez.

Para ter sucesso com algo como Google Cloud e Kubernetes, você **precisa** ter experiência em infraestrutura. Se você nunca instalou boxes Linux de nível servidor do zero, se nunca fez otimizações de servidor, se não está confortável com componentes bare-metal do lado do servidor, não tente um deploy real em produção. Sua aposta mais segura ainda é algo como o Heroku.

Você tem que ser o tipo de pessoa que gosta de fuçar nas coisas (como provavelmente você já me leu fazendo em [posts anteriores](http://www.akitaonrails.com/linux) do blog).

Não sei tudo, mas sei o suficiente. Então só precisei descobrir quais peças se encaixariam melhor nas minhas necessidades. Você **precisa** definir suas necessidades antes de tentar escrever seu primeiro arquivo YAML. Planejamento é crucial.

Antes de tudo, isso é o que eu queria/precisava:

* Camada de aplicação web escalável, onde eu pudesse fazer tanto rolling updates (para atualizações com **zero downtime**) quanto escalamento horizontal automático e manual dos servidores.
* Storage persistente montável **com** snapshots/backups automáticos.
* Banco de dados robusto gerenciado (Postgresql) com backups automáticos e **replicação fácil** para instâncias somente leitura.
* Solução gerenciada para armazenar secrets (como o suporte a ENV do Heroku). Nunca armazene configuração de produção no código-fonte.
* Suporte a imagens Docker sem precisar construir infraestrutura customizada para deploy.
* Endereços IP externos estáticos para integrações que exigiam IP fixo.
* Terminação SSL para poder conectar ao CloudFlare (CDN é obrigatório, mas não suficiente — em 2018 precisamos de algum nível de proteção contra DDoS).
* Segurança suficiente por padrão, para que tudo fique — em teoria — bloqueado a menos que eu decida abrir.
* Alta disponibilidade em diferentes regiões e zonas de data center.

É fácil fazer deploy de uma aplicação web demo simples. Mas eu não queria uma demo, queria uma solução de nível produção para o longo prazo. Melhorias na minha implementação são muito bem-vindas, então fique à vontade para comentar abaixo.

Alguns dos problemas para quem está começando:

* A documentação é _muito_ extensa, e você vai encontrar _quase_ tudo — se souber o que está procurando. Também tenha em mente que Azure e AWS também implementam Kubernetes com algumas diferenças, então parte da documentação não se aplica ao Google Cloud e vice-versa.
* Existem muitos recursos em estágios alpha, beta e stable. A documentação acompanha bem, mas a maioria dos tutoriais com alguns meses pode não funcionar mais como esperado (esse aqui incluído — estou assumindo Kubernetes 1.8.4-gke).
* Existe um conjunto de palavras que se aplicam a conceitos que você já conhece mas têm nomes diferentes. Se acostumar com o vocabulário pode atrapalhar no começo.
* Parece que você está brincando com Lego. Muitas peças que você pode misturar e combinar. É fácil de bagunçar. Isso significa que você pode construir uma configuração adaptada às suas necessidades. Mas se você só copiar e colar de tutoriais, você **vai** ficar preso.
* Você pode fazer _quase_ tudo através de arquivos YAML e linha de comando, mas não é trivial reutilizar a configuração (para ambientes de produção e staging, por exemplo). Existem ferramentas de terceiros que lidam com bits YAML parametrizáveis e reutilizáveis, mas eu faria tudo à mão primeiro. Nunca, jamais, tente templates automatizados em infraestrutura sem saber exatamente o que eles fazem.
* Você tem 2 ferramentas de linha de comando _pesadas_: `gcloud` e `kubectl`, e a parte confusa é que elas nomeiam algumas coisas de forma diferente mesmo sendo as mesmas "coisas". Pelo menos, `kubectl` é próximo do `docker`, se você estiver familiarizado com ele.

Mais uma vez, isso **NÃO** é um tutorial passo a passo. Vou anotar alguns passos mas não tudo.

### Camada Web Escalável (a própria aplicação web)

A primeira coisa que você precisa ter é uma aplicação web totalmente compatível com os 12 fatores.

Seja Ruby on Rails, Django, Laravel, Node.js ou o que for. Deve ser uma aplicação totalmente shared-nothing, que não depende de escrever nada no sistema de arquivos local. Uma que você possa facilmente desligar e iniciar instâncias independentemente. Sem sessão no estilo antigo em memória local ou em arquivos locais (prefiro evitar session affinity). Sem uploads para o sistema de arquivos local (se for necessário, você terá que montar um storage persistente externo) — sempre prefira enviar streams binários para serviços de storage gerenciados.

Você precisa ter um [pipeline adequado que produza cache-busting através de fingerprinting de assets](https://tomanistor.com/blog/cache-bust-that-asset/) (e gostando ou não, o Rails ainda tem a melhor solução out-of-the-box no seu Asset Pipeline). Você não quer se preocupar com invalidar caches em CDNs manualmente.

Instrumente sua aplicação, adicione o [New Relic RPM](https://rpm.newrelic.com), adicione o [Rollbar](https://rollbar.com).

De novo, isso é 2018 — você não quer fazer deploy de código ingênuo com injeção de SQL (ou qualquer outro tipo de input), sem `eval` sem verificação no seu código, sem brecha para CSRF ou XSS, etc. Vá em frente, compre a licença do [Brakeman Pro](https://brakemanpro.com/) e adicione ao seu pipeline de CI. Posso esperar...

Como isso não é um tutorial, vou assumir que você é mais do que capaz de se cadastrar no Google Cloud e encontrar seu caminho para configurar um projeto, configurar sua região e zona.

Demorei um pouco para entender a estrutura inicial no Google Cloud:

* Você começa com um [Projeto](https://cloud.google.com/resource-manager/docs/creating-managing-projects), que é o guarda-chuva para tudo que sua aplicação precisa.
* Em seguida você cria ["clusters"](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture). Você pode ter um cluster de produção ou staging, por exemplo. Ou um cluster web e um cluster de serviços separado para coisas não-web, e assim por diante.
* Um cluster tem um ["cluster-master"](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture#master), que é o controlador de tudo o mais (os comandos `gcloud` e `kubectl` falam com suas APIs).
* Um cluster tem muitas ["node instances"](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture#nodes), as "máquinas" propriamente ditas (ou, mais precisamente, instâncias de VM).
* Cada cluster também tem pelo menos um ["node pool"](https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools) (o "default-pool"), que é um conjunto de node instances com a mesma configuração, o mesmo ["machine-type"](https://cloud.google.com/compute/docs/machine-types).
* Por fim, cada node instance executa um ou mais "pods" que são containers leves como LXC. É aqui que sua aplicação realmente vive.

Este é um exemplo de [criação de cluster](https://cloud.google.com/sdk/gcloud/reference/container/clusters/create):

```
gcloud container clusters create my-web-production \
--enable-cloud-logging \
--enable-cloud-monitoring \
--machine-type n1-standard-4 \
--enable-autoupgrade \
--enable-autoscaling --max-nodes=5 --min-nodes=2 \
--num-nodes 2
```

Como mencionei, ele também cria um `default-pool` com um [machine-type](https://cloud.google.com/compute/docs/machine-types) de `n1-standard-4`. Escolha qual combinação de CPU/RAM você vai precisar para sua aplicação específica com antecedência. O tipo que escolhi tem 4 vCPUs e 15GB de RAM.

Por padrão ele começa com 3 nodes, então escolhi 2 inicialmente mas com auto-scaling até 5 (você pode atualizar isso depois se precisar, mas garanta que tem espaço para crescimento inicial). E você pode continuar adicionando node-pools extras para node instances de tamanhos diferentes — digamos, para workers do Sidekiq fazerem processamento pesado em background. Então você deve criar um Node Pool separado com um machine-type diferente para seu conjunto de node instances, por exemplo:

```
gcloud container node-pools create large-pool \
--cluster=my-web-production \
--node-labels=pool=large \
--machine-type=n1-highcpu-8 \
--num-nodes 1
```

Esse outro pool controla 1 node do tipo `n1-highcpu-8` que tem 8 vCPUs com 7,2 GB de RAM. Mais CPUs, menos memória. Existe uma categoria `highmem` que tem menos CPUs com muito mais memória. De novo, saiba o que você quer com antecedência.

A parte importante aqui é o `--node-labels` — é assim que vou mapear o deployment para escolher entre Node Pools (neste caso, entre o `default-pool` e o `large-pool`).

Após criar um cluster, você precisa executar o seguinte comando para buscar suas credenciais:

```
gcloud container clusters get-credentials my-web-production
```

Isso configura o comando `kubectl` também. Se você tiver mais de um cluster (digamos, um `my-web-production` e `my-web-staging`), precisa ter muito cuidado de sempre fazer `get-credentials` para o cluster correto primeiro, caso contrário pode acabar executando um deploy de staging no cluster de produção.

Como isso é confuso, modifiquei meu ZSH PROMPT para sempre mostrar com qual cluster estou lidando. Adaptei do [zsh-kubectl-prompt](https://github.com/superbrothers/zsh-kubectl-prompt):

![zsh kubectl prompt](https://github.com/superbrothers/zsh-kubectl-prompt/raw/master/images/screenshot001.png)

Como você acabará tendo múltiplos clusters em uma aplicação grande, recomendo fortemente adicionar esse PROMPT ao seu shell.

Agora, como você faz deploy da sua aplicação nos pods dentro dessas node instances?

Você precisa ter um `Dockerfile` no repositório do seu projeto de aplicação para gerar uma imagem Docker. Este é um exemplo para uma aplicação Ruby on Rails:

```
FROM ruby:2.4.3
ENV RAILS_ENV production
ENV SECRET_KEY_BASE xpto
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs postgresql-client cron htop vim
ADD Gemfile* /app/
WORKDIR /app
RUN gem update bundler --pre
RUN bundle install --without development test
RUN npm install
ADD . /app
RUN cp config/database.yml.prod.example config/database.yml && cp config/application.yml.example config/application.yml
RUN RAILS_GROUPS=assets bundle exec rake assets:precompile
```

No Google Cloud Web Console, você encontrará um ["Container Registry"](https://cloud.google.com/container-registry/), que é um Registry Docker Privado.

Você precisa adicionar a URL remota à sua configuração local assim:

```
git remote add gcloud https://source.developers.google.com/p/my-project/r/my-app
```

Agora você pode fazer `git push gcloud master`. Recomendo também adicionar [triggers](https://cloud.google.com/container-builder/docs/running-builds/automate-builds) para taggear suas imagens. Adiciono 2 triggers: um para taggeá-la com `latest` e outro para taggeá-la com um número de versão aleatório. Você vai precisar deles mais tarde.

Depois de adicionar o repositório do registry como um remote na sua configuração git (`git remote add`) e fazer push nele, ele deve começar a construir sua imagem Docker com as tags adequadas que você configurou com os triggers.

Certifique-se de que sua aplicação Ruby on Rails não tem nada nos initializers que exija uma conexão com o banco de dados, pois ele não está disponível. Isso é algo com que você pode travar quando seu build Docker falha por causa da tarefa `assets:precompile` que carregou um initializer que acidentalmente chama um Model — e isso dispara o `ActiveRecord::Base` tentando se conectar.

Além disso, certifique-se de que a versão do Ruby no `Dockerfile` corresponde à do `Gemfile`, caso contrário também vai falhar.

Reparou no estranho `config/application.yml` acima? Esse é do [figaro](https://github.com/laserlemon/figaro). Também recomendo usar algo para facilitar a configuração de variáveis ENV no seu sistema. Não gosto dos secrets do Rails, e ele não é exatamente amigável para a maioria dos sistemas de deploy depois que o Heroku popularizou as ENV vars. Fique com ENV vars. O Kubernetes também vai agradecer por isso.

Agora, você pode sobrescrever qualquer variável ENV do arquivo YAML de Deployment do Kubernetes. Agora é uma boa hora para mostrar um exemplo disso. Você pode nomeá-lo `deploy/web.yml` ou como preferir e — claro — comitá-lo no seu repositório de código-fonte.

```yaml
kind: Deployment
apiVersion: apps/v1beta1
metadata:
  name: web
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 10
  replicas: 2
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - image: gcr.io/my-project/my-app:latest
          name: my-app
          imagePullPolicy: Always
          ports:
          - containerPort: 4001
          command: ["passenger", "start", "-p", "4001", "-e", "production",
          "--max-pool-size", "2", "--min-instances", "2", "--no-friendly-error-pages"
          "--max-request-queue-time", "10", "--max-request-time", "10",
          "--pool-idle-time", "0", "--memory-limit", "300"]
          env:
            - name: "RAILS_LOG_TO_STDOUT"
              value: "true"
            - name: "RAILS_ENV"
              value: "production"
            # ... obviamente reduzi as muitas ENV vars por brevidade
            - name: "REDIS_URL"
              valueFrom:
                secretKeyRef:
                  name: my-env
                  key: REDIS_URL
            - name: "SMTP_USERNAME"
              valueFrom:
                secretKeyRef:
                  name: my-env
                  key: SMTP_USERNAME
            - name: "SMTP_PASSWORD"
              valueFrom:
                secretKeyRef:
                  name: my-env
                  key: SMTP_PASSWORD
            # ... esta parte abaixo é obrigatória para Cloud SQL
            - name: DB_HOST
              value: 127.0.0.1
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: cloudsql-db-credentials
                  key: password
            - name: DB_USER
              valueFrom:
                secretKeyRef:
                  name: cloudsql-db-credentials
                  key: username

        - image: gcr.io/cloudsql-docker/gce-proxy:latest
          name: cloudsql-proxy
          command: ["/cloud_sql_proxy", "--dir=/cloudsql",
                    "-instances=my-project:us-west1:my-db=tcp:5432",
                    "-credential_file=/secrets/cloudsql/credentials.json"]
          volumeMounts:
            - name: cloudsql-instance-credentials
              mountPath: /secrets/cloudsql
              readOnly: true
            - name: ssl-certs
              mountPath: /etc/ssl/certs
            - name: cloudsql
              mountPath: /cloudsql
      volumes:
        - name: cloudsql-instance-credentials
          secret:
            secretName: cloudsql-instance-credentials
        - name: ssl-certs
          hostPath:
            path: /etc/ssl/certs
        - name: cloudsql
          emptyDir:
```

Tem muita coisa acontecendo aqui. Então deixa eu quebrar um pouco:

* O `kind` e o `apiVersion` são importantes — você precisa ficar de olho na documentação se eles mudarem. Isso é o que chamamos de [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/). Antigamente existia um Replication Controller (você encontrará em tutoriais antigos), mas não está mais em uso. A recomendação é usar um [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/).
* Nomeie as coisas corretamente — aqui você tem `metadata:name` com `web`. Preste muita atenção também ao `spec:template:metadata:labels` onde estou rotulando cada pod com um label de `app: web`, você vai precisar disso para poder selecionar esses pods mais tarde na seção Service abaixo.
* Em seguida tenho o `spec:strategy` onde configuramos o Rolling Update, então se você tem 10 pods, ele vai terminar um, inicializar o novo e continuar fazendo isso, sem nunca derrubar tudo de uma vez.
* `spec:replicas` declara quantos Pods quero de uma vez. Você terá que calcular manualmente o machine-type do node-pool e então dividir quantos CPUs/RAM totais você tem pelo quanto precisa para cada instância de aplicação.
* Lembra da imagem Docker que geramos acima com a tag 'latest'? Você a referencia em `spec:template:spec:containers:image`
* Estou usando o Passenger com configuração de produção (confira a [documentação do Phusion](https://www.phusionpassenger.com/library/config/reference/), não copie isso só assim).
* Na seção `spec:template:spec:containers:env` posso sobrescrever as ENV vars com os secrets reais de produção. E você vai notar que posso hard-codar valores ou usar essa estranha construção:

```yaml
- name: "SMTP_USERNAME"
  valueFrom:
    secretKeyRef:
      name: my-env
      key: SMTP_USERNAME
```

Aqui está referenciando um armazenamento de ["Secret"](https://kubernetes.io/docs/concepts/configuration/secret/) que nomeei "my-env". E é assim que você cria o seu:

```
kubectl create secret generic my-env \
--from-literal=REDIS_URL=redis://foo.com:18821 \
--from-literal=SMTP_USERNAME=foobar
```

Leia a documentação pois você pode carregar arquivos de texto em vez de declarar tudo pela linha de comando.

Como disse antes, prefiro usar um serviço gerenciado para o banco de dados. Você pode definitivamente carregar sua própria imagem Docker, mas realmente não recomendo. O mesmo vale para outros serviços similares a banco de dados como Redis, Mongo. Se você vem da AWS, o [Google Cloud SQL](https://cloud.google.com/sql/docs/postgres/) é como o RDS.

Após criar sua instância PostgreSQL você não consegue acessá-la diretamente da aplicação web. No final, você tem um boilerplate para uma segunda imagem Docker, um ["CloudSQL Proxy"](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine).

Para isso funcionar você precisa primeiro criar uma Service Account:

```
gcloud sql users create proxyuser host --instance=my-db --password=abcd1234
```

Após criar a instância PostgreSQL ela vai pedir para você baixar uma credencial JSON, então tenha cuidado e salve-a em algum lugar seguro. Não preciso dizer que você também deve gerar uma senha forte e segura. Em seguida precisa criar secrets extras:

```
kubectl create secret generic cloudsql-instance-credentials \
--from-file=credentials.json=/home/myself/downloads/my-db-12345.json

kubectl create secret generic cloudsql-db-credentials \
--from-literal=username=proxyuser --from-literal=password=abcd1234
```

Esses são referenciados nesta parte do Deployment:

```yaml
- image: gcr.io/cloudsql-docker/gce-proxy:latest
  name: cloudsql-proxy
  command: ["/cloud_sql_proxy", "--dir=/cloudsql",
            "-instances=my-project:us-west1:my-db=tcp:5432",
            "-credential_file=/secrets/cloudsql/credentials.json"]
  volumeMounts:
    - name: cloudsql-instance-credentials
      mountPath: /secrets/cloudsql
      readOnly: true
    - name: ssl-certs
      mountPath: /etc/ssl/certs
    - name: cloudsql
      mountPath: /cloudsql
volumes:
- name: cloudsql-instance-credentials
  secret:
    secretName: cloudsql-instance-credentials
- name: ssl-certs
  hostPath:
    path: /etc/ssl/certs
- name: cloudsql
  emptyDir:
```

Veja que você precisa adicionar o nome do banco de dados ("my-db" neste exemplo) na cláusula `-instance` no comando.

A propósito, o `gce-proxy:latest` se referia à versão 1.09 na época em que esse post foi publicado. Mas já havia uma versão 1.11. Essa me deu dores de cabeça, derrubando conexões e adicionando um timeout super longo. Então voltei para a 1.09 (latest) e tudo funcionou como esperado. Fique atento! Nem tudo que é novinho é bom. Em infraestrutura, você quer ficar com o que é estável.

Você também pode querer a opção de carregar uma instância CloudSQL separada em vez de tê-la em cada pod, para que os pods pudessem se conectar a apenas um proxy. Pode ser interessante ler [essa thread](https://github.com/GoogleCloudPlatform/cloudsql-proxy/issues/49) sobre o assunto.

Parece que nada é exposto a nada a menos que você diga explicitamente. Então precisamos expor esses pods através do que chamamos de [Node Port Service](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport). Vamos criar um arquivo `deploy/web-svc.yaml` também:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  sessionAffinity: None
  ports:
  - port: 80
    targetPort: 4001
    protocol: TCP
  type: NodePort
  selector:
    app: web
```

É por isso que destaquei a importância do `spec:template:metadata:labels`, para que possamos usá-lo aqui no `spec:selector` para selecionar os pods corretos.

Agora podemos fazer deploy desses 2 assim:

```
kubectl create -f deploy/web.yml
kubectl create -f deploy/web-svc.yml
```

E você pode ver os pods sendo criados com `kubectl get pods --watch`.

## O Load Balancer

Muitos tutoriais vão expor esses pods diretamente através de um Service diferente, chamado [Load Balancer](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/). Não tenho tanta certeza sobre como isso se comporta sob pressão e se tem terminação SSL, etc. Então decidi ir com tudo com um [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) Load Balancer usando o [NGINX Controller](https://www.nginx.com/products/nginx/kubernetes-ingress-controller/).

Primeiro de tudo, decidi criar um node-pool separado para ele, por exemplo, assim:

```
gcloud container node-pools create web-load-balancer \
--cluster=my-web-production \
--node-labels=role=load-balancer \
--machine-type=g1-small \
--num-nodes 1 \
--max-nodes 3 --min-nodes=1 \
--enable-autoscaling 
```

Assim como quando criamos o exemplo de `large-pool`, aqui você precisa cuidar de adicionar `--node-labels` para que o controller seja instalado aqui em vez do `default-pool`. Você vai precisar saber o nome da node instance, podemos fazer isso assim:

```
$ gcloud compute instances list
NAME                                             ZONE        MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP      STATUS
gke-my-web-production-default-pool-123-123       us-west1-a  n1-standard-4               10.128.0.1   123.123.123.12   RUNNING
gke-my-web-production-large-pool-123-123         us-west1-a  n1-highcpu-8                10.128.0.2   50.50.50.50      RUNNING
gke-my-web-production-web-load-balancer-123-123  us-west1-a  g1-small                    10.128.0.3   70.70.70.70      RUNNING
```

Vamos salvar assim por enquanto:

```
export LB_INSTANCE_NAME=gke-my-web-production-web-load-balancer-123-123
```

Você pode reservar manualmente um IP externo e dar um nome a ele assim:

```
gcloud compute addresses create ip-web-production \
        --ip-version=IPV4 \
        --global
```

Para fins de exemplo, digamos que ele gerou um IP reservado "111.111.111.111". Então vamos buscá-lo e salvá-lo por enquanto assim:

```
export LB_ADDRESS_IP=$(gcloud compute addresses list | grep "ip-web-production" | awk '{print $3}')
```

Por fim, vamos vincular esse endereço à node instance do load balancer:

```
export LB_INSTANCE_NAT=$(gcloud compute instances describe $LB_INSTANCE_NAME | grep -A3 networkInterfaces: | tail -n1 | awk -F': ' '{print $2}')
gcloud compute instances delete-access-config $LB_INSTANCE_NAME \
    --access-config-name "$LB_INSTANCE_NAT"
gcloud compute instances add-access-config $LB_INSTANCE_NAME \
    --access-config-name "$LB_INSTANCE_NAT" --address $LB_ADDRESS_IP
```

Feito isso, podemos adicionar o resto da configuração de Deployment do Ingress. Vai ser um pouco longo, mas é basicamente boilerplate. Vamos começar definindo outra aplicação web que chamaremos de `default-http-backend`, usada para responder a requisições HTTP caso nossos pods web não estejam disponíveis por algum motivo. Vamos chamá-la de `deploy/default-web.yml`:

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: default-http-backend
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: default-http-backend
    spec:
      terminationGracePeriodSeconds: 60
      containers:
      - name: default-http-backend
        # Any image is permissable as long as:
        # 1. It serves a 404 page at /
        # 2. It serves 200 on a /healthz endpoint
        image: gcr.io/google_containers/defaultbackend:1.0
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 30
          timeoutSeconds: 5
        ports:
        - containerPort: 8080
        resources:
          limits:
            cpu: 10m
            memory: 20Mi
          requests:
            cpu: 10m
            memory: 20Mi
```

Não precisa mudar nada aqui — e a essa altura você já deve estar familiarizado com o template de Deployment. Você já sabe que precisa expô-lo através de um NodePort, então vamos adicionar um `deploy/default-web-svc.yml`:

```yaml
kind: Service
apiVersion: v1
metadata:
  name: default-http-backend
spec:
  selector:
    app: default-http-backend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: NodePort
```

De novo, não precisa mudar nada. Os próximos 3 arquivos são as partes importantes. Primeiro, criaremos um NGINX Load Balancer — vamos chamá-lo de `deploy/nginx.yml`:

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-ingress-controller
spec:
  replicas: 1
  template:
    metadata:
      labels:
        k8s-app: nginx-ingress-lb
    spec:
      # hostNetwork makes it possible to use ipv6 and to preserve the source IP correctly regardless of docker configuration
      # however, it is not a hard dependency of the nginx-ingress-controller itself and it may cause issues if port 10254 already is taken on the host
      # that said, since hostPort is broken on CNI (https://github.com/kubernetes/kubernetes/issues/31307) we have to use hostNetwork where CNI is used
      hostNetwork: true
      terminationGracePeriodSeconds: 60
      nodeSelector:
        role: load-balancer
      containers:
        - args:
            - /nginx-ingress-controller
            - "--default-backend-service=$(POD_NAMESPACE)/default-http-backend"
            - "--default-ssl-certificate=$(POD_NAMESPACE)/cloudflare-secret"
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          image: "gcr.io/google_containers/nginx-ingress-controller:0.9.0-beta.5"
          imagePullPolicy: Always
          livenessProbe:
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
            initialDelaySeconds: 10
            timeoutSeconds: 5
          name: nginx-ingress-controller
          ports:
            - containerPort: 80
              name: http
              protocol: TCP
            - containerPort: 443
              name: https
              protocol: TCP
          volumeMounts:
            - mountPath: /etc/nginx-ssl/dhparam
              name: tls-dhparam-vol
      volumes:
        - name: tls-dhparam-vol
          secret:
            secretName: tls-dhparam
```

Preste atenção ao `nodeSelector` para usar o node label que adicionamos ao criar o novo node-pool.

Você pode querer mexer nos labels, no número de réplicas se precisar. Mas aqui você vai notar que ele monta um volume que nomeei como `tls-dhparam-vol`. Esses são os [Parâmetros Efêmeros Diffie Hellman](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html#Forward_Secrecy_&_Diffie_Hellman_Ephemeral_Parameters). É assim que geramos:

```
sudo openssl dhparam -out ~/documents/dhparam.pem 2048

kubectl create secret generic tls-dhparam --from-file=/home/myself/documents/dhparam.pem

kubectl create secret generic tls-dhparam --from-file=/home/myself/documents/dhparam.pem
```

Note também que estou usando a versão "0.9.0-beta_5" para a imagem do controller. Funciona bem, sem problemas até agora. Mas fique de olho nas release notes para versões mais novas e faça seus próprios testes.

De novo, vamos expor esse controller Ingress através do Load Balancer Service. Vamos chamá-lo de `deploy/nginx-svc.yml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
spec:
  type: LoadBalancer
  loadBalancerIP: 111.111.111.111
  ports:
  - name: http
    port: 80
    targetPort: http
  - name: https
    port: 443
    targetPort: https
  selector:
    k8s-app: nginx-ingress-lb
```

Lembra do IP externo estático que reservamos acima e salvamos na ENV var `LB_INGRESS_IP`? Esse é o que precisa colocar na seção `spec:loadBalancerIP`. Esse também é o IP que você vai adicionar como "registro A" no seu serviço DNS (digamos, mapeando seu "www.my-app.com.br" no CloudFlare).

Por fim, podemos criar a configuração do Ingress em si — vamos criar um `deploy/ingress.yml` assim:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.org/ssl-services: "web-svc"
    kubernetes.io/ingress.global-static-ip-name: ip-web-production
    ingress.kubernetes.io/ssl-redirect: "true"
    ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
    - hosts:
      - www.my-app.com.br
      secretName: cloudflare-secret
  rules:
    - host: www.my-app.com.br
      http:
        paths:
        - path: /
          backend:
            serviceName: web-svc
            servicePort: 80
```

Cuidado com as annotations acima que conectam tudo. Ele vincula o serviço NodePort que criamos para os pods web com o nginx ingress controller e adiciona terminação SSL através daquele `spec:tls:secretName`. Como você cria isso? Primeiro precisa comprar um certificado SSL — usando o CloudFlare como exemplo novamente.

Quando terminar a compra, o provedor deve te dar os arquivos secretos para download (guarde-os em segurança! uma pasta pública do Dropbox não é segura!). Então precisa adicioná-los à infraestrutura assim:

```
kubectl create secret tls cloudflare-secret \
--key ~/downloads/private.pem \
--cert ~/downloads/fullchain.pem
```

Agora que editamos um monte de arquivos, podemos fazer deploy de todo o stack do load balancer:

```
kubectl create -f deploy/default-web.yml
kubectl create -f deploy/default-web-svc.yml
kubectl create -f deploy/nginx.yml
kubectl create -f deploy/nginx-svc.yml
kubectl create -f deploy/ingress.yml
```

Essa configuração do NGINX Ingress é baseada no [post do blog do Zihao Zhang](https://zihao.me/post/cheap-out-google-container-engine-load-balancer/). Existem também exemplos no [repositório kubernetes incubator](https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/nginx-ingress.md). Vale a pena conferir também.

Se você fez tudo certo até aqui, `https://www.my-app-com.br` deve carregar sua aplicação web. Pode ser interessante verificar o Time to First-Byte (TTFB). Você pode fazer isso passando pelo CloudFlare assim:

```
curl -vso /dev/null -w "Connect: %{time_connect} \n TTFB: %{time_starttransfer} \n Total time: %{time_total} \n" https://www.my-app.com.br
```

Ou, se estiver com TTFB lento, pode contornar o CloudFlare fazendo isso:

```
curl --resolve www.my-app.com.br:443:111.111.111.111 https://www.my-app.com.br -svo /dev/null -k -w "Connect: %{time_connect} \n TTFB: %{time_starttransfer} \n Total time: %{time_total} \n"
```

O TTFB deve ficar em torno de 1 segundo ou menos. Qualquer coisa muito acima disso pode indicar um problema na sua aplicação. Verifique os machine types da sua node instance, o número de workers carregados por pod, a versão do CloudSQL proxy, a versão do NGINX controller e assim por diante. Isso é um processo de tentativa e erro, pelo que sei. Cadastre-se em serviços como [Loader](https://loader.io) ou mesmo [Web Page Test](https://www.webpagetest.org) para ter insights.

## Rolling Updates

Agora, com tudo funcionando, como realizamos o Rolling Update que mencionei no início? Primeiro você faz `git push` para o repositório do Container Registry e aguarda a construção da imagem Docker.

Lembra que disse para deixar um trigger tagear a imagem com um número de versão aleatório? Vamos usá-lo (você pode ver isso na lista de Build History no Container Registry, no console do Google Cloud):

```
kubectl set image deployment web my-app=gcr.io/my-project/my-app:1238471234g123f534f543541gf5 --record
```

Você deve usar o mesmo nome e imagem declarados no `deploy/web.yml` acima. Isso vai começar a fazer rollout da atualização adicionando um novo pod, então encerrando um pod e assim por diante, sem downtime para seus usuários.

Rolling updates precisam ser executados com cuidado. Por exemplo, se seu novo deploy exige uma migração de banco de dados, você precisa adicionar uma janela de manutenção (ou seja: faça isso quando houver pouco ou nenhum tráfego, como de madrugada). Então você pode executar o comando migrate assim:

```
kubectl get pods # para obter o nome de um pod

kubectl exec -it my-web-12324-121312 /app/bin/rails db:migrate

# você também pode entrar em bash em um pod assim, mas lembre que este é um container efêmero, então arquivos que você editar e escrever ali desaparecem no próximo restart:

kubectl exec -it my-web-12324-121312 bash
```

Para fazer redeploy de tudo sem recorrer ao rolling update, você precisa fazer isso:

```
kubectl delete -f deploy/web.yml && kubectl apply -f deploy/web.yml
```

Você encontrará uma explicação mais completa no [blog do Ta-Ching](https://tachingchen.com/blog/Kubernetes-Rolling-Update-with-Deployment/).

## Bônus: Auto Snapshots

Um item que tinha na minha lista de "queria/precisava" no início é a capacidade de ter storage persistente montável com backups/snapshots automáticos. O Google Cloud fornece metade disso por enquanto. Você pode criar discos persistentes para montar nos seus pods, mas não tem um recurso para fazer backup automático dele. Pelo menos tem APIs para criar snapshots manualmente.

Para este exemplo, vamos criar um novo disco SSD e formatá-lo primeiro:

```
gcloud compute disks create --size 500GB my-data --type pd-ssd

gcloud compute instances list
```

O último comando é para copiarmos o nome de uma node instance. Digamos que seja `gke-my-web-app-default-pool-123-123`. Vamos anexar o disco `my-data` a ela:

```
gcloud compute instances attach-disk gke-my-web-app-default-pool-123-123 --disk my-data --device-name my-data

gcloud compute ssh gke-my-web-app-default-pool-123-123
```

O último comando faz SSH na instância. Podemos listar os discos anexados com `sudo lsblk` e você verá o disco de 500GB, provavelmente como `/dev/sdb`, mas certifique-se de que está correto porque vamos formatá-lo!

```
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
```

Agora podemos sair da sessão SSH e desanexar o disco:

```
gcloud compute instances detach-disk gke-my-web-app-default-pool-123-123 --disk my-data
```

Você pode montar esse disco nos seus pods adicionando o seguinte ao seu yaml de deployment:

```
spec:
  containers:
    - image: ...
      name: my-app
      volumeMounts:
        - name: my-data
          mountPath: /data
          # readOnly: true
   # ...
   volumes:
     - name: my-data
       gcePersistentDisk:
         pdName: my-data
         fsType: ext4
```

Agora, vamos criar um arquivo de deployment CronJob como `deploy/auto-snapshot.yml`:

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: auto-snapshot
spec:
  schedule: "0 4 * * *"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: auto-snapshot
            image: grugnog/google-cloud-auto-snapshot
            command: ["/opt/entrypoint.sh"]
            env:
            - name: "GOOGLE_CLOUD_PROJECT"
              value: "my-project"
            - name: "GOOGLE_APPLICATION_CREDENTIALS"
              value: "/credential/credential.json"
            volumeMounts:
              - mountPath: /credential
                name: editor-credential
          volumes:
            - name: editor-credential
              secret:
                secretName: editor-credential
```

Como já fizemos antes, você precisará criar outra Service Account com permissões de editor na seção "IAM & admin" do console do Google Cloud, depois baixar a credencial JSON e, por fim, fazer upload dela assim:

```
kubectl create secret generic editor-credential \
--from-file=credential.json=/home/myself/download/my-project-1212121.json
```

Note também que, como um cron job normal, existe um parâmetro de schedule que você pode querer alterar. No exemplo, "0 4 * * *" significa que o snapshot vai rodar todo dia às 4h da manhã.

Confira o [repositório original](https://github.com/grugnog/google-cloud-auto-snapshot) dessa solução para mais detalhes.


E por agora é isso!

Como disse no início, este não é um procedimento completo, apenas destaques de algumas das partes importantes. Se você é novo no Kubernetes, acabou de ler sobre Deployment, Service, Ingress, mas ainda tem ReplicaSet, DaemonSet e muito mais para explorar.

Acho que já está longo demais para adicionar uma explicação de configuração de [Alta Disponibilidade multi-região](https://cloud.google.com/sql/docs/mysql/high-availability), então vamos deixar por aqui.

Correções ou sugestões são muito bem-vindas, pois ainda estou no processo de aprendizado, e tem um monte de coisas que eu mesmo ainda não sei.
