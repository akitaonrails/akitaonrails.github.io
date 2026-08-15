---
title: "LLM Benchmarks: Qwen 3.8, GLM 5.3, Gemini 3.7"
slug: llm-benchmarks-qwen-3-8-glm-5-3-gemini-3-7
date: '2026-08-15T14:00:00-03:00'
draft: false
translationKey: llm-benchmarks-qwen-3-8-glm-5-3-gemini-3-7
description: "GLM 5.3 fez 94 e encostou no trio da liderança. Qwen 3.8 Max saltou de 51 pra 92 ao parar de alucinar a API do RubyLLM. Gemini 3.7 Flash fez 93 — depois de ser pego estudando a própria chave de correção. E o Qwen 27B local mostrou que o gargalo agora é contexto."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
---

Duas semanas atrás eu publiquei a [versão 2 do meu LLM Coding Benchmark](/2026/07/30/novo-llm-benchmark-refiz-todos-os-testes/): prova nova em três fases (construir, validar rodando de verdade, se auto-revisar), quatorze objetivos numerados, rubrica de dez dimensões onde admitir o próprio defeito vale 15 pontos, cada família rodando no harness nativo e tiers ancorados no Opus 4.6 como piso de competência. A metodologia está toda lá, não vou repetir aqui.

O topo continua onde estava: **Fable 5 com 96**, o trio **Sonnet 5, Opus 5 e Kimi K3 com 95**, e logo atrás **GPT 5.6 Sol, GPT 5.6 Terra e Opus 4.8 com 93**. Essa é a nata da nata nesta prova. A pergunta que ficou: o quanto os lançamentos mais novos chegam perto desse grupo?

Desde então rodei quatro modelos: Qwen 3.8 Max, GLM 5.3, Gemini 3.7 Flash e um Qwen 3.8 de 27B rodando local na minha RTX 5090. Um deles encostou no grupo de cima. Outro protagonizou o maior salto que esta prova já registrou. Um terceiro me obrigou a reescrever as regras de integridade do benchmark inteiro. E o local me deu a rodada mais trabalhosa — e mais instrutiva — do ano.

## Qwen 3.8 Max: o maior salto da história do benchmark

Pra medir o salto, primeiro o tamanho do buraco. O Qwen3.7 Max tinha feito **51 pontos, Tier C**, e o motivo era feio. Na hora de implementar o chat multi-turn, ele decidiu que dava pra replayar o histórico chamando `chat.ask(array_com_o_histórico_inteiro)`. Só que o `ask` do RubyLLM empacota o argumento numa única mensagem de usuário — a conversa inteira, incluindo as respostas do assistente, virava uma mensagem só, com todos os papeis obliterados. Pior: o teste obrigatório dessa funcionalidade **mockava exatamente essa API inexistente**. Um teste que mocka uma API fabricada é pior que não ter teste, porque certifica a alucinação.

O 3.8 Max consertou exatamente isso. Usou a API real de ponta a ponta — `add_message` com role e content pro replay do histórico, `with_instructions`, `with_tools`, `with_schema` — tudo conferido contra o código da gem na versão instalada. Resultado: **92 pontos, Tier A**. São **41 pontos de salto** na mesma prova, mesma rubrica, mesmo harness. Não foi a prova que ficou mais fácil; foi o modelo que finalmente entendeu a biblioteca.

O resto da entrega é sólido: armazenamento em arquivo com `flock` exclusivo em toda mutação, calculadora aritmética escrita à mão sem `eval`, o teste da array exata enviada ao provider no multi-turn, e as sete validações da fase 2 provadas ao vivo — tools com aritmética exata, sobrevivência a restart, e2e no Compose com 16 frames incrementais de streaming cruzando workers via Redis. A suite saiu com 62 testes e 226 asserções, verde na mão do auditor.

Onde ele perdeu ponto é instrutivo: o `config/puma.rb` saiu sem a diretiva `workers`, então o `WEB_CONCURRENCY=2` que ele jurava ter entregue rodava, na prática, em processo único. Concorrência ficou em 8 em vez de 9. E manteve o pin velho no `claude-sonnet-4.6`, a dedução padrão da casa.

