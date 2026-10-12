---
title: "Are There Better Languages for Programming with LLMs?"
slug: "are-there-better-languages-for-programming-with-llms"
date: '2026-10-11T21:00:00-03:00'
draft: false
translationKey: existem-linguagens-melhores-pra-programar-com-llms
description: "DHH converted his Campfire to several languages with AI and started posting that Rust won. Instead of fighting on X, I built a reproducible benchmark: 7 languages, 4 LLM configurations, 112 implementation attempts, and a queue-under-pressure test with Elixir, Rust, Rails and plain Ruby. Result: no language ranking holds up, concise Ruby cost more tokens than Rust, strong typing spared no repair at all, and under load the four stacks tied on throughput. What matters is testing and discipline, not language."
tags:
- llm-benchmarks
- programming-languages
- llms
- elixir-and-erlang
---

Last week DHH decided to farm engagement with the laziest format there is: he converted Campfire, his chat app, to several languages using AI agents, and started dropping the throughput results one by one on X. In the series he posted, the Rust version came out ahead of the Elixir and Ruby equivalents. The whole thread was designed to provoke, and it provoked.

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr">Last conversion of the Campfire from my token stash goes to JavaScript/Express. As with the others, I'm sure you can find more to optimize. But this gives you a sense of what order of magnitude these options exist within with agent-led development. https://t.co/UUapL99SJE https://t.co/2H2NXfeZog</p>&mdash; DHH (@dhh) <a href="https://twitter.com/dhh/status/2107077808182976817">October 5, 2026</a></blockquote>

I won't defend him this time. A one-shot conversion, done by an agent, with no fine-tuning at all, doesn't measure language: it measures how much the model knows each stack's idioms. It's rage bait and he knows it. That said, I do the same from time to time, and so do half his critics, so we're all hypocrites and life goes on.

And the weak spot of his methodology became a topic of its own: several people noticed the Rust version had gone through far more agent iterations than the others, meaning more optimization rounds. @kurtome answered in practice: he took the Elixir version and sped up the main page requests 10x, with obvious optimizations that no first conversion does, like caching and async database connection pooling.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">@dhh Here you go https://t.co/gUtK7Z7zG7<br><br>got a 10x speed up on the Room page requests, and sped up all the other requests significantly as well. the biggest gains came from some no brainers: implement caching and pool the db connections with proper async https://t.co/mbp94q9N0s</p>&mdash; kurt (.com) (@kurtome) <a href="https://twitter.com/kurtome/status/2106902762076467681">October 5, 2026</a></blockquote>

His comparison, then, wasn't "Rust versus Elixir": it was "Rust after N tuning rounds versus Elixir after one." And that lays bare the truth the thread pretends to ignore: **no real software ships from half a dozen prompts**. Coding with AI shines when an experienced engineer steers the agent toward their goal, and that means dozens of iterations, not three.

The good part is that the bait was useful to me. I've been doing [LLM benchmarks](/en/2026/09/15/new-llm-benchmark-v4-retesting-all-top-llms-part-1/) and [decision-model benchmarks](/en/2026/10/10/which-jev-like-ai-decision-classifier-model-is-best/), but I had never measured, in a reproducible way, the question that thread pretended to answer: **does it matter which language you pick when the one writing the code is an LLM?** My short answer was already out in two posts of mine:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Pressure under load is not a trivial problem to solve from scratch and I recommend you do not attempt to. It's a solved problem already and all solutions converge to what Elixir already brings out of the box. So yes. I use Rust all the time, but if I had to solve high scalability problems (particularly high volume message queues), I would think of Elixir first.</p>&mdash; Fabio Akita (@AkitaOnRails) <a href="https://twitter.com/AkitaOnRails/status/2108587462595367353">October 9, 2026</a></blockquote>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Language wars are tiresome. And the reality is simpler if you're doing AI assisted coding.<br><br>- system level (drivers, fs, daemons, etc): Rust. C++ is you're extending existing legacy<br>- windows only desktop apps: C#<br>- iOS/MacOS/iPadOS: Swift<br>- multi-OS: Rust/Tauri, Qt/C++, Flutter, Electron (pick your poison)<br>- simple websites: Node/Typescript/Bun/Deno<br>- highly scalable backend: Elixir, parts in Rust, parts in Go<br>- CLI tools: Rust<br><br>Everything else, by default, Rust. Unless it's an edge case.</p>&mdash; Fabio Akita (@AkitaOnRails) <a href="https://twitter.com/AkitaOnRails/status/2108590592263352540">October 9, 2026</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## There's no better language, there's the right tool

That list from the post isn't a ranking, it's a terrain map. Every language and every framework was designed for a use case, and none covers them all. That was true when you wrote every line by hand and it stays true with agents. The LLM doesn't change the physics of the problem: it only changes who's typing.

