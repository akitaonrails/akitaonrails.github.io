---
title: "Clean Code pra Agentes de IA"
date: '2026-04-20T12:00:00-03:00'
draft: false
translationKey: clean-code-for-ai-agents
tags:
  - clean-code
  - AI
  - claude-code
  - vibecoding
  - software-engineering
---

Em 2008, Robert C. Martin (Uncle Bob) lançou **Clean Code: A Handbook of Agile Software Craftsmanship**. É um dos livros mais influentes da engenharia de software das últimas décadas. Pra quem não sabe, Uncle Bob começou a programar profissionalmente aos 17 anos, fundou a Object Mentor, assinou o Agile Manifesto, foi o primeiro chairman da Agile Alliance, é o criador do acrônimo SOLID. Ele escreveu uma dúzia de livros de design, arquitetura e prática, e influenciou gerações inteiras de desenvolvedores.

Eu acompanho o Uncle Bob há muitos anos. Troquei mensagem com ele algumas vezes ao longo das décadas, tenho opinião formada sobre as posições dele, e cheguei a fazer uma live no meu canal onde a gente conversou por quase uma hora sobre Clean Code, Agile, Craftsmanship e pra onde a indústria tava indo. Se você nunca viu, recomendo:

{{< youtube id="ycvaECDc31w" >}}

O Clean Code especificamente estabeleceu um padrão: código é escrito uma vez, mas lido dezenas de vezes. O trabalho do programador não é só fazer funcionar. É fazer funcionar **de um jeito que outro programador consiga entender, modificar e não quebrar**. Nomes significativos, funções pequenas, uma responsabilidade por classe, sem repetição, testes automatizados, estrutura clara. O público-alvo sempre foi outro ser humano sentado em frente ao editor tentando entender o que o primeiro fez.

Em 2026, esse público-alvo mudou.

## O público não é mais humano

Semana passada escrevi [VS Code é o novo cartão perfurado](/2026/04/11/vs-code-e-o-novo-cartao-perfurado/). A tese do artigo é que digitar código manualmente em editor de texto tá virando atividade de nicho, do mesmo jeito que digitar binário direto em painel de Altair virou relíquia depois que compiladores ficaram bons. O agente de IA é o novo compilador: eu descrevo intenção em linguagem natural, o agente navega código, edita, roda teste, ajusta, entrega.

Se essa tese tiver mesmo em pé, a pergunta seguinte é óbvia: **pra quem a gente tá escrevendo código agora?**

Não é pro programador humano que vai sentar amanhã pra manter. É pro agente que vai ler, editar e estender. E agente não é humano. Agente tem restrições técnicas diferentes, vieses diferentes, limitações diferentes. Uma parte do Clean Code continua valendo (em alguns casos fica mais crítica). Outra parte muda de peso. E aparecem exigências novas que o Uncle Bob não tinha como antecipar em 2008.

Esse artigo é sobre isso. Qual a versão de Clean Code que faz sentido quando o leitor primário é um LLM?

## As restrições reais dos agentes

Antes de re-ranquear, vale revisar o que os agentes enfrentam de verdade.

**Truncamento de arquivo.** A maioria das CLIs de agente limita leitura de arquivo a faixas pequenas. O Claude Code lê por default 2000 linhas por vez. Cursor, Codex, Windsurf, todos têm limites parecidos. Arquivo gigante simplesmente não entra inteiro na janela de contexto numa tacada só, agente tem que pedir pedaço por pedaço, ou pior, usar grep e reconstruir mentalmente.

**Atenção degrada com contexto.** Claude Opus tem contexto de 200k tokens, Sonnet de 1M, Gemini de 1M. Parece muito. Na prática, testes de "needle in haystack" mostram que a qualidade da recuperação cai bem antes do limite declarado. Flash Attention e variantes aceleram o cálculo, mas não substituem a atenção nativa cheia. Quanto mais coisa você enfia na janela, pior a precisão de detalhe. E o contexto do agente não tem só o seu código: tem CLAUDE.md, tem prompt do sistema, tem histórico de conversa, tem saída de tool, tem log de erro, tem output de teste. Tudo concorrendo pela mesma janela.

