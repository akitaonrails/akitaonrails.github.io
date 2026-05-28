---
title: "Backup de Gmail pra Maildir em Linux"
slug: "backup-gmail-maildir-linux"
date: '2026-05-28T16:00:00-03:00'
draft: false
translationKey: backup-gmail-maildir-linux
tags:
  - linux
  - backup
  - email
  - gmail
  - maildir
  - mbsync
  - restic
---

A maioria das pessoas confia no Google e deixa tudo lá. Quem acompanha o blog sabe que eu não confio em ninguém: se tá na nuvem, não é meu. Por isso tenho um NAS em casa pra fazer backup de tudo que importa. Não confio em Google Drive, OneDrive, Dropbox, e nem em Gmail.

E-mail sempre foi a parte mais chata desse exercício. Meu workflow antigo era abrir o Thunderbird, deixar ele puxar tudo de Gmail via IMAP, e fazer backup do diretório `~/.thunderbird`. Funciona, mas é manual, chato (lembrar de abrir o Thunderbird de vez em quando), e preso ao próprio Thunderbird: se quero ler aqueles e-mails em outro cliente, eles estão num formato interno proprietário.

Depois de um tempo caiu a ficha: Linux tem suporte nativo a e-mail desde sempre. Os protocolos modernos (IMAP, SMTP) são padrão aberto. E o formato de armazenamento local, **Maildir**, existe e funciona muito bem desde os anos 90. Não precisa de Thunderbird pra nada.

## O que é Maildir

Maildir foi criado pelo Daniel J. Bernstein (djb) como parte do qmail em 1995. A ideia era resolver os problemas de file locking do formato mbox, onde a caixa de e-mail inteira é um arquivo único e dois processos escrevendo ao mesmo tempo podiam corromper tudo. No Maildir, **cada mensagem vira um arquivo separado** numa estrutura de três subdiretórios:

- `tmp/` — onde o e-mail é escrito enquanto chega
- `new/` — mensagens novas, ainda não lidas
- `cur/` — mensagens já vistas pelo cliente, com flags no nome do arquivo (`:2,S` = seen, `:2,F` = flagged, etc.)

A entrega é atômica: o MTA escreve a mensagem em `tmp/`, depois faz um `rename()` pra `new/`. `rename()` em filesystem POSIX é atômico, então não tem janela de corrupção. Sem locking, sem corrupção, e cada e-mail é só um arquivo de texto puro que você pode ler com `cat`, indexar com `grep`, versionar com git se quiser.

Trinta anos depois, ainda é o formato local padrão da maioria dos clientes de e-mail Linux. E é o formato que vou usar pra fazer o mirror do Gmail.

## A ferramenta: mbsync (isync)

