---
title: "Clean Code for AI Agents"
date: '2026-04-20T12:00:00-03:00'
draft: false
slug: clean-code-for-ai-agents
translationKey: clean-code-for-ai-agents
tags:
  - clean-code
  - AI
  - claude-code
  - vibecoding
  - software-engineering
---

In 2008, Robert C. Martin (Uncle Bob) published **Clean Code: A Handbook of Agile Software Craftsmanship**. It's one of the most influential software engineering books of the last couple of decades. For those who don't know, Uncle Bob started programming professionally at 17, founded Object Mentor, signed the Agile Manifesto, served as the first chairman of the Agile Alliance, coined the SOLID acronym. He's written a dozen books on design, architecture, and practice, and influenced entire generations of developers.

I've been following Uncle Bob for many years. I've exchanged messages with him a few times over the decades, I have formed opinions about his positions, and I did an hour-long live stream on my channel with him about Clean Code, Agile, Craftsmanship, and where the industry was heading. If you've never watched it, I recommend it:

{{< youtube id="ycvaECDc31w" >}}

Clean Code specifically set a standard: code is written once but read dozens of times. The programmer's job isn't just to make it work. It's to make it work **in a way that another programmer can understand, modify, and not break**. Meaningful names, small functions, one responsibility per class, no duplication, automated tests, clear structure. The target audience was always another human being sitting at an editor trying to figure out what the first one did.

In 2026, that audience changed.

## The audience isn't human anymore

Last week I wrote [VS Code Is the New Punch Card](/en/2026/04/11/vs-code-is-the-new-punch-card/). The thesis is that typing code manually into a text editor is becoming a niche activity, the same way typing binary directly on an Altair front panel became a relic after compilers got good. The AI agent is the new compiler: I describe intent in natural language, the agent navigates code, edits, runs tests, adjusts, delivers.

If that thesis holds, the next question is obvious: **who are we writing code for now?**

Not for the human programmer who'll sit down tomorrow to maintain it. It's for the agent that'll read, edit, and extend it. And an agent is not human. Agents have different technical constraints, different biases, different limitations. Part of Clean Code still applies (in some cases more critically). Another part shifts in weight. And new demands emerge that Uncle Bob couldn't have anticipated in 2008.

This article is about that. What's the version of Clean Code that makes sense when the primary reader is an LLM?

## The real agent constraints

Before re-ranking, worth reviewing what agents actually face.

**File truncation.** Most agent CLIs limit file reads to small ranges. Claude Code reads 2000 lines per chunk by default. Cursor, Codex, Windsurf, all have similar caps. A giant file simply doesn't fit into the context window in one shot. The agent has to ask for piece by piece, or worse, use grep and reconstruct mentally.

**Attention degrades with context.** Claude Opus has a 200k-token window, Sonnet 1M, Gemini 1M. Sounds like a lot. In practice, "needle in haystack" tests show retrieval quality drops well before the claimed limit. Flash Attention and variants speed up the computation, but they don't replace full native attention. The more you stuff into the window, the worse the detail precision. And the agent's context isn't just your code: it holds CLAUDE.md, the system prompt, chat history, tool output, error logs, test output. All competing for the same window.

**Grep is cheaper than read.** The agent knows this. It prefers `rg "funcName"` over loading a whole file. It's faster, uses fewer tokens, hits the target. Unique, distinctive names make that much more effective. This isn't a shortcut, it's an architectural choice: I wrote about this in detail in [Is RAG Dead? Long Context, Grep, and the End of the Mandatory Vector DB](/en/2026/04/06/rag-is-dead-long-context/), showing that Claude Code itself navigates a repo with `Glob` and `Grep`, no vector DB, no embedding, and that's not a deficiency, it's mature design. Lexical search + smart reader consuming raw text beats dense retriever + top-k on practically every real-domain benchmark. You benefit from that when you organize your code: greppable names aren't just "nice for humans", they're the agent's primary navigation API.

**Tool calls cost tokens.** Every `Read` or `Edit` or `Bash` burns input and output tokens. Short files, small test output, concise logs — all of that keeps the agent productive and the bill low.

**Latency matters.** Agent in a loop, each tool call adds seconds. A large file slow to process becomes perceptible session friction.

