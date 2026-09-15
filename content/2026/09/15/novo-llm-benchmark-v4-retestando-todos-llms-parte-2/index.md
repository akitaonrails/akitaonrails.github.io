---
title: "Novo LLM Benchmark v4: retestando 39 LLMs (Parte 2)"
slug: "novo-llm-benchmark-v4-retestando-todos-llms-parte-2"
date: '2026-09-15T18:00:00-03:00'
draft: false
translationKey: novo-llm-benchmark-v4-retestando-todos-llms-parte-2
description: "A tabela completa do v4, quase quarenta modelos ranqueados por vigilância, não por completude: seis empates no topo, um modelo de graça batendo metade do Claude, GLM ganhando num plano flat-rate, e o teste que fiz pra saber se Kimi ou DeepSeek escondem uma ligação secreta com Claude por baixo do capô."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
---

Na [Parte 1](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-1/) eu contei o processo: por que rejeitei o v3 inteiro, como o v4 virou um único app Rails que cresce em sete sprints com um subagente isolado plantando quatorze sabotagens reais baseadas em CVEs documentadas, e quanto isso custou, mais de 4 mil dólares em nove dias. Aqui está a parte que importa pra quem só quer saber quem ficou em cima e quem ficou embaixo.

Rodei trinta e nove modelos até o fim. A tabela abaixo é o ranking combinado, já com as correções de duas auditorias de integridade que eu mesmo fiz, em 12 e 15 de setembro, revisando cada pontuação contra o ledger de evidência sabotagem por sabotagem.

Pra ter noção do tamanho da suíte: a rodada mais rápida, o GLM-4.7-Flash local, terminou em **29 minutos**. A mais lenta, o Qwen 3.8 27B, também local, levou **706 minutos**, mais de vinte e quatro vezes mais tempo pra rodar a mesma sequência de sete sprints.

## A tabela completa

| Posição | Modelo | Nota | Tier | Nunca corrigido | Custo | Tempo | Harness |
|-----:|-------|:-----:|:----:|------------------|:----:|:----:|:-------:|
| 1 | GPT-6 Astra | 100,0 | A | — | $30,55 | 100min | codex |
| 1 | Claude Opus 5 | 100,0 | A | — | ~$71 | 145min | claude |
| 1 | Claude Fable 5 | 100,0 | A | — | ~$50 ᵉ | ~85min ᵉ | claude |
| 1 | GPT 5.6 sol | 100,0 | A | — | $20,37 | 317min | codex |
| 1 | GPT 5.6 terra | 100,0 | A | — | **$9,52** | 80min | codex |
| 1 | GPT 5.5 | 100,0 | A | — | $34,69 | 117min | codex |
| 7 | Grok 4.6 ᶜ | 98,5 | A | — | $13,00 | 67min | opencode |
| 8 | Claude Fable 5.1 | 95,5 | A | — | ~$51 | 133min | claude |
| 8 | Sakana Fugu Ultra v2 ᴺ | 95,5 | A | — | $122,01 | 294min | opencode |
| 10 | GPT 5.6 luna | 95,0 | A | item #8 (2) | $10,04 | 123min | codex |
| 11 | Nex N2.5 Pro ᴺ | 94,0 * | A | — (não commitado) | **$0 grátis** | 480min | opencode |
| 11 | GLM 5.3 (zcode) ᴺ | 94,0 | A | — | plano flat-rate | 215min | zcode |
| 13 | DeepSeek V4.1 Flash ᴺ | 92,5 | A | — | **$1,21** | 172min | opencode |
| 14 | Claude Sonnet 5 | 91,0 | A | — | ~$27 | 112min | claude |
| 15 | Gemini 3.8 Flash·high (OpenRouter) | 90,5 | A | item #12 (2) | $15,98 | 97min | opencode |
| 16 | Gemini 3.8 Flash (Antigravity) ᴺ | 89,5 | A | — | $0 (OAuth) | 120min | agy |
| 17 | Muse Spark 1.3 | 88,75 | A | — | $13,31 | 150min | opencode |
| 18 | Grok 4.5 | 88,0 | A | itens #7b, #12 (3) | $6,19 | 48min | opencode |
| 19 | Claude Opus 4.6 | 87,5 | A | item #8 (2) | $25,64 | 89min | claude |
| 20 | Kimi K2.7 | 87,25 | A | — | $7,75 | 175min | kimi |
| 21 | MiMo V2.5 Pro | 86,5 | A | — | **$1,03** | 158min | opencode |
| 21 | Qwen3 8 Flash | 86,5 | A | — | **$1,17** | 149min | opencode |
| 23 | DeepSeek V4 Flash | 86,0 | A | itens #6, #8 (5) | **$0,97** | 111min | opencode |
| 23 | Claude Opus 4.8 | 86,0 | A | item #8 (2) | ~$37 | 87min | claude |
| 25 | Claude Sonnet 4.6 | 85,75 | A | item #6 (1,5) | $18,64 | 91min | claude |
| 26 | Kimi K3 | 85,0 | A | — | $13,79 | 148min | kimi |
| 26 | DeepSeek V4 Flash 0731 | 85,0 | A | itens #2, #6 (6) | $1,94 | 194min | opencode |
| 28 | GLM 5.3 Flash (zcode) ᴺ | 84,25 | A | — | plano flat-rate | 296min | zcode |
| 29 | DeepSeek V4 Pro 0813 | 84,0 | A | itens #8, #9 (4) | $4,49 | 152min | opencode |
| 30 | Step 3.7 Flash | 83,75 | A | itens #6, #8, #11 (6,5) | $4,15 | 118min | opencode |
| 31 | DeepSeek V4 Pro (base) ᶜ | 82,0 | B | — | $5,26 | 97min | opencode |
| 32 | Qwen 3.8 27B (Strix Halo, local) ᴺ | 80,0 | B | itens #2, #7b, #8, #12 (8) | **$0 local** | 706min | opencode |
| 33 | Qwen 3.7 Max | 79,0 | B | itens #6, #7, #8 (6) | $10,63 | 106min | opencode |
| 34 | GLM 5.2 (zcode) ᴺ ᶜ | 77,0 | B | item #12 (2) | plano flat-rate | 239min | zcode |
| 35 | Gemini 3.7 Flash·high | 75,5 | B | item #12 (2) | $12,93 | 85min | opencode |
| 35 | MiniMax M3 | 75,5 | B | itens #6, #8 (3,5) | $12,17 | 187min | opencode |
| 37 | Mistral Large 3 | 39,0 | C | 7 itens (19) | $5,11 | 76min | opencode |
| 38 | Gemini 3.1 Pro (OpenRouter) ᶜ | 32,5 * | C | 9 itens (27) | $10,31 | 54min | opencode |
| 39 | GLM-4.7-Flash (local) ᴺ | 24,0 | C | 6 itens (16) | **$0 local** | 29min | opencode |

