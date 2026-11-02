---
title: "I Fixed Several Old Racing Games Using AI: Colin McRae 1, 3, 4, Sega Rally Revo and Outrun 2006, All the Way to the Screamer Trilogy"
slug: "i-fixed-several-old-racing-games-using-ai"
date: '2026-11-02T09:00:00-03:00'
draft: false
translationKey: consertei-varios-jogos-de-corrida-antigos-usando-ia
description: "The Colin McRae 1 launcher worked so well that I repeated the recipe: in a little over a day I shipped six more launchers, for Colin McRae Rally 3, 04 and DiRT, OutRun 2006, Sega Rally Revo and the Screamer trilogy. I explain why these abandoned games no longer run without hacks, how each launcher rewires graphics, controls and display using Wine, DXVK, dgVoodoo and a modified dosbox, and what can be improved afterwards: 4K, Hor+ widescreen, fps, anisotropic filtering, scalers, color correction in CMR3 and AI-generated HD textures in CMR1. Includes the links, videos, Linux and Windows instructions, and how long each one took."
tags:
- gaming
- retrocomputing
- emulation
- linux
---

In the [previous article](/en/2026/10/29/playing-with-pc-ports-colin-mcrae-rally-1/) I showed my two projects built around 1998's Colin McRae Rally: the **recomp** in Rust, which tries to rebuild the game from scratch, and the **launcher**, a thin layer around the original executable that makes it run at 4K, widescreen and 60 fps on a modern PC.

I liked the launcher's result a lot, and the most interesting part was realizing how easy the recipe was to repeat. So I decided to bring more abandonware back into the modern era. Between the night of October 31 and the early hours of November 2, six more launchers came out, covering eight racing games:

- **Colin McRae Rally 3** (2003)
- **Colin McRae Rally 04** (2004 on PC)
- **Colin McRae: DiRT** (2007)
- **OutRun 2006: Coast 2 Coast** (2006)
- **Sega Rally Revo** (2007)
- the **Screamer** trilogy (1995 to 1997), from the MS-DOS era

All of them replaced the manual installs I used to maintain in my [distrobox-gaming](/en/2026/04/19/my-favorite-retro-racing-games-on-distrobox/) project. For now the goal was just one: an easy, reproducible install, with the game running well.

## The abandonware problem

