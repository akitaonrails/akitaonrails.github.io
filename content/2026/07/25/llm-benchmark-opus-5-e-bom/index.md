---
title: "LLM Benchmark: Opus 5 é bom?"
slug: "llm-benchmark-opus-5-e-bom"
date: '2026-07-25T12:00:00-03:00'
draft: false
translationKey: llm-benchmark-opus-5-e-bom
description: "Opus 5 fez 95/100 no benchmark Rails, empatou com Opus 4.8 e passou o Fable 5 por um ponto. A tarifa é metade da do Fable, mas o teste estreito não define o melhor LLM."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
---

A Anthropic lançou o **Claude Opus 5** ontem. A pergunta óbvia é:

> "É bom?"

Resposta curta: **sim, é muito bom**. No meu benchmark fez 95/100, Tier A, com a engenharia mais completa que apareceu até agora em qualquer um dos harnesses que testei.

Agora a resposta que interessa: não, isso não prova que virou "o melhor LLM do mundo". Nem prova que é melhor que Fable 5, Opus 4.8, GPT 5.6 Sol ou Kimi K3 em qualquer trabalho que você jogar neles. Semana passada publiquei um artigo inteiro explicando [por que a maior nota não significa o melhor modelo](/2026/07/19/llm-benchmark-devo-usar-o-que-tem-nota-maior/). O Opus 5 chegou a tempo de produzir um belo estudo de caso praquele texto.

## Onde a Anthropic posiciona o Opus 5

