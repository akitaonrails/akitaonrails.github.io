---
title: "LLM Benchmark: Sonnet 5 Fails, Gemini Flash Surprises, Sakana Fugu Almost Reaches Tier A"
slug: "llm-benchmark-sonnet-5-fails-gemini-flash-surprises-sakana-fugu-almost-tier-a"
date: '2026-07-01T15:00:00-03:00'
draft: false
translationKey: llm-benchmark-sonnet-5-gemini-3-5-flash-sakana-fugu-ultra
description: "In the coding benchmark, Sonnet 5 scored 58/100 after calling a nonexistent API, while Gemini 3.5 Flash scored 93/100. Sakana Fugu Ultra landed at 79/100, close to Tier A."
tags:
- llm-benchmarks
- llms
- coding-agents
---

Another round of my coding benchmark. And this time we got the kind of result that annoys marketing.

The three names are **Sonnet 5**, **Gemini 3.5 Flash**, and **Sakana Fugu Ultra**. Sonnet 5 is the one that draws attention. New model, strong brand, high expectations. Except expectations do not compile. It ran, passed Docker, came up under Compose, and still finished at **58/100, Tier C**. The first real chat request would crash before calling the model.

The good surprise came from the other side: **Gemini 3.5 Flash** scored **93/100, Tier A, #6**. A Flash model. Above Kimi K2.6, GLM 5.2, and Gemini 3.1 Pro.

And then there was **Sakana Fugu Ultra**, right on the edge: **79/100, Tier B**, knocking on Tier A's door. Qwen3.7 Max and Step 3.7 Flash also entered, but they are supporting cast. Nex matters, but I already unpacked that case in the post about the [Rio 3.5 controversy](/en/2026/06/15/the-rio-3-5-llm-controversy-plagiarism/). Here it stays mostly as a ranking line and reference.

Since the [last benchmark](/en/2026/06/14/llm-benchmark-kimi-v2-7-code-glm-5-2-minimax-m3-local/), my practical recommendation has not changed: serious programming, long sessions, real projects, today still means **Opus 4.8** or **GPT 5.5**, using Claude Code, Codex, or OpenCode. What changed is the middle of the table. And the middle is where you can see who is learning and who merely changed the version number.

## For anyone landing here cold

The test is simple to explain and annoying to run. I give every model the same prompt and ask it to build, by itself, a ChatGPT-style chat app in Rails 8 + RubyLLM + Hotwire + Docker, with tests and CI. Then I read the generated code by hand and score it from 0 to 100, in A/B/C/D tiers.

This is not multiple choice. Not a puzzle. Not "complete this function." It is an agent trying to deliver a whole small Rails project. It either delivers, or it trips.

The series so far:

1. [Canonical May benchmark (Part 3)](/en/2026/04/24/llm-benchmarks-part-3-deepseek-kimi-mimo/), with the complete methodology.
2. [DeepSeek unlocked with DeepClaude](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/).
3. [Grok 4.3, MiniMax M3, Opus 4.8 update](/en/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/).
4. [Fable 5 and Anthropic's saga](/en/2026/06/11/llm-benchmark-fable-5-and-the-anthropic-saga/).
5. [Kimi v2.7 code, GLM 5.2, MiniMax M3 local](/en/2026/06/14/llm-benchmark-kimi-v2-7-code-glm-5-2-minimax-m3-local/).

The trap is still the same: the "RubyLLM OK" column is not decoration. If the model invents an API that does not exist, the app dies in its main feature. Sometimes everything around it looks nice: Tailwind, Turbo, Docker, README, green tests. Then you click "Send" and get a `NoMethodError`.

## The closed-model soap opera

Anthropic had placed US government controls on **Claude Fable 5** and **Claude Mythos 5** on June 12. Reason: they could not verify nationality in real time across all global channels. On June 30, they suspended the Fable 5 controls, and Anthropic announced its gradual return to Claude Platform, Claude.ai, Claude Code, and Claude Cowork. Mythos 5 remains more restricted, only for approved US organizations through Project Glasswing.

Sources: [Anthropic's post about Fable 5 returning](https://www.anthropic.com/news/redeploying-fable-5), the [original Fable 5 and Mythos 5 post](https://www.anthropic.com/news/claude-fable-5-mythos-5), and [The Verge on the suspension of the controls](https://www.theverge.com/ai-artificial-intelligence/958964/anthropic-claude-fable-5-is-back).

On the OpenAI side, **GPT-5.6** has appeared officially, but it is still in limited preview. There is an OpenAI page and a help center article. It is not available enough for me to benchmark it the way I can benchmark GPT 5.5 today. So it gets a note, no number yet: [GPT-5.6 Sol preview](https://openai.com/index/previewing-gpt-5-6-sol/) and [GPT-5.6 Sol, Terra, and Luna help center article](https://help.openai.com/en/articles/20001325-a-preview-of-gpt-56-sol-terra-and-luna).

## Updated ranking

New models in this round are in bold. Nex-N2-Pro and the Qwen 3.5 397B base are still highlighted because they entered the table after the last benchmark, but the longer analysis already appeared in the [Rio 3.5 post](/en/2026/06/15/the-rio-3-5-llm-controversy-plagiarism/).

| Rank | Model | Score | Tier | RubyLLM OK | Runtime | Cost |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | 97 | A | ✅ | 22m | ~$16 |
| 3 | GPT 5.5 xHigh (Codex) | 96 | A | ✅ | 18m | ~$10 |
| 4 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$1.10 |
| 5 | Claude Fable 5 | 94 | A | ✅ | 24m | ~$11 (est.) |
| **6** | **Gemini 3.5 Flash** | **93** | **A** | ✅ | **18m** | **~$3.50** |
| 7 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$0.30 |
| 7 | GLM 5.2 (Z.ai) | 87 | A | ✅ | 43m | subscription |
| 9 | Kimi K2.7 Code | 86 | A | ✅ | 22m | ~$0.30 |
| 10 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 |
| **10** | **Nex-N2-Pro** | **83** | **A** | ✅ | **25m** | **free** |
| 12 | Gemini 3.1 Pro | 79 | B | ✅ | 14m | ~$0.40 |
| **12** | **Sakana Fugu Ultra** | **79** | **B** | ✅ | **22m** | **subscription** |
| 14 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 |
| 14 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 14 | MiniMax M3 | 78 | B | ✅ | 53m (phase 2 DNF) | ~$0.10 |
| **14** | **Qwen3.7 Max** | **78** | **B** | ✅ | **19m** | **~$1.40** |
| 18 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.74 |
| 19 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 |
| 20 | DeepSeek V4 Pro | 69 | B | ✅ | 22m (DNF) | ~$0.50 |
| 20 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0.10 |
| **20** | **Step 3.7 Flash** | **69** | **B** | ✅ | **27m** | **~$0.30** |
| 23 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.14 |
| 24 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 |
| **25** | **Claude Sonnet 5** | **58** | **C** | ❌ | **27m** | **~$0.80** |
| 26 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 |
| 27 | Qwen 3.5 35B (local) | 55 | C | ✅ | 28m | free |
| 28 | GLM 4.7 Flash bf16 (local) | 52 | C | ✅ | failed | free |
| 29 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 30 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 |
| **31** | **Qwen 3.5 397B A17B (base)** | **42** | **C** | ❌ | **15m** | **~$0.58** |
| 32 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 |
| 33 | Qwen 3.5 122B (local) | 37 | D | ❌ | 43m | free |
| 34 | Qwen 3 Coder Next (local) | 32 | D | ❌ | 17m | free |
| 35 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.60 |
| 36 | GPT OSS 20B (local) | 11 | D | ❌ | failed | free |

## Sonnet 5: passed Docker, failed at the heart

Sonnet 5 scored **58/100, Tier C, #25**. Here is the part that fools people: phase 2 passed. Local boot. Docker build. Docker Compose. The project had Rails 8, Turbo, Stimulus, Tailwind, README, CI, SimpleCov, Brakeman, RuboCop, and bundler-audit. The shell looked good.

The problem was exactly where it could not be: the LLM path.

The generated service does this:

```ruby
RubyLLM.chat(model: MODEL, provider: PROVIDER).tap do |chat|
  chat.messages = history
end
```

But RubyLLM 1.16 has `messages`, `add_message`, `ask`, and `with_instructions`. It does not have `messages=`. The first real chat request raises `NoMethodError` before reaching the model. The test misses it because the project's own `FakeChat` defines `attr_accessor :messages`, exactly the writer that does not exist in production.

This is the kind of bug that keeps me reading benchmark outputs by hand. Green build does not prove correct integration. Green test can be worse than useless when the fake teaches the test a lie.

There is more: the generated app still defaulted to `anthropic/claude-sonnet-4.6`, not Sonnet 5, and left the system prompt without `with_instructions`. The shell was complete. The main feature was broken.

Cruel summary: **Sonnet 5 passed Docker and failed at the heart**. If you pay Anthropic for programming today, I still recommend Opus 4.8. Not Sonnet 5.

## Gemini 3.5 Flash: the good surprise

Gemini 3.5 Flash was the slap in the face of the round: **93/100, Tier A, #6**. Best non-Anthropic/non-OpenAI result in the benchmark so far. Fourteen points above Gemini 3.1 Pro.

The RubyLLM integration was exemplary:

```ruby
chat = RubyLLM.chat(model: @model, provider: :openrouter, assume_model_exists: true)
chat.with_instructions(SYSTEM_INSTRUCTION)
@conversation.messages.each { |msg| chat.add_message(role: msg.role.to_sym, content: msg.content) }
response = chat.complete
@conversation.add_message(role: :assistant, content: response.content)
```

It used `with_instructions`, history replay with `add_message`, `complete`, and `response.content`. All real. The test suite was the best in this cohort: `FakeChat` with a compatible signature, stub at the correct point (`RubyLLM.chat`), parameter assertions, history replay, and an error test. Sounds basic. It is not. The table proves it is not.

I also liked the persistence. It writes files under `tmp/chats/<id>.json`, with a 50-message cap and the system message preserved. It survives restart on the same host and is better than an in-memory singleton. It lacks file locking, `tmp/` is ephemeral in containers, and concurrent writes to the same conversation can race. It also lacks a nice API-key preflight. All fixable.

The cost bothers me. Even as Flash, the run came out around **US$3.50**, more expensive than Opus 4.8 in this benchmark because of high token churn. So I cannot sell it as "cheap." But as a quality signal it is strong. A Flash model at #6 changes my intuition about Gemini.

## Sakana Fugu Ultra: almost Tier A, missing memory

**Sakana Fugu Ultra** entered with **79/100, Tier B, tied at #12**. For a new provider, this was a clean debut. The harness worked. The app came up. Docker/Compose passed. RubyLLM was real (`chat`, `with_instructions`, `ask`, `response.content`). The tests used a correct `FakeChat`. Turbo/Stimulus were good.

The problem is small to explain and large in consequence: the model only sees the latest message. The history is saved and displayed, but it is not replayed into RubyLLM. The UI looks like a multi-turn chat. The LLM works as if every message were the first.

It missed exactly the part that makes chat chat.

Even so, this is the kind of result I like to see. It is not a disaster. It is not an invented API. It is an almost-correct app with a specific failure. Replacing the process-local repository with something decent and replaying history with `add_message` would change the evaluation a lot.

## Qwen3.7, Step 3.7, and the Qwen 3.6 footnote

**Qwen3.7 Max** scored **78/100, Tier B, tied at #14**. Correct RubyLLM API, including streaming and `reset_messages!`. Phase 2 passed. But it ignored Turbo Streams and implemented raw SSE with `ActionController::Live`. In a real app, maybe fine. In this benchmark, the prompt asked for Hotwire/Turbo Streams. It also used `anthropic/claude-sonnet-4` instead of the newest Sonnet and stored conversations in an unbounded class-level hash. Restart the process? Lose everything. Run long enough? Leak memory.

**Step 3.7 Flash** scored **69/100, Tier B, tied at #20**. It fixed the big Step 3.5 mistake: now it uses the real `ruby_llm` gem, not a `ruby-openai` bypass. Good. But it creates a new `RubyLLM.chat` per request and sends only the current message. The history lives in a `@@all` class var, but never reaches the model. It escaped the wrong bypass and forgot to give the LLM memory.

And yes, Qwen 3.6 appeared in the recent commit history. Two local **Qwen 3.6 35B A3B** runs entered through PR #9 (`cccc118` and `f06ddd0`), using a local `ik_llama.cpp` profile, but the merge was reverted in `d5f9195`. That is why they are not in the main table for this round.

The useful Qwen 3.6 local data remains in the separate RTX 5090 report: it was the first local model in that profile to get `RubyLLM.chat` + `chat.ask` right, but it still returned the whole object instead of `response.content` and had no multi-turn. Close to working. Still outside the main cloud/AMD ranking.

## Nex and Qwen base: already covered in the Rio 3.5 case

**Nex-N2-Pro** scored **83/100, Tier A, #10**, using OpenRouter's free endpoint. The raw **Qwen 3.5 397B A17B** base scored **42/100, Tier C, #31**. That 41-point gap matters. Repeating everything here would be padding.

I already used those numbers in the post about the [Rio 3.5 LLM controversy](/en/2026/06/15/the-rio-3-5-llm-controversy-plagiarism/), because the public accusation was precisely that Rio's checkpoint looked like a merge of Nex-N2-Pro and Qwen3.5-397B-A17B. That post explains what Nex is, why the fine-tune matters, and why a Rio model inheriting Nex's gains should not be sold as an obvious advance over pure Nex without a reproducible benchmark.

The short technical version: the Qwen base invented RubyLLM (`chat.system`, `chat.user`, `response.text`) and the tests mocked that fake API. Nex used the real API, booted locally, passed Docker/Compose, and delivered Turbo Streams with error handling. It still has shortcuts, like flattening history into text instead of using `add_message` and `with_instructions`, but it is a legitimate Tier A result. It is just not the focus of this post.

## My actual workflow today

In practice, I have been using a lot of **OpenCode + [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) + GPT 5.5** to maintain my open source projects. It is a slim, cleaner, cheaper-token fork of oh-my-opencode. Exactly the kind of adjustment that fits daily use. I already explained the rest of my [AI toolkit with ai-jail, ai-memory, and ai-usagebar](/en/2026/05/24/akita-ai-toolkit-ai-jail-ai-memory-ai-usagebar/) in a separate post.

This is annoying to explain to people who only want to know "which model is best." Model alone does not carry the work. Harness matters. System prompt matters. Project memory matters. Test quality matters. The same model, in a bad harness, becomes a random patch generator.

I have been using this on small, real things, like Geary extensions: [geary-email-autocomplete](https://github.com/akitaonrails/geary-email-autocomplete) and [geary-hide-sidebar-module](https://github.com/akitaonrails/geary-hide-sidebar-module). None of this is a revolution. It is maintenance, bugfixes, refactors, tests, documentation. Normal work. Exactly where a coding agent needs to be reliable for hours, not for a 90-second demo.

That is why I keep repeating: model benchmarks are useful, workflow benchmarks are even more useful. Sonnet 5 with a hallucinated API does not help me. Gemini Flash surprising me with correct RubyLLM does. Sakana and Step getting the gem right but forgetting multi-turn show exactly where these models still break in a real product.

## Conclusion

This round left a simple message: a strong name does not save a broken integration. Sonnet 5 entered with the aura of a new model and left in Tier C because it called an API that does not exist.

Gemini 3.5 Flash deserves attention. Not because it is cheap; in this run it was not even that cheap. It deserves attention because it delivered a Rails/RubyLLM app far more correctly than I expected from a Flash model.

On the open source / alternative provider side, the story is more mixed. Sakana Fugu Ultra almost reached Tier A. Qwen3.7 Max got the API right and missed the product. Step 3.7 Flash fixed the 3.5 bypass and forgot to give the chat memory. There is progress. There are edges.

My practical recommendation stays the same: **Opus 4.8 or GPT 5.5** for serious programming today. Use Tier B for small, cheap, reviewed tasks. Use open source/local to study and experiment. And do not trust a green test if the fake does not imitate the real library.

The benchmark is open: [github.com/akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). Want to see another model there? Fork it, add it to `config/models.json`, run it, and send the PR.
