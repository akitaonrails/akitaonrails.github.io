---
title: "An Emulation Distrobox with Claude Code"
date: '2026-04-11T18:00:00-03:00'
draft: false
slug: emulation-distrobox-with-claude-code
translationKey: distrobox-emulacao-claude-code
tags:
  - gaming
  - emulation
  - linux
  - distrobox
  - claude-code
  - AI
---

I've loved old videogames since before many of you were born. My first contact was back in the Atari era, in the early 80s. Then came the 8-bit micros, the 90s arcades, the 16, 32 and 64-bit consoles, and I kept following all of it. For me, nostalgia is not a cute Instagram folder. It's an archive. ROMs, BIOS files, dumps, patches, DLC, firmware, saves. Over the years I kept everything on my NAS. At this point I have terabytes of it under `/mnt/terachad/Emulators`.

On my YouTube channel I even used old games to teach computer science fundamentals. In [this Akitando episode about Super Mario and old computers](https://www.youtube.com/watch?v=hYJ3dvHjeOE&pp=ygUUYWtpdGFuZG8gc3VwZXIgbWFyaW8%3D), I explain the 6502, memory maps, the PPU, hardware constraints, and why those games were programmed the way they were. If you never watched it, start there:

{{< youtube id="hYJ3dvHjeOE" >}}

The problem is the usual one: every few years I decide to build a new emulation machine, redownload the major emulators of the moment, and repeat the same masochistic ritual. `PCSX2`, `RPCS3`, `Eden`, `Azahar`, `Dolphin`, `RetroArch`, `Flycast`, `shadPS4` and so on. Every one of them has its own quirks. Every one of them has its own way of wasting your time.

In theory, setting all this up should be fun. In practice, it takes days. And that's not an exaggeration. `Dolphin` is still one of the worst because GameCube and Wii controllers are anything but standard. `RPCS3` needs game-specific tuning. `Eden` needs DLC, updates and cheats in the right places. `shadPS4` is an endless pile of trial and error. By the time I finished configuring everything, I usually had no energy left to actually play anything. I just wanted to close the menus and go do something else.

I used to say maybe the tuning itself was part of the fun. I don't think that anymore. After doing this too many times, I'm done with it. I want to play the games, not fill out hidden forms inside emulator GUIs.

## The problem wasn't Linux

I've solved this kind of thing in several different ways over the years. Years ago I ran Linux on the host and a Windows VM with GPU passthrough for gaming. At the time, that made sense. I even made a full video about it:

{{< youtube id="IDnabc3DjYY" >}}

But that was before Valve's work, Proton, modern Wine and the broader open source community pushed desktop Linux to a much better place. These days you can avoid Windows for most cases. In the video below I explain the evolution of CPUs, GPUs, OpenGL, Vulkan and how we got here:

{{< youtube id="JEp7ozWqIps" >}}

My dedicated gaming mini-PC with an RTX 4090 is still my main Steam machine, especially now that I have a [proper sim racing cockpit](/en/2026/04/01/my-sim-racing-cockpit-formula-fx1/). On that machine I use [EmuDeck](https://www.emudeck.com/), which was originally built to automate emulator installation and configuration on the Steam Deck, later added Windows support, and helps a lot in reducing the pain of assembling this kind of setup. But my main desktop is far too powerful to leave idle. It has an RTX 5090, and these days I mostly use that GPU to test LLMs and run benchmarks, as I explained in [Testing Open Source and Commercial LLMs](/en/2026/04/05/testing-llms-open-source-and-commercial-can-anyone-beat-claude-opus/). It would be a waste not to use it for gaming too.

But on Linux I wanted something else. I didn't want a black box doing everything for me without me knowing exactly what had been changed, especially on my main PC, which is my work machine. I wanted a setup of my own, "done by hand" in the right sense of the phrase: not clicking through one GUI after another, but actually understanding what is being configured, keeping the files under my control, and being able to rebuild everything the way I like it. I know the NixOS crowd will jump in here to say "just use Nix", but I'm still not convinced I need yet another layer of complication in my life. And now, with Claude Code, I honestly think I need that even less. I also didn't want to turn my work machine into a carnival of emulator packages, GTK themes, wrappers, launchers, odd runtimes and configs buried all over `~/.config`. I didn't want dual boot or a VM either. In 2026, the best answer for this, in my opinion, is [Distrobox](https://distrobox.it/).

As the project itself explains, Distrobox is a wrapper around `podman`, `docker` or `lilipod` to create containers that are tightly integrated with the host, with access to `HOME`, Wayland/X11, audio, USB devices, external storage and GPU. In other words: exactly the kind of pragmatic isolation I wanted. It is not a security boundary, and the official site is explicit about that. Don't use it expecting a high-security sandbox. Use it when you want separate environments without paying the cost of a VM.

And before someone repeats the usual confusion: a container is not a virtual machine. I explain that carefully in this other episode:

{{< youtube id="85k8se4Zo70" >}}

## The plan

The idea was simple: create a vanilla Arch Linux install inside a Distrobox called `gaming`, mount my NAS paths read-only, keep the Steam library available where it made sense, and install all my favorite emulators inside it. Since the container has access to the NVIDIA GPU, audio, USB and the rest of the peripherals, I can separate work from games on the same machine without any practical performance penalty.

The initial bootstrap looked roughly like this:

```bash
distrobox create --name gaming --image archlinux:latest --nvidia \
  --home /mnt/data/distrobox/gaming \
  --volume /mnt/data/steam:/mnt/data/steam \
  --volume /mnt/terachad/Emulators:/mnt/terachad/Emulators:ro
```

And yes, even that starting point already has traps. `archlinux:latest` inside Distrobox came without `[multilib]` in `pacman.conf`, with a broken `sudoers` setup, and with the old `--nvidia` issue: the host driver libraries are bind-mounted read-only, so any install that depends on `nvidia-utils` breaks on file conflicts. Just that much was already enough to send me, a few years ago, into half a dozen browser tabs, a bunch of terminals, and a full night of trial and error.

This time I did it differently.

## Claude Code as an infrastructure assistant

I've become more and more comfortable using Claude Code as my infrastructure assistant on my personal machines. I would not do this blindly on a client's server. But on my own hardware, in an environment I can destroy and rebuild as many times as I want, it makes perfect sense. I wrote about that in [Migrating my Home Server with Claude Code](/en/2026/03/31/migrating-my-home-server-with-claude-code/), where I used Claude to install and configure openSUSE MicroOS, Docker, NFS, firewall hardening and the rest without having to remember annoying shell commands.

So I thought: why not do the same thing here?

That's exactly what I did. I started with a sequence of very objective prompts, always asking for two things at once: do the work, and document enough of it so I could rebuild everything later. The most important record of that lives in [`docs/distrobox-gaming-prompts.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/distrobox-gaming-prompts.md).

But one important clarification: those prompts on GitHub are not my raw messages exactly as I typed them during the sessions. After everything was working, I asked Claude itself to rewrite the prompts into a much more organized and detailed form purely for documentation purposes. The original prompts were much simpler and much less specific. In practice, I would describe the goal and let Claude figure out the paths, config files, formats and commands on its own.

The first prompt created the box with `--nvidia`, a separate `--home`, and the right mounts. The second fixed the three classic Arch-in-Distrobox problems: `sudo`, `multilib`, and the `nvidia-utils` dummy package. The third installed the gaming base stack, including one detail I easily could have forgotten if I were doing it manually: `pipewire-pulse`, which is necessary so several emulators don't go silent or lose audio timing.

Here's a real excerpt from the kind of prompt I used:

```text
The distrobox gaming container is created. I need you to fix three known issues
with archlinux:latest in distrobox, IN THIS ORDER...

1. PASSWORDLESS SUDO
2. MULTILIB
3. NVIDIA-UTILS DUMMY
```

The point is not the exact wording. The point is the method. I didn't have to remember the exact order, the exact flags, or where the documentation for each detail lived. I described the objective and let the agent carry the weight. I stayed in the tech lead role: watching, reviewing, correcting direction when needed, and telling it to continue.

## From prompts to reusable scripts

Once the setup stopped being an experiment and became a known-good configuration, I turned it into a public project: [akitaonrails/distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming).

The entry point is intentionally boring:

```bash
cp config/distrobox-gaming.env.example config/distrobox-gaming.env
$EDITOR config/distrobox-gaming.env
./bin/dg check
./bin/dg create
./bin/dg bootstrap
./bin/dg configure
./bin/dg verify
```

Or, if you want the straight path:

```bash
./bin/dg all
```

The [`bin/dg`](https://github.com/akitaonrails/distrobox-gaming/blob/master/bin/dg) script only orchestrates the phases. The real work lives in the scripts and docs:

- [`docs/distrobox-gaming-prompts.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/distrobox-gaming-prompts.md)
- [`docs/rebuild-runbook.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/rebuild-runbook.md)
- [`docs/controller-hotkeys.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/controller-hotkeys.md)
- [`docs/flycast-resolution.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/flycast-resolution.md)
- [`docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md)

If you want to see where the practical part actually lives, the files that matter most are [`scripts/05-seed-configs.sh`](https://github.com/akitaonrails/distrobox-gaming/blob/master/scripts/05-seed-configs.sh), [`scripts/07-configure-es-de.sh`](https://github.com/akitaonrails/distrobox-gaming/blob/master/scripts/07-configure-es-de.sh) and [`scripts/08-verify.sh`](https://github.com/akitaonrails/distrobox-gaming/blob/master/scripts/08-verify.sh). That's where muscle memory turns into code.

That was the real gain. Instead of an artisanal setup that only exists in my head, I ended up with a reproducible process.

## What used to be manual GUI work is now automation

This was the part that interested me the most.

Years ago, to get `RPCS3` into a usable state, I would open the GUI and go game by game. Installing DLC was even worse. `RPCS3` itself blocks `--installpkg` in `--no-gui` mode, so the obvious automation path doesn't work. The solution was to ignore the GUI and extract the PKGs straight into `dev_hdd0/game/` with a Python script. That's documented in prompt 11 and in the repo itself:

```bash
python3 /mnt/data/distrobox/gaming/scripts/extract_ps3_dlc.py \
  "/mnt/terachad/Emulators/EmuDeck/roms_heavy/ps3-DLC" \
  --dest "/mnt/data/distrobox/gaming/.config/rpcs3/dev_hdd0/game"
```

So instead of clicking through dozens of windows, the process became a batch job. More importantly, a repeatable one.

For Switch the story was similar. In the old days I would open `Ryujinx`, now `Eden`, and go game by game installing updates, DLC, cheats, fixing the `keys` directory, checking firmware, and so on. Now that is described in prompts and converted into automated steps. `prod.keys` and `title.keys` go to the right place, Atmosphere-format cheats are linked into `~/.local/share/eden/load/<TITLE_ID>/cheats/`, and `ES-DE` already launches the right wrapper, including the detail of unsetting `QT_STYLE_OVERRIDE` because `eden-bin` conflicts with `Kvantum`.

`Dolphin` was always the king of manual friction. If you use a modern controller like my 8BitDo Ultimate 2, you need to remember how I like the GameCube mapping, how I adapt the Wii Remote, when to use the Nunchuk profile, and when to switch to Classic Controller. I have no patience left for rebuilding that by hand every single time. So I left ready-made profiles and seeded configs. The details are in [`docs/controller-hotkeys.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/controller-hotkeys.md). I no longer need to spend half an hour fishing through obscure controller menus.

## A few bumps on the way

Not everything turned into magic. Emulation always has banana peels lying around.

`Flycast`, for example, wasted time with one particularly irritating trap. The `emu.cfg` file uses `rend.*` keys inside the `[config]` section. If you create a separate `[rend]` section, it looks right, but the emulator simply ignores it and later rewrites everything back to mediocre defaults. The fix is documented in [`docs/flycast-resolution.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/flycast-resolution.md) and eventually became a wrapper:

```bash
$DG_BOX_HOME/bin/flycast-hires \
  -config config:pvr.rend=4 \
  -config config:rend.Resolution=2880 \
  -config config:rend.EmulateFramebuffer=no \
  -config config:rend.WideScreen=yes
```

That kind of detail is exactly the kind of thing I hate rediscovering by myself every rebuild.

`shadPS4` is still far from a solved case. The current setup is focused on `Driveclub`, with mirrored config files, patch XML and firmware 11.00 `sys_modules` links. And that wasn't accidental: I really love `Driveclub`. In fact it's basically the only PS4-locked game I still really want to play properly. I've seen several YouTube videos of it running, but I still haven't managed to get it working satisfactorily myself on Linux. That is also documented in [`docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md). The good part is that I no longer depend on muscle memory to remember how to launch it, with which patch, from which folder, and with which modules. The bad part is that PS4 emulation is still PS4 emulation. There is no script that can make upstream mature faster. If anyone knows how to close this configuration properly on Linux, check the GitHub project and send a PR.

There was also a lot of fine tuning for my own machine: Vulkan everywhere it makes sense, aggressive internal resolution where the RTX 5090 can handle it, anisotropic filtering, widescreen hacks where they don't wreck the image, less painful shader compilation, and decent frame pacing on my 1440p 120Hz monitor. In other words: I stopped accepting generic defaults and started seeding defaults designed for my hardware.

## The real gain is not just automation

It would be easy to reduce all this to "look, I used AI to automate shell scripts." That's not it.

The real gain is more boring and more important: I stopped spending mental energy on grunt work. I didn't need to remember rare commands anymore. I didn't need to keep dozens of tabs open with wikis, issues, forums and READMEs. I didn't need half a dozen terminals running `tail` on logs while I tried to remember which hidden GUI option the emulator insists on rewriting on first boot. I moved to working in conversation.

I tell the agent the objective. It searches the files, reads the logs, finds the right config format, compares defaults, proposes fixes, writes scripts, validates paths, checks UID/GID, finds broken symlinks, generates wrappers, exports launchers. I'm still responsible for the decisions, obviously. But I stopped being a typist for rare commands.

That's the part that interests me most about coding agents on Linux. They drastically reduce the entry friction. A lot of people give up on desktop Linux not because the system is incapable, but because the tuning curve has historically been too annoying. Having an assistant that can read docs, cross-reference configs, propose automation and execute under supervision changes that.

## If you prefer scripts, they are there

If you're the kind of person who prefers traditional automation with no agent involved, fine. The repo was published exactly for that. The idea is that anyone should be able to clone it, adjust the environment file, and run the process:

```bash
git clone https://github.com/akitaonrails/distrobox-gaming.git
cd distrobox-gaming
cp config/distrobox-gaming.env.example config/distrobox-gaming.env
./bin/dg all
```

Read the [`README.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/README.md) and [`docs/rebuild-runbook.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/rebuild-runbook.md) first. I don't distribute ROMs, BIOS files, firmware or keys. The repo only detects, links and configures what you already have on your own machine.

## If you prefer the Claude Code route

My recommendation is simple:

1. Start with the objective, not the command. "I want an Arch distrobox with NVIDIA GPU access, separate home, read-only ROM mounts and Steam rw" is better than dropping half a shell line with no context.
2. Always ask it to document what it's doing. If it works, promote the result into a script. If you don't document it, you just manufactured disposable duct tape.
3. Work in phases. Create the box. Bootstrap. Configure the emulators. Export the launchers. Verify. That's exactly how I broke the problem down.
4. Ask for objective verification. `command -v`, file existence, broken symlinks, UID/GID, ROM paths, audio, GPU. The best automation fails early.
5. Don't use the agent as a command parrot. Use it as a technical assistant. You are still reviewing the decisions and telling it how to adjust course.

For me, that was the win. I went from zero to a much more complete emulation machine without having to customize everything manually, in GUIs, one window at a time. And this time, I still had the energy left to do what I wanted from the start.

Play.
