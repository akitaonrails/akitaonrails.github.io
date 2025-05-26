---
title: Windows Subsystem for Linux is good, but not enough yet
date: '2017-09-20T14:43:00-03:00'
slug: windows-subsystem-for-linux-is-good-but-not-enough-yet
tags:
- windows
- wsl
- manjaro
- nvidia
- mac
- microsoft
- apple
draft: false
---

I wrote a premature post in July of 2016 titled ["The Year of Linux on the Desktop - It's Usable!"](http://www.akitaonrails.com/2016/07/26/the-year-of-linux-on-the-desktop-it-s-usable) and, indeed, it was (barely) usable.

The real "Year of Linux on the Desktop" is still not here. It's getting closer as I will explain.

**TL;DR** this won't be 'yet-another-WSL-install-blog-post', there are already several out there, for example [this one](https://medium.com/xtrememl/why-how-to-use-windows-10-wsl-built-in-linux-for-machine-learning-6a225f4bbd3a) or [this other one](https://www.neowin.net/news/bash-plus-windows-10-equals-linux-gui-apps-on-the-windows-desktop). And you can always [Google it](http://lmgtfy.com/?q=windows+10+creator+update+install+WSL).

Back in early 2016 Microsoft announced and launched a very alpha version of their current Windows Subsystem for Linux (WSL). It booted and ran some software, but it was awfully buggy. Fair enough as it was still an Insider preview only (by the way, avoid Insider Preview builds, they BSOD all the time as it's in active development).

A year has passed, and we got to the Windows 10 Anniversary Update and, finally, the so anticipated **Creators Update**. This is very polished in comparison.

If you're unaware of what the WSL is, I highly recommend that you read the [articles at Microsoft's Developer Blog](https://blogs.msdn.microsoft.com/wsl/) and Jessie Frazelle's awesome [Windows for Linux Nerds blog post](https://blog.jessfraz.com/post/windows-for-linux-nerds/). In a nutshell, WSL wraps the Windows kernel system calls and maps them as Linux Kernel system calls, fooling ELF64 unmodified Linux compatible binaries to run as if they were on a real Linux-based system. The kicker is that there is no Linux kernel running! It also wraps Windows services such as filesystem, networking, into appropriate devices that Linux can access.

So, it's not any kind of virtualization. There is no Hyper-V involved. It's enabling Windows to boot ELF64 binaries up directly, without recompilation, without modification.

Unlike in OS X where we need to tweak source code and recompile to run on Darwin (the Mach/BSD-based operating system layer), we can download Ubuntu binaries (or any other distro for that matter, there are Fedora and Suse coming soon to the Windows App Store) and run them **directly**.

Even more interesting, you can run system level daemons (yes, Postgresql, Memcached, Redis, etc all load and run in the background) and you can even run X (GUI) programs!

Don't get me wrong, I commend everybody that is working hard at Microsoft to make this happen. It is a technical tour de force in itself.

![Windows and X side-by-side](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/657/2017-09-14.png)

Take a good look at the screenshot above. This is a sight to behold: native GNOME-VIM running natively side-by-side with Microsoft Edge loading a web site running out of a Rails app running within WSL, accessing PostgreSQL.

But, is it good for real people?

### How good is WSL?

**TL;DR** it's not nearly as smooth as running a pure Linux-distro, and the integration is not nearly as good as OS X in terms of usability as Windows was not redesigned in any meaningful way to be a UNIX system like OS X.

In an ideal world, Windows should replace its entire NT underpinnings and either build their own BSD-inspired infrastructure (like Darwin) or create their own Linux distro using off-the-shelf Linux kernel as the main driver (probably can't because of GPL).

But this is unrealistic. Apple could do it in a time when the Mac installed base was tiny, so alienating some people wouldn't hurt so much. Windows is just too big to fail. It is and will remain a maintenance nightmare of epic proportions.

That being said, WSL in itself is a miracle, so I can't complain. Microsoft had a really harsh decade in the turn of the century. Windows 10 is a return to form, and 2 big iterations later, it's finally becoming reasonable again. Maybe we're a couple of upgrades away from a really usable WSL. Remains to be seen.

Apple had its miracle in the turn of the century, and OS X and iOS are terrific OSes. Best of the breed. And by being able to reboot the entire ecosystem from scratch is not something anyone can do.

Linux-distros had their own ups and downs. No ecosystem can evolve healthily and in a cohesive way being that fragmented. But each major distro was able to brute force their own ecosystems. Canonical has prevailed where many failed but they are still not a definitive winner, and it feels like their [losing their steam](https://arstechnica.com/information-technology/2017/04/ubuntu-unity-is-dead-desktop-will-switch-back-to-gnome-next-year/). RedHat enjoyed the craze of the dot-com era and was able to fly high in the Enterprise market. There is no "best" distro. It's again, a matter of taste and ego, most of the time for most of the people.

And the OSS community still wastes an insurmountable amount of time in crazy disputes over stuff like the [Systemd controversy](https://www.reddit.com/r/linuxmasterrace/comments/616wxo/what_is_with_all_the_controversy_with_systemd/) or the time it is taking to get over X and finally get into Wayland. OSS has pros and cons, just like everything else.

But I digress, going back to WSL. Yes, as promised almost anything you can do in a native Ubuntu 16.04 can be done in this new environment. Even the ridiculous `cmd.exe` was heavily upgraded to the 21st century. Still nowhere near a default Terminal on Linux or OS X, but getting close. Actually, I'd recommend installing [WSL Terminal](https://github.com/goreliu/wsl-terminal) as a replacement, and despite the terrible "Bash on Ubuntu on Windows" moniker, I'd recommend installing ZSH instead and launching it over Bash for extra usability features.

You can Google around for endless tutorials on how to customize your environment, Vim, tweak PostgreSQL and so forth. So again I am not repeating those here. A caveat is that I have to `sudo /etc/init.d/PostgreSQL start` to actually run daemons. They won't autoload on a restart, keep that in mind.

And now you can install a Windows X Server such as [xming](https://sourceforge.net/projects/xming/) and `export DISPLAY=:0` and you now `sudo apt install gvim` and load the graphical version of Gvim, for instance. Or a full GNOME or XFCE desktop if that's your thing. You can run X based applications side-by-side to Windows apps, and that's super neat. I like to install [YADR](https://github.com/skwp/dotfiles) which is one of those super customized dotfiles collection and it works just fine.

I am now using [ASDF](https://github.com/asdf-vm/asdf) to install and manage multiple versions of Ruby, Node.js, Elixir, etc. And it also just works.

I was able to move my SSH keys from my previous [Arch Linux](http://www.akitaonrails.com/2017/01/10/arch-linux-best-distro-ever) install. And then I can clone from my Git repositories. Now, here comes the **big caveat**. I cloned and configured a Rails project. This the fastest I can get running an entire RSpec suite with PhantomJS acceptance tests:

---
Finished in 5 minutes 35 seconds (files took 48.53 seconds to load)
888 examples, 0 failures
---

This is running on my [Dell XPS 9550](http://www.akitaonrails.com/2017/01/31/from-the-macbook-pro-to-the-dell-xps-arch-linux-for-creative-pro-users) with Core i7 Skylake (4 cores, 8 threads), 16 GB of RAM and NVME2 SSD. I asked a co-worker to run it on his very old Mac Mini 2012 with Core i5 (probably Haswell), 10 GB of RAM, normal SSD. And this is his test run:

---
Finished in 3 minutes 37.6 seconds (files took 9.73 seconds to load)
888 examples, 0 failures
---

Yep, this is shocking. The filesystem emulation is [notoriously slow](https://meta.discourse.org/t/installation-notes-for-discourse-on-bash-for-windows/48141/3?u=sam) under WSL (at least 4 times slower as you can see in the numbers above).

This other test ran in a slightly newer hardware (still underpowered compared to my Dell XPS) running on Linux Mint:

---
Finished in 3 minutes 2.4 seconds (files took 22.69 seconds to load)
888 examples, 1 failure
---

I ran the same suite a couple times to make sure, but it can't go below the 5 minute mark and loading files is always around 1 minute while in other OSes it's 2 to 4 times faster.

If your development workflow is I/O bound, you will suffer. Webpack compilation, which is slow, gets even slower. Npm/Yarn installs take forever. Installing stuff from source is super slow.

It's not unusable, but this slowness will get old fast.

### What about Virtualization?

After I saw the dismal filesystem performance shown above, I wondered _"and what about running everything under good old Virtualbox?"_

In theory, WSL "should" be a thinner layer than Virtualbox, but the worst offender in terms of overhead seems to be the filesystem abstraction layer, and not necessarily access to CPU or RAM. My instinct would first suggest that a Virtual Drive, which is a single file mounted as a virtual hard drive, would perform much better.

So here I go, installing Virtualbox and the same set of tools (asdf, etc).

Mounting a shared folder directly to the one in WSL doesn't work properly, seems like the mounting protocol doesn't understand dot files, so they don't show up. One has to tar the folder and untar within the machine to preserve hidden files and permissions.

This is running the same Rspec suite over Virtualbox with 4 Cores (out of the 8 my machine has) and 4GB of RAM:

---
Finished in 2 minutes 3.4 seconds (files took 6.33 seconds to load)
888 examples, 2 failure
---

So, we're down from 5:35 min to 2:03 min and file loading from 49 seconds down to 6 seconds! So around 2.5 times faster execution and a whopping 8 times increase in file loading! This is ridiculous and it makes way more sense. My 2016 machine, within Virtualbox, still outperforms 2011/2012 bare hardware. And WSL is in the bottom of the list.

Forget synthetic benchmarks, this is a real-world case mixing CPU and I/O bound executions. Just for the sake of comparison, I tried to see if I could squeeze a bit more performance if I try to run over VMWare Workstation. This is the result:

---
Finished in 2 minutes 3.3 seconds (files took 6.21 seconds to load)
---

Almost identical. To me, it says that Virtualbox came a long way in being comparable to commercial, historically more robust solutions such as VMware or Parallels, so I will stick with Virtualbox for the time being.

I tried another test. This is `asdf` installing the brand new Ruby 2.4.2 from source. First over WSL (running with `time`):

---
229.38s user 244.59s system 113% CPU 6:57.51 total
---

And the same install from Virtualbox:

---
295,39s user 22,43s system 135% CPU 3:53,87 total
---

Again, a mixed scenario of CPU and I/O bound executions. And I am at least twice as fast on Virtualbox.

If you do want to see more controlled scenarios running synthetic benchmark comparison, I recommend you read [Phoronix's take on WSL vs Virtualbox](http://www.phoronix.com/scan.php?page=article&item=intel-7900x-wsl&num=1)

### The "Year of Linux on the Desktop" Conundrum

The Lack of commercial software is one problem but one of the reasons is the lack of backward binary compatibility.

For all its problems, Microsoft remained committed to a very difficult concept: you can actually run unmodified binaries from Windows 95 in the current Windows 10. Most of the time they "just work". In Linux distros, every binary is compiled against very specific library headers such as the kernel itself, Glibc and many others. Whenever one of those change, all binaries must be recompiled to run. Which is why you have the concept of "distros" where they recompile and test a whole set of software. Long-Term Support (LTS) is basically locking those dependencies versions for a couple of years to have software running without the need to recompile so much. But in bleeding-edge distros, you can't avoid having to recompile a lot of things many times over.

Windows carries the old dependency binaries around. OS X does the same to a degree. And OS X goes one step further by providing the concept of "fat binaries" (or "Universal Binaries") where you have a package with multiple binaries that target different hardware architectures (32-bit vs 64 bit, Intel vs ARM vs PowerPC).

Mostly because of this support, commercial complex applications like Office or Adobe's Creative Suite can run on many different machines, across many different OS versions, over many years without upgrading. In Linux distros, it's a major hassle for binaries. Which is why having source code available is so important and it's a philosophical discussion over the whole "Free Software" concept, as envisioned by Richard Stallman.

This is an unsolvable dilemma. Linux distros don't have binary backward compatibility out of the box. Developers must rely on tools such as the [ABI Compliance Checker](https://lvc.github.io/abi-compliance-checker/). Try to use [symbol versioning](http://www.airs.com/blog/archives/220) from glibc and so forth, but it's not realistic to expect volunteers collaborating their free time to open source to keep maintaining old versions of software for many years down the road. It is a fair compromise. Do you want the best, faster, most secure? Upgrade often, but expect old, unmaintained software to break.

So, without releasing the source code, you can't have good compatible binaries for every single major distribution, across many different versions going back many years.

### Which is right for you?

There is no point in trying to benchmark OSes. They are all generally good enough.

Macs are more expensive (sometimes by a whopping 1 grand or more). There is no denying that. The compromise is that Apple's hardware, OS X and the ecosystem are generally the better all around, and the " fit and finish" of the products are really usually better from a user experience perspective.

For the best mix of mainstream software and open source software, you won't find a better alternative. If you can afford a Mac, get a Mac.

Gamers have to stick with Windows. Again, there is no denying that. The best games are on Windows, period. The best combination of hardware supports Windows. No Linux tweaking will give you the raw juice you need to squeeze out 4K 60fps out of the newest AMD and NVIDIA cards through DirectX. And the Mac hardware is capped, and you can't add the newest GPUs. If you want to play the latest AAA games the way they were envisioned to perform, get custom hardware and Windows 10.

Web Developers are luckier. You can't go wrong, it's literally a matter of taste which OS you choose. You will be able to deliver the same results using the same tools. And unless you're targeting specific Microsoft infrastructure (SQL Server, Active Directory, etc), you can install any Linux distro and rejoice.

Desktop App Developers must target their audience. If you want to build Windows desktop apps, you have to be on Windows. You can use.NET/Xamarin or Java to build cross-platform compatible binaries, though. But you guys are out of luck because ideally, you have to have all 3 to ensure your software is performing as you want.

Mobile App Developers are also out of luck. You can do Android on Windows or Linux, but you have to have a Mac to develop for the Apple App Store. You can't escape that, and good luck waiting for Apple to release their tools for other platforms.

Creative Professionals can choose either Windows or OS X. That depends on the tooling. If you're an Adobe guy, either will do just fine, but you will probably want a custom workstation. Until Apple remodels the ridiculous Mac Pro, you won't find the best hardware for the buck at Apple. The current iMac 5K is good, but higher than that is not available. For example, if you need the power of 2 NVIDIA Titan or Quadro cards running in parallel, Apple can't help you there.

If you do require a Final Cut Pro, Logic Pro, Motion 5 workflow, the best option you will get is the iMac 5K.

I am not a full-time developer anymore. And I mix my time running a company, doing presentations, experimenting with tech and doing research. My ideal setup is actually a MacBook Pro. But I am forcing myself to live out of the Apple ecosystems, and it hurts. My web developer side can stay in Linux (Manjaro GNOME is my favorite nowadays) and be happy. But when my Creative side needs tooling, Gimp, Inkscape, Kdenlive, are just not good enough. I am too used to Photoshop, Illustrator, Final Cut/Premiere, Motion 5/After Effects. LibreOffice Impress is terrible to do complex presentations, and  those HTML/JS based slides software are good just for simple stuff. Try to do serious graphics and animation there and you will suffer in hell.

<iframe width="560" height="315" src="https://www.youtube.com/embed/a59U6kRJHLg" frameborder="0" allowfullscreen></iframe>

If you're a Creative, you **need** Color Calibrated screens (Adobe RGB space), you need the raw processing power to do a quick render and advanced post-processing. Adobe video editors will prefer Windows. Final Cut video editors are well served on Macs, even though the new MacBook Pros cooling system is terrible:

<iframe width="560" height="315" src="https://www.youtube.com/embed/6TWbXV5xeYE" frameborder="0" allowfullscreen></iframe>

And if you're a full-time video editor, you can afford either high-end PC or Mac configurations, so there is not much dispute here.

If you're a video editor on a budget, you will **not** have a good 4K editing workflow on Linux, period. There is a poor support to unlock the full potential of modern GPUs, no good Cuda or OpenCL support, and most video editing tools don't use them. Blender - which is primarily a 3D modeling and animation tool - is considered one of the best video editing tools available on Linux, which says a lot. The sad state of GPU support on Linux compromises Creative usage. The only other non-linear video editing tool that can achieve professional level workflows is [LightWorks](https://www.linux.com/learn/pro-level-video-editing-lightworks-linux) and it's not open source, requires the proprietary NVIDIA binaries, and [will cost](https://www.lwks.com/index.php?option=com_shop&view=shop&Itemid=205) you.

If you're going that way, it's probably better to stick with either Windows or OS X at this point.

### Conclusion

I digressed quite a bit, but my conclusion is simple:

* WSL is not there yet. We have to wait another couple upgrades. When you hear that they improved the filesystem abstraction by a few orders of magnitude, then we can try again. And keep in mind that there are tons of [open issues](https://github.com/Microsoft/BashOnWindows/issues), so your mileage will vary.
* If you're a Web Developer, you're safe on any Linux distro.
* If you're a mixed professional in need of both development toolkits and creative tools, use a Mac or Windows 10 with a fully virtualized Linux distro.
* If you're a Gamer, Windows.
* If you're a full-time creative professional, either Macs or PCs will do just fine.

For me, I will stick with my Dell XPS running Windows 10 and Manjaro GNOME over Virtualbox. Virtualbox is fast enough that it won't hurt my workflow. And the creative tools can appreciate the access to my NVIDIA Cuda cores without any problem, so I can render with Blender and make Premiere render 4K video quickly enough.
