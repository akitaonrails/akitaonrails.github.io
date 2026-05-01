---
title: "NW-Omarchy: Trazendo Omarchy pro X11 com XLibre"
date: '2026-05-01T18:00:00-03:00'
draft: false
translationKey: nw-omarchy-xlibre-inaugural
tags:
  - omarchy
  - xlibre
  - archlinux
  - bspwm
  - linux
  - x11
---

![Launcher do NW-Omarchy: super+space abre rofi com todos os .desktop do sistema, ícones renderizados pelo tema Papirus](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/01/nw-omarchy/launcher-drun.png)

Esse post inaugura um projeto experimental que tenho mexido nas últimas semanas: [NW-Omarchy](https://github.com/akitaonrails/NW-Omarchy). A ideia é simples de explicar e razoavelmente teimosa de defender: pegar o look-and-feel opinativo e bonito do [Omarchy](https://omarchy.org/) (que é Hyprland, ou seja, Wayland) e levar tudo isso pro mundo X11, como uma sessão paralela que você escolhe no SDDM. Sua sessão Hyprland continua intocada. Quando quiser experimentar X11, escolhe `nw-bspwm` no login e cai num ambiente que parece o mesmo Omarchy só que com outras peças por baixo.

A pergunta óbvia é "por quê". A Red Hat já comunicou em 2025 que o `xorg-server` upstream sai do RHEL 10, e o discurso oficial do mundo Linux corporativo virou "use Wayland e pronto". Como sempre, em open source a gente não precisa concordar. Existe XLibre, um fork do xorg-server retomando manutenção ativa, e existe muita gente com hardware velho, driver legado ou software legado pra qual Wayland ainda não é caminho viável. NW-Omarchy é pra esse cenário: dar uma sobrevida elegante pra esse equipamento e, de quebra, deixar ele bonito.

## O que é XLibre e por que ele importa

XLibre é um fork do xorg-server iniciado em 2025, depois que ficou claro que o upstream não tinha mais energia pra evoluir. O X.Org em si só recebia patches críticos de segurança, e o principal financiador histórico do desenvolvimento (Red Hat) [comunicou que vai parar](https://www.redhat.com/en/blog/rhel-10-plans-wayland-and-xorg-server) com o RHEL 10. XLibre pegou a base e voltou a fazer cleanup, security fixes, modernização e bumps de driver-ABI. A primeira release pública foi a [XLibre 25.0](https://www.phoronix.com/news/XLibre-25.0-Released), e o projeto vive em [github.com/X11Libre/xserver](https://github.com/X11Libre/xserver).

A pegada técnica do XLibre é ser drop-in replacement pro xorg-server. Mesmo protocolo X11, mesma API client (libxcb/libx11), mesmo grafo de dependência no pacman. Seu xterm, seu Firefox, seu Steam, seu emulador favorito de fliperama dos anos 90, nada disso sabe que o servidor X mudou. Distros que já adotam XLibre como default ou tier-one:

- **Artix Linux** ([2026.04+](https://linuxiac.com/artix-linux-2026-04-released-with-xlibre-as-default-x-serve/)) usa como X server padrão.
- **Fedora** tem [Change proposal aberta](https://fedoraproject.org/wiki/Changes) pra migrar.
- **Arch Linux** tem repo binário oficial em `x11libre.net/repo/arch_based/`. É exatamente esse que NW-Omarchy usa.

Comparando o que tá vivo:

| | xorg-server | XLibre |
|---|---|---|
| Última release não-security | 21.1 (2022) | 25.0 (2025) |
| Trabalho ativo no codebase | nenhum | sim |
| Driver ABI | congelado | atualizado (`X-ABI-VIDEODRV_VERSION=28.0` no 25.0) |
| Futuro declarado | "use Wayland" | continuar evolução do X server |
| Convive com `xorg-xwayland` | sim | sim |

Se o seu argumento pra ficar no X11 é qualquer um dos clássicos (driver proprietário antigo de Nvidia, GPU Intel vintage, laptop Optimus com muxing esquisito, dependência de `xdotool`/`wmctrl`/`xprop`/`xinput` pra acessibilidade ou ferramentas de remap, `ssh -X` pra rodar app remoto, clipboard sem prompt de permissão, screen reader que precisa ler input de qualquer janela), o XLibre é o caminho que mantém esse stack em manutenção ativa.

## Por que esse projeto existe

Eu rodo Omarchy no meu Thinkpad T14 Gen 6 ([escrevi sobre isso aqui](/2026/04/18/omarchy-no-thinkpad-t14-gen-6/)) e gosto bastante. O DHH fez um trabalho de curadoria muito bem pensado: tema único e consistente em tudo (terminal, launcher, top bar, lockscreen), atalhos coerentes, distinções visuais que não cansam o olho. É opinativo do jeito certo, te tira da fadiga de configurar tudo do zero.

O problema é que Omarchy é Hyprland, Hyprland é Wayland-only, e Wayland tem cenários onde ainda não é a ferramenta certa. Máquinas mais velhas com driver Nvidia legado, ambientes que dependem de software com integração X11 profunda, situações onde você quer `ssh -X` e não quer aprender `waypipe`, ou simplesmente máquinas que você quer manter funcionando sem trocar metade do stack. Pra esses casos, eu queria a estética e o workflow do Omarchy, mas em cima do X11. Não existia. Então fiz.

O nome NW-Omarchy é abreviação de "Not Wayland Omarchy". É deliberadamente um sidecar: roda em paralelo, não substitui. Você instala em cima de uma instalação Omarchy existente, ele cria uma sessão SDDM separada chamada `nw-bspwm`, e nada do seu Hyprland é tocado. Quer voltar pro Hyprland? Escolhe Hyprland no SDDM no próximo login. Quer desinstalar? Tem script de uninstall que reverte exatamente o que foi instalado, baseado num manifest que rastreia cada ação.

## O que muda no stack (Wayland → X11)

Hyprland é compositor + WM no mesmo binário. No mundo X11 essas duas funções vêm em peças separadas, e cada uma tem um substituto bem-conhecido. O esforço de tradução foi mapear cada componente do Omarchy pro equivalente X11 e garantir que o atalho de teclado, o tema e o comportamento ficassem o mais próximos possível.

| Função | Omarchy/Wayland | NW-Omarchy/X11 |
|---|---|---|
| Window manager | Hyprland | [bspwm](https://github.com/baskerville/bspwm) |
| Hotkey daemon | Hyprland built-in | [sxhkd](https://github.com/baskerville/sxhkd) |
| Compositor | Hyprland built-in | [picom](https://github.com/yshui/picom) (upstream v13) |
| Top bar | Waybar | [polybar](https://github.com/polybar/polybar) |
| App launcher | Walker | [rofi](https://github.com/davatorium/rofi) |
| Notifications | Mako | [dunst](https://github.com/dunst-project/dunst) |
| Idle/lock | hypridle / hyprlock | xidlehook + xss-lock + i3lock-color |
| Nightlight | hyprsunset | redshift |
| Clipboard history | walker `-m clipboard` | [clipmenu](https://github.com/cdown/clipmenu) (rofi-backed) |
| Screenshots | hyprshot | maim + slop + xclip |
| Color picker | hyprpicker | xcolor |

**bspwm** é tiling window manager minimalista. O WM em si só responde a comandos via socket, e o `bspwmrc` é literalmente um shell script. Atalho de teclado fica num daemon separado, **sxhkd**, que lê um arquivo de texto. Essa separação é típica do mundo X11: cada peça faz uma coisa só.

**picom** é o compositor que dá blur, sombra, cantos arredondados, fade-in/out e regras de opacidade por janela. NW-Omarchy usa o upstream v13 (release de fevereiro de 2026), não o fork antigo `picom-ftlabs-git`, [abandonado desde 2024](https://github.com/yshui/picom/issues). Os efeitos visuais que o Omarchy tem no Hyprland (cantos arredondados, fade ao abrir/fechar, blur no rofi e no dunst) vêm todos do picom no NW-Omarchy.

**polybar** substitui o waybar. Mesma topologia visual: logo do Omarchy à esquerda, data no centro, indicadores de áudio/wifi/bluetooth/bateria à direita. Os ícones nerd-font são os mesmos. Click esquerdo abre os mesmos TUIs (wiremix, impala, bluetui), click direito as variantes GUI. Scroll no áudio ajusta volume, click do meio mute. Paridade prática.

**rofi** substitui o walker. `super + space` abre o launcher completo com todos os `.desktop` do sistema e ícones. `super + shift + space` abre uma cheat-sheet das aplicações fixadas, mostrando o atalho ao lado do nome. Útil pra lembrar "qual era o chord pro Signal mesmo".

![Cheat-sheet das aplicações fixadas: super+shift+space abre o rofi com cada app e o chord ao lado, parseado direto do sxhkdrc](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/01/nw-omarchy/launcher-cheatsheet.png)

Pra usuário que não vai abrir o `~/.config` pra customizar nada, a diferença entre as duas sessões é cosmética em níveis homeopáticos. Os mesmos atalhos do Omarchy (mais de 70 bindings) estão mapeados, os mesmos menus aparecem, o mesmo logo no canto da bar, os mesmos ícones nerd-font.

## O sistema de temas é o mesmo

Essa parte foi a mais legal de implementar e a que mais surpreende quando você experimenta. O Omarchy tem um sistema de temas centralizado: cada tema vive em `~/.local/share/omarchy/themes/<nome>/`, traz um `colors.toml` com paleta universal (`accent`, `background`, `foreground`, `color0..15`), e `omarchy-theme-set <nome>` re-renderiza configs de cada app pra refletir essa paleta. O tema ativo fica em `~/.config/omarchy/current/theme/`, e cada app importa as cores de lá.

NW-Omarchy se encaixa nesse mesmo pipeline. Eu adicionei templates `.tpl` pra bspwm, polybar, rofi e dunst que seguem a mesma convenção do Omarchy, e o `omarchy-theme-set-templates` regenera tudo a cada troca de tema. O resultado é que os 19 temas que o Omarchy distribui funcionam tal e qual no NW-Omarchy, sem trabalho de portar. Catppuccin, gruvbox, kanagawa, nord, tokyo-night, todos funcionam. O wallpaper troca junto via um daemon inotify (`nw-omarchy-bg-watch`).

Olha alguns exemplos rodando:

![Tema Ristretto: paleta quente em curvas marrons no wallpaper, polybar e bspwm border seguindo a mesma paleta](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/01/nw-omarchy/theme-ristretto.png)

![Tema Lumon: referência ao Severance, paleta corporativa fria, "United in Severance"](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/01/nw-omarchy/theme-lumon.png)

![Tema Everforest: tons de verde-musgo, wallpaper de copa de árvores enevoada](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/01/nw-omarchy/theme-everforest.png)

![Tema Retro-82: synthwave, grade rosa em fundo escuro, neon nos detalhes](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/01/nw-omarchy/theme-retro-82.png)

Quando o Omarchy ganha um tema novo via `omarchy-theme-update`, NW-Omarchy pega ele de graça. Sem trabalho extra, sem rebuild, sem precisar republicar nada do meu lado.

## Menu do sistema e TUIs

O menu de sistema do Omarchy (aquele `super + alt + space` que abre o menu hierárquico com Hardware, Setup, Update, etc.) tem porte 1-pra-1 no NW-Omarchy. Mesma árvore, mesma navegação. Onde o Omarchy chama `walker --dmenu`, eu chamo `rofi -dmenu`. O resto do código é idêntico, e a maioria dos helpers que o menu invoca (`omarchy-pkg-add`, `omarchy-theme-set`, `omarchy-update`, etc.) não tem nada de Wayland-específico e funciona direto no X11.

![nw-omarchy-menu aberto: a árvore do menu de sistema do Omarchy, navegação por seta, mesma estética](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/01/nw-omarchy/system-menu.png)

Os TUIs também: wiremix pra áudio, impala pra wifi, bluetui pra bluetooth, btop pra recursos do sistema. Todos abrem como janela flutuante centralizada, igual o Omarchy faz no Hyprland. O bspwm tem regra (`bspc rule -a`) que reconhece a classe `org.nw-omarchy.<cmd>` e aplica `state=floating center=on rectangle=900x600` automaticamente.

![Impala TUI rodando como janela flutuante centralizada via super+ctrl+w, paleta seguindo o tema ativo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/01/nw-omarchy/wifi-tui.png)

## O que tem e o que não tem

Honestidade primeiro: tem coisa do Hyprland que é Wayland-only e não volta. Fractional scaling per-monitor não rola, X11 só faz scaling inteiro por output, então setup com mix de DPI fica torto. HDR não existe no X11. Renderização tear-free por design exige Wayland; no X11 precisa de picom + vsync e GPU cooperativa, e mesmo assim fica perto da Wayland sem chegar igual. Workspace swipe com preview ao vivo durante o gesto também não rola, porque o bspwm não tem estado de switch em progresso, então o gesto dispara comando discreto só na conclusão (você vai pra próxima workspace, mas não vê o preview deslizando). E os daemons especificamente Wayland (voxtype, walker preview pane, hyprsunset, hypridle) viram `redshift` e `xss-lock`, sem preview pane no rofi.

Se qualquer um desses pontos é decisivo pra você, fica no Omarchy/Hyprland. SDDM escolhe entre as duas sessões a cada login, então dá pra coexistir sem ressentimento.

Em compensação, o que o X11 tem de bom continua valendo. `xdotool`, `wmctrl`, `xprop` e `xinput` continuam funcionando pra automação, key remap, screen reader, AutoKey, kanata, xkeysnail. `xclip`, `xsel` e clipmenu fazem clipboard plumbing direto, sem dialog de permissão. `ssh -X` segue funcionando: você roda Firefox numa máquina remota e a janela aparece local. Driver Nvidia legacy, Intel vintage e Optimus quirky são first-class no X11. O ecossistema de tiling WM é maduro (bspwm, i3, awesome, openbox, xmonad, dwm) e configs migram entre eles com pouca dor. E o modelo de input previsível, onde qualquer cliente lê qualquer evento, é ruim pra segurança mas ótimo pra acessibilidade e ferramenta de produtividade.

Pra hardware mais velho, isso pesa como diferença entre "máquina viva" e "máquina parada num canto".

## Instalação

Pré-requisito: Arch Linux com Omarchy já instalado. NW-Omarchy roda em cima dele, não substitui.

One-liner de instalação:

```bash
curl -fsSL https://raw.githubusercontent.com/akitaonrails/NW-Omarchy/master/boot.sh | bash
```

O `boot.sh` faz preflight (checa Arch, Omarchy, git), clona o repo pra `~/.local/share/nw-omarchy`, e roda a pipeline de install completa: pacotes, sessão `nw-bspwm`, configs em `~/.config`, e troca pro XLibre como último passo. Pede confirmação uma vez antes de tocar em qualquer coisa. Se você quer pular a confirmação:

```bash
curl -fsSL https://raw.githubusercontent.com/akitaonrails/NW-Omarchy/master/boot.sh | bash -s -- --yes
```

Quando termina, reboota. A troca do X server (xorg-server → XLibre) só vale na próxima sessão. No SDDM, você verá um picker de sessão. A gente também substituiu o tema do SDDM por uma versão com seletor, porque o tema vanilla do Omarchy tem o nome da sessão hardcoded no QML, sem UI pra trocar. Escolhe `nw-bspwm` e tá dentro.

Se você prefere clonar e rodar à mão pra inspecionar antes:

```bash
git clone https://github.com/akitaonrails/NW-Omarchy.git ~/.local/share/nw-omarchy
cd ~/.local/share/nw-omarchy
./install.sh           # dry-run, mostra o que faria
./install.sh --apply   # executa de verdade
```

## Atualização

Quando sai release nova, o caminho é:

```bash
nw-omarchy-upgrade --check    # checa current vs latest, sai
nw-omarchy-upgrade            # yay -Syu, fetch latest tag, migrations, install
```

O script roda `yay -Syu` (ou `pacman -Syu` se você não tem yay), compara a tag local vs a remota, e se tiver release nova faz `git fetch && git checkout v<latest>`, roda as migrations entre a versão atual e a nova, e re-aplica `install.sh --apply`. Tudo idempotente. Re-rodar numa máquina já atualizada é no-op.

## Desinstalação

Se experimentou e não gostou, desinstala assim:

```bash
~/.local/share/nw-omarchy/uninstall.sh --apply
```

O uninstaller lê `~/.local/state/nw-omarchy/manifest.tsv` e replay reverso: remove só os pacotes que ele instalou (`pkg-skip` rows ficam intocadas; pacote que já existia continua no sistema), restaura configs originais a partir de `~/.local/state/nw-omarchy/backups/`, deleta a session entry `nw-bspwm`, limpa o state dir. Sua sessão Hyprland continua funcionando como antes. Nada do `~/.config/hypr/` ou do `~/.local/share/omarchy/` é tocado em momento algum durante a instalação ou desinstalação.

Pra reverter especificamente o XLibre de volta pro xorg-server (sem desinstalar o resto), o pacman resolve sozinho:

```bash
sudo pacman -S xorg-server xorg-server-common xf86-input-libinput
```

Pacote `provides`/`conflicts` cuida do resto da troca atomicamente.

## Status: experimental, feedback bem-vindo

A versão atual tá em 1.0 mas o projeto continua novo, em fase de polimento. Os itens grandes já estão de pé: paridade de bindings, paridade de menu, paridade de temas, paridade dos TUIs, doctor pra checar saúde da instalação, manifest pra uninstall limpo. Falta lapidar, descobrir edge cases, exercitar em hardware variado, ouvir feedback de quem rodar em máquina diferente da minha (Thinkpad T14 Gen 6).

Se você experimentar e bater em algo (coisa que não funciona, configuração que faltou, comportamento que difere do Omarchy de um jeito que quebra fluxo), abre issue lá:

[github.com/akitaonrails/NW-Omarchy/issues](https://github.com/akitaonrails/NW-Omarchy/issues)

Reproduções, stack traces, output do `nw-omarchy-doctor`, qualquer coisa ajuda. PRs também são bem-vindos.

A defesa do X11 em 2026 é pragmática. A transição pro Wayland leva tempo, muito hardware e muito software ainda vivem confortavelmente do lado de cá, e a comunidade open source comporta mais de um caminho ao mesmo tempo. XLibre é a aposta de manter o X server vivo por mais alguns anos. NW-Omarchy é minha aposta de que dá pra fazer esse stack mais velho parecer tão bonito quanto o stack mais novo, sem comprometer nada do que faz X11 ainda valer a pena.

Se você tá em máquina nova, com GPU moderna, monitor 4K HiDPI, querendo HDR, fica no Omarchy/Hyprland. Se você tá numa máquina mais antiga, ou simplesmente prefere o ecossistema X11 por qualquer um dos motivos acima, dá uma chance pro NW-Omarchy.
