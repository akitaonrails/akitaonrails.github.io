---
title: "AI Agents: Garantindo a Proteção do seu Sistema"
slug: "ai-agents-garantindo-a-protecao-do-seu-sistema"
date: 2026-01-10T11:50:36-0300
draft: false
tags:
- AI
- Linux
- Bubblewrap
- Sandbox
---

Hoje em dia temos dezenas de Agentes de IA pra programação, seja Cursor, Claude Code, Windsurf, Copilot, OpenCode, Crush e mais. Mas tem um problema que já virou até meme: o risco deles danificarem seu sistema ou enviar seus dados privados pra alguém na Internet (comportamento de malware).

O problema é que pra serem eficientes, essas ferramentas precisam ter acesso ao seu sistema de arquivos pra vasculhar os arquivos do seu projeto, pra analizar o código. E mais: conseguir rodar ferramentas como compiladores, linters, e coisas mundanas como grep, sed, awk, ls, e outros comandos do seu sistema.

Eventualmente, uma LLM pode mandar executar um `rm -Rf /` aleatório e apagar coisas no seu sistema, por exemplo. O código em si, se por acidente apagar o que não devia, teoricamente você deveria estar seguro porque seu código já deveria estar, no mínimo, num repositório de Git (GitHub, GitLab, etc), então seria só reverter a mudança. Mas se o agente rodar um `rm` fora do diretório do seu projeto, pode criar todo tipo de problema.

Não é comum isso acontecer e todas as ferramentas costumam ter checagens pra isso, incluindo perguntar se você quer realmente executar o comando. Ao mesmo tempo, eles também tem a opção de permitir rodar qualquer comando durante a sessão, sem perguntar - porque uma hora começa a ficar tedioso dar "ok" pra cada comando individual. Todo mundo acaba ficando com preguiça e diz _"foda-se, roda o que quiser"_.

E vocês devem estar pensando _"ah, minha ferramenta X é bem comportada, ele sempre pergunta antes de rodar qualquer coisa, então eu controlo"_. Não esqueçam: **ATAQUES DE SUPPLY-CHAIN** existem. Toda hora alguma biblioteca open source é invadida com malware e os programas que usam essas libs acabam sendo infectados sem saber. Isso já aconteceu várias vezes, em várias libs de NPM por exemplo. Não tem como garantir que mesmo um software open source seja confiável. Sempre parta do princípio que tudo é inseguro até prova em contrário e trate esses programas dessa forma: com restrição máxima.

Pra garantir que esses agentes realmente não vão fazer nada fora do diretório do projeto, o melhor é criar um **JAIL**. E aqui vai o comando pra isso:

```bash
bwrap --ro-bind /usr /usr \
      --ro-bind /bin /bin \
      --ro-bind /lib /lib \
      --ro-bind /lib64 /lib64 \
      --dev /dev \
      --proc /proc \
      --bind $(pwd) $(pwd) \
      --chdir $(pwd) \
      --unshare-all \
      --share-net \
      bash
```

`bwrap` é o **Bubblewrap** um dos componentes que permitem a existência de coisas como **Flatpak**. Ele cria um sandbox. O Bash que vai rodar ao executar o comando acima está essencialmente em "jail", ou seja, "preso". Nele damos acesso somente de leitura a alguns diretórios do sistema caso precise de bibliotecas e ferramentas. Pra isso serve o `--ro-bind`.

Mas somente o diretório corrente `pwd` vai ter permissão de escrita. Qualquer comando que rodar dentro desse jail não tem permissão de escrever em nenhum outro lugar o seu sistema. Veja o exemplo na foto abaixo onde eu tento apagar um arquivo na minha `$HOME`:

![sandbox](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260110120225_screenshot-2026-01-10_12-02-14.png)

Ele não consegue nem listar os arquivos na minha home. É tudo invisível dentro do sandbox. Essa é uma das vantagens de apps rodando com Flatpak: eles são muito mais isolados do que apps instalados direto.

