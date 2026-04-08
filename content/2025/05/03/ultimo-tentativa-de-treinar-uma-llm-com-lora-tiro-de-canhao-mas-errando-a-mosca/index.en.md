---
title: "Final Attempt to Train an LLM with LoRA. Cannon Shot, But Missing the Fly."
date: '2025-05-03T21:15:00-03:00'
slug: final-attempt-to-train-an-llm-with-lora-cannon-shot-missing-the-fly
tags:
- qwen3
- vllm
- runpod
- llm
draft: false
translationKey: last-lora-training-attempt
description: Renting an 80GB H100 on RunPod to fine-tune Qwen3-32B with a LoRA on Zig 0.14, and discovering that even cannon-class hardware can still miss the target.
---



Ok, I'm stubborn. In the [previous post](https://www.akitaonrails.com/en/2025/05/03/ensinando-zig-mais-recente-pra-sua-llm-treinando-loras-quase) I explained everything I knew about trying to fine-tune a model with LoRA. But it's a tedious, slow process, limited by the "poverty" of my RTX 4090. In 24GB of VRAM you have to fit the model, things like the KV cache, the training dataset and room to process it all. Squeezing hard, the Qwen3-8B model and 1MB of dataset fit and that's it. It'll use 21GB constantly for more than an hour and the end result, even though the model manages to answer "yes, I know Zig 0.14", isn't good — because the 8B base model wasn't great to begin with.

The way out: migrate my training to a bigger machine. I started by trying an A40, to see if 40GB was enough to fit the Qwen3-32B model for this training. And no, it didn't fit.

"Ph0da-se", I thought. I rented the biggest configuration RunPod has:

![H100](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/9m5uitxvhhbpotu5lkbrw0znd276)

This H100 is already "obsolete", in the more modern datacenters there are already H200 Blackwells and other bigger things. But in the world of "mortals", an H100 at USD 3 per HOUR will have to do. The good part: it has 80GB of VRAM. And what I wasn't expecting: even that is too little!

And here's the advantage of having done everything organized and pushed to this [GitHub repo](https://github.com/akitaonrails/qwen3-zig-lora-training). Setup was trivial: just pick a pod with a PyTorch 2.8 image with Python 3.10 and CUDA 12.8, which are the latest stable versions. Clone my project, run `pip install -r requirements.txt` and I could already run my `./train-lora.py`.

I was going to add back those 15MB of source code from the newer Zig Standard Library, but even on the H100, it didn't fit! Training with just the original 1MB I used yesterday already pushed the machine almost to its maximum:

![74GB](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/iahqr9hzs2aaku3fup7u3cw9navk)

Look how absurd this is: during the entire training it sat at nearly 75GB out of the 80GB of VRAM. Literally there's no room to train with much more material than that. Either that, or you drop down to a smaller model, like Qwen3-14B. I still don't know whether 32B with less material or 14B with more material would be the better combination. I already know 8B is useless for programming anything complicated. With 14B I had a bit more success in tests, but it still can't do anything very complex. 32B is no guarantee of being much better: Qwen2.5-32B didn't perform better than the 14B, but the new Qwen3-32B "looks like" it's more stable. That's what I'm trying to test with the LoRA.

This was at lunch time. I'm writing this post at dinner time. This was the training forecast:

![6h](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/lzrfdl97n96qesnhde33lugidr3i)

This estimate keeps fluctuating, but I think it did take around 5 to 6 hours.

![lora size](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/stoakih27g3o9c1e1d07y14szrf0)

And at the end of those almost 6 hours, this is what it produced: a 5.1GB LoRA (against yesterday's 3GB). Size isn't everything. Bigger doesn't mean better. Let's see.

### After Training

Now that training is done, I can use the same H100 pod to also serve the model with the LoRA, and it would have to be this one anyway. To run it, it goes like this:

```bash
vllm serve Qwen/Qwen3-32B \
    --enable-lora \
    --lora-modules ziglora=./qwen3-zig-lora \
    --max-model-len 10000
```

And you also have to limit the context size. By default vLLM tries to start with a 40k token context and, even on the H100 with 80GB, it fails initialization with this error:

![KV Cache error](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ykusgib7o6wybhi5rs4zvx2yrp8j)

There's no room left to load the KV Cache (in short, in the process of generating the next word, it keeps adding a new row and a new column to the matrix, but doesn't need to recompute the previous rows/columns, the result is the same. Hence this cache).

