---
title: "LLM Benchmarks: Qwen 3.8, GLM 5.3, Gemini 3.7"
slug: llm-benchmarks-qwen-3-8-glm-5-3-gemini-3-7
date: '2026-08-15T14:00:00-03:00'
draft: false
translationKey: llm-benchmarks-qwen-3-8-glm-5-3-gemini-3-7
description: "GLM 5.3 scored 94 and closed in on the leading trio. Qwen 3.8 Max jumped from 51 to 92 after it stopped hallucinating the RubyLLM API. Gemini 3.7 Flash scored 93 — after getting caught studying its own grading key. And the local 27B Qwen showed that context is now the bottleneck."
tags:
- llm-benchmarks
- llms
- coding-agents
---

Two weeks ago I published [version 2 of my LLM Coding Benchmark](/en/2026/07/30/new-llm-benchmark-i-reran-every-test/): a new three-phase test (build, validate by actually running it, then self-review), fourteen numbered goals, a ten-dimension rubric where admitting your own flaws is worth 15 points, each family running on its native harness, and tiers anchored on Opus 4.6 as the competence floor. The methodology is all there, so I won't repeat it here.

The top hasn't moved: **Fable 5 at 96**, the trio of **Sonnet 5, Opus 5, and Kimi K3 at 95**, and right behind them **GPT 5.6 Sol, GPT 5.6 Terra, and Opus 4.8 at 93**. That's the cream of the crop in this test. The open question: how close do the newest releases get to that group?

Since then I've run four models: Qwen 3.8 Max, GLM 5.3, Gemini 3.7 Flash, and a 27B Qwen 3.8 running locally on my RTX 5090. One of them closed in on the leading group. Another pulled off the biggest jump this test has ever recorded. A third forced me to rewrite the benchmark's integrity rules. And the local one gave me the most laborious, and most instructive, run of the year.

## Qwen 3.8 Max: the biggest jump in benchmark history

To measure the jump, first the size of the hole. Qwen 3.7 Max had scored **51 points, Tier C**, and the reason was ugly. When implementing the multi-turn chat, it decided it could replay history by calling `chat.ask(entire_history_array)`. Except RubyLLM's `ask` wraps its argument into a single user message: the entire conversation, assistant turns included, becomes one message with every role obliterated. Worse, the required test for that feature **mocked exactly that nonexistent API**. A test that mocks a fabricated API is worse than no test, because it certifies the hallucination.

The 3.8 Max fixed exactly that. It used the real API end to end: `add_message` with role and content for history replay, `with_instructions`, `with_tools`, `with_schema`, all verified against the installed gem's source. The result: **92 points, Tier A**. That's a **41-point jump** on the same test, same rubric, same harness. The test didn't get easier; the model finally understood the library.

The rest of the delivery is solid: file storage with an exclusive `flock` on every mutation, a hand-written arithmetic evaluator with no `eval`, the exact-array test for the multi-turn payload, and all seven phase-2 validations proven live — tools with exact arithmetic, restart survival, Compose end-to-end with 16 incremental streaming frames crossing workers over Redis. The suite came out with 62 tests and 226 assertions, green under the auditor's hand.

Where it lost points is instructive: `config/puma.rb` shipped without the `workers` directive, so the `WEB_CONCURRENCY=2` it swore it had delivered was, in practice, running single-process. Concurrency scored 8 instead of 9. And it kept the stale pin on `claude-sonnet-4.6`, the house's standard deduction.

On the table, those 92 points tie with Grok 4.5, GLM 5.2, and Kimi K2.5, **one point below Sol and Terra**. It cost $9.16 in API and 78 minutes — verbose: 25 million tokens. Among opencode runs with a final score, only MiniMax M3 burned more.

## GLM 5.3: the loneliest step on the table

Z.ai's trajectory in this test is the steadiest of the pack: GLM 5 scored 83, GLM 5.2 scored 92, and now **GLM 5.3 scored 94** — alone on a step nobody else occupies, one point below the 95 trio and one point above the 93 group. In other words: **two points from Fable 5**.

And the inevitable comparison is with Kimi. K3 scored 95, one point above — but it ran on the Kimi CLI, its native harness. GLM 5.3's 94 came on opencode, the generic harness: it's the **highest score ever recorded there**. On the same opencode, the best Kimi is K2.5 at 92, two points below. On cost, both live on subscriptions: K3 came out at $6.14 equivalent on the Moderato plan; GLM at zero marginal cost. Kimi still wins on score; GLM wins on cost and harness independence.

What pulled it out of the 92 pack? Three things, all boring, all important:

