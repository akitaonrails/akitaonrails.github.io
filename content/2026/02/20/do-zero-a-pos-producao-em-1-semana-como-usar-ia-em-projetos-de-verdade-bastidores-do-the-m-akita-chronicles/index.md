---
title: "Do Zero à Pós-Produção em 1 Semana - Como usar IA em Projetos de Verdade | Bastidores do The M.Akita Chronicles"
slug: "do-zero-a-pos-producao-em-1-semana-como-usar-ia-em-projetos-de-verdade-bastidores-do-the-m-akita-chronicles"
date: 2026-02-20T12:49:58+00:00
draft: false
tags:
- themakitachronicles
- rubyonrails
- xp
- extremeprogramming
- agile
- frankmd
---

Este post vai fazer parte de uma série; acompanhe pela tag [/themakitachronicles](/tags/themakitachronicles). Esta é a parte 9 e Final!

E não deixe de assinar minha nova newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

274 commits. 8 dias. 4 aplicações. 1.323 testes. Um sistema completo em produção — com assinantes reais recebendo uma newsletter toda segunda-feira às 7h, um podcast gerado por IA no Spotify, um blog estático no Netlify, e um bot no Discord que é minha interface operacional.

Fiz isso com um parceiro: Claude Code, um agente de IA rodando no terminal. E a lição mais importante que tirei não é que "IA programa sozinha" — é que **IA programando sozinha é a receita pro desastre**. O que funciona é algo que já tem nome e décadas de história: Extreme Programming. Só que agora o par no pair programming não é humano.

> Eu preciso que todos vocês passem por uma experiência: uma **IMERSÃO DE 1 SEMANA** completamente **DESAPEGADO** do código, usando a IA como pair programming, indo do zero até produção em qualquer projetinho pequeno. Vai por mim, até vocês fazerem pelo menos, não vão entender. Mas depois muda tudo.

![pair programming](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/pair-programming.jpg)

## O Mito do "One-Shot Prompt"

Tem uma narrativa crescente de que "vibe coding" é escrever uma spec detalhada, dar pro agente de IA, e ele entrega o sistema pronto. Tipo aqueles vídeos de "criei um SaaS em 10 minutos com o Cursor". Parece mágico até você olhar o que foi realmente entregue: um protótipo sem testes, sem segurança, sem tratamento de erros, sem deploy, sem nada que faça um sistema sobreviver ao contato com usuários reais.

A realidade dos meus 274 commits conta outra história:

| Categoria | Commits | % |
|-----------|---------|---|
| Features novas (`Add ...`) | 101 | 37% |
| Bug fixes (`Fix ...`) | 45 | 16% |
| Refactoring/hardening (`Harden`, `Extract`, `DRY`, `Rework`, `Replace`) | 27 | 10% |
| Segurança | 21 | 8% |
| Deploy/infra | 30 | 11% |
| Testes/CI | 44 | 16% |
| Documentação | 27 | 10% |

**Só 37% dos commits são features.** O resto é o trabalho que faz um software de verdade: corrigir bugs, endurecer contra falhas, proteger contra ataques, deployar, testar, documentar. Quem mostra só a parte das features está vendendo uma ilusão.

E mais: muitas das features surgiram **porque** a iteração revelou que eram necessárias. `ContentPreflight` não estava no plano original — nasceu quando a segunda newsletter saiu com uma seção vazia porque um job falhou silenciosamente. `RecoverStaleDeliveriesJob` nasceu quando percebi que um crash no meio do envio deixava emails num limbo eterno. `StealthBrowser` nasceu quando o Morningstar bloqueou o HTTParty. Nenhum spec do mundo prevê isso. **O sistema correto emerge da iteração, não da especificação.**

## Pair Programming Com Um Agente de IA

Eu não uso o Claude Code como um gerador de código. Uso como um par de pair programming.

A diferença é fundamental. Um gerador de código recebe uma spec e devolve output. Um par de pair programming **conversa**. Eu interrompo quando ele toma um caminho errado. Dou contexto que ele não tem. Questiono decisões. Peço alternativas. Às vezes digo "para, isso tá ficando complicado demais" e ele simplifica.

Alguns exemplos reais dos 274 commits:

**Interrupção por excesso de engenharia.** Quando pedi o sistema de email delivery, a primeira proposta tinha uma state machine com 8 estados, retry queues separadas, e dead letter handling. Interrompi: "Simplifica. Quatro estados: pending, sending, sent, unknown. Na dúvida, não reenvia." O resultado foi o `SendSingleEmailJob` com a variável `ses_accepted` como pivô — 40 linhas que resolvem o problema inteiro.

**Contexto que o agente não tem.** Quando estávamos no Yahoo Finance, o Claude tentou usar HTTParty. Expliquei: "Yahoo faz TLS fingerprinting, vai bloquear qualquer HTTP client que não seja browser real." Resultado: headless Chromium com crumb authentication. Isso não está em nenhum tutorial — é o tipo de conhecimento que vem de tentar e falhar.

**Decisão de arquitetura conjunta.** O podcast pipeline poderia ser um monolito Python. Sugeri: "Rails orquestra, Python serve TTS via HTTP, conteúdo integra por filesystem." O resultado — `QwenTtsClient` no Ruby chamando `podcast-tts` em Python — mantém cada linguagem no que faz melhor.

**Prompt refinement iterativo.** As primeiras newsletters saíam genéricas. Os comentários do Akita e do Marvin soavam iguais. Fui ajustando prompts com ele: "Akita nunca diz 'talvez'. Marvin usa 'bom...' e 'enfim'. O LLM vai suavizar opiniões se você não for explícito." Cada ajuste era um commit de prompt, testado com dados reais.

O padrão é: eu trago o **quê** e o **porquê**. O agente traz o **como** — e o como é frequentemente melhor do que eu faria sozinho. Mas o como sem o quê produz código correto que resolve o problema errado. E o quê sem o como produz specs que nunca saem do papel.

## Extreme Programming Não É Moda dos Anos 2000

![agile lifecycle development process diagram](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/agile-lifecycle-development-process-diagram-vector-31188796.jpg)

Tudo que fizemos tem nome no XP. Não porque planejei — porque são as práticas que naturalmente emergem quando você programa com feedback rápido:

### Pair Programming

Já expliquei. O par é o agente. A dinâmica é a mesma: um pilota, outro navega. Eu navego mais do que piloto — defino direção, questiono decisões, corrijo rota. O agente pilota mais do que navega — escreve código, roda testes, propõe soluções. Quando inverte (eu ditando código exato, ele apenas digitando), o resultado sempre piora.

### Small Releases

Dos 274 commits, **cada um passa no CI**. Sem exceção. Não existe "commit quebrando que vai ser consertado no próximo". Cada commit em master é production-ready.

O CI roda em cada commit: RuboCop (estilo) → bundler-audit (vulnerabilidades de gems) → Brakeman (segurança estática) → testes completos. São ~22 segundos. Parece pouco, mas multiplicado por 274 commits são 100+ minutos de validação automatizada que eu não precisei fazer manualmente.

A distribuição de commits por dia mostra o ritmo:

| Data | Commits | Destaque |
|------|---------|----------|
| 10/fev (seg) | 4 | Scaffold inicial, Discord bot, blog |
| 11/fev (ter) | 41 | Explosão de features: 7 seções de newsletter, temas, X polling |
| 12/fev (qua) | 49 | Podcast pipeline, deploy, segurança, market data real |
| 13/fev (qui) | 29 | Daily digest, scraping resiliente, hardening |
| 14/fev (sex) | 30 | Integração end-to-end, email hardening, blog deploy |
| 15/fev (sáb) | 40 | Podcast fine-tuning, cross-app, story management |
| 16/fev (dom) | 26 | Primeira newsletter real enviada para assinantes |
| 17/fev (seg) | 31 | Refactoring, Application Commands, anime fix |
| 18/fev (ter) | 24 | DRY shortcodes, backup job, consolidação |

A "explosão" do dia 2 não é caos — são small releases empilhadas. Cada uma adiciona uma feature, roda CI, está pronta pra deploy. Não é waterfall de 2 semanas seguido de big bang merge. É integração contínua de verdade.

### Test-Driven Development

1.323 testes. 970 no marvin-bot (6 segundos em paralelo), 353 no newsletter (1 segundo em paralelo). Ratio:

