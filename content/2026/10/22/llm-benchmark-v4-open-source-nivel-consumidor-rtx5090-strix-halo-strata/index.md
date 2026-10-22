---
title: "LLM Benchmark v4: open source nível consumidor na RTX5090 ou Strix Halo. E o Strata?"
slug: "llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata"
date: '2026-10-22T11:30:00-03:00'
draft: false
translationKey: llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata
description: "Depois de testar os modelos grandes em datacenter, voltei pro hardware de consumidor: RTX 5090 e Strix Halo. O Qwen3.8 Flash-Next fez 91,0 na 5090 com o motor novo Strata, a 1,5 ponto da B300. A Strix Halo mostra que memória grande não é velocidade: 80,0 na mesma tarefa, mas 7,7 tokens por segundo. Comparo specs, explico o tuning que faz modelo rodar bem em PC, e respondo se hardware de consumidor já serve pra trabalhar com IA no dia a dia."
tags:
- benchmarks-de-llm
- modelos-locais
- llms
- hardware
images:
- /2026/10/22/llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata/dgx-spark-box.jpeg
---

Nos dois últimos artigos eu cobri o [benchmark dos modelos grandes em 4x B300](/2026/10/22/llm-benchmark-v4-open-source-que-so-cabe-em-4x-b300/) e a [conta de time e custo por usuário em B300 e H200](/2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/). Agora a pergunta de todo desenvolvedor que não tem um pod na Runpod: **hardware de consumidor já serve pra trabalhar com IA de verdade?**

Voltei pra duas máquinas que eu já tinha: uma workstation com RTX 5090 e um mini PC Strix Halo. E com um motor de inferência novo, o Strata, que promete fazer MoE grande caber em PC comum. A resposta curta: um modelo de 125B já faz Tier A numa RTX 5090. O resto é mais complicado.

## As máquinas, lado a lado

Antes de qualquer nota, entenda a diferença física do que eu estou comparando:

| Hardware | Memória | Banda | Arquitetura | Custo aproximado |
| --- | --- | --- | --- | --- |
| NVIDIA B300 | 288 GB HBM3e | ~8 TB/s | Blackwell Ultra, FP8 e FP4 | US$ 9/hora (Runpod) |
| NVIDIA H200 | 141 GB HBM3e | ~4,8 TB/s | Hopper, FP8 | US$ 3,59/hora |
| DGX Spark | 128 GB unificada | 273 GB/s | GB10, FP4 | ~US$ 6.950 |
| RTX 5090 | 32 GB GDDR7 | ~1,8 TB/s | Blackwell sm_120, FP8/FP4 | ~US$ 2.000 |
| Strix Halo (Ryzen AI Max+ 395) | 128 GB unificada | ~256 GB/s | gfx1151, ROCm | ~US$ 2.000 |

O B300 tem mais de 30 vezes a banda de memória da Strix Halo. A 5090 tem 7 vezes. Isso explica por que o mesmo modelo voa numa máquina e rasteja na outra, e por que quantização deixa de ser detalhe e vira decisão de projeto.

E tem o detalhe da memória ser compartilhada: na Strix e na Spark, a mesma RAM serve CPU, GPU e sistema operacional. Não é VRAM dedicada, então a folga real é bem menor que o número bonito da caixa.

## O ranking em hardware de consumidor

A régua é a mesma do benchmark v4 de sabotagem: 14 defeitos plantados, nota de vigilância de revisão, Tier A a partir de 83.

| Modelo / máquina | Variante e engine | Nota / Tier | Velocidade |
| --- | --- | ---: | ---: |
| **Qwen3.8 Flash-Next** (125B-A6B) | RTX 5090, Strata, IQ3_S | **91,0 (A)** | 159,2 tok/s |
| Ornith-1.5-35B-A3B | RTX 5090, Strata, Q8_0 GGUF | 64,5 (C) | ~80 tok/s |
| Qwen3.8-27B | 5090 → Strix, Q5_K_M → Q8_0 | 80,0 (B) | 7,7 tok/s |
| GLM-4.7-Flash (30B-A3B) | RTX 5090, llama-swap, Q5_K_M | 24,0 (D) | não medido |

