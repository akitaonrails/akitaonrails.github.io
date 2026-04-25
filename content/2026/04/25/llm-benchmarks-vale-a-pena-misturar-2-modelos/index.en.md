---
title: "LLM Benchmarks: Is It Worth ($$) Mixing 2 Models? (Planner + Executor)"
date: '2026-04-25T13:00:00-03:00'
draft: false
translationKey: llm-benchmarks-mixing-2-models-planner-executor
tags:
  - llm
  - benchmark
  - claude
  - ai
  - vibecoding
---

**TL;DR:** No. Across all three rounds of experiments I ran, mixing "strong frontier planner + cheap executor" loses to just using Opus 4.7 alone in a mature harness. **Solo Opus 4.7 in opencode delivers Tier A (97/100) in 18 minutes for ~$4 pay-as-you-go.** No multi-agent combination beats that on quality, and no combination is cheaper at the same time. The exception is Codex GPT 5.4 xHigh + `medium` executor, which drops from ~$16/run to ~$1-3/run while losing 3 quality points. Useful if you only have GPT in your provider stack. For everything else, **let the frontier model decide when to delegate on its own**, especially if you're on a Plus/Pro/Max subscription.

---

## Before we start: the five wrong premises

There's a narrative that shows up in my feed every week: "I'm saving money mixing Opus for planning with Kimi/Qwen/GLM/DeepSeek for execution." The premise is that the frontier model is too expensive to use for continuous coding, so you split the task: the expensive one thinks, the cheap one writes. Sounds reasonable. In practice, it's wrong on five fronts.

**First: most of the people saying this don't show their results.** Plenty of folks brag about orchestrating dozens of agents in parallel, fancy dashboards, elaborate flows. Ask them to show the app that came out of it, in production, generating value. Almost nobody delivers. **Ask for the result.** If they can't show real production, they're snake-oil sellers. My benchmark, with everything open, is the opposite of that: [the repo is public](https://github.com/akitaonrails/llm-coding-benchmark), the logs are auditable, the generated code is right there for inspection. That's the minimum bar for honest discussion about LLMs in coding.

**Second: the use case changes everything.** If you're doing a legitimate one-shot (Opus plans the architecture once, a cheap model executes many parallel pieces with well-defined scope, like generating 50 UI components following the same pattern), then it can make sense. But most people complaining about token cost are doing continuous coding-agent work, not massive one-shots. For continuous coding the math is completely different.

**Third: pay-as-you-go vs subscription completely changes the math.** If you pay per token directly on the API, every extra orchestrator prompt counts. If you pay $20 or $200 a month for Plus/Pro/Max and use Claude Code, Codex CLI or similar inside the subscription quota, the "cost per run" question disappears. It becomes "I'm consuming part of my monthly quota." Under subscription, the marginal cost of an extra call is zero until you saturate the cap. Coordinating two models to save tokens you're not being charged for is optimization against a non-existent cost.

**Fourth, and most important: you only realize the maturity of solo frontier models when you do full vibe coding.** I've written about this in several posts ([six-day immersion from zero to production](/en/2026/02/16/vibe-code-do-zero-a-producao-em-6-dias-the-m-akita-chronicles/), [how to talk to Claude Code effectively](/en/2026/04/15/como-falar-com-o-claude-code-efetivamente/), [Clean Code for AI agents](/en/2026/04/20/clean-code-para-agentes-de-ia/)). Serious vibe coding is: **turn off the IDE, don't edit code by hand, role-play as product manager + QA + tech lead mentor, let the model write**. When you do that, it becomes immediately obvious that mixing two models creates absurd coordination overhead. It's like outsourcing development to an offshore team but hand-editing every delivery because you nitpick everything. A plan that needs to spell out every line of code becomes micromanagement: if the plan already contains the code, why are you delegating? That's the extreme, but it's where most multi-agent setups land. Balance is what matters, and removing overhead is the main technique. For that, **a good frontier model inside a mature harness (Claude Code, Codex, opencode) is the path**.

**Fifth, and the most technical: premature optimization.** Donald Knuth warned us decades ago, "premature optimization is the root of all evil." The original rule: 97% of the time you don't have data to justify optimizing; when you do, it's only in the critical 3%. The 2026 version of that is spending a weekend wiring up an orchestration of five parallel agents to save $30/month in tokens, before you've validated whether the product you're building is even worth shipping. You're optimizing the cost of a pipeline that hasn't delivered anything yet. Focus on shipping. $20-200/month subscriptions are trivial compared to any other professional learning cost. People spend more on bad online courses or weekend partying. Once the product ships and token cost becomes a measurable problem, then yes, optimize. Today, focus on shipping.

