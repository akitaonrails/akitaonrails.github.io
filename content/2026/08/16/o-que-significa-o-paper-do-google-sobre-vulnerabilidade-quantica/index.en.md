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

The document is called [Securing Elliptic Curve Cryptocurrencies against Quantum Vulnerabilities](https://arxiv.org/abs/2603.28846), and the author list alone forces you to take it seriously: it's Google Quantum AI (with Craig Gidney, the same guy behind the recent RSA-breaking estimates), plus the Ethereum Foundation (Justin Drake) and Stanford (Dan Boneh, one of the fathers of elliptic-curve cryptography). This is people who build quantum computers sitting at the same table as people who invented a good chunk of the cryptography running today. Rare weight for a subject that usually attracts a lot of hot takes from folks who never read a line of what they're trashing.

First things first: **read the paper directly**. It's long and dense, but written with rare care, including an explicit effort not to turn into FUD. What I'm doing here is my own read, then comparing it with what GLM, Kimi, and ChatGPT made of it when I asked them to tear the text apart, and finally trying to answer the question that matters to anyone holding a handful of satoshis or ether: in the real world, what are the odds a quantum computer steals your money in the next few years?

I'll tip the spirit of it upfront: the sky isn't falling. But the "start moving now" message has real grounding, and the reason is subtler than "quantum is coming."

## What the paper actually says, in plain engineer terms

Let me get the jargon out of the way first. The security of Bitcoin, Ethereum, and almost all crypto rests on a math problem: given a public key, computing the matching private key is infeasible. Everyone sees your public key; nobody can walk back from it to your private key. That one-way street is what makes a digital signature worth anything.

Shor's algorithm, running on a big enough quantum computer, breaks exactly that one-way street. It turns "infeasible" into "a matter of minutes." That's been known since 1994. The paper's news is something else, and it's five points.

**First: the cost collapsed.** The Google team presents new circuits for solving the secp256k1 curve (the curve behind Bitcoin and Ethereum accounts) using far fewer resources than anyone thought. Two recipes: one with under 1,200 logical qubits and 90 million Toffoli gates, another with under 1,450 logical qubits and 70 million gates. On superconducting hardware, with standard error-correction assumptions, that would fit in **under 500,000 physical qubits** — nearly 20 times fewer than prior estimates — and run in **9 to 12 minutes** from a precomputed state. Hold onto that number: 9 minutes. It's the scary one, because it's shorter than Bitcoin's average block interval.

**Second: they didn't publish the circuit.** Here's a move that's elegant and controversial at once. To prove they have a circuit that size without handing everyone a loaded gun, they published a **zero-knowledge proof**: a mathematical proof that they possess the circuit, without revealing the circuit. Responsible in intent. Except, as I'll get to, this part was the shakiest piece of the whole story.

**Third: not every quantum computer is good for everything.** The paper draws a distinction that's the text's best practical contribution. There's the "fast clock" (superconducting, photonic) and the "slow clock" (trapped ions, neutral atoms), with a 100x to 1,000x speed difference. Out of that speed come three types of attack:

- **On-spend attack:** the attacker intercepts your transaction in the mempool, breaks the key, and injects a rival transaction before your spend lands in a block. Needs a fast clock, because it's a race against the block clock.
- **At-rest attack:** the public key is already exposed on the blockchain (a dormant wallet, a reused key). The attacker has days or months to work. Even a slow clock does the job.
- **On-setup attack:** a single quantum computation extracts a secret from a cryptographic ceremony and becomes a reusable master key, which then runs on ordinary classical computers. This one's the most insidious, and it hits things like Ethereum's data-availability mechanism.

**Fourth: the map of who bleeds.** On Bitcoin, the at-rest targets are the old P2PK scripts (about 1.7 million BTC, almost all Satoshi-era and probably lost), Taproot (P2TR, which exposes the key), and any reused address. All told, the paper estimates around 6.9 million BTC vulnerable today, of which some 2.3 million have been dormant for more than five years. Modern addresses that hide the key behind a hash and have never spent stay safe at rest. And there's good news buried here: **Bitcoin mining is not at risk**. Grover's algorithm, which would attack mining, has too small a gain and doesn't parallelize; error-correction overhead eats it all. The paper buries that myth on purpose.

**Fifth: Ethereum has a much larger surface.** The account model exposes the public key permanently after the first transaction, unlike Bitcoin's UTXO model. Add to that contract admin keys (stablecoins, bridges, oracles), the BLS signatures holding up Proof-of-Stake consensus, and the KZG commitments in the data layer. More stuff exposed, and much of it you can't "change addresses" to escape.

And how does the paper argue all this? Three legs: the resource estimates (with the zero-knowledge proof for credibility), real blockchain data (the BTC and ETH at-risk figures come from public BigQuery queries), and the honest framing that this is a warning to migrate, not an announcement that the machine exists. The paper, by the way, **gives no date**. It estimates resources, not a calendar.

## Where I agree and disagree with the other models

I asked GLM 5.3, Kimi K3, and ChatGPT (GPT 5.6) to analyze and criticize the paper. The interesting part is that all three, and I, converge on the essentials and diverge on exactly the same points. That's a good sign: when different models hammer the same nail, the nail usually exists.

**What everyone agrees on (me included):**

- The logical-resource estimate is **credible**. It's not a number out of nowhere: it follows the historical trajectory (the cost to break RSA-2048 fell from ~1 billion qubits in 2012 to under 1 million in 2025) and comes from the very group that produced the field's best estimates.
- The fast-clock / slow-clock distinction and the spend / rest pairing are the right lens for thinking about mitigation.
- The mining immunity is correct and needed saying out loud.
- Dormant assets are a real problem no software fork solves on its own, because nobody holds the private key to move the lost coins.

**What everyone pokes at (and I poke harder):**

ChatGPT was the sharpest on a distinction worth gold: **"value at risk" is not "expected loss"**. When the paper says "20.5 million ETH in vulnerable accounts" or "6.9 million BTC exposed," that measures dependence on fragile cryptography, not money that would be stolen. There's overlap, there's multisig, there's admin keys you can rotate, there are contracts with an emergency council that pauses everything. Stacking those numbers into a "trillions at risk" headline is dishonest to the paper itself.

Same goes for the famous **41% chance of theft on Bitcoin**. That number is only the probability that the 9-minute computation finishes before the next block shows up (a block arrives every 10 minutes on average, but with a lot of variance). It's not the chance of stealing your money. To steal, the attacker still has to propagate the rival transaction, convince a miner to include it, win the fee race. And the paper itself assumes attacker-friendly conditions (no network congestion, instant delivery). Kimi and ChatGPT hit this; I sign my name under it.

The most important point, and one I think the paper leaves between the lines on purpose: **the 500,000 physical qubits and the 9 minutes are a conditional engineering scenario, not a date prediction.** It's a blueprint for a machine that *could* do the attack, assuming a 0.1% error rate, 1-microsecond correction cycles, low-latency decoding, enough magic-state factories, and half a million qubits running stable for minutes on end. Each assumption is reasonable in isolation. The whole chain working together, at that scale, nobody has demonstrated.

And here's the juiciest part, which Kimi and ChatGPT caught and I confirmed by searching outside: **the zero-knowledge proof sprang a leak.** Trail of Bits [managed to forge a proof](https://blog.trailofbits.com/2026/04/17/we-beat-googles-zero-knowledge-proof-of-quantum-cryptanalysis/) by exploiting memory and logic bugs in Google's Rust verifier code — it even produced a proof reporting zero Toffoli gates for a circuit that wasn't even reversible. Google patched the verifier in version 2, and the scientific claim itself wasn't affected. But the episode shows the zero-knowledge proof only moved the problem around: instead of trusting Google's word, you now trust its parser, its compiler, and its simulator.

What actually validated the result came later, and it's the best news for anyone who wants truth over faith: in June 2026, researcher André Schrottenloher [reproduced the secret circuits in the open](https://postquantum.com/security-pqc/google-ecdlp-circuits-reproduced-open/), landing in the same region (about 56 million Toffoli gates, with the entire circuit published and reproducible). Gidney himself acknowledged the reproduction captured the essential breakthrough. After that, others already pushed the number below a thousand logical qubits. So: the logical estimate is solid, and no longer rests on taking anyone's word. Open science, not the zero-knowledge proof, is what closed the case.

One last point almost nobody raises and I think needs saying: **conflict of interest.** Seven authors are from Google Quantum AI, whose hardware roadmap is precisely the superconducting architecture the paper makes look like the nearest threat. And there's an Ethereum Foundation coauthor on a paper that ranks Ethereum as more exposed and recommends urgent migration. The authors disclose long positions in crypto and no shorts, which is honest. None of this invalidates anything — the team's technical chops are the best in the field — but it calls for a calibrated read, not a hysterical one.

## The question that matters: what are the real odds, and when?

Let's separate the theoretical from the real, which is where most of these debates turn to mush.

**In theory, the answer is yes, comfortably.** If a big, stable enough machine exists, Shor's algorithm breaks secp256k1. In math terms there's no "if"; it's engineering. The whole question boils down to: *when does that machine exist?*

**In today's reality, we're far off.** The best public logical-qubit result in 2026 is Quantinuum's, with 12 logical qubits running below the error threshold. The paper needs more than 1,200. That's a factor of a hundred in logical qubits, and each logical qubit costs thousands of physical qubits at a quality and stability we don't have yet. In physical qubits, the largest announced system is in the low thousands; the attack asks for nearly half a million. Several orders of magnitude of distance, across several dimensions at once. Nothing a fine-tuning pass fixes.

**The near future is where the real debate lives.** The honest way to talk about it is with estimates, not certainty. The most-cited reference is the [Global Risk Institute's Quantum Threat Timeline](https://globalriskinstitute.org/publication/quantum-threat-timeline/), an annual survey of experts in the field. The 2025 edition gives something like **34% odds of a cryptographically relevant quantum computer by ~2030 and ~49% by ~2035**, with the median opinion landing between 2029 and 2032. And those estimates are for a generic CRQC, typically framed around breaking RSA-2048.

Mapping that onto crypto specifically, my read in round numbers, and making clear it's estimate and opinion:

- **Next 2 to 3 years (through ~2029):** near zero. Going from 12 to 1,200 stable logical qubits in that window isn't on any serious public roadmap.
- **The 2030–2032 horizon:** low, but not negligible. Maybe 10% to 20% that the machine exists *in principle*. The actual theft chance is lower still, because the highest-value targets (exchanges, modern wallets) will have moved by then.
- **Around 2035:** here it becomes a coin flip for a generic CRQC, in the 40% to 50% range per the experts. Except "a CRQC exists" isn't the same as "they stole your money." By then, migration should be well underway.

The detail that decides everything, and that Mosca sums up in a simple theorem: what matters is **the machine's date minus the time your migration takes**. If migrating takes years, and the machine could arrive in five to ten, you're already in a bind, even with low short-term odds. That's why "start now" makes sense even with clear skies. Asymmetric risk management, with a cool head.

## Why this isn't "it's over, everything's lost"

Even in the scenario of a ready machine and a bad actor, the damage is surgical, not a bomb that wipes everything. And the reason is beautiful to understand.

Your crypto doesn't live on your hard drive or your Ledger. It lives on the public blockchain, in plain sight, all the time. The device only holds the private key that authorizes moving it. Anyone can hit a block explorer, type an address, and see the balance. What decides your quantum exposure is one thing only: **has your public key shown up somewhere?**

On modern Bitcoin addresses (the `bc1q` ones, which hide the key behind a hash), as long as you've **never spent** from that address, the public key isn't exposed. The quantum attacker has nowhere to start, because it breaks the public key, and the key isn't there. Those funds are safe at rest. Exposure is only born the moment you spend, and even then it's a window of minutes, against a block clock, needing that fast-clock machine that doesn't exist yet.

That's why the paper talks about roughly 6.9 million vulnerable BTC, not the nearly 20 million that exist. The biggest slice of that is reused keys and Satoshi-era P2PK, which are probably lost anyway. Not the whole network — just a subset of addresses with one specific behavior: exposed key. Anyone using a fresh address per receipt and not spending from the same place over and over is, in practice, off the at-rest radar.

## What you can do today

Here comes the question that always shows up, and the answer that disappoints anyone hoping for a magic button.

**"If I create a wallet with a stronger password/passphrase, does that help?"** No. And understanding why teaches the whole problem.

A strong passphrase protects your *seed* — those 12 or 24 words — against someone trying to guess or steal the backup. That's great and you should do it, but it's a defense against a classical attack. The quantum computer doesn't guess your seed. It takes your **public** key, sitting in plain sight on the blockchain, and computes the matching private key with Shor. It doesn't matter whether your private key came from a 4-character passphrase or a 40-character one: once the public key has shown up, password strength is irrelevant. Quantum attacks the curve's math, and that math is the same for everyone.

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

**And the piece nobody has solved:** dormant assets. The lost P2PK coins, including the ~1 million BTC attributed to Satoshi, have no owner to migrate them. The paper discusses options — do nothing, burn the coins via soft fork, a "recovery sidechain," or even government-regulated salvage, on the sunken-treasure analogy. Here I'll be blunt: **this part is the paper's weakest, and it's advocacy, not science.** Nothing in the qubit estimate says who should keep a lost coin, or whether sitting still for five years extinguishes a property right. These are thorny legal and political choices the paper raises honestly but is nowhere near closing. Good that the conversation starts; bad to treat it as if there's a ready answer.

## Where we actually stand

Summing up the near-future quantum picture in a few layers, ruler always calibrated:

| Layer | Situation | Read |
|---|---|---|
| **Theoretical** | Shor breaks secp256k1 if the machine exists | Mathematical certainty; the question is when the machine exists |
| **Reality today (2026)** | ~12 logical qubits (Quantinuum); attack needs >1,200 | A factor of ~100 in logical qubits, several orders of magnitude in physical. Nobody steals anything today |
| **Next 2–3 years (~2029)** | Off any serious public roadmap | Risk near zero |
| **2030–2032** | A machine capable *in principle* starts to be plausible | Estimate of ~10–20%; actual theft lower still, targets migrate first |
| **~2035** | Coin flip for a generic CRQC (experts: ~40–50%) | "A machine exists" ≠ "they robbed you"; migration should be underway |

The paper is serious and its math stands, now confirmed by open, independent reproduction. The threat is real enough to justify action, and the reason has a name: Mosca's theorem. Since migrating takes years, you start before the machine exists, the same way you replace a roof in the summer, not in the middle of the storm.

But none of this is "sell everything, Bitcoin is done." The attack is about exposed keys, it's a subset of addresses, it needs a machine that's orders of magnitude from existing, and the defenses that matter now are boring hygiene: don't reuse addresses, don't park reserves in an exposed key, and migrate to post-quantum when the tooling matures. Mining is not at risk, your modern no-reuse wallet is not at risk today, and the strongest passphrase in the world changes none of it.

That's how to read Google's paper: a competent, self-aware warning, from people who know the subject, saying the window to migrate calmly is narrower than intuition suggests — and still wider than the headline makes it look. [Read it straight from the source](https://arxiv.org/abs/2603.28846) and draw your own conclusion. Just don't fall for "it's over" or "it's all a lie." The interesting answer, as almost always, lives in the middle.
