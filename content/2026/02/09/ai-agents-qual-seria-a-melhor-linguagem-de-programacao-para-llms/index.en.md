---
title: "AI Agents: What Would Be the Best Programming Language for LLMs?"
slug: "ai-agents-best-programming-language-for-llms"
date: 2026-02-09T20:20:30+00:00
draft: false
tags:
- claude
- gpt
- vibecode
translationKey: best-language-for-llms
description: "A thought experiment on what a programming language designed for LLM coding agents, rather than human programmers, would look like."
---

I decided to run a silly little exercise: ask Claude and GPT Codex what they consider to be the characteristics of a programming language that would benefit editing by LLMs, without worrying about being friendly to human programmers.

Language Design takes into account creating reasonably optimized, safe code, etc., but balances that with being easy for a human to read, understand, and edit later. Usually these two things tend to conflict: the more "friendly" for a human, the less efficient it is for a compiler/machine. Examples of that include dynamic languages like Python, Ruby, PHP, and Javascript.

In my head, I imagine the "best" (always in quotes) for a machine are exactly the ones we humans consider to have the worst ergonomics: functional, strongly typed, highly bureaucratic or "verbose" languages, for example, Rust, OCaml, Lean, etc.

Coincidentally (again, ask it yourself), Claude and GPT reached more or less this same conclusion. That doesn't mean it's "correct". It's what the model can deduce from its probabilities, with the information it has. It's a massive exercise in "guesswork". But I think the arguments make a lot of sense.

I asked it to show me what a snippet of code in this "AI-friendly" language would look like, which resembles the AST of a Lisp, but with more features, like annotations, metadata, typing, etc. I think the closest thing to an AST — with proper tooling to give feedback — would be, more or less, what an LLM would prefer for editing.

See what you think:

# Update: Pact-Lang

In the section below, you'll find Claude/GPT's reasoning and arguments about the ideal language. I liked the idea and decided to ask Claude to generate a prototype compiler that actually works, using what it itself described as the requirements.

It chose to do it in Rust, a language called **PACT** (it picked the name itself), and this initial version compiles `.pct` files and generates `.rs` files. I haven't even tested it yet, just let it do the project and threw it on GitHub.

