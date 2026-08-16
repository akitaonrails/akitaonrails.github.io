---
title: "What the Google Quantum Vulnerability Paper Means"
slug: what-the-google-quantum-vulnerability-paper-means
date: '2026-08-16T10:00:00-03:00'
draft: false
translationKey: o-que-significa-o-paper-do-google-sobre-vulnerabilidade-quantica
description: "Google, the Ethereum Foundation, and Stanford estimate breaking secp256k1 with under 500,000 qubits. I compare GLM, Kimi, and ChatGPT, calibrate the real odds of theft in the coming years, and what you can do today."
tags:
- quantum-computing
- bitcoin-and-cryptocurrency
- security
---

A Google paper dropped, and the predictable headline came with it: "quantum computer will break Bitcoin." On the other side, the "it's FUD, ignore it" crowd answered at the same volume. Both reactions are wrong, and the paper itself is far more interesting than either shouting match.

The document is called [Securing Elliptic Curve Cryptocurrencies against Quantum Vulnerabilities](https://arxiv.org/abs/2603.28846), and the author list alone forces you to take it seriously: it's Google Quantum AI (with Craig Gidney, the same guy behind the recent [RSA](<https://en.wikipedia.org/wiki/RSA_(cryptosystem)>)-breaking estimates), plus the Ethereum Foundation (Justin Drake) and Stanford (Dan Boneh, one of the fathers of [elliptic-curve cryptography](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography)). This is people who build quantum computers sitting at the same table as people who invented a good chunk of the cryptography running today. Rare weight for a subject that usually attracts a lot of hot takes from folks who never read a line of what they're trashing.

First things first: **read the paper directly**. It's long and dense, but written with rare care, including an explicit effort not to turn into FUD.

What I'm doing here is my own read, then comparing it with what GLM, Kimi, and ChatGPT made of it when I asked them to tear the text apart, and finally trying to answer the question that matters to anyone holding a handful of satoshis or ether: in the real world, what are the odds a quantum computer steals your money in the next few years?

I'll tip the spirit of it upfront: the sky isn't falling. But the "start moving now" message has real grounding, and the reason is subtler than "quantum is coming."

The short version, for the impatient:

- **The paper is serious and the math holds.** Google, the Ethereum Foundation, and Stanford show that breaking secp256k1 dropped to under 500,000 physical qubits and about 9 minutes, in a conditional scenario already confirmed by open, independent reproduction.
- **This measures the machine's size; the date stays open.** Today's best hardware works with about 12 logical qubits, and the attack asks for more than 1,200. On IBM's roadmap, hardware of the right size shows up around 2033.
- **Bitcoin isn't ending.** The risk hits whoever has an exposed public key, a subset of addresses (around 6.9 million BTC, much of it already lost). A modern no-reuse wallet stays safe at rest, and mining is at no risk at all.
- **What you can do.** As a user, key hygiene: a fresh address per use, no reuse (a stronger password doesn't help against quantum). As an industry, start the post-quantum migration now, in layers, without throwing everything out.

Below, each of these points in full: what the paper says, where I agree and disagree with the other models, the real odds with timelines, and what to do in practice.

## What the paper actually says, in plain engineer terms

Let me get the jargon out of the way first. The security of Bitcoin, Ethereum, and almost all crypto rests on a math problem: given a public key, computing the matching private key is infeasible. Everyone sees your public key; nobody can walk back from it to your private key. That one-way street is what makes a digital signature worth anything.

[Shor's algorithm](https://en.wikipedia.org/wiki/Shor%27s_algorithm), running on a big enough quantum computer, breaks exactly that one-way street. It turns "infeasible" into "a matter of minutes." That's been known since 1994. The paper's news is something else, and it's five points.

**First: the cost collapsed.** The Google team presents new circuits for solving the [secp256k1](https://en.bitcoin.it/wiki/Secp256k1) curve (the curve behind Bitcoin and Ethereum accounts) using far fewer resources than anyone thought. Two recipes: one with under 1,200 logical qubits and 90 million Toffoli gates, another with under 1,450 logical qubits and 70 million gates.

On superconducting hardware, with standard error-correction assumptions, that would fit in **under 500,000 physical qubits** — nearly 20 times fewer than prior estimates — and run in **9 to 12 minutes** from a precomputed state. Hold onto that number: 9 minutes. It's the scary one, because it's shorter than Bitcoin's average block interval.

**Second: they didn't publish the circuit.** Here's a move that's elegant and controversial at once. To prove they have a circuit that size without handing everyone a loaded gun, they published a **[zero-knowledge proof](https://en.wikipedia.org/wiki/Zero-knowledge_proof)**: a mathematical proof that they possess the circuit, without revealing the circuit. Responsible in intent. Except, as I'll get to, this part was the shakiest piece of the whole story.

If "zero-knowledge proof" sounds esoteric, the idea is simple and old in cryptography: prove you know or have something without revealing the thing itself. You can prove you're of legal age without showing your birthdate, or that you know a password without typing it.

It's the same trick behind the privacy of several cryptocurrencies: Zcash uses ZK (the so-called zk-SNARKs) to validate shielded transactions without exposing amount or address, Monero uses range proofs (bulletproofs) to hide how much was sent, and Ethereum's zk-rollups use ZK to prove a batch of transactions is valid without reprocessing all of it. In the paper, Google uses the same family of tool to prove it possesses the circuit, without handing over the circuit.

**Third: not every quantum computer is good for everything.** The paper draws a distinction that's the text's best practical contribution. There's the "fast clock" (superconducting, photonic) and the "slow clock" (trapped ions, neutral atoms), with a 100x to 1,000x speed difference. Out of that speed come three types of attack:

- **On-spend attack:** the attacker intercepts your transaction in the mempool, breaks the key, and injects a rival transaction before your spend lands in a block. Needs a fast clock, because it's a race against the block clock.
- **At-rest attack:** the public key is already exposed on the blockchain (a dormant wallet, a reused key). The attacker has days or months to work. Even a slow clock does the job.
- **On-setup attack:** a single quantum computation extracts a secret from a cryptographic ceremony and becomes a reusable master key, which then runs on ordinary classical computers. This one's the most insidious, and it hits things like Ethereum's data-availability mechanism.

**Fourth: the map of who bleeds.** On Bitcoin, the at-rest targets are the old [P2PK](https://en.bitcoin.it/wiki/Script) scripts (about 1.7 million BTC, almost all Satoshi-era and probably lost), [Taproot](https://bitcoinops.org/en/topics/taproot/) (P2TR, which exposes the key), and any reused address.

All told, the paper estimates around 6.9 million BTC vulnerable today, of which some 2.3 million have been dormant for more than five years. Modern addresses that hide the key behind a hash and have never spent stay safe at rest.

And there's good news buried here: **Bitcoin mining is not at risk**. [Grover's algorithm](https://en.wikipedia.org/wiki/Grover%27s_algorithm), which would attack mining, has too small a gain and doesn't parallelize; error-correction overhead eats it all. The paper buries that myth on purpose.

> **Bitcoin mining is not at risk. Quantum toppling Proof-of-Work is the myth this paper buries on purpose.**

**Fifth: Ethereum has a much larger surface.** The account model exposes the public key permanently after the first transaction, unlike Bitcoin's UTXO model. Add to that contract admin keys (stablecoins, bridges, oracles), the [BLS signatures](https://en.wikipedia.org/wiki/BLS_digital_signature) holding up [Proof-of-Stake](https://en.wikipedia.org/wiki/Proof_of_stake) consensus, and the [KZG commitments](https://dankradfeist.de/ethereum/2020/06/16/kate-polynomial-commitments.html) in the data layer. More stuff exposed, and much of it you can't "change addresses" to escape.

And how does the paper argue all this? Three legs: the resource estimates (with the zero-knowledge proof for credibility), real blockchain data (the BTC and ETH at-risk figures come from public [BigQuery](https://en.wikipedia.org/wiki/BigQuery) queries), and the honest framing that the goal is to sound the alarm to migrate, making clear the machine is still to come.

The paper, by the way, **gives no date**. It sizes the machine and stops there; the calendar stays open.

## Where I agree and disagree with the other models

I asked GLM 5.3, Kimi K3, and ChatGPT (GPT 5.6) to analyze and criticize the paper. The interesting part is that all three, and I, converge on the essentials and diverge on exactly the same points. That's a good sign: when different models hammer the same nail, the nail usually exists.

**What everyone agrees on (me included):**

- The logical-resource estimate is **credible**. It's not a number out of nowhere: it follows the historical trajectory (the cost to break RSA-2048 fell from ~1 billion qubits in 2012 to under 1 million in 2025) and comes from the very group that produced the field's best estimates.
- The fast-clock / slow-clock distinction and the spend / rest pairing are the right lens for thinking about mitigation.
- The mining immunity is correct and needed saying out loud.
- Dormant assets are a real problem no software fork solves on its own, because nobody holds the private key to move the lost coins.

**What everyone flags (and I flag harder):**

ChatGPT was the sharpest on a distinction worth gold: **there's a gulf between "value at risk" and "expected loss"**. When the paper says "20.5 million ETH in vulnerable accounts" or "6.9 million BTC exposed," that measures how much the system leans on fragile cryptography. It's a far bigger number than what an attacker could actually steal.

There's overlap, there's multisig, there's admin keys you can rotate, there are contracts with an emergency council that pauses everything. Stacking those numbers into a "trillions at risk" headline is dishonest to the paper itself.

> **"Value at risk" measures how much the system leans on fragile cryptography. It's a far bigger number than what an attacker could actually steal.**

Same goes for the famous **41% chance of theft on Bitcoin**. That number is only the probability that the 9-minute computation finishes before the next block shows up (a block arrives every 10 minutes on average, but with a lot of variance). It's not the chance of stealing your money.

To steal, the attacker still has to propagate the rival transaction, convince a miner to include it, win the fee race. And the paper itself assumes attacker-friendly conditions (no network congestion, instant delivery). Kimi and ChatGPT hit this one, and they're right.

The most important point, and one I think the paper leaves between the lines on purpose: **the 500,000 physical qubits and the 9 minutes describe a conditional engineering scenario. On dates, the paper says nothing.** It's a blueprint for a machine that *could* do the attack, assuming a 0.1% error rate, 1-microsecond correction cycles, low-latency decoding, enough magic-state factories, and half a million qubits running stable for minutes on end.

Each assumption is reasonable in isolation. The whole chain working together, at that scale, nobody has demonstrated.

And here's the most interesting part, which Kimi and ChatGPT caught and I confirmed by searching outside: **the zero-knowledge proof mechanism had a bug.** Trail of Bits [managed to forge a proof](https://blog.trailofbits.com/2026/04/17/we-beat-googles-zero-knowledge-proof-of-quantum-cryptanalysis/) by exploiting memory and logic bugs in Google's Rust verifier code, to the point of generating a proof that reported zero Toffoli gates for a circuit that wasn't even reversible.

Notice what that breaks and what it doesn't. The flaw was in the software that checks the proof, not in any demonstration that the paper's circuit is wrong. The proof stopped being trustworthy, and the scientific claim itself stayed standing, neither proven nor disproven. Google patched the verifier in version 2.

The lesson is about trust: instead of trusting Google's word, the proof was asking you to trust its parser, its compiler, and its simulator.

And that's exactly why the independent reproduction matters so much. In June 2026, researcher André Schrottenloher [rebuilt the circuits in the open](https://postquantum.com/security-pqc/google-ecdlp-circuits-reproduced-open/), landing in the same region: about 56 million Toffoli gates, with the entire circuit published and reproducible.

Gidney himself acknowledged the reproduction captured the essential breakthrough, and after that others already pushed the number below a thousand logical qubits. So: the paper's central claim held up, but through a route that doesn't depend on trusting anyone's proof software. Open science is what closed the case.

One last point almost nobody raises and I think needs saying: **conflict of interest.** Seven authors are from Google Quantum AI, whose hardware roadmap is precisely the superconducting architecture the paper makes look like the nearest threat. And there's an Ethereum Foundation coauthor on a paper that ranks Ethereum as more exposed and recommends urgent migration.

The authors disclose long positions in crypto and no shorts, which is honest. None of this invalidates anything — the team's technical chops are the best in the field — but it calls for a calibrated read, with a cool head.

## The question that matters: what are the real odds, and when?

Let's separate the theoretical from the real, which is where most of these debates turn to mush.

**In theory, the answer is yes, comfortably.** If a big, stable enough machine exists, Shor's algorithm breaks secp256k1. On the math side it's already settled; what's left is engineering. The whole question boils down to: *when does that machine exist?*

### Physical qubit versus logical qubit

A quick aside to separate two numbers that trip almost everyone up: physical qubit and logical qubit. The physical qubit is the real hardware, and it's noisy; it loses its state in a blink, from interference, heat, vibration. On its own, it errs far too much for any serious computation.

The fix is error correction: you gang up hundreds or thousands of physical qubits, all representing **one** logical qubit, and use the redundancy to detect and repair errors in real time. The logical qubit is the "real," stable qubit the algorithm actually sees.

And that's where the difficulty hides behind the numbers. The attack doesn't just ask for 1,200 logical qubits; it asks for **1,200 logical qubits working together, all stable at the same time, for minutes on end**, running tens of millions of operations without the correction system getting buried under errors.

It's like keeping a thousand plates spinning at once, each plate made of a thousand pieces that want to fall, for the entire length of the show. Keeping a single such plate up for an instant was the historic feat of 2024. The jump to a thousand plates, spinning for minutes, is the real chasm.

### Where the hardware stands today

**In today's reality, we're far off.** Google itself helps measure the distance. [Willow](https://blog.google/innovation-and-ai/technology/research/google-willow-quantum-chip/), their flagship chip, demonstrated below-threshold error correction in 2024, a historic feat. But the result was **a single well-corrected logical qubit**, built from 101 physical ones, which outlived every one of them.

If the ruler is the number of logical qubits running together, the public record today is around a dozen ([Quantinuum](https://en.wikipedia.org/wiki/Quantinuum) reached 12). The paper asks for more than 1,200. On both rulers, quality and quantity, the distance runs to roughly a hundredfold, and each logical qubit still costs thousands of physical qubits with the stability we're missing.

In physical qubits, the largest announced system is in the low thousands; the attack wants nearly half a million. Several orders of magnitude of distance, across several dimensions at once. Nothing a fine-tuning pass fixes.

> **Today's best hardware works with logical qubits in the dozen range. The attack needs more than a thousand. The gap is orders of magnitude.**

There's also a bet that sidesteps this brute-force game: the topological one, from Microsoft. The idea is a hardware-protected qubit, naturally more error-resistant, which would slash the count of physical qubits per logical one. [Majorana 2](https://www.forbes.com/sites/moorinsights/2026/07/16/microsoft-doubles-down-on-topological-qubits-with-majorana-2-chip/), in 2026, swapped aluminum for lead and jumped coherence from milliseconds to 20 seconds, and Microsoft pulled its fault-tolerance target from 2033 to 2029.

But it's the most disputed bet of them all. Much of the community doubts a real working topological qubit is even there; the latest paper shows only half the measurements that would prove the qubit. If it pans out, it's a shortcut for everyone; if not, it's a dead end. I broke this case down in [a separate article](/en/2026/07/12/quantum-news-majorana-2-and-understanding-shor/).

### The roadmaps and the timelines

**The near future is where the real debate lives.** The honest way to talk about it is with estimates, because nobody has certainty here. The most-cited reference is the [Global Risk Institute's Quantum Threat Timeline](https://globalriskinstitute.org/publication/quantum-threat-timeline/), an annual survey of experts in the field.

The 2025 edition gives something like **34% odds of a cryptographically relevant quantum computer by ~2030 and ~49% by ~2035**, with the median opinion landing between 2029 and 2032. And those estimates are for a generic CRQC, typically framed around breaking RSA-2048.

On the manufacturing side, the most explicit roadmap is [IBM's](https://www.ibm.com/roadmaps/quantum/). It projects Starling in 2029, the first large-scale fault-tolerant machine, with 200 logical qubits and 100 million operations.

Notice that 200 still sits below the more than 1,200 the attack asks for. The machine of the right size only shows up on the next step, Blue Jay, slated for 2033, with 2,000 logical qubits and a billion operations.

So even on the industry's own most aggressive roadmap, hardware with enough logical qubits to threaten secp256k1 arrives around 2033, with the usual caveat: quantum roadmaps slip. IBM is betting on [qLDPC](https://errorcorrectionzoo.org/c/qldpc) codes to get there, which cut the physical qubits behind each logical one by about 90% compared to Willow's surface code.

And China? It's right there at the frontier, which kills the one-horse-race framing. USTC's [Zuchongzhi 3.2](https://quantumzeitgeist.com/zuchongzhi-3-google-quantum-error-correction/) crossed the same error-correction threshold as Willow in 2025, with a distance-7 surface-code logical qubit, and it was the first team outside the US to get there.

But notice it's the same milestone: a single well-corrected logical qubit, the same hundredfold gap to 1,200. And publicly, China hasn't put a dated roadmap for the big machine on the table the way IBM has; the stated plan is incremental, pushing the code distance to 9 and 11. At the science frontier, it's a tie; on a calendar to the machine that breaks crypto, neither side has an easy date.

A warning about all these dates: they're the best case, with every published roadmap landing on time. A roadmap is a statement of intent, and quantum computing's track record is one of timelines slipping forward.

I'll go further, and this is my own opinion: I'd bet on a timeline at least an order of magnitude longer than these roadmaps. Keeping thousands of logical qubits in sync, error-free, for minutes on end, is anything but a linear problem. My gut says each extra logical qubit makes the whole set exponentially harder to hold together: the difficulty of syncing multiplies with every new piece, rather than just adding up.

### My read, in numbers

Mapping that onto crypto specifically, my read in round numbers, taking the roadmaps at face value (far more optimistic than my own bet just above), and always as estimate and opinion:

- **Next 2 to 3 years (through ~2029):** near zero. Going from 12 to 1,200 stable logical qubits in that window isn't on any serious public roadmap.
- **The 2030–2032 horizon:** low, but not negligible. Maybe 10% to 20% that the machine exists *in principle*. The actual theft chance is lower still, because the highest-value targets (exchanges, modern wallets) will have moved by then.
- **Around 2035:** here it becomes a coin flip for a generic CRQC, in the 40% to 50% range per the experts. Except "a CRQC exists" isn't the same as "they stole your money." By then, migration should be well underway.

The detail that decides everything, and that Mosca sums up in a simple theorem: what matters is **the machine's date minus the time your migration takes**. If migrating takes years, and the machine could arrive in five to ten, you're already in a bind, even with low short-term odds. That's why "start now" makes sense even with clear skies. Asymmetric risk management, with a cool head.

## Why this isn't "it's over, everything's lost"

Even in the scenario of a ready machine and a bad actor, the damage is surgical, hitting specific targets instead of wiping everything. And the reason is simple to grasp.

Your crypto doesn't live on your hard drive or your Ledger. It lives on the public blockchain, in plain sight, all the time. The device only holds the private key that authorizes moving it. Anyone can hit a block explorer, type an address, and see the balance. What decides your quantum exposure is one thing only: **has your public key shown up somewhere?**

On modern Bitcoin addresses (the `bc1q` ones, which hide the key behind a hash), as long as you've **never spent** from that address, the public key isn't exposed. The quantum attacker has nowhere to start, because it breaks the public key, and the key isn't there. Those funds are safe at rest.

Exposure is only born the moment you spend, and even then it's a window of minutes, against a block clock, needing that fast-clock machine that doesn't exist yet.

Watch the word, though: "quantum-resistant" is too big for these addresses. What they give you is at-rest protection, good only while the key stays hidden behind the hash. The day you spend, the public key hits the block and opens the on-spend window. The permanent shield only comes with migrating to a post-quantum signature; the hash just buys time until then.

That's why the paper talks about roughly 6.9 million vulnerable BTC, out of the nearly 20 million that exist. The biggest slice of that is reused keys and Satoshi-era P2PK, which are probably lost anyway.

It concentrates in a subset of addresses with one specific behavior, an exposed key, while the rest of the network stays out of it. Anyone using a fresh address per receipt and not spending from the same place over and over is, in practice, off the at-rest radar.

> **The vulnerable crypto is a subset of addresses with one specific behavior: an already-exposed key. A fresh, no-reuse wallet stays out of it.**

## What you can do today

Here comes the question that always shows up, and the answer that disappoints anyone hoping for a magic button.

**"If I create a wallet with a stronger password/passphrase, does that help?"** No. And understanding why teaches the whole problem.

A strong passphrase protects your *seed* — those 12 or 24 words — against someone trying to guess or steal the backup. That's great and you should do it, but it's a defense against a classical attack.

And don't mix up the problems: a badly generated seed is a separate failure, from the classical world. That's what happened with [Coinkite's weak RNG](/en/2026/08/01/exploiting-coinkites-rng-egregious-problem/), where the ColdCard itself spat out predictable keys from bad entropy at the source. There the defect is in how the key is born; quantum attacks the math of the already-finished key.

The quantum computer doesn't guess your seed. It takes your **public** key, sitting in plain sight on the blockchain, and computes the matching private key with Shor. It doesn't matter whether your private key came from a 4-character passphrase or a 40-character one: once the public key has shown up, password strength is irrelevant. Quantum attacks the curve's math, and that math is the same for everyone.

> **Quantum doesn't guess your seed. It computes your private key from the public key already in plain sight. Password strength doesn't enter into it.**

What actually moves the needle is key-exposure hygiene:

- **Don't reuse addresses.** One address per receipt. The moment you spend from an address, its public key goes to the blockchain; if you keep using that address, the remaining balance becomes exposed at rest.
- **Keep the bulk in modern addresses that hide the key behind a hash** (`bc1q`, P2WPKH) and that you've never spent from. Avoid parking reserves in Taproot (`bc1p`) and in old P2PK addresses, which expose the key directly.
- **Don't spread your extended public key (xpub) around.** Portfolio tools, a shared spreadsheet, a third-party integration: every place that gets your xpub is one more exposure point.
- **When real post-quantum wallets show up, migrate.** That's the definitive step, and it'll arrive via a software update.

And the most important thing to keep your head straight: if you store on a serious exchange or use a modern wallet without reuse, your short-term risk is practically zero. The exchange is the one that'll have to migrate for you (with the custody risks that already exist, quantum or not). No need to run around today moving anything in a panic.

## What the industry can do, without going radical

On the protocol-builder side, the temptation is the extreme: "drop everything and switch to post-quantum signatures tomorrow." That's as bad as "ignore it, it's FUD." Post-quantum cryptography is newer, less battle-tested, has much larger keys and signatures, and swapping blind introduces new bugs where there were none. The sensible path is defense in depth, starting with what's cheap.

**Intermediate measures, easier than the full swap:**

- Kill key reuse and minimize public-key exposure in the protocol and wallets by default.
- Private mempools and commit-reveal schemes, which close the on-spend attack window.
- Validator key rotation on Ethereum, a simple stopgap against the consensus attack.
- On Bitcoin, proposals like BIP-360 (the P2MR script), which removes Taproot's at-rest key exposure.

**The medium-term bridge:** hybrid signatures, which combine today's elliptic curve with a post-quantum scheme (lattice-based, for instance). You stay protected against both worlds at the cost of larger signatures, and you don't bet everything on a new scheme that might have an undiscovered weakness.

**The ground is more mature than it looks.** NIST has already standardized post-quantum schemes (ML-DSA, the former Dilithium; Falcon; SPHINCS+). Ethereum is discussing post-quantum precompiles (EIP-7932) and account abstraction, which shrink the surface without a traumatic hard fork. Blockchains like Algorand, XRP Ledger, and QRL already experiment with PQC or were born with it. The rail for this migration is already laid, far from a leap in the dark.

**And the piece nobody has solved:** dormant assets. The lost P2PK coins, including the ~1 million BTC attributed to Satoshi, have no owner to migrate them.

The paper discusses options — do nothing, burn the coins via soft fork, a "recovery sidechain," or even government-regulated salvage, on the sunken-treasure analogy.

Here I'll be blunt: **this part is the paper's weakest. It's political opinion dressed up as a technical conclusion.** Nothing in the qubit estimate says who should keep a lost coin, or whether sitting still for five years extinguishes a property right.

These are thorny legal and political choices the paper raises honestly but is nowhere near closing. Good that the conversation starts; bad to treat it as if there's a ready answer.

> **The policy section on lost coins is the paper's weakest: there the science stops and the opinion begins.**

## Where we actually stand

Summing up the near-future quantum picture in a few layers, ruler always calibrated:

| Layer | Situation | Read |
|---|---|---|
| **Theoretical** | Shor breaks secp256k1 if the machine exists | Mathematical certainty; the question is when the machine exists |
| **Reality today (2026)** | ~12 logical qubits (Quantinuum); attack needs >1,200 | A factor of ~100 in logical qubits, several orders of magnitude in physical. Nobody steals anything today |
| **Next 2–3 years (~2029)** | Off any serious public roadmap | Risk near zero |
| **2030–2032** | A machine capable *in principle* starts to be plausible | Estimate of ~10–20%; actual theft lower still, targets migrate first |
| **~2035** | Coin flip for a generic CRQC (experts: ~40–50%) | "A machine exists" ≠ "they robbed you"; migration should be underway |

The paper is serious and its math stands, now confirmed by open, independent reproduction. The threat is real enough to justify action, and the reason has a name: Mosca's theorem. Since migrating takes years, you start before the machine exists, the same way you replace a roof before the storm, while the weather's good.

But none of this is "sell everything, Bitcoin is done." The attack is about exposed keys, it's a subset of addresses, it needs a machine that's orders of magnitude from existing, and the defenses that matter now are boring hygiene: don't reuse addresses, don't park reserves in an exposed key, and migrate to post-quantum when the tooling matures.

Mining is not at risk, your modern no-reuse wallet is not at risk today, and the strongest passphrase in the world changes none of it.

That's how to read Google's paper: a competent, self-aware warning, from people who know the subject, saying the window to migrate calmly is narrower than intuition suggests — and still wider than the headline makes it look. [Read it straight from the source](https://arxiv.org/abs/2603.28846) and draw your own conclusion. Just don't fall for "it's over" or "it's all a lie." The interesting answer, as almost always, lives in the middle.