Dentro desse bash em sandbox podemos agora executar `opencode`, `crush`, `cursor` ou qualquer outro agente e ter certeza que eles não vão fazer nenhuma besteira no seu sistema.

Pra facilitar, recomendo criar um script como `~/.local/bin/ai-jail`:

```bash
#!/bin/bash

# ai-jail — bubblewrap sandbox for AI coding agents
# Mounts the project dir read-write, auto-discovers home dotfiles with a
# deny-list for sensitive dirs, and isolates namespaces.
#
# Usage: ai-jail [--map PATH]... COMMAND [ARGS...]
#        ai-jail claude
#        ai-jail bash

PROJECT_DIR=$(pwd)
TEMP_HOSTS=$(mktemp /tmp/bwrap-hosts.XXXXXX)

trap 'rm -f "$TEMP_HOSTS"' EXIT

# ── Mise discovery ─────────────────────────────────────────────
REAL_MISE_BIN=$(type -p mise 2>/dev/null || echo "")

# ── Localhost fix (Go resolver needs /etc/hosts) ───────────────
printf '127.0.0.1 localhost ai-sandbox\n::1       localhost ai-sandbox\n' > "$TEMP_HOSTS"

# ── Parse --map arguments ─────────────────────────────────────
EXTRA_MOUNTS=()
while [[ "${1:-}" == "--map" ]]; do
    MAP_PATH="$2"
    if [ -e "$MAP_PATH" ]; then
        EXTRA_MOUNTS+=("--ro-bind" "$MAP_PATH" "$MAP_PATH")
    else
        echo "Warning: Path $MAP_PATH not found, skipping." >&2
    fi
    shift 2
done

# ── Mise init command ──────────────────────────────────────────
if [ -n "$REAL_MISE_BIN" ]; then
    MISE_INIT="$REAL_MISE_BIN trust && eval \"\$($REAL_MISE_BIN activate bash)\" && eval \"\$($REAL_MISE_BIN env)\""
else
    MISE_INIT="true"
fi

# ── Dotfile deny-list (never mounted — sensitive data) ─────────
DOTDIR_DENY=(.gnupg .aws .docker .mozilla .basilisk-dev .cache .sparrow)

# Subdirs of ~/.config to hide (tmpfs over rw config mount)
CONFIG_DENY=(BraveSoftware Bitwarden)

# Dotdirs requiring read-write access
DOTDIR_RW=(.claude .crush .codex .aider .config)

# ── Helper functions ───────────────────────────────────────────
is_denied() {
    local name="$1"
    for d in "${DOTDIR_DENY[@]}"; do [[ "$name" == "$d" ]] && return 0; done
    return 1
}

is_rw() {
    local name="$1"
    for d in "${DOTDIR_RW[@]}"; do [[ "$name" == "$d" ]] && return 0; done
    return 1
}

# ── Auto-discover dot-directories in $HOME ─────────────────────
# Only directories — regular dotfiles (e.g. .claude.json) are NOT mounted.
# The tmpfs $HOME is writable so tools can create dotfiles as needed.
DOTFILE_MOUNTS=()
for entry in "$HOME"/.*; do
    [ -d "$entry" ] || continue
    name=$(basename "$entry")
    [[ "$name" == "." || "$name" == ".." ]] && continue
    is_denied "$name" && continue

    if is_rw "$name"; then
        DOTFILE_MOUNTS+=("--bind" "$entry" "$HOME/$name")
    else
        DOTFILE_MOUNTS+=("--ro-bind" "$entry" "$HOME/$name")
    fi
done

# ── Explicit dotfile mounts (regular files) ────────────────────
[ -f "$HOME/.gitconfig" ] && DOTFILE_MOUNTS+=("--ro-bind" "$HOME/.gitconfig" "$HOME/.gitconfig")
[ -f "$HOME/.claude.json" ] && DOTFILE_MOUNTS+=("--bind" "$HOME/.claude.json" "$HOME/.claude.json")

# ── Hide sensitive subdirs inside ~/.config (after rw mount) ───
CONFIG_HIDE_MOUNTS=()
for denied in "${CONFIG_DENY[@]}"; do
    [ -d "$HOME/.config/$denied" ] && CONFIG_HIDE_MOUNTS+=("--tmpfs" "$HOME/.config/$denied")
done

# ── Override ~/.local subdirs as rw (parent .local is ro) ──────
LOCAL_OVERRIDES=()
[ -d "$HOME/.local/state" ] && LOCAL_OVERRIDES+=("--bind" "$HOME/.local/state" "$HOME/.local/state")
for rw_share in zoxide crush opencode atuin mise yarn; do
    [ -d "$HOME/.local/share/$rw_share" ] && LOCAL_OVERRIDES+=("--bind" "$HOME/.local/share/$rw_share" "$HOME/.local/share/$rw_share")
done

# ── Assemble and launch ───────────────────────────────────────
echo "Jail Active: $PROJECT_DIR"

bwrap \
  --ro-bind /usr /usr \
  --symlink usr/bin /bin \
  --symlink usr/lib /lib \
  --symlink usr/lib /lib64 \
  --ro-bind /etc /etc \
  --ro-bind "$TEMP_HOSTS" /etc/hosts \
  --ro-bind /opt /opt \
  --ro-bind /sys /sys \
  --dev /dev \
  --proc /proc \
  --tmpfs /tmp \
  --tmpfs /run \
  --tmpfs "$HOME" \
  "${DOTFILE_MOUNTS[@]}" \
  "${CONFIG_HIDE_MOUNTS[@]}" \
  "${LOCAL_OVERRIDES[@]}" \
  "${EXTRA_MOUNTS[@]}" \
  --bind "$PROJECT_DIR" "$PROJECT_DIR" \
  --chdir "$PROJECT_DIR" \
  --die-with-parent \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --hostname "ai-sandbox" \
  --setenv PS1 "(jail) \w \$ " \
  bash -c "$MISE_INIT && ${*:-bash}"
```

