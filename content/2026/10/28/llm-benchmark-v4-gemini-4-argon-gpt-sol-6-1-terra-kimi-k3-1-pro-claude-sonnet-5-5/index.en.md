---
title: "LLM Benchmark v4: Gemini 4 Argon, GPT-6.1 Sol and Terra, Kimi K3.1 Pro, Claude Sonnet 5.5"
slug: llm-benchmark-v4-gemini-4-argon-gpt-6-1-sol-terra-kimi-k3-1-pro-claude-sonnet-5-5
date: '2026-10-28T10:00:00-03:00'
translationKey: llm-benchmark-v4-gemini-4-argon-gpt-sol-6-1-terra-kimi-k3-1-pro-claude-sonnet-5-5
description: "Argon, Sol 6.1, Terra, Kimi K3.1 Pro, and Sonnet 5.5 enter v4. Combining SWE-bench Pro and Terminal-Bench puts six leaders between 93.2 and 96.6."
tags:
- llm-benchmarks
- llms
- coding-agents
- ai-memory
draft: false
---

I spent the last few weeks talking quite a bit about open source LLMs, local hardware, B300s, the RTX 5090, Qwen, and Basalt. Meanwhile, the commercial labs kept shipping new models as if nobody needed sleep.

The [last commercial ranking update](/en/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/) added Opus 5.5, GPT 6 Sol and Luna, MiMo 2.6 Pro, and Grok 4.7. The pattern was already showing: new releases were improving mostly on cost and speed. Quality had become a fight over a few points, with models from the same family swapping positions from one run to the next.

Now **Gemini 4 Argon, GPT-6.1 Sol, GPT-6.1 Terra, Kimi K3.1 Pro, and Claude Sonnet 5.5** have joined the ranking. All five landed in Tier A.

I suspect this will be my last commercial ranking update, or close to it. The models have become too similar.

## A Reminder of What This Benchmark Measures

The [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark) does not attempt to measure "general intelligence." V4 has each agent develop a Rails system over seven sprints. Along the way, I plant 14 silent sabotages: authorization failures, XSS, SQL injection, a hard-coded secret, open CORS, a removed index, and a test altered to accept unsafe behavior.

When the model finds and fixes one by itself, it gets the item's full weight. A fix made only after the sabotage is revealed gets 40%. Anything still unresolved gets zero. The final score is normalized to 100.

This is a narrow measure of **vigilance during long-horizon agentic programming**. It does not measure whether the model writes the best prose, solves math, understands tax law, designs a beautiful interface, or debugs firmware. It does not even measure everything that matters in programming.

No benchmark can do that, including the popular ones. Models in this class may have billions of parameters, and the combinations of prompt, context, tools, harness, temperature, and prior conversation state grow far beyond anything a test suite can exercise. You would have to test practically everything that could go into and come out of the model. Impossible.

