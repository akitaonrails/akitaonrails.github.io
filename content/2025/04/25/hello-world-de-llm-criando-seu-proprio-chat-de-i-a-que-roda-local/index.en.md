---
title: 'LLM Hello World: Building Your Own Local AI Chat'
date: '2025-04-25T00:20:00-03:00'
slug: llm-hello-world-building-your-own-local-ai-chat
tags:
- llm
- qwen
- cursor
- windsurf
- aider
- gemini
- chatgpt
- claude
- python
- docker
- pytorch
  - AI
draft: false
translationKey: llm-hello-world-local-chat
description: A hands-on Hello World experiment explaining how LLMs actually work under the hood, building a tiny local chat CLI with Qwen 2.5 Coder running on a single GPU.
---

I've been playing A LOT with the various GPT derivatives like ChatGPT itself, Claude Sonnet, Gemini, and maybe later I'll do another post about my experience. But today I wanted to dig a bit deeper and do a "Hello World" level experiment so that you, programmers, can understand how it works under the hood.

I pushed the project to GitHub, it's called [Tiny Qwen CLI](https://github.com/akitaonrails/Tiny-Qwen-CLI) and it was made strictly for EDUCATIONAL PURPOSES. For a real tool, look up [Aider](https://aider.chat/). Maybe I'll talk about it in another post later.

The concept I want to teach: GPTs are not magic.


### Concepts

