---
title: "LLM Benchmarks - Atualizando sobre Grok 4.3, MiniMax v3 e Opus 4.8"
slug: "llm-benchmarks-grok-4-3-minimax-m3-opus-4-8"
date: '2026-06-01T13:00:00-03:00'
draft: false
translationKey: llm-benchmarks-grok-minimax-opus-update
description: "No benchmark Rails 8, Opus 4.8 mantém a liderança com 95/100, enquanto Grok 4.3 e MiniMax M3 enfim ficam usáveis, mas seguem no Tier B e atrás de GPT e Opus."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
---

Esse aqui é um update de rotina, em cima do [benchmark canônico de maio (Parte 3)](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) e do [post do DeepSeek destravado com DeepClaude](/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/). De lá pra cá entraram três modelos novos no teste, e eu registro aqui só por completude: Opus 4.8, Grok 4.3 e o MiniMax M3 (a v3 da MiniMax). Adianto que nada disso mexe na conclusão principal. Mas dado é dado, e eu gosto de manter o ranking honesto e atualizado.

**TL;DR:**

- **Opus 4.8** não me parece muito diferente do Opus 4.7, nem no uso diário nem no benchmark. 95/100 contra 97/100, dentro da margem de ruído. É o Opus mais rápido que eu já medi, mas a experiência no dia a dia é a mesma.
- **Grok 4.3**, anedoticamente, me pareceu um pouco mais literal e estrito em seguir o prompt. No benchmark ele deu uma melhorada substancial sobre a geração anterior (o Grok 4.20). Ainda não chega perto de Opus ou GPT, mas pelo menos agora começa a ficar usável. 72/100, Tier B.
- **MiniMax M3**, mesma história. A versão anterior (M2.7) era inusável, e a nova finalmente é pelo menos usável. 78/100, Tier B.
- Os três caem mais ou menos na faixa de um Sonnet 4.6 ou de um DeepSeek V4. Uma ou duas gerações atrás dos Opus e GPT novos.

## Recapitulando

Pra quem chegou agora: esse benchmark dá pra cada modelo o mesmo prompt e pede pra construir, sozinho, um app de chat estilo ChatGPT em Rails 8 + RubyLLM + Hotwire + Tailwind + Docker, com testes Minitest e tooling de CI. A nota sai de uma rubrica de 8 dimensões, de 0 a 100, distribuída em tiers A/B/C/D. A metodologia completa e os 20+ modelos anteriores estão na série:

1. [Testando LLMs Open Source e Comerciais — Quem Consegue Bater o Claude Opus?](/2026/04/05/testando-llms-open-source-e-comerciais-quem-consegue-bater-o-claude-opus/) (5 de abril). O primeiro corte e a tarefa-base.
2. [LLM Benchmarks Parte 2: Vale Combinar Múltiplos Modelos no Mesmo Projeto?](/2026/04/18/llm-benchmarks-parte-2-multiplos-modelos/) (18 de abril). Primeira tentativa de orquestração planner + subagents.
3. [Benchmark de LLMs pra Coding (Maio 2026): DeepSeek v4, Kimi v2.6, Grok 4.3, GPT 5.5](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) (24 de abril). A versão canônica com a rubrica padronizada. É a referência atual do ranking.
4. [LLM Benchmarks: Vale a pena ($) misturar 2 Modelos?](/2026/04/25/llm-benchmarks-vale-a-pena-misturar-2-modelos/) (25 de abril). Três rodadas de orquestração multi-modelo.
5. [LLM Benchmarks: DeepSeek Destravado! Use DeepClaude](/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/) (4 de maio). O DeepSeek V4 Pro saindo do limbo via troca de harness.

Disclaimer de sempre: tudo aqui vale dentro da metodologia específica desse benchmark, que é entregar um app Rails + RubyLLM completo a partir de um prompt fixo. Um modelo que cai pra Tier B aqui pode brilhar em outro tipo de tarefa (snippet curto, função isolada, raciocínio matemático). Ninguém deve ler isso como julgamento universal de capacidade.

## Ranking atualizado

Os três novos entram em negrito. O resto segue igual ao ranking canônico:

