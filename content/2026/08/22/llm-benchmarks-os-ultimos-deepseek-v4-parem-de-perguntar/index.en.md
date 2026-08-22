---
title: "LLM Benchmarks: The latest Deepseek v4, stop asking"
slug: llm-benchmarks-the-latest-deepseek-v4-stop-asking
date: '2026-08-22T15:00:00-03:00'
draft: false
translationKey: llm-benchmarks-os-ultimos-deepseek-v4-parem-de-perguntar
description: "I ran the new Deepseek v4 snapshots through the benchmark: Flash jumped from 80 to 90 and Pro from 82 to 91, both Tier A, the cheapest in the pack. I still prefer Kimi K3 and GLM 5.3, and I explain why a close score does not mean an equivalent model."
tags:
- llm-benchmarks
- llms
- coding-agents
---

Last week I published the round with [Qwen 3.8, GLM 5.3, Gemini 3.7 and Grok 4.6](/en/2026/08/15/llm-benchmarks-qwen-3-8-glm-5-3-gemini-3-7/) on my v2 benchmark: the three-phase test (build, validate everything actually running, self-review with an honesty score) that production-hardens a Rails 8 LLM chat app. The top is unchanged: Fable 5 at 96, the trio Sonnet 5, Opus 5 and Kimi K3 at 95, GLM 5.3 alone at 94, and the 93 pack right behind.

And every single time I publish one of these updates, without exception, someone shows up in the comments: *"what about Deepseek?"*

I confess I do not understand this blind focus on Deepseek. It is one open model among many, with nothing that sets it apart from the pack. In my daily use, I still prefer Kimi K3 or GLM 5.3. Yes, every iteration improves a little. Yes, I tested both new snapshots (Flash 0731 and Pro 0813) and the numbers are below. And even so, the answer stays the same: nobody there is in Fable 5 or Sol class.

## What this score measures (and what it does not)

Before the numbers, the reminder that needs repeating every round. The benchmark tests a very specific slice: **easy** web programming. A Rails chat CRUD with streaming, tools, concurrency and tests. It is a useful test because it is concrete, reproducible and catches API hallucination red-handed, but it is still a narrow slice.

It says nothing about far more advanced tasks: kernel driver development, game engine optimization, real offensive security. Testing the entirety of a model is impossible. What you can test is a subset, and that is what I did.

So next time you read "Kimi is about to dethrone Fable" or "GLM is about to pass Sol" because the scores came out close, read it like this: within a narrow slice of web programming, any of these models delivers. That is all. A close score on this test means proximity **on this test**, nothing more.

> **Keep this:** a benchmark measures a slice. Mine measures easy Rails web apps. Anyone extrapolating that into "model X beats model Y at everything" is reading the number wrong.

## The Tier A ranking, with a focus on time

The usual table, A.1 cut (90 points or more), now with both Deepseeks in **bold**. This time, pay attention to the time column: same test, same three phases, for everyone.

| # | Model | Score | Harness | Time | Cost |
|---:|---|---:|---|---:|---:|
| 1 | Claude Fable 5 | 96 | Claude Code | 46 min | $26.03 |
| 2 | Claude Sonnet 5 | 95 | Claude Code | 59 min | $25.83 |
| 2 | Claude Opus 5 | 95 | Claude Code | 78 min | $38.91 |
| 2 | Kimi K3 | 95 | Kimi CLI | 65 min | $6.14 |
| 5 | GLM 5.3 | 94 | OpenCode | 80 min | $0 (≈$2.59) |
| 6 | GPT 5.6 Sol | 93 | Codex | 57 min | ~$45 |
| 6 | Claude Opus 4.8 | 93 | Claude Code | 53 min | $21.82 |
| 6 | GPT 5.6 Terra | 93 | Codex | 48 min | $16.92 |
| 6 | Gemini 3.7 Flash | 93 | OpenCode | 43 min | $4.12 |
| 10 | GLM 5.2 | 92 | OpenCode | 155 min | $0 (≈$12.05) |
| 10 | Kimi K2.5 | 92 | OpenCode | 43 min | $1.50 |
| 10 | Gemini 3.6 Flash @ high | 92 | Antigravity | 15 min | — |
| 10 | Qwen 3.8 Max | 92 | OpenCode | 78 min | $9.16 |
| 10 | Grok 4.6 | 92 | OpenCode | 34 min | $6.33 |
| 15 | MiniMax M3 | 91 | OpenCode | 113 min | $7.72 |
| 15 | Kimi K2.6 | 91 | OpenCode | 34 min | $2.64 |
| 15 | Claude Opus 4.7 | 91 | Claude Code | 44 min | $44.28 |
| 15 | GPT 5.6 Luna | 91 | Codex | 46 min | $16.79 |
| 15 | **Deepseek v4 Pro (0813)** | **91** | OpenCode | **82 min** | **$5.01** |
| 15 | Grok 4.5 | 91 | grok CLI | 25 min | $0 (≈$1.62) |
| 21 | **Deepseek v4 Flash (0731)** | **90** | OpenCode | **88 min** | **$0.82** |

