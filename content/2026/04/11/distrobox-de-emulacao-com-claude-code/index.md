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

## O plano

A ideia foi simples: criar um Arch Linux vanilla dentro de um Distrobox chamado `gaming`, montar meus caminhos do NAS em read-only, deixar a Steam library acessível onde fazia sentido, e instalar todos os emuladores lá dentro. Como o container tem acesso a GPU NVIDIA, áudio, USB e demais periféricos, eu consigo separar trabalho de jogo na mesma máquina sem penalidade prática de performance.

O bootstrap inicial era mais ou menos isso:

```bash
distrobox create --name gaming --image archlinux:latest --nvidia \
  --home /mnt/data/distrobox/gaming \
  --volume /mnt/data/steam:/mnt/data/steam \
  --volume /mnt/terachad/Emulators:/mnt/terachad/Emulators:ro
```

Sim, só esse começo já tem pegadinha. O `archlinux:latest` dentro de Distrobox veio sem `[multilib]` no `pacman.conf`, com um `sudoers` mal configurado, e com o velho problema do `--nvidia`: as libs do driver do host entram bind-mounted read-only, então qualquer instalação que dependa de `nvidia-utils` quebra com conflito de arquivo. Só isso já era o tipo de dor de cabeça que, alguns anos atrás, me faria abrir meia dúzia de abas, mais uma penca de terminais, e gastar uma noite inteira em tentativa e erro.

Desta vez eu fiz diferente.

## Claude Code como assistente de infraestrutura

Eu venho ficando cada vez mais confortável em usar Claude Code como meu assistente de infraestrutura nas minhas máquinas pessoais. Eu não faria isso cegamente em servidor de cliente. Mas em máquina minha, em ambiente que eu posso destruir e reconstruir quantas vezes eu quiser, faz todo sentido. Escrevi sobre isso no artigo [Migrando meu Home Server com Claude Code](/2026/03/31/migrando-meu-home-server-com-claude-code/), quando usei Claude pra instalar e configurar openSUSE MicroOS, Docker, NFS, firewall, hardening e o resto todo sem eu precisar ficar lembrando comando chato de shell.

Então pensei: por que não fazer a mesma coisa aqui?

