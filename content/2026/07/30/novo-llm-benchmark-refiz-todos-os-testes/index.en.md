---
title: "New LLM Benchmark: I Reran Every Test!"
slug: "new-llm-benchmark-i-reran-every-test"
date: '2026-07-30T15:00:00-03:00'
draft: false
translationKey: novo-llm-benchmark-refiz-todos-os-testes
description: "I reran the LLM Coding Benchmark with a harder test, three phases, native harnesses, and new tiers. Fable led, Kimi won on cost, and 23 models proved suitable for programming."
tags:
- llm-benchmarks
- llms
- coding-agents
---

Five days ago I published my [Claude Opus 5 test](/en/2026/07/25/llm-benchmark-is-opus-5-any-good/). Eleven days ago I explained [why the highest score in a ranking does not mean "the best LLM"](/en/2026/07/19/llm-benchmark-should-i-use-the-highest-scoring-model/).

Great. The table in the first article is already a museum piece.

The argument in the second one still stands. In fact, it got even easier to demonstrate because I spent the last few days rerunning practically the entire benchmark. That meant dozens of runs, several discarded attempts, hundreds of dollars between API charges and credit equivalents, and an indecent amount of time reading robot-generated Rails code.

The result is **version 2** of my [LLM Coding Benchmark](https://github.com/akitaonrails/llm-coding-benchmark). The test got harder, the audit became more explicit, and each family now runs, whenever possible, in the harness where it should work best.

I'll say this up front: **v2 scores are not directly comparable to v1 scores**. The prompt changed. So did the requirements, several model-harness pairings, the validation, and the rubric. The `v1` column in the report is historical context, not a scientific measurement of how much each model "improved."

## Why I retired v1

We ran v1 for months. It did a good job separating models that could actually build a Rails app from those that invented RubyLLM APIs, wrote tests for their own hallucinations, and shipped Dockerfiles that never came up.

Then the newer models hit the ceiling of that test. Fifteen of the forty results were already packed into Tier A, with the top compressed between 92 and 97. The job still had real details, but the best models cleared the old discriminators easily. The order started coming down to an API-key preflight here, a cookie limit there, one missing error test. Valid details, not much separation.

There was another operational inconsistency: the model-harness pairing. Claude had been tested in OpenCode. So had Grok, Kimi, and Gemini. Today we have Claude Code, Codex, Kimi Code CLI, grok CLI, and Antigravity. Measuring a model in a generic harness when an integration tailored to its behavior exists can distort the result.

The benchmark was never measuring the weights file alone:

```text
result = model + harness + prompt + tools + context + execution + audit
```

So I stopped hiding the harness inside the score. Claude moved to Claude Code. GPT moved to Codex. Kimi K3 and K2.7-Coding moved to Kimi CLI. Grok and Gemini got A/B runs in their vendors' own CLIs. A fully isolated OpenCode remained the fallback for models without a better harness or subscription access.

## The new test

V1 had two phases: build the app and try to bring it up. V2 has **three phases**, fourteen numbered goals, and a ten-dimension rubric.

In phase one, the model still has to build a ChatGPT-style chat app on its own in Rails with RubyLLM, Hotwire, Tailwind, Minitest, Docker, and Compose. That's where the resemblance ends. Now it must also deliver:

- real per-token streaming through Turbo Streams, proven to be incremental;
- a correct multi-turn payload that does not send the current message twice, plus a test for the exact array sent to the provider;
- persistence that survives a restart and works with `WEB_CONCURRENCY=2`, with a TTL plus message-count and byte limits;
- exactly two tools, `server_time` and a safe calculator, using the real RubyLLM API;
- a title generated through the structured-output API;
- a per-conversation token budget;
- a system prompt, credential preflight, degraded states, and provider-error handling;
- a guarantee that failed turns never contaminate future history;
- clean RuboCop, Brakeman, and bundle-audit runs, plus a non-root production Docker image and no secrets.

Phase two does not accept a README claiming everything works. It boots Rails, watches the tokens arrive, forces real tool calls, holds a conversation across two workers, restarts the server, checks the history, runs tests and gates, executes `docker build`, and sends a real message to the app inside Compose.

Phase three asks the model to review every goal as `PASS`, `PARTIAL`, or `FAIL`, cite a file, line, test, or command, and write down what is still broken. That honesty is worth 15 points. An accurate `FAIL` is worth more than an optimistic `PASS` that the audit disproves.

This phase produced data v1 never had. Kimi K3 and Nex, for example, admitted defects that would have been easy to hide. Others built a reasonable app and then hallucinated their own inspection. Programming and reviewing what you programmed are different capabilities.

## The harness became part of the test

I also ran A/B tests with the native tools:

| Model | Clean OpenCode | Native harness | Reading |
|---|---:|---:|---|
| Grok 4.5 | 92 | 91 in grok CLI | difference within the noise |
| Grok 4.3 | 18 | 55 in grok CLI | native scaffolding rescues it, but it remains weak |
| Gemini 3.1 Pro | 62 | 88 in Antigravity | the direct path avoids a provider bug |
| Gemini 3.6 Flash | not run | 92 in Antigravity | good result, no comparable baseline |

A native harness does not sprinkle magic dust on a model. Grok 4.5 barely cared. Grok 4.3 needed the structure. Gemini 3.1 needed a transport that would not break on `Corrupted thought signature`. Three different mechanisms that a rushed comparison would flatten into "the CLI improved the score."

In the ranking below, I use the preferred harness whenever a complete run exists: Antigravity for the Geminis and grok CLI for the Groks. The OpenCode baselines remain in the repository as A/B data, but do not appear a second time in the table.

## The new ranking

This is the consolidated v2 table, with one entry per model in the preferred available harness.

| # | Model | Score | Tier | Harness |
|---:|---|---:|:---:|---|
| 1 | Claude Fable 5 | **96** | A.1 | Claude Code |
| 2 | Claude Sonnet 5 | **95** | A.1 | Claude Code |
| 2 | Claude Opus 5 | **95** | A.1 | Claude Code |
| 2 | Kimi K3 | **95** | A.1 | Kimi CLI |
| 5 | GPT 5.6 Sol | **93** | A.1 | Codex |
| 5 | Claude Opus 4.8 | **93** | A.1 | Claude Code |
| 7 | GLM 5.2 | **92** | A.1 | OpenCode |
| 7 | Kimi K2.5 | **92** | A.1 | OpenCode |
| 7 | Gemini 3.6 Flash @ high | **92** | A.1 | Antigravity |
| 10 | MiniMax M3 | **91** | A.1 | OpenCode |
| 10 | Kimi K2.6 | **91** | A.1 | OpenCode |
| 10 | Claude Opus 4.7 | **91** | A.1 | Claude Code |
| 10 | GPT 5.6 Luna | **91** | A.1 | Codex |
| 10 | Grok 4.5 | **91** | A.1 | grok CLI |
| 15 | Nex-N2-Pro | **88** | A.2 | OpenCode |
| 15 | GPT 5.5 | **88** | A.2 | Codex |
| 15 | Gemini 3.1 Pro @ high | **88** | A.2 | Antigravity |
| 18 | Claude Sonnet 4.6 | **87** | A.2 | Claude Code |
| 19 | GPT 5.4 | **86** | A.2 | Codex |
| 19 | Kimi K2.7-Coding | **86** | A.2 | Kimi CLI |
| 21 | Step 3.7 Flash | **84** | A.2 | OpenCode |
| 22 | Claude Opus 4.6 | **83** | A.2 | Claude Code |
| 22 | GLM 5 | **83** | A.2 | OpenCode |
| 24 | DeepSeek V4 Pro | **82** | B | OpenCode |
| 25 | DeepSeek V4 Flash | **80** | B | OpenCode |
| 26 | Qwen 3.6 Plus | **76** | B | OpenCode |
| 27 | MiMo V2.5 Pro | **73** | B | OpenCode |
| 28 | Grok 4.3 | **55** | C | grok CLI |
| 29 | Qwen3.7 Max | **51** | C | OpenCode |
| 30 | Step 3.5 Flash | **27** | D | OpenCode |

The details, artifacts, and deductions are in the [full v2 report](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.v2.md).

## What the tiers mean now

The new cutoff is anchored on Claude Opus 4.6, which scored 83 and showed the minimum needed to carry the entire test. Here's the practical interpretation:

| Tier | Score | How I read it |
|:---:|---:|---|
| **A.1** | **90 or higher** | The frontier of this test. More complete and consistent delivery; differences of one or two points inside the group remain noise. |
| **A.2** | **83 to 89** | Suitable for programming and past the same competence floor, but with more visible fixes or limitations. I still recommend these models, with closer review. |
| **B** | **73 to 82** | Close, but it still needs human cleanup in an important area. I do not recommend it for autonomous work; I keep it on the radar. |
| **C** | **51 to 72** | I do not recommend it for programming. It may still work for translation, summarization, classification, and simple agents. |
| **D** | **50 or lower** | Inconsistent, broken, or difficult-to-predict behavior. I do not feel safe recommending it even for simple automation. |

There are **14 models in A.1** and **9 in A.2**. All 23 cleared the competence floor for this kind of work. The subdivision helps decide where to start: A.1 contains the frontier results; A.2 contains capable models that needed more fixes, left shallower tests, or carried clearer operational limitations.

That does not make 96 universally more intelligent than 91, nor does it make an A.2 model bad. An A.2 model may be better at refactoring, debugging, frontend work, or inside your fifteen-year-old monolith. This test does not measure all of that. The cutoff simply avoids throwing 23 options into one oversized bucket.

A.1 and A.2 make up the candidate pool. I cut Tier C and D before I start.

## So which one is best: Fable, Opus, Sol, or Kimi?

If all you want is a one-line answer, you're going to be disappointed again.

| Model | Score | Time | API equivalent | Practical use |
|---|---:|---:|---:|---|
| Claude Fable 5 | 96 | 46 min | $26.03 | Claude Max subscription |
| Claude Opus 5 | 95 | 78 min | $38.91 | Claude Max subscription |
| Kimi K3 | 95 | 65 min | $6.14 | Moderato subscription |
| GPT 5.6 Sol | 93 | 57 min | ~$45 blended | ChatGPT credits |

On the final artifact, **Fable won**. It was also the fastest of these four. If I were paying for every API call in this run, **Kimi K3 won on cost by a mile**, tying Opus at 95 and landing only one point behind Fable.

Opus 5 built an excellent project, but it was the slowest and burned 56.8 million tokens as counted by Claude Code. In this test, the extra 33 minutes over Fable bought nothing visible. Sol also delivered good work, but finished two points behind K3 at a much higher equivalent cost.

If you already pay for Claude Max or ChatGPT Pro, the marginal cost stays near zero while you remain within the limits. Kimi Moderato is also a subscription, with its own quota windows. So "$26 versus $6" does not settle anything by itself. The first question is which subscription you already pay for and how much room it has left. For pay-as-you-go and automation, per-run cost moves back to center stage.

My reading of this run:

- **Fable 5** delivered the best combination of quality and time;
- **Kimi K3** offered the best value among the leaders;
- **Opus 5** was capable and meticulous, but expensive and slow in this execution;
- **GPT 5.6 Sol** remains strong if you live in Codex and already pay for OpenAI's credits.

That's a reading of this project. Change the workload and the order may flip.

## Opus versus Sonnet, Sol versus Luna

A tier name is not a benchmark. Sonnet 5 proved that in an almost embarrassing way:

| Claude | Score | Time | Recorded cost |
|---|---:|---:|---:|
| Fable 5 | 96 | 46 min | $26.03 API equivalent |
| Opus 5 | 95 | 78 min | $38.91 API equivalent |
| Sonnet 5 | 95 | 59 min | $25.83 subscription equivalent |
| Opus 4.8 | 93 | 53 min | $21.82 subscription equivalent |

Sonnet 5 tied Opus 5, finished nineteen minutes earlier, and produced the first genuine 100% line coverage in the entire benchmark. It also wrote the family's best self-review. Automatically choosing Opus because "Opus is the higher tier" would mean throwing out your own data.

This also corrects a terrible impression from v1, where Sonnet 5 scored 58 and hallucinated the RubyLLM API. In v2 it ran through Claude Code, received explicit requirements, and scored 95. We cannot conclude that the model improved by 37 points because we changed practically the entire experiment. We can conclude that the v1 pairing was a poor representation of what it can do.

On the OpenAI side:

| GPT | Score | Time | Blended equivalent cost |
|---|---:|---:|---:|
| GPT 5.6 Sol | 93 | 57 min | ~$45 |
| GPT 5.6 Luna | 91 | 46 min | $16.79 |
| GPT 5.5 | 88 | 58 min | ~$53 |
| GPT 5.4 | 86 | 67 min | ~$26 |

Sol buys two points over Luna, but Luna finishes eleven minutes sooner and costs a little more than one-third as much in the calculation that discounts cache hits. Both are A.1. For maximum rigor I would start with Sol; at volume, Luna looks far more rational.

The important detail is the cache. The new Codex event exposed that 19.7 million of Luna's 20.4 million input tokens were cache hits. Pricing everything as fresh input would produce $105.45. At the cache rate, it falls to $16.79. Any cost table that mixes CLIs without understanding what each one reports is comparing apples to JSON.

## What about the Chinese models?

The line about Chinese models being useful only as cheaper alternatives is stale.

| Model | Score | Tier | Time | Reported cost |
|---|---:|:---:|---:|---:|
| Kimi K3 | 95 | A.1 | 65 min | $6.14 equivalent, subscription |
| Kimi K2.5 | 92 | A.1 | 43 min | $0.0275, API |
| Kimi K2.6 | 91 | A.1 | 34 min | $0.0581, API |
| Kimi K2.7-Coding | 86 | A.2 | 54 min | $4.37 equivalent, subscription |
| MiniMax M3 | 91 | A.1 | 113 min | $0.17, API |
| GLM 5.2 | 92 | A.1 | 155 min | $0 marginal, Z.ai subscription |
| DeepSeek V4 Pro | 82 | B | 57 min | $0.0127, API |
| DeepSeek V4 Flash | 80 | B | 36 min | $0.0054, API |

Kimi K3 tied Opus 5. K2.5, K2.6, MiniMax M3, and GLM 5.2 landed in the same A.1 as Claude and GPT. The reported cost of the latter three is ridiculous next to the American leaders, although token metrics are not perfectly comparable across CLIs.

Kimi is the easiest family to recommend today. K3 offers top-tier quality through a cheap subscription. K2.5 and K2.6 were absurdly economical over the API. K2.7 landed below its siblings, but it ran in another harness, so I am not going to invent a tidy progression story from four isolated data points.

MiniMax M3 deserves attention and caution in equal measure. It scored 91 for seventeen cents, but took almost two hours and was especially sensitive to harness scaffolding. Great value when it clicks; a terrible candidate to trust without watching.

GLM 5.2 scored 92 at zero marginal cost on Z.ai's plan. It took about two and a half hours. If wall-clock time does not matter, it is a very strong option. If you work in short cycles, Grok 4.5 delivered 91 in about 25 minutes through grok CLI, more than six times faster.

DeepSeek remains almost comically cheap, but stopped in Tier B. V4 Pro scored 82 and V4 Flash scored 80. They're close, and I want to repeat the test when a new version arrives. Today I still would not leave either one working alone as a coding agent in a codebase that matters. Saving pennies only to spend an hour reviewing a structural defect is lousy math.

## Why I did not rerun the local models

I did not run Qwen 3.5 or the other local models on v2. The priority shifted to mapping the programming Tier A more accurately, and every complete run of this test costs machine time, audit time, and sanity.

Local models are not useless. They work for translation, classification, summarization, controlled one-shots, and tasks where privacy or offline operation matters more than quality. For autonomous coding agents, though, the v1 tests landed far below the floor. V2 is harder. I see no reason to spend several more days confirming that a quantized local Qwen cannot compete with Fable, Opus, Sol, or Kimi in software engineering.

For programming, it is not worth it today. If a new local model appears with strong evidence behind it, I'll test it. Until then, I'd rather spend my time separating the twenty-three models that have already cleared the floor.

## Conclusion

V1 did its job and saturated. V2 puts pressure where today's models still slip: real streaming, multi-turn payloads, concurrency, persistence, tools, structured output, budgeting, operational security, faithful tests, and the ability to admit their own defects.

Fable 5 finished on top with 96. Sonnet 5, Opus 5, and Kimi K3 tied at 95. Sol came right behind them at 93. That answers which models produced the best projects on this test.

Choosing what to use is a different reading:

- Tier A.1 contains the 14 frontier results, all scoring 90 or higher;
- Tier A.2 contains 9 capable models from 83 to 89, still worth recommending with closer review;
- Tier B is close, but I still do not recommend it for autonomous work;
- Tier C is for translation, summarization, and simple agents;
- Tier D is too inconsistent for me to recommend;
- inside Tier A, choose by subscription, speed, cost, and harness;
- one or two points do not make anyone the universal champion of intelligence.

My own choice remains concentrated on Claude Code and Codex because those are the harnesses I use every day. Kimi K3 has become a serious top-tier alternative. Grok 4.5 is the speed champion of this round. GLM and MiniMax offer nearly free runs if you can stand the wait. Sonnet 5 proved that reflexively paying for or selecting the "higher" tier can be a waste.

All generated code, prompts, results, self-reviews, rubric details, and corrections are in [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). The major code and test overhaul is already on `master`. Contributions are welcome, whether you want to add a model, improve a harness, dispute a deduction, or find another bug in the auditor.

Just bring artifacts and data. We have enough ranking opinions already.
