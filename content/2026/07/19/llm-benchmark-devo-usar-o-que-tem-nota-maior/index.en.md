---
title: "LLM Benchmark: Should I Use the Highest-Scoring Model?"
slug: "llm-benchmark-should-i-use-the-highest-scoring-model"
date: '2026-07-19T12:00:00-03:00'
draft: false
translationKey: llm-benchmark-devo-usar-o-que-tem-nota-maior
description: "Why the top entry in an LLM ranking is not necessarily the best model, why 90+ is a cluster, and how to use benchmarks without outsourcing your technical judgment."
tags:
  - llm
  - benchmark
  - claude
  - gpt
  - openai
  - anthropic
  - ai
  - vibecoding
---

Every time I publish another round of my benchmark, someone opens the table, looks at the first few rows, and asks:

> "Why is Opus 4.7 above Opus 4.8 and Fable 5?"

Or:

> "Does that mean GPT 5.4 is better than GPT 5.5 and 5.6?"

No. It means the table was sorted by a column called `score`. That's it.

A ranking needs an order if anyone is going to read it. The mistake is turning that presentation order into a world championship of intelligence. First place didn't beat every other model at everything. It generated the artifact that received the highest score **in this test, on this run, in this harness, with this prompt, under this rubric**.

This post is about how I read [my own open benchmark](https://github.com/akitaonrails/llm-coding-benchmark), why I consider everything above 90 to be roughly the same cluster, and why nobody should outsource model selection to a table. Mine included.

## The score belongs to the project, not the whole model

The benchmark started with [Testing Open Source and Commercial LLMs](/en/2026/04/05/testing-llms-open-source-and-commercial-can-anyone-beat-claude-opus/) and got its current methodology in [Part 3, now the canonical reference](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/).

Every model gets the same job: autonomously build a small Rails 8 chat app using RubyLLM, Hotwire, Tailwind, tests, CI tooling, a Dockerfile, Compose, and documentation. I then grade the output across eight dimensions: completeness, RubyLLM API correctness, test quality, error handling, persistence, Hotwire, architecture, and production readiness.

Notice the subject of that sentence: I grade **the output**.

The model doesn't go into an MRI that reveals how much "intelligence" is tucked away inside. It gets a prompt, uses tools, writes a project, and stops. The score is an evaluation of that project. To classify the full capability of an LLM, we would have to test every possible problem, in every language, with every prompt, context, tool, and combination of requirements. Good luck with that.

What really shows up in the table is closer to this:

```text
result = model + prompt + harness + context + tools + snapshot + run + audit
```

We sort by score because an unordered table is a pain to read. Sorting one sample doesn't turn it into a law of nature.

## An LLM doesn't take the same test twice

LLMs aren't deterministic. The same prompt doesn't guarantee the same tokens, architecture decisions, or sequence of tool calls. A coding agent also picks up terminal output, response times, accumulated context, compaction, and whatever the harness happens to do. If the provider updates an alias between one Monday and the next, another variable changed without you touching a thing.

I had already run into this in [Part 2 of the benchmark](/en/2026/04/18/llm-benchmarks-part-2-multi-model/). That post's ranking became obsolete when I fixed the RubyLLM audit, but the variance experiment still holds: the same Opus 4.7, with the same prompt, produced results ranging from Tier 1 to Tier 3 under different harnesses. I wrote back then that one or even three benchmark runs weren't enough to claim absolute quality. They still aren't.

There is a cleaner, more recent example. Fable 5 ran again after its re-release using the same model ID on OpenRouter. The first run scored **94 in 24 minutes**. The second scored **93 in 18 minutes**. Different projects, different defects, different cost. One score point is noise even within the "same" model.

The harness can move the whole result, too. DeepSeek V4 Pro got 69 with a DNF in OpenCode and reached 89 through DeepClaude. Kimi K2.7 scored 86 through OpenCode/OpenRouter and roughly 68 in an informal run through Kimi Code CLI. Both comparisons come with snapshot and endpoint caveats, which is exactly the problem: we can't isolate the model perfectly. An agent benchmark measures the whole package.

## Above 90, read it as a group

Here is the current top of the table. The numbers come from the [full benchmark report](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.md):

| Model | Score | Time | Run cost |
|---|---:|---:|---:|
| Claude Opus 4.7 | 97 | 18 min | ~$7.00 |
| GPT 5.4 xHigh | 95 | 22 min | ~$16 |
| Claude Opus 4.8 | 95 | 17 min | ~$6.40 |
| Claude Fable 5 | 94 | 24 min | ~$11.20 |
| Claude Fable 5 (re-release) | 93 | 18 min | ~$8.30 |
| Gemini 3.5 Flash | 93 | 18 min | ~$3.55 |
| GPT 5.6 Sol xHigh | 92 | 17 min | credits (~$8.70 API equivalent) |

To me, everything in there is in the same **ballpark**. We don't have enough samples to say that 97 is 2.1% "more intelligent" than 95, much less that it will be better at a database migration, a Rust refactor, or chasing down a race condition.

There is a ceiling effect, too. The benchmark app is real and includes plenty of annoying details, but it is still a small greenfield Rails project with a closed scope. The best models have saturated the task. The order at the top ends up coming down to isolated choices: an API-key guard, where conversation state was persisted, a cookie cap, one missing error test, a development Dockerfile instead of a production one.

Those details matter to the project. They don't prove a universal hierarchy among the models.

The distance between **Tier A and Tier C** says much more. The rubric defines Tier A as something that can ship as-is or after a short patch. Tier C has a broken core or needs major rework. I can't tell you whether a 97 model will really beat a 93 model on some future job. I can tell you that the group shipping correct RubyLLM code, useful tests, and a production image is in a different category from the group that invents an API and then tests the wrong mock.

Pick the group first. Then argue about cost, speed, subscription, harness, and which one you prefer using. Fighting over the exact position inside the 90s cluster is made-up precision.

## So why does Opus 4.7 rank above 4.8 and Fable?

Because the project generated by Opus 4.7 fit the rubric better. The RubyLLM integration was correct, the test doubles matched the real signatures, session-cookie persistence was multi-worker safe, and the error paths were covered. Under the current audit, there was no major concrete defect left to deduct.

Opus 4.8 also wrote an excellent project, validated Rails, Docker, Compose, and a real OpenRouter call, and finished one minute faster. It lost two points because cookie history had no cap and could hit the 4 KB limit, and because it had no explicit API-key preflight.

Fable 5 fixed those two things. Then it chose an in-process singleton for persistence. The conversation disappears on restart and doesn't work properly across multiple workers. That decision cost the point that put it below 4.8. The blind cross-audit itself noted that moving the store to `Rails.cache` would probably reverse their order.

That explains why the **artifact scores** were 97, 95, and 94. For analyzing a 500,000-line codebase, the table tells you nothing.

The efficiency data tells another story:

| Model | Score | Time | Tokens summed from logs | Input/output rate |
|---|---:|---:|---:|---:|
| Opus 4.7 | 97 | 18m12s | 9.78M | $5 / $25 per million |
| Opus 4.8 | 95 | 16m48s | 8.28M | $5 / $25 per million |
| Fable 5 | 94 | 24m19s | 6.03M | $10 / $50 per million |

That sum includes input, output, cache writes, and cache reads from every `step_finish` event in both phases. At the same rate as 4.7, Opus 4.8 used 15% fewer billable tokens and finished faster. Anthropic itself described [Opus 4.8 as a modest improvement over 4.7](https://www.anthropic.com/research/claude-opus-4-8), kept the price unchanged, and called out more efficient tool use. My run fits that story. One run still does not prove the cause.

Fable costs twice as much per token, and the higher price didn't produce a better project on this problem. All that tells us is that this small app didn't demand the extra capability Anthropic sells with Fable. It may simply be too much model for the test.

My personal read is that Opus hit the plateau of this benchmark with 4.7. Version 4.8 refined efficiency and behavior. Fable moved into another capability and price bracket, but the test could not pull out that difference. That is a hypothesis based on these results, not inside knowledge of Anthropic's training process.

## And why does GPT 5.4 rank above 5.5 and 5.6?

Same answer: different decisions in the generated projects.

GPT 5.4 did an API-key preflight, distinguished configuration errors from provider errors, used a cache with a TTL and message cap, and separated the form object from the domain. It lost points because its Dockerfile was a development image running as root.

GPT 5.5 got the integration and multi-turn behavior right, but repeated the development Dockerfile, didn't test any of the error paths, and left the cookie without a byte limit. It dropped to 85 in the re-audit.

GPT 5.6 Sol came back to 92 with much better defensive engineering, a non-root multi-stage Docker image, and 99.2% coverage. It had no system prompt and carried history in a hidden field on the client. The rubric deducts for that because the conversation disappears on reload and can be tampered with.

Now look at efficiency:

| Model | Score | Time | Total tokens | Run cost |
|---|---:|---:|---:|---:|
| GPT 5.4 xHigh | 95 | 22 min | 7.64M | ~$16 |
| GPT 5.5 xHigh | 85 | 18 min | 4.90M | ~$10 |
| GPT 5.6 Sol xHigh | 92 | 17 min | 3.92M | credits (~$8.70 API equivalent) |

From 5.4 to 5.6, runtime dropped about 23% and token use nearly halved. The funny part is that [GPT 5.4 costs $2.50/$15 per million](https://developers.openai.com/api/docs/models/gpt-5.4), while [GPT 5.5](https://developers.openai.com/api/docs/models/gpt-5.5) and [GPT 5.6 Sol](https://developers.openai.com/api/docs/models/gpt-5.6-sol) cost $5/$30. Even with a unit rate twice as high, the later runs cost less because they were far more economical with tokens. The 5.6 run was actually paid with subscription credits; $8.70 is only the calculated API-rate equivalent.

That backs my hunch a little better: GPT 5.4 was the jump that put the family on this test's quality plateau. Versions 5.5 and 5.6 seem to have put plenty of work into efficiency, using less context and finishing faster while staying in roughly the same capability ballpark.

But I have no way to prove that OpenAI trained those versions with that goal. The data shows how the three runs behaved. Calling it product strategy is already my own guess.

## Even the audit has bugs

There is one more uncomfortable variable: me.

GPT 5.5 originally got a 96. Then the cross-audit against 5.6 found problems that had slipped through. I reread the code, confirmed the defects, and dropped the score to 85. In the same review, 5.4 fell from 97 to 95 because of its development Dockerfile.

The model didn't change. The project didn't change. **The audit got better.**

In the first version of the benchmark, I also marked valid RubyLLM APIs as hallucinations because I was auditing from memory. Once I read the gem source, I had to redo a good chunk of the ranking. It is all documented in the old posts because hiding a mistake would be worse than making one.

Another reason not to treat a score like a physical constant. A rubric takes a pile of qualitative decisions and squeezes them into one number. It can have blind spots, bad weights, and wrong interpretations. A serious benchmark publishes the prompt, generated code, logs, criteria, and corrections so someone else can challenge it.

Be even more suspicious when someone publishes only the chart.

## How to use a benchmark without becoming a sports fan

I use rankings for three things:

1. **Discarding clearly bad groups.** Tier C and D fail at fundamental parts of this workload. I am not spending a week betting on them for autonomous Agile Vibe Coding.
2. **Finding the candidate cluster.** I consider everything above 90 strong. From there I pick based on the marginal cost of my subscription, speed, harness availability, and day-to-day behavior.
3. **Reading the defects, not just the score.** If my system uses neither cookies nor Docker, some deductions in this benchmark are irrelevant. If I need multi-turn and deployment, they become decisive.

If the decision carries real money or production risk, run your own test. Take the [benchmark repository](https://github.com/akitaonrails/llm-coding-benchmark), replace the prompt with work resembling yours, run each model more than once, and do a blind review. Measure time, cost, and how much human work remained afterward. A team maintaining a fifteen-year-old Java monolith needs a different benchmark from someone building a greenfield Rails prototype.

No benchmark is perfect. SWE-bench, Terminal-Bench, my Rails app, human-preference arenas: each tests one slice and ignores the rest. They are useful for locating groups and eliminating bad options. None can spit out "the best LLM" in absolute terms because that object does not exist until you specify the job.

## Conclusion

Claude Opus 4.7 sitting in first place doesn't mean I would choose it over 4.8 for every job. GPT 5.4 ranking above 5.6 doesn't mean I went back in time. It means those projects added up to more points in one run of this Rails app under this rubric.

My recommendation stays simple: read the top as **clusters**, not a podium. The 90+ group is in the same ballpark. Tier A is clearly more reliable than Tier C for this kind of coding. Within the good group, choose based on your harness, your subscription, your time limit, and the defect you are willing to fix.

And don't trust a benchmark. Don't trust influencers. Don't trust me.

If you truly need to know which model is best for your case, define your constraints, write your methodology, run them all, and bring data. Other people's opinions are useful for deciding what to test first. The technical decision is still yours.