No [anúncio oficial](https://www.anthropic.com/news/claude-opus-5), a Anthropic descreve o Opus 5 como um modelo de uso diário que chega perto da inteligência de fronteira do Fable 5, mas custa metade. Ele virou o modelo padrão no Claude Max e o mais forte disponível no Pro.

A escadinha comercial parece simples:

```text
Opus 4.8  <  Opus 5  ≈  Fable 5
```

Só que nem os dados da própria Anthropic formam uma linha tão limpa. No CursorBench 3.2, em esforço máximo, Opus 5 fica a 0,5% do pico do Fable 5. No Frontier-Bench v0.1, supera todos os outros modelos e mais que dobra o resultado do Opus 4.8 com custo menor por tarefa. No OSWorld 2.0, chega a passar o melhor resultado do Fable por pouco mais de um terço do custo.

Então "entre Opus 4.8 e Fable 5" é um atalho razoável pra entender o produto. Não é uma classificação universal. Dependendo da tarefa e do esforço escolhido, as curvas se cruzam.

O preço é mais objetivo. Opus 5 custa **$5 por milhão de tokens de input e $25 por milhão de output**, igual ao Opus 4.8. Fable 5 custa **$10/$50**. Em tarifa de API, Opus 5 entrega a promessa mais interessante do lançamento: comportamento próximo de Fable sem pagar a taxa Fable.

## O benchmark

Pra quem caiu de paraquedas, meu [LLM Coding Benchmark](https://github.com/akitaonrails/llm-coding-benchmark) dá o mesmo problema a todos: construir sozinho um chat estilo ChatGPT em Rails 8, com RubyLLM, Hotwire, Tailwind, testes, CI, Docker e documentação.

Não avalio uma função isolada. Avalio o projeto que saiu no final: se usa a API real do RubyLLM, se multi-turn funciona, se trata falhas do provider, se a conversa persiste, se Turbo Streams está ligado de verdade, se os testes conseguem pegar bugs e se a imagem de produção sobe.

O Opus 5 rodou solo pelo **Claude Code headless**, com `--dangerously-skip-permissions`, usando minha assinatura Max. Foram:

- **38m57s**
- **201 turnos**
- **121 testes e 355 assertions**
- **100% de cobertura de linhas e 95,94% de branches**
- **22,1 milhões de tokens de cache read**
- **$16,02 equivalentes em tarifa de API**, mas cobrados da assinatura

Isso exige um asterisco. Opus 4.8 e Fable 5 foram testados no OpenCode via OpenRouter. GPT 5.6 Sol rodou no Codex. Kimi K3 rodou no Kimi Code CLI. Coding benchmark mede o pacote inteiro:

```text
modelo + prompt + harness + tools + contexto + execução + auditoria
```

Por isso o repositório mantém o Opus 5 no perfil de Claude Code em vez de fingir que foi uma comparação perfeitamente controlada com a tabela principal. Aqui vou juntar as 40 linhas do ranking principal com o novo resultado porque todo mundo quer enxergar onde o 95 cai. O asterisco não é enfeite.

## Ranking atualizado: tabela principal + Opus 5

| Rank | Modelo | Score | Tier | RubyLLM OK | Tempo | Custo da rodada |
|---:|---|---:|:---:|:---:|---:|---:|
| **1** | **Claude Opus 5 (Claude Code)\*** | **95** | **A** | ✅ | **39m** | **assinatura (≈$16,02 equiv. API)** |
| 1 | GPT 5.4 xHigh (Codex) | 95 | A | ✅ | 22m | ~$16 |
| 1 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$6,40 |
| 4 | Claude Fable 5 | 94 | A | ✅ | 24m | ~$11,20 |
| 5 | Claude Fable 5 (re-release) | 93 | A | ✅ | 18m | ~$8,30 |
| 5 | Gemini 3.5 Flash | 93 | A | ✅ | 18m | ~$3,55 |
| 7 | GPT 5.6 Sol xHigh (Codex) | 92 | A | ✅ | 17m | assinatura (≈$8,70 equiv. API) |
| 8 | Kimi K3 (Kimi Code CLI) | 89 | A | ✅ | 26m | assinatura (≈$2,10 equiv. API) |
| 9 | Claude Opus 4.7 | 87 | A | ✅ | 18m | ~$7,00 |
| 9 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$1,19 |
| 9 | GLM 5.2 (Z.ai) | 87 | A | ✅ | 43m | assinatura |
| 9 | Grok 4.5 | 87 | A | ✅ | 16m | ~$5,10 |
| 13 | Kimi K2.7 Code | 86 | A | ✅ | 22m | ~$1,23 |
| 14 | GPT 5.5 xHigh (Codex) | 85 | A | ✅ | 18m | ~$10 |
| 15 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1,10 (hist.) |
| 15 | Nex-N2-Pro | 83 | A | ✅ | 25m | ~$0,34 |
| 17 | Gemini 3.1 Pro | 79 | B | ✅ | 14m | ~$3,10 |
| 17 | Sakana Fugu Ultra | 79 | B | ✅ | 22m | assinatura |
| 19 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0,63 (hist.) |
| 19 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0,01 |
| 19 | MiniMax M3 | 78 | B | ✅ | 53m (fase 2 DNF) | ~$1,25 |
| 19 | Qwen3.7 Max | 78 | B | ✅ | 19m | ~$1,40 |
| 23 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1,70 |
| 24 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0,15 (hist.) |
| 25 | DeepSeek V4 Pro | 69 | B | ✅ | 22m (DNF) | ~$0,05 |
| 25 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0,10 (hist.) |
| 25 | Step 3.7 Flash | 69 | B | ✅ | 27m | ~$0,80 |
| 28 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0,09 |
| 29 | GLM 5 | 64 | B | ✅ | 17m | ~$0,11 (hist.) |
| 30 | Claude Sonnet 5 | 58 | C | ❌ | 27m | ~$2,25 |
| 31 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0,02 (hist.) |
| 32 | Qwen 3.5 35B | 55 | C | ✅ | 28m | local |
| 33 | GLM 4.7 Flash bf16 | 52 | C | ✅ | falhou | local |
| 34 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | assinatura |
| 35 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0,07 (hist.) |
| 36 | Qwen 3.5 397B A17B | 42 | C | ❌ | 15m | ~$0,31 |
| 37 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0,30 (hist.) |
| 38 | Qwen 3.5 122B | 37 | D | ❌ | 43m | local |
| 39 | Qwen 3 Coder Next | 32 | D | ❌ | 17m | local |
| 40 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0,70 |
| 41 | GPT OSS 20B | 11 | D | ❌ | falhou | local |

\* Opus 5 recebeu 95/100 equivalente no perfil Claude Code. A tabela principal do repositório o mantém separado pra deixar a diferença de harness explícita.

## O que o Opus 5 escreveu

O score sozinho esconde a parte mais interessante. O projeto do Opus 5 foi o melhor exemplo de engenharia defensiva que apareceu até agora no benchmark.

Ele isolou todo acesso ao RubyLLM num único `Assistant::Client`, injetou a factory do chat pra testes e verificou a API real da gem antes de depender dela. Além dos mocks de `RubyLLM.chat`, `with_instructions`, `add_message` e `ask`, criou um teste de guarda que confirma que esses métodos continuam existindo na gem instalada. Se a biblioteca mudar a interface, o CI quebra antes da produção.

A conversa fica atrás de um `ConversationRepository` em `Rails.cache`, com TTL de 12 horas e limite de 40 mensagens no replay. Antes de mandar histórico ao provider, normaliza a alternância entre `user` e `assistant`, remove respostas que falharam e garante que a janela não começa com uma mensagem de assistant. Parece detalhe até a API rejeitar o payload no segundo turno.

Foi exatamente aí que o modelo encontrou e consertou dois bugs durante o próprio run. Uma resposta que falhou podia deixar duas mensagens de usuário seguidas. Cortar a janela do histórico também podia começar numa resposta do assistant. Ele escreveu os testes, corrigiu e validou multi-turn real, inclusive recuperação depois de uma falha.

Também entregou:

- streaming fora do request principal;
- broadcasts Turbo Streams assinados e limitados a cerca de 10 atualizações por segundo;
- preflight de credencial;
- mensagens diferentes pra chave inválida, rate limit, falta de crédito, contexto estourado e provider indisponível;
- Markdown escapado antes de formatar HTML;
- Dockerfile multi-stage, produção, non-root;
- RuboCop, Brakeman, bundler-audit, importmap audit e GitHub Actions.

Não é 100. Existe uma race de lost update se outra mensagem entrar durante a geração, embora o próprio projeto limite o deploy a `WEB_CONCURRENCY=1`. Também deixou o modelo padrão em Sonnet 4.6 quando Sonnet 5 já existia, e comitou lixo de `log/` e `coverage/` dentro do artefato. Foram as deduções que seguraram em 95.

## Opus 5 contra Opus 4.8 e Fable 5

Primeiro os números do nosso teste:

| Modelo | Score | Tempo | Testes | Persistência | Tarifa API |
|---|---:|---:|---:|---|---:|
| Opus 5 | 95 | 39m | 121 | Rails.cache, TTL, replay limitado | $5 / $25 |
| Opus 4.8 | 95 | 17m | 34 | session cookie sem cap | $5 / $25 |
| Fable 5 | 94 | 24m | 36 | singleton local, capped | $10 / $50 |
| Fable 5 (re-release) | 93 | 18m | 41 | Rails.cache com TTL, sem hard cap | $10 / $50 |

O [Opus 4.8 tinha feito 95](/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/) com uma solução menor e muito mais rápida. Usou a API correta, escreveu testes honestos e fez a melhor validação ao vivo daquela rodada: Rails local, chamada real ao OpenRouter, Docker, container de produção e Compose. Perdeu pontos por deixar o histórico sem limite no cookie e não fazer preflight da chave.

Opus 5 corrigiu os dois defeitos e foi bem além na arquitetura, no streaming e nos testes. Em compensação, criou outra race, deixou o pin desatualizado e gastou mais do dobro do tempo. Mesma nota, artefatos bem diferentes.

O [Fable 5 original fez 94](/2026/06/11/llm-benchmark-fable-5-e-a-novela-da-anthropic/). Foi o primeiro modelo que vi parar no meio do trabalho pra ler o source instalado do RubyLLM antes de escrever a integração. Tinha 99,3% de cobertura, cap de histórico, preflight e uma fase 2 sem nenhum conserto. A grande dedução foi guardar conversa num singleton em memória: reinicia o processo, perde tudo; sobe mais de um worker, cada um enxerga um mundo.

O re-release do Fable corrigiu isso com `Rails.cache`, mas deixou o cache sem hard cap, manteve Sonnet 4.6 e fez uma validação ao vivo mais fraca. Caiu um ponto. Mesma identificação de modelo, outro projeto, outro score.

Nos limites desse app Rails, Opus 5 parece mais completo que os dois Fable e pelo menos tão bom quanto Opus 4.8. Só não confunda isso com "Opus 5 tem mais inteligência que Fable". A Anthropic diz que a vantagem do Fable cresce quanto mais longa e complexa fica a tarefa. Nosso projeto é pequeno, greenfield e fechado. Pode simplesmente não ter espaço pra mostrar a diferença.

## O preço: metade do Fable, mas cuidado com a conta

Na API, a vantagem é direta:

| Modelo | Input / milhão | Output / milhão |
|---|---:|---:|
| Opus 5 | $5 | $25 |
| Opus 4.8 | $5 | $25 |
| Fable 5 | $10 | $50 |

Se Opus 5 realmente entrega comportamento próximo de Fable no seu workload, pagar o dobro por Fable fica difícil de justificar. Fable precisa resolver algo que Opus não resolve, não apenas carregar o nome da tier acima.

Mas o custo observado nessa rodada conta outra história:

| Modelo | Harness | Custo da rodada |
|---|---|---:|
| Opus 5 | Claude Code / Max | assinatura (≈$16,02 em API) |
| Opus 4.8 | OpenCode / OpenRouter | ~$6,40 |
| Fable 5 | OpenCode / OpenRouter | ~$11,20 |

Como um modelo com tarifa pela metade do Fable acabou com equivalente maior? Porque preço por milhão não é custo por tarefa. O run do Opus 5 fez 201 turnos e acumulou 22,1 milhões de cache reads no Claude Code. O run do Fable usou outro harness e outro perfil de tokens. Comparar $16,02 com $11,20 como se fosse só diferença de modelo seria errado.

Pra mim, assinante Max, o custo marginal real foi zero enquanto eu estiver dentro da franquia. Pra automação que paga API por token, a tarifa do Opus 5 é metade da do Fable e igual à do 4.8. Aí eu começaria no Opus 5 e só subiria pra Fable com evidência de que a tarefa precisa dele.

## Contra GPT 5.6 Sol e Kimi K3

O [GPT 5.6 Sol fez 92](/2026/07/09/llm-benchmark-grok-4-5-gpt-5-6-sol/) em 17 minutos. Foi muito mais econômico em tokens e entregou uma aplicação defensiva: Docker non-root, 99,2% de cobertura, histórico limitado por mensagens, caracteres e bytes, e um teste específico pra não repetir o prompt atual no contexto.

Perdeu pontos porque não usou `with_instructions` e carregou o histórico num hidden field do browser. Funciona, mas perde a conversa no reload e deixa o cliente adulterar o contexto. O Opus 5 colocou essas responsabilidades no servidor, separou melhor domínio, persistência e provider, e testou muito mais. Neste projeto, a diferença de três pontos faz sentido. No uso diário, os dois continuam no mesmo cluster de modelos fortes.

O [Kimi K3 fez 89](/2026/07/17/llm-benchmarks-kimi-k3/) em 26 minutos. Ele já tinha acertado o padrão que decide boa parte do topo: `Rails.cache`, TTL e cap de histórico. Custou só cerca de $2,10 equivalentes em API pela assinatura Moderato.

Ficou abaixo porque não tinha system prompt, colocou I/O do LLM dentro do model `Conversation`, não fez preflight de credencial e deixou o cache de produção no default efêmero do container. Opus 5 fecha quase todas essas lacunas. Kimi continua sendo uma alternativa Tier A bem mais barata; Opus 5 é o projeto que eu precisaria mexer menos antes de confiar.

## O Opus 5 também derrubou o antigo campeão

Tem uma mudança importante na tabela que não veio do código novo. Até ontem, Opus 4.7 aparecia em primeiro com 97. O cross-audit cego entre ele e Opus 5 deu **94 contra 70** a favor do 5. Fui reler os artefatos antigos.

O Opus 4.7 tinha um bug de double-send: o controller salvava a mensagem do usuário antes de chamar o service, e o service reenviava todo o histórico, incluindo aquela mesma mensagem. Cada prompt chegava duas vezes ao LLM. As mensagens de erro também voltavam no contexto de pedidos futuros, e o cookie tinha limite de quantidade, mas não de bytes.

Os testes passavam porque controller e service eram testados em arranjos diferentes do fluxo de produção. O modelo não piorou desde abril. O projeto também não mudou. **Minha auditoria é que estava incompleta.** Recalculei a nota de 97 pra 87.

Isso é quase cômico porque o artigo da semana passada usava justamente "por que Opus 4.7 fica acima de 4.8 e Fable?" como exemplo. Agora não fica. E o argumento do artigo ficou ainda mais forte.

Benchmark não é escritura sagrada. A rubrica evolui, o auditor encontra um ponto cego, o harness muda, o mesmo modelo gera outro projeto. Se uma tabela não publica prompt, artefato, logs e correções, ela serve mais pra marketing que pra engenharia.

## Conclusão

Opus 5 é bom? **Sim.** Muito.

Fez 95/A, empatou com Opus 4.8 e GPT 5.4 no score, ficou um ponto acima do Fable original, três acima do GPT 5.6 Sol e seis acima do Kimi K3. Produziu o projeto mais cuidadoso desta rodada inteira: arquitetura limpa, RubyLLM verificado na gem real, histórico correto, streaming bem feito, erros separados e 121 testes.

Também levou 39 minutos, queimou 22 milhões de cache reads e rodou num harness diferente. A nota maior que Fable não prova que é melhor que Fable no geral. Prova que, neste app Rails, nesta execução pelo Claude Code e nesta auditoria, o artefato encaixou um pouco melhor na rubrica.

Minha leitura prática: Opus 5 merece entrar como primeira opção. A tarifa é a mesma do Opus 4.8 e metade da do Fable. Pra quem tem Claude Pro ou Max, vira a escolha óbvia antes de gastar créditos no Fable. Pra quem paga API, eu também começaria nele e exigiria dados antes de subir pra tier de $10/$50.

E a regra continua a mesma: leia 90+ como um grupo. Tier A está claramente acima de Tier C neste workload. Dentro do grupo bom, escolha por custo, assinatura, velocidade, harness e pelo tipo de defeito que você aceita revisar.

Não use meu benchmark pra decidir qual é "o melhor LLM". Use pra escolher o que vale testar no seu problema. Se a decisão importa, rode a sua metodologia, mais de uma vez, e leia o código.