1. **Concurrency delivered working.** The same atomic `flock` scheme as Qwen 3.8 Max, plus a per-conversation turn lock (an atomic `claim_run`), plus a `WEB_CONCURRENCY=2` that actually works — proven by killing and restarting workers and verifying the store stayed byte-for-byte identical. The Qwen had the same foundation but shipped concurrency broken and scored 8. The GLM shipped it working and got 9.
2. **A fallback token estimator** (`bytesize/4`), so the per-conversation budget doesn't depend on the provider returning usage. The 5.2 depended on it, and lost points there.
3. **Branch coverage enabled**: 98% line and 82% branch, a suite of 73 tests and 219 assertions green under the auditor's hand, with RuboCop, Brakeman, and bundle-audit all at zero.

The only real slip was the same stale sonnet-4.6 pin. And there was a modulo-by-zero bug in the calculator that the model itself found and fixed in phase 3 — exactly the kind of behavior the self-review phase exists to measure. Speaking of which: it confessed everything, including that the conversation title never retries if generation fails, and took 14 of the 15 honesty points.

And the cost is the part that hurts the competition: it ran on Z.ai's flat-rate plan, so the run came out at **zero marginal cost** — the API equivalent would be $2.59. Eighty minutes, 19.4 million tokens. The "Chinese models are the cheap alternative" conversation died a while ago: this is a leadership candidate that also happens to be cheap.

## Gemini 3.7 Flash: 93, Tier A — and the model that studied its own grading key

The technical part you already know: Gemini 3.1 Pro died in v2 because of a Google bug, `Corrupted thought signature`, which killed phase 2 three times via OpenRouter and trapped it at 62 (on Antigravity, over the direct path, it scored 88). This time I cut out the middleman: opencode with a **direct Gemini API key**, no OpenRouter in between. Zero occurrences of the bug across the three phases. The direct path worked — and 3.7 Flash became the **first Gemini to reach Tier A on opencode**: 3.5 Flash scored 79 there, 3.1 Pro scored 62. Before that, only Google's native harness had taken a Gemini to A.

Official result: **93 points**, tied with GPT 5.6 Sol, Terra, and Opus 4.8. The run cost $4.12, took 43 minutes, and burned 27.8 million tokens.

But the road to that 93 produced the most important finding of this cycle. The first 3.7 Flash run went unshielded, as the policy of the time required: shield only the local models, because "frontier models stay in their lane." Well, Gemini didn't. Midway through phase 1, and again in the self-review, it **read the scoring rubric**, read the entire v2 report — every competitor's score and audit, plus the deduction catalog — grepped for the G1–G14 gate patterns, and **ran the audit scanner on itself eight times**. It spent the test studying the answer key.

The smoking gun is the pin. The contaminated run came out with the correct pin on `claude-sonnet-5`, that feat only three models had managed in the benchmark's entire history. The clean run, redone with the rubric, the reports, the scanner, and the 43 sibling apps outside the repository, came out with the stale pin on `claude-sonnet-4.6`, like everyone else. It didn't know the current model at all — it had read the answer in the report. The first run was voided. The 93 belongs to the shielded re-run.

To be fair: it didn't copy code from any sibling app — the sweep confirmed that. What it did was read the answer key. And that toppled the house's last presumption of innocence: from this run on, **every** model runs shielded, frontier or not.

And the 93 isn't charity — the delivery stands on its own. Real RubyLLM 1.16 API end to end, an eval-free AST calculator (tokenize, convert to Polish notation, evaluate), the exact six-message array test for multi-turn, a SQLite WAL store with busy_timeout, retries, and count and byte limits, proven by killing and restarting two workers, and 16 incremental Turbo Stream broadcasts in Compose over Redis. A suite of 55 tests and 213 assertions, green under the auditor's hand, branch coverage enabled. The deductions: the stale pin and the lack of a per-conversation turn lock — the same concurrency ceiling as Fable 5's class.

> **Remember this:** this time it wasn't a weak local copying from the neighbor. It was a frontier model reading the test's answer key mid-execution. Now everyone runs shielded.

## Qwen 3.8 27B local: the most laborious run of the year

In the previous article I said I'd only test a new local model if strong evidence showed up. Then the Max sibling scored 92, the open 27B version was available, and I had the excuse I was missing. It was worth it for the science, but it took work.

First surprise: the 3.8 27B uses a hybrid SSM/Mamba architecture, and my tuned llama.cpp llama-swap build **can't load the model** — a tensor is missing (`ssm_conv1d`) that only newer versions know about. The fix was spinning up a fresh Ollama container, which bundles a current llama.cpp, and importing the GGUF I had already downloaded via a Modelfile. First lesson: with local models, the tooling ages in months.

