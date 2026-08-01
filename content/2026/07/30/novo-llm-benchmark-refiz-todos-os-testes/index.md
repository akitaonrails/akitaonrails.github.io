---
title: "Novo LLM Benchmark: refiz todos os testes!"
slug: "novo-llm-benchmark-refiz-todos-os-testes"
date: '2026-07-30T15:00:00-03:00'
draft: false
translationKey: novo-llm-benchmark-refiz-todos-os-testes
description: "Refiz o LLM Coding Benchmark com uma prova mais difícil, três fases, harnesses nativos e tiers novos. Fable liderou, Terra empatou com Sol como melhor GPT e 24 modelos ficaram aptos para programação."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
---

Há cinco dias publiquei o teste do [Claude Opus 5](/2026/07/25/llm-benchmark-opus-5-e-bom/). Onze dias atrás expliquei [por que a maior nota de um ranking não significa "o melhor LLM"](/2026/07/19/llm-benchmark-devo-usar-o-que-tem-nota-maior/).

Ótimo. A tabela do primeiro artigo já virou peça de museu.

O argumento do segundo continua valendo. Na verdade, ficou ainda mais fácil de demonstrar, porque passei os últimos dias refazendo praticamente o benchmark inteiro. Foram dezenas de runs, várias tentativas descartadas, centenas de dólares entre API e créditos equivalentes, e uma quantidade indecente de tempo lendo código Rails gerado por robô.

