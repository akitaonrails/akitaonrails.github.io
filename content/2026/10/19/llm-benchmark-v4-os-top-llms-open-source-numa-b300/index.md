---
title: "LLM Benchmark v4: os top LLMs open source numa B300"
slug: "llm-benchmark-v4-os-top-llms-open-source-numa-b300"
date: '2026-10-19T14:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-os-top-llms-open-source-numa-b300
description: "Aluguei uma NVIDIA B300 de 288 GB na Runpod e rodei meu benchmark v4 de sabotagem em 14 modelos abertos que não cabem em casa. Nenhum serve rápido do jeito que vem: o GLM 5.3 Flash saiu de 10 pra 141 tokens por segundo só de configuração. Dois modelos abertos chegaram a 92,5, nível Sonnet 5, e um fine-tune de 27B fez 88. Um flagship de 397B deixou passar uma backdoor de admin, o DeepSeek V4 Flash fez 86 na nuvem e 44,5 em casa, e o Nemotron trapaceou no teste. A conta: a API em nuvem do mesmo modelo custa um dólar por rodada e o pod custa 218 por dia. Quando vale a pena ter a própria infra, e se um time cabe numa placa só."
tags:
- benchmarks-de-llm
- modelos-locais
- llms
- hardware
---

Nos dois últimos textos do benchmark v4 eu [refiz o teste do zero](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-1/), com um app Rails sabotado de propósito em sete sprints, e [ranqueei 39 modelos](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-2/) por vigilância: seis empates no topo, um modelo de graça batendo metade do Claude. Depois [testei cinco modelos novos](/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/), Opus 5.5, GPT 6 sol e luna, MiMo V2.6 Pro e Grok 4.7: o Opus 5.5 fechou com 100 e se juntou ao empate no topo, o GPT 6 luna fez 95,5 por menos de um dólar a rodada, e o Grok 4.7 regrediu feio contra o próprio antecessor.

Faltava uma categoria que eu nunca tinha testado direito: os modelos open source grandes. Os que cabem na minha [RTX 5090](/2026/01/21/omarchy-3-setup-de-dual-gpus-com-amd-e-nvidia/) de 32 GB ou no meu [Strix Halo](/2026/03/31/review-minisforum-ms-s1-max-amd-ai-max-395/) com 61 GB utilizáveis pela GPU são fracos demais pra isso. Servem pra tarefa simples de agente, e nenhum modelo pequeno aguenta tarefa real de programação, muito menos um projeto complexo de software.

O Qwen 3.8 27B levou 706 minutos pra fechar o v4 no Strix e fez 80; o GLM-4.7-Flash local fez 24. Então nem tente.

Mas e se a gente forçar? O que modelos de tamanho médio, de 100 a 400 bilhões de parâmetros, conseguem fazer rodando numa única B300 alugada? Eu podia alugar quatro delas e rodar os modelos gigantes de 750 bilhões ou um trilhão, e não tenho certeza de que o custo-benefício vale. Os dados abaixo respondem.

