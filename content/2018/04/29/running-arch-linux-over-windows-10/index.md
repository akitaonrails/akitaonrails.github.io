---
title: "Rodando Arch Linux sobre o Windows 10!"
date: '2018-04-29T22:06:00-03:00'
slug: rodando-arch-linux-sobre-o-windows-10
translationKey: arch-linux-over-windows-10
aliases:
- /2018/04/29/running-arch-linux-over-windows-10/
tags:
- archlinux
- wsl
- asdf
- microsoft
- windows
- vmware
- traduzido
draft: false
---

Ok, quem acompanha meu blog há um ano ou dois sabe como eu [curto o Arch Linux](http://www.akitaonrails.com/archlinux) — em particular o Manjaro com GNOME.

Também continuo bastante intrigado com a ideia do Windows Subsystem for Linux (WSL), que estreou de verdade na [Windows 10 Anniversary Edition](http://www.akitaonrails.com/2016/07/26/o-ano-do-linux-no-desktop-esta-usavel) em meados de 2016.

Já faz quase 2 anos e a expectativa é de atualizações expressivas em compatibilidade e performance do WSL para a próxima [Spring Creators Update](https://winaero.com/blog/command-line-wsl-improvements-windows-10-version-1803/) (versão 1803), prevista para 30 de abril de 2018. Isso aproxima o WSL de algo realmente utilizável por programadores profissionais. Só para ter uma ideia: hoje em dia você consegue desempenho ordens de magnitude superior rodando sua distro favorita dentro do Virtualbox ou do VMWare Workstation.

Além disso, o "Bash for Windows" de fábrica suporta oficialmente apenas Ubuntu, Fedora e OpenSuse, acho. A maioria das pessoas instala o Ubuntu mesmo. E funciona, ok. Para brincar e impressionar nas demonstrações, funciona. Mas me irrita profundamente conseguir fazer tanta coisa e não poder usar isso no meu dia a dia de verdade. É como carregar o protótipo finalizado do próximo iPhone sem suporte a 4G. Um brinquedo, só isso.

Mas se você quiser apenas ver como está a performance comparada ao meu setup com VMWare, pule direto para o final do artigo.

Voltando ao assunto das distros: usuários sérios de Linux preferem alternativas melhores. Eis o repositório no GitHub:

[![screenfetch of arch](https://raw.githubusercontent.com/wiki/yuk7/WSL-DistroLauncher/img/Arch_Alpine_Ubuntu.png)](https://github.com/yuk7/ArchWSL)

Você baixa [esse arquivo zip](https://github.com/yuk7/ArchWSL/releases/latest), descompacta e executa o `Arch.exe` incluso. Só isso!

Aí é só abrir o "Bash" na versão Windows e bootstrapar o restante da instalação por lá.

Precisamos do Pacman e de algum gerenciador de AUR. Para iniciar o Pacman:

```
pacman-key --init
pacman-key --populate
pacman -Syu
```

Que delícia, o Pacman rodando nativamente no Windows! Quem diria??

![pacman no windows](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/674/big_IMG_20180429_174518.jpg)

Isso vai atualizar tudo. Em seguida, criamos um usuário não-root:

```
useradd -m your_user
passwd your_user
EDITOR=nano visudo
```

Procure a linha que diz `root   ALL=(ALL) ALL` e adicione o seu usuário logo abaixo:

```
your_user   ALL=(ALL) ALL
```

Por último, fazemos login como esse usuário:

```
su your_user
```

Agora vamos instalar o Yaourt para depois instalar o Pacaur (preferência pessoal minha — acho o Yaourt verboso demais com suas confirmações, por isso prefiro o Pacaur).

Comece editando o arquivo `/etc/pacman.conf` com seu editor favorito (vim ou nano).

Adicione a seguinte seção no final do arquivo:

```
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```

Antes de prosseguir, temos um pequeno problema. O WSL ainda não tem suporte a SYSV IPC, que é necessário para o [fakeroot](https://unix.stackexchange.com/questions/9714/what-is-the-need-for-fakeroot-command-in-linux), que por sua vez é exigido pelo `makepkg` (que não pode rodar como root).

Para contornar isso:

```
wget https://github.com/yuk7/arch-prebuilt/releases/download/17121600/fakeroot-tcp-1.22-1-x86_64.pkg.tar.xz
sudo pacman -U fakeroot-tcp-1.22-1-x86_64.pkg.tar.xz
```

Por enquanto é isso! Até o WSL ter suporte nativo a SYSV IPC, usamos esse workaround. O próprio Yaourt provavelmente vai te pedir para instalar o `fakeroot-tcp` também — pode deixar.

Como disse, o Yaourt é bastante verboso nas confirmações. Regra geral: quando perguntar se quer editar algo, responda "N". Quando perguntar se quer compilar ou instalar, responda "Y". Se você quiser se livrar de mim nessa parte, faça logo:

```
yaourt -S pacaur
```

A partir de agora assumo que você tem o Pacaur instalado.

### Suporte a Interface Gráfica

Vamos instalar o básico para um ambiente de desenvolvimento:

```
sudo pacman -S base base-devel gvim git
```

Quando aparecer "default: all", instale tudo. Espaço em disco não deveria ser preocupação em 2018.

Prefiro ter um ambiente GNOME 3 completo, então:

```
sudo pacman -S gnome
```

De novo, deixe instalar tudo que quiser. Cada um tem seu gosto em termos de GUI — uns preferem KDE5, outros XFCE4. Tem quem vá ainda mais longe e use o gerenciador de janelas tileado [i3](https://i3wm.org/).

Isso exige uma adaptação séria. É para quem curte usar teclado tenkeyless sem legenda nas teclas e layouts alienígenas como DVORAK ou [Colemak](https://colemak.com/) (argh!). Gosto é gosto. E que tal se tornar digitador fluente no [Maltron](https://www.maltron.com/the-maltron-letter-layout-advantage.html)? Eu te desafio, e muito! :-D

Mas estou divagando. Adicione isso ao seu `/etc/.bashrc` ou ao `/etc/environment` global:

```
echo "export LIBGL_ALWAYS_INDIRECT=1" >> /etc/.bashrc
echo "export DISPLAY=:0" >> /etc/.bashrc
```

Exporte as variáveis no shell atual ou feche e reabra o Bash.

Para ter um ambiente gráfico completo, instale um servidor X local. São duas opções: Xming ou VcXSrv. Tenho tido problemas para redimensionar janelas no Xming, então recomendo o [VcXSrv](https://sourceforge.net/projects/vcxsrv/). Baixe e instale como qualquer aplicativo Windows, depois inicie. Ele vai criar um atalho no Desktop chamado "XLaunch" — é só abrir.

E finalmente, instalamos um terminal **DE VERDADE** no lugar daquela tralha derivada do cmd.exe antigo que o WSL oferece por padrão:

```
pacaur -S tilix-bin
tilix
```

Quem usou Mac provavelmente conhece o iTerm2, possivelmente o melhor emulador de terminal que já usei. Nada chega perto. Nada, exceto talvez o [Tilix](https://gnunn1.github.io/tilix-web/) (antigamente chamado Terminix).

Só pelo "Ctrl-Alt-D" para dividir o terminal horizontalmente e "Ctrl-Alt-R" para dividir verticalmente, e "Alt-1", "Alt-2" etc. para navegar entre os painéis, já vale a pena. Ainda vem com temas prontos excelentes como o clássico Solarized Dark ou meu favorito atual, Monokai Dark.

Não me xingue, eu sei. Alguns preferem o terminal padrão com TMUX. Também é gosto — faz mais sentido quando se trabalha em servidor remoto.

Adicione a fonte Hack monotype para um visual mais agradável:

```
sudo pacman -S ttf-hack
```

### Linguagens de Programação

Vamos ver se as linguagens mais importantes instalam corretamente. Como sempre digo, o ASDF resolve essa questão.

```
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
```

Reinicie o terminal e continue:

```
asdf plugin-add nodejs
addf plugin-add ruby
```

Para Node.js é preciso adicionar as chaves GPG corretas antes de instalar:

```
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 10.0.0
asdf global nodejs 10.0.0
```

Ruby se beneficia do jemalloc para alocar menos memória do sistema. Não sei se impacta no WSL, mas vamos fazer de qualquer forma:

```
sudo pacman -S jemalloc
RUBY_EXTRA_CONFIGURE_OPTIONS="--with-jemalloc" asdf install ruby 2.5.1
asdf global ruby 2.5.1
gem install bundler
```

![ruby compilando](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/675/big_IMG_20180429_193432.jpg)

Até aqui tudo bem. Se precisar instalar um Ruby antigo (< 2.4) para projetos legados:

```
pacaur -S openssl-1.0
PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig RUBY_EXTRA_CONFIGURE_OPTIONS="--with-openssl-dir=/usr/lib/openssl-1.0" asdf install ruby 2.3.3
```

Infelizmente precisa de uma versão de OpenSSL que não deveria mais ser usada por questões de segurança. Todo mundo migrou para a 1.1. Além disso, o Ruby 2.3.x chegou ao seu EOL (fim de vida). Use por sua conta e risco.

Mas até aqui tudo funcionando. E o Go? Vamos ver:

```
asdf plugin-add golang
asdf install golang 1.9.5
asdf global goland 1.9.5
```

Poderíamos continuar, mas acho que você já pegou a ideia. Simplesmente funciona!

### Processos em Background

Outra limitação atual do WSL (que esperamos ver resolvida na Spring Creators Update) é a capacidade de iniciar e manter processos em background (daemons).

Fazer `sudo systemctl enable postgresql` e reiniciar não vai iniciar o Postgresql automaticamente em background como deveria. O próprio Arch.exe que estamos usando nem tem systemd.

Felizmente, servidores como Postgresql ou Redis funcionam normalmente — podem ser iniciados como processos de usuário e se vinculam corretamente às suas portas TCP. Mas você vai ter que iniciá-los manualmente a cada sessão. Feche o terminal Bash e todos morrem.

Por exemplo, Postgresql:

```
[your_user]# sudo pacman -S postgresql
[your_user]# sudo mkdir -p /run/postgresql
[your_user]# sudo chown -R postgres:postgres /run/postgresql

[your_user]# sudo -u postgres -i
[postgresql]# initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data'

[postgresql]# pg_ctl -D /var/lib/postgres/data start
waiting for server to start....2018-04-29 23:30:35.483 UTC [1064] LOG:  listening on IPv4 address "127.0.0.1", port 5432
2018-04-29 23:30:35.505 UTC [1064] LOG:  listening on Unix socket "/run/postgresql/.s.PGSQL.5432"
2018-04-29 23:30:35.583 UTC [1065] LOG:  database system was shut down at 2018-04-29 23:23:48 UTC
2018-04-29 23:30:35.660 UTC [1064] LOG:  database system is ready to accept connections

[postgresql]# createuser --interactive
Enter name of role to add: your_user
Shall the new role be a superuser? (y/n) y

[postgresql]# exit
[your_user]#
```

Viu o que fiz aqui? Tem um problema na instalação sob WSL em que o `/run/postgresql` não é criado com as permissões corretas. Corrigindo isso conseguimos iniciar o servidor. Podemos sair da sessão `su` e o PostgreSQL continua rodando. Mas quando fecharmos a primeira janela/sessão Bash, ele morre.

E tem mais uma coisa irritante: as correções de `mkdir` e `chown` acima? Preciso fazer toda vez que fecho o Bash for Windows e abro novamente!! Absurdamente chato!

Mas dá para conviver por enquanto. Esperançosamente isso vai estar resolvido amanhã (30 de abril) ou em uma atualização próxima.

Em um ambiente de desenvolvimento Rails, dá para usar o [Foreman](https://github.com/theforeman/foreman) para ajudar. Basta editar um arquivo `Procfile.dev`:

```
web: bundle exec puma -C config/puma.rb -p 3000
db: su postgres -c 'pg_ctl start -D /var/lib/postgres/data'
redis: redis-server /usr/local/etc/redis.conf
mailcatcher: mailcatcher -f
```

Aí é só: `foreman start -f Procfile.dev` e todos os serviços sobem de uma vez.

### Performance no Mundo Real

Minha máquina do dia a dia é o Manjaro GNOME rodando no VMWare Workstation Pro no meu Surface Book 2. Dou a ele 6 dos 8 threads e generosos 12GB de RAM dos 16GB totais (Microsoft, precisamos de mais RAM! Os modernos implantam aplicativos estúpidos com camadas pesadas de JS/CSS que comem tudo que tem).

No projeto em que estou trabalhando, minha suite RSpec completa é um pouco lenta. Para essa comparação, estou pulando os feature specs porque não tenho paciência agora para configurar o chrome-driver no WSL (provavelmente funciona, mas fica para outra vez).

```
Finished in 12 minutes 8 seconds (files took 14.58 seconds to load)
1493 examples, 0 failures, 35 pending

531,34s user 127,56s system 88% cpu 12:24,99 total
```

No ambiente WSL comparável que acabei de instalar, rodando a mesma suite RSpec, obtive:

```
Finished in 13 minutes 43 seconds (files took 3 minutes 16.8 seconds to load)
1474 examples, 0 failures, 35 pending


455.80s user 399.14s system 83% cpu 17:04.96 total
```

Por algum motivo meu ambiente WSL está pulando alguns exemplos (parece mais um bug de contador do RSpec), mas acho que isso não muda muito o panorama geral. O WSL perde mesmo que o contador esteja correto e ele esteja rodando menos exemplos.

Quando começamos a exercitar o WSL de verdade, toda sorte de problemas aparece. Por exemplo, o PostgreSQL entra em colapso e fica imprimindo "could not flush dirty data: Function not implemented" no stdout, por causa de [um problema documentado](https://github.com/Microsoft/WSL/issues/645) do WSL! O que acaba acontecendo é que o runner do RSpec simplesmente pausa enquanto o PG tenta se resolver.

No VMWare os arquivos carregaram em menos de 15 segundos. No WSL levou mais de 3 minutos só em I/O de arquivos! Ordens de magnitude mais lento. Esse é o problema grave. Quando é só CPU contra CPU, os dois são bastante comparáveis.

No total, os tempos ficam próximos no papel. Em CPU o WSL até leva vantagem, o que explica como ele consegue recuperar o tempo total apesar do I/O claramente lento.

Na prática, numa situação normal de programação, você abre o Vim ou qualquer editor. Todo programador fica abrindo e alternando entre muitos arquivos o tempo todo. Com o I/O super lento, cada arquivo que você tenta abrir trava sua ação por uma fração de segundo. E isso vai acumulando.

Dentro do VMWare, o Vim responde na hora, abrir um arquivo é quase instantâneo.

O benchmark pode não capturar essa situação. Mas no dia a dia você vai acabar irritado. Além disso, rodar uma GUI sobre o X (VcXsrv no meu caso) também adiciona lentidão. Dentro do VMWare, o Xorg normal aproveita aceleração GPU, então todo o pipeline de rasterização é mais rápido.

Dá para usar o WSL como ambiente principal. Mas se consigo uma experiência mais fluida dentro do VMWare, é lá que vou ficar por enquanto.

### Conclusão

Vou segurar minhas conclusões até amanhã (30 de abril) ou mais para o final da semana, porque se a Spring Creators Update realmente corrigir os problemas de performance, aí posso me ver usando isso no lugar da minha instalação do Manjaro GNOME no VMWare Workstation.

Pode não vir nessa grande atualização, mas tenho informações de que estão trabalhando nos problemas pendentes de performance de I/O. Então está chegando.

Tudo que preciso simplesmente funciona: Tilix, Vim, Git, Zsh, Ruby, Node.js. Tudo instala como esperado pelo Pacman e AUR. Pura glória do Arch Linux! Que pena que a performance ruim estraga tudo.

Está perto, muito perto! Pela primeira vez em quase 15 anos, consigo quase me ver voltando 100% para o Windows (sem VMWare) e ainda sendo totalmente produtivo com ferramentas reais, profissionais e open source que "simplesmente funcionam".

Fique de olho neste post para atualizações esta semana!
