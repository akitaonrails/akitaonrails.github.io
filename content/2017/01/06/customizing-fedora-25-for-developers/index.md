---
title: Customizando o Fedora 25 para Desenvolvedores
date: '2017-01-06T17:11:00-02:00'
slug: customizando-o-fedora-25-para-desenvolvedores
translationKey: customizing-fedora-25
aliases:
- /2017/01/06/customizing-fedora-25-for-developers/
tags:
- linux
- fedora
- traduzido
draft: false
---

**Atualização 18/01/2017:** Logo depois de experimentar o Fedora por alguns dias, resolvi [testar o Arch Linux](http://www.akitaonrails.com/2017/01/10/arch-linux-a-melhor-distro-de-todas) e não me arrependi nem um pouco. Recomendo que você também experimente, provavelmente vai te surpreender. Pode se interessar também pelo post sobre [tuning avançado de Linux para melhor responsividade](http://www.akitaonrails.com/2017/01/17/otimizando-o-linux-para-computadores-lentos) no desktop.

Sou usuário de Ubuntu há muito tempo. Sempre que preciso configurar uma máquina Linux, vou direto para a última LTS. É memória muscular, não tem jeito.

Mas para substituir o macOS, Unity é feio demais, sendo honesto. Tentei customizar o Cinnamon e quase gostei, e nem me fale de KDE ou XFCE.

O [GNOME 3.22](https://www.gnome.org/news/2016/09/gnome-3-22-released-the-future-is-now/), por outro lado, é muito bem feito. Não preciso fuçar nada para deixar com boa aparência. O conjunto padrão de atalhos globais é exatamente o que um usuário antigo de macOS espera. Gosto de quase tudo nele.

Estava curioso com toda a movimentação em torno da transição do X.org para o Wayland e queria ver como estava.

A melhor distro que encontrei para isso é o bom e velho Fedora. RedHat (4) foi a segunda distro Linux que experimentei, logo depois do Slackware 1 lá em meados dos anos 90. Volto e saio de tempos em tempos. É uma boa hora de tentar de novo.

O resumo é que estou bem satisfeito com o [Fedora 25](https://getfedora.org/en/workstation/download/). Ele faz praticamente tudo que preciso já de cara, sem configuração adicional.

![Fedora 25](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/578/big_Screenshot_from_2017-01-06_16-58-17.png)

Tirei da gaveta um desktop Lenovo ThinkCentre Edge 71z de 4 anos de idade e um notebook Lenovo IdeaPad G400s. São, respectivamente, um Core i5 SandyBridge de 2ª geração a 2,5GHz e um Core i3 a 2,4GHz, com 8GB de RAM no desktop e 4GB no notebook. Para a rotina de um desenvolvedor, são mais que suficientes. Um CPU mais potente não faria grande diferença.

Fiquei feliz ao ver que o desktop velho tem uma placa Intel antiga com saída DVI. Por sorte tinha um cabo DVI-to-HDMI por aí e consegui conectar ao meu monitor ultrawide LG 21:9 (2560x1080), que escalou tudo corretamente (o macOS Sierra tinha uma regressão que precisava de hack para funcionar!).

O que pesa mesmo são os HDs mecânicos super lentos (7200rpm e 5400rpm). Já pedi upgrade de RAM e 2 SSDs Crucial MX300 compatíveis. Quando chegarem, vou ter a agilidade que preciso.

Dito isso, o que fazer depois de uma instalação zerada do Fedora 25?

### Para usuários de Ubuntu

Lembre disso: em vez de `apt-get`, você usa `dnf`. O Fedora antes da versão 22 usava `yum`, mas o `dnf` o substitui com basicamente as mesmas opções de comando.

Não existe equivalente ao `apt-get update` porque ele atualiza automaticamente. O resto é bem parecido: `dnf install pacote` em vez de `apt-get install pacote`, `dnf search pacote` em vez de `apt-cache search pacote`, e assim por diante. Para um upgrade global, use `dnf upgrade` em vez de `apt-get update && apt-get upgrade`.

Para serviços, em vez de `sudo service restart memcached`, use `sudo systemctl restart memcached`.

É basicamente isso. Leia essa [página da wiki](https://fedoraproject.org/wiki/Differences_to_Ubuntu) para mais diferenças de comandos.

### Suporte à linguagem Crystal

Digamos que você queira aprender essa linguagem nova chamada "Crystal": sintaxe e bibliotecas padrão familiares ao Ruby, mas com geração de binários nativos como no Go, primitivas de concorrência rápidas e todos os benefícios de um binário otimizado pelo LLVM.

Siga a [wiki deles](https://crystal-lang.org/docs/installation/on_redhat_and_centos.html) e também essa [página](https://github.com/crystal-lang/crystal/wiki/All-required-libraries#fedora), mas basicamente é isso:

```
sudo dnf -y install \
  gmp-devel \
  libbsd-devel \
  libedit-devel \
  libevent-devel \
  libxml2-devel \
  libyaml-devel \
  llvm-static \
  openssl-devel \
  readline-devel

sudo dnf -y install fedora-repos-rawhide
sudo dnf -y install gc gc-devel # get all dependencies from Fedora 25
sudo dnf -y install gc gc-devel --enablerepo=rawhide --best --allowerasing

sudo dnf -y install crystal
```

É isso, muitas dependências, mas como ainda é pré-1.0 acredito que vão melhorar isso no futuro.

### Suporte a Ruby e Node.js

Rubyistas têm várias opções de gerenciador de versões, mas eu prefiro RVM. Primeiro, precisamos instalar alguns [pré-requisitos](http://www.socialquesting.com/blog/octopress-installation-fedora-25/):

```
sudo dnf -y install patch autoconf gcc-c++ patch libffi-devel automake libtool bison sqlite-devel ImageMagick-devel nodejs git gitg
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import
curl -L https://get.rvm.io | bash -s stable --ruby

sudo npm -g install brunch phantomjs
```

Pronto, você terá o Ruby estável mais recente, Node, Npm e ferramentas úteis como Brunch (necessário para projetos Elixir-Phoenix) e PhantomJS para testes de aceitação automatizados em várias linguagens.

Note que já estamos instalando o Git e o opcional [GitG](https://git.gnome.org//browse/gitg), um companheiro fantástico para a sua rotina com Git.

![GitG](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/583/big_Screenshot_from_2017-01-06_16-59-05.png)

### Suporte a Postgresql, Redis, Memcached

O que é uma aplicação web sem banco de dados e serviços de cache? Vamos instalá-los:

```
sudo dnf -y install postgresql-server postgresql-contrib postgresql-devel memcached redis

sudo postgresql-setup --initdb
sudo sed -i.bak 's/ident/trust/' /var/lib/pgsql/data/pg_hba.conf # NUNCA faça isso em servidores de produção
sudo systemctl start postgresql

sudo su - postgres
createuser youruser -p
createdb youruser --owner=youruser
```

Substitua `youruser` pelo nome do seu usuário atual, claro.

### Suporte a Java

Fácil, basta instalar o [OpenJDK 8](http://www.2daygeek.com/install-java-openjdk-6-7-8-on-ubuntu-centos-debian-fedora-mint-rhel-opensuse-manjaro-archlinux/#) mais recente e os plugins para o navegador:

```
sudo dnf -y install java-1.8.0-openjdk icedtea-web
```

### Suporte a Go

Ainda mais simples:

```
sudo dnf -y install go
```

Não esqueça de editar seu perfil, como `$HOME/.profile`, e adicionar as variáveis de ambiente necessárias:

```
export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin
```

### Suporte a Elixir

Tem o jeito fácil e um mais complicado e demorado. Vamos começar com [o fácil](http://elixir-lang.org/install.html#unix-and-unix-like):

```
sudo dnf -y install erlang elixir
mix local.hex
mix local.rebar
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
```

O problema é que os pacotes para distros como Fedora demoram para ser atualizados. Por exemplo, o Elixir 1.4 foi lançado há alguns dias, mas ainda não há atualização para o Fedora.

Outro problema, se você desenvolve Elixir profissionalmente, é que vai precisar de um gerenciador de versões, porque vai acabar pegando projetos de clientes em versões diferentes e precisa configurar o ambiente adequadamente. É aí que entra o [asdf](https://github.com/asdf-vm/asdf). Você pode seguir [este gist](https://gist.github.com/rubencaro/6a28138a40e629b06470), mas vou colar os pontos importantes aqui:

```
sudo dnf -y install make automake gcc gcc-c++ kernel-devel git wget openssl-devel ncurses-devel wxBase3 wxGTK3-devel m4

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.2.1

# Para Ubuntu ou outras distros Linux
echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

# reinicie o terminal ou faça source do arquivo acima:
source ~/.bashrc

asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

asdf install erlang 19.0
asdf install elixir 1.4.0

asdf global erlang 19.0
asdf global elixir 1.4.0
```

Compilar o Erlang a partir do código-fonte demora uma eternidade, especialmente com CPUs velhos como os meus. Mas é assim que você tem acesso ao Elixir mais recente e, ao mesmo tempo, a capacidade de usar versões antigas para projetos de clientes.

Por sinal, você pode instalar plugins adicionais do asdf para gerenciar outras plataformas como Go, Rust, Node, Julia e muitas outras. Veja a [página do projeto](https://github.com/asdf-vm/asdf) para mais detalhes.

### Suporte a Docker

Provavelmente você vai querer Docker também, então [vamos lá](https://docs.docker.com/engine/installation/linux/fedora/):

```
sudo dnf -y install docker docker-compose

# você pode testar se funcionou com o famoso hello world
sudo docker run --rm hello-world
```

## Aplicativos de Desktop

Com tudo instalado, vamos configurar os aspectos não-terminais para uma experiência melhor.

### Terminator (e Terminix)

![Terminator](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/579/Screenshot_from_2017-01-06_16-59-53.png)

Falando em terminais, você vai querer instalar o [Terminator](https://gnometerminator.blogspot.com.br/p/introduction.html). Não gosto de usar screen ou tmux na minha máquina local (não consigo me acostumar com os atalhos). Estou mais habituado ao iTerm2 do macOS, e o Terminator é praticamente a mesma coisa com atalhos similares. Você definitivamente precisa substituir o terminal padrão por ele.

```
sudo dnf -y install terminator
```

Você também vai querer editar `~/.config/terminator/config` e adicionar o seguinte para melhorar a configuração:

```
[global_config]
  title_transmit_bg_color = "#d30102"
  focus = system
[keybindings]
[layouts]
  [[default]]
    [[[child1]]]
      parent = window0
      type = Terminal
      profile = default
    [[[window0]]]
      parent = ""
      type = Window
[plugins]
[profiles]
  [[default]]
    use_system_font = false
    font = Hack 12
    scrollback_lines = 2000
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#586e75:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    foreground_color = "#eee8d5"
    background_color = "#002b36"
    cursor_color = "#eee8d5"
```

Outra ótima opção que me recomendaram é o [Terminix](https://copr.fedorainfracloud.org/coprs/heikoada/terminix/). Para instalar:

```
sudo dnf copr enable heikoada/terminix
sudo dnf -y install terminix
```

### Fonte Hack

Você vai querer uma fonte melhor, como [Hack](https://github.com/chrissimpkins/Hack):

```
dnf -y install dnf-plugins-core
dnf copr enable heliocastro/hack-fonts
dnf -y install hack-fonts
```


### Gnome Tweak Tool

Instale o **Gnome Tweak Tool** para poder definir a Hack como fonte monoespaçada padrão:

```
sudo dnf -y install gnome-tweak-tool
```

### Vim, Zsh, Yadr

![Vim gruvbox](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/582/big_Screenshot_from_2017-01-06_16-59-36.png)

Gosto muito de usar Vim, então instale assim:

```
sudo dnf -y install vim-enhanced vim-X11
```

E gosto de usar o [YADR](https://github.com/Codeminer42/dotfiles) para customizar todos os aspectos do meu ZSH e Vim:

```
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh `"
```

Recomendo ter Zsh, Vim e Ruby instalados antes de rodar o script acima. Depois de concluir, tive que ajustar as configurações um pouco:

```
sed 's/gtk2/gtk3' ~/.vim/settings/yadr-appearance.vim
```

Você vai querer ajustar esse arquivo também, para adicionar novas fontes como Hack. Atualmente estou mais no mood "gruvbox" do que "solarized" como tema do Vim.

### GIMP Photoshop

![Gimp with Photoshop Theme](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/580/big_Screenshot_from_2017-01-06_17-07-14.png)

Se você é desenvolvedor web, vai precisar editar algumas imagens de vez em quando. E se for como eu, o Gimp é um pesadelo de usabilidade. Mas [existem maneiras](http://www.omgubuntu.co.uk/2016/08/make-gimp-look-like-photoshop-easy) de torná-lo um [pouco mais palatável](https://github.com/doctormo/GimpPs).

```
sudo dnf -y install gimp
sh -c "$(curl -fsSL https://raw.githubusercontent.com/doctormo/GimpPs/master/tools/install.sh)"
```

Pronto, um tema parecido com Photoshop para o Gimp deixar menos feio.

### Spotify

O que seria de nós, desenvolvedores, sem música para concentrar?

```
dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
dnf -y install spotify-client
```

### CoreBird

![CoreBird](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/581/big_Screenshot_from_2017-01-06_17-08-43.png)

Fico feliz que alguém construiu um cliente de Twitter muito competente e elegante para Linux. Instale o CoreBird:

```
dnf -y install corebird
```

Provavelmente é até melhor que a versão oficial para Mac.

### Ajustando a barra de título

Encontrei [esse hack](http://blog.samalik.com/make-your-gnome-title-bars-smaller/) para deixar as barras de título do Gnome um pouco menos gordas, que é praticamente a única reclamação que tenho sobre o visual até agora:

```
tee ~/.config/gtk-3.0/gtk.css <<-EOF
.header-bar.default-decoration {
 padding-top: 3px;
 padding-bottom: 3px;
 font-size: 0.8em;
}

.header-bar.default-decoration .button.titlebutton {
 padding: 0px;
}
EOF
```

### Conclusão

A maioria das coisas que você precisa é web, então Gmail, Slack, tudo funciona bem. Abra o Chromium, Firefox ou instale o [Franz](http://meetfranz.com/) ou [WMail](http://thomas101.github.io/wmail/) se precisar. Infelizmente tudo que é web consome muita RAM, o que é um problema sério. Sinto falta dos bons e velhos aplicativos nativos, leves e rápidos. Aplicativos web são um porre.

Eles "funcionam", mas prefiro um bom aplicativo nativo. Por outro lado, Dropbox e Skype têm clientes terríveis. São muito mal mantidos, cheios de bugs e com suporte péssimo. Prefiro não usá-los.

Estava tentando me acostumar com o Thunderbird no Ubuntu. O Geary ainda não é bom o suficiente. Mas fiquei surpreso ao tentar o Evolution de novo. Ele tem a única coisa que realmente quero de qualquer cliente de email: um atalho para mover emails para pastas: Ctrl-Shift-V (!!) Será que é tão difícil assim??

O Gnome 3 tem um repositório global de Contas Online nas Configurações onde você pode cadastrar redes sociais como Facebook e Google, mas o suporte ao Google está [bugado](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=820913). Expira toda hora, então não use o Evolution com ele. Adicione as informações de Imap/Smtp manualmente. Email e dados do Calendar sincronizam corretamente dessa forma.

Você já deve ter todas as suas senhas em uma conta LastPass. O Authy é uma extensão do Chrome, então sua autenticação de múltiplos fatores também deve funcionar.

Meu banco e corretoras, com seus feios applets Java, funcionam bem com Chromium e IcedTea, então estou ok por aí.

Só preciso descobrir a estratégia de backup mais fácil para ter tudo realmente seguro. Na instalação, não esqueça de escolher a opção de partição criptografada - e se fizer isso, faça backup dos dados regularmente, pois ouvi relatos de bugs em upgrades que tornaram as partições criptografadas inacessíveis. Seja seguro e cuidadoso.

Como sempre, do macOS as únicas 2 coisas que vou realmente sentir falta são o Apple Keynote (é incrível, ninguém conseguiu fazer uma ferramenta de apresentação tão elegante e rápida) e o iMovie para edição rápida de vídeo (embora o [Kdenlive](https://kdenlive.org/) seja uma alternativa bem boa).

Você ainda tem [atalhos](https://wiki.gnome.org/Gnome3CheatSheet) embutidos para capturar uma janela ou área e [gravar um screencast](https://fedoramagazine.org/taking-screencast-fedora/)!

Comparado à minha configuração no Ubuntu, esse Fedora 25 é realmente um prazer de usar. Uma boa alternativa ao macOS. Recomendo!

E como disse na atualização no início do post: dê uma olhada no [Arch Linux](http://www.akitaonrails.com/2017/01/10/arch-linux-a-melhor-distro-de-todas) e em como [otimizar sua distro para ser mais responsiva](http://www.akitaonrails.com/2017/01/17/otimizando-o-linux-para-computadores-lentos), especialmente em hardware antigo.
