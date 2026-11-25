---
title: "Understanding the Alleged Proof of the Riemann Hypothesis"
date: '2026-11-25T09:00:00-03:00'
slug: understanding-the-alleged-proof-of-the-riemann-hypothesis
translationKey: entendendo-a-suposta-prova-da-hipotese-de-riemann
description: "Anthropic's Levent Alpöge announced a 17-million-line Lean proof of the Riemann Hypothesis built with Claude, joked about 250,000 pages, and drew fraud claims over anyGeometry := True. Here is what holds up."
tags:
- artificial-intelligence
- computer-science
- llms
draft: false
---

Last Friday, November 20, mathematician **Levent Alpöge** (a member of the technical staff at Anthropic) dropped a bombshell: he posted a short note at [alpo.ge/remark.pdf](https://alpo.ge/remark.pdf) claiming that, working alongside an internal version of **Claude**, he had proved both the **Riemann Hypothesis** and the **Generalized Riemann Hypothesis** for Dirichlet L-functions.

What immediately set the internet on fire was how he released it. Rather than submitting a conventional paper to a math journal, he dumped a **17.4-million-line Lean 4 codebase** spread across **175,187 files**, accompanied by a footnote saying he had amused himself letting Claude generate a prose draft that crossed **250,000 pages**.

On Monday (November 23), after the "250,000 pages" line went viral across tech media and irritated mathematicians everywhere, Alpöge posted a [thread on X titled *"Stupid things I did"*](https://x.com/__alpoge__/status/2124987173439209561) and flat out admitted: *"250,000+ pages was a joke guys!, I find big number extremely hilarious."* He explained he had been *"lengthmaxxing"* the prose for laughs, even packing Theorem 1 with absurd pedantry about the real numbers being totally ordered, conceded the Lean codebase itself was messy (*"yoloing a lot in there"*), and [pushed back on X](https://x.com/__alpoge__/status/2125062170207457583) against people misreading the thread by insisting the formal proof itself stood.

Right in the middle of that storm, today (November 25), researcher **J. L. Nielsen** posted [The Invalidity of Alpöge's Proof of the Riemann Hypothesis](https://philpapers.org/archive/NIEIOT-2.pdf) on PhilPapers, calling the proof a fraudulent tautology built on predicates that always return `True`. Let's cut through the circus and look at what is actually happening here.

## In plain terms: what is the Riemann Hypothesis, and what changes in practice?

Proposed by Bernhard Riemann in 1859, the **Riemann Hypothesis** is the most famous of the seven Clay Millennium Prize Problems (each carrying a one-million-dollar bounty). At heart, it is about the hidden pattern governing **prime numbers** (2, 3, 5, 7, 11, 13...).

Up close, primes look chaotic. Zoom out, and their overall density follows a remarkably tight asymptotic law. If you want to see this visualized cleanly, I strongly recommend [3Blue1Brown's classic video on the Riemann Hypothesis](https://www.youtube.com/watch?v=sD0NjbwqlYw).

Riemann discovered that the "error term" between the smooth estimate and the actual prime count is controlled by a function called the **Riemann zeta function** (written with the Greek letter zeta: `ζ(s)`). Rather than taking ordinary numbers on a single line (like 1, 2, or 3), this function takes **complex numbers** (`s`), which act like coordinates on a 2D map: the horizontal axis is the "real part" (the everyday numbers `-1, 0, 1, 2...`) and the vertical axis is the "imaginary part" (`1i, 2i, 3i...`).

[![Visualization of the Riemann Hypothesis critical line on the complex plane, from the 3Blue1Brown video](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/25/riemann-hypothesis/3blue1brown-critical-line.png)](https://www.youtube.com/watch?v=sD0NjbwqlYw)

Look at the image above from [3Blue1Brown's video](https://www.youtube.com/watch?v=sD0NjbwqlYw). The hypothesis states that every interesting point where this function hits zero (the "non-trivial zeros," shown as yellow dots) lines up straight along that **yellow vertical line** crossing the horizontal axis halfway between 0 and 1 (X coordinate equal to `0.5`, or `1/2`, the famous **critical line**). Computers have checked trillions of zeros so far and every single one landed on that line, yet in mathematics checking trillions of cases still leaves the next trillion unproven.

> **So what changes in your practical day-to-day life if the Riemann Hypothesis is finally proved? Almost nothing in the short term.**

First, let's kill the biggest myth floating around online: **proving the Riemann Hypothesis does not break RSA cryptography or Bitcoin**. RSA rests on the difficulty of factoring the product of two huge primes (`n = p × q`). Knowing with pinpoint precision how many primes live below a bound `X` hands you zero shortcuts for finding which two primes multiply to produce a specific modulus `n`. (The real threat to RSA remains quantum computing via Shor's algorithm.)

In practice, a valid proof promotes thousands of number-theory results and certain deterministic primality algorithms (such as the Miller test) from conditional statements ("assuming RH/GRH") into unconditional theorems. Much like OpenAI's September announcement around [Navier-Stokes](https://en.wikipedia.org/wiki/Navier%E2%80%93Stokes_existence_and_smoothness) (a problem whose theoretical resolution matters enormously to pure mathematicians while aerospace and weather engineers already run CFD approximations every day), proving Riemann is a historic triumph of pure math and mostly a theoretical *"nice to have"* for everyday engineering.

## What Lean is, and why "it compiles" is never enough on its own

To make sense of the fight between Alpöge and his critics, it helps to know what **Lean 4** actually is. Lean is both a functional programming language and an interactive proof assistant, originally created by Leonardo de Moura at Microsoft Research and now maintained by the Lean FRO.

In Lean, mathematical statements are written as **types**, and proofs are written as **programs** that produce a value of that type. When the code compiles through Lean's kernel with no placeholders (`sorry`) and no custom axioms, the compiler guarantees that the logical steps derive the conclusion from the declared definitions.

There is a massive catch that people outside formal methods routinely miss: **Lean's kernel checks the internal logic of your code, yet it has zero clue whether the definition you wrote matches real-world mathematics**. A Lean file can compile cleanly, pass with zero errors and zero extra axioms, and still be mathematically bogus if the formal definition or hypotheses of the statement contain a flaw.

Look at a tiny pure Lean 4 example that compiles on the first try and "proves" mathematical nonsense:

```lean
-- We define "every prime is even" with an impossible hidden hypothesis:
def EveryPrimeIsEven : Prop :=
  ∀ n : Nat, (n > 2 ∧ n < 2) → n % 2 = 0

theorem proved_every_prime_is_even : EveryPrimeIsEven := by
  intro n h
  omega

#print axioms proved_every_prime_is_even
-- Output: depends on no axioms and compiles with zero 'sorry'
```

That snippet compiles cleanly, passes the checker with zero `sorry`s, and uses zero extra axioms. Obviously, the mathematical claim that every prime is even is dead wrong; the trick sits inside the definition `EveryPrimeIsEven`, where `n > 2 ∧ n < 2` can never hold (and in classical logic, a false premise implies anything).

That is why "it compiled in Lean" by itself proves nothing. Beyond compilation, you have to audit the **definitions and assertions** of the headline statement to be certain the program is actually proving the real Riemann Hypothesis, with no hidden trick baked into the statement.

## What the Lean community actually verified

Regular readers will remember my recent post on [why we don't write definitive formal proofs everywhere](/en/2026/10/24/why-dont-we-write-definitive-formal-proofs-of-bug-free-code/), where I walked through how a formal proof kernel works. With Lean 4, releasing code instead of a PDF means anyone with enough hardware can run the checker and audit whether every logical step obeys the rules.

The Lean community and MIT jumped on it fast. I did not compile the 175,000 files locally on my own workstation because the raw proof export alone weighs **61.6 GB** and eats nearly **100 GiB of RAM** and **48 to 72 hours** single-threaded across Lean's default and paranoid kernels. Fortunately, **Andrew Sutherland (MIT)** logged every step of his replication at [math.mit.edu/~drew/grh/](https://math.mit.edu/~drew/grh/), and the **Lean FRO** together with the **Mathlib Initiative** issued a [joint statement](https://leanprover-community.github.io/blog/posts/riemann-hypothesis/) confirming four objective facts:

* All **175,187 modules** compile with zero errors on Lean v4.33.1 / Mathlib v4.33.1, and an independent networkless sandbox `lake build` reproduced the exact 61.57 GB proof export byte for byte.
* Running `#print axioms` on the headline theorems reports **only Lean's three standard axioms** (`propext`, `Classical.choice`, and `Quot.sound`), with zero `sorry` placeholders and zero custom axioms.
* Two independent statement-matching tools (`comparator` and `con-leche --compare` / `con-ron --compare`) confirmed that the theorem proved in `Main.lean` matches Mathlib's vetted definition of `RiemannHypothesis` identically.
* The inert proof export was accepted with zero rejections by Lean's default kernel, Lean's paranoid kernel, and independent third-party checkers (including Rust implementations), such as `nanoda` (Rust, about 28 minutes on 80 threads), `con-leche` (Lean, 3 minutes on 64 threads), and `con-ron` (Rust, 7 minutes on 64 threads), where `con-leche` and `con-ron` themselves carry a formal proof relative to set theory that they cannot accept a false deduction.

> Mechanically speaking, Lean's kernel and multiple independent checkers confirmed that a closed term of type `RiemannHypothesis` exists using only standard axioms.

## The fraud claim: `anyGeometry := True` and Nielsen's paper

If independent proof checkers signed off on everything, why is J. L. Nielsen's paper [NIEIOT-2.pdf](https://philpapers.org/archive/NIEIOT-2.pdf) calling the entire proof a fraudulent tautology?

Because Nielsen dug into those 175,000 AI-generated files and actually found bizarre artifacts sitting along the dependency chain of the main theorem (`everyCharacter`):

* A geometric predicate literally defined as `def anyGeometry : GeoP := fun _ _ _ => True`, which ignores all three arguments and always returns `True` (the Lean equivalent of `assert true`), appearing 118 times across 24 files and discharged via `GeoCl.base trivial`.
* Degenerate geometric models literally named `geoDegenerate`, `algDegenerate`, `padDegenerate`, and `mdlJunk`, with zeroed volumes, empty surfaces (`Empty`), and a lattice-to-sections map sending every vector to zero.
* A `setDiv` step that overwrites the divisor height field (`div.h`) directly with the analytic formula `hExpl6`, letting the height equation `div.h u = hExpl6` close by reflexivity (`rfl`).

From this, Nielsen concludes the proof is circular: the program pretends to check geometry with a fake `True`, pastes the analytic target into the geometric height field, checks that the copy matches the original via `rfl`, and declares the Riemann Hypothesis proved.

### Who is actually right here?

This is where understanding type theory and compilers keeps you from swallowing nonsense from either camp.

**Nielsen is right about the mess in the codebase.** Those definitions (`anyGeometry := fun _ _ _ => True`, `geoDegenerate`, `mdlJunk`, `setDiv`) really are sitting right there in the release. The codebase Alpöge and Claude produced is a sprawling pile of abandoned scaffolding and dead code accumulated over months of iteration.

**Yet Nielsen is dead wrong in concluding that this invalidates the Lean proof.** Under Lean 4's type theory (the Curry-Howard correspondence), a proof is a program whose return type is the theorem. When a theorem has the signature `theorem riemannHypothesis : RiemannHypothesis` (taking zero input assumptions, zero `sorry`, and zero extra axioms), it is **logically impossible** to conjure a value of type `RiemannHypothesis` out of `fun _ _ _ => True` or an internal struct `rfl`, unless Lean's kernel plus three independent checkers all share a catastrophic soundness bug that would let you prove `False`.

The smoking gun sits right inside **Appendix A** of Nielsen's own paper (page 17). When she writes a minimal Lean 4 snippet to "reproduce the exact tautological pattern with zero `sorry`s," look at the signature the Lean compiler forced her to write:

```lean
theorem claimed_rh (hRH : RiemannHypothesis) :
  (∃ b : Bundle, anyGeometry 0 ∧ b.model.height = targetFormula) ∧ RiemannHypothesis := by
  let b := buildBundle
  exact ⟨⟨b, valid_bundle_of_manufactured b⟩, hRH⟩
```

Look closely at the parameter **`(hRH : RiemannHypothesis)`** on the first line. To make her "tautological" demo compile, she had to **pass the Riemann Hypothesis itself as an input assumption** and simply hand it back in the return value. Alpöge's `Main.lean` takes **no such input assumption**: it constructs `RiemannHypothesis` from scratch.

What `anyGeometry := fun _ _ _ => True` actually exposes is the opposite of a kernel fraud: it exposes **dead fat**. If the compiler lets you plug `True` into the geometric predicate and still derives `RiemannHypothesis` with no extra axioms, that means **the real proof never needed that geometric layer in the first place**. All the heavy lifting that rules out zeros off the critical line happened inside the analytic and matrix inequalities (`DivInputsR`, `WordFacts`, `LinkGLOBAL`), and Claude simply left the degenerate geometric shell hanging around in the architecture.

## The real problem: compiled code still has to be understood

Even with Nielsen's fraud argument collapsing at the kernel level, skeptics still have a serious point that no AI hype can wave away.

Alpöge himself admitted in `remark.pdf` that he handed the world a complete formal argument before mastering a huge neighborhood of the mathematics Claude assembled. And his social-media antics, joking about "250,000 pages" while dumping 17.4 million lines littered with `mdlJunk` onto the community, only poisoned the well further.

In mathematics, a green checkmark from a proof assistant guarantees mechanical soundness, while the actual goal of science goes far beyond shipping a 61 GB binary that passes CI. That is why researchers like **Manvir Jaswal** immediately started writing reading guides ([The Riemann hypothesis for Dirichlet L-functions [after Levent Alpöge]](https://hexagonmath.org/pdf/2611.00799v1)) and figures like **Kevin Buzzard** and **Terence Tao** point out that the real work now is reverse-engineering this black box, pruning millions of lines of bloat, and distilling a clean proof that humans can actually read, grasp, and build on.

## Science is not a popularity contest

What bothered me most watching this saga unfold over the past five days was seeing how many people turned it into tribal fandom. On one side, people declaring *"my favorite mathematician says it passed Lean, case closed, it's proved."* On the other, people waving Nielsen's PDF around without reading Appendix A and shouting *"I knew Anthropic was running a scam."*

Science and mathematics do not run on appeals to authority, and they certainly do not run on majority vote. Having a stamp from MIT, the Lean FRO, or a Fields Medalist tells you where to look first, yet authority never replaces clarity and reproducibility.

> Either an explanation is completely clear, transparent, and reproducible for any qualified person to verify step by step, or the scientific work is still unfinished.

Right now we have a remarkable computational artifact that cleared the strictest formal checkers on Earth, tangled inside millions of lines of AI-generated spaghetti and an avoidable PR circus. Until the community strips out the dead fat, translates the core idea into readable mathematics, and confirms every piece in broad daylight, the only grown-up stance is technical curiosity paired with healthy skepticism, far away from cheerleading.