**Grepping by visual pattern is hard.** If you used inconsistent indentation, mixed tabs and spaces, varied brace style between files, the agent spends tokens internalizing the mess. Consistency helps.

From those constraints, Clean Code principles can be re-ranked by relevance for agent-facing work.

## Re-ranking: Clean Code in the age of agents

Most important to least. A caveat: it's not that the ones at the bottom stop mattering. It's that the ones at the top started mattering MUCH more.

### 1. Small functions (and small files)

Uncle Bob: "functions should do ONE thing, they should do it WELL, and they should do it only". Ideal size 4 to 20 lines, per the book.

For an agent, that recommendation became a technical obligation. A small function fits in a single tool call without truncation. A short file (keep it under 500 lines, ideally 200-300) fits in a single read. If the agent can grab the whole unit of meaning in one call, it reasons about it with full attention. If it has to paginate, it builds a fragmented mental model, and each fragment costs attention.

Before, "small function" was good for humans because it aided reading. Today, "small function" is good because it matches the model's unit of processing. If there's one recommendation to take to heart, it's this one.

### 2. Single Responsibility Principle (SRP)

Each module does one thing and has one reason to change. It was already the heart of Clean Code. For an agent, it becomes even more critical because:

- The agent can isolate the unit to understand without loading the rest of the system
- You can run focused tests on it
- You can edit without fearing side effects
- Grepping by responsibility becomes predictable

Code with tangled responsibilities forces the agent to load way more context for any simple change. An 800-line class that does three things is worse for the agent than three 250-line classes, even if the total is the same.

### 3. Meaningful and unique names

Clean Code already preached: names reveal intention, no disinformation, distinctive, pronounceable, searchable. For the agent, "searchable" became the most important property of that list.

The agent searches code via grep/ripgrep all the time. A generic name (`data`, `process`, `handler`, `Manager`, `Service`) returns fifty matches and forces the agent to read each one. A distinctive name (`UserRegistrationValidator`, `InvoiceLineItemTotal`, `ClaudeCodeSessionTracker`) returns three matches and the agent goes straight to the right one.

Rule of thumb: if you grep the name and a lot of irrelevant stuff comes back, the name is bad for the agent. If only what matters comes back, the name is right.

### 4. Comments with context and provenance

This is where the inversion is most jarring. For Uncle Bob in 2008, the axiom was: "good code explains itself, excessive comments are a code smell, every comment is debt that gets stale". Every experienced programmer who read the book absorbed that rule. Well-named code doesn't need comments. Too many comments = flag of bad code trying to justify itself.

Now flip it. **The agent reads comments. And likes them**. Comments become first-class context. The agent has perfect syntax fluency, knows exactly what `x++` does, doesn't need obvious captions (that kind is still bad, see item 13). What it DOESN'T know is why you chose this approach over the obvious one, what production bug motivated this weird logic, what business constraint forces this specific order, what workaround exists because the upstream lib has known bug #1234, which commit introduced this decision, which Jira issue is the reference. That kind of information is **provenance**: the why of the decision. It only exists in the head of the human who wrote it, in the commit message, or in a well-placed comment. For the agent, the comment is the most accessible source during a tool call.

Docstrings with intent and usage examples also became strong signals. When the agent picks up a function without understanding the context, a header docstring (JSDoc-style with examples, Python `"""`, Rust `///`) drastically shortens the path to a correct change. Uncle Bob was skeptical of JavaDoc in 2008 because they got stale. Today, with the agent able to rewrite the docstring alongside the code, that counter-argument lost weight.

A practical consequence: **don't prune the comments the agent writes**. If you have the reflex "verbose comment is noise" inherited from the original Clean Code era, that rule flipped. The agent wrote that comment because, in the act of generating the code, it decided that information was worth preserving for future edits. Removing the comment in code review strips context that the agent itself will want to read on the next interaction. Let the agent comment. It knows what it's doing. The only kind of agent-authored comment worth removing is the obvious redundant one (item 13), and modern models rarely produce those if the system prompt is well written.

### 5. Explicit types

This isn't in 2008's Clean Code because the industry hadn't converted yet. But in 2026 it's a fundamental criterion.

Python without type hints, JavaScript instead of TypeScript, Ruby without RBS. Dynamic code without annotations forces the agent to infer types from usage, which costs reasoning and gets it wrong frequently. Typed code gives an immediate answer key: the signature says what goes in, what comes out, which states are valid. The agent saves discovery work and makes fewer mistakes.

