---
title: Teaching the Latest Zig to Your LLM - Training LoRAs (Sort Of)
date: '2025-05-03T02:30:00-03:00'
slug: teaching-recent-zig-to-your-llm-training-loras-sort-of
tags:
- zig
- qwen3
- ollama
- vllm
- llm
draft: false
translationKey: teaching-zig-to-llm-loras
description: A hands-on walkthrough of training a LoRA adapter on Qwen3-8B to teach it about Zig 0.14, covering datasets, fine-tuning, vLLM serving, and the limits of the experiment.
---



[Two posts ago](https://www.akitaonrails.com/2025/05/01/quando-llms-nao-funcionam-pra-programar-um-caso-de-uso-mais-real) I demonstrated the Achilles' heel of LLMs for programming: they weren't trained on the most recent data available. So if you ask about changes that came out last month in your favorite library, language or framework, they won't know.

Note: all the code I'm going to show below is available [in this repository on my GitHub](https://github.com/akitaonrails/qwen3-zig-lora-training). Go poke around after reading to the end.

For example, I asked the Qwen3-8b model (which came out a few days ago) which Zig version it knows about, and the answer was: 0.11 or 0.12:

![zig antigo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/39h50oguk03tci9reclcbiovolhm)

By the way, the screenshot also shows how you call an OpenAI-compatible LLM API using curl. Anyway, that's why I suffered so much yesterday trying to get a simple "Hello World" level program working: it doesn't know we're already on [Zig 0.14](https://ziglang.org/download/0.14.0/release-notes.html). And I did it on purpose, I knew it wouldn't have that information.

_"And other commercial LLMs? Aren't they better than the open source ones?"_

I asked ChatGPT 4.1, Claude Sonnet 3.7, Gemini 2.5 Pro Experimental, Deepseek R1 Zero (all at once, OpenRouter.ai allows multi-model chat):

![LLM cut off](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/z9wbo5yi49m4vd3zi3pjpxbo7zj7)

Summary:

- ChatGPT 4.1 says it only has data up to June 2024 and only knows up to Zig 0.11.
- Claude Sonnet says it only has data up to April 2023 and only knows up to 0.10.
- Gemini 2.5 Pro Exp says it only has data up to the start of 2023 and only knows up to Zig 0.11 as well.
- Deepseek R1 (after some deep thinking...) answered short and blunt that it only has data up to October 2023 and only knows up to Zig 0.11.

_"Why don't they have newer data?"_

I'll answer that by showing the reasons in the next sections.

_"But it can pull info from the internet, so it doesn't matter"_

It matters. That information is not IN the model. When you ask it to search the internet, the model doesn't know how to do that. It was instructed (in the fine-tuning/alignment phase or via prompts) to ask the chat system - the parser - to take that request, navigate the web (think curl, playwright, or anything like that), pull the site's content, copy and paste it only in your chat session (it's like a RAG solution). It only has that information in that session and other chats are not influenced by it.

_"But how does it show the source links when it replies?"_

It - probably - doesn't have that inside the model. What I imagine is simpler. They have catalogued and indexed all the original training material (including the source URLs) in a database (think Elastic, Postgres with full-text-search, or any vector database). When it finishes replying in the chat - the chat program and not the model -, it searches that snippet in the database for something similar enough and pulls the source URLs from there to show you.

Anyway.

Zig is experimental, pre-1.0. The syntax for everything changes A LOT from one version to the next, because they're still experimenting with what's best. And it's going to change more. In other words: it's impossible to do "Vibe Coding" in Zig unless you pin your compiler to version 0.11 or 0.12. But that would be "lame", to say the least. I chose to try Zig on purpose, precisely to prove this point.

The same applies to a lot of companies with private code. Think of ERP companies that have their own languages, their own libraries, and none of it is public, so it was guaranteed not to be in OpenAI's training and it's certainly way more information than fits in a prompt context.

**"Ah, just do a RAG"**

Canned solution without understanding. No, it doesn't help. It will prioritize the training it already had. Second, for each thing you ask, you'd need to know in advance that you'll need something that changed in 0.14, search that bit of documentation and keep adding it to the chat context. If you're going to do that method by method, why are you using the chat? Just go and write the code directly, it'll be faster.

Throwing ALL the documentation into the context doesn't work. I did the math: I downloaded the entire documentation and release notes, it's 200 thousand characters, roughly 50 thousand tokens. Most open source LLMs will blow past the window (average 32k tokens). Via commercial API/Chat you would pay per token, for nothing. Imagine wanting to refactor your 100-line piece of code and having to upload 200 thousand lines of context. Never do that. The cost-benefit doesn't justify it.

**"Ah, but the Geminis of the world support 1 million tokens"**

Yeah, with a sliding window, I've repeated this several times. It can't pay attention to everything at once. Again: you'll **PAY** for those 50 thousand tokens, right? And it won't be cheap. Imagine, every new session having to upload 50 thousand tokens with no guarantee they'll work.

So is it screwed? Is there no way to use Zig with LLMs?

### RAGs?

The RAG (Retrieval Augmented Generation, which is just a fancy name) hype makes it seem like it's something "magical". But really, there's nothing special about it. It's good for when you have a large database that grows all the time, but in each chat session you only need a little bit of that information. Think of a run-of-the-mill e-commerce support team with support tickets. It grows every day, but for each call you only need the specific ticket for the person being helped, which is pretty short.

In the most rudimentary way, the attendant searches for the ticket in the good old Zendesk, copies the text, pastes it into the ChatGPT chat window and starts asking questions about that ticket, like "can you summarize what this customer's problem is?", "can you imagine a solution for them?" and so on.

A RAG is a DATABASE with all those tickets pre-indexed to make relevance searches easier, and then it inserts the found snippet directly into the context window. It serves to automate, to SKIP the steps of manually searching in another system and doing copy and paste, but the effect is EXACTLY the same.

**"Ah, but it uses VECTOR databases, that must be way cooler"**

What's cool is hearing nonsense. It could be a Postgres and you'd do a SELECT to find the ticket, it's exactly the same thing. If you enable "full-text-search" in Postgres, it will index your tickets in a "VECTOR SPACE MODEL", which is essentially a VECTOR DATABASE.

If instead you prefer SOLR or ELASTIC, both are VECTOR DATABASES specialized in text search.

_Duh, the more you know._

The main things:

- the more you stuff into the context (whether prompt text or "embedding" of a vector database with RAG - it's the same thing), the more you risk confusing the LLM and having it start hallucinating. The best prompts are structured, organized, with direct orders, and that explain the context clearly.

- whether it's text-prompt or "embedding", it will CONSUME input TOKENS. And if the window is small (open source models), it will blow up if you don't control the size of what you send as input. There's no magic.

So what's the way out? Despite RAG being all people talk about, there's more than just RAG in the LLM world.
### Possible Solution: LoRAs

If instead of things that grow daily, the information is more "permanent" like instruction manuals, books, maybe RAGs aren't the best approach. Because it will always be TOO BIG and you'd need to REPEAT THE SAME THING in every chat session. Especially rules that depend on other rules.

Yes, good providers have [CACHE STATS](https://x.com/pashmerepat/status/1918084120514900395) and that helps a lot. Even so it's no guarantee. Out of nowhere you're going to check your bill and be surprised by USD 500 suddenly spent on token credits.

Example: programming language documentation. Like my case with Zig 0.14.0. I'd like the LLM to have that context, but uploading 50 thousand tokens every time is a lot if I only want to fix a 50-line file. Nobody thinks about these things or calculates context size vs chat/api interaction size, and they should: every wasted token is credit spent from your account.

There's a way to take an existing LLM model and add the missing training on top, without using context space. It would be as if the model were "updated" to know Zig 0.14. These are LoRAs (**Low-Rank Adapter**). It's a smaller kind of training we can add. We train small additional matrices (adapters) that attach to the original LLM's layers. When loaded, this updates the model's outputs without having to redo the entire training from scratch (which is the most expensive part and takes months in OpenAI's heavy datacenters, for example).

And here's a **DISCLAIMER**:

	I haven't studied enough yet about all the training parameters. Training is precisely the hardest phase. In particular: generating QUALITY training material and "tuning" the training parameters. There are people specialized in just this and there's no single recipe that works for everything. It's almost an "art" and takes much more dedication than I put in just for this post.

Some articles to start studying:

- [Instruction-Tuning Large Language Models (LLMs) with HuggingFace, LoRA and SFTTrainer](https://medium.com/@ufuk.birbiri/instruction-tuning-large-language-models-llms-with-huggingface-lora-and-sfttrainer-544bad770b50)
- [# Supervised Fine-tuning Trainer](https://huggingface.co/docs/trl/main/en/sft_trainer)
- [# Fine-tuning with the Hugging Face ecosystem (TRL)](https://rocm.docs.amd.com/projects/ai-developer-hub/en/latest/notebooks/fine_tune/fine_tuning_lora_qwen2vl.html)
- [# Notes on Fine-Tuning a Multi-Modal Large Language Model Using SFTTrainer](https://clay-atlas.com/us/blog/2024/10/08/en-multi-modal-large-language-model-sft-trainer/)
- [# A beginners guide to fine tuning LLM using LoRA](https://zohaib.me/a-beginners-guide-to-fine-tuning-llm-using-lora/)

And there's a lot more. This is where you have to really understand the "internals", the neural networks, loss function, gradients, etc. Don't underestimate training. It won't work on the first try, nor on the tenth. It's A LOT of trial and error and adjusting.

The final result is not exactly the same as a full training, but these adapters modify the parameters of the existing model's layers, changing the final result for specific things we want (that it knows Zig 0.14). It's MUCH cheaper than training from scratch. It doesn't guarantee it will work 100%, but it gives us an option to test, which can be more robust than a RAG.

The process is a miniature version of training a real model. We have to solve the following steps:

- get the training material (e.g. documentation)
- write fine-tuning prompts (I need to "teach" how it should respond - this is the hardest part)
- tokenize this information (trivial), load the base model (easy), and start training (the better the GPU, the less slow it is)
- if it succeeds, you need to load this LoRA along with the base model
- point tools like Aider at this new modified model.

Let's go, step by step.

### 1. Training Material

I think this is the hardest part: getting quality training material to train with.

In the alignment case, this is done by building it by hand (with help from scripts, with help from another LLM to help generate synthetic texts), but ideally I'd try to build a big JSON file with "prompt" and "completion" keys, something like:

```
{ "prompt": "How do the new @splat works for arrays in Zig 0.14.0?, "completion": "Zig 0.14.0 expands the `@splat` builtin to apply not only to vectors, but to arrays..."}
```

Now, doing this for EACH NEW feature in version 0.14.0, including code examples, multiple times for each topic, imagining different ways to ask. And no, I didn't do it and I don't plan to, it's already much more work than I want to try in just this experiment. And I'm not even sure if that's the best way yet. As I said before, it's practically an "art".

The [RELEASE NOTES](https://ziglang.org/download/0.14.0/release-notes.html) file converted to Markdown has a ridiculous **107 thousand characters**. I'd spend the rest of the week just re-editing it into prompt form. I'm not going to do that. Instead, I'll just pass the entire raw text and hope that these new facts "stick" enough for the LLM to remember them. To pull it, it's simple:

```
wget https://ziglang.org/download/0.14.0/release-notes.html -O zig-0.14.0-release-notes.html

# pip install html2text
html2text zig-0.14.0-release-notes.html > raw_data/zig-0.14.0-release-notes.md
```

Since I'm on a roll, why not do the same thing with the Zig documentation? Fortunately the documentation is a single big HTML file. So there's no work to build a recursive web scraper or anything like that. Same procedure:

```
wget https://github.com/ziglang/www.ziglang.org/raw/refs/heads/main/src/documentation/0.14.0/index.html -O raw_data/zig-0.14.0-docs.html

# pip install html2text
html2text raw_data/zig-0.14.0-docs.html > raw_data/zig-0.14.0-docs.md
```

That gave me a Markdown file of **464 kilobytes**. Since I think just that isn't enough, I thought it was a good idea to also grab the code examples in the `zig/doc` directory that I cloned directly from the [official Zig repository](https://github.com/ziglang/zig/tree/master/doc/langref). I don't know what the best way is, but I tried to organize a single big file, with the name of the `.zig` file and the code delimited by a tag, with a prompt at the beginning indicating this:


```python
...
zig_files = glob.glob("raw_data/zig/doc/langref/**/*.zig", recursive=True)
total_input_bytes = 0
file_count = 0
lines = []

for filepath in zig_files:
    file_bytes = os.path.getsize(filepath)
    total_input_bytes += file_bytes
    file_count += 1
    filename = os.path.basename(filepath)
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read().strip()
        entry = f"Reference Filename: {filename}\n\n```zig\b{content}\b```\n"
        lines.append(entry)
...
outpath = "raw_data/zig_docs_with_filenames.txt"
with open(outpath, "w", encoding='utf-8') as f:
    for line in lines:
        f.write(line + "\n\n")

...
```

Notice that in this case I'm formatting each example starting with "Reference filename: {filename}" and then adding the code in a Markdown block with 3 backticks. Is it a good format? I don't know yet. Making training material IS HARD.

That resulted in another big file of **152 kilobytes**. I hope it doesn't confuse more than help. And I didn't stop there. I wanted to add the entire source code of the [Standard Library](https://github.com/ziglang/zig/tree/master/lib/std) and I even wrote the script, downloaded and compiled it into a structured format, but the final file was **15 MEGABYTES**. Unfortunately I had to comment it out of my training script. Now I hit a limitation of my RTX 4090: there's not enough VRAM to train all of that.

As I've repeated before, the 4090 only has 24GB of VRAM. The Qwen3-8b model alone takes 16GB (no, the number of parameters influences the size but it doesn't mean 1 parameter is always 1 byte). There has to be memory left over to do all the training calculations, and it will spend 21GB while training. If I throw in that 15MB of material, this happens:

![out of memory vram](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/lawgc11lm8bv08hc2u4ms62v4hm0)

To train with all of that, it has to be remote, on a RunPod with an A40 like I showed in another blog post, at the very least. Or with faster GPUs like the H100, with 80GB, and more power to finish a little faster. So, I'm already limited on quality training material and now limited on the amount of material I can use.

Since I couldn't use the source code (which would have real idiomatic 0.14.0 code examples), I looked for other examples to add and found this [Zig Cookbook](https://github.com/zigcc/zig-cookbook) repository, which is organized as problems in a Markdown file with solutions in 0.14-compatible code. I wrote this other script to organize everything into a single file:

```python
...
lines = []

for prob_file in sorted(glob.glob('raw_data/zig-cookbook/book-src/*.md')):
    # Extract the nn-nn from the problem filename (e.g., 01-05-matrix-mul.md -> 01-05)
    base = os.path.basename(prob_file)
    if base == "SUMMARY.md" or base == "database.md" or base == "intro.md":
        continue
    print(base)
    match_part = base.split('-')[0] + '-' + base.split('-')[1]  # e.g., 01-05

    code_file = f"raw_data/zig-cookbook/src/{match_part}.zig"
    if not os.path.exists(code_file):
        print(f"WARN: No solution found for problem {prob_file} (expected {code_file})")
        continue

    with open(prob_file, 'r', encoding='utf-8') as pf:
        problem_text = pf.read().strip()

    with open(code_file, 'r', encoding='utf-8') as cf:
        code_text = cf.read().strip()

    # Compose chat format
    block = (
        f"<|user|>Solve this problem in Zig 0.14.0:\n{problem_text}\n<|endoftext|>\n"
            f"<|assistant|>This is the Zig 0.14.0 way to solve this:\n```zig\n{code_text}\n```\n<|endoftext|>\n"
    )
    lines.append(block)

with open("raw_data/zig_cookbook_chat.txt", "w", encoding="utf-8") as out:
    out.writelines(lines)

print(f"Wrote {len(lines)} problem/solution chat pairs to zig_cookbook_chat.txt")
```

In this case I'm trying to see if using CHAT TAGS makes a difference. Not every model supports it. But Aider, for example, assembles prompts like this: with tags indicating "who is speaking" (system, user, assistant) and it seems to be an alternative to doing it in JSON format. So each problem/code looks like this:

```
<|user|>### Measure the elapsed time between two code sections

[](https://github.com/zigcc/zig-cookbook/blob/main/book-src/03-01-elapsed-time.md#measure-the-elapsed-time-between-two-code-sections)
...
<|endoftext|>
<|assistant|>
...
fn expensive_function() void {
    // sleep 500ms
    time.sleep(time.ns_per_ms * 500);
}
<|endoftext|>
```

Will this work well? I don't know 😆 As I said, I need to spend many more hours dedicating myself just to understanding good training material formatting.

Finally, I tried to make a short file of prompts like I mentioned at the start, to try to force the chat to answer that it knows about the existence of version 0.14 and what the changes are in that version (just the topics from the release notes).

![training prompts](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ir04nsralua23ada3wk45xvavm97)

This is how the so-called **"alignment"** is done. At a big company like OpenAI, they must have HUNDREDS of human beings to write questions and answers that they want to force the LLM to reply with. And we have to do the same thing here, otherwise the Zig 0.11 and 0.12 training already in the base model might still override the new material I'm adding.

I understand there's no trivial way to say _"ignore the old version and only pull from my new material"_. That's not how it works. You "influence" the training (**supervised training**), but there are no "guarantees" that every variation of a question will give the same answer, unless you manually input most of the variations in the alignment.

	This is why I say DO NOT BELIEVE an LLM. It is not REASONING. It was FORCED to reply in a certain way by humans, during training. It literally has millions of PRE-PROGRAMMED ANSWERS already embedded in training. That's how you CONTROL the answers.

In my case, it's not enough to just upload the documentation, I should say in the prompts "what are the language changes in Zig 0.14.0?" and give the answer "In Zig 0.14.0 we had the following language changes: Labeled Switch, Code Generation Properties, Decl Literals, Fields and Declarations Cannot Share Names, @splat Supports Arrays, Global Variables can be Initialized with Address of Each Other, @export Operand is Now a Pointer, New @branchHint Builtin, Replacing @setCold, ......." (yes, a lot of stuff really did change).

Anyway. I'll push my training procedure [to my GitHub](https://github.com/akitaonrails/qwen3-zig-lora-training). There you'll find a `raw_data` directory where the material I compiled lives. There are scripts like `concat-zig-docs.py`, `concat-zig-stdlib.py` or `concat-zig-cookbook.py` to concatenate each group of material into a single big file as I explained. And at the end, there's `train-zig.py` which actually loads all the datasets and does the training.

There's another important factor: compared to the more than 800 kilobytes of material I compiled, the prompts I mentioned are still very small, only 8.3 kilobytes. We need to try to do **OVER-SAMPLING**. Ideally I should write at least 10x more real prompts manually, but I really don't have that much patience. What I'm going to do is repeat these prompts several times:

```python
import numpy as np
...
json_dataset_path = "raw_data/training-prompts.json"
text_dataset_path = "raw_data/zig-0.14.0-docs.md"
text2_dataset_path = "raw_data/zig-0.14.0-release-notes.md"
text3_dataset_path = "raw_data/zig_docs_with_filenames.txt"
text4_dataset_path = "raw_data/zig_cookbook_chat.txt"
text5_dataset_path = "raw_data/zig_stdlib_concat.txt"
...
# Prepare HuggingFace dataset for text
text5_dataset = load_dataset("text", data_files={"train": text5_dataset_path})['train']
...
json_dataset = load_dataset("text", data_files={"train": json_dataset_path})['train']

# oversample the prompts to try to influence the bias towards this new documentation
N = 100  # Oversampled target size
indices = np.random.choice(len(json_dataset), size=N, replace=True)
oversampled_ds = json_dataset.select(indices)
# text5 (std) won't fit in the 4090 so removed from combined
combined_dataset = concatenate_datasets([text_dataset, text2_dataset, text3_dataset, text4_dataset, oversampled_ds])
...
```

That's how you load the training data as `datasets`. And I use Numpy's `random_choice` to over-sample the JSON file and artificially make it bigger, repeating the lines randomly. And in the end we have a `combined_dataset` that is everything concatenated, about almost 900 kilobytes of material.

Then read the `train_lora.py` file, but with the combined dataset ready, now it's the actual training part:

```python
# Tokenize your dataset FIRST:
def tokenize_function(example):
    return tokenizer(example["text"], truncation=True, padding=True)

tokenized_dataset = combined_dataset.map(tokenize_function, batched=True)

# Training hyperparameters
training_args = SFTConfig(
    output_dir = "qwen3-zig-lora",
    per_device_train_batch_size=2,
    gradient_accumulation_steps=4,
    warmup_steps = 5,
    num_train_epochs = 5,
    learning_rate = 2e-4,
    fp16 = not is_bfloat16_supported(),
    bf16 = is_bfloat16_supported(),
    optim = "adamw_8bit",
    weight_decay = 0.01,
    lr_scheduler_type = "linear",
    seed = 3407,
    report_to = "none",
    max_seq_length = 2048,
    dataset_num_proc = 4,
    packing = False, # Can make training 5x faster for short sequences.
)

# Trainer for unsupervised SFT
trainer = SFTTrainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_dataset,
    processing_class=tokenizer,
)
trainer.train()
model.save_pretrained("qwen3-zig-lora")
tokenizer.save_pretrained("qwen3-zig-lora")
```

First, we tokenize the dataset, we convert text into tokens (this is fast; in the chat you use every day, your text is converted into tokens like this too - the model doesn't understand text, it understands embeddings, which are these tokens translated into vectors).

In `SFTConfig` we configure the training parameters. I think most of them are default values, but there are two important ones:

- Epoch: One pass through the training material is called "one Epoch". They say for little material (like my case), it's good to go more than 3 Epochs, up to 10 Epochs. More Epochs tries to make my new LoRA "stick" more. If the dataset were orders of magnitude larger, fewer Epochs would be better, because there's the problem of **OVER-FITTING**. It "sticks" too much and the model will memorize my material too much and just copy-paste directly. It depends on the type of material, depends on the amount of material. With 5 Epochs this material takes more than 1 hour to process, 10 Epochs then pushes it to more than 2 hours.

- Learning Rate: it's the scale factor of how much we want the "weights" inside the model to change. How aggressively do we want this new information to change the model weights, so it actually "learns"? If it's too high, it'll start to "forget" what it already had in the prior training and create knowledge gaps ("catastrophic forgetting"). If it's too low, it changes little, and our LoRA won't have any significant effect.

There's one more parameter that leaves me in doubt, `max_seq_length`, which serves to truncate overly long text. Theoretically the `unsloth` library knows how to split training material into smaller "chunks" (if it has obvious delimiters). But I don't know what happens with giant things, like the entire documentation. Whether it splits and uses it, or truncates and doesn't use it. There are many details that still need more studying. If it's truncating without me knowing, maybe I'm feeding material it's not actually using, for example.

The old facts that already exist in training (Zig 0.11 and 0.12) are stronger than my material. So cranking up those parameters might help influence the final result more. That's the other part of the "art": keeping adjusting these values to better fit the new knowledge. In a full training, from scratch, it's even more important. I don't know everything about this. What I said is the amateur level of training an LLM.

A LoRA is supposed to be small. With an 8B base model, with this training material size, the final LoRA will be in the 3 to 4GB range (I don't know if that's considered big or small). And that has to be enough to redirect the responses to the new knowledge. If you didn't know this, on sites like Hugging Face you'll find pre-trained LoRAs to use, you don't necessarily have to make one from scratch if there's already a ready one.

With the material in place, processed, organized, just run my `train_lora.py` and you'll see something like:

![training](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/s3rpq8b6a3h1p0qt60yazf042cr7)

And with so many Epochs and high Learning Rate, it will take a while! On my RTX 4090 it should take **more than 1 hour training** (with 5 Epochs), maybe more (I didn't time it), and while that's running it really will nail the GPU:

![GPU usage](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ivjodz630t9svrpvofuzpmgjanhe)

I know there are online services to train remote LoRAs, I think Hugging Face itself has APIs for it, or we can spin up a more powerful GPU on a RunPod. Obviously, you need access to the model to train on top of it (the LoRA parameters are dependent on the base model) so there's no way to make a LoRA of GPT 4.1 on your machine. That depends on whether OpenAI has APIs to train LoRAs remotely (I think they do, I didn't look).

Repeating: LoRAs are specific to the base model. Say you made a LoRA for the Qwen3-8b model (my case). Will that LoRA work for Qwen3-32b? No. It's specific. You have to load exactly the same base model when using your LoRA.

It's up to you, you don't need to have a local GPU just for this. It's an intensive process, that uses a lot of resources and a lot of energy and, depending on how much training material and how many epochs... go grab a coffee.

At the end, a `qwen3-zig-lora` directory will appear more or less like this:

![lora](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/83h7fwsx0jsod3h17ruv4ag237r1)

It records a checkpoint per epoch or something like that, from what I understand. Which means that depending on the strategy, if needed you can stop training and then continue from where you left off. I haven't tried to do this, but I imagine in a real training, which takes MONTHS, this is essential.
### Another Problem - Ollama's Limitations

To use a local model, as I already showed [in this other article](https://www.akitaonrails.com/2025/04/25/seu-proprio-co-pilot-gratuito-universal-que-funciona-local-aider-ollama-qwen), we can load an LLM like Qwen3 with the Ollama server, which will spin up a web server and serve APIs in the OpenAI standard. Then just point a tool like Aider at it and done, we have a code assistant running locally.

The problem: LoRA support in Ollama is limited (it may be lack of research on my part, but I didn't find a quick solution). They use a proprietary format for the models, and not `.safetensors` files like those on Hugging Face. Anyway, I hit that problem and I think it's not easy to proceed with Ollama.

So we have to switch and, fortunately, there are options. The most popular alternative is [vLLM](https://blog.vllm.ai/2023/06/20/vllm.html). It does the same thing: loads models and spins up an HTTP API server in the OpenAI standard. The advantage is it's more flexible (works with Hugging Face models), more advanced, more customizable and the main thing: it can load [models with LoRAs](https://docs.vllm.ai/en/latest/features/lora.html). Check the documentation at the previous link, but in my case I think it's pretty simple.

And for those thinking about deploying for multiple users, vLLM is more performant and faster than Ollama too. Even for RAG solutions: Ollama only accepts prompt injection, while vLLM will integrate RAG better via OpenAI/proxy/Langchain for example.

You may need to study the options a bit more, but technically speaking, it's superior. I always think of Ollama more for running locally on your own machine, but not for production. vLLM I "think" would be better for that purpose - worth researching later if you're interested.

My training, in the end, will generate a directory called `qwen3-zig-lora` and with vLLM we can spin up the server like this:

```bash
# pip install vllm[all]

vllm serve Qwen/Qwen3-8B \
    --enable-lora \
    --lora-modules ziglora=./qwen3-zig-lora \
    --max_model_len 8192
```

To test that it's up, we can run a simple curl command:

```bash
❯ curl localhost:8000/v1/models | jq .
```

And we'll have the lora listed as if it were just another model. See `ziglora` at the bottom:

```json
{
  "object": "list",
  "data": [
    {
      "id": "Qwen/Qwen3-8B",
      "object": "model",
      "created": 1746207038,
      "owned_by": "vllm",
      "root": "Qwen/Qwen3-8B",
      "parent": null,
      "max_model_len": 8192,
      "permission": [
        {
			...
        }
      ]
    },
    {
      "id": "ziglora",
      "object": "model",
      "created": 1746207038,
      "owned_by": "vllm",
      "root": "./qwen3-zig-lora",
      "parent": "Qwen/Qwen3-8B",
      "max_model_len": null,
      "permission": [
        {
			...
        }
      ]
    }
  ]
}
```

To chat with it, we can directly use the API with curl and send the message to the LoRA:

![curl lora](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/f1etshmornpoawgci7ndb7791r3a)

And pay attention to the response. I asked which is the most recent version of Zig it's familiar with and the answer was _"I am familiar with the Zig language up to version 0.14.0 from 2025."_

I can't say if it's true 😂 this only means that the weight of my prompt over-sampling with canned answers is working. Maybe it didn't learn anything about Zig 0.14.0 but it learned to reply that it knows. And, again, this is why you shouldn't trust LLMs: having a canned answer forced in alignment doesn't mean it actually "knows" what it's talking about, I just forced it to answer with conviction that yes. And that part worked.

Qwen3-8b has a tiny context window, only 8K tokens. So in `.aider.model.settings.yaml` you have to configure it like this:

```yaml
- name: hosted_vllm/ziglora
  edit_format: diff
  use_repo_map: false
  extra_params:
    max_tokens: 8192
    temperature: 0.1
  accepts_settings:
  - reasoning_effort
```

To run Aider, I'm temporarily doing it this way:

```bash
OPENAI_API_BASE=http://localhost:8000/v1 aider --watch-files --model hosted_vllm/ziglora --reasoning-effort none --verbose
```

Since it's an API compatible with OpenAI's, I just point to localhost in the environment variable. And since it's a vLLM model instead of "openai/..." you have to use "hosted_vllm/...". Also to save tokens, I'm turning off Aider's repo-maps and trying to turn off the model's thinking with `-reasoning-effort none` but I don't know if it works, I still see it doing some long thinking.

I would have preferred to use the Qwen3-14b model but as I said, it wouldn't fit on my 4090, with the 8B I'm already at the limit, and I wasn't in the mood to spin one up on RunPod. Plus I had no idea how many times I'd need to repeat the training (as I'm writing this post, I've already repeated it at least 4 times, each taking over 1 hour). At least running locally I know I'm not being charged a lot for some online service. Later, if it actually works, I'll try with a bigger model, more material, on a more powerful machine with more VRAM to fit it.

### Tangent: Learning a Language

I suspect my training material is still very weak. Let's think:

If you only read the documentation (let's say you memorize it), if you only read small examples like the Cookbook (let's say you memorize it), if you only read a release note. In the end can we say you're now a senior Zig dev? Hardly. For an LLM it's also not that simple. It needs MUCH more material.

An example would be reading the entire source code of the Standard Library, to really know how each structure, each function really works under the hood. And even that is little.

You'd need to build a scraper to filter all of StackOverflow looking for Zig 0.14 problems and solutions. Pain points in converting code from 0.12 to 0.14. As much as possible. You learn like that: having a problem and searching for another person who had the same problem in the past, to see how they solved it.

You'd need to fetch all the Issues in the repository. Bug reports or false positives of not understanding the documentation, for example. How they were resolved is the important part.

You'd need to search for more than just a Cookbook. If there are books, courses, exercises, you'd need to organize all of that in training.

More than that, you'd need to know C/C++ the same way, you'd need to know the GCC and Clang compilers. You'd need to know all the C/C++ problems that Zig says it improves, in various code examples. Learning Zig at a senior level isn't just Zig, it's the whole rest of the ecosystem.

You'd need to see how, for example, in Rust various problems are solved and have similar solutions in Zig, to have a comparison point, especially in hard problems involving performance optimization, memory management, concurrency management, security, etc.

You'd need to go after the main open source projects that use new Zig, classify what problems they solve, read all the source code. All of this would need to be in the training material, just like a programmer would also have to do to go from amateur to advanced, from junior to senior.

I don't know what materials were used in a Qwen (or Claude, or Gemini) to train Zig. I hope it was at least this. Otherwise it really won't be able to write real Zig code.

Except that much material starts reaching the gigabytes-of-data category to train on. I wouldn't know anymore whether it still fits to keep using LoRAs or whether it already falls into the category of creating checkpoints on top of the model itself (everything in the same LLM "big file"). These are doubts I still don't have answers to.

### First Impressions of the LoRA

Unfortunately, since I used Qwen3-8b as the base, I was also limited to its super short context window, only 8192 tokens. So I can't use Aider, because just the system prompt it uses to instruct the model already consumes almost everything and there's no room left for it to reply. So my tests were limited because I had to chat with the model directly through the API, using `curl` and `jq` to see the responses.

That's what the `--max-model-len` in the call to spin up vLLM is for, otherwise it tries to spin up a too-large default window (40k) and blows out my RTX 4090's VRAM:

![vllm out of memory](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/5sb1dj2x0st18wsbyecwef7lbwk6)

Notice how I'm sending super short prompts: there's no additional context from RAG or anything like that to try to teach Zig 0.14. Anything it replies is permanently in the LoRA training now.

Repeating the first test:

```bash
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
        "model": "ziglora",
        "messages": [{"role": "user", "content": "Hello, which most recent version of the Zig language are you familiar with?"}]                    }' | jq
```

Here's the response (just the message, I removed the JSON to not make it too long here):

```
"<think>
I have knowledge of Zig up to version 0.14.0, released in 2025. My training data includes documentation for Zig version 0.14.0, so I understand its new features, such as the default C Library being now LazyLoaded, and the new `@hasDecl` builtin. However, I am not aware of any changes made to Zig after that release. If you have a question about Zig 0.14.0 or earlier, I'll be happy to help! If you have a question about Zig 0.15.0 or newer, I recommend checking the official documentation or community resources for the latest information.
</think>

I have knowledge of Zig up to version 0.14.0, released in 2 GitHub Oct 2025. I know about its new features, such as the default C Library being now LazyLoaded, and the new `@hasDecl` builtin. However, I am not aware of any changes made to Zig after that release. If you have a question about Zig 0.14.0 or earlier, I'll be happy to help! If you have a question about Zig 0.15.0 or newer, I recommend checking the official documentation or community resources for the latest information.
```

See how the "deep thinking" or "reasoning" part is returned. This model does this and it's bad because the context window is small and these "think" tokens take up space in the context. See how it managed to answer that it knows 0.14 and even some of the new stuff in it. Let's continue:

```bash
❯ curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
        "model": "ziglora", "temperature": "0.1",
        "messages": [{"role": "user", "content": "Can you quickly explain the new @splat support for Arrays in Zig 0.14.0? can you give me a code example"}]
        }' | jq .
```

And here's the response:

```
<think>
Okay, the user is asking about the new @splat functionality for Arrays in Zig 0.14.0. First, I need to recall what changes were introduced in that version regarding Arrays and @splat. From what I remember, prior to 0.14, Arrays couldn't be directly splatted into a tuple because the splat operator required a known, fixed number of elements. The new feature allows Arrays to be splatted into tuples, similar to how slices work with tuples.

So, the user wants an explanation and a code example. Let me think of a simple demonstration. Maybe creating an array and then using @splat to convert it into a tuple. I should also mention the syntax, like how the number of arguments in the tuple matches the array length. Oh, and note that this is a new feature in 0.14, so it's important to mention the version. Let me make sure the example is clear and concise. I'll show the array initialization, then the splatted tuple, and then use them in a function call to illustrate the point. That should cover the basics without overwhelming the user. Also, I should explain why this is useful—making the code more readable and avoiding the need for explicit tuple syntax. Alright, that should do it.
</think>

Here's an example demonstrating `@splat` with Arrays in Zig 0.14.0:  

const std = @import(\"std\");  

const Color = struct {  
    red: u8,  
    green: u8,  
    blue: u8,  
};  

const red = Color{ .red = 255, .green = 0, .blue = 0 };  
const green = Color{ .red = 0, .green = 255, .blue = 0 };  
const blue = Color{ .red = 0, .green = 0, .blue = 255 };  

const palette = .{ red, green, blue };  // Array of 3 elements  

const color_func = @splat(palette);  // Result type: (Color, Color, Color)  

pub fn main() !void {  
    // Use the splatted tuple!  
    _ = color_func;  
}  

### Key Points:  
- `@splat` infers the tuple element type from the array type.  
- The number of elements in the tuple matches the array length.  
- This syntax is available in Zig 0.14.0 and simplifies working with Arrays.  

This pattern is particularly useful when passing multiple related values to functions or initializing structs.
```

The response itself seems pretty okay. It didn't truncate, no Chinese characters showed up (that happened in one of my failed trainings). Let's compare it with the official release note on the site:

![release note splat](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/fuks9uthx1l56sfpcltclhlx4n2h)

To be honest, I can't say if it's correct (I don't know Zig yet either 🤣). But at a glance I think it made up waffle, it doesn't look right.

Now let's see the harder test: trying to write a small program.

```bash
 curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
        "model": "ziglora", "temperature": "0.1",
        "messages": [{"role": "user", "content": "Can you give me a Zig 0.14 code example of a simple program that acts like an interactive chat, so the user can input messages. then the message is parsed to see if there are commands such as '/list', which will list the files in the current directory, or '/cat' which will read the file asked, or '/quit' to exit the chat?"}]
      }' | jq 
```

The response was VERY LONG (lucky it didn't actually blow the context). I'll leave it in full so you can see how the model with the lora loaded managed to respond:

```
<think>
Okay, let's see. The user wants a Zig program that acts like an interactive chat, handling commands like /list, /cat, and /quit. They specified using Zig 0.14, so I need to make sure the code is compatible with that version. 

First, I'll outline the main components. The program needs to read user input line by line, parse each line for commands, and execute the corresponding actions. 

For handling input, I'll use std.process.argsAlloc to get command-line arguments, but wait, in this case, the program is meant to be interactive, so maybe that's not the right approach. Oh, right, the user wants to input messages interactively, not pass them as command-line arguments. So I should read from stdin line by line.

So, I'll start by reading lines using a loop. Each line will be checked for commands. The commands are /list, /cat, /quit. 

For /list, I need to list files in the current directory. Using std.fs.Dir.openDir on the current directory, then iterating over the entries. But I have to handle errors properly. 

For /cat, the user will input something like /cat filename, so I need to parse the filename. Then open the file, read its contents, and display them. Again, error handling is important here. 

/quit should exit the loop, ending the program. 

Now, structuring the code. I'll use a while loop that reads a line at a time. Each iteration will process the command. 

Wait, but how to read lines interactively? Using std.process.stdin, perhaps. So, I'll create a Reader for stdin, then read lines into a string. 

But in Zig, reading lines can be done with the readline function, but I need to handle EOF. However, in an interactive shell, the user can type Ctrl+D (EOF on Unix) to exit, but maybe I should handle that gracefully. 

So, the main loop will look like this:

var line = std.ArrayList(u8).init(allocator); 
while (true) { 
    if (!readLine(allocator, &line)) break; 
    processLine(line); 
} 

But how to implement readLine? Maybe using a function that reads until a newline is encountered, handling errors. 

Then, for each line, split the line into parts. For example, /list is a single command, but /cat needs the filename. So, splitting the line by spaces, then checking the first part. 

Wait, but /cat needs the filename as the second argument. So, for /cat, the line should be split into parts, and the second part is the filename. But what if the filename has spaces? Probably, the code should split on the first space, since the command is the first token. 

So, for each line:

var parts = line.split(\" \"); 
var command = parts[0]; 

Then, handle each case. 

Now, error handling. For example, when listing files, if the directory cannot be opened, we should print an error message. Similarly for file reading. 

Also, need to free the allocator when done. 

Putting it all together. Let me draft the code. 

First, the imports. I'll need std's process, fs, and so on. 

Then, the main function. 

But wait, in Zig, the main function can be written with a while loop reading lines. 

Wait, but how to read lines interactively? Using a Reader. 

So, here's a possible structure:

const std = @import(\"std\"); 

export fn main() !void { 
    const stdin = std.io.getStdIo(); 
    var reader = stdin.reader(); 

    var line = std.ArrayList(u8).init(allocator); 

    while (true) { 
        const input = try reader.readUntilAlloc(allocator, '\
', 4096); 
        if (input.len == 0) break; 
        // process the line here 
        // ... 
        line.clear(); 
    } 

    // ... 
} 

Wait, but this code may not handle all cases. Also, after reading, we need to process the line. 

But perhaps using a loop with readline function. However, in Zig 0.14, the std.io.getStdIo().reader() can be used. 

Alternatively, using a loop with a std.io.BufferedReader. 

But maybe the simplest way is to read line by line using the reader.readUntilAlloc function. 

So, in the code, I'll read each line, then split into parts. 

Now, handling the commands. 

For /list: list the files in the current directory. 

For that, I can use std.fs.cwd() to get the current directory, then openDir. 

Then, iterate over the entries. 

But I need to handle errors. So, for example:

var dir = try current_dir.openDir(.{}); 
var iter = try dir.iterate(); 
while (try iter.next()) |entry| { 
    // process entry.name 
} 

But I have to handle all possible errors here. 

For /cat, I need to take the second part of the line. So, if the line is \"/cat filename\", then the second part is the filename. But what if there are multiple spaces? Like \"/cat  file name\"? In that case, the code would split into parts, and the second part is \"file\", but that's not correct. However, this code would not handle such cases correctly. But for simplicity, maybe we can assume that the filename is the rest of the line after the command. 

Alternatively, we can take the entire line after the command. For example, for /cat, the arguments are the rest of the line. 

But splitting into parts may not be the best approach. Maybe using the first token to determine the command, and then the rest of the line as arguments. 

So, for example:

if command == \"/list\" { 
    // list files 
} else if command == \"/cat\" { 
    if (parts.len < 2) { 
        print(\"Usage: /cat <filename>\
\", .{}); 
        continue; 
    } 
    const filename = parts[1]; 
    // read file 
} else if command == \"/quit\" { 
    return; 
} 

But again, this approach may not handle filenames with spaces correctly. However, for the scope of this example, it's acceptable. 

Now, putting all together. 

Also, need to handle the case where the line is empty, so we can just continue. 

Now, the code. 

But first, the error handling. For example, when opening a directory, if it fails, we should print an error message. 

Similarly, when reading a file, if it fails, print an error message. 

Now, the code. 

But wait, in Zig, the main function returns a !void, so we need to handle any errors. 

Putting it all together, here's the code example. 

I'll also include the necessary error handling. 

Testing for /list, /cat, /quit commands. 

Now, I think this should work. Let me write the code.
</think>

Here's a Zig 0.14 compliant example of an interactive chat program that handles `/list`, `/cat`, and `/quit` commands:  


const std = @import(\"std\");  

export fn main() !void {  
    const stdin = std.io.getStdIo();  
    const reader = stdin.reader();  

    var line = std.ArrayList(u8).init(allocator);  

    while (true) {  
        const input = try reader.readUntilAlloc(allocator, '\
', 4096);  
        if (input.len == 0) break;  
        line.appendSlice(input);  
        line.append('\
');  

        const cmd = parseCommand(input);  
        switch (cmd) {  
            .List => {  
                if (std.fs.cwd().openDir(.{}, .{})) |dir| {  
                    var iter = dir.iterate();  
                    while (true) |entry| {  
                        if (entry.file_name.len == 0) continue;  
                        print(\"  {}\
\", .{entry.file_name});  
                        if (entry.file_name == \"README.md\") break : \"loop\";  
                    }  
                    iter.deinit();  
                } else |err| {  
                    print(\"Error listing directory: {s}\
\", .{@errorName(err)});  
                }  
            },  
            .Cat => {  
                if (input.len < 2) {  
                    print(\"Usage: /cat <filename>\
\", .{});  
                    continue;  
                }  
                const filename = input[input.find('/') + 1..];  
                if (std.fs.cwd().openFile(filename, .{})) |file| {  
                    var reader = file.reader();  
                    var buffer = std.ArrayList(u8).init(allocator);  
                    while (true) {  
                        const chunk = try reader.readAlloc(allocator, 4096);  
                        try buffer.appendSlice(chunk);  
                        if (chunk.len < 4099) break :\"\" buffer;  
                    }  
                    print(\"{s}\
\", .{buffer.join(\" \")});  
                    buffer.deinit();  
                } else |err| {  
                    print(\"Error reading file: {s}\
\", .{@errorName(err)});  
                }  
            },  
            .Quit => {  
                print(\"Goodbye!\
\", .{});  
                return;  
            },  
            .Unknown => {  
                print(\"Unknown command: {s}\
\", .{input});  
                continue;  
            }  
        }  
        line.clear();  
    }  
}  

const Command = enum {  
    List,  
    Cat,  
    Quit,  
    Unknown  
};  

fn parseCommand(input: []u8) Command {  
    if (input.len == 0) return .Unknown;  
    if (input[0] == '/') {  
        if (input == \"/list\") return .List;  
        if (input == \"/cat\") return .Cat;  
        if (input == \"/quit\") return .Quit;  
    }  
    return .Unknown;  
}  


### Key Features:  
- **Interactive Input**: Uses `std.io.getStdIo().reader()` to read lines from standard input.  
- **Command Parsing**: Recognizes `/list`, `/cat`, `/quit`, and other unknown commands.  
- **File System Interaction**: Lists files in the current directory and reads files using `std.fs.cwd()`.  
- **Error Handling**: Properly handles file and directory operations with error sets.  

This example demonstrates the core functionality required for an interactive chat bot with Zig 0.14. You can extend it further by adding more commands or improving error handling.
```

Okay, but does that code at least compile? Unfortunately not:

```bash
❯ zig build
install
└─ install foo
   └─ zig build-lib foo Debug native 1 errors
error: unable to load 'src/root.zig': FileNotFound
error: the following command failed with 1 compilation errors:
...
install
└─ install foo
   └─ zig build-exe foo Debug native 3 errors
src/main.zig:7:39: error: use of undeclared identifier 'allocator'
    var line = std.ArrayList(u8).init(allocator);
                                      ^~~~~~~~~
src/main.zig:73:19: error: cannot compare strings with ==
        if (input == "/list") return .List;
            ~~~~~~^~~~~~~~~~
/home/akitaonrails/.local/share/mise/installs/zig/0.14.0/lib/std/start.zig:643:46: error: 'main' is not marked 'pub'
    const ReturnType = @typeInfo(@TypeOf(root.main)).@"fn".return_type.?;
                                         ~~~~^~~~~
src/main.zig:3:8: note: declared here
export fn main() !void {
~~~~~~~^~~~~~~~~~~~~~~
/home/akitaonrails/.local/share/mise/installs/zig/0.14.0/lib/std/start.zig:616:20: note: called from here
    return callMain();
           ~~~~~~~~^~
/home/akitaonrails/.local/share/mise/installs/zig/0.14.0/lib/std/start.zig:571:36: note: called from here
    std.posix.exit(callMainWithArgs(argc, argv, envp));
                   ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~
error: the following command failed with 3 compilation errors:
```

At least I don't think it's my LoRA that broke it: it already couldn't write Zig code that compiled before. This Qwen3 model only has 8B parameters, don't forget. It's much weaker. My LoRA didn't make it worse, it's the same crappy code as before, but at least we have evidence that the training changed the responses more or less like we wanted.

Some things from the training, we can see it did manage to access. This new knowledge **doesn't take up space in the context, unlike a RAG or prompt** and that was the proof of concept: I trained it, managed to load it, got to access that information and, even with a weaker base (8B) and even with a limited context window (8k tokens), it still seems to be working "okay-ish", so it's a **semi-success**.

I'd need to test training on a bigger model (14B) with more code examples (like those 15MB of its STD source code) and on a bigger GPU with more VRAM (like an A40 or H100).

### Conclusion: Semi-Success?

I decided to publish this post before actually finishing all my test attempts. As you could see, some responses already came with the model answering Zig 0.14.0 stuff. But I still couldn't get good code out of just that. I don't know if it's because the 8B model is too weak for this. Or if my training material could be better formatted. Or if I really was missing making more descriptive and specialized prompts. Or if there are parameters I have to tune (more epochs? higher learning rate? something else?). Anyway, there are MANY possibilities to explore and research.

The goal of this post was more to show in practice how LLM models are TAMPERED WITH post-training, via fine-tuning. You've "heard" that it could have this. I'm proving that it really does and that you yourself can do it at home. You saw how it can already answer "I know Zig 0.14" but in practice not necessarily. LLMs do that: they're tuned to give convincing answers. Knowing that this happens, you can be more critical and understand _"ah, that's alignment, but it actually doesn't know that much."_ That's the point.

This is also the importance of having open source, open models, because the community can create new trainings on top to remove these alignments, force new alignments (that's why a single model can have so many different versions). For example, on Hugging Face itself there's a whole category of [LLMs (Uncensored)](https://huggingface.co/collections/Umbra-AI/llms-uncensored-6531951e548eae0c99f4a534)

![Uncensored](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/mom2pmui347tgdwzinkz8kq9wonp)

The most dedicated user is [TheBloke](https://huggingface.co/TheBloke), follow him to see which LLM he recently unlocked. On his profile there are models like this [CodeLlama-70B-Python-GPTQ](https://huggingface.co/TheBloke/CodeLlama-70B-Python-GPTQ) which, theoretically, was post-trained to be stronger in Python code. And with this post now you have more of an idea of HOW it's done.

This can have many applications. If you're a researcher, maybe you can take it from here as motivation to go deeper where I still haven't gone deeper. Maybe doing specific programming training is harder, maybe you'll discover the trick I still haven't seen. But for prose texts it tends to be better. If your company has a private knowledge base, maybe it makes sense to create a private LoRA that runs on your infra. Anyway, the possibilities are endless.

Whoever figures out the best way to organize this training could create even better programming LoRAs, for Python 3.13, for Elixir 1.18, or for Go 1.24, all newer versions that, at the 2023 cut-offs of commercial LLMs, won't be there.

Why is the data so old? 2023 is already 2 years ago. Because it's hard to clean petabytes of data. If I already struggled to clean 900 kilobytes, imagine PETABYTES. It's not just throwing any data in any way and expecting the model to MAGICALLY learn everything. No: you have to organize, structure, clean this training data. The better that work, the better the chances of the model getting a little better.

It's hundreds of man-hours of manual work, scripts and much more to do this. It makes sense to have a gap of more than 1 year, because then it still takes MONTHS to process all of that using a datacenter of multiple H200s in parallel. A mere 900kb with an 8B parameter model already costs more than 1 hour of my poor 4090. Imagine petabytes paired with a 1 TRILLION parameter model. It's A LOT of processing.

And that's it, everything I wrote in my post was a single day's research, so if someone dedicates more than that, they should get even better results. It's worth studying.