Foi exatamente o que eu fiz. Eu comecei com uma sequência de prompts bem objetivos, sempre pedindo duas coisas ao mesmo tempo: fazer o trabalho e documentar o suficiente pra eu poder reconstruir tudo depois. O histórico mais importante disso ficou em [`docs/distrobox-gaming-prompts.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/distrobox-gaming-prompts.md).

Mas vale um esclarecimento importante: aqueles prompts no GitHub não são as minhas mensagens cruas, do jeito que saíram na hora. Depois que tudo funcionou, eu pedi pro próprio Claude reescrever os prompts de forma muito mais organizada e detalhada, só pra fins de documentação. Os prompts originais eram bem mais simples e bem menos específicos. Na prática, eu pedia o objetivo e deixava o Claude descobrir sozinho paths, arquivos de configuração, formatos e comandos necessários.

O primeiro prompt já criou a box com `--nvidia`, `--home` separado e os mounts corretos. O segundo resolveu os três problemas clássicos do Arch dentro de Distrobox: `sudo`, `multilib` e o dummy package de `nvidia-utils`. O terceiro instalou a base de gaming, inclusive um detalhe que eu teria esquecido fácil se estivesse fazendo na mão: `pipewire-pulse`, necessário pra vários emuladores não ficarem mudos nem perderem sincronia.

Aqui está um trecho real do tipo de prompt que usei:

```text
The distrobox gaming container is created. I need you to fix three known issues
with archlinux:latest in distrobox, IN THIS ORDER...

1. PASSWORDLESS SUDO
2. MULTILIB
3. NVIDIA-UTILS DUMMY
```

O ponto não é o texto em si. O ponto é o método. Eu não precisei lembrar a ordem exata, nem as opções precisas, nem onde estava a documentação de cada detalhe. Eu descrevi o objetivo e deixei o agente carregar o piano. Eu fiquei no papel de tech lead: observando, revisando, corrigindo direção quando precisava, e mandando continuar.

## De prompts para scripts — e de scripts para Ansible

Depois que a configuração parou de ser experimento e virou setup conhecido, converti tudo num projeto público: [akitaonrails/distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming).

A primeira versão era um punhado de shell scripts numerados em POSIX `sh`, orquestrados por um dispatcher chamado `bin/dg`. Cada fase tinha seu script: `00-check-host.sh` validava paths e permissões, `01-create-box.sh` criava o distrobox, `02-bootstrap-packages.sh` instalava pacotes, e assim por diante até o `08-verify.sh` que rodava regressão. A ideia era boa: um processo determinístico que eu pudesse rodar do zero numa máquina nova. Funcionou.

Só que shell script imperativo tem limites que aparecem rápido quando você tenta evoluir a automação. O maior deles é idempotência. Em shell, pra saber se uma ação já foi executada, você precisa checar manualmente: "esse diretório já existe?", "esse INI já tem essa chave?", "esse pacote já foi instalado?". A lógica fica cheia de `if/then/fi` que basicamente reimplementa, mal, o que ferramentas de gerenciamento de configuração já fazem há décadas. Outro problema: quando eu queria rodar só a parte de configs sem reinstalar a box inteira, o fluxo sequencial do `bin/dg` não ajudava. E backup/restore do container pra testar rebuilds destrutivos era algo que eu fazia na mão com `podman commit`.

Então converti o projeto pra [Ansible](https://docs.ansible.com/). A estrutura ficou assim: 10 roles mapeados 1:1 pros scripts originais (`check_host`, `create_box`, `bootstrap_packages`, `link_storage`, `seed_configs`, `desktop_apps`, `configure_esde`, `verify`, `refresh_shadps4`, `install_xenia`) e 6 playbooks com propósitos claros:

```bash
cd ansible
ansible-playbook site.yml               # setup completo do zero
ansible-playbook reset-configs.yml       # reseta configs sem reinstalar a box
ansible-playbook backup.yml              # snapshot do container + tarball do home
ansible-playbook restore.yml             # restaura do backup
ansible-playbook refresh-shadps4.yml     # atualiza builds do shadPS4
ansible-playbook install-xenia.yml       # instala/atualiza Xenia Manager
```

Tags permitem rodar subconjuntos: `--tags esde` aplica só o ES-DE, `--tags configs` só as configs de emulador, `--tags desktop` só os launchers. Essa granularidade simplesmente não existia no fluxo de shell scripts.

As variáveis que antes viviam espalhadas em `lib/paths.sh` como 70+ `DG_*` exports agora estão organizadas em `group_vars/all/`: `main.yml` (paths, identidade da box, UID/GID), `packages.yml` (listas de pacman e AUR), `emulators.yml` (configs por emulador), `shadps4.yml`, `xenia.yml`, `esde.yml`. Cada concern no seu arquivo. Se você quiser sobrescrever alguma coisa na sua máquina, cria um `host_vars/localhost.yml` e pronto — sem editar playbook nenhum.

A parte que mais ganhou foi a configuração do ES-DE. Antes era um template sed com placeholders `@DG_*@` que eu substituía com a função `render_template` do `common.sh`. Agora os sistemas do ES-DE são dados em YAML — nome, extensões, comando, path de ROMs — e um template Jinja2 renderiza o XML final via loop. Adicionar um sistema novo é adicionar um bloco de YAML, não editar um XML gigante à mão.

Os shell scripts continuam no repo e funcionam. Se você preferir não instalar Ansible, `./bin/dg all` ainda faz tudo. Mas o caminho preferido daqui pra frente é o Ansible.

A documentação também continua lá:

- [`docs/distrobox-gaming-prompts.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/distrobox-gaming-prompts.md) — o histórico dos prompts que geraram tudo
- [`docs/rebuild-runbook.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/rebuild-runbook.md) — passo a passo de rebuild
- [`docs/controller-hotkeys.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/controller-hotkeys.md) — mapeamento de controles
- [`docs/flycast-resolution.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/flycast-resolution.md) — armadilha do Flycast
- [`docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md) — config do Driveclub
- [`docs/distrobox-gaming-packages.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/distrobox-gaming-packages.md) — decisões de pacotes, por que AUR e não Flatpak

### Por que não Nix?

Alguém vai perguntar. "Você tá recriando ambiente reproduzível. Por que não usar NixOS, ou pelo menos `nix-shell`/flakes?"

Eu considerei e descartei. O ecossistema de emuladores que eu preciso vive no AUR. Pacotes `-bin` do AUR são wrappers de AppImage que empacotam o binário oficial do upstream sem compilar nada. `rpcs3-bin`, `pcsx2-latest-bin`, `eden-bin`, `duckstation-qt-bin`, `shadps4-bin` — esses binários acompanham o upstream praticamente no dia do lançamento. No Nixpkgs, muitos desses emuladores ficam semanas ou meses atrás do release, e alguns nem existem. Criar um overlay Nix pra cada emulador que eu preciso, manter, e lidar com os patches de compatibilidade quando upstream muda, é trabalho que eu não quero ter.

Tem também o modelo mental. Eu não quero aprender a linguagem Nix, o sistema de derivações e o modelo de avaliação pra montar um ambiente de games pessoal. Ansible eu já conheço, as roles são pastas com tasks em YAML, e o debug é `ansible-playbook -vvv`. Quando dá errado, eu leio a mensagem de erro, abro o task que falhou, e sei exatamente onde mexer. Se eu precisasse do mesmo nível de reprodutibilidade em escala, num cluster, com rollback atômico, aí sim Nix teria argumento. Pra um distrobox com emuladores na minha máquina pessoal, Ansible resolve com muito menos atrito.

Flatpak também foi testado e descartado. O `bwrap` (bubblewrap) do Flatpak não aninha direito dentro das mount namespaces do Docker, então apps Flatpak simplesmente não rodam dentro de distrobox. A alternativa seria instalar Flatpak no host, mas aí você volta ao problema de poluir a máquina de trabalho com pacotes de gaming. Além disso, as versões Flatpak de emuladores ficam bem atrás do AUR — o PCSX2 do Flathub em abril de 2026 ainda estava na v2.6.3, uns 250 commits atrás do master que o `pcsx2-latest-bin` do AUR já empacotava.

## O que antes era GUI manual, agora virou automação

Essa foi a parte que mais me interessou.

Anos atrás, pra deixar `RPCS3` em estado utilizável, eu abria a GUI e ia jogo por jogo. Pra instalar DLC era pior ainda. O próprio `RPCS3` bloqueia `--installpkg` em modo `--no-gui`, então a automação óbvia não funciona. A solução foi ignorar a GUI e extrair os PKGs diretamente pro `dev_hdd0/game/` com um script Python. Está documentado no prompt 11 e no próprio repo:

```bash
python3 /mnt/data/distrobox/gaming/scripts/extract_ps3_dlc.py \
  "/mnt/terachad/Emulators/EmuDeck/roms_heavy/ps3-DLC" \
  --dest "/mnt/data/distrobox/gaming/.config/rpcs3/dev_hdd0/game"
```

Resultado: em vez de clicar em dezenas de janelas, o processo virou batch. Mais importante: repetível.

No caso do Switch, a história era parecida. Antigamente eu abriria `Ryujinx`, hoje `Eden`, e iria jogo por jogo instalando update, DLC, cheat, arrumando pasta de `keys`, conferindo firmware, e assim por diante. Agora isso está descrito em prompts e convertido em passos automatizados. `prod.keys` e `title.keys` vão pro lugar certo, os cheats em formato Atmosphere são ligados em `~/.local/share/eden/load/<TITLE_ID>/cheats/`, e o `ES-DE` já sobe chamando o wrapper certo, inclusive com o detalhe de desarmar `QT_STYLE_OVERRIDE` porque o `eden-bin` conflita com `Kvantum`.

`Dolphin` sempre foi o rei do atrito manual. Se você usa um controle mais moderno, como meu 8BitDo Ultimate 2, precisa lembrar como eu gosto do mapeamento de GameCube, como adapto o Wii Remote, quando usar perfil de Nunchuk, quando trocar pro Classic Controller. Eu não tenho a menor paciência pra reconstruir isso na mão toda vez. Então deixei perfis prontos e configs seeded. Os detalhes estão em [`docs/controller-hotkeys.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/controller-hotkeys.md). Agora eu não preciso mais passar meia hora pescando binding em menu obscuro.

