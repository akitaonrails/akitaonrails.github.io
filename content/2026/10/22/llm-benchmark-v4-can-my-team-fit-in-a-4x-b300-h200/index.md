---
title: "LLM Benchmark v4: meu time cabe em 4x B300/H200?"
slug: "llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200"
date: '2026-10-22T11:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200
description: "Depois de ranquear os modelos grandes, a pergunta que sobra: quantos desenvolvedores cabem num pod de 4x B300 ou 4x H200? Medimos concorrência de verdade, com SLO de latência, e a resposta muda tudo: o DeepSeek V4.1 Flash segura 32 usuários confortáveis na B300 e só 8 na H200. Custo por usuário confortável: US$ 1,13/hora na B300 contra US$ 1,80 na H200. Quando a infra própria fecha a conta contra a assinatura de frontier, e quando ela é só vaidade cara."
tags:
- benchmarks-de-llm
- modelos-locais
- llms
- hardware
---

Nos dois últimos artigos eu cobri o [benchmark numa B300 única](/2026/10/19/llm-benchmark-v4-os-top-llms-open-source-numa-b300/) e o [ranking dos modelos grandes em 4x B300](/2026/10/22/llm-benchmark-v4-open-source-que-so-cabe-em-4x-b300/). A pergunta que fecha a trilogia é a da empresa: **vale a pena montar uma infra de LLM própria pro time de desenvolvimento?**

A resposta depende de duas coisas: quantos usuários confortáveis o hardware aguenta, e quanto isso custa por pessoa. Medimos os dois.

## A conta antes do teste

Recapitulando os números do artigo anterior: o pod de 4x B300 custa **US$ 36 por hora** (US$ 864/dia, quase US$ 26 mil/mês ligado direto). Comecei a campanha com uns US$ 127 de saldo, recarreguei US$ 2.550, e sobraram US$ 537. Foram **uns US$ 2.140** entre setup, downloads, tuning e benchmarks, não só inferência.

