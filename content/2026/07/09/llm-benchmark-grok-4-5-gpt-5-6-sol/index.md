---
title: "LLM Benchmarks: Grok 4.5 e GPT 5.6 Sol"
slug: "llm-benchmark-grok-4-5-gpt-5-6-sol"
date: '2026-07-09T15:00:00-03:00'
draft: false
translationKey: llm-benchmark-grok-4-5-gpt-5-6-sol
tags:
  - llm
  - benchmark
  - grok
  - gpt
  - openai
  - pricing
  - ai
  - vibecoding
---

Mais uma rodada do meu benchmark de coding. No [post anterior](/2026/07/01/llm-benchmark-sonnet-5-gemini-3-5-flash-sakana-fugu-ultra/), o Sonnet 5 chegou com nome forte e terminou em 58/100 Tier C (expectativa não compila), enquanto o Gemini 3.5 Flash surpreendeu com 93/100 Tier A e o Sakana Fugu Ultra empacou no limite do Tier B. A recomendação prática seguia a mesma de sempre: pra trabalho sério, Opus ou GPT via Claude Code, Codex ou OpenCode.

Dessa vez tem dois nomes novos e um estremecimento na parte de cima da tabela. O **Grok 4.5** finalmente puxou a família Grok pra Tier A, e o **GPT 5.6 Sol**, a nova geração da OpenAI, estreou. Mas o resultado mais desconfortável não foi de nenhum dos dois: foi uma **reauditoria** que derrubou o GPT 5.5 de 96 pra 85 e o GPT 5.4 de 97 pra 95. Explico já já.

## Pra quem caiu de paraquedas

Esse benchmark dá pra cada modelo o mesmo prompt e pede pra construir, sozinho, um app de chat estilo ChatGPT em Rails 8 + RubyLLM + Hotwire + Docker, com testes e CI. A nota sai de uma rubrica de 8 dimensões, de 0 a 100, distribuída em tiers A/B/C/D. Tudo é lido na mão, e desde algumas rodadas atrás cada projeto ainda passa por um **cross-audit cego** (um juiz independente reavalia sem saber qual modelo escreveu). A metodologia completa está na [Parte 3](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) e nos updates seguintes.

## Ranking atualizado

Os dois novos em negrito. Repara que os custos mudaram bastante, e volto nisso na seção de preço:

| Rank | Modelo | Score | Tier | RubyLLM OK | Tempo | Custo |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$7.00 |
| 2 | GPT 5.4 xHigh (Codex) | 95 | A | ✅ | 22m | ~$16 |
| 2 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$6.40 |
| 4 | Claude Fable 5 | 94 | A | ✅ | 24m | ~$11.20 |
| 5 | Claude Fable 5 (re-release) | 93 | A | ✅ | 18m | ~$8.30 |
| 5 | Gemini 3.5 Flash | 93 | A | ✅ | 18m | ~$3.55 |
| **7** | **GPT 5.6 Sol xHigh (Codex)** | **92** | **A** | ✅ | **17m** | **créditos (~$8.70 equiv. API)** |
| 8 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$1.00 |
| 8 | GLM 5.2 (Z.ai) | 87 | A | ✅ | 43m | subscription |
| **8** | **Grok 4.5** | **87** | **A** | ✅ | **16m** | **~$5.10** |
| 11 | Kimi K2.7 Code | 86 | A | ✅ | 22m | ~$1.15 |
| 12 | GPT 5.5 xHigh (Codex) | 85 | A | ✅ | 18m | ~$10 |
| 13 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 (hist.) |
| 13 | Nex-N2-Pro | 83 | A | ✅ | 25m | ~$0.34 |
| 15 | Gemini 3.1 Pro | 79 | B | ✅ | 14m | ~$3.10 |
| 15 | Sakana Fugu Ultra | 79 | B | ✅ | 22m | subscription |
| 17 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 (hist.) |
| 17 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 17 | MiniMax M3 | 78 | B | ✅ | 53m (fase 2 DNF) | ~$1.25 |
| 17 | Qwen3.7 Max | 78 | B | ✅ | 19m | ~$1.40 |
| 21 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.70 |
| ... | *(cauda B/C/D omitida)* | | | | | |
| 28 | Claude Sonnet 5 | 58 | C | ❌ | 27m | ~$2.25 |
| 38 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.70 |

