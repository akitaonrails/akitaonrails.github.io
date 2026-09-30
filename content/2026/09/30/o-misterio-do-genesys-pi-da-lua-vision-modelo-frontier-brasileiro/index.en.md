---
title: "The Mystery of LUA Vision's Genesys PI - A Brazilian Frontier Model??"
slug: "the-mystery-of-lua-vision-genesys-pi-brazilian-frontier-model"
date: '2026-09-30T19:00:00-03:00'
draft: false
translationKey: o-misterio-do-genesys-pi-da-lua-vision-modelo-frontier-brasileiro
description: "After the first Genesys PI test, LUA Vision fixed bugs in the API and I ran everything again: cost dropped 85%, House climbed to 95.5 and Enterprise stayed flat. I also ran a black-box forensic analysis to answer whether the model is a rebadged Qwen, a disguised gpt-oss or an API proxy. I separate what is checked from what is still only their word."
tags:
- llm-benchmarks
- llms
- artificial-intelligence
---

Last week I published [the first test of Genesys PI](/en/2026/09/23/llm-benchmark-v4-genesys-pi-new-brazilian-contender/), LUA Vision's model, on my v4 sabotage benchmark. The summary of that round: the House tier closed at 83.5, tied with Grok 4.7 in the middle of the pack, and Enterprise at 82.5, one step below.