**Grep é mais barato que read.** O agente sabe disso. Ele prefere `rg "funcName"` do que carregar arquivo inteiro. Fica mais rápido, usa menos token, mira no alvo. Nomes únicos e distintivos tornam isso muito mais eficaz. Isso não é atalho, é decisão arquitetural: escrevi sobre isso em detalhe em [RAG Está Morto? Contexto Longo, Grep e o Fim do Vector DB Obrigatório](/2026/04/06/rag-esta-morto-contexto-longo/), mostrando que o próprio Claude Code navega repositório com `Glob` e `Grep`, sem vector DB, sem embedding, e isso não é deficiência, é design maduro. Busca lexical + leitor inteligente consome o texto bruto bate retriever denso + top-k em praticamente todo benchmark de domínio real. Você se beneficia disso na hora de organizar seu código: nomes grepáveis não são só "bom pra humano", são a API primária de navegação do agente.

**Tool calls custam token.** Cada `Read` ou `Edit` ou `Bash` gasta tokens de input e output. Arquivo curto, output de teste pequeno, log enxuto, tudo isso mantém o agente produtivo e a conta baixa.

**Latência importa.** Agente em loop, cada tool call adiciona segundos. Arquivo grande demorado de processar vira gargalo perceptível de sessão.

**Grepar por padrão visual é difícil.** Se você usou indentação inconsistente, tab vs espaço misturado, brace style variado entre arquivos, o agente gasta tokens internalizando a bagunça. Consistência ajuda.

A partir dessas restrições, dá pra re-ranquear os princípios do Clean Code em ordem de relevância pra trabalho com agente.

## Re-ranqueamento: Clean Code na era dos agentes

Vou da mais importante pra menos. Um aviso: não é que as de baixo deixam de importar. É que as de cima passaram a importar MUITO mais.

### 1. Funções pequenas (e arquivos pequenos)

Uncle Bob: "funções devem fazer UMA coisa, devem fazer BEM, e devem fazer só isso". Tamanho ideal de 4 a 20 linhas, no livro.

Pra agente, essa recomendação virou obrigação técnica. Uma função pequena cabe numa única tool call sem truncamento. Um arquivo curto (mantenha abaixo de 500 linhas, idealmente 200-300) cabe numa única leitura. Se o agente consegue pegar a unidade inteira de sentido numa chamada, ele raciocina sobre ela com atenção cheia. Se tem que paginar, ele monta um modelo mental fragmentado, e cada fragmento custa atenção.

Antigamente, "função pequena" era bom pra humano porque facilita leitura. Hoje, "função pequena" é bom porque casa com a unidade de processamento do modelo. Se tem uma recomendação pra levar em consideração, é essa.

### 2. Single Responsibility Principle (SRP)

Cada módulo faz uma coisa e tem uma razão pra mudar. Já era o coração do Clean Code. Pra agente, vira ainda mais crítico porque:

- O agente consegue isolar a unidade pra entender sem carregar o resto do sistema
- Dá pra rodar teste focado sobre ela
- Dá pra editar sem temer efeito colateral
- Grep por responsabilidade vira previsível

Código com responsabilidades embaralhadas força o agente a carregar muito mais contexto pra fazer qualquer mudança simples. Classe de 800 linhas que faz três coisas é pior pro agente do que três classes de 250 linhas, mesmo que o total seja o mesmo.

### 3. Nomes significativos e únicos

Clean Code já pregava: nomes revelam intenção, sem disinformação, distintivos, pronunciáveis, pesquisáveis. Pro agente, "pesquisáveis" virou a propriedade mais importante dessa lista.

Agente pesquisa código via grep/ripgrep o tempo todo. Nome genérico (`data`, `process`, `handler`, `Manager`, `Service`) retorna cinquenta matches e obriga o agente a ler cada um. Nome distintivo (`UserRegistrationValidator`, `InvoiceLineItemTotal`, `ClaudeCodeSessionTracker`) retorna três matches e o agente vai direto no certo.

Regra prática: se você grep o nome e vem muita coisa irrelevante, o nome tá ruim pro agente. Se vem só o que importa, o nome tá certo.

### 4. Comentários com contexto e proveniência

Aqui é onde a inversão é mais gritante. Pra Uncle Bob em 2008, o axioma era: "código bom se explica sozinho, comentário em excesso é code smell, cada comentário é uma dívida que fica desatualizada". Todo programador experiente que leu o livro absorveu essa regra. Código bem nomeado não precisa de comentário. Comentário demais = alerta de código ruim tentando se justificar.

