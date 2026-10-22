---
title: "LLM Benchmark v4: the open source verdict (as of Oct 2026)"
slug: "llm-benchmark-v4-the-open-source-verdict-as-of-oct-2026"
date: '2026-10-22T12:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-o-veredito-de-open-source-ate-out-2026
description: "The wrap-up of benchmark v4: almost 70 runs, almost 60 models, across cloud, B300, 4x B300, RTX 5090 and Strix Halo, and more than 6 thousand dollars spent. In a single table, 42 runs made Tier A, and the best open models I served myself (DeepSeek V4.1 Flash, GLM 5.3 Flash, Qwen3.8 Flash-Next) sit 7.5 points from the ceiling, right on Sonnet 5's heels. The Chinese labs climb 5.5 to 17 points per generation while the Western top is stalled in programming and spending its showcase on math. I recommend the best commercial models, the best open models for companies and for PCs, along with what I learned, and I close with my hypothesis on why expensive hardware holds open source back."
tags:
- llm-benchmarks
- local-models
- llms
- open-source
---

This is the wrap-up of benchmark v4. Since I started this round, there have been seven articles, first in the cloud and then pushing the same sabotage yardstick further and further away from it:

- **[Part 1](/en/2026/09/15/new-llm-benchmark-v4-retesting-all-top-llms-part-1/)**: why I rebuilt the benchmark from scratch for the third time, how the Rails app sabotaged with real CVEs works, and how much it cost.
- **[Part 2](/en/2026/09/15/new-llm-benchmark-v4-retesting-39-llms-part-2/)**: the original cloud ranking, with almost 40 models, six ties at the top and a free model beating half of the Claude lineup.
- **[Opus 5.5, GPT-6 sol and luna, MiMo 2.6 and Grok 4.7](/en/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/)**: the next cloud batch. Opus 5.5 closed at 100, GPT 6 luna scored 95.5 for under a dollar per run, and Grok 4.7 regressed against its own predecessor.
- **[The top open source LLMs on a B300](/en/2026/10/19/llm-benchmark-v4-the-top-open-source-llms-on-a-b300/)**: one rented GPU, 14 open models, and two of them, GLM 5.3 Flash and Qwen3.8 Flash-Next, tied at 92.5, on par with Sonnet 5.
- **[Open source that only fits in 4x B300](/en/2026/10/22/llm-benchmark-v4-open-source-that-only-fits-in-4x-b300/)**: the big models, most of them between 400 billion and 1 trillion parameters. DeepSeek V4.1 Flash tied the leader at 92.5 and the rest showed that size doesn't buy vigilance.
- **[Can my team fit in 4x B300/H200?](/en/2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/)**: a real concurrency test. The same DeepSeek serves 32 comfortable sessions on the B300 pod and only 8 on the H200 one.
- **[Consumer-grade open source on RTX 5090 or Strix Halo](/en/2026/10/22/llm-benchmark-v4-consumer-open-source-rtx5090-strix-halo-strata/)**: Qwen3.8 Flash-Next scored 91 on a PC card with the Strata engine, at 159 tokens per second.

This article puts everything in a single table and answers the question left over: **as of October 2026, is open source good enough?**

## The biggest benchmark I've ever run

v4 was, by far, the biggest round of testing I've ever done. That's almost 70 complete runs of the same protocol, almost 60 different models, running on cloud APIs, on a rented B300, on a four-B300 pod, on an RTX 5090 and on a Strix Halo, plus a four-H200 pod just for the concurrency test.

And it was expensive. The first batch alone, the cloud one, went past 4 thousand dollars in nine days, counting credits and subscriptions. The single B300 cost about 270, and the 4x B300 and 4x H200 campaign took about another 2,100. Adding up what I can add up, it went past 6 thousand dollars, not counting machine hours at home.

> I don't think many people are going to reproduce this any time soon. If this material was useful to you, share it with whoever needs to decide between cloud, their own server or a local PC. All the code, prompts, logs and reports are open on my GitHub: [akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark).

### A refresher on the yardstick

The protocol is always the same. The model builds a Rails chat app in seven sprints, and between sprints a reviewer injects 14 security and correctness defects, some loud (a CVE in a gem, a key in the code), others silent (a cross-tenant leak, a wrong aggregate, a test tampered with to hide a backdoor).

The score goes from 0 to 100. A defect fixed unprompted counts at full weight; fixed only after I reveal there's a problem, it counts 40%; never fixed counts zero. The tiers are A from 83 up, B from 73 to 82.5, C from 51 to 72.5 and D up to 50.

It's a yardstick for **code review vigilance**. It measures whether the model notices sabotage while it works, and that is different from measuring who writes your whole system better.

## The combined ranking

Every v4 run in a single table, commercial and open, cloud and my own hardware. When the same model ran in different places, it shows up more than once, because the place changes the score.

