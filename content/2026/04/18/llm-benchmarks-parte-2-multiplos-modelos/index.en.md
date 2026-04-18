---
title: "LLM Benchmarks Part 2: Is It Worth Combining Multiple Models in the Same Project? Claude + GLM??"
date: '2026-04-18T14:00:00-03:00'
draft: false
slug: llm-benchmarks-part-2-multi-model
translationKey: llm-benchmarks-part-2-multi-model
tags:
  - llm
  - benchmark
  - claude
  - ai
  - vibecoding
---

**TL;DR:** Yes, the title is clickbait. The answer is no, it's not worth it. Keep using Claude Code with Opus 4.6 or 4.7. Details below.

---

A few weeks ago I wrote a [detailed LLM coding benchmark](/en/2026/04/05/testing-llms-open-source-and-commercial-can-anyone-beat-claude-opus/) comparing 33 open source and commercial models on the same test: build a Rails app using RubyLLM. The conclusion was that only 4 models generated code that works on first try (both Claudes, GLM 5, and GLM 5.1), and that for anyone who doesn't want to waste time fixing API hallucinations, Claude Opus via Claude Code remains the most rational choice despite the price.

This article is a follow-up. I'll keep that benchmark updated as new models come out (Opus 4.7, Qwen 3.6, GPT 5.4 via Codex are already in). This one tackles a different question that shows up in my feed every week: **what if I combine two models in the same project? Opus to plan, GLM to execute. Does that work?**

Short answer: no, it doesn't. Long answer is the rest of this article.

## First: a word about Opus 4.7

There are people on Reddit claiming Opus 4.7 is an absurd downgrade from 4.6, that it regressed, that it "got worse at coding". I get suspicious whenever I see "everything's getting worse" narratives. I have hundreds of hours with Opus 4.6, and I've been testing 4.7 since it came out a few days ago. Quality is equal to or better than 4.6 on non-trivial tasks where I have a reference for how 4.6 used to behave.

When you see someone complaining "4.7 is terrible", ask for the exact prompt, the repo, the context. Most of the time they can't reproduce it, or the repo has a badly written CLAUDE.md, or the task is too subjective to measure. "Felt like it got worse" isn't data. I got caught by that feeling myself in a 4.7 session where the context had been contaminated with a bunch of stale docs. The culprit was my config, not the model.

In the benchmarks I ran this week, Opus 4.7 on opencode delivered clean Tier 1, same level as the Opus 4.6 baseline. The tests it ran via Claude Code had a weirder story, and there the blame is likely the harness, not the model. More on that below.

## What's new in the benchmark

