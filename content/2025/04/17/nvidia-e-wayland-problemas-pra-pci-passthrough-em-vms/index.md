---
title: NVIDIA e Wayland - Problemas pra PCI Passthrough em VMs
date: '2025-04-17T19:35:00-03:00'
slug: nvidia-e-wayland-problemas-pra-pci-passthrough-em-vms
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
---

Mais um artigo que é mais pra eu não me esquecer e servir de anotação pra mim.

Em Fevereiro de 2023 eu fiz um longo video sobre como eu configurei Windows pra rodar emulado em VM de QEMU/Libvirt e conseguindo passar minha 2a GPU, que é a RTX 4090 pra dentro da VM, possibilitando rodar jogos pesados mesmo emulando o Windows. Se não assistiu, está [neste link](https://www.akitaonrails.com/2023/02/01/akitando-137-games-em-maquina-virtual-com-gpu-passthrough-entendendo-qemu-kvm-libvirt).

Em resumo, eu tenho uma máquina parruda, um Ryzen 9 7950X3D com 96GB de RAM. Essa CPU tem uma iGPU, uma GPU integrada fraquinha da AMD. Fraquinha mas mais do que suficiente pra rodar GNOME em dois monitores, com suporte a HDR e em 4K sem engasgar nem nada. Pra uso do dia a dia que é mais abrir navegador, é mais que suficiente.

Essa GPU carrega no Linux com o driver que já vem na kernel, `amdgpu`e é montada como `/dev/dri/card1`. Daí eu coloquei uma 2a GPU, a parruda RTX 4090 com 24GB de VRAM GDDR6X. Não é suficiente pra rodar as LLMs mais parrudas, mas consegue rodar o suficiente. Comprei primariamente pra jogos, mas acabo usando pra IA e render 3D também.

Agora o conceito é simples: no boot, o Linux precisa ignorar essa placa e não carregar os drivers da NVIDIA. Se fizer isso, eu não consigo depois passar ela pra dentro da VM do Windows. Eu editava os videos do meu canal no DaVinci Resolve, que usava plugins que só funcionam em Windows, esse era um dos motivos na época. O Resolve em si funciona no Linux também, mas muitos plugins não. Eu também preferia usar Photoshop, que também só tem no Windows.

Pra isso configuramos o Linux pra carregar um driver de mentira, chamado de `vfio-pci` no lugar do driver da Nvidia (ou a alternativa open source, Nouveau). No outro artigo eu explico em mais detalhes, mas é um enorme saco configurar isso na mão. Não sei se ainda funciona, mas na época também usei um script que automatiza isso, o [GPU-Passthrough-Manager](https://github.com/uwzis/GPU-Passthrough-Manager). Ele vai configurar tudo pra impedir os drivers da NVIDIA de carregar e trocar pra vfio-pci corretamente. Acho que também funciona em notebooks com Optimus, quando você tem uma iGPU mais fraca (pra economizar bateria) e uma GPU discreta separada, mas eu não testo isso faz anos então nem me perguntem, perguntem ao ChatGPT.

Desde 2023 isso funciona super bem. Eu tenho um script chamado `nvidia-locker` que tá no outro artigo. Se eu quiser rodar LLMs ou Blender no meu Linux nativo, rodo esse script e ele tira o vfio-pci e recolocar o driver da NVIDIA em tempo real, sem precisar rebootar. Daí quando termino e eu preciso bootar no Windows, rodo o script de novo e ele descarrega o driver também em tempo real, possibilitando passar via PCI Passthrough pra VM do QEMU. Tudo bonito.

Isso é, até poucos meses atrás, quando o Arch e Manjaro atualizaram pra trocar o antigo legado do **Xorg pra Wayland**. Hoje em dia Wayland é bem mais estável, os portals dele funcionam direitinho e eu consigo usar webcam, microfone, tablet e tudo mais sem nenhum problema. Tudo funciona e, teoricamente, Wayland é pra ser melhor. O novo GNOME 48 também ficou muito bom, com suporte a HDR e tudo mais. Enfim, tá tudo bonitão mesmo, recomendo.

Menos pra combinação de GNOME/Wayland com GPU NVIDIA especificamente nesse cenário de PCI Passthrough pra VM. Em resumo: o boot continua normal, vfio-pci carrega e esconde a GPU da NVIDIA. Meu script `nvidia-locker` também consegue recarregar o driver da NVIDIA a quente. O problema é quando eu tento descarregar o driver pra abrir a VM: o GNOME não deixa.

O Wayland é super agressivo e assim que ele detecta que surgiu uma nova GPU, ele carrega o processo `gnome-shell` nessa GPU. E como tem um processo pendurado, não tem como tirar mais o driver a quente. Só rebootando, e isso é um saco.

Não tem solução fácil. Eu tentei dezenas de coisas diferentes como permissões, regras de UDEV, serviços de SystemD, opções de kernel mas nada impede a porcaria do processo `gnome-shell` ou `gjs` (portal de Flatpak) de se pendurarem na GPU.

Só tem um jeito, meio gambiarra:

* primeiro, configurar o GDM (que carrega o GNOME e é o processo pai) pra não auto-restartar automaticamente se morrer
* segundo, ir pra outro TTY (Ctrl+Alt+F3, por exemplo), matar o GDM de lá e só assim descarregar o driver da NVIDIA.
* terceiro, quando trocar o driver por vfio-pci, agora sim a GPU está desligada e dá pra reiniciar o GDM e logar novamente. Só um saco que os apps gráficos abertos vão morrer, mas é mais rápido do que um reboot inteiro do PC.

## 1 - desligar auto-restart do GDM

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

Essa config impede o GDM de auto-reiniciar. Agora eu consigo matar ela. Sem fazer isso, se eu matar a GDM, ela abre de novo rápido demais e não dá tempo de tirar o driver da NVIDIA antes.

## 2 - Tentando evitar o Wayland de pegar a GPU

Isso o script de GPU-Passthrough-Manager teoricamente já faz, mas pra garantir é bom ter o seguinte:

Primeiro, em `/etc/modprobe.d/blacklist-nvidia.conf`:

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

Segundo, em `/etc/modprobe.d/nvidia.conf`:

```
options nvidia_drm modeset=0
options nvidia NVreg_InitializeSystemMemoryAllocations=0
```

A opção modeset é pra tentar fazer o nvidia_drm não se pendurar na GPU, mas isso não funcionou também. É opcional, não sei se tem problema deixar ou tirar pra modeset=1 de novo. Acho que é mais importante isso se você usa o GPU da Nvidia como GPU primária onde realmente sua interface gráfica vai rodar, especialmente pra suportar o Wayland corretamente.

A outra tentativa é com regras de UDEV em `/etc/udev/rules.d/80-nvidia-composite.rules`:

```
# Unified NVIDIA/AMD GPU management
ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x10de", \
    RUN+="/bin/sh -c 'chmod 000 /dev/dri/%k; echo GNOME_MUTTER_IGNORE_DEVICE=1 >> /etc/environment'"

ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x1002", \
    RUN+="/bin/sh -c 'chmod 660 /dev/dri/%k; chown root:video /dev/dri/%k'"

# New critical addition:
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{enable}="0"
```

A idéia é tentar mudar os atributos chmod pra 000, mas isso também não funcionou.

A última tentativa foi tentar um serviço Systemd em `/etc/systemd/system/nvidia-lock.service`:

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

Mesma idéia de tentar bloquear o Wayland via permissões mais duras, mas também não funcionou. Eu acho que não tem problemas eu deixar isso rodando mas podem pular pra próxima seção

## 3. O que funcionou

Depois de muito testar, agora eu tenho dois scripts (só pra ficar menor macarrônico). Eis o script `nvidia-unlock` que descarrega o driver da NVIDIA e tem que rodar de outro TTY diferente de onde roda o GDM:

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

Esse script mata todo mundo embaixo do GDM, o GNOME Shell, os programas gráficos abertos, tudo, então não deixe seu Libreoffice aberto sem salvar se rodar isso, vai matar tudo. Por isso tem que fazer Ctrl+Alt+F3 e rodar do terminal separado.

E agora, este é meu novo `nvidia-locker` :

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

Pra rodar é a mesma coisa: `nvidia-locker off` vai tirar o bloqueio da vfio-pci e carregar os drivers da Nvidia quando eu quero rodar uma LLM de IA nativo no meu Linux ou renderizar alguma coisa no Blender com Cycles.

Depois que terminar, e eu quiser rodar Windows na VM. Ctrl-Alt-F3, novo login no terminal puro texto, e `nvidia-locker on`. Isso vai matar a GDM, descarregar os drivers da NVIDIA, recarregar o bloqueio do vfio-pci e reiniciar o GDM pra eu logar de novo no modo gráfico. E de lá posso abrir via comando `virsh start` ou usando a interface gráfica Virtual Machine Manager se quiser usar Display Spice, por exemplo.

E é isso, o artigo é mais pra eu não me esquecer do que eu fiz, pra no futuro usar de referência.
