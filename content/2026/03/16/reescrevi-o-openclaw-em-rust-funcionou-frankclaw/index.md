---
title: "Reescrevi o OpenClaw em Rust, funcionou? | FrankClaw"
date: '2026-03-16T08:00:00-03:00'
draft: false
translationKey: openclaw-rust-rewrite-frankclaw
tags:
  - rust
  - security
  - ai
  - open-source
  - vibe-coding
---

Antes de tudo: o FrankClaw ainda está em alpha pesado. Funciona pra tarefas simples, mas não testei workflows complexos. Se você quer ajudar, abre Issues no [GitHub](https://github.com/akitaonrails/frankclaw) com o que encontrar. Tem muita coisa pra testar.

Até "funciona", mas esse projeto foi mais pelo exercício. Dito isso, deixa eu contar por que fiz isso.

## O problema com o OpenClaw

O [OpenClaw](https://github.com/openclaw/openclaw) é um gateway que conecta canais de mensagem (Telegram, Discord, Slack, WhatsApp, etc.) a provedores de IA (OpenAI, Anthropic, Ollama). Você configura, sobe o servidor, e pode conversar com LLMs direto pelo Telegram ou qualquer outro canal. É um projeto popular e com bastante atividade.

Atividade demais, na verdade.

Eu fiz um clone depth-1 do repositório e rodei um `tokei`:

| Métrica | Valor |
|---------|-------|
| Arquivos TypeScript (sem testes) | 3.794 |
| Linhas de código TypeScript | ~1.247.000 |
| Arquivos de teste | 2.799 |
| Dependências (package.json raiz) | 73 |

Mais de um milhão de linhas de TypeScript. Os 2.799 arquivos de teste parecem bastante em número absoluto, mas proporcionalmente ao tamanho do codebase, a cobertura é baixa. A maior parte do código está em 29 pacotes de um monorepo com 21 extensões.

Fui buscar mais commits pra entender o ritmo de desenvolvimento. Nos 100 commits que consegui puxar, todos caíram em apenas 2 dias (9 e 10 de março). ~50 commits por dia, de 42 contribuidores diferentes. Vibe coding ao extremo.

A conclusão é a que você imagina: volumes enormes de código gerado por IA sendo despejados num repositório a uma velocidade que impossibilita review humano sério. E isso me incomodou o suficiente pra ir investigar mais a fundo.

## A auditoria de segurança

Pedi pro Claude fazer uma auditoria de segurança completa no código do OpenClaw. O [relatório](https://github.com/akitaonrails/frankclaw/blob/master/docs/OPENCLAW_SECURITY_AUDIT.md) encontrou:

| Severidade | Quantidade |
|------------|-----------|
| CRITICAL | 7 |
| HIGH | 9 |
| MEDIUM | 12 |
| LOW | 6 |
| INFO | 5 |

Sete vulnerabilidades críticas. Deixa eu listar algumas:

- Timing side-channel na comparação de tokens -- o `safeEqualSecret()` faz um `return` antecipado no type-check, permitindo que um atacante distinga tokens malformados de tokens errados medindo latência.
- `eval()` no browser tool -- execução arbitrária de JavaScript sem sandbox.
- Shell sem allowlist -- qualquer tool pode executar qualquer comando no sistema.
- Webhooks do Slack sem verificação de assinatura nenhuma.
- Transcripts e config em texto puro no disco, sem criptografia.
- Sem rate limiting efetivo -- IPs podem ser spoofados se o operador configura trusted proxies de forma ampla.

Essas são só as que o Claude encontrou numa varredura automatizada. Provavelmente tem mais.

Eu não vou rodar isso na minha máquina. Nem dentro de um container Docker. Um gateway que recebe webhooks da internet, executa comandos shell, se conecta a APIs de IA com suas chaves, e guarda histórico de conversas, tudo isso com 7 vulnerabilidades críticas conhecidas? Não, obrigado.

Então eu fiz o que qualquer desenvolvedor racional faria: decidi construir o meu.

## A primeira tentativa: Claude Code

Comecei do jeito mais direto. Clonei o OpenClaw, apontei o Claude Code pro código, e pedi: "reescreve isso em Rust."

Não funcionou. O codebase é grande demais. Mais de um milhão de linhas de TypeScript espalhadas em 29 pacotes. O Claude não consegue manter tudo em contexto. O resultado inicial foi muito incompleto: muitos tipos criados mas sem implementação, `todo!()` por toda parte, boilerplate demais e funcionalidade de menos.

Troquei pro Codex 5.4 pra testar. Mesma coisa: pedi pra analisar e reescrever. Melhorou um pouco em certos aspectos, mas o problema fundamental é o mesmo. Nenhuma IA hoje pega um projeto desse tamanho e reescreve inteiro de uma vez. O contexto não cabe.

## A técnica que funciona

O que funciona é ir devagar. Um passo de cada vez.

Pede pro Claude (ou Codex) analisar o código original em etapas. Faz um plano longo detalhando cada feature. Depois implementa uma feature por vez em Rust, com testes, faz commit, e repete. É tedioso, mas é o que produz código que compila e funciona de verdade.

O motivo é simples: o código original é tão massivo que nenhum agente de IA (nem vários em paralelo) consegue manter tudo em contexto ao mesmo tempo. Você precisa decidir o que importa, implementar aquilo, validar, e seguir pro próximo.

E precisa decidir o que cortar. O OpenClaw tem 21 extensões de canal: Google Chat, iMessage, IRC, Teams, Matrix, Mattermost, Nostr, Twitch... Eu não preciso de nenhuma dessas. Mantive os canais mainstream: Web, Telegram, Discord, Slack, Signal, WhatsApp e Email. TTS? Fora. Polls? Fora. WhatsApp Web via Baileys? Fora, uso a Cloud API oficial. São features que adicionam complexidade sem valor proporcional.

## Descobrindo o IronClaw

No meio do desenvolvimento, descobri o [IronClaw](https://github.com/nichochar/iron-claw), que se apresenta como "OpenClaw em Rust". Ótimo, pensei. Vou ver o que eles fizeram.

Clonei o repositório e pedi pro Claude escrever um [relatório de comparação](https://github.com/akitaonrails/frankclaw/blob/master/docs/IRONCLAW_COMPARISON.md). O IronClaw tem coisas boas. Adotei 12 features:

Circuit breaker com retry e backoff exponencial pra resiliência de providers LLM. Detecção de leak de credenciais no output. Cache de respostas LLM com SHA-256 da prompt. Cost tracking com budget guards (aviso em 80%, bloqueio em 100%). Extended thinking pra Claude 3.7+ e o1. MCP client pra tool servers externos. Lifecycle hooks em inbound, tool calls e outbound. Smart model routing que joga queries simples pra modelos mais baratos. Suporte a túneis (cloudflared, ngrok, tailscale). REPL interativo (`frankclaw chat`). Routines com event triggers além de cron. Job state machine com auto-repair.

Mas o IronClaw depende de PostgreSQL + pgvector, tem sandbox WASM (wasmtime adiciona ~10MB), e é parte do ecossistema NEAR AI. Eu quero um binário único com SQLite embarcado e zero dependências externas.

## O que o FrankClaw traz do OpenClaw

O core do OpenClaw está lá: 7 canais de mensagem, multi-provider com failover, agent runtime, sistema de comandos, skills, subagents, browser automation via CDP, bash tool com allowlist, cron jobs, REPL interativo. Mais as 12 features do IronClaw que listei acima.

Mas vários pedaços precisaram ser reescritos de um jeito que o original não fez. A compactação de contexto, por exemplo, usa sliding window com estimativa de tokens, pruning de mensagens e repair automático de tool pairs que ficam órfãos quando o contexto é cortado. O failover entre providers agora é model-aware: se você pede um modelo Claude e o provider da vez é OpenAI, ele pula automaticamente em vez de dar erro. O canvas renderiza SVG, HTML e Markdown com detecção de conflitos de revisão. São coisas que no OpenClaw ou não existiam ou estavam pela metade.

Depois veio a fase de adicionar o que faltava pra paridade. O FrankClaw hoje tem 30+ LLM tools: `web_fetch` (SSRF-safe com HTML-to-text), `web_search` (Brave API), `file_read`/`file_write`/`file_edit` (sandboxed no workspace com proteção contra path traversal), `pdf_read`, `image_describe` (via modelos de vision), `audio_transcribe`, `sessions_list`/`sessions_history`/`sessions_delete`, `message_send`/`message_react`, `cron_list`/`cron_add`/`cron_remove`, `config_get` (auto-redação de secrets), `agents_list`, `memory_get`/`memory_search`, mais os browser tools (`browser_open`, `browser_extract`, `browser_snapshot`, `browser_click`, `browser_type`, `browser_wait`, `browser_press`, `browser_sessions`, `browser_close`, `browser_aria`).

Algumas adições que não existem no OpenClaw original: um sistema de memória/RAG com SQLite FTS5 e embeddings (OpenAI, Gemini, Voyage) que sincroniza arquivos do workspace automaticamente. Uma API compatível com OpenAI (`/v1/chat/completions` e `/v1/models`), então qualquer cliente que fala esse protocolo (Cursor, Continue, Open WebUI) pode usar o FrankClaw como backend sem adaptação. Uma TUI em `ratatui` pra quem prefere terminal. Aprovação interativa de tools destrutivos antes de executar.

Tem coisas menores que fazem diferença na prática. Você pode configurar múltiplas API keys por provider com round-robin e backoff automático, então se uma key estourar o rate limit, a próxima assume. O model catalog já sabe context windows e custos dos modelos OpenAI e Anthropic sem você ter que configurar. Extração de URLs de mensagens tem blocklist de IPs privados contra SSRF. O sistema de comandos aceita directives inline (`/think`, `/model`) além de aliases.

Do lado de operação: ACP (Agent Client Protocol) via JSON-RPC 2.0 sobre NDJSON pra quem quer integrar programaticamente. Sistema de plugins com manifests e lifecycle de enable/disable. i18n com 9 locales via `FRANKCLAW_LANG`. Workspace identity files (`SOUL.md`, `IDENTITY.md`) pra definir a personalidade do bot por projeto. Health monitor nos canais com auto-restart. WebSocket com ping keepalive que sobrevive timeouts de proxy e túnel. `frankclaw start/stop/status` pra quem quer rodar como daemon com PID tracking. E toda a configuração migrou de JSON pra TOML.

## Hardening: onde está o diferencial

O [relatório de auditoria](https://github.com/akitaonrails/frankclaw/blob/master/docs/OPENCLAW_SECURITY_AUDIT.md) que rodamos no OpenClaw encontrou 7 vulnerabilidades críticas e 9 high. O FrankClaw resolve todas:

| Área | OpenClaw | FrankClaw |
|------|----------|-----------|
| Comparação de tokens | SHA-256 + timingSafeEqual com early return que leaka timing | Comparação constant-time byte a byte, sem early returns |
| Shell execution | Sem allowlist obrigatória | Deny-all por padrão + binary allowlist + rejeição de metacaracteres + sandbox ai-jail opcional |
| Browser tool | `eval()` sem sandbox | CDP com timeout 15s, SSRF guard, crash recovery, ARIA inspection |
| Webhook Slack | Zero verificação de assinatura | HMAC-SHA256 com proteção contra replay |
| Webhook Discord | Placeholder hardcoded | Ed25519 com validação de timestamp |
| Criptografia | Plaintext no disco | ChaCha20-Poly1305 em sessions e config |
| Password hashing | Sem autenticação por senha | Argon2id (t=3, m=64MB, p=4) |
| Permissões de arquivo | 0o644 (world-readable) | 0o600 (owner-only) |
| Prompt injection | Sanitização básica | Unicode Cc/Cf stripping + boundary tags + limite de 2MB |
| Malware scanning | Nenhum | VirusTotal opcional em uploads |
| Validação de input | Sem limites | IDs de 255 bytes, session keys de 800 bytes, frames WS configuráveis |
| SSRF | Proteção parcial | Blocklist completa (RFC 1918, loopback, CGNAT, link-local) + DNS rebinding defense |
| Tool execution | Sem confirmação do usuário | Aprovação interativa pra tools mutating/destructive |

O FrankClaw compila com `#![forbid(unsafe_code)]` em todos os 13 crates. Zero blocos unsafe.

E a auditoria não parou no OpenClaw. Fizemos uma [auditoria por componente](https://github.com/akitaonrails/frankclaw/blob/master/docs/AUDIT_PLAN.md) em 14 fases comparando cada parte do FrankClaw contra o original: canais, providers, runtime, tools, sessions, crypto, cron, webhooks. Tudo documentado.

## Deploy: como instalar

O FrankClaw roda com Docker Compose. Três containers: gateway, Chromium headless (pra browser tools), e Cloudflare tunnel (pra receber webhooks).

### 1. Clonar e configurar

```bash
git clone https://github.com/akitaonrails/frankclaw.git
cd frankclaw
cp .env.docker.example .env.docker
```

Edite o `.env.docker` com suas chaves:

```bash
# Providers de IA (preencha os que usar)
OPENAI_API_KEY=
ANTHROPIC_API_KEY=

# Canais (preencha os que quiser usar)
TELEGRAM_BOT_TOKEN=         # via @BotFather
WHATSAPP_TOKEN=             # Meta Business Platform
WHATSAPP_PHONE_ID=
WHATSAPP_VERIFY_TOKEN=
DISCORD_BOT_TOKEN=
SLACK_BOT_TOKEN=
SLACK_APP_TOKEN=

# Embedding providers (só se usar memória/RAG)
# GEMINI_API_KEY=
# VOYAGE_API_KEY=

# Opcional: criptografia de sessions (recomendado)
# Gere com: openssl rand -base64 32
FRANKCLAW_MASTER_KEY=

# Opcional: scan de malware em uploads
VIRUSTOTAL_API_KEY=
```

### 2. Configurar o gateway

O arquivo `frankclaw.toml` define agentes, modelos e canais. Use o wizard ou os exemplos:

```bash
# Gerar config base com canal web
cargo run -- onboard --channel web

# Ou copiar dos exemplos
ls examples/channels/
```

Pra cada canal, o CLI tem templates prontos:

```bash
cargo run -- config-example --channel telegram
cargo run -- config-example --channel whatsapp
```

### 3. Cloudflare Tunnel (pra receber webhooks)

Se você vai usar canais que precisam de webhook (Telegram, Discord, Slack, WhatsApp), precisa de um túnel público. O Docker Compose já inclui o cloudflared:

```bash
# Copie suas credenciais do Cloudflare
cp docker/cloudflared/config.yml.example docker/cloudflared/config.yml
cp ~/.cloudflared/<tunnel-id>.json docker/cloudflared/credentials.json
cp ~/.cloudflared/cert.pem docker/cloudflared/cert.pem
# Edite config.yml com seu hostname
```

### 4. Subir

```bash
docker compose up -d
```

O gateway sobe na porta 18789 (interna ao Docker). O cloudflared roteia o tráfego externo. O Chromium fica na rede interna pra browser tools.

Pra testar local sem Docker:

```bash
cargo run -- chat
```

Abre o REPL interativo direto no terminal (agora também tem uma TUI em `ratatui` com dark mode e tabs). Sem gateway, sem webhook. Bom pra validar que o provider de IA está respondendo antes de configurar canais.

### Validação

```bash
cargo run -- check     # valida config
cargo run -- doctor    # diagnóstico completo
cargo run -- audit     # auditoria de segurança com severity ratings
```

O `audit` é o que eu mais gosto. Ele verifica se você tem criptografia habilitada, se as permissões de arquivo estão corretas, se os webhooks têm verificação de assinatura, se o bash tool está em deny-all. Sai com exit code non-zero se encontra problemas críticos, então dá pra colocar no CI.

## O processo de desenvolvimento

O projeto tem 178 commits em ~5 dias de trabalho (10-16 de março). Quase 57 mil linhas de Rust em 120 arquivos, organizados em 13 crates.

Os commits contam a história. As primeiras dezenas foram scaffold: estrutura do workspace, tipos básicos, o gateway HTTP/WebSocket, primeira versão dos channel adapters. Código gerado em massa, muita coisa incompleta.

Depois começaram os adapters de canal, um por um:

```
236aa1c - Minimal Discord channel adapter
fd67017 - Minimal Slack channel adapter
9f51373 - Minimal Signal channel adapter
1052e47 - WhatsApp channel webhook adapter
035f86e - Email channel adapter (IMAP inbound, SMTP outbound)
```

Quando os canais básicos estavam no lugar, veio a integração do IronClaw num commit grande:

```
c87ab32 - IronClaw-derived features: circuit breaker, retry, leak detection, cache, cost tracking, extended thinking
```

E aí veio o hardening. Essa foi a fase que eu mais tive que intervir manualmente, porque o Claude gera código funcional mas não pensa em vetores de ataque sozinho:

```
db34198 - Prompt injection sanitization, external content wrapping, prompt size limit
5719b34 - Optional VirusTotal malware scanning for file uploads
ccd2b2b - Harden input validation across all user-facing entry points
aa918ee - Optional ai-jail sandbox for bash tool
2d7b1df - Security audit command with severity-rated findings
d12cc97 - 3-tier ToolRiskLevel system replacing binary browser mutation flag
21e0c91 - Timing-safe token comparison in WhatsApp, crypto audit tests
e240c1b - Webhook replay prevention with timestamp verification
876a78c - Gateway & media: SSRF redirect validation, filename hardening
```

22 commits de security hardening. Mais 10 de auditoria por componente. Cada achado virou um commit com fix.

Depois vieram as auditorias específicas por canal, cada uma descobrindo edge cases diferentes:

```
43b085f - Discord audit: HELLO timeout, fatal close codes, message chunking
12c7cff - Telegram audit: caption overflow, parse fallback, edit idempotency
f515062 - WhatsApp audit: message type filtering, send error classification
3c42aff - Slack audit: fatal auth errors, send error classification
```

Browser tools precisaram de atenção extra. Um headless Chrome que recebe URLs de um LLM é um vetor de ataque óbvio:

```
3217a96 - Browser automation: CDP timeout, SSRF guard, session limits, crash recovery
d98a803 - Gate mutating browser tools behind operator approval
014f56e - Browser screenshot/ARIA tools for accessibility tree inspection
```

Nos commits mais recentes, o projeto começou a divergir do OpenClaw:

```
5d73c4d - OpenAI-compatible HTTP API (/v1/chat/completions, /v1/models)
d832c36 - Memory/RAG system with SQLite FTS5, embeddings, and file sync
2b05f47 - Interactive tool approval for mutating/destructive tools
49034eb - Web console: dark mode, 8 tabs, focus mode, tool sidebar
9f51a18 - TUI, Gemini/Voyage embeddings, plugin management, ACP protocol
3c0703b - Config migration from JSON to TOML
eb130ad - Channel health monitor with auto-restart and rate limiting
2c3ea7e - Workspace bootstrap files (SOUL.md, IDENTITY.md) to system prompt
9df61bf - Model-aware failover routing, canvas SVG rendering
c7ba108 - WebSocket ping keepalive and auto-reconnect to web console
```

A API compatível com OpenAI é a que eu mais uso no dia a dia. Cursor, Continue, Open WebUI, qualquer coisa que fala o protocolo OpenAI consegue usar o FrankClaw como backend sem mexer em nada do lado do cliente.

## Os números

| Métrica | Valor |
|---------|-------|
| Commits | 178 |
| Dias de trabalho | ~5 |
| Linhas de Rust | 56.586 |
| Arquivos Rust | 120 |
| Crates | 13 |
| LLM tools | 30+ |
| Commits de security hardening | 22 |
| Commits de auditoria | 10 |
| Canais suportados | 7 |
| Providers de IA | 9 (OpenAI, Anthropic, Ollama, Google, OpenRouter, Copilot, Groq, Together, DeepSeek) |
| Vulnerabilidades críticas do OpenClaw resolvidas | 7/7 |
| Vulnerabilidades high do OpenClaw resolvidas | 9/9 |
| Blocos unsafe no código | 0 |

Comparado ao OpenClaw:

| Métrica | OpenClaw (TS) | FrankClaw (Rust) |
|---------|--------------|-----------------|
| Linhas de código | ~1.247.000 | 56.586 |
| Arquivos fonte | 3.794 | 120 |
| Dependências runtime | 73 | ~40 crates |
| Canais | 28 | 7 |
| Vulnerabilidades críticas | 7 conhecidas | 0 |

Os números não são diretamente comparáveis. O OpenClaw tem 21 extensões de canal que eu cortei, uma UI web mais completa, e features de nicho que não portei. Mas o core (gateway, canais mainstream, providers, runtime, sessions, tools, memória) está lá com 22x menos código.

## Como ajudar (beta testing)

O FrankClaw funciona pra conversa básica via Web e Telegram (testei ambos). WhatsApp funciona pra mensagens simples. Discord, Slack, Signal e Email estão implementados mas não tiveram teste extensivo. Não fizemos nenhum workflow complicado ainda.

Se você quer testar: clone o repositório, suba com Docker Compose, configure pelo menos um canal (Telegram é o mais fácil) e tente usar normalmente. Mande mensagens, teste tool calls, tente quebrar o sistema. Abra Issues no GitHub com o que encontrar.

O que eu sei que precisa de mais olhos: workflows com tools (browser, bash, MCP), subagent orchestration, failover entre providers, session persistence com criptografia, smart routing entre modelos, scheduled jobs, o sistema de memória/RAG, e a API OpenAI-compatible. Basicamente tudo que vai além de "manda mensagem, recebe resposta".

Não precisa ser desenvolvedor Rust. O valor maior está em usar o sistema de formas que eu não pensei e encontrar os edge cases que só aparecem com uso real.

O FrankClaw não substitui o OpenClaw hoje. O OpenClaw tem mais canais, mais features, mais gente trabalhando nele. Mas carrega o peso de mais de um milhão de linhas de TypeScript geradas a 50 commits por dia por dezenas de contribuidores, com vulnerabilidades críticas documentadas. O FrankClaw é a alternativa pra quem olha pra isso e pensa "eu não vou rodar esse código na minha máquina".

Mas vou ser honesto: apesar de ter sido divertido construir, eu pessoalmente não sei se preciso disso. O FrankClaw é um gateway genérico, feito pra ser flexível, conectar qualquer canal a qualquer provider, com runtime de agentes, tools, subagents, jobs, hooks. É muita infraestrutura.

O que eu descobri nos últimos meses é que eu consigo construir bots customizados pra tarefas específicas muito mais rápido. Em 1 dia eu tenho um bot funcionando, focado no que eu preciso, sem carregar o peso de um framework genérico. Foi o que eu fiz com o [Marvin](/2026/02/20/discord-como-admin-panel-bastidores-do-the-m-akita-chronicles/) no projeto da newsletter, por exemplo. Um bot de Discord feito sob medida, que faz exatamente o que eu preciso e nada mais.

Um gateway genérico como o FrankClaw faz mais sentido pra quem quer uma interface unificada entre vários canais de chat e vários modelos de IA sem programar. Se esse é o seu caso, experimenta. Se você é desenvolvedor e sabe o que quer, talvez um bot customizado te sirva melhor. Fica a seu critério.

O [repositório está aqui](https://github.com/akitaonrails/frankclaw). AGPL-3.0.
