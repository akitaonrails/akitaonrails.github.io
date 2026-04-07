---
title: Your Windows May Be Crippled Without You Knowing. Check This!!
date: '2025-05-21T17:15:00-03:00'
slug: your-windows-may-be-crippled-without-you-knowing-check-this
tags:
- windows
- power saver
- hanging event
- slow down
draft: false
translationKey: windows-might-be-crippled
description: How a hidden Windows Power Saver profile was silently throttling a high-end desktop to a fraction of its real speed, and how to fix it.
---



I usually don't bother documenting silly Windows problems, but this one in particular got me really annoyed, so I'm going to report the sequence of events. But let me just drop the spoiler right now: open Control Panel and Power Options on your Windows and check if it's not in "Power saver" mode. Get it out of that garbage, at the very least leave it on Balanced, but if it's a desktop PC bump it up to "High Performance" or "Ultimate Performance". Thank me later.

Now sit down, here comes the story.

I built a pretty decent PC for my girlfriend: Intel i7 12th Gen 8 cores, 32GB DDR4-2400, NVIDIA RTX 3090, MSI Edge z790 motherboard, NVME and I even hooked up a Synology DS1621+ NAS on a 2.5Gbps network - because she's a content creator and has A LOT of video to edit. Modesty aside, it turned out pretty nice:

![pc branco](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/a8c82k3ocnpu1jamxb9w0z1fx2cf)

Everything worked very well for a long time, but eventually, for no apparent reason, everything started feeling kind of slow. Not completely slow, but sometimes web pages seemed to stutter while loading. I'd click on the Windows Start menu and it seemed to freeze up. Sometimes Explorer would hang and I'd need to go to Task Manager and restart the process manually. Several super inconvenient things but none of them throwing any explicit "error". It just felt "weird".

I'm a Linux user. My main PC is Manjaro Linux. I only use Windows on my gaming mini-PCs, exclusively to run Steam and some emulators. I avoid installing anything on them at all costs. Because I know how much of a pain it is to diagnose Windows after some weird program invades it.

I went after the usual suspects. She had installed games for streaming, like Valorant, Genshin Impact and stuff like that. I always suspect anti-cheats, the crap from Riot Vanguard or Easy or VAC. I started by uninstalling all the games. But I always think anti-cheat is like malware: once installed, it will never leave the system. I uninstalled everything, but that feeling of kind of freezing, kind of slow, intermittent, remained.

I tried the next suspects: peripheral software, like Elgato, Logitech, Razer stuff that install a bunch of garbage on your machines, and recently I was reading about the malware that was shipping with all of them. Watch this GamersNexus video to understand the house of cards that the whole peripheral industry with RGB has become:

{{< youtube id="H_O5JtBqODA" >}}

Even uninstalling all of them, still the same behavior: kind of slow, kind of freezing, unstable.

Let's try to go deeper, and for that you have to install tools like [Sysinternals Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) to see if there's anything starting up (things hidden in the Registry for example). I tried to disable everything I thought was suspicious.

Nothing. By that point I had also made sure that the newest MSI BIOS firmware was installed. I checked that nothing had been turned off in the BIOS, XMP profile was ok, no fast-boot and stuff like that.

### Is It the Internet?

Since most of the usage is internet and it seemed "slow", I thought it might be network problems. Vivo's router? The plan? Wifi with interference?