And the map goes beyond language. A real system has infrastructure around it: Kubernetes when scale asks for it, SQLite by default because most apps never need more than that, Postgres with pgBouncer when they do, Redis for cache and key-value, RabbitMQ or NATS for queues. Picking "the stack" on day zero and expecting it to last ten years is fantasy. It doesn't, and that's fine.

Personal example: new web app, I open Ruby on Rails without thinking twice. It's the most complete end-to-end solution there is for the web, and with an LLM writing most of the code, the framework's productivity weighs even more than the language's. As the system grows, I swap the parts that ask for another tool: a high-volume queue leaves Rails' side and goes to something from Erlang land, starting with RabbitMQ, which already solves the hard backpressure part for me.

> No good software is finished: it grows. Usage dictates what you replace, rewrite and add. The final architecture is never the first commit's, and whoever tries to get everything right in the first commit only produces dead documents.

## The token superstition

DHH's thread resurrected two beliefs that have been circulating since LLMs became work tools:

- **"Script languages are better for AI because the lean syntax spends fewer tokens."**
- **"Strongly typed languages are better for AI because the compiler catches the errors, so you need less testing and less repair."**

Both sound reasonable and both are superstition until someone measures. I was betting against both, from experience: a good compiler helps, but it doesn't do magic, and syntax conciseness was never the bottleneck of an agent that reads and writes files all day.

What really separates a project that moves from a project that spins in circles is test discipline. I've written that [TDD became a technical obligation, not a philosophy](/en/2026/04/20/clean-code-for-ai-agents/), and this post's benchmark is one more data point in the same direction. It doesn't matter whether you do test-first or test-after: what matters is that the suite grows with the code, that [every user-reported bug becomes a regression test](/en/2026/03/01/software-is-never-done-4-projects-life-after-deploy-one-shot-prompt-myth/) before the fix, and that you never make the same mistake twice. Software without users is dead software, so [release early, release often](/en/2026/09/22/stop-making-excuses-and-ship-more-the-premise-changed/), break fast and fix even faster. AI closes exactly that gap: the reproduce-test-fix cycle got cheap. QA became the programmer's most valuable skill, far above "knowing Rust syntax."

Discipline beats compiler and beats language. That was my hypothesis. Time to measure.

## The benchmark

