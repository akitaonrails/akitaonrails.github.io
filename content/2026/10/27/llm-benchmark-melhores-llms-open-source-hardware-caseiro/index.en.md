---
title: "LLM Benchmark: What Are the Best Open Source LLMs for Home Hardware?"
slug: llm-benchmark-best-open-source-llms-for-home-hardware
date: '2026-10-27T13:00:00-03:00'
translationKey: llm-benchmark-melhores-llms-open-source-hardware-caseiro
description: "I tested four Qwen3.8 Flash-Next quantizations on an RTX 5090 and a Strix Halo. Q2_0 won: it scored 100 and finished the hard test in 7.2 minutes, versus 12.1 for IQ3_S."
tags:
- llm-benchmarks
- local-models
- llms
- hardware
draft: false
---

In the [last LLM Benchmark about open source models](/en/2026/10/22/llm-benchmark-v4-the-open-source-verdict-as-of-oct-2026/), I pushed things as far as was reasonable. I rented B300s, H200s, four-GPU pods, ran almost 70 rounds, and spent more than $6,000 on the whole campaign. It produced strong candidates such as DeepSeek V4.1 Flash, GLM 5.3 Flash, and Qwen3.8 Flash-Next, all close to frontier models in my programming test.

The machine remained the problem. A 510 GB model that needs four B300s may be open source on GitHub, but it is still beyond the reach of anyone who wants to run an AI in a home office.

I went back to my RTX 5090 and Strix Halo. Instead of repeating the full v4 benchmark on dozens of models that we already know will not fit or run fast enough, I took the most promising candidate and compared **its quantizations**. Which version preserves enough quality without turning every interaction into a wait of several minutes?

The result surprised me: **the 2-bit version won**.

## The RTX 3090 and 4090 got a second wind

Before my results, the community found a limitation that could be removed. On GeForce RTX 20 cards, some FP16 Tensor Core operations with FP32 accumulation run at half the theoretical issue rate per cycle of their professional equivalents. On RTX 30 and 40 cards, the limit also affects BF16.

The hardware is there. Two internal registers select the speed, and the normal driver does not have enough privilege to change them.

