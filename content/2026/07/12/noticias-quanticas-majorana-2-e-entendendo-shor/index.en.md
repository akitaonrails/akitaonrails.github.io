---
title: "Quantum News: Majorana 2 and Understanding Shor"
slug: "quantum-news-majorana-2-and-understanding-shor"
date: '2026-07-12T12:00:00-03:00'
draft: false
translationKey: quantum-news-majorana-2-and-understanding-shor
description: "Microsoft announced Majorana 2 with 20-second qubits and physicists answering that nothing was resolved. I take the chance to properly explain Shor's algorithm, why factoring becomes period finding, and what quantum computers are actually good at."
tags:
- quantum-computing
- science
---

Quantum computing is back in the news and, as always, with more hype than substance. Before diving in: if you never studied the basics, I already made an entire video on the channel explaining the fundamentals, [Akitando #66 on quantum supremacy](/2019/11/06/akitando-66-entendendo-supremacia-quantica/), and I talked some more in this podcast:

{{< youtube id="_Hl9wiLkns4" >}}

This post has two parts. First, the news: Microsoft's Majorana 2 announcement and why the physicists in the field remain with one foot (both, actually) behind. Then, the educational part: a decent explanation of Shor's algorithm, because a lot of people repeat "quantum computers break RSA" without the slightest idea of the mechanism, and the mechanism is too beautiful to leave out.

## Majorana 2: the announcement

On June 2, 2026, at the Build conference in San Francisco, Microsoft revealed **Majorana 2**, the second generation of its topological quantum chip. The headlines: qubit stability 1,000 times better than Majorana 1's (announced some 15 months earlier), and the timeline for a scalable quantum computer shortened from 2033 to 2029.

The central number in the technical paper: Z-parity lifetimes above **20 seconds** (more precisely 22 ± 1 seconds) in an InAs device with lead, against 1 to 12 **milliseconds** in Majorana 1's aluminum devices. Three orders of magnitude of improvement. The main hardware change was swapping the superconductor from aluminum to lead, whose superconducting gap is about four times larger, which doubled the reported topological gap and drastically dropped the parity error rate.

These materials engineering numbers are real and measurable, and even the critics acknowledge the progress on that front. The problem lies in what the paper does NOT show.

## The history the announcement would rather not remember

Microsoft's topological quantum program carries almost two decades of history, and part of it is embarrassing. In 2018, a Microsoft-funded team at TU Delft published in Nature evidence of quantized Majorana conductance. In 2021 the paper was retracted, after physicists Sergey Frolov and Vincent Mourik demonstrated that the data had been selectively presented. TU Delft's scientific integrity committee concluded the data had been "unnecessarily corrected". A second paper from the same group was retracted in 2022.

When Majorana 1 was announced in February 2025 as "the world's first topological qubit", the accompanying Nature paper said less than the press release: Nature's own reviewers wrote that the published measurements **did not represent evidence for the presence of Majorana zero modes** in the devices. When Microsoft presented additional data at the APS meeting in March 2025, Frolov (University of Pittsburgh) publicly called the data "just noise", and physicist Henry Legg (St Andrews) raised similar objections, including criticism of the Topological Gap Protocol itself, the method Microsoft uses to identify the topological phase.

And did Majorana 2 answer those criticisms? Within hours the same physicists answered no. Legg, to Science News: "Nothing in this preprint resolves the fundamental issues. Nothing in the presented data proves the existence of a topological qubit or Majoranas in these devices." Frolov, to Scientific American, was more acid: "When Microsoft is mentioned these days, physicists and quantum computing specialists just chuckle or raise their eyebrows."

[Marin Ivezic's detailed analysis at PostQuantum](https://postquantum.com/industry-news/microsoft-majorana-2-analysis/), which I recommend reading in full, lists what's missing with precision:

- **No X measurements.** A functional qubit requires two complementary types of measurement: Z (parity of a single wire) and X (joint parity of the tetron's two wires). The Majorana 2 paper only presents Z. And the X measurement was exactly the point of contention with Majorana 1. Without it, what was demonstrated is a long-lived parity state in a superconducting wire. A qubit, not yet.
- **No demonstration that the states are topological.** The measurements are consistent with Majorana zero modes, but they are also potentially consistent with trivial Andreev states that mimic the same signatures. The paper itself admits the ambiguity.
- **No logic gates, no entanglement, no algorithms.** It's a characterization experiment, with no computation at all. Chetan Nayak, who leads the program, says he has unpublished data on qubit control. Until he publishes, it's a claim, without evidence.
- **No peer review.** The paper came out on Microsoft's website and on arXiv. Given the program's history of retractions, the absence of peer review at launch deserves extra scrutiny.
- **No demonstrated reproducibility.** The 22 seconds come from a single wire of a single tetron of a single chip. No ensemble of identical devices or independently fabricated chips.

My summary of the opera: the materials engineering genuinely advanced, and that counts. But the trillion-dollar question ("is this a topological qubit?") remains exactly as open as it was before the announcement. And shortening the public timeline from 2033 to 2029 on top of a result that doesn't even demonstrate a qubit is a marketing decision, with the scientific rigor left for the future.

## Shor: why factoring numbers becomes period hunting

Now the fun part. Everybody repeats that quantum computers break RSA. The algorithm responsible is **Peter Shor's, from 1994**, and its central trick is one of the most elegant ideas in computing. This Computerphile video explains it very well, and I recommend watching it before continuing:

{{< youtube id="k_kyepATqB8" >}}

RSA's security depends on a simple fact: multiplying two giant primes is easy, but taking the result N and figuring out which primes they were is brutally hard. The best known classical algorithm takes sub-exponential time, which in practice means that with large keys the Sun burns out before you finish.

Shor's insight was to prove that factoring N is reducible to another problem: **finding the period of a function**. You pick a number `a` coprime to N and look at the function:

```
f(x) = a^x mod N
```

This function is periodic: there's an `r` such that the values repeat every `r` steps. Once you find that period `r`, a bit of classical number theory (which any ordinary computer solves in an instant) hands you the prime factors of N. The problem is that, classically, finding the period for a giant N is as hard as the original problem.

This is where the quantum computer comes in, in four movements:

1. Prepare a **superposition** of many values of `x` at the same time.
2. Evaluate `f(x)` in superposition (the famous quantum parallelism: one evaluation over all the `x` at once).
3. The resulting state now **encodes the function's periodicity**.
4. Apply the **Quantum Fourier Transform (QFT)**, which uses constructive and destructive interference to amplify exactly the frequency components of the period, and measure.

The detail almost everybody gets wrong: you don't "read all the answers at once" (measurement collapses the superposition and gives you ONE value). The genius is in using interference to make the wrong answers cancel out and let the global information you want (the period) survive in the probability distribution. The QFT turns a global property of the function, which no individual measurement reveals, into a local, measurable feature. That's why factoring drops from sub-exponential to polynomial time on a quantum computer. And that's why post-quantum cryptography exists as a field.

## So quantum computers are good with "periodic functions"?

That's the hasty conclusion I want to undo. Periodicity and Fourier-style analysis are indeed a strong suit, and not only in Shor: quantum phase estimation (QPE), hidden subgroup problems and a good part of physical system simulations live in that territory. But the correct formulation is different: quantum computers shine when the problem has **exploitable mathematical structure**, something that can be mapped onto superposition, entanglement and interference.

There are quantum advantages that have nothing to do with periods. **Grover's** algorithm does unstructured search with a quadratic gain (√N instead of N). The **simulation of quantum systems** (molecules, materials) is probably the most promising application of all, because there the problem's Hilbert space is naturally the machine's space. There's **HHL** for linear systems, optimization techniques, some machine learning methods. The common thread is always the same: there's structure (symmetry, groups, geometry) that quantum interference exploits better than any known classical method.

And the reverse question: can you decompose any classical algorithm into periodic functions and gain quantum speedup? No. A quantum computer can simulate any classical algorithm (in the field's notation, BQP contains P), so technically everything runs there. But running is different from accelerating: without exploitable structure, you pay all the quantum overhead (error correction, qubit coherence, cryogenic temperatures) to arrive at the same result, probably slower.

Sorting, arithmetic, most graph problems, the bulk of what a computer does day-to-day: none of it has any known superpolynomial quantum speedup. For those tasks, the classical computer is faster, cheaper and more reliable, and will keep being so.

> A quantum computer is an accelerator for problems with specific structure. A better universal machine, it is not.

## Conclusion: put the hype back in the closet

Put the two halves of this post together and the picture becomes clear. On one side, Shor's algorithm is real, is beautiful, and is the reason the entire post-quantum cryptography race exists. On the other, the hardware needed to run Shor against a real RSA key requires millions of physical qubits with error correction, and the state of the art announced with fanfare in 2026 is... a 22-second parity state in a single wire, which the experts don't even agree is a qubit.

In practice, in the short term, quantum computing remains a very niche, very limited, very impractical solution. The real applications that arrive first will be in chemistry and materials simulation, inside research labs and datacenters, not in your life. Don't expect to use a quantum computer yourself any time soon. Follow the news the way I follow it: with genuine curiosity for the physics, and a raised eyebrow for the press releases.