| # | Model | Weights | Where it ran | Score | Tier | Cost per run | tok/s | Minutes |
| ---: | --- | --- | --- | ---: | :---: | ---: | ---: | ---: |
| 1 | GPT-6 Astra | closed | Cloud (Codex) | 100.0 | A | US$ 30.55 | — | 100 |
| 1 | Claude Opus 5 | closed | Cloud (Claude Code) | 100.0 | A | ~US$ 71 ¹ | — | 145 |
| 1 | Claude Fable 5 | closed | Cloud (Claude Code) | 100.0 | A | ~US$ 50 ¹ | — | 85 |
| 1 | Claude Opus 5.5 | closed | Cloud (Claude Code) | 100.0 | A | US$ 16.63 ¹ | — | 64 |
| 1 | GPT 5.6 sol | closed | Cloud (Codex) | 100.0 | A | US$ 20.37 | — | 317 |
| 1 | GPT 5.6 terra | closed | Cloud (Codex) | 100.0 | A | US$ 9.52 | — | 80 |
| 1 | GPT 5.5 | closed | Cloud (Codex) | 100.0 | A | US$ 34.69 | — | 117 |
| 8 | Grok 4.6 | closed | Cloud (OpenCode) | 98.5 | A | US$ 13.00 | — | 67 |
| 9 | Claude Fable 5.1 | closed | Cloud (Claude Code) | 95.5 | A | ~US$ 51 ¹ | — | 133 |
| 9 | Sakana Fugu Ultra v2 | closed | Cloud (OpenCode) | 95.5 | A | US$ 122.01 | — | 294 |
| 9 | GPT 6 luna | closed | Cloud (Codex) | 95.5 | A | ~US$ 0.84 ² | — | 122 |
| 12 | GPT 5.6 luna | closed | Cloud (Codex) | 95.0 | A | US$ 10.04 | — | 123 |
| 13 | Nex N2.5 Pro ⁴ | open | Cloud (OpenCode) | 94.0 | A | free | — | 480 |
| 13 | GLM 5.3 | open | Cloud (ZCode) | 94.0 | A | flat plan | — | 215 |
| 15 | DeepSeek V4.1 Flash | open | Cloud (OpenCode) | 92.5 | A | US$ 1.21 | — | 172 |
| 15 | DeepSeek V4.1 Flash | open | 4x B300 | 92.5 | A | pod at US$ 36/h | 174.8 | — |
| 15 | GLM 5.3 Flash (NVFP4) | open | 1x B300 | 92.5 | A | US$ 21.96 ³ | 142.0 | 145 |
| 15 | Qwen3.8 Flash-Next (NVFP4) | open | 1x B300 | 92.5 | A | US$ 12.04 ³ | 195.0 | 80 |
| 19 | MiMo V2.6 Pro | open | Cloud (OpenCode) | 92.0 | A | US$ 1.22 | — | 308 |
| 20 | Qwen3.8 Flash-Next (IQ3_S) | open | RTX 5090 (Strata) | 91.0 | A | US$ 0 (local) | 159.2 | — |
| 20 | Claude Sonnet 5 | closed | Cloud (Claude Code) | 91.0 | A | ~US$ 27 ¹ | — | 112 |
| 20 | GPT 6 sol | closed | Cloud (Codex) | 91.0 | A | ~US$ 8.35 ² | — | 73 |
| 23 | Gemini 3.8 Flash high | closed | Cloud (OpenCode) | 90.5 | A | US$ 15.98 | — | 97 |
| 24 | Gemini 3.8 Flash | closed | Cloud (Antigravity) | 89.5 | A | free (OAuth) | — | 120 |
| 24 | MiniMax M3.1 Flash | closed | Cloud (OpenCode) | 89.5 | A | free | — | — |
| 26 | Muse Spark 1.3 | closed | Cloud (OpenCode) | 88.75 | A | US$ 13.31 | — | 150 |
| 27 | Swift 1.5 27B | open | 1x B300 | 88.0 | A | US$ 9.71 ³ | 203.0 | 64 |
| 27 | Grok 4.5 | closed | Cloud (OpenCode) | 88.0 | A | US$ 6.19 | — | 48 |
| 29 | Claude Opus 4.6 | closed | Cloud (Claude Code) | 87.5 | A | US$ 25.64 ¹ | — | 89 |
| 30 | Kimi K2.7 Code | open | Cloud (Kimi CLI) | 87.25 | A | US$ 7.75 | — | 175 |
| 31 | MiMo V2.5 Pro | open | Cloud (OpenCode) | 86.5 | A | US$ 1.03 | — | 158 |
| 31 | Qwen3.8 Flash | closed | Cloud (OpenCode) | 86.5 | A | US$ 1.17 | — | 149 |
| 33 | DeepSeek V4 Flash | open | Cloud (OpenCode) | 86.0 | A | US$ 0.97 | — | 111 |
| 33 | Claude Opus 4.8 | closed | Cloud (Claude Code) | 86.0 | A | ~US$ 37 ¹ | — | 87 |
| 35 | Claude Sonnet 4.6 | closed | Cloud (Claude Code) | 85.75 | A | US$ 18.64 ¹ | — | 91 |
| 36 | Kimi K3 | open | Cloud (Kimi CLI) | 85.0 | A | US$ 13.79 | — | 148 |
| 36 | DeepSeek V4 Flash 0731 | open | Cloud (OpenCode) | 85.0 | A | US$ 1.94 | — | 194 |
| 38 | GLM 5.3 Flash | open | Cloud (ZCode) | 84.25 | A | flat plan | — | 296 |
| 39 | DeepSeek V4 Pro 0813 | open | Cloud (OpenCode) | 84.0 | A | US$ 4.49 | — | 152 |
| 40 | Step 3.7 Flash | open | Cloud (OpenCode) | 83.75 | A | US$ 4.15 | — | 118 |
| 41 | Grok 4.7 | closed | Cloud (OpenCode) | 83.5 | A | US$ 27.94 | — | 120 |
| 42 | ThinkingCap 3.8 27B | open | 1x B300 | 83.0 | A | US$ 11.47 ³ | 189.0 | 76 |
| 43 | DeepSeek V4 Pro | open | Cloud (OpenCode) | 82.0 | B | US$ 5.26 | — | 97 |
| 44 | Muse Glimmer 30B | open | 1x B300 | 81.0 | B | US$ 3.54 ³ | 295.0 | 23 |
| 44 | Ornith 1.5 35B | open | 1x B300 | 81.0 | B | US$ 24.39 ³ | 317.0 | 161 |
| 46 | Qwen 3.8 27B | open | 1x B300 | 80.5 | B | US$ 29.11 ³ | 195.0 | 192 |
| 47 | Qwen 3.8 27B (Q8_0) | open | Strix Halo | 80.0 | B | US$ 0 (local) | 7.7 | 706 |
| 48 | Qwen 3.7 Max | closed | Cloud (OpenCode) | 79.0 | B | US$ 10.63 | — | 106 |
| 49 | GLM 5.2 | open | Cloud (ZCode) | 77.0 | B | flat plan | — | 239 |
| 50 | GLM 5.3 full | open | 4x B300 | 76.0 | B | pod at US$ 36/h | 110.0 | — |
| 51 | Gemini 3.7 Flash high | closed | Cloud (OpenCode) | 75.5 | B | US$ 12.93 | — | 85 |
| 51 | MiniMax M3 | open | Cloud (OpenCode) | 75.5 | B | US$ 12.17 | — | 187 |
| 53 | Ornith 1.5 122B | open | 4x B300 | 73.0 | B | pod at US$ 36/h | 244.2 | — |
| 54 | Step-5-Preview | open | 4x B300 | 72.5 | C | pod at US$ 36/h | 165.9 | — |
| 55 | Muse Spark Open | open | 4x B300 | 69.5 | C | pod at US$ 36/h | 130.8 | — |
| 56 | Qwen3.5 397B (NVFP4) | open | 1x B300 | 68.5 | C | US$ 8.22 ³ | 140.0 | 54 |
| 57 | MiMo V2.6 Pro | open | 4x B300 | 67.0 | C | pod at US$ 36/h | 167.2 | — |
| 58 | Laguna-S-2.1 | open | 4x B300 | 65.5 | C | pod at US$ 36/h | 263.0 | — |
| 59 | Ornith 1.5 35B (Q8_0) | open | RTX 5090 (Strata) | 64.5 | C | US$ 0 (local) | 80.0 | — |
| 60 | Nemotron 3.5 Super VL (NVFP4) | open | 1x B300 | 63.0 | C | US$ 7.51 ³ | 207.0 | 50 |
| 61 | Kimi K2 Thinking | open | 4x B300 | 46.0 | D | pod at US$ 36/h | 110.0 | — |
| 62 | DeepSeek V4 Flash | open | 1x B300 | 44.5 | D | US$ 5.59 ³ | 153.0 | 37 |
| 63 | Mistral Large 3 | open | Cloud (OpenCode) | 39.0 | D | US$ 5.11 | — | 76 |
| 64 | GLM 4.7 Flash (BF16) | open | 1x B300 | 33.5 | D | US$ 4.60 ³ | 217.0 | 30 |
| 65 | Gemini 3.1 Pro ⁴ | closed | Cloud (OpenCode) | 32.5 | D | US$ 10.31 | — | 54 |
| 66 | Nex N2.5 Pro | open | 4x B300 | 27.0 | D | pod at US$ 36/h | 184.0 | — |
| 67 | GLM-4.7-Flash (Q5_K_M) | open | RTX 5090 | 24.0 | D | US$ 0 (local) | — | 29 |