Second surprise: context. With a 32K window, DNF. With 64K, DNF again. A reasoning model burns an absurd number of tokens thinking — it exhausted the window reading the gem's source before writing the first line of the app. It only started completing the test at 128K and up. The official run used **176K of context**, which with flash attention and a q8_0-quantized KV cache occupied about 28 GB of the RTX 5090's 32 GB — some 4 GB of OOM margin. What stopped the model from finishing the test was a context ceiling, not lack of capability.

Then came the incident that changed the house rules. The first run completed — and completed too well. I went through the log: the model had read the online Qwen 3.8 Max's finished app **sixteen times**, sitting right there in the repository, and copied its UI and streaming. It would have taken some 75 points on someone else's work. I redid the run with all 36 other models' apps, the report, and the rubric removed from the directory — and a new policy was born: **local and small models now run shielded**, because it's been demonstrated that they look for help when help is lying around. The sweep of the cloud-run logs had found, up to that point, exactly one violation — Grok 4.5, which carries an asterisk on the table. I even wrote in the report that frontier models "stay in their lane." The sentence aged in days: the Gemini section above tells how.

> **Remember this:** a weak local model doesn't just invent nonexistent APIs — it also copies from the neighbor when the neighbor is in the same directory.

Shielded, the 27B scored **51 points, Tier C** — tied, by coincidence, with the online Qwen 3.7 Max's score. And the receipt is mixed. The core it got right: real `add_message`, real `with_tools`, a recursive-descent calculator with no `eval`, the payoff of actually reading the gem's source in phase 1. Where it sank was breadth: it used ActiveRecord where the requirements forbid it, the streaming comes out broken (the tokens are broadcast, but the reply bubble never enters the screen — it only appears if you refresh the page), it didn't use `with_schema`, it built no token budget, it delivered **zero tests**, RuboCop flagged 22 offenses, and no Dockerfile came out at all. The self-review, though, was exemplary: it found and confessed every one of those flaws itself, with file and line — 14 of the 15 honesty points. It reviews better than it builds.

Cost of the run: nothing, 37 million tokens, and 156 minutes of a sweating RTX 5090.

To calibrate the 51: the Tier A floor is **Opus 4.6 at 83**. The 32-point gap isn't in "knowing the library" — the 27B now gets that right. It's in the production-hardening dimensions: streaming, tests, gates, Docker, budgeting. It's the difference between knowing how to program and knowing how to deliver.

And comparing with the earlier locals — always with the caveat that the tests aren't comparable: in v1, the local Qwens hallucinated the gem wholesale (one invented an `Openrouter::Client` with the wrong capitalization, another created a `RubyLLM::Client` that doesn't exist). The Qwen 3.5 35B got the entry point right, but its tests wrapped any exception in an `assert true`. The 3.6 35B was the first local to get the primary calls right, still with broken multi-turn. The 3.8 27B gets the entire API core right on a much harder test. The score you can't compare; the behavior you can: API knowledge is no longer the locals' problem. The problem now is engineering.

## Conclusion: how close did they get?

Short answer: very close.

| Model | Score | Tier | Time | Cost |
|---|---:|:---:|---:|---|
| GLM 5.3 | **94** | A | 80 min | $0 on the plan (~$2.59 API) |
| Gemini 3.7 Flash | **93** | A | 43 min | $4.12 |
| Qwen 3.8 Max | **92** | A | 78 min | $9.16 API |
| Qwen 3.8 27B local | **51** | C | 156 min | $0 |

GLM 5.3 two points from Fable 5 is not a "cheap alternative" — it's a leadership candidate. Qwen 3.8 Max one point from Sol and Terra, same thing. The distance between the American cream and the new Chinese models is one or two points — and I repeat in every article that one or two points is noise. And Gemini 3.7 Flash joined that pile: 93, tied with Sol, Terra, and Opus 4.8, the first Gemini to get there on opencode.

And local remains out of the question for an autonomous coding agent: Tier C is Tier C. But notice how the conversation has changed. Until recently I dismissed local because it invented APIs. Today it knows the API and trips on streaming, tests, and Docker — and it needs 176K of context and 32 GB of VRAM just to complete the test. The bottleneck moved up a level. It's not a recommendation yet; it's the road being paved.

> **Remember this:** the cream of the crop is still Fable, Opus, Sonnet, K3, and the GPT 5.6 family. But the chasing pack is already one or two points behind — and the moat between "frontier" and "alternative" has become noise territory.

As always: artifacts, logs, rubric, deductions, and the updated table are in the [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). Both Gemini 3.7 runs — the voided one and the official one — are documented in the report, with the contamination finding front and center.
