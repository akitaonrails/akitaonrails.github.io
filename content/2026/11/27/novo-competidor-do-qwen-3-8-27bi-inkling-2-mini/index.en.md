---
title: "A New Challenger to Qwen 3.8 27B: Inkling 2 Mini"
date: '2026-11-27T13:00:00-03:00'
slug: a-new-challenger-to-qwen-3-8-27b-inkling-2-mini
translationKey: novo-competidor-do-qwen-3-8-27bi-inkling-2-mini
description: "I benchmarked Thinking Machines Lab's Inkling 2 Mini against Qwen3.8 Flash-Next on an RTX 5090 (Strata and Basalt) and an AMD Strix Halo: 100/100 on the hard canary, zero RAM offload, 2.1 s TTFT, and the real trade-offs of its looped architecture."
tags:
- llm-benchmarks
- local-models
- llms
- hardware
draft: false
---

I had never even heard of **Inkling** until yesterday, when **DHH** [posted this on X](https://x.com/dhh/status/2125845831051858053) showing that **Thinking Machines Lab's** [**Inkling 2 Mini**](https://thinkingmachines.ai/news/inkling-2-mini/) had just beaten **Qwen3.8 27B** (and crushed Nemotron 3.5 Bolt) in his overnight Omarchy malleability shoot-out on an RTX Spark: an 8.50 average vs 8.00, finishing 8 of 8 runs in 142 minutes versus 240 minutes for Qwen.

![DHH's post on X comparing Inkling 2 Mini, Qwen3.8 27B, and Nemotron 3.5 Bolt in an overnight Omarchy eval](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/27/inkling-2-mini/dhh-inkling-2-mini.png)

It has been almost exactly a month since I published my [open-source LLM benchmark for home hardware](/en/2026/10/27/llm-benchmark-best-open-source-llms-for-home-hardware/), where **Qwen3.8 Flash-Next** running on Basalt claimed the crown on my RTX 5090. DHH's post immediately caught my attention: if this new 26.4B model beats dense **Qwen3.8-27B** in his shoot-out, how does it hold up against the reigning champion on my own desk? In [llm-opensource-benchmark](https://github.com/akitaonrails/llm-opensource-benchmark), I pitted Inkling 2 Mini directly against **Qwen3.8 Flash-Next** (a much larger 125B total / ~6B active MoE, quantized to Q2_0 and IQ3_S) on both my RTX 5090 and my AMD Strix Halo.

## Who built Inkling 2 and what is its story

Inkling 2 comes from **Thinking Machines Lab**, the AI startup founded in early 2025 by former OpenAI CTO **Mira Murati** alongside a veteran roster of former OpenAI researchers. After months of building training infrastructure and its *Tinker* platform, the lab released its second generation of open-weight models in November 2026 under the permissive **Apache 2.0** license: first the cloud-scale **Inkling 2 Small** (a 594B total / 17B active multimodal MoE), followed on November 20 by **Inkling 2 Mini** on [Hugging Face (`thinkingmachines/Inkling-2-Mini`)](https://huggingface.co/thinkingmachines/Inkling-2-Mini), built specifically to run locally on 32 GB laptops or a single desktop GPU.

The reason Inkling 2 Mini punches so far above its size comes down to its architecture. Instead of stacking more physical layers and blowing past consumer VRAM, Thinking Machines built a **depth-looped MoE Transformer**:

* **Parameters:** ~26.4 billion physical total parameters, with only **~3.4 billion unique active parameters** per token (roughly ~5.4 billion effective active parameters when counting the repeated passes).
* **The depth-loop trick:** the model has **24 physical decoder layers**. Layers 0 through 5 run once, the **middle 12 layers (6 through 17) loop three times sequentially per token** reusing the exact same weights, and layers 18 through 23 run once. You get the logical depth of a **48-layer** model inside a compact memory footprint.
* **Format and context:** it ships in native mixed **NVFP4/MXFP8** precision (~20 GB on disk), handles text and image inputs natively, and supports up to a **1 million token** context window.

## What the creators claim and their published numbers

Thinking Machines Lab's pitch is straightforward: bring near-frontier reasoning, tool use, and agentic software engineering into an offline package that fits inside a 32 GB MacBook Pro or an RTX 5090. Looking at their launch benchmarks (measured against dense **Qwen3.8-27B**), the model's profile is unmistakable:

| Benchmark | Inkling 2 Mini | Qwen3.8-27B (dense) | What it measures |
|---|---:|---:|---|
| **SWE-bench Verified** (bash-only) | **79.2%** | 77.8% | Autonomous bug fixing in real repositories |
| **SWE-bench Pro v2** (Hard) | **77.9%** | 73.8% | Advanced software engineering tasks |
| **DeepSWE v1.1** | **48.2%** | 42.2% | End-to-end repository-level resolution |
| **SWE-bench Multilingual** | **73.7%** | 70.0% | Cross-language code fixing |
| **PMPP-Hard** (Kernel Opt. AUC) | **455.82** | 262.50 | Low-level kernel optimization |
| **Terminal Bench v2.1** | 71.6% | **73.0%** | Command-line and terminal operations |
| **Artificial Analysis Index v5.0** | **20.1** | **20.1** | Composite intelligence index |
| **AutomationBench-AA v1.0.6** | 41.8% | **48.2%** | Office and enterprise workflow automation |
| **AA-Briefcase v1.1** (Elo) | 1263 | **1391** | General knowledge work and document tasks |

They also reported strong tool-use and multimodal scores (**82.7% on MCP Atlas**, **85.3% on DeepSearchQA**, **76.5% on ScreenSpot Pro**, and **92.8% on OmniDocBench**).

Notice the trade-off already visible in the lab's own numbers: on **coding, debugging, and kernel optimization**, Inkling 2 Mini beats dense Qwen3.8-27B almost across the board. On broader office workflows and static world knowledge (*AutomationBench* and *AA-Briefcase*), the 27B dense model holds the edge, because 27B dense weights store more static facts than a 3.4B-active sparse MoE, even with depth looping.

## My real-world tests: RTX 5090 and AMD Strix Halo

Every lab publishes flattering launch charts. I pulled Inkling 2 Mini into the exact same [llm-opensource-benchmark](https://github.com/akitaonrails/llm-opensource-benchmark) suite on my two home machines, driving [OpenCode](https://opencode.ai) inside a `bubblewrap` sandbox:

* **RTX 5090 desktop (32 GB VRAM):** keeping 4 GB free for the desktop (Hyprland, browser, and terminal), tested on both **Strata** (`0.1.69`, `SQ-20` pack) and [**Basalt**](https://github.com/jesdga95/basalt) (`v0.5.7`, native [`Inkling-2-Mini-NVFP4-MX8.basalt`](https://huggingface.co/jesdga/Inkling-2-Mini-Basalt)), against **Qwen3.8 Flash-Next** (`Q2_0`, `IQ3_XXS`, `IQ3_S`, and `UD-Q4_K_XL`).
* **AMD Strix Halo (headless, 64 GB VRAM + 31 GB GTT):** full GPU dedicated to the model, using Strata's HIP backend (`0.1.67` for Inkling 2 Mini).

### Speed on the RTX 5090: Strata vs Basalt

Numbers come from the speed canary (cold 4k and 32k prompts plus a cached 32k follow-up, 131k context window):

| Engine | Model / Version | Output (tok/s) | 32k Prefill (tok/s) | 32k TTFT | RAM offload | Min free VRAM |
|---|---|---:|---:|---:|---:|---:|
| **Basalt v0.5.7** | **Inkling 2 Mini (`NVFP4-MX8`)** | **250 to 346** | **15,577** | **2.1 s** | **0 GB** | **6.57 GiB** |
| **Basalt v0.2.1** | **Qwen3.8 Flash-Next (`Q2_0`)** | **377 to 400** | 8,600 | 4.9 s | ~30 GB | 4.13 GiB |
| **Basalt v0.2.1** | Qwen3.8 Flash-Next (`IQ3_S`) | 223 to 231 | 8,200 | 5.2 s | ~42 GB | 4.35 GiB |
| Strata `0.1.69` | Inkling 2 Mini (`SQ-20`) | 110 to 154 | 6,489 | 5.1 s | 0 GB | 4.98 GiB |
| Strata `0.1.50` | Qwen3.8 Flash-Next (`Q2_0`) | 245 to 270 | 6,200 | 7.0 s | ~30 GB | ~4.0 GiB |
| Strata `0.1.50` | Qwen3.8 Flash-Next (`IQ3_S`) | 160 to 210 | 6,200 | 7.0 s | ~42 GB | ~4.0 GiB |
| Strata `0.1.50` | Qwen3.8 Flash-Next (`UD-Q4_K_XL`) | 44 to 52 | 2,300 | 19.0 s | ~75+ GB | OOM on quality |

### Speed on the AMD Strix Halo (Strata HIP)

| Model / Version | Output (tok/s) | 32k Prefill (tok/s) | 32k TTFT | Min free VRAM | Quality Canary |
|---|---:|---:|---:|---:|---:|
| **Inkling 2 Mini (`SQ-20`, `0.1.67` HIP)** | **13.8 to 24.8** | **642** | **51.1 s** | **41.9 GiB** | **100** (6.2 min) |
| Qwen3.8 Flash-Next (`Q2_0`) | **55 to 65** | 371 | 114.1 s | 22.1 GiB | 100 |
| Qwen3.8 Flash-Next (`IQ3_XXS`) | 50 to 57 | 347 | 122.0 s | ~12 GiB | 100 |
| Qwen3.8 Flash-Next (`IQ3_S`) | 47 to 51 | 338 | 125.4 s | 5.4 GiB | 100 |
| Qwen3.8 Flash-Next (`UD-Q4_K_XL`) | 17 (4k) | 137 | hung machine | 0 GiB | did not fit |

### Coding quality: Hard Canary on the RTX 5090 (Basalt)

On the quality canary (3 turns, 9 hidden tests), every model scored 100 (Inkling 2 Mini finished in 2.1 minutes on Basalt 5090 and 6.2 minutes on Strix Halo). The real separation comes from the **hard canary**: a 4-turn OpenCode session on a payment reconciler graded by 36 hidden tests, with decisions buried inside a 64k-token transcript (including one reversed later), cent-exact decimal arithmetic, and a final refactor. I ran each model three times on Basalt:

| Model (Basalt 5090) | Scores (3 runs) | Hidden tests | Avg wall time (4 turns) | Output tokens per run |
|---|---|---:|---:|---:|
| **Inkling 2 Mini (`NVFP4-MX8`)** | **100 / 100 / 100** | **36/36** on all 3 | **9.8 min** (8.5 / 8.2 / 12.7) | **140k to 204k** |
| **Qwen3.8 Flash-Next (`Q2_0`)** | **100 / 100 / 100** | **36/36** on all 3 | **5.5 min** (5.9 / 4.2 / 6.3) | **78k to 116k** |
| Qwen3.8 Flash-Next (`IQ3_S`) | 100 / 96* / 100 | **36/36** on all 3 | **9.1 min** (5.8 / 11.3 / 10.1) | **61k to 121k** |

*\* On IQ3_S run 2, all 36 hidden tests passed. The 4 deducted points were a sandbox snooping false alarm triggered when the model ran `ps aux` (a harness bug since fixed).*

## The four insights that actually matter

Stepping back from the raw tables, four findings stand out far more than a simple "model A beat model B" headline:

1. **The inference engine matters as much as the model.** Had I stopped at Strata (`0.1.69`), I would have walked away thinking Inkling 2 Mini felt sluggish on a 5090 (110 to 154 tok/s). Moving the exact same model to **Basalt `v0.5.7`** boosted decode **2.3x** to **250 to 346 tok/s** and slashed 32k TTFT from 5.1 s down to **2.1 s**, because Basalt actually exploits Blackwell's native FP4 Tensor Cores.
2. **The looped architecture has a real cost on bandwidth-limited memory.** Look at what happened on the **AMD Strix Halo**: Inkling 2 Mini had tons of memory headroom (41.9 GiB free!) and prefilled 32k prompts **1.7x faster** than Qwen3.8 (51 s vs 114 to 126 s). Yet during decode it dropped to **14 to 25 tok/s**, while Qwen3.8 cruised at **47 to 65 tok/s**. That is pure physics: running the 12 middle layers three times per token hits LPDDR5X memory bandwidth hard during decode. On the 5090's massive GDDR7 bandwidth, the loop flies; on Strix Halo, memory bandwidth collects its toll.
3. **Raw tok/s vs wall-clock time (the verbosity tax).** Even on Basalt, Qwen3.8 `Q2_0` finished the hard canary nearly twice as fast in real clock time (**5.5 min** vs **9.8 min**). Beyond decoding faster (377 to 400 tok/s vs 250 to 346), Inkling 2 Mini thinks out loud a lot more, emitting **140k to 204k output tokens** per session compared to **61k to 121k** for Qwen3.8. In multi-turn agent loops, verbose reasoning turns straight into extra minutes on the clock.
4. **Native precision and zero RAM offload change the equation.** Qwen3.8 Flash-Next `Q2_0` is an aggressive 2-bit quant (~78% top-1 agreement vs BF16; `IQ3_S` sits around ~87%) that still spills **30 GB to 42 GB of experts into system RAM**. Inkling 2 Mini runs at its **native release precision (~97.8% top-1 vs BF16)**, fits **100% inside 5090 VRAM with 6.6 GiB to spare**, prefills **1.8x faster**, and brings a **1 million token context window** (right where 2-bit quants tend to degrade first past 100k tokens).

## Conclusion: is it better than Qwen 3.8? Is it the new consumer-hardware king?

**If you are running an RTX 5090 (or a 32 GB GPU) with Basalt, yes: Inkling 2 Mini is the new best overall open-weight model for consumer hardware up to a 5090.**

It solves the two biggest compromises Qwen3.8 Flash-Next forced you to accept: you no longer have to crush a 125B model down to 2 or 3 bits and give up precision, and you no longer need 64 GB or 128 GB of system RAM just to hold offloaded experts. It lives entirely inside VRAM with plenty of room left for your desktop, chews through 32k tokens of context in 2.1 seconds, and went **100 / 100 / 100** on my hard coding canary.

There are just two practical caveats:

* **If you have plenty of system RAM alongside a 5090 and want the fastest possible wall-clock turnaround** on short-to-medium coding loops, **Qwen3.8 Flash-Next `Q2_0`** on Basalt still finishes sooner (5.5 min vs 9.8 min) because it is far less verbose. On my own desktop, I keep Inkling 2 Mini as the primary default and keep Qwen3.8 right next to it in Basalt's multi-model router.
* **If you run on an AMD Strix Halo or another unified-memory machine with lower memory bandwidth**, Qwen3.8 Flash-Next still feels much snappier while streaming output (47 to 65 tok/s vs 14 to 25), despite the slower prefill, at least until more mature HIP kernels arrive for Inkling 2's looped layers.

The bar for what you can run locally without paying a cent in API fees just moved up again. All configs, logs, and raw reports from this run are public in [llm-opensource-benchmark](https://github.com/akitaonrails/llm-opensource-benchmark).
