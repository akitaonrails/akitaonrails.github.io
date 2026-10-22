---
title: "LLM Benchmark v4: o veredito de open source (até out/2026)"
slug: "llm-benchmark-v4-o-veredito-de-open-source-ate-out-2026"
date: '2026-10-22T12:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-o-veredito-de-open-source-ate-out-2026
description: "O fechamento do benchmark v4: quase 70 rodadas, quase 60 modelos, entre nuvem, B300, 4x B300, RTX 5090 e Strix Halo, e mais de 6 mil dólares gastos. Numa tabela só, 42 rodadas fizeram Tier A, e os melhores abertos que eu mesmo servi (DeepSeek V4.1 Flash, GLM 5.3 Flash, Qwen3.8 Flash-Next) ficam a 7,5 pontos do teto, colados no Sonnet 5. Os chineses sobem de 5,5 a 17 pontos por geração enquanto o topo ocidental está parado em programação e gastando a vitrine em matemática. Recomendo os melhores comerciais, os melhores abertos pra empresa e pra PC, junto o que aprendi, e termino com a minha hipótese sobre por que o hardware caro trava o open source."
tags:
- benchmarks-de-llm
- modelos-locais
- llms
- open-source
---

Este é o fechamento do benchmark v4. Desde que comecei essa rodada, foram sete artigos, primeiro na nuvem e depois empurrando a mesma régua de sabotagem pra cada vez mais longe dela:

- **[Parte 1](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-1/)**: por que eu refiz o benchmark do zero pela terceira vez, como funciona o app Rails sabotado com CVEs reais, e quanto custou.
- **[Parte 2](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-2/)**: o ranking original da nuvem, com quase 40 modelos, seis empates no topo e um modelo de graça batendo metade do Claude.
- **[Opus 5.5, GPT-6 sol e luna, MiMo 2.6 e Grok 4.7](/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/)**: a leva seguinte da nuvem. O Opus 5.5 fechou com 100, o GPT 6 luna fez 95,5 por menos de um dólar a rodada, e o Grok 4.7 regrediu contra o próprio antecessor.
- **[Os top LLMs open source numa B300](/2026/10/19/llm-benchmark-v4-os-top-llms-open-source-numa-b300/)**: uma GPU alugada, 14 modelos abertos, e dois deles, GLM 5.3 Flash e Qwen3.8 Flash-Next, empatados em 92,5, no nível do Sonnet 5.
- **[Open source que só cabe em 4x B300](/2026/10/22/llm-benchmark-v4-open-source-que-so-cabe-em-4x-b300/)**: os modelos grandes, a maioria de 400 bilhões a 1 trilhão de parâmetros. O DeepSeek V4.1 Flash empatou com o líder em 92,5 e o resto mostrou que tamanho não compra vigilância.
- **[Meu time cabe em 4x B300/H200?](/2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/)**: teste de concorrência de verdade. O mesmo DeepSeek atende 32 sessões confortáveis no pod de B300 e só 8 no de H200.
- **[Open source nível consumidor na RTX 5090 ou Strix Halo](/2026/10/22/llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata/)**: o Qwen3.8 Flash-Next fez 91 numa placa de PC com o motor Strata, a 159 tokens por segundo.

Este artigo junta tudo numa tabela só e responde a pergunta que sobra: **até outubro de 2026, open source já dá conta?**

## O maior benchmark que eu já rodei

O v4 foi, de longe, a maior rodada de testes que eu já fiz. São quase 70 rodadas completas do mesmo protocolo, quase 60 modelos diferentes, rodando em API de nuvem, numa B300 alugada, num pod de quatro B300, numa RTX 5090 e num Strix Halo, mais um pod de quatro H200 só pro teste de concorrência.

E foi caro. Só a primeira leva, a da nuvem, passou de 4 mil dólares em nove dias, somando créditos e assinaturas. A B300 única custou uns 270, e a campanha de 4x B300 e 4x H200 levou mais uns 2.100. Somando o que eu consigo somar, passou de 6 mil dólares, sem contar as horas de máquina em casa.

> Eu não acho que muita gente vai reproduzir isso tão cedo. Se este material te serviu, compartilhe com quem precisa decidir entre nuvem, servidor próprio ou PC local. Todo o código, os prompts, os logs e os relatórios estão abertos no meu GitHub: [akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark).

### Relembrando a régua

O protocolo é sempre o mesmo. O modelo constrói um app Rails de chat em sete sprints, e entre as sprints um revisor injeta 14 defeitos de segurança e de correção, alguns barulhentos (CVE em gem, chave no código), outros silenciosos (vazamento entre tenants, agregado errado, teste adulterado pra esconder backdoor).

A nota vai de 0 a 100. Defeito corrigido sem aviso vale peso cheio; corrigido só depois que eu revelo que tem problema vale 40%; nunca corrigido vale zero. Os tiers são A a partir de 83, B de 73 a 82,5, C de 51 a 72,5 e D até 50.

É uma régua de **vigilância de revisão de código**. Ela mede se o modelo percebe sabotagem enquanto trabalha, e isso é diferente de medir quem escreve o seu sistema inteiro melhor.

## O ranking combinado

Todas as rodadas do v4 numa tabela só, comerciais e abertos, nuvem e hardware próprio. Quando o mesmo modelo rodou em lugares diferentes, ele aparece mais de uma vez, porque o lugar muda a nota.

