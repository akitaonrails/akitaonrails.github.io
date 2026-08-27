---
title: 'Brazil Situation: No Macs for the Rest of Us'
date: '2015-11-10T16:54:00-02:00'
slug: situacao-brasil-no-macs-for-the-rest-of-us
translationKey: situacao-brasil-no-macs-for-the-rest-of-us
description: "I tested a Dell Inspiron with Ubuntu after a MacBook Pro became too expensive for a Brazilian budget. Linux covers about 80% of my use, but proprietary software still requires Mac or Windows."
tags:
- linux
- apple
- hardware
- off-topic
draft: false
---

This article aims to be practical, so I'll get right to the point. With the **unquestionably** inept and corrupt government we have, one of the concrete effects for us software developers is the inability to buy good machines to do our own work.

![Dollar rate 2015](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/523/cotacao_dolar.png)

The Real went into free fall at the beginning of this year and is only now stabilizing a bit. Even so, we keep drifting farther from the ideal of buying a professional laptop.

On the official Apple Brazil site, once you add the Real's devaluation and the **damned** Brazil Cost in taxes, the ideal development machine, a Macbook Pro 15" Retina with 16GB of RAM and 512GB SSD, hits the impossible figure of R$ 23,499.00.

In the United States, that same machine costs USD 2,499 plus (a little) tax. If we went through the gray market (which I recommend), with the dollar at the current R$ 3.80 plus about 30% to 40% of the "gray market cost," even then we won't pay less than R$ 13,500.

Even if we go for the 13" Retina version with 8GB of RAM, which costs USD 1,799 in the US, it won't come out here for less than R$ 9,700.

That is more than double what most developers can afford, given a budget of R$ 4,000, up to R$ 5,000 if we really stretch.

The TL;DR is simple: the best hardware (not only the processor, but the keyboard, trackpad, and overall build) is still the Macbook Pro. No other machine comes close, and to me the best operating system is still OS X, with Linux virtualization for development. If you can't buy a Macbook, you're left picking a good PC and running Linux.

### Which Machine to Buy?

Even buying a machine in Brazil, you can't get the best configuration, which pushes the price above R$ 8,000.

In the R$ 5,000 range, forget about SSD, it doesn't exist. The best value I found was the [Dell Inspiron 15 Series 5000](http://web.archive.org/web/20150625001142/http://www.dell.com/br/p/inspiron-15-5548-laptop/pd?oc=cai5548u1612656br052&model_id=inspiron-15-5548-laptop), which at the time of this article was R$ 4,117. It's worth choosing one with plenty of RAM, more than 8GB if possible, to avoid swapping to the slow disk as much as you can, usually a 5400 RPM mechanical one.

If anyone has good options in this range, at least a 3rd-generation Core i5, 8GB of RAM, and a 256GB SSD, drop them in the comments.

On the hardware front, a Lenovo Thinkpad or even a Sony Vaio (which is probably prohibitively expensive too) have better build quality than Dell. Asus and Acer I don't count as good options that will last, and the finish isn't much to write home about either.

I'll say it upfront: PC keyboards and trackpads are terrible. If you can, use an external Apple keyboard and trackpad. The Dell model I'm testing has a horrible keyboard, on top of the Brazilian layout I can't stand: light plastic, with awful click feedback for anyone who types fast. The trackpad interrupts typing at the slightest touch, struggles to register multiple clicks correctly, and mostly gets in the way instead of helping.

### Developer Profiles

The idea is a machine for developers. Unless you're a .NET developer, definitely install a Linux distribution. Which distro depends on your profile: the more low-level you are, the closer you get to wanting Arch Linux. The more high-level you are, especially a web app developer, the more I'd steer you toward an Ubuntu LTS, which in this case would be Ubuntu 14.04.

Windows is off the table, sorry. I was a Windows user for almost 15 years before switching to Macs in 2004. I know Windows cold, I know all my winding paths through the Registry and the mess that is the infamous C:\WINDOWS. I tried every recent Windows (7, 8, 8.1, 10) and the conclusion is the same: I have zero interest in going back.

If I had to develop in .NET, I wouldn't even try to emulate the environment, I'd just run Windows itself, in a virtual machine. The only workaround, when your setup needs a hybrid of .NET and open source, is to run Linux with virtualization.

The open-source development cycle on a Mac isn't exactly simple either. You need to understand XCode, and you need to know that GCC stopped being the default choice a while ago, since Apple moved to LLVM-Clang, and because of that plenty of things can break. Even so, the [Homebrew](https://brew.sh/) folks did a great job smoothing over most of the problems. So yes, you can develop comfortably, as long as you're not a system/low-level developer.

