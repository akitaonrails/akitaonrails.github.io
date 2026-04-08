---
title: 'Brazil Situation: No Macs for the Rest of Us'
date: '2015-11-10T16:54:00-02:00'
slug: situacao-brasil-no-macs-for-the-rest-of-us
tags:
- off-topic
- linux
- beginner
- learning
draft: false
---

This article aims to be practical, so I'll just say that with the **unquestionably** inept and corrupt government we have, one of the practical effects for us software developers is the inability to buy good machines to do our own work.

![Dollar rate 2015](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/523/cotacao_dolar.png)

The Real went into free fall at the beginning of this year and is only now stabilizing a bit, but that still means we've moved farther from the ideal of buying a professional laptop.

On the official Apple Brazil site, if we add the Real's devaluation and the **damned** Brazil Cost in taxes, an ideal development machine — the Macbook Pro 15" Retina with 16GB of RAM and 512GB SSD — will cost the impossible amount of R$ 23,499.00.

In the United States, that same machine costs USD 2,499 plus (a little) tax. If we went through the gray market (which I recommend), with the dollar at the current R$ 3.80 plus about 30% to 40% of the "gray market cost," that still means we won't pay less than R$ 13,500.

Even if we choose the 13" Retina version with 8GB of RAM, which costs USD 1,799 in the US, here it won't come out for less than R$ 9,700.

That is, it's more than double what most developers can afford, considering a budget of R$ 4,000, up to R$ 5,000 if we really stretch.

The TL;DR is simple: the best hardware (not only processor, but keyboard, trackpad, and overall build) continues to be the Macbook Pro. No other machine comes close, and to me the best operating system continues to be OS X (with Linux virtualization for development). Not being able to buy a Macbook, we have to choose a good PC and run Linux.

### Which Machine to Buy?

Even buying a machine in Brazil, it won't be possible to buy the best configuration, which raises the price above R$ 8,000.

In the R$ 5,000 range, forget SSD — it doesn't exist. What I found with the most reasonable cost-benefit was the [Dell Inspiron 15 Series 5000](http://www.dell.com/br/p/inspiron-15-5548-laptop/pd?oc=cai5548u1612656br052&model_id=inspiron-15-5548-laptop), which at the time of this article's publication was R$ 4,117. It's important to choose one with lots of RAM (more than 8GB preferably) to avoid as much as possible swapping to the slow disk (usually mechanical 5400 RPM).

If anyone has good options in this range for: at least Core i5 3rd generation, 8GB of RAM, 256GB SSD, feel free to share in the comments.

In terms of hardware, if you can buy a Lenovo Thinkpad or even a Sony Vaio (which should also be prohibitively expensive), I believe they have better hardware finish than Dell. Asus, Acer — I don't consider them good options that will last a long time, and the finish also isn't anything special.

I'll say right away that PC keyboards and trackpads are terrible. If possible use an external Apple keyboard and trackpad. Especially the Dell model I'm testing has a horrible keyboard (aside from the Brazilian layout, which I hate), light plastic with very poor click feedback for fast typers, and a trackpad that interrupts typing all the time with any light touch, has difficulty properly registering multiple clicks, and generally gives more of a headache than it helps.

### Developer Profiles

The intention is a machine for developers. And unless you're a .NET developer, definitely install a Linux distribution. Which distro depends on your profile — the more low-level you are, the closer you get to wanting to use Arch Linux. The more high-level you are, especially a web app developer, the more I recommend sticking with an Ubuntu LTS (and in this case it would really be Ubuntu 14.04).

Windows is out of the question — sorry — I was a Windows user for almost 15 years before migrating to Macs in 2004. I'm very experienced with Windows, I know all my winding paths through the Registry and the mess that is the infamous C:\WINDOWS. I tried all the latest Windows (7, 8, 8.1, 10) and the conclusion is the same: I have no interest in going back. Again, if I had to develop in .NET, I wouldn't try to emulate the environment — I'd just use Windows itself, in a virtual machine. The only solution if your development environment requires a hybrid of .NET with open source is to run Linux with virtualization.