| # | Modelo | Pesos | Onde rodou | Nota | Tier | Custo da rodada | tok/s | Minutos |
| ---: | --- | --- | --- | ---: | :---: | ---: | ---: | ---: |
| 1 | GPT-6 Astra | fechado | Nuvem (Codex) | 100,0 | A | US$ 30,55 | — | 100 |
| 1 | Claude Opus 5 | fechado | Nuvem (Claude Code) | 100,0 | A | ~US$ 71 ¹ | — | 145 |
| 1 | Claude Fable 5 | fechado | Nuvem (Claude Code) | 100,0 | A | ~US$ 50 ¹ | — | 85 |
| 1 | Claude Opus 5.5 | fechado | Nuvem (Claude Code) | 100,0 | A | US$ 16,63 ¹ | — | 64 |
| 1 | GPT 5.6 sol | fechado | Nuvem (Codex) | 100,0 | A | US$ 20,37 | — | 317 |
| 1 | GPT 5.6 terra | fechado | Nuvem (Codex) | 100,0 | A | US$ 9,52 | — | 80 |
| 1 | GPT 5.5 | fechado | Nuvem (Codex) | 100,0 | A | US$ 34,69 | — | 117 |
| 8 | Grok 4.6 | fechado | Nuvem (OpenCode) | 98,5 | A | US$ 13,00 | — | 67 |
| 9 | Claude Fable 5.1 | fechado | Nuvem (Claude Code) | 95,5 | A | ~US$ 51 ¹ | — | 133 |
| 9 | Sakana Fugu Ultra v2 | fechado | Nuvem (OpenCode) | 95,5 | A | US$ 122,01 | — | 294 |
| 9 | GPT 6 luna | fechado | Nuvem (Codex) | 95,5 | A | ~US$ 0,84 ² | — | 122 |
| 12 | GPT 5.6 luna | fechado | Nuvem (Codex) | 95,0 | A | US$ 10,04 | — | 123 |
| 13 | Nex N2.5 Pro ⁴ | aberto | Nuvem (OpenCode) | 94,0 | A | grátis | — | 480 |
| 13 | GLM 5.3 | aberto | Nuvem (ZCode) | 94,0 | A | plano flat | — | 215 |
| 15 | DeepSeek V4.1 Flash | aberto | Nuvem (OpenCode) | 92,5 | A | US$ 1,21 | — | 172 |
| 15 | DeepSeek V4.1 Flash | aberto | 4x B300 | 92,5 | A | pod a US$ 36/h | 174,8 | — |
| 15 | GLM 5.3 Flash (NVFP4) | aberto | 1x B300 | 92,5 | A | US$ 21,96 ³ | 142,0 | 145 |
| 15 | Qwen3.8 Flash-Next (NVFP4) | aberto | 1x B300 | 92,5 | A | US$ 12,04 ³ | 195,0 | 80 |
| 19 | MiMo V2.6 Pro | aberto | Nuvem (OpenCode) | 92,0 | A | US$ 1,22 | — | 308 |
| 20 | Qwen3.8 Flash-Next (IQ3_S) | aberto | RTX 5090 (Strata) | 91,0 | A | US$ 0 (local) | 159,2 | — |
| 20 | Claude Sonnet 5 | fechado | Nuvem (Claude Code) | 91,0 | A | ~US$ 27 ¹ | — | 112 |
| 20 | GPT 6 sol | fechado | Nuvem (Codex) | 91,0 | A | ~US$ 8,35 ² | — | 73 |
| 23 | Gemini 3.8 Flash high | fechado | Nuvem (OpenCode) | 90,5 | A | US$ 15,98 | — | 97 |
| 24 | Gemini 3.8 Flash | fechado | Nuvem (Antigravity) | 89,5 | A | grátis (OAuth) | — | 120 |
| 24 | MiniMax M3.1 Flash | fechado | Nuvem (OpenCode) | 89,5 | A | grátis | — | — |
| 26 | Muse Spark 1.3 | fechado | Nuvem (OpenCode) | 88,75 | A | US$ 13,31 | — | 150 |
| 27 | Swift 1.5 27B | aberto | 1x B300 | 88,0 | A | US$ 9,71 ³ | 203,0 | 64 |
| 27 | Grok 4.5 | fechado | Nuvem (OpenCode) | 88,0 | A | US$ 6,19 | — | 48 |
| 29 | Claude Opus 4.6 | fechado | Nuvem (Claude Code) | 87,5 | A | US$ 25,64 ¹ | — | 89 |
| 30 | Kimi K2.7 Code | aberto | Nuvem (Kimi CLI) | 87,25 | A | US$ 7,75 | — | 175 |
| 31 | MiMo V2.5 Pro | aberto | Nuvem (OpenCode) | 86,5 | A | US$ 1,03 | — | 158 |
| 31 | Qwen3.8 Flash | fechado | Nuvem (OpenCode) | 86,5 | A | US$ 1,17 | — | 149 |
| 33 | DeepSeek V4 Flash | aberto | Nuvem (OpenCode) | 86,0 | A | US$ 0,97 | — | 111 |
| 33 | Claude Opus 4.8 | fechado | Nuvem (Claude Code) | 86,0 | A | ~US$ 37 ¹ | — | 87 |
| 35 | Claude Sonnet 4.6 | fechado | Nuvem (Claude Code) | 85,75 | A | US$ 18,64 ¹ | — | 91 |
| 36 | Kimi K3 | aberto | Nuvem (Kimi CLI) | 85,0 | A | US$ 13,79 | — | 148 |
| 36 | DeepSeek V4 Flash 0731 | aberto | Nuvem (OpenCode) | 85,0 | A | US$ 1,94 | — | 194 |
| 38 | GLM 5.3 Flash | aberto | Nuvem (ZCode) | 84,25 | A | plano flat | — | 296 |
| 39 | DeepSeek V4 Pro 0813 | aberto | Nuvem (OpenCode) | 84,0 | A | US$ 4,49 | — | 152 |
| 40 | Step 3.7 Flash | aberto | Nuvem (OpenCode) | 83,75 | A | US$ 4,15 | — | 118 |
| 41 | Grok 4.7 | fechado | Nuvem (OpenCode) | 83,5 | A | US$ 27,94 | — | 120 |
| 42 | ThinkingCap 3.8 27B | aberto | 1x B300 | 83,0 | A | US$ 11,47 ³ | 189,0 | 76 |
| 43 | DeepSeek V4 Pro | aberto | Nuvem (OpenCode) | 82,0 | B | US$ 5,26 | — | 97 |
| 44 | Muse Glimmer 30B | aberto | 1x B300 | 81,0 | B | US$ 3,54 ³ | 295,0 | 23 |
| 44 | Ornith 1.5 35B | aberto | 1x B300 | 81,0 | B | US$ 24,39 ³ | 317,0 | 161 |
| 46 | Qwen 3.8 27B | aberto | 1x B300 | 80,5 | B | US$ 29,11 ³ | 195,0 | 192 |
| 47 | Qwen 3.8 27B (Q8_0) | aberto | Strix Halo | 80,0 | B | US$ 0 (local) | 7,7 | 706 |
| 48 | Qwen 3.7 Max | fechado | Nuvem (OpenCode) | 79,0 | B | US$ 10,63 | — | 106 |
| 49 | GLM 5.2 | aberto | Nuvem (ZCode) | 77,0 | B | plano flat | — | 239 |
| 50 | GLM 5.3 full | aberto | 4x B300 | 76,0 | B | pod a US$ 36/h | 110,0 | — |
| 51 | Gemini 3.7 Flash high | fechado | Nuvem (OpenCode) | 75,5 | B | US$ 12,93 | — | 85 |
| 51 | MiniMax M3 | aberto | Nuvem (OpenCode) | 75,5 | B | US$ 12,17 | — | 187 |
| 53 | Ornith 1.5 122B | aberto | 4x B300 | 73,0 | B | pod a US$ 36/h | 244,2 | — |
| 54 | Step-5-Preview | aberto | 4x B300 | 72,5 | C | pod a US$ 36/h | 165,9 | — |
| 55 | Muse Spark Open | aberto | 4x B300 | 69,5 | C | pod a US$ 36/h | 130,8 | — |
| 56 | Qwen3.5 397B (NVFP4) | aberto | 1x B300 | 68,5 | C | US$ 8,22 ³ | 140,0 | 54 |
| 57 | MiMo V2.6 Pro | aberto | 4x B300 | 67,0 | C | pod a US$ 36/h | 167,2 | — |
| 58 | Laguna-S-2.1 | aberto | 4x B300 | 65,5 | C | pod a US$ 36/h | 263,0 | — |
| 59 | Ornith 1.5 35B (Q8_0) | aberto | RTX 5090 (Strata) | 64,5 | C | US$ 0 (local) | 80,0 | — |
| 60 | Nemotron 3.5 Super VL (NVFP4) | aberto | 1x B300 | 63,0 | C | US$ 7,51 ³ | 207,0 | 50 |
| 61 | Kimi K2 Thinking | aberto | 4x B300 | 46,0 | D | pod a US$ 36/h | 110,0 | — |
| 62 | DeepSeek V4 Flash | aberto | 1x B300 | 44,5 | D | US$ 5,59 ³ | 153,0 | 37 |
| 63 | Mistral Large 3 | aberto | Nuvem (OpenCode) | 39,0 | D | US$ 5,11 | — | 76 |
| 64 | GLM 4.7 Flash (BF16) | aberto | 1x B300 | 33,5 | D | US$ 4,60 ³ | 217,0 | 30 |
| 65 | Gemini 3.1 Pro ⁴ | fechado | Nuvem (OpenCode) | 32,5 | D | US$ 10,31 | — | 54 |
| 66 | Nex N2.5 Pro | aberto | 4x B300 | 27,0 | D | pod a US$ 36/h | 184,0 | — |
| 67 | GLM-4.7-Flash (Q5_K_M) | aberto | RTX 5090 | 24,0 | D | US$ 0 (local) | — | 29 |

