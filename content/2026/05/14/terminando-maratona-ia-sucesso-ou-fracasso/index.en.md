---
title: "Wrapping Up My AI Marathon: Success or Failure?"
date: '2026-05-14T14:00:00-03:00'
draft: false
translationKey: terminando-maratona-ia-sucesso-ou-fracasso
slug: wrapping-up-my-ai-marathon-success-or-failure
description: "After more than 500 hours across 24 repositories, Akita ranks his experiments and concludes Codex and Claude Code support daily coding, but without review and XP, productivity turns into slop."
tags:
- vibe-coding
- coding-agents
- software-engineering
---

I think I'm finally out of my AI hyperfocus. When I started ramping up in February and kept going until almost May, the goal was to answer one simple question: can you actually use this new generation of frontier LLMs from Anthropic and OpenAI to code 100% of the time? Short answer: yes.

Instead of doing a one-day demo and risking a "yeah I think so," I went all-in: over 500 hours, almost half a million lines of code and documentation, 24 repositories between public and private.

But today someone flagged a point I never thought would need defending:

> "Are all 24 projects perfect, models of code excellence?" — **ABSOLUTELY NOT.**

I thought that was obvious. For starters, if I believed any of them was that good, I'd be spinning up a startup around it. I don't lack capital to invest. If I'm not doing that, clearly all of this is at hobby pace.

Second obvious point: if I'm jumping between projects every few days, it's because I lost interest. If I really liked it, I'd still be tuning it today. I keep saying it in the videos — software never "finishes". The moment it stops moving, it dies.

The goal was to test different kinds of projects to see how the LLMs handled each. That's why there's stuff in Ruby on Rails, Rust, Go, Python, Crystal. Plus frameworks like Tauri and Flutter. I figured, for instance, that Flutter being super popular would mean the LLMs wouldn't struggle. They did. They could move forward, just not as smoothly as in Rails. Tauri was "rough" too. Crystal was REALLY rough.

Third point: every experimental project got named "Frank". Sarcasm, obviously. I don't have the patience to invent a pretty name for a project I already know is going to be one-off.

I use my GitHub basically as a repository of exercises and experiments. Look at all the old repos: barely any are a "real" project I want to maintain. I do what I've been preaching in the videos: to actually learn, you exercise on MANY projects, even if most of them are meant to be THROWN AWAY. Nobody learns by trying to build a single perfect project. Check out my videos [A Dor de Aprender](/2020/05/15/a-dor-de-aprender/) or [Guia Definitivo de Aprendendo a Aprender](/2020/05/16/guia-definitivo-de-aprendendo-a-aprender/) (Portuguese).

In the middle of a bunch of half-baked projects, some naturally emerge as the ones I like and maintain. In practice I threw them all at the wall to see what stuck. The good ones naturally pulled in more contributors too. I don't keep an eye on Issues and PRs every day. I check once a week. Two or three days ago I made a sweep and cleared everything that was pending, for example. Even on projects I don't care much about, if a PR shows up, I review and accept it. It wasn't useful to me, but it can be useful to someone else.

## The project ranking

To make it clear, here's a ranking of the projects with a comment on each. The PR counts below are non-dependabot (gem bumps don't count). The score is my estimate of "how stable and usable is this thing in its current state."

### Top tier (7-8/10)

