---
title: War is Over, or is it? A New Dawn for Microsoft
date: '2016-03-31T18:02:00-03:00'
slug: war-is-over-or-is-it-a-new-dawn-for-microsoft
description: "Bash on Windows and free, open-source Xamarin tools could make Windows attractive to non-.NET developers. The author sees a plausible way out of OS X, but only if Microsoft delivers on its promise."
tags:
- microsoft
- developer-tools
- tech-market
- off-topic
draft: false
translationKey: nova-era-microsoft-2016
---

Update 04/07: [the preview is already out](http://thehackernews.com/2016/04/how-to-run-ubuntu-on-windows-10.html) ahead of the June release. If you're an Insider member, try it. Leave your impressions in the comments.

Yesterday was a historic day for Microsoft. From my personal perspective, it may have been a watershed. Ever since, I've been trying to figure out how to register the moment for posterity.

### Prologue - 1995 to 2005, the 1st Decade

I mean this for us, software developers. We've been through moments like this before: the release of Turbo Pascal in 1983, Visual Basic in 1991, Java in 1995, the first Linux distros like Slackware from 1993 on, the release of OS X in 2000, and the PowerPC-to-Intel transition in 2005.

The 80s and 90s were convoluted, an era of accelerated growth where everything went obsolete fast. In one decade, from 1989 to 1999, I went from Basic to dBase, Clipper, Fox Pro, Visual Basic, Delphi, Java, multimedia (Flash, Director/Shockwave), and the Internet (HTML, Javascript, ASP, PHP, Perl). I've never seen a decade move so fast. I went from a 4 MHz XT to a Pentium III at almost 1 GHz in those ten years.

We reached the end of the century at the peak of the Internet Bubble, had 9/11 in 2001 and the crash. But the Internet came to stay, and personal devices started showing up with the Palms and iPods. In 2001 Microsoft launched Windows XP and would spend the next decade carrying that legacy on its back.

A year earlier, the small Apple had started its comeback with the new iMac, iBook, and iPod, plus the BSD-UNIX-based OS X. One step at a time, it was building a system meant for both consumers and developers, the NeXT promise taking shape a decade after its inception.

Then, in 2005, Apple forged an alliance with one of Microsoft's oldest partners, Intel, and Macs would finally run on the same processor as Windows, a stratospheric leap in adoption. And that opened another door: since OS X was built processor-agnostic, it was a matter of time before it ran on smaller, more efficient ARM chips. That's what happened in 2007 with the iPhone. The rest is history.

### 2005 to 2015 - 2nd Decade

Meanwhile, Microsoft fell behind. It failed the Windows Vista promise, shipped a competent Windows 7, and followed it with the controversial Windows 8. Only with Windows 10, unveiled at the end of 2014, did things start to change. And the effects of Steve Jobs's death, at the end of 2011, were getting more obvious: Apple had stopped.

From 2011 to today, all we got were new versions. Nothing significant, nothing new. The last big iPhone was the 5, from 2012. The last big OS X feline was Mountain Lion, from 2011. In the meantime Google pulled ahead in mobile when KitKat shipped in 2013, in my view the first Android release on equal footing with iOS.

From 1999 to 2005, broadly, the enterprise software developer had two options: Java and .NET. PHP had solid adoption, but mostly for customizing Wordpress and Magento, far from the same league as Java or .NET; the rest was niche. From 2006 on, a new generation of developers rose for the so-called Web 2.0, the post-Google world of SEO, UX, fast iterations, and Agility with a capital "A". That's where Ruby, Python, and then Node took off exponentially.

From 2010, the mobile world sped up, and one kind of integrated development in particular: the "Cloud" variety, where a native "app" talks to services on remote servers, mostly Amazon AWS, which had debuted not long before, in 2006.

Microsoft stayed out of that move and spent the next ten years playing catch-up, nursing the Vista hangover. It kept its lead in purely enterprise markets, with SQL Server and Office licenses, but on the margins of cutting-edge software development.

Actually, I'd say the watershed came in 2013, with [Ballmer's exit](http://web.archive.org/web/20160404073120/http://olhardigital.uol.com.br/pro/noticia/mercado-reage-bem-a-saida-de-ballmer-da-microsoft/36992) and the end of the "Extended Gates Era", opening the door for [Satya Nadella to step in](http://www.businessinsider.com/microsoft-year-in-review-2015-12). Microsoft is a giant, plenty of its brains had been researching this for years, and a lot of it only surfaced now. But I mean "Eras" in a symbolic sense: the end of Microsoft's Highlander culture, the "there can only be one".

The [1995 prophecy](http://1995blog.com/2015/05/24/the-internet-tidal-wave-20-years-on/) that the Internet would destroy the Windows hegemony came true. And we reached the post-Moore world, where computing became accessible and ubiquitous. Think about it: in 1995, having a cluster of "super" computers for high-throughput distributed computing was for universities or big corporations. Today, you spin up a cluster of as many dozens of machines as you want on EC2 for a month at the price of a video game console.

I was a DOS user from 1988, switched to Windows 95 as soon as it launched, and spent almost ten years developing primarily on Windows, in the corporate world. I went from Visual Basic to ASP to .NET while also doing Java and PHP. But I wanted to run Perl, PHP, Python, and Ruby native on Linux, without giving up Office and Photoshop.

The answer we were waiting for was OS X. With the release of Tiger, things got serious. I tried it myself on a Mac Mini G4 in 2004. It was exceptional to have usability far better than Windows XP and access to all the UNIX I wanted on a single machine.

When Intel launched the Core Duo and then the 64-bit Core 2 Duo, and Tiger started running on Intel in 2005, there was nothing to think about: it was time to migrate. I'd spend the next decade in a pure OS X environment, developing on a different kind of platform, with different tools and a different culture. That was my whole story with Ruby and OS X over these ten years, which you know well if you follow this blog.

### 2015 on forward, Epilogue

2015 arrived, four years after Steve Jobs's death. It was an important gap, because it gave the non-Mac platforms time to catch up and surpass OS X in many areas. We're firmly in the Software as a Service Era. We don't "buy" anything anymore, we "subscribe" to services.

We're past the Post-PC Era. We're past the Smartphone Era. We're in the Services Era, where everything is a service. Our identity is a Facebook profile, our voice is WhatsApp, and everything we do generates data. We're in the Big Data Era, a pile of useless data that no SQL Server in the world can keep up with.

We need new things to handle this paradigm: Cassandra, Riak, Hadoop, HBase, Spark, Elasticsearch, Go, Rust, Elixir. They all "run" on Windows, but someone has to spend time doing ports, writing compatibility patches, and packaging installers. And the main thing: most of the developers behind these technologies are on Linux or OS X, almost nobody builds this new generation of tools inside Windows. They all use Emacs, Vim, or Sublime Text, hardly anyone wants Visual Studio.

And this brings me back to the start of the post: it's a new Era for Microsoft. It spent the last ten years playing catch-up and, for the first time, it looks like it has a real shot at turning things around and becoming relevant to the non-.NET developer again.

For that, two things happened yesterday.

### 2016 - The Year of Linux on the Desktop

First, the announcement that ["Bash is coming to Windows"](http://thehackernews.com/2016/03/ubuntu-on-windows-10.html). Which in practice is much more than Bash: it's a partnership with Canonical, one that had been taking shape since the announcement of [SQL Server running on Linux](http://web.archive.org/web/20160415160138/http://www.microsoft.com/en/server-cloud/sql-server-on-linux.aspx). In practice, it's a [Linux subsystem](http://blog.dustinkirkland.com/2016/03/ubuntu-on-windows.html) running alongside the Windows kernel, translating Linux syscalls into Windows syscalls.

The original idea came from the deceased Project Astoria, or Windows Bridge for Android, which back then wanted to let Android apps run on Windows. Technically, Android is a flavor of Linux, so the jump to yesterday was a short one.

So it'll be possible to take a binary built for Ubuntu and run it on Windows without changing a thing.

Ever since we started developing with Ruby, a lot of Windows users wanted to run Ruby natively. There's a [distribution](http://rubyinstaller.org/), but it's not good, and that's not the maintainers' fault. Ruby, like Python and PHP, was built to work on Linux.

To port it to Windows you have to write "wrappers", and you still lack an environment with compilers like GCC to build extension packages. All of that is trivial on Linux and a headache on Windows. It wasn't worth the trouble, so the only way out was to run a virtual machine (like VirtualBox) with something like Vagrant to make it easier and use the real Linux Ruby.

Everything from Linux that "works" on Windows, whether Python or PHP, never worked 100%, and we just got used to it.

What Microsoft is shipping in the Anniversary Update is a very thin translation layer at the lowest level, and not a virtual machine or a hypervisor: from a "virtual" Linux kernel to the Windows kernel. Everything will think it's running on Linux. It's what the Wine project tries to do to run Windows applications on Linux, only in reverse. It's also different from Cygwin, which requires recompiling everything from Linux to get a semi-Linux environment on top of Windows.

There probably won't be a secondary graphical environment at first, so no X, no GNOME or KDE. And there's no need: we're in a Web world, our graphical environment now is HTML and Javascript, and Chrome and Firefox already run native on Windows. For things like compiling gems with native extensions, even GCC will work. It's the exact same binary, in the same environment, with everything we're used to on UNIX. Having Bash and SSH on Windows is just the tip of the iceberg.

The second announcement is the [release of the Xamarin tools for free and as open source](http://techcrunch.com/2016/03/31/thanks-to-microsoft-small-teams-can-now-get-xamarins-ide-and-core-tools-for-free)! Microsoft acquired Xamarin, Miguel de Icaza's company, not long ago. They built open-source .NET through pure reverse engineering, reimplementing everything as open source, and now Microsoft did the smart thing: on top of buying them, it opened the tools. The last thing still keeping a developer on the Mac was needing Xcode, which ships with OS X, to develop for iOS. Now you can do that on Windows for free.

So the math got much simpler. Windows 10 is the first respectable Windows version since the brief window of 7. Let's forget Windows 8 existed, the same way we already forgot Vista. XP is finally dead, it took over a decade, along with the hideous Internet Explorer 6, 7, and 8. Google did us the favor of making Chrome ubiquitous, and services like Facebook forced users to migrate faster.

With the [Windows 10 Anniversary Update](http://arstechnica.com/information-technology/2016/03/windows-10-270-million-users-binbash-supporting-anniversary-update-coming-summer/), we'll probably be able to do:

```
apt-get install build-essential
\curl -sSL https://get.rvm.io | bash
rvm install 2.3.0
bundle install
```

And it should just work.

In the same environment, we'll still be able to use Xamarin Studio and, with a little effort to jog the C# muscle memory, build iOS and Android apps. We'll be able to use native Office 365, all the latest Adobe CS6 tools, and even play The Division, all on the same machine.

In one shot, Windows 10 becomes the best value choice: convenience of use, development options, and competent hardware in the form of the Surface Book, Lenovo Yoga 3, and Razer Blade Stealth, which finally caught up to and passed the legendary finish of the MacBook.

2016 is finally the infamous Year of Linux on the Desktop, just not the way the Free Software crowd wanted. You can't have everything.