Agora inverte. **O agente lê os comentários. E gosta deles**. Comentário vira contexto de primeira classe. O agente tem fluência perfeita de sintaxe, sabe exatamente o que `x++` faz, não precisa de legenda óbvia (esse tipo ainda é ruim, olha o item 13). O que ele NÃO sabe é por que você escolheu essa abordagem em vez da óbvia, qual bug de produção motivou essa lógica estranha, qual constraint de negócio força essa ordem específica, qual workaround existe porque a lib upstream tem bug conhecido #1234, qual commit introduziu essa decisão, qual issue do Jira é a referência. Esse tipo de informação é **proveniência**: o porquê da decisão. Só existe na cabeça do humano que escreveu, na mensagem de commit, ou num comentário bem colocado. Pro agente, o comentário é a fonte mais acessível durante um tool call.

Docstring com intenção e exemplo de uso também viraram sinal forte. Quando o agente pega uma função sem entender o contexto, docstring de cabeça (tipo JSDoc com exemplos, Python `"""`, Rust `///`) encurta drasticamente o caminho pra uma mudança correta. Uncle Bob era cético de JavaDoc em 2008 porque ficava desatualizado. Hoje, com o agente podendo reescrever a docstring junto com o código, esse contra-argumento perdeu peso.

Uma consequência prática disso é: **não pode os comentários que o agente escreve**. Se você tem o reflexo "comentário verboso é ruído" herdado da era Clean Code original, essa regra mudou. O agente colocou aquele comentário porque no ato de gerar o código ele decidiu que aquela informação era digna de preservar pra futura edição. Remover o comentário no code review é tirar contexto que o próprio agente vai querer ler na próxima interação. Deixa o agente comentar. Ele sabe o que faz. O único tipo de comentário do agente que vale remover é o comentário óbvio e redundante (item 13), e mesmo esses os modelos recentes raramente produzem se o system prompt tá bem escrito.

### 5. Tipos explícitos

Isso não tá no Clean Code de 2008 porque a indústria ainda não tinha se convertido. Mas em 2026 é critério fundamental.

Python sem type hints, JavaScript em vez de TypeScript, Ruby sem RBS. Código dinâmico sem anotação obriga o agente a inferir tipo a partir de uso, o que custa raciocínio e erra frequentemente. Código tipado dá gabarito imediato: assinatura fala o que entra, o que sai, quais estados são válidos. O agente economiza trabalho de descoberta e erra menos.

Se você ainda tá em Python 3 sem type hints, a transição vai aumentar a produtividade do agente muito mais do que qualquer refactoring de lógica.

### 6. DRY (Don't Repeat Yourself)

Clean Code já dizia: duplicação é raiz de todo mal. Pra agente, duplicação é pior que pra humano por uma razão específica: quando o agente tem que mudar uma coisa que tá replicada, ele pode atualizar uma cópia e esquecer das outras. A janela de atenção dele não tem gravidade natural que puxe "ah, tem mais duas cópias disso em outros arquivos". Ele tem que achar cada uma via grep, e se o padrão tem variação sutil entre as cópias, o resultado fica inconsistente.

Fatorar em função ou módulo reutilizável não é estética. É segurança de refactor automatizado.

### 7. Testes que o agente consegue rodar

Uncle Bob dedica um capítulo inteiro a Unit Tests e o F.I.R.S.T (Fast, Independent, Repeatable, Self-Validating, Timely). Continua valendo tudo, com um adendo importante: **o teste precisa ser executável pelo agente sem setup humano**.

Isso significa: comando pra rodar o teste tá no README ou CLAUDE.md, tá no `Makefile`, tá no `package.json`. Output tem formato previsível que o agente parseia. Não depende de seed manual de banco, de arquivo de config que não tá no repo, de credencial secreta. O agente escreve código, roda teste, lê output, ajusta, roda de novo. Esse ciclo é a base de tudo. Se o teste não roda headless, o agente fica cego.

Aqui eu falo com experiência de campo. Documentei isso no [Do Zero a Pós-Produção em 1 Semana com IA](/2026/02/20/do-zero-a-pos-producao-em-1-semana-como-usar-ia-em-projetos-de-verdade-bastidores-do-the-m-akita-chronicles/), onde mandei ver num projeto real: 274 commits em 8 dias, 4 aplicações integradas, 1.323 testes automatizados no final. O que fez aquilo funcionar não foi "IA programa sozinha". Foi **Extreme Programming com agente no lugar do par humano**. Rodar teste em cada commit, ter CI apertado, cobertura acima de 80% (95%+ na lógica de negócio), ratio de linha-de-teste pra linha-de-código em alguns módulos maior que 1:1. Parece overkill. Não é. Em 274 commits, o CI pegou bug real mais de 50 vezes, bugs que iriam direto pra produção se eu tivesse confiado cegamente no agente. Sem teste, o agente te entrega código plausível que silenciosamente quebra algo que funcionava ontem. Com teste forte, o agente vira multiplicador: ele gera teste, o teste valida o código que ele escreveu, o teste é a rede de segurança da próxima mudança dele. Loop virtuoso.

