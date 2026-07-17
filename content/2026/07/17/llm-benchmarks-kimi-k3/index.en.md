---
title: "LLM Benchmarks: Kimi K3"
slug: "llm-benchmarks-kimi-k3"
date: '2026-07-17T12:00:00-03:00'
draft: false
translationKey: llm-benchmarks-kimi-k3
tags:
  - llm
  - benchmark
  - kimi
  - moonshot
  - claude
  - glm
  - pricing
  - ai
  - vibecoding
---

I am always testing new LLMs. It is the only way to separate a release note from code that actually goes up. In the two most recent posts, [Grok 4.5 and GPT 5.6 Sol](/en/2026/07/09/llm-benchmark-grok-4-5-gpt-5-6-sol/) and [Sonnet 5, Gemini 3.5 Flash and Sakana](/en/2026/07/01/llm-benchmark-sonnet-5-fails-gemini-flash-surprises-sakana-fugu-almost-tier-a/), the table moved around quite a bit. Now it is Moonshot's turn.

The focus is **Kimi K3**, an alternative that is becoming more and more like Claude in the kind of work it can finish. And a silly but important detail when looking for documentation: its official name is **Kimi K3**, not “Kimi v3”.

## For those who just landed here

The benchmark gives every model the same prompt: build, on its own, a ChatGPT-like chat app in Rails 8, RubyLLM, Hotwire, Docker, with tests and CI. Then I inspect the project it produced, including the gem's real API, conversation memory, error handling, tests, and production image. The score goes from 0 to 100, in A/B/C/D tiers.