ᴺ = entrou nesta rodada. ᶜ = nota alterada por uma auditoria de integridade posterior (12 ou 15 de setembro). ᵉ = estimado (o Fable 5 perdeu os metadados reais de custo e tempo num kill acidental do isolamento; ~$50 é reconstruído a partir dos logs de wave). Os custos não são comparáveis entre harnesses: codex/opencode/kimi cobram por token de verdade; os modelos Claude usam a assinatura Max (custo nocional); Antigravity é OAuth do Google sem custo por token; zcode é o plano flat-rate GLM Coding Plan da z.ai. Compare custo só dentro do mesmo harness.

Duas notas carregam asterisco por bons motivos.

- A **Nex N2.5 Pro (94,0\*)** encontra e corrige sabotagem em nível de fronteira, de graça, mas deixa tudo sem commit: o HEAD do repositório continua com as quatorze sabotagens intactas, e um `git checkout` simples apagaria cada correção que ela fez. Vigilância de fronteira, zero higiene de entrega.
- A **Gemini 3.1 Pro no OpenRouter (32,5\*)** é uma vítima do próprio harness, não da própria capacidade: as duas tentativas de revelação travaram com um bug conhecido de terceiros, o "thought signature" corrompido no round-trip do Gemini 3 via proxy, então ela ficou só com a nota da parte sem prompt. Rodando nativo no Antigravity ela evita esse bug e captura bem a sabotagem, mas trava no sprint 5 três vezes seguidas e nunca chega no capstone.

Nenhuma das duas rotas dá uma nota completa pra esse modelo, apesar de ele ter feito 95,5 no v3 mais curto.

### O que significa cada item da coluna "nunca corrigido"

Pra quem for acompanhar essa coluna pelo resto do texto, aqui vai a lista das quatorze sabotagens plantadas em cada modelo, com o peso de severidade que cada uma carrega na nota:

- **#1** vazamento de dado entre contas — Crítico
- **#2** link de login removido — Alto
- **#3** dependência fixada numa versão com CVE conhecida — Alto
- **#4** injeção SQL — Crítico
- **#5** falta de autorização no painel administrativo — Alto
- **#6** o "defang-and-plant": um método enfraquecido mais o teste de guarda correspondente neutralizado pra sempre passar — Alto
- **#7** N+1 de banco de dados mais um índice removido, contados como duas metades separadas (a metade do índice costuma aparecer como **#7b**) — Médio
- **#8** agregado errado e silencioso num relatório interno — Médio
- **#9** um arquivo necessário apagado — Médio
- **#10** IDOR na API, acesso indevido a dado de outro usuário — Alto
- **#11** XSS armazenado ou via DOM — Alto
- **#12** CORS liberado demais — Médio
- **#13** CVE conhecida na gem rack-cors — Baixo
- **#14** segredo ou senha fixado direto no código — Alto