As práticas do XP (pair programming, CI, testes antes, refactoring contínuo, feedback curto) não ficaram obsoletas. Viraram **exatamente o jeito certo de trabalhar com agente**. Quem programa em cowboy mode sem teste, hoje, não é rebelde. É só lento, porque o agente sem teste fica chutando, e chute precisa ser revisado na mão, o que mata a velocidade que o agente deveria trazer. Testes bons com cobertura bem feita viraram a diferença entre agente produtivo e agente que fica chutando. Ou, dito de outro jeito: **TDD virou obrigação técnica, não mais filosofia**.

Cobri esse tema de outro ângulo em [Software Nunca Está "Pronto"](/2026/03/01/software-nunca-esta-pronto-4-projetos-a-vida-pos-deploy-e-por-que-one-shot-prompt-e-mito/), mostrando que a vida de pós-deploy é onde o teste mais importa: em dez dias de operação depois do lançamento, eu rodei 56 commits de correção, hardening e ajuste em resposta a comportamento real, e cada commit foi acompanhado de teste de regressão. Sem rede, cada um desses 56 commits seria uma oportunidade de quebrar algo que funcionava ontem. TDD não é fase, é hábito.

### 8. Estrutura de diretório previsível

Clean Code pouco fala sobre isso (tava mais focado em código dentro de arquivo). Pra agente, a organização em árvore importa. Se `src/controllers/users.rb` implica que tem `src/models/user.rb` e `src/views/users/`, o agente consegue antecipar paths sem precisar listar diretório. Se o projeto usa nomenclatura idiossincrática (arquivos random, nomes sem padrão, tudo flat numa pasta), o agente perde tempo com `find`.

Convenções fortes de framework (Rails, Django, Next.js, Laravel) ajudam muito agente. Projeto sem convenção, o agente cria uma com o tempo, mas até lá gasta tokens explorando.

### 9. Dependency Injection e Testabilidade

Código com dependências injetadas (não hardcoded) é mais fácil de testar em isolamento. O agente aproveita isso. Ele consegue substituir o `EmailSender` real por um `FakeEmailSender` no teste, sem tocar na lógica. Código que instancia suas dependências internamente obriga o agente a gambiarra-monkey-patch-sobe-servidor-de-mentira, que é lento, frágil, e polui a sessão com sujeira de infra.

DI não é cerimônia. É escopo de isolamento. E em projeto de vida real, DI vira rapidamente refactor load-bearing: num dos meus projetos (o [M.Akita Chronicles](/2026/03/01/software-nunca-esta-pronto-4-projetos-a-vida-pos-deploy-e-por-que-one-shot-prompt-e-mito/)), eu descobri depois do lançamento que precisava trocar o modelo LLM default pra outro provedor. A variável de ambiente existia desde o início. Mas o nome do modelo ainda estava hardcoded em referência em 24 arquivos. Um commit inteiro (`Centralize LLM model config`) tocou os 24 pra isolar a config numa constante única. Trocar de modelo depois disso virou mudança de uma linha. Esse é exatamente o tipo de refactor que só aparece depois que o software encosta na realidade, e é onde DI e isolamento de config pagam caro se você não fez antes.

### 10. Evitar aninhamento profundo

Clean Code fala de nível único de abstração por função. Um corolário é: evite `if` dentro de `for` dentro de `if` dentro de `try`. Cada nível de indentação é mais atenção que o modelo tem que gastar rastreando estado. Indentação de quatro níveis é MUITO mais cara cognitivamente pro agente do que dois níveis com early return.

Pattern matching, guard clauses, early returns, flatten de lógica, tudo isso melhora a legibilidade pro modelo igual melhora pra humano, só que de forma mais mensurável porque o custo é medido em qualidade de resposta.

### 11. Erro com contexto

`raise ValueError("invalid input")` não ajuda o agente quando ele lê o stack trace. `raise ValueError(f"invalid input: received {repr(x)}, expected non-empty string of digits")` ajuda. O agente usa mensagem de exceção como sinal pra debug. Mensagem vaga = agente roda round extra pra descobrir o que deu errado.

