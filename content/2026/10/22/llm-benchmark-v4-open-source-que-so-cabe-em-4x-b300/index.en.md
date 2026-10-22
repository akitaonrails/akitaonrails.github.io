---
title: "LLM Benchmark v4: open source that only fits in 4x B300!!"
slug: "llm-benchmark-v4-open-source-that-only-fits-in-4x-b300"
date: '2026-10-22T10:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-open-source-que-so-cabe-em-4x-b300
description: "I rented 4x NVIDIA B300 on Runpod and ran my v4 sabotage benchmark on the open models that don't fit on a single card. DeepSeek V4.1 Flash, at 748B, tied the leaders at 92.5, on the level of hosted GLM 5.3 and GPT-6 Sol. GLM 5.3 full fell behind, the 1T Kimi K2 Thinking disappointed, and a 397B model plummeted from 94 in the cloud to 27 at home. The math: US$ 36 per pod hour, US$ 864 per day. When owning your own infra makes sense, and whether a big open model is already enough for your day-to-day programming."
tags:
- llm-benchmarks
- local-models
- llms
- hardware
---

In the [previous article](/en/2026/10/19/llm-benchmark-v4-the-top-open-source-llms-on-a-b300/) I told what it was like running the v4 sabotage benchmark on a single rented NVIDIA B300 on Runpod. The obvious leftover question: what about the really big models, the ones that don't fit in 288 GB? I decided to see how far open source can be pushed.

The short answer: pretty far, and one of them tied the Sonnet 5 and GPT-6 Sol band. The long one comes with a grocery bill and several days of vLLM suffering.

First of all, the scope caveat. Some models were left out. Kimi K3, at 2.8 trillion parameters, is the example: in FP8 it would need about 2.8 TB of VRAM, and not even an 8x B300 pod (2.3 TB raw) closes the math. To run a monster like that you need to quantize to FP4 or rent a lot more cards. And I chose to spend my credit on what fits in 4x.

## The full ranking

Same methodology as always: the RubyLLM chat app with 14 planted defects (backdoors, authorization bypasses, lying tests), and the score measures code-review vigilance, not typing speed. The model has to find and fix the defects unannounced (full weight) and when revealed (40% weight). Tier A starts at 83. I ran everything on the same 4x pod to have a single yardstick, although not every model needed all four cards (Ornith and Laguna would fit on one).

| Model | Size / checkpoint | Score / Tier | Speed (single stream) |
| --- | --- | ---: | ---: |
| DeepSeek V4.1 Flash | 748B (552B + 196B Engram), FP8, 510 GB | **92.5 (A)** | 174.8 tok/s |
| GLM 5.3 full | ~700B, FP8, 704 GB | 76.0 (B) | 110 tok/s |
| Ornith-1.5-122B | ~122B MoE, FP8, 133 GB | 73.0 (B) | 244.2 tok/s |
| Step-5-Preview | ~816B (estimated size), NVFP4, 368 GiB | 72.5 (C) | 165.9 tok/s (with MTP) |
| Muse Spark Open | 816B-A42B, NVFP4, 533 GB | 69.5 (C) | 130.8 tok/s |
| MiMo V2.6 Pro | ~0.5T MoE, FP8/mxfp4, ~535 GB | 67.0 (C) | 167.2 tok/s |
| Laguna-S-2.1 | small code MoE, NVFP4, 99.7 GB | 65.5 (C) | 263 tok/s |
| Kimi K2 Thinking | 1T / ~32B active, INT4, 594 GB | 46.0 (D) | 110 tok/s |
| Nex N2.5 Pro | ~397B MoE, FP8, ~380 GB | 27.0 (D) | 184 tok/s |

Two notes to read the table properly. Step-5 and Muse are in C because the unannounced base was low: a fix after the "there's a problem there" is worth 40%. Muse fixed 6 of the 7 open items when revealed; Step-5, only 2 of 5. And Nex N2.5 Pro, on top of the shameful score, corrupted the code to the point the app wouldn't even boot. The two anchors from the previous campaign, for comparison: GLM 5.3 Flash and Qwen3.8 Flash-Next, both 92.5 on the single B300.

