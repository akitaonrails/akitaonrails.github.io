---
title: "LLM Benchmarks: Os últimos Deepseek v4, parem de perguntar"
slug: llm-benchmarks-os-ultimos-deepseek-v4-parem-de-perguntar
date: '2026-08-22T15:00:00-03:00'
draft: false
translationKey: llm-benchmarks-os-ultimos-deepseek-v4-parem-de-perguntar
description: "Rodei os snapshots novos do Deepseek v4 no benchmark: Flash saltou de 80 pra 90 e o Pro de 82 pra 91, ambos Tier A, os mais baratos do pelotão. Continuo preferindo Kimi K3 e GLM 5.3, e explico por que nota parecida não significa modelo equivalente."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
---

Semana passada eu publiquei a rodada com [Qwen 3.8, GLM 5.3, Gemini 3.7 e Grok 4.6](/2026/08/15/llm-benchmarks-qwen-3-8-glm-5-3-gemini-3-7/) no meu benchmark v2: a prova em três fases (construir, validar rodando de verdade, se auto-revisar com nota de honestidade) que endurece um app Rails 8 de chat com LLM. O topo segue o mesmo: Fable 5 com 96, o trio Sonnet 5, Opus 5 e Kimi K3 com 95, GLM 5.3 sozinho com 94, e o pelotão dos 93 logo atrás.

E toda vez que eu publico uma dessas atualizações, sem exceção, aparece alguém nos comentários: *"e o Deepseek?"*

Confesso que eu não entendo esse foco cego no Deepseek. É um modelo aberto entre tantos outros, e não tem nada que o destaque do pelotão. No meu uso diário, eu continuo preferindo Kimi K3 ou GLM 5.3. Sim, a cada iteração eles melhoram um pouco. Sim, eu testei os dois snapshots novos (Flash 0731 e Pro 0813) e os números estão aqui embaixo. E mesmo assim, a resposta continua sendo: ninguém ali está na classe do Fable 5 ou do Sol.

## O que essa nota mede (e o que ela não mede)

Antes dos números, o lembrete que precisa ser repetido a cada rodada. O benchmark testa um recorte muito específico: programação web **fácil**. Um CRUD de chat em Rails com streaming, tools, concorrência e testes. É uma prova útil porque é concreta, reproduzível e pega alucinação de API no flagra, mas continua sendo um recorte estreito.

Ela não diz nada sobre tarefas muito mais avançadas: desenvolvimento de driver de kernel, otimização de game engine, segurança ofensiva de verdade. É impossível testar a totalidade de um modelo. O que dá pra testar é um subconjunto, e foi o que eu fiz.

Então, da próxima vez que você vir "Kimi está prestes a destronar o Fable" ou "GLM vai passar o Sol" porque as notas ficaram parecidas, leia assim: num subconjunto estreito de programação web, qualquer um desses modelos entrega. Só isso. Nota próxima nessa prova significa proximidade **nessa prova**, em mais nada.

> **Pra guardar:** benchmark mede um recorte. O meu mede web app fácil em Rails. Quem extrapola isso pra "modelo X é melhor que modelo Y em tudo" está lendo o número errado.

## O ranking do Tier A, com foco no tempo

A tabela de sempre, recorte A.1 (90 pontos ou mais), agora com os dois Deepseek em **negrito**. Dessa vez preste atenção na coluna de tempo: é a mesma prova, as mesmas três fases, pra todo mundo.

| # | Modelo | Score | Harness | Tempo | Custo |
|---:|---|---:|---|---:|---:|
| 1 | Claude Fable 5 | 96 | Claude Code | 46 min | $26,03 |
| 2 | Claude Sonnet 5 | 95 | Claude Code | 59 min | $25,83 |
| 2 | Claude Opus 5 | 95 | Claude Code | 78 min | $38,91 |
| 2 | Kimi K3 | 95 | Kimi CLI | 65 min | $6,14 |
| 5 | GLM 5.3 | 94 | OpenCode | 80 min | $0 (≈$2,59) |
| 6 | GPT 5.6 Sol | 93 | Codex | 57 min | ~$45 |
| 6 | Claude Opus 4.8 | 93 | Claude Code | 53 min | $21,82 |
| 6 | GPT 5.6 Terra | 93 | Codex | 48 min | $16,92 |
| 6 | Gemini 3.7 Flash | 93 | OpenCode | 43 min | $4,12 |
| 10 | GLM 5.2 | 92 | OpenCode | 155 min | $0 (≈$12,05) |
| 10 | Kimi K2.5 | 92 | OpenCode | 43 min | $1,50 |
| 10 | Gemini 3.6 Flash @ high | 92 | Antigravity | 15 min | — |
| 10 | Qwen 3.8 Max | 92 | OpenCode | 78 min | $9,16 |
| 10 | Grok 4.6 | 92 | OpenCode | 34 min | $6,33 |
| 15 | MiniMax M3 | 91 | OpenCode | 113 min | $7,72 |
| 15 | Kimi K2.6 | 91 | OpenCode | 34 min | $2,64 |
| 15 | Claude Opus 4.7 | 91 | Claude Code | 44 min | $44,28 |
| 15 | GPT 5.6 Luna | 91 | Codex | 46 min | $16,79 |
| 15 | **Deepseek v4 Pro (0813)** | **91** | OpenCode | **82 min** | **$5,01** |
| 15 | Grok 4.5 | 91 | grok CLI | 25 min | $0 (≈$1,62) |
| 21 | **Deepseek v4 Flash (0731)** | **90** | OpenCode | **88 min** | **$0,82** |

*Tempo é o wall clock das três fases; custo é equivalente em API. O critério é o mesmo dos artigos anteriores, link no fim.*

