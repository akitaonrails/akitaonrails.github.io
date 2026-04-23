---
title: "Como Driveclub e shadPS4 Quase Derrotaram a IA e a Mim: Como Aprender"
date: '2026-04-23T12:00:00-03:00'
draft: false
translationKey: driveclub-shadps4-ai-how-to-learn
tags:
  - driveclub
  - shadps4
  - emulation
  - ai-agents
  - claude-code
  - learning
  - ps4
---

## Onde a gente tava

Na semana passada [publiquei sobre o meu setup distrobox-gaming](/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/), com mais de dez jogos de corrida retro rodando em Linux, do Gran Turismo 1 no DuckStation ao Forza Motorsport 4 no Xenia. No fim daquele artigo, falei do Driveclub no shadPS4 como o "final boss": o jogo boota, o menu carrega, a corrida começa, o controle responde.

Só que tinha dois problemas que eu mencionei de passagem e tratei como "limitações aceitas":

1. **De dia, a imagem fica um pouco mais escura do que no PS4 de referência.** Nada alarmante, mas perceptível.
2. **De noite, race start no Canadá ou em Munnar ficava pitch black por 10 a 30 segundos** antes de o jogo "se recuperar sozinho" perto de 1:30. Durante esses segundos, só o HUD aparecia. Pista, carro, faróis, tudo preto absoluto.

No artigo anterior eu empurrei a explicação pra "ainda não foi consertado no emulador, vou conviver com isso". Mas por dentro eu não conseguia me aceitar jogando num estado visualmente injogável. Eu queria jogar o Driveclub no melhor que ele podia entregar, e não queria ficar esperando o projeto consertar por mim. Decidi pegar a coisa nas minhas próprias mãos. Um preto absoluto de 30 segundos não é "um pouco mais escuro". É um bug grave, dos que tornam o jogo injogável na prática.

Esse artigo é o que aconteceu entre domingo de noite e quinta-feira de manhã.

## O blackout, ao vivo

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/original-blackout.mp4" >}}

Esse vídeo é o comportamento que eu queria consertar. Race start na Índia (Munnar), corrida noturna. Você vê a pista, os faróis aparecem, os primeiros segundos rodam. Depois, escurece progressivamente. Em uns 15 segundos já tá tudo preto. Fica assim por mais uns 60-90 segundos. Aí o jogo "recalibra" sozinho, e a pista reaparece.

Se você for um jogador, você não quer saber do porquê. Você quer dirigir.

## Por que shadPS4 é difícil de depurar

