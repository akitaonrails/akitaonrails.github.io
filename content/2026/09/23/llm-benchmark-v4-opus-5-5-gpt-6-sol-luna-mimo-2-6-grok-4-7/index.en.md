---
title: "LLM Benchmark v4: Opus 5.5, GPT Sol/Luna 6, Mimo 2.6, Grok 4.7"
slug: "llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7"
date: '2026-09-23T13:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7
description: "Five new models entered my v4 sabotage benchmark: Opus 5.5, GPT 6 sol and luna, MiMo V2.6 Pro, and Grok 4.7. I compare against external benchmarks, answer whether upgrading is worth it, and Grok 4.7 regresses badly against its own predecessor."
tags:
- llm-benchmarks
- llms
- coding-agents
---

This is the first update since the revamped v4 methodology went live, explained across two parts: [Part 1](/en/2026/09/15/new-llm-benchmark-v4-retesting-all-top-llms-part-1/) covers the process and the fourteen sabotage items, [Part 2](/en/2026/09/15/new-llm-benchmark-v4-retesting-39-llms-part-2/) has the full table for the original 39 models. Five new models shipped since then, and I checked each version against the repo before writing this: **Claude Opus 5.5**, **GPT 6 sol** and **GPT 6 luna** (two separate models, not one), **Xiaomi MiMo V2.6 Pro**, and **Grok 4.7**. The names in the title match exactly what I ran.

## The Methodology, Super Quick Recap

For anyone who hasn't read the previous two parts: v4 isn't a loose battery of questions, it's a single Rails app that grows across seven sprints, with an isolated subagent planting fourteen real CVE-based sabotage items along the way, disguised as a normal commit from a fictional dev. The model is never told sabotage exists, only at the seventh and final sprint does the explicit reveal happen. Catching it unprompted is full credit, catching it only after the reveal is 40%, never fixing it is zero. This measures security vigilance under active sabotage, not general code quality. Full detail in Part 1.

## The Updated Table, 44 Models

Same table as Part 2, now with 44 rows. The five models from this update are in **bold**, to distinguish them from ᴺ, which already marked additions from previous rounds.

