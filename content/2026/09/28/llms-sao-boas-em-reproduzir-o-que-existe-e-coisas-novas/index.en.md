---
title: "The Limits of LLMs: Good at Reproducing What Exists. Expensive for What Doesn't"
slug: "llms-are-good-at-reproducing-what-exists-what-about-new-things"
date: '2026-09-28T01:00:00-03:00'
draft: false
description: "Every LLM was trained only on what's public, but 81.5% of GitHub activity happens in private repositories, and the source code of every proprietary software never made it into training. In my retrocomputing projects I felt firsthand where the machine stalls: with no reference and no oracle, it spins in directed brute force."
tags:
- llms
- coding-agents
- retrocomputing
- software-engineering
translationKey: llms-reproduce-existing-what-about-new-things
---

Everyone has noticed by now that LLMs write CRUD with their eyes closed. Forms, reports, REST endpoints, unit tests: it comes out clean, it comes out fast. A lot of people conclude from this that programmers are done for.

I've been using LLMs for everything for almost two years, I've published dozens of projects with them, and my conclusion is different: what they do best is **reproduce what already exists**. And that covers a giant slice of corporate work, don't kid yourself. But there's a frontier they don't cross easily, and I spent the last few months bumping into it on purpose.

This article shows where that frontier sits, with evidence from my own projects and from the research that exists on the subject. And there's a hypothesis I'll put up front and defend along the way: if LLMs are so good at code, providers owe a huge debt to the decades of the open source community, which protected the freedom of code and published everything for free. Without that heritage, there would be no Copilot, no Cursor, no Claude Code, none of this.

A disclaimer before we start: what I'm going to argue here is speculative, based on observation and on the public data that exists. Nobody outside the labs knows exactly how each provider trains their own models, and that varies from provider to provider and from version to version. What holds today may not hold in the next generation. Take it all with a grain of salt.

## The Training Blind Spot

