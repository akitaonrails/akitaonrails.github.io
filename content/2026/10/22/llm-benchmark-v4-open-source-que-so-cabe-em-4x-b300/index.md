---
title: "LLM Benchmark v4: open source que só cabe em 4x B300!!"
slug: "llm-benchmark-v4-open-source-que-so-cabe-em-4x-b300"
date: '2026-10-22T10:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-open-source-que-so-cabe-em-4x-b300
description: "Aluguei 4x NVIDIA B300 na Runpod e rodei meu benchmark v4 de sabotagem nos modelos abertos que não cabem numa placa só. O DeepSeek V4.1 Flash, com 748B, empatou com os líderes em 92,5, no nível do GLM 5.3 hospedado e do GPT-6 Sol. O GLM 5.3 full ficou pra trás, o Kimi K2 Thinking de 1T decepcionou, e um modelo de 397B despencou de 94 na nuvem pra 27 em casa. A conta: US$ 36 por hora de pod, US$ 864 por dia. Quando faz sentido ter a própria infra, e se um modelo aberto grande já basta pro seu dia a dia de programador."
tags:
- benchmarks-de-llm
- modelos-locais
- llms
- hardware
---

No [artigo anterior](/2026/10/19/llm-benchmark-v4-os-top-llms-open-source-numa-b300/) eu contei como foi rodar o benchmark v4 de sabotagem numa única NVIDIA B300 alugada na Runpod. A pergunta que sobrou foi óbvia: e os modelos grandes de verdade, aqueles que não cabem em 288 GB? Decidi ver até onde dá pra empurrar os open source.

A resposta curta: dá pra ir longe, e um deles empatou com a faixa de Sonnet 5 e GPT-6 Sol. A longa vem com uma conta de padaria e vários dias de vLLM sofrendo.

Antes de tudo, a ressalva de escopo. Ainda ficou gente de fora. O Kimi K3, de 2,8 trilhões de parâmetros, é o exemplo: em FP8 ele precisaria de uns 2,8 TB de VRAM, e nem um pod de 8x B300 (2,3 TB brutos) fecha a conta. Pra rodar um monstro desses você precisa quantizar pra FP4 ou alugar muito mais placa. E eu escolhi gastar meu crédito no que cabe em 4x.

## O ranking completo

Metodologia é a mesma de sempre: o app de chat em RubyLLM com 14 defeitos plantados (backdoors, bypass de autorização, mentiras nos testes), e a nota mede vigilância de revisão de código, não velocidade de digitação. O modelo precisa encontrar e corrigir os defeitos sem ser avisado (peso cheio) e quando revelado (peso 40%). Tier A começa em 83. Rodei tudo no mesmo pod de 4x pra ter uma régua única, embora nem todo modelo precisasse das quatro placas (Ornith e Laguna caberiam numa só).

| Modelo | Tamanho / checkpoint | Nota / Tier | Velocidade (stream único) |
| --- | --- | ---: | ---: |
| DeepSeek V4.1 Flash | 748B (552B + 196B Engram), FP8, 510 GB | **92,5 (A)** | 174,8 tok/s |
| GLM 5.3 full | ~700B, FP8, 704 GB | 76,0 (B) | 110 tok/s |
| Ornith-1.5-122B | ~122B MoE, FP8, 133 GB | 73,0 (B) | 244,2 tok/s |
| Step-5-Preview | ~816B (tamanho estimado), NVFP4, 368 GiB | 72,5 (C) | 165,9 tok/s (com MTP) |
| Muse Spark Open | 816B-A42B, NVFP4, 533 GB | 69,5 (C) | 130,8 tok/s |
| MiMo V2.6 Pro | ~0,5T MoE, FP8/mxfp4, ~535 GB | 67,0 (C) | 167,2 tok/s |
| Laguna-S-2.1 | MoE pequeno pra código, NVFP4, 99,7 GB | 65,5 (C) | 263 tok/s |
| Kimi K2 Thinking | 1T / ~32B ativos, INT4, 594 GB | 46,0 (D) | 110 tok/s |
| Nex N2.5 Pro | ~397B MoE, FP8, ~380 GB | 27,0 (D) | 184 tok/s |

