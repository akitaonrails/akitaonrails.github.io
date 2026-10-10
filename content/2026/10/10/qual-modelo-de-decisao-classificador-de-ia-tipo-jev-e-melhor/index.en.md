---
title: "Which Jev-like AI Decision/Classifier Model Is Best?"
slug: "which-jev-like-ai-decision-classifier-model-is-best"
date: '2026-10-10T12:00:00-03:00'
draft: false
translationKey: qual-modelo-de-decisao-classificador-de-ia-tipo-jev-e-melhor
description: "I ran my own decision-model benchmark: Jev and Clef in the cloud, plus twelve open configurations (Clef-flash, Kev, Jebadiah, Mapika, Eikos, Laya, GLiNER, Simple-Jev) on my Strix Halo, across more than 15 thousand classifications with cases in English and Portuguese. Jev leads with 97.6% on the compact cases and 10 thousand decisions cost about 19 US cents. Jebadiah 4B is the best local one, Kev grows a lot from 0.8B to 4B and almost nothing to 9B, and Laya gets more than half wrong but answers in 19 ms and fits on any machine. Full table, cost in support emails, gotchas, and where the data converges."
tags:
- llm-benchmarks
- local-models
- artificial-intelligence
- llms
---

Last week I published [a long post about Jev](/2026/10/03/entendendo-o-hype-do-jev-pra-que-serve/), TypeSafe's hosted classifier that became all the rage in September. The short version of that post: Jev is a classifier, something that has existed for decades, and the "193x faster" amazement only exists because too many people were using chat LLMs as expensive, slow classifiers. I reproduced Paulo Câmara's essay *The student who marks answer A*, introduced the open alternatives Clef and Laya, and to compare the models side by side I leaned on the [Decision Index](https://huggingface.co/spaces/multimodalart/jev-decision-index), a public ranking that already existed.

Someone else's ranking is useful, but I wanted to get my hands dirty. So I built my own benchmark, with my own cases, half in Portuguese, and ran the open models on my [home server with Strix Halo](/2026/03/31/review-minisforum-ms-s1-max-amd-ai-max-395/), the same Ryzen AI Max+ 395 I use to test local LLMs. The hosted models (Jev and the two Clefs from Cloudflare) ran through their APIs. Everything, including the cases, the raw responses and the scoring scripts, is public in the [benchmark repository](https://github.com/akitaonrails/jev-docs-benchmarks).

> **TL;DR:** **Jev** is the best classifier of the bunch, with 97.6% accuracy in English and in Portuguese on the compact cases, and 10 thousand decisions cost less than 20 US cents. The full **Clef** ties with it in English and is free within Cloudflare's daily allowance. To run locally, **Jebadiah 4B v2** was the best, closely followed by Mapika Decider 4B, Kev 4B and Clef-flash. **Laya**, the smallest of all, gets more than half wrong, but answers in 19 ms and fits on any machine. If your problem is accuracy, cross Laya off. If your problem is running offline on a weak device, it may be the only one that works. Jump to the [full table](#the-full-table), the [cost in support emails](#how-much-it-costs-in-support-emails), [which model for which situation](#which-model-for-which-situation), [how hard it is to run the best open ones locally](#how-hard-it-is-to-run-the-best-open-models-on-your-machine) or the [gotchas](#highlights-and-gotchas).

## How I tested

The central idea was to measure more than "who gets the most right." A decision model has a design goal, and comparing a 322-million-parameter encoder made to run on weak devices with a hosted service of undisclosed size on accuracy percentage alone is unfair to both. So I measured accuracy, latency, cost and behavior under stress, and at the end I split the recommendations by situation.

### The two case sets

I built two test sets, frozen in git before any inference, with the dataset hash recorded alongside the responses. No model receives the expected answer, the justification or the case identifier. Only the text, the instructions and the options.

The **v1 set** has 13 operational use cases, in English, each with an explicit fictional policy:

- support ticket severity
- support routing
- refund policy
- incident escalation
- tool approval (whether an agent may or may not execute a given action)
- email fraud
- document type
- evidence support
- search relevance
- moderation
- order routing
- lead qualification
- numeric-threshold triage

There are 10 scenarios per use case, each presented four ways: original, options in reversed order, options with opaque names (c0, c1, c2) and original plus a "reviewer" comment suggesting the wrong answer, which the instructions say to ignore. That's 520 classifications per model. Add 24 probability probes in situations with no information at all (fair coin, six-sided die), where the right answer is mathematical.

The **v2 set** was made to cover what v1 leaves out: common semantics and Portuguese. There are 7 tasks, with 12 scenarios each, and every scenario written in English and in Brazilian Portuguese with the same answer and the same option order:

- sentiment (author versus quotation, negation, sarcasm)
- current intent (withdrawn request, competing actions, hypothesis)
- logical implication (quantifiers, absent fact, temporal order)
- search relevance (all, part or none of what was asked)
- sensitive data handling (fictional secret versus mention, redaction, revocation)
- current incident status (timeline order, verified versus unverified)
- threshold policy (inclusive bounds, units, AND/OR with a missing value)

Each pair runs under three conditions:

- **compact**: just the record and the rule
- **with examples**: one solved example per class, fixed and the same for everyone
- **with distractors**: ten irrelevant archive notes before the record that matters, to stress the context

That's 504 classifications per model.

> The cases were written with AI help and reviewed against the policies, without independent human annotation. It's a small, synthetic benchmark: 130 scenario families in v1 and 84 in v2. The variants are correlated, so 520 responses are 130 scenarios seen four ways. Treat the numbers as a snapshot of these cases, and test with your own before deciding.

### The 16 competitors

Three ran in the cloud, through the official API: **Jev** (version 1.13.0, from TypeSafe), **Clef** (27B, Cloudflare Workers AI) and **Clef-flash** (9B, same). The other thirteen ran on the Strix Halo, via ROCm, with weights pinned by Hugging Face commit hash, inside a Docker container. The first three (Laya, Laya typed and Clef-flash) shared one container; the ten in the second wave ran one at a time. The server has 64 GiB of GPU-addressable memory.

| Model | Nominal size | Origin | Where it ran |
| --- | ---: | --- | --- |
| Jev 1.13.0 | undisclosed | TypeSafe, proprietary | API |
| Clef | 27B | Cloudflare, open weights | API |
| Clef-flash | 9B | Cloudflare, open weights | API and local |
| Jebadiah 4B v2 | 4B | Frontier Infra, Apache 2.0 | local |
| Kev 0.8B / 4B / 9B | 0.8B / 4B / 9B | Jared Palmer, Apache 2.0 | local |
| Mapika Decider 4B | 4.2B | Mapika, Apache 2.0 | local |
| Eikos 4B | 4B | Caio Vicentino, MIT, trained on EN and PT | local |
| Simple-Jev + Qwen3.5 4B | 4B | Featherless, token-reading server over a stock model | local |
| Laya / Laya typed-decisions | 421M | Convai Innovations, ModernBERT encoder | local |
| Laya multilingual | 322M | Convai Innovations, mmBERT encoder | local |
| GLiNER2.5-Decide / multi-Decide | 340M / 287M | Fastino, Apache 2.0 | local |

Everyone received exactly the same text, the same instructions and the same options, with no per-model prompt tuning and no adjustments after seeing results (Simple-Jev uses its own server's fixed prompt policy). The exception is **GLiNER**, whose native API takes labels instead of probability distributions. It runs on a separate track, v2 only, with explicit mapping and no made-up calibration metrics.

**Simple-Jev** deserves an explanation. It's a server that takes a stock LLM (here Qwen3.5 4B, with no decision training at all) and reads the probability of the answer tokens instead of generating text. It's the baseline: if a "decision" model loses to this, the specialized training bought nothing.

### What was measured

- Accuracy per task, per language and per condition, always on top of the per-option probabilities the model returns, ignoring the vendor's "confidence" field.
- Brier and ECE for calibration.
- Median and p95 latency as seen by the client, including the network: WAN for the hosted ones, LAN for the local ones. These are deployment observations, and comparing hardware would require another test.
- Input tokens reported by the API, priced at the October 10 price table, before any allowance.
- Bootstrap confidence intervals over scenario families, instead of individual responses.

I left local cost unmeasured. Energy, hardware amortization and maintenance were left out, so local models show up as "not measured," because "zero" would be a lie.

## The full table

The main column is accuracy on the 168 compact v2 cases (84 in English, 84 in Portuguese). The v1 column uses the 130 original scenarios. Latency is the median seen by the client across the 504 v2 calls. Cost is the list price per 10 thousand compact decisions, computed from the tokens the API reported.

| Model | Compact EN / PT-BR | Compact combined | v1 originals | Median latency | 10 thousand decisions |
| --- | ---: | ---: | ---: | ---: | ---: |
| Jev | 97.6% / 97.6% | **97.6%** | 96.2% | 255 ms (WAN) | US$ 0.19 |
| Clef (27B) | 97.6% / 94.0% | 95.8% | 94.6% | 302 ms (WAN) | US$ 0.63 |
| Jebadiah 4B v2 | 91.7% / 89.3% | 90.5% | 85.4% | 205 ms (LAN) | not measured |
| Kev 9B | 92.9% / 83.3% | 88.1% | 87.7% | 561 ms (LAN) | not measured |
| Clef-flash (9B) hosted | 91.7% / 83.3% | 87.5% | 90.8% | 394 ms (WAN) | US$ 0.10 |
| Clef-flash (9B) local | 89.3% / 85.7% | 87.5% | 90.8% | 618 ms (LAN) | not measured |
| Mapika Decider 4B | 89.3% / 85.7% | 87.5% | 86.9% | 186 ms (LAN) | not measured |
| Kev 4B | 88.1% / 86.9% | 87.5% | 82.3% | 246 ms (LAN) | not measured |
| Eikos 4B | 85.7% / 79.8% | 82.7% | 87.7% | 235 ms (LAN) | not measured |
| Simple-Jev + Qwen3.5 4B | 77.4% / 71.4% | 74.4% | 85.4% | 1,349 ms (LAN) | not measured |
| Kev 0.8B | 64.3% / 61.9% | 63.1% | 63.1% | 86 ms (LAN) | not measured |
| GLiNER2.5-Decide (EN) | 54.8% / 50.0% | 52.4% | didn't run | 208 ms (LAN) | not measured |
| Laya typed-decisions | 50.0% / 35.7% | 42.9% | 43.8% | 43 ms (LAN) | not measured |
| Laya (EN) | 44.0% / 41.7% | 42.9% | 43.8% | 41 ms (LAN) | not measured |
| Laya multilingual | 35.7% / 38.1% | 36.9% | 43.8% | **19 ms** (LAN) | not measured |
| GLiNER2.5-multi-Decide | 32.1% / 35.7% | 33.9% | didn't run | 63 ms (LAN) | not measured |

To calibrate your reading: the tasks have three or four options, so a uniform guess gives about 31% on both sets. "Near 50%" here is already well above the coin, and "near 33%" is the coin.

The intervals matter. The difference between Jev and Clef on v2 is under 2 points and the bootstrap interval crosses zero: both are on the same tier, with Jev as the numeric leader. Jebadiah, on the other hand, sits 7 points behind Jev with an interval entirely below zero. From there down, every difference against Jev is clear.

Each task cell has only 12 scenarios per language, so one more correct answer moves the cell by more than 8 points. A tie on a specific task is a lead for a pilot. The per-task tables are in the [repository](https://github.com/akitaonrails/jev-docs-benchmarks/blob/master/benchmark/reports/next-wave-comparison-v2/results.md).

## How much it costs, in support emails

Price per million tokens is a number nobody can feel. List prices on October 10 are US$ 0.042 per million input tokens on Jev, US$ 0.24 on Clef and US$ 0.038 on Clef-flash. Output is free on all three.

Clef-flash cost US$ 0.09 on the 9th: Cloudflare cut the price by more than half in the middle of my test. Jev reports considerably more tokens than Cloudflare for the same text, about 45% more on v2, and that's already in the math below.

Imagine an operation with **10 thousand support emails per month** to classify into three or four buckets, with short texts similar to my cases:

| Model | 10k emails / month | 1 million emails | Expected errors in 10k (by compact accuracy) |
| --- | ---: | ---: | ---: |
| Clef-flash | US$ 0.10 | US$ 10 (about R$ 50) | ~1,250 |
| Jev | US$ 0.19 | US$ 19 (about R$ 95) | ~240 |
| Clef | US$ 0.63 | US$ 63 (about R$ 315) | ~420 |

> In reais, at Friday's exchange rate (R$ 4.99), 10 thousand decisions on Jev cost one real. A million costs less than a hundred reais. For any company with a million emails to classify, that vanishes into the budget.

One caveat about proportions: my cases are short, about 450 tokens per compact case by Jev's count. A real customer email, with quoted thread history, can be three to five times larger, and cost scales linearly with that. Even so, we're talking cents per thousand.

What this math shows is that the price difference between the hosted models is irrelevant next to the cost of being wrong. Jev costs 9 US cents more than Clef-flash per 10 thousand decisions, and in those same 10 thousand it makes about a thousand fewer errors. If a misrouted email costs more than a hundredth of a US cent in human rework, Jev pays for itself. This math assumes every error costs the same, which is never true: sending a critical ticket to the routine queue costs far more than the reverse.

Cloudflare's allowance changes the math for small players. It's 10 thousand "neurons" per day, shared by the whole account, resetting at midnight UTC. With my input sizes, that's about 1,500 full-Clef classifications per day or almost 10 thousand Clef-flash ones, free. If you have 1,000 emails a day and nothing else running on the account, Clef comes out at zero cost with top-tier quality.

And local? Energy is what the benchmark didn't measure. From what I see on my Strix Halo, the whole machine stays under 100 W under load. With Jebadiah at 200 ms per decision, 10 thousand decisions are about 35 machine minutes, under 0.1 kWh, a few cents of a real on the power bill.

The real local cost is the machine, your hours configuring ROCm and containers, and keeping it all standing. Whoever already has the hardware for another reason has low marginal cost. Whoever would buy the machine just for this is buying a problem of thousands of reais to save about a hundred reais per million.

## Which model for which situation

### You want accuracy and want to operate nothing: Jev

Jev won or tied practically every cell. In English it was 100% on five of the seven v2 tasks, and in Portuguese it repeated 97.6% on the aggregate without losing anything in translation, something no other model above the coin managed. On v1 it kept its 96.2% on the original with the malicious "reviewer" comment injected; Clef even gained one case, and Kev 4B also stayed put, just at a much lower tier. The 255 ms latency over WAN was the lowest among the hosted ones, and it costs 19 US cents per 10 thousand decisions.

The trade-off is the one I already discussed in the previous post: it's proprietary, hosted, of undisclosed size, and you depend on TypeSafe keeping the behavior underneath you. And it makes mistakes. It treated an invoice ID called "PASSWORD-523" as a usable credential, even with the record explicitly saying it doesn't authenticate anyone.

### You want the same level with open weights: Clef

The full 27B Clef tied with Jev in English (82 of 84) and finished 3 cases behind in Portuguese. It beat Jev on sensitive data handling in English (12 of 12 versus 11). It's an open-weights model, so you can run it locally with about 54 GB of memory just for the weights in BF16, which I didn't test: the full Clef ran only through the API.

Through the API it's the most expensive of the three hosted ones, three times Jev, with no quality gain to justify it. The exception is the daily allowance: for small volume, it's the best classifier you can get for free.

### You want the cheapest in the cloud: Clef-flash

At US$ 0.038 per million, Clef-flash is the lowest price in the hosted market and covers 9,400 decisions per day within the allowance. Quality drops: 92% in English and 83% in Portuguese on the compact cases, the biggest language drop among the hosted ones, with an interval entirely below zero. On sentiment in both languages, and on incident status in English, it tied with Jev. On intent and sensitive data in Portuguese, it lost badly.

For sentiment tasks in either language, or for English classification where 1 error in 12 is acceptable, it does well. For Portuguese, measure first.

### You need to run locally, with quality: Jebadiah 4B v2

Of the local ones, Jebadiah 4B v2 had the best compact accuracy, 90% combined, answering in about 200 ms. It tied with Jev on six of the fourteen task cells, including intent, implication and status in English and intent in Portuguese. The weak spot is numeric-threshold policy, 9 of 12 in both languages, and it loses ground when the context fills with distractors (76% in Portuguese under that condition, versus 82% for Mapika).

**Mapika Decider 4B** (the fastest of the 4Bs) and **Kev 4B** are right behind, both around 87%, and the 3-point difference between the three fits inside the error interval. They're three different training recipes on top of 4B backbones, with errors on different tasks. The choice between them depends on your task, and I'd run all three in a pilot.

### You will send examples in the prompt: Kev 9B

Kev 9B has a curious profile. On the compact cases it ties with Kev 4B, half a point apart with the interval crossing zero, meaning more than double the parameters bought nothing. With one solved example per class, it opens almost 10 points over the 4B, and with distractors it holds 7 more points. Brier also improves by about 25%: the probability it returns is better calibrated.

If your use is just the rule and the text, the 4B is enough and is more than twice as fast. If you're going to send examples or long context, the 9B is worth the memory. The warning is Portuguese: 83% compact in PT-BR, almost 10 points below its own English, the biggest language drop among the models above 80%. Only Laya typed drops more, 14 points.

### You want Clef-flash behavior on your machine: local Clef-flash

On the v1 set, local Clef-flash reproduced the hosted one's 520 classifications, hit for hit and miss for miss. On v2 the story changed: same total (439 of 504), but 19 different labels, with swapped strengths (the local one gets more Portuguese intent right, the hosted one gets more relevance right). Among the local ones it's still the best on the v1 operational-policy set (90.8%), ahead of every 4B.

The gotcha is latency: 618 ms median on the Strix Halo, three times Jebadiah, for the same v2 accuracy. If you pick it, it's for the known behavior.

### You need to run offline on weak hardware: Laya, with caveats

Laya multilingual was the worst in the benchmark for accuracy (37% combined, near the coin), and the fastest by far: 19 ms median, more than ten times faster than Jebadiah.

The three Laya checkpoints have between 322 and 421 million parameters, fit in under 1 GB of BF16 weights by parameter math, and the project documents CPU execution and an ONNX runtime (which I didn't measure). PyTorch's peak GPU allocation for the multilingual one stayed under 2 GB. A 4B needs about 8 GB just for weights at the same precision.

That's a design choice. Laya was made to be a small encoder, fine-tunable on your task, to run at the edge. What I tested was the factory checkpoint, with no tuning, applying rules it had never seen, on broad tasks. In that scenario it did badly, period.

One detail confirms the fragility. On v1, when the reviewer's malicious comment comes in, Laya drops from 44% to 19% and typed-decisions to 15%. It obeys the comment the instructions say to ignore, and confidently: 17 of the 28 guesses above 0.9 were wrong.

> If you want what Jev delivers, factory Laya is very far from it, and no small model (GLiNER included) came close. If your problem is "I need to classify short text into three buckets, on a device with no internet and no GPU, and I have a thousand labeled examples to fine-tune on," Laya is probably the only one on the list that fits. Fine-tuning is the part I didn't test. It's another question, and it needs another benchmark.

### The baseline: Simple-Jev with a stock Qwen

Simple-Jev reading tokens from Qwen3.5 4B, with no decision training at all, scored 74% on compact v2. That's the yardstick for "how much specialized training buys": Jebadiah, Mapika and Kev, all on similarly sized backbones, came in 13 to 16 points above. The training buys a lot.

The curious part is that on v1 Simple-Jev tied with Jebadiah (111 of 130 originals) and got both unambiguous critical tickets right, which several better models missed. It's also the slowest of the bunch, almost a second and a half per decision, because it's running a whole LLM.

## How hard it is to run the best open models on your machine

All these models speak the same HTTP protocol, called SystemOne, which Jev popularized: you send a state (the text), one or more closed-answer questions, and get back the chosen option and the probability of each. Swapping models is swapping the port. What changes is how much work it takes to get each one standing, and there the difference between them is big.

### Kev and Jebadiah: one pip and one command

**Kev** is the simplest of the 4B crowd. The project installs straight from GitHub and brings up a server with one command, downloading the LoRA adapter and the decision head on top of base Qwen3.5:

```sh
pip install "kev @ https://github.com/jaredpalmer/kev/archive/fc4a17e194bca35a48c57211392ec49ea54a94ac.tar.gz"
python -m kev.serve --run jaredpalmer/kev-4b --host 0.0.0.0 --port 8000 --device cuda
```

**Jebadiah** follows the same pattern, with the server package inside its own repository:

```sh
pip install "jebadiah-server @ https://github.com/getainode/jebadiah/archive/e9793abc66d1a7c5ad878d51eda656f1e9c5b9f5.tar.gz#subdirectory=server"
jebadiah-serve --model frontier-infra/jebadiah-4b-v2 --host 0.0.0.0 --port 8000
```

With either one up, a decision is a POST:

```sh
curl -s http://localhost:8000/v1/systemone -H 'content-type: application/json' -d '{
  "model": "kev-4b",
  "state": "Cliente diz que foi cobrado duas vezes e pede o estorno da segunda cobrança.",
  "questions": {
    "fila": {
      "type": "choice",
      "instructions": "Escolha a fila correta pela política de suporte.",
      "criteria": {
        "financeiro": "Cobrança, estorno, nota fiscal.",
        "tecnico": "Erro, bug, indisponibilidade.",
        "vendas": "Upgrade, plano novo, orçamento."
      }
    }
  }
}'
```

The response carries the option and the probability distribution, and that's where you apply your threshold, log and decide whether to send it for human review. On an NVIDIA with CUDA and 16 GB of VRAM, a 4B in BF16 comes up without drama. The weights are about 8 GB.

### Laya: even smaller

**Laya** is a Python package with an encoder inside. It installs with `pip install laya` and the project documents CPU execution, which is its whole point. The version pinned on my server was 0.4.1, and the multilingual one's peak GPU memory stayed under 2 GB. To run on a GPU-less laptop or a small container, it's the only one on the list that fits, no discussion.

### Where it gets complicated: AMD, ROCm and the rest

In my case the hardware is AMD, and then "one command" turns into a day of work. The points that cost me time, to save you yours:

- None of these projects test on ROCm. Kev had a gfx1151-specific segfault caused by CUDA graphs ([issue 170](https://github.com/jaredpalmer/kev/issues/170)), fixed only after the 1.0 tag, so the pinned version is a main-branch commit and the official tag crashes.
- The flash-linear-attention Triton kernels Qwen3.5 uses in the DeltaNet layers have no tested support on gfx1151. Everything ran on the pure-PyTorch path, slower than the latency published on CUDA. Jebadiah's 200 ms in the table is with that handbrake pulled.
- Mapika Decider forces CUDA graphs when it sees the "cuda" device, which on ROCm is also called "cuda." I had to turn it off by hand.
- You need to export `HSA_OVERRIDE_GFX_VERSION=11.5.1` and `PYTORCH_ROCM_ARCH=gfx1151` and use a base image with ROCm torch already validated. Any random `pip install torch` overwrites it with the CUDA build and breaks everything. In my Dockerfile every package is installed with `--no-deps` and the build fails if torch stops being the ROCm one.
- One model per container, one container at a time. The Strix Halo has memory shared between CPU and GPU, and three resident 4B models plus the Ollama that already runs there exhaust the 64 GiB the GPU can see.

None of this is impossible, and it's all documented, with Dockerfiles, compose and the hashes of each checkpoint, in the [repository's setup guide](https://github.com/akitaonrails/jev-docs-benchmarks/blob/master/docs/setup.md). But it's a real cost that the "local is free" spreadsheet never includes. If your machine is NVIDIA, most of this list disappears.

> The full 27B Clef I didn't even try locally: it's about 54 GB of weights in BF16 before any activation. The 9B Clef-flash runs, with about 18 GB of weights. The 4Bs are the sweet spot for consumer hardware.

## Highlights and gotchas

**Laya truncated all long Portuguese.** Under the distractor condition, base Laya reported truncation on all 84 Portuguese calls, discarding almost 31 thousand state tokens, and on none of the 84 English ones. The English checkpoint's default context limit is only 512 tokens (the multilingual and typed ones use 1,024, configurable up to 8,192), and Portuguese tokenizes heavier. The other models don't even expose truncation telemetry, so "zero truncation reported" on them means "I don't know."

**Portuguese costs more tokens.** For the same 84 case pairs, Jev reported about 14% more input tokens in Portuguese than in English, and both Clefs about 15% more. If you budget a bilingual operation by the English average, you'll come in low.

**Does an example in the prompt save a weak model? It saves nothing.** One solved example per class left Laya the same or worse; several of its aggregates dropped. It helped Kev 9B (plus 4 points) and Clef in Portuguese (plus 3.6 points, reaching Jev's level), and almost nothing on Jev, one more case in Portuguese. Validate examples on real traffic before assuming they help.

**Size correlates, and explains little.** Among the 14 competitors of known size, the Spearman correlation between parameters and compact accuracy was 0.92. The Kev series is more informative: 63% at 0.8B, 87% at 4B, 88% at 9B. The big jump is from 0.8B to 4B, about 24 points, with an interval between 16 and 33. From 4B to 9B the compact difference crosses zero, and several nominal 4Bs, with similar backbones, gave very different results.

**The 27B missed a critical ticket that two of the Layas got right.** On v1, one severity scenario says continuous data loss in production is critical, regardless of how many customers it affects. The record describes confirmed permanent loss, from a single customer. Jev, Clef-flash, Laya typed, Simple-Jev and Laya multilingual answered "critical." Full Clef, base Laya, Eikos, Jebadiah, Mapika, Kev 4B and Kev 9B answered "degraded."

> It's a single case, and an error rate would require many more. But it shows that the average hides exactly the error that costs the most. When the impact facts are structured, the severity rule belongs in code, and the model comes in only to extract the facts from free text.

**Hosted and local diverge over time.** Local Clef-flash reproduced the hosted one on v1's 520 classifications and diverged on 19 of v2's 504. Cloudflare keeps the weights version behind the hosted alias undisclosed. If reproducibility matters, pin the local hash.

**High confidence and safety are different things.** On compact v2, Jev, Clef, both Clef-flashes, Eikos and Jebadiah got zero guesses above 0.9 wrong. Mapika missed 5% of the guesses at that level, Kev 4B 3% and Simple-Jev 14%. Coverage varied too: Jev answered above 0.9 on almost 90% of cases, Clef on almost 80%, Clef-flash on 40% and base Laya on 2 of 168. On v1 Jev missed 1% of the guesses above 0.9 and base Laya missed 61%. A confidence threshold only works after being validated on your distribution, and Laya typed's low ECE in Portuguese left it at the same 36% accuracy.

**Numeric thresholds are a code problem.** The threshold-triage task, with clear numbers and an explicit rule, gave 100% on Jev and both Clef-flashes and under 30% on both Layas in English. An `if` solves that with 100% and zero latency. The model only comes in when the number is buried in free text, and even then the right thing is to extract the number and leave the comparison to code.

**Lottery probability is another skill.** On the 24 no-information probes (coin, die), Jev had the worst choice error among options and the best numeric-estimate error. Laya typed had the second-best choice error, behind only Kev 9B and neck-and-neck with Clef, and still classified badly. It's the "student who marks answer A" from Paulo's essay, now measured: calibration on lotteries and accuracy on classification are independent measures.

## Where the data converges

1. **For those who just want to classify text with quality and want to operate nothing, Jev is the obvious choice.** The cost is so low that the competitor's price stops being an argument: 9 cents per 10 thousand decisions over Clef-flash buys a thousand fewer errors. Those who want open weights at the same level have Clef, free at small volume and expensive at large volume.

2. **Running locally became viable at 4B.** Jebadiah, Mapika and Kev 4B deliver between 87 and 90% on the compact cases with 200 ms latency on a desktop machine, and in a pilot with your task any of the three can win. The financial math justifies using the machine that already exists, for data control or because of an obligation to stay offline. Buying a machine for this it stops justifying.

3. **Small models are another category.** Judging Laya by the accuracy column is reading the table wrong. It gets more than half wrong out of the factory and falls hard under a malicious comment, and it's the only one on the list that fits on a weak device and answers in under 20 ms. If Jev-like accuracy is a requirement, cross Laya off. If running offline on small hardware is a requirement, cross everything else off and start with fine-tuning Laya on your task, which is the missing measurement.

4. **Portuguese costs about 14% more tokens** and drops the models in the middle of the table by 1 to 10 points, with Kev 9B and Clef-flash in the worst case, while Jev loses nothing. For a Brazilian audience, that's the first column to look at, before price.

> And what holds for everyone: none of these models replaces the rule that's already in code. Numeric thresholds, severity policy with structured facts, tool permission, all of that stays in the `if`. The model comes in to turn free text into structured fact. And the test that matters is yours, with your tickets, because each cell in this table has 12 scenarios and your operation has thousands.

The cases, each model's raw responses, the scoring scripts and the guide to reproduce everything are in the [benchmark repository](https://github.com/akitaonrails/jev-docs-benchmarks). If you run it with your tickets and get a different ranking, tell me.
