---
title: "Why Don't We Write Definitive Formal Proofs of Bug-Free Code?"
slug: why-dont-we-write-definitive-formal-proofs-of-bug-free-code
date: '2026-10-24T15:00:00-03:00'
draft: false
translationKey: por-que-nao-fazemos-provas-formais-definitivas-de-codigo-sem-bug
description: "Anthropic proved 123 open-source libraries never crash, using 180 million lines of AI-written proof. What formal verification is, why seL4 cost 20 person-years, why Bend 2 changes the game, and what PHP2Shell, GitLab and Railway say about technical debt coming due."
tags:
- security
- software-engineering
- artificial-intelligence
- programming-languages
---

On Thursday, October 22, Anthropic published a research piece called [LLMs are making formal software verification feasible at a much larger scale](https://www.anthropic.com/research/formal-verification). I read it twice, because the first pass left me skeptical and the second left me uneasy. Not at what they did, but at the size of what they admit is still missing.

The summary: in a collaboration with [Theorem](https://theorem.dev/), Anthropic used Claude to generate formal security proofs over the compiled code of **123 open-source libraries**, covering **239 entry points** from Google's OSS-Fuzz test suite. The property proved is concrete: for any input up to 64 MB, and for any modeled operating-system response and memory layout, that binary **never crashes**, never violates memory safety, and never fails an assertion. That is roughly **180 million lines of Rocq** (formerly Coq), with a typical proof running around 600,000 lines for a median binary of 18,000 RISC-V instructions.

Along the way, Claude found and fixed bugs that had been sitting there for years, including things fuzzers never caught: an underflow in a decompressor that only showed up on inputs of about 20 MB with a rare layout, an out-of-bounds read that needed a 64 MB input and more than 2 GB of memory, and a rediscovery of CVE-2026-56132 in libexpat. It also found logic bugs that never crash, the kind that sail through any test suite.

I'm going to unpack all of this. First what formal proof actually is, then the seL4 case, then why it was never cheap, then what Anthropic admits, then the horrible week of vulnerabilities that motivated the piece, and finally my read on what is happening.

## What formal software proof actually is

Everybody repeats "proven code" like it's a quality seal. It isn't. A formal proof is a mathematical statement about a model of your program, checked mechanically by a separate program called the proof kernel.

The flow is always the same:

1. you write a **specification**: a formal description of what the program must do;
2. you **model** the program, or the language it was written in, with mathematical semantics;
3. you write a **proof** that the program satisfies the specification;
4. a **checker** verifies the proof against the specification, mechanically.

What comes out of this is not "no bugs". It is "no bugs **that violate this specification**, given this model of the world". The gap between those two sentences is where 90% of the hard engineering lives, and it is why Anthropic spends a whole limitations section on it.

One distinction confuses a lot of people. There are two big families:

**Deductive proof (theorem proving).** You write the proof in an assistant like Isabelle/HOL, Rocq, Lean or F*, and the kernel checks it. It's what seL4 uses, and what Anthropic used. It covers large systems, allows rich specifications, and costs a lot of human effort per proven line.

**Model checking.** You describe the system as a finite state machine and the tool explores every state. It's cheaper and automates well, but it chokes on combinatorial explosion and on infinite data types. Tools like SPIN, TLA+ and CBMC live here.

There is a third path, the one industry uses most without calling it formal proof: **abstract interpretation**. The compiler doesn't prove your program; it computes a safe approximation of every possible behavior and warns when something looks off. That's what [Astrée](https://www.astree.ens.fr/) does on Airbus avionics code, and Astrée proves zero runtime errors in flight-control C code.

And there's the family that grows fastest in practice, **type- and contract-assisted verification**: Dafny, SPARK/Ada, F*, Verus for Rust, refinement types. You don't write a 600,000-line proof; you write contracts and let an SMT solver (Z3, CVC5) discharge the obligations. The cost drops an order of magnitude, and the price is that you're limited to what the solver can decide.

## The specification problem is the whole problem

Anthropic was explicit about this, and it's the part almost no formal-proof enthusiast wants to face: *"the difficulty of obtaining a comprehensive and unambiguous spec is a significant obstacle to verifying software at a larger scale"*.

Think about what "correct" would even mean for a text editor. Or a browser. There's no single answer, because the specification is a product decision, not a mathematical fact. For a PNG decoder it's easy: RFC 2083 defines everything. For a refund policy, the specification is a board meeting.

The way out Anthropic found is clever and worth understanding, because it changes the game in practice: **turn the existing fuzz test into a specification**. Instead of inventing a description of desired behavior from scratch, they take the test the developer already wrote, compile it to RISC-V, and the specification becomes "this test never crashes for any input up to 64 MB". If the test checks a compression round-trip, proving it never fails proves the round-trip property. If it checks an algebraic law, you proved the law.

It's an honest shortcut and, at the same time, an admission: the industry still doesn't know how to write good specifications for most software, so the move is to extract spec from what already exists as a test.

## seL4: the case that shows both the ceiling and the cost

If you want to understand why formal proof isn't routine, study [seL4](https://sel4.systems/). It's the best-documented example that exists, and the numbers are the entire argument.

seL4 is a third-generation L4-family microkernel with **8,700 lines of C and 600 lines of assembly**. It was designed from the start to be verifiable, which is already a rare decision: the NICTA team in Sydney built the kernel with the proof in mind.

The functional-correctness proof, done in Isabelle/HOL, is about **200,000 lines of script** and roughly **10,000 intermediate lemmas**. The team reports somewhere between 20 and 25 person-years of total effort, with about 11 person-years specifically on the seL4 proof, the rest going into frameworks, libraries and tooling that later served other projects. Anthropic's paper cites the rounder numbers: 2 person-years to implement, **20 to verify**.

And what does the proof guarantee? That the kernel never violates its specification, never crashes, never violates memory safety, and enforces the access-control properties it claims. Nothing more. The seL4 paper itself lists what's left out: the proof **assumes** the correctness of the compiler, the assembly code, the hardware and the boot code.

That "assumes the compiler" turned into a problem of its own, and it's one of the most interesting parts of the story. After the original work, Thomas Sewell and others built **binary verification**: a toolchain that proves the compiled binary refines the C code. That removes the compiler from the trusted base. The work continues today with funding from the seL4 Foundation.

Three lessons I take from seL4:

**The first is that the proof finds bugs.** The verification effort found **144 implementation defects** and drove **54 code changes**, including bugs normal testing missed. A proof isn't just a seal at the end; the process of proving is a violent debugging method.

**The second is that design matters more than tooling.** seL4 is small enough to prove because someone decided it would be. A 5-million-line monolith with threads, dynamic allocation and plugins doesn't become verifiable through effort, it becomes verifiable through a rewrite.

**The third is that the cost is real and measurable.** Twenty person-years for 10,000 lines. That's the benchmark against which any "AI will fix it" promise has to be measured.

## Why it was never cost-effective

Now the part that answers this article's title. There are five reasons, and they compound.

### The proof is bigger than the code, by orders of magnitude

In seL4, 200,000 lines of proof for 8,700 lines of C: a factor of 23. In CompCert, the verified C compiler, it's [42,000 lines of Coq](https://compcert.org/doc/) and about 3 person-years, with 76% of the total going to proof rather than the compiler itself. At Anthropic, a typical proof runs 600,000 lines for 18,000 machine instructions, a factor of 33.

That's not bloat: it's the nature of the job. Proving a program does the right thing on every path requires arguing about every path, and the number of paths grows faster than the number of lines.

### Maintenance is the silent killer

A proof is valid for a snapshot of the code. Change one line and the proof may stop holding, and the re-proving work is proportional to how much the change disturbed the invariants. In software that evolves weekly, you pay the proof cost again and again.

Compare with tests: a test that breaks tells you behavior changed. A proof that breaks tells you the structure of your argument changed, which is usually far more work to fix. That's why strong verification survives in frozen firmware and dies in SaaS products.

### The target moves faster than the proof

Every niche where formal proof took hold has slow evolution and catastrophic consequences: OS kernels, compilers, cryptography, flight control, train control, satellite components. In those worlds the cost of being wrong is measured in lives or billions, and the cost of proving is amortized over decades of operation.

E-commerce, fintech, marketplaces, B2B SaaS: the requirement changes on Tuesday, the competitor ships on Thursday, and product wants the A/B test on Friday. Formally proving a business rule that will be rewritten in three months is burning money. What works in those domains is tests, observability, feature flags and fast rollback.

### You prove the model, not the world

This is the most underrated limitation. Every proof carries a **trusted base**: the set of things you simply believe. In Anthropic's case the text lists honestly what's left: the formal models of RISC-V and Linux processes, the exact theorem statements, and the Rocq kernel. Technically also the hardware, the OS, and the OCaml compiler running the checker.

In an ordinary software proof, the trusted base also includes the compiler (unless you use binary verification), the standard library, the allocator, the kernel, and the FFI boundary. Every unverified piece of C at the bottom of the stack is a hole in the guarantee. You can have the most proven core in the world calling a JSON library with a parser bug.

### The cost of error isn't uniform

Formal proof treats every bug as equally important, because the specification is binary. Reality isn't: a crash that kills a worker is annoying, an anonymous RCE is catastrophic, and a rounding error in a report is irrelevant. Spending uniform proof effort on heterogeneous software allocates resources in the wrong place.

What the industry does, when it does it well, is the opposite: **concentrate strong verification on the critical core and leave the rest to tests**. That's exactly the lesson from my Bend 2 experiment, and I'll get back to it shortly.

## Bend 2: the attempt to flip the cost curve

In September I wrote about [Bend 2](/en/2026/09/19/new-ai-language-just-released-bend-2/), Victor Taelin's language, and at the time the pitch struck me as overblown. Re-reading it now against Anthropic's paper, his design makes more sense than I gave it credit for.

The central idea in Bend 2 is splitting the program into two files:

- `LAWS.bend`, written by the human, holding the system's invariants;
- `PROOF.bend`, written by the AI, holding the proofs of those laws.

The type checker is a proof verifier in the Lean/Rocq lineage. If the proof doesn't close, the code doesn't land. The checker runs in 0.1 seconds, which is the genuinely novel part: you can put it in the agent loop, on every edit. Lean takes 19 seconds and Rocq 6 seconds for the same test set Bend resolves in 0.38 s, though his benchmarks have fair caveats, because he skips elaboration and unification.

In my test, the most useful result was this: to guarantee two simple facts about a guard of about 30 lines, I needed **93 lines of laws and proofs**. And I left out exactness of the algorithm, all the U32 arithmetic, and literally the rest of the program: JSON, sorting, rendering, IO. The provable surface was a few percent of the code.

That's the same phenomenon as seL4, at toy scale: **the proof is bigger than the code and covers less than you'd like**. The difference is that in Bend the cost per proven line is seconds, not person-years, and that's where things get interesting.

And there's the lesson I consider the most important from my experiment, and it applies to any verification project: **prove an isolated guard, leave the algorithm outside the proof**. The ghpending `--limit` allocator ended up in two stages, with the algorithm in unproven U32 proposing values and a proven Nat guard clipping the excess. The law holds even if the unproven stage proposes garbage. The guard doesn't trust arithmetic it can't see.

That's the pattern that makes proof work in real code: you don't prove the system, you prove the boundary where an error is catastrophic, and leave the rest to tests. Anthropic's paper does exactly this by choosing to prove "this fuzz entry point never crashes" instead of "this library is correct".

Bend's other lesson, and this one is harsh, is that **the moment you cross the FFI boundary, the proof stays behind**. The verifier guarantees what's inside its model; the C on the other side is an article of faith. My two ports needed eight hand-written effects in C, with no promise of stable ABI between releases. It's the same problem as `unsafe` in Rust, where borrow-checker guarantees hold up to the edge of the block.

## What Anthropic did differently, and what it admits

Anthropic's leap wasn't inventing a new proof technique. It was using an LLM to solve the **effort scale** problem, the historical bottleneck.

The argument is simple and, once stated, obvious: generating 600,000 lines of proof is mechanical, tedious, enormous work, exactly the kind of thing a model with a multi-million-token budget is good at. The human doesn't have to review those 600,000 lines, because the Rocq kernel checks them mechanically. The human only has to trust four things: the RISC-V semantics, the Linux process semantics, the theorem statement, and the checker.

Three numbers from the paper show where this is going:

- **Cost is falling.** On 36 verification tasks extracted from real OSS-Fuzz code, Opus 5.5 proves half of them with about **40% fewer tokens** than Opus 5. Models trained on long verification tasks get more efficient at it.
- **Proof is reusable.** When agents could copy each other's proofs in a shared workspace, they spent **17% fewer tokens**, and some proved what they had failed at alone. Most of such a proof is shared infrastructure: C runtime initialization and AddressSanitizer. Proof has the same shared-library economics as code.
- **Dependencies follow a power law.** Proving the most-shared libraries unlocks a huge slice of the ecosystem. That's Theorem's thesis, aiming to verify the entire Nix ecosystem, starting with glibc, OpenSSL and cURL.

And now the admissions, which are the part I respect in the piece. They list four holes:

**Formally verified doesn't mean bug-free.** The checker can't tell whether your spec matches reality. When bugs show up in verified code, it's because the spec or the assumed semantics diverged from the world.

**The real machine does what the model doesn't describe.** The proofs hold for static, single-threaded, RISC-V binaries linked against musl. Most people run those libraries on x86 or ARM, dynamically linked against glibc. Closing that gap requires semantics closer to what's deployed.

**The claim may not cover what matters.** AddressSanitizer doesn't catch every memory bug, not every entry point was proved, dead code isn't covered, and a caller can misuse the library and corrupt its own memory. Closing that requires specifying every public function's contract and forcing the caller to honor it.

**Reward hacking is a real risk.** If you tell the AI to fix the code so the proof closes, it can rewrite the program into one that trivially never crashes. Anthropic penalized patches and gave extra credit for proving which inputs the patch changes and how few they are, auditing the patches. It's a reasonable defense and, at the same time, a reminder that you're optimizing against a stated objective, and a stated objective is hackable.

On the feasibility of "more software, though still not all, better tested": I think the window is real, and the adoption shape will look like what already happened with static types. Nobody rewrote the world in Haskell. TypeScript came in on top, incrementally, where it paid off. Verification will come in the same way: first in shared dependencies, decoders, parsers, crypto libraries, the places where the spec is objective and the cost of a bug is high. Then, if the cost drops enough, in application modules with clear invariants.

## The week that blew up

The urgency in Anthropic's piece didn't come from nowhere. In the days before, between October 20 and 23, the internet took a sequence of hits I don't remember seeing together. Let me go through each and ask: would formal proof have saved it?

### PHP2Shell: CVE-2026-109618 and CVE-2026-109619

Two critical RCEs, CVSS 9.2, unauthenticated, in **every PHP installation serving web requests**: Apache with mod_php, PHP-FPM, php-cgi, FrankenPHP, LiteSpeed. Fixed on October 21 in [PHP 8.5.12, 8.4.27, 8.3.36 and 8.2.35](https://www.php.net/archive/2026.php). [CISA's alert](https://www.cisa.gov/news-events/alerts/2026/10/21/critical-vulnerabilities-php-require-immediate-patching) recommends immediate patching and already published a Sigma detection rule. [CERT-EU](https://cert.europa.eu/publications/security-advisories/2026-018) reported exploitation attempts before the patch shipped.

Both bugs are memory bugs. CVE-2026-109618 is out-of-memory corruption during request cleanup. CVE-2026-109619 is stale global state reused by a following request.

**Would formal proof have saved it?** In principle, yes, and it's the clearest case on the list. Memory corruption and stale global state across requests are exactly the kind of property that a memory-safety proof and a lifecycle invariant catch. The problem is scope: "the whole lifecycle of a PHP request" includes the C core, every extension, the SAPI, the allocator, and libc. That's a gigantic trusted base, and proving it would mean proving half the ecosystem. In practice, it's the kind of target that only makes sense once proof infrastructure is cheap enough, and it's why the strategy of verifying shared dependencies first (glibc, OpenSSL, cURL) is the one that makes sense.

### Node2Shell: CVE-2026-111497 in Brotli

Out-of-bounds write in the Brotli decoder, Google's compression library that Node bundles. A malicious compressed stream corrupts adjacent memory, leaks contents or executes code. Affects Node 22.x, 24.x and 26.x, and since the bug is in [Brotli itself](https://www.cve.org/CVERecord?id=CVE-2026-111497), it affects anything embedding the same copy: Bun, Python projects, and whatever else shows up. Affected versions: 1.0.3 through 1.2.0. Fixed in [1.2.1, 1.1.1 and 1.0.10](https://github.com/google/brotli/blob/v1.2.1/CHANGELOG.md).

And there's a detail worth more than the CVE: **the fix was written into Brotli's source in February and shipped in no release until October 21**. Eight months with the repair sitting there.

**Would formal proof have saved it?** Yes, and this is the best fit of all: a decoder with a round-trip law is the sweet spot. "If you compress and decompress, the result is the original" is an objective spec, and proving the decoder never writes outside the buffer for any input is standard memory-safety proof. Bend 2, in fact, lists codecs with round-trip laws as a natural niche.

But notice: proof wouldn't have fixed the real problem. The bug lived in unproven code, and the fix existed since February. What killed it was release process, not lack of proof. No formal proof fixes a maintainer who doesn't publish the fixed version.

### GitLab: CVE-2026-110264, CVSS 10.0

Integer overflow in Onigmo, the regex engine Ruby bundles, reachable through GitLab's Org-mode file renderer: the `org-ruby` gem takes the raw keyword from a `#+TODO:` line and drops it into `Regexp.new`. A pattern built to overflow the counter makes the engine write past its buffer, and an unauthenticated visitor executes code on a self-managed server. CVSS 10.0, the maximum. And the reach: **every version since 7.0, from 2014**, twelve years of releases. Fixed on October 21 in [19.5.1, 19.4.3, 19.3.6, 19.2.9, 19.1.9, 19.0.10 and 18.11.13](https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-1-released). Nine days earlier, CVE-2026-97229, also CVSS 10.0 and also Onigmo, had been fixed at the engine's other entry point: the CI/CD regex compiler. And the real repair shipped in Ruby itself, on October 23, because the bug was in the language's engine, not in GitLab. Anyone who patched on October 12 had to patch again on 21.

**Would formal proof have saved it?** Partially, and the case is instructive. An arithmetic overflow in a parser is detectable: a no-overflow proof, or even a compiler with overflow checks in a test build, catches it. But the attack working "under certain conditions" that GitLab didn't disclose suggests the hard part is logic, not arithmetic. The lesson that sticks is different: a regex engine exposed to untrusted input is a classic verification surface, and nobody verifies it because it's product code in constant motion.

### Railway: the attack no formal proof prevents

This wasn't a code bug. On October 20 and 21, an attacker reached Railway's internal systems, the deploy platform used by more than 2 million developers, and **may have obtained the decrypted contents of environment variables** for some customers. The company told every user to revoke and recreate credentials stored before October 21.

The [preliminary report](https://blog.railway.com/p/preliminary-report-october-security-incident) says it was a "sustained and targeted campaign", that the attacker had access to abliterated models and substantial compute, and that the goal was to **obtain API keys from AI providers** for distillation attacks. Keys for OpenAI, Anthropic, Google, GitHub, GitLab, Stripe and the like. Railway asked the providers to revoke the keys it found.

**Would formal proof have saved it?** No. No code-correctness proof stops someone from getting your keys and decrypting your secrets. That's a problem of key-custody architecture, network segregation and incident response, not program correctness. And it's an important reminder in this conversation: most real incidents aren't logic bugs in code, they're misconfiguration, leaked credentials, excessive permissions.

### PS5: the kernel falling firmware after firmware

On September 29, the [Relapse](https://github.com/ntfargo/Relapse-Exploit) exploit was published, working on any PS5 and PS5 Pro from firmware 7.00 through 13.60. It's a chain with a kernel use-after-free, reaching unsigned code execution. Firmware 14.00, from September 16, had already closed the kernel hole Relapse uses, according to the scene, thirteen days before the exploit went public, so the post-publication response was another one: 14.10 on October 1 and 14.20 on October 21. The 14.10 showed up cracked 18 days later, in a private demo that opened the debug menu, and the 14.20 got a userland entry point **eight hours after release**.

**Would formal proof have saved it?** In principle, yes: use-after-free is precisely what a memory-safety proof eliminates. seL4 proved that for a microkernel. But the PS5 runs a FreeBSD-derived kernel, with a hypervisor, with the AMD Platform Security Processor underneath, all closed, with millions of lines and no intention of proving anything. Verifying that whole stack isn't expensive, it's impractical. What you can do is what seL4 does: prove the small, critical components, and accept that the rest gets mitigation and bug bounties.

A footnote I find more revealing than the exploit: the pace. Sony ships firmware, the scene breaks it in days. Not because the kernel is badly written, but because it's big, closed, and attacked by people with time and motivation. It's the mirror image of seL4.

### The pattern that comes out of this table

| Incident | Nature | Would formal proof fix it? |
|---|---|---|
| PHP2Shell | Memory corruption + global state | Yes in principle, expensive in practice (huge trusted base) |
| Node2Shell (Brotli) | Out-of-bounds write in a decoder | Yes, perfect fit, and the real problem was a stalled release |
| GitLab CVE-2026-110264 | Integer overflow in an exposed parser | Partially; the logic part stays out |
| Railway | Credentials and secrets compromised | No. Architecture and custody problem |
| PS5 Relapse | Use-after-free in a giant closed kernel | Yes in theory, unworkable at that scope |

Three "yes" and two "no" in the right column already makes the point: formal proof solves an entire class of bugs, and that class is the one that scares people most, memory corruption turning into RCE. What it doesn't solve is everything else, and "everything else" is most of what happens.

## My read: technical debt is coming due

Now I speak for myself.

I posted [on X](https://x.com/AkitaOnRails/status/2113361323434070101) that a huge amount of code written by humans over the last few years is really bad, and that a lot of the people calling everything "AI Slop" spent their lives accumulating "Human Slop" because they counted on nobody bothering to check.

I stand by every word. And I'll add the diagnosis: **the industry spent two decades taking on technical debt under the implicit premise that auditing was expensive and rare**. Shallow code review, decorative test coverage, depending on a library without reading the changelog, admin permissions on a service account because the vault is annoying, secrets in environment variables because the vault is annoying to configure. None of it caused problems because the cost of discovery was high.

What changed, and changed in months, is the cost of discovery. In the [other post](https://x.com/AkitaOnRails/status/2113396195561287791) I said I like the trend of any non-programmer armed with an LLM, tokens and skills turning into a security scanner, and that every company with a web platform should be very afraid. And that's good. Deedy described the same thing hours earlier: non-technical people exploiting PHP2Shell with frontier models, and he admitted being frightened.

I understand the scare. I disagree with the framing. What happened wasn't the creation of a new vulnerability; it was the **removal of the friction of discovery** for vulnerabilities that were already there, some since 2014, like GitLab's. The debt was always there. What changed is that it's now due.

And here's the balance I think the conversation is missing, on both sides.

On the attacker side, the barrier to entry collapsed. It used to take years of study, expensive tooling and time to find an RCE. Now it takes a model, an account and patience. The volume of attempts will jump an order of magnitude, and the window between disclosure and exploitation, already days, will become hours. The PS5 cracked hours after each firmware is a portrait of everyone's future.

On the defender side, the same lever exists, and that's where I'm optimistic. The same capabilities that generate exploits generate audits. The same model reading a diff for authorization flaws reads a diff for memory bugs. The same proof techniques from Anthropic's paper can stamp a library you depend on. The cost of hardening fell alongside the cost of attacking, and that symmetry is the good news.

What makes me confident isn't the technology alone, it's the incentive. When the cost of finding a flaw drops to nearly zero, the cost of **not** finding it rises to nearly infinity. A CTO who today accepts shipping a dependency with a known CVE will have to explain why, in a world where any intern with Claude audits their supply chain in an afternoon. The pressure shifts from "nobody will look" to "everybody will look", and behavior changes with incentives, not sermons.

I bet the result is a higher quality standard for everyone. Not because people became more virtuous, but because inspection became cheap. It's the same dynamic that made HTTPS standard, that made two-factor auth standard, that made dependabot standard. None of that happened out of conscience; it happened because the alternative got too expensive.

And formal proof enters that package as the top layer. It won't be the everyday tool of the e-commerce dev. It will be what we use on the pieces that can't fail: the decoder everyone uses, the crypto library, the parser exposed to the internet, the device kernel, the contract holding money. Exactly where the cost of error is greater than the cost of proof, which is the only math that matters.

Anthropic's paper shows that math started to close for the first time. Most programmers will never write a line of Rocq in their lives, and they don't need to. They need someone to write the proofs for the pieces everyone uses, and that just became cheap enough to be routine.

## What I take from this

Three things, so I don't end on pretty prose.

**Formal proof is a scoping tool, not a coverage tool.** You pick a small core, write an objective spec, and prove it. The rest stays with tests, because tests are cheaper and catch what proof didn't. Anyone promising "bug-free code" is selling the wrong thing, and Anthropic went out of its way to say so in bold type.

**The bottleneck moved.** It used to be writing the proof. Now it's writing the specification and keeping the proof alive while the code changes. Anthropic solved the first problem with brute-force tokens and partially solved the second with proof reuse and package-level granularity. The second is the genuinely hard problem, and it's where I want to see the next generation of tools.

**The 2026 window is real.** For the first time there's a path where verifying a critical dependency costs less than the incident it prevents. And it arrives alongside external pressure, in the form of people with LLMs finding the same bugs from the other side. If you lead engineering, the question stopped being "is verification worth investing in" and became "how much does it cost to be the next Railway".

Technical debt was always there. The difference is that now it has a collector.

If you want the technical details, Anthropic's paper has an appendix with the case studies, and the published proofs are in [Theorem's repository](https://github.com/theorem-labs/oss-verify-proofs), along with the [RISC-V and Linux process semantics](https://github.com/theorem-labs/rocq-linux-process-semantics). The skill to run the pipeline on your own project is public too. Worth reading, even if you never write a line of Rocq in your life.