If you're still on Python 3 without type hints, the transition will boost agent productivity more than any logic refactor.

### 6. DRY (Don't Repeat Yourself)

Clean Code already said duplication is the root of all evil. For an agent, duplication is worse than for a human for one specific reason: when the agent has to change something that's replicated, it can update one copy and forget the others. The attention window doesn't have natural gravity pulling "oh, there are two more copies of this in other files". The agent has to find each one via grep, and if the pattern has subtle variation between copies, the result ends up inconsistent.

Factoring into a reusable function or module isn't aesthetic. It's automated-refactor safety.

### 7. Tests the agent can run

Uncle Bob dedicates a full chapter to Unit Tests and F.I.R.S.T (Fast, Independent, Repeatable, Self-Validating, Timely). All of it still applies, with an important addendum: **the test has to be executable by the agent without human setup**.

Meaning: the command to run the test is in the README or CLAUDE.md, in the `Makefile`, in the `package.json`. Output has a predictable format the agent parses. It doesn't depend on manually seeding the database, on a config file that isn't in the repo, on a secret credential. The agent writes code, runs tests, reads output, adjusts, runs again. That cycle is the foundation. If the tests don't run headless, the agent goes blind.

Here I speak from field experience. I documented this in [From Zero to Post-Production in 1 Week Using AI](/en/2026/02/20/zero-to-post-production-in-1-week-using-ai-on-real-projects-behind-the-m-akita-chronicles/), where I went hard on a real project: 274 commits in 8 days, 4 integrated applications, 1,323 automated tests by the end. What made it work wasn't "AI programs on its own". It was **Extreme Programming with the agent as pair instead of a human pair**. Running tests on every commit, tight CI, coverage above 80% (95%+ on business logic), test-line-to-code-line ratio above 1:1 on some modules. Sounds like overkill. It isn't. In 274 commits, CI caught real bugs more than 50 times, bugs that would have gone straight to production if I had blindly trusted the agent. Without tests, the agent hands you plausible code that silently breaks something that worked yesterday. With strong tests, the agent becomes a multiplier: it generates a test, the test validates the code it wrote, the test is the safety net for the next change it makes. Virtuous loop.

XP practices (pair programming, CI, tests first, continuous refactoring, short feedback) didn't become obsolete. They became **exactly the right way to work with an agent**. Whoever programs in cowboy mode without tests today isn't rebellious. They're just slow, because the agent without tests keeps guessing, and guesses need manual review, which kills the speed the agent should bring. Good tests with good coverage became the difference between a productive agent and an agent that keeps flailing. Or, put another way: **TDD became a technical obligation, not a philosophy**.

I covered this theme from another angle in [Software Is Never "Done"](/en/2026/03/01/software-is-never-done-4-projects-life-after-deploy-one-shot-prompt-myth/), showing that post-deploy life is where tests matter most: in ten days of operation after launch, I ran 56 commits of fixes, hardening, and adjustment in response to real behavior, and each commit came with a regression test. Without the net, each of those 56 commits would be an opportunity to break something that worked yesterday. TDD isn't a phase, it's a habit.

### 8. Predictable directory structure

Clean Code barely discusses this (it was more focused on code inside a file). For an agent, tree organization matters. If `src/controllers/users.rb` implies `src/models/user.rb` and `src/views/users/`, the agent can anticipate paths without listing directories. If the project uses idiosyncratic naming (random files, unpatterned names, everything flat in one folder), the agent loses time with `find`.

Strong framework conventions (Rails, Django, Next.js, Laravel) help the agent a lot. Project without convention, the agent builds one over time, but until then it burns tokens exploring.

### 9. Dependency Injection and Testability

Code with injected dependencies (not hardcoded) is easier to test in isolation. The agent benefits from this. It can swap the real `EmailSender` for a `FakeEmailSender` in a test without touching the logic. Code that instantiates its dependencies internally forces the agent into monkey-patch-fake-server-hacks that are slow, fragile, and pollute the session with infra grime.

