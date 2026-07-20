---
title: "LLM Benchmark: Kimi v2.7 Code, GLM 5.2, MiniMax M3 Local"
slug: "llm-benchmark-kimi-2-7-code-glm-5-2-minimax-m3-local"
date: '2026-06-14T13:00:00-03:00'
draft: false
translationKey: llm-benchmark-kimi-2-7-glm-5-2-minimax-m3-local
description: "In the benchmark, GLM 5.2 scored 87 and Kimi K2.7 Code scored 86. The open MiniMax M3 doesn’t fit in 128 GB, while serious programming still calls for Opus 4.8 or GPT 5.5."
tags:
- llm-benchmarks
- llms
- local-models
---

Another round of my coding benchmark. This time it's three open source entries: **Kimi K2.7 Code**, **GLM 5.2**, and the **MiniMax M3** that got open weights but that I can't run at home no matter how hard I squeeze. Before the numbers, the usual context for anyone who parachuted in here, plus an update to the data center soap opera, because there's news.

## For anyone just tuning in

This benchmark hands each model the same prompt and asks it to build, on its own, a ChatGPT-style chat app in Rails 8 + RubyLLM + Hotwire + Docker, with tests and CI. The score comes out of an 8-dimension rubric, 0 to 100, in A/B/C/D tiers. The whole series:

1. [Canonical May benchmark (Part 3)](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/). The full methodology and the ranking reference.
2. [DeepSeek unlocked with DeepClaude](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/). A harness swap pulling V4 Pro out of limbo.
3. [Update on Grok 4.3, MiniMax M3, Opus 4.8](/en/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/). M3 debuting via cloud.
4. [Fable 5 and the Anthropic soap opera](/en/2026/06/11/llm-benchmark-fable-5-anthropic-soap-opera/). The first public Mythos-class model.

## The data center soap opera got a new episode: SpaceX

In the last few posts I've been hammering the same nail: data center construction became the bottleneck of the AI era, and demand blew past the installed base with room to spare. [Nearly half of the US data centers planned for 2026 have been delayed or canceled](https://www.techradar.com/pro/if-one-piece-of-your-supply-chain-is-delayed-then-your-whole-project-cant-deliver-nearly-half-of-us-data-centers-planned-for-2026-canceled-or-delayed-and-things-could-soon-get-much-worse), stuck on transformers and electrical components with a three-year backlog. I went deep on that in the [Fable post](/en/2026/06/11/llm-benchmark-fable-5-anthropic-soap-opera/).