## What each one did that's interesting

The score alone hides the behavior, and the behavior is the fun part.

**DeepSeek was the only one that solved both compound items unaided.** The compound defects are the ones that require seeing two things at once (the backdoor and the test covering it), and it found and fixed both with no nudge. That's the kind of vigilance I want from my PR reviewer.

**The full GLM fixed everything when told, but slept through silent mode.** Unannounced, it let the access and silent-correction cluster through. When I pointed, it swept the six remaining items. In other words: the big model is capable, it's just not attentive by default. Its Flash, at a third of the size, was more vigilant.

**Kimi K2 Thinking did security-checklist theater.** It wrote these beautiful "security best practices" lists and left five items open, including a plaintext key. Talking about security and doing security are different things, and it did the first one.

**Ornith restored the behavior and kept the lying test.** On item 6, it reverted the code to the old behavior instead of fixing the planted test that validated the backdoor. Hence the strict score of 73 and the lenient 76: looking fixed is not being fixed, and the lying test also needs to die.

**Step-5 left three defects even with the map in hand.** After being explicitly told, it still left the login link, the authorization deactivation and the wrong aggregate. Not every model takes the second chance.

**Muse Spark Open almost didn't get off the ground, but recovered.** It started blocked: weights in 127 NVFP4 shards, gated on Hugging Face, and no support in stable vLLM. It only ran when I compiled a PR branch still in draft, with nvcc 12.9 and 12.8 libraries mixed, and capped the multimodal to text. Then it delivered 69.5: weak base unannounced (21 of 40), but 6 of 7 items fixed when pointed. It's the case of "infra effort is not the model's score": the service stayed up, the behavior is useful, and even so it only reaches Tier C. If the question is "why isn't it at the top", the answer is default vigilance, not VRAM.

**And Nex was the complete disaster.** It needed two nudges, and in the end the corrupted text reached the committed Ruby and the app won't even start. In the cloud, the same Nex N2.5 Pro had scored 94. At home, 27. I wouldn't trust a vendor benchmark after seeing this twice.

## Running on 4 GPUs is not trivial

Four cards are not four models: it's one model sliced into four, with tensor parallelism TP=4 in vLLM. That gives about 1.1 TB of aggregate VRAM (in practice, ~1,038 GB usable with `--gpu-memory-utilization 0.90`). Without that, none of the models above 400 GB would exist in my life without offloading to SSD, which is where speed goes to die.

The cares that repeated on almost all of them:

- **Bleeding-edge toolchain.** B300 (`sm_103a`) requires CUDA 12.9 to compile the kernels on the fly, so the default image wasn't enough: standalone toolkit with nvcc 12.9 and the right headers, and even then each family needed a DeepGEMM, FlashInfer or cudart-link patch.
- **Startup is not download.** DeepSeek took 15 to 30 minutes to initialize, so be prepared to wait for the model to load before measuring anything.
- **Each family has its parser and its quirks.** Nex only talked after switching the parser to `qwen3_xml`, getting one more nudge and ignoring the `tmp/log` artifacts. Step-5 didn't exist in stable vLLM 0.32 and needed a nightly with a specific PR. Muse required compiling a PR branch still in draft, with CUDA 12.9 nvcc and 12.8 libraries mixed, and weights in 127 NVFP4 shards. MiMo asked for `--trust-remote-code`. Laguna decided, out of nowhere, to flood the output with reasoning text, and one sprint had to be redone from the injection base.
- **Context is expensive.** Kimi K2 Instruct's FP8 checkpoint (1,029 GB) would leave 9 GB for KV cache on the 4 cards, so the 594 GB INT4 Thinking went in its place. Speculating with a draft head (MTP) only worked on Step-5, with a 2.24x gain and 73.7% token acceptance, because I verified the tools' correctness first.

