---
title: "I Rewrote OpenClaw in Rust. Did It Work? | FrankClaw"
date: '2026-03-16T08:00:00-03:00'
draft: false
slug: rewrote-openclaw-in-rust-frankclaw
translationKey: openclaw-rust-rewrite-frankclaw
tags:
  - rust
  - security
  - ai
  - open-source
  - vibe-coding
---

Before anything else: FrankClaw is still in heavy alpha. It works for simple tasks, but I haven't tested complex workflows. If you want to help, open Issues on [GitHub](https://github.com/akitaonrails/frankclaw) with whatever you find. There's a lot to test.

It "works," but this project was more about the exercise. With that out of the way, let me tell you why I did it.

## The problem with OpenClaw

[OpenClaw](https://github.com/openclaw/openclaw) is a gateway that connects messaging channels (Telegram, Discord, Slack, WhatsApp, etc.) to AI providers (OpenAI, Anthropic, Ollama). You configure it, bring up the server, and you can chat with LLMs straight from Telegram or any other channel. It's a popular project with plenty of activity.

Too much activity, actually.

I did a depth-1 clone of the repo and ran `tokei`:

| Metric | Value |
|---------|-------|
| TypeScript files (without tests) | 3,794 |
| Lines of TypeScript | ~1,247,000 |
| Test files | 2,799 |
| Dependencies (root package.json) | 73 |

Over a million lines of TypeScript. The 2,799 test files sound like a lot in absolute numbers, but proportional to the codebase size, the coverage is low. Most of the code lives in 29 packages of a monorepo with 21 channel extensions.

I went looking for more commits to understand the development pace. In the 100 commits I managed to pull, all of them landed in just 2 days (March 9 and 10). ~50 commits per day, from 42 different contributors. Vibe coding to the extreme.

The conclusion is the one you're imagining: enormous volumes of AI-generated code being dumped into a repository at a speed that makes serious human review impossible. And that bothered me enough to go investigate further.

## The security audit

I asked Claude to do a complete security audit of OpenClaw's code. The [report](https://github.com/akitaonrails/frankclaw/blob/master/docs/OPENCLAW_SECURITY_AUDIT.md) found:

| Severity | Count |
|------------|-----------|
| CRITICAL | 7 |
| HIGH | 9 |
| MEDIUM | 12 |
| LOW | 6 |
| INFO | 5 |

Seven critical vulnerabilities. Let me list a few:

- Timing side-channel in token comparison — `safeEqualSecret()` does an early return on the type-check, letting an attacker distinguish malformed tokens from wrong tokens by measuring latency.
- `eval()` in the browser tool — arbitrary JavaScript execution with no sandbox.
- Shell with no allowlist — any tool can run any command on the system.
- Slack webhooks with no signature verification at all.
- Transcripts and config in plaintext on disk, no encryption.
- No effective rate limiting — IPs can be spoofed if the operator configures trusted proxies broadly.

Those are just the ones Claude found in an automated scan. There are probably more.

I'm not going to run that on my machine. Not even inside a Docker container. A gateway that receives webhooks from the internet, executes shell commands, connects to AI APIs with your keys, and stores conversation history, all of it with 7 known critical vulnerabilities? No, thanks.

So I did what any rational developer would do: I decided to build my own.

## The first attempt: Claude Code

I started the most direct way. Cloned OpenClaw, pointed Claude Code at the code, and asked: "rewrite this in Rust."

Didn't work. The codebase is too big. Over a million lines of TypeScript spread across 29 packages. Claude can't keep all of it in context. The initial result was very incomplete: lots of types created but no implementation, `todo!()` everywhere, too much boilerplate and not enough functionality.

I switched to Codex 5.4 to test. Same thing: I asked it to analyze and rewrite. It improved a bit in certain aspects, but the fundamental problem is the same. No AI today takes a project of that size and rewrites it in one go. The context doesn't fit.

## The technique that actually works

What works is going slowly. One step at a time.

Ask Claude (or Codex) to analyze the original code in stages. Make a long plan detailing each feature. Then implement one feature at a time in Rust, with tests, commit, and repeat. It's tedious, but it produces code that compiles and actually works.

The reason is simple: the original code is so massive that no AI agent (and not even several in parallel) can keep all of it in context at the same time. You have to decide what matters, implement that, validate, and move on to the next thing.

And you have to decide what to cut. OpenClaw has 21 channel extensions: Google Chat, iMessage, IRC, Teams, Matrix, Mattermost, Nostr, Twitch... I don't need any of those. I kept the mainstream channels: Web, Telegram, Discord, Slack, Signal, WhatsApp and Email. TTS? Out. Polls? Out. WhatsApp Web through Baileys? Out, I use the official Cloud API. They're features that add complexity without proportional value.

## Discovering IronClaw

In the middle of development, I came across [IronClaw](https://github.com/nichochar/iron-claw), which presents itself as "OpenClaw in Rust." Great, I thought. Let me see what they did.

I cloned the repo and asked Claude to write a [comparison report](https://github.com/akitaonrails/frankclaw/blob/master/docs/IRONCLAW_COMPARISON.md). IronClaw has good things. I adopted 12 features:

Circuit breaker with retry and exponential backoff for LLM provider resilience. Credential leak detection in the output. LLM response cache with SHA-256 of the prompt. Cost tracking with budget guards (warning at 80%, block at 100%). Extended thinking for Claude 3.7+ and o1. MCP client for external tool servers. Lifecycle hooks on inbound, tool calls and outbound. Smart model routing that sends simple queries to cheaper models. Tunnel support (cloudflared, ngrok, tailscale). Interactive REPL (`frankclaw chat`). Routines with event triggers beyond cron. Job state machine with auto-repair.

But IronClaw depends on PostgreSQL + pgvector, has a WASM sandbox (wasmtime adds ~10MB), and is part of the NEAR AI ecosystem. I want a single binary with embedded SQLite and zero external dependencies.

## What FrankClaw brings from OpenClaw

The OpenClaw core is there: 7 messaging channels, multi-provider with failover, agent runtime, command system, skills, subagents, browser automation through CDP, bash tool with allowlist, cron jobs, interactive REPL. Plus the 12 IronClaw features I listed above.

But several pieces had to be rewritten in a way the original didn't. Context compaction, for example, uses a sliding window with token estimation, message pruning and automatic repair of tool pairs that get orphaned when the context is cut. Provider failover is now model-aware: if you ask for a Claude model and the current provider is OpenAI, it skips automatically instead of erroring out. The canvas renders SVG, HTML and Markdown with revision conflict detection. Things that in OpenClaw either didn't exist or were half-built.

Then came the phase of adding what was missing for parity. FrankClaw today has 30+ LLM tools: `web_fetch` (SSRF-safe with HTML-to-text), `web_search` (Brave API), `file_read`/`file_write`/`file_edit` (sandboxed in the workspace with path traversal protection), `pdf_read`, `image_describe` (through vision models), `audio_transcribe`, `sessions_list`/`sessions_history`/`sessions_delete`, `message_send`/`message_react`, `cron_list`/`cron_add`/`cron_remove`, `config_get` (auto-redacts secrets), `agents_list`, `memory_get`/`memory_search`, plus the browser tools (`browser_open`, `browser_extract`, `browser_snapshot`, `browser_click`, `browser_type`, `browser_wait`, `browser_press`, `browser_sessions`, `browser_close`, `browser_aria`).

Some additions that don't exist in the original OpenClaw: a memory/RAG system with SQLite FTS5 and embeddings (OpenAI, Gemini, Voyage) that automatically syncs workspace files. An OpenAI-compatible API (`/v1/chat/completions` and `/v1/models`), so any client that speaks that protocol (Cursor, Continue, Open WebUI) can use FrankClaw as a backend with no adaptation. A `ratatui` TUI for people who prefer the terminal. Interactive approval of destructive tools before execution.

Smaller things that make a difference in practice. You can configure multiple API keys per provider with round-robin and automatic backoff, so if one key hits the rate limit, the next one takes over. The model catalog already knows context windows and costs of OpenAI and Anthropic models without you having to configure them. URL extraction from messages has a private IP blocklist against SSRF. The command system accepts inline directives (`/think`, `/model`) in addition to aliases.

On the operational side: ACP (Agent Client Protocol) over JSON-RPC 2.0 on top of NDJSON for people who want to integrate programmatically. Plugin system with manifests and enable/disable lifecycle. i18n with 9 locales via `FRANKCLAW_LANG`. Workspace identity files (`SOUL.md`, `IDENTITY.md`) to define the bot's personality per project. Channel health monitor with auto-restart. WebSocket with ping keepalive that survives proxy and tunnel timeouts. `frankclaw start/stop/status` for people who want to run it as a daemon with PID tracking. And the entire configuration migrated from JSON to TOML.

## Hardening: where the real difference is

The [audit report](https://github.com/akitaonrails/frankclaw/blob/master/docs/OPENCLAW_SECURITY_AUDIT.md) we ran on OpenClaw found 7 critical and 9 high vulnerabilities. FrankClaw fixes all of them:

| Area | OpenClaw | FrankClaw |
|------|----------|-----------|
| Token comparison | SHA-256 + timingSafeEqual with early return that leaks timing | Constant-time byte-by-byte comparison, no early returns |
| Shell execution | No mandatory allowlist | Deny-all by default + binary allowlist + metacharacter rejection + optional ai-jail sandbox |
| Browser tool | `eval()` with no sandbox | CDP with 15s timeout, SSRF guard, crash recovery, ARIA inspection |
| Slack webhook | Zero signature verification | HMAC-SHA256 with replay protection |
| Discord webhook | Hardcoded placeholder | Ed25519 with timestamp validation |
| Cryptography | Plaintext on disk | ChaCha20-Poly1305 on sessions and config |
| Password hashing | No password authentication at all | Argon2id (t=3, m=64MB, p=4) |
| File permissions | 0o644 (world-readable) | 0o600 (owner-only) |
| Prompt injection | Basic sanitization | Unicode Cc/Cf stripping + boundary tags + 2MB limit |
| Malware scanning | None | Optional VirusTotal on uploads |
| Input validation | No limits | 255 byte IDs, 800 byte session keys, configurable WS frames |
| SSRF | Partial protection | Full blocklist (RFC 1918, loopback, CGNAT, link-local) + DNS rebinding defense |
| Tool execution | No user confirmation | Interactive approval for mutating/destructive tools |

FrankClaw compiles with `#![forbid(unsafe_code)]` in all 13 crates. Zero unsafe blocks.

And the audit didn't stop at OpenClaw. We did a [per-component audit](https://github.com/akitaonrails/frankclaw/blob/master/docs/AUDIT_PLAN.md) in 14 phases comparing each part of FrankClaw against the original: channels, providers, runtime, tools, sessions, crypto, cron, webhooks. All documented.

## Deploy: how to install

FrankClaw runs with Docker Compose. Three containers: gateway, headless Chromium (for browser tools), and Cloudflare tunnel (to receive webhooks).

### 1. Clone and configure

```bash
git clone https://github.com/akitaonrails/frankclaw.git
cd frankclaw
cp .env.docker.example .env.docker
```

Edit `.env.docker` with your keys:

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

### 2. Configure the gateway

The `frankclaw.toml` file defines agents, models and channels. Use the wizard or the examples:

```bash
# Generate a base config with the web channel
cargo run -- onboard --channel web

# Or copy from the examples
ls examples/channels/
```

For each channel, the CLI has ready-made templates:

```bash
cargo run -- config-example --channel telegram
cargo run -- config-example --channel whatsapp
```

### 3. Cloudflare Tunnel (to receive webhooks)

If you're going to use channels that need a webhook (Telegram, Discord, Slack, WhatsApp), you need a public tunnel. The Docker Compose already includes cloudflared:

```bash
# Copy your Cloudflare credentials
cp docker/cloudflared/config.yml.example docker/cloudflared/config.yml
cp ~/.cloudflared/<tunnel-id>.json docker/cloudflared/credentials.json
cp ~/.cloudflared/cert.pem docker/cloudflared/cert.pem
# Edit config.yml with your hostname
```

### 4. Bring it up

```bash
docker compose up -d
```

The gateway comes up on port 18789 (internal to Docker). cloudflared routes external traffic. Chromium stays on the internal network for browser tools.

To test locally without Docker:

```bash
cargo run -- chat
```

Opens the interactive REPL straight in the terminal (it now also has a `ratatui` TUI with dark mode and tabs). No gateway, no webhook. Good for validating that the AI provider is responding before configuring channels.

### Validation

```bash
cargo run -- check     # validates config
cargo run -- doctor    # full diagnostic
cargo run -- audit     # security audit with severity ratings
```

`audit` is the one I like the most. It checks whether you have encryption enabled, whether file permissions are correct, whether webhooks have signature verification, whether the bash tool is in deny-all. It exits with a non-zero exit code when it finds critical issues, so you can drop it in CI.

## The development process

The project has 178 commits in ~5 days of work (March 10-16). Almost 57 thousand lines of Rust in 120 files, organized in 13 crates.

The commits tell the story. The first few dozens were scaffolding: workspace structure, basic types, the HTTP/WebSocket gateway, first version of the channel adapters. Mass-generated code, lots of incomplete pieces.

Then the channel adapters started, one by one:

```
236aa1c - Minimal Discord channel adapter
fd67017 - Minimal Slack channel adapter
9f51373 - Minimal Signal channel adapter
1052e47 - WhatsApp channel webhook adapter
035f86e - Email channel adapter (IMAP inbound, SMTP outbound)
```

When the basic channels were in place, the IronClaw integration came in one big commit:

```
c87ab32 - IronClaw-derived features: circuit breaker, retry, leak detection, cache, cost tracking, extended thinking
```

And then came the hardening. That was the phase where I had to step in manually the most, because Claude generates functional code but doesn't think about attack vectors on its own:

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

22 security hardening commits. Plus 10 more component audits. Each finding became a commit with a fix.

Then came the per-channel audits, each one uncovering different edge cases:

```
43b085f - Discord audit: HELLO timeout, fatal close codes, message chunking
12c7cff - Telegram audit: caption overflow, parse fallback, edit idempotency
f515062 - WhatsApp audit: message type filtering, send error classification
3c42aff - Slack audit: fatal auth errors, send error classification
```

Browser tools needed extra attention. A headless Chrome that gets URLs from an LLM is an obvious attack vector:

```
3217a96 - Browser automation: CDP timeout, SSRF guard, session limits, crash recovery
d98a803 - Gate mutating browser tools behind operator approval
014f56e - Browser screenshot/ARIA tools for accessibility tree inspection
```

In the more recent commits, the project started diverging from OpenClaw:

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

The OpenAI-compatible API is the one I use the most day to day. Cursor, Continue, Open WebUI, anything that speaks the OpenAI protocol can use FrankClaw as a backend without touching anything on the client side.

## The numbers

| Metric | Value |
|---------|-------|
| Commits | 178 |
| Days of work | ~5 |
| Lines of Rust | 56,586 |
| Rust files | 120 |
| Crates | 13 |
| LLM tools | 30+ |
| Security hardening commits | 22 |
| Audit commits | 10 |
| Supported channels | 7 |
| AI providers | 9 (OpenAI, Anthropic, Ollama, Google, OpenRouter, Copilot, Groq, Together, DeepSeek) |
| OpenClaw critical vulnerabilities fixed | 7/7 |
| OpenClaw high vulnerabilities fixed | 9/9 |
| Unsafe blocks in the code | 0 |

Compared to OpenClaw:

| Metric | OpenClaw (TS) | FrankClaw (Rust) |
|---------|--------------|-----------------|
| Lines of code | ~1,247,000 | 56,586 |
| Source files | 3,794 | 120 |
| Runtime dependencies | 73 | ~40 crates |
| Channels | 28 | 7 |
| Critical vulnerabilities | 7 known | 0 |

The numbers aren't directly comparable. OpenClaw has 21 channel extensions I cut, a more complete web UI, and niche features I didn't port. But the core (gateway, mainstream channels, providers, runtime, sessions, tools, memory) is there with 22x less code.

## How to help (beta testing)

FrankClaw works for basic conversation through Web and Telegram (I tested both). WhatsApp works for simple messages. Discord, Slack, Signal and Email are implemented but haven't had extensive testing. We haven't done any complex workflows yet.

If you want to test it: clone the repository, bring it up with Docker Compose, configure at least one channel (Telegram is the easiest) and try to use it normally. Send messages, test tool calls, try to break the system. Open Issues on GitHub with whatever you find.

What I know needs more eyes: workflows with tools (browser, bash, MCP), subagent orchestration, failover between providers, session persistence with encryption, smart routing between models, scheduled jobs, the memory/RAG system, and the OpenAI-compatible API. Basically everything that goes beyond "send a message, get a reply."

You don't have to be a Rust developer. The bigger value is in using the system in ways I didn't think of and finding the edge cases that only show up under real use.

FrankClaw doesn't replace OpenClaw today. OpenClaw has more channels, more features, more people working on it. But it carries the weight of over a million lines of TypeScript generated at 50 commits per day by dozens of contributors, with documented critical vulnerabilities. FrankClaw is the alternative for anyone who looks at that and thinks "I'm not running this code on my machine."

But I'll be honest: as fun as it was to build, I personally don't know if I need this. FrankClaw is a generic gateway, designed to be flexible, to connect any channel to any provider, with an agent runtime, tools, subagents, jobs, hooks. It's a lot of infrastructure.

What I've discovered over the last few months is that I can build custom bots for specific tasks much faster. In 1 day I have a bot working, focused on what I need, without carrying the weight of a generic framework. That's what I did with [Marvin](/en/2026/02/20/discord-como-admin-panel-bastidores-do-the-m-akita-chronicles/) on the newsletter project, for instance. A custom-built Discord bot that does exactly what I need and nothing else.

A generic gateway like FrankClaw makes more sense for someone who wants a unified interface between several chat channels and several AI models without coding. If that's your case, give it a shot. If you're a developer and you know what you want, maybe a custom bot will serve you better. Up to you.

The [repository is here](https://github.com/akitaonrails/frankclaw). AGPL-3.0.
