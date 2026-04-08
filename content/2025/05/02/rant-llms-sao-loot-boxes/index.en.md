---
title: "RANT - LLMs are LOOT BOXES!"
date: '2025-05-02T19:20:00-03:00'
slug: rant-llms-are-loot-boxes
translationKey: rant-llms-are-loot-boxes
tags:
- llm
- openai
- microsoft
- google
- meta
- nvidia
- mcp
draft: false
description: Why LLMs for real coding behave like gacha loot boxes, and why every incentive in the industry pushes you to burn more tokens.
---



I know this is going to sound way too negative, and once again, let me repeat that I am not anti-AI, anti-LLM, or anything like that. Quite the opposite: I like it SO, SO much that I have been dedicating ALL my hours to researching it in depth.

It has been very useful to me, especially for summarizing papers, reconciling research across multiple sites, summarizing topics, and things like that.

**"BUT .."**

And it is a huge BUT, it has been PRETTY useless for real programming. I am not going to repeat every problem I have already run into: I detailed plenty of them in previous posts. But my conclusion is simple: it can help with code, on small, focused, isolated tasks, with a lot of prompting to help, and you - the programmer - need to be alert about what to pick and what to reject (and you will reject most of it).

Better prompts have limits. RAGs have limits. Loras have limits. Bigger context windows have limits. Using agents that hand back stacktraces and asking for deep thinking has limits. I have already hit EVERY one of these limits, and I have not found any "workaround" that can make it work 100% well 100% of the time - which is exactly what the marketing promises.

_"But Microsoft, Google, Meta, NVIDIA have already stated that 30% of their code is already written by AI and next year programmers will be replaced"_

That is the great half-truth, half-lie (interpret it however you want).

## "What 30%??"

You, who are not a programmer, did you know that project documentation (which is extensive), language translation files (which are extensive, do you know how many languages a Microsoft or Google supports globally?), HTML pages that duplicate that extensive documentation, all of it is "considered" part of the code and sits in the same "code" repository like GitHub?

You, who are not a programmer, did you know that the VOLUME in characters/bytes of that material very often nearly matches, or can even exceed, the byte volume of the actual code itself?

That is just one small example that comes to mind. Launch pages for new products, the "hot-sites" which are DISPOSABLE sites built to be thrown away. That is also code volume. There is A LOT of "code" that is not "THE code". Every programmer who works at a big company knows this.

Your little home project has no documentation, no automated tests, no build scripts, no deploy or packaging automation, no separate language files, no hot-site, no multi-language product site. It is just a "hello.py" and that is ALL of your code. I understand why you extrapolate that a big project is the same thing.

PART of the "30%" everyone keeps talking about is this. Sure, there is some real code in there, but nowhere near what you think.

### Conflict of Interest

I am stunned. If a "drug dealer" gives you a free sample and you ask "but is it safe?", what do you think he is going to answer?

The owner of Meta has AI products. The owner of Google, the owner of Microsoft, RENT OUT GPUs for AI. The owner of NVIDIA SELLS GPUs to AI datacenters. The owner of OpenAI, Anthropic, they all RENT that infrastructure and RESELL you **TOKEN CREDITS**.

What do you think their incentive is? **SELLING TOKEN USAGE**.

You saw what I reported in previous posts. In less than 1 week of testing I burned nearly USD 150 in credits. That would be more than 850 BRL in a week, and after running a HUNDRED attempts I got merely "reasonable" refactorings HALF of the time, and I got good passing unit tests LESS THAN HALF of the time (actually, almost NEVER). But I did spend tokens, LOTS OF TOKENS.

Features that the marketing tells you will improve things, like DEEP THINKING/REASONING, only "sometimes" give better code answers. They really are better at compiling papers or text research. But for code, in MOST attempts, I did not see that much difference. Except it took MUCH longer and burned MUCH more tokens. You know what Deep Thinking does? It adds more steps before the answer and stuffs the context with tokens. Those extra tokens: YOU PAY EXTRA FOR.