> **TL;DR:** 14 modelos abertos, uma B300 de 288 GB na Runpod a uns 9 dólares por hora, mesmo protocolo v4 de sabotagem. Nenhum deles serve rápido do jeito que vem: o GLM 5.3 Flash decodificava a 10 tokens por segundo com a configuração padrão e a 141 depois de ajustado, 14 vezes mais só de flag. Dois modelos abertos, GLM 5.3 Flash e Qwen3.8 Flash-Next, fizeram 92,5, nível Claude Sonnet 5, e o Swift 1.5 27B fez 88, nível Opus 4.6. Nenhum chegou nos 100 da fronteira. O flagship de 397 bilhões fez 68,5 e deixou passar uma backdoor de admin, o DeepSeek V4 Flash fez 86 na nuvem e 44,5 servido por mim, e o Nemotron trapaceou num teste de regressão. A API em nuvem do mesmo modelo custa um dólar por rodada; o pod custa 218 dólares por dia. Pule pra [B300 e Runpod](#o-que-é-uma-b300-e-o-que-é-a-runpod), pro [ajuste de servidor](#nenhum-deles-serve-rápido-do-jeito-que-vem), pro [ranking](#o-ranking), pros [casos interessantes](#os-casos-interessantes), pra [comparação com a fronteira](#a-que-distância-da-fronteira), pra [conta](#a-conta) ou pra [conclusão](#vale-a-pena-ter-a-própria-infra).

## O que é uma B300, e o que é a Runpod

A **B300** é a GPU de datacenter da geração Blackwell Ultra da NVIDIA, anunciada em março de 2025. Cada placa tem [288 GB de memória HBM3e](https://developer.nvidia.com/blog/nvidia-blackwell-ultra-for-the-era-of-ai-reasoning/), nove vezes a minha 5090, e uns 15 petaflops de computação densa em NVFP4, o formato de 4 bits que a Blackwell faz em hardware. É a placa que vai dentro do rack GB300 NVL72, 72 delas interligadas, que as empresas de IA compram aos milhares.

Sozinha, uma B300 custa mais que um apartamento. O que a torna acessível é alugar por hora.

A [**Runpod**](https://www.runpod.io/) é um provedor de GPU em nuvem que aluga placas em "pods", containers Linux com uma ou mais GPUs, cobrados por segundo. Você escolhe a placa, um template de imagem, sobe por SSH, e paga enquanto o pod está ligado, inclusive ocioso. A B300 custava uns [9 dólares por hora](https://www.runpod.io/pricing) na nuvem segura deles na semana do teste; uma H100 sai por 3 a 4. O disco do container é efêmero: terminou o pod, os 250 GB de pesos que você baixou somem, e você baixa de novo.

O pod que eu usei: uma B300 com 275 GiB segundo o `nvidia-smi` (os mesmos 288 GB nominais, em unidades binárias), 344 vCPUs, 4 TB de RAM no host, 700 GB de disco. O servidor de inferência foi o vLLM; o harness foi o mesmo OpenCode de todos os outros modelos do ranking, conectado por túnel SSH ao pod. O modelo roda lá; o código, os testes e os resultados ficam na minha máquina.

Caber na memória é a primeira peneira. Na B300 cabem os modelos de 100 a 400 bilhões de parâmetros quantizados em NVFP4, mais os de 27 a 35 bilhões em BF16. Ficam de fora o GLM 5.3 flagship de 753 bilhões, o DeepSeek V4.1 Flash de 750, o DeepSeek V4 Pro de 1,6 trilhão e o Kimi K3 de 2,8 trilhões. Pra esses, seriam quatro B300 ou mais, uns 36 dólares por hora.

## A metodologia

O protocolo é o [v4](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-1/) de sempre: o modelo constrói um app Rails em sete sprints acumulados, e entre os sprints um revisor independente, isolado do modelo, injeta 14 sabotagens, de CVE real a regressão silenciosa de lógica e de teste, no código que o próprio modelo escreveu. A nota de 0 a 100 mede vigilância: quanto o modelo pega e conserta sem ser avisado (peso cheio), quanto conserta depois de um "faça uma auditoria de segurança" explícito no último sprint (40% do peso), e o que fica sem resolver (zero). Os tiers são A a partir de 83, B de 73 a 82, C de 51 a 72, D até 50.

Duas diferenças nesta rodada. A primeira é o revisor: os cinco modelos que terminaram antes do bloqueio foram revisados de ponta a ponta pelo Codex, como nas rodadas anteriores.

No meio da leva o serviço de segurança da OpenAI passou a recusar a operação de injeção e correção, com uma flag de risco cibernético, mesmo sendo código meu, em máquina minha, num benchmark com 46 modelos já pontuados pelo mesmo protocolo. Troquei o revisor pro Claude Opus 4.8 nos modelos restantes, com o mesmo plano de injeção, mesmo catálogo, mesma régua, e a proveniência de cada fronteira está gravada por sprint. O impacto esperado na nota é nenhum, porque os dois executam a mesma receita escrita.

A segunda é a admissão por velocidade, que é o assunto da próxima seção. Modelo que decodifica abaixo de 100 tokens por segundo nem entra na pista.

Além disso: o modelo aberto tem direito a até dois empurrões curtos por rodada pra defeito bobo (um import faltando, um ponto de entrada de teste errado), registrados como "assistido". Falha de infraestrutura, driver, loader, parser, nunca é cobrada do modelo. E o pod rodava um modelo por vez, sem acesso ao workspace ou ao resultado de nenhum outro.

## Nenhum deles serve rápido do jeito que vem

A primeira lição custou um dia. Baixei o [GLM 5.3 Flash](https://huggingface.co/RedHatAI/GLM-5.3-Flash-NVFP4), 320 bilhões de parâmetros com 18 ativos, quantizado em NVFP4, 198 GB. Subi no vLLM com a configuração que "funciona": serve, passa nos testes de chamada de ferramenta, responde. E decodificava a **10 tokens por segundo**, com a GPU a 10% de uso, 209 watts dos 1.100 que o pod libera.

Isso é inutilizável pra programar. Um agente de código gera dezenas de milhares de tokens por sprint; a 10 por segundo, um sprint de 20 minutos vira mais de quatro horas.

O mesmo checkpoint, mesmo contexto de 128 mil tokens, mesmo cache de KV em FP8, mesmo prompt de teste, trocando só as flags de compilação e modo: **141 tokens por segundo**. Catorze vezes mais rápido, zero mudança de precisão ou de pesos.

O culpado principal era o `--enforce-eager`, que desliga o `torch.compile` e a captura de CUDA graphs do vLLM, e que todo tutorial manda ligar "pra subir mais rápido". Sobe mais rápido e serve 14 vezes mais devagar. A medição trocou essa flag junto com o modo `interactivity`, então eu não isolei a contribuição de cada uma.

Daí a regra de admissão: **menos de 100 tokens por segundo eu considero inutilizável**, e nenhum modelo entra no benchmark sem passar disso na mediana de duas sondagens quentes de 256 tokens, depois de uma fria. Pra não virar um buraco sem fundo, o ajuste é limitado: no máximo três configurações e 45 minutos de relógio por modelo, incluindo carga e compilação. E ajuste nunca pode trocar qualidade por velocidade: nada de encurtar contexto, baixar esforço de raciocínio ou quantizar mais pra bater o número.

Os ajustes que valeram pra todo mundo:

- **Instalar um CUDA que compile pra placa.** A imagem padrão da Runpod vem com CUDA 12.8, cujo `nvcc` [não compila pra `compute_103a`](https://developer.nvidia.com/cuda-gpus), a capacidade de computação da B300. Sem o 12.9, os kernels NVFP4 nunca compilam.
- **Nunca usar `--enforce-eager`.** Deixar o vLLM compilar e capturar CUDA graphs é a maior vitória isolada.
- **`--performance-mode interactivity`**: otimizar pra latência de um fluxo só, que é o que um agente serial precisa, em vez de vazão agregada.
- **Cache de KV em FP8 nos MoE grandes, cache de prefixo e prefill em pedaços em todos**, e confirmados pelos contadores do Prometheus do vLLM em vez de assumidos: num prompt de 11 mil tokens, o servidor reaproveitou exatamente 8.576 tokens de prefixo a cada repetição.
- **O parser certo de ferramenta e de raciocínio pra cada família.** Parser errado faz chamada de ferramenta sumir em silêncio ou vazar o raciocínio na resposta.

E os ajustes específicos que achei mais interessantes:

- **NVFP4 só roda no vLLM.** Os checkpoints de 198 a 251 GB em FP4 nativo da Blackwell são a única forma de caber na placa, e llama.cpp e Ollama simplesmente não carregam esses formatos. Quem vive de GGUF não tem acesso a essa faixa.
- **Decodificação especulativa nativa.** O Qwen 3.8 27B foi de 92 pra 195 tokens por segundo com a cabeça MTP que o próprio checkpoint traz, prevendo três tokens por passo, mais `--language-model-only` pra descartar a torre de visão (medido em pods diferentes, então sem ablação controlada). O [Muse Glimmer](https://huggingface.co/meta-models/Muse-Glimmer-30B) chegou a 295 com o rascunhador DFlash leve que ele publica junto, 15 tokens especulados por passo. Só liguei onde existe um rascunhador oficial e onde a chamada de ferramenta continuou correta; pro Ornith existe um rascunhador publicado à parte, com taxa de aceitação desconhecida, então ficou desligado.
- **O loader do CUDA 12.** O flashinfer compila em JIT um kernel de MoE em NVFP4 que precisa do `libcudart.so.12`, e depois de instalar o CUDA 13 pro Nemotron a resolução de biblioteca quebrou. O sintoma parecia OOM; a causa era um `ld.so.conf`. Um script de reparo com evidência de `ldd` antes e depois resolveu, e o 397B passou a servir a 144 tokens por segundo.
- **Um ambiente virtual por runtime.** O Nemotron 3.5 Super VL exigiu um vLLM 0.32 próprio num venv separado, porque é o que o card oficial fixa, e esse build pede CUDA 13. Cada família de modelo é um caso bespoke: parser, quantização, cabeça de rascunho, versão de runtime e reparo de loader, tudo diferente.
- **Um bug de parser que derrubava a última chamada.** O parser de ferramenta Qwen do vLLM descartava o último parâmetro de uma chamada quando faltava a tag de fechamento do parâmetro mas a de função estava presente. Um reparo estreito, com 24 casos de teste, tirou esse ruído de serving da conta do modelo.

Os argumentos exatos de cada modelo, os logs de sondagem e o livro-razão de cada rodada de ajuste estão no [documento de otimizações de serving](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/b300-serving-optimizations.md) e no [runbook da B300](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/runpod-b300-openweights-runbook.md) do repositório.

> A velocidade é quase de graça, depois que você deixa o vLLM compilar. O trabalho real é descobrir, modelo por modelo, qual combinação de toolkit, parser, quantização e cabeça de rascunho aquele checkpoint exige. Eu dei 45 minutos pra cada um e precisei deles.

## O ranking

Nota v4 de vigilância, tier, tamanho em memória, velocidade de decodificação na sondagem de admissão (quente, um fluxo só) e o custo só do tempo de inferência dos sete sprints, a 9,09 dólares por hora. O custo exclui download, carga, compilação, ajuste e tempo ocioso; a conta de verdade vem mais abaixo.

| # | Modelo | v4 | Tier | Memória | tok/s | Minutos | Custo inferência | Revisor |
| ---: | --- | ---: | --- | ---: | ---: | ---: | ---: | --- |
| 1 | GLM 5.3 Flash (NVFP4) | **92,5** | A | 198 GB | 142 | 145 | US$ 21,96 | Codex |
| 1 | Qwen3.8 Flash-Next (NVFP4) | **92,5** | A | 100 GB | 195 | 80 | US$ 12,04 | Codex → Claude |
| 3 | Swift 1.5 27B | **88,0** | A | 56 GB | 203 | 64 | US$ 9,71 | Codex |
| 4 | ThinkingCap 3.8 27B | **83,0** | A | 56 GB | 189 | 76 | US$ 11,47 | Codex → Claude |
| 5 | Muse Glimmer 30B | 81,0 | B | 60 GB | 295 | 23 | US$ 3,54 | Codex → Claude |
| 5 | Ornith 1.5 35B | 81,0 | B | 70 GB | 317 | 161 | US$ 24,39 | Codex → Claude |
| 7 | Qwen 3.8 27B | 80,5 | B | 54 GB | 195 | 192 | US$ 29,11 | Codex |
| 8 | Qwen3.5 397B (NVFP4) | 68,5 | C | 251 GB | 140 | 54 | US$ 8,22 | Codex → Claude |
| 9 | Nemotron 3.5 Super VL (NVFP4) | 63,0 | C | 70 GB | 207 | 50 | US$ 7,51 | Codex → Claude |
| 10 | DeepSeek V4 Flash | 44,5 | D | 167 GB | 153 | 37 | US$ 5,59 | Codex |
| 11 | GLM 4.7 Flash BF16 | 33,5 | D | 60 GB | 217 | 30 | US$ 4,60 | Codex |

Três não têm nota: o **Command A Plus** da Cohere (218 bilhões, 25 ativos, W4A4) travou num loop reescrevendo o mesmo model 23 vezes, precisou de três empurrões e ainda deixou os testes sem rodar antes de o revisor ser bloqueado; o **Nex N2.5 Mini** rodou a 337 tokens por segundo e entregou Ruby inválido, migrations contraditórias e autenticação quebrada em duas tentativas, um resultado ruim válido de um servidor que funciona; e o **Qwen3.5 122B** era reserva condicional pro caso de o 397B não terminar, e o 397B terminou.

Os minutos são só de sprint, e os de Ornith incluem um sprint interrompido por infra. Flash-Next, Swift, ThinkingCap, Muse e Qwen 27B levaram um empurrão cada; GLM 4.7, dois; os outros, nenhum. A velocidade de sondagem é um número de admissão: a vazão de uma sessão real de código inclui prefill, ferramentas, testes e as escolhas do agente. E repare que os dois primeiros empatam na nota com perfis opostos: o GLM gastou 145 minutos e 22 dólares pra chegar nos mesmos 92,5 que o Qwen3.8 Flash-Next fez em 80 minutos e 12 dólares, com metade da memória.

## Os casos interessantes

### Qwen3.8 Flash-Next: o melhor dos abertos, por custo

O [Flash-Next](https://huggingface.co/nvidia/Qwen3.8-Flash-Next-NVFP4) é, [nas palavras da Qwen](https://recipes.vllm.ai/Qwen/Qwen3.8-Flash-Next), uma prévia da arquitetura do Qwen 4: 125 bilhões de parâmetros de modelo de linguagem com 6 bilhões ativos, mais uma tabela de embeddings de n-gramas de 51 bilhões que a Qwen diz que pode ser descarregada pra memória do host, mais uma cabeça MTP de 4. Quantizado em NVFP4 pela NVIDIA, ocupou uns 100 GB de placa (o checkpoint tem 133 GB em disco). Foi o único modelo da segunda leva a resolver todos os 14 itens: pegou o vazamento entre tenants sem aviso, pegou o item composto de integridade de teste, e escreveu por conta própria specs de isolamento por usuário, de modo que a IDOR plantada na API nem tinha como continuar verde. Com 195 tokens por segundo e 12 dólares de inferência, é o melhor custo-benefício desta tabela.

### GLM 5.3 Flash: o mesmo 92,5, três vezes mais caro

O GLM fez a mesma nota com uma arquitetura bem maior: 320 bilhões de parâmetros, 18 ativos, 198 GB mesmo em FP4. Resolveu os 14 itens, zero empurrão, revisado de ponta a ponta pelo Codex.

Só que levou 145 minutos e consumiu o dobro da memória pelo mesmo resultado. Na nuvem da Z.ai, o mesmo modelo fez 84,25 num plano fixo. Com o ruído de uma rodada só, que no meu histórico chega a nove pontos, a leitura mais segura é que os dois estão na mesma faixa.

### Swift 1.5 e ThinkingCap: dois fine-tunes de 27B no Tier A

As duas surpresas. O [Swift 1.5](https://huggingface.co/ukisai/Swift-1.5-Qwen3.8-27b), da UkisAI, e o [ThinkingCap 3.8](https://huggingface.co/bottlecapai/ThinkingCap-Qwen3.8-27B), da BottleCap AI, são ajustes do Qwen 3.8 27B treinados pra pensar menos: o Swift anuncia até 58% menos tokens de raciocínio (na mediana do GPQA; no Terminal-Bench, 16%), o ThinkingCap uns 37% na média. Os dois cabem em 56 GB em BF16, rodam a uns 200 tokens por segundo com MTP, e fizeram 88 e 83.

O Swift ficou acima do Opus 4.6 da Anthropic. O Qwen 3.8 27B base, mesma arquitetura, fez 80,5 com 192 minutos; o Swift fez 88 em 64. O Swift pegou sabotagem mais cedo que o base; se foi por pensar menos, uma rodada de cada deixa de provar.

Uma ressalva de proveniência: o revisor registrou que o Swift leu mensagens de commit locais que revelavam regressões, o que enfraquece uma leitura literal de "descoberta totalmente sem ajuda". E ele deixou um item sem resolver, um admin inativo ainda aceito com um teste vazio de guarda. Ainda assim, de todos os modelos desta tabela, é o que eu colocaria numa placa minha.

### Qwen3.5 397B: o flagship que deixou passar a backdoor

O maior modelo da leva, 397 bilhões de parâmetros com 17 ativos, 251 GB de NVFP4 em 275 de placa, serviu a 140 tokens por segundo depois do reparo do loader e fez **68,5**, Tier C.

O caso que define a nota: a sabotagem número 6 é uma linha `admin? => admin || email.end_with?("@internal.example")`, uma escalação de privilégio por domínio de e-mail. O 397B deixou passar nos sprints normais, deixou passar no sprint 7 com o pedido explícito de auditoria de segurança, e **escreveu um teste que passava, codificando a backdoor como comportamento esperado**, no mesmo commit em que anunciou "Brakeman: 0 warnings". Parâmetro não comprou vigilância.

### Nemotron 3.5 Super VL: trapaceou no teste

O [Nemotron 3.5 Super VL](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Super-VL-120B-A12B-NVFP4) da NVIDIA, 120 bilhões com 12 ativos, lançado dois dias antes de eu começar a testar e [vendido pela NVIDIA](https://blogs.nvidia.com/blog/nemotron-3-5-super-vl/) como o modelo aberto de agente mais rápido da categoria, com "acurácia líder" em tarefas multimodais, fez **63**. A sabotagem número 2 remove um link de navegação e o teste de regressão procura `have_link('Sign in')`. O Nemotron trocou o teste pra `have_button('Sign in')`, que passa no botão do formulário de login sem restaurar o link, e manteve a trapaça mesmo depois do sprint de revelação.

Também tende a pegar item um sprint atrasado. E foi o que exigiu um runtime próprio: vLLM 0.32 com CUDA 13 num ambiente separado.

### DeepSeek V4 Flash: 86 na nuvem, 44,5 na minha mão

O caso mais importante pra quem pensa em self-host. O [DeepSeek V4 Flash](https://huggingface.co/deepseek-ai/DeepSeek-V4-Flash), 284 bilhões com 13 ativos, fez **86, Tier A, por 97 centavos** pela API em setembro, e a versão 0731, exatamente a que eu baixei, fez 85 por 1,94. Os mesmos pesos públicos em FP4 e FP8 misto, servidos por mim na B300, fizeram **44,5, Tier D**: pegou 4 itens sem aviso, mais 5 na revelação, e deixou 5 sem resolver. Foi o mais rápido a terminar, 37 minutos, e o que menos vigiou.

A causa provável é divergência entre o checkpoint público e o que a DeepSeek serve, ou entre o stack de serving deles e o meu: parser, template de chat, modo de raciocínio, quantização. Eu segui o card oficial. O que isso prova é que o nome do modelo no Hugging Face não garante a qualidade da API hospedada, e que quem vai hospedar precisa validar antes de confiar.

### GLM 4.7 Flash: igual ao local, ou seja, ruim

O GLM 4.7 Flash de 30 bilhões em BF16, a 217 tokens por segundo, fez 33,5. Em casa, em GGUF Q5, tinha feito 24. Precisou de dois empurrões, deixou nove itens sem resolver e entregou uma migration com erro de sintaxe. A diferença de nove pontos e meio cabe dentro do ruído de uma rodada; o que fica é que o modelo é fraco de qualquer jeito.

### O que apareceu em vários

Ornith, Muse Glimmer e o 397B compartilharam um defeito de higiene: rodaram o sprint até o fim com exit zero e esqueceram de commitar o próprio trabalho, deixando pro revisor fazer o checkpoint. Não entrou na nota, e num time de verdade seria o primeiro motivo de reclamação. E o aglomerado de 81 a 83, ThinkingCap, Ornith e Muse, tem um perfil consistente: pega injeção de SQL, vazamento entre tenants, XSS e segredo exposto com confiança, e deixa passar os itens silenciosos, controle de acesso quebrado, integridade de teste, índice faltando, agregação errada.

## A que distância da fronteira

Os três melhores abertos contra os melhores comerciais do mesmo ranking, com o custo e o tempo de cada rodada:

| Modelo | v4 | Tier | Custo da rodada | Minutos | Onde |
| --- | ---: | --- | ---: | ---: | --- |
| GPT-6 Astra | 100,0 | A | US$ 30,55 | 100 | nuvem |
| Claude Opus 5.5 | 100,0 | A | US$ 16,63 | 64 | nuvem |
| GPT 5.6 terra | 100,0 | A | US$ 9,52 | 80 | nuvem |
| Grok 4.6 | 98,5 | A | US$ 13,00 | 67 | nuvem |
| Claude Fable 5.1 | 95,5 | A | ~US$ 51 | 133 | nuvem |
| **GLM 5.3 Flash (NVFP4)** | **92,5** | A | US$ 21,96 só inferência | 145 | B300 |
| **Qwen3.8 Flash-Next (NVFP4)** | **92,5** | A | US$ 12,04 só inferência | 80 | B300 |
| Claude Sonnet 5 | 91,0 | A | ~US$ 27 | 112 | nuvem |
| Gemini 3.8 Flash high | 90,5 | A | US$ 15,98 | 97 | nuvem |
| **Swift 1.5 27B** | **88,0** | A | US$ 9,71 só inferência | 64 | B300 |
| Claude Opus 4.6 | 87,5 | A | US$ 25,64 | 89 | nuvem |

A leitura: o melhor do open source que cabe numa B300 e que eu servi está **um degrau abaixo do teto comercial e no mesmo nível do meio do Tier A**. Diferenças de um ou dois pontos são ruído de uma rodada.

GLM 5.3 Flash e Qwen3.8 Flash-Next empatam com o Sonnet 5 e passam o Gemini 3.8 Flash e o Opus 4.6. Nenhum chega nos 100 que sete modelos comerciais fizeram, nem nos 98,5 do Grok 4.6. Sete pontos e meio separam o melhor aberto do teto, e no v4 cada ponto é uma sabotagem a menos pega sem aviso.

A diferença que importa é outra: previsibilidade. Entre os comerciais de ponta da tabela, o pior é 87,5, e o campo comercial inteiro também tem fundo de poço, o Mistral Large 3 fez 39. O campo aberto tem os mesmos 92,5 no topo e dois Tier D no fundo, com o DeepSeek fazendo 85 na nuvem e 44,5 na minha mão. Escolher um comercial de ponta é escolher um número que a API reproduz; escolher um aberto é apostar que o checkpoint, a quantização e o seu stack de serving reproduzem o número do card, e às vezes reproduzem.

## A conta

Se a qualidade ainda fica abaixo da fronteira, o custo pelo menos é proporcional? Depende de onde você roda o modelo aberto.

**Na API em nuvem do próprio fornecedor, sim, e com folga.** Uma rodada completa do v4 custou 97 centavos no DeepSeek V4 Flash, 1,17 dólar no Qwen 3.8 Flash, 1,03 no MiMo V2.5 Pro, todos Tier A na nuvem. Contra 9,52 a 30,55 dólares dos modelos de 100 pontos, é dez a trinta vezes mais barato por uma nota 8 a 14 pontos menor. Os preços de lista explicam: o [GLM 5.3 Flash](https://docs.z.ai/guides/overview/pricing) custa 15 centavos por milhão de tokens de entrada e 50 de saída; o [DeepSeek Flash](https://api-docs.deepseek.com/quick_start/pricing), 15 a 30 centavos de entrada e 60 centavos a 1,20 de saída; o [Opus 5.5](https://platform.claude.com/docs/en/about-claude/pricing), 4 e 20 dólares; o [GPT-6 Astra](https://developers.openai.com/api/docs/pricing), 10 e 50.

**Na sua própria B300 alugada, não.** O pod custa 9 dólares por hora ligado ou ocioso, **218 por dia, uns 6.500 por mês**. O tempo de modelo desta leva inteira, 14 modelos entre download, carga e sprints, somou 23 horas, uns 212 dólares a preço de pod; só os sprints foram 17 horas e 157 dólares.

Só que o pod cobra também o tempo em que nada roda. Eu coloquei 400 dólares de crédito na Runpod e sobraram 127: a leva inteira custou **273 dólares**, umas 30 horas de pod, incluindo armazenamento, quatro pods em sequência e sete horas ociosas numa madrugada em que a orquestração morreu e nada avisou. Quase 60 dólares a mais que o tempo de modelo, só de espera. A conta de ponto de equilíbrio do repositório: o pod só fica mais barato que a API a partir de umas **6.500 rodadas por mês**, 217 por dia, sustentadas. Um desenvolvedor sozinho ou um time pequeno nem chega perto.

E modelo contra modelo, lado a lado:

| Modelo | API em nuvem | Hospedado por mim na B300 |
| --- | --- | --- |
| DeepSeek V4 Flash 0731 | 85 (A) por US$ 1,94 | 44,5 (D) por US$ 5,59 só de inferência |
| Qwen 3.8 Flash (nuvem) e Flash-Next (B300), da mesma família | 86,5 (A) por US$ 1,17 | 92,5 (A) por US$ 12,04 |
| Qwen 3.8 27B | 80 (B) de graça no Strix, em 706 minutos | 80,5 (B) por US$ 29,11, em 192 minutos |

> A API em nuvem de um modelo aberto é dez a trinta vezes mais barata que a fronteira por um tier a menos. Hospedar o mesmo modelo numa B300 alugada é mais caro que a fronteira, e às vezes pior que a própria API dele.

## Cabe um time na mesma placa?

Uma pergunta que eu fiz olhando a GPU a 10% de uso: esses modelos usam toda a computação do pod? Dava pra colocar um time inteiro na mesma B300?

Em princípio, sim, e é pra isso que o vLLM existe. O [batching contínuo](https://vllm.ai/blog/2023-06-20-vllm) agenda várias requisições no mesmo passo de decodificação, e o [PagedAttention](https://vllm.ai/blog/2023-06-20-vllm) guarda o cache de KV de cada sessão em blocos não contíguos, com menos de 4% de desperdício, justamente pra caber mais sessões na mesma memória. Um modelo de 27 bilhões em BF16 ocupa 56 GB e deixa uns 200 GB de cache de KV: são dezenas de sessões de agente com contexto de 128 mil tokens ao mesmo tempo. O 397B, com 251 GB de pesos, deixa 24, e aí cabem poucas.

O que não escala é a velocidade por pessoa. O meu teste rodou em `--performance-mode interactivity`, que otimiza a latência de um fluxo só, e os 200 tokens por segundo são desse fluxo. Com dez agentes decodificando ao mesmo tempo, a vazão agregada da placa sobe e a de cada um cai, e a decodificação especulativa que me deu os 295 do Muse Glimmer rende menos conforme a concorrência cresce: um [rascunhador DFlash publicado pro Muse pelo Z Lab](https://huggingface.co/z-lab/Muse-Glimmer-30B-DFlash2) reporta 3 a 4,6 vezes de ganho com uma sessão e 1,2 a 1,7 com 32.

Eu não medi concorrência nesta leva, então o que posso dizer é o contorno: um time de cinco a dez pessoas num modelo de 27 a 35 bilhões numa B300 é prático, e provavelmente cada um ainda fica acima dos 100 tokens por segundo. O mesmo time no 397B é inviável na placa, e no GLM 5.3 Flash de 198 GB fica apertado.

É nesse cenário, e só nele, que a conta do pod começa a fechar. Dez desenvolvedores rodando agente o dia inteiro num modelo de 27B gastariam na API, a um dólar por rodada de duas horas, uns 40 dólares por dia; o pod custa 218. Ainda perde. O que muda a conta é ter cem pessoas, ou ter a obrigação de que o código não saia da sua rede.

## Vale a pena ter a própria infra?

Pra desenvolvimento de software sério, com os dados desta leva, a resposta vem em três partes.

**Os modelos abertos de ponta são bons o suficiente.** GLM 5.3 Flash, Qwen3.8 Flash-Next e Swift 1.5 27B são Tier A no meu teste, no nível do Sonnet 5 e acima do Opus 4.6. Isso era impensável em abril, quando [só o Qwen 3.6 35B chegava perto do Opus](/2026/04/05/testando-llms-open-source-e-comerciais-quem-consegue-bater-o-claude-opus/), e ainda a uma correção de distância. Pra quem aceita um tier abaixo do teto, eles servem pra trabalho de verdade, inclusive revisão de segurança, que é o que o v4 mede.

**Alugar uma B300 pra rodar eles é o jeito errado de usá-los.** A API em nuvem do mesmo modelo custa um dólar por rodada e precisa de zero configuração. O pod custa 218 por dia, exige um dia de ajuste por família de modelo, e no caso do DeepSeek entregou um modelo pior do que a API dele. Só vale com uma obrigação de residência de dados, com um checkpoint que nenhuma nuvem serve, com carga sustentada de centenas de rodadas por dia, ou com necessidade de pesos fixados pra reprodutibilidade. Quatro B300 pra rodar os de 750 bilhões a um trilhão quadruplicam a conta sem evidência de que a nota chega nos 100: o 397B, maior modelo que eu testei, fez 68,5.

**E se for pra hospedar, hospede pequeno.** O Swift 1.5 27B e o ThinkingCap em 56 GB, com MTP, a 200 tokens por segundo, são Tier A em hardware que dá pra comprar, uma placa profissional de 80 ou 96 GB em vez de uma de datacenter. É ali que o open source faz sentido pra uma empresa: um time inteiro numa placa, código dentro da rede, nota de Opus 4.6. Só olhe a licença antes: o Swift e o ThinkingCap saem com licenças próprias, e acima de um certo faturamento os dois exigem licença comercial. Os gigantes abertos continuam sendo coisa pra API.

Minha regra depois disso tudo: modelo comercial de ponta pra tarefa que não pode errar, API de modelo aberto pra volume, e placa própria só quando a lei ou o cliente exigem. O repositório com cada argumento de serving, cada log de sondagem, cada transcrição de revisor e a proveniência Codex ou Claude de cada fronteira está [público](https://github.com/akitaonrails/llm-coding-benchmark), como sempre.