O que faz a ponte entre o IMAP do Gmail e o Maildir local é o [`mbsync`](https://isync.sourceforge.io/), o binário do pacote `isync`. Ele lê uma config simples (`~/.config/isyncrc`), conecta no IMAP do Gmail, e copia as mensagens pro disco. A diferença pro `offlineimap` (alternativa mais conhecida) é que `mbsync` é escrito em C, é bem mais rápido em mailboxes grandes, e tem menos casos esquisitos com Gmail.

A config é direta. Resumo do que tem no meu `~/.config/isyncrc` (sem senha, claro):

```ini
IMAPAccount minha-conta
Host imap.gmail.com
User you@example.com
PassCmd "/home/akitaonrails/.config/mbsync/bin/mbsync-password you@example.com"
TLSType IMAPS
CertificateFile /etc/ssl/certs/ca-certificates.crt
AuthMechs LOGIN

IMAPStore minha-remote
Account minha-conta

MaildirStore minha-local
SubFolders Verbatim
Path ~/.local/share/mail/mbsync/you.example.com/
Inbox ~/.local/share/mail/mbsync/you.example.com/INBOX

Channel minha-backup
Far :minha-remote:
Near :minha-local:
Patterns * !"[Gmail]/Trash" !"[Gmail]/Spam" !"[Gmail]/Drafts"
Create Near
Sync Pull New Flags
Expunge None
Remove None
```

Três pontos importantes nessa config:

1. **`Sync Pull`**: só puxa do servidor pro local. Nada que eu faça no Maildir vai propagar pro Gmail. Isso é proteção contra acidentes (se eu apagar um arquivo localmente, não some do Gmail).
2. **`Expunge None` + `Remove None`**: se uma mensagem some do Gmail (alguém apagou ou o Google decidiu mover pra lugar nenhum), ela **continua** no meu Maildir. O backup acumula histórico, não espelha o estado atual.
3. **`PassCmd` em vez de senha em texto**: a senha vai num script que faz `secret-tool lookup` no keyring do desktop. Nada de senha em arquivo de config no disco.

### O bloco da senha

O `mbsync-password` é um wrapper minúsculo que isola o segredo:

```bash
#!/usr/bin/env bash
set -euo pipefail
account="${1:?usage: mbsync-password ACCOUNT}"
password="$(secret-tool lookup service mbsync account "$account" 2>/dev/null || true)"
[ -z "$password" ] && { echo "missing keyring secret for $account" >&2; exit 1; }
printf '%s' "$password"
```

Senha é armazenada uma vez com `secret-tool store --label="mbsync gmail" service mbsync account you@example.com`. O Gmail moderno exige uma **app password** específica (16 caracteres, gerada em [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)) porque não aceita mais autenticação básica direta — você não cola sua senha do Google ali, cola uma chave gerada exclusivamente pro app, que dá pra revogar a qualquer momento sem mexer no resto da conta.

### Automação com systemd user timer

Pra não ter que rodar o mbsync na mão, montei dois user units no systemd. Primeiro o serviço, que é só uma chamada do script wrapper:

```ini
# ~/.config/systemd/user/mbsync-backup.service
[Unit]
Description=Mirror Gmail accounts locally with mbsync
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=%h/.config/mbsync/bin/mbsync-run
```

E o timer que dispara o serviço periodicamente:

```ini
# ~/.config/systemd/user/mbsync-backup.timer
[Unit]
Description=Run mbsync periodically

[Timer]
OnBootSec=10m
OnUnitActiveSec=30m
Persistent=true
Unit=mbsync-backup.service

[Install]
WantedBy=timers.target
```

`OnBootSec=10m` espera 10 minutos depois do boot pra primeira execução (evita brigar com o network-online no início da sessão). `OnUnitActiveSec=30m` re-dispara 30 minutos depois de cada execução terminar. `Persistent=true` faz com que, se a máquina estava desligada na hora que seria pra disparar, ele compense rodando logo no próximo boot. O wrapper já pega `flock` pra não rodar dois mbsync em paralelo, então se uma sincronização demorar mais que 30min, a próxima só espera. Tudo loga em `~/.local/state/mbsync/mbsync.log`.

Pra gerenciar o timer, os comandos básicos:

```bash
# Re-ler os arquivos depois de criar/editar
systemctl --user daemon-reload

# Ativar agora + habilitar pra subir no próximo boot
systemctl --user enable --now mbsync-backup.timer

# Conferir se o timer tá ativo e quando dispara da próxima vez
systemctl --user status mbsync-backup.timer
systemctl --user list-timers mbsync-backup.timer

# Disparar uma sincronização imediata sem esperar o intervalo
systemctl --user start mbsync-backup.service

# Acompanhar logs em tempo real
journalctl --user -u mbsync-backup.service -f

# Conferir status da última execução do serviço
systemctl --user status mbsync-backup.service

# Pra desligar tudo
systemctl --user disable --now mbsync-backup.timer
```

Pra que o timer continue rodando quando você não está logado (útil em desktop que fica ligado 24/7), habilite linger uma única vez: `sudo loginctl enable-linger $USER`. Sem isso, os user units só rodam enquanto você tem sessão ativa.

Ativa, confere o status uma vez pra ter certeza que tá verde, e esquece que existe.

## Backup do Maildir com restic

Agora que o Gmail está espelhado em `~/.local/share/mail/`, ele entra no mesmo pipeline de backup do resto do meu home. Eu uso o [restic](https://restic.net/) pra mandar snapshots criptografados pro NAS. O restic é incremental por content-addressable storage, então adicionar 100MB de e-mail no snapshot diário custa basicamente o delta — não os 100MB inteiros toda vez. Pra cópia off-site, meu NAS Synology já tem o pacote Glacier Backup nativo, que cuida de mandar snapshots criptografados pro AWS Glacier sem eu precisar configurar nada além do bucket e da chave. O Maildir entra junto no mesmo plano, então o backup off-site sai de graça em termos de configuração extra.

O Maildir é amigável a backup incremental por construção: cada e-mail é um arquivo imutável (nem o nome muda depois de baixado, exceto pela flag de seen/flagged). O restic deduplica perfeitamente. Snapshot de mailbox de 5GB tem custo marginal próximo de zero depois do primeiro.

## A vantagem do formato aberto: muitos clientes

Aqui mora a parte que me convenceu de vez. Maildir é um padrão aberto, então **qualquer cliente que entenda Maildir lê o mesmo backup**. Eu posso:

- Abrir no [mutt](http://www.mutt.org/) ou [neomutt](https://neomutt.org/) quando quero algo rápido no terminal.
- Abrir no [aerc](https://aerc-mail.org/) quando quero TUI mais moderna.
- Apontar o Thunderbird ou [Claws Mail](https://www.claws-mail.org/) pra `~/.local/share/mail/...` quando quero GUI.
- Migrar pra outro cliente no futuro sem ter que exportar/importar nada.

Os e-mails são meus. Vivem no meu disco. Em formato texto, legível por qualquer ferramenta.

## Bônus: scripts e bots leem direto

A consequência menos óbvia disso é que, se eu quiser construir um filtro, um bot, um classificador, ou qualquer coisa que mexe nos e-mails, eu **não preciso passar por OAuth do Gmail, criar projeto no Google Cloud, gerenciar refresh tokens, lidar com quota** — nada. Eu leio direto do Maildir.

O Python tem suporte nativo a Maildir na biblioteca `mailbox`. Um exemplo bobo pra listar assuntos da inbox:

```python
import mailbox
from email.header import decode_header

inbox = mailbox.Maildir("/home/akitaonrails/.local/share/mail/mbsync/you.example.com/INBOX")

for key, msg in inbox.iteritems():
    subject = msg.get("Subject", "")
    sender = msg.get("From", "")
    # decode_header lida com Subject em UTF-8 / latin-1 / etc
    decoded = "".join(
        part.decode(enc or "utf-8") if isinstance(part, bytes) else part
        for part, enc in decode_header(subject)
    )
    print(f"{sender[:40]:<40}  {decoded[:60]}")
```

Roda em milissegundos, não consome quota de API nenhuma, não tem rate limit, não precisa renovar credencial. É só leitura de arquivos. Se você quer fazer um pipeline mais sério (parser de anexos, classificação por LLM, regras automáticas), o mesmo princípio se aplica.

## Resumo

A combinação que finalmente me deixou tranquilo:

- **mbsync** (isync) puxa do IMAP do Gmail pra Maildir local, automaticamente via systemd timer.
- **Maildir** preserva o formato aberto, cada e-mail é um arquivo, pull-only protege contra exclusão acidental.
- **restic** snapshota o Maildir pro NAS com deduplicação ridícula, e o Glacier Backup do Synology leva isso pra off-site cifrado.
- **Cliente de e-mail livre** — mutt, neomutt, aerc, Thunderbird, Claws, qualquer um lê.
- **Automação leve** — bot ou script lê direto do disco, sem OAuth, sem API.

O Gmail vira só uma interface web confortável pra ler e responder. A propriedade real dos e-mails está no meu disco, replicada no NAS, replicada em backup off-site cifrado. Se o Google fechar minha conta amanhã (já aconteceu com gente), perco a interface, mas mantenho a história inteira. Pra mim é o jeito definitivo de fazer isso. Recomendo.
