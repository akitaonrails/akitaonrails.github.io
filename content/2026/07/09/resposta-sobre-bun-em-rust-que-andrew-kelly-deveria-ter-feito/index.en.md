---
title: "The Bun in Rust Response Andrew Kelly Should Have Written"
slug: "the-bun-in-rust-response-andrew-kelly-should-have-written"
date: '2026-07-09T17:00:00-03:00'
draft: false
translationKey: bun-rust-response-andrew-kelly-should-have-written
tags:
  - zig
  - rust
  - bun
  - languages
  - ai
  - vibecoding
---

I read Jarred Sumner's official post, ["Rewriting Bun in Rust"](https://bun.com/blog/bun-in-rust). And I'll start by making my bias clear: I am completely in favor of Bun's decision to rewrite in Rust. Not because Rust won some tribal war against Zig. That's not it. I like Zig a lot. But, for Bun's context, the decision looks understandable, serious, and well executed.

What I liked most about Jarred's post was the level of detail. He did not sell the idiotic fantasy of writing a prompt like "rewrite Bun in Rust" and waiting for a miracle. Quite the opposite. What he described was procedure: `PORTING.md`, lifetime analysis, `LIFETIMES.tsv`, a trial run with three files, dynamic workflows, adversarial reviewers, process correction when the agents started doing stupid things with `git stash`, then compiler errors becoming a work queue, then smoke tests, then the whole suite, then multi-platform CI. No irresponsible vibe coding. Engineering using AI as a multiplier.

