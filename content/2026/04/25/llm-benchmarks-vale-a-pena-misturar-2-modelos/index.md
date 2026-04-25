---
title: "LLM Benchmarks: Vale a Pena ($$) Misturar 2 Modelos? (Planner + Executor)"
date: '2026-04-25T13:00:00-03:00'
draft: false
translationKey: llm-benchmarks-mixing-2-models-planner-executor
tags:
  - llm
  - benchmark
  - claude
  - ai
  - vibecoding
---

**TL;DR:** Não. Em todas as três rodadas de experimentos que rodei, mistura de "modelo forte planejador + modelo barato executor" perde pra simplesmente usar Opus 4.7 sozinho num harness maduro. **Solo Opus 4.7 em opencode entrega Tier A (97/100) em 18 minutos por ~$4 pay-as-you-go.** Nenhuma combinação multi-agente bate isso em qualidade, e nenhuma combinação é mais barata simultaneamente. A exceção é Codex GPT 5.4 xHigh + executor `medium`, que cai de ~$16/run pra ~$1-3/run perdendo 3 pontos de qualidade. Útil se você só tem GPT no provedor. Pra todo o resto, **deixa o frontier model decidir quando delegar sozinho**, especialmente se você tá numa assinatura mensal de Plus/Pro/Max.

---

## Antes de começar: as cinco premissas erradas

Tem uma narrativa que aparece toda semana no meu feed: "tô economizando dinheiro misturando Opus pra planejar com Kimi/Qwen/GLM/DeepSeek pra executar". A premissa é que o frontier model é caro demais pra usar em coding contínuo, então você quebra a tarefa: o caro pensa, o barato escreve. Soa razoável. Na prática, é errado por cinco motivos.

