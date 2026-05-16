---
title: "ADRs in Notion, without the bureaucracy"
date: 2026-05-16T10:00:00-03:00
draft: true
translationKey: adrs-decisao-no-notion-sem-burocracia
category: gestao
tags: [adr, technical-decision, notion, process, small-team]
author: pablo-winter
description: "ADR isn't corporate ceremony — it's the cheapest way to stop repeating the same mistakes in a small team. Here's how we do it at Nextside, in Notion."
cover: covers/adrs-decisao-no-notion-sem-burocracia.png
cover_alt: "Nextside symbol in red on cream background, placeholder cover illustration."
cta:
  servico: discovery
  posicao: ambos
  contexto: "Before burning 6 months, validate in 2 weeks — and document your decisions in an ADR."
canonical: ""
---

Every time someone says "ADR" in a meeting, half the room pictures a Sharepoint spreadsheet, an architecture committee, and a 14-page document nobody reads. I thought the same thing. So here's the real question: is ADR worth it for a small team? Short answer: yes — but not the way the book says.

ADR — **Architecture Decision Record** — is a record of a technical decision. Short. Dated. Immutable. You decide something important today, write down why you decided it, and six months from now when someone asks "why on earth did we pick Postgres over Mongo?", the answer is right there. No need to re-summon the lost meeting buried in February's calendar.

The point isn't the template. The point is not losing history.

## Why most teams fail at ADR

Most teams that try to adopt ADR copy Michael Nygard's template (or the AWS prescriptive guidance one, or ThoughtWorks') in week one, write 3 ADRs in 4 days, and abandon ship by day five. I've done it. Small teams have zero patience for ritual.

The problem is simple: the traditional template has 6 sections (Context, Decision, Status, Consequences, Alternatives Considered, Stakeholders). In a 4-person team with tight deadlines, nobody writes out "Alternatives Considered" with bullet points. Nobody. You open the doc, stare at 6 empty headers, close the doc, and go back to the code.

Result: the ADR becomes a joke. "Hey, remember when we were going to document decisions? Good times."

> "But if you don't document properly, how do you keep any history?" — fair question. Answer: we DO document, just in a format that fits a small team. Not in the format that fits a corporate architecture book.

And that's where the difference lives. ADR for a small team isn't "Architecture Decision Record" in the pompous sense. It's a **note to your future self**. You're writing for the version of you that shows up 4 months from now, who forgot why you chose Redis over Memcached. That's all.

## How we do it at Nextside, in Notion

No separate repo for ADRs. No `docs/adr/0001-use-postgres.md`. Just a database in Notion called `Decisions`. Simple schema:

- **Title** — short declarative phrase: "Use Postgres as the main database", "Adopt Hugo instead of Next for the blog"
- **Status** — Proposed / Accepted / Superseded / Rejected
- **Date** — when the decision was made
- **Tags** — area (backend, frontend, infra, process)
- **Body** — 3 sections: **Context** (1-3 paragraphs), **Decision** (1 dry paragraph), **Consequences** (short bullets: what we gained, what we gave up)

That's it.

Notice what's NOT there: "Stakeholders", "Voting", "Alternatives Considered" as a formal section. If alternatives matter, they become a paragraph inside Context. If they don't, they don't appear at all. The criterion is simple: **the ADR exists so someone can understand the decision 6 months from now, not to defend it in an Audit**.

The golden rule we follow: **if you decided something that would be expensive to reverse, write an ADR**. If you can undo it in a 50-line PR, write nothing. Documenting everything is the same as documenting nothing — it becomes noise.

## Concrete example (real-ish decision)

Typical scenario: the team needs to pick between two ORMs for a new Node project. Prisma vs Drizzle. Discussion runs 40 minutes on Slack. Someone opens Notion and writes:

> **Title:** Use Drizzle as the ORM for project X
>
> **Status:** Accepted
>
> **Date:** 2026-04-12
>
> **Context:** Project X needs an ORM with solid TypeScript support, versioned migrations, and predictable performance on analytics queries. We evaluated Prisma (more mature, better DX, but Rust runtime engine weighs on cold-start in serverless) and Drizzle (newer, zero-cost abstraction, SQL-first). The team already has familiarity with raw SQL.
>
> **Decision:** Adopt Drizzle. SQL-first fits the team's profile, cold-start in serverless is a concrete problem for this project, and the learning curve is smaller than the DX gain from Prisma.
>
> **Consequences:**
> - Faster cold-start on Vercel/AWS Lambda
> - We lose some advanced features Prisma has out-of-the-box (Prisma Studio, better introspection)
> - Migrations are more manual — requires greater discipline from the team
> - If it goes sideways, we can migrate to Prisma — Drizzle is thin, no heavy lock-in

Done. 180 words. 4 minutes to write. Six months from now, when a new dev joins and asks "why Drizzle?", the answer is right there, dated, with context.

That's the whole secret. No magic.

## What happens when you DON'T do this

What happens is what I call **history losing**. Decision made, nobody wrote it down, 6 months later the entire team has forgotten. Then comes the temptation to revisit. "Hey, should we have used Prisma?" 40-minute discussion. Again. Same 4 people. More or less the same arguments. Identical conclusion.

You just paid the price of that decision TWICE.