Features that the marketing also tells you will improve things, like RAG-based solutions, deep down are just more "prompt injection" - which always burns context and BURNS MORE TOKENS. It works, sure, but the incentive is to burn more tokens.

Features that the marketing is now trying to push on you, like MCP, agents, and LLM automation, combined with RAGs and all the rest. Devin, n8n, and everything else are just a more automated way to BURN MORE TOKENS.

Every incentive, from everyone, is to burn more tokens, not fewer. And in my tests, with many models (I will not say all of them), I got better code answers by **TURNING OFF DEEP THINKING**. You can configure that in tools like Aider or directly in the OpenAI API. Reduce `thinking_tokens` or set `reasoning_effort` to "Low" or, even better, "NONE".

### LOOT BOXES

I also explained in the [article about how to build your own Ollama Modelfile](https://www.akitaonrails.com/en/2025/04/29/dissecando-um-modelfile-de-ollama-ajustando-qwen3-pra-codigo) that, essentially, the text generation process (swallow it, LLMs are next-word generators) has random components. Temperature, Top_P, Top_K. More: the training has non-linear components (e.g. ReLU). It is not deterministic, it is a DRAWING from a probability distribution.

That means, fundamentally, there is no way for an LLM to be 100% right 100% of the time. It is mathematically impossible. It can always be "almost right" or "looking like it is right". But if you diligently double-check everything, all the time, you are going to start finding small mistakes. In the case of code, it is a lot more obvious. It is VERY wrong, MANY times.

And the whole process looks a lot like those "free" online games with LOOT BOXES or GACHA systems, you know? Like a Genshin Impact and friends.

![Loot Box](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/my994es2wx2rj3mfkyu9i6h4s9ik)

What??? You are a boomer and have no idea what Loot Boxes are? ...

I AM A BOOMER AND I KNOW, there is no excuse. Go get up to speed (and it is the main reason I choose not to play that kind of online game).

The economy of those games works like this: you do not have the option of buying the specific items you want. Instead you pay, say, 20 credits for the chance to take part in a drawing (which happens on pre-scheduled dates and times, not all the time). In that drawing you have a (HIGH) probability of only winning a 10-credit item OR an **incredible** (VERY LOW) probability of winning an exclusive 1000-credit item!!!!

Sounds like the deal of the century, right??? (LITERALLY IT IS!!!)

You always win the cheapest item in the drawing. And every once in a while it gives you a MEDIUM item so you do not give up and believe you still have a real chance. Only if you spend A LOT (and by that point you have already spent more than 1000 credits anyway), only then maybe it hands you a big item, to shoot you up with more dopamine and deepen your **addiction**.

That is exactly what happens with LLMs. Their answers have odds similar to a Loot Box. Sometimes it surprises you with an excellent answer, but most of the time you are stuck asking "dude, are you sure about that answer?", or "dude, isn't that second line wrong?", or "dude, re-read what I asked and try again", and your whole day goes on like that.

You are not watching it, but under the hood every time it has to correct itself it keeps burning the same credits. By the end of the day, there goes USD 50. Sounds like a little, but do it every day and see how it adds up.

Except your **CONFIRMATION BIAS** makes you remember well when it got things right, but keeps "forgetting" all the other times it got things wrong. And your perception is that _"Yeah, it works."_

Worse, your low self-esteem and need to belong to a group, to **CONFORM**. Reinforced by what you read in the news every day, like:

- 30% of all Microsoft code is already written by AI
- The CEO of Anthropic says that next year programmers will be replaced by virtual workers
- The CEO of NVIDIA says he would not recommend his son to study programming anymore

And all of it RAISES THE BIAS: you think they are right, and the times you yourself saw the LLM getting it wrong _"must have been a small exception, I am the one who is dumb"_ and you BELIEVE the LIE.

Who remembers my talks from 15 years ago where I used to show this video?

{{< youtube id="iRh5qy09nNw" >}}

This is a well known phenomenon, today amplified even more by social networks and by the dumbness of journalists who just parrot what they hear and no longer ask critical questions like: IS THERE A CONFLICT OF INTEREST??

### "Does OpenAI use your chats for training?"

Here I have to fix a lie I have been telling you all. I always kept saying no. Your conversation is not used for training, because it would pollute the training material with garbage that in the end would not improve the answers.

It is a half-truth. Indeed, I doubt it a lot and I will stake my reputation on it: no provider wants to risk someone finding a copyrighted text and getting sued. That already happens, the New York Times sued because ChatGPT managed to reproduce a text they had published. And that kind of "proves" it was part of the training material.

There are people who paste private things in there like health conditions, financial situation, and even critical data like passwords, addresses, stuff they should not share but end up publishing because they have no clue about cybersecurity. Everybody falls for a scam every day because of that. OpenAI or Meta or Alibaba are not eager to have that show up in a chat one day and turn into a viral international news story about how irresponsible they were.

**BUT**

And it is a HUGE "BUT", yes they do use your chat. Everyone's. Without copying any of your data. They just need the METADATA, the data that describes your chat.

Off the top of my head, being naive and amateurish about training, I can see at least 2 important pieces of information you hand them: the length of your chat and the sentiment of your responses in the chat.

Determining sentiment from text is a well solved problem, there are algorithms with or without neural networks that can tell if a text looks happy, sad, angry, anguished, and so on. They do not need the content of your text, they just need the SENTIMENT you had at that moment.

Add to that the LENGTH of your Chat and as I said [in the previous post](https://www.akitaonrails.com/en/2025/05/02/rant-llms-sao-loot-boxes), the incentive is to make you burn MORE TOKENS (LONGER chats). IN THE NEXT POST I will show you how they do alignment, the model "fine-tuning". An OpenAI uses thousands of lines of prompt/completion pairs to "force" the model to answer in a certain way. Think of an Excel full of pre-written questions and answers that, according to their metadata, we know are the most POPULAR answers.

The goal is not to make the model answer more correctly, because sometimes the right answer is very harsh or inconvenient for some people. I am almost certain that the data extracted from millions of people's chats is just that: sentiment and length. It must help craft prompts that force the model to answer "less correctly" but "more pleasantly", encouraging the user to KEEP talking in the chat and BURN MORE TOKENS.

It is the oldest behavior in the world. Every shopkeeper knows this. Every salesperson knows this. Everyone who works in services knows this. If you are correct and direct, you will sound arrogant and the customer will not come back. Better to sound less correct but more inviting, pleasant, helpful, and so on. And the customer comes back, because that is how the average person works.

So, yes: I do think your data serves to re-align the model after training, to make it answer more pleasantly. They do not even bother hiding it anymore. Did you not see Sam Altman himself a few days ago saying they made ChatGPT 4 answer in a friendlier way, with more personality?

That is what I think they are doing. Making the model smarter is turning out to be a challenge. Because - as I have been saying for a year now - we are hitting the top of the S-curve. To keep selling tokens, to bring you back and get you hooked on talking, it does not need to be smarter, it just needs to be more pleasant.
### Conclusion

There is no LLM that will be 100% right 100% of the time, the fundamental architecture PREVENTS that from happening, no matter how many optimizations we pile on. There is now and there will always be an ENTROPY component. It is that randomness that produces text which sounds like a human talking and not a robot.

Automations that are too long and too complex built on top of this fragile foundation are a HUGE mistake. Sure, for simple, short, focused tasks, it has a higher HIT RATE. For real code? It is SUPER low.

Never let an MCP commit directly to your Git repository. Tools like Aider ship "autocommit = true" by default and that is an enormous stupidity! Do not do that.

I warned you.

But is there no way to improve LLMs at coding? Maybe. 100% never, but bumping up the rate I think we can. And to prove I am not anti-LLM or anything like that, in the next article I am going to try to teach HOW to improve an LLM for programming (with medium probability, it is no miracle!).