**Primeiro: a maior parte das pessoas que falam isso não mostram o resultado.** Tem gente se gabando de orquestrar dezenas de agentes em paralelo, dashboards bonitos, fluxos elaborados. Pede pra mostrar o app que saiu disso, em produção, gerando valor. Quase ninguém entrega. **Pede o resultado.** Se a pessoa não consegue mostrar produção real, é vendedor de fumaça. O meu benchmark, com tudo aberto, é exatamente o oposto disso: [o repo é público](https://github.com/akitaonrails/llm-coding-benchmark), os logs são auditáveis, o código gerado tá lá pra inspeção. Esse é o padrão mínimo pra discussão honesta sobre LLMs em coding.

**Segundo: o caso de uso muda tudo.** Se você tá fazendo um one-shot legítimo (Opus planeja arquitetura uma vez, modelo barato executa muitos pedaços paralelos com escopo bem-definido, tipo gerar 50 componentes de UI seguindo o mesmo padrão), aí pode fazer sentido. Mas a maioria das pessoas que reclama de custo de token tá fazendo coding agent contínuo, não one-shot massivo. Pra coding contínuo a conta muda completamente.

**Terceiro: pay-as-you-go vs assinatura muda completamente o cálculo.** Se você paga por token direto na API, todo prompt extra do orquestrador conta. Se você paga $20 ou $200 por mês de Plus/Pro/Max e tá usando Claude Code, Codex CLI ou similar dentro da quota da assinatura, a conta de "custo por run" desaparece. Vira "estou consumindo da minha quota mensal". Em assinatura, o custo marginal de uma chamada extra é zero até saturar a cota. Coordenar dois modelos pra economizar token nesse modelo é otimização contra um custo que não tá sendo cobrado.

**Quarto, e mais importante: você só percebe a maturidade do modelo solo quando faz vibe coding completo.** Eu já escrevi sobre isso em vários posts ([imersão de seis dias do zero à produção](/2026/02/16/vibe-code-do-zero-a-producao-em-6-dias-the-m-akita-chronicles/), [como falar com o Claude Code efetivamente](/2026/04/15/como-falar-com-o-claude-code-efetivamente/), [Clean Code pra agentes de IA](/2026/04/20/clean-code-para-agentes-de-ia/)). Vibe coding sério é: **desliga o IDE, não edita código manualmente, age como product manager + QA + tech lead mentor, deixa o modelo escrever**. Quando você faz isso, fica imediatamente óbvio que misturar dois modelos cria overhead absurdo de coordenação. É equivalente a outsourcing pra time offshore, mas você fica editando à mão cada entrega porque pega errinho em tudo. Plano que precisa especificar cada linha de código vira micromanagement: se o plano já contém o código, por que delegar? Esse é o extremo, mas é onde a maioria dos setups multi-agente cai. Equilíbrio é o que importa, e remover overhead é a técnica principal. Pra isso, **um bom frontier model dentro de um harness maduro (Claude Code, Codex, opencode) é o caminho**.

**Quinto, e o mais técnico: otimização prematura.** Donald Knuth já avisou faz décadas, "premature optimization is the root of all evil". A regra original: 97% do tempo você não tem dado pra justificar otimizar; quando tem, é só nos 3% críticos. Em 2026 a versão moderna disso é gastar fim de semana montando orquestração de cinco agentes em paralelo pra economizar $30/mês de token, antes de você ter validado se o produto que você tá construindo presta. Você tá otimizando custo de uma pipeline que ainda não entregou nada. Foco no entregar. Assinaturas de $20-200/mês são triviais comparadas com qualquer outro custo de aprendizado profissional. Gasta-se mais com cursos online ruins ou fim de semana de balada. Quando o produto rodar e o custo de token virar problema mensurável, aí sim, otimiza. Hoje, foco em entregar.

OK, fim do sermão. Vamos pros números.

---

## Metodologia em uma linha

Mesmo benchmark da [versão canônica](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/): construir um app Rails 8 com RubyLLM, Tailwind, Hotwire, testes Minitest, Brakeman, Docker, docker-compose. Mesma rubrica de 8 dimensões com score 0-100, mesmos tiers A/B/C/D. Diferença é que aqui cada variante tem **dois modelos**: um "planner" (forte) e um "executor" (mais barato), em diferentes harnesses (Claude Code, opencode, Codex). Tudo no [repo](https://github.com/akitaonrails/llm-coding-benchmark) com docs, dispatches, traces, audits.

Solo Opus 4.7 em opencode é a baseline de comparação: **97/100 Tier A, 18 minutos, ~$4 pay-as-you-go.** Toda variante multi-agente precisa bater isso (em qualidade, tempo OU custo) pra justificar a complexidade adicional.

---

## O que esse benchmark NÃO prova (e o que delegar bem significa)

Antes de mergulhar nas três rodadas, vale circular o que esse benchmark cobre e o que ele não cobre. Isso é importante porque eu vou tirar conclusões fortes sobre delegação, e essas conclusões não generalizam pra qualquer tipo de trabalho.

### Limite 1: o projeto é greenfield Rails simples

O benchmark constrói um app Rails 8 com chat RubyLLM. É código real, com Tailwind, Hotwire, Docker e testes, mas é **um projeto greenfield com escopo bem-definido em uma stack popular**. Praticamente todo modelo Tier A bate isso. Em termos de complexidade, é tarefa de início de júnior: não tem legacy code pra entender, não tem dívida técnica pra contornar, não tem sistema distribuído com 50 micro-serviços pra orquestrar.

Pra quem quer dado conclusivo sobre o **seu** caso de uso, a resposta honesta é: **adapte o harness do benchmark pra mimetizar as condições do seu projeto e compare modelos lá**. O [repo](https://github.com/akitaonrails/llm-coding-benchmark) é open source justamente por isso. Pega o prompt, troca pelo que reflete a sua realidade (codebase legado de 50K linhas, integração com 3 sistemas externos, DSL custom da empresa, ou seja qual for), e roda os modelos do mesmo jeito. Os números que eu reporto aqui dão direção, mas qualquer engenheiro sério deveria validar os modelos contra o trabalho que ele realmente faz, não contra um app de chat de exemplo.

### Limite 2: tarefas paralelizáveis vs tarefas com dependência

A pergunta "vale misturar dois modelos?" depende criticamente de **que tipo de trabalho você tá delegando**. Tem dois extremos.

**Trabalho onde frontier model delega de boa, e que vai funcionar lindamente:** tarefas numerosas, simples, com pouca ou nenhuma coordenação. "Traduz esses 100 documentos pro inglês." "Resume essas 50 planilhas em bullet points." "Converte essas 200 imagens pro WebP com tamanho máximo de 800px." Cada item é independente. Não tem revisão necessária entre eles. O resultado de um não muda o input do próximo. É exatamente o tipo de trabalho que o Mechanical Turk da Amazon foi desenhado pra distribuir. Frontier models já fazem isso sozinhos sem precisar de orquestração explícita: você pede pro Opus 4.7 traduzir 100 documentos, e ele dispara em batches paralelos pelo `Task` tool, escala ou não escala conforme tem trabalho.

**Trabalho onde frontier model não delega, porque não dá pra delegar bem:** tarefas com muitas dependências, exigindo revisão constante, ajuste mútuo. Construir um app Rails é exatamente isso. A model do `Chat` depende da decisão do `LlmClient`, que depende da config do RubyLLM, que depende do `OPENROUTER_API_KEY` no env, que depende do `ENV` ser carregado antes do initializer, que depende do Gemfile ter o gem certo. Mudar qualquer peça obriga a revisar várias outras. Isso não é trabalho de Mechanical Turk. É trabalho coeso de engenharia, e modelos Tier A reconhecem isso e mantêm tudo em uma sessão de raciocínio. **É por isso que zero dos 7 runs da rodada 1 delegou: a tarefa não era delegável.**

### A analogia com programação assíncrona

Quem aprendeu async/await numa linguagem moderna passou pela mesma desilusão. Você descobre `Promise.all`, `asyncio.gather`, ou similar, e olha pra todo trabalho lento procurando como paralelizar. Aí escreve algo tipo isso e fica bravo:

```javascript
// Cadeia sequencial: cada passo depende do resultado do anterior
const userData = await fetchUser(userId);
const orders = await fetchOrdersFor(userData);          // ← precisa de userData
const recommendations = await analyzeOrders(orders);    // ← precisa de orders

// Latência total = latência(fetchUser) + latência(fetchOrders) + latência(analyze)
```

Três `await`s. Três operações de I/O. Você esperava 3× mais rápido por colocar em async. Mas continua igual ao síncrono porque **cada chamada depende do resultado da anterior**. Tentar embrulhar isso em `Promise.all` nem compila: você não pode passar `userData` pra `fetchOrdersFor` antes de ter `userData`.

Promise.all só ajuda quando as chamadas são **independentes umas das outras**:

```javascript
// Calls independentes: nenhuma usa o resultado da outra
const [user, allProducts, categoryTree] = await Promise.all([
  fetchUser(userId),       // ← não precisa de products nem categories
  fetchAllProducts(),      // ← não precisa de user nem categories
  fetchCategoryTree()      // ← não precisa de user nem products
]);

// Latência total = max(latência das três), não a soma
```

**A diferença não é sintaxe; é estrutura de dependência.** No primeiro caso, A → B → C: três operações em série, cada uma esperando a anterior. No segundo caso, A | B | C: três operações independentes que disparam ao mesmo tempo e a latência total é a da mais lenta. Async/Promise.all não cria paralelismo, só **expõe** o paralelismo que já existia na estrutura do problema.

Multi-agente em coding é a mesma coisa. Se você dá pra dois modelos uma tarefa coesa com dependências internas (construir um app Rails de chat), o "planner" precisa ler cada output do "executor" antes de decidir o próximo dispatch, e o executor precisa do contexto que o planner construiu. Os dois acabam sequenciais. **Pior**: você adicionou overhead de coordenação (formato do prompt, parsing da resposta, watchdog, retry logic) num pipeline que era pra ser de baixo overhead. É como se você pegasse o código com três `await`s sequenciais e ainda colocasse uma fila de Redis no meio: agora você tem 3× a latência **mais** o custo da fila.

Tarefa paralelizável = "aplica o mesmo refactor em 50 arquivos diferentes". Aí orquestrar faz sentido: um modelo planeja o refactor uma vez, descreve em forma reusável, e despacha 50 sub-agentes em paralelo pra executar em cada arquivo. Ganho real de tempo. **Tarefa sequencial com dependências** = construir um app coeso. Aí não há paralelização possível, e adicionar agentes só adiciona overhead.

Esse benchmark testa o **segundo cenário**. Se o seu trabalho diário é o primeiro (lotes grandes de tarefas independentes), as conclusões aqui podem inverter. Adapta o harness, mede, decide.

---

## Segmento 1: a rodada inicial, modelos não delegaram

A primeira rodada, em meados de Abril, configurou 7 variantes onde o planner tinha um sub-agente registrado disponível e linguagem agressiva de prompt incentivando delegação ("Use PROACTIVELY", "ALWAYS delegate to this agent for code implementation"). A pergunta: dado que o sub-agente existe e tá pintado como o caminho preferido, o modelo principal vai delegar?

| Variante | Harness | Tempo | Custo | Delegações | Tier |
|---|---|---:|---:|---:|---:|
| `claude_opus_alone` | Claude Code | 11m | $6.74 | 0 | 3 |
| `claude_opus_sonnet` | Claude Code | 10m | $5.13 | 0 | 2 |
| `claude_opus_haiku` | Claude Code | 15m | $7.83 | 0 | 3 |
| `opencode_opus_glm` | opencode | 19m | ~$1.10 | 0 | 1 |
| `opencode_opus_qwen` | opencode | 30m | ~$1.10 | 0 | 1 |
| `gpt_5_4_multi_balanced` | Codex | 21m | ~$11 | 0 | 1 |
| `gpt_5_4_multi_faster` | Codex | 20m | ~$10 | 0 | 2 |
| **baseline** `claude_opus_4_7` | opencode | 18m | ~$1.10 | n/a | **1** |

**Zero delegações em zero das 7 variantes.** O `Task` tool do Claude Code, o task dispatcher do opencode e o `spawn_agent` do Codex foram completamente ignorados. Em todos os casos, o modelo principal fez 100% do trabalho.

Duas coisas pra registrar dessa rodada.

**Primeira:** prompt agressivo não convence modelo a delegar. "Use PROACTIVELY" é uma palavra fraca contra o instinto interno do modelo de "essa tarefa é coesa, vou fazer junto". Em greenfield Rails, plano e implementação não têm linha clara. Não tem tarefa atomicamente delegável.

**Segunda, e mais surpreendente:** o mesmo Opus 4.7 escreveu **código pior no Claude Code do que no opencode**, e custou **4 a 7× mais** ($6.74 vs $1.10). Duas das três variantes em Claude Code alucinaram um método de RubyLLM que não existe (alucinação Tier 3); o opencode com o mesmo modelo acertou a API e ficou Tier 1. O harness em si influencia o output. Claude Code reenvia muito mais contexto por turno, e isso parece empurrar o modelo pra padrões genéricos enquanto também infla a conta.

Conclusão da rodada 1: **se o modelo já tá entregando Tier A solo no harness certo (opencode), adicionar sub-agente nem é usado.** A configuração extra é puro overhead. E se você forçar em Claude Code, paga 4-7× mais. A "economia" da multi-agência aqui é negativa.

---

## Segmento 2: rodada forçada, quando o planner é proibido de codar

A comunidade reclamou da rodada 1: "a description do sub-agente foi fraca", "modelos não confiam em sub-agente que não conhecem". OK, contestação justa. Rodada 2: prompt explícito de planner-executor. **O planner é literalmente proibido** de usar `Write`/`Edit`/`Bash`. Toda mudança de código tem que passar pelo sub-agente via `Task` ou `spawn_agent`. Sem fallback.

O prompt completo tá em [`prompts/benchmark_prompt_forced_delegation.txt`](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/prompts/benchmark_prompt_forced_delegation.txt). Workflow obrigatório: `plan → delegate → converge → validate`. Sete variantes:

| Slug | Planner | Sub-agente | Harness |
|---|---|---|---|
| `claude_opus_sonnet_forced` | Opus 4.7 | Sonnet 4.6 | Claude Code |
| `claude_opus_haiku_forced` | Opus 4.7 | Haiku 4.5 | Claude Code |
| `opencode_opus_kimi_forced` | Opus 4.7 | Kimi K2.6 | opencode |
| `opencode_opus_glm_forced` | Opus 4.7 | GLM 5.1 (Z.ai) | opencode |
| `opencode_opus_qwen_forced` | Opus 4.7 | Qwen 3.6 Plus | opencode |
| `gpt_5_4_multi_balanced_forced` | GPT 5.4 xHigh | GPT 5.4 medium | Codex |
| `gpt_5_4_multi_faster_forced` | GPT 5.4 xHigh | GPT 5.4 low | Codex |

Resultados:

| Variante | Score | Tempo | Custo | Tier | vs solo Opus (97) |
|---|---:|---:|---:|:---:|---:|
| `claude_opus_sonnet_forced` | 92 | 25m | $5.77 | A | -5 |
| `claude_opus_haiku_forced` | 90 | 19m | $3.49 | A | -7 |
| `opencode_opus_kimi_forced` | 95 | 25m | ~$2-3 | A | -2 |
| `opencode_opus_glm_forced` | 93 | 13m | ~$0.50 | A | -4 |
| `opencode_opus_qwen_forced` | 92 | (variável) | ~$0.50 | A | -5 |
| `gpt_5_4_multi_balanced_forced` | 94 | 30m | ~$1-3 | A | -3 |
| `gpt_5_4_multi_faster_forced` | 94 | 53m | ~$3-6 | A | -3 |

Forçando, **agora tem delegação real** (5 a 15 dispatches por run). Todos os Tier A em qualidade de código (90-95). Mas o ponto importante é: **nenhum bate o solo Opus 4.7 em qualidade.** Todos custam tempo extra (mínimo +7 minutos, até +35 minutos no caso do `multi_faster`). E em custo bruto (pay-as-you-go), só dois ficam abaixo do solo: o GLM (Z.ai assinatura, então quase de graça) e o GPT 5.4 multi (que sai bem mais barato que GPT 5.4 solo, mas ainda na casa do Opus solo).

Nessa rodada teve duas descobertas técnicas embaraçosas no harness. Uma foi um watchdog cedo demais que matava o benchmark antes do sub-agente cross-provider terminar de inicializar (Z.ai e llama-swap demoravam mais que o esperado pra subir). Aumentei o timeout de 6 pra 15 minutos e GLM/Qwen voltaram a Tier A. A outra: vários modelos pareciam "executar em silêncio" (envelopes de resultado vazios). Só descobri na rodada 3 que a maioria desses casos era erro escondido — endpoint do `qwen3.6-plus:free` tinha sido depreciado e retornava 404, e o DeepSeek tava 400-erroring com bug de protocolo (detalhes na seção dele mais adiante). Os "1900 arquivos" do `opencode_opus_deepseek_forced` foram **inteiramente** escritos pelo `general` fallback do Opus, não pelo DeepSeek.

OK, então corrigindo as falhas de harness, a história fica:

- **Sonnet/Haiku coders em Claude Code:** 90-92 vs Opus solo 97. Custa +1 minuto a +7 minutos. Custa ~igual ou mais.
- **Kimi K2.6 em opencode:** 95 vs 97. Custa $2-3 vs $4, ou seja, 25-50% de economia. +7 minutos.
- **GLM 5.1 em opencode:** 93 vs 97. Custa ~$0.50 com assinatura Z.ai (quase de graça) vs $4 do Opus solo. -5 minutos.
- **GPT 5.4 + medium:** 94 vs 97. Custa ~$1-3 vs $16 do GPT 5.4 solo (80-85% mais barato). +12 minutos.

A última é a única configuração onde delegação forçada **realmente vale a pena em custo absoluto**: se você precisa estar no GPT 5.4, o multi-agente forçado é uma economia real. Em todos os outros casos, você paga em qualidade e/ou tempo pra usar um sub-agente mais barato. Em assinatura mensal Anthropic Pro, o Opus solo é $0 marginal. Tem zero motivo pra usar Sonnet/Haiku como sub. O multi-agente forçado é teatro.

E uma última coisa nessa rodada: a "lição da exceção", quando o multi-agente forçado **conserta** o Claude Code. Solo Opus em Claude Code ficou Tier 3 (alucinou `chat.complete`) com $6.74. Forçar Sonnet/Haiku como executor em Claude Code consertou pra Tier A com $3.49-5.77. Mas a correção mais limpa é **trocar de harness**, não orquestrar. Solo Opus em opencode dá Tier A em $4 sem complicação. A "orquestração conserta Claude Code" é contorno pra um bug de outro lugar.

---

## Segmento 3: orquestração manual cross-process, Opus dirigindo opencode

A terceira rodada foi a mais elaborada. Premissa: tirar o sub-agente do mesmo processo do planner (que é onde tava o bug `task` envelope) e usar opencode em modo single-agent invocado por subprocess pra cada subtask. O setup foi uma sessão Claude Code com Opus 4.7 no papel de orquestrador. Pra cada subtarefa, o Opus escrevia o prompt num arquivo, invocava opencode via Bash com o modelo barato como único primary, lia a saída, e decidia o próximo dispatch.

Sem fallback. Sem o `general` agent disponível pro Opus escapar. **Ou o executor nomeado escreve, ou ninguém escreve.**

Três variantes tentadas:

### Opus + Qwen 3.6 Plus (Variante 1): 94/100 Tier A

Setup: 8 dispatches + 1 ajuste = 9 dispatches no total. ~$0.74 de custo de executor. ~12 minutos cumulativos de wall time **só do executor**. Mais o overhead do planner (Opus em Claude Code orquestrando) que não é diretamente medido mas é estimado em $11 (mais sobre isso adiante).

Comportamento do Qwen 3.6 Plus como executor: trunca o resumo final em 3 de 9 dispatches, às vezes emite zero texto mas faz muita tool call (dispatch 8: 14 tool calls, 0 turnos de texto), faz adaptações inteligentes sozinho (criou `app/javascript/` à mão depois que o Rails 8.1 não gerou, trocou `root_url` por `get "/"`, criou tailwind.css placeholder). Mas precisou de 2 dispatches de ajuste pra problemas causados por mudanças de generator do Rails 8.1.

Leitura do auditor: *"Qwen escreveu as linhas, Opus decidiu os limites, e os limites são a maior parte do que tira isso de B pra A."*

Resultado: **94/100 Tier A. +23 pontos sobre Qwen 3.6 Plus solo (71/100, Tier B).** Mas o ganho inteiro vem do plano detalhado do Opus, não da capacidade autônoma do Qwen.

### Opus + Kimi K2.6 (Variante 2): 97/100 Tier A, EMPATA OPUS SOLO

Setup: 5 dispatches, **zero ajustes**. ~$0.37 de custo de executor. ~10 minutos cumulativos de wall time do executor. Validação completa end-to-end (boot local, docker compose up + curl + teardown limpo).

Comportamento do Kimi K2.6: resposta de texto coerente em cada dispatch sem truncar, adaptação autônoma forte (pegou Stimulus + Tailwind install gaps sem prompt explícito, pegou efeito colateral do `tailwindcss:install` envolvendo o layout), zero dispatches de ajuste.

Resultado: **97/100 Tier A. EMPATA Opus 4.7 solo.** Leitura do auditor: *"Kimi escreveu cada linha, mas as instruções de plano do Opus moldaram o que pedir (fixtures de teste melhores, cobertura de error path, design de persistência), empurrando Kimi de 87 → ~97."*

### Opus + DeepSeek V4 Pro (Variante 3): FALHOU

Bug estrutural de incompatibilidade harness. DeepSeek V4 Pro retorna `reasoning_content` em toda resposta, e opencode strippa esse campo na construção da próxima request. A API do DeepSeek então rejeita o turno 2 com `"reasoning_content must be passed back to the API"`. Testei três configs de `reasoning` (`true`, `false`, ausente). Todas falharam identicamente no turno 2 do dispatch 1. Não tem flag em opencode que conserte. Workarounds (param custom no provider OpenRouter, single-bash-per-dispatch, trocar pra V4 Flash) não foram perseguidos.

Implicação retroativa: as supostas "completions" do DeepSeek nas rodadas 2 e 2.5 foram **inteiramente** escritas pelo Opus via fallback `general`. DeepSeek V4 Pro contribuiu zero linhas de código em qualquer configuração desse benchmark até hoje.

### O custo escondido do planner

Aqui é onde a coisa fica feia. As duas variantes manuais que rodaram (Qwen e Kimi) tiveram **~14 dispatches bem-sucedidos no total**. Cada dispatch consumiu ~3-5 turnos do Opus orquestrador (ler saída do dispatch anterior, planejar próximo, escrever arquivo de prompt, monitorar execução, verificar filesystem). Cada turno custa ~$0.15-0.25 em token Anthropic. Total: **~$11 de custo escondido do planner**, não logado no executor JSON.

Custo total real das duas variantes manuais: ~$1.11 de executor + ~$11 de planner = **~$12 combined**. Comparado com solo Opus opencode em $4. **Manual orchestration custa 3× mais que solo.**

### O que essa rodada efetivamente prova

| Executor | Score solo | Ganho sob orquestração Opus |
|---|---:|---:|
| GLM 5.1 | 46 (Tier C) | +47 → 93 (Tier A) [via in-process forced 2.5] |
| Qwen 3.6 Plus | 71 (Tier B) | +23 → 94 (Tier A) [via manual orquestração] |
| Kimi K2.6 | 87 (Tier A) | +10 → 97 (Tier A, empata Opus) [via manual orquestração] |

**O ganho escala inversamente com a capacidade solo do executor.** Quanto mais distante o solo do Tier A, mais a orquestração adiciona. Kimi solo já é Tier A, então o +10 é polish (fixtures de teste melhores, cobertura de error path, persistência). GLM solo é Tier C por uma alucinação específica (fluent DSL inventada), e prompts prescritivos que nomeiam a API real removem a alucinação inteira.

**Mas o custo desse ganho é dominado pelo planner.** Se você só tem GLM acessível (não Opus), esse achado não te ajuda. Se você tem Opus E GLM, usa Opus solo por menos dinheiro e menos tempo.

O caso de uso realista pra essa pattern é: **deployment multi-tenant onde o planner roda uma vez e amortiza em muitas subtarefas similares** (tipo "aplica esse mesmo refactor em 50 arquivos diferentes"). Greenfield Rails benchmark não captura isso.

---

## Comparação final: as 3 rodadas vs solo

Todos os custos abaixo são **totais (planner Opus + executor)** em pay-as-you-go. Wall times end-to-end:

| Variante | Score | Wall time | Custo total | Δ qualidade vs solo (97) | Δ custo vs solo ($4) | Δ tempo vs solo (18m) |
|---|---:|---:|---:|---:|---:|---:|
| **Opus 4.7 solo (opencode)** | **97** | **18m** | **$4.04** | baseline | baseline | baseline |
| Opus + Kimi (manual) | 97 | 30-40m | ~$5-7 (planner ~$5 + executor $0.37) | =0 | +$1 a +$3 | +12-22m |
| Opus + Sonnet 4.6 (CC, forced) | 92 | 25m | $5.77 (Claude Code log) | -5 | +$1.73 | +7m |
| Opus + Haiku 4.5 (CC, forced) | 90 | 19m | $3.49 (Claude Code log) | -7 | -$0.55 | +1m |
| Opus + Kimi (in-process forced) | 95 | 25m | ~$3-4 (planner ~$2-3 + executor ~$0.50) | -2 | -$1 a 0 | +7m |
| Opus + GLM 5.1 (forced, watchdog fix) | 93 | 13m | ~$0.50 + Z.ai sub | -4 | -$3.50 + sub | -5m |
| Opus + Qwen 3.6 (manual) | 94 | ~40m | ~$6-7 (planner ~$5 + executor $0.74) | -3 | +$2 a +$3 | +22m |
| GPT 5.4 xHigh + medium (Codex forced) | 94 | 30m | ~$1-3 (Codex log, ambos GPT) | -3 | -$1 a -$3 | +12m |
| GPT 5.4 xHigh + low (Codex forced) | 94 | 53m | ~$3-6 (Codex log, ambos GPT) | -3 | -$1 a +$2 | +35m |

(Tier D / 0-arquivos omitidos.)

O custo do planner Opus orquestrador na linha "Opus + Kimi (manual)" e "Opus + Qwen (manual)" é um custo **escondido**: ele aparece na sessão Claude Code que dirigia o experimento, não no log do executor. As ~14 dispatches bem-sucedidas das duas variantes manuais combinadas consumiram ~$11 de Opus, divididos entre as duas, resultando em ~$5-6 cada.

**Solo Opus 4.7 em opencode é o melhor em todas as métricas:** ele empata ou bate cada outra variante em qualidade, custo OU tempo, e empata ou bate a maioria em todas as três simultaneamente.

A única exceção real é **Codex GPT 5.4 xHigh + medium executor**: 94/100 vs 97/100 (perde 3 pontos), mas custa $1-3 em vez de $16 do GPT 5.4 solo (80-85% mais barato). Útil se você só tem credenciais de OpenAI e precisa de Tier A barato.

Toda outra variante perde em pelo menos uma dimensão importante. A maioria perde em duas (qualidade E tempo, ou qualidade E custo).

---

## A questão da assinatura

Os números acima são **pay-as-you-go**. Vamos botar assinatura na conta.

Anthropic Pro a $200/mês inclui Opus 4.7 com [quota 20× maior que o Plus](https://help.openai.com/en/articles/20001106-codex-rate-card) — na prática, vários runs do benchmark inteiro por dia sem encostar no teto. OpenAI Plus a $20/mês ou Pro a $200/mês inclui Codex CLI com a mesma economia. Em assinatura, **um run do benchmark adiciona zero custo marginal** até saturar a quota.

O que isso muda?

- Solo Opus 4.7: $4 pay-as-you-go vira $0 marginal em Anthropic Pro. **Continua sendo o melhor.**
- Multi-agent com Sonnet/Haiku via Claude Code: $3.49-5.77 vira $0 marginal em Anthropic Pro. Ainda perde 5-7 pontos de qualidade. **Não vale.**
- Multi-agent com Kimi/GLM/Qwen via opencode (que cobra à parte do OpenRouter): adiciona $0.50-3 de custo de OpenRouter por cima da assinatura. Perde 2-7 pontos de qualidade. Tempo igual ou maior. **Não vale.**
- Codex GPT 5.4 + medium: $1-3 vira $0 marginal em ChatGPT Pro. Mas solo GPT 5.4 também vira $0 marginal. **Multi não vale.**
- Manual cross-process (Opus dirigindo opencode com Kimi): $0 marginal (planner em Anthropic Pro) + $0.37 (executor em OpenRouter pago) = $0.37. Custa 30-40 minutos vs 18 do solo. **Empata em qualidade. Não vale.**

Em assinatura, **nenhuma configuração multi-agente bate o solo do frontier model.** O custo marginal de uma chamada extra é zero pra quem já paga a assinatura mensal. Coordenação extra não compensa quando o "savings" é zero.

---

## O caso menos ruim: Opus + Kimi K2.6 sob uso intenso

Já que tô sendo cético em todas as conclusões, vale registrar separado a única configuração não-óbvia onde Opus + Kimi K2.6 pode fazer sentido na prática: **uso contínuo e pesado que já saturou a cota mensal da assinatura Anthropic Pro.**

Em modo forçado in-process (Round 2.5 com watchdog ajustado), Kimi K2.6 entrega 95/100 contra os 97 do Opus solo. Os 2 pontos de diferença geralmente são polish em fixtures de teste e error handling, coisas que dá pra patchar depois. Em troca, você paga ~$2-3 de OpenRouter no Kimi em vez de queimar quota Pro do Opus. Pra power user que tá batendo no teto dos $200/mês de Pro com frequência (várias vezes por semana, projetos paralelos pesados), redirecionar parte do trabalho pro Kimi pode liberar quota Pro pras tarefas que mais exigem do Opus.

É exceção estreita. Pra a maioria das pessoas que ainda não saturou Pro, continua sendo melhor usar o Opus sozinho. E pra quem não tem Pro ainda, a economia de orquestrar Kimi + Opus vai ser igual ou menor do que assinar Pro de uma vez. Mas pro cenário "estou usando coding agent profissional pesado e já estouro quota mensal", a configuração Opus planner + Kimi executor é a melhor opção que medi nesse benchmark.

Vale mencionar também o caso de **multi-tenant onde o planner é amortizado**: se você tá rodando uma pipeline que aplica o mesmo padrão de mudança em muitos projetos similares (refatorar 50 repos pra usar nova convenção, gerar 30 micro-serviços com mesmo skeleton), Opus planeja uma vez, salva o plano, e Kimi executa em cada projeto. Aí o custo do planner se dilui em volume e o pareamento ganha sentido econômico real.

---

## Por que DeepSeek foi o modelo mais difícil de testar

Vale registrar separado, porque é o caso mais frustrante de todo o benchmark. DeepSeek V4 Pro **nunca contribuiu uma única linha de código** em nenhuma das três rodadas multi-agente, apesar de aparecer em vários experimentos como "completed".

A causa raiz é uma incompatibilidade de protocolo entre a API do DeepSeek e o ai-sdk que o opencode usa por baixo. O DeepSeek V4 Pro roda thinking mode por default. Toda resposta que ele devolve inclui um campo `reasoning_content` com a cadeia de raciocínio interna do modelo. **A API do DeepSeek então exige que esse `reasoning_content` seja ecoado de volta no histórico de mensagens da próxima request.** Sem isso, o servidor responde com 400 e essa mensagem específica:

> `The "reasoning_content" in the thinking mode must be passed back to the API.`

O ai-sdk do opencode, na construção das próximas requests, **strippa o `reasoning_content`** do histórico de mensagens. Toda chamada multi-turn pra DeepSeek V4 Pro via opencode falha no turno 2.

O que torna isso invisível em superfície é que opencode não levanta esse 400 até o usuário. Ele soterra o erro no event stream e segue. Quando você olha o resultado da run, vê arquivos sendo escritos e tarefas sendo "completas". Mas se você inspeciona o trace, descobre que a maior parte (ou tudo) saiu do `general` fallback agent, que é o Opus 4.7 mesmo. O DeepSeek que devia estar fazendo o trabalho não escreveu nada.

Eu testei três configurações de `reasoning` em opencode (`true`, `false`, ausente). Todas falharam idêntico no turno 2 do dispatch 1. Não tem flag em config que conserte. Workarounds que ficaram fora do escopo:

- Custom OpenRouter provider params via header
- Protocolo single-bash-per-dispatch (que driblaria o multi-turn)
- Trocar pra DeepSeek V4 Flash, que não usa thinking mode

Isso obriga uma correção retroativa nas conclusões anteriores. Em [um post anterior](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) eu descrevi DeepSeek V4 Pro como tendo "código Tier 1, mas DNF no harness". A descrição era incompleta. **DeepSeek V4 Pro é fundamentalmente incompatível com qualquer harness baseado em ai-sdk** (que inclui opencode, e provavelmente várias outras ferramentas que usam o mesmo SDK por baixo dos panos). O modelo pode escrever bom código solo se você invocar API direta com handling de thinking mode. Mas em qualquer pipeline real de coding agent que use ai-sdk, ele não funciona em multi-turn.

O resultado prático: DeepSeek V4 Pro não é mensurável nesse benchmark. As únicas configurações onde ele apareceu como "successful" tinham Opus escrevendo no lugar dele. Pra benchmarks futuros, vou ou trocar pra V4 Flash (que evita thinking mode) ou montar um harness customizado que faça o echo de `reasoning_content` corretamente.

A lição mais geral é: **a maturidade de tooling em volta de um modelo importa tanto quanto a qualidade do modelo.** DeepSeek V4 Pro pode ter código excelente solo, mas se você não consegue usar ele sem escrever harness próprio, ele perde pra Kimi K2.6 que funciona out of the box.

---

## Conclusão

Multi-agente em coding agent contínuo é **otimização prematura disfarçada**. Você gasta fim de semana montando orquestração de cinco modelos, cinco harnesses, cinco token contadores diferentes, pra chegar num resultado que é igual ou pior que solo Opus em opencode. E pior: enquanto você fica orquestrando, você não tá entregando produto.

Os dados:

- Frontier model solo (Opus 4.7 em opencode) entrega **Tier A 97/100 em 18 minutos por $4 pay-as-you-go**.
- Tentar multi-agente sem forçar: o modelo não delega, você paga overhead do harness pra nada.
- Forçar multi-agente: equivalente quality em mais tempo e custo igual ou maior. Única exceção real é Codex com GPT 5.4 + medium pra cortar custo do GPT.
- Orquestração manual cross-process: empata em qualidade no melhor caso (Opus + Kimi → 97), mas dobra o wall time e triplica o custo total quando você conta o planner.
- Em assinatura mensal: o custo marginal de chamada extra é zero pro frontier solo. Multi-agente não tem vantagem econômica.

A regra prática: **escolhe um frontier model bom (Opus 4.7, GPT 5.5, GPT 5.4 xHigh), usa num harness maduro (opencode é o que mais respeita o modelo, Codex é o oficial pra GPT, Claude Code se você aceita a poluição de contexto), e otimiza prompt em vez de orquestração.** Os modelos atuais já decidem sozinhos quando dividir uma tarefa em sub-tarefas paralelas (Claude Code tem `Task` tool, Opus usa quando precisa). Não precisa forçar.

E pra fechar o argumento da assinatura: **$20-200 por mês é trivial.** É menos do que a maioria das pessoas gasta em curso online ruim, em assinatura de streaming, ou em fim de semana de balada. Em uso profissional sério, isso paga 5-10× só no primeiro uso real. Se "$200/mês" parece muito, o problema não é o LLM, é o ROI do que você tá construindo. Que é exatamente onde você deveria estar focando antes de orquestrar agentes pra cortar $30 de token.

Foco em entregar. Otimização de token vem depois.

---

## Fontes

- [Repo do benchmark](https://github.com/akitaonrails/llm-coding-benchmark) — código, prompts, configs, todos os logs
- [Round 1 multi-model report](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.multi_model.md) — 7 variantes free-choice, zero delegações
- [Round 2 forced-delegation audit](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.multi_model_forced.md) — 7 variantes forçadas, 0-100 rubrica
- [Round 3 manual orchestration](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.manual_orchestration.md) — Opus dirigindo opencode em subprocess, Kimi/Qwen/DeepSeek
- [Orchestration traces](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/orchestration_traces.md) — forensic walkthroughs por variante
- [Forced-delegation prompt template](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/prompts/benchmark_prompt_forced_delegation.txt)
- [Canonical benchmark (Abril 2026)](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) — solo runs de 23 modelos, rubrica 8 dimensões
- [Vibe code: do zero à produção em 6 dias](/2026/02/16/vibe-code-do-zero-a-producao-em-6-dias-the-m-akita-chronicles/) — full immersion na prática
- [Como falar com Claude Code efetivamente](/2026/04/15/como-falar-com-o-claude-code-efetivamente/) — role-play como PM/QA
- [Clean Code pra agentes de IA](/2026/04/20/clean-code-para-agentes-de-ia/) — guia de instruções pro modelo
