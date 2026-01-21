---
title: "Omarchy 3: Setup de Dual GPUs com AMD e NVIDIA"
slug: "omarchy-3-setup-de-dual-gpus-com-amd-e-nvidia"
date: 2026-01-21T15:29:35-0300
description: "Descrição do post aqui"
tags:
- omarchy
- amd
- nvidia
- wayland
- hyprland
---

Mais um post só pra eu não me esquecer destes detalhes na configuração do [Omarchy](https://omarchy.org/):

> Hyprland não funciona bem com NVIDIA

Dá pra usar. Mas tem vários probleminhas, em particular com [Hyprlock](https://github.com/basecamp/omarchy/issues/1147), em particular com DPMS onde eu deixo meu computador em idle, daí ele se bloqueia, e depois de um timeout desliga os monitores pra economizar energia, não ter burn in, etc.

Quando eu tento acordar do sleep, o Hyprlock crasheou e eu preciso ir pra outro TTY pra reiniciar, até fiz um script `~/.local/bin/hypr_unlock.sh` assim:

```bash
hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'
hyprctl --instance 0 'dispatch exec hyprlock'
```

Mas aí desbloqueia e eu vejo que meu Brave crasheou também. A nvidia realmente não gosta que desliguem o monitor enquanto ele tá ativo. Disseram que isso acontecia no Hyprlock 0.9.1 mas eu já estou no 0.9.2 e continua crasheando. Tentei habilitar serviços como nvidia-suspend/resume/hibernate mas nada também.

No fim do dia resolvi que não vale a pena brigar com isso: eu tenho uma **AMD 7850X3D** e essa CPU tem uma iGPU (GPU integrada), uma AMD Raphael, que pra coisas como renderizar um gerenciador de janelas, é mais do que potente o suficiente.

Primeiro, detectar as GPUs:

```bash
❯ ls /dev/dri/by-path
Permissions Size User Date Modified Name
lrwxrwxrwx     - root 21 Jan 15:22   pci-0000:01:00.0-card -> ../card1
lrwxrwxrwx     - root 21 Jan 15:22   pci-0000:01:00.0-render -> ../renderD128
lrwxrwxrwx     - root 21 Jan 15:22   pci-0000:1a:00.0-card -> ../card2
lrwxrwxrwx     - root 21 Jan 15:22   pci-0000:1a:00.0-render -> ../renderD129
```

Pra saber qual é AMD e qual é NVIDIA só executar:

```bash
❯ lspci | grep -i vga
01:00.0 VGA compatible controller: NVIDIA Corporation GB202 [GeForce RTX 5090] (rev a1)
1a:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Raphael (rev c9)
```

Pronto, pelo ID de PCI sabemos que card1 é NVIDIA e card2 é AMD. Agora precisa configurar meu `~/.config/hypr/hyprland.conf`:

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

Eu deixei as configurações específicas de NVIDIA comentadas, nenhuma delas pode estar ativa. Mas a linha mais importante é a do `AQ_DRM_DEVICES` que lista a ordem pro Hyprland pegar a GPU. Card2/AMD tem que estar primeiro. E pronto, só rebootar e recolocar os cabos HDMI na saída da iGPU.

Com isso eu posso escolher agora dar offload de somente alguns apps da NVIDIA usando Prime. Pra isso primeiro eu criei os script `~/.local/bin/nvidia-load.sh`:

```bash
#!/bin/bash
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
```

Finalmente, configurei alguns bindings em `~/.config/hypr/bindings.conf`:

```bash
...
bindd = SUPER SHIFT, B, Blender, exec, ~/.local/bin/nvidia-load.sh blender
bindd = SUPER SHIFT, L, Bambu Studio, exec, ~/.local/bin/nvidia-load.sh bambu-studio
bindd = SUPER SHIFT, P, Blender, exec, ~/.local/bin/nvidia-load.sh plasticity
...
```

Desta forma, somente os apps Blender, Plasticity e Bambu Studio, que vão primariamente usar a NVIDIA pra renderizar 3D em real time. Todos os outros apps vão abrir na iGPU AMD.

Ferramentas de IA como ComfyUI, Ollama ou LM Studio automaticamente reconhecem a NVIDIA e escolhem lá. E com isso eu também tenho mais VRAM livre pra carregar LLMs.

Se for usar XLibre/X.org, dá pra ficar de boa em NVIDIA. Mas se for usar Wayland, nvidia ainda não é totalmente estável, em particular com Hyprland. Dá menos dor de cabeça colocar uma segunda GPU AMD só pra isso.