| Rank | Model | Score | Tier | Never-fixed | Cost | Wall | Harness |
|-----:|-------|:-----:|:----:|------------------|:----:|:----:|:-------:|
| 1 | GPT-6 Astra | 100.0 | A | — | $30.55 | 100m | codex |
| 1 | Claude Opus 5 | 100.0 | A | — | ~$71 | 145m | claude |
| 1 | Claude Fable 5 | 100.0 | A | — | ~$50 ᵉ | ~85m ᵉ | claude |
| 1 | **Claude Opus 5.5** | 100.0 | A | — | **$16.63** | 64m | claude |
| 1 | GPT 5.6 sol | 100.0 | A | — | $20.37 | 317m | codex |
| 1 | GPT 5.6 terra | 100.0 | A | — | **$9.52** | 80m | codex |
| 1 | GPT 5.5 | 100.0 | A | — | $34.69 | 117m | codex |
| 8 | Grok 4.6 ᶜ | 98.5 | A | — | $13.00 | 67m | opencode |
| 9 | Claude Fable 5.1 | 95.5 | A | — | ~$51 | 133m | claude |
| 9 | Sakana Fugu Ultra v2 ᴺ | 95.5 | A | — | $122.01 | 294m | opencode |
| 9 | **GPT 6 luna** | 95.5 | A | — | $44.90 | 122m | codex |
| 12 | GPT 5.6 luna | 95.0 | A | item #8 (2) | $10.04 | 123m | codex |
| 13 | Nex N2.5 Pro ᴺ | 94.0 * | A | — (uncommitted) | **$0 free** | 480m | opencode |
| 13 | GLM 5.3 (zcode) ᴺ | 94.0 | A | — | flat-rate plan | 215m | zcode |
| 15 | DeepSeek V4.1 Flash ᴺ | 92.5 | A | — | **$1.21** | 172m | opencode |
| 16 | **Xiaomi MiMo V2.6 Pro** | 92.0 | A | item #12 (2) | **$1.22** | 308m | opencode |
| 17 | Claude Sonnet 5 | 91.0 | A | — | ~$27 | 112m | claude |
| 17 | **GPT 6 sol** | 91.0 | A | — | $22.06 | 73m | codex |
| 19 | Gemini 3.8 Flash·high (OpenRouter) | 90.5 | A | item #12 (2) | $15.98 | 97m | opencode |
| 20 | Gemini 3.8 Flash (Antigravity) ᴺ | 89.5 | A | — | $0 (OAuth) | 120m | agy |
| 21 | Muse Spark 1.3 | 88.75 | A | — | $13.31 | 150m | opencode |
| 22 | Grok 4.5 | 88.0 | A | items #7b, #12 (3) | $6.19 | 48m | opencode |
| 23 | Claude Opus 4.6 | 87.5 | A | item #8 (2) | $25.64 | 89m | claude |
| 24 | Kimi K2.7 | 87.25 | A | — | $7.75 | 175m | kimi |
| 25 | MiMo V2.5 Pro | 86.5 | A | — | **$1.03** | 158m | opencode |
| 25 | Qwen3 8 Flash ᴿ | 86.5 | A | — | **$1.17** | 149m | opencode |
| 27 | DeepSeek V4 Flash | 86.0 | A | items #6, #8 (5) | **$0.97** | 111m | opencode |
| 27 | Claude Opus 4.8 ᴿ | 86.0 | A | item #8 (2) | ~$37 | 87m | claude |
| 29 | Claude Sonnet 4.6 | 85.75 | A | item #6 (1.5) | $18.64 | 91m | claude |
| 30 | Kimi K3 | 85.0 | A | — | $13.79 | 148m | kimi |
| 30 | DeepSeek V4 Flash 0731 | 85.0 | A | items #2, #6 (6) | $1.94 | 194m | opencode |
| 32 | GLM 5.3 Flash (zcode) ᴺ | 84.25 | A | — | flat-rate plan | 296m | zcode |
| 33 | DeepSeek V4 Pro 0813 | 84.0 | A | items #8, #9 (4) | $4.49 | 152m | opencode |
| 34 | Step 3.7 Flash | 83.75 | A | items #6, #8, #11 (6.5) | $4.15 | 118m | opencode |
| 35 | **Grok 4.7** | 83.5 | A | — | $27.94 | 120m | opencode |
| 36 | DeepSeek V4 Pro (base) ᶜ | 82.0 | B | — | $5.26 | 97m | opencode |
| 37 | Qwen 3.8 27B (Strix Halo, local) ᴺ | 80.0 | B | items #2, #7b, #8, #12 (8) | **$0 local** | 706m | opencode |
| 38 | Qwen 3.7 Max | 79.0 | B | items #6, #7, #8 (6) | $10.63 | 106m | opencode |
| 39 | GLM 5.2 (zcode) ᴺ ᶜ | 77.0 | B | item #12 (2) | flat-rate plan | 239m | zcode |
| 40 | Gemini 3.7 Flash·high | 75.5 | B | item #12 (2) | $12.93 | 85m | opencode |
| 40 | MiniMax M3 | 75.5 | B | items #6, #8 (3.5) | $12.17 | 187m | opencode |
| 42 | Mistral Large 3 | 39.0 | C | 7 items (19) | $5.11 | 76m | opencode |
| 43 | Gemini 3.1 Pro (OpenRouter) ᶜ | 32.5 * | C | 9 items (27) | $10.31 | 54m | opencode |
| 44 | GLM-4.7-Flash (local) ᴺ | 24.0 | C | 6 items (16) | **$0 local** | 29m | opencode |

Cost isn't comparable across different harnesses: codex/opencode/kimi charge real per-token API cost, Claude uses a Max subscription (notional cost), Antigravity is Google OAuth with no per-token cost, zcode is a flat-rate plan. Only compare cost within the same harness.

## This Round's Surprises

### Grok 4.7 Regressed, and Not Just on the Score

Grok 4.7 closed at 83.5, fifteen points below its own Grok 4.6 (98.5), my overall runner-up. And no, it didn't make up for it on cost or speed either: $27.94 and 120 minutes against $13.00 and 67 minutes for 4.6. More expensive, slower, worse score. A regression on all three axes at once is rare in this benchmark.

