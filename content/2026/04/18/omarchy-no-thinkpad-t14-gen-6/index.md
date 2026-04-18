---
title: "Omarchy no Thinkpad T14 Gen 6: Mini-Review e Setup Completo"
date: '2026-04-18T08:30:00-03:00'
draft: false
translationKey: omarchy-thinkpad-t14-gen-6
tags:
  - omarchy
  - thinkpad
  - archlinux
  - hyprland
  - linux
  - homeserver
---

![Thinkpad T14 Gen 6 fechado ao lado do carregador USB-C](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/closed-lid.jpg)

Comprei um Lenovo Thinkpad T14 Gen 6 e instalei Omarchy em cima. Não é minha máquina principal, nem pretende ser. É companion: um notebook pra abrir em cima da mesa do escritório de impressão 3D, dar um SSH no desktop, chamar Claude Code, acessar arquivos no NAS, debugar rede pelo ethernet sem ficar procurando adaptador USB e cabo longo. Esse artigo cobre a escolha do hardware, o setup de Omarchy em cima, as customizações específicas pra notebook e pra esse Thinkpad em particular, e as decisões de arquitetura que podem não ser óbvias.

## Mini-review do Thinkpad T14 Gen 6

![Thinkpad T14 Gen 6 aberto, tela desligada, mostrando o teclado e o selo do Intel Core Ultra 5](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/open-lid-turned-off.jpg)

Vamos tirar do caminho: esse não é o notebook dos sonhos. Se eu fosse escolher por estética, pegaria um Asus Zenbook S 14 com tela OLED. Se fosse por portabilidade, o Thinkpad T14s com casca de alumínio, que é mais leve e muito mais bonito. O T14 regular tem tela IPS 1920x1200 de 14", 400 nits, 60Hz, sem HDR. Dá pro gasto, mas está longe da tela do Zenbook. A casca é de plástico com um acabamento emborrachado, o que deixa ele resistente a arranhão, mas não é premium. Revisões da [NotebookCheck](https://www.notebookcheck.net/AMD-Ryzen-AI-meets-classic-ThinkPad-Lenovo-ThinkPad-T14-Gen-6-AMD-laptop-review.1222690.0.html) e da [XDA Developers](https://www.xda-developers.com/lenovo-thinkpad-t14-gen-6-review/) batem na mesma tecla: bom custo, boa conectividade, desempenho adequado pra escritório, mas a tela é datada.

O que compensa:

- Seleção de portas. HDMI full-size. Ethernet gigabit. USB-A, USB-C Thunderbolt 4, carrega pelo USB-C (não é carregador proprietário). Pra um companion de debug, isso é exatamente o que eu queria. O Zenbook S 14, por ser mais fino, corta portas.
- Sensor de digital funcional no Linux (Goodix MOC, funciona com libfprint em kernel 6.11+). Isso eu uso, detalho mais à frente.
- Teclado Thinkpad. Curso de tecla de 1.5mm, trackpoint, layout clássico. Não é o melhor teclado do mundo em 2026, mas é confiável e durável.
- Carcaça rugged. Vai cair, vai arranhar, vai viajar na mala. Se eu colocasse um Zenbook OLED ou um Macbook Pro em cima da mesa do escritório de impressão 3D, ao lado da impressora, com poeira de PLA voando, eu ficaria nervoso. O Thinkpad pode levar porrada.