Como ler as colunas:

- **Pesos**: "aberto" é checkpoint baixável, qualquer licença; "fechado" é só API.
- **Custo da rodada**: o que uma rodada completa de sete sprints custou.
- **tok/s**: velocidade de decodificação de um stream só, medida por mim. Só existe pra quem eu servi.
- **Minutos**: tempo de relógio da rodada inteira, quando eu tenho o dado. Na B300 única, é só o tempo dos sprints.

E as notas de rodapé:

1. Claude rodou pela assinatura Max do Claude Code. O custo é nocional: os tokens da rodada a preço de tabela da API.
2. Estimado a partir dos tokens da rodada.
3. Só o tempo de inferência na B300 a uns US$ 9 por hora. Download, carga, compilação e tuning ficam de fora, e o custo real do pod foi maior.
4. Nota com ressalva. O Nex na nuvem foi avaliado pelo disco, com tudo sem commit; o Gemini 3.1 Pro foi prejudicado por um bug do proxy do OpenRouter.

Os primeiros artigos do v4 juntavam tudo abaixo de B como C; aqui eu uso a escala com D, a mesma das campanhas de B300. O MiniMax M3.1 Flash rodou de graça pelo OpenRouter como âncora de nuvem da campanha local, e a MiniMax promete liberar os pesos dele no dia 23 de outubro.

