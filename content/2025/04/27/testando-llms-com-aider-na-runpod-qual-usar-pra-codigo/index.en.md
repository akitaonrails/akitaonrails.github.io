---
title: Testing LLMs with Aider on RunPod - which one to use for code?
date: '2025-04-27T11:30:00-03:00'
slug: testing-llms-with-aider-on-runpod-which-to-use-for-code
tags:
- runpod
- aider
- gemini
- qwen
- deepseek
- ollama
- llm
draft: false
translationKey: aider-runpod-which-llm-for-code
description: Hands-on testing of Qwen2.5 Coder, DeepSeek, Codestral and others with Aider, locally on an RTX 4090 and on RunPod, comparing them against Claude and Gemini.
---

Following my post [about Aider](https://www.akitaonrails.com/2025/04/25/seu-proprio-co-pilot-gratuito-universal-que-funciona-local-aider-ollama-qwen), and now that you understand how LLMs work for code, I decided to try running some models on my own machine.


The setup is very simple. With Aider and Ollama installed, first we have to start ollama (I start it manually; you can create a systemd service to start it automatically):

```
OLLAMA_FLASH_ATTENTION=1 ollama serve
```

For both Aider and the Ollama client to see the server, it's good to put this in your `.bashrc` or the equivalent on your OS:

```
export OLLAMA_HOST=http://localhost:11434
export OLLAMA_API_BASE=http://localhost:11434
``` 

**WARNING:** it took me a while to figure out why Aider was failing sometimes, and it was because I wasn't paying attention and would sometimes leave a trailing "/" at the end of that URL. It can't end in "/", drop it, otherwise it will blow up when it tries to build the URL.

The only option I experimented with (there are many, check the docs) was forcing Flash Attention on (remember what I explained about Sliding Window Attention?). I don't know if it really makes a difference and not every model supports it, but let's go. With the server up, we can download some models:

```
ollama pull qwen2.5-coder:14b
```

With that done, from inside any code project directory, we can fire up Aider to watch for file saves (then it loads them into the chat context, looks for a comment with "AI!" and sends it to the model so it can do what was requested):

```
aider --watch-files --model ollama_chat/qwen2.5-coder:32b --verbos
```

The `--verbose` option is optional, but at the beginning it's good to leave it on. You can see exactly which prompts Aider is sending. Different models react a bit differently to different prompts. Pay attention to this: the same question can get very different answers on different models. AI does not give absolute answers, it gives "an" answer. And it's not always right; actually, **many** times it's wrong. Get used to it, it's a text generator with an entropy component: it will **NEVER be "100% correct, 100% of the time"**, that's a limitation of the whole architecture, no matter how much optimization you throw at it.

### Macs for LLMs?

Anyway, my machine has a Ryzen 9 7940X3D with an RTX 4090 with 24GB of VRAM. I thought _"Hmm, will it run the 32B parameter Qwen?"_ and went to test it. On my first test I got this behavior:

![CPU high GPU low](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/f0n8smr6ltbbb3mrmbm3lhkspt06)

I scratched my head over this: my CPU was constantly at 50% the whole time, but the GPU was idle most of the time with small short spikes around 20%. It should have been the opposite. After much research and testing, my conclusion was this:

```
OLLAMA_FLASH_ATTENTION=1 OLLAMA_CONTEXT_LENGTH=8192 OLLAMA_KV_CACHE_TYPE=f16 OLAMA_NUM_THREADS=25 OLLAMA_NUM_GPU=60 ollama serve
```

First, I tried several Ollama configurations. One of them, `OLLAMA_RUN_GPU`, tries to limit how many model layers get offloaded to VRAM. It's more of a suggestion than an absolute number. The 32B Qwen model has 65 layers. The maximum I managed to load was about 48 layers, tweaking that parameter. That pushed VRAM consumption in the screenshot from 17GB to 21GB.

Even then the CPU was still heavy. And the answer comes when we look at the model details with the `ollama show qwen2.5-coder:32b` command:

```
❯ ollama show qwen2.5-coder:32b
  Model
    architecture        qwen2
    parameters          32.8B
    context length      32768
    embedding length    5120
    quantization        Q4_K_M
```

It supports a maximum of 32,768 context tokens. But in my `~/.aider.model.settings.yml` I had left it too big:

```
- name: ollama_chat/qwen2.5-coder:32b
  extra_params:
    num_ctx: 65576
```

That whole size works fine for models like Deepseek, but Qwen caps out at 32k. But there's a catch: you need spare VRAM for that. In short:

- DEFAULT_NUM_CTX=24576 is estimated at 32GB of VRAM.
- DEFAULT_NUM_CTX=12288 is estimated at 26GB of VRAM.
- DEFAULT_NUM_CTX=6144 is estimated at 24GB of VRAM.

To run the full 32k tokens of context window, you need a GPU with around 40GB, and that doesn't exist in the consumer NVIDIA world. Whether it's my 4090 or the new 5090, which are top of the line, they're capped at 24GB. For those who didn't know, memory is the most expensive component of all. And don't think of the DDR4 or DDR5 stick you have in your PC: they are **SLOW**. We're talking GDDR6 or LPDDR6, much faster memory with much lower latencies that your PC doesn't support.

So the most I could cram into my 4090 was 8192, 8k tokens. That's a very small window. Any small code file with 400 lines already consumes around 4k tokens on average. So you can barely fit 2 files in the context. Without counting prompts, without counting the details of what you want to ask. It's very little context.

So I thought. In the consumer world there's only one alternative: Mac Mini.

![Mac Mini](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/wv52d20e5niksk9aeyw7nv684yzt)

A Mac Mini has up to 64GB of RAM. And Apple has an advantage: yes, it's expensive, but it is because it really does use more expensive components. The memory comes soldered on, and many people complain, but relax: you wouldn't be able to upgrade it anyway, because there are no memory sticks at the speed of Mac memory: they're the same type of memory chip as a GPU!!

And it's all soldered very close to the CPU and GPU, because slots are slow and physically farther away. With latencies that low, a few extra millimeters make a difference. There is no other alternative: **IT HAS TO BE SOLDERED**.

The advantage of this is that the same memory is **UNIFIED** and can be used by both the CPU and the GPU. The operating system can dynamically allocate memory to one or the other. So, within those 64GB of RAM, you could allocate the 40GB you'd need to offload all 65 layers of Qwen2.5 and still have room for the maximum 32k token context window.

If you get a Mac Studio you can go up to 512GB. So yes, it makes sense to use Macs for running LLMs. Especially when you consider that the other alternatives outside of consumer, in the more professional workstation world, include things like the RTX 6000 (a GPU made for 3D, CAD, and without gaming features). It can go up to 96GB but at a steep cost of USD 7 thousand! More expensive than an entire Mac Studio.

And what about the Ryzen AI Max with an integrated iGPU sharing memory? Forget it. For light models it's enough (but then you don't really need that much vram anyway), for large models the unified memory is at most DDR5: it's slow. It's a slow iGPU. That doesn't mean it's useless, just that for the type of test I wanted, it wasn't going to work. Keep reading to find out why.

