---
title: "LLM Benchmarks Parte 2: Vale Combinar Múltiplos Modelos no Mesmo Projeto? Claude + GLM??"
date: '2026-04-18T14:00:00-03:00'
draft: false
translationKey: llm-benchmarks-part-2-multi-model
tags:
  - llm
  - benchmark
  - claude
  - ai
  - vibecoding
---

> ⚠️ **Artigo obsoleto (atualização de 2026-04-24).** As conclusões e rankings desse artigo foram superados depois do re-audit contra o gem `ruby_llm`. A descoberta principal (multi-model não vale pra coding greenfield) se mantém e foi integrada no post canônico. **A versão canônica está em [Benchmark de LLMs pra Coding (Abril 2026)](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/).** Esse artigo fica aqui como registro histórico.

---

**TL;DR:** Sim, o título é clickbait. A resposta é não, não vale. Continue usando Claude Code com Opus 4.6 ou 4.7. Detalhes abaixo.

---

Escrevi algumas semanas atrás um [benchmark detalhado de LLMs pra coding](/2026/04/05/testando-llms-open-source-e-comerciais-quem-consegue-bater-o-claude-opus/) comparando 33 modelos open source e comerciais num mesmo teste: construir um app Rails com RubyLLM. A conclusão foi que só 4 modelos geraram código que funciona de primeira (os dois Claudes, GLM 5 e GLM 5.1), e que pra quem não quer perder tempo corrigindo alucinação de API, Claude Opus via Claude Code continua sendo a escolha mais racional apesar do preço.

Esse artigo é continuação. Vou manter aquele benchmark atualizado à medida que modelos novos saem (Opus 4.7, Qwen 3.6, GPT 5.4 via Codex já entraram), e esse aqui aborda uma pergunta diferente que aparece toda semana no meu feed: **e se eu combinar dois modelos no mesmo projeto? Opus pra planejar, GLM pra executar. Dá certo?**

A resposta curta é não, não dá. A resposta longa é o resto desse artigo.

## Antes: uma palavra sobre Opus 4.7

Tem gente no Reddit dizendo que Opus 4.7 é um downgrade absurdo do 4.6, que regrediu, que "piorou pra coding". Fico desconfiado sempre que vejo essa narrativa de "tá tudo ficando pior". Eu tenho centenas de horas com Opus 4.6 e venho testando o 4.7 desde que saiu há poucos dias, e a qualidade tá igual ou melhor que 4.6 em tarefas não-triviais onde eu tenho referência de como o 4.6 se comportava.

Quando você vê alguém reclamando que "4.7 tá horrível", peça o prompt exato, o repo, o contexto. Na maioria das vezes a pessoa não consegue reproduzir, ou o repo tem CLAUDE.md mal escrito, ou o task é subjetivo demais pra ter métrica. "Senti que ficou pior" não é dado. Eu mesmo fui pego por essa sensação em uma sessão do Opus 4.7 que tinha contaminado o contexto com muita documentação desatualizada, e o culpado era minha config, não o modelo.

Nos benchmarks que rodei esta semana, Opus 4.7 no opencode entregou Tier 1 limpo, mesmo nível do Opus 4.6 baseline. Vou mostrar abaixo que nos testes que ele rodou via Claude Code aconteceu uma coisa mais estranha, e aí a culpa provavelmente é do harness, não do modelo. Fica o recado.

## O que foi feito de novo no benchmark

