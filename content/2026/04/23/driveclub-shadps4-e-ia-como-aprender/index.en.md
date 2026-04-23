---
title: "How DriveClub and shadPS4 Almost Defeated AI and Me: How to Learn"
date: '2026-04-23T12:00:00-03:00'
draft: false
translationKey: driveclub-shadps4-ai-how-to-learn
tags:
  - driveclub
  - shadps4
  - emulation
  - ai-agents
  - claude-code
  - learning
  - ps4
---

## Where we were

Last week I [posted about my distrobox-gaming setup](/en/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/), with more than ten retro racing games running on Linux, from Gran Turismo 1 on DuckStation to Forza Motorsport 4 on Xenia. At the end of that piece, I described Driveclub on shadPS4 as the "final boss": the game boots, the menu loads, the race starts, the controller responds.

Except I mentioned two problems in passing and treated them as "accepted limitations":

1. **During daytime, the image is a bit darker than on a reference PS4.** Not alarming, but noticeable.
2. **At night, the race start in Canada or Munnar went pitch black for 10 to 30 seconds** before the game "recovered on its own" around the 1:30 mark. During those seconds, only the HUD was visible. Track, car, headlights — all absolute black.

In the previous article I pushed the explanation to "it's just not fixed in the emulator yet, I'll live with it". But inside I couldn't make myself play the game in a visually unplayable state. I wanted to play DriveClub at its best, and I didn't want to sit around waiting for the project to fix it for me. I decided to take matters into my own hands. Thirty seconds of absolute black isn't "a bit darker". It's a serious bug, the kind that makes a game unplayable in practice.

This article is what happened between Sunday night and Thursday morning.

## The blackout, live

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/original-blackout.mp4" >}}

This video is the behavior I wanted to fix. Race start in India (Munnar), night race. You see the track, headlights turn on, the first few seconds run. Then it darkens progressively. Within about 15 seconds everything is black. Stays that way for another 60-90 seconds. Then the game "recalibrates" on its own and the track reappears.

If you're a player, you don't care why. You just want to drive.

## Why shadPS4 is hard to debug