No meio, o saldo zerou, o pod morreu durante um autotune, e na hora de recarregar **não havia B300 disponível**. É o risco operacional da Runpod: o preço muda e a oferta some. A alternativa foi um pod de 4x H200, com preço de tabela na casa de [US$ 3,59 por GPU-hora na Community Cloud](https://www.runpod.io/pricing): US$ 14,36/hora pras quatro na conta de tabela, contra US$ 36 das B300.

## B300 e H200 não são a mesma máquina

A diferença de hardware muda mais que o preço:

| | 4x B300 | 4x H200 |
| --- | --- | --- |
| Arquitetura | Blackwell Ultra (`sm_103a`) | Hopper (`sm_90`) |
| VRAM | ~288 GB por GPU, ~1,1 TB total | ~141 GB por GPU, ~560 GB total |
| Formatos nativos | FP8 e FP4/NVFP4 | FP8 (sem FP4 nativo) |
| Toolchain | CUDA 12.9+ e kernels compilados na hora | mais maduro, mas ainda com remendos de JIT |

A troca teve custo de adaptação: o checkpoint NVFP4 do GLM que rodava na B300 não existe pra Hopper, então foi preciso baixar a variante FP8 dele, e mesmo o DeepSeek precisou de ajuste de kernel. Os resultados de concorrência abaixo são com os dois em FP8 nativo, que é a comparação justa possível.

## Como medimos "cabe um time"

O teste usa `vllm bench serve` contra o localhost de cada pod, com requisições de 8.000 tokens de entrada e 800 de saída (uma carga sintética no formato de sessão de codificação), subindo a concorrência N degrau por degrau.

O critério de conforto é o que importa: **TTFT de até 2 segundos e TPOT de até 20 ms por token** (ou seja, pelo menos 50 tokens/s por stream), com **95% ou mais das requisições** cumprindo os dois limites. Não é "a mediana ficou boa": é quase todo mundo bem atendido. Um time que espera 50 segundos pelo primeiro token não é um time, é uma fila.

E o aviso de honestidade: isso mede requisições de código confortáveis, não pessoas. Não tenho um multiplicador medido de duty-cycle de agente interativo, então não vou inventar que cada N vira 2 ou 3 desenvolvedores.

## Os números

| Modelo / hardware | Stream único | Confortável (N) | Porta solta (só mediana) | Pico agregado | Gargalo |
| --- | ---: | ---: | ---: | ---: | --- |
| DeepSeek V4.1 Flash, 4x B300 FP8 | 177 tok/s | **32** | 48 | 2.778 tok/s | prefill (TTFT) |
| DeepSeek V4.1 Flash, 4x H200 FP8 | 137 tok/s | **8** | 16 | 2.506 tok/s | prefill (TTFT) |
| GLM 5.3 Flash, 4x H200 FP8 | 175 tok/s | **8** | 16 | 1.930 tok/s | **KV cache, 97%** |

Leia com calma, porque tem três histórias aqui.

**A B300 atende quatro vezes mais gente no conforto.** Mesmo modelo, mesmo FP8, mesmo TP4: 32 usuários confortáveis contra 8. O agregado da H200 até impressiona (2.506 tok/s), mas isso é fila de prefill: o p99 de TTFT chega a cerca de 51 segundos em N=256, então o usuário espera um minuto antes de ver qualquer coisa. Throughput alto não é capacidade interativa.

**Modelo pesado e leve empatam na H200.** O DeepSeek de 510 GB e o GLM menor sustentam os mesmos 8 confortáveis, por motivos diferentes: o DeepSeek tem KV eficiente via MLA e morre de compute/prefill; o GLM estoura o KV cache (97% de uso). Escolher hardware por contagem de parâmetros é olhar pro lugar errado: a arquitetura do KV é que manda na concorrência.

**A porta solta engana.** Se você olhar só a mediana, dá pra dizer 48 na B300 e 16 na H200. Só que a cauda do p99 destrói a experiência de quem está do outro lado. Pra dimensionar time, uso o número confortável e pronto.

## Custo por usuário confortável

Agora a aritmética que decide:

- **4x B300:** US$ 36/h ÷ 32 = **US$ 1,13 por usuário confortável por hora**.
- **4x H200:** US$ 14,36/h ÷ 8 = **US$ 1,80 por usuário confortável por hora**.

A B300 ganha por pessoa mesmo custando 2,5x mais o pod. A H200 só viraria mais barata por usuário abaixo de US$ 9/hora o pod inteiro, e na tabela atual ela custa US$ 14,36. O ponto de corte não é o preço da máquina, é a capacidade dela.

E comparando com assinatura de frontier? Um plano forte de Claude/Codex custa uns US$ 200 por mês por desenvolvedor. Pra transformar stream em gente eu preciso de uma premissa: um desenvolvedor com uma requisição ativa o tempo inteiro durante o expediente, o que é otimista pra capacidade e conservador pra custo. Com essa premissa, e sem contar minha hora de sysadmin nem o setup, o pod rodando 8 horas por dia útil (176 horas/mês) fica assim:

| Setup | Custo mensal do pod | Streams confortáveis (1 por dev) | Custo por dev/mês |
| --- | ---: | ---: | ---: |
| 4x B300 | US$ 6.336 | 32 | **US$ 198** |
| 4x H200 | US$ 2.527 | 8 | **US$ 316** |
| 4x B300 ligado 24/7 | US$ 25.920 | 32 | US$ 810 |

Na faixa de 30 streams contínuos, a B300 fica praticamente no preço da assinatura forte. Abaixo disso, a assinatura sai mais barata, porque você paga por pessoa, não por hora de pod ociosa. E ligar 24/7 sem carga correspondente é jogar dinheiro fora: o pod cobra dormindo.

## Pra empresa, quando fecha a conta

Se você tem um time grande de verdade usando o dia inteiro, dados que não podem sair do ambiente, e um modelo que entrega no trabalho diário (o DeepSeek V4.1 Flash fez 92,5 no meu benchmark de vigilância, acima do GPT-6 Sol e do Sonnet 5), a infra própria começa a fazer sentido **pela primeira vez sem ser vaidade**. O ponto de corte, na premissa de um stream ativo por pessoa o expediente inteiro, fica na casa das 30 pessoas concorrentes, com o pod desligando fora do horário.

Se o time é pequeno, o uso é intermitente, ou o objetivo é só economizar: continua com a API. O mesmo DeepSeek custou US$ 1,21 por rodada completa de benchmark na nuvem, e você não herda um pod pra administrar, nem o risco de a B300 sumir do estoque quando você mais precisa.

O que eu levo dessa campanha: hardware grande não é resposta pra pergunta pequena. Antes de assinar o pod, faça a conta de quantas pessoas realmente concorrem no seu time, meça a latência que elas toleram, e some o preço da sua hora de sysadmin. O modelo aberto grande já chegou na faixa de Sonnet 5 e GPT-6 Sol pra revisão diária de código. A infra só precisa caber no orçamento.