Se eu quisesse máquina de jogo, pegaria um Asus Zephyrus G14, meu favorito de notebook gamer. Se eu quisesse máquina de trabalho criativo, pegaria o [Asus Zenbook Duo (UX8406)](https://www.asus.com/laptops/for-home/zenbook/zenbook-duo-ux8406/) com duas telas OLED verticais, ótimo pra edição de vídeo e modelagem 3D. Tenho grana pra qualquer Macbook Pro ou Mac Studio, e escolhi não ir por esse caminho. Explico melhor na próxima seção.

## Meu caso de uso

![Thinkpad aberto numa bancada do escritório de impressão 3D, com fastfetch mostrando Omarchy no terminal](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/open-lid-fastfetch.jpg)

Meu PC principal é um desktop com Ryzen 9 7950X3D, 96 GB de RAM, RTX 5090 de 32 GB. É onde eu trabalho, experimento com modelos locais, rodo containers, edito o blog. Pra jogo, tenho um mini-PC separado com RTX 4090. Esses dois atendem 100% do que eu preciso fazer em casa.

O notebook existe pra cobrir o 1% restante: sentar no sofá, levar no escritório de impressão 3D, levar na cozinha, levar em viagem curta. Não é pra substituir o desktop. É pra ter acesso remoto ao desktop quando eu estiver longe dele.

![Hyprland com dois terminais lado a lado: à esquerda SSH pro desktop principal (96 GB, RTX 5090), à direita o próprio Thinkpad. Mesma UI, duas máquinas.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/ssh-to-remote-desktop-on-left.png)

Na prática fica assim: abro o notebook, dou split no Hyprland, janela da esquerda dá SSH no desktop principal, janela da direita é o próprio notebook. Mesmo Omarchy nos dois, mesmos atalhos, mesmo bash. O notebook vira extensão do desktop, não um ambiente paralelo que eu tenho que reconfigurar na cabeça toda vez que alterno.

Então por que não um Mac? Eu não tenho uso pro macOS. Como dev, eu vivo melhor em Linux nativo. Toda ferramenta que eu preciso tem versão Linux de primeira, e no macOS eu teria versão de segunda via Homebrew. Não faço iOS, então não preciso do XCode. Pra mobile uso Flutter ou Hotwire Native, que rodam em qualquer OS. iTerm2 e Ghostty no Mac são bons, mas Alacritty, Kitty e o próprio Ghostty no Linux me atendem igual. Todo software bom chega primeiro no Linux, daí é portado pros outros. Arch com AUR cobre tudo num único `yay`.

Pra trabalho criativo, faz anos que não faço profissionalmente. DaVinci Resolve Studio no Linux é superior ao Final Cut Pro. Krita ou Affinity Photo substituem Photoshop na maioria dos casos. Clip Studio Paint no Android é superior ao Procreate. Eu simplesmente não tenho um workflow que depende da Apple, e a App Store me irrita.

Outro argumento que sempre aparece: "mas um Mac Mini M4 ou Mac Studio com 128GB de memória unificada roda modelos grandes localmente, é o substituto do ChatGPT". Já testei essa tese e escrevi um [benchmark detalhado](/2026/04/05/testando-llms-open-source-e-comerciais-quem-consegue-bater-o-claude-opus/). A conclusão: hardware local caro pra rodar LLM é hobby de fim de semana, não é ferramenta de produção. Os modelos open source que cabem não entregam a qualidade que o Claude Opus entrega. Eu tenho um [home server com AMD Strix Halo e 96 GB de RAM unificada](/2026/03/31/migrando-meu-home-server-com-claude-code/), rodei modelos por dezenas de horas, e no meu fluxo real de programação eles servem pra tarefas simples. Pras tarefas complexas, Claude Opus. Antes de gastar os $4000 num Mac Studio com a justificativa de rodar modelos locais, faça o teste de verdade. Você provavelmente vai voltar a pagar Opus depois.

## Por que Omarchy

Eu uso Omarchy no desktop há meses e documentei o caminho numa [série de artigos](/tags/omarchy/). O [Omarchy 2.0](/2025/08/29/new-omarchy-2-0-install/) tem instalador próprio com LUKS, Btrfs, Limine, snapper e SDDM já configurados. Escrevi sobre [usar a ISO oficial](/2025/09/12/omarchy-2-0-instale-com-a-iso-do-omarchy/), sobre as [customizações de ZSH](/2025/09/07/omarchy-2-0-zsh-configs/) com atuin, starship, secrets bem organizados, sobre [Mise pra múltiplas linguagens](/2025/09/07/omarchy-2-0-mise-pra-organizar-ambientes-de-desenvolvimento/), sobre [LazyVim e LazyExtras](/2025/09/07/omarchy-2-0-lazyvim-lazyextras/), sobre [SSH e Yubikeys](/2025/09/09/omarchy-2-0-entendendo-ssh-e-yubikeys/), sobre [TUIs modernas](/2025/09/09/omarchy-2-0-tuis/). Também tem o [Omarchy 3 com dual GPU AMD + NVIDIA](/2026/01/21/omarchy-3-setup-de-dual-gpus-com-amd-e-nvidia/) e o [Crush](/2026/01/09/omarchy-3-um-dos-melhores-agentes-pra-programacao-crush/) como agente de coding.

Pra quem não conhece: Omarchy é Arch Linux puro com uma camada de cosmética em cima do Hyprland/Wayland. Pré-configurado com defaults sãos. Eu podia montar tudo isso do zero, já fiz isso várias vezes na vida, mas por que refazer trabalho que alguém já fez bem feito? Instalo Omarchy, faço os tweaks que são meus em cima, e tenho Arch customizado numa fração do tempo.

Um ponto que eu levanto toda vez que recomendo Omarchy: a documentação é excelente. Tem um [manual oficial](https://manuals.omamix.org/2/the-omarchy-manual) que cobre desde instalação até customização de tema, keybindings, Hyprland, Waybar, tudo. Se você vem de Ubuntu ou Fedora e tem receio de Arch, esse manual resolve o grosso das dúvidas. Pra quem nunca tocou em Hyprland, abre ele e vai tangenciando. Não é um README jogado no GitHub, é manual de verdade, com capítulos e índice.

A história desse artigo começa num fio anterior. Eu migrei meu home server recentemente, trocando um servidor Ubuntu antigo por um [Minisforum MS-S1 com openSUSE MicroOS configurado com Claude Code](/2026/03/31/migrando-meu-home-server-com-claude-code/). Esse foi o primeiro experimento sério de deixar o Claude Code guiar uma migração de infra inteira, com containers, NFS, serviços, networking. Deu certo. E deixou no ar a ideia: por que não usar a mesma abordagem pra configurar um notebook novo?

Foi o que fiz. Peguei o Thinkpad, baixei a ISO do Omarchy mais recente, gravei num pendrive, instalei por cima do Windows. Do zero ao desktop funcional, menos de uma hora. Dali pra frente, tudo é tweaking, que eu fui documentando conforme fazia.

![Claude Code rodando no terminal do Thinkpad, pronto pra começar a configurar o notebook](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/open-lid-claude-terminal.jpg)

Vou detalhar as duas camadas de customização: o que precisa pra um notebook qualquer, e o que é específico desse Thinkpad.

## Configs específicos de notebook

Um notebook tem problemas que um desktop não tem: bateria, suspensão, tampa, brilho, trackpad. Essas são as partes que Omarchy default não cobre do jeito que eu quero.

### Power management com TLP

O default do Omarchy vem com `power-profiles-daemon`. Troquei por TLP, que dá controle granular de CPU scaling, thresholds de bateria e perfil dinâmico baseado em AC vs bateria.

```bash
sudo pacman -S tlp tlp-rdw
sudo systemctl mask power-profiles-daemon.service
sudo systemctl enable --now tlp.service
```

O `mask` é necessário porque o upower traz o `power-profiles-daemon` de volta se você só der `disable`.

Thresholds de carga: 60% pra começar, 85% pra parar. O notebook fica a maior parte do tempo plugado na mesa do escritório, e manter a bateria em 100% 24/7 detona a capacidade ao longo do tempo. Com 60/85, a bateria passa a maior parte do tempo na faixa saudável de lítio e ainda sobra capacidade útil decente.

Perfis: `balanced` com `balance_power` na bateria, `performance` no AC. O `low-power` do TLP era agressivo demais no Core Ultra 5 235U, a resposta de janela e terminal ficava perceptível. Balanced dá a melhor relação consumo/responsividade pra uso normal.

Tem uma pegadinha: `tlp auto` depois de `tlp ac` nem sempre reaplica o perfil de bateria. Criei um pequeno script ligado ao `Super+Ctrl+P` que lê o estado atual e chama `tlp bat` ou `tlp ac` explicitamente:

```bash
#!/bin/bash
set -euo pipefail

profile=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo unknown)
on_ac=$(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -1 || echo 0)

if [[ "$profile" == "performance" ]]; then
  if [[ "$on_ac" == "1" ]]; then
    sudo /usr/bin/tlp auto >/dev/null
    label="Plugged in — back to AC auto"
  else
    sudo /usr/bin/tlp bat >/dev/null
    label="On battery — normal profile"
  fi
  notify-send -t 2000 "Performance mode: off" "$label" 2>/dev/null || true
else
  sudo /usr/bin/tlp ac >/dev/null
  notify-send -t 2000 "Performance mode: on" "Forcing AC profile" 2>/dev/null || true
fi
```

No waybar, um módulo custom `custom/perf` mostra o estado atual (󰓅 PERF, 󰌪 ECO, ou vazio pra balanced) e aceita clique pra alternar. O script de output é bem curto:

```bash
#!/bin/bash
p=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null)
case "$p" in
  performance) printf '󰓅 PERF' ;;
  low-power)   printf '󰌪 ECO'  ;;
  balanced|"") printf ''       ;;
  *)           printf '%s' "$p" ;;
esac
```

### Suspend, hibernate, e tampa

Isso aqui é o que mudou em relação aos notebooks que eu usava em 2015. O T14 Gen 6 fecha a tampa, suspende, e acorda quando você abre de novo. Sem bug, sem delay estranho, sem precisar dar login de novo no meio da sessão gráfica. O hyprlock pega depois do suspend, aceita digital ou senha, e volta pro desktop em segundos. Isso é o comportamento que a gente tem na Apple há anos e que no Linux era uma aventura. Em 2026, em hardware moderno com kernel 6.11+, simplesmente funciona.

Mem sleep mode é s2idle (sem deep sleep). Hibernação habilitada via swapfile Btrfs de ~30 GB e `resume=/dev/mapper/root resume_offset=...` no kernel cmdline do Limine. Raramente uso, mas está lá.

O hypridle tem timeouts agressivos pra notebook:

- 2.5 min → screensaver
- 5 min → lock
- 5.5 min → DPMS off + keyboard backlight off

Depois de trancado, passa mais 5 min e a tela apaga de vez. No unlock, restaura brilho de tela e de teclado pro nível anterior. Essas timings são muito mais curtas que as do desktop (20-40 min lá). A diferença de bateria ao longo do dia é mensurável.

### Brilho e backlight de teclado

`brightnessctl` controla os dois. Fn+Space alterna o backlight do teclado em três níveis. Hypridle salva o nível atual antes de apagar e restaura no retorno. Comando que uso no script:

```bash
brightnessctl -sd '*::kbd_backlight' set 0    # salva e desliga
brightnessctl -rd '*::kbd_backlight'          # restaura
```

### Touchpad

No `hypr/input.conf`:

```
touchpad {
    natural_scroll = true
    clickfinger_behavior = true
    disable_while_typing = true
    scroll_factor = 0.4
}
gesture = 3, horizontal, workspace
```

`clickfinger_behavior` troca o clique de 2 dedos como botão direito (mais confortável que acertar a zona inferior direita). `disable_while_typing` é palm rejection básico. Três dedos horizontais alternam workspaces, o gesto mais útil no Hyprland.

## Configs específicos do Thinkpad

Aqui entra o que é particular desse modelo. Algumas coisas o Linux moderno já cobre sozinho, outras exigem configuração específica.

### Sensor de digital

Goodix MOC `27c6:6594`, funciona com libfprint 1.94.9+ em kernel 6.11+. Pacote é `fprintd`.

```bash
sudo pacman -S fprintd
fprintd-enroll                        # dedo indicador direito por default
fprintd-enroll -f left-index-finger   # outro dedo
```

Pro `sudo` aceitar digital, adiciono `auth sufficient pam_fprintd.so` acima da linha do `pam_unix.so` em `/etc/pam.d/sudo`. Com `sufficient`, se a digital passar, autentica direto. Se falhar ou se eu digitar ESC, cai pro prompt de senha. Isso vale a pena de verdade: dezenas de vezes por dia, `sudo pacman -Syu` ou `sudo systemctl restart algo`, e é só encostar o dedo.

No hyprlock, uso a configuração nativa do próprio hyprlock, não o PAM:

```
auth {
    fingerprint {
        enabled = true
        ready_message = Scan fingerprint or type password
        present_message = Scanning...
        retry_delay = 250
    }
}
```

A razão é que o caminho PAM dá prompt duplo. Configurado nativo, o hyprlock aceita digital ou senha, o que vier primeiro desbloqueia.

No SDDM (login inicial), deixei senha apenas. O motivo: a senha de login destrava o keyring do GNOME, e a digital não consegue fornecer plaintext pra isso. Depois que o keyring está destrancado, o hyprlock pode usar digital sem problema.

![Prompt do sudo pedindo leitura de digital](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/sudo-asks-for-fingerprinting.png)

Na prática, o sudo fica assim. Encosta o dedo, autentica, segue.

### Teclado brasileiro do Thinkpad

O teclado brasileiro do Thinkpad tem uma peculiaridade chata. A tecla `/?` fica na posição que seria o Ctrl direito (keycode 97), não na posição AB11 tradicional do ABNT2 (keycode 89). Se você usar o layout padrão `br(abnt2)`, essa tecla fica inacessível. Literalmente não imprime nada.

A solução é o variant `br(thinkpad)` que existe em `/usr/share/X11/xkb/symbols/br`:

```
xkb_symbols "thinkpad" {
    include "br(abnt2)"
    name[Group1]="Portuguese (Brazil, IBM/Lenovo ThinkPad)";
    key <RCTL> { [ slash, question, degree, questiondown ] };
};
```

No `hypr/input.conf`:

```
kb_layout = br
kb_variant = thinkpad
kb_model = thinkpad60
```

E system-wide pra TTY/X11:

```bash
sudo localectl set-keymap br-abnt2
sudo localectl set-x11-keymap br thinkpad thinkpad60
```

Escrevi um pequeno Python que lê scancodes brutos de `/dev/input/event*` pra diagnosticar essas esquisitices. Útil quando uma tecla decide não funcionar e você precisa descobrir se é hardware, kernel, ou xkb.

### Áudio SOF

Codec Realtek ALC3306/ALC287 via Sound Open Firmware. Sem o `sof-firmware`, o módulo de kernel carrega mas o DSP nunca boota e o PipeWire cai silenciosamente pra `auto_null`. Resultado: você acha que o alto-falante está no mudo, mas na verdade o PipeWire não tem device nenhum.

```bash
sudo pacman -S --needed sof-firmware alsa-ucm-conf pipewire pipewire-pulse wireplumber
```

Se precisar forçar SOF em vez do HDA legacy:

```bash
echo "options snd-intel-dspcfg dsp_driver=3" | sudo tee /etc/modprobe.d/alsa.conf
```

Reload sem reboot:

```bash
sudo modprobe -r snd_sof_pci_intel_mtl
sudo modprobe snd_sof_pci_intel_mtl
systemctl --user restart wireplumber pipewire pipewire-pulse
```

### Firmware updates pelo fwupd

![Firmware update da Lenovo (ME Corp) rodando no boot](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/bios-update.jpg)

`fwupdmgr update` funciona, mas com Limine tem uma pegadinha: o fwupd tenta escrever em `/boot/EFI/systemd/` ou `/boot/EFI/arch/`, que não existem. O workaround:

```bash
sudo mkdir -p /boot/EFI/arch
sudo fwupdmgr update -y --no-reboot-check
fwupdmgr get-history  # deve mostrar "Success"
```

### HiDPI / fractional scaling

Painel 14" em 1920x1200 numa resolução do Hyprland livre. O auto 1.5x do Omarchy ficava chunky demais. Fixei em 1.333x:

```
env = GDK_SCALE,1
monitor=,preferred,auto,1.3333,vrr,2
```

Efetivo 1440x900. GTK com `GDK_SCALE=1` renderiza 1:1 com o Hyprland (não magnifica duplo). VRR mode 2 só em fullscreen, porque painéis LCD tendem a cintilar em conteúdo estático com VRR ativa.

Flags do Brave e Chromium pra renderizar bem nessa escala:

```
--ozone-platform=wayland
--enable-features=WaylandFractionalScaleV1,UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder
--enable-gpu-rasterization
```

O VAAPI faz diferença real na bateria em YouTube.

## Tunando Omarchy pra ser meu

Omarchy vem com defaults bons. O que eu ajusto é no topo deles, sem tocar em `~/.local/share/omarchy/` (que é clobbered pelo `omarchy-update`). Toda customização fica em `~/.config/`.

### Infra: Btrfs, snapshots, Snapper

Omarchy já vem com Btrfs e subvolumes separados:

| Subvolume | Mount | Entra nos snapshots? |
|---|---|---|
| `@` | `/` | sim |
| `@home` | `/home` | não |
| `@log` | `/var/log` | não |
| `@pkg` | `/var/cache/pacman/pkg` | não |

`@home` separado significa que `~/.cache`, `~/.config/BraveSoftware`, etc. não incham snapshots do root. Snapshot é de sistema, não de perfil.

Swap: zram de 4 GB com prioridade 100 (hit primeiro), mais swapfile de 30 GB com prioridade 0 (habilita hibernação, dimensionado pra RAM).

O stack de snapshot: Snapper tira snapshot antes e depois de cada `pacman -Syu` via snap-pac. `limine-snapper-sync` escreve esses snapshots no menu do Limine, então dá pra bootar num snapshot anterior pra reverter. Se algo quebra depois de update, você segura uma tecla no boot, escolhe o snapshot pré-update, boota read-only pra verificar, e se estiver bom, faz `snapper rollback`.

![Subvolumes Btrfs separados pra que snapshots do root não inchem com cache de usuário](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/btrfs-snapshots-config.png)

Omarchy deixa o `snapper-cleanup.timer` e o `snapper-boot.timer` desabilitados por default. Habilitei os dois e configurei retenção pra caber num SSD de 1 TB sem explodir:

```
TIMELINE_LIMIT_HOURLY=10
TIMELINE_LIMIT_DAILY=0
TIMELINE_LIMIT_WEEKLY=1
TIMELINE_LIMIT_MONTHLY=1
NUMBER_LIMIT=50
```

Um detalhe que custa debug pra quem esquece: Docker e Ollama escrevem gigabytes em `/var/lib/docker` e `/var/lib/ollama`. Se isso cai dentro de `@`, os snapshots catastrofizam. Cada imagem Docker ou modelo Ollama baixado triplica em tamanho. Criei subvolumes aninhados pros dois, com `chattr +C` pra desligar CoW:

```bash
sudo btrfs subvolume create /var/lib/docker
sudo chattr +C /var/lib/docker
sudo btrfs subvolume create /var/lib/ollama
```

Isso tem que ser feito ANTES de o Docker ou Ollama escrever dados. Se já tem dados lá, precisa migrar.

### NFS pro NAS Synology

Meu Synology expõe três volumes. No desktop, monto normal. No notebook, tem que ser mais defensivo. O notebook anda, esquece a rede, conecta em WiFi público. Fstab do notebook:

```
nfs4  _netdev,noauto,nofail,x-systemd.automount,x-systemd.idle-timeout=10min,x-systemd.mount-timeout=15s,noatime,nodiratime,nconnect=4,actimeo=10,soft,timeo=30,retrans=2
```

Diferença crítica em relação ao desktop: `soft` com timeouts curtos (não fica pendurado pra sempre), `x-systemd.idle-timeout=10min` (auto-unmount quando ocioso), sem `network-online.target` no require (não atrasa boot). Resultado prático: `cd /mnt/gigachad` em casa monta lazy, fora de casa falha rápido sem trancar shell.

Outro detalhe importante: meu user no notebook tem UID 1026, que bate com a permissão do share no Synology. O Linux default cria user em 1000, o Synology impõe identidade via UID no fio. Se os UIDs não batem, você não consegue ler os arquivos, ou ainda pior, escreve como nobody. Rodei de TTY (com usuário deslogado) os `usermod`/`groupmod` pra remapear o user pra 1026/1026 e fiz `chown -R` em `/home`.

### Hardening de WiFi público

Notebook vai sair de casa. Num aeroporto ou café, eu não quero anunciar hostname, não quero MAC rastreável, não quero serviço escutando porta aberta.

`/etc/NetworkManager/conf.d/00-macrandomize.conf`:

```
[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=stable
ethernet.cloned-mac-address=stable
connection.stable-id=${CONNECTION}/${BOOT}

ipv6.ip6-privacy=2
ipv6.addr-gen-mode=stable-privacy
```

MAC aleatório por scan (anti-fingerprinting passivo). MAC clonado estável por SSID (o portal cativo não te re-pergunta login toda vez) mas diferente entre redes. IPv6 com endereços temporários e interface ID derivado de segredo estável, não do MAC (sem vazar EUI-64).

`/etc/systemd/resolved.conf.d/hardening.conf`:

```
[Resolve]
LLMNR=no
MulticastDNS=no
```

Mata broadcast de hostname em LLMNR e mDNS. Também desabilito avahi:

```bash
sudo systemctl disable --now avahi-daemon.service avahi-daemon.socket
```

UFW firewall:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
```

SSH server já é off por default no Omarchy. Nada escutando. Mesmo que o firewall vaze, não tem superfície.

Tudo isso entra num único ritual de setup inicial.

### Bash em vez de ZSH

No desktop uso ZSH. No notebook fui de Bash pra alinhar com o default do Omarchy, sem dupla de camadas modulares pra manter. `~/.bashrc` é um symlink pra `~/.config/bash/bashrc`, que faz source dos defaults do Omarchy primeiro e depois empilha as minhas customizações:

```bash
source ~/.local/share/omarchy/default/bash/rc
source ~/.config/bash/envs.sh
source ~/.config/bash/aliases.sh
source ~/.config/bash/mounts.sh
source ~/.config/bash/init.sh
source ~/.config/bash/secrets    # gitignored, chmod 600
```

`envs.sh` tem o que é meu: OpenRouter base URL, Ollama apontando pro GPU box da rede local (192.168.0.14), AWS region, analytics do Hugo, configs de zoxide e SSH agent. `aliases.sh` tem os atalhos de TLP, um alias pra `shell-gpt` via Docker, e functions pra hardenar o PATH quando rodo `makepkg` ou `yay` (prevenir injeção de binário via user config malicioso).

`init.sh` faz o trabalho de integração. Atuin com bind manual do Ctrl-R (pra deixar a seta pra cima com o history-search padrão do bash, que eu uso mais). Keychain carregando `~/.ssh/id_ed25519` uma vez por boot e reusando nos shells seguintes (sem ter que re-autenticar SSH toda hora). Blesh se estiver instalado (autosuggestion estilo ZSH pra Bash). E uma função que manda o PROMPT_COMMAND ajustar o título da janela com o pwd atual e o comando em execução:

```bash
__title_idle() { printf '\033]2;%s\007' "${PWD/#$HOME/~}"; }
__title_busy() {
  local cmd="${BASH_COMMAND}"
  [[ "$cmd" == "__title_"* || "$cmd" == *"PROMPT_COMMAND"* ]] && return
  printf '\033]2;%s — %s\007' "${PWD/#$HOME/~}" "$cmd"
}
if [[ -n "${PROMPT_COMMAND-}" ]]; then
  PROMPT_COMMAND="__title_idle; ${PROMPT_COMMAND}"
else
  PROMPT_COMMAND="__title_idle"
fi
trap '__title_busy' DEBUG
```

No idle, título mostra só o pwd. Com um comando rodando, `trap DEBUG` pega o `BASH_COMMAND` em execução e atualiza o título. Integra com o `hyprland/window` do waybar pra mostrar tudo lá.

Pro toolbelt Rust moderno, a lista:

```bash
sudo pacman -S --needed \
  eza bat fd ripgrep sd git-delta dust procs bottom duf tokei hyperfine \
  zoxide atuin tldr starship
```

`eza` substitui `ls`. `bat` substitui `cat` com syntax highlight. `fd` substitui `find`. `ripgrep` substitui `grep`. `sd` substitui `sed`. `delta` pluga no git pra diff side-by-side colorido. `dust` pro `du` visual. `procs` pro `ps`. `btm` (bottom) pro `top`. `duf` pro `df`. `tokei` conta linhas de código. `hyperfine` pra benchmark de comando. `zoxide` é `cd` com memória (muito útil). `atuin` é history do shell com sync criptografado (aponto pro meu home server via `sync_address = "http://192.168.0.90:8888"`). `starship` é o prompt. `tldr` é man page em 10 linhas.

O `atuin key` tem que ser backupeado offline. Se você perde, perde o histórico criptografado. Salvei no 1Password.

O git passa diff pelo delta:

```
[core]        pager = delta
[interactive] diffFilter = delta --color-only
[delta]       navigate side-by-side line-numbers hyperlinks, light=false
[merge]       conflictstyle = zdiff3
```

### Hyprland e Waybar

Customizações visuais e de UX que fiz em cima do default.

No `hypr/looknfeel.conf`, gaps menores (2/5 vs 5/10 do default), animação de slide entre workspaces, VFR ligado (reduz consumo quando a tela está estática), `allow_session_lock_restore` (se o hyprlock crasha, volta pra tela de lock em vez de jogar pro desktop).

No `hypr/bindings.conf`:

| Binding | Ação |
|---|---|
| `Super+B` | Brave |
| `Super+L` | Lock screen (default era layout toggle) |
| `Super+Ctrl+L` | Layout toggle (movi pra cá) |
| `Super+Ctrl+P` | Toggle TLP perf mode |

No Waybar, três módulos custom que recomendo:

**Título de janela**: o módulo `hyprland/window` mostra o que tá focado. No bash, o PROMPT_COMMAND atualiza o título pra algo como "~/Projects/blog — hugo server". Então no waybar aparece o diretório e o comando em execução, sem eu precisar olhar pro terminal.

![Waybar mostrando workspaces à esquerda e o título da janela focada com o pwd e comando em execução](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/hypr---window-title-on-waybar.png)

![Outro exemplo do título da janela no waybar, dessa vez mostrando "Claude Code"](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/hypr---another-window-title-on-waybar.png)

```jsonc
"hyprland/window": {
    "format": "{title}",
    "max-length": 50,
    "rewrite": { "(.{47}).+": "$1…" }
}
```

**Perf mode**: o `custom/perf` executa um script que lê o estado do TLP e mostra um ícone:

```jsonc
"custom/perf": {
    "exec": "~/.config/scripts/perf-waybar.sh",
    "interval": 3,
    "format": "{}",
    "on-click": "~/.config/scripts/perf-toggle.sh"
}
```

Vazio em balanced, 󰓅 PERF em performance, 󰌪 ECO em low-power. Clique alterna. Útil pra ver rapidamente em que modo a máquina está.

**Claudebar**: integrei o [claudebar](https://github.com/alfredopiquet/claudebar) num módulo custom que mostra a % de uso da sessão do Claude Code e o gasto extra inline no waybar. Sem ter que abrir outra janela.

![Claudebar mostrando 9%, 1h16m restantes e $1120.74 de uso extra, seguido do indicador PERF e o tray](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/hypr---power-profile-and-claudebar-next-to-traybar.png)

O clock:

```jsonc
"clock": {
    "format": "{:L%A %d %B - %H:%M}",
    "format-alt": "{:L%A W%V %Y - %H:%M}"
}
```

Exibe "quinta 17 abril - 14:32" por padrão, clique alterna pra "quinta W16 2026 - 14:32" com número da semana do ano, útil pra planejar artigos e tarefas.

![Clock do waybar no centro com data e hora em português](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/18/thinkpad/hypr---better-date-time-on-waybar-center.png)

### Atuin self-hosted

Atuin roda no meu home server em 192.168.0.90:8888. Criei uma conta separada pro notebook (`akitaonrails-thinkpad`), não misturo histórico com desktop de propósito. `atuin sync` roda a cada 5 minutos e todo histórico é criptografado antes de ir pro server. O server não vê os comandos, só vê bytes criptografados.

## Conclusão: escolhendo notebook pra Linux

Se tem uma coisa que eu aprendi nessa jornada: escolher notebook pra rodar Linux confortavelmente não é trivial. Precisa checar a [ArchWiki](https://wiki.archlinux.org/title/Laptop) pelo modelo específico antes de comprar. A do [T14s Gen 6 AMD](https://wiki.archlinux.org/title/Lenovo_ThinkPad_T14s_(AMD)_Gen_6), por exemplo, cataloga cada peculiaridade de hardware e como contornar. Sem essa referência, você descobre os problemas instalando.

Regra que sigo: nunca comprar modelo recém-lançado. Deixar passar uns 6 a 12 meses depois do lançamento. Isso dá tempo pra comunidade iron out os bugs, pros drivers entrarem no mainline, pra ArchWiki ter uma página decente, pra libfprint incluir o sensor de digital, pro kernel cobrir o WiFi e a câmera IR. Comprar de primeira é assumir o papel de tester beta.

Marcas com trilha Linux decente: Lenovo (especialmente Thinkpad, eles oferecem Ubuntu e Fedora pré-instalados), Dell (a linha XPS e Latitude), Asus (Zenbook e ROG têm suporte razoável), Framework (fábrica direto pra Linux). Mac qualquer geração recente é cortado do Linux mainline ou via Asahi com caveats.

O Thinkpad T14 Gen 6 não é o notebook mais bonito que eu podia ter comprado. Mas é rugged, tem as portas certas, o sensor de digital funciona, e a carcaça plástica aceita cair, arranhar, viajar na mala sem eu ficar nervoso. Pra servir de companion de debug remoto, é o que eu precisava. Se esse é o seu perfil de uso também, recomendo. Se você quer OLED e metal, vai de Zenbook ou de T14s. Cada premium tem seu compromisso, nenhum notebook Linux em 2026 é perfeito.

Tudo que descrevi aqui ficou versionado num repo privado meu. Se eu precisar reinstalar amanhã, rodo meia dúzia de passos em ordem e volto ao mesmo lugar. Esse é o ponto todo de manter configuração em Git: notebook é commodity, config é minha.
