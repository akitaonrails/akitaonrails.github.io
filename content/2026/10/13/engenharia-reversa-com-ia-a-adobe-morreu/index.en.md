---
title: "AI Reverse Engineering: Is Adobe Dead?"
slug: "ai-reverse-engineering-is-adobe-dead"
date: '2026-10-13T00:00:00-03:00'
draft: false
translationKey: engenharia-reversa-com-ia-a-adobe-morreu
description: "In the same week, a dev dropped seven Adobe clones built with Claude, REA passed 100K stars promising to 'reverse engineer anything', and retro gaming got a new port every day. The viral conclusion: no binary is sacred, Adobe is dead, programmers are dead. I explain what each of these things actually does: PhotoCraft is an alpha with 800 open issues, REA is a toolbox that requires the binary and Ghidra, and retro moves fast because an 8 MB ROM turns into 135K lines of C. Rewriting Bun cost US$ 165K with the author and 64 agents; Photoshop doesn't even have an open binary in the parts that matter. Reverse engineering got easier. Magic still doesn't exist."
tags:
- artificial-intelligence
- vibe-coding
- retrocomputing
- open-source
---

PhotoCraft exists. REA exists. Recomps and decomps of old games ship every day. Therefore: Adobe is dead, no binary is sacred, and programmers are finished.

That was the week on X, and if you only read headlines, it's a reasonable conclusion. This text is for anyone who wants to know what each of those things actually does.

