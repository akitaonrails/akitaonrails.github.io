---
title: "LLM Benchmark v5: How Much Does It Cost to Be Competent Enough?"
date: '2026-11-20T12:00:00-03:00'
slug: llm-benchmark-v5-how-much-does-it-cost-to-be-competent-enough
translationKey: llm-benchmark-v5-quanto-custa-ser-competente-o-suficiente
description: "I ran 16 Tier-A commercial models on the same greenfield Rails app: all passed with zero nudges, yet costs spanned 95x ($0.15 on GPT-6 Luna to $14.19 on Grok 4.7) with prompt caching driving the bill."
tags:
- llm-benchmarks
- llms
- coding-agents
draft: false
---

In my [last commercial LLM benchmark](/en/2026/10/28/llm-benchmark-v4-gemini-4-argon-gpt-6-1-sol-terra-kimi-k3-1-pro-claude-sonnet-5-5/), I already warned that I was probably done updating that ranking. I still feel it is barely worth chasing every new release just to compare raw code quality.

At least on quality and coding performance, the race has stopped being interesting. I could not care less if Anthropic just shipped **Claude Fable 5.2** or OpenAI dropped **GPT-6.2 Astra**: in practice, neither of them is going to change my day-to-day work.

Sure, on narrow niche problems or obscure algorithmic edge cases they are probably a bit sharper. For everyday software engineering, the end result feels the same.

Worse: every time a lab ships a new flagship in this generation, it feels like they either hike per-token prices or burn far more tokens than necessary to deliver the same output. That is why I built **Benchmark v5** in [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark), shifting the yardstick to what actually hits your wallet: **cost, speed, and prompt-caching economics**.

## The experiment: everyone can finish, but at what price?

For v5, I revisited the task of building a full-stack Ruby on Rails chat app with RubyLLM from scratch (the same 14-goal brief from v2: Tailwind, Hotwire/Stimulus/Turbo Streams, true streaming, concurrency-safe persistence under `WEB_CONCURRENCY=2`, `server_time` and `calculator` tools, structured-output auto-title, token budgeting, Minitest with SimpleCov, RuboCop, Brakeman, Dockerfile, and Docker Compose).

Each model ran inside its CLI harness (`codex`, `claude`, `agy`, `opencode`, `qwen`, `grok`, `muse`) across two phases: Phase 1 for building and Phase 2 for local and Docker validation. Every dollar figure comes from verified November 19, 2026 official first-party API rate cards, using exact 5-bucket token accounting (`input_uncached`, `cache_read`, `cache_write`, `output`, and `reasoning`).

Because my whole thesis is that Tier-A models have converged and can all solve the same general problems, the v5 runner allowed **up to 2 standardized nudges** if a model stumbled on tests, local boot, or Docker. I do not consider that unfair. The whole point was giving every model a fair shot to finish a working app and folding any extra nudge time and tokens into its final bill.

> The surprise of the experiment: not a single one of the 16 passing models needed a nudge. All 16 cleared the full quality gate on the first run with zero nudges.

The only model in the roster left out of the ranking was Meta's **Muse Wonder 1.0**, which hit an infrastructure wall: its subscription quota ran out at 103% with HTTP 429 after just 12 calls. I already ran into this exact same problem in the [previous v4 benchmark](/en/2026/10/28/llm-benchmark-v4-gemini-4-argon-gpt-6-1-sol-terra-kimi-k3-1-pro-claude-sonnet-5-5/), where quotas and hangs stretched 126 productive minutes across nearly 15 days.

It is by far the worst value in terms of price versus quota limits, so tight that it will not even let me finish a simple benchmark. The model might be wonderful, and none of that matters if you can barely run it; I cannot recommend it.

The other 16 models shipped the exact same working, tested, linted, Dockerized Rails app. The entire difference came down to how long they took and how much they cost.

## Benchmark v5 ranking (sorted by actual API-equivalent cost)

The table below ranks all 16 passing models by actual official API-equivalent cost (with prompt caching active), alongside the counterfactual no-cache cost, net cache savings, cache hit rate, wall-clock time, and total token volume:

