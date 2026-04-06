---
title: "ai-jail: Sandbox para Agentes de IA — De Shell Script a Ferramenta Real"
slug: "ai-jail-sandbox-para-agentes-de-ia-de-shell-script-a-ferramenta-real"
date: 2026-03-01T14:00:00-03:00
draft: false
tags:
- AI
- Linux
- Bubblewrap
- Sandbox
- Rust
- Security
translationKey: ai-jail-sandbox-tool
---

Este post é um follow-up direto do [AI Agents: Garantindo a Proteção do seu Sistema](/2026/01/10/ai-agents-garantindo-a-protecao-do-seu-sistema/), onde eu mostrei como usar bubblewrap pra criar um jail manual pros seus agentes de IA. Se não leu, leia antes de continuar.

--

Em janeiro publiquei um shell script de ~170 linhas que montava um sandbox com bubblewrap pra rodar Claude Code, OpenCode, Crush e qualquer outro agente de IA. Funcionava. Resolvia o problema. Mas era um script bash jogado em `~/.local/bin/` que você tinha que copiar, colar, e rezar pra não precisar customizar demais.

Dois meses usando aquele script todo dia me mostraram os limites. Queria configuração por projeto. Queria suporte a macOS pros devs do meu time. Queria parar de editar arrays em bash toda vez que precisava de um diretório extra. E queria algo que alguém pudesse instalar com `brew install` ou `cargo install` em 10 segundos, sem ler 170 linhas de script.

