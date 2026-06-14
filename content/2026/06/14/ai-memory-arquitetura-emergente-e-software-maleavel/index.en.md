---
title: "ai-memory: Emergent Architecture and Malleable Software"
slug: "ai-memory-emergent-architecture-malleable-software"
date: '2026-06-14T14:00:00-03:00'
draft: false
translationKey: ai-memory-emergent-architecture-malleable-software
tags:
  - ai-memory
  - rust
  - opensource
  - architecture
  - agile
  - ai
  - vibecoding
---

About three weeks ago I published the [post explaining ai-memory](/en/2026/05/23/i-built-memory-system-for-coding-agents-ai-memory/), my long-term memory system for coding agents. The core idea, for anyone who missed it: give Claude Code, Codex, OpenCode and the rest a shared brain that persists across sessions, a git-versioned wiki with FTS search, cross-agent handoff, and optional LLM consolidation. Every project isolated, running locally or self-hosted, without shipping your context to anybody's cloud.

So here's the thing. In three weeks this little project grew in a way that deserves a post about the **process** alone, because it became a living example of something I've been preaching for years: real software is grown, like a plant. Nobody builds good software piece by piece the way you snap a Lego together. Let me show you the numbers, and mostly the story they tell.

## The numbers, today

ai-memory has, in 24 days of life (from the first commit on May 21 until now):

- **482 commits** on `main`, averaging 20 a day.
- **26 people** committed to the repo.
- **10 Rust crates** in the workspace.
- **~62.7k lines** of production Rust, plus **~11k lines** of tests in `tests/`, more than **1,000 test functions**, and 90 `#[cfg(test)]` modules scattered through the code.
- **~19.7k lines** of markdown documentation (`docs/`).
- **70 pull requests**, of which **59 merged** (84% acceptance).
- **27 issues**, **100% closed**.
- We cut `v1.0.0` on June 12 and we're already on `v1.0.6`.

Twenty-four days. Hold onto that number, because the interesting part isn't the final size, it's the way it got here.

## How it started: one of everything

ai-memory was born small and dumb on purpose. In the first two days I nailed down the whole skeleton: workspace bootstrap, MCP server, hook capture, cross-agent handoff, git wiki versioning, an LLM provider trait, embeddings. All of it running for **one user, one machine, one workspace, one architecture** (Linux, basically). No multi-user, no permissions, no scopes, no Windows or macOS support. It was my agent brain, on my machine, for me.