How to read the columns:

- **Weights**: "open" is a downloadable checkpoint, any license; "closed" is API only.
- **Cost per run**: what one full seven-sprint run cost.
- **tok/s**: single-stream decode speed, measured by me. It only exists for the ones I served.
- **Minutes**: wall-clock time for the whole run, when I have the data. On the single B300, it's sprint time only.

And the footnotes:

1. Claude ran through the Claude Code Max subscription. The cost is notional: the run's tokens at API list price.
2. Estimated from the run's tokens.
3. Inference time on the B300 only, at about US$ 9 per hour. Download, loading, compilation and tuning are left out, and the real pod cost was higher.
4. Score with a caveat. The cloud Nex was graded from disk, with everything uncommitted; Gemini 3.1 Pro was hurt by an OpenRouter proxy bug.

The first v4 articles lumped everything below B into C; here I use the scale with D, the same as the B300 campaigns. MiniMax M3.1 Flash ran for free through OpenRouter as the cloud anchor for the local campaign, and MiniMax promises to release its weights on October 23.

## The models are converging

Within the limited scope of this benchmark, it looks like everybody is arriving at the same place. **42 of the 67 runs made Tier A**, 24 from closed models and 18 from open ones. Seven models hit 100, and 23 runs landed above 90.

Part of that is a limit of the yardstick itself. When seven models get the top score, the test stops separating the top. And a repeated GPT 5.5 run scored 91 against the official 100, so differences of a few points between two models may just be noise.

