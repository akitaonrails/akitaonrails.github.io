---
title: "Existem Linguagens Melhores pra programar com LLMs?"
slug: "existem-linguagens-melhores-pra-programar-com-llms"
date: '2026-10-11T21:00:00-03:00'
draft: false
translationKey: existem-linguagens-melhores-pra-programar-com-llms
description: "DHH converteu o Campfire dele pra várias linguagens com IA e saiu postando que Rust ganhou. Em vez de brigar no X, montei um benchmark reproduzível: 7 linguagens, 4 configurações de LLM, 112 tentativas de implementação, e um teste de fila sob pressão com Elixir, Rust, Rails e Ruby puro. Resultado: nenhum ranking de linguagem se sustenta, Ruby conciso custou mais tokens que Rust, tipagem forte não poupou reparo nenhum, e sob carga as quatro stacks empataram em vazão. O que importa é teste e disciplina, não linguagem."
tags:
- benchmarks-de-llm
- linguagens-de-programacao
- llms
- elixir-e-erlang
---

Semana passada o DHH resolveu farmar engajamento com o formato mais preguiçoso que existe: converteu o Campfire, o app de chat dele, pra várias linguagens usando agentes de IA, e foi soltando os resultados de throughput um a um no X. Na série que ele postou, a versão em Rust saiu na frente das equivalentes em Elixir e Ruby. A thread inteira foi desenhada pra provocar, e provocou.

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr">Last conversion of the Campfire from my token stash goes to JavaScript/Express. As with the others, I'm sure you can find more to optimize. But this gives you a sense of what order of magnitude these options exist within with agent-led development. https://t.co/UUapL99SJE https://t.co/2H2NXfeZog</p>&mdash; DHH (@dhh) <a href="https://twitter.com/dhh/status/2107077808182976817">October 5, 2026</a></blockquote>

Não vou defender ele dessa vez. Uma conversão única, feita por agente, sem ajuste fino nenhum, não mede linguagem: mede o quanto o modelo conhece os idiomas de cada stack. É rage bait e ele sabe. Dito isso, eu faço o mesmo de vez em quando, e metade dos críticos dele também, então somos todos hipócritas e segue o jogo.

A parte boa é que a isca foi útil pra mim. Eu venho fazendo [benchmarks de LLM](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-1/) e [benchmark de modelos de decisão](/2026/10/10/qual-modelo-de-decisao-classificador-de-ia-tipo-jev-e-melhor/), mas nunca tinha medido, de forma reproduzível, a pergunta que essa thread fingia responder: **faz diferença qual linguagem você escolhe quando quem escreve o código é um LLM?** Minha resposta curta já estava dada em dois posts meus:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Pressure under load is not a trivial problem to solve from scratch and I recommend you do not attempt to. It's a solved problem already and all solutions converge to what Elixir already brings out of the box. So yes. I use Rust all the time, but if I had to solve high scalability problems (particularly high volume message queues), I would think of Elixir first.</p>&mdash; Fabio Akita (@AkitaOnRails) <a href="https://twitter.com/AkitaOnRails/status/2108587462595367353">October 9, 2026</a></blockquote>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Language wars are tiresome. And the reality is simpler if you're doing AI assisted coding.<br><br>- system level (drivers, fs, daemons, etc): Rust. C++ is you're extending existing legacy<br>- windows only desktop apps: C#<br>- iOS/MacOS/iPadOS: Swift<br>- multi-OS: Rust/Tauri, Qt/C++, Flutter, Electron (pick your poison)<br>- simple websites: Node/Typescript/Bun/Deno<br>- highly scalable backend: Elixir, parts in Rust, parts in Go<br>- CLI tools: Rust<br><br>Everything else, by default, Rust. Unless it's an edge case.</p>&mdash; Fabio Akita (@AkitaOnRails) <a href="https://twitter.com/AkitaOnRails/status/2108590592263352540">October 9, 2026</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## Não existe linguagem melhor, existe ferramenta certa