There are hundreds of games in an abandonware state: there's no official, supported way to play them today. They're not on Steam, not even on GOG. And even some that are on GOG only run properly after a lot of manual tweaking. The Screamer trilogy is an example: GOG sells Screamer and Screamer 2 (Screamer Rally isn't there), and its version ships with a Windows Glide stub that simply doesn't work under DOS.

The reason is that compatibility broke in layers.

MS-DOS games need an emulator. Windows 95/98 games talk to DirectDraw and Direct3D 5, APIs that modern Windows keeps only for compatibility, with bugs and limitations Microsoft no longer prioritizes. 32-bit Windows XP games depend on disc protections like SafeDisc and older versions of SecuROM, which Microsoft [blocked in 2015](https://www.pcworld.com/article/2985806/windows-vista-7-8-update-prevents-some-old-cd-rom-games-from-running.html) for security reasons. On Windows 10 and 11, most of these games won't start without manual configuration, and on Linux the list of tweaks is even longer.

### Two examples of what used to be needed

2007's **Colin McRae: DiRT** looked like this in my old setup:

1. Run the 2007 InstallShield installer interactively, because it has no reliable silent mode.
2. Apply the chain of official patches in order: 1.1, 1.2, 1.21 and 1.22, each with its own wizard.
3. Find out the game opens the menus but **freezes when loading any race** on a 32-thread processor. The EGO engine builds work-distribution maps by core count, and the original maps can't handle that many threads.
4. Apply a community fix, MTFix, which solves it but deletes the configuration cache and resets every graphics option.
5. Remember that, after changing the resolution, the game's "restart now" button just closes the game.

2007's **Sega Rally Revo** had a different list:

- a permanent microstutter in every race, caused by two stacked timing bugs that patch 4.060 introduced;
- a mandatory registry key, without which the game won't open;
- a .NET configurator that doesn't work properly under Wine;
- the main menu crashing if two save files don't exist;
- logo videos that made startup look frozen;
- exclusive fullscreen failing on a 240 Hz monitor, and a black screen on PCs with two GPUs, the integrated one and the dedicated one.

> Most people simply won't do any of that. They give up on the game, and the game dies a little more.

## Decomp, recomp, and why I only built a launcher

The retrogaming hype today is around **decomps** and **recomps**. A decomp rebuilds, from the binary, source code equivalent to the original that compiles back to the same binary, as was done with [Super Mario 64](https://github.com/n64decomp/sm64) and with Ocarina of Time, which became [Ship of Harkinian](https://github.com/HarbourMasters/Shipwright). A recomp automatically translates the binary into C and compiles that as native code, like [N64Recomp](https://github.com/N64Recomp/N64Recomp) does with Nintendo 64 games, which [produced PC ports with ultrawide and high fps](https://tomshardware.com/video-games/nearly-all-nintendo-64-games-can-now-be-recompiled-into-native-pc-ports-to-add-proper-ray-tracing-ultrawide-high-fps-and-more).

The advantage of both is huge: you stop depending on the original binary and can compile the game for any platform, from ARM and Android to Mac. That's what I attempted with the Colin McRae 1 recomp, and it's months of work.

My itch was a different one. I wanted the games I like to be easy to install and maintain in my distrobox. For that, a launcher is enough.

## The concept: rewiring the game at the edges

Every launcher follows the same idea. The original game stays the same, and what changes are its edges with the world, the parts that aged:

- **graphics**: the 1998 or 2003 API now talks to a modern API;
- **input**: Xbox controller, analog triggers and rumble instead of keyboard and game-port joystick;
- **audio and files**: Windows registry, configuration files, saves and caches written correctly before the game opens;
- **display**: picking the right monitor, the right resolution and the window mode that doesn't break.

Each launcher identifies the executable, by hash or by byte signature, refuses unknown versions, and works on a **private copy** of the game. The original folder is never modified; any patch goes only into the copy.

### The compatibility pieces

I wrote almost none of this from scratch. The launchers orchestrate tools the community spent decades building:

- **Wine**: the layer that implements the Windows API on Linux. The launchers for Windows games carry their own Wine 11.20 inside an AppImage.
- **DXVK**: translates Direct3D 8, 9, 10 and 11 to Vulkan. It's what makes DirectX 9 games run fast on Linux.
- **dgVoodoo 2**: a wrapper by developer Dege that takes old graphics APIs (3dfx Glide, DirectDraw, and Direct3D from the early versions up to 9) and translates them to Direct3D 11 or 12. It's like making a 2003 game think it's on a period card while it runs on a modern one.
- **dosbox-staging**: a modern DOS emulator, with emulation of the 3dfx Voodoo card.
- **gamescope**: Valve's compositor that runs the game on its own screen and handles scaling to the monitor.
- **community patches and tools**: SilentPatch for Colin McRae 3, OutRun2006Tweaks for OutRun, the Sega Rally stutter fix, and Xidi, which presents XInput controllers to games that only read DirectInput.

And [REA](/en/2026/10/13/ai-reverse-engineering-is-adobe-dead/), my reverse engineering tool, comes in where there's no ready-made tool: finding the game function that computes the projection, the format of the controller profile file, the right spot for a hook.

## The ones that needed the most reverse engineering

### Colin McRae Rally 04: three translation layers

CMR04 uses Direct3D 9, but it's hostile to widescreen: without a patch, 16:9 shows no extra scenery on the sides. And the game's graphics menu only lists modes up to 2048x1536, rewrites the registry and freezes.

The final pipeline ended up with three layers on Linux: the game's Direct3D 9 goes through **dgVoodoo 2.80**, which converts to Direct3D 11, **DXVK** converts Direct3D 11 to Vulkan, and Wine runs everything underneath. On Windows, only dgVoodoo remains. The newest dgVoodoo version crashed, and 2.80 isn't even fully available on the official site anymore, so the repository keeps only the tested DLL.

For widescreen, reverse engineering found the projection function and its math: the community 16:9 patch only works if the game renders at 4:3 and the image is stretched afterwards. Rendering directly at 16:9 with the patch made the cars 25% narrower. So the launcher renders at 4:3 at screen height and dgVoodoo stretches it to 16:9 with the correct geometry.

And there were details of every kind:

- the game ignores Alt+F4: the window procedure returns zero for the close message and the main loop ignores the quit one, so the launcher injects a hook that closes the process;
- the controller profile lives in a binary file of almost 1 MB, and the launcher writes the right bytes so the controller comes preconfigured, checked byte by byte against the file the game itself saved;
- with a portrait primary monitor, the image came out as a 3829x682 strip, so the launcher picks the largest landscape monitor.

![Colin McRae Rally 04 running at 16:9 with a controller](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/cmr04-game.jpg)

### Sega Rally Revo: fixing the stutter in Rust

The Sega Rally stutter has a community fix, but it's a prebuilt binary patch. Instead of distributing third-party bytes, the launcher reimplements the same fix in Rust, with a tiny x86 assembler that writes three "code caves" into the private copy's executable:

- a guard that stops the game from creating the duplicate pacing thread from the second stage onward;
- a race clock that reads the master clock instead of the value truncated to milliseconds;
- an update of that clock every frame.

Each hook point is checked byte by byte before writing, and the result reproduces exactly the hash of the reference fixed executable. The same scheme applies the aspect patch for 21:9 and 32:9, finding the tables by byte pattern.

The rest was dealing with Wine: the game always runs on an isolated virtual desktop, the launcher pins the NVIDIA GPU on machines with two cards, and configures Wine's controller driver so the game's native XInput works.

### The Screamer trilogy: hacking the emulator itself

The Screamer trilogy is MS-DOS, so the path was different: a **modified dosbox-staging**, with a Rust library statically linked into the emulator.

- **Real 3dfx Glide.** Screamer 2 and Screamer Rally load DOS's `GLIDE2X.OVL`, which talks to the Voodoo 1 emulated by dosbox. GOG's Screamer 2 ships a Windows stub that doesn't work; with Screamer Rally in the same folder, the launcher uses its genuine DOS OVL.
- **A bug in the game itself.** The texture upload code had an error at the 2 MiB boundary, fixed with a three-instruction patch.
- **Analog control.** With the emulator running at full speed, the game-port joystick read finishes before the emulated capacitor discharges, and the controller doesn't work. The solution was to find the control records in the game's memory and write steering, throttle and brake directly into them, in 10 bits.
- **Widescreen and draw distance** came from patches to the Watcom executable: the camera matrix gets a wider field of view before projection, and the object distance limits increase.

A first version used `LD_PRELOAD` to intercept the system clock and froze SDL, because it ran on several emulator threads at once. That's why the hook ended up inside dosbox's main loop.

![Screamer trilogy launcher, with the 1995 Screamer selected](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/screamer-launcher-play.png)

## Once it runs, improve it

With the game running again on Linux and Windows, you can go beyond the original. This is where the launcher becomes more than an installer.

### Resolution and aspect

A 1998 game was made for 640x480 or 800x600 on a 4:3 monitor. Rendering at 4K is the easy part, when the API allows it.

The hard part is the aspect: stretching a 4:3 image to 16:9 makes everything wide. The right way is **Hor+**, which keeps the height and shows more scenery on the sides, increasing the horizontal field of view. That requires touching the camera projection, and that's what I did in Colin McRae 1 and Screamer. In Colin McRae 3, SilentPatch already delivers Hor+ at any aspect ratio.

### Frame rate

Many old games tie physics and rendering to the same clock, and unlocking the fps speeds up the whole game. Colin McRae 1 has physics on a fixed 25 Hz tick and interpolates frames, so it reaches 60 fps without touching the physics. Screamer doesn't: the physics reads a 50-entry table indexed by frame time, and going above 50 fps makes the cars fly at the start or crashes the game.

For Screamer, the launcher has an experimental **frame generation** mode at 100 fps: between two real frames it draws an intermediate frame, using a simple motion search done in a shader. It works, but costs about 10 ms of latency, so it's off by default.

### Anisotropic filtering

When a texture is seen almost edge-on, like the asphalt far ahead, regular filtering blurs everything, because it samples the texture as if it were facing you. **Anisotropic filtering** samples more points along the direction the texture is tilted, and the asphalt and distant signs stay sharp. In Direct3D 9 games, like Colin McRae 3 and OutRun, you can force up to 16x.

### Scalers

When the game renders at one resolution and the screen has another, something has to scale the image. On Linux, almost all launchers use gamescope, which offers:

- **nearest**: repeats whole pixels, ideal if you want the original look;
- **pixel**: keeps pixels sharp but smooths the edge between them, good for pixel art at a non-integer scale;
- **linear**: interpolates between pixels, smooth but blurry;
- **FSR**: AMD's FidelityFX Super Resolution 1.0, which reconstructs edges and applies sharpening, good for going from 1080p to 4K;
- **NIS**: NVIDIA's equivalent, used in CMR04.

Screamer has its own FSR, written as a shader inside dosbox, and a 2x "superscale" of the emulated Voodoo: the emulator renders the 3dfx card at double resolution by multiplying the triangle coordinates.

### Color and gamma in Colin McRae 3

Colin McRae 3 always had a washed-out image. Measuring a 4K frame, the whole image sat between about 25 and 160 on a 0 to 255 scale: black that isn't black, white that isn't white.

The launcher generates a **LUT**, a 3D color conversion table, that readjusts black point, white point, gamma and saturation, and applies it with vkBasalt on top of DXVK, along with a sharpening filter. There are two profiles, "Colour" and "Cinematic", both optional and Linux-only for now.

![Colin McRae Rally 3 before and after the color and gamma correction](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-colin-mcrae-3-cinematic-before-after.jpg)

### AI-generated HD textures in Colin McRae 1

The project I had the most fun with was the HD art pack for Colin McRae 1. The game stores images in its own format, and a Rust tool extracts all of them, including those inside the 3D models: skies, car liveries, trackside signs.

The first attempt was Real-ESRGAN, a classic upscaler. It came out badly: it invented cracked-leather texture on the carbon fiber and outlined the letters. From then on, each type of image got its own method:

- **flat art** (HUD, logos, flags, icons) goes through a deterministic depixelization algorithm, no AI, and is then locked to the original palette;
- **everything else** is redrawn at 4K by Google's image model, Gemini 3.1 Flash Image, with a vision model checking whether every word and number in the redraw is real. If no attempt passes, the original image stays.

The AI's mistakes were instructive: the "50" on the gauge became another "60", "SNR" became "SMX", "New ZeZealand" showed up, cars gained spare tires and air intakes that didn't exist. The rule that stuck: never trust the model's colors, take the best of three attempts, and compare each result with the original.

Pack 4 covers the HUD, the menus, the skies for every stage, 124 of the 164 signs and 247 of the 370 car textures. The raw art is about 800 MB; compressed, it's about 47 MB. In game, a hook swaps each original texture for the HD version at draw time, without changing the layout.

## The games

They all follow the same install scheme, so I'll explain it once. **You need your own copy of the game**, in the version each launcher asks for, and none of them distribute game files.

- **Linux**: download the AppImage from the release, make it executable and run it. It already brings Wine, and DXVK for the Direct3D 9 games; Screamer's brings the modified dosbox. If gamescope is installed, almost all of them use it.
- **Steam / Steam Deck**: add the AppImage as a non-Steam game, or the launcher's Windows executable with a forced Proton. Screamer runs natively, without Proton.
- **Windows**: download the zip, extract it and run the launcher executable.

On first run, point to the folder where the game is installed, pick a visual profile and hit Play.

```bash
chmod +x CMR4Launcher-*-x86_64.AppImage
./CMR4Launcher-*-x86_64.AppImage
```

### Colin McRae Rally (1998)

[Release v0.7.0](https://github.com/akitaonrails/rea-colin-mcrae/releases/tag/v0.7.0) · needs the CD version, updated to EU v1.5.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/01/colin-mcrae-rally/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/01/colin-mcrae-rally/showcase-poster.jpg" >}}

- 4K, Hor+ widescreen and 60 fps, with the original physics at 25 Hz;
- AI-generated HD art pack for the HUD, menus, skies, signs and cars;
- trilinear filtering with mipmaps, extended draw distance, 24-bit depth buffer;
- pedals on the triggers, rumble and modern button layouts.

![Colin McRae Rally launcher](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/cmr1-launcher.png)

### Colin McRae Rally 3 (2003)

[Release v0.1.2](https://github.com/akitaonrails/rea-colin-mcrae-3/releases/tag/v0.1.2) · needs the official 1.1 version.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-colin-mcrae-3-demo-v012.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-colin-mcrae-3-demo-v012-poster.jpg" >}}

- SilentPatch with widescreen at any aspect ratio and HD interface at 4K;
- conversion of the official 1.1 executable to the DRM-free executable from the re-releases;
- anisotropic filtering up to 16x, adjustable field of view, sharp or soft shadows;
- optional color and gamma correction on Linux;
- triggers as pedals and the controller already configured in the new profile.

![Picture tab of the Colin McRae Rally 3 launcher](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/cmr3-launcher-picture.png)

### Colin McRae Rally 04 (2004)

[Release v0.2.0](https://github.com/akitaonrails/rea-colin-mcrae-4/releases/tag/v0.2.0) · needs your install of the game, with the original `cmr4.exe`.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/colin-mcrae-rally-04/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/colin-mcrae-rally-04/showcase-poster.jpg" >}}

- 16:9 with the correct geometry, via dgVoodoo;
- automatic landscape monitor selection and a working window close;
- analog triggers as a combined pedal and a preconfigured controller profile;
- optional fps cap and vsync.

### Colin McRae: DiRT (2007)

[Release v0.1.1](https://github.com/akitaonrails/rea-dirt/releases/tag/v0.1.1) · needs the official 1.22 version.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/dirt-launcher/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/dirt-launcher/showcase-poster.jpg" >}}

- its own fix for the crash on processors with many threads, without resetting settings;
- Large Address Aware flag on the copy's executable, so it can use more than 2 GB of memory;
- Ultra preset at 4K, the game's native 16:9 and native XInput.

![Colin McRae DiRT launcher detecting version 1.22](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/dirt-launcher.png)

### OutRun 2006: Coast 2 Coast (2006)

[Release v0.1.0](https://github.com/akitaonrails/rea-outrun-2006/releases/tag/v0.1.0) · needs your PC copy of the game.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/outrun-2006/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/outrun-2006/showcase-poster.jpg" >}}

- OutRun2006Tweaks, which fixes the PC port and removes the disc DRM, installed automatically in a pinned, tested version;
- 4K, 16x anisotropic filtering, 2048 reflections and longer draw distance;
- the song "Rush a Difficulty" with the first two seconds that were missing from the PC version;
- optional HD texture pack, downloaded on demand;
- rumble and full triggers through SDL.

![Picture tab of the OutRun 2006 launcher](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/outrun-launcher-picture.png)

### Sega Rally Revo (2007)

[Release v0.1.1](https://github.com/akitaonrails/rea-sega-rally-revo/releases/tag/v0.1.1) · needs PC version 4.0.6.0.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/sega-rally-revo-launcher.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/sega-rally-revo-launcher-poster.jpg" >}}

- the stutter fix reimplemented and checked byte by byte;
- 4K, Ultra quality and 21:9 and 32:9 ultrawide;
- 60 or 120 fps cap, native XInput controller and rumble test.

![Sega Rally Revo launcher](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/srr-launcher-play.png)

### Screamer trilogy (1995 to 1997)

[Release v0.6.0](https://github.com/akitaonrails/rea-screamer-trilogy/releases/tag/v0.6.0) · needs Screamer and Screamer 2 from GOG or the original CDs; Screamer Rally only exists on CD.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-screamer-trilogy/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-screamer-trilogy/showcase-poster.jpg" >}}

- 3dfx Glide with the genuine DOS OVL and 2x Voodoo superscale;
- FSR in a shader, Hor+ widescreen and extended draw distance;
- true analog control, including on the 8BitDo Ultimate 2;
- working CD soundtrack and experimental frame generation at 100 fps.

## Windows and Linux at the same time

Making the same launcher work on both systems takes a few choices:

- **a single executable.** The launchers for Windows games are written in Rust, with an egui interface, and compiled as a Windows executable. On Windows it runs directly; on Linux, the same executable runs inside Wine;
- **the AppImage carries everything.** On Linux, each Windows-game launcher bundles a Wine 11.20, plus DXVK when the game needs it, with its own prefix, without depending on anything installed on the machine;
- **graphics change per system.** On Windows the game uses native Direct3D; on Linux, DXVK translates to Vulkan, and Colin McRae 1 uses Wine's own wined3d;
- **Screamer is native on both**, because dosbox-staging compiles for Linux and Windows.

There was a gotcha here too. The GNU binutils 2.47 linker dropped part of the Windows executable's import table, and the launcher crashed right on open. The fix was switching to LLVM's linker in OutRun and Sega Rally, and Sega Rally's CI now checks the imports.

> All launchers were tested end to end on Linux (with Wine 11, or with dosbox in Screamer's case), on an RTX 5090 with an Xbox-style controller. **They haven't been tested on native Windows yet.** If you own any of these games and a Windows PC, test it and open an issue in the repository, with the executable's SHA-256 and the log. Contributions are very welcome.

## How long it took

From the git history, adding up the work sessions, and counting the work before the first commit by the project files' dates:

| Launcher | Commits | Estimated work |
| --- | ---: | ---: |
| Colin McRae Rally (since the previous article) | 39 | ~17 h |
| Screamer trilogy | 29 | ~12 h |
| Colin McRae Rally 3 | 27 | ~7 h |
| Colin McRae Rally 04 | 9 | ~5.5 h |
| Colin McRae: DiRT | 3 | ~4.5 h |
| OutRun 2006 | 17 | ~4.5 h |
| Sega Rally Revo | 6 | ~4.5 h |

Several were done in parallel: CMR04 and DiRT in the same afternoon, OutRun and Sega Rally in the same night. Added up, that's about 38 hours of work sessions on the six new launchers, but since they ran in parallel, it all fit in a little over one calendar day.

### What went wrong along the way

- **The newest version isn't always the best.** dgVoodoo 2.87 crashed in CMR04; 2.80, which works, isn't even fully available anymore.
- **The game has bugs too.** Screamer had a texture upload bug, and DiRT has incomplete thread maps for 6 cores.
- **Code that looks dead may be alive.** In Screamer, a "zero padding" area used for a patch was reachable code, and the game closed mid-race.
- **A wrong diagnosis is expensive.** In CMR3, a virtual controller created by another script on my machine had me chasing a mapping bug that didn't exist.
- **Wine has its quirks.** Wine 11's EGL fell back to software rendering on NVIDIA, fullscreen picked the portrait monitor, and a video player crash froze the game behind an invisible debugger.

## Old tools, new speed

Nothing here is a new technique. Wine has existed since 1993, DOSBox since 2002, dgVoodoo and DXVK for years, and the community patches were made by people who spent nights with a debugger and a hex editor. Ghidra, disassemblers, `winedbg`, xdelta: all decades-old tools.

The difference is that now an LLM operates these tools with me. It reads the documentation, writes the hook, runs the game, compares the result and tries again, while I decide what's worth fixing and recognize when the strategy is wrong. REA gives it structured access to reverse engineering, and the rest is the toolbox the preservation community had already built.

> Porting abandonware back into the modern era used to take weeks per game, and that's why almost nobody did it. With LLMs operating tools that have existed for decades, each game became a few hours of work, and I did six in a little over a day.

The launchers are experimental and will keep changing. If your favorite game is stuck in the past, the recipe is open in the repositories.