| App | Código (linhas) | Testes (linhas) | Ratio teste/código |
|-----|----------------|-----------------|-------------------|
| marvin-bot | 9.348 | 13.929 | 1.49x |
| newsletter | 3.397 | 5.391 | 1.59x |
| **Total** | **12.745** | **19.320** | **1.52x** |

**Mais linhas de teste do que de código.** Em ambas as aplicações. E isso não é vanidade — é a infraestrutura que permite velocidade.

Coverage por SimpleCov:

| App | Line Coverage | Branch Coverage |
|-----|--------------|-----------------|
| marvin-bot | 82.4% | 73.1% |
| newsletter | 86.8% | 70.5% |

Não é 100% — e nunca será. Os 17-18% não cobertos são majoritariamente integração com APIs externas (Discord, SES, OpenRouter) que são mockadas nos testes. O coverage real em lógica de negócio está acima de 95%.

A pergunta que importa: **esses testes são úteis?** A prova empírica: em 274 commits, eu vi o CI falhar e pegar um bug real mais de 50 vezes. Sem esses testes, cada um desses bugs teria ido pra produção. O agente propõe uma mudança, o teste pega a regressão, a mudança é corrigida antes de commitar. Sem testes, o agente te entrega código plausível que silenciosamente quebra algo que funcionava ontem.

TDD com um agente de IA é multiplicativo. O agente é bom em gerar testes — sabe os padrões, sabe os edge cases comuns, sabe a estrutura do Minitest. E os testes que ele gera viram a rede de segurança das mudanças que ele mesmo faz depois. É um ciclo virtuoso: **testes permitem velocidade, velocidade gera mais testes**.

### Refactoring Contínuo

27 commits explícitos de refactoring. Alguns exemplos:

- **`Extract StealthBrowser wrapper`** — O código de headless browser com stealth patches estava duplicado em 4 clients. Extraiu pra um serviço, 4 clientes ficaram com 5 linhas cada.
- **`DRY section rendering: collapse 5 bubble methods + 7 Hugo shortcodes`** — 5 métodos de renderização de bolha no `MarkdownToHtml` que eram copy-paste com cores diferentes colapsados em 1 método parametrizado. 7 shortcodes Hugo delegando pra 1 partial.
- **`Replace market recap LLM generation with Yahoo Finance real data`** — O LLM inventava números de mercado. Substituí por dados reais do Yahoo Finance + commentary do LLM. Melhor resultado, menor custo.
- **`Replace DuckDuckGo with Brave Search API`** — DuckDuckGo não tem API estável. Brave Search tem API oficial com 2.000 queries/mês grátis. Troca limpa.
- **`Rework ArticleFetcher: browser-first with anti-detection`** — Duas reescrituras completas. A primeira tentou HTTP-first com fallback pra browser. A segunda inverteu: browser-first porque a maioria dos links de leitores são SPAs. Cada reescritura manteve os testes passando.

O refactoring é onde o par de pair programming brilha. Eu digo "esse código tá duplicado, extrai um concern" e o agente faz em 2 minutos o que me levaria 20. Mas **eu** decido o quê extrair e **como** a interface deveria ser. O agente sozinho não refatora — ele empilha código novo em cima do existente.

### Integração Contínua

O CI já descrito acima: rubocop + bundler-audit + brakeman + testes. Roda em cada commit, em ambas as apps. Brakeman merece destaque:

| App | Controllers | Models | Warnings | Ignored |
|-----|------------|--------|----------|---------|
| marvin-bot | 6 | 8 | 0 | 0 |
| newsletter | 10 | 5 | 0 | 2 |

Zero warnings de segurança em ambos. As 2 ignored no newsletter são false positives documentados (SQL interpolation com paths de config, não user input).

Brakeman pegou problemas reais durante o desenvolvimento: SQL injection numa query de busca, path traversal no controller de imagens, redirect aberto no unsubscribe. Cada um corrigido antes de ir pra produção, no mesmo commit que o CI flaggou.

## A Anatomia de Uma Feature: Do Pedido ao Deploy

Vou pegar um exemplo concreto pra ilustrar como o fluxo funciona na prática. O `List-Unsubscribe` (commit `5950ccc`).

**Contexto**: emails de confirmação não chegavam no Gmail. Tudo verde — DKIM, SPF, DMARC, SES aceitando. Mas Gmail jogava no spam silenciosamente.

