---
title: "LLM Benchmarks - An Update on Grok 4.3, MiniMax v3, and Opus 4.8"
slug: "llm-benchmarks-grok-4-3-minimax-m3-opus-4-8"
date: '2026-06-01T13:00:00-03:00'
draft: false
translationKey: llm-benchmarks-grok-minimax-opus-update
tags:
  - llm
  - benchmark
  - claude
  - grok
  - minimax
  - ai
  - vibecoding
---

This one's a routine update, sitting on top of the [canonical May benchmark (Part 3)](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) and the [DeepSeek-unlocked-with-DeepClaude post](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/). Three new models landed in the test since then, and I'm logging them here just for completeness: Opus 4.8, Grok 4.3, and MiniMax M3 (MiniMax's v3). Spoiler: none of it moves the main conclusion. But data is data, and I like to keep the ranking honest and current.

**TL;DR:**

- **Opus 4.8** doesn't feel much different from Opus 4.7, not in daily use and not in the benchmark. 95/100 against 97/100, inside the noise. It's the fastest Opus I've measured, but the day-to-day experience is the same.
- **Grok 4.3**, anecdotally, struck me as a bit more literal and strict about following the prompt. In the benchmark it improved substantially over the previous generation (Grok 4.20). It still doesn't come close to Opus or GPT, but at least now it starts to be usable. 72/100, Tier B.
- **MiniMax M3**, same story. The previous version (M2.7) was unusable, and the new one is finally at least usable. 78/100, Tier B.
- All three land roughly in the band of a Sonnet 4.6 or a DeepSeek V4. One or two generations behind the new Opus and GPT.

## Recap

For anyone just tuning in: this benchmark hands each model the same prompt and asks it to build, on its own, a ChatGPT-style chat app in Rails 8 + RubyLLM + Hotwire + Tailwind + Docker, with Minitest tests and CI tooling. The score comes out of an 8-dimension rubric, 0 to 100, sorted into A/B/C/D tiers. The full methodology and the 20+ earlier models are in the series:

1. [Testing Open Source and Commercial LLMs - Can Anyone Beat Claude Opus?](/en/2026/04/05/testing-llms-open-source-and-commercial-can-anyone-beat-claude-opus/) (April 5). The first cut and the base task.
2. [LLM Benchmarks Part 2: Is It Worth Combining Multiple Models in the Same Project?](/en/2026/04/18/llm-benchmarks-part-2-multi-model/) (April 18). First stab at planner + subagents orchestration.
3. [LLM Coding Benchmark (May 2026): DeepSeek v4, Kimi v2.6, Grok 4.3, GPT 5.5](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) (April 24). The canonical version with the standardized rubric. It's the current ranking reference.
4. [LLM Benchmarks: Is It Worth ($$) Mixing 2 Models?](/en/2026/04/25/llm-benchmarks-vale-a-pena-misturar-2-modelos/) (April 25). Three rounds of multi-model orchestration.
5. [LLM Benchmarks: DeepSeek Unlocked! Use DeepClaude](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/) (May 4). DeepSeek V4 Pro climbing out of limbo via a harness swap.

Usual disclaimer: everything here holds inside this benchmark's specific methodology, which is delivering a complete Rails + RubyLLM app from a fixed prompt. A model that drops to Tier B here might shine on a different kind of task (short snippet, isolated function, math reasoning). Nobody should read this as a universal judgment of capability.

## Updated ranking

The three new ones are in bold. The rest matches the canonical ranking:

| Rank | Model | Score | Tier | RubyLLM OK | Time | Cost |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | 97 | A | ✅ | 22m | ~$16 |
| 3 | GPT 5.5 xHigh (Codex) | 96 | A | ✅ | 18m | ~$10 |
| **4** | **Claude Opus 4.8** | **95** | **A** | ✅ | **17m** | **~$1.10** |
| 5 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$0.30 |
| 6 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 |
| 7 | Gemini 3.1 Pro | 82 | A | ✅ | 14m | ~$0.40 |
| 8 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 |
| 8 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| **8** | **MiniMax M3** | **78** | **B** | ✅ | **53m (phase 2 DNF)** | **~$0.10** |
| **11** | **Grok 4.3** | **72** | **B** | ✅ | **15m** | **~$1.74** |
| 12 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 |
| 13 | DeepSeek V4 Pro \* | 69 | B | ✅ | 22m (DNF) | ~$0.50 |
| 13 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0.10 |
| 15 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.14 |
| 16 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 |
| 17 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 |
| 18 | Qwen 3.5 35B (local) | 55 | C | ✅ | 28m | free |
| 19 | GLM 4.7 Flash bf16 (local) | 52 | C | ✅ | failed | free |
| 20 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 21 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 |
| 22 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 |
| 23 | Qwen 3.5 122B (local) | 37 | D | ❌ | 43m | free |
| 24 | Qwen 3 Coder Next (local) | 32 | D | ❌ | 17m | free |
| 25 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.60 |
| 26 | GPT OSS 20B (local) | 11 | D | ❌ | failed | free |

\* DeepSeek V4 Pro only reaches Tier A (89/100) via DeepClaude (Claude Code with env-vars pointed at OpenRouter). In opencode, the benchmark's default harness, it hits the `reasoning_content` bug and stalls at 69 (DNF). The full story is in the [dedicated post](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/).

## How the three did

### Opus 4.8: the fastest Opus, same quality

Opus 4.8 lands in Tier A with 95/100, two points under 4.7 (97), measurement noise. It keeps the exact RubyLLM path that puts the Claude family on top: `RubyLLM.chat(model:, provider: :openrouter, assume_model_exists: true)` + `with_instructions` + `add_message` + `ask` + `response.content`. It bumps to Ruby 4.0.3, writes 34 tests with a correctly-signed `FakeChat`, and the benchmark's phase 2 validated the whole loop: local boot, a real POST to OpenRouter, the Docker build, and the compose healthcheck. It was the most end-to-end-validated Opus run I've done.

The deductions are small: an unbounded session-cookie history (blows up on a long conversation) and no preflight checking the API key before initializing RubyLLM. Nothing that knocks it out of Tier A.

The efficiency numbers are the highlight: 104K tokens, 17 minutes, and the highest tokens-per-second of any Opus in the benchmark. It's clearly faster. But in my daily use, sitting in Claude Code, I don't feel any behavioral difference from 4.7. Same code quality, same way of working. Anyone who read [Part 3](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) knows 4.7's code quality was always Tier A; my gripe was with the more token-thrifty behavior, which sometimes skips a step. 4.8 leaves both exactly where they were.

### Grok 4.3: a 47-point jump over 4.20, with the UI half-dead

Grok 4.3 scores 72/100 Tier B against Grok 4.20's 25/100 Tier D. That's a 47-point jump, the biggest intra-family leap in the whole benchmark. And the reason is straightforward: the RubyLLM API now comes out correct on every call (`RubyLLM::Chat.new` + `add_message` + `ask` + `response.content` + a rescue of `RubyLLM::Error`, all verified against the gem's source). 4.20 invented API and broke in production; 4.3 writes the cleanest controller in the benchmark, with real server-side Turbo Streams, a real README, and a real `compose.yaml`.

The thing that holds it in Tier B is embarrassing to describe: **Stimulus is dead at runtime**. The `application.js` is a one-line comment, no `import "./controllers"`, no `Application.start()`. The result: every `data-controller="chat"` sits inert. Enter-to-send, autoresize, autoscroll, clear-input, half the UI silently broken. Add to that tests that stub `RubyLLM.stub :chat` while the controller calls `RubyLLM::Chat.new` (the stub gets bypassed) and a stale model pin (`claude-3.7-sonnet`). The backend is solid, the frontend layer never lights up.

Cost: $1.74 in 15 minutes. That's ~5× the price of Kimi K2.6, which delivers Tier A (87/100) for $0.30. Anecdotally, in use outside the benchmark, Grok 4.3 came across as a bit stricter and more literal about following prompt instructions, which can cut either way depending on how precise you are with the ask.

### MiniMax M3: from unusable to usable

MiniMax M3 climbs to 78/100 Tier B, against M2.7's 41/100 Tier C. M2.7 hallucinated a batch signature (`RubyLLM.chat(model:, messages: [...])`) that crashed on the first call, literally unusable. M3 fixes that and uses the real API (`RubyLLM.chat` + `with_instructions` + `add_message` + `ask` + `response.content`). It ships a 19-test suite, a session message cap, Turbo Streams, and service-layer separation. Decent code.

Two things keep it out of Tier A. Phase 2 stalled during compose validation (it never finished), and the model wrote a real `.env` with the `OPENROUTER_API_KEY` into the generated project. I deleted the file and redacted the key from every artifact, but it's a serious prompt violation (the prompt explicitly asks for "no secrets in a file"), and secret hygiene weighed on the score. At $0.10 a run, it's cheap. But cheap with a leaked key and incomplete validation is exactly the kind of thing that costs you later.

## How big the gap to the top of Tier A is

Worth putting the three against the top to size up the distance. The top of Tier A right now is Opus 4.7 (97), GPT 5.4 (97), GPT 5.5 (96), and Opus 4.8 (95). Just below, still in Tier A, come Kimi K2.6 (87), Opus 4.6 (83), and Gemini 3.1 Pro (82).

Grok 4.3 (72) and MiniMax M3 (78) sit 20 to 25 points under the leaders. That's what "one or two generations behind" looks like in practice. And the difference isn't in RubyLLM API correctness anymore, all three get that right now. It's in completeness. The Tier A models at the top deliver four things together: tests that mock RubyLLM with a correct signature, a rescue around `chat.ask` with a degraded UI, persistence that survives a restart and runs multi-worker, and a system prompt via `with_instructions`. On top of all that, a frontend layer that actually works. Grok delivers a clean backend with a dead frontend. MiniMax delivers solid code but doesn't finish validation and leaks a key on the way out.

The cost angle closes the argument. The "cheap Tier A" slot is already taken: Kimi K2.6 delivers Tier A at $0.30, Gemini 3.1 Pro at $0.40, DeepSeek V4 Flash reaches 78 (the same Tier B as MiniMax) for a penny. Grok 4.3 asks $1.74 to deliver less than Kimi at 5× the price. MiniMax is dirt cheap, but it's still Tier B with loose ends. Neither one opens a new price/quality band that wasn't already covered.

## Conclusion

If you want to dig deeper, the benchmark is open source: [github.com/akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). If you want to know about some less popular LLM I have no interest in covering, fork it, add an entry to `config/models.json`, run it, and send the PR. The audit scanner and the skill ship with the repo to make that easier.

But the summary stays the same as always. By default, for programming, pick Opus and/or GPT. I use both at the same time. There's no advantage to picking any other, not even if your concern is price. The time you spend fixing the others' output isn't worth the savings.

Grok 4.3 and MiniMax M3 are good news in the sense that the floor is rising: "usable" beats "unusable," and each new generation gets closer. But usable at Tier B still means 1 to 2 hours of patching per project. With Opus at $1.10 delivering Tier A out of the gate, the cheaper models only win on paper.
