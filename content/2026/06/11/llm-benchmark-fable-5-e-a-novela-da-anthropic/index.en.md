---
title: "LLM Benchmark: Fable 5 and the Anthropic Soap Opera"
slug: "llm-benchmark-fable-5-anthropic-soap-opera"
date: '2026-06-11T14:00:00-03:00'
draft: false
translationKey: llm-benchmark-fable-5-anthropic-soap-opera
tags:
  - llm
  - benchmark
  - claude
  - anthropic
  - fable
  - mythos
  - ai
  - vibecoding
---

Anthropic shipped **Claude Fable 5** this week, and before we get to my benchmark numbers (spoiler: a technical tie with Opus), the whole soap opera deserves a retelling, because the context matters more than the model. And it's a good one, the whole nine yards: a secret model "too dangerous to release," a closed consortium of big tech, an IPO on the horizon, and aggressive marketing.

## The context: the pressure cooker

The frontier model companies are squeezed from both sides. On one side, they're competing with each other to train the next big model that beats the previous one. On the other, demand for **inference** exploded. The curve flipped: according to [Deloitte](https://www.deloitte.com/us/en/insights/industry/technology/technology-media-and-telecom-predictions/2026/compute-power-ai.html), in 2023 inference was about **a third** of all AI compute; by 2025 it was half; in 2026 it's already **two-thirds**, [heading toward ~70% by 2030](https://www.computerworld.com/article/4114579/ces-2026-ai-compute-sees-a-shift-from-training-to-inference.html). Two years ago most data centers existed to train new models. Today most of them exist to serve you and me chatting with chatbots and running coding agents.

Add to that the diminishing returns of training. Doubling parameters and training compute buys you what, 10%, 20% of perceived improvement? The next order-of-magnitude jump got too expensive at exactly the moment compute got scarce.

And the infrastructure squeezes even harder. Alphabet, Amazon, Meta, and Microsoft are expected to spend more than [**$650 billion in 2026**](https://www.tomshardware.com/tech-industry/artificial-intelligence/half-of-planned-us-data-center-builds-have-been-delayed-or-canceled-growth-limited-by-shortages-of-power-infrastructure-and-parts-from-china-the-ai-build-out-flips-the-breakers) expanding AI capacity. The money exists; the problem is it takes forever to turn into buildings: [nearly half of the US data centers planned for 2026 have been delayed or canceled](https://www.techradar.com/pro/if-one-piece-of-your-supply-chain-is-delayed-then-your-whole-project-cant-deliver-nearly-half-of-us-data-centers-planned-for-2026-canceled-or-delayed-and-things-could-soon-get-much-worse), about 7 GW out of the 12 GW announced. The bottleneck became transformers, switchgear, and batteries, electrical components heavily dependent on China, with substation transformer lead times [now past 160 weeks](https://theoutpost.ai/news-story/america-s-ai-build-out-stumbles-on-electrical-parts-shortage-and-china-dependency-25093/). Three years in line for one part. It won't be raining new data centers anytime soon.

The logical conclusion of that math: if you can't train the next monster, optimize what you already have. And that's exactly what OpenAI and Anthropic have been doing. GPT 5 got steady upgrades: 5.1, 5.2, 5.3, 5.4, 5.5. Opus went from the excellent 4.5 to 4.6, 4.7, 4.8. Each new version with mixed results, sometimes a bit better, sometimes a bit worse, because the main goal became serving more people on the same hardware, with "more intelligence" waiting in line behind that. They tweak reasoning depth, caching, system prompts. These are closed boxes, all we can do is guess. I documented this myself in [Part 3 of the benchmark](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/): Opus 4.7 got objectively better at code than 4.6 while the community complained (with reason) about its more token-thrifty behavior. Resource optimization looks exactly like that.

## The IPOs

Enter the financial ingredient. Anthropic [filed its confidential S-1 with the SEC on June 1](https://techcrunch.com/2026/06/08/following-anthropic-openai-files-confidentially-for-ipo/), after a $65 billion Series H that valued the company at ~$965 billion. OpenAI [filed its own one week later](https://techcrunch.com/2026/06/08/following-anthropic-openai-files-confidentially-for-ipo/), on June 8. Dates? Officially there are none: a confidential filing means the timeline depends on SEC review and the market's mood. There's [speculation about a late-October window](https://www.thinkmarkets.com/en/anthropic-ipo-2026-date-valuation-and-how-to-trade/) for Anthropic, but that's a brokerage projection, unofficial data. What you can say for sure: [both are in line, together, right now](https://www.cnn.com/2026/06/09/tech/openai-ipo-anthropic-wall-street).

And a company on the verge of an IPO wants to show a user growth curve. So the game is to onboard as many new customers as possible, heavily subsidizing prices, while managing the data center shortage. Hold that contradiction in your head: they need usage to grow at a moment when serving existing usage is already tight.

## The Mythos soap opera

That's the backdrop against which Anthropic embarked on an aggressive marketing campaign around the **Mythos** model. The chronology:

On April 7, Anthropic [announced Claude Mythos Preview](https://red.anthropic.com/2026/mythos-preview/), a frontier model that it decided **not to release publicly** for being "too dangerous." The claim: Mythos had found thousands of high-severity vulnerabilities, including in every relevant operating system and browser. The numbers published later: [23,000 potential vulnerabilities across 1,000 open source projects, of which 1,726 confirmed, more than 1,000 rated high or critical severity](https://www.securityweek.com/anthropic-mythos-detected-23000-potential-vulnerabilities-across-1000-oss-projects/amp/).

Instead of releasing it, they created [**Project Glasswing**](https://www.anthropic.com/glasswing): a closed consortium of 40+ giant companies (Apple, Amazon, Microsoft, Google, NVIDIA, Cisco, JPMorganChase, the Linux Foundation, CrowdStrike, Palo Alto Networks) with exclusive access to the model to find and fix vulnerabilities in their own systems **before** the public launch. In other words: big tech got months of head start to armor up against a capability the rest of the world can't even test.

The reception was split. [CNBC described a cybersecurity "hysteria"](https://www.cnbc.com/2026/05/08/anthropic-mythos-ai-cybersecurity-banks.html) at banks and corporations, with experts pointing out that this class of threat existed before the announcement. Columnists started asking [whether Mythos is actually dangerous or just inflated hype](https://torment-nexus.mathewingram.com/anthropics-new-mythos-model-dangerous-or-over-hyped/), and [Puck raised the obvious question](https://puck.news/is-anthropics-mythos-model-as-dangerous-as-everyone-says/): a pre-IPO company has every incentive in the world to inflate the perceived capability of its own product. To complete the soap opera, [an unauthorized group gained access to Mythos](https://cybersecuritynews.com/anthropic-mythos-access/) through a third-party vendor's environment. The model too dangerous to release leaked out the back door.

Look at the shape of the thing: a model nobody outside can test, with capability claims nobody can verify, guarded by a consortium under NDA. We don't even know for sure what Mythos is. Whether it's a new model trained from scratch (and in that case, where did the compute come from, in the data center drought I just described?), whether it's an Opus with a heavy arsenal of offensive security tooling wrapped around it, whether it's something else. All we can do is speculate, and that's exactly how hype works.

## Fable 5: the "safe Mythos"

On June 9, [Anthropic released **Claude Fable 5**](https://www.anthropic.com/news/claude-fable-5-mythos-5), which it describes as a "Mythos-class" model safe for public release. In the same breath, it announced **Mythos 5**: [the same model without the locks, available only to the Glasswing consortium](https://www.bloomberg.com/news/articles/2026-06-09/anthropic-releases-mythos-like-model-without-cyber-capabilities). What is Fable on the inside? An Opus distilled with Mythos? A lobotomized Mythos? Closed box, no technical paper, guess again.

The safety mechanism is a curious one: queries touching cybersecurity exploitation, bio/chem weapons, or model distillation get blocked at the model level and [**rerouted to Opus 4.8**](https://www.itpro.com/technology/artificial-intelligence/anthropic-just-launched-claude-fable-5-its-first-mythos-class-ai-model-but-it-has-new-safeguards-to-prevent-misuse-and-will-fall-back-to-opus-4-8-for-high-risk-queries), something Anthropic estimates will trigger in under 5% of sessions.

In practice, the safeguards shipped tuned way too strict. The Register published a test with the priceless headline ["It blocked us at 'hello!'"](https://www.theregister.com/ai-and-ml/2026/06/10/anthropic-claude-fable-5-refuses-innocuous-prompts/5253754), documenting refusals of innocuous prompts, and [the internet is justifiably furious](https://decrypt.co/370688/internet-furious-anthropic-claude-mythos-fable-5). I ran into it firsthand: asking Fable to **audit the security of my own source code** can trip the "too dangerous" lock and fall back to Opus. A security researcher asking for an audit of his own source code is exactly the use case a "safe Mythos" should serve, and it's the one it refuses. Anthropic [promised to reduce the false positives](https://www.cnbc.com/2026/06/09/anthropic-mythos-claude-fable-5.html) "as quickly as we can."

And the net effect of all this? More hype for Mythos. Every Fable refusal becomes involuntary advertising for the forbidden sibling: "look at that, it's so dangerous even the neutered version won't go there." My read, and this is shameless opinion, pure speculation on my part: I actually **believe** Mythos is better than Opus. But the campaign is so aggressive it created an expectation no real model can meet. When Mythos finally ships, it will be judged against the myth Anthropic itself built, and myths don't lose benchmarks. Smells like a shot in the foot. My bet: Mythos only comes out after the IPO, and releases like Fable exist to keep the fire burning until then. Remember the math above: we've been months without compute for an order-of-magnitude jump. When exactly would they have allocated training for such a revolutionary model? The numbers don't add up easily.

## What we can actually test: Fable 5 in the benchmark

Enough soap opera, on to what matters. I updated [my coding benchmark](https://github.com/akitaonrails/llm-coding-benchmark) to include Fable 5 (snapshot `claude-5-fable-20260609`, $10/M input and $50/M output, the most expensive Claude run to date). Same task as always: autonomously build a chat app in Rails 8 + RubyLLM + Hotwire + Docker, with tests and CI, audited against the 8-dimension rubric. If you don't know the methodology, it's in [Part 3](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) and the [follow-up updates](/en/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/).

Result: **94/100, Tier A, #5 in the ranking**. One point under Opus 4.8 (95), three under Opus 4.7 (97). Just as I suspected: within the margin of error. A technical tie with its own family.

But the audit report has details worth logging, because Fable did things no other model has done:

- **It grepped the gem's source code mid-run.** Before writing the integration, Fable literally opened the installed `ruby_llm` 1.16.0 source ("Now let me verify the real RubyLLM 1.16 API from the installed gem source") and verified the real API. It's the only model I've ever observed performing, on its own, the verification step my audit does. Zero API hallucination, obviously.
- **36 tests across 7 files, 99.3% line coverage, 100% branch.** A `FakeChat` with exact signatures, error path and missing-key path both tested.
- **It fixed both of Opus 4.8's deductions**: capped history (`MAX_MESSAGES_PER_CONVERSATION = 200`, LRU eviction) and an explicit `OPENROUTER_API_KEY` preflight with a friendly error.
- **Phase 2 with zero fixes**: local boot, Docker build, compose healthcheck, and a live end-to-end chat, all on the first try.

And then comes the stumble that holds it at #5: **persistence in a process-local singleton**. The `Chat::ConversationStore` is thread-safe and capped, but history dies on restart and breaks under multi-worker Puma. The rubric scores that below Opus 4.8's session cookie. Stronger engineering in almost everything, taken down by one architecture decision that 4.8 got right.

A methodological detail I insist on disclosing: the session that audited the projects was itself running on Fable 5. To eliminate the risk of self-favoritism, the 4.8-vs-Fable ordering was confirmed in a **blind head-to-head**, with an independent judge and anonymized projects: 19 to 18 on the contested dimensions, with the judge noting that Fable's test suite is actually the stronger of the two, and that a single change (backing `ConversationStore` with `Rails.cache` instead of an in-memory hash) would flip the ranking. That's the size of the difference: one line of architecture.

### How this compares to Opus's own version-to-version variation

Look at the Claude family in the benchmark: Opus 4.6 scored 83, 4.7 jumped to 97, 4.8 dipped to 95, and now Fable 5 enters at 94, costing ~$11 per run against ~$1.10 for Opus. **10× the price for one point less.** The variation across 4.6 → 4.7 → 4.8 was already bigger than the distance between 4.8 and Fable. Meaning: for my specific scenario, Anthropic's first public "Mythos-class" model delivers the same thing the existing Opus models already delivered, with genuinely impressive engineering flourishes (the gem-source grep is the kind of behavior that made me raise an eyebrow) that don't translate into score because the mistakes that matter are elsewhere.

Maybe Fable is far better at other tasks. Its marketing is all about security analysis capability, and that capability is literally blocked in the public version (when it isn't busy blocking "hello"). On what can be measured here, it's a more expensive Opus.

## Updated ranking

Fable in bold, everything else as it was:

| Rank | Model | Score | Tier | RubyLLM OK | Time | Cost |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | 97 | A | ✅ | 22m | ~$16 |
| 3 | GPT 5.5 xHigh (Codex) | 96 | A | ✅ | 18m | ~$10 |
| 4 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$1.10 |
| **5** | **Claude Fable 5** | **94** | **A** | ✅ | **24m** | **~$11 (est.)** |
| 6 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$0.30 |
| 7 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 |
| 8 | Gemini 3.1 Pro | 82 | A | ✅ | 14m | ~$0.40 |
| 9 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 |
| 9 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 9 | MiniMax M3 | 78 | B | ✅ | 53m (phase 2 DNF) | ~$0.10 |
| 12 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.74 |
| 13 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 |
| 14 | DeepSeek V4 Pro \* | 69 | B | ✅ | 22m (DNF) | ~$0.50 |
| 14 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0.10 |
| 16 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.14 |
| 17 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 |
| 18 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 |
| 19 | Qwen 3.5 35B (local) | 55 | C | ✅ | 28m | free |
| 20 | GLM 4.7 Flash bf16 (local) | 52 | C | ✅ | failed | free |
| 21 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 22 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 |
| 23 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 |
| 24 | Qwen 3.5 122B (local) | 37 | D | ❌ | 43m | free |
| 25 | Qwen 3 Coder Next (local) | 32 | D | ❌ | 17m | free |
| 26 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.60 |
| 27 | GPT OSS 20B (local) | 11 | D | ❌ | failed | free |

\* DeepSeek V4 Pro only reaches Tier A (89/100) via DeepClaude. The story is in the [dedicated post](/en/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/).

## Conclusion

The soap opera continues, and I'll keep watching with popcorn. If Mythos exists as advertised, and if it ever leaves the Glasswing bubble, I'll put it through this same benchmark the next day. Until then, what we have is a Fable 5 that ties with Opus on what can be measured, costs 10× more, and refuses the very tasks where it's supposedly revolutionary.

As always, the benchmark is open: [github.com/akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). Want to see another model in there? Fork it, add an entry to `config/models.json`, run it, and send the PR.

And the practical recommendation stays identical to the [previous posts](/en/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/): for programming, by default, Opus and/or GPT (I use both simultaneously). Fable doesn't change that math. So far, the only thing it provably does better than Opus is marketing.
