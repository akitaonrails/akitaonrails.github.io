---
title: "New AI-Focused Language Just Released: Bend 2"
slug: "new-ai-language-just-released-bend-2"
date: '2026-09-19T12:00:00-03:00'
draft: false
translationKey: nova-linguagem-voltada-pra-ia-bend-2
description: "Bend 2, from Brazilian researcher Victor Taelin, arrived promising C speed, GPU parallelism, and formal proofs that block AI mistakes. I tested it by porting two of my Rust projects right at launch. Plenty of potential; stdlib and ecosystem are still toys."
tags:
- programming-languages
- artificial-intelligence
- rust
---

Two days ago, on September 17, Brazilian researcher Victor Taelin [announced on X](https://x.com/VictorTaelin/status/2100681226143092875) the release of **Bend 2**, hosted at [bend-lang.com](https://bend-lang.com/). The tagline is ambitious: *"a fast language that blocks AI mistakes via proof: C speed · CUDA parallelism · Lean proofs · Python syntax"*.

A language that promises to run near C speed, parallelize itself across CPU and GPU, and still formally verify that the code the AI wrote does what you asked. That's a lot of promises stacked together. I had never touched Bend 1, so this is new territory for me too: on launch day, I pointed my agents at two of my Rust projects and told them to port them to Bend 2. The result of that test is the most interesting part of this article.

Before we start, the disclaimer: this is a review written on the **second day of the language's life**, based on a one-day experiment. I may be wrong about several of my assumptions, and that's fine. The comments are down below; feel free to correct and add to it.

## Who Victor Taelin is

First things first, the author deserves an introduction. [Victor Taelin](https://github.com/VictorTaelin) is a Brazilian functional programming researcher who spent more than a decade obsessed with one specific problem: optimal reduction of the lambda calculus, Lamping's 1990 algorithm, and then Lafont's interaction nets.

[His own autobiography](https://gist.github.com/VictorTaelin/77fd5a2a8a4a07e1da6157ebca3c7cf1) tells the story: he worked at the Ethereum Foundation, created the Formality proof language, retired early on the ETH he stacked from salary, went back to the problem on his own dime, created HVM (the Higher-Order Virtual Machine), and founded the Higher Order Company, which raised a [$4 million seed](https://x.com/VictorTaelin/status/1743751536465903795) to turn the research into a product.

And here's a point that matters a lot to me: **I love seeing a Brazilian doing serious programming language design work**. We barely have real cutting-edge research in this country, let alone in computing fundamentals. For that alone, Taelin already has my respect and my congratulations for what he's built so far.

So let it be on record: every criticism in this article is constructive, from someone rooting for Bend to go further. Nothing against him or the project.

## Where Bend comes from

The first version of Bend showed up in [May 2024](https://news.ycombinator.com/item?id=40390287), with Python-like syntax running on top of HVM2, and the promise of automatic parallelism: write sequential code, the runtime spreads it across every core and even the GPU, no threads, no locks, no mutexes.

The launch went viral. Almost a thousand points on Hacker News, over 20 thousand GitHub stars, a Fireship video. And then reality hit: the [HN thread](https://news.ycombinator.com/item?id=40390287) was merciless. 24-bit numbers, no FFI, a simple sum taking 42 minutes on a user's machine, single-core C++ beating the demo's RTX 4090. Taelin himself admitted back then that the codegen was bad, and admitted now, in the [Bend 2 thread](https://news.ycombinator.com/item?id=49746163), that the 2024 hype didn't convert into usage: *"there is also my own failure into making the language actually be used, rather than just a viral moment"*.

Bend 2 is the answer to that. And pay attention: **it's a different language**. The README is explicit that Bend 1 programs don't load. Interaction-graph evaluation (HVM) is out; native compilation to a single C file is in, with clang for CPU and Metal or CUDA for GPU. Numbers are now real Nat, U32, and F32, and the memory limit jumped from 2 GB to 8 TB, according to [gihyo's Japanese announcement](https://gihyo.jp/article/2026/09/bend-2). Interaction nets stay in the architecture, but in his words, *"inets live in it architecturally, but they don't exist at runtime"*.

## What Bend 2 promises

The new pitch now revolves around AI. The project page sells a *"post-AGI"* vision: humans will stop writing and reading code, so we need an ambiguity-free way to tell the AIs what we want. Bend's solution is splitting the program into two files:

- `LAWS.bend`: the system's invariants, written by the human.
- `PROOF.bend`: the proofs of those laws, written by the AI.

Bend's type checker is a proof checker, in the lineage of Lean and Rocq, so `bend PROOF.bend` becomes a commit gate: if the proof doesn't close, the code doesn't ship. The site's demo is a little game with the law *"winning is impossible"* and a direct invitation: *"Skeptical? Try breaking the game"*. The positioning is explicit: **LAWS.bend is an AGENTS.md with mathematical backing**.

And what does it look like? The syntax feels like Python with dependent types. A complete program with effects:

```python
import Base

# Performs effects on the CPU.
def main() -> IO(Unit):
  do IO<Unit>:
    name : String <- IO.try(String, IO.get_env("USER"))
    IO.print("Hello, " ++ name)
```

Parallelism is divide-and-conquer: you split the work in two and the runtime spreads it over whatever cores it finds. And the `!` operator dispatches the function to the GPU:

```python
# Computes 2^d in parallel: a tree of d levels, one leaf per unit.
def pow2(+d: Nat) -> U32:
  match d:
    case 0n:
      1
    case 1n+p:
      a b = pow2(p) pow2(p)
      (a + b : U32)

# Runs pow2 on the GPU, via `!`.
def main() -> IO(Unit):
  result = pow2!(20n)
  IO.print(U32.show(result))
```

Notice the differences from mainstream languages: there's no `if` (every branch is a `match` on `True`/`False`), natural numbers pattern-match on the successor pattern (`1n+p`), and the `+d` marks the parameter as **affine**, which is what lets the language live without a garbage collector.

And proofs are ordinary defs. The law declares what holds; the proof is induction with explicit rewrites:

```python
# CLAIM: for every nat x, x + 0 equals x.
law add_zero:
  for x: Nat
  {Nat.add(x, 0n) == x : Nat}

# PROOF: induction on `x`, one rewrite (`%`) per step.
def add_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+xp:
      %add_zero(xp) : {1n+Nat.add(xp, 0n) == 1n+_ : Nat}
      {==}
```

No tactics, no inference, everything annotated by hand. It's verbose on purpose: that's the price of the 0.1s checker.

The other promises, all with benchmarks on the page:

- **Runs fast**: Game of Life on an M4 Max in 7.8s on one core, against C's 6.78s. On the GPU, 0.06s, or 124x.
- **Checks fast**: 3,200 generic instantiations checked in 0.38s, against Lean's 19.2s and Rocq's 6.04s. The idea is that the agent can verify after every edit.
- **Parallelizes by itself**: the `!` operator sends the function to the GPU, no threads, no locks, no hand-written kernels.
- **No garbage collector**: affine types, each closure can be called at most once, so memory resolves statically.

Two honest details I liked seeing published: the site itself warns *"Bend is still evolving. Expect bugs"*, and Taelin stated that [the compiler is 99% AI-written](https://gihyo.jp/article/2026/09/bend-2), with only the checking kernel audited by humans. Consistent with his thesis, at least.

And there's already a business plan: the [Bender](https://bend-lang.com/bender), a paid, proprietary *"proving agent"*, a harness on top of Anthropic and OpenAI models today, with a dedicated model and its own symbolic prover on the roadmap.

## Not everyone swallowed the benchmarks

The technical reception had strong caveats, and they matter. Nezk's gist, ["Why the benchmarks of Bend's 2 typechecker are misleading (and possible problems with its type system)"](https://gist.github.com/Nezk/dda0511c492cf9bd673885f0341dca0e), points out that Bend skips elaboration, unification, and implicit arguments, which is exactly where Lean and Rocq spend their time. Comparing times like that would be comparing an apple to a rocket.

Heavier: Liam Powell's post, ["Bend 2 and the Vibe-Coding Trap"](https://blog.liampwll.com/posts/bend_vibe_coding/), notes that the expression *"formal verification"* appears nowhere on Bend's site or code, redoes the game demo in SPARK/Ada proving the same two properties automatically with GNATprove (*"all checks proved (12 checks)"*), without the 442 lines of manual proof, and concludes that Bend is *"decades behind the state of the art"*.

These are criticisms from people who know the subject, and they deserve an answer. That said, Bend 2's main HN thread sits at [over 600 points](https://news.ycombinator.com/item?id=49746163), so attention the project has.

## What I tested

A tagline doesn't compile a program, so I went and tested. I have a [`bend-tests`](https://github.com/akitaonrails/bend-tests) repository where I pointed my agents at porting real projects of mine, written in Rust, to Bend 2 (v2.0.16, pinned via mise; to get a sense of the maturity, the language had nine releases in ten hours on GitHub the day after launch). The documentation for the whole experiment lives in `docs/` in there, and that's where the next sections come from.

### The three candidates

I picked three of my projects with different profiles. Fair warning: none of the three is a worthy Bend example, and I know it. I just grabbed small, simple projects I had lying around, somewhat at random, to see where the language breaks when you rub ordinary day-to-day code against it.

| Project | Fit | Why |
|---|---|---|
| ghpending | bad | 90% HTTP, JSON, and formatting; a single small function worth proving |
| clock-tui | bad | terminal IO from start to finish; the arithmetic is U32, unprovable in practice without a mathlib |
| ai-jail | worst | namespaces, mounts, seccomp, exec: almost everything is a syscall |

**ghpending** is my CLI that lists open issues and PRs across my repositories via GraphQL. The port covers the main command, the filters, the sorting, and the config.toml, with output verified **byte-for-byte identical** to the Rust binary in the cases tested against the real GitHub API (on my loaded config, the only difference is the fork view the port left out).

**tclock** is my fork of clock-tui, a terminal clock with timer and stopwatch. The port covers clock, timer, and stopwatch, without the widget system (which alone is 2,075 lines of the Rust), verified by driving the binary through a pty.

**ai-jail**, my sandbox for AI agents (bubblewrap, Landlock, seccomp), never even became code: the paper evaluation killed it. A port would be a C program with a Bend `main`, which defeats the purpose. And it had the most interesting part to prove: the policy logic, like *"path resolution never escapes the root"*. But there's no way to embed that in the Rust binary, so it stays for a next round.

### The numbers

I measured Rust and Bend side by side on both ports:

| | Rust | Bend |
|---|---|---|
| ghpending, lines of code | 1,962 (no tests) | 1,068 Bend + 93 laws/proofs + 109 C + 25 JS |
| ghpending, dependencies | 278 crates in the lockfile | dynamic libcurl, nothing else |
| ghpending, binary | 6.8 MB | 1.4 MB |
| ghpending, clean build | 57s | 62s (0.1s of checking; the rest is clang -O3 on the generated C) |
| ghpending, run with 43 repos | 3.9s wall / 16ms CPU | 2.1s wall / 28ms CPU |
| tclock, binary | 6.7 MB | 115 KB |
| tclock, idle 5s | 333ms CPU, 10 MB | 9ms CPU, 6.6 MB |

Read that table carefully, because it lies. The runs are network-bound. The 43-repo gap is Rust doing more work (fork lookups, sequential viewer query). Bend's tclock redraws whole frames, 26 KB/s against ratatui's 2 KB/s of diffs. And the lower line count is partly because the port does less. **No number here shows Bend faster than Rust on the same work.**

### The proofs in practice

Here's the part Rust can't imitate, so it's worth the detail. The design that worked was **proving an isolated guard, leaving the algorithm outside the proof**. ghpending's `--limit` allocator ended up in two stages: the first is the original algorithm in U32, unproven; the second is a Nat guard that takes the first stage's proposal and cuts any excess. The laws say the budget is conserved and that no repo gets more items than it has.

This is the real guard, from the port's `alloc.bend`:

```python
# the lesser of b and w
def take(b: Nat, w: Nat) -> Nat:
  match b w:
    case 0n w0:
      0n
    case 1n+bp 0n:
      0n
    case 1n+bp 1n+wp:
      1n+take(bp, wp)

# what is left of b once w is taken from it
def rest(b: Nat, w: Nat) -> Nat:
  match b w:
    case 0n w0:
      0n
    case 1n+bp 0n:
      1n+bp
    case 1n+bp 1n+wp:
      rest(bp, wp)
```

> The law holds even if the unproven stage proposes garbage. The guard doesn't trust arithmetic it can't see. That's the pattern that makes proofs work in real code.

The mutation test is the honest measure of the thing. I injected an off-by-one into the guard that leaks budget: the three sample outputs came out identical, so a test suite of that size would have passed it. The proof gate rejected it, with the exact term that stopped matching. That's Bend working as promised, down to the detail.

Now the price: 93 lines of laws and proofs to guarantee two simple facts about a guard of some 30 lines, starting from zero, because Base ships no Nat lemmas (the only arithmetic lemmas are `U32.add_comm` and `Word.add_comm`, which don't help in a Nat proof; we had to prove addition associativity by hand, and Taelin acknowledged in the thread: *"We need a mathlib!"*).

And what stayed outside the proof: the algorithm's exactness (it would need division lemmas, days of work), everything U32 (underneath it's a 32-bit vector; proving arithmetic on it without a lemma library is impractical), and literally everything else in the program: JSON, sorting, rendering, IO. The provable surface of a program like ghpending is a few percent of the code.

The checker, on the other hand, is the best part of the tool: 0.1s per round, errors pointing at one exact line. It took some 30 check rounds on ghpending. For an agent iterating in a loop, it's exactly the feedback format it needs.

### The price of escaping to C

Everything Base lacks becomes a *foreign effect*: a Bend def whose body is a C function (for the native binary) and a JS twin (for the dev runner). The two ports needed **eight** hand-written effects:

- `Http.post`: because there's no TLS, HTTP, or DNS (the official HTTP demo hard-codes an IP).
- `Clock.unix` and `Clock.local`: because `IO.now` is milliseconds since boot, with no wall clock and no timezone.
- `Tty.width`, `Tty.raw`, `Tty.key`, `Tty.size`: because there's no stdin, no raw mode, no terminal query. None of that exists.
- `Clock.millis`: convenience.

And the official guide is clear about the trade: **there's no ABI promise**. The names are runtime internals and any release can rename them, so *"rebuild your effects with every update"*. In a language with nine releases in ten hours, good luck with that. Details that complete the picture: there's no flag to link an extra library (ghpending uses a `$CC` wrapper that injects `-lcurl`), custom handle types are WONTFIX, and including a C header mid-file worked by luck, because the runtime defines short names like `lock` and `u32`.

Here's where the conceptual point lands: **the moment you cross the FFI boundary, the proof stays behind**. The checker guarantees what's inside its model; the C code on the other side is an act of faith. Rust has exactly the same problem with `unsafe`, where the borrow checker's guarantees hold up to the edge of the block and inside it the proof is on you. If you want strong end-to-end guarantees, the C boundary has to be minimal or nonexistent, and in Bend today it's enormous for any real program.

### Where Bend fits

Crossing the three projects with what the language offers, the winning shape is **a small pure core, with a sharp spec that tests cover poorly, inside a thin shell of effects**:

- allocators, schedulers, rate limiters, quota logic
- deterministic game or simulation rules, especially with rollback netcode (the only domain where Base already has what's needed: UDP, windowing, audio)
- consensus state machines, ledgers, matching engines
- parsers and codecs with a round-trip law
- CRDT merge functions (commutative, associative, idempotent)
- access policy evaluators (like ai-jail's)

And the design center the authors declare: **the AI writes the code and the proofs, the human writes only the LAWS.bend, and the checker arbitrates**. The shortest honest description I found: a *proof-carrying language for AI-written kernels*. Compared with Lean or Coq, which prove well and deliver applications poorly, Bend is far more executable.

One thing that surprised me in my own numbers: at first I'd assume the natural niche was academic math research. It's the opposite. For mathematics it loses badly to Lean 4, Coq, and Isabelle: no tactics, almost no inference, nothing at mathlib's scale, no reals, and a foundation (`Type : Type`, no positivity check) that would make a mathematician's hair stand on end. What it does is **software verification**, closer to Dafny, F*, or Liquid Haskell than to a proof assistant.

Two limitations weigh even in that niche: Bend emits a whole program instead of a library, so the proven core can't be linked into a Rust application today; and the cost of proving without a lemma library is high.

### What would change the verdict

Recorded in `use-cases.md`, the list of what would make me reevaluate:

- library output with a C ABI, so a proven core can live inside a Rust or C program
- U64/I64 and F64
- a lemma library for Nat, lists, and ordering
- stdin, subprocesses, TLS, and JSON in Base, or a package hub that has them
- incremental or faster native builds (62s for 1,000 lines today)
- an effects ABI that survives a release

## The unvarnished reality

Now my reading, and you already know I don't sugarcoat.

**It's a newborn language.** It launched two days ago. Outside the language's own repo, a GitHub search today finds only a few dozen 48-hour spikes, almost all with zero stars, nothing that looks like a real project. The repo's 21 thousand stars are almost all inherited from Bend 1; the repo was renamed. The site's demos are all toys: a little game, Game of Life, pow2. They're demonstrations of possibility, with no real usage yet.

**The stdlib needs to grow by an order of magnitude.** A language's strength lives in its standard library and ecosystem. The only historical exception to that rule was JavaScript, and that's a can of worms that doesn't fit in this article.

**The killer app is missing.** Every language that made it had one. My tests point to the niche (proven pure cores, written by AI), but someone needs to turn that into an app the world wants to use. And here's a concrete suggestion, free of charge: Taelin could pick popular open source software he thinks would be better in Bend and rewrite it. Taelin is the exact opposite of the stubborn maintainer who turns his nose up at AI: he designed the whole language around AI. So put that to work: grab a ripgrep, a jq, a sqlite, rewrite it with AI in Bend, and publish the side-by-side comparison. Performance, lines of code, and above all what the proofs guarantee that the original doesn't. A real-world before/after like that is worth more than a thousand little game demos.

**Don't expect webapps, mobile, or anything day-to-day anytime soon.** Maybe that's not even the goal, and that's fine too. But the *"C speed"* promise cuts the other way: if the differentiator is performance, it's easier to go straight to C, especially now, with an LLM writing the code for you.

And here's my concrete situation. I use Rust a ton. I **hate** the syntax, and I find the ergonomics miserable. But since the LLM writes the code and I don't have to deal with it by hand, I tolerate it, and in exchange I get performance, good-enough guarantees, and a gigantic ecosystem of crates and frameworks. Ecosystem. That's what decides it.

> I don't pick a language by the elegance of the paper. I pick it by the size of the ecosystem I don't have to write by hand.

## The proof-and-GPU focus, and the doubt that remains

One thing nagged me the whole time: Taelin clearly concentrates everything on two pillars, proofs and GPU, and I wasn't sure what that meant for the language's scope. I went and read what he himself said in the [pre-launch thread](https://x.com/VictorTaelin/status/2100374221671051472) and on HN, and the story is more interesting than I assumed.

The GPU pillar is research inheritance. Ten years of interaction nets and optimal reduction, from HVM to here. But there's a nuance that surprised me: Bend 2 consciously **betrays** his academic idealism. In his own words: *"Bend2 is designed to be practical, not idealistic"*, closer to C than to Haskell, because he couldn't make interaction nets beat the lower-order variants on common hardware. The GPU stayed as the practical application of the obsession, without becoming a fetish.

The proof pillar is older than the LLM era: it goes back to the Ethereum Foundation days, immutable contracts holding millions with a bug, which produced Formality. The LLM era just gave the old obsession a market outfit: *"the same capabilities that proved Navier-Stokes will now be writing real proofs that your own apps are correct"*.

And here comes my hypothesis that didn't survive the research. I was ready to write that the minimal stdlib was maybe **on purpose**, that the idea was never general-purpose programming, and that my criticism of the library desert was aiming at the wrong target. Wrong me. His words are general ambition, period: *"the potential to become the most sensible choice for any vibe-coded project"*, *"Bend is made for the general public"*, and the team *"working hard to [...] make this language competitive with the mature alternatives in the market"*. The only deliberate leanness is the checker's, no inference, verbose on purpose. The small Base is day two of life, so much so that he himself asks for a mathlib.

That makes my stdlib criticism bite even **harder**: if the declared goal is to be the choice for any vibe-coded project, the comparison with mature ecosystems is the game he chose to play.

And there's the business angle, which he admits with rare frankness: *"we ship without a product"*. The language is the free substrate; the sellable thing is the [Bender](https://bend-lang.com/bender) and the proving infrastructure behind it. Worth keeping an eye on that space.

The doubt that remains, and this one I register with no answer: the generalist ambition is his north star, but the reality I measured pushes Bend toward the niche of AI-written verified cores. Which of the two wins, only time will tell.

## The final word

If I could give Taelin one piece of advice, it would be this: the hard part, the research, he's already done. Now comes the less glamorous part, the one that decides whether a language lives or dies: **marketing and ecosystem building**. Adoption, teaching material, killer app, stdlib, mathlib. Going way beyond toys and demos.

The example that comes to mind is Zig. Years on the road and still fighting for adoption, even with immediate practical use: `zig cc` alone is a trivial drop-in for compiling C, without using any of the language. Real apps use it; Mitchell Hashimoto's [Ghostty](https://ghostty.org/) is the famous case. But Andrew Kelley, the author, is a notoriously difficult figure, from the crowd that turns its nose up at AI, and he clearly doesn't understand ecosystem building, and that holds Zig back. Technical perfectionism doesn't mix with marketing and adoption.

Bend 2 has real potential. Instant checker, proofs catching bugs that tests don't catch, parallelism without ceremony. But potential alone means nothing if adoption doesn't come. I'm rooting for it to come, and rooting double because a Brazilian is leading.

And one final provocation, this time for you who read this far. Thin stdlib, zero frameworks, zero third-party libraries, no killer app: all of that stops being a problem when you look from another angle and becomes an opportunity map. Everything missing in Bend is something someone will have to write, and whoever gets there first etches their name into the project's history. If you always wanted to contribute to impactful open source but never found room in the mature projects, where everything already exists, here's an empty lot waiting.

Those are my two cents. Don't take it too seriously.