Every LLM was trained on what's public. The entire public internet, and for code, public GitHub. The canonical open code dataset, BigCode's [The Stack v2](https://huggingface.co/datasets/bigcode/the-stack-v2), is explicit about this: it's derived from Software Heritage, an archive of *"the source code of all publicly available software"*. That's 67.5 TB, 3.28 billion unique files, 104.2 million repositories. Huge. And all public.

Now look at the other side. The [Octoverse 2025](https://github.blog/news-insights/octoverse/octoverse-a-new-developer-joins-github-every-second-as-ai-leads-typescript-to-1/), GitHub's official report, says **81.5% of contributions on the platform happened in private repositories**. That's just GitHub. Outside of it there's:

- the internal code of every company that never touched a public server;
- the source of every proprietary software;
- the code of every commercial game;
- and that of every embedded system.

None of that ever went into training.

Think about what this means: the model deeply knows what the world has already published, and it's blind to what the world keeps closed. When you ask for a React form, it's reproducing patterns it has seen millions of times. When you ask for something nobody has ever done in public, it's operating in territory where its map is blank.

## Why Is Everyone Shipping So Much, So Fast?

Before getting into the limits, it's worth recording the side that works, because it's what explains the feeling that everyone became an app factory.

Look at what's popping up in the community: [Spotifast](https://github.com/crmne/spotifast) and [ZapFast](https://github.com/crmne/zapfast), native Spotify and WhatsApp clients written in Rust by a single person, running on Linux, macOS, and Windows. Nothing in them is new technology. It's the service that already existed, wrapped in a lean native app, on top of libraries that already existed, doing what the official teams always could have done but never wanted to spend their time on. That work got cheap, because an LLM trained on everything public is really good precisely at this: replicating.

My own projects follow the same pattern. [FrankMD](https://github.com/akitaonrails/FrankMD) is a Markdown note-taking web app with a Visual Studio look and features that already existed in my other apps. [Frank Sherlock](https://github.com/akitaonrails/FrankSherlock) is a local image organizer that, deep down, is a file manager with thumbnails and search, something that exists by the dozen. Neither invents anything: they're mashups of known pieces, assembled the way I always wanted. The LLM does the boring part, and that's where the speed comes from.

The most didactic example is my email client. I've used Geary for years, and two small gaps always annoyed me: the weak recipient autocomplete and a sidebar I wanted to hide. Trivial stuff, which never justified setting up a build environment, learning the project's toolchain, and studying the code just for two features. This year I finally solved both: an [autocomplete module](https://github.com/akitaonrails/geary-email-autocomplete), a [module to hide the sidebar](https://github.com/akitaonrails/geary-hide-sidebar-module), and a [whole fork with my patches](https://github.com/akitaonrails/frank_geary). I became the maintainer of improvements I had postponed for years, not because I got faster, but because the boring part got cheap.

Notice what all these cases have in common: the problem had already been solved before, somewhere else, some other way. The map existed; what didn't exist was cheap labor to retrace the path. That's reproduction working in our favor, and it's why your feed is full of people shipping a new app every week.

Now hold that thought. The rest of this article is about what happens when the map runs out.

## Four Home Experiments

I'm not theorizing. Over the last few months I ran a marathon of retrocomputing projects that are exactly the pathological case: working with proprietary software from 30 or 40 years ago whose source code was never public. It's the perfect blind spot.

### nes-to-sms: the project I gave up on

[nes-to-sms](https://github.com/akitaonrails/nes-to-sms) is a static recompiler from NES to Master System. The idea: take the binary ROM of a NES game, translate it instruction by instruction from 6502 to Z80, convert the tiles, and generate a Master System ROM that runs on real hardware. Forget emulator or manual port: this is a machine that turns one game into another.

Static NES recompilers exist, [NESRecomp](https://github.com/mstan/nesrecomp) translates to C and runs natively on PC, and I studied it closely. But crossing from one console to another 8-bit console, with a completely different clock and VDP budget, nobody has ever done. There's no public reference, no paper, no abandoned project to copy.

The project numbers: **349 commits, 31 active days spread over almost 4 months, ~110 thousand lines of engine in Rust and Z80, 668 tests passing in the last run recorded in the README**. And the result? Playable Super Mario Bros. (slow, limited audio, but playable), with a byte-for-byte identical RAM trajectory to the NES on [one ~4,900-frame route](https://github.com/akitaonrails/nes-to-sms/blob/master/docs/completion-plan.md) (the diff leaves out audio and part of the VRAM buffer). Castlevania playable on stage 1. SMB3 rendering. And a queue of games that boot three frames and die.

And it wasn't for lack of pushing the models. In this project alone:

- **four generations of Claude** went through it (Opus 4.7, Fable 5, Opus 4.8, Fable 5.1), with 213 co-signed commits and 104 commits linked to sessions in the history, plus Codex sessions in the stretches without co-authorship, complete with documented handoffs between agents;
- there was even cross-generation auditing: a new agent session [reviewed the previous 55 commits](https://github.com/akitaonrails/nes-to-sms/blob/master/docs/mapper-continuation-review.md) and reverted conclusions the previous generation had overclaimed;
- the Castlevania crash hunt alone consumed 45 commits in 5 days;
- the final September sprint was 176 commits in 17 days before I called the pause;
- and the regressions are registered by name in the history: *"H.7 tried and reverted"*, *"record the reverted map-bank-hold attempt"*, *"correct-but-reverted result"*, plus three shared-lever hypotheses tested and rejected in the project's last three days.

I didn't measure tokens reliably in this project, so I won't make up a number. But 349 commits with 668 tests holding up every step already give an idea of the cost.

Notice the detail that matters: the only game that actually got finished is Super Mario Bros. Why? Because SMB is the most dissected game in history. There's a [complete public disassembly](https://gist.github.com/1wErt3r/4048722) the community has used for over a decade, with every function named and commented. I fed that into the game's profile and the LLM had a complete map to work with. For the other games, there's no map. And without a map, each new game died a few frames after boot from control flow divergence, and each one demanded an instruction-by-instruction forensic hunt that carried nothing over to the next game.

The project itself documented the spinning pattern. There was an entire optimization campaign that lasted weeks trying to cut the cost of emulating 6502 flags on the Z80.

Then in September I stopped to compare with the [manual port of SMB to Master System made by a hacker named lackoftrack27](https://github.com/lackoftrack27/Super-Mario-Bros.-SMS), written by a human, routine by routine. According to [the analysis we did of his code](https://github.com/akitaonrails/nes-to-sms/blob/master/docs/handport-comparison.md), the human port runs inside the frame budget, with headroom we estimated at ~90% utilization. My machine, after months of optimization, still needed overclocking.

And the analysis document pinned down why: when we removed 30% of the flag emulation calls, the timing barely moved.

> **The flags were never the bottleneck.**

The right optimization was to redesign the data structure: transposing the object array into RAM pages. It's a trick that depends on knowing that "the X register here is always an object index."

That invariant exists in the head of the programmer who wrote the game in 1985. It doesn't exist in the instruction stream. A static translator has no way to discover it. And the LLM, for months, didn't discover it.

The pause banner I wrote in the README is blunt: real-hardware parity "may be fundamentally unattainable" and, quoting, *"this may be a limit of the current frontier coding models as much as of the approach"*.

### gg-to-sms: the pivot to mapped territory

The same day I paused nes-to-sms, I started gg-to-sms: converting Game Gear games to Master System with a widened screen. The difference that matters is that this problem **is not new**. The romhacking scene has been converting GG games to SMS by hand for twenty years, and the catalog I built in the project counted ~186 of them. Meaning: there's a corpus, there's ground truth, there's a pattern to learn.

Result: in one day of work,

- the research phase was complete;
- the catalog of the 373 GG games was assembled;
- the patch-point scanner was validated against real human patches, hitting addresses within an 8-byte margin;
- and on top of that the tool found real bugs in twenty-year-old patches that the entire scene had never noticed.

The model was the same; what changed was the problem, which this time has references.

And even so: so far, zero games have passed the viewport acceptance review. The new part of the project (the machine that generates the patches on its own, which is the part nobody has ever done) remains undone.

### super-mario-deluxe-fixed: four days and 436 million tokens

This one was a 4-day sprint, practically a single Codex session that consumed **436 million input tokens**. The goal: run Super Mario Bros. Deluxe for Game Boy Color with a widened screen at NES resolution, something no existing tool does with live sprites.

It got to playable in 4 days. But look at the foundation: a ready-made emulator vendored as a dependency, and a dormant disassembly of the game that someone had published years earlier, which the project's own documentation calls "the most important artifact."

The new work was the custom renderer, and it stopped at 21 of 32 stages completed. The missing ones hang on moving-platform timing. The project has been stalled mid-sprint since then, and I haven't given up on it yet.

And one detail that says a lot: I had to direct QA by looking at screenshots, because the agent would deliver things with graphical glitches and not notice on its own.

### super-mario-bros-35: everything that worked had an owner

This is the offline clone of Super Mario Bros. 35, the battle royale Nintendo took offline. What worked in it: everything built on top of an existing artifact.

- The engine is a C reconstruction made by someone else with Ghidra.
- The AI's initial weights came from published checkpoints.
- The network rules were inferred from a public reverse engineering of the netcode.
- Even the physics: the central bug was diagnosed because I had a recorded reference trajectory to compare frame by frame.

What didn't work: the maze castle stages. Reinforcement training stalls on them. 46 million agent steps, training restarted from scratch, anti-loop reward, and in the end the only thing that solved one of the stages was manual bias surgery on the trained model. Out of 32 stages, 19 cleared. The worst ones remain stuck.

And the process degenerated into a pattern I recognize from all these projects: when training doesn't solve it, the flow becomes checkpoint-selection roulette, dozens of bias and output-head variations, throwing permutation and computation at the problem in place of a principled fix.

## The Pattern I Keep Seeing

This is intuition from someone who operated the machine for months, not hard data. But the pattern repeats with Claude, with GPT, with Kimi, with GLM, so it doesn't look like a defect of one model.

The beginning of any project is wonderful. The first milestones fly, because scaffolding the structure, writing harnesses, replicating APIs, all of that is covered territory. Then the project reaches the part nobody has ever done, and the speed collapses. The agent starts spinning: tries a hypothesis, regresses something else, reverts, tries again. The nes-to-sms commit history is full of honest messages like "attempt reverted" and "hypothesis closed with correct result but reverted." Lots of tokens burned, little progress.

> My reading of what happens inside: token sampling is probabilistic. When the problem resembles the training data, the right tokens have high probability and the answer comes out straight. When the problem is unprecedented, the probability of the right path is low, and the process becomes **directed brute force**: guided trial and error, but trial and error all the same.

The way out I found for this spinning is always the same: give it an oracle. If I can define "the result has to equal X" (a reference image, a recorded trajectory, a cycle-accurate emulator as ground truth), the machine can iterate until it hits X. In nes-to-sms, every real unlock came from that: the SMB disassembly, the frame diff, the reference emulator. When I can't define X properly, it spins indefinitely.

The second strategy that works: hunt down an abandoned project, a paper, any material the model never saw but that brings the problem closer, and shove it into the context. That warms up the distribution and improves the result a lot. But it's limited: if nothing similar exists, there's nothing to feed it.

## More Than Anecdote: What the Research Measures

The good part is I don't have to rely on my intuition. There's serious research measuring exactly this.

Apple's [GSM-Symbolic study](https://arxiv.org/abs/2410.05229) took benchmark math problems and did two simple things: swapped only the numbers, and then added a single irrelevant sentence to the problem statement. Result: performance drops just from swapping the numbers, and plummets **up to 65%** with the irrelevant sentence. The authors' hypothesis, in the text: *"current LLMs cannot perform genuine logical reasoning; they replicate reasoning steps from their training data."*

Scale AI's [GSM1k](https://arxiv.org/abs/2405.00332) created a mirror of GSM8K written from scratch by humans, guaranteed contamination-free, and saw drops of up to 8% across several model families, with signs of systematic overfitting in the worst ones. To be fair to the paper: the authors say frontier models show minimal signs of overfitting and that all of them generalize to some extent to new problems. The signal exists; its size is debatable.

[LiveCodeBench](https://arxiv.org/abs/2403.07974) ran the cleanest test of all: evaluating on coding problems published **after** the training cutoff. Inflated performance on pre-cutoff problems and drops on post-cutoff problems across several popular models, the classic contamination signal.

And there's [ARC-AGI](https://arcprize.org/), François Chollet's benchmark designed specifically to be memorization-proof: every task is unprecedented, nothing similar exists in training. On ARC-AGI-2, released in March 2025, the official leaderboard says: **pure LLMs score 0%**, reasoning systems sit in single digits, and every evaluation task was solved by at least two humans within two attempts. Chollet, by the way, summed up my thesis better than I did, back in February 2024:

> "Reality is that LLMs are not AGI — they're a big curve fit to a very large dataset. They work via memorization and interpolation. But that interpolative curve can be tremendously useful, if you want to automate a known task that's a match for its training data distribution. Memorization works, as long as you don't need to adapt to novelty."

In the real world, the study that impressed me most was the [METR RCT](https://arxiv.org/abs/2507.09089): 16 experienced developers, 246 real tasks on their own mature repositories, randomized with and without AI. The devs bet AI would speed them up by 24%. Measured: **it was 19% slower**. Notice where this happened: mature, private code, full of context the model never saw. Exactly the blind spot.

And the industry's favorite benchmark for saying "AI already does software engineering," SWE-bench, is Python-only, 12 famous open source repositories, in other words the most covered slice of training. The industry's success metric measures mapped territory.

Even the legacy code literature says the same thing: a [2026 paper on LLMs generating COBOL](https://arxiv.org/abs/2604.03986) states that, in these legacy languages, *"most production code resides in enterprise systems and is rarely publicly available"*. It's this article's thesis, said by other people.

## The Steelman: Directed Brute Force Works, at a Steep Price

Before wrapping up, it's worth facing the strongest argument against me. That's what steelman means, for anyone unfamiliar with the term: the opposite of a strawman. Instead of attacking the weakest version of the opposing argument, you answer the strongest version it can have. And it exists, and it's a good one.

In May 2025 DeepMind published [AlphaEvolve](https://deepmind.google/discover/blog/alphaevolve-a-gemini-powered-coding-agent-for-designing-advanced-algorithms/): a system that found an algorithm for multiplying 4x4 complex matrices with 48 scalar multiplications, beating Strassen's 1969 record in that specific scenario. On a list of more than 50 open math problems, it rediscovered the state of the art in ~75% of cases and improved the best known solution in 20%. That's real novelty, not reproduction.

OpenAI's o3-preview jumped to 75.7% on ARC-AGI-1 in December 2024, 22 points above the previous best result on the same evaluation set, and the high-compute configuration reached 87.5% at an estimated cost of $4,560 per task.

And back in 2016 AlphaGo played move 37 against Lee Sedol, a move that DeepMind's own data estimated had a 1 in 10,000 chance of being played by a human, proving that search over a model can transcend imitation.

Now look at the mechanism of the three:

- AlphaEvolve is an evolutionary loop: the LLM proposes mutations, an automatic evaluator scores them, selection iterates.
- o3 does program synthesis at test time, exploring the solution space.
- AlphaGo is tree search over reinforcement learning.

If there was any "insight" in any of them, it came from the search system around the model: all three are **directed brute force with a cheap verifier**, the same mechanism I described happening in my projects. The difference is that DeepMind has a perfect oracle and an infinite budget: in the configuration that reached 87.5%, o3-preview spent thousands of dollars per ARC task to do what a human does for free. The ARC Prize itself wrote the caveat:

> *"We know that brute-force search could eventually solve ARC-AGI (given unlimited resources and time to search). This would not represent true intelligence."*

In short: novelty comes out, but it comes out through expensive search over an oracle, on the basis of guided trial and error. If your problem has a cheap verifier and you have tokens to burn, you can go far. That's how nes-to-sms got where it got: 668 tests and emulator ground truth holding up every step. But when there's no oracle, no corpus, and no reference, you're paying for brute force in dollars, with regressions along the way, and the ceiling shows up.

And when brute force wins, you can measure the size of the trial and error. Two recent cases I already covered [in detail here on the blog](/en/2026/09/09/propagandas-enganosas-da-openai-anthropic-nvidia/):

- **OpenAI's Navier-Stokes proof:** about 10 thousand agents running in parallel for 88 hours, burning around **130 billion output tokens** on a single problem. OpenAI's Noam Brown confirmed the result "cost millions," and [New Scientist estimated some $15 million at list price](https://www.newscientist.com/article/2588063-openai-has-solved-the-navier-stokes-millennium-problem-using-15m-of-ai-effort/). And even that mountain of compute didn't start from zero: the proof leaned on the machinery human mathematicians published over decades attacking the problem and its sibling problems. Without the humans' map and without OpenAI's budget, there's no proof.
- **The Hugging Face incident:** the forensic reconstruction counted **~17,600 attacker actions** before the agents managed to execute code on 41 Hugging Face production servers and get root; on top of that, inside OpenAI's own environment, they read 956 secrets from the company's secrets manager. It wasn't one brilliant single-strike insight: it was a swarm executing attempt after attempt, with automatic verification saying what stuck. The headline's "intelligence" is volume.

That's the size of the bill when you force the model outside training territory: trial and error at industrial scale, with no guarantee the search finds what you need. And who can sign that check is half a dozen companies in the world, OpenAI and Anthropic level, with a practically unlimited compute budget. For the average Joe, with a credit card and an API key, the ceiling arrives much, much earlier.

## Where This Leaves the Profession

The question that motivated this article is the one I hear every week: "will LLMs replace programmers?" My answer got more precise after these months: **they will replace the part of the work that is reproduction**.

And that part is big. Forms, reports, CRUD, integration with documented APIs, framework migration: all of that already exists a thousand times in training, and the machine reproduces it better than most humans. Anyone who only does that really is living on borrowed time.

But the work that is genuinely new stays human:

- the system nobody has built;
- the domain without documentation;
- the proprietary code you can't show the model;
- the problem where you don't even know how to write the test that defines "right".

All of that depends on what was never published: the invariant that exists in the head of whoever understands the problem, and not in the instruction stream.

I confess there was a moment when I thought the bill would close on the legacy side: finally a tool capable of dealing with the COBOL that haunts banks and governments to this day. After these months, I think that problem will take much longer than it seemed. There's no giant COBOL open source community. Almost all of that code is private, and truly private: banks, insurers, governments. There's no training material, or very little of it. The model doesn't know what to do with code it has never seen, and production COBOL is almost entirely code it has never seen.

To close the reasoning: **LLMs can replicate what's open, but they can't guess what's private.** And that brings back the hypothesis from the introduction. If these models are good at code, it's because decades of open source community fought to keep code free, public, and reusable, and providers trained on top of that heritage without paying a cent of licensing for it. The least the AI industry owes the world is to acknowledge that: its capability is, to a large extent, our generosity compiled.

The final irony: the programmer who survives is precisely the one who knows how to build oracles, define tests, hunt down obscure references, and recognize when the agent started spinning. In other words, the skill the machine needs most from you is the one it can least learn from its training. For now, that's not a threatened job. It's a different job.
