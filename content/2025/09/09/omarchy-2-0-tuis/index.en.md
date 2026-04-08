---
title: Omarchy 2.0 - TUIs (Terminal User Interface Apps)
date: "2025-09-09T01:00:00-03:00"
slug: omarchy-2-0-tuis
translationKey: omarchy-tuis
tags:
  - arch
  - omarchy
  - TUI
  - lazydocker
  - bubbletea
  - gum
  - posting
  - caligula
draft: false
description: Why TUIs deserve a spot on your desktop in 2025, plus a tour of my favorite terminal apps and how Omarchy makes them feel native.
---

One of the most frustrating things for a Linux user is that there are very few well-made graphical apps. Look at Gimp or LibreOffice. They're ugly, outdated, very similar to the first time I used them over 20 years ago.

The more "modern" apps are basically canned web front-ends wrapped inside Electron. The problem? They're **HEAVY** and chew through RAM like there's no tomorrow. Start opening Discord, Spotify, and a handful of these and see if your old 8GB notebook can keep up.

But, especially if you're a programmer, you should pay more attention to TUIs. At first, some will turn their nose up: _"terminal apps are ugly, black and white, boxy, blegh"_

Twenty years ago, they'd be right. But it's 2025 and today's terminals support 256 colors (more than enough), various resolutions and, most importantly, fonts, in particular [Nerd Fonts](https://www.nerdfonts.com/), fonts that have icons inside. That's how a tool like [eza](https://github.com/eza-community/eza) works, which I use every day aliased to `ls` and looks like this:

![eza](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-08-29_16-50-25.png)

And there's more: there are modern libraries, for several languages, like [**BubbleTea**](https://github.com/charmbracelet/bubbletea), a framework for building TUIs. Check their GitHub but they have the tools to make interfaces like this:

![BubbleTea](https://camo.githubusercontent.com/e2b13cfb4ea64e98028ab21e0dca97a6af46d8eeb78ef092c5cd4669ea7b7bef/68747470733a2f2f73747566662e636861726d2e73682f627562626c657465612f627562626c657465612d6578616d706c652e676966)

And if you just want a simple widget to complement a Bash script you're writing, they have [**Gum**](https://github.com/charmbracelet/gum), which lets you do interfaces like this:

![Gum](https://camo.githubusercontent.com/cea695e2df946b14838196a5cfb7d6608f03387ba42c7a7fb5afa6432371635c/68747470733a2f2f7668732e636861726d2e73682f7668732d31715935375272516c584375796473456744703638472e676966)

And to use it just install the binary and put lines like this in your script:

```bash
# Gum examples
gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert"

gum input --placeholder "scope"

gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"
```

And if you use [**Omarchy**](https://akitaonrails.com/tags/omarchy/) they ship an extra feature for TUIs. Just hit "SUPER+ALT+SPACE" to bring up the main menu, then pick "INSTALL" and "TUI". Or simply open the terminal and run:

```
$OMARCHY_PATH/bin/omarchy-tui-install
```

![omarchy-tui-install](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-08_23-22-50.png)

It'll ask for a name for the App and the command line to run. You can also pick icons at [Dashboard Icons](https://dashboardicons.com/). Once registered that way, when you call the Rofi launcher with "SUPER+SPACE" and type "lazy", LazyDocker shows up as if it were a regular app:

![Rofi LazyDocker](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/hdmi-a-3.png)

And since Hyprland has no title bar or anything, TUI apps or web apps (there's `omarchy-webapp-install` too) open as if they were "native" apps:

![tiles windows](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-09_00-49-28.png)

Read the [TUIs](https://learn.omacom.io/2/the-omarchy-manual/59/tuis) and [Web-Apps](https://learn.omacom.io/2/the-omarchy-manual/63/web-apps) sections in the Omarchy manual.

Obviously, this is only for those who prefer the feeling of running "Apps", but it's the same thing as opening a Terminal and simply typing `lazydocker` on the command line - which is my preference. What these Omarchy scripts do is create a `.desktop` file at `~/.local/share/applications`. The `LazyDocker.desktop` example generates this:

```
❯ cat ~/.local/share/applications/LazyDocker.desktop
[Desktop Entry]
Version=1.0
Name=LazyDocker
Comment=LazyDocker
Exec=alacritty --class TUI.tile -e lazydocker
Terminal=false
Type=Application
Icon=/home/akitaonrails/.local/share/applications/icons/LazyDocker.png
StartupNotify=true
```

If you don't want this launcher anymore, just delete the file or call the `$OMARCHY_PATH/bin/omarchy-tui-remove` script.

This feature is particularly interesting in Hyprland because, unlike GNOME or KDE, the window has no top title bar, so it doesn't give away that you're just opening a terminal or web browser. That's how it ships pre-configured with things like ChatGPT or Grok looking like "native" apps, when they're really just Chromium windows opening each one's URLs directly:

![WebApps Omarchy](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-09_00-54-52.png)

## Some TUIs I like

In my opinion, since there are no pretty GUI apps for Linux, it's really better to use the respective web apps like Canva or ChatGPT that way, but more interesting is having actual TUIs. As I said, these days it's not hard to make pretty TUIs. For a programmer, the advantage is that you don't have to deal with front-end frameworks first, and second, you don't have to deploy anywhere on the internet.

TUIs are lightweight, use few machine resources, they're easy for any programmer to build, and you can have a home server or a server in some cloud, SSH in, and access the TUI, without having to deal with X11 or RDP or anything heavier just to get a GUI.

Some TUIs are obvious: in the [previous post](https://akitaonrails.com/en/2025/09/07/omarchy-2-0-lazyvim-lazyextras/) I already talked about [**LazyVim**](https://www.lazyvim.org/) and how it's a text editor as competent and complete as VS Code, using only a fraction of the machine's resources. Everyone should know tools like HTOP or BTOP. Plus [LazyGit](https://github.com/jesseduffield/lazygit) or [LazyDocker](https://github.com/jesseduffield/lazydocker). All of these already come in Omarchy.

But there's much more, for example, [**dblab**](https://github.com/danvergara/dblab) which is a TUI database client for MySQL or Postgres:

![dblab](https://github.com/danvergara/dblab/raw/main/screenshots/dblab-cover.png)

Another similar one is [LazySQL](https://github.com/jorgerojas26/lazysql), written in Go:

![LazySQL](https://github.com/jorgerojas26/lazysql/raw/main/images/lazysql.png)

Or if you prefer tools written in Rust, there's [**rainfrog**](https://github.com/achristmascarl/rainfrog):

![rainfrog](https://github.com/achristmascarl/rainfrog/raw/main/vhs/demo.gif)

For those who can't use CURL on the command line and prefer Postman to call and explore APIs, there's the TUI [**Posting**](https://github.com/darrenburns/posting) that does the same thing:

![Posting](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/422760155-78359ab0-5e0c-4c0b-a60b-dce06b11bbf5.png)

For those of us who run lots of Docker containers, I already mentioned LazyDocker, but there's also [**oxker**](https://github.com/mrjackwills/oxker):

![oxker](https://github.com/mrjackwills/oxker/raw/main/.github/demo_01.webp)

If you use Discord, there's [**discordo**](https://github.com/ayn2op/discordo):

![Discordo](https://github.com/ayn2op/discordo/raw/main/.github/preview.png)

Anyone who does a lot of Linux ricing has had to burn ISOs to USB sticks dozens of times; for that there's `dd` on the command line, but there's a cooler TUI called [**Caligula**](https://github.com/ifd3f/caligula):

![Caligula](https://github.com/ifd3f/caligula/raw/main/images/verifying.png)

If your SSD is filling up and you have no idea where the hell all that space is going, there are several tools to analyze and show you. One of them is [**gdu**](https://github.com/dundee/gdu):

![gdu](https://camo.githubusercontent.com/d8fa7d2f7bdd10dce45a81c2accf26d597b300b82e01b97a1288ff2f1fe06c57/68747470733a2f2f61736369696e656d612e6f72672f612f3338323733382e737667)

And the last one I thought was cool out of nostalgia is [**sc-im**](https://github.com/andmarti1424/sc-im); think Excel as a TUI or - for those of us who came from the 80s - think Lotus 1-2-3 but with Vim keybindings:

![sc-im](https://github.com/andmarti1424/sc-im/raw/main/screenshots/scim-plot-graph.gif?raw=true)

Why open Google Spreadsheets just to make a Todo list if you can do it in the Terminal?? TUIs are exceptional!

If you want to discover more TUIs check out [**awesome-tuis**](https://github.com/rothgar/awesome-tuis/?tab=readme-ov-file) on GitHub:

[![awesome tuis](https://github.com/rothgar/awesome-tuis/raw/master/img/banner.png)](https://github.com/rothgar/awesome-tuis/?tab=readme-ov-file)
Again: zero need for heavy web front-ends for simple things. Nothing beats the simplicity of a command line. And with libraries like BubbleTea or Gum, it's now very easy for anyone to make a pretty app. And with Hyprland and Omarchy, everything stays integrated side-by-side with any other GUI app.

Getting a bit philosophical, the history of GUIs starts with _skeuomorphic_ graphical interfaces that try to imitate objects from our daily life, particularly looking pseudo-3D, like Windows 95 was. The 2000s arrived and they started migrating to _flat_ or _minimalist_ interfaces, completely removing the skeuomorphism, making everything flat. That came mainly from Windows 8's Metro. And I think that's converging toward a more TUI-like style, coming full circle, going back to how it was on 70s terminals. Personally, I find that fascinating.