*Time is the wall clock of the three phases; cost is the API equivalent. Same criteria as the previous articles, linked at the end.*

Look at the time spread. The fastest in the group finishes the test in 15 minutes; the slowest takes 155, **ten times longer**. Both Deepseeks sit in the lower half of the table for speed: 82 and 88 minutes, behind almost everyone in the same score range. The Flash, in particular, burned **44 million tokens** in one run. For comparison, GLM 5.3 scored one point higher with 19.4 million. Deepseek makes up for it on the invoice: the Flash's $0.82 is the cheapest Tier A run to date.

## The new snapshots: what changed since July

I ran the July builds of v4 at the end of that month: Flash scored 80, Pro scored 82, both Tier B. Both dated snapshots (0731 and 0813) ran today under the same rigor, and both entered Tier A:

**Flash 0731: from 80 to 90 (+10).** The most visible improvement is behavioral. The July build pinned a model three generations old; this one got the pin right on the first try (`anthropic/claude-sonnet-5`, no stale slug). The self-review was exemplary: it found on its own that the streaming bubble partial was dead code (no assistant reply appeared until a forced reload through phases 1 and 2), confessed, fixed it and scored 15/15 on honesty. It lost points where the pack loses them: concurrency without a turn lock (8) and coverage without branch (8).

**Pro 0813: from 82 to 91 (+9).** The big news is what disappeared: the `reasoning_content` bug that broke its multi-turn on OpenCode, and that forced me to invent the [deepclaude workaround](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/) back in May, was fixed in opencode 1.18.4, and this snapshot ran end to end on the generic harness, no crutches. The technical highlight was concurrency: a SQLite store with read-modify-write inside a `BEGIN IMMEDIATE` transaction, the most serious solution in the group on that dimension (9/10). The losses were honest and self-confessed: stale sonnet-4.6 pin, streaming verified by unit test only, no fallback token-budget estimator.

Clean, shielded runs, zero reads of the rubric or of anyone else's app. The full reports are in the [benchmark repository](https://github.com/akitaonrails/llm-coding-benchmark).

## Deepseek against itself: the trajectory is real

Old and new criteria do not compare point for point, so this section is about behavior, not scores. And behavior you can compare, because the contrast is stark.

In April, **DeepSeek V3.2** scored 43 under the old criteria and starred in the most embarrassing moment in the benchmark's history: it invented the entire RubyLLM integration. `RubyLLM::Client.new`, `client.chat(messages:)`, both methods hallucinated, the whole LLM layer fictional.

Still under the old criteria, **v4 Flash** scored 78 with a fatal one-character bug (the model slug missing the `anthropic/` prefix), and **v4 Pro** DNF'd at 69: Tier 1 code, Tier 3 deliverables, taken down by the `reasoning_content` bug that ate the conversation history. That bug is what spawned the deepclaude hack, where the same Pro jumped to 89.

On v2, the July builds scored 80 and 82. Today's snapshots, 90 and 91. From "invented the entire API" to "finds its own dead code and confesses it in self-review" in four months. Deepseek's curve is one of the steepest this benchmark has ever recorded, and pretending otherwise would be dishonest.

## And against the other Chinese models?

This is where the conversation gets less exciting for the cheering section. On the same generic harness (OpenCode), the Chinese pack looks like this:

| Model | Score | Time | Cost |
|---|---:|---:|---:|
| GLM 5.3 | 94 | 80 min | $0 (≈$2.59) |
| Qwen 3.8 Max | 92 | 78 min | $9.16 |
| Kimi K2.5 | 92 | 43 min | $1.50 |
| Deepseek v4 Pro (0813) | 91 | 82 min | $5.01 |
| Deepseek v4 Flash (0731) | 90 | 88 min | $0.82 |

And Kimi K3, absent from this table because it ran on its native harness, scored 95. In other words: within the same test, Deepseek v4 arrives behind GLM 5.3, Qwen 3.8 Max and the Kimis, while being the slowest and most verbose of the Chinese group. Its advantage is a single one, and it is real: price. $0.82 for a Tier A run is impressive, and the Pro at $5.01 undercuts almost everyone at the same score.

If your criterion is "maximum competence per dollar on simple web tasks", the Flash 0731 deserves attention. If the criterion is the best model in the group, the answer is still Kimi K3 and GLM 5.3, same as last week.

## Conclusion: stop asking

There, now there are numbers on the table. Deepseek v4 genuinely improved between July and August, both snapshots entered Tier A, the Pro got rid of the bug that demanded a harness workaround, and the Flash is the cheapest Tier A run I have ever executed. All of that is fact.

And none of it changes the picture. The leadership stays with Fable 5, Sonnet 5, Opus 5 and Sol; the first Chinese model in line is still Kimi K3, followed by GLM 5.3. Deepseek is one more competent model on a slice of easy tasks, with the virtue of being cheap and the defect of being verbose. Next time you feel the urge to comment "what about Deepseek?", the answer is this article.