| Rank | Modelo | Score | Tier | RubyLLM OK | Tempo | Custo |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | 97 | A | ✅ | 22m | ~$16 |
| 3 | GPT 5.5 xHigh (Codex) | 96 | A | ✅ | 18m | ~$10 |
| **4** | **Claude Opus 4.8** | **95** | **A** | ✅ | **17m** | **~$1.10** |
| 5 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$0.30 |
| 6 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 |
| 7 | Gemini 3.1 Pro | 82 | A | ✅ | 14m | ~$0.40 |
| 8 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 |
| 8 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| **8** | **MiniMax M3** | **78** | **B** | ✅ | **53m (fase 2 DNF)** | **~$0.10** |
| **11** | **Grok 4.3** | **72** | **B** | ✅ | **15m** | **~$1.74** |
| 12 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 |
| 13 | DeepSeek V4 Pro \* | 69 | B | ✅ | 22m (DNF) | ~$0.50 |
| 13 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0.10 |
| 15 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.14 |
| 16 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 |
| 17 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 |
| 18 | Qwen 3.5 35B (local) | 55 | C | ✅ | 28m | grátis |
| 19 | GLM 4.7 Flash bf16 (local) | 52 | C | ✅ | falhou | grátis |
| 20 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 21 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 |
| 22 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 |
| 23 | Qwen 3.5 122B (local) | 37 | D | ❌ | 43m | grátis |
| 24 | Qwen 3 Coder Next (local) | 32 | D | ❌ | 17m | grátis |
| 25 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.60 |
| 26 | GPT OSS 20B (local) | 11 | D | ❌ | falhou | grátis |

\* DeepSeek V4 Pro chega a Tier A (89/100) só via DeepClaude (Claude Code com env-vars apontando pro OpenRouter). Em opencode, o harness padrão do benchmark, ele bate no bug de `reasoning_content` e fica em 69 (DNF). A história completa está no [post dedicado](/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/).

## Como os três se saíram

### Opus 4.8: o Opus mais rápido, mesma qualidade

Opus 4.8 entra em Tier A com 95/100, dois pontos abaixo do 4.7 (97), ruído de medição. Mantém exatamente o caminho de RubyLLM que põe a família Claude no topo: `RubyLLM.chat(model:, provider: :openrouter, assume_model_exists: true)` + `with_instructions` + `add_message` + `ask` + `response.content`. Sobe pro Ruby 4.0.3, escreve 34 testes com um `FakeChat` de assinatura correta, e a fase 2 do benchmark validou o ciclo inteiro: boot local, POST de verdade no OpenRouter, build do Docker e healthcheck do compose. Foi a run de Opus mais validada de ponta a ponta que eu rodei.

As deduções são pequenas: histórico de session cookie sem limite (estoura em conversa longa) e ausência de preflight checando a API key antes de inicializar o RubyLLM. Nada que tire da Tier A.

Os números de eficiência são o destaque: 104K tokens, 17 minutos, e a maior taxa de tokens/segundo de qualquer Opus no benchmark. É claramente mais rápido. Mas no meu uso diário, sentado no Claude Code, eu não sinto diferença de comportamento pro 4.7. Mesma qualidade de código, mesmo jeito de trabalhar. Quem leu a [Parte 3](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) sabe que a qualidade do código do 4.7 sempre foi Tier A; minha implicância era com o comportamento mais econômico de tokens, que às vezes pula etapa. O 4.8 mantém os dois exatamente onde estavam.

### Grok 4.3: salto de 47 pontos sobre o 4.20, com a UI pela metade

Grok 4.3 marca 72/100 Tier B contra os 25/100 Tier D do Grok 4.20. São 47 pontos de salto, a maior evolução intra-família do benchmark inteiro. E o motivo é direto: a API do RubyLLM agora sai correta em todas as chamadas (`RubyLLM::Chat.new` + `add_message` + `ask` + `response.content` + rescue de `RubyLLM::Error`, tudo verificado contra o código do gem). O 4.20 inventava API e quebrava em produção; o 4.3 escreve o controller mais limpo do benchmark, com Turbo Streams server-side de verdade, README real e `compose.yaml` real.

O problema que segura ele na Tier B é constrangedor de descrever: o **Stimulus está morto em runtime**. O `application.js` é um comentário de uma linha, sem `import "./controllers"`, sem `Application.start()`. Resultado: todo `data-controller="chat"` fica inerte. Enter pra enviar, autoresize, autoscroll, limpar input — metade da UI silenciosamente quebrada. Some a isso testes que dão stub em `RubyLLM.stub :chat` enquanto o controller chama `RubyLLM::Chat.new` (o stub é ignorado) e um pin de modelo velho (`claude-3.7-sonnet`). O backend é sólido, a camada de frontend não acende.

