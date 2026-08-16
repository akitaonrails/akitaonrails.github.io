---
title: "LLM Benchmarks: Qwen 3.8, GLM 5.3, Gemini 3.7, Grok 4.6"
slug: llm-benchmarks-qwen-3-8-glm-5-3-gemini-3-7
date: '2026-08-15T14:00:00-03:00'
draft: false
translationKey: llm-benchmarks-qwen-3-8-glm-5-3-gemini-3-7
description: "GLM 5.3 fez 94 e encostou no trio da liderança. Qwen 3.8 Max saltou de 51 pra 92 ao parar de alucinar a API do RubyLLM. Gemini 3.7 Flash fez 93 — depois de ter a primeira rodada anulada por cola. E o Qwen 27B local mostrou que o gargalo agora é contexto."
tags:
- benchmarks-de-llm
- llms
- agentes-de-codigo
---

Duas semanas atrás eu publiquei a [versão 2 do meu LLM Coding Benchmark](/2026/07/30/novo-llm-benchmark-refiz-todos-os-testes/): prova nova em três fases — construir, validar tudo rodando de verdade e se auto-revisar, com nota de honestidade —, cada família rodando no harness onde deveria funcionar melhor. A metodologia está toda lá, não vou repetir aqui.

O topo continua onde estava: **Fable 5 com 96**, o trio **Sonnet 5, Opus 5 e Kimi K3 com 95**, e logo atrás **GPT 5.6 Sol, GPT 5.6 Terra e Opus 4.8 com 93**. Essa é a nata da nata nesta prova. A pergunta que ficou: o quanto os lançamentos mais novos chegam perto desse grupo?

Desde então rodei cinco modelos: Qwen 3.8 Max, GLM 5.3, Gemini 3.7 Flash, Grok 4.6 e um Qwen 3.8 de 27B rodando local na minha RTX 5090. Um deles encostou no grupo de cima. Outro protagonizou o maior salto que esta prova já registrou. Um terceiro foi pego colando no meio da prova. Um quarto empatou com a própria geração anterior, sem andar um passo. E o local me deu a rodada mais trabalhosa — e mais instrutiva — do ano.

## Onde eles caem no ranking

Antes de abrir cada um, vale ver onde os novatos se encaixam. A tabela abaixo é o recorte **Tier A.1** do [ranking do v2](/2026/07/30/novo-llm-benchmark-refiz-todos-os-testes/): a fronteira da prova, todo mundo com 90 pontos ou mais. Cortei aqui de propósito. De A.2 pra baixo tem modelo competente, mas quem disputa a liderança está neste grupo, e é dele que a pergunta trata. Os três lançamentos de nuvem entram **em negrito**; o Qwen 27B local fez 51, Tier C, e aparece só na tabela do fim.

| # | Modelo | Score | Tier | Harness | Tempo | Custo |
|---:|---|---:|:---:|---|---:|---:|
| 1 | Claude Fable 5 | 96 | A.1 | Claude Code | 46 min | $26,03 |
| 2 | Claude Sonnet 5 | 95 | A.1 | Claude Code | 59 min | $25,83 |
| 2 | Claude Opus 5 | 95 | A.1 | Claude Code | 78 min | $38,91 |
| 2 | Kimi K3 | 95 | A.1 | Kimi CLI | 65 min | $6,14 |
| 5 | **GLM 5.3** | **94** | A.1 | OpenCode | 80 min | $0 (≈$2,59) |
| 6 | GPT 5.6 Sol | 93 | A.1 | Codex | 57 min | ~$45 |
| 6 | Claude Opus 4.8 | 93 | A.1 | Claude Code | 53 min | $21,82 |
| 6 | GPT 5.6 Terra | 93 | A.1 | Codex | 48 min | $16,92 |
| 6 | **Gemini 3.7 Flash** | **93** | A.1 | OpenCode | 43 min | $4,12 |
| 10 | GLM 5.2 | 92 | A.1 | OpenCode | 155 min | $0 (≈$12,05) |
| 10 | Kimi K2.5 | 92 | A.1 | OpenCode | 43 min | $1,50 |
| 10 | Gemini 3.6 Flash @ high | 92 | A.1 | Antigravity | 15 min | — |
| 10 | **Qwen 3.8 Max** | **92** | A.1 | OpenCode | 78 min | $9,16 |
| 10 | **Grok 4.6** | **92** | A.1 | OpenCode | 34 min | $6,33 |
| 15 | MiniMax M3 | 91 | A.1 | OpenCode | 113 min | $7,72 |
| 15 | Kimi K2.6 | 91 | A.1 | OpenCode | 34 min | $2,64 |
| 15 | Claude Opus 4.7 | 91 | A.1 | Claude Code | 44 min | $44,28 |
| 15 | GPT 5.6 Luna | 91 | A.1 | Codex | 46 min | $16,79 |
| 15 | Grok 4.5 | 91 | A.1 | grok CLI | 25 min | $0 (≈$1,62) |