Olha o espalhamento de tempo. O mais rápido do grupo resolve a prova em 15 minutos; o mais lento leva 155, **dez vezes mais**. Os dois Deepseek ficam na metade de baixo da tabela em velocidade: 82 e 88 minutos, atrás de quase todo mundo na mesma faixa de nota. O Flash, em particular, despejou **44 milhões de tokens** na rodada. Pra comparação, o GLM 5.3 fez um ponto a mais com 19,4 milhões. O Deepseek compensa na fatura: os $0,82 do Flash são o menor custo de uma rodada Tier A até hoje.

## Os snapshots novos: o que mudou de julho pra cá

Rodei os builds de julho do v4 no fim daquele mês: Flash fez 80, Pro fez 82, ambos Tier B. Os dois snapshots datados (0731 e 0813) rodaram hoje sob o mesmo rigor, e os dois entraram no Tier A:

**Flash 0731: de 80 pra 90 (+10).** A melhoria mais visível é de comportamento. O build de julho pinava um modelo três gerações atrás; esse acertou o pin de primeira (`anthropic/claude-sonnet-5`, sem slug velho). A auto-revisão foi exemplar: ele mesmo encontrou que o partial da bolha de streaming era código morto (nenhuma resposta aparecia até um reload forçado nas fases 1 e 2), confessou, corrigiu e tirou 15/15 em honestidade. Perdeu pontos onde o pelotão perde: concorrência sem lock de turno (8) e cobertura sem branch (8).

**Pro 0813: de 82 pra 91 (+9).** A notícia grande é o que sumiu: o bug do `reasoning_content` que quebrava o multi-turn dele no OpenCode e me obrigou a inventar a [gambiarra do deepclaude](/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/) em maio foi corrigido no opencode 1.18.4, e esse snapshot rodou ponta a ponta no harness genérico, sem muleta. O destaque técnico foi a concorrência: store SQLite com leitura-modificação-escrita dentro de `BEGIN IMMEDIATE`, a solução mais séria do grupo nessa dimensão (9/10). As perdas foram honestas e confessadas: pin velho no sonnet-4.6, streaming verificado só por teste unitário, sem estimador de orçamento com fallback.

Rodadas limpas, blindadas, zero leitura de rubrica ou de app alheio. Os relatórios completos estão no [repositório do benchmark](https://github.com/akitaonrails/llm-coding-benchmark).

## Deepseek contra ele mesmo: a trajetória é real

Critério novo e critério velho não se comparam ponto a ponto, então essa seção é sobre comportamento, não sobre nota. E comportamento dá pra comparar, porque o contraste é gritante.

Em abril, o **Deepseek V3.2** fez 43 no critério antigo e protagonizou o momento mais constrangedor da história do benchmark: inventou a integração inteira com o RubyLLM. `RubyLLM::Client.new`, `client.chat(messages:)`, os dois métodos alucinados, a camada de LLM inteira ficcional.

Ainda no critério velho, o **v4 Flash** fez 78 com um bug fatal de um caractere (o slug do modelo sem o prefixo `anthropic/`), e o **v4 Pro** deu DNF com 69: código de Tier 1, entrega de Tier 3, derrubado pelo bug do `reasoning_content` que comia o histórico da conversa. Foi esse bug que gerou o hack do deepclaude, onde o mesmo Pro saltou pra 89.

No v2, os builds de julho fizeram 80 e 82. Os snapshots de hoje, 90 e 91. Saindo do "inventou a API inteira" pra "acha o próprio código morto e confessa na auto-revisão" em quatro meses. A curva do Deepseek é das mais íngremes que essa prova já registrou, e seria desonesto fingir o contrário.

## E contra os outros chineses?

Aqui a conversa fica menos empolgante pra torcida. No mesmo harness genérico (OpenCode), o pelotão chinês fica assim:

| Modelo | Score | Tempo | Custo |
|---|---:|---:|---:|
| GLM 5.3 | 94 | 80 min | $0 (≈$2,59) |
| Qwen 3.8 Max | 92 | 78 min | $9,16 |
| Kimi K2.5 | 92 | 43 min | $1,50 |
| Deepseek v4 Pro (0813) | 91 | 82 min | $5,01 |
| Deepseek v4 Flash (0731) | 90 | 88 min | $0,82 |

E o Kimi K3, que não aparece nessa tabela por ter rodado no harness nativo dele, fez 95. Ou seja: dentro da mesma prova, o Deepseek v4 chega atrás do GLM 5.3, do Qwen 3.8 Max e dos Kimi, sendo o mais lento e o mais verboso do grupo chinês. A vantagem dele é uma só, e é real: preço. $0,82 por uma rodada Tier A é impressionante, e o Pro a $5,01 fica abaixo de quase todo mundo na mesma nota.

Se o seu critério é "máximo de competência por dólar em tarefa web simples", o Flash 0731 merece atenção. Se o critério é o melhor modelo do grupo, a resposta continua sendo Kimi K3 e GLM 5.3, como era semana passada.

## Conclusão: parem de perguntar

Pronto, agora tem número na mesa. O Deepseek v4 melhorou de verdade entre julho e agosto, os dois snapshots entraram no Tier A, o Pro se livrou do bug que exigia gambiarra de harness, e o Flash é a rodada Tier A mais barata que eu já rodei. Tudo isso é fato.

E nada disso muda o quadro. A liderança continua com Fable 5, Sonnet 5, Opus 5 e Sol; o primeiro chinês da fila continua sendo o Kimi K3, seguido do GLM 5.3. O Deepseek é mais um modelo competente num recorte de tarefa fácil, com a virtude de ser barato e o defeito de ser prolixo. Da próxima vez que bater a vontade de comentar "e o Deepseek?", a resposta é este artigo.
