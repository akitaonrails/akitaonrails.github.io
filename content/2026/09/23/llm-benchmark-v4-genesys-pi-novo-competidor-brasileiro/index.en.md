---
title: "LLM Benchmark v4: Genesys PI, a New Brazilian Contender!"
slug: "llm-benchmark-v4-genesys-pi-new-brazilian-contender"
date: '2026-09-23T18:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-genesys-pi-novo-competidor-brasileiro
description: "LUA Vision reached out on LinkedIn offering test access to Genesys PI, a Brazilian model trained from scratch. I ran both tiers, House and Enterprise, through my v4 sabotage benchmark, compared them against Opus, GPT-6, Grok and the Chinese competition, and looked at price, advantages and where it makes sense in the Brazilian market."
tags:
- llm-benchmarks
- llms
- coding-agents
---

Some folks from [LUA Vision](https://lua.vision/), the Brazilian company behind Genesys PI, reached out on LinkedIn offering test access to their model. That kind of thing usually doesn't interest me, but this particular pitch, a Brazilian lab training a model from scratch instead of reselling a foreign model with a Portuguese layer on top, made me curious enough to run the test myself.

Let me get the disclaimer out of the way first. Nobody paid me anything to write this. There is no business relationship between me and LUA Vision. Nothing written here was approved, reviewed or suggested by them before publishing. Every word is mine. The only courtesy I got was a free evaluation access key to run the test, and I explain what that means for the cost math further down.

I published [an update to my v4 benchmark's main table](/en/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/) earlier today, with five new models. This post is a direct addendum to that one: I ran Genesys PI on both tiers LUA Vision offers, House and Enterprise. With those two, the combined table reaches 46 models. Below I show only the stretch around the Brazilian models, which appear in **bold** at their actual positions.

## The updated table, with Genesys PI in it

| Rank | Model | Score | Tier | Never-fixed | Cost | Wall | Harness |
|-----:|-------|:-----:|:----:|------------------|:----:|:----:|:-------:|
| ... | ... | ... | ... | ... | ... | ... | ... |
| 32 | GLM 5.3 Flash (zcode) | 84.25 | A | — | flat-rate plan | 296m | zcode |
| 33 | DeepSeek V4 Pro 0813 | 84.0 | A | items #8, #9 (4) | $4.49 | 152m | opencode |
| 34 | Step 3.7 Flash | 83.75 | A | items #6, #8, #11 (6.5) | $4.15 | 118m | opencode |
| 35 | Grok 4.7 | 83.5 | A | — | $27.94 | 120m | opencode |
| 35 | **Genesys PI House (LUA Vision)** | 83.5 | A | items #7b, #8 (3) | ~$460 ᵉ | 68m | opencode |
| 37 | **Genesys PI Enterprise (LUA Vision)** | 82.5 | B | items #7a, #7b, #9 (4) | ~$19 ᵉ | 39m | opencode |
| 38 | DeepSeek V4 Pro (base) ᶜ | 82.0 | B | — | $5.26 | 97m | opencode |
| 39 | Qwen 3.8 27B (Strix Halo, local) | 80.0 | B | items #2, #7b, #8, #12 (8) | **$0 local** | 706m | opencode |
| 40 | Qwen 3.7 Max | 79.0 | B | items #6, #7, #8 (6) | $10.63 | 106m | opencode |
| 41 | GLM 5.2 (zcode) ᶜ | 77.0 | B | item #12 (2) | flat-rate plan | 239m | zcode |
| ... | ... | ... | ... | ... | ... | ... | ... |

> For the full table, with every other model, read [my previous article](/en/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/).

Genesys PI House ties Grok 4.7 exactly at 83.5, Tier A. Enterprise lands one step below, at 82.5, Tier B. If you want the methodology recap, real CVE-based sabotage planted across seven sprints, never announced, with full marks only for catching it unprompted, it's all laid out in [Part 1](/en/2026/09/15/new-llm-benchmark-v4-retesting-all-top-llms-part-1/) and in [today's update](/en/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/).

## Who LUA Vision is

[LUA Vision Tecnologia Ltda.](https://lua.vision/empresa/) is a São Paulo company, founded in late 2025 after three years of doctoral research (2022 to 2025) by Paulo Câmara, co-founder and CTO, an FGV graduate with a PhD from Tel Aviv University. His thesis, *"From Neurodivergent Cognition to Natural Intelligence"*, is the stated origin of the architecture that became Genesys PI. The other three co-founders are David Kang (CEO, strategy and partnerships), Plínio Ceccon (CFO) and Eronides Jr. (CRO, commercial and revenue).

The Genesys PI model family launched in April 2026. The company describes its own bet as deliberately risky: build a proprietary model trained for the reality of Brazil and other emerging markets, instead of reselling a foreign model with a Portuguese layer on top.

Their core argument is that a model trained abroad doesn't really understand the Brazilian legal structure, the CLT versus PJ distinction (salaried employee versus contractor), or the local tax and financial structure, and that this matters a lot in regulated sectors: healthcare, law, finance, education. The company currently runs about twenty pilot projects in those sectors, plus a consumer product line called [8th.vision](https://8th.vision).

On the technical side, they call their architecture NCAS and talk about five training phases "inspired by neural development", plus a self-monitoring module called PI-Probe that abstains from answering when the model doesn't have enough grounding to respond. [They published two papers of their own on Zenodo](https://lua.vision/pesquisa/): *["The weight you didn't choose"](https://doi.org/10.5281/zenodo.22899767)*, on the cost of tokenization across 31 languages, and *["Maximum capacity is not maximum efficiency"](https://doi.org/10.5281/zenodo.22881788)*, which introduces their own metric called the Synaptic Efficiency Coefficient. Both DOIs exist and resolve, but some context matters: Zenodo is a preprint repository, not a peer-reviewed journal, so treat these as self-published research rather than outside validation.

LUA Vision also [opened a public issue on the LiveBench repository](https://github.com/LiveBench/LiveBench/issues/370) asking for their model to be added to the official leaderboard, with a self-reported score climbing from 87.6% (November 2024, a thousand questions, with coding as the weak spot at 34.4%) to 98.2% (January 2026, 682 questions). Worth noting: the issue was opened in March 2026, a month before Genesys PI's official launch, and its title uses the name "Lua Genesys," not "Genesys PI," so I treat it as the same NCAS engine under an earlier label, not a direct, dated confirmation of the product I tested. The issue is still open, and its only comment is LUA Vision's own CEO praising the company's own post, with no maintainer confirming or rejecting the number as of this writing. In other words, the LiveBench score in their marketing is self-reported, not a verified official ranking.

## How Genesys PI did against the frontier and the Chinese competition

For anyone who just wants to know where it sits on the scale: Genesys PI House ties Grok 4.7 exactly (83.5), in the middle of a very tight pack. It falls behind:

- the whole frontier that closed at 100 (Astra, Opus 5, Opus 5.5, GPT 5.6 sol/terra, GPT 5.5, Fable 5);
- GPT 6 luna (95.5) and GPT 6 sol (91.0);
- GLM 5.3 (94.0);
- China's MiMo V2.6 Pro (92.0);
- Claude Sonnet 5 (91.0);
- both Gemini 3.8 Flash routes (89.5 and 90.5);
- both Kimis, K2.7 (87.25) and K3 (85.0);
- the pack right above it: Step 3.7 Flash (83.75), DeepSeek V4 Pro 0813 (84.0) and GLM 5.3 Flash (84.25);
- and roughly twenty more models scattered across this score range, from Grok 4.6 (98.5) to Claude Sonnet 4.6 (85.75), including three Claude tiers (Opus 4.6, Opus 4.8, Sonnet 4.6). In total, House falls behind 34 of the table's 46 models.

And it beats GLM 5.2 (77.0), the previous-generation Gemini 3.7 Flash, MiniMax M3, and the whole bottom of the table. Enterprise (82.5) lands one step below its own House sibling, in the same general range.

If the expectation that reached you is Claude-level, recalibrate before any purchasing decision. In this particular test, Genesys PI House sits in Grok 4.7 territory, well below the Claude flagships.

Claude Sonnet 5, the cheapest of the three Claude tiers I ran, already closes at 91.0, eight and a half points higher. Opus 5, Opus 5.5 and Fable 5 close at the absolute top, 100.0.

None of that takes away from a small Brazilian team reaching Grok's level, a lab that ranks among the best-funded in the world. It's just the right yardstick.

House's error profile is the classic "detection follows disguise": it caught every obvious sabotage on its own, both critical items, the IDOR, the hardcoded key, the CORS, both gem CVEs. It even caught the item that survives longest in the whole test (#6) at the reveal, with a fix that went beyond what was asked, a unique database index. It just never fixed two silent items, the dropped index (#7b) and the wrong aggregate (#8), not even after being told.

Enterprise got to the same count of items caught unprompted (31 of 40) by a different route, catching less sabotage along the way and recovering a big block of eight items at once in the capstone. It ended with three items never fixed, including a deleted view (#9) it never restored because there was no test covering reports or users to flag the error.

One reliability note worth recording: Enterprise's first attempt got stuck in a stochastic loop, repeating the same grep command in 841 of 857 tool calls, confusing its own name "LUA" with the name of the RubyLLM gem, and had to be aborted at the 90-minute limit without a single commit. I ran it again and the second attempt converged cleanly in 7 minutes. I treat that as a one-off instability rather than a pattern, but it's the kind of thing anyone testing in production needs to watch.

## Price and cost: where the math gets tight

Here's the second disclaimer I promised: LUA Vision gave me a free evaluation key for both tests, so I personally paid nothing. But the whole benchmark compares cost for whoever actually pays, so I recalculated the notional price a paying customer would face, using the price list their API exposes to anyone with an access key (the `/v1/models` endpoint), converted from reais to dollars at the rate at the time (5.16 BRL/USD).

The per-million-token price of the two tiers is very different:

- **House**: R$ 55 input / R$ 275 output per million tokens;
- **Enterprise**: R$ 4 input / R$ 20 output per million tokens, about 13.75 times cheaper than House per token.

The House run's total cost came to about $460 notional, steep for an 83.5 score. The reason goes beyond the per-token price: their API has no prompt caching, so every step resends the whole accumulated context at full input price, and in a seven-sprint benchmark that accumulates context the entire time, that adds up fast. Enterprise, with a much lower per-token price, closed at about $19 notional for the same sabotage, going toe to toe with cheap options like Grok 4.5 ($6.19) or Claude Sonnet 4.6 ($18.64), only with a lower score than both.

> **Keep in mind:** if you're an actual Genesys PI customer, ask explicitly about prompt caching before running a long, cumulative workload like a coding agent. Without it, the flagship tier gets expensive fast, because of the repeated context resending more than the per-token price.

## Where Genesys PI fits in the Brazilian market

Putting it all together: Genesys PI isn't the most vigilant model in my test, nor the cheapest, nor the most reliable on the first try. But it isn't weak either. Tying Grok 4.7 and landing in the same score range as big names like Kimi K3, DeepSeek V4 Pro and GLM 5.3 Flash, with a model trained from scratch by a small team in São Paulo, on a fraction of the budget of an American or Chinese lab, is a genuine result.

> I always figured training a frontier model from scratch in Brazil wouldn't be economically viable; that kind of budget seemed reserved for labs with a billion dollars lying around. LUA Vision proved me wrong, and I want to be the first to admit it. I'd rather root for people who try and pull it off than hold on to an opinion the facts already knocked down.

The real advantage for a Brazilian company choosing Genesys PI lies in what my benchmark doesn't measure:

- familiarity with the Brazilian legal and tax structure, CLT versus PJ included;
- real Portuguese support, instead of machine translation on top of a foreign model;
- data sovereignty, everything processed and trained inside Brazil, which matters to regulated sectors that care about where data travels and who has access to it.

The downsides:

- the flagship tier's price without prompt caching, which hurts on long, cumulative workloads;
- the still-inconsistent reliability I saw in Enterprise;
- a self-reported LiveBench score that hasn't gone through any outside verification yet.

For a Brazilian company choosing between a foreign and a domestic provider, Genesys PI is already a real option to evaluate, more than a LinkedIn pitch promise. It's not yet the model I'd recommend with my eyes closed for heavy security vigilance, but I'm genuinely glad to see a Brazilian model trained from scratch, instead of a wrapper around a foreign one, showing up in my ranking and actually competing with big frontier names. I hope they keep improving, because Brazil wins with more real players in this game.

## Final disclaimer

Repeating it so there's no doubt: I have no stake in LUA Vision. I had no access to their financial data, or to anything other than the Genesys PI test key. So I can't vouch for anything beyond what I tested myself, which is what's in this post. For the business side of the company, you'll have to ask them directly.