**[ai-jail](https://github.com/akitaonrails/ai-jail) — 8/10.** The only one really close to a stable 1.0 release. Got the most traction: 19 PRs closed, 23 Issues resolved. Recommend using, it works very well.

**akitando-news (the M.Akita Chronicles) — 8/10.** The one I built with the most care, in the "Agile Vibe Coding" mode I described a few posts back. And the one I touch most often. There's always some little thing to tweak, stuff I keep adding, removing, experimenting with. Which is why it's been shipping every week. Also why: it's closed and I don't plan to open it.

**[akitaonrails.github.io](https://github.com/akitaonrails/akitaonrails.github.io) — 7/10.** This is the blog you're reading. I touch it often and I've already closed about 7 Issues and 30 PRs from contributors. I'll keep tuning it bit by bit.

**[FrankMD](https://github.com/akitaonrails/FrankMD) — 7/10.** One of the first ones I built, with no criteria at all: I just wanted an editor with automatic image upload to my S3. These days I use Claude Code to edit posts, so the only people using it are the people contributing to it. Got solid traction, I closed 17 PRs and 29 Issues. It's not perfect, but it's good enough to use — at least it's been tested enough.

**[easy-ffmpeg](https://github.com/akitaonrails/easy-ffmpeg) — 7/10.** Tiny little project, but I actually use it in the videos. My OBS always records in MKV and when I want to share I convert to MP4. Small use cases like that. Good enough to use.

### Middle tier (5/10)

**[distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming) — 5/10.** Most recent one, serves as a "dump" of documentation for my retro games. I use it as a notepad and it's been working fine for my setup. Not worried about it working for anyone else. If anyone wants to send PRs, go ahead.

**[llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark) — 5/10.** This one doesn't run on its own. I have Claude Code execute it. The goal is to tabulate data so I can write articles about new LLMs. The code has to be REALLY rough.

**[FrankMega](https://github.com/akitaonrails/FrankMega) — 5/10.** The closest thing to a "todo list" exercise. I just needed to share a big file with a friend and thought "hmm, I bet I can build a mini-Mega in 1 day". And that was it. The name is a joke, obviously — this is nowhere near the actual Mega.

**[distrobox-llm](https://github.com/akitaonrails/distrobox-llm) — 5/10.** More personal organization on my PC: I wanted to isolate the AI tooling into a distrobox so I wouldn't have to keep updating big packages on the main system.

### Lower tier (3-4/10)

**[FrankYomik](https://github.com/akitaonrails/FrankYomik) — 4/10.** This was an idea I'd had in my head for years. I just wanted to see if the concept worked. It works. But running local LLMs for it is slow and not as practical as I'd like. It's the only one I might come back to, because I actually want to use it. As-is, it's in "works, sort of" territory.

**[NW-Omarchy](https://github.com/akitaonrails/NW-Omarchy) — 4/10.** Another "let's see if this works" experiment, lasted 2 days. The concept worked, but I don't plan to do much more than that. Up for grabs if anyone wants to take it further. The real test I wanted to run was whether X11 would be MUCH worse than Wayland. The gap turned out smaller than I expected, but I don't see myself using it day-to-day. Like I've said: for the niche of people who can't use Wayland, it's a decent alternative.

**[frank_investigator](https://github.com/akitaonrails/frank_investigator) — 3/10.** Started it, didn't have the patience to keep going. Planted the seeds of the idea. If nobody sends PRs, it's not going to evolve much. Needs more research and a lot more testing.

**[frank_fbi](https://github.com/akitaonrails/frank_fbi) — 3/10.** Another concept test, no personal use case (I never fall for phishing). No idea where this would go yet.

**[frank_karaoke](https://github.com/akitaonrails/frank_karaoke) — 3/10.** Born from a weekend conversation with my brothers. Another shot at using Flutter (and seeing the limits, both of Flutter and of LLMs writing Flutter). Useful for me to learn about the karaoke ecosystem and find out that real scoring only works with per-song metadata. So I didn't push it past toy territory.

### Bottom of the barrel (1-2/10)

**[FrankSherlock](https://github.com/akitaonrails/FrankSherlock) — 2/10.** I don't use it myself. So it's probably full of bugs that nobody's fixed. It was a test to see if I could build a Tauri app, but I lost interest fast. There's room to make it better, but it'd take a lot more hours of actual use, testing, and fixes. It was also my first time touching Tauri, so that part is probably pretty rough too.

**[FrankClaw](https://github.com/akitaonrails/FrankClaw) — 1/10.** I don't use it, and this is the only one I haven't even run a single time. The exercise was just to see how hard it'd be to port the original openclaw from TypeScript to Rust. But as I've said many times, I don't see any use for openclaw in my own workflow. When I finished version 0.1, I stopped. Even so, there were 6 PRs I closed. If anyone's interested, feel free to contribute.

**[shadPS4](https://github.com/akitaonrails/shadPS4) — 1/10.** Despite generating a lot of code and a lot of documentation, none of it was meant to be a real contribution. Pure learning, plus solving one very specific problem. I left it open just to show what "study-material" code looks like.

**[easy-subtitle](https://github.com/akitaonrails/easy-subtitle) — 1/10.** Started it, lost interest, never actually tested it. Just pushed it and forgot.

### The private ones

Beyond akitando-news, I have stuff on my private Gitea like `my-omarchy-config`, `emulators-reorg-2026`, `thinkpad-omarchy-config`, `homelab-docs`, `akitando_english_translation`, etc. I'm not going to describe them because you're never going to see them. They serve as "scratchpads" for Claude Code to administer my machines.

## What this ranking actually says

Notice: there's no project on this list that I think is 10/10.

For a project to graduate from hobby to real project, you need users and feedback. If nobody uses it, there are always dozens of functional bugs nobody's stumbled on, so nothing ever gets fixed. A project with no users is a dead project.

That's why I keep saying in the videos: there's no such thing as planning every detail, writing a pile of code, and one day "finishing". Nope. When you think you've "finished," what you actually have is version 0.1. Then comes months of experimentation with real users reporting bugs. You go fixing. Out of those fixes come refactors, architecture changes because your initial assumptions were wrong against actual use. Software NEVER finishes.

## What I took out of this marathon

16 hours a day, every day, vibe coding, the output is always going to have slop in it. There's no way around it. Forcing volume doesn't fix it. You have to review manually, commit by commit, PR by PR. Why didn't I do that on all of them? Simple: nobody's paying me. I did it on 2 or 3 projects. The rest I just wanted to test the concept and move on to the next one.

The right way is what I reported a few posts ago: "Agile" Vibe Coding. That's my sarcastic way of saying "use XP and normal software engineering practices". Metrics, monitoring, CI, the whole nine yards. None of that changed. Without it, you'll end up like a lot of my exercises: one-offs to throw away.

Don't be embarrassed to push "bad" projects. What I didn't anticipate is that some people assume just because I pushed code, I think it's perfect. But that's projection: they only push code they consider great, which is why they never push anything. I've said this MANY times and I demonstrate it: I don't care about my code, I have no preciousness about my code, GitHub is a temp dump directory for whatever. The ones I really like usually live private.

If a project is really good, don't just say it. Put your money where your mouth is: build a business around it, charge users, deliver quality. I'm retired, I don't need to charge anyone, but I also have no interest in working for free. The moment the code stops being fun, I drop it and move on. The ones I actually got hooked on (ai-jail, M.Akita Chronicles) I keep touching more often. That simple.

As I expected, and as I showed both in these little projects and in the benchmark, the choice is simple: use GPT Codex or Claude Code on one of the subsidized plans. Don't pay per token. That's where the 5x productivity lives (max 10x, with slop along for the ride). Yes, there's Kimi v2.6 or DeepSeek V4 Pro. But I'll save you the trip: the projects I scored below 5 here would quickly become projects below 2 with those.

## The point that matters most

AI doesn't replace a good programmer. AI mirrors and accelerates who you are. If you're a good programmer, AI accelerates good code. If you're a bad programmer, AI accelerates bad code.

That's exactly what I showed: most of the projects I built were one-offs and proof-of-concept tests. Bad code, with no interest from me to keep going. AI accelerated me finishing those tests in a half-baked way. Which is fine by me: without AI I never would've started. Now that I've seen what they look like, I can cross them off my list and move on.

What matters is your OBJECTIVE. If yours is to build a business and charge people, you have to do it with 10x more care than I did. Everything I do is meant to be thrown away. I don't need to make money on any of these projects. Don't assume things I never said.