OK, sermon over. Let's go to the numbers.

---

## Methodology in one line

Same benchmark as the [canonical version](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/): build a Rails 8 app with RubyLLM, Tailwind, Hotwire, Minitest tests, Brakeman, Docker, docker-compose. Same 8-dimension rubric with 0-100 scoring, same A/B/C/D tiers. The difference is that here every variant has **two models**: a "planner" (strong) and an "executor" (cheaper), in different harnesses (Claude Code, opencode, Codex). Everything in the [repo](https://github.com/akitaonrails/llm-coding-benchmark) with docs, dispatches, traces, audits.

Solo Opus 4.7 in opencode is the comparison baseline: **97/100 Tier A, 18 minutes, ~$4 pay-as-you-go.** Every multi-agent variant has to beat this (in quality, time OR cost) to justify the added complexity.

---

## What this benchmark does NOT prove (and what good delegation actually means)

Before diving into the three rounds, it's worth circling what this benchmark covers and what it doesn't. This matters because I'm going to draw strong conclusions about delegation, and those conclusions don't generalize to every kind of work.

### Limit 1: the project is a simple greenfield Rails build

The benchmark builds a Rails 8 chat app with RubyLLM. It's real code, with Tailwind, Hotwire, Docker and tests, but it's **a greenfield project with well-defined scope on a popular stack**. Practically every Tier A model nails it. In complexity terms, it's early-junior territory: there's no legacy code to understand, no technical debt to work around, no distributed system with 50 microservices to orchestrate.

For anyone who wants conclusive data about **their own** use case, the honest answer is: **adapt the benchmark harness to mimic your project's conditions and compare models there**. The [repo](https://github.com/akitaonrails/llm-coding-benchmark) is open source for exactly this reason. Take the prompt, swap in something that reflects your reality (50K-line legacy codebase, integration with 3 external systems, custom company DSL, whatever it is), and run the models the same way. The numbers I report here give direction, but any serious engineer should validate models against the work they actually do, not against an example chat app.

### Limit 2: parallelizable tasks vs dependency-laden tasks

The question "is mixing two models worth it?" depends critically on **what kind of work you're delegating**. There are two extremes.

**Work where frontier models delegate happily, and that will work beautifully:** numerous, simple tasks with little or no coordination needed. "Translate these 100 documents to English." "Summarize these 50 spreadsheets in bullet points." "Convert these 200 images to WebP at max 800px." Each item is independent. No revision is needed between them. The result of one doesn't change the input to the next. It's exactly the kind of work Amazon's Mechanical Turk was designed to distribute. Frontier models already do this on their own without explicit orchestration: ask Opus 4.7 to translate 100 documents and it'll fan out to parallel batches via the `Task` tool, scaling up or down as needed.

**Work where frontier models won't delegate, because it can't be delegated well:** tasks with many dependencies, requiring constant revision and mutual adjustment. Building a Rails app is exactly that. The `Chat` model depends on the `LlmClient` decision, which depends on the RubyLLM config, which depends on the `OPENROUTER_API_KEY` in env, which depends on `ENV` being loaded before the initializer, which depends on the Gemfile having the right gem. Touching one piece forces revising several others. This isn't Mechanical Turk work. It's cohesive engineering work, and Tier A models recognize that and keep everything inside one reasoning session. **That's why zero of the 7 runs in Round 1 delegated: the task wasn't delegable.**

### The async programming analogy

Anyone who learned async/await in a modern language went through the same disillusionment. You discover `Promise.all`, `asyncio.gather`, or similar, and start eyeing every slow piece of work looking for ways to parallelize. Then you write something like this and get angry:

```javascript
// Sequential chain: each step depends on the previous result
const userData = await fetchUser(userId);
const orders = await fetchOrdersFor(userData);          // ← needs userData
const recommendations = await analyzeOrders(orders);    // ← needs orders

// Total latency = latency(fetchUser) + latency(fetchOrders) + latency(analyze)
```

Three `await`s. Three I/O operations. You expected 3× faster from going async. But it's the same as synchronous because **each call depends on the previous one's result**. Trying to wrap this in `Promise.all` doesn't even compile: you can't pass `userData` to `fetchOrdersFor` before you have `userData`.

Promise.all only helps when the calls are **independent of one another**:

```javascript
// Independent calls: none uses another's result
const [user, allProducts, categoryTree] = await Promise.all([
  fetchUser(userId),       // ← doesn't need products or categories
  fetchAllProducts(),      // ← doesn't need user or categories
  fetchCategoryTree()      // ← doesn't need user or products
]);

// Total latency = max(latency of the three), not the sum
```

**The difference is not syntax; it's dependency structure.** In the first case, A → B → C: three operations in series, each waiting on the previous. In the second case, A | B | C: three independent operations that fire at the same time and the total latency is that of the slowest one. Async/Promise.all doesn't create parallelism, it only **exposes** the parallelism that was already there in the structure of the problem.

Multi-agent in coding is the same. If you give two models a cohesive task with internal dependencies (build a Rails chat app), the "planner" has to read every output from the "executor" before deciding the next dispatch, and the executor needs the context the planner built. You sequentialized the two. **Worse**: you added coordination overhead (prompt format, response parsing, watchdog, retry logic) on top of a pipeline that was supposed to have low overhead. It's like taking the three-sequential-`await` code and dropping a Redis queue in the middle: now you have 3× the latency **plus** the queue cost.

Parallelizable task = "apply this same refactor to 50 different files." There orchestration makes sense: one model plans the refactor once, describes it in reusable form, and dispatches 50 sub-agents in parallel to execute on each file. Real time savings. **Sequential task with dependencies** = building a cohesive app. There's no parallelization possible, and adding agents only adds overhead.

This benchmark tests the **second scenario**. If your daily work is the first (large batches of independent tasks), the conclusions here may invert. Adapt the harness, measure, decide.

---

## Segment 1: the initial round, models didn't delegate

The first round, in mid-April, configured 7 variants where the planner had a registered subagent available and aggressive prompt language pushing delegation ("Use PROACTIVELY", "ALWAYS delegate to this agent for code implementation"). The question: given that the subagent exists and is painted as the preferred path, will the main model delegate?

| Variant | Harness | Time | Cost | Delegations | Tier |
|---|---|---:|---:|---:|---:|
| `claude_opus_alone` | Claude Code | 11m | $6.74 | 0 | 3 |
| `claude_opus_sonnet` | Claude Code | 10m | $5.13 | 0 | 2 |
| `claude_opus_haiku` | Claude Code | 15m | $7.83 | 0 | 3 |
| `opencode_opus_glm` | opencode | 19m | ~$1.10 | 0 | 1 |
| `opencode_opus_qwen` | opencode | 30m | ~$1.10 | 0 | 1 |
| `gpt_5_4_multi_balanced` | Codex | 21m | ~$11 | 0 | 1 |
| `gpt_5_4_multi_faster` | Codex | 20m | ~$10 | 0 | 2 |
| **baseline** `claude_opus_4_7` | opencode | 18m | ~$1.10 | n/a | **1** |

**Zero delegations in zero of the 7 variants.** Claude Code's `Task` tool, opencode's task dispatcher, and Codex's `spawn_agent` were all completely ignored. In every case, the main model did 100% of the work.

Two things worth logging from this round.

**First:** aggressive prompt language doesn't persuade a model to delegate. "Use PROACTIVELY" is a weak word against the model's internal "this task is cohesive, I'll do it myself" instinct. In greenfield Rails, plan and implementation don't have a clean line. There's no atomically-delegable subtask.

**Second, and most surprising:** the same Opus 4.7 wrote **worse code in Claude Code than in opencode**, and cost **4 to 7× more** ($6.74 vs $1.10). Two of three Claude Code variants hallucinated a RubyLLM method that doesn't exist (Tier 3 hallucination); opencode with the same model got the API right and landed Tier 1. The harness itself influences the output. Claude Code resends much more context per turn, and that seems to nudge the model toward generic patterns while also inflating the bill.

Round 1 conclusion: **if the model is already delivering Tier A solo in the right harness (opencode), adding a subagent isn't even used.** The extra configuration is pure overhead. And if you force it inside Claude Code, you pay 4-7× more. The "savings" of multi-agency here is negative.

---

## Segment 2: the forced round, when the planner is forbidden from coding

The community pushed back on Round 1: "the subagent description was weak", "models don't trust unfamiliar subagents." Fair pushback. Round 2: explicit planner-executor prompt. **The planner is literally forbidden** from using `Write`/`Edit`/`Bash`. Every code change has to flow through the subagent via `Task` or `spawn_agent`. No fallback.

The full prompt is at [`prompts/benchmark_prompt_forced_delegation.txt`](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/prompts/benchmark_prompt_forced_delegation.txt). Mandatory workflow: `plan → delegate → converge → validate`. Seven variants:

| Slug | Planner | Subagent | Harness |
|---|---|---|---|
| `claude_opus_sonnet_forced` | Opus 4.7 | Sonnet 4.6 | Claude Code |
| `claude_opus_haiku_forced` | Opus 4.7 | Haiku 4.5 | Claude Code |
| `opencode_opus_kimi_forced` | Opus 4.7 | Kimi K2.6 | opencode |
| `opencode_opus_glm_forced` | Opus 4.7 | GLM 5.1 (Z.ai) | opencode |
| `opencode_opus_qwen_forced` | Opus 4.7 | Qwen 3.6 Plus | opencode |
| `gpt_5_4_multi_balanced_forced` | GPT 5.4 xHigh | GPT 5.4 medium | Codex |
| `gpt_5_4_multi_faster_forced` | GPT 5.4 xHigh | GPT 5.4 low | Codex |

Results:

| Variant | Score | Time | Cost | Tier | vs solo Opus (97) |
|---|---:|---:|---:|:---:|---:|
| `claude_opus_sonnet_forced` | 92 | 25m | $5.77 | A | -5 |
| `claude_opus_haiku_forced` | 90 | 19m | $3.49 | A | -7 |
| `opencode_opus_kimi_forced` | 95 | 25m | ~$2-3 | A | -2 |
| `opencode_opus_glm_forced` | 93 | 13m | ~$0.50 | A | -4 |
| `opencode_opus_qwen_forced` | 92 | (variable) | ~$0.50 | A | -5 |
| `gpt_5_4_multi_balanced_forced` | 94 | 30m | ~$1-3 | A | -3 |
| `gpt_5_4_multi_faster_forced` | 94 | 53m | ~$3-6 | A | -3 |

When forced, **delegation actually happens** (5 to 15 dispatches per run). All Tier A on code quality (90-95). But the important point is: **none beats solo Opus 4.7 on quality.** All cost extra time (minimum +7 minutes, up to +35 minutes for `multi_faster`). And on raw cost (pay-as-you-go), only two come in below solo: GLM (Z.ai subscription, basically free) and the GPT 5.4 multi (much cheaper than GPT 5.4 solo, but still in the same ballpark as Opus solo).

This round had two embarrassing harness findings. One was a watchdog firing too early, killing the benchmark before the cross-provider subagent finished spinning up (Z.ai and llama-swap took longer than expected to come online). I bumped the timeout from 6 to 15 minutes and GLM/Qwen came back at Tier A. The other: several models appeared to be "executing silently" (empty result envelopes). Only in Round 3 did I figure out that most of those were hidden errors — the `qwen3.6-plus:free` endpoint had been deprecated and was returning 404, and DeepSeek was 400-erroring with a protocol bug (details in its dedicated section below). The "1900 files" of `opencode_opus_deepseek_forced` were **entirely** written by Opus's `general` fallback, not DeepSeek.

OK, so accounting for the harness failures, the story becomes:

- **Sonnet/Haiku coders in Claude Code:** 90-92 vs solo Opus 97. Costs +1 minute to +7 minutes. Costs ~equal or more.
- **Kimi K2.6 in opencode:** 95 vs 97. Costs $2-3 vs $4, so 25-50% savings. +7 minutes.
- **GLM 5.1 in opencode:** 93 vs 97. Costs ~$0.50 with Z.ai subscription (basically free) vs $4 for solo Opus. -5 minutes.
- **GPT 5.4 + medium:** 94 vs 97. Costs ~$1-3 vs $16 for GPT 5.4 solo (80-85% cheaper). +12 minutes.

The last is the only configuration where forced delegation **actually pays off in absolute cost**: if you have to be on GPT 5.4, forced multi-agent is real savings. In every other case, you pay in quality and/or time to use a cheaper subagent. On Anthropic Pro monthly, solo Opus is $0 marginal. There's zero reason to use Sonnet/Haiku as a sub. Forced multi-agent there is theater.

And one last thing from this round: the "exception lesson", when forced multi-agent **repairs** Claude Code. Solo Opus in Claude Code came out Tier 3 (hallucinated `chat.complete`) at $6.74. Forcing Sonnet/Haiku as executor inside Claude Code repaired it to Tier A at $3.49-5.77. But the cleaner fix is to **switch harness**, not orchestrate. Solo Opus in opencode delivers Tier A at $4 with no fuss. The "orchestration repairs Claude Code" line is a workaround for a bug elsewhere.

---

## Segment 3: manual cross-process orchestration, Opus driving opencode

The third round was the most elaborate. Premise: take the subagent out of the planner's process (where the `task` envelope bug lived) and use opencode in single-agent mode invoked via subprocess for each subtask. The setup was a Claude Code session with Opus 4.7 in the orchestrator role. For each subtask, Opus wrote the prompt to a file, invoked opencode via Bash with the cheap model as sole primary, read the output, and decided the next dispatch.

No fallback. No `general` agent available for Opus to escape to. **Either the named executor writes, or nothing gets written.**

Three variants attempted:

### Opus + Qwen 3.6 Plus (Variant 1): 94/100 Tier A

Setup: 8 dispatches + 1 fix-up = 9 dispatches total. ~$0.74 executor cost. ~12 minutes cumulative wall time **for the executor only**. Plus the planner overhead (Opus in Claude Code orchestrating) which isn't directly measured but is estimated at $11 (more on this below).

Qwen 3.6 Plus behavior as executor: truncates the final summary in 3 of 9 dispatches, sometimes emits zero text but does many tool calls (dispatch 8: 14 tool calls, 0 text turns), made smart adaptations on its own (manually created `app/javascript/` after Rails 8.1 didn't generate it, swapped `root_url` for `get "/"`, created tailwind.css placeholder). But needed 2 fix-up dispatches for issues caused by Rails 8.1 generator behavior changes.

Auditor's read: *"Qwen wrote the lines, Opus decided the boundaries, and the boundaries are most of what lifts this from B to A."*

Result: **94/100 Tier A. +23 points over Qwen 3.6 Plus solo (71/100, Tier B).** But the entire lift comes from Opus's detailed plan, not from autonomous Qwen capability.

### Opus + Kimi K2.6 (Variant 2): 97/100 Tier A, TIES SOLO OPUS

Setup: 5 dispatches, **zero fix-ups**. ~$0.37 executor cost. ~10 minutes cumulative executor wall time. Full end-to-end validation (local boot, docker compose up + curl + clean teardown).

Kimi K2.6 behavior: coherent text response per dispatch with no truncation, strong autonomous adaptation (caught Stimulus + Tailwind install gaps without explicit prompting, caught the layout-wrapping side effect of `tailwindcss:install`), zero fix-up dispatches.

Result: **97/100 Tier A. TIES Opus 4.7 solo.** Auditor's read: *"Kimi wrote every line, but Opus's planning prompts shaped what to ask for (better test fixtures, error-path coverage, persistence design), pushing Kimi from 87 → ~97."*

### Opus + DeepSeek V4 Pro (Variant 3): FAILED

Structural harness incompatibility bug. DeepSeek V4 Pro returns `reasoning_content` on every response, and opencode strips that field when constructing the next request. The DeepSeek API then rejects turn 2 with `"reasoning_content must be passed back to the API"`. Tested three `reasoning` configurations (`true`, `false`, absent). All failed identically at turn 2 of dispatch 1. There's no opencode flag that fixes it. Workarounds (custom OpenRouter provider params, single-bash-per-dispatch protocol, switching to V4 Flash) were not pursued.

Retroactive implication: the supposed "completions" of DeepSeek in rounds 2 and 2.5 were **entirely** written by Opus through the `general` fallback. DeepSeek V4 Pro contributed zero lines of code in any configuration of this benchmark to date.

### The hidden planner cost

Here's where things get ugly. The two manual variants that actually ran (Qwen and Kimi) had **~14 successful dispatches combined**. Each dispatch consumed ~3-5 turns of the Opus orchestrator (read previous dispatch output, plan next, write prompt file, monitor execution, verify filesystem). Each turn costs ~$0.15-0.25 in Anthropic tokens. Total: **~$11 of hidden planner cost**, not logged in the executor JSON.

Real total cost of the two manual variants: ~$1.11 executor + ~$11 planner = **~$12 combined**. Compared to solo Opus opencode at $4. **Manual orchestration costs 3× more than solo.**

### What this round actually proves

| Executor | Solo score | Lift under Opus orchestration |
|---|---:|---:|
| GLM 5.1 | 46 (Tier C) | +47 → 93 (Tier A) [via in-process forced 2.5] |
| Qwen 3.6 Plus | 71 (Tier B) | +23 → 94 (Tier A) [via manual orchestration] |
| Kimi K2.6 | 87 (Tier A) | +10 → 97 (Tier A, ties Opus) [via manual orchestration] |

**The lift scales inversely with the executor's solo capability.** The further from Tier A solo, the more orchestration adds. Kimi solo is already Tier A, so the +10 is polish (better test fixtures, error coverage, persistence). GLM solo is Tier C because of one specific hallucination (invented fluent DSL), and prescriptive prompts that name the real API remove the hallucination entirely.

**But the cost of that lift is dominated by the planner.** If you only have access to GLM (not Opus), this finding doesn't help you. If you have Opus AND GLM, just use Opus solo for less money and time.

The realistic use case for this pattern is: **multi-tenant deployment where the planner runs once and is amortized across many similar subtasks** (like "apply this same refactor to 50 different files"). Greenfield Rails benchmark doesn't capture that.

---

## Final comparison: the 3 rounds vs solo

All costs below are **total (Opus planner + executor)** in pay-as-you-go. End-to-end wall times:

| Variant | Score | Wall time | Total cost | Δ quality vs solo (97) | Δ cost vs solo ($4) | Δ time vs solo (18m) |
|---|---:|---:|---:|---:|---:|---:|
| **Opus 4.7 solo (opencode)** | **97** | **18m** | **$4.04** | baseline | baseline | baseline |
| Opus + Kimi (manual) | 97 | 30-40m | ~$5-7 (planner ~$5 + executor $0.37) | =0 | +$1 to +$3 | +12-22m |
| Opus + Sonnet 4.6 (CC, forced) | 92 | 25m | $5.77 (Claude Code log) | -5 | +$1.73 | +7m |
| Opus + Haiku 4.5 (CC, forced) | 90 | 19m | $3.49 (Claude Code log) | -7 | -$0.55 | +1m |
| Opus + Kimi (in-process forced) | 95 | 25m | ~$3-4 (planner ~$2-3 + executor ~$0.50) | -2 | -$1 to 0 | +7m |
| Opus + GLM 5.1 (forced, watchdog fix) | 93 | 13m | ~$0.50 + Z.ai sub | -4 | -$3.50 + sub | -5m |
| Opus + Qwen 3.6 (manual) | 94 | ~40m | ~$6-7 (planner ~$5 + executor $0.74) | -3 | +$2 to +$3 | +22m |
| GPT 5.4 xHigh + medium (Codex forced) | 94 | 30m | ~$1-3 (Codex log, both GPT) | -3 | -$1 to -$3 | +12m |
| GPT 5.4 xHigh + low (Codex forced) | 94 | 53m | ~$3-6 (Codex log, both GPT) | -3 | -$1 to +$2 | +35m |

(Tier D / 0-file failures omitted.)

The orchestrator-Opus planner cost on the "Opus + Kimi (manual)" and "Opus + Qwen (manual)" rows is a **hidden** cost: it shows up in the Claude Code session driving the experiment, not in the executor log. The ~14 successful dispatches from the two manual variants combined consumed ~$11 of Opus, split between them, landing at ~$5-6 each.

**Solo Opus 4.7 in opencode is the best on every metric:** it ties or beats every other variant on quality, cost OR time, and ties or beats most on all three simultaneously.

The real exception is **Codex GPT 5.4 xHigh + medium executor**: 94/100 vs 97/100 (loses 3 points), but costs $1-3 instead of $16 for GPT 5.4 solo (80-85% cheaper). Useful if you only have OpenAI credentials and need cheap Tier A.

Every other variant loses on at least one important dimension. Most lose on two (quality AND time, or quality AND cost).

---

## The subscription question

The numbers above are **pay-as-you-go**. Let's add subscription to the picture.

Anthropic Pro at $200/month includes Opus 4.7 with [20× the Plus quota](https://help.openai.com/en/articles/20001106-codex-rate-card). In practice, that's many full benchmark runs per day without touching the cap. OpenAI Plus at $20/month or Pro at $200/month includes Codex CLI with similar economics. Under subscription, **a benchmark run adds zero marginal cost** until you saturate the quota.

What does that change?

- Solo Opus 4.7: $4 pay-as-you-go becomes $0 marginal on Anthropic Pro. **Still the best.**
- Multi-agent with Sonnet/Haiku via Claude Code: $3.49-5.77 becomes $0 marginal on Anthropic Pro. Still loses 5-7 quality points. **Not worth it.**
- Multi-agent with Kimi/GLM/Qwen via opencode (which charges separately via OpenRouter): adds $0.50-3 in OpenRouter cost on top of the subscription. Loses 2-7 quality points. Equal or longer time. **Not worth it.**
- Codex GPT 5.4 + medium: $1-3 becomes $0 marginal on ChatGPT Pro. But solo GPT 5.4 also becomes $0 marginal. **Multi isn't worth it.**
- Manual cross-process (Opus driving opencode with Kimi): $0 marginal (planner on Anthropic Pro) + $0.37 (executor on paid OpenRouter) = $0.37. Costs 30-40 minutes vs 18 for solo. **Ties on quality. Not worth it.**

Under subscription, **no multi-agent configuration beats solo frontier.** Marginal cost of an extra call is zero for someone already paying the monthly subscription. Extra coordination doesn't compensate when the "savings" is zero.

---

## The least-bad case: Opus + Kimi K2.6 under heavy use

Since I'm being skeptical on every conclusion, it's worth noting separately the one non-obvious configuration where Opus + Kimi K2.6 might actually make sense in practice: **continuous heavy use that already saturated the Anthropic Pro monthly quota.**

In forced in-process mode (Round 2.5 with adjusted watchdog), Kimi K2.6 delivers 95/100 vs Opus solo's 97. The 2-point difference is usually polish in test fixtures and error handling, things you can patch later. In exchange, you pay ~$2-3 of OpenRouter on Kimi instead of burning Pro quota on Opus. For power users hitting the $200/month Pro cap regularly (multiple times a week, heavy parallel projects), redirecting some work to Kimi can free up Pro quota for tasks that really need Opus.

It's a narrow exception. For most people who haven't saturated Pro, just using solo Opus is still better. And for those without Pro yet, the savings from orchestrating Kimi + Opus will be equal to or less than just subscribing to Pro. But for the "I'm using a coding agent professionally and heavily and I'm blowing the monthly cap" scenario, the Opus planner + Kimi executor configuration is the best option I measured in this benchmark.

Worth mentioning also is the **multi-tenant case where the planner is amortized**: if you're running a pipeline that applies the same change pattern to many similar projects (refactor 50 repos to use a new convention, generate 30 microservices with the same skeleton), Opus plans once, you save the plan, and Kimi executes against each project. The planner cost dilutes across volume and the pairing makes real economic sense.

---

## Why DeepSeek was the hardest model to test

Worth logging separately, because it's the most frustrating case in the whole benchmark. DeepSeek V4 Pro **never contributed a single line of code** in any of the three multi-agent rounds, despite showing up in several experiments as "completed".

The root cause is a protocol incompatibility between the DeepSeek API and the ai-sdk that opencode uses underneath. DeepSeek V4 Pro runs in thinking mode by default. Every response it returns includes a `reasoning_content` field with the model's internal chain of thought. **The DeepSeek API then requires that `reasoning_content` to be echoed back in the message history of the next request.** Without it, the server responds with 400 and this specific message:

> `The "reasoning_content" in the thinking mode must be passed back to the API.`

Opencode's ai-sdk, when constructing the next request, **strips `reasoning_content`** from the message history. Every multi-turn call to DeepSeek V4 Pro via opencode fails on turn 2.

What makes this invisible on the surface is that opencode doesn't bubble that 400 to the user. It buries the error in the event stream and keeps going. When you look at the run result, you see files being written and tasks "completing." But if you inspect the trace, you find that most (or all) came from the `general` fallback agent, which is Opus 4.7 itself. The DeepSeek that was supposed to be doing the work wrote nothing.

I tested three `reasoning` configurations in opencode (`true`, `false`, absent). All failed identically at turn 2 of dispatch 1. No config flag fixes it. Workarounds that were out of scope:

- Custom OpenRouter provider params via header
- Single-bash-per-dispatch protocol (which would dodge multi-turn)
- Switch to DeepSeek V4 Flash, which doesn't use thinking mode

This forces a retroactive correction of earlier conclusions. In [an earlier post](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) I described DeepSeek V4 Pro as having "Tier 1 code, but DNF in the harness." That description was incomplete. **DeepSeek V4 Pro is fundamentally incompatible with any ai-sdk-based harness** (which includes opencode, and probably several other tools that use the same SDK underneath). The model can write good code solo if you invoke the API directly with proper thinking-mode handling. But in any real coding-agent pipeline that uses ai-sdk, it doesn't work in multi-turn.

Practical result: DeepSeek V4 Pro is unmeasurable in this benchmark. The only configurations where it appeared as "successful" had Opus writing in its place. For future benchmarks, I'll either swap to V4 Flash (which avoids thinking mode) or build a custom harness that echoes `reasoning_content` correctly.

The broader lesson: **the maturity of tooling around a model matters as much as the model's quality.** DeepSeek V4 Pro might have excellent solo code, but if you can't use it without writing your own harness, it loses to Kimi K2.6 which works out of the box.

---

## Conclusion

Multi-agent on continuous coding agent work is **premature optimization in disguise**. You spend a weekend wiring up an orchestration of five models, five harnesses, five different token counters, only to land at a result that's equal or worse than solo Opus in opencode. And worse: while you're orchestrating, you're not shipping product.

The data:

- Solo frontier model (Opus 4.7 in opencode) delivers **Tier A 97/100 in 18 minutes for $4 pay-as-you-go**.
- Trying multi-agent without forcing: the model doesn't delegate, you pay harness overhead for nothing.
- Forcing multi-agent: equivalent quality at more time and equal or higher cost. The one real exception is Codex GPT 5.4 + medium for cutting GPT cost.
- Manual cross-process orchestration: ties on quality at best (Opus + Kimi → 97), but doubles wall time and triples total cost when you account for the planner.
- Under monthly subscription: the marginal cost of an extra call is zero for solo frontier. Multi-agent has no economic advantage.

Practical rule: **pick a good frontier model (Opus 4.7, GPT 5.5, GPT 5.4 xHigh), use it in a mature harness (opencode respects the model the most, Codex is the official one for GPT, Claude Code if you accept the context pollution), and optimize the prompt instead of the orchestration.** Current models already decide on their own when to split a task into parallel subtasks (Claude Code has the `Task` tool, Opus uses it when it needs to). No need to force it.

And to close the subscription argument: **$20-200 per month is trivial.** It's less than what most people spend on bad online courses, streaming subscriptions, or weekend partying. In serious professional use, that pays back 5-10× on the first real project. If "$200/month" feels like a lot, the problem isn't the LLM, it's the ROI of what you're building. Which is exactly where you should be focusing before orchestrating agents to cut $30 in tokens.

Focus on shipping. Token optimization comes later.

---

## Sources

- [Benchmark repo](https://github.com/akitaonrails/llm-coding-benchmark) — code, prompts, configs, all the logs
- [Round 1 multi-model report](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.multi_model.md) — 7 free-choice variants, zero delegations
- [Round 2 forced-delegation audit](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.multi_model_forced.md) — 7 forced variants, 0-100 rubric
- [Round 3 manual orchestration](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.manual_orchestration.md) — Opus driving opencode in subprocess, Kimi/Qwen/DeepSeek
- [Orchestration traces](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/orchestration_traces.md) — per-variant forensic walkthroughs
- [Forced-delegation prompt template](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/prompts/benchmark_prompt_forced_delegation.txt)
- [Canonical benchmark (April 2026)](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) — solo runs of 23 models, 8-dimension rubric
- [Vibe code: from zero to production in 6 days](/en/2026/02/16/vibe-code-do-zero-a-producao-em-6-dias-the-m-akita-chronicles/) — full immersion in practice
- [How to talk to Claude Code effectively](/en/2026/04/15/como-falar-com-o-claude-code-efetivamente/) — role-play as PM/QA
- [Clean Code for AI agents](/en/2026/04/20/clean-code-para-agentes-de-ia/) — instruction guide for the model
