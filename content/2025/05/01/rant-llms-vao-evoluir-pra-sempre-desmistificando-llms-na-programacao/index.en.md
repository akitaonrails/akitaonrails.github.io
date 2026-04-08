---
title: "Rant - Will LLMs Evolve Forever? Demystifying LLMs in Programming"
date: '2025-05-01T02:30:00-03:00'
slug: rant-llms-will-evolve-forever-demystifying-llms-in-programming
tags:
- aider
- gpt
- gemini
- claude
- imagenet
- mcp
- benchmark
- llm
draft: false
translationKey: rant-llms-evolve-forever
description: A hype-busting rant on LLM benchmarks, the myth of exponential AI progress, and my hands-on experience showing why Vibe Coding does not work.
---



Let me recap my latest articles:

- [Hello World for LLMs](https://www.akitaonrails.com/en/2025/04/25/hello-world-de-llm-criando-seu-proprio-chat-de-i-a-que-roda-local) - in this article I explain how to build a simple (educational) little chat program loading an LLM (Qwen2.5) and even how to use prompts so it can call scripts/agents and run a few simple tasks like loading local files. I pushed the code to GitHub as [Tiny-Qwen-CLI](https://github.com/akitaonrails/Tiny-Qwen-CLI) and I left the code "dirty" on purpose so I could test how LLMs manage (or fail) to adjust that code.
- [Your Own Free Co-Pilot](https://www.akitaonrails.com/en/2025/04/25/seu-proprio-co-pilot-gratuito-universal-que-funciona-local-aider-ollama-qwen) - here I explain more about the Aider tool, which is like a Co-Pilot or Cursor, but free and open-source. It does not require plugins or IDEs. It runs in the terminal and is easy to use. I also show how to integrate it with Ollama and spin up your own local LLMs.
- [Dissecting an Ollama Modelfile](https://www.akitaonrails.com/en/2025/04/29/dissecando-um-modelfile-de-ollama-ajustando-qwen3-pra-codigo) - in this one I dig deeper into LLM theory and explain what Key Sampling is and how various parameters affect an LLM's text generation, like Temperature or Top_P. This is to demystify even further that there is no "magic" in how an LLM manages to generate text.

Over the last few days I have been testing and posting on X my impressions about the most varied commercial and open source models like Claude Sonnet, Gemini 2.5, OpenAI O4, Deepseek-R1, the new Qwen3 and more. There are more posts on the blog beyond the ones I mentioned above, but these are the main ones.

The goal of this post is to demystify LLMs even more and talk more about my experience testing most of the most popular LLMs.

### Demystifying LLMs - 1. Benchmarks and Rankings

Anyone who has followed my talks and videos for years is sick of hearing me talk about the book ["How to Lie with Statistics"](https://www.amazon.com.br/Como-Mentir-Estat%C3%ADstica-Darrell-Huff/dp/858057952X). And what I see most in the hundreds of posts about LLMs are the rankings based on benchmarks. Here is an example that went viral yesterday, at the launch of Alibaba's new model, Qwen3:

![Qwen3 benchmarks](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/1kflvwk5uq9lkt5yh8knngwxwfi9)

The problem: the rankings are not wrong. What they mean is this:

**"Qwen 3 beats Qwen 2.5 and also other famous ones like OpenAI o1, DeepSeek-R1, Grok 3 Beta, Gemini 2.5, etc .... IN THE BENCHMARKS THAT WERE RUN - and ONLY in the benchmarks that were run."**

That's all. But 99% of posts publish it like this:

**"Qwen 3 IS BETTER AT WRITING CODE than Qwen 2.5 and also other famous ones like OpenAI o1, DeepSeek-R1, Grok 3 Beta, Gemini 2.5, etc"***

The benchmarks are not wrong, what is wrong is whoever interpreted that to mean being better at everything. Let's go to another analogy:

**"Student So-and-So got 99% right on every college entrance mock exam"**

People's conclusion:

**"Student So-and-So is 99% better than everyone at everything"**

I hope that sounds obviously wrong. Being better at 1 thing makes nobody better at everything, but in AI this is how every news item about a new LLM version is published in personal posts and journalistic outlets. It is an obvious **CLICKBAIT**. And you fall for it.

And if you are used to hearing it this way, it makes it seem that with every new LLM version - that is "better at everything" than the previous one - we are very close, or have already reached, the point where yes, human programmers are no longer needed, nor mathematicians, nor engineers, nor doctors, since after all, the LLM is "GOOD AT EVERYTHING".

And nothing could be further from the truth than this. These statistical ranking studies have a testing METHODOLOGY and a fixed benchmark suite. The tests are SIMPLE, think things at the level of "write a function that computes a factorial", "write a function that sorts a list of words", "given a list of words, find a specific one in logarithmic time", etc. Things you see in introductory computer science courses or on Leet Code.

These tests are run MULTIPLE TIMES and the "outliers" (tests where it got way too much wrong, or tests where it got way too much right, or anything that falls out of the average) are discarded, a statistical distribution is built, and a generic overall "number" is compiled like "got 99% right" or something like that.

It got a lot wrong, but that data point is an outlier, and it was removed from the tally. It is statistically irrelevant within the methodology. But here is a fact: no LLM gets it right 100% of the time, and none ever will. I demonstrated this in my post about Modelfiles where I explain that there is a controlled random factor (temperature, top_p, top_k, min_p, key sampling). And there are also normalizations and random factors during training (softmax, relu). And there are also later optimization factors that "round" or "truncate" the probabilities like quantization (fp8, Q4, etc). In other words, there are several "micro error" factors and randomness baked into the entire process. It will never be a "correct" answer, only "possibly one of the most correct" and this "possibly" can vary A LOT.

### Dissecting AI Myths - 2. Exponential Evolution

Whoever just arrived and is seeing frequent news about releases of new LLM versions like Alibaba's Qwen3 now, Xiaomi's new MiMo, Gemini version 2.5, ChatGPT version 4.1, etc has the impression that we are evolving by leaps and bounds.

But the truth is that yes, 2022 was a historical milestone with the original ChatGPT, mainly GPT 2. But from then until now, evolution has slowed down. Each new version is no longer visibly "twice as good" as the previous one, except in certain benchmarks, under certain specific conditions - that do not match reality. I will demonstrate this shortly.

A friend of mine reminded me about the evolution of deep learning technologies in image recognition, years earlier:

- 2012 – AlexNet: First major victory on ImageNet with 8 layers, reaching 84.7% top-5 accuracy.​

- 2014 – VGG: Networks with 16–19 layers, incremental improvements, but with a significant increase in parameters.​

- 2015 – ResNet: Introduction of residual connections, allowing networks with more than 100 layers and surpassing human performance in top-5 accuracy.​

- 2016–2017 – Inception, ResNeXt, SENet: More complex models with marginal gains.​

- Post-2018: Top-1 accuracy stabilizes around 85–88%, with marginal gains even in models like EfficientNet and NasNet.

AI has been studied since literally the beginning of modern computing in the late 1930s, by none other than Alan Turing himself or John Von Neumann. I talked about them here:

{{< youtube id="G4MvFT8TGII" >}}

Think of a "slow beginning": from 1930 until around 2012 when ImageNet and things like AlphaGo, GANs and such started to pick up speed. We left the bottom leg of the "S" for the middle starting in the 2010s and have been accelerating until now. I "guess" that we are either already at, or heading toward, the top of the "S", where the curve stabilizes and slows down. That is what happened with deep learning for images:

![ImageNet](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/lgr7uodnbmqfujjw39h69mnybi8t)

Remember AlphaGo? I followed it live. As a hobbyist amateur in Go, I watched live the games with the South Korean masters like Lee Sedol, at the time it happened, I think 2016. You probably just watched the [documentary on Netflix](https://www.netflix.com/br-en/title/80190844) only now, but this has been going on for years. And now, where is AlphaGo evolving exponentially? Everyone has forgotten already, because the hot thing of the moment is LLMs, which is just one more category in the AI world.

The vast majority of optimizations have already been done or are being done. If I had to summarize just some of the most important milestones of this part of the generation, it would go roughly like this:

![timeline llm](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/z14qvijztqvy6prvbpokk02fqrjt)

Every engineer and scientist knows this: when you have nothing, anything is a quantum leap. When you only have 1 real, 2 reais is already "double". When you have 10 reais, 20 is already a lot. But when you get to 20 thousand, another 100 no longer adds as much value as when you only had 1 (there it would be 100x).

Every new drop of optimization now COSTS A LOT. Even in lossy optimization (quantization) we already went from fp32, moved to fp16, fp8, already reached 1-bit. There is nowhere further down to go after that. We are at the point where we are trading precision for performance.

Doubling parameters no longer results in doubling result quality. Need to double to get 5%? Maybe? And it is no use to keep increasing, the result starts getting worse instead of better. That is why we already jumped to things like specialist LLMs, MoE (Mixture of Experts).

Deep thinking/Chain-of-Thought/Reasoning was a big leap, but just increasing more thinking no longer delivers as much either, in fact, in many cases it makes the result worse with "over-thinking". Thinking too much is not linear either.

Increasing context does not help improve the answers either. On the contrary, we already see that past a certain point, more context hurts the result, because the attention architecture (the great differentiator of LLMs), has limits. Yes, a Deepseek or Gemini claim to support "1 million tokens". But I already explained in previous articles that this is **Sliding Window Attention** like SDPA or Flash where the attention is focused only on a PART of that large context: it cannot pay attention to everything all the time.

Every spot where you could put the obvious things, like caching, whether in training or in generation, has already been put there. We are running out of options here. And yes, new discoveries continue to happen, but as I said, none has yet managed to push past the limits we know exist.

### Demystifying AI Myths - 3. Ending Programmers

What I hate most about the current hype are the false promises of "AGI", "Vibe Coding", "replacing employees with MCPs". Let me state it again: it is all propaganda.

Lying propaganda and false snake oil promises (something that always existed and will always exist in history) DEVALUES the reality of the innovations we have today.

_"But Anthropic's CEO and uncle Zuck said they will replace programmers. Microsoft and Google said that 30% of their code already comes out of AI."_

As I said before about statistics. Yes: a lot of stuff IS going to be done with AI indeed. You don't need AI to optimize work in several areas:

- a stick and a clay block are enough to replace people's memory. Nobody remembers details, especially numerical ones, permanently. For millennia we have been evolving in helping our memory with some kind of external storage. Whether a clay block, whether paper, whether a post-it, whether a .txt file on your machine.

- the first photographic camera already removed the need to hire a painter to have a "selfie".

- the first primitive computer already eliminated the need for an entire building of mathematicians doing and redoing calculations on paper. Even so, this is how the first rockets went to space. Have you watched the movie [Hidden Figures](https://www.netflix.com/title/80123775)? I recommend it.

- cars have been assembled almost entirely by robots for years now. Robotics is nothing new in industry. These days, a tablet has already replaced supermarket and McDonald's cashiers. All of this without needing AI. IVRs and little bots have already replaced a lot of telemarketing and support.

So yes, in practice, AI will also replace an entire class of programmers: the low-value-added ones. The ones who don't know how to do much more than copy and paste, or whose work routine is repetitive. If your job involves repetitive tasks, it is obvious that it is a matter of time until they get automated, whether by AI or mere scripts. Something we already do today.

A programmer's job has always been to replace other people's work. You, who work building an e-commerce system: you helped replace the work of salespeople, window dressers, store decorators, cashiers. You, who build ticketing and support systems, you already replaced human attendants. You, who build delivery systems, already replaced telephone operators. You, who build financial systems, already replaced bank clerks, the people who build bank branches, etc.

You, programmer, have always worked replacing other people's work. It was a matter of time until programmers replaced the work of programmers. Call it **poetic justice**. It is just evolution. It happens. Nothing in the world is made to be static nor guaranteed.

Here is the good news: as always happens. There are still painters, even though there are photographers. There are still salespeople, even though there is e-commerce. There is still construction, even though there is not as much need for stores or even offices (with home office). There still exist and will continue to exist, doctors, lawyers, accountants, several professions. The difference is that before, an accounting firm needed a building full of people who knew how to use abacuses and write spreadsheets on paper. Today a single accountant who knows how to use Excel replaces an entire floor. In the old days, an advertising agency was an entire building, today it is one person using Canva, CapCut and Photoshop.

Programmer is the same thing. Before it was an entire building with a purple ball pit. Tomorrow it will be one, GOOD, programmer with Cursor and Aider. Who disappears in this game? Whoever did the low-value-added grunt work.

I warned this was going to happen. For 5 years, before this generation of LLMs and AI even existed. Because it is the natural course of things. The weekend online course programmer. That is the first one who is going to disappear.

Do you know calculus? Do you know Algebra? Do you know Linear Algebra? Do you know Probability Statistics? Do you know what a statistical distribution is? Do you know what vectors or tensors are? Do you know what a Hilbert space is? No? I would take precautions if I were you. If all the articles I published this month of April/2025 were very difficult, you already know what you need to study.

### My Experience with LLMs

I have been using LLMs for 2 years. Every kind of research or code I do passes through some LLM in some capacity. I use it heavily, really. My ChatGPT history is gigantic.

And after doing another intensive round to make sure. Yes, o4-mini-high, Sonnet 3.7, Gemini 2.5, Qwen3, Deepseek-R1, etc are all extremely useful and none of them, absolutely none, can satisfy me.

Vibe Coding is enormous nonsense. Nobody without programming knowledge can build more than super simple software (and full of bugs) using only LLMs and prompts or MCPs. That is a fact.

_"But evolution is exponential, next year it will be perfect."_

It won't. I already argued that point above.

_"But the benchmarks say they already manage to produce 99% perfect code."_

I already argued that point too, your interpretation is mistaken.

We are near or already at the beginning of the top of the "S" curve. And I see no problem at all with that. I understand how LLMs are made, I understand how they are optimized, I understand what they can do and, more importantly, I understand what they are incapable of doing.

Look at the [pull requests](https://github.com/akitaonrails/Tiny-Qwen-CLI/pulls) of every attempt I made to do code refactoring and unit tests with the main LLMs on the market, open and closed. What I see:

- it needs LOTS of prompting and lots of instruction to get them to start spitting out code that works.
- they look like an intern, the famous "it works on my machine". They come out spitting, a bunch of copy-pasted code, and don't re-check whether it makes sense or whether it was needed. The amount of useless code they generate is scary.
- they repeat the same mistakes, even when warned not to commit them.
- even with "agents", "MCP", even running the code that was generated and giving the error stacktrace, they easily lose focus, lose attention and cannot fix it. Even retrying multiple times to fix the same error. Even giving hints. Even writing at length what is wrong. They quickly enter a loop. Especially if the so-called "thinking" is enabled. They think too much and don't solve it.
- I'm tired of seeing attempts to randomly go around tweaking the code, in parts I didn't even ask them to touch, and breaking more than fixing.
- none of them was able to generate unit tests that work on the first try. Some managed to write a few simple ones, after giving them the error and asking them to fix it. Some get stuck in a thinking loop, confused, and go around changing things without fixing. In the end they fail.
- Out of nowhere they start hallucinating. Qwen 3 itself, if I try to raise temperature just a bit, from 0.1 to 0.2, out of nowhere Chinese characters start coming out in the middle of the code, like this:

![chinese char](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/j0rnlba6loxmo32pyyjxy8diteor)

- Every now and then, more than one LLM pulled off the feat of generating a unit test that gave a recursive error. This filled the stacktrace so much that if I tried to pass it to the model (over 12 thousand tokens), it would blow the context window and from there it couldn't pay attention to anything else:

![recursive error](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/eqh6ytb84mvcpzr92dk7kge2exaj)

- since they mess up a lot, I repeatedly and exhaustively give it chances to fix things. I run the code it generated, send the error stacktrace, ask it to fix. It touches another part of the code. I run again, it errors and I repeat. If you do this more than half a dozen times, the context starts filling up, sliding window makes it split attention, it "forgets" what came before, starts repeating the same error and stays there forever.

- it does not matter whether it supports 8 thousand tokens, 30 thousand tokens, 100 thousand tokens or 1 million tokens of context. That did not influence the quality of the code nor improved this routine of error repetition. It never manages to pay attention to everything.

- there is no point trying to tune key sampling. whether with temperature 0, 0.1, 0.6. It only makes it err a little later or a little earlier, but it quickly errs and quickly becomes unable to fix its own mistakes. Tools like Aider take the code it suggested and write it over the real code file. Several times, from filling the context too much, it starts to "forget" and delete chunks of code. Thank goodness GIT exists, because several times I needed to run `git checkout` to go back to the beginning. If you don't check, be careful, it deletes code or overwrites it with nonsense, and this is frequent.

- deep thinking/reasoning/chain-of-thought, whatever you prefer to call it, just means it spends a lot of time thinking in excess and filling the context with filler, eating up your tokens. If it's your commercial API, be careful: you will burn through your credits very fast and the result is not significantly better. There are isolated cases where it helps. I recommend leaving it off by default and turning it on only in a few special cases.

And look: my example project is ridiculous: it is 5 files. 4 of them have fewer than 100 lines of code, the biggest one has 400-something lines. A real, large project is MILLIONS of lines of code. It does not fit in any context window of any Gemini or Deepseek. And even if it did fit, it would only make the model more confused. The good practice in any tool is to give it the minimum number of files. And that restricts the use cases to local and isolated refactorings, never things like renaming a class or function that is used in hundreds of files. For that, keep using your IntelliJ.

No model I tested is perfect. Some models do a bit better in some cases. On the first attempt I made with Gemini 2.5, it actually managed to perform the tasks I asked. It did not produce marvelous code, but at least it didn't break anything.

The second time, I ran `git reset --hard` and started over, with the same files and the same prompts. This time it was extremely disappointing. It broke the main code during the refactoring and was unable to finish a unit test that works, even though I forced it several times. I gave up out of exhaustion.

The third time, it gave a different result, improved the code a bit and managed to finish the same test. But it also required a few rounds of broken tests, giving stacktraces and asking it to fix obvious errors. And when I say "obvious" it is for it to fix a mock that it itself had placed without needing to.

And this is consistent across all the other models. If I run it only once, I get an impression. For example, that Claude is better than Qwen3. But if I run it again, the same test, now Claude disappoints me and Qwen3 jumps ahead. There is never an objectively better winner. They are all more or less at the same position and keep shuffling in the ranking depending on how many times you repeat exactly the same test, with the same code and the same prompts.

And who keeps repeating the same thing? Nobody. Everybody accepts the first answer. And the first answer can be QUITE wrong. At an obvious level of wrong. If you accept it automatically, you will insert garbage into your repo. And that is my problem with things like MCP or agents: if you leave everything on autopilot and ask things like "take all the code files in this directory and fix every bug". It will, with full certainty, generate more bugs, delete code, vanish files and leave the final repository in a worse state than before.

Pure Vibe Coding, with zero interaction from a programmer, does not work. I tested all the main models. None was able to pass simple tests. None will be able to pass real larger tests. Not without a lot of interaction from a good programmer to reject errors and demand it try again, or manually fix what came out wrong.

And guess what: a coder who only knows how to copy and paste from stackoverflow (and now from ChatGPT), is unable to recognize many of these errors. So instead of helping, he may make things worse.

For me, who knows exactly what I want, the errors are obvious and I automatically reject them. And I reject what every LLM does more than I accept. Many times I just grab a snippet of what it suggested and discard all the rest. That is the real day-to-day. Everyone who says otherwise has not written code more complicated than a Hello World.

Why do you think every example of _"wow, look at the LLM writing code on its own"_ is always writing a factorial function? Or a crappy web page? Because that is all it actually manages to do. No MCP example I have seen so far has impressed me. It was all smoke. And you got fooled by the propaganda.

Now you know.

How do you learn more and avoid getting fooled? Start by learning the fundamentals. 1 year ago I made several videos explaining how LLMs work. You should already have watched them:

[![Playlist I.A.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/7tshjfwbly7wudczbni2pa863f11)](https://www.youtube.com/playlist?list=PLdsnXVqbHDUeowsAO0sChHDY4D65T5s1U)

And how to become a programmer who will not be replaced by AI? That is what I made [my channel](https://www.youtube.com/@Akitando) for. When everything I said becomes common knowledge for you, congratulations, you have a good chance of surviving.