The open-source development cycle on a Mac isn't exactly simple either. You need to understand XCode, need to understand that GCC hasn't been the default choice for a while (Apple migrated to LLVM-Clang long ago), and because of this much can break. Even so, the [Homebrew](http://brew.sh/) people did an excellent job of removing most of the problems. So, yes, you can develop comfortably if you're not a system/low-level developer.

For iOS development, you need XCode. There's no alternative. You can develop in other languages with relative ease, whether Python, Ruby, or newer ones like Rust, Elixir, or Go. Java is also more or less simple on Mac, so Java 8, Clojure, Scala, Groovy are available.

Optionally, I recommend using a virtualized Linux environment inside the Mac. Either directly via Virtualbox (which isn't the most stable thing in the world on Mac) or with VMWare Fusion (via [Vagrant](https://www.vagrantup.com/vmware) to make it easier, but this option will cost you — USD 170).

### Proprietary Software vs Open Source

Yes, on Linux we have several options like Inkscape, Gimp, Blender. Yes, you "can" do a lot of things.

In practice, usability counts.

On OS X we have Keynote, iMovie, and GarageBand, which have no equals in terms of usability. For higher-end purposes, we have Aperture, Final Cut Pro, and Logic Pro. Again, unmatched in usability and flexibility.

On Windows, we can choose the Adobe package, which goes from Photoshop and Illustrator to Premiere Pro and After Effects — which also have Mac versions.

In the productivity world, forget LibreOffice or even Google Docs — the Microsoft Office package (especially Word, Excel) is still unbeatable and unmatched. You can do something similar, you can edit something similar — it's still not close to the same thing, especially in more complex spreadsheets full of formulas, pivot tables, etc.

All of them cost, and they cost a lot. Obviously it's not fair to compare with open source options. But I would really like to have the option of paying to have it working on a Linux distro. The problem is that Linux distros aren't friendly to proprietary software. It will always be the dilemma of 100% open vs hybrid or 100% closed. Just ask the Ubuntu people.

A small example is 1Password, which I use on Mac, on Android, used on iOS (when I had an iPhone), and has a version for Windows. Everything except Linux. I was forced to use 1Password from Windows via Wine to be able to access my passwords again. "Serves you right for using proprietary software."

For better or worse, the ideal of 100% open software has never been farther. Especially today when every app has an online component. There's now a lot of open source "client," but the back-end is totally closed-source. Worse: it isn't even a binary on your machine, it's in the "cloud." No one will ever adhere to the ideal of [Affero GPL](http://www.gnu.org/licenses/why-affero-gpl.en.html) where the code in the cloud should also be open. And even if it were, it wouldn't be practical for anyone to simulate the same cloud environment as everyone else.

Currently, the open source world isn't a world of absolute freedom. I usually summarize the open source world as being the best cost-benefit companies have ever had to maintain commoditized software.

Languages, frameworks, toolkits, development tools, cryptography libraries are commoditized software.

Adobe package, Office, etc., aren't commodities yet. They keep going full steam ahead, with new feature after new feature, every six months. It's impossible for an open source copy-cat, without resources, to reach the same level. There's no interest either.

For those who need proprietary software as a day-to-day tool, don't leave Windows, don't leave Mac.

I occasionally need it. 80% of my needs depend on commoditized software or software that isn't the core business of any company that produces it. For Google, Chromium is worth being open source, but don't go anywhere near the Ad Sense code — which is the real core business. For everyone, it's worth the clients that consume their services being open source. You'll find a good client for Dropbox, for Google Drive, but don't even try to search: the core business still is and will continue to be closed. That's where the ideal of Free Software drifts farther and farther away.

I'm not an idealist, and for most developers, what we have is enough — it sustains itself and becomes viable in a hybrid world. It means that in the real world, 80% of what we need is available. The other 20% I'll need to solve through virtualization, and I'll have my Office running either via Wine or via Virtualbox. And maybe I can have my Apple Keynote via Hackintosh in a Virtualbox. Or I'll solve the last 5% with an outdated Macbook that runs what I need for the few hours when I need them.

I tried to install a Hackintosh via Virtualbox, and although I managed to install it (after multiple attempts and many tutorials), it's absolutely unstable and slow, even giving it 2 of my 4 Core i7 and 4GB of RAM with 128MB of video memory. It's not usable — if I want to use Keynote it'll have to be a real Mac, there's no substitute.

### Why Ubuntu + Unity?

If there's one thing everyone has an opinion about, it's how to use your Linux. It depends on who you are.

If you're at least a more idealistic programmer, you'll hate Ubuntu for the reason that it uses what Debian does and adds the *argh* terrible layer of proprietary software on top.

If you're a more hardcore programmer, you'll want to understand every inch of your Linux, and for that you'll always think Arch Linux (or at least [Antergos](https://antergos.com/)) is a superior option. For these people, Pacman will always be infinitely superior to Apt-Get or Yum.

If you're the "be stable without messing with much but don't be common" style, you may end up going toward Fedora.

And regardless of the distro, there will always be the eternal fight between Window Managers. The KDE crowd with their Plasma speaking ill of the outdated Gnome, or XFCE asserting its "simple and stable" position, or a new distro like Elementary OS creating its new Pantheon. This has no end.

Most new programmers, who've used Linux for 5 years or less, can't understand how someone can use a Linux and not customize it totally to their taste. Editing every X11 file, editing every theme and icon pack to become a "Windows-alternative" or an "OS X-rebel."

In my case, what many may not understand is that I'm an old-school Linux user. My first Linux was Slackware 1.0 in 1996. I installed RedHat pre 4. Then came distros like Mandrake, long before Kurumin. I installed the first versions of most distros that exist today. I already pulled nights and nights customizing my X. Nights and nights downloading themes, downloading widgets, customizing every part of my system. Then I'd do something wrong and decide to format everything and start all over. Lots of time checking kernel compile flags to make my kernel as customized as possible.

I stayed in this vibe from 1997 to maybe 2001. It's tiring. Seriously. If you're a programmer in your 20s and have never done this, I'd say you have a **moral** obligation to go through this process. Every programmer has to find it cool to have total control of their own environment.

But it's not healthy to do this for more than 5 years. After that you really want to be productive. To produce and not customize. The number of hours necessary to make a distro 100% "mine" doesn't pay off.

That's why I like OS X: you don't need to customize anything. Everything is just right "out-of-the-box" — the best Window Manager, on top of one of the best traditional Unix flavors, and with reasonably simple access to both the open source world and the best of the closed source world. It's the best of both worlds.

In the Linux world you have to deal with the ideology of the GPL. I perfectly understand Stallman's arguments, I've read and reread the site countless times. How many times have you **really** read the entire [gnu.org](http://www.gnu.org/philosophy/philosophy.html)? Unfortunately there's no free lunch — staying in the ideology means giving up a lot of things I really don't have the willingness to give up.

In particular, the Dell I bought came with Ubuntu preinstalled. It's what it has support for, which means all the hardware works, has updated drivers. I intend to stay within the Ubuntu ecosystem, including Unity, which I know many don't like for ideological reasons or because they think XFCE or Gnome or KDE or XXX works better for their tastes.

Again: the cost of customization simply doesn't pay off. Software isn't installed once and works forever. You have to update, have to have support, have to be consistent. The Canonical people are the only company seriously focused on usability and end consumers, and that's important. They're constantly slowed by ideology and by too many opinions that never reach consensus, and they're vilified every time they make a decision: half the community will always not get what they want and will complain. Canonical has to deal with a slow and bureaucratic process that an Apple simply decided to bypass completely. Except in Apple's case, they can bring Microsoft, Adobe, and generate profitable business models for hundreds of other software houses. Canonical still can't do this and depends a lot on the spare hours of volunteer programmers in the open source world, and this dependency is both a great strength and the biggest problem.

Last tip: I had problems keeping the default language (for menus and everything else) in English and using an external Mac USB keyboard with the English (US, alternative international) layout. The normal thing of accenting "c" to get the cedilla "ç" didn't work. Only after following [Kemel Zaidan's](http://linuxlegal.blogspot.com.br/2014/02/cedilha-no-ubuntu-1310-com-teclado.html) tutorial did it work.

### Conclusion

Will I keep using Ubuntu as my main machine? I don't know yet. I'm keeping my options open for harder times when the dollar costs above R$ 2.50. Below that level, I'll definitely stick with a Mac.

For home users, a Linux works well — it's the idea of Chrome OS, which is a Linux basically running Web Apps like Google Docs, Gmail, etc. And at this level it doesn't matter which OS or which configuration. The advantage of a Linux for Web use for 90% of the population is not being vulnerable to the most obvious malware.

For office users, a Linux works reasonably well, but as I said, Office still can't be replaced. The only way is the entire company adopting a simpler document format and not doing anything too complex with Excel, for example. In general, Google Docs and Google Drive or Dropbox, Gmail Business, work well enough.

For .NET developers, stay on Windows.

For open source developers, it doesn't matter if you stay on Linux or Mac. If it's high-end, choose a Mac if you can pay. If it's more low-level, stay in the pure Linux world. When in doubt: Ubuntu 14.04 LTS (with Unity!), install your choice of Sublime Text 3, and the rest works perfectly.

For hybrid users who are developers most of the time but also need proprietary software (my case), you can stay in Linux — most of the time it won't hurt that much, but in that 1 moment when you need to edit a video, edit a heavier Photoshop, make a more elaborate Keynote, have a Mac at hand. There are no alternatives for that case.