This is not a fill-in-the-function benchmark. It is an agent delivering a small app, with the boring parts that usually break after the demo. The methodology is in [Part 3](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/); code, logs, and the rubric are in the [benchmark repository](https://github.com/akitaonrails/llm-coding-benchmark).

## First, the harness problem

Previous Kimi rounds used OpenCode through OpenRouter. K3 did not get through the door: Moonshot's strict tool-schema validator rejected the schema OpenCode sends:

```
when using anyOf, type should be defined in anyOf items instead of the parent schema
```

A controlled probe with a clean schema got tool calling to work. The problem is in the **OpenCode ↔ Moonshot** pairing. K2.5, K2.6, and K2.7 worked with the same tooling. Be careful with headlines saying “the model does not support tools”: sometimes the bug is in the fit.

So as not to abandon the test, a first-class runner for Kimi Code CLI was added. Phase 1 calls:

```bash
kimi -p <prompt> --output-format stream-json -m <model>
```

and phase 2 resumes the session with `-S <session_id>`. The runner code and configuration are in [commit 0cdf88a](https://github.com/akitaonrails/llm-coding-benchmark/commit/0cdf88a). The original error and investigation were recorded in commits [c3ab6d5](https://github.com/akitaonrails/llm-coding-benchmark/commit/c3ab6d5) and [506357b](https://github.com/akitaonrails/llm-coding-benchmark/commit/506357b); the final K3 project landed in [2bf1d7b](https://github.com/akitaonrails/llm-coding-benchmark/commit/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615).

This also puts an honest asterisk on the score. I wanted to compare the whole family under the new harness. The Kimi subscription exposes K3 and managed **K2.7-Coding**, but not K2.5/K2.6. We reran K2.7 through the CLI and compared it with the existing K2.5/K2.6/OpenRouter artifacts. K2.7 CLI came in at an informal **68/B**; K2.7 OpenCode/OpenRouter had scored **86/A**. This is harness and snapshot sensitivity, not a clean causal claim that “the harness costs 18 points”: managed `kimi-for-coding` may not be the same public K2.7 snapshot.

## Current ranking: 40 models

K2.7 CLI is informal and unranked, so it is not included. The cost column is the actual cost at the round's provider/OpenRouter or a subscription estimate, not an abstract rate card.

| Rank | Model | Score | Tier | RubyLLM OK | Runtime | Cost |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$7.00 |
| 2 | GPT 5.4 xHigh (Codex) | 95 | A | ✅ | 22m | ~$16 |
| 2 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$6.40 |
| 4 | Claude Fable 5 | 94 | A | ✅ | 24m | ~$11.20 |
| 5 | Claude Fable 5 (re-release) | 93 | A | ✅ | 18m | ~$8.30 |
| 5 | Gemini 3.5 Flash | 93 | A | ✅ | 18m | ~$3.55 |
| 7 | GPT 5.6 Sol xHigh (Codex) | 92 | A | ✅ | 17m | credits (≈$8.70 API-equiv.) |
| **8** | **Kimi K3 (Kimi Code CLI)** | **89** | **A** | ✅ | **26m** | **credits (≈$2.10 API-equiv.)** |
| **9** | **Kimi K2.6** | **87** | **A** | ✅ | **20m** | **~$1.19** |
| 9 | GLM 5.2 (Z.ai) | 87 | A | ✅ | 43m | subscription |
| 9 | Grok 4.5 | 87 | A | ✅ | 16m | ~$5.10 |
| **12** | **Kimi K2.7 Code** | **86** | **A** | ✅ | **22m** | **~$1.23** |
| 13 | GPT 5.5 xHigh (Codex) | 85 | A | ✅ | 18m | ~$10 |
| 14 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 (hist.) |
| 14 | Nex-N2-Pro | 83 | A | ✅ | 25m | ~$0.34 (was free) |
| 16 | Gemini 3.1 Pro | 79 | B | ✅ | 14m | ~$3.10 |
| 16 | Sakana Fugu Ultra | 79 | B | ✅ | 22m | subscription |
| 18 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 (hist.) |
| 18 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 18 | MiniMax M3 | 78 | B | ✅ | 53m (phase 2 DNF) | ~$1.25 |
| 18 | Qwen3.7 Max | 78 | B | ✅ | 19m | ~$1.40 |
| 22 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.70 |
| 23 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 (hist.) |
| 24 | DeepSeek V4 Pro | 69 | B | ✅ | 22m (DNF) | ~$0.05 |
| **24** | **Kimi K2.5** | **69** | **B** | ✅ | **29m** | **~$0.10 (hist.)** |
| 24 | Step 3.7 Flash | 69 | B | ✅ | 27m | ~$0.80 |
| 27 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.09 |
| 28 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 (hist.) |
| 29 | Claude Sonnet 5 | 58 | C | ❌ | 27m | ~$2.25 |
| 30 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 (hist.) |
| 31 | Qwen 3.5 35B | 55 | C | ✅ | 28m | free |
| 32 | GLM 4.7 Flash bf16 | 52 | C | ✅ | failed | free |
| 33 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 34 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 (hist.) |
| 35 | Qwen 3.5 397B A17B (base) | 42 | C | ❌ | 15m | ~$0.31 |
| 36 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 (hist.) |
| 37 | Qwen 3.5 122B | 37 | D | ❌ | 43m | free |
| 38 | Qwen 3 Coder Next | 32 | D | ❌ | 17m | free |
| 39 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.70 |
| 40 | GPT OSS 20B | 11 | D | ❌ | failed | free |

## Kimi evolved quickly. Its price even more so.

K2.5 scored **69/B** in February. K2.6 jumped to **87/A** in April. K2.7 stayed at **86/A** in June. Now K3 reaches **89/A** in July. There was a big jump with K2.6, a plateau in K2.7, and K3 pushes the ceiling a bit higher.

From the official spec sheet, only what matters here: K3 has 1M context, MoE architecture (mixture of experts, which activates only parts of the model for each token), and maximum reasoning mode. Useful for understanding the product's ambition. It does not replace opening the project it wrote.

## What K3 actually wrote

There is quite a lot right in the [`Conversation` model](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/kimi_k3_cli/project/app/models/conversation.rb#L31-L52). It builds the chat, replays only the prior history, and then calls `ask(content)`; the current message enters the collection only after the response. No double-send. If the provider fails, the exception is raised before `append`, so a failed turn is not stored:

```ruby
response = build_llm_chat.ask(content)
append(Message.new(role: "user", content: content))
append(Message.new(role: "assistant", content: response.content.to_s))
```

It also got persistence better than the global-hash pattern: [Rails.cache with a one-day TTL](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/kimi_k3_cli/project/app/controllers/concerns/conversation_store.rb#L12-L18), a key per session, and a [20-message limit](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/kimi_k3_cli/project/app/models/conversation.rb#L6-L8). Docker is production-grade, non-root, and validation performed a real chat both locally and in the container. That is real Tier A, not an optimistic README.

But you can still see the signature of a generation. It does not use `with_instructions`, so there is no system prompt. The LLM call lives inside the domain model. There is no preflight for a missing key.

Each individual message can grow without a ceiling and there is no rate limit. The production cache remains the ephemeral default. The `read` + mutation + `write` sequence races between requests. Raw provider errors appear in the UI. The error suite is smaller than it should be.

Against **Opus 4.6**, K3 clearly wins in this artifact: correct public RubyLLM API, bounded state, and tests for provider failures. [Opus 4.6 manipulates `chat.messages` directly](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/claude_opus_4_6/project/app/controllers/chats_controller.rb#L41-L56), stores an uncapped cookie, and does not cover provider errors.

[Opus 4.8 models preconditions, the system prompt, and replay better](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/claude_opus_4_8/project/app/services/chat_service.rb#L21-L51). The basic RubyLLM call is comparable. The distance appears in hardening, architecture, and test depth.

| Artifact | Score | What it delivered | Where it fell short |
|---|---:|---|---|
| Kimi K3 | 89 | Correct replay, cap, cache with TTL, tested error | No system prompt, ephemeral cache, race, and raw error |
| Claude Opus 4.6 | 83 | Working RubyLLM, production Docker | Fragile replay, uncapped cookie, almost no error tests |
| Claude Opus 4.8 | 95 | Disciplined service, invariants, and 34 tests | Cookie still uncapped, missing key preflight |
| Claude Fable 5 | 94/93 | Preflight, input limits, defensive tests | Persistence trade-offs and high price |

**Fable 5** is more defensive, but charges for it: original/re-release 94/93, against 89; $10/$50 per million, against $3/$15; measured runs of ~$11.20/~$8.30, against ~$2.10 API-equivalent. One run per cell does not provide statistical certainty. It provides concrete code to compare.

## Pricing: Kimi is no longer the absurd bargain

It is important here to separate Moonshot direct API, OpenRouter, and subscription. This is the official direct API rate card, per million tokens, with cached input separated:

| Model | Cached input | Input | Output |
|---|---:|---:|---:|
| K2.5 | $0.10 | $0.60 | $3 |
| K2.6 | $0.16 | $0.95 | $4 |
| K2.7 | $0.19 | $0.95 | $4 |
| K3 | $0.30 | $3 | $15 |

Official documentation: [K2.5](https://platform.kimi.ai/docs/pricing/chat-k25), [K2.6](https://platform.kimi.ai/docs/pricing/chat-k26), [K2.7 Code](https://platform.kimi.ai/docs/pricing/chat-k27-code), and [K3](https://platform.kimi.ai/docs/pricing/chat-k3). For intermediary pricing and availability, also see the [K3 page on OpenRouter](https://openrouter.ai/moonshotai/kimi-k3).

K3 costs **3.16× more for input** and **3.75× more for output** than K2.6/2.7. Moonshot left the ultra-cheap niche. The costs in the ranking table are something else: K2.6 ~$1.19 and K2.7 ~$1.23 were recomputed from the provider/OpenRouter and the run tokens; K3 is an API-equivalent estimate of ~$2.10 for a subscription-billed run. Mixing the two without identifying the channel creates a false comparison.

Even so, K3 costs 40% less than Opus 4.8 at official rates ($5/$25) and 70% less than Fable ($10/$50). On the **$19 Kimi Moderato plan**, this is excellent for interactive solo coding. Just do not automate recklessly: we observed around two heavy rounds per five-hour window and quota recovery in 4h16. For unsupervised batch work, a mid-run 403 throws away work and time.

My practical take: K2.6 remains the best raw-API option for high-volume automation with human review. K3 is a very good option for those coding interactively. Opus 4.8 remains my choice for complex refactors, concurrency, security, and autonomous changes where correctness matters more than the bill. Fable, in this slice, is economically dominated.

## Bonus: GLM 5.2 versus Opus

GLM 5.2 is at **#9, 87/A, 43 minutes**, through a Z.ai subscription. The natural comparison is Opus 4.6, its score neighbor at 83/A and 16 minutes, and Opus 4.8, the quality ceiling at 95/A and 17 minutes.

I read both projects. GLM beats the Opus 4.6 artifact: it uses RubyLLM correctly, applies a system prompt, separates the service, accepts DI, and tests failures. The [service](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/glm_5_2/project/app/services/chat_service.rb#L28-L55) even excludes the last message from replay before calling `ask`, the detail that avoids double-send.

But GLM also leaves skeletons in the closet: uncapped process-local singleton; failed turns are retained; `config.hosts.clear`; generated secret that invalidates sessions; and `npm ci || npm install`, which turns the lockfile into a suggestion. It remains clearly behind Opus 4.8 in state, design, tests, and configuration hardening.

Z.ai plans are Lite $18, Pro $72, and Max $160, with a promotion through September 2026: $12.60/$50.40/$112. Against Opus 4.8 at ~$6.40 per run, nominal break-even is approximately **3/12/25** runs per month, or **2/8/18** at the promotional price. But GLM takes 43 minutes where Opus 4.8 took 17. If you already pay for Z.ai, GLM 5.2 is a strong default for routine reviewed work. If correctness and turnaround rule, Opus 4.8.

## Conclusion

In this greenfield Rails project, K3 is a good replacement for Opus 4.6 and offers a cheaper alternative to Opus 4.8. Claude still has the edge when the project demands defenses against details nobody puts in the prompt.

There is one run per model and there is harness effect, especially with K3. The benchmark also does not cover database migrations, background jobs, or product tool calls. There is no data here to make promises about those.

My map today: K2.6 for reviewed-volume API automation; K3/Moderato for interactive solo work; Opus 4.8 when the patch is sensitive; GLM 5.2 as a good subscription default for routine reviewed work. No hype. Read the code, run the tests, and treat every ranking as limited evidence, not religion.