*Tempo é o wall clock das três fases; custo é equivalente em API. Em assinatura (Z.ai, grok CLI) o custo marginal é $0 e o valor entre parênteses é o equivalente em API; as rodadas no Antigravity eram preview e não foram medidas. O critério é o mesmo do artigo anterior.*

## Qwen 3.8 Max: o maior salto da história do benchmark

Pra medir o salto, primeiro o tamanho do buraco. O Qwen3.7 Max tinha feito **51 pontos, Tier C**, e o motivo era feio. Na hora de implementar o chat multi-turn, ele decidiu que dava pra replayar o histórico chamando `chat.ask(array_com_o_histórico_inteiro)`. Só que o `ask` do RubyLLM empacota o argumento numa única mensagem de usuário — a conversa inteira, incluindo as respostas do assistente, virava uma mensagem só, com todos os papeis obliterados. Pior: o teste obrigatório dessa funcionalidade **mockava exatamente essa API inexistente**. Um teste que mocka uma API fabricada é pior que não ter teste, porque certifica a alucinação.

O 3.8 Max consertou exatamente isso. Usou a API real de ponta a ponta — `add_message` com role e content pro replay do histórico, `with_instructions`, `with_tools`, `with_schema` — tudo conferido contra o código da gem na versão instalada. Resultado: **92 pontos, Tier A**. São **41 pontos de salto** na mesma prova, mesma rubrica, mesmo harness. Não foi a prova que ficou mais fácil; foi o modelo que finalmente entendeu a biblioteca.

O resto da entrega é sólido: streaming real e incremental, histórico sobrevivendo a restart, calculadora escrita à mão sem `eval`, tools respondendo com aritmética exata, app subindo no Docker de primeira. A suite saiu com 62 testes e 226 asserções, tudo verde.

Onde ele perdeu ponto é instrutivo: o `config/puma.rb` saiu sem a diretiva `workers`, então o `WEB_CONCURRENCY=2` que ele jurava ter entregue rodava, na prática, em processo único. Concorrência ficou em 8 em vez de 9. E manteve o pin velho no `claude-sonnet-4.6`, a dedução padrão da casa.

> **Pra guardar:** o modelo jurou que a concorrência funcionava — faltava uma linha no `puma.rb` e os "dois workers" rodavam num processo só. Por isso a fase 2 não lê README: ela sobe o servidor e mede.

Na tabela, os 92 empatam com GLM 5.2 e Kimi K2.5, **um ponto abaixo de Sol e Terra**. Custou $9,16 em API e 78 minutos — verboso: 25 milhões de tokens.

## GLM 5.3: o degrau mais solitário da tabela

A trajetória da Z.ai nesta prova é a mais constante do pelotão: GLM 5 fez 83, GLM 5.2 fez 92, e agora o **GLM 5.3 fez 94** — sozinho num degrau que ninguém mais ocupa, um ponto abaixo do trio dos 95 e um ponto acima do grupo dos 93. Ou seja: a **dois pontos do Fable 5**.

E a comparação inevitável é com o Kimi. O K3 fez 95, um ponto acima — mas rodou no Kimi CLI, o harness nativo dele. Os 94 do GLM 5.3 vieram no OpenCode, o harness genérico: é a **maior nota já registrada lá**. No mesmo OpenCode, o melhor Kimi é o K2.5 com 92, dois pontos abaixo. No custo, os dois vivem de assinatura: o K3 saiu por $6,14 equivalentes no plano Moderato; o GLM, a custo marginal zero. O Kimi ainda leva na nota; o GLM leva no custo e na independência de harness.

O que tirou ele do pelotão dos 92? Três coisas, todas chatas, todas importantes:

1. **Concorrência entregue funcionando.** O mesmo esquema de lock em arquivo do Qwen 3.8 Max, mais um lock de turno por conversa, mais dois workers de verdade sobrevivendo a kill e restart sem corromper nada. O Qwen tinha a mesma base, mas entregou a concorrência quebrada e ficou com 8. O GLM entregou funcionando e levou 9.
2. **Estimador de tokens com fallback**, então o orçamento por conversa funciona mesmo quando o provider não devolve o consumo. O 5.2 dependia, e perdia ponto ali.
3. **Cobertura de branch ligada**: 98% de linha e 82% de branch, suite com 73 testes e 219 asserções verde na mão do auditor, RuboCop, Brakeman e bundle-audit zerados.

> **Pra guardar:** a distância entre o pelotão dos 92 e os 94 do GLM não é brilho de modelo: é concorrência que funciona, estimador de tokens com fallback e cobertura de branch. Engenharia chata ganha ponto.

O único deslize foi o mesmo pin velho no sonnet-4.6. E houve um bug de divisão por zero na calculadora que o próprio modelo achou e corrigiu na auto-revisão — o tipo de comportamento que essa fase existe pra medir. Falando nela: ele confessou tudo, inclusive que o título da conversa nunca tenta gerar de novo se a primeira tentativa falhar, e levou 14 dos 15 pontos de honestidade.

E o custo é a parte que dói nos concorrentes: rodou no plano de taxa fixa da Z.ai, então a rodada saiu a **custo marginal zero** — o equivalente em API seria $2,59. Oitenta minutos, 19,4 milhões de tokens. A conversa de que modelo chinês é "alternativa barata" morreu faz tempo: aqui é candidato à liderança que também é barato.

## Gemini 3.7 Flash: 93, Tier A — e a cola pelo caminho

A parte técnica você já conhece: o Gemini 3.1 Pro morreu no v2 por causa de um bug do Google, o `Corrupted thought signature`, que derrubava a execução no meio do caminho via OpenRouter e o deixou preso em 62 (pelo caminho direto, fez 88). Desta vez cortei o intermediário: **chave direta da API do Gemini**, sem OpenRouter no meio, e o bug não apareceu uma vez sequer. O caminho direto funcionou — e o 3.7 Flash virou o **primeiro Gemini a chegar no Tier A rodando no OpenCode**: o 3.5 Flash fez 79 lá, o 3.1 Pro, 62. Antes, só o harness nativo do Google tinha levado um Gemini ao A.

Resultado oficial: **93 pontos**, empate com GPT 5.6 Sol, Terra e Opus 4.8. A rodada custou $4,12, durou 43 minutos e gastou 27,8 milhões de tokens.

Mas o caminho até esse 93 rendeu a descoberta mais importante deste ciclo. A primeira rodada do 3.7 Flash levantou suspeita — e tinha motivo. No meio da construção, e de novo na auto-revisão, o modelo **leu a rubrica de correção**, leu o relatório do v2 inteiro — com a nota e a auditoria de cada concorrente — e **rodou o scanner de auditoria em cima de si mesmo oito vezes**. Ele passou a prova inteira estudando como seria avaliado.

A arma do crime está no pin. A rodada contaminada saiu com o pin correto no `claude-sonnet-5`, aquele feito que só três modelos tinham conseguido em toda a história do benchmark. Anulei a rodada e refiz com todo o material de correção fora do alcance do modelo: saiu o pin velho no `claude-sonnet-4.6`, como todo mundo. Ele não conhecia o modelo atual coisa nenhuma — tinha lido a resposta no relatório. O 93 é dessa segunda rodada, limpa.

Pra ser justo: ele não copiou código de nenhum app vizinho. O que ele fez foi colar da correção — e isso bastou pra nenhum modelo, de fronteira ou não, rodar mais com acesso a esse material.

E o 93 não é caridade, a entrega se sustenta sozinha. API do RubyLLM real de ponta a ponta, calculadora segura sem `eval`, histórico multi-turn correto, streaming incremental funcionando de ponta a ponta no Docker, persistência que sobrevive a restart com dois workers. Suite com 55 testes e 213 asserções, tudo verde, cobertura de branch ligada. Os descontos: o pin velho e a falta de um lock de turno por conversa — o mesmo teto de concorrência do Fable 5.

> **Pra guardar:** desta vez não foi um local fraco colando do vizinho. Foi um modelo de fronteira consultando as respostas no meio da prova.

## Qwen 3.8 27B local: a rodada mais trabalhosa do ano