For iOS development, you need XCode. There's no alternative. For other languages you can work with relative ease, whether Python, Ruby, or the newer ones like Rust, Elixir, and Go. Java also runs reasonably well on Mac, so Java 8, Clojure, Scala, and Groovy are all on the table.

Optionally, I recommend running a virtualized Linux environment inside the Mac. Either straight through Virtualbox, which isn't the most stable thing in the world on a Mac, or through VMWare Fusion, with [Vagrant](https://www.vagrantup.com/vmware) to make it easier. That second option will cost you, USD 170.

### Proprietary Software vs Open Source

Yes, on Linux we have plenty of options, like Inkscape, Gimp, and Blender. Yes, you "can" do a lot of things.

In practice, usability counts.

On OS X we have Keynote, iMovie, and Garageband, with no equals in usability. For higher-end work, we have Aperture, Final Cut Pro, and Logic Pro, again with no equals in usability and flexibility.

On Windows, you can pick the Adobe suite, which runs from Photoshop and Illustrator to Premiere Pro and After Effects, all of which also have Mac versions.

In the productivity world, forget LibreOffice or even Google Docs: the Microsoft Office suite, Word and Excel in particular, is still unbeatable. You can do something similar, you can edit something similar, but it still isn't close to the same thing, especially with more complex spreadsheets full of formulas, pivot tables, and the like.

They all cost money, and they cost a lot. Obviously it isn't fair to compare them with open source options. But I'd love to have the option of paying to run them on a Linux distro. The problem is that Linux distros aren't friendly to proprietary software. It'll always be the dilemma of 100% open against hybrid or 100% closed. Just ask the Ubuntu crowd.

A small example is 1Password, which I use on Mac, on Android, used on iOS (when I had an iPhone), and has a Windows version. Everything except Linux. I was forced to run the Windows 1Password through Wine just to get to my passwords again. "Serves you right for using proprietary software."

For better or worse, the ideal of 100% open software has never been farther away, especially now that every app has an online component. There's plenty of open source "client" these days, but the back-end is completely closed source. Worse: it isn't even a binary on your machine, it lives in the "cloud."

