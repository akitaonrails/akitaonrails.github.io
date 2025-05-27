---
title: Ruby e Rails no Ubuntu 14.04 LTS Trusty Tahr
date: '2015-01-28T17:04:00-02:00'
slug: ruby-e-rails-no-ubuntu-14-04-lts-trusty-tahr
tags:
- learning
- rails
- linux
draft: false
---

Quase 2 anos atrás fiz um artigo que teve muitos leitores sobre [instalar Ruby no Ubuntu 12.04 LTS](http://www.akitaonrails.com/2012/08/13/ruby-e-rails-no-ubuntu-12-04-lts-precise-pangolin). Inclusive era o que eu estava usando até agora como ambiente de desenvolvimento no Vagrant. O bom é que dá pra desenvolver tudo sem problema algum nesse ambiente e é bem estável, mas resolvi atualizar o mesmo artigo para instalar no último Long Term Support do Ubuntu, o [14.04 LTS Trusty Tahr](http://releases.ubuntu.com/14.04/).

Para VPS pequenos, eu particularmente não me incomodo de usar RVM em single-user mode com Nginx+Passenger. Em particular eu instalo esse ambiente num Vagrant, então se for esse o caso, depois de [instalar o Vagrant](https://www.vagrantup.com/downloads.html), faça assim:

```
vagrant init phusion/ubuntu-14.04-amd64
vagrant up
vagrant ssh
```

Isso deve instalar o Ubuntu 14.04. Veja a documentação para configurar o que você precisa. Em particular, no meu caso, antes de dar <tt>vagrant up</tt> eu edito o <tt>Vagrantfile</tt> pra ter o seguinte:

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.synced_folder ".", "/vagrant", :nfs => true

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 3001, host: 3001
  config.vm.network :forwarded_port, guest: 3790, host: 3790
  config.vm.network :private_network, ip: "10.0.0.100"

  config.vm.provider :vmware_fusion do |v|
    v.vmx["memsize"] = "1024"
  end
end
```

Eu uso o [plugin de VMWare Fusion](https://www.vagrantup.com/vmware) (que é ordens de grandeza mais estável e performático que o Virtualbox). Mas qualquer um funciona bem o suficiente pra desenvolver.

Depois de fazer <tt>vagrant ssh</tt> você vai estar dentro do Ubuntu já e a partir daí siga o seguinte:

```
sudo apt-get install curl build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev libgmp-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
```

São os pacotes básicos que você sempre vai precisar. Feito isso, eu gosto de instalar o RVM mesmo:

```
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
```

O próximo passo é instalar pacotes que o RVM precisa para instalar novos Rubies. O próprio RVM toma conta disso fazendo o seguinte:

```
rvm requirements
```

Isso já é suficiente para instalar o Ruby, para ver a lista de Rubies disponiveis basta executar:

```
rvm list known # para ver todos os rubies disponíveis
rvm install 2.2.0 # para instalar o mais recente até a data deste artigo
```

Isso já é suficiente para instalarmos o Rails mais recente e iniciar a programar:

```
gem install rails
```

Não deixe de configurar o locale do seu sistema para UTF-8. Inicie adicionando as seguintes linhas ao seu <tt>/etc/bash.bashrc</tt>:

```
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

Então execute os seguintes comandos:

```
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
```

## Serviços Básicos Importantes

O que acabamos de instalar é o básico. Mas uma aplicação de verdade precisa de um pouco mais como bancos de dados e outros componentes. A maioria das aplicações Rails utilizar PostgreSQL, MySQL ou Redis (ou uma combinação de alguns deles). Além disso é recomendado aprender a utilizar Memcache. 

Lembrando que precisamos instalar tanto os pacotes binários quanto os códigos-fonte/headers para as Rubygems conseguirem compilar suas extensões nativas. 

Para começar, o melhor banco de dados relacional que você precisa instalar é o PostgreSQL:

```
sudo apt-get install postgresql postgresql-contrib postgresql-server-dev-9.3
```

Como estamos falando de uma máquina de desenvolvimento, vamos criar um superuser:

```
sudo su postgres
createuser -P -s -e vagrant
```

Você deve editar o arquivo pg_hba.conf com <tt>sudo vim /etc/postgresql/9.3/main/pg_hba.conf</tt> e faça o final dele estar assim:

```
# Database administrative login by Unix domain socket
local   all             postgres                                trust

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     postgres                                peer
#host    replication     postgres        127.0.0.1/32            md5
#host    replication     postgres        ::1/128                 md5
```

Se vai desenvolver Rails eventualmente você vai precisar do Sidekiq ou Resque, e eles precisam do banco de dados Redis, então instale assim:

```
sudo apt-get install redis-server libhiredis-dev
```

Você pode tirar muita vantagem de um bom cache em suas aplicações, então já deixe o Memcache preparado assim:

```
sudo apt-get install memcached libmemcached-dev
```

Muitas aplicações precisam manipular imagens, e para isso você vai precisar do Imagemagick, então instale assim:

```
sudo apt-get install imagemagick libmagickwand-dev
```

## Instalando Vim

E um bom ambiente não estaria completo sem um bom editor de textos para começar a trabalhar. Existem muitas opções como o Sublime Text 2, mas minha preferência pessoal ainda é o Vim. Para quem nunca usou Vim, não deixe de assistir meu screencast [Começando com Vim](http://akitaonrails.com/2010/07/19/screencast-comecando-com-vim) e para a discussão sobre qual melhor editor para você, não deixe de ler meu artigo [IDEs e Editores, como escolher?](http://www.akitaonrails.com/2014/07/31/small-bites-ides-e-editores-como-escolher). Para instalar neste novo Ubuntu é muito simples:

```
sudo apt-get install zsh vim vim-gnome exuberant-ctags ncurses-term ack-grep
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"
```

Isso vai instalar o excelente conjunto de dotfiles que configura ZSH e Vim pra ficarem perfeitos, o [YADR](https://github.com/skwp/dotfiles). Pode ser que o ZSH não tenha sido instalado então para garantir faça o seguinte:

```
chsh -s $(which zsh)
```

Toda vez que quiser atualizar o YADR, faça assim:

```
cd ~/.yadr
git pull --rebase
rake update
```

Isso deve instalar todos os submódulos para tornar seu Vim um editor bastante avançado. Assista ao screencast para aprender mais e visite a página do projeto no Github. Muitas coisas mudaram desde que gravei o screencast, por exemplo, em vez do módulo Command-T agora uso o módulo Ctrl-P, dentre outras mudanças.

Se no meio da execução do comando <tt>git submodule</tt> ele parar por alguma razão, sem terminar, não tem problema apenas reexecute o mesmo comando. A partir do terminal, no diretório do seu projeto, execute <tt>gvim</tt> para iniciar o Vim integrado ao ambiente gráfico Gnome (há quem prefira usar dentro do Terminal, mas isso seria mais preferência pessoal mesmo).

## Finalização do Ambiente

Se ainda não instalou, existem mais algumas ferramentas que você vai precisar:

```
sudo apt-get install git git-svn gitk ssh libssh-dev
```

Novamente, se não sabe usar Git, assista meu screencast [Começando com Git](http://akitaonrails.com/2010/08/17/screencast-comecando-com-git) pois é absolutamente obrigatório conhecer Git para programar no ecossistema Ruby e Rails. 

## Instalando Phusion Passenger

Com tudo instalado, podemos instalar o último componente: NGINX + Passenger:

Para instalar o Passenger com Nginx faça:

```
sudo apt-get install libcurl4-openssl-dev
gem install passenger
sudo chown -R `whoami` /opt
passenger-install-nginx-module --auto-download --auto
```

Quando ele terminar de instalar, você lembre-se que no arquivo <tt>/opt/nginx/conf/nginx.conf</tt> haverá o seguinte:

```
http {
    ...
    passenger_root /home/akitaonrails/.rvm/gems/ruby-2.2.0/gems/passenger-4.0.58;
    passenger_ruby /home/akitaonrails/.rvm/wrappers/ruby-2.2.2.0/ruby;
    ...
}
```

Sempre que atualizar o passenger, atualize este trecho com a versão mais recente. Além disso, para configurar novas aplicações Rails, no mesmo arquivo configure da seguinte forma:

```
server {
   listen 80;
   server_name www.yourhost.com;
   root /somewhere/public;   # <--- be sure to point to 'public'!
   passenger_enabled on;
}
```

Onde <tt>/somewhere</tt> é onde está o código da aplicação Rails, sempre completando com <tt>/public</tt> para o Passenger saber o que fazer.

Na instalação eu trapeceei um pouco: como instalei o RVM em single-mode não dá para instalar o nginx usando o script do Passenger via <tt>sudo</tt>. Por isso mudei o dono do diretório <tt>/opt</tt>. Precisamos mudar de volta:

```
sudo chown -R root /opt
```

Agora queremos que o NGINX inicie automaticamente sempre que o servidor reiniciar, para isso podemos usar da ajuda do script de inicialização feito pelo Linode:

```
wget -O init-deb.sh http://library.linode.com/assets/660-init-deb.sh
sudo mv init-deb.sh /etc/init.d/nginx
sudo chmod +x /etc/init.d/nginx
sudo /usr/sbin/update-rc.d -f nginx defaults
```

obs: dica retirada [deste blog post](http://excid3.com/blog/setting-up-ubuntu-12-04-with-ruby-1-9-3-nginx-passenger-and-postgresql-or-mysql/)

Inicie ou pare o NGINX como qualquer outro serviço no Ubuntu:

```
sudo service nginx start
sudo service nginx stop
sudo service nginx restart
```

Ambiente configurado, bom aprendizado!
