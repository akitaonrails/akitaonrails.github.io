---
title: "LLM Benchmarks: DeepSeek Destravado! Use DeepClaude"
date: '2026-05-04T16:00:00-03:00'
draft: false
translationKey: llm-benchmarks-deepseek-unlocked-deepclaude
tags:
  - ia
  - llm
  - benchmark
  - deepseek
  - claudecode
  - ruby
---

DeepSeek V4 Pro deixou de ser um caso perdido no meu benchmark de coding. Antes ele era Tier B isolado (69/100) e literalmente não-mensurável em qualquer cenário multi-agente, porque batia num bug de protocolo que eu detalhei nos últimos dois posts. A boa notícia é que descobri um caminho que destrava o modelo, e ele saiu do limbo direto pra **Tier A com 89/100**, abaixo só de Opus 4.7, GPT 5.4/5.5 e Kimi K2.6. Vou contar como cheguei lá, o que é o **DeepClaude**, como você pode usar, e onde isso põe o DeepSeek no ranking atualizado.

## Recapitulando os posts anteriores

Quem chegou agora, vale o contexto. Esse experimento de benchmark começou em abril, e o caso DeepSeek vem se desenrolando há quatro artigos:

1. [Testando LLMs Open Source e Comerciais — Quem Consegue Bater o Claude Opus?](/2026/04/05/testando-llms-open-source-e-comerciais-quem-consegue-bater-o-claude-opus/) (5 de abril). Primeiro corte, comparando ~20 modelos rodando uma tarefa Rails 8 + RubyLLM + Hotwire + Tailwind + testes Minitest. Definiu o cenário e a tarefa-base que sigo usando até hoje.

2. [LLM Benchmarks Parte 2: Vale Combinar Múltiplos Modelos no Mesmo Projeto? Claude + GLM??](/2026/04/18/llm-benchmarks-parte-2-multiplos-modelos/) (18 de abril). Primeira tentativa de orquestração: deixar um planner forte (Opus) chamando subagents mais baratos (Kimi, Qwen, GLM, DeepSeek). Resultado: zero delegações em sete variantes free-choice. Modelos fortes preferiram fazer tudo sozinhos.

3. [Benchmark de LLMs pra Coding (Abril 2026): GPT 5.5, DeepSeek v4, Kimi v2.6, MiMo, e o Estado da Arte](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) (24 de abril). Versão canônica com 23 modelos, rubrica padronizada de 0-100 em 8 dimensões, tiers A/B/C/D. É a referência atual de "quem é o que" no ranking.

4. [LLM Benchmarks: Vale a pena ($) misturar 2 Modelos? (Planner + Executor)](/2026/04/25/llm-benchmarks-vale-a-pena-misturar-2-modelos/) (25 de abril). Três rodadas de orquestração multi-modelo: free-choice, forced delegation, e orquestração manual cross-process. Resposta curta: pra tarefa coesa de Rails greenfield, Opus 4.7 solo no opencode (97/100, $4, 18m) bate todas as combinações. Foi nesse post que documentei o protocolo de incompatibilidade do DeepSeek V4 Pro com qualquer harness baseado em ai-sdk.

A história do DeepSeek até esse ponto era assim: solo no opencode entrega 69/100 Tier B (código RubyLLM correto, mas com README stock, sem `docker-compose.yml`, sem bundle-audit). Em qualquer cenário multi-turn no opencode, a API rejeita o turno 2 com `"reasoning_content must be passed back to the API"`. O ai-sdk que opencode usa por baixo strippa o `reasoning_content` na construção da próxima request, e o DeepSeek devolve 400. Pior: o opencode soterra o erro no event stream e cai pro `general` fallback agent, que é o Opus 4.7. As runs "completam" com arquivos escritos, mas a maior parte do output saiu do Opus mascarado como DeepSeek. Score 69 reflete autoria mista, não V4 Pro de verdade.

Conclusão prática que tinha ficado: o DeepSeek V4 Pro era fundamentalmente incompatível com qualquer harness ai-sdk (opencode incluso). Pra usar de verdade, teria que ser API direta com handling de thinking mode ou harness customizado.

A descoberta dessa semana é que existe um harness customizado pronto. Chama-se **DeepClaude**.

## O que é DeepClaude

