---
title: "LLM Benchmark: Is Opus 5 Any Good?"
slug: "llm-benchmark-is-opus-5-any-good"
date: '2026-07-25T12:00:00-03:00'
draft: false
translationKey: llm-benchmark-opus-5-e-bom
description: "Opus 5 scored 95/100 on the Rails benchmark, tying Opus 4.8 and edging Fable 5 by one point. Its API rate is half Fable’s, but this narrow test does not define the best LLM."
tags:
- llm-benchmarks
- llms
- coding-agents
---

Anthropic released **Claude Opus 5** yesterday. The obvious question is:

> "Is it any good?"

Short answer: **yes, very**. It scored 95/100, Tier A, on my benchmark, with the most complete engineering I have seen so far from any of the harnesses I tested.

Now for the answer that matters: no, this does not prove it is "the best LLM in the world." It does not prove it is better than Fable 5, Opus 4.8, GPT 5.6 Sol, or Kimi K3 at whatever job you throw at them either. Last week I published an entire article on [why the highest score does not mean the best model](/en/2026/07/19/llm-benchmark-should-i-use-the-highest-scoring-model/). Opus 5 arrived just in time to hand us a fine case study for that argument.

## Where Anthropic positions Opus 5

In the [official announcement](https://www.anthropic.com/news/claude-opus-5), Anthropic describes Opus 5 as an everyday model that comes close to Fable 5's frontier intelligence at half the price. It is now the default model on Claude Max and the strongest one available on Pro.

The product ladder looks simple enough:

```text
Opus 4.8  <  Opus 5  ≈  Fable 5
```

Except Anthropic's own data does not form such a tidy line. At maximum effort on CursorBench 3.2, Opus 5 lands within 0.5% of Fable 5's peak. On Frontier-Bench v0.1, it beats every other model and more than doubles Opus 4.8's result at a lower cost per task. On OSWorld 2.0, it even tops Fable's best result at a little over a third of the cost.

So "somewhere between Opus 4.8 and Fable 5" is a fair shortcut for understanding the product. It is not a universal ranking. The curves cross depending on the task and the effort setting.

Price is less fuzzy. Opus 5 costs **$5 per million input tokens and $25 per million output tokens**, the same as Opus 4.8. Fable 5 costs **$10/$50**. At API rates, Opus 5 delivers the most interesting promise in this release: near-Fable behavior without paying the Fable tax.

## The benchmark

For anyone just joining us, my [LLM Coding Benchmark](https://github.com/akitaonrails/llm-coding-benchmark) gives every model the same job: build a ChatGPT-style chat app on its own in Rails 8, with RubyLLM, Hotwire, Tailwind, tests, CI, Docker, and documentation.

I am not grading one isolated function. I grade the project that comes out the other end: whether it uses the real RubyLLM API, whether multi-turn works, whether it handles provider failures, whether the conversation persists, whether Turbo Streams is actually wired, whether the tests can catch bugs, and whether the production image boots.

Opus 5 ran solo through **Claude Code headless**, with `--dangerously-skip-permissions`, using my Max subscription. The numbers:

- **38m57s**
- **201 turns**
- **121 tests and 355 assertions**
- **100% line coverage and 95.94% branch coverage**
- **22.1 million cache-read tokens**
- **$16.02 at equivalent API rates**, billed to the subscription

That needs an asterisk. Opus 4.8 and Fable 5 were tested in OpenCode through OpenRouter. GPT 5.6 Sol ran in Codex. Kimi K3 ran in Kimi Code CLI. A coding benchmark measures the whole package:

```text
model + prompt + harness + tools + context + execution + audit
```

That is why the repository keeps Opus 5 in the Claude Code profile instead of pretending this was a perfectly controlled comparison with the main table. I am combining the main ranking's 40 rows with the new result here because everyone wants to see where that 95 lands. The asterisk is doing real work.

## Updated ranking: main table + Opus 5

| Rank | Model | Score | Tier | RubyLLM OK | Time | Run cost |
|---:|---|---:|:---:|:---:|---:|---:|
| **1** | **Claude Opus 5 (Claude Code)\*** | **95** | **A** | ✅ | **39m** | **subscription (≈$16.02 API equiv.)** |
| 1 | GPT 5.4 xHigh (Codex) | 95 | A | ✅ | 22m | ~$16 |
| 1 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$6.40 |
| 4 | Claude Fable 5 | 94 | A | ✅ | 24m | ~$11.20 |
| 5 | Claude Fable 5 (re-release) | 93 | A | ✅ | 18m | ~$8.30 |
| 5 | Gemini 3.5 Flash | 93 | A | ✅ | 18m | ~$3.55 |
| 7 | GPT 5.6 Sol xHigh (Codex) | 92 | A | ✅ | 17m | subscription (≈$8.70 API equiv.) |
| 8 | Kimi K3 (Kimi Code CLI) | 89 | A | ✅ | 26m | subscription (≈$2.10 API equiv.) |
| 9 | Claude Opus 4.7 | 87 | A | ✅ | 18m | ~$7.00 |
| 9 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$1.19 |
| 9 | GLM 5.2 (Z.ai) | 87 | A | ✅ | 43m | subscription |
| 9 | Grok 4.5 | 87 | A | ✅ | 16m | ~$5.10 |
| 13 | Kimi K2.7 Code | 86 | A | ✅ | 22m | ~$1.23 |
| 14 | GPT 5.5 xHigh (Codex) | 85 | A | ✅ | 18m | ~$10 |
| 15 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 (hist.) |
| 15 | Nex-N2-Pro | 83 | A | ✅ | 25m | ~$0.34 |
| 17 | Gemini 3.1 Pro | 79 | B | ✅ | 14m | ~$3.10 |
| 17 | Sakana Fugu Ultra | 79 | B | ✅ | 22m | subscription |
| 19 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 (hist.) |
| 19 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 19 | MiniMax M3 | 78 | B | ✅ | 53m (phase 2 DNF) | ~$1.25 |
| 19 | Qwen3.7 Max | 78 | B | ✅ | 19m | ~$1.40 |
| 23 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.70 |
| 24 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 (hist.) |
| 25 | DeepSeek V4 Pro | 69 | B | ✅ | 22m (DNF) | ~$0.05 |
| 25 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0.10 (hist.) |
| 25 | Step 3.7 Flash | 69 | B | ✅ | 27m | ~$0.80 |
| 28 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.09 |
| 29 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 (hist.) |
| 30 | Claude Sonnet 5 | 58 | C | ❌ | 27m | ~$2.25 |
| 31 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 (hist.) |
| 32 | Qwen 3.5 35B | 55 | C | ✅ | 28m | local |
| 33 | GLM 4.7 Flash bf16 | 52 | C | ✅ | failed | local |
| 34 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 35 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 (hist.) |
| 36 | Qwen 3.5 397B A17B | 42 | C | ❌ | 15m | ~$0.31 |
| 37 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 (hist.) |
| 38 | Qwen 3.5 122B | 37 | D | ❌ | 43m | local |
| 39 | Qwen 3 Coder Next | 32 | D | ❌ | 17m | local |
| 40 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.70 |
| 41 | GPT OSS 20B | 11 | D | ❌ | failed | local |

\* Opus 5 received an equivalent 95/100 in the Claude Code profile. The repository's main table keeps it separate to make the harness difference explicit.

## What Opus 5 wrote

The score alone hides the good part. Opus 5's project is the best example of defensive engineering to show up in this benchmark so far.

It isolated all RubyLLM access in one `Assistant::Client`, injected the chat factory for tests, and verified the gem's real API before depending on it. Besides mocking `RubyLLM.chat`, `with_instructions`, `add_message`, and `ask`, it created a guard test that confirms those methods still exist in the installed gem. If the library changes its interface, CI breaks before production does.

The conversation sits behind a `ConversationRepository` in `Rails.cache`, with a 12-hour TTL and a 40-message replay limit. Before sending history to the provider, it normalizes role alternation between `user` and `assistant`, removes failed replies, and makes sure the window does not begin with an assistant message. That sounds like trivia right up until the API rejects the payload on turn two.

That is exactly where the model found and fixed two bugs during its own run. A failed reply could leave two user messages in a row. Trimming the history window could also make it begin with an assistant reply. It wrote tests, fixed both, and validated real multi-turn behavior, including recovery after a failure.

It also delivered:

- streaming outside the main request;
- signed Turbo Streams broadcasts throttled to roughly 10 updates per second;
- credential preflight;
- different messages for an invalid key, rate limits, depleted credits, blown context, and provider downtime;
- Markdown escaped before formatting HTML;
- a multi-stage, production, non-root Dockerfile;
- RuboCop, Brakeman, bundler-audit, importmap audit, and GitHub Actions.

It is not a 100. There is a lost-update race if another message arrives during generation, although the project itself constrains deployment to `WEB_CONCURRENCY=1`. It also left the default model on Sonnet 4.6 after Sonnet 5 was already available, and committed `log/` and `coverage/` cruft inside the artifact. Those deductions held it at 95.

## Opus 5 against Opus 4.8 and Fable 5

First, the numbers from our test:

| Model | Score | Time | Tests | Persistence | API rate |
|---|---:|---:|---:|---|---:|
| Opus 5 | 95 | 39m | 121 | Rails.cache, TTL, limited replay | $5 / $25 |
| Opus 4.8 | 95 | 17m | 34 | session cookie with no cap | $5 / $25 |
| Fable 5 | 94 | 24m | 36 | capped local singleton | $10 / $50 |
| Fable 5 (re-release) | 93 | 18m | 41 | Rails.cache with TTL, no hard cap | $10 / $50 |

[Opus 4.8 had scored 95](/en/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/) with a smaller solution that finished much faster. It used the correct API, wrote honest tests, and performed the best live validation in that round: local Rails, a real OpenRouter call, Docker, a production container, and Compose. It lost points for leaving cookie history unbounded and skipping an API-key preflight.

Opus 5 fixed both defects and went much further on architecture, streaming, and tests. On the other hand, it created a different race, left the model pin stale, and took more than twice as long. Same score, very different artifacts.

[The original Fable 5 scored 94](/en/2026/06/11/llm-benchmark-fable-5-anthropic-soap-opera/). It was the first model I saw stop in the middle of the job to read RubyLLM's installed source before writing the integration. It had 99.3% coverage, capped history, preflight, and a phase 2 that needed no fixes. The big deduction came from storing conversations in an in-memory singleton: restart the process and everything is gone; add a second worker and each one sees a different world.

The Fable re-release fixed that with `Rails.cache`, but left the cache without a hard cap, kept Sonnet 4.6, and performed weaker live validation. It dropped one point. Same model ID, another project, another score.

Within the boundaries of this Rails app, Opus 5 looks more complete than both Fable runs and at least as good as Opus 4.8. Just do not confuse that with "Opus 5 is more intelligent than Fable." Anthropic says Fable's advantage grows as tasks get longer and more complex. Our project is small, greenfield, and closed-ended. There may simply be no room here for that difference to show.

## The price: half of Fable, but mind the bill

On the API, the advantage is straightforward:

| Model | Input / million | Output / million |
|---|---:|---:|
| Opus 5 | $5 | $25 |
| Opus 4.8 | $5 | $25 |
| Fable 5 | $10 | $50 |

If Opus 5 really delivers near-Fable behavior on your workload, paying twice as much for Fable is hard to justify. Fable needs to solve something Opus cannot, not merely carry the name of the tier above it.

But the observed cost of this run tells a different story:

| Model | Harness | Run cost |
|---|---|---:|
| Opus 5 | Claude Code / Max | subscription (≈$16.02 at API rates) |
| Opus 4.8 | OpenCode / OpenRouter | ~$6.40 |
| Fable 5 | OpenCode / OpenRouter | ~$11.20 |

How did a model with half Fable's rate end up with a higher equivalent cost? Because price per million is not cost per task. The Opus 5 run took 201 turns and accumulated 22.1 million cache reads in Claude Code. The Fable run used another harness and another token profile. Comparing $16.02 with $11.20 as if the model were the only variable would be flat-out wrong.

For me, as a Max subscriber, the real marginal cost was zero while I remained inside the allowance. For automation that pays API rates per token, Opus 5 costs half as much as Fable and the same as 4.8. I would start with Opus 5 and move up to Fable only with evidence that the task needs it.

## Against GPT 5.6 Sol and Kimi K3

[GPT 5.6 Sol scored 92](/en/2026/07/09/llm-benchmark-grok-4-5-gpt-5-6-sol/) in 17 minutes. It was far more token-efficient and delivered a defensive application: a non-root Docker image, 99.2% coverage, history bounded by messages, characters, and bytes, plus a specific test to keep the current prompt from being repeated in context.

It lost points because it never used `with_instructions` and carried history in a hidden field in the browser. That works, but the conversation disappears on reload and the client can tamper with the context. Opus 5 put those responsibilities on the server, separated domain, persistence, and provider more cleanly, and tested far more. On this project, the three-point difference makes sense. In daily use, both remain in the same cluster of strong models.

[Kimi K3 scored 89](/en/2026/07/17/llm-benchmarks-kimi-k3/) in 26 minutes. It had already nailed the pattern that decides much of the top end: `Rails.cache`, a TTL, and a history cap. It cost only about $2.10 at equivalent API rates through the Moderato subscription.

It landed lower because it had no system prompt, put LLM I/O inside the `Conversation` model, skipped credential preflight, and left the production cache on the container's ephemeral default. Opus 5 closes nearly all of those gaps. Kimi remains a much cheaper Tier A alternative; Opus 5 is the project I would need to touch less before trusting it.

## Opus 5 also dethroned the old champion

There is one important change in the table that did not come from the new code. Until yesterday, Opus 4.7 sat in first place with 97. The blind cross-audit between it and Opus 5 came back **94 to 70** in favor of 5. I went back and read the old artifacts.

Opus 4.7 had a double-send bug: the controller stored the user's message before calling the service, and the service replayed the entire history, including that same message. Every prompt reached the LLM twice. Error messages also returned in the context of future requests, and the cookie had a message-count limit but no byte limit.

The tests passed because controller and service were tested under arrangements that differed from the production flow. The model did not get worse since April. The project did not change either. **My audit was incomplete.** I recalculated the score from 97 to 87.

That is almost comical, because last week's article used "why is Opus 4.7 above 4.8 and Fable?" as its exact example. It is not anymore. And the article's argument just got stronger.

A benchmark is not holy writ. The rubric evolves, the auditor finds a blind spot, the harness changes, the same model generates another project. If a table does not publish the prompt, artifact, logs, and corrections, it is more useful for marketing than engineering.

## Conclusion

Is Opus 5 any good? **Yes.** Very.

It scored 95/A, tied Opus 4.8 and GPT 5.4, landed one point above the original Fable, three above GPT 5.6 Sol, and six above Kimi K3. It produced the most careful project in this entire round: clean architecture, RubyLLM verified against the real gem, correct history, solid streaming, separate error handling, and 121 tests.

It also took 39 minutes, burned 22 million cache reads, and ran in a different harness. Scoring higher than Fable does not prove it is better than Fable overall. It proves that, on this Rails app, in this Claude Code run, under this audit, the artifact fit the rubric a little better.

My practical read: Opus 5 deserves to be the first option. Its API rate is the same as Opus 4.8 and half Fable's. For anyone with Claude Pro or Max, it is the obvious choice before spending credits on Fable. If you pay API rates, I would still start there and demand data before moving up to the $10/$50 tier.

And the rule stays the same: read 90+ as a group. Tier A is clearly above Tier C on this workload. Within the good group, choose by cost, subscription, speed, harness, and the kind of defect you are willing to review.

Do not use my benchmark to decide which model is "the best LLM." Use it to decide what is worth testing on your problem. If the decision matters, run your own methodology more than once, and read the code.
