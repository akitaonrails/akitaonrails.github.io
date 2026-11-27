---
title: "A New Challenger to Qwen 3.8 27B: Inkling 2 Mini"
date: '2026-11-27T13:00:00-03:00'
slug: a-new-challenger-to-qwen-3-8-27b-inkling-2-mini
translationKey: novo-competidor-do-qwen-3-8-27bi-inkling-2-mini
description: "I benchmarked Inkling 2 Mini against Qwen3.8 Flash-Next on an RTX 5090 (Strata and Basalt) and an AMD Strix Halo, including 18 adversarial multi-language tasks from benchmark-v3: Qwen wins on depth (98.4 vs 94.3), while Inkling is a close second, 2.2x faster, and fits 100% in VRAM."
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

![Live Basalt dashboard serving Inkling 2 Mini on the RTX 5090: 100% of experts in VRAM (0% CPU/RAM), 274.5 tok/s average decode (peaks above 306 to 318 tok/s), and prefill reaching 17,407 tok/s](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/27/inkling-2-mini/basalt-inkling-2-mini-toks.png)

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

## The test that actually separated them: Benchmark v3 (18 multi-language tasks)

Because both Inkling 2 Mini and Qwen3.8 Flash-Next saturated the hard canary at **100 / 100 / 100**, I needed a much harsher yardstick to see where each model starts to crack. I stepped up to **`benchmark-v3`** (from my [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark) repo) running inside the exact same network-isolated `bubblewrap` sandbox, with read-only **Python, Ruby, Go, and Rust** toolchains, a **15-minute (900 s) timeout per task**, and both models served via **Basalt** on the RTX 5090: **Inkling 2 Mini (`NVFP4-MX8`)** against **Qwen3.8 Flash-Next (`IQ3_S`)**.

`benchmark-v3` grades **correctness depth**, where any tests the model writes itself count for zero points. Every score comes strictly from **hidden, adversarial test suites** the agent never sees, weighted heavily toward edge cases (empty inputs, overflow, unicode, concurrency, malformed data) alongside hard root-cause, regression, and performance gates. The **18 deliverables** span:

* **Root-cause debugging and safe refactoring in Ruby:** `01-debug-paginator` and `05-refactor-pricing`.
* **Adversarial edge cases in Go and performance in Rust:** `02-edge-csv` and `04-perf-intervals`.
* **Invariants, ambiguity traps, performance, and recovery in Python:** `03-invariant-eventlog`, `06-ambiguity-emails`, `08-perf-rangesum`, `09-sabotage-recover`, and `14-edge-semver`.
* **Security and latent bugs in brownfield code:** `07-security-safebox`, `10-latent-cve-restore`, `11-latent-nplus1`, `12-latent-antipatterns`, and `13-latent-sql`.
* **Algorithms and multi-file projects:** `15-observation-median`, `16-repo-order-service`, `17-marketplace-app` (full app simulation), and `18-resolver-backtrack`.

Here is the final scoreboard across all **18 tasks**:

| Metric (Basalt on RTX 5090) | Qwen3.8 Flash-Next (`IQ3_S`) | Inkling 2 Mini (`NVFP4-MX8`) |
|---|---:|---:|
| **Final mean v3 score** | **98.4** (18/18) | **94.3** (18/18) |
| **Perfect 100 scores** | **15 of 18** | **13 of 18** |
| **Total wall time** | **76.3 min** | **34.1 min** (2.2x faster) |
| **Total output tokens** | **679.7k** | **771.5k** |
| **System RAM offload** | ~42 GB | **0 GB** |

And here are the notable tasks where the two separated on depth or speed (on the other 9 tasks, both scored a clean **100.0** without drama):

| Task (Language) | Inkling 2 Mini (Score / Time / Reqs) | Qwen3.8 `IQ3_S` (Score / Time / Reqs) | What happened |
|---|---:|---:|---|
| `02-edge-csv` (Go) | **100.0** / 900s (TO) / 377.5k tok | **100.0** / 101s / 19.0k tok | Inkling looped long enough to hit timeout yet still aced it |
| `07-security-safebox` (Python) | 89.1 / 31.7s / 14 reqs | **100.0** / 243.4s / 30 reqs | Qwen dug twice as deep and closed every hole |
| `08-perf-rangesum` (Python) | **100.0** / 4.2s / 1.4k tok | **100.0** / 900s (TO) / 46.8k tok | Inkling solved it in 4 s; Qwen hit the timeout |
| `10-latent-cve-restore` (Python) | 37.5 / 13.0s / 5 reqs | **75.0** / 212.8s / 53 reqs | Largest gap in the suite: Inkling stopped far too early |
| `14-edge-semver` (Python) | **100.0** / 796.3s / 261.3k tok | **100.0** / 847.6s / 157.1k tok | Heavy grind on extreme semver edge cases |
| `15-observation-median` (Python) | 78.7 / 65.9s / 7 reqs | **100.0** / 71.3s / 11 reqs | Qwen nailed the full algorithm in the same time window |
| `16-repo-order-service` (Python) | **98.3** / 17.3s / 7.3k tok | **98.3** / 220.7s / 43.1k tok | Exact tie with Inkling running 12.7x faster |
| `17-marketplace-app` (Python) | 93.1 / 117.9s / 25 reqs | **98.6** / 498.3s / 91 reqs | Qwen worked methodically across 91 steps and nearly aced it |
| `18-resolver-backtrack` (Python) | **100.0** / 16.2s / 6.5k tok | **100.0** / 900s (TO) / 55 reqs | Inkling solved it in 16 s; Qwen hit 15 min yet still aced it |

