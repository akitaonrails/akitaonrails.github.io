---
title: Enabling Optimus NVIDIA GPU on the Dell XPS 15 with Linux, even on Battery
date: '2017-03-14T14:21:00-03:00'
slug: enabling-optimus-nvidia-gpu-on-the-dell-xps-15-with-linux-even-on-battery
tags: []
draft: false
---

It's been more than a month since my [last post](http://www.akitaonrails.com/2017/01/31/from-the-macbook-pro-to-the-dell-xps-arch-linux-for-creative-pro-users) on tuning Manjaro for the Dell XPS 15.

Manjaro released it's newest release [version 17](https://manjaro.org/2017/03/07/manjaro-gnome-17-0-released/) and the kernel released 4.10. The upgrade from Manjaro 16 and kernel 4.9 went smoothly.

These are the currently installed, kernel specific packages:

---
$ pacman -Ss 410 | grep installed
core/linux410 4.10.1-1 [installed]
core/linux410-headers 4.10.1-1 [installed]
extra/linux410-acpi_call 1.1.0-0.7 (linux410-extramodules) [installed]
extra/linux410-bbswitch 0.8-0.7 (linux410-extramodules) [installed]
extra/linux410-ndiswrapper 1.61-0.7 (linux410-extramodules) [installed]
extra/linux410-nvidia 1:375.39-0.7 (linux410-extramodules) [installed]
---

And to make sure everything is ok, I removed the old 4.9 related packages:

---
sudo pacman -R linux49 linux49-headers linux49-acpi_call linux49-bbswitch linux49-ndiswrapper linux49-nvidia
---