O GLM-4.7-Flash completou o protocolo inteiro (depois de uma primeira tentativa aninhada que precisou de retry) e mesmo assim fracassou em detectar sabotagem. E tem uma lição de humildade no Qwen 27B: ele fez 80 na mesma tarefa em que fez 80,5 na B300, mas a 7,7 tokens por segundo na sonda Q8 e 706 minutos de relógio. Nota boa não paga produtividade.

Deixei de fora os testes que ainda não têm nota final: a Qwen3.8 Flash-Next na Strix com Strata só está confirmada como executável, e as densas de 27B foram descartadas na Strix pelo corte de 30 tok/s.

## O tuning que faz modelo rodar bem em PC

Hardware de consumidor não perdoa configuração preguiçosa. O que eu aprendi na prática:

- **Na 5090, compile o llama.cpp pro sm_120.** Imagem pronta cai em fallback PTX lento. É `-DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=120`, driver 570+, e nada de `--ctx-size 0` numa placa de 32 GB: o default de contexto de treino estoura a VRAM na primeira alocação. Contexto tem teto explícito, e se der OOM no primeiro request, corta 25 a 50%.
- **KV cache em q8_0.** Corta a memória de KV pela metade sem custo mensurável de qualidade. Flash-attention ligado por padrão, mas o GLM 4.7 Flash precisa dele desligado, porque a arquitetura deepseek2 dele é incompatível.
- **Raciocínio híbrido dá trabalho.** O Qwen3.8-27B, com a arquitetura SSM/Mamba, precisou de build fresco do llama.cpp/Ollama por causa do `ssm_conv1d`. E o modo "sem raciocínio" não impediu loop de coerência em uma das tentativas; a saída foi retomar na Strix com Q8_0 e `--reasoning off`. Não foi memória extra que resolveu, foi desligar o pensamento.
- **Na Strix, o ajuste é ROCm, não mágica.** `HSA_OVERRIDE_GFX_VERSION`, `GGML_HIP_NO_VMM`, `-dio`. O trunfo dela é capacidade (128 GB), não velocidade (~256 GB/s). Q4_K_M deu 12,6 tok/s e Q8_0 deu 7,7 tok/s, abaixo do meu corte de 30 tok/s pra uso interativo. Por isso a Strix virou escape hatch de modelo grande, não caixa de chat rápida.
- **O motor importa mais que o argumento "AMD não presta".** A mesma placa que parecia lenta entrega modelo grande bem servido quando o motor é otimizado pra arquitetura dela. Especulação com draft head continua sendo fraude se a aceitação for baixa: num teste do llama.cpp com n-gram sem modelo de draft, só 5 de 64 drafts foram aceitos e a vazão caiu 2,3%.

## O que é esse tal de Strata