The **requests per task** column tells the whole story. **Qwen3.8 Flash-Next `IQ3_S`** (backed by 125B total parameters) is slower, yet far more **methodical and persistent** when the problem involves security, latent CVEs, or multi-file apps: on `10-latent-cve-restore`, Inkling declared victory in 13 seconds and 5 calls (scoring 37.5), while Qwen investigated across 53 calls and doubled the score to 75.0. On `17-marketplace-app`, Qwen made 91 tool/reasoning calls (98.6) versus 25 for Inkling (93.1).

On the flip side, Inkling 2 Mini's speed is wild: **28.3 of its 34.1 minutes** went to just two edge-case tasks (`02-edge-csv` and `14-edge-semver`). Across the **other 16 tasks combined**, it tore through all of them in **5.8 minutes total**, matching Qwen's 98.3 score on `16-repo-order-service` while finishing **12.7x faster** (17.3 s vs 220.7 s).

## The five insights that actually matter

Stepping back from the full suite (speed, hard canary, and benchmark-v3), five practical takeaways stand out:

1. **The inference engine matters as much as the model.** On Strata (`0.1.69`), Inkling 2 Mini felt sluggish on a 5090 (110 to 154 tok/s). Moving the exact same model to **Basalt `v0.5.7`** boosted decode **2.3x** to **250 to 346 tok/s** and cut 32k TTFT from 5.1 s down to **2.1 s** by exploiting Blackwell's native FP4 Tensor Cores.
2. **The looped architecture has a real cost on bandwidth-limited memory.** On the **AMD Strix Halo**, Inkling 2 Mini had 41.9 GiB of free VRAM and prefilled 32k prompts **1.7x faster** than Qwen3.8 (51 s vs 114 to 126 s). Yet decode dropped to **14 to 25 tok/s** versus **47 to 65 tok/s** for Qwen3.8, because running the 12 middle layers three times per token hits LPDDR5X memory bandwidth hard.
3. **Total parameters still show up on security and latent bugs.** Depth looping lets 26.4B Inkling 2 Mini tie a 125B MoE on 13 of 18 hard tasks, yet when a task requires hunting down subtle vulnerabilities or holding invariants across a larger app, Qwen3.8 `IQ3_S` digs deeper, misses less, and wins overall (**98.4 vs 94.3**, with 15 perfect 100s vs 13).
4. **Watch out for reasoning spikes on edge cases.** Inkling 2 Mini can fly through 16 tasks in 5.8 minutes or burn hundreds of thousands of tokens obsessing over an edge case (`377.5k` tokens on `02-edge-csv`, `261.3k` on `14-edge-semver`, `140k to 204k` on the hard canary). Even with those spikes, it still finished all 18 v3 tasks **2.2x faster** than Qwen3.8 `IQ3_S` (**34.1 min** vs **76.3 min**).
5. **Your hardware footprint decides which model makes sense on your desk.** Use the guide below to judge what fits your machine:

| Hardware Profile | Recommended Model | Memory Footprint | Expected Speed | What it handles well |
|---|---|---|---|---|
| **RTX 5090 (32 GB) + 64 GB+ RAM** | **Qwen3.8 Flash-Next (`IQ3_S` on Basalt)** | 28 GB VRAM + ~42 GB RAM | 223 to 231 tok/s, 5.2 s TTFT | Best overall depth (98.4 on v3), security audits, refactors, complex apps |
| **Smaller than 5090 (24 to 32 GB GPU) or only 32 GB RAM** | **Inkling 2 Mini (`NVFP4-MX8` / GGUF)** | ~20 to 25 GB VRAM, **0 GB RAM** | 250 to 346 tok/s on 5090 (2.1 s TTFT) | Close second (94.3 on v3), fast coding agent, 100% VRAM resident |
| **MacBook / Apple Silicon 32 GB+ unified** | **Inkling 2 Mini (MLX / Ollama)** | ~20 GB unified | Smooth local sessions | Best quality-per-gigabyte without needing 64 GB+ RAM |
| **AMD Strix Halo (64 GB VRAM + GTT)** | **Qwen3.8 Flash-Next (`Q2_0` / `IQ3_S`)** | ~42 to 58 GB VRAM | 47 to 65 tok/s (slow prefill) | 2.5x to 3x smoother decode than Inkling on LPDDR5X |

## Conclusion: is it better than Qwen 3.8? Which one should you run?

**On pure engineering depth, no: Qwen3.8 Flash-Next (`IQ3_S`) is still the better overall model, even though it is significantly slower.**

On my **RTX 5090** (with plenty of desktop RAM to hold Basalt's expert offload), I prefer **Qwen3.8 Flash-Next** as my primary workhorse for serious coding. The final **98.4 vs 94.3** gap across all 18 adversarial multi-language tasks (**15 perfect 100s** vs 13) shows up right where mistakes hurt most in production: security, latent vulnerabilities, and discipline across multi-file projects.

**Inkling 2 Mini is a very close second and 2.2x faster** (34.1 min vs 76.3 min on v3), and it completely changes the equation if you do **not** have an RTX 5090 paired with 64 GB or 128 GB of system RAM. For setups smaller than a 5090 (24 to 32 GB GPUs without massive RAM headroom for offload, or 32 GB unified-memory laptops), **Inkling 2 Mini is my direct recommendation**: it runs at native precision (~97.8% vs BF16), fits in ~20 GB with zero RAM offload, delivers **2.1 s TTFT**, supports a 1 million token context window, and posted **94.3** on an adversarial four-language benchmark.

On my own 5090 desktop, the sweet spot is keeping **Qwen3.8 Flash-Next** as the default for critical work while keeping **Inkling 2 Mini** right beside it in Basalt's multi-model router for fast iterations. All configs, logs, and raw reports are public in [llm-opensource-benchmark](https://github.com/akitaonrails/llm-opensource-benchmark).