Both caught every loud sabotage; House let through the two silent items almost every model lets through (#7b and #8), and Enterprise let through three (#7a, #7b and #9). House's notional cost, about $460, was the most expensive in the whole table, and the cause was the absence of prompt caching in the API.

A lot has happened since then, and this post is the continuation. I'll go in the order that matters: first the new numbers, then the question everyone asked me in comments and DMs ("isn't this just a Qwen with a sticker?"), and only at the end the speculative part about what the company says it built.

Before that, the backdrop that makes all of this strange: the industry consensus is that training a frontier model costs tens or hundreds of millions of dollars in GPU, and that, therefore, a small company with no billion-dollar funding round should not get anywhere near one. gpt-oss, OpenAI's own open model, with the best-funded lab in the world behind it, could not complete my benchmark on the same harness Genesys PI ran on. The Brazilian model completed it twice per tier.

This post is organized around that tension. First, what the model did in experiments I control. Then, what I could and could not verify about how it exists.

## New disclaimer

Since the first article, I've talked directly with two of LUA Vision's four co-founders: [Paulo Câmara](https://www.linkedin.com/in/paulocamara/), CTO, and [Eronides Junior](https://www.linkedin.com/in/eronidesjunior/), CRO. Paulo is the technical lead, an FGV graduate with a PhD from Tel Aviv University, and his thesis is the stated origin of the model's architecture.

Before LUA, according to his LinkedIn, his background is heavy corporate consulting, Oracle EBS and ERP implementations at large companies, and he maintains a series of essays on AI on LinkedIn. Eronides handles the commercial side; before LUA he was [CRO of SoftwareOne Brasil](https://portalerp.com/br/noticia/eronides-junior-assume-a-posicao-de-cro-na-softwareone), after going through marketing, services and operations at the same company.

I'll repeat what I already said, and it counts double now that I've talked to them: I have no business relationship with LUA Vision. I'm not a partner, not an investor, I haven't signed a contract, I haven't signed an NDA, I've received nothing beyond the same free evaluation key from the previous test. Nothing in this post went through them before publishing. So far, I'm just a curious guy with an API in hand.

That last detail matters more than it seems. Since I signed no NDA, I never had access to any internal company data: no weights, no training recipe, no loss curves, no hardware bill. Everything below is black-box experimentation on the public API plus public information. Where I say "checked," I measured it; where I say "they say," it's their word.

## The new numbers: re-test after the fixes

After the first article, Paulo let me know he had fixed a few bugs in the API, the main one being precisely prompt caching, and asked me to run it again. I did. It's a clean, independent round of both tiers, on the same 14-sabotage protocol, with the original round preserved intact for side-by-side comparison. A methodological detail: v4 is a single-run benchmark, so the vigilance score is noisy, and I'll come back to that shortly.

Before running, I confirmed the cache was really there. A repeated-prefix probe on the endpoint returned `cached_tokens: 4121 / 4124` on the second call. In the original test, that number was always zero.

| Model | Score (original → re-test) | Never fixed (original → re-test) | Notional cost (original → re-test) | Wall |
|---|:---:|---|:---:|:---:|
| **Genesys PI House** | 83.5 → **95.5** (+12.0) | #7b, #8 → **none** | ~$460 → **~$70** (−85%) | 68m → 94m |
| **Genesys PI Enterprise** | 82.5 → **82.0** (−0.5) | #7a, #7b, #9 → #7b, #8 | ~$19 → **~$2.40** (−87%) | 39m → 33m |

What clearly and reproducibly improved:

- **Cost dropped 85% to 87%.** Token volume was the same, about 40 million on House and about 20 million on Enterprise, but repeated context is now billed at the cache rate instead of full input price. House goes from the most expensive run in the table to mid-cost.
- **Reliability.** Enterprise's original run needed a second attempt because of that `grep` loop in the first sprint. In the re-test, it converged first try. No loops on either model.
- **Test discipline.** The original Enterprise wrote no automated tests at all. In the re-test, it wrote a real RSpec suite, with model, request and system tests.
- **Earlier detection.** Both caught the loud sabotages (#1 to #3) by sprint 3, and House caught everything from #1 to #6 by sprint 4, something the original runs partly left for the capstone.

What can't be claimed is that the model got more vigilant. House went up 12 points, but Enterprise went down half a point in the same round. Since prompt caching has no way of affecting sabotage detection, two tiers of the same model moving in opposite directions is the picture of single-run variance.

House's +12 is large enough to suggest that Paulo's other fixes improved the model, but one run per model doesn't confirm that. To separate signal from noise I'd need three or more runs per model, which I didn't do.

To calibrate the size of that noise: this same week, GPT 5.5, which had 100.0 in the table, ran again with identical model and harness and closed at 91.0. Nine points of difference without changing anything. So treat vigilance scores as a range.

And the two silent survivors are still there. In House's re-test, the dropped index with no test guard (#7b) and the hidden aggregate (#8) were only fixed at the reveal; in Enterprise's, not even at the reveal. It's the same disguise blind spot most of the table has, frontier models included.

> **Keep in mind:** the caching bug is fixed and verified, and the cost reduction is real. The vigilance score stayed within noise: Enterprise flat, House up but without statistical confirmation. In the overall table, I kept the original runs as the official entries, precisely so as not to reward a single run.

### Pricing: not final yet, and it won't be per token

The cost figures above are still notional, computed on top of the example price list the API exposes, and LUA itself already said, in the previous article, that those are not market prices. Talking to Eronides, he laid out what's coming: they don't intend to charge per token, like everyone else does, and the product isn't meant to be B2C like the subscription chats. The bet is B2B, by usage license, with the model running on the customer's own infrastructure.

In practice, that means a company with a Grok-class model, capable of advanced tasks like programming, running on-premise, off the cloud, with the guarantee that no sensitive data leaves the building. Frontier models today are cloud services from foreign companies, and regulated sectors live uneasily with that. If LUA can deliver exactly that package, and the "if" is still big, it changes the game for a lot of Brazilian companies.

Even with the caveat that the per-token price is only an example, the notional cost next to the table helps calibrate. The cheapest complete runs in the entire field are DeepSeek V4 Flash ($0.97) and MiMo V2.5 Pro ($1.03); Enterprise, at ~$2.40, sits in that neighborhood. On the other side, Opus 5.5 cost $16.63, Sonnet 5 about $27 and GPT 5.5 $34.69. And House, which in the original round was the single most expensive run in the whole field, is now mid-pack.

The pricing policy, according to them, comes out on October 7, 2026.

## Extra experiment: Genesys PI auditing ai-jail

A sabotage benchmark measures vigilance inside a small, controlled app. I wanted to see the model on a real problem, so I gave it my [ai-jail](https://github.com/akitaonrails/ai-jail), the operating-system sandbox that runs coding agents inside bubblewrap, Landlock and seccomp on Linux and `sandbox-exec` on macOS. It's a Rust project, with 776 unit tests, 70 dependency crates and a security surface I know well. The task: a full security audit of version 2.3.0, read-only, with a threat model, line-level code evidence and reproduction where possible.

For a yardstick, I ran a second independent audit, with another model, with no access to Genesys's report until its own candidate list was fixed. Then I cross-checked the two reports and also compared them against two security advisories that were open on GitHub, written by outsiders against earlier versions of the project.

Genesys PI's report (I'll call it audit A) came with 26 findings: 5 High, 17 Medium, 3 Low and 1 informational. The second audit's (B) came with 12: 2 High, 7 Medium and 3 Low. The cross-check:

- **11 findings in common**, including the two Highs that really matter: forged worktree metadata that exposes any host directory for read and write, and duplicate environment entries that bypass credential isolation. Both were reproduced empirically by both audits, independently.
- **11 findings only in A**, among them the entire macOS surface (B had no Mac), the resource-exhaustion class in the egress proxy, and a cross-process audit-chain corruption that B had rejected only in the simplest case.
- **3 findings only in B**, one of them a relevant Medium that A didn't see: two test environment variables that survive in the release binary and switch off the SSRF protection and the TLS root validation.
- B rejected a real bug (a wrong-width comparison in a seccomp rule) and only confirmed it after A pointed it out. A made no equivalent mistake.

Against the external advisories, the score also favors A: of the five findings in the most serious advisory, A caught four and B caught two (plus one after A's lead). Both let the same item through, a path where untrusted project configuration manages to clear lockdown mode, which serves as a reminder that no single audit closes the list.

I'm not saying Genesys PI is the best security auditor there is; it was a comparison of two models, on one project, in one run. I'm saying that, on real code, with a real threat, it produced the stronger of the two reports, with calibrated severity and empirical reproduction of the critical items, and I'm going to fix its list. That's more than I expected to see from a model most people have never heard of, and more than gpt-oss, which didn't even reach the end of the sabotage benchmark, would be in a position to do.

## The question everyone asked: is this a rebadged Qwen?

I'm not offended by the question, I asked it myself. Brazilian model, small team, frontier-range score: the cheapest hypothesis is that there's another model underneath. The three versions of the suspicion that reached me were: it's a Qwen or DeepSeek with a sticker; it's OpenAI's gpt-oss in different clothes; or the API is just a proxy to Claude or GPT.

The limit of all this comes before any result. In a black-box situation, with no access to weights, it's impossible to state with 100% certainty where a model came from. What you can do is exclude hypotheses. That's what I did, with a set of reproducible tests that are [in the benchmark repository](https://github.com/akitaonrails/llm-coding-benchmark), and then I asked Grok to review the method and the text as a hostile evaluator, to strip out any conclusion that was stronger than the data.

### The decisive test: the tokenizer

Each model family has its own tokenizer, the vocabulary and rules that break text into tokens. A fine-tune, a LoRA or a continued pre-train inherits the base model's tokenizer; you can't swap it without retraining from scratch. So the tokenizer works as a lineage fingerprint.

I measured how many tokens LUA's API charges for a battery of strings (Chinese, accented Portuguese, English, digit runs, emoji with ZWJ), cancelling out the system prompt they inject, and compared against reference tokenizers running locally: OpenAI's `o200k`, `cl100k`, Qwen, DeepSeek, Llama 3 and Mistral. The summed distance to LUA, in the final round of the test (`tokenizer_v2` in the repository):

- **o200k (OpenAI): 2**
- Llama 3: 68
- cl100k (GPT-4, Phi-4, DBRX): 134
- Qwen: 193
- DeepSeek: 255
- Mistral: 289

The strongest discriminators: Chinese packs the o200k way and not Qwen's tighter way, a digit run costs 67 tokens where Qwen and DeepSeek charge 200, and emoji with ZWJ matches only o200k.

In other words: **Genesys PI uses `o200k_base`, OpenAI's public tokenizer, with high confidence.** That kills the hypothesis of a rebadged Qwen, DeepSeek, Llama or Mistral, because none of them uses that vocabulary and no fine-tune could acquire it. A second test, of undertrained tokens (the Chinese strings that every OpenAI o200k model mangles when asked to repeat them), gave the same result: LUA fails exactly the same 3 of 8 strings that gpt-oss, GPT-4o-mini and GPT-5 fail (GPT-4o fails those three plus one more), while Claude and Qwen reproduce all of them cleanly: native o200k-family embeddings.

### It's not stock gpt-oss

gpt-oss, OpenAI's open model, is the only relevant public weight that uses the same vocabulary family, so it was the natural candidate. But gpt-oss serves with `o200k_harmony`, a variant that has its own special tokens (`<|channel|>`, `<|message|>` and the like) as single tokens. On LUA's API, each of those markers costs about 4 ordinary text tokens. The vocabulary is plain `o200k_base`, without the Harmony tokens.

That rules out gpt-oss served the standard way. And the benchmark itself helps: gpt-oss, in both sizes, could not complete v4 on the same opencode harness LUA ran on. The raw weights can't even build the app, while Genesys PI gets through all seven sprints, House in Tier A and Enterprise in Tier B. A light sticker on top of gpt-oss doesn't do that.

What this test does not exclude is someone taking the gpt-oss weights, stripping Harmony at serving time, putting a custom template on top and heavily retraining the agentic behavior. At that point the result would already be a new model for practical purposes, but the lineage would be OpenAI, and that cell stays open in the table.

### It's not a thin proxy to Claude or GPT

LUA's API rejects `temperature`, `top_p`, `n`, `presence_penalty` and `logprobs`, which OpenAI's classic chat API accepts, and also rejects `min_p`, `top_k` and `repetition_penalty`, which any vLLM server in front of an open model would accept. The HTTP headers are all `x-lua-*`, with no trace of OpenAI, Anthropic, Cloudflare or OpenRouter. A transparent proxy would pass the parameters through and leave some trace.

The benchmark reinforces this in a way I liked. If LUA were a passthrough of GPT 6 luna or GPT 5.5, it would inherit their strength on the silent sabotages: GPT 5.5 caught #7b and #8 unprompted, and so did luna.

LUA fails exactly those two items, stably, across the four runs I did. A proxy doesn't come out consistently weaker than the model behind it on one specific trait. That's the picture of a model with its own weaknesses.

There was one coincidence worth recording: of the roughly 40 models whose fix I checked, only two added a unique `LOWER(email)` index in the database when fixing sabotage #6. They were LUA and GPT 6 luna.

It's a rare convergence, but it's also the most complete fix possible, the kind of thing two careful models can arrive at on their own. And the two caught the item at different points in the run. It raises an eyebrow, but doesn't reach suspicion.

What stays open, though, is a thick wrapper, with plenty of its own logic, in front of a reasoning API. Their API accepts `reasoning_effort`, which is a control specific to OpenAI's reasoning models, and a silent 250,000-token context. That's compatible both with an in-house stack that copied OpenAI's interface and with a more elaborate wrapper. Black-box doesn't separate the two.

### What stays open: from scratch or distilled

Here's the limit no API test crosses. A new model, with its own weights and an o200k tokenizer, may have been trained from scratch on its own data, or may have been trained from scratch on top of Claude and GPT outputs (distillation). Both produce exactly the same observations I made.

I tried a similarity grid with 20 prompts against a panel of possible teachers, and the result was null: no teacher stood out on the two axes I managed to measure (the third axis, embedding similarity, stalled for lack of API credit and was left out), which is consistent with an in-house mix and also with a soup of traces from several teachers. "Not Qwen" doesn't become "trained from scratch."

### An inconsistency I need to record

LUA's published research, the paper *"O peso que você não escolheu"* ("The weight you didn't choose"), revolves around the "token tax," the extra cost an English-optimized tokenizer charges a language like Portuguese, which they measured across 31 languages. Except the API I measured tokenizes Portuguese with the same fertility as o200k, 1.31 tokens per English token, against 0.69 for a Portuguese-native tokenizer like Tucano.

In other words, the product I was given uses an English-optimized vocabulary, not a Portuguese-specific one. That says nothing about the model's lineage, and adopting o200k is the cheap, professional choice any small lab would make. But it's a point where the research material and the API are not telling the same story, and it's the first question I'm going to ask Paulo.

### Forensics scoreboard

| Hypothesis | Verdict | Confidence |
|---|---|---|
| Rebadged Qwen, DeepSeek, Llama or Mistral | Ruled out | High |
| gpt-oss served the standard way (Harmony) | Argued against | Medium-high |
| gpt-oss weights with Harmony stripped + custom template | Not excluded | — |
| Thin proxy to GPT or Claude | Argued against | Medium |
| Thick wrapper over a reasoning API | Not excluded | — |
| New model, own weights, public o200k tokenizer | Consistent with everything I measured | Medium |
| Trained from scratch versus distilled from a frontier model | Not separable black-box | — |

In one sentence: with high confidence, Genesys PI is not a rebadged Chinese model nor a Llama or Mistral fine-tune; with medium to medium-high confidence, the tests argue against stock gpt-oss and against a transparent proxy. Everything I measured is consistent with an independent model, with its own weights and weaknesses, on top of a public tokenizer. Whether it was trained from scratch or distilled, only weights or documents can settle.

### One more disclaimer: I only compared against what I tested

The reference panel has the OpenAI, Qwen, DeepSeek, Llama and Mistral tokenizers, and the behavior panel has GPT-4o, gpt-oss, GPT-5, Claude, Qwen, DeepSeek, Llama and Gemini. That covers the overwhelming majority of what runs in production today, but there are dozens of other open models I didn't compare. There's always a chance Genesys PI's relative is one of them and I missed it. "I found no correlation" means "I found none among those I tested," and nothing beyond that.

That said, look at the size of the effort it would take to fool this analysis. Someone would have to adopt OpenAI's tokenizer, mask the model's identity server-side in a way that resists prompt override, build their own gateway that rejects exactly the parameters an open-model server would accept, keep stable, distinctive weaknesses across four runs, and still complete a seven-sprint benchmark at frontier level. If this isn't a real model, the work of pretending it is would already be extraordinary. Past a certain point, a convincing fake of a model is indistinguishable from having a model.

## Now then: what LUA says it did

Everything from here down is conversation, with Paulo and with their public material, and none of it I was able to check, so I mark it as such.

Nobody can be blamed for being suspicious. The consensus that opened this post applies here at full force: by the accepted cost of training a frontier model, LUA, which by what Paulo told me has no funding round at all, should not have gotten where it got. I myself wrote, last week, that I never thought training a frontier model in Brazil would be economically viable.

Against that common sense, what I have in hand is a model that, by my black-box experimentation, looks new, with no kinship to any known open model, with no look of a proxy, and possibly something other than one more distillation. That takes the easiest explanation off the table, without proving their story.

What Paulo told me, and which lines up with a lot of what I've thought for a while:

- **Trillion-parameter models are more marketing than necessity.** His thesis, and mine, is that a smaller model with real agentic capability (solid tool calling, prompt caching, efficient attention over large context) is the winning combination. The cost math of my own benchmark points the same way: small, cheap models tying expensive ones is the table's pattern.
- **The reasoning peak is behind us.** We both think the GPT-4 generation and the first "o" models were where reasoning seemed best, still without agentic capability. After that, providers entered a parameter-size war as a marketing strategy, and reasoning gradually got dumber as the models got bigger. That's our opinion; I measured none of it.
- **A small model with reasoning and a decent agent gets to similar results.** That's what my benchmark shows when Genesys PI ties Grok and lands in the Kimi and DeepSeek range, and it's their central bet.
- **Training was done on off-the-shelf hardware, no CUDA.** Paulo says he trained on AMD and ARM64 hardware (MacBook included), in a few months, and that with funding it would be faster. That's the strongest claim of all, and the one I can least verify. Zero evidence either way; recorded as said.
- **Proprietary, unpublished architecture.** The public material talks about NCAS, a "brain-inspired" architecture with five training phases, and says the technical detail is under NDA. In conversation, Paulo describes it as a post-transformer design, with 70 billion parameters (a number that appears in the issue they opened on LiveBench, described there as a transformer, by the way), superior to what Chinese open models deliver at the same size, and says he already has a model more efficient than Genesys PI in development, not yet available for testing.

If all of this is true, the damage to the status quo is large. It breaks NVIDIA's monopoly on training and it breaks the lock frontier labs have on frontier models. A claim that size demands evidence that size, and I don't have it. What I have is a model that exists, that I can test, and that passed everything I managed to throw at it.

## Where I stand

Checked, by me:

- Genesys PI is a model that exists, responds and completes a hard benchmark in the Tier A and B range of my table, in two independent runs per tier;
- the caching bug was fixed and cost dropped 85%;
- the tokenizer is the public `o200k_base`, which rules out derivation from Qwen, DeepSeek, Llama and Mistral;
- the API doesn't behave like a transparent proxy and the model has its own, stable weaknesses;
- stock gpt-oss doesn't explain the result.

Not checked, and only their word:

- that the model was trained from scratch and not distilled;
- that the architecture is new and post-transformer;
- that training happened on off-the-shelf AMD and ARM64 hardware, no CUDA, in a few months;
- that a better model is on the way.

Open, and something I'm going to ask:

- how to reconcile the "token tax" narrative with an API that tokenizes Portuguese the same as o200k.

What would settle this for good is documents, not more prompts: the tokenizer file, the training recipe with token and compute counts, the initialization (random or continued from other weights), loss curves, and a held-out benchmark I run myself.

Until that arrives, my position is the one in the table above: a model that behaves like an independent one, on top of a public tokenizer, with an origin no outsider can certify. More than I expected from a company this size, less than their website sells.

And I need to record what doesn't fit in a table: these models are fascinating, and maybe the most intriguing thing I've tested in months. By everything the industry says, they shouldn't be possible, they shouldn't exist. But I tested them, extensively, with every black-box test I could put together, and I couldn't break the story. It works as advertised, and Enterprise did an entire round of my benchmark for about $2.40 notional, a fraction of what models in the same range cost.

Add that to what Eronides described, a usage license instead of tokens, the model running inside the company instead of in someone's cloud, and the picture is clear: a Grok-class model, on-premise, with no sensitive data leaking out. If they deliver that, it's a game-changer. Still curious, and now in a hurry to see what comes out in October.
