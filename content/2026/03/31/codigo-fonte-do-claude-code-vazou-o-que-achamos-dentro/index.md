---
title: "O código fonte do Claude Code vazou. O que achamos dentro."
date: '2026-03-31T17:00:00-03:00'
draft: false
translationKey: claude-code-source-leak
tags:
  - ai
  - security
  - claude-code
  - vibe-coding
  - open-source
---

> Atualizado em 2 de abril de 2026: se você já tinha lido este texto ontem, vale pular direto para a [nova seção de atualização](#update-2026-04-02).

Hoje de manhã (31 de março de 2026), o pesquisador de segurança [Chaofan Shou](https://x.com/Fried_rice) descobriu que o código fonte inteiro do Claude Code, a CLI oficial da Anthropic pra coding com IA, estava disponível pra qualquer pessoa no registry público do npm. 512 mil linhas de TypeScript. 1.900 arquivos. Tudo exposto num arquivo de source map de 59.8MB incluído acidentalmente na versão 2.1.88 do pacote `@anthropic-ai/claude-code`.

Em poucas horas o código já estava espelhado no GitHub, analisado por milhares de desenvolvedores, e a Anthropic soltou uma nota dizendo que foi "erro humano no empacotamento de release, não uma brecha de segurança". O que é tecnicamente verdade mas ignora que o resultado é o mesmo.

![Tweet anunciando o vazamento](https://raw.githubusercontent.com/kuberwastaken/claude-code/main/public/leak-tweet.png)

Eu uso Claude Code todo dia. Alguns dos artigos que você lê aqui eu escrevi com ele. Então resolvi olhar o que tem dentro. Inclusive comecei este texto no próprio Claude Code, mas meu plano Max acabou antes de eu terminar. O resto eu fechei no Codex.

## Como aconteceu o vazamento

O Claude Code é empacotado com o [Bun](https://bun.sh/), o runtime JavaScript que a Anthropic adquiriu no final de 2024. Quando você builda com Bun, source maps são gerados por padrão. Esses arquivos `.map` contêm o código fonte original completo, não só mapeamentos. Cada arquivo, cada comentário, cada constante interna, cada system prompt.

A teoria inicial era que um [bug conhecido no Bun](https://github.com/oven-sh/bun/issues/28001) teria causado o vazamento: mesmo com `development: false`, source maps continuavam sendo servidos e incluídos nos bundles. Mas o próprio [Jarred Sumner](https://github.com/oven-sh/bun/issues/28001#issuecomment-4164447815), criador do Bun, desmentiu: "This has nothing to do with claude code. This is with Bun's frontend development server. Claude Code is not a frontend app. It is a TUI. It doesn't use Bun.serve() to compile a single-file executable." Ou seja, o bug do Bun afeta o dev server de frontend, não o processo de build que gerou o pacote npm do Claude Code.

O que de fato aconteceu é mais simples: alguém na Anthropic esqueceu de adicionar `*.map` ao `.npmignore` ou não configurou o bundler pra pular geração de source maps em builds de produção. E pior: segundo o [The Register](https://www.theregister.com/2026/03/31/anthropic_claude_code_source_code/), o source map não só apontava pros arquivos originais, como referenciava um ZIP hospedado num bucket Cloudflare R2 da própria Anthropic. O npm serviu feliz pra qualquer pessoa que rodasse `npm pack`, e o resto virou trabalho de espelho.

![Arquivos fonte expostos no pacote npm](https://raw.githubusercontent.com/kuberwastaken/claude-code/main/public/claude-files.png)

A ironia é que o código contém um sistema inteiro chamado "Undercover Mode" feito especificamente pra evitar que informações internas da Anthropic vazem em commits e PRs. Eles construíram um subsistema pra impedir o AI de revelar codinomes internos, e aí o source map expôs tudo.

## O que tem dentro: as features escondidas

O código fonte revela 44 feature flags cobrindo funcionalidades prontas mas ainda não lançadas. Não é vaporware. É código real escondido atrás de flags que compilam pra `false` nos builds externos. Vou destacar as mais interessantes.

### KAIROS: Claude que nunca para

Dentro do diretório `assistant/`, existe um modo chamado KAIROS, um assistente persistente que não espera você digitar. Ele observa, registra e age proativamente sobre coisas que percebe. Mantém arquivos de log diários append-only, recebe prompts `<tick>` em intervalos regulares pra decidir se deve agir ou ficar quieto, e tem um budget de 15 segundos: qualquer ação proativa que bloquearia o workflow do usuário por mais de 15 segundos é adiada.

Ferramentas exclusivas do KAIROS: `SendUserFile` (envia arquivos pro usuário), `PushNotification` (notificações push), `SubscribePR` (monitora pull requests). Nada disso existe no build público.

### BUDDY: um Tamagotchi no terminal

Não estou inventando. O Claude Code tem um sistema completo de pet companion estilo Tamagotchi chamado "Buddy". Um sistema gacha determinístico com 18 espécies, raridade, variantes shiny, stats gerados proceduralmente, e uma "alma" escrita pelo Claude no primeiro hatch.

A espécie é determinada por um PRNG Mulberry32 seedado pelo hash do userId. Mesmo usuário sempre recebe o mesmo buddy. Tem 5 stats (DEBUGGING, PATIENCE, CHAOS, WISDOM, SNARK), 6 estilos de olhos, 8 opções de chapéu, e sprites renderizados como ASCII art de 5 linhas com animações. O código referencia 1-7 de abril de 2026 como janela de teaser, com lançamento completo pra maio de 2026.

### ULTRAPLAN: 30 minutos de planejamento remoto

O ULTRAPLAN offloads tarefas complexas de planejamento pra uma sessão remota rodando Opus 4.6, dá até 30 minutos pra pensar, e permite que você aprove o resultado pelo browser. O terminal mostra polling a cada 3 segundos, e quando aprovado, um valor sentinela `__ULTRAPLAN_TELEPORT_LOCAL__` "teletransporta" o resultado de volta pro terminal local.

### Multi-Agent: "Coordinator Mode"

O sistema de orquestração multi-agente no diretório `coordinator/` transforma o Claude Code de um agente único num coordenador que spawna, dirige e gerencia múltiplos workers em paralelo. Research em paralelo, síntese pelo coordenador, implementação pelos workers, verificação pelos workers. O prompt ensina paralelismo explicitamente e proíbe delegação preguiçosa: "Do NOT say 'based on your findings' - read the actual findings and specify exactly what to do."

E tem mais. O leak também mostra teammates in-process com `AsyncLocalStorage` pra isolar contexto, workers em processos separados via tmux/iTerm2 panes, sincronização de memória entre agentes, e flags já prontas para `BRIDGE_MODE`, `VOICE_MODE`, `WORKFLOW_SCRIPTS`, `AFK mode`, `advisor-tool` e `history snipping`. Isso não garante lançamento, mas sugere um roadmap bem mais adiantado do que a versão pública deixa transparecer.

## A arquitetura de memória

O sistema de memória me chamou atenção. Não é um "guarde tudo e recupere". É uma arquitetura de três camadas:

[![Resumo da arquitetura de memória do Claude Code](https://new-uploads-akitaonrails.s3.amazonaws.com/2026/03/31/claude-code-memory-architecture.jpg)](https://x.com/himanshustwts/status/2038924027411222533)

O `MEMORY.md` é um índice leve de ponteiros (~150 caracteres por linha) que fica permanentemente carregado no contexto. Não guarda dados, guarda localizações. O conhecimento real está distribuído em "topic files" buscados sob demanda. Transcrições brutas nunca são lidas inteiras de volta no contexto, apenas pesquisadas com grep pra identificadores específicos.

E isso vem com uma disciplina importante: o sistema escreve primeiro no arquivo de tópico e só depois atualiza o índice. O `MEMORY.md` não vira depósito de fatos. Continua sendo só mapa. Se você deixa o índice virar storage, ele polui o contexto permanente e degrada o sistema inteiro.

O sistema "Dream" (`services/autoDream/`) é um motor de consolidação de memória que roda como subagent em background. O nome é intencional. É o Claude sonhando.

O sonho tem um sistema de trigger com três portas: 24 horas desde o último sonho, pelo menos 5 sessões desde o último sonho, e aquisição de um lock de consolidação (impede sonhos concorrentes). As três precisam passar.

Quando roda, segue quatro fases: Orient (ls no diretório de memória, lê o índice), Gather (busca sinais novos em logs, memórias desatualizadas, transcrições), Consolidate (escreve ou atualiza topic files, converte datas relativas pra absolutas, deleta fatos contraditos), e Prune (mantém o índice abaixo de 200 linhas e ~25KB).

Os tipos de memória são quatro: `user` (perfil do usuário), `feedback` (correções e confirmações), `project` (contexto sobre o trabalho em andamento), `reference` (ponteiros pra sistemas externos). A taxonomia exclui explicitamente coisas deriváveis do código (patterns, arquitetura, git history, file structure).

O subagent de sonho recebe bash read-only. Pode olhar o projeto mas não pode modificar nada. É puramente uma passada de consolidação.

E tem outro detalhe que eu achei elegante: memória não é tratada como verdade. É tratada como pista. O sistema assume que memória pode estar velha, errada ou contraditória, então o modelo ainda precisa verificar antes de confiar. Isso é o oposto da fantasia de "joga tudo num banco vetorial e deixa a mágica acontecer".

## O "Undercover Mode"

Funcionários da Anthropic (identificados por `USER_TYPE === 'ant'`) usam o Claude Code em repositórios públicos e open source. O Undercover Mode (`utils/undercover.ts`) impede que o AI revele informações internas acidentalmente em commits e PRs.

Quando ativo, injeta no system prompt:

```
## UNDERCOVER MODE - CRITICAL

You are operating UNDERCOVER in a PUBLIC/OPEN-SOURCE repository. Your commit
messages, PR titles, and PR bodies MUST NOT contain ANY Anthropic-internal
information. Do not blow your cover.

NEVER include in commit messages or PR descriptions:
- Internal model codenames (animal names like Capybara, Tengu, etc.)
- Unreleased model version numbers (e.g., opus-4-7, sonnet-4-8)
- Internal repo or project names
- Internal tooling, Slack channels, or short links
- The phrase "Claude Code" or any mention that you are an AI
- Co-Authored-By lines or any other attribution
```

Não tem como desligar. Se o sistema não tem certeza que está num repositório interno, fica em modo undercover. Isso confirma uma coisa meio desconfortável: a Anthropic usa Claude Code pra contribuir em open source, e o agente é instruído a esconder que é IA.

Os codinomes internos são nomes de animais: Tengu (codinome do projeto Claude Code), Fennec (Opus), Capybara, Numbat (em teste). O "Fast Mode" é internamente chamado de "Penguin Mode" com endpoint `claude_code_penguin_mode` e kill-switch `tengu_penguins_off`.

## As partes mais paranoicas

Tem uma parte da análise que eu quase deixei passar porque estava olhando mais pras features escondidas. Mas talvez o mais revelador sobre a mentalidade da Anthropic esteja nos mecanismos de defesa contra cópia e abuso.

Segundo a análise do [Alex Kim](https://alex000kim.com/posts/2026-03-31-claude-code-source-leak/), existe um modo de anti-distillation que pode pedir ao servidor pra injetar ferramentas falsas no prompt do sistema. A ideia é envenenar tráfego gravado por quem estiver tentando destilar o comportamento do Claude Code pra treinar concorrente. Tem também um segundo mecanismo de sumarização de texto de conectores, assinado criptograficamente, pra que parte do tráfego observável não corresponda ao raciocínio bruto original. Não é proteção perfeita. É mais uma camada de atrito. Mas mostra que a empresa está pensando explicitamente em cópia por observação, não só em segurança tradicional.

E tem a parte mais agressiva: client attestation. Cada request inclui um header de billing com um placeholder `cch=00000`, e o runtime nativo do Bun substitui isso por um hash calculado abaixo da camada JavaScript. Em outras palavras, não basta parecer Claude Code. O binário tenta provar que é Claude Code. Isso ajuda a explicar por que a briga com ferramentas terceiras como OpenCode ficou tão sensível: não era só questão comercial ou jurídica. Tinha enforcement técnico embutido no transporte.

### Atualização: o DRM morreu em menos de 24 horas

Lembram que eu mencionei o client attestation como "a parte mais agressiva"? Pois é. Durou menos de um dia.

Pra entender o contexto: a Anthropic vinha travando uma guerra contra ferramentas terceiras desde janeiro de 2026. Primeiro veio o bloqueio server-side de tokens OAuth vindos de clientes não-oficiais. Depois, em março, o maintainer do [OpenCode](https://github.com/anomalyco/opencode) mergeou um [PR](https://github.com/anomalyco/opencode/issues/7456) removendo toda autenticação Claude do projeto. O commit message tinha duas palavras: "anthropic legal requests." O [The Register reportou](https://www.theregister.com/2026/02/20/anthropic_clarifies_ban_third_party_claude_access/) que a Anthropic atualizou seus termos de serviço pra deixar explícito que tokens OAuth de assinaturas Pro/Max só podem ser usados no Claude Code oficial e no Claude.ai. Quem pagava $100-200/mês pelo Max e queria usar a ferramenta de sua escolha ficou na mão.

O mecanismo técnico por trás do bloqueio era justamente o `cch=`. Com o código vazado dá pra ver que o sistema tem duas partes. A primeira é um sufixo de versão: o campo `cc_version` inclui 3 caracteres hex derivados da primeira mensagem do usuário via SHA-256, usando um salt de 12 caracteres embutido no JavaScript. A segunda é o body hash propriamente dito: o corpo inteiro do request (mensagens, ferramentas, metadata, modelo, config de thinking, tudo) é serializado como JSON compacto com o placeholder `cch=00000`, e então hasheado com [xxHash64](https://github.com/Cyan4973/xxHash) usando um seed fixo. O resultado é mascarado com `0xFFFFF` (20 bits) e formatado como 5 caracteres hex lowercase. O placeholder é substituído pelo hash calculado antes do request sair do processo.

O detalhe que faz a diferença: essa substituição acontece dentro do runtime nativo do Bun, escrito em Zig, abaixo da camada JavaScript. O Bun literalmente muta a string JavaScript in-place, sobrescrevendo os bytes `00000` no buffer da string com o hash computado. Se você rodasse o mesmo bundle em Node ou num Bun stock, o placeholder iria pro servidor como está e o request seria rejeitado.

E aí veio o vazamento. Com o source code exposto, o [@StraughterG](https://x.com/StraughterG/status/2039344027556798476) (Jay Guthrie) anunciou na noite do mesmo dia: "Yesterday I said Anthropic's compiled Zig cch= hash was banning 3rd-party Claude clients. Tonight, the DRM is dead. We extracted the algorithm from the binary. It's not advanced cryptography. It's a static xxHash64 seed."

O seed é `0x6E52736AC806831E`. O [algoritmo completo](https://a10k.co/b/reverse-engineering-claude-code-cch.html), como explicou numa sequência de tweets, cabe em poucas linhas de TypeScript:

```typescript
import xxhash from "xxhash-wasm";

const { h64Raw } = await xxhash();
const body = JSON.stringify(request); // com cch=00000 no placeholder
const hash = h64Raw(new TextEncoder().encode(body), 0x6E52736ACn | (0x806831En << 32n));
const cch = (hash & 0xFFFFFn).toString(16).padStart(5, "0");
// substituir cch=00000 por cch={valor calculado}
```

O [@paoloanzn](https://x.com/paoloanzn/status/2039348588741087341) celebrou: "we cracked it. the cch= signing system in claude code is fully reverse engineered." E já colocou o bypass no [free-code](https://github.com/paoloanzn/free-code), um fork do Claude Code com telemetria removida, guardrails de system prompt stripados, e todas as 54 feature flags experimentais desbloqueadas.

[![Screenshot do free-code rodando com features experimentais](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/01/free-code-screenshot.png)](https://github.com/paoloanzn/free-code)

O ponto técnico que importa: xxHash64 não é criptografia. É um hash de checksum projetado pra velocidade, não pra segurança. O seed é estático, embutido no binário. Muda a cada versão do Claude Code, mas dentro de uma versão é o mesmo pra todo mundo. A "segurança" dependia inteiramente de ninguém conseguir extrair o seed do binário Zig compilado. Com o source code vazado, essa obscuridade evaporou em horas.

Agora qualquer client terceiro — OpenCode, Claw-Code, o que for — pode interceptar o `fetch()`, hashear o body com o seed correto, e passar pela validação do servidor como se fosse o Claude Code oficial. A barreira que a Anthropic construiu pra proteger seu modelo de negócio de $2.5 bilhões de ARR era, no fim das contas, security by obscurity num hash não-criptográfico.

O terceiro detalhe é pequeno mas diz muito sobre produto real em produção: o sistema detecta frustração de usuário com regex. Sim, regex. Palavrão, insulto, "this sucks", esse tipo de coisa. É engraçado ver uma empresa de LLM fazendo sentiment analysis na base do `wtf|ffs|shit`, mas também é o tipo de solução pragmática que alguém coloca quando precisa de resposta barata e imediata, não de elegância conceitual.

## O que o código revela sobre como você usa o Claude Code

O [@iamfakeguru](https://x.com/iamfakeguru/status/2038965567269249484) compilou uma thread com sete achados técnicos do código que qualquer usuário deveria saber:

O Claude Code tem um cap de 2.000 linhas por leitura de arquivo. Quando você pede pra ler um arquivo maior, ele trunca silenciosamente. Resultados de ferramentas são cortados em 50.000 caracteres. O sistema de compressão de context window descarta mensagens antigas pra caber mais contexto novo. E existe uma diferença entre o nível de acesso de funcionários Anthropic (`USER_TYPE === 'ant'`) e o acesso público: ferramentas internas como `ConfigTool` e `TungstenTool` são invisíveis no build externo.

A descoberta mais útil da thread é como funcionários Anthropic contornam as limitações que os usuários externos enfrentam. O código revela que `USER_TYPE === 'ant'` desbloqueia ferramentas internas, beta headers exclusivos (`cli-internal-2026-02-09`), acesso a staging (`claude-ai.staging.ant.dev`), e um `ConfigTool` que permite alterar configurações em runtime. Builds externos compilam tudo isso pra `false` via dead code elimination.

Mas o ponto que interessa é: o CLAUDE.md que você coloca na raiz do seu projeto é lido inteiro pelo Claude Code e injetado no system prompt. É literalmente o lugar onde você controla como o agente se comporta. O [@iamfakeguru](https://x.com/iamfakeguru/status/2038965567269249484) publicou um override completo com 10 regras mecânicas, e depois subiu o arquivo inteiro num repositório separado: [iamfakeguru/claude-md](https://github.com/iamfakeguru/claude-md).

[![Screenshot do CLAUDE.md publicado pelo fakeguru](https://new-uploads-akitaonrails.s3.amazonaws.com/2026/03/31/claude-md-production-grade-agent-directives.png)](https://github.com/iamfakeguru/claude-md/blob/main/CLAUDE.md)

Eu não vou colar o bloco inteiro aqui. O que importa é o conteúdo: ele força verificação pós-edição (`tsc` e `eslint` antes de declarar sucesso), impõe releitura de arquivos antes de editar, exige leitura em chunks para arquivos grandes, assume truncamento silencioso de resultados muito longos, e manda quebrar trabalho maior em fases ou subagentes paralelos. Em outras palavras: ele transforma em regra explícita tudo que os usuários externos estavam apanhando para descobrir empiricamente.

Essas não são instruções mágicas. São guardrails. A diferença é que agora sabemos quais limites o sistema realmente tem e podemos escrever um CLAUDE.md que trabalha a favor deles, não contra eles.

## Bugs de cache que custam caro

O [@altryne](https://x.com/altryne/status/2038676458026189225) (Alex Volkov) reportou bugs de invalidação de cache que fazem tokens não-cacheados custarem 10-20x mais que os cacheados. São dois bugs: um de substituição de string no Bun que afeta a CLI standalone (workaround: usar `npx @anthropic-ai/claude-code` em vez do binário instalado), e outro na flag `--resume` que quebra o cache sem workaround conhecido. Mais de 500 usuários reportaram problemas similares de exaustão de quota. Se você sentiu que o Claude Code estava gastando tokens mais rápido que o esperado nos últimos dias, provavelmente não era impressão.

## "Spaghetti de staff engineer"

A análise do código revelou problemas reais. Um comentário no próprio fonte admite: "1.279 sessões tiveram 50+ falhas consecutivas (até 3.272) numa única sessão, desperdiçando ~250K chamadas de API por dia globalmente." O fix foram três linhas: limitar falhas consecutivas a três antes de desabilitar compactação.

O arquivo `print.ts` tem 5.594 linhas com uma única função de 3.167 linhas contendo doze níveis de nesting. O `main.tsx` tem 803.924 bytes num único arquivo. O `interactiveHelpers.tsx` tem 57.424 bytes. São arquivos que nenhum humano consegue revisar com confiança.

A reação mais viral veio do [@thekitze](https://x.com/thekitze/status/2038956521942577557): ele pediu pro GPT-5.4 avaliar o codebase e a nota foi 6.5/10. A descrição: "This is not junior spaghetti. This is staff-engineer spaghetti: performance-aware, feature-flagged, telemetry-instrumented, surgically optimized spaghetti." Ou seja, não é código ruim de inexperiência. É código ruim de pressão pra entregar rápido sem pagar o custo de organizar depois.

O [@thekitze](https://x.com/thekitze/status/2038986445839622405) também elaborou em outra thread sobre como o código evidencia falta de práticas básicas de engenharia. E é aqui que eu me sinto vindicado.

Eu venho repetindo em vários posts sobre [vibe coding](/tags/vibe-coding/) que velocidade sem disciplina produz exatamente isso. Os princípios que eu defendo, incrementos pequenos, testes a cada passo, revisão antes de commitar, refactoring contínuo, CI que rejeita complexidade ciclomática alta, são os mesmos princípios do Extreme Programming que funcionam desde os anos 2000. A Anthropic aparentemente não seguiu nenhum deles no próprio produto.

Uma função de 3.167 linhas com 12 níveis de nesting não é algo que aparece da noite pro dia. É acúmulo. É o resultado de dezenas de adições onde ninguém parou pra refatorar porque "tá funcionando, não mexe". É o anti-pattern clássico de vibe coding sem disciplina: gerar código com IA, ver que compila, fazer commit, repetir. Sem review rigoroso. Sem limites de complexidade no CI. Sem a regra básica de que se uma função passa de 50 linhas, ela precisa ser quebrada.

A ironia é que a Anthropic vende a ferramenta de vibe coding mais popular do mercado e não pratica o que eu chamo de vibe coding responsável. O Claude Code vale $2.5 bilhões de ARR. O código que gera esse faturamento tem qualidade 6.5/10.

## A questão do "clean room"

Com o código fonte inteiro público, surge uma implicação legal e competitiva séria. E aqui eu acho que muita gente começou a usar o termo "clean room" com uma leveza que não combina com o assunto.

Clean room de verdade não é só "reescrevi em outra linguagem" nem "não dei copy and paste". O modelo clássico é bem mais chato: um grupo estuda o original e produz uma especificação funcional; outro grupo, isolado, implementa a partir dessa especificação sem ver o código original. A ideia é justamente reduzir o risco de contaminação.

O [@braelyn_ai](https://x.com/braelyn_ai/status/2039025584626397491) levantou outro ponto interessante: com ferramentas generativas, alguém poderia tentar um "clean room rebuild" usando testes, comportamento observável e documentação, sem reaproveitar a implementação original. Em tese, faz sentido. Na prática, o que aparece no calor do vazamento costuma ficar numa zona bem mais cinzenta.

O caso do [Claw-Code](https://github.com/ultraworkers/claw-code) ilustra isso bem. O projeto se apresenta como rewrite independente e já migrou o foco para Python e Rust, mas o próprio README admite estudo direto do código exposto e fala até em parity audit contra archive local. Então eu não chamaria isso de clean room clássico no sentido mais rigoroso. Eu chamaria de reimplementação inspirada, com tentativa deliberada de se afastar do snapshot vazado.

Isso não quer dizer que toda reimplementação está condenada. Copyright de software não protege ideia abstrata, fluxo genérico de ferramenta, arquitetura em alto nível ou "uma CLI que faz X". Protege expressão concreta. Mas justamente por isso a disciplina importa. Quanto mais um projeto quiser sustentar independência, menos ele deveria depender do material vazado como benchmark direto.

Tem um detalhe mais pragmático aí: as cópias literais do source vazado provavelmente vão sumir rápido quando os primeiros DMCA começarem a chegar. Mirror cai fácil. É por isso que uma reimplementação interessa mais do que um espelho bruto. Isso não apaga a discussão jurídica, mas muda bastante o tipo de briga e a chance de continuar no ar.

Foi mais ou menos o que eu mesmo fiz quando [reescrevi o OpenClaw em Rust](/2026/03/16/reescrevi-o-openclaw-em-rust-funcionou-frankclaw/). O ponto não era copiar linha por linha. Era entender o comportamento e reescrever a peça inteira com código meu.

O site satírico [malus.sh](https://malus.sh/) apareceu hoje oferecendo "Clean Room as a Service" com o tagline "Robot-Reconstructed, Zero Attribution". A piada: robôs de IA recriam projetos open source eliminando obrigações de atribuição, com garantias tipo "This has never happened because it legally cannot happen. Trust us." e indenização via subsidiária offshore numa jurisdição que não reconhece copyright de software. É sátira, mas é sátira que descreve o que alguém vai tentar fazer de verdade.

<a id="update-2026-04-02"></a>
## Atualização em 2 de abril de 2026

Como o texto acima abre no calor do dia 31, vale registrar o que aconteceu logo depois. Resolvi adicionar esta atualização depois de ler [este tweet do @k1rallik](https://x.com/k1rallik/status/2039686500619534818), que resume bem o clima do pós-vazamento, mas mistura fatos confirmáveis com um pouco de épica demais.

Primeiro: a parte do DMCA ficou mais bagunçada do que parecia. A própria notice publicada no repositório `github/dmca` diz que o GitHub processou a remoção contra a rede inteira de **8.1 mil repositórios**, porque a notificação afirmava que "all or most of the forks" eram infringing na mesma medida que o repositório principal. No dia seguinte, a Anthropic publicou uma **retratação parcial**: pediu reinstalação de todos os repositórios removidos, exceto o `nirholas/claude-code` e **96 forks listados individualmente**. Então a tese de que a tentativa inicial foi ampla demais está certa. O retrato final, porém, não é "8.100 repositórios ficaram derrubados". O que houve foi um recuo formal depois da remoção em massa.

Segundo: o projeto [Claw-Code](https://github.com/ultraworkers/claw-code) realmente explodiu. Na hora em que atualizei este post, o GitHub já mostrava **142.829 stars** e **101.510 forks**. Isso por si só já basta pra dizer que a história saiu da categoria "fork curioso do vazamento" e entrou na categoria "efeito colateral competitivo real". O tweet viral que circulou hoje acerta no tamanho do estrago, mas exagera em alguns detalhes. O próprio README do projeto se autodescreve como "the fastest repo in history to surpass 50K stars" e diz que a marca veio em duas horas. Eu não consegui confirmar esse marco histórico de forma independente, então prefiro tratar isso como alegação do próprio projeto, não como fato fechado.

Terceiro: a parte do Rust também precisa de nuance. Sim, já existe workspace em Rust no branch principal e o `Cargo.toml` está com versão `0.1.0`. Mas eu não encontrei release pública no GitHub para sustentar a frase "já saiu release 0.1.0" como um lançamento formal. O que dá pra afirmar com segurança é outra coisa: o projeto já tem base em Python, já tem workspace em Rust, e já virou alvo de atenção suficiente para continuar existindo mesmo sem o mirror literal do código vazado.

## O que a Anthropic deveria ter feito

A Anthropic respondeu rápido. Tirou o pacote comprometido, soltou uma nota pública, e limpou o que podia. Mas o dano já estava feito. O código foi espelhado antes da remoção. Mirrors no GitHub, análises em blogs, threads no X/Twitter. Não tem como des-publicar algo na internet.

O que me incomoda não é o vazamento em si. Bugs acontecem. O que me incomoda é que isso era evitável com práticas básicas de engenharia:

1. Adicionar `*.map` ao `.npmignore`. Uma linha.
2. Configurar o bundler pra não gerar source maps em builds de produção. Uma flag.
3. Ter um CI check que rejeita publicação se o pacote contém `.map`. Um script de 5 linhas.
4. Ter um pipeline de release com review manual antes de publicar no npm. Processo, não código.

Nenhuma dessas é difícil. Todas são o tipo de coisa que se perde quando você está movendo rápido demais e não tem disciplina no processo de release. É exatamente o que eu prego como [vibe coding disciplinado](/tags/vibe-coding/): mover rápido não significa pular os guardrails.

E a segunda falha: a qualidade do código em si. 512 mil linhas com funções de 3 mil linhas e 12 níveis de nesting não é engenharia. É acúmulo. É o que acontece quando você gera código com IA sem review rigoroso, sem refactoring contínuo, sem CI que rejeita complexidade ciclomática alta. A ironia de ser justamente a empresa que vende a ferramenta de vibe coding mais popular do mundo não passa despercebida.

## Fontes

- [Kuberwastaken/claude-code - Breakdown completo do código vazado](https://github.com/Kuberwastaken/claude-code)
- [Alex Kim - Claude Code Source Leak: fake tools, frustration regexes, undercover mode](https://alex000kim.com/posts/2026-03-31-claude-code-source-leak/)
- [VentureBeat - Claude Code's source code appears to have leaked](https://venturebeat.com/technology/claude-codes-source-code-appears-to-have-leaked-heres-what-we-know/)
- [The Register - Anthropic accidentally exposes Claude Code source code](https://www.theregister.com/2026/03/31/anthropic_claude_code_source_code/)
- [Fortune - Anthropic leaks its own AI coding tool's source code](https://fortune.com/2026/03/31/anthropic-source-code-claude-code-data-leak-second-security-lapse-days-after-accidentally-revealing-mythos/)
- [Cybernews - Full source code for Anthropic's Claude Code leaks](https://cybernews.com/security/anthropic-claude-code-source-leak/)
- [Gizmodo - Source Code for Anthropic's Claude Code Leaks at the Exact Wrong Time](https://gizmodo.com/source-code-for-anthropics-claude-code-leaks-at-the-exact-wrong-time-2000740379)
- [Anthropic - Anthropic acquires Bun as Claude Code reaches $1B milestone](https://www.anthropic.com/news/anthropic-acquires-bun-as-claude-code-reaches-usd1b-milestone?s=33)
- [Bun Issue #28001 - Source maps incorrectly served in production](https://github.com/oven-sh/bun/issues/28001)
- [Hacker News - Claude's system prompt is over 24k tokens with tools](https://news.ycombinator.com/item?id=43909409)
- [malus.sh - Clean Room as a Service (sátira)](https://malus.sh/)
- [@iamfakeguru - Thread com 7 achados técnicos do código](https://x.com/iamfakeguru/status/2038965567269249484)
- [@altryne - Bugs de cache que custam 10-20x mais](https://x.com/altryne/status/2038676458026189225)
- [@thekitze - "Staff-engineer spaghetti" 6.5/10](https://x.com/thekitze/status/2038956521942577557)
- [@braelyn_ai - Clean room e implicações legais](https://x.com/braelyn_ai/status/2039025584626397491)
- [GitHub DMCA - Anthropic takedown notice processada contra a rede de 8.1K repositórios](https://github.com/github/dmca/blob/master/2026/03/2026-03-31-anthropic.md)
- [GitHub DMCA - Retratação parcial da Anthropic no dia seguinte](https://github.com/github/dmca/blob/master/2026/04/2026-04-01-anthropic-retraction.md)
- [ultraworkers/claw-code - Reimplementação em Python e Rust que virou o principal projeto pós-vazamento](https://github.com/ultraworkers/claw-code)
- [@mem0ai - Análise da arquitetura de memória](https://x.com/mem0ai/status/2039041449854124229)
- [@himanshustwts - Resumo da arquitetura de memória](https://x.com/himanshustwts/status/2038924027411222533)
- [iamfakeguru/claude-md - Override publicado com o CLAUDE.md completo](https://github.com/iamfakeguru/claude-md)
- [@StraughterG - "the DRM is dead" - reverse engineering do cch= hash](https://x.com/StraughterG/status/2039344027556798476)
- [@StraughterG - Seed xxHash64 e código TypeScript do bypass](https://x.com/StraughterG/status/2039344035555344550)
- [@paoloanzn - "we cracked it" - confirmação do reverse engineering](https://x.com/paoloanzn/status/2039348588741087341)
- [paoloanzn/free-code - Fork do Claude Code com telemetria removida e features desbloqueadas](https://github.com/paoloanzn/free-code)
- [a10k.co - What's cch? Reverse Engineering Claude Code's Request Signing](https://a10k.co/b/reverse-engineering-claude-code-cch.html)
- [The Register - Anthropic clarifies ban on third-party tool access to Claude](https://www.theregister.com/2026/02/20/anthropic_clarifies_ban_third_party_claude_access/)
- [OpenCode Issue #7456 - Claude Code API credentials removal](https://github.com/anomalyco/opencode/issues/7456)