| Rank | Model | Family | Harness | Nudges | Wall | Actual $ | No-Cache $ | Cache Saved | Cache Hit | Total Tok |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| 1 | **GPT-6 Luna** | OpenAI | `codex` | 0 | 19.4m | **$0.15** | $1.03 | -85.6% | 97.8% | 10.10M |
| 2 | **GPT-6.1 Terra** | OpenAI | `codex` | 0 | **7.4m** | **$0.50** | $4.77 | -89.5% | 96.8% | **4.67M** |
| 3 | **DeepSeek V4.1 Flash** | DeepSeek | `opencode` | 0 | 29.2m | **$0.56**¹ | $9.87 | **-94.3%** | 98.4% | 32.35M |
| 4 | **Qwen 4 Max** | Alibaba | `qwen` | 0 | 43.8m | **$1.78** | $18.22 | -90.2% | 97.5% | 11.93M |
| 5 | **Gemini 4 Hydrogen** | Google | `agy` | 0 | 16.2m | **$1.89** | $12.89 | -85.3% | 95.4% | 8.19M |
| 6 | **GPT-6.2 Sol** | OpenAI | `codex` | 0 | 25.3m | **$2.02** | $17.20 | -88.2% | 96.7% | 8.33M |
| 7 | **Claude Sonnet 5.5** | Anthropic | `claude` | 0 | 15.7m | **$2.14** | $11.50 | -81.4% | 96.5% | 5.39M |
| 8 | **Kimi K3.1 Pro** | Moonshot | `opencode` | 0 | 16.0m | **$2.66**² | $14.23 | -81.3% | 95.6% | 6.80M |
| 9 | **Gemini 4 Neon** | Google | `agy` | 0 | 24.1m | **$3.10** | $16.01 | -80.6% | 93.9% | 4.92M |
| 10 | **Gemini 4 Carbon** | Google | `agy` | 0 | 39.1m | **$3.29**³ | $21.32 | -84.6% | 95.4% | 10.09M |
| 11 | **DeepSeek V4 Pro** | DeepSeek | `opencode` | 0 | 35.2m | **$3.39**⁴ | $49.25 | -93.1% | 98.3% | 36.81M |
| 12 | **Claude Opus 5.5** | Anthropic | `claude` | 0 | 19.7m | **$5.73**⁵ | $40.06 | -85.7% | 97.7% | 9.58M |
| 13 | **GPT-6.2 Astra** | OpenAI | `codex` | 0 | 15.9m | **$5.78** | $58.92 | -90.2% | 97.6% | 7.20M |
| 14 | **GLM-5.3** | Z.ai | `opencode` | 0 | 28.5m | **$6.08**⁶ | $29.44 | -79.4% | **99.1%** | 20.80M |
| 15 | **Claude Fable 5.2** | Anthropic | `claude` | 0 | 35.0m | **$12.96** | $82.14 | -84.2% | 96.9% | 9.63M |
| 16 | **Grok 4.7** | xAI | `grok` | 0 | 87.4m | **$14.19**⁷ | $46.09 | -69.2% | 95.0% | 22.60M |

*Table footnotes:*
* ¹ **DeepSeek V4.1 Flash**: $0.56 at official peak rates; drops to $0.28 off-peak and $0.43 on OpenRouter.
* ² **Kimi K3.1 Pro**: $2.66 on Moonshot's official API; $1.92 on OpenRouter.
* ³ **Gemini 4 Carbon**: $3.29 at Google's intro rate ($2/$10 through Nov 30, 2026); doubles to **$6.58** on Dec 1.
* ⁴ **DeepSeek V4 Pro**: $3.39 official peak ($1.69 off-peak); on OpenRouter the exact same run jumps to **$10.59**.
* ⁵ **Claude Opus 5.5**: passed all 135 tests (99.77% coverage), RuboCop, Brakeman, and Docker in Phase 2 with zero code edits; an early unpatched runner lacking an ephemeral Redis daemon triggered two false nudges (+$1.69), while the table reports true Phase 1+2 cost.
* ⁶ **GLM-5.3**: $6.08 on Z.ai's official API; drops to **$1.58** on discounted OpenRouter providers.
* ⁷ **Grok 4.7**: Phase 2 exited on a background-wait timeout after logging all 87 usage events ($9.51 Phase 1 + $4.68 recovered Phase 2).

## The real math behind the bill: prompt caching and verbosity

The first number that jumps off the page is the spread from top to bottom: a **95x price gap** ($0.15 vs. $14.19) to ship the exact same passing Rails app. Wall-clock time stretched nearly 12x, from 7.4 minutes on GPT-6.1 Terra to 87.4 minutes on Grok 4.7.

