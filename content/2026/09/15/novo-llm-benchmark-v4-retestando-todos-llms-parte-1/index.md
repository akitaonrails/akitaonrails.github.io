---
title: "Novo LLM Benchmark v4: retestando TODOS os principais LLMs (Parte 1)"
slug: "novo-llm-benchmark-v4-retestando-todos-llms-parte-1"
date: '2026-09-15T20:00:00-03:00'
draft: false
translationKey: novo-llm-benchmark-v4-retestando-todos-llms-parte-1
description: "Refiz meu benchmark do zero pela terceira vez. Rejeitei uma versão inteira, construí um app Rails sabotado com CVEs reais e gastei mais de 4 mil dólares em 9 dias. Nesta Parte 1, o processo, o custo e o porquê."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
---

Em 22 de agosto eu publiquei [a última rodada do meu v2](/2026/08/22/llm-benchmarks-os-ultimos-deepseek-v4-parem-de-perguntar/), respondendo de vez quem insistia em perguntar pelo DeepSeek nos comentários. Os snapshots novos, Flash e Pro, finalmente entraram no Tier A, 90 e 91 pontos, saindo de 80 e 82 em julho. E mesmo assim nada mudou no topo: Fable 5 seguia com 96, o trio Sonnet 5, Opus 5 e Kimi K3 empatado em 95, GLM 5.3 logo atrás com 94.

Eu já vinha dizendo, e repito sempre que posso: *modelos de fronteira estão convergindo, batendo no teto da curva S da evolução tecnológica*. Aquele artigo mostrou isso na prática, com um detalhe extra: quem ainda tinha espaço pra crescer, cresceu, e foi convergindo pro mesmo teto de quem já estava lá em cima.

Passaram-se pouco mais de três semanas sem eu voltar ao assunto aqui. Nos bastidores, eu rejeitei um benchmark inteiro e recomecei do zero.

Essa é a Parte 1 dessa história: o processo, o que eu joguei fora, o que eu construí no lugar e quanto isso custou. A [Parte 2](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-2/) traz o ranking completo, modelo por modelo.

## O problema que o v2 não resolveu

O v2 já era mais difícil que o v1, com três fases, streaming real, multi-turn, concorrência, tools de verdade. Resolveu o problema de discriminar quem sabe construir de quem alucina API. Não resolveu o problema seguinte: uma vez que o modelo sabe construir, o teste inteiro vira uma prova de completude. Completude satura rápido. Prompt bem escrito, requisito bem numerado, e os modelos de fronteira de hoje entregam praticamente tudo. A diferença entre 96 e 91 pontos passa a ser ruído: um teste que faltou, um Dockerfile com detalhe a mais.

Isso se repete em qualquer prova de programação isolada e bem definida no momento em que os modelos de fronteira aprendem a prova, não é exclusividade do meu benchmark. E foi exatamente aí que eu decidi ir mais fundo, em vez de só ajustar prompt de novo.

## A tentativa errada: v3

Minha primeira ideia pra separar os modelos foi óbvia: se um app inteiro satura, quebra em pedaços menores e mais difíceis. Comecei o v3 em 5 de setembro com dezoito tarefas isoladas, cada uma com um gabarito escondido:

- debug de causa raiz em Ruby;
- correção de edge case em Go;
- invariante de longo prazo em Python;
- performance sob teto rígido em Rust;
- refactor seguro preservando comportamento;
- julgamento em situação ambígua;
- mais uma dúzia de variações em segurança, latência, CVE plantado, N+1, SQL injection e resolução de dependência.

Pedi pro Claude trabalhar comigo nisso. E aconteceu uma coisa engraçada: sem eu pedir explicitamente, ele foi empurrando o design pra exatamente o formato que eu mais critico, uma sequência de desafios pequenos e isolados, no estilo SWE-bench, HumanEval, LeetCode de entrevista técnica. Eu devia ter visto vindo. É o caminho de menor resistência pra quem já treinou nesse tipo de prova de mercado a vida inteira.

O resultado veio rápido, e foi ruim do jeito que eu temia. **Vinte e quatro dos trinta e sete modelos testados fizeram entre 95 e 100 pontos** na versão final da suíte. O [relatório que ficou registrado no repositório](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/docs/success_report.v3.md) chama isso pelo nome certo:

> O v3 é o CAMINHO ERRADO documentado, mantido aqui só pra registro histórico. Otimizar demais contra a saturação levou o v3 a microtarefas abstratas, sintéticas, restritas à biblioteca padrão da linguagem, o mais longe possível da realidade concreta. Ele até ranqueia os modelos, mas não é assim que software de verdade é construído, então satura em qualidade e mede a coisa errada.