O [Strata](https://mihai.ltd/blog/beating-llamacpp-from-scratch-consumer-amd) é um motor de inferência novo, escrito do zero em Rust com kernels AMD HIP customizados, do Mihai Farcas. Ele não é um wrapper do llama.cpp: é outra engine, com builds pra CUDA 12/13 e pra HIP-ROCm (o run da 5090 usou CUDA 13).

O problema que ele ataca é o MoE grande em máquina pequena. A estratégia é **expert-offload**: os especialistas quentes ficam na VRAM, os demais ficam na RAM, e o índice fica no SSD. Com 125B e 24.576 especialistas, só uns 10 ativos por token, você não precisa de 288 GB de VRAM pra servir o modelo. Precisa de pelo menos ~32 GB entre RAM e VRAM e ~80 GB de disco. É a diferença entre "não roda" e "roda bem".

No experimento do autor com o Qwen 3.5 4B numa RX 7900 XTX, as otimizações são as mesmas que eu contei no artigo anterior: prefill em lote em vez de milhares de kernels (de ~3.300 pra 280), HIP Graph Replay no decode, argmax na GPU, atenção split-KV em quatro trabalhadores pra não decair com o contexto, e flush imediato de cada token no HTTP (TTFT de 410 ms pra 48,5 ms). Tudo isso numa API compatível com OpenAI na porta 8080.

O que me fez acreditar nele foi o resultado, não o marketing: o **Qwen3.8 Flash-Next na 5090 com Strata fez 91,0, com zero nudges e os 14 itens resolvidos**, a 1,5 ponto do 92,5 que o mesmo modelo fez na B300 com vLLM. O próprio relatório chama isso de "dentro do ruído". Neste benchmark, um motor escrito por uma pessoa ficou a 1,5 ponto da mesma variante servida em datacenter.

## O que cada modelo fez de interessante

**Flash-Next: a prova de que consumidor chega em Tier A.** 34 de 40 sem aviso, mais 6 com peso de revelação, e só dois itens precisando de apontar. Nenhum nudge, todas as sprints limpas. É o único local que junta nota de Tier A, velocidade interativa (159 tok/s) e protocolo completo sem ajuda. Se a pergunta é "da pra usar no trabalho", esse é o exemplo.

**Ornith-35B: rápido, mas não bom o suficiente.** A mesma Ornith que fez 81 na B300 em BF16 fez 64,5 na 5090 com Q8_0. Caiu a detecção sem aviso de 30 pra 23. Mudou quantização, motor e hardware ao mesmo tempo, então não dá pra isolar a causa: essa combinação de Q8_0 + Strata + 5090 perdeu 16,5 pontos, e eu não sei quanto veio de cada variável. O recado é claro: "roda rápido" não é "revisa bem".

**Qwen 27B: boa nota, péssima experiência.** Fez 80 na retomada na Strix, com sprints 1 e 2 na 5090, quase o 80,5 da B300. Mas 7,7 tok/s na sonda Q8 e 706 minutos de wall time. E ainda por cima zero consertos na revelação, com quatro itens abertos. Usar isso no dia a dia é escolher esperar.

**GLM-4.7-Flash: o motor rodou, o modelo falhou.** Protocolo completo em 29 minutos, e zero detecção sem aviso. Recuperou 8 de 14 só quando apontado, e mesmo assim deixou os consertos sem commit. Na B300 ele fez 33,5, que também não é bom. O problema não é só a placa.

## A distância entre as categorias

A pergunta que todo dev tem é se consumidor já chega lá. Comparação direta, na mesma régua:

| Categoria | Modelos | Nota |
| --- | --- | ---: |
| Frontier comercial | Claude Opus 5 / 5.5 | 100,0 |
| Frontier comercial | GPT-6 Luna | 95,5 |
| Frontier comercial | GLM 5.3 (hospedado) | 94,0 |
| Frontier comercial | GPT-6 Sol / Sonnet 5 | 91,0 |
| Frontier comercial | Kimi K3 | 85,0 |
| Open datacenter | DeepSeek V4.1 Flash (4x B300) | 92,5 |
| Open datacenter | GLM 5.3 Flash / Qwen3.8 Flash-Next (B300) | 92,5 |
| **Open consumidor** | **Qwen3.8 Flash-Next (5090 + Strata)** | **91,0** |
| Open consumidor | Qwen3.8-27B (Strix) | 80,0 |
| Open consumidor | Ornith-35B (5090) | 64,5 |
| Open consumidor | GLM-4.7-Flash (5090) | 24,0 |

A leitura é que o topo do consumidor está **9 pontos abaixo do topo comercial absoluto e 1,5 ponto abaixo do topo aberto em datacenter**, nessa métrica de vigilância. É uma distância pequena, e ela some quando você percebe que o GPT-6 Sol e o Sonnet 5 também estão a 91. O abismo real não é entre datacenter e consumidor: é entre o modelo certo e todos os outros. Entre o Flash-Next e a Ornith, na mesma 5090, são 26,5 pontos.

## Então, hardware de consumidor já serve pra trabalhar?

**Serve, com o modelo e o motor certos.** Uma RTX 5090 com Strata entrega Tier A em vigilância de código, a 159 tokens por segundo, sem pagar um centavo por token depois que o hardware existe. Pra quem faz revisão de código, testa agente de codificação e mantém dado privado em casa, isso muda o jogo: não é "quase tão bom quanto", é bom de verdade.

O que não serve é achar que qualquer configuração serve. A Strix Halo é ótima pra ter 128 GB e montar modelo grande, mas a velocidade dela não paga interatividade; a Ornith roda rápido e revisa mal; o GLM-4.7-Flash completa protocolo e não detecta nada sem aviso. E tem o preço invisível: quantização agressiva pode cobrar nota, dependendo do modelo e da configuração, e tempo de espera cobra paciência.

Se eu fosse montar uma caixa pra um dev hoje, seria uma 5090 com Strata e o Flash-Next, e usaria a Strix pra tarefa de fundo que aceita ser lenta. A fronteira comercial continua ganhando de quem precisa do máximo. Mas o consumidor deixou de ser consolação: já tem Tier A na prateleira de casa.