The bigger lesson of v5 is that **headline per-million rate cards lie**. In agentic coding, 94% to 99% of all prompt tokens are cache reads. Without prompt caching, a single Rails app would cost $11.50 to $82.14 on frontier models. Caching slashed bills by 69% to 94%.

Three hidden mechanics explain why the final order looks nothing like the marketing pages:

* On Claude Code with 1-hour TTL cache writes (billed at 2x base input), cache writes alone ate 30% to 37% of the entire invoice. On Claude Fable 5.2, $4.78 of the $12.96 went purely to writing cache; on Opus 5.5 it was $1.72 of $5.73; on Sonnet 5.5, $0.73 of $2.14.
* GPT-6.2 Astra and Claude Fable 5.2 share the exact same headline rate card ($8 input, $40 output per million). Yet Astra cost less than half ($5.78 vs. $12.96) and finished in less than half the time (15.9 minutes vs. 35 minutes), because it emitted four times fewer output tokens (40K vs. 159K) and paid zero cache-write surcharges on Codex.
* Grok 4.7 has a friendly $2/M headline input price, yet its cache-read discount is only 75% ($0.50/M) and all rates double past 200K context. Burning 21 million cache-read tokens turned into $10.63 in cache reads alone, making Grok the priciest run in the entire field, even above Fable 5.2.

## Breaking down the model tiers

### The ultra-cheap Pareto frontier: GPT-6 Luna and GPT-6.1 Terra

Plot **cost against wall-clock speed** and only two models sit on the strict Pareto frontier: **GPT-6 Luna** ($0.15 in 19.4 minutes) and **GPT-6.1 Terra** ($0.50 in 7.4 minutes). Every other model in the 16-model field cost more and took longer than Terra on this task.

Unsurprisingly, smaller models cost far less. What stood out is that both Luna and Terra cleared every single quality gate on the first try with zero nudges.

Inspecting the generated code on disk shows *how* they pulled that off. GPT-6 Luna shipped a lean app with 4 test files (143 lines) and roughly 320 lines in `app/`. Terra was even terser: 4 test files (190 lines) and 260 lines in `app/`. Everything was valid, clean under RuboCop and Brakeman, booted in Docker, and used real RubyLLM APIs.

Compare that with larger models on the same brief: Claude Sonnet 5.5 wrote 12 test files (705 lines), Gemini 4 Neon wrote 14 files (1,084 lines), Opus 5.5 wrote 18 files (1,097 lines), and Fable 5.2 wrote 21 files (1,640 lines). Luna and Terra write the bare minimum required to satisfy the spec cleanly; mid-tier and frontier models modularize more and test far more edge cases.

### The sweet spot in the middle ($1.78 to $3.39)

Between $1.78 and $3.39 sits the most compelling group on the market today: **Qwen 4 Max** ($1.78), **Gemini 4 Hydrogen** ($1.89), **GPT-6.2 Sol** ($2.02), **Claude Sonnet 5.5** ($2.14), **Kimi K3.1 Pro** ($2.66), **Gemini 4 Neon** ($3.10), and **Gemini 4 Carbon** ($3.29 intro, jumping to $6.58 on Dec 1).

Look at that speed cluster: Sonnet 5.5 (15.7m), Kimi K3.1 Pro (16.0m), and Gemini 4 Hydrogen (16.2m) all ship the complete project in roughly 16 minutes for around two bucks. You get much richer test suites (9 to 17 test files) at a fraction of flagship pricing.

### The heavyweights ($5.73 to $14.19)

At the top end, **Claude Opus 5.5** ($5.73 in 19.7m) and **GPT-6.2 Astra** ($5.78 in 15.9m) land in a dead heat on price. Above them, **Claude Fable 5.2** ($12.96 in 35m) costs more than twice as much as Opus and Astra for the same passing deliverable, and **Grok 4.7** ($14.19 in nearly an hour and a half) is wildly out of proportion for standard web apps.

If you run on monthly subscriptions instead of raw API billing, here is where the math breaks even:

