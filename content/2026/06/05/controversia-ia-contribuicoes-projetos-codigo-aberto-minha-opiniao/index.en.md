---
title: "AI Controversy in Open Source Project Contributions - My Take"
slug: "ai-controversy-open-source-project-contributions-my-take"
date: '2026-06-05T11:00:00-03:00'
draft: false
translationKey: controversia-ia-contribuicoes-projetos-codigo-aberto-minha-opiniao
tags:
  - ai
  - opensource
  - vibe-coding
  - llm
  - github
  - ai-memory
  - ai-jail
  - ai-usagebar
---

Over the last few days, the discussion around **AI slop** in open source projects came back. Maintainers complaining that AI-generated PRs are garbage. Projects banning AI-assisted contributions. Bug bounty programs getting flooded with fake reports. Users angry because a release that used AI broke something. And, of course, the internet doing what the internet does best: turning one specific case into a holy war.

My short take: **AI in open source contributions is here to stay**. It will increase, not decrease. Pandora's box is already open. There is no realistic plan where everyone goes back to programming 100% manually and pretends Claude Code, Codex, OpenCode, Cursor, Gemini CLI, and the rest never existed.

That does not mean every project is obligated to accept AI-assisted contributions. Far from it. The maintainer has the absolute right to run the project however they want. They can accept AI, ban AI, freeze the project, delete the repository and go grow tomatoes. Open source is not mandatory democracy. Whoever maintains decides.

But I also think banning AI is mostly delaying a fight you cannot win. The volume will keep going up. Average quality will wobble. There will be trash, there will be good work, there will be almost-right PRs, there will be hallucinated bug reports. The practical question is not "how do we stop AI?" The practical question is: **how do we adapt the process to survive this?**

## The recent cases

