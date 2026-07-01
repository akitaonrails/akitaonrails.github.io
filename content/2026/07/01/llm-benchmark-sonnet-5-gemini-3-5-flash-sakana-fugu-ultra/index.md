---
title: "LLM Benchmark: Sonnet 5 falha, Gemini Flash surpreende, Sakana Fugu quase chega ao Tier A"
slug: "llm-benchmark-sonnet-5-gemini-3-5-flash-sakana-fugu-ultra"
date: '2026-07-01T15:00:00-03:00'
draft: false
translationKey: llm-benchmark-sonnet-5-gemini-3-5-flash-sakana-fugu-ultra
tags:
  - llm
  - benchmark
  - claude
  - sonnet
  - gemini
  - qwen
  - sakana
  - ai
  - vibecoding
---

Mais uma rodada do meu benchmark de coding. Os três nomes da vez são **Sonnet 5**, **Gemini 3.5 Flash** e **Sakana Fugu Ultra**. O Sonnet 5 é o nome que chama atenção, mas a história da rodada não favorece a Anthropic. Ele entrou, rodou, passou no Docker, subiu no Compose, e mesmo assim terminou em **58/100, Tier C**. A primeira conversa real quebraria antes de chamar o modelo.

O susto bom veio de outro lado: **Gemini 3.5 Flash** fez **93/100, Tier A, #6**. Um Flash. Acima de Kimi K2.6, GLM 5.2 e Gemini 3.1 Pro.

E teve **Sakana Fugu Ultra**, que ficou no limite: **79/100, Tier B**, praticamente batendo na porta do Tier A. Qwen3.7 Max e Step 3.7 Flash também entraram, mas como elenco de apoio da rodada. O Nex é importante, só que eu já destrinchei o caso dele no post sobre a [controvérsia da Rio 3.5](/2026/06/15/controversia-llm-rio-3-5-plagio/), então aqui ele fica mais como linha de ranking e referência.

Desde o [último benchmark](/2026/06/14/llm-benchmark-kimi-v2-7-code-glm-5-2-minimax-m3-local/) não mudou minha recomendação prática: se é programação séria, sessão longa, mexendo em projeto real, continuo em **Opus 4.8** ou **GPT 5.5**, usando Claude Code, Codex ou OpenCode. Mas o ranking mexeu bastante no meio da tabela. E o meio da tabela é onde dá pra enxergar a direção da indústria.

## Pra quem caiu de paraquedas

Esse benchmark dá o mesmo prompt pra cada modelo e pede pra ele construir, sozinho, um app de chat estilo ChatGPT em Rails 8 + RubyLLM + Hotwire + Docker, com testes e CI. A nota vai de 0 a 100, em tiers A/B/C/D, lendo o código gerado na mão. Não é benchmark sintético de múltipla escolha. É um agente tentando entregar um projetinho Rails inteiro.

A série até agora:

1. [Benchmark canônico de Maio (Parte 3)](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/), com a metodologia completa.
2. [DeepSeek destravado com DeepClaude](/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/).
3. [Update Grok 4.3, MiniMax M3, Opus 4.8](/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/).
4. [Fable 5 e a novela da Anthropic](/2026/06/11/llm-benchmark-fable-5-e-a-novela-da-anthropic/).
5. [Kimi v2.7 code, GLM 5.2, MiniMax M3 local](/2026/06/14/llm-benchmark-kimi-v2-7-code-glm-5-2-minimax-m3-local/).

A armadilha continua a mesma: a coluna "RubyLLM OK" não é detalhe cosmético. Se o modelo inventa uma API que não existe, o app morre no recurso principal. Às vezes tudo em volta parece bonito: Tailwind, Turbo, Docker, README, testes verdes. Aí você clica em "Enviar" e toma `NoMethodError`.

## A novela dos modelos fechados

A Anthropic tinha colocado controles do governo americano em cima do **Claude Fable 5** e **Claude Mythos 5** em 12 de junho. A justificativa era a impossibilidade prática de verificar nacionalidade em tempo real em todos os canais globais. Em 30 de junho, esses controles foram suspensos para o Fable 5, e a Anthropic anunciou a volta gradual dele para Claude Platform, Claude.ai, Claude Code e Claude Cowork. Mythos 5 continua mais restrito, disponível para organizações americanas aprovadas, coordenado via Project Glasswing.

