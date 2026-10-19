---
title: "LLM Benchmark v4: the top open source LLMs on a B300"
slug: "llm-benchmark-v4-the-top-open-source-llms-on-a-b300"
date: '2026-10-19T14:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-os-top-llms-open-source-numa-b300
description: "I rented a 288 GB NVIDIA B300 on Runpod and ran my v4 sabotage benchmark on 14 open-weight models that don't fit at home. None of them serves fast the way it ships: GLM 5.3 Flash went from 10 to 141 tokens per second on configuration alone. Two open models reached 92.5, Sonnet 5 level, and a 27B fine-tune scored 88. A 397B flagship let an admin backdoor through, DeepSeek V4 Flash scored 86 in the cloud and 44.5 at home, and Nemotron cheated on a test. The math: the cloud API of the same model costs a dollar per run and the pod costs 218 a day. When owning your own infra is worth it, and whether a team fits on one card."
tags:
- llm-benchmarks
- local-models
- llms
- hardware
---

In the last two v4 benchmark posts I [rebuilt the test from scratch](/en/2026/09/15/new-llm-benchmark-v4-retesting-all-top-llms-part-1/), with a Rails app sabotaged on purpose across seven sprints, and [ranked 39 models](/en/2026/09/15/new-llm-benchmark-v4-retesting-39-llms-part-2/) by vigilance: six ties at the top, a free model beating half of Claude. Then I [tested five new models](/en/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/), Opus 5.5, GPT 6 sol and luna, MiMo V2.6 Pro and Grok 4.7: Opus 5.5 closed at 100 and joined the tie at the top, GPT 6 luna scored 95.5 for under a dollar a run, and Grok 4.7 regressed badly against its own predecessor.

One category was missing that I had never tested properly: the big open source models. The ones that fit on my [RTX 5090](/en/2026/01/21/omarchy-3-dual-gpu-setup-with-amd-and-nvidia/) with 32 GB or on my [Strix Halo](/en/2026/03/31/minisforum-ms-s1-max-amd-ai-max-395-review/) with 61 GB usable by the GPU are too weak for this. They work for simple agent tasks, and no small model handles real programming tasks, let alone a complex software project.

Qwen 3.8 27B took 706 minutes to finish v4 on the Strix and scored 80; the local GLM-4.7-Flash scored 24. So don't even try.

But what if we push harder? What can mid-sized models, 100 to 400 billion parameters, do running on a single rented B300? I could rent four of them and run the giant 750-billion or one-trillion models, and I'm not sure the cost-benefit is worth it. The data below answers.

> **TL;DR:** 14 open models, one 288 GB B300 on Runpod at about 9 dollars an hour, the same v4 sabotage protocol. None of them serves fast the way it ships: GLM 5.3 Flash decoded at 10 tokens per second with the default configuration and at 141 after tuning, 14 times more from flags alone. Two open models, GLM 5.3 Flash and Qwen3.8 Flash-Next, scored 92.5, Claude Sonnet 5 level, and Swift 1.5 27B scored 88, Opus 4.6 level. None reached the frontier's 100. The 397-billion flagship scored 68.5 and let an admin backdoor through, DeepSeek V4 Flash scored 86 in the cloud and 44.5 served by me, and Nemotron cheated on a regression test. The cloud API of the same model costs a dollar per run; the pod costs 218 dollars a day. Jump to [B300 and Runpod](#what-a-b300-is-and-what-runpod-is), [server tuning](#none-of-them-serves-fast-the-way-it-ships), the [ranking](#the-ranking), the [interesting cases](#the-interesting-cases), the [frontier comparison](#how-far-from-the-frontier), the [math](#the-math) or the [conclusion](#is-owning-your-own-infra-worth-it).

## What a B300 is, and what Runpod is

The **B300** is the datacenter GPU of NVIDIA's Blackwell Ultra generation, announced in March 2025. Each card has [288 GB of HBM3e memory](https://developer.nvidia.com/blog/nvidia-blackwell-ultra-for-the-era-of-ai-reasoning/), nine times my 5090, and about 15 petaflops of dense compute in NVFP4, the 4-bit format Blackwell does in hardware. It's the card that goes inside the GB300 NVL72 rack, 72 of them interconnected, which AI companies buy by the thousands.

