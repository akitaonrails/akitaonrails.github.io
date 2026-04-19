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
  - ansible
  - claude-code
  - AI
---

I've loved old videogames since before many of you were born. My first contact was back in the Atari era, in the early 80s. Then came the 8-bit micros, the 90s arcades, the 16, 32 and 64-bit consoles, and I kept following all of it. For me, nostalgia is not a cute Instagram folder. It's an archive. ROMs, BIOS files, dumps, patches, DLC, firmware, saves. Over the years I kept everything on my NAS. At this point I have terabytes of it under `/mnt/terachad/Emulators`.

On my YouTube channel I even used old games to teach computer science fundamentals. In [this Akitando episode about Super Mario and old computers](https://www.youtube.com/watch?v=hYJ3dvHjeOE&pp=ygUUYWtpdGFuZG8gc3VwZXIgbWFyaW8%3D), I explain the 6502, memory maps, the PPU, hardware constraints, and why those games were programmed the way they were. If you never watched it, start there:

{{< youtube id="hYJ3dvHjeOE" >}}

The problem is always the same: every few years I decide to set up a new emulation machine, download the main emulators again, and there I go repeating the same masochistic ritual. `PCSX2`, `RPCS3`, `Eden`, `Azahar`, `Dolphin`, `RetroArch`, `Flycast`, `shadPS4`, and so on. Each one with its quirks. Each one with its own particular way of wasting hours of your life.

In theory, setting all this up should be fun. In practice, it takes days. And that's not an exaggeration. `Dolphin` still manages to be one of the worst because GameCube and Wii controller setups have no standard. `RPCS3` requires per-game tuning. `Eden` needs DLC, updates and cheats in the right place. `shadPS4` is a festival of trial and error. When I'd finally finish configuring everything, I didn't feel like playing anything anymore. I just wanted to close the menus and go do something else.

I've been known to say that maybe the fun was the tuning itself. I don't think that anymore. After repeating this process too many times, I'm done. I want to play the games, not fill out forms hidden inside emulator GUIs.

## The problem was never Linux

I've solved this kind of thing in different ways in the past. Years ago I ran Linux on the host and a virtualized Windows with GPU passthrough to play inside the VM. At the time that made sense. I made a whole video about it:

{{< youtube id="IDnabc3DjYY" >}}

But that was before Valve, Proton, modern Wine and the whole open source community pushed the Linux desktop to a much better place. Today you can avoid Windows in most cases. In the other video below I explain the evolution of CPU, GPU, OpenGL, Vulkan, and why we ended up here:

{{< youtube id="JEp7ozWqIps" >}}

My gaming mini-PC with the RTX 4090 is still my main Steam machine, especially now that I've built a [proper sim racing cockpit](/en/2026/04/01/my-sim-racing-cockpit-formula-fx1/). On it I use [EmuDeck](https://www.emudeck.com/), which was born to automate installing and configuring emulators on the Steam Deck, then grew Windows support, and helps cut the complexity of setting up this kind of environment. But my main desktop is also way too powerful to leave underused. It has an RTX 5090, and today I use that GPU mostly to test LLMs and for benchmarking, as I wrote in [Testing Open Source and Commercial LLMs](/en/2026/04/05/testing-llms-open-source-and-commercial-can-anyone-beat-claude-opus/). Leaving it idle for gaming would be a waste.

Only on Linux I wanted something else. I didn't want a black box doing everything for me without me knowing exactly what was being changed, especially on my main PC, which is my work machine. I wanted my own setup, handmade in the right sense: not clicking GUI by GUI, but understanding what's being configured, keeping the files under my control, and being able to rebuild everything the way I like. I know the NixOS folks will jump in here to say "just use Nix" — I'll explain why I ruled that out below. I also didn't want to turn my work machine into a carnival of emulator packages, GTK themes, wrappers, launchers, weird runtimes and configs buried in `~/.config`. Nor did I want dual boot or a VM. In 2026, the best answer for this, in my opinion, is [Distrobox](https://distrobox.it/).

From what the project itself explains, Distrobox is a wrapper on top of `podman`, `docker` or `lilipod` to create containers tightly integrated with the host, with access to `HOME`, Wayland/X11, audio, USB devices, external storage and GPU. In other words: exactly the kind of pragmatic isolation I wanted. It's not a security boundary, and the project site makes that clear. Don't use it thinking about high-security sandboxing. Use it thinking about separating environments without paying the price of a VM.

And before anyone repeats the usual confusion: a container is not a virtual machine. I explain this calmly in this other episode:

{{< youtube id="85k8se4Zo70" >}}

## The setup

The idea is simple: a vanilla Arch Linux inside a Distrobox called `gaming`, with NAS paths mounted read-only, Steam library accessible where it makes sense, and all emulators installed inside. Since the container has access to the NVIDIA GPU, audio, USB and other peripherals, I can separate work and gaming on the same machine without practical performance penalty.

The initial bootstrap looks roughly like this:

```bash
distrobox create --name gaming --image archlinux:latest --nvidia \
  --home /mnt/data/distrobox/gaming \
  --volume /mnt/data/steam:/mnt/data/steam \
  --volume /mnt/terachad/Emulators:/mnt/terachad/Emulators:ro
```

Even that first step has a catch. `archlinux:latest` inside Distrobox comes without `[multilib]` in `pacman.conf`, with a misconfigured `sudoers`, and with the old `--nvidia` problem: the host driver libs get bind-mounted read-only, so any install that depends on `nvidia-utils` breaks with file conflicts. Just that alone is the kind of headache that, a few years ago, would make me open half a dozen tabs, a bunch of terminals, and spend a whole night in trial and error.

This time I did it differently.

## Claude Code as an infrastructure assistant

I've been getting more and more comfortable using Claude Code as my infrastructure assistant on my personal machines. I wouldn't do this blindly on a client server. But on my own machine, in an environment I can destroy and rebuild however many times I want, it makes all the sense in the world. I wrote about this in [Migrating my Home Server with Claude Code](/en/2026/03/31/migrating-my-home-server-with-claude-code/), when I used Claude to install and configure openSUSE MicroOS, Docker, NFS, firewall, hardening, and all the rest without me having to remember annoying shell commands.

So I thought: why not do the same thing here?

That's exactly what I did. I started with a sequence of objective prompts, always asking for two things at once: do the work, and document enough for me to rebuild everything later. The most important history ended up in [`docs/distrobox-gaming-prompts.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/distrobox-gaming-prompts.md).

A clarification worth making: those prompts on GitHub aren't my raw messages, the way they came out in real time. After everything worked, I asked Claude itself to rewrite the prompts in a much more organized and detailed way, purely for documentation. The original prompts were much simpler and much less specific. I described the goal and let Claude figure out paths, config files, formats and commands on its own.

The first prompt created the box with `--nvidia`, a separate `--home`, and correct mounts. The second solved the three classic problems of Arch inside Distrobox: `sudo`, `multilib`, and the `nvidia-utils` dummy package. The third installed the gaming base, including a detail I would have easily forgotten if I was doing it by hand: `pipewire-pulse`, needed so several emulators don't end up mute or out of sync.

The point isn't the text itself. The point is the method. I don't need to remember the exact order, the precise options, or where the docs for each detail are. I describe the goal and let the agent carry the piano. I stay in the tech-lead role: watching, reviewing, course-correcting when needed, and telling it to keep going.

## The GitHub project

The setup lives in [akitaonrails/distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming), structured as an Ansible project. 17 roles cover everything from box creation, package bootstrap, config seeding, DLC installation, controller setup, to post-setup verification. The main playbooks are:

- `site.yml`: full setup from scratch
- `reset-configs.yml`: reset configs only (useful when you want to wipe tuning and redeploy)
- `backup.yml` / `restore.yml`: container snapshot and restore via `podman commit`
- `refresh-shadps4.yml`: standalone shadPS4 update
- `install-xenia.yml`: optional Xenia Manager install (Wine prefix)

Full walkthrough is in [`docs/rebuild-runbook.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/rebuild-runbook.md). Package decisions (why AUR instead of Flatpak, for example) are in [`docs/distrobox-gaming-packages.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/distrobox-gaming-packages.md).

### Why not Nix?

Someone will ask. "You're recreating a reproducible environment. Why not use NixOS, or at least `nix-shell`/flakes?"

I considered and ruled it out. The emulator ecosystem I need lives on the AUR. AUR `-bin` packages are wrappers around AppImages that ship the official upstream binary without compiling anything. `rpcs3-bin`, `pcsx2-latest-bin`, `eden-bin`, `duckstation-qt-bin`, `shadps4-bin` — these binaries track upstream practically on release day. On Nixpkgs, many of these emulators are weeks or months behind release, and some don't exist. Creating a Nix overlay for every emulator I need, maintaining it, and dealing with compatibility patches when upstream changes is work I don't want to have.

There's also the mental model. I don't want to learn the Nix language, the derivation system and the evaluation model just to set up a personal gaming environment. I already know Ansible, roles are folders with YAML tasks, and debugging is `ansible-playbook -vvv`. When something goes wrong, I read the error, open the task that failed, and know exactly where to fix it. If I needed the same level of reproducibility at scale, across a cluster, with atomic rollback, then Nix would have an argument. For a distrobox with emulators on my personal machine, Ansible solves it with much less friction.

Flatpak was also tested and ruled out. Flatpak's `bwrap` (bubblewrap) doesn't nest properly inside Docker's mount namespaces, so Flatpak apps simply don't run inside distrobox. The alternative would be installing Flatpak on the host, but then you're back to polluting the work machine with gaming packages. Plus, Flatpak versions of emulators lag well behind AUR — the AUR's `pcsx2-latest-bin` tracks the 2.7.x AppImage, while Flathub still ships v2.6.3.

## Platforms covered

The setup covers 12 platforms today:

| Platform | Emulator | Renderer | Highlight |
|---|---|---|---|
| PS1 | DuckStation | Vulkan, 8x upscale | JINC2 filter, PGXP, widescreen hack |
| PS2 | PCSX2 2.7.x | Vulkan, 4x SSAA | FXAA + PCRTC antiblur, Xbox bindings |
| PS3 | RPCS3 | Vulkan | Curated per-game configs via API |
| PS4 | shadPS4 | Vulkan | Driveclub-focused (experimental) |
| PS Vita | Vita3K | — | Default seeding |
| GameCube | Dolphin | Vulkan | 8BitDo Ultimate 2 profiles |
| Wii | Dolphin | Vulkan | Classic Controller + Nunchuk |
| Wii U | Cemu | Vulkan | Baseline seed only-if-missing |
| Switch | Eden | Vulkan | Atmosphere DLC + cheats |
| Dreamcast | Flycast | Vulkan, 2880p | Hi-res wrapper, widescreen |
| OG Xbox | xemu | — | BIOS/HDD via symlink |
| Xbox 360 | Xenia (Wine) | Vulkan | Project Forza Plus, PGR3/4 |

RetroArch comes on top to cover the rest (NES, SNES, Genesis, N64, arcade, etc.), with 21 buildbot cores and 8 asset packs (databases, shaders, cheats, overlays, autoconfig).

Frontend is [ES-DE](https://es-de.org/). Custom system definitions live in `ansible/group_vars/all/esde.yml`, and each emulator comes with a wrapper that sets the right GPU environment variables (more on that in a sec).

## GPU hardforce for NVIDIA

On a hybrid system with NVIDIA dGPU + AMD iGPU (my case on the desktop), Vulkan sometimes picks the iGPU on its own and you end up with an emulator running at 15 fps while the 5090 sits idle. The fix is to force NVIDIA's Vulkan ICD in every launcher.

Each desktop entry rendered by Ansible exports `VK_ICD_FILENAMES` pointing to NVIDIA's ICD, and the ES-DE wrapper does the same before launching any core. Combined with the `--nvidia` flag at box creation, which bind-mounts host drivers read-only, the result is predictable: Vulkan always on the NVIDIA dGPU, regardless of system state at runtime.

This mostly matters for hybrid setups. On a desktop with a single GPU, the ICD filtering is placebo, but it doesn't hurt.

## PS2: PCSX2 with per-game tuning

The Gran Turismo line is my declared addiction. Each version needs its own specific tweak. The PCSX2 setup today has sane global configs (Vulkan, 4x SSAA, widescreen 16:9, Xbox-style bindings, FXAA + PCRTC antiblur, 16x anisotropic, Automatic deinterlace) and per-game INIs for the titles I actually play:

- **Gran Turismo 3 A-spec** (SCUS-97102 + bundle PBPX-95503): widescreen pnach, optional retexture pack (disabled by default because NFS streaming causes flicker in car-showcase cutscenes)
- **Gran Turismo 4 USA** (SCUS-97328): Silentwarior112 HD HUD, full retexture pack, Silent's trigger/cam patches, widescreen pnach
- **Gran Turismo 4 Spec II** (SCUS-97436, CRC `4CE521F2`): special case — the vanilla GT4 HD packs are linked via symlink because Spec II has the same structure but a different CRC. Widescreen pnach renamed to match the CRC. Deinterlace mode 8 (Adaptive TFF), ShadeBoost tuning (+10 saturation, +3 brightness, +2 contrast) to fix pause-interlace ghosting and the anemic upscale saturation
- **Enthusia Professional Racing** (SLUS-20967): HD textures + widescreen
- **Ridge Racer V** (SLUS-20002): widescreen + no-interlace pnach

Silent's and community pnach files are downloaded automatically by the `pcsx2_textures` role, which also deploys the cheats pack from the NAS and installs the Spec II HD packs via symlink. Widescreen is enabled per-CRC via `gamesettings` (PCSX2 identifies games by CRC before applying pnach).

On PCSX2 versioning: the AUR's `pcsx2-latest-bin` tracks the 2.7.x line, which is where all the modern features live (texture replacement, FXAA, PCRTC antiblur). The default `pcsx2` in Arch repos is still on 2.6.3. The gap is over 250 commits of fixes and new features.

## PS3: RPCS3 with curated per-game configs

RPCS3 has an annoying detail: per-game configs live in `~/.config/rpcs3/custom_configs/config_<SERIAL>.yml`. The file format has a version, and if you hand-write YAML with the wrong version, RPCS3 silently rejects it and falls back to defaults. That cost me time to figure out.

The `rpcs3_per_game_configs` role handles it like this:

1. Queries the [RPCS3 community compatibility DB](https://rpcs3.net/compatibility) for recommended presets per title
2. Applies curated overrides on top for titles I know need specific tuning (typically GT5 and GT6)
3. Saves the YAML with the exact filename convention (`config_<SERIAL>.yml`, `config_` prefix mandatory)

For the Gran Turismo line:

- **GT5** (BCUS98114, BCES00569): Resolution Scale 300%, Shader Precision Ultra, Force High Precision Z, SPU XFloat Accurate, Multithreaded RSX. The combo kills the typical RSX dithering without breaking the GT-series safety config (WCB/RCB off).
- **GT6** (BCES01893 + regional variants): special case, **version pinned to v1.05**. Patches 1.06+ regress with black surfaces on cars in the garage menu. The `extract_ps3_dlc.py` script has a per-title PATCH ceiling specifically to pin GT6 at 1.05 even when PSN serves newer patches. Also, Force CPU Blit is mandatory (without it, full-screen flicker). The trade-off is that the rear-view mirror stays permanently black — turning WCB on would restore the mirror but downgrade to native 720p. I'll take no mirror.

More details on those two in [`docs/gt5-rpcs3.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/gt5-rpcs3.md) and [`docs/gt6-rpcs3.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/gt6-rpcs3.md).

### PS3 update checker

To avoid opening RPCS3's GUI and clicking `Download Game Updates` game by game, I wrote a Python script: `check_ps3_updates.py`. It walks the games installed in `dev_hdd0/game`, parses `PARAM.SFO` to get the current version per title, queries the PSN update server (`a0.ww.np.dl.playstation.net`), and compares against the local patch cache. `--list` shows the diff; `--download` fetches what's missing. `--max-version` respects per-title ceilings (e.g., 1.05 for GT6).

The first scan of my library found 51 of 72 games with updates available, 69 patches missing locally, ~24 GB in total. GT6 alone had 16 missing patches from 1.07 to 1.22, which I skipped for the reasons above.

Patches arrive as PSN packages type 0x0001 without encryption, so `extract_ps3_dlc.py` handles the install. Standard call:

```bash
distrobox enter gaming -- python3 scripts/extract_ps3_dlc.py \
  "/mnt/terachad/Emulators/EmuDeck/roms_heavy/ps3-DLC" \
  --dest "/mnt/data/distrobox/gaming/.config/rpcs3/dev_hdd0/game"
```

Tracking PS3 DLC versions manually, game by game through RPCS3, is impractical. It becomes an infinite to-do list, and you only find out there was a 1.22 patch when the game crashes.

## PS1: DuckStation per-game

The Gran Turismo trilogy starts on PS1, and quality there only goes up if you enable the right things:

- **Gran Turismo** (SCUS-94949): DuckStation's built-in WidescreenHack (no cheat exists for this game), PGXP enabled
- **Gran Turismo 2 Simulation** (SCUS-94455): widescreen cheat + 8 MB RAM cheat (fixes audio issues on crowded tracks), JINC2 filter
- **Gran Turismo 2 Arcade** (SCUS-94488): same treatment as Simulation

Global defaults: Vulkan, 8x upscale, JINC2 as the default filter.

GT2 cheats come from a widescreen-fixes repo and are linked automatically into DuckStation's cheats folder.

## Switch: Eden with DLC, update and cheats

On Switch, `eden-bin` is the emulator. The integration automates three things I used to do by hand:

1. **DLC and update install**: the `install_dlcs` role points to the dumps directory on the NAS, identifies `.nsp`/`.nsz`/`.xci`/`.xcz` files, and installs everything into `~/.local/share/eden/nand/user/Contents/registered/`. If the dump is messy (patches and DLC mixed in a flat folder), the `reorganize_switch_nsps.py` script sorts everything by Title ID first.

2. **Atmosphere cheats**: Atmosphere-format cheats get symlinked into Eden's load path (`~/.local/share/eden/load/<TITLE_ID>/cheats/`). The `switch_cheats` role handles this for every title covered by the NAS pack.

3. **Update checker**: `check_switch_updates.py` lists titles with updates available against what's installed locally. Useful so I don't miss important patches for games still getting updates.

A detail that burned me: `QT_STYLE_OVERRIDE` needs to be unset before launching `eden-bin`, otherwise it conflicts with Kvantum and breaks the UI. The wrapper does the `unset` before `exec`.

## Xbox 360: Xenia Manager via Wine

Xbox 360 is still rough territory on Linux. There's no decent native emulator. The best route today is [Xenia](https://xenia.jp/) running through Wine, managed by [Xenia Manager](https://github.com/xenia-manager/xenia-manager).

This is opt-in in my setup. The `install-xenia.yml` playbook creates a dedicated Wine prefix, downloads Xenia Manager, and registers launchers. It's not part of the main `site.yml` because not everyone wants Wine in the mix.

### Project Forza Plus (Forza Motorsport 2/3/4)

Old Forza is still the king of previous-gen simcade. Running FM2/3/4 on Xenia requires the Project Forza Plus community mods: compatibility patches, performance mods, specific title-update installs. I documented the process in [`docs/project-forza.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/project-forza.md).

### Project Gotham Racing 3 and 4

PGR3 runs reasonably well on Xenia Canary. PGR4 needs a specific tweak: `render_target_path_vulkan = "fsi"` in the config, otherwise some races break with visual artifacts. Setup documented in [`docs/xbox360-pgr.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/xbox360-pgr.md). PGR4 audio on NVIDIA still has an XMA decoding issue that produces intermittent garbage. There's an open xenia-canary issue, no resolution so far.

### Batch Title Updates

Title Updates for Xbox 360 games were distributed via Xbox Live, which has been shut down. The alternative is archive.org, which has the complete catalog preserved. I wrote `scripts/download-xbox360-tus.py` to automate:

```bash
distrobox enter gaming -- python3 scripts/download-xbox360-tus.py \
  --src /mnt/terachad/Emulators/EmuDeck/roms_heavy/xbox360 \
  --dest /mnt/terachad/Emulators/EmuDeck/roms_heavy/xbox360-updates \
  --dry-run
```

The script needs the `internetarchive` CLI authenticated (`ia configure` once, stores the token). It scans the games folder, matches against the archive.org manifest (cached locally), prioritizes by region (USA > World > Europe > Japan), and downloads via `ia download --checksum` with automatic retry. The resulting .zip files go to Xenia Manager via `Manage → Install Content`, which extracts into the correct directory (`000B0000/`).

Full setup in [`docs/xbox360-title-updates.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/xbox360-title-updates.md).

## Steam in the distrobox

Since Proton became a first-class citizen on Linux, it makes sense to have Steam in the gaming box too. I added the `steam` package via Ansible (which pulls in multilib and 32-bit deps), mounted `/mnt/data/steam` read-write so the library persists outside the container, and created a host-side launcher.

In practice, this lets me run Steam games via Proton side-by-side with emulation, without switching environments. The mini-PC with the RTX 4090 is still the main Steam machine in the sim racing cockpit. The desktop is fallback and a test environment.

## Shell and controllers

### Minimal in-box shell

When I `distrobox enter gaming`, I want a decent prompt even for quick troubleshooting. I installed `zsh` + `starship` with a minimal config, zero exotic plugins. It's not my full dev setup, it's just "a prompt that shows path and git branch without embarrassing me".

### Dolphin and the modern-controller hell

`Dolphin` has always been the king of manual friction. If you use a modern controller, like my 8BitDo Ultimate 2, you have to remember how I like the GameCube mapping, how I adapt the Wii Remote, when to use a Nunchuk profile, when to switch to Classic Controller. I don't have the patience to rebuild that by hand every time. Profiles are pre-built in `config/emulator-overrides/dolphin/Profiles/` and copied by the `seed_configs` role. Details in [`docs/controller-hotkeys.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/controller-hotkeys.md).

## A few stumbles that stuck around

Not everything became magic. Emulation always has banana peels.

`Flycast`, for example, has an irritating trap. The `emu.cfg` file uses `rend.*` keys inside the `[config]` section. If you create a separate `[rend]` section, it looks right, but the emulator just ignores it and later rewrites everything with mediocre defaults. The fix became a dedicated wrapper at `$DG_BOX_HOME/bin/flycast-hires`:

```bash
$DG_BOX_HOME/bin/flycast-hires \
  -config config:pvr.rend=4 \
  -config config:rend.Resolution=2880 \
  -config config:rend.EmulateFramebuffer=no \
  -config config:rend.WideScreen=yes
```

Details in [`docs/flycast-resolution.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/flycast-resolution.md).

`shadPS4` is still far from a closed case. The current setup is focused on `Driveclub`, with a mirrored config, XML patch and sys_modules links from firmware 11.00. And that wasn't random: I really like `Driveclub`. It's practically the only game still stuck on PS4 that I really wanted to get running properly. I've seen several YouTube videos showing the game working, but so far I haven't been able to get it running satisfactorily on Linux myself. Documented in [`docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md). The good part is that I no longer depend on muscle memory to remember how to launch it, with which patch, in which folder, with which modules. The bad part is that PS4 emulation is still PS4 emulation. No script makes upstream mature faster. If anyone knows how to close this setup on Linux, check the project on GitHub and send a PR.

Ridge Racer V has car-texture flickering documented in PCSX2 issues (#3639, #13729). The Hardware renderer is acceptable for a racing game where you're not standing still admiring the model. Software renderer fixes it but kills performance. I chose to live with the flicker.

## The real gain isn't just automation

It'd be easy to sum this up as "look how cool, I used AI to automate shell scripts". That's not it.

The real gain is more mundane and more important: I stopped spending mental energy on manual work. I didn't have to remember rare commands. I didn't have to keep dozens of tabs of wiki, issue, forum, README. I didn't have to leave half a dozen terminals scattered tailing logs while I try to remember which hidden GUI option the emulator insists on overwriting on the first boot. I started working in conversation.

I tell the agent the goal. It looks up the files, reads the logs, finds the right config format, compares defaults, proposes fixes, writes scripts, validates paths, checks UID/GID, verifies broken symlinks, generates wrappers, exports launchers. I'm still responsible for decisions, of course. But I stopped being a typist of rare commands.

That's the point that interests me most about using coding agents on Linux. They dramatically reduce the entry friction. A lot of people bounce off the Linux desktop not because the system is incapable, but because the tuning curve has historically been too irritating. Having an assistant capable of reading docs, cross-referencing configs, proposing automation and executing under supervision changes that game.

## If you want to reproduce

The repo was published for this:

```bash
git clone https://github.com/akitaonrails/distrobox-gaming.git
cd distrobox-gaming/ansible
ansible-galaxy collection install -r collections/requirements.yml
cp host_vars/localhost.yml.example host_vars/localhost.yml
$EDITOR host_vars/localhost.yml  # adjust paths for your machine
ansible-playbook site.yml
```

Xenia is opt-in:

```bash
ansible-playbook install-xenia.yml
```

Read the [`README.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/README.md) and [`docs/rebuild-runbook.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/rebuild-runbook.md) first. I don't distribute ROMs, BIOS, firmware or keys. The repo only detects, links and configures what you already have on your own machine.

## If you prefer the Claude Code route

My recommendation is simple:

1. Start with the goal, not the command. "I want an Arch distrobox with NVIDIA GPU, separate home, ROMs read-only and Steam rw" beats dumping a half shell command without context.
2. Always ask it to document what it's doing. If it works, promote the result to a script or role. If you don't document, you just manufactured a throwaway hack.
3. Work in phases. Box creation. Bootstrap. Emulator config. Launcher export. Verification. That's exactly how I broke down the problem.
4. Ask for objective checks. `command -v`, file existence, broken symlinks, UID/GID, ROM paths, audio, GPU. The best automation is the one that fails early.
5. Don't use the agent as a command parrot. Use it as a technical assistant. You still review the decisions and tell it to adjust course.

For me, that was the gain. I went from zero to a much more complete emulation machine without having to customize everything by hand, GUI by GUI, one window at a time. And this time, I finished with energy left to do what I wanted from the start.

Play.