Custo: $1.74 em 15 minutos. Isso é ~5× o preço do Kimi K2.6, que entrega Tier A (87/100) por $0.30. Anedoticamente, no uso fora do benchmark, o Grok 4.3 me pareceu um pouco mais estrito e literal em seguir instruções do prompt, o que pode ser bom ou ruim dependendo de quão preciso você é no pedido.

### MiniMax M3: de inusável a usável

MiniMax M3 sobe pra 78/100 Tier B, contra os 41/100 Tier C do M2.7. O M2.7 alucinava uma assinatura de lote (`RubyLLM.chat(model:, messages: [...])`) que crashava na primeira chamada, literalmente inusável. O M3 conserta isso e usa a API real (`RubyLLM.chat` + `with_instructions` + `add_message` + `ask` + `response.content`). Vem com uma suíte de 19 testes, cap de mensagens na sessão, Turbo Streams e separação de service layer. Código decente.

Duas coisas seguram ele fora da Tier A. A fase 2 travou durante a validação do compose (não terminou), e o modelo escreveu um `.env` de verdade com a `OPENROUTER_API_KEY` dentro do projeto gerado. Eu deletei o arquivo e redigi a chave de todos os artefatos, mas é uma violação séria do prompt (que pede explicitamente "sem secrets em arquivo"), e a higiene de secrets pesou na nota. A $0.10 por run, é barato. Mas barato com vazamento de chave e validação incompleta é exatamente o tipo de coisa que custa caro depois.

## O tamanho do gap pro topo da Tier A

Vale botar os três contra o topo pra dimensionar a distância. O topo da Tier A hoje é Opus 4.7 (97), GPT 5.4 (97), GPT 5.5 (96) e Opus 4.8 (95). Logo abaixo, ainda em Tier A, vêm Kimi K2.6 (87), Opus 4.6 (83) e Gemini 3.1 Pro (82).

Grok 4.3 (72) e MiniMax M3 (78) ficam de 20 a 25 pontos abaixo dos líderes. Esse é o tamanho de "uma ou duas gerações atrás" na prática. E a diferença não está mais na correção da API do RubyLLM — os três acertam isso agora. Está na completude. Os Tier A do topo entregam quatro coisas juntas: testes que mockam o RubyLLM com assinatura correta, rescue em volta do `chat.ask` com UI degradada, persistência que sobrevive a restart e roda multi-worker, e system prompt via `with_instructions`. Por cima de tudo isso, uma camada de frontend que efetivamente funciona. O Grok entrega backend limpo com frontend morto. O MiniMax entrega código sólido mas não conclui a validação e ainda vaza uma chave.

O ângulo de custo fecha o argumento. O slot de "Tier A barato" já está ocupado: Kimi K2.6 entrega Tier A a $0.30, Gemini 3.1 Pro a $0.40, DeepSeek V4 Flash chega a 78 (mesmo Tier B do MiniMax) por um centavo. O Grok 4.3 pede $1.74 pra entregar menos que o Kimi por 5× o preço. O MiniMax é baratíssimo, mas continua Tier B com pendências. Nenhum dos dois abre uma faixa nova de preço/qualidade que ainda não estivesse coberta.

## Conclusão

Quem quiser ir mais fundo, o benchmark é open source: [github.com/akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). Se você quer saber de algum LLM menos popular que eu não tenho interesse em cobrir, faz um fork, adiciona uma entrada no `config/models.json`, roda e manda o PR. O scanner de auditoria e o skill já vêm junto no repo pra facilitar.

Mas o resumo continua o mesmo de sempre. Por padrão, pra programar, escolhe Opus e/ou GPT. Eu uso os dois ao mesmo tempo. Não existe vantagem em escolher qualquer outro, nem se a sua preocupação for preço. O tempo que você gasta consertando a saída dos outros não compensa a economia.

Grok 4.3 e MiniMax M3 são boa notícia no sentido de que o piso está subindo: "usável" é melhor que "inusável", e cada geração nova chega mais perto. Mas usável em Tier B ainda significa 1 a 2 horas de patch por projeto. Com o Opus a $1.10 entregando Tier A direto, os modelos mais baratos só ganham no papel.
