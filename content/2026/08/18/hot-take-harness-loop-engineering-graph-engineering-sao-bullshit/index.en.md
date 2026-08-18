---
title: "Hot Take: Harness, Loop Engineering, Graph Engineering Are Bullshit"
slug: hot-take-harness-loop-engineering-graph-engineering-are-bullshit
date: '2026-08-18T13:00:00-03:00'
draft: false
translationKey: hot-take-harness-loop-engineering-graph-engineering-sao-bullshit
description: "I posted that Harness Engineering, Loop Engineering, and Graph Engineering are bullshit to sell consulting hours and courses. Here's my receipt: 30+ public repos, an AI marathon, and a whole benchmark — none of it using any of those 'disciplines'."
tags:
- artificial-intelligence
- llms
- vibe-coding
---

[![Hot take on X: Harness, Loop Engineering, and Graph Engineering are all bullshit to sell more consulting hours and courses](tweet-hot-take.png)](https://x.com/AkitaOnRails/status/2089734682325794897)

I posted [this tweet](https://x.com/AkitaOnRails/status/2089734682325794897) this morning and it struck a nerve. The full point: when the technology itself becomes a commodity, the money migrates to taxonomy. They invent five new names for chaining API calls and suddenly there's a certification that expires in six months.

Let me back up the provocation properly, because it's not a gratuitous jab.

Let me preempt the standard comment: *"but it works for me."* Good for you — honestly. Except "it works for me" never proved the ceremony is what made it work. What made it work is you knowing what you wanted. The ceremony just happened to be in the room.

## My receipt

Between January and May I ran an [AI marathon](/en/2026/05/14/wrapping-up-my-ai-marathon-success-or-failure/) and published [over 30 public repositories](https://github.com/akitaonrails?tab=repositories). There are tools I use every day — [ai-memory](https://github.com/akitaonrails/ai-memory), [ai-usagebar](https://github.com/akitaonrails/ai-usagebar), [ai-jail](https://github.com/akitaonrails/ai-jail) — and personal apps built to scratch my own itch: [Frank Manga+](https://github.com/akitaonrails/frank_mangaplus), [Frank Scanlation](https://github.com/akitaonrails/frank_scanlation), [Frank Geary](https://github.com/akitaonrails/frank_geary), and so on.

You know what I never once felt the urge to do in all that time? Complicate my AI setup. I don't have a super-customized [Pi](/en/2026/05/25/first-impressions-using-oh-my-pi-and-opencode/), no Hermes, no orchestrated agent graph, no numbered-spec pipeline. Thanks to ai-memory, **I swap harnesses like I swap underwear**: daily, no drama. Claude Code in the morning, Codex in the afternoon, Kimi CLI at night — the project memory travels with me, so the harness becomes a detail.

And detail is the point. Most harnesses are optimized for their own company's LLM. But "optimized" doesn't mean "magic," and I have data on that.

## What my benchmark says about harnesses

In [my LLM Coding Benchmark](/en/2026/08/15/llm-benchmarks-qwen-3-8-glm-5-3-gemini-3-7/) I run the same models through different harnesses under controlled conditions. The result is the opposite of what the course market implies:

- **For a weak model, the harness rescues.** Grok 4.3 built nothing on bare opencode (18 points) and delivered a real app on the grok CLI (55). Gemini 3.1 Pro went from 62 to 88 on Google's own harness — but the problem there was an OpenRouter transport bug, not a lack of "harness engineering."
- **For a frontier model, the harness is noise.** Grok 4.5: 92 on opencode, 91 on the grok CLI. Grok 4.6: 92 and 93. A one-point difference, inside the margin of error. No amount of harness engineering moves a good model.
- **Where the harness actually bites is your wallet.** The Grok 4.6 run cost $1.19 on the grok CLI versus $6.33 on opencode via OpenRouter — **over 5x cheaper** for the same ~11 million tokens, because the official CLI uses xAI's native prompt caching. Same story on Codex: GPT 5.6 Terra cost $6.77 blended because 21 of its 21.7 million tokens were cache hits; Sol, same family, same score, cost about $45.

So yes, picking a decent harness matters — for cost, and to give structure to a weak model. But that's an afternoon of reading docs and watching your token bill, not a new discipline with a learning track.

Since I mentioned Hermes up there, it's worth explaining: [Hermes Agent](https://github.com/NousResearch/hermes-agent) is an open-source framework from Nous Research for building *your own* personal agent — you define the tools, write the loops, configure per-model routing, local/cloud fallback, Telegram and Discord gateways, and it even "learns skills" from use. It's paradise for the setup crowd.

It's also a second job: every one of those pieces becomes yours to maintain, update, and debug, forever. And at the end of the day the engine is still the same Claude, GPT, or Qwen everyone else has — the custom chassis doesn't improve the engine. What Hermes actually solves, context continuity across sessions and tools, a decent harness with something like ai-memory already covers — without you becoming the infrastructure administrator of your own assistant.

If you want an assistant on your own hardware as a hobby or for privacy, that's a great reason, go for it. As a productivity prerequisite, it's not one.

> **Remember this:** a good harness is one that charges less and stays out of the way. The rest is the model. And a good model doesn't need "harness engineering" — at most it needs the transport not to be broken.

## Loop Engineering, Graph Engineering, Spec-Driven Development

On to the names, because they describe real things — just tiny ones.

**Loop Engineering** is this season's name for designing the cycle an agent repeats: execute, verify against evidence, iterate until a stop condition. The guides list real failure modes — the agent declaring "done" too early, the goal drifting on each pass. But the recommended mitigation is "an independent verifier checking objective evidence." That's had a name for fifty years: **tests and code review**. An agent in a loop with a test suite isn't a new discipline; it's the basics with a new name.

**Graph Engineering** is drawing the agent's workflow as an explicit graph of nodes, branches, and joins — LangChain has [three years of that story](https://www.langchain.com/blog/3-years-of-graph-engineering-with-langgraph). It makes sense when the flow is genuinely branched. Except the overwhelming majority of projects aren't a graph: they're a straight line with an `if` in the middle. Modeling that as a graph is buying a giant whiteboard to draw one arrow.

**Spec-Driven Development** is writing a detailed specification first and treating the code as an artifact generated from it — the spec becomes the "source of truth" and the code, a byproduct. Hold that thought, the strong argument is coming right up.

Notice the pattern: each name takes a real, small practice — looping with verification, drawing a flow, writing down what you want before building — and inflates it into a "discipline." The inflation is the product. A new name creates a course, the course creates a certification, the certification expires in six months and sells you the recertification.

To be fair: the serious guides on these topics already carry the caveat — the most-read [graph engineering guide](https://www.aibuilderclub.com/blog/graph-engineering-guide-2026) says outright that "you probably don't need it" and tells you to master the loop before opening a graph, and LangChain has a whole "when not to use graphs" section. The problem isn't the guide; it's the funnel that throws away the caveat and sells the rest as everyone's default.

The two that sell the most courses — heavy agent orchestration and spec-driven development — deserve more than definitions. They deserve the argument.

## The strong argument against super-orchestration

There's simple math that orchestrated-agent diagrams never show. If each step of your pipeline succeeds 90% of the time — and that's optimistic — a ten-agent chain succeeds 0.9^10, or **~35% of the time**. Every node is a new failure point, and every edge is tokens spent on agents talking to agents instead of working.

You don't have to take the math on faith: I accidentally measured it in the benchmark. MiniMax M3 running under an orchestrator looked like Tier D, with 24 points. The same model, clean, scored 91 — Tier A. A swing of up to 69 points between harness conditions means the opposite of what the orchestration vendor claims: **when the plumbing dominates the result, you stopped measuring the model and started measuring the plumbing.** The best result in the entire benchmark didn't come from any orchestrated swarm: it came from one strong model, alone, in a simple loop — Fable 5, 96 points, Claude Code, done.

It makes sense once you remember coordination scales badly. Each additional agent doesn't just add capacity; it adds edges, message contracts, shared state, and conflicting versions of the truth. The router deciding "which agent handles this" becomes both the bottleneck and the bug farm. A committee of mediocre agents with a conductor doesn't beat one capable agent with good tools and memory.

I've tested this directly. Back in April I ran [three rounds of "strong model orchestrating cheaper models"](/en/2026/04/25/llm-benchmarks-vale-a-pena-misturar-2-modelos/) — planner + executor, forced delegation, the full package. The result: **no multi-agent combination beat the Opus running solo** in a mature harness. On a cohesive task like building an app, the planner has to read every output from the executor before dispatching the next step — the two become sequential, with tripled latency and a coordination queue in the middle. It's the committee again: lots of talking, little software.

It's not just my benchmark. Cognition, which sells Devin, published ["Don't Build Multi-Agents"](https://cognition.com/blog/dont-build-multi-agents) with a mechanism sharper than my 90% math: **every action carries implicit decisions the other agents can't see** — one subagent draws a Mario-style background, another draws an incompatible bird, and no amount of individual reliability fixes the divergence.

Anthropic itself, which runs a multi-agent research system, [admits in its engineering post](https://www.anthropic.com/engineering/multi-agent-research-system) that multi-agent burns **15x more tokens**, that coding is a poor fit for it — most coding tasks aren't truly parallelizable — and that 80% of their improvement came from simply spending more tokens, not from the architecture.

When Berkeley measured what actually runs in production, [86 systems across 26 domains](https://arxiv.org/abs/2512.04123): 68% of production agents execute at most 10 steps before human intervention. What's really out there is the simple supervised loop — not the constellation of colored nodes on the consultant's diagram.

Where orchestration is legitimate: genuinely parallel, independent work — scanning ten thousand files, running ten thousand disposable analyses. Map-reduce has existed for twenty years and never needed a pompous name. And there's one serious corner beyond it: agents running overnight, unwatched, holding credentials — there, independent verifiers and hard budgets become a security matter, not a style one. But that's fleet operations, not the day-to-day coding the course is selling you. Outside those niches, most "multi-agent architectures" are one agent's job with extra YAML.

There's a reason you hear so much about it: orchestration is **visible** complexity. It has diagrams, colored nodes, dashboards. A well-driven agent has none of that — no slide deck, no certification, nothing to sell.

> **Remember this:** every added agent multiplies the failure modes. If your system's result changes when you swap the orchestrator, your system is the orchestrator — and the model was the costume.

## The strong argument against spec-driven development

SDD sounds mature because it sounds like "writing documentation." But look at what it actually proposes: the spec becomes the source of truth and the code becomes a generated artifact. The problem is that **a spec precise enough to generate correct code already is a program** — except written in prose, and prose doesn't compile. Every ambiguity in the spec is a bug no compiler catches, in a medium with no tests, no linter, no feedback. SDD doesn't remove the hard part, which is thinking precisely; it moves the hard part into a format where errors don't scream.

> **Remember this:** a spec precise enough to generate correct code already is a program — except in prose. And prose doesn't compile.

Even if you write the perfect spec, it starts dying with the first hotfix. A bug shows up in production, someone fixes it straight in the code, and the spec becomes a lie. We've known this law for decades — it's why documentation rots. Calling the spec the "source of truth" doesn't change anyone's incentives.

We've run this experiment before, by the way. UML, MDA, "the code generates itself from the model" — twenty-odd years ago it was the same promise with different acronyms. It collapsed every time for the same reason: the model was never the reality; the code was. SDD is MDA with an LLM bolted on. And [I'm not the only one seeing Waterfall 2.0 there](https://www.alexcloudstar.com/blog/spec-driven-development-2026/).

The people who tested the tools seriously landed in the same place. Thoughtworks put spec-driven development in the ["Assess" ring of its Technology Radar](https://www.thoughtworks.com/radar/techniques/spec-driven-development) — not "adopt", "assess" — after watching the tools inflate small tasks into ceremony, and nailed the summary: we may be *"relearning a bitter lesson — that handcrafting detailed rules for AI ultimately doesn't scale."* That's Rich Sutton's Bitter Lesson knocking again — handcrafted structure loses to scale, it always has.

There's also the temporal inversion. The great lesson of agile was that you discover what you want **by building** — working software over comprehensive documentation. LLMs just made iteration cheaper than it's ever been. And what does SDD propose? Expanding the planning phase, right now that iterating got cheap. Wrong answer, wrong direction, wrong time.

It's the thesis I've been hammering since the first [Agile Vibe Coding](/en/2026/02/23/vibe-code-built-a-smart-image-indexer-with-ai-in-2-days-frank-sherlock/) posts: **software emerges, it isn't planned**. [I wrote this back in February, with receipts](/en/2026/02/20/zero-to-post-production-in-1-week-using-ai-on-real-projects-behind-the-m-akita-chronicles/): the most important features of the M.Akita Chronicles were born from problems that showed up mid-way — a job that failed silently, a site that blocked the gem, a crash that left emails in limbo. No spec in the world predicts that. The correct system emerges from iteration, not from specification.

The process got documented again when ai-memory grew through 26 contributors in 24 days: [good software is a clay sculpture, not a Lego tower](/en/2026/06/14/ai-memory-emergent-architecture-malleable-software/) — malleable, always adjustable, never done. Whoever tries to design the whole architecture before the first line builds a straitjacket, not a system. Only amateurs still believe you can spec out an entire piece of software before coding it. Real modeling doesn't come from templates or courses — [I covered this years ago in Akitando 144](/2023/08/11/akitando-144-modelagem-de-software-e-dificil-ver-vs-enxergar/) (video in Portuguese): it's born from a repertoire of real problems and real code. There's no ready-made recipe; there never was.

SDD tries to resurrect the idea that you can plan software ahead of time — the idea the industry buried after decades of projects delivered late, wrong, and over budget. LLMs didn't revalidate that idea; they just gave it a new slide deck.

Even the pro-SDD guides separate the two things: ["spec-as-source is where the hype lives; spec-anchored is where the value is today"](https://dev.to/krlz/spec-driven-development-in-2026-what-it-is-the-tooling-and-how-teams-actually-use-it-2fk2). My target here is the former. Where heavy specs are legitimate: large teams, legacy codebases, asynchronous work crossing time zones and sprints — the good old design document, which has always existed and always had value. What doesn't fly is selling that as the new default for everyone.

My benchmark prompt, for the record, is one page of goals. The difference is that I don't trust the prose: I validate by running it. Precision lives in tests, not in paragraphs.

## What you actually need

I've already written all of this on this blog, with real-project receipts. It's called [Agile Vibe Coding](/en/2026/02/23/vibe-code-built-a-smart-image-indexer-with-ai-in-2-days-frank-sherlock/), and it fits in a paragraph:

It's XP (eXtreme Programming, the original agile) with an LLM: tests, [Clean Code](/en/2026/04/20/clean-code-for-ai-agents/), CI (continuous integration), pair programming, and deploy. You drive the agent like you'd drive a very fast pairing partner: say what you want, watch the execution, correct while mistakes are still cheap. The idea is 10% of the work; the other 90% is normal software engineering, the usual kind. [You don't need a framework or a three-page template](/en/2026/04/15/how-to-talk-to-claude-code-effectively/) — you need to know what you want, know what you don't want, and know how to validate when it arrives. And you need balance: [neither handing the wheel to the agent nor turning into a comma cop](/en/2026/04/11/vs-code-is-the-new-punch-card/).

That's over 600 hours of it, over half a million lines, dozens of projects shipped. No graphs, no certifications, no loop with an English name.

> **Remember this:** the idea is 10% of the work; the other 90% is plain software engineering, the usual kind.

## The piece that lets me swap harnesses: ai-memory

One of my own tools is the opposite of taxonomy: [ai-memory](https://github.com/akitaonrails/ai-memory). It was born from a concrete problem. Every harness stores its session in its own format, and when the conversation gets long, it compacts the history to fit the window — and compaction throws away exactly the details that explain why each decision was made. Then you switch tools and start from zero, with the whole project to re-explain.

ai-memory solves this from outside the harness. It reads the native session without touching the original file and stores everything in a searchable ledger: messages, tool calls with results, compaction summaries, a git checkpoint — every event tagged with its origin (from Claude, Codex, OpenCode). When I open another harness, it gets its own native session and receives only the delta it hasn't seen. When I go back to the previous one, ai-memory resumes it in that client's format and hands over what happened on the others meanwhile.

That's why "I swap harnesses like I swap underwear" isn't a figure of speech. **The project's knowledge lives in the project, not in one tool's session.** If Anthropic changes pricing, limits, or models tomorrow — and they will — I swap the engine without throwing away the trip. The details of how this works are in [this post](/en/2026/07/20/whats-new-ai-memory-switch-agents-without-losing-session/).

There's an inversion here that takes SDD down as a bonus. Spec-driven development says the source of truth is a document written **before** the work, trying to predict the future, and that the code owes it obedience. ai-memory does the opposite: the source of truth is a [wiki distilled from the work itself](/en/2026/06/16/ai-memory-long-term-memory-karpathy-wiki-self-improvement-hermes-projects/) — every session becomes evidence, and what deserves to survive (decisions, rules, gotchas, failed attempts) gets consolidated into short Markdown pages that any agent reads before starting.

The spec tries to guess the project; the wiki records the project. A document written beforehand rots at the first hotfix, because nobody is forced to update it. The wiki is fed by the very act of working — and when it goes stale, you notice immediately, because the agents trip over it every session.

Notice that this is real harness engineering: one tool, written once, solving a problem of mine. No course, no acronym, no certification.

## Conclusion: ask for the receipt

Don't waste time or money on a "harness engineering" course, "loop engineering," or whatever taxonomy is trending this week. It's a shameless attempt to charge you for things you already do if you know basic software engineering.

We've seen this movie before, by the way. [Pedro Arantes nailed it on X](https://x.com/arantespp/status/2089752215380426951): *"Microservices, clean architecture, hexagonal, and Domain-Driven Design are all bullshit to sell more consulting hours and courses."* Same story, same script. Each of them was born from a real problem — and became the default for people who didn't have the problem. Microservices for a three-person team, hexagonal architecture for a CRUD (the plain old create-read-update-delete app), DDD to never write code again. The technique passes, the taxonomy stays, the course sells.

So nobody plays dumb: **none of this is useless**. A loop with verification works. A graph works when the flow is genuinely a graph. Heavy specs save large teams. Microservices solved real problems for people with real scale; DDD shines in genuinely complex domains. The problem was never the tool — it's selling the tool as a **silver bullet**, the universal hammer you must apply to everything. Silver bullets don't exist, they never have. Whoever sells you one isn't selling a solution; they're selling a course.

Understand the psychological mechanism, because it's old and efficient: those terms exist to give you **FOMO** (Fear of Missing Out). To make you anxious, thinking you're falling behind, that you're leaving productivity on the table, that everyone else already migrated to the new paradigm and you haven't. Anxiety sells. Once you're insecure, they charge you to implement something you never needed. FOMO is real — and here, it's the business model.

The model is recurring, too — admire the elegance. First they sell you the methodology that *generates* artifacts — specs, graphs, boards, diagrams. The artifacts multiply, nobody knows where anything is anymore, and guess who shows up? The same consultancy, now selling the tool that *manages* the artifacts, the course that teaches you to manage the tool, and the artifact-governance workshop. It's the shovel salesman congratulating you on the hole you dug — and offering you a bigger shovel.

Gartner even has an official name for it: ["agent washing"](https://www.gartner.com/en/newsroom/press-releases/2025-06-25-gartner-predicts-over-40-percent-of-agentic-ai-projects-will-be-canceled-by-end-of-2027) — take an existing product, slap the "agentic" label on it, resell. Their estimate: only about **130 of the thousands** of companies selling themselves as "agentic AI" are real, and their prediction is that 40% of such projects get canceled by the end of 2027, over cost, unclear value, or badly managed risk. That's not my grudge; it's the cycle, measured.

Next time an influencer or consultant tries to push those products on you, ask a simple question: **where are your dozens of high-quality open-source projects that got better because of those "techniques"?**

They have nothing to show. I do — [it's all public](https://github.com/akitaonrails?tab=repositories), with code, benchmarks, and documented process. When technology becomes a commodity, money migrates to taxonomy. Don't be a customer of that migration.