It blew up on the 9th, when the account below summed up what Brandon Thomas, a developer from Atlanta, had been publishing since late September: seven open source clones of Adobe's main products, written in Rust with help from Claude Opus 5.5. Photoshop, Illustrator, Premiere, Lightroom, After Effects, InDesign, Acrobat. All free, all "clean room", without a single line of Adobe code. This is the post that went viral:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">AI is now being used to recreate Adobe's software, a developer has released seven free, open-source apps as clean-room alternatives to Adobe's main tools:<br><br>- PhotoCraft → Photoshop<br>- VectorCraft → Illustrator<br>- FilmCraft → Premiere Pro<br>- LightCraft → Lightroom<br>- EffectCraft → After Effects<br>- DesignCraft → InDesign<br>- PrintCraft → Acrobat Pro<br><br>Built in Rust with help from Claude Opus 5.5, they run on Windows, Linux, and macOS under MIT/Apache licenses without using Adobe's source code.</p>&mdash; Pirat_Nation (@Pirat_Nation) <a href="https://twitter.com/Pirat_Nation/status/2108437553615425881">October 9, 2026</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The same week, [REA](https://github.com/morluto/rea), "Reverse Engineer Anything", passed 100K stars on GitHub, gaining tens of thousands a day. The pitch on its page: "see a feature in an app that you want in your own product? Ask your agent to investigate it with REA and build a version for your project".

And anyone who follows retro gaming knows 2026 is the year that keeps on giving. There's a [community spreadsheet](https://docs.google.com/spreadsheets/d/1MT_xMPlKNbyhANRUMzOH94J3ybeF0b1Ws8F0kb-_598/edit) trying to list the unofficial PC ports, around 100 games from Ship of Harkinian to Skate 3, and it's always behind. The [Video Game Esoterica](https://www.youtube.com/@VideoGameEsoterica) channel publishes a new port almost daily: Time Crisis decompiled from the arcade board, Daytona USA, Bloodborne.

The Xbox One version of [Forza Horizon 2](https://almost-there-games.itch.io/azimuth), stuck there since 2014, runs on Windows. [AnyPS5](https://github.com/boykopovar/AnyPS5) promises to convert PS5 executables into native PC binaries, and PS5 emulators like KytyPS5 and SharpEmu already [run Astro Bot](https://www.invenglobal.com/articles/26860/astro-bot-boots-on-pc-as-ps5-emulation-makes-rapid-progress) with actual gameplay. Much of it with AI in the loop, some of it openly vibe-coded.

Hence the consensus: programming, in general, is over. Every binary is reversible and reusable, just point the agent at it. My position is that it did get much easier, that it's still nowhere near the silver bullet people imagine, and that the engine behind it, the LLM, [stopped growing exponentially](/en/2026/10/12/llms-agents-competent-enough/). The rest of the text is the reasons.

> **TL;DR:** reverse engineering is a 40-year-old discipline with mature tooling, and AI sped up its grunt work, especially in retro, where the binary is available, tiny, and the target doesn't move. The Adobe clones are alphas with hundreds of open bugs and pretty screenshots. REA is a toolbox that requires the binary in hand, Ghidra or IDA installed, and a lot of tokens. What's worth money today doesn't even have a binary: it's SaaS, cloud, manufacturer partnerships and decades of color science. Rewriting Bun, with the project's author and 64 agents, cost US$ 165K. Jump to the [timeline](#reverse-engineering-wasnt-born-last-week), to [REA](#what-rea-actually-does), to the [Adobe clones](#photocraft-pretty-screenshot-alpha-inside), to the [Bun case](#the-bun-case-what-it-costs-to-rewrite-big-software), to why [retro moves fast](#why-retro-moves-so-fast) or to the [answers at the end](#answering-the-list-from-the-top).

## First of all: I don't like Adobe

To be clear about where I'm speaking from. I hate Adobe's business practices as much as anyone. I was a paying customer for years, used Photoshop and Premiere extensively, plus Lightroom and After Effects, and left for the same reasons everybody leaves: mandatory subscription, cancellation fees, prices going up with nothing in return.

And it's precisely because I used them in depth that I know the size of what's inside those boxes. Whoever thinks Photoshop is layers, crop and text never needed a color proof for a print shop, never opened a camera RAW whose color profile Adobe has maintained for twenty years, never did the conform on cinema footage, the work of gathering the camera's raw material for finishing. I'll get there, after the basics.

## Reverse engineering wasn't born last week

Every emulator you've ever used exists because someone opened up hardware, disassembled a binary, sniffed a protocol and, in some cases, broke cryptography. The discipline has case law, commercial tooling and decades of history. A condensed timeline, with the milestones that matter most:

- **1982 to 1984**: Compaq reverse engineers the IBM PC BIOS, and in 1984 Phoenix sells a licensable BIOS built in a clean room, by a team that only read the specification. The PC compatible industry is born. [Source](https://en.wikipedia.org/wiki/Phoenix_Technologies).
- **1992**: Andrew Tridgell creates Samba by sniffing SMB packets. The same year, [Sega v. Accolade](https://www.copyright.gov/fair-use/summaries/segaenters-accolade-9thcir1992.pdf) and [Atari v. Nintendo](https://www.copyright.gov/fair-use/summaries/atari-nintendo-fedcir1992.pdf) establish in the US that disassembling code to reach functional elements is fair use (Atari lost its own case for another reason: it lied to the Copyright Office to get the source).
- **1993**: Wine begins, which becomes the foundation of Proton and of every Windows game that runs on the Steam Deck today.
- **1999**: UltraHLE runs commercial N64 games at full speed; bleem! emulates the PS1, Sony sues and loses the injunctions, and bleem! folds anyway in 2001; DeCSS breaks DVD protection.
- **2000**: [Sony v. Connectix](https://law.resource.org/pub/us/case/reporter/F3/203/203.F3d.596.99-15852.html) rules that copying the PS1 BIOS to build an emulator is fair use.
- **2002 and 2003**: PCSX2 and Dolphin are born, the two emulators that twenty years later are still the reference.
- **2007**: the iPhone is opened eleven days after launch. The European Commission forces Microsoft to document its network protocols, and the [Samba team receives the documentation](https://fsfe.org/news/2007/news-20071220-01.html) for 10,000 euros.
- **2010**: the fail0verflow group shows at 27C3 that Sony signed the PS3 firmware with a fixed nonce, exposing the private key (the nonce is the number that should be random in every signature). Days later, already in 2011, geohot publishes the key, Sony sues and settles in March.
- **2011 and 2013**: RPCS3 (PS3) and Xenia (Xbox 360) are born, the two hardest emulators ever built, for reasons I'll explain.
- **2019**: the NSA releases [Ghidra](https://github.com/NationalSecurityAgency/ghidra) as open source. The Super Mario 64 decompilation leaks and goes public, and the PC port appears the following year.
- **2021 and 2022**: Ocarina of Time 100% decompiled after almost two years of work; Ship of Harkinian becomes the reference port.
- **2024**: Mr-Wiseguy releases [Zelda 64: Recompiled](https://github.com/Zelda64Recomp/Zelda64Recomp/releases), the first showcase of N64 static recompilation.
- **2025**: Sonic Unleashed Recompiled brings the same trick to the Xbox 360, converting PowerPC to C++ and shaders to HLSL.

Notice that the current phase, decomp and recomp at scale, starts in 2019, well before any coding agent. AI joined an assembly line that already existed.

### The tools

The tooling is mature too, and much of it is free:

- [IDA Pro](https://hex-rays.com/ida-pro) (Hex-Rays), the reference commercial disassembler and decompiler, from one thousand to almost nine thousand euros a year, with a free version limited to x86.
- [Ghidra](https://github.com/NationalSecurityAgency/ghidra), the NSA's open answer, with a decompiler and scripting, Apache 2.0.
- [Binary Ninja](https://binary.ninja/), with a free edition and licenses from 200 to 3,500 dollars.
- [radare2](https://github.com/radareorg/radare2) and [Cutter](https://github.com/rizinorg/cutter), the GUI for rizin, which is a radare2 fork: the open command line and the open interface.
- [x64dbg](https://github.com/x64dbg/x64dbg) and [WinDbg](https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/) on Windows, [GDB](https://www.sourceware.org/gdb/) everywhere else.
- [Frida](https://frida.re/), to inject code into a live process and watch what it does.
- [JADX](https://github.com/skylot/jadx) for Android and [ILSpy](https://github.com/icsharpcode/ILSpy) for .NET.

Keep this list in mind. REA, which we'll get to shortly, is a wrapper around it.

## How a binary gets taken apart, in practice

In principle, every binary is reversible. The processor has to be able to execute it, so the instructions are in there. The path is always the same:

1. **Disassemble**: the binary becomes assembly, one machine instruction per line. This is mechanical.
2. **Decompile**: the assembly becomes something resembling C. Ghidra and IDA do this reasonably well, with a lot of noise.
3. **Recover what the compiler threw away**: variable names, function names, types, structures, comments. None of it survives compilation. This is the real work, and it's human.
4. **Refactor** until it becomes code a person can read, maintain and port.

The N64 decomp projects take step 4 all the way: their C code, recompiled, produces the original ROM byte for byte. That's how Super Mario 64 became a project with 135K lines of game C code (around 100K of actual code, plus half a million lines of generated level and model data), and Ocarina of Time passed 430K lines. Static recompilation skips part of this: it translates the original processor's instructions into generic C, without trying to understand them, and replaces only the parts that talk to the hardware. It's faster and the result is less readable.

### "But can't the AI just read the binary directly?"

Someone always asks: if it's AI, why go through C? Let the model read the binary and build on top of it. The short answer is that an LLM only knows what was in its training corpus, and a corpus of binaries paired with source code is scarce, because no human has written production assembly in decades.

The long answer is that the literature exists, and it's instructive precisely because it's modest. The lineage runs from 2018 neural networks to models like [SLaDe](https://arxiv.org/abs/2305.12520) (200 million parameters, one per architecture and optimization level), [LLM4Decompile](https://arxiv.org/abs/2403.05286) (up to 33 billion) and [Nova](https://arxiv.org/abs/2311.13721). Meta published an [LLM Compiler](https://arxiv.org/abs/2407.02524) that translates assembly into LLVM IR. The best results, on isolated benchmark functions, hover around 60 to 65% of code that runs again and gives the same result, dropping sharply when the compiler optimized with -O3.

Two recent studies show the real state of things. [DecompileBench](https://arxiv.org/abs/2505.11340), with 23K real functions, found that LLM-based decompilers produce more readable code with half the functional correctness of commercial decompilers. And a [September 2026 paper](https://arxiv.org/abs/2609.05370) measured that LLM refinement of Ghidra output raises the compilation rate from 75% to 90% and drops behavioral fidelity from 74% to 62%, with up to around 10% of functions with known vulnerabilities no longer reproducing the flaw, meaning the bug vanished without anyone asking.

> Summing up what exists: small models, function by function, almost only x86-64 Linux, and the best ones are refinement layers on top of Ghidra, which keeps the classic decompiler in the loop. No emulator, no game, no whole program has been neurally recompiled. Until someone invents that, you work with reality, and reality includes the intermediate layer of programming language and compiler.

The AI assistants that exist for this in production confirm the design: [aiDAPal](https://plugins.hex-rays.com/aidapal), an IDA plugin by Atredis, Binary Ninja's Sidekick, the MCP servers for Ghidra. All of them are an LLM naming variables and explaining functions on top of what the traditional decompiler produced.

## What REA actually does

I cloned [REA](https://github.com/morluto/rea) and read the code. It's an MCP server and a TypeScript CLI that wraps the tools from the list above and exposes them to your coding agent: Ghidra, Hopper, IDA, JADX, Frida, Wakaru for obfuscated JavaScript, Playwright to capture what a website does. The agent asks, REA runs the tool and returns pseudocode, call graphs, strings and IPC traces, each result with an evidence record and a list of limitations.

The judgment is supplied by the LLM you already pay for. REA supplies the deterministic plumbing and the provenance. The phrase "automates the heuristics of reverse engineering", which circulates out there, appears nowhere in the repository; the description the project itself uses is agent-driven reverse engineering with traceable evidence.

What it requires: the artifact on your machine (native binary, Electron app, .NET assembly, APK, firmware, network capture), Node 22.19 or later, and the heavy tools installed at your own expense. Ghidra is free; IDA, Hopper and JEB the README tells you to buy. There's no REA API key because it runs locally, and the token cost lands entirely on your agent subscription.

And that cost is the detail nobody mentions. REA's MCP tool catalog is 2.3 MB of JSON, which goes into the agent's context. The project itself publishes an [experiment](https://github.com/morluto/rea/tree/main/experiments/analysis-efficiency) in which analyzing SQLite compiled to WASM, on the default path, took 42 tool calls, five minutes and 300K input tokens. A full inventory of an Electron app like Obsidian returns almost 1 MB of JSON.

There's an open issue complaining that inspecting an ordinary Mac app returns 80K to 230K tokens in one go.

The project is serious and goes far: six months, 2,600 commits, a thousand test files, version 6.4 released on October 11. It's also unstable: 190 open issues, several breaking changes per minor release, subsystems marked experimental.

The limits are written in the repository itself. CONTRIBUTING excludes breaking DRM, anticheat, licensing and commercial protections. The DISCLAIMER warns that decompilation, reconstruction and AI-assisted analysis "may be incomplete or incorrect". And even the internal instructions for generating the website's figures say, in so many words: "never imply REA automatically clones a program" and "never say full reconstruction, exact game clone, or automatic source recovery".

> REA is a good toolbox for someone who already knows how to do reverse engineering and wants an agent holding Ghidra. It isn't the "copy this app for me" button. The people who wrote the project are the first to say so.

## PhotoCraft: pretty screenshot, alpha inside

The [PhotoCraft repository](https://github.com/storytold/photocraft) was created on September 30. In two weeks, 54K stars, 8 releases and, as I write, more than 800 open issues. The README badge says "early alpha", and Brandon Thomas himself, quoted by Gizmodo, said it's nowhere close to ready. The press that tested it reached the same conclusion: Gizmodo called it a "glitchy, but real, Photoshop", and OMG Ubuntu "a superficial facsimile with pronounced flaws".

The issues tell the technical story:

- Any image above 8,192 pixels leaves the GPU compositor and falls back to the CPU, with a 6 GB memory peak, because that's the egui-wgpu texture limit ([issue 49](https://github.com/storytold/photocraft/issues/49), already closed, and the ones that came after it, [1015](https://github.com/storytold/photocraft/issues/1015) and [4017](https://github.com/storytold/photocraft/issues/4017)).
- A 12 megapixel photo needs almost 800 MB just to open, adjust and export from the command line ([issue 1637](https://github.com/storytold/photocraft/issues/1637)).
- Color management is rudimentary: a global working space only, instead of per document, and no view transform ([issue 321](https://github.com/storytold/photocraft/issues/321)). Eighteen issues mention CMYK, fifteen mention ICC profiles.
- Almost a hundred open issues mention PSD. Hue/Saturation layers composite differently from Photoshop, and saving over the file overwrites the original's correct merged image ([issue 4089](https://github.com/storytold/photocraft/issues/4089)).
- Fifty open issues mention "crash".

The interface resembles Photoshop, so the screenshot is shareable, and whoever sees the screenshot assumes it's a carbon copy. That's expected in a two-week-old alpha. Linus Tech Tips made a video trying to be as optimistic as possible, putting professionals in front of the clones:

{{< youtube id="fr0WIIZxvx0" >}}

Look at the tasks: they're the simplest ones there are, nowhere near professional usage. Even so, everyone in the video struggles to finish, and you can see the prototype level in every freeze. With interest, time and contributions, part of this gets fixed. And then the contributors will discover something the N64 projects never faced.

## The target moves

Decompiling 1998's Zelda is aiming at a stationary target. Nintendo isn't going to release Ocarina of Time 2026 with a new file format. Copying a live product is another conversation, and we've seen this movie before.

In the 90s and 2000s the target was Microsoft Office. StarOffice became OpenOffice in 2000 and LibreOffice in 2010, and all of them spent years chasing a binary format, .doc, that changed from version to version and only got a public specification in 2008, when the game was already over. The proven part of that story is in the court cases: the European Commission fined Microsoft [497 million euros in 2004](https://ec.europa.eu/commission/presscorner/detail/en/ip_04_382) for refusing to supply interoperability information, and [899 million in 2008](http://news.bbc.co.uk/2/hi/business/7266629.stm) for failing to comply. .docx only became an ISO standard in 2008, in a [vote so controversial](https://en.wikipedia.org/wiki/Standardization_of_Office_Open_XML) that countries formally protested.

It took more than ten years. And when the format finally opened, Office no longer mattered the same way. The value moved elsewhere: today it's [400 million paid Office 365 seats](https://office365itpros.com/2024/01/31/office-365-reaches-400-million/), [3 billion Google Workspace users](https://www.googlecloudpresscorner.com/2025-12-04-Google-Workspace-Study-Reveals-More-Than-90-of-Rising-Leaders-Want-AI-With-Personalization) and around [41 million Creative Cloud subscribers](https://prodesigntools.com/number-of-creative-cloud-subscribers.html). Nobody wants to install that on a desktop, and so nobody has the binary.

> Reverse engineering Google Docs means rewriting the product from scratch looking only at the interface, because the code that matters never leaves the server. After the world moved to SaaS, most proprietary software became a walled garden with no binary. No binary, nothing to disassemble.

You can build versions of it, of course. [Immich](https://immich.app/) replaces Google Photos for a person or a family: phone backup, face recognition, semantic search, all on your server. What it doesn't replicate is the infrastructure and the training corpus that make Google's search Google's search. And Adobe made the same migration, in pieces.

## Photoshop is far more than layers and crop

Here's the part I know from having paid for it. The features that sell subscriptions today don't even run on your computer.

Generative Fill and Generative Expand run on Firefly, in the cloud, and consume [generative credits](https://helpx.adobe.com/creative-cloud/apps/generative-ai/generative-credits-faq.html). Several Neural Filters, according to [Adobe's own documentation](https://helpx.adobe.com/photoshop/using/neural-filters.html), need an internet connection because the processing happens on Adobe's servers. AI object selection has had, since 2020, an option to process in the cloud for a refined result. All of this is code that doesn't exist on your machine for anyone to disassemble.

Then comes what is in the binary, but took decades and partnerships to exist. Camera Raw carries [lens correction profiles](https://helpx.adobe.com/camera-raw/desktop/dng-and-file-formats/supported-lenses.html) and per-camera color profiles for hundreds of models, built over twenty years and updated with every release. No clone guesses that. Either you have the data or you don't.

And there's color science. The example I always remember is GIMP and CMYK.

GIMP was born in 1995. The first native support for CMYK files arrived in [2022](https://www.gimp.org/news/2022/08/27/gimp-2-99-12-released/), and only for import and export, with pixels always in RGB. [GIMP 3.0, from 2025](https://www.cgchannel.com/2025/03/gimp-3-0-is-out/), still has no CMYK editing mode. It's on the [roadmap](https://developer.gimp.org/core/roadmap/) as work in progress.

Thirty years of an open project, with good and motivated people, and the print shop still asks for Photoshop. That's the size of the color science hole, and no coding agent invents color science: it reproduces what's in the training data.

Why did it take so long, if it was the most requested feature? Because GIMP's core was born with 8-bit-per-channel RGB baked into every layer, blend mode and filter. Supporting another color model meant rewriting the entire pixel engine, the migration to GEGL, which took the better part of a decade and was only finished in [GIMP 2.10, in 2018](https://www.gimp.org/release-notes/gimp-2.10.html). CMYK could only start after that.

And CMYK is a family of device profiles, with four inks, a per-printer ICC profile, ink limits and black generation rules, and editing in it means the whole pipeline has to compute in a subtractive four-channel model and round-trip through the profiles without drifting. A single developer, however good a programmer, without experience in this specific field will struggle to implement it, because the knowledge lives in print shops and color labs, and almost none of it is in a training corpus. In GIMP, the people who carried it forward were contributors who understand printing, and even then it took years. No new tool shortcuts that kind of knowledge.

And then there's the layer that isn't even technical: commercial licensing. Print-shop color is Pantone, and Pantone is a proprietary library. No open project can ship the palettes; the Inkscape developers [reached that conclusion in 2005](https://lists.inkscape.org/hyperkitty/list/inkscape-devel@lists.inkscape.org/message/DOXDMUAPHORC4HEXPF37LYBQH6SSQ2M5), and [Linux.com explained the legal risk](https://www.linux.com/news/pantone-and-free-software/) around the same time. Adobe itself felt it in 2022: when Pantone changed its business model, the libraries [were pulled from Photoshop, Illustrator and InDesign](https://petapixel.com/2022/10/28/you-have-to-pay-a-subscription-to-use-pantone-colors-in-photoshop-now), old files started opening with their Pantone colors replaced by black, and anyone who needs them pays for a separate plugin subscription. If even Adobe, paying, didn't escape, imagine a clone that runs on goodwill.

### Video is worse

In Premiere, After Effects and DaVinci Resolve, the problem multiplies. A cinema camera doesn't deliver video, it delivers raw data on its own logarithmic curve: ARRI's LogC4, RED's IPP2. To turn that into an image you need the manufacturer's transforms, and RED ships its own in an [SDK](https://community.acescentral.com/t/red-ipp2-color-workflows/1055) that the editors integrate and update with every version. ACES, the industry's neutral standard, depends on input transforms supplied by each manufacturer.

Blackmagic gives Resolve away for free and it decodes ARRIRAW and R3D. It does that because it pays for the SDK and the partnership on your behalf. An agent-built clone, "guessing" how the Alexa's image should look, produces an image that doesn't match the reference monitor, and in cinema that means it's useless. That knowledge isn't in any training corpus: it's in contracts.

## The Bun case: what it costs to rewrite big software

For a sense of the order of magnitude, the best public data point there is comes from Bun. In May 2026, Jarred Sumner rewrote the entire runtime from Zig to Rust using agents, and in July [published the numbers](https://bun.com/blog/bun-in-rust):

- 535K lines of Zig in 1,448 files became a one-million-line Rust diff, in 11 days.
- Up to 64 Claude instances in parallel, 24 hours a day, every line reviewed by two adversarial agents and a fixer.
- 5.9 billion uncached input tokens, 690 million output tokens, 72 billion cache reads: **around US$ 165K** at API prices.
- 16K compiler errors fixed by 64 agents before CI went green on six platforms.
- The existing test suite, with more than a million assertions, passed 100% before the merge.

Read again what made it possible:

- the project's original author at the controls
- a complete, working source code as reference
- a test suite with a million assertions serving as the oracle
- unlimited budget, because Bun has belonged to Anthropic since December 2025, and a pre-release version of Claude Fable 5

Sumner estimates three engineers with full context would have needed a year.

Now take each of those advantages away. PhotoCraft doesn't have the Photoshop source to port, it has to invent. It doesn't have a test suite that says "this matches Photoshop". It doesn't have Photoshop's author.

And Photoshop is a 36-year-old product whose disk requirements Adobe lists between [10 and 100 GB](https://helpx.adobe.com/photoshop/desktop/get-started/technical-requirements-installation/adobe-photoshop-on-desktop-technical-requirements.html), against a JavaScript runtime. Even without knowing the size of Adobe's codebase, we're talking about a bigger target, with no reference, no oracle and no owner. Orders of magnitude above US$ 165K, and even then it would be an approximation.

## Why retro moves so fast

If it's so hard, why does an old game port ship every day? Because retro stacks up every advantage the rest doesn't have.

**The binary is available and tiny.** Super Mario Bros. on the NES: 40 KB. Super Mario 64: 8 MB. Ocarina of Time and Majora's Mask: 32 MB each. A whole PS1 CD: 650 MB.

Compare with [Baldur's Gate 3](https://store.steampowered.com/app/1086940/Baldurs_Gate_3/), 150 GB, or with the [latest Call of Duty](https://support.activision.com/black-ops-6/articles/pc-system-requirements-for-black-ops-6), above 100 GB. That's three or four orders of magnitude, and the scope shrinks along with it: a 1996 game has a handful of systems, not a physics engine with networking, a store and anticheat.

**The technology is old and documented.** Twenty-five years of community have already mapped the N64, PS1 and SNES hardware instruction by instruction. The agent discovers nothing; it speeds up work that already has a map. It's the same pattern I [saw in my retrocomputing projects](/en/2026/09/28/llms-are-good-at-reproducing-what-exists-what-about-new-things/): where there's a reference and an oracle, AI flies; where there isn't, it spins in brute force.

**The target doesn't move.** Nobody is going to update 1998's Zelda.

**And the legal side was settled thirty years ago.** Sega v. Accolade and Sony v. Connectix drew the outline. The ports require you to supply your own ROM.

### A modern console is a PC

The second half of the explosion, the PS4, PS5, Xbox One and Switch ports, has another explanation: those consoles are PCs or phones in a different case. The [PS4](https://www.playstation.com/en-us/ps4/tech-specs/) uses an AMD Jaguar x86-64, the [PS5](https://blog.playstation.com/2020/03/18/unveiling-new-details-of-playstation-5-hardware-technical-specs/) a Zen 2, the [Xbox Series](https://news.xbox.com/en-us/2020/03/16/xbox-series-x-tech/) another Zen 2, the Switch an NVIDIA [Tegra X1](https://www.techinsights.com/blog/nintendo-switch-teardown) ARM chip. Your PC's processor runs that code natively. So nobody needs to emulate the CPU.

The remaining work is translating the operating system and the GPU. [shadPS4](https://github.com/shadps4-emu/shadPS4) reimplements the PS4's system libraries and recompiles the shaders: games ship from the factory with AMD GPU machine code, which the emulator decodes instruction by instruction and converts to SPIR-V, Vulkan's format.

[Azimuth](https://almost-there-games.itch.io/azimuth), which makes Forza Horizon 2 run on Windows, translates Xbox WinRT calls to Win32 and DirectX 11.X to desktop DirectX 12, with the game's x86 code running directly. AnyPS5 relinks the executable: it takes the PS5 binary and produces a native Linux or Windows binary, linked against reimplemented system libraries. In all three cases, Proton, DXVK, VKD3D and MoltenVK had solved the graphics translation layer years earlier.

The reverse proof is the consoles that weren't PCs. The PS3 uses the Cell, a PowerPC with seven active coprocessors (the SPEs), each with its own local memory and no cache, and RPCS3 has been at it [since 2011](https://rpcs3.net/about), with SPU emulation still the bottleneck today. The Xbox 360 is PowerPC too, which is why Sonic Unleashed needed XenonRecomp to translate PowerPC into C++. Reverse engineering is case by case, and the architecture decides whether the case is easy.

### AI is in the loop, and there's already a fight

That the 2026 ports use AI, many of them say outright. The [Silent Hill decomp](https://github.com/SlickAmogus/silent-hill-decomp) writes in its README that development is "heavily AI-assisted (Claude Opus 4.6, 4.7 and the newer Fable model), and we're open about that. It is not automated translation of the game". The Pokémon Stadium recomp [lists Claude as a contributor](https://retrododo.com/a-pokemon-stadium-recomp-has-finally-arrived-but-lists-claude-as-a-contributor/).

The devs of the Zelda and Banjo recomps, who spent years doing this by hand, [went to war](https://kotaku.com/zelda-and-banjo-recompiled-devs-go-to-war-with-ai-vibe-coded-slopcomps-2000739936) with what they call "slopcomps", agent-generated ports of alpha quality.

And it's worth separating headline from actual state here too. AnyPS5 has a 0.1 version from September that, according to those who tested it, runs one 2D indie game; the viral claim that "the PS5 is 80% ported to PC" comes from fans, and no 3D game runs. Astro Bot runs, but in emulators (KytyPS5, SharpEmu), which take the traditional path. Forza Horizon 2 runs, and Azimuth is a closed binary from a studio that declares itself "AI assisted" without saying anything more.

## "But in two years tokens will cost nothing"

The standard answer to all of this is: it's hard today, in two years it's trivial, because AI grows exponentially. The numbers say otherwise.

The price of the most expensive tier barely fell. GPT-4 in March 2023 cost US$ 30 and 60 per million input and output tokens; Claude 3 Opus in 2024, 15 and 75; today's frontier models, Fable 5.1 and GPT-6 Astra, [cost](https://claude.com/pricing) [10 and 50](https://developers.openai.com/api/docs/pricing). In three and a half years, the frontier got between 1.2 and 3 times cheaper, depending on which end you look at.

What really fell was the cost of a fixed quality: Epoch AI measured drops [of 9 to 900 times per year](https://epoch.ai/blog/llm-inference-price-trends) depending on the task, and in a [2026 review](https://epoch.ai/gradient-updates/how-persistent-is-the-inference-cost-burden) sums it up as "very roughly 5 to 10 times per year", with the caveat that it might slow down. That's real and it's great.

But apply the math to Bun. US$ 165K divided by 10 is US$ 16K. By 100, US$ 1,650. That's to port a runtime with the source, the tests and the author in hand.

For an amateur trying to clone Photoshop with none of that, the bill starts orders of magnitude higher and falls in the same proportion. Cheap isn't the same as trivial.

And the "exponential" premise died in 2024. Ilya Sutskever said at NeurIPS that [pre-training as we know it will end](https://www.globalbankingandfinance.com/ai-with-reasoning-power-will-be-less-predictable-ilya-sutskever-says/), because there's only one internet. Epoch projects that reasoning model scaling [converges to the general frontier rate](https://epoch.ai/gradient-updates/how-far-can-reasoning-models-scale) in about a year.

I've written about this three times in recent weeks: [the limits](/en/2026/09/28/llms-are-good-at-reproducing-what-exists-what-about-new-things/) of what the model reproduces, [the convergence](/en/2026/10/12/llms-agents-competent-enough/) of raw models with the gains coming from the harness, and [the languages benchmark](/en/2026/10/11/are-there-better-languages-for-programming-with-llms/) where the frontier models tied at the ceiling. The tool we have is the tool we'll have for a good while, with incremental improvement. Plan with it.

## Answering the list from the top

**Does PhotoCraft exist?** It does, it's a two-week-old alpha with more than 800 open issues, rudimentary color management, freezing above 8K and opening PSDs wrong. It looks like Photoshop in a screenshot. It can improve a lot, and it will discover that the target moves and that Photoshop's expensive parts live in the cloud or in manufacturer contracts.

**Does REA exist?** It does, it's good, and it's a toolbox for people who already know how to use Ghidra, requiring the binary in hand, the tools installed and hundreds of thousands of tokens per analysis. The project itself avoids saying it clones programs.

**Did recomps and decomps accelerate?** Yes, for real, and AI has a part in it. They accelerated where the binary exists, is small, has been documented for 25 years and doesn't move. Or where the console is a PC in disguise and the work is API translation, solved by Wine and Vulkan years earlier.

**Is Adobe dead?** Adobe has around 40 million subscribers by the most cited estimate, the features that sell subscriptions run on its servers, and thirty years of GIMP still leave the print shop asking for Photoshop. I wish it were otherwise. The data says what will happen is what always happened with clones of a live product: years of chasing, and when you catch up, the value has already moved.

**Are programmers dead?** Rewriting Bun required Bun's author. The decomps that work have people who know the hardware driving the agent, and the ones that don't became "slopcomps", name and all. Reverse engineering got cheaper and more accessible, as it did with Ghidra in 2019, and it's still an engineer's job. Without us, the tool returns a pretty screenshot.

Proprietary software with a binary in hand will come under pressure, and it should. Most of the software you use has no binary at all, and the software that does already depends on cloud services that don't disassemble. Software engineering with AI has a great road ahead. "It's over" headlines get clicks and don't compile.
