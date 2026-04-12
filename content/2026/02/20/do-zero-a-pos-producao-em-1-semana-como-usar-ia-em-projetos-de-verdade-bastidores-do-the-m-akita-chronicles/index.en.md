---
title: "From Zero to Post-Production in 1 Week - How to Use AI on Real Projects | Behind The M.Akita Chronicles"
slug: "zero-to-post-production-in-1-week-using-ai-on-real-projects-behind-the-m-akita-chronicles"
date: 2026-02-20T12:49:58+00:00
draft: false
tags:
- themakitachronicles
- rubyonrails
- xp
- extremeprogramming
- agile
- frankmd
  - AI
translationKey: zero-to-post-production-1-week
description: "How 274 commits in 8 days shipped a full newsletter, podcast, blog, and Discord bot to production using Extreme Programming with Claude Code as the pair."
---

This post is part of a series; follow along via the tag [/themakitachronicles](/en/tags/themakitachronicles/). This is part 9 and the Finale!

And make sure you subscribe to my new newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

274 commits. 8 days. 4 applications. 1,323 tests. A complete system in production — with real subscribers receiving a newsletter every Monday at 7am, an AI-generated podcast on Spotify, a static blog on Netlify, and a Discord bot that's my operational interface.

I did this with a partner: Claude Code, an AI agent running in the terminal. And the most important lesson I took away is not that "AI programs by itself" — **AI programming by itself is a recipe for disaster**. What works is something that already has a name and decades of history: Extreme Programming. Except now the pair in pair programming isn't human.

> I need all of you to go through an experience: a **1-WEEK IMMERSION** completely **DETACHED** from the code, using AI as pair programming, going from zero to production on any small project. Trust me, until you do it at least once, you won't get it. But after that, everything changes.

![pair programming](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/pair-programming.jpg)

## The "One-Shot Prompt" Myth

There's a growing narrative that "vibe coding" means writing a detailed spec, handing it to the AI agent, and it delivers the system ready. Like those "I built a SaaS in 10 minutes with Cursor" videos. It looks magical until you look at what was actually delivered: a prototype with no tests, no security, no error handling, no deploy, nothing that makes a system survive contact with real users.

The reality of my 274 commits tells a different story:

| Category | Commits | % |
|-----------|---------|---|
| New features (`Add ...`) | 101 | 37% |
| Bug fixes (`Fix ...`) | 45 | 16% |
| Refactoring/hardening (`Harden`, `Extract`, `DRY`, `Rework`, `Replace`) | 27 | 10% |
| Security | 21 | 8% |
| Deploy/infra | 30 | 11% |
| Tests/CI | 44 | 16% |
| Documentation | 27 | 10% |

**Only 37% of the commits are features.** The rest is the work that makes real software: fixing bugs, hardening against failures, protecting against attacks, deploying, testing, documenting. Anyone showing only the features part is selling an illusion.

More than that: many of the features emerged **because** iteration revealed they were needed. `ContentPreflight` wasn't in the original plan — it was born when the second newsletter went out with an empty section because a job failed silently. `RecoverStaleDeliveriesJob` was born when I realized a crash in the middle of sending left emails in eternal limbo. `StealthBrowser` was born when Morningstar blocked HTTParty. No spec in the world predicts this. **The correct system emerges from iteration, not from specification.**

## Pair Programming With an AI Agent

I don't use Claude Code as a code generator. I use it as a pair programming partner.

The difference is fundamental. A code generator takes a spec and returns output. A pair programming partner **talks**. I interrupt when it takes the wrong path. I give it context it doesn't have. I question decisions. I ask for alternatives. Sometimes I say "stop, this is getting too complicated" and it simplifies.

Some real examples from the 274 commits:

**Interruption for over-engineering.** When I asked for the email delivery system, the first proposal had a state machine with 8 states, separate retry queues, and dead letter handling. I interrupted: "Simplify. Four states: pending, sending, sent, unknown. When in doubt, don't resend." The result was `SendSingleEmailJob` with the `ses_accepted` variable as the pivot — 40 lines that solve the whole problem.

**Context the agent doesn't have.** When we were on Yahoo Finance, Claude tried to use HTTParty. I explained: "Yahoo does TLS fingerprinting, it'll block any HTTP client that isn't a real browser." Result: headless Chromium with crumb authentication. That's in no tutorial — it's the kind of knowledge that comes from trying and failing.

