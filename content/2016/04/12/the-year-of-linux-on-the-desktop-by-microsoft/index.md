---
title: "O Ano do Linux no Desktop, pela Microsoft??"
date: '2016-04-12T18:33:00-03:00'
slug: o-ano-do-linux-no-desktop-pela-microsoft
translationKey: year-linux-desktop-microsoft
aliases:
- /2016/04/12/the-year-of-linux-on-the-desktop-by-microsoft/
tags:
- off-topic
- microsoft
- ubuntu
- traduzido
draft: false
---

Pois é, finalmente chegou. Escrevi sobre o anúncio no evento Build alguns dias atrás [aqui](http://www.akitaonrails.com/2016/03/31/war-is-over-or-is-it-a-new-dawn-for-microsoft). Agora a Microsoft está nos provocando um pouco mais ao [liberar o primeiro Insider Build Preview](http://thehackernews.com/2016/04/how-to-run-ubuntu-on-windows-10.html). Para ser exato, ele tem o rótulo "Build 14316.rs1_release.160402-2217", garanta que seja exatamente esse.

Para conseguir baixar, você precisa atender aos seguintes requisitos:

* Ter um Windows 10 64 bits ativado
* Inscrever-se no programa [Windows Insider](https://insider.windows.com/). Se for sua primeira vez, pode levar até 24 horas para ativar
* Nas configurações do Windows Update, em Opções Avançadas, escolha "Get Started" na opção Insider e também escolha o anel "Fast". Agora, ao buscar atualizações, o Preview 14316 deve aparecer. Se não aparecer, espere até a Microsoft atualizar sua conta.

[![configurações do windows update](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/538/big_windows_update_settings.jpg)](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/538/windows_update_settings.jpg)

Você precisa ter, no mínimo, 10GB de espaço livre na sua partição principal, então tenha isso em mente. Outra observação: se você é como eu e está testando no Virtualbox, lembre que para redimensionar um disco virtual é preciso deletar os snapshots, e o processo de merge pode demorar um tempo ridículo.

Depois de instalado, vá às opções de Desenvolvedor no Painel de Controle "Update & Security" e mude seu perfil para "Developer Mode". A feature "Bash on Windows" vai aparecer na lista de Windows Features. É voltada **apenas para desenvolvedores**, não deve ser usada em servidores de produção.

Com o Preview instalado, você deve conseguir abrir o velho cmd.exe (ou qualquer console melhor como o [ConEmu](https://conemu.github.io/)) e digitar "bash". Ele vai pedir para instalar o userland do Ubuntu empacotado pela Canonical. Mais um tempinho. Aliás, o processo todo demora bastante, então reserve pelo menos meio dia. Não faça isso no trabalho :-)

Um problema que esbarrei logo de cara foi que a rede não estava funcionando direito. Alguém [identificou](https://github.com/Microsoft/BashOnWindows/issues/35) que o DNS não estava sendo adicionado em <tt>/etc/resolv.conf</tt>, então é preciso adicionar manualmente. Basta colocar o DNS do Google (8.8.8.8 e 8.8.4.4) no arquivo resolv.conf e pronto.

Por fim, você deve estar dentro do bash, como usuário root. Então, se você é um usuário Windows, saiba desde já que rodar como root é inseguro e uma péssima prática, então não faça isso.

A primeira coisa que você **precisa** fazer é criar manualmente um usuário Linux sem privilégios e adicioná-lo ao grupo sudo, como Andrew Malton [publicou](http://blog.greenarrow.me/elixir-with-ubuntu-for-windows/) primeiro:

```
useradd new_username -m -s /bin/bash 
passwd new_username
usermod -aG sudo new_username
```

Aí você pode logar nesse shell de usuário com <tt>su - [seu usuário]</tt> sempre que quiser!

A partir daqui, podemos assumir que é um Ubuntu 14.04 comum e você deve conseguir seguir o [meu post bem antigo](http://www.akitaonrails.com/2015/01/28/ruby-e-rails-no-ubuntu-14-04-lts-trusty-tahr) sobre como configurar um ambiente Ubuntu para desenvolvedor, ou qualquer outro tutorial pelo Google. Os pacotes básicos de desenvolvimento que sempre instalo primeiro rodam normalmente:

```
sudo apt-get install curl build-essential openssl libcurl4-openssl-dev libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev libgmp-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion redis-server libhiredis-dev memcached libmemcached-dev imagemagick libmagickwand-dev exuberant-ctags ncurses-term ack-grep git git-svn gitk ssh libssh-dev

sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
```

Isso te dá toda a toolchain essencial de compilação além de algumas ferramentas de linha de comando bem conhecidas como o ack (muito melhor que o grep). Também adiciona Redis e Memcached. Todos rodam.

Como boa prática, adicione o seguinte ao arquivo de configuração <tt>/etc/bash.bashrc</tt>:

```
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

E depois disso, configure também o locale para UTF-8:

```
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
```

Só para esquentar um pouco, podemos começar com uma das coisas que eram impossíveis no Windows: ter uma instalação estável de Ruby. Para isso, dizem que o RVM não funciona (assim como o ZSH também não funciona devido a problemas de /dev/pts e symlinks neste preview, veja mais abaixo). Mas o RBENV funciona! Você precisa [instalá-lo](https://github.com/rbenv/rbenv) primeiro e depois o plugin [ruby-build](https://github.com/rbenv/ruby-build#readme):

[![instalando ruby pelo rbenv](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/536/big_installing_ruby.png)](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/536/installing_ruby.png)

Curiosamente, demora bastante para terminar e durante o processo o uso de CPU vai às alturas. Instalar Go é ainda mais demorado! Algo continua instável por baixo dos panos, porque a CPU não deveria ficar a 100% por tanto tempo.

![CPU nas alturas](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/537/big_resources.jpg)

Se eu checar quanta memória tenho no sistema fica mais claro:

```
root@localhost:/mnt/c/Users/fabio# free -h
             total       used       free     shared    buffers     cached
Mem:          1.0G       342M       664M         0B         0B         0B
-/+ buffers/cache:       342M       664M
Swap:           0B         0B         0B
```

Não tenho certeza se esse valor de memória é meio "hard-coded", já que muita gente está reportando os mesmos "664M" livres independente do que esteja rodando. Mas tem algo incompleto aqui. Swap também é zero e você não consegue adicionar nenhum, pelo que pude testar. Swapon, fallocate, nada disso funciona ainda.

```
root@localhost:/mnt/c/Users/fabio# swapon -s
swapon: /proc/swaps: open failed: No such file or directory

root@localhost:/mnt/c/Users/fabio# fallocate -l 4G swapfile
fallocate: swapfile: fallocate failed: Invalid argument
```

Cheguei a tentar [criar um swap file](https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04) usando <tt>dd</tt> em vez de <tt>fallocate</tt> e adicionar ao <tt>/etc/fstab</tt>, mas não funcionou:

```
root@localhost:/mnt/c/Users/fabio# free -m
             total       used       free     shared    buffers     cached
Mem:          1006        342        664          0          0          0
-/+ buffers/cache:        342        664
Swap:            0          0          0

root@localhost:/mnt/c/Users/fabio# cat /etc/fstab
LABEL=cloudimg-rootfs   /        ext4   defaults        0 0
/swapfile       none    swap    sw      0 0
```

Então parece mesmo que a memória está "hard-coded". Acompanhe [esta issue #92](https://github.com/Microsoft/BashOnWindows/issues/92) se quiser ver como vai evoluir.

Mas pior que isso, a memória compartilhada tem limites muito baixos e comportamento estranho. O Postgresql instala mas não sobe de jeito nenhum:

```
root@localhost:/mnt/c/Users/fabio# pg_createcluster 9.3 main --start
Creating new cluster 9.3/main ...
  config /etc/postgresql/9.3/main
  data   /var/lib/postgresql/9.3/main
  locale en_US.UTF-8
FATAL:  could not create shared memory segment: Invalid argument
DETAIL:  Failed system call was shmget(key=1, size=48, 03600).
HINT:  This error usually means that PostgreSQL's request for a shared memory segment exceeded your kernel's SHMMAX parameter, or possibly that it is less than your kernel's SHMMIN parameter.
        The PostgreSQL documentation contains more information about shared memory configuration.
child process exited with exit code 1
initdb: removing contents of data directory "/var/lib/postgresql/9.3/main"
Error: initdb failed
```

E se tentamos expandir o limite SHMMAX, é isso que acontece:

```
root@localhost:/mnt/c/Users/fabio# sysctl -w kernel.shmmax=134217728
sysctl: cannot stat /proc/sys/kernel/shmmax: No such file or directory

root@localhost:/mnt/c/Users/fabio# echo 134217728 >/proc/sys/kernel/shmmax
bash: /proc/sys/kernel/shmmax: Operation not permitted
```

Então, sem Postgresql por enquanto. Algumas pessoas que conseguiram completar a instalação do Go Lang (eu desisti depois de muito tempo esperando o apt-get terminar) reclamaram que o Go também quebrou nos requisitos de memória compartilhada. Acompanhe a [Issue #32](https://github.com/Microsoft/BashOnWindows/issues/32) e a [Issue #146](https://github.com/Microsoft/BashOnWindows/issues/146) para ver se alguém consegue fazer rodar.

Também tentei instalar o Node.js. Sem sorte com a instalação dos pacotes:

```
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
...
E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.
Error executing command, exiting
```

O NVM instala, mais ou menos, com vários erros no git:

```
...
error: unable to create file test/slow/nvm run/Running "nvm run 0.x" should work (No such file or directory)
error: unable to create file test/slow/nvm run/Running "nvm run" should pick up .nvmrc version (No such file or directory)
error: unable to create file test/slow/nvm use/Running "nvm use iojs" uses latest io.js version (No such file or directory)
error: unable to create file test/slow/nvm use/Running "nvm use node" uses latest stable node version (No such file or directory)
error: unable to create file test/slow/nvm use/Running "nvm use v1.0.0" uses iojs-v1.0.0 iojs version (No such file or directory)
error: unable to create file test/slow/nvm use/Running "nvm use" calls "nvm_die_on_prefix" (No such file or directory)
```

E é isso que acontece se eu tento instalar a versão mais recente:

```
akitaonrails@localhost:~/.nvm$ nvm install 5.10.1
Downloading https://nodejs.org/dist/v5.10.1/node-v5.10.1-linux-x64.tar.xz...
######################################################################## 100.0%
tar: bin/npm: Cannot create symlink to ‘../lib/node_modules/npm/bin/npm-cli.js’: Invalid argument
tar: Exiting with failure status due to previous errors
Binary download failed, trying source.
######################################################################## 100.0%
Checksums empty
tar: bin/npm: Cannot create symlink to ‘../lib/node_modules/npm/bin/npm-cli.js’: Invalid argument
tar: Exiting with failure status due to previous errors
Binary download failed, trying source.
Detected that you have 1 CPU thread(s)
Number of CPU thread(s) less or equal to 2 will have only one job a time for 'make'
Installing node v1.0 and greater from source is not currently supported
```

A [Issue #9](https://github.com/Microsoft/BashOnWindows/issues/9) aponta para a falta de suporte a symlinks.

Outra coisa muito chata é a falta de Pseudo-Terminais (/dev/pts), que é possivelmente uma das razões do ZSH não funcionar. Acompanhe a [Issue #80](https://github.com/Microsoft/BashOnWindows/issues/80).

Você também deve conseguir copiar suas chaves SSH privadas para ".ssh" e começar a clonar do Github ou dar git push para o Heroku rapidinho.

```
akitaonrails@localhost:~$ ssh-keygen  -t rsa
Generating public/private rsa key pair.
Created directory '/home/akitaonrails/.ssh'.kitaonrails/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/akitaonrails/.ssh/id_rsa.
Your public key has been saved in /home/akitaonrails/.ssh/id_rsa.pub.
The key fingerprint is:
f8:16:b1:be:85:31:0c:71:f8:c2:d3:72:ab:48:42:9a akitaonrails@localhost
The key's randomart image is:
+--[ RSA 2048]----+
|      ...        |
|      .o         |
|     ..o.        |
|  .   =++o       |
| +    .=S.       |
|E . .  o.=       |
|   o . .= .      |
|    . .. o       |
|        .        |
+-----------------+
```

Pelo menos o Elixir parece funcionar:

```
akitaonrails@localhost:~$ iex
Erlang/OTP 18 [erts-7.3] [source-d2a6d81] [64-bit] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.2.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> defmodule HelloWorld do; def say(name) do; IO.puts("Hello #{name}"); end; end
iex:1: warning: redefining module HelloWorld
{:module, HelloWorld,
 <<70, 79, 82, 49, 0, 0, 5, 240, 66, 69, 65, 77, 69, 120, 68, 99, 0, 0, 0, 147, 131, 104, 2, 100, 0, 14, 101, 108, 105, 120, 105, 114, 95, 100, 111, 99, 115, 95, 118, 49, 108, 0, 0, 0, 4, 104, 2, ...>>,
 {:say, 1}}
iex(2)> HelloWorld.say("Fabio")
Hello Fabio
:ok
```

Calma lá...

```
akitaonrails@localhost:~$ mix new ex_test
** (ErlangError) erlang error: :terminated
    (stdlib) :io.put_chars(#PID<0.25.0>, :unicode, [[[[[[[] | "\e[32m"], "* creating "] | "\e[0m"], ".gitignore"] | "\e[0m"], 10])
    (mix) lib/mix/generator.ex:26: Mix.Generator.create_file/3
    (mix) lib/mix/tasks/new.ex:76: Mix.Tasks.New.do_generate/4
    (elixir) lib/file.ex:1138: File.cd!/2
    (mix) lib/mix/cli.ex:58: Mix.CLI.run_task/2
```

Você vai encontrar mais informações no pseudo-projeto que a Microsoft abriu no Github para acompanhar as [Issues](https://github.com/Microsoft/BashOnWindows/issues?q=is%3Aissue+is%3Aclosed) de testers como eu. Dá para acompanhar a lista de issues abertas e fechadas por lá. Você vai ver muita coisa que funciona, mas também muita outra que não vai funcionar até sair uma nova release que conserte tudo o que mencionei aqui.

### Conclusão

Então, o "Bash on Windows" é um bom ambiente de desenvolvimento para usuários Linux terem sobre o Windows?

No Preview 14316, ainda não. A palavra-chave aqui é "ainda". Está tomando forma de um jeito legal e, se conseguirem realmente corrigir todas as issues abertas até agora, vai ficar muito utilizável muito rápido.

Precisamos de controles de memória adequados, um suporte bem implementado de pseudo-terminal, controles adequados de memória compartilhada, symlinks adequados, upstart adequado do Ubuntu para que serviços instalados como Redis ou Memcached (que instalei e rodam) possam ser reiniciados corretamente quando eu boote o ambiente (eles não sobem se eu reiniciar a máquina, por exemplo).

[Algumas pessoas](http://www.neowin.net/news/bash-plus-windows-10-equals-linux-gui-apps-on-the-windows-desktop) chegaram a conseguir enganar o X11 e rodar apps GUI como Firefox e até XFCE sobre esse ambiente, então é realmente promissor. Essa ideia funciona.

Uma vez que essas issues sejam resolvidas, sim, acredito que estamos mais perto do que nunca de finalmente usar Windows como um ambiente de desenvolvimento viável e completo. Vamos ver se até o Anniversary Release do Windows 10 em junho vamos ter uma instalação estável de Ubuntu.

Uma coisa que acho que fizeram muito errado foi amarrar o Linux Subsystem à instalação do Windows 10. Devia ter sido um instalador separado, para que o time pudesse liberar atualizações de build sem ter que empacotar tudo junto com o sistema operacional inteiro.

Se você estava pretendendo migrar para Windows para seus desenvolvimentos baseados em Linux, ainda não. Segure os cavalos um pouco mais.