Aquela lista do post não é ranking, é mapa de terreno. Cada linguagem e cada framework foram desenhados pra um caso de uso, e nenhum cobre todos. Isso valia quando você escrevia cada linha na mão e continua valendo com agente. O LLM não muda a física do problema: ele só muda quem digita.

E o mapa vai além da linguagem. Sistema real tem infraestrutura em volta: Kubernetes quando a escala pede, SQLite por padrão porque a maioria dos apps nunca precisa de mais que isso, Postgres com pgBouncer quando precisa, Redis pra cache e chave-valor, RabbitMQ ou NATS pra fila. Escolher "a stack" no dia zero e achar que ela dura dez anos é fantasia. Não dura, e tudo bem.

Exemplo pessoal: web app novo, eu abro Ruby on Rails sem pensar duas vezes. É a solução mais completa de ponta a ponta que existe pra web, e com LLM escrevendo a maior parte do código, a produtividade do framework pesa ainda mais que a da linguagem. Conforme o sistema cresce, eu vou trocando as partes que pedem outra ferramenta: fila de alto volume sai do lado do Rails e vai pra algo da terra Erlang, começando por RabbitMQ, que já resolve a parte difícil de backpressure pra mim.

> Nenhum software bom está pronto: ele cresce. O uso dita o que você substitui, reescreve e adiciona. A arquitetura final nunca é a do primeiro commit, e quem tenta acertar tudo no primeiro commit só gera documento morto.

## A superstição dos tokens

A thread do DHH ressuscitou duas crenças que circulam desde que LLM virou ferramenta de trabalho:

- **"Linguagem de script é melhor pra IA porque a sintaxe enxuta gasta menos tokens."**
- **"Linguagem fortemente tipada é melhor pra IA porque o compilador pega os erros, então precisa de menos teste e menos reparo."**

As duas soam razoáveis e as duas são superstição até alguém medir. Eu apostava contra as duas, por experiência: compilador bom ajuda, mas não faz mágica, e concisão de sintaxe nunca foi o gargalo de um agente que lê e escreve arquivo o dia inteiro.

O que realmente separa projeto que anda de projeto que gira em círculo é disciplina de teste. Já escrevi que [TDD virou obrigação técnica, não filosofia](/2026/04/20/clean-code-para-agentes-de-ia/), e o benchmark deste texto é mais um dado na mesma direção. Não importa se você faz test-first ou test-after: importa que a suíte cresça junto com o código, que [todo bug reportado por usuário vire teste de regressão](/2026/03/01/software-nunca-esta-pronto-4-projetos-a-vida-pos-deploy-e-por-que-one-shot-prompt-e-mito/) antes da correção, e que você nunca repita o mesmo erro duas vezes. Software sem usuário é software morto, então [release cedo, release sempre](/2026/09/22/parem-de-inventar-desculpas-e-facam-mais-deploy-a-premissa-mudou/), quebra rápido e conserta mais rápido ainda. IA fecha exatamente essa lacuna: o ciclo de reproduzir, testar e corrigir ficou barato. QA virou a habilidade mais valiosa do programador, muito acima de "saber a sintaxe de Rust".

Disciplina vence compilador e vence linguagem. Essa era a minha hipótese. Foi medir.

## O benchmark

