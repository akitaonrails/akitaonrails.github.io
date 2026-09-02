---
title: "AI-MEMORY 2.0 - The Best Memory System for Agents and Teams"
slug: "ai-memory-2-0-best-memory-system-for-agents-and-teams"
date: '2026-09-02T11:00:00-03:00'
draft: false
translationKey: ai-memory-2-0-melhor-sistema-memoria-agentes-e-times
description: "ai-memory hit version 2.0 with the open OKF format, local embeddings on by default, and support for teams working in parallel. I compare it with the competition and show what only ai-memory delivers."
tags:
- ai-memory
- coding-agents
- open-source
---

**TL;DR:** [ai-memory 2.0 is out](https://github.com/akitaonrails/ai-memory/releases/tag/v2.0.0), with the open OKF format, local embeddings turned on by default, and real support for several agents and a whole team working on the same project in parallel. The full pitch is below.

Back in July I published [What's New in My AI-MEMORY](/en/2026/07/20/whats-new-ai-memory-switch-agents-without-losing-session/), where I showed off `ai-memory run`: switching from Claude Code to Codex without losing your line of work. That day we were on version 1.17.1.

Today **2.0** shipped. And this time I'm not going to rehash how the hooks work or how a session turns into a wiki page. That's already in the earlier posts. Here I want to talk about where ai-memory landed against the competition, what 2.0 brings, and why it earned the jump to a "2".

If you've never heard of the project, the summary is short. ai-memory is a long-term memory server for your coding agents. It captures what happened in the session, consolidates it into Markdown pages, and hands the right context to the next agent, whatever the harness or the machine.

![ai-memory 2.0 web browser showing the wiki's project list, with the pre-migration OKF backup notice and cards for several projects like ai-memory, akitaonrails-hugo, and others](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260902132131_screenshot-2026-09-02_13-20-02.png)

This is the web interface that comes with it, handy for auditing what the agents wrote and for browsing between projects. Notice how each project lives separately, with its own page count, all of it coming out of real sessions.

## Why it became 2.0

For me, the first digit of a version carries a commitment.

The 1.x line grew too fast. We went from 1.1 to 1.39 in a little over two months, stacking feature on top of feature in minor releases. It worked for iterating, but it blurred what the numbers meant.

2.0 fixes that. It bundles the few compatibility-breaking changes into a single major, and from here on versioning follows real [Semantic Versioning](https://github.com/akitaonrails/ai-memory/blob/main/CONTRIBUTING.md). A fix is a patch. A new feature is a minor. Only a format or contract break is a major, and always with warning. The new contributing guide spells that rule out for any PR.

The main break is the new on-disk format. The first time you bring up 2.0, it migrates your wiki on its own. Before touching anything, it compresses your entire data directory into a verified backup with the date in the name. If the backup can't be written and checked, the migration aborts and the server refuses to start. No "trust me".

![ai-memory 2.0 dialog announcing that the memory was migrated to the OKF v0.2 format, showing the verified backup path and the rollback steps](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260902131952_screenshot-2026-09-02_13-16-17.png)

This is the notice that shows up once, right after the migration: it tells you where the backup landed, the file size, and how to roll back if something looks off. Once you confirm everything is fine, you just delete the backup and the reminder disappears.

## OKF: your memory isn't locked inside ai-memory

This is the change that made me happiest.

Starting with 2.0, the ai-memory wiki is, natively, a bundle in the **Open Knowledge Format**, the open format Google published in 2026. Each memory page is a valid OKF file: plain Markdown with standardized metadata. There's no export step that produces a divergent copy. The wiki files already are the OKF files.

In practice that means your memory stopped being a hostage of my project. You can read it all with `grep`, open it in Obsidian, version it in Git, or hand the bundle to a coworker who uses another OKF-compatible tool. There's even an `ai-memory export-okf` to package a whole project into a validated tarball.

That was always the thesis: the model and the harness are rented, the project's memory is yours. Now the format backs that up in writing.

## Local embeddings, on by default

Up through 1.x, real semantic search depended on you configuring an embeddings provider. Either you paid for an API and sent every page and every query out, or you spun up an Ollama on the side. Both options have a cost.

2.0 brings a `local` provider that runs the embeddings model inside the process itself, in pure Rust, with `all-MiniLM-L6-v2`. No API key, no external server, no GPU, and nothing about your data leaving the box. And now it comes on by default. On the first run it downloads the model (about 87 MB, with a fixed checksum) in the background and turns on hybrid search at the next restart.

The gain is measurable. On the LongMemEval-S benchmark, hit@5 goes from 0.617 with full-text only to 0.779 with the local embeddings. If for some reason you don't want it, an `embedding_provider = "none"` turns it off.

A detail that matters: I chose `candle` on purpose, instead of the native runtime the competition uses. That native layer is exactly what caused a recurring kind of crash in other memory projects. I preferred not to inherit the problem.

## Several agents at once, on the same project

Here's where the part that drove most of the work before 2.0 begins.

The `ai-memory run` case I showed in July was sequential: I close Claude, open Codex, keep going. But what about when I leave two or three harnesses open at the same time on the same project? Claude in one tab, Codex in another, OpenCode in a third.

ai-memory handles that without anyone stepping on anyone else. Each memory call figures out on its own which project it belongs to, from the session's directory. The "current project" pointer is now per actor, so two harnesses in the same checkout each keep their own sense of context. And the project's identity comes from the checkout name. The absolute path on disk doesn't count, so the same project on the laptop and on the desktop lands in the same place.

When two windows write to the same page, the second doesn't erase the first. It creates a new version that becomes the latest, and the previous one stays reachable in the version chain. Writing something identical doesn't create a new version. Every write goes through a single writer, with a queue and backpressure, so a burst doesn't corrupt anything.

This isn't theory. There's an acceptance test calling Claude, Codex, OpenCode, Pi, Crush, and a few others for real, inside a single workstream, covering leases, session adoption, and context handoff between harnesses.

## A whole team on the same project

The second scenario is the one that gives the post its title. Here it's several people, a whole team pointing their agents at the same server.

The way to run it is simple. Someone brings up a server, usually a container in a homelab or on a machine on the network, and each person points their agents at that URL. HTTPS goes in front with a reverse proxy, if you want. The database is still a single SQLite.

Everyone sees the same project pages. What one person learned in a session, the other's agent recovers. And each new session gets a briefing with the project's state right at the start. I'll be honest about the term "real time". What exists is a shared central store, with immediate reads, plus the briefing at the open. The note a coworker wrote shows up right away for anyone's next query or next session. A session that's already running only gets the news at the next query or the next open, with no interruption mid-flight.

What changes in multi-user mode is attribution. Each write records who did it. There's an audit log and the interface shows "edited by so-and-so". That comes in the box, for free. And there's no per-page permission, on purpose. Attribution is there to record authorship; anyone authenticated can write, and the history is what keeps track of who did.

There's an important security distinction between what's shared and what's personal. The pages belong to everyone. But the handoff is a baton with a single owner: exactly one session takes it, and a second `accept` doesn't steal the baton from anyone. The handoff you left pending isn't delivered to or consumed by a coworker. Likewise, the "what I'm working on right now" slots are per person, so your personal context doesn't leak into the whole team's briefing.

There's also a battery of real concurrency tests covering these cases: simultaneous writes, per-actor isolation under load, the handoff baton that doesn't get stolen, and the personal slots that don't leak.

## Where ai-memory stands against the competition

Before 2.0 we did another round of research on the 2026 landscape, documented in the repository. It was the basis for deciding what 2.0 needed to cover. Let me summarize the field.

There's **agentmemory**, a TypeScript MCP server tied to a native sidecar and a giant surface of dozens of tools. There's **basic-memory**, in Python, Markdown on disk, but with manual capture: you have to ask it to remember. There's **cognee**, which combines graph, vector, and relational into a heavy pipeline that wants several gigs of RAM. There's **MemPalace**, which went viral with almost 50,000 stars in two weeks over a benchmark number that, once audited, turned out to be inflated, on top of suffering corruption when two writes happen together. And there are the temporal graphs like **Zep**, the "memory OS" like **Letta** (the old MemGPT), and the fact extractors like **Mem0**.

There's also the native memory that Claude Code itself started turning on by default. I treat that one as the funnel that introduces the category to people. As a competitor it stays limited: tied to one machine, tied to one agent, without real search and without team history.

2.0 closes the gaps the research pointed out. We started publishing a reproducible benchmark with LongMemEval, running the actual server. We got the open OKF format. We got typed links between pages, with `causes`, `fixes`, and `contradicts`, which also feed a contradiction check without spending an LLM. We got queries with `as_of`, to ask what we knew about a subject on a given date. We got the local embeddings. And we got an optional "experience" pass that reviews several sessions to find patterns that only show up across the set.

Now the part that matters for whoever's choosing. What ai-memory has that the others don't, all together:

- **It follows you across agents.** More than twenty harnesses feed a single memory, and the handoff here is a real protocol: typed, with an owner, and claimed exactly once.
- **It follows you across machines.** The memory lives on a server that's yours. The project you dropped on the desktop is the one you pick back up on the laptop.
- **It works for a team.** Multi-user authentication, per-person attribution, and an audit log come in the box, for free.
- **Your memory is plain Markdown.** The source of truth is a wiki versioned in Git. The database is a derived index you can rebuild at any moment from the files, with no vector store to babysit and nothing trapped in a binary blob.
- **It captures the work on its own, quietly.** No "remember this" ceremony. And the default path runs with zero LLM calls.
- **It's a single binary.** No sidecar, no three databases to sync. Every write goes through a single writer, with a write ceiling we actually measured, with a real test. That design is exactly what avoided the concurrent-write corruption that took the others down.

No competitor delivers this set. Some have one piece or another. ai-memory has the whole package, and now with parity on the items where it used to fall behind.

## 2.0 belongs to everyone

When I wrote the July post, fifteen people had a merged PR in the project. Today it's around seventy. This stopped being a weekend project a long time ago.

The numbers up to 2.0: more than 1,500 commits, **371 merged pull requests**, and **181 closed issues**. That came from people actually using it and sending fixes, features, and documentation.

I have to give special thanks to [Djalma Júnior](https://github.com/djalmajr), who on his own passed 50 merged PRs, and to [Samir Hanna Verza](https://github.com/samirhvbr), with more than 20. Right behind come [lhzapata](https://github.com/lhzapata), [pedrofjr](https://github.com/pedrofjr), [mrpaiva](https://github.com/mrpaiva), [lucasliet](https://github.com/lucasliet), [lihuiyang1024](https://github.com/lihuiyang1024), [Murillofilho86](https://github.com/Murillofilho86), and [Matheus Rodrigues](https://github.com/matheus-rodrigues00). And there's a long tail of dozens of other people with a merged PR that it would be unfair to try to list in full here.

If you want in on this, the [contributing guide](https://github.com/akitaonrails/ai-memory/blob/main/CONTRIBUTING.md) was rewritten to make everything clear: how to set up the environment, the gates the CI enforces, the CHANGELOG rule, and the versioning policy. A bug fix usually ships fast in the next patch. A small feature, like a new harness or provider, goes into the next minor. There are issues tagged for people just starting out.

## How to get 2.0

The project page has every install method, including AUR, Homebrew, and release binaries:

- [ai-memory on GitHub](https://github.com/akitaonrails/ai-memory)
- [v2.0.0 release notes](https://github.com/akitaonrails/ai-memory/releases/tag/v2.0.0)

After updating, on the first run let the migration take the backup and convert your wiki to the OKF format. If you use the managed mode, reinstall the hooks for the harnesses you plan to use.

## Conclusion

1.x proved the idea worked. 2.0 is the version I'd recommend without an asterisk for someone else to put on a team.

The format is open, so your memory doesn't get locked in. Semantic search runs local, so you don't pay and you don't leak. Several agents and several people work on the same project without running each other over. And the single-binary, single-writer design is what avoids exactly the problems that sank half the competition.

The LLM and the subscription I keep renting from whoever's best that month. The project's memory stays with me, with the team, and now in a format nobody can take away from me.
