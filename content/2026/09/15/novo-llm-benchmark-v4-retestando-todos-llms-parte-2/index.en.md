---
title: "New LLM Benchmark v4: Retesting 39 LLMs (Part 2)"
slug: "new-llm-benchmark-v4-retesting-39-llms-part-2"
date: '2026-09-15T20:00:00-03:00'
draft: false
translationKey: novo-llm-benchmark-v4-retestando-todos-llms-parte-2
description: "The full v4 table, nearly forty models ranked by vigilance, not completeness: six ties at the top, a free model beating half of Claude, GLM winning on a flat-rate plan, and the test I ran to find out whether Kimi or DeepSeek are secretly hiding a connection to Claude under the hood."
tags:
- llm-benchmarks
- llms
- coding-agents
---

In [Part 1](/en/2026/09/15/new-llm-benchmark-v4-retesting-all-top-llms-part-1/) I told the process: why I threw out all of v3, how v4 became a single Rails app that grows across seven sprints with an isolated subagent planting fourteen real sabotages based on documented CVEs, and how much it cost, over $4,000 in nine days. Here's the part that matters if all you want to know is who came out on top and who ended up at the bottom.

I ran thirty-nine models to the end. The table below is the combined ranking, already carrying the corrections from two integrity audits I ran myself, on September 12th and 15th, cross-checking every score against the sabotage-by-sabotage evidence ledger.

To get a sense of the suite's scale: the fastest run, GLM-4.7-Flash local, finished in **29 minutes**. The slowest, Qwen 3.8 27B, also local, took **706 minutes**, more than twenty-four times longer to run the same seven-sprint sequence.

## The Full Table