The operational lesson: renting VRAM solves "fits", but not "runs well". Every big model is a mini integration project.

## And where's the frontier?

The question that matters to the developer isn't "who has more parameters", it's "does the big open model deliver in my day to day?". The v4 benchmark numbers, on the same yardstick:

| Model | Score |
| --- | ---: |
| Claude Opus 5 / 5.5 | 100.0 |
| GPT-6 Luna | 95.5 |
| GLM 5.3 (hosted) | 94.0 |
| **DeepSeek V4.1 Flash (cloud or 4x B300)** | **92.5** |
| GLM 5.3 Flash / Qwen3.8 Flash-Next (single B300) | 92.5 |
| GPT-6 Sol | 91.0 |
| Claude Sonnet 5 | 91.0 |
| Kimi K3 | 85.0 |

DeepSeek V4.1 Flash tied its own cloud service, at the same 92.5, and finished above GPT-6 Sol and Sonnet 5. In other words: **the best current open source is already 1.5 points behind hosted GLM and 7.5 behind the absolute top**, ahead of two strong commercial frontier models. If your yardstick is mine (find the backdoor and the bypass before merging), a local 748B open source is already good enough for daily code review, at 175 tokens per second per stream in my admission measurements.

But three warnings before you cancel your Claude subscription:

1. **More parameters doesn't mean more competence.** The full GLM 5.3, at ~700B, scored 76 against its own Flash's 92.5. Kimi K2 Thinking, at 1 trillion, scored 46. And Nex N2.5 Pro plummeted from 94 in the cloud to 27 at home: a public checkpoint is no guarantee of reproducing the service, as I had already seen with DeepSeek V4 Flash (86 in the cloud, 44.5 at home).

By the way, Nex's case is the perfect example of a bad base choice. When Rio 3.5 blew up in June, [I covered the controversy here](/en/2026/06/15/rio-3-5-llm-controversy-plagiarism/): its checkpoint was a blend of Nex-N2-Pro with Qwen. The Rio folks could have chosen much better bases, like DeepSeek V4.1 or GLM 5.3 Flash, and went exactly for the lineage that, on my current yardstick, was the worst of the bunch. Picking a model by its pretty name costs dearly.
2. **My yardstick is vigilance, not general programming.** Here I measure who notices sabotage. That's not the same as measuring who writes your whole system better, and a rerun of my benchmark already varied 9 points on the same model. The 1.5-point distance between models may be noise.
3. **Cost changes the answer.** If the idea is frontier quality day to day, DeepSeek V4.1's cloud API cost US$ 1.21 per full benchmark round. The 4x B300 pod costs US$ 36 per hour before you even press the button.

## Is renting 4x B300 worth it?

For one person writing code with an agent in the morning and another in the afternoon: no. The API solves for a few dollars what the pod solves for dozens of dollars per hour.

For a company that needs truly private data (code that can't leave the VPN), a pinned checkpoint for reproducibility, or continuous batch load (thousands of reviews, classifications, analyses per day), then the math changes. DeepSeek V4.1 on 4x B300 delivers near-frontier quality with the data at home, and that you can't buy with a chat subscription.

What I wouldn't buy again without measuring first is the "bigger is better" premise. I started this campaign thinking the jump past 92.5 would come from a bigger model. It came from the right model running properly. The rest is burned VRAM and a good story to tell.

And there's another chapter coming, on non-datacenter hardware: local model tests on the RTX 5090 and the Strix Halo, with a new inference engine called Strata. Once the protocol is done, the third article comes out.

And there's one more chapter coming, of non-datacenter hardware: the tests with local models on the RTX 5090 and the Strix Halo, with a new inference engine called Strata. When the protocol is done, the third article comes out.

And the "is it worth it" question has an irritatingly obvious answer: it depends on how many people will use it at the same time. That's the one I answer in the next article: [LLM Benchmark v4: can my team fit in a 4x b300/h200?](/en/2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/).