Duas notas pra ler a tabela direito. O Step-5 e o Muse estão em C porque a base sem aviso era baixa: conserto depois do "tem problema aí" vale 40%. O Muse consertou 6 dos 7 itens abertos quando revelado; o Step-5, só 2 de 5. E o Nex N2.5 Pro, além da nota vergonhosa, corrompeu o código a ponto do app nem subir. As duas âncoras da campanha anterior, pra comparar: GLM 5.3 Flash e Qwen3.8 Flash-Next, ambos 92,5 na B300 única.

## O que cada um fez de interessante

A nota sozinha esconde o comportamento, e o comportamento é a parte divertida.

**O DeepSeek foi o único que resolveu os dois itens compostos sem ajuda.** Os defeitos compostos são os que exigem enxergar duas coisas ao mesmo tempo (a backdoor e o teste que a encobre), e ele achou e corrigiu os dois sem nenhum nudge. É o tipo de vigilância que eu quero do meu revisor de PR.

**O GLM full consertou tudo quando avisado, mas dormiu no silent mode.** Sem aviso, ele deixou passar o cluster de acesso e correção silenciosa. Quando eu apontei, varreu os seis itens restantes. Ou seja: o modelo grande é capaz, só não é atento por padrão. O Flash dele, com um terço do tamanho, foi mais vigilante.

**O Kimi K2 Thinking fez teatro de checklist de segurança.** Escreveu umas listas lindas de "boas práticas de segurança" e deixou cinco itens abertos, incluindo uma chave em texto plano. Falar de segurança e fazer segurança são coisas diferentes, e ele fez a primeira.

**O Ornith restaurou o comportamento e manteve o teste mentiroso.** No item 6, ele reverteu o código pro comportamento antigo em vez de corrigir o teste plantado que validava a backdoor. Por isso a nota estrita foi 73 e a leniente 76: parecer que consertou não é consertar, e o teste que mente também precisa morrer.

**O Step-5 deixou três defeitos mesmo com o mapa na mão.** Depois de revelar explicitamente, ele ainda deixou o link de login, a desativação de autorização e o agregado incorreto. Nem todo modelo aproveita a segunda chance.

**E o Nex foi o desastre completo.** Precisou de dois nudges, e no fim o texto corrompido chegou ao Ruby commitado e o app nem inicializa. Na nuvem, o mesmo Nex N2.5 Pro tinha feito 94. Em casa, 27. Eu não acreditaria em benchmark de fornecedor depois de ver isso duas vezes.

## Rodar em 4 GPUs não é trivial

Quatro placas não são quatro modelos: é um modelo só fatiado em quatro, com tensor parallelism TP=4 no vLLM. Isso dá uns 1,1 TB de VRAM agregado (na prática, ~1.038 GB úteis com `--gpu-memory-utilization 0.90`). Sem isso, nenhum dos modelos acima de 400 GB existiria na minha vida sem offload pra SSD, que é onde a velocidade vai morrer.

Os cuidados que se repetiram em quase todos:

- **Toolchain sangrando na veia.** B300 (`sm_103a`) exige CUDA 12.9 pra compilar os kernels na hora, então a imagem padrão não bastava: toolkit standalone com nvcc 12.9 e headers certos, e ainda assim cada família precisava de um remendo de DeepGEMM, FlashInfer ou link de cudart.
- **Startup não é download.** O DeepSeek demorava 15 a 30 minutos pra inicializar, então prepare-se pra esperar o modelo carregar antes de medir qualquer coisa.
- **Cada família tem seu parser e suas manias.** O Nex só conversou depois de trocar o parser pra `qwen3_xml`, ganhar mais um nudge e ignorar os artefatos de `tmp/log`. O Step-5 não existia no vLLM 0.32 estável e precisou de nightly com PR específico. O Muse exigiu compilar uma branch de PR ainda em rascunho, com CUDA 12.9 nvcc e bibliotecas 12.8 misturadas, e os pesos em 127 shards de NVFP4. O MiMo pediu `--trust-remote-code`. A Laguna decidiu, do nada, inundar a saída com texto de raciocínio, e uma sprint teve que ser refeita a partir da base de injeção.
- **Contexto custa caro.** O checkpoint FP8 do Kimi K2 Instruct (1.029 GB) deixaria 9 GB pra KV cache nas 4 placas, então foi o INT4 Thinking de 594 GB no lugar. Especular com draft head (MTP) só funcionou no Step-5, com ganho de 2,24x e 73,7% de aceitação de tokens, porque eu verifiquei a correção das ferramentas antes.