Arguing whether benchmark A is "better" than benchmark B usually starts with the wrong question. Each one lights up a tiny surface. LeetCode-style tests and [HumanEval](https://arxiv.org/abs/2107.03374) measure short, well-defined problem solving. SWE-bench measures the ability to resolve issues in existing repositories.

Mine follows a project growing over several hours, carrying accumulated context and earlier decisions, with planted defects that simulate the sort of mess left behind by another programmer, another team, a dependency, or the agent itself.

That resembles the programming I actually do, but it remains **my slice of the problem**. Anyone who needs a model to pass every conceivable LeetCode-style hiring test should build a suite for that. A great score on those exercises still says nothing about whether the agent can maintain a project for seven sprints, notice broken authorization, and refuse to accept a doctored test.

You need to test your own use case, with your code, constraints, and failure criteria. That is why I made the [entire framework open source](https://github.com/akitaonrails/llm-coding-benchmark): anyone can replace the application, prompts, sabotages, weights, and harness. The ranking published here answers my questions. Use the framework to answer yours.

There is more. I ran the same GPT 5.5, through the same harness and test, and got 100 in one run and 91 in another. That nine-point difference came from single-sample variance alone. LLMs generate probabilistic answers. Two models separated by two or three points are, for all practical purposes, in the same neighborhood.

> **Read Tier A as a band of competent models, not an Olympic podium.** First place in this table did not automatically become the best model in the world.

## Updated Commercial Ranking

To avoid mixing a local GPU, a rented pod, and an API, the table below includes only models I tested through a managed route: subscription, API, OAuth, or a commercial plan. Some have open weights, including Kimi and GLM, but these runs used the vendor's service.

Models from this round are in **bold**. I kept Tier A only, because that is where the serious daily-work choices live.

| Model | Score | Run cost | Time | Harness |
|---|---:|---:|---:|---|
| **Gemini 4 Argon (high)** | **100.0** | **$0 marginal (OAuth)** | **114 min** | Antigravity |
| GPT-6 Astra | 100.0 | $30.55 | 100 min | Codex |
| Claude Opus 5 | 100.0 | ~$71 | 145 min | Claude Code |
| Claude Fable 5 | 100.0 | ~$50 | ~85 min | Claude Code |
| Claude Opus 5.5 | 100.0 | $16.63 | 64 min | Claude Code |
| GPT 5.6 Sol | 100.0 | $20.37 | 317 min | Codex |
| GPT 5.6 Terra | 100.0 | $9.52 | 80 min | Codex |
| GPT 5.5 | 100.0 | $34.69 | 117 min | Codex |
| Grok 4.6 | 98.5 | $13.00 | 67 min | OpenCode |
| **GPT-6.1 Sol** | **97.0** | **~$8.12** | **65 min** | Codex |
| **GPT-6.1 Terra** | **96.8** | **~$1.69** | **21 min** | Codex |
| Claude Fable 5.1 | 95.5 | ~$51 | 133 min | Claude Code |
| Sakana Fugu Ultra v2 | 95.5 | $122.01 | 294 min | OpenCode |
| GPT 6 Luna | 95.5 | ~$0.84 | 122 min | Codex |
| GPT 5.6 Luna | 95.0 | $10.04 | 123 min | Codex |
| Nex N2.5 Pro | 94.0* | free | 480 min | OpenCode |
| GLM 5.3 | 94.0 | flat-rate plan | 215 min | zcode |
| DeepSeek V4.1 Flash | 92.5 | $1.21 | 172 min | OpenCode |
| **Kimi K3.1 Pro** | **92.11** | **~$12.67** | **110 min** | Kimi CLI |
| MiMo V2.6 Pro | 92.0 | $1.22 | 308 min | OpenCode |
| Claude Sonnet 5 | 91.0 | ~$27 | 112 min | Claude Code |
| GPT 6 Sol | 91.0 | ~$8.35 | 73 min | Codex |
| Gemini 3.8 Flash (OpenRouter) | 90.5 | $15.98 | 97 min | OpenCode |
| Gemini 3.8 Flash (Antigravity) | 89.5 | $0 marginal (OAuth) | 120 min | Antigravity |
| Muse Spark 1.3 | 88.75 | $13.31 | 150 min | OpenCode |
| **Claude Sonnet 5.5** | **88.0** | **~$3.90** | **27 min** | Claude Code |
| Grok 4.5 | 88.0 | $6.19 | 48 min | OpenCode |
| Claude Opus 4.6 | 87.5 | $25.64 | 89 min | Claude Code |
| Kimi K2.7 | 87.25 | $7.75 | 175 min | Kimi CLI |
| MiMo V2.5 Pro | 86.5 | $1.03 | 158 min | OpenCode |
| Qwen3.8 Flash | 86.5 | $1.17 | 149 min | OpenCode |
| DeepSeek V4 Flash | 86.0 | $0.97 | 111 min | OpenCode |
| Claude Opus 4.8 | 86.0 | ~$37 | 87 min | Claude Code |
| Claude Sonnet 4.6 | 85.75 | $18.64 | 91 min | Claude Code |
| Kimi K3 | 85.0 | $13.79 | 148 min | Kimi CLI |
| DeepSeek V4 Flash 0731 | 85.0 | $1.94 | 194 min | OpenCode |
| GLM 5.3 Flash | 84.25 | flat-rate plan | 296 min | zcode |
| DeepSeek V4 Pro 0813 | 84.0 | $4.49 | 152 min | OpenCode |
| Step 3.7 Flash | 83.75 | $4.15 | 118 min | OpenCode |
| Grok 4.7 | 83.5 | $27.94 | 120 min | OpenCode |
| Genesys PI House | 83.5 | ~$460 | 68 min | OpenCode |

Costs marked with `~` are equivalents calculated from token counts and public pricing, not the bill I received. Claude Code and Codex run through subscriptions; Antigravity uses OAuth; zcode charges a flat-rate plan. Compare cost carefully, especially across different harnesses.

Terra and Kimi had item #8 marked not applicable because the exact state of that test did not permit a fair evaluation. Their denominator became 38 instead of 40, and the score was normalized. Nex retains its old caveat: it found the problems but left the work uncommitted.

## What Each Model Showed

### Gemini 4 Argon: It Finally Reached the Top

Argon was the only model in this batch to catch all 14 sabotages before the reveal: **40 out of 40, score 100**. This was the result Gemini needed to join the conversation about the best coding agents without an asterisk.

The [official Gemini 4 Argon announcement](https://blog.google/intl/en-mena/product-updates/explore-get-answers/gemini-4-argon-built-to-solve-your-hardest-problems/) positions it for difficult problems and makes it available through Antigravity and the API. Introductory API pricing is $2 per million input tokens and $10 for output; after November 30, that rises to $4 and $20.

I used Antigravity through the subscription, so the marginal cost was zero. It took 114 minutes and solved everything without waiting for me to point at the bombs.

### GPT-6.1 Sol: Nearly Perfect, No Waste

Sol scored **97.0**. It found 13 of the 14 sabotages on its own and fixed the last one after the reveal. The run took 65 minutes, practically the same as Opus 5.5 and far less than the old GPT 5.6 Sol's 317 minutes.

According to [OpenAI's official pricing](https://developers.openai.com/api/docs/changelog?mw_entry=2026-10-20-c57e1ddc3363933d), it costs $2 per million input tokens and $10 for output. Applied to the run's token counts, that comes to an equivalent cost of about $8.12.

It did not score 100. There is also no demonstrated practical difference between 97 and 100 in a methodology where the same model has already swung by nine points. The useful result is that Sol remains strong and has become fast.

### GPT-6.1 Terra: The Most Interesting Balance of Cost, Speed, and Quality

Terra finished at **96.8**, practically tied with Sol, in **21 minutes**. The equivalent cost was just **$1.69**.

The [official GPT-6.1 Terra page](https://developers.openai.com/api/docs/models/gpt-6.1-terra) lists $1 per million input tokens and $5 for output, half Sol's price. It also offers a 1.05-million-token context window, although requests above 272,000 tokens carry a pricing multiplier.

On one item, Terra noticed part of the problem by itself but completed the fix only after the reveal. That cost it the few missing points. Looking at what matters for actual work, **Terra is the strongest result from this round**: quality in Sol's neighborhood, three times faster, and about five times cheaper in this run.

### Kimi K3.1 Pro: Competitive, but It Needs to Move Faster

Kimi K3.1 Pro scored **92.11**, with no sabotage left unresolved at the end. Two groups of problems were closed only after the reveal. The downside was time: **110 minutes**, nearly five times Terra's run, with an equivalent cost of **$12.67**.

[K3.1 Pro](https://www.kimi.com/en/blog/kimi-k3-1-pro) has a context window of up to 1 million tokens and will be released with open weights. Kimi also offers a Highspeed route advertised as two to three times faster in exchange for higher pricing and quota consumption. The [public pricing table](https://www.kimi.com/resources/kimi-k3-1-pro-pricing) charges ¥13 per million input tokens and ¥68 for output on the regular route; Highspeed doubles those prices.

I like Kimi and use it every day. The score confirms that it belongs in the competent group. Latency is now the bottleneck. A good model that makes me wait almost two hours for the same campaign Terra completed in 21 minutes loses practical value.

### Claude Sonnet 5.5: The Score Alone Tells the Wrong Story

Sonnet 5.5 scored **88.0**. It caught most items by itself, resolved a few more after the reveal, and failed to finish one compound sabotage: it closed the vulnerability but left a doctored guard test containing `assert true`. That detail is exactly what my benchmark is designed to catch. The system may be fixed today, but a useless test leaves the door open for a regression tomorrow.

At the same time, it completed the whole run in **27 minutes**, with an equivalent cost of **$3.90**. [Anthropic positions Sonnet 5.5](https://www.anthropic.com/claude-sonnet-5-5) as its everyday-work model, reserving Opus for harder decisions. Pricing is $2 per million input tokens and $10 for output, and the company says generation is more than 30% faster than Sonnet 5.

So no, an 88 does not make Sonnet a bad model. It remains Tier A, runs fast, and costs little. The concrete gotcha from this run is that I would still ask Opus, Fable, or another strong model for a second pass on authorization reviews, security tests, and delicate changes.

## The Most Expensive Model Does Not Need to Run All Day

This round reinforced an important change in habit. For most work, I no longer need to keep the heaviest and most expensive model running all day.

CRUD, refactoring, tests, documentation, ordinary front-end work, API integrations, database migrations: Sonnet 5.5 and GPT-6.1 Terra can handle them. I would move up to Opus, Fable, Sol, or Astra when the problem justifies it: kernel-driver debugging, particularly treacherous concurrency, firmware, delicate embedded-system tuning, or a security incident where one missed detail costs real money.

Using Fable to change a button color is like firing up an excavator to plant basil. It works. Burning quota on it makes no sense.

Even open source models have come close. In my [recent Qwen3.8 Flash-Next test on a single RTX 5090](/en/2026/10/27/llm-benchmark-best-open-source-llms-for-home-hardware/), Q2_0 scored 100 in all six hard-test runs, three on Strata and three on Basalt. With Basalt, output reached 400 tokens per second while also using system RAM for the experts.

That test is considerably easier than v4, so the scores cannot be mixed. Even on full v4, though, a local Qwen has already reached the Tier A neighborhood. The distance is no longer an abyss.

## The Bottleneck Has Moved: Speed and Quotas

I use the top models every day and have switched among them in the same project for weeks. Claude in the morning, Codex later, Kimi when a quota gets tight, Gemini sometimes. I have yet to find a measurable advantage in staying loyal to one vendor.

What I notice immediately is **speed**. GLM 5.3 and DeepSeek V4.1 are good, but they feel slow next to Terra or Sonnet. Once you get used to fast responses, waiting for the agent to think and edit becomes the irritating part of the job.

The other limit is quota. Five-hour windows and weekly or monthly limits vary by vendor and plan, but the practical result is the same: my weekly quota rarely lasts a whole week. Fable and Astra drain the reserve even faster. I switch because I have to, not because I collect logos in my terminal.

That is exactly why I created [ai-memory](https://aimemory.sh). Project memory should not belong to Claude, Codex, Kimi, or Gemini. With `ai-memory run`, I can continue the same line of work in another harness without a manual handoff, and consolidated decisions survive context compaction.

> **Models and harnesses are rented. The session, decisions, and project memory need to remain yours.**

I covered the architecture and open format in the [ai-memory 2.0 article](/en/2026/09/02/ai-memory-2-0-best-memory-system-for-agents-and-teams/). The more interchangeable the models become, the more important frictionless switching gets.

## What About the Famous Benchmarks?

Keep an eye on [SWE-bench](https://www.swebench.com/), which uses real issues from GitHub projects, and [Terminal-Bench](https://www.tbench.ai/), which measures agents completing tasks in a terminal. They help expose regressions, improvements in tool use, and edge cases where a model family still struggles.

Just do not confuse them with your job. SWE-bench Verified has 500 selected problems. Terminal-Bench v4 has dozens of difficult, reviewed tasks. Neither one knows what your monorepo looks like, the quality of your tests and documentation, your company's internal library, or that legacy API nobody dares touch.

My benchmark does not know either.

If you need a model for a very specific constraint, build your own test with real examples. Otherwise, choose any Tier A model, use it for a week, and get back to work.

## What About This GLM 5.5?

There is a rumor going around about "GLM 5.5 coming soon." As of today, October 28, **there is no official announcement with that name, date, or price**. [Z.ai's official release page](https://docs.z.ai/release-notes/new-released) still lists the GLM 5.3 family as its latest.

Jie Tang, Z.ai's founder, replied *"won't take that long"* when Elon Musk estimated that China would reach Fable-level models in the first quarter of 2027. That suggests he expects the capability sooner, but it does not promise a Z.ai release, much less a model called GLM 5.5 by December. I am not turning a rumor into a ranking row.

Kimi K3.1 Pro is already in Tier A. Qwen and GLM can already fit on owned hardware through quantization. Gemini has finally caught the leaders.

Sonnet and Terra handle everyday work for much less. Competition is compressing everything into the same range.

## Commoditized. Good.

I no longer expect enormous jumps from every commercial release. I expect a model to get somewhat faster, cheaper, more token-efficient, with a better quota and a few edge cases fixed. That is what a maturing market looks like.

My advice today differs from what I would have said a few months ago:

1. Pick any Tier A model that fits your plan.
2. Use Sonnet or Terra for ordinary work.
3. Save Opus, Fable, Sol, or Astra for problems that deserve them.
4. Keep a second option for when the quota runs out.
5. Install [ai-memory](https://aimemory.sh) so no harness owns your history.
6. Stop following rankings like a sports league.

Benchmarks remain useful for detecting when a family reaches the top group, as Argon just did. After that, the difference between first, fourth, and tenth place becomes too small, noisy, and task-dependent.

Frontier LLMs have become commodities. You are not missing a revolution because you went a week without trying Tuesday's release. Pick a good one, keep your options open, and get back to programming.

## A Broader Ranking: Engineering Breadth Index

After finishing this article, I found a better question. What happens when I combine my result with benchmarks that measure other parts of the job?

I built a secondary index from four surfaces:

| Weight | Benchmark | What It Measures |
|---:|---|---|
| 35% | [SWE-bench Pro V2](https://labs.scale.com/leaderboard/swe_bench_pro_public_v2?tab=full) | Resolving issues in professional repositories without introducing regressions |
| 30% | llm-coding-benchmark v4 | A long project, accumulated context, vigilance, and sabotage |
| 25% | [Terminal-Bench 4.0](https://www.vals.ai/benchmarks/terminal-bench-4) | Terminal tasks graded by challenge-specific verifiers |
| 10% | [LiveCodeBench v6](https://livecodebench.github.io/leaderboard.html) | Short, well-defined algorithmic problems |

The raw percentages cannot be added. Terminal-Bench 4.0's leader scores 65.15; several models scored 100 on mine. I first normalized every result against the best score published by that benchmark in the snapshot:

```text
normalized score = 100 × model score / best benchmark score
```

Then I applied a weighted geometric mean. It penalizes a model with a major weakness in one dimension instead of letting one perfect score hide the hole.

```text
index = 100 × exp(
  0.35 × ln(SWE Pro) +
  0.30 × ln(Akita v4) +
  0.25 × ln(Terminal-Bench) +
  0.10 × ln(LiveCodeBench)
)
```

Each component enters the formula as a number from zero to one. The index measures capability. Price, duration, tok/s, and quotas stay out and belong in a separate practicality table. Mixing quality with dollars would let a weak, cheap model look technically stronger.

### Results as of October 28, 2026

The first honest limitation showed up immediately. As of October 28, the official LiveCodeBench v6 leaderboard still had no results for this model generation. **A complete official four-dimensional ranking does not exist today.**

I calculated a provisional index from the other three benchmarks, covering 90% of the original weight. I used the October 28 SWE-bench Pro V2 snapshot and the October 26 Terminal-Bench 4.0 update. The available weights were renormalized to 38.89% for SWE-bench Pro V2, 33.33% for my v4, and 27.78% for Terminal-Bench 4.0. Only models with an exact result in all three qualified. Kimi K3 does not stand in for K3.1, and GPT-5.6 Terra does not stand in for 6.1 Terra.

### Provisional Ranking

| # | Model | Akita v4 | SWE Pro V2 | Terminal 4.0 | SWE Pro Harness | Coverage | Index |
|---:|---|---:|---:|---:|---|---:|---:|
| 1 | GPT-6 Astra | 100.0 | 96.90 | 59.60 | Codex | 90% | **96.6** |
| 2 | Gemini 4 Argon | 100.0 | 99.22 | 57.58 | mini-SWE-agent | 90% | **96.6** |
| 3 | Claude Fable 5.1 | 95.5 | 99.10 | 58.08 | Claude Code | 90% | **95.3** |
| 4 | Claude Opus 5 | 100.0 | 99.40 | 53.53 | Claude Code | 90% | **94.7** |
| 5 | Claude Sonnet 5.5 | 88.0 | 95.79 | 64.14 | mini-SWE-agent | 90% | **94.1** |
| 6 | GPT-6.1 Sol | 97.0 | 96.11 | 55.05 | mini-SWE-agent | 90% | **93.2** |
| 7 | GPT-5.6 Sol | 100.0 | 95.50 | 37.88 | Codex | 90% | **84.7** |
| 8 | GLM 5.3 | 94.0 | 95.60 | 38.89 | mini-SWE-agent | 90% | **83.6** |
| 9 | GPT-5.6 Terra | 100.0 | 92.37 | 22.73 | Codex | 90% | **72.5** |
| 10 | Gemini 3.8 Flash | 89.5 | 94.86 | 19.70 | mini-SWE-agent | 90% | **67.9** |
| 11 | Kimi K3 | 85.0 | 97.70 | 17.17 | mini-SWE-agent | 90% | **65.0** |
| 12 | Claude Sonnet 5 | 91.0 | 93.15 | 10.61 | Claude Code | 90% | **57.1** |
| 13 | Muse Spark Open | 69.5 | 95.02 | 6.57 | mini-SWE-agent | 90% | **46.0** |

Terminal-Bench 4.0 uses mini-SWE-agent for every row. SWE-bench Pro V2 mixes mini-SWE-agent with the native harnesses shown in the table. In my v4, each row keeps the route documented for that run. Gemini 3.8 Flash is the Antigravity run; Muse Spark Open ran self-hosted on four B300s through OpenCode.

This ranks **models under the conditions published by each benchmark**, with real harness influence. It does not scientifically isolate model weights alone.

### Why the List Stops at 13

I wanted at least 20 models, but the honest intersection ends here. SWE-bench Pro V2 publishes 16 results. Only 13 of them have the exact same model tested on Terminal-Bench 4.0 and my v4. The next candidates all hit a gap:

| Model | Akita v4 | SWE Pro V2 | Terminal 4.0 | Missing Result |
|---|---:|---:|---:|---|
| Claude Opus 5.5 | 100.0 | n/a | 65.15 | SWE Pro V2 |
| Kimi K3.1 Pro | 92.11 | n/a | 63.64 | SWE Pro V2 |
| GPT-6.1 Terra | 96.8 | n/a | 49.49 | SWE Pro V2 |
| Claude Fable 5 | 100.0 | n/a | 41.41 | SWE Pro V2 |
| GPT-6 Sol | 91.0 | n/a | 44.44 | SWE Pro V2 |
| DeepSeek V4.1 Flash 1017 (B300) | 92.5 | n/a | 31.82 | SWE Pro V2 |
| GLM 5.3 Flash | 84.25 | n/a | 37.37 | SWE Pro V2 |
| Claude Haiku 5.5 | n/a | 87.23 | 36.36 | Akita v4 |
| Inkling | n/a | 89.88 | 0.51 | Akita v4 |

I could renormalize two scores and manufacture positions 14 through 22. The result would look neat and mislead readers. A model measured only on my v4 and Terminal-Bench would cover 55% of the original index; one measured on SWE Pro and Terminal would cover 60%. Sorting both as if they had taken the same exam would turn missing data into false precision.

I will not use Kimi K3 in place of K3.1, GPT-5.6 Terra in place of 6.1 Terra, or any older relative from the same family to fill a hole either. The index can grow when those results are published or I run the missing models. Until then, 13 is the defensible limit.

### What Changed When We Widened the Lens

Astra finished 0.036 points ahead of Argon before rounding: 96.5955 versus 96.5591. Both appear as 96.6 in the table and amount to a practical tie. Fable 5.1, Opus 5, Sonnet 5.5, and Sol 6.1 followed close behind. Differences below three points belong in the same practical band, especially when combining benchmarks with different confidence intervals and harnesses.

Sonnet 5.5 is the interesting case. It scored only 88 on my test but reached 64.14 on Terminal-Bench, almost the current ceiling. The broader index pulled it up to 94.1. GPT-5.6 Sol shows the reverse: 100 on my test and only 37.88 on Terminal-Bench, finishing at 84.7.

That is why combining surfaces helps. A benchmark sees what it was designed to see. Three benchmarks remain far from measuring everything, but they make it harder for one narrow specialty to masquerade as general competence.

The earlier conclusion still holds. The top six are compressed between 93.2 and 96.6. We widened the lens, and the supposed absolute champion still failed to appear.

## Conclusion: Pick a Good One and Get to Work

The composite index reinforced this article's thesis. Widening the test changes the order, exposes a few weaknesses, and still leaves the leading group tightly packed. Astra and Argon finished 0.036 points apart. Four other models finished within 3.5 points. Change the weights, the task set, or the benchmark version, and they may trade places again.

That makes the decision much simpler. First identify which models have reached a competent range for your kind of work. Then choose based on speed, price, quotas, privacy, availability, and harness quality. Those differences affect your entire day. One extra point in a table rarely does.

Benchmarks remain useful for detecting regressions, spotting when a family reaches Tier A, and finding blind spots. Turning a ranking into a sports rivalry or treating this week's leader as a universal truth is a waste of time.

Today I switch among the best models without ceremony. The project, tests, Git history, and session memory must survive the switch. That is why I keep insisting on [ai-memory](https://aimemory.sh): the valuable asset is the history of the work, not the provider renting you a context window. Pick any competent model, keep an exit route, and get back to solving real problems.
