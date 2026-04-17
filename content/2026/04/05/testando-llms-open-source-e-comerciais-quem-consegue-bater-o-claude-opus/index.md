---
title: "Testando LLMs Open Source e Comerciais - Quem Consegue Bater o Claude Opus?"
date: '2026-04-05T18:00:00-03:00'
draft: false
translationKey: testing-llms-open-source-and-commercial
tags:
  - llm
  - benchmark
  - open-source
  - claude
  - ai
  - self-hosting
---

**Update 16 de Abril, 2026:** Adicionamos Claude Opus 4.7, Qwen 3.6 e GPT 5.4 via Codex CLI (xHigh reasoning). Opus 4.7 é melhoria incremental sobre 4.6 (28 testes vs 16, mesma API correta) e passa a ser o novo baseline. GPT 5.4, que estava no Tier 1 pelo meu aval pessoal, agora tem dados objetivos e caiu pro Tier 2 — gastou 7.6M tokens (~$16/run, 15x mais caro que Opus) e errou a convenção de chamada do `add_message` no multi-turn. Qwen 3.6 Plus continua Tier 3 com a mesma alucinação de API do 3.5. A conclusão se mantém: se quer segurança, Opus.

---

**TL;DR:** Se você não quer ler a análise inteira: os únicos modelos que geraram código que funciona de verdade no nosso benchmark foram Claude Opus 4.7, Claude Opus 4.6, GLM 5 e GLM 5.1 (da Z.AI, ~89% mais baratos que Opus). O Sonnet também funciona nesse benchmark, mas na prática falha em projetos que exijam raciocínio mais profundo — detalhes na conclusão. O GPT 5.4, que antes estava no Tier 1 pelo meu aval pessoal, agora tem dados objetivos via Codex CLI: gastou 7.6M tokens ($16/run) e errou a convenção de chamada do `add_message` — funciona na primeira mensagem, quebra no multi-turn. Caiu pro Tier 2. O resto — Kimi, DeepSeek, MiniMax, Qwen, Gemini, Grok 4.20 — inventou APIs que não existem ou ignorou o gem pedido.

Tem uma novidade nesse update: refiz a parte local do benchmark numa RTX 5090 (em vez do AMD Strix Halo) e adicionei um lote de modelos Qwen, incluindo um Qwen 3.5 27B distilado direto do Claude 4.6 Opus. Isso reabriu a conversa sobre rodar modelo open source localmente. A banda de memória da 5090 muda o jogo de "inviável" pra "viável com 1-2 prompts de correção". E o gargalo dos modelos open source virou falta de conhecimento factual sobre bibliotecas, coisa que eu explico em detalhe na nova seção sobre a família Qwen. A aposta da distilação do Claude, aliás, deu um resultado bem frustrante que eu nunca tinha visto documentado nesses termos.

---