So am I going to buy a Mac Studio? No, I don't need to. I don't plan on heavy daily use, just occasional playing around. And for that it's better to **RENT**. Besides, just because you have an expensive machine doesn't mean everything will automatically be fast. Spoiler: it won't.

### RunPod

I've already mentioned RunPod in some articles and posts on X because I always hear about it in LLM tutorial videos on YouTube. It really is super simple and relatively cheap. Let's summarize:

![Storage RunPod](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/lpcff2b5hh9dg9gw4aqo8drfrc6g)

The first thing is to spin up a "Network Volume", network-attached storage (like my NAS). Because we're going to have to download heavy models (over 15GB, 20GB average) and if I need to recreate machines (pods/Docker containers, actually), I don't want to have to redo downloads all the time. USD 7 per month for 100 GB is expensive, but I can live with it.

If you have no idea, a 4TB NVME from Samsung (the most popular one, not the best, not the worst) costs around USD 250. For 4 TERABYTES, that's 16 cents per gigabyte. Renting costs 14 cents per gigabyte PER MONTH! That's why, if possible, it's always better to run things locally rather than rent, if you know you'll use them for months. In my case, since I'm just going to test and then delete, it's fine. At that point it's the cost of convenience (testing today instead of risking buying a Mac Studio and waiting for it to arrive only to find out it makes no difference).

Another tip. RunPod already has several templates, which are basically Docker images. For Ollama it has these:

![runpod templates](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/3s9d3fkcqaq03wtbdvubziucy5dn)

I think any of these should do, but to test I decided to create my own template from scratch, using the official "ollama/ollama:latest" image as a base:

![ollama template](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/y146j9i22ud0q8z0muv3rpasvyro)

The `OLLAMA_MODELS` environment variable is how I tell ollama to look for models on the network volume I created earlier, so when I tear down the container the models will persist. Anyone who has deployed containers understands the concept of mapped volumes, that's exactly it.

One detail: what RunPod calls "pods" are nothing more than mere Docker containers with the "--gpus" option to access the GPUs underneath. But the physical machine underneath, the server, has no more than half a dozen GPUs. While your pod is running, it "holds" that GPU. But when you shut down the pod, someone else can grab it and the GPUs on that machine can run out. Then you have to either wait until a GPU is freed up, or delete your container and recreate it on another machine with a live GPU.

For things like a development tool, that's not a problem. If it were a product that had to stay up 24/7, then you'd have to look into reservation options because the longer the reservation, the lower the hourly price. Depending on the machine config, the difference is huge. For example:

![plan savings](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/6vwgla9vunxiplt05pwjy2seyp1z)

If I use an H100 machine (one of the top of the line), at the standard "on-demand" rate of USD 2.89, and I keep it on for 6 months, that'd be over USD 12k. At the reduced rate of USD 2.49, it gives a discount of about USD 2k. You have to do the math to see if it's worth it. In that machine bracket, maybe it's worth consulting Azure or AWS, it varies a lot.

![a40](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/94eicysvvgdn37n4m3p54xfolbi1)

Anyway, I kept testing on the A40, which is last-generation architecture, probably close in processing to something like a 3080, but with 40GB of VRAM. And as you can see in this screenshot, it really does hit the GPU and doesn't consume half the VRAM (the model isn't much more than 20GB, but it needs the rest for the context window and other internal calculations).

The big advantage is launching with a 32k context window instead of just 8k. But let me tell you: unfortunately I didn't feel much difference in code quality.