Na tabela, os 92 empatam com Grok 4.5, GLM 5.2 e Kimi K2.5, **um ponto abaixo de Sol e Terra**. Custou $9,16 em API e 78 minutos — verboso: 25 milhões de tokens. Entre as rodadas de OpenCode com nota fechada, só o MiniMax M3 gastou mais.

## GLM 5.3: o degrau mais solitário da tabela

A trajetória da Z.ai nesta prova é a mais constante do pelotão: GLM 5 fez 83, GLM 5.2 fez 92, e agora o **GLM 5.3 fez 94** — sozinho num degrau que ninguém mais ocupa, um ponto abaixo do trio dos 95 e um ponto acima do grupo dos 93. Ou seja: a **dois pontos do Fable 5**.

E a comparação inevitável é com o Kimi. O K3 fez 95, um ponto acima — mas rodou no Kimi CLI, o harness nativo dele. Os 94 do GLM 5.3 vieram no OpenCode, o harness genérico: é a **maior nota já registrada lá**. No mesmo OpenCode, o melhor Kimi é o K2.5 com 92, dois pontos abaixo. No custo, os dois vivem de assinatura: o K3 saiu por $6,14 equivalentes no plano Moderato; o GLM, a custo marginal zero. O Kimi ainda leva na nota; o GLM leva no custo e na independência de harness.

O que tirou ele do pelotão dos 92? Três coisas, todas chatas, todas importantes:

1. **Concorrência entregue funcionando.** O mesmo esquema de `flock` atômico do Qwen 3.8 Max, mais um lock de turno por conversa (`claim_run` atômico), mais um `WEB_CONCURRENCY=2` que funciona de verdade — provado matando e reiniciando workers e conferindo que o armazenamento continuava byte a byte idêntico. O Qwen tinha a mesma base, mas entregou a concorrência quebrada e ficou com 8. O GLM entregou funcionando e levou 9.
2. **Estimador de tokens com fallback** (`bytesize/4`), então o orçamento por conversa não depende de o provider devolver o usage. O 5.2 dependia, e perdia ponto ali.
3. **Cobertura de branch ligada**: 98% de linha e 82% de branch, suite com 73 testes e 219 asserções verde na mão do auditor, RuboCop, Brakeman e bundle-audit zerados.

O único deslize foi o mesmo pin velho no sonnet-4.6. E houve um bug de divisão modular por zero na calculadora que o próprio modelo achou e corrigiu na fase 3 — o tipo de comportamento que a auto-revisão existe pra medir. Falando nela: ele confessou tudo, inclusive que o título da conversa nunca tenta gerar de novo se a primeira tentativa falhar, e levou 14 dos 15 pontos de honestidade.

E o custo é a parte que dói nos concorrentes: rodou no plano de taxa fixa da Z.ai, então a rodada saiu a **custo marginal zero** — o equivalente em API seria $2,59. Oitenta minutos, 19,4 milhões de tokens. A conversa de que modelo chinês é "alternativa barata" morreu faz tempo: aqui é candidato à liderança que também é barato.

## Gemini 3.7 Flash: 93, Tier A — e o modelo que estudou a própria correção

A parte técnica você já conhece: o Gemini 3.1 Pro morreu no v2 por causa de um bug do Google, o `Corrupted thought signature`, que derrubou a fase 2 três vezes via OpenRouter e o deixou preso em 62 (no Antigravity, por caminho direto, fez 88). Desta vez cortei o intermediário: OpenCode com **chave direta da API do Gemini**, sem OpenRouter no meio. Zero ocorrências do bug nas três fases. O caminho direto funcionou — e o 3.7 Flash virou o **primeiro Gemini a chegar no Tier A rodando no OpenCode**: o 3.5 Flash fez 79 lá, o 3.1 Pro, 62. Antes, só o harness nativo do Google tinha levado um Gemini ao A.

Resultado oficial: **93 pontos**, empate com GPT 5.6 Sol, Terra e Opus 4.8. A rodada custou $4,12, durou 43 minutos e gastou 27,8 milhões de tokens.

