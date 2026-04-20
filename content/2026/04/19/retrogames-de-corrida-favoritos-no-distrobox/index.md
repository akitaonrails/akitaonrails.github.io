---
title: "Meus Retrogames de Corrida Favoritos Rodando no Meu Distrobox"
date: '2026-04-19T20:00:00-03:00'
draft: false
translationKey: retrogames-de-corrida-favoritos-no-distrobox
tags:
  - gaming
  - emulation
  - linux
  - distrobox
  - racing
  - gran-turismo
  - forza
---

Eu passei o domingo inteiro nisso, e foi um dos domingos mais produtivos que eu tive em tempos. A missão foi específica: fechar os jogos de corrida simcade mais difíceis de emular, que eu quero rodar há anos, e só agora consegui chegar num estado confiável.

No topo dessa lista estão dois monstros. Primeiro, **[Driveclub](#driveclub-o-impossível-finalmente-possível)** no shadPS4. É exclusivo de PS4, nunca foi portado, a Evolution Studios foi fechada, não tem remaster. Pra jogar fora do PS4 original, só via emulação, e emulação de PS4 ainda é a parte mais imatura da ecossistema hoje. Esse é **de longe o mais difícil da lista**.

![shadPS4 Qt Launcher mostrando DRIVECLUB CUSA00003 pronto pra rodar](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/19/distrobox-gaming/shadps4-launcher.png)

Segundo, **[Forza Motorsport 4 com Project Forza Plus](#forza-motorsport-4-o-goat)** no Xenia Canary. FM4 é o GOAT da era Xbox 360, Project Forza Plus é a mod comunitária que consolida patches e conteúdo, e fazer os dois rodarem juntos no Xenia com gráfico decente, sem crash de áudio e sem shadow bug, levou horas sérias de trial and error.

![Xenia Manager com a coleção Forza do Xbox 360 instalada](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/19/distrobox-gaming/xenia-manager.png)

Em torno desses dois eu organizei o resto do que eu já sabia que funcionava em algum nível, só faltava consolidar num setup repetível: **[Gran Turismo 4 com Retexture 3.0 e HD HUD](#gran-turismo-4)**, **[Gran Turismo 3 com HD textures e widescreen](#gran-turismo-3-a-spec)**, **[Gran Turismo 2 na mod Spec II](#gran-turismo-2-spec-ii-mod)**, os Gran Turismos de PS3 ([GT5](#gran-turismo-5) e [GT6](#gran-turismo-6)), os Forza Horizon [1](#forza-horizon-1-com-xe-mod) e [2](#forza-horizon-2), os [PGRs](#project-gotham-racing-3-e-4), [Ridge Racer](#ridge-racer-v), [Enthusia](#enthusia-professional-racing), [Colin McRae](#colin-mcrae-rally-1-e-2). Esses eu tinha ideia de como fazer, só precisava consolidar num setup que não volta a quebrar na próxima vez que eu reinstalar o sistema.

Antes de entrar no detalhe, preciso esclarecer duas coisas.

Primeiro, sobre a infra: não vou repetir aqui o como o setup foi montado. Já escrevi isso em detalhe no artigo [Distrobox de Emulação com Claude Code](/2026/04/11/distrobox-de-emulacao-com-claude-code/). Arch Linux num distrobox com `--nvidia`, 17 roles Ansible, todos os emuladores no AUR, ES-DE como frontend, configs per-game automatizadas, scripts Python pra PS3 update check e Xbox 360 title updates, Xenia via Wine. Lê lá. O repo tá em [akitaonrails/distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming) pra quem quiser reproduzir. Aqui eu vou falar dos jogos.

Segundo, sobre o gosto: eu gosto de simcade de corrida. Gran Turismo é meu vício declarado desde o PS1, e escrevi sobre o resto no artigo do [meu cockpit Formula FX1](/2026/04/01/meu-cockpit-de-sim-racing-formula-fx1/). Volante direct drive, pedal com load cell, triple monitor quando tô afim de sofrer. Esse é o tipo de corrida que eu gosto.

## O aviso pra quem já tá de dedo no teclado

Sim, eu conheço iRacing e os outros sims e simcades atuais. Eu tenho 12 TB de ISO e ROM no NAS, provavelmente tenho algum que você ia lembrar de citar. Não é por falta de opção que eu tô focando em emulação hoje.

Aliás, dos jogos novos que eu realmente tô esperando: **[Forza Horizon 6](https://forza.net/) em Tóquio**, **[Assetto Corsa EVO](https://www.assettocorsa.it/)** e **[Assetto Corsa Rally](https://www.assettocorsa.it/)**. Tô jogando as demos dos dois Assetto Corsa e gostando muito das campanhas single-player. Quando eles saírem em versão final, vão virar meus jogos principais de sim na rotina. Esse artigo aqui cobre um lado diferente da coleção, que é tirar do esquecimento os clássicos que ainda não têm remaster.

Hoje, aqui, eu estou interessado nesses jogos específicos que listei acima. Ponto. Você faz o que você quer, eu faço o que eu quero. Se você quer iRacing, abra um Steam e vá em paz. Esse artigo é sobre mexer com emulador, preservar jogo velho, e tirar essas pérolas do esquecimento num setup Linux. Quem tá procurando review de sim atual não vai encontrar aqui.

Agora vamos ao que interessa.

**Observação sobre os vídeos:** a maioria tá sem áudio porque eu esqueci de ligar a captura de som no OBS antes de gravar e fiquei com preguiça de re-gravar. O áudio funciona perfeito em todos os emuladores aqui, é falha minha no OBS, não do setup.

## Settings globais por emulador

Antes dos jogos, vale consolidar as configs globais que valem pra tudo em cada emulador. Isso tá automatizado no repo, mas se você tá configurando na mão, aqui tá o resumo.

### DuckStation (PS1)

- **Renderer:** Vulkan
- **Internal Resolution Scale:** 8x (8K render, downscalado pro monitor)
- **Texture Filtering:** JINC2 (preserva pixel art mas suaviza)
- **PGXP:** ligado (corrige wobble de vértice típico do PS1)
- **Widescreen Hack:** ligado como fallback, mas preferência por cheat widescreen per-game
- **Aspect Ratio:** 16:9 com widescreen cheat, 4:3 sem

PS1 hoje em dia sobe liso no DuckStation. É o emulador mais maduro da lista. A atenção vai pras escolhas per-game (alguns jogos precisam de cheat específico de widescreen).

### PCSX2 (PS2)

- **Renderer:** Vulkan
- **Upscale:** 4x SSAA (1440p nativo → 4K interno)
- **Anisotropic Filtering:** 16x
- **Post Processing:** FXAA ligado, PCRTC antiblur ligado
- **Deinterlacing:** Automatic (alguns jogos precisam override)
- **Controller:** bindings Xbox-style (eu uso controle 8BitDo)

PCSX2 2.7.x é muito superior ao 2.6.3 que ainda tá no repo oficial do Arch. O AUR `pcsx2-latest-bin` tracka o 2.7.x e é onde mora o texture replacement, FXAA moderno e PCRTC antiblur. Se você tá em distro diferente e tá no 2.6.3, procure o AppImage oficial.

### RPCS3 (PS3)

- **Renderer:** Vulkan
- **Resolution Scale:** 300% (geralmente) ou nativo (jogos com issue de upscale)
- **Shader Precision:** Ultra
- **Force High Precision Z:** ligado
- **SPU XFloat:** Accurate
- **Multithreaded RSX:** ligado
- **Write Color Buffers (WCB) / Read Color Buffers (RCB):** desligados por padrão (GT-series safety)

RPCS3 é onde mais tem armadilha. Cada jogo tem preset recomendado na [DB de compatibilidade oficial](https://rpcs3.net/compatibility). E atenção: configs per-game ficam em `~/.config/rpcs3/custom_configs/config_<SERIAL>.yml`. Prefixo `config_` obrigatório. Perdi tempo até descobrir isso, o RPCS3 aceita o YAML silenciosamente e depois ignora se o nome tá errado.

### Xenia Canary (Xbox 360)

- **Build:** Canary (o `master` tá parado há meses, Canary é o que anda)
- **Renderer:** Vulkan
- **Render Target Path:** `rtv` por default, `fsi` pra jogos específicos (PGR4)
- **User Profile:** criado uma vez, persiste
- **Wine Prefix:** dedicado, gerenciado pelo Xenia Manager

Xenia no Linux roda via Wine, gerenciado pelo [Xenia Manager](https://github.com/xenia-manager/xenia-manager). Não tem build nativo decente. Funciona bem, mas cada jogo pede ajuste específico, e Title Updates tem que ser puxado manualmente do archive.org (escrevi um script pra isso, detalhes no artigo anterior).

### shadPS4 (PS4)

Esse merece a seção dedicada no final. Resumindo: funciona pra alguns jogos simples, pra Driveclub ainda não é confiável. Continua sendo um tiro no escuro.

## PS1 no DuckStation

### Gran Turismo (o primeiro, de 1997)

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/gran%20turismo%201.mp4" >}}

Esse aqui é puro sentimento. GT1 foi um dos primeiros jogos que eu comprei pro PS1, e joguei até rachar o CD. Na época, era outro patamar. Simulação real numa máquina de 128K de RAM de vídeo, física decente, 140 carros quando todo mundo tinha 15, trilha sonora memorável.

Mas sejamos honestos: não dá pra voltar hoje. A física do GT1 tem drift exagerado, o carro desliza mais do que deveria em qualquer curva acima de 80 km/h. É parte do charme de 1997 mas irrita em 2026. O **modelo de controle foi muito refinado a partir do GT2**, e tudo que veio depois só melhorou. Entre GT1 e GT2, GT2 vence em conteúdo (650+ carros vs 140) e principalmente em dirigibilidade.

Eu deixo o GT1 no ES-DE pra abrir em momentos de nostalgia, jogar uns 10 minutos em Trial Mountain e fechar. Pra gameplay sério da era PS1, vai de GT2.

### Gran Turismo 2 (Spec II Mod)

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/gran%20turismo%202.mp4" >}}

O Gran Turismo original do PS1 é um marco histórico. Eu joguei muito na época. Hoje, pra jogar de novo? Não. GT2 existe, e GT2 é superior em tudo. Mais carros (650+), mais pistas, mais modos, e principalmente, **um modelo de controle muito melhor**. O GT1 tem aquele drift exagerado onde o carro desliza mais do que deveria, o GT2 ajustou isso pra algo mais próximo do que a série seria a partir do PS2. Entre jogar GT1 ou GT2, sempre GT2.

E o GT2 que eu rodo hoje é o **GT2 Spec II Mod** do [Project A-Spec](https://x.com/projectaspec?lang=en), um projeto comunitário que consolida as duas variantes regionais (Arcade + Simulation) num único jogo, traz de volta eventos que foram cortados no release final, corrige bugs de física, adiciona suporte a widescreen nativo e dá quality-of-life updates em menus. É o jeito definitivo de jogar GT2 em 2026. O projeto não mantém mais site próprio, as atualizações vêm pelo Twitter do autor.

Pra rodar:

| Config | Valor |
|---|---|
| Disco | GT2 Spec II Mod (patch aplicado sobre ISO Simulation USA) |
| Serial | SCUS-94455 |
| Widescreen cheat | Ligado |
| 8 MB RAM cheat | Ligado (corrige áudio em pistas cheias) |
| Texture Filter | JINC2 |
| Resolution Scale | 8x |

O cheat de 8 MB RAM é importante pra pistas cheias (tipo Seattle em corridas populated) onde o áudio começa a estourar. Ele simula a expansão de memória da versão japonesa que nunca veio pro Ocidente.

### Colin McRae Rally 1 e 2

Jogos icônicos do PS1. CMR1 tem aquela sensação áspera de rally primeiro-gen que tem seu charme. CMR2 é tecnicamente superior, física melhor, mais rallys, melhor grafia. Mas eu vou ser honesto: **pra jogar CMR2 hoje, vale procurar a versão PC original**. Resolução maior, 60fps nativo (a versão PS1 trava em 30), controle direto de teclado/volante. Existem repacks do Codemasters na internet, tem umas 40 segundos num search decente. Não vou linkar, você sabe onde procurar.

No PS1 via DuckStation eles rodam liso, nostalgia garantida, mas não é onde eu passo o tempo.

## PS2 no PCSX2

### Gran Turismo 3 A-Spec

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/gran%20turismo%203.mp4" >}}

GT3 foi um salto geracional. Saiu do mundo quadradinho do PS1 pra um mundo de shaders, environment mapping decente, modelos de carro com polígono sério, física que finalmente começou a parecer com física de verdade. A trilha sonora com Feeder de "Just a Day" abrindo o jogo ainda me dá arrepio.

O problema é que GT3 tem MENOS conteúdo que GT2. Polyphony foi mais cautelosa, cortou modos pra focar em qualidade. Licença A/B/S é menor, carros são menos, pistas são fewer. Mas o que tem é polido.

Em 2026 no PCSX2 2.7.x, GT3 fica muito bom. HD textures de comunidade, widescreen pnach, anti-aliasing via SSAA, 16x AF. Parece jogo relançado.

| Config | Valor |
|---|---|
| Disco | GT3 A-spec (SCUS-97102) ou Bundle (PBPX-95503) |
| Widescreen pnach | Ligado |
| Pack de retextura | Opcional (desativado por default, ativar se quiser ver tudo HD) |
| Upscale | 4x SSAA |
| Deinterlacing | Automatic |

Caveat sobre o pack de retextura: quando ligado, tem cenas de mostruário de carro no garage onde o NFS stream causa um flicker momentâneo. Não incomoda em corrida. Se te irrita no menu, desliga.

**Lembrete:** pro widescreen pnach fazer efeito você ainda precisa entrar nas opções **dentro do jogo** e mudar o aspect ratio pra 16:9. O pnach libera a opção no menu, não aplica automaticamente.

### Gran Turismo 4 (Spec II Mod)

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/gran%20turismo%204.mp4" >}}

GT4 é o meu GOAT da série. 700+ carros, 50+ circuitos, física ainda respeitável pra padrão 2026, e aquela trilha sonora que mistura rock alternativo, lounge japonês, e o infame "Sail Away" do Moby no menu principal. Foi o jogo que mais mexi em 2004, e é o que eu mais mexo hoje.

Igual o GT2, o GT4 que eu rodo hoje **não é o disco original**. É o [**Gran Turismo 4: Spec II**](https://www.theadmiester.co.uk/specii/) mantido pelo TheAdmiester — uma mod comunitária massiva que é objetivamente o melhor jeito de jogar GT4 em 2026. Ela combina o disco final USA, a Beta prototype de 2003 e o release japonês original num único jogo, restaurando carros cortados (incluindo vários que nunca saíram fora do Japão), eventos cancelados, dezenas de faixas de trilha sonora faltantes, suporte a widescreen 16:9, mais de 30 cheats integrados como opções de menu (pro tuning, velocidade máxima, economia de combustível), opção de trocar entre idiomas Inglês/Japonês, e correções de bugs originais. O projeto é ativo, ainda recebe patches e tem instalador próprio que aplica sobre uma ISO USA limpa.

Na prática, Spec II é o que o GT4 deveria ter sido se a Polyphony tivesse tido mais seis meses pra polir. Quando você joga hoje, é GT4 com todo o conteúdo que ficou de fora + quality-of-life moderno. Pra qualquer um que gostou do original, é obrigatório.

Por cima disso vai o **Retexture 3.0** da comunidade (pack de textura HD) e o **HD HUD** do [Silentwarior112](https://github.com/Silentwarior112/GT4-HD-HUD-Pack). Com essas três peças juntas (Spec II Mod + Retexture + HD HUD), GT4 roda a 1440p SSAA no PCSX2 2.7.x com 16x AF, FXAA, e uma cara que honestamente é indistinguível de um jogo novo em low-poly style. É o meu atual favorito pra sentar e jogar longo.

| Config | Valor |
|---|---|
| Disco | GT4 USA (SCUS-97328) ou Spec II (SCUS-97436, CRC `4CE521F2`) |
| HD HUD pack | Instalado via symlink (Silentwarior112) |
| Retexture 3.0 | Instalado |
| Widescreen pnach | Ligado (renomeado pro CRC do Spec II se for Spec II) |
| Silent's trigger/camera patches | Ligado |
| Deinterlace (Spec II) | Mode 8 Adaptive TFF |
| ShadeBoost (Spec II) | Saturation +10, Brightness +3, Contrast +2 |
| FXAA + PCRTC antiblur | Ligado global |
| Upscale | 4x SSAA |

Quem tá usando o Spec II Mod precisa atentar pro CRC: os HD packs do GT4 vanilla foram feitos pro `77E61C8A` (USA), então no Spec II com CRC `4CE521F2` eu linko os assets via symlink na pasta CRC-suffixed que o PCSX2 procura. O pnach de widescreen também foi renomeado pra bater com o CRC do Spec II. Sem esse cuidado, o jogo roda mas os mods não carregam.

**Lembretes in-game:** igual ao GT3, o widescreen pnach só libera a opção, você ainda precisa entrar em Options dentro do jogo e trocar pra 16:9. E importante: **mude o modo de vídeo pra progressive 480p** (também em Options). O default é interlaced 480i, que fica péssimo em tela moderna. O Spec II Mod tem suporte nativo a progressive, é só ligar.

Se eu pudesse recomendar um único GT da série pra alguém começar hoje, seria esse. Se você gosta de corrida e nunca jogou GT4 full, tá perdendo.

### Enthusia Professional Racing

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/enthusia.mp4" >}}

Enthusia é o jogo esquecido da Konami de 2005. Saiu na sombra do GT4 e morreu no balcão. É uma pena, porque a **física do Enthusia era mais realista que a do GT4**. Peso do carro, transferência de massa, comportamento em limite, tudo mais próximo do comportamento real. A comunidade sim-racing dos anos 2000 sabia disso e o jogo tem culto hoje.

O problema do Enthusia era o sistema de Enthusia Points: você ganhava pontos por andar limpo, perdia por bater, e a progressão do jogo dependia desses pontos. Muita gente achou punitivo. Eu achei perfeito. Forçava você a dirigir com cabeça.

Em PCSX2 com retexture e widescreen, o jogo fica muito bom. Recomendação forte pra quem quer algo diferente dos Gran Turismo.

| Config | Valor |
|---|---|
| Disco | Enthusia Professional Racing (SLUS-20967) |
| Widescreen pnach | Ligado |
| Retexture | Ligado |
| Upscale | 4x SSAA |

### Ridge Racer V

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/ridge%20racer%20v.mp4" >}}

Ridge Racer é sua própria coisa. Não é simcade, é arcade puro. Drift tudo, colinha dinâmica, trilha sonora eletrônica, cores saturadas. Ridge Racer V foi o jogo de lançamento do PS2 no Japão e por isso tem aquele cheiro de "mostra o que o console pode fazer", com cenários colossais e sensação de velocidade que GT nunca tentou.

No PCSX2 ele roda bem, com uma caveira: textura de carro às vezes flicka em hardware renderer (issues [#3639](https://github.com/PCSX2/pcsx2/issues/3639) e [#13729](https://github.com/PCSX2/pcsx2/issues/13729) do PCSX2). Software renderer resolve mas mata performance. Eu fico no hardware e aceito o flicker ocasional.

| Config | Valor |
|---|---|
| Disco | Ridge Racer V (SLUS-20002) |
| Widescreen pnach | Ligado |
| No-interlace pnach | Ligado |
| Upscale | 4x SSAA |

### Colin McRae Rally 3, 4, 5 (PS2)

Versões de PS2 dos Colin McRae rodam bem no PCSX2 com configs default. CMR3 e CMR04 são bons. CMR05 (o último antes do rebrand pra Dirt) é o melhor dos três tecnicamente. Mas de novo: **se você tá em PC, procura a versão nativa**. Os ports de PS2 eram relativamente inferiores aos PC da época, rodavam em resolução menor, e o PC moderno com repack vai dar 144Hz fácil.

Fica o registro no PCSX2 pra completude da coleção.

## PS3 no RPCS3

### Gran Turismo 5

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/gran%20turismo%205.mp4" >}}

GT5 é controverso. Polyphony prometeu mundos e entregou um jogo meio fragmentado: modelos Premium lindos ao lado de Standard que eram basicamente carros do GT4 em HD, sistema de níveis que alguns amaram e outros detestaram, online que foi pra lama quando o serviço PSN desligou, modo Top Gear que era estranho. A crítica na época foi mista, e eu lembro de comunidades inteiras brigando sobre se o jogo era decepção ou genial.

Pra mim, é genial. GT5 tem o Course Maker (edita tua própria pista baseada em seções reais), o Nurburgring 24h real com chuva dinâmica, o Moon Rover (sim, modo de dirigir na Lua), Red Bull X-Challenge com Vettel, e a experiência de endurance single-player é ridiculamente grande. Quem entrou no jogo a fundo sabe que tem conteúdo pra ano inteiro.

No RPCS3 em 2026, GT5 roda **muito bem**. Estável, sem os bugs graves de anos passados. É o GT mais estável que eu tenho emulado hoje.

| Config | Valor |
|---|---|
| Serial | BCUS98114 (US) ou BCES00569 (EU) |
| Resolution Scale | 300% |
| Shader Precision | Ultra |
| Force High Precision Z | Ligado |
| SPU XFloat | Accurate |
| Multithreaded RSX | Ligado |
| WCB / RCB | Desligados |

A combinação Shader Precision Ultra + Force High Precision Z mata o dithering típico do RSX que fazia GT5 parecer granulado em RPCS3 antigamente. Sem esses dois, o asfalto parece ter ruído constante. Com eles, o jogo fica limpo.

### Gran Turismo 6

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/gran%20turismo%206.mp4" >}}

GT6 é um dos meus preferidos da série. Saiu em 2013 pra um PS3 no final de vida, enquanto a concorrência já olhava pra PS4. Vendeu mal. Muita gente não jogou. E é uma pena, porque GT6 pegou a base do GT5, cortou a gordura (Standards foram reduzidos), adicionou mais Premiums, sessões em circuito no Moon melhores, meteorologia dinâmica em mais pistas, refinamento de física. É basicamente o GT5 polido.

Em conteúdo, GT6 é comparável ao GT4. Muitos jogadores da velha guarda botam o GT4 acima por causa do charme da era PS2. Eu fico entre os dois e vou mais pro GT6 em dia normal, GT4 em dia nostálgico.

Em RPCS3, GT6 tem uma pegadinha grave: **patches 1.06 em diante regridem visualmente**. Superfícies pretas em carros no menu garagem, flicker em cockpit view, tela inteira piscando em certas pistas. A versão que funciona bem em 2026 é **travada em v1.05**. O script [`extract_ps3_dlc.py`](https://github.com/akitaonrails/distrobox-gaming/blob/master/scripts/extract_ps3_dlc.py) do repo tem um ceiling por título específico pra pinar GT6 em 1.05 mesmo quando o PSN cuspa 1.22 como "mais recente".

Além disso, Force CPU Blit é mandatório. Sem ele, tem flicker de tela inteira em menu. O trade-off é que o retrovisor fica permanentemente preto. Eu prefiro perder o retrovisor a ter o flicker. Quem quer retrovisor pode ligar Write Color Buffers, mas aí a resolução cai pra 720p nativo.

| Config | Valor |
|---|---|
| Serial | BCES01893 + variantes regionais |
| Versão travada | v1.05 (patches 1.06+ causam black surfaces) |
| Resolution Scale | 300% (menus) ou 200% (gameplay pesada) |
| Force CPU Blit | Ligado (mandatório, mata flicker) |
| WCB | Desligado (trade-off: retrovisor preto) |
| Shader Precision | Ultra |

Em 2026, com essas configs, GT6 tá no meu rodízio. Não é perfeito, mas é jogável o suficiente pra eu passar uma tarde fazendo endurance.

### Ridge Racer 7

Ridge Racer 7 foi lançamento do PS3 em 2006 e é o último mainline da franquia. Arcade igual Ridge Racer V, drift-first, trilha sonora eletrônica, câmera cinemática. Pra PS3 da época era uma demo tecnológica bonita.

No RPCS3 ele roda, mas com caveats: requer Write Color Buffers ligado pra não ter problemas de iluminação, e o preset recomendado na compat DB é diferente do meu preset GT. Eu uso config per-game dedicada pra ele. Não é meu favorito, mas tá lá pra completude.

Sem vídeo pra esse, gravo depois.

## Xbox 360 no Xenia Canary

Aqui tá a parte que mais me deu dor de cabeça nesse domingo. Xbox 360 no Linux é território hostil. Xenia roda via Wine, cada jogo tem tweaks específicos, title updates tem que vir do archive.org, e Forza Motorsport 4 especificamente tinha problemas sérios até pouco tempo atrás.

### Forza Motorsport 4 (o GOAT)

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/forza%20motorsport%204.mp4" >}}

FM4 é, pra muita gente, o melhor Forza Motorsport já lançado. Polyphony fez Gran Turismo, Turn 10 fez Forza, e FM4 é o pico da era 360. Modelos de carro belíssimos pra época, pistas bem construídas, física sólida sem ser simulador puro, Autovista mode com narração do Jeremy Clarkson, trilha sonora épica, e aquela sensação de Xbox 360 sendo usado no limite.

FM4 no Xenia **era um pesadelo até recentemente**. Shadow com artefato severo, texture pop-in constante no carro, textura de pista chiada e pixelada, céu com brilho completamente errado (ficava branco-estourado em vez do azul profundo original), e o pior: crash de áudio frequente, onde o XMA (codec proprietário do Xbox 360) travava e o som virava ruído agudo até congelar o jogo. Eu passei horas nesse domingo mexendo em config, testando builds, procurando issue no xenia-canary, testando diferentes title updates.

O que destravou:

- **Build Xenia Canary mais recente** (o `master` tá parado, Canary acompanha desenvolvimento ativo)
- **Render Target Path:** `rtv` (o default funciona bem pra FM4)
- **Title Update 1.0.17.0** instalado via Xenia Manager (versão importa, mais velha dá regressão em sombras)
- **GPU Vulkan com ICD NVIDIA forçado** (no meu setup híbrido com AMD iGPU, tinha que forçar a 5090)

Depois disso, FM4 rodou. Não é perfeito. Ainda tem algum crash esporádico de áudio ([xenia-canary issue #161](https://github.com/xenia-canary/xenia-canary/issues/161) aberta). Mas é jogável, e eu passei umas duas horas do domingo no Top Gear Test Track só apreciando o Koenigsegg CCX. Valeu cada hora de debug.

| Config | Valor |
|---|---|
| Build | Xenia Canary recente |
| Render Target Path | `rtv` (default) |
| Title Update | 1.0.17.0 |
| Wine Prefix | dedicado via Xenia Manager |
| GPU | NVIDIA via `VK_ICD_FILENAMES` hardforce |

### Forza Motorsport 3

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/forza%20motorsport%203.mp4" >}}

FM3 é uma das entradas boas da série, entre o charme áspero do FM2 e o pico técnico do FM4. Tentar emular foi surpreendentemente chato, porque eu tava usando a ISO errada.

Existem dois releases do FM3: o **retail** (disco original vendido em loja) e o **Ultimate Edition** (com todas as DLCs empacotadas num segundo disco). Eu tava tentando rodar o Ultimate, que combina dois discos numa ISO híbrida que o Xenia não parseia direito. Troquei pro retail padrão + DLCs instaladas separadamente via Title Update, e bingo, o jogo rodou na primeira.

Moral: se teu FM3 não tá rodando no Xenia, verifica se é retail. Ultimate dá problema.

| Config | Valor |
|---|---|
| Versão | Retail (NÃO Ultimate Edition) |
| Build | Xenia Canary recente |
| Render Target Path | `rtv` |
| DLCs | Instaladas via Xenia Manager separadamente |

### Forza Motorsport 2

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/forza%20motorsport%202.mp4" >}}

FM2 é da era 2007, primeira-gen do 360. Sistemas menos refinados, modelagem mais básica, mas aquele charme de Forza original que alguns preferem à sofisticação do FM4. No Xenia rodou praticamente out-of-the-box. Nenhum tweak especial.

| Config | Valor |
|---|---|
| Build | Xenia Canary |
| Render Target Path | default |

### Forza Horizon 2

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/forza%20horizon%202.mp4" >}}

FH2 foi o Forza Horizon mais polido da geração 360 (existe também a versão Xbox One, que é melhor tecnicamente, mas o 360 tem seu charme por causa do mapa menor e da progressão mais focada). Mundo aberto no sul da Europa, trilha sonora icônica, festival Horizon no seu pico.

No Xenia rodou sem pedir nada extra. Como o FM2.

| Config | Valor |
|---|---|
| Build | Xenia Canary |
| Render Target Path | default |

### Forza Horizon 1 (com XE Mod)

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/forza%20horizon%201%20xe%20mod.mp4" >}}

FH1 original roda OK no Xenia, mas tem uma comunidade que mantém o **Forza Horizon 1 XE Mod**, que melhora IA do tráfego, rebalanceia progressão, adiciona carros que ficaram de fora, corrige bugs conhecidos, e traz uns quality-of-life tweaks na UI. Eu testei o XE Mod nesse domingo e vale a pena. O jogo parece mais vivo e progressão mais justa.

Detalhes da instalação do XE Mod estão no site do projeto. Basicamente é patch sobre a ISO original + alguns title updates customizados.

Pra comparação, aqui é o FH1 **sem** o mod, rodando puro:

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/forza%20horizon%201.mp4" >}}

A diferença mais visível é no tráfego e na variedade de situações que aparecem, mas o XE Mod tem muita coisa que você só percebe depois de algumas horas.

| Config | Valor |
|---|---|
| Build | Xenia Canary |
| XE Mod | Aplicado sobre ISO original |
| Title Updates | Version pinada pelo XE Mod |

### Project Gotham Racing 3 e 4

PGR3 foi lançamento do 360 em 2005 e continua lindo hoje. Pistas urbanas (Nova York, Tokyo, Nurburgring, Las Vegas), kudos system, câmera cinemática. PGR4 adicionou clima dinâmico (chuva e neve) e motos (algumas pessoas adoram, eu prefiro fingir que não existe).

PGR3 no Xenia Canary roda razoavelmente bem com configs default. PGR4 precisa de tweak específico: **`render_target_path_vulkan = "fsi"`** no config. Sem isso, algumas pistas quebram com artefato visual severo (barras verdes atravessando a tela em corridas de neve).

E PGR4 no NVIDIA tem um bug conhecido de áudio: decoding XMA gera garbage intermitente (issue aberta no xenia-canary, sem resolução). Não é game-breaking, mas incomoda.

| Jogo | Config relevante |
|---|---|
| PGR3 | Default |
| PGR4 | `render_target_path_vulkan = "fsi"`, aceitar bug de áudio XMA |

### Ridge Racer 6

Ridge Racer 6 foi o Ridge Racer do 360, pula o 7 que ficou em PS3. Arcade puro, igual Ridge Racer V do PS2. No Xenia Canary roda com config default, sem tweak especial. É divertido pra sessão curta. Sem vídeo dele no artigo, mas tá no catálogo rodando.

## PS4 no shadPS4: o estado do emulador

[shadPS4](https://shadps4.net/) **ainda não tem release estável**. O projeto tá em desenvolvimento ativo, main branch muda várias vezes por semana, e "o que funciona hoje" pode regredir num rebase amanhã. Dito isso, **muitos jogos já bootam e rodam bem o suficiente**. Lista da comunidade tá no [compatibility tracker](https://github.com/shadps4-compatibility/shadps4-game-compatibility/issues) e cresce toda semana.

A diferença entre shadPS4 e os outros emuladores desse artigo é o tipo de esforço. PCSX2, RPCS3, Xenia são projetos maduros onde cada jogo tem uma página de wiki razoavelmente atualizada. shadPS4 é o oposto: você lê um guia do Reddit, tenta reproduzir, descobre que o guia usa um fork específico (não o main oficial), ou um commit de dois meses atrás, ou um firmware com `sys_modules` linkados de jeito particular, ou patches XML aplicados numa ordem específica que o autor não documentou. Reproduzir setup de shadPS4 a partir de vídeo YouTube é tentar resolver Rubik's Cube com venda.

Mas isso não significa que você não deve tentar. Significa que você precisa tratar shadPS4 como brincadeira, não como workflow. E se você tiver paciência, dá pra colher resultados impressionantes.

## Driveclub: o impossível, finalmente possível

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/driveclub.mp4" >}}

Driveclub é meu Moby Dick da emulação. É o único jogo de PS4 que eu quero muito rodar. Saiu em 2014 pela Evolution Studios, teve lançamento catastrófico (servers online colapsaram no dia 1), foi patchado durante dois anos até virar um dos melhores jogos de corrida da geração, e foi descontinuado pela Sony quando a Evolution foi fechada em 2016. Não tem port pra PC. Não tem remaster. Não tem sequel. Só existe no PS4.

E hoje, depois de literalmente horas de debug, **está rodando aqui**. Menu principal carrega, intro roda, corridas começam, controle responde, áudio funciona. Não é perfeito (SDR dim porque o jogo foi tonemapado pra HDR TV, fica a 30 FPS nativo, dither ocasional em superfícies brilhantes na NVIDIA), mas é **jogável**. Eu dei pole position em uma corrida enquanto validava o setup pra gravar o vídeo acima.

Chegar até aqui exigiu desarmar várias armadilhas. Vale documentar todas, porque a maioria dos guias online não menciona nenhuma.

### Armadilha 1: o FMOD loop error que não era FMOD

Quando você tenta bootar Driveclub no shadPS4 direto da PKG retail, o log estoura um loop infinito de:

```
/app0/audio/fmodstudio/masterbank.bank failed, file does not exist
```

A primeira reação é investigar FMOD. Tem gente na internet que passou horas mexendo em sceFont, libtbb, sceNgs2, convencidos que era problema de áudio ou lib HLE. **Nada disso é a causa**. O arquivo `masterbank.bank` literalmente não existe no disco, porque ele tá empacotado dentro dos arquivos `gameNNN.dat` num formato de archive customizado da Evolution Studios que o VFS do shadPS4 não sabe ler.

A única ferramenta pública que parse esse formato é o **[DriveClubFS do Nenkai](https://github.com/Nenkai/DriveClubFS)**. É uma app .NET que walk o `game.ndx` (índice) e decomprime os `.dat` em arquivos soltos. Você extrai a PKG com [ShadPKG](https://github.com/shadps4-emu/ShadPKG), depois passa o DriveClubFS por cima, e fica com 5343 arquivos soltos (~25 GB). Aí o shadPS4 consegue ler.

Armadilha dentro da armadilha: o projeto DriveClubFS tá em `net9.0`, e o Arch tem `net8` e `net10`. Precisa retarget o csproj pra `net10.0` antes de buildar. O comando exato tá documentado no [`docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md) do repo.

### Armadilha 2: v1.00 vs v1.28

Driveclub teve patches até 1.28. A intuição é usar a versão mais recente. Errado. **Só a v1.00 funciona** com o DriveClubFS. Quando você tenta mesclar a base v1.00 com o patch v1.28, o DriveClubFS crasha com `EndOfStreamException` no arquivo 12 de 8018. A v1.28 tem um formato de `.dat` que o DriveClubFS (v1.1.0 atual) não processa.

A consequência é aceitar v1.00 como ponto de entrada. Sem patches, sem conteúdo adicional, sem os mapas do Japão, sem VR-sourced tracks que vieram no último update de 2016. É o jogo básico. Em troca, você tem o jogo rodando.

### Armadilha 3: o patch XML de 60fps corrompe o v1.00

Tem um `Driveclub.xml` patch famoso que faz o jogo rodar a 60fps. Os byte offsets dele foram feitos pra v1.28 eboot. Se você aplica no v1.00, ele corrompe código ao vivo, e o jogo crasha logo após boot.

Solução: desabilitar o patch XML (renomear pra `.disabled-for-v1.0`). Você fica a 30 FPS nativo. Isso é aceitar o trade-off. Se aparecer um patch de 60fps compatível com v1.00 no futuro, legal, até lá, 30 FPS é o que tem.

### Armadilha 4: o `fontlib` PR que parecia ser a solução e não era

O crash `0x29` durante boot fez o Claude sugerir que era problema de font HLE. Eu gastei duas a três horas nisso. Fui atrás do [PR #3772](https://github.com/shadps4-emu/shadPS4/pull/3772) que adiciona fontlib, compilei fork do shadPS4 com ele, dump de fontes SST* da PS4 (que requer hardware jailbroken, descobri isso depois), experimento de substituição das fontes com Adobe Source Han Sans renomeadas pros nomes que o shadPS4 espera. Tudo isso ignorado em main: font HLE já tinha sido mergido no main via [PR #2761](https://github.com/shadps4-emu/shadPS4/pull/2761) em novembro de 2025, e o crash `0x29` não era font afinal.

Moral: **usa o main branch stock**. Nada de fork, nada de compilar, nada de PR não mergido. O stock do CI é suficiente.

### Armadilha 5: TOML silenciosamente ignorado

O shadPS4 migrou de TOML pra JSON em config per-game em late 2025. Se você tem um `CUSA00003.toml` antigo na pasta `custom_configs/`, ele é silenciosamente ignorado, sem warning no log. Você pensa que sua config tá ativa, na prática tá rodando tudo default.

Solução: deleta qualquer TOML e usa `CUSA00003.json`. As configs per-game que funcionam pra Driveclub são específicas e detalhadas, documentei todas no [`docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md) do repo.

### Armadilha 6: controle não detectado sem hidapi hints

Qt Launcher do shadPS4 chama um `Shadps4-sdl.AppImage` interno. Sem env vars específicas do SDL hidapi, o controle (no meu caso 8BitDo Ultimate 2) não é detectado, mesmo funcionando em outros emuladores. O fix é wrapar o AppImage num shell que exporta `SDL_JOYSTICK_HIDAPI=1` e variantes específicas por plataforma (PS4, PS5, Xbox), antes de executar o original.

Plugar o controle **antes** de abrir o Qt Launcher também ajuda. Hot-plug funciona durante o jogo, não antes.

### O que finalmente funcionou

Depois de todas essas armadilhas, a receita é:

| Componente | Valor |
|---|---|
| shadPS4 | main branch, commit `90b75ea` ou mais recente, stock AppImage do CI |
| Driveclub | **v1.00 base PKG apenas** (sem patches) |
| Extração | [ShadPKG](https://github.com/shadps4-emu/ShadPKG) → [DriveClubFS](https://github.com/Nenkai/DriveClubFS) (retargetado pra net10.0) |
| Estrutura | loose files, 5343 arquivos, ~25 GB (pode deletar os `.dat` originais depois) |
| Config per-game | JSON em `custom_configs/CUSA00003.json` (não TOML) |
| `readbacks_mode` | 0 (mandatório, [issue #3210](https://github.com/shadps4-emu/shadPS4/issues/3210)) |
| `vblank_frequency` | 60 |
| `gpu_id` | 0 (NVIDIA dGPU hardforced) |
| `Driveclub.xml` patch | **Desabilitado** (não compatível com v1.00) |
| Controle | Wrapper AppImage com `SDL_JOYSTICK_HIDAPI=1` + variantes |
| Qt Launcher | `checkForUpdates=false` pra evitar dialog rate-limit do GitHub |

Tudo isso tá encapsulado no [`docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md) do repo, com o passo a passo exato de extração, config e wrapper.

### Quão jogável tá hoje

Honestamente bom. O vídeo acima é gameplay real, a 30 FPS estáveis, com física respondendo, áudio sincronizado, HUD correto. O que falta:

- **SDR dim:** Driveclub foi tonemapado pra HDR TV de PS4. Sem HDR no monitor + sem ShadeBoost interno no shadPS4, o jogo fica visualmente escuro. Parece com o jogo em noite permanente. vkBasalt tentou ajudar e quebrou a imagem em RTX 5090 / Vulkan 1.4. Hyprland `screen_shader` funciona mas tem seus próprios bugs. **Aceitei o look dim**. É o que aparece nos vídeos da comunidade também.
- **30 FPS:** patch de 60fps não existe pra v1.00. Aceitei.
- **Dither em superfícies brilhantes:** shiny reflections têm padrão dither na NVIDIA. Reportadamente é melhor em AMD. Menor.

**"Achievement Unlocked".** Não é um estado perfeito, mas **o jogo roda**, com som, com controle, com jogabilidade, e eu consigo completar corrida inteira sem crash. Isso é um marco pessoal. Eu passei anos tentando fazer esse jogo rodar no Linux e chegava num ponto onde simplesmente desistia. Agora é parte do meu ES-DE, atalho no desktop, tá lá esperando eu sentar pra jogar.

Se você quer replicar, o repo tá público. Boa sorte. Vai precisar de paciência.

## "Achievement Unlocked"

Eu venho tentando fazer esses jogos funcionarem, em algum nível, desde que cada respectivo emulador saiu de alpha. GT2 eu tô rodando desde ePSXe. GT4 eu mexo desde PCSX2 0.9.6. FM4 eu tentei fazer rodar em Xenia duas vezes em anos anteriores e desisti nas duas. E Driveclub eu olhei pra cara do shadPS4 três vezes antes desse domingo e engoli em seco.

Hoje fechou. Os dois monstros que abriram esse artigo (Driveclub no shadPS4 e FM4 com Project Forza Plus no Xenia) estão rodando, junto com todo o resto da coleção de Gran Turismo, Forza, Ridge Racer, Colin McRae e Enthusia. Tudo num setup único, reproduzível, automatizado. Agora eu faço parte do **grupo bem pequeno de pessoas que conseguiu brute force emular Driveclub no Linux**, e isso sozinho já tornou o domingo inesquecível.

A frustração de anos não era falta de informação. Era o OPOSTO. Informação demais, mal indexada, espalhada em fóruns apagados, vídeos YouTube que ficaram datados, threads Reddit com soluções pra versão do emulador de dois anos atrás que não valem hoje, wiki de projeto desatualizada em metade das páginas, e mods com requisitos MUITO específicos de CRC, versão, patch, path, setting. Cada vez que eu sentava pra fazer um desses jogos rodar direito, eu ficava três horas lendo material conflitante antes de escrever a primeira linha de config. Pior ainda quando o material bom estava enterrado entre diagnósticos errados, tipo o FMOD loop do Driveclub que todo mundo investigava como se fosse problema de áudio quando na real era formato de archive proprietário da Evolution Studios.

O que mudou nesse último ano é que Claude Code consegue ser meu agregador. Eu peço pro Claude ir na issue tracker do Xenia, na wiki do PCSX2, no subreddit do RPCS3, nos PRs do shadPS4, comparar todas as informações com a versão atual do emulador instalada, cruzar com os logs que eu tô vendo, e me devolver a combinação que funciona hoje. Ele lê source code quando precisa, entende por que `Force CPU Blit` muda comportamento no GT6, acha qual title update do FM4 foi o que consertou o shadow bug, descobre que o DriveClubFS precisa de retarget pra .NET 10 antes de compilar. O que antes levava três fins de semana pesquisando agora leva uma tarde de execução assistida.

Esse domingo é o resultado consolidado de todo esse trabalho. [distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming) é a versão desse conhecimento virada código, reprodutível, automatizada. Rodando numa máquina fresca, um `ansible-playbook site.yml` me põe de volta nesse estado em menos de duas horas. Menos de 10 comandos separam "Arch Linux vanilla" de "Driveclub rodando".

Se alguém quiser contribuir, testar em outro hardware, reportar bug ou mandar config que ficou faltando, o repo tá aberto. Quanto mais gente testar em setups diferentes, mais resiliente o projeto fica. Se você melhorar a situação do Driveclub (ShadeBoost interno, DLC funcionando em v1.00, patch de 60fps compatível com v1.00, dump de fontes que não precise hardware jailbroken), manda PR que eu abraço.

Por enquanto, eu vou fazer uma corrida na Islândia no Driveclub. Boa noite de domingo.