The error profile is very specific: it caught every loud sabotage on its own, both critical items, the IDOR, the hardcoded key, the CORS. But it pushed all four disguised sabotages to the reveal, including the stored XSS that survived all the way to the capstone, and it was even fooled by a test adapted to accept the sabotage in item #6 along the way. Strong on the obvious, blind on the disguised.

Just one clean run, so I treat this as a data point, not a final verdict on the Grok 4.7 family. But the data I have today is: worse, more expensive, slower.

### Opus 5.5 Is the Opposite: Same Top Score, a Quarter of the Cost

Opus 5.5 walked straight into the 100-point club, tying Astra, Opus 5, Fable 5, GPT 5.6 sol and terra, and GPT 5.5. It caught everything without needing any reveal at all, the seventh sprint didn't even run because there was nothing left to reveal. And it went beyond the minimum: it wrote its own regression tests for SQL injection and session revocation, and stacked a Content-Security-Policy and Permissions-Policy at the capstone, without anyone asking.

The number that actually matters: **$16.63 and 64 minutes** against **~$71 and 145 minutes** for Opus 5, to land on the exact same perfect score. A quarter of the cost, less than half the time, zero quality loss on this specific test.

### GPT 6 Sol and Luna: Expensive, and Worse on Vigilance Than the Predecessor

GPT 6 sol closed at 91.0, tied with Claude Sonnet 5, but nine points below its own GPT 5.6 sol (100.0), paying a bit more, $22.06 against $20.37, in much less time. GPT 6 luna scored 95.5, technically tying or slightly beating GPT 5.6 luna (95.0), except costing **four and a half times more**, $44.90 against $10.04, for a half-point gain.

Sol's error pattern is the same as Grok 4.7's: it catches the obvious on its own, pushes the disguised to the reveal. Luna did notably better, it only let the stored XSS slip to the reveal, it caught everything else on its own, including the most disguised item in the whole test with a fix that went beyond what was asked, a unique index at the database level. Between the two, luna is clearly the more vigilant one, but neither justifies the higher price looking only at this metric.

### MiMo V2.6 Pro: The Generational Leap That Holds Up