A strange behavior both on my machine and on the H100. I don't know if this happens every time you load a LoRA, or if my LoRA is broken, or if there's some configuration I'm missing. But loading with a LoRA, initialization is EXTREMELY SLOW. Bringing up vLLM, which normally takes 1 minute, now takes 5 minutes or more. I don't know what causes this, but this is the kind of server you can't easily shut down and restart. It makes me miss starting up a J2EE server ...

Seriously though, it seems I'm not the only one. This [issue](https://github.com/vllm-project/vllm/issues/6876) never got resolved. It "could" be some bug in vLLM, it "could" be a combination of factors nobody knows. But neither the GPU nor the CPU is doing anything. CPU doesn't go above 10% usage, GPU looks like it's just waiting. Honestly, at first glance it looks like some I/O problem. Maybe the process of checking the checkpoint shards, pulling from a network volume, is slow. But since I'm going to run this only today, I didn't bother to debug it.

![slow load](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/mluc626od3h1q0swnv8kepe1aji5)

Look at this. 8 MINUTES on the part that loads checkpoints. And then it still continues with other phases that also take a bit more time. I'll leave this screenshot here, in case someone has seen it and knows what it could be.

Just to rule it out, I tried bringing up vLLM with just Qwen3 and removing the LoRA entirely and, to my surprise:

![sem lora](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2hzvcqrk087i5ov4otx0rxa8erdf)

It also took almost 8 minutes. So the problem is not the LoRA. Either it's something in vLLM that can be configured — but I don't know how — or it's a limitation of the Qwen3-32B model itself being this slow to load.

Anyway, with the LoRA, I tried dropping to 16k tokens: it doesn't come up. I tried starting with 10k tokens. And at this point I'd say this test has already failed. A Qwen3-32 theoretically has the capacity to support context windows up to 40k tokens. It's not huge, but you can work a bit inside that context.

But below 15k tokens you can no longer use it with tools like Aider, which needs to send long system prompts to instruct the LLM on how to behave so it spits out code the tool can capture. So there it is: a Qwen3-32b + LoRA, on an H100 SXM with 80GB of VRAM, is not really usable.

And I'd even be sad or frustrated if a 32B model were really, orders of magnitude better than a 14B, but in my empirical tests: it isn't. It makes just as many errors, and it isn't so much better that it justifies paying that much for your own top-of-the-line infra. All of them barely manage to produce simple code, and even then with errors.

In the end, with 10k the server came up, consuming an absurd 63GB at initialization, without even starting to process anything:

![63GB](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/uetjwlzlgy7bpd4itn1qxczl3mhs)


And ...

### First Tests