[shadPS4](https://shadps4.net/) **ainda não tem release estável**. O projeto tá em desenvolvimento ativo. Main branch muda várias vezes por semana, configs migram de TOML pra JSON sem aviso, settings ficam atrás de "Advanced" pra não gerar issue de usuário com hardware incompatível, PRs em aberto disputam abordagens diferentes pra o mesmo problema.

Quem tenta configurar Driveclub hoje encontra:

- Guias de Reddit de setembro/2025 que usam `readbacks = true` (era bool na época) e dizem "pra DriveClub sempre ligar readbacks".
- Guias de novembro/2025 que dizem "desliga readbacks, mata a performance" (porque em 2025-07 readbacks virou enum `Disabled | Relaxed | Precise`, com perfil de performance diferente, e Bloodborne começou a travar com ele ligado).
- Vídeos YouTube de janeiro/2026 com fork customizado que ninguém documentou qual é.
- Thread no shadps4.net com três explicações diferentes pro blackout, todas mutuamente exclusivas.
- Minhas próprias anotações da semana passada no [`distrobox-gaming/docs/driveclub-shadps4.md`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md) dizendo `readbacks_mode: 0`. Que é exatamente o oposto do que eu descobri essa semana.

Ou seja, a informação existe, mas tá espalhada, datada, contraditória, e a maior parte depende de detalhes de versão que mudaram entre a postagem original e hoje. Reproduzir setup via vídeo do YouTube é tentar resolver cubo mágico de olhos vendados.

## Spoiler: a solução é um inteiro

Depois de 31 fases de investigação, 44 commits no meu fork do shadPS4, 15.668 linhas de código instrumental adicionadas e 3 dias de debug quase ininterrupto, a resposta é **uma linha no config por jogo**:

```json
{
  "GPU": {
    "readbacks_mode": 2
  }
}
```

`readbacks_mode: 2` é o modo `Precise`. Explicar o que isso faz exige entender como o Driveclub implementa auto-exposure, e é aqui que a jornada começa. Pra saber POR QUE esse toggle resolve, você precisa entender a cadeia toda.

O resumo do porquê: o **Driveclub faz auto-exposure como um loop de feedback GPU→CPU**.

1. A cena renderiza num HDR target.
2. Um compute shader calcula um histograma de luminância num SSBO.
3. A CPU **lê** esse SSBO no frame seguinte e deriva uma exposição alvo.
4. A CPU escreve essa exposição de volta num UBO de lighting de 1936 bytes (nos slots `[38] [48] [50]`).
5. Os fragment shaders leem esse UBO e multiplicam a luminância da cena por ele.

Sem `readbacks_mode: Precise`, o passo 3 lê zeros obsoletos. A página de memória que o GPU escreveu o histograma nunca é sincronizada pro lado da CPU. O integrator de exposição da CPU conclui "a cena tá escura, abrir diafragma ao máximo" e rampa o valor de saída monotonicamente: `2.59 → 7.84 → 24 → 90 → 179 → 255`. Em 60-90 segundos, a escala satura tão alto que tudo clipa pra zero. É esse o pitch black.

Com `readbacks_mode: Precise` ligado, o emulador marca as páginas que o GPU acabou de escrever como protegidas no nível de kernel (via `mprotect` no Linux). Quando a CPU tenta ler uma dessas páginas pela primeira vez, dispara uma page fault. O emulador intercepta, emite um `vkCmdCopyBuffer` download do buffer do GPU pro staging de host, espera no scheduler, e a CPU enfim vê o dado fresco. O histograma verdadeiro entra no integrator, a exposição converge normalmente, e o race start abre brilhante como deveria.

Por que não é o default? Três motivos documentados. Primeiro, per-page `mprotect` + per-fault GPU stall + compute dispatch + scheduler wait tem custo real: em NVIDIA warm path é tolerável, em AMD derruba pra menos de 12 FPS, [issue aberta](https://github.com/shadps4-emu/shadPS4/issues/3322) a respeito. Segundo, [Bloodborne trava](https://github.com/shadps4-emu/shadPS4/issues/3826) em loading screens com Precise ligado. Terceiro, o maintainer escondeu a opção atrás de "Advanced" no UI justamente pra evitar que usuário de hardware sensível habilite sem saber. O modo existe desde `v0.15.0` (setembro/2025), mas **ninguém tinha publicamente conectado `Precise` + DriveClub + feedback loop de auto-exposure**. O [compat tracker já admite](https://github.com/shadps4-emu/shadPS4/issues/3346) que DriveClub "requires readbacks enabled to function properly", mas não especifica o modo.

No meu setup o custo de performance é irrelevante. Tenho uma RTX 5090 no desktop, hardware de sobra pra bancar o mprotect, o page fault, o copy e o stall por frame. A decisão é trivial: ligo Precise, pago o preço, o jogo roda. Num hardware mais modesto ou numa AMD a conversa é outra, e é exatamente por isso que o setting não é default e fica atrás do "Advanced".

Importante deixar claro uma coisa: essa explicação toda acima, sobre `Precise` vs `Relaxed` vs `Disabled`, feedback loop GPU→CPU, mprotect syscall por página, não é conhecimento que eu tinha domingo à noite. Eu não sabia o que era um buffer readback, não sabia que Driveclub implementava auto-exposure como feedback loop GPU→CPU, não sabia que `readbacks_mode` virou um enum em 2025 com três valores. Pra chegar na resposta certa, precisei aprender cada peça do zero. Não dava pra chutar. Se eu tivesse tentado "ligar readbacks" semana passada sem entender a cadeia, teria pegado o valor errado (Relaxed não basta pra esse feedback loop, explico isso mais pra frente) e desistido achando que "não funciona".

E mais duas coisas precisam estar no lugar pra isso funcionar, que já cobri no [artigo anterior](/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/#driveclub-o-impossível-finalmente-possível):

- **v1.28 patch aplicado** em cima da install base de v1.00 (sem isso, o conteúdo fica locked com "não lançado ainda").
- **Patch XML de 60fps desabilitado** (render rate subiu mas logic tickrate é fixo; com ele ligado, o jogo roda em câmera lenta).

## O resultado

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/canada-fixed.mp4" >}}

Mesma corrida no Canadá, noturna, com `readbacks_mode: 2` ligado. Race start abre brilhante, auto-exposure converge imediatamente, a transição pra noite acontece de forma natural conforme o TOD (time of day) do jogo avança. Sem blackout, sem "recalibração" aos 1:30, sem janela de 30 segundos de preto absoluto. Isso é Driveclub rodando como no PS4.

Agora a pergunta interessante não é "qual o setting". É: **como a gente chegou aqui?**

## Como um junior aprende hoje?

Tem uma pergunta que eu ouço com frequência: "com a IA fazendo tudo, como um junior aprende?"

A premissa dessa pergunta tá errada. **A IA não faz tudo.** A IA faz o que você pede. Ela não descobre por conta própria. Ela não tem iniciativa de domínio. Ela não é capaz de dizer "olha, isso aqui parece um feedback loop quebrado em GPU→CPU readback" se você não souber pelo menos que existe uma coisa chamada readback, e que feedback loops quebrados são uma classe de bug.

Pior ainda: se você for num agente de IA hoje e pedir "conserta essa tela preta no Driveclub no shadPS4", ele vai te entregar uma lista de respostas possíveis baseada em fóruns antigos, com probabilidade alta de te mandar no caminho errado. Ele vai sugerir patch XML de 60fps (errado, causa slow-motion). Vai sugerir tonemap override (errado, o jogo já escreve SDR correto). Vai sugerir vblank_frequency tweak (inútil pro problema real). Vai sugerir gamma manual (trata o sintoma, não a causa).

O caminho pra descobrir é **mergulhar na cadeia**, fase por fase, descartando hipóteses erradas até o terreno ficar suficientemente conhecido pra você reconhecer a resposta certa quando ela aparece.

E é aí que muita gente se confunde comigo. "O Akita já é senior, ele tem 25+ anos de experiência, claro que ele sabe." **Falso.** Profissional senior é alguém que já foi junior em cada tópico que domina. E continua virando junior toda vez que pega um domínio novo. Eu tenho 25 anos de programação web, sistemas distribuídos, Ruby, Erlang, Go. Mas **eu nunca programei pra PS4**. Nunca tinha olhado o codebase do shadPS4. Não conhecia a arquitetura gráfica do PS4. Domingo eu era um absoluto junior nesse domínio.

Junior não é o mesmo que totalmente cru. Em anos anteriores eu já tinha explorado no meu canal a arquitetura low-level de consoles antigos (do 6502 do NES pra cima) e como emuladores funcionam internamente em geral. Os dois vídeos abaixo ajudaram a construir o vocabulário básico de como videogame funciona por dentro, e garantiram que eu não ia tropeçar em conceitos tipo fetch-decode-execute, opcode, interrupt, ou HLE vs LLE.

{{< youtube id="hYJ3dvHjeOE" >}}

{{< youtube id="vUqLLpUJ47s" >}}

Eu também já tinha feito outro vídeo, mais antigo, sobre a evolução de CPUs, GPUs, DirectX e Vulkan, então pelo menos o vocabulário de "pipeline gráfico moderno" e "shading language" não era estranho pra mim.

{{< youtube id="JEp7ozWqIps" >}}

Saber que existe `VkCommandBuffer` é bem diferente de saber onde no shadPS4 um `vkCmdCopyBuffer` de readback dispara. Mas dá uma base. Esse tipo de curiosidade antiga rendeu juros agora.

## O rodízio: Claude Code e Codex

A IA (no meu caso o [Claude Code](https://claude.com/claude-code)) não "sabia" mais que eu. Ela tem o mesmo texto de fórum datado que você achou no Reddit. O que ela fazia bem era **agregar**: ler o código do shadPS4 em paralelo comigo, indexar os comentários, cruzar referências entre phase docs, compilar, rodar probes, parsear logs de 61 MB, comparar binário decompilado com o diff de UBO, jogar luz em cantos do sistema mais rápido do que eu sozinho conseguiria.

Mas a decisão de "continuar investigando" era minha. A perseverança de "não aceita uma mitigação, quer a causa-raiz" era minha. E quando a IA sugeria "honestly, we should just accept the current result and document it" (e ela sugeriu **várias vezes** ao longo dos quatro dias), eu era o que tinha que dizer "não, continuamos".

O ponto central do rodízio: **nenhum LLM sozinho conseguiu fechar esse problema.**

Ao longo dos quatro dias, várias vezes o Claude Code entrou em loop, repetindo as mesmas hipóteses sem rumo novo. Quando isso acontecia, eu trocava pro Codex por algumas horas pra trazer ideias de fora, probes diferentes, releitura do codebase por ângulo novo. Depois voltava pro Claude Code pra integrar o que o Codex tinha levantado. E assim por diante, alternando.

A resolução final aconteceu no Claude Code, mas a jornada trocou de modelo várias vezes. Cada LLM tinha seus viéses e seus pontos cegos. Deixado sozinho, cada um teria desistido antes.

O que rompeu o impasse foi eu continuar trazendo novas ideias pra tentar, forçando o modelo a reavaliar, trocando quando um deles começava a repetir.

Em dois momentos a coisa foi além de "só repetir hipóteses". O Codex literalmente teve um glitch em loop agêntico: começou a repetir a mesma "solução" que tinha acabado de tentar, de novo e de novo, em sequência, sem perceber o que estava fazendo. Foi a primeira vez que eu vi isso acontecer em qualquer agente de IA. Tive que matar a sessão e começar uma nova do zero pra quebrar o ciclo.

Isso diz muito sobre o tamanho de contexto e a duração da sessão. A complexidade e o ritmo dessa investigação foi suficiente pra derrubar os dois LLMs, cada um do seu jeito.

Toda a jornada abaixo está documentada em 33 phase docs no branch [`gamma-debug` do meu fork do shadPS4](https://github.com/akitaonrails/shadPS4/tree/gamma-debug/docs/driveclub-investigation). Cada seção aqui linka pro doc original pra quem quiser o detalhe completo. Aqui eu resumo o essencial: a hipótese que tínhamos, o que tentamos, o que aprendemos de novo, e por que essa fase não fechou o caso.

## Sessão zero: baseline e reprodutibilidade

Toda investigação séria começa antes da Fase 1. A primeira coisa, pra qualquer projeto, é garantir que o **baseline funciona como esperado** e que a situação que você quer pesquisar é **reproduzível toda vez**. Se você não consegue reproduzir o bug por comando, tá caçando fantasma. Cada probe depois vai ser inconclusivo porque o bug "apareceu e sumiu" sem controle. E se o baseline tá quebrado de algum jeito que você nem percebeu, cada experimento mede o problema errado. Sem essas duas garantias, não tem como progredir.

No meu caso, domingo à noite confirmei:

- O jogo boota até a tela de corrida sem crash, usando a config da [`distrobox-gaming`](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md).
- [DriveClubFS](https://github.com/Nenkai/DriveClubFS) extrai v1.28 limpo, 8018 arquivos, ~47 GB.
- MSAA depth resolve aplicado no fork, pistas noturnas renderizam forma em vez de uniforme preto absoluto (isso está coberto no [artigo anterior](/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/)).
- Controle 8BitDo detectado.
- Corrida noturna na Índia 19:30 **reproduz o blackout em 100% das tentativas**, no mesmo padrão temporal: fade progressivo nos primeiros ~15s, pitch black entre ~20s e ~90s, "recalibração" aos 1:30.

Esse baseline é a única base sólida que me permite comparar cada experimento de forma confiável. Sem ele, um probe que "funcionou" pode ser só um cache diferente, não o fix real. Com ele, cada mudança tem um antes e um depois que são mensuráveis.

Fora isso, zero conhecimento específico de:

- Formato de PKG do PS4 (PFS, param.sfo, disc_info, keystone).
- Codebase do shadPS4 (src/core, src/video_core, shader_recompiler, buffer_cache).
- Pipeline gráfico do PS4 (GCN ISA, forward+ lighting, MSAA depth resolve).
- Vulkan além do superficial (descriptor sets, UBO binding, push constants, pipeline cache).
- SPIR-V disassembly e patching.
- PS4 OELF loader, Itanium RTTI, SCE dynamic relocations.
- mprotect-based page-fault tracking pra CPU-GPU synchronization.

## A jornada em fases

Vou organizar as 30+ fases em grupos que fazem sentido como narrativa. Cada fase linka pro doc completo pra quem quiser o detalhe técnico.

> **Nota pra quem não quiser ler todas as 30+ fases:** depois da sequência de fases tem seções de reflexão e metodologia que dá pra ler direto. [A técnica do shotgun](#a-técnica-do-shotgun) explica a metodologia de depuração que usei ao longo da investigação. [O que eu sabia domingo vs quinta](#o-que-eu-sabia-domingo-vs-quinta) resume o que aprendi de fato. [A IA sugeria aceitar. A perseverança humana foi minha](#a-ia-sugeria-aceitar-a-perseverança-humana-foi-minha) discute o papel real da IA nesse processo. [Custo real dessa jornada](#custo-real-dessa-jornada) cataloga o que foi gerado. Se quiser pular direto pro argumento, esses são os atalhos.

### Fase 01: pipeline cache, o warm-up

> [`phase-01-shader-compile-stalls.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-01-shader-compile-stalls.md)

- **Hipótese:** menus rodam a 2-3 fps no primeiro launch, deve ser compilação de pipelines Vulkan acontecendo em tempo real.
- **Ação:** ligar `pipeline_cache_enabled: true` no config global.
- **Conceito novo:** cache de pipelines Vulkan. Quando o emulador traduz um shader GCN do PS4 pra SPIR-V e depois em binário Vulkan específico do driver, ele pode cachear esse binário. Sem cache, recompila cada cold launch (~864 shaders + ~590 pipelines).
- **Resultado:** resolvido. Primeira sessão paga o custo; sessões seguintes leem do disk e sobem imediatas. Fácil. Também foi minha primeira lição sobre o codebase do shadPS4.

### Fase 02: gamma dim, começando pela direção errada

> [`phase-02-gamma-dim-image.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-02-gamma-dim-image.md)

- **Hipótese:** imagem do Driveclub tá dim comparada com referência. Deve ser sRGB encode errado, ou HDR tonemap mal aplicado pelo emulador.
- **Ação:** instrumentei a swapchain pra logar formato; adicionei env var `SHADPS4_PP_*` pra experimentar; montei pipeline de pós-processamento com três knobs (exposure, ACES tonemap, gamma curve).
- **Conceito novo:** sRGB OETF, HDR tonemap (ACES vs Reinhard), Bayer dither como anti-banding.
- **Resultado:** descobri via bypass path (`SHADPS4_PP_BYPASS=1`, escreve raw game output sem nenhum pós-processamento) que o **jogo escreve SDR já correto** no framebuffer. O pipeline de pós-processamento do emulador é que estava estragando o sinal. Shader final virou simplesmente sRGB encode + Bayer dither. Dim persiste, mas não é culpa de gamma.

![Ajustes de gamma errando pra todo lado](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/wrong-gamma.png)

![Blown out: gamma em cima](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/wrong-gamma-blown.png)

![Céu escuro: gamma pra baixo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/wrong-gamma-sky-dark.png)

Três horas nessa fase. A lição mais importante é: **quando "a imagem tá estranha", o primeiro diagnóstico deveria ser um bypass path que mostra o raw game output**. Se bypass tá certo, o emulador tá estragando o sinal. Pare de mexer no tonemap.

### Fase 03: v1.28 content access

> [`phase-03-v128-content-access.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-03-v128-content-access.md)

- **Hipótese:** v1.28 extrai, mas o jogo diz "content not released yet, download required".
- **Ação:** merge v1.28 em cima de v1.00, restaurar `param.sfo`, `disc_info.dat`, `keystone`.
- **Conceito novo:** PS4 cumulative patches, metadata do package.
- **Resultado:** resolvido. Detalhado no [artigo anterior](/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/).

### Fase 04: MSAA depth + slow-motion

> [`phase-04-slowness.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-04-slowness.md)

- **Hipótese:** pistas à noite pitch black e o jogo "parece lento".
- **Ação:** duas coisas separadas. Desabilitar patch XML de 60fps (que tava descolando render rate do logic tickrate). Implementar `ReinterpretMsDepthAsColor` no meu fork (pra permitir que o emulador resolva depth MSAA 4x pra color 1-sample, que o Driveclub precisa pro forward+ lighting nas pistas noturnas).
- **Conceito novo:** forward+ lighting (renderer que escreve cena em MSAA depth target e depois lê como color pra SSAO e volumetrics), MSAA depth resolve.
- **Resultado:** dois problemas resolvidos. Detalhado no [artigo anterior](/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/).

### Fase 05: second pass no brilho

> [`phase-05-brightness-followup.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-05-brightness-followup.md)

- **Hipótese:** já que o game escreve SDR correto, talvez um boost estático no pós-processamento ajude sem mexer em UBO feedback.
- **Ação:** testei linear boost (1.5x, 2.0x), gamma pre-encode (pow curve), auto-exposure cena-aware com peak+mean sampling.
- **Resultado:** tudo rollback. Linear boost clipa luz. Gamma introduz banding. Auto-exposure da minha camada cancela o slider manual do usuário. Não tem almoço grátis no pós-processamento. Imagem dim fica dim sem HDR real ou patch de shader.

![Céu escuro demais](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/wrong-gamma-sky-dark.png)

### Narrowing the blackout: o gate compartilhado

> [`race-start-blackout-040420.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/race-start-blackout-040420.md)

- **Hipótese:** o blackout tem uma assinatura curiosa: main view vai pra dim/preto, retrovisor vai pra preto absoluto, HUD permanece brilhante. Três camadas com comportamentos diferentes sugerem um "gate" compartilhado, não um fade comum.
- **Ação:** instrumentei texture-cache aliasing, probes com live fragment shader substitution nos inputs suspeitos.
- **Conceito novo:** texture-cache aliasing (várias imagens com mesmo endereço de memória, cache do emulador reusa), render-target lifetime.
- **Resultado:** aponta pra "permissão de apresentação" compartilhada entre main scene e retrovisor, não um fade narrativo.

![Baseline do blackout](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/screenshot-2026-04-20_21-22-45.png)

### Fases 07-09: tortura de texturas, cirurgia de UI, plano de binary patch

> [`phase-07-aggressive-torture-probe.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-07-aggressive-torture-probe.md) · [`phase-08-ui-asset-surgery.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-08-ui-asset-surgery.md) · [`phase-09-eboot-binary-patch-plan.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-09-eboot-binary-patch-plan.md)

- **Hipótese:** o overlay dim do race start é um asset. Textura pequena, panel da UI, ou método do controller `FreeplayGetInCar` no eboot.
- **Ação:** null-substituir materiais BC comprimidos, textures pequenas candidatas, four-vector weight masks durante draws críticos. Desabilitar painéis da UI (`loading_freeplay.txt`, `get_in_car_animation.txt`, `vehicle_select_background`). Extrair o OELF, localizar strings ASCII `FreeplayGetInCar`, identificar construtor em VA 0xf89b00 e vtable em 0x15dc3e0.
- **Conceito novo:** PS4 OELF loader (variant do ELF da Sony), Itanium C++ RTTI (como C++ encoda type info em vtables), SCE dynamic relocations (placeholders que só o loader dinâmico resolve em runtime).
- **Resultado:** nulls funcionam mas o fade persiste. O overlay renderiza direto nos HDR scene targets, não via panel system. Binary patch tem placeholder de relocation que não é resolvível estaticamente sem um Ghidra com PS4 plugin. **Asset-side surface exhausted.** Seis horas depurando, final conclusion: o bug vive em state, não em asset.

### Fase 10: rethink + animlib

> [`phase-10a-rethink-040422.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-10a-rethink-040422.md) · [`phase-10b-video-diagnostic-animlib.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-10b-video-diagnostic-animlib.md)

Terça-feira de manhã. Sentei, reiniciei mentalmente. Modelo novo: o blackout é um **state-machine gate**. Não é "cena não pronta", é "permission transition". O gate fecha depois da grid de largada aparecer. Próximo probe: runtime dispatch trace, chega de blind asset surgery.

Em paralelo: extração de frame da gravação de vídeo a 10 Hz, cruzamento com keyframes de animation library (`animlib`) em `india_posteffects.lvl`. Encontramos smoking gun. Track `MasterBrightness` com keyframe 0.003 e 0.0007 (0.63% brightness), quando o default seria 1.0. Animlib vence inline defaults todo frame.

- **Conceito novo:** animation library, keyframe encoding, float-scanning de binário.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/debugging-blackout-fade.mp4" >}}

Vídeo acima: o processo de probar pelo fade em real time.

### Fase 11: multi-scalar patch

> [`phase-11-multi-scalar-patch.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-11-multi-scalar-patch.md)

- **Hipótese:** patchar `MasterBrightness` + `AutoTargetLuminance` + `ManualAutoMix` simultaneamente vai lift o blackout.
- **Ação:** estendi `PatchAnimlibFloatValues` pra reescrever três scalars. Instrumentei com `SHADPS4_DC_DRAWLOG` + `SHADPS4_DC_UBOLOG`.
- **Resultado:** patch produz um lift **numérico** real (1.2 → 6.5 em 255, um 5×), mas ainda é sub-perceptual black. E descobri o achado crucial: o mirror funciona normalmente após o patch. Não está gated, apenas refletindo uma cena escura. **Pelo menos 285× de atenuação adicional vive downstream dos scalars que a gente pode patchar.**

### Fase 12: bisect fechando o asset-side

> [`phase-12-bisect-closes-asset-side.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-12-bisect-closes-asset-side.md)

- **Hipótese:** um dos 60 patches acumulados quebrou o mirror independente do blackout. Bisect.
- **Ação:** binary bisect em 60 overlay files ao longo de 5 rounds.
- **Resultado:** `x_live_lobby_pre_race.txt` (reroute de loading-spinner transition de `ZoomInAndFade` pra `NoFade`) era o mirror killer. Rollback. **Asset-side completamente fechado.** O driver vive em código compilado ou em post-process state, não em asset de jogo.

### Asset sweeps 01-09 (consolidado)

> [`asset-sweep-09-conclusions.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/asset-sweep-09-conclusions.md)

Em paralelo com as fases acima, varri 12 RPK substitutions: page swaps de `FreeplayGetInCar`, mexidas no postfx de `india_landscape_gui.rpk`, edits em `globaldata` RTT-only, rewrites de prerace state strings. **Todos clean misses.** Nenhuma família de asset toca o blackout. Lição: **pare de chasing by names; chase por state transitions.**

### Fase 13: UBO dump breakthrough

> [`phase-13-ubo-dump-breakthrough.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-13-ubo-dump-breakthrough.md)

- **Hipótese:** loop de feedback de eye-adaptation com input stale é o culpado. Um scalar de luminância crescendo sem convergir.
- **Ação:** dump de 128 bytes de UBO em hex durante a race window, em seis pipelines hand-picked. Procurar valores monotonicamente em mudança.
- **Conceito novo:** **UBO (Uniform Buffer Object)**, região de memória compartilhada que o CPU escreve e shaders leem. **Auto-exposure integrator**, componente clássico de eye adaptation que tira tempo pra convergir em direção a um target.
- **Resultado:** encontrei. **Offset 3 do UBO sobe monotonicamente de 2.59 → 7.84 → 24 → 90 → 179 → 255** em 2 segundos. Textbook feedback loop com input quebrado. Primeiro hit real em 12 fases.

### Fase 14: scene-pipeline UBOs são o read-side

> [`phase-14-scene-pipeline-ubos-wrong.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-14-scene-pipeline-ubos-wrong.md)

- **Hipótese:** clampar o scalar que tá subindo vai parar o blackout.
- **Ação:** `SHADPS4_DC_LUM_CLAMP=2.0` força offset 3 a um valor fixo durante race window.
- **Resultado:** clamp dispara 1093 vezes, blackout inalterado. Scene-pipeline UBOs **consomem** o dim, não produzem. Dim tá upstream, em um tonemap ou post-fx compute fullscreen.

### Fases 15-16: runtime texture dump + mutation

> [`phase-15-runtime-texture-dump.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-15-runtime-texture-dump.md) · [`phase-16-runtime-texture-mutation.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-16-runtime-texture-mutation.md)

- **Hipótese:** o blackout é uma textura fullscreen composta sobre a cena.
- **Ação:** `SHADPS4_DC_TEX_DUMP=1` dumpa todas as texturas bound durante race window (1079 texturas capturadas). Converter tiled-format pra PNG pra triagem visual. Depois, mutar deterministicamente cada textura via hash-based tint + `InvalidateMemory` pra forçar re-upload.
- **Conceito novo:** **GCN tile format** (Sony interleava bytes de forma específica pra cache locality), texture de-swizzle, buffer cache invalidation.
- **Resultado:** 14 rounds de mutação (BC textures, float data, render targets, UI atlases, post-fx buffers, LUTs). Blackout **inalterado em todos**. Texture content 100% descartado como source.

![Overlay azul durante mutação](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/blue-ish-overlay.png)

![Overlay verde durante mutação](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/green-ish-overlay.png)

![Reflections glitched](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/reflections-glitching-blown.png)

![Reflections blown white](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/reflections-glitched-blown-white.png)

### Fases 17-19: UBO smashing, push-constant smashing, compute dispatch probe

> [`phase-17-ubo-batch-smashing.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-17-ubo-batch-smashing.md) · [`phase-18-push-constant-smashing.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-18-push-constant-smashing.md) · [`phase-19-compute-dispatch-probe.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-19-compute-dispatch-probe.md)

- **Hipótese:** random-fill em UBOs, push constants e compute input buffers pode bracket and isolate o field do dim sem crashar.
- **Ação:** `SHADPS4_DC_UBO_SMASH=1`, `SHADPS4_DC_PC_SMASH=1`, `SHADPS4_DC_DISPATCH_SMASH=1` com filtros de cb-index e size.
- **Conceito novo:** **push constants** (128 bytes de param rápido que o driver empurra direto pro pipeline, sem descriptor), **compute dispatches** (dispara compute shaders com uma grid de threads), **ud_regs** (user data registers do GCN, como shadPS4 mapeia user-data pra push-constants).
- **Resultado:** brackets seguros geram overlay bokeh + blinks, mas dim inalterado. Brackets wide o suficiente pra pegar o dim também pegam matrices/transforms e crasham. **Random-fill é instrumento errado.** Precisa de diff methodology.

![Tudo bege depois de smash](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/all-bege.png)

![Tudo verde](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/all-green.png)

![Tudo ciano](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/all-cyan.png)

### Fase 19b-c: dim-vs-lift dispatch diff

> [`phase-19b-dim-vs-lift-diff.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-19b-dim-vs-lift-diff.md) · [`phase-19c-dispatch-draw-skip-null.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-19c-dispatch-draw-skip-null.md)

- **Hipótese:** compute dispatches que firam só durante dim (e param depois do lift) fazem parte do chain.
- **Ação:** dividir log limpo em pre / dim / bright windows (via user wall-clock), contar dispatch frequency por pipeline.
- **Resultado:** identificamos **8 compute pipelines** (histogram 256→downsamples, tile-grid reductions, auto-exposure 1x1 scalars) que param exatamente quando dim lifts. Shapes fortemente sugerem eye-adaptation chain. **First genuine diagnostic hit.** Skip test dessas 8 + 101 draws correlacionados: blackout **inalterado**. Elas são **downstream effects**, não drivers.

### Fase 20-21: tonemap inline, fragment → flip buffer

> [`phase-20-shader-dump-tonemap-inline.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-20-shader-dump-tonemap-inline.md) · [`phase-21-fragment-to-flip-buffer.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-21-fragment-to-flip-buffer.md)

- **Hipótese:** o auto-exposure compute shader tá quebrado, ou o tonemap compute tá com a matemática errada.
- **Ação:** recompilar todos os shaders, dumpar SPIR-V, desmontar o histogram auto-exposure. Patchar a saída dele pra constante 1.0 e testar.
- **Conceito novo:** **SPIR-V disassembly** (formato intermediário do Khronos, tem assembly legível). **Verificação de shader compute**. Depois, **pipeline-to-shader mapping**.
- **Resultado:** patch **sem efeito**. Descoberta: **Driveclub não tem tonemap pass separada**. Scene geometry escreve direto no flip buffer, com exposure inline nos material shaders. Cada material shader bake o scalar de dim de um UBO compartilhado. Pipeline cache wipe + `SHADPS4_DC_PIPEMAP=1` dumpa todos os pipeline→shader mappings. Filtrar drawlog por pipelines que escrevem em `0x5000900000` / `0x5000108000` (os swapchain buffers de verdade) resulta em **14 pipelines únicos**. Zero com Exp2/Log2 tonemap ops. Exposure é aplicada upstream.

### Fase 22: tonemap compute identified

> [`phase-22-tonemap-compute-identified.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-22-tonemap-compute-identified.md)

- **Hipótese:** entre os 510 compute shaders do jogo, um deles tem assinatura de tonemap (muitos Exp2/Log2).
- **Ação:** scan automatizado, cross-reference com dispatchlog.
- **Resultado:** **`cs_0x2c918c06`** é o candidato forte, com 8 Exp2 + 8 Log2, 5 SSBOs (scene params, TAA, bloom, camera, exposure), 11 images. Skip test pra esse pipeline específico: **para o blackout cycle**, remove color grading, introduz temporal ghosting. **Esse é o caminho final scene→swapchain pra tonemap.**

![Temporal ghosting depois do skip](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/temporal-glitching.png)

### Fase 22+: tonemap patches → playable

> [`phase-22plus-tonemap-compute-patches.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-22plus-tonemap-compute-patches.md)

- **Hipótese:** dois SPIR-V surgical edits (histogram no-op + tonemap exposure clamp/boost) deixam o jogo jogável.
- **Ação:** patch de histogram pra nunca atualizar; patch de tonemap pra clampar exposure floor em 0.5 e boost blend por ×10. Ambos via SPIR-V patching + shader/patch/ drop-in.
- **Resultado:** **playable!** Dim reduz de pitch black pra mild. É uma **mitigação real, não fix de causa-raiz.** A fade curve ainda arrasta a exposição, e cada pista precisa de tuning per-threshold.

![Luzes da pista explodindo após ×10 boost](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/blown-just-track-lights.png)

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/india-gamma-correction-attempt.mp4" >}}

Aqui a IA sugeriu parar pela primeira vez. **"O jogo tá playable, isso é uma mitigação decente, deveríamos documentar e aceitar."** Eu pressionei: "tá playable mas tá errado. Não aceita. Continuamos."

### Fase 23: CPU-side exposure intercept

> [`phase-23-cpu-exposure-intercept.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-23-cpu-exposure-intercept.md)

- **Hipótese:** clampar o exposure scalar no momento do `BindBuffers` da tonemap compute previne o over-dimming.
- **Ação:** `SHADPS4_DC_EXPOSURE_PIN=1` intercepta `BindBuffers`, sobrescreve exposure offsets com clamp-min threshold, invalidate buffer_cache.
- **Conceito novo:** **CPU-GPU buffer binding** (momento em que o CPU entrega descriptor pro GPU). **Buffer cache invalidation** (como o emulator mantém consistency entre o estado CPU-side e GPU-side de um buffer).
- **Resultado:** scalar oscila no race start, depois sobe monotonicamente. Per-track tuning necessário. A Índia quer 3.0, o Canadá blows out no mesmo threshold. **Solução de scalar único não converge cross-track.**

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/videos/debugging-cli-gamma-correction.mp4" >}}

### Fase 24: dim upstream of tonemap

> [`phase-24-dim-upstream-of-tonemap.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-24-dim-upstream-of-tonemap.md)

- **Conclusão:** depois de toda a cadeia de probes (identity tonemap, exposure pin, compute skip), o dim **está no HDR target antes** do tonemap ler. Três upstream suspects: (1) atmospheric scattering / volumetric fog, (2) reflection-probe / envmap update, (3) pre-tonemap exposure apply.
- **Conceito novo:** **atmospheric scattering** (simulação de como luz viaja pela atmosfera, tipo Rayleigh/Mie), **volumetric fog** (neblina renderizada como froxel volume).
- **Resultado:** plano definido. Frame-order dump, andar pra trás da tonemap pela cadeia toda.

### Fase 25: frame-order trace

> [`phase-25-frameorder-trace.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-25-frameorder-trace.md)

- **Ação:** `SHADPS4_DC_FRAMEORDER=<N>` loga strict per-submit pipeline/shader chain sobre N submits durante race window.
- **Conceito novo:** **frame-order reconstruction** (listar toda submission ao GPU em ordem exata), **froxel volumetrics** (volume frustum voxels, malha 3D alinhada ao frustum da câmera pra armazenar info de luz).
- **Resultado:** três suspeitos: (A) half-res compute `(60,34,1)`, provavelmente SSAO; (B) dispatches progressive `(256,1,1)→(2560,1,1)→(10240,1,1)`, froxel volumetric; (C) draw fullscreen apply-fog-to-HDR. **Suspeito B** é o mais forte (sunset best-fit, per-pixel non-uniform dim).

### Fase 26: O UBO fade pin, o "aha moment"

> [`phase-26-ubo-fade-pin.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-26-ubo-fade-pin.md)

Aqui mudou tudo.

- **Hipótese:** memory diff direto (bright vs dim vs recovered) identifica os bytes exatos que o jogo escreve pra controlar o blackout.
- **Ação:** capturar snapshots periódicos de UBO através das transições visuais. Diffar três snapshots byte por byte. Procurar fade signatures.
- **Conceito novo:** **state diff methodology**. Ao invés de "qual passagem parece suspeita?", perguntar "quais bytes realmente mudam com o estado visual?"
- **Resultado:** **breakthrough.** Dois UBOs controlam o fade: um de 1936 bytes com slots `[38/48/50]` (light intensity) sendo multiplicados por 0.094 (fade factor), e um sun UBO de 224 bytes com slot `[50]` caindo 97%. Pinar os dois: race start abre brilhante. TOD animation intacta. Content-aware three-state lifecycle (idle → engaged → expired).

![Primeiro toque no UBO de sun light](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/touching-sun-light.png)

Quarta-feira à noite. Claude sugere parar de novo. **"Temos pin funcionando, three-state lifecycle robusto, Canadá + Munnar rodando. Isso é upstream-quality, deveríamos PR-ar e fechar."** Eu insisto: "ainda tem dim residual em outras pistas, não tá fechado. Continuamos."

### Fase 28: pivot pra emulator code

> [`phase-28-pivot-to-emulator-code.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-28-pivot-to-emulator-code.md)

- **Realização:** o dim residual no Canadá ao anoitecer não é um valor errado de UBO. É uma **translation gap do emulador**. O jogo roda correto no PS4 real, então shadPS4 tem algum caminho que traduz ou sincroniza errado.
- **Ação:** 5 candidatos de bug emulator ranqueados — HLE shader misidentification, image storage classification, layout transitions, IMAGE_STORE_MIP fallback, OpImageFetch LOD restriction.
- **Conceito novo:** **HLE (High-Level Emulation)**. Substituir funções complexas do sistema operacional do PS4 por implementações host-side. Diferente de LLE (low-level) que emula bit a bit. HLE é mais rápido mas pode divergir do comportamento real quando a implementação host não cobre todos os casos.

![Canadá ao anoitecer ainda dim](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/canada-dim.png)

### Fase 29: calibrated state + recording harness

> [`phase-29-calibrated-state.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-29-calibrated-state.md)

- **Ação:** `SHADPS4_DC_RECORD=1`. Recording harness que dumpa lighting UBOs periodicamente + cross-correlation com screenshots wall-clock.
- **Resultado:** descoberta importante. **Slots `[144..295]` do UBO de 1936 bytes** (30+ fields) ficam **denormal/uninitialized** pelos primeiros ~90 segundos de corrida. Na "auto-recalibração" dos 1:30, o jogo escreve os valores reais. **Não é recovery mágico, é a CPU finalmente escrevendo os valores que já deveriam estar lá desde o frame 1.** No PS4 estão prontos antes do primeiro frame; no shadPS4 atrasam 90s. **Root cause vive num init gap do emulador.**

### Fase 30: UBO writer audit

> [`phase-30-ubo-writer-audit.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-30-ubo-writer-audit.md)

- **Ação:** auditoria exaustiva de todos os caminhos que escrevem no slot `[38]` do UBO de 1936 bytes. 7 suspeitos ranqueados: (1) ObtainBuffer stream-copy race, (2) lazy RegionManager em memory_tracker, (3) histogram compute skip, (4) page-fault delayed invalidation, (5) readback gating, (6) buffer-coherency race, (7) push-constant.
- **Status:** auditoria incompleta. Antes de conseguir verificar cada suspeito, a Fase 31 curto-circuitou tudo.

### Fase 31: readbacks_mode = Precise, a virada

> [`phase-31-readbacks-mode-fix.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-31-readbacks-mode-fix.md)

Quinta-feira de manhã. Cansado, pensando na suspeita **#5, readback gating**. Essa me coçava porque era a única dos 7 writers que tocava *timing* do read e não *correctness* do write.

- **Hipótese:** ligar `readbacks_mode: 2 (Precise)` no config per-game faz o feedback loop funcionar sincronizando read do CPU a fresh GPU output.
- **Ação:** uma edit no `custom_configs/CUSA00003.json`. Boot. Corrida no Canadá à noite.
- **Resultado:** **race start abre brilhante. Auto-exposure converge normalmente. Zero blackout. Zero recalibração aos 1:30. Night TOD natural.**

![Quase lá, o teste antes do final](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/23/driveclub-learning/almost-fixed.png)

Testes em Munnar. Mesmo resultado. Um inteiro. **31 fases. 44 commits. 15.668 linhas. Resposta: um inteiro no config.**

Por que isso passou batido por 30 fases? O doc da Fase 31 tem a análise honesta:

1. **Disfarce de sintoma.** Progressive darkening parece exatamente com tonemap quebrado, shader ruim, ou scalar de exposure compilado errado. Toda probe dump-driven achou **valores errados no UBO**, que é verdade, mas descreve o downstream read, não o upstream gap.
2. **Red herring do `readback_linear_images`.** Testei essa flag na Fase 29 e deu zero efeito, então concluí que "a superfície de readback tá auditada". Esqueci que essa flag é pra *image* readbacks (linear images via `TextureCache::DownloadImageMemory`). O histogram SSBO é um **buffer**, caminho separado.
3. **Pinning piorando em vez de melhorar.** Sobrescrever os slots [38/48/50] parecia prometer, mas nunca convergia. O jogo reescrevia em cima do pin a cada frame. Interpretei como "o mecanismo de pin chega tarde demais no pipeline". Gastei as fases 27-29 movendo o pin pra mais cedo. O fix real era **parar de clobber o GPU-side input que o integrator lê**.
4. **Nunca auditei o caminho do readback de buffer.** A auditoria da Fase 30 listou 7 candidatos de writer, mas todos eram sobre a correctness do *write*. Nenhum perguntou "o que a CPU está lendo, esperando que o GPU tenha preenchido?"

## A técnica do shotgun

Tem uma coisa que eu quero registrar: **os probes de tortura não são desperdício, são infraestrutura de aprendizado.** E a metodologia por trás deles tem nome: shotgun.

{{< youtube id="HkxVhFg81fs" start="40" >}}

Se você tem uma suspeita, tipo "o dim vem de alguma textura", a pior coisa que você pode fazer é começar investigando uma textura por vez, em profundidade. Driveclub tem 1079 texturas bound durante a race window. Se cada triagem detalhada leva 20 minutos, você gasta três dias num galho só dessa árvore, e ainda não sabe se o dim vem de textura. Pode até ser que a resposta não esteja na árvore inteira.

Shotgun resolve isso. Em vez de investigar uma por vez, você dispara em todas ao mesmo tempo. Muta cada textura bound com um tint hash-based, força re-upload, roda o jogo. Em 30 segundos você sabe se alguma delas afeta o dim. Se afeta, então o dim é texture-side e aí sim vale a pena começar a narrow down. Se não afeta, parabéns: você acabou de descartar a categoria "textura" inteira em 30 segundos. Muda de categoria, shotgun em UBOs. Nenhum hit? Shotgun em push constants. Nenhum hit? Shotgun em compute dispatches. Continua até algo reagir.

**Não comece tentando estreitar uma árvore que pode ser enorme.** Você vai gastar semanas em folhas irrelevantes. Dê um tiro de shotgun no tronco primeiro. Veja qual galho reage. Aí sim, desce em detalhe dentro desse galho.

Foi isso que eu fiz, sem saber que estava fazendo, pelas 30 primeiras fases. 32 variáveis de ambiente de probe (`SHADPS4_DC_UBO_SMASH`, `SHADPS4_DC_PC_SMASH`, `SHADPS4_DC_DISPATCH_SMASH`, `SHADPS4_DC_TEX_NUKE_*`, `SHADPS4_DC_UBO_NUKE`, e mais). Batches randômicos, tints hash-based, substituições null. A maioria nunca apontou pro fix real. Mas cada rodada de shotgun descartou uma categoria inteira de modelo mental. "Não é textura." "Não é push-constant." "Não são esses 8 compute pipelines." "Não é UBO write-side em qualquer lugar dessa região." Cada descarte estreita o problema.

**E enquanto eu fazia isso, eu aprendia o sistema.** Cada smash que crashava me dizia "aqui vive um descriptor pointer crítico". Cada color tint que aparecia me dizia "esse UBO alimenta essa passagem de composição". Cada dispatch que fira diferente entre dim/bright me mostrava onde está a fronteira interessante.

**Quando você não conhece o sistema, shotgun probes são um mapa.** Você não usa eles pra encontrar a resposta. Você usa pra descobrir o terreno.

## O que eu sabia domingo vs quinta

**Domingo:** zero em tudo. Todas as áreas abaixo eram caixas pretas pra mim.

**Quinta:**

- PS4 package format end-to-end (PKG → PFS → param.sfo → disc_info → keystone → npbind). Como v1.28 cumulative patches funcionam em cima de v1.00 base install.
- Arquitetura do shadPS4 em resumo: `src/common`, `src/core` (OS emulation, libraries HLE), `src/shader_recompiler` (GCN→SPIR-V), `src/video_core` (Vulkan renderer, buffer cache, texture cache, page manager).
- Pipeline gráfico completo: G-buffer → forward+ lighting (escreve MSAA depth) → read depth como color pra SSAO / volumetric froxel → post-fx compute → tonemap → composite → swapchain.
- UBO vs push constant vs descriptor set. Quando usar cada um.
- SPIR-V disassembly e re-assembly pra patching cirúrgico. Como identificar tonemap compute por assinatura de Exp2/Log2.
- Forward+ lighting + MSAA depth resolve + como implementar ReinterpretMsDepthAsColor.
- Buffer cache do shadPS4: `MemoryTracker`, `RegionManager`, `FaultManager`. Como page-fault vira GPU→CPU sync.
- `readbacks_mode`: Disabled / Relaxed / Precise. Qual tradeoff de cada. Por que Relaxed não basta pra feedback loops (ele só write-protect, não read-protect).
- PS4 OELF → Itanium RTTI → SCE relocation → dynamic linker reasoning, mesmo sem ter feito o binary patch (o plano ficou documentado).

Não virei expert em nada disso. Mas virei de **total outsider** pra **operador razoavelmente orientado**. E esse salto, como eu comento depois, foi a coisa mais valiosa dos 4 dias.

## A IA sugeria aceitar. A perseverança humana foi minha

Eu disse algumas vezes ao longo do artigo que "Claude sugeriu parar". Quero ser justo e específico aqui: não foi uma falha da IA. Foi exatamente o comportamento correto de uma ferramenta inteligente: **quando você tem algo que funciona razoavelmente bem, parar e documentar é frequentemente a escolha certa.** O patch de tonemap na Fase 22+ fez o jogo playable. O pin de UBO na Fase 26 fez a imagem ficar bonita. O recording harness da Fase 29 cobriu a janela crítica. Todos eram pontos legítimos de parada.

Se você ler o [`codex-conclusion.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/codex-conclusion.md), documento que a IA produziu após a Fase 26 (ainda sem saber sobre a Fase 31), ela descreve a solução de então como "**a mitigation, not a root-cause fix**". Admite honestamente o que sabíamos: o pin de UBO era um contra-ataque, não explicação. Esse é bom comportamento.

A diferença é que **eu tinha um teimoso palpite de que algo ainda tava errado**. Ela funcionava no sentido playable. Mas o custo (pin Driveclub-specific + patch SPIR-V de tonemap + per-track threshold tuning + não generalizar) era alto demais pra um fix supostamente de engineering-quality. Profissional senior reconhece quando a assimetria entre custo e entendimento aponta pra algo mais fundo. Não sempre acerta. Mas esse palpite merece ser escutado.

Quatro dias sem interrupção, das 8h à meia-noite, domingo, segunda, terça, quarta, e resolvido quinta de manhã. Quantas vezes a IA sugeriu "honestly, we should just accept the current result and document"? Umas 4 ou 5 vezes. Cada uma tecnicamente defensável. **A perseverança humana é a diferença entre "o jogo funciona bem o bastante" e "o jogo funciona, e eu sei por quê".**

## Custo real dessa jornada

O [`investigation-effort-accounting.md`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/investigation-effort-accounting.md) catalogue tudo antes da limpeza. Uns highlights:

- **3 dias** de trabalho ativo (Apr 21-23, 2026).
- **33 phases** numeradas + sweeps + side threads = 54 docs, 412 KB, **6.867 linhas de prosa**.
- **44 commits** no fork gamma-debug. **15.668 linhas adicionadas**, 1.204 removidas.
- `src/video_core/renderer_vulkan/vk_rasterizer.cpp` cresceu de 1.364 pra **4.680 linhas** (3.4×) com instrumentação, pin lifecycles, recording harness.
- **32 env vars** de probe definidas. **1 efetivamente usada pra encontrar o bug** (`SHADPS4_DC_LOG_STREAMCOPY`, na Fase 30).
- **61 MB** de log shadPS4 acumulado. **57 MB** de shader dumps (5.803 arquivos). ~**470 MB** totais de artifacts reclaimáveis depois de fechar.

Resolution: **1 inteiro no config.**

A proporção **6.867 linhas de prosa : 1 inteiro** me diverte. Mas ela não é uma piada de ineficiência. É o custo real de aprender um sistema que você não conhecia. Cada linha de prosa descartou uma hipótese. Cada commit ensinou uma camada do stack. O inteiro foi o fim; o caminho foi o produto.

Uma nota honesta: apesar das 15.668 linhas adicionadas no fork `gamma-debug`, **quase nada disso presta pra contribuir upstream no shadPS4**. O que está lá é instrumentação — torture probes, recording harness, pin lifecycles, calibrate-at-arm, snapshots de UBO, dezenas de env vars de debug. Código de diagnóstico, não código de produção. Diagnóstico que só faz sentido pro Driveclub naquelas condições específicas.

O fork vai ficar público, mas **não como branch de contribuição pro projeto shadPS4**. Infelizmente. Fica como documento de estudo: 54 arquivos md cobrindo o processo completo, 44 commits mostrando a sequência de hipóteses, descartes e falhas. É material pra quem quiser entender como foi o processo de depuração, ou pra reaproveitar algumas das técnicas em outras investigações similares. PR upstream-ready dali não sai.

## Fechamento

Sim, a solução final era um toggle de config que já existia. Está no código do shadPS4 há sete meses. Mas domingo à noite, zero conhecimento de PS4, zero conhecimento do emulator, zero noção de que auto-exposure era um GPU→CPU feedback loop, **eu não tinha autoridade técnica pra dizer "liga readbacks Precise, resolve"**.

Eu tive que ver a cadeia toda pra entender *por que* funciona. Por que Relaxed não basta (só write-protects, e o DriveClub lê, não escreve no SSBO do histograma). Por que Precise é caro (per-page mprotect + per-fault GPU stall). Por que o maintainer escondeu atrás de "Advanced" (Bloodborne trava, AMD cai pra 12 FPS). Por que ninguém na comunidade tinha conectado Precise com DriveClub antes: o compat tracker admite "readbacks enabled", mas não cita o modo, e ninguém tinha visto a assinatura de drift monotônico pelo ângulo do loop GPU→CPU.

Essa é a diferença entre **conhecer a resposta** e **conhecer o terreno o suficiente pra reconhecer a resposta**. Pra junior que me pergunta "como eu aprendo hoje na era da IA": essa é a minha resposta. Não pergunte. Mergulhe. Use a IA pra acelerar a busca, pra ler código em paralelo, pra indexar fóruns antigos, pra compilar, pra parsear logs. Mas **insista em entender o porquê**. Quando a IA sugerir "vamos aceitar e documentar" (e ela vai sugerir, porque esse comportamento é frequentemente correto), pergunte a si mesmo se você realmente entendeu a cadeia. Se ainda tiver a coceira de "isso tá errado mas eu não sei por quê", continue.

Provavelmente você vai gastar 4 dias numa coisa que tem solução de um inteiro. Provavelmente você vai descobrir 5 caminhos errados antes do certo. Provavelmente a metade dos seus probes vão ser torture shotguns que nunca apontaram pro fix.

E provavelmente, quando terminar, você vai saber um domínio que você não conhecia.

- **Fork gamma-debug:** [github.com/akitaonrails/shadPS4/tree/gamma-debug](https://github.com/akitaonrails/shadPS4/tree/gamma-debug)
- **54 docs da investigação:** [docs/driveclub-investigation/](https://github.com/akitaonrails/shadPS4/tree/gamma-debug/docs/driveclub-investigation)
- **Operational runbook (recipe):** [distrobox-gaming/docs/driveclub-shadps4.md](https://github.com/akitaonrails/distrobox-gaming/blob/master/docs/driveclub-shadps4.md)
- **Resolução da Fase 31:** [`readbacks_mode: 2`](https://github.com/akitaonrails/shadPS4/blob/gamma-debug/docs/driveclub-investigation/phase-31-readbacks-mode-fix.md)

Agora eu vou jogar Driveclub. Corrida noturna no Canadá, brilho natural, sem blackout. Boa quinta-feira.
