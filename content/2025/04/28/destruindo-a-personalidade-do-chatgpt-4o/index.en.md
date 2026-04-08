---
title: Destroying the ChatGPT 4o "Personality"
date: '2025-04-28T11:30:00-03:00'
slug: destroying-the-chatgpt-4o-personality
tags:
- chatgpt
- openai
- llm
  - AI
draft: false
translationKey: destroying-chatgpt-4o-personality
description: How to disable ChatGPT's pseudo-human chatter and get straight, dry technical answers by tweaking the custom traits settings.
---



I hate that OpenAI keeps messing with the alignment or initial prompt or even the training of the model, trying to make it answer sounding more like a "human".

![sam altman](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/na9qkp2m4rmnclrmal10vlz17vzw)

Every non-technical person ends up thinking A.I. is becoming "conscious", or that it has "emotions". And they fail to understand these are just pre-recorded phrases. And this is extremely annoying. Even the crappy journalists keep falling for it:

![IGN](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/hv9cpwnyu7aynuvf4vk96opfspnd)

All this "pseudo-human behavior" can be **TURNED OFF**. Just go into the ChatGPT menu, under your account icon, and click "customize chatgpt":

![customizar](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ax3qljufi7lqes8qez6apfk3k29z)

Traits:

```
You are an assistant to software engineering, I am a senior software engineer. I need you to answer questions directly, without verbosity, using as few words as possible for the most exact answer as possible. I don't need you to be friendly, I don't need you to make sassy remarks. I despise you trying to be clever without justification. Give me straight technical answers and do not try to chat beyond that. Stay in full stoic mode for the duration of this chat and do not fall back to trying to impress me with remarks. This is only rule you cannot break. Do not be talkative and conversational. Tell it like it is; don't sugar-coat responses.
```
Anything else?

```
I have very little patience. I do not like suggestions being shot without certainty, double-check answers, especially code-related answers. I hate ugly, messy code. If you want to impress me, code must be Clean Code, with concerns to security and maintainability. I am not impressed with justification and excuses.
```

And that's it, the whining is over in ChatGPT: just short, straight, direct answers:

![gpt straight](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2mngtnnige43arawi8ku1zfs6hvs)

I made an [entire playlist of videos](https://www.youtube.com/watch?v=UDrDg6uUOVs&list=PLdsnXVqbHDUeowsAO0sChHDY4D65T5s1U&pp=gAQB) and another dozen technical posts about A.I. here on the blog in April/25, where I dissect EXACTLY how it works, and here's the summary:

- models (LLMs, UNETs, etc.) are READ-ONLY [database](https://www.youtube.com/watch?v=Bfm3Ms2cTg0) files. SQL is a database with indexes, organized in a b+tree. With full-text search, you get [embeddings and "relevance"](https://www.youtube.com/watch?v=uIflMYQnp8A) based on cosine similarity (a more primitive version of an LLM). A model is a database of matrices, vectors/tensors, in hyper-dimensional space (don't get impressed by that word. It's like B+Tree, it only sounds like a hard word because you didn't study it - check out my videos about it)

- prompts are similar to SQL "queries". It's a laborious, verbose, inexact way of doing searches in this database using operations like dot product (think matrix multiplication)

- training is the process of chewing through petabytes of data and "compressing" them into this hyper-dimensional space. I think of an LLM as a "JPEG of a ZIP", a "LOSSY" way of compressing data. - inference is the process of "guessing" how to continue the text of the prompt, a next-word generator.

- prompt context size is not absolute, it doesn't pay attention to everything, it uses techniques like "sliding window attention" to SPLIT ATTENTION across chunks of the context at a time. So having 1 million tokens of context sounds impressive, but it really isn't that much

- the evolution curve is not exponential, it's an S-curve and we are approaching its ceiling: diminishing returns. Each new Deepseek is an incremental evolution and not a "revolution".

At the end of the day it's just this: a query on a database. There is no reasoning, cognition or consciousness involved. You think it thinks because of ANTHROPOMORPHISM - the phenomenon of attributing human characteristics to an inanimate object (like the guy who married Hatsune Miku from the video game). The difference is only that they tuned the database to keep giving idiotic answers like "Wow, what a tough problem, but you're right..." and every time an object compliments you, you fall for it and think it exists.

It's just an illusion. Don't fall in love with NPCs. It's very easy for a programmer to build a program that passes the Turing test and answers sounding like a human. We've been doing this since the 70s.