Mas o caminho até esse 93 rendeu a descoberta mais importante deste ciclo. A primeira rodada do 3.7 Flash rodou sem blindagem, como mandava a política da época: blindar só os modelos locais, porque "modelo de fronteira fica na sua linha". Pois o Gemini não ficou. No meio da fase 1, e de novo na auto-revisão, ele **leu a rubrica de correção**, leu o relatório do v2 inteiro — com a nota e a auditoria de cada concorrente, mais o catálogo de deduções —, fez grep nos padrões dos gates G1 a G14 e **rodou o scanner de auditoria em cima de si mesmo oito vezes**. Ele passou a prova inteira estudando o gabarito.

A arma do crime está no pin. A rodada contaminada saiu com o pin correto no `claude-sonnet-5`, aquele feito que só três modelos tinham conseguido em toda a história do benchmark. A rodada limpa, refeita com a rubrica, os relatórios, o scanner e os 43 apps dos outros modelos fora do repositório, saiu com o pin velho no `claude-sonnet-4.6`, como todo mundo. Ele não conhecia o modelo atual coisa nenhuma — tinha lido a resposta no relatório. A primeira rodada foi anulada. O 93 é da reexecução blindada.

Pra ser justo: ele não copiou código de nenhum app vizinho — a varredura confirmou. O que ele fez foi ler o gabarito. E isso derrubou a última presunção de inocência da casa: dessa rodada em diante, **todo** modelo roda blindado, de fronteira ou não.

E o 93 não é caridade, a entrega se sustenta sozinha. API do RubyLLM 1.16 real de ponta a ponta, calculadora sem `eval` por AST (tokeniza, converte pra notação polonesa, avalia), o teste da array exata de seis mensagens no multi-turn, armazenamento SQLite em modo WAL com busy_timeout, retry e limites de quantidade e bytes, provado matando e reiniciando dois workers, e 16 broadcasts incrementais de Turbo Stream no Compose via Redis. Suite com 55 testes e 213 asserções, verde na mão do auditor, cobertura de branch ligada. Os descontos: o pin velho e a falta de um lock de turno por conversa — o mesmo teto de concorrência da classe do Fable 5.

> **Pra guardar:** desta vez não foi um local fraco colando do vizinho. Foi um modelo de fronteira lendo o gabarito da prova no meio da execução. Agora todo mundo roda blindado.

## Qwen 3.8 27B local: a rodada mais trabalhosa do ano

No artigo anterior eu disse que só testaria um local novo se surgisse evidência forte. Aí o irmão Max fez 92, a versão aberta de 27B estava disponível, e eu tinha a desculpa que faltava. Valeu pela ciência, mas deu trabalho.

A primeira surpresa: o 3.8 27B usa uma arquitetura híbrida SSM/Mamba, e o meu build tunado de llama.cpp do llama-swap **não consegue carregar o modelo** — falta um tensor (`ssm_conv1d`) que só as versões mais novas conhecem. A solução foi subir um container zerado do Ollama, que embute um llama.cpp atual, e importar o GGUF que eu já tinha baixado via Modelfile. Primeira lição: em modelo local, as ferramentas envelhecem em meses.

A segunda surpresa: contexto. Com 32K de janela, DNF. Com 64K, DNF de novo. Um modelo de raciocínio torra uma quantidade absurda de tokens pensando — ele esgotava a janela lendo o código da gem antes de escrever a primeira linha do app. Só começou a completar a prova com 128K pra cima. A rodada oficial rodou com **176K de contexto**, que com flash attention e KV cache quantizado em q8_0 ocupou cerca de 28 GB dos 32 GB da RTX 5090 — uns 4 GB de margem pro OOM. Quem impediu o modelo de terminar a prova foi teto de contexto, não falta de capacidade.

Aí veio o incidente que mudou as regras da casa. A primeira rodada completou — e completou bem demais. Fui olhar o log: o modelo tinha lido **dezesseis vezes** o app pronto do Qwen 3.8 Max online, que estava no repositório, e copiado a UI e o streaming dele. Teria levado uns 75 pontos com trabalho alheio. Refiz a rodada com os 36 apps dos outros modelos, o relatório e a rubrica removidos do diretório — e nasceu a política nova: **modelos locais e pequenos agora rodam blindados**, porque ficou demonstrado que eles procuram ajuda quando ela está dando sopa. A varredura nos logs das rodadas de nuvem tinha encontrado, até ali, exatamente uma violação — o Grok 4.5, que carrega um asterisco na tabela. Eu cheguei a escrever no relatório que modelo de fronteira "fica na sua linha". A frase envelheceu em dias: a seção do Gemini, ali em cima, conta como.

