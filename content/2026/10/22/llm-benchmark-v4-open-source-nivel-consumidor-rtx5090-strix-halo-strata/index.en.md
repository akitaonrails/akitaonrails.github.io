---
title: "LLM Benchmark v4: consumer-grade open source on RTX 5090 or Strix Halo. And Strata?"
slug: "llm-benchmark-v4-consumer-open-source-rtx5090-strix-halo-strata"
date: '2026-10-22T11:30:00-03:00'
draft: false
translationKey: llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata
description: "I went back to consumer hardware after the datacenter tests. Qwen3.8 Flash-Next scored 91.0, Tier A, on an RTX 5090 with the Strata engine, 1.5 points behind the B300 at 159 tokens per second. It's a different model from the Qwen 3.8 27B I had called slow: a MoE with 6B active per token, served with the hottest experts on the card. Strix Halo scored 80.0 with the 27B, but at 7.7 tokens per second. It's the first local model to make Tier A on the v4, and it's worth testing in day-to-day programming, if you can find a 5090: NVIDIA denies the end of production but admits tight supply."
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
| RTX 5090 | 32 GB GDDR7 | ~1.8 TB/s | Blackwell sm_120, FP8/FP4 | US$ 1,999 suggested (~5x at retail) |
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
- **Speculation only helps with high acceptance.** In a [test by Mihai Farcas](https://mihai.ltd/blog/beating-llamacpp-from-scratch-consumer-amd) on an RX 7900 XTX, llama.cpp's n-gram speculation, with no draft model, had only 5 of 64 tokens accepted, and throughput stayed flat in one run and dropped about 2% in the other. The gain shows up with a drafter made for the model, like the helper Strata uses on Flash-Next.

## What is this Strata thing

[Strata](https://github.com/Niko1221/Strata) is an open source inference engine, MIT license, built around one model: **Qwen3.8 Flash-Next**, a 125-billion-parameter MoE that normally asks for a server. It also runs smaller MoEs, like the Ornith-35B I tested here. The code is C++ and CUDA and reuses parts of llama.cpp/ggml. It has builds for NVIDIA (CUDA 12 and 13), AMD (including Strix Halo), Intel Arc and Apple Silicon, and brings up an OpenAI- and Anthropic-compatible API on localhost, which plugs straight into Claude Code, Codex CLI or OpenCode.

Careful with the name. Mihai Farcas published [another engine called Strata](https://mihai.ltd/blog/beating-llamacpp-from-scratch-consumer-amd), in Rust with HIP kernels, for small dense Qwen 3.5 models on an RX 7900 XTX. They're different projects, and the one that ran here was the first.

The problem it attacks is the big MoE on a small machine. The strategy is **expert-offload**, in layers:

- the model has 24,576 experts, 512 in each of the 48 layers, and each token uses only 10 per layer;
- the GPU holds about 4 thousand experts, the most used ones;
- the system RAM holds all of them;
- a lookup table of about 29 GB stays on the SSD, and the model reads a few rows of it per token.

On top of that, a small helper guesses the next words and the big model checks them all at once. The README promises the same answer 1.6 to 1.8 times faster. The minimum is 32 GB adding RAM and VRAM, plus about 80 GB of disk, and the IQ3_S variant I used is about 55 GB.

What made me believe in it was the result: **Qwen3.8 Flash-Next on the 5090 with Strata scored 91.0, with zero nudges and all 14 items solved**, 1.5 points behind the 92.5 the same model scored on the B300 with vLLM. The report itself calls that "within the noise". A community project, on a consumer card, sat glued to the same model served in a datacenter in NVFP4.

### And now it can see

Until yesterday, my Strata was blind: sending an image got back "this server was started without the vision encoder". I enabled vision by hand, and it was simpler than it looked.

The vision projector (the `mmproj`) I had already archived on the NAS inside the uncensored Flash-Next variant. I checked its sha256 against the archive's manifest and against the hash Strata pinned for the BF16 encoder, and copied it into the models directory. The configuration gained the `--vision` flag and a `vision` section pointing to the `strata-vision` component and the mmproj, with a backup beside it.

The verification was end-to-end: the encoder loads in half a second, warms up 1,024 image tokens in under two seconds, and answered "Red" to a red test square. And the detail that matters most to me: with the encoder resident, 3.65 GB of VRAM remained free, so the desktop's 4 GB reserve still holds. The only gotcha: lazy loading doesn't coexist with the vision section in this configuration, so it stays off here.

## Careful: Strata eats the whole GPU, and the desktop dies

There's a cost that doesn't show up in benchmarks: running Strata on the same GPU that draws your desktop. It was designed to fill the card, and it does.

In my case, the engine allocated 32,085 of the 32,607 MiB on the 5090, 98.4% of the VRAM. Hyprland was left with about 500 MiB, desktop allocations failed, and even the terminal stopped responding. Only a hard reset solved it.

It was two failures in sequence. The reserve I had configured was 2,560 MiB, but the proxy fired only once, swallowed the exception and never tried again. The engine's `/v1/vram` endpoint wasn't up at that moment, so the reserve was never applied. And 2,560 MiB was already too little for Hyprland, browser and terminal together.

The fix, validated under load:

- **4,096 MiB** (4 GiB) reserve, with retry for up to a few minutes, engine-response verification and a confirmation log. No fire-and-forget.
- Re-assertion of the reserve every 30 seconds while the engine is loaded, to close any rebalancing drift.
- In the first load test, with the GPU at 99%, **3,629 to 3,888 MiB stayed free during the whole generation**. In the following test, one long generation and three other concurrent requests finished successfully; the smallest slack observed was 3,949 MiB. The desktop stayed alive.

The price shows up in throughput. The expert cache dropped from about 11,700 slots to 9,700, so more experts travel over PCIe. In the initial measurement, it went from ~200 to ~150 tokens per second. I happily pay that: a desktop that doesn't freeze is worth more than those 25% of speed in that test.

There's a structural alternative: this machine has an integrated Radeon 610M, and Hyprland can be moved to it. The 5090 would be dedicated to inference.

The cost is that the 610M is weak for gaming and NVIDIA multi-GPU on Wayland has its quirks. I preferred the elastic reserve, because the model also unloads when idle.

The general lesson: **never let an inference engine take 100% of a GPU that also draws your screen.** In this configuration I don't have a rigid driver-level VRAM reservation for display clients. I had to solve it on the engine side: reserve a few GB, re-assert after every cold start, and measure again with the desktop open.

### The same 32 GB also limit the session

The 5090's math is tight on all sides. The same 32 GB have to accommodate the model's dense weights and fixed buffers, the hot-expert cache, the resident part of the KV cache and also the 4 GiB reserve for Hyprland, browser and terminal. What's left for one thing comes out of another.

KV cache is the conversation's memory. Every token of the prompt, of the previous answers and of the files read creates state that the model needs to consult in the next tokens. In my Strata it's in `int8`, with 32K cells per layer resident on the GPU.

The rest can be streamed from RAM, which is why raising the window from 128K to 256K didn't increase VRAM or drop speed in my synthetic test. That streaming avoids the immediate blow-up, but it still uses memory and doesn't turn a 5090 into a limit-free server.

The ceiling configured here is **262,144 tokens, or 256K**. Several commercial models I tested, including the newest Claudes, already work in the 1-million-token class. Almost four times the window changes how you work: in Claude Code you can accumulate much more history before compaction; in the local Qwen I have to treat context as a budget from the first prompt.

The conversation that shows up in the terminal is only part of the context. Depending on the harness, the system prompt, `AGENTS.md` and `CLAUDE.md`, skill catalogs and loaded content, tool descriptions and schemas, MCP servers, plugin instructions, command outputs, files and the space reserved for the answer also go in. A well-implemented skill loads its full text only when called, but its catalog can still enter the prompt. A plugin that registers twenty tools also sends twenty schemas before you ask for anything.

That's why the benchmark didn't use my normal OpenCode. The runner [generates an isolated configuration](https://github.com/akitaonrails/llm-coding-benchmark#local-opencode-benchmark-config), without the global plugins and MCPs, with only the providers and agents needed for the test. It also pins the real 262,144-token limit instead of pretending the model accepts the context advertised by another backend.

To use this Qwen day to day, I'd do the same cleanup:

- start with the leanest possible harness and activate plugins or MCPs when the project really needs them;
- keep heavy skills on demand, without dumping whole manuals at the start of the session;
- compact or open a new session before touching the ceiling, recording important decisions in project files;
- reserve space for the model's output. A window stuffed with input is useless if there's no token left for it to think, call tools and answer.

> With 256K, context is a hardware resource. Installing too many integrations and loading everything into every session consumes window and memory before the work starts.

## Wasn't Qwen 3.8 too slow?

It was, and I wrote that. In the [v4 ranking](/en/2026/09/15/new-llm-benchmark-v4-retesting-39-llms-part-2/), the local Qwen 3.8 27B took almost 12 hours to close the seven sprints. In the [B300 article](/en/2026/10/19/llm-benchmark-v4-the-top-open-source-llms-on-a-b300/) I summarized: scored 80, took 706 minutes, "so don't even try".

Except that's another Qwen 3.8. The family has both, and they behave in opposite ways at home:

| | Qwen 3.8 27B | Qwen3.8 Flash-Next |
| --- | --- | --- |
| Architecture | dense, 27B | MoE, 125B total, 6B active per token |
| Where v4 finished | Strix Halo, Q8_0 | RTX 5090, IQ3_S, Strata |
| Speed | 7.7 tok/s | **159.2 tok/s** |
| v4 score | 80.0 (B) | **91.0 (A)** |

### Why the bigger one runs faster

In token generation, a local machine is memory-bandwidth-bound: each token needs to read all the active weights. The dense 27B reads its 27 billion every token, about 29 GB in Q8. The Strix moves about 256 GB/s, so the ceiling sits near 9 tokens per second, and I measured 7.7.

On the 5090 the same 27B would be fast, but in Q8 it doesn't fit in the 32 GB along with the context that seven sprints accumulate. In Q5_K_M it fit, but got stuck in a reasoning loop on sprint 3. It finished on the Strix, in Q8_0 with reasoning off (`--reasoning off`), which is what unlocked the loop.

Flash-Next has almost five times more parameters in total, but only about 6 billion work per token. In 3 bits, that's around a tenth of what the 27B in Q8 needs to read. The hot experts stay on the 5090's GDDR7, with seven times the Strix's bandwidth, and the speculation helper gets tokens ahead. Result: about 20 times the 27B's speed on the Strix, with a higher score.

> The turnaround came from the model and engine swap: a MoE with few active parameters, served by an expert-offload engine made to measure for it. No configuration flag would pull this out of the dense 27B on the Strix.

### The tuning still charges

The price of running at home changes from model to model. Flash-Next in 3 bits lost only 1.5 points against the B300's NVFP4 version. Ornith-35B, on the same engine and the same card, lost 16.5 against its BF16 version on the B300. Measure your model before trusting it.

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

For the first time in this benchmark I have a tested model, on consumer hardware, that deserves to go into everyday work. I've already configured Flash-Next in OpenCode pointing at the 5090. The next step is using it in real programming, outside the sabotage yardstick, and seeing whether the score holds.

What doesn't work is thinking any configuration works. The Strix Halo is great for having 128 GB and mounting a big model, but its speed doesn't pay for interactivity; Ornith runs fast and reviews badly; GLM-4.7-Flash completes the protocol and detects nothing unannounced. And there's the invisible price: aggressive quantization can charge score, depending on the model and the configuration, and waiting time charges patience.

If I were building a box for a dev today, it would be a 5090 with Strata and Flash-Next, and I'd use the Strix for background tasks that accept being slow. The commercial frontier keeps winning for whoever needs the maximum. But consumer stopped being a consolation prize: there's already Tier A on the home shelf.

### The problem now is finding a 5090

In October, leakers claimed NVIDIA would stop producing the RTX 5090 and reserve the GB202 chips for the professional and datacenter lines. The card even disappeared from NVIDIA's official US store. On October 16, at an event in Taipei, **Jeff Fisher**, NVIDIA's senior vice president, [denied the discontinuation](https://www.guru3d.com/story/nvidia-says-geforce-rtx-5090-production-is-continuing/) and said the company will keep delivering, but admitted production capacity is tight.

In practice:

- the suggested price is still US$ 1,999, and most listings on American Newegg [go past US$ 9,300, almost five times that](https://www.techspot.com/news/114254-nvidia-rtx-5090-production-but-absence-company-us.html);
- in Brazil, each unit goes for around [R$ 35 thousand at retail](https://www.baguete.com.br/noticias/carga-milionaria-de-gpus-some-de-guarulhos);
- and two pallets of Zotac RTX 5090s, imported by the Oderço distributor and valued at about R$ 2.5 million, [disappeared at Guarulhos airport](https://www.terra.com.br/noticias/misterio-em-guarulhos-r-25-milhoes-em-placas-de-video-desaparecem,a7596d7874eddfb490f96345b4be1b09z4eix4rc.html). GRU Airport notified the authorities, and the case remains under investigation, with no theft confirmation.

> The v4's first local Tier A model runs precisely on the hardest card to buy right now. The home shelf already has Tier A. Getting the shelf is what's missing.
