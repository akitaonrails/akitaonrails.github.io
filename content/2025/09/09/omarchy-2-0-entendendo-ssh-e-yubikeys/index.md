---
title: Omarchy 2.0 - Entendendo SSH e Yubikeys
date: "2025-09-09T12:00:00-03:00"
slug: omarchy-2-0-entendendo-ssh-e-yubikeys
tags:
  - arch
  - omarchy
  - ssh
  - openssh
  - yubikey
  - ssh-agent
  - segurança
draft: false
---

Este post não tem nada a ver diretamente com Omarchy mas resolvi incluir na [mesma série](/tags/omarchy) porque é uma dica importante pra programadores.

**Todo programador precisa saber como gerenciar suas chaves SSH.** No mínimo porque toda conta no GitHub exige uma chave.

![GitHub SSH](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-09_12-19-38.png)

Toda vez que fizer `git push` pra um repositório seu, ele vai pedir a passphrase dessa chave:

```bash
❯ git puss origin master
Enter passphrase for key '/home/akitaonrails/.ssh/id_ed25519':
```

O que significa isso?

SSH é um conjunto de ferramentas tanto de cliente quanto servidor pra criar uma conexão segura, encriptada, pela internet. Ela tem diversas utilidades e eu expliquei como fazer Proxy SSH neste video:

{{< youtube id="T-jHuFnxZ2k" >}}

O processo todo se inicia instalando SSH na sua máquina, e no Omarchy/ArchLinux é só fazer isso:

```bash
yay -S openssh
```

Se nunca criou um par de chaves (sim, é um par) é só executar este comando:

```
ssh-keygen -t ed25519 -a 100 -C "your_email@example.com" -f ~/.ssh/id_ed25519
```

**ED25519** é um algoritmo de chave-pública, ou seja, cria um par de chaves: uma privada que **jamais deve sair da sua máquina**, e uma pública que pode ser exposta na internet aberta (a que você registra na sua conta no GitHub, por exemplo). Eu expliquei sobre chaves-públicas neste outro video:

{{< youtube id="HCHqtpipwu4" >}}

ED25519 é um algoritmo mais moderno que o antigo RSA (que acho que ainda é o padrão no ssh-keygen se não fizer a escolha explícita - ela continua sendo segura, mas curva elíptica é ainda mais segura).

Ela é baseada em criptografia de curva elíptica (ECC). Pros paranóicos, sim, é inclusive considerada **quantum-resistant**, ou seja, mesmo se fosse possível fazer um computador quântico, ela não conseguiria quebrar uma chave ED25519.

Dois arquivos serão criados depois de rodar `ssh-keygen`:

```
.rw-------   464 akitaonrails 14 Nov  2017  󰌆 id_ed25519
.rw-r--r--   108 akitaonrails 14 Nov  2017  󰷖 id_ed25519.pub
```

Note as permissões desses arquivos. É importante que o diretório `~/.ssh` e os arquivos de chave privada dentro sempre estejam com permissão `600` , ou seja, read-write somente pro seu usuário, e nenhuma permissão pra grupos ou qualquer outro usuário. Ninguém deve ser capaz sequer de listar o diretório se não for você mesmo.

Já os arquivos `*.pub`, que são as chaves públicas, tem permissão `644` que é read-write pra você e somente-leitura pra outros grupos e usuários. Como falei, a chave pública pode ser exposta publicamente. A minha, por exemplo, é esta:

```
❯ cat id_ed25519.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWG5bHK02sMqilMiYu67xqdaBsk3TtCQ564bcJibDiO akitaonrails@Miner42.local
```

ED25519 tem outra vantagem, ela é ordens de grandeza mais segura que RSA e ainda oferece uma chave pública muito mais curta, o que facilita na hora de copiar e colar por aí.

Uma chave privada tem um envelope neste formato:

```
-----BEGIN RSA PRIVATE KEY-----
MIIEpA ...
...
XfI0X....
...
... nQ5w==
-----END RSA PRIVATE KEY-----
```

Repetindo: **ESTE ARQUIVO JAMAIS DEVE SAIR DA SUA MÁQUINA**. Nunca deixe largado num pen drive, por exemplo. E sempre garanta que a permissão é `chmod 600` como expliquei.

### Yubikey 5

A forma considerada mais segura e que muitas empresas até enforçam, é o uso de uma **HARDWARE-KEY**. A chave privada nunca é gravada na sua máquina local e sim gerada dentro de um hardware seguro, de onde é impossível tentar ler essa chave privada. Exemplos são Yubikey ou FIDO2.

