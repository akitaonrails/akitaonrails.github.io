---
title: "LLM Benchmark: Kimi v2.7 code, GLM 5.2, Minimax M3 local"
slug: "llm-benchmark-kimi-v2-7-code-glm-5-2-minimax-m3-local"
date: '2026-06-14T13:00:00-03:00'
draft: false
translationKey: llm-benchmark-kimi-2-7-glm-5-2-minimax-m3-local
description: "No benchmark, GLM 5.2 marcou 87 e Kimi K2.7 Code, 86. O MiniMax M3 aberto não cabe em 128 GB, enquanto programação séria ainda pede Opus 4.8 ou GPT 5.5."
tags:
- benchmarks-de-llm
- llms
- modelos-locais
---

Mais uma rodada do meu benchmark de coding. Dessa vez são três entradas open source: o **Kimi K2.7 Code**, o **GLM 5.2**, e o **MiniMax M3** que ganhou pesos abertos mas que eu não consigo rodar em casa nem espremendo. Antes de chegar nos números, vale o contexto de sempre pra quem caiu aqui de paraquedas, e vale uma atualização da novela dos data centers, porque tem coisa nova.

## Pra quem chegou agora

Esse benchmark dá pra cada modelo o mesmo prompt e pede pra construir, sozinho, um app de chat estilo ChatGPT em Rails 8 + RubyLLM + Hotwire + Docker, com testes e CI. A nota sai de uma rubrica de 8 dimensões, de 0 a 100, em tiers A/B/C/D. A série inteira:

1. [Benchmark canônico de Maio (Parte 3)](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/). A metodologia completa e a referência do ranking.
2. [DeepSeek destravado com DeepClaude](/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/). Troca de harness tirando o V4 Pro do limbo.
3. [Update Grok 4.3, MiniMax M3, Opus 4.8](/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/). O M3 estreando via cloud.
4. [Fable 5 e a novela da Anthropic](/2026/06/11/llm-benchmark-fable-5-e-a-novela-da-anthropic/). O primeiro Mythos-class público.

## A novela dos data centers ganhou um capítulo: SpaceX

