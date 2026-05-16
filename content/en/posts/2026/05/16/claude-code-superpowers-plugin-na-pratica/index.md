---
title: "Claude Code superpowers: the plugin that changes how a team ships"
date: 2026-05-16T11:00:00-03:00
draft: true
translationKey: claude-code-superpowers-plugin-na-pratica
category: entregas-rapidas
tags: [claude-code, superpowers, ai, productivity, skills]
author: pablo-winter
description: "Claude Code superpowers isn't just another AI plugin — it's how you encode team knowledge into a place the machine reads and executes every time."
cover: covers/claude-code-superpowers-plugin-na-pratica.png
cover_alt: "Nextside symbol in red on cream background, placeholder cover illustration."
cta:
  servico: sprint
  posicao: ambos
  contexto: "This way of working — AI + encoded process — fits exactly in a 4-week Sprint."
canonical: ""
---

**TL;DR:** can you ship quality software with plain Claude Code? Yes. But there's fine print.

The fine print is: it depends on your seniority level to cover what the AI doesn't, and on the methodology you can keep in your head. For 1-2 parallel tasks, vibe coding with Claude Code does the job. For 5-6 simultaneous tasks — where Nextside lives — the human brain can't hold it. That's where encoded methodology comes in.

Superpowers is encoded methodology packaged as a plugin: skills, agents, slash commands, hooks. Instead of reinventing SDD (Spec-Driven Development) and your own harness engineering — which costs weeks of R&D — you use what thousands of devs are validating in parallel. Plugin bug fix lands for you for free. New feature lands for you for free. It's open-source working the way open-source should.

I tested it. We tested it. This blog you're reading was built with Claude Code + superpowers from start to finish — design system, Hugo layouts, agent pipeline, frontmatter, this very post. And what caught my attention most wasn't speed. It was discipline.

## Plain Claude Code with vibe coding works — until it breaks

