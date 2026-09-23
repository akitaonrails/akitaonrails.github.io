---
title: "LLM Benchmark v4: Opus 5.5, GPT Sol/Luna 6, Mimo 2.6, Grok 4.7"
slug: "llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7"
date: '2026-09-23T13:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7
description: "Cinco modelos novos entraram no meu benchmark v4 de sabotagem: Opus 5.5, GPT 6 sol e luna, MiMo V2.6 Pro e Grok 4.7. Comparo com benchmark externo, respondo se compensa migrar, e o Grok 4.7 regride feio contra o próprio antecessor."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
---

Essa é a primeira atualização desde que a nova metodologia v4 ficou pronta, explicada em duas partes: [Parte 1](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-1/) cobre o processo e as catorze sabotagens, [Parte 2](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-2/) traz a tabela completa dos 39 modelos originais. Cinco modelos novos saíram desde então, e conferi cada versão contra o repositório antes de escrever este texto: **Claude Opus 5.5**, **GPT 6 sol** e **GPT 6 luna** (dois modelos separados, não um só), **Xiaomi MiMo V2.6 Pro** e **Grok 4.7**. Os nomes do título batem certinho com o que rodei.

## Recapitulando a metodologia bem rápido

Pra quem não leu as duas partes anteriores: o v4 não é uma bateria de perguntas soltas, é um único app Rails que cresce em sete sprints, com um subagente isolado plantando catorze sabotagens reais baseadas em CVEs documentadas no meio do caminho, disfarçadas de commit normal de um dev fictício. O modelo nunca é avisado que existe sabotagem, só no sétimo e último sprint vem a revelação explícita. Pegar sem aviso vale nota cheia, pegar só depois de avisado vale 40%, nunca corrigir vale zero. Isso mede vigilância de segurança sob sabotagem ativa, não qualidade geral de código. Detalhe completo na Parte 1.

## A tabela atualizada, 44 modelos

Mesma tabela da Parte 2, agora com 44 linhas. Os cinco modelos desta atualização estão em **negrito**, pra distinguir de ᴺ, que já marcava adição de rodadas anteriores.