DI isn't ceremony. It's isolation scope. And in a real project, DI quickly becomes a load-bearing refactor: on one of my projects (the [M.Akita Chronicles](/en/2026/03/01/software-is-never-done-4-projects-life-after-deploy-one-shot-prompt-myth/)), I discovered after launch that I needed to swap the default LLM model to another provider. The environment variable had existed from the start. But the model name was still hardcoded in references across 24 files. A whole commit (`Centralize LLM model config`) touched all 24 to isolate the config into a single constant. Swapping models after that became a one-line change. That's exactly the kind of refactor that only shows up after software meets reality, and it's where DI and config isolation pay dearly if you didn't do it earlier.

### 10. Avoid deep nesting

Clean Code talks about single level of abstraction per function. A corollary: avoid `if` inside `for` inside `if` inside `try`. Every indentation level is more attention the model has to spend tracking state. Four levels of indentation is MUCH more cognitively expensive for the agent than two levels with early return.

Pattern matching, guard clauses, early returns, flattening logic, all of this improves readability for the model the same way it improves it for the human, except measurably so, because the cost is measured in response quality.

### 11. Errors with context

`raise ValueError("invalid input")` doesn't help the agent when it reads the stack trace. `raise ValueError(f"invalid input: received {repr(x)}, expected non-empty string of digits")` does. The agent uses exception messages as debug signal. Vague message = agent runs an extra round to figure out what went wrong.

Uncle Bob talked about this in Error Handling: "Provide context with exceptions". It became critical now.

### 12. Formatting and style

Don't waste time on this. Use the default or most popular formatter for your language: `cargo fmt` for Rust, `gofmt` for Go, `prettier` for JS/TS, `black` or `ruff` for Python, `rubocop -A` for Ruby. Configure it in pre-commit, configure it in your editor to run on save, and move on. The agent handles any consistent style just fine, and the auto-formatter keeps the diff tidy between commits. Tab vs space, 80 vs 100 columns, brace style, all of that became noise. The formatter decides, you accept.

### 13. Comments that describe the obvious

Last on the list. Still bad, got even worse. Comments like `// increment i by 1` above `i++` waste the agent's tokens the same way they wasted the human's patience. The model knows how to read code, it doesn't need obvious captions.

If you have the habit of writing obvious comments because some school taught you that way, this is the moment to stop. In 2008 it was bad because it polluted visual space. In 2026 it's bad because it costs real money in tokens.

## What Uncle Bob couldn't foresee

Beyond re-ranking what was in the book, some new things emerged that are specific to the agent world:

**Meta-documentation files for agents.** `CLAUDE.md`, `AGENTS.md`, `.cursor/rules`, and so on. These are files the agent reads before any tool call, describing project conventions, important commands, caveats, things that don't go in a docstring. Writing these files is a new skill: short, direct, imperative, action-oriented. No philosophical prose. Bullet points of what the agent needs to know to not mess up.

**README with high-level architecture.** Uncle Bob barely cared about README (the book is about code). For the agent, well-made READMEs drastically shorten the path to understanding the shape of the project. A simple ASCII or Mermaid diagram helps.

**Structured logging.** JSON logs with named fields are much more useful for the agent than prose logs. The agent parses JSON trivially, uses fields to filter relevant errors, correlates across services. A loose `printf` in free text forces heuristic parsing.

**Accessible observability commands.** `pnpm test`, `make lint`, `cargo check`, `python -m mypy` — the more the project exposes predictable commands the agent can invoke to validate changes, the better. If running tests requires 10 manual setup steps, the agent won't run tests, and the feedback loop breaks.

**Idempotent setup scripts.** The agent has to be able to run `bin/setup` or `scripts/bootstrap.sh` on a clean machine and reach a state where it can work. If onboarding depends on instructions in someone's head, the agent is locked out.

## Instructing the agent to write clean code

There's an important detail that only becomes clear after about 500 hours of using agents: **no LLM does any of this by default**. You tell it "implement feature X" and it'll implement it the way the model considers average. No dependency injection. 80-line functions. No tests, or tests that mock the wrong thing. Duplicated logic because it's faster. 2000-line files because "everything's in one place". You need to WRITE these rules. The agent reads, the agent follows.

Where to write: `CLAUDE.md`, `AGENTS.md`, `.cursor/rules`, `.github/copilot-instructions.md`, depending on the CLI. Format: short, imperative, action-oriented. The agent reads these files on every iteration (Claude Code re-reads CLAUDE.md on every query), so each line burns context tokens — density matters.

