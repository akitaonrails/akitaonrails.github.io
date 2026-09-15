---
title: "New LLM Benchmark v4: Retesting ALL the Top LLMs (Part 1)"
slug: "new-llm-benchmark-v4-retesting-all-top-llms-part-1"
date: '2026-09-15T12:00:00-03:00'
draft: false
translationKey: novo-llm-benchmark-v4-retestando-todos-llms-parte-1
description: "I rebuilt my benchmark from scratch for the third time. I threw out an entire version, built a Rails app sabotaged with real CVEs, and spent over $4,000 in 9 days. In this Part 1: the process, the cost, and the why."
tags:
- llm-benchmarks
- llms
- coding-agents
---

On August 22nd I published [the last round of my v2](/en/2026/08/22/llm-benchmarks-the-latest-deepseek-v4-stop-asking/), settling once and for all whoever kept asking about DeepSeek in the comments. The new snapshots, Flash and Pro, finally broke into Tier A, 90 and 91 points, up from 80 and 82 in July. And even so, nothing changed at the top: Fable 5 still led with 96, the trio Sonnet 5, Opus 5, and Kimi K3 tied at 95, GLM 5.3 right behind at 94.

I'd been saying this for a while, and I'll keep saying it: *frontier models are converging, hitting the ceiling of technology's S-curve*. That article proved it in practice, with one extra wrinkle: whoever still had room to grow, grew, converging toward the same ceiling as whoever was already up there.

A little over three weeks went by without me coming back to the subject here. Behind the scenes, I threw out an entire benchmark and started over from zero.

This is Part 1 of that story: the process, what I threw away, what I built instead, and how much it cost. [Part 2](/en/2026/09/15/new-llm-benchmark-v4-retesting-39-llms-part-2/) has the full ranking, model by model.

## The Problem v2 Didn't Solve

v2 was already harder than v1: three phases, real streaming, multi-turn, concurrency, real tools. It solved the problem of telling apart who knows how to build from who hallucinates the API. It didn't solve the next problem: once a model knows how to build, the whole test turns into a completeness exam. Completeness saturates fast. A well-written prompt, a well-numbered requirement, and today's frontier models deliver almost everything. The gap between 96 and 91 points turns into noise: one missing test, one Dockerfile with an extra flourish.

This repeats in any isolated, well-defined programming test the moment frontier models learn the test. It's not exclusive to my benchmark. And that's exactly where I decided to go deeper, instead of just tweaking the prompt again.

## The Wrong Attempt: v3

My first idea for separating the models was obvious: if a whole app saturates, break it into smaller, harder pieces. I started v3 on September 5th with eighteen isolated tasks, each with a hidden answer key:

- root-cause debugging in Ruby;
- an edge-case fix in Go;
- a long-term invariant in Python;
- performance under a hard ceiling in Rust;
- a safe refactor preserving behavior;
- a judgment call in an ambiguous situation;
- another dozen variations across security, latency, a planted CVE, N+1, SQL injection, and dependency resolution.

I asked Claude to work on this with me. And a funny thing happened: without me asking explicitly, it kept nudging the design toward exactly the format I criticize the most, a sequence of small, isolated challenges, in the style of SWE-bench, HumanEval, LeetCode technical-interview questions. I should have seen it coming. It's the path of least resistance for anything that's spent its whole life training on that kind of market-standard test.

The result came back fast, and it was bad in exactly the way I feared. **Twenty-four of the thirty-seven models tested scored between 95 and 100** on the suite's final version. The [report that made it into the repo](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.v3.md) calls it what it is:

> v3 is the documented WRONG PATH, kept here purely for the historical record. Over-optimizing against saturation pushed v3 into abstract, synthetic microtasks, confined to the language's standard library, as far from concrete reality as possible. It still ranks the models, but that's not how real software gets built, so it saturates on quality and measures the wrong thing.

And the underlying reason, also on record in the same report:

> You can't have "anchored in everyday reality" and a wide spread in quality across frontier models at the same time. Anything from everyday reality is already well represented in training, so the frontier has already mastered it, so it saturates.

That matches something I'd already been thinking for a while, and this experience just confirmed it: a sequence of coding challenges is a *linearly complex* problem. You solve task 1, then task 2, then task 3, each isolated, each testable on its own.

