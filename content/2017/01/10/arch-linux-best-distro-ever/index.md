---
title: "Arch Linux: A Melhor Distro de Todas"
date: '2017-01-10T14:25:00-02:00'
slug: arch-linux-a-melhor-distro-de-todas
translationKey: arch-linux-best-distro
aliases:
- /2017/01/10/arch-linux-best-distro-ever/
tags:
- linux
- archlinux
- pacman
- pacaur
- asdf
- traduzido
draft: false
---

**Atualização 18/01/2017:** Se você está num hardware antigo como o meu, talvez queira otimizar a instalação para ter muito mais responsividade. [Leia tudo sobre isso aqui](http://www.akitaonrails.com/2017/01/17/otimizando-o-linux-para-computadores-lentos).

Quando decidi voltar do macOS para o Linux, não queria simplesmente retornar ao velho Ubuntu (sim, fico entediado fazendo as mesmas coisas por tempo demais). Então experimentei o Fedora 25 e fiquei impressionado com a evolução do Gnome 3.22.

Comparado ao Ubuntu, os padrões do Fedora pareciam melhores. Na prática, dá para forçar qualquer distro a ser o que você quiser, mas prefiro não brigar com os padrões. O Ubuntu é fortemente customizado para o Unity e eu realmente, realmente não gosto. Parece mais um brinquedo do que um ambiente sério para trabalhar.

O Fedora 25 fica bonito com o Gnome 3, mas ainda me deu algumas dores de cabeça. Uma coisa que não funcionou de jeito nenhum foi o [Gnome Online Accounts](https://wiki.gnome.org/Projects/GnomeOnlineAccounts). O GOA coleta tokens de autenticação depois que você faz login nos seus serviços sociais como o Google. Aí aplicativos compatíveis como Evolution e o Calendário integrado conseguem usá-los. Mas os tokens expiravam o tempo todo, então a integração era inútil. E configurar o Evolution manualmente para o Google não é nada agradável.

![Arch Linux](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/584/Screenshot_from_2017-01-10_14-15-41.png)

A surpresa: no Arch Linux, escolhi o Gnome 3.22 como desktop e instalei manualmente o pacote [gnome-online-accounts](https://www.archlinux.org/packages/extra/i686/gnome-online-accounts/). Fiz login nas minhas contas Google e posso afirmar com satisfação que os tokens não expiram e tudo "simplesmente funciona"! É esse tipo de polimento que espero de uma distro grande, não a roubada que o Fedora rotula como "estável".

### Por que Arch Linux?

A maioria das distros importantes se divide entre "estável" (mas com pacotes muito antigos) e "instável" (mas com o que há de mais recente). Se você instala as versões Long-Term Support (LTS), está condenado a ter só pacotes velhos de alguns anos atrás. Se instala os repositórios instáveis, está condenado a ter coisas explodindo na sua cara sem explicação e perdendo horas garimpando no Stackoverflow.

O Arch parece ter encontrado o nível exato de equilíbrio entre estável e cutting-edge. Ele continua empurrando as versões mais recentes dos softwares sem quebrar tudo o mais o tempo todo. No Ubuntu 16.04 e no Fedora 25, se eu quero instalar o Postgresql, fico preso no 9.4 ou 9.5, mas no Arch consigo acessar o 9.6 direto dos repositórios principais do Pacman. (A propósito, "Pac"kage "Man"ager é o nome mais óbvio possível.)

É só fazer `pacman -Sy postgresql` e pronto.

E se você está no Ubuntu 14.04 e agora quer o 16.04, boa sorte fazendo `dist-upgrade`. É mais fácil começar do zero.

A filosofia do Arch parece ser ter a versão mais recente de verdade de todo software sem quebrar o sistema. Não existe aquele upgrade big bang a cada 6 meses que quebra tudo. Em vez disso, você tem um sistema de upgrade **rolling** constante, sempre na última versão, sem precisar esperar mais um ano pelo próximo LTS grande.

Toda distro grande tem repositórios "não suportados" para binários proprietários (codecs, por exemplo) ou software de terceiros. No Arch existe o Arch User Repository (AUR): uma coleção de pequenos repositórios Git de usuários que mantêm simples arquivos de texto `PKGBUILD`.

O AUR é inteligente. Se você vem do macOS e conhece o Homebrew, vai entender na hora: parece Casks e Formulas. Um arquivo `PKGBUILD` pode descrever uma receita para baixar um pacote DEB ou tarball disponível, desmontá-lo e reconstruí-lo como um pacote compatível com o Pacman. Ele pode descrever as dependências necessárias e tornar o processo de instalação extremamente tranquilo.

Por exemplo, o Sublime Text só tem a opção de baixar um pacote DEB ou um tarball com os binários. O mesmo vale para Spotify, Franz, etc. Às vezes dá para registrar Personal Package Archives (PPAs) e instalar via `apt-get`. Mas você ainda precisa que alguém construa, mantenha e distribua esses pacotes direito. Dá muito trabalho.

Manter um repositório Git simples com um arquivo PKGBUILD simples é muito mais fácil. O `makepkg` faz o trabalho pesado de construir o pacote que você precisa, na sua máquina, e então o `pacman` cuida de instalá-lo como qualquer outro pacote. Chega de ficar baixando tarballs com `wget` e configurando tudo na mão!

Talvez eu finalmente consiga só fazer `pacman -Syu` e ter tudo "de verdade" atualizado sem precisar me preocupar com o próximo LTS grande que eventualmente vai me forçar a reinstalar tudo do zero.

### Arch Linux é perfeito para "Iniciantes"

Faz um bom tempo que ouço falar do Arch e seus usuários são muito entusiastas em tentar convencer outras pessoas a aderir. Quando você vê uma base de fãs tão leal assim, alguma coisa interessante deve estar escondida por baixo. Upgrades rolling, Pacman, AUR são razões realmente valiosas.

Depois de apenas um dia usando, percebi que o Arch é bom para usuários avançados, mas também para **iniciantes**. Não porque é fácil. Pelo contrário: porque é difícil do jeito certo.

A maioria dos "usuários Linux" hoje em dia só pega uma distro trivial de instalar, como Ubuntu ou Elementary, e não faz ideia do que acontece por baixo. Ficam clicando cegamente em "próximo" nos instaladores gráficos.

A maioria das pessoas não sabe o que são TTYs. Que você pode sondar dispositivos USB com ferramentas de linha de comando como `lsusb`, ou que precisa usar ferramentas como `fdisk` para particionar e depois `mkfs.ext4` para formatar. Que arquivos de swap de memória são partições com um formato especial. Não conhecem as opções de LVM para particionamento flexível, nem que o LVM existe. Que o "negócio" que você escolhe o kernel no menu de boot se chama Grub e que dá para tunear.

Montar uma distribuição Linux completamente funcional tem muito envolvido. Mas os instaladores gráficos escondem a maior parte. O Arch Linux te força a ir passo a passo e realmente sentir que você é dono da sua máquina, e não o contrário.

Se você é um "iniciante", eu realmente te encorajo a instalar uma distro como o Arch algumas vezes, em diferentes configurações de máquinas, para entender de verdade como um sistema operacional funciona.

A [Arch Wiki](https://wiki.archlinux.org/) é um repositório de informações muito abrangente e detalhado sobre tudo que você precisa saber para instalar e manter cada componente de um sistema Linux adequado. Você vai aprender muito no processo.

Mas se você é como eu, e passou por tudo isso em meados dos anos 90 e início dos 2000 (puxa, eu tive que aprender Slackware 1.0 na marra, ainda me lembro de usar disquetes de boot e root e estragar meus HDs sem entender cilindros e setores no fdisk), pode pular essa parte. Para você, usuário avançado/experiente, eu recomendo o [Arch Linux Anywhere](https://arch-anywhere.org/).

![Arch Anywhere](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/586/big_20170109_150742.jpg)

Ele instala o Arch de forma customizada mas com automação suficiente para não desperdiçar muito tempo em ter uma instalação Arch devidamente configurada e funcionando, sem bloatware.

### Pacaur - a melhor forma de lidar com o AUR

Os usuários de Arch são rápidos em elogiar o Pacman. Na maior parte do tempo, você basicamente faz:

```
sudo pacman -S chromium
```

E é isso. Depois pode fazer `sudo pacman -Syu` para atualizar os pacotes instalados. Esse é o básico que você precisa saber.

Se você é desenvolvedor, recomendo instalar também os pacotes de desenvolvimento básicos:

```
sudo pacman -Sy --needed base-devel
```

Você pode instalar pacotes do AUR manualmente. Pode ir ao site deles e [buscar por "terminix"](https://aur.archlinux.org/packages/?O=0&K=terminix) (um substituto bem interessante para o Terminal, parecido com o iTerm2 do Mac), por exemplo. Vai chegar a [esta página](https://aur.archlinux.org/packages/terminix/) e precisará fazer manualmente o seguinte:

```
git clone https://github.com/gnunn1/terminix.git
cd terminix
makepkg -si
```

Parece simples, mas dá para fazer melhor instalando o [Pacaur](https://github.com/rmarquis/pacaur), um wrapper em cima do Pacman. Se você estiver usando um terminal gráfico como Terminal ou Terminix, NÃO ESQUEÇA de editar o perfil para "Run command as login shell", caso contrário haverá um problema de PATH e o Cower vai falhar na instalação.

```
sudo pacman -S expac yajl --noconfirm
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
git clone https://aur.archlinux.org/cower.git
cd cower
makepkg -si
cd ..
git clone https://aur.archlinux.org/pacaur.git
cd pacaur
makepkg -si
cd ..
```

Em resumo, o Pacaur pode ser usado não só como complemento para instalar pacotes do AUR, mas também se você quiser usar uma única ferramenta para gerenciar tanto o AUR quanto os pacotes oficiais do Pacman. Todos os comandos `-S` são comandos do Pacman. Então em vez de fazer `sudo pacman -Syu` para atualizar todos os pacotes, você pode substituir por `pacaur -Syu`. Todo o resto basicamente "funciona".

Quando você tenta instalar um pacote com `-S`, ele primeiro procura nos repositórios oficiais; se não encontrar, tenta o AUR. Tem até uma GUI bem bacana se quiser:

```
pacaur -S pamac-pacaur
```

Para instalar o mesmo Terminix agora, basta fazer:

```
pacaur -Sy terminix
```

Ele vai fazer perguntas simples de sim/não como "Quer editar o arquivo de build?" Responda "n" para essas e confirme "y" quando perguntar se quer instalar as dependências ou o pacote gerado.

E é isso! Você pode buscar nos repositórios do AUR com:

```
pacaur -s spotify
```

Vai te dar várias opções, por exemplo:

```
$ pacaur -s spotify
aur/spotify 1.0.47.13-1 (1037, 36.09) [installed]
    A proprietary music streaming service
aur/playerctl 0.5.0-1 (127, 11.33)
    mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others.
aur/blockify 3.6.3-3 (106, 5.61)
    Mutes Spotify advertisements.
...
```

Bom senso, pessoal. Leia, interprete, escolha. O Arch exige que você seja uma pessoa **inteligente**, e por "inteligente" quero dizer: que sabe ler! A maioria das pessoas pula a leitura e fica clicando em tudo como idiota.

Agora que você sabe o nome exato do pacote que quer, instale normalmente assim:

```
pacaur -S spotify
```

![Pacaur](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/604/Screenshot_from_2017-01-16_14-21-49.png)

O Pacaur é um dos muitos [AUR Helpers](https://wiki.archlinux.org/index.php/AUR_helpers). Inicialmente fui atraído pelo Yaourt, mas depois de pesquisar, você percebe que deve experimentar apenas aurutils, bauerbill ou pacaur. Prefiro este último porque é mais fácil de falar.

```
pacaur -Syua
```

Isso mantém o seu sistema atualizado, tanto os pacotes oficiais quanto os do AUR.

### Asdf - o último gerenciador de versões de linguagens que você vai precisar

Se você é Rubyist, conhece RVM, rbenv, chruby. Se vem do Node.js, conhece o NVM inspirado no RVM para gerenciar diferentes versões do Node. Cada nova linguagem hoje em dia precisa de um gerenciador de versões porque evoluem rapidamente e porque se você trabalha com projetos de clientes vai eventualmente precisar usar uma versão antiga para lidar com software legado.

Então, mesmo que você possa instalar o Ruby 2.3.3 estável atual só fazendo `pacman -S ruby` ou `pacaur -S ruby`, vai eventualmente precisar voltar para Ruby 2.1 ou mais antigo para algum projeto de cliente.

Instala RVM? Ou rbenv? E como lidar com diferentes versões de Clojure, Go, Rust, Elixir?

Isso soa como mais um pesadelo de manutenção para encarar. Mas alguém decidiu resolver esse problema de forma elegante. Entra o [asdf](https://github.com/asdf-vm/asdf) - e se você por acaso conhecer [Akash Manohar](https://github.com/HashNuke), dê um abraço nele.

Vamos instalá-lo (do README do projeto):

```
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.2.1
```

Depois edite seus arquivos de configuração de shell:

```
# Para Ubuntu ou outras distros Linux
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

# OU para Mac OSX
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profile

# Para o Fish shell
echo 'source ~/.asdf/asdf.fish' >> ~/.config/fish/config.fish
mkdir -p ~/.config/fish/completions; and cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions

# Se, como eu, você gosta de ZSH com YADR (precisa instalar o YADR antes disso)
touch ~/.zsh.after/asdf.zsh
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zsh.after/asdf.zsh
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zsh.after/asdf.zsh
```

Essa ferramenta é bem auto-explicativa. Vamos começar instalando um monte de plugins (tabela completa de links no arquivo README):

```
asdf plugin-add clojure https://github.com/vic/asdf-clojure.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
```

Se você é como eu, deve estar **super animado** porque já sabe o que vamos fazer a seguir:

```
sudo pacman -Sy jdk8-openjdk # precisa de Java para Clojure

asdf install clojure 1.8.0
asdf global clojure 1.8.0
mkdir ~/bin
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -O ~/bin/lein
chmod +x ~/bin/lein
export PATH=$PATH:~/bin
# echo "PATH=$PATH" > ~/.zsh.after/binpath.zsh # se usar YADR+ZSH
lein

asdf install erlang 19.0
asdf global erlang 19.0

asdf install elixir 1.4.0
asdf global elixir 1.4.0
mix local.hex
mix local.rebar

asdf install golang 1.7.4
asdf global golang 1.7.4

asdf install ruby 2.4.0
asdf global ruby 2.4.0
gem install bundler

asdf install rust 1.14.0
asdf global rust 1.14.0

asdf install nodejs 7.4.0
asdf global nodejs 7.4.0
npm -g install brunch phantomjs
```

Pronto! Agora temos todas as linguagens que precisamos instaladas e prontas para uso! E se eu precisar do Ruby 2.3.1 para um projeto de cliente?

```
asdf install ruby 2.3.1
asdf local ruby 2.3.1
```

E agora tenho o 2.3.1 localmente (posso mudar para o padrão do sistema usando `global`).

A maior parte do esforço de manutenção se resume a isso:

```
asdf plugin-update --all # atualiza os plugins individuais
asdf list-all [linguagem] # lista todas as versões disponíveis
```

E é basicamente isso! Você tem quase tudo que precisa para desenvolver software.

### Software Útil para Instalar

Agora, como de costume, deixa eu recomendar alguns softwares:

```
# garanta que está atualizado
sudo pacman -Syu

# instale codecs multimídia
sudo pacman -Sy gstreamer0.10-plugins
sudo pacman -Sy exfat-utils fuse-exfat a52dec faac faad2 flac jasper lame libdca libdv gst-libav libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gstreamer0.10-plugins flashplugin libdvdcss libdvdread libdvdnav gecko-mediaplayer dvd+rw-tools dvdauthor dvgrab pulseaudio-equalizer-

# se precisar de fontes japonesas como eu
sudo pacman -Sy adobe-source-han-sans-otc-fonts otf-ipafont

# alguns componentes que você vai precisar
sudo pacman -Sy fuse-exfat 

# gosto do tema Numix e ícones Breeze, mude-os com o Tweak Tool
sudo pacman -Sy numix-themes breeze-icons 

# instale mais fontes com boa aparência
sudo pacman -Sy ttf-dejavu 
pacaur -S ttf-ms-fonts ttf-vista-fonts ttf-liberation adobe-source-sans-pro-fonts ttf-ubuntu-font-family

# Firefox e plugin Java
sudo pacman -Sy icedtea-web firefox

# para devs
sudo pacman -Sy zsh the_silver_searcher gvim imagemagick htop
pacaur -Sy ttf-hack

# Wrapper nativo para apps Web como Slack, Hangout, etc
pacaur -Sy franz-bin

# Melhor cliente nativo de Twitter para Linux
pacaur -Sy corebird

# Dispensa explicação
pacaur -Sy spotify
pacaur -Sy sublime-text-dev # instale estes plugins http://www.hongkiat.com/blog/sublime-text-plugins/

# Se você gosta de ler RSS
pacaur -Sy feedreader-beta

# se precisar de suporte tipo Office
sudo pacman -Sy libreoffice-fresh

# se precisar de suporte tipo Photoshop
sudo pacman -Sy gimp
sh -c "$(curl -fsSL https://raw.githubusercontent.com/doctormo/GimpPs/master/tools/install.sh)"

# se quiser um editor de vídeo realmente bom
sudo pacman -Sy frei0r-plugins dvdauthor vlc
pacaur -Sy kdenlive

# isso pode fazer softwares que consomem muito CPU se comportarem melhor e garantir melhor experiência de uso
pacaur -Sy ananicy-git

# dropbox é o software mais horrível do mundo, mas pode ser que você precise:
pacaur -Sy dropbox dropbox-cli nautilus-dropbox
```

Como sempre, gosto de substituir o Bash pelo Zsh e configurar o Vim com YADR:

```
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"
touch ~/.vimrc.before
touch ~/.vimrc.after
echo "let g:yadr_using_unsolarized_terminal = 1" >> ~/.vimrc.before
echo "let g:yadr_disable_solarized_enhancements = 1" >> ~/.vimrc.after
echo "colorscheme gruvbox" >> ~/.vimrc.after
```

Para instalar e configurar o Postgresql 9.6:

```
sudo pacman -Sy postgresql
sudo -u postgres -i
initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data'
exit

# não faça isso em máquinas de Produção
sudo sed -i.bak 's/ident/trust/' /var/lib/postgres/data/pg_hba.conf
sudo systemctl start postgresql
sudo systemctl enable postgresql

sudo -u postgres -i
createuser --interactive # crie com seu nome de usuário e papel de superuser
createdb youruser
exit
sudo systemctl restart postgresql
```

Se quiser instalar o Docker:

```
sudo pacman -Sy docker
sudo usermod -aG docker $USER
sudo systemctl start docker
sudo systemctl enable docker
logout
```

Sempre precisamos de Redis, Memcached, então vamos instalá-los:

```
sudo pacman -Sy redis memcached
sudo systemctl start redis
sudo systemctl enable redis
sudo systemctl start memcached
sudo systemctl enable memcached
```

Depois de instalar e remover muito software, você pode acabar com pacotes desnecessários ocupando espaço em disco. Dá para limpar com:

```
sudo pacman -Rns $(pacman -Qtdq)
```

E como disse antes, a Arch Wiki é super útil para continuar ajustando o sistema, então leia artigos como [esta página "Improving Performance"](https://wiki.archlinux.org/index.php/Improving_performance).

### Kernels para Desktop

Uma coisa importante sobre a maioria das distros Linux é que o kernel geralmente é compilado para ser mais otimizado para Servidores.

Hardware moderno, especialmente com bastante RAM e equipado com SSD, "deveria" funcionar bem o suficiente. Mas nem sempre: você pode ter alguns "engasgos" ou até total falta de resposta.

Há muitas razões, mas os 2 principais culpados são a memória da aplicação sendo paginada para o swap em disco e o escalonador de I/O do kernel Linux.

Num cenário de servidor, você quer que os processos tenham uma fatia justa dos recursos, por isso um escalonador de processos como o CFS - Completely Fair Scheduler - e o CFQ - Complete Fairness Queueing - para I/O, são fantásticos.

Mas no Desktop a história é completamente diferente. Você está disposto a trocar alto throughput por baixa latência para ter responsividade. Ninguém quer ter a UI e o ponteiro do mouse congelados enquanto copia arquivos grandes para drives USB, ou enquanto espera aquele terrível `make -j9` terminar de compilar o seu igualmente terrível gcc-gcj. Pode terminar com a UI congelada por horas! Simplesmente inaceitável!

O que você quer para uso em Desktop, com dezenas de processos aleatórios fazendo operações aleatórias, é uma configuração quase de "soft real time". Uma preempção mais agressiva onde o Kernel devolve algum controle para a UI para que você possa fazer outras coisas - embora mais devagar. Baixa latência é a chave para uma experiência de usuário fluida.

Para aumentar a responsividade, a primeira e mais importante coisa a fazer é configurar isto:

```
sudo tee -a /etc/sysctl.d/99-sysctl.conf <<-EOF
vm.swappiness=1
vm.vfs_cache_pressure=50
vm.dirty_background_bytes=16777216
vm.dirty_bytes=50331648
EOF
```

Reinicie. Se quiser saber o que são essas configurações, [leia isto](https://rudd-o.com/linux-and-free-software/tales-from-responsivenessland-why-linux-feels-slow-and-how-to-fix-that).

Você pode querer instalar um Kernel customizado com um Scheduler diferente. Existem 3 opções atualmente: [Zen](https://aur.archlinux.org/packages/linux-zen-git/), [Liquorix](https://liquorix.net/) e [CK](https://aur.archlinux.org/packages/linux-ck/).

Ainda não tenho 100% de certeza sobre qual é o melhor; todos têm algumas preocupações de manutenção.

Dos 3, você vai querer ficar com o Zen (que é [basicamente o Liquorix](https://github.com/zen-kernel/zen-kernel/issues/30#issuecomment-142787936)), pois é mantido nos repositórios oficiais em formato binário (acredite, você não quer esperar um kernel customizado compilar, leva uma eternidade).

```
sudo pacman -Sy linux-zen
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Reinicie.

A principal mudança é provavelmente o I/O Scheduler, passando do CFQ padrão para o BFQ. Se você usa HD mecânico vai querer usar o BFQ melhorado (que o Zen habilita por padrão). Se usa SSD vai querer 'deadline' em vez disso.

NÃO INSTALE ESSES KERNELS EM SERVIDORES DE PRODUÇÃO! Eles são destinados apenas ao uso em desktop!

De modo geral, o Zen pode ter o melhor equilíbrio entre estabilidade e conjunto de ajustes. Vale usá-lo, especialmente em hardware mais antigo. Hardware moderno, como disse, pode não notar muita diferença.

### Conclusão

Não sei se são os mantenedores do Arch que estão fazendo um trabalho excelente ou se são a RedHat e a Canonical que estão estragando tanto as distros deles em comparação.

Quer dizer, Ubuntu, Fedora, OpenSuse, Elementary são todas distros decentes que, na maioria das vezes, "simplesmente funcionam".

Mas para uma distro que muitos consideram voltada a "usuários avançados", o Arch é muito mais polido. Não consigo entender o porquê.

No mesmo hardware, a experiência com o Gnome 3 no Arch é visivelmente melhor do que o mesmo Gnome 3 no Fedora. Comparado ao Unity no Ubuntu, está milhas à frente. É rápido, fluido, com boa aparência, e os padrões todos funcionam bem.

E de repente percebo que não preciso mais me preocupar com grandes atualizações. Os upgrades rolling contínuos para o mais recente me trazem mais uma camada de confiança.

O Arch me faz sentir que estou no controle novamente sem exigir que eu perca horas ajustando coisas ao meu gosto. Os padrões são sólidos e consigo fazer pequenas melhorias quando preciso.

Parabéns aos mantenedores do Arch: esta é a melhor distro Linux que já tive o prazer de usar. Espero que essa sensação continue enquanto eu a usar como meu sistema principal. Mas até agora estou convencido de que esta é a escolha certa.