If anyone wants to see the kind of code I got out of Qwen2.5-coder:32b, running both on my limited local machine and on RunPod, I pushed up a [pull request](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/2) on top of that little educational [Tiny-Qwen-CLI](https://github.com/akitaonrails/Tiny-Qwen-CLI) project from my other blog article.

The changes I asked for were simple, like "refactor two methods that were complex and create a unit test file for those two methods." Really nothing out of this world. The main file isn't much more than 400 lines. It really is proof-of-concept level. And Qwen struggled.

First of all, whether on my 4090 or on the A40, Qwen is **SLOW**, very slow, in the under-8-tokens-per-second range sometimes, painfully slow.

![H100](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/1vumh8tyouv4skrmho4gm72fto80)

But is it because my GPU or the A40 are old and slow? To clear up the doubt I spun up the cream of the crop: the H100 SXM with 80GB of VRAM in a container with 28 vCPUs and 250GB of RAM. And although it really did push the GPU, the speed on top of it didn't scale linearly. It's faster, but not enough to justify the price difference.

The cheap A40 pod is only USD 0.44 per hour, while this H100 is almost USD 3 per hour. **3 TRUMPS PER HOUR** or, if you leave it on all day, **USD 72 PER DAY**. You really need to know what you're doing to spend that kind of money on playing around. Don't make the mistake of testing and forgetting the pod running over there!! In one month it'll eat through more than USD 2k!!!

Unless there are specific Qwen2.5 configurations that I don't know about, and believe me: I scoured every GitHub issue, subreddit and whatever I could, but I found nothing, this model is heavy and SLOW. And that slowness and heaviness doesn't translate into superior code quality.

In practice, running locally or running in the cloud, I got the same results and the same problems. The code never worked on the first try, it always broke. When I told it to fix it, it wouldn't fix it. It would touch other places and it was still broken. Even giving it the stacktrace of the failing test, it couldn't fix it. One time I told it to refactor and instead of cleaning up the code, it added blank spaces, which the linter had told it to remove!

Using Qwen2.5-Coder:32b, and also the 32b-instruct version, were some of the most frustrating sessions I've ever had with LLMs. I thought more machine would improve things, but no, not even the H100 helped.

### Benchmarks Lie!

And here's a first warning: on every blog and YouTube video you look at, you'll see everyone saying this model is the crème de la crème of code models. There will be plenty of benchmark charts showing it matching or beating Claude, Gemini, ChatGPT. All lies.

My theory: it's all based on **synthetic tests**, tiny little tests at the level of "write a function that computes factorial", "write a function that computes the shortest path between two points", "write a function that reorders a word list", Leet Code-level stuff at most. And yes, ALL models know how to do that. It's in the training material, there's ready-made cheat code in dozens of GitHub repos. You've certainly written one for practice.

Now, hand it real code. Then the story is QUITE different.

Again, it's possible there's some configuration I haven't discovered and that, somehow, everyone knows but isn't documented anywhere. Who knows. KV Cache? Tweaked it. Context? Tweaked it. Flash attention? Tweaked it. More VRAM? Already gave it. Offload configuration? Tweaked it. Temperature at zero to try to avoid hallucinations. More prompt? More context? What else?

Don't use benchmarks to draw conclusions. They don't reflect anyone's day-to-day use. Test one by one like I did, under various configurations. That's the only way to really know how they work. And my verdict for now is that the 32B Qwen2.5 Coder, one of the **BIGGEST**, didn't work out.

### Size Is Not Everything

One prejudice I had was really about size. In my head "the more parameters" had to be better. So I was obsessed with testing the heaviest: **32B**.

Frustrated with the results, I decided to give the smaller version a chance: [qwen2.5-coder:7b-instruct](https://ollama.com/library/qwen2.5-coder:7b). Same thing, first, configure `~/.aider.model.settings.yml`:

``` 
- name: ollama_chat/qwen2.5-coder:7b-instruct
  extra_params:
    num_ctx: 32768
```

Being a lighter model, only 7B parameters, weighing less than 5GB, there's room to spare and knowing it supports up to 32k tokens, I can ask it to use everything that will fit even on my 4090.

``` 
aider --watch-files --model ollama_chat/qwen2.5-coder:7b-instruct
```

I started up Aider and asked for the same things: refactor two methods and write a unit test for the two. And the result: it was MUCH faster (it's lighter), and MUCH MORE ACCURATE. That was a surprise!

To see the difference in code, here's the [pull request](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/4). As I commented on that PR: the main point is that the code it wrote didn't break the project. I tested after the changes and it keeps running as it should. The test it wrote from scratch also failed on the first run, but given the error message, it knew how to fix it. Most importantly: I didn't have to fight with it to redo things as much as I did with the 32b. And because it's lighter and faster, interactivity was much more natural and much less exhausting, more like using something like Claude.

Its code still doesn't beat Claude or Gemini, but the way it is it's already quite usable. But if you stop and think about it, it makes sense:

**The bigger the model (parameters) the more data it has to GET WRONG.**

And it's what I'd said before: more specialized models tend to give better results. Size is not everything and there's no correlation between "being bigger" and "being better." Yes, it'll do better and faster on "synthetic benchmarks", but that's because the larger model will have more ready-made results that many of those tests use. But it'll be heavier and more complicated for generating novel results.

A smaller model, I imagine, has fewer relationships to compute, and what it has - if it was well trained - combined with the context (my current code) is already enough to give good answers. More parameters hurts more than it helps.

Besides, this is a code use case. We want it to be more attentive and less "creative." Code needs to follow the rules of that particular file to the letter. There's no point having it invent exotic stuff in it: it'll only make the code worse.

In other words: even on a smaller machine, with a 3070, 4070, with 16GB of VRAM, you can run **Qwen 2.5 Coder 7B Instruct** and it'll give appropriate and useful results. Worth a test. If you don't have a machine for it, a RunPod 3090 should be enough and cheaper than an A40. (actually I think it's just 1 cent per hour cheaper).

### Other Models

While I was at it, I tried spinning up other models to test:

```
❯ ollama list
NAME                         ID              SIZE      MODIFIED
qwen2.5-coder:7b-instruct    2b0496514337    4.7 GB    2 hours ago
codegemma:7b                 0c96700aaada    5.0 GB    2 hours ago
codestral:latest             0898a8b286d5    12 GB     3 hours ago
codellama:34b                685be00e1532    19 GB     3 hours ago
deepseek-coder-v2:16b        63fb193b3a9b    8.9 GB    3 hours ago
deepseek-coder:33b           acec7c0b0fd9    18 GB     3 hours ago
qwen2.5-coder:14b            3028237cc8c5    9.0 GB    3 hours ago
qwen2.5-coder:32b            4bd6cbf2d094    19 GB     4 hours ago
```

Unfortunately, Deepseek-Coder, Deepseek-Coder-V2, Code Gemma (from Google), Code Llama (from Meta), Codestral (from Mistral), all failed miserably. None of them managed to produce any usable code in the same test I ran on the others.

**BUT** this might still be a limitation of the AIDER tool I'm using. It's very well tested on commercial LLMs like OpenAI's, Claude or Gemini, but it's very little tested on open LLMs.

I already explained how it works: with LOTS of instruction prompting (turn on the `--verbose` option to see). The issue is that different LLMs need prompts in different formats and verbalized differently. I didn't read in depth, but Deepseek for example, I think I read that command prompts for it are in XML format (I remember seeing a bunch of tags). And if you don't feed it in that format, I don't think it's going to help much.

So it's not that these models are bad, but rather that AIDER is not good for them. It's an opportunity for anyone who wants to contribute, to create special profiles for each one and submit a pull request to Aider. It's something that, if I feel like it, maybe I'll try at some point, because after Qwen2.5 Coder, **they say** the best is DeepSeek Coder V2. Only I couldn't see it, because it was refusing to return results in a format Aider expects.

I looked through the project's open issues and found nothing to hack around temporarily. 

It blows my mind that there's a LOT of blog posts talking both about Qwen and Deepseek but my conclusion is that NONE OF THEM ACTUALLY TRIED TO RUN IT! They're just REPEATING what they heard. I could claim that this blog post is the FIRST one that really tested on code that's a bit closer to real stuff, and not little leet code games. Because just using it for 10 minutes is enough: it doesn't work.

![refactor fake](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ljvz5somwsrl2qow26ks6eh24cv1)

No kidding, I don't remember which model it was, but I asked it to refactor the method and look at this screenshot: it just created a new line and removed blank spaces, nothing else! That was the level. Codellama refused to give code, it only gave explanations. Codegemma was similar. Aider probably still doesn't know how to get the most out of them. I hope someone submits PRs to fix this.

### Conclusion

In these preliminary (super limited) tests, out of the open models, qwen2.5-coder:7b-instruct really impressed me, it's worth testing more, on more complex things, to see if it keeps the same quality.

But among the commercial ones, I also tested, and both **Claude Sonnet 3.7** and **Gemini 2.5 Pro Exp Preview** were unbeatable. My default command line from now on should be this:

```
aider --model openrouter/google/gemini-2.5-pro-preview-03-25
```

They're considerably faster, and with considerably more accurate results and fewer errors. Neither is perfect, every now and then you have to tell it to fix something, but the error frequency is WAY lower than Qwen and the final code is objectively better.

For comparison, this is the [pull request](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/3) for the same project, asking the same things, to Gemini. It didn't break the project, it managed to refactor and managed to write the unit test. I didn't spend a lot of time trying to make it exactly the "right" way I wanted, but the way it came out is already workable. I literally didn't spend 10 minutes with Gemini to get that result. With Qwen 32b I spent literally HOURS for a mediocre result.

Using an LLM to help with code is really essential. Even having to fix several things manually, wherever I had doubts or wanted ideas, any of the LLMs was a huge help. Especially late at night, with my focus scattered, drowsy, the LLM helped me avoid trivial mistakes and thought of things that, at that moment, just weren't going to come out of my head.

In terms of cost: an A40 costs 44 cents per hour. I spent less than 5 dollars on the test. On OpenRouter I also spent less than 5 dollars in credits (it's the best way to subscribe in one place and use Claude, Gemini, OpenAI, etc.). If it's just about cost, it doesn't pay off to pick open source models for the programming assistant role. Subscribe to OpenRouter and test Gemini and others, it'll be more convenient anyway. But now you know how to spin things up from scratch on RunPod and think about building products and solutions that use LLMs.

I recommend testing Aider, it's super simple, very low setup, it doesn't shove a heavy plugin into your IDE, and it's fast to use. But read the docs, there are lots of hidden tips.