**Investigação** (eu + agente): pesquisamos. Desde fevereiro de 2024, Gmail exige `List-Unsubscribe` + `List-Unsubscribe-Post` em todo email de bulk sender. Sem eles, penaliza o **domínio inteiro** — incluindo emails transacionais.

**Implementação** (agente executa, eu valido): header no `SesMailer`, endpoint RFC 8058 no `UnsubscriptionsController` (skip CSRF pra email clients, retorna 200 ao invés de redirect), testes cobrindo ambos os flows.

**CI**: rubocop OK, brakeman pegou o `skip_forgery_protection` como warning (correto — validamos que é condicional). Testes passam.

**Deploy**: `kamal deploy`. Em 2 minutos, a correção está em produção. Reputação do domínio leva 1-2 dias pra se recuperar. No dia seguinte, emails de confirmação voltam a chegar.

**Tempo total**: ~25 minutos do "por que o Gmail tá rejeitando?" ao deploy em produção. Sem o agente, seriam horas de leitura de RFC, implementação manual, e esperança de que não esqueci nada.

## O Que a IA Faz Bem (E o Que Faz Mal)

Depois de 274 commits com um agente de IA, tenho uma noção bem clara dos pontos fortes e fracos:

### Faz bem:

- **Boilerplate e scaffolding**: jobs, services, testes, migrations — o agente produz na velocidade de digitação
- **Testes**: surpreendentemente bom em identificar edge cases e gerar testes abrangentes
- **Refactoring mecânico**: renomear, extrair métodos, mover código entre arquivos — rápido e preciso
- **Pesquisa contextual**: "como funciona RFC 8058?" produz resposta acionável em segundos
- **Consistência**: segue padrões estabelecidos no projeto (concerns, naming conventions, test structure) sem esquecer

### Faz mal:

- **Decisões de arquitetura**: tende a over-engineer. Precisa de freio humano constante
- **Conhecimento de domínio específico**: não sabe que o Yahoo faz TLS fingerprinting ou que o VoiceDesign do Qwen produz sotaque europeu
- **Opiniões**: suaviza tudo. Prompts de personalidade viram mush genérico sem instruções explícitas
- **Segurança proativa**: implementa o que você pede, mas raramente sugere proteções que você não pediu (SSRF, rate limiting, encryption at rest)
- **Priorização**: executa qualquer coisa com igual entusiasmo. Não diz "isso é perda de tempo" ou "faça X antes de Y"

IA não programa sozinha, e não é inútil. **É um multiplicador do programador, não um substituto**. Um programador medíocre com IA produz código medíocre mais rápido. Um programador experiente com IA produz código bom na velocidade que antes só era possível com equipes.

## Os Números que Importam

Vamos ao tamanho real do que foi construído em 8 dias:

### Código

| Componente | Linhas |
|------------|--------|
| marvin-bot app (Ruby) | 9.348 |
| marvin-bot tests (Ruby) | 13.929 |
| newsletter app (Ruby) | 3.397 |
| newsletter tests (Ruby) | 5.391 |
| podcast-tts (Python) | 1.770 |
| Hugo templates (HTML) | 193 |
| Blog CSS | 261 |
| AI prompts (Markdown) | 795 |
| CLAUDE.md (guia do projeto) | 702 |

**Total de código funcional: ~16.000 linhas. Total com testes: ~36.000 linhas.**

### Componentes

- **43 services** no marvin-bot (scrapers, AI, parsers, validators, uploaders)
- **38 jobs** no marvin-bot (geração de conteúdo, daily digest, podcast, infraestrutura)
- **12 services** no newsletter (email delivery, publishing, assembly)
- **11 jobs** no newsletter (sending, recovery, backup, blog publishing)
- **23 prompt templates** de IA (personalidade, geração, podcast, tools)
- **17 shortcodes** Hugo (renderização de seções no blog)
- **3 RubyLLM tools** (image generation, web search, web fetch)

### Pipeline

- **10 seções** de conteúdo geradas por semana (anime, hacker news, youtube, market, world events, history x3, holidays, closing remarks)
- **10 daily digest jobs** postando no Discord às 8h
- **1 podcast** de ~30 minutos gerado por semana (script + TTS + assembly + S3)
- **1 newsletter** montada, publicada no blog, e enviada por email toda segunda

## Isso É 200 User Stories?

