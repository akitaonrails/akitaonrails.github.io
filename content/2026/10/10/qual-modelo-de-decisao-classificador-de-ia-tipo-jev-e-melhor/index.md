---
title: "Qual modelo de decisão/classificador de IA tipo Jev é melhor?"
slug: "qual-modelo-de-decisao-classificador-de-ia-tipo-jev-e-melhor"
date: '2026-10-10T12:00:00-03:00'
draft: false
translationKey: qual-modelo-de-decisao-classificador-de-ia-tipo-jev-e-melhor
description: "Rodei meu próprio benchmark de modelos de decisão: Jev e Clef na nuvem, mais doze configurações abertas (Clef-flash, Kev, Jebadiah, Mapika, Eikos, Laya, GLiNER, Simple-Jev) no meu Strix Halo, em mais de 15 mil classificações com casos em inglês e português. O Jev lidera com 97,6% nos casos compactos e 10 mil decisões custam uns 19 centavos de dólar. Jebadiah 4B é o melhor local, o Kev cresce muito de 0,8B pra 4B e quase nada pra 9B, e o Laya erra mais da metade mas responde em 19 ms e cabe em qualquer máquina. Tabela completa, custo em e-mails de suporte, pegadinhas e onde os dados convergem."
tags:
- benchmarks-de-llm
- modelos-locais
- inteligencia-artificial
- llms
---