A tabela completa, com os 39 modelos, está no [repositório do benchmark](https://github.com/akitaonrails/llm-coding-benchmark).

Sobre a coluna de custo: é o gasto aproximado de tokens por run, na tarifa verificada em 09/07/2026. Onde aparece **`(hist.)`**, é o valor do dia em que aquele modelo rodou, ainda sem recontar os tokens de cache-read, então está subestimado (exatamente o erro que eu corrijo na seção de preço lá embaixo). Não dá pra comparar um número "(hist.)" com um número atualizado.

## Grok 4.5: a família Grok enfim chega na Tier A

A trajetória da xAI nesse benchmark é uma das mais bonitas de acompanhar. Grok 4.20 fez 25/100 Tier D. Grok 4.3 subiu pra 72/100 Tier B. E agora o **Grok 4.5 marca 87/100, Tier A**. Ele conserta as três falhas que seguravam o 4.3: o Stimulus agora está vivo (o 4.3 mandava um comentário de uma linha e a UI inteira ficava morta), os testes não conseguem mais furar o stub (injeção de dependência de verdade no `LlmClient`), e o pin do modelo é o Sonnet 4.6 atual, não o `claude-3.7-sonnet` velho. A integração com RubyLLM está toda correta, verificada contra o código do gem, com Turbo Streams reais, cookie de sessão com teto e 28 testes cobrindo os caminhos de erro. Engenharia sólida de verdade.

O que segura ele no cluster dos 87 é um bug sutil que só o cross-audit cego pegou, e é do tipo que me fascina: o **double-send**. O controller anexa a mensagem do usuário à sessão **antes** de chamar o service, e o `previous_messages` só filtra mensagens de sistema. Resultado: o replay de histórico já contém a mensagem nova, e o `chat.ask(user_message)` então manda ela **de novo**. Cada turno do usuário chega no LLM duas vezes. Desperdício de token e uma conversa sutilmente corrompida. E o teste do service monta o histórico *sem* a mensagem pendente, uma precondição diferente da produção, e é por isso que a suíte fica verde enquanto o bug passa batido. É o tipo de defeito que green tests não pegam e que só aparece na frente do usuário.

A ~$5.10 por run em 16 minutos, o Grok 4.5 é o segundo run mais caro da Tier A. Guarda esse número, porque na seção de preço ele fica numa posição incômoda.

## GPT 5.6 Sol: a nova geração da OpenAI, rodando na assinatura

O **GPT 5.6 Sol** (o nome faz parte da nova nomenclatura Sol/Terra/Luna da OpenAI, com lançamento público atrasado por uma revisão do governo americano) marcou **92/100, Tier A**. E ele trouxe duas primeiras vezes pro benchmark.

A primeira: foi o **primeiro run cobrado numa assinatura**. Rodei via Codex CLI, no plano ChatGPT, com os créditos da assinatura em vez de pagar API direto. Pelo log de tokens dá pra calcular o equivalente em API: cerca de **$8.70** na tarifa verificada do Sol ($5/$30 por milhão). A segunda: foi o GPT mais econômico em token que eu já medi, 3.9M de tokens totais contra 4.9M do 5.5 e 7.6M do 5.4. Menos token pra fazer a mesma coisa.

A engenharia é exemplar. Preflight de chave faltando, rescues em camada que nunca vazam detalhe de erro (e isso está *testado*), turnos que falharam ficam fora do histórico, recuperação de histórico malformado, e um helper de XSS com escape antes do format e **teste de regressão de `<script>`**. 28 testes, 99.2% de cobertura. E crucialmente, ele acerta o que o Grok 4.5 errou: o responder é chamado *antes* da mensagem do usuário entrar no histórico, e o próprio teste garante a separação que pegaria um double-send. Ainda por cima, ele fixa o `anthropic/claude-sonnet-5`, o pin de Sonnet mais atual de todo o benchmark.

Por que 92 e não mais? Duas deduções honestas. Ele não manda system prompt via `with_instructions` em lugar nenhum (o assistente sobe sem persona nem guardrail, a mesma lacuna do Kimi K2.7), e a persistência é histórico carregado no cliente via campo oculto: rigorosamente capado, mas se perde no reload e é adulterável. No A/B cego contra o antecessor GPT 5.5, foi decisivo: **92 a 81**. E foi esse confronto que abriu a caixa de marimbondo da reauditoria.

## A reauditoria: o GPT 5.5 caiu de 96 pra 85

Essa é a parte que dói. Quando o juiz cego comparou o Sol com o GPT 5.5, ele apontou defeitos no projeto do 5.5 que a auditoria original tinha deixado passar. Fui verificar na mão e era verdade: o Dockerfile do 5.5 é uma imagem de desenvolvimento (`RAILS_ENV=development`, rodando como root, `CMD ./bin/dev`), ele tem **zero cobertura de teste no caminho de erro**, e o cookie não tem teto de bytes. Reauditado, o GPT 5.5 caiu de 96 pra **85/100, despencando pro #12**. O GPT 5.4 também levou um ajuste, de 97 pra 95, mas segura melhor porque os caminhos de erro dele *estão* testados.

A consequência de tabela é que o **Claude Opus 4.7 agora é o líder isolado do benchmark**, com 97. E a lição metodológica ficou registrada: minhas auditorias pré-Sol subestimavam a inspeção de Dockerfile. É por isso que eu insisto em ler na mão e cruzar com juiz independente. Nota bonita em CI verde não é nota real.

## Como os dois se comparam ao Fable 5 e ao melhor open source

Botando lado a lado o que interessa: o **Fable 5** (o topo da linha Claude aberta ao público) fez 94, e o re-release dele fez 93. O **melhor open source** da tabela hoje é um empate em 87 entre **Kimi K2.6** e **GLM 5.2**, seguidos de perto pelo Kimi K2.7 Code em 86.

O GPT 5.6 Sol, com 92, fica **entre** o Fable 5 e o melhor open source, e mais perto do Fable. É genuinamente forte, a diferença de 2 pontos pro Fable é margem de ruído, e ele é mais econômico em token que qualquer GPT anterior. Já o Grok 4.5, com 87, **empata exatamente com o teto do open source**. E aqui a comparação fica cruel: o Grok 4.5 entrega a mesma nota do Kimi K2.6 custando cinco vezes mais (~$5.10 contra ~$1.00). No confronto A/B cego contra o Fable 5, o Grok perdeu de 84 a 90, decisivo. Ou seja, a família Grok finalmente chegou na Tier A, o que é um marco real, mas chegou na *base* da Tier A, no mesmo lugar que modelos chineses abertos ocupam por uma fração do preço.

O recado que se repete a cada rodada: chegar na Tier A é o que importa (abaixo dela o modelo não é mais barato, ele só transfere o custo da fatura de API pra sua agenda de engenheiro). Mas *dentro* da Tier A, preço e qualidade decidem, e é onde o Grok 4.5 tropeça.

## Preço: a conta mudou desde o último post

Essa rodada veio junto de uma auditoria de preço completa no repositório, e ela mexeu em números que eu vinha reportando errado. Vale corrigir publicamente.

O erro maior era eu **subcontar os tokens de cache-read**. Run agentic é dominado por leitura de cache (5 a 15 milhões de tokens de cache-read por run), e minhas estimativas antigas pra modelos da Anthropic e do Google ignoravam isso. Não foi o preço que subiu, foi a minha conta que estava furada. Os valores corrigidos pra cima:

| Modelo | Eu reportava | Custo real por run |
|---|---:|---:|
| Opus 4.7 | ~$1,10 | **~$7,00** |
| Opus 4.8 | ~$1,10 | **~$6,40** |
| Gemini 3.1 Pro | ~$0,40 | **~$3,10** |

Além disso, o endpoint gratuito do Nex-N2-Pro deixou de existir (o mesmo run hoje custa ~$0,34, ainda o Tier A mais barato), e as tarifas do Kimi K2.6 subiram uns 30% desde o run dele, pra ~$1,00.

Com os números certos, dá pra montar a **fronteira de valor** da Tier A: pra cada faixa de preço, qual é a maior nota que o dinheiro compra. Cada linha aqui é uma escolha racional, porque paga mais e entrega mais:

| Custo por run | Melhor modelo | Nota |
|---:|---|---:|
| ~$0,34 | Nex-N2-Pro | 83 |
| ~$1,00 | Kimi K2.6 | 87 |
| ~$3,55 | Gemini 3.5 Flash | 93 |
| ~$6,40 | Opus 4.8 | 95 |
| ~$7,00 | Opus 4.7 | 97 |

Qualquer modelo que fique **fora** dessa fronteira (cobra mais e entrega a mesma nota, ou menos) é escolha irracional. É o caso do **Grok 4.5** (~$5,10 pra fazer 87, quando o Kimi K2.6 faz os mesmos 87 por ~$1,00) e do **GPT 5.4** (~$16 pra fazer 95, quando o Opus 4.8 faz 95 por 40% do preço).

E entrou uma variável nova de vez: **assinatura**. O GPT 5.6 Sol rodou em créditos do plano ChatGPT. Na tarifa de API, ele é dominado pelo Opus 4.8 (95 por ~$6.40 contra 92 por ~$8.70). Mas num plano que você *já paga*, o custo marginal de mais um run é praticamente zero, e aí a lógica vira.

### O que faz sentido pra quem programa de verdade

Junta tudo e o quadro pra um programador profissional fica claro:

- **Se você usa assinatura** (Claude Max, ChatGPT Pro) e trabalha dentro dos limites do plano, o cálculo de preço por token **colapsa**. Um assinante do Max 20x não ganha nada escolhendo o Kimi K2.6 pra economizar $6 que ele não está gastando. A regra vira "use o melhor modelo que seu plano te dá", e ponto. A fronteira de preço só volta a valer pro que estoura o teto do plano ou pros modelos de fora dele.
- **Se você paga API por token** (o caso de qualquer automação, CI ou pipeline, que *não* pode rodar em plano de consumidor), a fronteira de valor manda. Nunca desça da Tier A pra economizar dólares de um dígito num trabalho que você pretende colocar em produção: economizar $6 pegando um Tier B custa de $60 a $100 em tempo de conserto, um retorno negativo de 10 a 15 vezes.
- **O piso continua sendo a Tier A.** Abaixo dela você ganha quebra silenciosa em runtime, não código só um pouco pior: API alucinada que o próprio teste mocka, multi-turn que nunca chega no modelo, stub que a produção fura. Passa no CI e explode na frente do usuário. Aquela sessão de debug custa mais que um mês inteiro de runs Tier A.

Na prática, pra mim: se estou num plano pago, uso o topo que o plano oferece (Opus, e agora o Sol quando eu quiser variar). Se é automação pagando token, o Opus 4.8 é o ponto doce de qualidade por preço no cluster dos 95, e o Gemini 3.5 Flash é a melhor opção de 90+ com orçamento apertado. O Grok 4.5 e o GPT 5.6 Sol são modelos bons, mas nenhum dos dois muda essa recomendação: um empata com open source cinco vezes mais barato, o outro só compensa dentro de uma assinatura já paga.

O benchmark é aberto, com a tabela completa, os custos verificados e a análise de preço detalhada: [github.com/akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). Quer ver outro modelo aí? Fork, adiciona no `config/models.json`, roda e manda o PR.
