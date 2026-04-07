---
title: "Substituindo rvm, rbenv, nvm e outros pelo asdf"
date: '2017-10-24T14:19:00-02:00'
slug: substituindo-rvm-rbenv-nvm-e-outros-pelo-asdf
translationKey: replacing-rvm-with-asdf
aliases:
- /2017/10/24/replacing-rvm-rbenv-nvm-etc-for-asdf/
tags:
- rvm
- rbenv
- nvm
- ruby
- nodejs
- elixir
- traduzido
draft: false
---

Muita gente está usando Docker como meio de ter diferentes versões de Ruby ou de qualquer outra linguagem. Ainda acho que o overhead adicional tanto em uso de recursos quanto em fricção de usabilidade simplesmente não compensa. Recomendo fortemente contra isso. Docker é ótimo como base para infraestruturas automatizadas, mas prefiro tê-lo apenas em servidores.

Faz bastante tempo que uso o [asdf](https://github.com/asdf-vm/asdf) como meu gerenciador principal de versões de Ruby, e estou confiante de que posso recomendá-lo no lugar dos mais conhecidos RVM ou Rbenv.

Além disso, ele não gerencia só Ruby — ele gerencia praticamente todas as linguagens que você precisar, com um único conjunto de comandos. Então nem precisa mais de virtualenv para Python ou NVM para Node.js. É só usar o ASDF.

A instalação não poderia ser mais simples. Basta seguir o [README](https://github.com/asdf-vm/asdf/blob/master/README.md) na página do projeto.

Não esqueça de instalar as ferramentas base de desenvolvimento para o seu ambiente. Você pode seguir a [wiki do ruby-build](https://github.com/rbenv/ruby-build/wiki) como referência:

```
## Para OS X
# opcional, mas recomendado:
brew install openssl libyaml libffi

# obrigatório para compilar Ruby <= 1.9.3-p0:
brew tap homebrew/dupes && brew install apple-gcc42

## Para Ubuntu
sudo apt-get install gcc-6 autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

## Para Arch
sudo pacman -S --needed gcc5 base-devel libffi libyaml openssl zlib
```

Depois instale o próprio ASDF:

```
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.0
```

Então adicione a configuração de ambiente para o PATH e o autocomplete:

```
# Para Ubuntu ou outras distros Linux
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

# OU para Mac OSX
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profile
```

Por fim, você precisa instalar um dos dezenas de [plugins](https://github.com/asdf-vm/asdf-plugins) disponíveis. No meu caso, tenho estes instalados:

```
asdf plugin-add clojure https://github.com/vic/asdf-clojure.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf plugin-add python https://github.com/tuvistavie/asdf-python.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git

# Importa as chaves OpenPGP do time de releases do Node.js para o keyring principal
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
```

Para atualizar todos os plugins de uma vez, basta rodar:

```
asdf plugin-update --all
```

Para ver as versões disponíveis de uma linguagem específica:

```
asdf list-all ruby
asdf list-all clojure
asdf list-all python
```

Para instalar qualquer versão que você precisar:

```
asdf install ruby 2.4.2
asdf install nodejs 8.7.0
asdf install erlang 20.1
```

Depois de instalar uma versão, costumo definir uma como padrão global do sistema:

```
asdf global ruby 2.4.2
asdf global elixir 1.5.2
```

E dentro de um diretório de projeto específico, posso definir outra versão, válida só para aquele projeto:

```
asdf local ruby 2.3.4
```

Esse comando grava um arquivo `.tool-versions` no diretório onde você está quando o executa. Ele contém a linguagem e a versão escolhidas, então sempre que você voltar para aquele diretório o ASDF vai configurar a versão correta automaticamente. O `asdf global <linguagem>` que mencionei antes faz a mesma coisa, só que grava o `.tool-versions` no seu diretório home. A configuração local sobrescreve a do home.

Outro ponto importante: sempre que você instalar bibliotecas que têm scripts executáveis que precisam estar no PATH, você deve fazer o **reshim** deles. Por exemplo:

```
npm install -g phantomjs # instala o phantomjs
asdf reshim nodejs # coloca o shim do executável phantomjs no PATH
phantomjs # executa corretamente
```

Se você tentar instalar versões de Ruby anteriores à 2.4, vai encontrar [problemas de compilação](https://github.com/asdf-vm/asdf-ruby/wiki/Ruby-Installation-Problems), pois elas dependem do gcc5 e do openssl-1.0. Nesse caso, use o seguinte comando (assumindo que você já instalou o openssl-1.0 e o gcc5 obsoletos):

```
CC=gcc-5 PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig \
RUBY_EXTRA_CONFIGURE_OPTIONS="--with-openssl-dir=/usr/lib/openssl-1.0" \
asdf install ruby 2.3.4
```

Às vezes, quando uma dependência está faltando e a instalação falha, você precisa remover manualmente a versão antes de tentar reinstalar:

```
asdf remove <linguagem> <versão>
```

Por fim, se você costumava adicionar algo ao seu bash ou zsh para mostrar a versão atual da linguagem na linha de comando — provavelmente usando algo como `rvm-prompt` — no caso do ASDF você vai precisar de algo um pouco mais longo:

```
asdf current ruby | awk -F' ' '{print $1}'
```

Isso extrai só a versão (o comando `asdf current` mostra também qual arquivo `.tool-versions` está sendo usado, por isso o resultado é mais longo).

Fora isso, está tudo pronto. Um gerenciador de versões para governar todos. Sem RVM, sem Virtualenv, sem NVM. Pode viver feliz para sempre!
