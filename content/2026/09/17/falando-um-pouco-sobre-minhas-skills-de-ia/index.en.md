---
title: "Talking a Bit About My AI Skills"
slug: talking-about-my-ai-skills
date: '2026-09-17T16:00:00-03:00'
draft: false
translationKey: falando-um-pouco-sobre-minhas-skills-de-ia
description: "Agent skills are just prompts in text files. I keep 25 in my my-skills repo, from pr-audit to fact-check, and they have already closed over a thousand PRs and issues across my projects. The recommendation: don't copy somebody else's skill, build your own."
tags:
- coding-agents
- automation
- llms
---

Lately several readers have asked me about the "skills" I mention when I talk about my workflow with AI agents. This article explains what they are, how I use them, and what my actual recommendation is.

And the recommendation comes right up front, because it's the reason this article exists: **don't use other people's skills.** Read that again. My skills are published on [my my-skills repository](https://github.com/akitaonrails/my-skills) and the repo description warns you: *"not tailored for general usage"*. They're there so you can read the reasoning, understand the structure, and go build your own. Copying somebody's skill and running it blind is the digital equivalent of signing a contract without reading it. Worse: it's installing someone else's instructions to run with your permissions, on your repositories, with your tokens. That's prompt injection you install voluntarily and say thank you for.

## What a skill really is

No magic involved. A skill is a directory with a `SKILL.md` inside: a header with name and description, and a body of text that is, essentially, a well-written prompt about how to execute a task. Sometimes it ships with a `scripts/` folder of helper scripts, so the LLM doesn't have to recreate them from scratch every time.

> Skills are just prompts.

That's it. A prompt you versioned, refined, and kept one command away. The only difference between a skill and that giant prompt you paste into the chat every day is that the skill lives in a file, with a name, and the agent knows it exists.

And here's the answer to the question everybody asks: "doesn't that fill the context with junk?" The good news is the harnesses do this right. Claude Code uses what Anthropic calls [progressive disclosure](https://code.claude.com/docs/en/skills): at session start, only each skill's name and description go into the system prompt. The `SKILL.md` body only loads when the agent decides to invoke the skill. [OpenCode does the same](https://opencode.ai/docs/skills/): lists name and description, loads content on demand through its own tool. Anthropic itself [documents the design](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills): metadata first, body only when needed.

That solves the text cost, but only half the problem. Every installed skill still takes a line in the listing, and more importantly: it competes for the agent's attention when it decides which tool to use. Anthropic again, [on the engineering blog](https://www.anthropic.com/engineering/writing-tools-for-agents): *"more tools don't always lead to better outcomes"*, and their official recommendation is a few well-designed tools for high-impact workflows. My version of that rule is more acidic:

> An idle skill is debt.

You change your process, the skill ages, and one day the agent executes a rule that no longer makes sense in your workflow. Fewer skills, better written, reviewed often.

## The only third-party skill that survived here