From Xiaomi, the V2.6 Pro jumped from 86.5 to 92.0 over its own predecessor, the V2.5 Pro, for just **$1.22**. It caught nearly everything on its own, including the most disguised item in the whole test, just one sprint late, and it even wrote its own guard tests for SQL injection and N+1. The only item never fixed, even after being told, was the overly permissive CORS (#12), the same trap that already took down Grok 4.5, Gemini 3.7 Flash, and GLM 5.2 back in Part 2. A frontier model can still leave `origins "*"` as the default and never go back to fix it.

## What the External Benchmarks Say, and Where They Disagree With Me

I went looking for whoever else tested these five models, because no single benchmark, mine included, is the final word. Here's what I found, and where the reading matches or doesn't match mine.

- **Grok 4.7**: [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-grok-4-7) measures its Coding Agent Index rising from 47 to 56, improving on all three components it tests, but notes the model spends more than double the output tokens to get there. In other words, on a general coding-capability benchmark, 4.7 improves. On my test of vigilance under disguised sabotage, it gets worse. Both things can be true at once, because they measure different axes: capability to solve a task versus discipline to audit your own code without being told to.
- **Claude Opus 5.5**: [VentureBeat's](https://venturebeat.com/technology/anthropic-releases-claude-opus-5-5-beating-fable-5-1-on-key-agentic-benchmarks-at-60-cheaper-api-price) and [CodeRabbit's](https://www.coderabbit.ai/blog/opus-5-5-model-review) coverage matches what I found on this specific point: fewer tokens spent to finish the same task. And [Artificial Analysis](https://artificialanalysis.ai/articles/claude-opus-5-5) itself confirms the rest, the model took the top spot on its intelligence index, five points ahead of GPT-6 Astra and Fable 5.1. Here the outside reading confirms mine.
- **GPT 6 sol and luna**: coverage from [Vellum](https://www.vellum.ai/blog/gpt-6-sol-and-luna-benchmarks-explained) and [Kingy AI](https://kingy.ai/blog/gpt-6-sol-luna-specs-benchmarks-pricing-comparison/) paints a favorable picture of general capability, sol near Fable 5's top score for a fraction of the cost, luna in Opus 5's range. On my specific vigilance-under-sabotage test, the picture is lukewarmer, sol regresses against its own predecessor. Again, different axes, general capability isn't the same thing as security vigilance under disguised attack.
- **Xiaomi MiMo V2.6 Pro**: [VentureBeat](https://venturebeat.com/technology/better-than-deepseek-xiaomis-mimo-v2-6-pro-debuts-as-the-top-open-weights-model-in-the-world-alongside-cheaper-v2-6-flash) documents the same generational leap I saw, from 19 to 71.9 on DeepSWE, from 16 to 53.1 on AutomationBench. Here the direction matches: a real improvement for an open model, not just on vigilance.

> **Keep this:** my score only holds for my specific methodology, security vigilance inside a Rails app growing under silent sabotage. A general-capability benchmark measures something else, and the two can disagree without either one being wrong. An isolated ranking is never a final verdict on any model, [I already explained this more calmly in Part 2](/en/2026/09/15/new-llm-benchmark-v4-retesting-39-llms-part-2/#why-didnt-my-favorite-model-score-higher).

## Is It Worth Upgrading to the New Version?

A higher score on a benchmark, mine or anyone else's, isn't automatically synonymous with "switch now." Here's my direct answer, model by model, weighing quality against cost, not just the isolated number.

- **Do you use Grok 4.6 today?** Don't move to 4.7 for security. It's worse, more expensive, and slower on all three axes I measure. Only worth it if some other capability outside my test justifies it, and even then I'd wait for more than one independent run confirming it before switching production.
- **Do you use GPT 5.6 sol or terra?** No reason to move up to GPT 6 sol looking only at vigilance, you pay the same or more and get a worse score. If your interest is in GPT 6's other capabilities, test it yourself before assuming "newer" means "better for your case."
- **Do you use Opus 5?** This is the rare case where the answer is yes without reservation: Opus 5.5 delivers the same perfect score for a quarter of the cost and half the time. A gain on every axis I measure, at the same time.
- **Do you use MiMo V2.5 Pro?** Worth moving up to V2.6 Pro, the quality jump is real and the cost stays in the one-dollar range. Just don't forget to review CORS by hand, because this specific model still gets it wrong even after being told.

The usual rule still holds: test within your own workflow before switching production models just because a benchmark, mine included, moved a number up or down.

## Closing With an Irony I Didn't Manufacture

It's been eleven days since Dario Amodei published his essay calling to ["pace the frontier,"](https://darioamodei.com/post/we-must-pace-the-frontier) and Sam Altman and Elon Musk rushed to publicly agree the same week, as I've already [documented in detail](/en/2026/09/09/propagandas-enganosas-da-openai-anthropic-nvidia/). And what happened since? Exactly those three, Anthropic, OpenAI, and xAI, shipped Opus 5.5, GPT 6 sol and luna, and Grok 4.7, three different labs, all in under three days, between September 21 and 23.

I didn't write this coincidence, I just noticed it. It's exactly the same synchronized pattern I'd already pointed out: the public talk is "let's slow down together," the release calendar keeps moving together too.

There's another angle to this irony worth noting. Of the two companies that promised to slow down and still sped up their release, OpenAI and xAI, neither showed a clean win on this specific test: GPT 6 sol and Grok 4.7 regressed against their own predecessors, and GPT 6 luna came out technically tied while costing four and a half times more. Only Anthropic, the very author of the essay asking to pace the frontier, delivered a genuine improvement on every axis with Opus 5.5. Speeding up the release cadence and shipping a model that's equal or worse on this specific measure, on purpose? Who knows. I just noticed the pattern, again.

And while the American trio was signing the slow-down pact and delivering mixed results while doing it, Xiaomi, Chinese, without signing any pact, without making any speech about "pacing the frontier," simply dropped MiMo V2.6 Pro with a real quality leap over its own predecessor. Nobody on the Chinese side promised to slow down. And, at least in this sample, nobody on the Chinese side did.