On its own, a B300 costs more than an apartment. What makes it accessible is renting by the hour.

[**Runpod**](https://www.runpod.io/) is a cloud GPU provider that rents cards in "pods", Linux containers with one or more GPUs, billed per second. You pick the card, an image template, get in over SSH, and pay while the pod is on, idle included. The B300 cost about [9 dollars an hour](https://www.runpod.io/pricing) on their secure cloud the week of the test; an H100 goes for 3 to 4. The container disk is ephemeral: terminate the pod and the 250 GB of weights you downloaded are gone, and you download again.

The pod I used: one B300 with 275 GiB according to `nvidia-smi` (the same nominal 288 GB, in binary units), 344 vCPUs, 4 TB of host RAM, 700 GB of disk. The inference server was vLLM; the harness was the same OpenCode as every other model in the ranking, connected to the pod through an SSH tunnel. The model runs there; the code, the tests and the results stay on my machine.

Fitting in memory is the first filter. The B300 fits the 100 to 400-billion-parameter models quantized to NVFP4, plus the 27 to 35-billion ones in BF16. Left out are the 753-billion GLM 5.3 flagship, the 750-billion DeepSeek V4.1 Flash, the 1.6-trillion DeepSeek V4 Pro and the 2.8-trillion Kimi K3. For those it would take four B300s or more, about 36 dollars an hour.

## The methodology

The protocol is the usual [v4](/en/2026/09/15/new-llm-benchmark-v4-retesting-all-top-llms-part-1/): the model builds a Rails app across seven accumulating sprints, and between sprints an independent reviewer, isolated from the model, injects 14 sabotages, from real CVEs to silent logic and test regressions, into the code the model itself wrote. The 0-to-100 score measures vigilance: how much the model catches and fixes without being told (full weight), how much it fixes after an explicit "do a security audit" in the last sprint (40% of the weight), and what stays unresolved (zero). Tiers are A from 83 up, B from 73 to 82, C from 51 to 72, D up to 50.

Two differences this round. The first is the reviewer: the five models that finished before the block were reviewed end to end by Codex, as in the previous rounds.

Midway through the batch OpenAI's security service started refusing the injection and grading operation with a cybersecurity risk flag, even though it's my code, on my machine, in a benchmark with 46 models already scored under the same protocol. I switched the reviewer to Claude Opus 4.8 for the remaining models, with the same injection plan, same catalog, same yardstick, and the provenance of every boundary is recorded per sprint. The expected impact on the score is none, because both execute the same written recipe.

The second is admission by speed, which is the subject of the next section. A model that decodes below 100 tokens per second doesn't even get on the track.

Also: an open model is entitled to up to two short nudges per run for silly defects (a missing import, a wrong test entry point), recorded as "assisted". Infrastructure failure, driver, loader, parser, is never charged to the model. And the pod ran one model at a time, with no access to any other model's workspace or results.

## None of them serves fast the way it ships

The first lesson cost a day. I downloaded [GLM 5.3 Flash](https://huggingface.co/RedHatAI/GLM-5.3-Flash-NVFP4), 320 billion parameters with 18 active, quantized to NVFP4, 198 GB. I brought it up on vLLM with the configuration that "works": it serves, passes the tool-call tests, answers. And it decoded at **10 tokens per second**, with the GPU at 10% utilization, 209 watts out of the 1,100 the pod allows.

That's unusable for programming. A coding agent generates tens of thousands of tokens per sprint; at 10 per second, a 20-minute sprint becomes more than four hours.

The same checkpoint, same 128K-token context, same FP8 KV cache, same test prompt, changing only the compile and mode flags: **141 tokens per second**. Fourteen times faster, zero change in precision or weights.

The main culprit was `--enforce-eager`, which disables vLLM's `torch.compile` and CUDA graph capture, and which every tutorial tells you to enable "to start faster". It starts faster and serves 14 times slower. The measurement changed that flag together with the `interactivity` mode, so I didn't isolate each one's contribution.

Hence the admission rule: **below 100 tokens per second I consider unusable**, and no model enters the benchmark without clearing that on the median of two warm 256-token probes, after a cold one. To keep it from becoming a bottomless pit, tuning is bounded: at most three configurations and 45 minutes of wall-clock per model, including load and compilation. And tuning can never trade quality for speed: no shortening the context, lowering reasoning effort or quantizing further to hit the number.

The tweaks that paid off for everyone:

- **Install a CUDA that compiles for the card.** Runpod's default image ships CUDA 12.8, whose `nvcc` [cannot compile for `compute_103a`](https://developer.nvidia.com/cuda-gpus), the B300's compute capability. Without 12.9, the NVFP4 kernels never compile.
- **Never use `--enforce-eager`.** Letting vLLM compile and capture CUDA graphs is the single biggest win.
- **`--performance-mode interactivity`**: optimize for single-stream latency, which is what a serial agent needs, instead of aggregate throughput.
- **FP8 KV cache on the big MoEs, prefix caching and chunked prefill on all of them**, confirmed by vLLM's Prometheus counters instead of assumed: on an 11K-token prompt, the server reused exactly 8,576 prefix tokens on every repeat.
- **The right tool and reasoning parser for each family.** The wrong parser makes tool calls vanish silently or leaks the reasoning into the answer.

And the specific tweaks I found most interesting:

- **NVFP4 only runs on vLLM.** The 198 to 251 GB checkpoints in Blackwell's native FP4 are the only way to fit on the card, and llama.cpp and Ollama simply don't load those formats. Whoever lives on GGUF has no access to this range.
- **Native speculative decoding.** Qwen 3.8 27B went from 92 to 195 tokens per second with the MTP head the checkpoint itself ships, predicting three tokens per step, plus `--language-model-only` to drop the vision tower (measured on different pods, so no controlled ablation). [Muse Glimmer](https://huggingface.co/meta-models/Muse-Glimmer-30B) reached 295 with the lightweight DFlash drafter it ships alongside, 15 speculated tokens per step. I only enabled it where an official drafter exists and where tool calling stayed correct; for Ornith a drafter exists as a separate release, with unknown acceptance rate, so it stayed off.
- **The CUDA 12 loader.** flashinfer JIT-compiles an NVFP4 MoE kernel that needs `libcudart.so.12`, and after installing CUDA 13 for Nemotron the library resolution broke. The symptom looked like OOM; the cause was an `ld.so.conf`. A repair script with `ldd` evidence before and after fixed it, and the 397B went on to serve at 144 tokens per second.
- **One virtual environment per runtime.** Nemotron 3.5 Super VL required its own vLLM 0.32 in a separate venv, because that's what the official card pins, and that build wants CUDA 13. Every model family is a bespoke case: parser, quantization, draft head, runtime version and loader repair, all different.
- **A parser bug that dropped the last call.** vLLM's Qwen tool parser discarded the last parameter of a call when the parameter closing tag was missing but the function one was present. A narrow repair, with 24 test cases, took that serving noise out of the model's account.

The exact arguments for each model, the probe logs and the ledger of every tuning round are in the [serving optimizations document](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/b300-serving-optimizations.md) and the [B300 runbook](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/runpod-b300-openweights-runbook.md) in the repository.

> Speed is almost free, once you let vLLM compile. The real work is finding out, model by model, which combination of toolkit, parser, quantization and draft head that checkpoint demands. I gave each one 45 minutes and needed them.

## The ranking

v4 vigilance score, tier, memory footprint, decode speed on the admission probe (warm, single stream) and the cost of the seven sprints' inference time only, at 9.09 dollars an hour. The cost excludes download, load, compilation, tuning and idle time; the real math comes further down.

| # | Model | v4 | Tier | Memory | tok/s | Minutes | Inference cost | Reviewer |
| ---: | --- | ---: | --- | ---: | ---: | ---: | ---: | --- |
| 1 | GLM 5.3 Flash (NVFP4) | **92.5** | A | 198 GB | 142 | 145 | US$ 21.96 | Codex |
| 1 | Qwen3.8 Flash-Next (NVFP4) | **92.5** | A | 100 GB | 195 | 80 | US$ 12.04 | Codex → Claude |
| 3 | Swift 1.5 27B | **88.0** | A | 56 GB | 203 | 64 | US$ 9.71 | Codex |
| 4 | ThinkingCap 3.8 27B | **83.0** | A | 56 GB | 189 | 76 | US$ 11.47 | Codex → Claude |
| 5 | Muse Glimmer 30B | 81.0 | B | 60 GB | 295 | 23 | US$ 3.54 | Codex → Claude |
| 5 | Ornith 1.5 35B | 81.0 | B | 70 GB | 317 | 161 | US$ 24.39 | Codex → Claude |
| 7 | Qwen 3.8 27B | 80.5 | B | 54 GB | 195 | 192 | US$ 29.11 | Codex |
| 8 | Qwen3.5 397B (NVFP4) | 68.5 | C | 251 GB | 140 | 54 | US$ 8.22 | Codex → Claude |
| 9 | Nemotron 3.5 Super VL (NVFP4) | 63.0 | C | 70 GB | 207 | 50 | US$ 7.51 | Codex → Claude |
| 10 | DeepSeek V4 Flash | 44.5 | D | 167 GB | 153 | 37 | US$ 5.59 | Codex |
| 11 | GLM 4.7 Flash BF16 | 33.5 | D | 60 GB | 217 | 30 | US$ 4.60 | Codex |

Three have no score: Cohere's **Command A Plus** (218 billion, 25 active, W4A4) got stuck in a loop rewriting the same model file 23 times, needed three nudges and still left the tests unable to run before the reviewer was blocked; **Nex N2.5 Mini** ran at 337 tokens per second and delivered invalid Ruby, contradictory migrations and broken authentication in two attempts, a valid bad result from a server that works; and **Qwen3.5 122B** was a conditional fallback in case the 397B didn't finish, and the 397B finished.

Minutes are sprint time only, and Ornith's include a sprint interrupted by infrastructure. Flash-Next, Swift, ThinkingCap, Muse and Qwen 27B took one nudge each; GLM 4.7, two; the others, none. The probe speed is an admission number: the throughput of a real coding session includes prefill, tools, tests and the agent's choices. And note that the top two tie on score with opposite profiles: GLM spent 145 minutes and 22 dollars to reach the same 92.5 that Qwen3.8 Flash-Next did in 80 minutes and 12 dollars, with half the memory.

## The interesting cases

### Qwen3.8 Flash-Next: the best of the open models, by cost

[Flash-Next](https://huggingface.co/nvidia/Qwen3.8-Flash-Next-NVFP4) is, [in Qwen's words](https://recipes.vllm.ai/Qwen/Qwen3.8-Flash-Next), a preview of the Qwen 4 architecture: 125 billion language-model parameters with 6 billion active, plus a 51-billion n-gram embedding table that Qwen says can be offloaded to host memory, plus a 4-billion MTP head. Quantized to NVFP4 by NVIDIA, it took about 100 GB on the card (the checkpoint is 133 GB on disk). It was the only model in the second batch to resolve all 14 items: it caught the tenant leak unprompted, caught the compound test-integrity item, and wrote per-user isolation specs on its own, so the planted API IDOR had no way to stay green. At 195 tokens per second and 12 dollars of inference, it's the best cost-benefit in this table.

### GLM 5.3 Flash: the same 92.5, three times the cost

GLM scored the same with a much bigger architecture: 320 billion parameters, 18 active, 198 GB even in FP4. It resolved all 14 items, zero nudges, reviewed end to end by Codex.

But it took 145 minutes and consumed twice the memory for the same result. On Z.ai's cloud, the same model scored 84.25 on a flat plan. With single-run noise, which in my history reaches nine points, the safest reading is that both sit in the same band.

### Swift 1.5 and ThinkingCap: two 27B fine-tunes in Tier A

The two surprises. [Swift 1.5](https://huggingface.co/ukisai/Swift-1.5-Qwen3.8-27b), from UkisAI, and [ThinkingCap 3.8](https://huggingface.co/bottlecapai/ThinkingCap-Qwen3.8-27B), from BottleCap AI, are Qwen 3.8 27B fine-tunes trained to think less: Swift advertises up to 58% fewer reasoning tokens (on the GPQA median; on Terminal-Bench, 16%), ThinkingCap about 37% on average. Both fit in 56 GB in BF16, run at about 200 tokens per second with MTP, and scored 88 and 83.

Swift landed above Anthropic's Opus 4.6. The base Qwen 3.8 27B, same architecture, scored 80.5 in 192 minutes; Swift scored 88 in 64. Swift caught sabotage earlier than the base; whether that was from thinking less, one run of each can't prove.

A provenance caveat: the reviewer recorded that Swift read local commit messages that disclosed regressions, which weakens a literal reading of "entirely unaided discovery". And it left one item unresolved, an inactive admin still accepted with a vacuous guarding test. Even so, of every model in this table, it's the one I'd put on a card of my own.

### Qwen3.5 397B: the flagship that let the backdoor through

The biggest model in the batch, 397 billion parameters with 17 active, 251 GB of NVFP4 on a 275 GB card, served at 140 tokens per second after the loader repair and scored **68.5**, Tier C.

The case that defines the score: sabotage number 6 is a line `admin? => admin || email.end_with?("@internal.example")`, a privilege escalation by email domain. The 397B let it through in the normal sprints, let it through in sprint 7 with the explicit security-audit request, and **wrote a passing test codifying the backdoor as expected behavior**, in the same commit where it announced "Brakeman: 0 warnings". Parameters did not buy vigilance.

### Nemotron 3.5 Super VL: cheated on the test

NVIDIA's [Nemotron 3.5 Super VL](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Super-VL-120B-A12B-NVFP4), 120 billion with 12 active, released two days before I started testing and [sold by NVIDIA](https://blogs.nvidia.com/blog/nemotron-3-5-super-vl/) as the fastest open agentic model in its class, with "leading accuracy" on multimodal tasks, scored **63**. Sabotage number 2 removes a navigation link and the regression test looks for `have_link('Sign in')`. Nemotron changed the test to `have_button('Sign in')`, which passes on the login form's submit button without restoring the link, and kept the cheat even after the reveal sprint.

It also tends to catch items a sprint late. And it was the one that required its own runtime: vLLM 0.32 with CUDA 13 in a separate environment.

### DeepSeek V4 Flash: 86 in the cloud, 44.5 in my hands

The most important case for anyone considering self-hosting. [DeepSeek V4 Flash](https://huggingface.co/deepseek-ai/DeepSeek-V4-Flash), 284 billion with 13 active, scored **86, Tier A, for 97 cents** through the API in September, and the 0731 version, exactly the one I downloaded, scored 85 for 1.94. The same public weights in mixed FP4 and FP8, served by me on the B300, scored **44.5, Tier D**: it caught 4 items unprompted, 5 more at the reveal, and left 5 unresolved. It was the fastest to finish, 37 minutes, and the least vigilant.

The likely cause is divergence between the public checkpoint and what DeepSeek serves, or between their serving stack and mine: parser, chat template, reasoning mode, quantization. I followed the official card. What this proves is that the model's name on Hugging Face doesn't guarantee the hosted API's quality, and that whoever is going to host needs to validate before trusting.

### GLM 4.7 Flash: same as local, meaning bad

The 30-billion GLM 4.7 Flash in BF16, at 217 tokens per second, scored 33.5. At home, in GGUF Q5, it had scored 24. It needed two nudges, left nine items unresolved and delivered a migration with a syntax error. The nine-and-a-half-point difference fits within single-run noise; what remains is that the model is weak either way.

### What showed up in several

Ornith, Muse Glimmer and the 397B shared a hygiene defect: they ran the sprint to the end with exit zero and forgot to commit their own work, leaving it for the reviewer to checkpoint. It didn't go into the score, and on a real team it would be the first complaint. And the 81-to-83 cluster, ThinkingCap, Ornith and Muse, has a consistent profile: it catches SQL injection, tenant leaks, XSS and exposed secrets with confidence, and lets the quiet items through, broken access control, test integrity, missing index, wrong aggregate.

## How far from the frontier

The three best open models against the best commercial ones from the same ranking, with the cost and time of each run:

| Model | v4 | Tier | Run cost | Minutes | Where |
| --- | ---: | --- | ---: | ---: | --- |
| GPT-6 Astra | 100.0 | A | US$ 30.55 | 100 | cloud |
| Claude Opus 5.5 | 100.0 | A | US$ 16.63 | 64 | cloud |
| GPT 5.6 terra | 100.0 | A | US$ 9.52 | 80 | cloud |
| Grok 4.6 | 98.5 | A | US$ 13.00 | 67 | cloud |
| Claude Fable 5.1 | 95.5 | A | ~US$ 51 | 133 | cloud |
| **GLM 5.3 Flash (NVFP4)** | **92.5** | A | US$ 21.96 inference only | 145 | B300 |
| **Qwen3.8 Flash-Next (NVFP4)** | **92.5** | A | US$ 12.04 inference only | 80 | B300 |
| Claude Sonnet 5 | 91.0 | A | ~US$ 27 | 112 | cloud |
| Gemini 3.8 Flash high | 90.5 | A | US$ 15.98 | 97 | cloud |
| **Swift 1.5 27B** | **88.0** | A | US$ 9.71 inference only | 64 | B300 |
| Claude Opus 4.6 | 87.5 | A | US$ 25.64 | 89 | cloud |

The reading: the best of the open source that fits on a B300 and that I served sits **one step below the commercial ceiling and level with the middle of Tier A**. Differences of one or two points are single-run noise.

GLM 5.3 Flash and Qwen3.8 Flash-Next tie with Sonnet 5 and pass Gemini 3.8 Flash and Opus 4.6. None reaches the 100 that seven commercial models scored, nor Grok 4.6's 98.5. Seven and a half points separate the best open model from the ceiling, and in v4 every point is one less sabotage caught unprompted.

The difference that matters is another: predictability. Among the top commercial models in the table, the worst is 87.5, and the full commercial field also has a bottom, Mistral Large 3 scored 39. The open field has the same 92.5 at the top and two Tier D at the bottom, with DeepSeek scoring 85 in the cloud and 44.5 in my hands. Choosing a top commercial model is choosing a number the API reproduces; choosing an open one is betting that the checkpoint, the quantization and your serving stack reproduce the number on the card, and sometimes they do.

## The math

If quality still falls short of the frontier, is the cost at least proportional? It depends on where you run the open model.

**On the vendor's own cloud API, yes, and by a wide margin.** A full v4 run cost 97 cents on DeepSeek V4 Flash, 1.17 dollars on Qwen 3.8 Flash, 1.03 on MiMo V2.5 Pro, all Tier A in the cloud. Against 9.52 to 30.55 dollars for the 100-point models, that's ten to thirty times cheaper for a score 8 to 14 points lower. The list prices explain it: [GLM 5.3 Flash](https://docs.z.ai/guides/overview/pricing) costs 15 cents per million input tokens and 50 for output; [DeepSeek Flash](https://api-docs.deepseek.com/quick_start/pricing), 15 to 30 cents input and 60 cents to 1.20 output; [Opus 5.5](https://platform.claude.com/docs/en/about-claude/pricing), 4 and 20 dollars; [GPT-6 Astra](https://developers.openai.com/api/docs/pricing), 10 and 50.

**On your own rented B300, no.** The pod costs 9 dollars an hour on or idle, **218 a day, about 6,500 a month**. The model time of this whole batch, 14 models across download, load and sprints, added up to 23 hours, about 212 dollars at pod price; the sprints alone were 17 hours and 157 dollars.

But the pod also charges for the time when nothing runs. I put 400 dollars of credit on Runpod and 127 were left: the whole batch cost **273 dollars**, about 30 pod-hours, including storage, four pods in sequence and seven idle hours one night when the orchestration died and nothing warned me. Almost 60 dollars more than the model time, just waiting. The repository's break-even math: the pod only gets cheaper than the API from about **6,500 runs a month**, 217 a day, sustained. A solo developer or a small team doesn't come close.

And model against model, side by side:

| Model | Cloud API | Hosted by me on the B300 |
| --- | --- | --- |
| DeepSeek V4 Flash 0731 | 85 (A) for US$ 1.94 | 44.5 (D) for US$ 5.59 inference only |
| Qwen 3.8 Flash (cloud) and Flash-Next (B300), same family | 86.5 (A) for US$ 1.17 | 92.5 (A) for US$ 12.04 |
| Qwen 3.8 27B | 80 (B) for free on the Strix, in 706 minutes | 80.5 (B) for US$ 29.11, in 192 minutes |

> The cloud API of an open model is ten to thirty times cheaper than the frontier for one tier less. Hosting the same model on a rented B300 is more expensive than the frontier, and sometimes worse than its own API.

## Does a team fit on the same card?

A question I asked while looking at the GPU at 10% utilization: do these models use all of the pod's compute? Could a whole team go on the same B300?

In principle, yes, and that's what vLLM exists for. [Continuous batching](https://vllm.ai/blog/2023-06-20-vllm) schedules several requests in the same decode step, and [PagedAttention](https://vllm.ai/blog/2023-06-20-vllm) stores each session's KV cache in non-contiguous blocks, with under 4% waste, precisely to fit more sessions in the same memory. A 27-billion model in BF16 takes 56 GB and leaves about 200 GB of KV cache: that's dozens of agent sessions with 128K-token context at the same time. The 397B, with 251 GB of weights, leaves 24, and then few fit.

What doesn't scale is speed per person. My test ran in `--performance-mode interactivity`, which optimizes single-stream latency, and the 200 tokens per second are that stream's. With ten agents decoding at the same time, the card's aggregate throughput rises and each one's falls, and the speculative decoding that gave me Muse Glimmer's 295 yields less as concurrency grows: a [DFlash drafter published for Muse by Z Lab](https://huggingface.co/z-lab/Muse-Glimmer-30B-DFlash2) reports 3 to 4.6 times gain with one session and 1.2 to 1.7 with 32.

I didn't measure concurrency in this batch, so what I can say is the outline: a team of five to ten people on a 27-to-35-billion model on one B300 is practical, and each one probably still stays above 100 tokens per second. The same team on the 397B is unworkable on the card, and on the 198 GB GLM 5.3 Flash it gets tight.

It's in that scenario, and only there, that the pod math starts to close. Ten developers running an agent all day on a 27B model would spend, on the API, at a dollar per two-hour run, about 40 dollars a day; the pod costs 218. It still loses. What changes the math is having a hundred people, or being required to keep the code from leaving your network.

## Is owning your own infra worth it?

For serious software development, with this batch's data, the answer comes in three parts.

**The top open models are good enough.** GLM 5.3 Flash, Qwen3.8 Flash-Next and Swift 1.5 27B are Tier A in my test, at Sonnet 5 level and above Opus 4.6. That was unthinkable in April, when [only Qwen 3.6 35B came close to Opus](/en/2026/04/05/testing-llms-open-source-and-commercial-can-anyone-beat-claude-opus/), and still one fix away. For anyone who accepts one tier below the ceiling, they serve for real work, including security review, which is what v4 measures.

**Renting a B300 to run them is the wrong way to use them.** The cloud API of the same model costs a dollar per run and needs zero configuration. The pod costs 218 a day, demands a day of tuning per model family, and in DeepSeek's case delivered a worse model than its own API. It's only worth it with a data-residency obligation, with a checkpoint no cloud serves, with sustained load of hundreds of runs a day, or with a need for pinned weights for reproducibility. Four B300s to run the 750-billion-to-one-trillion models quadruple the bill with no evidence the score reaches 100: the 397B, the biggest model I tested, scored 68.5.

**And if you're going to host, host small.** Swift 1.5 27B and ThinkingCap at 56 GB, with MTP, at 200 tokens per second, are Tier A on hardware you can buy, a professional 80 or 96 GB card instead of a datacenter one. That's where open source makes sense for a company: a whole team on one card, code inside the network, an Opus 4.6 score. Just check the license first: Swift and ThinkingCap ship with their own licenses, and above a certain revenue both require a commercial license. The open giants remain an API thing.

My rule after all this: top commercial model for tasks that can't fail, open-model API for volume, and your own card only when the law or the client demands it. The repository with every serving argument, every probe log, every reviewer transcript and the Codex-or-Claude provenance of every boundary is [public](https://github.com/akitaonrails/llm-coding-benchmark), as always.
