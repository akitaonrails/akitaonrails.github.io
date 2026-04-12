---
title: "37 Days of Vibe Coding Immersion: Conclusions on Business Models"
slug: "37-days-of-vibe-coding-immersion-conclusions-on-business-models"
date: 2026-03-05T14:00:00-03:00
draft: false
translationKey: 37-days-vibe-coding-business-conclusions
tags: ["off-topic", "ai", "vibe-coding", "startups", "business", "opinion"]
description: "After 37 days, 650+ commits, ~144K lines of code and nearly 10 published projects, my conclusion on what vibe coding means for the future of startups and business models."
---

For the last 37 days I locked myself into a vibe coding immersion. The goal was simple: actually understand what the current generation of LLMs and coding agents can do. Not on a weekend toy project, but building real things, with production deploys, users, and the maintenance pain that comes along.

The result was 653 commits, ~144K lines of code across 8 projects published on GitHub, and a series of articles documenting each one. If you've been following along, you've already read the post-mortems. If you haven't, here's the index:

## The articles

- [Vibe Code: I built a small app 100% with GLM 4.7 (TV Clipboard)](/en/2026/01/28/vibe-code-built-a-little-app-fully-with-glm-4-7-tv-clipboard/)
- [Vibe Code: Which LLM is the BEST?? Let's get real](/en/2026/01/29/vibe-code-which-llm-is-best-lets-be-real/)
- [Vibe Code: I built a Markdown editor from scratch with Claude Code (FrankMD) PART 1](/en/2026/02/01/frankmd-markdown-editor-vibe-code-part-1/)
- [Vibe Code: I built a Markdown editor from scratch with Claude Code (FrankMD) PART 2](/en/2026/02/01/frankmd-markdown-editor-vibe-code-part-2/)
- [RANT: Did AI kill programmers?](/en/2026/02/08/rant-ai-killed-programmers/)
- [Vibe Code: From Zero to Production in 6 DAYS - The M.Akita Chronicles](/en/2026/02/16/vibe-code-zero-to-production-in-6-days-the-m-akita-chronicles/)
- [From Zero to Post-Production in 1 Week - How to Use AI on Real Projects](/en/2026/02/20/zero-to-post-production-in-1-week-using-ai-on-real-projects-behind-the-m-akita-chronicles/)
- [Vibe Code: I built a Mega clone in Rails in 1 day for my Home Server](/en/2026/02/21/vibe-code-built-a-mega-clone-in-rails-in-1-day-frankmega/)
- [Vibe Code: I built an Intelligent Image Indexer with AI in 2 days - Frank Sherlock](/en/2026/02/23/vibe-code-built-a-smart-image-indexer-with-ai-in-2-days-frank-sherlock/)
- [RANT: Did Akita open his legs to AI??](/en/2026/02/24/rant-akita-caved-to-ai/)
- [ai-jail: Sandbox for AI Agents](/en/2026/03/01/ai-jail-sandbox-for-ai-agents-from-shell-script-to-real-tool/)
- [Software Is Never 'Done' - 4 Projects, the Life After Deploy](/en/2026/03/01/software-is-never-done-4-projects-life-after-deploy-one-shot-prompt-myth/)
- [I Built a Data Mining System for My Influencer Girlfriend](/en/2026/03/04/data-mining-system-for-my-influencer-girlfriend/)
- [My First Vibe Code Failure and How I Fixed It - Frank Yomik](/en/2026/03/05/my-first-vibe-code-failure-frank-yomik/)

## The projects

| Project | Commits | LOC | Time | What it does |
|---------|---------|-----|-------|-----------|
| [FrankMD](https://github.com/akitaonrails/FrankMD) | 234 | 38K | ~5 days | Markdown editor in Rust/Tauri |
| [FrankYomik](https://github.com/akitaonrails/FrankYomik) | 131 | 21K | ~9 days | Manga/webtoon translator (Go + Python + Flutter) |
| [FrankSherlock](https://github.com/akitaonrails/FrankSherlock) | 103 | 37K | ~6 days | Intelligent image indexer (Rails + Python) |
| mila-bot (private) | 60 | 30K | ~3 days | Data mining system (Rails + Discord) |
| [TVClipboard](https://github.com/akitaonrails/tvclipboard) | 49 | 5K | ~2 days | Cross-device clipboard app with GLM 4.7 |
| [ai-jail](https://github.com/akitaonrails/ai-jail) | 46 | 6K | ~4 days | Security sandbox for AI agents (Rust) |
| [FrankMega](https://github.com/akitaonrails/FrankMega) | 29 | 7K | ~1 day | Mega clone for the home server (Rails) |
| The M.Akita Chronicles | 1+ | many | ~6 days | Full blog/newsletter in production |

All of this happened between January 27 and March 5, 2026.

I'm not going to repeat the technical details of every project. Each post-mortem above already covered that. What I want to discuss here is the consequence.

## What these 37 days showed me

Projects that used to take weeks or months for an experienced developer now take days. A complete Markdown editor in 5 days. A Mega clone in 1 day. A data mining system with 40+ bot tools in 3 days. An image indexer with vision AI in 2 days.

And I'm not talking about throwaway prototypes. These projects are in production. They have tests. They have automated deployments. It's real software built with real engineering practices, just at a speed that was unthinkable before.

This speed isn't unique to me. Cloudflare just demonstrated something similar. [In a recent post](https://blog.cloudflare.com/vinext/), they describe how an engineer reimplemented the Next.js API surface on top of Vite in a week, using Claude as the main tool. US$ 1,100 in API tokens, more than 800 sessions, 1,700 unit tests, 380 E2E tests, builds 4.4x faster than the original Next.js. Controversies aside about whether it's a "complete" reimplementation or not, the central point is real: software that used to require teams and months can now be built by one person in days.

And that changes everything for anyone wanting to start a company.

## The death of the easy startup

For years, the classic startup model worked like this: someone has an idea, puts together a small team, builds an MVP in 3-6 months, raises seed money, and tries to scale. The barrier to entry was development cost. Programmers are expensive, development is slow, and the first to market has the advantage.

That model is breaking.

If I can build a working Mega clone in 1 day, what's a "cloud storage" startup worth? If Cloudflare reimplements the Next.js core in 1 week with one engineer and US$ 1,100 in tokens, what's the real moat of a platform like Vercel? The "social listening" SaaS that charges R$ 500/month is competing with something I built in 3 days as a side project.

Every entrepreneur who used to show up describing their idea as "it's like Uber, but for..." or "it's like Airbnb, except..." or "another social network, but with..." — those people need to stop and rethink. When any competent developer with access to Claude Code or GPT Codex can replicate your MVP in a week, your idea isn't worth anything anymore. Execution got too cheap.

I'm not exaggerating. In my 37 days, I built things I wouldn't even attempt in 6 months before. Small CRMs, ecommerces, content managers, productivity tools, data mining apps, processing pipelines — all of that became commodity. The code itself is no longer the differentiator.

## So what is the differentiator?

This is where most vibe coding enthusiasts miss the point. To illustrate, let me use my own project as an example.

[Frank Yomik](https://github.com/akitaonrails/FrankYomik) translates manga pages from Japanese to English in near real-time. The full pipeline (balloon detection, OCR, translation, rendering) works. But the most important component of the system isn't any code I wrote. It's the `ogkalu/comic-text-and-bubble-detector` model, an RT-DETR-v2 trained on ~11,000 labeled comic images.

I didn't train that model. I couldn't easily train that model. Collecting 11,000 diverse comic images, manually labeling the speech balloons in each one (or generating labels with some semi-automated pipeline, which isn't trivial either), configuring the training, and running it on the necessary hardware — that's work of a different nature. It's work that vibe coding doesn't solve.

And that's the case of a relatively small model. An object detector can be trained with a few hundred to a few thousand labeled images on a single GPU in hours. Studies show useful results are possible with 100-350 images for specific domains, but robust real-world detectors usually need thousands. The cost is low, in the hundreds of dollars range.

Now look at what happens when we scale up to bigger models.

## The numbers that matter

GPT-4 cost more than US$ 100 million to train, according to Sam Altman himself. Stanford estimated the compute cost of Google's Gemini Ultra at US$ 191 million. Meta's Llama 3 consumed 39.3 million GPU-hours on H100s, and Meta built two clusters of 24,576 GPUs each to make it possible — and by the end of 2024 it planned to have 350,000 H100s in its infrastructure.

These costs are accelerating. According to Epoch AI, the cost of hardware and energy to train frontier models grows by 2.4x per year since 2016. If that trend continues, the largest training runs will cost more than US$ 1 billion before the end of 2027. Dario Amodei, Anthropic's CEO, has said frontier developers are probably spending close to a billion per training run now, with US$ 10 billion training runs expected within two years.

And the hardware? An H100 GPU costs US$ 25,000-40,000 per unit. A server with 8 GPUs runs between US$ 200,000 and US$ 400,000. The HBM memory those GPUs use is at capacity — SK Hynix, Samsung and Micron have already announced ~20% price increases for 2026. NVIDIA consumes more than 60% of the global HBM production. It's a structural bottleneck, not a temporary one.

In terms of energy: global data centers consumed ~415 TWh of electricity in 2024, according to the IEA, about 1.5% of the world's electricity. The projection is ~945 TWh by 2030. New data centers are being built with capacities of 100 MW to 1 GW each.

And the big tech investments reflect that. In 2025, the aggregate capex of Amazon (~$125B), Google (~$91B), Microsoft (~$80B) and Meta (~$71B) crossed US$ 400 billion, a 62% increase over 2024. Goldman Sachs projects more than US$ 500 billion in 2026.

These numbers aren't meant to scare. They're meant to put the real entry barrier in context.

## The new barrier: exclusive data and training capacity

If software got cheap to produce, the competitive differentiator migrated. The question stopped being "who writes code the fastest?" and became "who has access to data nobody else has, and knows how to turn that data into useful models?"

DeepSeek-V3 announced that its training cost US$ 5.5 million in compute. The press celebrated the "cheap Chinese model." But The Register reported that the acquisition cost of the 256 GPU servers used was over US$ 51 million — and that excludes R&D, data acquisition, data cleaning, and all the failed training runs before the final successful one. The real cost of developing the capability is one or two orders of magnitude above the marginal cost of the final successful training run.

That's why we only see large companies producing frontier models. Meta, Alibaba, Google, Amazon, Microsoft, Anthropic — companies investing tens of billions in hardware and energy. A garage startup can't compete on this dimension.

But the question goes beyond frontier models. Even smaller specialized models require something you can't buy: high-quality proprietary data.

Llama 3 was trained on 15 trillion tokens. Epoch AI has documented that we're approaching the limits of human-generated text data on the internet. Public data is being exhausted. Whoever has exclusive data — medical, financial, industrial, logistics, sensor, user behavior — has something that vibe coding can't replicate.

And even those who train specialized models with proprietary data face a problem: the advantage is temporary. Another competitor can collect similar data and train a competing model in months. The differentiator needs to be continuously fed: more data, better curation, more efficient training pipelines, access to hardware that's increasingly scarce and expensive.

## The picture

If you're thinking about starting a company, the question that matters has changed.

Before it was: "can I build this software?" Now the answer is almost always yes, fast and cheap.

The question now is: "do I have exclusive data nobody else has, and do I know how to turn that data into something useful that's hard to replicate?"

If the answer is no, any competitor with Claude Code replicates your product in days. And then another one shows up. And another. The race to the bottom on price is immediate when the cost of building is close to zero.

If the answer is yes, you have a real moat — but a temporary one. Competing models trained on similar data can show up in months. Your differentiator needs to be continuously fed.

The era of easy startups is over. Not because building software got harder — it got way easier. But precisely because of that: when everyone can build the same thing in a week, the competitive advantage has to come from somewhere else. And that "somewhere else" requires capital and infrastructure that are orders of magnitude more expensive than writing code.

The garage still works. But what comes out of it can no longer be "an app."
