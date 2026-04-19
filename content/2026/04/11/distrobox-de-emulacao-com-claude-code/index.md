---
title: "Distrobox de Emulação com Claude Code"
date: '2026-04-11T18:00:00-03:00'
draft: false
translationKey: distrobox-emulacao-claude-code
tags:
  - gaming
  - emulation
  - linux
  - distrobox
  - ansible
  - claude-code
  - AI
---

Eu gosto de videogame velho desde antes de muita gente aqui nascer. Meu primeiro contato foi ainda na era do Atari, no começo dos anos 80. Depois vieram os micros de 8 bits, os arcades dos anos 90, os consoles de 16, 32, 64 bits, e eu continuei acompanhando tudo. Nostalgia, pra mim, não é pasta bonitinha no Instagram. É acervo mesmo. ROM, BIOS, dumps, patches, DLC, firmware, save. Ao longo dos anos fui guardando tudo no meu NAS. Hoje tenho terabytes disso em `/mnt/terachad/Emulators`.

No meu canal eu inclusive usei jogos antigos pra ensinar fundamentos de computação. No [Akitando sobre Super Mario e computadores antigos](https://www.youtube.com/watch?v=hYJ3dvHjeOE&pp=ygUUYWtpdGFuZG8gc3VwZXIgbWFyaW8%3D) eu explico 6502, mapa de memória, PPU, limitações de hardware e por que aqueles jogos eram programados daquele jeito. Se você nunca viu, recomendo assistir:

{{< youtube id="hYJ3dvHjeOE" >}}

O problema é o de sempre: a cada poucos anos eu resolvo montar uma máquina nova de emulação, baixo de novo os emuladores principais da vez, e lá vou eu repetir o mesmo ritual masoquista. `PCSX2`, `RPCS3`, `Eden`, `Azahar`, `Dolphin`, `RetroArch`, `Flycast`, `shadPS4` e por aí vai. Cada um com suas manias. Cada um com sua forma particular de te fazer perder horas.

Em teoria, montar tudo isso deveria ser divertido. Na prática, leva dias. E não é exagero. `Dolphin` ainda consegue ser um dos piores porque controle de GameCube e Wii não tem nada de padrão. `RPCS3` exige tuning por jogo. `Eden` precisa de DLC, update e cheats no lugar certo. `shadPS4` é um festival de tentativa e erro. Quando eu finalmente terminava de configurar tudo, eu já não queria mais jogar porcaria nenhuma. Eu só queria fechar os menus e ir fazer outra coisa.

Eu já cheguei a dizer que talvez a graça estivesse justamente no tuning. Não acho mais isso. Depois de repetir esse processo vezes demais, eu cansei. Eu quero jogar os jogos, não preencher formulário escondido em GUI de emulador.

## O problema não era Linux

Eu já resolvi esse tipo de coisa de várias formas no passado. Anos atrás eu rodava Linux no host e um Windows virtualizado com GPU passthrough pra jogar dentro da VM. Na época era o que fazia sentido. Eu fiz um vídeo inteiro sobre isso:

{{< youtube id="IDnabc3DjYY" >}}

Mas isso foi antes do trabalho monumental da Valve, do Proton, do Wine moderno e de toda a comunidade open source que empurrou o desktop Linux pra um lugar muito melhor. Hoje dá pra evitar Windows na maior parte dos casos. No outro vídeo abaixo eu explico a evolução de CPU, GPU, OpenGL, Vulkan e por que chegamos nesse ponto:

{{< youtube id="JEp7ozWqIps" >}}

Meu mini-PC dedicado a games com RTX 4090 continua sendo minha principal máquina de Steam, especialmente agora que montei um [cockpit decente de sim racing](/2026/04/01/meu-cockpit-de-sim-racing-formula-fx1/). Nele eu uso [EmuDeck](https://www.emudeck.com/), que nasceu justamente pra automatizar instalação e configuração de emuladores no Steam Deck, depois passou a suportar Windows também, e ajuda bastante a reduzir a complicação de montar esse tipo de ambiente. Mas meu desktop principal também é forte demais pra ficar subutilizado. Ele tem uma RTX 5090, e hoje eu uso essa GPU principalmente pra testar LLMs e benchmarking, como contei em [Testando LLMs Open Source e Comerciais](/2026/04/05/testando-llms-open-source-e-comerciais-quem-consegue-bater-o-claude-opus/). Seria um desperdício não usar isso pra gaming também.

Só que no Linux eu queria outra coisa. Eu não queria uma caixa-preta fazendo tudo por mim sem eu saber exatamente o que estava sendo alterado, principalmente no meu PC principal, que é minha máquina de trabalho. Eu queria um setup meu, feito "na mão" no sentido certo da expressão: não clicar GUI por GUI, mas entender o que está sendo configurado, manter os arquivos sob meu controle, e conseguir reconstruir tudo do jeito que eu gosto. Eu sei que o pessoal do NixOS vai pular aqui pra dizer "é só usar Nix" — explico mais abaixo por que descartei essa rota. Também não queria transformar a minha máquina de trabalho num carnaval de pacote de emulador, tema GTK, wrapper, launcher, runtime esquisito e config enterrada em `~/.config`. Nem queria dual boot ou VM. Em 2026, a melhor resposta pra isso, na minha opinião, é [Distrobox](https://distrobox.it/).

Pelo que o próprio projeto explica, Distrobox é um wrapper em cima de `podman`, `docker` ou `lilipod` pra criar containers fortemente integrados ao host, com acesso a `HOME`, Wayland/X11, áudio, dispositivos USB, storage externo e GPU. Ou seja: exatamente o tipo de isolamento pragmático que eu queria. Não é uma fronteira de segurança, e o próprio site deixa isso claro. Não use pensando em sandbox de alta segurança. Use pensando em separar ambientes sem ficar pagando o preço de uma VM.

E antes que alguém repita a confusão de sempre: container não é máquina virtual. Eu explico isso com calma neste outro episódio:

{{< youtube id="85k8se4Zo70" >}}

## O setup

A ideia é simples: um Arch Linux vanilla dentro de um Distrobox chamado `gaming`, com os caminhos do NAS montados em read-only, a biblioteca Steam acessível onde faz sentido, e todos os emuladores instalados lá dentro. Como o container tem acesso a GPU NVIDIA, áudio, USB e demais periféricos, eu separo trabalho de jogo na mesma máquina sem penalidade prática de performance.

O bootstrap inicial é mais ou menos isso:

```bash
distrobox create --name gaming --image archlinux:latest --nvidia \
  --home /mnt/data/distrobox/gaming \
  --volume /mnt/data/steam:/mnt/data/steam \
  --volume /mnt/terachad/Emulators:/mnt/terachad/Emulators:ro
```

Só esse começo já tem pegadinha. O `archlinux:latest` dentro de Distrobox vem sem `[multilib]` no `pacman.conf`, com um `sudoers` mal configurado, e com o velho problema do `--nvidia`: as libs do driver do host entram bind-mounted read-only, então qualquer instalação que dependa de `nvidia-utils` quebra com conflito de arquivo. Só isso já é o tipo de dor de cabeça que, alguns anos atrás, me faria abrir meia dúzia de abas, mais uma penca de terminais, e gastar uma noite inteira em tentativa e erro.

Desta vez eu fiz diferente.

## Claude Code como assistente de infraestrutura

Eu venho ficando cada vez mais confortável em usar Claude Code como meu assistente de infraestrutura nas minhas máquinas pessoais. Eu não faria isso cegamente em servidor de cliente. Mas em máquina minha, em ambiente que eu posso destruir e reconstruir quantas vezes eu quiser, faz todo sentido. Escrevi sobre isso no artigo [Migrando meu Home Server com Claude Code](/2026/03/31/migrando-meu-home-server-com-claude-code/), quando usei Claude pra instalar e configurar openSUSE MicroOS, Docker, NFS, firewall, hardening e o resto todo sem eu precisar ficar lembrando comando chato de shell.

Então pensei: por que não fazer a mesma coisa aqui?

Foi exatamente o que eu fiz. Comecei com prompts bem objetivos, sempre pedindo duas coisas ao mesmo tempo: fazer o trabalho e documentar o suficiente pra eu poder reconstruir tudo depois. O histórico mais importante ficou em [`docs/distrobox-gaming-prompts.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/distrobox-gaming-prompts.md).

Vale um esclarecimento: aqueles prompts no GitHub não são as minhas mensagens cruas, do jeito que saíram na hora. Depois que tudo funcionou, eu pedi pro próprio Claude reescrever os prompts de forma organizada e detalhada, só pra fins de documentação. Os prompts originais eram bem mais simples e bem menos específicos. Eu descrevia o objetivo e deixava o Claude descobrir sozinho paths, arquivos de configuração, formatos e comandos necessários.

O primeiro prompt criou a box com `--nvidia`, `--home` separado e os mounts corretos. O segundo resolveu os três problemas clássicos do Arch dentro de Distrobox: `sudo`, `multilib` e o dummy package de `nvidia-utils`. O terceiro instalou a base de gaming, inclusive um detalhe que eu teria esquecido fácil se estivesse fazendo na mão: `pipewire-pulse`, necessário pra vários emuladores não ficarem mudos nem perderem sincronia.

O ponto não é o texto em si. O ponto é o método. Eu não preciso lembrar a ordem exata, nem as opções precisas, nem onde está a documentação de cada detalhe. Eu descrevo o objetivo e deixo o agente carregar o piano. Fico no papel de tech lead: observando, revisando, corrigindo direção quando precisa, e mandando continuar.

## O projeto no GitHub

O setup vive em [akitaonrails/distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming), estruturado como um projeto Ansible. 17 roles cobrem desde criação da box, bootstrap de pacotes, seed de configs, instalação de DLC, configuração de controle, até verificação pós-setup. Os playbooks principais são:

- `site.yml`: setup completo do zero
- `reset-configs.yml`: reset só das configs (útil quando você quer zerar tuning e redeployar)
- `backup.yml` / `restore.yml`: snapshot e restauração do container inteiro via `podman commit`
- `refresh-shadps4.yml`: atualização standalone do shadPS4
- `install-xenia.yml`: instalação opcional do Xenia Manager (Wine prefix)

O passo a passo completo está em [`docs/rebuild-runbook.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/rebuild-runbook.md). As decisões de pacote (por que AUR em vez de Flatpak, por exemplo) estão em [`docs/distrobox-gaming-packages.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/distrobox-gaming-packages.md).

### Por que não Nix?

Alguém vai perguntar. "Você tá recriando ambiente reproduzível. Por que não usar NixOS, ou pelo menos `nix-shell`/flakes?"

Eu considerei e descartei. O ecossistema de emuladores que eu preciso vive no AUR. Pacotes `-bin` do AUR são wrappers de AppImage que empacotam o binário oficial do upstream sem compilar nada. `rpcs3-bin`, `pcsx2-latest-bin`, `eden-bin`, `duckstation-qt-bin`, `shadps4-bin` — esses binários acompanham o upstream praticamente no dia do lançamento. No Nixpkgs, muitos desses emuladores ficam semanas ou meses atrás do release, e alguns nem existem. Criar um overlay Nix pra cada emulador que eu preciso, manter, e lidar com os patches de compatibilidade quando upstream muda, é trabalho que eu não quero ter.

Tem também o modelo mental. Eu não quero aprender a linguagem Nix, o sistema de derivações e o modelo de avaliação pra montar um ambiente de games pessoal. Ansible eu já conheço, as roles são pastas com tasks em YAML, e o debug é `ansible-playbook -vvv`. Quando dá errado, eu leio a mensagem de erro, abro o task que falhou, e sei exatamente onde mexer. Se eu precisasse do mesmo nível de reprodutibilidade em escala, num cluster, com rollback atômico, aí sim Nix teria argumento. Pra um distrobox com emuladores na minha máquina pessoal, Ansible resolve com muito menos atrito.

Flatpak também foi testado e descartado. O `bwrap` (bubblewrap) do Flatpak não aninha direito dentro das mount namespaces do Docker, então apps Flatpak simplesmente não rodam dentro de distrobox. A alternativa seria instalar Flatpak no host, mas aí você volta ao problema de poluir a máquina de trabalho com pacotes de gaming. Além disso, as versões Flatpak de emuladores ficam bem atrás do AUR — o `pcsx2-latest-bin` do AUR tracka o AppImage 2.7.x, enquanto o Flathub ainda distribui a v2.6.3.

## Plataformas cobertas

O setup cobre 12 plataformas hoje:

| Plataforma | Emulador | Renderer | Destaque |
|---|---|---|---|
| PS1 | DuckStation | Vulkan, 8x upscale | JINC2 filter, PGXP, widescreen hack |
| PS2 | PCSX2 2.7.x | Vulkan, 4x SSAA | FXAA + PCRTC antiblur, Xbox bindings |
| PS3 | RPCS3 | Vulkan | Per-game configs curados via API |
| PS4 | shadPS4 | Vulkan | Driveclub em foco (experimental) |
| PS Vita | Vita3K | — | Seeding padrão |
| GameCube | Dolphin | Vulkan | Perfis 8BitDo Ultimate 2 |
| Wii | Dolphin | Vulkan | Classic Controller + Nunchuk |
| Wii U | Cemu | Vulkan | Baseline seed only-if-missing |
| Switch | Eden | Vulkan | DLC + cheats Atmosphere |
| Dreamcast | Flycast | Vulkan, 2880p | Wrapper hires, widescreen |
| OG Xbox | xemu | — | BIOS/HDD via symlink |
| Xbox 360 | Xenia (Wine) | Vulkan | Project Forza Plus, PGR3/4 |

RetroArch entra por cima pra cobrir o resto (NES, SNES, Genesis, N64, arcade, etc.), com 21 cores do buildbot e 8 asset packs (databases, shaders, cheats, overlays, autoconfig).

Frontend é [ES-DE](https://es-de.org/). As definições dos sistemas customizados ficam em `ansible/group_vars/all/esde.yml` e cada emulador entra com um wrapper que já sobe com as variáveis certas de GPU (voltarei nisso).

## GPU hardforce pra NVIDIA

Num sistema híbrido com NVIDIA dGPU + AMD iGPU (meu caso no desktop), Vulkan às vezes escolhe o iGPU sozinho e o resultado é emulador rodando a 15 fps enquanto a 5090 fica parada. A solução é forçar o ICD Vulkan da NVIDIA em todos os launchers.

Cada entrada de desktop rendereizada pelo Ansible exporta `VK_ICD_FILENAMES` apontando pro ICD da NVIDIA, e o wrapper do ES-DE faz a mesma coisa antes de lançar qualquer core. Em combinação com a flag `--nvidia` na criação da box, que bind-monta os drivers do host em read-only, o resultado é previsível: Vulkan sempre na dGPU NVIDIA, independente do estado do sistema na hora.

Isso vale principalmente pra quem tem setup híbrido. Num desktop com só uma GPU, o ICD filtering é placebo, mas também não atrapalha.

## PS2: PCSX2 com tuning por jogo

A linha Gran Turismo é meu vício declarado. Cada versão precisa de tweak específico. O setup do PCSX2 hoje tem configs globais razoáveis (Vulkan, 4x SSAA, widescreen 16:9, Xbox-style bindings, FXAA + PCRTC antiblur, 16x anisotropic, deinterlace Automatic) e per-game INIs pros títulos que eu realmente jogo:

- **Gran Turismo 3 A-spec** (SCUS-97102 + bundle PBPX-95503): widescreen pnach, pack de retextura opcional (desabilitado por default porque NFS causa flicker em cutscenes de showcase de carro)
- **Gran Turismo 4 USA** (SCUS-97328): HD HUD do Silentwarior112, pack completo de retextura, patches do Silent pra gatilho e câmera, widescreen pnach
- **Gran Turismo 4 Spec II** (SCUS-97436, CRC `4CE521F2`): caso especial — os HD packs de GT4 vanilla são linkados via symlink porque o Spec II tem mesma estrutura mas CRC diferente. Widescreen pnach renomeado pra bater com o CRC. Deinterlace mode 8 (Adaptive TFF), ShadeBoost tuning (+10 saturação, +3 brilho, +2 contraste) pra corrigir ghosting de pause-interlace e saturação anêmica do upscale
- **Enthusia Professional Racing** (SLUS-20967): HD textures + widescreen
- **Ridge Racer V** (SLUS-20002): widescreen + no-interlace pnach

Os pnach files do Silent e da comunidade são baixados automaticamente pelo role `pcsx2_textures`, que também faz o deploy do pack de cheats do NAS e instala os HD packs do Spec II via symlink. Widescreen é ligado via `gamesettings` por CRC (PCSX2 identifica jogo por CRC antes de aplicar o pnach).

Sobre versão do PCSX2: o `pcsx2-latest-bin` do AUR tracka a linha 2.7.x, que é onde todas as features modernas estão (texture replacement, FXAA, PCRTC antiblur). O `pcsx2` padrão dos repos oficiais do Arch ainda está na 2.6.3. A diferença é mais de 250 commits de correção e feature novo.

## PS3: RPCS3 com per-game configs curados

RPCS3 tem um detalhe chato: configs por jogo ficam em `~/.config/rpcs3/custom_configs/config_<SERIAL>.yml`. O formato do arquivo tem versão, e se você gerar um YAML manualmente com versão errada, o RPCS3 rejeita silenciosamente e volta pro default. Isso custou tempo pra descobrir.

A role `rpcs3_per_game_configs` resolve isso assim:

1. Query o [compatibility DB da comunidade RPCS3](https://rpcs3.net/compatibility) pra pegar os presets recomendados por título
2. Aplica overrides curados por cima pra títulos que eu sei que precisam de ajuste específico (tipicamente GT5 e GT6)
3. Salva o YAML com a filename convention exata (`config_<SERIAL>.yml`, prefixo `config_` obrigatório)

Na linha Gran Turismo:

- **GT5** (BCUS98114, BCES00569): Resolution Scale 300%, Shader Precision Ultra, Force High Precision Z, SPU XFloat Accurate, Multithreaded RSX. Combinação que mata o dithering típico do RSX sem quebrar a GT series safety config (WCB/RCB off).
- **GT6** (BCES01893 + variantes regionais): caso especial, **versão travada em v1.05**. Patches 1.06+ regridem com superfícies pretas em carros no menu garagem. O script `extract_ps3_dlc.py` tem per-title PATCH ceiling justamente pra pinar o GT6 no 1.05 mesmo quando o PSN cuspe patches mais novos. Além disso, Force CPU Blit ligado é mandatório (sem ele, flicker de tela inteira). O trade-off é que o retrovisor fica permanentemente preto — ligar WCB restauraria o retrovisor mas downgradaria pra 720p nativo. Prefiro perder o retrovisor.

Mais detalhes desses dois em [`docs/gt5-rpcs3.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/gt5-rpcs3.md) e [`docs/gt6-rpcs3.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/gt6-rpcs3.md).

### Update checker de PS3

Pra não ter que abrir a GUI do RPCS3 e ficar clicando em `Download Game Updates` jogo por jogo, criei um script em Python: `check_ps3_updates.py`. Ele percorre os jogos instalados em `dev_hdd0/game`, parseia o `PARAM.SFO` pra pegar a versão atual de cada título, consulta o servidor de updates da PSN (`a0.ww.np.dl.playstation.net`) e compara com o cache local de patches. `--list` mostra o diff; `--download` baixa o que falta. `--max-version` respeita os teto por título (ex: 1.05 pro GT6).

O primeiro scan na minha biblioteca achou 51 de 72 jogos com update disponível, 69 patches faltando localmente, uns 24 GB no total. Só o GT6 sozinho tinha 16 patches faltando, da 1.07 até 1.22, que eu descartei pelos motivos acima.

Os patches chegam como pacotes PSN tipo 0x0001 sem criptografia, então o próprio `extract_ps3_dlc.py` consegue instalar depois. A chamada padrão:

```bash
distrobox enter gaming -- python3 scripts/extract_ps3_dlc.py \
  "/mnt/terachad/Emulators/EmuDeck/roms_heavy/ps3-DLC" \
  --dest "/mnt/data/distrobox/gaming/.config/rpcs3/dev_hdd0/game"
```

Acompanhar versão de DLC de PS3 manualmente, jogo por jogo no RPCS3, é inviável. Vira lista de tarefas eterna e você só descobre que tinha patch 1.22 quando o jogo crasha.

## PS1: DuckStation com per-game

A trilogia Gran Turismo começa no PS1, e a qualidade ali só sobe se você ligar as coisas certas:

- **Gran Turismo** (SCUS-94949): built-in WidescreenHack do DuckStation (não existe cheat pra esse jogo), PGXP ligado
- **Gran Turismo 2 Simulation** (SCUS-94455): widescreen cheat + 8 MB RAM cheat (fix de áudio em track crowded), filter JINC2
- **Gran Turismo 2 Arcade** (SCUS-94488): mesmo tratamento do Simulation

Global defaults: Vulkan, 8x upscale, JINC2 como filter default.

Os cheats pro GT2 saem de um repositório de widescreen fixes e são ligados automaticamente na pasta de cheats do DuckStation.

## Switch: Eden com DLC, update e cheats

No Switch, `eden-bin` é o emulador. A integração automatiza três coisas que antes eu fazia na mão:

1. **Install de DLC e update**: o role `install_dlcs` aponta pro diretório de dumps no NAS, identifica os arquivos `.nsp`/`.nsz`/`.xci`/`.xcz`, e instala tudo em `~/.local/share/eden/nand/user/Contents/registered/`. Se o dump está bagunçado (patches e DLC misturados em flat folder), o script `reorganize_switch_nsps.py` sorteia tudo por Title ID antes.

2. **Cheats Atmosphere**: os cheats em formato Atmosphere vão symlinkados pro load path do Eden (`~/.local/share/eden/load/<TITLE_ID>/cheats/`). O role `switch_cheats` faz isso por todos os títulos cobertos pelo pack do NAS.

3. **Update checker**: `check_switch_updates.py` lista títulos com update disponível vs o que tá instalado localmente. Útil pra não perder patch importante de jogo que sai atualização ainda.

Atenção ao detalhe que me queimou: `QT_STYLE_OVERRIDE` precisa ser desarmado antes de lançar o `eden-bin`, senão ele conflita com Kvantum e quebra a UI. O wrapper já faz o `unset` antes do `exec`.

## Xbox 360: Xenia Manager via Wine

Xbox 360 ainda é território áspero no Linux. Não tem emulador nativo decente. A melhor rota hoje é [Xenia](https://xenia.jp/) rodando via Wine, gerenciado pelo [Xenia Manager](https://github.com/xenia-manager/xenia-manager).

Isso é opt-in no meu setup. O playbook `install-xenia.yml` cria um Wine prefix dedicado, baixa o Xenia Manager, e registra os launchers. Não faz parte do `site.yml` principal porque nem todo mundo quer Wine no meio do caminho.

### Project Forza Plus (Forza Motorsport 2/3/4)

Forza antigo ainda é o rei do simcade de geração passada. Rodar FM2/3/4 no Xenia requer mods da comunidade Project Forza Plus: patches de compatibilidade, mods de performance, instalação de title updates específicos. Documentei o processo em [`docs/project-forza.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/project-forza.md).

### Project Gotham Racing 3 e 4

PGR3 roda razoavelmente bem no Xenia Canary. PGR4 precisa de ajuste específico: `render_target_path_vulkan = "fsi"` no config, senão algumas races quebram com artefato visual. Documentei o setup em [`docs/xbox360-pgr.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/xbox360-pgr.md). Áudio do PGR4 no NVIDIA ainda tem problema de XMA decoding que gera garbage intermitente. Tem issue aberta no xenia-canary, sem resolução up até agora.

### Title Updates em batch

Title Update pra jogo de Xbox 360 era distribuído pela Xbox Live, que já foi desligada. A alternativa é o archive.org, que tem o catálogo completo preservado. Escrevi `scripts/download-xbox360-tus.py` pra automatizar:

```bash
distrobox enter gaming -- python3 scripts/download-xbox360-tus.py \
  --src /mnt/terachad/Emulators/EmuDeck/roms_heavy/xbox360 \
  --dest /mnt/terachad/Emulators/EmuDeck/roms_heavy/xbox360-updates \
  --dry-run
```

O script precisa do CLI `internetarchive` autenticado (`ia configure` uma vez, guarda o token). Ele scaneia a pasta de jogos, faz match contra o manifest do archive.org (cacheado localmente), prioriza por região (USA > World > Europe > Japan), e baixa via `ia download --checksum` com retry automático. Os .zip resultantes vão pro Xenia Manager via `Manage → Install Content`, que extrai pro diretório correto (`000B0000/`).

O setup completo tá em [`docs/xbox360-title-updates.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/xbox360-title-updates.md).

## Steam no distrobox

Desde que o Proton virou cidadão de primeira no Linux, faz sentido ter Steam também no gaming box. Adicionei o pacote `steam` no Ansible (que puxa multilib e dependências 32-bit), montei `/mnt/data/steam` em read-write pra a biblioteca persistir fora do container, e criei launcher no host.

Na prática, isso me permite rodar jogos Steam via Proton lado a lado com emulação, sem precisar alternar ambiente. O mini-PC com RTX 4090 continua sendo a máquina principal de Steam no cockpit de sim racing. O desktop é fallback e ambiente de teste.

## Shell e controle por controle

### Shell mínimo dentro da box

Quando eu entro no gaming box via `distrobox enter gaming`, eu quero prompt decente mesmo pra troubleshooting rápido. Instalei `zsh` + `starship` com config mínima, zero plugins exóticos. Não é meu setup de dev full, é só "prompt que mostra path e git branch sem me dar vergonha".

### Dolphin e o inferno do controle moderno

`Dolphin` sempre foi o rei do atrito manual. Se você usa um controle mais moderno, como meu 8BitDo Ultimate 2, precisa lembrar como eu gosto do mapeamento de GameCube, como adapto o Wii Remote, quando usar perfil de Nunchuk, quando trocar pro Classic Controller. Eu não tenho a menor paciência pra reconstruir isso na mão toda vez. Os perfis ficam prontos em `config/emulator-overrides/dolphin/Profiles/` e são copiados pelo role `seed_configs`. Detalhes em [`docs/controller-hotkeys.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/controller-hotkeys.md).

## Alguns tropeços que sobraram

Nem tudo virou magia. Emulação sempre tem casca de banana.

`Flycast`, por exemplo, tem uma armadilha irritante. O arquivo `emu.cfg` usa chaves `rend.*` dentro da seção `[config]`. Se você cria uma seção `[rend]` separada, parece certo, mas o emulador simplesmente ignora e depois reescreve tudo com default medíocre. A correção virou wrapper dedicado em `$DG_BOX_HOME/bin/flycast-hires`:

```bash
$DG_BOX_HOME/bin/flycast-hires \
  -config config:pvr.rend=4 \
  -config config:rend.Resolution=2880 \
  -config config:rend.EmulateFramebuffer=no \
  -config config:rend.WideScreen=yes
```

Detalhes em [`docs/flycast-resolution.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/flycast-resolution.md).

`shadPS4` ainda está longe de ser um caso encerrado. O setup atual é focado em `Driveclub`, com config espelhada, patch XML e links dos `sys_modules` do firmware 11.00. E isso não foi por acaso: eu gosto muito de `Driveclub`. Aliás, é praticamente o único jogo ainda preso no PS4 que eu realmente queria conseguir rodar direito. Eu já vi vários vídeos no YouTube mostrando o jogo funcionando, mas até agora eu mesmo não consegui fazer isso rodar de forma satisfatória no Linux. Documentado em [`docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md). A parte boa é que agora eu não dependo mais de memória muscular pra lembrar como lançar, com qual patch, em que pasta, com quais módulos. A parte ruim é que emulação de PS4 ainda é emulação de PS4. Não existe script que faça upstream amadurecer mais rápido. Se alguém souber como fechar essa configuração no Linux, olhe o projeto no GitHub e mande um PR.

Ridge Racer V tem um flickering de textura de carro documentado nas issues do PCSX2 (#3639, #13729). O renderer Hardware é aceitável pra jogo de corrida onde você não fica admirando parado o modelo. Software renderer resolve mas mata performance. Escolhi aceitar o flicker.

## O ganho real não é só automação

Seria fácil resumir isso como "olha que legal, usei IA pra automatizar shell script". Não é isso.

O ganho real é mais chato e mais importante: eu parei de gastar energia mental com trabalho braçal. Não precisei mais lembrar comando raro. Não precisei manter dezenas de abas com wiki, issue, fórum e README. Não precisei deixar meia dúzia de terminais espalhados dando `tail` em log enquanto tento lembrar que opção escondida de GUI o emulador insiste em regravar no primeiro boot. Eu passei a trabalhar em conversa.

Eu digo pro agente o objetivo. Ele procura os arquivos, lê os logs, encontra o formato certo do config, compara defaults, propõe correções, escreve script, valida paths, verifica UID/GID, confere symlink quebrado, gera wrapper, exporta launcher. Eu continuo responsável pelas decisões, claro. Mas parei de ser digitador de comando raro.

Esse é o ponto que mais me interessa no uso de coding agents em Linux. Eles reduzem dramaticamente a fricção de entrada. Muita gente desiste do desktop Linux não porque o sistema seja incapaz, mas porque a curva de tuning historicamente foi irritante demais. Ter um assistente capaz de ler docs, cruzar config, propor automação e executar com supervisão muda esse jogo.

## Se você quiser reproduzir

O repo foi publicado pra isso:

```bash
git clone https://github.com/akitaonrails/distrobox-gaming.git
cd distrobox-gaming/ansible
ansible-galaxy collection install -r collections/requirements.yml
cp host_vars/localhost.yml.example host_vars/localhost.yml
$EDITOR host_vars/localhost.yml  # ajuste paths da sua máquina
ansible-playbook site.yml
```

Xenia é opt-in:

```bash
ansible-playbook install-xenia.yml
```

Leia o [`README.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/README.md) e o [`docs/rebuild-runbook.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/rebuild-runbook.md) antes. Eu não distribuo ROM, BIOS, firmware nem chaves. O repo só detecta, linka e configura o que você já tem na sua própria máquina.

## Se você preferir a rota com Claude Code

Minha recomendação é simples:

1. Comece pelo objetivo, não pelo comando. "Quero um distrobox Arch com GPU NVIDIA, home separado, ROMs read-only e Steam rw" é melhor do que despejar meia linha de shell sem contexto.
2. Peça sempre pra documentar o que está fazendo. Se der certo, promova o resultado a script ou role. Se não documentar, você acabou de fabricar uma gambiarra descartável.
3. Trabalhe em fases. Criação da box. Bootstrap. Config de emuladores. Export de launchers. Verificação. Foi exatamente assim que eu quebrei o problema.
4. Peça verificações objetivas. `command -v`, existência de arquivos, symlinks quebrados, UID/GID, path de ROM, áudio, GPU. A melhor automação é a que falha cedo.
5. Não use agente como papagaio de comando. Use como assistente técnico. Você continua revisando as decisões e mandando ajustar o rumo.

Pra mim, esse foi o ganho. Eu saí do zero pra uma máquina de emulação muito mais completa sem precisar customizar tudo na unha, em GUI, uma janela por vez. E, dessa vez, terminei com energia pra fazer o que eu queria desde o começo.

Jogar.