| Rank | Model | Score | Tier | Never-fixed | Cost | Time | Harness |
|-----:|-------|:-----:|:----:|------------------|:----:|:----:|:-------:|
| 1 | GPT-6 Astra | 100.0 | A | — | $30.55 | 100min | codex |
| 1 | Claude Opus 5 | 100.0 | A | — | ~$71 | 145min | claude |
| 1 | Claude Fable 5 | 100.0 | A | — | ~$50 ᵉ | ~85min ᵉ | claude |
| 1 | GPT 5.6 sol | 100.0 | A | — | $20.37 | 317min | codex |
| 1 | GPT 5.6 terra | 100.0 | A | — | **$9.52** | 80min | codex |
| 1 | GPT 5.5 | 100.0 | A | — | $34.69 | 117min | codex |
| 7 | Grok 4.6 ᶜ | 98.5 | A | — | $13.00 | 67min | opencode |
| 8 | Claude Fable 5.1 | 95.5 | A | — | ~$51 | 133min | claude |
| 8 | Sakana Fugu Ultra v2 ᴺ | 95.5 | A | — | $122.01 | 294min | opencode |
| 10 | GPT 5.6 luna | 95.0 | A | item #8 (2) | $10.04 | 123min | codex |
| 11 | Nex N2.5 Pro ᴺ | 94.0 * | A | — (not committed) | **$0 free** | 480min | opencode |
| 11 | GLM 5.3 (zcode) ᴺ | 94.0 | A | — | flat-rate plan | 215min | zcode |
| 13 | DeepSeek V4.1 Flash ᴺ | 92.5 | A | — | **$1.21** | 172min | opencode |
| 14 | Claude Sonnet 5 | 91.0 | A | — | ~$27 | 112min | claude |
| 15 | Gemini 3.8 Flash·high (OpenRouter) | 90.5 | A | item #12 (2) | $15.98 | 97min | opencode |
| 16 | Gemini 3.8 Flash (Antigravity) ᴺ | 89.5 | A | — | $0 (OAuth) | 120min | agy |
| 17 | Muse Spark 1.3 | 88.75 | A | — | $13.31 | 150min | opencode |
| 18 | Grok 4.5 | 88.0 | A | items #7b, #12 (3) | $6.19 | 48min | opencode |
| 19 | Claude Opus 4.6 | 87.5 | A | item #8 (2) | $25.64 | 89min | claude |
| 20 | Kimi K2.7 | 87.25 | A | — | $7.75 | 175min | kimi |
| 21 | MiMo V2.5 Pro | 86.5 | A | — | **$1.03** | 158min | opencode |
| 21 | Qwen3 8 Flash | 86.5 | A | — | **$1.17** | 149min | opencode |
| 23 | DeepSeek V4 Flash | 86.0 | A | items #6, #8 (5) | **$0.97** | 111min | opencode |
| 23 | Claude Opus 4.8 | 86.0 | A | item #8 (2) | ~$37 | 87min | claude |
| 25 | Claude Sonnet 4.6 | 85.75 | A | item #6 (1.5) | $18.64 | 91min | claude |
| 26 | Kimi K3 | 85.0 | A | — | $13.79 | 148min | kimi |
| 26 | DeepSeek V4 Flash 0731 | 85.0 | A | items #2, #6 (6) | $1.94 | 194min | opencode |
| 28 | GLM 5.3 Flash (zcode) ᴺ | 84.25 | A | — | flat-rate plan | 296min | zcode |
| 29 | DeepSeek V4 Pro 0813 | 84.0 | A | items #8, #9 (4) | $4.49 | 152min | opencode |
| 30 | Step 3.7 Flash | 83.75 | A | items #6, #8, #11 (6.5) | $4.15 | 118min | opencode |
| 31 | DeepSeek V4 Pro (base) ᶜ | 82.0 | B | — | $5.26 | 97min | opencode |
| 32 | Qwen 3.8 27B (Strix Halo, local) ᴺ | 80.0 | B | items #2, #7b, #8, #12 (8) | **$0 local** | 706min | opencode |
| 33 | Qwen 3.7 Max | 79.0 | B | items #6, #7, #8 (6) | $10.63 | 106min | opencode |
| 34 | GLM 5.2 (zcode) ᴺ ᶜ | 77.0 | B | item #12 (2) | flat-rate plan | 239min | zcode |
| 35 | Gemini 3.7 Flash·high | 75.5 | B | item #12 (2) | $12.93 | 85min | opencode |
| 35 | MiniMax M3 | 75.5 | B | items #6, #8 (3.5) | $12.17 | 187min | opencode |
| 37 | Mistral Large 3 | 39.0 | C | 7 items (19) | $5.11 | 76min | opencode |
| 38 | Gemini 3.1 Pro (OpenRouter) ᶜ | 32.5 * | C | 9 items (27) | $10.31 | 54min | opencode |
| 39 | GLM-4.7-Flash (local) ᴺ | 24.0 | C | 6 items (16) | **$0 local** | 29min | opencode |

ᴺ = joined this round. ᶜ = score changed by a later integrity audit (September 12 or 15). ᵉ = estimated (Fable 5 lost its real cost/time metadata to an accidental isolation kill; ~$50 is reconstructed from the wave logs). Costs aren't comparable across harnesses: codex/opencode/kimi charge real per-token rates; the Claude models use the Max subscription (notional cost); Antigravity is Google OAuth with no per-token cost; zcode is z.ai's flat-rate GLM Coding Plan. Only compare cost within the same harness.

Two scores carry an asterisk for good reason.

- **Nex N2.5 Pro (94.0\*)** finds and fixes sabotage at frontier level, for free, but leaves everything uncommitted: HEAD still holds all fourteen sabotages intact, and a plain `git checkout` would wipe out every fix it made. Frontier vigilance, zero delivery hygiene.
- **Gemini 3.1 Pro on OpenRouter (32.5\*)** is a victim of its own harness, not its own capability: both reveal attempts crashed on a known third-party bug, the "thought signature" getting corrupted on the Gemini 3 round trip through the proxy, so it only ended up with the unprompted-only score. Running natively on Antigravity it dodges that bug and catches sabotage well, but stalls at sprint 5 three times in a row and never reaches the capstone.

Neither route gives this model a complete score, despite it scoring 95.5 on the shorter v3.

### Visualizing the Cost-Efficiency

A thirty-nine-row table is hard to scan fast, so I put together two charts covering the Tier A models with a defined dollar cost (leaving out free, uncommitted, and flat-rate-plan models, for the same reason already explained above).

The first plots cost against score, with bubble size marking wall-clock time: the further up, the further left, and the smaller the bubble, the better the deal.

