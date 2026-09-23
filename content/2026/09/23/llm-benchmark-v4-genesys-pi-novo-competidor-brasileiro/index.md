---
title: "LLM Benchmark v4: Genesys PI, novo competidor brasileiro!"
slug: "llm-benchmark-v4-genesys-pi-novo-competidor-brasileiro"
date: '2026-09-23T18:00:00-03:00'
draft: false
translationKey: llm-benchmark-v4-genesys-pi-novo-competidor-brasileiro
description: "A LUA Vision me chamou pelo LinkedIn oferecendo acesso de teste ao Genesys PI, modelo brasileiro treinado do zero. Rodei os dois tiers, House e Enterprise, no meu benchmark v4 de sabotagem, comparo contra Opus, GPT-6, Grok e concorrentes chineses, e analiso preço, vantagens e onde ele faz sentido no mercado nacional."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
---

Fui contatado pelo LinkedIn por gente da [LUA Vision](https://lua.vision/), empresa brasileira por trás do Genesys PI, oferecendo acesso de teste ao modelo deles. Isso não costuma me interessar, mas o pitch específico, laboratório brasileiro treinando modelo do zero em vez de revender modelo estrangeiro com camada de português por cima, me deixou curioso o suficiente pra rodar o teste eu mesmo.

Deixa eu adiantar o disclaimer antes de qualquer coisa. Ninguém me pagou nada pra escrever isso. Não existe relação comercial entre mim e a LUA Vision. Nada do que está escrito aqui foi aprovado, revisado ou sugerido por eles antes de publicar. Toda palavra é minha. A única cortesia que recebi foi uma chave de acesso de avaliação sem custo pra rodar o teste, e explico o que isso significa pra conta de custo mais abaixo.

Publiquei [uma atualização da tabela geral do meu benchmark v4](/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/) hoje mais cedo, com cinco modelos novos. Este texto é um adendo direto daquele: rodei o Genesys PI nos dois tiers que a LUA Vision oferece, House e Enterprise. Com os dois, a tabela combinada chega a 46 modelos. Abaixo mostro só o trecho em volta dos brasileiros, que aparecem em **negrito** na posição real deles.

## A tabela atualizada, com o Genesys PI dentro

| Posição | Modelo | Nota | Tier | Nunca corrigido | Custo | Tempo | Harness |
|-----:|-------|:-----:|:----:|------------------|:----:|:----:|:-------:|
| ... | ... | ... | ... | ... | ... | ... | ... |
| 32 | GLM 5.3 Flash (zcode) | 84,25 | A | — | plano flat-rate | 296min | zcode |
| 33 | DeepSeek V4 Pro 0813 | 84,0 | A | itens #8, #9 (4) | $4,49 | 152min | opencode |
| 34 | Step 3.7 Flash | 83,75 | A | itens #6, #8, #11 (6,5) | $4,15 | 118min | opencode |
| 35 | Grok 4.7 | 83,5 | A | — | $27,94 | 120min | opencode |
| 35 | **Genesys PI House (LUA Vision)** | 83,5 | A | itens #7b, #8 (3) | ~$460 ᵉ | 68min | opencode |
| 37 | **Genesys PI Enterprise (LUA Vision)** | 82,5 | B | itens #7a, #7b, #9 (4) | ~$19 ᵉ | 39min | opencode |
| 38 | DeepSeek V4 Pro (base) ᶜ | 82,0 | B | — | $5,26 | 97min | opencode |
| 39 | Qwen 3.8 27B (Strix Halo, local) | 80,0 | B | itens #2, #7b, #8, #12 (8) | **$0 local** | 706min | opencode |
| 40 | Qwen 3.7 Max | 79,0 | B | itens #6, #7, #8 (6) | $10,63 | 106min | opencode |
| 41 | GLM 5.2 (zcode) ᶜ | 77,0 | B | item #12 (2) | plano flat-rate | 239min | zcode |
| ... | ... | ... | ... | ... | ... | ... | ... |

> Pra ver a tabela completa, com todos os outros modelos, leia o [meu artigo anterior](/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/).

O Genesys PI House empata exatamente com o Grok 4.7 em 83,5, Tier A. O Enterprise fica um degrau abaixo, 82,5, Tier B. Pra quem quer o resumo da metodologia, sabotagem real baseada em CVE plantada ao longo de sete sprints, nunca anunciada, com nota cheia só pra quem pega sem aviso, está tudo detalhado na [Parte 1](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-1/) e na [atualização de hoje](/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/).

## Quem é a LUA Vision

A [LUA Vision Tecnologia Ltda.](https://lua.vision/empresa/) é uma empresa de São Paulo, fundada no fim de 2025 depois de três anos de pesquisa de doutorado (2022 a 2025) do Paulo Câmara, cofundador e CTO da empresa, formado pela FGV com doutorado pela Universidade de Tel Aviv. A tese dele, *"From Neurodivergent Cognition to Natural Intelligence"*, é a origem declarada da arquitetura que virou o Genesys PI. Os outros três cofundadores são David Kang (CEO, estratégia e parcerias), Plínio Ceccon (CFO) e Eronides Jr. (CRO, comercial e receita).

A família de modelo Genesys PI foi lançada em abril de 2026. A empresa descreve a própria aposta como arriscada de propósito: construir modelo proprietário treinado pra realidade brasileira e de outros mercados emergentes, em vez de revender modelo estrangeiro com uma camada de português por cima.

O argumento central deles é que modelo treinado fora não entende bem estrutura jurídica brasileira, distinção CLT versus PJ, nem a estrutura fiscal e financeira local, e que isso importa de verdade em setor regulado: saúde, direito, finanças, educação. Hoje a empresa roda cerca de vinte projeto piloto nesses setores, além de uma linha de produto de consumo chamada [8th.vision](https://8th.vision).

Tecnicamente, eles batizam a própria arquitetura de NCAS e falam de cinco fases de treino "inspiradas em desenvolvimento neural", mais um módulo de automonitoramento chamado PI-Probe, que abstém resposta quando o modelo não tem base suficiente pra responder. [Publicaram dois artigos próprios no Zenodo](https://lua.vision/pesquisa/), *["O peso que você não escolheu"](https://doi.org/10.5281/zenodo.22899767)*, sobre o custo de tokenização em 31 línguas diferentes, e *["Capacidade máxima não é eficiência máxima"](https://doi.org/10.5281/zenodo.22881788)*, introduzindo uma métrica própria chamada Coeficiente de Eficiência Sináptica. Os dois DOI existem e resolvem de verdade, mas vale o contexto: Zenodo é repositório de preprint, não revista com revisão por pares, então trate como pesquisa própria publicada, não como validação externa.

A LUA Vision também [abriu uma issue pública no repositório do LiveBench](https://github.com/LiveBench/LiveBench/issues/370) pedindo inclusão do Genesys PI no ranking oficial, com nota autodeclarada subindo de 87,6% (novembro de 2024, mil perguntas, com destaque negativo pra codificação, 34,4%) pra 98,2% (janeiro de 2026, 682 perguntas). A issue segue aberta, sem posição de mantenedor confirmando ou rejeitando o número até a data deste texto. Ou seja: nota de LiveBench que aparece no marketing deles é autodeclarada, não ranking oficial verificado.

## Como o Genesys PI se saiu contra a fronteira e contra a concorrência chinesa

Direto ao ponto de quem só quer saber onde ele fica na régua: o Genesys PI House empata exatamente com o Grok 4.7 (83,5), no meio de um pelotão bem apertado. Fica atrás de:

- toda a fronteira que fechou em 100 (Astra, Opus 5, Opus 5.5, GPT 5.6 sol/terra, GPT 5.5, Fable 5);
- GPT 6 luna (95,5) e GPT 6 sol (91,0);
- GLM 5.3 (94,0);
- MiMo V2.6 Pro chinês (92,0);
- Claude Sonnet 5 (91,0);
- as duas rotas do Gemini 3.8 Flash (89,5 e 90,5);
- os dois Kimi, K2.7 (87,25) e K3 (85,0);
- o pelotão logo acima: Step 3.7 Flash (83,75), DeepSeek V4 Pro 0813 (84,0) e GLM 5.3 Flash (84,25).

E fica à frente de GLM 5.2 (77,0), do Gemini 3.7 Flash da geração anterior, do MiniMax M3, e de todo o fundo de tabela. O Enterprise (82,5) fica um degrau abaixo do próprio House, na mesma faixa geral.

Se a expectativa que chegou até você é de nível Claude, vale calibrar antes de qualquer decisão de compra. Nesse teste específico, o Genesys PI House fica na faixa do Grok 4.7, não na faixa dos flagship Claude.

O Claude Sonnet 5, o mais barato dos três tiers Claude que rodei, já fecha em 91,0, oito pontos e meio acima. Opus 5, Opus 5.5 e Fable 5 fecham no topo absoluto, 100,0.

Isso não tira o mérito real de uma equipe pequena brasileira chegar no patamar do Grok, laboratório entre os mais bem financiados do mundo. É só a régua certa de comparação.

O perfil de erro do House é o clássico "detecção segue disfarce": pegou toda sabotagem óbvia sozinho, os dois itens críticos, o IDOR, a chave fixa, o CORS, ambas as CVE de gem. Pegou até o item que mais sobrevive no teste inteiro (#6) na revelação, com uma correção que foi além do pedido, um índice único de banco de dados. Só nunca corrigiu dois itens silenciosos, o índice derrubado (#7b) e o agregado errado (#8), nem depois de avisado.

O Enterprise chegou na mesma contagem de itens pegos sem aviso (31 de 40) por um caminho diferente, pegando menos sabotagem no meio do caminho e recuperando um bloco grande de oito itens de uma vez só no capstone. Ficou com três itens nunca corrigidos, incluindo uma view apagada (#9) que ele nunca restaurou porque não tinha teste nenhum cobrindo relatório ou usuário pra acusar o erro.

Vale registrar um ponto de confiabilidade: a primeira tentativa do Enterprise travou num loop estocástico, repetindo o mesmo comando de grep em 841 das 857 chamadas de ferramenta, confundindo o próprio nome "LUA" com o nome da gem RubyLLM, e precisou ser abortada no limite de 90 minutos sem nenhum commit. Rodei de novo e a segunda tentativa convergiu limpa em 7 minutos: trato isso como instabilidade pontual, não como padrão, mas é o tipo de coisa que quem for testar em produção precisa monitorar.

## Preço e custo: onde a conta aperta

Aqui vale o segundo disclaimer prometido: a LUA Vision me deu uma chave de avaliação sem custo pros dois testes, então eu pessoalmente não paguei nada. Mas o benchmark inteiro compara custo pra quem for pagar de verdade, então recalculei o preço nocional que um cliente pagante teria, usando a própria tabela pública de preço da API deles (endpoint `/v1/models`), convertida de real pra dólar na cotação da época (5,16 BRL/USD).

O preço por milhão de token dos dois tiers é bem diferente:

- **House**: R$ 55 de entrada / R$ 275 de saída por milhão de token;
- **Enterprise**: R$ 4 de entrada / R$ 20 de saída por milhão de token, cerca de catorze vezes mais barato que o House por token.

O custo total da rodada do House ficou em torno de $460 nocional, alto pra uma nota de 83,5. O motivo não é só o preço por token, é a ausência de cache de prompt na API deles: cada passo reenvia o contexto acumulado inteiro a preço cheio de entrada, e num benchmark de sete sprints que acumula contexto o tempo todo, isso pesa muito. O Enterprise, com preço por token bem mais baixo, fechou em torno de $19 nocional pela mesma sabotagem, competindo de igual pra igual com opção barata como o Grok 4.5 ($6,19) ou o Claude Sonnet 4.6 ($18,64), só que com nota mais baixa que os dois.

> **Pra guardar:** se você for cliente de verdade do Genesys PI, pergunte explicitamente sobre cache de prompt antes de rodar carga de trabalho longa e cumulativa como agente de código. Sem isso, o tier flagship fica caro rápido, não pelo preço por token, mas pelo reenvio de contexto repetido.

## Onde o Genesys PI se encaixa no mercado brasileiro

Juntando tudo: o Genesys PI não é o modelo mais vigilante do meu teste, nem o mais barato, nem o mais confiável na primeira tentativa. Mas também não é fraco. Empatar com o Grok 4.7 e ficar na mesma faixa de nota de nome grande como Kimi K3, DeepSeek V4 Pro e GLM 5.3 Flash, com um modelo treinado do zero por uma equipe pequena em São Paulo, não numa fração do orçamento de um laboratório americano ou chinês, é um resultado genuíno, não figuração.

> Eu sempre achei que treinar modelo de fronteira do zero no Brasil não seria economicamente viável, esse tipo de orçamento parecia coisa reservada pra laboratório com bilhão de dólar disponível. A LUA Vision me provou errado, e faço questão de admitir isso em primeira mão. Prefiro torcer por quem tenta e consegue do que segurar uma opinião que os fatos já derrubaram.

A vantagem real de uma empresa brasileira escolher o Genesys PI não está na nota de vigilância isolada, está no que o meu benchmark não mede:

- proximidade com estrutura jurídica e fiscal brasileira, distinção CLT versus PJ incluída;
- suporte em português de verdade, não tradução automática por cima de modelo estrangeiro;
- soberania de dado, tudo processado e treinado dentro do Brasil, relevante pra setor regulado que se preocupa com onde o dado trafega e quem tem acesso a ele.

A desvantagem:

- o preço do tier flagship sem cache de prompt, que pesa em carga de trabalho longa e cumulativa;
- a confiabilidade ainda inconsistente que vi no Enterprise;
- uma nota autodeclarada de LiveBench que ainda não passou por verificação externa nenhuma.

Pra empresa brasileira decidindo entre um provedor estrangeiro e um nacional, o Genesys PI já é opção real de avaliar, não só promessa de pitch de LinkedIn. Não é ainda o modelo que eu recomendaria de olhos fechados pra vigilância de segurança pesada, mas fico genuinamente feliz de ver um modelo brasileiro treinado do zero, não um wrapper em cima de modelo de fora, aparecendo no meu ranking e competindo de verdade com nome grande de fronteira. Espero que continuem melhorando, porque o Brasil ganha com mais gente de verdade competindo nesse jogo.

## Disclaimer final

Repetindo pra não sobrar dúvida: não tenho participação nenhuma na LUA Vision. Não tive acesso a dado financeiro deles, nem a nada além da chave de teste do Genesys PI. Então não posso atestar nada além do que eu mesmo testei, que é o que está neste texto. Sobre o lado de negócio da empresa, você vai ter que perguntar diretamente pra eles.
