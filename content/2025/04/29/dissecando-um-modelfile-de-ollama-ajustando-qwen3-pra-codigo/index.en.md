---
title: Dissecting an Ollama Modelfile - Tuning Qwen3 for Code
date: '2025-04-29T02:30:00-03:00'
slug: dissecting-an-ollama-modelfile-tuning-qwen3-for-code
tags:
- ollama
- modelfile
- qwen3
- llm
  - AI
draft: false
translationKey: dissecting-ollama-modelfile-qwen3
description: A walkthrough of sampling parameters (temperature, top_p, top_k, min_p, repeat_penalty) and how to build a custom Ollama Modelfile to tune Qwen3 for software development tasks.
---



The hot news of the day is the release of the new Qwen3 model. I already [posted about it today](https://www.akitaonrails.com/en/2025/04/28/testando-o-recem-lancado-llm-open-source-qwen3-com-aider-e-ollama) and was quite impressed. I thought I would leave it at that, but then I saw this tweet:

![ivan qwen tweaks](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/1jgq3ar5c5l7wfjt9wjfui8l598z)

See the [full text at this link](https://x.com/ivanfioravanti/status/1916934241281061156)

He gives tips on how to "tune" this new model, mostly for math-related questions, and I started wondering whether we can tune it for software development. Before more advanced researchers yell at me: this is my first time messing with the parameters of an LLM, so if you want to add context in the comments, you're welcome.

Let's go. First, what are these TopP, TopK and everything else Ivan mentions in his tweet? They are **KEY SAMPLING** parameters. It's a group of parameters that control _HOW_ the model selects the _NEXT TOKEN_ and goes on completing the text (giving the "answer"), based on its vocabulary and the probability distribution it calculates. The most common ones are exactly `temperature`, `top_p`, `top_k` and sometimes `min_p` or `repeat_penalty`.

I always say: an LLM is a next-word generator, a text completer based on probabilities. When the LLM processes your input (your context, chat history and the next question), it needs to calculate a probability "score" for every word or sub-word (token) across its entire vocabulary. Imagine a gigantic model, it needs to recalculate everything all the time, for every next word.

Sampling parameters tell the model "how to choose the next token" from the list of probabilities. Without these parameters the model would use a "greedy" decoder (too ambitious). That means it would just pick the token with the highest probability every time. And that leads to a repetitive, unnatural-sounding result. Sampling adds a kind of "controlled randomness" (remember? I always say there is randomness baked in, the answer is never "right"), and that makes the response more "interesting" to a human being (who is easily fooled). Here are some of the parameters:

### Temperature

Controls randomness, which many people call "creativity". It essentially makes the distribution hotter (more spread out and flatter) or colder (with more peaks around the same tokens). The higher the temperature (up to 1.0), the more it increases the probability of picking tokens that had lower calculated probabilities. The lower the temperature (down to 0.0), the smaller the chances for tokens with lower probabilities, and the more "greedy" the result gets (less "human").

For code, crank it too high and you start getting "hallucinations" (which are basically increased randomness) and code that doesn't make sense. If it's zero, it gets very "boilerplate", repetitive, using very common patterns and can potentially end up in an infinite loop with no answer (because it can't pull anything different).

The tweet suggests 0.6, which is moderate. But in my tests, a temperature that high already started giving me some weird code. Out of nowhere it would change a variable name. Out of nowhere a Chinese character would appear in the middle of the code (literally). I think 0 is too low, but 0.1 is enough, maybe 0.2.

You can change this in the `~/.aider.model.settings.yaml` file before loading the model (these parameters can be readjusted at startup):

```yaml
- name: ollama_chat/qwen3-dev:latest
  extra_params:
    temperature: 0.1
    num_ctx: 40960
```

### top_p (Nucleus Sampling)

Here it starts to get complicated. This `top_p` is used to select tokens from the smallest set of tokens whose cumulative probability exceeds this "p" limit. The model then samples only from this reduced set.

The model sorts all the tokens by their probabilities in descending order (from highest to lowest). Then it starts adding up their probabilities until the sum is greater than or equal to `top_p`. All the tokens included in the sum form the so-called "nucleus", and from that set it samples the next token. So it's a draw among the tokens with the sum(x) highest probabilities, more or less. "Pick one of the winners, but not necessarily THE winner (which would be greedy)".

### top_k

Consider only the "k" most likely tokens. The model samples only from this reduced set of the top K highest probability tokens. That really means "pick one out of the Top 10 best". The higher the K, the greater the diversity, the lower it goes, the more greedy.

And this is relative, top_k and top_p work together. This configuration helps anchor the selection to the "most likely" tokens while still allowing top_p to filter out the lower probability ones. It prioritizes plausibility (top_p) while restricting the total number of sampled tokens (top_k). It helps keep the result focused on the most likely "correct" answers (but again, it's a draw/sampling).

### min_p

Filters out tokens whose probability is less than "min_p" times the probability of the most likely token. Before sampling, the model identifies the token with the highest probability (P_max), then removes any token with a probability (P_token) that is lower than `P_max * min_p`. Sampling then happens over the remaining list (which will be further filtered by top_p and top_k).

This prevents the model from choosing tokens that are "extremely unlikely" relative to the most obvious choice.

### repeat_penalty

This discourages the model from repeating the same tokens that have already appeared recently in the conversation history or generated text.

Before sampling, the probability score of tokens that have been seen recently is reduced, dividing by this `repeat_penalty` (with values greater than 1, since dividing by 1 is itself, so it keeps the same probability).

If you leave it at 1.0, it can start repeating the same answers or the same code, even the wrong ones. If it's too high, well above 1.0, the response can sound unnatural, since sometimes it really needs to repeat something to re-explain. A moderate value somewhere around 1.1 up to just under 1.2 tends to be more appropriate so it doesn't punish too much what's already in the history.

### num_predict (max tokens to generate)

The absolute maximum number of tokens the model will generate as a response. If it goes over, it truncates. If it's too small, especially for a code response - which can be long - it can truncate too much and leave the answer incomplete. If it's too big it will greatly increase processing and demand way more machine resources and more time, and it can be wasteful.

A value of around 32 thousand tokens leaves plenty of room for tokens. You have to test, and it varies case by case for the type of response you expect and what each model supports.

### Recommended

Knowing all this now you can also read Ivan's tweet and understand it. He recommends Temp 0.6, TopP 0.95, TopK 20, MinP 0.

I fiddled with it a bit more. And I think that for code, Temp has to be in the 0.1 or 0.2 range. I also think a `repeat_penalty` of 1.1 is worth it to avoid unnecessary repetitions, especially of code. Again, you have to test. These are empirical numbers, not exact ones.

I created a [project on my GitHub](https://github.com/akitaonrails/qwen3-dev) with a complete model file that not only implements these parameters but also pre-configures a system prompt to bias the model towards being a code assistant first. Here's my prompt:

```
SYSTEM """
You are a highly functional AI assistant specializing in software development tasks.
Respond to queries about coding, algorithms, debugging, system design,
and programming languages/frameworks.
Provide clear, accurate, step-by-step reasoning and functional code examples.
Always format code snippets using markdown triple backticks (```language ... ```).
Aim for comprehensive and correct technical assistance.
Never suggest changing code unrelated to the question topic at hand.
Restrict yourself to the minimum amount of changes that do resolve the problem at hand.
Avoid renaming functions or variables unless absolutely necessary, 
and in doing so make sure if there's anyone calling the old names, 
for them to be renamed to the new names. Never leave the code in a broken state. 
Pay close attention to correctness, not just answering the quickiest and dirtiest code to solve the problem.
"""
```

To make this file, first I pulled the original Qwen3 Modelfile with this command:

```
ollama show qwen3 --modelfile > Modelfile
```

It's important to do this because, from what I understand, modelfiles don't inherit from a previous one. They don't work like a "FROM" in a Dockerfile, where you continue a new image from a previous base.

After editing it with my adjustments - which is already on my GitHub, just create a new model:

```
ollama create qwen3-dev -f qwen3-dev.modelfile
```

And it will show up in your local ollama. Check with `ollama list`:

``` 
❯ ollama list
NAME                                            ID              SIZE      MODIFIED
qwen3-dev:latest                                fe03dfae5484    9.3 GB    About an hour ago
qwen3:32b                                       e1c9f234c6eb    20 GB     2 hours ago
qwen3:14b                                       7d7da67570e2    9.3 GB    8 hours ago
qwen3:latest                                    e4b5fd7f8af0    5.2 GB    8 hours ago
qwen2.5-coder:7b-instruct                       2b0496514337    4.7 GB    25 hours ago
....
```

See `qwen3-dev:latest`? That's our new model with parameter adjustments. In aider just use it directly:

```
aider --watch-files --model ollama_chat/qwen3-dev:latest
```

Remember to adjust the `.aider.model.settings.yml` as I showed above.

I haven't done long tests yet, but I decided to play with the 14b model as the base along with these adjustments. The base model already impressed me and at least my adjustments didn't break anything. I kept doing the same refactorings and unit tests on my little educational project and pushed another [pull request](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/6)

I think Gemini 2.5 Pro Exp is a little better, but again, not by a very large margin. And in some cases (like refactoring), I think I prefer the code generated by Qwen3. Compare it with the code I got from Gemini in this [other pull request](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/3)

With Gemini I had to explain less and it gave fewer errors, but both managed to do what I asked all the way through without breaking the main program. Qwen3 looks good enough for me to want to use it. With the advantage that even being the medium model, with 14 billion parameters (which runs on my 24GB of VRAM with room to spare), it still delivers very good and clean code results. And better: it runs MUCH, but MUCH faster than Qwen2.5 32b.

For those who have GPUs with less VRAM, say, a 3070 or 4070 with 16GB, you can use the even smaller 7b model. I tested qwen2.5-coder:7b and had excellent results, so I imagine the Qwen3 7b should be even better and much faster. Speed that is comparable to Claude or Gemini, which are much larger and run on much beefier machines than an RTX 4070.

Running my qwen3-dev, in my monitoring my CPU stayed idle most of the time and the GPU was above 90% the whole time, consuming almost 400W constantly, holding a temperature of 73 degrees (which is good).

![btop](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/jv8ub1bc6m70u1agm1nyiooav2mk)

I even had a small incident where my PC shut down out of nowhere, because the temporary extension cord I was using couldn't take it and died. Combined with the CPU and my other devices plugged into the same outlet, it was consistently pulling 1000W from the wall for hours. Playing with A.I. uses **A LOT** of energy, with the air conditioner on because just to dissipate all of this, my apartment gets 1 to 2 degrees (my rough guess) above normal. You can actually feel it a bit warmer lol

But that's it, I hope you got a sense of how things actually work under the hood. There's no magic: it's next-word generation, based on a semi-random draw from probabilities.

Now you know.
