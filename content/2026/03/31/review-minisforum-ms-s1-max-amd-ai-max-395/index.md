---
title: "Review: Minisforum MS-S1 Max | AMD AI Max+ 395 com 96GB de VRAM"
date: '2026-03-31T15:00:00-03:00'
draft: false
translationKey: minisforum-ms-s1-max-review
tags:
  - hardware
  - llm
  - homeserver
  - amd
  - review
---

Quem acompanha meus posts sobre [home server](/2024/04/03/meu-netflix-pessoal-com-docker-compose/) sabe que eu rodava tudo num Intel NUC Core i7 com 32GB de RAM. Funcionava. Mas com o crescimento dos modelos de IA open source, o NUC virou um gargalo. Sem GPU dedicada, qualquer inferência de LLM ia pra CPU e ficava inutilizável.

Eu comprei um Minisforum MS-S1 Max com o novo chip AMD Ryzen AI Max+ 395 por um motivo específico: esse chip suporta até 128GB de RAM unificada, e eu posso alocar 96GB como VRAM pro iGPU. Isso me dá mais VRAM do que qualquer placa gamer comercial, incluindo a RTX 5090 (32GB). E isso muda o que eu consigo rodar localmente.

![Minisforum MS-S1 Max na mesa](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/blog/2026/03/31/minisforum-desk.jpg)

## Por que trocar o Intel NUC

