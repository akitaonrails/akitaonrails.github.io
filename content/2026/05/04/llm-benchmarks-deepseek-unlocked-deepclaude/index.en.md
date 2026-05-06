---
title: "LLM Benchmarks: DeepSeek Unlocked! Use DeepClaude"
date: '2026-05-04T16:00:00-03:00'
draft: false
translationKey: llm-benchmarks-deepseek-unlocked-deepclaude
slug: llm-benchmarks-deepseek-unlocked-deepclaude
tags:
  - ai
  - llm
  - benchmark
  - deepseek
  - claudecode
  - ruby
---

DeepSeek V4 Pro stopped being a lost cause in my coding benchmark. It used to be solo Tier B (69/100) and literally unmeasurable in any multi-agent scenario, because it kept hitting a protocol bug I documented across the last two posts. The good news: I found a path that unblocks the model, and it jumped out of limbo straight into **Tier A at 89/100**, sitting only behind Opus 4.7, GPT 5.4/5.5 and Kimi K2.6. I'll walk through how I got there, what **DeepClaude** is, how you can use it, and where this puts DeepSeek in the updated ranking.

## Recapping the previous posts

If you just got here, the context matters. This benchmark experiment kicked off in April, and the DeepSeek case has been unfolding across four articles:

1. [Testing Open Source and Commercial LLMs — Who Can Beat Claude Opus?](/en/2026/04/05/testing-llms-open-source-and-commercial-can-anyone-beat-claude-opus/) (April 5). First cut, comparing ~20 models running a Rails 8 + RubyLLM + Hotwire + Tailwind + Minitest task. It defined the scenario and the base task I'm still using today.

2. [LLM Benchmarks Part 2: Worth Combining Multiple Models in the Same Project? Claude + GLM??](/en/2026/04/18/llm-benchmarks-part-2-multi-model/) (April 18). First orchestration attempt: have a strong planner (Opus) call cheaper subagents (Kimi, Qwen, GLM, DeepSeek). Result: zero delegations across seven free-choice variants. Strong models would rather do everything themselves.

3. [LLM Coding Benchmark (May 2026): DeepSeek v4, Kimi v2.6, Grok 4.3, GPT 5.5](/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) (April 24, updated in May). The canonical version with 24 models, standardized 0-100 rubric across 8 dimensions, A/B/C/D tiers. It's the current "who's what" reference.

4. [LLM Benchmarks: Is it worth ($) mixing 2 Models? (Planner + Executor)](/en/2026/04/25/llm-benchmarks-vale-a-pena-misturar-2-modelos/) (April 25). Three rounds of multi-model orchestration: free-choice, forced delegation, and manual cross-process orchestration. Short answer: for a cohesive Rails greenfield task, solo Opus 4.7 in opencode (97/100, $4, 18m) beats every combination. This was the post where I documented DeepSeek V4 Pro's protocol incompatibility with any ai-sdk-based harness.

The DeepSeek story up to that point looked like this: solo in opencode delivers 69/100 Tier B (correct RubyLLM code, but with a stock README, no `docker-compose.yml`, no bundle-audit). In any multi-turn opencode scenario, the API rejects turn 2 with `"reasoning_content must be passed back to the API"`. The ai-sdk that opencode uses underneath strips `reasoning_content` while building the next request, and DeepSeek returns 400. Worse: opencode buries the error in the event stream and falls back to the `general` agent, which is Opus 4.7. The runs "complete" with files written, but most of the output came from Opus masquerading as DeepSeek. Score 69 reflects mixed authorship, not V4 Pro for real.

The takeaway that landed: DeepSeek V4 Pro was fundamentally incompatible with any ai-sdk harness (opencode included). To use it for real, you'd need direct API with thinking-mode handling or a custom harness.

The discovery this week is that a custom harness already exists. It's called **DeepClaude**.

## What DeepClaude is