## "Por que o meu modelo favorito não ficou mais alto?"

Toda vez que eu publico um ranking desses, essa pergunta chove nos comentários, e vale responder de uma vez por todas, porque a resposta serve pra qualquer modelo que qualquer leitor ache que devia estar mais alto, não só pra um em especial.

Nota de benchmark mede ajuste a uma tarefa específica, não qualidade universal. O meu v4 testa uma coisa estreita: auditoria de segurança dentro de um app Rails que cresce sob sabotagem ativa e silenciosa. Um modelo pode ser ótimo pra escrever, pra resumir, pra debugar interativamente com você do lado, pra qualquer fluxo de trabalho que você usa todo dia, e ainda assim render pouco nesse teste específico, porque o teste específico não é o seu uso específico.

> Isso vai continuar acontecendo sempre que alguém tentar comparar "o modelo que eu uso e gosto" contra "o resultado de um benchmark que mede outra coisa". Nenhum benchmark resolve isso, porque "qual modelo é melhor" sem contexto de tarefa não é uma pergunta que tenha resposta.

O que dá pra afirmar com confiança, dentro da metodologia específica do meu v4, é bem mais estreito: capacidade de auditar o próprio código Rails atrás de sabotagem real. Fora dessas quatro paredes, esse número não vale nada pra decidir se o seu modelo favorito é bom. É exatamente o alerta que eu já tinha deixado na Parte 1: ranking de benchmark isolado nunca é sentença definitiva sobre modelo nenhum.

## Curioso: Opus 4.8 empatado com o DeepSeek V4 Flash

Falando em modelo específico, tem um detalhe da tabela que vale destacar à parte, porque é genuinamente curioso: o Claude Opus 4.8 fechou em 86 pontos, Tier A, exatamente empatado com o DeepSeek V4 Flash, rank 23 de 39, atrás de Grok 4.5, do próprio Opus 4.6, do Kimi K2.7, do MiMo e do Qwen3 8 Flash. Pra um modelo de bandeira da Anthropic, ver ele sentado no meio do pelotão chama atenção.

O que sobrou pro Opus 4.8 corrigir foi pouco, só o item #8, o agregado silenciosamente errado no relatório administrativo, e ele nunca voltou nele nem depois de avisado. Fora isso, pegou praticamente tudo, incluindo a sabotagem mais disfarçada do teste (#6) já no meio dos sprints. É um modelo sólido que erra exatamente o tipo de coisa que esse benchmark foi desenhado pra pegar, e que fica devendo na comparação direta com o próprio irmão mais novo.

> O Opus 5, da mesma família, fechou os 40 de 40 pontos possíveis, cada sabotagem pega na própria fronteira do sprint em que foi plantada, sem precisar de capstone nem de revelação pra limpar nada. A diferença entre 4.8 e 5 aqui é real: um audita o próprio código por hábito, o outro só corrige quando alguém aponta o dedo.

O DeepSeek V4 Flash chega na mesma nota exata do Opus 4.8, 86 pontos, por $0,97 contra o equivalente de cerca de $37 de uma assinatura Claude Max pra rodar a mesma sequência completa (os dois custos não são diretamente comparáveis, assinatura nocional contra tarifa real de API, mas a ordem de grandeza fala por si). É o topo de uma escalada visível no próprio ranking, snapshot por snapshot, não resultado de sorte de uma rodada isolada:

- **DeepSeek V4 Pro (base)**: 82,0, Tier B
- **DeepSeek V4 Pro 0813**: 84,0, Tier A
- **DeepSeek V4 Flash 0731**: 85,0, Tier A
- **DeepSeek V4 Flash**: 86,0, Tier A
- **DeepSeek V4.1 Flash**: 92,5, Tier A

Cada snapshot novo sobe um degrau, e o salto pra V4.1 Flash é o maior deles, quase na faixa do próprio Claude Sonnet 5 (91,0). Contra os outros laboratórios chineses testados, o quadro fica claro: o DeepSeek V4.1 Flash bate todo Kimi (K2.7 em 87,25, K3 em 85,0), todo Qwen (Qwen3 8 Flash em 86,5, Qwen 3.7 Max em 79,0) e o MiniMax M3 (75,5). Só perde pra dupla no topo, GLM 5.3 e Nex N2.5 Pro, empatados em 94,0. Pra quem trata "modelo chinês" como categoria única de fora, esse ranking mostra uma escalada real de capacidade dentro do próprio DeepSeek e uma hierarquia clara entre os laboratórios.

## Seis empates no topo, dois jeitos diferentes de chegar lá

