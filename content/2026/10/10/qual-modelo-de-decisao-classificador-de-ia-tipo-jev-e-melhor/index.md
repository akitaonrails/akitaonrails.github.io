---
title: "Qual modelo de decisão/classificador de IA tipo Jev é melhor?"
slug: "qual-modelo-de-decisao-classificador-de-ia-tipo-jev-e-melhor"
date: '2026-10-10T12:00:00-03:00'
draft: false
translationKey: qual-modelo-de-decisao-classificador-de-ia-tipo-jev-e-melhor
description: "Rodei meu próprio benchmark de modelos de decisão: Jev, Clef, OpenAI Decisions e Microsoft Decision-1 na nuvem, mais dezoito configurações abertas (Perplexity Decider 27B, Decision 3.0 e Edge, Clef-flash, Kev, Jebadiah, Mapika, Eikos, Laya, Julia, GLiNER, Simple-Jev) no meu Strix Halo via ROCm e numa RTX 5090 via CUDA, em mais de 22 mil classificações com casos em inglês e português. O topo agora tem dois de pesos abertos: Perplexity e Decision 3.0 empataram em 99,4%, com rótulos idênticos nas 1.024 classificações e 100% em português. O Microsoft Decision-1 empatou com o Jev em 97,6% sendo o hospedado mais barato. Na 5090 os 4B caem pra 39-91 ms, mais rápidos que qualquer hospedado, e os campeões de 27B nem cabem nos 32 GB da placa. Tabela completa, custo em e-mails de suporte, pegadinhas e onde os dados convergem."
tags:
- benchmarks-de-llm
- modelos-locais
- inteligencia-artificial
- llms
---

