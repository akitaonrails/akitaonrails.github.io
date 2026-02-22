---
title: "AI Agents: Qual seria a melhor Linguagem de Programação para LLMs?"
slug: "ai-agents-qual-seria-a-melhor-linguagem-de-programacao-para-llms"
date: 2026-02-09T20:20:30+00:00
draft: false
tags:
- claude
- gpt
- vibecode
---

Resolvi fazer um exercício bem bobo: perguntar ao Claude e ao GPT Codex o que eles consideram que seriam as características de uma linguagem de programação que beneficiaria a edição por LLMs, sem se preocupar em ser amigável para programadores humanos.

Design de Linguagens leva em consideração criar código razoavelmente otimizado, seguro, etc., mas balanceia isso com ser fácil para um humano ler, entender e editar depois. Normalmente essas duas coisas costumam entrar em conflito: quanto mais "amigável" pra um humano, menos eficiente é pra um compilador/máquina. Exemplos disso incluem linguagens dinâmicas como Python, Ruby, PHP e Javascript.

Na minha cabeça, imagino que as "melhores" (sempre entre aspas) para uma máquina sejam justamente as que nós, humanos, consideramos ter piores ergonomias: linguagens funcionais, fortemente tipadas, altamente burocráticas ou "verboses", por exemplo, Rust, OCaml, Lean, etc.

Coincidentemente (de novo, pergunte você mesmo), o Claude e o GPT chegaram mais ou menos a essa mesma conclusão. Não quer dizer que isso seja "correto". É o que o modelo consegue deduzir a partir de suas probabilidades, com a informação que tem. É um enorme exercício de "achismo". Mas eu acho que os argumentos fazem muito sentido.

Eu pedi pra me mostrar como seria um trecho de código dessa linguagem "AI-friendly", que parece com a AST de um Lisp, mas com mais funcionalidades, como anotações, metadados, tipagens, etc. Eu acho que o mais próximo de uma AST — com tooling adequado pra dar feedback — seria, mais ou menos, o que uma LLM gostaria mais pra editar.

Vejam o que vocês acham:

# Update: Pact-Lang

Na seção abaixo, há o raciocínio e as argumentações do Claude/GPT sobre a linguagem ideal. Eu gostei da ideia e resolvi pedir pro Claude gerar um protótipo de compilador que realmente funciona, usando o que ele mesmo descreveu como requisitos.

Ele escolheu fazer em Rust, uma linguagem chamada **PACT** (ele mesmo escolheu o nome), e essa versão inicial compila arquivos `.pct` e gera arquivos `.rs`. Eu nem testei ainda, só deixei ele fazer o projeto e joguei no GitHub.