Worse: sometimes the conclusion is different — because someone forgot the critical argument that tipped the scales the first time. So the team switches from Drizzle to Prisma, refactors everything, and 3 months later hits the same cold-start problem that originally motivated Drizzle. Back to Drizzle. Another 3 months burned.

This is the worst thing that can happen in a small team: **repeating the same mistake because nobody wrote down the previous mistake**. Big companies can absorb it. A 4-person team can't.

**Institutional memory in a small team isn't Confluence. It's habit.**

ADR doesn't replace conversation. Doesn't replace pair programming. Doesn't replace [an RFC for something big — which fits better in a dedicated Discovery](https://nextside.tech/#discovery). But it does replace the "wait, let me try to remember why we decided that..." — and that "wait, let me try to remember" costs more than it looks. It costs interrupted context, rework, and trust in the team's own history.

> "But nobody's going to go back and read the ADR!" — they will. I do. Every time I come back to an old project and ask myself "why?" The ADR is the shortcut to the why. Without it, the shortcut disappears.

## How to start tomorrow (without turning it into a heavy process)

If you've never had ADR in your team and want to start, three steps:

- **Create a database in Notion (or Linear, or Trello, or a `docs/decisions/` directory in the monorepo)** — the tool doesn't matter. Having ONE place does.
- **Define the trigger rule** — any decision that would cost 1+ day to reverse deserves an ADR. Framework choice, database, auth pattern, queue choice, error pattern. Variable naming does NOT.
- **Add a trigger to the PR template** — optional question in the template: "Does this PR introduce an architectural decision? If so, link the ADR." Soft enforcement. Without it, the habit dies in the second week.

In 3 months, the team has 10-15 ADRs. In a year, 30-40. It's not volume. It's **context density**. Each ADR is a clear signal of "here we made a decision that mattered."

And here's the detail nobody talks about: the real value of the ADR isn't in the document. It's in **the act of writing**. When you sit down to explain the decision in 3 paragraphs, you discover that half the decision was implicit and poorly formed. The ADR forces clarity. It's the pair programming of technical decision-making.

For those who want to go further — and [encode the process into a skill that AI executes](/en/posts/2026/05/16/claude-code-superpowers-plugin-na-pratica/), so that writing an ADR becomes an automatic trigger — that's the natural next step. But start with the human habit. A skill without habit behind it is theater.

That's why I don't even mind if nobody reads it afterward. It was already worth it just for the act of writing.

## The ADR INDEX: the part nobody talks about yet

Here's what changed for me in 2026.

ADRs are great for humans. New partner joins the team, opens `docs/adr/0042-prisma-vs-sequelize.md`, gets the decision in 5min. Good.

But now AI also reads your repo. And it needs an **index**, not brute-force search.

> "Can't AI just grep the directory?"

It can. And fills the context with 47 irrelevant ADRs to answer one question. Costs tokens, costs quality, costs time.

The solution came from Claude Code itself: its auto-memory system uses a `MEMORY.md` file that's just an **index** — each line points to a detailed memory file with a 1-line description. When Claude needs to decide something, it reads `MEMORY.md` (200 lines max), picks the relevant memory, and only then opens the detailed file.

The parallel for ADRs is exact. In your Notion (or `docs/adr/INDEX.md` if you use a repo), create an `INDEX` page at the same level as the ADRs:

```
- [ADR-0042 — Prisma over Sequelize](./0042-prisma-vs-sequelize.md) — Postgres with strong typing; rejects Sequelize over migration pain
- [ADR-0043 — Server Components on Next 15](./0043-rsc-next-15.md) — Default; "use client" only where real interaction exists
- [ADR-0044 — No Redux](./0044-sem-redux.md) — Zustand for small global state; URL state for the rest
```

One line per ADR. Description that fits in search.

Now Claude (or any AI) hits your repo, reads `INDEX.md` in 2s, picks which 2-3 ADRs are relevant to the problem at hand, loads only those in context. **The difference between 3 ADRs read and 47 is the difference between useful AI and confused AI.**

And the best part: you get the index for free. New humans use it too. No extra cost.

Without an INDEX, your ADRs become a cemetery of great documentation nobody reads — neither human, nor AI.

## What ADR actually protects you from

ADR doesn't protect you from making the wrong decision. ABSOLUTELY NOT. You're going to make the wrong decision anyway — every team does. What ADR protects you from is making the SAME wrong decision twice. Which is a different thing.

A good team isn't the one that gets everything right. It's the one that makes fewer mistakes with each iteration. ADR is the record that lets you know which mistake you made and why — so you don't make it again the next time a similar decision comes up. It's the equivalent, in product decisions, of the [local validation with real quality we do via MCP Playwright in frontend](/en/posts/2026/05/16/mcp-playwright-validacao-local-com-qualidade/): you don't prevent every mistake, but you ensure that mistakes become registered learning.

In a small team, the margin to repeat mistakes is zero. Every week burned on a redone decision is a week you didn't have. Discovery, MVP, refactor — there's no slack.

That's why the Nextside team writes ADRs in Notion. Short. Dated. Honest. No giant template. No ceremony. No extra meetings.

ADR isn't for impressing an auditor. It's for the team. And the team is small. And time is short.

Those who don't record history are doomed to repeat it. And repeating mistakes is a luxury a small team simply can't afford.
