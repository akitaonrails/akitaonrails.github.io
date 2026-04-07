---
title: "Omarchy 3: Dual GPU Setup with AMD and NVIDIA"
slug: "omarchy-3-dual-gpu-setup-with-amd-and-nvidia"
date: 2026-01-21T15:29:35-0300
description: "How I configured Hyprland on Omarchy to use an AMD iGPU as primary and offload 3D apps to an NVIDIA RTX 5090 via Prime."
tags:
- omarchy
- amd
- nvidia
- wayland
- hyprland
translationKey: omarchy-3-dual-gpu-setup
---

Another post just so I don't forget these details when configuring [Omarchy](https://omarchy.org/):

> Hyprland doesn't play nice with NVIDIA

You can use it. But there are several little problems, particularly with [Hyprlock](https://github.com/basecamp/omarchy/issues/1147), and particularly with DPMS where I leave my computer idle, it locks itself, and after a timeout turns off the monitors to save power, avoid burn-in, etc.

When I try to wake it from sleep, Hyprlock crashed and I have to jump to another TTY to restart it. I even wrote a `~/.local/bin/hypr_unlock.sh` script like this:

```bash
hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'
hyprctl --instance 0 'dispatch exec hyprlock'
```

But then I unlock and see that my Brave crashed too. NVIDIA really doesn't like the monitor being turned off while it's active. People said this happened in Hyprlock 0.9.1, but I'm already on 0.9.2 and it still crashes. I tried enabling services like nvidia-suspend/resume/hibernate, but nothing worked either.

At the end of the day I decided it's not worth fighting with this: I have an **AMD 7850X3D**, and this CPU has an iGPU (integrated GPU), an AMD Raphael, which for things like rendering a window manager is more than powerful enough.

First, detect the GPUs:

```bash
❯ ls /dev/dri/by-path
Permissions Size User Date Modified Name
lrwxrwxrwx     - root 21 Jan 15:22   pci-0000:01:00.0-card -> ../card1
lrwxrwxrwx     - root 21 Jan 15:22   pci-0000:01:00.0-render -> ../renderD128
lrwxrwxrwx     - root 21 Jan 15:22   pci-0000:1a:00.0-card -> ../card2
lrwxrwxrwx     - root 21 Jan 15:22   pci-0000:1a:00.0-render -> ../renderD129
```

To find out which is AMD and which is NVIDIA, just run:

```bash
❯ lspci | grep -i vga
01:00.0 VGA compatible controller: NVIDIA Corporation GB202 [GeForce RTX 5090] (rev a1)
1a:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Raphael (rev c9)
```

Done. From the PCI ID we know card1 is NVIDIA and card2 is AMD. Now I need to configure my `~/.config/hypr/hyprland.conf`:

```bash
....
# NVIDIA environment variables
env = NVD_BACKEND,direct
#env = LIBVA_DRIVER_NAME,nvidia
env = LIBVA_DRIVER_NAME,radeonsi
#env = __GLX_VENDOR_LIBRARY_NAME,nvidia

# Comment these out when using AMD as primary
#env = __NV_PRIME_RENDER_OFFLOAD,1
#env = __VK_LAYER_NV_optimus,NVIDIA_only

# card1=nvidia, card2=amdgpu (verify with: cat /sys/class/drm/card*/device/uevent)
# AMD first for iGPU primary:
env = AQ_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1

env = ELECTRON_OZONE_PLATFORM_HINT,auto
```

I left the NVIDIA-specific settings commented out; none of them can be active. But the most important line is `AQ_DRM_DEVICES`, which lists the order for Hyprland to pick the GPU. Card2/AMD has to come first. Done, just reboot and move the HDMI cables to the iGPU output.

With that, I can now choose to offload only some apps to the NVIDIA using Prime. For that, I first created the script `~/.local/bin/nvidia-load.sh`:

```bash
#!/bin/bash
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
```

Finally, I configured some bindings in `~/.config/hypr/bindings.conf`:

```bash
...
bindd = SUPER SHIFT, B, Blender, exec, ~/.local/bin/nvidia-load.sh blender
bindd = SUPER SHIFT, L, Bambu Studio, exec, ~/.local/bin/nvidia-load.sh bambu-studio
bindd = SUPER SHIFT, P, Blender, exec, ~/.local/bin/nvidia-load.sh plasticity
...
```

This way, only Blender, Plasticity, and Bambu Studio, which primarily use the NVIDIA to render 3D in real time. All the other apps open on the AMD iGPU.

AI tools like ComfyUI, Ollama, or LM Studio automatically recognize the NVIDIA and pick it. And with that I also have more free VRAM to load LLMs.

If you're going to use XLibre/X.org, you can stay on NVIDIA just fine. But if you're going to use Wayland, NVIDIA still isn't fully stable, particularly with Hyprland. It's less of a headache to drop in a second AMD GPU just for this.