The loudest case right now was [rsync 3.4.3](https://linuxiac.com/rsync-3-4-3-regressions-trigger-debate-over-ai-assisted-code/). The version shipped on May 20 as a security update, fixing six CVEs. Soon after, users reported regressions, especially in backup flows using daemon mode and incremental transfer options. Rsync is not a toy. It is a backup, deploy, mirror, sysadmin tool. Breaking compatibility there hurts.

Andrew Tridgell, creator of Samba and co-creator of rsync, answered in the post [rsync and outrage](https://medium.com/@tridge60/rsync-and-outrage-d9849599e5a0). He confirmed that he used Claude, with cross-checks from Codex and Gemini, to help rewrite part of the test suite in Python. But he also said the obvious thing a lot of people do not want to hear: he did not type "convert all of this" and go to sleep. He designed the suite, reviewed the work, burned a lot of CI time, and acknowledged that regressions happened in valid but uncommon cases that were covered neither by the existing tests nor by his manual testing.

That is the interesting point: the regression became a discussion about AI, but regression was not born with AI. Regression was born with software.

On the other side we have Zig. The [Zig Code of Conduct](https://ziglang.org/code-of-conduct/) today has an explicit policy: **Strict No LLM / No AI Policy**. No LLM-generated content, not code, not prose, not grammar edits, not translation, not brainstorming. Andrew Kelley explained in an interview, summarized by [DevClass](https://www.devclass.com/devops/2026/06/01/zig-creator-seeks-uncompromising-perfection-before-blessing-10/5248219), that the team considers AI contributions invariably bad, review-time sinks, unteachable, non-deterministic. The line that sums up his position is a good one: the bar he wants is not "works surprisingly well," it is "uncompromising perfection."

I disagree with the generalization, but I respect the decision. It is his project. If he wants to keep that space free of LLMs, that is his right. Period.

In the same neighborhood came the Bun discussion. The [official post about Bun joining Anthropic](https://bun.sh/blog/bun-joins-anthropic) says Bun was acquired because Claude Code and other Anthropic coding products depend on it. "If Bun breaks, Claude Code breaks," in the post's own words. Meanwhile, the [Cosmic piece about the Rust rewrite](https://www.cosmicjs.com/blog/bun-rust-rewrite-javascript-runtime) points to reasons like contributor accessibility, maintainability at scale, and long-term stability. I saw people linking this to Zig's anti-AI policy, but the source I could verify does not state that causality. What we can safely say is: Bun, a project born in Zig, is moving important parts to Rust, and one stated reason is Rust's larger contributor base.

Then there is curl. According to [Hackaday](https://hackaday.com/2026/01/26/the-curl-project-drops-bug-bounties-due-to-ai-slop/), Daniel Stenberg suspended curl's bug bounty program starting February 1, 2026 because the project was flooded with LLM-generated vulnerability reports. Long reports, intimidating, with the shape of a serious exploit, but when an experienced maintainer reads them, they are not vulnerabilities. The PR removing the bounty is on GitHub as [curl/curl#20312](https://github.com/curl/curl/pull/20312).

That case is different from a code PR. It is worse. A bad patch you test, compile, read. A fake security report forces someone experienced to spend time proving that the bug does not exist. That is the kind of thankless work that burns maintainers out.

So yes: the problem is real. AI slop exists. It is filling issue trackers, PRs, bug bounties, comments, everything.

Now the part nobody likes: it will not stop.

## There is no "back to normal"

I already talked about this in [VS Code Is the New Punch Card](/en/2026/04/11/vs-code-is-the-new-punch-card/). The interface changed. First you had to type binary instructions. Then you had to organize punch cards. Then you had to convince the compiler. Then you had to operate editor, terminal, framework, CI, container, cloud, and YAML. Now you have to orchestrate agents.

This does not eliminate engineering. It only changes where the manual work ends.

Some people are treating AI like a passing fad, like the "metaverse" or NFTs. It is not. AI for programming is already past the conference-demo stage. It is inside real workflows. Rsync used it. Bun has Claude Code bots opening PRs. My projects use it. Your contributors will use it, even if you forbid it. If you think you can detect with 100% certainty whether a patch was written with or without AI, good luck with that one.

The maintainer can still set a rule. They can say "if I find out you used AI, I block you." That may make sense in small communities with their own culture, like Zig. But in open source at large, especially big projects with users all over the world, this turns into compliance theater. The person uses AI, rewrites the text, does not disclose it, and that's that. What are you going to do? AI detector for code? For crying out loud.

## The mistake is thinking you have to review everything alone

The fairest maintainer complaint is simple: there already are not enough people to review human contributions. AI increases volume. More PRs, more issues, more bug reports. The maintainer was already tired, now they are underwater.

I get it. I just do not think the solution is to process the new volume with the old process.

You fight AI with AI.

The first triage has to be done with an LLM. Not to approve automatically. To filter. To summarize. To compare the diff against the stated goal. To point out bad smells. To say "this touches schema, it needs a migration." To say "this changes public behavior, it needs compatibility tests." To say "this PR description does not match the code." That layer alone removes 80% of the grunt work.

The mistake is letting the agent decide alone. The right move is making the agent do the boring investigation, then you decide.

That is how I do it.

## My real PR flow

Anyone who followed my [AI marathon](/en/2026/05/14/wrapping-up-my-ai-marathon-success-or-failure/) knows I did not get here after watching two YouTube videos. I spent weeks using agents every day, on real projects, breaking real things, fixing real things. What I am describing here is the workflow that survived that, not LinkedIn theory.

Shameless propaganda: I am happy that my three main AI-related projects are getting contributions almost every day:

- [ai-jail](https://github.com/akitaonrails/ai-jail), which I already covered in [ai-jail: Sandbox for AI Agents](/en/2026/03/01/ai-jail-sandbox-for-ai-agents-from-shell-script-to-real-tool/).
- [ai-memory](https://github.com/akitaonrails/ai-memory), which I explained in [I Built a Memory System for Coding Agents: ai-memory](/en/2026/05/23/i-built-memory-system-for-coding-agents-ai-memory/).
- [ai-usagebar](https://github.com/akitaonrails/ai-usagebar), from [I Built a Waybar Widget for Omarchy to Monitor LLM Plan Usage: ai-usagebar](/en/2026/05/24/i-built-a-waybar-widget-for-omarchy-to-monitor-llm-usage-ai-usagebar/).

ai-memory in particular became a live experiment. As I write this, GitHub shows **55 closed PRs** in the project; through the `gh` API, 46 were merged and 9 were closed without merge. Thanks to everyone who contributed. Seriously. Djalma, mrpaiva, pedrofjr, CaTeIM, azevedo-luis, brunoomariano, rikelmyso7, abnersajr, and several others. That is a lot of work from a lot of people.

![GitHub closed Pull Requests screen for ai-memory, showing 55 closed PRs and several recent PRs from contributors.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/05/ia-open-source-contribuicoes/screenshot-ai-projects.png)

It is also obvious, looking at the style, that most of those PRs were made with AI assistance. And that is not a problem. It would be hypocritical to complain: **the entirety of ai-memory was written by AI**. I did not open a code editor once to write that thing by hand.

But almost no PR arrives immediately mergeable. That is the point a lot of people still do not understand. "Made with AI" does not mean "blind merge." It means "the audit begins."

My prompt for reviewing a PR is more or less this:

> check the latest open PR as usual: do not trust the author, audit the whole code thoroughly, make sure it achieves its goal.
>
> Check whether we need to adjust or fix anything before merging: do not accept regressions, do not accept degraded code quality, check whether test coverage is correct.
>
> If it touches build or OS support, check GitHub Actions, CI, clean build, correct wiring, and documentation.
>
> Summarize what the PR does, what you found, and ask me for approval before proceeding.

Notice two things. First: "do not trust the author." That is not rudeness. It is engineering. The PR description is a hypothesis. The diff is the evidence. Second: "ask me for approval." The agent investigates, I decide.

When I receive several PRs on the same day, I do this for all of them. After they are all in, I send another prompt:

> check today's commits.
>
> We touched a lot of code, so I need a complete audit of the touched code to make sure we did not add regressions, unnecessary duplication, dead code, or magic values that should become documented constants.
>
> Follow clean code principles, confirm test coverage, and refactor whatever is needed.

If the project is already in use, I add the part many people forget:

> this project is already being used. Do not break compatibility.
>
> If we touched database schema or user-file structures, there must be a clean migration on upgrade.
>
> Upgrade must not corrupt data.

This guarantees nothing. But it avoids obvious mistakes.

In ai-memory you can see that pattern in the history. After a big batch of PRs, there are hardening commits from me. One example is [`65682dc`](https://github.com/akitaonrails/ai-memory/commit/65682dc), "fix(audit): address 5 BLOCKING audit findings from today's review," touching OpenAI OAuth, admin API, admission hooks, and the MCP server. Another is the sequence of PRs [`#65`](https://github.com/akitaonrails/ai-memory/pull/65), [`#68`](https://github.com/akitaonrails/ai-memory/pull/68), [`#70`](https://github.com/akitaonrails/ai-memory/pull/70), followed by hardening commits around base path, wikilinks, and strict mode. PR goes in, then audit, then adjustment. That second step is where the difference lives.

In [`#77`](https://github.com/akitaonrails/ai-memory/pull/77), the auto-scope by session/actor change touched a lot: `active_project`, hooks router, MCP server, stress tests, multi-user tests. More than 3,800 lines added. I am not going to pretend someone reads that manually line by line with the same consistency after the fifth hour. The agent helps map risk. I use my judgment to decide what needs hardening.

## Regression happens with or without AI

The rsync case is useful because it exposes a fantasy: the idea that human code was safe and AI code is dangerous.

No. Code is dangerous.

Rust is considered a safe language. And Rust has bugs. Go look at Rust's issue tracker. Zig wants perfection and has bugs. Curl has bugs. Rsync has bugs. Linux has bugs. SQLite has bugs. My code has bugs. Your code has bugs. There is no magical language that produces bug-free software. There never will be.

This is not pessimism. It is a fundamental limit. In computing, we have known for a long time that there is no perfect general verifier for non-trivial semantic properties of programs. Halting problem, Rice's theorem, that kind of thing. You can prove a lot in restricted domains. You can use a better type system. You can use Rust to eliminate entire classes of memory-safety bugs. You can use tests, fuzzing, model checking, static analysis. Good. Use all of it.

But "arbitrary software with no bugs" is fantasy.

Humans err because of incomplete context, wrong assumptions, pressure, fatigue, lack of tests, lack of real use. AI errs for the same practical reasons: incomplete context, wrong assumptions, training on bad code, poorly specified goals, weak validation. The difference is scale. AI can produce more trash per minute. It can also produce more fixes per minute if you build the process correctly.

## I use it because I use it

Another thing I learned in practice: it is very hard to maintain a project well if you do not use it yourself.

I use ai-memory every day. I use ai-jail every day. I use ai-usagebar every day. I used the [Prettify Manga Reader](https://github.com/akitaonrails/prettify-manga) extension in my real reading. That is why I catch bugs automated tests do not catch.

In Prettify, for example, the commits tell the story. [`66c6728`](https://github.com/akitaonrails/prettify-manga/commit/66c6728) added the night filter. Then came [`b5bcb4d`](https://github.com/akitaonrails/prettify-manga/commit/b5bcb4d), release 0.2.2, with Kindle Web Reader support, toolbar, shortcuts, and screenshot. Soon after came [`0e6b7ee`](https://github.com/akitaonrails/prettify-manga/commit/0e6b7ee), release 0.2.3, fixing spread pairing so right-to-left reading stayed correct without messing up chronological order. That came from real use. I was reading, noticed strange behavior, asked the LLM to fix it, tested it, released it.

That is the healthy loop: use it, feel the pain, fix it, test again.

In ai-jail, some contributions came from use cases I would not have prioritized on my own. [`#56`](https://github.com/akitaonrails/ai-jail/pull/56) fixed the PKGBUILD on AUR. [`#55`](https://github.com/akitaonrails/ai-jail/pull/55) forwarded OSC 52 clipboard writes through the alt-screen PTY proxy. [`#51`](https://github.com/akitaonrails/ai-jail/pull/51) recognized Grok as a known agent and documented the machine-id privacy mask. These details show up when other people use the tool in setups different from mine.

In ai-usagebar, this is even clearer. [`#4`](https://github.com/akitaonrails/ai-usagebar/pull/4) added a macOS Keychain fallback for Anthropic credentials. I am on Linux/Omarchy, not macOS. I was not going to find that bug in my daily use. [`#7`](https://github.com/akitaonrails/ai-usagebar/pull/7) fixed reading a custom `credentials_path` in the widget. Same story: a user with a different config from mine. This is where open source shines: someone scratches their own itch and improves the project for everyone else.

But notice: when I cannot test manually, like macOS and Windows, I depend more on CI. GitHub Actions runs macOS, Windows, Linux. It does not replace real use, but it reduces risk. And when someone who uses that environment opens an issue or PR, that is gold.

Manual testing is still the last line of defense. If you give it up, you are introducing bugs by definition. Automated tests catch what you remembered to specify. Real use catches what you did not even know you needed to specify.

After merging a large set, my final flow is usually:

> now run `bin/deploy` to my home server and test it online.
>
> Check health, check whether it still works as before.

Again: it guarantees nothing. But it avoids breaking the obvious.

## There is no silver bullet

I do not think every project should accept AI PRs. I also do not think every project should ban them. There is no universal rule.

If you are a solo maintainer of a critical library, with no time, no decent CI, no energy to deal with an avalanche of bad PRs, banning AI-assisted contribution may be the right decision for now. Better that than accepting junk and breaking users.

If you maintain a small community and want to teach human contributors, as Zig argues, an anti-AI policy makes sense inside that culture. You are optimizing for contributor formation, not patch throughput.

But if you maintain a project that already gets high volume, that already has CI, that already has tests, that already has users, I think adaptation is inevitable. You will need automated triage. You will need an agent reviewing PRs. You will need a bot summarizing issues. You will need a tool that says "this looks like a hallucinated vulnerability report."

AI is imperfect and scales fast. That is exactly why the process has to change.

## My conclusion

AI slop is real. It will get worse before it gets better. There will be garbage PRs. There will be fake security reports. There will be regressions blamed on AI that would have happened with humans too. There will be angry maintainers. There will be users yelling. Normal.

But the direction does not change.

AI-assisted code is here to stay. The percentage of code touched by agents will keep rising. Banning it can work locally, for a while, in one specific community. Across the industry, it is a lost war.

The pragmatic path is to make AI work **for us**. Use AI for triage. Use AI for audits. Use AI to compare diffs. Use AI to find regressions. Use AI to write tests that fail before and pass after. Use AI to do the boring work that wears humans down.

And keep the human decision where it matters.

I have said this several times and I will repeat it: **AI is a mirror**.

If you are sloppy, it accelerates your sloppiness. Your code becomes industrialized AI slop.

If you are a real engineer, it amplifies your engineering. You keep demanding tests, CI, compatibility, migrations, review, clean code, deploy, manual testing. You just do it 10 times faster.

And for companies: if you are thinking, "great, now I save money because I do not need to hire as many programmers," I get it. Up to a point. But if you are putting AI into the workflow, then you must strengthen QA. More tests, more review, more validation process, more good people thinking about quality. Skip that and you are screwed. You will trade development cost for production bugs, rework, incidents, and angry customers.

There is no going back to the 100% manual world. Better to stop wasting energy trying to close Pandora's box and start building a decent process around what came out of it.
