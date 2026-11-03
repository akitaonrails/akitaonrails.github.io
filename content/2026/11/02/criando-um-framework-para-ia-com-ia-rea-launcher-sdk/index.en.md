---
title: "Creating a Framework for AI with AI: REA Launcher SDK"
slug: "creating-a-framework-for-ai-with-ai-rea-launcher-sdk"
date: '2026-11-02T21:00:00-03:00'
draft: false
translationKey: criando-um-framework-para-ia-com-ia-rea-launcher-sdk
description: "After building seven launchers with AI agents to modernize old racing games, I extracted what they had in common into a framework, rea-launcher-sdk. I explain why a framework is extracted from several projects and never designed up front, how migrating the launchers found bugs in the SDK and in the launchers themselves, the built-in techniques (a test before every fix, snapshots, headless tests, CI, agents that run the game and debug crash dumps), the test and coverage numbers for each project, the two new launchers built straight from the SDK, and the step by step for anyone to build a launcher for their favorite game with the agent of their choice."
tags:
- coding-agents
- software-engineering
- software-architecture
- gaming
---

In the [first article of the series](/en/2026/10/29/playing-with-pc-ports-colin-mcrae-rally-1/) I showed the [launcher for Colin McRae Rally](https://github.com/akitaonrails/rea-colin-mcrae) from 1998: a thin layer around the original executable that makes the game run at 4K, widescreen and 60 fps on a modern PC, with [REA](/en/2026/10/13/ai-reverse-engineering-is-adobe-dead/) doing the reverse engineering. In the [second](/en/2026/11/02/i-fixed-several-old-racing-games-using-ai/), this morning, I repeated the recipe on half a dozen more racing games: [Colin McRae 3](https://github.com/akitaonrails/rea-colin-mcrae-3), [04](https://github.com/akitaonrails/rea-colin-mcrae-4) and [DiRT](https://github.com/akitaonrails/rea-dirt), [OutRun 2006](https://github.com/akitaonrails/rea-outrun-2006), [Sega Rally Revo](https://github.com/akitaonrails/rea-sega-rally-revo) and the [Screamer trilogy](https://github.com/akitaonrails/rea-screamer-trilogy).

After building these launchers to bring back my favorite games, I wanted more people to be able to do the same with *their* games. So I put it all together in a framework: [rea-launcher-sdk](https://github.com/akitaonrails/rea-launcher-sdk).

This article tells how it was born, and why I did it in the order I did.

## Apps first, framework later

Many amateurs think about it the wrong way: first you design a cool new framework, then you build applications on top of it. That's the completely wrong way to build a library or framework.

The right way is the opposite:

1. implement **several projects of the same kind**, each one solving its own real problem;
2. assess all of them together, comparing what each one did;
3. **normalize** them through refactoring, until they all share the same common foundation;
4. only then **extract** the common parts into a proper framework.

That's how Rails was born, extracted from Basecamp. A framework designed before the first app always solves the problem the author *imagined*, and gets wrong what shows up in practice.

> You only know what's common after you've seen the same thing done three, four, five times. Before that, it's a guess.

That's what I did here. The difference is that this time every step was done with LLMs.

## The launchers before the SDK

Every launcher was built with agents, and I used several: Claude, Codex, Antigravity and others. The one that took most of my time was the first, Colin McRae 1. It started on October 20 and today has almost 800 commits, because that's where I discovered what a launcher like this needs, along with the recomp and the HD texture pack.

For the others, it was enough to say something like *"copy everything from rea-colin-mcrae and adapt it for game X"*. That sped up the following ones a lot. The problem is that each agent copied and adapted in its own way, and in the end each launcher went in a different direction.

![The Colin McRae Rally launcher, the first of the family](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/cmr1-launcher.png)

The audit the SDK agent did later showed the size of the mess. Every bug it found existed in one or more copies, and was already fixed in another:

- the Colin McRae 3 launcher had an executable conversion that **never ran**, because the program path was passed twice on the command line;
- Screamer's built the private copy with symlinks to the original folder, so the game could write into the user's install;
- Sega Rally's wrote `"Disable Hidraw"`, with a space, into a key Wine reads as `DisableHidraw`;
- OutRun's copied saves without checking which was newer, and its stop command killed the helper shell instead of the game;
- three launchers built a script by interpolating the launcher path without escaping quotes.

About 2,000 lines of code were repeated in every launcher, each copy with its own bugs.

## Extracting the SDK

When I felt I had enough material, I created rea-launcher-sdk and asked Claude to do exactly what I preach: study five of the seven launchers I had so far (Colin McRae 1 and DiRT joined later), normalize them, extract what was common and build a proper framework, with my software engineering techniques built in as skills.

The first commit, at 10:50 today, says *"initial SDK extracted from the five rea launchers"*. Each piece is the best version among the five copies, and an audit document records which launcher each one came from. The private copy came from one, the DLL installation from another, and the window-close hook, which arrived in 0.3.0, came from Colin McRae 04.

What ended up in the SDK:

- **the portable core** (`rea-launcher`): the game's private copy, save mirroring, executable identification by SHA-256, declarative binary patches, the options table, INI editing, downloads pinned by hash;
- **the Windows layer** (`rea-launcher-win32`): registry, processes, single instance, error messages, GPU and Wine detection;
- **the interface** (`rea-launcher-ui`): the egui settings window, with theme, contrast checks and screenless UI tests;
- **the close hook** (`rea-launcher-close-hook`): a DLL that turns Alt+F4 or the close button into the game's quit path, configurable without recompiling;
- **the Linux side**: a shell library for the play script with gamescope and Wine, and AppImage packaging;
- **CI**: reusable workflows for build, tests, import checks and release, plus a weekly workflow that opens a pull request when a new SDK version is out.

What was **not** extracted is each game's knowledge: which byte to patch, which registry key to write, which community fix to use. That stays in each launcher, and the SDK takes it as data.

### From 0.1 to 0.3 in about four hours

The first version came out at 11:07, after a full review of the SDK itself. 0.3.3 came out at 15:12. In between, the cycle was always the same:

1. migrate the launchers to the new SDK version;
2. the migration exposes a bug or a gap in the SDK;
3. the SDK fixes it and ships another version;
4. the launchers bump again.

Some examples of what this cycle caught:

- **Flags in the `--key=value` form.** The new options table stopped accepting that form, which the launchers' scripts used. 0.3.2 brought it back, with a test.
- **Errors invisible under Wine.** The Linux scripts, the AppImage and Proton send output to a log, so the SDK thought it had a terminal and didn't show the error to the player. 0.3.2 added a report that decides who needs to see the message.
- **DLLs rewritten every run.** Sega Rally rewrote about 70 MB of DLLs on every launch. The SDK started skipping identical files.
- **Wine ignores `WINEDLLOVERRIDES`.** The real-game test on Sega Rally showed Wine loading its own builtin DLL in place of the Microsoft DLL in the private copy. 0.3.3 started writing the overrides into Wine's registry, per program, and five launchers adopted it.

And the migration also found bugs specific to each launcher, which only showed up when they were all forced into the same standard:

- the GNU binutils 2.47 linker left kernel32 imports out of the table; in Screamer there were 53, and the launcher crashed before `main`. It became an SDK rule to link with lld and check imports in CI;
- in Colin McRae 3, unsetting a picture option wiped the choice the player had made in the game's menu;
- in Colin McRae 04, opening the launcher again found the game's own window, or even an Explorer folder with the same name, and exited silently;
- in Sega Rally, the Polish menu showed up in English, and the empty saves the launcher created made the game report corrupted data.

There was even a bug created by the process itself. The `--help` test snapshot included the version number, so the release commit changed the version and broke the tag build. Releases 0.2.0 of Colin McRae 3, 0.3.0 of 04 and 0.2.0 of OutRun were tagged and never published, and came out fixed minutes later.

In the end, all seven launchers were on the SDK, all green, with new releases. Besides sharing the same layer, they became more correct than they were before.

## The built-in techniques

The SDK has a standards document of about 540 lines, and most of its rules came from real bugs that showed up in the launchers. The main ones:

### A test before the fix

Every bug fix starts with a test that fails on the old code. Then the agent temporarily reverts the fix to confirm the test really fails without it, because several "regression tests" passed either way.

Other testing rules:

- **test the behavior**: the xdelta bug in Colin McRae 3 survived because the unit test checked the wrong argument list. Where a real tool exists, test against it;
- **test the whole wiring**: option → `launcher.cfg` → game file, registry and environment, end to end;
- **tests as player stories**: "the player restores an older save backup", "the session is killed before copying the saves back", "opens the launcher again with the game running";
- **hostile inputs**: paths with spaces, apostrophes and accents (`José/Jogos d'Ação`), files in a Windows code page, CRLF, BOM, truncated files;
- **Windows code runs with Windows semantics**: the Windows-target tests run inside Wine, without a screen. Four SDK bugs only showed up that way.

### Golden snapshots

Each launcher keeps snapshots of everything it produces: the `--help`, the generated `launcher.cfg`, and for each visual profile the game's config files, registry values, environment variables and the patches it would apply. If an SDK update changes any byte of that, the test breaks, and the change is reviewed like code.

### No screen by default

Tests, probes and even the real game run **headless**: gamescope with no video output, a PipeWire null audio sink and a throwaway Wine prefix. Evidence comes from logs, exit codes, the process table, files written and screenshots captured without a monitor.

A window only opens when it needs a human, like judging how the interface looks or testing a controller. And the agent warns first: what will open, why, and what to look at.

### CI that catches what humans forget

Each launcher's CI runs formatting, lint, the Windows-target tests inside Wine, the import check, dependency auditing and packaging. A release only ships with green CI, generates `SHA256SUMS` and a provenance attestation, and the notes come straight from the CHANGELOG.

## AI code doesn't have to be slop

Plenty of people look at AI-generated code and assume it's "AI slop": it works on the example, breaks on everything else, and nobody knows why. That happens when someone asks for code and accepts whatever comes back.

With the right techniques, the opposite happens. I'd say the code I generate with AI today is far superior to that of the average human developer, who still fights against writing proper tests out of laziness.

I measured it. I ran the test suite and line coverage for each project, on Linux:

| Project | Tests | Line coverage | Snapshots |
| --- | ---: | ---: | ---: |
| rea-launcher-sdk | 310 | 95% | |
| Colin McRae Rally | 171 | 89% | 8 |
| Colin McRae Rally 3 | 97 | 96% | 7 |
| Colin McRae Rally 04 | 106 | 98% | 8 |
| Colin McRae: DiRT | 74 | 97% | 8 |
| OutRun 2006 | 94 | 92% | 11 |
| Sega Rally Revo | 126 | 96% | 8 |
| Screamer trilogy | 89 | 71% | 10 |
| [Colin McRae Rally 2005](https://github.com/akitaonrails/rea-colin-mcrae-2005) | 71 | 96% | 10 |
| [DiRT Rally](https://github.com/akitaonrails/rea-dirt-rally) | 85 | 85% | 13 |

That's more than 1,200 tests, all passing, and nine of the ten projects at 85% coverage or more. For every two lines of production code, there's roughly one line of test.

Coverage only counts what compiles on Linux. Windows-only code, like Colin McRae 1's hook DLL, is left out of the count, and is tested in CI by running the Windows-target tests inside Wine. Screamer is the lowest: its configuration, private copy and hooks inside the emulator sit below 75%.

The numbers alone don't tell the story. What tells it is the kind of bug these tests caught.

### The test that passed wrong

In Colin McRae 3, the conversion of the executable to the DRM-free version **never happened**, silently. The launcher built xdelta's arguments repeating the program path, and xdelta received `xdelta.exe xdelta.exe -f -d -s …`.

The unit test passed, because it checked exactly that wrong list. The SDK audit ran real xdelta3 and got "too many filenames". The fix came with a new test that generates a tiny patch with real xdelta3, applies it with the launcher's arguments and compares the bytes.

That's where one of the SDK's rules came from: test the behavior, with the real tool whenever it exists.

### The "safe" fix that lost saves

In Colin McRae 3, after a crash, the launcher restored the old save over the new one. The fix was "newest wins", and the audit liked it so much it took it to OutRun and Screamer the same morning.

But "newest wins" throws away the older backup the player restored on purpose, and saves brought from another PC with old timestamps. Within 20 minutes, the three launchers replaced the rule with a record of the last sync's state. The tests are named like stories: `a_restored_older_backup_wins`, `a_session_killed_before_saving_is_recovered`.

An independent reviewer caught the problem, and that's why the SDK started requiring tests written as player stories.

### The checklist that said FAILED

In Sega Rally, the real-game verification had an item: "`WINEDLLOVERRIDES` reaches the game". It was marked **FAILED**. The launcher logged the overrides, but with `WINEDEBUG=+loaddll` you could see the game loading Wine's builtin DLL.

`WINEDEBUG=+module` showed two causes. Wine swaps in its own version of any DLL whose version resource identifies it as Microsoft's, even in the program folder, and it ignores `WINEDLLOVERRIDES` set only in the child process's environment. The fix went into the SDK, with a test that proves the bug (`env_block_overrides_do_not_reach_wine`), and five launchers adopted it. Without the rule of verifying in the real game, nobody would have noticed: the log said everything was fine.

### Two wrong fixes before the right one

In Screamer, reaching the title screen proved nothing. A headless run switching track previews reproduced the real crash: `mipmap cannot span 2 Mbyte boundary`.

The first fix handled a path that never happened. The second caused the same error on its own and was reverted. The third, after reading the disassembly, found a signed `jle` that let through a texture ending exactly at the limit, plus two paths that skipped the check. The final fix changes **one byte** (`jle` becomes `jl`) and nulls the two bypasses, with a test that checks all three spots.

> Getting it wrong the first time is normal, for humans and for AI. What changes is that the agent only commits when the game confirms it, and the test guarantees the error doesn't come back.

## Agents that play the game

What sped all of this up the most is that the agents have access to **run the actual game**. They apply the patch, open the game in a headless gamescope, check the result in the log and the screenshot, and only commit when everything is confirmed working.

That saves hours, sometimes days, of manual testing. I don't need to open the game for every patch attempt, only at the points where my eyes or my hands on the controller make a difference.

And when the game crashes, there's a dump. The agent opens it in `gdb` or `winedbg`, finds the instruction that failed and gets to the cause with a precision I rarely had when doing this by hand, years ago. Three examples:

- **OutRun 2006**: the launcher crashed right after copying the saves. `winedbg` with symbols put the fault in a call to `GetModuleHandleW` whose import table slot belonged to no descriptor, so the loader never filled it. The cause was the binutils 2.47 linker in my toolchain, and the fix was switching to lld.
- **Colin McRae Rally 2005**: the game crashed at startup under Wine, at an address inside the routine that measures text width. It read the font header before checking whether the font had loaded, and the font never loaded because the game builds its paths from registry keys only the installer writes. There was a [Wine bug](https://bugs.winehq.org/show_bug.cgi?id=38198) with the same crash, which went away by reinstalling the game and ended up closed without an explanation.
- **DiRT Rally**: the 2017 Linux port crashed right after starting SDL on new processors. The game maps memory with execute permission only and then *reads* from it. On CPUs with Memory Protection Keys (Ryzen on Zen 3 or newer, Intel 11th generation or newer), the kernel makes that memory truly execute-only, and the read faults. The problem was already known in the community, and the launcher's fix is its own small Rust library that intercepts `mmap` and `mprotect` and adds read permission, without touching the game.

## Testing the SDK with two new games

With everything green, it was time to really test the SDK: two new launchers, from scratch, for **Colin McRae Rally 2005** and **DiRT Rally**. This time I only needed to say *"use rea-launcher-sdk and create a new launcher for game X"*.

The agent followed the playbook: research first, then the scaffold generated by the SDK's `new-launcher` script (66 files and almost 11,000 lines to start from), then the implementation in steps, verification in the real game, and the release.

Of course each game had its quirks, and needed manual testing, extra prompting and my own insight.

### Colin McRae Rally 2005

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/colin-mcrae-rally-2005/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/colin-mcrae-rally-2005/showcase-poster.jpg" >}}

- **the startup crash**, explained above, solved by writing the registry keys on every start;
- **GOG's installer hangs under Wine**, so the launcher unpacks the installer files with innoextract and never runs the installer;
- **with Wine's renderer, a stage ran at 20 fps**; with DXVK, it went past a thousand;
- **a portrait main monitor** made the game stop with "Adapter has no modes!", and Wine's per-program virtual desktop key is ignored in Wine 11. The solution was to open the game in a virtual desktop the size of the landscape monitor;
- **in a fresh Wine prefix, the launcher window didn't open**, because Wine only reads the EGL setting when the process starts. The launcher now switches to GLX and restarts itself.

The last two only showed up when I played on my desktop, with my portrait monitor and my Hyprland. No headless test would catch that.

![Colin McRae Rally 2005 on a stage in Australia, at 1920x1080 with the widescreen view](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-launcher-sdk/cmr2005-gameplay.jpg)

### DiRT Rally

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/dirt-rally-launcher/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/dirt-rally-launcher/showcase-poster.jpg" >}}

- **the new-CPU crash**, explained above;
- **the old libraries** today's Linux no longer ships (OpenSSL 1.0, libidn11, librtmp, OpenLDAP 2.4, GConf) come from pinned Steam Runtime packages, and only the game sees them, because leaking them into gamescope crashes gamescope;
- **Feral's pre-game window**: the obvious preference flags didn't work. The agent decompiled the decision with REA and found the two right keys. Skipping the window without writing the resolution crashed the game, so the launcher writes both;
- **the controllers took three tries.** My 8BitDo Ultimate 2 showed up as a generic joystick. The first fix, through an SDL variable, made the controller *disappear*. The real cause was Feral's own controller list inside the game, and the launcher now adds standard-layout controllers to it.

DiRT Rally also exposed the SDK's biggest hidden assumption: it was built for Windows executables running under Wine. DiRT Rally is a native Linux binary, so it lacked a native error window, a Unix single-instance lock, progress on the 40 GB copy and Linux controller reading for the launcher window. The agent wrote all of that in the launcher itself first, and later it moved into the SDK.

![DiRT Rally's first Play: the private copy being made, 2.3 of 43.1 GB](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-launcher-sdk/dirt-rally-launcher-copy.jpg)

### The numbers

Comparing commits and session hours (adding up the spans between commits) until each launcher reached the SDK standard:

| Launcher | Commits | Hours in commit sessions |
| --- | ---: | ---: |
| Colin McRae Rally (the first) | 789 | ~110 h |
| Screamer trilogy | 87 | ~17.5 h |
| Colin McRae Rally 3 | 89 | ~11.5 h |
| Colin McRae Rally 04 | 70 | ~10 h |
| OutRun 2006 | 88 | ~9 h |
| Sega Rally Revo | 77 | ~8 h |
| Colin McRae: DiRT | 27 | ~3.5 h |
| **Colin McRae Rally 2005** | **15** | **~4 h** |
| **DiRT Rally** | **18** | **~4 h** |

The older launchers' numbers include the first version, the fixes and the migration to the SDK, and the migration alone was about 35 to 50 commits each. DiRT has few commits because almost all of its work was done before the first commit.

Colin McRae 2005 was born with everything: tests, snapshots, CI, a standard README, issue forms, releases with hashes. DiRT Rally shipped without the golden snapshots, got them right after the release, and that gap became an SDK rule (more below). Its test and coverage numbers in the earlier table are from after the release.

> Most of the older launchers needed 70 to 90 commits and 8 to 18 hours to reach the standard. The two new ones got there in their first release, or close to it, with fewer than 20 commits and about 4 hours each, built in parallel in the same afternoon and evening.

Fewer commits means less back and forth. The agent got it right the first time more often because the SDK had already solved what the other launchers had to learn the hard way.

## The SDK learns from the new launchers

After the two shipped, I went back to the SDK agent and asked it to assess both: adjust whatever they needed, and learn whatever could come back into the framework. It's the same rule as before: only what has already shown up in a real project becomes framework.

The result was [version 0.4.0](https://github.com/akitaonrails/rea-launcher-sdk/releases/tag/v0.4.0). What it brought:

- from DiRT Rally: a single-instance lock for native Linux launchers, a native error window, copying with progress, Linux controller reading;
- from Colin McRae 2005: switching to GLX with a restart on a fresh prefix, light palettes with proper contrast, and a new close-hook mode for games that grab the keyboard in exclusive DirectInput mode, where Alt+F4 never arrives;
- from several: gamescope sizing per visual profile, which Colin McRae 1, 2005, 04 and OutRun had each reimplemented in their own hook;
- from the release bug: a snapshot helper that never records the version number.

And what came from the two new launchers will already benefit the older ones too. OutRun, Colin McRae 1 and 04, for example, can delete their own code that sized gamescope and use the SDK's, and several get the proper error window, second launches handled the same way, and safe removal of DLL overrides. That's the cycle closing: the new project teaches the framework, and the framework improves the old projects.

A new idea came along too: a **conformance checker**, `launcher-check`, which runs in each launcher's CI and fails the build when a launcher repeats a known mistake. There are 33 rules, and each one explains why it exists and how to fix it. A mistake that showed up in one launcher and can be detected by looking at the files becomes a rule. For example, "DiRT Rally shipped without snapshots" became one.

The new-launcher playbook also gained pattern sections: native Linux port, old Feral ports, GOG installers with innoextract, portrait monitor with a virtual desktop.

No software is ever "done". But I believe the SDK is already good enough: it's been battle tested with nine launchers and eleven real games, and anyone can start using it.

## Built to be used by AI

The SDK was designed **AI-first**. The README says so right at the start: it was written to be driven by a coding agent. The agent does the research, the reverse engineering and the code; you bring the game and the decisions.

And it doesn't have to be Claude. The structure works with whatever agent you prefer, be it Claude Code, Codex, opencode or Cursor:

- **`AGENTS.md`** is the entry point for any agent: a "task → playbook" table and the rules that are easy to forget. `CLAUDE.md` just points to it;
- **the playbooks** are plain Markdown: new launcher, binary patching, community components, CI and releases, SDK changes, contributing back, and the README template;
- **`docs/STANDARDS.md`** holds the mandatory rules, and every launcher gets a copy;
- **the Claude skills** (`rea-new-launcher`, `rea-sdk-change`, `rea-contribute-back`) are just thin pointers to the playbooks, for Claude Code users.

Some rules the agent follows without you having to remember them:

- never distribute game files, and never modify the game folder;
- identify each executable by SHA-256 and **never** patch an unknown version by guesswork;
- research community fixes before writing code;
- record the project owner's decisions, with dates;
- publish nothing, no push, no release, no forum post, without approval.

## How to build a launcher for your favorite game

If you have an old game that doesn't run properly anymore, this is the way.

**1. Prepare the tools.** Clone the SDK and install REA in your agent:

```bash
git clone https://github.com/akitaonrails/rea-launcher-sdk ~/Projects/rea-launcher-sdk
npx rea-agents setup                                  # REA, the reverse engineering MCP
~/Projects/rea-launcher-sdk/scripts/install-skills    # Claude Code only
```

You also need the toolchain: Rust with the Windows targets, MinGW, lld, Wine, gamescope and a few more tools the README lists. The easiest way is a container that already has everything, like my [distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming).

**2. Have the game installed.** Your own copy, in a folder the agent can read. It's never modified, nor copied into the repository.

**3. Ask the agent.** Open the agent in an empty folder and paste a prompt like this one, from the README:

> Build a new rea launcher for *Need for Speed: Porsche Unleashed* (PC, 2000) using the SDK at `~/Projects/rea-launcher-sdk`. Read its `AGENTS.md`, `docs/STANDARDS.md` and `docs/playbooks/new-launcher.md` and follow the playbook phase by phase. The game is installed at `/mnt/games/NFSPU` (read-only, never copy it into the repo). Use the REA MCP tools to analyse it. Research existing community fixes first and show me what you found before writing code. Keep tests headless. Don't push or publish anything without asking me.

With Claude Code and the skills installed, *"make a rea launcher for game X at /path"* is enough.

![Picture tab of the Colin McRae Rally 2005 launcher, generated from the options table](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-launcher-sdk/cmr2005-launcher-picture.jpg)

**4. Review at the checkpoints.** The playbook stops at four moments for you to decide:

1. what the research found;
2. the list of problems the launcher will solve;
3. the options the window will offer;
4. what was verified in the real game, recorded in `docs/RUNTIME_NOTES.md`.

In between, the agent follows the phases: get to know the game with REA, generate the scaffold, build in order (game edition, private copy, components, configuration, patches, visual profiles, window, command line, Linux script, packaging), and verify with the tests and with the real game running headless.

![DiRT Rally launcher with no game folder yet: Play waits](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-launcher-sdk/dirt-rally-launcher-setup.jpg)

**5. Play.** This part is yours. It's by playing on your PC, with your monitor and your controller, that the bugs no test catches show up.

**6. Publish.** When you approve, the agent pushes, and the release comes out through CI with the Linux AppImage, the Windows zip and the hashes. The playbook also has a contribute-back phase: drafts for PCGamingWiki and for the community projects, which are only posted with your approval.

## Good tools are born from real use

rea-launcher-sdk went from zero to version 0.3.3 in about four and a half hours, but that was only possible because seven working launchers already existed, with almost a thousand commits between them. The framework is the easy part when you already have the projects.

> Don't start with the framework. Build the same kind of project several times, let the copies diverge, and only then extract. With agents, that cycle that would take months fits in a few days.

If your favorite game is stuck in the past, the SDK is open. Point your agent at it, point it at the game folder, and release your own launcher.