O NUC serviu bem como servidor Docker por dois anos. Mas a limitação era clara: sem GPU com VRAM suficiente, eu não conseguia rodar LLMs localmente de forma usável. O [Frank Yomik](https://github.com/akitaonrails/FrankYomik), meu sistema de tradução automática de mangás, precisava de OCR via CPU (lento) e conectava remotamente no Ollama do meu desktop (AMD 7950X3D + RTX 5090) pra tradução. Funcionava, mas significava que meu desktop precisava estar ligado pro servidor funcionar.

![Frank Yomik - tradução automática de mangás](https://raw.githubusercontent.com/akitaonrails/FrankYomik/master/docs/sample_translate.png)

Com o Minisforum, o Frank Yomik roda inteiramente no servidor. O worker agora usa ROCm pra OCR com a iGPU, e o Ollama roda local com 96GB de VRAM. Zero dependência do desktop.

![Comparação: Intel NUC (esquerda) vs Minisforum MS-S1 Max (direita)](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/blog/2026/03/31/minisforum-nuc-compare.jpg)

Na foto dá pra ter uma ideia do tamanho. O NUC é aquele cubinho pequeno na esquerda. O Minisforum é maior, mas ainda é um mini-PC. Cabe na prateleira do rack embaixo do Synology NAS sem problema.

![Minisforum instalado na prateleira, ao lado do NAS](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/blog/2026/03/31/minisforum-shelf.jpg)

## As specs

![fastfetch do Minisforum](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/blog/2026/03/31/minisforum-fastfetch.png)

O chip é o AMD Ryzen AI Max+ 395: 16 cores / 32 threads Zen 5, com iGPU Radeon 8060S integrada e 128GB de LPDDR5X unificada. No BIOS, eu configurei UMA Frame Buffer Size pra 96GB, o que deixa ~30GB de RAM pro sistema operacional e containers. Mais os parâmetros de kernel pra TTM (sem eles, o ROCm só enxerga 15.5GB mesmo com a alocação do BIOS).

O sistema operacional é openSUSE MicroOS (mais sobre isso no [próximo post](/2026/03/31/migrando-meu-home-server-com-claude-code/)). O consumo de energia da máquina inteira fica abaixo de 100W, o que é absurdo pra quem está acostumado com GPUs dedicadas que puxam 450W+ sozinhas.

## Minisforum vs meu desktop: benchmarks

Eu rodei um [conjunto de benchmarks](https://github.com/akitaonrails/homelab-docs/tree/master/benchmarks) comparando o Minisforum com meu desktop (AMD 7950X3D, 96GB DDR5, RTX 5090 32GB GDDR7). Os resultados são claros.

### CPU

| Teste | 7950X3D | AI Max+ 395 | Vantagem |
|---|---|---|---|
| Prime sieve (single-core) | 0.021s | 0.018s | Strix Halo +14% |
| Float pi (single-core) | 1.335s | 1.706s | 7950X3D +28% |
| Multi-core sieve (32 threads) | 0.181s | 0.118s | Strix Halo +53% |
| SHA-256 throughput | 2.714 MB/s | 2.488 MB/s | 7950X3D +9% |
| AES-256-CBC throughput | 1.613 MB/s | 1.410 MB/s | 7950X3D +14% |

Resultados mistos. O AI Max+ 395 é melhor em paralelismo puro (sieve multi-core), provavelmente por conta da latência menor na arquitetura de memória unificada. O 7950X3D ganha em float e crypto por causa dos clocks mais altos e do 3D V-Cache.

### Inferência de LLMs (modelos que cabem nos dois)

Aqui é onde a coisa fica interessante. Pra modelos que cabem nos 32GB da RTX 5090, a comparação é puramente de bandwidth de memória:

| Modelo | Tamanho | RTX 5090 (tok/s) | Strix Halo (tok/s) | Vantagem 5090 |
|---|---|---|---|---|
| phi4 | 9.1 GB | 155.1 | 23.2 | 6.7x |
| qwen3:14b | 9.3 GB | 138.9 | 22.6 | 6.1x |
| phi4-reasoning | 11.1 GB | 130.2 | 19.1 | 6.8x |
| qwen3:32b | 20.2 GB | 66.9 | 10.0 | 6.7x |

A RTX 5090 é ~7x mais rápida. A explicação é simples: GDDR7 tem ~1.792 GB/s de bandwidth. LPDDR5X tem ~256 GB/s. A razão (7x) bate quase exatamente com a diferença de velocidade medida (6.7x). Inferência de LLM é um problema dominado por bandwidth de memória. Quem lê pesos mais rápido, gera tokens mais rápido.

### E o prompt processing?

| Modelo | RTX 5090 (tok/s) | Strix Halo (tok/s) | Vantagem 5090 |
|---|---|---|---|
| phi4 | ~1.933 | ~212 | 9.1x |
| qwen3:14b | ~1.474 | ~155 | 9.5x |
| qwen3:32b | ~767 | ~68 | 11.3x |

Prompt processing é ainda pior: 7-11x mais lento. Faz sentido, porque o prompt precisa ser processado inteiro antes de gerar o primeiro token, e é uma operação ainda mais bandwidth-intensiva.

### Onde o Strix Halo ganha: modelos grandes

Agora vem a razão pela qual eu comprei esse PC. Modelos que não cabem na RTX 5090:

| Modelo | Tamanho | Strix Halo (tok/s) | Notas |
|---|---|---|---|
| gpt-oss:20b | 13.8 GB MXFP4 | 48.9 | MoE, mais rápido que esperado |
| qwen3.5:35b | 23.9 GB | 43.2 | MoE, apenas ~4B params ativos |
| qwen3-coder-next | 51.7 GB | 29.5 | MoE, 50GB+ |
| qwen3.5:122b | 81.4 GB Q4_K_M | 19.2 | 122B params, MoE |
| glm-4.7-flash:bf16 | 59.9 GB | 17.9 | Full precision bf16 |
| qwen2.5:72b | 47.4 GB Q4_K_M | 4.5 | Dense 72B, bandwidth-limited |

O qwen3.5:122b com 81GB de pesos rodando a 19 tok/s. Num mini-PC. Isso simplesmente não é possível numa RTX 5090. Na placa da NVIDIA, esse modelo teria que fazer offload de camadas pra RAM do sistema, caindo pra 2-3 tok/s. Na prática, inutilizável.

A diferença entre modelos MoE e densos é brutal. O qwen3.5:35b roda a 43 tok/s porque, apesar de ter 35B de parâmetros totais, só ~4B ficam ativos por token. Um modelo denso de 72B como o qwen2.5:72b precisa ler 40GB+ de pesos por token, e a 256 GB/s de bandwidth, o máximo teórico é ~6.7 tok/s. Os 4.5 medidos representam ~67% de eficiência, que é o esperado pra iGPU (overhead de bus compartilhado e drivers).

### Resumo: quando usar cada máquina

| Caso de uso | Melhor máquina |
|---|---|
| Chat/coding interativo (modelos <32GB) | RTX 5090 (6-7x mais rápido) |
| Modelos grandes (50GB+) | Strix Halo (única opção) |
| Modelos densos 70B+ | Strix Halo (única opção) |
| Full-precision bf16 | Strix Halo (única opção) |
| Batch processing com contexto longo | Strix Halo (mais VRAM pra KV cache) |
| API serving com baixa latência | RTX 5090 (sub-150ms TTFT) |

### Um bug de ROCm que ainda existe

Nem tudo funciona. Modelos como deepseek-r1:70b, llama3.3:70b e llama4:scout crasham com um bug no ggml (`GGML_ASSERT(ggml_nbytes(src0) <= INT_MAX) failed`). O tensor de embedding desses modelos excede 2GB e o kernel de cópia do ROCm usa inteiro de 32 bits pro tamanho. No CUDA (NVIDIA) já foi corrigido, mas no ROCm ainda não. Esperando o fix no Ollama 0.20.0+.

## LPDDR5X vs GDDR7: por que essa diferença

A pergunta que vem é: por que a LPDDR5X é tão mais lenta?

GDDR7 é memória dedicada de GPU. Ela fica soldada na placa de vídeo, conectada por um barramento largo (384 ou 512 bits na RTX 5090) com clocks altos. O único trabalho dela é alimentar a GPU com dados. LPDDR5X é memória unificada que serve pra tudo: sistema operacional, aplicações, e GPU ao mesmo tempo. O barramento é mais estreito e compartilhado.

Na prática: GDDR7 entrega ~1.792 GB/s dedicados pra GPU. LPDDR5X entrega ~256 GB/s que ainda precisam ser divididos entre CPU e GPU. Inferência de LLM é basicamente "leia todos os pesos do modelo da memória, multiplique pelo token atual, gere o próximo token, repita". Quem lê mais rápido, gera mais rápido. Não tem atalho.

A vantagem do Strix Halo não é velocidade. É capacidade. 96GB de VRAM num chip de 100W que custa uma fração de uma GPU profissional. A RTX 5090 é 7x mais rápida, mas trava em 32GB. Modelos que não cabem, não rodam.

## As alternativas: quem mais faz isso?

Se 96GB não é suficiente ou se você quer mais velocidade, as opções são poucas.

O Framework Desktop usa o mesmo chip AI Max+ 395 com até 128GB de RAM. Mesma plataforma, mesma performance, mas com o diferencial de ser modular e reparável (é o Framework, afinal). Na prática é equivalente ao Minisforum em specs e preço.

Acima disso, a alternativa é o Mac Studio com M3 Ultra. O chip M3 Ultra suporta até 512GB de memória unificada, com bandwidth de ~819 GB/s (mais de 3x o Strix Halo). A Apple fabrica os chips de memória no package, então a latência e a bandwidth são superiores. Você poderia potencialmente alocar ~400GB como VRAM e rodar modelos que não cabem em lugar nenhum fora de servidores com GPUs profissionais.

O NVMe interno da Apple também é outro nível: ~7.4 GB/s de leitura sequencial no M3 Ultra, comparado com ~14 GB/s do Crucial T700 (PCIe 5.0). O T700 é mais rápido em throughput bruto, mas a latência do NVMe da Apple tende a ser menor em I/O aleatório por causa da integração com o SoC.

| Spec | Minisforum MS-S1 Max | Mac Studio M3 Ultra (max) |
|---|---|---|
| RAM máxima | 128 GB LPDDR5X | 512 GB unified |
| VRAM alocável | ~96 GB | ~400 GB |
| Memory bandwidth | ~256 GB/s | ~819 GB/s |
| CPU | Zen 5, 16C/32T | Apple M3 Ultra, 32C |
| GPU compute | ROCm (gfx1151, experimental) | Metal (mlx, mature) |
| Consumo | ~100W | ~135W |
| NVMe | PCIe 5.0 (slot padrão) | Custom Apple (~7.4 GB/s) |
| Preço (EUA) | ~$1.500-2.000 | ~$9.999 (512GB config) |
| Preço estimado (Brasil) | ~R$ 12.000-15.000 | ~R$ 110.000+ (importação) |

O preço no Brasil é o elefante na sala. A configuração máxima do Mac Studio custa $9.999 nos EUA. Com impostos de importação (~60% + ICMS estadual), passa dos R$ 110.000. O Minisforum com 128GB sai por R$ 12.000-15.000. A diferença de quase 8x no preço compra muita coisa.

Se você precisa de mais de 96GB de VRAM pra modelos realmente enormes (DeepSeek-V3 com 671B parâmetros cabe em ~400GB Q4, por exemplo), o Mac Studio com 512GB é a única opção consumer. A alternativa seria GPUs profissionais NVIDIA A6000 (48GB VRAM, ~$6.000 cada, e você precisaria de várias em NVLink). Pra tudo que cabe em 96GB, o Minisforum faz o trabalho por uma fração do custo.

## E projetos que prometem rodar LLMs grandes em GPUs pequenas?

Existe o conceito de "layer offloading" que projetos como llama.cpp já suportam. A ideia é: se o modelo não cabe inteiro na VRAM, mantém algumas camadas na GPU e o resto na RAM do sistema. A GPU processa as camadas que estão nela, transfere pro CPU processar o resto, e volta.

Na prática, não funciona bem. O gargalo é o PCIe: a velocidade de transferência entre RAM do sistema e VRAM da GPU é de ~32 GB/s (PCIe 5.0 x16). Cada token gerado precisa transferir dados ida e volta. O resultado é que você cai de 150 tok/s (tudo na VRAM) pra 2-8 tok/s (offload parcial). É lento demais pra uso interativo.

A VRAM é a limitação fundamental porque inferência de LLM é memory-bandwidth-bound, não compute-bound. A GPU tem compute sobrando. O que falta é capacidade de ler os pesos do modelo rápido o suficiente. Quando parte dos pesos está em RAM via PCIe, o pipeline inteiro espera pela transferência.

É por isso que memória unificada (como no Strix Halo ou no Apple Silicon) faz diferença. Não tem PCIe no meio. CPU e GPU acessam a mesma memória física. Os 256 GB/s do Strix Halo são lentos comparados com GDDR7, mas são 8x mais rápidos que ficar fazendo offload via PCIe.

## Avanços em otimização de LLMs (até 2026)

Pra entender por que alguns modelos rodam tão melhor que outros no Strix Halo, precisa entender o que mudou no ecossistema nos últimos dois anos.

### Mixture of Experts (MoE)

Se você roda modelos locais, MoE é o avanço que mais importa. Um modelo MoE tem parâmetros totais altos (ex: 122B no qwen3.5:122b), mas ativa apenas uma fração deles por token (ex: ~4B). Os pesos inativos ficam na VRAM mas não são lidos a cada token, o que reduz drasticamente a bandwidth necessária.

Nos benchmarks do Strix Halo, modelos MoE rodam 3-10x mais rápido que modelos densos do mesmo tamanho. O qwen3.5:35b (MoE, ~4B ativos) roda a 43 tok/s enquanto o qwen2.5:72b (denso, 72B ativos) roda a 4.5 tok/s.

### DeepSeek e a otimização de treinamento

O DeepSeek V3 (dezembro 2024) mostrou que era possível treinar modelos de 671B parâmetros com custo uma ordem de magnitude menor que o previsto. Eles combinaram MoE com quantização FP8 durante o treinamento (não só na inferência), treinamento multi-estágio com curriculum learning, e várias otimizações de comunicação entre GPUs. O impacto: todo mundo copiou. Qwen, GLM, MiniMax, todos adotaram variações dessa técnica.

### Quantização: de FP16 pra Q4 sem perder muito

Quantização comprime os pesos do modelo de 16 bits (FP16) pra formatos menores: 8 bits (Q8), 4 bits (Q4), ou até 2 bits. Um modelo de 70B que ocuparia ~140GB em FP16 cabe em ~40GB em Q4_K_M. A perda de qualidade existe, mas nos formatos modernos (GGUF Q4_K_M, AWQ, EXL2) é pequena o suficiente pra uso prático.

O GGUF (formato do llama.cpp) se tornou o padrão pra inferência local. AWQ e GPTQ são alternativas com calibração mais sofisticada, mas o ecossistema convergiu pro GGUF porque ele funciona em CPU, CUDA e ROCm sem recompilação.

### Destilação: modelos menores que sabem mais

Destilação é treinar um modelo pequeno usando as respostas de um modelo grande como professor. O Phi-4 da Microsoft (14B) foi treinado com destilação do GPT-4 e compete com modelos de 70B em vários benchmarks. O Qwen3 fez o mesmo: o qwen3:14b é surpreendentemente capaz pro tamanho.

### Flash Attention e KV Cache otimizado

Flash Attention (Tri Dao, 2022) mudou como attention é computada: em vez de materializar a matriz inteira de attention na memória, processa em blocos mantendo os dados no SRAM on-chip da GPU, reduzindo consumo de memória de O(n²) pra O(n). Sem isso, contextos de 128K+ tokens seriam impraticáveis. Já passou pelas versões 2 e 3, com otimizações pra FP8 e operações assíncronas no H100. O PagedAttention (vLLM, UC Berkeley) fez o mesmo pro KV cache durante serving: aplica conceitos de memória virtual ao cache, eliminando fragmentação e melhorando throughput 2-4x.

No Ollama, eu configurei `OLLAMA_FLASH_ATTENTION=1` e `OLLAMA_KV_CACHE_TYPE=q8_0` no servidor. O primeiro ativa flash attention, o segundo usa KV cache em 8-bit em vez de fp16, cortando a bandwidth necessária pela metade por token. São otimizações que custam zero em hardware e melhoram throughput mensurável.

### O que Qwen, Kimi, MiniMax e GLM estão fazendo

O Qwen (Alibaba) tem sido consistentemente o melhor custo-benefício em modelos open source. O Qwen3:14b é denso e forte; o Qwen3.5:122b é MoE e roda surpreendentemente bem em 96GB. O GLM-4.7 (Zhipu AI) é notável por oferecer versões bf16 full precision que rodam inteiras em 96GB. O MiniMax experimentou com contextos longos (até 4M tokens). O Kimi (Moonshot AI) focou em context windows grandes com arquiteturas lineares.

### O que roda bem em 96GB de VRAM

Com 96GB no Strix Halo, os modelos que funcionam bem pra uso diário:

| Modelo | Tamanho | tok/s | Uso |
|---|---|---|---|
| qwen3.5:35b | 24 GB | 43.2 | Uso geral, excelente |
| qwen3-coder-next | 52 GB | 29.5 | Código, MoE |
| qwen3.5:122b | 81 GB | 19.2 | Pesado mas usável |
| glm-4.7-flash:bf16 | 60 GB | 17.9 | Full precision |
| qwen2.5-coder:32b | 20 GB | 10.2 | Código, denso |
| deepseek-r1:32b | 20 GB | 7.4 | Raciocínio |

Modelos densos de 70B+ (deepseek-r1:70b, llama3.3:70b) ainda estão bloqueados pelo bug do ROCm que mencionei. Quando for corrigido, devem rodar a ~4-6 tok/s, usáveis pra batch mas não pra chat interativo.

## Conclusão

Eu comprei o Minisforum pra rodar modelos que não cabem em GPU gamer nenhuma. Pra isso, funciona. Não é rápido. 19 tok/s num modelo de 122B não é a experiência que você tem com Claude ou ChatGPT. Mas é local, é privado, e roda na minha prateleira consumindo menos energia que uma lâmpada antiga.

Pra quem pergunta sobre o Mac Studio: se você tem orçamento, é a melhor máquina pra rodar LLMs locais. 512GB de memória unificada, 819 GB/s de bandwidth, ecossistema Metal/mlx maduro. Dá pra rodar DeepSeek-V3 inteiro em Q4. Mas no Brasil, com importação, passa dos R$ 110 mil. O Minisforum com 128GB por R$ 12-15 mil é a opção realista.

E pra quem acha que dá pra contornar a limitação de VRAM com offloading de camadas: não dá. PCIe é lento demais. O modelo precisa caber inteiro na VRAM pra inferência ser usável. É o motivo pelo qual GPUs gamers com 32GB de GDDR7 ultra-rápida continuam limitadas em tamanho de modelo, e por que a memória unificada do Strix Halo e do Apple Silicon mudou a equação.

No [próximo post](/2026/03/31/migrando-meu-home-server-com-claude-code/) eu conto como migrei todo o home server pro Minisforum usando Claude Code, os problemas que encontrei, e como o openSUSE MicroOS se comporta como sistema operacional de servidor Docker.