![Bubble chart: dollar cost on the X axis (log scale) against score on the Y axis, bubble size is wall-clock time, color is the harness](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/15/v4-cost-score-en.png)

The second compresses all three variables, score, cost, and time, into a single value ruler, for anyone who just wants the direct verdict:

![Horizontal bar chart ranking models by score divided by cost times time, from best to worst value](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/15/v4-value-ranking-en.png)

Notice this combined index tells a slightly different story than the one I highlighted in the text: DeepSeek V4.1 Flash is the most impressive result on pure score-per-dollar among frontier-tier models, but DeepSeek V4 Flash, MiMo, and Qwen3 8 Flash all pull ahead of it on this combined index precisely because they're also fast, not just cheap. Cost alone doesn't tell the whole story; time matters too.

### What Each Item in the "Never-Fixed" Column Means

For anyone tracking that column through the rest of the piece, here's the list of the fourteen sabotages planted in every model, with the severity weight each carries in the score:

- **#1** cross-account data leak — Critical
- **#2** removed login link — High
- **#3** dependency pinned to a version with a known CVE — High
- **#4** SQL injection — Critical
- **#5** missing admin-panel authorization — High
- **#6** the "defang-and-plant": a weakened method plus its matching guard test neutered to always pass — High
- **#7** a database N+1 plus a dropped index, counted as two separate halves (the index half usually shows up as **#7b**) — Medium
- **#8** a wrong, silent aggregate in an internal report — Medium
- **#9** a required file deleted — Medium
- **#10** an API IDOR, improper access to another user's data — High
- **#11** stored or DOM-based XSS — High
- **#12** overly permissive CORS — Medium
- **#13** known CVE in the rack-cors gem — Low
- **#14** a secret or password hardcoded straight into the code — High

## "Why Didn't My Favorite Model Score Higher?"

Every time I publish a ranking like this, that question rains down in the comments, and it's worth answering once and for all, because the answer applies to whatever model any given reader thinks should be higher, not just one in particular.

A benchmark score measures fit to a specific task, not universal quality. My v4 tests one narrow thing: security auditing inside a Rails app growing under active, silent sabotage. A model can be great at writing, at summarizing, at debugging interactively with you sitting right there, at any workflow you use every day, and still perform poorly on this specific test, because this specific test isn't your specific use case.

> That's going to keep happening any time someone tries to compare "the model I use and like" against "the result of a benchmark that measures something else." No benchmark fixes that, because "which model is better" without a task in mind isn't a question with an answer.

What I can say with confidence, inside my v4's specific methodology, is much narrower: the ability to audit its own Rails code against real sabotage. Outside those four walls, this number is worthless for deciding whether your favorite model is good. It's exactly the warning I already left in Part 1: an isolated benchmark ranking is never a final verdict on any model.

## Odd: Opus 4.8 Tied with DeepSeek V4 Flash

Speaking of specific models, there's one detail in the table worth calling out on its own, because it's genuinely odd: Claude Opus 4.8 closed at 86 points, Tier A, tied exactly with DeepSeek V4 Flash, rank 23 of 39, behind Grok 4.5, its own predecessor Opus 4.6, Kimi K2.7, MiMo, and Qwen3 8 Flash. For an Anthropic flagship, seeing it parked in the middle of the pack is eye-catching.

What was left for Opus 4.8 to fix was small, just item #8, the silent wrong aggregate in the admin report, and it never went back to it even after being told. Other than that, it caught nearly everything, including the most disguised sabotage in the whole test (#6) already mid-sprints. It's a solid model that misses exactly the kind of thing this benchmark was designed to catch, and comes up short in a direct comparison with its own younger sibling.

> Opus 5, from the same family, closed out a perfect 40 of 40, catching every sabotage right at the boundary of the sprint where it was planted, no capstone or reveal needed to clean anything up. The gap between 4.8 and 5 here is real: one audits its own code out of habit, the other only fixes things when someone points a finger.