I built a reproducible experiment, public in the [vibe-coding-benchmarks repository](https://github.com/akitaonrails/vibe-coding-benchmarks), with per-attempt results published in JSON and the raw traces kept out of the repo for credential containment. It's not a language championship, and the design itself says so: it's a snapshot of one real task, measuring what can be honestly measured.

### The task

One task only, on purpose: maintain a multi-tenant **ledger engine**. The agent receives working v1 code and has to take it to a v2 contract, with per-tenant identities, authorization, serializable snapshots, a unique secondary index with alias swap, a capacity-bounded journal, torn-group recovery, checkpointing, legacy schema migration and durable retry IDs. It's not FizzBuzz: it's the kind of system that demands invariants across operations, exactly where LLMs tend to trip.

Correctness is judged by **43 test stories applied after collection**, out of the agent's sight: the 27 public ones from T1 plus 16 hidden ones. Passing is 43 out of 43. The conditions:

- **T0:** prose contract, input and output examples, a working launcher. No test suite.
- **T1:** the same, plus 27 public stories and a driver to run them.

Each attempt had a 15-minute budget, with at most two 3-minute continuations. In practice, none of the 112 needed a continuation.

### The languages and the models

Seven languages in three strata, with pinned toolchains and Rust in safe mode:

- **Typed natives:** Rust (safe, pinned), Haskell (pinned GHC).
- **Typed VMs:** C# (with nullable analysis), Kotlin, TypeScript (`strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`).
- **Dynamic scripts:** Python and Ruby, no checker at all.

Four model configurations, all on subscriptions, no paid fallback: **Kimi K3** (high), **GLM 5.3** via OpenCode (high), **Claude Opus 5.5** (medium) and **Codex with gpt-6 Sol** (medium). Crossing everything: 7 languages × 4 models × 2 conditions × 2 repetitions = **112 attempts**.

### What this design doesn't measure

Before the numbers, the brakes, because they're part of the result. It's a single task, with two repetitions per cell: a small sample by construction. Token coverage is partial in some models (missing data is not zero). The harness changed mid-campaign across three instrumentation epochs. And provider delays contaminate wall time: one of the Opus attempts spent half the clock waiting for quota release. All numbers below are descriptive, and I point out where they can't support a conclusion.

There's one additional brake, on purpose: **the iteration level**. My design measures what can be reached in all languages with similar iteration levels, on a short budget, with no human tuning afterwards. It's a photograph of the floor, not the ceiling. Any of the 112 implementations probably improves with more agent rounds, and the four queue stacks likewise: what I publish is what each language delivers "out of the factory" under the same effort, not the maximum a patient engineer would extract from it.

> **Mandatory disclaimer before quoting any number from this post around:** every result that follows holds for **this** benchmark, with **this** task, **these** models, **these** prompts and **this** hardware. Your case may vary violently. If your task doesn't look like a ledger engine, if your model isn't one of these four, if your queue isn't my queue, the numbers don't transfer. The code, the tasks, the grades and the step-by-step to reproduce are all in the [GitHub repository](https://github.com/akitaonrails/vibe-coding-benchmarks). And if you disagree with some result and that disagreement matters to your company or your project, the only honest attitude is the one I had: **stop arguing and run your own benchmark.**

## Result 1: on correctness, the frontier models tied at the ceiling

| Configuration | Correct within budget | Correct at the limit | Failures | Ungraded |
| --- | ---: | ---: | ---: | ---: |
| Kimi K3 high | 17 | 7 | 2 | 2 |
| GLM 5.3 high (OpenCode) | 7 | 9 | 7 | 5 |
| Opus 5.5 medium | 25 | 0 | 3 (infra interruption) | 0 |
| Codex / Sol medium | 28 | 0 | 0 | 0 |

Reading: Sol passed all 28 eligible attempts and Opus its 25 (the 3 failures were infrastructure, not code). **53 of 53 eligible attempts correct between the two.** The task, made to be hard, was too easy to separate the frontier models, let alone the languages: with everyone passing everything, there's no correctness ranking to publish.

The difference showed up in the weaker models, and in the direction my hypothesis predicted: **provided tests helped**. Kimi and GLM, with the public suite in hand (T1), delivered 24 correct artifacts against 16 without it (T0). Kimi, in particular, passed all 14 attempts with provided tests. It's descriptive, not causal, but it's the cleanest signal in the whole benchmark: what changed the outcome wasn't the language, it was the presence of tests.

Per language, within each model, correctness scattered between 1/4 and 4/4 with no pattern that repeats across models. The three semantic failures I audited in depth are instructive: a GLM C# and a Kimi Python lost the same story by violating the same cross-operation invariant, and a Kimi Haskell missed a checkpoint path. None of the failures was a type error.

> Where the model erred, it erred on domain invariants: the kind of error no compiler catches, in typed or dynamic languages. The myth that strong typing spares you the work of understanding the problem dies right there.

## Result 2: concise language saved no tokens

Here's the table that kills the first superstition. Medians per language on Sol, four valid attempts per cell:

| Language | Median time | Median tokens | Final code lines |
| --- | ---: | ---: | ---: |
| TypeScript | 53 s | 147.5 thousand | ~280 |
| Python | 77 s | 138.2 thousand | ~300 |
| C# | 61 s | 171.6 thousand | ~260 |
| Kotlin | 65 s | 170.6 thousand | ~210 |
| Haskell | 75 s | 184.7 thousand | ~265 |
| Ruby | 82 s | 185.6 thousand | ~380 |
| Rust | 80 s | 188.1 thousand | ~650 |

Ruby, the most concise in lines (a bit over half of Rust's), cost practically the same tokens as Rust on Sol, and on Opus it was **the most expensive of all**, about 205 thousand median tokens against C#'s 94 thousand. The cheapest were TypeScript and Python on Sol, C#, Haskell and Kotlin on Opus. If "fewer source code lines = fewer LLM tokens" were a law, Ruby should have led by a wide margin. It finished last.

And the second superstition? I audited the traces looking for the compiler-guided repair cycles that strong typing supposedly avoids. Result: **zero compilation-error repair cycles** in the audited Opus attempts, across Ruby, Rust and Haskell. Rust needed no compiler-driven fix at all; Haskell had one warning cleanup; Ruby spent its extra tokens on voluntary performance tuning. The frontier model almost always writes code that compiles on the first try, and the real effort goes to verification, not to appeasing the compiler.

One counterpoint that closes the coffin on the "cheap is good" thesis: GLM's **lowest** token-consumption cells were the failures. TypeScript T0 at 50 thousand tokens looks efficient until you see it's two unmodified starters because the model blew the output limit. Low tokens can mean early surrender.

## Result 3: under load, everyone tied at the queue

Now for DHH's question: Rust "beats" Elixir and Ruby when the subject is throughput. I built the separate track for that: four queue workers against a real RabbitMQ, written with agent help, each in its natural idiom:

- **Elixir** with OTP and Broadway
- **Rust** with Tokio and Lapin
- **Rails** with Bunny
- **Plain Ruby** with Bunny (control)

A generator published 10 thousand 4 KB messages to RabbitMQ, at 200 per second, and each worker consumed as fast as it could, hitting the effects on an HTTP/SQLite collector with a nominal 50 ms delay, limited to 2 CPUs and 1 GB of RAM. Two concurrency profiles:

| Stack | Handlers | Effects/s | Correct/10,000 | Memory peak | Drained? |
| --- | ---: | ---: | ---: | ---: | --- |
| Elixir | 8 | 94.8 | 10,000 | 135 MiB | yes |
| Rust | 8 | 94.6 | 10,000 | 16 MiB | yes |
| Rails | 8 | 92.7 | 10,000 | 79 MiB | yes |
| Ruby | 8 | 92.5 | 10,000 | 38 MiB | yes |
| Elixir | 64 | 84.8 | 7,915 | 161 MiB | no |
| Rust | 64 | 88.2 | 8,151 | 23 MiB | no |
| Rails | 64 | 88.5 | 8,108 | 87 MiB | no |
| Ruby | 64 | 88.0 | 8,081 | 60 MiB | no |

On the 8-handler profile, the four stacks delivered the same throughput, 93 to 95 effects per second, and drained the whole queue. The apparent bottleneck was the shared collector (a Python lock, a single SQLite writer), not the languages. On the 64-handler profile, all of them left a backlog and blew the client timeout en masse, so I marked those cells as not qualified: the strong protocol, with a group-commit collector and a 50 to 800 msg/s ramp, is designed but not executed.

The only difference left standing in the numbers was **memory**: Rust held the peak at 16 MiB where the BEAM spent 135. It's a real Rust advantage in density, with the caveat that a cgroup peak is not a language footprint. On throughput, which was the thread's claim, a technical tie.

And the tie deserves an honest reading: it may only mean my pressure was too little. With the shared collector holding everything around 95 effects per second, any stack capable of more than that shows up as "equal." What this test shows is where the bottleneck was, not where each stack breaks. To find each one's ceiling I'd need the strong protocol, with a group-commit collector and a load ramp, which is designed but not executed. Until then, "all stacks perform the same" is the wrong conclusion; "all of them stayed above what my test could measure" is the right one.

And the question that interested me most, "does the agent work less to deliver a reliable queue consumer in Elixir than in Rust?", was deliberately left unanswered: these four implementations were written to validate the environment, not as a controlled coding attempt. Comparing AI effort between Elixir and Rust would require the same ledger matrix running on the queue task. It's on the list.

## So, does the language matter?

With the data on the table, the thread's three questions can be answered:

**Is there a better language for programming with LLMs?** None showed up. In the frontier models, correctness and effort varied less between languages than between models. Where there was a correctness difference, it followed the presence of provided tests, not syntax. "No general language ranking is established" is the report's official sentence, and it's the correct one.

**Do the token-economy theses hold?** Neither one. Conciseness didn't save: Ruby cost as much as Rust, or more. Strong typing spared no repair: there was no type repair to spare. The models' effort went to verification and understanding the contract, and that has no language.

**Was DHH right?** In what he measured, he measured what an agent delivers for free on each stack, without tuning, and called that a verdict on language. In my test, with real load and honest measurement, the four stacks tied on throughput in the stable regime, and only memory differentiated Rust. If his thread proves anything, it proves that agent conversion measures the model, not the language.

My bets from the introduction came out standing: testing and discipline are the lever, the compiler is a supporting actor, and the right tool depends on the problem. New web app is still Rails in my hand, heavy queue is still Erlang territory, low-level system is still Rust, and the LLM writes any of them with the same competence. Whoever spent the week fighting for their favorite language on X fought over nothing.

And my daily practice tells the same story. I have a personal bias toward Rust and even so I've published more than 30 open source projects in all kinds of stacks: [ai-memory](https://github.com/akitaonrails/ai-memory) is Rust, [FrankMD](https://github.com/akitaonrails/FrankMD) is Ruby on Rails, [ai-memory-web](https://github.com/akitaonrails/ai-memory-web) and [ai-jail-web](https://github.com/akitaonrails/ai-jail-web) are Node.js. In none of them did I feel any relevant difference that came from the stack: the wins were similar, the errors too, and the errors were always understandable. Every error became an invariant, a rule, a skill improvement. It never became a language switch.

So forget "token savings" and "typing superstition." Do real software engineering: pick the right tool for your specific problem, apply proper engineering technique, and any reasonable agent will perform more or less the same. And stop wasting time arguing over language-war rage bait on the internet. Be a real software engineer and do real engineering. That's it.

The per-attempt data, the full methodology and the evidence limits are in the [repository](https://github.com/akitaonrails/vibe-coding-benchmarks). If you run the matrix with another task and find a ranking I didn't, show me.