## Os modelos estão convergindo

No escopo limitado deste benchmark, a impressão é de que todo mundo está chegando no mesmo lugar. **42 das 67 rodadas fizeram Tier A**, 24 de modelos fechados e 18 de abertos. Sete modelos bateram 100, e 23 rodadas ficaram acima de 90.

Parte disso é limite da própria régua. Quando sete modelos tiram a nota máxima, o teste deixa de separar o topo. E uma rodada repetida do GPT 5.5 fez 91 contra os 100 da oficial, então diferenças de poucos pontos entre dois modelos podem ser só ruído.

Mesmo descontando isso, o desenho é claro. O DeepSeek V4.1 Flash, o GLM 5.3 Flash e o Qwen3.8 Flash-Next, todos abertos, estão a 7,5 pontos do teto, colados no Sonnet 5 e no GPT 6 sol.

> Pra revisão de código e vigilância, o modelo aberto bom já está no pelotão do modelo fechado bom. O que ainda separa os dois é consistência: entre os abertos aparecem notas D que entre os fechados de ponta não aparecem.

### O Ocidente parado, a China correndo

Comparando gerações da mesma família dentro do v4, a diferença de ritmo aparece:

| Família | Antes | Depois |
| --- | ---: | ---: |
| DeepSeek V4 Flash → V4.1 Flash | 86,0 | 92,5 |
| GLM 5.2 → 5.3 | 77,0 | 94,0 |
| MiMo V2.5 Pro → V2.6 Pro | 86,5 | 92,0 |
| MiniMax M3 → M3.1 Flash | 75,5 | 89,5 |
| Kimi K2.7 Code → K3 | 87,25 | 85,0 |
| Gemini 3.7 Flash → 3.8 Flash (high) | 75,5 | 90,5 |
| Claude Fable 5 → 5.1 | 100,0 | 95,5 |
| Grok 4.6 → 4.7 | 98,5 | 83,5 |
| GPT 5.6 sol → GPT 6 sol | 100,0 | 91,0 |
| GPT 5.6 luna → GPT 6 luna | 95,0 | 95,5 |
| Claude Opus 5 → 5.5 | 100,0 | 100,0 |

Os chineses subiram de 5,5 a 17 pontos por geração, com exceção do Kimi. Do lado ocidental, quem já estava no teto não tinha pra onde subir: o Opus ficou em 100, o GPT 6 luna ficou onde o 5.6 luna estava, e três lançamentos novos ficaram abaixo dos antecessores. O Gemini Flash é o contraexemplo ocidental, com um salto de 15 pontos.

O calendário reforça a leitura. O Claude Fable 5 saiu em junho, o Opus 5 e o GPT 5.6 em julho, e todos já batiam 100 na minha régua. Daí até outubro, a OpenAI e a Anthropic lançaram o Fable 5.1, o GPT-6 Astra, o Opus 5.5 e o GPT-6 sol e luna. Nenhum deles mostrou ganho na minha régua, e alguns ficaram abaixo dos antecessores.

No mesmo intervalo, os chineses saíram de uma posição bem atrás: DeepSeek V4 em abril, Kimi K3 em julho, Qwen 3.8 e GLM 5.3 em agosto, DeepSeek V4.1 Flash e MiMo V2.6 Pro em setembro, MiniMax M3.1 Flash em outubro. Cada lançamento chegou mais perto do topo.

> Os chineses parecem andar mais rápido, e andam. Mas parte da impressão vem de os ocidentais estarem parados há meses, pelo menos em programação. Quando o líder não se mexe, quem corre atrás encosta.

### Matemática não é programação

Os laboratórios ocidentais não pararam de trabalhar. Eles estão gastando boa parte da vitrine em matemática:

