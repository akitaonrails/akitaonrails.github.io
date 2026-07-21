---
title: "What's New in My AI-MEMORY: Switch AI Agents Without Losing the Session"
slug: "whats-new-ai-memory-switch-agents-without-losing-session"
date: '2026-07-20T21:00:00-03:00'
draft: false
translationKey: novidades-no-meu-ai-memory-cada-vez-melhor-pra-usar-com-suas-ias
description: "ai-memory run keeps the same programming session while switching among Claude Code, Codex, and other harnesses, with searchable workstreams and integration with ai-jail and ai-usagebar."
tags:
- ai-memory
- coding-agents
- ai-jail
- ai-usagebar
---

It's been a little over a month since I published [ai-memory: long-term memory (Karpathy Wiki) and self-improvement (Hermes) for your projects](/en/2026/06/16/ai-memory-long-term-memory-karpathy-wiki-self-improvement-hermes-projects/). That was June 16. In that post I explained how sessions became Markdown pages, how auto-improve promoted lessons, and why bad memory can be worse than amnesia.

Version 1.1.0 shipped that same day. Today, July 20, we're at **1.17.1**.

Version numbers alone don't mean much, so I counted what actually happened after that post went live: **31 releases, 55 merged pull requests, and 46 closed issues**. I counted **24 groups of new user-facing features** in the [CHANGELOG](https://github.com/akitaonrails/ai-memory/blob/main/CHANGELOG.md), ignoring fixes, documentation, and internal details from the same delivery. If I split the new `ai-memory run` family into auto-selection, session adoption, Crush support, `--yolo`, search, and recovery, we'd blow past that number.

