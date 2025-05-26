---
title: "[Small Bites] Vagrant + Ubuntu 14.04 + Chef Solo"
date: '2014-07-28T20:22:00-03:00'
slug: small-bites-vagrant-ubuntu-14-04-chef-solo
tags:
- learning
- beginner
- linux
draft: false
---

Este post é dedicado a quem utilizar Mac OS X (ou mesmo Windows) como sistema de desenvolvimento. Para quem usa uma distro Linux, adapte para usar o [plugin de LXC](https://github.com/fgrehm/vagrant-lxc) do Vagrant.

A versão TL;DR é muito simples. Baixe e instale o [VirtualBox](https://www.virtualbox.org/wiki/Downloads) e o [Vagrant](http://www.vagrantup.com/downloads.html). Assumindo que está no OS X (já tem Ruby 2.0.0 pré-instalado), faça o seguinte do Terminal:

---
sudo gem install berkshelf
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-omnibus

mkdir ~/Vagrant
cd ~/Vagrant
git clone https://github.com/akitaonrails/vagrant-railsbox.git railsbox
cd railsbox

export VAGRANT_SYNCED_FOLDER=~/Sites

berks install
vagrant up --provision
---

Note que o <tt>Vagrantfile</tt> vai buscar a variável de ambiente <tt>VAGRANT_SYNCED_FOLDER</tt>, não esqueça de colocar no seu <tt>.zshrc</tt> ou <tt>.bashrc</tt> apontando para o diretório onde você costuma clonar seus projetos. Ele será montado, [via NFS](https://docs.vagrantup.com/v2/synced-folders/nfs.html), dentro do box Vagrant no diretório <tt>/vagrant</tt>.

Pronto, isso deve ser suficiente. Ao final você terá um ambiente de desenvolvimento com os seguintes componentes principais:

* RVM (receita 'user_install', onde você mesmo deve instalar os rubies que precisar manualmente)
* Oh-My-Zsh (isso não seria necessário, mas ZSH é tão bom que é melhor já ter pré-instalado)
* MySQL
* Postgresql
* MongoDB
* Redis 2
* Elasticsearch
* Node.js, Java 1.7, Git, Imagemagick

Acesse seu novo box com <tt>vagrant ssh</tt>, instale seu primeiro Ruby com <tt>rvm install ruby-2.1.2</tt> e pronto!

## Alguns Conceitos de Vagrant e Chef

Meu projetinho [vagrant-railsbox](https://github.com/akitaonrails/vagrant-railsbox) por si só é estruturado como uma receita Chef. Ele tem um <tt>metadata.rb</tt> que funciona mais ou menos como uma "gemspec", se fosse uma Rubygem.

Para gerenciar as dependências, uso o [Berkshelf](http://berkshelf.com/), que funciona como se fosse um Bundler. Ao rodar <tt>berks install</tt> ele vai usar o arquivo <tt>Berksfile.lock</tt> (novamente, similar ao "Gemfile.lock" dos seus projetos Ruby). O arquivo <tt>Berksfile</tt> tem as definições de versão ou fonte, e no caso desta receita, puxa as dependências do <tt>metadata.rb</tt>. Leia mais sobre como usar [Berkshelf com Vagrant neste post](http://misheska.com/blog/2013/06/16/getting-started-writing-chef-cookbooks-the-berkshelf-way/).

O arquivo <tt>Vagrantfile</tt> tem as configurações da receita. Na teoria eu deveria colocar as configurações que você encontra no bloco <tt>config.vm.provision :chef_solo</tt> no diretório <tt>attributes</tt>, que toda receita Chef tem, mas neste caso, como é muito específico ao Vagrant, deixei lá mesmo.

Note que estou usando um IP interno fixo com <tt>config.vm.network :private_network, ip: "192.168.50.4"</tt> em vez de usar a configuração com DHCP que seria <tt>, type: 'dhcp'</tt>, porque acho que no VMWare Fusion (que eu uso) estava dando problema. Tente usar DHCP e veja se no seu caso funciona, senão mantenha fixo.

Como é máquina de desenvolvimento, a senha do usuário 'root' do MySQL é simplesmente 'root'. E a senha do usuário 'postgres' é simplesmente 'postgres', além de estar tudo como 'trust' no arquivo <tt>pg_hba.conf</tt>. Obviamente, estas configurações não devem ser mantidas assim se for subir em produção. Redis, Mongo e Elasticsearch, está tudo na configuração padrão e tudo sem proteção.

Para quem nunca usou Chef, o conceito é simples:

* procure por receitas no [Chef Supermarket](http://supermarket.getchef.com/)
* adicione no seu <tt>metadata.rb</tt> como <tt>depends 'git'</tt>
* adicione no seu <tt>recipes/default.rb</tt> como <tt>include_recipe 'git'</tt> ou o que a documentação da receita mandar
* configure o <tt>node['git']</tt> no <tt>attributes/default.rb</tt> (ou, neste exemplo, no <tt>Vagrantfile</tt>), conforme a documentação

A receita é onde fica os comandos para instalar e configurar o que você precisa. Atributos são os valores customizáveis que variam de instalação para instalação. No diretório <tt>files</tt> costuma ficar templates ERB para arquivos de configuração, do tipo que você editaria em <tt>/etc</tt>. Em <tt>libraries</tt> ficam classes Ruby que organizam lógicas mais complexas que você quer estruturar para reusar.

Resources e Providers são conceitos mais complicados de explicar, e como a idéia deste post não é detalhar Chef, vamos apenas resumir dizendo que resources definem o estado de um sistema. Por exemplo, num cookbook de NGINX teríamos o pacote de instalação, o serviço e o arquivo de configuração. Providers são as ações que levam o sistema ao estado definido, como instalar o pacote propriamente dito, editar o arquivo de configuração e configurar o serviço. Se quiser saber mais sobre o assunto, [leia este post](http://neethack.com/2013/10/understand-chef-lwrp-heavy-version/) e [este outro](http://tech.yipit.com/2013/05/09/advanced-chef-writing-heavy-weight-resource-providers-hwrp/).

A grande vantagem é você poder modificar este cookbook e incrementalmente instalar coisas novas no seu box com o comando <tt>vagrant provision</tt>. E também poder simplesmente recomeçar do zero, destruindo seu box com <tt>vagrant destroy</tt> e reiniciando com <tt>vagrant up --provision</tt> e chegar na mesma configuração final. É sempre bom pode começar do zero sem dores de cabeça.

Sobre montar seu próprio cookbook, a parte mais complicada é buscar os cookbooks que já existem, entender como eles funcionam, e isso requer ler as receitas, ler a documentação, entender dependências como ver que o oh-my-zsh depende o data_bag do cookbook 'user', por exemplo. Antes de sair montando tudo do zero, procure no supermarket e, obviamente, no Google, para buscar direto no Github.

Alguém tem mais dicas para melhorar este cookbook? Não deixe de comentar aqui ou mesmo mandar um Pull Request pra mim!