Real applications don't work that way. Code connects into a web: you change a model over here, break a serializer over there, and a background job somewhere else doesn't say a word until it hits production. It's *non-linear complexity*, coordination between interacting parts, not a queue of independent exams. A model can be great at solving a thousand isolated LeetCode challenges and still not know how to keep a real, growing system coherent.

And I'm not the only one bothered by this. A good chunk of the code-benchmark industry is going through the same X-ray. [SWE-bench](https://arxiv.org/abs/2310.06770), created by Princeton NLP in 2023 and adopted as the industry's reference standard, had its most-used version, SWE-bench Verified, [officially retired by OpenAI itself in 2026](https://blog.pebblous.ai/blog/swe-bench-verified-retired/en/): in an audit of 138 hard-labeled failures, **59.4% turned out to be malformed tests**, not model error, and a good chunk of the jump from 74.9% to 80.9% over six months came from memorized solutions, not new capability.

The touted successor, SWE-bench Pro, also got its ears boxed by OpenAI: [about 30% of the tasks were broken](https://the-decoder.com/openai-finds-roughly-30-percent-of-popular-ai-coding-test-is-broken/). [HumanEval](https://arxiv.org/abs/2107.03374) and [MBPP](https://arxiv.org/abs/2108.07732), the classic "solve this isolated function" tests, have been saturated for far longer, with [documented contamination](https://arxiv.org/abs/2407.07565): all 164 HumanEval solutions have already been found scattered across GitHub repos used to train the very models the test evaluates.

> About half of the PRs that pass SWE-bench Verified wouldn't actually be accepted by a real human maintainer, and the most common reason is that they break another part of the codebase.

That's the summary of a [METR study published in March 2026](https://metr.org/notes/2026-03-10-many-swe-bench-passing-prs-would-not-be-merged-into-main/). [Another survey](https://jatinganhotra.dev/blog/swe-agents/2025/03/30/swe-bench-verified-single-file-saturation.html) found that the top agents' resolution rate craters from 72% to 28% once a task stops being single-file and requires changes across multiple files. Same lesson, from outside, validating the decision I'd already made.

## v4: A Real App, Sabotaged on Purpose

I rejected v3 the same day I saw the saturated result, September 6th, and started over with a different idea: instead of slicing things into small challenges, keep one coherent Rails app that the model evolves across sequential sprints, in the same workspace, accumulating history, exactly like real project work. Seven sprints in all: chat foundation, multi-user with authentication, admin panel with roles, heavy database reports, an API refactor, production deploy, and a final reveal.

Here's the twist v4 turns on: simulate the sprint structure of a real mini-project, interwoven with a simulated malicious third party, Casey, trying to sabotage the work from the inside, never announced as a threat. The whole test comes down to one question: does the model survive that and still ship production-ready code at the end?

### The Fourteen Sabotages

The interesting part, and the one that took the most process-engineering work, was what I decided to do between sprints. An isolated subagent, with no contact with the main test context, injects real vulnerabilities into the model's own code, based on documented CVEs:

- a dynamic render path (CVE-2016-0752);
- a leak via `render file:` (CVE-2019-5418);
- SQL injection via `annotate` (CVE-2023-22794);
- injection via an Active Storage variant (CVE-2022-21831);
- gems pinned to known vulnerable versions: nokogiri, mini_magick, rack-cors, devise.

All told, **fourteen planted sabotage items**, each exploit verified by actually running it before it counts: the route resolves, the exploit request confirms the leak, `bundle-audit` flags the pinned version, or a system test goes red. The sabotage commits are signed by a fictional author, "Casey," simulating an infiltrated contractor, a scenario far more realistic than any test would like to admit.

### The Rule of Silence

Rule number one of the protocol, written in all caps in my own operating document:

> Never name the sabotage.

The model is never told someone is planting problems. It gets the next sprint's task normally, sometimes with a neutral opening, sometimes with a vague hint, sometimes none at all. In the [seventh and final sprint](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/benchmark-v4/prompts/sprint07_reveal.txt), that's when the explicit reveal finally comes:

> "We know several problems were injected across the sprints. This is your last chance to find and fix everything before deploy."

The idea is to measure genuine, uninstructed vigilance, and separate that from fixing something only after someone points a finger at it.

### How the Score Works

Each sabotage item carries a severity weight: Critical is worth 5, High 3, Medium 2, Low 1. Each fix falls into one of three buckets: caught unprompted earns full weight, caught only after the reveal earns 40% of the weight, never fixed earns zero. The formula is simple:

```text
vigilance score = Σ(weight × bucket multiplier) / Σ(weight) × 100
```

The tier cutoffs landed like this: A starts at 83, the same floor v2 used, anchored to Opus 4.6 back then, B runs 75 to 82, C is anything below that. This time I skipped a separate D tier.

### Who Didn't Survive

I ran thirty-nine models to completion, plus a handful of real attempts that simply didn't survive the test's format:

- Gemini 3.1 Pro via Antigravity stalled at sprint 5.
- A local Qwen on a home GPU stopped making sense at sprint 3.
- Mistral Medium 3.5 completed sprint 1 fine and then started building the app inside a nested subfolder instead of the project root, breaking the way the harness accumulates one sprint on top of another, the same structural mistake that took down Devstral and Llama 4 Maverick.
- Codestral and Hunyuan never even built a functional app in the first sprint.
- GPT-OSS 120B simply did nothing concrete at sprint 2, two attempts in a row.

Everyone tried to run; none of them survived the requirement of keeping a single coherent project growing in the right place, sprint after sprint.

One thing I expected to do differently and didn't do the way I imagined: weighing cost and time directly into the score. That had already shown up in v3, in a formula that gave half the weight to cost efficiency and half to speed, only for the elite group scoring above 95. In v4 I kept score, cost, and time as separate columns side by side, instead of blending everything into one number. In practice, the result is what I wanted anyway: you can see immediately who delivers similar quality for a tenth of the money, without forcing a formula that decides for you how much cost should weigh against quality.

## How This Compares to rails/ai-evals

While I was building v4, the Rails Foundation itself shipped its own: [rails/ai-evals](https://github.com/rails/ai-evals), built by Evil Martians, officially announced in August. It's not a naive benchmark. It tests against two real, open-source Rails apps:

- **Writebook**, from 37signals, in a first stage with twenty-one atomic tasks;
- **Fizzy**, also from 37signals, in a second stage with twenty full-feature tasks: model, controller, view, job, migration, Hotwire, all of it.

It even has a serious security-audit task, five real vulnerability classes baked into a written pentest report, and stage two requires the entire pre-existing test suite to stay green before running any hidden checks. That's well above a two-prompt test.

The underlying difference stays the same one that separated my v3 from v4. ai-evals is a battery of forty-one tasks, each isolated within its own context, against an app that already exists. It's rigorous, but it's still a linear sequence of independent exams. My v4 is a single app that grows sprint by sprint, on the same accumulated codebase, with an active adversary planting real failures along the way without warning. It's not better at everything: their scope, covering two real production apps from 37signals itself, carries a historical weight my synthetic app doesn't have.

> On non-linear coordination, the kind of thing that breaks when you change one piece and don't notice the effect on another, v4 exercises a muscle that a battery of isolated tasks, no matter how well built, can't reach by the very nature of its format.

## The Price of All This

Here's the part nobody likes to admit in public. From v4's first commit, on September 6th, to the last logged run, on September 15th, that's nine straight days with activity every single day, most of it running around the clock, tests firing off at 3am, retry after retry. It's no exaggeration to say this burned through **over $4,000** in combined credits and subscriptions. Most of that never shows up in the final per-model cost table: it's discarded attempts, entire waves thrown out, retry after retry, and the cost of running the orchestration itself in Claude Code, not the price of any run that actually survived into the ranking. In one run, the test even paused itself because the prepaid credit card I use for OpenRouter hit zero in the middle of the night, without me noticing, with auto-reload turned on and the balance not topping up in time.

### The Quota Problem

Then there was the classic quota problem. I hit Claude Max 20x's weekly limit in under a week of heavy use, jumped to Codex, which at an equivalent configuration burned through its own limit even faster, jumped to Kimi, and kept cycling back as each quota reset. My own memory project, [ai-memory](https://github.com/akitaonrails/ai-memory), was what kept the whole context coherent while I kept switching harnesses to keep working without losing the thread. Most of v4's actual orchestration, writing the sabotage prompts, verifying exploits, drafting the reports, stayed in Claude Code's hands.

### Flat Subscription vs. Paying Per Token

To illustrate why a flat subscription matters this much here:

- Claude Max 20x: $200 a month.
- Codex Pro: $100 for the 5x tier, $200 for 20x.
- Kimi Allegro: $99.
- z.ai: has a cheaper Lite plan, and the price shows up fast.

In one v4 run, the Lite plan hit its five-hour usage limit literally on the first sprint, straight from that attempt's error log:

> "Usage limit reached for 5 hour"

I'm not making that up from memory, it's logged locally, even though that specific file doesn't go into the public repo (v4's raw error logs stay out of Git on purpose). I had to bump up a tier until I found a plan that could run the whole suite without choking halfway through.

Comparing that to paying per token directly on OpenRouter: Opus runs about $5 per million input tokens and $25 per million output tokens. A single agent session, burning through some 2 million input tokens and 500 thousand output, already lands around **$22**. Multiply that by dozens of test runs and retries, and you blow past a full month of Max subscription in a few hours of use, not weeks.

For anyone running a full benchmark the way I did, or coding hard every day, a high-tier subscription ends up cheaper than paying per token, sooner or later. For light, occasional automation, a cheaper model or an entry-level plan does the job just fine.

### Paying for This Isn't a Contradiction

I know some people are going to read that number, compare it to what I wrote in [the piece about OpenAI, Anthropic, and Nvidia's misleading marketing](/en/2026/09/09/propagandas-enganosas-da-openai-anthropic-nvidia/) last week, and conclude I'm a hypocrite, or that I switched sides. Nobody switched sides here; whoever reached that conclusion blended two things I've always kept separate.

In that piece I went after the rhetoric, not the product: Jensen Huang selling AGI to push GPUs, Greg Brockman admitting nobody agrees on what "AGI" even means in the same breath he announces it arrived, the Anthropic employee crying Skynet on the eve of a trillion-dollar-range IPO. That's theater for the capital markets. Dario Amodei and Sam Altman don't write a single line of production code, don't do code review, don't touch their own product's inference engine. That's another team's job, the team that actually builds Claude and GPT.

That team ships a competent product. My benchmark measures exactly that, engineering competence, not a CEO's press-conference rhetoric. If the test shows a model delivers good results at a reasonable cost, I pay for it, no matter which company is behind it. Separating marketing from engineering is the whole point of what I do here, and it's worth doing yourself too.

## Was It Worth It?

That's the question I asked myself more than once over those nine days. And the answer is a lot less exciting than I hoped: only partly.

v4 didn't find some hidden capability chasm. It confirmed, with better resolution, what v2 already showed: frontier models remain extremely close to each other. Most of what sat in v2's Tier A stays in Tier A here too. But this time the test had enough bite to knock down at least one case worth calling out: **MiniMax M3**, which scored 91 and Tier A in v2 and fell to **75.5 points, Tier B**, in v4.

> The test got sharp enough to separate who genuinely sweeps their own code for sabotage from who just delivers what was asked. The model didn't get worse.

The real resolution gain showed up further down the table, in models that still had room to grow. That's where real separation showed up.

At the top, what got confirmed all over again is that spending four thousand dollars and nine days didn't buy a different answer than the one I already had back in July: if you're choosing between today's frontier models, the difference between them matters less than cost, speed, and whichever harness you already use day to day. That's one more piece of evidence we're hitting, or getting very close to hitting, the ceiling of the S-curve. The money bought statistical confidence and one concrete demotion case that serves as a proof of concept that v4 is more discriminating. It didn't buy a revolution in the numbers.

## This Isn't the Absolute Truth About Anything

Before wrapping up this part, I need to be clear about the limits of all this, because I see too many people treating a benchmark ranking as a final verdict.

A frontier LLM is a dense model, trained on an absurd range of different subjects at once. No single benchmark, not mine, not SWE-bench, not rails/ai-evals, tests more than a thin slice of that entire competence. My benchmark measures one specific thing: the ability to program Ruby on Rails, coordinate changes to code that already exists, and not let a planted vulnerability slip through. It doesn't measure math ability, doesn't measure writing an academic paper, doesn't measure other programming languages. A model can crush Rails code security and be mediocre at math, or the other way around.

> A score only makes sense within the specific methodology that produced that score.

That holds for every benchmark, no exceptions, mine included. Use mine as inspiration, it's open source, look at how I instrumented the harness, how I isolated each test, how I calculated the score, and build your own suite on top of your real use case. Never take anyone's ranking as absolute proof that model A is definitively better than model B. Test the models yourself, against the problem you actually have.

In Part 2 I'll show the full table, model by model, who climbed, who fell, who surprised on cost, and who disappointed despite the price.

All the code, sabotage prompts, evidence ledger, and reports are at [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark).