[shadPS4](https://shadps4.net/) **still has no stable release**. The project is under active development. The main branch changes several times a week, configs migrate from TOML to JSON without notice, settings hide behind "Advanced" so users with incompatible hardware don't file issues, open PRs compete over different approaches to the same problem.

Anyone trying to configure DriveClub today will find:

- September/2025 Reddit guides using `readbacks = true` (it was a boolean back then) saying "for DriveClub always enable readbacks".
- November/2025 guides saying "disable readbacks, it kills performance" (because in 2025-07 readbacks became an enum `Disabled | Relaxed | Precise` with different performance profiles, and Bloodborne started hanging with it on).
- January/2026 YouTube videos using some custom fork nobody documented.
- A thread on shadps4.net with three different, mutually exclusive explanations for the blackout.
- My own notes from last week in [`distrobox-gaming/docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md) saying `readbacks_mode: 0`. The exact opposite of what I found this week.

So the information exists, but it's scattered, dated, contradictory, and most of it depends on version details that changed between the original post and today. Reproducing a setup from a YouTube video is like trying to solve a Rubik's cube blindfolded.

## Spoiler: the solution is one integer

After 31 phases of investigation, 44 commits on my shadPS4 fork, 15,668 lines of instrumental code added, and three days of nearly uninterrupted debugging, the answer is **one line in the per-game config**:

```json
{
  "GPU": {
    "readbacks_mode": 2
  }
}
```

`readbacks_mode: 2` is the `Precise` mode. Explaining what it does requires understanding how DriveClub implements auto-exposure, and that's where the journey starts. To know WHY this toggle fixes things, you have to understand the whole chain.

The short version: **DriveClub implements auto-exposure as a GPU→CPU feedback loop**.

1. The scene renders to an HDR target.
2. A compute shader calculates a luminance histogram into an SSBO.
3. The CPU **reads** that SSBO on the next frame and derives a target exposure.
4. The CPU writes that exposure back into a 1936-byte lighting UBO (at slots `[38] [48] [50]`).
5. Fragment shaders read that UBO and multiply scene luminance by it.

Without `readbacks_mode: Precise`, step 3 reads stale zeros. The memory page where the GPU wrote the histogram is never synchronized to the CPU side. The CPU exposure integrator concludes "scene is dark, open the aperture all the way" and ramps its output value monotonically: `2.59 → 7.84 → 24 → 90 → 179 → 255`. Within 60-90 seconds the scale saturates so high that everything clips to zero. That's the pitch black.

With `readbacks_mode: Precise` on, the emulator marks the pages the GPU just wrote as kernel-protected (via `mprotect` on Linux). When the CPU tries to read one of those pages for the first time, a page fault fires. The emulator intercepts it, issues a `vkCmdCopyBuffer` download from the GPU buffer to the host staging area, waits on the scheduler, and the CPU finally sees fresh data. The real histogram enters the integrator, exposure converges normally, and the race start opens bright as it should.

Why isn't it the default? Three documented reasons. First, per-page `mprotect` + per-fault GPU stall + compute dispatch + scheduler wait has a real cost: on NVIDIA's warm path it's tolerable, on AMD it tanks below 12 FPS, with an [open issue](https://github.com/shadps4-emu/shadPS4/issues/3322) about it. Second, [Bloodborne hangs](https://github.com/shadps4-emu/shadPS4/issues/3826) on loading screens with Precise enabled. Third, the maintainer tucked the option behind "Advanced" in the UI precisely to keep users with sensitive hardware from enabling it by mistake. The mode has existed since `v0.15.0` (September/2025), but **nobody had publicly connected `Precise` + DriveClub + auto-exposure feedback loop**. The [compat tracker already admits](https://github.com/shadps4-emu/shadPS4/issues/3346) that DriveClub "requires readbacks enabled to function properly", but doesn't specify the mode.

In my setup the performance cost is irrelevant. I have an RTX 5090 on my desktop, plenty of hardware to swallow the mprotect, the page fault, the copy and the stall per frame. The call is trivial: I flip Precise on, pay the price, the game runs. On more modest hardware or on AMD the conversation is different, which is exactly why this setting isn't default and hides behind "Advanced".

One thing I want to make clear: this whole explanation above (`Precise` vs `Relaxed` vs `Disabled`, GPU→CPU feedback loop, per-page mprotect syscall) is not knowledge I had on Sunday night. I didn't know what a buffer readback was, didn't know DriveClub implemented auto-exposure as a GPU→CPU feedback loop, didn't know `readbacks_mode` had become an enum in 2025 with three values. To arrive at the right answer, I had to learn every piece from scratch. I couldn't guess. Had I tried to "enable readbacks" last week without understanding the chain, I'd have picked the wrong value (Relaxed isn't enough for this feedback loop, as I'll explain below) and given up thinking "it doesn't work".

Two more things need to be in place for this to work, both covered in the [previous article](/en/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/#driveclub-the-impossible-finally-possible):

- **v1.28 patch applied** on top of the v1.00 base install (without it, content stays locked with "not yet released").
- **60fps XML patch disabled** (it raises the render rate but the logic tickrate is fixed; with it on, the game runs in slow motion).

## The result

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/canada-fixed.mp4" >}}

Same race in Canada, night, with `readbacks_mode: 2` on. Race start opens bright, auto-exposure converges immediately, the night transition unfolds naturally as the game's TOD (time of day) advances. No blackout, no "recalibration" at 1:30, no 30-second window of absolute black. This is DriveClub running like it does on PS4.

Now the interesting question is not "which setting". It's: **how did we get here?**

## How does a junior learn today?

There's a question I hear often: "with AI doing everything, how does a junior learn?"

The premise is wrong. **AI doesn't do everything.** AI does what you ask it to. It doesn't discover on its own. It has no domain initiative. It's not capable of telling you "hey, this looks like a broken GPU→CPU readback feedback loop" unless you already know there's a thing called a readback and that broken feedback loops are a class of bug.

Worse: if you go to an AI agent today and ask "fix this black screen in DriveClub on shadPS4", it will give you a list of possible answers based on old forum posts, with a high probability of steering you wrong. It will suggest the 60fps XML patch (wrong — causes slow motion). It will suggest a tonemap override (wrong — the game already writes correct SDR). It will suggest a vblank_frequency tweak (useless for the real problem). It will suggest manual gamma (treats the symptom, not the cause).

The way to discover is to **dive into the chain**, phase by phase, ruling out wrong hypotheses until the terrain is familiar enough that you recognize the right answer when it appears.

That's where a lot of people misread me. "Akita is already a senior, he has 25+ years of experience, of course he knows." **False.** A senior is someone who has been a junior in every topic they master. And they keep becoming a junior every time they pick up a new domain. I have 25 years of web programming, distributed systems, Ruby, Erlang, Go. But **I've never programmed for PS4**. I'd never looked at the shadPS4 codebase. I didn't know PS4's graphics architecture. On Sunday I was an absolute junior in this domain.

But junior doesn't mean totally green. A while back I had explored on my YouTube channel the low-level architecture of older consoles (from the NES's 6502 onward) and how emulators work internally in general. The two videos below helped build the basic vocabulary for how a game console works under the hood, and made sure I wouldn't trip on concepts like fetch-decode-execute, opcode, interrupt, or HLE vs LLE.

{{< youtube id="hYJ3dvHjeOE" >}}

{{< youtube id="vUqLLpUJ47s" >}}

I had also made an older video on the evolution of CPUs, GPUs, DirectX, and Vulkan, so at least the vocabulary of "modern graphics pipeline" and "shading language" wasn't alien.

{{< youtube id="JEp7ozWqIps" >}}

Knowing that `VkCommandBuffer` exists is very different from knowing where in shadPS4 a readback `vkCmdCopyBuffer` fires. But it gives you a base. That kind of old curiosity paid interest now.

## The rotation: Claude Code and Codex

AI (in my case [Claude Code](https://claude.com/claude-code)) didn't "know" more than I did. It has the same dated forum text you'd find on Reddit. What it did well was **aggregate**: read shadPS4 source code in parallel with me, index comments, cross-reference between phase docs, compile, run probes, parse 61 MB logs, compare decompiled binary against UBO diffs, shine light on corners of the system faster than I could alone.

But the decision to "keep investigating" was mine. The perseverance of "don't accept a mitigation, want the root cause" was mine. And when the AI suggested "honestly, we should just accept the current result and document it" (and it suggested this **several times** over the four days), I was the one who had to say "no, we keep going".

The central point about the rotation: **no single LLM managed to close this problem alone.**

Over the four days, Claude Code repeatedly got stuck looping on the same hypotheses with no new direction. When that happened, I'd switch to Codex for a few hours to bring in outside ideas, different probes, a re-read of the codebase from a fresh angle. Then back to Claude Code to integrate what Codex had surfaced. And so on, alternating.

The final resolution happened on Claude Code, but the journey switched models several times. Each LLM had its biases and blind spots. Left alone, each one would have given up sooner.

What broke the impasse was me continuing to bring in new ideas to try, forcing the model to reassess, switching models whenever one started to repeat itself.

At two points things went past "just repeating hypotheses". Codex literally had an agentic-loop glitch: it started repeating the exact same "solution" it had just tried, over and over, in sequence, without noticing what it was doing. It was the first time I'd ever seen that happen in any AI agent. I had to kill the session and start a fresh one from zero to break the cycle.

That says something about context size and session duration. The complexity and pace of this investigation were enough to bring both LLMs to their knees, each in their own way.

The whole journey below is documented in 33 phase docs on the [`gamma-debug` branch of my shadPS4 fork](https://github.com/akitaonrails/shadPS4/tree/gamma-debug/docs/driveclub-investigation). Each section here links to the original doc for anyone who wants the complete detail. Here I summarize the essentials: the hypothesis we had, what we tried, what new concept we had to learn, and why the phase didn't close the case.

## Session zero: baseline and reproducibility

Every serious investigation starts before Phase 1. The first thing, for any project, is to make sure the **baseline works as expected** and that the situation you want to research is **reproducible every time**. If you can't reproduce the bug on demand, you're chasing ghosts. Every probe after that will be inconclusive because the bug "appeared and vanished" without control. And if the baseline is broken in some way you haven't noticed, every experiment measures the wrong problem. Without those two guarantees, you can't make progress.

In my case, on Sunday night I confirmed:

- The game boots all the way to the race screen without crashing, using the [`distrobox-gaming`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md) config.
- [DriveClubFS](https://github.com/Nenkai/DriveClubFS) extracts v1.28 cleanly, 8018 files, ~47 GB.
- MSAA depth resolve applied on the fork; night tracks render shapes instead of uniform absolute black (covered in the [previous article](/en/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/)).
- 8BitDo controller detected.
- Night race in India 19:30 **reproduces the blackout on 100% of attempts**, with the same temporal pattern: progressive fade in the first ~15s, pitch black between ~20s and ~90s, "recalibration" at 1:30.

That baseline is the only solid ground that lets me compare each experiment reliably. Without it, a probe that "worked" might just be a different cache state, not the real fix. With it, every change has a before and an after that are measurable.

Beyond that, zero specific knowledge of:

- PS4 PKG format (PFS, param.sfo, disc_info, keystone).
- shadPS4 codebase (src/core, src/video_core, shader_recompiler, buffer_cache).
- PS4 graphics pipeline (GCN ISA, forward+ lighting, MSAA depth resolve).
- Vulkan beyond the surface (descriptor sets, UBO binding, push constants, pipeline cache).
- SPIR-V disassembly and patching.
- PS4 OELF loader, Itanium RTTI, SCE dynamic relocations.
- mprotect-based page-fault tracking for CPU-GPU synchronization.

## The journey, phase by phase

I'll group the 30+ phases into buckets that make sense as a narrative. Each phase links to the full doc for anyone who wants technical detail.

> **Note for anyone who doesn't want to read all 30+ phases:** after the phase sequence there are reflection and methodology sections you can read on their own. [The shotgun technique](#the-shotgun-technique) explains the debugging methodology I used throughout the investigation. [What I knew on Sunday vs Thursday](#what-i-knew-on-sunday-vs-thursday) sums up what I actually learned. [The AI suggested accepting. The perseverance was mine](#the-ai-suggested-accepting-the-perseverance-was-mine) discusses AI's real role in this process. [The real cost of this journey](#the-real-cost-of-this-journey) catalogs what got produced. If you want to jump straight to the argument, those are the shortcuts.

### Phase 01: pipeline cache, the warm-up

> [`phase-01-shader-compile-stalls.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-01-shader-compile-stalls.md)

- **Hypothesis:** menus run at 2-3 fps on first launch. Must be Vulkan pipeline compilation happening in real time.
- **Action:** enable `pipeline_cache_enabled: true` in the global config.
- **New concept:** Vulkan pipeline caching. When the emulator translates a PS4 GCN shader into SPIR-V and then into driver-specific Vulkan binary, it can cache that binary. Without the cache, it recompiles every cold launch (~864 shaders + ~590 pipelines).
- **Outcome:** solved. First session pays the cost; subsequent sessions read from disk and launch immediately. Easy. Also my first lesson about the shadPS4 codebase.

### Phase 02: gamma dim, starting in the wrong direction

> [`phase-02-gamma-dim-image.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-02-gamma-dim-image.md)

- **Hypothesis:** DriveClub's image is dim compared to reference. Must be wrong sRGB encoding or an HDR tonemap applied badly by the emulator.
- **Action:** instrumented the swapchain to log format, added `SHADPS4_PP_*` env vars to experiment, built a post-processing pipeline with three knobs (exposure, ACES tonemap, gamma curve).
- **New concept:** sRGB OETF, HDR tonemap (ACES vs Reinhard), Bayer dither as anti-banding.
- **Outcome:** via bypass path (`SHADPS4_PP_BYPASS=1`, writes raw game output with no post-processing) I discovered the **game writes correct SDR already** into the framebuffer. The emulator's post-processing pipeline was mangling the signal. Final shader became simply sRGB encode + Bayer dither. Dim persists, but it's not a gamma problem.

![Gamma adjustments going wrong everywhere](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/wrong-gamma.png)

![Blown out: gamma too high](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/wrong-gamma-blown.png)

![Dark sky: gamma too low](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/wrong-gamma-sky-dark.png)

Three hours on this phase. The most important lesson: **when "the image looks wrong", the first diagnostic should be a bypass path that shows raw game output**. If bypass looks right, the emulator is the one mangling the signal. Stop touching the tonemap.

### Phase 03: v1.28 content access

> [`phase-03-v128-content-access.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-03-v128-content-access.md)

- **Hypothesis:** v1.28 extracts, but the game says "content not released yet, download required".
- **Action:** merge v1.28 on top of v1.00, restore `param.sfo`, `disc_info.dat`, `keystone`.
- **New concept:** PS4 cumulative patches, package metadata.
- **Outcome:** solved. Detailed in the [previous article](/en/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/).

### Phase 04: MSAA depth + slow motion

> [`phase-04-slowness.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-04-slowness.md)

- **Hypothesis:** night tracks are pitch black and the game "feels slow".
- **Action:** two separate things. Disable the 60fps XML patch (which was decoupling render rate from logic tickrate). Implement `ReinterpretMsDepthAsColor` on my fork (to let the emulator resolve 4x MSAA depth to 1-sample color, which DriveClub needs for forward+ lighting on night tracks).
- **New concept:** forward+ lighting (a renderer that writes the scene to an MSAA depth target and then reads it as color for SSAO and volumetrics), MSAA depth resolve.
- **Outcome:** both fixed. Detailed in the [previous article](/en/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/).

### Phase 05: second pass on brightness

> [`phase-05-brightness-followup.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-05-brightness-followup.md)

- **Hypothesis:** since the game writes correct SDR, maybe a static boost in post-processing helps without touching the UBO feedback loop.
- **Action:** tried linear boost (1.5x, 2.0x), gamma pre-encode (pow curve), scene-aware auto-exposure with peak+mean sampling.
- **Outcome:** all rolled back. Linear boost clips highlights. Gamma introduces banding. My auto-exposure layer cancels the user's manual brightness slider. There's no free lunch in post-processing. Dim stays dim without real HDR or shader patches.

![Sky too dark](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/wrong-gamma-sky-dark.png)

### Narrowing the blackout: the shared gate

> [`race-start-blackout-040420.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/race-start-blackout-040420.md)

- **Hypothesis:** the blackout has a curious signature. Main view goes dim/black, rearview mirror goes absolute black, HUD stays bright. Three layers with different behaviors suggest a shared "gate", not a common fade.
- **Action:** instrumented texture-cache aliasing, probed with live fragment shader substitution on suspected inputs.
- **New concept:** texture-cache aliasing (multiple images sharing a memory address, which the emulator cache reuses), render-target lifetime.
- **Outcome:** points to a shared "presentation permission" between the main scene and the mirror, not a scripted fade.

![Blackout baseline](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/screenshot-2026-04-20_21-22-45.png)

### Phases 07-09: texture torture, UI surgery, binary patch plan

> [`phase-07-aggressive-torture-probe.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-07-aggressive-torture-probe.md) · [`phase-08-ui-asset-surgery.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-08-ui-asset-surgery.md) · [`phase-09-eboot-binary-patch-plan.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-09-eboot-binary-patch-plan.md)

- **Hypothesis:** the race-start dim overlay is an asset. Small texture, UI panel, or a method of the `FreeplayGetInCar` controller in the eboot.
- **Action:** null-substituted BC-compressed materials, small texture candidates, four-vector weight masks during critical draws. Disabled UI panels (`loading_freeplay.txt`, `get_in_car_animation.txt`, `vehicle_select_background`). Extracted the OELF, located `FreeplayGetInCar` ASCII strings, identified the constructor at VA 0xf89b00 and the vtable at 0x15dc3e0.
- **New concept:** PS4 OELF loader (Sony's variant of ELF), Itanium C++ RTTI (how C++ encodes type info in vtables), SCE dynamic relocations (placeholders that only the dynamic loader resolves at runtime).
- **Outcome:** nulls work but the fade persists. The overlay renders directly into HDR scene targets, not through the panel system. Binary patching has relocation placeholders that aren't statically resolvable without a Ghidra + PS4 plugin. **Asset-side surface exhausted.** Six hours of debugging, final conclusion: the bug lives in state, not in an asset.

### Phase 10: rethink + animlib

> [`phase-10a-rethink-040422.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-10a-rethink-040422.md) · [`phase-10b-video-diagnostic-animlib.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-10b-video-diagnostic-animlib.md)

Tuesday morning. Sat down, rebooted mentally. New model: the blackout is a **state-machine gate**. It's not "scene not ready", it's "permission transition". The gate closes after the starting grid appears. Next probe: runtime dispatch trace, enough of the blind asset surgery.

In parallel: frame extraction from the recording at 10 Hz, cross-referenced against keyframes of the animation library (`animlib`) in `india_posteffects.lvl`. Found a smoking gun. The `MasterBrightness` track has keyframes 0.003 and 0.0007 (0.63% brightness) where the default would be 1.0. Animlib beats inline defaults every frame.

- **New concept:** animation library, keyframe encoding, binary float-scanning.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/debugging-blackout-fade.mp4" >}}

Video above: the process of probing the fade in real time.

### Phase 11: multi-scalar patch

> [`phase-11-multi-scalar-patch.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-11-multi-scalar-patch.md)

- **Hypothesis:** patching `MasterBrightness` + `AutoTargetLuminance` + `ManualAutoMix` simultaneously will lift the blackout.
- **Action:** extended `PatchAnimlibFloatValues` to rewrite three scalars. Instrumented with `SHADPS4_DC_DRAWLOG` + `SHADPS4_DC_UBOLOG`.
- **Outcome:** the patch produces a real **numeric** lift (1.2 → 6.5 in 255, a 5×), but still sub-perceptual black. And the crucial finding: the mirror works normally after the patch. It's not gated, just reflecting a dark scene. **At least 285× of additional attenuation lives downstream of the scalars we can patch.**

### Phase 12: bisect closes the asset side

> [`phase-12-bisect-closes-asset-side.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-12-bisect-closes-asset-side.md)

- **Hypothesis:** one of the 60 accumulated patches broke the mirror independently from the blackout. Bisect.
- **Action:** binary bisect across 60 overlay files over 5 rounds.
- **Outcome:** `x_live_lobby_pre_race.txt` (rerouting loading-spinner transition from `ZoomInAndFade` to `NoFade`) was the mirror killer. Rolled back. **Asset side completely closed.** The driver lives in compiled code or post-process state, not in a game asset.

### Asset sweeps 01-09 (consolidated)

> [`asset-sweep-09-conclusions.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/asset-sweep-09-conclusions.md)

In parallel with the phases above, I swept 12 RPK substitutions: `FreeplayGetInCar` page swaps, postfx edits in `india_landscape_gui.rpk`, `globaldata` RTT-only edits, prerace state-string rewrites. **All clean misses.** No asset family touches the blackout. Lesson: **stop chasing by names; chase by state transitions.**

### Phase 13: UBO dump breakthrough

> [`phase-13-ubo-dump-breakthrough.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-13-ubo-dump-breakthrough.md)

- **Hypothesis:** eye-adaptation feedback loop with stale input is the culprit. A luminance scalar growing without converging.
- **Action:** dump 128 bytes of UBO in hex during the race window across six hand-picked pipelines. Look for monotonically changing values.
- **New concept:** **UBO (Uniform Buffer Object)**, a shared memory region the CPU writes and shaders read. **Auto-exposure integrator**, a classic eye-adaptation component that takes time to converge toward a target.
- **Outcome:** found it. **UBO offset 3 climbs monotonically from 2.59 → 7.84 → 24 → 90 → 179 → 255** over 2 seconds. Textbook feedback loop with broken input. First real hit in 12 phases.

### Phase 14: scene-pipeline UBOs are the read side

> [`phase-14-scene-pipeline-ubos-wrong.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-14-scene-pipeline-ubos-wrong.md)

- **Hypothesis:** clamping the climbing scalar will stop the blackout.
- **Action:** `SHADPS4_DC_LUM_CLAMP=2.0` forces offset 3 to a fixed value during the race window.
- **Outcome:** the clamp fires 1093 times, blackout unchanged. Scene-pipeline UBOs **consume** the dim, they don't produce it. The dim is upstream, in a fullscreen tonemap or post-fx compute.

### Phases 15-16: runtime texture dump + mutation

> [`phase-15-runtime-texture-dump.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-15-runtime-texture-dump.md) · [`phase-16-runtime-texture-mutation.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-16-runtime-texture-mutation.md)

- **Hypothesis:** the blackout is a fullscreen texture composited over the scene.
- **Action:** `SHADPS4_DC_TEX_DUMP=1` dumps every bound texture during the race window (1079 textures captured). Convert tiled format to PNG for visual triage. Then, deterministically mutate each texture via hash-based tint + `InvalidateMemory` to force re-upload.
- **New concept:** **GCN tile format** (Sony interleaves bytes a specific way for cache locality), texture de-swizzle, buffer cache invalidation.
- **Outcome:** 14 rounds of mutation (BC textures, float data, render targets, UI atlases, post-fx buffers, LUTs). Blackout **unchanged across all of them**. Texture content 100% ruled out as the source.

![Blue overlay during mutation](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/blue-ish-overlay.png)

![Green overlay during mutation](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/green-ish-overlay.png)

![Reflections glitched](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/reflections-glitching-blown.png)

![Reflections blown white](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/reflections-glitched-blown-white.png)

### Phases 17-19: UBO smashing, push-constant smashing, compute dispatch probe

> [`phase-17-ubo-batch-smashing.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-17-ubo-batch-smashing.md) · [`phase-18-push-constant-smashing.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-18-push-constant-smashing.md) · [`phase-19-compute-dispatch-probe.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-19-compute-dispatch-probe.md)

- **Hypothesis:** random-fill on UBOs, push constants, and compute input buffers can bracket and isolate the dim field without crashing.
- **Action:** `SHADPS4_DC_UBO_SMASH=1`, `SHADPS4_DC_PC_SMASH=1`, `SHADPS4_DC_DISPATCH_SMASH=1` with cb-index and size filters.
- **New concept:** **push constants** (128 bytes of fast params the driver pushes straight into the pipeline, no descriptor), **compute dispatches** (fires compute shaders with a grid of threads), **ud_regs** (GCN user data registers — how shadPS4 maps user data to push constants).
- **Outcome:** safe brackets produce overlay bokeh + blinks, but the dim stays put. Wide brackets that reach the dim also hit matrices/transforms and crash. **Random-fill is the wrong instrument.** Needs diff methodology.

![Everything beige after smash](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/all-bege.png)

![Everything green](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/all-green.png)

![Everything cyan](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/all-cyan.png)

### Phase 19b-c: dim-vs-lift dispatch diff

> [`phase-19b-dim-vs-lift-diff.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-19b-dim-vs-lift-diff.md) · [`phase-19c-dispatch-draw-skip-null.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-19c-dispatch-draw-skip-null.md)

- **Hypothesis:** compute dispatches that only fire during dim (and stop once it lifts) are part of the chain.
- **Action:** split the clean log into pre / dim / bright windows (via user wall-clock), count dispatch frequency per pipeline.
- **Outcome:** identified **8 compute pipelines** (histogram 256→downsamples, tile-grid reductions, auto-exposure 1x1 scalars) that stop exactly when dim lifts. Shapes strongly suggest the eye-adaptation chain. **First genuine diagnostic hit.** Skip test on those 8 + 101 correlated draws: blackout **unchanged**. They're **downstream effects**, not drivers.

### Phase 20-21: tonemap inline, fragment → flip buffer

> [`phase-20-shader-dump-tonemap-inline.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-20-shader-dump-tonemap-inline.md) · [`phase-21-fragment-to-flip-buffer.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-21-fragment-to-flip-buffer.md)

- **Hypothesis:** the auto-exposure compute shader is broken, or the tonemap compute has the wrong math.
- **Action:** recompile all shaders, dump SPIR-V, disassemble the histogram auto-exposure. Patch its output to constant 1.0 and test.
- **New concept:** **SPIR-V disassembly** (Khronos intermediate format with readable assembly). **Compute shader verification.** Later, **pipeline-to-shader mapping**.
- **Outcome:** patch **has no effect**. Discovery: **DriveClub has no separate tonemap pass**. Scene geometry writes directly to the flip buffer, with exposure inline in material shaders. Each material shader bakes the dim scalar from a shared UBO. Pipeline cache wipe + `SHADPS4_DC_PIPEMAP=1` dumps every pipeline→shader mapping. Filtering drawlog for pipelines writing to `0x5000900000` / `0x5000108000` (the actual swapchain buffers) yields **14 unique pipelines**. None with Exp2/Log2 tonemap ops. Exposure is applied upstream.

### Phase 22: tonemap compute identified

> [`phase-22-tonemap-compute-identified.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-22-tonemap-compute-identified.md)

- **Hypothesis:** among the game's 510 compute shaders, one has a tonemap signature (many Exp2/Log2).
- **Action:** automated scan, cross-reference with dispatchlog.
- **Outcome:** **`cs_0x2c918c06`** is the strong candidate, with 8 Exp2 + 8 Log2, 5 SSBOs (scene params, TAA, bloom, camera, exposure), 11 images. Skip test on that specific pipeline: **stops the blackout cycle**, removes color grading, introduces temporal ghosting. **That's the final scene→swapchain tonemap path.**

![Temporal ghosting after skip](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/temporal-glitching.png)

### Phase 22+: tonemap patches → playable

> [`phase-22plus-tonemap-compute-patches.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-22plus-tonemap-compute-patches.md)

- **Hypothesis:** two surgical SPIR-V edits (histogram no-op + tonemap exposure clamp/boost) make the game playable.
- **Action:** histogram patch to never update; tonemap patch to clamp exposure floor at 0.5 and boost blend by ×10. Both via SPIR-V patching + `shader/patch/` drop-in.
- **Outcome:** **playable!** Dim shrinks from pitch black to mild. A **real mitigation, not a root-cause fix.** The fade curve still drags exposure, and each track needs per-threshold tuning.

![Track lights blowing out after ×10 boost](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/blown-just-track-lights.png)

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/india-gamma-correction-attempt.mp4" >}}

Here the AI suggested stopping for the first time. **"The game is playable, this is a decent mitigation, we should document and accept."** I pushed back: "it's playable but it's wrong. Don't accept. We keep going."

### Phase 23: CPU-side exposure intercept

> [`phase-23-cpu-exposure-intercept.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-23-cpu-exposure-intercept.md)

- **Hypothesis:** clamping the exposure scalar at the tonemap compute's `BindBuffers` point prevents over-dimming.
- **Action:** `SHADPS4_DC_EXPOSURE_PIN=1` intercepts `BindBuffers`, overwrites exposure offsets with a clamp-min threshold, invalidates buffer_cache.
- **New concept:** **CPU-GPU buffer binding** (the moment when the CPU hands a descriptor to the GPU). **Buffer cache invalidation** (how the emulator keeps consistency between a buffer's CPU-side and GPU-side state).
- **Outcome:** the scalar oscillates at race start, then climbs monotonically. Per-track tuning is needed. India wants 3.0, Canada blows out at the same threshold. **A single-scalar solution doesn't converge cross-track.**

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/debugging-cli-gamma-correction.mp4" >}}

### Phase 24: dim upstream of tonemap

> [`phase-24-dim-upstream-of-tonemap.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-24-dim-upstream-of-tonemap.md)

- **Conclusion:** after the whole probe chain (identity tonemap, exposure pin, compute skip), the dim **is in the HDR target before** the tonemap reads it. Three upstream suspects: (1) atmospheric scattering / volumetric fog, (2) reflection-probe / envmap update, (3) pre-tonemap exposure apply.
- **New concept:** **atmospheric scattering** (simulating how light travels through atmosphere, Rayleigh/Mie-style), **volumetric fog** (fog rendered as a froxel volume).
- **Outcome:** plan set. Frame-order dump, walk backwards from tonemap through the whole chain.

### Phase 25: frame-order trace

> [`phase-25-frameorder-trace.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-25-frameorder-trace.md)

- **Action:** `SHADPS4_DC_FRAMEORDER=<N>` logs strict per-submit pipeline/shader chain over N submits during race window.
- **New concept:** **frame-order reconstruction** (listing every GPU submission in exact order), **froxel volumetrics** (frustum volume voxels — a 3D grid aligned to the camera's frustum that stores light info).
- **Outcome:** three suspects: (A) half-res compute `(60,34,1)`, probably SSAO; (B) progressive dispatches `(256,1,1)→(2560,1,1)→(10240,1,1)`, froxel volumetric; (C) fullscreen apply-fog-to-HDR draw. **Suspect B** is the strongest fit (sunset best-fit, per-pixel non-uniform dim).

### Phase 26: The UBO fade pin, the "aha moment"

> [`phase-26-ubo-fade-pin.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-26-ubo-fade-pin.md)

This is where everything changed.

- **Hypothesis:** a direct memory diff (bright vs dim vs recovered) identifies the exact bytes the game writes to control the blackout.
- **Action:** capture periodic UBO snapshots across visual state transitions. Diff three snapshots byte by byte. Look for fade signatures.
- **New concept:** **state diff methodology**. Instead of "which pass looks suspicious?", ask "which bytes actually change with the visual state?"
- **Outcome:** **breakthrough.** Two UBOs control the fade: a 1936-byte one with slots `[38/48/50]` (light intensity) being multiplied by 0.094 (fade factor), and a 224-byte sun UBO with slot `[50]` dropping 97%. Pinning both: race start opens bright. TOD animation intact. Content-aware three-state lifecycle (idle → engaged → expired).

![First touch on the sun-light UBO](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/touching-sun-light.png)

Wednesday night. Claude suggests stopping again. **"We have the pin working, three-state lifecycle is robust, Canada + Munnar are running. This is upstream quality, we should PR and close it."** I insist: "there's still residual dim on other tracks, it's not closed. We keep going."

### Phase 28: pivot to emulator code

> [`phase-28-pivot-to-emulator-code.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-28-pivot-to-emulator-code.md)

- **Realization:** the residual dim in Canada dusk/night isn't a wrong UBO value. It's an **emulator translation gap**. The game runs correctly on a real PS4, so shadPS4 has some path that translates or synchronizes incorrectly.
- **Action:** ranked 5 candidate emulator bugs: HLE shader misidentification, image storage classification, layout transitions, IMAGE_STORE_MIP fallback, OpImageFetch LOD restriction.
- **New concept:** **HLE (High-Level Emulation)**. Replacing complex PS4 OS functions with host-side implementations. Different from LLE (low-level) which emulates bit by bit. HLE is faster but can diverge from real behavior whenever the host implementation doesn't cover every case.

![Canada dusk/night still dim](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/canada-dim.png)

### Phase 29: calibrated state + recording harness

> [`phase-29-calibrated-state.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-29-calibrated-state.md)

- **Action:** `SHADPS4_DC_RECORD=1`. Recording harness that dumps lighting UBOs periodically + cross-correlates with wall-clock screenshots.
- **Outcome:** important discovery. **Slots `[144..295]` of the 1936-byte UBO** (30+ fields) stay **denormal/uninitialized** for the first ~90 seconds of a race. At the 1:30 "auto-recalibration", the game writes the real values. **It's not magic recovery, it's the CPU finally writing values that should have been there since frame 1.** On PS4 they're ready before the first frame; on shadPS4 they're delayed by 90s. **Root cause lives in an emulator init gap.**

### Phase 30: UBO writer audit

> [`phase-30-ubo-writer-audit.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-30-ubo-writer-audit.md)

- **Action:** exhaustive audit of every path that writes into slot `[38]` of the 1936-byte UBO. 7 suspects ranked: (1) ObtainBuffer stream-copy race, (2) lazy RegionManager in memory_tracker, (3) histogram compute skip, (4) page-fault delayed invalidation, (5) readback gating, (6) buffer-coherency race, (7) push-constant.
- **Status:** audit incomplete. Before I could verify each suspect, Phase 31 short-circuited the whole thing.

### Phase 31: readbacks_mode = Precise, the turning point

> [`phase-31-readbacks-mode-fix.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-31-readbacks-mode-fix.md)

Thursday morning. Tired, thinking about suspect **#5, readback gating**. That one itched at me because it was the only one of the 7 writers that touched the *timing* of the read rather than the *correctness* of the write.

- **Hypothesis:** flipping `readbacks_mode: 2 (Precise)` in per-game config makes the feedback loop work by synchronizing the CPU's read to fresh GPU output.
- **Action:** one edit in `custom_configs/CUSA00003.json`. Boot. Canada night.
- **Outcome:** **race start opens bright. Auto-exposure converges normally. Zero blackout. Zero 1:30 recalibration. Night TOD natural.**

![Almost there, the test before the final one](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/almost-fixed.png)

Tested on Munnar. Same result. One integer. **31 phases. 44 commits. 15,668 lines. Answer: one integer in the config.**

Why did this slip past 30 phases? The Phase 31 doc has the honest analysis:

1. **Symptom disguise.** Progressive darkening looks exactly like a broken tonemap, bad shader, or miscompiled exposure scalar. Every dump-driven probe found **wrong values in the UBO**, which is true but describes the downstream read, not the upstream gap.
2. **`readback_linear_images` red herring.** I tested that flag in Phase 29, saw no effect, and concluded "the readback surface is audited". I forgot that flag is for *image* readbacks (linear images via `TextureCache::DownloadImageMemory`). The histogram SSBO is a **buffer**, a separate path.
3. **Pinning making it worse, not better.** Overwriting slots [38/48/50] looked promising but never converged. The game rewrote on top of the pin every frame. I interpreted that as "the pin mechanism lands too late in the pipeline". I spent phases 27-29 moving the pin earlier. The real fix was to **stop clobbering the GPU-side input the integrator reads**.
4. **Never audited the buffer readback path.** The Phase 30 audit listed 7 writer candidates, but all of them were about the correctness of the *write*. None asked "what is the CPU reading, expecting the GPU to have filled?"

## The shotgun technique

One thing I want to put on record: **torture probes aren't waste, they're learning infrastructure.** And the methodology behind them has a name: shotgun.

{{< youtube id="HkxVhFg81fs" start="40" >}}

If you have a suspicion (say, "the dim comes from some texture"), the worst thing you can do is start investigating one texture at a time, in depth. DriveClub has 1079 bound textures during the race window. If a detailed triage on one texture takes 20 minutes, you spend three days on a single branch of that tree and still don't know if the dim even comes from a texture. It might not be in the whole tree.

Shotgun fixes that. Instead of investigating one at a time, you fire at all of them simultaneously. Mutate every bound texture with a hash-based tint, force re-upload, run the game. In 30 seconds you know whether any of them affects the dim. If it does, the dim is texture-side and only then is it worth starting to narrow down. If nothing changes, congratulations: you just ruled out the entire "texture" category in 30 seconds. Switch categories, shotgun UBOs. No hit? Shotgun push constants. No hit? Shotgun compute dispatches. Keep going until something reacts.

**Don't start by narrowing down a tree that might be huge.** You'll spend weeks in irrelevant leaves. Shotgun the trunk first. See which branch reacts. Then go deep inside that branch.

That's what I did, without knowing I was doing it, for the first 30 phases. 32 probe env vars (`SHADPS4_DC_UBO_SMASH`, `SHADPS4_DC_PC_SMASH`, `SHADPS4_DC_DISPATCH_SMASH`, `SHADPS4_DC_TEX_NUKE_*`, `SHADPS4_DC_UBO_NUKE`, and more). Random batches, hash-based tints, null substitutions. Most of them never pointed at the real fix. But every shotgun round ruled out an entire category of mental model. "Not texture." "Not push-constant." "Not those 8 compute pipelines." "Not the UBO write side anywhere in that region." Every ruling-out narrows the problem.

**And while I was doing it, I was learning the system.** Every smash that crashed told me "there's a critical descriptor pointer here". Every color tint that appeared told me "this UBO feeds that composition pass". Every dispatch that fired differently between dim/bright showed me where the interesting boundary lives.

**When you don't know the system, shotgun probes are a map.** You don't use them to find the answer. You use them to learn the terrain.

## What I knew on Sunday vs Thursday

**Sunday:** zero everything. All the areas below were black boxes to me.

**Thursday:**

- PS4 package format end-to-end (PKG → PFS → param.sfo → disc_info → keystone → npbind). How v1.28 cumulative patches layer on top of a v1.00 base install.
- shadPS4 architecture in outline: `src/common`, `src/core` (OS emulation, HLE libraries), `src/shader_recompiler` (GCN→SPIR-V), `src/video_core` (Vulkan renderer, buffer cache, texture cache, page manager).
- Full graphics pipeline: G-buffer → forward+ lighting (writes MSAA depth) → read depth as color for SSAO / volumetric froxel → post-fx compute → tonemap → composite → swapchain.
- UBO vs push constant vs descriptor set. When to use each.
- SPIR-V disassembly and re-assembly for surgical patching. How to identify a tonemap compute by its Exp2/Log2 signature.
- Forward+ lighting + MSAA depth resolve + how to implement ReinterpretMsDepthAsColor.
- shadPS4 buffer cache: `MemoryTracker`, `RegionManager`, `FaultManager`. How page faults turn into GPU→CPU sync.
- `readbacks_mode`: Disabled / Relaxed / Precise. What each tradeoff looks like. Why Relaxed isn't enough for feedback loops (it only write-protects, not read-protects).
- PS4 OELF → Itanium RTTI → SCE relocation → dynamic linker reasoning, even without actually doing the binary patch (the plan is documented).

I didn't become an expert in any of it. But I went from **total outsider** to **reasonably oriented operator**. And that jump, as I'll argue below, was the single most valuable thing of the four days.

## The AI suggested accepting. The perseverance was mine

I've said a few times in this article that "Claude suggested stopping". I want to be fair and specific: it wasn't an AI failure. It was exactly the correct behavior of an intelligent tool: **when you have something that works reasonably well, stopping and documenting is frequently the right call.** The Phase 22+ tonemap patch made the game playable. The Phase 26 UBO pin made the image pretty. The Phase 29 recording harness covered the critical window. All were legitimate stopping points.

If you read [`codex-conclusion.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/codex-conclusion.md), the document the AI produced after Phase 26 (still not knowing about Phase 31 yet), it describes the then-current solution as "**a mitigation, not a root-cause fix**". It honestly admits what we knew: the UBO pin was a countermeasure, not an explanation. That's good behavior.

The difference is that **I had a stubborn hunch that something was still wrong**. It worked in the playable sense. But the cost (DriveClub-specific pin + tonemap SPIR-V patch + per-track threshold tuning + doesn't generalize) was too high for a supposedly engineering-quality fix. A senior professional recognizes when the asymmetry between cost and understanding points to something deeper. You don't always get it right. But that hunch deserves to be heard.

Four days without interruption, 8 a.m. to midnight, Sunday, Monday, Tuesday, Wednesday, resolved Thursday morning. How many times did the AI suggest "honestly, we should just accept the current result and document"? Four or five. Each technically defensible. **Human perseverance is the difference between "the game works well enough" and "the game works, and I know why".**

## The real cost of this journey

[`investigation-effort-accounting.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/investigation-effort-accounting.md) catalogs everything before cleanup. Some highlights:

- **3 days** of active work (Apr 21-23, 2026).
- **33 numbered phases** + sweeps + side threads = 54 docs, 412 KB, **6,867 lines of prose**.
- **44 commits** on the gamma-debug fork. **15,668 lines added**, 1,204 removed.
- `src/video_core/renderer_vulkan/vk_rasterizer.cpp` grew from 1,364 to **4,680 lines** (3.4×) with instrumentation, pin lifecycles, recording harness.
- **32 probe env vars** defined. **1 effectively used to find the bug** (`SHADPS4_DC_LOG_STREAMCOPY`, in Phase 30).
- **61 MB** of shadPS4 log accumulated. **57 MB** of shader dumps (5,803 files). ~**470 MB** of total reclaimable artifacts once closed.

Resolution: **1 integer in the config.**

The ratio of **6,867 lines of prose : 1 integer** amuses me. But it isn't a joke about inefficiency. It's the real cost of learning a system you didn't know. Every line of prose ruled out a hypothesis. Every commit taught a layer of the stack. The integer was the end; the path was the product.

An honest note: despite the 15,668 lines added on the `gamma-debug` fork, **almost none of it is useful to contribute upstream to shadPS4**. What's there is instrumentation: torture probes, recording harness, pin lifecycles, calibrate-at-arm, UBO snapshots, dozens of debug env vars. Diagnostic code, not production code. Diagnostics that only make sense for DriveClub under those specific conditions.

The fork is going to stay public, but **not as a contribution branch to the shadPS4 project**. Unfortunately. It stays as a study document: 54 md files covering the full process, 44 commits showing the sequence of hypotheses, rule-outs and failures. It's material for anyone who wants to understand how the debugging process unfolded, or to reuse some of the techniques in similar investigations. No upstream-ready PR is coming out of that tree.

## Closing

Yes, the final solution was a config toggle that already existed. It's been in shadPS4's code for seven months. But on Sunday night, with zero PS4 knowledge, zero emulator knowledge, zero notion that auto-exposure was a GPU→CPU feedback loop, **I had no technical authority to say "flip readbacks Precise, done"**.

I had to see the whole chain to understand *why* it works. Why Relaxed isn't enough (it only write-protects, and DriveClub reads, it doesn't write into the histogram SSBO). Why Precise is expensive (per-page mprotect + per-fault GPU stall). Why the maintainer hid it behind "Advanced" (Bloodborne hangs, AMD tanks to 12 FPS). Why nobody in the community had connected Precise to DriveClub before: the compat tracker admits "readbacks enabled" but doesn't cite the mode, and nobody had seen the monotonic-drift signature through the GPU→CPU lens.

That's the difference between **knowing the answer** and **knowing the terrain well enough to recognize the answer**. To the junior asking me "how do I learn today, in the AI era": that's my answer. Don't ask. Dive in. Use AI to speed up the search, to read code in parallel, to index old forums, to compile, to parse logs. But **insist on understanding the why**. When the AI suggests "let's accept and document" (and it will, because that's often the right behavior), ask yourself whether you actually understood the chain. If the itch "this is wrong but I don't know why" is still there, keep going.

You're probably going to spend four days on something that has a one-integer solution. You're probably going to discover five wrong paths before the right one. Probably half your probes will be torture shotguns that never pointed at the fix.

And you'll probably, when you finish, know a domain you didn't know before.

- **Fork gamma-debug:** [github.com/akitaonrails/shadPS4/tree/gamma-debug](https://github.com/akitaonrails/shadPS4/tree/gamma-debug)
- **54 investigation docs:** [docs/driveclub-investigation/](https://github.com/akitaonrails/shadPS4/tree/gamma-debug/docs/driveclub-investigation)
- **Operational runbook (recipe):** [distrobox-gaming/docs/driveclub-shadps4.md](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md)
- **Phase 31 resolution:** [`readbacks_mode: 2`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-31-readbacks-mode-fix.md)

Now I'm going to go play DriveClub. Night race in Canada, natural brightness, no blackout. Good Thursday.
