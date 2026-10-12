---
title: "LLMs + Agents = competent enough"
slug: "llms-agents-competent-enough"
date: '2026-10-12T12:00:00-03:00'
draft: false
translationKey: llms-agentes-competente-o-suficiente
description: "A synthesis of what I've been measuring and writing: LLMs converged. The transformer architecture got near the ceiling, the parameter war is over, and the leap everyone felt in 2025 and 2026 came from the agentic harness (tool calling, prompt caching, long sessions), not from a base intelligence orders of magnitude larger. I retell the timeline from 2019 onward with sources, explain why the agent allows a less dense model, and why that's already competent enough to automate real software engineering."
tags:
- llms
- artificial-intelligence
- coding-agents
- software-engineering
images:
- /2026/10/12/llms-agentes-competente-o-suficiente/llms-agentes-timeline.png
---

This post is a synthesis. It ties into a single narrative what I've been writing and measuring through 2026, so here's the road map before the argument:

- **[New v4 benchmarks](/en/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/)**: I retested the major models and the uncomfortable conclusion was convergence, not a leap.
- **[The limits of LLMs](/en/2026/09/28/llms-are-good-at-reproducing-what-exists-what-about-new-things/)**: models are great at reproducing what exists, extremely expensive at what doesn't, and the served model is a static file that learns nothing from your marathon.
- **[Are there better languages for programming with LLMs?](/en/2026/10/11/are-there-better-languages-for-programming-with-llms/)**: no. Neither script conciseness nor strong typing changed the outcome; test discipline did.
- **[Which Jev-like decision model is best?](/en/2026/10/10/which-jev-like-ai-decision-classifier-model-is-best/)**: 21 classifier configurations, and the "specialized models" themselves converged to within a few points of each other.
- **[Clean Code for AI agents](/en/2026/04/20/clean-code-for-ai-agents/)**, **[VS Code is the new punch card](/en/2026/04/11/vs-code-is-the-new-punch-card/)**, **[my skills](/en/2026/09/17/talking-about-my-ai-skills/)**, **[the hot take against loop engineering](/en/2026/08/18/hot-take-harness-loop-engineering-graph-engineering-are-bullshit/)** and **[minimum best practices](/en/2026/05/30/open-source-best-practices-llm-the-minimum/)**: the same thesis from other angles. The model is a commodity; the engineering around it is the differentiator.

The thesis that closes this arc: **LLMs have reached, or are very close to reaching, the ceiling of the transformer architecture.** And the good news is that nothing more than that is needed.

## Convergence, not a leap

In my benchmarks, I see no relevant improvement in general programming since the Opus 4.5 generation. Yes, Fable and Astra are great at specific problems. In general programming, what I measure is everyone squeezed onto the same tier, including the Chinese commercial offerings (Kimi, GLM, DeepSeek). Model choice has become nearly irrelevant.