The [gpu-unlock](https://github.com/Zagitta/gpu-unlock) project found a way to change those registers before the NVIDIA driver takes over the card. On Ampere, it exploits a buffer overflow in the signed Booter that authenticates and loads GSP-RM. The change lasts for that boot: a reboot resets everything, and nothing is written to the VBIOS.

It also requires Linux, initramfs, and a lot of care. I would not install this on a production workstation without reading the code and understanding the risk.

This is a community hack with no official NVIDIA support. You install it at your own risk. Its value for LLMs is faster prefill when the engine uses this exact Tensor Core path. Other compute applications, including some image-generation pipelines, may also change in performance. Games depend on different GPU paths and bottlenecks, so do not expect higher frame rates from it.

On an RTX 3090, FP16 with FP32 accumulation went from 70.95 to 122.49 TFLOPS; BF16 went from 70.29 to 127.30. On the 4090, an implementation that is still experimental measured roughly twice the FP16 and BF16 instruction issue rate.

Doubling TFLOPS does not double your LLM. The [test that prompted this discussion](https://dev.to/orca_forge/why-gpu-unlock-speeds-up-rtx-3090-prefill-but-barely-changes-decode-4572) separated the two phases:

- **Prefill** is when the model reads the whole prompt. Many tokens are available at once, so the engine can build large parallel matrix operations. The unlock improved some 3090 tests by 8% to 13%.
- **Decode** is when the model generates one token after another. With a quantized LLM using expert offload, this phase is constrained mainly by memory bandwidth, RAM, PCIe, and the expert cache. The measured change stayed within noise.

On the heavier Qwen quantization, the prefill gain nearly vanished too. A test on a modified 48 GB 4090 measured 0.983x, essentially nothing. The computation path used by a quantization may never touch the FP16/BF16 path that was unlocked.

> gpu-unlock accelerates a specific Tensor Core path. It may reduce the wait when reading large prompts, but it does not turn 24 GB into 96 GB or create memory bandwidth.

Even with that caveat, the 3090 and 4090 became more interesting for local inference. A used [RTX 3090](https://www.nvidia.com/en-us/geforce/graphics-cards/30-series/rtx-3090-3090ti/) still has 24 GB of VRAM, NVLink in its generation, and 936 GB/s of bandwidth. The community is already running Qwen3.8 Flash-Next on one 3090 at 43 to 51 tokens per second, and on two cards at 84 to 111 tokens per second depending on the configuration. Those are community results, not measurements from this round.

## Why I chose Qwen3.8 Flash-Next

In v4, the open candidates that really interested me were:

| Model | Where I ran it | v4 score | Speed |
| --- | --- | ---: | ---: |
| DeepSeek V4.1 Flash | 4x B300, native checkpoint | 92.5 | 174.8 tok/s |
| GLM 5.3 Flash | 1x B300, NVFP4 | 92.5 | 142 tok/s |
| Qwen3.8 Flash-Next | 1x B300, NVFP4 | 92.5 | 195 tok/s |
| Qwen3.8 Flash-Next | RTX 5090, IQ3_S | 91.0 | 159.2 tok/s |

The three tied within the noise margin. Only Qwen repeated that quality on consumer hardware. Its main model is a 125-billion-parameter MoE with roughly 6 billion active parameters per token, plus 51 billion parameters in n-gram embeddings and a 4-billion-parameter MTP head. [Strata](https://github.com/Niko1221/Strata) keeps the most frequently used experts on the GPU, keeps the rest in RAM for the CPU to compute, reads the n-gram table from the SSD, and uses the model's own MTP layer to speculate the next tokens.

DeepSeek V4.1 has about 748 billion parameters in total: 552 billion in the backbone and 196 billion in Engram. I served its native mixed FP4/FP8 checkpoint, about 510 GB, on the four-B300 pod.

I also managed to start a 2-bit version on the 5090 using Strata's dedicated engine. It generated around **17 tokens per second**. It runs. It is out of the race for a programming agent.

The GLM 5.3 Flash NVFP4 checkpoint was around 198 GB and ran on the B300. This repository has no consumer configuration that I measured and can recommend. The smaller GLM 4.7 Flash had already scored 24 on the 5090 and 33.5 on the B300 in the previous benchmark. Spending days forcing the wrong family to fit would not produce useful information.

I also left out Qwen 4 and Llama by choice. This round asks a narrow question: **which version of the model that already proved its quality works best on the two machines I own?**

## What I tested

All the code, prompts, hidden tests, and results are in [llm-opensource-benchmark](https://github.com/akitaonrails/llm-opensource-benchmark). I tested four Qwen3.8 Flash-Next versions:

| Quantization | Model files | Idea |
| --- | ---: | --- |
| Q2_0 | ~62 GiB | 2 bits, smaller and more aggressive |
| IQ3_XXS | ~71 GiB | 3 bits, optimized for size |
| IQ3_S | ~78 GiB | 3 bits, more precision |
| UD-Q4_K_XL | ~104 GiB | 4 bits, preserves more of the weights |

The files include a shared PLE component, so the full size does not fit directly in VRAM. Strata handles loading and unloading experts.

On the RTX 5090, I used Strata's CUDA backend with:

- 4 GiB of VRAM reserved for Hyprland, the browser, and the terminal;
- `int8` KV cache, a 128K maximum context, and 32K resident on the GPU;
- an elastic expert cache;
- four-token speculation with the model's MTP.

On the Strix Halo, I used the `hip-halo` backend. That machine has 64 GB reserved for the GPU and 31 GB of GTT mapped over system RAM; the engine's RAM limit was 61.9 GiB. Since it is headless, I gave the entire GPU to the model and kept 8 GiB of headroom for the conversation cache.

Underneath, these are two different backends, CUDA on NVIDIA and HIP/ROCm on AMD, with the same engine and the same OpenAI-compatible API. That removes one important variable: I am not comparing Ollama on one side with vLLM and a different template on the other.

## Methodology

I started with a speed test in three situations:

1. a cold 4K-token prompt;
2. a cold prompt labeled 32K, which this model's tokenizer counted as 42,400 tokens;
3. a continuation of the same conversation, reusing the cache.

Each one generates 256 tokens. The runner measures time to first token, prompt processing, generation, VRAM, RAM, power, and temperature.

### What each speed number means

When someone says an LLM runs at 200 tokens per second, they are almost always talking only about generation. An agent session goes through different phases, and each phase hits a different bottleneck.

**Prefill** is the initial reading of the prompt. The model must process the harness instructions, conversation history, files, and your question before producing its first word. Since all those tokens are available at once, the GPU can process large matrices in parallel.

This phase makes better use of Tensor Cores and raw compute. The larger the context, the more it matters.

| Metric | What it measures | What you feel |
| --- | --- | --- |
| Prompt tok/s | Prefill throughput, or how many input tokens are read per second | Time to digest new context |
| TTFT (*time to first token*) | Total time between sending the request and receiving the first token | The pause before the answer starts |
| Decode or output tok/s | Generation speed after the first token | Pace of text and tool calls |
| TPOT (*time per output token*) | Time per generated token, usually reported at p50 and p99 (or p95) | Response consistency; a high tail percentile exposes stalls |
| Wall time | Time for the whole task, including tools, tests, retries, and generated text | Actual agent productivity |

The **KV cache** stores intermediate states for tokens that have already been processed. On a continuation of the same conversation, the model reuses that state instead of reading everything again. That is why the append test reaches tens of thousands of prompt tokens per second and receives the first token in roughly half a second. That number measures cache reuse; comparing it with cold prefill would be dishonest.

The KV cache also grows with the conversation and competes with weights, experts, and buffers for memory. Here it uses `int8`, with 32K resident on the 5090. Advertised maximum context, context that fits, and context that stays fast are three different numbers.

**Speculative decoding** uses a draft layer to propose several tokens and lets the main model verify the batch. Output tok/s goes up when the acceptance rate is good. The benefit vanishes when the draft misses too often. The speeds in this round already include MTP with four-token speculation.

One metric is missing because I did not measure it here: **concurrency**. Every number in this article comes from a single stream. A server can handle several sessions and raise aggregate throughput, while each user will usually receive fewer tokens per second.

For individual use, single-stream performance and wall time are what matter. A team must measure simultaneous sessions and per-user latency, as I did in the [B300 and H200 test](/en/2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/).

Then came two programming tests using OpenCode 2.1.4. The model receives a small Python codebase, works in one continuous session, and never sees the hidden tests. Everything runs inside Bubblewrap, without network access, with a limited filesystem and a local gateway that accepts calls only to the expected model.

The first canary has three turns and 9 hidden tests. The model must implement a log analyzer, fix bugs, and handle changed requirements.

The hard canary has four turns and 36 hidden tests. It is a payment reconciler with decisions buried inside a 64K-token history, one decision corrected later, rejected proposals used as distractions, money that requires exact decimals, and new rules that interact with earlier ones. With OpenCode's system prompt, the first turn approaches 83K tokens.

### A separate yardstick from benchmark v4

These canaries are much smaller and easier. In v4, the model works on a Rails application for seven sprints while a reviewer injects 14 security and correctness defects. The score measures how many defects it finds and fixes on its own before they are revealed. It is a vigilance test with much more code, more tools, and more opportunities to lose track.

Here I use two small Python codebases, three or four turns, and hidden functional tests. I built this yardstick to compare **quantizations of the same Qwen** and find out whether reducing the bits breaks requirements, context retention, or process. The comparison ends there. Qwen, Opus, GPT, DeepSeek, and the other model families remain a job for v4.

A score of 100 in this article belongs to a different scale, with no equivalence to 100 in v4. It also does not make Q2_0 "better" than the IQ3_S version that scored 91 in v4. V4 selected Qwen as the candidate; this smaller test selects which Qwen file is worth loading at home.

> Speed without quality only makes the model fail faster. That is why I measured them separately.

## Speed ranking

### RTX 5090, with 4 GiB reserved for the desktop

| Quantization | Generation | Long-input processing | First token |
| --- | ---: | ---: | ---: |
| **Q2_0** | **223 to 259 tok/s** | **6,158 tok/s** | **6.9 s** |
| IQ3_XXS | 196 to 241 tok/s | 5,084 tok/s | 8.3 s |
| IQ3_S | 158 to 208 tok/s | 6,233 tok/s | 6.8 s |
| UD-Q4_K_XL | 44 to 52 tok/s | 2,300 tok/s | 19 s |

### Strix Halo, using the whole GPU

| Quantization | Generation | Long-input processing | First token |
| --- | ---: | ---: | ---: |
| **Q2_0** | **55 to 65 tok/s** | **371 tok/s** | **114 s** |
| IQ3_XXS | 50 to 57 tok/s | 347 tok/s | 122 s |
| IQ3_S | 47 to 50 tok/s | 338 tok/s | 125 s |
| UD-Q4_K_XL | 17 tok/s on one 4K prompt | 137 tok/s | did not finish |

The 5090 has 32 GB of GDDR7 and [1,792 GB/s of bandwidth](https://www.nvidia.com/en-us/geforce/graphics-cards/50-series/rtx-5090/). The Strix has more total capacity, but its roughly 256 GB/s must serve the entire system. The difference shows up mainly in prefill: 6.9 seconds versus almost 2 minutes to start answering the 42,400-token workload.

Q4 gave me the worst of both worlds. On the 5090 it ran slowly, and `systemd-oomd` killed the quality test. On the Strix, it exhausted VRAM, started paging, and froze the machine until a reboot. More bits preserve more information, but they also use more memory and shrink the hot cache that makes this MoE move.

## Quality ranking

The simple test separated nothing:

| Quantization | RTX 5090 | Strix Halo |
| --- | ---: | ---: |
| Q2_0 | 100 | 100 |
| IQ3_XXS | 100 | 100 |
| IQ3_S | 100 | 100 |

All three passed the 9 hidden tests, preserved the requirements, and finished with the visible suite green. I had to make the test harder.

In the hard canary, I ran Q2_0 and IQ3_S three times each on the 5090:

| Run | Score | Hidden tests | Time for 4 turns | Output tokens |
| --- | ---: | ---: | ---: | ---: |
| Q2_0 r1 | 100 | 36/36 | 5.3 min | 70K |
| Q2_0 r2 | 100 | 36/36 | 8.8 min | 117K |
| Q2_0 r3 | 100 | 36/36 | 7.4 min | 100K |
| IQ3_S r1 | 100 | 36/36 | 11.9 min | 110K |
| IQ3_S r2 | 100 | 36/36 | 13.3 min | 127K |
| IQ3_S r3 | 100 | 36/36 | 11.1 min | 98K |

Both versions got everything right in all three runs. They found the decisions in the long context, respected the later correction, handled out-of-order events, chargebacks, currency conversion, and completed the final refactor. They also went through a similar number of failing test runs while working.

The difference was on the clock. **Q2_0 took 7.2 minutes on average. IQ3_S took 12.1.** The 2-bit model delivered the same result in roughly 60% of the time.

The evidence covers small Python codebases, contexts up to roughly 85K tokens, and only three repetitions of the hard canary. A 2-bit quantization will usually lose quality first on contexts above 100K and on larger codebases. Within the use I measured, spending more bits bought no quality.

## What each version showed

### Q2_0: the current recommendation

It was the fastest on both machines and finished every test with a perfect score. On the 5090, 223 to 259 tokens per second is already comfortable for an agent. On the Strix, 55 to 65 tokens per second is usable, although long prefill costs almost two minutes before the first answer.

I would use this version every day and keep the context caveat in mind. Large project, session approaching 100K, or strange behavior? I repeat the same work with IQ3_S before blaming the model.

### IQ3_XXS: no clear role

It passed the simple canary and ran quickly, but Q2_0 was faster and uses less space. I did not run the three hard-test repetitions on IQ3_XXS, so I have no data showing a quality advantage.

### IQ3_S: the conservative option

This is still the version I would use to validate a suspicious Q2_0 result. It had already scored 91 in benchmark v4 on the 5090, only 1.5 points below its NVFP4 version on the B300. In this round, though, it took almost 70% longer than Q2_0 and found nothing that the smaller version had missed.

### UD-Q4_K_XL: quality that does not fit is useless

It was the intuitive candidate for preserving more fidelity. I ran out of memory before reaching the test that could confirm it. On the 5090, it fell below one quarter of Q2_0's speed and the system killed the run. On the Strix, the machine froze.

The largest quantization that fits on paper can be the worst real configuration. An MoE depends on the space left for experts, KV cache, buffers, and the operating system itself.

## Which hardware is worth it?

### RTX 3090 and 4090: good if you already own them

Both have 24 GB, which limits the expert cache. gpu-unlock improves prefill in workloads that use the unlocked path, while decode remains constrained by memory and offload. A used 3090, especially two of them with NVLink, can make an interesting local machine. I would not buy a new 4090 today just for this: it still has 24 GB, costs a lot, and the Ada unlock remains experimental.

For either one, I would start with **Qwen3.8 Flash-Next Q2_0** and measure my workload. The community's 43 to 51 tokens per second on a single 3090 already clears the tolerable range. Two 3090s provide a much better experience, provided you accept the power draw, heat, PSU requirements, and 128 GB of RAM.

### Strix Halo: plenty of capacity, little bandwidth

It is a good compact and efficient headless box. Unified memory lets it run models that a 24 or 32 GB GPU would reject. In this test, the best model was also **Q2_0**, at 55 to 65 tokens per second.

The problem appears every time the agent reads a large context. Almost two minutes to process the long workload adds up quickly during a session. I would use it as a private server for asynchronous tasks, simple agents, and workloads where capacity matters more than immediate response.

### RTX 5090: the best home option today

The [RTX 5090](https://www.nvidia.com/en-us/geforce/graphics-cards/50-series/rtx-5090/) has 32 GB, 21,760 CUDA cores, and the same nominal 1,792 GB/s bandwidth as the RTX PRO 6000. Capacity is the missing piece: I must reserve 4 GiB for the desktop and use RAM and SSD for the experts that do not fit.

Even so, it pushed Q2_0 to 223 to 259 tokens per second and read the long workload at 6,158 tokens per second. This is the first local configuration that does not make me feel like I am waiting for the machine at every step. It is also a card I can use for gaming, image generation, video, and everything else in the workstation.

### RTX PRO 6000: three times the VRAM, server-class price

The [RTX PRO 6000 Blackwell](https://www.nvidia.com/en-us/products/workstations/professional-desktop-gpus/rtx-pro-6000/) has 96 GB of GDDR7 ECC, 24,064 CUDA cores, and the same 1,792 GB/s bandwidth. The extra capacity keeps many more experts resident, makes room for a larger quantization, and holds context without fighting the desktop for the last few gigabytes.

It costs [$16,000 in NVIDIA's store](https://marketplace.nvidia.com/en-us/enterprise/laptops-workstations/nvidia-rtx-pro-6000-blackwell-workstation-edition/), eight times the 5090's suggested $1,999 price. I have not run this benchmark on one, so I will not invent a speed. Equal bandwidth means that three times the memory will not produce three times the tokens per second. Its gain comes from keeping more data on the card and avoiding the slow RAM and PCIe path.

For individual use, the 5090 makes more financial sense. The PRO 6000 starts to make sense when 96 GB solves a model you actually need, when ECC and professional support matter, or when several sessions will share one card.

## Verdict

| Hardware | Best choice today | Experience |
| --- | --- | --- |
| 1x RTX 3090/4090, 24 GB | Qwen3.8 Flash-Next Q2_0 | Viable with offload; check prefill and decode on your stack |
| Strix Halo | Qwen3.8 Flash-Next Q2_0 | 55 to 65 tok/s; long prompts take time |
| RTX 5090 | **Qwen3.8 Flash-Next Q2_0** | 223 to 259 tok/s; best balance I measured |
| RTX PRO 6000 | Probably IQ3_S or larger | Excellent capacity, unmeasured in this round |

Local open source models have finally entered a practical range. A single 5090 runs a model that reached Tier A in my v4 benchmark and, with Q2_0, reached 259 tokens per second in the canary. The Strix also did far better than the 7.7 tokens per second from the dense Qwen I had tested before.

The limits remain clear. Context consumes memory, the desktop needs the same VRAM, and every expert outside the card travels over PCIe or falls back to RAM. DeepSeek at 17 tokens per second shows how useless "it runs" can be as a metric. If every iteration takes several hours, model quality stops mattering because nobody can work that way.

> For home hardware, the best model preserves enough quality at a speed that lets you iterate. In this round, that was Qwen3.8 Flash-Next Q2_0 on the RTX 5090.

The [benchmark repository](https://github.com/akitaonrails/llm-opensource-benchmark) has the runners, configurations, raw results, and hidden tests. Repeat it on your machine and send results. Hardware, engine, quantization, and context change the answer. A ready-made ranking is a starting point; the final decision is still measured against your own work.