The new episode is financial. **SpaceX went public**, and it was the biggest IPO in Wall Street history: [556 million shares at $135, a $1.77 trillion valuation, with over $250 billion of investor demand](https://www.datacenterdynamics.com/en/news/spacex-ipo-musks-firm-set-to-launch-first-orbital-data-center-ai1-satellites-in-2027-will-put-compute-on-starlink-craft/) against the $75 billion the company first set out to raise. And the pitch that propped up that valuation was, of all things, AI compute: the **AI1 satellites**, "orbital data centers" SpaceX plans to launch starting late 2027, with [the company already signing compute deals with Anthropic and Google](https://www.scientificamerican.com/article/spacex-ipo-valuation-depends-on-starship-and-orbital-ai-data-centers/). The Anthropic and OpenAI IPOs come right behind, and all that money shares one goal: accelerate the availability of compute, because right now it can't keep up.

Here's the part that genuinely interests me. In a not-so-distant future, **open source LLMs can be part of the solution to that demand**. If a slice of the tasks migrates to a model running locally, on the developer's machine, that's less load hitting the cloud data centers. But "can be" isn't "already is," and this benchmark exists precisely to measure that distance.

## The usual reminder: serious programming means Opus 4.8 or GPT 5.5

I say this in every post and I'm not going to stop: serious programming work, today, is done with **Claude Opus 4.8 or GPT 5.5**, inside Claude Code or OpenCode. Full stop. The open source models haven't reached the point of carrying a real project, a long session, 100% vibe coded start to finish. They're too small, and the context window is too limited. By my yardstick, true programming only becomes feasible above roughly **200,000 tokens** of context, and most open source models don't come close to that with any quality. In my benchmark, nearly the entire open source field sits at Tier B or below.

Now for the "but." They're not standing still. Every generation they improve at a steady clip, and this round's three entries show it in black and white. The day an open source model becomes a consistent Tier A and runs with 200k of context on a machine that fits on your desk, the data center math changes. On to the numbers.

## Kimi K2.7 Code: almost there, with a silly regression

Kimi K2.7 Code (exposed on OpenRouter as `moonshotai/kimi-k2.7-code`) scored **86/100, Tier A, #8**. At $0.30 per run in 22 minutes, it's still one of the cheapest models in all of Tier A.

The RubyLLM integration is genuine end to end (`RubyLLM.chat` + `add_message` with full history replay + `complete` + `response.content`), verified against the gem source 1.16.0. Session-cookie persistence that survives restart and is multi-worker safe, 22 tests that exercise the LLM path with a correctly-signed mock and an error-path test, real Turbo Streams, and three Stimulus controllers. Solid engineering.

Worth logging a methodological trap this model exposed, because it's instructive. My structural scanner flagged **six `chat.user`/`chat.assistant` calls as hallucinations**, the exact invented signature that dropped GLM 5.1 to Tier C months ago. Except here they were all false positives: they resolve to the app's **own** domain methods (`Chat#user`, `Message.assistant`), not RubyLLM's DSL. Reading the code by hand made it clear the real API is correct. If I'd trusted the scanner blindly, I'd have sunk a Tier A unfairly. That's why this benchmark always reads the integration by hand, never just counts files.

And then comes the stumble that holds it **below** K2.6 itself (87): K2.7 Code **doesn't send a system prompt via `with_instructions`**. The assistant ships with no persona and no guardrail, a real gap for a "ChatGPT-style" app and the main regression from K2.6, which had one. On top of that, the session cookie has no message cap (`CookieOverflow` risk on a long chat), and the RubyLLM I/O lives inside the `Chat` value object instead of an isolated service. Funny detail: the "Code" variant, supposedly specialized for programming, regressed on a product dimension the general version got right.

## GLM 5.2: the biggest version-to-version turnaround in the whole benchmark

This was the round's highlight. GLM 5.2 scored **87/100, Tier A, #6**, and the size of the jump is what stuns: GLM 5.1 had scored **46/100, Tier C, #21**. From one version to the next, 41 points, three tiers, fifteen positions. It's the biggest intra-family turnaround I've ever measured.

The bug that doomed 5.1 was specific: it invented `chat.user`/`chat.assistant` to build the multi-turn history and crashed on turn 2. 5.2 just uses the real `chat.add_message(role:, content:)` for the replay, and that's that. Every call verified against the gem source 1.16.0, zero hallucinations. It has the **cleanest dependency injection of the whole field**: both the RubyLLM client and the controller's `service_class` are injectable, so the 26-test suite mocks the LLM path with a correctly-signed `FakeChat`/`FakeClient`, no external mock library, exercising streaming, system-prompt application, and error wrapping. Targets the right slug (`anthropic/claude-sonnet-4.6`), real Turbo Streams, full Gemfile, valid Ruby 4.0.5.

What holds it to a tie with Kimi K2.6 (and just behind it) is the same dimension that separated Fable 5 from Opus 4.8: **persistence**. The store is a process-local `Singleton` with **no cap**, dies on restart, isn't multi-worker safe, and grows without bound on top of that. The code is honest about this in its comments, but the rubric scores it below Kimi's capped, multi-worker-safe cookie. It was also the slowest Tier A run, 43 minutes on Z.ai's coding endpoint, which was throttled to 12-55 tokens/s.

The takeaway: GLM 5.1 → 5.2 is the clearest example that open source isn't stagnant. A model that was architectural garbage became Tier A in one generation, fixing the exact bug that mattered.

## MiniMax M3 local: the problem isn't the model, it's the hardware

Here the story is different, and it's the one that matters most to the argument about the future. MiniMax released **open weights** for M3: there's an [`unsloth/MiniMax-M3-GGUF`](https://huggingface.co/unsloth/MiniMax-M3-GGUF) and an [`ollama.com/library/minimax-m3`](https://ollama.com/library/minimax-m3) entry. Availability isn't the problem. **Memory is.**

M3 is a MoE/MSA with **~428 billion total parameters and ~23 billion active per token** (~427B in the safetensors; NVIDIA lists ~22B active, likely a rounding/counting difference) spread across **128 experts, with 4 active per token**. And here's the MoE catch: even though only ~23B activate per token, the **entire** weight set has to be resident in memory. You can't page an idle expert to the CPU without introducing latency that kills interactive inference. So the number that matters is total size, not active size:

| Quantization | GGUF size | RTX 5090 (32 GB) | Strix Halo (≤128 GB) |
|---|---|:---:|:---:|
| Q4_K_M | ~264 GB | ✗ | ✗ |
| Q3_K_M | ~195 GB | ✗ | ✗ |
| 1-bit | ~128 GB | ✗ | ✗ (no room for KV cache / OS) |

I run the local subset of this benchmark on a [Minisforum MS-S1 Max, the Strix Halo with 128 GB unified](/en/2026/03/31/minisforum-ms-s1-max-amd-ai-max-395-review/). It doesn't come close. Even the 1-bit quant (~128 GB), which would be useless for coding anyway, would eat the entire unified memory with nothing left for the KV cache or the OS. The 32 GB NVIDIA card doesn't even enter the conversation. There's no quant of M3 that runs at usable quality on either machine. Running "a MiniMax" locally today would mean grabbing a much smaller, weaker variant (like the `minimax-m2-tiny` distill), which is a different model, not M3.

Who **can** attempt it? A Mac Studio with 256 GB of unified RAM or more. Q3 (~195 GB) would fit a 256 GB Mac Studio, Q4 (~264 GB) only a 512 GB one. And if someone runs it, the expectation is that the result lands **around the same score as M3 via OpenRouter**, the 78/100 Tier B I already logged in the [previous post](/en/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/): same model, same weights, Q3/Q4 quantization shaves off very little. Only where it runs changes, the output is the same. So nobody would do it for the score; they'd do it for the sovereignty of running locally. But at that hardware cost, it's not worth it.

### The convergence I see coming (target: ~2030)

And this is where the two stories meet. The reason there's no practical local solution today is the same reason for the data center drought: **manufacturing chips is still brutally expensive**, because the whole industry has its focus locked on feeding data centers. Fast memory and cutting-edge silicon go where the money is, and the money is hyperscalers buying by the container-load. So for the next couple of years, give or take, we won't have a cheap, good local solution. The parts aren't available at a developer's-desk price.

But the near future points to a convergence. At some point data center construction hits a ceiling, whether from power, from electrical components, or from demand saturation. When that race slows down, hardware manufacturing capacity frees up and starts catching up with the rest of the market, with cost-effective silicon arriving for running models locally. Today the two extremes don't cut it: the 256 GB Mac Studio is too expensive to be "accessible," and the Strix Halo, which is accessible, is still too slow for serious practical use. But the next generation of hardware could close exactly that gap, with the memory and bandwidth of a Mac Studio at the price of a mini PC.

Put the two ends together: open source models improving steadily (the GLM 5.2 jump is the proof) on one side, and local hardware becoming viable as the data center race cools on the other. The day a Tier A GLM or Kimi runs with 200k of context on a desk machine that costs about as much as a decent laptop, the whole compute equation changes. My guess for that meeting point is something like **2030**. Still a way off, but we're heading there.

## Updated ranking

Kimi K2.7 Code and GLM 5.2 in bold:

| Rank | Model | Score | Tier | RubyLLM OK | Time | Cost |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | 97 | A | ✅ | 22m | ~$16 |
| 3 | GPT 5.5 xHigh (Codex) | 96 | A | ✅ | 18m | ~$10 |
| 4 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$1.10 |
| 5 | Claude Fable 5 | 94 | A | ✅ | 24m | ~$11 (est.) |
| 6 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$0.30 |
| 6 | **GLM 5.2 (Z.ai)** | **87** | **A** | ✅ | **43m** | **subscription** |
| **8** | **Kimi K2.7 Code** | **86** | **A** | ✅ | **22m** | **~$0.30** |
| 9 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 |
| 10 | Gemini 3.1 Pro | 82 | A | ✅ | 14m | ~$0.40 |
| 11 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 |
| 11 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 11 | MiniMax M3 | 78 | B | ✅ | 53m (phase 2 DNF) | ~$0.10 |
| 14 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.74 |
| 15 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 |
| 16 | DeepSeek V4 Pro \* | 69 | B | ✅ | 22m (DNF) | ~$0.50 |
| 16 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0.10 |
| 18 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.14 |
| 19 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 |
| 20 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 |
| 21 | Qwen 3.5 35B (local) | 55 | C | ✅ | 28m | free |
| 22 | GLM 4.7 Flash bf16 (local) | 52 | C | ✅ | failed | free |
| 23 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 24 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 |
| 25 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 |
| 26 | Qwen 3.5 122B (local) | 37 | D | ❌ | 43m | free |
| 27 | Qwen 3 Coder Next (local) | 32 | D | ❌ | 17m | free |
| 28 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.60 |
| 29 | GPT OSS 20B (local) | 11 | D | ❌ | failed | free |

\* DeepSeek V4 Pro only reaches Tier A (89/100) via DeepClaude. Story in the [dedicated post](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/).

## Conclusion

For today's work, nothing changes: Opus 4.8 and/or GPT 5.5 stay the recommendation for serious programming, and the best open source models still stall at the low-Tier-A ceiling with a short context window. Kimi K2.7 Code even slipped a notch over a silly system-prompt oversight, a reminder that "new version" isn't always "better version."

But GLM 5.2 jumping from Tier C to #6 in a single generation is the kind of signal I keep an eye on. Open source isn't stagnant, it's climbing, stubbornly. And when that movement meets hardware getting cheap (the convergence I see around 2030), the story of where we run our coding agents will look very different from today's. For now, it's cloud, it's Opus, it's GPT. But I keep measuring, generation by generation, because the day it turns, it'll turn fast.

The benchmark is open: [github.com/akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). Want to see another model in there? Fork it, add an entry to `config/models.json`, run it, and send the PR.