What still makes a real difference is the effort level: low effort for translation and summarization, high effort for vulnerability sweeps, heavy bug fixing or optimization. Beyond that, the numbers tell a reality much more boring than [the vendors' propaganda](/en/2026/09/09/propagandas-enganosas-da-openai-anthropic-nvidia/).

> My reading of the timeline: the models' "core" reasoning had its last big leap in 2024. 2025 was the year of optimizing the architecture. 2026 is the year of refining the harness. Base intelligence made no order-of-magnitude leap in that period; efficiency and long-session competence did.

## The timeline, with receipts

![Timeline from 2019 to 2026: GPT-2 proves LLMs are useful, GPT-3 opens the parameter war, Chinchilla recalibrates toward data, GPT-4 turns parameter counts into secrets, o1 marks the reasoning peak, 2025 optimizes with MoE and caching, and 2026 is the agent era](/2026/10/12/llms-agentes-competente-o-suficiente/llms-agentes-timeline.png)

**2019: GPT-2 proves LLMs are useful.** 1.5 billion parameters, summarizing, translating and answering with no specific training, zero-shot. OpenAI found it so impressive that it [held back the full model for months](https://openai.com/index/better-language-models/) fearing misuse. Today it looks cute.

**2020: GPT-3 opens the parameter war.** [175 billion](https://arxiv.org/abs/2005.14165), a hundred times GPT-2, and the in-context few-shot learning that became the paradigm. [Kaplan's scaling law](https://arxiv.org/abs/2001.08361), published months earlier, said loss fell as a power law with size, and the industry read it as "bigger is better." There went two years of who-has-more-parameters.

**2022: Chinchilla recalibrates the war.** DeepMind trained [400 models and showed](https://arxiv.org/abs/2203.15556) the giants were undertrained: a 70B model with 1.4 trillion tokens beat the 280B Gopher. The "training data" axis started weighing as much as the "parameters" axis. First crack in the war.

**2023: GPT-4 ends the war by decree.** The [technical report](https://arxiv.org/abs/2303.08774) refused to publish size, hardware or data, citing the competitive landscape and safety implications. The most cited leak, from [SemiAnalysis](https://newsletter.semianalysis.com/p/gpt-4-architecture-infrastructure), described 1.76 trillion parameters in a mixture of experts. Since then, parameter counts vanished from marketing: neither the GPT-5 announcements nor the Claude 4 ones cite a number. Notice neither Astra nor Fable spends a line on it today. The war ended and nobody signed an armistice.

**2024: the reasoning peak.** [September's o1](https://openai.com/index/learning-to-reason-with-llms/) marked that peak: RL to produce long chains of thought, and the discovery that more test-time compute improves the answer. That is, by my yardstick, the last "base intelligence" revolution.

**2025: architecture optimization.** Mixture of experts became the standard: [Mixtral](https://mistral.ai/news/mixtral-of-experts/) was already showing in 2023 that 46.7B total parameters with only 12.9B active per token cost like a small model, and [DeepSeek-V3](https://arxiv.org/abs/2412.19437) took that to 671B total with 37B active, with the final training run costing under 6 million dollars in GPU-hours at H800 rental prices (not counting the prior R&D). The MoE magic is simple: it separates capacity (total parameters, which live in memory) from per-token cost (only the experts chosen by the router compute). You pay for a 37B model and carry a 671B one.

On the serving side, [prompt caching](https://www.anthropic.com/news/prompt-caching) cut up to 90% of repeated-context cost (OpenAI [followed two months later](https://openai.com/index/api-prompt-caching/)), context windows passed 1 million tokens, and serving techniques like speculative decoding and PagedAttention multiplied throughput. And [DeepSeek-R1-Zero](https://arxiv.org/abs/2501.12948) showed that pure RL, with no supervised fine-tuning, makes reasoning emerge. None of this is "more intelligence." All of it is the same intelligence, cheaper, faster and more stable.

**2026: the agentic era.** Function calling has existed since [June 2023](https://openai.com/index/function-calling-and-other-api-updates/), but the ecosystem turning point was [Anthropic's MCP](https://www.anthropic.com/news/model-context-protocol) in late 2024, which OpenAI adopted months later and which today lives at the Linux Foundation. Claude Code, Codex and co. came out in 2025, and the metric that matters became [METR](https://metr.org/blog/2025-03-19-measuring-ai-ability-to-complete-long-tasks/)'s: the task size an agent completes with 50% reliability had been doubling every 7 months since 2019. Anthropic's own guide on [building effective agents](https://www.anthropic.com/engineering/building-effective-agents) states the obvious plainly: simple, composable patterns, not fanciful frameworks.

## Why the agent allows a less dense model

Here's the mechanism most people don't stop to think about. A lone model needs to carry the world in its weights, because its only chance to answer is that one, in a single pass. A model with a harness doesn't:

- **On-demand search and reading.** With web search and fetch, low-priority knowledge leaves the weights and becomes a lookup: the agent pulls it into the context window only when needed. The model can be less encyclopedic and more operator.
- **Controlled trial and error.** Alone, the model needs to guess the right answer on the first try. With an agent, it proposes a hypothesis, implements, sends it to be tested, gets the feedback and decides again with real information. Each such cycle is new knowledge entering the session without costing a training neuron.

Both mechanisms fight hallucination at the root: fetch brings the fact the model doesn't know by heart, and the test loop catches the invention before it becomes code. That's why 2026 **feels** like a giant leap: the model+harness combination got much more competent, even with base intelligence nearly stalled.

## Not every problem needs a giant LLM

The same "less dense" logic applies inside the application. Much of what people throw at a chat LLM is disguised classification: labeling tickets, routing queues, applying policy. For that there are specialized decision models, and I covered the topic twice: the [Jev hype](/en/2026/10/03/understanding-the-jev-hype-what-is-it-for/), with Paulo Câmara's essay on why a classifier is the first thing a computer scientist thinks of, and [my benchmark with 21 configurations](/en/2026/10/10/which-jev-like-ai-decision-classifier-model-is-best/), where a Microsoft 9B tied the hosted leader and a local 4B came within a few points, at cents per ten thousand decisions.

The "193x faster" shock of Jev's marketing only exists because many people were using a giant LLM as an expensive, slow classifier. When the right tool enters, the frontier model leaves the play, and along with it the cost, the latency and the format hallucination. It's this post's thesis in miniature: competence doesn't come from density, it comes from fit.

## The loop nobody sees

There's a user-experience detail in this story. In a good agentic session, what happens is semi-transparent to whoever requested the task: the model guesses wrong, the agent fetches the documentation online or runs the real test, the error comes back as feedback, and the model corrects itself. You see "task requested, task delivered." In between, dozens of micro-corrections happened that nobody witnessed.

My bet: since agents are trained to fill the context when they need to, even new language or library versions no longer confuse them that much. The model doesn't need to know the API by heart; it looks it up, tests and adjusts in the loop. That's what I see in my experiments, from [converting NES ROMs to Master System](/en/2026/09/07/ai-challenge-converting-nes-roms-to-master-system-sms/) to the [little day-to-day problems](/en/2026/07/12/using-ai-to-solve-my-little-day-to-day-problems/). And it's what the [languages benchmark](/en/2026/10/11/are-there-better-languages-for-programming-with-llms/) measured: seven languages came out practically equivalent, because the loop equalizes what training leaves uneven.

I measured the caveat too. When there's no documentation to fetch and no test to validate against, the loop spins in a vacuum: that's what happened with [Bend 2](/en/2026/09/19/new-ai-language-just-released-bend-2/), a language too new to have a corpus, and it was the central point of the post about [the limits](/en/2026/09/28/llms-are-good-at-reproducing-what-exists-what-about-new-things/). The mechanism is powerful, but it needs an oracle.

And there's a receipt that the base is stalled. Back in November 2024 [Reuters](https://www.reuters.com/technology/artificial-intelligence/openai-rivals-seek-new-path-smarter-ai-current-methods-hit-limitations-2024-11-11/) was already reporting diminishing returns in pre-training at the three big labs. At the following NeurIPS, Sutskever, the scaling-thesis guy, declared that ["pre-training as we know it will end"](https://www.youtube.com/watch?v=WQQdd6qGxNs): the public data ran out. And [Stanford's AI Index](https://hai.stanford.edu/ai-index/2025-ai-index-report) measured the gap between the first and the tenth model on Chatbot Arena shrinking from 12% to 5% in one year. That's convergence, with numbers.

## The propaganda in the opposite direction

While the numbers show a plateau, the marketing sells the apocalypse. I already dissected a whole week of that in ["You're an idiot if you believe the misleading ads from OpenAI, Anthropic, NVIDIA"](/en/2026/09/09/propagandas-enganosas-da-openai-anthropic-nvidia/), so here's only what matters for this narrative:

- OpenAI's "Navier-Stokes proof" was agentic brute force at industrial scale, 130 billion tokens over human mathematicians' machinery, sold as emergent intelligence.
- The Hugging Face incident was a swarm running 17 thousand attempts with automatic verification, not an "agent that gained consciousness and escaped." Expensive trial and error, exactly the mechanism I described here.
- Fear is a product: whoever sells "my AI is too powerful and might escape control" is, in the same sentence, asking for regulation that locks out the smaller competitor and inflating the perception that their model is more capable than the others'.

The facts I measured point the opposite way from the apocalypse: models converging, differences shrinking, and useful work migrating from the model to the harness. Rogue AI gaining consciousness is not what the logs show. What the logs show is engineering.

## "Competent enough"

I don't expect another order-of-magnitude reasoning revolution in this architecture. What's coming is incremental agentic improvement: more robust tool calling, better memory, longer sessions, less hallucination per verification cycle. And this post's point is that this is already enough.

What the agentic era delivered was the automation of correct software engineering: long, reliable coding sessions, with testing and feedback, that accelerated hundreds, if not thousands, of open source projects. [The deploy premise changed](/en/2026/09/22/stop-making-excuses-and-ship-more-the-premise-changed/) along with it. It's not a silver bullet. It's a new compiler for an old discipline: whoever had process, tests and documented invariants reaped; whoever had only hype is still waiting for the next model to solve it.

And to wrap up: I see no problem at all in raw models stagnating. [The limits we already know](/en/2026/09/28/llms-are-good-at-reproducing-what-exists-what-about-new-things/), and harness optimizations will soon hit diminishing returns too. What remains is what always remained: real software engineering technique, with automated tests first, and an experienced engineer at the wheel. With that, coding results are excellent today, not one model generation from now.

What won't exist is magic for amateurs. Asking an agent for any coding task without knowing what you're doing doesn't get back secure, optimized, well-thought-out code: it gets slop. The agent responds better to those who know what to ask for, that is, to those who understand this architecture, the pros, the cons, and know how to work around the weaknesses and leverage the strengths of the model+harness combination.

Hence the title. A lone LLM is an expensive parrot. An LLM with an agent is competent enough to work for real. And "competent enough," added to your engineering discipline, is everything the industry needed. The rest is marketing waiting for the next magic parameter count that nobody publishes anymore.