[DeepClaude](https://github.com/aattaran/deepclaude) é um shim de shell pro Claude Code (o CLI da Anthropic) que troca o endpoint que ele consulta. O Claude Code, por baixo, fala com `api.anthropic.com` e espera o formato Anthropic (Messages API com `system`, `messages`, `tools`, etc.). O DeepClaude define algumas variáveis de ambiente antes de invocar o Claude Code:

```bash
ANTHROPIC_BASE_URL          # endpoint alternativo
ANTHROPIC_AUTH_TOKEN        # token do endpoint alternativo
ANTHROPIC_DEFAULT_OPUS_MODEL    # modelo a invocar no lugar de Opus
ANTHROPIC_DEFAULT_SONNET_MODEL  # idem pra Sonnet
ANTHROPIC_DEFAULT_HAIKU_MODEL   # idem pra Haiku
CLAUDE_CODE_SUBAGENT_MODEL  # modelo do subagent
```

Backends suportados:

- **DeepSeek direto** via `api.deepseek.com/anthropic` (precisa do `DEEPSEEK_API_KEY`)
- **OpenRouter** via `openrouter.ai/api` (precisa do `OPENROUTER_API_KEY`)
- **Fireworks AI** via `api.fireworks.ai/inference` (precisa do `FIREWORKS_API_KEY`)
- **Anthropic** (sem override, Claude Code normal)

A genialidade do truque é que o Claude Code não percebe a troca. O loop de agente dele inteiro (edição de arquivos, execução de bash, spawn de subagents, multi-step tool use, prompt caching da Anthropic) roda igual. Só que cada chamada de modelo sai pelo OpenRouter (ou DeepSeek direto, ou Fireworks) e cai num modelo escolhido por você. No caso do nosso benchmark, o DeepSeek V4 Pro passa a receber o tráfego que normalmente iria pra Opus 4.7.

Por que isso resolve o bug do `reasoning_content`? Porque o endpoint compatível-com-Anthropic do OpenRouter (`/anthropic`) trata o conteúdo de thinking corretamente no formato que o Claude Code emite. O ai-sdk que o opencode usa não fazia isso. Mudou o harness, sumiu o bug.

Instalação:

```bash
git clone https://github.com/aattaran/deepclaude ~/Projects/deepclaude
ln -sf ~/Projects/deepclaude/deepclaude.sh ~/.local/bin/deepclaude
chmod +x ~/Projects/deepclaude/deepclaude.sh
deepclaude --status   # confere quais backend keys foram detectadas
```

Depois é só rodar:

```bash
export OPENROUTER_API_KEY=sk-...
deepclaude --provider openrouter --model deepseek/deepseek-v4-pro
# inicia uma sessão Claude Code com DeepSeek V4 Pro respondendo no lugar do Opus
```

Pra encerrar e voltar ao Claude Code normal, é só `exit` da sessão. As variáveis de ambiente são restauradas no fim do script.

## Como melhorei a suite de benchmark pra suportar DeepClaude

O `claude_code_runner.py` que eu já uso pra rodar variantes Claude Code (`claude_opus_alone`, `claude_opus_sonnet`, `claude_opus_haiku`) precisava aceitar uma forma de injetar variáveis de ambiente por variante, sem alterar o pipeline existente. Adicionei um campo opcional `env_overrides` no JSON de configuração de cada variante. O formato:

```json
{
  "env_overrides": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api",
    "ANTHROPIC_AUTH_TOKEN": "$OPENROUTER_API_KEY",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek/deepseek-v4-pro",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek/deepseek-v4-pro",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek/deepseek-v4-pro",
    "CLAUDE_CODE_SUBAGENT_MODEL": "deepseek/deepseek-v4-pro",
    "UNSET:ANTHROPIC_API_KEY": ""
  }
}
```

Convenções:

- Valor começando com `$` é lookup indireto na env do shell pai (`$OPENROUTER_API_KEY` resolve pro que tá na shell do usuário). Mantém secrets fora do `config/*.json` versionado.
- Chave começando com `UNSET:` remove a variável do env do subprocess. Uso isso pra dropar `ANTHROPIC_API_KEY` quando troco pra um backend não-Anthropic, senão o SDK pode preferir ela ao `ANTHROPIC_AUTH_TOKEN`.
- Resto é literal.

O runner loga quais overrides foram aplicados (com secrets mascarados) no início de cada variante, então o output do benchmark captura o setup completo. Isso me deu duas variantes novas no benchmark:

| Slug | Setup | Subagent registrado? |
|---|---|---|
| `claude_code_deepseek_v4_pro_or` | Claude Code via DeepClaude → DeepSeek V4 Pro pro loop inteiro | nenhum |
| `claude_code_deepseek_v4_pro_or_sonnet` | Igual, mas com `sonnet-coder` registrado (Sonnet 4.6 via Anthropic API) | sim, mas zero delegações observadas |

Ambas usaram `--no-progress-minutes 15` (o watchdog padronizado da Round 2.5).

## Resultados: DeepSeek V4 Pro na Tier A

Ambas as variantes rodaram end-to-end sem o erro de `reasoning_content`. Multi-turn funciona. Subagent registrado funciona (mesmo que não invocado). Tool calls, edição de arquivo, bash, tudo funciona. Os números:

| Variante | Status | Tempo | Arquivos | Turnos | Delegações | Custo | Score | Tier |
|---|---|---:|---:|---:|---:|---:|---:|---|
| `..._or` | completed | **21m** | 1544 | 106 | 0 (sem subagent) | **$3.38** | **84** | A |
| `..._or_sonnet` | completed | **18m** | 1348 | 109 | **0** (Sonnet ignorado) | **$3.14** | **89** | A |

Ambas 100% billed em `deepseek/deepseek-v4-pro`. Zero token de Sonnet apesar de registrado. O subagent existia, o planner DeepSeek nunca o invocou.

E onde isso põe o DeepSeek no ranking canônico? Aqui:

| Rank | Modelo | Score | Tier | Tempo | Custo |
|---:|---|---:|:---:|---|---|
| 1 | Claude Opus 4.7 (opencode) | **97** | A | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | **97** | A | 22m | ~$16 |
| 3 | GPT 5.5 xHigh (Codex) | **96** | A | 18m | ~$10 |
| **4** | **DeepSeek V4 Pro (DeepClaude + sonnet registrado)** | **89** | **A** | **18m** | **$3.14** |
| 5 | Kimi K2.6 | 87 | A | 20m | ~$0.30 |
| 6 | DeepSeek V4 Pro (DeepClaude solo) | 84 | A | 21m | $3.38 |
| 7 | Claude Opus 4.6 | 83 | A | 16m | ~$1.10 |
| 8 | Gemini 3.1 Pro | 82 | A | 14m | ~$0.40 |
| 9 | Claude Sonnet 4.6 | 78 | B | 16m | ~$0.63 |
| 9 | DeepSeek V4 Flash | 78 | B | 3m | ~$0.01 |
| 11 | Qwen 3.6 Plus | 71 | B | 17m | ~$0.15 |
| ... | DeepSeek V4 Pro (opencode solo) | 69 | B | ~25m | ~$1 | (configuração antiga, mantida como referência) |

Em uma rodada o V4 Pro entrega Tier A, sai do limbo de "não-mensurável", encosta em Kimi K2.6 e supera Opus 4.6 / Gemini 3.1 Pro. **Ganho de 15 a 20 pontos vindo só da troca de harness**. Mesmo modelo, mesmo prompt, sem orquestração, só um loop de agente diferente.

## O que essa rodada provou (e o que não provou)

### A regressão do Claude Code com Opus é específica do Opus, não do harness

Essa é a descoberta mais importante. No Round 1 eu tinha documentado que o Opus 4.7 dentro do Claude Code alucinava `chat.complete` (Tier 3), enquanto o mesmo Opus 4.7 no opencode entregava Tier A. A hipótese era que o contexto que o Claude Code injeta (system prompt, tool schemas, agent registry com 6-11M tokens de cache-read) empurrava o Opus pra um modelo mental OpenAI-SDK em vez do RubyLLM específico.

O DeepSeek V4 Pro no mesmo harness Claude Code usou o `chat.ask` correto (`chat_service.rb:17` em ambas as variantes). Sem `chat.complete`, sem fluent DSL inventada, sem invenção de batch-form. Grep cruzado nos dois projetos:

```
grep -nE "RubyLLM::Client|chat\.complete|chat\.send_message|chat\.user|chat\.assistant"
→ 0 hits (ambas as variantes)
```

A regressão é específica do Opus. O treinamento do Opus tem uma vulnerabilidade particular ao jeito que o system prompt e o schema-chatter do Claude Code priman o modelo. O DeepSeek é robusto a isso. Provavelmente outros modelos com training correto de RubyLLM passariam pelo Claude Code sem regredir do mesmo jeito.

### Subagent registrado, mesmo sem ser invocado, melhora a qualidade

A descoberta mais sutil. A variante `..._or_sonnet` tem o `sonnet-coder` registrado, mas o DeepSeek nunca o invocou (zero delegações, 100% dos tokens em `deepseek/deepseek-v4-pro`). Mesmo assim, ela pontuou +5 sobre a sister variant sem subagent (89 vs 84). Atribuição do auditor: com um subagent disponível "caso eu precise", o planner DeepSeek produziu decomposição mensuravelmente mais delegável. Seams menores, DI mais limpa, system prompt usado via `with_instructions`, controller test que mocka a API real do service em vez de fudgear.

> Knowing a subagent might execute the work pushes toward smaller, more contractable units — even when nothing actually delegates. Weak signal, single sample, but visible.

Isso bate com achados anteriores de que a fase CONVERGE estruturada (planner forçado a articular interface antes de executar) era a responsável pelos lifts de qualidade em algumas runs forçadas, mais do que a delegação em si. A mera disponibilidade de um subagent já faz o planner pensar mais como arquiteto.

### O bug de multi-turn no controller persiste

Um defeito específico que sobrevive à troca de harness: ambas as variantes DeepClaude têm problemas de multi-turn na camada de controller.

- Variante 1 (`..._or`): single-shot direto. `chats_controller.rb:10` constrói um array de mensagens com 1 elemento a cada POST, jogando histórico fora. O `ChatService` suporta histórico, mas o controller nunca manda.
- Variante 2 (`..._or_sonnet`): multi-turn correto via `session[:messages]`, mas o cookie-store estoura em ~10 turnos com `CookieOverflow`.

A run solo do DeepSeek no opencode (69/100) tinha o mesmo problema de single-shot. Harness diferente, agente loop diferente, mesmo erro do modelo. Arquitetura multi-turn pra Rails stateless é genuinamente difícil pro DeepSeek e a troca de harness não ajuda nesse gap específico.

### DeepSeek como planner também ignora subagents em tarefa coesa

Eu já tinha documentado nos posts anteriores que todo LLM frontier (Opus, GPT 5.4, Codex) ignorou os subagents registrados na tarefa Rails coesa do benchmark. Foi documentado como racionalidade do planner: planners inteligentes intuem corretamente que custo de coordenação excede ganho de execução em tarefa fortemente acoplada.

A Round 4 adiciona DeepSeek V4 Pro à lista: Sonnet 4.6 registrado, zero delegações. Generaliza o achado para "modelo de raciocínio forte enfrentando Rails greenfield com delegate opcional", em vez de uma esquisitice do Opus. O comportamento de não-delegar do DeepSeek bate com o que todo planner forte fez.

## Resposta atualizada pra "vale orquestrar?"

A conclusão da Round 3 era: pra Rails greenfield one-off, Opus solo no opencode ganha. A Round 4 adiciona três casos:

Pra quem não tem acesso a Anthropic Claude Opus (ou quer evitar custo direto Anthropic), `claude_code_deepseek_v4_pro_or_sonnet` é o substituto mais próximo: 89/100 Tier A, 18m, $3.14, rodando inteiramente no OpenRouter com a key que você já tem. É a primeira resposta significativa de "Tier A coding sem assinatura Anthropic" do benchmark.

Pra quem tem Opus, DeepClaude continua um pouco pior em qualidade (-8) com custo ligeiramente menor (-$0.66). Não vale a troca.

Pra comparar modelos dentro do harness Claude Code direto, DeepClaude torna a comparação possível: DeepSeek V4 Pro a 84-89 versus Opus 4.7 no nível Tier-3 regredido no mesmo harness. DeepSeek V4 Pro via DeepClaude bate o Opus 4.7 dentro do Claude Code em qualidade, custo e multi-turn. Vale lembrar que isso só acontece porque o Opus regride nesse harness; contra o Opus no opencode (97), o DeepSeek tá claramente atrás.

## O quadro cross-harness do DeepSeek V4 Pro

Ficou assim:

| Harness | Resultado |
|---|---|
| opencode solo (single agent) | 69/100 Tier B — funciona, falta polish nas entregas |
| opencode multi-agent forced (executor) | NÃO-MENSURÁVEL — bug de `reasoning_content` falha no turno 2 |
| opencode + orquestração manual cross-process (executor) | NÃO-MENSURÁVEL — mesmo bug |
| Claude Code via DeepClaude OR (solo) | **84/100 Tier A** — funciona, harness fecha o gap de polish |
| Claude Code via DeepClaude OR (com subagent registrado) | **89/100 Tier A** — bônus modesto de planner-availability |
| Claude Code direto (Anthropic API) | não testado — precisaria do `DEEPSEEK_API_KEY` pro endpoint nativo |

No fim das contas, o DeepSeek V4 Pro é Tier A quando entregue por um loop autônomo forte (Claude Code) e Tier B quando entregue por um harness mais fino (opencode). A correção de API RubyLLM é a mesma nos dois casos. A diferença de score tá inteiramente em completude de entrega (README, compose, CI tooling) que o loop do Claude Code preenche.

## Pra que usar isso

Três cenários onde o DeepClaude vira a ferramenta certa.

O primeiro é Tier A com orçamento sensível e sem assinatura Anthropic: a variante `..._or_sonnet` é o default agora. $3.14, 18m, 89/100, Tier A, rodando inteiro no OpenRouter.

O segundo é validar se a regressão do Claude Code pega outros modelos. Pega o Opus, não pega o DeepSeek. A regressão `chat.complete` é específica do Opus. DeepSeek (e presumivelmente outros modelos de raciocínio com training correto de RubyLLM) atravessam o harness sem regredir.

O terceiro é experimentação futura. DeepClaude abre a porta pra rodar qualquer modelo do OpenRouter dentro do loop completo do Claude Code. Vale re-testar Kimi K2.6 e Qwen 3.6 Plus via DeepClaude pra comparar com os resultados de orquestração manual da Round 3. Mesmo modelo, harness diferente, ver onde fica o ganho. Tem chance real de que o Kimi K2.6 (já em Tier A a 87) suba pra 90+ e empate com o V4 Pro deepclaude. É a próxima rodada do benchmark.

## Caveats do DeepClaude

Coisas que o README do projeto avisa, e que vale repetir aqui.

Sem image input: o endpoint Anthropic do DeepSeek não suporta vision. Pra esse benchmark é texto puro, então não interfere. Pra outros casos pode ser limitação real.

Sem MCP server tools: a camada de compatibilidade não suporta MCP. Se você usa MCPs no seu workflow Claude Code normal, eles não vão funcionar dentro do DeepClaude.

Prompt caching da Anthropic é ignorado. O `cache_control` que o Claude Code emite cai no chão. O DeepSeek tem cache automático próprio (que aparece no `cache_read` do token usage), mas os marcadores explícitos de cache são droppados. Custo por turno fica um pouco mais alto que comparável Anthropic-direct por causa disso. Relevante pra comparação de custo apples-to-apples.

## Resumindo

O DeepSeek V4 Pro saiu do limbo. Era Tier B em opencode solo e não-mensurável em qualquer cenário multi-agente. Via DeepClaude (Claude Code com env-vars apontando pro OpenRouter) ele entrega Tier A com 89/100, bate Opus 4.6 e Gemini 3.1 Pro, encosta em Kimi K2.6, custa $3.14 em 18 minutos. O ganho não veio de orquestração nem de modelo melhor: veio puramente de trocar o harness pra um loop de agente que o DeepSeek consegue dirigir bem. Pra quem não tem acesso a Opus mas tem `OPENROUTER_API_KEY`, é a primeira opção real de Tier A coding sem amarra Anthropic.

A próxima rodada já tá engatilhada: rodar Kimi K2.6 e Qwen 3.6 Plus via DeepClaude pra ver se o efeito de "harness forte sobe modelo Tier B/A pra topo" se reproduz. Se reproduzir, abre uma família inteira de variantes orçadas que podem competir com Opus solo no benchmark. Se não reproduzir, fica claro que o DeepSeek tem uma afinidade específica com o loop Claude Code que outros não têm. Os dois resultados são interessantes.

## Referências

- [DeepClaude no GitHub](https://github.com/aattaran/deepclaude) — o shim shell em si, README com lista completa de backends suportados
- [Round 4 success report](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.deepclaude.md) — o relatório técnico completo que originou esse post
- [Integração DeepClaude no benchmark](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/deepclaude-integration.md) — patch do runner, formato `env_overrides`, smoke test
- [Repo do benchmark](https://github.com/akitaonrails/llm-coding-benchmark) — código, configs, resultados de todas as rodadas
