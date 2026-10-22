---
title: "LLM Benchmark v4: consumer-grade open source on RTX 5090 or Strix Halo. And Strata?"
slug: "llm-benchmark-v4-consumer-open-source-rtx5090-strix-halo-strata"
date: '2026-10-22T11:30:00-03:00'
draft: false
translationKey: llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata
description: "After testing the big models in the datacenter, I went back to consumer hardware: RTX 5090 and Strix Halo. Qwen3.8 Flash-Next scored 91.0 on the 5090 with the new Strata engine, 1.5 points behind the B300. Strix Halo shows that big memory is not speed: 80.0 on the same task, but 7.7 tokens per second. I compare specs, explain the tuning that makes a model run well on a PC, and answer whether consumer hardware is already good enough to work with AI day to day."
tags:
- llm-benchmarks
- local-models
- llms
- hardware
images:
- /2026/10/22/llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata/dgx-spark-box.jpeg
---

In the last two articles I covered the [big-model benchmark on 4x B300](/en/2026/10/22/llm-benchmark-v4-open-source-that-only-fits-in-4x-b300/) and the [team-size and per-user cost math on B300 and H200](/en/2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/). Now the question every developer without a Runpod pod has: **is consumer hardware already good enough to work with AI for real?**

I went back to two machines I already had: a workstation with an RTX 5090 and a Strix Halo mini PC. And with a new inference engine, Strata, which promises to make big MoEs fit on a regular PC. The short answer: a 125B model already makes Tier A on an RTX 5090. The rest is more complicated.

## The machines, side by side

Before any scores, understand the physical difference of what I'm comparing:

| Hardware | Memory | Bandwidth | Architecture | Approximate cost |
| --- | --- | --- | --- | --- |
| NVIDIA B300 | 288 GB HBM3e | ~8 TB/s | Blackwell Ultra, FP8 and FP4 | US$ 9/hour (Runpod) |
| NVIDIA H200 | 141 GB HBM3e | ~4.8 TB/s | Hopper, FP8 | US$ 3.59/hour |
| DGX Spark | 128 GB unified | 273 GB/s | GB10, FP4 | ~US$ 6,950 |
| RTX 5090 | 32 GB GDDR7 | ~1.8 TB/s | Blackwell sm_120, FP8/FP4 | ~US$ 2,000 |
| Strix Halo (Ryzen AI Max+ 395) | 128 GB unified | ~256 GB/s | gfx1151, ROCm | ~US$ 2,000 |

The B300 has over 30 times the Strix Halo's memory bandwidth. The 5090 has 7 times. That explains why the same model flies on one machine and crawls on the other, and why quantization stops being a detail and becomes a design decision.

And there's the shared-memory detail: on the Strix and the Spark, the same RAM serves CPU, GPU and operating system. It's not dedicated VRAM, so the real slack is much smaller than the pretty number on the box.

## The ranking on consumer hardware

The yardstick is the same as the v4 sabotage benchmark: 14 planted defects, a review-vigilance score, Tier A starting at 83.

| Model / machine | Variant and engine | Score / Tier | Speed |
| --- | --- | ---: | ---: |
| **Qwen3.8 Flash-Next** (125B-A6B) | RTX 5090, Strata, IQ3_S | **91.0 (A)** | 159.2 tok/s |
| Ornith-1.5-35B-A3B | RTX 5090, Strata, Q8_0 GGUF | 64.5 (C) | ~80 tok/s |
| Qwen3.8-27B | 5090 → Strix, Q5_K_M → Q8_0 | 80.0 (B) | 7.7 tok/s |
| GLM-4.7-Flash (30B-A3B) | RTX 5090, llama-swap, Q5_K_M | 24.0 (D) | not measured |

GLM-4.7-Flash completed the whole protocol (after a first nested attempt that needed a retry) and still failed to detect sabotage. And there's a humility lesson in the Qwen 27B: it scored 80 on the same task where it scored 80.5 on the B300, but at 7.7 tokens per second on the Q8 probe and 706 minutes on the clock. A good score doesn't pay for productivity.

I left out the tests that don't have a final score yet: Qwen3.8 Flash-Next on the Strix with Strata is only confirmed as executable, and the dense 27Bs were discarded on the Strix by the 30 tok/s cutoff.

## The tuning that makes a model run well on a PC

Consumer hardware doesn't forgive lazy configuration. What I learned in practice:

- **On the 5090, compile llama.cpp for sm_120.** A ready-made image falls into a slow PTX fallback. It's `-DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=120`, driver 570+, and no `--ctx-size 0` on a 32 GB card: the training-context default blows the VRAM on the first allocation. Context needs an explicit ceiling, and if you get OOM on the first request, cut 25 to 50%.
- **KV cache in q8_0.** Halves KV memory with no measurable quality cost. Flash-attention on by default, but GLM 4.7 Flash needs it off, because its deepseek2 architecture is incompatible.
- **Hybrid reasoning is work.** Qwen3.8-27B, with the SSM/Mamba architecture, needed a fresh llama.cpp/Ollama build because of `ssm_conv1d`. And "no reasoning" mode didn't prevent a coherence loop in one of the attempts; the way out was resuming on the Strix with Q8_0 and `--reasoning off`. It wasn't extra memory that fixed it, it was turning off the thinking.
- **On the Strix, the adjustment is ROCm, not magic.** `HSA_OVERRIDE_GFX_VERSION`, `GGML_HIP_NO_VMM`, `-dio`. Its trump is capacity (128 GB), not speed (~256 GB/s). Q4_K_M gave 12.6 tok/s and Q8_0 gave 7.7 tok/s, below my 30 tok/s cutoff for interactive use. That's why the Strix became an escape hatch for big models, not a fast chat box.
- **The engine matters more than the "AMD is no good" argument.** The same card that looked slow serves big models well when the engine is optimized for its architecture. Draft-head speculation is still a fraud if acceptance is low: in a llama.cpp test with n-gram and no draft model, only 5 of 64 drafts were accepted and throughput dropped 2.3%.