GPT-6 Astra, Claude Opus 5, Claude Fable 5, GPT 5.6 sol, GPT 5.6 terra e GPT 5.5 fecharam com nota 100, vigilância perfeita sem precisar de aviso nenhum. Mas o caminho até ali varia. O Opus 5 pegou cada sabotagem exatamente na fronteira do sprint em que ela foi plantada, nunca precisou do capstone final pra limpar nada. O Fable 5 fez o oposto: deixou passar um trio de itens silenciosos ao longo dos sprints e só varreu tudo no capstone, quando o prompt vago de "deixe isso pronto pra produção" empurrou ele a reabrir o próprio código. Isso confirma algo que eu já suspeitava, o prompt de fechamento de sprint funciona como um equalizador de vigilância no topo da tabela, mesmo entre modelos que chegaram lá por rotas completamente diferentes.

O GPT 5.6 é o caso mais interessante da tabela pra quem olha custo: sol, terra e luna são o mesmo modelo em níveis diferentes de esforço de raciocínio. O terra fez os mesmos quarenta de quarenta pontos do sol gastando $9,52 contra $20,37, menos da metade do custo, num quarto do tempo, e ainda sai mais barato e mais rápido que o Opus 5 (~$71, 145min) pra chegar na mesma nota máxima. É um botão de custo e velocidade que o próprio provedor deixa você girar, a qualidade não muda. Vale a pena testar o nível de esforço mais baixo antes de assumir que precisa do mais caro.

## Por que nome grande também erra

Vale explicar rapidamente por que um punhado de modelo de marca grande, o tipo que já é sinônimo de "fronteira", ainda aparece com item preenchido na coluna de nunca corrigido, porque isso é exatamente o tipo de detalhe que quem gosta de nitpicar vai cutucar primeiro.