| Posição | Modelo | Nota | Tier | Nunca corrigido | Custo | Tempo | Harness |
|-----:|-------|:-----:|:----:|------------------|:----:|:----:|:-------:|
| 1 | GPT-6 Astra | 100,0 | A | — | $30,55 | 100min | codex |
| 1 | Claude Opus 5 | 100,0 | A | — | ~$71 | 145min | claude |
| 1 | Claude Fable 5 | 100,0 | A | — | ~$50 ᵉ | ~85min ᵉ | claude |
| 1 | **Claude Opus 5.5** | 100,0 | A | — | **$16,63** | 64min | claude |
| 1 | GPT 5.6 sol | 100,0 | A | — | $20,37 | 317min | codex |
| 1 | GPT 5.6 terra | 100,0 | A | — | **$9,52** | 80min | codex |
| 1 | GPT 5.5 | 100,0 | A | — | $34,69 | 117min | codex |
| 8 | Grok 4.6 ᶜ | 98,5 | A | — | $13,00 | 67min | opencode |
| 9 | Claude Fable 5.1 | 95,5 | A | — | ~$51 | 133min | claude |
| 9 | Sakana Fugu Ultra v2 ᴺ | 95,5 | A | — | $122,01 | 294min | opencode |
| 9 | **GPT 6 luna** | 95,5 | A | — | ~$0,84 ᵉ | 122min | codex |
| 12 | GPT 5.6 luna | 95,0 | A | item #8 (2) | $10,04 | 123min | codex |
| 13 | Nex N2.5 Pro ᴺ | 94,0 * | A | — (não commitado) | **$0 grátis** | 480min | opencode |
| 13 | GLM 5.3 (zcode) ᴺ | 94,0 | A | — | plano flat-rate | 215min | zcode |
| 15 | DeepSeek V4.1 Flash ᴺ | 92,5 | A | — | **$1,21** | 172min | opencode |
| 16 | **Xiaomi MiMo V2.6 Pro** | 92,0 | A | item #12 (2) | **$1,22** | 308min | opencode |
| 17 | Claude Sonnet 5 | 91,0 | A | — | ~$27 | 112min | claude |
| 17 | **GPT 6 sol** | 91,0 | A | — | ~$8,35 ᵉ | 73min | codex |
| 19 | Gemini 3.8 Flash·high (OpenRouter) | 90,5 | A | item #12 (2) | $15,98 | 97min | opencode |
| 20 | Gemini 3.8 Flash (Antigravity) ᴺ | 89,5 | A | — | $0 (OAuth) | 120min | agy |
| 21 | Muse Spark 1.3 | 88,75 | A | — | $13,31 | 150min | opencode |
| 22 | Grok 4.5 | 88,0 | A | itens #7b, #12 (3) | $6,19 | 48min | opencode |
| 23 | Claude Opus 4.6 | 87,5 | A | item #8 (2) | $25,64 | 89min | claude |
| 24 | Kimi K2.7 | 87,25 | A | — | $7,75 | 175min | kimi |
| 25 | MiMo V2.5 Pro | 86,5 | A | — | **$1,03** | 158min | opencode |
| 25 | Qwen3 8 Flash ᴿ | 86,5 | A | — | **$1,17** | 149min | opencode |
| 27 | DeepSeek V4 Flash | 86,0 | A | itens #6, #8 (5) | **$0,97** | 111min | opencode |
| 27 | Claude Opus 4.8 ᴿ | 86,0 | A | item #8 (2) | ~$37 | 87min | claude |
| 29 | Claude Sonnet 4.6 | 85,75 | A | item #6 (1,5) | $18,64 | 91min | claude |
| 30 | Kimi K3 | 85,0 | A | — | $13,79 | 148min | kimi |
| 30 | DeepSeek V4 Flash 0731 | 85,0 | A | itens #2, #6 (6) | $1,94 | 194min | opencode |
| 32 | GLM 5.3 Flash (zcode) ᴺ | 84,25 | A | — | plano flat-rate | 296min | zcode |
| 33 | DeepSeek V4 Pro 0813 | 84,0 | A | itens #8, #9 (4) | $4,49 | 152min | opencode |
| 34 | Step 3.7 Flash | 83,75 | A | itens #6, #8, #11 (6,5) | $4,15 | 118min | opencode |
| 35 | **Grok 4.7** | 83,5 | A | — | $27,94 | 120min | opencode |
| 36 | DeepSeek V4 Pro (base) ᶜ | 82,0 | B | — | $5,26 | 97min | opencode |
| 37 | Qwen 3.8 27B (Strix Halo, local) ᴺ | 80,0 | B | itens #2, #7b, #8, #12 (8) | **$0 local** | 706min | opencode |
| 38 | Qwen 3.7 Max | 79,0 | B | itens #6, #7, #8 (6) | $10,63 | 106min | opencode |
| 39 | GLM 5.2 (zcode) ᴺ ᶜ | 77,0 | B | item #12 (2) | plano flat-rate | 239min | zcode |
| 40 | Gemini 3.7 Flash·high | 75,5 | B | item #12 (2) | $12,93 | 85min | opencode |
| 40 | MiniMax M3 | 75,5 | B | itens #6, #8 (3,5) | $12,17 | 187min | opencode |
| 42 | Mistral Large 3 | 39,0 | C | 7 itens (19) | $5,11 | 76min | opencode |
| 43 | Gemini 3.1 Pro (OpenRouter) ᶜ | 32,5 * | C | 9 itens (27) | $10,31 | 54min | opencode |
| 44 | GLM-4.7-Flash (local) ᴺ | 24,0 | C | 6 itens (16) | **$0 local** | 29min | opencode |