## Alguns tropeços no caminho

Nem tudo virou magia. Emulação sempre tem casca de banana.

`Flycast`, por exemplo, me fez perder tempo com uma armadilha particularmente irritante. O arquivo `emu.cfg` usa chaves `rend.*` dentro da seção `[config]`. Se você cria uma seção `[rend]` separada, parece certo, mas o emulador simplesmente ignora e depois reescreve tudo com default medíocre. A correção ficou documentada em [`docs/flycast-resolution.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/flycast-resolution.md) e acabou virando wrapper:

```bash
$DG_BOX_HOME/bin/flycast-hires \
  -config config:pvr.rend=4 \
  -config config:rend.Resolution=2880 \
  -config config:rend.EmulateFramebuffer=no \
  -config config:rend.WideScreen=yes
```

Esse tipo de detalhe é exatamente o tipo de coisa que eu detesto ter que redescobrir sozinho a cada rebuild.

`shadPS4` ainda está longe de ser um caso encerrado. O setup atual é focado em `Driveclub`, com config espelhada, patch XML e links dos `sys_modules` do firmware 11.00. E isso não foi por acaso: eu gosto muito de `Driveclub`. Aliás, é praticamente o único jogo ainda preso no PS4 que eu realmente queria conseguir rodar direito. Eu já vi vários vídeos no YouTube mostrando o jogo funcionando, mas até agora eu mesmo não consegui fazer isso rodar de forma satisfatória no Linux. Isso também está documentado em [`docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md). A parte boa é que agora eu não dependo mais de memória muscular pra lembrar como lançar, com qual patch, em que pasta, com quais módulos. A parte ruim é que emulação de PS4 ainda é emulação de PS4. Não existe script que faça upstream amadurecer mais rápido. Se alguém souber como fechar essa configuração no Linux, olhe o projeto no GitHub e mande um PR.