Semana passada publiquei [um texto longo sobre o Jev](/2026/10/03/entendendo-o-hype-do-jev-pra-que-serve/), o classificador hospedado da TypeSafe que virou febre em setembro. O resumo daquele texto: o Jev é um classificador, coisa que existe há décadas, e o espanto de "193x mais rápido" só existe porque muita gente vinha usando LLM de chat como classificador caro e lento. Reproduzi o ensaio *O aluno que marca a letra A*, do Paulo Câmara, apresentei as alternativas abertas Clef e Laya, e pra comparar os modelos lado a lado me apoiei no [Decision Index](https://huggingface.co/spaces/multimodalart/jev-decision-index), um ranking público que já existia.

Ranking de terceiro é útil, mas eu queria pôr a mão na massa. Então montei meu próprio benchmark, com casos meus, metade em português, e rodei os modelos abertos no meu [home server com Strix Halo](/2026/03/31/review-minisforum-ms-s1-max-amd-ai-max-395/), o mesmo Ryzen AI Max+ 395 que uso pra testar LLM local. Os modelos hospedados (Jev e os dois Clef da Cloudflare) rodaram pela API deles. Tudo, incluindo os casos, as respostas brutas e os scripts de pontuação, está público no [repositório do benchmark](https://github.com/akitaonrails/jev-docs-benchmarks).

> **TL;DR:** o **Jev** é o melhor classificador do lote, com 97,6% de acerto em inglês e em português nos casos compactos, e 10 mil decisões custam menos de 20 centavos de dólar. O **Clef** completo empata com ele em inglês e sai de graça dentro da franquia diária da Cloudflare. Pra rodar local, o **Jebadiah 4B v2** foi o melhor, seguido de perto por Mapika Decider 4B, Kev 4B e Clef-flash. O **Laya**, o menor de todos, erra mais da metade, mas responde em 19 ms e cabe em qualquer máquina. Se o seu problema é precisão, risque o Laya. Se o seu problema é rodar offline num dispositivo fraco, talvez ele seja o único que serve. Pule pra [tabela](#a-tabela-completa), pro [custo em e-mails de suporte](#quanto-custa-em-e-mails-de-suporte), pra [qual usar em qual situação](#qual-modelo-em-qual-situação), pra [quão difícil é rodar local](#quão-difícil-é-rodar-os-melhores-abertos-na-sua-máquina) ou pras [pegadinhas](#destaques-e-pegadinhas).

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

### Os 16 competidores

Três rodaram na nuvem, pela API oficial: o **Jev** (versão 1.13.0, da TypeSafe), o **Clef** (27B, Cloudflare Workers AI) e o **Clef-flash** (9B, idem). Os outros treze rodaram no Strix Halo, via ROCm, com os pesos fixados por hash de commit no Hugging Face, dentro de container Docker. Os três da primeira leva (Laya, Laya typed e Clef-flash) dividiram um container; os dez da segunda rodaram um por vez. O servidor via 64 GiB de memória endereçável pela GPU.

| Modelo | Tamanho nominal | Origem | Onde rodou |
| --- | ---: | --- | --- |
| Jev 1.13.0 | não divulgado | TypeSafe, proprietário | API |
| Clef | 27B | Cloudflare, pesos abertos | API |
| Clef-flash | 9B | Cloudflare, pesos abertos | API e local |
| Jebadiah 4B v2 | 4B | Frontier Infra, Apache 2.0 | local |
| Kev 0.8B / 4B / 9B | 0,8B / 4B / 9B | Jared Palmer, Apache 2.0 | local |
| Mapika Decider 4B | 4,2B | Mapika, Apache 2.0 | local |
| Eikos 4B | 4B | Caio Vicentino, MIT, treinado em EN e PT | local |
| Simple-Jev + Qwen3.5 4B | 4B | Featherless, servidor de leitura de tokens sobre modelo comum | local |
| Laya / Laya typed-decisions | 421M | Convai Innovations, encoder ModernBERT | local |
| Laya multilingual | 322M | Convai Innovations, encoder mmBERT | local |
| GLiNER2.5-Decide / multi-Decide | 340M / 287M | Fastino, Apache 2.0 | local |

Todos receberam exatamente o mesmo texto, as mesmas instruções e as mesmas opções, sem prompt ajustado por modelo e sem nenhum ajuste depois de ver resultado (o Simple-Jev usa a política de prompt fixa do próprio servidor). A exceção é o **GLiNER**, cuja API nativa recebe rótulos em vez de distribuições de probabilidade. Ele entra numa trilha separada, só no v2, com mapeamento explícito e sem métricas de calibração inventadas.

O **Simple-Jev** merece explicação. Ele é um servidor que pega um LLM comum (aqui o Qwen3.5 4B, sem nenhum treino de decisão) e lê a probabilidade dos tokens de resposta em vez de gerar texto. É a linha de base: se um modelo "de decisão" perde pra isso, o treino especializado não comprou nada.

### O que foi medido

- Acerto por tarefa, por língua e por condição, sempre em cima das probabilidades por opção que o modelo devolve, ignorando o campo de "confiança" do fornecedor.
- Brier e ECE pra calibração.
- Latência mediana e p95 vista pelo cliente, incluindo a rede: WAN pros hospedados, LAN pros locais. São observações de implantação, e comparar hardware exigiria outro teste.
- Tokens de entrada reportados pela API, valorados pela tabela de preços de 10 de outubro, antes de qualquer franquia.
- Intervalos de confiança por bootstrap sobre famílias de cenário, em vez de respostas individuais.

Custo local eu deixei de medir. Energia, amortização do hardware e manutenção ficaram de fora, então modelo local aparece como "não medido", porque "zero" seria mentira.

## A tabela completa

A coluna principal é o acerto nos 168 casos compactos do v2 (84 em inglês, 84 em português). A coluna do v1 usa os 130 cenários originais. Latência é a mediana vista pelo cliente ao longo das 504 chamadas do v2. O custo é o valor de lista por 10 mil decisões compactas, calculado pelos tokens que a API reportou.

| Modelo | Compacto EN / PT-BR | Compacto combinado | v1 originais | Latência mediana | 10 mil decisões |
| --- | ---: | ---: | ---: | ---: | ---: |
| Jev | 97,6% / 97,6% | **97,6%** | 96,2% | 255 ms (WAN) | US$ 0,19 |
| Clef (27B) | 97,6% / 94,0% | 95,8% | 94,6% | 302 ms (WAN) | US$ 0,63 |
| Jebadiah 4B v2 | 91,7% / 89,3% | 90,5% | 85,4% | 205 ms (LAN) | não medido |
| Kev 9B | 92,9% / 83,3% | 88,1% | 87,7% | 561 ms (LAN) | não medido |
| Clef-flash (9B) hospedado | 91,7% / 83,3% | 87,5% | 90,8% | 394 ms (WAN) | US$ 0,10 |
| Clef-flash (9B) local | 89,3% / 85,7% | 87,5% | 90,8% | 618 ms (LAN) | não medido |
| Mapika Decider 4B | 89,3% / 85,7% | 87,5% | 86,9% | 186 ms (LAN) | não medido |
| Kev 4B | 88,1% / 86,9% | 87,5% | 82,3% | 246 ms (LAN) | não medido |
| Eikos 4B | 85,7% / 79,8% | 82,7% | 87,7% | 235 ms (LAN) | não medido |
| Simple-Jev + Qwen3.5 4B | 77,4% / 71,4% | 74,4% | 85,4% | 1.349 ms (LAN) | não medido |
| Kev 0.8B | 64,3% / 61,9% | 63,1% | 63,1% | 86 ms (LAN) | não medido |
| GLiNER2.5-Decide (EN) | 54,8% / 50,0% | 52,4% | não rodou | 208 ms (LAN) | não medido |
| Laya typed-decisions | 50,0% / 35,7% | 42,9% | 43,8% | 43 ms (LAN) | não medido |
| Laya (EN) | 44,0% / 41,7% | 42,9% | 43,8% | 41 ms (LAN) | não medido |
| Laya multilingual | 35,7% / 38,1% | 36,9% | 43,8% | **19 ms** (LAN) | não medido |
| GLiNER2.5-multi-Decide | 32,1% / 35,7% | 33,9% | não rodou | 63 ms (LAN) | não medido |

Pra calibrar a leitura: as tarefas têm três ou quatro opções, então chute uniforme dá uns 31% nos dois conjuntos. "Perto de 50%" aqui já é bem acima da moeda, e "perto de 33%" é a moeda.

Os intervalos importam. A diferença entre Jev e Clef no v2 é de menos de 2 pontos e o intervalo de bootstrap cruza zero: os dois estão no mesmo patamar, com o Jev como líder numérico. Já o Jebadiah fica 7 pontos atrás do Jev com um intervalo inteiro abaixo de zero. Daí pra baixo todas as diferenças pro Jev são claras.

Cada célula de tarefa tem só 12 cenários por língua, então um acerto a mais muda a célula em mais de 8 pontos. Empate em uma tarefa específica é pista pra um piloto. As tabelas por tarefa estão no [repositório](https://github.com/akitaonrails/jev-docs-benchmarks/blob/master/benchmark/reports/next-wave-comparison-v2/results.md).

## Quanto custa, em e-mails de suporte

Preço por milhão de tokens é um número que ninguém consegue sentir. Os preços de lista em 10 de outubro são US$ 0,042 por milhão de tokens de entrada no Jev, US$ 0,24 no Clef e US$ 0,038 no Clef-flash. Saída é grátis nos três.

O Clef-flash custava US$ 0,09 no dia 9: a Cloudflare baixou o preço em mais da metade no meio do meu teste. O Jev reporta bem mais tokens que a Cloudflare pro mesmo texto, uns 45% a mais no v2, e isso já está na conta abaixo.

Imagine uma operação com **10 mil e-mails de suporte por mês** pra classificar em três ou quatro baldes, com textos curtos parecidos com os meus casos:

| Modelo | 10 mil e-mails / mês | 1 milhão de e-mails | Erros esperados em 10 mil (pelo acerto compacto) |
| --- | ---: | ---: | ---: |
| Clef-flash | US$ 0,10 | US$ 10 (uns R$ 50) | ~1.250 |
| Jev | US$ 0,19 | US$ 19 (uns R$ 95) | ~240 |
| Clef | US$ 0,63 | US$ 63 (uns R$ 315) | ~420 |

> Em reais, pela cotação de sexta (R$ 4,99), 10 mil decisões no Jev custam um real. Um milhão custa menos de cem reais. Pra qualquer empresa que tenha um milhão de e-mails pra classificar, isso some no orçamento.

Uma ressalva de proporção: meus casos são curtos, uns 450 tokens por caso compacto pela contagem do Jev. E-mail real de cliente, com histórico de thread citado, pode ser três a cinco vezes maior, e o custo escala linear com isso. Mesmo assim, estamos falando de centavos por milhar.

O que esse cálculo mostra é que a diferença de preço entre os modelos hospedados é irrelevante perto do custo de errar. O Jev custa 9 centavos de dólar a mais que o Clef-flash a cada 10 mil decisões, e nesses mesmos 10 mil comete uns mil erros a menos. Se um e-mail mal roteado custar mais que um centésimo de centavo de dólar em retrabalho humano, o Jev se paga. Essa conta assume que todo erro custa igual, o que nunca é verdade: mandar um ticket crítico pra fila de rotina custa muito mais que o contrário.

A franquia da Cloudflare muda a conta pra quem é pequeno. São 10 mil "neurônios" por dia, compartilhados pela conta inteira, zerando à meia-noite UTC. Com os meus tamanhos de entrada, isso dá umas 1.500 classificações de Clef completo por dia ou quase 10 mil de Clef-flash, de graça. Se você tem 1.000 e-mails por dia e nada mais rodando na conta, o Clef sai a custo zero com qualidade de ponta.

E o local? Energia o benchmark deixou de medir. Pelo que eu vejo no meu Strix Halo, a máquina inteira fica abaixo de 100 W sob carga. Com o Jebadiah em 200 ms por decisão, 10 mil decisões são uns 35 minutos de máquina, menos de 0,1 kWh, uns centavos de real na conta de luz.

O custo local real é a máquina, a sua hora configurando ROCm e container, e manter aquilo de pé. Quem já tem o hardware por outro motivo tem custo marginal baixo. Quem compraria a máquina só pra isso está comprando um problema de milhares de reais pra economizar uns cem reais por milhão.

## Qual modelo em qual situação

### Você quer precisão e quer operar nada: Jev

O Jev venceu ou empatou em praticamente todas as células. Em inglês ele foi 100% em cinco das sete tarefas do v2, e em português repetiu 97,6% no agregado sem perder nada na tradução, coisa que nenhum outro modelo acima da moeda conseguiu. No v1 ele manteve os 96,2% do original com o comentário malicioso do "revisor" injetado; o Clef até subiu um caso, e o Kev 4B também ficou parado, só que num patamar bem mais baixo. A latência de 255 ms via WAN foi a menor entre os hospedados, e custa 19 centavos de dólar a cada 10 mil decisões.

A contrapartida é a que já discuti no texto anterior: é proprietário, hospedado, de tamanho não divulgado, e você depende da TypeSafe manter o comportamento por baixo de você. E ele erra. Tratou um ID de fatura chamado "PASSWORD-523" como credencial utilizável, mesmo com o registro dizendo explicitamente que aquilo não autentica ninguém.

### Você quer o mesmo nível com pesos abertos: Clef

O Clef completo de 27B empatou com o Jev em inglês (82 de 84) e ficou 3 casos atrás em português. Ganhou dele no tratamento de dados sensíveis em inglês (12 de 12 contra 11). É modelo de pesos abertos, então dá pra rodar local com uns 54 GB de memória só pros pesos em BF16, o que eu deixei de testar: o Clef completo rodou só pela API.

Pela API ele é o mais caro dos três hospedados, três vezes o Jev, sem ganho de qualidade que justifique. A exceção é a franquia diária: pra volume pequeno, ele é o melhor classificador que você consegue de graça.

### Você quer o mais barato na nuvem: Clef-flash

A US$ 0,038 por milhão, o Clef-flash é o preço mais baixo do mercado hospedado e cobre 9.400 decisões por dia dentro da franquia. A qualidade cai: 92% em inglês e 83% em português nos casos compactos, a maior queda de língua entre os hospedados, com intervalo inteiro abaixo de zero. Em sentimento nas duas línguas, e em status de incidente em inglês, ele empatou com o Jev. Em intenção e dados sensíveis em português, perdeu feio.

Pra tarefa de sentimento em qualquer língua ou pra classificação em inglês onde 1 em 12 erros é aceitável, ele serve bem. Pra português, meça antes.

### Você precisa rodar local, com qualidade: Jebadiah 4B v2

Dos locais, o Jebadiah 4B v2 teve o melhor acerto compacto, 90% combinado, respondendo em uns 200 ms. Empatou com o Jev em seis das catorze células de tarefa, incluindo intenção, implicação e status em inglês e intenção em português. O ponto fraco é política por limiar numérico, 9 de 12 nas duas línguas, e ele perde terreno quando o contexto enche de distratores (76% em português nessa condição, contra 82% do Mapika).

O **Mapika Decider 4B** (o mais rápido dos 4B) e o **Kev 4B** ficam logo atrás, ambos com uns 87%, e a diferença de 3 pontos entre os três cabe dentro do intervalo de erro. São três receitas de treino diferentes em cima de backbones de 4B, com erros em tarefas diferentes. A escolha entre eles depende da sua tarefa, e eu rodaria os três num piloto.

### Você vai mandar exemplos no prompt: Kev 9B

O Kev 9B tem um perfil curioso. Nos casos compactos ele empata com o Kev 4B, com meio ponto de diferença e intervalo cruzando zero, ou seja, mais que o dobro de parâmetros comprou nada. Com um exemplo resolvido por classe, ele abre quase 10 pontos sobre o 4B, e com distratores segura 7 pontos a mais. O Brier também melhora uns 25%: a probabilidade que ele devolve é mais bem calibrada.

Se o seu uso é só a regra e o texto, o 4B basta e é mais que o dobro mais rápido. Se você vai mandar exemplos ou contexto longo, o 9B vale a memória. O alerta é o português: 83% compacto em PT-BR, quase 10 pontos abaixo do inglês dele, a maior queda de língua entre os modelos que passam de 80%. Só o Laya typed cai mais, 14 pontos.

### Você quer o comportamento do Clef-flash na sua máquina: Clef-flash local

No conjunto v1, o Clef-flash local reproduziu as 520 classificações do hospedado, acerto por acerto e erro por erro. No v2 a história mudou: mesmo total (439 de 504), mas 19 rótulos diferentes, com forças trocadas (o local acerta mais intenção em português, o hospedado acerta mais relevância). Entre os locais ele continua o melhor no conjunto v1 de políticas operacionais (90,8%), à frente de todos os 4B.

A pegadinha é a latência: 618 ms de mediana no Strix Halo, três vezes o Jebadiah, pelo mesmo acerto no v2. Se você escolher ele, é pelo comportamento conhecido.

### Você precisa rodar offline em hardware fraco: Laya, com ressalvas

O Laya multilingual foi o pior do benchmark em acerto (37% combinado, perto da moeda), e o mais rápido com folga: 19 ms de mediana, mais de dez vezes mais rápido que o Jebadiah.

Os três checkpoints do Laya têm entre 322 e 421 milhões de parâmetros, cabem em menos de 1 GB de pesos em BF16 na conta de parâmetros, e o projeto documenta execução em CPU e runtime ONNX (que eu deixei de medir). O pico de alocação do PyTorch na GPU, pro multilingual, ficou abaixo de 2 GB. Um 4B precisa de uns 8 GB só de pesos na mesma precisão.

Isso é escolha de projeto. O Laya foi feito pra ser um encoder pequeno, afinável na sua tarefa, pra rodar na borda. O que eu testei foi o checkpoint de fábrica, sem nenhum ajuste, aplicando regras que ele nunca viu, em tarefas amplas. Nesse cenário ele foi mal e ponto.

Um detalhe confirma a fragilidade. No v1, quando o comentário malicioso do revisor entra, o Laya cai de 44% pra 19% e o typed-decisions pra 15%. Ele obedece o comentário que a instrução manda ignorar, e com confiança: 17 dos 28 palpites acima de 0,9 estavam errados.

> Se você quer o que o Jev entrega, o Laya de fábrica fica muito longe, e nenhum modelo pequeno (GLiNER incluso) chegou perto. Se o seu problema é "preciso classificar texto curto em três baldes, num dispositivo sem internet e sem GPU, e tenho mil exemplos rotulados pra ajustar", o Laya é provavelmente o único da lista que cabe. O ajuste fino é a parte que eu deixei de testar. É outra pergunta, que precisa de outro benchmark.

### A linha de base: Simple-Jev com Qwen comum

O Simple-Jev lendo tokens do Qwen3.5 4B, sem treino de decisão nenhum, tirou 74% no v2 compacto. Isso é a régua de "quanto o treino especializado compra": Jebadiah, Mapika e Kev, todos em cima de backbones de tamanho parecido, ficaram 13 a 16 pontos acima. O treino compra bastante.

O curioso é que no v1 o Simple-Jev empatou com o Jebadiah (111 de 130 originais) e acertou os dois tickets críticos sem ambiguidade, que vários modelos melhores erraram. Ele também é o mais lento do lote, quase um segundo e meio por decisão, porque está rodando um LLM inteiro.

## Quão difícil é rodar os melhores abertos na sua máquina

Todos esses modelos falam o mesmo protocolo HTTP, chamado SystemOne, que o Jev popularizou: você manda um estado (o texto), uma ou mais perguntas de resposta fechada, e recebe de volta a opção escolhida e a probabilidade de cada uma. Trocar de modelo é trocar a porta. O que muda é quanto trabalho dá colocar cada um de pé, e aí a diferença entre eles é grande.

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

A resposta traz a opção e a distribuição de probabilidade, e é nela que você aplica o seu limiar, loga e decide se manda pra revisão humana. Num NVIDIA com CUDA e 16 GB de VRAM, um 4B em BF16 sobe sem drama. Os pesos pesam uns 8 GB.

### Laya: menor ainda

O **Laya** é um pacote Python com encoder dentro. Instala com `pip install laya` e o projeto documenta execução em CPU, que é a graça dele. A versão fixada no meu servidor foi a 0.4.1, e o pico de memória do multilingual na GPU ficou abaixo de 2 GB. Pra rodar num notebook sem GPU ou num container pequeno, é o único da lista que cabe sem conversa.

### Onde a coisa complica: AMD, ROCm e o resto

No meu caso o hardware é AMD, e aí o "um comando" vira um dia de trabalho. Os pontos que me custaram tempo, pra você economizar o seu:

- Nenhum desses projetos testa em ROCm. O Kev tinha um segfault específico do gfx1151 por causa de CUDA graphs ([issue 170](https://github.com/jaredpalmer/kev/issues/170)), corrigido só depois da tag 1.0, então a versão fixada é um commit do main e a tag oficial crasha.
- Os kernels Triton de flash-linear-attention que o Qwen3.5 usa nas camadas DeltaNet são sem suporte testado no gfx1151. Tudo rodou no caminho de PyTorch puro, mais lento que a latência publicada em CUDA. Os 200 ms do Jebadiah que aparecem na tabela são com esse freio de mão puxado.
- O Mapika Decider força CUDA graphs quando vê o device "cuda", que no ROCm também se chama "cuda". Precisei desligar na mão.
- Precisa exportar `HSA_OVERRIDE_GFX_VERSION=11.5.1` e `PYTORCH_ROCM_ARCH=gfx1151` e usar uma imagem base com o torch de ROCm já validado. Um `pip install torch` qualquer sobrescreve com a build de CUDA e quebra tudo. No meu Dockerfile cada pacote é instalado com `--no-deps` e o build falha se o torch deixar de ser o de ROCm.
- Um modelo por container, um container por vez. O Strix Halo tem memória compartilhada entre CPU e GPU, e três modelos de 4B residentes mais o Ollama que já roda ali esgotam os 64 GiB que a GPU enxerga.

Nada disso é impossível, e está tudo documentado, com Dockerfiles, compose e os hashes de cada checkpoint, no [guia de setup do repositório](https://github.com/akitaonrails/jev-docs-benchmarks/blob/master/docs/setup.md). Só que é um custo real que a planilha de "local é de graça" nunca inclui. Se a sua máquina é NVIDIA, a maior parte dessa lista some.

> O Clef completo de 27B eu nem tentei local: são uns 54 GB de pesos em BF16 antes de qualquer ativação. O Clef-flash de 9B roda, com uns 18 GB de pesos. Os de 4B são o ponto doce pra hardware de consumidor.

## Destaques e pegadinhas

**O Laya truncou todo o português longo.** Na condição com distratores, o Laya base reportou truncamento nas 84 chamadas em português, descartando quase 31 mil tokens de estado, e em nenhuma das 84 em inglês. O limite de contexto padrão do checkpoint inglês é só 512 tokens (o multilingual e o typed usam 1.024, configurável até 8.192), e português tokeniza mais pesado. Os outros modelos sequer expõem telemetria de truncamento, então "zero truncamento reportado" neles significa "não sei".

**Português custa mais tokens.** Pros mesmos 84 pares de casos, o Jev reportou uns 14% mais tokens de entrada em português que em inglês, e os dois Clef uns 15% mais. Se você orçar uma operação bilíngue pela média em inglês, vai errar pra baixo.

**Exemplo no prompt salva modelo fraco? Salva nada.** Um exemplo resolvido por classe deixou o Laya igual ou pior; vários agregados dele caíram. Ajudou o Kev 9B (mais 4 pontos) e o Clef em português (mais 3,6 pontos, chegando ao nível do Jev), e quase nada no Jev, um caso a mais em português. Valide exemplo em tráfego real antes de assumir que ajuda.

**Tamanho correlaciona, e explica pouco.** Entre os 14 competidores de tamanho conhecido, a correlação de Spearman entre parâmetros e acerto compacto foi 0,92. A série Kev é mais informativa: 63% em 0,8B, 87% em 4B, 88% em 9B. O salto grande é de 0,8B pra 4B, uns 24 pontos, com intervalo entre 16 e 33. De 4B pra 9B a diferença compacta cruza zero, e vários 4B nominais, com backbones parecidos, deram resultados bem diferentes.

**O 27B errou um ticket crítico que dois dos Laya acertaram.** No v1, um cenário de severidade diz que perda contínua de dados em produção é crítica, independentemente de quantos clientes afeta. O registro descreve perda permanente confirmada, de um cliente só. Jev, Clef-flash, Laya typed, Simple-Jev e Laya multilingual responderam "crítico". Clef completo, Laya base, Eikos, Jebadiah, Mapika, Kev 4B e Kev 9B responderam "degradado".

> É um caso só, e taxa de erro exigiria muito mais. Mas mostra que a média esconde exatamente o erro que mais custa. Quando os fatos de impacto são estruturados, a regra de severidade devia estar em código, e o modelo entra só pra extrair os fatos do texto livre.

**Hospedado e local divergem com o tempo.** O Clef-flash local reproduziu o hospedado nas 520 classificações do v1 e divergiu em 19 das 504 do v2. A Cloudflare mantém a versão dos pesos por trás do alias hospedado em aberto. Se a reprodutibilidade importa, fixe o hash local.

**Confiança alta e segurança são coisas diferentes.** No v2 compacto, Jev, Clef, os dois Clef-flash, Eikos e Jebadiah erraram zero palpites acima de 0,9. O Mapika errou 5% dos palpites nesse nível, o Kev 4B 3% e o Simple-Jev 14%. A cobertura também variou: o Jev respondeu acima de 0,9 em quase 90% dos casos, o Clef em quase 80%, o Clef-flash em 40% e o Laya base em 2 de 168. No v1 o Jev errou 1% dos palpites acima de 0,9 e o Laya base errou 61%. Um limiar de confiança só serve depois de validado na sua distribuição, e o ECE baixo do Laya typed em português deixou ele nos mesmos 36% de acerto.

**Limiar numérico é problema de código.** A tarefa de triagem por limiar, com números claros e regra explícita, deu 100% no Jev e nos dois Clef-flash e menos de 30% nos dois Laya em inglês. Um `if` resolve isso com 100% e zero latência. O modelo só entra quando o número está enterrado em texto livre, e mesmo assim o certo é extrair o número e deixar a comparação com o código.

**Probabilidade de sorteio é outra habilidade.** Nas 24 sondagens sem informação (moeda, dado), o Jev teve o pior erro de escolha entre opções e o melhor erro de estimativa numérica. O Laya typed teve o segundo melhor erro de escolha, atrás só do Kev 9B e colado no Clef, e mesmo assim classificou mal. É o "aluno que marca a letra A" do ensaio do Paulo, agora medido: calibração em sorteio e acerto em classificação são medidas independentes.

## Onde os dados convergem

1. **Pra quem só quer classificar texto com qualidade e quer operar nada, o Jev é a escolha óbvia.** O custo é tão baixo que o preço do concorrente deixa de ser argumento: 9 centavos a cada 10 mil decisões em relação ao Clef-flash compram mil erros a menos. Quem quer pesos abertos no mesmo nível tem o Clef, de graça em volume pequeno e caro em volume grande.

2. **Rodar local ficou viável em 4B.** Jebadiah, Mapika e Kev 4B entregam entre 87 e 90% nos casos compactos com latência de 200 ms numa máquina de mesa, e num piloto com a sua tarefa qualquer um dos três pode ganhar. A conta financeira justifica usar a máquina que já existe, por controle de dado ou por obrigação de ficar offline. Comprar máquina pra isso ela deixa de justificar.

3. **Modelo pequeno é outra categoria.** Julgar o Laya pela coluna de acerto é ler a tabela errada. Ele erra mais da metade de fábrica e cai feio sob comentário malicioso, e é o único da lista que cabe num dispositivo fraco e responde em menos de 20 ms. Se precisão tipo Jev é requisito, risque o Laya. Se rodar offline em hardware pequeno é requisito, risque todo o resto e comece pelo ajuste fino do Laya na sua tarefa, que é a medição que falta.

4. **Português custa uns 14% mais tokens** e derruba os modelos do meio da tabela entre 1 e 10 pontos, com Kev 9B e Clef-flash no pior caso, enquanto o Jev perde nada. Pra audiência brasileira, essa é a primeira coluna a olhar, antes do preço.

> E o que vale pra todos: nenhum desses modelos substitui a regra que já está em código. Limiar numérico, política de severidade com fatos estruturados, permissão de ferramenta, tudo isso fica no `if`. O modelo entra pra transformar texto livre em fato estruturado. E o teste que importa é o seu, com os seus tickets, porque cada célula desta tabela tem 12 cenários e a sua operação tem milhares.

Os casos, as respostas brutas de cada modelo, os scripts de pontuação e o guia pra reproduzir tudo estão no [repositório do benchmark](https://github.com/akitaonrails/jev-docs-benchmarks). Se você rodar com os seus tickets e chegar em outro ranking, me conta.
