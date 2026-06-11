---
title: "LLM Benchmark: Fable 5 e a novela da Anthropic"
slug: "llm-benchmark-fable-5-e-a-novela-da-anthropic"
date: '2026-06-11T14:00:00-03:00'
draft: false
translationKey: llm-benchmark-fable-5-anthropic-soap-opera
tags:
  - llm
  - benchmark
  - claude
  - anthropic
  - fable
  - mythos
  - ai
  - vibecoding
---

A Anthropic lançou o **Claude Fable 5** essa semana, e antes de chegar nos números do meu benchmark (spoiler: empate técnico com Opus), vale recontar a novela inteira, porque o contexto importa mais que o modelo. E é uma novela mexicana das boas, com modelo secreto "perigoso demais", consórcio fechado de big techs, IPO à vista e marketing agressivo.

## O contexto: a panela de pressão

As empresas de modelo de fronteira estão espremidas dos dois lados. De um lado, competem entre si pra treinar o próximo modelo que supere o anterior. Do outro, a demanda por **inferência** explodiu. A curva inverteu: segundo a [Deloitte](https://www.deloitte.com/us/en/insights/industry/technology/technology-media-and-telecom-predictions/2026/compute-power-ai.html), em 2023 a inferência era cerca de **um terço** de todo o compute de IA; em 2025 virou metade; em 2026 já é **dois terços**, [caminhando pra ~70% até 2030](https://www.computerworld.com/article/4114579/ces-2026-ai-compute-sees-a-shift-from-training-to-inference.html). Há dois anos a maior parte dos data centers servia pra treinar modelo novo. Hoje a maior parte serve pra atender você e eu conversando com chatbot e rodando coding agent.

Soma-se a isso o retorno decrescente do treinamento. Dobrar parâmetros e compute de treino entrega o quê, 10%, 20% de melhora percebida? O salto de mais uma ordem de magnitude ficou caro demais justamente na hora em que o compute ficou escasso.

E a infraestrutura aperta ainda mais. Alphabet, Amazon, Meta e Microsoft devem gastar mais de [**US$ 650 bilhões em 2026**](https://www.tomshardware.com/tech-industry/artificial-intelligence/half-of-planned-us-data-center-builds-have-been-delayed-or-canceled-growth-limited-by-shortages-of-power-infrastructure-and-parts-from-china-the-ai-build-out-flips-the-breakers) expandindo capacidade de IA. O dinheiro existe, o problema é que ele tem onde ser gasto mas demora pra virar prédio: [quase metade dos data centers planejados nos EUA pra 2026 foi adiada ou cancelada](https://www.techradar.com/pro/if-one-piece-of-your-supply-chain-is-delayed-then-your-whole-project-cant-deliver-nearly-half-of-us-data-centers-planned-for-2026-canceled-or-delayed-and-things-could-soon-get-much-worse), uns 7 GW dos 12 GW anunciados. O gargalo virou transformador, painel de distribuição e bateria, componentes elétricos que dependem pesadamente da China, com prazo de entrega de transformador de subestação [passando de 160 semanas](https://theoutpost.ai/news-story/america-s-ai-build-out-stumbles-on-electrical-parts-shortage-and-china-dependency-25093/). Três anos de fila por uma peça. Não vai chover data center novo tão cedo.

A conclusão lógica dessa conta: se não dá pra treinar o próximo monstro, otimiza o que já tem. E é exatamente o que OpenAI e Anthropic vêm fazendo. O GPT 5 recebeu upgrades contínuos: 5.1, 5.2, 5.3, 5.4, 5.5. O Opus foi do excelente 4.5 pro 4.6, 4.7, 4.8. Cada versão nova com resultado misto, às vezes um pouco melhor, às vezes um pouco pior, porque o objetivo principal virou servir mais gente com o mesmo hardware, e "mais inteligência" entra na fila atrás disso. Mexem na profundidade do reasoning, no caching, nos prompts de sistema. São caixas fechadas, a gente só pode adivinhar. Eu mesmo documentei isso na [Parte 3 do benchmark](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/): o Opus 4.7 ficou objetivamente melhor em código que o 4.6 e ao mesmo tempo a comunidade reclamou (com razão) do comportamento mais econômico de tokens. Otimização de recurso tem cara disso.

## Os IPOs

Aí entra o ingrediente financeiro. A Anthropic [protocolou o S-1 confidencial na SEC em 1º de junho](https://techcrunch.com/2026/06/08/following-anthropic-openai-files-confidentially-for-ipo/), depois de uma Series H de US$ 65 bilhões que avaliou a empresa em ~US$ 965 bilhões. A OpenAI [protocolou o dela uma semana depois](https://techcrunch.com/2026/06/08/following-anthropic-openai-files-confidentially-for-ipo/), em 8 de junho. Datas? Oficialmente não existem: protocolo confidencial significa que o cronograma depende da revisão da SEC e do humor do mercado. Tem [especulação de janela pro fim de outubro](https://www.thinkmarkets.com/en/anthropic-ipo-2026-date-valuation-and-how-to-trade/) no caso da Anthropic, mas é projeção de corretora, dado não-oficial. O que dá pra cravar: [as duas estão na fila, juntas, agora](https://www.cnn.com/2026/06/09/tech/openai-ipo-anthropic-wall-street).

E empresa às vésperas de IPO quer mostrar curva de crescimento de usuário. Então o jogo é captar o máximo de clientes novos possível, subsidiando preço pesadamente, enquanto administra a escassez de data center. Segura essa contradição na cabeça: precisa crescer uso num momento em que servir o uso existente já está apertado.

## A novela do Mythos

É nesse cenário que a Anthropic embarcou numa campanha de marketing agressiva em volta do modelo **Mythos**. A cronologia:

Em 7 de abril, a Anthropic [anunciou o Claude Mythos Preview](https://red.anthropic.com/2026/mythos-preview/), um modelo de fronteira que ela mesma decidiu **não lançar publicamente** por ser "perigoso demais". A alegação: o Mythos teria encontrado milhares de vulnerabilidades de alta severidade, incluindo em todo sistema operacional e navegador relevante. Os números divulgados depois: [23 mil vulnerabilidades potenciais em mil projetos open source, das quais 1.726 confirmadas, mais de mil de severidade alta ou crítica](https://www.securityweek.com/anthropic-mythos-detected-23000-potential-vulnerabilities-across-1000-oss-projects/amp/).

Em vez de lançar, criou o [**Project Glasswing**](https://www.anthropic.com/glasswing): um consórcio fechado com mais de 40 empresas gigantes (Apple, Amazon, Microsoft, Google, NVIDIA, Cisco, JPMorganChase, Linux Foundation, CrowdStrike, Palo Alto Networks) com acesso exclusivo ao modelo pra encontrar e corrigir vulnerabilidades nos próprios sistemas **antes** do lançamento público. Ou seja: as big techs ganharam meses de vantagem pra se blindar contra uma capacidade que o resto do mundo nem pode testar.

A recepção foi dividida. A [CNBC descreveu uma "histeria" de cibersegurança](https://www.cnbc.com/2026/05/08/anthropic-mythos-ai-cybersecurity-banks.html) em bancos e empresas, com especialistas ponderando que esse tipo de ameaça já existia antes do anúncio. Colunistas começaram a perguntar [se o Mythos é perigoso mesmo ou se é só hype inflado](https://torment-nexus.mathewingram.com/anthropics-new-mythos-model-dangerous-or-over-hyped/), e [a Puck levantou a questão óbvia](https://puck.news/is-anthropics-mythos-model-as-dangerous-as-everyone-says/): empresa pré-IPO tem todo incentivo do mundo pra inflar a percepção de capacidade do próprio produto. Pra completar a novela, [um grupo não-autorizado conseguiu acesso ao Mythos](https://cybersecuritynews.com/anthropic-mythos-access/) através do ambiente de um fornecedor terceirizado. O modelo perigoso demais pra ser lançado vazou pela porta dos fundos.

Repara no desenho da coisa: um modelo que ninguém de fora pode testar, com alegações de capacidade que ninguém pode verificar, guardado por um consórcio que assina NDA. Nem sabemos com certeza o que é o Mythos. Se é um modelo novo treinado do zero (e nesse caso, de onde saiu o compute, na seca de data center que descrevi acima?), se é um Opus com um arsenal pesado de ferramentas de segurança ofensiva em volta, se é outra coisa. Só podemos especular, e é exatamente assim que hype funciona.

## Fable 5: o "Mythos seguro"

Em 9 de junho, [a Anthropic lançou o **Claude Fable 5**](https://www.anthropic.com/news/claude-fable-5-mythos-5), que ela descreve como um modelo "Mythos-class" seguro pra lançamento público. Na mesma tacada, anunciou o **Mythos 5**: [o mesmo modelo sem as travas, disponível só pro consórcio do Glasswing](https://www.bloomberg.com/news/articles/2026-06-09/anthropic-releases-mythos-like-model-without-cyber-capabilities). O que é o Fable por dentro? Um Opus destilado com Mythos? Um Mythos lobotomizado? Caixa fechada, sem paper técnico, adivinha de novo.

O mecanismo de segurança é curioso: queries que tocam em exploração de cibersegurança, armas bio/químicas ou destilação de modelo são bloqueadas no nível do modelo e [**redirecionadas pro Opus 4.8**](https://www.itpro.com/technology/artificial-intelligence/anthropic-just-launched-claude-fable-5-its-first-mythos-class-ai-model-but-it-has-new-safeguards-to-prevent-misuse-and-will-fall-back-to-opus-4-8-for-high-risk-queries), algo que a Anthropic estima acontecer em menos de 5% das sessões.

Na prática, os safeguards saíram calibrados estritos demais. O Register publicou um teste com o título impagável ["It blocked us at 'hello!'"](https://www.theregister.com/ai-and-ml/2026/06/10/anthropic-claude-fable-5-refuses-innocuous-prompts/5253754), documentando recusas de prompts inócuos, e [a internet está justificadamente furiosa](https://decrypt.co/370688/internet-furious-anthropic-claude-mythos-fable-5). Eu esbarrei nisso em primeira mão: pedir pro Fable **auditar a segurança do meu próprio código** pode disparar a trava de "perigoso demais" e cair no fallback pro Opus. Pesquisador de segurança pedindo auditoria do próprio código-fonte é exatamente o caso de uso que um "Mythos seguro" deveria atender, e é o que ele recusa. A Anthropic [prometeu reduzir os falsos positivos](https://www.cnbc.com/2026/06/09/anthropic-mythos-claude-fable-5.html) "o mais rápido possível".

E o efeito líquido de tudo isso? Mais hype pro Mythos. Cada recusa do Fable vira propaganda involuntária do irmão proibido: "olha que coisa, é tão perigoso que nem a versão castrada deixa". A minha leitura, e aqui é opinião descarada, especulação minha: eu até **acredito** que o Mythos seja melhor que o Opus. Mas a campanha é tão agressiva que criou uma expectativa que nenhum modelo real consegue cumprir. Quando o Mythos finalmente sair, vai ser julgado contra o mito que a própria Anthropic construiu, e mito não perde benchmark. Tem cheiro de tiro no pé. Meu palpite: o Mythos só sai depois do IPO, e lançamentos como o Fable existem pra manter a fogueira acesa até lá. Lembrando da matemática de cima: estamos há meses sem compute pra um salto de ordem de magnitude. Quando exatamente eles teriam alocado treino pra um modelo tão revolucionário assim? As contas não fecham fáceis.

## O que dá pra testar: Fable 5 no benchmark

Chega de novela, vamos ao que interessa. Atualizei o [meu benchmark de coding](https://github.com/akitaonrails/llm-coding-benchmark) pra incluir o Fable 5 (snapshot `claude-5-fable-20260609`, $10/M input e $50/M output, o run de Claude mais caro até hoje). Mesma tarefa de sempre: construir sozinho um app de chat em Rails 8 + RubyLLM + Hotwire + Docker, com testes e CI, auditado na rubrica de 8 dimensões. Quem não conhece a metodologia, ela está na [Parte 3](/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/) e nas [atualizações seguintes](/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/).

Resultado: **94/100, Tier A, #5 no ranking**. Um ponto abaixo do Opus 4.8 (95), três abaixo do Opus 4.7 (97). Como eu suspeitava: dentro da margem de erro. Empate técnico com a própria família.

Mas o relatório de auditoria tem detalhes que valem registro, porque o Fable fez coisas que nenhum outro modelo fez:

- **Ele grepou o código-fonte do gem no meio do run.** Antes de escrever a integração, o Fable literalmente abriu o source do `ruby_llm` 1.16.0 instalado ("Now let me verify the real RubyLLM 1.16 API from the installed gem source") e verificou a API real. É o único modelo que eu já observei fazendo, por conta própria, o passo de verificação que a minha auditoria faz. Zero alucinação de API, óbvio.
- **36 testes em 7 arquivos, 99.3% de cobertura de linha, 100% de branch.** `FakeChat` com assinaturas exatas, error path e missing-key testados.
- **Corrigiu as duas deduções do Opus 4.8**: histórico com teto (`MAX_MESSAGES_PER_CONVERSATION = 200`, descarte LRU) e verificação prévia explícita da `OPENROUTER_API_KEY` com erro amigável.
- **Fase 2 com zero correções**: boot local, build de Docker, healthcheck do compose e chat end-to-end ao vivo, tudo de primeira.

E aí vem o tropeço que segura ele no #5: **persistência em singleton process-local**. O `Chat::ConversationStore` é thread-safe e tem cap, mas o histórico morre no restart e quebra com Puma multi-worker. A rubrica pontua isso abaixo do session cookie do Opus 4.8. Engenharia mais forte em quase tudo, derrubada por uma decisão de arquitetura que o 4.8 acertou.

Detalhe metodológico que eu faço questão de expor: a sessão que auditou os projetos rodava no próprio Fable 5. Pra eliminar o risco de auto-favorecimento, a ordem 4.8-vs-Fable foi confirmada num **confronto direto cego**, com juiz independente e projetos anonimizados: 19 a 18 nas dimensões contestadas, com o juiz anotando que a suíte de testes do Fable é na verdade a mais forte das duas, e que uma única mudança (trocar o hash em memória do `ConversationStore` por `Rails.cache`) inverteria o ranking. É esse o tamanho da diferença: uma linha de arquitetura.

### Como isso se compara à variação interna do Opus

Olha a família Claude no benchmark: Opus 4.6 fez 83, o 4.7 saltou pra 97, o 4.8 recuou pra 95, e agora o Fable 5 entra com 94, custando ~$11 por run contra ~$1.10 do Opus. **10× o preço por um ponto a menos.** A variação entre 4.6 → 4.7 → 4.8 já era maior que a distância entre 4.8 e Fable. Ou seja: pro meu cenário específico, o primeiro modelo "Mythos-class" público da Anthropic entrega a mesma coisa que os Opus que já existiam, com requintes de engenharia genuinamente impressionantes (o grep do gem source é o tipo de comportamento que me fez levantar a sobrancelha) que não se traduzem em score porque os erros que importam são outros.

Talvez o Fable seja muito melhor em outras tarefas. O marketing dele é todo em volta de capacidade de análise de segurança, e essa capacidade está literalmente bloqueada na versão pública (quando não está bloqueando "hello"). No que dá pra medir aqui, é um Opus mais caro.

## Ranking atualizado

Fable em negrito, resto como estava:

| Rank | Modelo | Score | Tier | RubyLLM OK | Tempo | Custo |
|---:|---|---:|:---:|:---:|---|---|
| 1 | Claude Opus 4.7 | 97 | A | ✅ | 18m | ~$1.10 |
| 1 | GPT 5.4 xHigh (Codex) | 97 | A | ✅ | 22m | ~$16 |
| 3 | GPT 5.5 xHigh (Codex) | 96 | A | ✅ | 18m | ~$10 |
| 4 | Claude Opus 4.8 | 95 | A | ✅ | 17m | ~$1.10 |
| **5** | **Claude Fable 5** | **94** | **A** | ✅ | **24m** | **~$11 (est.)** |
| 6 | Kimi K2.6 | 87 | A | ✅ | 20m | ~$0.30 |
| 7 | Claude Opus 4.6 | 83 | A | ✅ | 16m | ~$1.10 |
| 8 | Gemini 3.1 Pro | 82 | A | ✅ | 14m | ~$0.40 |
| 9 | Claude Sonnet 4.6 | 78 | B | ✅ | 16m | ~$0.63 |
| 9 | DeepSeek V4 Flash | 78 | B | ✅ | 3m | ~$0.01 |
| 9 | MiniMax M3 | 78 | B | ✅ | 53m (fase 2 DNF) | ~$0.10 |
| 12 | Grok 4.3 | 72 | B | ✅ | 15m | ~$1.74 |
| 13 | Qwen 3.6 Plus | 71 | B | ✅ | 17m | ~$0.15 |
| 14 | DeepSeek V4 Pro \* | 69 | B | ✅ | 22m (DNF) | ~$0.50 |
| 14 | Kimi K2.5 | 69 | B | ✅ | 29m | ~$0.10 |
| 16 | Xiaomi MiMo V2.5 Pro | 67 | B | ✅ | 11m | ~$0.14 |
| 17 | GLM 5 | 64 | B | ✅ | 17m | ~$0.11 |
| 18 | Step 3.5 Flash | 56 | C | ⚠️ bypass | 38m | ~$0.02 |
| 19 | Qwen 3.5 35B (local) | 55 | C | ✅ | 28m | grátis |
| 20 | GLM 4.7 Flash bf16 (local) | 52 | C | ✅ | falhou | grátis |
| 21 | GLM 5.1 (Z.ai) | 46 | C | ❌ | 22m | subscription |
| 22 | DeepSeek V3.2 | 43 | C | ❌ | 60m | ~$0.07 |
| 23 | MiniMax M2.7 | 41 | C | ❌ | 14m | ~$0.30 |
| 24 | Qwen 3.5 122B (local) | 37 | D | ❌ | 43m | grátis |
| 25 | Qwen 3 Coder Next (local) | 32 | D | ❌ | 17m | grátis |
| 26 | Grok 4.20 | 25 | D | ❌ | 8m | ~$0.60 |
| 27 | GPT OSS 20B (local) | 11 | D | ❌ | falhou | grátis |

\* DeepSeek V4 Pro chega a Tier A (89/100) só via DeepClaude. A história está no [post dedicado](/2026/05/04/llm-benchmarks-deepseek-unlocked-deepclaude/).

## Conclusão

A novela continua, e eu vou continuar assistindo com pipoca. Se o Mythos existir como anunciado, e se sair algum dia da redoma do Glasswing, eu coloco ele nesse mesmo benchmark no dia seguinte. Até lá, o que temos é um Fable 5 que empata com o Opus no que dá pra medir, custa 10× mais, e recusa as tarefas em que supostamente seria revolucionário.

Como sempre, o benchmark é aberto: [github.com/akitaonrails/llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). Quer ver outro modelo aí? Fork, adiciona no `config/models.json`, roda e manda o PR.

E a recomendação prática segue idêntica à dos [posts anteriores](/2026/06/01/llm-benchmarks-grok-4-3-minimax-m3-opus-4-8/): pra programar, por padrão, Opus e/ou GPT (eu uso os dois simultaneamente). O Fable não muda essa conta. Por enquanto, a única coisa que ele faz melhor que o Opus, comprovadamente, é marketing.