I also upgraded the system BIOS to the [latest 1.2.19](http://dell.to/2mWmWDg) (although many said to stay at 1.2.18 for now, but I didn't downgrade). The BIOS upgrade is quite easy as you just need to have a FAT formatted USB drive and copy the "XPS_9550_1.2.19.exe" file. On boot, you can press F12 and choose the option to upgrade directly from there.

One thing that stopped working was the function keys to control screen brightness. I wasn't able to tweak it back but I can still control the brighness manually from the Terminal using commands like this:

---
xbacklight -inc 20 # to increment
xbacklight -dec 20 # to decrement
---

Then, the most annoying part: the NVIDIA Optimus card.

Suspending the OS works flawlessly most of the time. I can just close the lid, open the other day and the battery stays reasonably at the same level. Kudos to the kernel team for supporting it.

But the power management system turns off the NVIDIA GPU and I can't re-enable it after the machine wakes up, even if I reconnect to a power source. Whenever I try to run something through `optirun` (which forces the rendering through the NVIDIA GPU instead of the primary integrated Intel GPU) it errors out with this message:

---
Could not enable discrete graphics card
---

And the only way to have it running was to connect the power cord and reboot the machine. Then I could use the NVIDIA GPU normally. Rebooting all the time is not slow (thanks to the fast SSD) but it's still annoying to have to reopen every single application every time.

Finally, after a lot of research, I found out how to be able to have the NVIDIA GPU enabled even on battery and after suspend. First, you need to know the PCI ID for the card:

---
$ lspci | grep "NVIDIA" | cut -b -8
01:00.0
---

Then you need to edit `/etc/default/tlp` and add that PCI ID to be blacklisted from power management:

---
# Exclude PCI(e) device adresses the following list from Runtime PM
# (separate with spaces). Use lspci to get the adresses (1st column).
#RUNTIME_PM_BLACKLIST="bb:dd.f 11:22.3 44:55.6"
RUNTIME_PM_BLACKLIST="01:00.0"
---

Reboot, and this is it! Now I can run applications through the NVIDIA card even without being connected to the power cord.

It seems that [there is a conflict](https://github.com/linrunner/TLP/issues/244) between TLP and Bumblebee. The solution was listed in [this 2 months old reddit thread](https://www.reddit.com/r/archlinux/comments/5m78zz/bumblebee_nvidia_error_on_optimus_laptop/) and [this 2 weeks old Manjaro forum thread](https://forum.manjaro.org/t/bumblebee-could-not-enable-discrete-graphics-card/16728/12) if you're interested in the discussion around it.

The most difficult part on using NVIDIA on Linux is understanding all the many terminologies around it. I'm not even sure that I got it all already.

This is what I figured out so far:

* [Optimus](https://wiki.archlinux.org/index.php/NVIDIA_Optimus) is the hybrid graphics card technology, which enables a low power Intel GPU as the primary card that you can bridge to the secondary, power demanding, NVIDIA GPU, just when you really need it.
* `optirun` is the command you use to make this bridge.
* "NVIDIA" is what we call the official proprietary binaries. On Arch it's available on package "linux410-nvidia".
* "Nouveau" is the open source driver, it uses Primus to make the bridge instead of `optirun`. I understand that you should avoid this driver for now if you need full performance and full compliance from the GPU.
* ["Bumblebee"](https://wiki.archlinux.org/index.php/Bumblebee#Power_management) is a daemon used to enable and disable the NVIDIA GPU. You don't want it enabled all the time, specially when running on battery, to avoid draining it too fast.
* ["bbswitch"](https://github.com/Bumblebee-Project/bbswitch) is the kernel module that does the low level ACPI calls to control the power state of the NVIDIA GPU card.
* ["TLP"](https://github.com/linrunner/TLP) is the general Linux power management system, which controls every aspect of the machine's hardware, including the PCI devices (one of which is the NVIDIA card).

The way I understand it, you don't want TLP to kick in and shut off the card, because if it does, then Bumblebee can't enable it back on when needed (through bbswitch). So you have to blacklist it's PCI device on TLP and let Bumblebee do it's job.

If everything is working fine, then the NVIDIA GPU is turned off by default. You can check that it is off through bbswitch:

---
$ cat /proc/acpi/bbswitch
0000:01:00.0 OFF
---

Now, let's say you want to force something to use the card, so you do it like this:

---
$ optirun -vv glxgears
[ 1817.200384] [DEBUG]Reading file: /etc/bumblebee/bumblebee.conf
[ 1817.200519] [INFO]Configured driver: nvidia
[ 1817.200579] [DEBUG]optirun version 3.2.1-2017-02-27-Format:%h$ starting...
[ 1817.200584] [DEBUG]Active configuration:
[ 1817.200588] [DEBUG] bumblebeed config file: /etc/bumblebee/bumblebee.conf
[ 1817.200592] [DEBUG] X display: :8
[ 1817.200595] [DEBUG] LD_LIBRARY_PATH: /usr/lib/nvidia:/usr/lib32/nvidia
[ 1817.200599] [DEBUG] Socket path: /var/run/bumblebee.socket
[ 1817.200603] [DEBUG] Accel/display bridge: auto
[ 1817.200607] [DEBUG] VGL Compression: proxy
[ 1817.200611] [DEBUG] VGLrun extra options: 
[ 1817.200615] [DEBUG] Primus LD Path: /usr/lib/primus:/usr/lib32/primus
[ 1817.200645] [DEBUG]Using auto-detected bridge virtualgl
[ 1818.163747] [INFO]Response: Yes. X is active.

[ 1818.163757] [INFO]Running application using virtualgl.
[ 1818.163843] [DEBUG]Process vglrun started, PID 9770.
10419 frames in 5.0 seconds = 2083.766 FPS
10671 frames in 5.0 seconds = 2134.041 FPS
---

This will run `glxgears` (a simple app to test the card) through the Optimus bridge (in verbose mode, which is why you have all this extra information). And if `glxgears` was able to use the NVIDIA GPU it should report FPS (frames per second) higher than 1,000.

And you can check with `bbswitch` like this:

---
$ cat /proc/acpi/bbswitch
0000:01:00.0 ON
---

When you `Ctrl-C` out of `glxgears` it should report as `OFF` again.

Just to make sure, it's important to guarantee that `/etc/bumblebee/bumblebee.conf` is customized like this (only important keys are shown below):

---
[bumblebeed]
Driver=nvidia
...
[optirun]
Bridge=auto
...
[driver-nvidia]
KernelDriver=nvidia
PMMethod=bbswitch
...
---

So far, the only small issues I still have are these:

* Function keys don't change screen brightness
* Bose bluetooth headset connects flawlessly but won't become primary sound output without manually changing to it under the Sound settings (but hardware function keys for volume and media control all work without problems).
* I had to install Manjaro using the old BIOS boot and MBR partition scheme instead of GPT over UEFI. Not sure how to move to GPT/UEFI now (using a LUKS encrypted partition scheme)

But after fixing the NVIDIA GPU after a suspend or power disconnect, the other issues are just very minor annoyances.

So far, I am very happy to be using Manjaro over the Dell XPS. I am using a dual monitor setup, and everything is working quite smoothly. If you want to try it out, I recommend you stick to the 9560 (mid 2016 version) Sandy Bridge version, do not go to the new Kaby Lake versions yet as you will find buggy BIOS firmware and many aspects of the hardware won't be properly supported or documented yet.

And if you're new to Arch, I highly recommend you start with Manjaro GNOME. It's by far the best and most usable Linux desktop I've tried.