* [Repositório do Pact-Lang](https://github.com/akitaonrails/pact-lang)

No X eu comentei que não achei impressionante quando a Anthropic fez hype que o Claude conseguiu fazer um compilador de C (usando GCC como comparação). Não é difícil fazer um compilador — é uma das primeiras matérias numa boa faculdade de ciências da computação; todo mundo que estudou já fez uma.

E, pra reforçar este ponto, o Claude conseguiu fazer um compilador de uma linguagem que não existe, que — segundo ele — é ideal para LLMs, mas não para humanos.

Não sei por que ninguém discutiu essa vertente de possibilidade ainda. Fica de curiosidade.

Eu não acho que — pelo menos no curto prazo — isso seja algo que realmente aconteça, mas me parece inevitável: por que gastar tanto pra tentar fazer a LLM se adaptar a uma linguagem feita para humanos, se o objetivo é evitar que humanos mexam mais diretamente no código?

A resposta mais óbvia é voltar ao início: fazer humanos escreverem especificações de software bem detalhadas. Até hoje isso era super improdutivo; já tentamos várias vezes ao longo dos anos. Mas era impraticável escrever especificações que depois outro humano precisava converter em código: era mais inteligente criar uma linguagem mais fácil de escrever que, mais ou menos, lembrasse uma boa especificação (assim, inventamos tipos fortes, anotações, testes unitários, etc.).

Mas se "gerar código" se torna uma tarefa trivial com a LLM, vale a pena dedicar mais tempo à especificação, ao famoso "blueprint". Não sei quão prático seria isso, mas é um raciocínio que, hoje, com LLMs, faz sentido, pelo menos, explorar.

Então vamos ao raciocínio que o Claude deu:

# Projetando uma Linguagem de Programação para Agentes de IA

Um experimento mental sobre como seria uma linguagem de programação se fosse concebida para agentes de codificação baseados em LLM, e não para programadores humanos.

---

## Sumário

- [O Problema](#o-problema)
- [O Que o Design Orientado a Humanos Faz de Errado para LLMs](#o-que-o-design-orientado-a-humanos-faz-de-errado-para-llms)
  - [Salvaguardas que se Tornam Redundantes](#salvaguardas-que-se-tornam-redundantes)
  - [O Que Realmente Ajudaria um LLM](#o-que-realmente-ajudaria-um-llm)
  - [O Insight Contraintuitivo](#o-insight-contraintuitivo)
  - [A Pergunta Real](#a-pergunta-real)
- [Um Protótipo: Como Seria](#um-prototipo-como-seria)
  - [Camada 0: A Especificação Humana](#camada-0-a-especificacao-humana)
  - [Camada 1: O Formato Nativo de IA](#camada-1-o-formato-nativo-de-ia)
  - [Camada 2: A Projeção Humana](#camada-2-a-projecao-humana)
  - [Camada 3: Como um LLM Editaria Isso](#camada-3-como-um-llm-editaria-isso)
  - [Justificativa das Decisões de Design](#justificativa-das-decisoes-de-design)
  - [Principal Conclusão](#principal-conclusao)
- [Linguagens Existentes: Quão Perto Estamos?](#linguagens-existentes-quao-perto-estamos)
  - [Nível 1: Mais Próximas da Visão](#nivel-1-mais-proximas-da-visao)
  - [Nível 2: Acertam Várias Coisas](#nivel-2-acertam-varias-coisas)
  - [Nível 3: Acertam Uma ou Duas Coisas](#nivel-3-acertam-uma-ou-duas-coisas)
  - [O Padrão Desconfortável](#o-padrao-desconfortavel)

---

## O Problema

Projetamos linguagens de programação para serem rápidas, seguras e principalmente **amigáveis para humanos** — modularidade, isolamento de escopo, sintaxe fácil, etc. Mas quando o principal "usuário" de uma linguagem é um agente de codificação baseado em LLM, as restrições mudam drasticamente. Humanos têm memória de trabalho limitada, leem de forma linear e interpretam visualmente. LLMs não compartilham essas restrições — mas têm outras que as linguagens atuais ignoram.

---

## O Que o Design Orientado a Humanos Faz de Errado para LLMs

### Salvaguardas que se Tornam Redundantes

- **Açúcar sintático** — Um LLM não precisa que `for x in list` seja mais bonito do que `loop(list, fn(x) -> ...)`. Ambos são igualmente fáceis de analisar. A ideia de "sintaxe legível" é uma preocupação humana. S-expressions de Lisp ou até mesmo notação de AST crua seriam suficientes.

- **Convenções de nomes** — camelCase vs snake_case, nomes curtos vs descritivos — existem para ajudar humanos a escanear e lembrar. Um LLM poderia trabalhar com UUIDs como identificadores se o *grafo semântico* estiver disponível.

- **Indentação/formatação** — Inteiramente visual. Delimitadores explícitos de bloco (ou apenas uma AST) são inequívocos. O whitespace significativo do Python é, na verdade, *mais difícil* para LLMs porque o espaço em branco é hostil à tokenização.

- **Redução de boilerplate** — DRY existe porque humanos odeiam repetição e perdem o controle de lógica duplicada. Um LLM não se cansa nem se perde. Repetição explícita com checagens de consistência garantidas pode ser *melhor* do que mágica implícita (pense em convenções do Rails que escondem comportamento).

- **Divulgação progressiva de complexidade** — Linguagens escondem coisas (parâmetros padrão, conversões implícitas, sobrecarga de operadores) para não sobrecarregar humanos. Isso atrapalha LLMs — comportamento oculto significa que o modelo precisa simular o que o runtime *realmente faz* versus o que o código *parece fazer*.

### O Que Realmente Ajudaria um LLM

1. **Metadados semânticos ricos, inline** — Não comentários (linguagem natural é ambígua), mas anotações *legíveis por máquina* de intenção. "Esta função é pura." "Este bloco deve executar em < 10ms." "Este invariante deve valer: x > 0 na saída." Sistemas de tipos atuais são uma versão fraca disso. O ideal são **contratos, efeitos e proveniência** como cidadãos de primeira classe, não acoplados depois.

2. **Rastreabilidade bidirecional** — Cada linha de código deve saber *por que existe*. Link para o requisito, o teste, a justificativa do commit. Ao editar uma função, a linguagem deveria dizer "isso existe por causa do requisito R-1234, é testado pelo teste T-56 e é dependido pelos módulos A, B, C". Linguagens atuais não suportam isso — fica em ferramentas externas (Jira, git blame, grep).

3. **Grafos de dependência formais e consultáveis como primitivo da linguagem** — Não `imports` para perseguir. A capacidade de perguntar ao runtime: "qual é o impacto transitivo total de mudar este tipo?" e obter uma resposta precisa. LSP é uma aproximação improvisada.

4. **Rastreamento determinístico e total de efeitos** — Toda função deve declarar *tudo* o que pode fazer: I/O, mutação, alocação, panic, não-terminação. O monad IO do Haskell está na direção certa, mas é grosseiro demais. O ideal: "esta função lê da rede, escreve nesta tabela específica do banco e pode lançar estes 3 tipos de erro". Isso permite que um LLM raciocine sobre mudanças *sem executar o código*.

5. **Semântica nativa de diff/patch** — Linguagens atuais representam *estado* (o fonte atual). LLMs trabalham em *deltas* (edições). Uma linguagem desenhada para LLMs poderia representar programas como um *histórico de transformações* com significado semântico, não arquivos de texto planos. Pense: um programa é uma cadeia de refatorações, não um monte de caracteres.

6. **Especificações baseadas em restrições ao lado da implementação** — Em vez de apenas escrever código e esperar que testes capturem erros, toda função carregaria uma especificação formal. LLMs são muito melhores em verificar "esta implementação satisfaz esta restrição formal?" do que "este código faz o que aquele comentário vago diz?".

7. **Eliminação de sobrecarga ambígua** — Cada operação deve ter exatamente um significado no contexto. O fato de `+` significar soma de inteiros, soma de floats, concatenação de strings e concatenação de listas dependendo dos tipos é uma conveniência humana que cria carga de inferência para LLMs.

### O Insight Contraintuitivo

A linguagem que um LLM *realmente* gostaria se parece menos com Python e mais com um **formato de AST tipado, total e com rastreamento de efeitos, com especificações formais embutidas e metadados completos de proveniência** — basicamente um IR rico com densidade semântica de algo como Lean 4 ou Idris, mas sem qualquer preocupação com aparência na tela.

A ironia: **isso já existe em partes.** LLVM IR, WebAssembly, Typed Racket, Dafny, F*. Ninguém usa diretamente porque são hostis a humanos. Uma linguagem nativa para LLMs seria essencialmente um IR *muito* rico que nenhum humano gostaria de escrever, emparelhado com uma projeção voltada a humanos (tipo um "view layer") para quando pessoas precisarem ler.

### A Pergunta Real

A questão mais profunda não é "que linguagem LLMs deveriam usar" — é **LLMs deveriam usar linguagens textuais?** Texto é um formato de serialização para cognição humana. A interface ideal de programação para LLMs pode ser manipulação direta de um grafo semântico com verificação formal a cada passo, onde "código-fonte" como texto plano simplesmente não existe.

---

## Um Protótipo: Como Seria

O mesmo conceito — um serviço HTTP simples de usuários — mostrado em quatro camadas: a especificação humana de intenção, o formato nativo de IA, uma projeção humana, e a interface de edição semântica.

### Camada 0: A Especificação Humana

Se humanos não escrevem mais código — nem o formato nativo (Camada 1), nem a projeção legível (Camada 2) — o que *exatamente* eles escrevem? A resposta: **uma especificação declarativa de intenção**. Não é código. Não é pseudocódigo. É uma declaração estruturada do que o sistema deve fazer, quais restrições deve respeitar, e quais garantias deve oferecer. O humano descreve o *quê* e o *porquê*. A IA decide o *como*.

Isso não é linguagem natural livre (ambígua demais) nem uma linguagem de programação (detalhada demais). É algo intermediário: uma **DSL de especificação** onde o vocabulário é restrito, a estrutura é formal, mas a cognição exigida é de *design de produto*, não de *engenharia de software*.

Para o mesmo serviço de usuários:

```yaml
spec: SPEC-2024-0042
title: "Serviço de usuários"
owner: time-plataforma
status: rascunho

domain:
  User:
    campos:
      - nome: obrigatório, texto, 1–200 caracteres
      - email: obrigatório, formato email, único no sistema
      - id: gerado automaticamente, imutável

endpoints:
  buscar-usuário:
    descrição: "Retorna um usuário pelo ID"
    entrada: id do usuário (da URL)
    saídas:
      - sucesso: o usuário encontrado (200)
      - não encontrado: quando o ID não existe (404)
      - ID inválido: quando o formato do ID é incorreto (400)
    restrições:
      - tempo máximo de resposta: 50ms
      - somente leitura no banco

  criar-usuário:
    descrição: "Cria um novo usuário"
    entrada: nome e email (do corpo da requisição, JSON)
    saídas:
      - sucesso: o usuário criado (201)
      - email duplicado: quando o email já existe (409)
      - validação falhou: lista de erros de validação (422)
    restrições:
      - tempo máximo de resposta: 200ms
      - idempotente por email (mesma requisição não duplica)
      - escrita no banco

qualidade:
  - toda função deve ser total (sem crashes, sem loops infinitos)
  - todo campo deve ter validação explícita
  - todo erro deve ser tipado e enumerado (sem exceções genéricas)

rastreabilidade:
  - testes requeridos: cobertura de todos os caminhos de saída
  - dependências conhecidas: api-router, admin-panel
```

**O que essa especificação *não* contém:**

- Nenhuma decisão de implementação (qual banco, qual framework, qual padrão de validação)
- Nenhuma sintaxe de programação (sem tipos, sem funções, sem imports)
- Nenhum detalhe de serialização (o formato JSON é uma restrição, não uma instrução de como serializar)
- Nenhuma preocupação com estrutura de arquivos, módulos ou organização de código

**O que o LLM faz com isso:**

1. Interpreta a especificação e gera a Camada 1 (o formato nativo de AST com todos os metadados, efeitos, invariantes e proveniência)
2. Deriva automaticamente os testes a partir das saídas declaradas
3. Calcula o grafo de dependências a partir das dependências conhecidas
4. Preenche a proveniência linkando cada função de volta à seção da spec que a originou
5. Gera a migração de schema se o tipo é novo

**A inversão fundamental:** em programação tradicional, humanos escrevem a implementação e *esperam* que ela corresponda à intenção. Aqui, humanos escrevem a intenção e o sistema *garante* que a implementação corresponda — porque a especificação é formal o suficiente para ser verificável, mas de alto nível o suficiente para ser pensada em termos de produto, não de código.

**A DSL de especificação não é YAML.** O exemplo acima usa YAML como formato familiar, mas a representação real poderia ser qualquer coisa estruturada — um formulário, um grafo visual, uma interface conversacional com o agente. O que importa é que o vocabulário é restrito ao domínio (não à implementação), as restrições são explícitas (não implícitas), e a saída é *verificável por máquina* contra a implementação gerada.

Isso muda o papel do humano de **autor de código** para **autor de restrições**. O programador vira um *especificador* — alguém que pensa em domínio, invariantes e garantias, não em sintaxe, padrões e boilerplate.

### Camada 1: O Formato Nativo de IA

Isso é com o que o LLM realmente trabalha:

```scheme
(module user-service
  :provenance {req: "SPEC-2024-0042", author: "agent:claude-v4", created: "2026-02-09T14:00:00Z"}
  :version 7
  :parent-version 6
  :delta (added-fn get-user-by-id "support single-user lookup endpoint")

  (type User
    :invariants [(> (strlen name) 0) (matches email #/.+@.+\..+/)]
    (field id   UUID   :immutable :generated)
    (field name String :min-len 1 :max-len 200)
    (field email String :format :email :unique-within user-store))

  (effect-set db-read    [:reads  user-store])
  (effect-set db-write   [:writes user-store :reads user-store])
  (effect-set http-respond [:sends http-response])

  (fn get-user-by-id
    :provenance {req: "SPEC-2024-0042#section-3", test: ["T-101" "T-102" "T-103"]}
    :effects    [db-read http-respond]
    :total      true
    :latency-budget 50ms
    :called-by  [api-router/handle-request admin-panel/user-detail]

    (param id UUID
      :source http-path-param
      :validated-at boundary)

    (returns (union
      (ok   User   :http 200 :serialize :json)
      (err  :not-found {:id id} :http 404)
      (err  :invalid-id {:id id} :http 400)))

    ;; a lógica em si — note como é pequena em relação aos metadados
    (let [validated-id (validate-uuid id)]
      (match validated-id
        (err _)    (err :invalid-id {:id id})
        (ok  uuid) (match (query user-store {:id uuid})
                     (none)   (err :not-found {:id uuid})
                     (some u) (ok u)))))

  (fn create-user
    :provenance {req: "SPEC-2024-0041", test: ["T-090" "T-091"]}
    :effects    [db-write http-respond]
    :total      true
    :idempotency-key (hash (. input email))
    :latency-budget 200ms

    (param input {:name String :email String}
      :source http-body
      :content-type :json
      :validated-at boundary)

    (returns (union
      (ok   User   :http 201 :serialize :json)
      (err  :duplicate-email {:email (. input email)} :http 409)
      (err  :validation-failed (list ValidationError) :http 422)))

    (let [errors (validate-against User input)]
      (if (non-empty? errors)
        (err :validation-failed errors)
        (match (insert! user-store (build User input))
          (err :unique-violation) (err :duplicate-email {:email (. input email)})
          (ok user)               (ok user))))))
```

### Camada 2: A Projeção Humana

Isso é auto-gerado. Não é código-fonte — é uma renderização somente leitura, como o formato de armazenamento de um banco e a saída de uma consulta. Nenhum humano escreve isso; é projetado a partir da Camada 1 sempre que alguém precisa revisar.

```python
# --- Auto-projetado a partir de user-service v7 ---
# Spec: SPEC-2024-0042 | Tests: T-101, T-102, T-103

@effects(reads="user_store")
@budget(latency="50ms")
@total
def get_user_by_id(id: UUID) -> User | NotFound | InvalidId:
    match validate_uuid(id):
        case Err(_):
            return InvalidId(id=id)          # → 400
        case Ok(uuid):
            match user_store.get(id=uuid):
                case None:
                    return NotFound(id=uuid) # → 404
                case user:
                    return user              # → 200
```

### Camada 3: Como um LLM Editaria Isso

Um LLM não enviaria um diff de texto. Enviaria uma **operação semântica**:

```scheme
(edit user-service
  :operation add-field
  :target-type User
  :field (field role (enum :admin :member :guest) :default :member)
  :reason "SPEC-2024-0055: role-based access control"

  :cascading-impacts
    ;; a própria linguagem calcula estes impactos e pede confirmação:
    ;; - create-user precisa aceitar parâmetro opcional 'role'
    ;; - get-user-by-id agora retorna 'role'
    ;; - 3 testes precisam ser atualizados: T-090, T-091, T-101
    ;; - migração de schema do user-store necessária
    ;; - admin-panel/user-detail consome User — verificar compatibilidade

  :confirm true)
```

O sistema responde com:

```scheme
(edit-result
  :version 8
  :parent 7
  :changes-applied 4
  :changes-pending-review 2
  :migration-generated "M-0008-add-role-to-user"
  :tests-invalidated ["T-090" "T-091" "T-101"]
  :tests-auto-updated ["T-101"]    ;; trivial: formato de retorno mudou
  :tests-need-manual  ["T-090" "T-091"]  ;; comportamental: criação mudou
  :downstream-verified ["admin-panel/user-detail: compatible"]
  :downstream-warning  ["api-router: new field not yet exposed in list endpoint"])
```

### Justificativa das Decisões de Design

| Decisão de Design | Equivalente em Linguagens Humanas | Por que Ajuda LLMs |
|---|---|---|
| Spec declarativa de intenção (Camada 0) | Doc de requisitos + user stories | Entrada formal e verificável, sem ambiguidade de linguagem natural |
| AST em s-expression | blocos `if/else`, chaves | Sem ambiguidade de parsing, manipulação programática trivial |
| `:provenance` em cada nó | Git blame + links de Jira | Nunca precisa perguntar "por que isso existe?" — está inline |
| Declarações de `:effects` | Efeitos colaterais implícitos | Sabe exatamente o que uma função toca sem ler o corpo |
| Anotação `:total` | Esperança + testes | "Sem crashes, sem loops infinitos" verificado pelo compilador |
| Grafo `:called-by` | Grep por usos | Análise de impacto é instantânea, não uma busca |
| `:latency-budget` | SLA em algum documento | Restrições de performance estão no código, não no conhecimento tribal |
| Edição semântica vs diff textual | `sed` / find-replace | Declara intenção, o sistema calcula consequências |
| Análise de impacto em cascata | "Você lembrou de atualizar X?" | A linguagem diz o que quebrou — sem adivinhação |
| Tipos de retorno explícitos | Exceções lançadas de qualquer lugar | Todo resultado possível é enumerado — sem surpresas |

### Principal Conclusão

A proporção de **metadados para lógica** é algo como 3:1. Em linguagens humanas, é o inverso. Essa é a mudança fundamental — uma linguagem nativa para IA é *principalmente especificação, proveniência e restrições* com uma camada fina de computação. A lógica é a parte fácil. Saber **por quê**, **o que mais é afetado** e **que garantias devem valer** é onde LLMs gastam o orçamento de raciocínio.

Isso não é uma linguagem para escrever código. É uma linguagem para **manter sistemas**. E com a Camada 0, o ciclo se completa: humanos especificam intenção, a IA gera e mantém a implementação, e a verificação formal garante que ambos concordam. O código vira um artefato intermediário — importante para a máquina, invisível para o humano.

---

## Linguagens Existentes: Quão Perto Estamos?

Um ranking honesto de linguagens populares existentes, baseado no quanto cada uma já entrega nativamente do ideal.

### Nível 1: Mais Próximas da Visão

#### Lean 4

A coisa mais próxima que existe hoje. Tipos dependentes significam que especificações *são* o código — o tipo de uma função pode literalmente dizer "retorna uma lista ordenada cujo tamanho é igual ao da lista de entrada". As obrigações de prova forçam lógica total e verificada. O sistema de macros opera diretamente sobre a AST, o que se aproxima do conceito de "edição semântica". O framework de metaprogramação (monad `Elab` do Lean) permite consultar e manipular o ambiente de provas programaticamente.

**Peças faltantes:** sem rastreamento de efeitos, sem proveniência, sem consultas a grafos de dependência embutidas.

#### F* (F-Star)

Linguagem do Microsoft Research. Tem *exatamente* o sistema de efeitos descrito acima — você declara `ST` para estado, `IO` para I/O, `Pure` para computação pura, e o compilador impõe isso. Tipos refinados permitem codificar invariantes como `:min-len 1` diretamente no tipo. Ela pode extrair código verificado para OCaml, F# ou C. É a coisa mais próxima de "muita especificação com pouca lógica".

Quase ninguém usa fora de pesquisa, o que diz muito sobre o trade-off de amigabilidade para humanos.

#### Idris 2

Semelhante a Lean, mas com **teoria de tipos quantitativa** de primeira classe — o sistema de tipos rastreia *quantas vezes* um valor é usado. Isso é uma forma primitiva de rastreamento de recursos/efeitos. A elaborator reflection permite que programas inspecionem e modifiquem o próprio processo de type-checking, o que dialoga com a ideia de edição semântica.

### Nível 2: Acertam Várias Coisas

#### Rust

Não pelos motivos que as pessoas normalmente citam. O borrow checker é essencialmente um *sistema de efeitos verificado pelo compilador* para memória — rastreia aliasing, mutação e lifetime no nível de tipos. O sistema de traits com `Send`, `Sync`, `Unpin` é rastreamento de efeitos por outro nome. A convenção `Result<T, E>` com `match` exaustivo dá retornos explícitos. O `cargo` fornece um grafo real de dependências que pode ser consultado.

**Faltam:** especificações formais, proveniência, checagem de totalidade, e a sintaxe é complexa o suficiente para LLMs gastarem tokens com ginástica de lifetime.

#### Haskell

O clássico de várias dessas ideias. Pureza por padrão significa que efeitos são *sempre* explícitos (monad `IO`). O sistema de tipos é poderoso o bastante para codificar muitos invariantes. `hlint` e typed holes dão feedback estruturado.

**Faltam:** a história de efeitos é grosseira (apenas `IO` vs puro — sem granularidade sobre *que tipo* de I/O), sem proveniência, sem linguagem de especificação embutida, e o modelo de avaliação preguiçosa torna raciocinar sobre performance genuinamente difícil até para LLMs.

#### Dafny

Linguagem do Microsoft voltada a verificação. Tem `requires`, `ensures`, `invariant` como sintaxe de primeira classe — exatamente as anotações `:invariants` descritas acima. O verificador checa isso em tempo de compilação. Terminação de loops é verificada (`decreases` = totalidade). É praticamente "programação pesada em especificação".

**Fraqueza:** ecossistema pequeno, sem sistema de efeitos, e orientada a verificação de algoritmos mais do que construção de sistemas.

### Nível 3: Acertam Uma ou Duas Coisas

#### Elixir/Erlang (BEAM)

Escolha surpreendente, mas: as árvores de supervisão do OTP são essencialmente um **grafo declarativo de dependência e falhas**. O modelo de processos dá isolamento natural de efeitos — cada processo é um boundary. Pattern matching com tuplas tagueadas (`{:ok, result}` / `{:error, reason}`) é retorno de união explícita. `@spec` e `@doc` são metadados inline. Hot code reloading é um "patch semântico" primitivo.

**Faltam:** verificação formal, imposição de tipos em tempo de compilação (Dialyzer é opcional e incompleto), sem proveniência.

#### Scala 3

O trabalho em sistema de efeitos (Caprese/capture checking) está indo na direção certa. Union types, match types e opaque types dão especificações expressivas de retorno. Metaprogramação inline via `scala.quoted` opera em ASTs tipadas. Mas carrega um enorme pacote de complexidade JVM.

#### Ada/SPARK

O subset SPARK é formalmente verificável com contratos (`Pre`, `Post`, `Contract_Cases`). Usado em aeroespacial e defesa, onde "provar que não pode quebrar" é exigência real. Muito próximo ao conceito de `:total` + `:invariants`. Mas a linguagem é verbosa, o ecossistema é pequeno e não há rastreamento de efeitos além do que contratos expressam.

### O Padrão Desconfortável

| O Que LLMs Querem | Quem Tem | Por Que Não É Mainstream |
|---|---|---|
| Especificações formais como código | Lean, F*, Dafny | Curva de aprendizado íngreme para humanos |
| Rastreamento de efeitos | F*, Haskell, Rust (parcial) | Aumenta a carga de anotações |
| Checagem de totalidade | Lean, Idris, Agda | Rejeita muitos programas "úteis" |
| Manipulação rica de AST | Lean, Lisp/Racket, Elixir macros | Humanos acham macros confusas |
| Retornos exaustivos | Rust, Haskell, OCaml | Humanos acham `match` tedioso vs exceções |

Cada recurso existe em algum lugar. A razão de nenhuma linguagem combinar tudo é que **cada um adiciona carga cognitiva para humanos**. A história do design de linguagens mainstream é sobre *remover* as coisas que LLMs acham mais úteis, porque humanos as experimentam como fricção.

Essa é a tensão central: **a linguagem ideal para IA é a que humanos continuam rejeitando.**

---

## Adendo: Pensamentos Adicionais

### Primitivos extras que parecem especialmente úteis para LLMs

- **Serialização canônica e sem perda da AST** — Uma representação única, estável, determinística, diffável e hashável. Isso remove drift de formatter e torna caching semântico trivial.
- **Artefatos com prova acoplada** — O compilador emite certificados verificáveis por máquina, amarrados a specs e efeitos, permitindo confiança incremental sem rerodar o mundo.
- **Efeitos com escopo de capacidade** — Efeitos deveriam exigir concessões explícitas de capacidade no boundary de módulo (não apenas declarados em assinaturas). Isso dá à linguagem um modelo de permissões embutido.
- **Dualidade spec/teste** — Specs devem ser executáveis e testes devem ser deriváveis de specs. A fronteira entre os dois deve ser fina e programática.

### Modularização para LLMs

LLMs lidam melhor com monólitos do que humanos, mas **módulos ainda importam** como *limites semânticos*:

- **Escopo de efeitos**: capacidades são concedidas nos boundaries de módulo.
- **Propriedade e invariantes**: módulos definem quais invariantes de dados possuem e impõem.
- **Grafos de dependência**: a linguagem pode fazer cache e re-verificar unidades menores.
- **Recompilação parcial**: o impacto da mudança é menor quando as unidades são isoladas.

Em uma linguagem nativa para IA, modularização deve ser **orientada a restrições e capacidades**, não a arquivos. Você pode guardar tudo em um único arquivo, mas as *unidades* ainda devem ser explícitas.

### Observabilidade em runtime como primitivo da linguagem

Uma linguagem para LLMs deveria tratar **rastreamento estruturado** como algo de primeira classe:

- Cada efeito produz eventos de trace legíveis por máquina com vínculos causais.
- Edições podem ser validadas contra *deltas comportamentais*, não apenas diffs de tipo.
- A proveniência pode se estender ao runtime, permitindo anexar "por quê" ao "o que aconteceu".

### Enquadramento alternativo

Em vez de uma "linguagem", pense: **IR nativo de grafo + protocolo de edição semântica + DSL de projeção humana**. Texto vira uma view, não a fonte. A interface primária é um grafo semântico com restrições checadas, capacidades seguras e metadados com prova acoplada.
