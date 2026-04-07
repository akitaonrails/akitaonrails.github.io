---
title: "Aplicativo Elixir Phoenix em Deploy num Setup com Balanceamento de Carga no DigitalOcean"
date: '2016-12-23T15:07:00-02:00'
slug: aplicativo-elixir-phoenix-deploy-balanceamento-carga-digitalocean
tags:
- elixir
- phoenix
- deployment
- edeliver
- digitalocean
- websockets
- traduzido
translationKey: elixir-phoenix-digitalocean-lb
aliases:
- /2016/12/23/elixir-phoenix-app-deployed-into-a-load-balanced-digitalocean-setup/
draft: false
---

Uma das principais vantagens de construir uma aplicação web com Websockets usando Phoenix é como é "fácil" para o Erlang se conectar num cluster.

Para começar, Erlang não precisa de múltiplos processos como Ruby (que fica limitado a uma conexão por processo, ou por thread se você usa um servidor com threads como o Puma). Um único processo Erlang vai tomar conta de toda a máquina, se necessário. Internamente ele mantém uma thread real por core da máquina. E cada thread tem seu próprio Scheduler para gerenciar quantos micro-processos você precisar. Você pode ler tudo sobre isso no meu post ["Yocto Services"](http://www.akitaonrails.com/2015/11/25/yocto-services-and-my-first-month-with-elixir).

Além disso, Erlang tem capacidades nativas de formar um cluster, onde cada instância Erlang age como um Node peer-to-peer, sem precisar de um coordenador centralizado. Você pode ler tudo sobre isso no meu post sobre [Nodes](http://www.akitaonrails.com/2015/11/25/exmessenger-exercise-understanding-nodes-in-elixir). O poder do Erlang está em como é "fácil" formar sistemas distribuídos confiáveis.

Você pode subir várias instâncias Phoenix e, a partir de uma delas, transmitir mensagens para usuários inscritos em Channels mesmo que seus sockets estejam conectados a instâncias diferentes. É transparente e você não precisa fazer nada especial no seu código. Phoenix, Elixir e Erlang fazem todo o trabalho pesado por você nos bastidores.

### Sem Heroku para você :-(

Como você quer aproveitar esse recurso de escalabilidade e alta disponibilidade para sistemas distribuídos (no pequeno exemplo de um sistema de chat em tempo real), vai precisar ter mais controle sobre a infraestrutura. Esse requisito descarta a maioria das ofertas de Platform as a Service (PaaS), como o Heroku. O modelo do Heroku gira em torno de processos únicos e voláteis em containers isolados. Esses processos enjaulados (dynos) não têm consciência de outros processos ou da rede interna, então você não consegue subir Dynos e fazer com que formem um cluster porque eles não vão se encontrar.

Se você já sabe configurar coisas no Linux: Postgresql, HAproxy, etc., vá direto para a [seção específica do Phoenix](#phoenix-setup).

### IaaS (DigitalOcean) ao resgate!

Você precisa de processos de longa duração em servidores alcançáveis pela rede (seja por rede privada, VPN, ou simplesmente - inseguro! - redes públicas).

Neste exemplo quero mostrar um deploy bem simples usando DigitalOcean (você pode escolher qualquer IaaS, como AWS, Google Cloud, Azure ou o que você se sentir mais confortável).

Criei 4 droplets (todos usando o menor tamanho de 512Mb de RAM):

* 1 banco de dados Postgresql (ponto único de falha: não é o foco deste artigo construir um setup de banco de dados altamente disponível e replicado);
* 1 servidor HAProxy (ponto único de falha: novamente, não é o foco criar um esquema de balanceamento de carga altamente disponível);
* 2 servidores Phoenix - um no datacenter de NYC e outro no de Londres, para demonstrar como é fácil para o Erlang formar clusters mesmo com máquinas geograficamente separadas.

### Configuração básica do Ubuntu 16.04

* Objetivos: configurar o locale, garantir que as atualizações automáticas estejam ativas, atualizar pacotes, instalar e configurar Elixir e Node.
* Você também deveria: mudar o SSH para outra porta e instalar [fail2ban](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04, desabilitar login por senha.

Recomendo ler meu post sobre [configurar o Ubuntu 16.04](http://www.akitaonrails.com/2016/09/21/ubuntu-16-04-lts-xenial-on-vagrant-on-vmware-fusion). Resumindo, comece configurando o UTF-8 corretamente:

```
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
echo 'LC_ALL=en_US.UTF-8' | sudo tee -a /etc/environment
echo 'LANG=en_US.UTF-8' | sudo tee -a /etc/environment
```

Adicione um usuário adequado ao grupo sudo e, a partir de agora, não use mais o usuário root. Vou criar um usuário chamado `pusher` e vou explicar em outro post o porquê. Você deve criar um nome de usuário que faça sentido para a sua aplicação.

```
adduser pusher
usermod -aG sudo pusher
```

Agora saia e entre novamente com esse usuário. `ssh pusher@server-ip-address`. Se você estiver num Mac, copie a chave pública do seu certificado SSH assim:

```
ssh-copy-id -i ~/.ssh/id_ed25519.pub pusher@server-ip-address
```

Isso cria o `.ssh/authorized_keys` se não existir, define as permissões corretas e adiciona sua chave pública. Você pode fazer isso manualmente também, claro.

Os droplets do DigitalOcean não vêm com swap file e eu recomendaria adicionar um, especialmente se você quiser começar com as máquinas menores com menos de 1GB de RAM:

```
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
```

Certifique-se de que as atualizações automáticas estejam configuradas. No mínimo você vai querer que as atualizações de segurança sejam instaladas automaticamente quando disponíveis.

```
sudo apt install unattended-upgrades
```

Agora, vamos instalar Elixir e Node (Phoenix precisa de Node.js):

```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential nodejs esl-erlang elixir erlang-eunit erlang-base-hipe
sudo npm install -g brunch
mix local.hex
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez # opcional, instale se quiser testar phoenix manualmente na sua máquina
```

Agora você tem uma máquina pronta para Elixir. Crie um snapshot de imagem no DigitalOcean, mova para as regiões onde quer criar seus outros droplets e use essa imagem para criar quantos droplets precisar.

Para este exemplo, criei um segundo droplet na região de Londres, um terceiro para postgresql na região NYC1 e um quarto na região NYC3 para o HAProxy.

Vou me referir aos endereços IP públicos deles como **"nyc-ip-address"**, **"lon-ip-address"**, **"pg-ip-address"**, e **"ha-ip-address"**.

### Configuração básica do PostgreSQL

* Objetivo: configuração básica do Postgresql para permitir que os servidores Phoenix se conectem.
* A fazer: criar uma role secundária só para conectar ao banco da aplicação e outra superusuário para criar o banco e migrar o schema. Também trancar a máquina e configurar SSH tunnels ou outro método seguro, pelo menos uma rede privada, em vez de permitir conexões TCP na porta 5432 abertas para a Internet.

Agora conecte em `ssh pusher@pg-ip-address` e siga isso:

```
sudo apt-get install postgresql postgresql-contrib
```

Crie uma nova role com o mesmo nome do usuário que você adicionou acima ("pusher" no nosso exemplo):

```
$ sudo -u postgres createuser --interactive

Enter name of role to add: pusher
Shall the new role be a superuser? (y/n) y

$ sudo -u postgres createdb pusher
```

O Postgresql espera encontrar um banco de dados com o mesmo nome da role e a role deve ter o mesmo nome do usuário Linux. Agora você pode usar `psql` para definir uma senha para essa nova role:

```
$ sudo -u postgres psql
\password pusher
```

Registre uma senha segura, anote-a e vamos em frente.

O Postgresql vem bloqueado para conexões externas. Uma forma de conectar de fora é configurar seus servidores para criar um [SSH tunnel](https://www.postgresql.org/docs/9.1/static/ssh-tunnels.html) ao servidor de banco de dados e manter as conexões TCP externas pela porta 5432 proibidas.

Mas neste exemplo, vamos simplesmente permitir conexões da Internet pública na porta TCP 5432. **Atenção:** isso é MUITO inseguro!

Edite o `/etc/postgresql/9.5/main/postgresql.conf` e encontre a linha de configuração `listen_addresses` e permita:

```
listen_addresses = '*'    # what IP address(es) to listen on;
```

Isso deve vincular o servidor à porta TCP. Agora edite `/etc/postgresql/9.5/main/pg_hba.conf` e edite o final para ficar assim:

```
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
host    all             all             your-local-machine-ip-address/24        trust
host    all             all             nyc-ip-address/24       trust
host    all             all             lon-ip-address/24       trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
```

Salve o arquivo de configuração e reinicie o servidor:

```
sudo service postgresql restart
```

Viu o que fiz aí? Só permiti conexões vindas dos IPs públicos dos servidores Phoenix. Isso não torna o servidor seguro, só um pouco menos vulnerável. Se você está atrás de uma rede DHCP/NAT, só pesquise "what's my IP" no Google para ver seu IP público - que provavelmente é compartilhado por muitos outros usuários; lembre-se que você está permitindo conexões de um IP inseguro ao seu servidor de banco de dados! Depois de fazer os testes iniciais e criar seu schema, remova a linha `your-local-machine-ip-address/24` da configuração.

Na sua aplicação Phoenix, edite o arquivo local `config/prod.secret.exs` para ficar assim:

```ruby
# Configure your database
config :your_app_name, ExPusherLite.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pusher",
  password: "your-super-secure-pg-password",
  database: "your-app-database-name",
  hostname: "pg-ip-address",
  pool_size: 20
```

Substitua as informações pelo seu servidor e banco de dados, e agora você pode testar assim:

```
MIX_ENV=prod iex -S mix phoenix.server
```

Se você ver uma mensagem `:econnrefused` do postgrex, tem algo errado. Revise sua configuração, reinicie o servidor e tente novamente. Se tudo conectar, rode `MIX_ENV=prod mix do ecto.create, ecto.migrate` para preparar seu banco de dados.

Por fim, você vai querer fechar o restante do seu servidor com UFW, pelo menos. UFW já vem instalado no Ubuntu 16, então basta fazer:

```
ufw allow 5432
ufw allow ssh
ufw enable
```

Pronto. E de novo, isso não torna seu servidor seguro, só o torna menos inseguro. Há uma diferença enorme!

E por falar nisso, se você é fã de Docker:

> NÃO INSTALE UM BANCO DE DADOS DENTRO DE UM CONTAINER DOCKER!

[Você foi avisado](http://patrobinson.github.io/2016/11/07/thou-shalt-not-run-a-database-inside-a-container/)!

### Configuração básica do HAProxy

* Objetivos: fornecer uma solução simples de balanceamento de carga entre nossos 2 servidores Phoenix.
* A fazer: há algo errado com a verificação de sessão ou algo assim, pois às vezes preciso atualizar o browser para não ser mandado de volta ao formulário de login na minha aplicação. Phoenix usa sessões baseadas em cookie, então não acho que esteja perdendo sessões.

Agora vamos `ssh pusher@ha-ip-address`. Essa parte é fácil, basta instalar o HAProxy:

```
sudo apt-get install haproxy
```

Edite `/etc/haproxy/haproxy.cfg`:

```
...
listen your-app-name
  bind 0.0.0.0:80
  mode http
  stats enable
  stats uri /haproxy?stats
  stats realm Strictly\ Private
  stats auth admin:some-secure-password-for-admin
  option forwardfor
  option http-server-close
  option httpclose
  balance roundrobin
  cookie SERVERID insert indirect nocache
  server us your_us_server_IP:8080 check cookie us1
  server uk your_uk_server_IP:8080 check cookie uk1
```

Você pode omitir as linhas de `stats` se tiver outros meios de monitoramento, caso contrário defina uma senha segura para o usuário `admin`. Uma parte muito importante é o `option http-server-close`, conforme explicado [neste outro post](http://blog.silverbucket.net/post/31927044856/3-ways-to-configure-haproxy-for-websockets), caso contrário você pode ter problemas com Websockets.

Por algum motivo estou tendo problemas com minha aplicação depois de fazer login e ela definir a sessão - às vezes preciso atualizar para ser redirecionado à página correta, ainda não sei o porquê e acredito que seja algo na configuração do HAProxy. Se alguém souber o que é, me avise nos comentários. Por ora, estou recorrendo a Sticky sessions (afinidade de servidor) fazendo o HAProxy escrever um cookie de volta com o servidor.

Agora reinicie o servidor e habilite o UFW também:

```
sudo service haproxy restart
sudo ufw allow http
sudo ufw allow https
sudo ufw allow ssh
sudo ufw enable
```

Você pode facilmente adicionar suporte a SSL na sua aplicação configurando o HAProxy (e não os nodes Phoenix). A [documentação do DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-secure-haproxy-with-let-s-encrypt-on-ubuntu-14-04) é abrangente, é só seguir. No fim, meu `haproxy.cfg` ficou assim:

```
global
   log /dev/log    local0
   log /dev/log    local1 notice
   chroot /var/lib/haproxy
   stats socket /run/haproxy/admin.sock mode 660 level admin
   stats timeout 30s
   user haproxy
   group haproxy
   daemon
   maxconn 2048
   tune.ssl.default-dh-param 2048

defaults
   log global
   mode http
   option httplog
   option dontlognull
   option redispatch
   option forwardfor
   option http-server-close
   timeout connect 5000
   timeout client  50000
   timeout server  50000

frontend www-http
   bind your_ha_proxy_IP:80
   reqadd X-Forwarded-Proto:\ http
   default_backend www-backend

frontend www-https
   bind your_ha_proxy_IP:443 ssl crt /etc/haproxy/certs/your_domain.pem
   reqadd X-Forwarded-Proto:\ https
   acl letsencrypt-acl path_beg /.well-known/acme-challenge/
   use_backend letsencrypt-backend if letsencrypt-acl
   default_backend www-backend

backend www-backend
   redirect scheme https if !{ ssl_fc }
   # setting session stickiness
   cookie SERVERID insert indirect nocache
   server us your_us_server_IP:8080 check cookie us1
   server uk your_uk_server_IP:8080 check cookie uk1

backend letsencrypt-backend
   server letsencrypt 127.0.0.1:54321
```

Por fim, vou assumir que você tem um servidor/serviço de DNS em algum lugar onde pode registrar o IP deste servidor HAProxy como um registro A para acessá-lo por um nome completo como "your-app-name.mydomain.com".

<a name="phoenix-setup"></a>

### Configuração básica do Phoenix

* Objetivo: configurar a app Phoenix para ser deployável. Configurar os servidores com os arquivos de configuração necessários.
* A fazer: descobrir uma forma de reduzir os tempos absurdamente longos de deploy.

Finalmente, temos quase tudo no lugar.

Vou assumir que você já tem uma aplicação Phoenix funcionando, caso contrário crie uma a partir de qualquer um dos muitos tutoriais disponíveis.

Montei estas informações a partir de [posts](https://medium.com/@diamondgfx/deploying-phoenix-applications-with-exrm-97a3867ebd04#.7qyuplncx) como [este muito útil](http://engineering.pivotal.io/post/how-to-set-up-an-elixir-cluster-on-amazon-ec2/) do Pivotal sobre deploy baseado em AWS. Em resumo, você precisa fazer uma série de alterações na sua configuração.

Quando você está desenvolvendo a aplicação, vai notar que toda vez que roda, ela compila incrementalmente o que mudou. Os binários ficam em `_build/dev` ou `_build/test` na forma de binários `.beam` (similar ao que `.class` são para Java).

Diferente de Ruby, Python ou PHP, você não está fazendo deploy de código-fonte para servidores de produção. É mais parecido com Java, onde você precisa ter tudo compilado em binários e empacotado no que chamamos de **release**. É como um ".war" ou ".ear" se você vem do mundo Java.

Para criar esse pacote as pessoas costumavam usar "exrm", mas está sendo substituído por ["distillery"](https://github.com/bitwalker/distillery), então vamos usá-lo.

Aí, se você vem do Ruby está familiarizado com Capistrano. Ou se vem do Python, conhece o clone do Capistrano, Fabric. Elixir tem uma ferramenta similar (bem mais simples por enquanto), chamada ["edeliver"](https://github.com/boldpoker/edeliver). É basicamente uma ferramenta de automação SSH.

Você adiciona eles ao `mix.exs` como qualquer outra dependência:

```ruby
...
def application do
  [mod: {ExPusherLite, []},
   applications: [..., :edeliver]]
end

defp deps do
  [...,
   {:edeliver, "~> 1.4.0"},
   {:distillery, "~> 1.0"}]
end
...
```

Do post do Pivotal, o detalhe importante para não esquecer é editar esta parte no arquivo `config/prod.exs`:

```ruby
http: [port: 8080],
url: [host: "your-app-name.yourdomain.com", port: 80],
...
config :phoenix, :serve_endpoints, true
```

Você PRECISA deixar fixo o PORT padrão do servidor web Phoenix e o domínio permitido (lembra do nome de domínio que você associou ao seu servidor HAProxy acima? Esse mesmo). E PRECISA descomentar a linha `:serve_endpoints, true`!

Para o edeliver funcionar, você precisa criar um arquivo `.deliver/config` assim:

```
USING_DISTILLERY=true

# change this to your app name:
APP="your-app-name"

# change this to your own servers IP and add as many as you want
US="nyc-ip-address"
UK="lon-ip-address"

# the user you created in your Ubuntu machines above
USER="pusher"

# which server do you want to build the first release?
BUILD_HOST=$US
BUILD_USER=$USER
BUILD_AT="/tmp/edeliver/$APP/builds"

# list the production servers declared above:
PRODUCTION_HOSTS="$US $UK"
PRODUCTION_USER=$USER
DELIVER_TO="/home/$USER"

# do not change here

LINK_VM_ARGS="/home/$USER/vm.args"

# For *Phoenix* projects, symlink prod.secret.exs to our tmp source
pre_erlang_get_and_update_deps() {
  local _prod_secret_path="/home/$USER/prod.secret.exs"
  if [ "$TARGET_MIX_ENV" = "prod" ]; then
    __sync_remote "
      ln -sfn '$_prod_secret_path' '$BUILD_AT/config/prod.secret.exs'

      cd '$BUILD_AT'

      mkdir -p priv/static

      mix deps.get

      npm install

      brunch build --production

      APP='$APP' MIX_ENV='$TARGET_MIX_ENV' $MIX_CMD phoenix.digest $SILENCE
    "
  fi
}
```

Lembra de todas as informações que fomos juntando desde o início desta longa receita? São essas opções que você PRECISA mudar para as suas. Basta seguir os comentários no conteúdo do arquivo acima e adicionar ao seu repositório git. Aliás, seu projeto está num repositório GIT adequado, né??

Se você gosta de usar chaves SSH privadas protegidas por passphrase, vai ser uma dor de cabeça enorme para fazer deploy porque, para cada comando, o edeliver vai emitir um comando SSH que vai ficar pedindo sua passphrase, umas dez vezes ao longo de todo o processo. Você foi avisado! Se ainda assim não se importar, e estiver num Mac, vai ter um problema extra porque o Terminal não consegue criar um prompt para você digitar sua passphrase. Você precisa criar um [script](https://github.com/markcarver/mac-ssh-askpass) `/usr/local/bin/ssh-askpass`:

```
#!/bin/bash
# Script: ssh-askpass
# Author: Mark Carver
# Created: 2011-09-14
# Licensed under GPL 3.0

# A ssh-askpass command for Mac OS X
# Based from author: Joseph Mocker, Sun Microsystems
# http://blogs.oracle.com/mock/entry/and_now_chicken_of_the

# To use this script:
#   Install this script running INSTALL as root
#
# If you plan on manually installing this script, please note that you will have
# to set the following variable for SSH to recognize where the script is located:
#   export SSH_ASKPASS="/path/to/ssh-askpass"

TITLE="${SSH_ASKPASS_TITLE:-SSH}";
TEXT="$(whoami)'s password:";
IFS=$(printf "\n");
CODE=("on GetCurrentApp()");
CODE=(${CODE[*]} "tell application \"System Events\" to get short name of first process whose frontmost is true");
CODE=(${CODE[*]} "end GetCurrentApp");
CODE=(${CODE[*]} "tell application GetCurrentApp()");
CODE=(${CODE[*]} "activate");
CODE=(${CODE[*]} "display dialog \"${@:-$TEXT}\" default answer \"\" with title \"${TITLE}\" with icon caution with hidden answer");
CODE=(${CODE[*]} "text returned of result");
CODE=(${CODE[*]} "end tell");
SCRIPT="/usr/bin/osascript"
for LINE in ${CODE[*]}; do
      SCRIPT="${SCRIPT} -e $(printf "%q" "${LINE}")";
done;
eval "${SCRIPT}";
```

Agora faça isso:

```
sudo chmod +x /usr/local/bin/ssh-askpass
sudo ln -s /usr/local/bin/ssh-askpass /usr/X11R6/bin/ssh-askpass
```

Lembre-se, apenas para Macs. E agora toda vez que tentar fazer deploy você vai receber vários prompts gráficos pedindo a passphrase da chave privada SSH. É de enlouquecer! E você precisa ter o [XQuartz](https://www.xquartz.org/) instalado, por sinal.

Agora você precisa criar manualmente 3 arquivos em todos os servidores Phoenix. Comece com `your-app-name/vm.args`:

```
-name us@nyc-ip-address
-setcookie @bCd&fG
-kernel inet_dist_listen_min 9100 inet_dist_listen_max 9155
-config /home/pusher/your-app-name.config
-smp auto
```

O `/home/pusher/your-app-name` é o diretório onde a release vai ser descomprimida depois que o edeliver fizer o deploy do tarball.

Você precisa criar este arquivo em todas as máquinas Phoenix, mudando o bit `-name` pelo mesmo nome que declarou no arquivo `.deliver/config`. O `-setcookie` pode ser qualquer nome, desde que seja o mesmo em todos os servidores.

Viu o `-config /home/pusher/your-app-name.config`? Crie esse arquivo com o seguinte:

```
[{kernel,
  [
    {sync_nodes_optional, ['uk@lon-ip-address']},
    {sync_nodes_timeout, 30000}
  ]}
].
```

Isso é código-fonte Erlang. Na máquina de NYC você deve declarar o nome de Londres, e vice-versa. Se você tiver várias máquinas, todas elas exceto a que você está agora. Entendeu?

Por fim, para a própria app Phoenix, você sempre tem um `config/prod.secret.exs` que nunca deve ser adicionado com `git add` ao repositório, lembra? É aqui que você coloca as informações do servidor Postgresql e a chave secreta aleatória para assinar os cookies de sessão:

```
use Mix.Config

config :your_app_name, YourAppName.Endpoint,
  secret_key_base: "..."

# Configure your database
config :your_app_name, YourAppName.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pusher",
  password: "your-super-secure-pg-password",
  database: "your-app-database-name",
  hostname: "pg-ip-address",
  pool_size: 20

# if you have Guardian, for example:
config :guardian, Guardian,
  secret_key: "..."
```

Como você cria uma nova chave secreta aleatória? Na sua máquina de desenvolvimento, basta rodar: `mix phoenix.gen.secret` e copiar a string gerada para o arquivo acima.

Então agora você deve ter esses 3 arquivos em cada servidor Phoenix, na pasta home `/home/pusher`:

```
~/your-app-name/vm.args
~/prod.secret.exs
~/your-app-name.config
```

Conforme a [documentação do distillery](https://hexdocs.pm/distillery/runtime-configuration.html#vm-args), você precisa definir uma variável de ambiente para informar a localização do arquivo `vm.args`, e isso é **SUPER** importante - caso contrário ele vai gerar um padrão que não define o nome e cookie corretos, então os nodes não vão se encontrar depois de subir.

Usando `sudo`, edite o `/etc/environment` e adicione a linha:

```
RELEASE_CONFIG_DIR=/home/pusher/your-app-name
VMARGS_PATH=/home/pusher/your-app-name/vm.args
```

Faça isso em todos os servidores phoenix.

No seu diretório de desenvolvimento local você ainda precisa rodar isso:

```
mix release.init
```

Isso vai gerar um arquivo padrão `rel/config.exs` que você precisa adicionar ao repositório git com as seguintes alterações no final:

```ruby
...
environment :prod do
  plugin Releases.Plugin.LinkConfig
  ...
end

release :your_app_name do
  set version: current_version(:your_app_name)

  set applications: [
    your_app_name: :permanent
  ]
end
```

O plugin deve habilitar a release a encontrar o arquivo `vm.args` local no servidor (isso é super importante, caso contrário os comandos remotos como start, stop, ping, etc. não vão funcionar e os nodes não vão carregar as informações corretas para subir e formar um cluster).

Finalmente, tudo pronto, você pode executar este comando:

```
$ mix edeliver build release production --skip-mix-clean --verbose
```

Se terminar sem erros você vai ter uma mensagem parecida com esta no final:

```
...
==> Release successfully built!
    You can run it in one of the following ways:
      Interactive: _build/prod/rel/your-app-name/bin/your-app-name console
      Foreground: _build/prod/rel/your-app-name/bin/your-app-name foreground
      Daemon: _build/prod/rel/your-app-name/bin/your-app-name start
--> Copying release 0.0.1 to local release store
--> Copying your-app-name.tar.gz to release store

RELEASE BUILD OF YOUR-APP-NAME WAS SUCCESSFUL!
```

Agora, isso vai demorar um tempo absurdamente longo para fazer o deploy. Isso porque vai clonar o código-fonte da sua app com git, buscar todas as dependências Elixir (toda vez!), compilar tudo, depois rodar o lentíssimo `npm install` (toda vez!), processar os assets com brunch, criar a tal "release", comprimir em tar e gzip, baixar e enviar via SCP para as outras máquinas configuradas.

No arquivo `.deliver/config` você definiu a opção `BUILD_HOST`. É a máquina onde todo esse processo acontece, então você vai querer que pelo menos essa máquina seja mais robusta que as outras. Como estou usando droplets pequenos de 512Mb, o processo leva uma eternidade.

O último comando vai baixar o tarball gerado. Ele precisa fazer isso para garantir que os [NIFs](http://erlang.org/doc/tutorial/nif.html) estejam compilados no ambiente nativo onde vai rodar, porque se você usa Mac, binários de Mac não vão rodar no Linux.

Agora precisamos fazer o upload e descompressão desse tarball em cada servidor com o seguinte comando:

```
mix edeliver deploy release to production
```

Quanto mais lenta sua rede, mais tempo vai levar, já que está enviando um tarfile grande pela internet pública, então certifique-se de estar numa conexão rápida. Quando terminar, podemos reiniciar os servidores (se você já tinha instâncias rodando):

```
mix edeliver stop production
mix edeliver start production
```

Se você fizer tudo certo, o processo do edeliver termina sem erros e deixa um daemon rodando no seu servidor, assim:

```
/home/pusher/your-app-name/erts-8.2/bin/beam -- -root /home/pusher/your-app-name -progname home/pusher/your-app-name/releases/0.0.1/your-app-name.sh -- -home /home/pusher -- -boot /home/pusher/your-app-name/releases/0.0.1/your-app-name -config /home/pusher/your-app-name/running-config/sys.config -boot_var ERTS_LIB_DIR /home/pusher/your-app-name/erts-8.2/../lib -pa /home/pusher/your-app-name/lib/your-app-name-0.0.1/consolidated -name us@nyc-ip-address -setcookie ex-push&r-l!te -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9155 -config /home/pusher/your-app-name.config -mode embedded -user Elixir.IEx.CLI -extra --no-halt +iex -- console
```

Ainda vai demorar bastante, mas deve ser mais fácil. Então aqui vai uma dica pro para usuários Linux. Siga [este Gist](https://gist.github.com/mattweldon/2e8ecb953216438ad168) para mais detalhes; você precisa emular o que é executado na segunda metade do arquivo `.deliver/config`.

Note também que rodei as migrations manualmente, mas você pode fazer isso usando `mix edeliver migrate`.

Leia a documentação deles para mais comandos e configurações.

E não esqueça de habilitar o UFW:

```
sudo ufw allow ssh
sudo ufw allow 8080
sudo ufw allow 4369
sudo ufw allow proto tcp from any to any port 9100:9155
sudo ufw default allow outgoing
sudo ufw enable
```

### Depurando bugs em produção

Logo depois que fiz o deploy, obviamente falhou. E o problema é que os arquivos `/home/pusher/your-app-name/log/erlang.log` (eles são rotacionados automaticamente, então você pode encontrar vários arquivos terminando em número) não vão mostrar muita coisa.

O que eu recomendo é alterar o arquivo `config/prod.exs` APENAS na sua máquina de desenvolvimento e mudar o nível de log para `config :logger, level: :debug`, usar o mesmo `prod.secret.exs` que você editou nos servidores e rodar localmente com `MIX_ENV=prod iex -S mix phoenix.server`.

Por exemplo, em modo de desenvolvimento eu tinha um código no controller que verificava a existência de um parâmetro de query string opcional assim:

```ruby
if params["some_parameter"] do
 ...
```

Funcionava bem em desenvolvimento mas travava em produção, então tive que mudar para:

```ruby
if Map.has_key?(params, "some_parameter") do
 ...
```

Outro problema foi que Guardian funcionava normalmente em desenvolvimento, mas em produção precisei declarar sua aplicação no `mix.exs` assim:

```ruby
def application do
  [mod: {ExPusherLite, []},
   applications: [..., :guardian, :edeliver]]
end
```

Estava recebendo erros `:econnrefused` porque esqueci de rodar `MIX_ENV=prod mix do ecto.create, ecto.migrate` como instruí acima. Depois de resolver essas questões, minha aplicação estava funcionando em `http://your-app-name.yourdomain.com`, o HAProxy estava encaminhando corretamente para a porta 8080 nos servidores e tudo roda bem, incluindo as conexões WebSocket.

### Conclusão

Como mencionei acima, esse tipo de procedimento me faz sentir falta de uma solução de deploy fácil como o Heroku.

O único problema que estou enfrentando agora é que quando faço login pela página de sign in do Coherence, não sou redirecionado para o URI correto que estava tentando acessar ("/admin" no meu caso) - às vezes recarregar depois do login funciona, às vezes não. Às vezes estou dentro de uma página "/admin" mas quando clico em um dos links ele me manda de volta para a página de login mesmo estando logado. Não sei se é um bug no Coherence, ExAdmin, no próprio Phoenix ou uma configuração errada do HAProxy. Vou atualizar este post se descobrir.

O Edeliver também leva um tempo obsceno para fazer deploy. Até esperar os sprockets processarem num `git push heroku master` parece muito mais rápido em comparação. E isso para uma app Phoenix bem enxuta. Ter que buscar tudo (porque o Hex não mantém um cache global local, todas as dependências são vendorizadas estaticamente no diretório do projeto) e ter que rodar o lentíssimo npm não ajuda em nada.

Ainda preciso pesquisar se há opções mais rápidas, mas por ora o que tenho "funciona".

E mais importante: agora tenho um cluster escalável para WebSockets bidirecionais em tempo real, que é a principal razão pela qual alguém pode querer usar Phoenix.

Se você quer construir um site "normal", mantenha simples e faça em Rails, Django, Express ou qual for seu framework web preferido. Se você quer comunicações em tempo real de forma fácil, talvez eu tenha uma solução melhor. Fique de olho no blog para novidades que vêm por aí! ;-)