Having said all that, it would be hypocritical to pretend I live on homemade skills alone. One survived my scrutiny and runs on every post on this blog: [Humanizer](https://github.com/akitaonrails/my-skills/tree/master/humanizer).

It exists because the Wikipedia community maintains a public, brutally honest catalog called [Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), kept by WikiProject AI Cleanup, documenting the "tells" of AI-generated text one by one: the rule of three, the "not just X, but also Y", the puffery, the emoji-decorated bullet. Humanizer turns that catalog into a procedure: the agent receives the text, marks the tells from strongest to weakest, rewrites preserving every supported claim (losing a fact is an error, inventing a fact is an error), and does a final read-aloud check. Without changing what was said, only how it was said.

If you produce content, you know why I insist: text that smells like AI is becoming the new "Dear Sir", the mark of a rushed form letter. I run Humanizer on every article before publishing, including [this one](https://akitaonrails.com/en/2026/08/16/anthropic-ai-watermark-how-to-beat-it/). But note the detail: I merged version 3.0.0 into my repo, with my own adjustments. I read the source material before trusting it. That's the pattern.

## What I do with this every day

Now the practical part. I maintain and monitor over 40 repositories on GitHub. My own projects, forks I maintain, tools that became daily dependencies. To stay sane, my second monitor runs [tclock](https://github.com/akitaonrails/clock-tui) (my fork of [clock-tui](https://github.com/race604/clock-tui), with Evangelion themes, because why not) and next to it [ghpending](https://github.com/akitaonrails/ghpending), a Rust CLI that lists open issues and PRs from all my repos at once.

![My second monitor with tclock and ghpending listing the repositories with open PRs and issues](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260917161027_screenshot-2026-09-17_16-10-27.png)

In the photo you can see: [ai-memory](https://github.com/akitaonrails/ai-memory) and [ai-usagebar](https://github.com/akitaonrails/ai-usagebar) with open PRs and issues. Every morning I open the harness on each project with `ai-memory run` in its directory. ai-memory deserves a paragraph: it's my long-term memory project for agents, a persistent Markdown wiki that captures session observations, consolidates decisions and gotchas into pages, keeps workstreams across sessions and handoffs between agents. Every project of mine has its own memory, with the architectural decisions and the traps only that codebase has. Without it, every agent session starts from zero like an intern with amnesia.

From there the daily ritual is almost childishly simple. I write, literally:

```text
run pr-audit and iss-audit, then run github-resolution
```

When a release is ripe, I add `then run the release skill`. On days when the only queue is Dependabot's automatic bumps, it's `run pr-bump and release` and done. One line of instruction from me. The heavy lifting lives in the skills. Let's get to them.

### pr-audit

PR audit before merge, and the central principle is: **evidence over narrative**. Nothing the contributor wrote is treated as truth; everything is a claim to verify, with a claims ledger (confirmed, partial, unsupported). The rest of the skill is a hostile checklist:

- **Change gate**: hunk inventory looking for executable bits, symlinks, bidirectional characters, homoglyphs, `pull_request_target` workflows, unpinned actions, typosquat dependencies, lockfile drift.
- **Credentials**: unexplained credential access is an instant blocker. Execution happens in an isolated worktree, with no host credentials.
- **Semver**: the changelog category is a version gate; breaking changes go in major, never in patch. A rule that has saved me more than once.
- **Prompt injection**: text inside a PR trying to "change the audit rules" is just one more suspicious data point to investigate. It's an audit finding, obviously.

### iss-audit

The same distrust, applied to issues:

- Never run a command copied from an issue. Attachments only go through an isolated scanner.
- Formal separation between what was observed, what was expected, the reporter's diagnosis, and the proposed fix.
- Reproduction with synthetic data in a disposable sandbox, with resource limits for DoS claims.

And two golden rules I love: *"a number that moves is not a pinned number"* (async lag looks like a bug) and *"the obvious owner may be innocent"* (query the suspect population; if it comes back empty, the cause is elsewhere).

### github-resolution

The execution phase: turning what the audit approved into merged code. The rules:

- Only execute approved tickets, one at a time, with a regression test written before the fix. *"Slop is a defect"*: no speculative abstraction, no TODOs, no drive-by refactors, no weakened tests.
- If I resolved more than three tickets in a session, run the post-audit over the whole range before pushing, no exceptions.
- A ticket closes when the fix is merged with green CI on that exact SHA, never left hanging waiting for a release.
- Every unresolved issue gets logged with the reason. Compressing it into a number is forbidden.

### pr-bump

The fast path for Dependabot's dependency bumps. The rule that saves me the most time: **batch, never serialize**. Instead of merging PR by PR, one consolidated `bundle update` to the latest compatible versions, a single CI pass for the whole set, fix forward on whatever breaks.

But there's a **supply-chain floor**:

- Every dependency must resolve on the public registry (rubygems, npm, pypi) with the expected name, version, and checksum.
- Git source, path source, typosquat-adjacent name, new install hook: full stop, it goes to a complete audit.

`bundler-audit` will happily pass a well-formed trojanized gem. That's exactly the case the floor covers.

### release

Cut a version only when I ask. The iron rules:

- The version comes from the changelog classification: fixes go in patch, additive changes in minor, breaking in major. A number that conflicts with the classification forces me to confirm; silent bumps are forbidden.
- Green CI gate on the tag's exact SHA. Never tag with pending or skipped CI.
- Annotated tag, updated changelog.
- Never rewrite a published tag. Never cut a release nobody asked for.

## The numbers, because numbers don't argue

Counting right now, on the day I write this article, across just three projects ([ai-memory](https://github.com/akitaonrails/ai-memory), [ai-usagebar](https://github.com/akitaonrails/ai-usagebar) and [ai-jail](https://github.com/akitaonrails/ai-jail)):

- ai-memory: 430 merged PRs, 260 closed issues
- ai-usagebar: 137 merged PRs, 34 closed issues
- ai-jail: 42 merged PRs, 81 closed issues

Total: **609 merged PRs and 375 closed issues**, over a thousand items. Nearly all of that was handled by these skills, with me supervising and deciding. One person, no team, keeping three active projects at this volume. That's the multiplier.

## And they weren't born ready

Open the [my-skills commit history](https://github.com/akitaonrails/my-skills/commits/master) and you see skills being polished the hard way. July starts the repo with the basic audits. Late July: *"harden audit skills and add security audit"*. August: *"consolidate agent skills from all harnesses into this repo"* and, days later, github-resolution is born as the execution phase of the audits. September: *"fold in release-discipline and audit lessons"*.

And just yesterday, look at the level of fine-tuning in pr-bump: *"batch all bump PRs into one consolidated verification pass, fix forward on failures"* and *"require deferred/declined PRs be left in a clean state"*. Two rules that became skill text. Neither came from a blog post or somebody's opinion: they came from me face-planting into the exact error the rule now prevents.

> Every line in these skills is a scar.

That's how you write a good prompt: watch the result, decide to adjust, adjust again.

## Skills are little. Knowledge is a lot.

Now the counterpoint, because I don't want you leaving here thinking skills are the answer to everything. I depend on them very little. What actually carries my workflow is something else.

Every project of mine has its own `AGENTS.md`, instructions specific to that code, and its ai-memory memory with decisions and gotchas. And the pattern I use most day to day isn't even a skill: it's pointing at a living example. When I wanted automated AUR packaging for clock-tui, I didn't write a "how to make an AUR package" skill. I opened the harness and said:

```text
make a similar github action to build and publish AUR packages
as we did in ~/Projects/ai-memory
```

The agent went there, read the workflow that works, and reproduced the pattern in the new project. A skill for that would be worse: AUR changes, GitHub Actions changes, the example gets stale. A living example in a repo I maintain is always up to date by definition, because when it breaks, I fix it.

> Every project becomes its own knowledge base.

And this generalizes, because harnesses can consume any text base. My entire Linux PC is documented and reinstallable from a config repo of mine, and my homeserver is fully described in runbooks. Those two are not on GitHub: they live on a private Gitea server I maintain, because that's the kind of thing I don't want leaking in public. When I want to change something at home, I say:

```text
add integration to my Plex server as documented in my homelab runbooks
```

That's not a skill. It's organized, versioned, searchable knowledge. Skills are for *procedures* that repeat the same way. Knowledge is for everything else.

## The recommendation worth more than any skill

If you take a single practice from this article, take this one: **have your agent write down everything that didn't become code.** The research it did, the decision you made and why, the comparison with the rejected alternative. Without that, the knowledge evaporates at the end of the session.

My ai-memory, for instance, has [a docs folder](https://github.com/akitaonrails/ai-memory/tree/main/docs) with competitor research I commissioned before every big decision:

- [The Karpathy wiki pattern](https://github.com/akitaonrails/ai-memory/blob/main/docs/research-karpathy-llm-wiki.md), the project's intellectual origin.
- [A 2026 landscape survey](https://github.com/akitaonrails/ai-memory/blob/main/docs/research-2026-landscape.md), covering Zep/Graphiti, Letta, Mem0, and Google's Open Knowledge Format.
- Deep dives on each competitor: [Hindsight](https://github.com/akitaonrails/ai-memory/blob/main/docs/research-hindsight.md) (the one with a paper and funding, which ended up validating my design bets), [cognee](https://github.com/akitaonrails/ai-memory/blob/main/docs/research-cognee.md) (pretty graph pipeline, ugly gateway bug), [agentmemory](https://github.com/akitaonrails/ai-memory/blob/main/docs/research-agentmemory.md) (I kept the ideas, threw out the substrate), [basic-memory](https://github.com/akitaonrails/ai-memory/blob/main/docs/research-basic-memory.md).
- And my favorite, the [MemPalace](https://github.com/akitaonrails/ai-memory/blob/main/docs/issues-mempalace.md) autopsy: 47k stars, viral, and a tracker clogged with index corruption and lost data. The fairy tale in reverse that confirmed for me why compiling memory beats stockpiling verbatim.

Dozens of documents like that. Every hour of research an agent did for me became a permanent asset, reusable in any new project. The more you produce and document, the more intelligence you accumulate.

> It's compound interest for knowledge.

## Nobody knows what you need

And there the circle closes, back to where we started: why I don't recommend copying anybody's skills, mine included.

Because my PR audit skill is molded around *my* projects, *my* languages, *my* risks, *my* level of supply-chain paranoia. It reflects what I, Fabio, maintaining the repositories I maintain, on the infra I have, with the goals I have, needed to write into it. Your project has another stack, other risks, another tolerance level. You may need checks I don't, and vice versa. Experience is only relevant to whoever lived through its constraints. That changes from person to person, and that's exactly why a third-party skill used blind is a gamble.

That's the thesis of my 2019 video, [Don't Outsource Your Decisions: the most important lesson of your life](/2019/10/09/akitando-63-nao-terceirize-suas-decisoes-a-licao-mais-importante-da-sua-vida/) (in Portuguese): nobody but you knows what you need.

{{< youtube id="D3L8IOncLkg" >}}

I don't ask anybody. I research, I build mine, and the skills are the versioned record of my decisions. The beauty of LLMs is they speed this process up tenfold: the research that took a week now takes an afternoon, and the cost of building your own tool fell through the floor.

A good skill is your own. Mine are on [my-skills](https://github.com/akitaonrails/my-skills) so you can read the reasoning. Then close the tab and write yours. I don't waste time asking for other people's opinions. Neither should you.