**Joint architecture decision.** The podcast pipeline could have been a Python monolith. I suggested: "Rails orchestrates, Python serves TTS over HTTP, content integrates by filesystem." The result — `QwenTtsClient` in Ruby calling `podcast-tts` in Python — keeps each language doing what it does best.

**Iterative prompt refinement.** The first newsletters came out generic. The Akita and Marvin comments sounded the same. I tuned prompts with it: "Akita never says 'maybe'. Marvin uses 'well...' and 'anyway'. The LLM will soften opinions if you're not explicit." Each tweak was a prompt commit, tested with real data.

The pattern is: I bring the **what** and the **why**. The agent brings the **how** — and the how is often better than I'd do alone. But how without what produces correct code that solves the wrong problem. And what without how produces specs that never leave paper.

## Extreme Programming Isn't a 2000s Fad

![agile lifecycle development process diagram](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/agile-lifecycle-development-process-diagram-vector-31188796.jpg)

Everything we did has a name in XP. Not because I planned it — because these are the practices that naturally emerge when you program with fast feedback:

### Pair Programming

Already explained. The pair is the agent. The dynamic is the same: one drives, the other navigates. I navigate more than drive — I define direction, question decisions, correct course. The agent drives more than navigates — writes code, runs tests, proposes solutions. When it inverts (me dictating exact code, it just typing), the result always gets worse.

### Small Releases

Out of 274 commits, **every single one passes CI**. No exceptions. There's no "broken commit that'll be fixed in the next one". Every commit on master is production-ready.

CI runs on every commit: RuboCop (style) → bundler-audit (gem vulnerabilities) → Brakeman (static security) → full tests. It's ~22 seconds. Sounds like nothing, but multiplied by 274 commits that's 100+ minutes of automated validation I didn't have to do manually.

The distribution of commits by day shows the rhythm:

| Date | Commits | Highlight |
|------|---------|----------|
| Feb 10 (Mon) | 4 | Initial scaffold, Discord bot, blog |
| Feb 11 (Tue) | 41 | Feature explosion: 7 newsletter sections, themes, X polling |
| Feb 12 (Wed) | 49 | Podcast pipeline, deploy, security, real market data |
| Feb 13 (Thu) | 29 | Daily digest, resilient scraping, hardening |
| Feb 14 (Fri) | 30 | End-to-end integration, email hardening, blog deploy |
| Feb 15 (Sat) | 40 | Podcast fine-tuning, cross-app, story management |
| Feb 16 (Sun) | 26 | First real newsletter sent to subscribers |
| Feb 17 (Mon) | 31 | Refactoring, Application Commands, anime fix |
| Feb 18 (Tue) | 24 | DRY shortcodes, backup job, consolidation |

The day-2 "explosion" isn't chaos — it's small releases stacked up. Each one adds a feature, runs CI, is ready to deploy. It isn't a 2-week waterfall followed by a big-bang merge. It's real continuous integration.

### Test-Driven Development

1,323 tests. 970 in marvin-bot (6 seconds in parallel), 353 in newsletter (1 second in parallel). Ratio:

| App | Code (lines) | Tests (lines) | Test/code ratio |
|-----|----------------|-----------------|-------------------|
| marvin-bot | 9,348 | 13,929 | 1.49x |
| newsletter | 3,397 | 5,391 | 1.59x |
| **Total** | **12,745** | **19,320** | **1.52x** |

**More lines of test than of code.** In both applications. And this isn't vanity — it's the infrastructure that enables speed.

Coverage from SimpleCov:

| App | Line Coverage | Branch Coverage |
|-----|--------------|-----------------|
| marvin-bot | 82.4% | 73.1% |
| newsletter | 86.8% | 70.5% |

It's not 100% — and never will be. The 17-18% uncovered is mostly integration with external APIs (Discord, SES, OpenRouter) that are mocked in tests. Real coverage on business logic is above 95%.

The question that matters: **are these tests useful?** The empirical proof: over 274 commits, I saw CI fail and catch a real bug more than 50 times. Without those tests, every one of those bugs would have gone to production. The agent proposes a change, the test catches the regression, the change is fixed before committing. Without tests, the agent hands you plausible code that silently breaks something that worked yesterday.