Também teve uma porção de ajuste fino pra minha máquina: Vulkan em tudo que faz sentido, internal resolution agressiva onde a RTX 5090 aguenta, filtro anisotrópico, widescreen hack onde não degrada a imagem, shader compilation menos sofrível, frame pacing decente no meu monitor 1440p a 120Hz. Em outras palavras: parei de aceitar defaults genéricos e passei a seedar defaults pensados pra minha máquina.

## O ganho real não é só automação

Seria fácil resumir isso como "olha que legal, usei IA pra automatizar shell script". Não é isso.

O ganho real é mais chato e mais importante: eu parei de gastar energia mental com trabalho braçal. Não precisei mais lembrar comando raro. Não precisei manter dezenas de abas com wiki, issue, fórum e README. Não precisei deixar meia dúzia de terminais espalhados dando `tail` em log enquanto tento lembrar que opção escondida de GUI o emulador insiste em regravar no primeiro boot. Eu passei a trabalhar em conversa.

Eu digo pro agente o objetivo. Ele procura os arquivos, lê os logs, encontra o formato certo do config, compara defaults, propõe correções, escreve script, valida paths, verifica UID/GID, confere symlink quebrado, gera wrapper, exporta launcher. Eu continuo responsável pelas decisões, claro. Mas parei de ser digitador de comando raro.

Esse é o ponto que mais me interessa no uso de coding agents em Linux. Eles reduzem dramaticamente a fricção de entrada. Muita gente desiste do desktop Linux não porque o sistema seja incapaz, mas porque a curva de tuning historicamente foi irritante demais. Ter um assistente capaz de ler docs, cruzar config, propor automação e executar com supervisão muda esse jogo.

## Se você quiser reproduzir

O repo foi publicado pra isso. Você tem duas rotas. Via Ansible (recomendado):

```bash
git clone https://github.com/akitaonrails/distrobox-gaming.git
cd distrobox-gaming/ansible
# edite group_vars/all/main.yml com seus paths, ou crie host_vars/localhost.yml
ansible-playbook site.yml
```

Ou via shell scripts, se preferir não instalar Ansible:

```bash
git clone https://github.com/akitaonrails/distrobox-gaming.git
cd distrobox-gaming
cp config/distrobox-gaming.env.example config/distrobox-gaming.env
./bin/dg all
```

Leia o [`README.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/README.md) e o [`docs/rebuild-runbook.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/rebuild-runbook.md) antes. Eu não distribuo ROM, BIOS, firmware nem chaves. O repo só detecta, linka e configura o que você já tem na sua própria máquina.

## Se você preferir a rota com Claude Code

Minha recomendação é simples:

1. Comece pelo objetivo, não pelo comando. "Quero um distrobox Arch com GPU NVIDIA, home separado, ROMs read-only e Steam rw" é melhor do que despejar meia linha de shell sem contexto.
2. Peça sempre pra documentar o que está fazendo. Se der certo, promova o resultado a script. Se não documentar, você acabou de fabricar uma gambiarra descartável.
3. Trabalhe em fases. Criação da box. Bootstrap. Config de emuladores. Export de launchers. Verificação. Foi exatamente assim que eu quebrei o problema.
4. Peça verificações objetivas. `command -v`, existência de arquivos, symlinks quebrados, UID/GID, path de ROM, áudio, GPU. A melhor automação é a que falha cedo.
5. Não use agente como papagaio de comando. Use como assistente técnico. Você continua revisando as decisões e mandando ajustar o rumo.

Pra mim, esse foi o ganho. Eu saí do zero pra uma máquina de emulação muito mais completa sem precisar customizar tudo na unha, em GUI, uma janela por vez. E, dessa vez, terminei com energia pra fazer o que eu queria desde o começo.

Jogar.
