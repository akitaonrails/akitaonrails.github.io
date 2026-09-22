---
title: "Stop Making Excuses and Ship More! With AI, the Premise Changed. Get It."
slug: "stop-making-excuses-and-ship-more-the-premise-changed"
date: '2026-09-22T16:00:00-03:00'
draft: false
translationKey: parem-de-inventar-desculpas-e-facam-mais-deploy-a-premissa-mudou
description: "With frontier LLMs making fewer mistakes than most human devs, the only real excuse left for holding back a deploy is your own review process's bureaucracy. I use my open source projects, cross-platform CI/CD, and real contribution numbers to show how I've been doing this since February."
tags:
- devops
- software-engineering
- coding-agents
- vibe-coding
---

Today I fired off a string of posts on X hammering this point, and, like every time I talk about fast deploys, a bunch of people read it as "this guy is saying to ship any garbage to production without testing." That's not it. Let me lay it out calmly, because the argument is narrower and more boring than the version that spreads panic.

> It's better to deploy faster, because fixing things afterward became fast and cheap.

That sentence is the whole article. Everything else is just me justifying why it's true now, even though it wasn't true a few years ago, and showing how I've been acting on it myself since February.

## The Premise Changed, and Most People Haven't Noticed

I started saying this [on X](https://x.com/AkitaOnRails/status/2102436061083267441) like this:

> Fixing got cheap. Stop holding things back. Just ship it and fix it after. "Ugh, but I risk shipping a bug." The wrong premise is thinking that staring at every line is going to make any difference at scale. And idle code doesn't improve on its own. Only used code lets you find out if it needs improving.

And I followed up [in the second post](https://x.com/AkitaOnRails/status/2102476036709450066), because the first read of anything I write in 280 characters always comes back angrier and more literal than intended:

> Get the concept (this is an X post, not a blog post, stop reading it literally). I'm not saying AI doesn't produce bugs. It does, obviously. But at this point, not more than you, the human, also produce. [...] The old excuse was that when a bug ships to production, it sits there longer than it should, because it never becomes a sprint priority to fix. Now THAT'S NOT TRUE ANYMORE, the premise changed: fixing the bug afterward is FAST and CHEAP.

That's the entire point. It isn't about AI being infallible. It's about the cost of fixing a mistake having collapsed, while most teams still run their review process as if that cost were still high.

With today's frontier models, Opus, Sol, K3, and company, the LLM makes fewer mistakes than most human developers I've seen go through a code review. When it does err, the overwhelming majority of the time the mistake isn't the model's. It's whoever was driving the harness. The LLM does what you ask, and it doesn't do what you didn't ask.

If you don't know what to ask for, you won't produce anything useful, no matter how good the model is. That's exactly why only a real software engineer can get real production-grade software out of an agent: someone has to know how to break down the problem, validate the result, and recognize when the request itself was poorly framed. AI doesn't replace that judgment. It multiplies what that judgment already knew how to do.

## This Should Have Been the Norm for 25 Years

The discomfort I feel with bureaucratic review processes isn't new, and the industry should have solved it a long time ago. Kent Beck and Ron Jeffries invented Extreme Programming in 1997, on Chrysler's C3 project, and Beck published the book in 1999 with continuous integration, TDD, and small-batch delivery as core practices. In February 2001, seventeen developers locked themselves in a resort in Snowbird, Utah, and walked out with the Agile Manifesto. That's twenty-five years ago.

Martin Fowler's mantra for continuous integration has always been "if it hurts, do it more often," and the book *Continuous Delivery*, by Jez Humble and Dave Farley, formalized the idea that small, frequent deploys reduce risk, not increase it. DORA's annual State of DevOps reports have documented this with numbers for over a decade:

- elite teams: deploy on demand, multiple times a day;
- low-performing teams: deploy once a month, sometimes once every six months.

And the finding that's hardest to swallow if you're afraid of deploying fast: historically, more frequent deploys **do not increase** the failure rate. *They reduce it.* Teams that deploy more, on average across the last decade of reports, fail less and recover faster when they do fail.

Even with all of this documented, measured, and published for over a decade, a large chunk of the industry keeps damming up change into big batches, with slow manual review, and calling that "prudence." It was never a settled matter even inside the agile community itself: in 2014, Kent Beck, Martin Fowler, and DHH (Rails' creator) spent weeks publicly debating whether TDD was dead, without reaching a clean consensus. In other words, the very community that invented these practices still argues today about how much rigor is enough.

What I'm saying is simpler than that whole debate: whatever your testing rigor level is, an LLM reviewing your diff before merge is fast, and reverting a bad deploy became trivial with containers and git. The math that's left is: how much time do you spend holding back code, versus how much time it would take to revert if it went wrong? If the second number is smaller, you're paying a toll for fear, not for prudence.

## This Isn't "Ship Anything"

And here I need to be very direct, because this is the part that always gets lost: I'm not saying to deploy with zero engineering practice underneath. I'm saying the opposite. This is only safe **after** you already have basic software engineering working, which I document exhaustively on this blog for years: automated tests, CI running on every push, real revert capability, observability to know when something broke.

> 80/20. Ask the LLM to do a minimal review and ship it. If it breaks, revert (that's what containers, git, etc. are for). If you can't revert, your infra sucks, go fix it yesterday.

That last sentence is the whole filter. If your infrastructure doesn't let you revert fast, the problem isn't deploy speed. It's your infrastructure, and it needs fixing before any conversation about going faster. Nobody gets a pass to skip having real rollback capability. What changes is that, once you have it, holding back code waiting on human review became pure waste.

## The Minimum Recommended Environment

I've already said "basic software engineering" several times in this piece without spelling out what that means in practice. Here's the list, no hedging. Nothing on it is optional, and none of it got expensive to maintain:

- unit tests covering isolated logic, TDD or not, as long as they exist;
- scenario and integration tests covering concurrency, partial failure, and conflict, the things unit tests alone don't catch;
- CI that builds and tests on every change, ideally for every platform you actually ship to;
- hostile automated review before merge, like `pr-audit`, which treats a contributor's claim as unverified until proven;
- feature flags to control the blast radius of who sees a change first;
- real staging as a gate before any real user sees the change;
- fast revert capability, with git and containers, and observability to know when something broke;
- in compliance, financial, or health environments, one extra layer: heavier scenario testing, and more than one lock per identified failure mode.

![Diagram of the minimum pipeline for fast, safe deploys: commit, automated tests, cross-platform CI, feature flag, staging, and production, with a rollback arrow looping from production back to tests and a feedback arrow looping from production back to commit](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/22/deploy-environment-diagram-en.png)

What the diagram tries to make clear is that speed and safety aren't competing with each other here. They come from the same stack of layers, and each layer in that stack is what gives you permission to stop holding back code waiting for manual review.

## Where This Math Doesn't Work Out

I'm not going to pretend I didn't get good pushback in the replies on X, because several of them hit on something real that I skipped while writing fast for Twitter. It's worth answering for real instead of just validating whoever agreed.

1. **Reverting code doesn't undo a consequence that already left your system.** If the bug already processed a wrong payment, moved money to the wrong account, or controlled an elevator, reverting the deploy doesn't undo what already happened. "If you can't revert, your infra sucks" covers the technical side of deploy and rollback, not the case where the damage already left your system before you could react. Payments, health, and anything touching physical safety fall into this category, and there the review bar before shipping has to get stricter, not looser, because the cost of reverting stopped being technical.

2. **Databases break the "reverting is easy" analogy.** Reverting a binary is trivial. Reverting a migration that already ran in production, already moved data, and maybe already dropped a column, is not. There's a pattern for this, *expand-contract*: add the new shape without removing the old one, wait for every consumer to migrate, only then remove the old one. This isn't about trusting AI more or less. It's about state that doesn't undo with `git revert`.

3. **Libraries and public packages don't run on the same math as a closed application.** When my own code breaks, I fix it on the spot. When a lib that hundreds of projects depend on breaks, the people who eat the cost are people who don't even know I exist, with a much slower reaction time than mine. That's why my `pr-audit` skill, which I describe further below, treats semver classification as a version gate: a breaking change ships in a major, never in a patch, because there the real review isn't about catching a bug, it's about not blindsiding whoever depends on you without warning.

4. **App stores knock the speed down too**, and my own frank_yomik example hides that instead of solving it. It publishes the APK straight as a GitHub Release, without going through the Play Store. If you distribute through Google's or Apple's official store, their review sits in the middle of your process, and you don't control how long it takes. This article is about removing the bottleneck that's inside your own control. The app store isn't inside it.

5. **The most honest point of all: every piece of evidence I bring here comes from projects where I'm the sole owner and I decide alone.** I have no way to prove, with my own numbers, that the same pace works inside a large company, with Legal, Compliance, and a product manager in the middle. What I'd argue generalizes is the principle, not the exact pace: build real revert capability, automate the mechanical checking, and measure the result against real usage, not against your own sense of security. How much speed you apply on top of that depends on how much a mistake costs in your specific context, and nobody from outside answers that for you.

On the first point specifically, it's worth opening up more, because "stricter bar" can't stay vague. It means real scenario testing, not just unit tests. ai-memory itself has more than a thousand integration tests spread across its modules, and most of them don't ask "does this function return the right value?" They ask things like:

- what happens when two writes race for the same file at the same time;
- what happens when the disk fails mid-way through a delete operation;
- what happens when two sessions try to consolidate the same data at the same time;
- what happens when the process dies before it finishes writing.

An environment with compliance, financial, or health requirements needs this level of testing: every identified failure mode has to have a mitigation, and more than one layer of checking, never a single lock.

And here's the point that holds up this article's entire argument even in those environments: this bar doesn't change depending on who wrote the code. A human developer's mistake takes down a payment system just as well as an LLM's mistake does, and nobody gets a free pass for loose review just because a senior human wrote the line. The bar of scenario testing and double-layer protection is about the problem domain, not about who, or what, produced the code.

Feature flags and staging environments are the other half of that double layer, and they also changed cost. Flags used to be a pain to maintain: dozens of them, each one needing to be born, monitored, and removed once it stops making sense, and it's easy to pile up dead flags nobody remembers the purpose of. That got cheap too: I ask the agent to audit every flag in the project, find which ones have been stuck at the same value for months, and generate the cleanup PR. Maintenance that used to take a whole afternoon turns into a task that takes minutes.

With that solved, the layered defense becomes simple to assemble: staging to catch obvious errors before any user sees them, feature flags to limit the blast radius of who sees the change first, and scenario tests to cover what staging alone doesn't simulate. Three layers, none of them expensive to maintain.

## How I've Been Doing This Since February

I started accelerating my output with AI in February this year, and the question I wanted to answer was simple: can you use the new generation of frontier LLMs to code full-time, at real production pace, not just for a demo? The answer turned into my [biggest LLM benchmark](/en/2026/09/15/new-llm-benchmark-v4-retesting-all-top-llms-part-1/), more than 110 articles published since then, and this, as I [wrote recently](https://x.com/AkitaOnRails/status/2102176881139138806):

> Since February I've produced more than 110 articles on my blog. Most of it came from the 30+ open source projects I built and maintain (43 if you count other people's contributing projects, like Flea or Omarchy). 1.6 million lines of code produced. By myself (with agents, of course).

The projects I use the most in my own day to day, and that survived the "am I still maintaining this months later" test, are three:

- [ai-jail](https://aijail.io): an OS sandbox for my coding agents;
- [ai-memory](https://aimemorybr.netlify.app): long-term memory for the agents;
- ai-usagebar: a bar widget to monitor LLM usage.

Two of them already have a decent landing page:

![ai-jail's landing page, an operating system sandbox for AI agents](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/22/aijail-hero.png)

ai-jail went live today. ai-memory is up at [aimemorybr.netlify.app](https://aimemorybr.netlify.app) because the `aimemory.io` domain transfer will still take a few more days.

![ai-memory's landing page, a long-term memory system for coding agents](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/22/aimemory-hero.png)

Both run on Netlify. That's not a tool recommendation, it's just where I already had an account set up. The point that matters here isn't the platform, it's the flow: to put a new version live, the command is `git push`. There's no manual step between the commit and the updated site.

My newsletter, [The M.Akita Chronicles](https://themakitachronicles.com), already has more than 15,000 subscribers:

![The M.Akita Chronicles newsletter's subscription page](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/22/themakitachronicles-hero.png)

And the newest effort is converting blog posts into podcast episodes. The whole thing runs inside Discord, with a bot that generates the preview and waits for my command:

![Discord bot announcing that a podcast episode preview is ready, with commands to publish, schedule, or reject it](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/22/discord-podcast-1.png)

One `/publish-podcast 2` later, the episode is published and the transcript already has a URL:

![Discord bot confirming that the podcast episode was published, with a link to the transcript](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/22/discord-podcast-2.png)

From finished text to published audio, the entire process is me typing a slash command in a Discord conversation. That's the effort bar I use to measure whether a process is good enough: if publishing takes more than one command, some step is still too manual.

## Cross-Platform CI/CD With Zero Effort

I went and counted how many of my `ai-*` and `frank-*` projects (18 repositories total, among the ones with a README) already have automated build and deploy. Fourteen have CI configured, and most of them build and publish to multiple operating system platforms from a push made on a Linux machine.

The most complete example is ai-memory itself: a single tag push triggers a workflow that, in the same run:

- builds Linux x86_64 and arm64;
- builds macOS arm64 and x86_64;
- builds Windows x86_64, packaged with PowerShell;
- publishes a multi-architecture Docker image;
- pushes the package to Arch Linux's AUR.

ai-usagebar follows the same build pattern for Linux and Windows, and also publishes two AUR packages, to crates.io, and to a Scoop bucket for Windows.

Then there's frank_yomik, my manga reader with OCR and translation via a local LLM, which is the example I wanted to show that Android fits into the same pipeline. A `v*` tag push triggers five parallel builds:

- Linux;
- macOS;
- Windows;
- browser extension;
- Android, on an ordinary Linux runner, decoding a signing keystore stored in GitHub secrets and producing the already-signed APK.

At the end, one job waits for all five to finish and publishes a single GitHub Release with every binary together. It builds for four different systems, including Android, without ever leaving Linux.

Not everything came out perfect on first look, and I'd rather admit that than pretend it's all clean: frank_sherlock and frank_karaoke publish the release as a draft by default, which blocks the automation that follows (like the AUR push) until someone clicks "publish" by hand. I found this hole while writing this piece.

A neighboring project, frank_scanlation, had already solved a similar but different problem: GitHub suppresses the event that triggers automation when the release itself was created by the bot's own token, so its workflow triggers the next step by hand, via `workflow_dispatch`, from inside the job itself. Neither fix is hard. I'll apply both to the projects that still need it this week, because that's exactly the kind of accumulated friction this whole article is telling you not to leave sitting.

And speaking of hidden friction: ai-memory has Windows-specific code (NTFS file index, a native PowerShell hook) that only really runs on GitHub's `windows-latest` runner, about 1000 seconds against 250 on Linux for the same suite. I went as far as setting up a local Windows VM via [dockur/windows](https://github.com/dockur/windows), thinking I'd gain speed.

I didn't: the workload is dominated by disk I/O, and the result came out slower than GitHub's runner for the full suite. It only turned out useful for fast iteration on a single isolated crate. A good tool is one you measure, not one you assume, even when the measurement contradicts your initial bet.

## The Automated Review That Holds All of This Up

I already [detailed my review skills](/en/2026/09/17/talking-about-my-ai-skills/) in a recent article, so I'll summarize here:

- `pr-audit` audits every PR before merge with the principle of **evidence over narrative**: nothing the contributor wrote is true until proven, with a hostile checklist for malicious code, exposed credentials, semver breaks, and prompt injection attempts;
- `iss-audit` applies the same distrust to issues, never executing a command pasted by whoever reported it;
- `github-resolution` turns what got approved into merged code, one ticket at a time, with a regression test written before the fix, and the rule that *"slop is a defect"*: no speculative abstraction, no forgotten TODO, no weakening a test just to pass faster.

That catches the most expensive category of garbage inside the same diff. It doesn't catch duplication spread across different PRs, because the audit looks at one isolated diff, not the whole project's architecture. That part still depends on me noticing the pattern repeating and telling it to consolidate.

By my estimate, this handles about 99% of review and resolution work on its own, with me supervising and deciding on the cases that are left. But that's not the main point. Automated review is necessary, but it alone proves nothing about whether the software is good.

## What Actually Keeps This Grounded: Real People Using It

Here's the part I think is the most important in the whole article, and the one that usually gets skipped over: your own review isn't worth as much as you think. What's worth something is published software being used by real people, giving real feedback.

I went and checked ai-memory's real numbers on GitHub, without rounding up to sound impressive:

- **issues: 287 total, 249 came from people who aren't me**, 86.8% of the total;
- **pull requests: 562 total, 371 from outside**, 10 of them Dependabot's automatic bumps and the other 361 from real people, roughly 121 distinct contributors.

The two people who contributed the most alongside me sent 64 and 43 PRs each, on their own.

That's what keeps the project grounded. It isn't the LLM being a good reviewer, nor me being a good reviewer. It's hundreds of real people actually using it, finding cases I never imagined, and sending real issues and PRs. Without that, my automated review skills would just be confirming my own assumptions back to me, no matter how rigorous the rules look on paper.

It doesn't matter how good the AI you use is: if nobody uses what you published, you have no real feedback, and without real feedback there's no real improvement. There's only your own opinion about your own work, validated by nobody but yourself.

## The Conclusion That Matters

Real software engineering **needs** fast, near-zero-effort deploy. It isn't optional, it isn't a luxury for a big team, it's a prerequisite. And if reviewing and shipping to production is taking longer than it took to develop the feature, you're not just wrong.

**You are the bottleneck.**

Excuses and justifications aren't worth anything at that point. Use that time to fix yourself and your process, because only real-world results matter, not the sense of security from having reviewed a diff line by line that nobody else is ever going to look at again.

If the premise changed, I change today. Not tomorrow, not next week. And if yours hasn't changed yet, the problem isn't AI. It's you holding back your own work.
