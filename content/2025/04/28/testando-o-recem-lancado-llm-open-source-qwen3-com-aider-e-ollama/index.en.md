---
title: "Testing the Newly Released Open Source LLM - Qwen3 (with Aider and Ollama)"
date: '2025-04-28T20:30:00-03:00'
slug: testing-the-newly-released-qwen3-open-source-llm-with-aider-and-ollama
tags:
- qwen3
- ollama
- aider
- llm
  - AI
draft: false
translationKey: testing-qwen3-first-aider-ollama
description: "First hands-on impressions of Qwen3 running locally via Ollama and remotely via OpenRouter, tested with Aider on real refactoring tasks."
---



I just [posted yesterday about Qwen2.5-Coder](https://www.akitaonrails.com/en/2025/04/27/testando-llms-com-aider-na-runpod-qual-usar-pra-codigo) and TODAY (2025-04-28) Qwen shows up and drops **QWEN 3** on me, which, obviously, they claim totally smokes the 2.5. And obviously I had my hands dirty already, so I had to test it.

[![qwen x](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/e1ipve95x7e6nlnf7qffayzsz0ag)](https://x.com/AkitaOnRails/status/1916974917872193780)
If you're running an ollama installed via packages like Pacman or Apt, it's possible they're not compatible yet. But I saw on Ollama's X that they're already supporting it:

[![ollama x](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/yrkrg6l6r4nvnmfefiqoaplbf6cw)](https://ollama.com/library/qwen3)
So there was only one alternative: pull the source directly from their repo and compile from the master branch:

```
git clone https://github.com/ollama/ollama.git
cd ollama
yay -S cmake
cmake -B build
cmake --build build
```

Done, it will use the same environment variables pointing to my correct models directory, so I just start the server manually like this:

```
OLLAMA_FLASH_ATTENTION=1 go run . serv
```

And from another terminal, pull the new model:

```
ollama pull qwen3:14
```

The `latest` tag, I "think" is the smallest version, the 4b, because it's pretty small. I already know that 32b is too big for my RTX 4090 with 24GB, so I went for the 14b:

```
❯ ollama list
NAME                                            ID              SIZE      MODIFIED
qwen3:14b                                       7d7da67570e2    9.3 GB    About an hour ago
qwen3:latest                                    e4b5fd7f8af0    5.2 GB    About an hour ago
qwen2.5-coder:7b-instruct                       2b0496514337    4.7 GB    18 hours ago
...
qwen2.5-coder:14b                               3028237cc8c5    9.0 GB    2 days ago
MHKetbi/Qwen2.5-Coder-32B-Instruct:latest       ac172e3af969    65 GB     2 days ago
qwen2.5-coder:32b-instruct-q4_K_M               4bd6cbf2d094    19 GB     2 days ago
...
```

Look at the size differences. Depending on your GPU/VRAM, you have to pick sizes that fit **AND** leave room for the context window. Speaking of which, let's check the maximum it supports:

```
❯ ollama show qwen3:14b
  Model
    architecture        qwen3
    parameters          14.8B
    context length      40960
    embedding length    5120
    quantization        Q4_K_M
...
```

It's already a nice upgrade: Qwen2.5 maxed out at 32k tokens, Qwen3 supports up to 40k tokens. It's nothing revolutionary, but it does let you load a bit more code into the context. Now, we need to update `~/.aider.model.settings.yml` and add:

```
- name: ollama_chat/qwen3:14b
  extra_params:
    num_ctx: 40960
...
- name: openrouter/qwen/qwen3-235b-a22b-04-28:free
  extra_params:
    num_ctx: 40960
```

There are 2 entries: the first is to run the 14b version locally via ollama on my RTX 4090. That's why it's the 14b version. The second is connecting remotely to the OpenRouter API where I can test the a22b version (I didn't read the details, they start from the biggest 235b and somehow "compress" into a 22b one, I guess).

Anyway, to run it on aider just use one of the two:

```
aider --watch-files --model ollama_chat/qwen3:14b --verbose
```

If you haven't read them, check my previous posts on Aider and Ollama. It makes a huge difference how each model reacts to different types of prompts. Aider (like Co-Pilot, Cursor and others) sends a bunch of hidden prompts that you don't see, instructing the LLM on how to respond in a structured way so these tools can later capture the suggested code and apply it to your actual file.

I didn't update Aider, I don't know if anyone is already tweaking specific adjustments for Qwen3. As I said in yesterday's post, Aider can't talk well to models like Codellama or Codestral. Because it doesn't have proper prompts for them. Someone has to produce PRs for that. It's not automatic, it depends on a lot of testing and trial and error until you get it right.

That said, fortunately with Qwen3 it worked reasonably well without any extra configuration. With ollama from the master branch, it loads just fine, or connecting via OpenRouter.

### The Verdict

You're going to see a bunch of tweets sharing "charts" of "benchmarks" saying "wow, look how amazing this is"

![fake news example](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/pa8p2i7givn9sqeldkx2mfog9wws)

**DON'T BELIEVE ANY OF THEM**

Do your own tests. It's literally one command pointing to OpenRouter, zero setup (ollama master is only if you're going to run local). You can test IMMEDIATELY on your own machine via that API.

Those charts mean nothing to me. I ran the same tests I did with Qwen2.5, Deepseek, Gemini, Claude, etc. Here's the [pull request with Qwen3 code samples](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/5). Same thing as the others: I asked it to refactor some methods and write a unit test.

Just like Qwen2.5:7b-instruct and Gemini, and contrary to Qwen2.5:32b, this new Qwen3 did really well. My first impressions:

- it is WAY faster than Qwen2.5. At least on my local machine, on the 14b version, I felt tokens/sec much quicker. At that speed, I think it's viable to use locally.
- Its reasoning/deep thinking is WAY superior to Qwen2.5, getting closer to the line of reasoning of Claude or Deepseek R1. You could see it stopping to think properly before spitting out random code.
- Refactoring results: the two "dirtiest" methods of this little project of mine are an "ensure_model_loaded" and the "chat" which is the main loop. Qwen2.5 couldn't refactor them properly, Gemini did, and now Qwen3 did too: on the **first try**.
- More than that: on the first try it didn't break the code. I tested building and running and it kept working as it should.
- On the tests it got more confused and had a lot of trouble. But half the blame is mine: I didn't give it the full context (I didn't show the files in "helper_functions/") for example. Without that context it didn't know if they were fixed things, dynamic, or what to expect.
- Giving it that context, it managed to get out of the errors and got the test to pass. It wasn't a great test, but as I said, I think I failed to explain better what I wanted. But that was part of the challenge, I was just sending a "try to make a test that passes".

Being much faster than qwen2.5, it's not that big a deal that I had to explain more, because it returned reasonably quick responses. At least in these preliminary tests, if no one had told me, I would believe I was talking to ChatGPT o4-mini or Sonnet 3.7. Qwen3 really was a very good leap over Qwen2.5. And as I said in the previous post, it doesn't have to be the 32b model: it can be the smaller 14b. I imagine the 7b also works well on more modest hardware.

This gets very close to having a competent coding assistant, in the caliber of an o4-mini. And at the very least it's another good alternative to use in place of Claude or ChatGPT, in case they're not giving good answers on a specific problem.

I still feel Gemini 2.5 Pro Exp is better, but the margin has shrunk. Where Gemini still pulls ahead is in their Sliding Window Attention algorithm that allows a much larger context window. Same thing with Deepseek. But as I've also said, that doesn't mean you can dump a huge project into it and expect it to produce good results: the larger the context, the worse the responses get.

Everyone has already felt that in web chat, when the conversation drags on without good answers, there's no point insisting: it's better to start a new empty session, which has more chances of better responses. And that's the reason: excess context hurts the following responses. And that's why it's still impossible to upload an entire project and expect good results. 1 million tokens sounds like a lot, but once you understand this, it really isn't that much.

Anyway. The main thing is that yes, Qwen3 represents a very good leap in the open source LLM world. Now the expectation is whether Deepseek R2 will surpass it and by how much.