![sprint planning](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/66d7f28718285e260f53fe6e_018b4d67589e6f4d2fdf9130502016fb4a75e73a-1200x674.jpg)

Olhei os 274 commits e tentei mapear pra user stories no sentido ágil. Nem todo commit é uma story — muitos são fixes dentro da mesma feature, ajustes de prompt, ou cleanup de CI. Mas a contagem conservadora de features distintas, cada uma com critérios de aceitação implícitos (funciona, tem teste, passa no CI, deploya):

> **Estimativa: ~180-200 user stories.**

Isso inclui:
- Cada seção de newsletter (10 geradores distintos com scraping, AI, validação, fallback)
- O pipeline de email (delivery tracking, claiming atômico, recovery, List-Unsubscribe)
- O pipeline de podcast (script LLM, TTS dual-model, assembly, S3, RSS)
- O Discord bot (15+ comandos, embeds, context, multi-turn /ask, daily digest)
- O blog (Hugo + Hextra, 17 shortcodes, RSS podcast, SEO, GA)
- A subscription page (confirmação, temas, LGPD, termos de serviço)
- Infraestrutura (Kamal deploy, Cloudflare, SES config, RunPod, backups)
- 21 commits de segurança (SSRF, CSP, rate limiting, encryption, path traversal)

Em Scrum tradicional com uma equipe de 2-3 devs, uma story bem feita (com code review, QA, deploy) leva em média 1-2 dias. 200 stories × 1.5 dias / 2 devs = **~150 dias de trabalho, ou ~30 semanas em sprints de 2 semanas** (contando planning, review, retro, e o overhead inevitável de coordenação entre pessoas).

Sendo generoso — equipe sênior, stories bem definidas, sem impedimentos — talvez 10-15 semanas.

> Nós fizemos em 8 dias. Uma pessoa e um agente de IA.

Mas — e isso é crucial — **eu não sou um dev qualquer e isso não é um projeto qualquer**. Eu tenho 30 anos de experiência em software. Sei quais decisões importam e quais não. Sei quando parar de engenheirar e shipar. Sei quando o agente está errado antes de ele terminar de gerar o código. E o projeto é solo-developer, sem code review externo, sem QA separado, sem coordenação entre equipes.

O multiplicador real do agente não é "10x mais código". É **eliminar o tempo morto**. Sem agente, 70% do meu tempo seria digitando boilerplate, lendo docs de API, escrevendo testes mecânicos, debugando typos. Com agente, esse tempo vira zero e eu foco 100% em decisões de arquitetura, domínio, e qualidade.

## O CLAUDE.md: A Spec que Evolui

Uma coisa que funciona excepcionalmente bem com agentes de IA é ter um documento vivo que descreve o projeto. O `CLAUDE.md` do projeto tem 702 linhas e cobre:

- Visão geral da arquitetura
- Stack tecnológico completo
- Todas as variáveis de ambiente
- Estrutura do diretório de conteúdo
- Serviços, jobs e models de cada app
- 12 "common hurdles" com soluções documentadas
- 14 design patterns do projeto
- Pipeline semanal completo com horários
- Checklist pós-implementação

Esse documento não foi escrito de uma vez. Ele **evoluiu com o projeto**. Cada vez que descobríamos um hurdle (Yahoo Finance precisa de Chromium, HN RSS muda de formato, LLM suaviza opiniões), documentávamos no CLAUDE.md. Na próxima sessão, o agente já sabe.

É o equivalente do onboarding doc de uma equipe — mas o "novo membro da equipe" é o agente, e ele lê o doc inteiro em 2 segundos antes de cada interação. O investimento em documentação retorna exponencialmente com agentes de IA porque **eles realmente leem**.

![claude.md](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_12-59-38.jpg)

## As Lições

**1. Vibe coding sem disciplina é protótipo descartável.** 274 commits com CI, testes, security scanning, e small releases é o oposto de vibe coding. É engenharia de software com um copiloto que digita rápido.

**2. TDD é mais importante com IA, não menos.** O agente modifica código com confiança porque tem 1.323 testes como rede de segurança. Sem testes, cada mudança é uma aposta.

**3. O humano decide o quê. O agente decide o como.** Inverta e o resultado piora dramaticamente.