[Fabio Akita wrote about Agile Vibe Coding](https://akitaonrails.com/2026/02/23/vibe-code-fiz-um-indexador-inteligente-de-imagens-com-ia-em-2-dias/) and he's right. You can ship a whole feature in 30min using plain Claude Code, talking to the AI, iterating fast. Vibe.

And it works. For 1 task. For 2 tasks.

> "So why the plugin?"

Because the real work at Nextside isn't 1 task. It's 5. Sometimes 6.

Vibe coding with 1 context = productive. Vibe coding switching context every 15min = your head in pieces by 5pm, with nothing solid shipped.

When parallelism enters, vibe isn't enough. You need:

- **Forced brainstorming before coding** — so you don't start the wrong task
- **Mandatory tests at code-time** — so you don't come back to debug in 2 days
- **Plan written by an agent** — so you can read it later and remember where you stopped
- **Automatic UX review** — so you don't forget to check the visual result
- **Skill with checklist** — so each task type runs the same way

You can build all of this yourself. You'll spend 2-3 weeks, validate with your team, debug the first iteration. **Or use the superpowers plugin that already has it — and get new features other engineers already validated.**

The plugin doesn't take the vibe away. It takes the **mess out of parallelism**. You're still in command — just with guard rails where human fatigue would already have betrayed the result.

## What superpowers is, without the hype

Superpowers is a plugin for Claude Code (claude.ai/code, Anthropic's CLI) that adds three concrete things:

- **Skills** — markdown files that describe "how to do X." Each skill has a trigger (when to use it), steps (what to do), and rules (what not to skip). Claude reads the skill before executing the task.
- **Agents/Subagents** — specialized invocations. You launch a "UX review subagent" that has its own context, its own prompts, and its own tools. Doesn't pollute the main context.
- **Slash commands** — shortcuts you type (`/code-review`, `/ship`, `/init`) that fire complex flows. Each one reads the repo, executes steps, and reports back.

Sounds like saved prompts? It is. But the difference isn't the content — it's the **ritual**. Skill enforced means Claude reads the skill BEFORE it starts working. There's no chance of skipping the TDD step. No chance of skipping the brainstorming checkpoint. The skill is an automatic trigger.

And that's where the shift happens.

## How it changes the real workflow

Without superpowers, Claude Code is a good generalist AI. You open it, describe the task, it tries to solve it. If you forget to ask for tests, it doesn't write tests. If you forget to ask for brainstorming before coding, it jumps straight to implementation. Result: lots of generated code, lots of thrown-away code.

With superpowers, the game is different:

- **TDD enforced** — the `test-driven-development` skill forces Claude to write a failing test BEFORE writing the implementation. Always. For every bugfix, every feature. Non-negotiable.
- **Brainstorming before code** — the `brainstorming` skill requires that, before any creative work, Claude explores the problem with you. Asks questions. Lists alternatives. Only then proposes a solution.
- **Systematic debugging** — found a bug? The `systematic-debugging` skill forces methodical investigation instead of guessing. The first hypothesis isn't the bet — it's the starting point of a cause tree.
- **Verification before completion** — Claude can't say "done" without running verification. Runs the tests, shows the output, then asserts. Goodbye "should work."

Notice the pattern: each skill is a way of encoding senior engineering discipline. What experienced devs do out of habit — TDD, brainstorming before code, methodical debugging, verify before asserting — becomes a rule the machine executes.

And here's the key point: **this isn't about giving AI superpowers. It's about giving AI the habit set of your best senior dev.**

## How Nextside used it to build its own blog

The Nextside team built this blog (`blog.nextside.tech`) using Claude Code + superpowers. Stack: Hugo + Hextra theme, custom CSS design system, editorial agent pipeline, bilingual pt-BR/EN.

Typical flow for a design system feature:

1. **Brainstorming session** — I describe "I need a hover state for the post card." Claude (via brainstorming skill) asks 3-4 questions: "ember glow or just elevation?", "mobile too or desktop only?", "behavior in dark mode?" Only after that does it propose an approach.
2. **Written plan** — the `writing-plans` skill forces Claude to write a detailed plan before coding. The plan goes into a spec file. I review it. Approve or request adjustments.
3. **Execution with TDD** — the `executing-plans` skill follows the plan. Each plan step becomes a checkpoint. The TDD skill forces a test before code (when applicable — in pure CSS, it becomes visual verification).
4. **Automatic UX review** — before the commit, it launches a [dedicated UX review agent that opens the site in the browser via MCP Playwright](/en/posts/2026/05/16/mcp-playwright-validacao-local-com-qualidade/), navigates, takes screenshots, and flags problems.
5. **Commit + push** — only after everything is green.

Notice: zero disorganized vibe coding. Zero "let me try something." Zero "should work." It's a pipeline.

And the result comes because the pipeline is repeatable. The next feature goes through the same checkpoints. Same skill. Same agent. Doesn't depend on my memory of "what did I ask for last time?"

That's what changes for a team. When knowledge is encoded in a skill, any dev on the team invokes the same Claude and gets the same standard. There's no dev "who knows how to use Claude well" and dev "who doesn't." The knowledge lives in the plugin.

## What improves vs plain Claude Code

Concrete before-and-after:

- **Real speed (not perceived)** — plain Claude delivers too fast. You think you saved time, but spent 2h redoing it. With superpowers, the first delivery takes a bit longer — because there's brainstorming, a plan, TDD — but it's the delivery that sticks.
- **Less slop** — slop is generated code that looks right but isn't. Without superpowers, slop shows up constantly. With superpowers, the verification step catches it before the commit.
- **Reproducibility** — another dev on the team invokes the same `/code-review` and gets a review with criteria identical to mine. Doesn't depend on the prompt I wrote at 3am on a Saturday.
- **Faster onboarding** — a new dev on the team doesn't need to memorize process. They install superpowers, read the skill and slash command catalog, and already work the way the team works.

That last one surprised me the most. I always thought "team process" meant a doc in Notion. Turns out it doesn't — it's a skill in Claude. Nobody reads Notion docs. A Claude skill executes every time the task starts.

This matters: **process documentation is fiction. Executed skill is actual process.**

## Honest limits (it's not magic)

Hold on. Superpowers doesn't solve everything:

- **Doesn't replace senior devs** — it replaces the grunt work of senior devs. Real architectural decisions still require a human in the loop. Who picks the stack, who decides the performance vs DX trade-off, who makes the product call — that's people.
- **Slip can still escape** — the verification step isn't omniscient. If the test is wrong, the "all green" is a false positive. You still need to look.
- **Context cost** — skills fill the initial context. If you have 30 skills loaded and the repo is huge, performance drops. You have to curate active skills.
- **Doesn't learn on its own** — superpowers doesn't evolve by itself. If a team pattern changes, someone has to update the skill. Without maintenance, it goes stale — and then the AI executes old process with full conviction.

And the critical point: **superpowers is a lever, not an autopilot**. You still need to think. You need to review the plan Claude wrote. You need to decide when the brainstorming session has gone on too long. The skill is the ruler, but you're the one holding it.

> "But if the AI does everything, what's the dev's role?" — good question. Answer: the dev becomes **architect + reviewer + taste dictator**. No more typing boilerplate. Decides the what, reviews the how, and calibrates the tone. It's a more senior role, not less.

## What this plugin says about the future of work

Here's the point that matters most.

For years, team process meant documents. [ADRs in Notion](/en/posts/2026/05/16/adrs-decisao-no-notion-sem-burocracia/). Checklists in Confluence. Playbooks in Google Docs. All passive. All ignored after the second week.

Superpowers changes that because it turns process into **code the AI executes**. The skill isn't a doc — it's an instruction that fires every time the task starts. Nobody needs to remember to "run the playbook." The AI runs it by itself.

This has a big implication: the engineering knowledge that used to live in senior devs' heads now fits in a markdown file that another team member invokes via slash command. **Encoded knowledge**, executed by machine, scaled to the whole team.

Not magic. Doesn't replace seniority. But it's the first time I've seen "team process" leave the page and become real, repeatable behavior — without depending on someone to police it.

And that changes the game. Full stop.

That's why the Nextside team runs Claude Code + superpowers in [every 4-week Sprint](https://nextside.tech/#sprint). Not as a productivity tool. As a **way of ensuring the Nextside way of working happens every time, without a human having to remember.**

Those who document process in PDF are fighting an old war. Those who encode process in skills are shipping while the others write playbooks.