Below is a proposal for a template you can drop into a `CLAUDE.md` on a new project, consolidating what I discussed above in a format the agent consumes. **This is not a definitive version**, it's a starting point to test and tune to your language, your team, your flow. If a rule doesn't fit your context, remove it. If you need a new rule, add it. The point is to have a structured skeleton:

```markdown
## Code style

- Functions: 4-20 lines. Split if longer.
- Files: under 500 lines. Split by responsibility.
- One thing per function, one responsibility per module (SRP).
- Names: specific and unique. Avoid `data`, `handler`, `Manager`.
  Prefer names that return <5 grep hits in the codebase.
- Types: explicit. No `any`, no `Dict`, no untyped functions.
- No code duplication. Extract shared logic into a function/module.
- Early returns over nested ifs. Max 2 levels of indentation.
- Exception messages must include the offending value and expected shape.

## Comments

- Keep your own comments. Don't strip them on refactor — they carry
  intent and provenance.
- Write WHY, not WHAT. Skip `// increment counter` above `i++`.
- Docstrings on public functions: intent + one usage example.
- Reference issue numbers / commit SHAs when a line exists because
  of a specific bug or upstream constraint.

## Tests

- Tests run with a single command: `<project-specific>`.
- Every new function gets a test. Bug fixes get a regression test.
- Mock external I/O (API, DB, filesystem) with named fake classes,
  not inline stubs.
- Tests must be F.I.R.S.T: fast, independent, repeatable,
  self-validating, timely.

## Dependencies

- Inject dependencies through constructor/parameter, not global/import.
- Wrap third-party libs behind a thin interface owned by this project.

## Structure

- Follow the framework's convention (Rails, Django, Next.js, etc.).
- Prefer small focused modules over god files.
- Predictable paths: controller/model/view, src/lib/test, etc.

## Formatting

- Use the language default formatter (`cargo fmt`, `gofmt`, `prettier`,
  `black`, `rubocop -A`). Don't discuss style beyond that.

## Logging

- Structured JSON when logging for debugging / observability.
- Plain text only for user-facing CLI output.
```

This block fits in under 100 lines and costs about 500 tokens per iteration. Sounds like a lot, but the savings in code quality and absence of rework easily make up for it, especially if you're on a pay-per-token API account. Use it as a base and evolve it with your own experience.

Some items (SRP, small functions, tests) the agent will try to do on its own. Others (DI, strict DRY, explicit types EVERYWHERE, aggressively unique names) it only does when you say so explicitly. And some (like "don't strip the comments you wrote yourself on a refactor") are so counterintuitive to its default training that without the instruction it WILL prune them. Hence the importance of having a rules file that gets read every iteration.

An analogous pattern shows up around defensive programming: the agent implements circuit breaker, retry with backoff, aggressive timeout, graceful degradation, all of it nicely — **when you ask**. But on its own it won't propose them. The agent doesn't know what your system's operational failure points are, so it implements the happy path and waits for instruction. If your CLAUDE.md lists the categories of defensive code the project needs (rate limit, retry, breaker, fallback), the agent covers them. If it doesn't list them, the agent doesn't invent them. It's another case where explicit instruction to the agent is what separates robust code from naive code.

If you use the same agent across different projects, it's worth having a base template and adding project-specific rules on top. But start with something like the above and iterate from there.

## The short version

Uncle Bob wrote Clean Code to be read by other humans. In 2026, the primary reader became the agent. The good news is that most of what the book preached still holds. The bad news is that some things that were opinions ("a file should have N lines") became technical constraints ("a file with X lines makes the agent perform worse"). The difference is that now there's a metric: token cost, tool-call latency, output quality. Whoever writes clean code for the agent saves API-bill money, session time, and gets less hallucination in the output.

And there's a cultural bonus worth registering: all these practices (XP, TDD, SOLID, SRP, DI, small code, abundant tests) were falling out of fashion in the 2010s, replaced by "move fast and break things" and two-month bootcamps. Programmers who invested in fundamentals became a minority, and it became fashion to trash Uncle Bob on the internet. Turns out those very fundamentals became the technical differentiator of working with agents. Whoever kept the discipline is well served. Whoever dismissed it is now struggling to teach the agent not to commit mistakes the XP crowd had mapped out 25 years ago.

Clean code was never fashion. It became infrastructure.