- em maio, a OpenAI anunciou que um modelo de raciocínio de uso geral [derrubou uma conjectura de Erdős](https://openai.com/index/model-disproves-discrete-geometry-conjecture/) sobre distâncias unitárias;
- em agosto, ela publicou [dez resultados matemáticos do Astra](https://github.com/openai/ten-proofs), cada um com prova formal em Lean;
- também em agosto, a Anthropic mostrou um Claude interno elevando de 41,6% pra 67,2% a fração provada de [zeros da função zeta de Riemann](https://www.anthropic.com/research/riemann-zeta) que satisfazem a hipótese;
- em setembro, a Anthropic [formalizou o Último Teorema de Fermat inteiro em Lean](https://www.anthropic.com/research/formalizing-fermats-last-theorem) em 11 dias, com um modelo interno que ela mesma descreve como comparável ao Fable 5.1.

É impressionante, e é legítimo. Prova formal é um dos poucos lugares onde dá pra verificar a resposta automaticamente, o que torna matemática um ótimo campo de treino e de propaganda. Só que o mesmo Fable 5.1 que serviu de régua pro Fermat fez 95,5 no meu benchmark, contra os 100 do Fable 5.

Ficar melhor em matemática não deixa o modelo automaticamente melhor em programação. Um estudo de 2025, [*Does Math Reasoning Improve General LLM Capabilities?*](https://arxiv.org/abs/2507.00432), concluiu que *a maioria dos modelos que vai bem em matemática não transfere o ganho pra outros domínios*, com programação entre eles. Há contraexemplos: a NVIDIA mostrou que [aprendizado por reforço só com matemática](https://arxiv.org/abs/2505.16400) subiu a nota de código de modelos pequenos. A transferência acontece às vezes, e depende de como se treina.

### E o tal do mixture of experts

A intuição comum é que, num modelo *mixture of experts* (MoE), dá pra melhorar o "especialista de matemática" sem mexer no "especialista de código". A ideia está meio certa pelo motivo errado.

Um MoE tem vários blocos de pesos em cada camada, e um roteador escolhe poucos deles pra cada token. Mas os especialistas não se dividem por assunto do jeito que a intuição sugere. O [paper do Mixtral](https://arxiv.org/abs/2401.04088) procurou exatamente isso e *não encontrou padrão óbvio de especialista por tema*, com uma diferença pequena só num conjunto sintético de matemática; o roteador se organiza mais por sintaxe, por tipo de token. E nem a OpenAI nem a Anthropic confirmam publicamente se os modelos fechados delas são MoE.

O que fica de pé é o essencial: capacidade é treinada por objetivo. O sinal que premia prova em Lean não é o mesmo que premia perceber um vazamento entre tenants num controller Rails, e melhorar um não arrasta o outro junto. Num modelo onde só uma fração dos parâmetros trabalha por token, esse descompasso fica ainda mais fácil de acontecer.

## NVFP4, FP8, Q4: o que é essa sopa de letrinhas

Todo modelo é uma pilha de bilhões de números, os pesos. Quantização é guardar cada número com menos bits. Quanto menos bits, menos memória o modelo ocupa e menos dado a placa precisa ler por token, e é isso que define a velocidade em máquina local. O preço, quando existe, é qualidade.

Pra um modelo de 27 bilhões de parâmetros, a conta fica assim:

| Formato | Bits por peso | 27B ocupa | Onde roda |
| --- | ---: | ---: | --- |
| BF16 | 16 | ~54 GB | nativo de Ampere (RTX 30) em diante |
| FP8 | 8 | ~27 GB | nativo em Ada (RTX 40), Hopper (H200) e Blackwell |
| Q8_0 (GGUF) | ~8,5 | ~29 GB | llama.cpp e Ollama, qualquer placa |
| Q5_K_M (GGUF) | ~5,5 | ~19 GB | llama.cpp e Ollama |
| Q4_K_M (GGUF) | ~4,5 a 4,8 | ~16 GB | llama.cpp e Ollama |
| NVFP4 | 4,5 | ~15 GB | nativo só em Blackwell; vLLM, e llama.cpp desde 2026 |
| IQ3_S (GGUF) | ~3,4 | ~12 GB | llama.cpp e derivados |

### O que é cada um

- **BF16** é a precisão em que a maioria dos modelos é publicada. É a referência: nada se perde.
- **FP8** é ponto flutuante de 8 bits, com suporte em hardware nas gerações Ada, Hopper e Blackwell. Corta a memória pela metade e é o padrão dos checkpoints grandes, como o DeepSeek V4.1 Flash e o GLM 5.3 full.
- **Q8_0, Q5_K_M, Q4_K_M e IQ3_S** são formatos GGUF do llama.cpp. Os pesos são guardados em blocos de inteiros com uma escala por bloco; os "K" misturam precisões por tensor, e os "IQ" usam uma matriz de importância pra decidir onde gastar bits. Q8 é tido como praticamente sem perda, e Q4_K_M é o padrão recomendado de quem roda em casa.
- **NVFP4** é o formato de 4 bits da NVIDIA. Cada número é um ponto flutuante de 4 bits, e cada bloco de 16 números ganha a própria escala em FP8. A NVIDIA diz que isso [ocupa 3,5 vezes menos que FP16 e perde 1% ou menos contra FP8](https://developer.nvidia.com/blog/introducing-nvfp4-for-efficient-and-accurate-low-precision-inference/) no DeepSeek-R1.

O hype do NVFP4 vem daí: os tensor cores da Blackwell calculam nele direto, e foi ele que fez caber numa B300 só o GLM 5.3 Flash, de 198 GB, e o Qwen3.5 397B, de 251 GB. A H200, da geração anterior, não tem FP4 nativo. E o ecossistema caseiro ainda está chegando: o llama.cpp ganhou [suporte a NVFP4](https://github.com/ggml-org/llama.cpp/pull/22196) só em 2026, e a cobertura por arquitetura ainda é parcial.

### O que os nossos testes mostram

Quatro modelos rodaram em mais de uma precisão:

| Modelo | Versão A | Versão B |
| --- | --- | --- |
| Qwen 3.8 27B | BF16, B300: 80,5 | Q8_0, Strix Halo: 80,0 ¹ |
| Qwen3.8 Flash-Next | NVFP4, B300: 92,5 | IQ3_S, RTX 5090 com Strata: 91,0 |
| Ornith 1.5 35B | BF16, B300: 81,0 | Q8_0, RTX 5090 com Strata: 64,5 |
| GLM 4.7 Flash | BF16, B300: 33,5 | Q5_K_M, RTX 5090: 24,0 |

¹ Rodada mista: sprints 1 e 2 em Q5_K_M na 5090, o resto em Q8_0 na Strix, com o raciocínio desligado.

E seis rodaram na API de nuvem e também servidos por mim, com os pesos oficiais:

| Modelo | Nuvem | Servido por mim |
| --- | ---: | ---: |
| GLM 5.3 Flash | 84,25 | 92,5 (NVFP4, B300) |
| DeepSeek V4.1 Flash | 92,5 | 92,5 (FP8, 4x B300) |
| GLM 5.3 full | 94,0 | 76,0 (FP8, 4x B300) |
| MiMo V2.6 Pro | 92,0 | 67,0 (FP8, 4x B300) |
| DeepSeek V4 Flash 0731 | 85,0 | 44,5 (FP4/FP8 oficial, B300) |
| Nex N2.5 Pro | 94,0 | 27,0 (FP8, 4x B300) |

Cada linha é uma rodada só, e o ruído chega a quase 10 pontos. Com essa ressalva, a leitura que eu faço:

- **Q8 ficou empatado com BF16.** O Qwen 27B fez 80,5 e 80,0, num ponto só e com outras coisas mudando junto.
- **Descer de 4 pra 3 bits saiu quase de graça no Flash-Next**, a 1,5 ponto, mesmo trocando de motor e de placa.
- **A queda da Ornith dificilmente é dos bits.** Q8 é quase sem perda, e mesmo assim ela perdeu 16,5 trocando também de motor e de placa.
- **Servir o mesmo checkpoint pode dar qualquer coisa.** O GLM 5.3 Flash subiu 8 pontos na minha mão, o DeepSeek V4.1 empatou, e o Nex caiu quase 70. Parser de ferramenta, template de chat, modo de raciocínio e versão do motor pesam tanto quanto a precisão, e o efeito muda de modelo pra modelo.

> Nos meus testes, os bits pesaram menos do que o hype sugere, e o conjunto todo de como o modelo é servido pesou mais. Use Q8 quando couber, desça pra 4 bits quando precisar, e meça no seu próprio trabalho antes de confiar.

## Os melhores comerciais

Aqui só entra modelo fechado, só Tier A, e só o que eu pagaria por API.

### Por nota

| Modelo | Nota | Custo da rodada | Minutos |
| --- | ---: | ---: | ---: |
| GPT-6 Astra | 100,0 | US$ 30,55 | 100 |
| Claude Opus 5.5 | 100,0 | US$ 16,63 ¹ | 64 |
| Claude Opus 5 | 100,0 | ~US$ 71 ¹ | 145 |
| Claude Fable 5 | 100,0 | ~US$ 50 ¹ | ~85 |
| GPT 5.6 terra | 100,0 | US$ 9,52 | 80 |
| GPT 5.6 sol | 100,0 | US$ 20,37 | 317 |
| GPT 5.5 | 100,0 | US$ 34,69 | 117 |
| Grok 4.6 | 98,5 | US$ 13,00 | 67 |
| GPT 6 luna | 95,5 | ~US$ 0,84 | 122 |
| Claude Fable 5.1 | 95,5 | ~US$ 51 ¹ | 133 |

¹ Custo nocional da assinatura, a preço de tabela da API.

No topo absoluto, o **Claude Opus 5.5** e o **GPT 5.6 terra** são as escolhas óbvias: nota máxima, rodada em pouco mais de uma hora, e preço de rodada de um dígito ou pouco mais. O Opus 5 e o GPT 5.5 tiram a mesma nota custando de duas a sete vezes mais.

### Por custo-benefício

| Modelo | Nota | Custo da rodada |
| --- | ---: | ---: |
| GPT 6 luna | 95,5 | ~US$ 0,84 |
| Qwen3.8 Flash | 86,5 | US$ 1,17 |
| GPT 6 sol | 91,0 | ~US$ 8,35 |
| GPT 5.6 terra | 100,0 | US$ 9,52 |
| GPT 5.6 luna | 95,0 | US$ 10,04 |
| Grok 4.6 | 98,5 | US$ 13,00 |
| Claude Opus 5.5 | 100,0 | US$ 16,63 ¹ |

¹ Custo nocional da assinatura, a preço de tabela da API.

O **GPT 6 luna** é o absurdo da tabela: Tier A alto por menos de um dólar a rodada, uma fração do preço de qualquer outro fechado no mesmo patamar. Se a nota máxima não for obrigatória, é por onde eu começaria.

Na nota máxima, o **GPT 5.6 terra** custa pouco mais da metade do Opus 5.5. A diferença entre os dois fica no resto: harness, velocidade, comportamento em sessão longa, e isso eu cobri nos artigos anteriores.

## Os melhores abertos pra empresa

Aqui entra o que roda em GPU de datacenter, na B300.

| Modelo | Onde | Nota | tok/s | Memória |
| --- | --- | ---: | ---: | ---: |
| DeepSeek V4.1 Flash | 4x B300 | 92,5 | 175 | 510 GB |
| GLM 5.3 Flash | 1x B300 | 92,5 | 142 | 198 GB |
| Qwen3.8 Flash-Next | 1x B300 | 92,5 | 195 | 100 GB |
| Swift 1.5 27B | 1x B300 | 88,0 | 203 | 56 GB |
| ThinkingCap 3.8 27B | 1x B300 | 83,0 | 189 | 56 GB |

O **DeepSeek V4.1 Flash** é o campeão pra time grande. Num pod de 4x B300 a US$ 36 por hora, ele atende **32 sessões confortáveis** ao mesmo tempo, com o primeiro token em menos de 2 segundos pra quase todas. Contando uma sessão ativa por desenvolvedor o expediente inteiro, o que é otimista, são 32 pessoas. Ligando o pod só no expediente, 8 horas por dia, 22 dias por mês, dá uns US$ 6.300 por mês, ou **uns US$ 200 por desenvolvedor**.

As alternativas, pela mesma conta:

- 4x H200 na Runpod atende só 8 sessões confortáveis e sai por uns US$ 316 por desenvolvedor por mês, mesmo com o pod mais barato;
- a mesma configuração na AWS custa quase o dobro, e a H200 na Azure custa quase três vezes o preço da Runpod;
- comprar uma DGX Station GB300 de uns US$ 130 mil se paga em uns 20 meses contra o aluguel no expediente, ou em uns 5 meses contra o pod ligado direto.

Pra time menor, a B300 única com o **Qwen3.8 Flash-Next** ou o **GLM 5.3 Flash** é o ponto doce: mesma nota do DeepSeek, numa GPU só, a uns US$ 9 por hora. Eu não medi concorrência nela. Pela memória que sobra, um time de cinco a dez pessoas cabe bem num modelo de 27 a 35 bilhões, como o Swift 1.5; no GLM 5.3 Flash, de 198 GB, fica apertado.

> A infra própria começa a fazer sentido na casa de 30 pessoas usando ao mesmo tempo, ou quando o código não pode sair da rede. Abaixo disso, a API do mesmo DeepSeek custa pouco mais de um dólar por rodada e você não administra servidor nenhum.

## Os melhores abertos pra consumidor

Aqui entra o que roda num PC: RTX 5090 de 32 GB ou Strix Halo de 128 GB unificados.

| Modelo | Máquina | Nota | tok/s |
| --- | --- | ---: | ---: |
| Qwen3.8 Flash-Next (IQ3_S, Strata) | RTX 5090 | **91,0** | 159 |
| Qwen 3.8 27B (Q8_0) | Strix Halo | 80,0 | 8 |
| Ornith 1.5 35B (Q8_0, Strata) | RTX 5090 | 64,5 | ~80 |
| GLM-4.7-Flash (Q5_K_M) | RTX 5090 | 24,0 | — |

Só tem um vencedor: o **Qwen3.8 Flash-Next na RTX 5090 com o Strata**. É um MoE de 125 bilhões com 6 bilhões ativos por token, e o Strata deixa os especialistas mais usados na placa e o resto na RAM. Ficou a 1,5 ponto da versão de datacenter, em velocidade interativa.

O Strix Halo cabe modelo grande, mas a banda de memória dele é sete vezes menor que a da 5090, e um modelo denso de 27B anda a menos de 10 tokens por segundo em Q8, uns 13 em Q4. Serve pra tarefa de fundo, que pode esperar.

E o **Swift 1.5** e o **ThinkingCap 3.8**, os fine-tunes de 27B que foram bem na B300? Eu não rodei os dois na 5090, e nem precisei. Na B300, em BF16, precisão cheia, eles fizeram 88 e 83, abaixo dos 92,5 do Flash-Next na mesma placa e dos 91 que ele fez na 5090.

Numa 5090 eles caberiam em Q4 ou Q5, mas quantizado o melhor cenário é repetir a nota da B300. Rodar em casa custou 1,5 ponto pro Flash-Next e 16,5 pra Ornith-35B. O Qwen 3.8 27B base, que é a mesma arquitetura, nem completou na 5090 em Q5_K_M: travou num loop de raciocínio no sprint 3.

> Se os dois já ficaram atrás do Flash-Next com precisão cheia, numa 5090 eles não vão ficar melhores. Não vi motivo pra testar: pra PC, o Flash-Next é claramente a escolha.

E tem o problema que eu contei no [artigo anterior](/2026/10/22/llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata/): achar uma 5090 hoje é difícil, e quando acha, o preço fica entre duas vezes e meia e quase cinco vezes o sugerido.

## O que eu aprendi no v4

### Sobre os modelos

- Quase todo modelo pega o defeito barulhento sem aviso: CVE em gem, chave no código, CORS aberto, SQL injection óbvia. Quase todo modelo deixa passar o silencioso até eu revelar: vazamento entre tenants, agregado errado, teste adulterado, índice removido. O que separa o Tier A do resto é quanto do silencioso ele pega sozinho.
- Tamanho não compra vigilância. O Kimi K2 Thinking, de 1 trilhão de parâmetros, fez 46. O GLM 5.3 full, de 700 bilhões, fez 76, contra 92,5 do Flash da mesma família.
- Modelo trapaceia ou se engana com convicção. O Nemotron adulterou um teste de regressão pra passar, o Qwen3.5 397B deixou passar uma backdoor e ainda escreveu um teste que a tratava como comportamento esperado, e o Kimi K2 fez teatro de checklist de segurança, pegando só o que dá pra achar com grep.
- O salto entre gerações foi de confiabilidade agêntica. O GPT-4o e o GPT-4.1 nem conseguem completar o protocolo sozinhos. Os modelos atuais do topo rodam as sete sprints sem ajuda nenhuma.

### Sobre servir modelo aberto

- O mesmo checkpoint muda de nota conforme quem serve. O DeepSeek V4 Flash fez 85 na nuvem, na mesma versão 0731 que eu baixei, e 44,5 servido por mim; o Nex N2.5 Pro fez 94 na nuvem e 27 no pod de 4x B300, com tokens corrompidos chegando no código commitado.
- Nenhum modelo roda rápido do jeito que vem. O GLM 5.3 Flash saiu de 10 pra 141 tokens por segundo só de configuração, e cada família pediu parser, flag e às vezes uma branch de PR do vLLM.
- Rodar em casa cobra preço diferente de cada modelo. Trocando quantização, motor e placa de uma vez, o Flash-Next perdeu 1,5 ponto e a Ornith-35B perdeu 16,5.
- Quem limita a concorrência é a arquitetura do cache de KV e o tempo até o primeiro token. Contagem de parâmetros diz pouco: na H200, um modelo de 510 GB e outro bem menor empataram em 8 usuários, por motivos opostos.

### Sobre medir

- Uma rodada tem ruído de quase 10 pontos. Duas notas a 2 pontos de distância empatam.
- O harness pesa. O Gemini 3.1 Pro foi derrubado por um bug de proxy, o gpt-oss não completa no OpenCode, e três modelos insistiram em criar o app numa subpasta.
- Modelo que não faz commit perde trabalho. Correção que fica só no disco some no primeiro `git checkout`.

## A minha hipótese: o hardware caro é parte do modelo de negócio

O veredito do v4, até outubro de 2026, é este: pra revisão de código e vigilância, open source chegou. O DeepSeek V4.1 Flash, o GLM 5.3 Flash e o Qwen3.8 Flash-Next estão no pelotão do Sonnet 5 e do GPT 6 sol, e um deles roda numa placa de PC.

Então por que não está todo mundo rodando em casa? Porque o hardware ficou caro e difícil de achar, e eu tenho uma hipótese sobre isso. É hipótese minha, sem prova de combinação nenhuma, montada em cima de fatos públicos.

### Os fatos

- A memória disparou. A TrendForce mediu alta de [93% a 98% no preço de contrato de DRAM](https://www.trendforce.com/presscenter/news/20260601-13070.html) só no primeiro trimestre de 2026, e diz que os fabricantes [continuam priorizando capacidade pra servidor](https://www.trendforce.com/presscenter/news/20260930-13258.html) no quarto trimestre.
- A HBM, a memória das GPUs de datacenter, deve ter o [preço médio subindo 121% em 2027](https://www.trendforce.com/presscenter/news/20260929-13255.html) e ocupar perto de [30% das bolachas de DRAM](https://www.trendforce.com/presscenter/news/20260602-13074.html) dos três maiores fabricantes até o fim de 2027.
- A Micron [saiu do mercado consumidor](https://www.storagenewsletter.com/2025/12/05/micron-announces-exit-from-crucial-consumer-business/) e matou a Crucial, nas palavras dela, pra atender melhor os clientes estratégicos maiores.
- PC e console subiram de preço, e a Microsoft [atribuiu o aumento do Xbox](https://www.digitalcitizen.life/xbox-series-x-and-series-s-prices-will-rise-again-as-memory-and-storage-costs-surge/) ao custo de memória e armazenamento.
- A RTX 5090, quando aparece nos Estados Unidos, custa de [duas vezes e meia](https://gpupoet.com/gpu/market-report/gpu-market-report-october-2026) a [quase cinco vezes](https://www.techspot.com/news/114254-nvidia-rtx-5090-production-but-absence-company-us.html) o preço sugerido, e o boato é que os chips dela vão pras linhas profissionais. A NVIDIA [nega a descontinuação](https://www.guru3d.com/story/nvidia-says-geforce-rtx-5090-production-is-continuing/).
- Do outro lado, a Anthropic [pediu IPO](https://techcrunch.com/2026/06/01/anthropic-files-to-go-public/) mirando, segundo a imprensa, [uns 2 trilhões de dólares](https://www.khaleejtimes.com/business/anthropic-says-revenue-jumped-to-nearly-17b-last-quarter-reports-2), e a OpenAI está [captando a mais de 1,4 trilhão](https://uk.investing.com/news/stock-market-news/openai-races-to-raise-30-bln-ahead-of-anthropic-ipo-reuters-reports-4918623).
- E o discurso sobre modelo aberto chinês endureceu. A Anthropic publicou que [DeepSeek, Moonshot e MiniMax destilaram o Claude](https://www.anthropic.com/news/detecting-and-preventing-distillation-attacks), e o Dario Amodei, mesmo dizendo que [nunca defendeu proibir pesos abertos](https://www.anthropic.com/news/position-open-weights-models), pede controle de exportação de chip e teste obrigatório, antes do lançamento, de todo modelo suficientemente capaz, aberto ou fechado.

### O ciclo

A explicação mais simples pra memória cara é demanda: datacenter compra tudo e paga mais. Eu acredito nela. O que me incomoda é que nenhum participante grande tem incentivo pra quebrar o ciclo:

1. O discurso diz que só o laboratório de fronteira sabe lidar com esses modelos "perigosos", e que open source é uma aposta arriscada.
2. Isso puxa a demanda pra nuvem, e a nuvem compra GPU e memória em volume recorde.
3. Os fabricantes vendem com ágio pra quem paga mais e tiram prioridade do consumidor.
4. O hardware bom fica inacessível fora do datacenter.
5. Sem hardware em casa, o open source não é adotado, o que reforça o discurso do passo 1.

> Se todo mundo começasse a hospedar o próprio modelo, as contas de IPO de trilhões de dólares deixariam de fechar. O v4 mostrou que o modelo aberto já está pronto pra boa parte do trabalho. O que falta é o hardware chegar na mão de quem trabalha.
