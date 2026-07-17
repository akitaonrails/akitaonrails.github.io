---
title: "LLM Benchmark: Kimi K3 chegou no nível do Claude Opus?"
slug: "llm-benchmarks-kimi-k3"
date: '2026-07-17T12:00:00-03:00'
draft: false
translationKey: llm-benchmarks-kimi-k3
tags:
  - llm
  - benchmark
  - kimi
  - moonshot
  - claude
  - glm
  - pricing
  - ai
  - vibecoding
---

Eu estou sempre testando LLM nova. É a única forma de separar release note de código que sobe. Nos dois posts mais recentes, [Grok 4.5 e GPT 5.6 Sol](/2026/07/09/llm-benchmark-grok-4-5-gpt-5-6-sol/) e [Sonnet 5, Gemini 3.5 Flash e Sakana](/2026/07/01/llm-benchmark-sonnet-5-gemini-3-5-flash-sakana-fugu-ultra/), a tabela mexeu bastante. Agora é a vez da Moonshot.

O foco é o **Kimi K3**, alternativa que está ficando cada vez mais parecida com Claude no tipo de trabalho que consegue terminar. E um detalhe bobo, mas importante para procurar documentação: o nome oficial é **Kimi K3**, não “Kimi v3”.

## Pra quem caiu de paraquedas

O benchmark dá o mesmo prompt a todos os modelos: construir sozinho um chat estilo ChatGPT em Rails 8, RubyLLM, Hotwire, Docker, testes e CI. Depois eu verifico o projeto produzido, inclusive API real da gem, memória de conversa, tratamento de erro, testes e imagem de produção. A nota vai de 0 a 100, em tiers A/B/C/D.

