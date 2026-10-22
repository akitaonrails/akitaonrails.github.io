---
title: "LLM Benchmark v4: can my team fit in a 4x b300/h200?"
slug: "llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200"
date: '2026-10-22T11:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200
description: "After ranking the big models, the leftover question: how many developers fit on a 4x B300 or 4x H200 pod? We measured real concurrency, with a latency SLO, and the answer changes everything: DeepSeek V4.1 Flash holds 32 comfortable users on B300 and only 8 on H200. Cost per comfortable user: US$ 1.13/hour on B300 versus US$ 1.80 on H200. When your own infra closes the math against a frontier subscription, and when it's just expensive vanity."
tags:
- llm-benchmarks
- local-models
- llms
- hardware
---

In the last two articles I covered the [benchmark on a single B300](/en/2026/10/19/llm-benchmark-v4-the-top-open-source-llms-on-a-b300/) and the [big-model ranking on 4x B300](/en/2026/10/22/llm-benchmark-v4-open-source-that-only-fits-in-4x-b300/). The question that closes the trilogy is the company's: **is it worth building your own LLM infra for the dev team?**

The answer depends on two things: how many comfortable users the hardware holds, and how much that costs per person. We measured both.

## The math before the test

Recapping the numbers from the previous article: the 4x B300 pod costs **US$ 36 per hour** (US$ 864/day, almost US$ 26 thousand/month running nonstop). I started the campaign with about US$ 127 of balance, topped up US$ 2,550, and US$ 537 were left. That was **about US$ 2,140** between setup, downloads, tuning and benchmarks, not just inference.

In the middle, the balance hit zero, the pod died during an autotune, and when it was time to top up **there was no B300 available**. That's Runpod's operational risk: the price changes and the supply disappears. The alternative was a 4x H200 pod, with list price around [US$ 3.59 per GPU-hour on Community Cloud](https://www.runpod.io/pricing): US$ 14.36/hour for the four at list math, against US$ 36 for the B300s.

## B300 and H200 are not the same machine

The hardware difference changes more than the price:

| | 4x B300 | 4x H200 |
| --- | --- | --- |
| Architecture | Blackwell Ultra (`sm_103a`) | Hopper (`sm_90`) |
| VRAM | ~288 GB per GPU, ~1.1 TB total | ~141 GB per GPU, ~560 GB total |
| Native formats | FP8 and FP4/NVFP4 | FP8 (no native FP4) |
| Toolchain | CUDA 12.9+ and kernels compiled on the fly | more mature, but still with JIT patches |

The swap had an adaptation cost: the GLM's NVFP4 checkpoint that ran on B300 doesn't exist for Hopper, so its FP8 variant had to be downloaded, and even DeepSeek needed kernel tuning. The concurrency results below are with both in native FP8, which is the fair comparison possible.

## How we measured "a team fits"

The test uses `vllm bench serve` against each pod's localhost, with requests of 8,000 input tokens and 800 output (a synthetic load in the shape of a coding session), raising concurrency N step by step.

The comfort criterion is what matters: **TTFT up to 2 seconds and TPOT up to 20 ms per token** (that is, at least 50 tokens/s per stream), with **95% or more of requests** meeting both limits. It's not "the median looked good": it's almost everyone well served. A team that waits 50 seconds for the first token is not a team, it's a queue.

And the caveat: this measures comfortable code requests, not people. I don't have a measured duty-cycle multiplier for interactive agents, so I won't invent that each N becomes 2 or 3 developers.

## The numbers

| Model / hardware | Single stream | Comfortable (N) | Loose gate (median only) | Aggregate peak | Bottleneck |
| --- | ---: | ---: | ---: | ---: | --- |
| DeepSeek V4.1 Flash, 4x B300 FP8 | 177 tok/s | **32** | 48 | 2,778 tok/s | prefill (TTFT) |
| DeepSeek V4.1 Flash, 4x H200 FP8 | 137 tok/s | **8** | 16 | 2,506 tok/s | prefill (TTFT) |
| GLM 5.3 Flash, 4x H200 FP8 | 175 tok/s | **8** | 16 | 1,930 tok/s | **KV cache, 97%** |

Read carefully, because there are three stories here.

**The B300 serves four times more people in comfort.** Same model, same FP8, same TP4: 32 comfortable users against 8. The H200's aggregate is even impressive (2,506 tok/s), but that's a prefill queue: p99 TTFT reaches about 51 seconds at N=256, so the user waits a minute before seeing anything. High throughput is not interactive capacity.

**Heavy and light models tie on the H200.** The 510 GB DeepSeek and the smaller GLM sustain the same 8 comfortable users, for different reasons: DeepSeek has efficient KV via MLA and dies of compute/prefill; GLM blows the KV cache (97% usage). Choosing hardware by parameter count is looking at the wrong place: the KV architecture is what rules concurrency.

**The loose gate deceives.** If you only look at the median, you could say 48 on B300 and 16 on H200. Except the p99 tail destroys the experience of whoever is on the other side. To size a team, I use the comfortable number and that's it.

## Cost per comfortable user

Now the deciding arithmetic:

- **4x B300:** US$ 36/h ÷ 32 = **US$ 1.13 per comfortable user per hour**.
- **4x H200:** US$ 14.36/h ÷ 8 = **US$ 1.80 per comfortable user per hour**.

The B300 wins per person even with the pod costing 2.5x more. The H200 would only become cheaper per user below US$ 9/hour for the whole pod, and on the current table it costs US$ 14.36. The cut-off point isn't the machine's price, it's its capacity.

And comparing with a frontier subscription? A strong Claude/Codex plan costs about US$ 200 per month per developer. To turn streams into people I need a premise: one developer with one active request the whole workday, which is optimistic for capacity and conservative for cost. With that premise, and not counting my sysadmin hours or setup, the pod running 8 hours per workday (176 hours/month) looks like this:

| Setup | Monthly pod cost | Comfortable streams (1 per dev) | Cost per dev/month |
| --- | ---: | ---: | ---: |
| 4x B300 | US$ 6,336 | 32 | **US$ 198** |
| 4x H200 | US$ 2,527 | 8 | **US$ 316** |
| 4x B300 on 24/7 | US$ 25,920 | 32 | US$ 810 |

Around 30 continuous streams, the B300 lands practically at the strong subscription's price. Below that, the subscription is cheaper, because you pay per person, not per idle pod hour. And running 24/7 without matching load is throwing money away: the pod charges while sleeping.

## For a company, when the math closes

If you have a genuinely big team using it all day, data that can't leave the environment, and a model that delivers on the daily job (DeepSeek V4.1 Flash scored 92.5 on my vigilance benchmark, above GPT-6 Sol and Sonnet 5), your own infra starts making sense **for the first time without being vanity**. The cut-off point, on the premise of one active stream per person the whole workday, lands around 30 concurrent people, with the pod off outside working hours.

If the team is small, usage is intermittent, or the goal is just to save money: stay with the API. The same DeepSeek cost US$ 1.21 per full benchmark round in the cloud, and you don't inherit a pod to administer, nor the risk of the B300 vanishing from stock when you need it most.

What I take from this campaign: big hardware is not an answer to a small question. Before signing the pod, do the math on how many people actually run concurrently on your team, measure the latency they tolerate, and add the price of your sysadmin hour. The big open model already reached the Sonnet 5 and GPT-6 Sol band for daily code review. The infra just needs to fit the budget.
