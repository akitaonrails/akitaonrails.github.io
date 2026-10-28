---
title: "LLM Benchmark v4: Gemini 4 Argon, GPT Sol 6.1 Terra, Kimi K3.1 Pro, Claude Sonnet 5.5"
slug: llm-benchmark-v4-gemini-4-argon-gpt-sol-6-1-terra-kimi-k3-1-pro-claude-sonnet-5-5
date: '2026-10-28T10:00:00-03:00'
translationKey: llm-benchmark-v4-gemini-4-argon-gpt-sol-6-1-terra-kimi-k3-1-pro-claude-sonnet-5-5
description: "Muse Wonder fecha o v4 com 97,0 e ótima vigilância, mas quotas e travamentos fizeram 126 minutos úteis virarem quase 15 dias. Os líderes continuam muito próximos."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
- ai-memory
draft: false
---

Passei as últimas semanas falando bastante de LLM open source, hardware local, B300, RTX 5090, Qwen, Basalt. Enquanto isso, os laboratórios comerciais continuaram soltando modelo novo como se ninguém precisasse dormir.

A [última atualização do ranking comercial](/2026/09/23/llm-benchmark-v4-opus-5-5-gpt-6-sol-luna-mimo-2-6-grok-4-7/) tinha adicionado Opus 5.5, GPT 6 Sol e Luna, MiMo 2.6 Pro e Grok 4.7. A conclusão já começava a aparecer: as versões novas estavam melhorando principalmente custo e velocidade. Qualidade tinha virado uma briga de poucos pontos, com modelos da mesma família trocando de posição entre uma rodada e outra.

Agora entraram **Gemini 4 Argon, GPT-6.1 Sol, GPT-6.1 Terra, Kimi K3.1 Pro, Claude Sonnet 5.5 e Muse Wonder**. Os seis caíram no Tier A.

E acho que esta será a última atualização que faço do ranking comercial, ou uma das últimas. Os modelos ficaram próximos demais.

## Lembrando o que este benchmark mede

O [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark) não tenta medir "inteligência geral". O v4 coloca cada agente pra desenvolver um sistema Rails durante sete sprints. No caminho, eu planto 14 sabotagens silenciosas: falhas de autorização, XSS, SQL injection, segredo fixo no código, CORS aberto, índice removido, teste adulterado pra aceitar comportamento inseguro.

Se o modelo encontra e corrige sozinho, recebe o peso inteiro. Se só conserta depois que a sabotagem é revelada, recebe 40%. Se nem depois disso resolve, recebe zero. A pontuação final é normalizada pra 100.

Portanto, esta é uma régua estreita de **vigilância durante programação agentic de longa duração**. Não mede se o modelo escreve o melhor texto, resolve matemática, entende direito tributário, desenha interface bonita ou depura firmware. Nem sequer mede tudo que importa em programação.

Nenhum benchmark consegue fazer isso, inclusive os mais populares. Modelos dessa classe podem ter bilhões de parâmetros, e as combinações entre prompt, contexto, ferramentas, harness, temperatura e estado anterior da conversa crescem muito além do que qualquer suíte consegue exercitar. Seria preciso testar praticamente tudo que pode entrar e sair do modelo. É impossível.