The [benchmark](https://github.com/akitaonrails/llm-coding-benchmark) now supports testing model combinations across the three main harnesses:

1. **Claude Code** (`claude -p --output-format stream-json`) — supports sub-agents declared in `.claude/agents/*.md` that Opus can delegate to via the `Task` tool
2. **opencode** — has its own sub-agent system that can run different models
3. **Codex CLI** — got sub-agent support via TOML with `-c agents.<name>.config_file=...`

On top of these three, I configured 7 combinations:

| Runner | Primary model | Sub-agent | Idea |
|---|---|---|---|
| Claude Code | Opus 4.7 | — | Baseline, Opus alone |
| Claude Code | Opus 4.7 | Sonnet 4.6 | Opus plans, Sonnet executes |
| Claude Code | Opus 4.7 | Haiku 4.5 | Opus plans, Haiku (smaller) executes |
| opencode | Opus 4.7 | GLM 5.1 | Opus + GLM (cheap + good) |
| opencode | Opus 4.7 | Qwen 3.6 local | Opus + free local model |
| Codex | GPT 5.4 xHigh | GPT 5.4 medium | High reasoning plans, lower executes |
| Codex | GPT 5.4 xHigh | GPT 5.4 low | High reasoning plans, minimum executes |

Each runs the same prompt: build a Rails app with RubyLLM, Tailwind, Stimulus, Turbo Streams, Minitest tests, Brakeman, RuboCop, Dockerfile, docker-compose. Same prompt as the original benchmark.

### How to enable multi-model in each harness

Before showing what went wrong, it's worth understanding how each harness exposes the sub-agent and who decides to call it. The mechanics are similar across all three, but the details matter.

#### Claude Code

Claude Code automatically reads files in `.claude/agents/*.md` from the project directory. Each file is an agent definition:

```markdown
---
name: sonnet-coder
description: Claude Sonnet 4.6 for concrete coding execution. Use PROACTIVELY for any code change where the plan is already clear. Opus should plan and delegate; Sonnet should execute. Only skip delegation for cross-file architectural decisions.
model: claude-sonnet-4-6
---

You are a focused coding agent. The parent (Opus) has already decided
the approach — your job is to execute cleanly.

Rules:
- Follow the provided instructions precisely. Don't re-plan.
- Prefer editing existing files over creating new ones.
- Match the existing codebase style.
- Keep changes minimal.
- Default to no comments.
```

The YAML frontmatter has three required fields: `name` (the handle the primary model uses), `model` (which model runs the agent), and `description` (what the primary reads to decide whether to delegate). The file body is the system prompt the sub-agent receives when invoked.

To invoke, Opus uses the native `Task(subagent_type="sonnet-coder", prompt="...")` tool. Claude Code bills tokens to the sub-agent's model, not the primary's.

#### opencode

opencode uses a JSON config file (can be the default `opencode.json` or a custom one via `--config`). Agents live under an `agents` key:

```json
{
  "model": "openrouter/anthropic/claude-opus-4.7",
  "agents": {
    "coder": {
      "model_id": "zai/glm-5.1",
      "provider": "zai",
      "description": "Use proactively for concrete coding execution...",
      "prompt": "You are a focused coding agent. The parent..."
    }
  }
}
```

Each entry has `model_id`, `provider`, `description`, and `prompt`. The primary model (set at the top) invokes the agent via a `task` tool, passing the name (`coder` in the example) and specific instructions.

#### Codex CLI

Codex uses TOML files per agent, passed via `-c` flags on the command line:

```toml
# .codex-coder.toml
name = "coder"
model = "gpt-5.4"
reasoning_effort = "medium"
description = "Use proactively for concrete coding execution..."
prompt = "You are a focused coding agent. The parent (xhigh)..."
```

And invoked:

```bash
codex exec \
  --dangerously-bypass-approvals-and-sandbox \
  -c model_reasoning_effort=xhigh \
  -c agents.coder.config_file=.codex-coder.toml \
  -p "<main prompt>"
```

The primary model gets access to the `spawn_agent` tool to invoke the `coder`. Codex lets you configure a different `reasoning_effort` for the primary and the sub-agent, which is exactly what the `multi_balanced` and `multi_faster` variants test.

### Who decides which model runs each task

In all three harnesses, the decision to delegate is made by the **primary model at runtime**, not by a programmatic rule. There's no deterministic heuristic like "if the file is larger than X lines, call the sub-agent". What exists is the primary model reading the sub-agent's description and judging, step by step, whether the current task fits.

Three consequences:

1. **The sub-agent description is the only control knob**. If you write "use PROACTIVELY for X" without caveats, the model tends to delegate more. If you add "skip for Y", it tends not to delegate on Y.

2. **The primary model is conservative by default**. Across all three, current training favors not delegating when the task needs cross-file context or architectural decisions. A greenfield Rails app is exactly that kind of task.

3. **You can't force delegation via config**. You can write an aggressive description, but if the model judges the task doesn't fit, it ignores the sub-agent. No `--force-subagent` flag exists. The call is the model's, not the operator's.

Matters for what comes next.

## The finding that kills the argument

I opened the logs of each run expecting to see delegation happen. Tools like `Task` (Claude Code) or `spawn_agent` (Codex) should show up in the ndjson every time the primary model calls the sub-agent.

Across 7 runs, **the delegation tool was called zero times**. No Opus called Sonnet. No Opus called Haiku. No Opus called GLM 5.1 or the local Qwen 3.6. No GPT xHigh called GPT medium or low.

All primary models did the entire job alone, ignoring the sub-agent that was registered and visible to them. The sub-agents were read, parsed, listed, and never invoked. It's like hiring an assistant and letting them sit at their desk all day while you do everything yourself.

Why did this happen? Two layers of explanation.

### The technical layer

The primary models read the sub-agent descriptions and decided the task didn't fit. Descriptions typically said "use proactively for concrete code execution" with a caveat "skip for cross-file architectural decisions". Except an entire Rails app is cross-file architectural decision. Controller depends on service, service depends on initializer, view depends on partial, all depend on how tests mock the LLM. There's no isolated piece you can hand off to a dumber executor without losing context.

I could have written the sub-agent description more imperatively, forcing delegation. But that would be cheating to get a result. The point of the test is to see what the model does freely, not what it does under force. And freely, it didn't delegate.

### The management layer

Delegation has coordination cost. That's basic project management knowledge, not news. When you outsource a task, you have to:

- Write a clear spec for the other executor
- Wait for the result
- Review
- Request adjustments if there's a gap between what you wanted and what came back
- Reintegrate into the rest of the work

For seniors outsourcing to juniors, that cost is real. Productivity doesn't scale linearly with the number of executors. Doubling the team doesn't double speed. In many cases, outsourcing costs more time than doing it yourself would have.

With LLMs the same thing happens, compounded by a specific trait: Opus's planning is rarely perfect on the first try. Never is. Opus reads the prompt, builds a plan, starts implementing, hits a problem (library that doesn't have that version, method that doesn't exist as it imagined, test that fails for a reason it didn't anticipate), adjusts the plan, tries again. That "plan → try → adjust" loop is inherent to the work. Not an Opus failure, it's the nature of software development.