**4. Refactoring contínuo é obrigatório.** O agente empilha código. Se você não poda regularmente — extrair concerns, DRY duplicações, simplificar interfaces — a base de código vira um monólito de 500 linhas por arquivo.

**5. Documentação é investimento com retorno imediato.** Cada hora documentando no CLAUDE.md economiza horas de contexto perdido em sessões futuras.

**6. Small releases são a chave.** Cada commit é production-ready. Se algo der errado, reverte um commit. Se a feature era má ideia, nunca dependeu de outra. Isso só funciona com CI automático.

**7. Segurança não é fase — é hábito.** 21 commits de segurança espalhados por 8 dias, não concentrados numa "sprint de segurança" no final. Brakeman roda em todo commit. Vulnerabilidades são corrigidas no momento que aparecem.

**8. O agente nunca diz "não".** Isso é um bug, não uma feature. Se você pede algo over-engineered, ele implementa com entusiasmo. Se pede algo inseguro, ele implementa sem reclamar. **Você** é o freio. **Você** é o code review. **Você** é o adulto na sala.

## O Contra-Exemplo: FrankMD

Tudo que descrevi acima pode soar teórico. *"Claro que TDD e refactoring contínuo são importantes"* — todo mundo concorda em tese. Então vou provar empiricamente com um contra-exemplo do **mesmo desenvolvedor, com o mesmo agente de IA, duas semanas antes**.