Resultado: [ai-jail](https://github.com/akitaonrails/ai-jail). Uma ferramenta em Rust, ~880KB, 4 dependências, 124 testes, que faz exatamente o que aquele script fazia e mais. Vou explicar o que mudou e por que você deveria estar usando.

## O Problema (de novo, pra quem pulou o post anterior)

Agentes de IA pra programação precisam de acesso ao seu filesystem. Precisam rodar compiladores, linters, grep, ls, make, cargo, npm. O mínimo pra serem úteis. O problema é que junto com esse acesso vem a capacidade de ler `~/.aws/credentials`, exportar suas chaves SSH, ou rodar um `rm -rf` fora do diretório do projeto.

Não é paranoia. Supply-chain attacks são reais. Toda hora uma lib de NPM, PyPI, ou RubyGems é comprometida. Se o agente rodar `npm install` e um post-install script malicioso tentar exfiltrar seus dados, a única coisa entre o atacante e suas credenciais é o que você montou de barreira antes.

A resposta é um sandbox. Especificamente, um que permita o agente trabalhar no diretório do projeto com as ferramentas que precisa, mas que torne invisível todo o resto do sistema.

## De Script pra Ferramenta

O shell script do post anterior já resolvia isso com bubblewrap. O ai-jail resolve o mesmo problema, mas trata as limitações que dois meses de uso diário revelaram:

| Shell script | ai-jail |
|-------------|---------|
| Configuração editando arrays bash | Arquivo `.ai-jail` TOML por projeto |
| Só Linux | Linux + macOS |
| GPU/Docker/Display hardcoded | Auto-detecção com flags pra desligar |
| Sem dry-run | `--dry-run --verbose` mostra tudo |
| Sem lockdown | `--lockdown` pra modo paranóico |
| Copiar/colar pra instalar | `brew install`, `cargo install`, `mise` |
| Sem bootstrap | `--bootstrap` gera configs de permissão pro Claude/Codex/OpenCode |

A lógica core é a mesma: bubblewrap cria namespaces isolados de PID, UTS, IPC, monta o `$HOME` como tmpfs efêmero, e só monta o diretório do projeto com escrita. A diferença é que agora tudo isso é configurável sem editar código.

## Instalação

Quatro formas:

```bash
# Homebrew (macOS e Linux)
brew tap akitaonrails/tap && brew install ai-jail

# Cargo
cargo install ai-jail

# Mise
mise use -g ubi:akitaonrails/ai-jail

# Binário direto do GitHub Releases
curl -fsSL https://github.com/akitaonrails/ai-jail/releases/latest/download/ai-jail-linux-x86_64.tar.gz | tar xz
sudo mv ai-jail /usr/local/bin/
```

No Linux, bubblewrap precisa estar instalado separadamente: `pacman -S bubblewrap` (Arch), `apt install bubblewrap` (Debian/Ubuntu), `dnf install bubblewrap` (Fedora). No macOS não precisa de nada extra.

## Uso Básico

```bash
cd ~/Projects/meu-app

# Roda Claude Code dentro do sandbox
ai-jail claude

# Roda Codex
ai-jail codex

# Roda OpenCode
ai-jail opencode

# Bash puro pra debug
ai-jail bash

# Qualquer comando
ai-jail -- python script.py
```

Na primeira execução, ele cria um arquivo `.ai-jail` no diretório do projeto:

```toml
# ai-jail sandbox configuration
# Edit freely. Regenerate with: ai-jail --clean --init

command = ["claude"]
rw_maps = []
ro_maps = []
```

Esse arquivo é commitável no repo. Quando outro dev do seu time clona o projeto e roda `ai-jail`, a mesma configuração se aplica.

Se quiser adicionar diretórios extras, pode fazer pela CLI ou direto no TOML:

```bash
# Diretório extra com escrita
ai-jail --rw-map ~/Projects/shared-lib claude

# Diretório extra somente leitura
ai-jail --map /opt/datasets claude
```

Quer ver o que o sandbox vai fazer sem executar nada?

```bash
ai-jail --dry-run --verbose claude
```

Isso mostra cada mount point, cada flag de isolamento, o comando completo do bubblewrap. Sem surpresas.

## Por Que Bubblewrap no Linux

Avaliei as alternativas antes de decidir. O [documento completo de análise](https://github.com/akitaonrails/ai-jail/blob/master/docs/sandbox-alternatives.md) tá no repositório, mas o resumo é:

Bubblewrap (bwrap) é o sandbox que o Flatpak usa pra isolar todo app desktop. ~50KB de binário, ~4000 linhas de C, mantido pelo time do GNOME. Roda sem root usando `CLONE_NEWUSER` pra criar namespaces sem privilégio elevado. Tá empacotado em toda distro Linux relevante e testado em escala por milhões de instalações Flatpak.

Considerei e descartei as alternativas. Firejail requer setuid root, e confiar em setuid pra proteger contra agentes que já rodam no seu sistema é contraditório. nsjail e minijail são projetados pra ambientes de produção (Google os usa internamente), complexos demais pra workstation de dev. systemd-nspawn requer root e é pra containers de sistema, não pra isolar um processo.

Landlock é um caso diferente. Ele não substitui bubblewrap — não tem nada a ver com namespaces ou mount isolation. Mas complementa. Landlock é um LSM (Linux Security Module) que controla acesso no nível do VFS, independente dos mount namespaces. Isso fecha vetores que o bwrap sozinho não cobre: rotas de escape pelo `/proc`, tricks com symlinks dentro de mounts permitidos, e serve como seguro contra bugs no próprio mecanismo de namespaces. A partir da v0.4.0, o ai-jail aplica Landlock automaticamente em kernels 5.13+ como defense-in-depth. Usa ABI V3 (Linux 6.2+) com degradação graceful pra V1 em kernels mais antigos, e vira no-op silencioso se o kernel não suportar. Se causar problema com alguma ferramenta específica, `--no-landlock` desativa.

Bubblewrap acerta no ponto exato: isolamento real sem root, em toda distro, e simples o suficiente pra wrappear num binário de 880KB.

## O Que o Sandbox Faz no Linux

Quando você roda `ai-jail claude`, o seguinte acontece:

O agente roda em namespaces isolados de PID, UTS e IPC, com hostname `ai-sandbox`, e morre automaticamente se o pai morrer (`--die-with-parent`).

O filesystem é montado numa sequência específica (bubblewrap é order-dependent). `/usr`, `/etc`, `/opt`, `/sys` entram read-only pras ferramentas do sistema. `/dev` e `/proc` montados pra acesso a devices e processos. `/tmp` e `/run` como tmpfs frescos. GPUs auto-detectadas (`/dev/nvidia*`, `/dev/dri`). Docker socket, X11/Wayland, `/dev/shm`, tudo auto-detectado e montado se existir.

A parte mais importante é o tratamento do home directory. `$HOME` é montado como tmpfs vazio. Depois, seletivamente, dotfiles são layered por cima. `.gnupg`, `.aws`, `.ssh`, `.mozilla`, `.sparrow` nunca são montados (dados sensíveis). `.claude`, `.crush`, `.codex`, `.aider`, `.config`, `.cargo`, `.cache`, `.docker` entram como read-write porque os agentes precisam escrever aqui. Todo o resto entra read-only. Dentro de `~/.config`, subdiretórios de browser são escondidos atrás de tmpfs: `BraveSoftware`, `Bitwarden`. Mesma coisa em `~/.cache`: `BraveSoftware`, `chromium`, `spotify`, `nvidia`. O agente não consegue nem ver que esses diretórios existem.

O diretório corrente do projeto é o único lugar com permissão de escrita (além dos dotdirs de ferramentas). O agente modifica o código, mas não toca no resto.

## macOS: sandbox-exec

No macOS, o backend é o `sandbox-exec` com profiles SBPL (Sandbox Profile Language). É uma API legada da Apple, depreciada oficialmente mas sem substituto público. Funciona hoje, mas a Apple pode remover no futuro.

O ai-jail gera um profile SBPL em runtime que replica a mesma lógica do Linux:

- Default deny em tudo
- Permite operações de processo (exec, fork, signal)
- Permite rede (exceto em lockdown)
- Permite leitura global, nega paths sensíveis (`.gnupg`, `.aws`, `.ssh`, `~/Library/Keychains`, `~/Library/Mail`)
- Permite escrita só em diretório do projeto, dotfiles de ferramentas, e `/tmp`

As limitações são reais. GPU (Metal) e Display (Cocoa) são system-level no macOS, sandbox-exec não consegue restringir. As flags `--no-gpu` e `--no-display` simplesmente não têm efeito no macOS. A paridade entre plataformas é aproximada, não exata.

Mesmo com essas limitações, é melhor do que rodar o agente completamente aberto. O sandbox-exec protege contra acesso a filesystem sensível e, em lockdown, remove permissões de escrita e rede.

## Windows: Não Suportado (E Provavelmente Nunca Será)

Não é falta de vontade, é falta de primitivas. Windows não tem equivalente userspace a Linux namespaces. Não tem mount API como bubblewrap. AppContainers existem mas usam um modelo de segurança completamente diferente, requerem privilégios de admin, e mapear a funcionalidade do bwrap pra AppContainers seria efetivamente escrever outro projeto do zero.

A solução pra Windows é WSL 2:

```bash
# No WSL 2 (kernel Linux real)
sudo apt install bubblewrap
cargo install ai-jail
# ou: mise use -g ubi:akitaonrails/ai-jail

cd /mnt/c/Users/voce/Projects/meu-app
ai-jail claude
```

WSL 2 roda um kernel Linux de verdade. Bubblewrap funciona normalmente. Os arquivos do Windows ficam acessíveis em `/mnt/c/`. Performance de I/O é mais lenta pelo mount de 9p, mas funciona. Pra projetos grandes, clonar dentro de `~/Projects/` no lado Linux melhora a performance consideravelmente.

## Lockdown Mode

Pra workloads que você realmente não confia, existe `--lockdown`:

```bash
ai-jail --lockdown bash
```

Lockdown faz tudo que o modo normal faz, mas vai além. O projeto é montado read-only (não read-write). GPU, Docker, Display e mise são desabilitados. Flags `--rw-map` e `--map` são ignoradas. `$HOME` vira tmpfs puro, sem dotfiles do host. No Linux, a rede é cortada com `--unshare-net` e o ambiente é limpo com `--clearenv`. No macOS, as variáveis de ambiente são limpas e as regras de escrita e rede são removidas do SBPL.

É o sandbox mais restritivo que dá pra fazer sem usar uma VM. Útil pra auditar código de terceiros ou rodar agentes em projetos que você não conhece.

## Bootstrap: Configuração Automática de Permissões

`ai-jail --bootstrap` gera configurações de permissão pras ferramentas que você usa:

```bash
ai-jail --bootstrap
```

Pro **Claude Code**, gera `~/.claude/settings.json` com listas de allow/deny/ask. Permite git status, diff, log, ls, grep, cargo, npm, python, docker compose. Bloqueia rm -rf, sudo, chmod 777, git push --force. Pergunta antes de git push, rm, docker run.

Pro **Codex**, gera `~/.codex/config.toml` com `approval_policy = "on-request"`.

Pro **OpenCode**, gera `~/.config/opencode/opencode.json` com permissões de bash, edit, write.

Antes de sobrescrever qualquer arquivo, faz backup automático (`settings.json.bak`). E rejeita operações se o alvo for um symlink, pra evitar path traversal.

É exatamente o conteúdo que eu coloquei manualmente no [post anterior](/2026/01/10/ai-agents-garantindo-a-protecao-do-seu-sistema/), mas automatizado e testado.

## Mas o Claude Code Já Tem Sandbox Próprio

Tem. Desde outubro de 2025, o Claude Code oferece um sandbox runtime via o comando `/sandbox`. E adivinhe o que ele usa por baixo? Bubblewrap no Linux e sandbox-exec no macOS. O mesmo stack.

Mas as diferenças importam.

ai-jail é agnóstico de ferramenta. Funciona com Claude, Codex, OpenCode, Crush, e qualquer comando. O sandbox do Claude só protege o Claude. Se amanhã você trocar de agente, o ai-jail continua funcionando igual.

O ponto que mais me incomoda é o escape hatch. Quando um comando falha por restrição de sandbox, o Claude pode tentar novamente com `dangerouslyDisableSandbox`, caindo de volta no fluxo normal de permissões. Dá pra desabilitar isso (`"allowUnsandboxedCommands": false`), mas é opt-out, não opt-in. No ai-jail, não existe escape hatch. O processo roda dentro do bwrap ou do sandbox-exec, ponto. Não tem como o agente decidir sozinho sair do sandbox.

Outra diferença prática: o `.ai-jail` vive no diretório do projeto e pode ser commitado no repositório. Qualquer dev que clona o projeto herda a mesma política de sandbox. O sandbox do Claude depende de `settings.json` global.

Quando roda dentro de Docker, o sandbox do Claude cai pra um modo `enableWeakerNestedSandbox` que, nas palavras da própria documentação, *"considerably weakens security"*. O ai-jail não foi projetado pra rodar dentro de Docker (ele roda diretamente na workstation do dev), então esse problema não existe.

Sobre rede: o sandbox do Claude roteia tráfego por um proxy e permite/bloqueia por domínio. ai-jail no modo normal herda a rede do host; no lockdown, corta a rede inteira com `--unshare-net`. A abordagem do Claude é mais granular; a do ai-jail é mais simples e mais difícil de contornar.

Os dois não são mutuamente exclusivos. Dá pra rodar o sandbox do Claude dentro do ai-jail. O ai-jail cuida do isolamento de filesystem; o sandbox do Claude adiciona filtragem de rede por domínio. Layers de segurança se somam.

## Por Que Não Usar --dangerously-skip-permissions Sem Jail

Vou ser direto: se você roda Claude Code com `--dangerously-skip-permissions` sem nenhum sandbox, tá confiando cegamente que a LLM nunca vai executar algo destrutivo. E tá confiando que nenhuma dependência do seu projeto foi comprometida num supply-chain attack.

Toda flag `--dangerously` tem esse nome por um motivo. O Claude Code é explícito: esse modo existe pra CI/CD e automação em ambientes já isolados (containers, VMs descartáveis). Não pra sua workstation pessoal com `~/.aws/credentials`, `~/.gnupg/`, SSH keys, e o banco de senhas do seu browser.

Com ai-jail, o agente tem autonomia total dentro do sandbox. Faz o que quiser no diretório do projeto, usa as ferramentas que precisa, e não consegue acessar nada fora do que foi explicitamente permitido.

## ai-jail + Git: A Rede de Segurança que Você Já Tem

Tem uma coisa que eu não mencionei ainda e que muda o cálculo de risco: se o seu projeto tá num repositório Git, com remote no GitHub/GitLab, e o agente não tem permissão de `git push`, o dano que ele consegue causar é limitado ao diretório local.

Pense assim. O pior cenário dentro do ai-jail é o agente corromper todos os arquivos do projeto. Irritante? Sim. Catastrófico? Não. Você faz `git checkout .` e volta ao último commit. Se ele corromper o `.git` de alguma forma (improvável, mas possível), você deleta o diretório e clona de novo. O remote não foi tocado.

Por isso o `--bootstrap` do ai-jail coloca `git push` na lista de "ask" (perguntar antes), não na lista de "allow". E `git push --force` vai direto pra "deny". O agente pode commitar à vontade localmente, pode criar branches, pode fazer rebase. Nada disso afeta o remote. Quando chega na hora de push, você revisa o que ele fez e decide se vai pro ar.

Essa combinação, sandbox pra filesystem + Git pro código + push manual, já te dá um nível de segurança muito razoável pro dia a dia. O ai-jail protege seus dados pessoais e o sistema. O Git protege seu código. E a decisão de publicar continua sendo sua.

Se quiser ir além, as próximas duas seções cobrem camadas adicionais.

## ai-jail vs Dev Containers

Desde que escrevi o ai-jail, a pergunta mais frequente é: *"por que não usar Dev Containers?"*. A resposta curta é que um não substitui o outro. Resolvem problemas diferentes.

Dev Containers (a spec do [containers.dev](https://containers.dev)) define um ambiente de desenvolvimento completo num `devcontainer.json`. Você especifica imagem base, ferramentas, extensões do VS Code, variáveis de ambiente, e o editor monta tudo pra você num container Docker. O Docker também lançou recentemente os Docker Sandboxes, que vão além e rodam cada agente numa microVM com Firecracker, com isolamento de hardware.

ai-jail não faz nada disso. Ele não define ambiente. Não instala ferramentas. Não roda imagem Docker. Ele pega o ambiente que já existe na sua máquina e restringe o que o processo pode acessar.

Na prática, a diferença é:

| | Dev Container | ai-jail |
|---|---|---|
| O que faz | Define e provisiona um ambiente isolado completo | Restringe acesso do processo ao filesystem existente |
| Setup | `devcontainer.json` + Docker | `.ai-jail` TOML + bubblewrap |
| Startup | Segundos (pull de imagem, build de container) | Milissegundos (fork + exec do bwrap) |
| Ferramentas | As que você coloca na imagem | As que já estão instaladas na sua máquina |
| GPU | Requer configuração de NVIDIA Container Toolkit | Auto-detecta `/dev/nvidia*` e `/dev/dri` |
| Daemon | Requer Docker daemon rodando | Nada além do bwrap |
| Reprodutibilidade | Alta (imagem fixa) | Depende do que tá instalado no host |
| Isolamento de rede | Docker Sandboxes: firewall por domínio | Lockdown: corta tudo com `--unshare-net` |

Dev Container faz mais sentido quando você precisa que todo o time tenha exatamente o mesmo ambiente, ou quando o projeto tem dependências que ninguém quer instalar no host, ou pra rodar agentes não-interativos em CI/CD. Docker Sandboxes com microVM são o isolamento mais forte que existe fora de uma VM dedicada.

ai-jail faz mais sentido quando você já tem o ambiente configurado e quer startup instantâneo sem Docker daemon. Ou quando usa ferramentas que são chatas de rodar dentro de container (CUDA, Wayland, mise). Ou simplesmente quando quer a mesma proteção pra qualquer agente, não só os que têm integração com devcontainer.

E dá pra combinar. Eu conheço gente que roda ai-jail dentro de um Dev Container pra ter reprodutibilidade de ambiente + restrição de filesystem. Layers de segurança se somam.

## Sistemas Operacionais Imutáveis: A Última Camada

Se você quer levar a segurança a sério, a terceira camada é o sistema operacional em si.

Sistemas imutáveis como [Fedora Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/), [NixOS](https://nixos.org/), e [openSUSE Aeon](https://aeondesktop.github.io/) têm o filesystem raiz read-only. O sistema base não pode ser modificado por nenhum processo, nem com root. Atualizações são atômicas: ou aplicam completamente ou não aplicam. E se algo der errado, você faz rollback pra imagem anterior em um reboot.

Na prática, isso significa que mesmo se um agente de IA escapasse do sandbox (exploiting uma vulnerabilidade no kernel, por exemplo), ele não conseguiria modificar o sistema de forma persistente. No próximo reboot, o sistema volta ao estado declarado. No NixOS, o sistema inteiro é definido por um arquivo de configuração (`configuration.nix`). No Silverblue, o base é uma imagem OSTree que recebe updates atômicos via `rpm-ostree`.

Pra desenvolvedores, a pegada é: suas ferramentas de dev rodam em containers (Toolbox/Distrobox no Silverblue, `nix-shell` no NixOS). O sistema base fica intocado. Apps desktop vêm via Flatpak, que já roda em sandbox. O resultado é que a superfície de ataque do host é mínima.

Fedora Silverblue é provavelmente a entrada mais acessível. Já é Fedora por baixo, com GNOME, funciona com hardware que Fedora suporta, e o Toolbox te dá um Fedora Server containerizado onde você instala o que quiser sem tocar no host. NixOS é mais poderoso (reprodutibilidade total, rollback declarativo), mas a curva de aprendizado é real.

A combinação completa fica assim: o OS imutável cuida do sistema (filesystem read-only, updates atômicos, rollback em um reboot). O ai-jail cuida da sessão (namespace isolado, home efêmero, dados sensíveis invisíveis). E o Git cuida do código (remote intocado enquanto o agente não tiver push).

Nenhuma dessas camadas é perfeita sozinha. Mas o ataque que fura as três ao mesmo tempo — escapar do namespace, persistir num filesystem read-only, e corromper um remote Git — é um cenário que eu ficaria confortável chamando de improvável.

O melhor é que nenhuma exige mudar como você trabalha. O ai-jail é um comando antes do seu agente. Git você já usa. E um OS imutável é uma instalação, não uma mudança de workflow.

## Detalhes Técnicos (Pra Quem Se Importa)

Escrito em Rust com 124 testes e 4 dependências: `lexopt` (parsing de CLI sem clap), `serde` + `toml` (config), `nix` (syscalls Unix). Sem runtime async, sem framework de cores (ANSI direto), binary de ~880KB com LTO e strip.

O signal handling é feito corretamente: SIGINT, SIGTERM, e SIGHUP são forwarded pro processo filho. O handler só chama `libc::kill`, que é async-signal-safe. O reaping do processo usa `waitpid` em loop com retry em EINTR.

Arquivos temporários (como o `/etc/hosts` customizado que o sandbox monta) usam RAII: um `SandboxGuard` que implementa `Drop` em Rust. Se o processo pai morrer por qualquer razão, o cleanup acontece.

A compatibilidade de configuração é garantida por política de desenvolvimento: nunca remover campos, nunca renomear, campos novos sempre com `#[serde(default)]`, campos desconhecidos são silenciosamente ignorados. Testes de regressão pra formatos antigos de `.ai-jail` garantem que atualizar o binário nunca quebra configs existentes. São 32 testes só de config.

## Roadmap

O que falta:

- Mais backends de ferramentas no bootstrap: Aider, Cursor, Windsurf. Conforme mais agentes padronizarem arquivos de configuração de permissão.
- Profile sharing pra monorepos, pra não ter que configurar cada serviço separadamente.

## Instalação e Primeiro Uso (Resumo Rápido)

```bash
# 1. Instalar
brew tap akitaonrails/tap && brew install ai-jail
# ou: cargo install ai-jail

# 2. No Linux, instalar bubblewrap
sudo pacman -S bubblewrap  # Arch
# sudo apt install bubblewrap  # Debian/Ubuntu

# 3. Entrar no projeto e rodar
cd ~/Projects/meu-app
ai-jail claude

# 4. (Opcional) Gerar configs de permissão
ai-jail --bootstrap

# 5. (Opcional) Ver o que o sandbox faz
ai-jail --dry-run --verbose claude
```

O `.ai-jail` criado pode ser commitado no seu repo. A partir daí, qualquer dev que clonar o projeto roda `ai-jail claude` e tem o mesmo sandbox.

## Conclusão

O shell script de janeiro resolveu o problema. O ai-jail resolve o problema direito. Config por projeto, suporte a macOS, lockdown mode, bootstrap de permissões, dry-run pra auditar, e um binário de 880KB que instala em 10 segundos.

Se você usa agentes de IA pra programar, rode eles num sandbox. A boa vontade da LLM não é garantia de nada, e supply-chain attacks não escolhem vítima. Isolamento de processo é a barreira que funciona.

O projeto é GPL-3.0 e tá no GitHub: [github.com/akitaonrails/ai-jail](https://github.com/akitaonrails/ai-jail)

Issues e PRs são bem-vindos.