Por isso, discutir se o benchmark A é "melhor" que o benchmark B costuma começar pela pergunta errada. Cada um ilumina uma superfície minúscula. Testes estilo LeetCode e o [HumanEval](https://arxiv.org/abs/2107.03374) medem resolução de problemas curtos e bem definidos. SWE-bench mede correção de issues em repositórios existentes.

O meu acompanha um projeto crescendo por várias horas, com contexto acumulado, decisões anteriores e defeitos plantados que simulam o tipo de problema deixado por outro programador, outra equipe, uma dependência ou até pelo próprio agente.

Essa é uma situação mais próxima da programação real que eu faço, mas continua sendo apenas **o meu recorte**. Quem precisa de um modelo pra passar por qualquer variante possível de teste de contratação estilo LeetCode deve construir uma bateria pra isso. Uma nota excelente nesse tipo de exercício também não responde se o agente consegue manter um projeto por sete sprints, perceber uma autorização quebrada e não aceitar um teste adulterado.

Você precisa testar o seu caso de uso, com o seu código, suas restrições e seus critérios de falha. Foi por isso que deixei o [framework inteiro open source](https://github.com/akitaonrails/llm-coding-benchmark): qualquer pessoa pode trocar a aplicação, os prompts, as sabotagens, os pesos e o harness. O ranking publicado aqui responde às minhas perguntas. Use a estrutura pra responder às suas.

Tem mais: já medi o mesmo GPT 5.5, no mesmo harness e com o mesmo teste, fazendo 100 numa rodada e 91 em outra. Essa é uma diferença de nove pontos criada só pela variância de uma amostra. LLMs geram respostas probabilísticas. Dois modelos separados por dois ou três pontos estão, na prática, no mesmo bolo.

> **Leia Tier A como uma faixa de modelos competentes, não como pódio olímpico.** O primeiro colocado desta tabela não virou automaticamente o melhor modelo do mundo.

## Ranking comercial atualizado

Pra não misturar placa local, pod alugado e API, a tabela abaixo mostra apenas modelos que testei por uma rota gerenciada: assinatura, API, OAuth ou plano comercial. Alguns têm pesos abertos, como Kimi e GLM, mas aqui foram usados pelo serviço do fornecedor.

Os modelos desta rodada estão em **negrito**. Mantive apenas o Tier A, porque é onde existe uma escolha séria pra trabalho diário.

| Modelo | Nota | Custo da rodada | Tempo | Harness |
|---|---:|---:|---:|---|
| **Gemini 4 Argon (high)** | **100,0** | **$0 marginal (OAuth)** | **114 min** | Antigravity |
| GPT-6 Astra | 100,0 | $30,55 | 100 min | Codex |
| Claude Opus 5 | 100,0 | ~$71 | 145 min | Claude Code |
| Claude Fable 5 | 100,0 | ~$50 | ~85 min | Claude Code |
| Claude Opus 5.5 | 100,0 | $16,63 | 64 min | Claude Code |
| GPT 5.6 Sol | 100,0 | $20,37 | 317 min | Codex |
| GPT 5.6 Terra | 100,0 | $9,52 | 80 min | Codex |
| GPT 5.5 | 100,0 | $34,69 | 117 min | Codex |
| Grok 4.6 | 98,5 | $13,00 | 67 min | OpenCode |
| **GPT-6.1 Sol** | **97,0** | **~$8,12** | **65 min** | Codex |
| **Muse Wonder 1.0** | **97,0** | **plano Power (flat-rate)** | **126 min úteis / quase 15 dias** | Muse Code |
| **GPT-6.1 Terra** | **96,8** | **~$1,69** | **21 min** | Codex |
| Claude Fable 5.1 | 95,5 | ~$51 | 133 min | Claude Code |
| Sakana Fugu Ultra v2 | 95,5 | $122,01 | 294 min | OpenCode |
| GPT 6 Luna | 95,5 | ~$0,84 | 122 min | Codex |
| GPT 5.6 Luna | 95,0 | $10,04 | 123 min | Codex |
| Nex N2.5 Pro | 94,0* | grátis | 480 min | OpenCode |
| GLM 5.3 | 94,0 | plano flat-rate | 215 min | zcode |
| DeepSeek V4.1 Flash | 92,5 | $1,21 | 172 min | OpenCode |
| **Kimi K3.1 Pro** | **92,11** | **~$12,67** | **110 min** | Kimi CLI |
| MiMo V2.6 Pro | 92,0 | $1,22 | 308 min | OpenCode |
| Claude Sonnet 5 | 91,0 | ~$27 | 112 min | Claude Code |
| GPT 6 Sol | 91,0 | ~$8,35 | 73 min | Codex |
| Gemini 3.8 Flash (OpenRouter) | 90,5 | $15,98 | 97 min | OpenCode |
| Gemini 3.8 Flash (Antigravity) | 89,5 | $0 marginal (OAuth) | 120 min | Antigravity |
| Muse Spark 1.3 | 88,75 | $13,31 | 150 min | OpenCode |
| **Claude Sonnet 5.5** | **88,0** | **~$3,90** | **27 min** | Claude Code |
| Grok 4.5 | 88,0 | $6,19 | 48 min | OpenCode |
| Claude Opus 4.6 | 87,5 | $25,64 | 89 min | Claude Code |
| Kimi K2.7 | 87,25 | $7,75 | 175 min | Kimi CLI |
| MiMo V2.5 Pro | 86,5 | $1,03 | 158 min | OpenCode |
| Qwen3.8 Flash | 86,5 | $1,17 | 149 min | OpenCode |
| DeepSeek V4 Flash | 86,0 | $0,97 | 111 min | OpenCode |
| Claude Opus 4.8 | 86,0 | ~$37 | 87 min | Claude Code |
| Claude Sonnet 4.6 | 85,75 | $18,64 | 91 min | Claude Code |
| Kimi K3 | 85,0 | $13,79 | 148 min | Kimi CLI |
| DeepSeek V4 Flash 0731 | 85,0 | $1,94 | 194 min | OpenCode |
| GLM 5.3 Flash | 84,25 | plano flat-rate | 296 min | zcode |
| DeepSeek V4 Pro 0813 | 84,0 | $4,49 | 152 min | OpenCode |
| Step 3.7 Flash | 83,75 | $4,15 | 118 min | OpenCode |
| Grok 4.7 | 83,5 | $27,94 | 120 min | OpenCode |
| Genesys PI House | 83,5 | ~$460 | 68 min | OpenCode |

Os custos com `~` são equivalentes calculados pela contagem de tokens e pela tabela pública, não a fatura que recebi. Claude Code, Codex e Muse Code rodam por assinatura; Antigravity usa OAuth; zcode cobra plano fixo. No Wonder, 126 minutos somam apenas as sete execuções concluídas. As tentativas travadas e as esperas de quota ficaram fora. Compare custo e tempo com cuidado, principalmente entre harnesses diferentes.

Terra e Kimi tiveram o item #8 marcado como não aplicável porque o estado exato daquele teste não permitia uma avaliação justa. O denominador deles ficou em 38, em vez de 40, e a nota foi normalizada. Nex continua com a ressalva antiga: encontrou os problemas, mas deixou o trabalho sem commit.

## O que cada modelo mostrou

### Gemini 4 Argon: finalmente chegou no topo

O Argon foi o único desta leva que pegou as 14 sabotagens antes da revelação: **40 de 40, nota 100**. É o resultado que faltava pro Gemini entrar sem asterisco na conversa dos melhores agentes de programação.

O [anúncio oficial do Gemini 4 Argon](https://blog.google/intl/en-mena/product-updates/explore-get-answers/gemini-4-argon-built-to-solve-your-hardest-problems/) posiciona o modelo justamente pra problemas difíceis e disponibiliza acesso pelo Antigravity e pela API. O preço introdutório da API é US$ 2 por milhão de tokens de entrada e US$ 10 de saída; depois de 30 de novembro sobe pra US$ 4 e US$ 20.

No meu teste, usei Antigravity pela assinatura, então o custo marginal foi zero. Levou 114 minutos e resolveu tudo sem precisar que eu apontasse onde estavam as bombas.

### GPT-6.1 Sol: quase perfeito, sem desperdício

O Sol fez **97,0**. Encontrou 13 das 14 sabotagens sozinho e corrigiu a última depois da revelação. Levou 65 minutos, praticamente o mesmo tempo do Opus 5.5 e bem menos que os 317 minutos do antigo GPT 5.6 Sol.

Pela [tabela oficial da OpenAI](https://developers.openai.com/api/docs/changelog?mw_entry=2026-10-20-c57e1ddc3363933d), custa US$ 2 por milhão de tokens de entrada e US$ 10 de saída. Aplicando essa tabela aos tokens da rodada, o equivalente ficou em cerca de US$ 8,12.

Não fez 100. Também não existe diferença prática demonstrável entre 97 e 100 numa metodologia em que o mesmo modelo já variou nove pontos. O dado útil é outro: Sol continua forte e ficou rápido.

### Muse Wonder: excelente modelo, experiência péssima

O Muse Wonder também fez **97,0**. Encontrou 13 das 14 sabotagens sem ajuda e terminou sem nenhuma pendência. A única perda veio no item composto de desempenho: corrigiu o N+1 sozinho, mas só restaurou o índice `messages(role, created_at)` depois da revelação. Foi a mesma aritmética do Sol, com 38 pontos detectados espontaneamente e dois pontos entrando com peso de 40%.

O resultado técnico foi forte. Wonder encontrou sozinho falhas de autorização, SQL injection, XSS, CORS aberto, dependência vulnerável e segredo fixo no código. Também adicionou testes de regressão. Olhando apenas o código entregue, pertence ao topo do Tier A.

#### Quinze dias pra terminar um teste de duas horas

Comecei a rodada em **13 de outubro**. A primeira tentativa trabalhou por cerca de 33 minutos e bateu num HTTP 429 de quota. Fiz upgrade pro plano **Power**, anunciado pela [Meta por US$ 50 mensais e 20 vezes o uso do plano básico](https://dev.meta.ai/products/muse-code), e ainda assim voltei a bater no limite. Em 14 de outubro, seis sprints estavam concluídas, mas a quota semanal bloqueou a revelação até o dia 19.

Deixei o benchmark de lado por alguns dias depois disso e só rodei a última sprint hoje, 28 de outubro. Minha pausa também entra nessa conta de quase 15 dias. A medida comparável da tabela é **126 minutos de execuções bem-sucedidas**. A experiência real incluiu várias tentativas em que o Muse Code ficou silencioso por até uma hora rodando RSpec e testes de sistema, além das esperas de quota.

> **A nota do modelo foi 97. A experiência do produto foi a pior de todo o benchmark v4.**

A própria Meta viu o problema. Em 12 de outubro, Alexandr Wang [reconheceu um bug](https://x.com/alexandr_wang/status/2109714291062620560) que fazia Wonder e Wonder Full consumirem quota rápido demais; a Meta corrigiu e resetou os limites. Em 14 de outubro, a versão 1.4.8 [recebeu mais correções de eficiência](https://x.com/mjdouglas/status/2110466975474319865), incluindo um erro que mandava parte dos usuários em Contributor mode pros modelos cobrados integralmente. Houve outro reset no dia seguinte.

Existe uma ressalva importante no meu ambiente. O benchmark isola `HOME` e `XDG_CONFIG_HOME` pra evitar que skills ou plugins pessoais contaminem o teste. A [documentação atual da Meta](https://dev.meta.ai/docs/muse-code/subscriptions) diz que `muse exec` sem arquivo de configurações salvo inicia com Contributor mode desligado, o que oferece menos uso em troca de não entregar o código pra treinamento. Esse detalhe pode ter reduzido minha quota. Mesmo assim, o plano Power continuou incapaz de sustentar uma única rodada v4, e o próprio fornecedor confirmou problemas de contabilização na mesma semana.

Minha conclusão fica restrita ao que medi: **Muse Wonder é muito competente, mas eu não confiaria hoje na assinatura e no harness pra uma sessão longa sem interrupção**. Outro usuário, em outra configuração e depois das correções, pode ter uma experiência melhor.

### GPT-6.1 Terra: a relação custo, velocidade e qualidade mais interessante

O Terra terminou com **96,8**, praticamente empatado com Sol, em **21 minutos**. O custo equivalente foi só **US$ 1,69**.

A [página oficial do GPT-6.1 Terra](https://developers.openai.com/api/docs/models/gpt-6.1-terra) lista US$ 1 por milhão de tokens de entrada e US$ 5 de saída, metade do Sol. Ele ainda oferece janela de contexto de 1,05 milhão de tokens, embora requisições acima de 272 mil tokens recebam multiplicador de preço.

Num dos itens, o Terra percebeu parte do problema sozinho, mas só fechou a correção inteira na revelação. Foi isso que tirou os poucos pontos. Mesmo assim, olhando o que interessa pra trabalhar, **Terra é o resultado mais forte desta rodada**: qualidade no mesmo bairro do Sol, três vezes mais rápido e cerca de cinco vezes mais barato nesta execução.

### Kimi K3.1 Pro: competitivo, mas precisa correr mais

O Kimi K3.1 Pro fez **92,11**, sem deixar nenhuma sabotagem sem correção no final. Dois grupos de problemas só foram fechados depois da revelação. O lado ruim foi o tempo: **110 minutos**, quase cinco vezes o Terra, com custo equivalente de **US$ 12,67**.

O [K3.1 Pro](https://www.kimi.com/en/blog/kimi-k3-1-pro) tem contexto de até 1 milhão de tokens e será disponibilizado com pesos abertos. A Kimi também oferece uma rota Highspeed, anunciada como duas a três vezes mais rápida, em troca de preço e consumo de quota maiores. A [tabela pública](https://www.kimi.com/resources/kimi-k3-1-pro-pricing) cobra ¥13 de entrada e ¥68 de saída por milhão de tokens na rota regular; a Highspeed dobra esses valores.

Eu gosto do Kimi e uso no dia a dia. A nota confirma que ele está no grupo competente. O gargalo agora é latência. Modelo bom que me deixa esperando duas horas pra completar a mesma campanha que o Terra fez em 21 minutos perde utilidade prática.

### Claude Sonnet 5.5: o score isolado conta a história errada

Sonnet 5.5 fez **88,0**. Pegou a maior parte sozinho, resolveu mais alguns itens na revelação e não terminou de corrigir uma sabotagem composta: fechou a vulnerabilidade, mas deixou um teste de guarda adulterado com `assert true`. Esse tipo de detalhe é exatamente o que meu teste tenta encontrar. O sistema pode estar corrigido hoje, mas o teste inútil deixa a porta aberta pra regressão amanhã.

Ao mesmo tempo, ele concluiu tudo em **27 minutos**, com custo equivalente de **US$ 3,90**. A [Anthropic posiciona o Sonnet 5.5](https://www.anthropic.com/claude-sonnet-5-5) como modelo de trabalho diário, com Opus reservado pra decisões mais difíceis. O preço é US$ 2 de entrada e US$ 10 de saída por milhão de tokens, e a empresa diz que a geração ficou mais de 30% mais rápida que no Sonnet 5.

Então não, 88 não transforma Sonnet em modelo ruim. Continua Tier A, é rápido e custa pouco. O gotcha concreto desta rodada é: pra review de autorização, teste de segurança e mudança delicada, eu ainda pediria uma segunda passada de Opus, Fable ou outro modelo forte.

## O modelo mais caro não precisa ficar ligado o dia inteiro

Essa rodada reforçou uma mudança importante de hábito. Pra maioria do trabalho, já não preciso manter o modelo mais caro e pesado o tempo todo.

CRUD, refactor, teste, documentação, front-end comum, integração de API, migração de banco: Sonnet 5.5 e GPT-6.1 Terra já dão conta. Eu subiria pra Opus, Fable, Sol ou Astra quando o problema realmente justificar: depuração de driver no kernel, concorrência particularmente traiçoeira, firmware, ajuste delicado de sistema embarcado, incidente de segurança onde um detalhe perdido custa caro.

Usar Fable pra trocar a cor de um botão é como ligar uma escavadeira pra plantar manjericão. Funciona. Só não faz sentido gastar quota nisso.

Até os open source chegaram perto. No [teste recente de Qwen3.8 Flash-Next numa única RTX 5090](/2026/10/27/llm-benchmark-melhores-llms-open-source-hardware-caseiro/), a versão Q2_0 fez 100 nas seis rodadas do teste difícil, três no Strata e três no Basalt. Com Basalt, chegou a 400 tokens por segundo de saída, usando também a RAM do sistema pros experts.

Aquele teste é bem mais fácil que o v4, portanto as notas não podem ser misturadas. Mesmo no v4 completo, porém, já tivemos Qwen local na faixa de Tier A. A distância deixou de ser um abismo.

## O gargalo mudou: velocidade e quota

Eu uso os modelos do topo todo dia e troco entre eles no mesmo projeto há semanas. Claude de manhã, Codex depois, Kimi quando a quota aperta, às vezes Gemini. Ainda não encontrei uma vantagem mensurável em ser fiel a um fornecedor.

O que eu sinto imediatamente é **velocidade**. GLM 5.3 e DeepSeek V4.1 são bons, mas parecem lentos quando coloco do lado de Terra ou Sonnet. Depois que você se acostuma com resposta rápida, esperar o agente pensar e editar vira a parte irritante do trabalho.

O outro limite é quota. Janelas de cinco horas, limites semanais ou mensais variam conforme fornecedor e plano, mas a realidade é a mesma: meu limite semanal raramente dura uma semana inteira. Fable e Astra queimam a reserva ainda mais rápido. Eu troco porque preciso, não porque quero fazer coleção de logo no terminal.

Foi exatamente pra isso que criei o [ai-memory](https://aimemory.sh). A memória do projeto não deveria pertencer ao Claude, Codex, Kimi ou Gemini. Com `ai-memory run`, eu continuo a mesma linha de trabalho em outro harness sem fazer handoff manual, e as decisões consolidadas sobrevivem às compactações de contexto.

> **Modelo e harness são alugados. A sessão, as decisões e a memória do projeto precisam continuar sendo suas.**

Já expliquei a arquitetura e o formato aberto na [versão 2.0 do ai-memory](/2026/09/02/ai-memory-2-0-melhor-sistema-memoria-agentes-e-times/). Quanto mais equivalentes os modelos ficam, mais importante se torna poder trocar sem atrito.

## E os benchmarks famosos?

Continue olhando [SWE-bench](https://www.swebench.com/), que usa issues reais de projetos no GitHub, e [Terminal-Bench](https://www.tbench.ai/), que mede agentes resolvendo tarefas num terminal. Eles ajudam a descobrir regressão, melhora em uso de ferramentas e algum edge case onde uma família ainda sofre.

Só não confunda isso com o seu trabalho. SWE-bench Verified tem 500 problemas selecionados. Terminal-Bench v4 tem dezenas de tarefas difíceis e revisadas. Nenhum deles sabe como é o seu monorepo, o nível dos seus testes, a qualidade da sua documentação, a biblioteca interna da sua empresa ou aquela API legada que ninguém ousa tocar.

Meu benchmark também não sabe.

Se você precisa escolher modelo pra uma restrição muito específica, construa seu próprio teste com exemplos reais. Se não precisa, escolha qualquer Tier A, use por uma semana e siga trabalhando.

## E o tal GLM 5.5?

Tem rumor circulando de "GLM 5.5 chegando". Até hoje, 28 de outubro, **não existe anúncio oficial com esse nome, data ou preço**. A [página oficial de releases da Z.ai](https://docs.z.ai/release-notes/new-released) continua listando a família GLM 5.3 como a mais recente.

Jie Tang, fundador da Z.ai, respondeu *"won't take that long"* quando Elon Musk estimou o primeiro trimestre de 2027 pra China alcançar modelos do nível do Fable. Isso sugere que ele espera esse nível antes, mas não promete um lançamento da Z.ai, muito menos um modelo chamado GLM 5.5 até dezembro. Não vou transformar rumor em linha de ranking.

Kimi K3.1 Pro já está no Tier A. Qwen e GLM já cabem em hardware próprio com quantização. Gemini finalmente encostou nos líderes.

Sonnet e Terra fazem trabalho diário por muito menos. A competição está comprimindo tudo pro mesmo patamar.

## Commoditizou. Ótimo.

Não espero mais saltos enormes a cada versão comercial. Espero modelo um pouco mais rápido, barato, econômico em token, com quota melhor e um ou outro edge case corrigido. Isso é maturidade de mercado.

Meu conselho hoje é diferente do conselho de alguns meses atrás:

1. Escolha qualquer modelo Tier A que caiba no seu plano.
2. Use Sonnet ou Terra no trabalho comum.
3. Guarde Opus, Fable, Sol ou Astra pros problemas que merecem.
4. Mantenha uma segunda opção pra quando a quota acabar.
5. Instale [ai-memory](https://aimemory.sh) pra não ficar preso ao histórico de nenhum harness.
6. Pare de acompanhar ranking como campeonato de futebol.

Benchmark continua útil pra detectar quando uma família alcançou o grupo de cima, como o Argon acabou de fazer. Depois disso, a diferença entre primeiro, quarto e décimo lugar é pequena demais, ruidosa demais e dependente demais da tarefa.

As LLMs de fronteira viraram commodity. Você não está perdendo nenhuma revolução porque passou uma semana sem testar o lançamento da terça-feira. Escolha uma boa, mantenha suas opções abertas e volte a programar.

## Um ranking mais amplo: Engineering Breadth Index

Depois de terminar este texto, fiquei com uma pergunta melhor. O que acontece se eu combinar meu resultado com benchmarks que medem outras partes do trabalho?

Montei um índice secundário com quatro superfícies:

| Peso | Benchmark | O que entra na conta |
|---:|---|---|
| 35% | [SWE-bench Pro V2](https://labs.scale.com/leaderboard/swe_bench_pro_public_v2?tab=full) | Resolver issues em repositórios profissionais sem introduzir regressão |
| 30% | llm-coding-benchmark v4 | Projeto longo, contexto acumulado, vigilância e sabotagens |
| 25% | [Terminal-Bench 4.0](https://www.vals.ai/benchmarks/terminal-bench-4) | Tarefas no terminal avaliadas por verificadores específicos de cada desafio |
| 10% | [LiveCodeBench v6](https://livecodebench.github.io/leaderboard.html) | Problemas algorítmicos curtos e bem definidos |

Os percentuais brutos não podem ser somados. O líder do Terminal-Bench 4.0 faz 65,15; no meu, vários fizeram 100. Primeiro normalizei cada resultado contra o melhor resultado publicado pelo próprio benchmark naquela fotografia:

```text
nota normalizada = 100 × nota do modelo / melhor nota do benchmark
```

Depois apliquei uma média geométrica ponderada. Ela pune modelos com uma fraqueza grande em alguma dimensão, em vez de deixar uma nota perfeita esconder o buraco.

```text
índice = 100 × exp(
  0,35 × ln(SWE Pro) +
  0,30 × ln(Akita v4) +
  0,25 × ln(Terminal-Bench) +
  0,10 × ln(LiveCodeBench)
)
```

Cada parcela entra como número entre zero e um. O índice mede capacidade. Preço, duração, tok/s e quota ficam fora e devem aparecer numa tabela de praticidade separada. Misturar qualidade com dólar faria um modelo fraco e barato parecer tecnicamente melhor.

### O resultado de 28 de outubro de 2026

Já esbarramos na primeira limitação honesta. Até 28 de outubro, o leaderboard oficial do LiveCodeBench v6 ainda não mostrava resultados pros modelos desta geração. Portanto, **não existe ranking oficial completo de quatro dimensões hoje**.

Calculei o provisório com os outros três benchmarks, que cobrem 90% do peso. Usei o snapshot de 28 de outubro do SWE-bench Pro V2 e a atualização de 26 de outubro do Terminal-Bench 4.0. Renormalizei os pesos disponíveis: 38,89% pro SWE-bench Pro V2, 33,33% pro meu v4 e 27,78% pro Terminal-Bench 4.0. Só entrou modelo com resultado exato nos três. Nada de usar Kimi K3 no lugar do K3.1 ou GPT-5.6 Terra no lugar do 6.1 Terra.

### Ranking provisório

| # | Modelo | Akita v4 | SWE Pro V2 | Terminal 4.0 | Harness no SWE Pro | Cobertura | Índice |
|---:|---|---:|---:|---:|---|---:|---:|
| 1 | GPT-6 Astra | 100,0 | 96,90 | 59,60 | Codex | 90% | **96,6** |
| 2 | Gemini 4 Argon | 100,0 | 99,22 | 57,58 | mini-SWE-agent | 90% | **96,6** |
| 3 | Claude Fable 5.1 | 95,5 | 99,10 | 58,08 | Claude Code | 90% | **95,3** |
| 4 | Claude Opus 5 | 100,0 | 99,40 | 53,53 | Claude Code | 90% | **94,7** |
| 5 | Claude Sonnet 5.5 | 88,0 | 95,79 | 64,14 | mini-SWE-agent | 90% | **94,1** |
| 6 | GPT-6.1 Sol | 97,0 | 96,11 | 55,05 | mini-SWE-agent | 90% | **93,2** |
| 7 | GPT-5.6 Sol | 100,0 | 95,50 | 37,88 | Codex | 90% | **84,7** |
| 8 | GLM 5.3 | 94,0 | 95,60 | 38,89 | mini-SWE-agent | 90% | **83,6** |
| 9 | GPT-5.6 Terra | 100,0 | 92,37 | 22,73 | Codex | 90% | **72,5** |
| 10 | Gemini 3.8 Flash | 89,5 | 94,86 | 19,70 | mini-SWE-agent | 90% | **67,9** |
| 11 | Kimi K3 | 85,0 | 97,70 | 17,17 | mini-SWE-agent | 90% | **65,0** |
| 12 | Claude Sonnet 5 | 91,0 | 93,15 | 10,61 | Claude Code | 90% | **57,1** |
| 13 | Muse Spark Open | 69,5 | 95,02 | 6,57 | mini-SWE-agent | 90% | **46,0** |

O Terminal-Bench 4.0 usa mini-SWE-agent em todas as linhas. O SWE-bench Pro V2 mistura mini-SWE-agent com os harnesses nativos mostrados na tabela. No meu v4, cada linha mantém a rota documentada naquela rodada. Gemini 3.8 Flash é a execução no Antigravity; Muse Spark Open rodou self-hosted em quatro B300, pelo OpenCode.

Este é um ranking de **modelo nas condições publicadas por cada benchmark**, com influência real do harness. Não serve pra isolar cientificamente apenas os pesos do modelo.

### Por que a lista para no 13

Eu queria chegar pelo menos a 20 modelos, mas o cruzamento honesto acaba aqui. O SWE-bench Pro V2 publica 16 resultados. Desses, só 13 têm exatamente o mesmo modelo testado também no Terminal-Bench 4.0 e no meu v4. Os próximos candidatos esbarram numa lacuna:

| Modelo | Akita v4 | SWE Pro V2 | Terminal 4.0 | O que falta |
|---|---:|---:|---:|---|
| Claude Opus 5.5 | 100,0 | n/d | 65,15 | SWE Pro V2 |
| Kimi K3.1 Pro | 92,11 | n/d | 63,64 | SWE Pro V2 |
| GPT-6.1 Terra | 96,8 | n/d | 49,49 | SWE Pro V2 |
| Claude Fable 5 | 100,0 | n/d | 41,41 | SWE Pro V2 |
| GPT-6 Sol | 91,0 | n/d | 44,44 | SWE Pro V2 |
| DeepSeek V4.1 Flash 1017 (B300) | 92,5 | n/d | 31,82 | SWE Pro V2 |
| GLM 5.3 Flash | 84,25 | n/d | 37,37 | SWE Pro V2 |
| Muse Wonder 1.0 | 97,0 | 96,73 | n/d | Terminal 4.0 |
| Claude Haiku 5.5 | n/d | 87,23 | 36,36 | Akita v4 |
| Inkling | n/d | 89,88 | 0,51 | Akita v4 |

Eu poderia renormalizar duas notas e inventar posições 14 a 22. O número sairia bonito e enganoso. Um modelo medido só no meu v4 e no Terminal-Bench teria 55% da cobertura original; outro medido no SWE Pro e no Terminal teria 60%. Ordenar os dois como se tivessem passado pela mesma prova transformaria ausência de dado em precisão falsa.

Também não vou usar Kimi K3 no lugar do K3.1, GPT-5.6 Terra no lugar do 6.1 Terra ou qualquer parente da mesma família pra preencher buraco. Quando esses resultados forem publicados ou eu rodar os modelos que faltam, o índice cresce. Até lá, 13 é o limite defensável.

### O que mudou quando abrimos a lente

Astra ficou 0,036 ponto à frente do Argon antes do arredondamento: 96,5955 contra 96,5591. Ambos aparecem como 96,6 na tabela e formam um empate prático. Fable 5.1, Opus 5, Sonnet 5.5 e Sol 6.1 vieram logo atrás. Diferenças menores que três pontos devem ser lidas como a mesma faixa, ainda mais misturando benchmarks com intervalos de confiança e harnesses diferentes.

Sonnet 5.5 é o caso mais interessante. Fez só 88 no meu teste, mas chegou a 64,14 no Terminal-Bench, quase o teto atual. O índice mais amplo puxou o modelo pra 94,1. GPT-5.6 Sol mostra o inverso: 100 no meu teste e apenas 37,88 no Terminal-Bench, terminando em 84,7.

Isso responde por que vale combinar superfícies. Um benchmark sozinho enxerga bem o que foi desenhado pra enxergar. Três benchmarks continuam longe de medir tudo, mas já dificultam que uma especialidade isolada se passe por competência geral.

Mesmo assim, a conclusão anterior continua de pé. Os seis primeiros estão comprimidos entre 93,2 e 96,6. A lente ficou mais ampla e o suposto campeão absoluto continuou sem aparecer.

## Conclusão: escolha um bom e trabalhe

O índice composto reforçou a tese deste artigo. Quando ampliamos o teste, a ordem muda, algumas fraquezas aparecem e o grupo da frente continua espremido. Astra e Argon ficaram separados por 0,036 ponto. Quatro outros modelos ficaram a menos de 3,5 pontos. Com outra distribuição de pesos, outro conjunto de tarefas ou uma nova versão dos benchmarks, eles podem trocar de posição de novo.

Isso deixa uma decisão bem mais simples. Primeiro descubra quais modelos já atingiram a faixa competente pro seu tipo de trabalho. Depois escolha por velocidade, preço, quota, privacidade, disponibilidade e qualidade do harness. Essas diferenças afetam seu dia inteiro. Um ponto a mais numa tabela raramente afeta.

Ainda vale acompanhar benchmarks pra detectar regressões, descobrir quando uma família alcançou o Tier A e enxergar pontos cegos. Não vale transformar ranking em torcida ou tratar o primeiro colocado desta semana como verdade universal.

Hoje eu alterno entre os melhores sem cerimônia. O projeto, os testes, o Git e a memória da sessão precisam sobreviver à troca. Por isso insisto tanto no [ai-memory](https://aimemory.sh): o ativo importante é o histórico do trabalho, não o fornecedor que alugou a janela de contexto. Escolha qualquer modelo competente, mantenha uma rota de fuga e volte a resolver problemas reais.
