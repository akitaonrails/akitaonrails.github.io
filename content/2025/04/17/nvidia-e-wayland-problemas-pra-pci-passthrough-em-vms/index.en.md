---
title: NVIDIA and Wayland - Problems for PCI Passthrough in VMs
date: '2025-04-17T19:35:00-03:00'
slug: nvidia-and-wayland-problems-for-pci-passthrough-in-vms
tags:
- nvidia
- wayland
- manjaro
- arch
- gnome
- libvirt
- qemu
draft: false
translationKey: nvidia-wayland-pci-passthrough
description: How GNOME on Wayland breaks live NVIDIA GPU passthrough to QEMU/Libvirt VMs, and the workaround scripts I use to make it work again.
---

Another article that's mostly so I don't forget and serves as a note to myself.

In February 2023 I made a long video about how I configured Windows to run emulated in a QEMU/Libvirt VM, managing to pass my second GPU, an RTX 4090, into the VM, making it possible to run heavy games even while emulating Windows. If you haven't watched it, it's at [this link](https://www.akitaonrails.com/2023/02/01/akitando-137-games-em-maquina-virtual-com-gpu-passthrough-entendendo-qemu-kvm-libvirt).

In short, I have a beefy machine, a Ryzen 9 7950X3D with 96GB of RAM. This CPU has an iGPU, a weak integrated AMD GPU. Weak but more than enough to run GNOME on two monitors, with HDR support and at 4K without any stutter. For day-to-day use, which is mostly opening a browser, it's more than enough.

This GPU loads on Linux with the driver that ships in the kernel, `amdgpu`, and is mounted as `/dev/dri/card1`. Then I added a 2nd GPU, the beefy RTX 4090 with 24GB of GDDR6X VRAM. Not enough to run the heaviest LLMs, but it can run enough. I bought it primarily for games, but I end up using it for AI and 3D rendering as well.

Now the concept is simple: at boot, Linux needs to ignore this card and not load the NVIDIA drivers. If it does that, I can't later pass it into the Windows VM. I used to edit my channel's videos in DaVinci Resolve, which used plugins that only work on Windows; that was one of the reasons at the time. Resolve itself works on Linux too, but many plugins don't. I also preferred using Photoshop, which is also Windows-only.

For this we configure Linux to load a fake driver, called `vfio-pci`, in place of the NVIDIA driver (or the open source alternative, Nouveau). In the other article I explain in more detail, but it's a huge pain to configure this by hand. I don't know if it still works, but at the time I also used a script that automates this, [GPU-Passthrough-Manager](https://github.com/uwzis/GPU-Passthrough-Manager). It configures everything to prevent the NVIDIA drivers from loading and switches to vfio-pci correctly. I think it also works on Optimus laptops, when you have a weaker iGPU (to save battery) and a separate discrete GPU, but I haven't tested that in years so don't ask me, ask ChatGPT.

Since 2023 this has worked great. I have a script called `nvidia-locker` that's in the other article. If I want to run LLMs or Blender on my native Linux, I run that script and it removes vfio-pci and puts the NVIDIA driver back in real time, without rebooting. Then when I'm done and need to boot into Windows, I run the script again and it unloads the driver in real time too, allowing it to be passed via PCI Passthrough to the QEMU VM. All neat and tidy.

That is, until a few months ago, when Arch and Manjaro updated to swap out the old legacy **Xorg for Wayland**. These days Wayland is much more stable, its portals work properly and I can use webcam, microphone, tablet and everything else without any problem. Everything works and, theoretically, Wayland is supposed to be better. The new GNOME 48 also turned out really good, with HDR support and all. Anyway, everything's pretty slick, I recommend it.

Except for the GNOME/Wayland combo with an NVIDIA GPU specifically in this PCI Passthrough to VM scenario. In short: boot still works normally, vfio-pci loads and hides the NVIDIA GPU. My `nvidia-locker` script also manages to hot-reload the NVIDIA driver. The problem is when I try to unload the driver to open the VM: GNOME won't let me.

Wayland is super aggressive and as soon as it detects that a new GPU has appeared, it loads the `gnome-shell` process onto that GPU. And since there's a process attached, there's no way to remove the driver hot anymore. Only by rebooting, and that's a pain.

There's no easy solution. I tried dozens of different things like permissions, UDEV rules, SystemD services, kernel options, but nothing prevents the damn `gnome-shell` or `gjs` (Flatpak portal) processes from latching onto the GPU.

There's only one way, kind of a hack:

* first, configure GDM (which loads GNOME and is the parent process) to not auto-restart automatically if it dies
* second, switch to another TTY (Ctrl+Alt+F3, for example), kill GDM from there and only then unload the NVIDIA driver.
* third, when the driver is swapped for vfio-pci, now the GPU is off and you can restart GDM and log back in. Just a pain that the open graphical apps will die, but it's faster than a full PC reboot.

## 1 - disable GDM auto-restart

```
# Disable GDM auto-restart
sudo mkdir -p /etc/systemd/system/gdm.service.d
sudo tee /etc/systemd/system/gdm.service.d/10-no-restart.conf <<EOF
[Service]
Restart=no
EOF

# Update systemd
sudo systemctl daemon-reload
```

This config prevents GDM from auto-restarting. Now I can kill it. Without doing this, if I kill GDM, it reopens too fast and there's no time to remove the NVIDIA driver before that.

## 2 - Trying to keep Wayland from grabbing the GPU

The GPU-Passthrough-Manager script theoretically already does this, but to be safe it's good to have the following:

First, in `/etc/modprobe.d/blacklist-nvidia.conf`:

```
blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_uvm
blacklist nvidia_peer_mem
blacklist nvidia_modeset
blacklist nvidia-nvlink
blacklist xhci_pci
blacklist ucsi_ccg
options nvidia NVreg_EnableGpuFirmware=0
```

Second, in `/etc/modprobe.d/nvidia.conf`:

```
options nvidia_drm modeset=0
options nvidia NVreg_InitializeSystemMemoryAllocations=0
```

The modeset option is to try to keep nvidia_drm from latching onto the GPU, but this didn't work either. It's optional, I don't know if there's a problem leaving it or removing it back to modeset=1. I think this matters more if you use the Nvidia GPU as the primary GPU where your graphical interface actually runs, especially to support Wayland correctly.

The other attempt is with UDEV rules in `/etc/udev/rules.d/80-nvidia-composite.rules`:

```
# Unified NVIDIA/AMD GPU management
ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x10de", \
    RUN+="/bin/sh -c 'chmod 000 /dev/dri/%k; echo GNOME_MUTTER_IGNORE_DEVICE=1 >> /etc/environment'"

ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x1002", \
    RUN+="/bin/sh -c 'chmod 660 /dev/dri/%k; chown root:video /dev/dri/%k'"

# New critical addition:
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{enable}="0"
```

The idea is to try to change the chmod attributes to 000, but that didn't work either.

The last attempt was trying a Systemd service in `/etc/systemd/system/nvidia-lock.service`:

```
[Unit]
Description=Hardened NVIDIA Lock
Before=display-manager.service
Conflicts=multi-user.target

[Service]
Type=oneshot
# Merge of both prepare scripts
ExecStart=/bin/sh -c 'echo 0 > /sys/class/vtconsole/vtcon0/bind'
ExecStart=/bin/sh -c 'echo 0 > /sys/class/vtconsole/vtcon1/bind'
ExecStart=/bin/sh -c 'chmod 000 /dev/dri/card0'
ExecStart=/bin/sh -c 'for card in /dev/dri/card*; do [ "$(cat /sys/class/drm/${card##*/}/device/vendor)" == "0x10de" ] && chmod 000 "$card"; done'

[Install]
WantedBy=graphical.target
```

Same idea of trying to block Wayland via tighter permissions, but it didn't work either. I think there's no harm in leaving this running but you can skip to the next section.

## 3. What worked

After much testing, I now have two scripts (just to keep it less spaghetti). Here's the `nvidia-unlock` script that unloads the NVIDIA driver and has to be run from a different TTY than the one running GDM:

```bash
#!/bin/bash
# /usr/local/bin/nvidia-unlock - Improved version with session handling

# Store current TTY
CURRENT_TTY=$(tty | sed 's/\/dev\/tty//')
IS_GDM_RUNNING=$(systemctl is-active gdm)

# 1. Stop GDM gracefully
if [ "$IS_GDM_RUNNING" = "active" ]; then
  echo "Stopping GDM..."
  sudo systemctl stop gdm
fi

# 2. Kill all graphical processes
echo "Terminating graphical sessions..."
sudo pkill -9 -f "gnome-shell|gjs|Xwayland"
sleep 1

# 3. Nuclear GPU unbind
echo "Removing PCI devices..."
echo "1" | sudo tee /sys/bus/pci/devices/0000:01:00.0/remove >/dev/null
echo "1" | sudo tee /sys/bus/pci/devices/0000:01:00.1/remove >/dev/null
sleep 1

# 4. Purge drivers
echo "Unloading NVIDIA modules..."
sudo rmmod nvidia_drm nvidia_modeset nvidia_uvm nvidia 2>/dev/null

# 5. Rescan PCI
echo "Rescanning PCI bus..."
echo "1" | sudo tee /sys/bus/pci/rescan >/dev/null
sleep 1

# 6. Restore GDM if it was running
if [ "$IS_GDM_RUNNING" = "active" ]; then
  echo "Restarting GDM..."
  sudo systemctl start gdm

  # Return to original TTY
  sleep 3 # Wait for GDM to initialize
  sudo chvt $CURRENT_TTY
fi

# 7. Final verification
if ! lsmod | grep -q nvidia; then
  echo "✅ NVIDIA GPU successfully unlocked"
else
  echo "❌ Failed to fully unlock GPU"
  exit 1
fi

``` 

This script kills everything under GDM, GNOME Shell, the open graphical programs, everything, so don't leave your Libreoffice open without saving if you run this, it will kill it all. That's why you have to do Ctrl+Alt+F3 and run it from a separate terminal.

And now, here's my new `nvidia-locker`:

```bash

#!/bin/bash
# nvidia-locker - Final working version with proper TTY handling

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configuration
NVIDIA_GPU="0000:01:00.0"
NVIDIA_AUDIO="0000:01:00.1"
PCI_PATH="/sys/bus/pci/devices"
DRM_PATH="/dev/dri"
UNLOCK_SCRIPT="${SCRIPT_DIR}/nvidia-unlock" # Look in same directory

#  Core Functions 

get_driver() {
  local device="$1"
  if [ -d "$PCI_PATH/$device/driver" ]; then
    basename $(readlink "$PCI_PATH/$device/driver") 2>/dev/null || echo "none"
  else
    echo "none"
  fi
}

is_gui_session() {
  # Returns true if running in a graphical session
  [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]
}

print_status() {
  echo -e "\nCurrent GPU Status:"
  lspci -nnk -d 10de:2684
  lspci -nnk -d 10de:22ba
  echo
}

load_vfio() {
  echo "🔒 Binding to vfio-pci..."
  echo "vfio-pci" | sudo tee "$PCI_PATH/$NVIDIA_GPU/driver_override" >/dev/null
  echo "vfio-pci" | sudo tee "$PCI_PATH/$NVIDIA_AUDIO/driver_override" >/dev/null
  echo "$NVIDIA_GPU" | sudo tee /sys/bus/pci/drivers/vfio-pci/bind >/dev/null
  echo "$NVIDIA_AUDIO" | sudo tee /sys/bus/pci/drivers/vfio-pci/bind >/dev/null
}

load_nvidia_headless() {
  echo "🔓 Loading NVIDIA in headless mode..."

  # Clear any existing overrides
  echo "" | sudo tee "$PCI_PATH/$NVIDIA_GPU/driver_override" >/dev/null
  echo "" | sudo tee "$PCI_PATH/$NVIDIA_AUDIO/driver_override" >/dev/null

  # Load modules with headless options
  sudo modprobe nvidia NVreg_InitializeSystemMemoryAllocations=0
  sudo modprobe nvidia_modeset
  sudo modprobe nvidia_uvm
  sudo modprobe nvidia_drm modeset=0

  # Bind devices
  echo "$NVIDIA_GPU" | sudo tee /sys/bus/pci/drivers/nvidia/bind >/dev/null
  echo "$NVIDIA_AUDIO" | sudo tee /sys/bus/pci/drivers/nvidia/bind >/dev/null

  # Lock DRM nodes
  sudo chmod 000 "$DRM_PATH/card0" 2>/dev/null # NVIDIA
  sudo chmod 660 "$DRM_PATH/card1" 2>/dev/null # AMD
}

#  Command Handlers 

vm_mode() {
  current_driver=$(get_driver "$NVIDIA_GPU")

  if [[ "$current_driver" == "nvidia" ]]; then
    if is_gui_session; then
      echo "⚠️  Please switch to TTY (Ctrl+Alt+F2) and run:"
      echo "   sudo systemctl stop gdm && sudo nvidia-unlock"
    else
      echo "⚠️  Already in TTY - running nvidia-unlock..."
      if [ -x "$UNLOCK_SCRIPT" ]; then
        sudo "$UNLOCK_SCRIPT"
      else
        echo "❌ Error: nvidia-unlock not found at ${UNLOCK_SCRIPT}"
        echo "ℹ️  Make sure both scripts are in the same directory"
        exit 1
      fi
    fi
    exit 1
  fi

  load_vfio
  print_status
}

host_mode() {
  current_driver=$(get_driver "$NVIDIA_GPU")
  if [[ "$current_driver" == "vfio-pci" ]]; then
    echo "🔄 Releasing vfio-pci binding..."
    echo "$NVIDIA_GPU" | sudo tee /sys/bus/pci/drivers/vfio-pci/unbind >/dev/null
    echo "$NVIDIA_AUDIO" | sudo tee /sys/bus/pci/drivers/vfio-pci/unbind >/dev/null
  fi

  load_nvidia_headless
  echo && nvidia-smi
  print_status
}

#  Main 

case "$1" in
on) vm_mode ;;
off) host_mode ;;
status) print_status ;;
*)
  echo "Usage: $0 [on|off|status]"
  echo "  on     - Prepare GPU for VM (may require nvidia-unlock)"
  echo "  off    - Enable NVIDIA for host (headless mode)"
  echo "  status - Show current GPU status"
  exit 1
  ;;
esac

```

To run it it's the same thing: `nvidia-locker off` will lift the vfio-pci block and load the Nvidia drivers when I want to run an AI LLM natively on my Linux or render something in Blender with Cycles.

After I'm done, and I want to run Windows in the VM. Ctrl-Alt-F3, fresh login on the plain text terminal, and `nvidia-locker on`. This will kill GDM, unload the NVIDIA drivers, reload the vfio-pci block and restart GDM so I can log back into graphical mode. And from there I can launch via the `virsh start` command or using the Virtual Machine Manager GUI if I want to use Display Spice, for example.

And that's it, the article is more so I don't forget what I did, to use as a reference in the future.