Antes do M.Akita Chronicles, eu construí o [FrankMD](https://github.com/akitaonrails/FrankMD) — um editor Markdown em Rails, estilo Obsidian/VSCode. 212 commits em 19 dias. Mesmo setup: eu + Claude Code como par de pair programming.

![frankmd](https://camo.githubusercontent.com/4d7ffcd26d22eb57334017e3b946a10eeb59cacf609edcc8caebf68d03d528b4/68747470733a2f2f6e65772d75706c6f6164732d616b6974616f6e7261696c732e73332e75732d656173742d322e616d617a6f6e6177732e636f6d2f6672616e6b6d642f323032362f30322f73637265656e73686f742d323032362d30322d30315f31342d31332d32392e6a7067)

A diferença: no FrankMD, eu fiz o que qualquer desenvolvedor faz quando "é só um projetinho pessoal". Foquei em features. Testes? Depois. Refactoring? Quando necessário. CI? Roda quando lembrar.

### A Espiral do `app_controller.js`

O FrankMD é um SPA-like com Stimulus. No início, todo o JavaScript vivia em um único arquivo: `app_controller.js`. Aqui está o que aconteceu com ele ao longo dos commits:

| Momento | LOC | O que aconteceu |
|---------|-----|-----------------|
| Commit #1 (inicial) | 506 | Scaffold limpo, editor básico |
| Commit #44 (~10 features depois) | ~4.372 | File finder, themes, typewriter, image picker, emoji... |
| Commit #54 (pico) | **4.990** | Tudo dentro. AI grammar, video embed, content search... |
| **Refactor 1**: Extract utilities + image picker | 3.249 | -35%, 6 módulos + 1 controller extraídos |
| **Refactor 2**: Extract 10 Stimulus controllers | 1.803 | -45%, 10 controllers com testes |
| Features crescem de novo... | 2.739 | Mais código empilhado |
| **Refactor 3**: Extract utility modules | 2.684 | -2%, pequeno |
| **Refactor 4**: Extract domain controllers | 2.074 | -23%, 4 controllers novos |
| Features crescem... | 2.367 | De volta a crescer |
| **Refactor 5**: Extract autosave/scroll-sync | 1.837 | -22% |
| **Refactor 6**: Replace custom JS with Rails 8 built-ins | 1.511 | -17%, -383 linhas líquidas |
| Estado final | 1.576 | 39 controllers + 29 lib modules |

O padrão é claro: **construir-construir-construir-PARAR-refatorar**. O arquivo cresceu 10x em 54 commits, atingiu quase 5.000 linhas, e então precisei de **6 rodadas de refatoração** pra trazer de volta ao aceitável. Cada parada foi um commit grande (centenas de linhas movidas, dezenas de arquivos criados), não um ajuste cirúrgico.

O CSS seguiu o mesmo padrão: 1.053 linhas num único `application.css`, até o commit de refactoring que explodiu em 10 arquivos de tema + 9 arquivos de componente.

### Testes: Antes vs. Depois

No FrankMD, o 2º commit foi "Add comprehensive test suite" — testes de sistema (integração browser). Parece responsável, mas esses testes cobriam **o happy path e nada mais**. Os testes de unidade JavaScript vieram só no commit #52, **depois que o app_controller.js já tinha 5.000 linhas** — porque eu precisava de testes pra refatorar com segurança. Testes retroativos.

A cobertura Ruby reflete isso: teve que ser empurrada de 77% pra 89% num commit explícito de "Add tests for untested success paths". Não era TDD — era **preencher buracos depois**.

### Os Números Lado a Lado

| Métrica | FrankMD | M.Akita Chronicles |
|---------|---------|---------------------|
| Commits | 212 | 274 |
| Dias | 19 | 8 |
| Commits/dia | 11 | 34 |
| Testes | 1.364 JS + ~490 Ruby | 1.323 Ruby |
| Coverage Ruby | ~89% (retroativo) | 82-87% (orgânico) |
| Ratio teste/código | ~1.2x | 1.52x |
| Refactors "pare tudo" | 6 grandes | 0 |
| Refactors incrementais | 16 | 27 |
| Maior arquivo (pico) | 4.990 LOC | — |
| CI a cada commit | Não | Sim |

O número que importa: **commits por dia**. O M.Akita Chronicles teve 3x mais throughput — com TDD, CI, e refactoring contínuo — porque **nunca precisou parar**. Nenhum commit de "parar tudo e refatorar 5.000 linhas em 10 arquivos". Nenhum momento de "preciso adicionar testes retroativos pra poder mexer nesse código sem medo".

### A Lição Concreta

Os 6 refactors grandes do FrankMD não foram "refactoring contínuo". Foram **cirurgias de emergência em dívida técnica acumulada**. Cada um levou horas — não os 2 minutos do "extrai um concern" descrito acima. E cada um introduziu riscos: quando você move 1.500 linhas de um arquivo pra 10 arquivos novos, a chance de quebrar algo é proporcional ao tamanho da mudança.

Com TDD e refactoring contínuo, o M.Akita Chronicles nunca acumulou essa dívida. Os 27 refactors são commits pequenos — "Extract StealthBrowser", "DRY bubble methods" — que levam minutos e são protegidos por 1.323 testes que já existiam quando o refactoring foi feito.

**Mesmo desenvolvedor. Mesmo agente de IA. Duas abordagens diferentes. Resultado: o projeto disciplinado entregou mais, em menos tempo, com menos dor.**

## Conclusão

![xp book](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/41MD3fXWOXL.jpg)

Esse projeto não é um showcase de IA. É um showcase de engenharia de software acelerada por IA. E a prova mais forte é que o **mesmo desenvolvedor com o mesmo agente** produziu resultados radicalmente diferentes dependendo do processo.

No FrankMD, sem disciplina, o resultado foi previsível: um arquivo de 5.000 linhas, 6 cirurgias de emergência, testes retroativos, e 11 commits por dia. No M.Akita Chronicles, com XP, o resultado foi 34 commits por dia, zero paradas forçadas, 1.323 testes orgânicos, e um sistema em produção em 8 dias. A variável não foi a IA — foi o processo.

274 commits em 8 dias não acontecem porque o agente é mágico. Acontecem porque Extreme Programming — pair programming, TDD, small releases, refactoring contínuo, integração contínua — funciona tão bem com um par de IA quanto funciona com um par humano. Talvez melhor em alguns aspectos: o agente nunca cansa, nunca discute por ego, nunca diz "mas sempre fizemos assim", e lê 700 linhas de documentação antes de cada interação sem reclamar.

O futuro do desenvolvimento não é "IA substituindo programadores". É programadores que sabem usar IA como ferramenta — com a mesma disciplina que sempre usaram com qualquer outra ferramenta — produzindo em uma semana o que equipes inteiras levam trimestres.

Não porque a IA é genial. Porque **o processo** é genial. O XP tinha razão desde o começo. Só faltava um par que nunca cansa e digita a 1000 palavras por minuto.

Lembrem-se:

> "A IA é seu espelho, ele revela mais rápido quem você é. Se for incompetente, vai produzir coisas ruins mais rápido. Se for competente, vai produzir coisas boas mais rápido." - by Akita