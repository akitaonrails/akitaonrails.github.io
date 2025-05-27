---
title: Ruby e Rails no Ubuntu 12.04 LTS Precise Pangolin
date: '2012-08-13T21:28:00-03:00'
slug: ruby-e-rails-no-ubuntu-12-04-lts-precise-pangolin
tags:
- learning
- linux
- tutorial
draft: false
---

**Atualização 27/01/2015:** Fiz um novo artigo com o Ubuntu 14.04 LTS. Prossiga para o [novo artigo aqui](http://www.akitaonrails.com/2015/01/28/ruby-e-rails-no-ubuntu-14-04-lts-trusty-tahr).

Um ano atrás eu gravei um screencast sobre [Instalando um Ambiente Ruby](http://akitaonrails.com/2010/07/12/screencast-instalando-um-ambiente-ruby) onde mostro como instalar e configurar um ambiente em Linux/Ubuntu, Mac e Windows 7. 

Por curiosidade, resolvi dar uma olhada no Ubuntu mais recente o 12.04 LTS Precise Pangolin. Já explorei sobre [Rbenv](http://akitaonrails.com/2012/07/06/mudando-de-rvm-para-rbenv) recentemente mas continuo preferindo usar RVM. A partir de um Ubuntu 12.04 recém-instalado entre no site do [RVM](http://rvm.io) e siga as instruções, como vou mostrar neste artigo.

Para VPS pequenos, eu particularmente não me incomodo de usar RVM em single-user mode com Nginx+Passenger. Para instalar faça o seguinte no terminal:

```
sudo apt-get install curl
curl -L https://get.rvm.io | bash -s stable
```

Em single-user mode, o RVM será instalado na pasta <tt>~/.rvm</tt>, para carregar o ambiente, execute a seguir:

```
source ~/.rvm/scripts/rvm
```

Para que o RVM sempre carregue ao iniciar o Terminal (com Bash), adicione a seguinte linha no final do seu <tt>~/.bash_profile</tt>:

```
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
```

O próximo passo é instalar pacotes que o RVM precisa para instalar novos Rubies. Lembre-se que existe o seguinte comando que lhe dirá o que fazer:

```
rvm requirements
```

Como estamos interessados no Ruby MRI mais recente, basta copiar a linha com o <tt>apt-get</tt> e executar:

```
sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
```

Isso já é suficiente para instalar o Ruby, para ver a lista de Rubies disponiveis basta executar:

```
rvm list known
```

Sabendo o nome exato com a versão que queremos, podemos executar:

```
rvm install ruby-1.9.3-p194
```

E terminada a instalação podemos definir que este seja o Ruby padrão:

```
rvm 1.9.3-p194 --default
```

Isso já é suficiente para instalarmos o Rails mais recente e iniciar a programar:

```
gem install rails
```

## Pacotes Importantes

O que acabamos de instalar é o básico. Mas uma aplicação de verdade precisa de um pouco mais como bancos de dados e outros componentes. A maioria das aplicações Rails utilizar PostgreSQL, MySQL, MongoDB ou Redis (ou uma combinação de alguns deles). Além disso é recomendado aprender a utilizar Memcache. 

Lembrando que precisamos instalar tanto os pacotes binários quanto os códigos-fonte/headers para as Rubygems conseguirem compilar suas extensões nativas. Vou dividir as instruções dos diferentes serviços que você pode querer e as Rubygems que as utilizam, ou seja, apesar dos comandos <tt>apt-get install</tt> e <tt>gem install</tt> estarem agrupadas, não significa que você precisa executá-las dessa forma.

Para instalar o MySQL faça:

```
sudo apt-get install mysql-server mysql-client libmysqlclient-dev
gem install mysql2
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

Execute os passos anteriores antes de instalar. O Ubuntu 12.04 vem por padrão para instalar o Postgresql 9.1 mas para usar funcionalidades mais novas como HSTORE, você vai querer instalar a versão 9.3. Para isso comece assim:

```
wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
```

Edite o arquivo de sources com <tt>sudo vim /etc/apt/sources.list</tt> e adicione na última linha:

```
deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
```

Crie o arquivo PGDG com <tt>sudo vim /etc/apt/preferences/pgdg.pref</tt>:

```
Package: *
Pin: release o=apt.postgresql.org
Pin-Priority: 500
```

Agora atualize o apt:

```
sudo apt-get update
sudo apt-get install pgdg-keyring
```

Remova qualquer Postgres mais antigo que tenha instalado:

```
sudo apt-get remove --purge postgresql-9.2 postgresql-9.1 postgresql-contrib
```

E finalmente podemos instalar o Postgres:

```
sudo apt-get install postgresql postgresql-contrib
gem install pg
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

Pode ser que você precise ainda alterar o Template1 do postgresql assim:

```
sudo su postgresql
psql
```

Agora dentro do Postgresql execute os seguinte comandos:

```
update pg_database set datistemplate=false where datname='template1';
drop database Template1;
create database template1 with owner=postgres encoding='UTF-8'
  lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;
update pg_database set datistemplate=true where datname='template1';
```

Para instalar o MongoDB faça:

```
sudo apt-get install mongodb mongodb-dev
gem install mongo
```

Para instalar o Redis faça:

```
sudo apt-get install redis-server libhiredis-dev
gem install hiredis
```

Para instalar o Memcache faça:

```
sudo apt-get install memcached libmemcached-dev
gem install dalli
```

Para instalar o Imagemagick faça:

```
sudo apt-get install imagemagick libmagickwand-dev
gem install rmagick mini_magick
```

## Instalando Vim

E um bom ambiente não estaria completo sem um bom editor de textos para começar a trabalhar. Existem muitas opções como o Sublime Text 2, mas minha preferência pessoal ainda é o Vim. Para quem nunca usou Vim, não deixe de assistir meu screencast [Começando com Vim](http://akitaonrails.com/2010/07/19/screencast-comecando-com-vim). Para instalar neste novo Ubuntu é muito simples:

```
sudo apt-get install vim vim-gnome exuberant-ctags ncurses-term ack

cd ~
git clone git://github.com/akitaonrails/vimfiles.git .vim
cd .vim
git submodule update --init

echo "filetype on" > ~/.vimrc
echo "source ~/.vim/vimrc" >> ~/.vimrc
```

Isso deve instalar todos os submódulos para tornar seu Vim um editor bastante avançado. Assista ao screencast para aprender mais e visite a página do projeto no Github. Muitas coisas mudaram desde que gravei o screencast, por exemplo, em vez do módulo Command-T agora uso o módulo Ctrl-P, dentre outras mudanças.

Se no meio da execução do comando <tt>git submodule</tt> ele parar por alguma razão, sem terminar, não tem problema apenas reexecute o mesmo comando. A partir do terminal, no diretório do seu projeto, execute <tt>gvim</tt> para iniciar o Vim integrado ao ambiente gráfico Gnome (há quem prefira usar dentro do Terminal, mas isso seria mais preferência pessoal mesmo).

## Finalização do Ambiente

Se ainda não instalou, existem mais algumas ferramentas que você vai precisar:

```
sudo apt-get install git git-svn gitk ssh libssh-dev
```

Novamente, se não sabe usar Git, assista meu screencast [Começando com Git](http://akitaonrails.com/2010/08/17/screencast-comecando-com-git) pois é absolutamente obrigatório conhecer Git para programar no ecossistema Ruby e Rails. E para finalizar sua instalação, eu pessoalmente gosto de customizar meu <tt>~/.bashrc</tt> com o seguinte:

```
...
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

ESC="\033" # This is the escape sequence
NO_COLOR="$ESC[0m"
IRED="$ESC[1;31m" # ANSI color code for intense/bold red
IGRN="$ESC[1;32m" # ANSI color code for intense/bold green

# From http://railstips.org/blog/archives/2009/02/02/bedazzle-your-bash-prompt-with-git-info/
# I had to change 'git-symbolic-ref' to 'git symbolic-ref'
function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " ["${ref#refs/heads/}"]" # I wanted my branch wrapped in [], use () or <> or whatever
}

# from http://ariejan.net/2010/04/25/ruby-version-and-gemset-in-your-bash-prompt-yes-sir
function rvm_version {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"
  local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
  [ "$version" != "" ] && version="$version"
  local full="$version$gemset"
  [ "$full" != "" ] && echo "${full}:" # the colon at the end is a delimiter, you could use a space instead
}

#PS1="\h:\W \u\$" # For reference, here's the default OS X prompt
#export PS1="\$(rvm_version)\W \$(parse_git_branch)\$ " # Without the colors

# I had to put the \[ and \] down here, as opposed to $IRED, to avoid wrapping funkiness.
export PS1="\[$IRED\]\$(rvm_version)\[$NO_COLOR\]\W\[$IGRN\]\$(parse_git_branch)\[$NO_COLOR\]\n \$ "
```

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
    passenger_root /home/akitaonrails/.rvm/gems/ruby-2.0.0-p245/gems/passenger-4.0.17;
    passenger_ruby /home/akitaonrails/.rvm/wrappers/ruby-2.0.0-p245/ruby;
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
