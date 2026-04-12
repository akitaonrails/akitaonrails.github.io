---
title: "Software Is Never 'Done' — 4 Projects, Life After Deploy, and Why One-Shot Prompting Is a Myth"
slug: "software-is-never-done-4-projects-life-after-deploy-one-shot-prompt-myth"
date: 2026-03-01T12:00:00-03:00
draft: false
tags:
- off-topic
- themakitachronicles
- frankmd
- franksherlock
- frankmega
- agile
- xp
- extremeprogramming
  - AI
translationKey: software-never-done
description: "125 post-production commits across 4 projects in 10 days. Real bugs, real users, real iteration. Why one-shot prompting is a myth and software is never 'done'."
---

And don't forget to subscribe to my newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

I published the "final post" of the [Behind The M.Akita Chronicles](/en/2026/02/20/zero-to-post-production-in-1-week-using-ai-on-real-projects-behind-the-m-akita-chronicles/) series 10 days ago. 274 commits, 1,323 tests, deployed to production. I wrote down the lessons, did the conclusion, dropped the quote at the end. Done.

125 post-production commits later, I can confirm: **software *"done"* doesn't exist.**

Today the M.Akita Chronicles repo has 335 commits and 1,422 tests. Tomorrow, Monday, subscribers get the 3rd consecutive newsletter — generated, reviewed, and sent by a system that won't stop evolving. Meanwhile, [Frank Sherlock](/en/2026/02/23/vibe-code-built-a-smart-image-indexer-with-ai-in-2-days-frank-sherlock/) went from 50 commits and v0.1 to 103 commits and v0.7 with face detection. [FrankMD](/en/2026/02/01/frankmd-markdown-editor-vibe-code-part-1/) got 3 external contributors and shipped v0.2.0. And even [FrankMega](/en/2026/02/21/vibe-code-built-a-mega-clone-in-rails-in-1-day-frankmega/) — a project built in 1 day — needed fixes when real users showed up.

Throughout February, I published more than a dozen posts detailing the build of each project. This post is different. It isn't about building from scratch, I covered that already. It's about what happens **after**. And what happens after destroys the one-shot prompt narrative. Software needs an experienced human at the wheel. Iterative development is the only thing that works. Anyone who disagrees hasn't put a system in production yet.

I'll prove it with `git log`.

## Life After Deploy

| Project | Post-publication commits | Highlight |
|---------|----------------------|----------|
| The M.Akita Chronicles | 56 | 3rd week in production, new features, 13 bug fixes, prompt tuning |
| Frank Sherlock | 53 | From v0.3 to v0.7: video support, face detection, AUR publish |
| FrankMD | 14 | 3 external contributors, 4 PRs merged, v0.2.0 |
| FrankMega | 2 | MIME types nobody saw coming |
| **Total** | **125** | |

Let's get into the details.

## The M.Akita Chronicles: 3 Weeks in Production

The newsletter system has been live since February 16. It's already sent 2 newsletters and tomorrow it sends the third. 56 commits have happened since the "final post":

| Date | Commits | What happened |
|------|---------|-----------------|
| Feb 20 (Thu) | 16 | Steam Gaming (whole new section), bug fixes in paywall detection |
| Feb 21 (Fri) | 12 | /preview command, YouTube collage, /rerun notifications |
| Feb 22 (Sat) | 1 | Fix: /preflight sending the result to the wrong channel |
| Feb 23 (Sun) | 10 | 2nd newsletter publication, Gmail clipping warning, TTS revert |
| Feb 24 (Mon) | 1 | Podcast prompt tweak |
| Feb 28 (Sat) | 7 | Marvin prompt tuning, rate limiting, /rerun comments |
| Mar 1 (Sun) | 9 | Mood system, switch to Grok-4, QA pipeline, config centralization |

### Features Nobody Saw Coming

**Steam Gaming.** Wasn't in the original plan. It was born because the entertainment section only had anime — and gamer readers were left out. Result: 6 commits just on launch day. The first commit (`bf41e25`) added the whole section — Steam API service, generation job, tests, Hugo shortcode. The next 5 fixed things: Portuguese date parsing, ranking offset so the top 10 didn't repeat, wishlist filter for releases, dark theme. No spec in the world predicts that the Steam API returns dates with Portuguese abbreviations (`"fev"`, `"mar"`, `"abr"`) when you ask for `l=brazilian`. You find that out when the parser breaks in production.