Esta versão é bem customizada, deem uma boa lida porque tem deny-list pra que só diretórios de que você realmente precisa dentro do Jail estejam disponíveis. Alguns são read-write porque um Claude precisa conseguir escrever em `~/.claude` ou Codex precisa do `~/.codex`; vários diretórios nunca devem ir pra dentro do Jail como repositório de senhas de um Brave ou BitWarden. O resto de que pode precisar deve ser tudo read-only. Esse script cuida de tudo isso.

Só fazer `chmod +x ~/.local/bin/ai-jail`. Agora podemos executar ele direto ou já passar o comando que queremos rodar no sandbox:

```
~/.local/bin/ai-jail crush
```

Nesta versão ele vai criar um diretório `$HOME` temporário, caso ele precise gravar algo temporário lá. E também mandei mapear o seu `~/.config` pros agentes terem acesso às suas configurações. Se precisar de mais coisas como variáveis de ambiente e coisas assim, modifique pra mapear essas coisas também, mas isso é o mínimo pra conseguir montar um sandbox seguro.

Tome muito cuidado com programas que rodam comandos aleatórios no seu sistema. Nada é 100% seguro, especialmente uma LLM que pode halucinar a qualquer momento e decidir apagar coisas, ou ferramentas suspeitas que você baixou sem ter certeza da origem e pode ser um malware disfarçado. Sempre rode coisas realmente suspeitas somente numa VM ou, no mínimo, dentro de um jail como esse.

Isso não serve só pra agentes de IA, lógico. Toda vez que for rodar qualquer comando que tem dúvidas ou ache suspeito, rode dentro desse jail.