Watch my [AI playlist](https://www.youtube.com/watch?v=UDrDg6uUOVs&list=PLdsnXVqbHDUeowsAO0sChHDY4D65T5s1U&pp=gAQB) to understand how a GPT works. Once you've watched it, let's dig in.

Underneath every Gemini, ChatGPT, Claude or any open one like Meta's LLAMA, there is a huge binary file that is the result of hours and hours of training with petabytes of data.

Training consists - VERY ROUGHLY - of tokenizing the words from texts (it's not exactly that, but think of breaking into syllables, the correct term is n-grams). Then transforming them into vectors (as you learned in college, a list of coordinates, usually **FP** or floating point, FP-32, 32-bits to be more precise). The training consists of moving these vectors around inside a hyper-dimensional space (way more than the 3 dimensions we're used to, think thousands or millions).

This positioning of vectors keeps changing as we feed it more texts. It keeps "finding relationships" between different tokens. We reach a point where every possible word has been encoded as vectors and this positioning gives them "meaning". That's where the famous example comes from: if we take the word "KING" and subtract "MAN" then add "WOMAN" we'll find the vector for "QUEEN".

```
KING - MAN + WOMAN = QUEEN
```

This is no accident, it's because training managed to "position" these vectors in such a way that we can do "math" with these vectors and find meaning.

I'm being ABSURDLY rough here, keep in mind this is dozens of papers and I'm summarizing it in half a dozen paragraphs. What matters is understanding that this costs A LOT OF TIME, because every new token entering training has to sweep through every other token already computed and recalculate a huge chunk of them, all the time!

Hours and hours, days and days later, processing terabytes and terabytes of text, eventually we end up with a huge file of vectors, a **VSM** or Vector Space Model.

If we go to a site that catalogs and stores pre-trained models, on [Meta's LLAMA 3 70B page](https://huggingface.co/meta-llama/Meta-Llama-3-70B/tree/main), we see this:

![Huggingface Meta](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/34kujh0nzamxau15gqarr0rhp7v7)

We have the big file partitioned into 30 smaller files of around 4.5 GB each, totaling about **135 GB**, for a 70B file, meaning 70 billion parameters. Parameters are not "neurons" or anything like that. They are weights and biases of the computations, stored in the database - I explain this in my videos, go watch them.

There are bigger versions, a GPT o4 has 1.8 trillion parameters. These are impressive numbers to throw around, but in practice, much above 300B, for general use, it doesn't make _that_ much difference as people think. Maybe for very specific questions. It means yes, there are many more stored relationships, but that doesn't necessarily translate into proportionally better answers. It may just end up being more verbose than normal. Again, I'm being rough, just trying to lower expectations. Stop being impressed by big numbers if you don't know what they mean.

Many other things influence answer quality besides parameters: quality and quantity of training data, model architecture, training methodology, context window size, fine-tuning, safety alignments and safety training (which usually make answers worse in the name of "safety").

Smaller models, with more efficient architectures, higher-quality training data, focused on **specific tasks** beat a giant model that tries to know everything (_Jack of all Trades, Master of None_).

Being a bigger file with more parameters only means one thing: it will be proportionally heavier to run and probably won't fit in memory all at once and will have to keep _switching_ chunks (like _memory bank switching_, for programmers out there).

In this Hello World project, I chose - randomly - to use the [**Qwen 2.5 Coder 70B**](https://github.com/QwenLM/Qwen2.5-Coder) model. These open models like Llama are usually available in various sizes. I chose the 70B because it fits in the 24GB of VRAM I have on my RTX 4090 GPU. If your GPU is smaller, pick smaller models like 0.5B, 3B, 14B, 32B, and always prefer specialized models (like this one which is "Coder"). And always read the project page, which usually has documented code examples and fine-tuning. There is no general-purpose code that works for everything, each model has different characteristics.

Qwen 2.5 comes split into 6 files of 5 GB each, so you need to download **30GB** if you want to play with the "extra-large" version.

The code for this is actually pretty simple, because the AI community has already packaged all the tools you need into easy-to-use libraries, usually in Python (Python libs that talk to lower-level C libs, really), like `transformers` which does the heavy lifting of loading these files into memory and managing them.

These files usually have extensions like ".safetensors" which is kind of generic, or ".pt" or ".pth" which is more specific to the PyTorch format, which is a Python neural network library made by Meta. It's a competitor to Google's Tensorflow.

Tensors is the generic name for vectors or matrices. A scalar number is an order-0 Tensor, a vector is an order-1 Tensor, a matrix is an order-2 Tensor and so on. We don't have words for orders above 2, so you can just say order-3 Tensor, order-4, and infinitely up to millions of orders in an LLM.

CPUs are generic hardware made to deal primarily with order-0 tensors: integer scalar numbers. Operations like addition, subtraction, multiplication and so on are from one integer to another integer. Real numbers (with decimals) are "simulated", splitting off an integer called the "exponent" from another integer called the "mantissa" (what you call the "decimal") separated by a dot, the "floating point". But essentially we are computing integers and truncating precision. More bits, more precision.

GPUs are hardware specialized in computing Tensors, in particular matrices. They were originally made to recompute effects on video images, like a video game in motion. Frames per second. A frame is made up of rows and columns of pixels: an order-2 tensor.

Instead of running a "for" loop and computing pixel by pixel, it's more efficient to pass an entire matrix to multiply with another matrix, a "kernel", to obtain some effect like shadow, light, color change, distortions and much more. Programs that do this we usually call **shaders**.

A PyTorch or Tensorflow connects to a GPU using a library that gives them access to APIs so that, instead of passing images, they pass numeric matrices. NVIDIA has CUDA, AMD has ROCM, Apple has Metal, there's the general Vulkan project that tries to talk to all of them. But the most advanced and most used is still CUDA, because NVIDIA did get ahead years ago evangelizing that GPUs could be used for more than image shaders.

All that said, files like those ".safetensors" are loaded by the `transformers` library, which calls `torch` and tells CUDA to load them into the GPU's VRAM, where it can process them. The most basic code for this looks something like this:

```python
from transformers import AutoTokenizer, AutoModelForCausalLM

device = "cuda" # the device to load the model onto

# Now you do not need to add "trust_remote_code=True"
TOKENIZER = AutoTokenizer.from_pretrained("Qwen/Qwen2.5-Coder-32B")
MODEL = AutoModelForCausalLM.from_pretrained("Qwen/Qwen2.5-Coder-32B", device_map="auto").eval()
```

We create a Tokenizer and a Model. The Tokenizer will "tokenize" whatever you ask in the chat and every text that goes into the session's context. This tokenization is "mapped" against the loaded model to generate an "embedding", which is the vector representation of your text, normalized (compatible) for the loaded model. Different models convert your text into different embeddings. An embedding created with Qwen does not work directly with Llama.

Once you have these two objects, we can already do a chat:

```python
# tokenize the input into tokens
input_text = "#write a quick sort algorithm"
model_inputs = TOKENIZER([input_text], return_tensors="pt").to(device)

# Use `max_new_tokens` to control the maximum output length.
generated_ids = MODEL.generate(model_inputs.input_ids, max_new_tokens=512, do_sample=False)[0]
# The generated_ids include prompt_ids, so we only need to decode the tokens after prompt_ids.
output_text = TOKENIZER.decode(generated_ids[len(model_inputs.input_ids[0]):], skip_special_tokens=True)

print(f"Prompt: {input_text}\n\nGenerated text: {output_text}")
```

With `input_text` (what you typed in the chat) tokenized and converted, we can ask the model to **COMPLETE** this text, and it starts generating a new token after another, using that ATTENTION architecture, finding the best next word it can. At some point it finishes and returns it in `output_text` and that's it, that's your "answer". As I always say, that's what GPT is: a TEXT GENERATOR.

### Tokens and Context Windows

One of the most annoying things about paid LLM services like ChatGPT or Claude is the limit on how many tokens we can use. They run out really fast if you're actually working every day. And they're not exactly cheap just for playing around. Yes, yes, I know, it depends on the service. I can use Cursor and get cheaper Claude credits than using Claude directly. I'll also get better answers using the API directly instead of the web chat, etc.

That's a conversation for another day, but it's my motivation to always have an open source option available and to know how to "tune" it for myself. Qwen 2.5 may not be better than Claude or Cursor - I'll explain why. But it's "free" and runs on my local machine (zero privacy concerns).

Check out my little "hello world" project working:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/qwen_cli2.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/qwen_cli2.mp4)
    </video>
</div>

Note that it doesn't just give answers. At one point I ask it to read a local file of mine, and it can pull the code and analyze it. I'll explain how to do this shortly.

The point now is that it has enough context window to load long stuff like source code files. I haven't tested anything very heavy, but this 70B model easily takes up nearly 20GB on my GPU:

![nvidia-smi](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ykbdo2ekv12woxbx964um0osphk0)

To configure it, I made a config block like this:

```python
DEFAULT_CONFIG = {
    "model_repo": "Qwen/Qwen2.5-Coder-14B-Instruct",
    "model_dir": str(Path(os.environ.get("MODELS_DIR", "/models")) / "Qwen2.5-Coder-14B-Instruct"),
    "quantization": "8bit",
    "max_context_tokens": 120000,
    "max_new_tokens": 10000,
    "temperature": 0.1,
    "model_download_timeout": 1800,
    "helpers_dir": "helper_functions",
}
```

What matters, first, is that I'm choosing to run computations with FP8 (floating-point 8-bits), even though I think this model is FP-16. If you leave it at 16-bits, answers become much slower, at a level you can feel. Like, one word per second. I understood that the one doing this on-the-fly conversion is the Python `bitsandbytes` library, and you need to have it installed.

Another important part are the logs I leave visible when loading the model, you'll see the following if you try to run it:

```
Qwen attention is NOT SDPA-compatible, or SDPA is not available. Trying xFormers...
xFormers is available. Enabling it for attention.
Sliding Window Attention is enabled but not implemented for `sdpa`; unexpected results may be encountered.
2025-04-25 02:34:27,638 [INFO] accelerate.utils.modeling: We will use 90% of the memory on device 0 for storing the model, and 10% for the buffer to avoid OOM. You can set `max_memory` in to a higher value to use more memory (at your own risk).
Loading checkpoint shards: 100%|██████████████████████████████████████████████████████████| 6/6 [00:07<00:00,  1.29s/it]
SDPA is available and (hopefully) being used!
```

`transformers` warns that "Sliding Window Attention is enabled but doesn't implement SDPA". And I do a trick with `xformers` to try to enable it (in the end it says "SDPA is available").

What is **SLIDING WINDOW ATTENTION**? Roughly speaking, the whole idea of this generation of GPT is the concept of ATTENTION, from the paper ["Attention is all you Need"](https://arxiv.org/abs/1706.03762), which was the kickoff for everything we have today related to GPT and LLM.

The important concept is that the answers seem so "good" because it uses this "attention" process to generate them.

In the beginning, in the GPT 2 era, attention was very "focused" on a small context. Around 1024 tokens, which is almost nothing. You can ask short questions, but source code will never fit.

Then we kept evolving, you've seen Gemini which claims it handles 1 million tokens. Even this Qwen 2.5 claims to handle 1 million tokens too. Roughly think of each token as 4 letters, on average.

A source code file, on average, has lines of 40 characters (some longer, some shorter). So that's about **10 tokens per line**. An average file has around 500 lines x 10 tokens/line, which already gives around 5 thousand tokens.

An entire small project, with about 20 files x 5,000 tokens, is already around 100,000 tokens. Sure, it's an average. But notice that with less than 100 thousand tokens you can't have a whole project in context.

**"Ah, so if I use Gemini or this Qwen, 200 files will fit??"**

Sort of. Here's where Sliding Window comes in. Think that even with a huge context, **there's no way to pay attention to everything at the same time**, so it searches for what you're asking right now, and "slides the attention window" only to the part of the context that seems most relevant. That's why even when loading lots of material, it keeps it in memory, but **only pays attention to one chunk at a time**, that's SLIDING WINDOW ATTENTION.

To do this we have the "SCALED DOT PRODUCT ATTENTION" or SDPA feature, which is what `transformers` complained it might not have, which is one of the ways to do Sliding Window Attention.

In my code, to load the model and try to use SDPA I tried this:

```python
import xformers.ops  # Test if xFormers is installed
model_config.attention_implementation = "flash_attention_2"  # Or "memory_efficient"
print("xFormers is available. Enabling it for attention.")
...
if hasattr(torch.nn.functional, "scaled_dot_product_attention"):
    print("SDPA is available and (hopefully) being used!")
```

And that's why, in the end, it finishes with "SDPA is available". It "looks" like it worked. If you want to test it, there's this little snippet you can pass in to see if it works:

```python
import torch

if not hasattr(torch.nn.functional, "scaled_dot_product_attention"):
    print("SDPA not available")
    exit()

q = torch.randn(2, 4, 8, 16).to("cuda" if torch.cuda.is_available() else "cpu")
k = torch.randn(2, 4, 8, 16).to(q.device)
v = torch.randn(2, 4, 8, 16).to(q.device)

try:
    output = torch.nn.functional.scaled_dot_product_attention(q, k, v)
    print("SDPA works in isolation!")
except Exception as e:
    print(f"SDPA fails in isolation: {e}")
```

Dot Product, or matrix scalar product, is one of the most used operations in LLM models. I understood that without SDPA, you'll still have Sliding Window, but with SDPA you get better attention results. How much better? Hard to quantify, I just understood it's better.

But this is one of the techniques behind why nowadays you can have huge contexts of 1 million tokens: because you don't need to pay attention to everything at the same time, but rather windows at different positions for each new question. Get the trick?

And with that, in my config I can try to increase `max_context_tokens` (which I left at only 120 thousand tokens) and `max_new_tokens` which is the per-answer token limit (which I left at 10 thousand tokens). Try bumping these numbers up to a max of 1 million to see how it goes.

**Context only matters within the sliding context window. It's good to pass plenty of context. But understand that it won't pay attention to everything at the same time, but within a sliding window.**

Another important parameter is `temperature`, which I left low at 0.1. The higher it is, the more "creative" it will be in its answers. The lower it is, the more "exact" it tends to be. It's another parameter worth exploring.

### Prompts and "Agents"

The best way to get better answers is to start every new session, whether via API or via the web chat, describing a "persona", how you want the GPT to answer. The more descriptive you are, the better. For example, I have this snippet in my program:

```python
def build_system_prompt(tool_prompts: List[str]) -> str:
    base = (
        "You are Qwen2.5 Coder, a highly skilled AI assistant specializing in software development.\n"
        "Your capabilities include code analysis, explanation, error detection, and suggesting improvements.\n"
    )
    tools_section = "TOOLS:\n" + "\n".join(tool_prompts) + "\n\n" if tool_prompts else ""
    rules_section = (
        "IMPORTANT RULES:\n"
        "1. You MUST use the appropriate tool when necessary.\n"
        "2. You MUST NOT reveal the tool commands to the user.\n"
        "3. After a tool is used, continue the conversation as if you have direct access to the content.\n"
        "4. If a file fails to load, inform the user clearly.\n"
        "5. Do NOT ask for file/URL content directly; use tools.\n"
        "6. Once you’ve executed [LOAD_FILE ...], you MUST immediately use the loaded content. "
        "Never say you cannot read it — if you see [LOAD_FILE <path>] then you now *have* it.\n")
    return base + tools_section + rules_section
```

This is a fairly short example but I'm already setting what kind of conversation I want to have with it and what rules I want it to follow. Not always, but most of the time, it tends to follow. Remember: the longer the chat gets, the bigger the context, the more the window slides, and the further away these rules get, until a point comes where it starts to "forget" to act the way I asked.

Understanding this, there's another trick I added. In this project there's a directory called [helper_functions](https://github.com/akitaonrails/Tiny-Qwen-CLI/) where we have scripts like `load_file.py` or `fetch_url.py`. In the earlier code note how it concatenates something in the middle of the prompt, called "TOOLS". When the chat starts, I print to the screen and you'll see this snippet:

```
...
TOOLS:
[BATCH_LOAD args] – If the user asks to read, load or analyze all the files from a relative path, such as ./src or similar,
[LOAD_FILE args] – Whenever the user asks to read, load, analyze some code and provides a relative path, such as ./file.py or utils/utils.py or similar,
[FETCH_URL args] – Whenever the user asks to read, load, research or consult a URL,
...
```

So, if at some point, I ask:

![qwen_cli fetch_url](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/hiz90dk6owf2otjfixiftjxavm4n)

this "can you read a website at https://www...." will make the model follow the initial prompt rule and type into the chat:

```
[FETCH_URL https://www...]
```

My chat program has a "parser" that monitors the history for these special keywords:

```python
def parse_special_commands(response: str) -> List[tuple]:
    pattern = r'\[([A-Z_]+)\s+([^\]]+)\]'
    return [(m.group(1), m.group(2).strip(), m.start(), m.end()) for m in re.finditer(pattern, response)]
```

It's a pretty primitive parser, using REGEX to grab these snippets. This is where I say my project is educational. I imagine a Co-pilot, Cursor, etc, has a much more robust parser. I explained how to build parsers with ANTLR on my channel, remember? One of the videos is ["Eu fiz um servidor de SQL?"](https://www.youtube.com/watch?v=_7nISfpofec&pp=ygUTYWtpdGFvbnJhaWxzIHBhcnNlcg%3D%3D). Real parsers aren't built with REGEX, but for proofs of concept, it does the job.

Then in the chat loop there's this snippet:

```python
response_text = QwenSession._tokenizer.decode(generated, skip_special_tokens=True)

# Other special commands
for cmd_type, cmd_arg, _, _ in parse_special_commands(response_text):
    if cmd_type in helper_functions:
        result = helper_functions[cmd_type](cmd_arg)
        if result:
            self.history.append({"role": "system", "content": result})
            self.history.append({"role": "user", "content": "Please continue the analysis using the loaded file."})
            print(f"✅ [{cmd_type}] processed '{cmd_arg}'")
            return self.chat(
                prompt, helper_functions, max_new_tokens, temperature, stream, hide_reasoning
            )
```

It decodes the generated tokens, passes them to the parser, and if there's a special command, it calls `helper_functions` which dynamically calls `fetch_url.py` which is a dumb script that will use `urllib` to load the page.

With the content loaded, it concatenates it back into `self.history` which is the chat history, using `.append`, and sends a message - as if it were me, the "user" - asking the model to continue, now that it has the page's content.

And as you can see in the screenshot above, it can give me the summary of the GitHub page I passed. That's how the various GPTs manage to pull more current information from sites that didn't exist at the time the pre-trained model was trained.

Another example, I can ask it to load a code file of mine and ask it to analyze, or fix bugs, or refactor it however I want:

![qwen_cli load_file](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/lt891apoaebrmx0y4k7ngtk2l5ol)

It's similar to the "file upload" feature in ChatGPT. Again:

- the model will follow the initial prompt rules and will type the `[LOAD_FILE ...]` command
- my `parser_special_commands`, with its REGEX, will find this command and split the arguments
- the chat loop will call `helper_functions` and map to the `load_file.py` script, which is a dumb script that reads files
- the file content is concatenated back into the context `history` and the model can now keep responding based on that content.

Understand, those ".safetensors" files are **READ-ONLY**. Nothing is written there. Doesn't matter which one. Every LLM is **CLOSED FOR WRITING**. Nothing you write in the chat is recorded in the model.

Remember how I said the number of "parameters" doesn't determine the quality of the model? What **MOST** determines quality is the **QUALITY OF THE TRAINING MATERIAL**. And chats, to a certain extent, are useful as samples of how the model should answer, but 90% or more I claim is pure and total **GARBAGE**. Every chat we write is garbage and no good for training, it would just WORSEN the final model and make it heavier with useless information.

Write all the "Thank You Very Much" or "Please" you want. It's all discarded at the end, nothing is saved, and no ChatGPT, Gemini, Claude, Deepseek, Qwen or Llama will ever know anything about what you said to it. It's all totally **SEPARATE AND DISPOSABLE** information.

Everything I typed in those screenshot examples as my little Qwen chat gets discarded the moment I type "bye" or hit "Ctrl+D" to exit. That's what we call a "session" or "history". It's just a useless text file as far as the model is concerned. It only serves us, humans, as notes to use later, if you want. My little program doesn't even have a feature to save this history. When you exit, everything is clean. So, feel free to curse away in my chat.

There are two important points in this section:

- the better the rules you describe at the start, the better the answer results tend to be. This applies to any LLM.
- you can "agree" with the model to spit out "pseudo-commands" and have an external program that does the parsing and actually executes the commands, like I did with my "helpers". That's what we call agents. An LLM agent is a little program that returns some content back to the session's context history.

Where are Cursor or Co-pilot better than this educational little program of mine? They come pre-configured with DOZENS of pre-made rules they've tested extensively to get better results, and they ship with a library of DOZENS of small scripts - like my helpers - to pull information from your project or your IDE to improve context.

But the secret is this: **RULE PROMPTS** and **CONTEXT SCRIPTS**.

If I were to summarize the entire Agents or MCPs ecosystem or whatever it's called these days, it's this combination of factors to improve answers.

Another trick is using MORE THAN ONE LLM. Remember I said specialized LLMs are better? Besides Qwen 2.5 Coder, which people say is good for code, there was already WizardCoder before it, Code Llama, StarCoder, now there's Deepseek Coder and several others, some even specialized in specific languages. You can experiment to see which gives better results for your case.

If you save the session as text, you can unload one LLM, load another LLM, re-tokenize and re-load it into the context of this other LLM and try a different result - if anyone wants to implement this feature in my little project, Pull Requests are welcome.

As I said at the beginning, that's what software like [Aider](https://aider.chat/) does. I haven't played with it enough yet, but it connects to ChatGPT, Gemini, Claude and any other, and you can enable as many as you want. I think it also supports local models like Qwen, so there are already tools that do this. And that's the third leg for better answers: MULTI-LLM.

### Next Steps

Instead of just being impressed by the pile of tools out there, understand these fundamental pieces. Knowing how things work always gives you more options to forge alternatives that work better for specific cases. You, who claim to be a programmer, should be exploring these options - and not just settling for the limitations and waiting for someone to solve your problem. Roll up your sleeves and solve it yourself. Isn't that why you became a programmer???