**Preview system.** `/preview` was born because I needed to see how the auto-generated content looked **before** publishing the entire newsletter. Seems obvious in retrospect, but in v1 the only way to validate was to generate everything and look at the final result. 5 commits to build a preview system with 9 sections, aliases (`hn` for hacker_news, `steam` for steam_gaming), separate comment-preview mode, and rescue when one section fails without taking the others down (`d23c725` — because a section with an error was killing the entire preview).

**Marvin's moods.** Marvin (the bot's sarcastic persona) suffers from a chronic LLM problem: smoothing. Without intervention, every comment ends up the same lukewarm tone. The iterative fix was a mood system — 9 modes the operator picks per story:

```ruby
MARVIN_MOODS = {
  "sarcastic"   => "Be extra sarcastic and biting in your commentary.",
  "ironic"      => "Use irony and dark humor to make your point.",
  "grounded"    => "Be more neutral and journalist-like, factual and measured.",
  "provocative" => "Be provocative and controversial, challenge assumptions.",
  "counter"     => "Take the opposite position from Akita's comment.",
  "insightful"  => "Find a non-obvious angle -- a historical parallel, a second-order consequence.",
  "positive"    => "Find the genuinely positive angle.",
  "hopeful"     => "Be cautiously optimistic. Acknowledge the good potential.",
  "negative"    => "Be extra pessimistic and bleak."
}.freeze
```

None of this came from a spec. It came from 3 weeks of reading bland comments and thinking *"this isn't good enough"*. There are 7 commits just for prompt tuning across 10 days. I banned formulaic patterns (`d4bd3a6`). I killed off "Ah," as an opener (`4171628`). I removed Marvin from entire podcast sections because he was contaminating the tone (`246cc60`). I pushed for substance instead of puns (`8bc47c4`). Each prompt commit is a micro-correction that only makes sense after reading the previous output.

### Bugs That Only Exist in Production

Of the 56 commits, 13 are bug fixes. Some favorites:

- **Gmail clipping** (`3258f5b`): Gmail silently cuts off emails larger than 102KB. I found out when the 2nd newsletter went out longer and Gmail readers didn't see the end. Fix: a size check in the content preflight that warns before publishing. I shrunk the history sections from 10 to 5 items (`51ce528`) to fit the limit.

- **False paywall detection** (`1fd8739`): the scraper marked sites as paywalled when it found accidental block text in a generic footer. Only showed up when the story list grew to dozens of real sources.

- **t.co link mangling** (`6bd056f`): Twitter shortens URLs with t.co, but it also auto-links file names that look like domains. `config.yml` becomes a link to the `config.yml` domain. 158 lines of fix to handle tweet text correctly.

- **TTS language revert** (`7803ad9` -> `c1dd668`): I tried switching the TTS language from "Portuguese" to "Auto". The model produced a mixed accent. Reverted the same day.

- **Podcast section ordering** (`5bef18c`): podcast sections came out in the wrong order. 3-line fix + untracking of 1,504 lines of generated content that had been committed by accident.

- **Elementor sites with multiple `<article>`** (`e70b756`): sites built with Elementor use the `<article>` tag in a non-semantic way. The content extractor was grabbing the wrong block. 171 lines of fix + tests.

None of these bugs could have been predicted in a spec. They only exist because the system is live, processing real data, hitting real APIs, being read by real people.

### From 1,323 to 1,422 Tests

The test suite kept growing along with it:

| App | Tests (Feb 20) | Tests (Mar 1) | Growth |
|-----|-----------------|-----------------|-------------|
| marvin-bot | 970 | 1,060 | +90 |
| newsletter | 353 | 362 | +9 |
| **Total** | **1,323** | **1,422** | **+99** |

New feature? Comes with a test. Bug fix? Comes with a regression test. Without that, the 56 post-production commits would be 56 chances to break something that worked yesterday. TDD isn't a phase, it's a habit.

### The Model Changed: From Claude to Grok-4

Commit `8f9d11c`: `Switch default model to x-ai/grok-4`. The architecture had isolated the LLM model into an environment variable from day one. But the model name was still hardcoded across 24 files. Result: commit `c8c688e` — `Centralize LLM model config` — 24 files touched to make swapping models a 1-line config change.