No artigo anterior eu disse que só testaria um local novo se surgisse evidência forte. Aí o irmão Max fez 92, a versão aberta de 27B estava disponível, e eu tinha a desculpa que faltava. Valeu pela ciência, mas deu trabalho.

A primeira surpresa: o 3.8 27B usa uma arquitetura híbrida SSM/Mamba, e o meu build tunado de llama.cpp do llama-swap **não consegue carregar o modelo** — falta um tensor (`ssm_conv1d`) que só as versões mais novas conhecem. A solução foi subir um container zerado do Ollama, que embute um llama.cpp atual, e importar o GGUF que eu já tinha baixado via Modelfile. Primeira lição: em modelo local, as ferramentas envelhecem em meses.

A segunda surpresa: contexto. Um modelo de raciocínio torra uma quantidade absurda de tokens pensando, e janela pequena não basta — com 32K ou 64K ele nem termina a prova, esgotando tudo na leitura do código da gem antes de escrever a primeira linha do app. A rodada oficial precisou de **176K de contexto**, quase tudo que os 32 GB da RTX 5090 aguentam. Quem impediu o modelo de terminar foi teto de contexto, não falta de capacidade.

Aí veio o incidente. A primeira rodada completou — e completou bem demais. Fui olhar o log: o modelo tinha lido **dezesseis vezes** o app pronto do Qwen 3.8 Max online, que estava no repositório, e copiado a UI e o streaming dele. Teria levado uns 75 pontos com trabalho alheio. Anulei e refiz sem nenhum app de terceiro por perto. E como a seção do Gemini ali em cima mostra, não são só os locais que procuram ajuda quando ela está dando sopa.

> **Pra guardar:** modelo local fraco não inventa só API inexistente — ele também cola do vizinho quando o vizinho está no mesmo diretório.

Na rodada limpa, o 27B fez **51 pontos, Tier C** — empatado, por acaso, com a nota do Qwen3.7 Max online. E o recibo é misto. O miolo ele acertou: `add_message` de verdade, `with_tools` de verdade, calculadora por descida recursiva sem `eval`, fruto de ter lido o código da gem de verdade. Onde ele afundou foi na largura: usou ActiveRecord onde os requisitos proíbem, o streaming sai quebrado (os tokens são transmitidos, mas o balão da resposta nunca entra na tela — ela só aparece se você atualizar a página), não usou `with_schema`, não fez orçamento de tokens, entregou **zero testes**, RuboCop com 22 ofensas, e nem Dockerfile saiu. Já a auto-revisão foi exemplar: ele mesmo achou e confessou cada um desses defeitos, com arquivo e linha — 14 dos 15 pontos de honestidade. Sabe revisar melhor do que constrói.

Custo da rodada: zero reais, 37 milhões de tokens e 156 minutos de uma RTX 5090 suando.

Pra calibrar o 51: o piso do Tier A é o **Opus 4.6 com 83**. O gap de 32 pontos não está em "conhecer a biblioteca" — nisso o 27B agora acerta. Está nas dimensões de robustez de produção: streaming, testes, gates, Docker, orçamento. É a diferença entre saber programar e saber entregar.

E comparando com os locais de antes — sempre com o aviso de que as provas não são comparáveis: no v1, os Qwens locais alucinavam a gem por inteiro (um inventou um `Openrouter::Client` com a capitalização errada, outro criou um `RubyLLM::Client` que não existe). O Qwen 3.5 35B acertou o ponto de entrada, mas os testes embrulhavam qualquer exceção num `assert true`. O 3.6 35B foi o primeiro local a acertar as chamadas principais, ainda com o multi-turn quebrado. O 3.8 27B acerta o núcleo inteiro da API numa prova muito mais difícil. A nota não dá pra comparar; o comportamento, dá: conhecimento de API deixou de ser o problema dos locais. O problema agora é engenharia.

## Grok 4.6: o primeiro empate geracional, e a rodada mais limpa

Depois de dois flagrantes de cola, veio um respiro. Rodei o Grok 4.6 já com a blindagem no talo: tirei tudo do alcance do modelo — a rubrica de correção, o relatório inteiro do v2, o scanner de auditoria, o catálogo de deduções do `CLAUDE.md` e os 44 apps dos concorrentes, todos movidos pra fora do repositório. Foi a primeira rodada sob esse regime mais rígido. E a varredura pós-prova não achou nada: zero leitura de arquivo de correção, zero olhada em app vizinho. Passou limpo. Depois do Gemini e do Qwen local, é bom ver um modelo de fronteira construindo sozinho porque não tinha por onde colar.