A lição operacional: alugar VRAM resolve o "cabe", mas não o "roda bem". Cada modelo grande é um mini-projeto de integração.

## E a fronteira, fica onde?

A pergunta que interessa pro desenvolvedor não é "quem tem mais parâmetro", é "o modelo aberto grande entrega no meu dia a dia?". Os números do benchmark v4, na mesma régua:

| Modelo | Nota |
| --- | ---: |
| Claude Opus 5 / 5.5 | 100,0 |
| GPT-6 Luna | 95,5 |
| GLM 5.3 (hospedado) | 94,0 |
| **DeepSeek V4.1 Flash (nuvem ou 4x B300)** | **92,5** |
| GLM 5.3 Flash / Qwen3.8 Flash-Next (B300 única) | 92,5 |
| GPT-6 Sol | 91,0 |
| Claude Sonnet 5 | 91,0 |
| Kimi K3 | 85,0 |

O DeepSeek V4.1 Flash empatou com o próprio serviço em nuvem, com os mesmos 92,5, e ficou acima do GPT-6 Sol e do Sonnet 5. Ou seja: **o melhor open source atual já está a 1,5 ponto do GLM hospedado e a 7,5 do topo absoluto**, na frente de dois frontier comerciais fortes. Se a sua régua é a minha (achar backdoor e bypass antes de mergear), um open source de 748B local já serve pra revisão diária de código, com 175 tokens por segundo por stream nas minhas medições de admissão.

Mas três avisos antes de você cancelar a assinatura do Claude:

1. **Mais parâmetros não significa mais competência.** O GLM 5.3 full, com ~700B, fez 76 contra 92,5 do Flash dele mesmo. O Kimi K2 Thinking, com 1 trilhão, fez 46. E o Nex N2.5 Pro despencou de 94 na nuvem pra 27 em casa: checkpoint público não é garantia de reproduzir o serviço, como eu já tinha visto no DeepSeek V4 Flash (86 na nuvem, 44,5 em casa).

Aliás, o caso da Nex é o exemplo perfeito de escolha ruim de base. Quando a Rio 3.5 explodiu em junho, [eu cobri a controvérsia aqui](/2026/06/15/controversia-llm-rio-3-5-plagio/): o checkpoint dela era uma mescla de Nex-N2-Pro com Qwen. A turma da Rio podia ter escolhido bases muito melhores, como o DeepSeek V4.1 ou o GLM 5.3 Flash, e foi justamente pra linhagem que, na minha régua atual, foi a pior do lote. Escolher modelo por nome bonito custa caro.
2. **Minha régua é vigilância, não programação geral.** Aqui eu meço quem percebe sabotagem. Não é a mesma coisa que medir quem escreve o seu sistema inteiro melhor, e uma repetida de benchmark minha já variou 9 pontos num mesmo modelo. A distância de 1,5 ponto entre modelos pode ser barulho.
3. **Custo muda a resposta.** Se a ideia é ter qualidade de frontier no dia a dia, a API em nuvem do DeepSeek V4.1 custou US$ 1,21 por rodada de benchmark completa. O pod de 4x B300 custa US$ 36 por hora antes mesmo de você apertar o botão.

## Vale alugar 4x B300?

Pra uma pessoa escrevendo código com um agente de manhã e outro de tarde: não. A API resolve por poucos dólares o que o pod resolve por dezenas de dólares por hora.

Pra uma empresa que precisa de dado privado de verdade (código que não pode sair da VPN), checkpoint travado pra reprodutibilidade, ou carga batch contínua (milhares de revisões, classificações, análises por dia), aí o cálculo muda. O DeepSeek V4.1 em 4x B300 entrega qualidade de quase-fronteira com o dado em casa, e isso não se compra com assinatura de chat.

O que eu não compraria de novo sem medir antes é a premissa "maior é melhor". Eu comecei essa campanha achando que o salto de 92,5 ia vir de um modelo maior. Veio do modelo certo rodando direito. O resto é VRAM queimada e uma história boa pra contar.

E a pergunta de "vale a pena" tem uma resposta irritante de óbvia: depende de quantas pessoas vão usar ao mesmo tempo. É ela que eu respondo no próximo artigo: [LLM Benchmark v4: can my team fit in a 4x b300/h200?](/2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/).
