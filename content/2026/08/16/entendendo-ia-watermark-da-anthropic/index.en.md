---
title: "Understanding Anthropic's AI Watermark: How to Beat It"
slug: anthropic-ai-watermark-how-to-beat-it
date: '2026-08-16T16:00:00-03:00'
draft: false
translationKey: entendendo-ia-watermark-da-anthropic
description: "Claude now stamps everything it writes with an invisible statistical watermark, a requirement of European AI law. How it works, what the AI Act demands, and the rewrite in another LLM that wipes the signal."
tags:
- llms
- security
- law-and-regulation
---

Claude now ships with a stamp on it. Since August 2, 2026, Anthropic has been invisibly marking the text of its newest models, with the older ones migrating over the following months.

No off switch. The backlash came fast: a [wave of subscription cancellations](https://www.businessinsider.com/claude-users-cancel-subscriptions-citing-anthropic-new-ai-watermark-2026-8), with cancellation screenshots making the rounds on X.

Before you cancel on reflex, it's worth knowing what the mark actually is. It works quite differently from what most people picture, it exists for a concrete reason, and it vanishes with an almost comic ease.

For those in a hurry, the essentials:

- **A statistical bias in the words Claude picks.** Invisible to the reader, detectable only by whoever holds Anthropic's key. Hidden characters and strange fonts stay out.
- **The origin is European law, the AI Act.** Anthropic signed the EU transparency code and chose to stamp the whole world; the why comes below.
- **One pass through another LLM erases the stamp.** The signal lives in Claude's word choices; when another model rewrites the text, even a weak local one, the choices become its own and the pattern dissolves. Anthropic itself admits this.

Each point in detail below.

## What this watermark actually is

Strike the invisible Unicode character, the hidden space mid-line, the altered font. Anthropic's watermark is [statistical](https://www.anthropic.com/news/claude-text-watermark): it acts at the moment Claude decides which word to use, precisely at the points where several words would serve equally well.

Every language model assembles text one word at a time, pulling the next from a list of likely candidates. When two or three work equally well, a random number settles it. The watermark changes where that randomness comes from: the number now derives from a secret key combined with the preceding words. The method is inherited from [SynthID-Text](https://ai.google.dev/responsible/docs/safeguards/synthid) at Google DeepMind.

A concrete example. Talking about the weather, "the sky was overcast" and "the sky was grey" carry the same information. At these synonym junctions, the key leans Claude one way more often than pure chance would. Each individual choice goes unnoticed, but a long text repeats this decision point hundreds of times, and the whole ends up forming a statistical signature.

Anthropic's announcement is blunt: **the text gains nothing, and no character stays hidden**. The cost stays the same because no extra tokens are generated, and the reading is identical. Whoever holds the key runs a detector, compares the sequence of words against Claude's typical choices, and gets back a probability that the text came from Claude.

And what the mark proves boils down to this: Claude **was involved** at some point. It doesn't distinguish text the model wrote from scratch from text it merely edited heavily. About you, nothing gets recorded: no user, no company, no identified conversation.

The stamp covers text in Claude.ai, the API, Claude Code, and the other products. In code it shows up less, since code rarely lets you swap one term for an equivalent. Files and images take a different route, a signed piece of metadata called C2PA, instead of this text watermark. And the limitation matters: on short or highly factual passages, where almost no word choice exists, the detector weakens.

## Why so many people canceled

The spark added up three ingredients: mandatory, global reach, and no opt-out. The mark can't be switched off and applies outside Europe too. A wave of Claude Max subscribers [canceled citing control and authorship](https://www.forbes.com/sites/maryroeloffs/2026/08/11/claude-will-put-invisible-watermarks-on-ai-text-and-images-and-the-internet-isnt-happy/) of their own material.

The fear is concrete, professional and academic. Drafting with Claude and signing the result as your own becomes a liability if, down the road, a detector points at "went through AI". [Anthropic answered with a post](https://gizmodo.com/anthropic-explains-its-watermark-system-as-some-claude-users-loudly-revolt-2000799022) insisting the mark preserves reading, meaning, and quality, only signaling processing. Not everyone bought it.

## The European law behind the stamp

The stamp was born of a concrete obligation. [Article 50 of the AI Act](https://artificialintelligenceact.eu/article/50/) requires providers of generative AI systems to mark output in machine-readable form, so artificial content can be identified as such. The obligation took effect on August 2, 2026, and violating it costs real money: fines up to €15 million or 3% of annual global revenue.

Back in July 2026, Anthropic had signed the European Commission's Code of Practice on Transparency for AI-Generated Content, alongside other major model providers, in a group of roughly 190 signatories. The others will implement their own watermarks too, each with its own key and its own method.

That left Anthropic with a decision: restrict marking to Europe or extend it to the whole planet. The company says it still has no durable way to scope the mark by region, so it chose to stamp everything, everywhere, from day one. Hence the stamp showing up in the text of Brazilian and Japanese subscribers, who have nothing to do with European law.

## Can you remove it by passing the text through another LLM?

That's the question I get most. Short answer: yes, and it's easy. The signal lives in Claude's word choices; when another model rewrites the text, the choices become that model's, and the statistical pattern comes apart.

Anthropic itself admits it. Light retouching probably leaves pieces of the mark, but **a complete rewrite, with every word swapped, kills the signal**. The logic is simple: the detector measures which synonyms Claude preferred; if another model picked its own synonyms, there's nothing of Claude left to measure.

Academia confirms the direction. [Robustness tests of SynthID](https://arxiv.org/abs/2508.20228), done at Queen's University, start from perfect detection with no attack and show the rate dropping to around 84% after a dedicated paraphraser, and below 70% with round-trip translation. The more aggressive the rewrite, the more the signal degrades.

And yes, your intuition is right: **a modest model, even a local one, does the job**. Rearranging text while preserving the meaning is a task that calls for zero deep reasoning. A GLM, a Kimi, a small Llama running on your machine rewrites the paragraph and wipes the signature along the way. Swapping "overcast" for "grey" a thousand times is nowhere near needing the smartest model on the market.

Two honest caveats. The rewrite has to be genuine, word by word; a spell-checker pass doesn't come close to counting. And all of this applies to the text watermark: files and images carry that C2PA metadata, which comes off by another method, stripping the file's metadata.

## What prompt would pull this off

Add up the watermark's criteria and the removal prompt practically writes itself. The mark inhabits synonym and structure choices, survives light editing, and needs text of some length. So the prompt has to demand maximum vocabulary and structure swap while holding the meaning in place.

```text
Rewrite the text below in full, in your own words.
Replace the vocabulary and restructure the sentences from start to finish:
pick different synonyms, change the order of the clauses, vary the construction.
Keep the exact meaning, the facts, and the tone.
Avoid reproducing any literal expression from the original.
Return only the rewritten text.

Text:
"""
<paste the Claude text here>
"""
```

Each line targets one criterion. "In your own words" and "replace the vocabulary" dismantle the synonym junctions where the mark hides. "Restructure the sentences" and "change the order of the clauses" break the word sequence the detector compares. "Avoid reproducing any literal expression" seals the gaps a light edit would leave open.

No magic here, and that's by design. Anthropic knows the limit and says it plainly: the mark is soft, attests that Claude touched the text, and disappears in the face of a serious rewrite. It works as a provenance label in a world where most people will never bother to erase it; against whoever decides to erase it, the signal is weak.

## Where this leaves us

In my accounting, the watermark scares less and does less than both sides of the shouting advertise. It's invisible, carries zero data about you, and proves at most that Claude passed through the text. A rewrite in any model dissolves it. It's a deliberately weak provenance label, designed to satisfy European law.

Still, canceling over it follows a logic I understand. Compulsory, planetary marking with no exit door irritates the people paying for the tool. And of the roughly 190 signatories to the European Code, Claude was the first to hit the headlines, absorbing the revolt wave all alone.

If you just want to use Claude and get on with your life, the day-to-day difference is barely there. If you need your text not to scream "AI", a paragraph rewritten in a local model fixes it, and the recipe comes straight from Anthropic itself. The noise ended up much bigger than the hole.

## How this text was made

Transparency suits the subject. The first draft of this article was written by Claude. Then Kimi ran the fact-check, claim by claim, against the original sources, and caught an invented statistic along the way, which we corrected. Finally, GLM rewrote the entire text, word by word, following the recipe from the sections above.

In other words: the article applies to itself what it teaches. It left Claude, passed through Kimi's sieve, and came back with GLM's vocabulary and construction. If the original draft carried the watermark, the complete rewrite swapped the word choices, and with them the signal. With no public detector, nobody can check from the outside; the recipe, anyone can test.