Fontes: [post da Anthropic sobre a volta do Fable 5](https://www.anthropic.com/news/redeploying-fable-5), [post original de Fable 5 e Mythos 5](https://www.anthropic.com/news/claude-fable-5-mythos-5), e [The Verge sobre a suspensão dos controles](https://www.theverge.com/ai-artificial-intelligence/958964/anthropic-claude-fable-5-is-back).

Do lado da OpenAI, o **GPT-5.6** também apareceu oficialmente, mas ainda em preview limitado. Tem página da OpenAI e artigo no help center, mas não é algo amplamente disponível pra eu colocar no benchmark como coloco GPT 5.5 hoje. Então fica registrado, mas sem número ainda: [preview do GPT-5.6 Sol](https://openai.com/index/previewing-gpt-5-6-sol/) e [help center do GPT-5.6 Sol, Terra e Luna](https://help.openai.com/en/articles/20001325-a-preview-of-gpt-56-sol-terra-and-luna).

## Ranking atualizado

Os modelos novos desta rodada estão em negrito. Nex-N2-Pro e Qwen 3.5 397B base continuam destacados porque entraram na tabela depois do último benchmark, mas a análise longa deles já apareceu no post da [Rio 3.5](/2026/06/15/controversia-llm-rio-3-5-plagio/).

| Rank | Modelo | Score | Tier | RubyLLM OK | Tempo | Custo |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | 97 | A | ✅ | 22m | ~$16 |
| 3 | GPT 5.5 xHigh (Codex) | 96 | A | ✅ | 18m | ~$10 |
| 4 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$1.10 |
| 5 | Claude Fable 5 | 94 | A | ✅ | 24m | ~$11 (est.) |
| **6** | **Gemini 3.5 Flash** | **93** | **A** | ✅ | **18m** | **~$3.50** |
| 7 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$0.30 |
| 7 | GLM 5.2 (Z.ai) | 87 | A | ✅ | 43m | subscription |
| 9 | Kimi K2.7 Code | 86 | A | ✅ | 22m | ~$0.30 |
| 10 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 |
| **10** | **Nex-N2-Pro** | **83** | **A** | ✅ | **25m** | **free** |
| 12 | Gemini 3.1 Pro | 79 | B | ✅ | 14m | ~$0.40 |
| **12** | **Sakana Fugu Ultra** | **79** | **B** | ✅ | **22m** | **subscription** |
| 14 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 |
| 14 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 14 | MiniMax M3 | 78 | B | ✅ | 53m (fase 2 DNF) | ~$0.10 |
| **14** | **Qwen3.7 Max** | **78** | **B** | ✅ | **19m** | **~$1.40** |
| 18 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.74 |
| 19 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 |
| 20 | DeepSeek V4 Pro | 69 | B | ✅ | 22m (DNF) | ~$0.50 |
| 20 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0.10 |
| **20** | **Step 3.7 Flash** | **69** | **B** | ✅ | **27m** | **~$0.30** |
| 23 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.14 |
| 24 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 |
| **25** | **Claude Sonnet 5** | **58** | **C** | ❌ | **27m** | **~$0.80** |
| 26 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 |
| 27 | Qwen 3.5 35B (local) | 55 | C | ✅ | 28m | grátis |
| 28 | GLM 4.7 Flash bf16 (local) | 52 | C | ✅ | falhou | grátis |
| 29 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 30 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 |
| **31** | **Qwen 3.5 397B A17B (base)** | **42** | **C** | ❌ | **15m** | **~$0.58** |
| 32 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 |
| 33 | Qwen 3.5 122B (local) | 37 | D | ❌ | 43m | grátis |
| 34 | Qwen 3 Coder Next (local) | 32 | D | ❌ | 17m | grátis |
| 35 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.60 |
| 36 | GPT OSS 20B (local) | 11 | D | ❌ | falhou | grátis |

## Sonnet 5: passou no Docker, falhou no coração

O Sonnet 5 fez **58/100, Tier C, #25**. Parece estranho quando você lê que a fase 2 passou: boot local, Docker build e Docker Compose. O projeto tinha Rails 8, Turbo, Stimulus, Tailwind, README, CI, SimpleCov, Brakeman, RuboCop, bundler-audit. Em volta, tudo parecia no lugar.

O problema estava exatamente onde não podia estar: no caminho do LLM.

O serviço gerado faz isso:

```ruby
RubyLLM.chat(model: MODEL, provider: PROVIDER).tap do |chat|
  chat.messages = history
end
```

Só que o RubyLLM 1.16 tem `messages`, `add_message`, `ask` e `with_instructions`. Ele não tem `messages=`. A primeira conversa real levanta `NoMethodError` antes de chegar no modelo. O teste não pega porque o `FakeChat` do próprio projeto define `attr_accessor :messages`, justamente o writer que não existe em produção.

Esse é o tipo de bug que me faz continuar lendo benchmark na mão. Build verde não garante integração correta. Teste verde pode ser pior que inútil quando o fake ensina uma mentira pro teste.

Tem mais: o app gerado ainda defaultava para `anthropic/claude-sonnet-4.6`, não Sonnet 5, e deixava o system prompt sem `with_instructions`. A casca estava completa. O recurso principal estava quebrado.

Resumo cruel: **Sonnet 5 passou no Docker e falhou no coração**. Se você paga Anthropic pra programar hoje, meu conselho continua sendo Opus 4.8, não Sonnet 5.

## Gemini 3.5 Flash: o susto bom

O Gemini 3.5 Flash foi o maior susto positivo da rodada: **93/100, Tier A, #6**. Melhor resultado não-Anthropic/não-OpenAI do benchmark até agora, 14 pontos acima do Gemini 3.1 Pro.

A integração RubyLLM foi exemplar:

```ruby
chat = RubyLLM.chat(model: @model, provider: :openrouter, assume_model_exists: true)
chat.with_instructions(SYSTEM_INSTRUCTION)
@conversation.messages.each { |msg| chat.add_message(role: msg.role.to_sym, content: msg.content) }
response = chat.complete
@conversation.add_message(role: :assistant, content: response.content)
```

Ele usou `with_instructions`, replay de histórico com `add_message`, `complete` e `response.content`. Tudo real. A suíte de testes foi a melhor desse grupo: `FakeChat` com assinatura compatível, stub no ponto certo (`RubyLLM.chat`), assert de parâmetros, replay de histórico e teste de erro.

Também gostei da persistência. Ele grava em arquivo, em `tmp/chats/<id>.json`, com cap de 50 mensagens e preservando a mensagem de sistema. Sobrevive restart no mesmo host e é melhor que singleton em memória. Não é perfeito: falta lock de arquivo, `tmp/` é efêmero em container, e uma conversa concorrente pode gerar race. Também não tem preflight bonito de API key. Mas isso é detalhe corrigível perto do que ele acertou.

O custo incomoda. Mesmo sendo Flash, o run saiu por volta de **US$3,50**, mais caro que Opus 4.8 nesse benchmark, por churn alto de token. Então não dá pra vender como "baratinho". Mas como sinal de qualidade, é forte. Um Flash entrando em #6 muda minha intuição sobre a família Gemini.

## Sakana Fugu Ultra: quase Tier A, faltou memória

O **Sakana Fugu Ultra** entrou com **79/100, Tier B, #12 empatado**. Pra um provedor novo, foi uma estreia limpa. O harness funcionou, o app subiu, Docker/Compose passaram, RubyLLM era real (`chat`, `with_instructions`, `ask`, `response.content`), os testes usavam `FakeChat` correto, Turbo/Stimulus estavam bons.

O problema: o modelo só enxerga a última mensagem. O histórico é salvo e exibido, só não é replayado para o RubyLLM. Então a UI parece chat multi-turn. O LLM trabalha como se cada mensagem fosse a primeira. É quase Tier A, faltando justamente a parte que faz um chat ser chat.

Esse é o tipo de resultado que eu gosto de ver, mesmo quando não passa de Tier. Não é um desastre. Não é API inventada. É um app quase correto com uma falha específica, pequena de explicar e relativamente pequena de consertar. Trocar o repositório process-local por algo decente e replayar histórico com `add_message` já mudaria bastante a avaliação.

## Qwen3.7, Step 3.7 e o rodapé do Qwen 3.6

O **Qwen3.7 Max** fez **78/100, Tier B, #14 empatado**. A API RubyLLM estava correta, inclusive streaming e `reset_messages!`, e a fase 2 passou. Só que ele ignorou Turbo Streams e implementou SSE cru com `ActionController::Live`. Isso pode ser legítimo num app real; o prompt pedia Hotwire/Turbo Streams. Também usou `anthropic/claude-sonnet-4` em vez do Sonnet mais novo e guardou conversas num hash class-level sem limite. Processo reinicia, perde tudo. Processo longo, vaza memória.

O **Step 3.7 Flash** fez **69/100, Tier B, #20 empatado**. Ele corrigiu o erro grande do Step 3.5: agora usa `ruby_llm` de verdade, não bypass com `ruby-openai`. A parte ruim lembra Sakana. Ele cria um `RubyLLM.chat` novo por request e manda só a mensagem atual. O histórico fica num `@@all` class var, só nunca chega ao modelo. Saiu do bypass errado e esqueceu de dar memória ao LLM.

E sim, teve Qwen 3.6 no histórico recente de commits. Dois runs locais do **Qwen 3.6 35B A3B** entraram via PR #9 (`cccc118` e `f06ddd0`), com perfil `ik_llama.cpp` local, mas o merge foi revertido em `d5f9195`. Por isso eles não entram na tabela principal desta rodada.

O dado útil de Qwen 3.6 local continua no relatório separado da RTX 5090: ele foi o primeiro modelo local daquele perfil a acertar o entry point `RubyLLM.chat` + `chat.ask`, mas ainda retornava o objeto inteiro em vez de `response.content` e não fazia multi-turn. Eu já tinha comentado essa linha nos posts anteriores de benchmark: perto de funcionar, mas ainda não pronto pra ranking principal junto com os runs cloud/AMD.

## Nex e Qwen base: já cobri no caso Rio 3.5

O **Nex-N2-Pro** fez **83/100, Tier A, #10**, usando o endpoint grátis do OpenRouter. A base crua **Qwen 3.5 397B A17B** fez **42/100, Tier C, #31**. Essa diferença de 41 pontos é importante, mas repetir tudo aqui seria encher linguiça.

Eu já usei esses números no post sobre a [controvérsia da LLM Rio 3.5](/2026/06/15/controversia-llm-rio-3-5-plagio/), porque a acusação pública era justamente que o checkpoint da Rio parecia uma mescla de Nex-N2-Pro com Qwen3.5-397B-A17B. Lá está a explicação do que é Nex, por que a fine-tune importa, e por que uma Rio que herdasse ganho da Nex não deveria ser vendida como avanço óbvio sobre Nex puro sem benchmark reproduzível.

O resumo técnico é simples: a base Qwen inventou RubyLLM (`chat.system`, `chat.user`, `response.text`) e os testes mockavam essa API falsa. O Nex usou a API real, subiu localmente, passou Docker/Compose e entregou Turbo Streams com tratamento de erro. Ainda tem atalhos, como achatar histórico em texto em vez de usar `add_message` e `with_instructions`, mas é um Tier A legítimo. Só não é o foco deste post.

## Meu uso real hoje

Na prática, eu tenho usado muito **OpenCode + [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) + GPT 5.5** pra manter meus projetos open source. É um fork slim, limpo e mais econômico do oh-my-opencode, justamente o tipo de ajuste que combina com uso diário. O resto do meu [toolkit de IA com ai-jail, ai-memory e ai-usagebar](/2026/05/24/dicas-e-toolkit-de-ia-do-akita-ai-jail-ai-memory-ai-usagebar/) eu já expliquei em post separado.

É um fluxo chato de explicar pra quem só quer saber "qual modelo é melhor", porque o modelo sozinho não carrega o trabalho. O harness importa. O prompt de sistema importa. A memória do projeto importa. A qualidade dos testes importa. O mesmo modelo, num harness ruim, vira um gerador de patch aleatório.

Tenho usado isso em coisas pequenas e reais, tipo extensões do Geary: [geary-email-autocomplete](https://github.com/akitaonrails/geary-email-autocomplete) e [geary-hide-sidebar-module](https://github.com/akitaonrails/geary-hide-sidebar-module). Nada disso é revolução. É manutenção, bugfix, refactor, teste, documentação. Exatamente o tipo de trabalho onde agente de código precisa ser confiável por horas, não por uma demo de 90 segundos.

Por isso eu continuo repetindo: benchmark de modelo é útil, benchmark de fluxo é mais útil ainda. Sonnet 5 com API alucinada não me ajuda. Gemini Flash surpreendendo com RubyLLM correto me interessa. Sakana e Step acertando a gem mas esquecendo multi-turn mostram exatamente onde esses modelos ainda quebram em produto real.

## Conclusão

A rodada deixou um recado simples: nome forte não salva integração quebrada. Sonnet 5 entrou com aura de modelo novo e saiu em Tier C porque chamou uma API que não existe.

Gemini 3.5 Flash merece atenção. Não por ser barato, porque neste run nem foi tão barato assim. Ele merece atenção por ter entregue um app Rails/RubyLLM muito mais correto do que eu esperava de um Flash.

No lado open source/provedor alternativo, a história é mais mista. Sakana Fugu Ultra quase chegou em Tier A, Qwen3.7 Max acertou a API mas errou o produto, e Step 3.7 Flash corrigiu o bypass do 3.5 mas esqueceu de dar memória ao chat. O avanço existe, só ainda vem cheio de arestas.

Minha recomendação prática continua igual: **Opus 4.8 ou GPT 5.5** pra programação séria hoje. Use modelos Tier B pra tarefa pequena, barata, revisada. Use open source/local pra estudar e experimentar. E não confie em teste verde se o fake não imita a biblioteca real.

O benchmark é aberto: [github.com/akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). Quer ver outro modelo aí? Fork, adiciona no `config/models.json`, roda e manda o PR.