This kind of refactoring only shows up in operation. When you start the project, you don't know you're going to change models. When you change, you want it to be trivial. And the cleanup to make it trivial? Only happens when the pain shows up.

## Frank Sherlock: From v0.1 to v0.7 in 4 Days

The [Frank Sherlock post](/en/2026/02/23/vibe-code-built-a-smart-image-indexer-with-ai-in-2-days-frank-sherlock/) covered the first 2 days and ~50 commits: the benchmark research, the Tauri app scaffold (Rust + React), the classification pipeline with Ollama, and the v0.1.0 release with binaries for Linux, macOS and Windows.

What the post didn't cover: the next 53 commits, in 4 days, that took the project from v0.3 to v0.7:

| Version | Date | Highlight |
|--------|------|----------|
| v0.4.0 | Feb 24 | Duplicate detection (SHA-256 + dHash), PDF password manager |
| v0.5.0 | Feb 24 | Auto-update, scan performance 2x, checkpoint resume |
| v0.6.0 | Feb 25 | Video support (11 formats), directory tree, FTS stemmer |
| v0.7.0 | Feb 27 | **Face detection** with native ONNX, person management |

### Face Detection: A Feature Born from Iteration

v0.1 was an image indexer with LLM-based classification. v0.7 has face detection with 512-dimensional embeddings, cosine-similarity clustering, and per-person search (`face:alice`). None of that was in the original plan. It came up because I started using the app with real photos and thought *"I want to find every photo of so-and-so"*. The feature was born from use, not from a spec.

The path to get there was methodical:

1. **`f34132f`**: A/B testing framework for face detection — benchmark before implementing, not after
2. **`ef3be82`**: A/B results (SCRFD + ArcFace won)
3. **`6d9174a`**: Native implementation with ONNX Runtime — no Python, no external dependency
4. **`3b25eaf`**: Clustering, person management, complete FacesView
5. **`a02d67f`**: Refactoring — extract helpers, delete dead code, share CSS

Benchmark -> implement -> refactor. The same cycle as always. And something no one-shot prompt produces.

### Video Support: Another Emergent Feature

The app was built for images. But real media folders have videos. Commit `a67a2f9` added full support: scanning of 11 formats (MP4, MKV, AVI, MOV, WebM...), keyframe extraction for LLM classification, black frame skipping, .srt subtitle parsing for the full-text index, and inline preview with HTTP Range streaming.

1,626 lines added in one commit. An entire feature born from real use, not from a spec.

### 7 Releases, 3 Platforms, Automatic AUR

In 7 days, Frank Sherlock had 7 releases. Each one with binaries compiled for Linux (AppImage), macOS (DMG with notarization and code signing), and Windows (MSI). The CI/CD pipeline (`release.yml`) does everything automatically. Starting at v0.5.0, an additional workflow (`aur-publish.yml`) publishes automatically to the AUR — the Arch Linux package repository.

Final tally: 17,210 lines of Rust, 10,863 lines of TypeScript, 621 tests (322 Rust + 299 frontend). Cross-platform. Releases published and installable by any user. One week, one dev, one AI agent.