* [Pact-Lang Repository](https://github.com/akitaonrails/pact-lang)

On X, I commented that I wasn't impressed when Anthropic hyped that Claude managed to make a C compiler (using GCC as a comparison). Making a compiler isn't hard — it's one of the first subjects in a decent computer science degree; everyone who studied there has already done one.

And, to reinforce this point, Claude managed to make a compiler for a language that doesn't exist, which — according to it — is ideal for LLMs, but not for humans.

I don't know why nobody has discussed this angle yet. Leaving it as a curiosity.

I don't think — at least in the short term — this is something that will actually happen, but it seems inevitable to me: why spend so much trying to make the LLM adapt to a language made for humans, if the goal is to prevent humans from directly touching the code anymore?

The most obvious answer is going back to the beginning: getting humans to write very detailed software specifications. Until now this was super unproductive; we've tried it several times over the years. But it was impractical to write specifications that another human would then need to convert into code: it was smarter to create a language that was easier to write and that, more or less, resembled a good specification (and so we invented strong types, annotations, unit tests, etc.).

But if "generating code" becomes a trivial task with the LLM, it's worth dedicating more time to the specification, the famous "blueprint". I don't know how practical this would be, but it's a line of reasoning that, today, with LLMs, makes sense to at least explore.

So let's get to the reasoning Claude gave:

# Designing a Programming Language for AI Agents

A thought experiment on what a programming language would look like if it were conceived for LLM-based coding agents rather than human programmers.

---

## Summary

- [The Problem](#the-problem)
- [What Human-Oriented Design Gets Wrong for LLMs](#what-human-oriented-design-gets-wrong-for-llms)
  - [Safeguards That Become Redundant](#safeguards-that-become-redundant)
  - [What Would Actually Help an LLM](#what-would-actually-help-an-llm)
  - [The Counterintuitive Insight](#the-counterintuitive-insight)
  - [The Real Question](#the-real-question)
- [A Prototype: What It Would Look Like](#a-prototype-what-it-would-look-like)
  - [Layer 0: The Human Specification](#layer-0-the-human-specification)
  - [Layer 1: The AI-Native Format](#layer-1-the-ai-native-format)
  - [Layer 2: The Human Projection](#layer-2-the-human-projection)
  - [Layer 3: How an LLM Would Edit This](#layer-3-how-an-llm-would-edit-this)
  - [Design Decisions Rationale](#design-decisions-rationale)
  - [Main Takeaway](#main-takeaway)
- [Existing Languages: How Close Are We?](#existing-languages-how-close-are-we)
  - [Tier 1: Closest to the Vision](#tier-1-closest-to-the-vision)
  - [Tier 2: Get Several Things Right](#tier-2-get-several-things-right)
  - [Tier 3: Get One or Two Things Right](#tier-3-get-one-or-two-things-right)
  - [The Uncomfortable Pattern](#the-uncomfortable-pattern)

---

## The Problem

We design programming languages to be fast, safe, and mostly **human-friendly** — modularity, scope isolation, easy syntax, etc. But when the main "user" of a language is an LLM-based coding agent, the constraints change drastically. Humans have limited working memory, read linearly, and interpret visually. LLMs don't share those constraints — but they have others that current languages ignore.

---

## What Human-Oriented Design Gets Wrong for LLMs

### Safeguards That Become Redundant

- **Syntactic sugar** — An LLM doesn't need `for x in list` to be prettier than `loop(list, fn(x) -> ...)`. Both are equally easy to parse. The idea of "readable syntax" is a human concern. Lisp S-expressions or even raw AST notation would be enough.

- **Naming conventions** — camelCase vs snake_case, short vs descriptive names — they exist to help humans scan and remember. An LLM could work with UUIDs as identifiers if the *semantic graph* is available.

- **Indentation/formatting** — Entirely visual. Explicit block delimiters (or just an AST) are unambiguous. Python's significant whitespace is actually *harder* for LLMs because whitespace is hostile to tokenization.

- **Boilerplate reduction** — DRY exists because humans hate repetition and lose track of duplicated logic. An LLM doesn't get tired and doesn't get lost. Explicit repetition with guaranteed consistency checks can be *better* than implicit magic (think Rails conventions that hide behavior).

- **Progressive disclosure of complexity** — Languages hide things (default parameters, implicit conversions, operator overloading) so as not to overwhelm humans. That gets in the way of LLMs — hidden behavior means the model has to simulate what the runtime *actually does* versus what the code *appears to do*.

### What Would Actually Help an LLM

1. **Rich, inline semantic metadata** — Not comments (natural language is ambiguous), but *machine-readable* annotations of intent. "This function is pure." "This block must execute in < 10ms." "This invariant must hold: x > 0 at exit." Current type systems are a weak version of this. The ideal is **contracts, effects, and provenance** as first-class citizens, not bolted on afterward.

2. **Bidirectional traceability** — Every line of code should know *why it exists*. Link to the requirement, the test, the commit rationale. When editing a function, the language should say "this exists because of requirement R-1234, it's tested by test T-56, and it's depended on by modules A, B, C". Current languages don't support this — it lives in external tools (Jira, git blame, grep).

3. **Formal, queryable dependency graphs as a language primitive** — Not `imports` to chase. The ability to ask the runtime: "what is the total transitive impact of changing this type?" and get a precise answer. LSP is a makeshift approximation.

4. **Deterministic, total effect tracking** — Every function should declare *everything* it can do: I/O, mutation, allocation, panic, non-termination. Haskell's IO monad is going in the right direction, but it's too coarse. The ideal: "this function reads from the network, writes to this specific database table, and can throw these 3 types of error". That lets an LLM reason about changes *without running the code*.

5. **Native diff/patch semantics** — Current languages represent *state* (the current source). LLMs work in *deltas* (edits). A language designed for LLMs could represent programs as a *history of transformations* with semantic meaning, not plain text files. Think: a program is a chain of refactorings, not a bunch of characters.

6. **Constraint-based specifications alongside implementation** — Instead of just writing code and hoping tests catch bugs, every function would carry a formal specification. LLMs are much better at checking "does this implementation satisfy this formal constraint?" than "does this code do what that vague comment says?".

7. **Elimination of ambiguous overloading** — Every operation should have exactly one meaning in context. The fact that `+` means integer addition, float addition, string concatenation, and list concatenation depending on the types is a human convenience that creates inference load for LLMs.

### The Counterintuitive Insight

The language an LLM would *actually* like looks less like Python and more like a **typed, total, effect-tracked AST format with embedded formal specs and full provenance metadata** — basically a rich IR with the semantic density of something like Lean 4 or Idris, but without any concern for on-screen appearance.

The irony: **this already exists in parts.** LLVM IR, WebAssembly, Typed Racket, Dafny, F*. Nobody uses it directly because it's hostile to humans. An LLM-native language would essentially be a *very* rich IR that no human would want to write, paired with a human-facing projection (like a "view layer") for when people need to read.

### The Real Question

The deeper question isn't "what language should LLMs use" — it's **should LLMs use textual languages at all?** Text is a serialization format for human cognition. The ideal programming interface for LLMs may be direct manipulation of a semantic graph with formal verification at every step, where "source code" as plain text simply doesn't exist.

---

## A Prototype: What It Would Look Like

The same concept — a simple HTTP user service — shown in four layers: the human intent specification, the AI-native format, a human projection, and the semantic editing interface.

### Layer 0: The Human Specification

If humans no longer write code — neither the native format (Layer 1) nor the readable projection (Layer 2) — what *exactly* do they write? The answer: **a declarative specification of intent**. It isn't code. It isn't pseudocode. It's a structured declaration of what the system must do, which constraints it must respect, and which guarantees it must offer. The human describes the *what* and the *why*. The AI decides the *how*.

This isn't free-form natural language (too ambiguous) nor a programming language (too detailed). It's something in between: a **specification DSL** where the vocabulary is restricted, the structure is formal, but the cognition required is *product design*, not *software engineering*.

For the same user service:

```yaml
spec: SPEC-2024-0042
title: "Serviço de usuários"
owner: time-plataforma
status: rascunho

domain:
  User:
    campos:
      - nome: obrigatório, texto, 1–200 caracteres
      - email: obrigatório, formato email, único no sistema
      - id: gerado automaticamente, imutável

endpoints:
  buscar-usuário:
    descrição: "Retorna um usuário pelo ID"
    entrada: id do usuário (da URL)
    saídas:
      - sucesso: o usuário encontrado (200)
      - não encontrado: quando o ID não existe (404)
      - ID inválido: quando o formato do ID é incorreto (400)
    restrições:
      - tempo máximo de resposta: 50ms
      - somente leitura no banco

  criar-usuário:
    descrição: "Cria um novo usuário"
    entrada: nome e email (do corpo da requisição, JSON)
    saídas:
      - sucesso: o usuário criado (201)
      - email duplicado: quando o email já existe (409)
      - validação falhou: lista de erros de validação (422)
    restrições:
      - tempo máximo de resposta: 200ms
      - idempotente por email (mesma requisição não duplica)
      - escrita no banco

qualidade:
  - toda função deve ser total (sem crashes, sem loops infinitos)
  - todo campo deve ter validação explícita
  - todo erro deve ser tipado e enumerado (sem exceções genéricas)

rastreabilidade:
  - testes requeridos: cobertura de todos os caminhos de saída
  - dependências conhecidas: api-router, admin-panel
```

**What this specification does *not* contain:**

- No implementation decisions (which database, which framework, which validation pattern)
- No programming syntax (no types, no functions, no imports)
- No serialization details (the JSON format is a constraint, not an instruction on how to serialize)
- No concern for file structure, modules, or code organization

**What the LLM does with this:**

1. Interprets the specification and generates Layer 1 (the native AST format with all the metadata, effects, invariants, and provenance)
2. Automatically derives tests from the declared outputs
3. Computes the dependency graph from the known dependencies
4. Fills in provenance by linking each function back to the section of the spec that originated it
5. Generates the schema migration if the type is new

**The fundamental inversion:** in traditional programming, humans write the implementation and *hope* it matches the intent. Here, humans write the intent and the system *guarantees* that the implementation matches it — because the specification is formal enough to be verifiable, but high-level enough to be thought about in product terms, not in code.

**The specification DSL isn't YAML.** The example above uses YAML as a familiar format, but the real representation could be anything structured — a form, a visual graph, a conversational interface with the agent. What matters is that the vocabulary is restricted to the domain (not the implementation), the constraints are explicit (not implicit), and the output is *machine-verifiable* against the generated implementation.

This changes the human's role from **code author** to **constraint author**. The programmer becomes a *specifier* — someone who thinks in terms of domain, invariants, and guarantees, not syntax, patterns, and boilerplate.

### Layer 1: The AI-Native Format

This is what the LLM actually works with:

```scheme
(module user-service
  :provenance {req: "SPEC-2024-0042", author: "agent:claude-v4", created: "2026-02-09T14:00:00Z"}
  :version 7
  :parent-version 6
  :delta (added-fn get-user-by-id "support single-user lookup endpoint")

  (type User
    :invariants [(> (strlen name) 0) (matches email #/.+@.+\..+/)]
    (field id   UUID   :immutable :generated)
    (field name String :min-len 1 :max-len 200)
    (field email String :format :email :unique-within user-store))

  (effect-set db-read    [:reads  user-store])
  (effect-set db-write   [:writes user-store :reads user-store])
  (effect-set http-respond [:sends http-response])

  (fn get-user-by-id
    :provenance {req: "SPEC-2024-0042#section-3", test: ["T-101" "T-102" "T-103"]}
    :effects    [db-read http-respond]
    :total      true
    :latency-budget 50ms
    :called-by  [api-router/handle-request admin-panel/user-detail]

    (param id UUID
      :source http-path-param
      :validated-at boundary)

    (returns (union
      (ok   User   :http 200 :serialize :json)
      (err  :not-found {:id id} :http 404)
      (err  :invalid-id {:id id} :http 400)))

    ;; the logic itself — note how small it is compared to the metadata
    (let [validated-id (validate-uuid id)]
      (match validated-id
        (err _)    (err :invalid-id {:id id})
        (ok  uuid) (match (query user-store {:id uuid})
                     (none)   (err :not-found {:id uuid})
                     (some u) (ok u)))))

  (fn create-user
    :provenance {req: "SPEC-2024-0041", test: ["T-090" "T-091"]}
    :effects    [db-write http-respond]
    :total      true
    :idempotency-key (hash (. input email))
    :latency-budget 200ms

    (param input {:name String :email String}
      :source http-body
      :content-type :json
      :validated-at boundary)

    (returns (union
      (ok   User   :http 201 :serialize :json)
      (err  :duplicate-email {:email (. input email)} :http 409)
      (err  :validation-failed (list ValidationError) :http 422)))

    (let [errors (validate-against User input)]
      (if (non-empty? errors)
        (err :validation-failed errors)
        (match (insert! user-store (build User input))
          (err :unique-violation) (err :duplicate-email {:email (. input email)})
          (ok user)               (ok user))))))
```

### Layer 2: The Human Projection

This is auto-generated. It isn't source code — it's a read-only rendering, like a database's storage format and a query's output. No human writes this; it's projected from Layer 1 whenever someone needs to review.

```python
# --- Auto-projetado a partir de user-service v7 ---
# Spec: SPEC-2024-0042 | Tests: T-101, T-102, T-103

@effects(reads="user_store")
@budget(latency="50ms")
@total
def get_user_by_id(id: UUID) -> User | NotFound | InvalidId:
    match validate_uuid(id):
        case Err(_):
            return InvalidId(id=id)          # → 400
        case Ok(uuid):
            match user_store.get(id=uuid):
                case None:
                    return NotFound(id=uuid) # → 404
                case user:
                    return user              # → 200
```

### Layer 3: How an LLM Would Edit This

An LLM wouldn't send a text diff. It would send a **semantic operation**:

```scheme
(edit user-service
  :operation add-field
  :target-type User
  :field (field role (enum :admin :member :guest) :default :member)
  :reason "SPEC-2024-0055: role-based access control"

  :cascading-impacts
    ;; the language itself computes these impacts and asks for confirmation:
    ;; - create-user needs to accept optional 'role' parameter
    ;; - get-user-by-id now returns 'role'
    ;; - 3 tests need to be updated: T-090, T-091, T-101
    ;; - user-store schema migration required
    ;; - admin-panel/user-detail consumes User — check compatibility

  :confirm true)
```

The system responds with:

```scheme
(edit-result
  :version 8
  :parent 7
  :changes-applied 4
  :changes-pending-review 2
  :migration-generated "M-0008-add-role-to-user"
  :tests-invalidated ["T-090" "T-091" "T-101"]
  :tests-auto-updated ["T-101"]    ;; trivial: return format changed
  :tests-need-manual  ["T-090" "T-091"]  ;; behavioral: creation changed
  :downstream-verified ["admin-panel/user-detail: compatible"]
  :downstream-warning  ["api-router: new field not yet exposed in list endpoint"])
```

### Design Decisions Rationale

| Design Decision | Equivalent in Human Languages | Why It Helps LLMs |
|---|---|---|
| Declarative spec of intent (Layer 0) | Requirements doc + user stories | Formal, verifiable input, no natural-language ambiguity |
| S-expression AST | `if/else` blocks, braces | No parsing ambiguity, trivial programmatic manipulation |
| `:provenance` on every node | Git blame + Jira links | Never has to ask "why does this exist?" — it's inline |
| `:effects` declarations | Implicit side effects | Knows exactly what a function touches without reading the body |
| `:total` annotation | Hope + tests | "No crashes, no infinite loops" verified by the compiler |
| `:called-by` graph | Grep for uses | Impact analysis is instant, not a search |
| `:latency-budget` | SLA in some document | Performance constraints live in the code, not in tribal knowledge |
| Semantic edit vs textual diff | `sed` / find-replace | Declare intent, the system computes consequences |
| Cascading impact analysis | "Did you remember to update X?" | The language tells you what broke — no guessing |
| Explicit return types | Exceptions thrown from anywhere | Every possible outcome is enumerated — no surprises |

### Main Takeaway

The ratio of **metadata to logic** is something like 3:1. In human languages, it's the reverse. That's the fundamental shift — an AI-native language is *mostly specification, provenance, and constraints* with a thin layer of computation. Logic is the easy part. Knowing **why**, **what else is affected**, and **which guarantees must hold** is where LLMs spend their reasoning budget.

This isn't a language for writing code. It's a language for **maintaining systems**. And with Layer 0, the loop closes: humans specify intent, AI generates and maintains the implementation, and formal verification guarantees that both agree. Code becomes an intermediate artifact — important for the machine, invisible for the human.

---

## Existing Languages: How Close Are We?

An honest ranking of existing popular languages, based on how much each one already delivers natively of the ideal.

### Tier 1: Closest to the Vision

#### Lean 4

The closest thing that exists today. Dependent types mean that specifications *are* the code — a function's type can literally say "returns a sorted list whose length equals that of the input list". Proof obligations force total, verified logic. The macro system operates directly on the AST, which gets close to the "semantic editing" concept. The metaprogramming framework (Lean's `Elab` monad) lets you query and manipulate the proof environment programmatically.

**Missing pieces:** no effect tracking, no provenance, no built-in dependency graph queries.

#### F* (F-Star)

A Microsoft Research language. It has *exactly* the effect system described above — you declare `ST` for state, `IO` for I/O, `Pure` for pure computation, and the compiler enforces it. Refined types let you encode invariants like `:min-len 1` directly into the type. It can extract verified code to OCaml, F#, or C. It's the closest thing to "lots of specification with little logic".

Almost nobody uses it outside research, which says a lot about the human-friendliness trade-off.

#### Idris 2

Similar to Lean, but with first-class **quantitative type theory** — the type system tracks *how many times* a value is used. That's a primitive form of resource/effect tracking. Elaborator reflection lets programs inspect and modify the type-checking process itself, which speaks to the idea of semantic editing.

### Tier 2: Get Several Things Right

#### Rust

Not for the reasons people usually cite. The borrow checker is essentially a *compiler-verified effect system* for memory — it tracks aliasing, mutation, and lifetime at the type level. The trait system with `Send`, `Sync`, `Unpin` is effect tracking by another name. The `Result<T, E>` convention with exhaustive `match` gives explicit returns. `cargo` provides a real dependency graph you can query.

**What's missing:** formal specifications, provenance, totality checking, and the syntax is complex enough that LLMs burn tokens on lifetime gymnastics.

#### Haskell

The classic of several of these ideas. Purity by default means effects are *always* explicit (`IO` monad). The type system is powerful enough to encode many invariants. `hlint` and typed holes give structured feedback.

**What's missing:** the effects story is coarse (just `IO` vs pure — no granularity about *what kind* of I/O), no provenance, no built-in specification language, and the lazy evaluation model makes reasoning about performance genuinely hard even for LLMs.

#### Dafny

A Microsoft language focused on verification. It has `requires`, `ensures`, `invariant` as first-class syntax — exactly the `:invariants` annotations described above. The verifier checks these at compile time. Loop termination is verified (`decreases` = totality). It's basically "specification-heavy programming".

**Weakness:** small ecosystem, no effect system, and it's oriented toward verifying algorithms more than building systems.

### Tier 3: Get One or Two Things Right

#### Elixir/Erlang (BEAM)

A surprising pick, but: OTP's supervision trees are essentially a **declarative dependency and failure graph**. The process model gives natural effect isolation — each process is a boundary. Pattern matching with tagged tuples (`{:ok, result}` / `{:error, reason}`) is explicit union return. `@spec` and `@doc` are inline metadata. Hot code reloading is a primitive "semantic patch".

**What's missing:** formal verification, compile-time type enforcement (Dialyzer is optional and incomplete), no provenance.

#### Scala 3

The work on the effect system (Caprese/capture checking) is going in the right direction. Union types, match types, and opaque types give expressive return specifications. Inline metaprogramming via `scala.quoted` operates on typed ASTs. But it carries a huge JVM complexity bundle.

#### Ada/SPARK

The SPARK subset is formally verifiable with contracts (`Pre`, `Post`, `Contract_Cases`). Used in aerospace and defense, where "proving it can't break" is a real requirement. Very close to the concept of `:total` + `:invariants`. But the language is verbose, the ecosystem is small, and there's no effect tracking beyond what contracts can express.

### The Uncomfortable Pattern

| What LLMs Want | Who Has It | Why It Isn't Mainstream |
|---|---|---|
| Formal specs as code | Lean, F*, Dafny | Steep learning curve for humans |
| Effect tracking | F*, Haskell, Rust (partial) | Increases annotation burden |
| Totality checking | Lean, Idris, Agda | Rejects many "useful" programs |
| Rich AST manipulation | Lean, Lisp/Racket, Elixir macros | Humans find macros confusing |
| Exhaustive returns | Rust, Haskell, OCaml | Humans find `match` tedious vs exceptions |

Every feature exists somewhere. The reason no language combines them all is that **each one adds cognitive load for humans**. The history of mainstream language design is about *removing* the things LLMs find most useful, because humans experience them as friction.

That's the central tension: **the ideal language for AI is the one humans keep rejecting.**

---

## Addendum: Additional Thoughts

### Extra primitives that seem especially useful for LLMs

- **Canonical, lossless AST serialization** — A single, stable, deterministic, diffable, and hashable representation. That removes formatter drift and makes semantic caching trivial.
- **Proof-carrying artifacts** — The compiler emits machine-verifiable certificates tied to specs and effects, allowing incremental trust without rerunning the world.
- **Capability-scoped effects** — Effects should require explicit capability grants at the module boundary (not just declared in signatures). That gives the language a built-in permissions model.
- **Spec/test duality** — Specs should be executable and tests should be derivable from specs. The boundary between the two should be thin and programmatic.

### Modularization for LLMs

LLMs handle monoliths better than humans, but **modules still matter** as *semantic boundaries*:

- **Effect scope**: capabilities are granted at module boundaries.
- **Ownership and invariants**: modules define which data invariants they own and enforce.
- **Dependency graphs**: the language can cache and re-verify smaller units.
- **Partial recompilation**: the impact of a change is smaller when units are isolated.

In an AI-native language, modularization should be **constraint- and capability-driven**, not file-driven. You can keep everything in a single file, but the *units* should still be explicit.

### Runtime observability as a language primitive

A language for LLMs should treat **structured tracing** as a first-class thing:

- Every effect produces machine-readable trace events with causal links.
- Edits can be validated against *behavioral deltas*, not just type diffs.
- Provenance can extend into the runtime, letting you attach "why" to "what happened".

### Alternative framing

Instead of a "language", think: **native graph IR + semantic edit protocol + human projection DSL**. Text becomes a view, not the source. The primary interface is a semantic graph with checked constraints, safe capabilities, and proof-carrying metadata.
