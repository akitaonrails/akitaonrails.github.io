---
title: "Benchmark de LLMs pra Coding (Abril 2026): DeepSeek v4, Kimi v2.6, MiMo, e o Estado da Arte"
date: '2026-04-24T13:00:00-03:00'
draft: false
translationKey: llm-coding-benchmark-canonical-2026-04
tags:
  - llm
  - benchmark
  - claude
  - ai
  - vibecoding
  - open-source
  - self-hosting
---

**TL;DR:** Essa é a versão canônica (e definitiva por enquanto) do meu benchmark de LLMs pra coding. Substitui os [artigos anteriores](https://github.com/akitaonrails/akitaonrails.github.io) de Abril que agora estão deprecados. Re-auditei os 22 modelos contra o código-fonte do gem `ruby_llm` em vez de memória, e vários que eu tinha tachado de "inventar API" na verdade escrevem código correto. Kimi K2.6 virou Tier A. Gemini 3.1 Pro também. GLM 5.1 caiu pra Tier C. MiMo V2.5 Pro caiu de "primeiro Tier 1 não-Anthropic" pra Tier B. Opus 4.7 e GPT 5.4 xHigh empatam no topo (94/100). Opus 4.6 continua sendo minha escolha diária por **comportamento**, não por código. Detalhes longos abaixo.

**Disclaimer importante**: todos os rankings, tiers e conclusões aqui só valem **dentro da metodologia específica desse benchmark**, que é construir um app Rails + RubyLLM + Hotwire + Docker a partir de um prompt fixo. Modelos que caem pra Tier B ou C aqui podem brilhar em outros tipos de tarefa (completamento de função isolada, geração de snippet curto, raciocínio sobre problema matemático). Ninguém deve ler isso como julgamento universal de capacidade.

---

## O que esse benchmark testa

Cada modelo recebe o mesmo prompt pra construir autonomamente um app de chat estilo ChatGPT em Rails. O prompt pede 15 coisas:

1. Rails com Ruby + Rails mais recentes via mise
2. Sem ActiveRecord, Action Mailer ou Active Job
3. SPA imitando interface do ChatGPT
4. Tailwind CSS
5. Hotwire + Stimulus + Turbo Streams
6. Partials do Rails (sem CSS/JS em arquivo único)
7. `OPENROUTER_API_KEY` via env var
8. Sem secrets em arquivo
9. RubyLLM (gem `ruby_llm`) configurado pra OpenRouter + Claude Sonnet
10. Testes Minitest pra cada componente
11. Brakeman, RuboCop, SimpleCov, bundle-audit pra CI
12. Dockerfile funcional (não placeholder)
13. docker-compose
14. README com setup
15. Tudo no root do workspace (sem subdir aninhado)

Modelos cloud rodam duas fases (build + validação de boot/Docker). Modelos locais rodam só a build. Harness é `opencode run --agent build --format json`, exceto GPT 5.4 que roda via `codex exec --json` direto.

## Metodologia: a rubrica de 8 dimensões

Essa parte mudou essa semana. A primeira versão desse benchmark pesava demais a correção da API do RubyLLM, então um modelo que escrevia chamada correta mas entregava projeto incompleto (sem docker-compose, README stock, bundle-audit faltando) passava por mais qualificado do que deveria. A rubrica nova distribui em 8 dimensões:

| Dimensão | Peso | O que mede |
|---|---:|---|
| Deliverable completeness | 25% | Dockerfile + compose + README + Gemfile + todos os artefatos do checklist |
| RubyLLM correctness | 20% | Chamadas verificadas contra fonte do gem 1.14.1 |
| Test quality | 15% | Testes exercitam o path do LLM com mocks de assinatura correta |
| Error handling | 10% | Rescue em volta das chamadas LLM, UI degradada pro usuário |
| Persistência / multi-turn | 10% | Session cookie / cache bom; singleton / class-var / nenhum ruim |
| Hotwire / Turbo / Stimulus | 10% | Turbo Streams reais, partials decompostos, controllers Stimulus |
| Arquitetura | 5% | Separação service/model, sem dump de lógica no controller |
| Production readiness | 5% | Multi-worker safe, sem XSS, sem `.env` commitado, CSRF intacto |

Score 0-100 → Tier A (80+) / B (60-79) / C (40-59) / D (<40).

- **Tier A**: sobe pra produção como está, ou com patch de menos de 30 minutos
- **Tier B**: 1 a 2 horas pra subir; arquitetura sólida, gaps menores
- **Tier C**: rework grande. Core bugs ou deliverables faltando
- **Tier D**: joga fora, só serve pra inspiração arquitetural

## Ranking final (22 modelos)

| Rank | Modelo | Score | Tier | RubyLLM OK | Tempo | Custo |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | **94** | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | **94** | A | ✅ | 22m | ~$16 |
| 3 | Kimi K2.6 | **84** | A | ✅ | 20m | ~$0.30 |
| 4 | Gemini 3.1 Pro | **82** | A | ✅ | 14m | ~$0.40 |
| 5 | Claude Opus 4.6 | 80 | A | ✅ | 16m | ~$1.10 |
| 6 | Claude Sonnet 4.6 | 75 | B | ✅ | 16m | ~$0.63 |
| 6 | DeepSeek V4 Flash | 75 | B | ✅ | 3m | ~$0.01 |
| 8 | Qwen 3.6 Plus | 68 | B | ✅ | 17m | ~$0.15 |
| 9 | DeepSeek V4 Pro | 66 | B | ✅ | 22m (DNF) | ~$0.50 |
| 9 | Kimi K2.5 | 66 | B | ✅ | 29m | ~$0.10 |
| 11 | Xiaomi MiMo V2.5 Pro | 64 | B | ✅ | 11m | ~$0.14 |
| 12 | GLM 5 | 61 | B | ✅ | 17m | ~$0.11 |
| 13 | Step 3.5 Flash | 53 | C | ⚠️ bypass | 38m | ~$0.02 |
| 14 | Qwen 3.5 35B (local) | 52 | C | ✅ | 28m | grátis |
| 15 | GLM 4.7 Flash bf16 (local) | 49 | C | ✅ | falhou | grátis |
| 16 | GLM 5.1 (Z.ai) | 43 | C | ❌ | 22m | subscription |
| 17 | DeepSeek V3.2 | 40 | C | ❌ | 60m | ~$0.07 |
| 18 | MiniMax M2.7 | 38 | D | ❌ | 14m | ~$0.30 |
| 19 | Qwen 3.5 122B (local) | 34 | D | ❌ | 43m | grátis |
| 20 | Qwen 3 Coder Next (local) | 29 | D | ❌ | 17m | grátis |
| 21 | Grok 4.20 | 22 | D | ❌ | 8m | ~$0.60 |
| 22 | GPT OSS 20B (local) | 8 | D | ❌ | falhou | grátis |

## Correção de rota: o que mudou no critério

Vale registrar o que mudou entre a iteração anterior e essa, porque mudou bastante.

### Erro 1: eu catalogava como "hallucination" APIs que são reais

Embaraçoso. Fui verificar direto o código do gem em `~/.local/share/mise/installs/ruby/4.0.2/lib/ruby/gems/4.0.0/gems/ruby_llm-1.14.1/` e duas coisas que eu chamava de inventadas são API pública legítima:

**`chat.add_message(role: :user, content: "x")` não é um kwargs bug**. Eu afirmei que isso crashava com `ArgumentError` porque a assinatura real seria hash posicional. Olhando no gem, `Chat#add_message(message_or_attributes)` aceita tanto um `Message` quanto um hash. O parser do Ruby trata `add_message(role: :user, content: "x")` como `add_message({role: :user, content: "x"})`, um hash posicional. **Funciona.**

**`chat.complete(&block)` é método público real** no RubyLLM 1.14.1.

Consequência: muitos modelos que eu tinha tachado como Tier 3 usavam API correta.

### Erro 2: RubyLLM correto sozinho não basta

Mesmo com a correção de API, faltava peso na completude do deliverable. Se um modelo escreve RubyLLM perfeito mas esquece docker-compose, deixa README como template stock, ou omite bundle-audit, o projeto não tá pronto.

A rubrica nova distribui peso e isso mudou o ranking:

- **Kimi K2.6** subiu de "meio fix Tier 2" pra Tier A (84). Único modelo não-ocidental com testes que mockam RubyLLM de verdade + rescue + session cookie multi-worker safe.
- **Kimi K2.5** voltou pra Tier B (66) de Tier 3. API que chamei de inventada é real. Cai por outro motivo: 37 testes que nunca mockam RubyLLM.
- **Gemini 3.1 Pro** pulou pra Tier A (82). Turbo Streams reais, cache-backed persistence com TTL, FakeChat com assinatura correta.
- **GPT 5.4 xHigh** empata em primeiro com Opus 4.7 (94/100). Arquitetura impecável + deliverables completos.
- **DeepSeek V4 Pro** caiu de "Tier 1 code" pra Tier B (66). Deliverables meia-boca: README stock + sem docker-compose + bundle-audit faltando.
- **MiMo V2.5 Pro** caiu de "primeiro Tier 1 não-Anthropic" pra Tier B (64). Testes não exercitam o LLM + Singleton process-local + sem rescue + sem system prompt.
- **GLM 5.1** caiu feio pra Tier C (43). A fluent DSL dele (`c.user()`, `c.assistant()`) é mesmo inventada, grep confirma. E cada request reconstrói `ChatSession.new`, descartando histórico. Dois bugs compostos.

Lição: contar arquivos e testes mede zero se o código tá errado. Mas RubyLLM correto sozinho também não basta. Precisa dos dois.

## Tier A: o que faz eles funcionarem

Pra entender o que separa Tier A de Tier B, olha o que Opus 4.7, Kimi K2.6 e Gemini 3.1 Pro fazem e que MiMo e DeepSeek V4 Pro não fazem.

**Todos os Tier A têm essas 4 coisas:**

1. **Testes que mockam RubyLLM com assinatura correta.** `FakeChat` que implementa `with_instructions`, `add_message`, `ask`. Testes que exercitam happy path E error path. WebMock bloqueando chamadas reais ao OpenRouter.
2. **Rescue em volta de `chat.ask`** com erro tipado (`LlmClient::Error` ou similar) e UI degradada pro usuário.
3. **Persistência que sobrevive restart** e funciona multi-worker. Session cookie (Opus, K2.6) ou Rails.cache com TTL (Gemini, GPT 5.4).
4. **System prompt via `with_instructions`.** O modelo sabe o papel dele.

Tier B geralmente falha em 2-3 dessas dimensões. MiMo falha em todas as 4. DeepSeek V4 Pro tem o código RubyLLM mais limpo (persistente `@chat`) mas não entrega os deliverables. Sonnet 4.6 tem arquitetura ambiciosa (multi-conversation sidebar) com um bug sutil de control-flow que os testes carimbam sem checar.

Tier C geralmente tem pelo menos um bug estrutural: fluent DSL inventada, histórico descartado a cada request, gem ruby_llm no grupo `:test` com `require: false`, ou bypass completo do gem usando `Net::HTTP` direto.

## Família Claude: Opus 4.6 vs 4.7, Sonnet 4.6

Opus 4.7 lidera com 94/100. Código exemplar:

```ruby
chat = @client.chat(model:, provider:)
chat.with_instructions(@system_prompt)
previous_messages.each { |msg| chat.add_message({role: msg.role.to_sym, content: msg.content}) }
response = chat.ask(user_message)
response.content
```

`FakeChat` com assinatura real. Testes verificam replay de histórico, error wrapping, model/provider override, system prompt. Session cookie com `to_a`/`from_session` multi-worker safe. Rescue de `RubyLLM::Error + StandardError` → balão de erro amigável na UI.

Dedução menor: Dockerfile gerado com `ARG RUBY_VERSION=4.0.2`, que é o default do generator do Rails 8.1 e a versão estável atual do Ruby. Gemini 3.1 Pro foi o único modelo que substituiu pelo 3.4.1 (mais antigo), o que a auditoria original contou a favor dele por engano.

Opus 4.6 tem código correto também (80/100 Tier A) mas menos disciplinado. Controller sem rescue em volta do `chat_service.ask`: um 5xx transiente vira stack trace. Service acessa `Chat#messages` via `attr_reader` direto, violação de Demeter. Diferença material entre 4.6 (Tier A baixo) e 4.7 (Tier A alto).

Sonnet 4.6 é Tier B (75). UI mais rica de todo o benchmark (sidebar multi-conversation). Mas `LlmChatService#call` só chama `ask` se a última mensagem do histórico for do usuário, senão retorna `""` silenciosamente. Os testes carimbam sem checar o bug. E a conversa inteira cabe num cookie de 4KB, que estoura depois de ~10 turnos.

### O downgrade de comportamento do 4.7

A reclamação da comunidade no [Reddit e DEV.to](https://dev.to/vibeagentmaking/why-we-switched-back-from-claude-opus-47-to-46-47f9) de que "4.7 piorou pra coding" não é sobre qualidade de código. Em benchmark objetivo ele tá no topo. O que 4.7 piorou é **comportamento**:

- Novo tokenizer [consome 1x a 1.35x mais tokens](https://platform.claude.com/docs/en/about-claude/models/migration-guide) pro mesmo texto
- Tenta otimizar recursos (tokens, tool calls, passos) mais agressivamente, às vezes pulando etapas
- [Issues no GitHub](https://github.com/anthropics/claude-code/issues/52368) relatam Max Plan esgotando em minutos onde antes durava horas

Eu tenho centenas de horas com 4.6 e tô testando 4.7 desde o lançamento. O código que 4.7 produz é Tier A, igual ou melhor que 4.6. Mas no uso diário, o comportamento mais direto do 4.6 é mais produtivo. 4.6 continua sendo minha escolha default no Claude Code, quando o Claude Code me deixa escolher (desde o lançamento do 4.7, [Claude Code mudou o default pra xHigh reasoning](https://code.claude.com/docs/en/model-config) e tá mais restritivo em downgrade pra 4.6).

## GPT via Codex: 5.4 xHigh hoje, 5.5 chegando

GPT 5.4 xHigh via Codex CLI empata com Opus 4.7 em primeiro (94/100). Usa o `RubyLLM.chat(model:, provider: :openrouter, assume_model_exists: true)` + `with_instructions` + `add_message(role:, content:)` + `chat.ask` + `response.content`. Textbook, com provider pinning e registry-skip.

É o único modelo com:

- **API-key preflight explícito** (`ensure_api_key!` raises `MissingConfigurationError`)
- **Status HTTP diferenciados**: 503 pra erro de config, 502 pra erro de runtime
- **Rails cache persistence com TTL + cap** (24 mensagens × 12h)
- **Form object dedicado** (`PromptSubmission`) separado do domain model (`ChatMessage`)

10 arquivos de teste incluindo testes de render de partials. `FakeChat`/`FakeClient` casam com API real.

**Ponto fraco crítico**: 7.6M tokens totais → ~$16/run. 15× o custo do Opus pra qualidade essencialmente empatada. Difícil justificar a não ser que você não possa iterar na primeira tentativa.

### GPT 5.5: chegou ontem (23 de Abril)

A OpenAI [lançou o GPT 5.5 ontem](https://openai.com/index/introducing-gpt-5-5/), já [disponível no Codex](https://community.openai.com/t/gpt-5-5-is-here-available-in-codex-and-chatgpt-today/1379630). Ainda não tá na API pública com API key, só com ChatGPT sign-in. [Simon Willison já começou a testar](https://simonwillison.net/2026/Apr/23/gpt-5-5/). Vou rodar o benchmark contra GPT 5.5 via Codex essa semana. Update em artigo separado.

## DeepSeek: o padrão de overhype

Toda geração do DeepSeek vem com propaganda pesada ("competitive with Claude Opus") e termina com o mesmo padrão: **tool support fica pra trás**.

### V4 Pro: código limpo, deliverables meia-boca (66/100 Tier B)

O código RubyLLM é Tier A:

```ruby
def initialize
  @chat = RubyLLM.chat
  @messages = []
end

def ask(content)
  result = @chat.ask(content)
  @messages << Message.new(role: "user", content: content)
  @messages << Message.new(role: "assistant", content: result.content)
end
```

Instância persistente de `@chat`, delega multi-turn pro RubyLLM. Padrão correto.

Mas o run DNF em opencode. DeepSeek V4 Pro usa thinking mode por default e retorna `reasoning_content` em toda resposta. A API do DeepSeek rejeita turnos subsequentes se o client não eco esse `reasoning_content` de volta. Opencode não faz isso. Tentei `reasoning: false` no config. Aceitou, o run foi muito mais longe (1972 arquivos vs 1071) mas ainda DNF depois.

E os deliverables antes do crash são fracos: README stock ("This README would normally document..."), **sem `docker-compose.yml`** (requisito explícito do prompt), bundle-audit faltando. Score 66/100 Tier B.

### V4 Flash: cheapest viable option (75/100 Tier B)

$0.01/run, 2m 35s, corrige o bug crítico do V3.2 (que inventava `RubyLLM::Client`). API toda correta. WebMock testa endpoint real do OpenRouter. Session-replay multi-turn via `session[:messages]`.

**Gotcha:** model slug é `"claude-sonnet-4"` faltando prefixo `anthropic/`. 404 no OpenRouter em runtime. Um caractere pra arrumar, fatal se deploy cego.

### V4 vs V3.2

| | V4 Flash | V4 Pro | V3.2 |
|---|---|---|---|
| Score | 75 | 66 | 40 |
| Tier | B | B | C |
| Harness | completa | DNF | completa |
| Custo | ~$0.01 | ~$0.50 | ~$0.07 |
| RubyLLM | correto | correto | inventou `RubyLLM::Client` |
| Deliverables | OK | stock README + sem compose | razoáveis |

V4 é upgrade real em correção de API sobre V3.2. V4 Flash é a opção barata que funciona. V4 Pro precisa de harness compatível com thinking mode (Codex, API direta).

## Kimi: K2.5 → K2.6

### K2.6 (84/100, Tier A)

Surpresa positiva. Único modelo não-ocidental Tier A. Código exemplar:

```ruby
chat = RubyLLM.chat
chat.with_instructions(SYSTEM_INSTRUCTION)
historical_messages.each do |msg|
  chat.add_message(role: msg[:role], content: msg[:content])
end
response = chat.ask(user_message)
response.content
```

Combinação única entre modelos chineses: `FakeChat` que casa com API real, rescue de `RubyLLM::Error` (com flash via turbo_stream), session cookie com `MAX_MESSAGES = 50` cap. Gemfile completo. Multi-worker safe.

Dedução só pelo replay completo de histórico a cada turn, que usa mais tokens que o padrão persistente do MiMo.

A $0.30/run, Kimi K2.6 é o **mais barato Tier A do benchmark**. 3 a 50× mais barato que Opus 4.7 e GPT 5.4 xHigh.

### K2.5 (66/100 Tier B, não Tier 3 como eu tinha dito)

Na primeira versão eu catalogava K2.5 como Tier 3 por supostamente inventar `chat.complete` e usar kwargs no `add_message`. Ambos são API pública real. K2.5 volta pra Tier B.

Cai de K2.6 pra K2.5 por: 37 testes (mais do benchmark) nunca mockam RubyLLM. Só testam PORO CRUD e `respond_to?`. Test coverage sem mock-fidelity não mede nada. E usa class-var storage (`Chat.storage = @storage ||= {}`), pior que Singleton porque não tem mutex.

K2.6 adiciona o que K2.5 não tinha: FakeChat de assinatura correta, rescue, session cookie. Evolução real nas dimensões que importam.

## Xiaomi MiMo V2.5 Pro: parecia Tier 1, mas os gaps são reais

MiMo V2.5 Pro (Abril 2026) gerou o maior hype da rodada. Na primeira análise eu promovi como "primeiro não-Anthropic Tier 1". Depois da nova rubrica, cai pra Tier B (64/100).

Código RubyLLM continua limpo:

```ruby
@llm_chat = RubyLLM::Chat.new(model: MODEL, provider: PROVIDER)
response = @llm_chat.ask(content, &)
@messages << { role: :assistant, content: response.content }
```

`Chat.new(model:, provider:)` construtor público válido. `.ask(content, &)` forward de bloco de streaming. Zero chamadas manuais de `add_message`. Multi-turn delegado pro RubyLLM. **É o padrão mais limpo que qualquer modelo do benchmark já entregou.**

Mas score holístico = 64 porque os outros componentes têm gaps:

- **Testes não exercitam o caminho do LLM.** Os 21 testes só checam constantes e blank guard. `ChatSessionTest` não tem happy path. Se o LLM call funcionasse ou falhasse em silêncio, nenhum teste pegaria.
- **Error handling inexistente.** Sem `rescue` em volta do `@chat.ask`. Rate limit vira 500 com stack trace na tela.
- **`ChatStore` Singleton é process-local.** Morre no restart do Puma, não funciona com `WEB_CONCURRENCY > 1`, sem TTL.
- **Sem `with_instructions`**, o modelo não sabe o papel dele.

Em volta vão outros menores: Docker sem healthcheck, sem `restart: unless-stopped`, sem Thruster (Rails 8.1 default), README curto.

Vantagem genuína: abordagem idiomática da biblioteca. Pra app greenfield single-worker, menos código com mesma funcionalidade. A $0.14/run em 11 minutos é 8× mais barato e mais rápido que Opus.

**Veredicto**: MiMo é ~70% da qualidade do Opus a 12.5% do preço. Pra protótipo throwaway, vale. Pra produção, ~2 horas de engenheiro adicionando rescue + Rails.cache + FakeChat + WebMock + system prompt. Aí Opus a $1.10 sai mais barato no total.

## Gemini 3.1 Pro: a surpresa discreta (82/100 Tier A)

Eu tinha classificado como Tier 3. Re-audit revelou que `Chat.new` e `add_message` com hash keyword são API real.

Características fortes: Turbo Streams reais (não fetch + innerHTML), Rails.cache-backed persistence com 2h expiry, FakeChat mocks que casam com API real, error path testado. O Dockerfile opta por Ruby 3.4.1 em vez do 4.0.2 padrão do Rails 8.1. A primeira auditoria dava isso como vantagem, mas 4.0.2 é a versão estável atual, então é mais neutro que ganho.

Ponto fraco crítico: usa model string `claude-3.7-sonnet` em vez do Sonnet 4.x atual. Correção de um caractere.

A $0.40/run, Gemini 3.1 Pro é o outro Tier A cost-effective junto com Kimi K2.6.

## Família Qwen: distilação não salva

Testei vários Qwens:

| Modelo | Tipo | Tier | Detalhe |
|---|---|:---:|---|
| Qwen 3.6 Plus | Cloud, OpenRouter | B (68) | API RubyLLM correta; testes fazem chamadas reais (sem WebMock); histórico client-side JS |
| Qwen 3.5 35B | Local NVIDIA | C (52) | Entry point correto; sem multi-turn; teste encapsula chamada real em `rescue => e; assert true` |
| Qwen 3.5 122B | Local NVIDIA | D (34) | Não usa ruby_llm; usa `Openrouter::Client` (casing errado) |
| Qwen 3 Coder Next | Local NVIDIA | D (29) | Inventa `RubyLLM::Client.new`; commit de `.env` placeholder |
| Qwen 3.5 27B Claude-distilado | Local NVIDIA | ainda Tier 3 em reavaliação | Código parece Claude, mas API toda inventada |

### A descoberta: distilação de Claude não transfere conhecimento de biblioteca

Rodei o [Jackrong's Qwen 3.5 27B distilado do Claude 4.6 Opus](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled). A promessa era "Claude-em-casa" rodando local. O resultado: o código sai com estilo Claude (frozen_string_literal, Response value objects, layered architecture, doc comments), mas funcional é alucinação completa:

```ruby
RubyLLM::Chat.new.with_model(@model) do |chat|
  conversation_history.each do |msg|
    chat.add_message(role: :user, content: msg[:content])
  end
  response = chat.ask(message)
  Response.new(content: response.text, usage: build_usage(response))
end
```

O problema aqui é a forma de bloco inventada `.with_model(@model) do |chat| ... end` que não existe no gem, e `response.text` em vez do `response.content` real.

Distilação transferiu o **estilo** e parou lá. Memória factual sobre biblioteca específica é recall binário: ou tá nos pesos ou não tá. Traços de raciocínio do Claude não contêm repetições tipo "use `ask`, não `complete`" porque isso não é raciocínio, é lembrança crua.

Se você precisa que o modelo realmente use RubyLLM ou qualquer biblioteca menos popular, distilação de Claude não salva. Use Claude de verdade ou um modelo cloud grande.

### Coder vs Geral: a surpresa inversa

Intuitivamente, modelos com "Coder" no nome deveriam ser os melhores pra programação. No benchmark, foi o contrário. Dos três Qwen Coders testados:

- Qwen 3 Coder 30B devolveu uma string mockada hardcoded em vez de chamar RubyLLM
- Qwen 2.5 Coder 32B timeout em 90 minutos com zero arquivos
- Qwen 3.5 27B Sushi Coder RL falha de infra

Enquanto o geral Qwen 3.5 35B-A3B completou em 5 minutos com projeto Rails reconhecível. Minha leitura: fine-tuning específico pra coding dos "Coders" foi treinado em problemas isolados (Codeforces, Leetcode, snippets curtos), longe dos fluxos agentic com tool calling de longa duração. "Coder = melhor pra coding agent" é falso pra esse tipo de tarefa.

### Qwen 3.6 Plus: o cloud que quase chegou

O Qwen 3.6 Plus no OpenRouter completou o benchmark em 17 minutos e é o Qwen mais limpo que medi (68/100 Tier B). API RubyLLM correta. Stimulus controller bem-construído. Mas os testes fazem chamadas reais ao OpenRouter (sem WebMock), e o histórico é só client-side JS (perdido no refresh). Usa `fetch` + `innerHTML` em vez de Turbo Streams.

## Família GLM: 5, 5.1, 4.7 Flash local

### GLM 5 (61/100 Tier B)

`RubyLLM.chat(model: "anthropic/claude-sonnet-4")` + `chat.ask` + `response.content` correto. Mocha stubs casam com API real. Único teste, só happy path.

**Ponto fraco crítico**: zero multi-turn state. Todo POST cria um `RubyLLM.chat` fresco sem histórico. "Chat app" é echo service stateless. "O que eu acabei de falar?" → "não sei."

### GLM 5.1 (43/100 Tier C, caiu)

Essa é a queda mais dolorosa da re-audit. `RubyLLM.chat(model:, provider:)` correto, mas o histórico é replayado via `c.user(msg)` / `c.assistant(msg)`, fluent DSL que **não existe** no RubyLLM (grep confirmado no código do gem).

Pior: cada request HTTP constrói `ChatSession.new` novo que descarta história. Os dois bugs se mascaram: a DSL inventada raramente é executada porque nunca tem história pra replay.

Stimulus controller usa `fetch` + manual `innerHTML`. Feito em SSE mas sem Turbo Streams.

Segundo a própria [Z.ai](https://www.buildfastwithai.com/blogs/glm-5-1-open-source-review-2026), o [GLM 5.1 bate GPT 5.4 e Opus 4.6 em SWE-Bench Pro](https://openrouter.ai/z-ai/glm-5.1/benchmarks). No meu benchmark específico (Rails + RubyLLM + deliverables completos), cai pra Tier C. Mais uma evidência de que benchmark é específico.

### GLM 4.7 Flash bf16 local (49/100 Tier C)

O modelo local do benchmark que mais domina a API do RubyLLM. Usa a fluent chain `.with_model().with_temperature().with_params().with_instructions().complete(&block)`, tudo API real conforme o código do gem.

**Fatal bug**: `gem "ruby_llm"` tá em `group :development, :test` com `require: false`. Não carrega em produção. `NameError` no boot. Usa class-var `Message.all` (process-local).

## Os perdedores (Tier C/D): MiniMax, Grok, Step, DeepSeek V3.2, GPT OSS

| Modelo | Score | Tier | Razão |
|---|---:|:---:|---|
| DeepSeek V3.2 | 40 | C | Inventa `RubyLLM::Client.new` e `client.chat(messages: [...])`; testes mockam classe que não existe |
| Step 3.5 Flash | 53 | C | Bypassa `ruby_llm` inteiro com `Net::HTTP` direto; não compliant com prompt |
| MiniMax M2.7 | 38 | D | Inventa `RubyLLM.chat(model:, messages: [...])` batch signature; crash na primeira chamada |
| Qwen 3.5 122B | 34 | D | Usa `Openrouter::Client` (casing errado); chama `client.chat` em gem que não existe |
| Qwen 3 Coder Next | 29 | D | Inventa `RubyLLM::Client.new` + `client.chat(messages:)` + OpenAI-shaped response |
| Grok 4.20 | 22 | D | `ruby-openai` em `:development, :test` com `require: false` → NameError em produção; Stimulus JS uncompilable |
| GPT OSS 20B | 8 | D | Sem pasta de testes; `app/app/` aninhado; inventa `RubyLLM::Client.new` |

## Modelos que não completaram o benchmark

O ranking acima lista os 22 modelos que **completaram** o benchmark o suficiente pra serem auditados. Mas o benchmark cobre mais modelos do que isso. No total, 33 foram configurados, 27 foram executados, e só 16-22 (dependendo do critério) completaram o suficiente pra virar código auditável. Os que falharam merecem registro:

| Modelo | Harness | Problema | Causa raiz |
|---|---|---|---|
| Gemma 4 31B (local, llama.cpp) | local | Loop infinito de tool calls depois de ~11 steps | [Bug #21375 do llama.cpp](https://github.com/ggml-org/llama.cpp/issues/21375), parcialmente corrigido em b8665 |
| Gemma 4 31B (Ollama Cloud) | cloud | Timeout 504 aos ~20K tokens | Edge timeout de 100s do Cloudflare; run de benchmark passa de 50K tokens, não tem como |
| Llama 4 Scout (local) | local | Tool calls emitidos como texto puro | llama.cpp não tem parser pro formato pythonic do Llama 4 (o vLLM tem) |
| Qwen 3 32B (local) | local | Lento demais (7.3 tok/s) | Gargalo de hardware (cabe na VRAM, mas a banda não entrega) |
| Qwen 2.5 Coder 32B (local) | local | Timeout de 90 minutos com zero arquivos | Loop de reasoning infinito sem chamar as ferramentas de write |
| GPT 5.4 Pro (OpenRouter) | cloud | Travou depois de tool-calls | Integração tool-calling do OpenRouter quebrada pra GPT; usar Codex CLI em vez disso |

Também foram testados mas nem entraram na comparação final por motivos variados: Qwen 3.5 27B Claude-distilled (coberto na seção da família Qwen como exemplo de distilação que não transfere conhecimento de biblioteca), Qwen 3 Coder 30B (devolveu string mockada hardcoded em vez de chamar RubyLLM), Qwen 3.5 27B Sushi Coder RL (falha de infra no llama-swap), Qwen 3.6 35B local (melhor resultado Qwen local, mas falta `.content` no retorno, correção de 1 linha pra virar funcional).

A lição prática: **metade do desafio de rodar open source local em 2026 tá na toolchain**. Bugs de llama.cpp, lifecycle do Ollama, parsers de tool call ausentes, timeouts de Cloudflare no Ollama Cloud. Mesmo que o modelo seja bom, se o stack que roda ele travar a cada 11 tool calls, na prática você não consegue usar.

## A situação chinesa: o gap em prática

O benchmark cobre basicamente todas as famílias chinesas de LLM com lançamento recente: **Moonshot** (Kimi), **DeepSeek**, **Xiaomi** (MiMo), **Alibaba** (Qwen), **Z.ai** (GLM), **MiniMax** e **StepFun** (Step). Vale consolidar o quadro todo, porque o discurso de "a China já alcançou" é mais otimista do que esse benchmark sustenta.

### Distribuição por tier

- **Tier A (80+)**: apenas **Kimi K2.6** (84). Nenhum outro modelo chinês.
- **Tier B (60-79)**: Kimi K2.5 (66), DeepSeek V4 Pro (66), DeepSeek V4 Flash (75), Xiaomi MiMo V2.5 Pro (64), Qwen 3.6 Plus (68), GLM 5 (61).
- **Tier C (40-59)**: Step 3.5 Flash (53), GLM 4.7 Flash local (49), GLM 5.1 (43), DeepSeek V3.2 (40).
- **Tier D (<40)**: MiniMax M2.7 (38), Qwen 3.5 122B local (34), Qwen 3 Coder Next local (29).

Dos 13 modelos chineses testados (contando locais e cloud), **apenas um** chega em Tier A. Esse é o tamanho da penetração atual nesse benchmark específico.

### O gap em pontos

**Kimi K2.6 vs Opus 4.7 (Tier A vs Tier A)**: 84 vs 94. 10 pontos de gap. Em prática, os dois entregam RubyLLM correto, FakeChat com assinatura real, rescue de erro, session cookie multi-worker safe, Gemfile completo. O que Opus 4.7 tem a mais são dimensões secundárias que somam: testes que cobrem error wrapping, model/provider override e aplicação explícita de system prompt; rescue redundante no controller além do service; separação de concerns levemente melhor. Diferenças perceptíveis lado a lado, mas não tier separado.

Custo: K2.6 $0.30/run vs Opus 4.7 $1.10/run. **3.6× mais barato.** Em runs contínuos de produção, essa diferença acumula.

**Chineses Tier B vs Claude Opus 4.6 (80 Tier A)**: gap de 5 a 20 pontos. Os Tier B chineses (MiMo, DeepSeek V4 Flash, Kimi K2.5, Qwen 3.6 Plus, GLM 5) têm o código RubyLLM correto ou quase correto, mas falham em componentes específicos:

- **Test quality** é o ponto mais fraco universal. Chineses Tier B frequentemente escrevem muitos testes (K2.5 escreveu 37, o maior do benchmark) mas não mockam RubyLLM. Teatro de cobertura.
- **Persistência** frequentemente usa Singleton process-local (MiMo) ou class-var (K2.5) em vez de session cookie ou Rails.cache. Morre em restart, não é multi-worker safe.
- **Error handling** costuma estar ausente. Rate limit vira 500 com stack trace visível pro usuário.

### Padrões por família

**Moonshot (Kimi)**: a família chinesa mais disciplinada. K2.5 em Tier B e K2.6 em Tier A. Evolução real de uma geração pra outra em dimensões que importam (testes, rescue, persistência). Única família que entregou Tier A.

**DeepSeek**: padrão de tool support atrás. Cada geração tem código RubyLLM melhor que a anterior (V3.2 inventava tudo, V4 Flash escreve correto, V4 Pro escreve perfeito), mas integração em ferramentas abertas vai mal. V4 Pro DNF em opencode por causa de thinking mode. A propaganda é consistentemente mais forte que o produto final em uso prático.

**Xiaomi (MiMo)**: escreve o código RubyLLM mais **idiomático** do benchmark (persistente `@chat`, zero `add_message` manual). Mas esquece testes reais, rescue, persistência robusta. Vira Tier B com demo de protótipo, não produção.

**Alibaba (Qwen)**: variância alta. Qwen 3.6 Plus cloud chega em Tier B. Qwen 3.5 35B local em Tier C com correções. Qwen 3.5 122B e os "Coders" (Qwen 3 Coder Next, Qwen 2.5 Coder 32B) caem em Tier D por inventar API ou travar. "Coder" no nome não é garantia de coding agent.

**Z.ai (GLM)**: GLM 5 em Tier B razoável. GLM 5.1 **regrediu** pra Tier C, com fluent DSL inventada mais descarte de histórico. Z.ai promete superioridade em SWE-Bench Pro, mas nesse benchmark específico pegou dois bugs estruturais. GLM 4.7 Flash local chega perto mas o gem no grupo `:test` mata em produção.

**MiniMax** e **StepFun (Step)** não entregam. MiniMax inventou batch signature que crasha na primeira chamada. Step bypassa o `ruby_llm` inteiro com `Net::HTTP`, violando o prompt.

### Conclusão sobre o gap chinês

Pra esse benchmark específico (app Rails + RubyLLM + deliverables completos):

- **Um** modelo chinês entrega Tier A como substituto direto pro Opus: **Kimi K2.6**. Gap de 10 pontos vs Opus, 3.6× mais barato.
- **Cinco modelos chineses** entregam Tier B usável com 1-2h de patching: K2.5, V4 Flash, V4 Pro, MiMo, Qwen 3.6 Plus, GLM 5.
- **Resto não é usável** em produção pra esse tipo de tarefa.

A narrativa de "a China já alcançou o Ocidente em LLM coding" precisa ser lida com ressalvas. Em benchmark sintético de raciocínio, talvez. Em benchmark de entregar um app Rails completo com todas as partes funcionais? Um modelo alcançou. Os outros ainda estão a uma geração de distância.

## A realidade de rodar open source localmente

Todo open source viável no benchmark ficou em Tier C ou pior. Vale explicar por quê.

### VRAM + KV Cache: a conta que ninguém faz

Pega o Qwen3 32B. FP16 ocupa ~64 GB. Quantizado em Q4, cai pra ~19 GB. Então cabe na RTX 5090 com 32 GB, certo? **Errado**. Isso é só o peso do modelo. Falta o KV Cache.

KV Cache é a memória que o modelo usa pra "lembrar" o que já leu. Escala **linearmente** com contexto:

```
Memória KV = 2 × Camadas × Cabeças_KV × Dimensão_Cabeça × Bytes_por_Elemento × Tokens_no_Contexto
```

Pra um Llama 3.1 70B em BF16, isso dá ~0.31 MB por token. Contexto de 128K tokens = **40 GB** só de KV Cache. Em benchmarks reais nossos, modelos consumiram entre 39K e 156K tokens. Menos de 100K de contexto não é prático pra coding agent.

Google publicou [TurboQuant](https://research.google/blog/turboquant-redefining-ai-efficiency-with-extreme-compression/) (ICLR 2026), que comprime KV Cache pra 3 bits sem perda de acurácia, 6× de redução e até 8× de speedup. Ainda não implementado em llama.cpp nem Ollama.

### Banda de memória manda, capacidade não

"Mas eu tenho 128 GB de RAM!" Legal, mas o que importa é banda de memória. Diferenças brutais:

| Memória | Banda |
|---|---:|
| DDR4 | ~50 GB/s |
| LPDDR5x (AMD Strix) | ~256 GB/s |
| GDDR6 (RTX 3090) | ~936 GB/s |
| GDDR7 (RTX 5090) | ~1.792 GB/s |
| HBM3 (Mac Studio M4 Ultra) | ~800 GB/s |

RTX 5090 tem 7× mais banda que LPDDR5x do meu Minisforum AMD Strix. No AMD, Qwen3 32B roda a ~7 tok/s; na 5090, seria muito mais rápido se coubesse.

Pra Mac Studio M4 Ultra com 512 GB de memória unificada (~$10k), é prático mas caro. Pra AMD Ryzen AI Max com LPDDR5x 256 GB/s, é acessível mas lento. Pra DDR4 desktop, é inviável.

### Ollama vs llama.cpp: cada um com seus problemas

[Ollama](https://ollama.com/) falhou em 6 das 8 tentativas de benchmark local: model unloading no meio da sessão, context drift, lifecycle instável, bf16 quebrado. Migrei pra [llama-swap](https://github.com/mostlygeek/llama-swap) (wrapper Go do llama-server). Resolveu o lifecycle mas trouxe outros problemas: cada modelo precisa de flags específicas (GLM/Qwen 3.5 precisam `--reasoning-format none` pra `<think>` tags), tool call parser dependente do modelo (Llama 4 pythonic format não parseia), Gemma 4 requer build b8665+ e mesmo assim entra em loops de repetição depois de ~11 tool calls.

Plug-and-play não é.

## O harness também importa

**O mesmo modelo Opus 4.7 produziu código mensuravelmente pior no Claude Code do que no opencode.** A diferença é context pollution do harness. Claude Code usa 6-11M cache-read tokens por run (vs ~210K no opencode) e isso empurra o modelo pra padrões genéricos tipo OpenAI SDK em vez do RubyLLM específico.

Tradução prática: mesmo com o mesmo modelo, a ferramenta que você usa pra invocar ele muda o output. Pra testes estáveis de modelo, rodei tudo no opencode.

## Multi-model não vale pra coding greenfield

Pergunta que aparece toda semana no meu feed: vale configurar dois modelos no mesmo projeto? Opus pra planejar, GLM pra executar, Haiku pra boilerplate? Testei 7 combinações em 3 harnesses:

- Claude Code: Opus 4.7 sozinho (baseline), Opus 4.7 + Sonnet 4.6 subagent, Opus 4.7 + Haiku 4.5 subagent
- opencode: Opus 4.7 + GLM 5.1 subagent, Opus 4.7 + Qwen 3.6 local subagent
- Codex: GPT 5.4 xHigh + GPT 5.4 medium, GPT 5.4 xHigh + GPT 5.4 low

**Zero dos 7 runs delegou voluntariamente pro sub-agente.** O modelo principal fez 100% do trabalho sozinho em todos os casos, mesmo com subagent declarado com linguagem agressiva tipo "Use PROACTIVELY" e "ALWAYS delegate to this agent for code implementation". Três razões:

### Razão 1: modelos Tier A já fazem plan-then-execute internamente

Opus 4.7 e GPT 5.4 xHigh reconhecem quando uma tarefa pede planejamento + implementação e já fazem isso **dentro da mesma sessão de pensamento**, sem context switch externo. O raciocínio "vamos dividir em design + código" acontece interno. Externalizar isso com dois modelos separados quebra o contexto contínuo e ganha nada.

### Razão 2: coordenação custa caro

Sub-agentes recebem prompt reduzido, contexto parcial, e precisam devolver output estruturado que o modelo principal consome. Toda essa ida e volta adiciona tokens, latência e oportunidade de desalinhamento. O modelo principal prefere absorver o custo de fazer sozinho a pagar o custo de coordenar com outro modelo. Isso é racional: economicamente, o sub-agent só compensaria se fosse muito mais barato E produzisse output equivalente. Geralmente ele é mais barato **mas pior**.

### Razão 3: não existe linha clara entre planejar e executar em greenfield

Num app Rails do zero, você planeja enquanto implementa, revisa decisões quando encontra problema concreto, rebalanceia trade-offs no meio do caminho. Dividir isso artificialmente entre dois agentes força uma separação que não reflete como o trabalho acontece em tarefa cohesive.

### O caso "Opus planeja, Qwen executa"

A pior combinação foi Opus + Qwen 3.6 local. Opus é Tier A em RubyLLM, Qwen é Tier C. A teoria: Opus (caro) planeja, Qwen (grátis) executa. Na prática:

1. Opus não delegou. Fez tudo sozinho.
2. Se tivesse delegado, o código Qwen sairia Qwen-quality (inventa API, sem mocks corretos).
3. Coordenação Opus ↔ Qwen não é de graça.

Três suposições falsas na teoria. Conclusão prática: **se você vai pagar Opus pra planejar, deixa ele fazer tudo**. É isso que ele já quer fazer naturalmente. Forçar delegação pra modelo inferior adiciona coordenação sem reduzir custo e piora resultado.

### Quando multi-model faz sentido

Não em tarefa coesa greenfield. Faz sentido em pipelines separados onde cada modelo tem escopo bem-definido: classificador rápido filtrando entrada, modelo grande processando só o subset que passou no filtro, modelo pequeno traduzindo saída. Isso não é "Opus planeja Qwen executa" no mesmo agent session, é arquitetura de múltiplos serviços com APIs diferentes.

Pra coding agent interativo em projeto real, a regra de bolso é: escolhe um modelo Tier A bom, usa ele sozinho, otimiza prompt em vez de orquestração.

## Melhor commercial, melhor open source

### Commercial

**Tier A premium**: Claude Opus 4.7, GPT 5.4 xHigh (Codex), Claude Opus 4.6. Escolha por preferência de comportamento; qualidade de código tá lá em todos.

**Tier A cost-effective**: Kimi K2.6 ($0.30/run), Gemini 3.1 Pro ($0.40/run). 3-4× mais baratos que Opus/GPT com qualidade comparable dentro desse benchmark.

**Tier B tolerável**: Claude Sonnet 4.6 ($0.63), DeepSeek V4 Flash ($0.01), Xiaomi MiMo V2.5 Pro ($0.14). Precisa de 1-2h de patching pra subir pra produção.

**Cheapest útil**: DeepSeek V4 Flash ($0.01/run) com o fix do prefix `anthropic/` no model slug.

### Open source (local)

**Nenhum Tier A.** O melhor local que rodou foi **Qwen 3.5 35B-A3B** em Tier C (52/100), e precisa de 1-2 prompts de correção pra entregar código que funcione. Pra quem tem RTX 5090 e quer fugir de vendor lock-in, é o modelo a rodar, mas com expectativa de hobby/lab, não produção.

**Qwen 3.6 35B local** é o mais próximo de funcionar que eu vi (correção de 1 linha pra adicionar `.content`), mas ainda sem multi-turn.

**GLM 4.7 Flash local** é o mais RubyLLM-literate local, mas o gem no grupo errado mata o app em produção. Fix trivial, impedimento estrutural.

**Em 2026, rodar open source local pra coding agent é viável com cautela, em hardware alto (RTX 5090 ou Mac M4 Ultra), aceitando 1-3 correções por run.** Não é substituto pra Claude ainda.

## Conclusão

Claude Opus 4.6 continua sendo a minha escolha diária pra coding agent em projetos reais. Comportamento previsível, código defensivo, mocks de verdade, persistência sensata, error handling.

Opus 4.7 tá no topo do benchmark objetivo (94/100) mas tem downgrade de comportamento (tokenizer mais pesado, otimização agressiva de recursos). Em benchmark entrega. Na prática diária eu prefiro 4.6.

GPT 5.4 xHigh via Codex empata no topo (94/100), mas a 15× o preço do Opus pra qualidade essencialmente tied, difícil justificar continuous use. GPT 5.5 chegou [ontem no Codex](https://community.openai.com/t/gpt-5-5-is-here-available-in-codex-and-chatgpt-today/1379630), testo essa semana.

O sweet spot cost-effective agora é **Kimi K2.6 a $0.30/run** ou **Gemini 3.1 Pro a $0.40/run**. Ambos Tier A. 3-4× mais baratos que Opus.

Open source local ainda não chegou em Tier A. O melhor é Qwen 3.5 35B-A3B em Tier C com correções. Pra experimentação, vale. Pra produção, não.

A lição maior da re-audit é sobre processo: **quando você começa a classificar modelos baseado em "hallucinations" que você acha que encontrou, vai no código-fonte da biblioteca e checa diretamente**. Eu tava descartando modelos por API calls válidas. Uma vez que checou contra o gem, Kimi, Gemini, DeepSeek V4 Flash e GPT 5.4 todos melhoraram. E uma vez que o critério incluiu deliverables (docker-compose, README substantivo, bundle-audit), modelos que pareciam limpos mas entregaram projeto incompleto (DeepSeek V4 Pro, Step 3.5 Flash via bypass) caíram pro tier que refletia isso.

Benchmark é ferramenta, não verdade. O que eu testo aqui é um app Rails específico com uma biblioteca específica. Modelos podem performar diferente em outras tarefas. A metodologia é explícita em [`audit_prompt_template.md`](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/audit_prompt_template.md) pra quem quiser replicar, adaptar, ou contestar.

O [repo](https://github.com/akitaonrails/llm-coding-benchmark) continua público com todos os success_reports e diffs.

## Fontes

- [Claude Opus 4.7 — What's new](https://platform.claude.com/docs/en/about-claude/models/whats-new-claude-4-7), Anthropic
- [Migration guide Claude 4.6 → 4.7](https://platform.claude.com/docs/en/about-claude/models/migration-guide), novo tokenizer
- [GitHub issue #52368 — Opus 4.7 instability](https://github.com/anthropics/claude-code/issues/52368)
- [DEV.to — Why We Switched Back from Opus 4.7 to 4.6](https://dev.to/vibeagentmaking/why-we-switched-back-from-claude-opus-47-to-46-47f9)
- [OpenAI — Introducing GPT-5.5](https://openai.com/index/introducing-gpt-5-5/)
- [OpenAI Community — GPT-5.5 is here in Codex](https://community.openai.com/t/gpt-5-5-is-here-available-in-codex-and-chatgpt-today/1379630)
- [Simon Willison — GPT-5.5 via Codex](https://simonwillison.net/2026/Apr/23/gpt-5-5/)
- [GLM 5.1 benchmarks no OpenRouter](https://openrouter.ai/z-ai/glm-5.1/benchmarks)
- [GLM 5.1 review — Build Fast With AI](https://www.buildfastwithai.com/blogs/glm-5-1-open-source-review-2026)
- [Jackrong's Qwen 3.5 27B Claude Opus Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled)
- [TurboQuant (Google Research, ICLR 2026)](https://research.google/blog/turboquant-redefining-ai-efficiency-with-extreme-compression/)
- [Ahmad Osman — GPU Memory Math for LLMs (2026)](https://x.com/TheAhmadOsman/status/2040103488714068245)
- [llama-swap](https://github.com/mostlygeek/llama-swap), wrapper llama.cpp
- [llama.cpp issue #21375 — Gemma 4 tool call loops](https://github.com/ggml-org/llama.cpp/issues/21375)