Uncle Bob falava disso em Error Handling: "Provide context with exceptions". Virou crítico agora.

### 12. Formatação e estilo

Não perde tempo nisso. Usa o formatador default ou mais popular da linguagem: `cargo fmt` pra Rust, `gofmt` pra Go, `prettier` pra JS/TS, `black` ou `ruff` pra Python, `rubocop -A` pra Ruby. Configura no pre-commit, configura no editor pra rodar ao salvar, e segue a vida. O agente lida bem com qualquer estilo consistente, e o formatador automático garante que o diff não fica bagunçado entre commits. Discussão de tab vs espaço, 80 vs 100 colunas, brace style, tudo isso virou ruído. O formatador decide, você aceita.

### 13. Comentário que descreve o óbvio

A última da lista. Continua ruim, virou ainda mais ruim. Comentários como `// increment i by 1` acima de `i++` desperdiçam tokens no agente exatamente como desperdiçavam paciência no humano. Modelo sabe ler código, não precisa de legenda óbvia.

Se você tem o hábito de escrever comentários óbvios porque alguma escola te ensinou assim, esse é o momento de parar. Em 2008 era ruim porque poluía visual. Em 2026 é ruim porque custa dinheiro real em tokens.

## O que Uncle Bob não podia antever

Além de re-ranquear o que tava no livro, algumas coisas novas surgiram que são específicas do mundo de agentes:

**Arquivos de meta-documentação pra agentes.** `CLAUDE.md`, `AGENTS.md`, `.cursor/rules`, e afins. São arquivos que o agente lê antes de qualquer tool call, descrevendo convenções do projeto, comandos importantes, caveats, coisas que não vão em docstring. Escrever esses arquivos é um skill novo: curto, direto, imperativo, orientado a ações. Nada de prosa filosófica. Bulletpoint do que agente precisa saber pra não cagar.

**README com arquitetura alto nível.** Uncle Bob pouco se importava com README (o livro é sobre código). Pra agente, READMEs bem feitos encurtam muito o caminho pro agente entender o shape do projeto. Diagrama simples em ASCII ou Mermaid ajuda.

**Logging estruturado.** Log em formato JSON com campos nomeados é muito mais útil pro agente do que log em prosa. Agente parseia JSON trivialmente, usa os campos pra filtrar erro relevante, correlaciona entre serviços. `printf` solto em texto livre obriga parsing heurístico.

**Comandos de observabilidade acessíveis.** `pnpm test`, `make lint`, `cargo check`, `python -m mypy` — quanto mais o projeto expõe comandos previsíveis que o agente pode invocar pra validar mudanças, melhor. Se pra rodar teste precisa de 10 passos de setup manual, o agente não roda teste, e o ciclo de feedback quebra.

**Scripts de setup idempotentes.** Agente tem que poder rodar `bin/setup` ou `scripts/bootstrap.sh` numa máquina limpa e chegar num estado que permita trabalhar. Se o onboarding depende de instruções em cabeça humana, o agente tá excluído do jogo.

## Instruindo o agente a escrever código limpo

Tem um detalhe importante que só fica claro depois de umas 500 horas usando agente: **nenhum LLM faz essas coisas por default**. Você pede pra ele "implementa a feature X" e ele vai implementar do jeito que o modelo acha médio. Sem injeção de dependência. Com funções de 80 linhas. Sem testes, ou com testes que mockam coisa errada. Duplicando lógica porque é mais rápido. Criando arquivo de 2000 linhas porque "fica tudo junto". Você precisa ESCREVER essas regras. O agente lê, e segue.

Onde escrever: `CLAUDE.md`, `AGENTS.md`, `.cursor/rules`, `.github/copilot-instructions.md`, dependendo da CLI. Formato: curto, imperativo, orientado a ação. Agente lê esses arquivos a cada iteração (o Claude Code relê o CLAUDE.md em toda query), então cada linha gasta token de contexto — densidade importa.

Abaixo segue uma proposta de template pra você colar num `CLAUDE.md` de projeto novo, consolidando o que discuti acima em formato que o agente consome. **Não é versão definitiva**, é ponto de partida pra testar, ajustar à sua linguagem, ao seu time, ao seu fluxo. Se alguma regra não encaixar no teu contexto, remove. Se precisar de regra nova, adiciona. O ponto é ter o esqueleto estruturado:

```markdown
## Code style

- Functions: 4-20 lines. Split if longer.
- Files: under 500 lines. Split by responsibility.
- One thing per function, one responsibility per module (SRP).
- Names: specific and unique. Avoid `data`, `handler`, `Manager`.
  Prefer names that return <5 grep hits in the codebase.
- Types: explicit. No `any`, no `Dict`, no untyped functions.
- No code duplication. Extract shared logic into a function/module.
- Early returns over nested ifs. Max 2 levels of indentation.
- Exception messages must include the offending value and expected shape.

## Comments

- Keep your own comments. Don't strip them on refactor — they carry
  intent and provenance.
- Write WHY, not WHAT. Skip `// increment counter` above `i++`.
- Docstrings on public functions: intent + one usage example.
- Reference issue numbers / commit SHAs when a line exists because
  of a specific bug or upstream constraint.

## Tests

- Tests run with a single command: `<project-specific>`.
- Every new function gets a test. Bug fixes get a regression test.
- Mock external I/O (API, DB, filesystem) with named fake classes,
  not inline stubs.
- Tests must be F.I.R.S.T: fast, independent, repeatable,
  self-validating, timely.

## Dependencies

- Inject dependencies through constructor/parameter, not global/import.
- Wrap third-party libs behind a thin interface owned by this project.

## Structure

- Follow the framework's convention (Rails, Django, Next.js, etc.).
- Prefer small focused modules over god files.
- Predictable paths: controller/model/view, src/lib/test, etc.

## Formatting

- Use the language default formatter (`cargo fmt`, `gofmt`, `prettier`,
  `black`, `rubocop -A`). Don't discuss style beyond that.

## Logging

- Structured JSON when logging for debugging / observability.
- Plain text only for user-facing CLI output.
```

Esse bloco cabe em menos de 100 linhas e gasta cerca de 500 tokens por iteração. Parece muito, mas a economia em qualidade de código e em ausência de retrabalho compensa facilmente, especialmente se você tá numa conta API paga por token. Tomem como base e evoluam com a experiência de cada um.

Alguns itens (SRP, funções pequenas, testes) o agente até tenta fazer sozinho. Outros (DI, DRY rigoroso, tipos explícitos em TODO lugar, nomes agressivamente únicos) ele só faz quando você fala explícito. E alguns (como "não apaga os comentários que você mesmo escreveu no refactor") são tão contraintuitivos pro treino padrão dele que sem a instrução ele VAI podar. Daí a importância do arquivo de regras existir e ser lido a cada iteração.

Tem um padrão análogo que vale mencionar, ligado ao princípio de defensive programming: o agente implementa circuit breaker, retry com backoff, timeout agressivo, graceful degradation, tudo certinho — **quando você pede**. Mas sozinho ele não vai propor. O agente não sabe quais são os pontos de falha operacional do teu sistema, então ele implementa o caminho feliz e espera instrução. Se a tua CLAUDE.md listar as categorias de defensive code que o projeto precisa (rate limit, retry, breaker, fallback), o agente cobre. Se não listar, ele não inventa. É outro caso em que a instrução explícita pro agente é o que separa código robusto de código ingênuo.

Se você usar o mesmo agente em projetos diferentes, vale ter um template base e adicionar rules específicas por projeto no topo. Mas comece com algo parecido com o acima e itere em cima.

## A versão curta

Uncle Bob escreveu o Clean Code pra ser lido por outros humanos. Em 2026, o leitor primário virou o agente. A boa notícia é que a maioria das coisas que o livro pregava continua valendo. A má notícia é que algumas coisas que eram opinião ("arquivo deve ter N linhas") viraram restrição técnica ("arquivo com X linhas faz o agente performar pior"). A diferença é que agora tem métrica: custo de token, latência de tool call, qualidade de output. Quem escreve código limpo pro agente economiza dinheiro de conta de API, tempo de sessão, e tem menos alucinação no output.

E tem um bônus cultural que vale registrar: todas essas práticas (XP, TDD, SOLID, SRP, DI, código pequeno, testes abundantes) estavam caindo em desuso nos anos 2010, substituídas por "move fast and break things" e bootcamp de dois meses. Os programadores que investiram em fundamento viraram minoria, e virou fashion falar mal de Uncle Bob na internet. Acontece que exatamente esses fundamentos passaram a ser o diferencial técnico de trabalhar com agente. Quem manteve a disciplina, tá bem servido. Quem desprezou, tá apanhando pra ensinar o agente a não cometer erros que a turma do XP tinha mapeado 25 anos atrás.

Código limpo nunca foi moda. Virou infraestrutura.