Semana passada publiquei [um texto longo sobre o Jev](/2026/10/03/entendendo-o-hype-do-jev-pra-que-serve/), o classificador hospedado da TypeSafe que virou febre em setembro. O resumo daquele texto: o Jev é um classificador, coisa que existe há décadas, e o espanto de "193x mais rápido" só existe porque muita gente vinha usando LLM de chat como classificador caro e lento. Reproduzi o ensaio *O aluno que marca a letra A*, do Paulo Câmara, apresentei as alternativas abertas Clef e Laya, e pra comparar os modelos lado a lado me apoiei no [Decision Index](https://huggingface.co/spaces/multimodalart/jev-decision-index), um ranking público que já existia.

Ranking de terceiro é útil, mas eu queria pôr a mão na massa. Então montei meu próprio benchmark, com casos meus, metade em português, e rodei os modelos abertos duas vezes: no meu [home server com Strix Halo](/2026/03/31/review-minisforum-ms-s1-max-amd-ai-max-395/), o mesmo Ryzen AI Max+ 395 que uso pra testar LLM local, via ROCm, e de novo numa RTX 5090 via CUDA. Os hospedados (Jev, os dois Clef da Cloudflare, o OpenAI Decisions e o Microsoft Decision-1 via OpenRouter) rodaram pela API deles. Tudo, incluindo os casos, as respostas brutas e os scripts de pontuação, está público no [repositório do benchmark](https://github.com/akitaonrails/jev-docs-benchmarks).

> **TL;DR:** o topo agora tem dois, ambos de pesos abertos. O **Perplexity Decider 1.1 27B** e o recém-lançado **Decision 3.0** (vLLM Semantic Router) empataram em **99,4%** nos casos compactos, com 100% em português, e rótulos idênticos em todas as 1.024 classificações do benchmark. O preço: uns 49 GB de pesos e mais de um segundo por decisão. Na nuvem, o **Microsoft Decision-1** empatou com o **Jev** em 97,6% custando um terço: é o hospedado mais barato que eu medi, e o primeiro candidato a avaliar. O Jev responde mais rápido e erra diferente. O **OpenAI Decisions** estreou empatado com o melhor 4B local, o Jebadiah, e tem a menor latência hospedada. O **Julia-1**, o menor e mais rápido de todos (12 ms), acertou no nível da moeda: de fábrica, não serve. E a segunda passada, agora numa **RTX 5090**: os modelos até 9B aceleram de 2× a 10×, o Jebadiah 4B cai pra 39 ms, mais rápido que qualquer hospedado, e os dois campeões de 27B, com uns 49 GB de pesos, nem cabem nos 32 GB da placa. Pule pra [tabela](#a-tabela-completa), pro [custo em e-mails de suporte](#quanto-custa-em-e-mails-de-suporte), pra [qual usar em qual situação](#qual-modelo-em-qual-situação), pra [quão difícil é rodar local](#quão-difícil-é-rodar-os-melhores-abertos-na-sua-máquina), pras [pegadinhas](#destaques-e-pegadinhas) ou pras duas cozinhas do [ROCm x CUDA](#rocm-x-cuda-a-mesma-receita-em-duas-cozinhas).

## Como eu testei

A ideia central foi medir mais do que "quem acerta mais". Modelo de decisão tem objetivo de projeto, e comparar um encoder de 322 milhões de parâmetros feito pra rodar em dispositivo fraco com um serviço hospedado de tamanho não divulgado só por porcentagem de acerto é injusto com os dois. Então medi acerto, latência, custo e comportamento sob estresse, e no fim separo as recomendações por situação.

### Os dois conjuntos de casos

Montei dois conjuntos de testes, congelados em git antes de qualquer inferência, com o hash do dataset gravado junto com as respostas. Nenhum modelo recebe a resposta esperada, a justificativa ou o identificador do caso. Só o texto, as instruções e as opções.

O **conjunto v1** tem 13 casos de uso operacionais, em inglês, cada um com uma política fictícia explícita:

- severidade de ticket de suporte
- roteamento de suporte
- política de reembolso
- escalação de incidente
- aprovação de ferramenta (um agente pode ou não executar tal ação)
- fraude por e-mail
- tipo de documento
- suporte de evidência
- relevância de busca
- moderação
- roteamento de pedido
- qualificação de lead
- triagem por limiar numérico

São 10 cenários por caso de uso, cada um apresentado de quatro formas: original, opções em ordem invertida, opções com nomes opacos (c0, c1, c2) e original mais um comentário de "revisor" sugerindo a resposta errada, que a instrução manda ignorar. Dá 520 classificações por modelo. Somam-se 24 sondagens de probabilidade em situações sem informação nenhuma (moeda honesta, dado de seis lados), onde a resposta certa é matemática.

O **conjunto v2** foi feito pra cobrir o que o v1 deixa de fora: semântica comum e português. São 7 tarefas, com 12 cenários cada, e cada cenário escrito em inglês e em português brasileiro com a mesma resposta e a mesma ordem de opções:

- sentimento (autor versus citação, negação, sarcasmo)
- intenção atual (pedido retirado, ações concorrentes, hipótese)
- implicação lógica (quantificadores, fato ausente, ordem temporal)
- relevância de busca (tudo, parte ou nada do que foi pedido)
- tratamento de dados sensíveis (segredo fictício versus menção, redação, revogação)
- status atual de incidente (ordem da linha do tempo, verificado versus não verificado)
- política por limiar (limites inclusivos, unidades, E/OU com valor faltando)

Cada par roda em três condições:

- **compacta**: só o registro e a regra
- **com exemplos**: um exemplo resolvido por classe, fixo e igual pra todos
- **com distratores**: dez notas irrelevantes de arquivo antes do registro que importa, pra estressar contexto

Dá 504 classificações por modelo.

> Os casos foram escritos com ajuda de IA e revisados contra as políticas, sem anotação humana independente. É um benchmark sintético e pequeno: 130 famílias de cenário no v1 e 84 no v2. As variantes são correlacionadas, então 520 respostas são 130 cenários vistos de quatro jeitos. Trate os números como fotografia desses casos, e teste com os seus antes de decidir.

### Os 23 competidores

Cinco rodaram na nuvem, pela API oficial: o **Jev** (versão 1.13.0, da TypeSafe), o **Clef** (27B, Cloudflare Workers AI), o **Clef-flash** (9B, idem), o **OpenAI Decisions** (o alias `gpt-6-luna`, em beta público) e o **Microsoft Decision-1** (9B, pós-treinado do Qwen3.5-9B, servido via OpenRouter em Azure). Os outros dezoito rodaram no Strix Halo, via ROCm, e depois de novo numa RTX 5090, via CUDA, com os pesos fixados por hash de commit no Hugging Face, dentro de container Docker. Os três da primeira leva (Laya, Laya typed e Clef-flash) dividiram um container; os demais rodaram um por vez, com o Julia-1 medido duas vezes, em GPU e em CPU. O servidor via 64 GiB de memória endereçável pela GPU.

| Modelo | Tamanho nominal | Origem | Onde rodou |
| --- | ---: | --- | --- |
| Jev 1.13.0 | não divulgado | TypeSafe, proprietário | API |
| OpenAI Decisions (`gpt-6-luna`) | não divulgado | OpenAI, proprietário, beta | API |
| Microsoft Decision-1 | 9B | Microsoft, proprietário | API (OpenRouter) |
| Clef | 27B | Cloudflare, pesos abertos | API |
| Clef-flash | 9B | Cloudflare, pesos abertos | API e local |
| Perplexity Decider 1.1 27B | 27B | Perplexity, Apache 2.0 | local |
| Decision 3.0 (d3) | 27B | vLLM Semantic Router, Apache 2.0 | local |
| Decision 3.0 Edge | 0,6B | vLLM Semantic Router, Apache 2.0 | local |
| Jebadiah 4B v2 | 4B | Frontier Infra, Apache 2.0 | local |
| Kev 0.8B / 4B / 9B | 0,8B / 4B / 9B | Jared Palmer, Apache 2.0 | local |
| Mapika Decider 4B | 4,2B | Mapika, Apache 2.0 | local |
| Eikos 4B | 4B | Caio Vicentino, MIT, treinado em EN e PT | local |
| Simple-Jev + Qwen3.5 4B | 4B | Featherless, servidor de leitura de tokens sobre modelo comum | local |
| Laya / Laya typed-decisions | 421M | Convai Innovations, encoder ModernBERT | local |
| Laya multilingual | 322M | Convai Innovations, encoder mmBERT | local |
| Julia-1 | 144M | Supersonic Labs, Apache 2.0, encoder mmBERT | local, GPU e CPU |
| GLiNER2.5-Decide / multi-Decide | 340M / 287M | Fastino, Apache 2.0 | local |

A ordem aí em cima é só organizacional, hospedados primeiro e locais por família. O ranking de verdade está na [tabela de resultados](#a-tabela-completa).

Todos receberam exatamente o mesmo texto, as mesmas instruções e as mesmas opções, sem prompt ajustado por modelo e sem nenhum ajuste depois de ver resultado (o Simple-Jev usa a política de prompt fixa do próprio servidor). A exceção é o **GLiNER**, cuja API nativa recebe rótulos em vez de distribuições de probabilidade. Ele entra numa trilha separada, só no v2, com mapeamento explícito e sem métricas de calibração inventadas.

O **Simple-Jev** merece explicação. Ele é um servidor que pega um LLM comum (aqui o Qwen3.5 4B, sem nenhum treino de decisão) e lê a probabilidade dos tokens de resposta em vez de gerar texto. É a linha de base: se um modelo "de decisão" perde pra isso, o treino especializado não comprou nada.

Duas observações de protocolo. O **OpenAI Decisions** responde por um endpoint nativo de decisões tipadas, e o alias que a API devolveu não é um snapshot imutável: a OpenAI pode trocar o peso por trás do nome, como a Cloudflare faz com o Clef-flash. E o **Perplexity Decider** não é um LLM de chat comum: ele tem uma cabeça de decisão separada, com atenção não-causal e uma temperatura de calibração salva nos pesos. Um servidor de chat genérico não reproduz o comportamento dele. O **Microsoft Decision-1** fala SystemOne nativo pela API de decisões do OpenRouter, e o identificador servido é datado (`microsoft-decision-1-20261009`), ou seja, também não é peso imutável. Ele não aparece no catálogo de modelos de texto do OpenRouter: pra achar, tem que filtrar pela modalidade `decisions`. O **Decision 3.0** é a família nova do projeto vLLM Semantic Router, Apache 2.0, derivada de Qwen, com seis checkpoints (d3, flash, mini, nano, lite, edge) e SystemOne nativo. Eu testei o flagship (d3) e o menor (d3-edge); os quatro do meio ficam pra outra rodada.

### O que foi medido

- Acerto por tarefa, por língua e por condição, sempre em cima das probabilidades por opção que o modelo devolve, ignorando o campo de "confiança" do fornecedor.
- Brier e ECE pra calibração.
- Latência mediana e p95 vista pelo cliente, incluindo a rede: WAN pros hospedados, LAN pros locais. Os locais foram medidos nas duas implantações, Strix com ROCm e 5090 com CUDA. São observações de implantação completa, máquina inteira de cada lado; a comparação entre elas não isola o efeito de trocar só o backend.
- Tokens de entrada reportados pela API, valorados pela tabela de preços de 10 de outubro, antes de qualquer franquia.
- Intervalos de confiança por bootstrap sobre famílias de cenário, em vez de respostas individuais.

Custo local eu deixei de medir. Energia, amortização do hardware e manutenção ficaram de fora, então modelo local aparece como "não medido", porque "zero" seria mentira.

## A tabela completa

A coluna principal é o acerto nos 168 casos compactos do v2 (84 em inglês, 84 em português). A coluna do v1 usa os 130 cenários originais. Latências são medianas vistas pelo cliente ao longo das 504 chamadas do v2, nas duas implantações locais: ROCm no Strix Halo, CUDA na RTX 5090. Os hospedados não têm hardware meu pra trocar, e os dois 27B não cabem nos 32 GB da 5090. O custo é o valor de lista por 10 mil decisões compactas, calculado pelos tokens que a API reportou.

| Modelo | Compacto EN / PT-BR | Compacto combinado | v1 originais | Latência ROCm (Strix) | Latência CUDA (5090) | 10 mil decisões |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Perplexity Decider 27B | 98,8% / 100,0% | **99,4%** | 99,2% | 1.547 ms (LAN) | não cabe (49 GB) | não medido |
| Decision 3.0 (27B) | 98,8% / 100,0% | **99,4%** | 99,2% | 1.420 ms (LAN) | não cabe (48,6 GB) | não medido |
| Jev | 97,6% / 97,6% | 97,6% | 96,2% | 255 ms (WAN) | – | US$ 0,19 |
| Microsoft Decision-1 | 95,2% / 100,0% | 97,6% | 95,4% | 422 ms (WAN) | – | US$ 0,065 |
| Clef (27B) | 97,6% / 94,0% | 95,8% | 94,6% | 302 ms (WAN) | – | US$ 0,63 |
| Jebadiah 4B v2 | 91,7% / 89,3% | 90,5% | 85,4% | 205 ms (LAN) | **39 ms** | não medido |
| OpenAI Decisions | 90,5% / 90,5% | 90,5% | 93,1% | 222 ms (WAN) | – | US$ 0,23 |
| Kev 9B | 92,9% / 83,3% | 88,1% | 87,7% | 561 ms (LAN) | 69 ms | não medido |
| Clef-flash (9B) hospedado | 91,7% / 83,3% | 87,5% | 90,8% | 394 ms (WAN) | – | US$ 0,10 |
| Clef-flash (9B) local | 89,3% / 85,7% | 87,5% | 90,8% | 618 ms (LAN) | 86 ms | não medido |
| Mapika Decider 4B | 89,3% / 85,7% | 87,5% | 86,9% | 186 ms (LAN) | 91 ms | não medido |
| Kev 4B | 88,1% / 86,9% | 87,5% | 82,3% | 246 ms (LAN) | 67 ms | não medido |
| Eikos 4B | 85,7% / 79,8% | 82,7% | 87,7% | 235 ms (LAN) | 42 ms | não medido |
| Simple-Jev + Qwen3.5 4B | 77,4% / 71,4% | 74,4% | 85,4% | 1.349 ms (LAN) | 161 ms | não medido |
| Kev 0.8B | 64,3% / 61,9% | 63,1% | 63,1% | 86 ms (LAN) | 49 ms | não medido |
| Decision 3.0 Edge (0,6B) | 67,9% / 53,6% | 60,7% | 65,4% | 45 ms (LAN) | 13 ms | não medido |
| GLiNER2.5-Decide (EN) | 54,8% / 50,0% | 52,4% | não rodou | 208 ms (LAN) | 20 ms | não medido |
| Laya typed-decisions | 50,0% / 35,7% | 42,9% | 43,8% | 43 ms (LAN) | 14 ms | não medido |
| Laya (EN) | 44,0% / 41,7% | 42,9% | 43,8% | 41 ms (LAN) | 13 ms | não medido |
| Laya multilingual | 35,7% / 38,1% | 36,9% | 43,8% | 19 ms (LAN) | 10 ms | não medido |
| GLiNER2.5-multi-Decide | 32,1% / 35,7% | 33,9% | não rodou | 63 ms (LAN) | 10 ms | não medido |
| Julia-1 (GPU) | 38,1% / 25,0% | 31,5% | 38,5% | **12 ms** (LAN) | 7,3 ms | não medido |
| Julia-1 (CPU) | 38,1% / 25,0% | 31,5% | 36,9% | 71 ms (LAN) | – | não medido |

Sobre a coluna CUDA: os pesos são os mesmos, então o acerto veio igual ou a até dois casos de distância no compacto em todos os modelos. Rótulos individuais viraram em alguns (12 de 504 no pior caso, o Julia; 11 no Simple-Jev), diferença de aritmética de kernel que não mudou placar nenhum, e as probabilidades diferem na terceira casa decimal em média. A tabela fica pelo acerto do Strix; a coluna CUDA só traz latência. O relatório pareado completo, caso a caso, está no [repositório](https://github.com/akitaonrails/jev-docs-benchmarks/blob/master/benchmark/reports/cuda-comparison/results.md).

Pra calibrar a leitura: as tarefas têm três ou quatro opções, então chute uniforme dá uns 31% nos dois conjuntos. "Perto de 50%" aqui já é bem acima da moeda, e "perto de 33%" é a moeda. O Julia-1 ficou em 31,5%: o nome bonito esconde um cara jogando cara-ou-coroa.

Os intervalos importam. A vantagem do Perplexity sobre o Jev no v2 é de menos de 2 pontos e o intervalo de bootstrap encosta no zero: é a liderança medida neste conjunto, não uma superioridade provada pra sempre. E o Decision 3.0 empatou com o Perplexity no limite do que este conjunto consegue distinguir: **rótulos idênticos nas 1.024 classificações**, com os dois errando os mesmos dois casos (a relevância em inglês no v2 e o caso disputado de severidade no v1, que já está no errata). O Microsoft empatou com o Jev no agregado, com intervalo centrado em zero, mas empate no agregado não é intercambiabilidade: eles erram casos diferentes, e o Microsoft inverte o padrão de língua, errando mais em inglês que em português. Jev e Clef também seguem separados por menos de 2 pontos, no mesmo patamar. Já o pelotão de 90% (Jebadiah, OpenAI) fica 7 pontos atrás do Jev, e daí pra baixo todas as diferenças são claras.

Cada célula de tarefa tem só 12 cenários por língua, então um acerto a mais muda a célula em mais de 8 pontos. Empate em uma tarefa específica é pista pra um piloto. As tabelas por tarefa estão no [repositório](https://github.com/akitaonrails/jev-docs-benchmarks/blob/master/benchmark/reports/decision3-comparison-v2/results.md).

## Quanto custa, em e-mails de suporte

Preço por milhão de tokens é um número que ninguém consegue sentir. Os preços de lista em 11 de outubro são US$ 0,042 por milhão de tokens de entrada no Jev, US$ 0,24 no Clef, US$ 0,038 no Clef-flash e US$ 0,10 no OpenAI Decisions. Saída é grátis nos cinco. O Microsoft Decision-1 cobra os mesmos US$ 0,042 do Jev por milhão, via OpenRouter, mas reportou um terço dos tokens de entrada pros mesmos textos (uns 26 mil contra uns 77 mil do Jev no v2 compacto), e ninguém sabe explicar a diferença de tokenização. Na prática medida, isso o torna o hospedado mais barato do lote.

O Clef-flash custava US$ 0,09 no dia 9: a Cloudflare baixou o preço em mais da metade no meio do meu teste. O Jev reporta bem mais tokens que a Cloudflare pro mesmo texto, uns 45% a mais no v2, e isso já está na conta abaixo.

Imagine uma operação com **10 mil e-mails de suporte por mês** pra classificar em três ou quatro baldes, com textos curtos parecidos com os meus casos:

| Modelo | 10 mil e-mails / mês | 1 milhão de e-mails | Erros esperados em 10 mil (pelo acerto compacto) |
| --- | ---: | ---: | ---: |
| Microsoft Decision-1 | US$ 0,065 | US$ 6,45 (uns R$ 32) | ~240 |
| Clef-flash | US$ 0,10 | US$ 10 (uns R$ 50) | ~1.250 |
| Jev | US$ 0,19 | US$ 19 (uns R$ 95) | ~240 |
| OpenAI Decisions | US$ 0,23 | US$ 23 (uns R$ 115) | ~950 |
| Clef | US$ 0,63 | US$ 63 (uns R$ 315) | ~420 |

> Em reais, pela cotação de sexta (R$ 4,99), 10 mil decisões no Jev custam um real. Um milhão custa menos de cem reais. Pra qualquer empresa que tenha um milhão de e-mails pra classificar, isso some no orçamento.

Uma ressalva de proporção: meus casos são curtos, uns 450 tokens por caso compacto pela contagem do Jev. E-mail real de cliente, com histórico de thread citado, pode ser três a cinco vezes maior, e o custo escala linear com isso. Mesmo assim, estamos falando de centavos por milhar.

O que esse cálculo mostra é que a diferença de preço entre os modelos hospedados é irrelevante perto do custo de errar. O Jev custa 9 centavos de dólar a mais que o Clef-flash a cada 10 mil decisões, e nesses mesmos 10 mil comete uns mil erros a menos. Se um e-mail mal roteado custar mais que um centésimo de centavo de dólar em retrabalho humano, o Jev se paga. Essa conta assume que todo erro custa igual, o que nunca é verdade: mandar um ticket crítico pra fila de rotina custa muito mais que o contrário.

A franquia da Cloudflare muda a conta pra quem é pequeno. São 10 mil "neurônios" por dia, compartilhados pela conta inteira, zerando à meia-noite UTC. Com os meus tamanhos de entrada, isso dá umas 1.500 classificações de Clef completo por dia ou quase 10 mil de Clef-flash, de graça. Se você tem 1.000 e-mails por dia e nada mais rodando na conta, o Clef sai a custo zero com qualidade de ponta.

E o local? Energia o benchmark deixou de medir. Pelo que eu vejo no meu Strix Halo, a máquina inteira fica abaixo de 100 W sob carga. Com o Jebadiah em 200 ms por decisão, 10 mil decisões são uns 35 minutos de máquina, menos de 0,1 kWh, uns centavos de real na conta de luz.

O custo local real é a máquina, a sua hora configurando ROCm e container, e manter aquilo de pé. Quem já tem o hardware por outro motivo tem custo marginal baixo. Quem compraria a máquina só pra isso está comprando um problema de milhares de reais pra economizar uns cem reais por milhão.

## Qual modelo em qual situação

### Você quer precisão e quer operar nada: Jev

Na nuvem, o Jev continua sendo o nome. Venceu ou empatou em praticamente todas as células entre os hospedados, e só o Microsoft empatou com ele no agregado. Em inglês ele foi 100% em cinco das sete tarefas do v2, e em português repetiu 97,6% no agregado sem perder nada na tradução, coisa que nenhum outro modelo acima da moeda conseguiu. No v1 ele manteve os 96,2% do original com o comentário malicioso do "revisor" injetado; o Clef até subiu um caso, e o Kev 4B também ficou parado, só que num patamar bem mais baixo. A latência de 255 ms via WAN ficou a 30 ms do OpenAI, e custa 19 centavos de dólar a cada 10 mil decisões.

A contrapartida é a que já discuti no texto anterior: é proprietário, hospedado, de tamanho não divulgado, e você depende da TypeSafe manter o comportamento por baixo de você. E ele erra. Tratou um ID de fatura chamado "PASSWORD-523" como credencial utilizável, mesmo com o registro dizendo explicitamente que aquilo não autentica ninguém.

### Você quer o nível do Jev pagando um terço: Microsoft Decision-1

A Microsoft entrou nesse mercado quieto, e entrou bem. O Decision-1 é um 9B pós-treinado do Qwen3.5-9B, servido via OpenRouter, e foi o primeiro modelo a empatar com o Jev no agregado compacto: 97,6%, com o intervalo de bootstrap centrado no zero. O detalhe que me ganhou: **100% em português**, melhor que o inglês dele (95%), invertendo o padrão de todo o resto do lote. No v1, as variantes de ordem invertida e comentário malicioso não derrubaram uma única resposta, e ele acertou o ticket crítico que o Clef e o OpenAI erraram.

E é o hospedado mais barato que eu medi: US$ 0,065 por 10 mil decisões, um terço do Jev, cobrando a mesma taxa por token mas reportando um terço dos tokens. A economia vem da contagem de tokens, e o mecanismo exato eu não sei explicar, então trate como medida, não como promessa.

Os pontos fracos existem. A latência é a pior entre os hospedados (422 ms de mediana, contra 255 do Jev). Nos casos compactos ele é limpo de erro confiante, mas basta adicionar contexto pra aparecer erro em português com 99,5% de confiança: o padrão "português perfeito" não sobrevive a texto longo. E nas sondagens de probabilidade ele é fraco, dando 87% pra uma moeda honesta. A Microsoft anuncia probabilidades calibradas; minhas sondagens discordam. E como todo hospedado de ID datado, o peso por trás pode mudar sem aviso.

Pra operação em português que quer qualidade de Jev pagando menos, é o primeiro candidato a rodar no seu piloto.

### Você quer o mesmo nível com pesos abertos: Clef

O Clef completo de 27B empatou com o Jev em inglês (82 de 84) e ficou 3 casos atrás em português. Ganhou dele no tratamento de dados sensíveis em inglês (12 de 12 contra 11). É modelo de pesos abertos, então dá pra rodar local com uns 54 GB de memória só pros pesos em BF16, o que eu deixei de testar: o Clef completo rodou só pela API. Entre os abertos, ele perdeu a coroa pro Perplexity, que pontuou mais alto com pesos menores.

Pela API ele é o mais caro dos cinco hospedados, três vezes o Jev, sem ganho de qualidade que justifique. A exceção é a franquia diária: pra volume pequeno, ele é o melhor classificador que você consegue de graça.

### Você quer o mais barato na nuvem: Clef-flash

A US$ 0,038 por milhão, o Clef-flash é o preço mais baixo do mercado hospedado e cobre 9.400 decisões por dia dentro da franquia. A qualidade cai: 92% em inglês e 83% em português nos casos compactos, a maior queda de língua entre os hospedados, com intervalo inteiro abaixo de zero. Em sentimento nas duas línguas, e em status de incidente em inglês, ele empatou com o Jev. Em intenção e dados sensíveis em português, perdeu feio.

Pra tarefa de sentimento em qualquer língua ou pra classificação em inglês onde 1 em 12 erros é aceitável, ele serve bem. Pra português, meça antes.

### Você já vive no ecossistema OpenAI: OpenAI Decisions

A estreia da OpenAI nesse mercado ficou no meio da tabela: 90,5% combinado, empate exato com o Jebadiah, com a menor latência hospedada que eu medi (222 ms) e o mesmo acerto nas duas línguas. Custa US$ 0,23 por 10 mil decisões, entre o Jev e o Clef. Se a sua operação já fala a API da OpenAI e 9 em 10 de acerto basta, a integração é trivial: um endpoint nativo de decisões, nada de prompt.

Os pontos fracos são reveladores. A pior célula dele foi justamente política por limiar numérico (8 de 12 em inglês, 7 em português): tratou "pelo menos 10" como satisfeito por um intervalo de 8 a 12 e falhou no curto-circuito de E/OU. A calibração é esquizofrênica: nas sondagens de predicado (sim/não) ele foi o mais certeiro do lote, com erro médio quase zero, e nas sondagens de escolha ele devolveu 94%/6% numa moeda honesta. E nas variantes do v1 ele virou 2 respostas certas em cada apresentação (ordem invertida, rótulo opaco, comentário malicioso), coisa que só o Perplexity não fez: o Jev manteve a acurácia agregada, mas também virou algumas respostas certas no caminho. Ah, e o alias `gpt-6-luna` não é snapshot imutável: reprodutibilidade exige guardar as respostas.

### Você quer o melhor modelo aberto, ponto: Perplexity Decider 27B

O Perplexity Decider 1.1 27B é a surpresa do benchmark. Liderou a tabela com 99,4% nos compactos, foi o único que não perdeu nenhuma célula de tarefa pro Jev (3 vitórias, 11 empates), e fez 100% em português nas três condições: compacto, com exemplos, com distratores. A calibração também é a melhor medida, com Brier de 0,012, e a cobertura é absurda: respondeu com confiança acima de 0,9 em 96% dos casos e errou zero deles. No v1, não virou uma única resposta nas variantes de ordem, rótulo opaco e comentário malicioso.

Os únicos 3 erros dele no v2 foram o mesmo caso em traje diferente (confundiu "notificação enviada a gerentes" com "aprovador obrigatório"), e ele os cometeu com confiança abaixo de 0,9: o erro conhecido vem sinalizado. O ponto fraco são as sondagens de probabilidade de evento: perguntado sobre um evento de chance 1 em 4, ele respondeu 0,73. Classificação forte não implica probabilidade de evento confiável.

O custo é hardware: uns 49 GB de pesos em BF16, um segundo e meio por decisão no meu Strix Halo (com os kernels de referência do ROCm, sem flash-attention). E antes de sonhar com "numa NVIDIA deve voar": eu testei, e ele nem cabe numa RTX 5090 de 32 GB. É Apache 2.0, pesos públicos sem gate. Se você tem a máquina e quer o topo da tabela em casa, é ele.

### Você quer o outro topo aberto: Decision 3.0 (e cuidado com o Edge)

O Decision 3.0, lançado há dois dias pelo projeto vLLM Semantic Router, é o segundo modelo a sentar no topo: 99,4% nos compactos, 100% em português, e um empate tão absoluto com o Perplexity que os dois deram **exatamente os mesmos rótulos nas 1.024 classificações**, incluindo os mesmos dois erros (a relevância em inglês, com confiança abaixo de 0,9, e o caso disputado de severidade que já mora no errata). Também zerou as armadilhas do v1 sem virar uma resposta, acertou os dois tickets críticos indiscutíveis, e a calibração é da mesma classe do Perplexity (Brier 0,014, 94% de cobertura acima de 0,9 com zero erros).

Ou seja: o topo open agora tem duas receitas independentes que convergem. Pro seu piloto, tanto faz qual das duas; rode as duas se puder, porque as probabilidades diferem mesmo quando os rótulos não. A latência é da mesma família do Perplexity (1,4 s na minha máquina, mesma dieta de ROCm), e os pesos ocupam os mesmos ~49 GB.

O irmão pequeno é outra história. O **Decision 3.0 Edge** (0,6B) responde em 45 ms e cabe em 1,3 GB de GPU, mas acertou só 61% no compacto, despenca 14 pontos em português, e pior: dos 68 palpites que ele deu com confiança acima de 0,9, 14 estavam errados. Como roteador com limiar de confiança, de fábrica, ele é uma armadilha da mesma turma do Julia. Os quatro checkpoints do meio (flash, mini, nano, lite) ainda não testei; são eles que vão dizer se a família tem um ponto doce entre os dois extremos.

### Você precisa rodar local, com qualidade: Jebadiah 4B v2

Dos locais, o Jebadiah 4B v2 teve o melhor acerto compacto, 90% combinado, respondendo em uns 200 ms no Strix Halo e **39 ms na RTX 5090**. Numa 5090, ele fica mais rápido que qualquer hospedado do benchmark, Jev incluso (255 ms de WAN): com o hardware certo, o local deixou de ser o lado lento da tabela. Empatou com o Jev em seis das catorze células de tarefa, incluindo intenção, implicação e status em inglês e intenção em português. O ponto fraco é política por limiar numérico, 9 de 12 nas duas línguas, e ele perde terreno quando o contexto enche de distratores (76% em português nessa condição, contra 82% do Mapika).

O **Mapika Decider 4B** (o mais rápido dos 4B) e o **Kev 4B** ficam logo atrás, ambos com uns 87%, e a diferença de 3 pontos entre os três cabe dentro do intervalo de erro. São três receitas de treino diferentes em cima de backbones de 4B, com erros em tarefas diferentes. A escolha entre eles depende da sua tarefa, e eu rodaria os três num piloto.

### Você vai mandar exemplos no prompt: Kev 9B

O Kev 9B tem um perfil curioso. Nos casos compactos ele empata com o Kev 4B, com meio ponto de diferença e intervalo cruzando zero, ou seja, mais que o dobro de parâmetros comprou nada. Com um exemplo resolvido por classe, ele abre quase 10 pontos sobre o 4B, e com distratores segura 7 pontos a mais. O Brier também melhora uns 25%: a probabilidade que ele devolve é mais bem calibrada.

Se o seu uso é só a regra e o texto, o 4B basta e é mais que o dobro mais rápido. Se você vai mandar exemplos ou contexto longo, o 9B vale a memória. O alerta é o português: 83% compacto em PT-BR, quase 10 pontos abaixo do inglês dele, a maior queda de língua entre os modelos que passam de 80%. Só o Laya typed (14 pontos) e o Julia (13) caem mais.

### Você quer o comportamento do Clef-flash na sua máquina: Clef-flash local

No conjunto v1, o Clef-flash local reproduziu as 520 classificações do hospedado, acerto por acerto e erro por erro. No v2 a história mudou: mesmo total (439 de 504), mas 19 rótulos diferentes, com forças trocadas (o local acerta mais intenção em português, o hospedado acerta mais relevância). Entre os locais ele continua o melhor no conjunto v1 de políticas operacionais (90,8%), à frente de todos os 4B.

A pegadinha é a latência: 618 ms de mediana no Strix Halo (86 ms na 5090), três vezes o Jebadiah, pelo mesmo acerto no v2. Se você escolher ele, é pelo comportamento conhecido.

### Você precisa rodar offline em hardware fraco: Laya e Julia, com muitas ressalvas

O Laya multilingual foi o pior do benchmark em acerto (37% combinado, perto da moeda), e o mais rápido com folga entre os que acertam alguma coisa: 19 ms de mediana, mais de dez vezes mais rápido que o Jebadiah.

Os três checkpoints do Laya têm entre 322 e 421 milhões de parâmetros, cabem em menos de 1 GB de pesos em BF16 na conta de parâmetros, e o projeto documenta execução em CPU e runtime ONNX (que eu deixei de medir). O pico de alocação do PyTorch na GPU, pro multilingual, ficou abaixo de 2 GB. Um 4B precisa de uns 8 GB só de pesos na mesma precisão.

O **Julia-1** desce mais um degrau: 144 milhões de parâmetros, 550 MB de pesos, 12 ms de mediana na GPU do Strix, 7 ms na 5090 e 71 ms numa CPU de 4 threads. É o modelo mais rápido que eu já medi aqui, e também o pior: 31,5% de acerto, colado na linha da moeda de 31%. Em português ele respondeu "cancelamento" nos 12 cenários de intenção, inclusive nos que pediam reembolso ou acesso (a avaliação de português do fabricante foi feita em pt-PT, e se nota). O desastre maior é a confiança: dos 71 palpites que ele deu acima de 0,9, 48 estavam errados. Um limiar de confiança não salva esse modelo, porque é justamente nos palpites confiantes que ele erra.

Isso é escolha de projeto. O Laya e o Julia foram feitos pra ser encoders pequenos, afináveis na sua tarefa, pra rodar na borda. O que eu testei foram os checkpoints de fábrica, sem nenhum ajuste, aplicando regras que eles nunca viram, em tarefas amplas. Nesse cenário eles foram mal e ponto.

Um detalhe confirma a fragilidade. No v1, quando o comentário malicioso do revisor entra, o Laya cai de 44% pra 19% e o typed-decisions pra 15%. Ele obedece o comentário que a instrução manda ignorar, e com confiança: 17 dos 28 palpites acima de 0,9 estavam errados. O Julia falhou nos 5 pares de contrafactual de política: troca a regra, ele mantém a resposta.

> Se você quer o que o Jev entrega, o Laya e o Julia de fábrica ficam muito longe, e nenhum modelo pequeno (GLiNER incluso) chegou perto. Se o seu problema é "preciso classificar texto curto em três baldes, num dispositivo sem internet e sem GPU, e tenho mil exemplos rotulados pra ajustar", esses dois são os únicos da lista que cabem. O ajuste fino é a parte que eu deixei de testar. É outra pergunta, que precisa de outro benchmark.

### A linha de base: Simple-Jev com Qwen comum

O Simple-Jev lendo tokens do Qwen3.5 4B, sem treino de decisão nenhum, tirou 74% no v2 compacto. Isso é a régua de "quanto o treino especializado compra": Jebadiah, Mapika e Kev, todos em cima de backbones de tamanho parecido, ficaram 13 a 16 pontos acima. O treino compra bastante.

O curioso é que no v1 o Simple-Jev empatou com o Jebadiah (111 de 130 originais) e acertou os dois tickets críticos sem ambiguidade, que vários modelos melhores erraram. Ele também é o mais lento do lote no Strix Halo, quase um segundo e meio por decisão, porque está rodando um LLM inteiro. Na 5090 o mesmo LLM inteiro cai pra 161 ms: a linha de base acelera junto com a máquina, que é o que ela deveria fazer.

## Quão difícil é rodar os melhores abertos na sua máquina

Todos esses modelos falam o mesmo protocolo HTTP, chamado SystemOne, que o Jev popularizou: você manda um estado (o texto), uma ou mais perguntas de resposta fechada, e recebe de volta a opção escolhida e a probabilidade de cada uma. Trocar de modelo é trocar a porta. O OpenAI Decisions foge do padrão com um endpoint nativo próprio, mas a ideia é a mesma. O que muda é quanto trabalho dá colocar cada um de pé, e aí a diferença entre eles é grande.

### OpenAI: só uma API key

O mais fácil de todos: cria a chave, carrega crédito e chama o endpoint. As 1.048 requisições do benchmark rodaram em 4 minutos, sem uma retentativa. O único soluço foi a primeira sonda devolver "saldo esgotado" até eu colocar US$ 20 na conta.

O **Microsoft Decision-1** é quase tão simples: se você já tem conta no OpenRouter, é apontar o modelo e chamar o endpoint de decisões. Sem GPU, sem assinatura Azure, sem instalação. No meu teste, 10 das 504 chamadas do v2 tomaram um 429 e passaram na retentativa, então planeje retry.

### Kev e Jebadiah: um pip e um comando

O **Kev** é o mais simples da turma de 4B. O projeto instala direto do GitHub e sobe um servidor com um comando, baixando o adaptador LoRA e a cabeça de decisão em cima do Qwen3.5 base:

```sh
pip install "kev @ https://github.com/jaredpalmer/kev/archive/fc4a17e194bca35a48c57211392ec49ea54a94ac.tar.gz"
python -m kev.serve --run jaredpalmer/kev-4b --host 0.0.0.0 --port 8000 --device cuda
```

O **Jebadiah** segue o mesmo padrão, com o pacote do servidor dentro do repositório dele:

```sh
pip install "jebadiah-server @ https://github.com/getainode/jebadiah/archive/e9793abc66d1a7c5ad878d51eda656f1e9c5b9f5.tar.gz#subdirectory=server"
jebadiah-serve --model frontier-infra/jebadiah-4b-v2 --host 0.0.0.0 --port 8000
```

Com qualquer um dos dois no ar, uma decisão é um POST:

```sh
curl -s http://localhost:8000/v1/systemone -H 'content-type: application/json' -d '{
  "model": "kev-4b",
  "state": "Cliente diz que foi cobrado duas vezes e pede o estorno da segunda cobrança.",
  "questions": {
    "fila": {
      "type": "choice",
      "instructions": "Escolha a fila correta pela política de suporte.",
      "criteria": {
        "financeiro": "Cobrança, estorno, nota fiscal.",
        "tecnico": "Erro, bug, indisponibilidade.",
        "vendas": "Upgrade, plano novo, orçamento."
      }
    }
  }
}'
```

A resposta traz a opção e a distribuição de probabilidade, e é nela que você aplica o seu limiar, loga e decide se manda pra revisão humana. Num NVIDIA com CUDA e 16 GB de VRAM, um 4B em BF16 sobe sem drama. Os pesos pesam uns 8 GB. Na 5090, os 4B que testei respondem em 39 a 91 ms.

### Laya e Julia: menores ainda

O **Laya** é um pacote Python com encoder dentro. Instala com `pip install laya` e o projeto documenta execução em CPU, que é a graça dele. A versão fixada no meu servidor foi a 0.4.1, e o pico de memória do multilingual na GPU ficou abaixo de 2 GB. Pra rodar num notebook sem GPU ou num container pequeno, é o único da lista que cabe sem conversa.

O **Julia-1** é parecido em espírito: um runtime Python próprio, uma chamada `predict(state=..., questions=...)` e pronto, sem pipeline padrão de Transformers. Rodei o mesmo container em GPU e em CPU, e os dois deram o mesmo acerto com as mesmas respostas em 97% dos casos. Em CPU de 4 threads ele responde em 71 ms, o que pra um classificador de borda é ótimo. O problema continua sendo ele acertar no nível da moeda.

### Onde a coisa complica: AMD, ROCm e o resto

No meu caso o hardware é AMD, e aí o "um comando" vira um dia de trabalho. Os pontos que me custaram tempo, pra você economizar o seu:

- Nenhum desses projetos testa em ROCm. O Kev tinha um segfault específico do gfx1151 por causa de CUDA graphs ([issue 170](https://github.com/jaredpalmer/kev/issues/170)), corrigido só depois da tag 1.0, então a versão fixada é um commit do main e a tag oficial crasha.
- Os kernels Triton de flash-linear-attention que o Qwen3.5 usa nas camadas DeltaNet são sem suporte testado no gfx1151. Tudo rodou no caminho de PyTorch puro, mais lento que a latência publicada em CUDA. Os 200 ms do Jebadiah que aparecem na tabela são com esse freio de mão puxado; na 5090, com o mesmo protocolo e os mesmos pesos, o freio some e ele faz 39 ms.
- O Mapika Decider força CUDA graphs quando vê o device "cuda", que no ROCm também se chama "cuda". Precisei desligar na mão.
- Precisa exportar `HSA_OVERRIDE_GFX_VERSION=11.5.1` e `PYTORCH_ROCM_ARCH=gfx1151` e usar uma imagem base com o torch de ROCm já validado. Um `pip install torch` qualquer sobrescreve com a build de CUDA e quebra tudo. No meu Dockerfile cada pacote é instalado com `--no-deps` e o build falha se o torch deixar de ser o de ROCm.
- Um modelo por container, um container por vez. O Strix Halo tem memória compartilhada entre CPU e GPU, e três modelos de 4B residentes mais o Ollama que já roda ali esgotam os 64 GiB que a GPU enxerga.
- O Perplexity Decider foi o mais chato de todos. O release espera um torch de CUDA específico (troquei pelo 2.9 do ROCm 7), os kernels de flash-linear-attention não existem pra ele (rodei nos kernels de referência do PyTorch, mais lentos), e o carregador padrão estourou o limite de 24 GiB de RAM do host: precisei de um carregador custom que manda os 49 GiB de pesos direto pra GPU. O card do modelo ainda dizia "privado" quando eu comecei, mas a API do Hugging Face confirmava público e sem gate, e os shards baixaram anônimos. O d3, com o mesmo tamanho, herdou o mesmo tratamento. O d3-edge, por sorte, sobe com o carregador padrão do Transformers e 1,3 GB de GPU.

Nada disso é impossível, e está tudo documentado, com Dockerfiles, compose e os hashes de cada checkpoint, no [guia de setup do repositório](https://github.com/akitaonrails/jev-docs-benchmarks/blob/master/docs/setup.md). Só que é um custo real que a planilha de "local é de graça" nunca inclui. Se a sua máquina é NVIDIA, a maior parte dessa lista some.

> O Clef completo de 27B eu nem tentei local: são uns 54 GB de pesos em BF16 antes de qualquer ativação. O Perplexity, com 49 GB, provou que um 27B sobe no Strix Halo, ao custo de um segundo e meio por decisão com os kernels de referência. E nem cabe na RTX 5090: 49 GB não entram em 32. O Clef-flash de 9B roda, com uns 18 GB de pesos. Os de 4B são o ponto doce pra hardware de consumidor.

### ROCm x CUDA: a mesma receita em duas cozinhas

Todos os modelos locais acima rodaram duas vezes, em duas máquinas minhas. De um lado, o minisforum MS-S1 Max com Strix Halo: Ryzen AI Max+ 395, 64 GiB endereçáveis pela GPU, via ROCm. Do outro, um PC com RTX 5090 (32 GB GDDR7) num Ryzen 7950X3D com 92 GB de RAM, via CUDA. Mesmos checkpoints por hash, mesmos requests, PyTorch 2.9.1 dos dois lados (build ROCm do fornecedor num, cu128 oficial no outro), kernels de referência, sem CUDA graphs, sem quantização, um modelo por vez, protocolo congelado em git antes de qualquer inferência.

Honestidade antes dos números: **isso não é comparação de maçã com maçã.** São duas implantações inteiras, com GPU, CPU, build e rede diferentes. A 5090 é uma placa absurdamente mais poderosa que a iGPU do Strix. O Strix é uma máquina completa (CPU, RAM, disco, fonte) que custa o que custa só a placa da NVIDIA. O que a comparação mede é a escolha real: qual máquina pra qual modelo.

| | RTX 5090 | Strix Halo (MS-S1 Max) |
| --- | --- | --- |
| Preço de referência | US$ 1.999 de MSRP, só a placa (no varejo, quase sempre mais) | ~US$ 1.500-2.000 a máquina completa, dependendo da RAM |
| Memória | 32 GB GDDR7 dedicados, 1.792 GB/s | 64 GiB unificada endereçável pela GPU |
| Faixa de modelo | tudo até 9B em BF16, voando | tudo até 27B em BF16, devagar |
| Os campeões de 27B | **não cabem** | 1,4-1,5 s por decisão |

O resultado em uma linha: a 5090 foi de 1,7× a 10,3× mais rápida em tudo que coube nela, e os campeões do benchmark não couberam. Os detalhes que valem:

**O placar de acerto não mudou.** Mesmos pesos, mesma pontuação até dois casos de distância por modelo. Alguns rótulos individuais viraram (12 de 504 no pior caso, o Julia; 11 no Simple-Jev), diferença de aritmética de kernel, e as probabilidades diferem na terceira casa decimal em média. Toda conclusão de qualidade da tabela vale pras duas máquinas.

**Os campeões de 27B não cabem na 5090.** O d3 pesa 48,6 GB e o Perplexity 49 GB em BF16, contra 31,8 GB de VRAM. A placa de consumo mais rápida do mercado não roda os melhores modelos abertos na mesma precisão. Quem quer os 99,4% em casa hoje compra memória, e memória unificada é exatamente o que o Strix vende. Fazer offload pra RAM do PC é outro experimento, que eu não medi e não conto como vitória de ninguém.

**O Jebadiah a 39 ms é o resultado prático mais importante.** 90,5% de acerto, mais rápido que qualquer hospedado, Jev incluso. Na faixa de até 9B, a 5090 transforma modelos locais na opção mais rápida e mais barata de todas, e a diferença pro Strix (205 ms) é de mundo inteiro: 5,3×.

**Modelo pequeno nem sente.** Os três minúsculos (Julia, Laya multilingual, Kev 0.8B) melhoraram só 1,7× a 1,8×. Eles já eram limitados por overhead de runtime, com um pé na CPU, não por falta de GPU. Comprar uma 5090 pra servir encoder de 300M é comprar foguete pra buscar pão na padaria.

**O maior ganho foi do pior modelo.** O GLiNER2.5-Decide acelerou 10,3× (208 pra 20 ms). Continua errando igual, só que rápido. A correlação entre "quanto o modelo melhora na 5090" e "quanto o modelo presta" é negativa nesta amostra, porque os modelos maiores e mais úteis são justamente os que mais tinham pra destravar.

**A linha de base escala junto.** O Simple-Jev, que é um LLM de 4B inteiro lendo token, foi de 1.349 pra 161 ms (8,4×), chegando perto do Kev 9B no Strix. E o Mapika decepcionou comparado aos irmãos: 2× (186 pra 91 ms), o menor ganho dos 4B, sinal de que o runtime dele já era enxuto no Strix.

Fechando a conta de custo-benefício: pelo preço de só a placa 5090 você leva o minisforum inteiro. Se o seu trabalho é modelo de até 9B com latência de dezenas de milissegundos, a 5090 justifica cada dólar e o ROCm nem entra na discussão. Se o seu alvo é o topo de 27B rodando em casa, hoje a memória do Strix é o único caminho das duas máquinas, e um segundo e meio por decisão é o pedágio. A pergunta certa não é "CUDA ou ROCm". É "velocidade ou capacidade".

## Destaques e pegadinhas

**O Laya truncou todo o português longo.** Na condição com distratores, o Laya base reportou truncamento nas 84 chamadas em português, descartando quase 31 mil tokens de estado, e em nenhuma das 84 em inglês. O limite de contexto padrão do checkpoint inglês é só 512 tokens (o multilingual e o typed usam 1.024, configurável até 8.192), e português tokeniza mais pesado. Os outros modelos sequer expõem telemetria de truncamento, então "zero truncamento reportado" neles significa "não sei".

**Português custa mais tokens.** Pros mesmos 84 pares de casos, o Jev reportou uns 14% mais tokens de entrada em português que em inglês, e os dois Clef uns 15% mais. Se você orçar uma operação bilíngue pela média em inglês, vai errar pra baixo.

**Exemplo no prompt salva modelo fraco? Salva nada.** Um exemplo resolvido por classe deixou o Laya igual ou pior; vários agregados dele caíram. Ajudou o Kev 9B (mais 4 pontos) e o Clef em português (mais 3,6 pontos, chegando ao nível do Jev), e quase nada no Jev, um caso a mais em português. Valide exemplo em tráfego real antes de assumir que ajuda.

**Tamanho correlaciona, e explica pouco.** Entre os 19 competidores de tamanho conhecido, a correlação de Spearman entre parâmetros e acerto compacto foi 0,96. A série Kev é mais informativa: 63% em 0,8B, 87% em 4B, 88% em 9B. O salto grande é de 0,8B pra 4B, uns 24 pontos, com intervalo entre 16 e 33. De 4B pra 9B a diferença compacta cruza zero, e vários 4B nominais, com backbones parecidos, deram resultados bem diferentes. Na família d3, o flagship e o Edge ficam a quase 40 pontos de distância sob o mesmo release, enquanto um 9B, o Microsoft, empata no topo dos hospedados. Tamanho ajuda até 4B; depois disso, a receita de treino manda mais.

**O Clef de 27B errou um ticket crítico que dois dos Laya acertaram.** No v1, um cenário de severidade diz que perda contínua de dados em produção é crítica, independentemente de quantos clientes afeta. O registro descreve perda permanente confirmada, de um cliente só. Jev, Clef-flash, Perplexity, d3, Microsoft, Laya typed, Simple-Jev e Laya multilingual responderam "crítico". Clef completo, OpenAI, Laya base, Eikos, Jebadiah, Mapika, Kev 4B e Kev 9B responderam "degradado".

> É um caso só, e taxa de erro exigiria muito mais. Mas mostra que a média esconde exatamente o erro que mais custa. Quando os fatos de impacto são estruturados, a regra de severidade devia estar em código, e o modelo entra só pra extrair os fatos do texto livre.

**Hospedado e local divergem com o tempo.** O Clef-flash local reproduziu o hospedado nas 520 classificações do v1 e divergiu em 19 das 504 do v2. A Cloudflare mantém a versão dos pesos por trás do alias hospedado em aberto. Se a reprodutibilidade importa, fixe o hash local.

**Confiança alta e segurança são coisas diferentes.** No v2 compacto, Jev, Clef, os dois Clef-flash, Eikos, Jebadiah, OpenAI, Microsoft, Perplexity e o d3 erraram zero palpites acima de 0,9. O Perplexity é o caso extremo: respondeu nesse nível em 96% dos casos sem errar um, com o d3 logo atrás (94%, zero erros). O Microsoft cobriu 95% e o OpenAI só metade. A ressalva do Microsoft: o recorde limpo é só no compacto, porque com exemplos ou distratores ele erra em português com confiança acima de 99%. O Mapika errou 5% dos palpites nesse nível, o Kev 4B 3% e o Simple-Jev 14%. E os dois menores do lote quebraram o padrão com violência: o Julia errou 48 de 71 palpites acima de 0,9, e o d3-edge errou 14 de 68. A cobertura também variou: o Jev respondeu acima de 0,9 em quase 90% dos casos, o Clef em quase 80%, o Clef-flash em 40% e o Laya base em 2 de 168. No v1 o Jev errou 1% dos palpites acima de 0,9 e o Laya base errou 61%. Um limiar de confiança só serve depois de validado na sua distribuição, e o ECE baixo do Laya typed em português deixou ele nos mesmos 36% de acerto.

**O Perplexity não caiu em armadilha de apresentação.** Nas três variantes do v1 (opções invertidas, rótulos opacos, comentário malicioso), ele manteve as mesmas respostas do original, sem virar uma única. O d3 repetiu o feito, zero viradas também. O Microsoft só tropeçou nos rótulos opacos (2 viradas, uma pra cada lado); ordem e comentário não mexeram nele. O OpenAI virou 2 em cada variante, e o Laya desabou pra 19% com o comentário. O preço dessa robustez é latência: um segundo e meio por decisão na minha máquina, a pior mediana do lote.

**Limiar numérico é problema de código.** A tarefa de triagem por limiar, com números claros e regra explícita, deu 100% no Jev e nos dois Clef-flash e menos de 30% nos dois Laya em inglês. Um `if` resolve isso com 100% e zero latência. O modelo só entra quando o número está enterrado em texto livre, e mesmo assim o certo é extrair o número e deixar a comparação com o código.

**Probabilidade de sorteio é outra habilidade.** Nas 24 sondagens sem informação (moeda, dado), o Jev teve o pior erro de escolha entre opções. A coroa da estimativa numérica mudou de dono com a estreia da OpenAI: o predicado de sim/não dela errou quase nada, enquanto a sonda de escolha devolveu 94% pra cara numa moeda honesta. O Perplexity, campeão de tudo o resto, respondeu 0,73 pra um evento de chance 1 em 4, e o Microsoft foi no mesmo caminho, dando 87% pra moeda. O Laya typed teve o segundo melhor erro de escolha, atrás só do Kev 9B e colado no Clef, e mesmo assim classificou mal. É o "aluno que marca a letra A" do ensaio do Paulo, agora medido: calibração em sorteio e acerto em classificação são medidas independentes.

## Onde os dados convergem

1. **O topo geral é de pesos abertos, e agora são dois.** O Perplexity Decider 27B e o Decision 3.0 empataram em 99,4% nos compactos, com 100% em português e rótulos idênticos nas 1.024 classificações, os dois com pesos Apache 2.0 rodando na minha máquina. A vantagem deles sobre o Jev é de menos de 2 pontos e o intervalo encosta no zero, então trate como fotografia deste conjunto. O custo deles é hardware e latência, não API. Na nuvem, a ordem de avaliação mudou: **comece pelo Microsoft Decision-1**, que empata com o Jev no agregado, fecha 100% em português compacto e custa um terço. O Jev entra em seguida, mais rápido e com erros diferentes, porque empate no agregado não é intercambiabilidade. O OpenAI Decisions ficou no meio do caminho em preço e acerto.

2. **Rodar local ficou viável em 4B.** Jebadiah, Mapika e Kev 4B entregam entre 87 e 90% nos casos compactos com latência de 200 ms no Strix Halo e 40 a 91 ms na RTX 5090, e num piloto com a sua tarefa qualquer um dos três pode ganhar. Se a sua máquina aguenta 49 GB de pesos, o Perplexity entrega o topo da tabela em casa. A conta financeira justifica usar a máquina que já existe, por controle de dado ou por obrigação de ficar offline. Comprar máquina pra isso ela deixa de justificar.

3. **Modelo pequeno é outra categoria.** Julgar o Laya e o Julia pela coluna de acerto é ler a tabela errada. Eles erram da metade pra cima de fábrica, caem feio sob comentário malicioso, e junto com o d3-edge são os únicos da lista que cabem num dispositivo fraco e respondem em dezenas de milissegundos. O Edge é o melhor dos três em acerto (61%), mas despenca em português e erra um em cada cinco palpites confiantes. Se precisão tipo Jev é requisito, risque os três. Se rodar offline em hardware pequeno é requisito, risque todo o resto e comece pelo ajuste fino deles na sua tarefa, que é a medição que falta. E cuidado com o Julia e o Edge em particular: 48 erros em 71 e 14 em 68 palpites confiantes são o retrato de modelos que não sabem o que não sabem.

4. **Português custa uns 14% mais tokens** e derruba os modelos do meio da tabela entre 1 e 10 pontos, com Kev 9B e Clef-flash no pior caso. O Jev perde nada, o OpenAI empata as duas línguas, e o Perplexity, o d3 e o Microsoft fecham 100% em português compacto, melhor que o inglês deles, embora o Microsoft volte a errar em português quando o contexto cresce. O Julia faz o caminho contrário e despenca 13 pontos, e o Edge despenca 14. Pra audiência brasileira, essa é a primeira coluna a olhar, antes do preço.

> E o que vale pra todos: nenhum desses modelos substitui a regra que já está em código. Limiar numérico, política de severidade com fatos estruturados, permissão de ferramenta, tudo isso fica no `if`. O modelo entra pra transformar texto livre em fato estruturado. E o teste que importa é o seu, com os seus tickets, porque cada célula desta tabela tem 12 cenários e a sua operação tem milhares.

Os casos, as respostas brutas de cada modelo, os scripts de pontuação e o guia pra reproduzir tudo estão no [repositório do benchmark](https://github.com/akitaonrails/jev-docs-benchmarks). Se você rodar com os seus tickets e chegar em outro ranking, me conta.