Custo não é comparável entre harnesses diferentes: codex/opencode/kimi cobram por token de verdade, Claude usa assinatura Max (custo nocional), Antigravity é OAuth do Google sem custo por token, zcode é plano flat-rate. Compare custo só dentro do mesmo harness.

**Nota sobre o custo do GPT 6 sol e luna (ᵉ):** os dois rodam por assinatura ChatGPT, não API paga por token, então o custo na tabela é uma estimativa, preço por milhão de tokens publicado pela OpenAI ($2 de entrada / $10 de saída pro sol, $0,10 / $0,50 pro luna, o luna sai vinte vezes mais barato por token) aplicado à contagem real de token de cada sprint.

## As surpresas dessa rodada

### Grok 4.7 regrediu, e não só na nota

O Grok 4.7 fechou em 83,5, quinze pontos abaixo do próprio Grok 4.6 (98,5), meu segundo colocado geral. E não, não compensou em custo nem em velocidade: $27,94 e 120 minutos contra $13,00 e 67 minutos do 4.6. Mais caro, mais lento, pior nota. Uma regressão nos três eixos ao mesmo tempo é rara nesse benchmark.

O perfil de erro é bem específico: pegou toda sabotagem barulhenta sozinho, os dois itens críticos, o IDOR, a chave fixa no código, o CORS. Mas empurrou as quatro sabotagens disfarçadas pra revelação, incluindo o XSS armazenado que sobreviveu até o capstone, e ainda foi enganado por um teste adaptado pra aceitar a sabotagem do item #6 no meio do caminho. Forte no óbvio, cego no disfarçado.

Uma rodada limpa só, então trato isso como um ponto de dado, não uma sentença definitiva sobre a família Grok 4.7. Mas o dado que tenho hoje é: pior, mais caro, mais devagar.

### Opus 5.5 é o oposto: mesma nota máxima, um quarto do custo

O Opus 5.5 entrou direto no clube dos 100 pontos, empatando com Astra, Opus 5, Fable 5, GPT 5.6 sol e terra, e GPT 5.5. Pegou tudo sem precisar de revelação nenhuma, o sétimo sprint nem rodou porque não sobrou nada pra revelar. E foi além do mínimo: escreveu teste de regressão próprio pra SQL injection e pra revogação de sessão, e ainda empilhou Content-Security-Policy e Permissions-Policy no capstone, sem ninguém pedir.

O número que importa de verdade: **$16,63 e 64 minutos** contra **~$71 e 145 minutos** do Opus 5, pra chegar exatamente na mesma nota perfeita. Um quarto do custo, menos da metade do tempo, zero perda de qualidade nesse teste específico.

### GPT 6 sol regride em vigilância, GPT 6 luna acerta em cheio

O GPT 6 sol fechou em 91,0, empatado com o Claude Sonnet 5, nove pontos abaixo do próprio GPT 5.6 sol (100,0), mas custando bem menos, ~$8,35 contra $20,37, em menos de um quarto do tempo. Regressão real em vigilância, ganho real em custo e velocidade.

O GPT 6 luna é o destaque positivo da dupla. Fez 95,5, empatando ou passando um pouco o GPT 5.6 luna (95,0), e custando ~$0,84 contra $10,04, cerca de doze vezes menos. Pegou sozinho praticamente tudo, só deixou o XSS armazenado escapar até a revelação, incluindo o item mais disfarçado do teste inteiro com uma correção que foi além do pedido, um índice único a nível de banco de dados. Nota igual ou melhor, custo desabando: a mesma classe de resultado que o Opus 5.5 entregou.

O padrão de erro do sol é o mesmo do Grok 4.7: pega o óbvio sozinho, empurra o disfarçado pra revelação. O luna, de novo, é claramente o mais vigilante dos dois irmãos, e agora também o mais barato dos dois por uma margem enorme.

### MiMo V2.6 Pro: o salto geracional que se sustenta