O [benchmark](https://github.com/akitaonrails/llm-coding-benchmark) ganhou suporte pra testar combinações de modelos nos três harnesses principais:

1. **Claude Code** (`claude -p --output-format stream-json`) — suporta sub-agentes declarados em `.claude/agents/*.md` que o Opus pode delegar via ferramenta `Task`
2. **opencode** — tem um sistema próprio de sub-agentes que podem rodar em modelos diferentes
3. **Codex CLI** — ganhou suporte a sub-agentes em TOML via `-c agents.<nome>.config_file=...`

Em cima dessas três plataformas, configurei 7 combinações:

| Runner | Modelo principal | Sub-agente | Ideia |
|---|---|---|---|
| Claude Code | Opus 4.7 | — | Baseline, só Opus sozinho |
| Claude Code | Opus 4.7 | Sonnet 4.6 | Opus planeja, Sonnet executa |
| Claude Code | Opus 4.7 | Haiku 4.5 | Opus planeja, Haiku (menor) executa |
| opencode | Opus 4.7 | GLM 5.1 | Opus + GLM (econômico + bom) |
| opencode | Opus 4.7 | Qwen 3.6 local | Opus + modelo local grátis |
| Codex | GPT 5.4 xHigh | GPT 5.4 medium | Raciocínio alto planeja, menor executa |
| Codex | GPT 5.4 xHigh | GPT 5.4 low | Raciocínio alto planeja, mínimo executa |

Cada um roda o mesmo prompt: construir um app Rails com RubyLLM, Tailwind, Stimulus, Turbo Streams, testes Minitest, Brakeman, RuboCop, Dockerfile, docker-compose. O mesmo prompt do benchmark original.

### Como habilitar multi-model em cada harness

Antes de mostrar o que deu errado, vale entender como cada harness expõe o sub-agente e quem decide chamá-lo. A mecânica é parecida nos três, mas os detalhes importam.

#### Claude Code

Claude Code lê automaticamente arquivos em `.claude/agents/*.md` do diretório do projeto. Cada arquivo é uma definição de agente:

```markdown
---
name: sonnet-coder
description: Claude Sonnet 4.6 for concrete coding execution. Use PROACTIVELY for any code change where the plan is already clear. Opus should plan and delegate; Sonnet should execute. Only skip delegation for cross-file architectural decisions.
model: claude-sonnet-4-6
---

You are a focused coding agent. The parent (Opus) has already decided
the approach — your job is to execute cleanly.

Rules:
- Follow the provided instructions precisely. Don't re-plan.
- Prefer editing existing files over creating new ones.
- Match the existing codebase style.
- Keep changes minimal.
- Default to no comments.
```

O frontmatter YAML tem três campos obrigatórios: `name` (o handle que o modelo principal usa), `model` (qual modelo roda o agente), e `description` (a descrição que o modelo principal lê pra decidir se delega). O corpo do arquivo é o system prompt que o sub-agente recebe quando invocado.

Pra invocar, o Opus usa a ferramenta nativa `Task(subagent_type="sonnet-coder", prompt="...")`. Claude Code cobra tokens no modelo do sub-agente, não no modelo principal.

#### opencode

opencode usa um arquivo de config JSON (pode ser `opencode.json` padrão ou um custom via `--config`). Os agentes ficam numa chave `agents`:

```json
{
  "model": "openrouter/anthropic/claude-opus-4.7",
  "agents": {
    "coder": {
      "model_id": "zai/glm-5.1",
      "provider": "zai",
      "description": "Use proactively for concrete coding execution...",
      "prompt": "You are a focused coding agent. The parent..."
    }
  }
}
```

Cada entrada tem `model_id`, `provider`, `description` e `prompt`. O modelo principal (definido no topo) invoca o agente via ferramenta `task`, passando o nome (`coder` no exemplo) e instruções específicas.

#### Codex CLI

Codex usa arquivos TOML por agente, passados via flags `-c` no comando:

```toml
# .codex-coder.toml
name = "coder"
model = "gpt-5.4"
reasoning_effort = "medium"
description = "Use proactively for concrete coding execution..."
prompt = "You are a focused coding agent. The parent (xhigh)..."
```

E invoca:

```bash
codex exec \
  --dangerously-bypass-approvals-and-sandbox \
  -c model_reasoning_effort=xhigh \
  -c agents.coder.config_file=.codex-coder.toml \
  -p "<prompt principal>"
```

O modelo principal ganha acesso à ferramenta `spawn_agent` pra invocar o `coder`. Codex permite configurar `reasoning_effort` diferente entre principal e sub-agente, que é justamente o que os dois variants `multi_balanced` e `multi_faster` testam.

### Quem decide qual modelo roda cada tarefa

Nos três harnesses, a decisão de delegar é tomada pelo **modelo principal em tempo de execução**, não por regra programática. Não tem heurística determinística do tipo "se o arquivo é maior que X linhas, chame o sub-agente". O que existe é o modelo principal lendo a descrição do sub-agente e julgando, a cada passo, se a tarefa atual se encaixa.

Isso significa três coisas:

1. **A descrição do sub-agente é o único botão de controle**. Se você escreve "use PROACTIVELY for X" sem caveats, o modelo tende a delegar mais. Se você bota "skip for Y", ele tende a não delegar em Y.

2. **O modelo principal é conservador por default**. Em todos os três, o treinamento atual favorece não delegar quando a tarefa exige contexto cross-file ou decisão arquitetural. Greenfield Rails app é exatamente esse tipo de tarefa.

3. **Não dá pra forçar delegação via config**. Você pode escrever uma descrição agressiva, mas se o modelo julgar que a tarefa não se encaixa, ele ignora. Não tem flag tipo `--force-subagent` nos três harnesses. A decisão é do modelo, não do operador.

Isso é importante pra entender o resultado que vem a seguir.

## A descoberta que mata o argumento

Abri os logs de cada run esperando ver delegação acontecendo. Tools como `Task` (Claude Code) ou `spawn_agent` (Codex) deviam aparecer no ndjson cada vez que o modelo principal chamasse o sub-agente.

Em 7 runs, **a ferramenta de delegação foi chamada zero vezes**. Nenhum Opus chamou o Sonnet. Nenhum Opus chamou o Haiku. Nenhum Opus chamou o GLM 5.1 ou o Qwen 3.6 local. Nenhum GPT xHigh chamou o GPT medium ou low.

Todos os modelos principais fizeram o trabalho inteiro sozinhos, ignorando o sub-agente que estava registrado e visível pra eles. Os sub-agentes foram lidos, parseados, listados, e nunca invocados. É como contratar um assistente e deixar ele sentado na mesa o dia inteiro enquanto você faz tudo.

Por que isso aconteceu? Acho que tem duas camadas de explicação.

### A parte técnica

Os modelos principais liam a descrição dos sub-agentes e decidiam que a tarefa não se encaixava. As descrições tipicamente diziam "use proativamente pra executar código concreto" com uma ressalva "evite pra decisões arquiteturais cross-file". Só que um app Rails inteiro é decisão arquitetural cross-file. Controller depende de service, service depende de initializer, view depende de partial, todos dependem de como os testes fazem mock do LLM. Não tem parte isolada que dê pra passar pro coador menor sem perder contexto.

Eu poderia ter escrito a descrição do sub-agente com tom mais imperativo, forçando delegação. Mas isso seria trapacear pra conseguir um resultado. O ponto do teste é ver o que o modelo faz livremente, não o que ele faz forçado. E livremente, ele não delegou.

### A parte de gestão

Delegação tem custo de coordenação. Isso é conhecimento básico de project management, não é novidade. Quando você terceiriza uma tarefa, você tem que:

- Escrever especificação clara pro outro executor
- Aguardar o resultado
- Revisar
- Pedir ajustes se tiver diferença entre o que você queria e o que veio
- Reintegrar no resto do trabalho

Com humanos sênior terceirizando pra júniors, esse custo existe e é real. A produtividade não escala linearmente com o número de executores. Dobrar o time não dobra a velocidade. Em muitos casos, a terceirização custa mais tempo do que teria custado fazer sozinho.

Com LLMs acontece a mesma coisa, agravada por uma característica específica: o planejamento do Opus raramente é perfeito de primeira. Nunca é. O Opus lê o prompt, monta um plano, começa a implementar, descobre um problema (biblioteca que não tem aquela versão, método que não existe como ele imaginou, teste que falha por motivo que ele não previu), ajusta o plano, tenta de novo. Esse loop de "planejar → tentar → ajustar" é inerente ao trabalho. Não é uma falha do Opus, é a natureza do desenvolvimento de software.

Agora imagina que você insere um modelo menor na metade desse loop. O Opus planeja, passa pro Qwen executar, o Qwen escreve código que provavelmente alucina API (como vimos no benchmark anterior, Qwen inventa `RubyLLM::Client.new` que não existe), o Opus recebe o código de volta, descobre que tá errado, tem que fazer sub-plano pra corrigir, passa de novo pro Qwen, que inventa outra coisa, e assim vai. O overhead de comunicação e correção explode.

Por isso os próprios modelos, sem serem forçados, decidiram não delegar. Eles sabem que o custo de coordenação é maior que o benefício, especialmente pra uma tarefa coesa como construir um app Rails do zero.

## Comentários por run

Mesmo sem delegação acontecer, os 7 runs deram resultados diferentes. Vou comentar cada um.

### Claude Code: Opus 4.7 sozinho

11 minutos, $6.74, 24 testes, 1742 arquivos. Resultado **Tier 3** (quebrado). O Opus nesse run alucinou o método `chat.complete` do RubyLLM, que não existe, e usou `chat.add_message(role:, content:)` com keyword args em vez de hash posicional. Mesma alucinação típica que outros modelos têm, agora no próprio Opus. Estranho, porque o mesmo Opus 4.7 no opencode entregou código Tier 1 correto no mesmo prompt.

### Claude Code: Opus 4.7 + Sonnet 4.6

10 minutos, $5.13, 18 testes, 1829 arquivos. Resultado **Tier 2** (primeira mensagem roda, multi-turn quebra). Melhor que o baseline do Opus sozinho, mas ainda tem o bug do keyword-args no `add_message`. Zero delegações pro Sonnet.

### Claude Code: Opus 4.7 + Haiku 4.5

15 minutos, $7.83, 34 testes, 1984 arquivos. Resultado **Tier 3**, mesma alucinação do Opus sozinho. O maior volume de testes (34!) todos passam, porque os fakes de teste mockam a API alucinada que o próprio Opus inventou. Testes vazios de significado.

Esse é o ponto que vale sublinhar: Opus 4.7 no Claude Code escreveu 34 testes que passam e nenhum deles prova que o código funciona. A API alucinada é testada contra uma implementação alucinada. No mundo real, o app crasha na primeira mensagem. Contagem de teste é métrica de vaidade quando o mock é errado.

### opencode: Opus 4.7 + GLM 5.1

19 minutos, $1.10, Tier 1 (funciona de primeira). API correta do RubyLLM. Ambas as fases (build + validação com Docker) completaram limpas. Zero chamadas pro GLM 5.1, o Opus fez tudo.

### opencode: Opus 4.7 + Qwen 3.6 local

30 minutos, $1.10 (só Opus cobrado, Qwen local é grátis), Tier 1. Mesma qualidade do anterior. Zero chamadas pro Qwen 3.6 rodando na 5090.

### Codex: xHigh planejando, medium executando

21 minutos, ~$11, Tier 1. A run multi-agent mais cara da lista pelo lado Codex, mas curiosamente foi a que gerou melhor código, e corrigiu o bug do `add_message` que o benchmark anterior tinha encontrado no GPT 5.4 sozinho. Mas zero delegações, todo o trabalho foi do xHigh.

### Codex: xHigh planejando, low executando

20 minutos, ~$10, Tier 2. Voltou a fazer o bug do keyword-args. Mais barato que o anterior mas gerou código pior. Zero delegações pro low também.

## O mesmo modelo, runs diferentes, resultados diferentes

Aqui tá a história real desse benchmark, que fica mais clara quando você agrupa por modelo em vez de por combinação.

Como os sub-agentes não rodaram em nenhum caso, na prática cada combinação "multi-model" virou só mais um run do modelo principal. Isso me deu algo que eu não tinha no benchmark anterior: **múltiplos runs do mesmo modelo no mesmo prompt**. Vou comparar.

### GPT 5.4 xHigh: três runs

No [benchmark da semana passada](/2026/04/05/testando-llms-open-source-e-comerciais-quem-consegue-bater-o-claude-opus/), GPT 5.4 via Codex com xHigh tinha rodado uma vez só, com resultado Tier 2 (primeira mensagem funciona, multi-turn quebra por causa de `chat.add_message(role:, content:)` com keyword args em vez de hash posicional).

Esta semana rodei mais dois, com configurações de sub-agente diferentes (que não foram usadas, mas a presença altera o comportamento do principal, como mostrei acima):

| Run | Tier | Tokens | Custo | API correta? |
|---|---|---:|---:|---|
| xHigh sozinho (semana passada) | 2 | 7.6M | ~$16 | Bug no `add_message` |
| xHigh + medium subagent | 1 | 5.44M | ~$11 | **Corrigiu o bug** |
| xHigh + low subagent | 2 | 4.28M | ~$10 | Bug voltou |

O mesmo modelo, mesmo prompt, três runs. Um deles escreveu `chat.add_message(message)` com hash posicional (Tier 1, funciona em multi-turn). Os outros dois escreveram com keyword args (Tier 2, quebra na segunda mensagem).

Nenhum sub-agente foi chamado nos multi variants. A única coisa que mudou entre os três runs foi o texto da descrição do sub-agente disponível (ou ausência dele). E mesmo assim, aquele GPT 5.4 "acertou" a API numa run e "errou" nas outras duas.

### Claude Opus 4.7: seis runs

Com o Opus foi ainda mais instrutivo. Seis runs diferentes, o mesmo modelo, o mesmo prompt, resultados espalhados entre Tier 1 e Tier 3:

| Run | Harness | Tier | Tempo | Custo |
|---|---|---|---:|---:|
| Opus 4.7 baseline | opencode | 1 | 18.2m | $1.10 |
| Opus 4.7 + GLM 5.1 | opencode | 1 | 10.3m | $1.10 |
| Opus 4.7 + Qwen 3.6 local | opencode | 1 | 19.4m | $1.10 |
| Opus 4.7 sozinho | Claude Code | 3 | 11.0m | $6.74 |
| Opus 4.7 + Sonnet | Claude Code | 2 | 10.1m | $5.13 |
| Opus 4.7 + Haiku | Claude Code | 3 | 14.7m | $7.83 |

As três runs de Opus no opencode: Tier 1 consistente. API correta do RubyLLM, funciona em multi-turn, código limpo.

As três runs de Opus no Claude Code: uma Tier 2 e duas Tier 3. Código que alucinou `chat.complete` (método que não existe) ou errou a assinatura do `add_message`.

Mesmo modelo. Mesmo prompt. Harness diferente = resultado diferente.

### O que isso significa

Duas leituras possíveis:

**A leitura preguiçosa:** "Opus 4.7 no Claude Code regrediu, trocar pro 4.6" ou "opencode é melhor que Claude Code". Ambas seriam conclusões erradas de um benchmark tão pequeno.

**A leitura honesta:** benchmark de um run só, ou mesmo três runs, não é suficiente pra afirmar nada sobre qualidade absoluta de um modelo. A variância é grande, o contexto carregado pelo harness (CLAUDE.md, tool schemas, agent registries) mexe com o "mental model" que o modelo ativa, e o resultado pode oscilar entre tiers.

No benchmark anterior, eu tive a sorte (ou o azar) de ter runs consistentes o bastante pra as hierarquias do tipo "Claude/GLM funcionam, Kimi/DeepSeek/Qwen inventam API" se manterem. Mas mesmo lá, a variância de um run só pra outro é real. Se eu rodar o Kimi K2.5 dez vezes, talvez dois ou três desses runs tenham acertado a API. Não testei isso, mas é plausível.

Esse benchmark reforça o ponto: os rankings do artigo anterior valem como sinal, não como prova. "Funciona de primeira 80% das vezes" é diferente de "sempre funciona". Pra uso em produção, você quer modelo que é robusto à variância, que não tem 20% de chance de voltar alucinação. Hoje, os únicos modelos que me atendem esse critério são Claude Opus e Claude Sonnet, em qualquer harness. GLM 5.1 chega perto mas ainda não tenho sample grande.

Quer dizer que Opus 4.7 "piorou"? Não. Quer dizer que Claude Code "é pior que opencode"? Não. Quer dizer que benchmark de run único sobre greenfield Rails não capta variância de modelo. É importante saber disso antes de tirar conclusões fortes.

## Tempo de execução: multi-model é mais lento?

Vale medir uma pergunta adjacente: se o sub-agente nunca rodou, os runs multi-model foram mais lentos que os baselines sozinhos? Minha intuição inicial era que sim, já que sem paralelismo entre sessões o modelo principal faz o trabalho todo serialmente. O dado conta outra história.

| Run | Tempo |
|---|---:|
| Claude Code Opus alone | 11.0m |
| Claude Code Opus + Sonnet | 10.1m |
| Claude Code Opus + Haiku | 14.7m |
| opencode Opus baseline | 18.2m |
| opencode Opus + GLM 5.1 | 10.3m |
| opencode Opus + Qwen 3.6 | 19.4m |
| Codex xHigh baseline | 21.9m |
| Codex xHigh + medium | 21.2m |
| Codex xHigh + low | 20.2m |

Alguns multi-model foram **mais rápidos** que o baseline sozinho. opencode com GLM 5.1 foi quase metade do tempo do opencode sozinho (10m vs 18m). Claude Code com Sonnet foi 1 minuto mais rápido que Opus puro. Codex multi-agent variants ficaram um pouco mais rápidos que xHigh sozinho.

Outros foram mais lentos: Claude Code com Haiku levou 15m (4m a mais que baseline). opencode com Qwen 3.6 ficou em 19m (igual baseline, provavelmente penalizado por overhead do llama-swap mesmo sem invocar o modelo).

Não tem padrão consistente de "multi-model é sempre mais lento" ou "sempre mais rápido". O que aconteceu, olhando os tool calls e contagem de testes, é mais interessante: **o modelo principal muda o próprio comportamento quando vê que tem sub-agente disponível, mesmo sem chamar ele**.

- Claude Code Opus sozinho: 24 testes, 11m
- Claude Code Opus + Sonnet: 18 testes, 10m (menos testes, mais rápido)
- Claude Code Opus + Haiku: 34 testes, 15m (mais testes, mais lento)

O padrão: quando o sub-agente existe na descrição como "executor", o modelo principal às vezes produz output mais enxuto, como se estivesse "deixando trabalho pra depois". Quando o sub-agente descreve execução mais cara (Haiku como "high-volume execution"), o modelo parece assumir que pode se dar ao luxo de escrever mais testes porque "o executor barato vai cuidar". Em nenhum caso o executor é chamado. Mas a presença do sub-agente influencia o planejamento do modelo principal.

É um efeito sutil, tipo placebo de delegação. O modelo não delega, mas comporta como se fosse delegar. Isso pode ser bom (output mais focado) ou ruim (cobertura de teste menor que o baseline). Não é algo que você controla, é comportamento emergente do modelo lendo a descrição do sub-agente.

### Então vale configurar Haiku só pro efeito placebo?

Dá pra ser tentado a pensar: "se Opus escreveu mais código e mais testes com Haiku configurado, então vale a pena configurar Haiku como sub-agente mesmo que ele nunca rode, só pelo placebo". Os números dizem que não.

Comparando Opus sozinho vs Opus com Haiku configurado, ambos no Claude Code:

| Métrica | Opus sozinho | Opus + Haiku |
|---|---:|---:|
| Tempo | 11.0m | 14.7m |
| Custo | $6.74 | $7.83 |
| Testes | 24 | 34 |
| Tier de qualidade | 3 (quebrado) | 3 (quebrado, mesma alucinação) |

Com Haiku configurado, Opus gastou 3.7 minutos a mais, $1.09 a mais, e escreveu 10 testes a mais. O tier de qualidade ficou igual. A mesma alucinação de `chat.complete` apareceu nos dois runs. Os 10 testes extras mockam a mesma API alucinada, então não provam nada que os 24 originais já não provavam. Mais código, não código melhor.

Placebo de delegação pode mover quantidade, mas não corrige erro factual. E com sample de 1 run cada, nem o aumento de quantidade é confiável, porque variância entre runs de Opus sozinho também é alta (provavelmente um outro run de Opus sozinho ia dar 30+ testes por acaso).

**Conclusão prática:** não configure sub-agente "de mentira" só pra tentar manipular o modelo principal. O custo em tokens/tempo é certo, o benefício é especulativo. Opus sozinho, sem sub-agente, continua sendo a configuração default recomendada. Sub-agentes só valem se você tem caso de uso real com delegação que funcione (e vimos aqui que greenfield não é esse caso).

### Hipótese "multi-model é mais lento" não se sustenta

De toda forma, voltando à pergunta original: não, não dá pra dizer que multi-model sem delegação é consistentemente mais lento. Às vezes é, às vezes é mais rápido, depende do modelo e da descrição do sub-agente. O que dá pra dizer é que a presença do sub-agente muda o comportamento do principal de forma imprevisível, e isso por si só é argumento contra configurações multi-model sem necessidade clara.

## Duas descobertas inesperadas

Fora do assunto principal (multi-model não funcionou), dois padrões apareceram.

### Primeira: o harness influencia a qualidade do código, não só o custo

O mesmo Opus 4.7 produziu Tier 1 no opencode e Tier 2/Tier 3 no Claude Code, no mesmo prompt. Isso é novo. Até onde eu sei, é a primeira evidência em benchmark de que o harness (a CLI que envelopa o modelo) pode degradar correção factual, não só custo.

A hipótese é que Claude Code carrega 6-11 milhões de tokens de cache por run (CLAUDE.md, schemas de tools, registro de agentes, etc.), contra ~210 mil do opencode. Esse volume de contexto parece puxar o Opus na direção de um "mental model" genérico de SDK OpenAI, onde `chat.complete` faz sentido, em vez do mental model específico do gem RubyLLM. É especulação, não consigo provar. Mas a diferença de Tier entre os dois harnesses rodando o mesmo modelo é concreta.

Isso **não significa** que opencode é melhor que Claude Code pra uso diário. No meu dia a dia, Claude Code com Opus é superior ao opencode em quase tudo: integração com editor, gestão de contexto em sessões longas, tool support nativo, qualidade de planejamento multi-step. O benchmark tem um recorte estreito (greenfield Rails app, prompt bem específico, sem iteração humana) que não reflete o uso real.

O que o dado diz é: a variância entre harnesses é real e mensurável. Vale ter em mente quando você tá avaliando um modelo.

### Segunda: custo de Claude Code vs opencode

Rodando o mesmo Opus 4.7 no mesmo prompt:

- Claude Code: $5 a $8 por run
- opencode: $1.10 por run

Claude Code custa 5 a 7 vezes mais por run no mesmo modelo. A diferença é o cache-read: Claude Code carrega 6-11M tokens de contexto por run, opencode carrega ~210K. Tem razão técnica legítima (tool schemas, TodoWrite, agent registries, CLAUDE.md, integração com editor), mas o overhead é real e aparece direto na conta de quem paga por token.

Aqui cabe uma orientação mais refinada, porque isso muda o cálculo dependendo do seu modelo de consumo.

**Se você tem Pro ou Max:** use Claude Code. Ponto. Assinatura cobre os tokens, você ganha o conjunto completo de features (tool support nativo, skills, agentes, Plan mode, contexto melhor em sessão longa). Não tem motivo pra trocar.

**Se você paga por token direto via API, o cálculo muda com o volume.**

Pra uso leve (algumas centenas de dólares por mês): opencode com Opus é mais barato e, nesse benchmark específico, chegou em Tier 1 enquanto Claude Code ficou em Tier 2/3. Funciona bem pra pipeline automatizado, CI, benchmark, agente server-side.

Pra uso pesado (milhares de dólares por mês no API): não faz sentido ficar no per-token. A assinatura Max 20x por $200/mês cobre volume grande e inclui Claude Code. Pra vibe-coder pesado, Max sai mais barato que Opus no API por uma margem ampla. Aí você volta pro primeiro bucket, com Claude Code.

**Opencode é melhor, independente de custo, pra:**

- Uso headless ou automatizado (CI, benchmarks, agentes em servidor)
- Setup multi-provider onde você quer o mesmo harness batendo em OpenRouter, Z.ai, llama-swap local
- Quando você precisa de output em JSON estruturado (`--format json`)
- Comparativos neutros entre modelos

**Claude Code é melhor, independente de custo, pra:**

- Sessões de coding interativas com humano no loop
- Projetos com CLAUDE.md, skills, MCP custom
- Trabalho onde Plan mode do Opus faz diferença
- Sessões longas iterativas onde contexto acumulado ajuda

A leitura honesta: esse benchmark mede um cenário estreito (greenfield, one-shot, sem humano iterando). Pra trabalho de verdade do dia a dia, Claude Code com Max continua sendo a recomendação pra 99% das pessoas. O ganho de custo do opencode aparece num nicho específico (pipeline automatizado ou uso API abaixo do break-even do Max). A maioria não tá nesse nicho.

## O mito do "Opus planeja, Qwen executa"

Volta e meia aparece gente no Twitter falando que monta pipeline onde Opus faz o plano técnico detalhado, e um modelo menor (Qwen, GLM 5, Haiku, Sonnet) executa. "Economia de tokens, mesma qualidade, todo mundo ganha".

Não funciona. Ou melhor, funciona pra demo, não funciona pra projeto real.

O problema mais grave é que **o plano nunca é perfeito de primeira**. Código nunca é one-shot. Você implementa, descobre um problema, ajusta. Com um modelo grande só, esse ajuste é feito pelo próprio modelo em tempo real. Com dois modelos, cada ajuste precisa voltar pro planner, ser reprocessado, novo plano escrito, novo executor invocado. O loop é mais lento.

Depois tem a questão do **conhecimento factual de API**. Se o plano do Opus diz "use RubyLLM pra chamar OpenRouter", o Opus sabe que é `RubyLLM.chat(model:).ask(msg).content`. O Qwen menor lê o plano e implementa com a API que ele acha que existe, que pode ser `RubyLLM::Client.new.complete`. O plano não corrige isso porque o plano não contém o conhecimento factual do gem. Só o próprio modelo que sabe aquela API sabe implementar corretamente.

E tem o **custo de coordenação**, que explode com iteração. Cada round de "plano → executa → falha → re-plano → executa de novo" custa mais tokens que simplesmente deixar o modelo grande fazer tudo em uma sessão. Você paga em tokens de planejamento E em tokens de código errado que precisa ser reescrito.

Em teoria, multi-model faz sentido. Na prática, é trabalho pra mostrar em thread do Twitter com animação bonita, não workflow de quem entrega código.

## Quando multi-model pode fazer sentido

Não quero parecer absolutista. Tem cenários onde multi-model é a escolha certa.

O principal é **tarefas genuinamente paralelas e desacopladas**. Migração de API em 30 arquivos idênticos, por exemplo: cada arquivo segue o mesmo pattern, não tem dependência entre eles. Opus poderia supervisionar 20 sub-agentes fazendo a mesma transformação em 20 arquivos diferentes. Nesse caso, o custo de coordenação é amortizado pelo paralelismo.

Outro caso é **tarefas que têm fase de pesquisa pesada seguida de fase de implementação direta**. Opus faz o spike arquitetural com exploração de código legado, depois delega a implementação mecânica pro modelo menor.

Um exemplo real que passei semana passada: [traduzi 700+ posts e todas as legendas de vídeo do blog pra inglês](/2026/04/09/20-anos-de-blog-o-ano-em-que-a-ia-finalmente-me-deixou-traduzir-tudo/) usando Claude Code. Esgotei o Max 20x e estourei mais $1120 de uso extra no mês. Tradução é exatamente o tipo de tarefa que teria se beneficiado de multi-model: cada post é independente do outro, não tem dependência cross-file, o planejamento arquitetural é nenhum, só tradução em lote. Opus orquestrando + Sonnet executando a tradução de cada arquivo teria cortado o custo pela metade, fácil. Não me ocorreu na hora, rodei tudo no Opus. A lição que tiro é: pra tarefa genuinamente paralela, multi-model com Sonnet como executor faz sentido, e eu perdi uma oportunidade clara de economizar.

Mas nenhum dos casos acima é "greenfield Rails app". Aplicação nova do zero é o pior cenário pra multi-model porque cada parte depende de todas as outras partes. Os modelos não são estúpidos, eles reconhecem isso e recusam a delegação.

## A regra de bolso segue a mesma

Pra 90% do trabalho de programação do dia a dia, minha recomendação continua:

- Claude Code + Opus (4.6 ou 4.7)
- Se custo for crítico e você tá ok com plugar em OpenRouter, GLM 5.1 é o segundo lugar confortável
- Se você tem GPU boa (5090 ou equivalente), Qwen 3.6 35B local é aceitável pra tarefas simples, com caveats

Multi-model? Só pra casos específicos onde o paralelismo é genuíno. Pra projeto normal, é overhead desnecessário.

## Benchmarks não são verdade absoluta

Esse benchmark mede uma coisa específica: greenfield Rails app, prompt bem determinado, sem iteração humana, em runners automatizados. É uma fatia estreita do uso real.

Se você quer saber qual combinação funciona pro SEU workflow, pros SEUS tipos de projeto, pras SUAS expectativas de qualidade, não confie no meu benchmark. Rode o seu. O [código tá todo no GitHub](https://github.com/akitaonrails/llm-coding-benchmark), o harness é extensível, você troca o prompt e já tem seu próprio comparativo.

O que eu espero que esse trabalho contribua é metodologia, não resposta definitiva. "Claude é melhor que Qwen" depende do que você tá fazendo. "Multi-model não funciona" depende do tipo de tarefa. Benchmark serve pra restringir o espaço de especulação com dado concreto, não pra fechar a discussão.

Enquanto isso, se alguém te disser que combinou Claude + GLM e ficou mágico, pede o código, pede o prompt, pede o repo. Na maioria das vezes a pessoa mediu uma coisa bem diferente, ou tem uma tarefa bem específica onde essa combinação cabe. Não generalize a partir de tweet.
