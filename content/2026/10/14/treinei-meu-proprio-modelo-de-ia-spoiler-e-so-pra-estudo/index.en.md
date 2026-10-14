---
title: "I Trained My Own AI Model (Spoiler: It's Just for Study)"
slug: "i-trained-my-own-ai-model-spoiler-its-just-for-study"
date: '2026-10-14T15:00:00-03:00'
draft: false
translationKey: treinei-meu-proprio-modelo-de-ia-spoiler-e-so-pra-estudo
description: "One exercise was missing: training an LLM from scratch. I started from Karpathy's microgpt, 200 lines of pure Python, and expanded it into a lab with a tokenizer, pretraining, SFT, an OpenAI-compatible server and OpenCode integration. Under two weeks, one RTX 5090, 10 billion tokens, 137 hours of training, at most around R$ 80 of electricity. The final model has 337 million parameters, gets 58 out of 100 simple Python functions right and scores zero on anything that requires acting in a repository. I explain each step, the stumbles, the dimensions against GPT-2 and frontier models, and why I think the future is smaller, specialized models."
tags:
- artificial-intelligence
- llms
- machine-learning
- local-models
---

One exercise was missing from my list this year: trying to build my own LLM. Not a frontier model. Building a GPT-5 or a Claude takes years of study and experimentation, whole teams and hundreds of millions of dollars in compute. The [Stanford AI Index](https://hai.stanford.edu/ai-index/2024-ai-index-report) estimate for GPT-4 was US$ 78 million in compute alone, and for Gemini Ultra, US$ 191 million.

But nobody needs a GPT-class model for everything. A frontier model is a generalist by definition: it tries to know everything about anything, from tax law to song lyrics, and the returns on that diminish.

And most of them today are mixtures of experts: roughly speaking, several smaller models clustered into one giant chunk of bits, with a router that wakes only a few of them for each token. OpenAI's [gpt-oss-120b](https://arxiv.org/abs/2508.10925) has 117 billion parameters in total and uses 5.1 billion per token. [DeepSeek-V3](https://arxiv.org/abs/2412.19437) has 671 billion and activates 37. The big model is already, on the inside, a collection of small models.

I could have grabbed an open model, gpt-oss, Qwen, Phi, and adapted it. The techniques exist and are well documented:

- **Full fine-tuning**: keep training all the weights of a ready model on your data. It's classic transfer learning, formalized for text by [ULMFiT](https://arxiv.org/abs/1801.06146) in 2018.
- **LoRA and QLoRA**: freeze the original weights and train only small low-rank matrices beside them. [LoRA](https://arxiv.org/abs/2106.09685) cuts trainable parameters by up to ten thousand times; [QLoRA](https://arxiv.org/abs/2305.14314) quantizes the base model to 4 bits and fine-tunes a 65-billion model on a single 48 GB GPU.
- **Distillation**: train a smaller model to imitate a larger one's outputs. The idea is from [Hinton, 2015](https://arxiv.org/abs/1503.02531), and the most famous recent example is [DeepSeek-R1](https://arxiv.org/abs/2501.12948) distilled into versions from 1.5 to 70 billion on top of Qwen and Llama.
- **Continued pretraining**: one more training phase on text from your domain before any instruction tuning, the ["Don't Stop Pretraining"](https://arxiv.org/abs/2004.10964) of 2020.
- **SFT, RLHF and DPO**: teach the assistant format with demonstrations, then align with human preference via reinforcement learning ([InstructGPT](https://arxiv.org/abs/2203.02155)) or with a direct classification loss ([DPO](https://arxiv.org/abs/2305.18290)).

With any of those I'd have a useful model in hours. But the goal was different. I wanted to organize, hands-on, the basic techniques for building a model smaller than GPT-2, from scratch, in a few days, and see how far it would go. If possible, train a tiny model starting from random weights and add enough functionality for it to almost work inside an agentic harness like OpenCode.

Before going on, who I am in this story: I'm a curious software engineer and an amateur at this. As an LLM researcher I'm a zero. I knew I wouldn't have a working LLM in such a short time, and that's part of the exercise.

But it's not unachievable. If you're a computer science student, study hard and give it enough years, you can try it yourself. And if you're not a scientist, understand this: nobody needs to be Einstein to do this. The foundations are all available, published, for you to study and try. What's mandatory is elbow grease.

Spoiler: we got far into the "almost" and stopped there. The [repository is public](https://github.com/akitaonrails/microgpt), with every step and every failure documented. This text is the summary.

> **TL;DR:** I started from Karpathy's microgpt, 200 lines of pure Python that train a GPT in one minute on a MacBook, and expanded it into a PyTorch lab with its own tokenizer, pretraining, supervised fine-tuning, an OpenAI-compatible server and OpenCode integration. In under two weeks, on one RTX 5090, I trained a 337-million-parameter model on 10 billion tokens: 137 hours of training, at most around R$ 80 of electricity. It gets 58 out of 100 simple Python functions right on a held-out set, and scores zero on anything that requires reading, editing and testing a repository. The [360-million SmolLM2](https://huggingface.co/HuggingFaceTB/SmolLM2-360M), the same size, saw 4 trillion tokens, 400 times more. Jump to [Karpathy's exercise](#karpathys-exercise), the [steps](#the-steps-of-building-an-llm), the [dimensions](#the-dimensions-of-the-problem), the [stumbles](#the-stumbles), the [result](#what-came-out-the-other-side) or the [conclusion](#the-future-is-smaller-and-more-specialized).

## Karpathy's exercise

In February this year Andrej Karpathy published [microgpt](https://karpathy.github.io/2026/02/12/microgpt/): a single file of 200 lines of Python, with no dependencies, that trains and runs a GPT. He calls it "the full algorithmic content of what is needed. Everything else is just efficiency". It's the culmination of a lineage of his: micrograd (scalar autograd), makemore (generating names) and nanoGPT (compact GPT-2 in PyTorch), joined by [nanochat](https://github.com/karpathy/nanochat), "the best ChatGPT that $100 can buy", which at launch trained a GPT-2-capability model in almost four hours on a node of eight H100s, and today does it in about two.

microgpt is deliberately minimal: the dataset is 32 thousand first names, one per line, and the tokenizer is one character per token.

The network has one layer, 16 embedding dimensions, 4 attention heads, a 16-token window because the longest name has 15 letters. It trains for a thousand steps, one name per step, with Adam written by hand, and at the end generates made-up names, all in one minute on a MacBook.

What it teaches, by having everything exposed in a single file:

- autograd, the `Value` class that holds a number, the gradient and the chain rule to propagate back;
- what a token and an embedding are;
- the attention block, with query, key and value, and the causal mask that stops the model from peeking at the future;
- the cross-entropy loss against the next token;
- the optimizer;
- sampling with temperature.

It's a GPT-2 with small differences the file itself notes: RMSNorm instead of LayerNorm, no biases, ReLU instead of GeLU. After reading that, what's left between you and a real model is, in his words, efficiency. I went to see how much efficiency.

## What we expanded

The [microgpt lab](https://github.com/akitaonrails/microgpt) is an independent reimplementation in PyTorch, inspired by the gist, split by concept: about 3,300 lines of Python in 31 modules, plus scripts and 85 CPU tests. A single model implementation serves pretraining, assistant tuning and the server. Every weight starts random; the project downloads no pretrained weights at all, on purpose, because the rule of the exercise was from scratch.

On top of Karpathy's block came the components a 2026 model uses: RoPE for position, RMSNorm, SwiGLU in the dense layer, embeddings tied to the output, Flash Attention through PyTorch, a key-value cache with prefix reuse. And around the model, what it needs to talk to an agent: a conversation protocol with roles, an HTTP server compatible with OpenAI's chat API, tool calls validated by schema and optionally by grammar, separation of reasoning content, and the OpenCode configuration pointing at it.

The project went through four scales:

| Model | Parameters | Tokenizer | Purpose |
| --- | ---: | --- | --- |
| Byte lesson | 0.9 million | byte by byte | runs on CPU, teaches the whole loop |
| Student | 91 million | o200k (200K entries) | first agent, arithmetic |
| Capacity candidate | 239 million | o200k | more layers, same vocabulary |
| Foundation pivot | 337 million | own BPE, 32K entries | the final model |

The table hides the first big lesson, which I tell in the stumbles: in the 239-million model, 154 million parameters were just the vocabulary table. 85 million were left for the actual transformer.

## The steps of building an LLM

Regardless of size, the path has the same stations. What changes is the trailing zero at each one.

### 1. Data

A model is what it eats. We downloaded, with pinned revisions and hashes, selections of public corpora: [CodeParrot](https://huggingface.co/datasets/codeparrot/codeparrot-clean) (deduplicated, filtered Python), [OpenCoder](https://huggingface.co/datasets/OpenCoder-LLM/opc-sft-stage1) (instruction and code), [Cosmopedia](https://huggingface.co/datasets/HuggingFaceTB/smollm-corpus) (synthetic educational text), [SmolTalk](https://huggingface.co/datasets/HuggingFaceTB/smoltalk) (conversation) and a multilingual slice. The 14 download manifests add up to about 20 GB raw, all stored on the NAS.

Then comes curation: exact deduplication, splitting train and validation by repository or conversation group (never by line, or the same project leaks to both sides), and the mixture. The final foundation corpus has 3.5 billion stored tokens, 60% Python code, 16% instruction, 12% educational text, 8% conversation, 4% multilingual. Every proportion is a design decision, and none of them has a published right answer.

### 2. Tokenizer

The tokenizer is the dictionary between text and integers. The byte lesson uses 256 tokens plus one for end of document. The student used o200k, OpenAI's public vocabulary with 200K entries, which is what most tutorials do. The pivot trained its own BPE with 32,768 entries, on 92 MB of training-only text, with full UTF-8 coverage.

The choice looks like a detail and decides where the parameters end up. Each vocabulary entry costs one row in the embedding table at the model's width. With 200K entries and width 768, that's 154 million parameters spent on the table. With 32K entries and width 1,024, it's 33 million, and the rest goes to the layers that think.

### 3. Pretraining, or foundation

This is Karpathy's loop at scale. The model receives 2,048-token windows drawn from the training stream and learns to predict the next token. Each update processes 32,768 tokens: two sequences, accumulated eight times. AdamW, learning rate with warmup and cosine decay, gradient clipping, BF16 on the GPU and FP32 for the weights.

The pivot ran about 305 thousand updates, 10 billion tokens of exposure. Since the corpus has 3.5 billion, each document was seen, in the mixture's expectation, almost three times: the code about twice, and instruction, educational text and conversation about nine or ten. Every 500 updates, a validation and a checkpoint. At the 2, 5 and 10 billion milestones, a frozen checkpoint with a hash, to measure the curve.

### 4. Supervised fine-tuning

Pretraining produces a model that completes text. For it to answer a request comes SFT, *supervised fine-tuning*: question and answer examples in the exact format the server uses, with the loss computed only over the assistant's tokens. What the user and the tool said goes in as context and is masked out of the loss.

The examples came from NVIDIA's [OpenCodeInstruct](https://huggingface.co/datasets/nvidia/OpenCodeInstruct), and every answer was executed in a restricted Docker before going in: almost 99 thousand candidates, 97 thousand survived the test with three different hash seeds. 92 thousand training episodes remained. The selected checkpoint saw 64 thousand draws from those episodes, about 10 million answer tokens.

### 5. Protocol, tools and server

An agent like OpenCode talks to the model over HTTP: it sends the history with roles and the tool definitions, gets back text or a tool call in JSON, executes it, returns the result, and repeats. The lab implements that whole cycle: the same protocol file serializes the training examples and the serving prompts, so training format and usage format never diverge.

The server implements `/v1/models` and `/v1/chat/completions`, validates the tool call against the schema, can constrain generation with a grammar so the JSON comes out well formed, separates reasoning content from the answer, counts cached tokens and rejects context overflow instead of truncating silently. All of that is plumbing, zero intelligence, and without it the model doesn't even get a seat at the table.

### 6. Evaluation

The step that changed the project the most. A frozen set of 100 Python development tasks, 20 families with five variants of name and wording, plus 100 held-out tasks that only the final checkpoint saw. Every answer runs in a Docker with no network, no root, with CPU and memory limits, against fixed assertions. On top of that: four real repository-repair tasks through OpenCode, 12 problems of tracing a program's exact output, information-retrieval probes in prompts of 8, 16 and 32 thousand tokens, and four short conversations.

> No HumanEval, MBPP or SWE-bench. These are small local diagnostics, with correlated families, one seed, greedy generation. They serve to choose between checkpoints, and the closeout report itself says not to read "58 out of 100" as "58% success at programming".

## The dimensions of the problem

What all of this cost, and how it compares with the real world:

| Dimension | Our final model | References |
| --- | ---: | --- |
| Parameters | 337 million | GPT-2 small: 124 million; full GPT-2 (2019): 1.5 billion |
| Tokens seen in pretraining | 10 billion | SmolLM2-360M: 4 trillion; Llama 3.1: 15 trillion; Qwen3: 36 trillion |
| Raw data downloaded | 20 GB | GPT-2: 40 GB of WebText, 8 million pages |
| Foundation corpus | 3.5 billion tokens, 2.35 million documents | |
| Hardware | 1 RTX 5090, 32 GB | Llama 3.1 405B: 30.84 million H100 hours |
| GPU time in foundation | 137 process hours, 6.4 calendar days | DeepSeek-V3: 2.79 million H800 hours, ~US$ 5.6 million |
| SFT time | 3.4 hours across the nine stages | |
| Throughput | 23 to 44 thousand tokens/s, depending on I/O | |
| Peak VRAM | 13.9 GB in foundation; 6.8 GB in SFT | |
| Checkpoints | 17 distinct checkpoints (20 paths), 69 GB | |
| Cost in money | zero in cloud; about R$ 80 of electricity worst case | nanochat: US$ 100 on 8 H100s for 4 hours at launch; today about US$ 48 in 2 hours |

The electricity bill: the RTX 5090 has a [575 W rated power](https://www.nvidia.com/en-us/geforce/graphics-cards/50-series/rtx-5090/). Over 137 hours at full load that's about 79 kWh, and Enel's residential tariff in São Paulo in 2026, adding TUSD, TE and taxes, is around R$ 1 per kWh. Since training ran much of the time at a 75% duty cycle to keep the desktop from freezing, the real figure was lower. It's the marginal cost of someone who already owns the card.

Renting a 5090 on [Runpod](https://www.runpod.io/pricing) costs about US$ 1.20 an hour, so the same 137 hours would cost about US$ 165; an H100 runs between US$ 2.90 and 4 an hour, depending on the variant.

And the comparison that gives the scale. SmolLM2, at 360 million parameters, practically our size, was trained on 4 trillion tokens. At our throughput, 4 trillion would take between four and six years of uninterrupted GPU. Same model size, 400 times the amount of study.

That's why "parameters" is a misleading unit: it says the size of the brain, and nothing about how many years of school it had.

The rule of thumb derived from [Chinchilla](https://arxiv.org/abs/2203.15556) (70 billion parameters, 1.4 trillion tokens), about 20 tokens per parameter to be compute-optimal, would give 6.7 billion tokens for our model. We went past that. But Chinchilla's optimum is the point of best compute usage, and modern small models go far past it on purpose, because the inference cost afterward makes training more worthwhile.

## The stumbles

The full list is in the [closeout report](https://github.com/akitaonrails/microgpt/blob/main/docs/report/experiment-closeout.md). The ones that taught the most:

**Measuring too close to training.** The first agent, the 91-million one, completed four 16-round sessions in OpenCode and one 32-round session with 130 real tool calls, recovering from a check error and switching sessions midway, with the state kept by the harness. It looked ready.

Then I asked, by hand and in English, for a hello world function that takes a name as a parameter and prints it in the message. The model repeated the previous arithmetic edit twice, pointed at a file that didn't exist, and on the third attempt spat out invalid JSON. All it knew was the training task family.

**The vocabulary ate the model.** The 239-million candidate had more layers and lower loss than the 91 and solved 24 out of 100 problems. Looking at the parameter distribution, 154 million were vocabulary table. The pivot to 32K entries gave 300 million parameters back to the transformer. The pivot changed vocabulary, capacity distribution, initialization and exposure all at once, so the report doesn't isolate which of them moved the result.

**Loss is not competence.** In the final SFT, continuing from 4 thousand to 8 thousand updates lowered the validation loss and dropped executed correctness from 68 to 62. Lower loss, worse code. Checkpoint selection became by executed task, frozen beforehand; the loss number stayed out of it.

**Data and graders lie.** "Correct" answers from the public dataset failed when executed again. Tests that depended on Python's hash order, shadowed builtins, `SystemExit(0)` counting as success, empty edits copying the file. Each one needed a control: three hash seeds, a completion sentinel, an empty fixture that must fail. And in one of the mixed training runs, the model learned to say the tests passed when they hadn't.

**Training format and usage format have to match.** Session-switch announcements, tool-call IDs, edit anchors, the way OpenCode quotes user input: every difference between what the model saw in training and what it received from the server brought the old agent down. The same protocol file for both sides was the fix, and even so changing format sometimes improved the function name without improving the code.

**Tokenization crosses correctness boundaries.** The literal string `<|endoftext|>` inside source code has to remain ordinary text instead of becoming the end-of-document marker. Reconstructing UTF-8 documents without splitting a character in half. XGrammar's support for byte-level vocabularies. The first code evaluation at the 2-billion milestone failed at grammar construction, and was fixed and rerun instead of counting as a model failure.

**The NAS almost cost me days.** On resuming the 10-billion phase, the trainer loaded step 81,500 instead of the frozen 152,588: the mutable `last.pt` had a timestamp earlier than the pause, right after a NAS maintenance, and the cause was never proven. We discarded 1.24 hours of training, verified the hash of the 5-billion milestone, and every later resume came to require a hash, the exact step, optimizer and RNG state, the dataset and a write probe with fsync. Never resume a training run just because the file is called `last.pt`.

**A desktop GPU is a shared GPU.** Free VRAM didn't stop the browser from freezing. The fix was a cooperative duty cycle: the trainer syncs the GPU and sleeps between batches, 75% of the time during the day and 100% from 3 to 9 in the morning. And reading the corpus from the NAS, through mmap, left the GPU idle waiting for disk. After one maintenance the throughput dropped to 5 thousand tokens per second before climbing back to 23 thousand.

**I stopped at a pipeline boundary.** The pivot's controller implemented foundation, code SFT and holdout. It finished clean, and "finished clean" covered up to the isolated Python function, while the goal was the agent. The final checkpoint was tested in OpenCode only at closeout, and failed. It should have been tested before any sentence with "ready" in it.

## What came out the other side

The final model's spec sheet:

| Property | Value |
| --- | --- |
| Parameters | 337,167,360, of which 303.6 million in the transformer and 33.6 million in the vocabulary table |
| Architecture | 24 layers, width 1,024, 16 heads, SwiGLU with hidden width 2,752, RMSNorm, RoPE |
| Vocabulary | own BPE with 32,768 entries, UTF-8 coverage |
| Context | 32,768 tokens allocated; trained on 2,048-token windows |
| Foundation | 10 billion tokens, 305,176 updates, final validation loss 1.085 |
| Selected SFT | 4,000 updates, 10.3 million answer tokens |
| Checkpoint | 4 GB with optimizer state; 1.35 GB of weights alone in FP32 |

The learning curve, measured at the three milestones, with the same short SFT applied on top of each:

| Foundation tokens | Raw code completion /100 | After SFT 500 /100 | After SFT 1,000 /100 |
| ---: | ---: | ---: | ---: |
| 2 billion | 0 | 24 | 39 |
| 5 billion | 0 | 49 | 52 |
| 10 billion | 8 | 56 | 65 |

The longer SFT on top of the 10 billion reached **68 out of 100** on the development set and **58 out of 100** on the held-out one. All 100 held-out outputs are valid Python, and 97 have the requested function name and parameters. Nine families passed all five variants: median, factorial, greatest common divisor, binary conversion, inverting a dictionary, line count, leap year, seconds to hours, JSON keys. Running total ended at four out of five.

So what it does: it writes a small Python function, with a docstring, correct syntax and the right name, for a clear one-line request. Inside an editor, as autocomplete for an isolated function, it's fine for study.

What it gets wrong, with saved examples: deduplicating with a `set` when the spec required supporting unhashable lists; grouping by length by counting words instead of grouping; doing arithmetic on each element in a padding function; returning `(text, '')` in a split-once function, ignoring the separator; removing the last character instead of the directory in a basename function. Of the 42 held-out failures, 39 have valid syntax and the right name and fail on semantics. The hard part was never looking like code.

And what it zeroes:

- **0 out of 4** real repository repairs in OpenCode, with zero tool calls. Asked to read, edit and test a file, it returned text with code. In one of the tasks, it renamed the function to `fix_mean`.
- **0 out of 12** at tracing the exact output of short programs, with and without reasoning mode. Many answers were code that supposedly would compute the requested integer.
- **0 out of 9** at finding a six-digit number hidden in prompts of 8, 16 and 32 thousand tokens. The 32K-token allocation works; the useful memory, none.
- Conversation: asked in Portuguese about the color of the sky, it answered repetitively and wrongly; an English breakfast request became a Python docstring repeating "oats" until the token limit. In a short exchange it remembered the cat's name was Pipoca, and still answered with a full sentence despite the request for "only the name".

The final SFT had only code answers, no conversation, no tool trajectories, no error recovery. The tendency to answer anything with Python is consistent with that, and the report is careful to say the cause was not isolated.

## What it would still take for a simple agent in OpenCode

The report closes with engineering estimates, with no promise of a pass rate. To get to an agent that solves simple programming tasks inside OpenCode, in this order:

1. **Teach tool use on the stronger model.** Between 10 and 30 thousand short, verified repository trajectories (read, edit, check), mixed with 30 to 50% code so it doesn't unlearn. One to three days of engineering and two to six initial hours of training.
2. **Correct its own mistakes.** Collect hundreds to a few thousand model failures on training tasks, reconstruct the file state, verify the corrections and train while masking the wrong action. Another one to three days of collection and two to eight hours of training.
3. **Bring the conversation back.** A balanced mix of conversation, tools and code against the frozen checkpoint, so it stops answering everything with Python and can switch tasks. One to four hours of training.
4. **Real long context.** Only after the short tasks pass: 4K, 8K, and only then 16K and 32K, with real compaction and session-switch trajectories. One to two days of engineering and 6 to 24 hours of training, measuring memory at every window.
5. **More foundation, with better data.** Every additional 10 billion tokens costs between 93 and 139 hours on this GPU, before preparation and evaluation. And repeating the same 3.5-billion mixture isn't worth it: it needs more unique educational code.

None of those steps was executed. There's no evidence that a fixed number of extra hours would produce a reliable agent, and the report is explicit about it. What the exercise established was the distance: between generating a plausible function and acting reliably in a repository there's a chasm that parameters and allocated context alone don't cross.

> The strongest thing that came out of this was the measured curve from 0 to 65 in ten billion tokens, and three concrete counterexamples: syntax is not semantics, protocol support is not tool skill, and context capacity is not memory.

## The future is smaller and more specialized

After eleven days looking inside a model, my reading of the market got firmer. The generalist frontier model will keep existing and will keep being expensive, and the return on every extra billion parameters keeps shrinking. I already wrote that [the raw models converged](/en/2026/10/12/llms-agents-competent-enough/) and that the recent gains came from the harness. The exercise gave me the other half of the argument.

Mixture of experts is the industry admitting it on the inside. If the 117-billion gpt-oss wakes 5 billion per token, what you're using for an accounting question is a 5-billion model picked by a router. The question that remains is why carry the other 112 billion, of art, film, memes and particle physics, on an accounting office's server.

Imagine a local model, built for accountants. It knows the chart of accounts, the country's tax legislation, the tax authority's file formats, the jargon. It skips parameters about everything an accountant doesn't need, and it can run on the office PC, with the client's data inside the room.

The examples already exist in other fields: Google's 4-billion [MedGemma](https://research.google/blog/medgemma-our-most-capable-open-models-for-health-ai-development/) for health, the 7-billion [SaulLM](https://arxiv.org/abs/2403.03883) for law, the 7-billion [Fin-R1](https://arxiv.org/abs/2503.16252) for financial reasoning. In 2023 [BloombergGPT](https://arxiv.org/abs/2303.17564) needed 50 billion parameters and 1.3 million A100 hours to do finance; today a fine-tune on top of an open 7-billion model plays the same role for a fraction.

What changed to make this viable was the agent. A specialized model from 2023 had to know everything by heart, because the only thing it did was complete text. A 2026 model needs a base: enough reasoning, the ability to sustain a long task, reliable tool calling, prompt caching. The rest, the law that changed yesterday, the client's document, the table it never saw, it fetches with tools and the internet on the spot, and fills the gaps in its training at usage time.

[NVIDIA published in 2025](https://arxiv.org/abs/2506.02153) exactly that position: small models are sufficient, more suitable and cheaper for most of an agent's calls, with the big model called only when open-ended conversation demands it. Apple already [runs a 3-billion model on the device](https://machinelearning.apple.com/research/apple-foundation-models-2025-updates) with a tool protocol and per-task adapters.

It's the same reasoning as the [decision models I tested](/en/2026/10/10/which-jev-like-ai-decision-classifier-model-is-best/) last week: a 4-billion classifier trained for a task beats a generic chat model of the same size at it, in a fraction of the response time. Instead of trying to fit the whole world into a bigger model, fit the domain into a smaller one and let the harness fetch the world when needed.

And what my 337-million model taught me is the size of "enough" in that sentence. It knows the syntax and knows the names of things. What's missing, semantics, tools, memory, is exactly what separates a text generator from an agent, and nobody trains that in two weeks on a graphics card. You train it over months, on a cluster, with trillions of tokens, and then specialize.

The code is in the [repository](https://github.com/akitaonrails/microgpt), with the full closeout report, for anyone who wants to pick up where I left off. It's just for study. And it was the best study of the year.