Sobre Yubikey, cuidado, você quer os modelos mais novos **Yubikey Series 5**:

![Yubikey 5](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/yubikey.webp)

Se tiver o antigo - que normalmente é o de cor azul - ele é o Security Key v4.3.1 e só suporta **U2F (FIDO U2F)** mas não **FIDO2/WebAuthn** e não applets **PIV/OpenPGP/OTP**. Pra ter certeza, instale estes pacotes no seu Arch:

```
sudo pacman -S yubikey-manager libfido2
```

Daí cheque com este comando:

```bash
❯ ykman info
WARNING: PC/SC not available. Smart card (CCID) protocols will not function.
Device type: FIDO U2F Security Key
Firmware version: 4.3.1
Enabled USB interfaces: FIDO

Applications
Yubico OTP   Not available
FIDO U2F     Enabled
FIDO2        Not available
OATH         Not available
PIV          Not available
OpenPGP      Not available
YubiHSM Auth Not available
```

Veja como ele acha o Yubikey conectado via USB mas tudo está como "Not available". Não é o correto, esse Yubikey só serve como Two-Factor Authentication em Websites. Não é inútil, mas pro nosso caso não funciona porque:

* não tem applet PIV então não serve de smartcard
* não tem applet OpenPGP então não consegue guardar chaves privadas GPG ou SSH
* não tem FIDO2 então não dá pra rodar `ssh-keygen -t ed25519-sk`.

Um novo, no Mercado Livre hoje, vai custar uns BRL 800. Se for usar pra trabalhar por política de segurança da empresa, eles tem que providenciar ou ressarcir pra você. Mas mesmo pra uso pessoal, recomendo investir um pouco mais na segurança.

Tendo um Yubikey 5, o procedimento é o seguinte. Comece garantindo que tem os pacotes na sua máquina:

```
sudo pacman -S yubikey-manager yubico-piv-tool opensc
```

Inicialize a aplicação PIV mudando o PIN:

```
ykman piv reset                # wipes PIV, careful
ykman piv access change-pin    # default PIN is 123456
ykman piv access change-puk    # default PUK is 12345678
```

Gere um novo par de chaves **dentro** do Yubikey:

```
ykman piv keys generate 9a pubkey.pem
```

Extraia somente a chave pública pro seu diretório local `~/.ssh`:

```
ssh-keygen -D /usr/lib/opensc-pkcs11.so -e > ~/.ssh/id_yubikey.pub
```

O conteúdo desse arquivo `~/.ssh/id_yubikey.pub` é que você vai adicionar no arquivo `~/.ssh/authorized_keys` do seu servidor remoto que quer conectar via SSH. Pra abrir uma conexão SSH pra ele, conecte o Yubikey na porta USB e execute assim:

```
ssh -I /usr/lib/opensc-pkcs11.so seu-user@server
```

Ele vai pedir seu PIN e autorizar a conexão. Se não quiser ficar digitando esse `-I` toda vez, basta editar o `~/.ssh/config` com isto:

```
# ~/.ssh/config
Host server
  PKCS11Provider /usr/lib/opensc-pkcs11.so
  User seu-user
```

**PORÉM**

Este procedimento vai usar o gerador de chaves de dentro da Yubikey, que só suporta **RSA (1024–2048)** ou **ECC (P-256, P-384)**. Se quiser gerar uma chave ED25519, o fluxo é diferente, temos que executar assim:

```
ssh-keygen -t ed25519-sk -a 100 -C "you@example.com" -f ~/.ssh/id_ed25519_sk
```

Esse arquivo `id_ed25519_sk` que ele gera na sua máquina local **não é a chave-privada** é somente um "stub" que aponta pra sua Yubikey. Então a chave fica armazenada no hardware e nunca passa pela sua máquina.

Pra adicionar sua chave-pública no servidor remoto, basta manualmente adicionar no arquivo `~/.ssh/authorized_keys` como fizemos antes ou rodar este comando pra logar com sua senha e ele vai adicionar a chave-pública pra você:

```
ssh-copy-id -i ~/.ssh/id_ed25519_sk.pub seu-user@server
```

Pra usar sua chave pra logar agora é só fazer:

```
ssh -i ~/.ssh/id_ed25519_sk seu-user@server
```

Isso só funciona porque a Yubikey 5 tem suporte a FIDO2. As antigas não tem, por isso não dá pra fazer isso.

