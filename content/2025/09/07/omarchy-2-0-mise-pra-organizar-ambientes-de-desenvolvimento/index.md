---
title: Omarchy 2.0 - Mise pra organizar ambientes de desenvolvimento
date: "2025-09-07T16:40:00-03:00"
slug: omarchy-2-0-mise-pra-organizar-ambientes-de-desenvolvimento
tags:
  - arch
  - omarchy
  - mise
  - docker
draft: false
translationKey: omarchy-mise-dev-environments
---

Continuando meus posts sobre [Omarchy](https://www.akitaonrails.com/tags/omarchy) mais um post introdutório, mas agora sobre [Mise-en-place](https://mise.jdx.dev/getting-started.html) que já vem pré-instalado. No Omarchy, se digitar "Super+Alt+Espaço" vai abrir o menu principal. Escolha "Install" e depois "Development" e vai aparecer várias linguagens/frameworks que pode instalar, como Ruby on Rails ou Go.

Mas não precisa usar estes menus. Vamos entender.

Num Arch Linux ou Ubuntu da vida, um amador instalaria ruby ou python fazendo algo assim:

```
# arch
yay -S ruby python3
# ubuntu
apt install ruby python3
```

**Este é o jeito ERRADO.**

Esses comandos vão instalar a versão mais nova de cada linguagens e toda vez que atualizar o sistema com `yay -Syu` ou `apt upgrade`, vai puxar as versões mais novas ainda.

Só que se você desenvolve projetos de verdade, **não quer que as versões mudem**.

A versão do deploy no servidor no cloud e a versão na sua máquina local **TEM QUE SER AS MESMAS**.

Se está usando Ruby v3.0.7 e Node.js 22.19.0, não pode ficar refém que quando atualizar seu sistema, do nada vai aparecer Ruby 3.4.5 e Node 24.7.0. Tudo vai começar a quebrar e você vai ficar super confuso sem saber porque. Esse é o erro mais primário que um júnior comete.

Pra evitar isso, cada projeto que está trabalhando PRECISA ESTAR TRAVADO EM VERSÕES FIXAS.

O jeito mais fácil de fazer isso em 2025 é usando **MISE**. Como falei, ele já vem instalado e ativado no Omarchy, mas se estiver usando outra distro basta instalar Mise manualmente:

```
yay -S mise

# .bashrc
eval $(mise activate bash)
```

Adapte isso pra ZSH, Fish ou outro shell que estiver usando, leia a [documentação](https://mise.jdx.dev/installing-mise.html)

Agora navegue pro diretório do seu projeto, por exemplo:

```
cd ~/Projects/AkitaOnRails.com
```

E trave as versões:

```
mise use ruby@3.2.3
mise use node@14.21.3
```

Isso vai criar o arquivo `.tool-versions` que você deve adicionar no git do seu repositório:

```
❯ cat .tool-versions
ruby 3.2.3
nodejs 14.21.3

❯ git add .tool-versions
```

E pronto, toda vez que fizer `cd` pro diretório, o Mise vai ativar exatamente a versão correta pra esse projeto. Veja:

```
AkitaOnRails.com [ master][$!?⇡][ v24.7.0][💎 v3.2.3]
❯ ruby -v
ruby 3.2.3 (2024-01-18 revision 52bb2ac0a6) [x86_64-linux]

AkitaOnRails.com [ master][$!?⇡][ v24.7.0][💎 v3.2.3]
❯ which ruby
/home/akitaonrails/.local/share/mise/installs/ruby/3.2.3/bin/ruby
```

Note que, se estiver usando o prompt [Starship](https://akitaonrails.com/2025/09/07/omarchy-2-0-zsh-configs/) como expliquei no post anterior, com um preset como Pure Prompt, ele mostra no prompt as versões de cada linguagem pra que fique fácil de ver se estiver numa versão errada.

No caso, se leu com atenção, já deve ter notado que **SIM, ESTOU NA VERSÃO ERRADA** do Node.js. Olhem como no prompt ele fala que estou usando Node 24.7.0 mas no arquivo `.tool-versions` ele pede 14.21.3.

O motivo de estar "missing" é porque esta máquina é recém-instalada, mas o projeto é velho.

Então vamos checar:

```
AkitaOnRails.com [ master][$!?⇡][ v24.7.0][💎 v3.2.3]
❯ mise list
Tool    Version            Source                                              Requested
go      1.25.0             ~/.config/mise/config.toml                          latest
node    14.21.3 (missing)  /mnt/data/Projects/AkitaOnRails.com/.tool-versions  14.21.3
node    22.18.0
python  3.13.7
ruby    3.2.3              /mnt/data/Projects/AkitaOnRails.com/.tool-versions  3.2.3
ruby    3.4.5
```

Veja como na listagem de `mise list` ele fala que 14.21.3 está "missing". Então vamos instalar:

```
AkitaOnRails.com [ master][$!?⇡][ v24.7.0][💎 v3.2.3]
❯ mise use node@14.21.3
mise /mnt/data/Projects/AkitaOnRails.com/.tool-versions tools: node@14.21.3

AkitaOnRails.com [ master][$!?⇡][ v14.21.3][💎 v3.2.3]
❯
```

Com o comando `mise use` podemos pedir pra instalar e usar uma versão em particular. Se já não estiver instalado, ele vai instalar. Note como depois disso o prompt do Starship mudou pra refletir que agora estamos usando 14.21.3. Esse é o jeito certo.

Se não estiver necessariamente num diretório de projeto com versões travadas, ainda assim é possível rodar comandos usando uma versão específica, assim:

```
mise exec ruby@3.2.1 -- ruby ...
```

Digamos que queira gerar um projeto de Rails numa versão específica de Ruby:

```
mise exec ruby@3.2.3 -- rails new todo-exercise
```

Mesma coisa vale pra generators em Node, como Next.js ou qualquer outro framework.

Não chequei se o LazyVim no Omarchy já vem configurado assim, mas caso não venha, pro NeoVim suportar Mise precisa adicionar isso:

```lua
-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
```

Basta colocar isso em `~/.config/nvim/lua/config/mise.lua` que ele deve carregar o path correto. Pra integrar com outros editores, cheque [esta documentação](https://mise.jdx.dev/ide-integration.html). Tem um MONTE de opções avançadas que é bom ler a respeito na [seção de Dev-Tools](https://mise.jdx.dev/dev-tools/) mas o básico é o que listei aqui.

## E bancos de dados??

O mesmo vale pra bancos de dados. Cada projeto deve estar travado numa versão específica idêntica à que está rodando no servidor de produção e nunca deve depender dos pacotes do sistema operacional. Dá pra usar mise pra isso mas o mais recomendado é usar Docker. Cada projeto **DEVE** ter um `docker-compose.yml` pra subir somente os bancos de dados. Não precisa subir containers pra linguagens, pra isso é melhor usar Mise.

Se não entende Docker, eu fiz videos ensinando:

{{< youtube id="85k8se4Zo70" >}}

</br>

{{< youtube id="-yGHG3pnHLg" >}}

Somando Mise + Docker Compose + LazyVim, é tudo que se precisa pra ser um desenvolvedor web produtivo, além de usar os recursos da sua máquina de maneira eficiente. Todo desenvolvedor PRECISA aprender este combo de opções. Omarchy já trás tudo pré-instalado, por isso tem sido minha recomendação pra todo iniciante.

Não precisa se preocupar: Arch Linux (com archinstall), é tão fácil de instalar quanto um Ubuntu ou Linux Mint e o Hyprland do Omarchy é muito mais bonito e fluido que um MacOS. O melhor dos mundos. Aprenda hoje!
