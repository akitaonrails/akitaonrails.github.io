---
title: "ai-memory: long-term memory (Karpathy Wiki) and self-improvement (Hermes) for your projects"
slug: "ai-memory-long-term-memory-karpathy-wiki-self-improvement-hermes-projects"
date: '2026-06-16T10:00:00-03:00'
draft: false
translationKey: ai-memory-long-term-memory-karpathy-wiki-hermes
description: "ai-memory turns agent sessions into a searchable Markdown wiki with hooks, MCP, and handoffs between tools. A Hermes-inspired loop promotes memories with validation, evidence, and optional review."
tags:
- ai-memory
- coding-agents
- llms
---

Yesterday I published a post about how [ai-memory became a living example of emergent architecture](/en/2026/06/14/ai-memory-emergent-architecture-malleable-software/). That one was more about process: how a small tool I built for myself grew, through real contributions, into a multi-user, multi-platform system with support for several agents and a bunch of edge cases that only appear when real people start using it.

Today I want to talk about the other side: **what this is useful for day to day**, and how the project now incorporates an idea inspired by **[Hermes Agent](https://github.com/NousResearch/hermes-agent)**: a self-improvement loop with validation, an audit trail, and an optional manual review mode when you want more control.

If you dropped in cold, the sequence so far is:

1. First I wrote about [agent memory, Karpathy LLM Wiki, and agentmemory](/en/2026/05/18/ai-agent-memory-karpathy-llm-wiki-agentmemory/). Back then I was still evaluating the original [`agentmemory`](https://github.com/rohitg00/agentmemory).
2. Then I published the main post: [I built a memory system for coding agents: ai-memory](/en/2026/05/23/i-built-memory-system-for-coding-agents-ai-memory/). That one explains the foundation of the project.
3. In the [AI toolkit post](/en/2026/05/24/akita-ai-toolkit-ai-jail-ai-memory-ai-usagebar/), I placed ai-memory next to `ai-jail` and `ai-usagebar`: small tools for real pain points when you use agents every day.
4. Yesterday came the [emergent architecture](/en/2026/06/14/ai-memory-emergent-architecture-malleable-software/) post, showing how the project evolved with contributors.

This post is the practical continuation. ai-memory turns long development sessions into a **project wiki** that an agent can query weeks later, without turning you into the human cache for project context.

## The real problem: long sessions become long amnesia

Anyone using [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview), [Codex](https://github.com/openai/codex), [OpenCode](https://opencode.ai/), [Cursor](https://cursor.com/), [Gemini CLI](https://github.com/google-gemini/gemini-cli), or any of these agents knows the cycle. You start a session, explain the project, show the important files, correct a hallucination, find a trap, decide on an architecture, run tests, fail, fix, run again. After two hours, the agent is finally warmed up. It knows what not to do. It knows where the holes are. It knows that one function looks wrong but exists for legacy compatibility. It knows the test only passes if service X is running first.

Then the session ends.

The next day you open another agent, or the same agent in another window, or you switch from Claude Code to Codex because you want to compare. And it starts again. "No, this project uses that." "No, we already tried that." "No, that API does not exist." "No, that file is generated." You become the agent's cache.

A large context window only helps up to a point. It belongs to the current session, not to the whole month of work. And raw context is still raw context. Dumping one hundred thousand tokens of logs into a prompt is different from having a short page that says:

- decision: SQLite is a derived index, markdown is the source of truth;
- trap: on Windows, do not trust inode, use our own index;
- rule: do not edit `content/_index.md` by hand, run the generator;
- procedure: to publish a new post, write PT first, humanize, validate Hugo, translate only after approval.

That is useful memory. Not a transcript. A synthesis.

## The mental model: Karpathy Wiki

The name I like for this pattern is what Karpathy called an **[LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)**: instead of depending on raw history, you maintain a versioned markdown wiki that the agent can query. Small pages, stable names, separated by type of knowledge. The agent does not need to remember everything. It needs to know how to search.

<figure>
  <a href="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/15/ai-memory-hermes/architecture-overview.svg">
    <img src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/15/ai-memory-hermes/architecture-overview.svg" alt="ai-memory architecture diagram: agent clients send hooks and MCP calls to the server, which writes to a markdown wiki and keeps SQLite as a derived index." />
  </a>
  <figcaption>ai-memory architecture overview. The source diagram is in <a href="https://github.com/akitaonrails/ai-memory/blob/main/docs/architecture-overview.svg">docs/architecture-overview.svg</a>.</figcaption>
</figure>

ai-memory implements this with a simple idea: hooks capture what happened, the server organizes that material into a markdown wiki, and agents query that wiki when they need to continue the work.

Some pages are session summaries. Others become decisions, traps, procedures, or project rules. The user does not need to memorize the taxonomy. The point is that knowledge stops being trapped inside the chat window and starts existing as readable files.

Notice that last part: markdown is the source of truth. You can open it in Obsidian, `grep` it, version it, back it up with `rsync`, inspect a git diff. SQLite helps with search, but it is a derived index. If I throw the database away tomorrow, the system can rebuild the index from the wiki.

This is where I get stubborn. I want a file I can read, not a black box of embeddings that "maybe" remembers.

## The base: memory that crosses agents

From early on, ai-memory solved the main pain: **context that survives the agent you happened to be using**.

You could end a Claude Code session, open Codex in the same directory, and the next agent would receive a short summary of where things stopped, which questions were still open, and which next steps made sense.

On top of that, the agent could query the wiki before answering. Instead of depending only on what still fits in the context window, it could search old decisions, known traps, recent pages, and permanent project rules.

In practice, the agent stops guessing about architecture. It can ask: "what did we decide about auth?", "did we already try Redis here?", "what was the Docker trap in this project?" And the answer does not come back as a thousand raw events. It comes back as a wiki page.

In software projects, this matters because the most useful knowledge is usually not "which file exists." The agent can find that with `grep`. The expensive knowledge is **why** something is that way. Why we did not use library X. Why this test is strange. Why the CI config has an exception. Why that refactor was postponed.

That is what long-term memory needs to preserve.

## What came from real use

Yesterday I mentioned some numbers and thanked contributors, but it is worth calling out the newer capabilities because they changed the shape of the project. ai-memory stopped being "my local daemon" and became something you can run on a homelab or shared server.

The short version of the changes is:

- **It works for one person or a team.** The system now understands users, projects, and workspaces. That makes it possible to run it on a homelab or shared server without mixing clients, repositories, and sessions.
- **Scoping became predictable.** A `.ai-memory.toml` file can say which project a directory belongs to. That helps with monorepos, worktrees, consulting, and personal/work separation.
- **More agents can participate.** Beyond Claude Code, Codex, and OpenCode, there is support for Cursor, Gemini CLI, [Antigravity CLI](https://antigravity.google/docs/hooks), [Grok Build CLI](https://x.ai/cli), [OpenClaw](https://docs.openclaw.ai/), [Oh My Pi/OMP](https://github.com/can1357/oh-my-pi), [VS Code GitHub Copilot](https://code.visualstudio.com/docs/copilot/overview), and [Claude Desktop](https://claude.ai/download). Some have full hooks, others can only query through MCP, but all of them can benefit from the same wiki.
- **Administration and recovery became less fragile.** Renaming or moving projects, restoring pages, rebuilding the index, using the web UI, and auditing changes are boring to explain, but important once the tool becomes part of daily work.

I will not go through every detail here. That is what the [GitHub documentation](https://github.com/akitaonrails/ai-memory/tree/main/docs) is for. The important shift is the category change: this stopped being my local daemon and became shareable project memory.

This came from real use. Djalma Júnior, wlech, Pedro de Freitas Jr, Mauro Couto de Paiva, Gustavo Cateim, Lucas Oliveira, Pablo Winter, azevedo-luis, zanlucathiago, and others pushed the project into cases I had not planned for. That is how software grows without becoming PowerPoint architecture: need pulls the architecture, not the other way around.

## Auto-improve: sessions become memory

Today, ai-memory has a safe self-improvement loop: when an LLM provider is configured, a background job can review new sessions, separate noise from real learning, and turn useful lessons into durable wiki pages.

That is what matters for the user: you do not need to remember to open a notes file at the end of the day, or manually write "session learnings." If the session revealed a decision, a reproducible trap, or a procedure worth repeating, the system can promote it into project memory.

Under the hood, it uses the consolidated session, looks for strong signals, asks an LLM to suggest small edits, validates paths, evidence, size, and confidence, records the proposal in an audit trail, and applies the write through the normal wiki path.

If you want human review before the final write, set `[auto_improve] require_approval = true`. Then proposals stay pending until someone reviews, approves, or rejects them.

In the architecture diagram above, this sits on the maintenance side, in the work that depends on an LLM provider. It is not in the hot hook path. That is intentional. Hooks need to capture quickly, return 202 or 429, and get out of the way. LLM review is a different class of work.

The important detail: **this does not enter the agent's hot path**.

The user keeps working normally. Hooks capture the session. The handoff stays short and actionable. auto-improve runs as maintenance: it looks back, identifies what deserves to survive, and turns learning into queryable memory. The feature exists to answer one question:

> "What did this session teach us that is worth turning into permanent memory?"

And the answer becomes reusable knowledge, with proposal trail and evidence, not a loose guess inside the prompt.

That may sound small, but it is the difference between useful memory and an agent polluting your project with confident junk. If you let an LLM write a rule every time something goes wrong, in one week your wiki becomes a graveyard of superstition: "never use tool X," "always run command Y," "library Z is broken." Many of those problems were temporary: wrong PATH, expired token, network down, outdated dependency, a bug fixed five minutes later.

Bad memory is worse than no memory. No memory makes you ask. Bad memory gives you false certainty.

## What Hermes Agent is

The inspiration came from **Hermes Agent**, which treats learning as part of the normal agent cycle. After doing the work, it can look back and ask: "did this create any memory or skill that will help next time?"

What interested me was the separation. The agent does the work first. Then, in the background, it reviews what happened. There is also slower maintenance that looks for stale, duplicated, or low-value knowledge. One loop learns from the session; the other cleans the garden.

That separation avoids the common mistake of creating a magical daemon that changes everything all the time. It sounds powerful, but it becomes impossible to trust. If you want the details, I left them in the [auto-improvement loop documentation](https://github.com/akitaonrails/ai-memory/blob/main/docs/auto-improvement-loop.md).

## How we adapted Hermes to ai-memory

ai-memory does not copy Hermes literally. Hermes works with memories and skills. ai-memory works with wiki pages. So the adaptation is simple: when a session teaches something useful, the system tries to turn that into a small, readable, queryable page.

The LLM suggests, but the product imposes boundaries. The suggestion needs evidence, a valid path, reasonable size, and minimum confidence. That keeps a messy session from contaminating the whole wiki.

The current shape is this:

1. The session ends and becomes `sessions/<id>.md`, as before.
2. A background job reviews eligible completed sessions after the first-run watermark and configured minimum age.
3. The reviewer looks for decisions, traps, procedures, and rules worth keeping.
4. The system validates the suggestion and records an audit trail.
5. By default, the memory enters the wiki; if you want, you can require manual review first.

That trail is the missing piece between "the LLM suggested it" and "this became project truth." Project memory cannot be a black box.

## What should become memory

This part matters more than the tool: not everything that happens in a session deserves to become permanent memory.

What is worth keeping is whatever helps the next agent work better: a decision with future consequences, a reproducible trap, a procedure that will repeat, an explicit user preference, or an important project pattern.

What is not worth keeping is noise: a test command, a transient error, a failure caused by that day's environment, or a whole session narrative that is already preserved under `sessions/`.

That filter is the difference between a wiki that helps and a wiki that gets in the way. auto-improve does not exist to capture more things. It exists to **selectively promote** what deserves to move out of the episodic layer and into durable project memory.

## Hooks, MCP, and prompts: the part that makes it usable

The other half of the system is less glamorous, but it is what makes the thing feel natural. The user works normally. Hooks capture the session cycle. MCP gives the agent a way to query memory. And the instruction block in `CLAUDE.md` or `AGENTS.md` teaches when to use all of it.

When the integration is complete, the experience becomes almost invisible: you close one session, open another tool, and the next agent can orient itself. When a client only supports MCP, it can still query the wiki, even if it cannot capture the full lifecycle.

The important detail is not the specific hook format of each tool. That is in the [installation documentation](https://github.com/akitaonrails/ai-memory/blob/main/docs/install.md). The important part is that ai-memory tries to hide those differences and give the agent a simple behavior: before deciding, consult memory; when it learns something durable, preserve it.

## Why this makes coding sessions smarter

The flow I want is this.

You open OpenCode in an old project. Before answering anything serious, it knows to query ai-memory. It finds an existing database decision. It finds a build trap. It finds a handoff from the last agent saying the test failed in `PaymentImporter`. You do not need to retell the whole soap opera.

During the session, hooks record what happens. At the end, the session becomes a short narrative. If it was a rich session, the auto-improve job can turn the lessons into pages like:

- `gotchas/payment-importer-timezone.md`;
- `decisions/use-ledger-table-for-reconciliation.md`;
- `procedures/run-importer-smoke-test.md`.

In the default mode, this enters as validated, auditable memory. In manual mode, you inspect the diff, approve, or reject. Next week, another agent can query it and avoid stepping into the same hole.

That is the cycle I want: **work becomes knowledge, knowledge improves the next work**. No prompt religion, no infinite context window, no blind trust in opaque memory.

## Be careful with the word "auto"

There is a marketing trap here. "Self-improvement" sounds like science fiction: the agent learns by itself and gets better forever. I do not want to sell that, because it becomes a lie quickly.

What exists today is much more grounded: a job that reviews sessions, suggests memory, validates the suggestion, keeps evidence, and applies through the normal wiki path. If you prefer, there is a manual review mode before the final write. And precisely because it is limited, it is useful. The active prompt and hook latency stay protected. The system observes, filters, validates, and leaves a trail.

That is the right boundary for a system like this right now. Auto-approval only after structural validation and evidence. Human review when the project needs it. Trust is earned with history, not enthusiasm.

## Closing

ai-memory started as a simple answer to a simple frustration: I got tired of re-explaining the same project to different agents. In a few weeks it became a versioned wiki, with hooks, MCP, handoff, multi-user mode, multi-workspace support, marker files, support for several CLIs, web UI, recovery, and now a Hermes-inspired self-improvement loop with validation and audit instead of blind faith in the LLM.

The philosophy is still the same: good memory organizes knowledge into small, readable, versioned, citable pages. It turns a long session into a decision, trap, procedure, or rule. It lets the next agent start where the previous one stopped.

If you use agents for real software projects, this is the bottleneck that starts hurting first: continuity. A better model alone will not fix it.

The repo is here: [github.com/akitaonrails/ai-memory](https://github.com/akitaonrails/ai-memory). If you already use it with an LLM provider configured, update and let auto-improve work in the background on new completed sessions.

If you want manual review before applying, configure:

```toml
[auto_improve]
require_approval = true
```

In manual mode, do not accept everything. That is the point. Read, criticize, approve only what deserves to become memory. In the default mode, follow the audit trail when you want to understand what was promoted and why.
