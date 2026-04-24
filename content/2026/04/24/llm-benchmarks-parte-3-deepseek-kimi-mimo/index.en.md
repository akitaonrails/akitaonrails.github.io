---
title: "LLM Coding Benchmark (April 2026): DeepSeek v4, Kimi v2.6, MiMo, and the State of the Art"
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

**TL;DR:** This is the canonical (and for now, definitive) version of my LLM coding benchmark. It supersedes the [earlier April posts](https://github.com/akitaonrails/akitaonrails.github.io) which are now deprecated. I re-audited the 22 models against the `ruby_llm` gem source instead of memory, and several models I had flagged for "inventing API" actually write correct code. Kimi K2.6 moved to Tier A. Gemini 3.1 Pro too. GLM 5.1 dropped to Tier C. MiMo V2.5 Pro fell from "first non-Anthropic Tier 1" to Tier B. Opus 4.7 and GPT 5.4 xHigh tie at the top (94/100). Opus 4.6 is still my daily pick on **behavior**, not code. Long details below.

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

## Final ranking (22 models)

| Rank | Model | Score | Tier | RubyLLM OK | Time | Cost |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | **94** | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | **94** | A | ✅ | 22m | ~$16 |
| 3 | Kimi K2.6 | **84** | A | ✅ | 20m | ~$0.30 |
| 4 | Gemini 3.1 Pro | **82** | A | ✅ | 14m | ~$0.40 |
| 5 | Claude Opus 4.6 | 80 | A | ✅ | 16m | ~$1.10 |
| 6 | Claude Sonnet 4.6 | 75 | B | ✅ | 16m | ~$0.63 |
| 6 | DeepSeek V4 Flash | 75 | B | ✅ | 3m | ~$0.01 |
| 8 | Qwen 3.6 Plus | 68 | B | ✅ | 17m | ~$0.15 |
| 9 | DeepSeek V4 Pro | 66 | B | ✅ | 22m (DNF) | ~$0.50 |
| 9 | Kimi K2.5 | 66 | B | ✅ | 29m | ~$0.10 |
| 11 | Xiaomi MiMo V2.5 Pro | 64 | B | ✅ | 11m | ~$0.14 |
| 12 | GLM 5 | 61 | B | ✅ | 17m | ~$0.11 |
| 13 | Step 3.5 Flash | 53 | C | ⚠️ bypass | 38m | ~$0.02 |
| 14 | Qwen 3.5 35B (local) | 52 | C | ✅ | 28m | free |
| 15 | GLM 4.7 Flash bf16 (local) | 49 | C | ✅ | failed | free |
| 16 | GLM 5.1 (Z.ai) | 43 | C | ❌ | 22m | subscription |
| 17 | DeepSeek V3.2 | 40 | C | ❌ | 60m | ~$0.07 |
| 18 | MiniMax M2.7 | 38 | D | ❌ | 14m | ~$0.30 |
| 19 | Qwen 3.5 122B (local) | 34 | D | ❌ | 43m | free |
| 20 | Qwen 3 Coder Next (local) | 29 | D | ❌ | 17m | free |
| 21 | Grok 4.20 | 22 | D | ❌ | 8m | ~$0.60 |
| 22 | GPT OSS 20B (local) | 8 | D | ❌ | failed | free |

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
- **GPT 5.4 xHigh** ties for first with Opus 4.7 (94/100). Impeccable architecture + complete deliverables.
- **DeepSeek V4 Pro** dropped from "Tier 1 code" to Tier B (66). Half-baked deliverables: stock README + no docker-compose + missing bundle-audit.
- **MiMo V2.5 Pro** dropped from "first non-Anthropic Tier 1" to Tier B (64). Tests don't exercise LLM + process-local Singleton + no rescue + no system prompt.
- **GLM 5.1** dropped hard to Tier C (43). Its fluent DSL (`c.user()`, `c.assistant()`) really is invented — grep confirms. And every request reconstructs `ChatSession.new`, discarding history. Two compound bugs.

Lesson: file count and test count measure zero if the code is wrong underneath. But RubyLLM correct on its own also isn't enough. You need both.

## Tier A: what makes them work

To understand what separates Tier A from Tier B, look at what Opus 4.7, Kimi K2.6 and Gemini 3.1 Pro do that MiMo and DeepSeek V4 Pro don't.

**All Tier A models have these 4 things:**

1. **Tests that mock RubyLLM with the correct signature.** A `FakeChat` that implements `with_instructions`, `add_message`, `ask`. Tests that exercise happy path AND error path. WebMock blocking real calls to OpenRouter.
2. **Rescue around `chat.ask`** with typed error (`LlmClient::Error` or similar) and degraded UI for the user.
3. **Persistence that survives restart** and works multi-worker. Session cookie (Opus, K2.6) or Rails.cache with TTL (Gemini, GPT 5.4).
4. **System prompt via `with_instructions`.** The model knows its role.

Tier B usually fails 2-3 of these. MiMo fails all 4. DeepSeek V4 Pro has the cleanest RubyLLM code (persistent `@chat`) but doesn't deliver the artifacts. Sonnet 4.6 has ambitious architecture (multi-conversation sidebar) with a subtle control-flow bug that the tests rubber-stamp.

Tier C usually has at least one structural bug: invented fluent DSL, history discarded every request, `ruby_llm` gem in the `:test` group with `require: false`, or bypassing the gem entirely with raw `Net::HTTP`.

## Claude family: Opus 4.6 vs 4.7, Sonnet 4.6

Opus 4.7 leads at 94/100. Textbook-correct code:

```ruby
chat = @client.chat(model:, provider:)
chat.with_instructions(@system_prompt)
previous_messages.each { |msg| chat.add_message({role: msg.role.to_sym, content: msg.content}) }
response = chat.ask(user_message)
response.content
```

`FakeChat` with real signature. Tests verify history replay, error wrapping, model/provider override, system prompt. Session cookie with `to_a`/`from_session` is multi-worker safe. Rescue of `RubyLLM::Error + StandardError` → friendly error bubble.

Minor deduction: Dockerfile generated with `ARG RUBY_VERSION=4.0.2`, which is the Rails 8.1 generator's default and the current stable Ruby version. Gemini 3.1 Pro is the only model that replaced it with 3.4.1 (older), which the original audit had wrongly counted in Gemini's favor.

Opus 4.6 has correct code too (80/100 Tier A) but less disciplined. Controller without rescue around `chat_service.ask`: a transient 5xx becomes a stack trace page. Service reaches into `Chat#messages` via `attr_reader` directly, Demeter violation. Material difference between 4.6 (low Tier A) and 4.7 (high Tier A).

Sonnet 4.6 is Tier B (75). Richest UI of the whole benchmark (multi-conversation sidebar). But `LlmChatService#call` only calls `ask` if the last history message is from the user, otherwise it silently returns `""`. The tests rubber-stamp the bug. And the whole conversation fits in a 4KB cookie, which overflows after ~10 turns.

### The 4.7 behavior downgrade

The community complaint on [Reddit and DEV.to](https://dev.to/vibeagentmaking/why-we-switched-back-from-claude-opus-47-to-46-47f9) that "4.7 got worse for coding" isn't about code quality. On objective benchmark it's at the top. What 4.7 made worse is **behavior**:

- New tokenizer [consumes 1x to 1.35x more tokens](https://platform.claude.com/docs/en/about-claude/models/migration-guide) for the same text
- Tries to optimize resources (tokens, tool calls, steps) more aggressively, sometimes cutting corners
- [GitHub issues](https://github.com/anthropics/claude-code/issues/52368) report Max Plan running out in minutes where it used to last hours

I have hundreds of hours with 4.6 and have been testing 4.7 since launch. The code 4.7 produces is Tier A, equal to or better than 4.6. But in daily use, 4.6's more direct behavior is more productive. 4.6 is still my Claude Code default when Claude Code lets me pick (since 4.7 launched, [Claude Code changed the default to xHigh reasoning](https://code.claude.com/docs/en/model-config) and is more restrictive about downgrading to 4.6).

## GPT via Codex: 5.4 xHigh today, 5.5 incoming

GPT 5.4 xHigh via Codex CLI ties with Opus 4.7 at first (94/100). Uses `RubyLLM.chat(model:, provider: :openrouter, assume_model_exists: true)` + `with_instructions` + `add_message(role:, content:)` + `chat.ask` + `response.content`. Textbook, with provider pinning and registry-skip.

It's the only model with:

- **Explicit API-key preflight** (`ensure_api_key!` raises `MissingConfigurationError`)
- **Differentiated HTTP status codes**: 503 for config error, 502 for runtime error
- **Rails cache persistence with TTL + cap** (24 messages × 12h)
- **Dedicated form object** (`PromptSubmission`) separate from the domain model (`ChatMessage`)

10 test files including partial render tests. `FakeChat`/`FakeClient` match real API.

**Critical weakness**: 7.6M total tokens → ~$16/run. 15× Opus's cost for essentially tied quality. Hard to justify unless you can't iterate on the first try.

### GPT 5.5: arrived yesterday (April 23)

OpenAI [released GPT 5.5 yesterday](https://openai.com/index/introducing-gpt-5-5/), already [available in Codex](https://community.openai.com/t/gpt-5-5-is-here-available-in-codex-and-chatgpt-today/1379630). Not yet in the public API with API key, only with ChatGPT sign-in. [Simon Willison already started testing](https://simonwillison.net/2026/Apr/23/gpt-5-5/). I'll run the benchmark against GPT 5.5 via Codex this week. Update in a separate post.

## DeepSeek: the overhype pattern

Every DeepSeek generation ships with heavy marketing ("competitive with Claude Opus") and ends with the same pattern: **tool support lags behind**.

### V4 Pro: clean code, half-baked deliverables (66/100 Tier B)

The code DeepSeek V4 Pro writes for RubyLLM is Tier A quality:

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

But the run DNFs in opencode due to thinking-mode incompatibility. DeepSeek V4 Pro uses thinking mode by default and returns `reasoning_content` on every response. The DeepSeek API rejects subsequent turns unless the client echoes that `reasoning_content` back. Opencode doesn't. I tried `reasoning: false` in the config. It accepted, the run went much further (1972 files vs 1071), but still DNF on a later turn.

And the deliverables before the crash are weak: stock README template ("This README would normally document..."), **no `docker-compose.yml`** (explicit prompt requirement), missing bundle-audit. Score 66/100 Tier B.

This is the pattern that shows up every time DeepSeek ships: **tool support lags**. The community takes weeks to figure out integration, the thinking-mode protocol is more complex at runtime, and support in open-source tooling accumulates gaps the provider doesn't fix. If you need a production pipeline today that integrates DeepSeek, you'll probably have to maintain your own patches.

### V4 Flash: cheapest viable option (75/100 Tier B)

$0.01/run, 2m 35s, fixes V3.2's critical bug (invented `RubyLLM::Client` class). API all correct (now that I know `add_message(role:, content:)` is valid). Session-replay multi-turn via `session[:messages]`. WebMock tests the real OpenRouter endpoint — actually exercises the LLM path. All of this pushes it to 75/100 Tier B.

**Gotcha:** the model slug is `"claude-sonnet-4"` missing the `anthropic/` prefix. 404 at OpenRouter at runtime. One-character fix, but fatal if you deploy blind.

At Tier B, $0.01/run, V4 Flash is the cheapest model that gets close to "code that works with one manual patch".

### V4 vs V3.2: real generational upgrade

| | V4 Flash | V4 Pro | V3.2 (previous) |
|---|---|---|---|
| Score | 75 | 66 | 40 |
| Tier | B | B | C |
| Harness | completes | DNF (thinking mode) | completes |
| Time | 2m 35s | 22m (DNF) | 60m |
| Cost/run | ~$0.01 | ~$0.50 (partial) | ~$0.07 |
| RubyLLM API | correct | correct | invented `RubyLLM::Client` |
| Deliverables | mostly present | stock README + no compose | decent |

V4 is a real API-correctness upgrade over V3.2. V4 Flash is the cheap option that works. V4 Pro needs a thinking-mode-compatible harness (Codex, direct API).

## Kimi: K2.5 → K2.6

### K2.6 (84/100, Tier A)

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

### K2.5 (66/100 Tier B, not Tier 3 as I had claimed)

In the first version I cataloged K2.5 as Tier 3 for supposedly inventing `chat.complete` and using kwargs in `add_message`. Both are real public API. K2.5 comes back to Tier B.

It drops from K2.6 to K2.5 because: 37 tests (most in the benchmark) never mock RubyLLM. They only test PORO CRUD and `respond_to?`. Test coverage without mock fidelity measures nothing. And it uses class-var storage (`Chat.storage = @storage ||= {}`), worse than Singleton because there's no mutex.

K2.6 adds what K2.5 didn't have: `FakeChat` with the right signature, rescue, session cookie. Real evolution in the dimensions that matter.

## Xiaomi MiMo V2.5 Pro: looked like Tier 1, but the gaps are real

MiMo V2.5 Pro (April 2026) generated the most hype of this round. In the first analysis I promoted it as "first non-Anthropic Tier 1". After the new rubric, it drops to Tier B (64/100).

RubyLLM code is still clean:

```ruby
@llm_chat = RubyLLM::Chat.new(model: MODEL, provider: PROVIDER)
response = @llm_chat.ask(content, &)
@messages << { role: :assistant, content: response.content }
```

`Chat.new(model:, provider:)` is a valid public constructor. `.ask(content, &)` forwards a streaming block. Zero manual `add_message` calls. Multi-turn delegated to RubyLLM itself. **It's the cleanest pattern any model in this benchmark produced.**

But the holistic score = 64 because the other components have gaps:

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

Strong points: real Turbo Streams (not fetch + innerHTML), Rails.cache-backed persistence with 2h expiry, FakeChat mocks matching the real API, error path tested. The Dockerfile opts for Ruby 3.4.1 instead of the Rails 8.1 default 4.0.2. The first audit counted this as an advantage, but 4.0.2 is the current stable, so it's more neutral than win.

Critical weakness: it uses the model string `claude-3.7-sonnet` instead of the current Sonnet 4.x. One-character fix.

At $0.40/run, Gemini 3.1 Pro is the other cost-effective Tier A alongside Kimi K2.6.

## Qwen family: distillation doesn't save you

Tested several Qwens:

| Model | Type | Tier | Detail |
|---|---|:---:|---|
| Qwen 3.6 Plus | Cloud, OpenRouter | B (68) | Correct RubyLLM API; tests make real calls (no WebMock); client-side JS history |
| Qwen 3.5 35B | Local NVIDIA | C (52) | Correct entry point; no multi-turn; test wraps real call in `rescue => e; assert true` |
| Qwen 3.5 122B | Local NVIDIA | D (34) | Doesn't use ruby_llm; uses `Openrouter::Client` (wrong casing) |
| Qwen 3 Coder Next | Local NVIDIA | D (29) | Invents `RubyLLM::Client.new`; commits placeholder `.env` |
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

Qwen 3.6 Plus on OpenRouter completed the benchmark in 17 minutes and is the cleanest Qwen I've measured (68/100 Tier B). Correct RubyLLM API. Well-built Stimulus controller. But tests make real calls to OpenRouter (no WebMock), and history is client-side JS only (lost on refresh). Uses `fetch` + `innerHTML` instead of Turbo Streams.

## GLM family: 5, 5.1, local 4.7 Flash

### GLM 5 (61/100 Tier B)

`RubyLLM.chat(model: "anthropic/claude-sonnet-4")` + `chat.ask` + `response.content` correct. Mocha stubs match the real API. One happy-path test, no error-path coverage.

**Critical weakness**: zero multi-turn state. Every POST creates a fresh `RubyLLM.chat` without history. The "chat app" is a stateless echo service. "What did I just say?" → "I don't know."

### GLM 5.1 (43/100 Tier C, dropped)

This is the most painful fall from the re-audit. `RubyLLM.chat(model:, provider:)` is correct, but history is replayed via `c.user(msg)` / `c.assistant(msg)`, fluent DSL that **doesn't exist** in RubyLLM (confirmed via grep of the gem source).

Worse: every HTTP request constructs a new `ChatSession.new` that discards history. The two bugs mask each other: the invented DSL rarely fires because there's never any history to replay.

Stimulus controller uses `fetch` + manual `innerHTML`. SSE-based but not Turbo Streams.

Per Z.ai itself, [GLM 5.1 beats GPT 5.4 and Opus 4.6 on SWE-Bench Pro](https://openrouter.ai/z-ai/glm-5.1/benchmarks). In this specific benchmark (Rails + RubyLLM + complete deliverables), it drops to Tier C. More evidence that benchmarks are specific.

### GLM 4.7 Flash bf16 local (49/100 Tier C)

The local model that most dominates the RubyLLM API. Uses the fluent chain `.with_model().with_temperature().with_params().with_instructions().complete(&block)`, all real API per gem source.

**Fatal bug**: `gem "ruby_llm"` is in `group :development, :test` with `require: false`. Doesn't load in production. `NameError` at boot. Uses class-var `Message.all` (process-local).

## The losers (Tier C/D): MiniMax, Grok, Step, DeepSeek V3.2, GPT OSS

| Model | Score | Tier | Reason |
|---|---:|:---:|---|
| DeepSeek V3.2 | 40 | C | Invents `RubyLLM::Client.new` and `client.chat(messages: [...])`; tests mock a class that doesn't exist |
| Step 3.5 Flash | 53 | C | Bypasses `ruby_llm` entirely with `Net::HTTP`; not compliant with prompt |
| MiniMax M2.7 | 38 | D | Invents `RubyLLM.chat(model:, messages: [...])` batch signature; crashes on first call |
| Qwen 3.5 122B | 34 | D | Uses `Openrouter::Client` (wrong casing); calls `client.chat` on a method the gem doesn't expose |
| Qwen 3 Coder Next | 29 | D | Invents `RubyLLM::Client.new` + `client.chat(messages:)` + OpenAI-shaped response |
| Grok 4.20 | 22 | D | `ruby-openai` in `:development, :test` with `require: false` → NameError in production; uncompilable Stimulus JS |
| GPT OSS 20B | 8 | D | No tests folder; nested `app/app/`; invents `RubyLLM::Client.new` |

## Models that didn't complete the benchmark

The ranking above lists the 22 models that **completed** the benchmark enough to be audited. But the benchmark covers more than that. In total, 33 were configured, 27 ran, and only 16-22 (depending on the criterion) completed enough to become auditable code. The ones that failed deserve to be logged:

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

- **Tier A (80+)**: only **Kimi K2.6** (84). No other Chinese model.
- **Tier B (60-79)**: Kimi K2.5 (66), DeepSeek V4 Pro (66), DeepSeek V4 Flash (75), Xiaomi MiMo V2.5 Pro (64), Qwen 3.6 Plus (68), GLM 5 (61).
- **Tier C (40-59)**: Step 3.5 Flash (53), GLM 4.7 Flash local (49), GLM 5.1 (43), DeepSeek V3.2 (40).
- **Tier D (<40)**: MiniMax M2.7 (38), Qwen 3.5 122B local (34), Qwen 3 Coder Next local (29).

Out of 13 Chinese models tested (counting both local and cloud), **only one** reaches Tier A. That's the current penetration in this specific benchmark.

### The gap in points

**Kimi K2.6 vs Opus 4.7 (Tier A vs Tier A)**: 84 vs 94. 10-point gap. In practice, both deliver correct RubyLLM, real-signature FakeChat, error rescue, multi-worker-safe session cookie, complete Gemfile. What Opus 4.7 has extra are secondary dimensions that accumulate: tests that cover error wrapping, model/provider override and explicit system prompt application; redundant rescue in the controller beyond the service; slightly better concerns separation. Perceptible differences side by side, but not tier-separated.

Cost: K2.6 $0.30/run vs Opus 4.7 $1.10/run. **3.6× cheaper.** In continuous production runs, that difference accumulates.

**Chinese Tier B vs Claude Opus 4.6 (80 Tier A)**: 5 to 20-point gap. The Chinese Tier B models (MiMo, DeepSeek V4 Flash, Kimi K2.5, Qwen 3.6 Plus, GLM 5) have correct or near-correct RubyLLM code, but fail on specific components:

- **Test quality** is the universal weakest spot. Chinese Tier B models often write many tests (K2.5 wrote 37, the most in the benchmark) but don't mock RubyLLM. Coverage theater.
- **Persistence** frequently uses process-local Singleton (MiMo) or class-var (K2.5) instead of session cookie or Rails.cache. Dies on restart, not multi-worker safe.
- **Error handling** is usually absent. Rate limit becomes 500 with a stack trace visible to the user.

### Patterns by family

**Moonshot (Kimi)**: the most disciplined Chinese family. K2.5 at Tier B and K2.6 at Tier A. Real generational evolution in the dimensions that matter (tests, rescue, persistence). The only family that delivered Tier A.

**DeepSeek**: pattern of tool support lagging. Each generation has better RubyLLM code than the previous (V3.2 invented everything, V4 Flash writes correct, V4 Pro writes perfect), but integration in open tooling goes badly. V4 Pro DNFs in opencode due to thinking mode. The marketing is consistently stronger than the actual product in practical use.

**Xiaomi (MiMo)**: writes the most **idiomatic** RubyLLM code in the benchmark (persistent `@chat`, zero manual `add_message`). But forgets real tests, rescue, robust persistence. Lands at Tier B with prototype-demo quality, not production.

**Alibaba (Qwen)**: high variance. Qwen 3.6 Plus cloud reaches Tier B. Qwen 3.5 35B local at Tier C with patches. Qwen 3.5 122B and the "Coders" (Qwen 3 Coder Next, Qwen 2.5 Coder 32B) fall to Tier D for inventing API or hanging. "Coder" in the name isn't a guarantee for coding agent.

**Z.ai (GLM)**: GLM 5 at reasonable Tier B. GLM 5.1 **regressed** to Tier C, with invented fluent DSL plus history discard. Z.ai claims superiority in SWE-Bench Pro, but this specific benchmark caught two structural bugs. GLM 4.7 Flash local gets close but the gem in the `:test` group kills it in production.

**MiniMax** and **StepFun (Step)** don't deliver. MiniMax invented a batch signature that crashes on first call. Step bypasses the `ruby_llm` gem entirely with `Net::HTTP`, violating the prompt.

### Conclusion on the Chinese gap

For this specific benchmark (Rails + RubyLLM + complete deliverables):

- **One** Chinese model delivers Tier A as a drop-in Opus replacement: **Kimi K2.6**. 10-point gap vs Opus, 3.6× cheaper.
- **Five Chinese models** deliver Tier B usable with 1-2h of patching: K2.5, V4 Flash, V4 Pro, MiMo, Qwen 3.6 Plus, GLM 5.
- **The rest are not usable** in production for this kind of task.

The narrative of "China has already caught up with the West in coding LLMs" needs to be read with caveats. On synthetic reasoning benchmarks, maybe. On the benchmark of delivering a complete Rails app with every part functional? One model caught up. The others are still a generation behind.

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

**Tier A premium**: Claude Opus 4.7, GPT 5.4 xHigh (Codex), Claude Opus 4.6. Pick by behavior preference; code quality is there on all of them.

**Tier A cost-effective**: Kimi K2.6 ($0.30/run), Gemini 3.1 Pro ($0.40/run). 3-4× cheaper than Opus/GPT with comparable quality within this benchmark.

**Tolerable Tier B**: Claude Sonnet 4.6 ($0.63), DeepSeek V4 Flash ($0.01), Xiaomi MiMo V2.5 Pro ($0.14). Needs 1-2h of patching to ship to production.

**Cheapest useful**: DeepSeek V4 Flash ($0.01/run) with the `anthropic/` prefix fix on the model slug.

### Open source (local)

**No Tier A.** The best local that ran was **Qwen 3.5 35B-A3B** at Tier C (52/100), and it needs 1-2 correction prompts to deliver working code. For those with an RTX 5090 who want to escape vendor lock-in, that's the model to run, but with hobby/lab expectations, not production.

**Qwen 3.6 35B local** is the closest to working I've seen (1-line fix to add `.content`), but still without multi-turn.

**GLM 4.7 Flash local** is the most RubyLLM-literate local, but the gem in the wrong group kills the app in production. Trivial fix, structural impediment.

**In 2026, running open source locally for coding agent is viable with caution, on high-end hardware (RTX 5090 or Mac M4 Ultra), accepting 1-3 corrections per run.** It's not a substitute for Claude yet.

## Conclusion

Claude Opus 4.6 is still my daily pick for coding agent on real projects. Predictable behavior, defensive code, real mocks, sensible persistence, error handling.

Opus 4.7 leads the objective benchmark (94/100) but has a behavior downgrade (heavier tokenizer, aggressive resource optimization). On benchmark it delivers. In daily use I prefer 4.6.

GPT 5.4 xHigh via Codex ties at the top (94/100), but at 15× Opus's price for essentially tied quality, hard to justify for continuous use. GPT 5.5 landed [yesterday in Codex](https://community.openai.com/t/gpt-5-5-is-here-available-in-codex-and-chatgpt-today/1379630), I'll test this week.

The cost-effective sweet spot now is **Kimi K2.6 at $0.30/run** or **Gemini 3.1 Pro at $0.40/run**. Both Tier A. 3-4× cheaper than Opus.

Local open source hasn't reached Tier A yet. The best is Qwen 3.5 35B-A3B at Tier C with corrections. For experimentation, worth it. For production, not yet.

The biggest lesson from the re-audit is about process: **when you start classifying models based on "hallucinations" you think you found, go to the library source and check directly**. I was discarding models for valid API calls. Once I checked against the gem, Kimi, Gemini, DeepSeek V4 Flash and GPT 5.4 all improved. And once the criterion included deliverables (docker-compose, substantive README, bundle-audit), models that looked clean but delivered incomplete projects (DeepSeek V4 Pro, Step 3.5 Flash via bypass) fell to the tier that reflected that.

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