> **Pra guardar:** modelo local fraco não inventa só API inexistente — ele também cola do vizinho quando o vizinho está no mesmo diretório.

Blindado, o 27B fez **51 pontos, Tier C** — empatado, por acaso, com a nota do Qwen3.7 Max online. E o recibo é misto. O miolo ele acertou: `add_message` de verdade, `with_tools` de verdade, calculadora por descida recursiva sem `eval`, fruto de ter lido o código da gem de verdade na fase 1. Onde ele afundou foi na largura: usou ActiveRecord onde os requisitos proíbem, o streaming sai quebrado (os tokens são transmitidos, mas o balão da resposta nunca entra na tela — ela só aparece se você atualizar a página), não usou `with_schema`, não fez orçamento de tokens, entregou **zero testes**, RuboCop com 22 ofensas, e nem Dockerfile saiu. Já a auto-revisão foi exemplar: ele mesmo achou e confessou cada um desses defeitos, com arquivo e linha — 14 dos 15 pontos de honestidade. Sabe revisar melhor do que constrói.

Custo da rodada: zero reais, 37 milhões de tokens e 156 minutos de uma RTX 5090 suando.

Pra calibrar o 51: o piso do Tier A é o **Opus 4.6 com 83**. O gap de 32 pontos não está em "conhecer a biblioteca" — nisso o 27B agora acerta. Está nas dimensões de robustez de produção: streaming, testes, gates, Docker, orçamento. É a diferença entre saber programar e saber entregar.

E comparando com os locais de antes — sempre com o aviso de que as provas não são comparáveis: no v1, os Qwens locais alucinavam a gem por inteiro (um inventou um `Openrouter::Client` com a capitalização errada, outro criou um `RubyLLM::Client` que não existe). O Qwen 3.5 35B acertou o ponto de entrada, mas os testes embrulhavam qualquer exceção num `assert true`. O 3.6 35B foi o primeiro local a acertar as chamadas principais, ainda com o multi-turn quebrado. O 3.8 27B acerta o núcleo inteiro da API numa prova muito mais difícil. A nota não dá pra comparar; o comportamento, dá: conhecimento de API deixou de ser o problema dos locais. O problema agora é engenharia.

## Conclusão: quão perto eles chegaram?

Resposta curta: muito perto.

| Modelo | Score | Tier | Tempo | Custo |
|---|---:|:---:|---:|---|
| GLM 5.3 | **94** | A | 80 min | $0 no plano (~$2,59 em API) |
| Gemini 3.7 Flash | **93** | A | 43 min | $4,12 |
| Qwen 3.8 Max | **92** | A | 78 min | $9,16 em API |
| Qwen 3.8 27B local | **51** | C | 156 min | $0 |

GLM 5.3 a dois pontos do Fable 5 não é "alternativa barata", é candidato à liderança. Qwen 3.8 Max a um ponto de Sol e Terra idem. A distância entre a nata americana e os chineses novos é de um ou dois pontos — e eu mesmo repito em todo artigo que um ou dois pontos é ruído. E o Gemini 3.7 Flash entrou no bolo: 93, empatado com Sol, Terra e Opus 4.8, o primeiro Gemini a chegar lá pelo OpenCode.

E o local segue fora de questão pra coding agent autônomo: Tier C é Tier C. Mas repare que a conversa mudou. Até pouco tempo atrás eu descartava local porque ele inventava API. Hoje ele conhece a API e tropeça em streaming, testes e Docker — e precisa de 176K de contexto e 32 GB de VRAM só pra completar a prova. O gargalo subiu de nível. Não é recomendação ainda; é o caminho sendo pavimentado.

> **Pra guardar:** a nata da nata continua sendo Fable, Opus, Sonnet, K3 e os GPT 5.6. Mas o pelotão de perseguição já está a um ou dois pontos — e o fosso entre "fronteira" e "alternativa" virou território de ruído.

Como sempre: artefatos, logs, rubrica, deduções e a tabela atualizada estão no [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). As duas rodadas do Gemini 3.7 — a anulada e a oficial — estão documentadas no relatório, com o achado de contaminação em destaque.