TDD with an AI agent is multiplicative. The agent is good at generating tests — it knows the patterns, knows the common edge cases, knows the Minitest structure. And the tests it generates become the safety net for the changes it makes later. It's a virtuous cycle: **tests enable speed, speed generates more tests**.

### Continuous Refactoring

27 explicit refactoring commits. Some examples:

- **`Extract StealthBrowser wrapper`** — The headless browser code with stealth patches was duplicated in 4 clients. Extracted into a service, the 4 clients were left with 5 lines each.
- **`DRY section rendering: collapse 5 bubble methods + 7 Hugo shortcodes`** — 5 bubble rendering methods in `MarkdownToHtml` that were copy-paste with different colors, collapsed into 1 parameterized method. 7 Hugo shortcodes delegating to 1 partial.
- **`Replace market recap LLM generation with Yahoo Finance real data`** — The LLM invented market numbers. Replaced with real data from Yahoo Finance + LLM commentary. Better result, lower cost.
- **`Replace DuckDuckGo with Brave Search API`** — DuckDuckGo doesn't have a stable API. Brave Search has an official API with 2,000 queries/month free. Clean swap.
- **`Rework ArticleFetcher: browser-first with anti-detection`** — Two full rewrites. The first tried HTTP-first with fallback to browser. The second inverted: browser-first because most reader links are SPAs. Each rewrite kept tests passing.

Refactoring is where the pair programming partner shines. I say "this code is duplicated, extract a concern" and the agent does in 2 minutes what would take me 20. But **I** decide what to extract and **how** the interface should look. The agent alone doesn't refactor — it piles new code on top of existing code.

### Continuous Integration

The CI already described above: rubocop + bundler-audit + brakeman + tests. Runs on every commit, in both apps. Brakeman deserves a mention:

| App | Controllers | Models | Warnings | Ignored |
|-----|------------|--------|----------|---------|
| marvin-bot | 6 | 8 | 0 | 0 |
| newsletter | 10 | 5 | 0 | 2 |

Zero security warnings in both. The 2 ignored in newsletter are documented false positives (SQL interpolation with config paths, not user input).

Brakeman caught real problems during development: SQL injection in a search query, path traversal in the images controller, open redirect in unsubscribe. Each one fixed before going to production, in the same commit where CI flagged it.

## The Anatomy of a Feature: From Request to Deploy

Let me take a concrete example to illustrate how the flow works in practice. `List-Unsubscribe` (commit `5950ccc`).

**Context**: confirmation emails weren't reaching Gmail. Everything green — DKIM, SPF, DMARC, SES accepting. But Gmail was silently dropping them into spam.

**Investigation** (me + agent): we researched. Since February 2024, Gmail requires `List-Unsubscribe` + `List-Unsubscribe-Post` on every bulk sender email. Without them, it penalizes the **entire domain** — including transactional emails.

**Implementation** (agent executes, I validate): header in `SesMailer`, RFC 8058 endpoint in `UnsubscriptionsController` (skip CSRF for email clients, returns 200 instead of redirect), tests covering both flows.

