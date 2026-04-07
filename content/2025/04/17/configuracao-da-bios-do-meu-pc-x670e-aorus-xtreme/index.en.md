---
title: BIOS Configuration of My PC - X670E Aorus Xtreme
date: '2025-04-17T18:50:00-03:00'
slug: bios-config-my-pc-x670e-aorus-xtreme
tags:
- amd
- performance
- linux
draft: false
translationKey: pc-bios-x670e-aorus
description: My BIOS tuning notes for a Ryzen 9 7950X3D on a Gigabyte X670E Aorus Xtreme, plus Linux-Zen kernel and an automated BIOS update checker.
---

This is a note to myself, so I don't forget, and maybe it helps someone else.


I know every motherboard ships pre-configured with safe and conservative "defaults", the most stable rather than the most performant. So if you don't go into the BIOS to tweak things, you're leaving performance on the table.

I have an AMD Ryzen 9 7950X3D CPU. The processor is a package that works with two "dies", I'm not sure if "chip" is a way to visualize it. Each one has 8 cores, totaling 16 cores, and each core has 2 threads, so 32 threads possible in parallel.

But there's a difference: each die has different L3 caches. One of the dies has only 32MB and the other has 96MB, so heavier programs benefit from running on the cores of the die with more L3, and you can configure that.

![lstopo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/gcbhrzj8wuc38z3lonisck0ooeck)

Besides that, it has a base clock of about 3GHz with the ability to turbo boost up to 5.7GHz. They can't all run at that speed or it heats up too fast and may "thermal throttle", and then it drops everything below 3GHz. That's why, especially in laptops that don't have adequate thermal capacity, the best option is not overclocking but "undervolting" (cutting power so it runs less fast). Because it's better for everyone to be a bit less fast than for everyone to be super fast and immediately overheat and slow everyone down. It's complex.

To complicate things further, I have 96GB of DDR5 6000 RAM. Capable of a theoretical maximum of 6GHz, but that's theoretical because everything can desync and cause instabilities up to a kernel panic crash. That's why the motherboard default is the base speed of about 4GHz and the CPU also maxing out at around 4GHz.

But you can push that up a bit without making it unstable. In short, here's what I did:

## PBO - Precision Boost Overdrive

Ryzen CPUs have PBO to turbo boost the core clocks. It usually ships either disabled or in a conservative configuration, so your 5.7GHz CPU may be running at only 4GHz or less and never delivering its maximum.

To adjust this, if you want to get advanced, you need to tweak parameters like PPT (Package Power Tracking) to 200W or more. TDC (Thermal Design Current) to 160A or more. EDC (Electrical Design Current) to 200A or more. And you can set up a curve optimizer, per core, to negative (-10 or -20) to reduce voltage, which can allow higher boost clocks.

But this is very advanced, and you need to know a lot more about electrical stuff before
trying it. Better not risk it and not mess with this. On the screen below, don't leave it on Advanced, leave it on Auto:

![PBO Advanced](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/vxeurat4imakwzdl6artkzuqymmq)

Instead, it's better to mess with PBO Enhancement Presets, which is this screen below:

![PBO Presets](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/a1vgigv3ka64xs6nclq9z2hh21w7)

**70/80/90** refers to the maximum temperature we allow the cores to reach. This will depend on whether you have a good cooling solution. Whether it's an AIO with liquid cooling or a [**Noctua NH-D15 G2**](https://noctua.at/en/nh-d15-g2), which is what I use. Noctua fans are extremely silent, I almost never hear them, and they have less maintenance and lower failure potential than liquid cooling. I prefer fewer moving parts to be safe.

