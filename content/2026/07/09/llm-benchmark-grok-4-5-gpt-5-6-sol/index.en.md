---
title: "LLM Benchmarks: Grok 4.5 and GPT 5.6 Sol"
slug: "llm-benchmark-grok-4-5-gpt-5-6-sol"
date: '2026-07-09T15:00:00-03:00'
draft: false
translationKey: llm-benchmark-grok-4-5-gpt-5-6-sol
tags:
  - llm
  - benchmark
  - grok
  - gpt
  - openai
  - pricing
  - ai
  - vibecoding
---

Another round of my coding benchmark. In the [previous post](/en/2026/07/01/llm-benchmark-sonnet-5-fails-gemini-flash-surprises-sakana-fugu-almost-tier-a/), Sonnet 5 showed up with a big name and finished at 58/100 Tier C (hype doesn't compile), while Gemini 3.5 Flash surprised everyone with 93/100 Tier A and Sakana Fugu Ultra stalled right at the Tier B ceiling. The practical recommendation stayed the same as always: for serious work, Opus or GPT via Claude Code, Codex, or OpenCode.

This time there are two new names and a tremor at the top of the table. **Grok 4.5** finally pulled the Grok family into Tier A, and **GPT 5.6 Sol**, OpenAI's new generation, made its debut. But the most uncomfortable result wasn't from either of them: it was a **re-audit** that dropped GPT 5.5 from 96 to 85 and GPT 5.4 from 97 to 95. I'll explain in a bit.

## For anyone who just parachuted in

This benchmark hands each model the same prompt and asks it to build, on its own, a ChatGPT-style chat app in Rails 8 + RubyLLM + Hotwire + Docker, with tests and CI. The score comes out of an 8-dimension rubric, 0 to 100, in A/B/C/D tiers. Everything is read by hand, and for several rounds now each project also goes through a **blind cross-audit** (an independent judge re-scores it without knowing which model wrote it). The full methodology is in [Part 3](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) and the follow-up updates.

## Updated ranking

The two new ones in bold. Notice the costs changed a lot, and I'll come back to that in the pricing section:

| Rank | Model | Score | Tier | RubyLLM OK | Time | Cost |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$7.00 |
| 2 | GPT 5.4 xHigh (Codex) | 95 | A | ✅ | 22m | ~$16 |
| 2 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$6.40 |
| 4 | Claude Fable 5 | 94 | A | ✅ | 24m | ~$11.20 |
| 5 | Claude Fable 5 (re-release) | 93 | A | ✅ | 18m | ~$8.30 |
| 5 | Gemini 3.5 Flash | 93 | A | ✅ | 18m | ~$3.55 |
| **7** | **GPT 5.6 Sol xHigh (Codex)** | **92** | **A** | ✅ | **17m** | **credits (~$8.70 API-equiv.)** |
| 8 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$1.00 |
| 8 | GLM 5.2 (Z.ai) | 87 | A | ✅ | 43m | subscription |
| **8** | **Grok 4.5** | **87** | **A** | ✅ | **16m** | **~$5.10** |
| 11 | Kimi K2.7 Code | 86 | A | ✅ | 22m | ~$1.15 |
| 12 | GPT 5.5 xHigh (Codex) | 85 | A | ✅ | 18m | ~$10 |
| 13 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 (hist.) |
| 13 | Nex-N2-Pro | 83 | A | ✅ | 25m | ~$0.34 |
| 15 | Gemini 3.1 Pro | 79 | B | ✅ | 14m | ~$3.10 |
| 15 | Sakana Fugu Ultra | 79 | B | ✅ | 22m | subscription |
| 17 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 (hist.) |
| 17 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 17 | MiniMax M3 | 78 | B | ✅ | 53m (phase 2 DNF) | ~$1.25 |
| 17 | Qwen3.7 Max | 78 | B | ✅ | 19m | ~$1.40 |
| 21 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.70 |
| ... | *(B/C/D tail omitted)* | | | | | |
| 28 | Claude Sonnet 5 | 58 | C | ❌ | 27m | ~$2.25 |
| 38 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.70 |

The full table, with all 39 models, is in the [benchmark repository](https://github.com/akitaonrails/llm-coding-benchmark).

About the cost column: it's the approximate per-run token spend at rates verified on 2026-07-09. Where you see **`(hist.)`**, it's the figure from the day that model ran, still without re-counting cache-read tokens, so it's undercounted (exactly the mistake I fix in the pricing section below). You can't compare a "(hist.)" number against an updated one.

## Grok 4.5: the Grok family finally reaches Tier A

xAI's trajectory in this benchmark is one of the most satisfying to watch. Grok 4.20 scored 25/100 Tier D. Grok 4.3 climbed to 72/100 Tier B. And now **Grok 4.5 hits 87/100, Tier A**. It fixes the three failures that held 4.3 back: Stimulus is now alive (4.3 shipped a one-line comment and the whole UI was dead), the tests can't bypass the stub anymore (real dependency injection in `LlmClient`), and the model pin is the current Sonnet 4.6, not the stale `claude-3.7-sonnet`. The RubyLLM integration is all correct, verified against the gem source, with real Turbo Streams, a capped session cookie, and 28 tests covering the error paths. Genuinely solid engineering.

What holds it in the 87 cluster is a subtle bug only the blind cross-audit caught, and it's the kind that fascinates me: the **double-send**. The controller appends the user's message to the session **before** calling the service, and `previous_messages` only filters system messages. Result: the history replay already contains the new message, and `chat.ask(user_message)` then sends it **again**. Every user turn reaches the LLM twice. Token waste and a subtly corrupted conversation. And the service test builds the history *without* the pending message, a different precondition than production, which is why the suite stays green while the bug slips through. It's the kind of defect green tests don't catch and that only shows up in front of the user.

At ~$5.10 per run in 16 minutes, Grok 4.5 is the second-priciest Tier A run. Hold that number, because in the pricing section it lands in an awkward spot.

## GPT 5.6 Sol: OpenAI's new generation, running on the subscription

**GPT 5.6 Sol** (the name is part of OpenAI's new Sol/Terra/Luna naming, with public release delayed by a US government review) scored **92/100, Tier A**. And it brought two firsts to the benchmark.

The first: it was the **first run billed against a subscription**. I ran it via Codex CLI, on the ChatGPT plan, using the subscription credits instead of paying API directly. From the token log you can compute the API equivalent: about **$8.70** at Sol's verified rate ($5/$30 per million). The second: it was the most token-frugal GPT I've measured, 3.9M total tokens against 5.5's 4.9M and 5.4's 7.6M. Fewer tokens to do the same thing.

The engineering is exemplary. A missing-key preflight, layered rescues that never leak error detail (and that's *tested*), failed turns kept out of history, malformed-history recovery, and an XSS helper with escape-before-format and a **`<script>` regression test**. 28 tests, 99.2% coverage. And crucially, it gets right what Grok 4.5 got wrong: the responder is called *before* the user message enters the history, and its own test guarantees the separation that would catch a double-send. On top of that, it pins `anthropic/claude-sonnet-5`, the most current Sonnet pin in the whole benchmark.

Why 92 and not higher? Two honest deductions. It doesn't send a system prompt via `with_instructions` anywhere (the assistant ships with no persona or guardrails, the same gap as Kimi K2.7), and persistence is client-carried history via a hidden field: rigorously capped, but lost on reload and client-tamperable. In the blind A/B against its predecessor GPT 5.5, it was decisive: **92 to 81**. And that matchup is what kicked over the hornet's nest of the re-audit.

## The re-audit: GPT 5.5 dropped from 96 to 85

This is the part that stings. When the blind judge compared Sol against GPT 5.5, it flagged defects in the 5.5 project that the original audit had let slip. I went and verified by hand, and it was true: 5.5's Dockerfile is a development image (`RAILS_ENV=development`, running as root, `CMD ./bin/dev`), it has **zero test coverage on the error path**, and the cookie has no byte cap. Re-audited, GPT 5.5 fell from 96 to **85/100, sliding to #12**. GPT 5.4 also took an adjustment, from 97 to 95, but it holds up better because its error paths *are* tested.

The table consequence is that **Claude Opus 4.7 is now the sole benchmark leader**, at 97. And the methodological lesson is on the record: my pre-Sol audits underweighted Dockerfile inspection. This is exactly why I insist on reading by hand and cross-checking with an independent judge. A pretty score on green CI isn't a real score.

## How the two compare to Fable 5 and the best open source model

Putting the relevant part side by side: **Fable 5** (the top of the publicly available Claude line) scored 94, and its re-release scored 93. The **best open source model** in the table today is a tie at 87 between **Kimi K2.6** and **GLM 5.2**, followed closely by Kimi K2.7 Code at 86.

GPT 5.6 Sol, at 92, sits **between** Fable 5 and the best open source, and closer to Fable. It's genuinely strong, the 2-point gap to Fable is noise, and it's more token-frugal than any previous GPT. Grok 4.5, at 87, **ties exactly with the open source ceiling**. And here the comparison turns cruel: Grok 4.5 delivers the same score as Kimi K2.6 at five times the cost (~$5.10 vs ~$1.00). In the blind A/B against Fable 5, Grok lost 84 to 90, decisively. So the Grok family finally reached Tier A, which is a real milestone, but it reached the *bottom* of Tier A, the same spot open Chinese models occupy at a fraction of the price.

The takeaway that repeats every round: reaching Tier A is what matters (below it the model isn't cheaper, it just moves the cost from the API invoice to your engineer's calendar). But *within* Tier A, price and quality decide, and that's where Grok 4.5 trips.

## Pricing: the math changed since the last post

This round came bundled with a full pricing audit in the repo, and it touched numbers I'd been reporting wrong. Worth correcting publicly.

The bigger mistake was **undercounting cache-read tokens**. An agentic run is dominated by cache reads (5 to 15 million cache-read tokens per run), and my old estimates for Anthropic and Google models ignored that. The price didn't go up; my math was off. The values corrected upward:

| Model | I was reporting | Real cost per run |
|---|---:|---:|
| Opus 4.7 | ~$1.10 | **~$7.00** |
| Opus 4.8 | ~$1.10 | **~$6.40** |
| Gemini 3.1 Pro | ~$0.40 | **~$3.10** |

On top of that, Nex-N2-Pro's free endpoint stopped existing (the same run costs ~$0.34 today, still the cheapest Tier A), and Kimi K2.6's rates rose about 30% since its run, to ~$1.00.

With the right numbers, you can draw the **value frontier** of Tier A: for each price band, what's the highest score the money buys. Every line here is a rational choice, because it pays more and delivers more:

| Cost per run | Best model | Score |
|---:|---|---:|
| ~$0.34 | Nex-N2-Pro | 83 |
| ~$1.00 | Kimi K2.6 | 87 |
| ~$3.55 | Gemini 3.5 Flash | 93 |
| ~$6.40 | Opus 4.8 | 95 |
| ~$7.00 | Opus 4.7 | 97 |

Any model that falls **off** this frontier (charges more and delivers the same score, or less) is an irrational pick. That's the case for **Grok 4.5** (~$5.10 to score 87, when Kimi K2.6 scores the same 87 for ~$1.00) and **GPT 5.4** (~$16 to score 95, when Opus 4.8 scores 95 for 40% of the price).

And a new variable is on the board for good: **subscriptions**. GPT 5.6 Sol ran on ChatGPT plan credits. At API rates it's dominated by Opus 4.8 (95 for ~$6.40 vs 92 for ~$8.70). But on a plan you *already pay for*, the marginal cost of one more run is basically zero, and that flips the logic.

### What makes sense for someone who programs for a living

Put it all together and the picture for a professional programmer is clear:

- **If you're on a subscription** (Claude Max, ChatGPT Pro) and you work within the plan's limits, the per-token price math **collapses**. A Max 20x subscriber gains nothing by picking Kimi K2.6 to save $6 they aren't spending. The rule becomes "use the best model your plan gives you," full stop. The price frontier only matters again for what overflows the plan's cap or for models outside the plan.
- **If you pay API per token** (the case for any automation, CI, or pipeline, which *can't* run on a consumer plan), the value frontier rules. Never step below Tier A to save single-digit dollars on work you intend to ship: saving $6 by taking a Tier B model costs $60 to $100 in fix time, a negative return of 10 to 15 times.
- **The floor is still Tier A.** Below it you get silent runtime breakage, not just slightly worse code: a hallucinated API mocked by its own test, multi-turn that never reaches the model, a stub the production path bypasses. It passes CI and blows up in front of the user. That debugging session costs more than a whole month of Tier A runs.

In practice, for me: if I'm on a paid plan, I use the top the plan offers (Opus, and now Sol when I want variety). If it's automation paying per token, Opus 4.8 is the quality-per-price sweet spot in the 95 cluster, and Gemini 3.5 Flash is the best 90+ option on a tight budget. Grok 4.5 and GPT 5.6 Sol are good models, but neither changes that recommendation: one ties with open source five times cheaper, the other only pays off inside an already-paid subscription.

The benchmark is open, with the full table, the verified costs, and the detailed pricing analysis: [github.com/akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). Want to see another model in there? Fork it, add an entry to `config/models.json`, run it, and send the PR.