De bônus, note que eu também mapeio o [Mise](https://akitaonrails.com/2025/09/07/omarchy-2-0-mise-pra-organizar-ambientes-de-desenvolvimento/) pra dentro do container. Se você usa Omarchy, deve estar usando Mise também.

Especificamente pra Claude Code, que eu mais uso, prefiro não deixar tudo autorizado no modo automático `--allow-dangerously-skip-permissions`, mas também não gosto de ter que ficar autorizando coisa besta como cada domínio que ele quer pesquisar na web (só pesquisar não tem problema nenhum) ou qualquer comando que só lista coisas como `ls` ou `grep` então dá pra melhorar configurando direto em `~/.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git status *)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(git branch *)",
      "Bash(git checkout *)",
      "Bash(git switch *)",
      "Bash(git stash *)",
      "Bash(git show *)",
      "Bash(git fetch *)",
      "Bash(git pull *)",
      "Bash(git merge *)",
      "Bash(git tag *)",
      "Bash(git remote -v*)",
      "Bash(git rev-parse *)",
      "Bash(git ls-files *)",
      "Bash(ls *)",
      "Bash(find *)",
      "Bash(grep *)",
      "Bash(wc *)",
      "Bash(cat *)",
      "Bash(head *)",
      "Bash(tail *)",
      "Bash(file *)",
      "Bash(which *)",
      "Bash(echo *)",
      "Bash(pwd)",
      "Bash(cd *)",
      "Bash(ps *)",
      "Bash(env *)",
      "Bash(printenv *)",
      "Bash(mkdir *)",
      "Bash(cp *)",
      "Bash(mv *)",
      "Bash(touch *)",
      "Bash(npm *)",
      "Bash(npx *)",
      "Bash(yarn *)",
      "Bash(pnpm *)",
      "Bash(bun *)",
      "Bash(node *)",
      "Bash(ruby *)",
      "Bash(bundle *)",
      "Bash(rails *)",
      "Bash(rake *)",
      "Bash(go *)",
      "Bash(cargo *)",
      "Bash(rustc *)",
      "Bash(python *)",
      "Bash(pip *)",
      "Bash(docker compose *)",
      "Bash(docker ps *)",
      "Bash(docker logs *)",
      "Bash(docker images *)",
      "Bash(make *)",
      "Bash(gh *)",
      "Bash(curl *)",
      "Bash(jq *)",
      "Bash(sed *)",
      "Bash(awk *)",
      "Bash(sort *)",
      "Bash(uniq *)",
      "Bash(diff *)",
      "Bash(* --version)",
      "Bash(* --help)",
      "WebSearch",
      "WebFetch"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(rm -r *)",
      "Bash(sudo *)",
      "Bash(chmod 777 *)",
      "Bash(git reset --hard *)",
      "Bash(git clean *)",
      "Bash(git push --force *)",
      "Bash(git push -f *)",
      "Bash(docker rm *)",
      "Bash(docker rmi *)",
      "Bash(docker system prune *)"
    ],
    "ask": [
      "Bash(git push *)",
      "Bash(git rebase *)",
      "Bash(git branch -D *)",
      "Bash(git branch -d *)",
      "Bash(rm *)",
      "Bash(kamal *)",
      "Bash(docker run *)",
      "Bash(docker exec *)",
      "Bash(docker stop *)"
    ],
    "defaultMode": "acceptEdits"
  },
  "enabledPlugins": {
    "gopls-lsp@claude-plugins-official": true,
    "typescript-lsp@claude-plugins-official": true,
    "pyright-lsp@claude-plugins-official": true,
    "rust-analyzer-lsp@claude-plugins-official": true,
    "github@claude-plugins-official": true,
    "pr-review-toolkit@claude-plugins-official": true,
    "frontend-design@claude-plugins-official": true
  },
  "alwaysThinkingEnabled": true
}
```

Pesquise a documentação (ou pergunte direto pro próprio Claude) sobre mais customizações que dá pra fazer nesse arquivo pra servir melhor pro seu tipo de projeto de fluxo de trabalho.

É basicamente assim que um container de Docker ou Podman funciona também. Eu expliquei isso no meu [video sobre Docker](https://akitaonrails.com/2023/03/02/akitando-139-entendendo-como-containers-funcionam/). Se não assistiu ainda, recomendo ver.
