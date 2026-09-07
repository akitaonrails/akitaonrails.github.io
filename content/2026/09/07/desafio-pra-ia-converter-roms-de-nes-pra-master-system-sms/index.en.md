---
title: "AI Challenge: Converting NES ROMs to the Master System/SMS"
slug: "ai-challenge-converting-nes-roms-to-master-system-sms"
date: '2026-09-07T14:00:00-03:00'
draft: false
translationKey: desafio-ia-converter-nes-master-system
description: "I tried using frontier LLMs to convert NES ROMs into Master System games. I explain the architecture, why translating 6502 to Z80 runs slow, the emulator as a feedback oracle, and where the mappers stall everything."
tags:
- retrocomputing
- coding-agents
- gaming
- emulation
---

For many years I had a fixed idea in my head, and I always thought it wasn't practical: converting NES games to run on the Master System.

Let me be precise. I always knew it could be done. Two Turing-complete machines can, in theory, run each other's code. You can always translate a program from one architecture to another. The problem was never possibility, it was cost. The NES runs a 6502, the Master System runs a Z80, and over the years I read in several places that a direct 6502-to-Z80 translation always ended up running much slower, because of the architecture and hardware differences. Slow enough to never pay off in practice.

And that memory has a basis. If you dig into retro-dev forums, like [NESdev](https://forums.nesdev.org/viewtopic.php?t=17339), the consensus is that translating instruction by instruction is exactly the worst path: "each instruction in the source code becomes multiple instructions of object code, and the resulting program runs much slower and takes much more memory." It's not just the CPU. The 6502 has the zero page, a dirt-cheap addressing mode the Z80 has no equivalent for, so you trade a cheap access for an expensive sequence with `IX`/`IY`. And the graphics part is even worse: the NES PPU and the Master System VDP are different beasts, with scroll, sprites, and screen mirroring that don't fit into each other without expensive workarounds.

In other words, everyone who ever thought about this reached the same conclusion: it can be done, but it runs too badly to be worth it.

Except now we have frontier LLMs. And I got curious: could a brute-force approach, with a good LLM in the middle of the process, get a better result than the usual naive translation? I started the [nes-to-sms](https://github.com/akitaonrails/nes-to-sms) project in late May, about three months ago, to find out.

The first result was exactly what the theory predicted: bad. A more or less direct translation generated code that runs, but way too slow. I managed to convert the entire Super Mario Bros, with sprites, levels, everything, but to make it minimally playable I had to run the Mednafen emulator at 500% overclock. After banging my head against Claude, GPT, and other models for a while, I got stuck. I worked hard through June and July, and in August I paused the project to let the dust settle.

## Why the Master System, and not the NES?

Before explaining the technical part, I need to explain the obsession, because it is the reason for everything.

I always thought the Master System was a superior console to the NES. Better CPU, better video chip, a much richer color palette. The NES works with 4 colors per background tile and 3 per sprite. The Master System works with 16-color palettes. That is a huge difference in practice.

The problem is that Nintendo had a brutal monopoly back then and would not let third parties release for other consoles. Anyone who wanted to make a game for the NES signed an exclusivity contract. The result is that the Master System, technically better, ended up starved of games. Basically only Sega itself released for it, and Sega's library never had the weight of a Castlevania, a Mega Man, a Final Fantasy.

Imagine what we lost. We could have had those same NES classics, but with the Master System's superior capability underneath. A Castlevania with more color, better sprites, better sound. We never had that, and it is exactly this historical frustration that made me want to convert NES to SMS in the first place.

## The port that proved the thesis

While my project was paused, another developer, [lackoftrack27](https://github.com/lackoftrack27/Super-Mario-Bros.-SMS), published a Super Mario Bros port for the Master System that is on another level. It runs at full speed, 60fps, and on top of that with improved sprite art that takes advantage of the console's superior palette. It ended up looking more like the Super Mario All-Stars remaster from the Super Nintendo than the somewhat crude original NES version. The retro community was in awe.

{{< youtube id="igOu1NQL5Ww" >}}

That proved my thesis in practice: the Master System is capable of running superior versions of NES games. It always was.

Now, two honest points about this port, because they matter for the rest of the story.

First: lackoftrack27's work is a hand reimplementation, built from the game's disassembly, optimized specifically for Super Mario. It's not a general-purpose automatic translation like the one I'm trying to do. He solved one game, beautifully, by hand. Curiously, that reinforces what the forums already said: the path that works is reimplementing by hand, not machine-translating.

Second: as impressive as it is to see Super Mario on the Master System, it's worth remembering it is still a first-generation game, around 40kb. Meaning it is one of the simpler games on the NES. Later-generation stuff, like Super Mario Bros 3 or Kirby, nobody has tried to convert yet, and for good reasons I explain further down.

But the most important thing was the side effect: with the map his port gave me, I finally got my automatic conversion running properly. I came back to the project in early September, loaded lackoftrack27's code into Claude Fable and then the new GPT Astra, and put both of them to study what he did that I wasn't doing.

## The architecture of the solution

Since this article is for programmers, let me open the black box.

The first important decision is that `nes-to-sms` is not an emulator, nor a text-to-text translator of 6502 to Z80. It is a **static recompiler**. It reads the NES ROM, lifts the 6502 code into an intermediate representation with explicit semantics, and from that IR it generates Z80 code. The output is a WLA-DX assembly project that compiles into a real `.sms` ROM. The core is a Rust workspace with thirteen crates, plus a hand-written Z80 runtime shared across games.

The flow, end to end, goes roughly like this:

1. Parse the ROM header, split the code banks (PRG) from the tile banks (CHR), and read the reset and interrupt vectors.
2. Load a per-game profile (a TOML with labels, data regions, jump tables, mapper type, and replacements).
3. Discover the functions, build the control-flow graph, and classify every byte as code or data. A key detail enters here: every memory access is tagged with the region it belongs to (zero page, stack, RAM, PPU registers, sprite DMA, sound, mapper).
4. Lift each routine into IR, with the 6502 flags explicit. A write to the PPU register `$2006` doesn't become just some `mem[]=`, it becomes a first-class "PPU write" primitive.
5. Lower the IR to Z80. The 6502 flags are kept in a shadow status byte in RAM, and every hardware access becomes a call into the runtime.
6. Emit the Z80 bytes and also the readable WLA-DX assembly.
7. Convert the assets: the NES 2bpp tiles become SMS mode-4 4bpp tiles, the NES palette becomes SMS CRAM, and so on.
8. Write the whole SMS project, with a Makefile, runtime, and data, ready to compile.

The CPU mapping is conservative on purpose. The 6502 accumulator `A` becomes the Z80 `A`, the `X` and `Y` registers live in RAM or registers, the zero page becomes a fixed block in SMS RAM, and every operation that touches a flag calls a helper. It's safe and correct, but this is exactly where the cost lives.

## Where NES and SMS really diverge

The project's central finding is about speed, and it's counterintuitive.

The NES 6502 runs at 1.79 MHz. The Master System Z80 runs at 3.58 MHz, double the clock. You look at that and think "so there's plenty of headroom." Except no. The Z80 spends on average about 13 cycles per instruction, while the 6502 spends about 4. In real numbers, a 3.5 MHz Z80 is roughly equivalent to a 1 MHz 6502 for general work. Meaning the SMS Z80 is actually **slower** than the NES 6502 for the same work. The headroom is negative.

Worse: the cheapest 6502 idiom, an `LDA table,X`, is one of the most expensive to emulate on the Z80. So a faithful translation of a game that already squeezed the NES to the limit simply cannot hit 60fps without overclock. The blame is on the physics of the problem, not on my translator.

And the video is another story. The NES sees video memory in a mapped way, with nametables, hardware scroll, and a sprite table accessed via DMA. The SMS Z80 does not address VRAM as memory: it sets an address latch and streams bytes through VDP ports. So every NES PPU write has to be captured, queued in a buffer, and flushed to the VDP during vblank. The NES flips a sprite for free, just by setting an attribute bit. The Master System has no hardware sprite flipping, so the program has to mirror the tile data in VRAM by hand, burning memory. The mid-frame screen split that NES games do, changing the scroll each scanline, also has no direct equivalent, because the VDP latches the vertical scroll at the top of the frame.

And there's still the VRAM ceiling. Super Mario's 8 KB of tiles become 16 KB in the SMS 4bpp format, which is the console's entire VRAM. Background and sprites can't both stay resident at once. And the code balloons 3 to 6 times in size, which is why the SMS output is already banked from the very first game, even the simplest ones.

## Leveraging what the SMS does best

The trick to recover speed is to stop emulating NES behavior and start spending the Master System's strengths. The project's motto became "spend ROM to buy CPU."

The SMS accepts cartridges of several megabytes. So instead of mirroring a sprite by hand at runtime, the build already generates pre-flipped variants of each sprite tile, and the flip becomes a table lookup. Instead of emulating the NES attribute table, the assembler already writes the final SMS nametable word, with the flip, palette, and priority bits baked in. The NES attribute table simply stops existing in the program. The copies to the VDP use unrolled `OUTI` blocks, faster than the generic loop. And the status-bar split, which on the NES depends on sprite-zero, becomes an SMS line interrupt, which is the native way to do it.

None of this is magic. The negative CPU headroom is still there, so these optimizations reduce the cost but don't work miracles on their own. But it's the difference between unplayable and playable.

## The real trick: making the AI run the emulator

Here's the part I consider the most important of the whole project, and it's what separated the failed attempt from May from the version that finally moves.

Blind translation doesn't work. The model needs real feedback to know what's broken and what's slow. So the heart of the project is the **differential oracle**, the infrastructure that runs the emulators and measures reality. The translator is just the easy part.

It works in two layers. The first compares instruction by instruction: for each routine, the system generates random initial states, runs the original 6502 in a reference interpreter and runs the generated Z80, and compares the result (accumulator, registers, flags, touched RAM). Any divergence raises a flag. The second layer compares frame by frame: it runs the NES ROM as absolute ground truth and the SMS build side by side, with the same button script, and compares RAM byte by byte on every frame. That was later extended with an oracle that checks the SMS VRAM and palette, and with a visual oracle that compares the output against the real NES frame.

This measurement loop is what unlocked the recent fixes. It wasn't guesswork. Two concrete examples:

In Super Mario, every optimization step was measured in cycles per frame, with the emulator actually running. A frame's budget is 59,736 cycles. The baseline sat at around 370 thousand cycles per frame, something like 6 times over budget, which gave about 10fps and explained the need for that brutal 500% overclock. Measuring step by step, each change validated by the oracle, it dropped to 118,296 cycles per frame, or 1.98 times the budget. It went from 6 times to under 2 times. It now runs at full speed already in the emulator's standard overclock, and it's comfortable in the 200 to 300% range, versus the 500 to 700% from the start.

In Castlevania, the biggest speed win came from a profile only the emulator could reveal: a sprite-zero wait loop, at address `$F8C7`, was doing 255 status reads and exiting by timeout every single time, consuming almost 23% of the entire CPU. Without running the emulator and measuring, nobody would find this by eye. With the measurement, the fix was surgical.

This is the bigger argument I've been hammering for a while about agents: an LLM that only generates code in the dark makes big mistakes. An LLM that can actually run the target, collect real data, and react to what it measured plays in another league.

## What I learned studying lackoftrack27's port

With that oracle in place, I put Claude Fable and GPT Astra to dissect lackoftrack27's port, which is a reimplementation of the same game from the same disassembly I translate. That settled once and for all a doubt that was blocking me: Super Mario fits on the Master System. My 6-times overrun on the budget was 100% translation overhead, not a limitation of the game or the hardware.

His wins, in order of impact, were roughly these:

- **The biggest of all: the data representation.** He reorganized the game's object arrays into RAM pages, one per slot, with the same field offsets. Then the 6502's `X` becomes the register `H` and the field name becomes `L`, and an access that cost about 70 time units in my translator now costs 14. The cruel detail is that this only works because the programmer knows, from memory, that this particular `X` is always an object index between 0 and 6. A static translator has no way to safely discover that invariant. This is the most powerful optimization, and it's precisely the one automatic translation can't prove on its own. It's the residual that holds back the last 2 times in speed.
- **Flags audited, not emulated.** He checked the code and found only about 10 places that genuinely depend on some 6502 carry quirk. The rest uses the Z80's native flags. That confirmed a measurement of mine: spending energy emulating flags yields almost nothing.
- **Native calls.** `JSR` becoming a real `CALL`, without the expensive emulated-stack bookkeeping. That was the biggest generic win I ported over to my pipeline.
- **PPU deleted at build time**, not emulated at runtime, exactly as I described in the section on leveraging the SMS.
- **Frame architected to overrun gracefully**, turning an overrun into a clean lag frame instead of corrupting the screen.

I adopted what could be generalized, and Super Mario dropped from 6 times to under 2 times the budget. This is the result running today:

<div class="embed-container">
  <video controls preload="metadata" playsinline style="position:absolute;top:0;left:0;width:100%;height:100%;border:0;background:#000;">
    <source src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260907152243_smb-sms-conversion.mp4" type="video/mp4">
  </video>
</div>

The most honest lesson from this study is twofold. The real wins are in the data representation and the calling convention, not in what I had attacked first. And the deepest win of all is exactly what the automatic translator can't infer. That draws the ceiling of what can be automated pretty clearly.

## Castlevania and the mapper problem

With Super Mario moving, I went back to my old target: the first Castlevania. And here we hit the NES's most serious limitation.

The NES is a simple console, with a bunch of limits. One of the main ones is that it doesn't support games bigger than about 40kb of ROM, because the 6502 only sees a 32 KB window of program in its address space. The "solution" from back then was brilliant and a bit crazy: parts of the console were being upgraded by the cartridge itself.

Many people think a cartridge is just a ROM chip with the game code. In the NES case, it's not. The cartridges came with a variety of extra chips that increased the console's capability, be it a better sound chip or, much more commonly, the **mappers**. There are several different mappers, from Nintendo itself and from third parties like Capcom and Konami. They use a technique called **bank switching**: since the 6502 can't see enough address space, the mapper swaps which pieces of ROM are visible in that 32 KB window, as the game asks. That's how big games fit into a console that, on paper, couldn't handle them.

I already explained this in detail in an old video from my channel, [Akitando #81, about learning computing with Super Mario the hardcore way](/2020/06/18/akitando-81-aprendendo-sobre-computadores-com-super-mario-do-jeito-hardcore/):

{{< youtube id="hYJ3dvHjeOE" >}}

Castlevania uses one of the earlier mappers, the UxROM. And here is the scale problem of my project: if I want to be able to translate the majority of NES games, I have to map every mapper, one by one. Today the project implements only two: the NROM, which is Super Mario's bare cartridge, and Castlevania's UxROM. All the others, the MMC1, MMC3, and company, are only planned. Each mapper is quite a bit of work to implement, because it's not enough to understand the NES bank switching, you have to translate that behavior into the Master System's own mapper.

The good news is that the Master System is also a banked system, so the mapping is "the same shape one level up." A NES PRG bank becomes a set of SMS banks, a NES bank-switch write becomes a write to the SMS mapper through a shim, and a call that crosses banks uses the "gate" machinery that already exists. A routine's identity becomes the pair (bank, address), and a dispatch table resolves that at runtime. When it doesn't find it, it fails closed, with a trap, instead of running garbage.

This is where bigger games will hit the wall. The tile bank switching of the more advanced mappers, the scanline interrupt timing of the MMC3 and MMC5, and the SMS's own bank ceiling for a really big NES game, all of that is still unsolved. That's why I still can't say whether a Super Mario Bros 3 is viable or not. It's quite possible the bigger games die exactly at this step.

Either way, I worked a good bit more on Castlevania in this comeback. I fixed a pile of things using the oracle: the sprite-zero loop that ate CPU, the weapon and projectile logic that lost call returns, a scroll glitch in the status bar, the VRAM collision between 8x16 and 8x8 sprites, and the coherence between background, palette, HUD, and sprites. Today Castlevania boots, accepts start, draws a recognizable first stage, responds to the controller, and runs for a good while without crashing. But it's honest to say it still runs slowly, and the path I use to play it is Mednafen at 500% overclock, and even then it's still 2 to 3 times below its own speed target. It's far from pixel-perfect and real-time.

<div class="embed-container">
  <video controls preload="metadata" playsinline style="position:absolute;top:0;left:0;width:100%;height:100%;border:0;background:#000;">
    <source src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260907152243_castlevania-sms-conversion.mp4" type="video/mp4">
  </video>
</div>

## Conclusion

After so many weeks and so many attempts, I still don't know how much more can be squeezed out of an automatic translation. The ceiling might be close, because the deepest optimizations are precisely the ones a machine can't infer on its own.

But there's a path that excites me. The automatic translation can become a baseline. An SMS conversion that already runs, correct, even if slow, and that can later be optimized by hand, game by game, exactly like lackoftrack27 did with Super Mario and like so many people have been doing with decompilations and ports out there. The oracle guarantees the base is correct, and the human hand steps in to do what the machine can't.

Porting a game to much better hardware, like a PC port, is relatively easy, because there's capacity to spare. The truly hard part is fitting the game into a same-generation console, where nothing is to spare. And it's exactly that difficulty that makes the idea of making better versions of NES games for the Master System so appealing. It's the console that deserved to have had those games, and never did.

I hope more people get excited about this possibility and contribute to the project. It's all open at [nes-to-sms](https://github.com/akitaonrails/nes-to-sms). If you enjoy 6502, Z80, VDP, and the challenge of squeezing cycles out of 40-year-old hardware, come by. There's plenty of room.