On day 3, when the [first external contribution landed](https://github.com/akitaonrails/ai-memory) (a fix from Lucas Oliveira for OpenAI-compatible provider URLs, PR #6), the project had **102 commits and around 22.9k lines** of source. Already the same 10 crates as today, but with a fraction of the functionality. It was a one-of-everything MVP that worked for me and nobody else.

And this is where most projects die, or worse, where most inexperienced programmers get it wrong.

## The Lego fallacy

There's a widespread belief, especially among people starting out, that you can design everything a piece of software **will be** before writing the first line. You sit down, plan the entire architecture, break it into neat little pieces with all the folders and layers and interfaces mapped out, and then build it piece by piece. When the last Lego brick clicks in, the software is done. Beautiful on paper.

In practice, it's the fastest road to rotting code. The sooner you crystallize a structure, the sooner it becomes a straitjacket. You predicted an elaborate permission system before having any users? Congrats, now you carry the weight of maintaining an abstraction nobody uses, and that's almost always wrong, because you designed it guessing the future instead of answering a real need. The inexperienced programmer over-engineers at the start, and no matter how much they plan, the result starts to rot fast, because they're solving problems that don't exist yet and getting wrong the ones that do.

I don't believe in software that finishes. I already wrote about this in ["Software Is Never Done"](/en/2026/03/01/software-is-never-done-4-projects-life-after-deploy-one-shot-prompt-myth/), and it connects straight to the original Agile methodologies, the real ones, before they turned into a corporate post-it ritual. Good software is a clay sculpture: malleable, always wet, that you keep adjusting and reshaping, and that never gets finished. It's clay you mold while it's being used. The Lego tower that one day clicks into place and is done is a fantasy.

## What the contributors built

And this is where the best part of open-sourcing it comes in. That one-of-everything MVP became a cross-platform, multi-user system because **a lot of people** put their hands on it. I want to thank them by name, because without these people the project would be a fraction of what it is:

[**Djalma Júnior**](https://github.com/djalmajr) drove a big chunk of the heavy architecture (multi-user, admin, cross-project recall), with 25 merged PRs. [**wlech**](https://github.com/wblech) with dozens of commits. [**Pedro de Freitas Jr**](https://github.com/pedrofjr) on embeddings and web fixes. [**Mauro Couto de Paiva**](https://github.com/mrpaiva) and [**Gustavo Cateim**](https://github.com/CaTeIM) drove a big part of the Windows support. [**Pablo Winter**](https://github.com/pablowinck), [**Lucas Oliveira**](https://github.com/lucasliet) (author of the first external PR), and **Said Rodrigues**, among many others. Thank you so much, folks.

What those contributions added, the highlights:

- **Real Windows, macOS, and Linux support.** What was Linux-only got macOS bash 3.2 compatibility, an NTFS file index for tracking inodes on Windows, and native per-platform hook commands.
- **Frontend API (`/api/v1`) and a customizable web UI.** It stopped being only MCP + CLI and got a real HTTP surface, with clickable wiki links and search by file path.
- **Multi-user with attribution.** A `users` table, writer/reader commands, and write attribution in the same SQL transaction as the data (`pages.author_id` + frontmatter).
- **Multi-workspace and cross-project recall.** Global search, links between wikis of different projects, and active-project isolation per session and per actor.
- **More providers and more agents.** Gemini, Copilot via OAuth, OpenAI-compat strict mode; plus support for Antigravity, Grok, and VS Code Copilot on top of the originals.
- **Operational robustness.** Checkpoint recovery, `reindex-from-wiki` to rebuild the index from the markdown, self-describing `_meta.md` manifests.

Notice something: none of this was in the original plan. There was no original plan. Each of these features landed because someone needed it, opened an issue or a PR, and the structure gave way to make room. Multi-user wasn't predicted: it emerged.

## And only now did we stop to consolidate

Here's the central point of the post. Over these three weeks, the code grew a little messy on purpose. When multi-user support came in, the logic for "which workspace and project is this request aiming at" ended up **embedded right in the middle** of several handlers in the MCP server, the web API, the admin, scattered and duplicated. Each spot resolved scope its own way. There was duplication. There was code that wasn't pretty. And that's fine, because it was working, and working for a lot of people.

Only **after** the software was already running on dozens of people's machines, across three operating systems, with real multi-user in production, did I stop and say: "okay, now is a good time to refactor and rethink the internal wiring." The second-to-last big commit, [`refactor: centralize scope auth and wiki consistency`](https://github.com/akitaonrails/ai-memory), did exactly that, with 1,239 lines added and 249 removed, creating a central 601-line `ScopeResolver` and a consolidated `ActorContext`.

Look at the "before." This scope-resolution snippet lived duplicated, with variations, across several methods:

```rust
// BEFORE: scope logic embedded, repeated in every handler
let active = self.active_project.get_for(actor);
if let Some(name) = explicit_project.map(str::trim).filter(|s| !s.is_empty()) {
    if let Some((active_ws, _)) = active
        && let Ok(Some(pid)) = self.reader.find_project(active_ws, name.to_string()).await
    {
        return Ok((active_ws, pid));
    }
    if active.map(|(ws, _)| ws) != Some(self.workspace_id)
        && let Ok(Some(pid)) = self
            .reader
            .find_project(self.workspace_id, name.to_string())
            .await
    {
        return Ok((self.workspace_id, pid));
    }
    return Err(McpError::internal_error(
        format!("project '{name}' not found in the active or default workspace"),
        None,
    ));
}
Ok(active.unwrap_or((self.workspace_id, self.project_id)))
```

And the "after." The same resolution, now delegated to a single authority in the store crate:

```rust
// AFTER: one central resolver, one call
fn scope_resolver(&self) -> ScopeResolver<'_> {
    ScopeResolver::new(&self.reader, self.workspace_id, self.project_id)
        .with_writer(&self.writer)
        .with_active_project(&self.active_project)
}

// ... and each handler becomes this:
self.scope_resolver()
    .resolve_current_or_project(explicit_project, actor)
    .await
    .map(ai_memory_store::ResolvedScope::as_tuple)
    .map_err(Self::scope_error)
```

Three different methods that each used to carry 30 lines of embedded logic, with `lookup_ids`, workspace fallback, and their own error handling, collapsed into one call each. Alongside came the sibling commits: `harden multi-user admin auth boundaries` and `prevent scoped fallback bleed`. Centralizing permissions, workspace and user scope, and wiki consistency, all in one place, with a clear rule.

The detail that matters: `ScopeResolver` wasn't invented at the start of the project by guessing there'd be multi-user one day. It was **extracted** from code that already existed, already worked, and had already shown, in practice, which patterns kept repeating. The abstraction came after the usage, not before. I let the structure emerge from the code, and only once it was obvious did I consolidate it.

## The right order: make it work, make it right, make it fast

This is the summary of everything. There's an old saying, attributed to Kent Beck, that I carry like a mantra: **"make it work, make it right, make it fast."** Make it work, then make it right, then make it fast. In that order. Most inexperienced programmers want to make it "right" and "fast" before making it "work," and so they invent rules with no code to justify the rule.

ai-memory followed the right order without me even thinking much about it. First I made it work for one person, simple scope. Then I made it work one feature at a time, refactoring and hardening the code along the way, but never falling into over-engineering and never rewriting from scratch to fit a preconceived structure. I let the current structures emerge from the code that was being added. That meant living with some duplication and some so-so code for a while, until that moment hit of "okay, now it's time to refactor and rethink the wiring." And only now, with the software mature and in use, did I establish better patterns and rules for new code. Rules backed by real code, not by guesswork.

KISS, "keep it simple," is about not solving a problem you don't have yet. It has nothing to do with writing little code. It's about letting architecture emerge from the code, not the other way around. You don't design the sculpture and pour the clay into the mold. You take the clay, start shaping, and the form appears as your hands work. The mold, if you ever need one, you build later, around the form that already exists.

Twenty-four days, 482 commits, 26 people, and none of them followed a diagram drawn on day 1. Because there was no diagram on day 1. And that's exactly why it worked.

ai-memory is open source and keeps changing every week: [github.com/akitaonrails/ai-memory](https://github.com/akitaonrails/ai-memory). Want to help shape the next piece? There's an open issue waiting.
