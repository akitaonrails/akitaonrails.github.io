---
title: "When Do LLMs Fail at Programming? A More Realistic Use Case."
date: '2025-05-01T17:20:00-03:00'
slug: when-llms-dont-work-for-coding-a-more-realistic-use-case
tags:
- zig
- llama.cpp
- aider
- openrouter
- llm
  - AI
draft: false
translationKey: when-llms-dont-work-for-coding
description: "A real-world attempt to build a Zig program using llama.cpp with Gemini 2.5 Pro and Aider, showing where LLMs crumble on new languages and libraries."
---



As I said in my previous rant post about [Demystifying A.I. for programming](https://www.akitaonrails.com/en/2025/05/01/rant-llms-vao-evoluir-pra-sempre-desmistificando-llms-na-programacao), I can confirm that many synthetic benchmarks that claim to measure coding ability are LIES.

And I'm not saying it's a deliberate attempt to lie, but the people doing the research and compiling rankings and leaderboards don't publish the actual details and just drop the result without context. Here's an example I found today: [LiveBench](https://github.com/LiveBench/LiveBench), yet another "programming" benchmark package. Look at what's actually being tested:

[![LiveBench scripts](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/pms3gupxalzq81uwsz73t0ip34m8)](https://github.com/LiveBench/LiveBench/tree/main/livebench/scripts)

They're idiotic tests like "load these two CSV files and compare the values". It's even more idiotic than Leet Code. It's even more idiotic than most intern hiring tests. It's the most idiotic set of tests I've ever seen.

That's why I said my tests are WAY SUPERIOR. Not because I'm awesome. But because the bar is extremely low. My most realistic test is a tiny Python project and I give prompts to refactor dirty code and create unit tests. Which is the basics of the basics that I expect from any minimally competent programmer. And I chose Python (which isn't even my favorite language), to give LLMs a better shot, assuming the training material must have a ton of Python.

Even so, they can't do what I asked. You can see it with your own eyes in my comments on the [pull requests](https://github.com/akitaonrails/Tiny-Qwen-CLI/pulls ) I left in the repository, testing each LLM, multiple times. It's absolutely disappointing to watch.

### New Project: Zig

Now I have another theory: LLMs are good at "copy and paste", at spitting out code they've seen repeatedly during training. That's why if you ask anything simple from Leet Code, it knows the answer. It doesn't even need to try to "think", it's already baked into the model. It's like taking a test with a cheat sheet.

I think the Achilles' heel of LLMs for programming is recently released libraries, new versions, or very new languages. Anything you would struggle to find on Google yourself.

And that's exactly it. I pushed [this new repo to GitHub: Qwen-CLI-Zig](https://github.com/akitaonrails/qwen-cli-zig)
The goal was to try to build, from scratch, a mini interactive chat to talk to a local model, in this case Qwen3:14b GGUF (quantized). And to do that I chose to use the C library [llama.cpp](https://github.com/ggml-org/llama.cpp) directly. I assume every popular higher-level library like litellm, vllm, ollama and similar things either use it, or are inspired by it. It sets more or less the conventions for how LLMs work.

The obstacle: it's C++ code. And to make it worse, you have to compile with the CUDA Toolkit to get access to my GPU. And now my nightmare begins.

### The Problems

For this, I chose to use Aider with Gemini 2.5 Pro Exp Preview 03-25, theoretically the "state of the art" in programming. "According to the benchmarks" ...

It's not bad, sure, but what matters for a professional is not praising what you don't know, it's knowing the limitations to figure out how to fix them, create workarounds/hacks or simply know there are cases where you can't use the tool. This is one of those cases.

Here we go:

- Gemini clearly didn't have much Zig material to train on, and what it had is out of date or obsolete. It insists on generating code that no longer works. And it doesn't know how to fix it, because it's not in the training.

- The "solution" was to run `zig build`, see the error, go to the [official documentation](https://ziglang.org/documentation/master/#intCast), for things like `ptrCast`, `intCast`, pass the URL to Aider to load it and at least that way it managed to get past those errors.

- Things that are already well documented, like cloning the llama.cpp repo, configuring the correct flags to compile with CUDA, all that in a bash script, that was easy. It pulled it off flawlessly. I imagine there's a lot of example build scripts for that sort of thing in the training.

- Even so, in Zig, it needed to load the `llama.h` header to know which functions exist and their signatures to be able to `extern "c"` things. Snippets like this:

![extern c](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/3t4nq4879ra3k81b4z2clhfb6axh)

- To do that it needs to read `vendor/llama.cpp/include/llama.h`. It knows this, but kept sending the wrong path the whole time, like `vendor/llama.h` or `vendor/llama.cpp/llama.h`. If you don't pay attention, it gets into an infinite loop trying to guess because it errors out endlessly without stopping to think about the correct path. I had to manually tell it the right path, more than once, and even so it would forget.

- With `llama.h` loaded into context, it still made rookie mistakes: it went off creating `extern` for functions it doesn't even need. It read the file and started copy-pasting everything into Zig. And besides padding the code with unnecessary mappings, it got the types WRONG a lot, using `c_int` for `int32` (the first is to map to C, the second is just for pure Zig). That cost A LOT of compilation errors and excessive repeated attempts before getting it fixed.

- After a few frustrated attempts, I got it to create a download script for the Qwen3 14b GGUF model file (it seems llama.cpp, by default, wants GGUF). And finally the program compiled and I managed to run it up to the point where the chat opened and I could submit a message.

And in the final part, it could not, under any circumstances, get the response back from the model. Unfortunately, I chose Zig precisely because it's still very new and I know the syntax keeps changing because it's not a stable language yet. That's why I don't recommend it for real projects. It's very experimental. I still don't know how to use Zig properly. So I didn't have the patience to try to fix the error myself either. (if any Zig person wants to volunteer, I'll accept pull requests).

Anyway, I spent a good 2 hours just on this part. Trying to read documentation. I'd try to pass llama.cpp articles with code examples and here comes another problem: everyone only writes blog posts with Python examples (which is the easiest thing, just load litellm), but nobody volunteered to write posts in C++, for example (because nobody who writes posts knows how, myself included).

It's either some specific model config with llama.cpp that I don't know (so the result is wrong) or it's the code that grabs the response that has some bug. I see this:

![llama error](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/wocaykokk9w8wj8udgi3hyfk9emj)

The problem: there's very little documentation about it and I couldn't find anything that helped me solve it. And by trial and error Gemini couldn't solve it either. So I ended the test.

### It's Expensive

Now the bonus. I subscribed to [OpenRouter.ai](https://openrouter.ai) to centralize spending on any LLM in one place. I bought USD 100 in credit and had already spent quite a bit on the refactoring tests with several LLMs. I don't know how much I had left, let's guess around USD 20.

So while doing this new little Zig program, the credits ran out mid-way. My Aider started beeping that there weren't enough credits for the amount of context Gemini generates (this is a problem with "thinking" models, the reasoning is too long and eats A LOT of token credit).

I went to my account and topped up another USD 100. I came back just to this `std::bad_alloc` part to try to fix it - and the problem is that Gemini doesn't focus. It starts messing with code at random and things like the model loading procedure onto the GPU, which was already working, it kept frequently breaking. And I kept frequently telling it to revert to how it was. And that burns A LOT of credit too.

The moment I gave up, this is what I saw in my OpenRouter balance:

![OpenRouter credits](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/pobrdfrwga38utw0jud47no3fhhn)

On top of the ~USD 20 I had left, it spent almost USD 35. Ballparking it, it burned more than USD 50 to fail to deliver working code, after a good 4 or 5 hours of trying. Expect to spend USD 10 per hour in trial and error. If you see yourself repeating "What's wrong, fix" a lot, it's time to stop and give up, it's not going to manage.

You have to have the right intuition for when information is missing and go fetch URLs on Google to hand to it. You have to have intuition about what's in the training material and know when it doesn't have that information. You have to have intuition to read the stack trace and tell it what to ignore and what to focus on to fix. You have to know that you should ask for one small thing at a time and never "fix everything" or "test everything". It won't manage.

Prompts that have the best chance of working are always very small things. One small block of code at a time. Incremental, testing, and telling it not to touch what already works (and it'll ignore you and touch it, and break it). Having tests to check is fundamental. And "compiling" isn't enough.

This Zig code "compiles" but it has a runtime error, it only shows up when it runs. But I didn't have the courage to ask it to write a unit test. All of them were incompetent at writing tests for Python. For Zig then, I already consider it impossible. It won't manage.

Why? Because I think researchers don't know how programmers work. To them, programming is just small scripts (which is what they actually do: open a CSV and aggregate data). That's all they know how to do. And that's what LLMs reflect: they have A LOT of difficulty writing real code. And never longer than about 4 files in context at a time. Any more than that and it gets confused very quickly and starts spitting out VERY wrong code.

By the way, another tip: avoid naming your project with names similar to popular open source projects. Think about it, say your project is called "my-react". You're screwed, its training certainly had tons of real React.js examples, and it'll keep confusing the two things all the time. Again, have intuition about what's already in training to help the model not get confused.

And you'll have spent tens of dollars, or more, if you're not careful. And in the end you won't have code that works properly.

Oh right, there are hacks you can pull: integrate a RAG with source code of things you know it doesn't have in training, or train LoRAs and use them together. And even so these aren't "solutions", they're attempts to get it to generate code that makes more sense. But on their own, without this kind of help, at this moment they still don't know what to do.

What many people ignore is that the VAST MAJORITY of the main real codebases on the market are all CLOSED. Amazon will never release their e-commerce code, nor will Alibaba. iFood or MercadoLivre the same. No real code is in the model. If it were it would be a huge LAWSUIT risk. They can only use open source code, from places like GitHub or Stack Overflow answers. And there you only find BASIC AND BAD code. So that's all LLMs manage to spit out: BASIC AND BAD code.

If an LLM has been solving your problems, it's because your problem is very simple, not because the model is good.