Da Xiaomi, o V2.6 Pro saltou de 86,5 pra 92,0 sobre o próprio antecessor V2.5 Pro, por apenas **$1,22**. Pegou sozinho praticamente tudo, incluindo o item mais disfarçado do teste inteiro, só que um sprint atrasado, e ainda escreveu os próprios testes de guarda pra SQL injection e N+1. O único item nunca corrigido, nem depois de avisado, foi o CORS liberado demais (#12), a mesma armadilha que já tinha derrubado Grok 4.5, Gemini 3.7 Flash e o GLM 5.2 na Parte 2. Modelo de fronteira mesmo assim consegue deixar `origins "*"` como padrão e nunca voltar nele.

## O que o benchmark externo diz, e onde ele discorda de mim

Fui atrás de quem também testou esses cinco modelos, porque nenhum benchmark isolado, nem o meu, é palavra final. Aqui está o que achei, e onde a leitura bate ou não bate com a minha.

- **Grok 4.7**: a [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-grok-4-7) mede o Coding Agent Index subindo de 47 pra 56, com melhora em todos os três componentes que ela testa, mas avisa que o modelo gasta mais do dobro de token de saída pra chegar lá. Ou seja, num benchmark de capacidade geral de codificação, o 4.7 melhora. No meu teste de vigilância sob sabotagem disfarçada, ele piora. As duas coisas podem ser verdade ao mesmo tempo, porque medem eixos diferentes: capacidade de resolver tarefa versus disciplina de auditar o próprio código sem ser avisado.
- **Claude Opus 5.5**: a cobertura da [VentureBeat](https://venturebeat.com/technology/anthropic-releases-claude-opus-5-5-beating-fable-5-1-on-key-agentic-benchmarks-at-60-cheaper-api-price) e da [CodeRabbit](https://www.coderabbit.ai/blog/opus-5-5-model-review) bate com o que eu achei nesse ponto específico: menos token gasto pra terminar a mesma tarefa. E a própria [Artificial Analysis](https://artificialanalysis.ai/articles/claude-opus-5-5) confirma o resto, o modelo assumiu o topo do índice de inteligência dela, cinco pontos à frente de GPT-6 Astra e Fable 5.1. Aqui a leitura externa confirma a minha.
- **GPT 6 sol e luna**: a cobertura da [Vellum](https://www.vellum.ai/blog/gpt-6-sol-and-luna-benchmarks-explained) e da [Kingy AI](https://kingy.ai/blog/gpt-6-sol-luna-specs-benchmarks-pricing-comparison/) pinta um quadro favorável de capacidade geral, sol perto da nota máxima da Fable 5 por uma fração do custo, luna na faixa do Opus 5. No meu teste específico de vigilância sob sabotagem, o quadro é mais morno, sol regride contra o próprio antecessor. De novo, eixos diferentes, capacidade geral não é a mesma coisa que vigilância de segurança sob ataque disfarçado.
- **Xiaomi MiMo V2.6 Pro**: a [VentureBeat](https://venturebeat.com/technology/better-than-deepseek-xiaomis-mimo-v2-6-pro-debuts-as-the-top-open-weights-model-in-the-world-alongside-cheaper-v2-6-flash) documenta o mesmo salto geracional que eu vi, de 19 pra 71,9 no DeepSWE, de 16 pra 53,1 no AutomationBench. Aqui a direção bate: modelo aberto melhorando de verdade, não só em vigilância.

> **Pra guardar:** minha nota vale só pra minha metodologia específica, vigilância de segurança dentro de um app Rails crescendo sob sabotagem silenciosa. Benchmark de capacidade geral mede outra coisa, e os dois podem discordar sem que nenhum dos dois esteja errado. Ranking isolado nunca é sentença definitiva sobre modelo nenhum, [já expliquei isso com mais calma na Parte 2](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-2/#por-que-o-meu-modelo-favorito-não-ficou-mais-alto).

## Vale a pena migrar pra versão nova?

Nota mais alta num benchmark, o meu ou qualquer outro, não é sinônimo automático de "troque agora". Aqui vai minha resposta direta, modelo por modelo, olhando qualidade contra custo, não só o número isolado.

- **Você usa Grok 4.6 hoje?** Não migre pro 4.7 por causa de segurança. É pior, mais caro e mais lento nos três eixos que meço. Só vale a pena se alguma outra capacidade fora do meu teste justificar, e mesmo assim eu esperaria mais de uma rodada independente confirmando antes de trocar produção.
- **Você usa GPT 5.6 sol?** Migrar pro GPT 6 sol custa bem menos, mas perde nove pontos de vigilância. Vale a troca se custo pesa mais que segurança no seu caso, não vale se você depende justamente dessa vigilância mais alta.
- **Você usa GPT 5.6 luna?** Suba pro GPT 6 luna sem pensar duas vezes: nota igual ou melhor por uma fração pequena do custo anterior. Junto com o Opus 5.5, esse é o outro caso raro de vitória limpa em todos os eixos.
- **Você usa Opus 5?** Esse é outro caso onde a resposta é sim sem ressalva: Opus 5.5 entrega a mesma nota perfeita por um quarto do custo e metade do tempo. Ganho em todos os eixos que meço, ao mesmo tempo.
- **Você usa MiMo V2.5 Pro?** Vale subir pro V2.6 Pro, o salto de qualidade é real e o custo continua na casa de um dólar. Só não esqueça de revisar CORS manualmente, porque esse modelo especificamente ainda erra nisso mesmo depois de avisado.

A régua de sempre continua valendo: teste dentro do seu próprio fluxo de trabalho antes de trocar modelo em produção só porque um benchmark, incluindo o meu, subiu ou desceu um número.

## Fechando com uma ironia que eu não fabriquei

Faz onze dias que o Dario Amodei publicou o ensaio pedindo pra ["pacear a fronteira"](https://darioamodei.com/post/we-must-pace-the-frontier), e o Sam Altman e o Elon Musk correram pra concordar publicamente na mesma semana, como eu já [documentei com detalhe](/2026/09/09/propagandas-enganosas-da-openai-anthropic-nvidia/). E o que aconteceu desde então? Justamente os três, Anthropic, OpenAI e xAI, lançaram Opus 5.5, GPT 6 sol e luna, e Grok 4.7, três laboratórios diferentes, todos em menos de três dias, entre 21 e 23 de setembro.

Não escrevi essa coincidência, só reparei nela. Continua sendo exatamente o padrão sincronizado que eu já tinha apontado: o discurso público é "vamos desacelerar juntos", o calendário de lançamento continua andando junto também.

Tem outro ângulo nessa ironia que vale registrar, e ficou menos limpo do que parecia numa primeira olhada. Dentro do mesmo lote acelerado, o resultado nem é uniforme dentro da mesma empresa: o Grok 4.7 da xAI regrediu feio, e o GPT 6 sol da OpenAI também regrediu em vigilância.

O irmão do sol, o GPT 6 luna, saiu como vitória limpa, nota igual ou melhor por uma fração do custo, a mesma classe de resultado que a Anthropic entregou com o Opus 5.5. Acelerar o lançamento não virou sinônimo de piorar em bloco, virou loteria, a ponto de uma única empresa lançar um modelo pior e um melhor na mesma semana.

E enquanto o trio americano assinava o pacto de desacelerar e entregava resultado misto fazendo isso, a Xiaomi, chinesa, sem assinar pacto nenhum, sem fazer discurso nenhum sobre "pacear a fronteira", simplesmente soltou o MiMo V2.6 Pro com um salto de qualidade real sobre o próprio antecessor. Ninguém do lado chinês prometeu desacelerar. E, pelo menos nessa amostra, ninguém do lado chinês desacelerou.
