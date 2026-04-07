---
title: Ubuntu 16.04 LTS Xenial no Vagrant com Vmware Fusion
date: '2016-09-21T18:08:00-03:00'
slug: ubuntu-16-04-lts-xenial-no-vagrant-com-vmware-fusion
translationKey: ubuntu-xenial-vagrant-vmware
aliases:
- /2016/09/21/ubuntu-16-04-lts-xenial-on-vagrant-on-vmware-fusion/
tags:
- linux
- aprendizado
- elixir
- crystal
- clojure
- ruby on rails
- postgresql
- traduzido
draft: false
---

Sou old school. Sei que a garotada descolada está toda brincando com Docker hoje em dia, mas gosto de ter um ambiente linux completo com todas as dependências num lugar só. Deixo as máquinas voláteis para a nuvem.

Gosto de manter uma box Vagrant por perto, porque por mais bagunçado que um upgrade de sistema operacional possa ser (olhando pra você, macOS), sei que minha máquina de desenvolvimento vai simplesmente funcionar.

Mas mesmo com tudo virtualizado e isolado, coisas ainda podem dar errado. Atualmente estou usando [Vagrant 1.8.5](https://www.vagrantup.com/downloads.html), com o [plugin vagrant-vmware-fusion 4.0.11](https://www.vagrantup.com/vmware/) e Vmware Fusion 8.5 no El Capitan (mesmo com o macOS Sierra tendo acabado de ser lançado, vou esperar pelo menos 1 mês antes de atualizar, nada ali vale o risco).

Se você está instalando uma box novinha pela primeira vez, essa é a configuração mínima do `Vagrantfile` que eu uso:

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 3001, host: 3001
  config.vm.network :forwarded_port, guest: 4000, host: 4000
  config.vm.network :forwarded_port, guest: 5555, host: 5555
  config.vm.network :forwarded_port, guest: 5556, host: 5556
  config.vm.network :forwarded_port, guest: 3808, host: 3808

  config.vm.network "private_network", ip: "192.168.0.100"

  config.vm.synced_folder "/Users/akitaonrails/Sites", "/vagrant", nfs: true

  config.vm.provider :vmware_fusion do |v|
    v.vmx["memsize"] = "2048"
  end
end
```

Normalmente entro nas configurações do Vmware da máquina virtual e habilito um processador extra (já que meu Macbook tem 8 núcleos virtuais pra compartilhar) e habilito o hypervisor (suporte ao VT-x/EPT da Intel).

Como regra geral, a primeira coisa que sempre faço é configurar o locale para en_US.UTF-8:

```
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
```

E, só pra garantir, adicione o seguinte ao `/etc/environment`:

```
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
```

Você precisa configurar o UTF-8 antes de instalar pacotes como o Postgresql.

Depois eu atualizo os pacotes e instalo o básico:

```
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install open-vm-tools build-essential libssl-dev exuberant-ctags ncurses-term ack-grep silversearcher-ag fontconfig imagemagick libmagickwand-dev python-software-properties redis-server libhiredis-dev memcached libmemcached-dev
```

Isso vai instalar ferramentas importantes como Imagemagick, Memcached e Redis pra gente.

Agora, para [instalar o Postgresql](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04):

```
sudo apt-get install postgresql-9.5 postgresql-contrib postgresql-server-dev-9.5
```

Crie o superusuário para o vagrant:

```
sudo -i -u postgres
createuser --interactive

Enter name of role to add: vagrant
Shall the new role be a superuser? (y/n) y
```

E **apenas para o ambiente de desenvolvimento** edite o `/etc/postgresql/9.5/main/pg_hba.conf` e altere o seguinte:

```
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
```

Isso deixa sua vida mais fácil na hora de programar. Se você fez tudo certo até aqui, terá seu PG com encoding unicode adequado e sem incomodar com senha quando rodar `bin/rails db:create`. Se não configurou o locale direito antes, pode seguir [este gist](https://gist.github.com/turboladen/6790847) para setar o locale do PG manualmente para UTF-8.

Instalar [Ruby](https://rvm.io/rvm/install) ainda é melhor via RVM:

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash
source $HOME/.rvm/scripts/rvm
rvm install 2.3.1
rvm use 2.3.1 --default
```

E eu prefiro usar o [YADR](https://github.com/skwp/dotfiles) como meus dotfiles padrão, trocando o Bash pelo ZSH. Comparado com outros dotfiles, gosto desse porque normalmente não preciso mexer em nada, ponto. Nem vou configurar nada de RVM depois da instalação porque o YADR já cuida disso.

```
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh `"
```

Para atualizar (ou retomar caso quebre por algum motivo):

```
cd .yadr
rake update
```

Os únicos 2 ajustes que tenho que fazer são mudar meu perfil do [iTerm2](https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized) para usar [Solarized](http://ethanschoonover.com/solarized), e adicionar as 2 linhas a seguir no topo do arquivo `.vimrc`:

```
scriptencoding utf-8
set encoding=utf-8
```

Próximo passo, [instalar o NodeJS](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04):

```
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs
```

Próximo passo, [instalar o Java](https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04). Você pode escolher o instalador da Oracle, mas acredito que o openjdk deva ser suficiente:

```
sudo apt-get install default-jdk
```

Vamos precisar do Java para o [Elasticsearch](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-16-04) 2.4.0:

```
wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.4.0/elasticsearch-2.4.0.deb && sudo dpkg -i elasticsearch-2.4.0.deb
```

Agora você pode iniciá-lo manualmente com `sudo /etc/init.d/elasticsearch start`, e é melhor deixar assim porque ele consome bastante RAM, então só inicie quando realmente precisar.

Com o Java no lugar, também podemos instalar o [Leiningen](http://leiningen.org/) para ter o Clojure pronto.

```
echo "PATH=$PATH:~/bin" >> ~/.zsh.after/bin.zsh
mkdir ~/bin && cd ~/bin
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod a+x lein
lein
```

O Leiningen vai instalar suas dependências e você pode seguir o [tutorial](https://github.com/technomancy/leiningen/blob/stable/doc/TUTORIAL.md) dele para começar.

Instalar [Rust](https://www.rust-lang.org/en-US/downloads.html) é igualmente fácil:

```
curl -sSf https://static.rust-lang.org/rustup.sh | sh
```

Instalar [Crystal](https://crystal-lang.org/docs/installation/on_debian_and_ubuntu.html), também fácil:

```
curl https://dist.crystal-lang.org/apt/setup.sh | sudo bash
sudo apt-get install crystal
```

Instalar [Go](https://www.digitalocean.com/community/tutorials/how-to-install-go-1-6-on-ubuntu-16-04) até dá, mas é mais manual:

```
wget https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz
tar xvfz go1.7.1.linux-amd64.tar.gz
chown -R root:root .go
sudo mv go /usr/local
touch ~/.zsh.after/go.zsh
echo "export GOPATH=$HOME/go" >> ~/.zsh.after/go.zsh
echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> ~/.zsh.after/go.zsh
```

Assim que instalar o go e configurar o work path dele, podemos instalar algumas ferramentas úteis como o [forego](https://github.com/ddollar/forego) e o [goon](https://github.com/alco/goon#goon) (que o Hex do Elixir pode usar opcionalmente):

```
go get -u github.com/ddollar/forego
go get -u github.com/alco/goon
```

E falando em [Elixir](http://elixir-lang.org/install.html), deixamos o melhor pro final:

```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang elixir
```

E é isso, um tutorial bem direto para ter um ambiente de desenvolvimento moderno pronto pra usar. Essas são as ferramentas básicas de desenvolvimento de software que acredito que deveriam estar no cinto de utilidades de todo mundo nos próximos anos.

Honestamente, não mexo tanto com Clojure e Go quanto acho que deveria. E ainda não dei muito tempo pro .NET Core, mas vou explorar esses em mais detalhes no futuro.
