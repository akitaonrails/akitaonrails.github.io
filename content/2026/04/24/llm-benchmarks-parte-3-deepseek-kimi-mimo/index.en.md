---
title: "LLM Coding Benchmark (May 2026): DeepSeek v4, Kimi v2.6, Grok 4.3, GPT 5.5"
date: '2026-04-24T13:00:00-03:00'
draft: false
translationKey: llm-coding-benchmark-canonical-2026-04
tags:
  - llm
  - benchmark
  - claude
  - ai
  - vibecoding
  - open-source
  - self-hosting
---

> **Update (May 6, 2026)**: two post-publication adjustments that reshuffle the ranking. **DeepSeek V4 Pro got unblocked** — what was listed here as "unmeasurable in opencode" climbed to **Tier A at 89/100** running through DeepClaude, a shim that swaps the endpoint Claude Code talks to. Technical details in the [dedicated May 4 post](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/). And **Grok 4.3 entered the benchmark** at 72/100 Tier B, a big jump over Grok 4.20's 25/100 (which still sits at the bottom of the list). The ranking, comparisons, and DeepSeek/Grok dedicated sections have all been updated below.

**TL;DR:** This is the canonical version of my LLM coding benchmark. It supersedes the [earlier April posts](https://github.com/akitaonrails/akitaonrails.github.io) which are now deprecated. I re-audited 24 models against the `ruby_llm` gem source instead of memory, and several models I had flagged for "inventing API" actually write correct code. Kimi K2.6 moved to Tier A. Gemini 3.1 Pro too. DeepSeek V4 Pro reaches Tier A only via DeepClaude (89/100); in opencode it stays unmeasurable. Grok 4.3 debuts at Tier B (72/100). GLM 5.1 dropped to Tier C. MiMo V2.5 Pro fell from "first non-Anthropic Tier 1" to Tier B. Opus 4.7 and GPT 5.4 xHigh tie at the top (97/100), GPT 5.5 lands third at 96/100 (40% cheaper than 5.4 at the same quality). Opus 4.6 is still my daily pick on **behavior**, not code. Long details below.

**Important disclaimer**: all the rankings, tiers and conclusions here only hold **within this specific benchmark methodology**, which is building a Rails + RubyLLM + Hotwire + Docker app from a fixed prompt. Models that fall to Tier B or C here can shine on other kinds of task (isolated function completion, short snippet generation, mathematical reasoning). Nobody should read this as a universal capability judgment.

---

## What this benchmark tests

Each model gets the same prompt to autonomously build a ChatGPT-style chat app in Rails. The prompt asks for 15 things:

1. Rails with latest Ruby + Rails via mise
2. No ActiveRecord, Action Mailer, or Active Job
3. SPA mimicking ChatGPT's interface
4. Tailwind CSS
5. Hotwire + Stimulus + Turbo Streams
6. Rails partials (no single-file CSS/JS dumps)
7. `OPENROUTER_API_KEY` via env var
8. No secrets in files
9. RubyLLM (`ruby_llm` gem) configured for OpenRouter + Claude Sonnet
10. Minitest tests for each component
11. Brakeman, RuboCop, SimpleCov, bundle-audit for CI
12. Functional Dockerfile (not a placeholder)
13. docker-compose
14. README with setup
15. Everything in workspace root (no nested subdir)

Cloud models run two phases (build + boot/Docker validation). Local models run phase 1 only. Harness is `opencode run --agent build --format json`, except GPT 5.4 which runs via `codex exec --json` directly.

## Methodology: the 8-dimension rubric

This part changed this week. The first version of this benchmark weighted RubyLLM API correctness too heavily, so a model that wrote the correct call but delivered an incomplete project (no docker-compose, stock README, bundle-audit missing) came across as more qualified than it should. The new rubric distributes across 8 dimensions:

| Dimension | Weight | What it measures |
|---|---:|---|
| Deliverable completeness | 25% | Dockerfile + compose + README + Gemfile + all checklist artifacts |
| RubyLLM correctness | 20% | Calls verified against gem 1.14.1 source |
| Test quality | 15% | Tests exercise the LLM path with mocks that match the real signature |
| Error handling | 10% | Rescue blocks around LLM calls, degraded UI for the user |
| Persistence / multi-turn | 10% | Session cookie / cache good; singleton / class-var / none bad |
| Hotwire / Turbo / Stimulus | 10% | Real Turbo Streams, decomposed partials, Stimulus controllers |
| Architecture | 5% | Service/model separation, no logic dumps in controllers |
| Production readiness | 5% | Multi-worker safe, no XSS, no committed `.env`, CSRF intact |

Score 0-100 → Tier A (80+) / B (60-79) / C (40-59) / D (<40).

- **Tier A**: ship as-is, or with a patch under 30 minutes
- **Tier B**: 1 to 2 hours to ship; architecture is sound, minor gaps
- **Tier C**: major rework. Core bugs or missing deliverables
- **Tier D**: throw away, useful only for architectural inspiration

## Final ranking (24 models)

| Rank | Model | Score | Tier | RubyLLM OK | Time | Cost |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | **97** | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | **97** | A | ✅ | 22m | ~$16 |
| 3 | **GPT 5.5 xHigh (Codex)** | **96** | A | ✅ | 18m | ~$10 |
| 4\* | DeepSeek V4 Pro (DeepClaude) | **89** | A | ✅ | 18m | ~$3.14 |
| 5 | Kimi K2.6 | **87** | A | ✅ | 20m | ~$0.30 |
| 6 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 |
| 7 | Gemini 3.1 Pro | 82 | A | ✅ | 14m | ~$0.40 |
| 8 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 |
| 8 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 10 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.74 |
| 11 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 |
| 12 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0.10 |
| 13 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.14 |
| 14 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 |
| 15 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 |
| 16 | Qwen 3.5 35B (local) | 55 | C | ✅ | 28m | free |
| 17 | GLM 4.7 Flash bf16 (local) | 52 | C | ✅ | failed | free |
| 18 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 19 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 |
| 20 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 |
| 21 | Qwen 3.5 122B (local) | 37 | D | ❌ | 43m | free |
| 22 | Qwen 3 Coder Next (local) | 32 | D | ❌ | 17m | free |
| 23 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.60 |
| 24 | GPT OSS 20B (local) | 11 | D | ❌ | failed | free |

\*DeepSeek V4 Pro only reaches that score via DeepClaude (Claude Code with env vars pointed at OpenRouter). In opencode (and any ai-sdk-based harness) the model stays unmeasurable due to the `reasoning_content` protocol bug. The 89 above is the `claude_code_deepseek_v4_pro_or_sonnet` variant, with `sonnet-coder` registered but never invoked; the solo variant (no subagent registered) lands at 84/100, still Tier A. Full coverage in the [May 4 post on the unlock](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/).

## Course correction: what changed in the criteria

Worth logging what changed between the previous iteration and this one, because it's quite a bit.

### Mistake 1: I was cataloging real APIs as "hallucinations"

Embarrassing. I went to verify directly against the gem source at `~/.local/share/mise/installs/ruby/4.0.2/lib/ruby/gems/4.0.0/gems/ruby_llm-1.14.1/` and two things I had been calling invented are actually legitimate public API:

**`chat.add_message(role: :user, content: "x")` is not a kwargs bug**. I asserted this crashed with `ArgumentError` because the real signature would be a positional hash. Looking at the gem, `Chat#add_message(message_or_attributes)` accepts either a `Message` or a hash. Ruby's parser treats `add_message(role: :user, content: "x")` as `add_message({role: :user, content: "x"})`, a single positional hash. **It works.**

**`chat.complete(&block)` is a real public method** in RubyLLM 1.14.1.

Consequence: several models I had tagged as Tier 3 were actually using valid API.

### Mistake 2: RubyLLM correctness alone isn't enough

Even after the API correction, weight was missing on deliverable completeness. If a model writes perfect RubyLLM but forgets docker-compose, leaves the README as a stock template, or omits bundle-audit, the project isn't done.

The new rubric distributes weight differently and that shifted the ranking:

- **Kimi K2.6** moved from "half-fix Tier 2" up to Tier A (84). The only non-Western model with real tests mocking RubyLLM + rescue + multi-worker-safe session cookie.
- **Kimi K2.5** came back to Tier B (66) from Tier 3. The API I called invented is real. It drops for another reason: 37 tests that never mock RubyLLM.
- **Gemini 3.1 Pro** jumped to Tier A (82). Was previously misclassified as Tier 3.
- **GPT 5.4 xHigh** ties for first with Opus 4.7 (97/100). Impeccable architecture + complete deliverables.
- **DeepSeek V4 Pro** has two readings. In opencode (and any ai-sdk harness) it stays unmeasurable: it hits the thinking-mode protocol incompatibility and the output falls back to Opus. Through DeepClaude (Claude Code with the endpoint swapped to OpenRouter), it delivers Tier A at 89/100 — the model is capable, the prior harness just didn't support the protocol. May update, see the dedicated post.
- **MiMo V2.5 Pro** dropped from "first non-Anthropic Tier 1" to Tier B (64). Tests don't exercise LLM + process-local Singleton + no rescue + no system prompt.
- **GLM 5.1** dropped hard to Tier C (43). Its fluent DSL (`c.user()`, `c.assistant()`) really is invented — grep confirms. And every request reconstructs `ChatSession.new`, discarding history. Two compound bugs.

Lesson: file count and test count measure zero if the code is wrong underneath. But RubyLLM correct on its own also isn't enough. You need both.

## Tier A: what makes them work

To understand what separates Tier A from Tier B, look at what Opus 4.7, Kimi K2.6 and Gemini 3.1 Pro do that MiMo, Sonnet 4.6 and Grok 4.3 don't.

**All Tier A models have these 4 things:**

1. **Tests that mock RubyLLM with the correct signature.** A `FakeChat` that implements `with_instructions`, `add_message`, `ask`. Tests that exercise happy path AND error path. WebMock blocking real calls to OpenRouter.
2. **Rescue around `chat.ask`** with typed error (`LlmClient::Error` or similar) and degraded UI for the user.
3. **Persistence that survives restart** and works multi-worker. Session cookie (Opus, K2.6) or Rails.cache with TTL (Gemini, GPT 5.4).
4. **System prompt via `with_instructions`.** The model knows its role.

Tier B usually fails 2-3 of these. MiMo fails all 4. Sonnet 4.6 has ambitious architecture (multi-conversation sidebar) with a subtle control-flow bug that the tests rubber-stamp. Grok 4.3 writes the cleanest controller in the benchmark but its Stimulus pipeline is dead at runtime, so half the UI doesn't react to events. DeepSeek V4 Pro has the cleanest RubyLLM code (persistent `@chat`) in the snippet it produces; in opencode the run falls back to Opus before covering the checklist, but through DeepClaude the same model covers the checklist and lands in Tier A.

Tier C usually has at least one structural bug: invented fluent DSL, history discarded every request, `ruby_llm` gem in the `:test` group with `require: false`, or bypassing the gem entirely with raw `Net::HTTP`.

## Claude family: Opus 4.6 vs 4.7, Sonnet 4.6

Opus 4.7 leads at 97/100. Textbook-correct code:

```ruby
chat = @client.chat(model:, provider:)
chat.with_instructions(@system_prompt)
previous_messages.each { |msg| chat.add_message({role: msg.role.to_sym, content: msg.content}) }
response = chat.ask(user_message)
response.content
```

`FakeChat` with real signature. Tests verify history replay, error wrapping, model/provider override, system prompt. Session cookie with `to_a`/`from_session` is multi-worker safe. Rescue of `RubyLLM::Error + StandardError` → friendly error bubble.

No relevant deductions this round.

Opus 4.6 has correct code too (83/100 Tier A) but less disciplined. Controller without rescue around `chat_service.ask`: a transient 5xx becomes a stack trace page. Service reaches into `Chat#messages` via `attr_reader` directly, Demeter violation. Material difference between 4.6 (low Tier A) and 4.7 (high Tier A).

Sonnet 4.6 is Tier B (78). Richest UI of the whole benchmark (multi-conversation sidebar). But `LlmChatService#call` only calls `ask` if the last history message is from the user, otherwise it silently returns `""`. The tests rubber-stamp the bug. And the whole conversation fits in a 4KB cookie, which overflows after ~10 turns.

### The 4.7 behavior downgrade

The community complaint on [Reddit and DEV.to](https://dev.to/vibeagentmaking/why-we-switched-back-from-claude-opus-47-to-46-47f9) that "4.7 got worse for coding" isn't about code quality. On objective benchmark it's at the top. What 4.7 made worse is **behavior**:

- New tokenizer [consumes 1x to 1.35x more tokens](https://platform.claude.com/docs/en/about-claude/models/migration-guide) for the same text
- Tries to optimize resources (tokens, tool calls, steps) more aggressively, sometimes cutting corners
- [GitHub issues](https://github.com/anthropics/claude-code/issues/52368) report Max Plan running out in minutes where it used to last hours

I have hundreds of hours with 4.6 and have been testing 4.7 since launch. The code 4.7 produces is Tier A, equal to or better than 4.6. But in daily use, 4.6's more direct behavior is more productive. 4.6 is still my Claude Code default when Claude Code lets me pick (since 4.7 launched, [Claude Code changed the default to xHigh reasoning](https://code.claude.com/docs/en/model-config) and is more restrictive about downgrading to 4.6).

## GPT via Codex: 5.4 and 5.5 at the top

GPT 5.4 xHigh via Codex CLI ties with Opus 4.7 at first (97/100). Uses `RubyLLM.chat(model:, provider: :openrouter, assume_model_exists: true)` + `with_instructions` + `add_message(role:, content:)` + `chat.ask` + `response.content`. Textbook, with provider pinning and registry-skip.

It's the only model with:

- **Explicit API-key preflight** (`ensure_api_key!` raises `MissingConfigurationError`)
- **Differentiated HTTP status codes**: 503 for config error, 502 for runtime error
- **Rails cache persistence with TTL + cap** (24 messages × 12h)
- **Dedicated form object** (`PromptSubmission`) separate from the domain model (`ChatMessage`)

10 test files including partial render tests. `FakeChat`/`FakeClient` match real API.

**Critical weakness**: 7.6M total tokens → ~$16/run. 15× Opus's cost for essentially tied quality. Hard to justify unless you can't iterate on the first try.

### GPT 5.5 xHigh (Codex): 96/100, cheaper and faster than 5.4

OpenAI [released GPT 5.5 yesterday (April 23)](https://openai.com/index/introducing-gpt-5-5/), already [available in Codex](https://community.openai.com/t/gpt-5-5-is-here-available-in-codex-and-chatgpt-today/1379630). I ran the benchmark today. Result: 96/100, Tier A, rank #3.

Good news is 5.5 delivers **the same code quality as 5.4** on this benchmark, with real time and token savings.

| | GPT 5.4 xHigh | GPT 5.5 xHigh | Δ |
|---|---|---|---|
| Score | 97/100 | 96/100 | tie (1-point noise) |
| Elapsed | 22m | 18m | **20% faster** |
| Total tokens | 7.6M | 4.9M | **35% fewer** |
| Output tokens | 63K | 29K | **54% fewer** |
| Est. cost | ~$16 | ~$10 | **40% cheaper** |

The RubyLLM integration is structurally identical to 5.4:

```ruby
chat = RubyLLM.chat(model:, provider: :openrouter, assume_model_exists: true)
chat.with_instructions(SYSTEM_PROMPT)
history.each { |m| chat.add_message(role: m.role.to_sym, content: m.content) }
response = chat.ask(prompt)
response.content.to_s.strip
```

Ships with the same defensive patterns 5.4 has:

- **Dependency-injected `client_factory:`**: lets tests exercise the full seed-history-then-ask path via `FakeClient`, no WebMock required
- **`rescue_from RubyLLM::Error, RubyLLM::ConfigurationError`**: both real error classes, rescued separately
- **Session cookie with 20-message cap**
- **Real Turbo Streams** (`turbo_stream.replace "chat-thread"` + composer)
- **Stimulus composer controller** with proper lifecycle (disable-on-submit, reset, auto-scroll)

### What changes for the user: nothing in quality, everything in cost/speed

This is worth logging. On synthetic capability benchmark, 5.5 and 5.4 tie. Same architectural shape delivered, same defensive patterns, same error rescue, same persistence. Side-by-side code review shows no material difference.

Where 5.5 really wins is **generation efficiency**: 35% fewer total tokens, 54% fewer output tokens, 20% less time. For what used to cost $16/run on 5.4, you pay $10. On continuous use the savings compound.

**It's not a new capability generation.** It's cost optimization on top of architecture that was already at the top. For folks already on Codex, 5.5 replaces 5.4 with no regression. For folks who aren't, at 15× (and now 10×) the cost of Opus for tied quality, it's still hard to justify for continuous use.

**Critical weakness**: no significant defect on this run. Same shape as 5.4 at lower cost. The DI-injected pattern + real error class rescue + session cookie = **best defensive patterns in the whole benchmark**.

### A caveat on price

The ~$16/run for GPT 5.4 and ~$10/run for GPT 5.5 in the table are direct API token costs (pay-as-you-go). In April 2026, OpenAI [switched Codex to use the same API token accounting](https://chatgpt.com/codex/pricing/) inside the Plus, Pro, Business and Enterprise subscriptions. In practice, most Codex CLI users access it via [ChatGPT Plus ($20/mo) or Pro ($200/mo)](https://chatgpt.com/pricing/), where Codex usage falls under the subscription quota (Pro gets [20× Plus's limit](https://help.openai.com/en/articles/20001106-codex-rate-card)). For a Pro subscriber already paying $200/month, a benchmark run adds no marginal cost until they saturate their monthly quota.

So "GPT 5.4 is the most expensive in the ranking" is true under pay-as-you-go and changes under subscription. Anyone already on Pro for everything probably isn't thinking of this in "cost per run" terms. That said, in terms of tokens spent per delivered quality, 5.5 is simply more efficient than 5.4. Even inside the subscription it burns 35% less of the quota.

## DeepSeek: the overhype pattern

Every DeepSeek generation ships with heavy marketing ("competitive with Claude Opus") and ends with the same pattern: **tool support lags behind**.

### V4 Pro: clean code in snippet, harness incompatible in opencode

The RubyLLM snippet it produces, in isolation, is Tier A quality:

```ruby
def initialize
  @chat = RubyLLM.chat
  @messages = []
end

def ask(content)
  result = @chat.ask(content)
  @messages << Message.new(role: "user", content: content)
  @messages << Message.new(role: "assistant", content: result.content)
end
```

Persistent `@chat` instance, delegates multi-turn to RubyLLM. Correct pattern.

In opencode, V4 Pro hits a protocol incompatibility. The model uses thinking mode by default and returns `reasoning_content` on every response. **The DeepSeek API requires the client to echo that `reasoning_content` back in the next request's message history**, or it answers 400 with `"reasoning_content must be passed back to the API"`. The ai-sdk that opencode uses underneath strips that field while building the next request. Every multi-turn call to V4 Pro via opencode fails on turn 2.

What makes this treacherous: opencode doesn't surface that 400 to the user. It buries the error in the event stream and falls back to the `general` fallback agent — which is Opus 4.7. The run "completes," files get written, tasks get marked ok. But if you inspect the trace, you discover that **most of the files were written by Opus, not by DeepSeek**. The half-baked deliverables that drag the score down (stock README, no `docker-compose.yml`, missing bundle-audit) are output from Opus in fallback mode acting without the main agent's context. The 69/100 score on the old record reflects mixed authorship, not V4 Pro for real.

This isn't opencode-specific. **Any ai-sdk-based harness** has the same bug, because the SDK is the one that strips `reasoning_content`.

### V4 Pro unblocked: DeepClaude delivers Tier A at 89/100

In May I ran Round 4 of the orchestration benchmark and found a way to actually measure V4 Pro. There's a shell shim called [DeepClaude](https://github.com/aattaran/deepclaude) that swaps the endpoint Claude Code talks to. Instead of hitting `api.anthropic.com`, Claude Code now calls `openrouter.ai/api/anthropic`, which is OpenRouter's Anthropic-compatible route. That route handles thinking content correctly in the format Claude Code emits (opencode's ai-sdk doesn't). The result: Claude Code's full autonomous loop runs on top of DeepSeek V4 Pro with no protocol bug.

Numbers from the two variants I ran:

| Variant | Score | Time | Cost | Note |
|---|---:|---:|---:|---|
| Claude Code via DeepClaude → V4 Pro (solo) | 84 | 21m | $3.38 | No subagent registered |
| Claude Code via DeepClaude → V4 Pro + Sonnet registered | **89** | 18m | $3.14 | Sonnet registered but never invoked |

The 15-20 point lift over the opencode result is purely a harness-change effect. Same model, same prompt, no new orchestration, just a different agent loop. And the variant with Sonnet registered but never invoked scored +5 over its sister with no subagent. Mere availability of a delegate made the DeepSeek planner decompose better (smaller seams, cleaner DI, system prompt via `with_instructions`). Full technical details in the [dedicated post](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/).

Where this leaves V4 Pro:

- In opencode (and any ai-sdk): unmeasurable. What I wrote above still applies.
- In Claude Code with DeepClaude: Tier A at 89/100, $3.14 in 18 minutes.
- In Claude Code direct against the Anthropic API with `DEEPSEEK_API_KEY`: not tested, but the native route also handles thinking content properly.

For anyone without an Anthropic subscription who wants Tier A coding, the DeepClaude variant running entirely on `OPENROUTER_API_KEY` is the first real answer the benchmark has produced.

This is the pattern that shows up every time DeepSeek ships: tool support lags. The community takes weeks to figure out integration, the thinking-mode protocol is more complex at runtime, and support in open-source tooling accumulates gaps the provider doesn't fix. If you need a production pipeline today that integrates DeepSeek, you'll probably have to maintain your own patches — or use DeepClaude.

### V4 Flash: cheapest viable option (78/100 Tier B)

$0.01/run, 2m 35s, fixes V3.2's critical bug (invented `RubyLLM::Client` class). API all correct (now that I know `add_message(role:, content:)` is valid). Session-replay multi-turn via `session[:messages]`. WebMock tests the real OpenRouter endpoint and exercises the LLM path. All of this pushes it to 78/100 Tier B.

**Gotcha:** the model slug is `"claude-sonnet-4"` missing the `anthropic/` prefix. 404 at OpenRouter at runtime. One-character fix, but fatal if you deploy blind.

At Tier B, $0.01/run, V4 Flash is the cheapest model that gets close to "code that works with one manual patch".

### V4 vs V3.2: real generational upgrade

| | V4 Flash | V4 Pro (DeepClaude) | V4 Pro (opencode) | V3.2 (previous) |
|---|---|---|---|---|
| Score | 78 | **89** | 69 (mixed authorship) | 43 |
| Tier | B | **A** | unmeasurable | C |
| Harness | completes | completes | reroute to Opus fallback | completes |
| Time | 2m 35s | 18m | 22m | 60m |
| Cost/run | ~$0.01 | ~$3.14 | ~$0.50 (Opus underneath) | ~$0.07 |
| RubyLLM API | correct | correct | correct (snippet only) | invented `RubyLLM::Client` |
| Deliverables | mostly present | full | written by Opus fallback | decent |

V4 Flash is the cheap option that works. V4 Pro needs DeepClaude (Claude Code with env vars pointed at OpenRouter) to deliver its full potential; in opencode it stays unmeasurable.

## Kimi: K2.5 → K2.6

### K2.6 (87/100, Tier A)

Positive surprise. Only non-Western model at Tier A. Textbook code:

```ruby
chat = RubyLLM.chat
chat.with_instructions(SYSTEM_INSTRUCTION)
historical_messages.each do |msg|
  chat.add_message(role: msg[:role], content: msg[:content])
end
response = chat.ask(user_message)
response.content
```

Unique combination among Chinese models: `FakeChat` matching real API, rescue of `RubyLLM::Error` (with flash via turbo_stream), session cookie with `MAX_MESSAGES = 50` cap. Complete Gemfile. Multi-worker safe.

Only deduction is the full history replay on each turn (uses more tokens than MiMo's persistent pattern).

At $0.30/run, Kimi K2.6 is the **cheapest Tier A in the benchmark**. 3 to 50× cheaper than Opus 4.7 and GPT 5.4 xHigh.

### K2.5 (69/100 Tier B, not Tier 3 as I had claimed)

In the first version I cataloged K2.5 as Tier 3 for supposedly inventing `chat.complete` and using kwargs in `add_message`. Both are real public API. K2.5 comes back to Tier B.

It drops from K2.6 to K2.5 because: 37 tests (most in the benchmark) never mock RubyLLM. They only test PORO CRUD and `respond_to?`. Test coverage without mock fidelity measures nothing. And it uses class-var storage (`Chat.storage = @storage ||= {}`), worse than Singleton because there's no mutex.

K2.6 adds what K2.5 didn't have: `FakeChat` with the right signature, rescue, session cookie. Real evolution in the dimensions that matter.

## Xiaomi MiMo V2.5 Pro: looked like Tier 1, but the gaps are real

MiMo V2.5 Pro (April 2026) generated the most hype of this round. In the first analysis I promoted it as "first non-Anthropic Tier 1". After the new rubric, it drops to Tier B (67/100).

RubyLLM code is still clean:

```ruby
@llm_chat = RubyLLM::Chat.new(model: MODEL, provider: PROVIDER)
response = @llm_chat.ask(content, &)
@messages << { role: :assistant, content: response.content }
```

`Chat.new(model:, provider:)` is a valid public constructor. `.ask(content, &)` forwards a streaming block. Zero manual `add_message` calls. Multi-turn delegated to RubyLLM itself. **It's the cleanest pattern any model in this benchmark produced.**

But the holistic score = 67 because the other components have gaps:

- **Tests don't exercise the LLM path.** The 21 tests only check constants and blank guards. `ChatSessionTest` has no happy-path test. If the LLM call worked or silently failed, no test would catch it.
- **No error handling.** No `rescue` around `@chat.ask`. Rate limit becomes 500 with stack trace on screen.
- **`ChatStore` Singleton is process-local.** Dies on Puma restart, doesn't work with `WEB_CONCURRENCY > 1`, no TTL.
- **No `with_instructions`**, the model doesn't know its role.

Around those four gaps are smaller ones: Docker without healthcheck, no `restart: unless-stopped`, no Thruster (Rails 8.1 default), short README.

Genuine advantage: idiomatic use of the library. For a greenfield single-worker app, it's less code with the same functionality. Opus's manual replay pattern is actually more defensive than the library itself recommends.

At $0.14/run in 11 minutes, it's **8× cheaper and faster than Opus**. For throwaway prototypes, it's genuinely useful.

**Verdict**: MiMo is ~70% of Opus quality at 12.5% of the price. For throwaway prototype, worth it. For production, ~2 engineer-hours adding rescue + Rails.cache + FakeChat + WebMock + system prompt. At that point Opus at $1.10 comes out cheaper overall.

## Gemini 3.1 Pro: the quiet surprise (82/100 Tier A)

I had classified it as Tier 3. Re-audit showed `Chat.new` and `add_message` kwargs form are real API.

Strong points: real Turbo Streams (not fetch + innerHTML), Rails.cache-backed persistence with 2h expiry, FakeChat mocks matching the real API, error path tested.

Critical weakness: it uses the model string `claude-3.7-sonnet` instead of the current Sonnet 4.x. One-character fix.

At $0.40/run, Gemini 3.1 Pro is the other cost-effective Tier A alongside Kimi K2.6.

## Qwen family: distillation doesn't save you

Tested several Qwens:

| Model | Type | Tier | Detail |
|---|---|:---:|---|
| Qwen 3.6 Plus | Cloud, OpenRouter | B (71) | Correct RubyLLM API; tests make real calls (no WebMock); client-side JS history |
| Qwen 3.5 35B | Local NVIDIA | C (55) | Correct entry point; no multi-turn; test wraps real call in `rescue => e; assert true` |
| Qwen 3.5 122B | Local NVIDIA | D (37) | Doesn't use ruby_llm; uses `Openrouter::Client` (wrong casing) |
| Qwen 3 Coder Next | Local NVIDIA | D (32) | Invents `RubyLLM::Client.new`; commits placeholder `.env` |
| Qwen 3.5 27B Claude-distilled | Local NVIDIA | still Tier 3 on re-review | Code looks Claude-shaped, but invents the entire API |

### The discovery: Claude distillation doesn't transfer library knowledge

I ran [Jackrong's Qwen 3.5 27B distilled from Claude 4.6 Opus](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled). The promise was "Claude-at-home" running locally. The result: the code comes out Claude-styled (frozen_string_literal, Response value objects, layered architecture, doc comments), but functionally it's full-blown hallucination:

```ruby
RubyLLM::Chat.new.with_model(@model) do |chat|
  conversation_history.each do |msg|
    chat.add_message(role: :user, content: msg[:content])
  end
  response = chat.ask(message)
  Response.new(content: response.text, usage: build_usage(response))
end
```

The issue here is the invented block form `.with_model(@model) do |chat| ... end` (doesn't exist in the gem), and `response.text` instead of the real `response.content`.

Distillation transferred the **style** and stopped there. Factual memory about a specific library is binary recall: it's either in the weights or not. Claude's reasoning traces don't contain repetitions like "use `ask`, not `complete`" because that's not reasoning, it's raw memory.

If you need the model to actually use RubyLLM or any less popular library, Claude distillation won't save you. Use actual Claude or a large cloud model.

### Coder vs General: the inverse surprise

Intuitively, models with "Coder" in the name should be better for programming. In this benchmark, the opposite happened. Of the three Qwen Coders tested:

- Qwen 3 Coder 30B returned a hardcoded mock string instead of calling RubyLLM
- Qwen 2.5 Coder 32B timed out at 90 minutes with zero files
- Qwen 3.5 27B Sushi Coder RL had infra failure

Meanwhile the general Qwen 3.5 35B-A3B completed in 5 minutes with a recognizable Rails project. My reading: the "Coders" were fine-tuned on isolated problems (Codeforces, Leetcode, short snippets), far from the long-running agentic flows with tool calling. "Coder = better for coding agent" is false for this kind of task.

### Qwen 3.6 Plus: the cloud that almost arrived

Qwen 3.6 Plus on OpenRouter completed the benchmark in 17 minutes and is the cleanest Qwen I've measured (71/100 Tier B). Correct RubyLLM API. Well-built Stimulus controller. But tests make real calls to OpenRouter (no WebMock), and history is client-side JS only (lost on refresh). Uses `fetch` + `innerHTML` instead of Turbo Streams.

## GLM family: 5, 5.1, local 4.7 Flash

### GLM 5 (64/100 Tier B)

`RubyLLM.chat(model: "anthropic/claude-sonnet-4")` + `chat.ask` + `response.content` correct. Mocha stubs match the real API. One happy-path test, no error-path coverage.

**Critical weakness**: zero multi-turn state. Every POST creates a fresh `RubyLLM.chat` without history. The "chat app" is a stateless echo service. "What did I just say?" → "I don't know."

### GLM 5.1 (46/100 Tier C, dropped)

This is the most painful fall from the re-audit. `RubyLLM.chat(model:, provider:)` is correct, but history is replayed via `c.user(msg)` / `c.assistant(msg)`, fluent DSL that **doesn't exist** in RubyLLM (confirmed via grep of the gem source).

Worse: every HTTP request constructs a new `ChatSession.new` that discards history. The two bugs mask each other: the invented DSL rarely fires because there's never any history to replay.

Stimulus controller uses `fetch` + manual `innerHTML`. SSE-based but not Turbo Streams.

Per Z.ai itself, [GLM 5.1 beats GPT 5.4 and Opus 4.6 on SWE-Bench Pro](https://openrouter.ai/z-ai/glm-5.1/benchmarks). In this specific benchmark (Rails + RubyLLM + complete deliverables), it drops to Tier C. More evidence that benchmarks are specific.

### GLM 4.7 Flash bf16 local (52/100 Tier C)

The local model that most dominates the RubyLLM API. Uses the fluent chain `.with_model().with_temperature().with_params().with_instructions().complete(&block)`, all real API per gem source.

**Fatal bug**: `gem "ruby_llm"` is in `group :development, :test` with `require: false`. Doesn't load in production. `NameError` at boot. Uses class-var `Message.all` (process-local).

## Grok: from Tier D to Tier B (4.20 → 4.3)

Grok 4.3 entered the benchmark in May 2026 and deserves a separate section, because it's the biggest intra-family jump in the whole benchmark. Grok 4.20 scored 25/100 Tier D (still listed in the losers section right below). Grok 4.3 scores **72/100 Tier B**, ranking between Qwen 3.6 Plus (71) and Kimi K2.5 (69). 47 points of jump. Cost $1.74 per run (15m wall time, 1.0M input + 18K output + 2.2M cache_read tokens, 102 step finishes).

What it does well, and does well:

- **Correct RubyLLM API on all five calls**: `RubyLLM::Chat.new(model:)` + `add_message(role:, content:)` + `chat.ask` + `response.content` + `RubyLLM::Error` rescue. Verified against the gem 1.14.1 source, no hallucinations. Counter-grep zeroed: `grep -nE "RubyLLM::Client|chat\.complete|chat\.send_message|chat\.user|chat\.assistant"` returns 0 hits.
- **Cleanest controller in the benchmark**: 48 lines, no service-object over-engineering, no invented fluent DSL.
- **Real Turbo Streams**: the server-side reactive parts work.
- **Material deliverables**: real README, real `compose.yaml`, working multi-stage Dockerfile, cookie-based session persistence.

The killer weakness is awkward to describe: **Stimulus is dead at runtime.** The `app/javascript/application.js` is a one-liner comment, no `import "./controllers"`, no `Application.start()`. The compiled `app/assets/builds/application.js` weighs 48 bytes (just a sourcemap pointer). The `controllers/index.js` imports `./application`, which doesn't exist. Result: every `data-controller="chat"` is inert. Enter-to-send, autoresize, autoscroll, clear-input — all silently broken. Phase 2 of the benchmark (boot validation) reported "local boot OK" without exercising the JS layer, so the gap slipped through.

Other smaller issues:

- Tests stub `RubyLLM.stub :chat` but the controller calls `RubyLLM::Chat.new`. The stub is bypassed, so the test either hits the network for real or fails for missing key.
- Stale model pin: `anthropic/claude-3.7-sonnet` in code, README says "latest Claude Sonnet" (current is 4.7).
- No `with_instructions` for system prompt.

The direct cost comparison is unfavorable: $1.74/run for Grok 4.3 vs $0.30/run for Kimi K2.6 (Tier A, 87/100). That's **5× more expensive for a worse result**. Grok 4.3 sits in an awkward price/quality slot: good enough for Tier B, but in Tier B there are options 5× cheaper (Kimi K2.5 at $0.10) and in Tier A there are options at almost the same price (Kimi K2.6 at $0.30). xAI still has to find the lane where Grok makes economic sense.

The general read: Grok 4.3 shows the family materially improved generation over generation (47 points is a huge jump). But it hasn't reached the level of the models that dominate the top yet. Worth keeping an eye on the next generation.

## The losers (Tier C/D): MiniMax, Grok 4.20, Step, DeepSeek V3.2, GPT OSS

| Model | Score | Tier | Reason |
|---|---:|:---:|---|
| Step 3.5 Flash | 56 | C | Bypasses `ruby_llm` entirely with `Net::HTTP`; not compliant with prompt |
| DeepSeek V3.2 | 43 | C | Invents `RubyLLM::Client.new` and `client.chat(messages: [...])`; tests mock a class that doesn't exist |
| MiniMax M2.7 | 41 | C | Invents `RubyLLM.chat(model:, messages: [...])` batch signature; crashes on first call |
| Qwen 3.5 122B | 37 | D | Uses `Openrouter::Client` (wrong casing); calls `client.chat` on a method the gem doesn't expose |
| Qwen 3 Coder Next | 32 | D | Invents `RubyLLM::Client.new` + `client.chat(messages:)` + OpenAI-shaped response |
| Grok 4.20 | 25 | D | `ruby-openai` in `:development, :test` with `require: false` → NameError in production; uncompilable Stimulus JS |
| GPT OSS 20B | 11 | D | No tests folder; nested `app/app/`; invents `RubyLLM::Client.new` |

## Models that didn't complete the benchmark

The ranking above lists the 24 models that **completed** the benchmark enough to be audited. But the benchmark covers more than that. In total, 34+ were configured, 28+ ran, and only 17-24 (depending on the criterion) completed enough to become auditable code. The ones that failed deserve to be logged:

| Model | Harness | Problem | Root cause |
|---|---|---|---|
| Gemma 4 31B (local, llama.cpp) | local | Infinite tool-call loop after ~11 steps | [llama.cpp bug #21375](https://github.com/ggml-org/llama.cpp/issues/21375), partially fixed in b8665 |
| Gemma 4 31B (Ollama Cloud) | cloud | 504 timeout at ~20K tokens | Cloudflare 100s edge timeout; benchmark runs pass 50K tokens, no way |
| Llama 4 Scout (local) | local | Tool calls emitted as plain text | llama.cpp has no parser for Llama 4's pythonic format (vLLM does) |
| Qwen 3 32B (local) | local | Too slow (7.3 tok/s) | Hardware bottleneck (fits in VRAM, bandwidth doesn't deliver) |
| Qwen 2.5 Coder 32B (local) | local | 90-minute timeout with zero files | Infinite reasoning loop without calling the write tools |
| GPT 5.4 Pro (OpenRouter) | cloud | Stalled after tool-calls | OpenRouter tool-calling integration broken for GPT; use Codex CLI instead |

Also tested but didn't make the final comparison for various reasons: Qwen 3.5 27B Claude-distilled (covered in the Qwen section as an example of distillation not transferring library knowledge), Qwen 3 Coder 30B (returned a hardcoded mock string instead of calling RubyLLM), Qwen 3.5 27B Sushi Coder RL (llama-swap infra failure), Qwen 3.6 35B local (best Qwen local result, but missing `.content` on the return, 1-line fix to work).

Practical lesson from these failures: **half the challenge of running open source locally in 2026 lives in the toolchain**. llama.cpp bugs, Ollama lifecycle, missing tool-call parsers, Ollama Cloud Cloudflare timeouts. Even if the model is good, if the stack that runs it hangs every 11 tool calls, in practice you can't use it.

## The Chinese situation: the gap in practice

The benchmark covers essentially every Chinese LLM family with recent releases: **Moonshot** (Kimi), **DeepSeek**, **Xiaomi** (MiMo), **Alibaba** (Qwen), **Z.ai** (GLM), **MiniMax** and **StepFun** (Step). Worth consolidating the whole picture, because the "China has caught up" narrative is more optimistic than this benchmark sustains.

### Distribution by tier

- **Tier A (80+)**: **Kimi K2.6** (87) and **DeepSeek V4 Pro** via DeepClaude (89, with the caveat that it requires a custom harness).
- **Tier B (60-79)**: Kimi K2.5 (69), DeepSeek V4 Flash (78), Xiaomi MiMo V2.5 Pro (67), Qwen 3.6 Plus (71), GLM 5 (64). DeepSeek V4 Pro in opencode scored 69 but with mixed authorship (reroute to Opus fallback), so unmeasurable in that harness.
- **Tier C (40-59)**: Step 3.5 Flash (56), GLM 4.7 Flash local (52), GLM 5.1 (46), DeepSeek V3.2 (43), MiniMax M2.7 (41).
- **Tier D (<40)**: Qwen 3.5 122B local (37), Qwen 3 Coder Next local (32).

Out of 13 Chinese models tested (counting both local and cloud), **two** reach Tier A: Kimi K2.6 with no caveats and DeepSeek V4 Pro only through DeepClaude. That's the current penetration in this specific benchmark.

### The gap in points

**Kimi K2.6 vs Opus 4.7 (Tier A vs Tier A)**: 87 vs 97. 10-point gap. In practice, both deliver correct RubyLLM, real-signature FakeChat, error rescue, multi-worker-safe session cookie, complete Gemfile. What Opus 4.7 has extra are secondary dimensions that accumulate: tests that cover error wrapping, model/provider override and explicit system prompt application; redundant rescue in the controller beyond the service; slightly better concerns separation. Perceptible differences side by side, but not tier-separated.

Cost: K2.6 $0.30/run vs Opus 4.7 $1.10/run. **3.6× cheaper.** In continuous production runs, that difference accumulates.

**Chinese Tier B vs Claude Opus 4.6 (83 Tier A)**: 5 to 20-point gap. The Chinese Tier B models (MiMo, DeepSeek V4 Flash, Kimi K2.5, Qwen 3.6 Plus, GLM 5) have correct or near-correct RubyLLM code, but fail on specific components:

- **Test quality** is the universal weakest spot. Chinese Tier B models often write many tests (K2.5 wrote 37, the most in the benchmark) but don't mock RubyLLM. Coverage theater.
- **Persistence** frequently uses process-local Singleton (MiMo) or class-var (K2.5) instead of session cookie or Rails.cache. Dies on restart, not multi-worker safe.
- **Error handling** is usually absent. Rate limit becomes 500 with a stack trace visible to the user.

### Patterns by family

**Moonshot (Kimi)**: the most disciplined Chinese family. K2.5 at Tier B and K2.6 at Tier A. Real generational evolution in the dimensions that matter (tests, rescue, persistence).

**DeepSeek**: pattern of tool support lagging. Each generation has better RubyLLM code than the previous (V3.2 invented everything, V4 Flash writes correct, V4 Pro writes perfect). In ai-sdk harnesses (opencode included), V4 Pro stays incompatible because of the `reasoning_content` echo protocol. But via DeepClaude (Claude Code with env vars swapping the endpoint), the same model delivers Tier A at 89/100. The marketing matches the product, as long as you use the right harness.

**Xiaomi (MiMo)**: writes the most **idiomatic** RubyLLM code in the benchmark (persistent `@chat`, zero manual `add_message`). But forgets real tests, rescue, robust persistence. Lands at Tier B with prototype-demo quality, not production.

**Alibaba (Qwen)**: high variance. Qwen 3.6 Plus cloud reaches Tier B. Qwen 3.5 35B local at Tier C with patches. Qwen 3.5 122B and the "Coders" (Qwen 3 Coder Next, Qwen 2.5 Coder 32B) fall to Tier D for inventing API or hanging. "Coder" in the name isn't a guarantee for coding agent.

**Z.ai (GLM)**: GLM 5 at reasonable Tier B. GLM 5.1 **regressed** to Tier C, with invented fluent DSL plus history discard. Z.ai claims superiority in SWE-Bench Pro, but this specific benchmark caught two structural bugs. GLM 4.7 Flash local gets close but the gem in the `:test` group kills it in production.

**MiniMax** and **StepFun (Step)** don't deliver. MiniMax invented a batch signature that crashes on first call. Step bypasses the `ruby_llm` gem entirely with `Net::HTTP`, violating the prompt.

### Conclusion on the Chinese gap

For this specific benchmark (Rails + RubyLLM + complete deliverables):

- **Two Chinese models** deliver Tier A: **Kimi K2.6** (87/100, 10-point gap vs Opus, 3.6× cheaper) and **DeepSeek V4 Pro** (89/100 through DeepClaude — needs the custom harness, but fits within the budget of anyone who already has an `OPENROUTER_API_KEY`).
- **Five Chinese models** deliver Tier B usable with 1-2h of patching: K2.5, V4 Flash, MiMo, Qwen 3.6 Plus, GLM 5.
- **The rest are not usable** in production for this kind of task.

The narrative of "China has already caught up with the West in coding LLMs" needs to be read with caveats. On synthetic reasoning benchmarks, maybe. On the benchmark of delivering a complete Rails app with every part functional? Two models caught up, with the caveat that one of them (V4 Pro) only works in a non-default harness. The others are still a generation behind.

## The reality of running open source locally

Every viable open source in the benchmark landed at Tier C or worse. Worth explaining why.

### VRAM + KV Cache: the math nobody does

Take Qwen3 32B. FP16 takes ~64 GB. Quantized to Q4, it drops to ~19 GB. So it fits on a 32 GB RTX 5090, right? **Wrong.** That's only the model weights. You're missing the KV Cache.

KV Cache is the memory the model uses to "remember" what it already read. It scales **linearly** with context:

```
KV Memory = 2 × Layers × KV_Heads × Head_Dim × Bytes_per_Element × Context_Tokens
```

For a Llama 3.1 70B in BF16, that's ~0.31 MB per token. A 128K-token context = **40 GB** of KV Cache alone. In real benchmark runs, models consumed between 39K and 156K tokens. Less than 100K context isn't practical for a coding agent.

Google published [TurboQuant](https://research.google/blog/turboquant-redefining-ai-efficiency-with-extreme-compression/) (ICLR 2026), which compresses KV Cache to 3 bits without accuracy loss, 6× reduction and up to 8× speedup. Not yet implemented in llama.cpp or Ollama.

### Memory bandwidth rules, capacity doesn't

"But I have 128 GB of RAM!" Nice, but what matters is memory bandwidth. Brutal differences:

| Memory | Bandwidth |
|---|---:|
| DDR4 | ~50 GB/s |
| LPDDR5x (AMD Strix) | ~256 GB/s |
| GDDR6 (RTX 3090) | ~936 GB/s |
| GDDR7 (RTX 5090) | ~1,792 GB/s |
| HBM3 (Mac Studio M4 Ultra) | ~800 GB/s |

RTX 5090 has 7× more bandwidth than my Minisforum's LPDDR5x. On the AMD, Qwen3 32B runs at ~7 tok/s; on the 5090, it would be much faster if it fit.

For Mac Studio M4 Ultra with 512 GB of unified memory (~$10k), it's practical but pricey. For AMD Ryzen AI Max with LPDDR5x 256 GB/s, it's accessible but slow. For DDR4 desktop, it's unviable.

### Ollama vs llama.cpp: each with its own problems

[Ollama](https://ollama.com/) failed 6 of 8 local benchmark attempts: mid-session model unloading, context drift, flaky lifecycle, broken bf16. I migrated to [llama-swap](https://github.com/mostlygeek/llama-swap) (Go wrapper around llama-server). It fixed the lifecycle but brought other problems: each model needs specific flags (GLM/Qwen 3.5 need `--reasoning-format none` for `<think>` tags), tool-call parsers depend on the model (Llama 4's pythonic format doesn't parse), Gemma 4 requires build b8665+ and still enters repetition loops after ~11 tool calls.

Plug-and-play it isn't.

## The harness also matters

**The same Opus 4.7 model produced measurably worse code on Claude Code than on opencode.** The difference is harness context pollution. Claude Code uses 6-11M cache-read tokens per run (vs ~210K on opencode) and that nudges the model toward generic patterns like the OpenAI SDK instead of RubyLLM-specific.

Practical translation: even with the same model, the tool you invoke it through changes the output. For stable model testing, I ran everything on opencode.

## Multi-model isn't worth it for greenfield coding

Question that shows up every week in my feed: is it worth configuring two models in the same project? Opus for planning, GLM for executing, Haiku for boilerplate? I tested 7 combinations across 3 harnesses:

- Claude Code: Opus 4.7 alone (baseline), Opus 4.7 + Sonnet 4.6 subagent, Opus 4.7 + Haiku 4.5 subagent
- opencode: Opus 4.7 + GLM 5.1 subagent, Opus 4.7 + Qwen 3.6 local subagent
- Codex: GPT 5.4 xHigh + GPT 5.4 medium, GPT 5.4 xHigh + GPT 5.4 low

**Zero of the 7 runs voluntarily delegated to the subagent.** The main model did 100% of the work alone in every case, even with the subagent declared with aggressive language like "Use PROACTIVELY" and "ALWAYS delegate to this agent for code implementation". Three reasons:

### Reason 1: Tier A models already plan-then-execute internally

Opus 4.7 and GPT 5.4 xHigh recognize when a task calls for planning + implementation and already do that **within the same thought session**, without external context switch. The "let's split this into design + code" reasoning happens internally. Externalizing that with two separate models breaks the continuous context and gains nothing.

### Reason 2: coordination costs are high

Subagents receive a reduced prompt, partial context, and have to return structured output the main model consumes. All that back-and-forth adds tokens, latency, and opportunities for misalignment. The main model prefers to absorb the cost of doing it alone rather than pay the cost of coordinating with another model. This is rational: economically, the subagent would only pay off if it were much cheaper AND produced equivalent output. Usually it's cheaper **but worse**.

### Reason 3: there's no clean plan-vs-execute line in greenfield

On a Rails app from scratch, you plan while implementing, revise decisions when you hit concrete problems, rebalance trade-offs along the way. Splitting that artificially between two agents forces a separation that doesn't reflect how the work actually happens on a cohesive task.

### The "Opus plans, Qwen executes" case

The worst combination was Opus + Qwen 3.6 local. Opus is Tier A on RubyLLM, Qwen is Tier C. The theory: Opus (expensive) plans, Qwen (free) executes. In practice:

1. Opus didn't delegate. It did everything alone.
2. If it had delegated, the Qwen code would come out Qwen-quality (invents API, no correct mocks).
3. Opus ↔ Qwen coordination isn't free.

Three false assumptions in the theory. Practical conclusion: **if you're going to pay Opus to plan, let it do everything**. That's what it wants to do naturally. Forcing delegation to an inferior model adds coordination without reducing cost and makes the result worse.

### When multi-model does make sense

Not on a cohesive greenfield task. It makes sense on separate pipelines where each model has a well-defined scope: fast classifier filtering input, large model processing only the subset that passed the filter, small model translating output. That's not "Opus plans Qwen executes" in the same agent session, it's multi-service architecture with different APIs.

For interactive coding agent on a real project, the rule of thumb is: pick one good Tier A model, use it alone, optimize the prompt instead of the orchestration.

## Best commercial, best open source

### Commercial

**Tier A premium**: Claude Opus 4.7, GPT 5.4 xHigh (Codex), GPT 5.5 xHigh (Codex), Claude Opus 4.6. Pick by behavior preference; code quality is there on all of them. Among the GPTs, 5.5 costs 40% less than 5.4 at the same output.

**Tier A cost-effective**: Kimi K2.6 ($0.30/run), Gemini 3.1 Pro ($0.40/run). 3-4× cheaper than Opus/GPT with comparable quality within this benchmark.

**Tolerable Tier B**: Claude Sonnet 4.6 ($0.63), DeepSeek V4 Flash ($0.01), Xiaomi MiMo V2.5 Pro ($0.14). Needs 1-2h of patching to ship to production.

**Cheapest useful**: DeepSeek V4 Flash ($0.01/run) with the `anthropic/` prefix fix on the model slug.

### Open source (local)

**No Tier A.** The best local that ran was **Qwen 3.5 35B-A3B** at Tier C (55/100), and it needs 1-2 correction prompts to deliver working code. For those with an RTX 5090 who want to escape vendor lock-in, that's the model to run, but with hobby/lab expectations, not production.

**Qwen 3.6 35B local** is the closest to working I've seen (1-line fix to add `.content`), but still without multi-turn.

**GLM 4.7 Flash local** is the most RubyLLM-literate local, but the gem in the wrong group kills the app in production. Trivial fix, structural impediment.

**In 2026, running open source locally for coding agent is viable with caution, on high-end hardware (RTX 5090 or Mac M4 Ultra), accepting 1-3 corrections per run.** It's not a substitute for Claude yet.

## Conclusion

Claude Opus 4.6 is still my daily pick for coding agent on real projects. Predictable behavior, defensive code, real mocks, sensible persistence, error handling.

Opus 4.7 leads the objective benchmark (97/100) but has a behavior downgrade (heavier tokenizer, aggressive resource optimization). On benchmark it delivers. In daily use I prefer 4.6.

GPT 5.4 xHigh via Codex ties at the top (97/100), and **GPT 5.5 xHigh landed third at 96/100**: same quality as 5.4, but 40% cheaper and 20% faster. For anyone already on Codex, 5.5 replaces 5.4 with no regression. At 10× Opus's price (used to be 15×) for essentially tied quality, it's still pricey for continuous use.

The cost-effective sweet spot now is **Kimi K2.6 at $0.30/run** or **Gemini 3.1 Pro at $0.40/run**. Both Tier A. 3-4× cheaper than Opus.

Local open source hasn't reached Tier A yet. The best is Qwen 3.5 35B-A3B at Tier C with corrections. For experimentation, worth it. For production, not yet.

The biggest lesson from the re-audit is about process: **when you start classifying models based on "hallucinations" you think you found, go to the library source and check directly**. I was discarding models for valid API calls. Once I checked against the gem, Kimi, Gemini, DeepSeek V4 Flash and GPT 5.4 all improved. And once the criterion included deliverables (docker-compose, substantive README, bundle-audit), models that looked clean but delivered incomplete projects (Step 3.5 Flash via bypass) fell to the tier that reflected that. And the DeepSeek V4 Pro case showed that harness choice can be as decisive as the model: under opencode the run is mixed authorship (Opus fallback underneath) and unmeasurable; through DeepClaude the same model delivers Tier A.

Benchmark is a tool, not truth. What I test here is a specific Rails app with a specific library. Models may perform differently on other tasks. The methodology is explicit in [`audit_prompt_template.md`](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/audit_prompt_template.md) for anyone who wants to replicate, adapt, or challenge it.

The [repo](https://github.com/akitaonrails/llm-coding-benchmark) is public with all the success_reports and diffs.

## Sources

- [Claude Opus 4.7 — What's new](https://platform.claude.com/docs/en/about-claude/models/whats-new-claude-4-7), Anthropic
- [Migration guide Claude 4.6 → 4.7](https://platform.claude.com/docs/en/about-claude/models/migration-guide), new tokenizer
- [GitHub issue #52368 — Opus 4.7 instability](https://github.com/anthropics/claude-code/issues/52368)
- [DEV.to — Why We Switched Back from Opus 4.7 to 4.6](https://dev.to/vibeagentmaking/why-we-switched-back-from-claude-opus-47-to-46-47f9)
- [OpenAI — Introducing GPT-5.5](https://openai.com/index/introducing-gpt-5-5/)
- [OpenAI Community — GPT-5.5 is here in Codex](https://community.openai.com/t/gpt-5-5-is-here-available-in-codex-and-chatgpt-today/1379630)
- [Simon Willison — GPT-5.5 via Codex](https://simonwillison.net/2026/Apr/23/gpt-5-5/)
- [GLM 5.1 benchmarks on OpenRouter](https://openrouter.ai/z-ai/glm-5.1/benchmarks)
- [GLM 5.1 review — Build Fast With AI](https://www.buildfastwithai.com/blogs/glm-5-1-open-source-review-2026)
- [Jackrong's Qwen 3.5 27B Claude Opus Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled)
- [TurboQuant (Google Research, ICLR 2026)](https://research.google/blog/turboquant-redefining-ai-efficiency-with-extreme-compression/)
- [Ahmad Osman — GPU Memory Math for LLMs (2026)](https://x.com/TheAhmadOsman/status/2040103488714068245)
- [llama-swap](https://github.com/mostlygeek/llama-swap), llama.cpp wrapper
- [llama.cpp issue #21375 — Gemma 4 tool call loops](https://github.com/ggml-org/llama.cpp/issues/21375)