Fifteen people had PRs merged during that period, fourteen besides me. Special thanks go to [Djalma Júnior](https://github.com/djalmajr), who alone had 24 PRs merged, [Matheus Rodrigues](https://github.com/matheus-rodrigues00), with five, [lhzapata](https://github.com/lhzapata), with four, [Thiago Silva](https://github.com/rthiago) and [Cristiano Dewes](https://github.com/cristianodewes), with two each. Nine more contributors had a PR merged. This stopped being "a little program I made over a weekend" a while ago.

I'm not going to dump 55 PRs here. I want to talk about the change that affects my daily use the most: the new **`ai-memory run`**.

## The session is part of the project too

Code is the result that survived. It doesn't preserve the entire investigation.

Git shows that you replaced Redis with SQLite. Maybe the commit explains part of it. But where is the Redis experiment? Where is the intermittent bug that only showed up with two workers? Who remembered that the first solution broke on Windows? Why did the team change its mind after three hours? Which workaround was temporary, and which one became the decision?

Much of that exists only in the agent session.

When I program with Claude Code or Codex, the session accumulates the project's operational reasoning: questions, corrections, discarded attempts, test results, surprises, decisions, and changes in direction. The final code shows what stayed. The session explains how we got there.

And an LLM session, at the end of the day, is text. Claude Code writes JSONL. Codex does too. OpenCode uses SQLite. Pi, OMP, and Crush have their own formats and directories. Each harness packages the conversation differently, but the visible content is still messages and tool results.

Why should I leave the most expensive part of the work trapped inside the harness?

Anthropic can change limits, pricing, models, or formats tomorrow. OpenAI can too. An agent can be excellent this week and unbearable the next. I want to swap the engine without throwing away the whole trip.

That has been ai-memory's thesis from the start: **the programmer must remain independent of provider whims**. Models and harnesses are replaceable. The project memory is mine.

## Handoffs solved only half the problem

ai-memory already handled handoffs. I would close Claude Code, the hooks would consolidate the session, and the next Codex would receive a short summary with what had been done, open questions, and next steps.

That still exists and is still useful. Anyone who opens `claude`, `codex`, or `opencode` directly keeps the previous behavior. The new launcher is opt-in.

But a handoff is deliberately lossy compression. It preserves what seems most important at that moment. It isn't meant to carry the entire session or resume each harness's native session. If the summary left out an old attempt that became relevant again two hours later, you have to search the wiki or the records.

`ai-memory run` adds another layer: a **managed workstream**, one line of work that crosses harnesses.

## Claude now, Codex in a little while

Basic usage looks like this:

```bash
cd ~/Projects/meu-projeto

ai-memory run claude
# work, then exit Claude Code normally

ai-memory run codex --yolo
# Codex continues the same line of work

ai-memory run claude --model opus
# return to Claude's previous native session

ai-memory run
# or let ai-memory choose the right harness to continue
```

You don't need `--` to separate arguments. Everything after the harness name goes to it, with one deliberate exception: `--yolo` belongs to the wrapper and is translated into the native dangerous option for Claude Code, Codex, OpenCode, Pi, or Crush.

Under the hood, ai-memory doesn't try to convert a Codex file into a Claude file. That would be fragile and would probably break on the next update. Each harness keeps its own native session. The workstream connects those sessions to a portable ledger containing the visible part of the conversation.

Think of it this way:

```text
Claude native session ─┐
Codex native session  ─┼─ workstream ─ portable context
OpenCode session      ─┤                 + full search
Pi native session     ─┘
```

The first time Claude enters that workstream, it gets a native session. When you switch to Codex, Codex gets its own native session and receives the portable delta it hasn't seen yet. When you return to Claude, the launcher uses Claude Code's own `--resume` and delivers only what happened in the other harnesses since the last visit.

This is very different from starting a new chat with a summary pasted into the prompt. Claude returns to its real session. Codex returns to its real session. ai-memory handles continuity between the two.

Managed mode currently supports **Claude Code, Codex, OpenCode, Pi, Crush, and OMP**. General ai-memory support is broader, with MCP and hooks for other clients, but that doesn't mean every client already has a native-session adapter for `run`. Those are different contracts, and I prefer to make that explicit.

## What goes into the workstream

When the harness exits, ai-memory reads the tail of the native session without modifying the original store. It imports visible user and assistant messages, completed tool calls with their results, compaction summaries, and a non-mutating Git checkpoint. Every event keeps its origin: Claude, Codex, OpenCode, Pi, Crush, or OMP.

Provider credentials, encrypted records, system and developer prompts, and hidden reasoning stay out. Private formats the adapter doesn't understand stay out too and produce a loss annotation instead of letting the system pretend it imported everything.

Records pass through the sanitizer before entering ai-memory's searchable ledger and immutable JSONL segments. The adapter opens native stores read-only; the harness itself remains the writer.

I don't cram the entire session into the next prompt either. That would recreate the problem the project is trying to solve: too much raw context, too much cost, and too much noise. The next agent gets a size-limited recent delta. If an old decision matters again, the full ledger remains searchable:

```bash
ai-memory workstream-search "por que desistimos do Redis"
ai-memory workstream-search --limit 50 --json "migration que falhou"
```

Inside an `ai-memory run`, the workstream ID is already in the environment. The agent doesn't have to discover some UUID.

And the ledger doesn't replace the wiki. It handles operational continuity. Decisions, rules, procedures, and gotchas that need to survive for months still deserve consolidated Markdown pages. A raw session is evidence. A wiki is organized knowledge.

## Can I keep more than one line of work?

Yes. The default workstream is called `default`, selected by repository and worktree. If I want an independent line for an investigation without contaminating the main work:

```bash
ai-memory run --new investigar-race claude

# later, continue that line with another harness
ai-memory run --workstream investigar-race codex
```

A lease prevents two windows from writing to the same workstream at once. On a normal exit, the launcher imports the tail of the session and releases it immediately. If someone kills the process without cleanup, the lease expires within 90 seconds and the next run resumes from the last confirmed cursor without duplicating imported events.

One stupid annoyance kept coming back: I would reopen a project after a few days and have no idea whether the newest session was in Claude or Codex. I'd guess, open one, realize the context was in the other, close it, and try again.

Now I just run:

```bash
ai-memory run

# or keep the same auto-selection in YOLO mode
ai-memory run --yolo
```

In an empty workstream, ai-memory looks for local sessions from that checkout in Claude Code, Codex, OpenCode, Pi, and Crush, finds the newest one, and opens the right harness for me. In an established workstream, server memory beats the file timestamp: it returns to the last harness attached to that work instead of accidentally adopting an old session that happened to receive a newer write. OMP remains available when selected explicitly, but it doesn't participate in auto-selection yet.

On the first explicit run, the launcher can also offer existing sessions from the same checkout for adoption. You can start using it without abandoning the chat that was already open before you updated ai-memory.

## Other new features I actually use

I promised I wouldn't read the entire changelog out loud, but a few changes from this month deserve a mention because they reduce work for the programmer.

### A briefing before the first question

A project can request an automatic briefing at the start of every session:

```toml
[briefing]
inject_on_session_start = "true"
max_chars = 4000
```

ai-memory assembles a package with pinned pages, `_rules/`, `_slots/`, and recent titles. The agent starts with the project's rules and basic state instead of spending the first conversation rediscovering the architecture. It's opt-in because it consumes context on every SessionStart, including after a Claude `/clear`.

### Global preferences and cross-project search

Preferences that apply to all my work can now live in the reserved `_global` scope: coding style, preferred tools, personal rules, and conventions that don't belong to one specific repository. Normal queries already combine that scope with the current project.

For meta-repos that need to query several sibling projects all the time, there is another opt-in:

```toml
[recall]
default_global = "true"
```

With that, `memory_query` and `memory_recent` without an explicit scope search every project. I don't turn it on in every repo because gratuitous global search only adds noise.

### Less static instruction, more Agent Skills

The routing block in `CLAUDE.md` or `AGENTS.md` got smaller. Detailed instructions for when to search memory, consolidate, save a decision, or create a handoff moved into managed Agent Skills. One command installs or updates both without trampling the rest of the file:

```bash
ai-memory install-instructions
```

That reduces drift too. When the protocol changes, I update the managed package instead of hunting down an old prompt copied across forty repositories.

### Privacy before the network

Each repo can now exclude paths from capture:

```toml
[capture]
ignore_paths = ["private/**", "~/personal-notes/**"]
```

When an integration recognizes a file tool and the path matches, the event is discarded locally before spool, queue, network, or server. The limits are clear: this isn't magic DLP, it doesn't understand every shell command, and it doesn't track content quoted in free-form text. But it handles the verifiable case without selling a fake guarantee.

There are also new integrations with Kimi Code, Grok Build CLI, Devin, and Zero, an OpenCode Zen/Go provider, `finalize-session` for Codex, and workspace-administration improvements. Again: having MCP and a hook doesn't automatically mean having `ai-memory run`. The [README](https://github.com/akitaonrails/ai-memory#support-matrix) separates those levels.

## Bonus: ai-jail on the outside, YOLO on the inside

Just over a week ago I wrote about [how I protect myself from agents deleting my stuff](/en/2026/07/11/how-to-protect-yourself-from-agents-deleting-your-stuff/). My recommendation remains the same: YOLO mode gives the best experience, provided the system limits the possible damage.

[ai-jail](https://github.com/akitaonrails/ai-jail) reached version 1.15.0 and now understands the ai-memory launcher. My favorite way to work has become:

```bash
ai-jail ai-memory run codex --yolo
```

Or, when I want ai-memory to choose which harness should continue:

```bash
ai-jail ai-memory run --yolo
```

Order matters. `ai-jail` stays on the outside so the launcher and child process remain inside the same sandbox. `ai-memory run` by itself manages the session, but it doesn't create a sandbox.

`--yolo` gets rid of the harness's approval ceremony. ai-jail handles containment: the current project is read-write, home is replaced with tmpfs, necessary parts of agent state are mounted selectively, and sensitive directories such as `.ssh`, `.gnupg`, and `.aws` stay outside the jail. The new support also keeps ai-memory's local state writable so hooks can maintain spools and cursors between runs.

ai-jail recognizes both the `ai-memory` layer and the selected harness. If you have Codex-specific global configuration, for example, it still applies when the actual command is `ai-memory run codex`. Even the status-bar redraw adjustment understands that the child is Codex.

This combination takes care of both annoyances at once: the agent stops asking for confirmation on every command, and the session stops belonging to the agent. You get the speed without handing over your entire home directory.

## One more thing: ai-usagebar grew too

When I published the [original ai-usagebar](/en/2026/05/24/i-built-a-waybar-widget-for-omarchy-to-monitor-llm-usage-ai-usagebar/), it monitored Claude, Codex, Z.AI, and OpenRouter in a Waybar widget or TUI. Version 0.14.0 already covers **eleven usage, spending, or balance integrations**.

Kimi got the two pieces of information that really matter for coding: weekly subscription quota and the rolling five-hour window. Kilo, Novita, Moonshot, and Grok show remaining balance. A separate Anthropic Console integration shows API spending for the month without conflating it with the Claude Code subscription. It makes clear that the Cost API doesn't include Priority Tier.

You can also register multiple Anthropic accounts, see weekly limits for specific models such as Fable, and get a pace marker. The bar doesn't turn red just because it reached 40%; it compares the percentage spent with how much of the window has passed. If I used 40% in 20% of the week, I'm moving too fast. That's the useful information.

The project outgrew Waybar. It has a native macOS menu bar app, a GNOME extension, and a standalone TUI. The newest addition is a local Claude Code context monitor: I press `c`, choose one of the recent sessions, and see how much of the window it has consumed. It reads limited tails from local JSONL files and doesn't invent a percentage when it can't determine the window size.

In my workflow, the three end up working together. `ai-usagebar` shows which subscription still has room. `ai-memory run` switches harnesses without throwing away the work. `ai-jail` lets the chosen one run in YOLO without unrestricted access to the machine.

## Updating

The installation pages for all three projects cover every method, including AUR, Homebrew, and release binaries:

- [ai-memory](https://github.com/akitaonrails/ai-memory)
- [ai-jail](https://github.com/akitaonrails/ai-jail)
- [ai-usagebar](https://github.com/akitaonrails/ai-usagebar)

After updating ai-memory, reinstall the hooks for the harnesses you plan to use in managed mode. The three main ones in my case:

```bash
ai-memory install-hooks --agent claude-code --apply
ai-memory install-hooks --agent codex --apply
ai-memory install-hooks --agent opencode --apply
```

Crush doesn't need a hook in managed mode; it receives context through a temporary file configured only for the launched process. The [managed workstreams documentation](https://github.com/akitaonrails/ai-memory/blob/main/docs/managed-workstreams.md) covers installation, privacy, recovery, and native arguments for each adapter.

## Conclusion

A month ago, ai-memory could already turn a session into a wiki and hand off to the next agent. Now it can manage the line of work itself: adopt an existing session, keep one native session per harness, carry visible history, resume each client in its own format, and keep the entire ledger searchable.

For me, that's the value. The code contains the implementation that won. The session contains the decisions, failed experiments, gotchas, unexpected bugs, and changes of mind that produced that implementation. Throwing all of it away every time you change providers is wasteful.

A raw transcript doesn't solve the problem by itself either. It's large, repetitive, and expensive to stuff into every context. ai-memory keeps the evidence, delivers only the recent delta, and uses consolidation to turn what deserves to survive into short Markdown pages.

There are still new formats to support, platform rough edges, and plenty of testing ahead. The difference is that there is now a real foundation, with an acceptance test that calls actual harnesses, 14 outside contributors with merged PRs in a little over a month, and daily use pushing the design forward.

I rent LLMs and subscriptions from whoever is delivering the best service today. My project's session stays with me.