[![Noctua NH-D15 G2](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/4d10atf2k9rb5pntb9eec5uzqk7u)

Now those **Level 1 to 5** are the PPT/TDC/EDC tunings I mentioned, but already pre-defined and tested by the manufacturer. 1 is less aggressive, the most stable, while 5 is the most aggressive and can be unstable. The right approach is to start at **90 level 5** and decrease until you find the most stable for your system. This will vary; for instance, the more RAM you have, the less aggressive it seems you can be, especially the faster that RAM is.

In my case, right at the boot of my Manjaro Linux, it gave a kernel panic, which looks something like this:

![kernel panic](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/f25kqct9urmereleunhurknw40d4)

So I went back into the BIOS and tested different levels and, for my configuration, I could only get up to **90 Level 2**. This has been stable and so far I haven't had any random crashes.

Beyond that, recently (early 2025) motherboard manufacturers released firmware updates that opened access to a feature called **X3D Turbo Mode**. If you see this, don't think it's free extra performance. In reality, unless you use the machine more for games, you'll actually feel it got slower.

As I explained before, Ryzen 9 has 1 CCD (core complex), which is the die with 96MB of L3 cache (V-Cache). Turbo mode tries to force more programs onto the CCD that does **NOT** have V-Cache (the 32MB one), which can therefore reach a higher clock boost but has more latency. This is good for games, which usually don't benefit from having more cache but rather from more clock.

But at the same time, programs that need V-Cache will end up landing more often on the Core with **LESS** L3 cache and will then perform worse than before. Examples of that are 3D modeling programs like Blender, exactly what I want to use more now. So test it, but in principle you can leave it off.

This option in my firmware is called "X3D Turbo Mode" but elsewhere it may be "3D V-Cache Performance Optimizer", same thing.

## XMP/EXPO RAM

Now, DDR5 RAM boots at the base clock of about 4.8GHz. But depending on the RAM model, it can go much higher, in my case up to 6GHz. All modern memory also has several settings like frequency, latency, voltage, and more. Again, it's not worth trying to set these by hand. Better to use predefined profiles. Intel calls this support **XMP** and AMD calls it **EXPO**.

I forgot to take a photo of my BIOS, but this slightly older photo from Google Images is the same thing. XMP/EXPO ships disabled (conservative) but you just pick the profile that already exists:

![XMP/EXPO Profile](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ypwo0rsbr1bmu6w6ujm7b1qyjlof)

Note that just below there are things like **Low Latency Support** and **High Bandwidth Support**. Theoretically to reduce latency and increase transfer bandwidth. All of which sounds great, but in my case it doesn't work. If I try to enable both, my system doesn't boot. I was forced to clear the CMOS to reset the BIOS without that.

The problem: possibly too much memory (96GB). Maybe if you have less, around 32GB, this works, but it seems the more you have, the more unstable it gets if you try to go too fast.

Another problem, on DDR5, the more memory, the slower the Cold Boot, the initial boot when the PC was off. The BIOS has to do a check on the memory to ensure those parameters, response time and so on. And this happens on **EVERY** boot. It can take a few minutes and some people might even think the machine is frozen, but it's just that check.

In the BIOS there's an option called **Memory Context Restore** where it uses the parameters it recorded the last time it did that check. But I don't recommend it; for me it doesn't even boot anymore after enabling it. Theoretically it would cut down the check time and reuse old data, but that data may not match (the values can fluctuate) and that makes the whole system unstable. Better to wait an extra minute on boot than to live with an unstable system.

In advanced memory settings there's one more thing we should change: **DF C-States**, which needs to be **DISABLED**. In theory this feature is to reduce the latency between CPU and memory. But on systems with a lot of RAM (96GB or more like mine) this can also cause instability for not much noticeable gain. I prefer staying stable in this case.

Another setting to change is **Power Supply Idle Control**, which has to be set to "Typical Current Idle", and so far (a firmware fix update may come), it's mandatory for Ryzen processors (even AM5). This prevents the "Deep Power State" sleep state, which can cause random kernel panics.

Same thing for **Global C-State Control**, which also needs to be disabled for the same reason: avoid "deep sleep states" (C6/C10) when the CPU sits in "idle" (doing nothing) for too long. These features exist to save energy, but it seems AMD has bugs when the CPU is forced into that state and when it wakes up, it comes back unstable or crashing. So it'll consume more energy when doing nothing (around less than 20W, rather than near zero), but at least it won't be unstable. If you want to save energy, the better option is to shut down and actually cut the power when not using it.

## BIOS Summary (for me)

+ PBO Enhancement: **90 Level 2** (clock boost slightly more aggressive than the default)
+ Power Supply Idle Control: **Typical Current Idle** (prevents the idle crash bug)
+ Global C-State Control: **Disabled** (avoids deep sleep, which causes instability)
+ DF C-States: **Disabled** (also avoids sleep, improving Infinity Fabric latency)
+ XMP/EXPO: **Profile XMP1** if you have it (raises the memory clock)

There are 2 important things, especially if you're using discrete GPUs:

* Above 4G Decoding and Re-Size Bar Support. In my case both are on by default; if yours are off, turn them on.

On Linux, you can check if it's enabled. Run the following:

`sudo lspci -vv | grep -A 15 VGA`

You should see "Resizable BAR" like this:

`Capabilities: [XX] PCI Express, ... Resizable BAR: Supported (Enabled)`

If it doesn't show up, go to the BIOS and look for it to enable. Without this you're not using the maximum of your video card. I think on iGPUs (which are GPUs already built into the CPU) this option doesn't exist.

## Linux-Zen Kernel

I've always used the most stable LTS default kernel, currently Linux66, if I'm not mistaken. But I remembered I can use the Zen kernel, which is the same default kernel Arch uses with performance tunings to improve latency, especially in multi-thread. It switches to the CFS scheduler with improvements. Theoretically, it improves overall system responsiveness. I think it's worth using. On Arch/Manjaro it's like this:

`yay -S linux-zen-versioned-bin linux-zen-versioned-headers-bin`

This will uninstall the old kernel and, if you're using NVIDIA GPUs, it'll also uninstall the driver package. So you also need to install the following package:

`yay -S nvidia-dkms`

And then, with everything installed, run the following command:

`sudo dkms autoinstall`

This will reinstall the nvidia driver binaries for the new Zen kernel. In Manjaro's case, you don't need to mess with GRUB because in my case it's set to `GRUB_DEFAULT=saved` in `/etc/default/grub`. That means when it reboots, it'll record which kernel I last chose, and on the next reboot, if I don't choose anything, it'll load again the last kernel I picked. I prefer it this way over hard-coding which kernel is the default.

Once that's done, on the next boot just check:

```
❯ uname -r
6.14.2-zen1-1-zen
```

Another thing is to check if **CPPC** is active. That's **Collaborative Processor Performance Control**, a feature that exposes to the OS kernel a ranking of cores (which has the highest boost, which has more cache, etc). Remember the X3D Turbo Mode I mentioned earlier? Same concept: to help the OS pick which core to send each program to so it runs better.

Not every motherboard firmware exposes this as an option; in the case of my Gigabyte X670E, it doesn't exist. That probably means it's already on by default. To check if it's on, just go to the Linux terminal and run:

```
cat /sys/devices/system/cpu/cpu*/cpufreq/amd_pstate_highest_perf
```

If it returns any result, it means it's on and the firmware is informing the kernel about the characteristics of each core, so the scheduler has more information to manage where to send each thread.

Another way to check:

```
ls /sys/devices/system/cpu/cpu0/cpufreq/
```

It needs to return a list containing names like these:

```
amd_pstate_highest_perf
amd_pstate_nominal_perf
amd_pstate_preferred_core
```

Which, again, is a sign that Linux is recognizing CPPC properly.

Manjaro itself, besides the stable kernels, has the "linux-rt" versions which are for real-time systems. Technically, this is meant not just for lower latency, but for stable and more predictable latencies. **DO NOT USE THIS KIND OF KERNEL**. This is for factory systems or things like that which need processing determinism and have no tolerance for random latency. It doesn't mean it'll run more responsively; it might even run slower, but the important thing is that it's a predictable slow.

Others might mention the **Linux Liquorix** kernel, which many compare to Zen. But while Zen is based on the same kernel Arch uses, Liquorix's is based on the Debian/Ubuntu version. So it's not recommended on Arch/Manjaro. On top of that it's more experimental and theoretically less stable too. Use it if you're on Ubuntu or derivatives. On Arch, better stick with Zen.
## check_ryzen_perf.sh

If you have a Ryzen system, copy the following script and run it on your machine:

```bash
#!/bin/bash

echo "🔍 Verifying Ryzen 7950X3D Tuning on Linux"

echo -n "✅ CPU Driver: "
grep . /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver

echo -n "✅ EPP Mode: "
cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference

echo -n "✅ CPPC Detected: "
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/amd_pstate_highest_perf ]; then
  echo "Yes"
else
  echo "No"
fi

echo -n "✅ Preferred Core Ranking: "
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/amd_pstate_prefcore_ranking ]; then
  echo "Yes"
else
  echo "No"
fi

echo -n "✅ Running Kernel: "
uname -r

echo -e "\n✅ All key Linux-side Ryzen tuning options appear active.\n"
```

On my machine it now produces this result:

```
🔍 Verifying Ryzen 7950X3D Tuning on Linux
✅ CPU Driver: amd-pstate-epp
✅ EPP Mode: performance
✅ CPPC Detected: Yes
✅ Preferred Core Ranking: Yes
✅ Running Kernel: 6.14.2-zen1-1-zen

✅ All key Linux-side Ryzen tuning options appear active.
```

Saying that, theoretically, all the performance bits seem to be active and working. If one of them isn't, ask ChatGPT what to do for your setup.

## Checking the BIOS Version

Many motherboard manufacturers offer software, for Windows, to automatically download and update the firmware. But in Gigabyte's case, there's no Linux support. To check which version is currently installed, without having to enter the BIOS, on Linux there's this command:

`sudo dmidecode -s bios-version`

In my case, it now returns F33 (March 2025 version). Now, to compare whether that's the newest version, I just have to manually go to Gigabyte's crappy site, which in my case is [this link](https://www.gigabyte.com/Motherboard/X670E-AORUS-XTREME-rev-10/support). For your specific model, and manufacturer of course, this link will vary.

[![x670e support page](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/72l1if05q22u1ogowfzws9rtz95j)](https://www.gigabyte.com/Motherboard/X670E-AORUS-XTREME-rev-1x/support#support-dl)

To make it worse, it seems the content is loaded asynchronously by javascript, so if you try to use `wget` or `curl` from the command line, the content won't have loaded yet.

I decided to write a dumb script to solve that. First, in case you don't use `mise` like I do (see my Github project [Omakub-MJ](https://github.com/akitaonrails/omakub-mj) for a setup just like mine), install Node manually like this:

`sudo pacman -S nodejs npm`

Create some directory for the project and from there do:

```
npm init -y
npm install -g playwright
npx playwright install
```

Create a file `check_bios_playwright.js` with this content:

```js
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  // Load support page
  await page.goto('https://www.gigabyte.com/Motherboard/X670E-AORUS-XTREME-rev-10/support', { waitUntil: 'domcontentloaded' });

  // Click the BIOS tab manually (it triggers JS to fetch content)
  await page.click('id=bios-count');

  // Wait for BIOS version element to load
  await page.waitForSelector('.div-table-body-BIOS .download-version', { timeout: 60000 });

  // Grab the first BIOS version listed
  const biosVersion = await page.$eval('.div-table-body-BIOS .download-version', el => el.innerText.trim());

  console.log('🌐 Latest BIOS Version on Gigabyte site:', biosVersion);

  await browser.close();
})();
```

Now create a bash script `check_bios_update.sh` with this content:

```bash
#!/bin/bash

# Get directory of this script (absolute path)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get current BIOS version
CURRENT=$(sudo dmidecode -s bios-version | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

# Run the Playwright JS script in the same directory
LATEST=$(node "$SCRIPT_DIR/check_bios_playwright.js" | grep -o 'F[0-9]\+')

# Output
echo "🖥  Current BIOS: $CURRENT"
echo "🌐 Latest BIOS:  $LATEST"

if [[ "$CURRENT" == "$LATEST" ]]; then
  echo "✅ You are up to date."
else
  echo "⬆  BIOS update available!"
fi
```

Do a `chmod +x` to make it executable and, if all goes well, you'll get a response like this:

```
[sudo] password for akitaonrails:
🖥  Current BIOS: F33
🌐 Latest BIOS:  F33
✅ You are up to date.
```

It's a cannon shot to kill a fly, but this will use headless Chromium to pull the page, load the javascript, and then use CSS selectors to find the BIOS version, compare it to the one on your machine, and see if it's up to date.

If it isn't, there's no way around it: you have to manually go to the site, download the ZIP file, extract it onto a pen drive, and boot into the BIOS to update manually. But at least I can quickly check from time to time with one command line now.

## Automatic BIOS Version Check

I decided I don't want to remember to run that script manually, so the best thing is to create a user systemd service and check automatically every week. If there's a new version, create a notification to GNOME so I can see it visually and automatically open the download page for me.

First, I need to give my user access to the dmidecode command to check my current BIOS version without having to type a password with `sudo`. To do that, let's create a new sudoers rule like this:

```
sudo visudo -f /etc/sudoers.d/bios-check
```

It'll open an empty file where I fill in like this:

```
sudo /usr/sbin/dmidecode -s bios-version
```

And don't forget to set the correct permissions on this file:

```
sudo chmod 0440 /etc/sudoers.d/bios-check
```

With that it won't ask for a password to run that command anymore, since we're going to put it in a background service running automatically. Obviously it's not safe to allow running `sudo` without a password, so we restrict it exclusively to allow it only on that specific binary and nothing else.

In the same directory as the other files with playwright installed and so on, I create a `bios-update-check.sh` with this content:

```bash
#!/bin/bash

# Path to your Playwright BIOS scraper script
JS_CHECKER="$HOME/bios-check/check_bios_playwright.js"
NODE_BIN="$(which node)"

# URL of your motherboard's BIOS support page
URL="https://www.gigabyte.com/Motherboard/X670E-AORUS-XTREME-rev-10/support#support-dl-bios"

# Get current BIOS version
CURRENT=$(sudo dmidecode -s bios-version | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

# Get latest BIOS version from Gigabyte site
LATEST=$($NODE_BIN "$JS_CHECKER" | grep -o 'F[0-9]\+' | head -1)

if [[ -z "$LATEST" ]]; then
  notify-send "BIOS Check" "⚠️ Failed to fetch latest BIOS version from Gigabyte"
  exit 1
fi

if [[ "$CURRENT" != "$LATEST" ]]; then
  notify-send -u normal "🔔 BIOS Update Available!" "Current: $CURRENT → Latest: $LATEST

Opening the download page..." --app-name="BIOS Checker"
  xdg-open "$URL"
fi
```

It's the same as the previous script but now using `notify-send` to send messages to Gnome (in KDE it's different) and using `xdg-open` to open the URL in the system's default browser. Configure differently for your system. Don't forget to make it executable and test:

```
chmod +x ~/.local/bin/bios-update-check.sh
```

Now to create the systemd service for my user (different from creating one for the system that runs with more permissions. I only need this running at my user level), so I create the file `~/.config/systemd/user/bios-check.service` with the following content:

```
[Unit]
Description=Weekly BIOS version checker

[Service]
Type=oneshot
ExecStart=/home/akitaonrails/.local/bin/bios-check/bios-update-check.sh
```

Now the timer service to run every week, called `~/.config/systemd/user/bios-check.timer`:

```
[Unit]
Description=Run BIOS version check weekly

[Timer]
OnCalendar=weekly
Persistent=true

[Install]
WantedBy=default.target
```

And enable the timer:

```
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now bios-check.timer
```

By Systemd convention, a timer [blabla].timer will execute the service with the same name [blabla].service. That's why you need both. If you enable the service directly, it'll run only once and exit. To know if it's enabled correctly do the following:

```
✦ ❯ systemctl --user list-timers

NEXT                          LEFT LAST PASSED UNIT             ACTIVATES
Mon 2025-04-21 00:00:00 -03 2 days -         - bios-check.timer bios-check.service

1 timers listed.
Pass --all to see loaded but inactive timers, too.
```

And that's how you can automate some things on your system and get more out of your Gnome.

## Conclusion

I only started this journey this time because it occurred to me that it had been months since I'd last updated the motherboard firmware, and then I took the chance to tune some things I hadn't done before. Things like PBO were on automatic (so I was leaving performance behind; I remember that last time it had been unstable but I didn't dig in to find out why), things like XMP/EXPO were already on. But now I think I really enabled everything I could.

It had also been years since I tried out the Linux-Zen kernel, so I took the chance to test it now. And as I said, so far it's stable. Since I've started learning Blender and pulling more CPU and memory, I figured it was worth spending time trying to extract the most from my machine. 3D modeling is totally CPU/RAM, more than GPU.

Oh yes, speaking of Blender, one last thing. Remember my Ryzen has 1 CCD, which is that 1 die with 96MB of L3 cache. The best thing to do is create affinity for Blender with that die and prevent it from landing on the core with only 32MB of L3 cache.

On Linux, to do that, here's the command line:

`taskset -c 0-15 blender-4.3 &`

The taskset command will hint to the scheduler that blender should stay on threads 0 to 15 (where the V-Cache is) and not 16 to 31 (which only have 32MB). That way, in theory, I'm giving Blender the best chances to run at the best possible performance on this machine. Less important programs like the browser, the terminal, if they land on the 32MB core, no problem.

I do the same thing in libvirt/qemu when I run emulated Windows: I configure libvirt to bring up the VM tied to the 96MB CCD and leave the other core for the Linux host. Speaking of BIOS, by the way, to run VMs you have to enable SVM and IOMMU, which usually ship disabled because virtual machine support steals a bit of the CPU's performance. Maximum performance is with them **disabled**. If you're not going to use VMs, leave them off.

And if anyone noticed that I'm explicitly running Blender 4.3 instead of the newer Blender 4.4, it's because some addons still don't work on the newer version, so it's better to stay one version back to keep more compatibility with addons that don't update fast.
