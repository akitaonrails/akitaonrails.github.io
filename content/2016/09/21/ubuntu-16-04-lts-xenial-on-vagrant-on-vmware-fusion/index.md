---
title: Ubuntu 16.04 LTS Xenial on Vagrant on Vmware Fusion
date: '2016-09-21T18:08:00-03:00'
slug: ubuntu-16-04-lts-xenial-on-vagrant-on-vmware-fusion
tags:
- linux
- install
- learning
- elixir
- crystal
- clojure
- ruby on rails
- postgresql
draft: false
---

I'm old school. I know the cool kids are all playing around with Docker nowadays, but I like to have a full blown linux environment with all dependencies in one place. I will leave volatile boxes for the cloud.

I like to keep a Vagrant box around, because no matter how messy an OS upgrade can go (looking at ya macOS), I know my development box will just work.

But even with everything virtualized and isolated, things can still go wrong. I am currently using [Vagrant 1.8.5](https://www.vagrantup.com/downloads.html), with the [vagrant-vmware-fusion plugin 4.0.11](https://www.vagrantup.com/vmware/) and Vmware Fusion 8.5 on El Capitan (even though macOS Sierra just launched, I will wait at least 1 month before upgrading, there is nothing there that is worth the risk).

If you're installing a brand new box for the first time, this is the bare-bone `Vagrantfile` configuration I am using:

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

I usually go in the Vmware settings for the virtual machine and enable an extra processor (as my Macbook has 8 virtual cores to share) and enable hypervisor (support for Intel's VT-x/EPT).

As a rule of thumb, the very first thing I always do is set the locale to en_US.UTF-8:

```
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
```

And just to make sure, add the following to `/etc/environment`:

```
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
```

You must set UTF-8 before you install packages such as Postgresql.

Then I upgrade packages and install the basic:

```
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install open-vm-tools build-essential libssl-dev exuberant-ctags ncurses-term ack-grep silversearcher-ag fontconfig imagemagick libmagickwand-dev python-software-properties redis-server libhiredis-dev memcached libmemcached-dev
```

This will install important tools such as Imagemagick, Memcached and Redis for us.

Now, to [install Postgresql](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04):

```
sudo apt-get install postgresql-9.5 postgresql-contrib postgresql-server-dev-9.5
```

Create the superuser for vagrant:

```
sudo -i -u postgres
createuser --interactive

Enter name of role to add: vagrant
Shall the new role be a superuser? (y/n) y
```

And **only for the development environment** edit `/etc/postgresql/9.5/main/pg_hba.conf` and change the following:

```
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
```

This is to make your life easier while programming. If you did everything right until now, you will have your PG with proper unicode encoding and without bothering with password when you do `bin/rails db:create`. If you didn't configure your locale properly before, you can follow [this gist](https://gist.github.com/turboladen/6790847) to manually set PG's locale to UTF-8.

Installing [Ruby](https://rvm.io/rvm/install) is still better done through RVM:

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash
source $HOME/.rvm/scripts/rvm
rvm install 2.3.1
rvm use 2.3.1 --default
```

And I prefer using [YADR](https://github.com/skwp/dotfiles) as my default dotfiles, replacing Bash for ZSH. And comparing to other dotfiles, I like this one because I usually don't have to tweak it, at all. I won't even configure anything about RVM after installing because YADR takes care of that already.

```
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh `"
```

To update it (or resume in case it breaks for some reason):

```
cd .yadr
rake update
```

The only 2 tweaks I have to do is change my [iTerm2](https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized) profile to use [Solarized](http://ethanschoonover.com/solarized), and I have to add the following 2 lines to the top of the `.vimrc` file:

```
scriptencoding utf-8
set encoding=utf-8
```

Next step, [install NodeJS](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04):

```
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs
```

Next step, [install Java](https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04). You can choose Oracle's installer, but I believe the openjdk should be enough:

```
sudo apt-get install default-jdk
```

We will need Java for [Elasticsearch](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-16-04) 2.4.0:

```
wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.4.0/elasticsearch-2.4.0.deb && sudo dpkg -i elasticsearch-2.4.0.deb
```

Now you can start it manually with `sudo /etc/init.d/elasticsearch start`, and you want to leave it that way because it consumes a lot of RAM, so you should only start it when you really need it.

With Java in place, we can also install [Leiningen](http://leiningen.org/) to have Clojure ready.

```
echo "PATH=$PATH:~/bin" >> ~/.zsh.after/bin.zsh
mkdir ~/bin && cd ~/bin
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod a+x lein
lein
```

Leiningen will install it's dependencies and you can follow its [tutorial](https://github.com/technomancy/leiningen/blob/stable/doc/TUTORIAL.md) to get started.

Installing [Rust](https://www.rust-lang.org/en-US/downloads.html) is as easy:

```
curl -sSf https://static.rust-lang.org/rustup.sh | sh
```

Installing [Crystal](https://crystal-lang.org/docs/installation/on_debian_and_ubuntu.html), also easy:

```
curl https://dist.crystal-lang.org/apt/setup.sh | sudo bash
sudo apt-get install crystal
```

Installing [Go](https://www.digitalocean.com/community/tutorials/how-to-install-go-1-6-on-ubuntu-16-04) is not difficult, but more manual:

```
wget https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz
tar xvfz go1.7.1.linux-amd64.tar.gz
chown -R root:root .go
sudo mv go /usr/local
touch ~/.zsh.after/go.zsh
echo "export GOPATH=$HOME/go" >> ~/.zsh.after/go.zsh
echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> ~/.zsh.after/go.zsh
```

Once you install go and set it's work path, we can install some useful tools such as [forego](https://github.com/ddollar/forego) and [goon](https://github.com/alco/goon#goon) (that Elixir's Hex can optionally use):

```
go get -u github.com/ddollar/forego
go get -u github.com/alco/goon
```

And speaking of [Elixir](http://elixir-lang.org/install.html), we saved the best for last:

```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang elixir
```

And this is it, a very straightforward tutorial to have a modern development environment ready to go. These are the basic software development tools that I believe should be in everybody's toolbelts for the following years.

Honestly, I am not so much into Clojure and Go as I think I should. And I didn't give .NET Core a lot of time yet, but I will explore those in more detail in the future.
