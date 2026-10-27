---
title: "LLM Benchmark: Quais as melhores LLMs open source pra hardware caseiro?"
slug: llm-benchmark-melhores-llms-open-source-hardware-caseiro
date: '2026-10-27T13:00:00-03:00'
translationKey: llm-benchmark-melhores-llms-open-source-hardware-caseiro
description: "Testei quatro quantizações do Qwen3.8 Flash-Next numa RTX 5090 e num Strix Halo. A Q2_0 venceu: fez 100 e terminou o teste difícil em 7,2 minutos, contra 12,1 da IQ3_S."
tags:
- benchmarks-de-llm
- modelos-locais
- llms
- hardware
draft: false
---

No [último LLM Benchmark sobre modelos open source](/2026/10/22/llm-benchmark-v4-o-veredito-de-open-source-ate-out-2026/), eu fui até o limite do razoável. Aluguei B300, H200, pods com quatro GPUs, rodei quase 70 rodadas e gastei mais de US$ 6 mil na campanha inteira. Saíram candidatos muito bons, como DeepSeek V4.1 Flash, GLM 5.3 Flash e Qwen3.8 Flash-Next, todos chegando perto dos frontier no meu teste de programação.

O problema continuava sendo a máquina. Um modelo de 510 GB que precisa de quatro B300 pode ser open source no GitHub, mas continua fora do alcance de quem quer rodar uma IA no escritório de casa.

Voltei pra minha RTX 5090 e pro Strix Halo. Desta vez, em vez de repetir o benchmark v4 inteiro em dezenas de modelos que já sabemos que não cabem ou não têm velocidade, peguei o candidato mais promissor e fui comparar **as quantizações dele**. Qual versão entrega qualidade suficiente sem transformar cada interação numa espera de vários minutos?

O resultado me surpreendeu: **a versão de 2 bits ganhou**.

## A RTX 3090 e a 4090 ganharam uma sobrevida

Antes dos meus resultados, a comunidade descobriu uma limitação que dava pra remover. Nas GeForce RTX 20, certas operações Tensor Core FP16 com acumulação em FP32 rodam com metade da taxa teórica de emissão por ciclo das equivalentes profissionais. Nas RTX 30 e 40, o limite também atinge BF16.

O hardware está lá. Dois registradores internos selecionam a velocidade, e o driver normal não tem privilégio pra alterá-los.