Running out of patience I decided to go nuclear on the internet idea. In fact, opening the [Cloudflare Speed Test](https://speed.cloudflare.com/) page I could see that the speed itself was ok, but the latency was VERY high, jitter high and, mainly, PACKET LOSS was over 15%. That's not normal, it has to be 0%.

Taking advantage of a trip to Miami I brought back a TP-LINK BE9300 router for Wi-fi 7, and I also bought a compatible Wi-fi 7 PCIe card. I turned off Vivo's Wi-fi router and bumped the plan up to 800Mbps. And indeed, the internet improved a lot:

![vivo internet](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ogesvmtex2ek825hel7d4l0f5i30)

Latency dropped, jitter dropped, packet loss went to 0%.

But this didn't fix the problem. Out of nowhere the browser would pause when loading some page. That feeling of kind of slow, kind of freezing. And yes, I tried switching from Edge to Chrome, to Firefox, to everything. Nothing made any difference. The internet really did get faster, but Windows itself didn't seem to improve much and while browsing, it was getting slower and slower. So the problem wasn't the internet.

I was running out of options. Everything that could be manually cleaned in Windows, I cleaned. There was almost nothing left to delete - and I delete things without mercy. But I always had it in my head that it was some malware, something that loads before boot, some "ROOTKIT". Anti-cheats are Rootkits by definition. They load even before the kernel and from that point on, the compromised system can no longer be trusted, because no tool will be able to find it.

Assuming at that point it had to be a compromised system, I decided to go with the nuclear option: reinstall everything from scratch. We backed up the data and off I went to reinstall from scratch.

### Reinstalling DID NOT WORK

Now it got worse.

With Windows 11 Pro, freshly installed, guaranteed with no third-party software installed, it still had the same behavior of kind of slow, kind of freezing. The start menu wouldn't let me click on anything. I had to open task manager and kill Explorer manually to get it to work again.

I spent some time staring at Task Manager, but there wasn't any process running that I could suspect further: it was bare-bones Windows. I had even run a [Debloater](https://github.com/Raphire/Win11Debloat) to uninstall unnecessary Microsoft apps like Teams.

But lo and behold, from staring at task manager so much, I saw that I had been ignoring an important piece of data. See if you can spot it:

![cpu low](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/pky39kkwcbuyqocwpj15n36i9gai)

The image is kind of messed up because I took a photo of the monitor with my phone. The refresh rate clashes with the camera's and you get this "grid", but I think you can still read it.

Even when you have almost no program running, it's not natural for the CPU to be at such a low clock, 0.50Ghz - HALF A GIGAHERTZ. This Intel i7 can go above 4Ghz and the base clock is 2Ghz.

I opened browsers, opened tabs, kept monitoring, and it never went above 1.5Ghz. An occasional spike to 2Ghz for 1 second and then it dropped below 1Ghz again. Then I thought: could the AIO be failing??

Looking at Event Viewer you could see when the Start menu (which is part of Explorer.exe) stopped working and froze: it logs it as "Hanging Events" code 1002.

![event viewer](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/dtugk013p4decud6zo1dzg3rjhxr)

See all those Errors? All Hanging Events, and "hanging" is exactly the behavior: something seems to "hold", "freeze" and only by killing the process does it come back to working.

And this was happening before and also AFTER reinstalling everything from scratch. Something seemed fundamentally wrong with the hardware itself. With the super low clock, this behavior starts to make sense: it's so slow it can't even process basic things. Click several times on the Start Menu (which will be digging through recent documents, updating the list of applications, opening the search bar, etc) and there's no clock to process all that while there's still Windows Defender in background, browser tabs processing.

### Could It Be Thermal Throttle??

Since Windows was wiped clean, it can't be anti-cheat anymore, it can't be some weird anti-virus, it can't be malware, it's not the internet, it had to be something EXTERNAL, that was what made sense.

I opened the PC and left it open so I could feel if the heatsink was getting absurdly hot. If it was, it would mean my AIO (Coolermaster Watercooler) had started to fail.

It's normal for the CPU, when it overheats, to drop the clock to avoid burning the chip. This is called "THERMAL THROTTLING".

And again, weird: it was COLD to the touch!!!

No way. I opened the BIOS to re-check fan profiles, but everything was normal:

![cpu fans](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/yl02sk0dug6zj9d1gen877d22gnw)

That's when it finally hit me:

	**LET ME CHECK THE POWER SETTINGS**


On a normal PC/laptop, it should show something like this:

![Power Settings](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/a5dkm6eag4ebma6ye1i1mnzphy3s)

By default, Windows always boots in "Balanced Mode".

But on my girlfriend's PC, **I have no idea why**, there was no Power Mode option!!! And I'm on a Windows 11 Pro with a paid license!!

That's weird, but I know that in the old Control Panel, there's a Power Options entry:

![control panel](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/70ymku67f5ufp0pd76jp0b2hqjx2)

AND THERE'S THE PROBLEM:

It was on "Power saver"!!!

How did that happen? I have absolutely no idea. REMEMBER: I had reinstalled Windows from scratch. This is right after reinstalling!!

On a laptop this profile makes sense, to save battery when you don't have an outlet. But on a desktop PC, which is my case, it makes no sense at all!! I switched to "Ultimate Performance" and look at the task manager now:

![cpu high](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/5hg5d85ivuxv9tw5si21wcb3hm5p)

NOW WE'RE TALKING!! Above 4Ghz!!!

The NORMAL range for this CPU is around 4Ghz, with Turbo Boost of 5Ghz. But in Power saver mode, it NEVER goes above 2Ghz and idles at 500Mhz. In other words, everything was **TEN TIMES SLOWER**, sometimes it tried to boost and was still **FIVE TO TWO TIMES SLOWER**. And it's intermittent!!!

Testing installing apps, browsing, etc, everything is now working normally, no freezing, no feeling of slowness. Start menu doesn't hang anymore - because now there's enough CPU to process the crap it needs in background.

### Conclusion

CHECK POWER OPTIONS IN CONTROL PANEL!!!!

Again: I had JUST REINSTALLED WINDOWS. It was wiped clean and, by default, it came up in Power Saver mode.

I have no idea why it did that, I don't know if it always does that, I don't know if it failed to recognize the MSI motherboard, I don't know what combination of hardware factors can make Windows fall back to this.

But it's ALARMING that it does this without warning. There's no error message. There's no notification. It doesn't show up in Event Viewer. In other words, even a Power User like myself has to randomly suspect "hmm, let me check the power profile".

Lots of people with Windows must be feeling this slowness and freezing and thinking "hmm, my PC is just crap, I need to save up to buy another one", without knowing that maybe it's just crippled by this power profile and in reality their PC is 2x to 5x, even 10x faster and they don't know it! That's not a small difference!

POWER SAVER MODE is a huge piece of garbage, it has no practical use and it shouldn't even exist. It's one of those legacy things that give Windows a terrible experience - because it doesn't warn you.

Remember those 1002 hanging events error codes? If you go searching on Google, every forum will tell you to run diagnostic programs, uninstall stuff, or reinstall Windows. None of them mention anything about the power profile.

I hope this helps someone else!
