---
title: "Why Things Like TypeSafe AI Don't Interest Me"
slug: "why-things-like-typesafe-ai-dont-interest-me"
date: '2026-09-16T13:00:00-03:00'
draft: false
translationKey: por-que-coisas-como-typesafe-ia-nao-me-interessam
description: "A handful of people showed up in the comments asking 'have you tried TypeSafe?'. I use that as a hook to lay out my rule about new AI tools, actually investigate the case, and explain why I don't waste time optimizing token spend."
tags:
- artificial-intelligence
- coding-agents
- llms
---

A handful of people showed up in the comments over the last few days, always with the same line: "have you seen [TypeSafe](https://typesafe.ai)?" That trips an automatic alarm in my head. Every time several different people show up recommending the same thing out of nowhere, with the same "you need to see this" tone, I **smell a propaganda bot** or someone repeating whatever they read in some group chat without thinking twice. There's a flood of AI SaaS fighting for attention in this market right now, and the overwhelming majority of it is irrelevant to what I actually do day to day.

Let me get my rule out of the way before I get into the specific case, because it matters more than the case itself.

## My Rule: Don't Use Anything Until Not Having It Hurts

After producing more than half a million lines of AI-assisted code over the last few months, dozens of projects live, a whole benchmark rebuilt from scratch three times, my recommendation for anyone who codes is direct: **don't use any orchestration tool or middle layer until you feel it in your bones that you need the extra help**. Use whichever harness you already like, Codex, opencode, Claude Code, whatever, directly, no middleman, and forget the rest.

It's not even worth spending time collecting someone else's skill packages to stack on top of your agent. Build, train, and gather your own experience for your own use case. Nobody else on earth has your project, your context, your codebase. Someone else's skill package was designed for their problem, not yours.

I already hit this note [a month ago](/en/2026/08/18/hot-take-harness-loop-engineering-graph-engineering-are-bullshit/): once a technology turns into a commodity, the money migrates to taxonomy. Somebody coins a fancy name for chaining API calls, and out of nowhere a course, a certification, and a consulting practice spring up around that name. TypeSafe is just one more chapter of the same story, so it became a good excuse to show how I decide whether something's worth even opening the tab.

> **Keep this:** don't use an orchestration tool or middle layer until you feel in your bones that you need it. Build experience for your own use case; don't collect someone else's skill package.

## The Trigger: TypeSafe

