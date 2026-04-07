---
title: "Migrando para o GitLab! Sim, vale a pena!"
date: '2016-08-03T14:49:00-03:00'
slug: migrando-para-o-gitlab-sim-vale-a-pena
translationKey: moving-to-gitlab
aliases:
- /2016/08/03/moving-to-gitlab-yes-it-s-worth-it/
tags:
- gitlab
- git
- self-hosted
- segurança
- traduzido
draft: false
---

Eu [comecei a evangelizar Git em 2007](http://www.akitaonrails.com/2007/9/22/jogar-pedra-em-gato-morto-por-que-subversion-no-presta). Foi uma venda dificílima de fazer naquela época.

Fora do desenvolvimento do kernel quase ninguém queria aprender e tínhamos concorrentes bem dignos, de Subversion, Mercurial, Bazaar, Darcs, Perforce, e por aí vai. Mas quem cavou mais fundo sabia que o Git tinha a vantagem e era só uma questão de tempo.

Aí o GitHub apareceu em 2008 e o resto é história. Por muitos anos era só "bacana" estar no GitHub. A comunidade Ruby impulsionou o GitHub lá pra cima. No fim virou o status quo e o único monopólio real em repositórios de informação, não só código-fonte, mas tudo.

Sempre soube que deveríamos ter uma opção "local", que é por isso que [tentei contribuir com o Gitorious](https://gitorious.org/gitorious/oboxodo-gitorious?p=gitorious:oboxodo-gitorious.git;a=search;h=9f6bdf5887c65a440bc3fdc43a14652f42ddf103;s=Fabio+Akita;st=committer) lá em 2009. Outras opções apareceram, mas eventualmente o GitLab surgiu por volta de 2011 e pegou tração nos últimos dois anos.

O próprio GitHub levantou [USD 350 milhões em financiamento](https://www.crunchbase.com/organization/github#/entity) e uma das metas obrigatórias é arrasar na Enterprise Edition para grandes corporações que não querem seus dados fora dos jardins fechados. Embora o GitHub hospede cada projeto open source que existe, eles próprios são closed-source.

A [GitLab Inc.](http://gitlab.com) começou diferente, com uma abordagem open source-first com a Community Edition (CE) e tendo tanto uma opção hospedada estilo GitHub quanto uma Enterprise Edition suportada para as corporações temerosas. Já levantaram [USD 5.62 milhões em financiamento](https://www.crunchbase.com/organization/gitlab-com#/entity), e são a alternativa mais promissora ao GitHub até agora.

Claro, existem outras plataformas como o Bitbucket da Atlassian. Mas acredito que a estratégia da Atlassian é mais lenta e eles têm uma suíte maior de produtos enterprise pra vender primeiro, como o Confluence e o Jira. Acho que eles nunca chegaram a representar muita competição contra o GitHub.

O GitLab realmente começou a acelerar em 2015 como mostra este [gráfico de commits](https://github.com/gitlabhq/gitlabhq/graphs/contributors?from=2015-03-14&to=2016-08-02&type=c):

![contributions](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/545/big_Contributors_to_gitlabhq_gitlabhq.png)

Vem crescendo de forma constante desde 2011, mas parece que cruzaram o primeiro ponto de virada lá por final de 2014, saindo dos early adopters pra early majority. Isso ficou mais importante quando o GitHub [anunciou as mudanças de preço](https://github.com/blog/2164-introducing-unlimited-private-repositories) em maio.

Disseram que não se comprometeram com um prazo pra forçar a mudança, então as organizações podem optar por ficar fora do novo formato por enquanto. Eles estão mudando de "repositórios limitados e usuários ilimitados" pra "repositórios ilimitados e usuários limitados".

## O Dilema do Custo-Benefício

Por exemplo, se você tem até 8 desenvolvedores no plano de USD 50/mês (20 repositórios privados), a mudança não vai te afetar, já que você vai pagar USD 25/mês por 5 usuários e USD 9 por usuários adicionais (total de USD 52/mês).

Agora, se você tem uma equipe grande de 100 desenvolvedores atualmente no Diamond Plan de USD 450/mês (300 repositórios privados), teria que pagar USD 25/mês + 95 vezes USD 9, o que totaliza impressionantes USD 880/mês! **O dobro do valor!**

Isso são **USD 10.560 a mais por ano**!

E o que o GitLab te oferece em troca?

Você pode ter muito mais usuários e mais repositórios numa máquina virtual de **USD 40/mês** (4GB de RAM, 60GB SSD, 4TB de transferência).

E não para por aí. O GitLab também tem o funcionalíssimo [GitLab Multi Runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner) que você pode instalar numa máquina separada (na verdade, pelo menos 3 máquinas, mais sobre isso abaixo).

Você pode facilmente conectar esse runner ao sistema de build pelo GitLab de modo que cada novo git push dispara o runner pra rodar a suíte de testes automatizados numa imagem Docker à sua escolha. Então é um sistema de Integração Contínua completo e totalmente funcional integrado na interface do projeto GitLab:

![Pipeline](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/546/big_Pipelines___cm42-archived___PremiosOnline___GitLab.png)

![CI Runner](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/547/big_test___144____Builds___cm42-archived___PremiosOnline___GitLab.png)

Lembra de alguma coisa? Sim, é uma alternativa totalmente funcional ao Travis-CI, Semaphore, CircleCI ou qualquer outro CI que você esteja usando com um procedimento de instalação bem fácil. Digamos que você está pagando USD 489/mês ao Travis-CI pra ter 10 jobs concorrentes.

Você pode instalar o GitLab Runner em 3 máquinas de USD 10/mês (1GB RAM, 1 Core, 30GB SSD) e ter muito mais jobs concorrentes (20? 50? Auto-Scale!?) que rodam **mais rápido** (num teste simples, um build que demorou 15 minutos no Travis demorou menos de 8 minutos no Digital Ocean).

Então vamos fazer a conta pra um ano de serviço. Primeiro considerando nenhuma mudança no plano do GitHub:

> USD 5.400 (GitHub) + USD 5.868 (Travis) = USD 11.268 por ano.

Agora, GitLab + GitLab Runner + Digital Ocean pelas mesmas features e usuários ilimitados, repositórios ilimitados, builds concorrentes ilimitados:

> USD 480 (GitLab) + USD 840 (máquina do Runner) = USD 1.320 por ano.

Isso já é quase 8,5x mais barato com quase nenhuma mudança de qualidade.

No pior cenário, compare quando o GitHub decidir forçar os novos planos:

> USD 10.560 (novos planos GitHub) + USD 5.868 (Travis) = USD 16.428

Agora a opção GitLab é 11x mais barata! Você economiza quase USD 15.000 por ano! Isso é algo que você não pode ignorar na sua planilha de custos.

Como eu disse, os cálculos acima só são significativos num cenário de 100 desenvolvedores. Você tem que fazer sua própria conta considerando o tamanho do seu time e número de projetos ativos (você sempre pode arquivar projetos que não estão sendo usados).

Mesmo que você não tenha 100 desenvolvedores. Vamos considerar o cenário pra **30 desenvolvedores** nos novos planos por usuário do GitHub e uma configuração menor de Travis pra 5 jobs concorrentes:

> USD 3.000 (novo plano GitHub) + USD 3.000 (Travis) = USD 6.000

É 4,5x mais barato na opção suite Digital Ocean + GitLab.

Olha, vamos considerar o plano **Atual** do GitHub (o Platinum, pra até 125 repositórios):

> USD 2.400 (plano atual GitHub) + USD 3.000 (Travis) = USD 5.400

Ainda é pelo menos **4x mais caro** que uma solução baseada em GitLab!

E quanto tempo leva pra um único desenvolvedor descobrir o setup e migrar tudo do GitHub pra nova instalação do GitLab? Vou dizer que você pode reservar 1 semana de trabalho pra um programador mediano fazer isso seguindo a documentação oficial e minhas dicas e truques abaixo.

## Instalando o GitLab CE

Não vou te encher com o que você encontra facilmente pela Web. Recomendo fortemente que você comece com a solução mais fácil primeiro: [One-Click Automatic Install do Digital Ocean](https://www.digitalocean.com/features/one-click-apps/gitlab/). Instale numa máquina com pelo menos 4GB de RAM (você vai querer mantê-la se gostar).

Claro, existem várias opções diferentes de instalação, de imagens AMI da AWS a pacotes Ubuntu que você pode instalar manualmente. Estude a [documentação](https://about.gitlab.com/installation/).

Vai te custar USD 40 por um mês de teste. Se você quiser economizar dezenas de milhares de dólares, isso é uma pechincha.

O GitLab tem muitas opções de customização. Você pode trancar seu GitLab privado pra permitir só usuários com e-mail oficial do seu domínio, por exemplo. Você pode configurar [provedores OAuth2](http://docs.gitlab.com/ee/integration/omniauth.html) pros seus usuários entrarem rapidamente usando contas do GitHub, Facebook, Google ou outras.

#### Alguns Detalhes

Tropecei em alguns caveats na configuração. É por isso que recomendo planejar com antecedência, estude este artigo inteiro antes! Faça uma instalação rápida que você pode jogar fora, pra você "sentir" o ambiente antes de tentar migrar todos os seus repositórios pro seu GitLab novinho. Como referência, esta é uma parte do meu `/etc/gitlab/gitlab.rb`:

```ruby
# registre um domínio pro seu servidor e coloque aqui:
external_url "http://my-gitlab-server.com/"

# você vai querer habilitar [LFS](https://git-lfs.github.com)
gitlab_rails['lfs_enabled'] = true

# registre seus emails
gitlab_rails['gitlab_email_from'] = "no-reply@my-gitlab-server.com"
gitlab_rails['gitlab_support_email'] = "contact@my-gitlab-server.com"

# adicione sua configuração de email (template pra gmail)
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.gmail.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "-- algum email no-reply ---"
gitlab_rails['smtp_password'] = "-- a senha ---"
gitlab_rails['smtp_domain'] = "my-gitlab-server.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_openssl_verify_mode'] = 'peer'

# aqui é onde você habilita a integração oauth2
gitlab_rails['omniauth_enabled'] = true

# CUIDADO!
# Isso permite usuários logarem sem ter uma conta de usuário primeiro. Defina os providers permitidos
# usando um array, ex. ["saml", "twitter"], ou como true/false pra permitir todos os providers ou nenhum.
# Contas de usuário serão criadas automaticamente quando a autenticação for bem-sucedida.
gitlab_rails['omniauth_allow_single_sign_on'] = ['github', 'google_oauth2', 'bitbucket']
gitlab_rails['omniauth_block_auto_created_users'] = true

gitlab_rails['omniauth_providers'] = [
  {
    "name" => "github",
    "app_id" => "-- github app id --",
    "app_secret" => "-- github secret --",
    "url" => "https://github.com/",
    "args" => { "scope" => "user:email" }
  },
  {
    "name" => "google_oauth2",
    "app_id" => "-- google app id --",
    "app_secret" => "-- google secret --",
    "args" => { "access_type" => "offline", "approval_prompt" => '', hd => 'codeminer42.com' }
  },
  {
    "name" => "bitbucket",
    "app_id" => "-- bitbucket app id --",
    "app_secret" => "-- bitbucket secret id --",
    "url" => "https://bitbucket.org/"
  }
]

# se você está importando repos do GitHub, os workers do Sidekiq podem crescer até 2.5GB de RAM e a config padrão do [Sidekiq Killer](http://docs.gitlab.com/ee/operations/sidekiq_memory_killer.html) vai limitar em 1GB, então você vai querer ou desabilitar adicionando '0' ou adicionar um limite maior
gitlab_rails['env'] = { 'SIDEKIQ_MEMORY_KILLER_MAX_RSS' => '3000000' }
```

Existem [dezenas de variáveis padrão](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/files/gitlab-cookbooks/gitlab/attributes/default.rb#L57) que você pode [sobrescrever](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/settings/environment-variables.md), só tome cuidado nos seus testes.

Toda vez que você muda uma configuração, basta rodar os seguintes comandos:

```
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
```

Você pode abrir um console Rails pra inspecionar objetos de produção assim:

```
gitlab-rails console
```

Tive muita dor de cabeça importando repos grandes do GitHub, mas depois de alguns dias debugando o problema com os desenvolvedores do GitLab Core Team [Douglas Alexandre](https://gitlab.com/u/dbalexandre), [Gabriel Mazetto](https://gitlab.com/u/brodock), alguns Merge Requests e algum patching local finalmente consegui importar projetos relativamente grandes (mais de 5.000 commits, mais de 1.000 issues, mais de 1.200 pull requests com várias discussões de comentários). Um projeto desse tamanho pode levar algumas horas pra completar, principalmente porque **é lento demais usar as APIs públicas do GitHub** (são lentas e têm rate limits e detecção de abuso, então você não consegue baixar tudo tão rápido quanto sua banda permitiria).

(A propósito, não perca o GitLab na [Rubyconf Brasil 2016](http://www.rubyconf.com.br/pt-BR/speakers#Gabriel%20Gonçalves%20Nunes%20Mazetto), nos dias 23 e 24 de setembro)

Migrar todos os meus projetos do GitHub levou alguns dias, mas todos passaram sem problemas e meu time não teve nenhuma dificuldade, só ajustar os git remote URLs e pronto.

O procedimento de importação do GitHub é bem completo, traz não só o repositório git em si, mas também todos os metadados, de labels a comentários e histórico de pull request, que é justamente o que normalmente leva mais tempo.

Mas eu recomendaria esperar pelo menos a versão 8.11 (atualmente está na 8.10.3) antes de tentar importar projetos grandes do GitHub.

Se você está no Bitbucket, infelizmente tem menos features no importador. Ele vai trazer principalmente só o código-fonte. Então fique atento se você depende bastante do sistema de pull request deles e quer preservar esse histórico. Mais features virão e você até pode ajudá-los, eles são bem desenvoltos e dispostos a melhorar o GitLab.

### Desvio: Customizações pra cada máquina Digital Ocean

Assuma que você deve rodar o que está nesta seção pra todas as novas máquinas que você criar no Digital Ocean.

Primeiro, elas vêm sem arquivo de swap. Não importa quanta RAM você tem, o Linux foi feito pra funcionar melhor combinado com um arquivo de swap. Você pode [ler mais sobre isso](https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04) depois, por enquanto só rode o seguinte como root:

```
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

sysctl vm.swappiness=10
sysctl vm.vfs_cache_pressure=50
```

Edite o arquivo `/etc/fstab` e adicione esta linha:

```
/swapfile   none    swap    sw    0   0
```

Finalmente, edite o arquivo `/etc/sysctl.conf` e adicione estas linhas:

```
vm.swappiness=10
vm.vfs_cache_pressure = 50
```

Não esqueça de configurar o [locale padrão](http://askubuntu.com/questions/162391/how-do-i-fix-my-locale-issue) da sua máquina. Comece editando o arquivo `/etc/environment` e adicionando:

```
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
```

Então rode:

```
sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure locales
```

Finalmente, você deveria ter o Ubuntu instalando patches de segurança estáveis automaticamente pra você. Você não quer esquecer máquinas online sem as correções de segurança mais atuais, então só rode isto:

```
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

Escolha "yes" e pronto. E claro, pra toda instalação nova, é sempre bom rodar o velho e bom:

```
sudo apt-get update && sudo apt-get upgrade
```

Isso é o básico do básico, acho que é mais fácil ter uma imagem com tudo isso pronto, mas se você usa as imagens padrão do Digital Ocean, estas configurações devem dar conta por enquanto.

## Instalando o CI Runner

Assim que você terminar sua instalação do GitLab, é [super fácil](https://about.gitlab.com/2016/04/19/how-to-set-up-gitlab-runner-on-digitalocean/) subir o GitLab Runner. Você pode usar a mesma máquina, mas recomendo instalar numa máquina separada.

Se você não sabe o que é um runner, imagina assim: basicamente é um servidor conectado à instalação do GitLab. Quando está disponível e online, sempre que alguém dá push num novo commit, merge request, num repositório que tem um arquivo `gitlab-ci-yml` presente, o GitLab vai empurrar um comando pro runner.

Dependendo de como você configurou o runner, ele vai receber esse comando e criar um novo container Docker. Dentro do container ele vai executar o que você definiu no arquivo `gitlab-ci.yml` do projeto. Normalmente é buscar arquivos em cache (dependências, por exemplo) e rodar sua suíte de testes.

No setup mais básico, você só vai ter um Runner e quaisquer builds subsequentes de outros usuários vão esperar na fila até terminarem. Se você já usou serviços externos de CI como Travis-CI ou CircleCI, sabe que eles cobram por um certo número de builds concorrentes. E é **muito caro**.

Quanto menos builds concorrentes disponíveis, mais seus usuários vão ter que esperar por feedback nas mudanças deles, e menos produtivos vocês ficam. As pessoas podem até começar a evitar adicionar novos testes, ou ignorar completamente os testes, o que vai machucar muito a qualidade do seu projeto com o tempo. Se tem uma coisa que você **não pode** deixar de fazer é ter boas suítes de testes automatizados.

O Gabriel Mazetto me apontou pra uma feature muito importante do GitLab CI Runner: [**auto-scaling**](https://about.gitlab.com/2016/03/29/gitlab-runner-1-1-released/). É isso que eles usam na oferta hospedada deles lá no GitLab.com.

Você pode **facilmente** configurar um runner que pode usar "docker-machine" e as APIs do seu provedor IaaS pra subir máquinas na hora pra rodar quantos builds concorrentes você quiser, e vai ser super barato!

Por exemplo, no Digital Ocean você pode ser cobrado USD 0,06 (6 centavos) por hora de uso numa máquina de 4GB. Na AWS EC2 você pode ser cobrado USD 0,041 por hora numa máquina m3.medium.

Tem documentação extensiva mas vou tentar resumir o que você tem que fazer. Pra mais detalhes recomendo fortemente que você estude a [documentação oficial](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/install/autoscaling.md#prepare-the-docker-registry-and-cache-server).

Comece criando 3 novas máquinas no Digital Ocean, todas na mesma Região com rede privada habilitada! Vou listar um endereço IP privado fake só pra avançar nos exemplos de configuração:

* uma máquina de 1GB chamada "docker-registry-mirror", (ex 10.0.0.1)
* uma máquina de 1GB chamada "ci-cache", (ex 10.0.0.2)
* uma máquina de 1GB chamada "ci-runner", (ex 10.0.0.3)

Sim, podem ser pequenas já que muito pouco vai rodar nelas. Você pode ser conservador e escolher as de 2GB RAM só pra ficar no seguro (e o preço ainda vai ser super barato).

Não esqueça de executar a configuração básica que mencionei acima pra habilitar swapfile, auto security update e regeneração de locale.

Faça SSH na "docker-registry-mirror" e rode:

```
docker run -d -p 6000:5000 \
    -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
    --restart always \
    --name registry registry:2
```

Agora você vai ter um registry proxy e cache local de imagens Docker em `10.0.0.1:6000` (anote o IP privado real).

Faça SSH na "ci-cache" e rode:

```
mkdir -p /export/runner

docker run -it --restart always -p 9005:9000 \
        -v /.minio:/root/.minio -v /export:/export \
        --name minio \
        minio/minio:latest /export
```

Agora você vai ter um clone do AWS S3 chamado [Minio](https://github.com/minio/minio) rodando. Eu nem sabia que esse projeto existia, mas é um serviçozinho legal escrito em Go pra clonar o comportamento e APIs do AWS S3. Então agora você pode ter seu próprio S3 dentro da sua infraestrutura!

Depois que o Docker sobe, ele vai imprimir a Access Key e Secret key, anote. E este serviço vai estar rodando em `10.0.0.2:9005`.

Você até pode abrir um browser e ver a interface web em `http://10.0.0.2:9005` e usar as access e secret keys pra logar. Certifique-se de ter um bucket chamado "runner". Os arquivos serão armazenados no diretório `/export/runner`.

![Minio Dashboard](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/549/big_Minio_Browser.png)

Certifique-se de que o [nome do bucket é válido](http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html) (tem que ser um nome DNS válido, por exemplo, NÃO use underlines).

Abra esta URL do seu GitLab-CE recém instalado: `http://yourgitlab.com/admin/runners` e anote o Registration Token. Digamos que seja `1aaaa_Z1AbB2CdefGhij`

![Admin Area for Runner Registration Token](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/550/big_Admin_Area___GitLab.png)

Finalmente, faça SSH na "ci-runner" e rode:

```
curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine

chmod +x /usr/local/bin/docker-machine

curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | sudo bash

sudo apt-get install gitlab-ci-multi-runner

rm -Rf ~/.docker # só pra garantir
```

Agora você pode registrar este novo runner com sua instalação do GitLab, você vai precisar do Registration Token mencionado acima.

```
sudo gitlab-ci-multi-runner register
```

Você vai ser perguntado algumas coisas, e isto é o que você pode responder:

```
Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/ci )
https://yourgitlab.com/ci
Please enter the gitlab-ci token for this runner
1aaaa_Z1AbB2CdefGhij # como no exemplo acima
Please enter the gitlab-ci description for this runner
my-autoscale-runner
INFO[0034] fcf5c619 Registering runner... succeeded
Please enter the executor: shell, docker, docker-ssh, docker+machine, docker-ssh+machine, ssh?
docker+machine
Please enter the Docker image (eg. ruby:2.1):
codeminer42/ci-ruby:2.3
INFO[0037] Runner registered successfully. Feel free to start it, but if it's
running already the config should be automatically reloaded!
```

Vamos fazer uma cópia da configuração original, só pra garantir:

```
cp /etc/gitlab-runner/config.toml /etc/gitlab-runner/config.bak
```

Copie as primeiras linhas deste arquivo (você quer o token), vai parecer com isto:

```
concurrent = 1
check_interval = 0

[[runners]]
  name = "my-autoscale-runner"
  url = "http://yourgitlab.com/ci"
  token = "--- generated runner token ---"
  executor = "docker+machine"
```

A parte importante aqui é o "token". Você vai querer anotar. E agora você também vai querer criar um [novo API Token no Digital Ocean](https://cloud.digitalocean.com/settings/api/tokens). Só Gere um Novo Token e anote.

Agora você pode substituir o arquivo `config.toml` inteiro por isto:

```
concurrent = 20
check_interval = 0

[[runners]]
  name = "my-autoscale-runner"
  url = "http://yourgitlab.com/ci"
  token = "--- generated runner token ---"
  executor = "docker+machine"
  limit = 15
  [runners.docker]
    tls_verify = false
    image = "codeminer42/ci-ruby:2.3"
    privileged = false
  [runners.machine]
    IdleCount = 2                   # Tem que ter 2 máquinas em estado Idle
    IdleTime = 1800                 # Cada máquina pode ficar em estado Idle até 30 minutos (depois disso será removida)
    MaxBuilds = 100                 # Cada máquina pode lidar com até 100 builds em sequência (depois disso será removida)
    MachineName = "ci-auto-scale-%s"   # Cada máquina vai ter um nome único ('%s' é obrigatório)
    MachineDriver = "digitalocean"  # Docker Machine está usando o driver 'digitalocean'
    MachineOptions = [
        "digitalocean-image=coreos-beta",
        "digitalocean-ssh-user=core",
        "digitalocean-access-token=-- seu novo Digital Ocean API Token --",
        "digitalocean-region=nyc1",
        "digitalocean-size=4gb",
        "digitalocean-private-networking",
        "engine-registry-mirror=http://10.0.0.1:6000"
    ]
  [runners.cache]
    Type = "s3"   # O Runner está usando um cache distribuído com o serviço Amazon S3
    ServerAddress = "10.0.0.2:9005"  # minio
    AccessKey = "-- sua minio access key --"
    SecretKey = "-- sua minio secret key"
    BucketName = "runner"
    Insecure = true # Use Insecure só quando usar com Minio, sem o certificado TLS habilitado
```

E você pode reiniciar o runner pra pegar a nova configuração assim:

```
gitlab-ci-multi-runner restart
```

Como eu disse antes, você vai querer ler a [documentação oficial](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/configuration/autoscale.md) extensiva (e todos os links dentro).

Se você fez tudo certo, trocando os IPs privados corretos pro docker registry e cache, os tokens corretos, e assim por diante, pode logar no seu dashboard do Digital Ocean e vai ver algo assim:

![Digital Ocean CI Setup](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/548/big_DigitalOcean_-_Droplets.png)

E da máquina `ci-runner`, você pode listá-las assim:

```
# docker-machine ls

NAME                                                ACTIVE   DRIVER         STATE     URL                         SWARM   DOCKER    ERRORS
runner-xxxx-ci-auto-scale-xxxx-xxxx   -        digitalocean   Running   tcp://191.168.0.1:2376            v1.10.3
runner-xxxx-ci-auto-scale-xxxx-xxxx   -        digitalocean   Running   tcp://192.169.0.2:2376           v1.10.3
```

Elas não devem listar nenhum erro, significando que estão de pé e rodando, esperando novos builds começarem.

Vai ter 2 novas máquinas listadas no seu dashboard do Digital Ocean, chamadas "runner-xxxxx-ci-auto-scale-xxxxx". Isso é o que o `IdleCount = 2` faz. Se ficarem paradas por mais de 30 minutos (`IdleTime = 1800`) serão desligadas pra você não ser cobrado.

Você pode ter várias definições de "runner", cada uma com um `limit` de builds/máquinas que podem ser criadas no Digital Ocean. Você pode ter outras definições de runner pra outros provedores, por exemplo. Mas neste exemplo estamos limitados a no máximo 15 máquinas, então 15 builds concorrentes.

O limite `concurrent` é uma configuração global. Então se eu tivesse 3 definições de runner, cada uma com um `limit` de 15, elas ainda seriam globalmente limitadas a 20 como definido na variável global `concurrent`.

Você pode usar provedores diferentes pra necessidades específicas, por exemplo, pra rodar builds OS X ou builds Raspberry PI ou outros tipos exóticos de build. No exemplo estou mantendo simples e configurando vários builds no mesmo provedor (Digital Ocean).

E não se preocupe com a mensalidade de cada máquina. Quando usada dessa forma, você vai pagar por hora.

Além disso, certifique-se de ter subido todas as suas máquinas (docker-registry, minio cache, CI runner) todas com **rede privada habilitada** (pra que conversem pela VLAN interna em vez de ter que atravessar toda a internet pública) e que estão todas na mesma região/data center (NYC1 é New York 1, New York tem 3 sub-regiões, por exemplo). Não comece máquinas em regiões diferentes.

Porque temos proxy/cache Docker e cache Minio/S3, seus builds vão demorar mais na primeira vez (digamos, 5 minutos), e aí builds subsequentes vão buscar tudo do cache (levando, digamos, 1:30 minuto). É rápido e é conveniente.

### Configurando cada Projeto pro Runner

O Runner é uma das peças mais novas do ecossistema GitLab então você pode ter algum trabalho no começo pra descobrir uma configuração decente. Mas uma vez que você tem a infraestrutura toda figurada como descrito na seção anterior, agora é tão fácil quanto adicionar um arquivo `.gitlab-ci.yml` no seu diretório raiz. Algo assim:

```yaml
# Este arquivo é um template, e pode precisar de edição antes de funcionar no seu projeto.
image: codeminer42/ci-ruby:2.3

# Escolha zero ou mais serviços pra serem usados em todos os builds.
# Só necessário quando usar um container docker pra rodar seus testes.
# Confira: http://docs.gitlab.com/ce/ci/docker/using_docker_images.html#what-is-service
services:
  - postgres:latest
  - redis:latest

cache:
  key: your-project-name
  untracked: true
  paths:
    - .ci_cache/

variables:
  RAILS_ENV: 'test'
  DATABASE_URL: postgresql://postgres:@postgres
  CODECLIMATE_REPO_TOKEN: -- seu token de projeto codeclimate --

before_script:
  - bundle install --without development production -j $(nproc) --path .ci_cache
  - cp .env.sample .env
  - cp config/database.yml.example config/database.yml
  - bundle exec rake db:create db:migrate

test:
  script:
    - xvfb-run bundle exec rspec
```

Meu time na [Codeminer 42](http://www.codeminer42.com) preparou uma [imagem Docker simples](https://hub.docker.com/r/codeminer42/ci-ruby/) com coisas úteis pré-instaladas (como o phantomjs mais novo, xvfb, etc), então agora é super fácil habilitar builds automatizados dentro do GitLab só adicionando este arquivo aos repositórios. (Obrigado ao Carlos Lopes, Danilo Resende e Paulo Diovanni, que vai estar falando [sobre Docker na Rubyconf Brasil 2016](http://www.rubyconf.com.br/pt-BR/speakers#Paulo%20Diovani%20Gonçalves), a propósito)

O GitLab-CI até suporta buildar um Merge Request pendente, e você pode forçar o request pra que ele só possa ser merjado se os builds passarem, assim como no GitHub + Travis. E como o Code Climate é agnóstico a host de repositório ou CI runner, você pode integrá-lo facilmente também.

![Project Force Successful Build to Merge](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/551/big_Settings___Codeminer42___CM-Fulcrum___GitLab.png)

## Conclusão

A matemática é difícil de contestar: o combo GitLab + GitLab-CI + Digital Ocean é uma grande vitória. A interface do GitLab é bem familiar, então usuários vindos do GitHub ou Bitbucket vão se sentir em casa rapidinho.

Podemos usar todos os [Git flows](https://about.gitlab.com/2014/09/29/gitlab-flow/) que estamos acostumados.

O GitLab-CE ainda é um trabalho em andamento, o time está aumentando o ritmo mas atualmente tem mais de [4.200 issues abertas](https://gitlab.com/gitlab-org/gitlab-ce/issues). Mas como tudo isto é Ruby on Rails e tooling Ruby, você pode facilmente entrar e contribuir. Nenhuma contribuição é pequena demais. Só reportar como reproduzir um bug já é ajuda suficiente pra assistir os desenvolvedores a descobrirem como melhorar mais rápido.

Mas não se assuste com as issues abertas, está totalmente funcional agora e eu não achei nenhum bug que poderia ser considerado show stopper.

Eles têm muita coisa certa. Primeiro de tudo, é um projeto Ruby on Rails "simples". É um front-end sem firulas com jQuery puro. A escolha de HAML pras views é questionável mas não atrapalha. Eles usam o bom e velho Sidekiq+Redis pra jobs assíncronos. Sem mágica negra aqui. Um monólito puro que não é difícil de entender e contribuir.

As APIs são todas escritas usando Grape. Eles têm o projeto [GitLab CE](https://gitlab.com/gitlab-org/gitlab-ce) separado de outros componentes, como o [GitLab-Shell](https://gitlab.com/gitlab-org/gitlab-shell) e o [GitLab-CI-Multi-Runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).

Eles também forkaram o [Omnibus](https://gitlab.com/gitlab-org/omnibus-gitlab) pra conseguir empacotar o projeto Rails CE como um ".deb". Tudo é orquestrado com Docker. E quando uma nova versão está disponível, você só precisa rodar `apt-get update && apt-get upgrade` e ele vai fazer todo o trabalho de backup e migração do Postgresql, atualizar o código, incluir novas dependências, reiniciar os serviços e por aí vai. É super conveniente e você deveria dar uma olhada neste projeto se você tem deploys Rails complicados na sua própria infraestrutura (fora do Heroku, por exemplo).

Estou quase terminando de mover centenas de repositórios tanto do BitBucket quanto do GitHub pro GitLab agora e os desenvolvedores da minha empresa já estão usando no dia a dia sem nenhum problema. Estamos quase no ponto onde podemos nos desengajar do BitBucket, GitHub e CIs externos.

Você vai se surpreender com o quão fácil sua empresa também pode fazer isso e economizar alguns milhares de dólares no processo, enquanto se diverte fazendo!