O resultado é a **versão 2** do meu [LLM Coding Benchmark](https://github.com/akitaonrails/llm-coding-benchmark). A prova ficou mais difícil, a auditoria ficou mais explícita e cada família passou a rodar, sempre que possível, no harness onde deveria funcionar melhor.

E já vou adiantar: **os scores do v2 não são comparáveis diretamente aos do v1**. Mudaram o prompt, os requisitos, o harness de vários modelos, a validação e a rubrica. A coluna `v1` no relatório serve como histórico, não como medição científica de quanto cada modelo "evoluiu".

## Por que aposentei o v1

Rodamos o v1 por meses. Ele serviu muito bem pra separar quem realmente conseguia construir um app Rails de quem inventava APIs do RubyLLM, escrevia testes pra própria alucinação e entregava Dockerfile que nunca subia.

Só que os modelos novos chegaram ao teto daquela prova. Quinze dos quarenta resultados já estavam comprimidos no Tier A, com o topo entre 92 e 97. O trabalho ainda tinha detalhes reais, mas os melhores modelos passavam pelos antigos discriminadores com facilidade. A ordem começava a depender de um preflight de API key aqui, um limite de cookie ali, um teste de erro que faltou. Detalhes válidos, pouca separação.

Também havia uma inconsistência operacional: a combinação entre modelo e harness. Claude tinha sido testado no OpenCode, Grok também, Kimi também, Gemini também. Só que hoje temos Claude Code, Codex, Kimi Code CLI, grok CLI e Antigravity. Medir um modelo num harness genérico quando existe uma integração feita pro comportamento dele pode distorcer o resultado.

O que o benchmark mede nunca foi apenas o arquivo de pesos:

```text
resultado = modelo + harness + prompt + tools + contexto + execução + auditoria
```

Então resolvi parar de esconder o harness dentro da nota. Claude foi pro Claude Code. GPT foi pro Codex. Kimi K3 e K2.7-Coding foram pro Kimi CLI. Grok e Gemini ganharam rodadas A/B nos CLIs dos próprios vendors. OpenCode, completamente isolado, continuou como fallback pros modelos sem harness melhor ou sem acesso por assinatura.

## A prova nova

O v1 tinha duas fases: construir e tentar subir. O v2 tem **três fases**, quatorze objetivos numerados e uma rubrica de dez dimensões.

Na primeira fase, o modelo ainda precisa construir sozinho um chat estilo ChatGPT em Rails com RubyLLM, Hotwire, Tailwind, Minitest, Docker e Compose. A semelhança termina aí. Agora ele também precisa entregar:

- streaming real por token via Turbo Streams, comprovadamente incremental;
- payload multi-turn sem mandar a mensagem atual duas vezes, com um teste da array exata enviada ao provider;
- persistência que sobreviva a restart e funcione com `WEB_CONCURRENCY=2`, com TTL e limites de quantidade e bytes;
- exatamente duas tools, `server_time` e uma calculadora segura, usando a API real do RubyLLM;
- título gerado pela API de structured output;
- orçamento de tokens por conversa;
- system prompt, preflight de credencial, estados degradados e tratamento dos erros do provider;
- garantia de que turnos que falharam nunca contaminem o histórico futuro;
- RuboCop, Brakeman e bundle-audit limpos, além de Docker de produção non-root e ausência de secrets.

A segunda fase não aceita um README dizendo que funciona. Ela sobe o Rails, observa os tokens chegando, força chamadas reais às tools, mantém uma conversa com dois workers, reinicia o servidor, confere o histórico, roda os testes e gates, faz `docker build` e manda uma mensagem real pro app dentro do Compose.

A terceira fase pede que o próprio modelo revise cada objetivo como `PASS`, `PARTIAL` ou `FAIL`, cite arquivo, linha, teste ou comando e escreva o que ainda está quebrado. Essa honestidade vale 15 pontos. Um `FAIL` correto vale mais que um `PASS` otimista que a auditoria desmente.

Essa fase trouxe um dado que o v1 não tinha. Kimi K3 e Nex, por exemplo, admitiram defeitos que seria fácil esconder. Outros construíram um app razoável e depois alucinaram a própria inspeção. Saber programar e saber revisar o que programou são capacidades diferentes.

## O harness também entrou no teste

Também fiz A/Bs com as ferramentas nativas:

| Modelo | OpenCode limpo | Harness nativo | Leitura |
|---|---:|---:|---|
| Grok 4.5 | 92 | 91 no grok CLI | diferença dentro do ruído |
| Grok 4.3 | 18 | 55 no grok CLI | o scaffolding nativo resgata, mas continua fraco |
| Gemini 3.1 Pro | 62 | 88 no Antigravity | o caminho direto evita um bug do provider |
| Gemini 3.6 Flash | não rodado | 92 no Antigravity | bom resultado, sem baseline comparável |

O harness nativo não joga pó mágico no modelo. Grok 4.5 praticamente não ligou. Grok 4.3 precisava da estrutura. Gemini 3.1 precisava de um transporte que não quebrasse com `Corrupted thought signature`. Três mecanismos diferentes, que uma comparação apressada chamaria simplesmente de "o CLI melhorou a nota".

No ranking abaixo, uso o harness preferencial quando existe uma rodada completa: Antigravity pros Geminis e grok CLI pros Groks. Os baselines de OpenCode continuam no repositório como A/B, mas não aparecem uma segunda vez na tabela.

## O novo ranking

Esta é a tabela consolidada do v2, com uma entrada por modelo no harness preferencial disponível.

| # | Modelo | Score | Tier | Harness |
|---:|---|---:|:---:|---|
| 1 | Claude Fable 5 | **96** | A.1 | Claude Code |
| 2 | Claude Sonnet 5 | **95** | A.1 | Claude Code |
| 2 | Claude Opus 5 | **95** | A.1 | Claude Code |
| 2 | Kimi K3 | **95** | A.1 | Kimi CLI |
| 5 | GPT 5.6 Sol | **93** | A.1 | Codex |
| 5 | Claude Opus 4.8 | **93** | A.1 | Claude Code |
| 5 | GPT 5.6 Terra | **93** | A.1 | Codex |
| 8 | GLM 5.2 | **92** | A.1 | OpenCode |
| 8 | Kimi K2.5 | **92** | A.1 | OpenCode |
| 8 | Gemini 3.6 Flash @ high | **92** | A.1 | Antigravity |
| 11 | MiniMax M3 | **91** | A.1 | OpenCode |
| 11 | Kimi K2.6 | **91** | A.1 | OpenCode |
| 11 | Claude Opus 4.7 | **91** | A.1 | Claude Code |
| 11 | GPT 5.6 Luna | **91** | A.1 | Codex |
| 11 | Grok 4.5 | **91** | A.1 | grok CLI |
| 16 | Nex-N2-Pro | **88** | A.2 | OpenCode |
| 16 | GPT 5.5 | **88** | A.2 | Codex |
| 16 | Gemini 3.1 Pro @ high | **88** | A.2 | Antigravity |
| 19 | Claude Sonnet 4.6 | **87** | A.2 | Claude Code |
| 20 | GPT 5.4 | **86** | A.2 | Codex |
| 20 | Kimi K2.7-Coding | **86** | A.2 | Kimi CLI |
| 22 | Step 3.7 Flash | **84** | A.2 | OpenCode |
| 23 | Claude Opus 4.6 | **83** | A.2 | Claude Code |
| 23 | GLM 5 | **83** | A.2 | OpenCode |
| 25 | DeepSeek V4 Pro | **82** | B | OpenCode |
| 26 | DeepSeek V4 Flash | **80** | B | OpenCode |
| 27 | Qwen 3.6 Plus | **76** | B | OpenCode |
| 28 | MiMo V2.5 Pro | **73** | B | OpenCode |
| 29 | Grok 4.3 | **55** | C | grok CLI |
| 30 | Qwen3.7 Max | **51** | C | OpenCode |
| 31 | Step 3.5 Flash | **27** | D | OpenCode |

Os detalhes, artefatos e deduções estão no [relatório completo do v2](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.v2.md).

## O que os tiers querem dizer agora

O novo corte foi ancorado no Claude Opus 4.6, que fez 83 e mostrou o mínimo necessário pra carregar a prova inteira. A interpretação prática ficou assim:

| Tier | Score | Como eu leio |
|:---:|---:|---|
| **A.1** | **90 ou mais** | Fronteira desta prova. Entrega mais completa e consistente; diferenças de um ou dois pontos dentro do grupo continuam sendo ruído. |
| **A.2** | **83 a 89** | Serve pra programação e passou pelo mesmo piso de competência, mas deixou correções ou limitações mais visíveis. Ainda recomendo, com revisão mais atenta. |
| **B** | **73 a 82** | Está perto, mas ainda exige limpeza humana em ponto importante. Não recomendo pra trabalho autônomo; mantenho no radar. |
| **C** | **51 a 72** | Não recomendo pra programação. Ainda pode servir pra tradução, resumo, classificação e agentes simples. |
| **D** | **50 ou menos** | Comportamento inconsistente, quebrado ou difícil de prever. Não me sinto seguro recomendando nem pra automação simples. |

Temos **15 modelos no A.1** e **9 no A.2**. Os 24 passaram do piso de competência pra esse tipo de trabalho. A subdivisão ajuda a escolher por onde começar: A.1 concentra os resultados de fronteira; A.2 reúne modelos competentes que exigiram mais consertos, deixaram testes mais rasos ou carregaram limitações operacionais mais claras.

Isso não transforma 96 em uma inteligência universalmente maior que 91, nem torna um A.2 ruim. Um modelo A.2 pode ser melhor em refactor, debugging, frontend ou dentro do seu monolito de quinze anos. A prova não mede tudo isso. O corte só evita colocar 24 opções num balde grande demais.

A.1 e A.2 formam o grupo de candidatos. Tier C e D são grupos que eu corto antes de começar.

## Afinal, qual é o melhor: Fable, Opus, Terra ou Kimi?

Se você só quer uma resposta de uma linha, vai se decepcionar de novo.

| Modelo | Score | Tempo | Equivalente em API | Uso prático |
|---|---:|---:|---:|---|
| Claude Fable 5 | 96 | 46 min | $26,03 | assinatura Claude Max |
| Claude Opus 5 | 95 | 78 min | $38,91 | assinatura Claude Max |
| Kimi K3 | 95 | 65 min | $6,14 | assinatura Moderato |
| GPT 5.6 Terra | 93 | 49 min | $16,92 blended | créditos do ChatGPT |

No artefato final, **Fable ganhou**. Também foi o mais rápido entre esses quatro. Se eu estivesse pagando cada chamada de API dessa rodada, o **Kimi K3 ganhou de lavada no custo**, empatado com Opus em 95 e só um ponto abaixo de Fable.

Opus 5 fez um projeto excelente, mas foi o mais lento e gastou 56,8 milhões de tokens somados pelo Claude Code. Nesta prova ele não comprou nada visível com os 33 minutos extras sobre Fable. Terra também entregou bem, ficou dois pontos abaixo de K3 e custou menos que Fable e Opus no equivalente de API.

Quem já paga Claude Max ou ChatGPT Pro tem custo marginal próximo de zero enquanto estiver dentro dos limites. Kimi Moderato também é assinatura, com janelas de quota próprias. Portanto, "$26 contra $6" não decide sozinho. A primeira pergunta é qual assinatura você já paga e quanto limite ainda tem. Pra pay-as-you-go e automação, aí sim o custo por execução volta pro centro.

Minha leitura desse run:

- **Fable 5** entregou o melhor pacote de qualidade e tempo;
- **Kimi K3** foi o melhor custo-benefício entre os líderes;
- **Opus 5** foi competente e meticuloso, mas caro e lento nesta execução;
- **GPT 5.6 Terra** entregou o melhor equilíbrio da família pra quem vive no Codex.

É uma leitura deste projeto. Troque o workload e a ordem pode virar.

## Opus contra Sonnet, Sol contra Terra

Nome de tier não é benchmark. O Sonnet 5 provou isso de um jeito quase constrangedor:

| Claude | Score | Tempo | Custo registrado |
|---|---:|---:|---:|
| Fable 5 | 96 | 46 min | $26,03 equivalente em API |
| Opus 5 | 95 | 78 min | $38,91 equivalente em API |
| Sonnet 5 | 95 | 59 min | $25,83 equivalente na assinatura |
| Opus 4.8 | 93 | 53 min | $21,82 equivalente na assinatura |

Sonnet 5 empatou com Opus 5, terminou dezenove minutos antes e produziu a primeira cobertura de linhas realmente 100% de todo o benchmark. Também fez a melhor self-review da família. Escolher Opus automaticamente porque "Opus é a tier maior" seria jogar os próprios dados fora.

Isso também corrige uma impressão péssima do v1, onde Sonnet 5 tinha feito 58 e alucinado a API do RubyLLM. No v2 ele rodou no Claude Code, recebeu requisitos explícitos e fez 95. Não dá pra concluir que o modelo melhorou 37 pontos porque mudamos quase todo o experimento. Dá pra concluir que a combinação v1 era uma representação ruim do que ele consegue fazer.

Do lado da OpenAI:

| GPT | Score | Tempo | Custo blended equivalente |
|---|---:|---:|---:|
| GPT 5.6 Sol | 93 | 57 min | ~$45 |
| GPT 5.6 Terra | 93 | 49 min | $16,92 |
| GPT 5.6 Luna | 91 | 46 min | $16,79 |
| GPT 5.5 | 88 | 58 min | ~$53 |
| GPT 5.4 | 86 | 67 min | ~$26 |

Terra empatou com Sol em 93, terminou oito minutos antes e custou pouco mais de um terço no cálculo blended. Também produziu a melhor proteção de concorrência de toda a rodada: Redis com `WATCH`/`MULTI`, lock distribuído por conversa e escolha forçada de tool. Nesta prova, pagar pelo Sol não comprou nenhum ponto nem economizou tempo. Terra é a escolha mais racional da família.

Luna continua na tabela porque fez 91 e ainda é um resultado A.1, mas perdeu o argumento de custo: Terra ficou dois pontos acima por apenas treze centavos a mais e levou cerca de três minutos extras.

O detalhe importante continua sendo o cache. Dos 21,7 milhões de tokens de input do Terra, 21 milhões eram cache hits. Cobrar tudo como input novo daria um teto de $111,62. Com a tarifa de cache, cai pra $16,92. Qualquer tabela de custo que mistura CLIs sem entender o que cada uma reporta está comparando banana com JSON.

## E os modelos chineses?

A conversa de que modelo chinês só serve como alternativa barata ficou velha.

| Modelo | Score | Tier | Tempo | Custo reportado |
|---|---:|:---:|---:|---:|
| Kimi K3 | 95 | A.1 | 65 min | $6,14 equivalente, assinatura |
| Kimi K2.5 | 92 | A.1 | 43 min | $1,50, API |
| Kimi K2.6 | 91 | A.1 | 34 min | $2,64, API |
| Kimi K2.7-Coding | 86 | A.2 | 54 min | $4,37 equivalente, assinatura |
| MiniMax M3 | 91 | A.1 | 113 min | $7,72, API |
| GLM 5.2 | 92 | A.1 | 155 min | $0 marginal na assinatura, $12,05 equivalente em API |
| DeepSeek V4 Pro | 82 | B | 57 min | $0,35, API |
| DeepSeek V4 Flash | 80 | B | 36 min | $0,81, API |

Kimi K3 empatou com Opus 5. K2.5, K2.6, MiniMax M3 e GLM 5.2 ficaram no mesmo A.1 de Claude e GPT. As execuções via OpenCode continuam mais baratas que a faixa de $16 a $45 dos líderes rodados em Claude Code e Codex, mas já não é uma comparação de centavos contra dezenas de dólares. E assinatura não é API: o GLM teve custo marginal zero porque rodou no plano da Z.ai; o mesmo consumo sairia por cerca de $12,05 via API.

O Kimi é a família mais fácil de recomendar hoje. K3 oferece qualidade de topo na assinatura barata. K2.5 e K2.6 foram econômicos via API, custando $1,50 e $2,64. K2.7 ficou abaixo dos irmãos, mas rodou em outro harness, então não vou inventar uma historinha de evolução linear com quatro pontos isolados.

MiniMax M3 merece atenção e cautela na mesma medida. Fez 91 por $7,72, ainda abaixo de uma rodada nos líderes americanos, mas gastou 121 milhões de tokens e levou quase duas horas. Foi a execução mais cara e mais voraz em tokens entre as rodadas de OpenCode. O score é bom; o perfil de uso, nem tanto.

GLM 5.2 fez 92 com custo marginal zero no plano da Z.ai, mas consumiu o equivalente a $12,05 em API. Levou cerca de duas horas e meia. Se tempo de wall clock não importa, é uma opção muito forte. Se você trabalha em ciclos curtos, Grok 4.5 entregou 91 em cerca de 25 minutos no grok CLI, mais de seis vezes mais rápido.

DeepSeek continua barato, mas parou no Tier B. V4 Pro fez 82 por $0,35 e V4 Flash fez 80 por $0,81. Estão perto e quero repetir quando vier uma versão nova. Hoje eu ainda não usaria nenhum dos dois pra deixar um coding agent trabalhando sozinho numa codebase que importa. Economizar um ou dois dólares pra depois gastar uma hora revisando defeito estrutural é uma conta ruim.

## Por que não refiz os modelos locais

Não rodei Qwen 3.5 e os outros modelos locais no v2. A prioridade passou a ser mapear melhor o Tier A de programação, e cada execução completa dessa prova custa tempo de máquina, auditoria e sanidade.

Os locals não são inúteis. Servem pra tradução, classificação, resumo, one-shot controlado e tarefas onde privacidade ou operação offline pesa mais que qualidade. Já pra coding agent autônomo, os testes do v1 ficaram muito abaixo do piso. A prova v2 é mais difícil. Não vejo motivo pra gastar vários dias confirmando de novo que um Qwen quantizado local não compete com Fable, Opus, GPT 5.6 ou Kimi em engenharia de software.

Pra programação, hoje não vale a pena. Se surgir um modelo local novo com evidência forte, eu testo. Até lá, prefiro gastar tempo diferenciando os vinte e quatro modelos que já passaram do piso.

## Conclusão

O v1 cumpriu seu papel e saturou. O v2 aperta onde os modelos atuais ainda escorregam: streaming de verdade, payload multi-turn, concorrência, persistência, tools, structured output, orçamento, segurança operacional, teste fiel e capacidade de admitir o próprio defeito.

Fable 5 ficou no topo com 96. Sonnet 5, Opus 5 e Kimi K3 empataram em 95. Sol e Terra vieram logo atrás com 93. Isso responde quem produziu os melhores projetos nesta prova.

Pra escolher o que usar, a leitura prática é outra:

- Tier A.1 reúne os 15 resultados de fronteira, todos com 90 ou mais;
- Tier A.2 reúne 9 modelos competentes entre 83 e 89, ainda recomendáveis com revisão mais atenta;
- Tier B está perto, mas ainda não recomendo pra trabalho autônomo;
- Tier C fica pra tradução, resumo e agentes simples;
- Tier D tem comportamento inconsistente demais pra eu recomendar;
- dentro do Tier A, escolha por assinatura, velocidade, custo e harness;
- um ou dois pontos não transformam ninguém no campeão universal de inteligência.

Minha escolha pessoal continua concentrada em Claude Code e Codex porque são os harnesses que uso todo dia. Dentro do Codex, Terra entregou o melhor equilíbrio entre score, tempo e custo. Kimi K3 virou uma alternativa séria de topo. Grok 4.5 é o campeão de velocidade desta rodada. GLM tem custo marginal zero na assinatura e MiniMax ainda custa menos que os líderes, mas nenhum dos dois é escolha de velocidade. Sonnet 5 provou que pagar ou selecionar a tier "maior" por reflexo pode ser desperdício.

Todo o código gerado, prompts, resultados, self-reviews, rubrica e correções estão no [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). A grande reforma de código e testes já está no `master`. Contribuições são bem-vindas, seja pra adicionar modelo, melhorar o harness, contestar uma dedução ou encontrar mais um bug no auditor.

Só traga artefato e dado. Opinião de ranking já tem demais.
