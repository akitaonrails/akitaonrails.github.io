---
title: "LLM Benchmark v4: consumer-grade open source on RTX 5090 or Strix Halo. And Strata?"
slug: "llm-benchmark-v4-consumer-open-source-rtx5090-strix-halo-strata"
date: '2026-10-22T11:30:00-03:00'
draft: false
translationKey: llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata
description: "I went back to consumer hardware after the datacenter tests. Qwen3.8 Flash-Next scored 91.0, Tier A, on an RTX 5090 with the Strata engine, 1.5 points behind the B300 and at 159 tokens per second. It is a different model from the Qwen 3.8 27B I had called too slow: a MoE with 6B active per token, served with the most-used experts on the card. The Strix Halo scored 80.0 with the 27B, but at 7.7 tokens per second. It is the first local model to make Tier A on v4 that is worth testing for day-to-day programming, if you can find a 5090: NVIDIA denies ending production, but admits supply is tight."
tags:
- llm-benchmarks
- local-models
- llms
- hardware
images:
- /2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/dgx-spark-box.jpeg
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
| RTX 5090 | 32 GB GDDR7 | ~1.8 TB/s | Blackwell sm_120, FP8/FP4 | US$ 1,999 MSRP (~5x at retail) |
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
- **Speculation only helps with high acceptance.** In a [test by Mihai Farcas](https://mihai.ltd/blog/beating-llamacpp-from-scratch-consumer-amd) on an RX 7900 XTX, llama.cpp's n-gram speculation with no draft model had only 5 of 64 tokens accepted, and throughput stayed flat in one run and dropped about 2% in the other. The gain shows up with a drafter built for the model, like the helper Strata uses for Flash-Next.

## What is this Strata thing

[Strata](https://github.com/Niko1221/Strata) is an open source inference engine, MIT licensed, built around one model: **Qwen3.8 Flash-Next**, a 125-billion-parameter MoE that normally needs a server. It also runs smaller MoEs, like the Ornith-35B I tested here. The code is C++ and CUDA and reuses parts of llama.cpp/ggml. It has builds for NVIDIA (CUDA 12 and 13), AMD (Strix Halo included), Intel Arc and Apple Silicon, and it serves an OpenAI- and Anthropic-compatible API on localhost that plugs straight into Claude Code, Codex CLI or OpenCode.

Watch out for the name. Mihai Farcas published [another engine called Strata](https://mihai.ltd/blog/beating-llamacpp-from-scratch-consumer-amd), in Rust with HIP kernels, for small dense Qwen 3.5 models on an RX 7900 XTX. They are different projects, and the one that ran here is the first.

The problem it attacks is the big MoE on a small machine. The strategy is **expert-offload**, in tiers:

- the model has 24,576 experts, 512 in each of its 48 layers, and each token uses only 10 per layer;
- the GPU holds about 4 thousand experts, the most-used ones;
- system RAM holds all of them;
- a lookup table of about 29 GB sits on the SSD, and the model reads a few rows of it per token.

On top of that, a small helper guesses the next words and the big model checks all of them at once. The README promises the same answer 1.6 to 1.8 times sooner. The minimum is 32 GB of RAM and VRAM combined, plus about 80 GB of disk, and the IQ3_S variant I used is about 55 GB.

What made me believe in it was the result: **Qwen3.8 Flash-Next on the 5090 with Strata scored 91.0, with zero nudges and all 14 items solved**, 1.5 points behind the 92.5 the same model scored on the B300 with vLLM. The report itself calls that "within the noise". A community project, on a consumer card, landed right next to the same model served in a datacenter in NVFP4.

## Careful: Strata eats the whole GPU, and the desktop dies

There is a cost that does not show up in the benchmark: running Strata on the same GPU that draws your desktop. It was built to fill the card, and it does.

On my machine, the engine allocated 32,085 of the 5090's 32,607 MiB, or 98.4% of its VRAM. Hyprland was left with about 500 MiB, desktop allocations failed, and even the terminal stopped responding. Only a hard reset brought it back.

Two failures happened in sequence. I had configured a 2,560 MiB reserve, but the proxy fired once, swallowed the exception and never tried again. The engine's `/v1/vram` endpoint was not up yet, so the reserve was never applied. And 2,560 MiB was already too little for Hyprland, the browser and the terminal together.

The fix, validated under load:

- A **4,096 MiB** (4 GiB) reserve, with retries for up to a few minutes, response verification and a confirmation log. No fire-and-forget.
- Reapply the reserve every 30 seconds while the engine is loaded, closing any rebalance drift.
- In the first load test, with the GPU at 99%, **3,629 to 3,888 MiB stayed free throughout generation**. In the next test, one long generation and three concurrent requests all succeeded; the lowest observed headroom was 3,949 MiB. The desktop stayed alive.

The price shows up in throughput. The expert cache dropped from about 11,700 slots to 9,700, so more experts travel over PCIe. In the initial measurement, throughput went from ~200 to ~150 tokens per second. I will happily pay that: a desktop that does not freeze is worth those 25% in that test.

There is a structural alternative: this machine has an integrated Radeon 610M, and I could move Hyprland to it. The 5090 would be dedicated to inference.

The cost is that the 610M is weak for games and NVIDIA multi-GPU on Wayland has its quirks. I chose the elastic reserve because the model also unloads when idle.

The general lesson: **do not let an inference engine take 100% of a GPU that also draws your screen.** In this setup I have no hard driver-level VRAM reserve for the display client. I had to solve it on the engine side: reserve a few GB, reapply it after every cold start, and measure again with the desktop open.

### The same 32 GB also limits the session

The 5090 budget is tight from every side. The same 32 GB has to hold the model's dense weights and fixed buffers, the hot-expert cache, the resident portion of the KV cache, and the 4 GiB reserve for Hyprland, the browser and the terminal. Giving memory to one takes it from another.

The KV cache is the conversation's memory. Every token in the prompt, previous responses and files read creates state the model needs for the tokens that follow. My Strata setup uses `int8` KV with 32K cells per layer resident on the GPU.

The rest can stream from system RAM, which is why raising the window from 128K to 256K did not increase VRAM use or reduce speed in my synthetic test. Streaming prevents the immediate blowup while still consuming memory. It does not turn a 5090 into an unlimited server.

The configured ceiling here is **262,144 tokens, or 256K**. Several commercial models I tested, including the newer Claude models, already operate in the 1-million-token class. A window almost four times larger changes how you work: Claude Code can accumulate much more history before compaction; with local Qwen I have to treat context as a budget from the first prompt.

The conversation visible in the terminal is only one part of the context. Depending on the harness, it can also include the system prompt, `AGENTS.md` and `CLAUDE.md`, skill catalogs and loaded skill contents, tool descriptions and schemas, MCP servers, plugin instructions, command output, files, and the room reserved for the answer. A well-built skill loads its full text only when invoked, but its catalog entry may still reach the prompt. A plugin that registers twenty tools also sends twenty schemas before you ask for anything.

That is why the benchmark did not use my regular OpenCode setup. The runner [generates an isolated configuration](https://github.com/akitaonrails/llm-coding-benchmark#local-opencode-benchmark-config), without global plugins or MCP servers, containing only the providers and agents needed for the test. It also pins the real 262,144-token limit instead of pretending the model accepts the context advertised by some other backend.

For daily work with this Qwen, I would apply the same discipline:

- start with the thinnest possible harness and enable plugins or MCP servers only when the project needs them;
- keep heavy skills on demand instead of dumping whole manuals at the beginning of the session;
- compact or open a fresh session before hitting the ceiling, recording important decisions in project files;
- leave room for model output. A window packed with input is useless when the model has no tokens left to think, call tools and answer.

> With 256K, context is a hardware resource. Installing too many integrations and loading everything in every session consumes window and memory before the work begins.

## Wasn't Qwen 3.8 too slow?

It was, and I wrote that. In the [v4 ranking](/en/2026/09/15/new-llm-benchmark-v4-retesting-39-llms-part-2/), Qwen 3.8 27B running locally took almost 12 hours to finish the seven sprints. In the [B300 article](/en/2026/10/19/llm-benchmark-v4-the-top-open-source-llms-on-a-b300/) I summed it up: it scored 80, took 706 minutes, "so don't even try".

Except that one is a different Qwen 3.8. The family has both, and they behave in opposite ways at home:

| | Qwen 3.8 27B | Qwen3.8 Flash-Next |
| --- | --- | --- |
| Architecture | dense, 27B | MoE, 125B total, 6B active per token |
| Where it finished v4 | Strix Halo, Q8_0 | RTX 5090, IQ3_S, Strata |
| Speed | 7.7 tok/s | **159.2 tok/s** |
| v4 score | 80.0 (B) | **91.0 (A)** |

### Why the bigger one runs faster

When generating tokens, a local machine is limited by memory bandwidth: every token has to read all the active weights. The dense 27B reads all 27 billion on every token, about 29 GB in Q8. The Strix moves about 256 GB/s, so the ceiling sits near 9 tokens per second, and I measured 7.7.

On the 5090 the same 27B would be fast, but in Q8 it doesn't fit in 32 GB together with the context that seven sprints pile up. In Q5_K_M it fit, but it got stuck in a reasoning loop on sprint 3. It finished on the Strix, in Q8_0 with reasoning turned off (`--reasoning off`), which is what broke the loop.

Flash-Next has almost five times as many parameters in total, but only about 6 billion work on each token. At 3 bits, that's roughly a tenth of what the 27B in Q8 has to read. The hot experts sit in the 5090's GDDR7, with seven times the Strix's bandwidth, and the speculation helper gets tokens ahead. The result: about 20 times the speed of the 27B on the Strix, with a higher score.

> The turn came from switching model and engine: a MoE with few active parameters, served by an expert-offload engine built for it. No configuration flag would get that out of the dense 27B on the Strix.

### Tuning still charges its price

The cost of running at home changes from model to model. Flash-Next at 3 bits lost only 1.5 points against the B300's NVFP4 version. Ornith-35B, on the same engine and the same card, lost 16.5 against its own BF16 version on the B300. Measure your model before you trust it.

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

**Yes, with the right model and engine.** An RTX 5090 with Strata delivers Tier A code-review vigilance, at 159 tokens per second, without paying a cent per token once the hardware exists. For anyone doing code review, testing coding agents and keeping private data at home, that changes the game.

For the first time in this benchmark I have a tested model, on consumer hardware, that deserves to go to work every day. I've already set Flash-Next up in OpenCode pointing at the 5090. The next step is to use it for real programming, outside the sabotage yardstick, and see whether the score holds.

What doesn't work is thinking any configuration works. The Strix Halo is great for having 128 GB and mounting a big model, but its speed doesn't pay for interactivity; Ornith runs fast and reviews badly; GLM-4.7-Flash completes the protocol and detects nothing unannounced. And there's the invisible price: aggressive quantization can charge score, depending on the model and the configuration, and waiting time charges patience.

If I were building a box for a dev today, it would be a 5090 with Strata and Flash-Next, and I'd use the Strix for background tasks that accept being slow. The commercial frontier keeps winning for whoever needs the maximum. But consumer stopped being a consolation prize: there's already Tier A on the home shelf.

### The problem now is finding a 5090

In October, leakers claimed NVIDIA would stop producing the RTX 5090 and reserve the GB202 chips for its professional and datacenter lines. The card even vanished from NVIDIA's official US store. On October 16, at an event in Taipei, **Jeff Fisher**, NVIDIA's senior vice president, [denied the discontinuation](https://www.guru3d.com/story/nvidia-says-geforce-rtx-5090-production-is-continuing/) and said the company will keep shipping, but admitted production capacity is tight.

In practice:

- the suggested price is still US$ 1,999, and most listings on Newegg in the US [go above US$ 9,300, almost five times that](https://www.techspot.com/news/114254-nvidia-rtx-5090-production-but-absence-company-us.html);
- in Brazil, each unit retails for around [R$ 35 thousand](https://www.baguete.com.br/noticias/carga-milionaria-de-gpus-some-de-guarulhos);
- and two pallets of Zotac RTX 5090s, imported by the distributor Oderço and valued at about R$ 2.5 million, [disappeared at Guarulhos airport](https://www.terra.com.br/noticias/misterio-em-guarulhos-r-25-milhoes-em-placas-de-video-desaparecem,a7596d7874eddfb490f96345b4be1b09z4eix4rc.html) in São Paulo. GRU Airport reported it to the authorities, and the case is still under investigation, with no confirmed theft.

> The first local Tier A model on v4 runs precisely on the hardest card to buy right now. The home shelf already has Tier A. What's missing is getting the shelf.
