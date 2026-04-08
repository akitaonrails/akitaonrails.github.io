---
title: "RANT: Did Akita Bend Over for AI??"
slug: "rant-akita-caved-to-ai"
translationKey: rant-akita-caved-to-ai
date: 2026-02-24T11:54:26+00:00
draft: false
tags:
- vibecode
- rant
  - AI
description: "I have been 'bending over' for AI since 2023. If you only watch out-of-context podcast clips, let me spell it out for you."
---

> **TL;DR**: I have always "bent over" for AI. But if you only watched clips from the podcasts, I get why you are confused. Let me explain.

Anyone remember this video of mine: ["16 Languages in 16 Days"](/2023/09/20/akitando-145-16-linguagens-em-16-dias-minha-saga-da-rinha-de-backend/)? It is from late 2023 (1 year after the first ChatGPT launched) and it is about the first Rinha de Backend. How do you think I wrote code in 16 languages in 16 days??

I have been using AI to write code since early 2023 (3 years already). I did not start now: I never stopped. 🤷‍♂

*"But you said AI would never be any good, you hate AI"*

That is what you understood because you are lazy and only watch out-of-context clips or out-of-context tweets. If you read my blog, I have literally dozens of posts (particularly in the last 2 years) detailing every aspect of the evolution and use of AIs (whether for code, images, or 3D modelling).

## "Hype?"

And what about my famous line:

> **"Your hype about AI is inversely proportional to your knowledge of AI"** ?