O projeto [gpu-unlock](https://github.com/Zagitta/gpu-unlock) encontrou uma forma de mudar esses registradores antes do driver da NVIDIA assumir a placa. No Ampere, isso explora um buffer overflow no Booter assinado que autentica e carrega o GSP-RM. A alteração vale só praquele boot: um reboot já desfaz tudo, e nada é gravado na VBIOS.

Também exige Linux, initramfs e bastante cuidado. Eu não recomendo sair instalando isso numa workstation de produção sem ler o código e entender o risco.

É um hack da comunidade, sem suporte oficial da NVIDIA. Você instala por sua conta e risco. O interesse pra LLM está em acelerar prefill quando o engine usa exatamente esse caminho dos Tensor Cores. Outras aplicações de compute, como alguns pipelines de geração de imagem, também podem mudar de desempenho. Jogos dependem de outros gargalos e caminhos da GPU, então não espere ganhar FPS com isso.

Numa RTX 3090, FP16 com acumulação em FP32 foi de 70,95 pra 122,49 TFLOPS; BF16 foi de 70,29 pra 127,30. Na 4090, uma implementação ainda experimental mediu aproximadamente o dobro da taxa de instruções FP16 e BF16.

Só que dobrar TFLOPS não dobra sua LLM. O [teste que motivou esta discussão](https://dev.to/orca_forge/why-gpu-unlock-speeds-up-rtx-3090-prefill-but-barely-changes-decode-4572) separou as duas fases:

- **Prefill** é quando o modelo lê o prompt inteiro. Há muitos tokens disponíveis ao mesmo tempo, então o motor consegue montar operações matriciais grandes e paralelas. O unlock deu de 8% a 13% de ganho em alguns testes na 3090.
- **Decode** é quando o modelo gera um token depois do outro. Em LLM quantizada com expert-offload, essa etapa fica limitada principalmente por banda de memória, RAM, PCIe e cache de especialistas. O ganho medido ficou dentro do ruído.

No Qwen quantizado mais pesado, o ganho de prefill também quase sumiu. E um teste numa 4090 modificada de 48 GB chegou a medir 0,983x, essencialmente nada. A rota de cálculo usada por uma quantização pode nem passar pelo caminho FP16/BF16 que foi liberado.

> O gpu-unlock acelera um caminho específico dos Tensor Cores. Ele pode reduzir a espera pra ler prompts grandes, mas não transforma 24 GB em 96 GB e nem cria banda de memória.

Mesmo com essa ressalva, 3090 e 4090 ficaram mais interessantes pra inferência local. Uma [RTX 3090](https://www.nvidia.com/en-us/geforce/graphics-cards/30-series/rtx-3090-3090ti/) usada ainda tem 24 GB de VRAM, NVLink na geração dela e 936 GB/s de banda. A própria comunidade já está rodando Qwen3.8 Flash-Next numa 3090, com 43 a 51 tokens por segundo, e em duas placas, com 84 a 111 tokens por segundo dependendo da configuração. Esses resultados são da comunidade, não desta rodada.

## Por que eu escolhi o Qwen3.8 Flash-Next

No v4, os candidatos abertos que realmente me interessaram foram:

| Modelo | Onde rodei | Nota v4 | Velocidade |
| --- | --- | ---: | ---: |
| DeepSeek V4.1 Flash | 4x B300, checkpoint nativo | 92,5 | 174,8 tok/s |
| GLM 5.3 Flash | 1x B300, NVFP4 | 92,5 | 142 tok/s |
| Qwen3.8 Flash-Next | 1x B300, NVFP4 | 92,5 | 195 tok/s |
| Qwen3.8 Flash-Next | RTX 5090, IQ3_S | 91,0 | 159,2 tok/s |

Os três empataram dentro da margem de ruído. Só o Qwen repetiu a qualidade numa máquina de consumidor. O modelo principal é um MoE de 125 bilhões de parâmetros, com aproximadamente 6 bilhões ativos por token, mais 51 bilhões em embeddings n-gram e uma cabeça MTP de 4 bilhões. O [Strata](https://github.com/Niko1221/Strata) deixa os especialistas mais usados na GPU, mantém os demais na RAM pra CPU calcular, lê a tabela n-gram do SSD e usa a camada MTP do próprio modelo pra especular os próximos tokens.

DeepSeek V4.1 soma aproximadamente 748 bilhões de parâmetros, contando 552 bilhões do backbone e 196 bilhões do Engram. Eu servi o checkpoint nativo misto FP4/FP8, de cerca de 510 GB, no pod de quatro B300.

Também consegui iniciar uma versão de 2 bits na 5090 com o engine dedicado do Strata. Ela gerou por volta de **17 tokens por segundo**. Tecnicamente roda. Pra agente de programação, está fora da disputa.

O checkpoint NVFP4 do GLM 5.3 Flash tinha cerca de 198 GB e foi servido na B300. Não existe neste repositório uma configuração de consumidor que eu tenha medido e possa recomendar. O GLM 4.7 Flash menor já tinha feito 24 pontos na 5090 e 33,5 na B300 no benchmark anterior. Gastar dias tentando fazer a família errada caber não produziria informação útil.

Também deixei Qwen 4 e Llama fora por escolha. Esta rodada tem uma pergunta estreita: **qual versão do modelo que já provou qualidade funciona melhor nas duas máquinas que eu tenho?**

## O que eu testei

Todo o código, os prompts, os testes escondidos e os resultados estão no [llm-opensource-benchmark](https://github.com/akitaonrails/llm-opensource-benchmark). Testei quatro versões do Qwen3.8 Flash-Next:

| Quantização | Arquivos do modelo | Ideia |
| --- | ---: | --- |
| Q2_0 | ~62 GiB | 2 bits, menor e mais agressiva |
| IQ3_XXS | ~71 GiB | 3 bits, prioriza tamanho |
| IQ3_S | ~78 GiB | 3 bits, mais precisão |
| UD-Q4_K_XL | ~104 GiB | 4 bits, maior preservação dos pesos |

Os arquivos incluem uma parte comum de PLE, então o tamanho total não cabe diretamente na VRAM. O Strata faz o trabalho de carregar e descarregar especialistas.

Na RTX 5090, usei o backend CUDA do Strata com:

- 4 GiB de VRAM reservados pro Hyprland, navegador e terminal;
- cache de KV em `int8`, contexto máximo de 128K e 32K residentes na GPU;
- cache elástico de especialistas;
- especulação de quatro tokens com o MTP do modelo.

No Strix Halo, usei o backend `hip-halo`. Essa máquina tem 64 GB reservados pra GPU e GTT de 31 GB mapeado sobre a RAM do sistema; o limite de RAM do engine era 61,9 GiB. Como ela é headless, deixei a GPU inteira pro modelo e mantive 8 GiB de folga pro cache da conversa.

São dois backends diferentes por baixo, CUDA na NVIDIA e HIP/ROCm na AMD, mas o mesmo engine e a mesma API compatível com OpenAI. Isso reduz uma variável importante: não estou comparando Ollama de um lado e vLLM do outro com templates diferentes.

## A metodologia

Comecei com um teste de velocidade em três situações:

1. prompt frio de 4K tokens;
2. prompt frio rotulado como 32K, que o tokenizer do modelo contou como 42.400 tokens;
3. continuação da mesma conversa, reaproveitando o cache.

Cada uma gera 256 tokens. O runner mede tempo até o primeiro token, leitura do prompt, geração, VRAM, RAM, potência e temperatura.

### O que cada número de velocidade quer dizer

Quando alguém diz que uma LLM faz 200 tokens por segundo, quase sempre está falando só da geração. Uma sessão de agente passa por fases diferentes, e cada uma encosta num gargalo diferente.

**Prefill** é a leitura inicial do prompt. O modelo precisa processar as instruções do harness, histórico da conversa, arquivos e sua pergunta antes de soltar a primeira palavra. Como todos esses tokens já estão disponíveis, a GPU consegue trabalhar com matrizes grandes em paralelo.

Essa fase aproveita melhor Tensor Cores e poder bruto de cálculo. Quanto maior o contexto, mais ela pesa.

| Métrica | O que mede | O que você sente |
| --- | --- | --- |
| Prompt tok/s | Vazão do prefill, quantos tokens de entrada são lidos por segundo | Tempo pra digerir contexto novo |
| TTFT (*time to first token*) | Tempo total entre enviar a requisição e receber o primeiro token | A pausa antes da resposta começar |
| Decode ou output tok/s | Velocidade de geração depois do primeiro token | Ritmo do texto e das chamadas de ferramenta |
| TPOT (*time per output token*) | Tempo por token gerado, normalmente em p50 e p99 (ou p95) | Regularidade da resposta; percentil alto denuncia travadas |
| Wall time | Tempo da tarefa inteira, incluindo ferramentas, testes, retries e texto gerado | Produtividade real do agente |

O **KV cache** guarda os estados intermediários dos tokens já processados. Numa continuação da mesma conversa, o modelo reaproveita esse estado em vez de ler tudo de novo. Por isso o teste de append chega a dezenas de milhares de prompt tokens por segundo e recebe o primeiro token em cerca de meio segundo. Esse número mede reaproveitamento de cache; comparar com prefill frio seria fraude.

O KV também cresce com a conversa e disputa memória com pesos, especialistas e buffers. Aqui ele está em `int8`, com 32K residentes na 5090. Contexto máximo anunciado, contexto que cabe e contexto que continua rápido são três números diferentes.

**Speculative decoding** usa uma camada de draft pra propor vários tokens e o modelo principal verifica o lote. Quando a taxa de aceitação é boa, o output tok/s sobe. Se o draft erra muito, o ganho desaparece. As velocidades desta rodada já incluem MTP com especulação de quatro tokens.

E falta uma métrica que eu não medi aqui: **concorrência**. Todos estes números são de um único stream. Um servidor pode atender várias sessões e aumentar a vazão agregada, mas cada usuário tende a receber menos tokens por segundo.

Pra uso individual, single-stream e wall time mandam. Pra uma equipe, precisa medir sessões simultâneas e latência por usuário, como fiz no [teste com B300 e H200](/2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/).

Depois vieram dois testes de programação usando OpenCode 2.1.4. O modelo recebe uma pequena base Python, trabalha em uma sessão contínua e nunca vê os testes escondidos. Tudo roda em Bubblewrap, sem rede, com filesystem limitado e apenas um gateway local que aceita as chamadas pro modelo esperado.

O primeiro canário tem três turnos e 9 testes escondidos. O modelo precisa implementar um analisador de logs, corrigir bugs e lidar com mudança de requisitos.

O teste difícil tem quatro turnos e 36 testes escondidos. É um reconciliador de pagamentos com decisões enterradas num histórico de 64K tokens, uma decisão corrigida mais tarde, propostas rejeitadas servindo de distração, dinheiro que exige decimal exato e regras novas que interagem com as anteriores. Com o system prompt do OpenCode, o primeiro turno chega perto de 83K tokens.

### Uma régua separada do benchmark v4

Estes canários são muito menores e mais fáceis. No v4, o modelo trabalha num aplicativo Rails por sete sprints enquanto um revisor injeta 14 defeitos de segurança e de correção. A nota mede quantos ele encontra e corrige sozinho antes da revelação. É um teste de vigilância, com muito mais código, ferramentas e oportunidades de se perder.

Aqui são duas bases Python pequenas, três ou quatro turnos e testes funcionais escondidos. Eu montei essa régua pra comparar **quantizações do mesmo Qwen** e descobrir se reduzir os bits quebra requisitos, contexto ou processo. A comparação termina aí, sem ranquear Qwen contra Opus, GPT, DeepSeek ou qualquer outro modelo.

A nota 100 deste artigo pertence a outra escala, sem equivalência com 100 do v4. Ela também não torna o Q2_0 “melhor” que o IQ3_S que fez 91 no v4. O v4 escolheu o Qwen como candidato; este teste menor escolhe qual arquivo do Qwen vale carregar em casa.

> Velocidade sem qualidade só faz o modelo errar mais rápido. Por isso eu medi as duas coisas separadamente.

## Ranking de velocidade

### RTX 5090, com 4 GiB preservados pro desktop

| Quantização | Geração | Leitura da carga longa | Primeiro token |
| --- | ---: | ---: | ---: |
| **Q2_0** | **223 a 259 tok/s** | **6.158 tok/s** | **6,9 s** |
| IQ3_XXS | 196 a 241 tok/s | 5.084 tok/s | 8,3 s |
| IQ3_S | 158 a 208 tok/s | 6.233 tok/s | 6,8 s |
| UD-Q4_K_XL | 44 a 52 tok/s | 2.300 tok/s | 19 s |

### Strix Halo, usando a GPU inteira

| Quantização | Geração | Leitura da carga longa | Primeiro token |
| --- | ---: | ---: | ---: |
| **Q2_0** | **55 a 65 tok/s** | **371 tok/s** | **114 s** |
| IQ3_XXS | 50 a 57 tok/s | 347 tok/s | 122 s |
| IQ3_S | 47 a 50 tok/s | 338 tok/s | 125 s |
| UD-Q4_K_XL | 17 tok/s num prompt de 4K | 137 tok/s | não terminou |

A 5090 tem 32 GB de GDDR7 e [1.792 GB/s de banda](https://www.nvidia.com/en-us/geforce/graphics-cards/50-series/rtx-5090/). O Strix tem mais capacidade total, mas seus aproximadamente 256 GB/s precisam servir o sistema inteiro. A diferença aparece principalmente no prefill: 6,9 segundos contra quase 2 minutos pra começar a responder a carga de 42.400 tokens.

O Q4 foi o pior dos dois mundos. Na 5090 ele rodou devagar e o `systemd-oomd` matou o teste de qualidade. No Strix, zerou a VRAM, começou a paginar e travou a máquina até reboot. Mais bits preservam mais informação, mas ocupam mais memória e reduzem o cache quente que faz esse MoE andar.

## Ranking de qualidade

O teste simples não separou nada:

| Quantização | RTX 5090 | Strix Halo |
| --- | ---: | ---: |
| Q2_0 | 100 | 100 |
| IQ3_XXS | 100 | 100 |
| IQ3_S | 100 | 100 |

Todas passaram os 9 testes escondidos, preservaram os requisitos e terminaram com a suíte visível verde. Precisei aumentar a dificuldade.

No canário difícil, rodei Q2_0 e IQ3_S três vezes cada na 5090:

| Rodada | Nota | Testes escondidos | Tempo dos 4 turnos | Tokens de saída |
| --- | ---: | ---: | ---: | ---: |
| Q2_0 r1 | 100 | 36/36 | 5,3 min | 70K |
| Q2_0 r2 | 100 | 36/36 | 8,8 min | 117K |
| Q2_0 r3 | 100 | 36/36 | 7,4 min | 100K |
| IQ3_S r1 | 100 | 36/36 | 11,9 min | 110K |
| IQ3_S r2 | 100 | 36/36 | 13,3 min | 127K |
| IQ3_S r3 | 100 | 36/36 | 11,1 min | 98K |

As duas acertaram tudo nas três rodadas. Encontraram as decisões no contexto longo, respeitaram a correção posterior, lidaram com eventos fora de ordem, chargebacks, câmbio e fizeram o refactor final. Também passaram por quantidade parecida de testes quebrados enquanto trabalhavam.

A diferença ficou no relógio. **Q2_0 levou 7,2 minutos em média. IQ3_S levou 12,1.** O modelo de 2 bits entregou o mesmo resultado em aproximadamente 60% do tempo.

A evidência vale para bases Python pequenas, com contexto de até uns 85K tokens, e apenas três repetições no canário difícil. Quantização de 2 bits costuma sofrer primeiro em contexto acima de 100K e em bases maiores. Dentro do uso que medi, gastar mais bits não comprou nenhuma qualidade.

## O que cada versão mostrou

### Q2_0: a recomendação atual

Foi a mais rápida nas duas máquinas e terminou todos os testes com nota máxima. Na 5090, 223 a 259 tokens por segundo já entra numa faixa que eu considero confortável pra agente. No Strix, 55 a 65 tokens por segundo é utilizável, embora o prefill longo cobre quase dois minutos antes da primeira resposta.

Eu usaria esta versão no dia a dia e guardaria a ressalva de contexto. Projeto grande, sessão chegando em 100K ou comportamento estranho? Repito o mesmo trabalho em IQ3_S antes de culpar o modelo.

### IQ3_XXS: ficou sem função clara

Passou no canário simples e foi rápida, só que perdeu pro Q2_0 em velocidade e ocupa mais espaço. Eu não rodei as três repetições do teste difícil nela, então não tenho dado pra prometer uma vantagem de qualidade.

### IQ3_S: a opção conservadora

Continua sendo a versão que eu escolheria pra validar um resultado suspeito da Q2_0. Ela já tinha feito 91 no benchmark v4 na 5090, a apenas 1,5 ponto da versão NVFP4 na B300. Nesta rodada, porém, levou quase 70% mais tempo que Q2_0 e não encontrou nada que a menor tivesse perdido.

### UD-Q4_K_XL: qualidade que não cabe não serve

Era a candidata intuitiva a entregar mais fidelidade. Faltou memória pra chegar ao teste que confirmaria isso. Na 5090, caiu pra menos de um quarto da velocidade da Q2_0 e o sistema matou a rodada. No Strix, a máquina travou.

Serve como lembrança de que a maior quantização compatível no papel pode ser a pior configuração real. Um MoE depende do espaço que sobra pra especialistas, KV cache, buffers e o próprio sistema operacional.

## Qual hardware vale a pena?

### RTX 3090 e 4090: boas se você já tem

As duas têm 24 GB, e isso limita o cache de especialistas. O gpu-unlock melhora prefill em workloads que usam o caminho liberado, mas decode continua preso em memória e offload. Uma 3090 usada, principalmente duas com NVLink, pode formar uma máquina local interessante. Eu não compraria uma 4090 nova hoje só pra isso: continua com 24 GB, custa caro e o unlock de Ada ainda é experimental.

Pra ambas, começaria pelo **Qwen3.8 Flash-Next Q2_0** e mediria meu workload. Os 43 a 51 tokens por segundo publicados pela comunidade numa 3090 única já passam do limite do tolerável. Duas 3090 chegam numa experiência bem melhor, desde que você aceite consumo, calor, fonte e 128 GB de RAM.

### Strix Halo: muita capacidade, pouca banda

É uma boa caixa headless, compacta e econômica. A memória unificada deixa rodar modelos que uma GPU de 24 ou 32 GB recusaria. Neste teste, o melhor modelo também foi o **Q2_0**, a 55 a 65 tokens por segundo.

O problema aparece toda vez que o agente lê contexto grande. Quase dois minutos pra processar a carga longa do teste acumulam rápido durante uma sessão. Eu usaria como servidor privado pra tarefas assíncronas, agentes simples e workloads onde capacidade vale mais que resposta imediata.

### RTX 5090: o melhor ponto caseiro hoje

A [RTX 5090](https://www.nvidia.com/en-us/geforce/graphics-cards/50-series/rtx-5090/) tem 32 GB, 21.760 CUDA cores e a mesma banda nominal de 1.792 GB/s da RTX PRO 6000. O que falta é capacidade: preciso reservar 4 GiB pro desktop e usar RAM e SSD pros especialistas que não cabem.

Mesmo assim, ela colocou o Q2_0 em 223 a 259 tokens por segundo e leu a carga longa a 6.158 tokens por segundo. É a primeira configuração local que não me faz sentir que estou esperando a máquina a cada passo. E é uma placa que também serve pra jogos, geração de imagem, vídeo e todo o resto da workstation.

### RTX PRO 6000: três vezes a VRAM, preço de servidor

A [RTX PRO 6000 Blackwell](https://www.nvidia.com/en-us/products/workstations/professional-desktop-gpus/rtx-pro-6000/) tem 96 GB de GDDR7 ECC, 24.064 CUDA cores e os mesmos 1.792 GB/s de banda. A capacidade extra deixa muito mais especialistas residentes, abre espaço pra quantização maior e comporta contexto sem disputar os últimos gigabytes com o desktop.

Ela custa [US$ 16 mil na loja da NVIDIA](https://marketplace.nvidia.com/en-us/enterprise/laptops-workstations/nvidia-rtx-pro-6000-blackwell-workstation-edition/), oito vezes o preço sugerido de US$ 1.999 da 5090. Eu ainda não rodei este benchmark nela, então não vou inventar uma velocidade. A banda igual à 5090 significa que três vezes a memória não viram três vezes mais tokens por segundo. O ganho está em manter mais coisa na placa e evitar o caminho lento de RAM e PCIe.

Pra uso individual, a conta da 5090 fecha melhor. A PRO 6000 começa a fazer sentido quando 96 GB resolvem um modelo que você realmente precisa, quando ECC e suporte profissional importam ou quando várias sessões vão dividir a mesma placa.

## O veredito

| Hardware | Melhor escolha hoje | Experiência |
| --- | --- | --- |
| 1x RTX 3090/4090, 24 GB | Qwen3.8 Flash-Next Q2_0 | Viável com offload; confira prefill e decode no seu stack |
| Strix Halo | Qwen3.8 Flash-Next Q2_0 | 55 a 65 tok/s; prompt longo demora |
| RTX 5090 | **Qwen3.8 Flash-Next Q2_0** | 223 a 259 tok/s; melhor equilíbrio que medi |
| RTX PRO 6000 | Provavelmente IQ3_S ou maior | Capacidade excelente, sem medição minha nesta rodada |

O open source local finalmente entrou numa faixa prática. Uma única 5090 roda um modelo que fez Tier A no meu benchmark v4 e, com Q2_0, chegou a 259 tokens por segundo no canário. O Strix também ficou muito melhor do que os 7,7 tokens por segundo do Qwen denso que eu tinha testado antes.

Ainda existem limites claros. O contexto custa memória, o desktop precisa da mesma VRAM e qualquer especialista fora da placa atravessa PCIe ou cai na RAM. DeepSeek a 17 tokens por segundo mostra que “rodou” continua sendo uma métrica inútil. Se cada iteração leva várias horas, a qualidade do modelo deixa de importar porque ninguém consegue trabalhar desse jeito.

> Pra hardware caseiro, o melhor modelo é o que mantém qualidade suficiente na velocidade que deixa você iterar. Nesta rodada, foi o Qwen3.8 Flash-Next Q2_0 na RTX 5090.

O [repositório do benchmark](https://github.com/akitaonrails/llm-opensource-benchmark) tem os runners, configurações, resultados brutos e testes escondidos. Repita na sua máquina e mande resultados. Hardware, engine, quantização e contexto mudam a resposta. Ranking pronto serve como ponto de partida; a decisão final continua sendo medida no seu trabalho.