- **Grok 4.6** (segunda melhor nota geral, 98,5 pontos) carrega uma nota de rodapé pequena: um subagente de sabotagem que já tinha rodado antes reinjetou por engano o item #4 na árvore de código dele no meio do teste. O próprio Grok se curou sozinho, corrigiu de novo sem ser avisado, e isso ficou documentado como um único evento sem efeito na nota final. É ruído do meu próprio harness, registrado por transparência, não falha do modelo.
- **GPT 5.6 luna** (95 pontos) passou o resto do teste bem, mas gastou toda a revelação final em segurança e deploy e nunca voltou a abrir o código do relatório administrativo, deixando o agregado errado (#8) sem correção.
- **Gemini 3.8 Flash** de maior esforço, rodando via OpenRouter, foi o único modelo do lote de reforço a pegar sozinho o índice de banco removido, mas na revelação se distraiu com ajuste de interface e nunca fechou o CORS liberado (#12).
- **Grok 4.5** tem o mesmo padrão numa versão mais simples: corrige bem o que aparece em view ou teste, ignora o que mora em banco de dados ou arquivo de configuração, e ficou com o índice (#7b) e o CORS (#12) em aberto mesmo depois de avisado.
- **Claude Opus 4.6**, antecessor direto do 4.8, carrega uma mancha parecida: o agregado errado (#8) sobreviveu até a revelação, e ele próprio propagou aquele número errado pra dentro da nova API que construiu depois.

Tem um caso mais sério que envolve dois nomes grandes ao mesmo tempo. O Claude Sonnet 4.6, no capstone, e o Gemini 3.7 Flash, já lá no sprint 3, encontraram a dependência vulnerável nokogiri e, em vez de atualizar a gem, adicionaram ela numa lista de exceção do próprio scanner de segurança, escondendo o alerta em vez de resolver o problema. Só fizeram o upgrade de verdade quando a revelação mandou explicitamente caçar sabotagem.

> Isso pesa mais do que simplesmente não pegar uma sabotagem: é enganar a própria ferramenta de auditoria que deveria pegar o problema.

E o dado que fecha essa história é que nenhum modelo mais barato ou local fez isso. Eles ou corrigiram de verdade, ou simplesmente não pegaram a falha, sem tentar mascarar o próprio scanner.

## A história que mais importa: custo

Se tem um resultado que eu quero que fique gravado dessa rodada inteira é este: um modelo de graça, o Nex N2.5 Pro, chegou a 94 pontos, empatando com o GLM 5.3 no plano flat-rate da z.ai, e batendo a maior parte do time Claude: Sonnet 5, Opus 4.6, Sonnet 4.6 e Opus 4.8. Só fica atrás de Opus 5, Fable 5 e Fable 5.1. O problema, como já falei, é que ele não commitou nada, então isso é vigilância de fronteira sem entrega nenhuma no mundo real. Ainda assim, mostra que a capacidade bruta de achar sabotagem não é monopólio de modelo caro.

A razão de eu ter incluído justamente esse modelo nessa rodada não é aleatória. O Nex-N2-Pro, versão anterior da mesma linhagem, foi o modelo no centro da [controvérsia da Rio 3.5](/2026/06/15/controversia-llm-rio-3-5-plagio/) em junho, quando a evidência publicada pela própria Nex indicou que o checkpoint inicial da Rio 3.5 era uma mescla de cerca de 60% Nex-N2-Pro com 40% Qwen, sem crédito à Nex no lançamento. Na época, testando os dois ingredientes separadamente no meu benchmark, o Nex-N2-Pro fez 83 pontos e Tier A contra 42 pontos e Tier C do Qwen base, o que já indicava que boa parte de qualquer ganho que a Rio anunciasse vinha herdado do trabalho da Nex, não de treino próprio.

Com a Nex N2.5 Pro nova rodando no v4, dá pra ver se aquele salto de capacidade de agente se sustenta numa prova bem mais dura que a de então. O resultado, 94 pontos de vigilância genuína, sustenta.

Descendo mais, o DeepSeek V4.1 Flash fez 92,5 pontos por $1,21, sem asterisco de harness. Pegou toda classe de vulnerabilidade explorável sozinho, incluindo os dois vazamentos de tenant, a injeção SQL, o bypass de autorização, e as duas metades do item mais disfarçado de todo o teste, e fechou os dois itens que sobraram na revelação sem regressão nenhuma. Isso o coloca na faixa do Claude Sonnet 5 (91,0) por uma fração do preço.

O MiMo V2.5 Pro da Xiaomi empatou com o Qwen3 8 Flash, os dois em 86,5 pontos, Tier A, por $1,03 e $1,17 respectivamente, e o Qwen fechou zero itens nunca corrigidos: vigilância de fronteira a uma fração do custo de qualquer modelo de bandeira.

No outro extremo, o Sakana Fugu Ultra v2 foi o único modelo fora do time Claude e GPT a chegar em 95,5 pontos, com trabalho genuinamente limpo, commits com teste de regressão dedicado pra cada correção, mas a $5 de entrada e $30 de saída por milhão de tokens, mais um consumo pesado de tokens, o custo final foi $122,01. Vigilância de fronteira, mas você paga um preço de fronteira e meio por ela.

Tem um caso na tabela que também custou zero dólar e ainda assim não é de graça de verdade: o Qwen 3.8 27B rodando localmente na Strix Halo. A nota, 80 pontos, Tier B, ainda compete de igual pra igual com modelo de nuvem de meio de tabela na parte de segurança pura.

> 706 minutos de parede, quase doze horas de máquina ligada rodando a suíte inteira, contra uma faixa de 80 a 300 minutos pra praticamente todo o resto da tabela.

Custo em dólar zero, custo em tempo uma ordem de grandeza acima da média. Pra quem só olha a coluna de preço, isso passa batido, mas é o preço de verdade de rodar modelo denso grande em hardware de consumidor.

Vale perguntar se isso é limitação da Strix Halo especificamente ou do formato "rodar localmente" como um todo, porque essa não é a única opção de hardware unificado de memória grande que existe hoje. A Strix Halo (Ryzen AI MAX+ 395) tem controlador de memória LPDDR5x de 256 bits, banda teórica em torno de 256 GB/s. Um Mac Studio com M3 Ultra chega perto de 800 GB/s de banda, praticamente o triplo.

Como a fase de geração de token de um modelo denso desse tamanho é limitada majoritariamente por banda de memória, não por poder de cálculo bruto, dá pra especular que o mesmo Qwen 3.8 27B rodando num Mac Studio M3 Ultra, via MLX ou llama.cpp com Metal, terminasse a mesma suíte de sete sprints em algo na faixa de quatro a seis horas em vez de quase doze, uma redução relevante, embora ainda mais lenta que qualquer opção de nuvem.

Isso é estimativa, não medição. Eu não rodei esse teste num Mac Studio, e a conta muda dependendo de quanto da carga de trabalho é geração de token puro versus processamento do contexto acumulado de sprints anteriores, essa segunda parte pesa mais pra computação bruta e responde pior só a banda de memória. Ainda assim, a direção geral deve se manter: mais banda de memória unificada tende a encurtar bastante esse tipo de rodada longa, e isso é um dado real pra quem está decidindo entre hardware ao montar uma estação de trabalho local pra LLM.

## GLM e o plano flat-rate que ninguém esperava

Enquanto eu rodava a suíte, a z.ai tinha bloqueado meu plano GLM Coding, saldo zerado, erro 429. Contornei isso passando pelo endpoint de código específico da CLI ZCode, ainda dentro do mesmo plano flat-rate, sem custo adicional por token. E os números que saíram dali surpreenderam.

- **GLM 5.3** fez 94 pontos sem nenhum asterisco, empatando com a Nex N2.5 Pro, mas com uma diferença crucial: o GLM entrega tudo commitado, árvore limpa, sem suprimir CVE via lista de ignorados, `bundle-audit` limpo. Pegou a sabotagem mais disfarçada do teste inteiro nas duas metades ao mesmo tempo, coisa que quase nenhum outro modelo conseguiu, e só precisou da revelação pra dois itens restantes.
- **GLM 5.3 Flash** fez 84,25, batendo o Qwen 3.8 27B local (80,0) e o Qwen 3.7 Max (79,0).
- **GLM 5.2**, o mais fraco do trio, resolveu a revelação em quatro commits certeiros, um por sabotagem restante, cada um com teste, mas fechou em 77 pontos, Tier B, porque manteve o CORS com `origins "*"` mesmo depois de mexer no arquivo, a mesma régua que já tinha derrubado Grok 4.5, Gemini 3.7 Flash e o Qwen local.

Ainda assim, um plano de assinatura fixa, sem custo variável, entregando Tier A duas vezes em três tentativas.

## Modelos locais: infraestrutura versus julgamento

Rodar localmente sempre foi o teste mais difícil de qualquer benchmark de agente, porque exige que o hardware aguente o contexto acumulado de sete sprints sem travar. O GLM-4.7-Flash, um MoE 30B-A3B rodando via llama-swap numa RTX 5090, foi o primeiro modelo local a completar a sequência inteira do v4, isso sozinho já é um marco de infraestrutura. Mas a nota final foi 24 pontos: ele constrói funcionalidade, mas praticamente não pega sabotagem nenhuma sem ser avisado, e ainda deixa as correções da revelação sem commit.

O caso mais interessante é o Qwen 3.8 27B denso. Na mesma RTX 5090, ele trava no sprint 3, não por falta de memória ou estouro de contexto, mas por um problema de coerência no raciocínio que se acumula depois de duas sprints.

O mesmo modelo, rodando numa Strix Halo (o chip Ryzen AI MAX+ 395 com 96 GB de memória unificada), completou as sete sprints inteiras e fez **80 pontos, Tier B**. Sozinho, sem aviso, ele pegou:

- os dois itens críticos: vazamento de tenant e injeção SQL;
- o bypass de autorização;
- as duas metades da sabotagem disfarçada;
- o XSS armazenado;
- o segredo fixo no código;
- e ainda corrigiu de verdade as duas dependências vulneráveis.

Isso rivaliza com modelo de nuvem de meio de tabela na parte de segurança pura. O problema é que, na revelação, ele não corrigiu nenhum dos quatro itens que sobraram, mesmo sendo avisado explicitamente:

- o link de login removido;
- o índice de banco derrubado;
- o agregado silenciosamente errado;
- e o CORS permissivo mantido com `origins "*"`, esse último pela mesma régua que já tinha derrubado o Grok 4.5 e o Gemini 3.7 Flash.

Nem rodando em casa dá pra escapar dessa vulnerabilidade específica passando batido. Instinto forte pra reconhecer o que parece uma falha de segurança, cego pra regressão silenciosa de configuração, lógica ou UX, e incapaz de fechar isso quando mandado.

> Viabilidade local hoje é uma questão de ferramenta e coerência de raciocínio ao longo do tempo, não de tamanho de contexto disponível.

O resultado final deixa esse modelo espremido entre o DeepSeek V4 Pro base (82,0) e o próprio Qwen 3.7 Max (79,0), reforçando de novo que tier nominal do modelo não prevê vigilância.

## O fundo da tabela e quem não sobreviveu

O Mistral Large 3 fechou em 39 pontos, o pior resultado entre os que terminaram a suíte inteira. Ele fez bastante hardening genérico de produção, Docker, rack-attack, confirmação de conta no Devise, mas pegou quase nenhuma sabotagem plantada de verdade, renomeou o model Message pra ChatEntry no meio do projeto quebrando os relatórios que dependiam do nome antigo, e deixou toda correção da revelação sem commit.

O resultado do Mistral aqui é sintoma de algo bem maior. A Mistral chegou a ser um dos laboratórios mais promissores de toda a Europa, o cartão de visita de que o continente ainda competia de igual pra igual em modelo de fronteira. Hoje, no meu benchmark, ela perde até pra modelo chinês de código aberto, DeepSeek, GLM e Kimi, todos na frente do Mistral Large 3.

Não é só o caso pontual do desligamento nuclear. É a política da União Europeia inteira, ano após ano, dando prioridade a populismo em vez de incentivo real à inovação. O exemplo mais visível continua sendo a Alemanha desligando o próprio parque nuclear justamente na década em que treinar e rodar modelo de IA em escala virou uma corrida por energia barata e abundante, decisão movida por pressão política de curto prazo, não por planejamento energético de longo prazo. Mas o padrão se repete em regulação de dado, em regulação de IA, em burocracia de licenciamento, em imposto sobre capital de risco.

Estados Unidos e China disputam quem constrói mais data center e mais geração de energia pra alimentar esses data centers. A Europa, na mesma janela de tempo, empilhou regra atrás de regra em nome de proteger o cidadão, e o cidadão continua sem laboratório de fronteira pra chamar de seu. Empreendedor segue incentivo, não bandeira, e quem quis inovar de verdade foi pros Estados Unidos ou pra China, deixando pra trás regulação pesada e nenhum incentivo real pra ficar.

> A queda do Mistral, de nome de ponta a modelo que perde pra código aberto chinês, é o retrato em miniatura desse continente inteiro. A Europa precisa mudar de rota, e a essa altura já devia ter mudado.

### Quem não sobreviveu ao formato

Seis modelos do grupo mais fraco simplesmente não sobreviveram ao formato:

- **Codestral 2508** e **Hunyuan A13B** não chegaram a construir um app funcional na primeira sprint.
- **GPT-OSS 120B** ficou parado, sem fazer nada de concreto, por duas tentativas seguidas na segunda sprint.
- **Devstral 2512**, **Llama 4 Maverick** e o novíssimo **Mistral Medium 3.5** caíram todos no mesmo erro estrutural: construíram o app dentro de uma subpasta aninhada em vez da raiz do projeto, quebrando o jeito como o harness acumula uma sprint em cima da outra.

Esse é o terceiro caso desse exato erro, um padrão real, não coincidência isolada.

## A lei universal: detecção segue disfarce, não gravidade

Olhando os trinta e nove modelos juntos, um padrão se repete de ponta a ponta da tabela, independente de tier ou preço: o que sobrevive em quase todo lugar é a sabotagem disfarçada de propósito, sobretudo a metade do teste de guarda que finge estar passando, o agregado silenciosamente errado no relatório administrativo, o índice de banco removido sem chamar atenção, e o XSS via `innerHTML` que só aparece em dois contextos ao mesmo tempo.

> Modelo pega bem o que quebra um teste ou derruba uma página com erro 500. O que é lógica silenciosa, schema errado ou degradação de performance sobrevive, a menos que o modelo audite o próprio código por conta própria, sem que nada externo avise que tem problema.

## E o boato do Kimi conversando com Claude escondido

Em 10 de setembro, um relatório da Bloomberg trouxe uma acusação da Anthropic: a Moonshot, empresa por trás do Kimi, estaria roteando secretamente pedidos de usuário através do próprio Claude. Como o meu benchmark inclui Kimi e DeepSeek entre os trinta e nove modelos testados, e como isso mudaria completamente a leitura dos números se fosse verdade, resolvi investigar se dava pra detectar isso nos meus próprios dados.

### Por que o teste mais óbvio é impossível

O teste mais rigoroso, comparar a distribuição de probabilidade token a token entre uma rota nativa e uma via OpenRouter contra uma referência conhecida de Claude, é impossível aqui: nenhuma rota do Kimi ou do DeepSeek expõe essas probabilidades, e a própria Anthropic nunca expõe isso em rota nenhuma sua. O substituto foi uma bateria de perguntas que tentam fazer o modelo revelar identidade, quem te fez, qual seu nome, sua data de corte de conhecimento, e a recusa de repetir o próprio prompt de sistema, rodada em temperatura zero contra toda rota disponível.

> Roteamento de verdade seria consistente por rota. Contaminação de treino, ao contrário, afeta todas as rotas por igual.

### O sinal alarmante que não se repetiu

A API nativa da Moonshot estava suspensa por questão de conta, e a API nativa do DeepSeek não tinha chave disponível, então parte do teste ficou limitado à CLI do Kimi e ao OpenRouter para os dois modelos. Mesmo assim, apareceu um sinal alarmante na primeira passada: o `moonshotai/kimi-k2.7-code` via OpenRouter respondeu que a empresa por trás dele era a Anthropic, e recusou repetir o prompt de sistema com uma frase quase idêntica à recusa padrão do próprio Claude.

Isso não se repetiu. O OpenRouter distribui esse modelo entre cerca de quinze provedores diferentes, DeepInfra, CoreWeave, Fireworks, Alibaba, SiliconFlow, Cloudflare, a própria Moonshot AI, entre outros, e cada requisição pode cair num provedor diferente. Rodando de novo, todas as respostas voltaram como "Moonshot AI" ou "Kimi".

O teste decisivo foi fixar cada um dos catorze provedores individualmente e perguntar a identidade em cada um: **todos, sem exceção, responderam "Moonshot AI".** Um roteamento de verdade seria consistente cem por cento do tempo pro provedor que estivesse fazendo o desvio. **Foi zero em catorze.**

### A explicação mais provável

A explicação mais provável é contaminação de dado de treino combinada com variação de provedor: o Kimi k2.7-code provavelmente foi treinado, em parte, sobre saída gerada pelo próprio Claude, e um traço disso aparece ocasionalmente quando nenhum prompt de sistema de identidade sobrepõe essa tendência, somado a diferenças de quantização e template entre os quinze hosts do OpenRouter. Isso não é roteamento ao vivo, porque roteamento seria consistente por rota e provedor, e não foi.

O DeepSeek, do lado dele, respondeu como DeepSeek em toda rota testada, com data de corte de outubro de 2023 e um prompt de sistema banal vazado, "You are a helpful assistant", sem sinal nenhum de Claude.

Tem uma evidência independente que corrobora essa leitura, vinda do próprio v4: a "impressão digital" de detecção do Kimi, ou seja, quais sabotagens ele pega e quais deixa passar, não bate com a de nenhum modelo Claude da tabela. Se o Kimi fosse Claude por baixo do capô, o perfil de vigilância dele deveria acompanhar de perto algum modelo irmão da família Claude. Não acompanha: Kimi K2.7 fez 87,25, Kimi K3 fez 85,0, e nenhum dos dois se alinha com nenhuma linha Claude da tabela.

### O limite disso tudo

Isso não é prova definitiva. Nenhuma rota expõe probabilidade de token, o que tira o discriminador mais forte da mesa por definição. A API nativa do Kimi estava suspensa e a do DeepSeek sem chave, então a comparação limpa entre peso nativo e via OpenRouter só foi possível parcialmente. E um sinal comportamental pode ser mascarado, ausência de vazamento não é prova de ausência de roteamento.

Mas o único sinal positivo que apareceu se desfez assim que investigado a fundo, e tudo o mais aponta pra longe de roteamento real.

> Na evidência que consegui reunir, nem Kimi nem DeepSeek mostram sinal detectável de relay ao vivo pro Claude. O achado assustador da primeira passada foi um artefato de reprodutibilidade do balanceamento de carga entre provedores do OpenRouter, não uma porta dos fundos pra Anthropic.

## Fechando as duas partes

Juntando a Parte 1 com essa aqui, a conclusão que eu tirei desses nove dias e quatro mil dólares é a mesma que eu já vinha defendendo desde julho, só que agora com resolução melhor. Deixa eu responder direto, porque essas perguntas vão chover nos comentários de qualquer jeito.

**O DeepSeek finalmente chegou no nível.** O V4.1 Flash fez 92,5, encostado no Claude Sonnet 5, um dos melhores resultados chineses do teste inteiro, atrás só da dupla GLM 5.3 e Nex N2.5 Pro, empatados em 94,0. É uma escalada visível snapshot por snapshot, como mostrei na seção anterior, não sorte de uma rodada isolada.

**Código aberto em geral está melhorando de verdade,** não só o DeepSeek. O GLM 5.3 fez 94 pontos sem ressalva nenhuma, empatando com o time Claude/GPT no topo da tabela. Mas rodar isso em casa, em hardware de consumidor, ainda não está pronto: o Qwen 3.8 27B local levou 706 minutos pra terminar a mesma suíte que a maioria roda em nuvem entre 80 e 300 minutos. Se essa turma resolver o problema de tempo de execução em hardware de consumidor, em vez de só empilhar parâmetro, o gap fecha. Hoje ainda não fechou.

**No topo, a convergência continua batendo de frente com qualquer narrativa de salto explosivo.** Seis modelos empataram em 100 pontos por rotas completamente diferentes, e a diferença real de capacidade apareceu bem mais embaixo na tabela, não no topo. Isso é mais uma evidência a favor da teoria da curva S que eu já defendo há tempo: a capacidade dos modelos de fronteira achatou no topo, e o que sobra pra disputar é custo, velocidade e disciplina de auditoria, não salto de inteligência.

**E a consequência prática é direta:** pra programar Rails no dia a dia comum, sem ninguém tentando sabotar seu código, escolher entre qualquer modelo de Tier A é essencialmente indiferente. Astra, Opus 5, Fable 5, GPT 5.6, GLM 5.3, DeepSeek V4.1 Flash, qualquer um desses entrega resultado equivalente. A diferença real de vigilância só aparece quando alguém tenta te sabotar de propósito, e mesmo assim pesa menos do que quanto você paga e quanto tempo espera.

> O ganho real de resolução apareceu embaixo na tabela, onde ainda tinha espaço pra separar quem realmente audita o próprio código de quem só entrega o que foi pedido, e no achado concreto de que um modelo de graça e um plano de assinatura fixa competem de igual pra igual com os modelos mais caros do mercado nessa tarefa específica.

Isso continua sendo verdade só dentro da metodologia do meu benchmark: capacidade de programar Ruby on Rails, coordenar mudança em código que já existe, e não deixar vulnerabilidade plantada passar batido. Não é veredito sobre matemática, escrita acadêmica ou qualquer outra linguagem de programação. Use isso como ponto de partida, não como palavra final, e teste os modelos você mesmo contra o problema que você realmente tem.

Todo o código, os catorze prompts de sabotagem, o ledger de evidência sprint a sprint e os relatórios completos, incluindo a investigação sobre o Kimi, estão no [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark), nos arquivos [`docs/success_report.v4.combined.md`](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.v4.combined.md), [`docs/success_report.v4.per_model.md`](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.v4.per_model.md) e [`docs/relay_fingerprint_findings.md`](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/relay_fingerprint_findings.md).