Still correct. Same as the people who used to say Low Code would replace every programmer. It will not. Same thing now: no matter how good AI gets, it is not going to replace every programmer. Only the bad ones, as I already explained in [this other rant](https://akitaonrails.com/en/2026/02/08/rant-ia-acabou-com-programadores/).

Programmers like me have zero problem: we are the decision-makers who can decide what AIs cannot today and never will (it is an impossibility baked into the foundations of computing, I will come back to that).

The "hyped-up" crowd I talked about is every non-programmer startup bro who - with or without AI - throws garbage code into production and that is how things like the **"Tea"** app fiasco happen, remember?

[![tea leak](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/tea.jpg)](https://www.npr.org/2025/08/02/nx-s1-5483886/tea-app-breach-hacked-whisper-networks)

There was no "hacking" attempt at all; their database was already wide open to the public in production: anyone could just download it. That is a "hyped about AI" guy.

Or the morons who already fired all their programmers because they think AI code will be so much better. Spoiler alert: it will not.

So now you are even more confused. *"You don't like AI then?"* No, no, I like it. *"But if you like it, it means it is already intelligent?"* No, no. See how your line of reasoning makes no sense.

## "Stochastic Parrot?"

Someone reminded me today that I also said:

> **"AI is just a glorified text generator"**

Confused? *"How can it be good if it is just a text generator??"*

I really do not understand this line of reasoning. Text generators are objectively good. You and I use the auto-corrector on every email and messaging app every day. Whether it is the iPhone or Android keyboard. Whether it is Grammarly. None of you will say it has "personality" or even "intelligence," but I think we all agree it is very useful. Even when it slips up now and then, most of the time it fixes our text just fine, right?

GPT or Claude or GLM or Gemini or DeepSeek, all of them are still "stochastic parrots" or "glorified text generators."

* Stochastic parrot: something that repeats stuff using a random or partially random method (there is an element of entropy)
* Text generators: they use probabilistic math (transformers on the complicated side, or Markov chains on the simple side) to try to figure out the most likely next word/token, given the preceding text.

Every "AI" (more correctly "LLM") has worked exactly like this from their launch in 2022 until today: gigabytes of hyper-dimensional matrices of weights and probabilities where your text/prompt is computed against those matrices to pick the "next token." Concatenate that new token onto the original text and recompute everything again against the same matrices (more correctly, tensors), **draw** the next token from a small group of probabilities, concatenate, repeat, and so on.

That is a "text generator." But yes, they are so good that they "seem" to have personality in their replies. And human beings are very easily fooled into "anthropomorphizing" non-human things. It does not take much.

Back in 2023, in the video ["Understanding How ChatGPT Works"](/2023/06/19/akitando-142-entendendo-como-chatgpt-funciona-rodando-sua-propria-ia/) I explain the Turing Test, one of the first "conversational" apps that passed the test, ["Eliza"](https://en.wikipedia.org/wiki/ELIZA), which already passed it without needing AI at all.

That is why I said they are "glorified," because everyone who has little knowledge of AI thinks of it the way the ape in the movie thinks of the monolith: as a divinity that must be glorified.

![2001 a Space Odyssey](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/2001-a-Space-Odyssey.jpg)

## "But What About Flow?"

*"But Akita, on Flow you were against AIs."*

Nope, again, you only watched clips. Look at how I open the conversation: I am talking about the hysteria around the ["AI 2027 Report"](https://ai-2027.com/), I am talking about Sam Altman's nonsense that they were very close to hitting "AGI" (General Artificial Intelligence, an intelligence that, like a human, reasons and decides things on its own and is capable of evolving autonomously). And all the controversies about AIs coming up with a "plan" to kill their owner (what I call "fanfics").

Then I spend hours explaining in detail the history and exactly how the "next token calculation" is done, as I also [gave more details](/en/2025/04/29/dissecando-um-modelfile-de-ollama-ajustando-qwen3-pra-codigo/) here on the blog. And I always say there has to be some "new breakthrough" (that has not happened yet). As long as every new GPT or Claude is just an evolution of the previous one, there are limits. And I explained the limits.

It is not a "matter of time." That does not exist. Even though we have never been to, say, Saturn, we know what it takes and more importantly: how much it costs. **"WITH TODAY'S TECHNOLOGY"** - which is always the premise - there is no practical way, it does not make sense.

Tomorrow some "new breakthrough" may appear that changes everything. But until it shows up, we cannot "count on it." And my entire explanation is based on that premise. And the conclusion is objective and mathematical:

> AGI is not achievable. That has not changed.

It does not mean current AIs are **USELESS**. That is the counter-conclusion whose reasoning I cannot understand either. On every podcast after the first one, I would come back saying: *"The way I talk, some people seem to understand that I do not like AIs, but it is the opposite: I like them."*

I got tired of repeating this on the podcasts, on the blog, on X, but that is the part everyone pretends is not there and **OMITS**. That is why I always put everything in writing here on the blog and, as I said, you can see I was already using it back in 2023 - 3 years ago.

> In summary: EVERYTHING I said on the latest videos of my channel and on the podcasts **STILL HOLDS**. The explanation is still correct. What is wrong are YOUR CONCLUSIONS. Review them and interpret them literally and not subjectively, with the lack of knowledge you people have. Do not ignore the terms I used that you do not understand. The argument only makes sense if it is complete, and it cost me 4 hours to explain it in each video.

## A Message to the "Hyped"

I said this on X the other day:

[![agile vibe code](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-24_12-23-27.jpg)](https://x.com/AkitaOnRails/status/2025649633318555812)

It does not matter if you want to call it "Vibe Code," "Agentic Engineering," "AI Assisted Programming," it is all **bullshit**.

EVERYTHING now is "programming with AI."

And there are only two ways to do it: the right way and the wrong way. The wrong way is the way you and the owner of the Tea app (probably, allegedly) do it: you let AI write the code, you have no clue how to review it or criticize it, you push it to production and let users use it, with no idea of the risks.

The right way: I spent TWO MONTHS writing more than TWENTY POSTS on this blog explaining the right way, which I called "Agile Vibe Code," but it is basically **"Software Engineering applied to AI"** and guess what: you need to have studied and have experience to know it.

It is not 2026 and it will not be 2027 or anywhere near as soon as you think before Claude or Codex "replace ALL programmers." No, they WILL replace all the bad ones and that is excellent! Again, [read this rant](https://akitaonrails.com/en/2026/02/08/rant-ia-acabou-com-programadores/).

You are never going to build a "new Linux" and "replace Linus Torvalds" with AI. You will manage to "copy parts," sure. Copying is not enough. Bad programmers were already copying before, and it never made them good.

## A Message to the "AI Haters"

Give up, this is a one-way street. Same as mobile, same as the internet, same as microcomputers, etc. Pandora's box is open, there is no closing it anymore. AIs are here to stay.

> *"But you said AI was a bubble that was going to pop!"*

Again, either you are playing dumb or you are dumb.

The 2001 Internet Bubble popped, but the Internet did not disappear. On the contrary, it grew! What disappeared were the companies that thought they would make easy money riding the bubble wave, and everyone who blindly believed in it. Still, whoever was an **"Internet Hater"** lost out too.

At this point, every anti-AI argument already sounds like a lousy excuse. Let's look at a few:

*"AI makes lots of mistakes, every now and then I see some half-assed code."*

True, and that is exactly why I said not to get hyped for nothing. It makes mistakes, I catch them every day. Up until last year, the error vs. success rate was high enough that I could not recommend any amateur use it on a daily basis. Only someone who pays close attention and knows how to fix it - like me.

However, in 2026, that rate has improved significantly. It does in fact hit more than it misses now, enough for me to trust it without "micro-managing" every step.

The truth is every human programmer makes mistakes, and they make MANY. Whoever makes mistakes has confirmation bias and does not think they mess up that much. Only someone watching from the outside - someone like me, who has managed hundreds of programmers across dozens of projects - knows they screw up much more than they are prepared to admit.

I GOT TIRED of asking people to only push PRs with unit tests: everyone ignores it.

I GOT TIRED of asking people to at least run it once on their own machine to see if it works, instead of me pulling the PR and finding out it does not even run: everyone ignores it.

I GOT TIRED of asking people not to just copy and paste from stackoverflow, and at least adjust and adapt it for our project. Everyone ignores it.

I GOT TIRED of asking people not to dump everything into the same giant file and to refactor from time to time so technical debt does not pile up: everyone ignores it.

I GOT TIRED of asking people not to push more commits with messages saying "bug fix," without explaining what is actually in there: everyone ignores it.

I GOT TIRED of asking people to remember to update the documentation when they change some feature, to make it easier for whoever is going to test it: everyone ignores it.

I GOT TIRED of asking people to cover a bug fix with a regression test so we would not see the same error again. The same error kept repeating: everyone ignores it.

I GOT TIRED of asking people to follow the conventions we agreed on in the project and not write different code with different patterns. Everyone ignores it.

I GOT TIRED of asking people to adjust deploy scripts, CI or things like that when there are pieces that affect the infra: everyone ignores it.

I GOT TIRED of asking people not to pile up a bunch of code that makes no sense together and not to `git add .` at the end and just write "new feature" and commit everything together. Everyone ignores it.

These are just a few examples. Know what is new: Claude and Codex do not ignore. Everything I just listed, which happens on EVERY project with humans, no matter the size of the project, does not happen to me anymore with Claude.

Understand: all of this should be the basics of the basics, intern level. But I GOT TIRED of asking seniors to be more careful, to not set a bad example for the juniors: EVERYONE IGNORES IT.

And now, all these people who WORE ME OUT, are precisely the ones who became "AI Haters." But of course, the AI does everything they DO NOT. Look in the mirror and reflect on whether your code was really that good (Spoiler: it was not).

90% of all code produced is nowhere near something like "optimization of the Linux memory management solution" or "bug fix for a performance regression in the file system drivers" or "improvement in the firewall security algorithm" or "rewriting this old Assembly part in C"..

90% of most code produced day to day is **MUNDANE**, it is consuming an API, it is writing a front-end, it is one more report, one more CRUD, one more email validation, one more cleanup job, one more deploy script. Absolutely NOTHING actually "interesting."

What did I like about LLMs? It REMOVES from my plate all the mundane tasks and lets me focus on the parts I like: research, forming hypotheses, benchmarks, a/b tests so I can make better decisions, integration tests that make sure the various parts of my system actually work. Everything I could not do before, because 90% of my time was spent fixing somebody's crappy CSS.

I HATE messing with CSS. It is about time I did not have to anymore.

I HATE writing CRUD. It is about time I did not have to anymore.

I HATE doing the initial dev environment setup for every different project. It is about time I did not have to anymore.

I HATE having to spec out idiotic things like mapping fields on a poorly designed fintech/bank API. It is about time I did not have to anymore.

I HATE having five hundred poorly designed front-end frameworks to stitch everything together and pray it works through trial and error. It is about time I did not have to anymore.

I HATE having to attend sprint meetings, where what was asked for keeps getting modified along the way because nobody paid attention. It is about time I did not have to anymore.

I HATE being blocked, having to wait around because another dev or another team is working on something that affects my side and in the end I will spend days later just fixing merge conflicts by hand. It is about time I did not have to anymore.

Who are the "AI Haters": exactly everyone who used to block me before, the ones responsible for dragging out and delivering in bad quality all the MUNDANE tasks, and thinking they were doing something big.

## What History Has Taught Me

Computers understand machine instructions. They do not give a damn about our "favorite languages." That is what I spent hours explaining on the podcasts and in the videos on my channel.

Fuck your favorite language/framework. Fuck your favorite design pattern. At the end of the day, the machine only cares about the binary that is going to run.

Back in the day, it was extremely costly to feed those instructions to the machine. We had to literally key in, bit by bit, each instruction, at the exact address in memory. Whether with WIRES or with SWITCHES, ONE BIT AT A TIME:

![eniac](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/7972f02c9ad7fe9bc30d1493b1295188.jpg)

![Altair 8800](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/NV_0103_Driscoll_Large.jpg)

Fortunately, things evolved and we improved the ways of "INPUTTING" instructions and data. Whether with punched paper or teletypes (electric typewriters adapted as dumb terminals):

![punched card](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/s-l400.jpg)

[![teletype](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-24_12-55-27.jpg)](https://www.youtube.com/watch?v=zeL3mbq1mEg)

Programming was expensive, because it was VERY costly to "fix" an error. There was no easy "backspace." The moment you went to type, you had to be VERY SURE of what you were going to type, without screwing up!

Even by the late 70s, early 80s, it had already evolved a lot, but having permanent storage was an OPTIONAL thing on most "micro" computers. We had to type the programs in from scratch to run them and when the machine shut down, whatever was in RAM was wiped and we lost everything. Recording was expensive, and one of the most popular options was recording to cassette tape:

![c64set](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/c64set.jpg)

But to record/read just a measly 1 kilobyte of data, it could take MORE than 20 seconds. A little 10-kilobyte game (which is very little), would take almost 4 MINUTES to load.

You have no idea what 10 kilobytes means. Any PNG or SVG icon or any stupid little JS file on your website has way more than that.

All this to say the following:

- computers run machine instructions, to this day
- it has always been costly to feed those instructions to the computer

Nowadays we have NVME SSDs that let me read 1 gigabyte today (<70ms) faster than I used to read 10 kilobytes in the 80s.

But to compensate, our programs kept getting more and more complex and "bloated." Once memory, storage, data bus, everything became orders of magnitude faster, we humans kept throwing more and more data at them. A text editor today does the same thing a text editor in the 80s did: edits text. But, of course, it has way more features: pretty fonts, smooth scrolling, auto-correct, auto-format, etc.

We traded resources for comfort, and that is a good thing.

I said in my videos, in the recent rant posts, that it was a very bad thing that the startup bubble only popped in 2022 (and its aftershocks are still going today). We traded programming efficiency for cheap bad programmers. Why bother trying to be more efficient if it was "cheap" to just throw more "bodies" at the problem? The same mentality that enabled the rise of cheap software sweatshops in the 2000s, cranking out bad software like there was no tomorrow.

Personally, I am very happy we finally took one more step toward feeding instructions to the machine more efficiently. LLMs, our stochastic parrots, are, in fact, the most efficient way to produce 90% of the instructions we need to give the machines so they can compute what we need. Same way I do not miss punched cards, or teletypes, or cassette tape, if I do not need to use an IDE in my day-to-day anymore, I will not miss it.

> I did not choose to become a programmer to become an IDE operator. When I started, the concept of IDEs did not even exist.

I chose to become a programmer because I like the idea of instructing a machine to compute the things I want. Whether it is a spreadsheet or a game. HOW those instructions are input is not the main thing for me. It never was. IDEs were just a small phase within decades of career and they will not be the last.

> I do not understand the reasoning of the over-hyped or the over-haters. Why do you need to glorify a hammer? Why do you need to hate a hammer? That is all I needed to say 🤷‍♂

## Some Idiotic Excuses

*"But Anthropic (or OpenAI) are evil"*

Fuck that. Microsoft was too, it even went through an anti-trust trial in the year 2000 that almost split the company. Even though I prefer Mac or Linux today, has Windows stopped being the most used operating system in the world? No.

*"But AI uses a lot of energy, what about the environment?"*

Fuck that. This was never a consensus (and most likely never will be and is not even a problem). The planet has already gone through 5 or 6 great extinction events before, the last one was a meteor that fell and wiped out the dinosaurs. We have gone through multiple Ice Ages. The planet is going to be fine, don't worry.

The problem of the last decade was the stupidity of not investing in more nuclear power plants - and now that option is finally back on the table. I said on Flow that Germany shutting down theirs was one of the dumbest decisions of all time, and I stand by it: it was.

Those are the two most common ones I can think of today. But that is how it is: anything is an excuse now. Pandora's box has been opened, there is no going back.