Se você acompanhou meus [artigos anteriores sobre vibe coding](/tags/vibecoding/), sabe que passei os últimos dois meses numa maratona de mais de 500 horas usando Claude Opus como coding agent principal. Os resultados foram bons, como reportei na [conclusão sobre modelos de negócio](https://akitaonrails.com/2026/03/05/37-dias-de-imers%c3%a3o-em-vibe-coding-conclus%c3%a3o-quanto-a-modelos-de-neg%c3%b3cio/). Mas ficou uma coceira: será que eu estou preso num único modelo? Tem alternativa real ao Claude Opus pra uso diário em projetos de verdade?

Tenho uma RTX 5090 com 32 GB de GDDR7. Sei que posso rodar os modelos open source mais recentes. Comprei um [Minisforum MS-S1](https://akitaonrails.com/2026/03/31/review-minisforum-ms-s1-max-amd-ai-max-395/) com AMD Ryzen AI Max 395 e 128 GB de memória unificada, e montei um [home server com Docker](https://akitaonrails.com/2026/03/31/migrando-meu-home-server-com-claude-code/) pra servir modelos locais. A infraestrutura estava pronta. Faltava testar de verdade.

Construí um benchmark automatizado pra comparar modelos open source e comerciais em condições idênticas. 33 modelos configurados ao todo (25 da rodada original mais 8 adicionados na rerodada na NVIDIA), 27 executados, 16 completados de alguma forma. O código está no [GitHub](https://github.com/akitaonrails/llm-coding-benchmark).

## O gargalo que ninguém explica: VRAM e KV Cache

Antes de falar dos resultados, preciso explicar por que rodar modelos grandes localmente é muito mais difícil do que parece.

Pega o Qwen3 32B como exemplo. O modelo em FP16 (precisão total) ocupa ~64 GB. Quantizado em Q4 (4 bits), cai pra ~19 GB. Então cabe nos 32 GB da minha RTX 5090, certo? Errado. Esse é só o peso do modelo. Falta a parte que ninguém conta pra você: o **KV Cache**.

KV Cache é a memória que o modelo usa pra "lembrar" o que já leu. Cada vez que processa um token (uma palavra ou pedaço de palavra), ele calcula dois vetores — K (key) e V (value) — pra cada camada de atenção. Esses vetores ficam armazenados pra que não precise recalcular tudo quando gera o próximo token. Sem isso, a geração seria quadraticamente lenta.

O KV Cache escala linearmente com o tamanho do contexto. A fórmula:

```
Memória KV = 2 × Camadas × Cabeças_KV × Dimensão_Cabeça × Bytes_por_Elemento × Tokens_no_Contexto
```

Pra um modelo como o Llama 3.1 70B em BF16, isso dá ~0.31 MB por token. Parece pouco, até você perceber que um contexto de 128K tokens consome **40 GB** só de KV Cache. O modelo em si + KV Cache = muito mais VRAM do que a maioria das GPUs tem.

E pra uso real com coding agents, 128K tokens não é luxo — é necessidade. O agent precisa ler arquivos, manter histórico de conversação, receber output de comandos. Em sessões longas de benchmark, nossos modelos consumiram entre 39K e 156K tokens. Menos de 100K de contexto não é prático pra projetos do dia a dia.

O Google publicou o [TurboQuant](https://research.google/blog/turboquant-redefining-ai-efficiency-with-extreme-compression/) (ICLR 2026), que comprime o KV Cache pra 3 bits sem perda de acurácia — redução de 6x na memória e até 8x de speedup. Usa rotação aleatória de vetores (PolarQuant) seguida de um algoritmo de 1 bit nos resíduos. Funciona online durante inferência, comprimindo na escrita e descomprimindo na leitura. Ainda não está implementado nos runtimes que usamos (llama.cpp, Ollama), mas quando chegar vai mudar bastante a equação.

Pra quem quer se aprofundar nessa matemática de VRAM, recomendo [este link do Ahmad Osman](https://x.com/TheAhmadOsman/status/2040103488714068245) pro artigo "GPU Memory Math for LLMs (2026 Edition)".

## O problema do hardware: memória não é toda igual

"Mas eu tenho 128 GB de RAM!" Legal, mas não é isso que importa. O que importa é largura de banda de memória, e a diferença entre tipos é absurda:

![Largura de banda de memória por tipo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/05/llm-benchmark/en/memory-bandwidth.png)

A RTX 5090 tem 7x mais bandwidth que a memória LPDDR5x do meu Minisforum. Isso significa que mesmo que o modelo caiba na RAM unificada do AMD, a inferência vai ser proporcionalmente mais lenta. No meu Minisforum com LPDDR5x a 256 GB/s, o Qwen3 32B roda a ~7 tok/s. Na RTX 5090 a 1.792 GB/s, seria muito mais rápido — se coubesse inteiro na VRAM junto com o KV Cache.

A maioria das pessoas rodando modelos locais ainda está em DDR4. A 50 GB/s, modelos de 32B ficam praticamente unusáveis. E tem outro fator que pouca gente lembra: storage. Quando a RAM não dá conta e o sistema faz swap, a velocidade do armazenamento vira o gargalo:

| Storage | Velocidade Sequencial |
|---|---:|
| SATA SSD | ~550 MB/s |
| NVMe Gen3 | ~3.500 MB/s |
| NVMe Gen4 | ~7.000 MB/s |
| NVMe Gen5 | ~12.000 MB/s |

De SATA pra NVMe Gen5 são 22x de diferença. Se você está fazendo offloading parcial pro disco (comum quando o modelo não cabe inteiro na GPU), NVMe Gen4 ou Gen5 faz diferença real. SATA é inviável.

Resumindo: rodar modelos locais não é só "ter RAM suficiente". Precisa do tipo certo de memória, com a bandwidth certa, e storage rápido como fallback. Pra muita gente, um Mac Studio com memória unificada de alta bandwidth (até 800 GB/s nos M4 Ultra com 512 GB) seria a opção mais prática, mas custa mais de US$ 10.000. O AMD Ryzen AI Max é a alternativa mais acessível com memória unificada, mas o LPDDR5 fica limitado a 256 GB/s.

## Ollama vs llama.cpp: por que o Ollama falha pra benchmarks

O [Ollama](https://ollama.com/) é a forma mais popular de rodar modelos locais. Instala, puxa o modelo, roda. Pra uso casual funciona. Mas quando tentei usar pra benchmarks automatizados, sessões longas sem intervenção humana, quebrou de 6 formas diferentes em 8 modelos:

1. Descarrega o modelo no meio da sessão. Em runs longos, o Ollama decide que o modelo não está sendo usado e descarrega da GPU. O agent fica esperando resposta de um modelo que não existe mais.
2. Ignora o contexto solicitado. Você pede `num_ctx=131072`, o Ollama aceita, e no meio do run reverte pro padrão sem avisar.
3. Lifecycle instável. Pedir `keep_alive: 0` pra descarregar nem sempre funciona. O modelo fica residente e bloqueia o próximo.
4. Formatos incompatíveis. Variantes bf16 nativas do Ollama falhavam, enquanto o mesmo modelo como GGUF Q8 do HuggingFace funcionava sem problemas.

A solução: migrar pro [llama-swap](https://github.com/mostlygeek/llama-swap), um wrapper Go que gerencia processos llama.cpp com hot-swap. Chega um request pra um modelo diferente do que está carregado, ele mata o processo atual e inicia o novo. Sem negociação de contexto, sem lifecycle instável.

O llama-swap resolveu o carregamento de 6 dos 8 modelos que falharam no Ollama:

| Modelo | Ollama | llama-swap |
|---|---|---|
| Gemma 4 27B | HTTP 500 | 47.6 tok/s |
| GLM 4.7 Flash | Sem output | 47.4 tok/s |
| Llama 4 Scout | Descarregou | 17.5 tok/s |
| Qwen 3.5 35B | Output off-spec | 49.7 tok/s |
| Qwen 3.5 122B | Context drift | 23.1 tok/s |
| GPT OSS 20B | Model not found | 78.3 tok/s |

Mas o llama-swap não é mágico.

## Por que "só usar llama.cpp" não resolve tudo

O llama.cpp resolve os problemas de lifecycle do Ollama mas traz os próprios:

Cada modelo precisa de flags específicas. GLM e Qwen 3.5 emitem `<think>` tags que quebram clientes se você não passar `--reasoning-format none`. Gemma 4 precisa de build b8665+ pro parser de tool calls funcionar.

Nem todo modelo suporta tool calling. O llama.cpp precisa de um parser dedicado pro formato de tool call de cada modelo. O Llama 4 Scout usa um formato "pythonic" (`[func(param="value")]`) que o llama.cpp simplesmente não parseia, emite como texto puro. O vLLM tem parser pra isso, o llama.cpp não.

E tem os repetition loops. O Gemma 4, mesmo com o parser certo, entra em loop infinito depois de ~11 tool calls em sessões longas. É um [bug conhecido](https://github.com/ggml-org/llama.cpp/issues/21375) que o PR #21418 não resolveu completamente.

Compatibilidade de tool calling por modelo:

| Modelo | Tool Calling | Flags Necessárias | Resultado no Benchmark |
|---|---|---|---|
| Gemma 4 27B | Parcial (b8665+) | `--jinja --reasoning-format none` | Loop infinito após ~11 steps |
| GLM 4.7 Flash | Sim | `--jinja --reasoning-format none` | 2029 arquivos, terminou mid-tool-call |
| Qwen 3.5 (35B, 122B) | Sim | `--jinja --reasoning-format none` | Completou com sucesso |
| Qwen 3 Coder Next | Sim | `--jinja` | Completou (melhor resultado local) |
| GPT OSS 20B | Sim | `--jinja` | Tool calls ok, mas app no diretório errado |
| Llama 4 Scout | Não | — | Sem parser no llama.cpp |

No fim das contas, llama.cpp é melhor que Ollama pra runs automatizados, mas "plug and play" não é. Cada modelo exige configuração específica, e alguns simplesmente não funcionam pra agentic coding ainda.

## Reasoning: modelos que pensam vs modelos que chutam

Tem uma diferença entre modelos que vale explicar: reasoning. A ideia é que o modelo "pensa antes de responder" em vez de gerar tokens direto da esquerda pra direita. Modelos com reasoning fazem uma etapa interna de cadeia de pensamento (chain-of-thought) onde avaliam o problema, consideram alternativas, planejam, e só depois emitem a resposta.

Na prática, isso aparece como `<think>...</think>` tags no output, blocos de texto que o modelo gera pra si mesmo, que não devem ir pro usuário final. Claude Opus 4.6, GPT 5.4, DeepSeek V3.2 e a linha Qwen 3.5 suportam reasoning nativamente. Os menores (Gemma 4, GPT OSS 20B, modelos mais antigos) não têm essa capacidade.

Por que importa pra coding? Quando um coding agent recebe "construa um app Rails com 9 componentes", ele precisa decompor a tarefa em passos, decidir a ordem, antecipar dependências, adaptar quando algo falha. Sem reasoning, o modelo gera código sequencialmente sem planejamento. Funciona pra tarefas simples, desmorona em projetos com partes interdependentes.

No benchmark, a diferença ficou clara:

- GPT OSS 20B (sem reasoning, 20B parâmetros) criou o app no diretório errado. Não conseguiu manter o contexto das instruções de workspace enquanto gerava código.
- Qwen 3 32B tem reasoning, mas a 7 tok/s era lento demais. Os tokens de "pensamento" aumentam o tempo de geração.
- Gemma 4 31B, sem reasoning treinado pra uso agentic, entrou em loops repetitivos de tool calling.
- GLM 5 (cloud, 745B MoE) com reasoning e 44B parâmetros ativos, completou limpo e usou a API correta.

Tem um trade-off: reasoning consome tokens extras (os `<think>` blocks), que ocupam VRAM no KV Cache e desaceleram a geração. Por isso flags como `--reasoning-format none` são necessárias no llama.cpp. Alguns clientes não sabem o que fazer com reasoning tokens e quebram. Modelos que emitem reasoning sem que o runtime espere podem gerar lixo no output.

E reasoning não é algo que você "liga" num modelo qualquer. É uma capacidade treinada com reinforcement learning em cima do modelo base, usando dados de problemas que exigem raciocínio multi-step. Os modelos open source menores (20B-35B) tipicamente não passaram por esse treinamento, ou passaram em escala menor. Eles sabem gerar código, mas não sabem *planejar* código. Em tarefas que exigem 50+ tool calls coordenadas, essa diferença mata.

## O benchmark: metodologia

Pra comparar modelos de forma justa, construí um harness automatizado em Python. Cada modelo recebe exatamente o mesmo prompt: construir uma aplicação Ruby on Rails completa, um chat SPA tipo ChatGPT usando o gem RubyLLM, com Hotwire/Stimulus/Turbo Streams, Tailwind CSS, testes Minitest, ferramentas de CI (Brakeman, RuboCop, SimpleCov, bundle-audit), Dockerfile, docker-compose e README.

![Crush — CLI de coding da Charm](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/05/llm-benchmark/crush-screenshot.png)

O runner é o [opencode](https://github.com/sst/opencode), uma das CLIs de coding open source mais populares, competindo com Claude Code e Codex. Vale um esclarecimento: o autor original saiu do projeto e foi tocar o [Crush](https://github.com/charmbracelet/crush) junto com a equipe da [Charm](https://charm.sh/) (o pessoal por trás do Bubble Tea, Lip Gloss e várias outras ferramentas de terminal em Go), mas o restante do time original continuou evoluindo o opencode normalmente — o projeto não foi descontinuado. Hoje os dois coexistem. Se você leu [meu artigo sobre o Crush](https://akitaonrails.com/2026/01/09/omarchy-3-um-dos-melhores-agentes-pra-programacao-crush/), já conhece essa vertente. Ambos rodam em tudo: macOS, Linux, Windows, Android, FreeBSD.

Na verdade, tentei usar o Crush primeiro pro benchmark. O problema: ele anunciava uma flag `--yolo` no help pra auto-aprovar todas as ações (essencial pra runs automatizados sem intervenção humana), mas na hora de rodar, rejeitava a flag. Sem auto-approve, não dá pra fazer benchmark desacompanhado. O opencode, por outro lado, tinha o modo `opencode run --agent build --format json` que emite eventos JSON com session IDs e contagem de tokens, perfeito pra automação. Então ficamos com o opencode.

Escolhi o opencode (e não Claude Code ou Codex) por dois motivos:

1. Neutralidade. Claude Code é otimizado pra modelos Anthropic. Codex é otimizado pra modelos OpenAI. O opencode é agnóstico, mesma interface pra todos.
2. Automação. O opencode expõe um formato JSON legível por máquina. Claude Code e Codex não têm interface equivalente pra benchmarking externo.

Modelos cloud rodaram em duas fases: fase 1 (construir o app) e fase 2 (validar boot local, docker build, docker compose). Modelos locais rodaram só fase 1.

Detalhe que vale mencionar: o benchmark inteiro custou menos de $10 em tokens no OpenRouter. Tirando o GPT 5.4 Pro que torrou $7.20 pra falhar, os outros 11 modelos cloud somaram uns $2.50 no total. Modelos locais custam só eletricidade. O ponto é: rodar seu próprio benchmark é barato. Se você quer saber se um modelo funciona pro seu caso de uso, gaste os $2 e teste. O código do harness está no GitHub, é só trocar o prompt pelo seu projeto.

## Por que o GPT 5.4 falhou no benchmark (mas não na vida real)

O GPT 5.4 Pro é o único modelo cloud que falhou consistentemente no nosso benchmark. Duas runs separadas, mesmo resultado: o modelo gerou arquivos mas nunca chegou a `finish_reason: stop`. Sempre terminava com `finish_reason: tool-calls` — queria continuar chamando tools mas o loop se quebrava.

Pra quem não sabe: tool calling é quando um LLM precisa executar uma ação (ler um arquivo, rodar um comando, editar código) e emite uma "chamada de ferramenta" num formato estruturado. O client (opencode, Claude Code, Codex) interpreta, executa, e devolve o resultado pro modelo. Cada provedor tem seu formato: a Anthropic usa `tool_use` blocks, a OpenAI usa `function_calling` com JSON schemas, o Google usa `FunctionCall`.

O GPT 5.4 é fortemente treinado pro formato nativo de function calling da OpenAI — `tool_choice`, `tools` com JSON schemas proprietários. Quando o benchmark rota por opencode → OpenRouter → GPT 5.4, os schemas de tools são traduzidos em cada hop. Se o GPT emite tool calls num formato que o OpenRouter ou opencode não parseia corretamente, o loop do agent quebra.

A evidência: todos os outros modelos cloud (Claude Opus, Claude Sonnet, Kimi K2.5, DeepSeek V3.2, MiniMax M2.7, GLM 5, Qwen 3.6 Plus, Step 3.5 Flash) terminaram com `finish_reason: stop`. Só o GPT termina com `finish_reason: tool-calls`.

Comparação justa do GPT 5.4 exigiria rodar no ambiente nativo. E agora temos essa comparação: construímos suporte pra automatizar o Codex CLI (`codex exec` com `--dangerously-bypass-approvals-and-sandbox` e reasoning effort `xhigh`) e rodamos o mesmo benchmark. O GPT 5.4 completou em 22 minutos, gerou todos os 9 artefatos, escreveu 22 testes com a arquitetura mais sofisticada do benchmark inteiro: injeção de dependência do client RubyLLM, PORO models pra `ChatMessage` e `PromptSubmission`, session-backed `ChatSession` com TTL e trimming de mensagens, bin/ci script.

Mas o código quebra na segunda mensagem. O GPT 5.4 usa `chat.add_message(role:, content:)` com keyword arguments em vez de hash posicional `chat.add_message({role:, content:})` — isso causa `ArgumentError: wrong number of arguments (given 0, expected 1)` na primeira troca multi-turn. A primeira mensagem funciona (usa `chat.ask` direto), o multi-turn não.

E o custo: **7.6 milhões de tokens** no reasoning effort xHigh. São 65x mais tokens que o Opus 4.7 (118K) pro mesmo benchmark. Custo estimado de ~$16 por run, contra ~$1.10 do Opus. Gastou 15x mais e ainda errou a convenção de chamada. Nem budget de token gigantesco nem reasoning effort máximo garante acerto factual numa API de gem. Conhecimento de API é memória binária, não é função de quanto o modelo "pensa".

Com dados objetivos em mãos, o GPT 5.4 sai do Tier 1 e vai pro Tier 2. A arquitetura que ele gera é melhor que a do Opus em termos de design patterns. Mas o código precisa de correção pra rodar multi-turn, e o custo por token é proibitivo.

O Sonnet e o Opus via opencode/OpenRouter também provavelmente não foram usados ao máximo da capacidade. O Claude Code oferece suporte nativo de tools que o opencode não replica — o que significa que os resultados do benchmark representam um piso, não um teto, pra esses modelos.

## Modelos open source: a realidade vs a narrativa

Tem muita gente dizendo que modelos open source já alcançaram os comerciais e que dá pra rodar seu próprio "Claude" em casa. Na prática, não é bem assim.

A escala não é comparável. Modelos frontier como Claude Opus 4.6 e GPT 5.4 são closed-source, mas estimativas indicam que estão na faixa de centenas de bilhões a trilhões de parâmetros, treinados com compute e dados que nenhuma empresa open source replica. Os melhores modelos que cabem num hardware razoável são:

| Modelo | Parâmetros Totais | Parâmetros Ativos | Arquitetura |
|---|---:|---:|---|
| Qwen 3.5 35B-A3B | 35B | 3B | MoE (A3B) |
| Qwen 3.5 27B | 27B | 27B | Dense |
| Qwen 3 32B | 32B | 32B | Dense |
| Qwen 3.5 122B | 122B | 122B | Dense |
| GPT OSS 20B | 20B | 20B | Dense |
| Gemma 4 31B | 31B | 31B | Dense |

Correção pós-publicação: o Qwen 3.5 35B na verdade é o **35B-A3B**, um MoE com só 3B de parâmetros ativos por token (não denso, como eu tinha colocado originalmente). Isso explica por que ele roda relativamente rápido pro tamanho. E pra quem tem 24 GB de VRAM, o modelo recomendado pela própria [Unsloth](https://unsloth.ai/docs/models/qwen3.5#qwen3.5-27b) é o **Qwen 3.5 27B** denso — esse eu não cheguei a testar no benchmark, mas fica como recomendação. Pra quem quer se aprofundar em modelos locais, vale acompanhar o trabalho do [@sudoingX](https://x.com/sudoingX), que tem feito experimentação séria nessa frente. Valeu [@thpmacedo](https://x.com/thpmacedo/status/2041105305111502927) pelo toque.

Mesmo os maiores modelos open source MoE (Mixture of Experts) que as empresas disponibilizam publicamente ativam poucos parâmetros por token:

| Modelo | Parâmetros Totais | Parâmetros Ativos | Notas |
|---|---:|---:|---|
| Kimi K2.5 | 1T | 32B | 384 experts, top-8 + shared |
| GLM 5 | 745B | 44B | 256 experts, 8 ativados |
| DeepSeek V3.2 | 671B | 37B | Sparse Attention |
| Qwen 3.5 397B | 397B | 17B | MoE, cloud-only |

Esses modelos grandes não são self-hostáveis. O Kimi K2.5 com 1T parâmetros precisa de clusters de GPUs com centenas de GBs de VRAM. O GLM 5 com 745B idem. Mesmo que a Alibaba ou a Z.AI liberem os pesos (e algumas liberam), ninguém tem hardware doméstico pra rodar eles.

O que cabe na sua GPU doméstica são os modelos de 20B-35B — e esses têm limitações reais.

### O que cada modelo local fez no benchmark

Resultados da rodada original no AMD Strix Halo:

**Qwen 3 Coder Next (30B)** — Completou em 17 minutos no Strix, gerou 1675 arquivos, app Rails com todos os artefatos. Mas só 3 testes. E o mais importante: inventou `RubyLLM::Client.new`, uma classe que não existe no gem. O app não roda.

**Qwen 3.5 35B** — Completou em 28 minutos no Strix, 1478 arquivos, 11 testes. Usou `RubyLLM.chat` sem parâmetro de modelo — funciona só se o default estiver configurado. Sem mocking de LLM nos testes.

**Qwen 3.5 122B** — Completou em 43 minutos no Strix, 1503 arquivos, 16 testes. Mas ignorou o gem RubyLLM completamente e construiu um cliente HTTP customizado pro OpenRouter. O prompt pedia explicitamente pra usar ruby_llm.

**GLM 4.7 Flash (local, Strix)** — Produziu 2029 arquivos com todos os artefatos, mas a sessão terminou mid-tool-call. O modelo cloud (GLM 5) funciona perfeitamente.

**Gemma 4 31B (Strix)** — Loop infinito de tool calls depois de ~11 steps produtivos. Bug conhecido do llama.cpp.

**GPT OSS 20B (Strix)** — Criou o app Rails no diretório errado (`project/app/` em vez de `project/`). Um modelo de 20B não segue instruções de workspace de forma confiável.

**Qwen 3 32B (Strix)** — Lento demais (7.3 tok/s). Hardware não dá conta.

E os resultados da rerodada na NVIDIA RTX 5090 (todos com Q3_K_M ou Q4_K_M e contexto entre 64k e 128k pra caber nos 32 GB de VRAM):

**Qwen 3.5 35B-A3B (5090)** — 5 minutos a 273 tok/s. Projeto Rails reconhecível, entry point `RubyLLM.chat(model:)` está certo, mas alucina `chat.add_message(role:, content:)` e `chat.complete` em vez de `.ask`. Dá pra arrumar em 1-2 follow-ups. O melhor candidato a "OSS local que vale a pena tentar".

**Qwen 3.5 27B Claude-distilado (5090)** — 12 minutos a 129 tok/s. Estilo Claude impecável, alucinação total da API (`RubyLLM::Chat.new.with_model{}`, `add_message`, `response.text`). Mais detalhes na seção de distilação abaixo.

**Qwen 3 Coder 30B (5090)** — 6 minutos a 145 tok/s. Devolveu uma string mockada hardcoded em vez de chamar a API. Tier 3 inutilizável.

**Qwen 2.5 Coder 32B (5090)** — 90 minutos de timeout, zero arquivos. Modelo girou sem nunca chamar tool de write.

**Qwen 3 32B (5090)** — 4 minutos a 69 tok/s, scaffold parcial, errors. Versão geral é melhor que a Coder mas ainda quebra.

**Gemma 4 31B (5090)** — 8 minutos a 213 tok/s. Mesmo loop de repetição que tinha no Strix. Bug do llama.cpp não é hardware.

**Qwen 3.5 27B Sushi Coder RL (5090)** — Falha de infra (`ProviderModelNotFoundError`), não foi possível avaliar. Refazer numa próxima rodada.

**GPT OSS 20B (5090)** — Tirado da rodada por regressão recente do llama.cpp main no parser de tool calls da família harmony. Os logs mostram `Failed to parse input at pos 755: <|channel|>...` em sessões multi-turn. Funcionava no Strix com o llama.cpp `b8643`, quebrou no main de hoje. Aguardando upstream consertar.

## Modelos cloud: o que funciona de verdade

Dos 12 modelos que completaram o benchmark, todos geraram um projeto Rails reconhecível com todos os artefatos pedidos (Gemfile, routes, views, JS, testes, README, Dockerfile, docker-compose). 9 de 9 no checklist de completude.

Mas aí vem a pergunta que importa: o código roda?

![Custo vs tempo — e o código funciona?](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/05/llm-benchmark/en/cost-vs-quality.png)

A API correta do RubyLLM é simples:

```ruby
chat = RubyLLM.chat(model: "anthropic/claude-sonnet-4")
response = chat.ask("Hello")
response.content  # => "Hi there!"
```

8 dos 12 modelos inventaram APIs que não existem. O padrão mais comum: alucinação de uma interface que não é a do gem real:

| Modelo | O que Inventou |
|---|---|
| DeepSeek V3.2 | `RubyLLM::Client.new` — classe inexistente |
| Qwen 3 Coder Next | `RubyLLM::Client.new` — mesmo erro |
| Qwen 3.5 122B | `Openrouter::Client` — gem inexistente |
| Kimi K2.5 | `add_message()` e `complete()` — métodos inexistentes |
| MiniMax M2.7 | `RubyLLM.chat(messages: [...])` — assinatura inexistente |
| Qwen 3.6 Plus | `chat.add_message()` — método inexistente |
| Gemini 3.1 Pro | `RubyLLM::Chat.new()` e `add_message()` — API interna, não pública |
| Grok 4.20 | Ignora o gem completamente — usa `OpenAI::Client` (ruby-openai) batendo direto na URL do OpenRouter |

Os modelos que acertaram — os dois Claudes, o GLM 5 e o GLM 5.1 — usaram o padrão simples de duas etapas (`chat = RubyLLM.chat(model:)` depois `chat.ask(message)`). Os que erraram tentaram fazer o RubyLLM parecer com o SDK Python da OpenAI, que é outra coisa. O Grok 4.20 foi o caso mais cínico: nem tentou usar o gem, foi direto pro `OpenAI::Client` apontando pra URL do OpenRouter, ignorando o pedido explícito do prompt.

E os testes? Só Opus, Sonnet, GLM 5 e GLM 5.1 fizeram mocking correto das chamadas LLM. Todos os outros ou batiam na API real (que falha sem chave) ou mockavam a API inventada (testes passam mas não provam nada). Contagem de testes é uma métrica enganosa: o Kimi K2.5 escreveu 37 testes, mais que qualquer outro, mas nenhum testa a funcionalidade real porque a API que ele usa não existe.

### Tabela de viabilidade real

| Modelo | API Correta? | Roda? | Mocking nos Testes? | Problema |
|---|:---:|:---:|:---:|---|
| **Claude Opus 4.7** | Sim | **Sim** | Sim (FakeChat) | Implementação limpa, 28 testes |
| **Claude Sonnet 4.6** | Sim | **Sim** | Sim (mocha) | Implementação limpa |
| **Claude Opus 4.6** | Sim | **Sim** | Sim (mocha) | Implementação limpa |
| **GLM 5** | Sim | **Sim** | Sim (mocha) | API correta, funciona |
| **GLM 5.1** | Sim | **Sim** | Sim | API correta, funciona |
| GPT 5.4 (Codex) | Parcial | Só 1ª msg | Sim (FakeChat) | `add_message(role:, content:)` com keyword args em vez de hash posicional — quebra no multi-turn |
| Step 3.5 Flash | N/A | **Sim*** | Não | Bypassa RubyLLM, usa HTTP direto |
| Grok 4.20 | N/A | **Sim*** | Não | Bypassa RubyLLM, usa `OpenAI::Client` direto |
| Qwen 3.6 Plus | Parcial | Só 1ª msg | Não | `add_message()` não existe |
| Qwen 3.5 35B | Parcial | Talvez | Não | Sem parâmetro de modelo |
| Kimi K2.5 | Não | **Não** | Não | `add_message()`/`complete()` inventados |
| MiniMax M2.7 | Não | **Não** | Não | Assinatura de `RubyLLM.chat` errada |
| DeepSeek V3.2 | Não | **Não** | Não | `RubyLLM::Client` inexistente |
| Qwen 3 Coder Next | Não | **Não** | Não | `RubyLLM::Client` inexistente |
| Gemini 3.1 Pro | Não | **Não** | Mock errado | `RubyLLM::Chat.new()` e `add_message()` inexistentes |
| Qwen 3.5 122B | Não | **Não** | Não | `Openrouter::Client` gem inexistente |

*Step 3.5 Flash funciona chamando a API REST do OpenRouter direto com `Net::HTTP`, contornando completamente o gem que o prompt pedia.

Agora, isso não quer dizer que esses modelos são inúteis. Se você pegar o Kimi K2.5 ou o DeepSeek V3.2 e mandar "a classe RubyLLM::Client não existe, corrija pra usar a API real do gem", provavelmente vai corrigir. Um ou dois follow-ups e o projeto fica funcional. A maioria dos modelos que falharam aqui conseguiria entregar um projeto rodando com mais algumas rodadas de conversa.

Só que aí está o trade-off. Com Opus ou GPT 5.4, o primeiro output já funciona. Pede, entrega, testa, roda. Com os modelos mais baratos, você vai gastar tempo corrigindo alucinações de API, debugando código que "parece certo" mas crasha, guiando o modelo na direção certa. Cada rodada dessas são 10-30 minutos. Três rodadas extras e você gastou uma hora do seu tempo pra economizar $0.90 de tokens.

Economiza dólar, gasta tempo. E tempo é dinheiro. Pra quem está aprendendo ou explorando sem pressa, essa troca pode fazer sentido. Pra quem precisa entregar, os modelos frontier se pagam rápido.

### Comparação dos modelos que funcionam

| Modelo | Provedor | Tempo | Testes | Custo/Run | vs Opus |
|---|---|---:|---:|---:|---|
| Claude Opus 4.7 | OpenRouter | 18m | 28 | ~$1.10 | Novo baseline |
| Claude Sonnet 4.6 | OpenRouter | 16m | 30 | ~$0.63 | 40% mais barato, mais testes |
| Claude Opus 4.6 | OpenRouter | 16m | 16 | ~$1.05 | Baseline anterior |
| GLM 5 | OpenRouter | 17m | 7 | ~$0.11 | 89% mais barato |
| GLM 5.1 | Z.AI direto | 22m | 24 | ~$0.13 | ~88% mais barato, mais testes que o GLM 5 |

### Ranking completo por tempo e tokens

![Tempo de conclusão por modelo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/05/llm-benchmark/en/time-to-complete.png)

| Modelo | Provedor | Tempo | Tokens Totais | Tok/s | Custo/Run |
|---|---|---:|---:|---:|---:|
| Grok 4.20 | OpenRouter | 8m | 63.457 | 412.54 | ~$0.04 |
| Gemini 3.1 Pro | OpenRouter | 14m | 104.034 | 128.28 | ~$0.50 |
| MiniMax M2.7 | OpenRouter | 14m | 79.743 | 574.52 | ~$0.05 |
| Claude Opus 4.6 | OpenRouter | 16m | 136.806 | 347.18 | ~$1.05 |
| Claude Sonnet 4.6 | OpenRouter | 16m | 127.067 | 532.26 | ~$0.63 |
| GLM 5 | OpenRouter | 17m | 59.378 | 400.01 | ~$0.11 |
| Qwen 3.6 Plus | OpenRouter | 17m | 88.940 | 182.91 | Grátis |
| Claude Opus 4.7 | OpenRouter | 18m | 118.216 | 328.24 | ~$1.10 |
| GLM 5.1 | Z.AI direto | 22m | 81.666 | 166.62 | ~$0.13 |
| GPT 5.4 (Codex) | Codex CLI | 22m | 7.643.800 | 5.824.56 | ~$16.00 |
| Qwen 3 Coder Next | Local | 17m | 39.054 | 37.49 | Eletricidade |
| Qwen 3.5 35B | Local | 28m | 76.919 | 46.03 | Eletricidade |
| Kimi K2.5 | OpenRouter | 29m | 63.638 | 160.14 | ~$0.07 |
| Step 3.5 Flash | OpenRouter | 38m | 156.267 | 242.11 | ~$0.02 |
| Qwen 3.5 122B | Local | 43m | 57.472 | 22.41 | Eletricidade |
| DeepSeek V3.2 | OpenRouter | 60m | 115.278 | 53.37 | ~$0.04 |

O DeepSeek V3.2 é o mais lento apesar de ser cloud — não tem prompt caching, então reenvia o contexto completo a cada turno.

### Eficiência de tokens e cache

Modelos com prompt caching pagam muito menos tokens efetivos:

![Eficiência de tokens: cache vs novos](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/05/llm-benchmark/en/token-efficiency.png)

| Modelo | Tokens Totais | Cache Lido | Tokens Novos Efetivos |
|---|---:|---:|---:|
| Claude Sonnet 4.6 | 127.067 | 126.429 | 638 |
| Claude Opus 4.7 | 118.216 | 116.824 | 1.392 |
| Claude Opus 4.6 | 136.806 | 135.976 | 830 |
| GLM 5 | 59.378 | 58.240 | 1.138 |
| GLM 5.1 | 81.666 | 81.216 | 450 |
| Grok 4.20 | 63.457 | 62.400 | 1.057 |
| Gemini 3.1 Pro | 104.034 | 98.129 | 5.905 |
| GPT 5.4 (Codex) | 7.643.800 | 0 | 7.643.800 |
| DeepSeek V3.2 | 115.278 | 0 | 115.278 |
| Kimi K2.5 | 63.638 | 0 | 63.638 |

## Velocidade: o abismo entre cloud e local

Tem um aspecto que as tabelas de custo escondem: velocidade de inferência. E a diferença é brutal.

![Velocidade de inferência por modelo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/05/llm-benchmark/en/speed-comparison.png)

O Claude Sonnet gera 532 tok/s. O Qwen 3.5 122B rodando local no meu Minisforum (AMD Strix Halo) gera 22 tok/s. São 24x de diferença. Na prática, o que o Sonnet faz em 16 minutos, o Qwen 3.5 122B leva 43 minutos. O Qwen 3 Coder Next a 37 tok/s é o mais rápido dos locais no Strix e mesmo assim é 14x mais lento que o Sonnet.

E não é só tempo de relógio. Quando você está num loop de coding interativo — pede uma mudança, espera o output, testa, pede outra — a velocidade do modelo define seu ritmo. A 37 tok/s, cada resposta longa te faz esperar 30-60 segundos. A 530 tok/s, aparece quase instantaneamente. Ao longo de um dia, você sente.

O DeepSeek V3.2 é um caso curioso: é cloud mas roda a 53 tok/s, mais lento que o Qwen 3.5 35B local no Strix (46 tok/s). O motivo é que o DeepSeek não tem prompt caching — reenvia o contexto completo a cada turno, estrangulando o throughput. Pagar por um modelo cloud mais lento que rodar local não faz sentido nenhum.

Modelos locais são grátis em tokens, mas pagam em tempo. No AMD Strix, essa conta era inviável pra todos os Qwen que testei: dois minutos esperando uma resposta longa, multiplicado por 50 turnos, é tarde inteira. Mas isso muda quando o hardware muda, e foi por isso que rerodei a parte local do benchmark numa máquina diferente.

## AMD Strix Halo vs NVIDIA RTX 5090: o que muda quando a banda de memória dobra

Pra checar se o gargalo era hardware ou modelo, peguei os mesmos modelos Qwen e refiz o benchmark numa workstation com NVIDIA RTX 5090 (Blackwell, 32 GB GDDR7, 1.792 GB/s de banda). Os números mudam de uma forma que vale ver com calma.

| Modelo | AMD Strix (LPDDR5x) | NVIDIA 5090 (GDDR7) | Speedup | Tempo total no 5090 |
|---|---:|---:|---:|---:|
| Qwen 3 32B (denso) | 7 tok/s | 69 tok/s | ~10x | 4 min |
| Qwen 3 Coder 30B (Coder) | 37 tok/s | 145 tok/s | ~4x | 6 min |
| Qwen 3.5 35B-A3B (MoE) | 46 tok/s | **273 tok/s** | ~6x | 5 min |
| Qwen 3.5 27B Claude (distilado) | timeout 90m | 129 tok/s | n/a | 12 min |
| Gemma 4 31B | (não testei no Strix) | 213 tok/s | n/a | 8 min |
| Qwen 2.5 Coder 32B | (não testei no Strix) | 2.86 tok/s | n/a | timeout 90m |

Pra contextualizar essas velocidades, lembra que no cloud o Sonnet roda a 532 tok/s, o Opus a 347 tok/s, o Step 3.5 Flash a 242 tok/s, o Gemini 3.1 Pro a 128 tok/s e o Kimi K2.5 a 160 tok/s. O Qwen 3.5 35B-A3B na 5090, a 273 tok/s, está na faixa do Step 3.5 Flash, mais rápido que Gemini, Kimi e GLM 5.1. O Qwen 3 Coder 30B a 145 tok/s está na faixa do Gemini. A frase clássica "modelo local é dez vezes mais lento que cloud" parou de valer no momento que a 5090 entrou na conta.

A consequência prática é que o argumento "tempo é dinheiro" muda de figura. No Strix, "esperar 1 hora pra um Qwen 3.5 122B fazer o que o Sonnet faz em 16 minutos" é pura perda. Na 5090, esperar 5 minutos pra o Qwen 3.5 35B-A3B fazer o trabalho, mais 10-15 minutos pra você fazer 1-2 prompts de correção, dá um total na faixa de 20-25 minutos. O Sonnet faz em 16 minutos com zero correção. A diferença ficou pequena o suficiente pra que, se custo importa muito, valha a pena.

A pegadinha: pra que isso valha a pena, o modelo precisa estar perto o suficiente da resposta certa pra que 1-2 prompts de correção resolvam. Quando o erro é do tipo "o modelo decidiu não usar o gem que pedi e devolveu uma string mockada", como fez o Qwen 3 Coder 30B, nenhum prompt de correção fácil arruma. Isso é refazer.

### Antes que você gaste em hardware achando que é a saída

Tenho que dar um aviso, porque é o erro de compra mais comum que vejo agora. Toda hora aparece alguém dizendo que vai pegar um Ryzen AI Max porque tem 128 GB de memória unificada e isso "permite rodar modelos enormes". Tecnicamente, sim — o modelo cabe. Na prática, é quase inutilizável. A memória é LPDDR5x a 256 GB/s, sete vezes mais lenta que a GDDR7 da 5090. O que cabe não roda em velocidade humana. Meu próprio Strix com Qwen 3.5 122B chegou a 22 tok/s e o run levou 43 minutos. Pra fazer qualquer coisa de verdade no dia a dia, isso é impraticável.

A 5090 é claramente superior, e começa a fazer sentido até pra modelos menores justamente por causa da banda de memória. Mac Studio com memória unificada de alta velocidade (até 800 GB/s nos M4 Ultra) é a outra opção viável, e custa proporcionalmente o mesmo. Mas nenhuma das duas chega perto de bater os modelos comerciais em qualidade — e o preço de Claude, GPT ou GLM por token, somado à velocidade brutal de inferência deles, faz a conta ser difícil de justificar pra quem não é entusiasta ou pesquisador. Hardware caro de IA local é hobby de fim de semana, ferramenta pra quem precisa rodar offline por compliance, ou playground de pesquisa. Pra trabalho de produção dia após dia, no momento atual, cloud ainda é a escolha racional. Ryzen AI Max com 128 GB pode parecer tentador na planilha, mas se a ideia é coding agent sério, é dinheiro mal gasto.

## A família Qwen: Coder vs Geral, distilação, e por que nada é bala de prata

Com tantos Qwens diferentes rodando nessa rerodada, dá pra fazer uma análise mais focada. O que aprendi é capaz de surpreender quem segue benchmark de modelo no Twitter.

### Antes de ir aos resultados: o que é quantização e o que é distilação

Os dois conceitos aparecem o tempo todo nessa discussão e merecem uma explicação curta.

**Quantização** é a técnica de comprimir os pesos do modelo pra ocupar menos memória. Um modelo treinado em FP16 (16 bits por peso) pode ser quantizado pra Q8 (8 bits), Q4 (4 bits), Q3_K_M (3 bits, mas com agrupamentos médios), e por aí vai. Cada passo divide o tamanho do modelo em disco e na VRAM, ao custo de uma certa perda de precisão. Q8 é praticamente lossless. Q4 já perde alguma coisa mensurável. Q3 perde mais. Q2 é o limite onde o modelo começa a falar besteira de verdade. A regra de ouro é que pra coding e raciocínio multi-step, vale ficar em Q4 ou acima. Q3_K_M é o mínimo que ainda funciona pra muitos modelos, e é o que cabe num 27B na 5090 com 128k de contexto.

A surpresa do meu teste, e olha que isso vai contra o consenso, é que a quantização não foi o gargalo aqui. Rodei o Qwen 3.5 27B Claude-distilado em duas versões: Q8 no AMD Strix (~27 GB de pesos) e Q3_K_M na 5090 (~12 GB de pesos). Ambos alucinaram exatamente as mesmas APIs falsas do RubyLLM. O Q3_K_M até gerou um Gemfile mais limpo. A limitação do modelo estava no que esses pesos sabem, não na precisão com que eles foram comprimidos.

**Distilação** é a técnica de treinar um modelo menor (o "aluno") pra imitar a saída ou o comportamento de um modelo maior (o "professor"). A versão clássica é distilação de logits — o aluno aprende a aproximar as distribuições de probabilidade do professor. A versão moderna, mais popular pra coding agents, é distilação de **traços de raciocínio** (reasoning traces): você pega cadeias de pensamento do modelo grande pra problemas reais e treina o menor a reproduzir o mesmo estilo de raciocínio.

O hype do momento é distilar Claude e GPT em modelos open source. A promessa é que dá pra ter "Claude-em-casa" rodando local. Eu queria testar isso, e foi por isso que coloquei no benchmark o **[Jackrong's Qwen 3.5 27B distilado do Claude 4.6 Opus](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled)**. Se algum modelo open source ia conseguir usar o RubyLLM corretamente, era essa aposta — afinal, no benchmark inteiro, Claude e GLM 5 são os únicos que acertam a API.

### O que o Claude-distilled aprendeu (e o que não aprendeu)

Rodei a mesma distilação duas vezes: uma em Q8 no AMD Strix (que estourou no timeout de 90 minutos), outra em Q3_K_M na 5090 (completou em 12 minutos). Em ambas, o resultado é a mesma frustração elegante.

O código que sai parece Claude. Tem `# frozen_string_literal: true` no topo de todo arquivo. Tem uma classe `Response` separada como value object com leitores de atributo explícitos. Tem separação clara entre service, controller e model. Tem comentário de doc no topo de cada arquivo. Comenta corretamente coisas como `active_record`, `active_job` e `action_mailer` no `application.rb`. Tem `case` defensivo tentando múltiplos formatos de retorno. Estilisticamente, é Claude.

Funcionalmente, é alucinação completa do RubyLLM. Olha o serviço gerado pelo run da 5090:

```ruby
RubyLLM::Chat.new.with_model(@model) do |chat|
  conversation_history.each do |msg|
    chat.add_message(role: :user, content: msg[:content])
  end
  response = chat.ask(message)
  Response.new(content: response.text, usage: build_usage(response))
end
```

Cada primitiva nesse código é inventada:

- `RubyLLM::Chat.new` — o construtor não é público, o entry correto é `RubyLLM.chat(model:)`
- `.with_model(@model) do |chat| ... end` — não existe API de bloco assim
- `chat.add_message(role:, content:)` — não existe
- `response.text` — a API real expõe `response.content`
- `response.usage.prompt_tokens` — o objeto não tem essa forma

Isso vai estourar `NoMethodError` na primeira request. O initializer também tenta `config.openrouter_api_base=` que não existe no `RubyLLM.configure`, então o app provavelmente nem boota.

A versão Q8 no AMD Strix faz exatamente o mesmo, com uma diferença: a chamada de entrada é `RubyLLM.chat(model:, provider: :openrouter)` — o entry point está certo, mas o `provider:` é inventado e logo em seguida vem o mesmo `chat.add_message(role:, content:)` falso. Pior, o Gemfile do run de 90 minutos lista `gem "ruby-openai"` (gem errada!), `gem "minitest", "~> 6.0"` (não existe minitest 6.0) e `gem "tailwindcss"` (nome errado, é `tailwindcss-rails`). O Gemfile não inclui o gem que o próprio service tenta usar.

Pra comparar, olha o Claude Opus 4.6 baseline real, no mesmo benchmark, acertando tudo:

```ruby
@chat = RubyLLM.chat(model: model_id)
response = @chat.ask(message)
response.content
```

Doze linhas no service inteiro. Sem alucinação. Inclui streaming via bloco. O modelo distilado produziu o triplo do volume de código e errou a API.

A leitura honesta é que distilação transferiu uma camada e parou. A camada que veio junto foi a do estilo: organização do código, comentários, estrutura de classes, ordem das coisas. A camada que ficou pra trás foi a da memória factual sobre bibliotecas específicas. Isso faz sentido quando você pensa: traços de raciocínio do Claude, mesmo escritos com calma, raramente contêm referências repetidas a `chat.ask(msg).content` num gem Ruby obscuro. O aluno só aprende o que o professor repete, e Claude nunca teve motivo pra ficar sussurrando "use ask, não use complete" ao longo das suas cadeias de pensamento. Conhecimento de API de biblioteca é memória binária de recall, do tipo que ou está nos pesos ou não está. Decompor isso em passos de raciocínio é impossível porque não é raciocínio, é só lembrança crua.

Pra fechar com a recomendação prática: se você precisa que o modelo realmente use o RubyLLM, ou qualquer biblioteca menos popular que seja, distilação de Claude não te salva. Use Claude de verdade ou GLM 5. Os "Claude-stand-ins" open source vão falhar do mesmo jeito que o Qwen base falharia, só que com letrinha mais bonita.

### Coder vs Geral: a surpresa dos modelos "pra coding"

A intuição de quase todo mundo é que modelos com "Coder" no nome são os melhores pra programação. Faz sentido, foram fine-tunados especificamente em código. Mas no benchmark, foi exatamente o oposto.

| Modelo | Tipo | Hardware | Tempo | Resultado |
|---|---|---|---:|---|
| Qwen 3.5 35B-A3B | Geral (MoE) | 5090 | 5 min | Roda Rails, alucina `add_message`/`complete` (1-2 follow-ups arrumam) |
| Qwen 3 Coder 30B | Coder | 5090 | 6 min | Devolveu uma string mockada hardcoded em vez de chamar o RubyLLM |
| Qwen 2.5 Coder 32B | Coder | 5090 | timeout 90m | Zero arquivos, modelo travou |
| Qwen 3 32B | Geral | 5090 | 4 min | Scaffold parcial, errors |
| Qwen 3.5 27B Claude-distilado | Geral + distilado | 5090 | 12 min | Roda Rails, alucina API toda |
| Qwen 3.5 27B Sushi Coder RL | Coder (RL) | 5090 | 6 min | Falha de infra, não pôde testar |

Dos três Coders dedicados, dois falharam catastroficamente (timeout total e mock string hardcoded) e um nem rodou direito por bug de infra. Já o Qwen 3.5 35B-A3B, que é o modelo geral da linha (não o Coder), foi o que mais perto chegou de algo aproveitável: 5 minutos de execução, projeto Rails reconhecível, e o problema dele se conserta em 1-2 prompts.

O Qwen 3 Coder 30B é particularmente decepcionante. Ele passou longe de qualquer tentativa séria de usar a API: o controller que ele gerou tem isso:

```ruby
class Api::V1::MessagesController < ApplicationController
  def create
    render json: {
      response: "This is a mock response. In a real implementation, this would connect to RubyLLM with Claude Sonnet via OpenRouter."
    }
  end
end
```

O Gemfile lista `gem "ruby_llm"` mas nada importa. O service layer é inexistente. O modelo decidiu que era mais fácil devolver uma string fake e seguir a vida. Isso é Tier 3 garbage de uma forma que nem prompt de correção arruma — tem que mandar reescrever do zero.

O Qwen 2.5 Coder 32B é ainda pior: 90 minutos rodando, zero arquivos. O `opencode-output.ndjson` de 1.8 MB mostra o modelo girando sem conseguir escrever nada. Provavelmente entrou em loop de planejamento sem nunca chamar as ferramentas de write. Total perda de slot.

Por que os "Coder" Qwens foram tão mal? Minha leitura é que o fine-tuning específico pra coding deles foi treinado em problemas mais isolados (Codeforces, Leetcode, snippets curtos), longe dos fluxos agentic com tool calling de longa duração. O modelo geral Qwen 3.5 35B-A3B tem treinamento mais amplo e se vira melhor com a parte de orquestração. A intuição popular "Coder = melhor pra coding agent" tá errada pra esse tipo de tarefa. O caso de uso onde os Coders se saem bem é "completar uma função isolada", que é exatamente pro que eles foram treinados, e isso é uma fração pequena do que um coding agent faz no dia a dia.

### A pergunta que eu queria responder

Era essa: rodando local na 5090, qual modelo Qwen vale o 1-2 prompts de correção pra entregar código que funcione?

A resposta honesta é: só o Qwen 3.5 35B-A3B, e talvez o Claude-distilado se você não se importa de gastar 12 minutos a mais.

- Qwen 3.5 35B-A3B na 5090: 5 minutos, entry point certo (`RubyLLM.chat(model:)`), erros nas chamadas seguintes. Total realista até funcionar: na faixa de 15-20 minutos com 1-2 follow-ups. Bate cloud OSS na conta de custo.
- Qwen 3.5 27B Claude-distilado na 5090: 12 minutos, alucinação mais profunda (entry point inventado também). Total realista: 25-30 minutos com 2-3 follow-ups. Ainda compete em custo, e perde em tempo absoluto pro Claude real.
- Os outros (Coder 30B, Coder 2.5 32B, 3 32B): não recompensam o tempo de correção. Cada um tem um problema estrutural que pede reescrita inteira do zero.

Pra quem tem hardware nessa categoria e quer fugir do vendor lock-in da Anthropic, agora dá. Não dava na 5090 do ano passado, no Strix Halo então, esquece. Em 2026, na NVIDIA Blackwell, com o modelo certo, dá. Pra quem tem hardware de banda baixa (LPDDR5x, DDR4, DDR5), continua sendo perda de tempo: o relógio sozinho derruba qualquer plano de tornar isso prático.

### Qwen 3.6: o que mudou em relação ao 3.5

Testamos dois sabores do Qwen 3.6: o **3.6 Plus** (cloud, OpenRouter, grátis) e o **3.6 35B** (local, NVIDIA 5090, Q3_K_M).

O Qwen 3.6 Plus (cloud) completou em 17 minutos com 88.940 tokens e 9/9 no checklist de artefatos. Completou rápido e de graça. Mas o serviço gerado usa `chat.add_message()`, método que não existe no RubyLLM. A primeira mensagem funciona, a segunda quebra. O mesmo problema do 3.5.

O Qwen 3.6 35B (local, 5090) é mais interessante. Completou em 4.7 minutos a 240 tok/s, 169 arquivos, entry point `RubyLLM.chat(model:, provider:)` correto e `chat.ask(message)` correto. O bug é mais sutil: retorna `response` em vez de `response.content` e não faz replay de histórico. Correção de 1 linha. Isso é uma melhoria real sobre o Qwen 3.5 35B-A3B (que alucinava `add_message` e `complete`). É o resultado Qwen mais limpo que vimos até agora.

| Modelo | Versão | Hardware | API correta? | Multi-turn funciona? | Tempo | Tok/s |
|---|---|---|:---:|:---:|---:|---:|
| Qwen 3.5 35B-A3B | 3.5 | NVIDIA 5090 | Entry point sim, `add_message`/`complete` não | Não | 5m | 273 |
| Qwen 3.5 27B Claude-distilado | 3.5 | NVIDIA 5090 | Não (entry point inventado) | Não | 12m | 129 |
| Qwen 3.6 35B | 3.6 | NVIDIA 5090 | Entry point sim, `chat.ask` sim, falta `.content` | Não (sem replay) | 5m | 240 |
| Qwen 3.6 Plus | 3.6 | Cloud | Entry point sim, `add_message` não | Não | 17m | 183 |

O gap diminuiu mas não fechou. O 3.6 35B local está mais perto de funcionar que qualquer Qwen anterior — o bug é um `.content` esquecido, não uma API inteira inventada. Mas continua sem multi-turn funcional de primeira. Na prática, o Qwen 3.6 35B local sobe do Tier 3 pro Tier 2: é o modelo open source local que mais perto chega de entregar código correto no primeiro try, a uma correção de distância.

## O Deep Code Review: Sonnet vs GLM 5 vs Gemini vs Kimi vs MiniMax

As tabelas acima medem completude estrutural. Mas o projeto funciona? Fiz code review detalhado dos modelos que completaram o benchmark.

**Claude Sonnet 4.6 — funciona e é o mais completo.** Respostas síncronas via Turbo Stream. Histórico de chat persistido em session cookie com replay completo das mensagens anteriores a cada request. Mocking correto do LLM nos testes com mocha (30 testes em 328 linhas). Lógica de LLM extraída pra um `LlmChatService` separado. Views decompostas em 9 partials. Problemas menores: constante de modelo duplicada, leak no event listener do auto-resize. Nenhum é blocker. Dos projetos gerados, é o que mais se aproxima de algo que você colocaria em produção.

**GLM 5 — funciona, mas é o mínimo viável.** Usa a API correta (`RubyLLM.chat(model:)` depois `.ask()`), faz mocking com mocha nos testes. Só que o projeto é bem mais enxuto que o do Sonnet: controller de 21 linhas (vs 52 do Sonnet), sem service layer (lógica LLM inline no controller), sem persistência de histórico de chat, cada mensagem tratada isoladamente. A primeira mensagem funciona, mas o app não mantém contexto de conversação, então não dá pra ter um diálogo multi-turn. Os testes existem (7 métodos) mas são esqueléticos: o `ruby_llm_test.rb` só checa se o módulo está carregado, o `chat_flow_test.rb` é cópia do controller test. O Dockerfile, por outro lado, é o melhor dos quatro: multi-stage, non-root, jemalloc. Mas como app de chat? É mais uma prova de conceito do que algo funcional. Detalhe engraçado: o README diz "Powered by Claude Sonnet 4" em vez do modelo que realmente gerou o projeto.

**Gemini 3.1 Pro — o mais rápido, mas tropeça na API.** Completou em 14 minutos, o mais rápido junto com o MiniMax. O código Rails em si é bem feito: usa `Rails.cache` com session ID e expiração de 2 horas pra manter estado (em vez de banco de dados), Turbo Streams bem integrados, Stimulus controller pra scroll automático, e o Dockerfile é o melhor do grupo (multi-stage, non-root, jemalloc). O problema é o de sempre: usa `RubyLLM::Chat.new()` em vez de `RubyLLM.chat()`, e chama `add_message()` que não existe. O app boota, o Docker roda, o health check passa, mas a primeira mensagem de chat dá 500. Os testes (5 métodos) mockam com um `FakeChat` que replica a assinatura errada, então passam. É frustrante porque o resto do código é o mais "Rails way" dos modelos que não são Anthropic. Corrigir seriam 3 linhas, mas o benchmark mede o que sai de primeira.

**Kimi K2.5 — ambicioso mas quebrado.** Tentou a arquitetura mais sofisticada: ActionCable streaming, modelos configuráveis, dual Dockerfiles, 37 testes em 374 linhas. Problema: o streaming depende do ActionCable, que está comentado no `config/application.rb`. O guard `return unless defined?(ActionCable)` faz o método não fazer nada. O assistente nunca responde. O Stimulus controller tem bug de escopo: o `submitTarget` referencia um botão fora da subtree do controller. Storage thread-unsafe com hash em variável de classe. O Kimi escreveu mais testes que qualquer outro modelo (37), mas nenhum mocka as chamadas LLM — então os testes passam sem provar que a funcionalidade funciona de verdade.

**Grok 4.20 — rápido e errado.** Foi o mais rápido do benchmark inteiro: 8 minutos, 412 tok/s. Só que foi rápido porque cortou caminho. O prompt pedia explicitamente o gem `ruby_llm`, e o Grok ignorou. Foi direto no `OpenAI::Client` da gem `ruby-openai` apontando pra URL do OpenRouter. Tecnicamente a primeira mensagem volta, então sim, "funciona". Mas é o mesmo truque do Step 3.5 Flash e do Qwen 3.5 122B: pula a peça que tava sendo testada. Sem histórico, controller de 33 linhas chamando o cliente HTTP no braço, dois testes, nenhum mock de verdade. Foi rápido porque fez menos do que pediram.

**MiniMax M2.7 — parece certo, crasha.** Chama `RubyLLM.chat(model: '...', messages: [...])` — essa assinatura não existe. Sem persistência de mensagens. HTML duplicado (DOCTYPE dentro do layout). master.key commitada. E os testes? Mockam a API errada, então passam mas não provam nada.

Resumo do code review:

| Aspecto | Sonnet 4.6 | GLM 5 | Gemini 3.1 Pro | Kimi K2.5 | MiniMax M2.7 |
|---|:---:|:---:|:---:|:---:|:---:|
| API correta | Sim | Sim | Não | Não | Não |
| Histórico de chat | Session cookie | Nenhum | Rails.cache (2h) | Broken (ActionCable off) | Nenhum |
| Service layer | LlmChatService | Inline no controller | LlmService | LlmService | ChatService (API errada) |
| Testes (métodos) | 30 | 7 | 5 | 37 | 12 |
| Mocking LLM | Sim (mocha) | Sim (mocha) | FakeChat (API errada) | Não | Mock da API errada |
| Dockerfile | Multi-stage | Multi-stage + jemalloc | Multi-stage + jemalloc | Dual (dev/prod) | Single-stage |
| Roda de verdade? | Sim | Sim (sem histórico) | Não (500 no chat) | Não | Não |

### GLM 5 vs GLM 5.1: o que mudou

O GLM 5 foi um dos poucos modelos que cuspiu código funcional de primeira, então era óbvio testar a versão nova. Um detalhe que importa antes dos números: o GLM 5 rodou via OpenRouter, o GLM 5.1 ainda não tava lá quando rodei o teste, então usei a API direta da Z.AI. Provedor diferente, infra diferente, cache diferente. Os números abaixo são referência, não medida exata.

| Aspecto | GLM 5 | GLM 5.1 |
|---|---|---|
| Provedor | OpenRouter | Z.AI direto |
| Tempo total | 17m | 22m |
| Tok/s (final phase) | 400 | 167 |
| Tokens efetivos novos | 1.138 | 450 |
| Cache lido | 58.240 | 81.216 |
| API RubyLLM correta | Sim | Sim |
| Mocking nos testes | Sim (mocha) | Sim |
| Testes | 7 | 24 |
| Histórico de chat | Não | Sim (in-memory) |
| Service layer | Inline no controller | `ChatSession` model com `add_user_message`/`add_assistant_message` |

O projeto do GLM 5.1 ficou bem mais completo. 24 testes contra 7. Separação real entre `ChatSession`, `ChatMessage` e o controller, em vez do GLM 5 botando tudo inline. Histórico de chat persistido em memória durante a sessão, então dá pra ter uma conversa multi-turn de verdade (o GLM 5 tratava cada mensagem como se fosse a primeira). E a API do RubyLLM continua correta, mesmo padrão `RubyLLM.chat(model:, provider:)` seguido de `c.user`/`c.assistant` pra montar o contexto. Tem até teste cobrindo a constante `MODEL`, coisa que normalmente ninguém faz.

O preço foi velocidade. 22 minutos contra 17, e a vazão caiu de 400 pra 167 tok/s. Pode ser provedor (Z.AI direto não é a mesma infra do OpenRouter), pode ser um run mais carregado no servidor, pode ser que o 5.1 raciocine mais. Não rodei várias vezes pra fazer média, então não vou dizer que o 5.1 é "mais lento". Uma run só não prova regressão. O que dá pra dizer é que, no meu teste, o 5.1 entregou um projeto melhor estruturado e demorou um pouco mais pra fazer isso.

Pra quem quer fugir da Anthropic sem perder qualidade, GLM 5 e GLM 5.1 são as duas opções que funcionam. Se você precisa de billing centralizado no OpenRouter, GLM 5. Se consegue usar a Z.AI direto e quer um projeto mais redondo de primeira, GLM 5.1.

## Custos: API vs Assinatura

Primeiro, o preço por token de cada modelo no OpenRouter:

![Preço por token no OpenRouter](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/05/llm-benchmark/en/token-pricing.png)

O GPT 5.4 Pro cobra $180 por milhão de tokens de output. O Claude Opus cobra $25. O GLM 5 cobra $2.30. E o Qwen 3.6 Plus é grátis (com rate limit). A escala logarítmica no gráfico esconde um pouco a brutalidade da diferença: de Qwen grátis pra GPT 5.4 Pro são ordens de magnitude.

Mas preço por token não é a história completa. Se você usa Claude ou GPT diariamente pra coding, a assinatura mensal pode sair muito mais barata que pagar por token via API:

![Assinatura vs API: quanto custa usar Claude e GPT por mês](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/05/llm-benchmark/en/monthly-pricing.png)

| Abordagem | Est. $/mês* | Notas |
|---|---:|---|
| Qwen 3.6 Plus (OpenRouter) | $0 | Grátis mas rate-limited |
| Modelos locais | Eletricidade | Precisa de hardware |
| Claude Pro | $20 | ~44K tokens/5hr |
| ChatGPT Plus | $20 | Inclui Codex |
| Claude Max 5x | $100 | ~88K tokens/5hr |
| Claude Sonnet (OpenRouter API) | ~$150 | Sem cap, pay-as-you-go |
| Claude Max 20x | $200 | ~220K tokens/5hr |
| ChatGPT Pro | $200 | GPT 5.4 Pro ilimitado |
| Claude Opus (OpenRouter API) | ~$450 | Sem cap, pay-as-you-go |
| GPT 5.4 Pro (OpenRouter API) | ~$990 | Absurdamente caro |

*Estimativa pra uso moderado de coding (~15M input + ~3M output tokens/mês).

O ponto principal: se você usa GPT 5.4 Pro, a assinatura ChatGPT Pro a $200/mês com uso ilimitado é 5x mais barata que pagar por token na API. Pra Claude, o Pro a $20/mês cobre uso leve, mas pra quem usa pesado (maratona de coding como a minha), o Max 20x a $200/mês sai mais barato que pagar Opus por token no OpenRouter (~$450/mês). Os modelos open source no OpenRouter ficam todos abaixo de $2.50/M output tokens, mas como vimos, a maioria gera código que não roda.

## O que funciona pra uso real

Depois de testar 33 modelos ao longo das duas rodadas e olhar o código gerado em detalhe:

Tier 1 (funciona plug and play):

| Modelo | Qualidade | Custo/Run | Trade-off |
|---|---|---:|---|
| Claude Opus 4.7 | Novo baseline (28 testes, FakeChat, 96.7% cobertura) | ~$1.10 | Incremental sobre 4.6, novo gold standard |
| Claude Sonnet 4.6 | Melhor que Opus 4.6 no opencode (30 vs 16 testes) | ~$0.63 | Mais barato, mas no Claude Code o Opus pode se sair melhor |
| Claude Opus 4.6 | Gold standard anterior | ~$1.05 | Baseline anterior |
| GLM 5 | Bom (7 testes, API correta) | ~$0.11 | 89% mais barato, alternativa non-Anthropic/OpenAI que funciona |
| GLM 5.1 | Bom (24 testes, histórico, API correta) | ~$0.13 | ~88% mais barato, projeto mais completo que o GLM 5 |

Tier 2 (funciona com ressalvas):

| Modelo | Hardware | Custo/Run | Ressalva |
|---|:---:|---:|---|
| GPT 5.4 (Codex) | Cloud | ~$16.00 | Arquitetura impressionante (22 testes, injeção de dependência, PORO models), mas `add_message` com keyword args em vez de hash posicional quebra multi-turn. 7.6M tokens, 15x mais caro que Opus |
| Step 3.5 Flash | Cloud | ~$0.02 | Bypassa o gem pedido, lento (38m) |
| Grok 4.20 | Cloud | ~$0.04 | Bypassa o gem pedido (vai direto pro `OpenAI::Client`), mas é o mais rápido do benchmark |
| Qwen 3.6 35B | NVIDIA 5090 | Grátis | Entry point e `chat.ask` corretos, falta `.content`. Correção de 1 linha. ~10-15 min total |
| Qwen 3.5 35B-A3B | NVIDIA 5090 | Grátis | Entry point certo, alucina `add_message`/`complete`. Dá pra arrumar em 1-2 follow-ups. ~15-20 min total |
| Qwen 3.5 27B Claude-distilado | NVIDIA 5090 | Grátis | Estilo Claude, alucinação completa da API. 2-3 follow-ups pra arrumar. ~25-30 min total |
| Qwen 3.5 35B (local) | AMD Strix | Grátis | Funciona se default configurado, sem mocking, e lento |

Tier 3 (código quebrado, mesmo com prompts de correção é mais fácil refazer):

Kimi K2.5, MiniMax M2.7, DeepSeek V3.2, Gemini 3.1 Pro, Qwen 3 Coder Next (Strix), Qwen 3 Coder 30B (5090, devolveu mock string hardcoded), Qwen 3.5 122B, Qwen 3.6 Plus — todos inventam APIs que não existem ou nem tentam usar o gem.

Tier 4 (não completaram):

Gemma 4 (loop infinito nos dois hardwares), Llama 4 Scout (sem parser), GPT OSS 20B (diretório errado no Strix, regressão de parser na 5090), Qwen 3 32B (lento demais no Strix, scaffold parcial na 5090), Qwen 2.5 Coder 32B (timeout 90m com zero arquivos).

### Ranking simplificado (qualidade, tempo, preço)

Pra quem quer só o resumão em forma de boletim escolar. Qualidade é se o código roda e quão completo está. Tempo é o tempo total do run. Preço é o custo estimado por execução no opencode. **Hardware** indica onde o modelo rodou — Cloud, Strix (AMD Strix Halo, LPDDR5x 256 GB/s) ou 5090 (NVIDIA RTX 5090, GDDR7 1792 GB/s). Modelos cloud rodaram via OpenRouter ou API direta do provedor.

| Modelo | Tipo | Hardware | Qualidade | Tempo | Preço |
|---|:---:|:---:|:---:|:---:|:---:|
| Claude Opus 4.7 | Commercial | Cloud | A+ | A | D |
| Claude Sonnet 4.6 | Commercial | Cloud | A+ | A | C |
| Claude Opus 4.6 | Commercial | Cloud | A+ | A | D |
| GPT 5.4 (Codex) | Commercial | Cloud | B+ | B | F |
| GLM 5.1 | OSS | Cloud | A | B | A |
| GLM 5 | OSS | Cloud | A− | A | A |
| Qwen 3.6 35B | OSS | 5090 | B+ | A+ | A+ (grátis) |
| Qwen 3.5 35B-A3B | OSS | 5090 | B | A+ | A+ (grátis) |
| Qwen 3.5 27B Claude-distilado | OSS | 5090 | C+ | B | A+ (grátis) |
| Gemini 3.1 Pro | Commercial | Cloud | C | A+ | B |
| Grok 4.20 | Commercial | Cloud | C− | A+ | A+ |
| Step 3.5 Flash | Commercial | Cloud | C− | D | A+ |
| Qwen 3.5 35B-A3B | OSS | Strix | C | C | A+ (grátis) |
| Qwen 3 Coder Next | OSS | Strix | D+ | A | A+ (grátis) |
| Qwen 3 32B | OSS | 5090 | D | A+ | A+ (grátis) |
| Qwen 3 Coder 30B | OSS | 5090 | D− | A+ | A+ (grátis) |
| Qwen 3.6 Plus | Commercial | Cloud | D | A | A+ (grátis) |
| Kimi K2.5 | OSS | Cloud | D | C | A |
| MiniMax M2.7 | OSS | Cloud | D | A | A+ |
| Qwen 3.5 122B | OSS | Strix | D | F | A+ (grátis) |
| DeepSeek V3.2 | OSS | Cloud | F | F | A+ |
| Qwen 2.5 Coder 32B | OSS | 5090 | F | F | A+ (grátis) |
| Gemma 4 31B | OSS | 5090 | F | A+ | A+ (grátis) |
| Gemma 4 31B | OSS | Strix | F | — | A+ (grátis) |
| GLM 4.7 Flash | OSS | Strix | F | — | A+ (grátis) |
| Llama 4 Scout | OSS | Strix | F | — | A+ (grátis) |
| GPT OSS 20B | OSS | Strix | F | — | A+ (grátis) |
| Qwen 3 32B | OSS | Strix | F | — | A+ (grátis) |

Critério de qualidade: A+ funciona e o código está bem estruturado. A/B funciona com ressalvas pequenas a médias. C roda mas pula requisito do prompt ou tem problema estrutural sério. D quebra na primeira mensagem por API inventada. F não completou o benchmark ou produziu lixo. O GPT 5.4 via Codex caiu de A+ pra B+: a arquitetura é a mais sofisticada do benchmark (injeção de dependência, PORO models, 22 testes), mas a primeira mensagem funciona e o multi-turn quebra por convenção de chamada errada no `add_message`. Gastou 7.6M tokens (~$16/run) sem atingir o nível de acerto do Opus. "Tipo" separa modelos commercial (pesos fechados) dos OSS (pesos abertos, mesmo quando você usa via API hospedada). Os Qwens aparecem duas vezes quando rodaram nos dois hardwares, porque os resultados são diferentes o suficiente pra justificar — o Qwen 3.5 35B-A3B no 5090 sobe pro Tier B, no Strix continua no Tier C por causa do tempo de espera. Dos 33 modelos configurados ao longo das duas rodadas, alguns ficam de fora dessa tabela porque nem chegaram a executar (sem quota, runner quebrado, falha de infra, ou timeout antes da primeira mensagem).

### O veredito

Se quer o melhor resultado e não quer pensar: **Claude Opus**. O Opus 4.7 é o novo baseline — 28 testes, API correta, 96.7% de cobertura, FakeChat pattern nos testes. É melhoria incremental sobre o 4.6 (que tinha 16 testes), não uma revolução. Mas não precisa ser revolução. O 4.6 já funcionava, o 4.7 funciona igual e entrega um projeto um pouco mais polido. Se você estava no 4.6, atualizar pro 4.7 é trocar pra um modelo que faz a mesma coisa com mais capricho nos testes e na estrutura.

Um aviso sobre o Sonnet: ele ganhou do Opus nesse benchmark (30 testes vs 16 do Opus 4.6, vs 28 do Opus 4.7). Mas esse benchmark é um app web pequeno e bem definido. Na minha experiência real com projetos maiores, o Sonnet falha quando o raciocínio precisa ir mais fundo. Não estou falando de projetos imensos — basta ir um pouco além desse benchmark (mais controllers, mais integrações, decisões arquiteturais que dependem umas das outras) e o Sonnet começa a perder o fio da meada. O Opus tem teto de output de 128K tokens contra 64K do Sonnet, e o treinamento dele foi especificamente pra tarefas de longo prazo, planejamento multi-etapas e raciocínio profundo sobre código complexo. Num projeto pequeno como o do benchmark, esses músculos ficam parados, e nesse cenário Sonnet ganha por ser mais rápido e mais barato. Mas se você extrapolar isso pra "Sonnet é melhor que Opus", vai levar um susto na primeira tarefa que exija raciocínio sustentado. Pode experimentar o Sonnet, é mais barato e pros projetos pequenos funciona. Mas pra projetos reais, você provavelmente vai acabar no Opus de qualquer jeito.

Sobre o GPT 5.4: agora temos dados objetivos. Rodei via Codex CLI com reasoning effort xHigh. A arquitetura que ele gera é a mais sofisticada do benchmark — injeção de dependência, PORO models, session management com TTL. Mas gastou 7.6M tokens (~$16/run, 15x mais caro que Opus) e errou a convenção de chamada do `add_message` (keyword args em vez de hash posicional), quebrando o multi-turn. Gastou mais, errou igual. Caiu do Tier 1 pro Tier 2. O padrão se repete: acerto de API é memória binária nos pesos. Não escala com budget de tokens nem com reasoning effort.

Se custo importa e você quer sair da Anthropic: **GLM 5 ou GLM 5.1** são as alternativas plug-and-play que funcionam. API correta, mocking nos testes, ~$0.11-$0.13 por run, ~88-89% mais barato que Opus. O GLM 5.1 entregou um projeto mais completo (24 testes, histórico de chat) ao custo de uns 5 minutos a mais.

Se quer evitar vendor lock-in total e tem hardware decente: **Qwen 3.5 35B-A3B** rodando local numa NVIDIA RTX 5090. Cinco minutos de execução a 273 tok/s, projeto Rails que arranca, e o erro de API se conserta em 1-2 follow-ups. Total realista até funcionar: ~15-20 minutos. Bate o Sonnet em custo (zero) e fica perto em tempo total. Essa opção simplesmente não existia na rodada anterior do benchmark, e marca o ponto onde "rodar OSS local" deixa de ser brincadeira e vira alternativa real. Importante: isso é específico de hardware com banda de memória alta. Numa RTX 4090 deve funcionar parecido. Num laptop com LPDDR5x ou num desktop com DDR4, esquece — você vai esperar 10x mais e o tempo total mata o argumento.

Se quer evitar vendor lock-in mas está em hardware fraco: **GLM 5 ou GLM 5.1** continuam sendo a escolha. São cloud, é verdade, mas a $0.11-$0.13 por run é praticamente preço de eletricidade.

Se quer testar a aposta "Claude em casa" via distilação: o **Qwen 3.5 27B Claude-distilado** tá lá pra brincar, mas já avisei que ele alucina exatamente as mesmas APIs falsas do Qwen base. Distilação transferiu o estilo do Claude, não o conhecimento factual sobre bibliotecas. Vale como experimento, não como produção.

Sim, talvez com dias de tweaking no llama.cpp, calibrando flags, ajustando prompts, testando builds diferentes, dê pra fazer o Gemma 4 ou outros modelos funcionarem melhor. Pra maioria das pessoas, isso não é realista. A distância entre modelos frontier (Claude, GPT) e modelos open source self-hosted é real. Não é marketing. O gap está diminuindo, mas continua existindo, e a natureza dele mudou: hoje o que falta nos open source é conhecimento factual sobre bibliotecas específicas, não capacidade bruta de raciocínio. Hardware deixou de ser o gargalo, pelo menos pra quem tem GPU recente.

No fim, o que importa é se o código roda. Um modelo pode gerar 3.405 arquivos, escrever 37 testes, produzir um README de 181 linhas, e ainda assim o app não funcionar porque a API que ele usa não existe. Métricas de completude e contagem de testes são necessárias mas não suficientes. O único sinal confiável é se o modelo usa APIs reais corretamente.

O benchmark completo, com código, configuração, prompts e resultados por modelo, está no [GitHub](https://github.com/akitaonrails/llm-coding-benchmark).