Ah sim, no seu home server ou outro servidor, **DEPOIS** que adicionar sua chave no `authorized_keys` eu recomendo **DESABILITAR** a opção de login por senha (pra que nenhum bot fique tentando logar por força bruta). No servidor edite:

```
# /etc/ssh/sshd_config
PasswordAuthentication no
ChallengeResponseAuthentication no
KbdInteractiveAuthentication no
UsePAM no
...
PubkeyAuthentication yes
```

Ou seja, desligue todas as opções de login e deixe somente por chave pública. Agora só reinicie o serviço:

```
sudo systemctl restart sshd
```

### SSH-Agent

Pra ficar claro: a forma considerada mais segura pra gerenciar chaves privadas é via um hardware de segurança externo, no caso a Yubikey 5.

Mas, não é obrigatório. Se você tem um PC exclusivo pra trabalhar, com seu Arch Linux ou Omarchy instalado, e você não fica instalando softwares suspeitos - como jogos pirateados - nem fica acessando sites suspeitos e clicando em qualquer link (risco de malware), não é completamente ruim ter suas chaves localmente na sua máquina. Eu mesmo uso assim faz anos e nunca tive problemas - porque eu sou paranóico com segurança da minha máquina.

Lembre-se, um dos tipos de malware mais comuns são que fazem upload dos seus arquivos ou que encripta seus arquivos e depois pedem resgate de criptomoeda pra devolver. O bom e velho **RANSOMWARE**:

![Ransomware](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ransomware-message.jpg)

Isso tem não só em Windows como Mac e Linux também. E navegadores web são o principal vetor, especialmente emails de phishing com links maliciosos que você sai clicando, ou links que vem em canais de Discord, Telegram ou Whatsapp.

**NUNCA CLIQUE EM LINKS**. Copie o link, cole num terminal e veja que tipo de link que é. Se não for um domínio obviamente oficial como "whatspp.com" ou "google.com", não siga em frente.

isso tudo dito. Digamos que você criou suas chaves localmente e cadastrou no `authorized_keys` do seu servidor e na sua conta de GitHub. Agora, toda vez que fizer `ssh` ou `git push` ele vai pedir pra digitar sua **passphrase** (que, se você não for bobo, fez uma passphrase **BEM LONGA**).

Isso é extremamente inconveniente de ficar digitando o tempo todo. Por isso tem um recurso no SSH pra ajudar: cachear sua autenticação durante algum tempo fixo usando ssh-agent.

Comece criando este serviço de usuário pro systemd:

```toml
# ~/.config/systemd/user/ssh-agent.service
[Unit]
Description=SSH Agent

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK

[Install]
WantedBy=default.target
```

Habilite com privilégios do seu user (sem sudo):

```
systemctl --user enable --now ssh-agent.service
```

Exponha isso no seu `.bashrc` ou `.zshrc`:

```bash
# ~/.zshenv (or ~/.profile)
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
```

Agora, toda vez que fizer login no seu sistema e começar a trabalhar, adicione sua chave de trabalho:

```
ssh-add -t 30m ~/.ssh/id_ed25519
```

Ele vai pedir sua passphrase uma vez, mas durante **30 minutos** (que é essa opção `-t 30m`), não vai mais precisar re-digitar a passphrase e pode ficar acessando `ssh` ou fazendo `git push` de forma mais conveniente.

Se quiser remover o cache do agente, antes do timeout, pode fazer:

```
ssh-add -d ~/.ssh/id_ed25519
```

Se sua rotina de trabalho envolve usar ssh, em vez de manualmente fazer `ssh-add` pode adicionar a seguinte configuração no seu `~/.ssh/config`:

```bash
# ~/.ssh/config
Host *
  AddKeysToAgent yes
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_ed25519
```

E toda vez que abrir o terminal, ele vai pedir pra digitar sua passphrase. E isso vai durar enquanto sua sessão estiver logada.

Por fim, o nome do arquivo nos exemplos é sempre `id_ed25519` mas isso não tem relevância nenhuma, você pode renomear como quiser e inclusive criar múltiplas chaves pra usar em serviços separados, se quiser ser extra-seguro. Basta gerar chaves como `heroku_id_ed25519` ou `google_cloud_id_ed25519` e assim por diante. Crie quantas chaves quiser ou achar necessário. Isso vale tanto pra chaves locais quanto chaves na Yubikey 5.

Acho que estes são os aspectos que considero mais importante saber sobre chaves SSH, esqueci alguma outra coisa importante? Não deixe de mandar mais dicas nos comentários abaixo.