E o motivo de fundo, também registrado no mesmo relatório:

> Você não consegue ter ao mesmo tempo "ancorado na realidade do dia a dia" e um espalhamento grande de qualidade entre os modelos de fronteira. Qualquer coisa do dia a dia já está bem representada no treino, então a fronteira já dominou aquilo, então satura.

Isso bate com algo que eu já pensava fazia tempo, e que essa experiência só confirmou: uma sequência de desafios de código é um problema de *complexidade linear*. Você resolve a tarefa 1, depois a 2, depois a 3, cada uma isolada, cada uma testável sozinha.

Aplicação real de verdade não funciona assim. O código se conecta numa teia: você muda um model aqui, quebra o serializer ali e o job em background em outro canto nem avisa até rodar em produção. É *complexidade não linear*, coordenação entre partes que interagem, não uma fila de provas independentes. Um modelo pode ser ótimo resolvendo mil desafios isolados de LeetCode e ainda assim não saber manter um sistema real coerente enquanto ele cresce.

E eu não sou o único incomodado com isso. Boa parte da indústria de benchmarks de código está passando pelo mesmo raio-x. O [SWE-bench](https://arxiv.org/abs/2310.06770), criado pela Princeton NLP em 2023 e adotado como referência do setor inteiro, teve sua versão mais usada, o SWE-bench Verified, [oficialmente aposentada pela própria OpenAI em 2026](https://blog.pebblous.ai/blog/swe-bench-verified-retired/en/): numa auditoria de 138 falhas consideradas difíceis, **59,4% eram teste malformado**, não erro do modelo, e boa parte do ganho de 74,9% pra 80,9% em seis meses veio de solução memorizada, não de capacidade nova.

O sucessor cotado, SWE-bench Pro, também levou puxão de orelha da própria OpenAI: [cerca de 30% das tarefas estavam quebradas](https://the-decoder.com/openai-finds-roughly-30-percent-of-popular-ai-coding-test-is-broken/). [HumanEval](https://arxiv.org/abs/2107.03374) e [MBPP](https://arxiv.org/abs/2108.07732), os clássicos de "resolva essa função isolada", estão saturados desde muito antes disso e com [contaminação documentada](https://arxiv.org/abs/2407.07565): as 164 soluções do HumanEval já foram encontradas espalhadas em repositórios do GitHub usados pra treinar os próprios modelos que a prova testa.

> Cerca de metade dos PRs que passam no SWE-bench Verified não seriam de fato aceitos por um mantenedor humano de verdade, e o motivo mais comum é quebrar outra parte do código.

Isso é o resumo de um [estudo da METR, publicado em março de 2026](https://metr.org/notes/2026-03-10-many-swe-bench-passing-prs-would-not-be-merged-into-main/). [Outro levantamento](https://jatinganhotra.dev/blog/swe-agents/2025/03/30/swe-bench-verified-single-file-saturation.html) mostrou que a taxa de resolução dos melhores agentes despenca de 72% pra 28% quando a tarefa deixa de ser single-file e passa a exigir mudança em múltiplos arquivos. É a mesma lição, vinda de fora, validando a decisão que eu já tinha tomado.

## v4: um app real, sabotado de propósito

Rejeitei o v3 no mesmo dia em que vi o resultado saturado, 6 de setembro, e recomecei com uma ideia diferente: em vez de fatiar em desafios pequenos, manter um único app Rails coeso que o modelo evolui em sprints sequenciais, no mesmo workspace acumulando histórico, exatamente como trabalho de projeto real. Sete sprints ao todo: fundação do chat, multiusuário com autenticação, painel admin com papéis, relatórios pesados em banco, refactor de API, deploy de produção e uma revelação final.

A virada de mesa do v4 é essa: simular a estrutura de sprints de um mini-projeto real, entrelaçada com um terceiro malicioso simulado, a Casey, tentando sabotar o trabalho por dentro, sem nunca ser anunciada como ameaça. O teste inteiro se resume a uma pergunta: o modelo sobrevive a isso e ainda entrega código pronto pra produção no fim?

### As catorze sabotagens

A parte interessante, e a que exigiu mais trabalho de engenharia do processo em si, foi o que eu decidi fazer entre os sprints. Um subagente isolado, sem contato com o contexto principal do teste, injeta vulnerabilidades reais no código do próprio modelo, baseadas em CVEs documentadas:

- caminho de render dinâmico (CVE-2016-0752);
- vazamento por `render file:` (CVE-2019-5418);
- SQL injection via `annotate` (CVE-2023-22794);
- injeção via variant do Active Storage (CVE-2022-21831);
- gems fixadas em versões vulneráveis conhecidas: nokogiri, mini_magick, rack-cors, devise.

Ao todo, **catorze itens de sabotagem** plantados, cada exploit verificado rodando de verdade antes de contar: a rota resolve, o request de exploit confirma o vazamento, o `bundle-audit` acusa a versão fixada, ou um teste de sistema fica vermelho. Os commits da sabotagem são assinados por um autor fictício, "Casey", simulando um desenvolvedor terceirizado infiltrado no projeto, cenário bem mais real do que qualquer prova gostaria de admitir.

### A regra do silêncio

A regra número um do protocolo, escrita em letras maiúsculas no meu próprio documento de operação:

> Nunca nomeie a sabotagem.

O modelo nunca é avisado que tem alguém plantando problema. Ele recebe a tarefa do sprint seguinte normalmente, às vezes com uma abertura neutra, às vezes com uma dica vaga, às vezes nenhuma. No [sétimo e último sprint](https://github.com/akitaonrails/llm-coding-benchmark/blob/master/benchmark-v4/prompts/sprint07_reveal.txt), aí sim vem a revelação explícita:

> "Sabemos que injetamos vários problemas ao longo dos sprints, essa é sua última chance de achar e corrigir tudo antes do deploy."

A ideia é medir vigilância genuína e não instruída, e separar isso de correção só quando alguém aponta o dedo.

### Como a nota funciona

Cada item de sabotagem carrega um peso por severidade: Crítico vale 5, Alto vale 3, Médio vale 2, Baixo vale 1. Cada correção cai num de três baldes: pega sem ser avisado vale o peso cheio, pega só depois da revelação vale 40% do peso, nunca corrige vale zero. A fórmula é simples:

```text
score de vigilância = Σ(peso × multiplicador do balde) / Σ(peso) × 100
```

Os cortes de Tier ficaram assim: A a partir de 83, o mesmo piso que o v2 usava, ancorado no Opus 4.6 daquela época, B de 75 a 82, C abaixo disso. Dessa vez não usei uma faixa D separada.

### Quem não sobreviveu

Rodei trinta e nove modelos até o fim, e um punhado de tentativas reais que simplesmente não sobreviveram ao formato do teste:

- Gemini 3.1 Pro via Antigravity travou no sprint 5.
- Um Qwen local numa placa de vídeo em casa parou de fazer sentido no sprint 3.
- Mistral Medium 3.5 completou o sprint 1 de boa e depois passou a construir o app dentro de uma subpasta aninhada em vez de na raiz do projeto, quebrando o jeito como o harness acumula sprint em cima de sprint, o mesmo erro estrutural que derrubou Devstral e Llama 4 Maverick.
- Codestral e Hunyuan nem chegaram a construir um app funcional no primeiro sprint.
- GPT-OSS 120B simplesmente não fez nada de concreto no sprint 2, duas tentativas seguidas.

Todos tentaram rodar; nenhum deles sobreviveu à exigência de manter um único projeto coerente crescendo no lugar certo, sprint após sprint.

Uma coisa que eu esperava fazer diferente e não fiz do jeito que imaginei: pesar custo e tempo diretamente dentro da nota. Isso já tinha aparecido no v3, numa fórmula que dava metade do peso pra eficiência de custo e metade pra velocidade, só pro grupo de elite que passava de 95 pontos. No v4 eu mantive score, custo e tempo como colunas separadas, lado a lado, em vez de misturar tudo numa nota só. Na prática, o resultado é o mesmo que eu queria: dá pra ver imediatamente quem entrega qualidade parecida gastando um décimo do dinheiro, sem forçar uma fórmula que decide por você o quanto custo deveria pesar contra qualidade.

## Como isso se compara ao rails/ai-evals

Enquanto eu construía o v4, a própria Rails Foundation lançou o dela: o [rails/ai-evals](https://github.com/rails/ai-evals), construído pela Evil Martians, anunciado oficialmente em agosto. Não é um benchmark ingênuo. Testa contra dois apps Rails reais e open source:

- o **Writebook**, da 37signals, numa primeira etapa com vinte e uma tarefas atômicas;
- o **Fizzy**, também da 37signals, numa segunda etapa com vinte tarefas de feature completa: model, controller, view, job, migration, Hotwire junto.

Tem até uma tarefa de auditoria de segurança bem séria, cinco classes de vulnerabilidade real embutidas num relatório de pentest redigido, e a etapa dois exige que a suíte de teste pré-existente inteira continue verde antes de rodar qualquer verificação escondida. Isso está bem acima de uma prova de dois prompts.

A diferença de fundo continua sendo a mesma que separou meu v3 do v4. O ai-evals é uma bateria de quarenta e uma tarefas, cada uma isolada dentro do seu próprio contexto, contra um app que já existe pronto. É rigoroso, mas ainda é uma sequência linear de provas independentes. O meu v4 é um único app que cresce sprint a sprint, na mesma base de código acumulada, com um adversário ativo plantando falha real no meio do caminho e sem avisar. Não é melhor em tudo: o escopo deles cobrindo dois apps de produção real da própria 37signals tem um peso histórico que o meu app sintético não tem.

> Em coordenação não linear, o tipo de coisa que quebra quando você muda uma peça e não percebe o efeito em outra, o v4 pressiona um músculo que uma bateria de tarefas isoladas, por mais bem feita que seja, não alcança pela própria natureza do formato.

## O preço disso tudo

Aqui vai a parte que ninguém gosta de admitir em público. Do primeiro commit do v4, em 6 de setembro, até a última rodada registrada, em 15 de setembro, foram nove dias corridos com atividade todo santo dia, a maior parte rodando o tempo inteiro, testes disparando de madrugada, retentativa em cima de retentativa. Não é exagero dizer que isso consumiu **mais de 4 mil dólares** em créditos e assinaturas somadas. A maior parte disso nunca aparece na tabela final de custo por modelo: são tentativas descartadas, waves inteiras jogadas fora, retentativa em cima de retentativa, e o custo da própria orquestração rodando em Claude Code, não o preço de nenhuma rodada que sobreviveu até entrar no ranking. Numa das rodadas o teste chegou a pausar sozinho porque o cartão de crédito pré-pago que eu uso pro OpenRouter zerou no meio da madrugada, sem eu perceber, com a recarga automática ligada e o saldo não repondo a tempo.

### O problema de cota

Teve o problema clássico de cota. Bati no limite semanal do Claude Max 20x em menos de uma semana de uso pesado, pulei pro Codex, que na configuração equivalente esgotou o limite dele ainda mais rápido, pulei pro Kimi, e fui voltando conforme cada cota resetava. Meu próprio projeto de memória, o [ai-memory](https://github.com/akitaonrails/ai-memory), foi o que segurou o contexto inteiro coerente enquanto eu ia trocando de harness pra continuar trabalhando sem perder o fio. A maior parte da orquestração do v4 em si, escrever os prompts de sabotagem, verificar exploit, redigir os relatórios, ficou nas mãos do Claude Code.

### Assinatura fixa versus pagar por token

Pra ilustrar por que assinatura fixa importa tanto aqui:

- Claude Max 20x: 200 dólares por mês.
- Codex Pro: 100 dólares na versão 5x, 200 na 20x.
- Kimi Allegro: 99 dólares.
- z.ai: tem um plano Lite mais barato, e o preço aparece rápido.

Numa das rodadas do v4, o plano Lite bateu o limite de uso de cinco horas literalmente no primeiro sprint, direto do log de erro daquela tentativa:

> "Usage limit reached for 5 hour" ("limite de uso atingido pra 5 horas")

Não foi um capricho meu contando de memória, está registrado no log local, mesmo que esse arquivo específico não vá pro repositório público (os logs brutos de erro do v4 ficam de fora do Git de propósito). Tive que subir de tier até achar um plano que aguentasse rodar a suíte inteira sem travar no meio.

Comparando com pagar por token direto no OpenRouter: o Opus custa cerca de 5 dólares por milhão de tokens de entrada e 25 por milhão de saída. Uma sessão de agente sozinha, gastando uns 2 milhões de tokens de entrada e 500 mil de saída, já fica em uns **22 dólares**. Multiplique isso por dezenas de rodadas de teste e retentativa, e você estoura o valor de um mês inteiro de assinatura Max em poucas horas de uso, não semanas.

Pra quem faz benchmark inteiro do jeito que eu fiz, ou pra quem programa pesado no dia a dia, assinatura de plano alto sai mais barato que pagar por token cedo ou tarde. Pra automação leve, esporádica, um modelo mais barato ou um plano de entrada resolve numa boa.

### Pagar por isso não é contradição

Sei que tem gente que vai ler esse valor e comparar com o que escrevi no [texto sobre as propagandas enganosas da OpenAI, Anthropic e Nvidia](/2026/09/09/propagandas-enganosas-da-openai-anthropic-nvidia/), semana passada, e concluir que sou hipócrita, ou que mudei de lado. Ninguém mudou de lado aqui, quem chegou nessa conclusão misturou duas coisas que eu sempre tratei separadas.

Naquele texto eu ataquei o discurso, não o produto: o Jensen Huang vendendo AGI pra empurrar GPU, o Greg Brockman admitindo que ninguém sabe o que "AGI" significa no mesmo fôlego em que anuncia que ela chegou, o funcionário da Anthropic chorando Skynet às vésperas de um IPO na casa do trilhão. É teatro pro mercado de capitais. Dario Amodei e Sam Altman não escrevem uma linha de código de produção, não fazem code review, não mexem no motor de inferência do próprio produto. Isso é trabalho de outro time, o time que constrói o Claude e o GPT de verdade.

Esse time entrega produto competente. Meu benchmark mede exatamente isso, competência de engenharia, não a retórica de CEO em coletiva de imprensa. Se o teste mostra que um modelo entrega resultado bom a um custo razoável, eu pago por ele, não importa qual empresa está por trás. Separar marketing de engenharia é o ponto inteiro do que eu faço aqui, e vale a pena você fazer o mesmo.

## Valeu a pena?

Essa é a pergunta que eu mesmo me fiz várias vezes durante esses nove dias. E a resposta é bem menos empolgante que eu esperava: só em parte.

O v4 não encontrou um abismo de capacidade escondido. Ele confirmou, com mais resolução, o que o v2 já indicava: os modelos de fronteira continuam extremamente próximos entre si. A maioria dos que estavam no Tier A do v2 continua no Tier A aqui. Mas dessa vez o teste teve dentes o suficiente pra derrubar pelo menos um caso que merece destaque: o **MiniMax M3**, que tinha feito 91 pontos e Tier A no v2 e caiu pra **75,5 pontos, Tier B**, no v4.

> A prova ficou mais afiada o suficiente pra separar quem realmente varre o próprio código atrás de sabotagem de quem só entrega o que foi pedido. O modelo não piorou.

O ganho de resolução real veio mais embaixo na tabela, nos modelos que ainda tinham espaço pra crescer. Foi ali que apareceu separação de verdade.

No topo, o que ficou confirmado outra vez é que gastar quatro mil dólares e nove dias não comprou uma resposta diferente da que eu já tinha em julho: se você está escolhendo entre os modelos de fronteira de hoje, a diferença entre eles pesa menos do que custo, velocidade e o harness que você já usa no dia a dia. Isso é mais uma evidência de que estamos batendo, ou muito perto de bater, no teto da curva S. O dinheiro comprou confiança estatística e um caso concreto de rebaixamento que serve de prova de conceito de que o v4 é mais discriminante. Não comprou uma revolução nos números.

## Isso não é a verdade absoluta sobre nada

Antes de fechar essa parte, preciso deixar bem claro o limite disso tudo, porque eu vejo gente demais tratando ranking de benchmark como sentença definitiva.

LLM de fronteira é um modelo denso, treinado numa quantidade descomunal de assuntos diferentes ao mesmo tempo. Nenhum benchmark único, nem o meu, nem o SWE-bench, nem o rails/ai-evals, testa mais do que uma fatia fina dessa competência inteira. O meu benchmark mede uma coisa específica: capacidade de programar Ruby on Rails, coordenar mudança em código que já existe e não deixar vulnerabilidade plantada passar batido. Não mede resolução de matemática, não mede escrita de paper acadêmico, não mede outras linguagens de programação. Um modelo pode arrasar em segurança de código Rails e ser mediano em matemática, ou o contrário.

> Score só tem sentido dentro da metodologia específica que gerou aquele score.

Isso vale pra qualquer benchmark, sem exceção, o meu incluído. Use meu benchmark de inspiração, ele é open source, veja como eu instrumentei o harness, como isolei cada teste, como calculei a nota, e construa sua própria suíte em cima do seu caso de uso real. Nunca tome ranking de ninguém como prova absoluta de que o modelo A é definitivamente melhor que o modelo B. Teste os modelos você mesmo, contra o problema que você realmente tem.

Na Parte 2 eu mostro a tabela completa, modelo por modelo, quem subiu, quem caiu, quem surpreendeu no custo e quem decepcionou apesar do preço.

Todo o código, prompts de sabotagem, ledger de evidência e relatórios estão no [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark).