The CI/CD cross-platform part is where the *"works on my machine"* fantasy dies. There were 17 commits just for builds: Windows UNC paths, macOS signing with notarization, Linux AppImage, release workflow permissions, macOS Intel target removed. No LLM in the world knows that macOS requires specific entitlements for hardened runtime, or that paths on Windows start with `\\?\`. That kind of deploy work demands someone who's been through that pain before.

## FrankMD: Real Open Source

FrankMD was the first project in this saga, a self-hosted Markdown editor with Rails 8. The [February posts](/en/2026/02/01/frankmd-markdown-editor-vibe-code-part-1/) covered the build. What happened after is more interesting: other people started contributing.

14 commits since February 20. 3 external contributors. 4 PRs merged. v0.2.0 release on the 28th:

| PR | Author | Type | What it did |
|----|-------|------|-----------|
| #34 | @murilo-develop | Bug fix | Ollama integration: ModelNotFoundError + API base URL |
| #36 | @rafaself | Bug fix | Table hint behavior in the editor (3 iterative commits) |
| #38 | @LuccaRomanelli | Feature | Auto-sync theme with the Omarchy desktop environment |
| #39 | @LuccaRomanelli | Feature | "New Folder" in the explorer's context menu |

### The Maintainer's Pattern

What's most telling isn't the contributions themselves, but what I did after every merge.

When @LuccaRomanelli submitted the Omarchy theme sync PR (+308 lines), I merged it and immediately committed `fix: harden Omarchy theme integration and fix broken tests` — **+163 lines** of fixes and tests in the next commit. The contributor implemented the feature. The maintainer hardened it.

When @rafaself submitted the table hint fix, there were 3 iterative commits the same day — `enhance`, `improve`, `streamline` — showing the same progressive refinement pattern I do with the AI agent. The next day, he sent a separate commit updating faraday, nokogiri and rack for security advisories.

On the 28th, I sat down and did everything in one shot: merged the 4 PRs, committed the hardening, updated 5 gems (brakeman, bootsnap, selenium-webdriver, web-console, mocha), and published the v0.2.0 release notes. A classic *"release day"*.

FrankMD today has 226 commits, 1,804 tests (425 Ruby + 1,379 JavaScript), and active contributors. It isn't *"my little personal project"* anymore. It became software with a community. And community doesn't show up for a test-less prototype that *"works on my machine"*. It shows up for a project with green CI, documentation, versioned releases, and code you can actually read.

## FrankMega: Even the Smallest Project Needs Post-Production

FrankMega was built in [1 day](/en/2026/02/21/vibe-code-built-a-mega-clone-in-rails-in-1-day-frankmega/). 26 commits, secure file sharing with Rails 8, 210 tests, deploy via Docker + Cloudflare Tunnel. Post published the same day. Done, right?

Three days later, 2 commits:

- `db4bb705` — Add macOS, Linux, and Windows package MIME types to seed defaults
- `b0c4829a` — Fix MIME types to match Marcel detection, add normalizes strip

Users tried to share `.dmg`, `.deb`, and `.msi` files. The MIME type detection (via the Marcel gem) didn't recognize those formats because they weren't in the seed defaults. Two commits. 22 lines. 15 minutes.

But without them, FrankMega couldn't be used to share installer packages — which is exactly the most common use case on a dev's home server.

> No prompt in the world predicts that your users will want to share `.deb` files on day one.

The simplest project of all, with the shortest post-production. And even then, it needed iteration.

## The Consolidated Numbers

| Project | Commits (total) | Tests | Post-production |
|---------|----------------|--------|--------------|
| The M.Akita Chronicles | 335 | 1,422 | 56 commits, 10 days in production |
| Frank Sherlock | 103 | 621 | 53 commits, 4 extra releases |
| FrankMD | 226 | 1,804 | 14 commits, 3 contributors |
| FrankMega | 28 | 210 | 2 commits, MIME fixes |
| **Total** | **692** | **4,057** | **125 post-publication commits** |

692 commits. 4,057 tests. 4 projects in production. February 2026. Me and an AI agent.

## Why One-Shot Prompting Is a Myth

Look at the 125 post-production commits and tell me which one of them could have been predicted by a spec.

Gmail cuts off emails larger than 102KB, and you only find that out when you send the first long email. The Steam API returns dates with Portuguese abbreviations (`"fev"`, `"abr"`), and you only find that out when the parser breaks on generation Sunday. macOS users try to share `.dmg` files and can't because the MIME type isn't in the seed. Marvin opens every comment with *"Ah,"* and you only notice it after reading 30 in a row and wanting to claw your eyes out. The LLM model has to be swappable with 1 line of config, but it's spread across 24 files. Windows uses UNC paths starting with `\\?\`, and CI explodes in your face. And TTS in "Auto" mode? Generates an accent that sounds like Lisbon Portuguese trying to be carioca.

None of this is "debugging" in the traditional sense. It's navigating a problem space that only reveals itself when the software meets reality. Each one of these was a real-time decision made by someone with context.

The one-shot prompt fantasy is that, if you write a sufficiently detailed spec, the AI produces the perfect software. But the perfect spec would require you to know in advance everything that's going to go wrong. And if you knew in advance everything that's going to go wrong, you wouldn't need the spec — you'd already have the software done in your head.

Good software is the result of hundreds of micro-decisions made with the system running. Not a single macro-decision made before the first line is written.

## The Role of the Experienced Developer

AI accelerated all of this. Without it, 692 commits in a month would be impossible for one person. But acceleration without direction is just faster entropy.

In every project there were decisions the AI couldn't have made on its own. Switching from Claude to Grok-4 because the previous model was weak in a specific domain. Benchmarking SCRFD against alternatives *before* implementing face detection, because the wrong choice would cost days. The +163 lines of hardening I committed immediately after merging the Omarchy PR, because I saw where it was going to break. The TTS revert from Auto mode the same day, because I know that "Auto" on a TTS model for Brazilian Portuguese will produce a mixed accent.

The circuit breaker case is the most illustrative. When I added rate limiting, the Brave Search API started returning 429s every once in a while. If I had asked, the agent would have implemented a retry with exponential backoff. But I didn't ask for retry. I asked for a circuit breaker:

```ruby
class WebSearcher
  CIRCUIT_BREAKER_SECONDS = 120

  def self.search(query, max_results: 5)
    return [] if circuit_open?

    response = brave_search(query, max_results)

    if response.code == 429
      trip_circuit!
      Rails.logger.warn("WebSearcher rate limited (429)")
      return []
    end
  rescue Net::OpenTimeout, Net::ReadTimeout => e
    trip_circuit!
    []
  end