Even discounting that, the picture is clear. DeepSeek V4.1 Flash, GLM 5.3 Flash and Qwen3.8 Flash-Next, all open, sit 7.5 points from the ceiling, right on the heels of Sonnet 5 and GPT 6 sol.

> For code review and vigilance, a good open model is already in the same pack as a good closed model. What still separates the two is consistency: among the open models there are D scores that don't show up among the top closed ones.

### The West stalled, China sprinting

Comparing generations of the same family within v4, the difference in pace shows up:

| Family | Before | After |
| --- | ---: | ---: |
| DeepSeek V4 Flash → V4.1 Flash | 86.0 | 92.5 |
| GLM 5.2 → 5.3 | 77.0 | 94.0 |
| MiMo V2.5 Pro → V2.6 Pro | 86.5 | 92.0 |
| MiniMax M3 → M3.1 Flash | 75.5 | 89.5 |
| Kimi K2.7 Code → K3 | 87.25 | 85.0 |
| Gemini 3.7 Flash → 3.8 Flash (high) | 75.5 | 90.5 |
| Claude Fable 5 → 5.1 | 100.0 | 95.5 |
| Grok 4.6 → 4.7 | 98.5 | 83.5 |
| GPT 5.6 sol → GPT 6 sol | 100.0 | 91.0 |
| GPT 5.6 luna → GPT 6 luna | 95.0 | 95.5 |
| Claude Opus 5 → 5.5 | 100.0 | 100.0 |

The Chinese models climbed 5.5 to 17 points per generation, with the exception of Kimi. On the Western side, whoever was already at the ceiling had nowhere to go: Opus stayed at 100, GPT 6 luna stayed where 5.6 luna was, and three new releases landed below their predecessors. Gemini Flash is the Western counterexample, with a 15-point jump.

The calendar reinforces that reading. Claude Fable 5 came out in June, Opus 5 and GPT 5.6 in July, and all of them already hit 100 on my yardstick. From then until October, OpenAI and Anthropic released Fable 5.1, GPT-6 Astra, Opus 5.5 and GPT-6 sol and luna. None of them showed a gain on my yardstick, and some landed below their predecessors.

In the same window, the Chinese labs started from well behind: DeepSeek V4 in April, Kimi K3 in July, Qwen 3.8 and GLM 5.3 in August, DeepSeek V4.1 Flash and MiMo V2.6 Pro in September, MiniMax M3.1 Flash in October. Each release got closer to the top.

> The Chinese labs seem to move faster, and they do. But part of that impression comes from the Western ones having stood still for months, at least in programming. When the leader doesn't move, whoever is chasing catches up.

### Math isn't programming

The Western labs didn't stop working. They're spending a good chunk of their showcase on math:

- in May, OpenAI announced that a general-purpose reasoning model [disproved an Erdős conjecture](https://openai.com/index/model-disproves-discrete-geometry-conjecture/) about unit distances;
- in August, it published [ten mathematical results from Astra](https://github.com/openai/ten-proofs), each with a formal proof in Lean;
- also in August, Anthropic showed an internal Claude raising from 41.6% to 67.2% the proven fraction of [Riemann zeta function zeros](https://www.anthropic.com/research/riemann-zeta) that satisfy the hypothesis;
- in September, Anthropic [formalized the whole of Fermat's Last Theorem in Lean](https://www.anthropic.com/research/formalizing-fermats-last-theorem) in 11 days, with an internal model it describes itself as comparable to Fable 5.1.

It's impressive, and it's legitimate. Formal proof is one of the few places where you can verify the answer automatically, which makes math a great field for training and for marketing. Except the same Fable 5.1 that served as the yardstick for Fermat scored 95.5 on my benchmark, against Fable 5's 100.

Getting better at math doesn't automatically make a model better at programming. A 2025 study, [*Does Math Reasoning Improve General LLM Capabilities?*](https://arxiv.org/abs/2507.00432), concluded that *most models that do well at math don't transfer the gain to other domains*, programming among them. There are counterexamples: NVIDIA showed that [math-only reinforcement learning](https://arxiv.org/abs/2505.16400) raised the code scores of small models. Transfer happens sometimes, and it depends on how you train.

### And what about mixture of experts

The common intuition is that, in a *mixture of experts* (MoE) model, you can improve the "math expert" without touching the "code expert". The idea is half right for the wrong reason.

An MoE has several blocks of weights in each layer, and a router picks a few of them for each token. But the experts don't split by subject the way the intuition suggests. The [Mixtral paper](https://arxiv.org/abs/2401.04088) looked for exactly that and *found no obvious pattern of experts by topic*, with a small difference only on a synthetic math set; the router organizes itself more by syntax, by token type. And neither OpenAI nor Anthropic publicly confirm whether their closed models are MoE.

What still stands is the essential part: capability is trained by objective. The signal that rewards a Lean proof is not the same one that rewards noticing a cross-tenant leak in a Rails controller, and improving one doesn't drag the other along. In a model where only a fraction of the parameters work per token, that mismatch becomes even easier.

## NVFP4, FP8, Q4: what's this alphabet soup

Every model is a pile of billions of numbers, the weights. Quantization is storing each number with fewer bits. The fewer the bits, the less memory the model takes and the less data the card has to read per token, and that's what defines speed on a local machine. The price, when there is one, is quality.

For a 27-billion-parameter model, the math goes like this:

| Format | Bits per weight | 27B takes | Where it runs |
| --- | ---: | ---: | --- |
| BF16 | 16 | ~54 GB | native from Ampere (RTX 30) onward |
| FP8 | 8 | ~27 GB | native on Ada (RTX 40), Hopper (H200) and Blackwell |
| Q8_0 (GGUF) | ~8.5 | ~29 GB | llama.cpp and Ollama, any card |
| Q5_K_M (GGUF) | ~5.5 | ~19 GB | llama.cpp and Ollama |
| Q4_K_M (GGUF) | ~4.5 to 4.8 | ~16 GB | llama.cpp and Ollama |
| NVFP4 | 4.5 | ~15 GB | native only on Blackwell; vLLM, and llama.cpp since 2026 |
| IQ3_S (GGUF) | ~3.4 | ~12 GB | llama.cpp and derivatives |

### What each one is

- **BF16** is the precision most models are published in. It's the reference: nothing is lost.
- **FP8** is 8-bit floating point, with hardware support on the Ada, Hopper and Blackwell generations. It cuts memory in half and is the default for big checkpoints, like DeepSeek V4.1 Flash and GLM 5.3 full.
- **Q8_0, Q5_K_M, Q4_K_M and IQ3_S** are llama.cpp GGUF formats. The weights are stored in blocks of integers with one scale per block; the "K" ones mix precisions per tensor, and the "IQ" ones use an importance matrix to decide where to spend bits. Q8 is considered practically lossless, and Q4_K_M is the recommended default for people running at home.
- **NVFP4** is NVIDIA's 4-bit format. Each number is a 4-bit floating point, and each block of 16 numbers gets its own FP8 scale. NVIDIA says this [takes 3.5 times less than FP16 and loses 1% or less against FP8](https://developer.nvidia.com/blog/introducing-nvfp4-for-efficient-and-accurate-low-precision-inference/) on DeepSeek-R1.

That's where the NVFP4 hype comes from: Blackwell's tensor cores compute in it directly, and it's what made GLM 5.3 Flash, at 198 GB, and Qwen3.5 397B, at 251 GB, fit on a single B300. The H200, from the previous generation, has no native FP4. And the home ecosystem is still catching up: llama.cpp got [NVFP4 support](https://github.com/ggml-org/llama.cpp/pull/22196) only in 2026, and per-architecture coverage is still partial.

### What our tests show

Four models ran at more than one precision:

| Model | Version A | Version B |
| --- | --- | --- |
| Qwen 3.8 27B | BF16, B300: 80.5 | Q8_0, Strix Halo: 80.0 ¹ |
| Qwen3.8 Flash-Next | NVFP4, B300: 92.5 | IQ3_S, RTX 5090 with Strata: 91.0 |
| Ornith 1.5 35B | BF16, B300: 81.0 | Q8_0, RTX 5090 with Strata: 64.5 |
| GLM 4.7 Flash | BF16, B300: 33.5 | Q5_K_M, RTX 5090: 24.0 |

¹ Mixed run: sprints 1 and 2 in Q5_K_M on the 5090, the rest in Q8_0 on the Strix, with reasoning turned off.

And six ran on the cloud API and were also served by me, with the official weights:

| Model | Cloud | Served by me |
| --- | ---: | ---: |
| GLM 5.3 Flash | 84.25 | 92.5 (NVFP4, B300) |
| DeepSeek V4.1 Flash | 92.5 | 92.5 (FP8, 4x B300) |
| GLM 5.3 full | 94.0 | 76.0 (FP8, 4x B300) |
| MiMo V2.6 Pro | 92.0 | 67.0 (FP8, 4x B300) |
| DeepSeek V4 Flash 0731 | 85.0 | 44.5 (official FP4/FP8, B300) |
| Nex N2.5 Pro | 94.0 | 27.0 (FP8, 4x B300) |

Each row is a single run, and the noise reaches almost 10 points. With that caveat, here's my reading:

- **Q8 came out tied with BF16.** The Qwen 27B scored 80.5 and 80.0, a single point of data with other things changing at the same time.
- **Going from 4 down to 3 bits was nearly free on Flash-Next**, at 1.5 points, even while switching engine and card.
- **Ornith's drop is unlikely to be about the bits.** Q8 is nearly lossless, and it still lost 16.5 while also switching engine and card.
- **Serving the same checkpoint can give you anything.** GLM 5.3 Flash went up 8 points in my hands, DeepSeek V4.1 tied, and Nex fell almost 70. Tool parser, chat template, reasoning mode and engine version weigh as much as precision, and the effect changes from model to model.

> In my tests, the bits mattered less than the hype suggests, and the whole package of how the model is served mattered more. Use Q8 when it fits, drop to 4 bits when you have to, and measure on your own work before trusting it.

## The best commercial models

Only closed models get in here, only Tier A, and only what I'd pay for through an API.

### By score

| Model | Score | Cost per run | Minutes |
| --- | ---: | ---: | ---: |
| GPT-6 Astra | 100.0 | US$ 30.55 | 100 |
| Claude Opus 5.5 | 100.0 | US$ 16.63 ¹ | 64 |
| Claude Opus 5 | 100.0 | ~US$ 71 ¹ | 145 |
| Claude Fable 5 | 100.0 | ~US$ 50 ¹ | ~85 |
| GPT 5.6 terra | 100.0 | US$ 9.52 | 80 |
| GPT 5.6 sol | 100.0 | US$ 20.37 | 317 |
| GPT 5.5 | 100.0 | US$ 34.69 | 117 |
| Grok 4.6 | 98.5 | US$ 13.00 | 67 |
| GPT 6 luna | 95.5 | ~US$ 0.84 | 122 |
| Claude Fable 5.1 | 95.5 | ~US$ 51 ¹ | 133 |

¹ Notional subscription cost, at API list price.

At the absolute top, **Claude Opus 5.5** and **GPT 5.6 terra** are the obvious picks: top score, a run in a little over an hour, and a per-run price in the single digits or a bit more. Opus 5 and GPT 5.5 get the same score at two to seven times the cost.

### By cost-benefit

| Model | Score | Cost per run |
| --- | ---: | ---: |
| GPT 6 luna | 95.5 | ~US$ 0.84 |
| Qwen3.8 Flash | 86.5 | US$ 1.17 |
| GPT 6 sol | 91.0 | ~US$ 8.35 |
| GPT 5.6 terra | 100.0 | US$ 9.52 |
| GPT 5.6 luna | 95.0 | US$ 10.04 |
| Grok 4.6 | 98.5 | US$ 13.00 |
| Claude Opus 5.5 | 100.0 | US$ 16.63 ¹ |

¹ Notional subscription cost, at API list price.

**GPT 6 luna** is the absurdity of the table: high Tier A for under a dollar per run, a fraction of the price of any other closed model at the same level. If the top score isn't mandatory, that's where I'd start.

At the top score, **GPT 5.6 terra** costs a little more than half of Opus 5.5. The difference between the two lies in everything else: harness, speed, behavior in long sessions, and I covered that in the previous articles.

## The best open models for companies

This is what runs on datacenter GPUs, on the B300.

| Model | Where | Score | tok/s | Memory |
| --- | --- | ---: | ---: | ---: |
| DeepSeek V4.1 Flash | 4x B300 | 92.5 | 175 | 510 GB |
| GLM 5.3 Flash | 1x B300 | 92.5 | 142 | 198 GB |
| Qwen3.8 Flash-Next | 1x B300 | 92.5 | 195 | 100 GB |
| Swift 1.5 27B | 1x B300 | 88.0 | 203 | 56 GB |
| ThinkingCap 3.8 27B | 1x B300 | 83.0 | 189 | 56 GB |

**DeepSeek V4.1 Flash** is the champion for a big team. On a 4x B300 pod at US$ 36 per hour, it serves **32 comfortable sessions** at the same time, with the first token in under 2 seconds for almost all of them. Counting one active session per developer for the whole workday, which is optimistic, that's 32 people. Turning the pod on only during business hours, 8 hours a day, 22 days a month, comes to about US$ 6,300 per month, or **about US$ 200 per developer**.

The alternatives, by the same math:

- 4x H200 on Runpod serves only 8 comfortable sessions and comes out to about US$ 316 per developer per month, even with the cheapest pod;
- the same configuration on AWS costs almost double, and the H200 on Azure costs almost three times the Runpod price;
- buying a DGX Station GB300 for about US$ 130 thousand pays for itself in about 20 months against renting during business hours, or in about 5 months against a pod running nonstop.

For a smaller team, the single B300 with **Qwen3.8 Flash-Next** or **GLM 5.3 Flash** is the sweet spot: same score as DeepSeek, on a single GPU, at about US$ 9 per hour. I didn't measure concurrency on it. Going by the memory left over, a team of five to ten people fits well on a 27 to 35 billion model, like Swift 1.5; on GLM 5.3 Flash, at 198 GB, it gets tight.

> Your own infrastructure starts to make sense at around 30 people using it at the same time, or when the code can't leave the network. Below that, the API for the same DeepSeek costs a little over a dollar per run and you don't babysit any server.

## The best open models for consumers

This is what runs on a PC: an RTX 5090 with 32 GB or a Strix Halo with 128 GB unified.

| Model | Machine | Score | tok/s |
| --- | --- | ---: | ---: |
| Qwen3.8 Flash-Next (IQ3_S, Strata) | RTX 5090 | **91.0** | 159 |
| Qwen 3.8 27B (Q8_0) | Strix Halo | 80.0 | 8 |
| Ornith 1.5 35B (Q8_0, Strata) | RTX 5090 | 64.5 | ~80 |
| GLM-4.7-Flash (Q5_K_M) | RTX 5090 | 24.0 | — |

There's only one winner: **Qwen3.8 Flash-Next on the RTX 5090 with Strata**. It's a 125-billion MoE with 6 billion active per token, and Strata keeps the most-used experts on the card and the rest in RAM. It landed 1.5 points from the datacenter version, at interactive speed. I covered it in detail, with installation, an auto-loading service and the OpenCode setup, in [Best Open Source LLM: Strata with Qwen 3.8 Flash Next](/en/2026/10/22/best-open-source-llm-strata-with-qwen-3-8-flash-next/).

The Strix Halo fits big models, but its memory bandwidth is seven times lower than the 5090's, and a 27B dense model crawls at under 10 tokens per second in Q8, about 13 in Q4. It's fine for background tasks that can wait.

And what about **Swift 1.5** and **ThinkingCap 3.8**, the 27B fine-tunes that did well on the B300? I didn't run them on the 5090, and I didn't need to. On the B300, in BF16, full precision, they scored 88 and 83, below Flash-Next's 92.5 on the same card and the 91 it scored on the 5090.

On a 5090 they'd fit in Q4 or Q5, but quantized, the best case is matching the B300 score. Running at home cost Flash-Next 1.5 points and Ornith-35B 16.5. The base Qwen 3.8 27B, which is the same architecture, didn't even finish on the 5090 in Q5_K_M: it got stuck in a reasoning loop in sprint 3.

> If those two already fell behind Flash-Next at full precision, they won't get better on a 5090. I saw no reason to test them: for a PC, Flash-Next is clearly the pick.

### What about GPUs worse than the 5090?

It's the question that always comes up: what about people with an 8, 12 or 16 GB card? From my data, the path of a small model that fits entirely on the card still doesn't deliver anything worth the effort for programming.

On a card like that, in Q4, a dense model of up to about 20 billion fits; a 30-billion MoE with few active parameters only runs with part of it in RAM. And that range did badly in v4:

- GLM-4.7-Flash, a 30B MoE with 3B active, scored 24 on the 5090 and 33.5 on the B300 at full precision, Tier D on both;
- Ornith-35B, another MoE with 3B active, scored 81 on the B300 and fell to 64.5 on the 5090;
- gpt-oss-20b didn't even complete the protocol;
- the best mid-size model was Qwen 3.8 27B, with 80, but it already needs about 16 GB in Q4 alone, stalled on the 5090, and only finished at 8 tokens per second on the Strix.

The exception is precisely Flash-Next. Strata was built to run it on a 12 GB card, holding most of the experts in RAM: the [project's README](https://github.com/Niko1221/Strata) publishes 53 tokens per second in IQ3_S on a 12 GB RTX 5070 with 64 GB of RAM, and the stated minimum is 32 GB of RAM and VRAM combined. With the same weights and the same engine, the score in theory shouldn't change, only the speed, which drops to a third of the 5090's. I didn't measure this; it's the author's number.

The catch is RAM. With DRAM [nearly doubling in price](https://www.trendforce.com/presscenter/news/20260601-13070.html) in a single quarter this year, 64 GB stopped being the cheap upgrade it used to be.

> Below the 5090, I wouldn't waste time on small models for programming. If you're going to try something, make it Flash-Next with Strata and plenty of RAM, and measure it on your own work before trusting it.

And there's the problem I covered in the [previous article](/en/2026/10/22/llm-benchmark-v4-consumer-open-source-rtx5090-strix-halo-strata/): finding a 5090 today is hard, and when you do, the price runs between two and a half and almost five times MSRP.

## What I learned in v4

### About the models

- Almost every model catches the loud defect unprompted: a CVE in a gem, a key in the code, open CORS, obvious SQL injection. Almost every model lets the silent one slip until I reveal it: cross-tenant leak, wrong aggregate, tampered test, removed index. What separates Tier A from the rest is how much of the silent stuff it catches on its own.
- Size doesn't buy vigilance. Kimi K2 Thinking, at 1 trillion parameters, scored 46. GLM 5.3 full, at 700 billion, scored 76, against 92.5 for the Flash from the same family.
- Models cheat or get things wrong with conviction. Nemotron tampered with a regression test to make it pass, Qwen3.5 397B let a backdoor through and even wrote a test that treated it as expected behavior, and Kimi K2 put on security checklist theater, catching only what you can find with grep.
- The leap between generations was in agentic reliability. GPT-4o and GPT-4.1 can't even finish the protocol on their own. Today's top models run all seven sprints with no help at all.

### About serving open models

- The same checkpoint changes score depending on who serves it. DeepSeek V4 Flash scored 85 in the cloud, on the same 0731 version I downloaded, and 44.5 served by me; Nex N2.5 Pro scored 94 in the cloud and 27 on the 4x B300 pod, with corrupted tokens landing in the committed code.
- No model runs fast out of the box. GLM 5.3 Flash went from 10 to 141 tokens per second from configuration alone, and every family asked for a parser, a flag and sometimes a vLLM PR branch.
- Running at home charges each model a different price. Switching quantization, engine and card all at once, Flash-Next lost 1.5 points and Ornith-35B lost 16.5.
- What limits concurrency is the KV cache architecture and the time to first token. Parameter count says little: on the H200, a 510 GB model and a much smaller one tied at 8 users, for opposite reasons.

### About measuring

- A single run has noise of almost 10 points. Two scores 2 points apart are a tie.
- The harness matters. Gemini 3.1 Pro was taken down by a proxy bug, gpt-oss doesn't finish in OpenCode, and three models insisted on creating the app in a subfolder.
- A model that doesn't commit loses work. A fix that only lives on disk vanishes at the first `git checkout`.

## My hypothesis: expensive hardware is part of the business model

The v4 verdict, as of October 2026, is this: for code review and vigilance, open source has arrived. DeepSeek V4.1 Flash, GLM 5.3 Flash and Qwen3.8 Flash-Next are in the same pack as Sonnet 5 and GPT 6 sol, and one of them runs on a PC card.

So why isn't everybody running it at home? Because hardware got expensive and hard to find, and I have a hypothesis about that. It's my hypothesis, with no proof of any collusion, built on public facts.

### The facts

- Memory skyrocketed. TrendForce measured a [93% to 98% rise in DRAM contract prices](https://www.trendforce.com/presscenter/news/20260601-13070.html) in the first quarter of 2026 alone, and says manufacturers [keep prioritizing server capacity](https://www.trendforce.com/presscenter/news/20260930-13258.html) in the fourth quarter.
- HBM, the memory in datacenter GPUs, is expected to see its [average price rise 121% in 2027](https://www.trendforce.com/presscenter/news/20260929-13255.html) and take up close to [30% of the DRAM wafers](https://www.trendforce.com/presscenter/news/20260602-13074.html) of the three biggest manufacturers by the end of 2027.
- Micron [left the consumer market](https://www.storagenewsletter.com/2025/12/05/micron-announces-exit-from-crucial-consumer-business/) and killed Crucial, in its own words, to better serve its larger strategic customers.
- PCs and consoles went up in price, and Microsoft [attributed the Xbox increase](https://www.digitalcitizen.life/xbox-series-x-and-series-s-prices-will-rise-again-as-memory-and-storage-costs-surge/) to memory and storage costs.
- The RTX 5090, when it shows up in the United States, costs from [two and a half times](https://gpupoet.com/gpu/market-report/gpu-market-report-october-2026) to [almost five times](https://www.techspot.com/news/114254-nvidia-rtx-5090-production-but-absence-company-us.html) MSRP, and the rumor is that its chips are going to the professional lines. NVIDIA [denies discontinuing it](https://www.guru3d.com/story/nvidia-says-geforce-rtx-5090-production-is-continuing/).
- On the other side, Anthropic [filed for an IPO](https://techcrunch.com/2026/06/01/anthropic-files-to-go-public/) aiming, according to the press, at [about 2 trillion dollars](https://www.khaleejtimes.com/business/anthropic-says-revenue-jumped-to-nearly-17b-last-quarter-reports-2), and OpenAI is [raising at more than 1.4 trillion](https://uk.investing.com/news/stock-market-news/openai-races-to-raise-30-bln-ahead-of-anthropic-ipo-reuters-reports-4918623).
- And the rhetoric about Chinese open models has hardened. Anthropic published that [DeepSeek, Moonshot and MiniMax distilled Claude](https://www.anthropic.com/news/detecting-and-preventing-distillation-attacks), and Dario Amodei, even while saying he [never advocated banning open weights](https://www.anthropic.com/news/position-open-weights-models), calls for chip export controls and mandatory pre-release testing of every sufficiently capable model, open or closed.

### The cycle

The simplest explanation for expensive memory is demand: datacenters buy everything and pay more. I believe it. What bothers me is that no big player has an incentive to break the cycle:

1. The rhetoric says only the frontier lab knows how to handle these "dangerous" models, and that open source is a risky bet.
2. That pulls demand to the cloud, and the cloud buys GPUs and memory in record volume.
3. Manufacturers sell at a premium to whoever pays more and deprioritize consumers.
4. Good hardware becomes unreachable outside the datacenter.
5. Without hardware at home, open source doesn't get adopted, which reinforces the rhetoric in step 1.

> If everybody started hosting their own model, the trillion-dollar IPO math would stop adding up. v4 showed that open models are already ready for a good chunk of the work. What's missing is the hardware getting into the hands of the people doing the work.