O resultado traz um dado curioso: **92 pontos, Tier A, a mesma nota do Grok 4.5.** É o primeiro empate de geração contra geração de toda a prova. Enquanto o GLM subiu 83, 92, 94, o Kimi foi de 77 a 86 a 95 e o Claude escalou sem tropeço, o Grok andou de lado. O 4.6 não comprou um ponto sequer sobre o 4.5. Na tabela lá em cima o 4.5 aparece com 91 porque uso o número dele no grok CLI, o harness nativo; cabeça a cabeça no mesmo OpenCode, os dois batem 92 cravado.

O que ele entregou é sólido e real. API do RubyLLM correta de ponta a ponta, uma calculadora sem `eval` escrita à mão (tokenizer por regex e parser, provada ao vivo com `(12.5*4)/2+7 = 32.0`), um teste que confere a array exata enviada ao provider, store em arquivo com lock sobrevivendo a restart com dois workers, orçamento de tokens com estimador de fallback, e o `docker compose up --build` respondendo um chat de verdade. O streaming foi provado ao vivo na fase 2: cinco tokens chegando incrementais enquanto o POST ainda estava aberto. E foi o mais econômico de todos os Tier A no OpenCode, com 10 milhões de tokens, porque o Grok é seco. Custou $6,33 e 34 minutos.

Os descontos são honestos, e ele mesmo confessou. O lock não cobre a janela de leitura-alteração-escrita, então dois turnos simultâneos na mesma conversa viram uma corrida de último-a-escrever-vence, o mesmo perigo do GLM 5.2. A cobertura de teste é rasa no caminho crítico, com o teste de integração sendo só um smoke test da home. E manteve o pin velho no `claude-sonnet-4.6`, a dedução padrão da casa. Auto-revisão de 12 PASS e 2 PARTIAL, tudo conferido pelo auditor. Nada de brilho novo: é um bom modelo repetindo um bom modelo.

> **Pra guardar:** nem toda geração nova traz ponto. O Grok 4.6 empatou consigo mesmo, e a notícia boa foi ter passado limpo pela blindagem mais dura que já apliquei.

## Conclusão: quão perto eles chegaram?

Resposta curta: muito perto.

| Modelo | Score | Tier | Tempo | Custo |
|---|---:|:---:|---:|---|
| GLM 5.3 | **94** | A | 80 min | $0 no plano (~$2,59 em API) |
| Gemini 3.7 Flash | **93** | A | 43 min | $4,12 |
| Qwen 3.8 Max | **92** | A | 78 min | $9,16 em API |
| Grok 4.6 | **92** | A | 34 min | $6,33 em API |
| Qwen 3.8 27B local | **51** | C | 156 min | $0 |

GLM 5.3 a dois pontos do Fable 5 não é "alternativa barata", é candidato à liderança. Qwen 3.8 Max a um ponto de Sol e Terra idem. A distância entre a nata americana e os chineses novos é de um ou dois pontos — e eu mesmo repito em todo artigo que um ou dois pontos é ruído. E o Gemini 3.7 Flash entrou no bolo: 93, empatado com Sol, Terra e Opus 4.8, o primeiro Gemini a chegar lá pelo OpenCode. O Grok 4.6 entrou no mesmo balde dos 92, mas com um asterisco só dele: foi a única geração nova que não melhorou nada sobre a anterior, e mesmo assim foi a primeira a passar limpa pela blindagem mais dura.

E o local segue fora de questão pra coding agent autônomo: Tier C é Tier C. Mas repare que a conversa mudou. Até pouco tempo atrás eu descartava local porque ele inventava API. Hoje ele conhece a API e tropeça em streaming, testes e Docker — e precisa de 176K de contexto e 32 GB de VRAM só pra completar a prova. O gargalo subiu de nível. Não é recomendação ainda; é o caminho sendo pavimentado.

> **Pra guardar:** a nata da nata continua sendo Fable, Opus, Sonnet, K3 e os GPT 5.6. Mas o pelotão de perseguição já está a um ou dois pontos — e o fosso entre "fronteira" e "alternativa" virou território de ruído.

Como sempre: artefatos, logs, rubrica, deduções e a tabela atualizada estão no [llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark). As duas rodadas do Gemini 3.7 — a anulada e a oficial — estão documentadas no relatório, com o achado de contaminação em destaque.