[DeepClaude](https://github.com/aattaran/deepclaude) is a shell shim for Claude Code (Anthropic's CLI) that swaps the endpoint it queries. Claude Code, under the hood, talks to `api.anthropic.com` and expects the Anthropic format (Messages API with `system`, `messages`, `tools`, etc.). DeepClaude sets a few environment variables before invoking Claude Code:

```bash
ANTHROPIC_BASE_URL          # alternative endpoint
ANTHROPIC_AUTH_TOKEN        # token for the alternative endpoint
ANTHROPIC_DEFAULT_OPUS_MODEL    # model to invoke instead of Opus
ANTHROPIC_DEFAULT_SONNET_MODEL  # same for Sonnet
ANTHROPIC_DEFAULT_HAIKU_MODEL   # same for Haiku
CLAUDE_CODE_SUBAGENT_MODEL  # subagent model
```

Supported backends:

- **DeepSeek directly** via `api.deepseek.com/anthropic` (needs `DEEPSEEK_API_KEY`)
- **OpenRouter** via `openrouter.ai/api` (needs `OPENROUTER_API_KEY`)
- **Fireworks AI** via `api.fireworks.ai/inference` (needs `FIREWORKS_API_KEY`)
- **Anthropic** (no override, regular Claude Code)

The clever bit is that Claude Code never realizes the swap. Its full agent loop (file editing, bash execution, subagent spawning, multi-step tool use, Anthropic prompt caching) runs the same way. It's just that every model call goes out via OpenRouter (or DeepSeek direct, or Fireworks) and lands on a model you picked. In our benchmark's case, DeepSeek V4 Pro now receives the traffic that would normally go to Opus 4.7.

Why does this fix the `reasoning_content` bug? Because OpenRouter's Anthropic-compatible endpoint (`/anthropic`) handles thinking content correctly in the format Claude Code emits. The ai-sdk opencode uses didn't. Different harness, no bug.

Install:

```bash
git clone https://github.com/aattaran/deepclaude ~/Projects/deepclaude
ln -sf ~/Projects/deepclaude/deepclaude.sh ~/.local/bin/deepclaude
chmod +x ~/Projects/deepclaude/deepclaude.sh
deepclaude --status   # confirms which backend keys it detected
```

Then run:

```bash
export OPENROUTER_API_KEY=sk-...
deepclaude --provider openrouter --model deepseek/deepseek-v4-pro
# starts a Claude Code session with DeepSeek V4 Pro answering instead of Opus
```

To exit and go back to regular Claude Code, just `exit` the session. The environment variables are restored at the end of the script.

## How I extended the benchmark suite to support DeepClaude

The `claude_code_runner.py` I already use to run Claude Code variants (`claude_opus_alone`, `claude_opus_sonnet`, `claude_opus_haiku`) needed a way to inject env vars per variant, without breaking the existing pipeline. I added an optional `env_overrides` field to the JSON config of each variant. The shape:

```json
{
  "env_overrides": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api",
    "ANTHROPIC_AUTH_TOKEN": "$OPENROUTER_API_KEY",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek/deepseek-v4-pro",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek/deepseek-v4-pro",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek/deepseek-v4-pro",
    "CLAUDE_CODE_SUBAGENT_MODEL": "deepseek/deepseek-v4-pro",
    "UNSET:ANTHROPIC_API_KEY": ""
  }
}
```

Conventions:

- A value starting with `$` is an indirect lookup against the parent shell env (`$OPENROUTER_API_KEY` resolves to whatever's in the user's shell). Keeps secrets out of the version-controlled `config/*.json`.
- A key starting with `UNSET:` removes the variable from the subprocess env. I use this to drop `ANTHROPIC_API_KEY` when swapping to a non-Anthropic backend, otherwise the SDK might prefer it over `ANTHROPIC_AUTH_TOKEN`.
- Everything else is literal.

The runner logs which overrides got applied (with masked secrets) at the start of each variant, so the benchmark output captures the full setup. That gave me two new variants in the benchmark:

| Slug | Setup | Subagent registered? |
|---|---|---|
| `claude_code_deepseek_v4_pro_or` | Claude Code via DeepClaude → DeepSeek V4 Pro for the entire loop | none |
| `claude_code_deepseek_v4_pro_or_sonnet` | Same, but with `sonnet-coder` registered (Sonnet 4.6 via Anthropic API) | yes, but zero delegations observed |

Both ran with `--no-progress-minutes 15` (the standardized watchdog from Round 2.5).

## Results: DeepSeek V4 Pro in Tier A

Both variants ran end-to-end with no `reasoning_content` errors. Multi-turn works. Registered subagent works (even if not invoked). Tool calls, file editing, bash, all of it works. The numbers:

| Variant | Status | Time | Files | Turns | Delegations | Cost | Score | Tier |
|---|---|---:|---:|---:|---:|---:|---:|---|
| `..._or` | completed | **21m** | 1544 | 106 | 0 (no subagent) | **$3.38** | **84** | A |
| `..._or_sonnet` | completed | **18m** | 1348 | 109 | **0** (Sonnet ignored) | **$3.14** | **89** | A |

Both 100% billed against `deepseek/deepseek-v4-pro`. Zero Sonnet tokens despite being registered. The subagent was there, the DeepSeek planner just never invoked it.

And where does this put DeepSeek in the canonical ranking? Here:

| Rank | Model | Score | Tier | Time | Cost |
|---:|---|---:|:---:|---|---|
| 1 | Claude Opus 4.7 (opencode) | **97** | A | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | **97** | A | 22m | ~$16 |
| 3 | GPT 5.5 xHigh (Codex) | **96** | A | 18m | ~$10 |
| **4** | **DeepSeek V4 Pro (DeepClaude + sonnet registered)** | **89** | **A** | **18m** | **$3.14** |
| 5 | Kimi K2.6 | 87 | A | 20m | ~$0.30 |
| 6 | DeepSeek V4 Pro (DeepClaude solo) | 84 | A | 21m | $3.38 |
| 7 | Claude Opus 4.6 | 83 | A | 16m | ~$1.10 |
| 8 | Gemini 3.1 Pro | 82 | A | 14m | ~$0.40 |
| 9 | Claude Sonnet 4.6 | 78 | B | 16m | ~$0.63 |
| 9 | DeepSeek V4 Flash | 78 | B | 3m | ~$0.01 |
| 11 | Qwen 3.6 Plus | 71 | B | 17m | ~$0.15 |
| ... | DeepSeek V4 Pro (opencode solo) | 69 | B | ~25m | ~$1 | (old config, kept as reference) |

In one round V4 Pro delivers Tier A, leaves the "unmeasurable" limbo behind, lands next to Kimi K2.6, and beats Opus 4.6 / Gemini 3.1 Pro. **A 15-to-20-point lift from a harness change alone.** Same model, same prompt, no orchestration, just a different agent loop.

## What this round proved (and what it didn't)

### The Claude Code regression with Opus is Opus-specific, not a harness property

This is the biggest finding. In Round 1 I'd documented that Opus 4.7 inside Claude Code hallucinated `chat.complete` (Tier 3), while the same Opus 4.7 in opencode delivered Tier A. The hypothesis was that the context Claude Code injects (system prompt, tool schemas, agent registry, with 6-11M cache-read tokens) was nudging Opus toward an OpenAI-SDK mental model instead of the specific RubyLLM one.

DeepSeek V4 Pro inside the same Claude Code harness used the correct `chat.ask` path (`chat_service.rb:17` in both variants). No `chat.complete`, no invented fluent DSL, no batch-form invention. Cross-grep on both project trees:

```
grep -nE "RubyLLM::Client|chat\.complete|chat\.send_message|chat\.user|chat\.assistant"
→ 0 hits (both variants)
```

The regression is Opus-specific. Opus's training has a particular vulnerability to how Claude Code's system prompt and schema-chatter prime the model. DeepSeek is robust to it. Other reasoning models with correct RubyLLM training would probably make it through Claude Code without regressing the same way.

### A registered subagent, even when never invoked, lifts quality

The more subtle finding. The `..._or_sonnet` variant has `sonnet-coder` registered, but DeepSeek never invoked it (zero delegations, 100% of tokens on `deepseek/deepseek-v4-pro`). And yet it scored +5 over the sister variant with no subagent (89 vs 84). Auditor attribution: with a subagent available "in case I need it", the DeepSeek planner produced measurably more delegable decomposition. Smaller seams, cleaner DI, system prompt used via `with_instructions`, controller test that mocks the real service API shape instead of fudging it.

> Knowing a subagent might execute the work pushes toward smaller, more contractable units — even when nothing actually delegates. Weak signal, single sample, but visible.

This lines up with prior findings that the structured CONVERGE phase (planner forced to articulate the interface before executing) was the actual driver of quality lifts in some forced runs, more than the delegation itself. Just having a subagent available makes the planner think more like an architect.

### The multi-turn controller bug persists

A specific defect that survives the harness change: both DeepClaude variants have multi-turn problems at the controller layer.

- Variant 1 (`..._or`): outright single-shot. `chats_controller.rb:10` builds a 1-element messages array on every POST, throwing history away. The `ChatService` supports history, but the controller never sends it.
- Variant 2 (`..._or_sonnet`): correct multi-turn via `session[:messages]`, but the cookie-store overflows around 10 turns with `CookieOverflow`.

The solo DeepSeek run in opencode (69/100) had the same single-shot issue. Different harness, different agent loop, same model-level mistake. Multi-turn architecture for stateless Rails is genuinely hard for DeepSeek and a harness change doesn't help with that specific gap.

### DeepSeek as planner also ignores subagents on cohesive tasks

I'd already documented in earlier posts that every frontier LLM (Opus, GPT 5.4, Codex) ignored their registered subagents on the cohesive Rails task. That got documented as planner rationality: smart planners correctly intuit that coordination cost exceeds execution savings on a tightly coupled task.

Round 4 adds DeepSeek V4 Pro to the list: Sonnet 4.6 registered, zero delegations. It generalizes the finding to "strong reasoning model facing greenfield Rails with an optional delegate", instead of being a quirk of Opus. DeepSeek's no-delegate behavior matches what every other strong planner has done.

## Updated answer to "is orchestrating worth it?"

The Round 3 verdict was: for one-off greenfield Rails, solo Opus in opencode wins. Round 4 adds three cases:

For users who don't have access to Anthropic Claude Opus (or want to avoid Anthropic-direct cost), `claude_code_deepseek_v4_pro_or_sonnet` is the closest substitute: 89/100 Tier A, 18m, $3.14, running entirely through OpenRouter using a key you already have. It's the first meaningful "Tier A coding without an Anthropic subscription" answer in the benchmark.

For users who do have Opus, DeepClaude is still slightly worse on quality (-8) for marginally better cost (-$0.66). Not worth the trade.

For comparing models inside the Claude Code harness directly, DeepClaude makes the comparison possible: DeepSeek V4 Pro at 84-89 vs Opus 4.7 at the regressed Tier-3 level in the same harness. DeepSeek V4 Pro through DeepClaude beats Opus 4.7 inside Claude Code on quality, cost, and multi-turn. Worth remembering this only happens because Opus regresses in this harness; against Opus in opencode (97), DeepSeek is clearly behind.

## The cross-harness picture for DeepSeek V4 Pro

It looks like this:

| Harness | Outcome |
|---|---|
| opencode solo (single agent) | 69/100 Tier B — works, lacks deliverable polish |
| opencode multi-agent forced (executor) | UNMEASURABLE — `reasoning_content` interop bug fails at turn 2 |
| opencode + manual cross-process orchestration (executor) | UNMEASURABLE — same bug |
| Claude Code via DeepClaude OR (solo) | **84/100 Tier A** — works, harness fills the polish gap |
| Claude Code via DeepClaude OR (with registered subagent) | **89/100 Tier A** — modest planner-availability bonus |
| Claude Code direct (Anthropic API) | not tested — would need `DEEPSEEK_API_KEY` for the native endpoint |

Bottom line, DeepSeek V4 Pro is a Tier-A coder when delivered through a strong autonomous loop (Claude Code) and Tier B when delivered through a thinner harness (opencode). The RubyLLM API correctness is the same in both cases. The score difference is entirely in deliverable completeness (README, compose, CI tooling) which Claude Code's loop fills in.

## What to use this for

Three scenarios where DeepClaude becomes the right tool.

The first is Tier-A coding on a budget, with no Anthropic subscription: the `..._or_sonnet` variant is the new default. $3.14, 18m, 89/100, Tier A, running entirely through OpenRouter.

The second is validating whether the Claude Code regression hits other models. It hits Opus, doesn't hit DeepSeek. The `chat.complete` regression is Opus-specific. DeepSeek (and presumably other reasoning models with correct RubyLLM training) cross the harness without regressing.

The third is future experiments. DeepClaude opens the door to running any OpenRouter model through Claude Code's full agent loop. Worth re-testing Kimi K2.6 and Qwen 3.6 Plus through DeepClaude to compare against the manual-orchestration Round 3 results. Same model, different harness, see where the lift lands. There's a real chance Kimi K2.6 (already Tier A at 87) climbs to 90+ and ties V4 Pro deepclaude. That's the next round of the benchmark.

## Caveats from DeepClaude

Things the project README warns about, worth repeating here.

No image input: the DeepSeek Anthropic endpoint doesn't support vision. For this benchmark it's text-only, so no impact. For other use cases it can be a real limitation.

No MCP server tools: the compatibility layer doesn't support MCP. If you use MCPs in your normal Claude Code workflow, they won't work inside DeepClaude.

Anthropic prompt caching is ignored. The `cache_control` markers Claude Code emits get dropped on the floor. DeepSeek has its own automatic caching (which shows up in the `cache_read` of the token usage), but the explicit cache markers get dropped. Per-turn cost ends up slightly higher than a comparable Anthropic-direct run because of this. Relevant for apples-to-apples cost comparisons.

## Wrapping up

DeepSeek V4 Pro is out of limbo. It was Tier B in opencode solo and unmeasurable in any multi-agent scenario. Through DeepClaude (Claude Code with env vars pointed at OpenRouter) it delivers Tier A at 89/100, beats Opus 4.6 and Gemini 3.1 Pro, lands next to Kimi K2.6, costs $3.14 in 18 minutes. The lift didn't come from orchestration or a better model: it came purely from swapping the harness for an agent loop DeepSeek can drive well. For anyone without Opus access but with an `OPENROUTER_API_KEY`, this is the first real Tier-A coding option without an Anthropic tether.

The next round is already cooked: run Kimi K2.6 and Qwen 3.6 Plus through DeepClaude to see whether the "strong harness lifts a Tier-B/A model to the top" effect reproduces. If it does, that opens up a whole family of budget variants that can compete with solo Opus in the benchmark. If it doesn't, it becomes clear that DeepSeek has a specific affinity with the Claude Code loop the others don't share. Both outcomes are interesting.

## References

- [DeepClaude on GitHub](https://github.com/aattaran/deepclaude) — the shell shim itself, README with the full list of supported backends
- [Round 4 success report](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.deepclaude.md) — the full technical report this post comes from
- [DeepClaude integration in the benchmark](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/deepclaude-integration.md) — runner patch, `env_overrides` shape, smoke test
- [Benchmark repo](https://github.com/akitaonrails/llm-coding-benchmark) — code, configs, results from every round