**CI**: rubocop OK, brakeman flagged the `skip_forgery_protection` as a warning (correct — we validated it's conditional). Tests pass.

**Deploy**: `kamal deploy`. In 2 minutes, the fix is in production. Domain reputation takes 1-2 days to recover. The next day, confirmation emails start arriving again.

**Total time**: ~25 minutes from "why is Gmail rejecting this?" to production deploy. Without the agent, it would be hours of RFC reading, manual implementation, and hoping I didn't forget anything.

## What AI Does Well (And What It Does Badly)

After 274 commits with an AI agent, I have a pretty clear sense of the strengths and weaknesses:

### Does well:

- **Boilerplate and scaffolding**: jobs, services, tests, migrations — the agent produces at typing speed
- **Tests**: surprisingly good at identifying edge cases and generating comprehensive tests
- **Mechanical refactoring**: renaming, extracting methods, moving code between files — fast and precise
- **Contextual research**: "how does RFC 8058 work?" produces an actionable answer in seconds
- **Consistency**: follows patterns established in the project (concerns, naming conventions, test structure) without forgetting

### Does badly:

- **Architecture decisions**: tends to over-engineer. Needs constant human braking
- **Specific domain knowledge**: doesn't know that Yahoo does TLS fingerprinting or that Qwen's VoiceDesign produces a European accent
- **Opinions**: softens everything. Personality prompts become generic mush without explicit instructions
- **Proactive security**: implements what you ask for, but rarely suggests protections you didn't ask for (SSRF, rate limiting, encryption at rest)
- **Prioritization**: executes anything with equal enthusiasm. Never says "this is a waste of time" or "do X before Y"

AI doesn't program by itself, and it isn't useless. **It's a programmer multiplier, not a substitute**. A mediocre programmer with AI produces mediocre code faster. An experienced programmer with AI produces good code at a speed that was previously only possible with a team.

## The Numbers That Matter

Let's look at the real size of what was built in 8 days:

### Code

| Component | Lines |
|------------|--------|
| marvin-bot app (Ruby) | 9,348 |
| marvin-bot tests (Ruby) | 13,929 |
| newsletter app (Ruby) | 3,397 |
| newsletter tests (Ruby) | 5,391 |
| podcast-tts (Python) | 1,770 |
| Hugo templates (HTML) | 193 |
| Blog CSS | 261 |
| AI prompts (Markdown) | 795 |
| CLAUDE.md (project guide) | 702 |

**Total functional code: ~16,000 lines. Total with tests: ~36,000 lines.**

### Components

- **43 services** in marvin-bot (scrapers, AI, parsers, validators, uploaders)
- **38 jobs** in marvin-bot (content generation, daily digest, podcast, infrastructure)
- **12 services** in newsletter (email delivery, publishing, assembly)
- **11 jobs** in newsletter (sending, recovery, backup, blog publishing)
- **23 AI prompt templates** (personality, generation, podcast, tools)
- **17 Hugo shortcodes** (section rendering on the blog)
- **3 RubyLLM tools** (image generation, web search, web fetch)

### Pipeline

- **10 content sections** generated per week (anime, hacker news, youtube, market, world events, history x3, holidays, closing remarks)
- **10 daily digest jobs** posting to Discord at 8am
- **1 podcast** of ~30 minutes generated per week (script + TTS + assembly + S3)
- **1 newsletter** assembled, published to the blog, and sent by email every Monday

## Is This 200 User Stories?

![sprint planning](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/66d7f28718285e260f53fe6e_018b4d67589e6f4d2fdf9130502016fb4a75e73a-1200x674.jpg)

I looked at the 274 commits and tried to map them to user stories in the agile sense. Not every commit is a story — many are fixes inside the same feature, prompt tweaks, or CI cleanup. But the conservative count of distinct features, each one with implicit acceptance criteria (works, has tests, passes CI, deploys):

> **Estimate: ~180-200 user stories.**

That includes:
- Each newsletter section (10 distinct generators with scraping, AI, validation, fallback)
- The email pipeline (delivery tracking, atomic claiming, recovery, List-Unsubscribe)
- The podcast pipeline (LLM script, dual-model TTS, assembly, S3, RSS)
- The Discord bot (15+ commands, embeds, context, multi-turn /ask, daily digest)
- The blog (Hugo + Hextra, 17 shortcodes, RSS podcast, SEO, GA)
- The subscription page (confirmation, themes, LGPD, terms of service)
- Infrastructure (Kamal deploy, Cloudflare, SES config, RunPod, backups)
- 21 security commits (SSRF, CSP, rate limiting, encryption, path traversal)

In traditional Scrum with a team of 2-3 devs, a well-done story (with code review, QA, deploy) takes on average 1-2 days. 200 stories × 1.5 days / 2 devs = **~150 days of work, or ~30 weeks in 2-week sprints** (counting planning, review, retro, and the inevitable overhead of people coordinating with each other).

Being generous — senior team, well-defined stories, no impediments — maybe 10-15 weeks.

> We did it in 8 days. One person and one AI agent.

But — and this is crucial — **I'm not just any dev and this isn't just any project**. I have 30 years of software experience. I know which decisions matter and which don't. I know when to stop engineering and ship. I know when the agent is wrong before it finishes generating the code. And the project is solo-developer, without external code review, without separate QA, without coordination between teams.

The agent's real multiplier isn't "10x more code". It's **eliminating dead time**. Without an agent, 70% of my time would be typing boilerplate, reading API docs, writing mechanical tests, debugging typos. With an agent, that time goes to zero and I focus 100% on architecture, domain, and quality decisions.

## The CLAUDE.md: The Spec That Evolves

One thing that works exceptionally well with AI agents is having a living document that describes the project. The project's `CLAUDE.md` has 702 lines and covers:

- Architecture overview
- Full tech stack
- All environment variables
- Content directory structure
- Services, jobs, and models of each app
- 12 "common hurdles" with documented solutions
- 14 project design patterns
- Full weekly pipeline with schedules
- Post-implementation checklist

This document wasn't written all at once. It **evolved with the project**. Every time we found a hurdle (Yahoo Finance needs Chromium, HN RSS changes format, LLM softens opinions), we documented it in CLAUDE.md. In the next session, the agent already knows.

It's the equivalent of a team's onboarding doc — except the "new team member" is the agent, and it reads the whole doc in 2 seconds before every interaction. Investing in documentation pays back exponentially with AI agents because **they actually read it**.

![claude.md](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_12-59-38.jpg)

## The Lessons

**1. Vibe coding without discipline is a throwaway prototype.** 274 commits with CI, tests, security scanning, and small releases is the opposite of vibe coding. It's software engineering with a copilot that types fast.

**2. TDD is more important with AI, not less.** The agent modifies code with confidence because it has 1,323 tests as a safety net. Without tests, every change is a gamble.

**3. The human decides the what. The agent decides the how.** Flip it and the result drops dramatically.

**4. Continuous refactoring is mandatory.** The agent piles code. If you don't prune regularly — extract concerns, DRY duplications, simplify interfaces — the codebase becomes a monolith of 500 lines per file.

**5. Documentation is an investment with immediate return.** Every hour documenting in CLAUDE.md saves hours of lost context in future sessions.

**6. Small releases are the key.** Every commit is production-ready. If something goes wrong, revert one commit. If the feature was a bad idea, it never depended on another. This only works with automated CI.

**7. Security isn't a phase — it's a habit.** 21 security commits spread across 8 days, not concentrated in a "security sprint" at the end. Brakeman runs on every commit. Vulnerabilities are fixed the moment they appear.

**8. The agent never says "no".** That's a bug, not a feature. If you ask for something over-engineered, it implements with enthusiasm. If you ask for something insecure, it implements without complaining. **You** are the brake. **You** are the code review. **You** are the adult in the room.

## The Counter-Example: FrankMD

Everything I described above may sound theoretical. *"Of course TDD and continuous refactoring are important"* — everyone agrees in theory. So let me prove it empirically with a counter-example from **the same developer, with the same AI agent, two weeks earlier**.

Before the M.Akita Chronicles, I built [FrankMD](https://github.com/akitaonrails/FrankMD) — a Markdown editor in Rails, Obsidian/VSCode style. 212 commits in 19 days. Same setup: me + Claude Code as a pair programming partner.

![frankmd](https://camo.githubusercontent.com/4d7ffcd26d22eb57334017e3b946a10eeb59cacf609edcc8caebf68d03d528b4/68747470733a2f2f6e65772d75706c6f6164732d616b6974616f6e7261696c732e73332e75732d656173742d322e616d617a6f6e6177732e636f6d2f6672616e6b6d642f323032362f30322f73637265656e73686f742d323032362d30322d30315f31342d31332d32392e6a7067)

The difference: on FrankMD, I did what any developer does when "it's just a little personal project". I focused on features. Tests? Later. Refactoring? When necessary. CI? Runs when I remember.

### The `app_controller.js` Spiral

FrankMD is a SPA-like with Stimulus. In the beginning, all the JavaScript lived in a single file: `app_controller.js`. Here's what happened to it across commits:

| Moment | LOC | What happened |
|---------|-----|-----------------|
| Commit #1 (initial) | 506 | Clean scaffold, basic editor |
| Commit #44 (~10 features later) | ~4,372 | File finder, themes, typewriter, image picker, emoji... |
| Commit #54 (peak) | **4,990** | Everything inside. AI grammar, video embed, content search... |
| **Refactor 1**: Extract utilities + image picker | 3,249 | -35%, 6 modules + 1 controller extracted |
| **Refactor 2**: Extract 10 Stimulus controllers | 1,803 | -45%, 10 controllers with tests |
| Features grow again... | 2,739 | More code piled on |
| **Refactor 3**: Extract utility modules | 2,684 | -2%, small |
| **Refactor 4**: Extract domain controllers | 2,074 | -23%, 4 new controllers |
| Features grow... | 2,367 | Growing again |
| **Refactor 5**: Extract autosave/scroll-sync | 1,837 | -22% |
| **Refactor 6**: Replace custom JS with Rails 8 built-ins | 1,511 | -17%, -383 net lines |
| Final state | 1,576 | 39 controllers + 29 lib modules |

The pattern is clear: **build-build-build-STOP-refactor**. The file grew 10x in 54 commits, hit almost 5,000 lines, and then I needed **6 rounds of refactoring** to bring it back to acceptable. Each stop was a big commit (hundreds of lines moved, dozens of files created), not a surgical tweak.

The CSS followed the same pattern: 1,053 lines in a single `application.css`, until the refactoring commit that exploded it into 10 theme files + 9 component files.

### Tests: Before vs. After

On FrankMD, the 2nd commit was "Add comprehensive test suite" — system tests (browser integration). Sounds responsible, but those tests covered **the happy path and nothing else**. The JavaScript unit tests only came in commit #52, **after app_controller.js had already hit 5,000 lines** — because I needed tests to refactor safely. Retroactive tests.

Ruby coverage reflects this: it had to be pushed from 77% to 89% in an explicit "Add tests for untested success paths" commit. That wasn't TDD — it was **filling holes afterward**.

### The Numbers Side by Side

| Metric | FrankMD | M.Akita Chronicles |
|---------|---------|---------------------|
| Commits | 212 | 274 |
| Days | 19 | 8 |
| Commits/day | 11 | 34 |
| Tests | 1,364 JS + ~490 Ruby | 1,323 Ruby |
| Ruby coverage | ~89% (retroactive) | 82-87% (organic) |
| Test/code ratio | ~1.2x | 1.52x |
| "Stop everything" refactors | 6 big ones | 0 |
| Incremental refactors | 16 | 27 |
| Largest file (peak) | 4,990 LOC | — |
| CI on every commit | No | Yes |

The number that matters: **commits per day**. The M.Akita Chronicles had 3x more throughput — with TDD, CI, and continuous refactoring — because **it never had to stop**. No "stop everything and refactor 5,000 lines into 10 files" commit. No "I need to add retroactive tests so I can touch this code without fear" moment.

### The Concrete Lesson

FrankMD's 6 big refactors weren't "continuous refactoring". They were **emergency surgery on accumulated technical debt**. Each one took hours — not the 2 minutes of the "extract a concern" described above. And each one introduced risk: when you move 1,500 lines from one file to 10 new files, the chance of breaking something is proportional to the size of the change.

With TDD and continuous refactoring, the M.Akita Chronicles never accumulated that debt. The 27 refactors are small commits — "Extract StealthBrowser", "DRY bubble methods" — that take minutes and are protected by the 1,323 tests that already existed when the refactoring was done.

**Same developer. Same AI agent. Two different approaches. Result: the disciplined project delivered more, in less time, with less pain.**

## Conclusion

![xp book](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/41MD3fXWOXL.jpg)

This project isn't an AI showcase. It's a showcase of software engineering accelerated by AI. And the strongest proof is that **the same developer with the same agent** produced radically different results depending on the process.

On FrankMD, without discipline, the result was predictable: a 5,000-line file, 6 emergency surgeries, retroactive tests, and 11 commits per day. On the M.Akita Chronicles, with XP, the result was 34 commits per day, zero forced stops, 1,323 organic tests, and a production system in 8 days. The variable wasn't the AI — it was the process.

274 commits in 8 days don't happen because the agent is magical. They happen because Extreme Programming — pair programming, TDD, small releases, continuous refactoring, continuous integration — works as well with an AI pair as it does with a human pair. Maybe better in some ways: the agent never gets tired, never argues from ego, never says "but we've always done it this way", and reads 700 lines of documentation before every interaction without complaining.

The future of development isn't "AI replacing programmers". It's programmers who know how to use AI as a tool — with the same discipline they've always used with any other tool — producing in a week what entire teams take quarters to deliver.

Not because the AI is brilliant. Because **the process** is brilliant. XP was right from the start. It was just missing a pair that never gets tired and types at 1,000 words per minute.

Remember:

> "AI is your mirror, it reveals faster who you are. If you're incompetent, it'll produce bad things faster. If you're competent, it'll produce good things faster." - by Akita