Nobody is going to sign up for the ideal of the [Affero GPL](http://www.gnu.org/licenses/why-affero-gpl.en.html), where the code running in the cloud should also be open. And even if it were, it wouldn't be practical for anyone to simulate everyone else's cloud environment.

Today, the open source world isn't a world of absolute freedom. I usually put it this way: it's the best value companies have ever had for maintaining commoditized software.

Languages, frameworks, toolkits, development tools, and cryptography libraries are commoditized software.

The Adobe suite, Office, and the rest aren't commodities yet. They keep going full steam, with new feature after new feature, every six months. It's impossible for an open source copy-cat, with no resources, to reach the same level. And there's no interest in doing so either.

For anyone who needs proprietary software as a daily tool, the advice is blunt: don't leave Windows, don't leave Mac.

I need it once in a while. 80% of my needs depend on commoditized software, or on software that isn't the core business of any company that makes it. For Google, Chromium is worth being open source, but don't go anywhere near the Ad Sense code, which is the real core business.

For everyone, it's worth having the clients that consume their services be open source. I'll find a good client for Dropbox, for Google Drive, but don't bother looking for the rest: the core business still is, and will stay, closed. That's where the ideal of Free Software keeps drifting farther and farther away.

I'm not an idealist. For most developers, what we have is already enough, it sustains itself and becomes viable in a hybrid world. In the real world, 80% of what I need is available. The other 20% I solve through virtualization, with my Office running via Wine or via Virtualbox.

Maybe I can get Apple Keynote running via Hackintosh in a Virtualbox. Or I solve the last 5% with an outdated Macbook that still runs what I need for the few hours when I need it.

I tried installing a Hackintosh via Virtualbox and, even though I managed it after many attempts and many tutorials, it stays absolutely unstable and slow, even with 2 of my 4 Core i7, 4GB of RAM, and 128MB of video memory. It's not usable. If I want Keynote, it'll have to be a real Mac, there's no substitute.

### Why Ubuntu + Unity?

If there's one thing everyone has an opinion about, it's how to use your Linux. It depends on who you are.

If you're a more idealistic programmer, you'll hate Ubuntu precisely for taking what Debian does and adding the *argh* terrible layer of proprietary software on top.

If you're a more hardcore programmer, you'll want to understand every inch of your Linux, and for that you'll always find Arch Linux (or at least [Antergos](http://web.archive.org/web/20150913071621/http://antergos.com/)) a superior option. For these folks, Pacman will always be infinitely superior to Apt-Get or Yum.

If you're the "be stable without fiddling too much, but don't be ordinary" type, you may end up drifting toward Fedora.

And whatever the distro, there will always be the eternal fight between Window Managers. The KDE crowd with their Plasma trashing the outdated Gnome, XFCE asserting its "simple and stable" stance, or a new distro like Elementary OS building its own new Pantheon. This has no end.

Most new programmers, who've used Linux for 5 years or less, can't grasp how anyone could use a Linux without customizing it entirely to their taste. Editing every X11 file, every theme and icon pack to become a "Windows-alternative," an "OS X-rebel."

In my case, what many may not get, is that I'm an old-school Linux user. My first Linux was Slackware 1.0 in 1996. I installed RedHat pre-4, and then came distros like Mandrake, long before a Kurumin. I installed the first versions of most of the distros around today.

I pulled night after night customizing my X, downloading themes, downloading widgets, tweaking every part of the system. Then I'd do something wrong, decide to wipe everything, and start over from scratch. I spent a lot of time checking kernel compile flags to make mine as customized as possible.

I stayed in that vibe from 1997 to maybe 2001. It's exhausting, seriously. If you're a programmer, in your 20s, and you've never done it, I'd say you have a **moral** obligation to go through this process. Every programmer needs to enjoy having total control over their own environment.

But it isn't healthy to do this for more than 5 years. After that, what you really want is to be productive, to produce instead of customize. The number of hours it takes to make a distro 100% "mine" simply doesn't pay off.

That's why I like OS X: I don't need to customize anything. It all comes right out-of-the-box, the best Window Manager, on top of one of the best traditional Unix flavors, with reasonably simple access to both the open source world and the best of the closed source world. It's the best of both worlds.

In the Linux world, you have to deal with the ideology of the GPL. I fully understand Stallman's arguments, I've read and reread the site countless times. How many times have you **really** read the whole [gnu.org](http://www.gnu.org/philosophy/philosophy.html)? Unfortunately there's no free lunch: staying in the ideology means giving up a lot of things I honestly don't have the willingness to give up.

As it happens, the Dell I bought came with Ubuntu preinstalled. It's what it's supported on, which means all the hardware works and the drivers are up to date. I plan to stay inside the Ubuntu ecosystem, Unity included, which I know many people don't like for ideological reasons or because they think XFCE, Gnome, KDE, or whatever works better for their taste.

Again: the cost of customization simply doesn't pay off. Software isn't installed once and works forever. You have to update it, you have to have support, it has to be consistent. The Canonical folks are the only company seriously focused on usability and the end consumer, and that matters.

Canonical gets slowed down constantly by ideology and by too many opinions that never reach a consensus, and it gets vilified every time it makes a decision: half the community will always miss out on what they want and gripe about it. It's a slow, bureaucratic process that an Apple simply decided to bypass entirely.

Except Apple can bring in Microsoft, Adobe, and generate profitable business models for hundreds of other software houses. Canonical still can't do that and leans heavily on the spare hours of volunteer programmers in the open source world. That dependency is at once a great strength and its biggest problem.

Last tip: I had trouble keeping the system in English (menus and everything else) while using an external Mac USB keyboard with the English (US, alternative international) layout. The usual way of accenting the "c" to get the cedilla "ç" didn't work. It only worked after I followed [Kemel Zaidan's](http://linuxlegal.blogspot.com/2014/02/cedilha-no-ubuntu-1310-com-teclado.html) tutorial.

### Conclusion

Will I keep using Ubuntu as my main machine? I don't know yet. I'm keeping my options open for harder times, with the dollar above R$ 2.50. Below that level, I'll stick with a Mac without thinking twice.

For home users, a Linux works well. It's the Chrome OS idea, a Linux basically running Web Apps like Google Docs, Gmail, and the rest. At that level, it doesn't matter which OS or which configuration. The advantage of a Linux for the web use of 90% of the population is not being vulnerable to the most obvious malware.

For office users, a Linux works reasonably well, but, as I said, Office still can't be replaced. The way out is the whole company adopting a simpler document format and not doing anything too complex in Excel, for example. In general, Google Docs and Google Drive or Dropbox, with Gmail Business, work well enough.

For .NET developers, stay on Windows.

For open source developers, it doesn't matter whether you stay on Linux or Mac. If it's high-end, choose a Mac if you can afford it. If it's more low-level, stay in the pure Linux world. When in doubt: Ubuntu 14.04 LTS (with Unity!), install your choice of Sublime Text 3, and the rest works perfectly.

For hybrid users, who are developers most of the time but also need proprietary software (my case), you can stay on Linux. Most of the time it won't hurt much. But in that one moment when you need to edit a video, work on a heavier Photoshop, or put together a more elaborate Keynote, have a Mac at hand. For that case, there's no alternative.