That's why I was disappointed by Andrew Kelley's response, ["My Thoughts on the Bun Rust Rewrite"](https://andrewkelley.me/post/my-thoughts-bun-rust-rewrite.html). Andrew is Zig's creator. I wanted to read the best possible technical argument defending Zig. I wanted to see him explain where Bun confused a language problem with an architecture problem. I wanted to see which Zig APIs could have helped, which invariants should have been hardened, where `comptime`, allocators, arenas, `errdefer`, `DebugAllocator`, and Zig's new I/O design could change the analysis.

Instead, a large part of the text becomes an attempt at character assassination. Comments about personality, management, VC, startup culture, backstage gossip. There may even be real resentment there. I don't care. It does not help technically.

So I decided to do the exercise I expected to have read: put Claude Fable 5 and GPT 5.6 Sol as technical arbiters and ask them for the answer Andrew should have written. Not the polite answer. Not the fan-club answer. The technical answer.

Before handing over the microphone, one off-topic note. If you, like me, stared at those beautiful GitHub animations in Bun's post and thought "I want that in my projects", I went there and built it. [`github-visualize`](https://github.com/akitaonrails/github-visualize) is a self-hosted dashboard that tracks your repositories and replays commit evolution, the hourly heatmap, and the CI race until everything turns green. It's all open on GitHub.

[![Animated commit timeline in github-visualize](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/09/bun-zig-rust/github-visualize-commit-timeline.png)](https://github.com/akitaonrails/github-visualize)

But now let's separate support from proof. One thing is to say "I would have done something similar". Another is to say "it was technically impossible to continue in Zig". To answer that, we need to look at causes: which bugs were really language bugs, which were architecture problems, which were ecosystem costs, and which could have been reduced with different discipline inside Zig itself.

That's where the analysis starts.

First, minimum vocabulary. **Use-after-free** is using memory after freeing it. **Double-free** is freeing the same memory twice. **Leak** is forgetting to free. **Ownership** is who is responsible for destroying a resource. **Lifetime** is how long a reference remains valid. **FFI** is the boundary where Rust or Zig call C/C++ and lose part of the language guarantees. **GC root** is a way to tell the garbage collector: "do not collect this object yet". **Pinning** is holding a buffer in place so it cannot be moved, detached, or invalidated while someone still has a pointer to it. **Reentrancy** is when a call enters the runtime again before the previous call has finished.

## What Rust actually buys

The strongest thesis in Bun's post is simple: a large percentage of the listed bugs were use-after-free, double-free, or forgotten resources in error paths. In safe Rust, a good portion of that becomes compiler error or automatic cleanup through `Drop`, as long as the resource is modeled as an owning value. Rust does not prove the general absence of leaks: `Rc` cycles, `mem::forget`, `Box::leak`, and `abort` still exist. But it makes accidental leaking in error paths much harder.

That is correct. And it is a strong argument.

Rust's strong point here is not magic. It is that Rust forces certain ownership and lifetime relationships to appear in the type, instead of being scattered around as convention. When a value has an owner, when it is moved, when it leaves scope, when a destructor runs, that stops being just an agreement between programmers. The compiler participates.

In Bun's current code, you can see the pattern in miniature. A MySQL byte wrapper stores a pinned JavaScriptCore value, and `Drop` undoes the pin when the object dies:

```rust
impl Drop for Bytes {
    fn drop(&mut self) {
        if !self.pinned.is_empty() {
            // `pinned` is rooted by the caller's MarkedArgumentBuffer for the
            // lifetime of this Value (see struct doc); the FFI itself is `safe fn`.
            JSC__JSValue__unpinArrayBuffer(self.pinned);
        }
        // self.slice dropped automatically
    }
}
```

Source: [`src/sql_jsc/mysql/MySQLValue.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/sql_jsc/mysql/MySQLValue.rs#L172-L180). The important detail is not the FFI call itself. It is that cleanup follows the value's owner.

This is the round Rust wins cleanly. In a small project, discipline is enough. In half a million lines, with reentrant callbacks, threadpool, libuv, sockets, TLS, JavaScriptCore, parser, bundler, package manager, and Node API, discipline becomes recurring cost.

Rust probably reduced the invalid state space the team needed to keep in their heads. Real win.

But a real win does not mean total victory.

## Zig was not defenseless

The weakest argument you can make against Zig is pretending it is C with new syntax. It is not. Zig has explicit mechanisms to address exactly part of these problems.

The most obvious one is [`errdefer`](https://ziglang.org/documentation/master/#errdefer), the idiomatic mechanism for cleanup on error paths:

```zig
fn readThing(alloc: std.mem.Allocator, fail: bool) ![]u8 {
    const buf = try alloc.alloc(u8, 16);
    errdefer alloc.free(buf);

    if (fail) return error.Boom;
    return buf;
}

test "leak em caminho de erro" {
    const alloc = std.testing.allocator;
    try std.testing.expectError(error.Boom, readThing(alloc, true));
}
```

[`std.testing.allocator` reports leaks](https://ziglang.org/documentation/master/#Report-Memory-Leaks) in tests. [`DebugAllocator`](https://github.com/ziglang/zig/blob/master/lib/std/heap/debug_allocator.zig) helps find double-free, leaks, and many invalid memory uses, including making bugs noisier by not immediately reusing addresses. This is not the same thing as a static proof of the absence of use-after-free. It is not a borrow checker. It does not cover allocation done inside C++, JavaScriptCore, BoringSSL, or any other external allocator. It only catches what goes through it and only on the paths exercised by tests.

The allocator's own comment is precise about what it provides:

```zig
//! * Captures stack traces on allocation, free, and optionally resize.
//! * Double free detection, which prints all three traces (first alloc, first
//!   free, second free).
//! * Leak detection, with stack traces.
//! * Never reuses memory addresses, making it easier for Zig to detect branch
//!   on undefined values in case of dangling pointers.
```

Source: [`debug_allocator.zig`](https://github.com/ziglang/zig/blob/master/lib/std/heap/debug_allocator.zig#L3-L12). It is a good testing and debugging tool. It is not a theorem.

Even so, it is wrong to say Zig had no tools. It did.

The difference is feedback timing. In Rust, a lot appears at compile time. In Zig, a lot appears in tests, fuzzing, instrumented allocators, ASAN, review, and architectural style. In critical code, that matters. Early feedback is better.

But it also matters to say the whole sentence: if the problem was lack of clear invariants in the Zig code, the answer could have been a rewrite in Rust. It could also have been an aggressive restructuring of the Zig.

We do not know which would have been cheaper. We only know which one Bun chose.

## `Drop` is not just sugar, but it is not a miracle either

Bun's post is right to contrast `defer` with `Drop`.

In Zig, you write:

```zig
var resource = try Resource.init(allocator);
defer resource.deinit();
```

This is explicit. It is in your face. There is no hidden control flow. That is Zig's philosophy: if something happens, you should be able to point to where it happens.

In Rust, if the type implements `Drop`, cleanup follows the owner:

```rust
impl Drop for Resource {
    fn drop(&mut self) {
        self.deinit();
    }
}
```

This is not just syntactic sugar. [Rust's destruction rules](https://doc.rust-lang.org/reference/destructors.html) connect `Drop` to ownership, move semantics, field destruction order, and panic unwind. Ordinary safe code cannot use a value after it has been moved, nor double-drop the object as if it still owned it. It is a language guarantee.

But the guarantee ends where semantics the compiler does not understand begin.

If `drop` calls an FFI function to unprotect a JavaScriptCore value, Rust guarantees the destructor will run on normal scope and drop paths, not on `abort`, `mem::forget`, intentional leaks, or `Rc` cycles. It does not prove that the JSC pointer is still valid. It does not prove the GC has no special rule. It does not prove an asynchronous C callback will not call back after you destroyed the wrapper.

The comment in the same Bun wrapper shows the size of the contract that still remains outside the compiler:

```rust
/// JS could `transfer()`/detach an earlier ArrayBuffer, or drop the last
/// JS reference to it and force GC, while we still hold a borrowed slice
/// into it. Pinning the backing `ArrayBuffer` makes it non-detachable for
/// the duration, and the caller's stack-scoped `MarkedArgumentBuffer`
/// roots the wrapper so GC can't sweep the cell. `Drop` unpins.
pub struct Bytes {
    pub slice: ZigStringSlice,
```

Source: [`MySQLValue.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/sql_jsc/mysql/MySQLValue.rs#L142-L154). Notice the size of the contract. It did not disappear because this is Rust. It became documented and encapsulated.

That is the real boundary: Rust improves the Rust side of the contract. It does not perform magic inside the JavaScriptCore heap.

## The FFI boundary is still hell

Bun is not a simple CLI. Bun is a JavaScript runtime. It talks to JavaScriptCore, uWebSockets, usockets, BoringSSL, SQLite, compression libraries, system APIs, asynchronous handles, buffers that JavaScript can detach in the middle of a coercion, reentrant callbacks, and a conservative GC.

That is where the debate gets interesting.

Inside an `unsafe` block, Rust requires discipline. The [Rustonomicon on FFI](https://doc.rust-lang.org/nomicon/ffi.html) itself treats foreign calls and raw pointers as programmer obligations. If the binding is lying, if the real ownership does not match the type, if the foreign callback outlives the Rust object, the compiler does not save you.

Bun's binding documents the preconditions in the declaration itself:

```rust
unsafe extern "C" {
    /// By-value `JSValue`; C++ side null-checks and reads its own heap state.
    /// No caller-side preconditions → `safe fn`.
    safe fn JSC__JSValue__unpinArrayBuffer(v: JSValue);
    /// 0 = detached/null, 1 = FastTypedArray (GC-movable — caller should dupe;
    /// no unpin needed), 2 = pinned ArrayBuffer (caller must unpin).
}
```

Source: [`MySQLValue.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/sql_jsc/mysql/MySQLValue.rs#L859-L868). The language lets you declare a foreign call safe. The obligation to prove that safety remains ours.

But there is an important difference: Rust lets you encapsulate that `unsafe` behind safe APIs. You can create handle types, `NonNull`, `PhantomData`, `Pin`, lifetimes marking the relationship between wrapper and runtime, wrappers that do not implement `Send` or `Sync`, RAII for GC roots, and a smaller surface for audit. The goal is not to eliminate danger. It is to shrink the place where danger lives.

The most didactic example in Bun's post is the `uv_close` bug. The first version compiled, but handed a `Box` to libuv to close asynchronously and let the `Box` fall at the end of the scope. Use-after-free followed by double-free. The fixed version in the current code makes the transfer explicit:

```rust
spawn::WindowsStdioResult::Buffer(pipe) => {
    // `uv_close` is async — libuv keeps the raw handle pointer until the
    // next loop tick. Leak the Box so it outlives this scope; dropping it
    // here would be a use-after-free + double-free when the callback fires.
    Box::leak(pipe).close(Subprocess::on_pipe_close)
}
```

Source: [`js_bun_spawn_bindings.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/runtime/api/bun/js_bun_spawn_bindings.rs#L1359-L1366). It compiled in Rust and was still wrong at the C/async boundary. The review process caught it.

Here `leak` does not mean "leak forever". It means removing the `Box` from Rust's lexical control and transferring ownership to libuv's asynchronous protocol, whose callback later reconstructs and frees the allocation.

Zig also lets you write good wrappers. The difference is that it does not have the `safe`/`unsafe` boundary as part of the language. In Zig, everything is explicit and reviewable. In Rust, a larger part of the contract can become type.

For a large team, that matters. It matters even more when part of the code is being generated by agents.

## Arenas: yes, Bun already used them

Here the pro-Zig argument needs to be honest. Arenas are idiomatic and excellent for certain problems: parser, AST, request lifecycle, data that dies together.

But Bun's post does not ignore arenas. It explicitly says the existing approach was already a mix of lifetimes by arena, reference counting, and "pay really close attention". It even cites parser state and AST nodes as good cases for an arena.

The excerpt from the post is this:

```text
Our current approach is a mix of:

- arena lifetimes, where the scope of when it's accessible is clear
  (parser state doesn't escape the calling function and so AST nodes
  are a good choice there)
- reference-counting
- pay really close attention
```

Source: [Bun's official post](https://bun.com/blog/bun-in-rust). The good counter-argument is not "use arena". They already did. The good counter-argument is asking whether the remaining boundaries could have been hardened in Zig.

So the correct response is not "you forgot arenas". They did not forget.

The correct response is: arena solves the case where lifetime is clear. It does not, by itself, solve a socket handle that closes asynchronously, a callback that runs later, an SSL session that needs a specific `free`, a GC root, a pointer that may be invalidated by reentrancy, or an object that crosses several API layers with implicit ownership.

Arena is a good tool. It is not a religion.

If Bun had hardened the boundaries more in Zig, maybe part of the rewrite's benefit could have come from that: more restricted APIs, fewer raw pointers crossing subsystems, handles with explicit ownership, allocators instrumented by default in tests, fuzzing aimed at reentrancy, wrappers that force `deinit`, less "pay attention".

But that would also be a rewrite. Just inside Zig.

## The borrow checker helps, but not where the internet thinks

A lot of people talk about the borrow checker as if it were a universal bug detector. It is not. The borrow checker is the part of the Rust compiler that prevents certain invalid borrows: two mutable owners at the same time, a live reference after the owner dies, use after move. That is a lot. It is not everything.

It does not understand the JavaScriptCore heap. It does not understand every GC rule. It does not automatically understand that a C callback can trigger JS, that JS can detach an `ArrayBuffer`, that it can reenter the runtime, that it can invalidate a pointer captured earlier. These invariants need to be modeled.

But when they are modeled, Rust charges you.

A small example in Bun: a `uSockets` wrapper that turns a C pointer into a Rust borrow tied to `&mut self`:

```rust
impl PacketBuffer {
    pub fn get_peer(&mut self, index: c_int) -> &mut sockaddr_storage {
        // SAFETY: uSockets guarantees a non-null, properly-aligned peer pointer for
        // indices < packet count. The returned storage lives inside the C-owned packet
        // buffer, which is exclusively loaned to the data callback for its duration; no
        // other Rust or C path holds a reference to it. The reborrow of `&mut self`
        // ties the returned lifetime to this handle, so the borrow checker prevents
        // obtaining a second overlapping `&mut` via `get_peer`/`get_payload`.
        unsafe { &mut *us_udp_packet_buffer_peer(self, index) }
    }
}
```

Source: [`src/uws_sys/udp.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/uws_sys/udp.rs#L200-L209). The `unsafe` still exists. But after the wrapper creates the reference, the borrow checker can prevent certain abuses on the Rust side.

And Bun is not only JavaScript heap. It is parser, bundler, module resolver, package manager, file watcher, HTTP protocol, buffers, caches, tables, queues, process state, glue code. In these parts, local ownership matters a lot. `Vec`, `String`, slices, maps, wrappers, enums, finite states: all of that becomes easier to refactor with the compiler slapping your hand.

The honest argument is not "the borrow checker solves Bun". It is: the borrow checker reduces many classes of error on Bun's Rust side, and that frees human attention for the part that remains hard.

That is strong enough. No need to exaggerate.

## `comptime`: here Zig has a real advantage

The best technical counterexample in Bun's own post is `Output.pretty`.

In Zig, the format string could be a `comptime` parameter. Bun's own post puts the difference like this:

```rust
// Zig:
pub inline fn pretty(comptime fmt: string, args: anytype) void;
Output.pretty("<r>{f}<r>", .{hyperlink});

// Primeira API Rust:
pub fn pretty(payload: impl PrettyFmtInput);
Output::pretty(format_args!("<r>{}<r>", hyperlink));
```

This allowed processing color and formatting markers in the literal known at compile time, before mixing runtime arguments. When porting to Rust, the first version became a function. Result: the tag parser touched bytes that came from the arguments. Issue [#30693](https://github.com/oven-sh/bun/issues/30693) shows the regression in port/canary involving an OSC 8 hyperlink escape and `<r>`, not a failure released in stable.

The bug was exactly the contamination between template and runtime argument:

```text
TerminalHyperlink::Display emits an OSC 8 hyperlink:

\x1b]8;;URL\x1b\ai\x1b]8;;\x1b\

The closing string terminator ST is the final two bytes `\x1b\`.

This is then wrapped via `Output::pretty(format_args!("<r>{}<r>", hyperlink))`.
The rendered string tail is `...\x1b\<r>`.
```

Source: [issue #30693](https://github.com/oven-sh/bun/issues/30693).

Then they fixed it using a macro.

The current code makes the difference explicit:

```rust
/// Write to stdout with `<tag>` color expansion.
/// Function form: performs the `<tag>` → ANSI rewrite at runtime on the rendered
/// payload (using stdout's colour state). Prefer the `pretty!` macro for literal
/// templates so the rewrite happens at compile time.
#[inline(always)]
pub fn pretty(payload: impl PrettyFmtInput) {
    let buf = payload.into_pretty_buf(enable_ansi_colors_stdout());
    write_bytes(Destination::Stdout, &buf);
}
```

And right below:

```rust
/// Compile-time `<tag>` → ANSI escape rewriter.
///
/// This must be a proc-macro because it consumes a string literal and emits
/// a new string literal usable as a `format_args!` template.
///
/// `pretty_fmt!("<red>{s}<r>", true)`  → `"\x1b[31m{}\x1b[0m"`
/// `pretty_fmt!("<red>{s}<r>", false)` → `"{}"`
pub use bun_core_macros::pretty_fmt;
```

Source: [`src/bun_core/output.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/bun_core/output.rs#L1765-L1805).

This demonstrates a legitimate strength of Zig: `comptime` is the language itself running at compile time. You do not switch to a parallel system. In Rust, macros are powerful and mature, but they are another mechanism. For some kinds of API, Zig is simply more direct.

But let's not turn a porting bug into universal proof against Rust. The problem there was not "Rust is fragile". It was the wrong translation of a `comptime` API into a runtime function. Bun's own post recognizes that and fixes it with a macro.

The correct reading is simpler: Zig had a structural guarantee there. The first Rust version lost that guarantee. That cost a regression in port/canary.

Point for Zig.

## Binary size and performance: careful with cheap causality

Bun's post shows good numbers: smaller binary, some faster benchmarks, better startup in certain scenarios.

The numbers from the post:

```text
Bun v1.4.0 (canary) — Windows — 76 MB
Bun v1.3.14          — Windows — 94 MB
Bun v1.4.0 (canary) — Linux   — 70 MB
Bun v1.3.14          — Linux   — 88 MB

Bun.serve  — 169.6k → 177.7k — +4.8%
node:http  — 103.8k → 108.5k — +4.5%
fastify    —  91.5k →  95.9k — +4.8%
```

Source: [Bun's official post](https://bun.com/blog/bun-in-rust).

I believe the numbers. I do not believe in simple attribution.

A rewrite changes many things at the same time. It changes code layout, removes debt, changes toolchain, touches LTO, changes how generics/comptime are instantiated, changes linker, changes dead code, changes ICU, changes internal organization. When all of that happens together, you cannot look at the graph and say: "it was Rust".

You also cannot say: "it was only the rewrite".

The post itself talks about a combination: Rust, ICU changes, Identical Code Folding, LTO, codegen, accumulated cleanup. LTO is optimization at the final link stage, when the compiler sees more of the program before generating the binary. Identical Code Folding is the linker merging identical functions into one. [Andrew is right](https://andrewkelley.me/post/my-thoughts-bun-rust-rewrite.html) to point out that Zig also supports LTO and that some of these gains could have been pursued before. But that does not prove the result would be the same. It only proves causality is mixed.

Bun's `Cargo.toml` shows there is explicit build engineering in this story:

```toml
# Cargo's defaults (lto=false, codegen-units=16) leave us at ~105 crates × 16
# CGUs ≈ 1680 separately-optimized units with NO cross-crate inlining beyond
# `#[inline]`-annotated leaf fns. `lto = "fat"` + `codegen-units = 1` collapses
# the whole Rust crate graph into one LLVM module, matching Zig's shape.
[profile.release]
lto = "fat"
codegen-units = 1
debug = "line-tables-only"
strip = "none"
panic = "abort"
```

Source: [`Cargo.toml`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/Cargo.toml#L117-L135).

And there is LTO configuration crossing Rust and C++:

```ts
/**
 * Cross-language LTO: rustc emits LLVM bitcode (`-Clinker-plugin-lto`) into
 * `libbun_rust.a` so the final lld `-flto=thin` link sees through Rust↔C++
 * call edges. When false but `lto` is true, both halves still LTO
 * independently (C++ via `-flto=thin`, Rust via `[profile.release] lto =
 * "fat"`); only the cross-language inlining is lost.
 */
crossLangLto: boolean;
```

Source: [`scripts/build/config.ts`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/scripts/build/config.ts#L118-L129). It is not "Rust won". It is language, toolchain, linker, configuration, and code working together.

Same thing for stack usage and parser depth. The post attributes improvement to Rust emitting better [`llvm.lifetime.start/end`](https://llvm.org/docs/LangRef.html#llvm-lifetime-start-intrinsic) and allowing stack slot reuse. Codegen detail? Yes. But a codegen detail delivered by today's toolchain counts. Zig itself still has an [open issue about stack allocations that do not disappear at the end of scope](https://github.com/ziglang/zig/issues/23475). For the user, it matters little whether the advantage comes from the pure language, the compiler, or backend maturity. What matters is that it works today.

The mechanism described by Bun is this:

```text
Rust's LLVM IR codegen emits LLVM's llvm.lifetime.start and
llvm.lifetime.end intrinsics for stack variables when they are no longer
in use, which lets LLVM reuse stack space slots.
```

And the Zig ticket says, bluntly, that this case is still not solved:

```text
Block stack allocations do not disappear at end of block scope #23475
```

There is also the architectural solution: iterative parser with an explicit stack on the heap. Works in Zig and Rust. But it is more work.

Honest reading: the numbers favor Bun's Rust version in that experiment. They do not prove general language superiority.

## Miri, crates, and the real world

There are Rust advantages that have no direct equivalent in Zig today.

Crates is the obvious one. The Rust ecosystem is large, mature, and practical. For a project the size of Bun, a good off-the-shelf library is real engineering value. Zig is still maturing on this point.

[`Miri`](https://github.com/rust-lang/miri) is also a real advantage. It detects classes of undefined behavior in executed Rust code: out-of-bounds, use-after-free, uninitialized data, alignment problems, data races in certain cases. The project itself documents the limits: it is not a formal proof, it evaluates the executions you provide, and it has restricted support for FFI and platform APIs. It does not replace testing. But to validate isolated `unsafe` abstractions, it is a tool Zig does not have in the same way.

Bun does not merely cite Miri in the abstract. It is in the toolchain:

```toml
[toolchain]
channel = "nightly-2026-05-06"
components = ["rust-src", "rustfmt", "clippy", "miri", "llvm-tools"]
```

Source: [`rust-toolchain.toml`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/rust-toolchain.toml#L1-L24).

And there is an internal test explaining exactly the use:

```rust
// Run under Miri (`bun run rust:miri -p bun_ptr`): every path here walks raw
// pointers through `Box::into_raw` / `heap::take`, so Tree Borrows is what
// proves the ref/deref/destructor handoff does not alias or use-after-free.
```

Source: [`src/ptr/ref_count.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/ptr/ref_count.rs#L1313-L1315). It does not prove the whole program. It exercises a dangerous abstraction under a model made to detect undefined behavior on those executed paths.

There is also hiring, tooling, documentation, IDE, review culture, CI, examples, people in the market. This is not a political detail. It is engineering. A language exists inside an ecosystem.

If Bun were a smaller project, with a smaller team, less pressure, and less Node-compatible surface area, maybe I would weigh this differently. But Bun became a runtime used by millions of monthly downloads. The margin for "let's maintain perfect discipline" shrinks.

## Async: Zig may have a better answer, but it is not Bun's present yet

Zig removed the old async/await and is [redesigning I/O around `std.Io`](https://kristoff.it/blog/zig-new-async-io/), passed by the caller in a way similar to `Allocator`. The idea is good: avoid classic function coloring, make the function less coupled to blocking, threaded, or event-driven execution, and treat I/O as an explicit capability.

The proposed format is like this:

```zig
const std = @import("std");
const Io = std.Io;

fn saveData(io: Io, data: []const u8) !void {
    const file = try Io.Dir.cwd().createFile(io, "save.txt", .{});
    defer file.close(io);

    try file.writeAll(io, data);

    const out: Io.File = .stdout();
    try out.writeAll(io, "save complete");
}
```

Source: [Kristoff on Zig's new async I/O](https://kristoff.it/blog/zig-new-async-io/). `io` is a capability passed explicitly, like `Allocator`.

I like this direction a lot.

But it is still in transition. The [tracking issue](https://github.com/ziglang/zig/issues/23446) remains open: there is a prototype, roadmap, discussion, parts landing gradually. It is not a stable foundation Bun could bet on today without cost.

So the argument here cannot be "Zig already solved it". The correct formulation is: Zig is moving toward an async/I/O design that may be cleaner in some aspects than the traditional colored model. But Bun needed to make a decision with what exists now, not with what promises to exist later.

That is always cruel to young languages. But it is real.

## The rewrite process matters more than the language

The best part of Jarred's post is not Rust. It is method.

The mental loop of the post is literally this:

```js
// Pseudocode, not real code:
let task;
while ((task = todoList.pop())) {
  const result = task();
  const feedback = await Promise.all([review(result), review(result)]);
  await apply(feedback, result);
}
```

Then compiler errors became a queue:

```text
~16,000 compiler errors left

error: deref *mut EventLoop before field access
error[E0034]: multiple applicable items in scope
error: event_loop/EventLoopTimer.rs: port Timespec::ns from bun.zig
```

And the per-crate cycle was explicit:

```text
- For each crate, run cargo check, group the output by file and save the errors to a file
- Fix all the compiler errors within that crate
- 2 adversarial reviewers for the crate's changes
- 1 fixer applies the fixes
```

Source: [Bun's official post](https://bun.com/blog/bun-in-rust).

He did not tell Claude to rewrite an entire runtime and go to sleep. He built loops. Separated implementer from reviewer. Used different context for adversarial review. Did a trial run. Fixed the workflow when agents started tripping over each other. Banned dangerous commands. Split worktrees. Turned compiler errors into a queue. Ran the same TypeScript suite because the suite did not depend on the runtime language. Used multi-platform CI as judge.

That is the part everyone should study.

The model did not replace engineering. The model executed work inside an engineering process. When the process was bad, the result was bad. When the process improved, the result improved.

It is the detail the tribal discussion ignores. The story is not "Claude rewrote Bun". The story is "an engineer turned a giant migration into several verifiable loops and used Claude to accelerate each loop".

Much more interesting.

## So did Zig fail?

No.

Zig did not fail because Bun chose Rust. Rust also did not become the universal answer because Bun chose Rust.

What the public evidence shows is more boring: that code, at that moment, was too expensive to evolve with the level of confidence the team wanted. Rust bought predictability. Bought compiler feedback. Bought ecosystem. Bought an explicit safe/unsafe boundary. Bought tooling. Bought an environment where AI agents can bang against compiler errors and move forward mechanically.

That is enough to justify the decision.

But it is not enough to prove Zig was technically unviable for Bun. Many cited problems also look like boundary problems: implicit ownership, overly permissive APIs, allocation without a visible contract, resources crossing layers without a type carrying the owner, tests that maybe did not capture difficult invariants, and the human cost of reviewing all of that.

Those things could have been attacked in Zig. Maybe an aggressive Zig restructuring would have solved a lot. Maybe not. Maybe it would cost more than the port. Maybe it would cost less, but deliver less confidence. We do not have the counterfactual.

And that is exactly why the conclusion needs to be calibrated.

I support Jarred's decision as a product and engineering decision. His post is one of the most useful reports I have ever seen about a large AI-assisted rewrite. But liking the decision does not force me to pretend it was the only possible technical conclusion.

And there is one important disclaimer. [Anthropic acquired Bun in December 2025](https://bun.com/blog/bun-in-rust), and Jarred opens the post by saying that he and the Bun team now work there. Anthropic sells Claude Code. Jarred had every institutional incentive to use as much Claude as possible and turn this rewrite into a public demonstration of his new employer's product. That does not prove bad faith, nor does it invalidate a technical result. But it adds bias to the decision and to the way the case is presented. Ignoring that conflict of incentives would be as naive as ignoring Andrew's resentment over Bun leaving Zig.

The best reading is less dramatic: Bun chose to pay a large cost now to reduce recurring maintenance costs later. Rust was a defensible choice, maybe a great one for that team at that moment. Zig remained an excellent language, but would have required another kind of reengineering: more explicit invariants, less informal ownership, more tools enabled by default, harder boundaries.

Andrew could have written that. He could have defended Zig on technical ground. He could have said: "Rust bought some real guarantees, but a large part of the problem was architecture and process; here is how Zig could have attacked the same causes." That would have been a useful post.

We do not need to declare a winner. Language does not replace architecture. It only changes which errors become cheap to detect and which still depend on human discipline.

Bun chose to trade part of that discipline for compiler. I think it is a good bet.

I do not think it buries Zig.