Now imagine you insert a smaller model in the middle of that loop. Opus plans, hands off to Qwen to execute, Qwen writes code that likely hallucinates the API (as we saw in the previous benchmark, Qwen invents `RubyLLM::Client.new` which doesn't exist), Opus gets the code back, finds it's wrong, has to make a sub-plan to fix it, hands back to Qwen, which invents something else, and on it goes. The communication and correction overhead explodes.

That's why the models themselves, without being forced, decided not to delegate. They know the coordination cost outweighs the benefit, especially for a cohesive task like building a Rails app from scratch.

## Notes per run

Even without delegation happening, the 7 runs produced different results. Let me comment on each.

### Claude Code: Opus 4.7 alone

11 minutes, $6.74, 24 tests, 1742 files. Result **Tier 3** (broken). Opus in this run hallucinated the `chat.complete` method on RubyLLM, which doesn't exist, and used `chat.add_message(role:, content:)` with keyword args instead of a positional hash. Same typical hallucination other models have, now from Opus itself. Weird, because the same Opus 4.7 on opencode delivered correct Tier 1 code on the same prompt.

### Claude Code: Opus 4.7 + Sonnet 4.6

10 minutes, $5.13, 18 tests, 1829 files. Result **Tier 2** (first message works, multi-turn breaks). Better than the Opus-alone baseline, but still has the keyword-args bug on `add_message`. Zero delegations to Sonnet.

### Claude Code: Opus 4.7 + Haiku 4.5

15 minutes, $7.83, 34 tests, 1984 files. Result **Tier 3**, same hallucination as Opus alone. The highest test count (34!) all pass because the test fakes mock the hallucinated API Opus itself invented. Tests that prove nothing.

The point worth underlining: Opus 4.7 on Claude Code wrote 34 passing tests, and none of them prove the code works. The hallucinated API is tested against a hallucinated implementation. In the real world, the app crashes on the first message. Test count is a vanity metric when the mock is wrong.

### opencode: Opus 4.7 + GLM 5.1

19 minutes, $1.10, Tier 1 (works on first try). Correct RubyLLM API. Both phases (build + Docker validation) completed clean. Zero calls to GLM 5.1, Opus did everything.

### opencode: Opus 4.7 + local Qwen 3.6

30 minutes, $1.10 (only Opus billed, local Qwen is free), Tier 1. Same quality as above. Zero calls to the Qwen 3.6 running on the 5090.

### Codex: xHigh planning, medium executing

21 minutes, ~$11, Tier 1. The most expensive multi-agent run on the Codex side, but curiously the one that generated the best code, and fixed the `add_message` bug the previous benchmark caught on GPT 5.4 alone. But zero delegations, all the work came from xHigh.

### Codex: xHigh planning, low executing

20 minutes, ~$10, Tier 2. Reproduced the keyword-args bug. Cheaper than the above but worse code. Zero delegations to low either.

## Same model, different runs, different results

Here's the real story of this benchmark, which becomes clearer when you group by model instead of by combination.

Since the sub-agents never ran, each "multi-model" combination effectively became another run of the primary model. That gave me something I didn't have in the previous benchmark: **multiple runs of the same model on the same prompt**. Let me compare.

### GPT 5.4 xHigh: three runs

In [last week's benchmark](/en/2026/04/05/testing-llms-open-source-and-commercial-can-anyone-beat-claude-opus/), GPT 5.4 via Codex with xHigh ran once, scoring Tier 2 (first message works, multi-turn breaks due to `chat.add_message(role:, content:)` with keyword args instead of positional hash).

This week I ran two more, with different sub-agent configurations (which weren't used, but the presence changes the primary's behavior, as I showed above):

| Run | Tier | Tokens | Cost | Correct API? |
|---|---|---:|---:|---|
| xHigh alone (last week) | 2 | 7.6M | ~$16 | Bug in `add_message` |
| xHigh + medium subagent | 1 | 5.44M | ~$11 | **Fixed the bug** |
| xHigh + low subagent | 2 | 4.28M | ~$10 | Bug came back |

Same model, same prompt, three runs. One of them wrote `chat.add_message(message)` with positional hash (Tier 1, works in multi-turn). The other two wrote it with keyword args (Tier 2, breaks on the second message).

No sub-agent was called in any of the multi variants. The only thing that changed between the three runs was the text of the available sub-agent description (or its absence). Even so, that GPT 5.4 "got" the API right in one run and "got it wrong" in the other two.

### Claude Opus 4.7: six runs

With Opus it was even more instructive. Six different runs, same model, same prompt, results spread from Tier 1 to Tier 3:

| Run | Harness | Tier | Time | Cost |
|---|---|---|---:|---:|
| Opus 4.7 baseline | opencode | 1 | 18.2m | $1.10 |
| Opus 4.7 + GLM 5.1 | opencode | 1 | 10.3m | $1.10 |
| Opus 4.7 + Qwen 3.6 local | opencode | 1 | 19.4m | $1.10 |
| Opus 4.7 alone | Claude Code | 3 | 11.0m | $6.74 |
| Opus 4.7 + Sonnet | Claude Code | 2 | 10.1m | $5.13 |
| Opus 4.7 + Haiku | Claude Code | 3 | 14.7m | $7.83 |

The three Opus runs on opencode: consistent Tier 1. Correct RubyLLM API, works in multi-turn, clean code.

The three Opus runs on Claude Code: one Tier 2 and two Tier 3. Code that hallucinated `chat.complete` (method doesn't exist) or got the `add_message` signature wrong.

Same model. Same prompt. Different harness = different result.

### What that means

Two possible readings:

**The lazy reading:** "Opus 4.7 on Claude Code regressed, switch to 4.6" or "opencode is better than Claude Code". Both would be wrong conclusions from such a small benchmark.

**The honest reading:** a single-run benchmark, or even three runs, isn't enough to assert anything about the absolute quality of a model. Variance is high, the context loaded by the harness (CLAUDE.md, tool schemas, agent registries) shifts the "mental model" the model activates, and the result can swing between tiers.

In the previous benchmark, I got lucky (or unlucky) with runs consistent enough for hierarchies like "Claude/GLM work, Kimi/DeepSeek/Qwen hallucinate the API" to hold. But even there, run-to-run variance is real. If I run Kimi K2.5 ten times, maybe two or three of those runs would hit the API right. I didn't test this, but it's plausible.

This benchmark reinforces the point: the rankings in the previous article count as signal, not proof. "Works on first try 80% of the time" is different from "always works". For production use, you want a model robust to variance, one that doesn't have a 20% chance of returning hallucinated code. Today, the only models that meet that bar for me are Claude Opus and Claude Sonnet, on any harness. GLM 5.1 is close but I don't have a large sample yet.

Does that mean Opus 4.7 "got worse"? No. Does it mean Claude Code "is worse than opencode"? No. It means a single-run benchmark on a greenfield Rails app doesn't capture model variance. Worth knowing before jumping to strong conclusions.

## Execution time: is multi-model slower?

Adjacent question worth measuring: if the sub-agent never ran, were the multi-model runs slower than the alone baselines? My initial intuition was yes, since without cross-session parallelism the primary model does the work serially. The data tells another story.

| Run | Time |
|---|---:|
| Claude Code Opus alone | 11.0m |
| Claude Code Opus + Sonnet | 10.1m |
| Claude Code Opus + Haiku | 14.7m |
| opencode Opus baseline | 18.2m |
| opencode Opus + GLM 5.1 | 10.3m |
| opencode Opus + Qwen 3.6 | 19.4m |
| Codex xHigh baseline | 21.9m |
| Codex xHigh + medium | 21.2m |
| Codex xHigh + low | 20.2m |

Some multi-model runs were **faster** than the alone baseline. opencode + GLM 5.1 was almost half the time of opencode alone (10m vs 18m). Claude Code + Sonnet was 1 minute faster than pure Opus. Codex multi-agent variants ended up slightly faster than xHigh alone.

Others were slower: Claude Code + Haiku took 15m (4m more than baseline). opencode + Qwen 3.6 ran 19m (same as baseline, likely penalized by llama-swap overhead even without invoking the model).

No consistent pattern of "multi-model is always slower" or "always faster". What happened, looking at tool calls and test counts, is more interesting: **the primary model changes its own behavior when it sees a sub-agent is available, even without calling it**.

- Claude Code Opus alone: 24 tests, 11m
- Claude Code Opus + Sonnet: 18 tests, 10m (fewer tests, faster)
- Claude Code Opus + Haiku: 34 tests, 15m (more tests, slower)

The pattern: when the sub-agent exists in the description as "executor", the primary model sometimes produces leaner output, as if "leaving work for later". When the sub-agent describes more expensive execution (Haiku as "high-volume execution"), the model seems to assume it can afford to write more tests because "the cheap executor will handle it". The executor is never called in either case. But the sub-agent's presence influences the primary's planning.

Subtle effect, like a delegation placebo. The model doesn't delegate, but behaves as if it would. It can be good (more focused output) or bad (lower test coverage than baseline). Not something you control, it's emergent behavior from the model reading the sub-agent description.

### So is it worth configuring Haiku just for the placebo?

You might be tempted: "if Opus wrote more code and more tests with Haiku configured, then it's worth configuring Haiku as a sub-agent even if it never runs, just for the placebo". The numbers say no.

Comparing Opus alone vs Opus with Haiku configured, both on Claude Code:

| Metric | Opus alone | Opus + Haiku |
|---|---:|---:|
| Time | 11.0m | 14.7m |
| Cost | $6.74 | $7.83 |
| Tests | 24 | 34 |
| Quality tier | 3 (broken) | 3 (broken, same hallucination) |

With Haiku configured, Opus spent 3.7 more minutes, $1.09 more, and wrote 10 more tests. The quality tier stayed the same. The same `chat.complete` hallucination appeared in both runs. The 10 extra tests mock the same hallucinated API, so they prove nothing the original 24 weren't already proving. More code, not better code.

Delegation placebo can shift quantity but doesn't fix factual errors. And with a sample of 1 run each, even the quantity increase isn't reliable, because Opus-alone run-to-run variance is also high (probably another Opus-alone run would hit 30+ tests by chance).

**Practical takeaway:** don't configure a "fake" sub-agent just to try to manipulate the primary. The cost in tokens/time is certain, the benefit is speculative. Opus alone, no sub-agent, stays the recommended default configuration. Sub-agents are only worth it when you have a real delegation use case that works (and we saw here that greenfield isn't one).

### "Multi-model is slower" hypothesis doesn't hold

Back to the original question: no, you can't say multi-model without delegation is consistently slower. Sometimes it is, sometimes it's faster, depends on the model and the sub-agent description. What you can say is that the sub-agent's presence shifts the primary's behavior in unpredictable ways, and that alone is an argument against multi-model configurations with no clear need.

## Two unexpected findings

Outside the main topic (multi-model didn't work), two patterns showed up.

### First: the harness affects code quality, not just cost

The same Opus 4.7 produced Tier 1 on opencode and Tier 2/Tier 3 on Claude Code, same prompt. That's new. As far as I know, this is the first benchmark evidence that the harness (the CLI wrapping the model) can degrade factual correctness, not just cost.

The hypothesis is that Claude Code carries 6-11 million cache-read tokens per run (CLAUDE.md, tool schemas, agent registries, etc.), against opencode's ~210 thousand. That volume of context seems to pull Opus toward a generic OpenAI SDK "mental model", where `chat.complete` makes sense, instead of the specific mental model for the RubyLLM gem. Speculation on my part, I can't prove it. But the Tier difference between the two harnesses running the same model is concrete.

This **does not mean** opencode is better than Claude Code for daily use. In my day-to-day, Claude Code with Opus beats opencode on almost everything: editor integration, long-session context management, native tool support, multi-step planning quality. The benchmark has a narrow scope (greenfield Rails app, specific prompt, no human iteration) that doesn't reflect real use.

What the data says: variance between harnesses is real and measurable. Worth keeping in mind when you're evaluating a model.

### Second: cost of Claude Code vs opencode

Running the same Opus 4.7 on the same prompt:

- Claude Code: $5 to $8 per run
- opencode: $1.10 per run

Claude Code costs 5 to 7 times more per run on the same model. The difference is cache-read: Claude Code loads 6-11M context tokens per run, opencode loads ~210K. There's a legit technical reason (tool schemas, TodoWrite, agent registries, CLAUDE.md, editor integration), but the overhead is real and shows up directly on the bill of anyone paying per token.

Worth a more refined take here, because this changes the calculus depending on how you consume.

**If you're on Pro or Max:** use Claude Code. Period. Subscription covers the tokens, you get the full feature set (native tool support, skills, agents, Plan mode, better long-session context). No reason to switch.

**If you pay per token directly through the API, the math changes with volume.**

For light use (a few hundred dollars a month): opencode with Opus is cheaper, and in this specific benchmark hit Tier 1 while Claude Code landed in Tier 2/3. Works well for automated pipelines, CI, benchmarks, server-side agents.

For heavy use (thousands of dollars a month on API): staying on per-token doesn't make sense. The Max 20x subscription at $200/month covers heavy volume and includes Claude Code. For a heavy vibe-coder, Max is cheaper than Opus on API by a wide margin. Then you're back in the first bucket, on Claude Code.

**Opencode is better, regardless of cost, for:**

- Headless or automated use (CI, benchmarks, server agents)
- Multi-provider setups where you want the same harness hitting OpenRouter, Z.ai, and local llama-swap
- When you need structured JSON output (`--format json`)
- Neutral model comparisons

**Claude Code is better, regardless of cost, for:**

- Interactive coding sessions with a human in the loop
- Projects with CLAUDE.md, skills, custom MCP
- Work where Opus's Plan mode matters
- Long iterative sessions where accumulated context helps

Honest reading: this benchmark measures a narrow scenario (greenfield, one-shot, no human iteration). For real daily work, Claude Code with Max remains the recommendation for 99% of people. Opencode's cost win shows up in a specific niche (automated pipelines or per-token API use below the Max break-even). Most people aren't in that niche.

## The "Opus plans, Qwen executes" myth

Every so often someone on Twitter talks about setting up a pipeline where Opus makes the detailed technical plan and a smaller model (Qwen, GLM 5, Haiku, Sonnet) executes. "Save tokens, same quality, everybody wins".

Doesn't work. Or rather, works for a demo, doesn't work for a real project.

The most serious problem is that **the plan is never perfect on the first pass**. Code is never one-shot. You implement, find a problem, adjust. With one big model, that adjustment happens in real time by the model itself. With two models, every adjustment has to go back to the planner, be reprocessed, a new plan written, a new executor invoked. The loop is slower.

Then there's the question of **factual API knowledge**. If Opus's plan says "use RubyLLM to call OpenRouter", Opus knows it's `RubyLLM.chat(model:).ask(msg).content`. The smaller Qwen reads the plan and implements with the API it thinks exists, which may be `RubyLLM::Client.new.complete`. The plan doesn't correct this because the plan doesn't carry the gem's factual knowledge. Only the model that knows that API can implement it correctly.

And then there's **coordination cost**, which explodes with iteration. Every round of "plan → execute → fail → re-plan → execute again" costs more tokens than just letting the big model do everything in one session. You pay in planning tokens AND in wrong-code tokens that need to be rewritten.

In theory, multi-model makes sense. In practice, it's work for a Twitter thread with pretty animations, not the workflow of someone who ships code.

## When multi-model can make sense

I don't want to sound absolute. There are scenarios where multi-model is the right pick.

The main one is **genuinely parallel and decoupled tasks**. API migration across 30 identical files, for example: each file follows the same pattern, no dependencies between them. Opus could supervise 20 sub-agents doing the same transformation on 20 different files. In that case, the coordination cost is amortized by the parallelism.

Another is **tasks with a heavy research phase followed by a direct implementation phase**. Opus does the architectural spike exploring legacy code, then delegates the mechanical implementation to the smaller model.

A real example I went through last week: [I translated 700+ posts and all the video subtitles of the blog to English](/en/2026/04/09/20-years-of-blogging-ai-finally-translated-everything/) using Claude Code. I burned through the Max 20x and blew another $1120 in extra usage on top. Translation is exactly the kind of task that would have benefited from multi-model: each post is independent of the others, no cross-file dependency, zero architectural planning, just batch translation. Opus orchestrating + Sonnet executing each file's translation would have cut the cost in half, easily. Didn't occur to me at the time, I ran everything on Opus. The lesson I take: for genuinely parallel tasks, multi-model with Sonnet as executor makes sense, and I missed a clear chance to save money.

But neither of the cases above is "greenfield Rails app". A new app from scratch is the worst scenario for multi-model because every part depends on every other part. The models aren't dumb, they recognize this and refuse to delegate.

## The rule of thumb stays the same

For 90% of day-to-day programming work, my recommendation remains:

- Claude Code + Opus (4.6 or 4.7)
- If cost is critical and you're OK plugging into OpenRouter, GLM 5.1 is a comfortable second place
- If you have good GPU (5090 or equivalent), local Qwen 3.6 35B is acceptable for simple tasks, with caveats

Multi-model? Only for specific cases where the parallelism is genuine. For normal projects, it's unnecessary overhead.

## Benchmarks aren't absolute truth

This benchmark measures a specific thing: greenfield Rails app, deterministic prompt, no human iteration, in automated runners. A narrow slice of real use.

If you want to know which combination works for YOUR workflow, YOUR types of projects, YOUR quality expectations, don't trust my benchmark. Run your own. The [code is all on GitHub](https://github.com/akitaonrails/llm-coding-benchmark), the harness is extensible, you swap the prompt and you have your own comparison.

What I hope this work contributes is methodology, not a definitive answer. "Claude is better than Qwen" depends on what you're doing. "Multi-model doesn't work" depends on the type of task. Benchmarks narrow the space for speculation with concrete data, they don't close the discussion.

Meanwhile, if someone tells you they combined Claude + GLM and it was magical, ask for the code, the prompt, the repo. Most of the time they measured something quite different, or have a specific task where that combination fits. Don't generalize from a tweet.