| Plan | Monthly | Model | API-Equiv / Run | Break-Even |
|---|---:|---|---:|---:|
| **Claude Max 20x** | $200 | Claude Fable 5.2 | $12.96 | ~15 runs/mo |
| **Claude Max 20x** | $200 | Claude Opus 5.5 | $5.73 | ~35 runs/mo |
| **Claude Pro** | $20 | Claude Sonnet 5.5 | $2.14 | ~9 runs/mo |
| **ChatGPT Pro 20x** | $200 | GPT-6.2 Astra | $5.78 | ~35 runs/mo |
| **ChatGPT Plus** | $20 | GPT-6.2 Sol | $2.02 | ~10 runs/mo |
| **ChatGPT Plus** | $20 | GPT-6.1 Terra | $0.50 | ~40 runs/mo |
| **Google AI Pro** | $20 | Gemini 4 Neon / Carbon | $3.10 to $3.29 | ~6 runs/mo |
| **Z.ai Coding Lite** | $18 | GLM-5.3 | $6.08 official ($1.58 OR) | ~3 runs/mo (~11 OR) |

## The myth that Chinese models are always the cheapest

Most developers assume on autopilot that Chinese models are automatically the cheapest option. Once you account for actual token burn and prompt-caching rates, the picture looks very different.

**DeepSeek V4.1 Flash** really is cheap ($0.56 official peak, $0.28 off-peak, $0.43 on OpenRouter). Look at how many tokens it burned to get there, though: **32.35 million tokens**, nearly seven times GPT-6.1 Terra (4.67 million). It stayed cheap only because DeepSeek's cache-read discount is massive (98% off, $0.006/M).

On **DeepSeek V4 Pro**, that verbosity blew up even further: **36.81 million tokens**, the highest token count in the entire benchmark. On official API rates that came to $3.39, while on OpenRouter the exact same run skyrockets to **$10.59**, nearly double Opus 5.5 and GPT-6.2 Astra.

The biggest twist is **GLM-5.3**. It posted the highest cache hit rate in the entire benchmark (99.1%), yet burned 20.80 million tokens. Because Z.ai's official cache-read rate is relatively steep ($0.26/M), GLM-5.3 cost **$6.08** on first-party API rates, coming out pricier than both Claude Opus 5.5 ($5.73) and GPT-6.2 Astra ($5.78). It only turns into a bargain through discounted OpenRouter providers ($1.58) or Z.ai's $18 Coding Lite subscription.

Meanwhile, **Qwen 4 Max** ($1.78, taking nearly 44 minutes) and **Kimi K3.1 Pro** ($2.66 official or $1.92 on OpenRouter, in 16 minutes) sit squarely in the middle of the table alongside Sol, Sonnet, and Hydrogen, well above Luna's $0.15 and Terra's $0.50. Right now, OpenAI's Luna and Terra beat the Chinese labs on actual delivered cost.

### My day-to-day experience with the Chinese models

Stepping outside the benchmark table into real daily work, my personal ranking among the Chinese models is clear: **GLM-5.3 first, Kimi K3.1 Pro second, and DeepSeek V4.1 Flash dead last**.

In everyday use, DeepSeek is by far the worst of the bunch. I only touch it when the quotas on every other model have already been exhausted.

The reason is simple: with DeepSeek I have to babysit it constantly. Sometimes it gets lost mid-task and drops assignments unfinished, spins into strange agentic loops, or flat-out does the wrong thing.

> DeepSeek is the only model of this current generation that still misbehaves like that. None of the other models I have been testing act up this way anymore.

## Pick for your domain, and run your own tests

If there is one takeaway from this benchmark (and from what I wrote earlier about being [competent enough](/en/2026/10/12/llms-agents-competent-enough/)), it is that **there is no one-size-fits-all model**.

You will meet developers who swear all day that GPT-6 Luna alone is more than enough, and they are probably right, because their domain problems simply do not demand more than Luna delivers. Right next to them, other engineers will swear they cannot touch anything below GPT-6.2 Astra or Claude Opus 5.5, and they are right too, because their domain genuinely demands it.

Every team and every codebase has different constraints. Never blindly trust any benchmark, mine included. Benchmark v5 measures price and speed on a greenfield Rails app; that makes Luna the cheapest, period. Your real answer is probably somewhere in the middle of the table.

In my own daily workflow right now, I am reaching for **Gemini 4 Neon** far more often than **Claude Opus 5.5** or **GPT-6.2 Sol**. I rarely touch **Claude Fable 5.2** or **GPT-6.2 Astra**, because they chew through token quotas way too fast for marginal gains. For most tasks, Opus and Sol are already overkill, and plenty of days I feel like **Claude Sonnet 5.5** or **GPT-6.1 Terra** would handle the job just fine.

Test models against your own code, measure how much time and how many tokens they burn on your workload, and stop paying rocket-fuel prices for a bicycle delivery.