Nos últimos posts eu venho batendo na mesma tecla: a construção de data center virou o gargalo da era da IA, e a demanda passou por cima da base instalada com folga. [Quase metade dos data centers planejados nos EUA pra 2026 foi adiada ou cancelada](https://www.techradar.com/pro/if-one-piece-of-your-supply-chain-is-delayed-then-your-whole-project-cant-deliver-nearly-half-of-us-data-centers-planned-for-2026-canceled-or-delayed-and-things-could-soon-get-much-worse), travada em transformador e componente elétrico com fila de três anos. Detalhei isso no [post do Fable](/2026/06/11/llm-benchmark-fable-5-e-a-novela-da-anthropic/).

O capítulo novo é financeiro. A **SpaceX abriu capital** e foi o maior IPO da história de Wall Street: [556 milhões de ações a US$ 135, avaliação de US$ 1,77 trilhão, com mais de US$ 250 bilhões de demanda de investidor](https://www.datacenterdynamics.com/en/news/spacex-ipo-musks-firm-set-to-launch-first-orbital-data-center-ai1-satellites-in-2027-will-put-compute-on-starlink-craft/) contra os US$ 75 bilhões que a empresa buscava no início. E o pitch que sustentou essa avaliação foi justamente compute pra IA: os **satélites AI1**, "data centers orbitais" que a SpaceX pretende lançar a partir do fim de 2027, com [a empresa já fechando acordo de compute com Anthropic e Google](https://www.scientificamerican.com/article/spacex-ipo-valuation-depends-on-starship-and-orbital-ai-data-centers/). Os IPOs da Anthropic e da OpenAI vêm logo atrás, e todo esse dinheiro tem um objetivo comum: acelerar a disponibilidade de compute, porque hoje ela não dá conta.

Aqui entra a parte que me interessa de verdade. Num futuro não tão distante, **LLM open source pode ser parte da solução pra essa demanda**. Se uma fatia das tarefas migrar pra modelo rodando localmente, na máquina do desenvolvedor, é menos carga batendo nos data centers das nuvens. Mas "pode ser" não é "já é", e é exatamente sobre essa distância que esse benchmark existe.

## O recado de sempre: programação séria é Opus 4.8 ou GPT 5.5

Eu repito isso em todo post e não vou parar: trabalho de programação sério, hoje, se faz com **Claude Opus 4.8 ou GPT 5.5**, dentro do Claude Code ou do OpenCode. Ponto. Os modelos open source ainda não chegaram no ponto de tocar projeto de verdade, sessão longa, 100% vibe coded do começo ao fim. São pequenos demais, e a janela de contexto é limitada demais. Na minha régua, programação de verdade só fica viável acima de uns **200 mil tokens** de contexto, e a maioria dos open source não chega perto disso com qualidade. No meu benchmark, quase toda a oferta open source fica em Tier B ou abaixo.

Agora vem o "mas". Eles não estão parados. A cada geração eles melhoram num ritmo constante, e as três entradas dessa rodada mostram isso preto no branco. O dia em que um open source virar Tier A consistente e rodar com 200k de contexto numa máquina que cabe na sua mesa, a conta dos data centers muda. Vamos aos números.

## Kimi K2.7 Code: quase lá, com uma regressão boba

O Kimi K2.7 Code (exposto no OpenRouter como `moonshotai/kimi-k2.7-code`) marcou **86/100, Tier A, #8**. A $0.30 por run em 22 minutos, segue sendo um dos modelos mais baratos da Tier A inteira.

A integração com RubyLLM é genuína de ponta a ponta (`RubyLLM.chat` + `add_message` com replay de histórico completo + `complete` + `response.content`), verificada contra o source do gem 1.16.0. Persistência em session cookie que sobrevive a restart e é multi-worker safe, 22 testes que exercitam o caminho do LLM com mock de assinatura correta e teste de error path, Turbo Streams de verdade e três controllers Stimulus. Engenharia sólida.

Vale registrar uma armadilha metodológica que esse modelo expôs, porque ela é instrutiva. Meu scanner estrutural acusou **seis chamadas `chat.user`/`chat.assistant` como alucinação**, exatamente a assinatura inventada que jogou o GLM 5.1 pra Tier C meses atrás. Só que aqui eram todas falso positivo: resolvem pros métodos de domínio **do próprio app** (`Chat#user`, `Message.assistant`), não pra DSL do RubyLLM. Lendo o código na mão dava pra ver que a API real está certa. Se eu tivesse confiado cego no scanner, teria afundado um Tier A injustamente. É por isso que esse benchmark sempre lê a integração na mão, nunca só conta arquivo.

E aí vem o tropeço que segura ele **abaixo** do próprio K2.6 (87): o K2.7 Code **não manda system prompt via `with_instructions`**. O assistente sobe sem persona e sem guardrail, o que é uma lacuna real pra um app "estilo ChatGPT" e é a principal regressão em relação ao K2.6, que tinha. Além disso, o cookie de sessão não tem cap de mensagens (risco de `CookieOverflow` em conversa longa), e o I/O do RubyLLM mora dentro do value object `Chat` em vez de num service isolado. Curioso: a variante "Code", teoricamente especializada em programação, regrediu numa dimensão de produto que a versão geral acertava.

## GLM 5.2: a maior virada de uma versão pra outra no benchmark inteiro

Esse foi o destaque da rodada. O GLM 5.2 marcou **87/100, Tier A, #6**, e o tamanho do salto é o que impressiona: o GLM 5.1 tinha feito **46/100, Tier C, #21**. De uma versão pra outra, 41 pontos, três tiers, quinze posições. É a maior virada intra-família que eu já medi.

O bug que condenava o 5.1 era específico: ele inventava `chat.user`/`chat.assistant` pra montar o histórico multi-turn e crashava no turno 2. O 5.2 simplesmente usa o `chat.add_message(role:, content:)` real pra fazer o replay, e acabou. Todas as chamadas verificadas contra o source do gem 1.16.0, zero alucinação. Tem a **injeção de dependência mais limpa de todo o grupo**: tanto o client do RubyLLM quanto o `service_class` do controller são injetáveis, então a suíte de 26 testes mocka o caminho do LLM com `FakeChat`/`FakeClient` de assinatura correta, sem biblioteca externa de mock, exercitando streaming, aplicação de system prompt e wrapping de erro. Mira no slug certo (`anthropic/claude-sonnet-4.6`), Turbo Streams reais, Gemfile completo, Ruby 4.0.5 válido.

O que segura ele num empate com o Kimi K2.6 (e logo atrás dele) é a mesma dimensão que separou o Fable 5 do Opus 4.8: **persistência**. O store é um `Singleton` process-local **sem cap**, que morre no restart, não é multi-worker safe, e ainda cresce sem limite. O código é honesto sobre isso nos comentários, mas a rubrica pontua isso abaixo do cookie capado e multi-worker safe do Kimi. Foi também o run mais lento da Tier A, 43 minutos no endpoint de coding da Z.ai, que estava estrangulado em 12-55 tokens/s.

A leitura geral: GLM 5.1 → 5.2 é o exemplo mais claro de que open source não está estagnado. Um modelo que era lixo arquitetural virou Tier A em uma geração, corrigindo exatamente o bug que importava.

## MiniMax M3 local: o problema não é o modelo, é o hardware

Aqui a história é diferente, e é a que mais interessa pro argumento de futuro. A MiniMax soltou **pesos abertos** do M3: existe um [`unsloth/MiniMax-M3-GGUF`](https://huggingface.co/unsloth/MiniMax-M3-GGUF) e uma entrada [`ollama.com/library/minimax-m3`](https://ollama.com/library/minimax-m3). Disponibilidade não é o problema. **Memória é.**

O M3 é um MoE/MSA de **~428 bilhões de parâmetros totais e ~23 bilhões ativos por token** (~427B nos safetensors; a NVIDIA lista ~22B ativos, por diferença de arredondamento/contagem) espalhados por **128 experts, com 4 ativos por token**. E aqui mora a pegadinha do MoE: mesmo que só ~23B ativem por token, o conjunto **inteiro** de pesos precisa estar residente em memória. Não dá pra paginar expert ocioso pra CPU sem introduzir latência que mata a inferência interativa. Ou seja, o número que importa é o tamanho total, não o ativo:

| Quantização | Tamanho GGUF | RTX 5090 (32 GB) | Strix Halo (≤128 GB) |
|---|---|:---:|:---:|
| Q4_K_M | ~264 GB | ✗ | ✗ |
| Q3_K_M | ~195 GB | ✗ | ✗ |
| 1-bit | ~128 GB | ✗ | ✗ (sem sobra pra KV cache / OS) |

Eu rodo o subset local desse benchmark num [Minisforum MS-S1 Max, o Strix Halo com 128 GB unificados](/2026/03/31/review-minisforum-ms-s1-max-amd-ai-max-395/). Não chega nem perto. Até o quant de 1-bit (~128 GB), que já seria inútil pra coding de qualquer jeito, consumiria a memória unificada inteira sem deixar nada pro KV cache ou pro sistema. A placa NVIDIA de 32 GB então nem entra na conversa. Não existe quant do M3 que rode com qualidade usável em nenhuma das duas máquinas. Rodar "um MiniMax" local hoje significaria pegar uma variante bem menor e mais fraca (tipo o distill `minimax-m2-tiny`), que é outro modelo, não o M3.

Quem **consegue** tentar? Mac Studio com 256 GB de RAM unificada ou mais. O Q3 (~195 GB) caberia num Mac Studio de 256 GB, o Q4 (~264 GB) só num de 512 GB. E se alguém rodar, a expectativa é que o resultado fique **em torno da mesma nota do M3 via OpenRouter**, os 78/100 Tier B que eu já registrei no [post anterior](/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/): mesmo modelo, mesmos pesos, a quantização Q3/Q4 tira pouca coisa. Muda só onde roda, a entrega é a mesma. Ou seja, ninguém faria isso pela nota; faria pela soberania de rodar local. Mas a esse custo de hardware, não compensa.

### A convergência que eu enxergo (alvo: ~2030)

E é aqui que as duas histórias se encontram. O motivo de não existir solução local prática hoje é o mesmo motivo da seca de data center: **fabricar chip continua caríssimo**, porque a indústria inteira está com o foco travado em abastecer data center. Memória rápida e silício de ponta vão pra onde paga mais, e quem paga mais é hyperscaler comprando aos containers. Então pelos próximos dois anos, mais ou menos, a gente não vai ter uma solução local barata e boa. As peças não estão disponíveis a preço de mesa de desenvolvedor.

Mas o futuro próximo aponta pra uma convergência. Em algum momento a construção de data center bate num teto, seja por energia, por componente elétrico ou por saturação de demanda. Quando essa corrida desacelerar, a capacidade de fabricação de hardware sobra e começa a alcançar o resto do mercado, com silício cost-effective chegando pra rodar modelo local. Hoje os dois extremos não servem: o Mac Studio de 256 GB é caro demais pra ser "acessível", e o Strix Halo, que é acessível, ainda é lento demais pra uso prático sério. Mas a próxima geração de hardware pode fechar exatamente esse vão, com a memória e a banda de um Mac Studio no preço de um mini PC.

Junta as duas pontas: modelos open source melhorando de forma constante (o pulo do GLM 5.2 é a prova) de um lado, e hardware local ficando viável conforme a corrida de data center esfria do outro. No dia em que um GLM ou um Kimi Tier A rodar com 200k de contexto numa máquina de mesa que custa o preço de um notebook bom, a equação inteira de compute muda. Meu chute pra esse encontro é algo como **2030**. Ainda longe, mas a gente está indo pra lá.

## Ranking atualizado

Kimi K2.7 Code e GLM 5.2 em negrito:

| Rank | Modelo | Score | Tier | RubyLLM OK | Tempo | Custo |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | 97 | A | ✅ | 22m | ~$16 |
| 3 | GPT 5.5 xHigh (Codex) | 96 | A | ✅ | 18m | ~$10 |
| 4 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$1.10 |
| 5 | Claude Fable 5 | 94 | A | ✅ | 24m | ~$11 (est.) |
| 6 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$0.30 |
| 6 | **GLM 5.2 (Z.ai)** | **87** | **A** | ✅ | **43m** | **subscription** |
| **8** | **Kimi K2.7 Code** | **86** | **A** | ✅ | **22m** | **~$0.30** |
| 9 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 |
| 10 | Gemini 3.1 Pro | 82 | A | ✅ | 14m | ~$0.40 |
| 11 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 |
| 11 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 11 | MiniMax M3 | 78 | B | ✅ | 53m (fase 2 DNF) | ~$0.10 |
| 14 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.74 |
| 15 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 |
| 16 | DeepSeek V4 Pro \* | 69 | B | ✅ | 22m (DNF) | ~$0.50 |
| 16 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0.10 |
| 18 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.14 |
| 19 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 |
| 20 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 |
| 21 | Qwen 3.5 35B (local) | 55 | C | ✅ | 28m | grátis |
| 22 | GLM 4.7 Flash bf16 (local) | 52 | C | ✅ | falhou | grátis |
| 23 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 24 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 |
| 25 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 |
| 26 | Qwen 3.5 122B (local) | 37 | D | ❌ | 43m | grátis |
| 27 | Qwen 3 Coder Next (local) | 32 | D | ❌ | 17m | grátis |
| 28 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.60 |
| 29 | GPT OSS 20B (local) | 11 | D | ❌ | falhou | grátis |

\* DeepSeek V4 Pro chega a Tier A (89/100) só via DeepClaude. História no [post dedicado](/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/).

## Conclusão

Pro trabalho de hoje, nada muda: Opus 4.8 e/ou GPT 5.5 seguem sendo a recomendação pra programação séria, e os melhores open source ainda empacam no teto da Tier B-baixa-Tier-A com janela de contexto curta. O Kimi K2.7 Code até regrediu uma casa por uma bobagem de system prompt, lembrete de que "versão nova" nem sempre é "versão melhor".

Mas o GLM 5.2 saltando de Tier C pra #6 numa única geração é o tipo de sinal que eu fico de olho. O open source não está estagnado, está subindo de forma teimosa. E quando esse movimento encontrar o hardware ficando barato (a convergência que eu vejo lá por 2030), a história de onde a gente roda nossos coding agents vai ser bem diferente da de hoje. Por enquanto, é cloud, é Opus, é GPT. Mas eu continuo medindo, geração por geração, porque o dia que virar vai virar rápido.

O benchmark é aberto: [github.com/akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). Quer ver outro modelo aí? Fork, adiciona no `config/models.json`, roda e manda o PR.
