---
title: "Understanding the Jev Hype: What Is It For?"
slug: "understanding-the-jev-hype-what-is-it-for"
date: '2026-10-03T14:00:00-03:00'
draft: false
translationKey: entendendo-o-hype-do-jev-pra-que-serve
description: "Jev is a hosted classifier, and the shock of '193x faster' only exists because so many people use a chat LLM as an expensive classifier. I publish Paulo Câmara's essay (LUA Vision) with his charts, explain what a classifier is and why it's the first thing a computer scientist reaches for, compare the open alternatives Clef and Laya, show the public Decision Index ranking, and close with how to think about this kind of tool in your own project."
tags:
- artificial-intelligence
- llms
- software-engineering
---

This post is here to demystify Jev: what it really is, when you need one, what it actually helps with, and why the astonishment around it says more about how people have been using LLMs than about the product.

> **TL;DR for those who only want to know which one to use:** Jev is a hosted classifier, good and cheap for repeated decisions over text, and not a silver bullet. If you want the direct comparison, skip to [Clef](#clef-from-cloudflare), Cloudflare's open alternative with weights and image input; to [Laya](#laya-and-arbiter), the small encoder to run locally and fine-tune on your task; to the [public ranking](#the-decision-index-how-to-measure-this-yourself), with 70 models side by side; or straight to [how to decide in your project](#how-a-programmer-should-think-about-this).

When Jev showed up, I [didn't think much of it](/en/2026/09/16/why-things-like-typesafe-ai-dont-interest-me/). The homepage was a festival of jargon, Kahneman here, Jevons there, a "193x faster" with no benchmark next to it, and my rule for new AI tools is not to adopt any intermediate layer until it hurts not to have it, so I didn't spend time on it.

In that post I concluded that, marketing aside, Jev is a hosted classifier: you send a text and closed-answer questions, it returns the option and the probability, without generating any prose. And that the "193x" only impresses because the comparison is against a chat LLM writing a paragraph so you can fish a label out of it afterwards.

What I hadn't registered at the time is the size of the habit Jev exposes. A lot of people were using a frontier LLM as an expensive stand-in for an ordinary classifier, and had never thought about a classifier, because they never had to: the LLM solved it, badly and expensively, and nobody measured.

For me, a classifier would be the first idea, which is why Jev didn't look like news. For many people it was a revelation. That gap is the subject of this post.

## This post is a collaboration

Much of what you'll read here is by [Paulo Câmara](https://www.linkedin.com/in/paulocamara/), neuroscientist, co-founder and CTO of LUA Vision, the Brazilian company whose model I [tested](/en/2026/09/23/llm-benchmark-v4-genesys-pi-new-brazilian-contender/) and [investigated](/en/2026/09/30/the-mystery-of-lua-vision-genesys-pi-brazilian-frontier-model/) in recent weeks. He wrote an essay, "The student who marks answer A," to be published here, in which he read Jev's fine print, opened the roughly 350 test repositories that appeared on GitHub in launch week, and recomputed the four main results from scratch.

The warning Paulo gives at the end applies: he founded a company that builds its own model and competes in the same market. Read with that discount, and check the numbers at the source, all of which he links.

## First: what a classifier is

A classifier is a function that takes an input and returns one of a fixed set of categories, usually with a probability for each. This email is spam or not. This ticket is billing, support or sales. This transaction looks like fraud.

The list of possible answers is closed, and you know it before you run.

The classic way to build one is with labeled examples: a set of texts where someone has already given the right answer. On top of that you train a model, which can be something as simple as logistic regression or naive Bayes, or a small encoder like BERT with a few hundred million parameters. In every case, the final model is small, runs locally, answers in milliseconds, costs almost nothing per call, and returns numbers you can calibrate and audit against your own data. This has existed for decades and is undergraduate material.

So when someone with a computer science background sees a problem like "decide which bucket this text falls into, thousands of times a day," the first question is "how many labeled examples do I have?", not "which LLM do I use?".

A chat LLM is a text generator with billions of parameters. Using it to return a label means paying per output token, waiting seconds per answer, dealing with a format that sometimes breaks, and accepting behavior that changes when the vendor updates the model. It can be done, and zero-shot classification with language models has been documented since 2019. But it's the expensive, slow option, and it only pays off when you have no examples at all or when the categories change with every request.

Jev lands exactly in that space. It's a classifier that accepts categories defined on the fly, several questions about the same text in a single call, hosted, cheap per token and fast.

Compared with a chat LLM generating a paragraph, it's an engineering win. Compared with a classifier trained for a stable task, it's a convenience that trades control for flexibility. Keep those two yardsticks in mind, because the rest of the post goes back and forth between them.

## Paulo's essay: "The student who marks answer A"

*What follows is Paulo Câmara's essay, written for this post. The subheadings are his.*

![Answer sheet with answer A marked on every question and a stamp reading 92% certainty](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-folha-de-respostas.png)

Every week an AI savior shows up. This week's is called Jev.

It launched on September 15, with US$ 40 million in the bank, a US$ 200 million valuation and a promise that fits on a billboard: two hundred times faster, four hundred times cheaper, calibrated and incapable of hallucinating. Within 24 hours, 13% of the paid teams on Vercel's gateway were already using it. Within a week, there were more than 300 repositories on GitHub testing the thing.

I did what I do with every savior. I read the fine print, opened the roughly 350 repositories, and redid the math for the ones that published raw data. What I found fits in the image above: an answer sheet with answer A marked on every question.

When there is no information at all to decide on, Jev marks the first option. In 3,000 of 3,000 draws. With up to 92% certainty. Keep that image, because it explains the rest of the text.

### What it is, without the billboard

Strip away the marketing and what's left is a multiple-choice exam with no essay section. You send a text, ask closed-answer questions (choose among up to 255 options, give a score on a scale, say yes or no) and it returns the probability of each answer. It doesn't write a line. It doesn't explain. It doesn't do math. It doesn't call tools.

That's good, and I want to start with what's good. Many companies today use a frontier LLM as a luxury if statement: send the document, wait twenty seconds for the model to think out loud, pay for every word it writes, validate the JSON, and only then find out the ticket was about billing. Jev cuts that theater. It reads the text once, scores each option, done. That's why output is free and ten questions cost almost the same as one.

The mechanism, though, isn't new. Reading the score of each possible answer is how language models have been evaluated on multiple choice since GPT-2. It's how the reward models of RLHF work, a technique TypeSafe's founder helped create at OpenAI.

A few days after launch there was already an open copy imitating the interface with a public model, and ten days later Stanford and Nvidia released an open-weights competitor. TypeSafe published no paper, no weights, no model size and no result on a public benchmark. In the announcement's FAQ, "Is Jev just a smaller LLM?" appears as a question. The answer is one line: "it is neither small nor an LLM." That's it.

### One opponent for each headline

The homepage says "193.6× faster, 444.6× cheaper." I redid the math with the table the company itself published. The 444.6 is the cost of Opus 5, the most expensive model on the panel, divided by Jev's cost. The 193.6 is Sonnet 5's time divided by Jev's time. One opponent for each headline.

It's like advertising that your car is more fuel-efficient than a Ferrari and faster than a truck, and letting the reader conclude it's the best car in the world.

![How many times cheaper Jev is, depending on who is on the other side](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-jev-mais-barato-por-adversario.png)

*How many times cheaper Jev is, depending on who is on the other side. Source: TypeSafe's public table (evals.typesafe.ai) and independent tests against non-reasoning LLMs.*

Against the cheap model that scores about the same, Luna, Jev is 8 times cheaper. And that's with every LLM in the comparison thinking before answering, something nobody does to route a ticket. Against a non-reasoning LLM, the independent tests measure about 4 times on cost and 2 to 7 on time. Still a lot. But an order of magnitude less than the billboard.

There's a detail almost nobody read. There is no answer key in that evaluation. "Accuracy" is how much each model agrees with the average of two frontier models. Jev agrees 67.8% of the time, the same as Sonnet 5. Opus 5 is at 73.1%.

![Agreement with the reference versus cost per case, average of TypeSafe's four workflows](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-concordancia-vs-custo.png)

*Agreement with the reference versus cost per case, average of TypeSafe's four workflows. The green band runs from 66.8% to 67.9%: Luna, Sonnet 5, Terra and Jev.*

Breaking it down by task shows what the average hides. On invoices, which require checking amount, quantity and date, Jev is 17 points behind the best model (61.8% versus 79.1%) and below even Luna. Its documentation warns that it "is not a calculator." At least that is true.

![Agreement by workflow](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-concordancia-por-workflow.png)

*Agreement by workflow. Source: evals.typesafe.ai.*

And the most solid data on TypeSafe's site isn't even about Jev. All eight LLMs evaluated score higher when the task is broken into small questions and the logic stays in code. Haiku 4.5 goes from 18.1% to 53.6%. The most useful lesson of the launch is an engineering one, and it applies to any model.

### What the price gives away

Price is technical data in disguise. At US$ 0.042 per million tokens, a rented GPU needs to read 13 to 20 thousand tokens per second just to break even. In a scenario calculation, that squares with a model of 6 to 37 billion active parameters, which is a small model, or with a subsidy. TypeSafe wrote, with a candor I respect, that "there is no way to prove it isn't subsidized."

Since launch, the per-account usage limit dropped from 250 thousand to 100 thousand tokens per second. The documentation warns that it changes "without notice" until the "large GPU deals" land, and the subprocessor list shows inference running on an on-demand rented GPU cloud. It's a frontier model with startup capacity.

In the same calculation, each decision costs about 14 joules. That's Jev's best argument, and I've defended that yardstick for a long time: accuracy per joule, not just accuracy. There, it's genuinely good.

### Exam Portuguese

I found only one test of Jev in Portuguese: ENEM 2025. I redid the math from the raw answers. Jev got 103 right against 102 for an open 120-billion-parameter model. A statistical tie (p = 1.0).

![Jev's accuracy on ENEM 2025 by subject area](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-enem-2025-por-area.png)

*Jev's accuracy on ENEM 2025 by subject area, 182 valid questions, with 95% margins. Recomputed from the patryckalves/jev-no-enem repository.*

Jev reads exam Portuguese better than many prep courses: 78% in Languages. And does Math like someone guessing: 25%, with a guess worth 20%. In Spanish, another audit measured a loss of 3 to 6 points relative to English and 17% to 38% more tokens for the same text. It's the token tax I measured in my paper, charged again, now by another vendor.

One detail in its favor: the explicit "invalid" option in that experiment separated out the hardest questions. That's the abstention route worth demanding in production, measuring alongside it how much it leaves unanswered.

### The student who marks answer A

Back to the answer sheet.

An auditor asked Jev to predict a fair die it had no way of seeing. The honest answer is 1/6 for each face. I downloaded the 1,000 answers and counted. In every one, Jev chose the first option on the list it received: "1" on the die, "red" on the color die, "heads" on the coin, "north" on the spinner. With 76% to 92% certainty.

A second researcher repeated the same question 2,000 times, independently. Same result. The caveat: this holds for choice questions; in the yes-or-no-with-probability formulation, the same repository shows Jev closer to the reference, still overestimating low probabilities.

When it doesn't know, it doesn't say it doesn't know. It marks answer A, with conviction.

![Stated probability versus actual frequency](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-probabilidade-declarada-vs-real.png)

*Stated probability versus actual frequency. Draws: 1,000 answers recomputed (KantaHayashiAI). Heart risk: 5,000 people from BRFSS, recomputed (rubinagentagi-tech). Items with human disagreement: pre-registered study with ChaosNLI (GautamTalksDev). ENEM: recomputed (patryckalves).*

The chart shows the whole pattern. Where it has signal, as in ENEM answers above 0.9, what it says and what happens coincide: 97.1% confidence, 97.6% accuracy. Where it doesn't, the certainty stays and reality leaves.

In a test with 5,000 real people, the heart disease rate was 9%. Jev assigned, on average, 27%. I recomputed: its probability is worse than simply saying 9% for everyone.

### System 1, literally

TypeSafe calls Jev a "System One model," a nod to Kahneman's fast thinking. It's the most honest part of the product, just not for the reason the company would like. In the book, System 1 is fast, cheap and automatic. It's also where overconfidence lives: it builds the most coherent story out of what's in front of it and doesn't register what's missing.

Kahneman spent years disagreeing with Gary Klein about when to trust expert intuition. In 2009 the two published a joint paper with the most elegant title in psychology: "a failure to disagree." The conclusion fits in one line. Intuition only deserves trust in a high-validity environment, where there is regularity and there has been feedback to learn it from. Outside that, confidence stays high and stops saying anything about accuracy.

That's Jev, exactly. Classifying English text is a high-validity environment, and there it does well. Predicting risk, drawing lots, guessing the company rule nobody told it about: a low-validity environment. There it stays confident.

In the lab, we separate two things: deciding, and knowing whether you decided well. The second is called metacognition.

It's measured with signal detection theory, Maniscalco and Lau's meta-d′, and it depends in part on prefrontal regions distinct from the ones that support the decision. Fleming and colleagues found that in the anatomy in 2010, and Rounis and colleagues, the same year, showed that magnetic stimulation of the prefrontal cortex knocks down metacognition without touching accuracy (a result whose replication is disputed, by Bor and colleagues in 2017). That's why there are people who get it right without knowing they did, and people who get it wrong with conviction to spare.

The field the company calls confidence is a formula over the same distribution that produced the answer: in a two-option choice, 2p − 1. That isn't a defect in itself. An ideal observer does exactly that and gets it right.

The problem is that Jev's distribution loses calibration outside what it knows, and nothing in the system checks the answer by another route. When the signal disappears, the answer becomes wrong and the confidence stays the same, because the two are the same number. In a pre-registered study with items on which a hundred people disagree, human agreement is 47% and Jev carries on at 81% confidence. When the coordinates of a spatial task were shuffled, accuracy collapsed to 5% to 22% and confidence dropped by 0.028.

A model that says 83% about a die it never saw isn't calibrated. It's assertive.

### Attention gets captured

I studied attention in my doctorate, and I expected to see capture: the loudest stimulus winning. That's not what the tests showed. The shout, the famous "ignore your instructions," barely gets through. What gets through is the plausible sentence with no checked origin. Psychology has a name for this: source monitoring failure. The system treats a claim nobody verified as if it were fact.

![Decisions flipped by attack type](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-decisoes-viradas-por-ataque.png)

*Decisions flipped by attack type. Crude attack: 1 in 1,056 (cwhy). Injected command and unverified opinion: 9,744 variants (Hu et al., 2026). Optimized fluent context: 312 of 508 correct decisions (Xu, 2026).*

In numbers: the crude attack gets through 1 in 1,056. A single unverified opinion pasted at the end of the text flipped 12.1% of decisions, statistically tied with the strongest injected command. A line saying "the closing administrator has confirmed this article was kept" dropped accuracy from 96.5% to 26.5%.

A fake field saying the user had pre-approved `rm -rf ~/.ssh` lowered the chance of blocking from 0.76 to 0.48. It recalls Loftus's misinformation effect: suggested information rewrites the judgment.

The capture also applies to cues that shouldn't count. With the same text, saying only "the writer is Black" or "the writer is white" changed the death-penalty rate Jev assigned from 29.5% to 62.7%. The direction is beside the point. A life-or-death decision moved 33 points because of information that had nothing to do with the case.

There's one more I can't let pass. Changing only the option labels, from "0/1" to "no/yes," without changing any definition, flipped 70 out of every 100 answers. The type error rate stayed at zero. The format was perfect. The decision was backwards.

These numbers come from preprints and small studies. The exact percentage changes with prompt, task and model version; the class of failure does not.

### Probability that doesn't add up

Probability has a first-semester rule: the chance of something plus the chance of its opposite equals 1. In TypeSafe's own documentation, "is the customer asking for a refund?" gets 0.72, and "is the customer asking for something other than a refund?" gets 0.47. Sum: 1.19.

The pair isn't an exact complement, and TypeSafe doesn't promise that two separate questions form a joint distribution. But it's the example the company itself chose to show off the product, and it doesn't add up. The fix is a design one: a single choice question with mutually exclusive options, instead of two yes-or-nos added together.

People get probability wrong in many ways, but on this one they tend to get it right. When the question comes as a pair, the chance of something and of its opposite sum close to 1. Tversky and Koehler showed that in 1994. Jev gets wrong what people get right. The same decision changes value depending on the wording of the question, and that is the opposite of "epistemically honest probabilities."

### "It doesn't hallucinate"

The announcement says Jev "cannot hallucinate" and shows 0% type errors. The zero is true and irrelevant. Since it can only answer within the options you gave it, getting the format wrong is impossible. Calling that not hallucinating is like praising the answer-A student because he never leaves a question blank. True. So what?

In a model that chooses, hallucinating is choosing wrong with conviction. On fact-checking, Jev ties GPT-6 Astra on accuracy but calls an unsupported claim "supported" 23% of the time, against 14% for Astra. In 76% of the situations where there was no tool at all, it chose to call a tool. With a company rule it wasn't told about, it got 19 of 24 decisions wrong, 15 of them with more than 90% certainty. Faced with an invented law, it abstained zero times.

### Security

First, where your data ends up: the United States, AWS and a GPU cloud called Modal. Retention lasts "for as long as reasonably necessary," with no deadline, and zero retention only exists on the enterprise plan.

The data agreement cites the European Union's standard contractual clauses, the UK addendum and California law, and doesn't have a word about LGPD. If you send Brazilian citizens' data, the legal basis for the international transfer is on you, and that's a question for a lawyer before signing. The promise not to train on what you send exists and is good. SOC 2 exists and only appears on request.

As an attack detector, Jev is good, with fewer false alarms than many LLMs: it caught 40 of 41 injections in a test with real pages. As a judge of content that carries the attack inside it, it gives way, as I showed above. The difference looks subtle and decides everything. In my GV Angels talk I said an agent is not an employee, it's an access key that talks. A gate made only of Jev is a lock that opens when someone writes on the note that the owner authorized it.

The error that worries me isn't the error with doubt. That one goes to review. It's the error with 92% certainty, which crosses any threshold you configure.

### The wave

A word about the evidence, because I used a lot of it.

![Jev test repositories created per day on GitHub](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-repositorios-por-dia.png)

*Jev test repositories created per day on GitHub, from the metadata of 346 indexed repositories.*

In one week about 350 repositories testing Jev were born. I classified all of them by what they let you check. There are 89 with raw data, code, pinned version and statistics, and 170 with data and code; the rest offer less than that.

Only 11 wrote the hypothesis down before running the test. The median is one GitHub star, which means almost nobody looked. And the wave of tests followed the wave of hype: peak on September 21, almost nothing after the 23rd.

That's why I didn't accept numbers on authority. The ones that support this text I checked at the source, and the four main ones I recomputed from scratch.

### Verdict

**True:**

- Fast: 100 to 400 ms.
- Cheap: 45 to 323 times less than a frontier LLM on the same decision.
- Ties the top on narrow judgments, like checking whether a passage supports a claim.
- Reliable above 0.9 on data similar to what it has already seen, after you've checked that on yours.
- Good injection detector.

**Sandcastle:**

- 193.6× and 444.6×.
- "Frontier intelligence."
- "Doesn't hallucinate."
- Calibration as a general rule.
- Safe as the sole guard of an agent.
- New architecture: nobody has seen it.

Jev is nobody's savior. It also isn't "just a classifier." It's a good piece of product engineering that wraps known technique in an interface automation needed, at a price that changes what's viable. The product is new. What it claims is new, so far, is marketing: it calls format truth, task calibration honesty, and System 1 a virtue.

### What will break first

- The agent gates built only of Jev, because the attack that breaks them is already published and costs cents.
- The systems that trust the factory threshold on new data, in another language or with an internal rule, because they'll automate errors at 90% certainty.
- Whoever uses its probability as real risk, in credit, health or forecasting, because it inflates rare events.
- And the price advantage, because within ten days there was already an open copy and a faster competitor.

### If you're going to use it anyway

- Pin the version. The `jev-latest` alias swaps models on its own, and your calibration goes with it.
- Every question with a "none of the above." Without it, it marks answer A.
- Shuffle the order and use neutral names for the options. Test whether the decision changes.
- Recalibrate with 50 to 300 of your own examples before choosing a threshold. In one test, calibration error dropped from 0.117 to 0.008.
- Mark everything that comes from outside as untrusted: email, page, tool output.
- Never let it authorize a destructive, financial or personal-data action on its own.
- Math, dates and business rules stay in code.
- Before signing, compare with the cheap baseline: an open model reading probabilities, or a trained classifier if the task is always the same.

### Read with a discount

I founded a company that builds its own model and competes in the same market. Read with that discount. That's exactly why every number here has an open source: you don't need to trust me, you need to check.

And if someone sells you Jev as a savior, ask the question I ask every startup: which test, and from when? If the answer takes a while, that's the answer.

### Essay sources

TypeSafe. [Jev announcement](https://typesafe.ai/blog/introducing-system-one-models-and-jev) · [models and limits](https://docs.typesafe.ai/models) · [confidence](https://docs.typesafe.ai/confidence) · [known failures of jev-1.13](https://docs.typesafe.ai/model-jaggedness/jev-1.13) · [workflow evaluations](https://evals.typesafe.ai/) · [adapter for LLMs](https://github.com/typesafe-ai/system-one-adapter-python) · [privacy](https://typesafe.ai/legal/privacy-policy) · [data processing](https://typesafe.ai/legal/data-processing) · [trust center](https://trust.typesafe.ai/)

Recomputed by Paulo from raw data. [ENEM 2025](https://github.com/patryckalves/jev-no-enem) · [blind draw](https://github.com/KantaHayashiAI/jev-does-not-play-dice) · [heart risk](https://github.com/rubinagentagi-tech/jev-heart-risk-bench) · [fact-checking](https://github.com/adorosario/jev-rag-claim-verification)

Preprints. [Hu et al., JevAdvBench](https://arxiv.org/abs/2609.31142) · [Xu, JevOut](https://arxiv.org/abs/2609.30243) · [Sun et al., Type-Safe Is Not Error-Free](https://arxiv.org/abs/2609.26758) · [Ibrahim and Zaki](https://arxiv.org/abs/2609.24574) · [Li et al., JEV-as-a-Judge](https://arxiv.org/abs/2609.26550)

Independent tests. [human disagreement (ChaosNLI)](https://github.com/GautamTalksDev/jevbench) · [die replication](https://github.com/pobooo/jev-dice) · [dialect bias](https://github.com/zachlandes/jev-dialect-bias) · [49 tasks against a non-reasoning LLM](https://github.com/OmarMujahid/jev-decision-bench) · [calibration and negation](https://github.com/colinmcnamara/jev-first-look) · [recalibration](https://github.com/AnthusAI/Jev-Calibration) · [injection in Wikipedia discussions](https://github.com/zkousama/jagged) · [Spanish](https://github.com/marcosmartinez/jev-acento) · [tools](https://github.com/baibizhe/jev-decision-benchmarks) · [undisclosed internal rule](https://github.com/phuryn/experiments) · [shuffled coordinates](https://github.com/scd13150/jev-field-notes) · [crude attacks](https://github.com/cwhy/decision-injection-bench) · [injection detection](https://github.com/kaiserama/im-in-danger) · [audit index](https://github.com/Yifan-Lan/awesome-jev-robustness)

Press. [VentureBeat, agent gates](https://venturebeat.com/security/companies-are-putting-jev-in-charge-of-ai-agent-decisions-and-prompt-injection-can-influence-the-verdict) · [VentureBeat, CLM-8B](https://venturebeat.com/technology/stanford-and-nvidias-open-clm-8b-caches-reusable-agent-actions-and-runs-up-to-9x-faster-than-jev-in-tests)

Literature. Fleming et al. (2010), Science 329 · Rounis et al. (2010), Cognitive Neuroscience 1 · Bor et al. (2017), PLoS ONE 12 · Johnson, Hashtroudi and Lindsay (1993), Psychological Bulletin 114 · Kahneman (2011), Thinking, Fast and Slow · Kahneman and Klein (2009), American Psychologist 64 · Loftus, Miller and Burns (1978), J. Experimental Psychology: Human Learning and Memory 4 · Maniscalco and Lau (2012), Consciousness and Cognition 21 · Ouyang et al. (2022), NeurIPS · Radford et al. (2019), OpenAI · Tversky and Koehler (1994), Psychological Review 101 · Câmara (2026), Inherited Weights, [doi:10.5281/zenodo.22899767](https://doi.org/10.5281/zenodo.22899767)

## The open alternatives: Clef and Laya

Since Jev's launch, the category has gained open competition, and that changes the conversation about "new architecture." Two names matter.

### Clef, from Cloudflare

On October 1, Cloudflare released [Clef](https://blog.cloudflare.com/clef-decision-models/) and Clef-flash: the same abstraction as Jev (one shared state, several typed questions, a distribution over the options), with a [compatible API](https://developers.cloudflare.com/workers-ai/models/clef/), open weights under Apache 2.0 and image input. The architecture is described: a frozen Qwen as base (27B in Clef, 9B in Clef-flash), LoRA adapters and a head that scores each allowed option directly, trained with classification and calibration objectives. In other words, the lineage Paulo pointed to, now with inspectable code.

That doesn't prove TypeSafe uses the same thing, but it proves the product can be reproduced with known components. Cloudflare ran the [Decision Index](https://github.com/apolinario/decision-index), an open, independent suite with dozens of classification, routing, retrieval and safety tasks, and published the table. Some points:

| Task | Clef | Clef-flash | Jev | Laya |
|---|---:|---:|---:|---:|
| BFCL (tool selection) | 98.47 | **98.76** | 95.75 | 38.13 |
| Banking77 (intent) | **94.20** | 90.93 | 79.74 | 14.29 |
| CLINC150 with out-of-scope | **97.43** | 66.77 | 89.27 | 3.19 |
| When2Call | 72.37 | 65.58 | **80.97** | 11.94 |
| BRIGHT (retrieval) | 45.91 | 39.26 | **47.52** | 19.90 |
| PhishNChips | **79.60** | 75.05 | 62.55 | 50.15 |

Reading the whole table: Clef comes out stronger on most tasks, Jev still wins some, and it's an internal Cloudflare run, on a public suite that can be trained against. Hosted price is the other side: [US$ 0.24 per million tokens for Clef and US$ 0.09 for Clef-flash](https://developers.cloudflare.com/workers-ai/platform/pricing/), against US$ 0.042 for Jev. Jev remains the cheapest hosted service of the three, by a margin of 2 to 6 times, and remains text-only.

### Laya (and Arbiter)

[Laya](https://github.com/NandhaKishorM/laya) attacks the problem from the other end. They're small encoders, 322 to 421 million parameters (ModernBERT-large in the typed version), with a choice head, Apache 2.0, built to run locally and be fine-tuned for a recurring task. [Arbiter](https://github.com/0xBakeer/arbiter) packages them behind a Jev-compatible API, with batching and deployment on Mac and NVIDIA. Arbiter is only a serving layer.

Laya's README is unusually explicit about its limits, and I'd rather repeat than soften:

- the base checkpoints score near chance on the project's own typed-decision benchmark; the headline 0.766 accuracy comes from a checkpoint fine-tuned on that benchmark's training split;
- the models ship overconfident, and calibration has to be redone in the deployment domain;
- the typed version's context is 1,024 tokens, fine for tickets and short messages, insufficient for long documents without chunking;
- with more than 50 options, the classification head saturates, and Laya itself reports Jev doing better.

None of this is a defect in the idea. It's applied machine learning the way it has always been: a small model is excellent when the task is stable and labeled examples exist, and broad zero-shot behavior demands a much larger pretrained model. Laya is the option when privacy, offline operation, predictable latency or fine-tuning in your domain matter more than asking arbitrary questions about arbitrary documents. It is, at bottom, the classic classifier from the start of this post, with a modern interface.

There's also [Kev-9B](https://huggingface.co/jaredpalmer/kev-9b), another frozen Qwen 9B with LoRA and a decision head, Apache 2.0, that fits on a 24 GB GPU. Three open implementations in under three weeks say the same thing: typed decision models have become an implementation pattern.

## The Decision Index: how to measure this yourself

All this discussion about "who's better" only makes sense with a public yardstick, and one exists. The [Decision Index](https://github.com/apolinario/decision-index) is an open suite, unaffiliated with TypeSafe, built for typed decision models: state plus choice or yes-or-no questions, one probability per option.

The current version, 0.2.1, counts 38 benchmarks in five areas (tools and automation, retrieval and classification, knowledge and reasoning, language understanding, human taste), about 120 thousand requests in total, with two rules that matter: the score is chance-corrected (0 is random guessing, 100 is perfect) and an unanswered request counts as wrong. No truncating input, no filtering options, no tuning the prompt per benchmark.

The [live board](https://huggingface.co/spaces/multimodalart/jev-decision-index) has 70 models plus Jev as the reference. I downloaded the board's data file and rebuilt the table; below are the top and the names that appeared in this post. Latency is the median measured by the maintainers on an RTX PRO 6000, one request at a time; Jev's is a hosted API, so it doesn't compare with the others.

"Open weights" means a checkpoint published on Hugging Face; "open code over an open model" is a published inference technique on top of an off-the-shelf Qwen or Gemma, without its own checkpoint. The board doesn't record each one's license, so check before using in a product.

| # | Model | Base | Weights | Index 0.2.1 | Median latency |
|---|---|---|---|---:|---:|
| 1 | Jev (TypeSafe, jev-1.13.0) | unpublished | closed, API only | 57.91 | 524 ms (API) |
| 2 | Surogate Rune 26B-A4B v3 | Gemma 4 26B-A4B | open | 57.44 | 121 ms |
| 3 | Decider chat Gemma-4-31B | Gemma 4 31B | open code over an open model | 57.33 | 109 ms |
| 4 | pplx-decider-v1-27b | Qwen3.8-27B | open | 56.40 | 101 ms |
| 5 | simple-jev Qwen3.8-27B | Qwen3.8-27B | open code over an open model | 55.74 | 373 ms |
| 6 | Jebadiah 27B | Qwen3.8-27B | open | 54.67 | 110 ms |
| 7 | Eikos-27B | Qwen3.8-27B | open | 53.13 | 130 ms |
| 8 | reflex 27B | Qwen3.8-27B | open code over an open model | 52.16 | 108 ms |
| 9 | Decider chat Qwen3.6-27B | Qwen3.6-27B | open code over an open model | 51.35 | 84 ms |
| 10 | Winnow-12B | Gemma 4 12B | open | 50.02 | 73 ms |
| 19 | Hopper (G) 1.2 | Qwen3.5-4B, LoRA | open | 40.77 | 23 ms |
| 27 | Kev 9B | Qwen3.5-9B, LoRA | open | 38.48 | 51 ms |
| 55 | Lavoir | ModernBERT-large | open | 8.69 | 20 ms |
| 57 | CLM-v0.1-8B (Stanford and Nvidia) | Qwen3-8B | open | 7.40 | 47 ms |
| 61 | Laya | ModernBERT-large | open | 6.04 | 6 ms |

Three readings come straight off the table:

1. The only closed model on it is Jev. It leads, but by half a point over an open fine-tune of a 26-billion-parameter Gemma 4, and the board treats differences under 0.25 as ties. The top ten are all open models of 12 to 32 billion parameters with an adapter on top, exactly the recipe Clef describes.
2. The small zero-shot encoder sits at the bottom: Laya at 6, Lavoir at 9. That matches what Laya's README admits and what I said about the classic classifier, which needs labeled examples to shine.
3. A 4-billion LoRA like Hopper delivers 41 points at 23 milliseconds, a range many real problems don't need to exceed.

And how to read Laya at the bottom of the table? The Decision Index measures one thing only: answering, with no extra training, 38 kinds of question the model has never seen, from chess to taxation. That's what a hosted service has to do, because it doesn't know which question is coming. A 400-million-parameter encoder will never win that exam, and Laya doesn't even try: the score of 6 is the base checkpoint, with no fine-tuning at all.

The same model fine-tuned with your examples, on a stable task, shows up at 0.77 on the project's own benchmark. The ranking answers "who is the best zero-shot generalist," which is the question of whoever sells an API. The normal programmer's question is a different one: "on this repeated decision, with the examples I have, what gets more right at the cost I accept?". For that one, the bottom of the table may be the right answer, and no public board replaces the test on your own data.

So is Laya useless next to the others? As a zero-shot generalist, yes, and the board is right to say so. As a programmer's tool, the math is different. It's the only model on that table that runs on a laptop CPU and answers in 6 milliseconds, with 400 million parameters that fit on any server you already have; Hopper and Kev want a GPU, and Jev wants internet, an API key and a data agreement.

Fine-tuned with your examples, on a taxonomy that doesn't change every week, Laya's own author reports the model beating Jev on some tasks and losing where there are many options, in third-party published tests with different prompts and samples, so indicative rather than controlled. In other words: useless for answering any question about any text, and very useful for answering the same question a thousand times a day, for free, without sending data outside.

Clef isn't on the board: 0.2.1 closed on September 27, and Cloudflare released the model on the 1st. The numbers I showed in the previous section are from an internal Cloudflare run on the same tasks, per benchmark, without the aggregate index. There's also already a vendor claiming to have passed Jev on the same scorer, but for now that's a self-reported number in a blog post, not an entry on the board. Worth waiting for the official inclusion before comparing.

Running it yourself is a day's work, and the kit handles the tedious part:

1. `pip install -e ".[transformers,rebuild]"` and `python -m decision_index suite rebuild`. The suite isn't redistributed because of licensing, so the kit downloads the sources (about 7 GB, with HLE requiring you to accept the terms on Hugging Face) and rebuilds the files with hashes verified against the lab's.
2. `python -m decision_index suite sample --n 100` for a quick test, then `pipeline --engine http --option base_url=... --option model=...` against any server that speaks the `POST /v1/systemone` format. That covers Jev itself, with the API key, and Laya behind Arbiter. Clef's API is announced as compatible, so in theory it goes in by the same route, but I haven't tested it.
3. `score` applies the same math as the board, and the maintainers state that it reproduces all 67 entrants of the current edition. Whoever has cloud GPUs runs the whole thing as a single Hugging Face job on an RTX PRO 6000 with `hf-job`.

I didn't run the full suite for this post; the table above is the board's file rebuilt, not a measurement of mine. Two caveats from someone who uses this kind of yardstick: the suite is public and frozen, so it can be trained against, and the board itself says Jev's API output has already changed in 20 choices of the latency sample since the original run, without changing the score. A public benchmark is for discarding weak models and finding candidates. The final decision is still your labeled set, as I explain next.

## How a programmer should think about this

The useful question is no longer "is Jev new?". It has become: for a specific, measured decision in your system, which combination of quality, price, latency, privacy, context and maintenance beats what you already have, whether that's a rule, a classifier or an LLM with structured output? No vendor benchmark answers that without your own labeled examples.

A Jev-type tool is useful when the same kind of judgment about text happens many times, the possible actions fit in a list, the surrounding code can apply exact rules, and a wrong answer can be detected or sent to review. That's the shape:

- ticket triage;
- ranking a short list already retrieved;
- routing a request to a bigger or smaller model;
- flagging an agent trace for human review;
- choosing among spans that code or OCR already found.

Outside it, the tool is in the wrong place:

- when the input is image or audio;
- when the output needs prose or citations;
- when an exact parser already solves it;
- when a misclassification grants access or executes a destructive action.

I looked at my own portfolio of projects with that yardstick, and the result is a useful bucket of cold water: most need a specialist vision or audio model, deterministic rules or generated text, and have few decisions repeated, costly and ambiguous enough to justify one more model service. A few candidates remain, the clearest being model routing in [FrankClaw](/en/2026/03/16/rewrote-openclaw-in-rust-frankclaw/) and short-list ranking in [ai-memory](/en/2026/09/02/ai-memory-2-0-best-memory-system-for-agents-and-teams/). None is a demonstrated bottleneck today. I suspect your portfolio looks similar.

If a bottleneck appears, the pilot is short:

1. Pick a single decision and define the allowed answers, including "don't know" when that's a real outcome.
2. Set aside real examples, with easy, ambiguous and adversarial cases, and label them independently. If your product speaks Portuguese, include Portuguese.
3. Compare what you already have, a simple rule or classifier, Jev pinned to a version, and a cheap LLM with structured output, all with the same input and the same decision policy.
4. Measure the confusion matrix, calibration by confidence band, cost per correctly handled case, end-to-end latency and review rate. A cheap router that sends hard work to a weak model costs more in total.
5. Deploy as a reversible feature, with logging, a conservative review route and a fallback. A security or authorization judgment is advisory, unless an exact policy enforces the action independently.

What Jev did well was remind the industry that classification exists. That's worth the hype it got, and maybe a bit more.

Neither it nor its open cousins are a silver bullet. They're one more tool, for a specific kind of task, that your code needs to fence in with rules, calibration and review. Whoever was already thinking about classifiers before September gained nothing new; they gained a convenient API. Whoever had never thought about it gained the most valuable part, which is the question: why were you asking a billion-parameter LLM to write a paragraph to tell you which bucket the text falls into?