I opened their site and their launch post, [Jev](https://typesafe.ai/blog/introducing-system-one-models-and-jev). My first impression, pretty superficial and raw: I didn't like it and I didn't trust it. The homepage is a pile-up of AI jargon, Kahneman here, Jevons there, decorative glyphs, a "193x faster" figure with no benchmark sitting next to it. At first glance, none of it makes sense on its own.

And there's a detail that always puts me on guard: any time the first thing someone says about themselves is "I'm a former OpenAI researcher" or something like it, **I get suspicious first and ask questions later**. It reads like an attempt to slap on a credential to look credible before any real proof. TypeSafe's founder talks himself up too loudly right out of the gate, and that alone is reason enough to hit the skepticism button.

But a triggered skepticism meter isn't a conclusion. It's the starting point for actually investigating, not for dismissing something without a look. That's the part I want to show here: how I move from initial distrust to real research, until I find out whether I was right or just being difficult.

## I Asked the AIs, I Didn't Trust the AIs

I sent the same prompt to Grok and to Claude: research this thoroughly, my initial impression is very skeptical, "ex-OpenAI researcher" smells like slapping on a credential, the site is jargon top to bottom, tell me what the actual sales pitch is, what it's for in practice, and whether their logic, underneath the jargon, even makes sense.

Both came back with long, detailed research, a similar story from each: the founder's credential is real but inflated; the product is narrower and more coherent than the homepage lets on; and "can't hallucinate" is a schema claim dressed up as a truth claim.

Except I'd already handed my own conclusion to both of them inside the prompt, so their agreement proves less than it looks like. Two AIs agreeing with the hypothesis I wrote into the request myself isn't independent confirmation of anything, it's an echo. That doesn't invalidate what they brought back, but it meant I couldn't stop there. I wasn't going to publish this by stamping my approval on what two AIs told me. I asked for another round of research, this time with me checking every claim against a primary source: the actual paper, the launch post straight from the source, independent third-party tests, and whether "RLCD," the name they use for their training method, is a real paper or just a nice-sounding name with nothing behind it.

### What Jev Actually Is

Strip away the marketing, and Jev is a hosted classifier. You send a piece of text and a list of small questions, each with a fixed answer type:

- pick one option from a list;
- give it a score on a scale;
- answer yes or no, with a probability.

It doesn't write anything, doesn't plan anything, doesn't converse. Code owns the flow; the model just answers the little question fast, in parallel, without generating free text.

As a product, that's reasonable: plenty of people today send text to a chat LLM just so it returns a label inside a JSON blob, wait eight seconds, and pray the schema doesn't break. Swapping that for a call that returns just the label, fast, is legitimate engineering. **The idea was never the problem. It's the packaging around it.**

## The Facts I Confirmed

Here are the findings that actually survived a primary-source check, not what an AI told me secondhand.

The founder's credential is real, but the company's own page inflates it in a way you can prove is inflated. [Diogo Almeida](https://typesafe.ai/team) is the 4th of 20 authors on the [InstructGPT paper](https://arxiv.org/abs/2203.02155), published and peer-reviewed at [NeurIPS 2022](https://neurips.cc/virtual/2022/poster/52886), the field's heavyweight conference. A real author, a real position, a real paper. Except TypeSafe's team page says this, word for word:

> *"Diogo co-invented RLHF and InstructGPT, the methods that lead to ChatGPT and GPT4."*

RLHF is from 2017, [five years earlier](https://arxiv.org/abs/1706.03741), authored by a different team (Christiano, Leike, Amodei, and company), with no Diogo anywhere in it. He helped apply RLHF to train InstructGPT. **He didn't invent RLHF.** It's the same résumé inflation I already suspected before checking anything, just with proof now.

The funding is real: **a $40 million seed round** led by [DCVC](https://www.dcvc.com/companies), **a $200 million valuation** [confirmed independently by Forbes](https://www.forbes.com/sites/the-prompt/2026/09/15/this-200-million-startup-wants-to-fix-ais-overconfidence-problem/), not just by the company's own press release. That's serious money, not some guy running a scam out of a garage.

[The launch post](https://typesafe.ai/blog/introducing-system-one-models-and-jev) admits, in its own words, exactly what I suspected about the "zero hallucination" chart:

> *"Our number is not empirical. Schema matching is guaranteed, thus we can confidently add 0% into the plots."*

In other words: the zero doesn't come from measuring anything, it comes from guaranteeing the answer always fits inside the allowed options. That stops the model from inventing a fifth category when only four exist. **It does not stop the model from picking the wrong category with 93% confidence.** It's the same critique [The Register published](https://www.theregister.com/ai-and-ml/2026/09/16/typesafe-ai-debuts-model-for-machines-that-plays-doom/5296711): the comparison isn't fair because the output isn't language, and a validly-typed answer can still just be wrong.

The post also admits what the ruler is for measuring "accuracy": *"We use the average of GPT-6 Astra and Fable 5.1 as the reference answer"*, and goes on to admit that this *"biases answers towards OpenAI and Anthropic's models."* In other words, the answer key is the average of what two other companies' models said, with bias admitted by the authors themselves, not objective truth measured by a human.

The only test run by an outsider, from the [Every](https://every.to/also-true-for-humans/mini-vibe-check-typesafe-s-jev-judged-everything-i-ve-written-in-0-7-seconds) newsletter, found Jev about twenty-five times faster, 0.35 seconds versus 8.83 seconds per passage, and much cheaper than Claude Fable 5.1, except it caught six of seven planted defects against Fable's seven of seven. **Faster and cheaper, for real. Also weaker, for real.**

And the finding neither Grok nor Claude fully nailed down, but that I confirmed myself: the name of their training method, RLCD, already exists. [There's a real, peer-reviewed 2023 paper](https://arxiv.org/abs/2307.12950), Reinforcement Learning from Contrastive Distillation, from a completely different team, with [the authors' own code published on Facebook Research's GitHub](https://github.com/facebookresearch/RLCD), since two of the five authors are at Meta. It's a different technique, with no relation whatsoever to what TypeSafe describes. Their RLCD has no paper, no published architecture, nothing to review. **It's a name borrowed from someone else's research, glued onto a method that, until proven otherwise, is just a paragraph in a blog post.**

## Was My Suspicion Justified?

It was. The product idea is legitimate and reasonably coherent underneath the jargon: cheap, closed-form decisions at high volume is a real problem that today gets solved slowly and expensively, generating free text just to extract a JSON out of it afterward. Solving that fast has real value.

But "overblown claim without much practical difference" also holds up point by point:

- the founder's résumé is inflated in a way you can prove with a publication date;
- the launch's flashiest number, zero hallucination, is a schema definition, not a measurement;
- the accuracy benchmark's answer key is the average of another company's LLMs, not objective truth;
- the only outside test found the product weaker than the model it's pitched to replace;
- the name of their most-cited training method collides with a real paper that has nothing to do with them.

That's not reason enough to call it a scam. It's plenty of reason to call it "a small product with a pitch way bigger than what it actually delivers." And before I hand my data to yet another third party I don't know, with a closed API, a waitlist, and no published paper backing up the fancy name, the risk-versus-benefit math doesn't close for my use case.

> **Keep this:** a real credential isn't the same thing as an honest credential. Check the publication date before trusting the résumé, and check the paper before trusting the method's name.

## And What About Saving Tokens?

The TypeSafe case reminded me of a separate gripe I already wanted to put on paper, and it isn't about them specifically: the promise of token and cost savings that practically every product of this type sells. It's about the whole category of tool that promises "save Nx by spending with us instead of spending directly with your provider," not one more accusation against TypeSafe.

Every new model version, and every harness update, changes the entire math, sometimes violently. When I jumped from [GPT Sol to Astra](/en/2026/09/15/new-llm-benchmark-v4-retesting-39-llms-part-2/), I watched my weekly subscription quota drain much faster than I expected, without me having changed anything about how I work. It was just the new model consuming differently. **That's the rule of this market, not the exception**: OpenAI, Anthropic, and company are going to keep messing with price, with quantization, with caching policy, and with how much reasoning each model burns under the hood, with or without my consent.

Building your strategy on top of "saving tokens" is betting on a foundation that shifts month to month, decided by people who don't consult you. A middle-layer tool that promises to cut cost today can turn irrelevant, or worse, more expensive than the direct path, on the next model update. It's the same reason I don't use an orchestrator or a skill framework: when the foundation keeps shifting, adding structure on top of it just makes you a hostage to maintenance you didn't need.

I'd rather max out tokens and focus on whether the result I get from that spend is worth it. So far, with my subscription, I'm satisfied with what I'm able to produce. I feel zero urge to spend time cutting tokens, an effort that always carries the risk of degrading response quality in exchange for a saving the next model version can erase on its own.

> **Keep this:** don't build a strategy on top of token price and consumption, because that shifts month to month by decisions from people who don't consult you. Measure whether the result is worth the spend, not the spend itself.

And if I ever manage to spend enough tokens to boil an entire lake with the datacenter's heat, I will spend it with the greatest pleasure in the world. It's my personal revenge against whoever forced me to use paper straws that dissolve in your mouth for all these years.