## What is this Strata thing

[Strata](https://mihai.ltd/blog/beating-llamacpp-from-scratch-consumer-amd) is a new inference engine, written from scratch in Rust with custom AMD HIP kernels, by Mihai Farcas. It's not a llama.cpp wrapper: it's another engine, with builds for CUDA 12/13 and for HIP-ROCm (the 5090 run used CUDA 13).

The problem it attacks is the big MoE on a small machine. The strategy is **expert-offload**: the hot experts stay in VRAM, the rest stay in RAM, and the index stays on SSD. With 125B and 24,576 experts, only about 10 active per token, you don't need 288 GB of VRAM to serve the model. You need at least ~32 GB between RAM and VRAM and ~80 GB of disk. It's the difference between "doesn't run" and "runs well".

In the author's experiment with Qwen 3.5 4B on an RX 7900 XTX, the optimizations are the same ones I covered in the previous article: batched prefill instead of thousands of kernels (from ~3,300 to 280), HIP Graph Replay on decode, argmax on the GPU, split-KV attention with four workers so it doesn't decay with context, and immediate flush of every token over HTTP (TTFT from 410 ms to 48.5 ms). All of that on an OpenAI-compatible API on port 8080.

What made me believe in it was the result, not the marketing: **Qwen3.8 Flash-Next on the 5090 with Strata scored 91.0, with zero nudges and all 14 items solved**, 1.5 points behind the 92.5 the same model scored on the B300 with vLLM. The report itself calls that "within the noise". In this benchmark, an engine written by one person landed 1.5 points behind the same variant served in a datacenter.

## What each model did that's interesting

**Flash-Next: the proof that consumer reaches Tier A.** 34 of 40 unannounced, plus 6 with reveal weight, and only two items needing a pointer. No nudges, all sprints clean. It's the only local one that combines a Tier A score, interactive speed (159 tok/s) and the full protocol without help. If the question is "can I use it at work", this is the example.

**Ornith-35B: fast, but not good enough.** The same Ornith that scored 81 on the B300 in BF16 scored 64.5 on the 5090 with Q8_0. Unannounced detection dropped from 30 to 23. Quantization, engine and hardware all changed at once, so the cause can't be isolated: this Q8_0 + Strata + 5090 combination lost 16.5 points, and I don't know how much came from each variable. The message is clear: "runs fast" is not "reviews well".

**Qwen 27B: good score, terrible experience.** It scored 80 on the Strix resume, with sprints 1 and 2 on the 5090, close to the B300's 80.5. But 7.7 tok/s on the Q8 probe and 706 minutes of wall time. And on top of that zero fixes on reveal, with four items open. Using this day to day is choosing to wait.

**GLM-4.7-Flash: the engine ran, the model failed.** Full protocol in 29 minutes, and zero unannounced detection. It recovered 8 of 14 only when pointed, and even then left the fixes uncommitted. On the B300 it scored 33.5, which isn't good either. The problem isn't just the card.

## The distance between the categories

The question every dev has is whether consumer already gets there. Direct comparison, on the same yardstick:

| Category | Models | Score |
| --- | --- | ---: |
| Commercial frontier | Claude Opus 5 / 5.5 | 100.0 |
| Commercial frontier | GPT-6 Luna | 95.5 |
| Commercial frontier | GLM 5.3 (hosted) | 94.0 |
| Commercial frontier | GPT-6 Sol / Sonnet 5 | 91.0 |
| Commercial frontier | Kimi K3 | 85.0 |
| Open datacenter | DeepSeek V4.1 Flash (4x B300) | 92.5 |
| Open datacenter | GLM 5.3 Flash / Qwen3.8 Flash-Next (B300) | 92.5 |
| **Open consumer** | **Qwen3.8 Flash-Next (5090 + Strata)** | **91.0** |
| Open consumer | Qwen3.8-27B (Strix) | 80.0 |
| Open consumer | Ornith-35B (5090) | 64.5 |
| Open consumer | GLM-4.7-Flash (5090) | 24.0 |

The reading is that the consumer top is **9 points below the absolute commercial top and 1.5 points below the open datacenter top**, on this vigilance metric. It's a small distance, and it vanishes when you notice GPT-6 Sol and Sonnet 5 are also at 91. The real abyss isn't between datacenter and consumer: it's between the right model and all the others. Between Flash-Next and Ornith, on the same 5090, it's 26.5 points.

## So, is consumer hardware good enough to work with?

**Yes, with the right model and engine.** An RTX 5090 with Strata delivers Tier A code-review vigilance, at 159 tokens per second, without paying a cent per token once the hardware exists. For anyone doing code review, testing coding agents and keeping private data at home, that changes the game: it's not "almost as good as", it's genuinely good.

What doesn't work is thinking any configuration works. The Strix Halo is great for having 128 GB and mounting a big model, but its speed doesn't pay for interactivity; Ornith runs fast and reviews badly; GLM-4.7-Flash completes the protocol and detects nothing unannounced. And there's the invisible price: aggressive quantization can charge score, depending on the model and the configuration, and waiting time charges patience.

If I were building a box for a dev today, it would be a 5090 with Strata and Flash-Next, and I'd use the Strix for background tasks that accept being slow. The commercial frontier keeps winning for whoever needs the maximum. But consumer stopped being a consolation prize: there's already Tier A on the home shelf.