Montei um experimento reproduzível, público no [repositório vibe-coding-benchmarks](https://github.com/akitaonrails/vibe-coding-benchmarks), com os resultados por tentativa publicados em JSON e os rastros brutos fora do repo por contenção de credenciais. Não é um campeonato de linguagem, e o próprio design repete isso: é uma fotografia de uma tarefa real, medindo o que dá pra medir com honestidade.

### A tarefa

Uma tarefa só, de propósito: manter um **motor de livro-razão** (ledger) multilocatário. O agente recebe um código v1 funcionando e precisa levá-lo a um contrato v2, com identidades por tenant, autorização, snapshots serializáveis, índice secundário único com troca de alias, journal com limite de capacidade, recuperação de grupos rasgados, checkpoint, migração de schema legado e IDs de retry duráveis. Não é FizzBuzz: é o tipo de sistema que exige invariante atravessando operações, exatamente onde LLM costuma tropeçar.

A correção é julgada por **43 histórias de teste aplicadas depois da coleta**, fora da vista do agente: as 27 públicas do T1 mais 16 ocultas. Passar é 43 de 43. As condições:

- **T0:** contrato em prosa, exemplos de entrada e saída, um launcher funcionando. Sem suíte de testes.
- **T1:** o mesmo, mais 27 histórias públicas e um driver pra rodá-las.

Cada tentativa tinha 15 minutos de orçamento, com no máximo duas continuações de 3 minutos. Na prática, nenhuma das 112 precisou de continuação.

### As linguagens e os modelos

Sete linguagens em três estratos, com os toolchains pinados e o Rust em modo seguro:

- **Nativas tipadas:** Rust (safe, pinado), Haskell (GHC pinado).
- **VM tipadas:** C# (com nullable analysis), Kotlin, TypeScript (`strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`).
- **Dinâmicas de script:** Python e Ruby, sem checker nenhum.

Quatro configurações de modelo, todas por assinatura, sem fallback pago: **Kimi K3** (high), **GLM 5.3** via OpenCode (high), **Claude Opus 5.5** (medium) e **Codex com gpt-6 Sol** (medium). Cruzando tudo: 7 linguagens × 4 modelos × 2 condições × 2 repetições = **112 tentativas**.

### O que esse design não mede

Antes dos números, os freios, porque eles fazem parte do resultado. É uma tarefa só, com duas repetições por célula: amostra pequena por construção. Cobertura de tokens é parcial em alguns modelos (dado faltante não é zero). O harness mudou no meio da campanha em três épocas de instrumentação. E atrasos de provedor contaminam tempo de parede: uma das tentativas do Opus passou metade do relógio esperando liberação de cota. Todos os números abaixo são descritivos, e eu aponto onde eles não sustentam conclusão.

> **Disclaimer obrigatório antes de citar qualquer número deste texto por aí:** todos os resultados a seguir valem pra **este** benchmark, com **esta** tarefa, **estes** modelos, **estes** prompts e **este** hardware. O seu caso pode variar violentamente. Se a sua tarefa não se parece com um motor de livro-razão, se o seu modelo não é um destes quatro, se a sua fila não é a minha fila, os números não se transferem. O código, as tarefas, as notas e o passo a passo pra reproduzir estão todos no [repositório no GitHub](https://github.com/akitaonrails/vibe-coding-benchmarks). E se você discordar de algum resultado e essa discordância for importante pra sua empresa ou pro seu projeto, a única atitude honesta é a que eu tive: **pare de argumentar e rode o seu próprio benchmark.**

## Resultado 1: em acerto, os modelos de fronteira empataram no teto

| Configuração | Corretas no prazo | Corretas no limite | Falhas | Sem nota |
| --- | ---: | ---: | ---: | ---: |
| Kimi K3 high | 17 | 7 | 2 | 2 |
| GLM 5.3 high (OpenCode) | 7 | 9 | 7 | 5 |
| Opus 5.5 medium | 25 | 0 | 3 (interrupção de infra) | 0 |
| Codex / Sol medium | 28 | 0 | 0 | 0 |

Leitura: Sol passou nas 28 tentativas elegíveis e o Opus nas 25 dele (as 3 falhas foram infraestrutura, não código). **53 de 53 tentativas elegíveis corretas entre os dois.** A tarefa, feita pra ser difícil, foi fácil demais pra separar os modelos de fronteira, e muito menos as linguagens: com todo mundo passando em tudo, não existe ranking de acerto pra publicar.

A diferença apareceu nos modelos mais fracos, e na direção que a minha hipótese previa: **teste fornecido ajudou**. Kimi e GLM, com a suíte pública em mãos (T1), entregaram 24 artefatos corretos contra 16 sem ela (T0). O Kimi, em particular, passou nas 14 tentativas com testes fornecidos. É descritivo, não causal, mas é o sinal mais limpo do benchmark inteiro: o que mudou o resultado não foi a linguagem, foi a presença de teste.

Por linguagem, dentro de cada modelo, o acerto ficou espalhado entre 1/4 e 4/4 sem padrão que se repita entre modelos. As três falhas semânticas que eu auditei a fundo são instrutivas: um C# do GLM e um Python do Kimi perderam a mesma história por violar a mesma invariante entre operações, e um Haskell do Kimi errou um caminho de checkpoint. Nenhuma falha era erro de tipo.

> Onde o modelo errou, errou invariante de domínio: o tipo de erro que compilador nenhum pega, em linguagem tipada ou dinâmica. O mito de que tipagem forte poupa o trabalho de entender o problema morre aí.

## Resultado 2: linguagem concisa não economizou token

Aqui vai a tabela que mata a primeira superstição. Medianas por linguagem no Sol, quatro tentativas válidas por célula:

| Linguagem | Tempo mediano | Tokens medianos | Linhas finais do código |
| --- | ---: | ---: | ---: |
| TypeScript | 53 s | 147,5 mil | ~280 |
| Python | 77 s | 138,2 mil | ~300 |
| C# | 61 s | 171,6 mil | ~260 |
| Kotlin | 65 s | 170,6 mil | ~210 |
| Haskell | 75 s | 184,7 mil | ~265 |
| Ruby | 82 s | 185,6 mil | ~380 |
| Rust | 80 s | 188,1 mil | ~650 |

Ruby, o mais conciso em linhas (pouco mais da metade do Rust), custou praticamente os mesmos tokens do Rust no Sol, e no Opus foi **o mais caro de todos**, uns 205 mil tokens de mediana contra 94 mil do C#. Os mais baratos foram TypeScript e Python no Sol, C#, Haskell e Kotlin no Opus. Se "menos linhas de código fonte = menos tokens de LLM" fosse lei, Ruby tinha que liderar de longe. Ficou no fim.

E a segunda superstição? Auditei os rastros procurando os ciclos de reparo guiados por compilador que a tipagem forte supostamente evita. Resultado: **zero ciclos de reparo de erro de compilação** nas tentativas auditadas do Opus, em Ruby, Rust e Haskell. O Rust não precisou de correção nenhuma vinda do compilador; o Haskell teve uma limpeza de warning; o Ruby gastou seus tokens extras em ajuste voluntário de performance. O modelo de fronteira quase sempre escreve código que compila de primeira, e o esforço real vai pra verificação, não pra apaziguar o compilador.

Um contraponto que fecha o caixão da tese "barato é bom": as células de **menor** consumo de token do GLM foram as falhas. TypeScript T0 por 50 mil tokens parece eficiente até você ver que são dois starters inalterados porque o modelo estourou o limite de saída. Token baixo pode significar desistência precoce.

## Resultado 3: sob carga, todo mundo empatou na fila

Aí vem a pergunta do DHH: Rust "ganha" de Elixir e Ruby quando o assunto é throughput. Montei a trilha separada pra isso: quatro workers de fila contra um RabbitMQ real, escritos com ajuda de agente, cada um com seu idioma natural:

- **Elixir** com OTP e Broadway
- **Rust** com Tokio e Lapin
- **Rails** com Bunny
- **Ruby puro** com Bunny (controle)

Um gerador publicava 10 mil mensagens de 4 KB no RabbitMQ, a 200 por segundo, e cada worker consumia o mais rápido que conseguia, batendo os efeitos num coletor HTTP/SQLite com atraso nominal de 50 ms, limitado a 2 CPUs e 1 GB de RAM. Dois perfis de concorrência:

| Stack | Handlers | Efeitos/s | Corretas/10.000 | Pico de memória | Drenou? |
| --- | ---: | ---: | ---: | ---: | --- |
| Elixir | 8 | 94,8 | 10.000 | 135 MiB | sim |
| Rust | 8 | 94,6 | 10.000 | 16 MiB | sim |
| Rails | 8 | 92,7 | 10.000 | 79 MiB | sim |
| Ruby | 8 | 92,5 | 10.000 | 38 MiB | sim |
| Elixir | 64 | 84,8 | 7.915 | 161 MiB | não |
| Rust | 64 | 88,2 | 8.151 | 23 MiB | não |
| Rails | 64 | 88,5 | 8.108 | 87 MiB | não |
| Ruby | 64 | 88,0 | 8.081 | 60 MiB | não |

No perfil de 8 handlers, as quatro stacks entregaram a mesma vazão, 93 a 95 efeitos por segundo, e drenaram a fila inteira. O gargalo aparente era o coletor compartilhado (um lock em Python, um escritor SQLite), não as linguagens. No perfil de 64 handlers, todas deixaram backlog e estouraram o timeout do cliente em massa, então marquei essas células como não qualificadas: o protocolo forte, com coletor de group-commit e escada de 50 a 800 msg/s, está desenhado e não executado.

A única diferença que sobrou de pé nos números foi **memória**: Rust segurou o pico em 16 MiB onde a BEAM gastou 135. É uma vantagem real do Rust em densidade, com a ressalva de que pico de cgroup não é footprint de linguagem. Em vazão, que era a alegação da thread, empate técnico.

E a pergunta que interessava mais, "o agente trabalha menos pra entregar um consumer de fila confiável em Elixir do que em Rust?", ficou sem resposta de propósito: essas quatro implementações foram escritas pra validar o ambiente, não como tentativa controlada de codificação. Comparar o esforço de IA entre Elixir e Rust exigiria a mesma matriz do ledger rodando na tarefa de fila. Está na lista.

## Afinal, a linguagem importa?

Com os dados na mesa, dá pra responder as três perguntas da thread:

**Existe linguagem melhor pra programar com LLM?** Não apareceu nenhuma. Nos modelos de fronteira, acerto e esforço variaram menos entre linguagens do que entre modelos. Onde houve diferença de acerto, ela seguiu a presença de testes fornecidos, não a sintaxe. "Nenhum ranking geral de linguagem se estabelece" é a frase oficial do relatório, e é a frase correta.

**As teses de economia de token se sustentam?** Nenhuma das duas. Concisão não economizou: Ruby custou tanto quanto Rust, ou mais. Tipagem forte não poupou reparo: não havia reparo de tipo pra poupar. O esforço dos modelos foi pra verificação e entendimento do contrato, e isso não tem linguagem.

**O DHH estava certo?** No que ele mediu, ele mediu o que um agente entrega de graça em cada stack, sem ajuste, e chamou isso de veredito sobre linguagem. No meu teste, com carga real e medição honesta, as quatro stacks empataram em vazão no regime estável, e só a memória diferenciou o Rust. Se a thread dele prova alguma coisa, prova que conversão por agente mede o modelo, não a linguagem.

Minhas apostas da introdução saíram de pé: teste e disciplina são a alavanca, o compilador é coadjuvante, e a ferramenta certa depende do problema. Web app novo continua sendo Rails na minha mão, fila pesada continua sendo território Erlang, sistema baixo nível continua sendo Rust, e o LLM escreve qualquer uma delas com a mesma competência. Quem passou a semana brigando pela linguagem favorita no X brigou por nada.

Os dados por tentativa, a metodologia completa e os limites de evidência estão no [repositório](https://github.com/akitaonrails/vibe-coding-benchmarks). Se você rodar a matriz com outra tarefa e achar um ranking que eu não achei, me mostra.