After 10 minutes of waiting, I had to hit Ctrl+C and start all over. Because I was dumb. RunPod is really meant to run experimental stuff, I'm not sure I'd trust it for production. It's more like a VPS than an AWS. And I'm hacking it together by bringing up a pod that expects to have only port 8888 mapped to run a Jupyter Notebook server (which I'm not running).

![runpod connect](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/h4pzcdxydfiou5iulc7m67zctb9a)

My idea is to use this port to map vLLM. But by default it starts on port 8000. I forgot to add `--port 8888`:

```
vllm serve Qwen/Qwen3-32b --enable-lora --lora-modules ziglora=./qwen3-zig-lora --max_model_len 10000 --port 8888
```

And here we go again, wait another 10 minutes ... ... and finally it came up on the right port and now we can test. First, the curl tests:

![curl hello](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/p8d3ogzwd7lzpu05o7lkm50f8k4h)

And before anyone comments: there's no problem showing my pod's URL in the screenshot. I'm going to delete this pod before publishing this post.

By the way, if you bring up a remote model like I did, all you have to do is take the URL and put it in the `OPENAI_API_BASE` variable and anything in `OPENAI_API_KEY` and tools like Aider will work the same. The vLLM and Ollama APIs are compatible with OpenAI's.

As you can see, the first question answered similarly to my local test with Qwen3-8B. Nothing special, I already knew that worked. Let's ask it to explain a new feature of Zig 0.14.

By the way, besides being slow to start, it's also slower at generating text, MUCH slower. I must have done something wrong in training, but I felt the same thing with the local LoRA or on the H100. It gets noticeably slower. It did another long "think", but the answer this time is more consistent with the release notes (I only cut out the relevant excerpt):

```
In Zig 0.14.0, the `@splat` function has been extended to support arrays, making it easier to initialize fixed-length arrays with a single repeated value. This replaces more verbose or unsafe initialization patterns and is type-safe, with the array's length inferred from the destination type. Here's a concise explanation and code example:


...

### **@splat for Arrays**  
`@splat(value: T) [N]T` creates an array of length `N` where every element is `value`. The array's length and element type are determined by the context in which `@splat` is used.  

### **Code Example**  

const Point = struct { x: i32, y: i32 };  

pub fn main() void {  
    // Initialize an array of 5 integers with 42  
    const numbers: [5]i32 = @splat(42);  

    // Initialize an array of 10 booleans with true  
    const flags: [10]bool = @splat(true);  

    // Initialize an array of 7 points with (0, 0)  
    const origin_points: [7]Point = @splat(Point{ .x = 0, .y = 0 });  
}  
....
```

The example code also makes a bit more sense. Compared to the 8B version, at least the explanation was better. But this might have been affected by a small tweak I made to the dataset: I duplicated the release notes, to try to put a bit more emphasis on the new features. That probably had an effect too.

Now let's see if it can write code that actually works. My prompt was this:

```
"Can you give me a Zig 0.14 code example of a simple program that acts like an interactive chat, so the user can input messages. then the message is parsed to see if there are commands such as '/list', which will list the files in the current directory, or '/cat' which will read the file asked, or '/quit' to exit the chat?"
```

And this happened:

![abort](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/4n3bzm5g0gt46jfmqv55qy0x9tlu)

Remember how I had to keep decreasing the context to get it to come up? And remember how I keep saying that "thinking" wastes a lot of tokens? Well, there you go. The model self-crashed by thinking too much. I tried a few times and it crashes. To try to avoid this, I tried hitting `curl` sending `enable_thinking=false` like this:

```bash
❯ curl https://d8zck5aw8eimij-8888.proxy.runpod.net/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
        "model": "ziglora", "temperature": "0.1", "enable_thinking": "false", "skip_special_tokens": true,
        "messages": [{"role": "user", "content": "..."}]
      }'
```

Temperature, for code, I think can't really be much higher than 0.1. For chit-chat, for less exact things, the default of 0.6 that everyone uses is fine. But for code, I really don't need it to be "creative" (random, in fact), I want answers as exact as possible.

Anyway, even trying to turn off thinking, something is wrong. Possibly the LoRA I added is making it "think in circles" and never being able to return, blowing up the context. I tried several times, but it's unable to answer with code.

### Final: I Give Up For Now

Yes, I broke the LLM, apparently lol 😅

I tried several times and it really can't give me any code back. And I know it's trying, because if I send `stream=true`, I can see it returning tokens, but at some point it runs out of space somewhere (surely the context, which is small) and it crashes.

The feeling is that my LoRA probably "stuck" too hard and threw too many parameters out of balance. Now the model starts writing the text and enters circular thinking, never stopping generating more text.

This is definitely an effect of the LoRA and of some mistake in training. If I had to guess, it's because I crammed super long texts into training, without manual markers indicating where each part ends with a `<|im_end|>` or whatever. Without that, maybe it thinks the whole text is one answer and it has to respond that long. From what I understand, in the case of this Zig training, I would have had to break the documentation, the release notes and everything else into smaller chunks, like this:

```
<|im_start|>system
You are a helpful assistant.<|im_end|>
<|im_start|>user
What is Zig?<|im_end|>
<|im_start|>assistant
Zig is a compiled programming language...<|im_end|>
``` 

And do that for all 200 thousand characters of documentation. Imagine the work to do that. And avoid sending super long texts in context without markers for where each part starts and ends.

At least, that's my guess. The problem: even if I spend time formatting it this way, then it's another 6 hours of processing, just to find out afterwards whether it made any difference. It probably won't, I need to think of other hypotheses, and each round is 6 to 12 hours between setup and processing.

From this point on it's a slog I don't have the motivation to do. I'm leaving this written down here to see if it reaches the hands of real researchers. Maybe it's something an AI researcher would find super obvious. But that's the point: this information isn't easily available publicly anywhere. Every example you find online is too simple. They just say _"on this line of python you load the dataset, and on the next line training starts"_ — but where are the instructions for HOW to build a dataset and HOW to determine whether it's adequate? Nowhere.

If anyone has tips on how to improve the training or wants a research problem in the field, [here is the GitHub](https://github.com/akitaonrails/qwen3-zig-lora-training) with all the code and training material I produced. We need researchers to look at this kind of thing and share more about what they know. I know someone knows, but just digging around on Google didn't get me anywhere.