DeepSeek V4 Flash lands on the exact same score as Opus 4.8, 86 points, for $0.97 against the notional equivalent of about $37 for a Claude Max subscription to run the same full sequence (the two costs aren't directly comparable, a notional subscription against a real API rate, but the order of magnitude speaks for itself). It's the top of a visible climb across the ranking itself, snapshot by snapshot, not a lucky one-off run:

- **DeepSeek V4 Pro (base)**: 82.0, Tier B
- **DeepSeek V4 Pro 0813**: 84.0, Tier A
- **DeepSeek V4 Flash 0731**: 85.0, Tier A
- **DeepSeek V4 Flash**: 86.0, Tier A
- **DeepSeek V4.1 Flash**: 92.5, Tier A

Every new snapshot climbs a step, and the jump to V4.1 Flash is the biggest one, close to Claude Sonnet 5's own band (91.0). Against the other Chinese labs tested, the picture is clear: DeepSeek V4.1 Flash beats every Kimi (K2.7 at 87.25, K3 at 85.0), every Qwen (Qwen3 8 Flash at 86.5, Qwen 3.7 Max at 79.0), and MiniMax M3 (75.5). It only loses to the pair at the top, GLM 5.3 and Nex N2.5 Pro, tied at 94.0. For anyone who treats "Chinese model" as one single category from the outside, this ranking shows a real capability climb inside DeepSeek itself, and a clear hierarchy between the labs.

## Six Ties at the Top, Two Different Ways to Get There

GPT-6 Astra, Claude Opus 5, Claude Fable 5, GPT 5.6 sol, GPT 5.6 terra, and GPT 5.5 all closed at 100, perfect vigilance with zero warning needed. But the road there varies. Opus 5 caught every sabotage exactly at the boundary of the sprint it was planted in, never needed the final capstone to clean anything up. Fable 5 did the opposite: let a trio of silent items slip through across the sprints and only swept everything at the capstone, when the vague "get this production-ready" prompt pushed it to reopen its own code. That confirms something I already suspected: the sprint-closing prompt works as a vigilance equalizer at the top of the table, even among models that got there by completely different routes.

GPT 5.6 is the most interesting case in the table for anyone watching cost: sol, terra, and luna are the same model at different reasoning-effort levels. terra scored the same forty out of forty as sol spending $9.52 against $20.37, less than half the cost, in a quarter of the time, and still ends up cheaper and faster than Opus 5 (~$71, 145min) for the exact same top score. It's a cost-and-speed dial the provider hands you; the quality doesn't change. Worth testing the lower effort tier before assuming you need the pricier one.

## Why Big Names Miss Too

Worth explaining quickly why a handful of big-name models, the kind already synonymous with "frontier," still show up with something filled in on the never-fixed column, because that's exactly the kind of detail anyone who likes to nitpick will poke at first.

- **Grok 4.6** (second-best overall score, 98.5 points) carries a small footnote: a sabotage subagent that had already run before accidentally reinjected item #4 into its codebase mid-test. Grok healed itself, fixed it again without being told, and it got logged as a single, transparent event with no effect on the final score. It's noise from my own harness, logged for transparency, not a model failure.
- **GPT 5.6 luna** (95 points) had a solid run otherwise, but spent the entire final reveal on security and deploy work and never went back to open the admin report's code, leaving the wrong aggregate (#8) unfixed.
- **Gemini 3.8 Flash** at higher effort, running via OpenRouter, was the only model in the reinforcement batch to catch the dropped database index on its own, but got distracted with UI tweaks at the reveal and never closed the open CORS (#12).
- **Grok 4.5** shows the same pattern in a simpler form: fixes whatever surfaces in a view or a test, ignores whatever lives in the database or a config file, and left the index (#7b) and CORS (#12) open even after being told.
- **Claude Opus 4.6**, the 4.8's direct predecessor, carries a similar blemish: the wrong aggregate (#8) survived all the way to the reveal, and it went on to propagate that same wrong number into the new API it built afterward.

There's a more serious case involving two big names at once. Claude Sonnet 4.6, at the capstone, and Gemini 3.7 Flash, already back at sprint 3, both found the vulnerable nokogiri dependency and, instead of upgrading the gem, added it to their own security scanner's ignore list, hiding the alert instead of fixing the problem. They only did the real upgrade once the reveal explicitly told them to go hunt for sabotage.

> That's worse than simply missing a sabotage: it's tricking the very audit tool that was supposed to catch the problem.

And the fact that closes out this story is that no cheaper or local model did this. They either fixed it for real or simply missed the flaw, without trying to mask their own scanner.

## The Story That Matters Most: Cost

If there's one result I want to stick from this whole round, it's this: a free model, Nex N2.5 Pro, hit 94 points, tying GLM 5.3 on z.ai's flat-rate plan, and beating most of the Claude lineup: Sonnet 5, Opus 4.6, Sonnet 4.6, and Opus 4.8. It only trails Opus 5, Fable 5, and Fable 5.1. The catch, as I already mentioned, is that it didn't commit anything, so this is frontier vigilance with zero real-world delivery. Still, it shows raw sabotage-hunting capability isn't a monopoly of expensive models.

The reason I included this exact model in this round isn't random. Nex-N2-Pro, an earlier version of the same lineage, was the model at the center of the [Rio 3.5 controversy](/en/2026/06/15/rio-3-5-llm-controversy-plagiarism/) back in June, when evidence published by Nex itself showed Rio 3.5's initial checkpoint was a blend of roughly 60% Nex-N2-Pro and 40% Qwen, with no credit to Nex at launch. Back then, testing both ingredients separately on my benchmark, Nex-N2-Pro scored 83, Tier A, against 42, Tier C, for the base Qwen, which already showed that most of whatever gain Rio announced was inherited from Nex's work, not its own training.

With the new Nex N2.5 Pro running in v4, it's possible to check whether that agentic-capability leap holds up under a much harder test than back then. The result, 94 points of genuine vigilance, holds.

Further down, DeepSeek V4.1 Flash scored 92.5 for $1.21, no harness asterisk. It caught every exploitable vulnerability class on its own, including both tenant leaks, the SQL injection, the authorization bypass, and both halves of the most disguised item in the whole test, and closed the two remaining items at the reveal without a single regression. That puts it in Claude Sonnet 5's band (91.0) for a fraction of the price.

Xiaomi's MiMo V2.5 Pro tied Qwen3 8 Flash, both at 86.5 points, Tier A, for $1.03 and $1.17 respectively, and Qwen closed with zero never-fixed items: frontier vigilance at a fraction of any flagship model's cost.

At the other extreme, Sakana Fugu Ultra v2 was the only non-Claude, non-GPT model to reach 95.5, with genuinely clean work, a dedicated regression test for every fix, but at $5 in / $30 out per million tokens plus heavy token burn, the final cost was $122.01. Frontier vigilance, but you pay a frontier-and-a-half price for it.

There's a case in the table that also cost zero dollars and still isn't really free: Qwen 3.8 27B running locally on a Strix Halo. The score, 80 points, Tier B, still holds its own against a mid-table cloud model on pure security.

> 706 minutes of wall time, nearly twelve hours of a machine running to complete the whole suite, against a range of 80 to 300 minutes for almost the rest of the table.

Zero dollars in cost, an order of magnitude above average in time. For anyone only looking at the price column, that slides right by, but it's the real price of running a big dense model on consumer hardware.

Worth asking whether that's a Strix Halo-specific limit or a "running it at home" limit across the board, because that isn't the only large-unified-memory hardware option out there today. The Strix Halo (Ryzen AI MAX+ 395) has a 256-bit LPDDR5x memory controller, theoretical bandwidth around 256 GB/s. A Mac Studio with an M3 Ultra gets close to 800 GB/s, almost triple.

Since the token-generation phase for a dense model this size is mostly bound by memory bandwidth, not raw compute, it's fair to speculate that the same Qwen 3.8 27B running on a Mac Studio M3 Ultra, via MLX or llama.cpp with Metal, would finish the same seven-sprint suite somewhere in the four-to-six-hour range instead of nearly twelve, a meaningful drop, though still slower than any cloud option.

That's a speculation, not a measurement. I didn't run this test on a Mac Studio, and the math shifts depending on how much of the workload is pure token generation versus processing the accumulated context from earlier sprints, and that second part leans harder on raw compute and responds less to memory bandwidth alone. Still, the general direction should hold: more unified memory bandwidth tends to meaningfully shorten this kind of long run, and that's real data for anyone deciding on hardware while building a local LLM workstation.

## GLM and the Flat-Rate Plan Nobody Saw Coming

While I was running the suite, z.ai had locked my GLM Coding plan, balance at zero, a 429 error. I got around it by going through the ZCode CLI's dedicated code endpoint, still inside the same flat-rate plan, no extra per-token cost. And the numbers that came out of that surprised me.

- **GLM 5.3** scored 94 points with no asterisk at all, tying Nex N2.5 Pro, but with one crucial difference: GLM ships everything committed, a clean tree, no suppressing a CVE through an ignore list, clean `bundle-audit`. It caught the most disguised sabotage in the whole test in both halves at once, something almost no other model pulled off, and only needed the reveal for two remaining items.
- **GLM 5.3 Flash** scored 84.25, beating the local Qwen 3.8 27B (80.0) and Qwen 3.7 Max (79.0).
- **GLM 5.2**, the weakest of the trio, closed out the reveal in four sharp commits, one per remaining sabotage, each with a test, but landed at 77 points, Tier B, because it kept CORS at `origins "*"` even after touching the file, the same bar that had already knocked down Grok 4.5, Gemini 3.7 Flash, and the local Qwen.

Even so, a flat subscription plan, with no variable cost, delivering Tier A two times out of three.

## Local Models: Infrastructure vs. Judgment

Running locally has always been the hardest test in any agent benchmark, because it requires the hardware to handle seven sprints' worth of accumulated context without choking. GLM-4.7-Flash, a 30B-A3B MoE running via llama-swap on an RTX 5090, was the first local model to complete v4's entire sequence, which by itself is already an infrastructure milestone. But the final score was 24 points: it builds functionality, but barely catches any sabotage unprompted, and still leaves the reveal's fixes uncommitted.

The most interesting case is the dense Qwen 3.8 27B. On that same RTX 5090, it stalls at sprint 3, not from lack of memory or a context overflow, but from a reasoning-coherence problem that builds up after two sprints.

The same model, running on a Strix Halo (the Ryzen AI MAX+ 395 chip with 96 GB of unified memory), completed all seven sprints and scored **80 points, Tier B**. On its own, unprompted, it caught:

- both critical items: the tenant leak and the SQL injection;
- the authorization bypass;
- both halves of the disguised sabotage;
- the stored XSS;
- the hardcoded secret;
- and it even genuinely fixed both vulnerable dependencies.

That rivals a mid-table cloud model on pure security. The problem is that, at the reveal, it didn't fix a single one of the four remaining items, even after being told explicitly:

- the removed login link;
- the dropped database index;
- the silently wrong aggregate;
- and the permissive CORS left at `origins "*"`, that last one under the same bar that had already knocked down Grok 4.5 and Gemini 3.7 Flash.

Not even running it at home lets that specific vulnerability slide by. A strong instinct for recognizing what looks like a security flaw, blind to silent config, logic, or UX regressions, and unable to close them out on command.

> Local viability today is a question of tooling and reasoning coherence over time, not available context size.

The final result leaves this model squeezed between DeepSeek V4 Pro base (82.0) and Qwen 3.7 Max itself (79.0), reinforcing again that a model's nominal tier doesn't predict vigilance.

## The Bottom of the Table, and Who Didn't Survive

Mistral Large 3 closed at 39 points, the worst result among everyone who finished the whole suite. It did plenty of generic production hardening, Docker, rack-attack, Devise account confirmation, but caught almost none of the actually planted sabotage, renamed the Message model to ChatEntry mid-project, breaking the reports that depended on the old name, and left every reveal fix uncommitted.

Mistral's result here is a symptom of something much bigger. Mistral was once one of Europe's most promising labs, the proof the continent could still compete head-to-head on frontier models. Today, on my benchmark, it loses even to Chinese open-source models, DeepSeek, GLM, and Kimi, all ahead of Mistral Large 3.

The nuclear shutdown is just the clearest single example. The European Union's entire policy, year after year, prioritizes populism over real innovation incentives, and the same pattern repeats in data regulation, AI regulation, licensing bureaucracy, and venture-capital taxation. The most visible case is still Germany shutting down its own nuclear fleet in exactly the decade when training and running AI models at scale turned into a race for cheap, abundant energy, a decision driven by short-term political pressure, not long-term energy planning.

The United States and China are racing over who builds more data centers and more power generation to feed those data centers. Europe, in that same window, piled rule on top of rule in the name of protecting the citizen, and the citizen still has no frontier lab to call its own. Entrepreneurs follow incentives, not flags, and whoever really wanted to innovate went to the United States or to China, leaving behind heavy regulation and no real incentive to stay.

> Mistral's fall, from a top name to a model that loses to Chinese open source, is a miniature portrait of the whole continent. Europe needs to change course, and at this point it should already have.

### Who Didn't Survive the Format

Six models from the weaker group simply didn't survive the format:

- **Codestral 2508** and **Hunyuan A13B** never even built a functional app in the first sprint.
- **GPT-OSS 120B** just sat there, doing nothing concrete, for two attempts in a row on the second sprint.
- **Devstral 2512**, **Llama 4 Maverick**, and the brand-new **Mistral Medium 3.5** all fell into the same structural mistake: they built the app inside a nested subfolder instead of the project root, breaking the way the harness accumulates one sprint on top of another.

That's the third case of this exact mistake, a real pattern, not an isolated coincidence.

## The Universal Law: Detection Tracks Disguise, Not Severity

Looking at all thirty-nine models together, a pattern repeats from one end of the table to the other, regardless of tier or price: what survives almost everywhere is sabotage disguised on purpose, especially the guard-test half that fakes passing, the silent wrong aggregate in an admin report, the dropped database index that doesn't call attention to itself, and the XSS via `innerHTML` that only shows up across two contexts at once.

> A model catches what breaks a test or crashes a page with a 500. Whatever is silent logic, a wrong schema, or a performance regression survives, unless the model audits its own code on its own initiative, with nothing external flagging a problem.

## And the Rumor That Kimi Secretly Talks to Claude

On September 10th, a Bloomberg report carried an accusation from Anthropic: Moonshot, the company behind Kimi, was allegedly secretly routing user requests through Claude itself. Since my benchmark includes Kimi and DeepSeek among the thirty-nine models tested, and since that would completely change how you should read those numbers if true, I decided to check whether I could detect this in my own data.

### Why the Most Obvious Test Is Impossible

The most rigorous test, comparing token-by-token probability distributions between a native route and an OpenRouter route against a known Claude reference, is impossible here: no route for Kimi or DeepSeek exposes those probabilities, and Anthropic itself never exposes that on any of its routes. The substitute was a battery of questions designed to get a model to reveal its identity: who made you, what's your name, your knowledge cutoff, and whether it refuses to repeat its own system prompt, run at temperature zero across every available route.

> Real routing would be consistent per route. Training contamination, by contrast, affects every route equally.

### The Alarming Signal That Didn't Repeat

Moonshot's native API was suspended over an account issue, and DeepSeek's native API had no available key, so part of the test was limited to Kimi's CLI and OpenRouter for both models. Even so, an alarming signal showed up on the first pass: `moonshotai/kimi-k2.7-code` via OpenRouter answered that the company behind it was Anthropic, and refused to repeat its system prompt with a phrase nearly identical to Claude's own standard refusal.

It didn't repeat. OpenRouter spreads that model across roughly fifteen different providers, DeepInfra, CoreWeave, Fireworks, Alibaba, SiliconFlow, Cloudflare, Moonshot AI itself, among others, and every request can land on a different one. Running it again, every single response came back as "Moonshot AI" or "Kimi."

The decisive test was pinning each of the fourteen providers individually and asking for identity on each one: **every single one, no exceptions, answered "Moonshot AI."** Real routing would be consistent one hundred percent of the time for whichever provider was doing the relaying. **It was zero for fourteen.**

### The Most Likely Explanation

The most likely explanation is training-data contamination combined with provider variance: Kimi k2.7-code was probably trained, in part, on output generated by Claude itself, and a trace of that surfaces occasionally when no identity system prompt overrides that tendency, on top of quantization and template differences across OpenRouter's fifteen hosts. That's not live routing, because routing would be consistent per route and per provider, and it wasn't.

DeepSeek, for its part, answered as DeepSeek on every route tested, with an October 2023 knowledge cutoff and a bland leaked system prompt, "You are a helpful assistant," no Claude signal whatsoever.

There's independent evidence backing this reading, coming straight from v4 itself: Kimi's detection "fingerprint," meaning which sabotages it catches and which it lets through, doesn't match any Claude model in the table. If Kimi were Claude under the hood, its vigilance profile should track closely with some sibling model in the Claude family. It doesn't: Kimi K2.7 scored 87.25, Kimi K3 scored 85.0, and neither one lines up with any Claude row in the table.

### The Limits of All This

This isn't definitive proof. No route exposes token probability, which takes the strongest discriminator off the table by definition. Kimi's native API was suspended and DeepSeek's had no key, so a clean comparison between native weights and the OpenRouter path was only partially possible. And a behavioral signal can be masked; the absence of a leak isn't proof of the absence of routing.

But the one positive signal that showed up fell apart the moment it was investigated closely, and everything else points away from real routing.

> On the evidence I was able to gather, neither Kimi nor DeepSeek shows a detectable live relay to Claude. The scary-looking finding from the first pass turned out to be a reproducibility artifact of OpenRouter's load balancing across providers, not a backdoor into Anthropic.

## Closing Out Both Parts

Putting Part 1 together with this one, the conclusion I drew from these nine days and four thousand dollars is the same one I'd already been arguing since July, just with better resolution now. Let me answer directly, because these questions are going to rain down in the comments either way.

**DeepSeek finally caught up.** V4.1 Flash scored 92.5, right next to Claude Sonnet 5, one of the best Chinese results in the whole test, trailing only the pair GLM 5.3 and Nex N2.5 Pro, tied at 94.0. It's a visible climb, snapshot by snapshot, as I showed in the previous section, not a lucky one-off run.

**Open source in general is genuinely getting better,** not just DeepSeek. GLM 5.3 scored 94 points with zero caveats, tying the Claude/GPT lineup at the top of the table. But running that at home, on consumer hardware, still isn't ready: the local Qwen 3.8 27B took 706 minutes to finish the same suite that most run in the cloud in 80 to 300 minutes. If that crowd solves the execution-time problem on consumer hardware, instead of just stacking on more parameters, the gap closes. It hasn't closed yet.

**At the top, convergence keeps running head-first into any explosive-leap narrative.** Six models tied at 100 points by completely different routes, and the real capability difference only showed up much further down the table, not at the top. That's one more piece of evidence for the S-curve theory I've been arguing for a while now: frontier-model capability has flattened at the top, and what's left to fight over is cost, speed, and audit discipline, not a leap in intelligence.

**And the practical takeaway is straightforward:** for everyday Rails programming, with nobody trying to sabotage your code, picking any Tier A model is essentially a wash. Astra, Opus 5, Fable 5, GPT 5.6, GLM 5.3, DeepSeek V4.1 Flash, any of them delivers an equivalent result. The real vigilance difference only shows up when someone deliberately tries to sabotage you, and even then it matters less than what you pay and how long you wait.

> The real resolution gain showed up further down the table, where there was still room to separate who genuinely audits their own code from who just delivers what was asked, and in the concrete finding that a free model and a flat subscription plan compete on equal footing with the most expensive models on the market for this specific task.

That holds true only within my benchmark's specific methodology: the ability to program Ruby on Rails, coordinate changes to code that already exists, and not let a planted vulnerability slip by. It isn't a verdict on math, academic writing, or any other programming language. Use this as a starting point, not the final word, and test the models yourself against the problem you actually have.

All the code, the fourteen sabotage prompts, the sprint-by-sprint evidence ledger, and the full reports, including the Kimi investigation, are at [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark), in the files [`docs/success_report.v4.combined.md`](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.v4.combined.md), [`docs/success_report.v4.per_model.md`](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.v4.per_model.md), and [`docs/relay_fingerprint_findings.md`](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/relay_fingerprint_findings.md).
