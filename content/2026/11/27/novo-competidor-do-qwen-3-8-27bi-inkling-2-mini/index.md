---
title: "Novo competidor do Qwen 3.8 27bi: Inkling 2 Mini"
date: '2026-11-27T13:00:00-03:00'
slug: novo-competidor-do-qwen-3-8-27bi-inkling-2-mini
translationKey: novo-competidor-do-qwen-3-8-27bi-inkling-2-mini
description: "Testei o Inkling 2 Mini contra o Qwen3.8 Flash-Next na RTX 5090 (Strata e Basalt) e no Strix Halo, incluindo 18 tarefas adversariais multi-linguagem do benchmark-v3: Qwen vence em profundidade (98,4 vs 94,3), enquanto o Inkling chega perto, roda 2,2x mais rápido e cabe inteiro na VRAM."
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

![Painel ao vivo do Basalt servindo o Inkling 2 Mini na RTX 5090: 100% dos especialistas na VRAM (0% na RAM), média de 274,5 tok/s em decode (picos acima de 306 a 318 tok/s) e prefill chegando a 17.407 tok/s](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/27/inkling-2-mini/basalt-inkling-2-mini-toks.png)

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

## O teste que realmente separou os dois: Benchmark v3 (18 tarefas multi-linguagem)

Como tanto o Inkling 2 Mini quanto o Qwen3.8 Flash-Next saturaram o *hard canary* em **100 / 100 / 100**, eu precisava de uma régua bem mais cruel pra descobrir onde cada modelo realmente começa a rachar. Subi o nível rodando o **`benchmark-v3`** (do meu repositório [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark)) dentro do mesmo sandbox `bubblewrap` sem rede, com toolchains de **Python, Ruby, Go e Rust** montados em modo somente leitura, limite de **15 minutos (900 s) por tarefa** e ambos os modelos servidos pelo **Basalt** na RTX 5090: **Inkling 2 Mini (`NVFP4-MX8`)** contra **Qwen3.8 Flash-Next (`IQ3_S`)**.

O `benchmark-v3` mede **profundidade de correção**, onde os testes que o próprio modelo escreve valem zero na nota. A avaliação inteira vem de suítes **escondidas e adversariais** que o agente nunca vê, com peso maior pra casos de borda (*empty*, *overflow*, *unicode*, concorrência, entradas malformadas) e travas rígidas (*gates*) de causa raiz, regressão e performance. As **18 entregas** cobrem:

* **Depuração de causa raiz e refatoração segura em Ruby:** `01-debug-paginator` e `05-refactor-pricing`.
* **Casos de borda em Go e performance em Rust:** `02-edge-csv` e `04-perf-intervals`.
* **Invariantes, ambiguidade, performance e recuperação em Python:** `03-invariant-eventlog`, `06-ambiguity-emails`, `08-perf-rangesum`, `09-sabotage-recover` e `14-edge-semver`.
* **Segurança e bugs latentes em código existente:** `07-security-safebox`, `10-latent-cve-restore`, `11-latent-nplus1`, `12-latent-antipatterns` e `13-latent-sql`.
* **Algoritmos e projetos multi-arquivo:** `15-observation-median`, `16-repo-order-service`, `17-marketplace-app` (simulação completa de aplicação) e `18-resolver-backtrack`.

Aqui está o placar final consolidado das **18 tarefas**:

| Métrica (Basalt na RTX 5090) | Qwen3.8 Flash-Next (`IQ3_S`) | Inkling 2 Mini (`NVFP4-MX8`) |
|---|---:|---:|
| **Nota média final (v3)** | **98,4** (18/18) | **94,3** (18/18) |
| **Notas 100 perfeitas** | **15 de 18** | **13 de 18** |
| **Tempo total (wall time)** | **76,3 min** | **34,1 min** (2,2x mais rápido) |
| **Tokens de saída gerados** | **679,7k** | **771,5k** |
| **Offload na RAM do sistema** | ~42 GB | **0 GB** |

E olhe exatamente onde os dois se separaram nas tarefas mais marcantes (nas outras 9 tarefas, ambos cravaram **100,0** sem drama):