end
```

If the API returns 429 or times out, it stops trying for 120 seconds. No retry, no backoff, no queue. Why? Because I know the cron runs every day at 8am and that on newsletter generation Sundays the query volume triples. A herd of retries delaying everything is worse than empty results in one section.

The AI implements a circuit breaker when you ask it to. But it isn't going to ask to implement a circuit breaker. It doesn't have the operational context. That's knowledge that comes from running systems in production for decades.

> The agent writes the code. I decide what code to write. And that decision requires experience no prompt can replace.

## The Lessons

**1. Software in production diverges from the spec in hours, not months.** The first M.Akita Chronicles bugs showed up in the first real newsletter. FrankMega's MIME types broke on the first uploads. Anyone who thinks deploy means done is living in a world that doesn't exist.

**2. Post-production isn't "maintenance".** 56 commits in 10 days on the M.Akita Chronicles aren't patches. They're new features (Steam Gaming, preview, moods), architecture refactoring (LLM config centralization), security hardening (rate limiting). That's development. The software didn't stop evolving just because I said *"done"* in a blog post.

**3. TDD protects evolution.** 99 new tests in 10 days. FrankMD's 1,804 tests let me merge 4 external contributor PRs without fear. Without tests, every merge is Russian roulette.

**4. Small releases keep you sane.** 7 Frank Sherlock releases in 7 days. Green CI, compiled binaries, release notes. Something broke? Roll back one version. Compare that with "6 months + big bang release" and tell me which one works better.

**5. Community shows up for real projects.** Nobody sends a PR to a test-less prototype that *"works on my machine"*. FrankMD got 3 contributors because it has green CI, documentation, and versioned releases.

**6. The developer's experience is the bottleneck, not the AI's speed.** 692 commits in a month. But every commit that mattered required decades of experience to know it was needed. The AI types fast. I know what to type.

**7. One-shot is for demos. Iteration is for production.** If the goal is a 10-minute video showing a *"finished SaaS"*, one-shot will do. If the goal is software that survives contact with real users, only iteration works. And sustainable iteration demands discipline: TDD, CI, small releases, continuous refactoring. No shortcut.

## To the Senior Still Sitting on Their Hands

So far I've been hitting the amateurs who think they can fire off a prompt and the AI spits out a finished system. Fair enough. But there's another group that worries me just as much: the senior developer who saw the AI mess up three times, declared *"this is useless"*, and went back to doing everything by hand.

I get the reasoning. The AI hallucinates, generates code with subtle bugs, suggests over-engineered solutions. All true, and I documented every one of these problems in the previous posts. But tell me something: have you never done exactly the same thing? Have you never spent 2 hours reading documentation only to find out it was a typo in the config? The difference is that when the AI gets it wrong, you catch it in the tests and fix it in minutes. When you get it wrong on your own, it takes you the same amount of time to make the mistake and even longer to find it, because you trust your own code.

Let's look at the concrete numbers of what I shipped in February, one person and one AI agent:

| Project | Time | Result |
|---------|-------|-----------|
| M.Akita Chronicles | 8 days | 4 apps (Rails + Python + Hugo), 335 commits, 1,422 tests, 3 weeks in production |
| Frank Sherlock | 7 days | Tauri desktop app (Rust + React), 103 commits, 621 tests, 7 releases, binaries for 3 OSes |
| FrankMD | ~4 days | Rails 8 Markdown editor, 226 commits, 1,804 tests, 3 external contributors |
| FrankMega | 1 day | Rails 8 file sharing, 28 commits, 210 tests, Docker + Cloudflare deploy |

Now do the math in your head. How long would it take you to build Frank Sherlock on your own? A Tauri app from scratch, with an LLM classification pipeline in Rust, OCR via Python, full-text search with FTS5, duplicate detection by perceptual hash, face detection with native ONNX, video support with keyframe extraction, CI for 3 platforms with macOS code signing and notarization, auto-update, and automatic publishing to the AUR. With 621 tests. In Rust, which doesn't forgive.

To be honest: without AI, a good senior dev would take at least 3-4 weeks on this, probably more. I did it in 7 days, alone, and every release is published with binaries anyone can download and install.

I already estimated The M.Akita Chronicles in the [previous post](/en/2026/02/20/zero-to-post-production-in-1-week-using-ai-on-real-projects-behind-the-m-akita-chronicles/): ~200 user stories. In Scrum with a senior team of 2-3 devs, no impediments, that would be 10-15 weeks. I did it in 8 days. Today, 3 weeks later, the system keeps running, evolving, with 99 more tests than when it *"was done"*.

FrankMega is more modest, but secure file sharing with Rails 8, I18n in 2 languages, 22 security issues fixed, Docker deploy, 210 tests. I did it in 1 day. A good senior, without AI, would do it in 1-2 weeks at best.

And I'm not talking about disposable prototypes. People from outside send PRs to FrankMD. Real subscribers get the M.Akita Chronicles newsletter every Monday. Anyone can download Frank Sherlock from GitHub Releases or the AUR. Green CI, Brakeman clean, real tests, automated deploys. That's production software, not a conference demo.

*"Yeah, but I write better code without AI."* Maybe. But how long does it take you? What I showed here isn't that AI writes perfect code. Far from it. It's that with TDD, CI, pair programming with the agent, and continuous refactoring, the end result is production code with quality. 4,057 tests are there to prove it. Brakeman clean. 125 post-production commits show the code can take evolution without turning into a ball of mud.

And using AI here and there to generate a snippet of code, like glorified autocomplete, also isn't the answer. You're leaving 90% of the gain on the table. What I did in February was full-time pair programming with an agent. From the first commit to production deploy. With the same discipline I'd use with a human pair. Result: 4 projects in production in 1 month, with quality I put my name on. Because I did put my name on it.

If you're a senior and you're still waiting for AI to *"get better"* before you really start using it, here's my message: it's already good enough. The 692 commits are there to prove it. The bottleneck now is you learning to work with it.

## Conclusion

In February 2026, I built 4 projects from zero to production with AI. But the build is the easy part. What separates real software from a demo is the 125 commits that came after, when the bugs nobody predicted appeared, when external contributors sent PRs that needed hardening, when new features came up from real use and not from a requirements spreadsheet.

AI made me absurdly more productive. Without it, Frank Sherlock wouldn't have face detection in 7 days. Without it, M.Akita Chronicles wouldn't be in its 3rd week of operation with 1,422 tests. The speed is real.

But none of the decisions that mattered came from the AI. Switching models, reverting the TTS the same day, looking at the contributor PR and seeing where it was going to break, asking for a circuit breaker instead of retry. All of that was me. The AI executed. The decisions were mine.

The AI is the accelerator. Extreme Programming techniques (TDD, small releases, pair programming, continuous refactoring) are the brake and the steering wheel. Without discipline, AI produces fast code that piles up technical debt even faster. With discipline, AI produces software that actually evolves, week after week.

692 commits. 4,057 tests. 4 projects in production. And tomorrow, Monday, at 7am, M.Akita Chronicles subscribers get the 3rd newsletter. Generated, reviewed, and sent by a system that will never be *"done"*. Because finished software is dead software.

> "Finished software is dead software. Live software iterates."
