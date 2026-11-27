---
title: "Novo competidor do Qwen 3.8 27bi: Inkling 2 Mini"
date: '2026-11-27T13:00:00-03:00'
slug: novo-competidor-do-qwen-3-8-27bi-inkling-2-mini
translationKey: novo-competidor-do-qwen-3-8-27bi-inkling-2-mini
description: "Testei o Inkling 2 Mini da Thinking Machines Lab contra o Qwen3.8 Flash-Next na RTX 5090 (Strata e Basalt) e no Strix Halo: 100/100 no hard canary, zero offload de RAM, 2,1 s de TTFT e os trade-offs reais da arquitetura em loop."
tags:
- benchmarks-de-llm
- modelos-locais
- llms
- hardware
draft: false
---

Eu nunca tinha ouvido falar do **Inkling** até ontem, quando o **DHH** [publicou este post no X](https://x.com/dhh/status/2125845831051858053) contando que o [**Inkling 2 Mini**](https://thinkingmachines.ai/news/inkling-2-mini/), da **Thinking Machines Lab**, tinha acabado de bater o **Qwen3.8 27B** (e atropelar o Nemotron 3.5 Bolt) no teste noturno dele de maleabilidade do Omarchy numa RTX Spark: média 8,50 contra 8,00, fechando 8 de 8 rodadas em 142 minutos contra 240 minutos do Qwen.

![Post do DHH no X comparando Inkling 2 Mini, Qwen3.8 27B e Nemotron 3.5 Bolt no teste noturno do Omarchy](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/27/inkling-2-mini/dhh-inkling-2-mini.png)

Faz exatamente um mês que eu publiquei meu [benchmark de LLMs open source pra hardware caseiro](/2026/10/27/llm-benchmark-melhores-llms-open-source-hardware-caseiro/), onde o **Qwen3.8 Flash-Next** rodando no Basalt tinha virado o campeão da minha RTX 5090. O post do DHH me deixou curioso na hora: se esse modelo novo de 26,4B bate o **Qwen3.8-27B** denso no teste dele, como ele se sai contra o campeão anterior da minha bancada? No meu repositório [llm-opensource-benchmark](https://github.com/akitaonrails/llm-opensource-benchmark), eu coloquei o Inkling 2 Mini pra brigar direto contra o **Qwen3.8 Flash-Next** (um MoE bem maior, de 125B totais e ~6B ativos, quantizado em Q2_0 e IQ3_S) tanto na minha RTX 5090 quanto no meu AMD Strix Halo.

## Quem criou o Inkling 2 e qual é a história

O Inkling 2 é obra da **Thinking Machines Lab**, a startup de IA fundada no começo de 2025 por **Mira Murati** (ex-CTO da OpenAI) junto com um time pesado de pesquisadores egressos da própria OpenAI. Depois de passar meses construindo infraestrutura de treinamento e a plataforma *Tinker*, a empresa lançou sua segunda geração de modelos abertos em novembro de 2026 sob licença permissiva **Apache 2.0**: primeiro o gigante **Inkling 2 Small** (um MoE multimodal de 594B totais e 17B ativos voltado pra nuvem) e, logo na sequência, em 20 de novembro, o **Inkling 2 Mini**, publicado no [Hugging Face (`thinkingmachines/Inkling-2-Mini`)](https://huggingface.co/thinkingmachines/Inkling-2-Mini) com foco explícito em rodar localmente em notebooks de 32 GB ou numa única GPU doméstica.

O motivo de tanta gente estar falando do Inkling 2 Mini está na arquitetura. Em vez de simplesmente empilhar mais camadas físicas e estourar a VRAM, a Thinking Machines usou um **Looped MoE Transformer** (um Mixture-of-Experts com camadas em loop):

* **Parâmetros:** ~26,4 bilhões de parâmetros físicos no total, com apenas **~3,4 bilhões de parâmetros únicos ativos** por token (chegando a ~5,4 bilhões efetivos quando contamos as passagens repetidas).
* **O truque do loop de profundidade:** o modelo tem apenas **24 camadas físicas** no decoder. As camadas 0 a 5 rodam uma vez, as **12 camadas do meio (6 a 17) rodam três vezes em sequência por token** reaproveitando os mesmos pesos, e as camadas 18 a 23 rodam uma vez. Isso entrega a profundidade lógica de um modelo de **48 camadas** ocupando o espaço em memória de um modelo bem menor.
* **Formato e contexto:** vem distribuído em precisão mista nativa **NVFP4/MXFP8** (~20 GB no disco), é nativamente multimodal (texto e imagem) e suporta janela de contexto de até **1 milhão de tokens**.

## O que os criadores prometem e os números oficiais

A tese da Thinking Machines Lab é direta: entregar capacidade de raciocínio, uso de ferramentas e engenharia de software agêntica de nível próximo a modelos bem maiores num pacote que cabe offline num MacBook Pro de 32 GB ou numa RTX 5090. Nos benchmarks divulgados no lançamento (comparando contra o **Qwen3.8-27B** denso), o perfil do modelo fica bem claro:

| Benchmark | Inkling 2 Mini | Qwen3.8-27B (denso) | O que mede |
|---|---:|---:|---|
| **SWE-bench Verified** (bash-only) | **79,2%** | 77,8% | Correção autônoma de bugs em repositórios reais |
| **SWE-bench Pro v2** (Hard) | **77,9%** | 73,8% | Engenharia de software avançada |
| **DeepSWE v1.1** | **48,2%** | 42,2% | Resolução ponta a ponta em repositórios complexos |
| **SWE-bench Multilingual** | **73,7%** | 70,0% | Correção de código em múltiplas linguagens |
| **PMPP-Hard** (Kernel Opt. AUC) | **455,82** | 262,50 | Otimização pesada de kernels |
| **Terminal Bench v2.1** | 71,6% | **73,0%** | Operações de terminal e linha de comando |
| **Artificial Analysis Index v5.0** | **20,1** | **20,1** | Índice composto de inteligência |
| **AutomationBench-AA v1.0.6** | 41,8% | **48,2%** | Automação de fluxos de escritório |
| **AA-Briefcase v1.1** (Elo) | 1263 | **1391** | Trabalho de conhecimento geral e documentos |

Além disso, eles publicaram números fortes em uso de ferramentas (**82,7% no MCP Atlas**), busca profunda (**85,3% no DeepSearchQA**) e compreensão visual/documental (**76,5% no ScreenSpot Pro** e **92,8% no OmniDocBench**).

Repare no trade-off que já aparece nos próprios números oficiais: em **código, depuração e otimização pesada**, o Inkling 2 Mini bate o Qwen3.8-27B denso em quase tudo. Em tarefas de escritório e conhecimento estático amplo (*AutomationBench* e *AA-Briefcase*), o modelo denso de 27B segura vantagem, porque 27B de parâmetros densos armazenam mais "fatos de mundo" do que um MoE esparso de 3,4B ativos, mesmo com o loop de profundidade.

## Meus testes reais: RTX 5090 e AMD Strix Halo

Marketing de lançamento todo laboratório faz bonito. Eu peguei o Inkling 2 Mini e rodei exatamente a mesma bateria do [llm-opensource-benchmark](https://github.com/akitaonrails/llm-opensource-benchmark) nas minhas duas máquinas de casa, usando o [OpenCode](https://opencode.ai) dentro do sandbox com `bubblewrap`:

* **Desktop RTX 5090 (32 GB VRAM):** sempre reservando 4 GB livres pro desktop (Hyprland, navegador e terminal), testando tanto no **Strata** (`0.1.69`, pack `SQ-20`) quanto no [**Basalt**](https://github.com/jesdga95/basalt) (`v0.5.7`, pack nativo [`Inkling-2-Mini-NVFP4-MX8.basalt`](https://huggingface.co/jesdga/Inkling-2-Mini-Basalt)), contra o **Qwen3.8 Flash-Next** (`Q2_0`, `IQ3_XXS`, `IQ3_S` e `UD-Q4_K_XL`).
* **AMD Strix Halo (headless, 64 GB VRAM + 31 GB GTT):** GPU inteira dedicada ao modelo, usando o backend HIP do Strata (`0.1.67` para o Inkling 2 Mini).

### Velocidade na RTX 5090: Strata vs Basalt

Os números abaixo vêm do *speed canary* (prompts frios de 4k e 32k tokens + continuação de conversa de 32k em cache, com janela configurada pra 131k):

| Engine | Modelo / Versão | Geração (tok/s) | Prefill 32k (tok/s) | TTFT 32k | Offload na RAM | VRAM livre mín. |
|---|---|---:|---:|---:|---:|---:|
| **Basalt v0.5.7** | **Inkling 2 Mini (`NVFP4-MX8`)** | **250 a 346** | **15.577** | **2,1 s** | **0 GB** | **6,57 GiB** |
| **Basalt v0.2.1** | **Qwen3.8 Flash-Next (`Q2_0`)** | **377 a 400** | 8.600 | 4,9 s | ~30 GB | 4,13 GiB |
| **Basalt v0.2.1** | Qwen3.8 Flash-Next (`IQ3_S`) | 223 a 231 | 8.200 | 5,2 s | ~42 GB | 4,35 GiB |
| Strata `0.1.69` | Inkling 2 Mini (`SQ-20`) | 110 a 154 | 6.489 | 5,1 s | 0 GB | 4,98 GiB |
| Strata `0.1.50` | Qwen3.8 Flash-Next (`Q2_0`) | 245 a 270 | 6.200 | 7,0 s | ~30 GB | ~4,0 GiB |
| Strata `0.1.50` | Qwen3.8 Flash-Next (`IQ3_S`) | 160 a 210 | 6.200 | 7,0 s | ~42 GB | ~4,0 GiB |
| Strata `0.1.50` | Qwen3.8 Flash-Next (`UD-Q4_K_XL`) | 44 a 52 | 2.300 | 19,0 s | ~75+ GB | OOM no quality |

### Velocidade no AMD Strix Halo (Strata HIP)

| Modelo / Versão | Geração (tok/s) | Prefill 32k (tok/s) | TTFT 32k | VRAM livre mín. | Quality Canary |
|---|---:|---:|---:|---:|---:|
| **Inkling 2 Mini (`SQ-20`, `0.1.67` HIP)** | **13,8 a 24,8** | **642** | **51,1 s** | **41,9 GiB** | **100** (6,2 min) |
| Qwen3.8 Flash-Next (`Q2_0`) | **55 a 65** | 371 | 114,1 s | 22,1 GiB | 100 |
| Qwen3.8 Flash-Next (`IQ3_XXS`) | 50 a 57 | 347 | 122,0 s | ~12 GiB | 100 |
| Qwen3.8 Flash-Next (`IQ3_S`) | 47 a 51 | 338 | 125,4 s | 5,4 GiB | 100 |
| Qwen3.8 Flash-Next (`UD-Q4_K_XL`) | 17 (4k) | 137 | travou a máquina | 0 GiB | não coube |

### Qualidade de código: Hard Canary na RTX 5090 (Basalt)

No *quality canary* (3 turnos, 9 testes escondidos), todo mundo tirou 100 (o Inkling 2 Mini fechou em 2,1 minutos no Basalt 5090 e 6,2 minutos no Strix Halo). A separação real acontece no **hard canary**: uma sessão de 4 turnos no OpenCode sobre um reconciliador financeiro com 36 testes escondidos, decisões enterradas num transcript de 64k tokens (uma delas corrigida no meio), aritmética exata até o centavo e refatoração final. Rodei 3 vezes cada modelo no Basalt:

| Modelo (Basalt 5090) | Notas (3 rodadas) | Testes escondidos | Tempo médio (4 turnos) | Tokens gerados por rodada |
|---|---|---:|---:|---:|
| **Inkling 2 Mini (`NVFP4-MX8`)** | **100 / 100 / 100** | **36/36** em todas | **9,8 min** (8,5 / 8,2 / 12,7) | **140k a 204k** |
| **Qwen3.8 Flash-Next (`Q2_0`)** | **100 / 100 / 100** | **36/36** em todas | **5,5 min** (5,9 / 4,2 / 6,3) | **78k a 116k** |
| Qwen3.8 Flash-Next (`IQ3_S`) | 100 / 96* / 100 | **36/36** em todas | **9,1 min** (5,8 / 11,3 / 10,1) | **61k a 121k** |

*\* Na rodada 2 do IQ3_S, todos os 36 testes escondidos passaram. Os 4 pontos descontados foram um alarme falso do detector de vazamento do sandbox quando o modelo rodou `ps aux` (bug já corrigido no harness).*

## Os quatro insights que realmente importam

Olhando essas tabelas com calma, saem quatro lições bem mais interessantes do que um simples "modelo A ganhou do modelo B":

1. **O engine faz tanta diferença quanto o modelo.** Se eu tivesse parado no Strata (`0.1.69`), minha conclusão teria sido que o Inkling 2 Mini era meio travado na 5090 (110 a 154 tok/s). Quando subi o mesmo modelo no **Basalt `v0.5.7`**, ele saltou **2,3x** para **250 a 346 tok/s** e derrubou o TTFT de 5,1 s para **2,1 s**, porque o Basalt explora de verdade os Tensor Cores FP4 nativos da arquitetura Blackwell.
2. **A arquitetura em loop tem um preço claro em hardware com menos banda de memória.** Olhe o que aconteceu no **AMD Strix Halo**: o Inkling 2 Mini sobrou em memória (41,9 GiB livres!) e leu o prompt de 32k **1,7x mais rápido** que o Qwen3.8 (51 s contra 114 a 126 s). Na hora de gerar texto, porém, despencou pra **14 a 25 tok/s**, enquanto o Qwen3.8 seguiu firme em **47 a 65 tok/s**. O motivo é física pura: passar pelas 12 camadas do meio três vezes por token estoura a banda de memória da LPDDR5X durante o decode. Na RTX 5090 (GDDR7 com banda absurda), o loop voa; no Strix Halo, o gargalo de banda cobra a conta.
3. **Velocidade bruta vs tempo de relógio (a taxa de verbosidade).** Mesmo no Basalt, o Qwen3.8 `Q2_0` terminou o hard canary quase duas vezes mais rápido em tempo real (**5,5 min** contra **9,8 min**). Além de gerar mais rápido (377 a 400 tok/s contra 250 a 346), o Inkling 2 Mini pensa muito mais alto: ele produziu entre **140k e 204k tokens** por sessão, contra **61k a 121k** do Qwen3.8. Em sessões longas de agente, raciocínio verboso vira minutos extras no relógio.
4. **Precisão nativa e zero offload de RAM mudam o jogo.** O Qwen3.8 Flash-Next `Q2_0` é uma quantização agressiva de 2 bits (~78% de concordância top-1 contra BF16; o `IQ3_S` fica em ~87%) e ainda precisa despejar **30 GB a 42 GB de especialistas na RAM do sistema**. O Inkling 2 Mini roda na sua **precisão nativa de lançamento (~97,8% top-1 contra BF16)**, cabe **100% dentro da VRAM da 5090 com 6,6 GiB livres**, lê prompts longos **1,8x mais rápido** e traz janela de **1 milhão de tokens** (exatamente o território acima de 100k tokens onde quantizações de 2 bits costumam começar a degradar primeiro).

## Conclusão: é melhor que o Qwen 3.8? É o novo rei do hardware doméstico?

**Para quem tem uma RTX 5090 (ou uma GPU de 32 GB) rodando Basalt, sim: o Inkling 2 Mini é o novo melhor modelo open-weight geral pra hardware doméstico até a 5090.**

Ele resolve as duas maiores dores de cabeça que o Qwen3.8 Flash-Next deixava na mesa: você não precisa esmagar o modelo em 2 ou 3 bits perdendo fidelidade, e você não precisa de 64 GB ou 128 GB de RAM no desktop pra segurar offload de especialistas. Ele mora inteiro na VRAM, sobra espaço pro desktop, engole 32k tokens de contexto em 2,1 segundos e cravou **100 / 100 / 100** no meu teste difícil de programação.

A resposta só tem dois asteriscos práticos:

* **Se você tem RAM sobrando na 5090 e quer velocidade máxima de relógio** em sessões curtas e médias de código, o **Qwen3.8 Flash-Next `Q2_0`** no Basalt ainda termina mais rápido (5,5 min contra 9,8 min) por ser bem menos verboso. Na prática, no meu desktop eu mantenho o Inkling 2 Mini como padrão e deixo o Qwen3.8 ao lado no roteador multi-modelo do Basalt.
* **Se você roda num AMD Strix Halo ou outra máquina de memória unificada com banda mais modesta**, o Qwen3.8 Flash-Next ainda entrega uma experiência bem mais fluida na geração de tokens (47 a 65 tok/s contra 14 a 25), apesar do prefill bem mais lento, pelo menos até aparecerem kernels HIP mais maduros pro loop do Inkling 2.

A barra do que dá pra rodar localmente sem pagar um centavo de API acabou de subir de novo. Todos os configs, logs e relatórios completos dessa bateria estão abertos no [llm-opensource-benchmark](https://github.com/akitaonrails/llm-opensource-benchmark).