| Tarefa (Linguagem) | Inkling 2 Mini (Nota / Tempo / Reqs) | Qwen3.8 `IQ3_S` (Nota / Tempo / Reqs) | O que aconteceu |
|---|---:|---:|---|
| `02-edge-csv` (Go) | **100,0** / 900s (TO) / 377,5k tok | **100,0** / 101s / 19,0k tok | Inkling entrou em loop longo, estourou timeout e ainda gabaritou |
| `07-security-safebox` (Python) | 89,1 / 31,7s / 14 reqs | **100,0** / 243,4s / 30 reqs | Qwen cavou o dobro de passos e fechou todas as brechas |
| `08-perf-rangesum` (Python) | **100,0** / 4,2s / 1,4k tok | **100,0** / 900s (TO) / 46,8k tok | Inkling resolveu em 4 s; Qwen travou até o timeout |
| `10-latent-cve-restore` (Python) | 37,5 / 13,0s / 5 reqs | **75,0** / 212,8s / 53 reqs | Maior diferença do teste: Inkling parou cedo demais |
| `14-edge-semver` (Python) | **100,0** / 796,3s / 261,3k tok | **100,0** / 847,6s / 157,1k tok | Empate pesado nos casos extremos de semver |
| `15-observation-median` (Python) | 78,7 / 65,9s / 7 reqs | **100,0** / 71,3s / 11 reqs | Qwen acertou o algoritmo completo na mesma janela |
| `16-repo-order-service` (Python) | **98,3** / 17,3s / 7,3k tok | **98,3** / 220,7s / 43,1k tok | Empate técnico com o Inkling 12,7x mais rápido |
| `17-marketplace-app` (Python) | 93,1 / 117,9s / 25 reqs | **98,6** / 498,3s / 91 reqs | Qwen rodou 91 passos metódicos e quase zerou erros |
| `18-resolver-backtrack` (Python) | **100,0** / 16,2s / 6,5k tok | **100,0** / 900s (TO) / 55 reqs | Inkling resolveu em 16 s; Qwen levou 15 min, mas também gabaritou |

Os números de **requisições por tarefa** contam a história inteira. O **Qwen3.8 Flash-Next `IQ3_S`** (com 125B de parâmetros totais por baixo) é mais lento, mas é muito mais **metódico e persistente** quando o problema envolve segurança, CVEs latentes ou sistemas multi-arquivo: em `10-latent-cve-restore`, o Inkling declarou vitória em 13 segundos e 5 chamadas (tirando 37,5), enquanto o Qwen investigou por 53 chamadas e dobrou a nota pra 75,0. Em `17-marketplace-app`, foram 91 chamadas do Qwen (98,6) contra 25 do Inkling (93,1).

Por outro lado, a velocidade do Inkling 2 Mini impressiona: **28,3 dos seus 34,1 minutos** foram gastos em apenas duas tarefas (`02-edge-csv` e `14-edge-semver`). Nas **outras 16 tarefas somadas**, ele liquidou tudo em **5,8 minutos totais**, chegando a entregar exatamente a mesma nota do Qwen em `16-repo-order-service` (98,3) sendo **12,7x mais rápido** (17,3 s contra 220,7 s).

## Os cinco insights que realmente importam

Olhando a bateria inteira (velocidade, *hard canary* e *benchmark-v3*), saem cinco lições práticas:

1. **O engine faz tanta diferença quanto o modelo.** No Strata (`0.1.69`), o Inkling 2 Mini parecia travado na 5090 (110 a 154 tok/s). No **Basalt `v0.5.7`**, saltou **2,3x** para **250 a 346 tok/s** e derrubou o TTFT de 5,1 s para **2,1 s**, explorando os Tensor Cores FP4 nativos da arquitetura Blackwell.
2. **A arquitetura em loop cobra caro em banda de memória limitada.** No **AMD Strix Halo**, o Inkling 2 Mini sobrou em memória (41,9 GiB livres!) e leu o prompt de 32k **1,7x mais rápido** que o Qwen3.8 (51 s contra 114 a 126 s). Na hora de gerar texto, porém, despencou pra **14 a 25 tok/s**, contra **47 a 65 tok/s** do Qwen3.8, porque passar pelas 12 camadas do meio três vezes por token estoura a banda da LPDDR5X no decode.
3. **Parâmetros totais ainda pesam em julgamento de segurança e bugs latentes.** O truque do loop faz o Inkling 2 Mini (26,4B) empatar com um MoE de 125B em 13 de 18 tarefas difíceis, mas quando a tarefa exige farejar vulnerabilidades sutis ou manter consistência numa aplicação grande, o Qwen3.8 `IQ3_S` insiste mais, erra menos e vence no placar geral (**98,4 vs 94,3**, com 15 notas 100 contra 13).
4. **Cuidado com loops de raciocínio nos casos de borda.** O Inkling 2 Mini pode ser absurdamente rápido (16 tarefas em 5,8 min) ou disparar centenas de milhares de tokens quando cisma com um caso de borda (`377,5k` tokens em `02-edge-csv`, `261,3k` em `14-edge-semver`, `140k a 204k` no hard canary). Mesmo com esses picos, terminou as 18 tarefas do v3 **2,2x mais rápido** que o Qwen3.8 `IQ3_S` (**34,1 min** contra **76,3 min**).
5. **Requisitos reais de hardware decidem qual modelo cabe na sua mesa.** Use a tabela abaixo pra julgar o que roda no seu setup:

| Perfil de Hardware | Modelo Recomendado | Memória Necessária | Velocidade Esperada | O que dá pra fazer bem |
|---|---|---|---|---|
| **RTX 5090 (32 GB) + 64 GB+ RAM** | **Qwen3.8 Flash-Next (`IQ3_S` no Basalt)** | 28 GB VRAM + ~42 GB RAM | 223 a 231 tok/s, TTFT 5,2 s | Melhor qualidade geral (98,4 no v3), segurança, refatoração e apps complexos |
| **GPU menor que 5090 (24 a 32 GB) ou só 32 GB RAM** | **Inkling 2 Mini (`NVFP4-MX8` / GGUF)** | ~20 a 25 GB VRAM, **0 GB RAM** | 250 a 346 tok/s na 5090 (TTFT 2,1 s) | Excelente segundo lugar (94,3 no v3), agente rápido e 100% na VRAM |
| **MacBook / Apple Silicon 32 GB+ unificada** | **Inkling 2 Mini (MLX / Ollama)** | ~20 GB unificados | Fluido pra sessões locais | Melhor relação qualidade/espaço sem depender de 64 GB+ de RAM |
| **AMD Strix Halo (64 GB VRAM + GTT)** | **Qwen3.8 Flash-Next (`Q2_0` / `IQ3_S`)** | ~42 a 58 GB VRAM | 47 a 65 tok/s (prefill lento) | Decode 2,5x a 3x mais fluido que o Inkling na LPDDR5X |

## Conclusão: é melhor que o Qwen 3.8? Qual escolher pro seu hardware?

**No placar geral de qualidade de engenharia, não: o Qwen3.8 Flash-Next (`IQ3_S`) continua sendo o melhor modelo geral, mesmo sendo bem mais lento.**

Na minha **RTX 5090** (com RAM de sobra no desktop pra segurar o offload do Basalt), eu continuo preferindo o **Qwen3.8 Flash-Next** como modelo principal pra trabalho pesado de programação. A diferença final de **98,4 contra 94,3** nas 18 tarefas adversariais multi-linguagem (com **15 notas 100** contra 13) aparece exatamente onde mais dói em produção: segurança, vulnerabilidades latentes e disciplina em projetos multi-arquivo.

**O Inkling 2 Mini, porém, é um segundo lugar muito próximo e 2,2x mais rápido** (34,1 min contra 76,3 min no v3), e muda completamente o jogo pra quem **não** tem uma RTX 5090 com 64 GB ou 128 GB de RAM no desktop. Para setups menores que uma 5090 (GPUs de 24 a 32 GB sem folga de RAM pro offload, ou notebooks de 32 GB de memória unificada), o **Inkling 2 Mini é a minha recomendação direta**: roda em precisão nativa (~97,8% vs BF16), ocupa ~20 GB com zero offload, entrega **2,1 s de TTFT**, suporta contexto de 1 milhão de tokens e cravou **94,3** num benchmark adversarial em quatro linguagens.

Na prática, no meu desktop com a 5090, o cenário ideal é manter o **Qwen3.8 Flash-Next** como titular pra tarefas críticas e deixar o **Inkling 2 Mini** ao lado no roteador multi-modelo do Basalt pra iterações rápidas. Todos os configs, logs e relatórios dessa bateria ficam abertos no [llm-opensource-benchmark](https://github.com/akitaonrails/llm-opensource-benchmark).
