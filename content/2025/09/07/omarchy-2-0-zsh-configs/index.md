---
title: Omarchy 2.0 - ZSH Configs
date: "2025-09-07T15:00:00-03:00"
slug: omarchy-2-0-zsh-configs
tags:
  - arch
  - omarchy
  - atuin
  - secrets
  - starship
  - zsh
draft: false
---

Estou gostando bastante de usar [Omarchy](https://omarchy.org/) como meu desktop manager. Leia [meu post anterior](https://akitaonrails.com/2025/08/29/new-omarchy-2-0-install/) pra ver como eu instalei e fiz modificações pra servir o meu setup. Seguindo nessa linha, o Omarchy vem por padrão com shell Bash. Mas eu prefiro ZSH. Bash é perfeitamente usável, é só preferência pessoal mesmo. Tem gente que prefere Fish ou outros. Mas o Omarchy vem só com Bash por enquanto, então resolvi modificar o setup pra suportar meu ZSH.

![Meu ZSH](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_15-16-57.png)

Se quiser mudar pra ZSH, é fácil, só fazer isso:

```bash
yay -S zsh zoxide
chsh -s $(which zsh)
```

Logout, login e pronto. Mas agora seu shell vai estar vazio. Pra baixar minha config faça isso:

```bash
git clone https://github.com/akitaonrails/omarchy-zsh.git ~/config/zsh
ln -s ~/.config/zsh/.zshrc ~/.zshrc 
```

Tem duas coisas que precisa modificar. Em `.zshrc` remova esta linha:

```
source ~/.config/zsh/mounts
```

Isso é só pra eu checar meus mounts de NFS pro meu NAS. Pra você não serve pra nada então pode tirar.

A segunda coisa é criar um novo arquivo para segredos:

```
touch ~/.config/zsh/secrets
chmod 600 ~/.config/zsh/secrets
```

É nele que vai colocar coisas como suas chaves de OpenAI ou Google Cloud ou qualquer coisa assim. Por exemplo:

```
# ~/.config/zsh/secrets
export OPENAI_API_KEY="sk-xx-v1-xxx...xxxxx"
```

Assim seus segredos ficam separados das suas configurações e podemos dar `git push` pra um repositório sem se preocupar que algo possa vazar no futuro. Sempre mantenha segredos, senhas, chaves, separados localmente. Isso já está no `.gitignore` então está seguro.

De bônus, no `~/.config/init` adicionei suporte ao [Atuin](https://atuin.sh/) que é uma ferramenta que serve pra sincronizar todo histórico de comandos que fez no seu shell pra um repositório no "cloud" (leia a documentação, você pode criar seu próprio server local também). O repositório é encriptado, então não é inseguro, mesmo se seu histórico contenha chaves secretas nos comandos.

Instale assim:

```
yay -S atuin
atuin register -u <seu username> -e <seu email>
atuin import auto
atuin sync
```

Logo que registrar o Atuin vai gerar uma chave de encriptação aleatório. Garanta que guardou essa chave num lugar seguro como 1password, Bitwarden ou outro cofre seguro!! Sem ela não vai conseguir decriptar numa nova instalação. Se esquecer, ainda dá pra ver antes de reinstalar, por exemplo:

```
atuin key
```

Se reinstalar sua máquina ou instalar uma nova máquina e quiser seus históricos de volta, basta instalar o Atuin e fazer:

```
atuin login -u <seu username>
atuin sync
```

Ele vai pedir sua senha e chave de encriptação e trazer todo seu histórico de volta.

Segundo minha config, basta digitar `Ctrl+R` pra chamar a procura do histórico (que a partir de agora vai estar num sqlite na sua máquina). Leia a [documentação](https://docs.atuin.sh/) pra mais funcionalidades.

![Ctrl+R](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-07_15-17-20.png)

O DHH configurou o prompt do **Starship** usando o jeito antigo de variável `PS1`. Mas o Starship já tem vários prompt bem bonitos fáceis de usar como "presets". Eu escolhi o Pure Prompt, que eu gosto, mas tem vários outros. Se gostar de algo mais chamativo e colorido, tem este [Pastel Powerline](https://starship.rs/presets/pastel-powerline):

![Pastel Powerline](https://starship.rs/presets/img/pastel-powerline.png)
Escolha o de sua preferência na [página de Presets](https://starship.rs/presets/) e mude em `~/.config/zsh/prompt` no lugar desta linha:

```
starship preset bracketed-segments -o ~/.config/starship.toml
```

Por fim, eu deixei alguns ENVs em `~/.config/zsh/envs` que funcionam pros meus testes de Ollama e coisas assim, mas é bom você saber que estão lá pra não achar estranho se seu Ollama estiver se comportando estranho, edite o arquivo `~/.config/zsh/envs` pra ter os envs de sua preferência:

```
# envs
export OPENAI_API_BASE="https://openrouter.ai/api/v1"
export DEFAULT_MODEL="o1-mini";
export OLLAMA_API_BASE=http://127.0.0.1:11434
export OLLAMA_HOME=http://127.0.0.1:11434
export OLLAMA_MODELS=/mnt/gigachad/ollama/models
```

Também modifique o arquivo `~/.config/zsh/aliases` pra ter alias que você prefira:

```
# aliases
alias monhd="sudo ddcutil -d 1 setvcp 60 0x12"
alias mondp="sudo ddcutil -d 1 setvcp 60 0x0F"

alias sgpt='docker run --rm -e OPENAI_API_BASE=${OPENAI_API_BASE} -e OPENAI_API_KEY=${OPENROUTER_API_KEY} ghcr.io/tbckr/sgpt:latest txt '

alias git='nocorrect git'
git config --global alias.a 'add'
git config --global alias.ps 'push'
git config --global alias.pl 'pull'
git config --global alias.l 'log'
git config --global alias.c 'commit -m'
git config --global alias.s 'status'
git config --global alias.co 'checkout'
git config --global alias.b 'branch'
```

Os primeiros dois aliases são pro meu setup de 2 monitores onde um dos monitores recebe sinal tanto da entrada HDMI quanto da entrada DisplayPort (tenho 2 GPUs). Se não sabia, dá pra controlar isso usando o shell. Leia [este post sobre ddcutil](https://jeancharles.quillet.org/posts/2021-08-20-How-to-use-ddcutil-to-switch-input-of-a-Dell-screen.html)

Em seguida você ganha o comando `sgpt`. Omarchy já trás Docker instalado. Agora no shell você pode perguntar ao ChatGPT sem precisar ficar abrindo um navegador web pra isso:

```
sgpt "qual é a sintaxe de rsync pra sincronizar dois diretórios?"
```

Leia [documentação do SGPT](https://github.com/tbckr/sgpt) pra saber outras funcionalidades ou quais LLMs você pode escolher.

No final temos aliases pra Git. O Omarchy já tem alias pra fazer "g" ser "git" e com este que eu adicionei você pode fazer:

```
git add . # antigo
g a . # novo

git commit -m "initial commit" # antigo
g c "initial commit" # novo

git commit --amend -m "initial commit"
g ca "initial commit"

git push origin master
g ps origin master

git pull origin master
g pl origin master

git log
g l

# e assim por diante
```

Mais prático e menos verbose. Adicione mais aliases conforme seu workflow em `~/.config/aliases`.

E acho que é isso, agora sim, meu Omarchy está organizado do jeito que eu gosto. Faça suas próprias configurações pra tudo ficar do seu jeito também!