Não é benchmark de preencher função. É um agente entregando um app pequeno, com as partes chatas que costumam quebrar depois da demo. A metodologia está na [Parte 3](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/); código, logs e rubric estão no [repositório do benchmark](https://github.com/akitaonrails/llm-coding-benchmark).

## Primeiro, o problema do harness

As rodadas anteriores de Kimi usaram OpenCode por OpenRouter. K3 não passou da porta: o validador estrito de schema de tools da Moonshot recusou o schema que o OpenCode manda:

```
when using anyOf, type should be defined in anyOf items instead of the parent schema
```

Um probe controlado, com schema limpo, fez tool calling funcionar. O problema está no par **OpenCode ↔ Moonshot**. K2.5, K2.6 e K2.7 funcionavam com o mesmo ferramental. Cuidado com manchete de “modelo não suporta tools”: às vezes o bug está no encaixe.

Para não abandonar o teste, entrou um runner de primeira classe para Kimi Code CLI. A fase 1 chama:

```bash
kimi -p <prompt> --output-format stream-json -m <model>
```

e a fase 2 retoma a sessão com `-S <session_id>`. O código do runner e a configuração estão no [commit 0cdf88a](https://github.com/akitaonrails/llm-coding-benchmark/commit/0cdf88a). O erro original e a investigação ficaram registrados nos commits [c3ab6d5](https://github.com/akitaonrails/llm-coding-benchmark/commit/c3ab6d5) e [506357b](https://github.com/akitaonrails/llm-coding-benchmark/commit/506357b); o projeto final do K3 entrou em [2bf1d7b](https://github.com/akitaonrails/llm-coding-benchmark/commit/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615).

Isso também põe um asterisco honesto na nota. Eu queria comparar toda a família com o novo harness. A assinatura Kimi expõe K3 e o gerenciado **K2.7-Coding**, mas não K2.5/K2.6. Re-rodamos K2.7 pelo CLI e comparamos com os artefatos existentes K2.5/K2.6/OpenRouter. O K2.7 CLI ficou em aproximadamente **68/B** informal; o K2.7 OpenCode/OpenRouter tinha feito **86/A**. É sensibilidade de harness e snapshot, não uma alegação causal limpa de “o harness custa 18 pontos”: `kimi-for-coding` gerenciado pode não ser o mesmo snapshot público de K2.7.

## Ranking atual: 40 modelos

K2.7 CLI é informal, sem rank, então não entra. A coluna de custo é custo efetivo no provedor/OpenRouter da rodada ou estimativa de assinatura, não uma tabela tarifária abstrata.

| Rank | Modelo | Score | Tier | RubyLLM OK | Tempo | Custo |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$7.00 |
| 2 | GPT 5.4 xHigh (Codex) | 95 | A | ✅ | 22m | ~$16 |
| 2 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$6.40 |
| 4 | Claude Fable 5 | 94 | A | ✅ | 24m | ~$11.20 |
| 5 | Claude Fable 5 (re-release) | 93 | A | ✅ | 18m | ~$8.30 |
| 5 | Gemini 3.5 Flash | 93 | A | ✅ | 18m | ~$3.55 |
| 7 | GPT 5.6 Sol xHigh (Codex) | 92 | A | ✅ | 17m | créditos (≈$8.70 equiv. API) |
| **8** | **Kimi K3 (Kimi Code CLI)** | **89** | **A** | ✅ | **26m** | **créditos (≈$2.10 equiv. API)** |
| **9** | **Kimi K2.6** | **87** | **A** | ✅ | **20m** | **~$1.19** |
| 9 | GLM 5.2 (Z.ai) | 87 | A | ✅ | 43m | subscription |
| 9 | Grok 4.5 | 87 | A | ✅ | 16m | ~$5.10 |
| **12** | **Kimi K2.7 Code** | **86** | **A** | ✅ | **22m** | **~$1.23** |
| 13 | GPT 5.5 xHigh (Codex) | 85 | A | ✅ | 18m | ~$10 |
| 14 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 (hist.) |
| 14 | Nex-N2-Pro | 83 | A | ✅ | 25m | ~$0.34 (was free) |
| 16 | Gemini 3.1 Pro | 79 | B | ✅ | 14m | ~$3.10 |
| 16 | Sakana Fugu Ultra | 79 | B | ✅ | 22m | subscription |
| 18 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 (hist.) |
| 18 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 18 | MiniMax M3 | 78 | B | ✅ | 53m (fase 2 DNF) | ~$1.25 |
| 18 | Qwen3.7 Max | 78 | B | ✅ | 19m | ~$1.40 |
| 22 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.70 |
| 23 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 (hist.) |
| 24 | DeepSeek V4 Pro | 69 | B | ✅ | 22m (DNF) | ~$0.05 |
| **24** | **Kimi K2.5** | **69** | **B** | ✅ | **29m** | **~$0.10 (hist.)** |
| 24 | Step 3.7 Flash | 69 | B | ✅ | 27m | ~$0.80 |
| 27 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.09 |
| 28 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 (hist.) |
| 29 | Claude Sonnet 5 | 58 | C | ❌ | 27m | ~$2.25 |
| 30 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 (hist.) |
| 31 | Qwen 3.5 35B | 55 | C | ✅ | 28m | free |
| 32 | GLM 4.7 Flash bf16 | 52 | C | ✅ | falhou | free |
| 33 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 34 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 (hist.) |
| 35 | Qwen 3.5 397B A17B (base) | 42 | C | ❌ | 15m | ~$0.31 |
| 36 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 (hist.) |
| 37 | Qwen 3.5 122B | 37 | D | ❌ | 43m | free |
| 38 | Qwen 3 Coder Next | 32 | D | ❌ | 17m | free |
| 39 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.70 |
| 40 | GPT OSS 20B | 11 | D | ❌ | falhou | free |

## Kimi evoluiu rápido. O preço mais ainda.

K2.5 fez **69/B** em fevereiro. K2.6 saltou para **87/A** em abril. K2.7 ficou em **86/A** em junho. Agora K3 chega a **89/A** em julho. Houve um salto grande no K2.6, um platô em K2.7 e K3 empurra o teto mais um pouco.

Da ficha oficial, só o que importa aqui: K3 tem contexto de 1M, arquitetura MoE (mixture of experts, ativa só partes do modelo a cada token) e modo de raciocínio máximo. Útil para entender a ambição do produto. Não substitui abrir o projeto que ele escreveu.

## O que o K3 escreveu de verdade

Há bastante coisa certa no [modelo `Conversation`](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/kimi_k3_cli/project/app/models/conversation.rb#L31-L52). Ele monta o chat, reenvia só o histórico anterior e então faz `ask(content)`; a mensagem atual só entra na coleção depois da resposta. Sem double-send. Se o provider falha, a exceção sobe antes dos `append`, então turno falho não fica gravado:

```ruby
response = build_llm_chat.ask(content)
append(Message.new(role: "user", content: content))
append(Message.new(role: "assistant", content: response.content.to_s))
```

Também acertou uma persistência melhor do que o padrão de hash global: [Rails.cache com TTL de um dia](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/kimi_k3_cli/project/app/controllers/concerns/conversation_store.rb#L12-L18), chave por sessão e limite de [20 mensagens](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/kimi_k3_cli/project/app/models/conversation.rb#L6-L8). O Docker é produção, não root, e a validação fez chat real tanto localmente quanto no container. Isso é Tier A de verdade, não um README otimista.

Mas ainda dá para ver a assinatura de uma geração. Não usa `with_instructions`, então não há system prompt. A chamada de LLM mora dentro do model de domínio. Falta preflight para chave ausente.

Cada mensagem individual pode crescer sem teto e não há rate limit. O cache de produção continua o default efêmero. A sequência `read` + alteração + `write` tem race entre requisições. Erro cru do provider aparece na UI. A suíte de erro é menor do que deveria.

Contra o **Opus 4.6**, K3 vence com clareza neste artefato: API pública do RubyLLM correta, estado limitado e testes para falhas do provider. O [Opus 4.6 mexe direto em `chat.messages`](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/claude_opus_4_6/project/app/controllers/chats_controller.rb#L41-L56), guarda cookie sem cap e não cobre erro do provider.

O [Opus 4.8 modela melhor as precondições, system prompt e replay](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/claude_opus_4_8/project/app/services/chat_service.rb#L21-L51). A chamada básica de RubyLLM é comparável. A distância aparece no hardening, na arquitetura e na profundidade de testes.

| Artefato | Score | O que entregou | Onde ficou devendo |
|---|---:|---|---|
| Kimi K3 | 89 | Replay correto, cap, cache com TTL, erro testado | Sem system prompt, cache efêmero, race e erro cru |
| Claude Opus 4.6 | 83 | RubyLLM funcional, Docker de produção | Replay frágil, cookie sem cap, quase nenhum teste de erro |
| Claude Opus 4.8 | 95 | Serviço disciplinado, invariantes e 34 testes | Cookie ainda sem cap, falta preflight de chave |
| Claude Fable 5 | 94/93 | Preflight, limites de input, testes defensivos | Persistência com trade-offs e preço alto |

O **Fable 5** é mais defensivo, mas cobra por isso: original/re-release 94/93, contra 89; $10/$50 por milhão, contra $3/$15; runs medidos de ~$11.20/~$8.30, contra ~$2.10 equivalente de API. Um run por célula não dá certeza estatística. Dá código concreto para comparar.

## Preço: Kimi deixou de ser a pechincha absurda

Aqui é importante separar API direta Moonshot, OpenRouter e assinatura. Esta é a tarifa oficial da API direta, por milhão de tokens, com input cacheado separado:

| Modelo | Input cacheado | Input | Output |
|---|---:|---:|---:|
| K2.5 | $0.10 | $0.60 | $3 |
| K2.6 | $0.16 | $0.95 | $4 |
| K2.7 | $0.19 | $0.95 | $4 |
| K3 | $0.30 | $3 | $15 |

Documentação oficial: [K2.5](https://platform.kimi.ai/docs/pricing/chat-k25), [K2.6](https://platform.kimi.ai/docs/pricing/chat-k26), [K2.7 Code](https://platform.kimi.ai/docs/pricing/chat-k27-code) e [K3](https://platform.kimi.ai/docs/pricing/chat-k3). Para o preço e disponibilidade via intermediário, veja também a [página do K3 no OpenRouter](https://openrouter.ai/moonshotai/kimi-k3).

K3 custa **3,16× mais no input** e **3,75× mais no output** que K2.6/2.7. Moonshot saiu do nicho ultra-barato. Os custos da tabela de ranking são outra coisa: K2.6 ~$1.19 e K2.7 ~$1.23 foram recalculados com o provedor/OpenRouter e tokens do run; K3 é estimativa equivalente de API de ~$2.10 para uma rodada cobrada na assinatura. Misturar os dois sem identificar o canal cria comparação falsa.

Mesmo assim, K3 custa 40% menos que Opus 4.8 nas tarifas oficiais ($5/$25) e 70% menos que Fable ($10/$50). No plano **Kimi Moderato de $19**, isso é excelente para coding interativo solo. Só não automatize alegremente: observamos cerca de duas rodadas pesadas por janela de cinco horas e recuperação de quota em 4h16. Para batch sem supervisão, um 403 no meio joga fora trabalho e tempo.

### Moderato é pequeno demais para trabalho sério

Essa é a parte que o preço mensal esconde. Eu usei o Moderato de $19/mês. A quota é organizada em janelas móveis de cinco horas: use muito agora, espere a janela deslizar para recuperar capacidade. Uma rodada do benchmark não é um prompt solto. São exatamente dois prompts/fases: construir o app e depois retomar a mesma sessão para validar e corrigir.

O K3 completou essa rodada inteira em 26 minutos e 4,83 milhões de tokens, quase todos cache-read, cerca de $2.10 equivalentes de API. O K2.7 Coding completou os mesmos dois prompts em 16 minutos e 9,25 milhões de tokens. No histórico do benchmark, couberam aproximadamente duas rodadas completas dessa escala antes de uma terceira receber hard 403 no meio. A construção parcial foi perdida. A recuperação levou 4h16, com sete probes bloqueados em intervalos de 20 minutos.

Transparência necessária: o transcript bruto de 403/probes não foi commitado. Essa cronologia é uma observação registrada do benchmark, não algo que outra pessoa consiga auditar independentemente pelos logs crus. A documentação diz que tarefas já em execução normalmente terminam; a nossa terceira não terminou. É uma discrepância empírica que vi no uso, não uma acusação de que a documentação esteja mentindo.

Os planos oficiais estão na [página de membership](https://www.kimi.com/help/membership/membership-pricing):

| Plano | Mensal / equivalente anual | Créditos | Tarefas concorrentes | Veredito |
|---|---:|---:|---:|---|
| Adagio | grátis | — | — | Para experimentar, não para sessão pesada |
| Moderato | $19 / $15 ($180/ano) | 1x | 2 | Uma ou, no máximo, umas duas sessões pesadas por janela; pequeno demais para rotina séria |
| Allegretto | $39 / $31 | 5x | 2 | Mínimo sensato para uso interativo diário mais leve |
| Allegro | $99 / $79 | 15x | 4 | Primeiro plano que recomendo para uso profissional sustentado, ao menos 5h/dia |
| Vivace | $199 / $159 | 30x | 4 | Agentes paralelos ou uso pesado quase contínuo; provavelmente excesso para uma pessoa |

K3 no Moderato fica limitado a 256K de contexto. Allegretto para cima libera até 1M. Allegretto+ também libera HighSpeed, mas esse modo queima aproximadamente 3x a quota. Os 5x/15x/30x são créditos relativos, não promessa de que você terá 5/15/30 vezes mais runs lineares. A documentação divulga refresh semanal, janela móvel de cinco horas e quota compartilhada entre CLI, VS Code e ferramentas com API key, mas não publica a fórmula exata para sessão pesada ou token. Cache, output e o comportamento do agente mudam muito a conta.

Moderato serve para uma, talvez duas sessões pesadas em cinco horas. Para cinco horas de coding por dia, é pequeno demais: numa sequência de runs deste benchmark minúsculo, com só dois prompts por modelo, a terceira tentativa já bateu cooldown. Cooldown é justamente a espera pela janela de quota voltar a abrir. Allegretto é o upgrade mínimo para interação diária leve e ganha 1M de contexto, mas 5x pode deixar pouca folga para quem dirige o agente continuamente ou liga HighSpeed. Para uso profissional sustentado, no mínimo cinco horas por dia, eu iria de **Allegro**: 15x créditos e quatro tarefas concorrentes. Ainda assim, não há garantia oficial de execução ininterrupta. Vivace é para vários agentes ou carga quase contínua; para um desenvolvedor, em geral é exagero.

A outra decisão é assinatura ou API direta. A API do K3 cobra $0.30/M de input cacheado, $3/M de input sem cache e $15/M de output. Ela dá contabilidade explícita, contexto completo de 1M e não tem a quota semanal da membership, embora limites normais de API continuem existindo. É o caminho melhor para CI, batch e runs longos que valem dinheiro.

A assinatura compra outra coisa: custo mensal fixo, OAuth/CLI conveniente, custo marginal quase zero dentro dos caps e fatura previsível. Em troca, você aceita envelope de tokens oculto, caps móveis/semanais, franquia compartilhada, risco de parar no meio e nenhuma SLA para automação desacompanhada. Os ~$2.10 do K3 são só equivalente grosseiro de API. Nesse formato de run, a mensalidade do Moderato equivale aritmeticamente a cerca de 9 runs, Allegretto a 19, Allegro a 47 e Vivace a 95 por mês. Isto é conta de fatura, não garantia de quota: workloads reais variam brutalmente com cache e output.

Existe [Extra Usage](https://www.kimi.com/code/docs/en/kimi-code/membership.html): ele pode cair em saldo pago, respeitando um spending cap. Útil para evitar que a quota acabe abruptamente. A tarifa exata em USD não é publicada, e isso não transforma membership de consumidor em SLA de automação.

Minha recomendação sem enfeite: para 5h/dia, Allegro. Para interação mais leve, Allegretto. Para automação e CI, API pay-as-you-go. Se ficar na assinatura e o trabalho não puder parar, ative Extra Usage com teto de gasto.

Separando plano de modelo: K2.6 ainda é a melhor opção de API crua para automação de alto volume com revisão humana. K3 é uma opção muito boa para quem programa interativamente. Opus 4.8 continua minha escolha para refactor complexo, concorrência, segurança e mudança autônoma em que correção importa mais que a fatura. Fable, nesse recorte, é economicamente dominado.

## Bônus: GLM 5.2 contra Opus

GLM 5.2 está em **#9, 87/A, 43 minutos**, via assinatura Z.ai. O confronto natural é Opus 4.6, o vizinho de score em 83/A e 16 minutos, e Opus 4.8, o teto de qualidade em 95/A e 17 minutos.

Fui ler os dois projetos. O GLM supera o artefato do Opus 4.6: usa RubyLLM corretamente, aplica system prompt, separa serviço, aceita DI e testa falhas. O [serviço](https://github.com/akitaonrails/llm-coding-benchmark/blob/2bf1d7b3e3bbc7e6ff9a18a07390333c86bda615/results/glm_5_2/project/app/services/chat_service.rb#L28-L55) inclusive exclui a última mensagem do replay antes de chamar `ask`, o detalhe que evita double-send.

Só que GLM também deixa esqueletos no armário: singleton process-local sem cap; turno que falhou fica retido; `config.hosts.clear`; secret gerado que invalida sessões; e `npm ci || npm install`, que transforma lockfile em sugestão. Continua claramente atrás do Opus 4.8 em estado, desenho, testes e hardening de configuração.

Os planos Z.ai são Lite $18, Pro $72 e Max $160, com promoção até setembro de 2026: $12.60/$50.40/$112. Contra Opus 4.8 a ~$6.40 por run, o break-even nominal é aproximadamente **3/12/25** runs por mês, ou **2/8/18** no preço promocional. Mas GLM leva 43 minutos onde Opus 4.8 levou 17. Se você já paga Z.ai, GLM 5.2 é um default forte para trabalho rotineiro revisado. Se correção e turnaround mandam, Opus 4.8.

## Conclusão

Neste projeto Rails feito do zero, K3 substitui bem o Opus 4.6 e oferece uma alternativa mais barata ao Opus 4.8. O Claude ainda leva vantagem quando o projeto cobra defesa contra os detalhes que ninguém põe no prompt.

Há uma rodada por modelo e há efeito de harness, especialmente no K3. O benchmark também não cobre migrations de banco, jobs em background nem tool calls de produto. Não há dado aqui para fazer promessa sobre isso.

Meu mapa hoje: K2.6 para automação API de volume revisada; K3/Allegretto para trabalho solo interativo leve e Allegro para rotina sustentada; Opus 4.8 quando o patch é sensível; GLM 5.2 como bom default de assinatura para rotina revisada. Sem hype. Leia o código, rode os testes, e trate qualquer ranking como evidência limitada, não como religião.
