---
title: "Nova linguagem voltada pra IA acabou de ser lançada: Bend 2"
slug: nova-linguagem-voltada-pra-ia-bend-2
date: '2026-09-19T12:00:00-03:00'
draft: false
translationKey: nova-linguagem-voltada-pra-ia-bend-2
description: "Bend 2, do pesquisador brasileiro Victor Taelin, chegou prometendo velocidade de C, paralelismo em GPU e provas formais que barram erros de IA. Eu testei portando dois projetos meus de Rust logo no lançamento. Potencial tem de sobra; stdlib e ecossistema ainda são de brinquedo."
tags:
- linguagens-de-programacao
- inteligencia-artificial
- rust
---

Anteontem, 17 de setembro, o pesquisador brasileiro Victor Taelin [anunciou no X](https://x.com/VictorTaelin/status/2100681226143092875) o lançamento do **Bend 2**, hospedado em [bend-lang.com](https://bend-lang.com/). O slogan é ambicioso: *"a fast language that blocks AI mistakes via proof — C speed · CUDA parallelism · Lean proofs · Python syntax"*.

Uma linguagem que promete rodar quase na velocidade de C, paralelizar sozinha em CPU e GPU, e ainda verificar com prova formal que o código que a IA escreveu faz o que você pediu. É muita promessa junta. Eu nunca tinha encostado no Bend 1, então isso aqui é experiência nova pra mim também: no dia do lançamento, apontei meus agentes pra dois projetos meus em Rust e mandei portar pra Bend 2. O resultado desse teste é a parte mais interessante deste artigo.

Antes de começar, o disclaimer: isso é uma review feita no **segundo dia de vida** da linguagem, baseada num experimento de um dia. Posso estar errado em várias das minhas assunções, e tá tudo bem. Os comentários estão aí embaixo, sintam-se livres pra corrigir e complementar.

## Quem é Victor Taelin

Antes de tudo, vale apresentar o autor. O [Victor Taelin](https://github.com/VictorTaelin) é um pesquisador brasileiro de programação funcional que passou mais de uma década obcecado por um problema específico: redução ótima de lambda cálculo, o algoritmo do Lamping de 1990, e depois as redes de interação do Lafont.

A [própria autobiografia dele](https://gist.github.com/VictorTaelin/77fd5a2a8a4a07e1da6157ebca3c7cf1) conta a trajetória: trabalhou na Ethereum Foundation, criou a linguagem de provas Formality, aposentou cedo com o ETH que acumulou de salário, voltou ao problema por conta própria, criou a HVM (Higher-Order Virtual Machine) e fundou a Higher Order Company, que levantou [US$ 4 milhões de seed](https://x.com/VictorTaelin/status/1743751536465903795) pra transformar a pesquisa em produto.

E aqui vai um ponto que pra mim importa muito: **eu acho ótimo um brasileiro fazendo trabalho sério de design de linguagem de programação**. A gente quase não tem pesquisa de ponta de verdade nesse país, muito menos em fundamentos de computação. Só por isso, o Taelin já tem o meu respeito e os meus parabéns pelo que construiu até aqui.

Então deixa registrado: as críticas deste artigo são todas construtivas, de alguém que torce pro Bend chegar mais longe, nada contra ele ou contra o projeto.

## De onde vem o Bend

A primeira versão do Bend apareceu em [maio de 2024](https://news.ycombinator.com/item?id=40390287), com sintaxe parecida com Python rodando em cima da HVM2, e a promessa de paralelismo automático: escreva código sequencial, o runtime distribui em todos os cores e até na GPU, sem thread, sem lock, sem mutex.

O lançamento foi viral. Quase mil pontos no Hacker News, mais de 20 mil estrelas no GitHub, vídeo do Fireship. E aí veio a realidade: a [thread do HN](https://news.ycombinator.com/item?id=40390287) foi impiedosa. Números de 24 bits, sem FFI, soma simples levando 42 minutos na máquina de um usuário, C++ em um core batendo a RTX 4090 do demo. O próprio Taelin admitiu na época que o codegen era ruim, e admitiu agora, na [thread do Bend 2](https://news.ycombinator.com/item?id=49746163), que o hype de 2024 não converteu em uso: *"there is also my own failure into making the language actually be used, rather than just a viral moment"*.

O Bend 2 é a resposta pra isso. E atenção: **é outra linguagem**. O README é explícito que programas de Bend 1 não carregam. Saiu a avaliação por grafos de interação (a HVM); entrou compilação nativa pra um único arquivo C, com clang pra CPU e Metal ou CUDA pra GPU. Os números passam a ser Nat, U32 e F32 de verdade, e o limite de memória pulou de 2 GB pra 8 TB, segundo o [anúncio japonês da gihyo](https://gihyo.jp/article/2026/09/bend-2). As redes de interação continuam na arquitetura, mas, nas palavras dele, *"inets live in it architecturally, but they don't exist at runtime"*.

## O que o Bend 2 promete

O pitch novo agora gira em torno de IA. A página do projeto vende uma visão *"post-AGI"*: humanos vão parar de escrever e ler código, então precisamos de um jeito sem ambiguidade de dizer pras IAs o que queremos. A solução do Bend é dividir o programa em dois arquivos:

- `LAWS.bend`: as invariantes do sistema, escritas pelo humano.
- `PROOF.bend`: as provas dessas leis, escritas pela IA.

O type checker do Bend é um verificador de provas, na linha do Lean e do Rocq, então `bend PROOF.bend` vira um portão de commit: se a prova não fecha, o código não entra. O demo do site é um joguinho com a lei *"vencer é impossível"* e um convite direto: *"Skeptical? Try breaking the game"*. O posicionamento é explícito: **LAWS.bend é um AGENTS.md com respaldo matemático**.

E como é a cara disso? A sintaxe lembra Python com tipos dependentes. Um programa completo com efeitos:

```python
import Base

# Performs effects on the CPU.
def main() -> IO(Unit):
  do IO<Unit>:
    name : String <- IO.try(String, IO.get_env("USER"))
    IO.print("Hello, " ++ name)
```

O paralelismo é divide-and-conquer: você quebra o trabalho em dois e o runtime espalha pelos cores que encontrar. E o operador `!` despacha a função pra GPU:

```python
# Computes 2^d in parallel: a tree of d levels, one leaf per unit.
def pow2(+d: Nat) -> U32:
  match d:
    case 0n:
      1
    case 1n+p:
      a b = pow2(p) pow2(p)
      (a + b : U32)

# Runs pow2 on the GPU, via `!`.
def main() -> IO(Unit):
  result = pow2!(20n)
  IO.print(U32.show(result))
```

Repara nas diferenças pras linguagens mainstream: não existe `if` (todo branch é um `match` em `True`/`False`), números naturais se casam por padrão de sucessor (`1n+p`), e o `+d` marca o parâmetro como **afim**, que é o que permite a linguagem viver sem garbage collector.

E as provas são defs comuns. A lei declara o que vale; a prova é indução com reescritas explícitas:

```python
# CLAIM: for every nat x, x + 0 equals x.
law add_zero:
  for x: Nat
  {Nat.add(x, 0n) == x : Nat}

# PROOF: induction on `x`, one rewrite (`%`) per step.
def add_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+xp:
      %add_zero(xp) : {1n+Nat.add(xp, 0n) == 1n+_ : Nat}
      {==}
```

Sem táticas, sem inferência, tudo anotado à mão. É verbose de propósito: é o preço do checker de 0,1s.

As outras promessas, todas com benchmark na página:

- **Roda rápido**: Game of Life num M4 Max em 7,8s em um core, contra 6,78s do C. Na GPU, 0,06s, ou 124x.
- **Verifica rápido**: 3.200 instanciações genéricas checadas em 0,38s, contra 19,2s do Lean e 6,04s do Rocq. A ideia é que o agente possa verificar a cada edição.
- **Paraleliza sozinho**: operador `!` manda a função pra GPU, sem thread, sem lock, sem kernel escrito à mão.
- **Sem garbage collector**: tipos afins, cada closure pode ser chamada no máximo uma vez, então a memória se resolve estaticamente.

Dois detalhes honestos que eu gostei de ver publicados: o próprio site avisa *"Bend is still evolving. Expect bugs"*, e o Taelin declarou que [o compilador é 99% escrito por IA](https://gihyo.jp/article/2026/09/bend-2), com só o kernel de checagem auditado por humanos. Coerente com a tese dele, pelo menos.

E já existe um plano de negócio: o [Bender](https://bend-lang.com/bender), um *"proving agent"* pago e proprietário, harness em cima dos modelos da Anthropic e da OpenAI hoje, com modelo dedicado e provador simbólico próprio no roadmap.

## Nem todo mundo engoliu os benchmarks

A recepção técnica teve ressalvas fortes, e elas importam. O gist do Nezk, ["Why the benchmarks of Bend's 2 typechecker are misleading (and possible problems with its type system)"](https://gist.github.com/Nezk/dda0511c492cf9bd673885f0341dca0e), aponta que o Bend pula elaboração, unificação e argumentos implícitos, que é justamente onde Lean e Rocq gastam tempo. Comparar os tempos assim seria comparar maçã com foguete.

Mais pesado: o post do Liam Powell, ["Bend 2 and the Vibe-Coding Trap"](https://blog.liampwll.com/posts/bend_vibe_coding/), nota que a expressão *"formal verification"* não aparece no site nem no código do Bend, refaz o demo do jogo em SPARK/Ada provando as mesmas duas propriedades automaticamente com GNATprove (*"all checks proved (12 checks)"*), sem as 442 linhas de prova manual, e conclui que o Bend está *"decades behind the state of the art"*.

São críticas de gente que entende do assunto e merecem resposta. Dito isso, a thread principal do Bend 2 no HN está com [mais de 600 pontos](https://news.ycombinator.com/item?id=49746163), então atenção o projeto tem.

## O que eu testei

Slogan não compila programa, então eu fui testar. Tenho um repositório [`bend-tests`](https://github.com/akitaonrails/bend-tests) onde apontei meus agentes pra portar projetos reais meus, escritos em Rust, pra Bend 2 (v2.0.16, pinada via mise; pra ter noção da maturidade, a linguagem teve nove releases em dez horas no GitHub, no dia seguinte ao lançamento). A documentação do experimento inteiro está em `docs/` lá dentro, e é dela que saem as próximas seções.

### Os três candidatos

Escolhi três projetos meus com perfis diferentes. Já aviso: nenhum dos três é um exemplo digno de Bend, e eu sei disso. Eu só peguei projetos pequenos e simples que eu tinha à mão, meio aleatórios, pra ver onde a linguagem quebra quando esfregam nela código comum do dia a dia.

| Projeto | Fit | Por quê |
|---|---|---|
| ghpending | ruim | 90% HTTP, JSON e formatação; uma única função pequena que vale provar |
| clock-tui | ruim | IO de terminal do começo ao fim; a aritmética é U32, impraticável de provar sem mathlib |
| ai-jail | pior | namespaces, mounts, seccomp, exec: quase tudo syscall |

O **ghpending** é minha CLI que lista issues e PRs abertos dos meus repositórios via GraphQL. O port cobre o comando principal, os filtros, a ordenação e o config.toml, com saída verificada **byte a byte idêntica** ao binário Rust nos casos testados contra a API real do GitHub (no meu config cheio, a única diferença é a fork view que o port deixou de fora).

O **tclock** é meu fork do clock-tui, relógio de terminal com timer e cronômetro. O port cobre relógio, timer e stopwatch, sem o sistema de widgets (que sozinho é 2.075 linhas do Rust), verificado dirigindo o binário via pty.

O **ai-jail**, meu sandbox pra agentes de IA (bubblewrap, Landlock, seccomp), nem virou código: a avaliação no papel já matou. Um port seria um programa em C com um `main` em Bend, o que anula o propósito. E olha que ele tinha a parte mais interessante pra provar: a lógica de política, tipo *"resolução de path nunca escapa da raiz"*. Mas não tem como embutir isso no binário Rust, então ficou pra uma próxima.

### Os números

Medi Rust e Bend lado a lado nos dois ports:

| | Rust | Bend |
|---|---|---|
| ghpending, linhas de código | 1.962 (sem testes) | 1.068 Bend + 93 leis/provas + 109 C + 25 JS |
| ghpending, dependências | 278 crates no lockfile | libcurl dinâmico, mais nada |
| ghpending, binário | 6,8 MB | 1,4 MB |
| ghpending, build limpo | 57s | 62s (0,1s de check; o resto é clang -O3 no C gerado) |
| ghpending, run com 43 repos | 3,9s wall / 16ms CPU | 2,1s wall / 28ms CPU |
| tclock, binário | 6,7 MB | 115 KB |
| tclock, idle 5s | 333ms CPU, 10 MB | 9ms CPU, 6,6 MB |

Lê essa tabela com cuidado, porque ela engana. As runs são bound de rede. O gap dos 43 repos é o Rust fazendo mais trabalho (fork lookups, query sequencial de viewer). O tclock do Bend redesenha frames inteiros, 26 KB/s contra 2 KB/s de diffs do ratatui. E a contagem menor de linhas é em parte porque o port faz menos. **Nenhum número aqui mostra o Bend mais rápido que o Rust no mesmo trabalho.**

### As provas na prática

Aqui mora a parte que o Rust não consegue imitar, então vale o detalhe. O design que funcionou foi **provar uma guarda isolada, deixando o algoritmo fora da prova**. O alocador de `--limit` do ghpending ficou em dois estágios: o primeiro é o algoritmo original em U32, não provado; o segundo é uma guarda em Nat que recebe a proposta do primeiro e corta qualquer excesso. As leis dizem que o orçamento é conservado e que nenhum repo recebe mais itens do que tem.

Essa é a guarda de verdade, do `alloc.bend` do port:

```python
# the lesser of b and w
def take(b: Nat, w: Nat) -> Nat:
  match b w:
    case 0n w0:
      0n
    case 1n+bp 0n:
      0n
    case 1n+bp 1n+wp:
      1n+take(bp, wp)

# what is left of b once w is taken from it
def rest(b: Nat, w: Nat) -> Nat:
  match b w:
    case 0n w0:
      0n
    case 1n+bp 0n:
      1n+bp
    case 1n+bp 1n+wp:
      rest(bp, wp)
```

> A lei vale mesmo se o estágio não provado propor lixo. A guarda não confia na aritmética que ela não consegue enxergar. Esse é o padrão que faz prova funcionar em código real.

O teste de mutação é a medida honesta do negócio. Injetei um off-by-one na guarda que vaza orçamento: as três saídas de exemplo ficaram idênticas, então uma suíte de testes daquele tamanho teria aprovado. O portão de prova rejeitou, com o termo exato que deixou de bater. É o Bend funcionando como prometido, no detalhe.

Agora o preço: 93 linhas de leis e provas pra garantir dois fatos simples sobre uma guarda de umas 30 linhas, começando do zero, porque a Base não traz nenhum lema de Nat (os únicos lemas aritméticos são `U32.add_comm` e `Word.add_comm`, que não ajudam em prova de Nat; tivemos que provar associatividade da soma na mão, e o Taelin reconheceu na thread: *"We need a mathlib!"*).

E o que ficou de fora da prova: a exatidão do algoritmo (precisaria de lemas de divisão, dias de trabalho), tudo que é U32 (por baixo é um vetor de 32 bits; provar aritmética nele sem biblioteca de lemas é impraticável) e literalmente todo o resto do programa: JSON, ordenação, renderização, IO. A superfície provável de um programa como o ghpending é uns poucos por cento do código.

O checker, por outro lado, é a melhor parte da ferramenta: 0,1s por rodada, erro apontando uma linha exata. Foram umas 30 rodadas de check no ghpending. Pra um agente iterando em loop, é exatamente o formato de feedback que ele precisa.

### O preço de sair pra C

Tudo que a Base não tem vira *foreign effect*: um def em Bend cujo corpo é uma função C (pro binário nativo) e uma gêmea em JS (pro runner de desenvolvimento). Os dois ports precisaram de **oito** efeitos escritos à mão:

- `Http.post`: porque não existe TLS, HTTP ou DNS (o demo oficial de HTTP hard-coda um IP).
- `Clock.unix` e `Clock.local`: porque `IO.now` é milissegundos desde o boot, sem hora de parede e sem fuso.
- `Tty.width`, `Tty.raw`, `Tty.key`, `Tty.size`: porque não existe stdin, raw mode nem consulta de terminal. Nada disso existe.
- `Clock.millis`: conveniência.

E o guia oficial é claro sobre o compromisso: **não há promessa de ABI**. Os nomes são internos do runtime e qualquer release pode renomeá-los, então *"rebuild your effects with every update"*. Numa linguagem com nove releases em dez horas, boa sorte. Detalhes que completam o quadro: não existe flag pra linkar biblioteca extra (o ghpending usa um wrapper de `$CC` que injeta `-lcurl`), tipos de handle customizados são WONTFIX, e incluir header de C no meio do arquivo funcionou por sorte, porque o runtime define nomes curtos tipo `lock` e `u32`.

Aqui encaixa o ponto conceitual: **no momento em que você cruza a fronteira do FFI, a prova ficou pra trás**. O verificador garante o que está dentro do modelo dele; o código C do outro lado é ato de fé. O Rust tem exatamente o mesmo problema com `unsafe`, onde as garantias do borrow checker valem até a borda do bloco e dentro dele a prova é sua. Se você quer garantia forte de ponta a ponta, a fronteira com C precisa ser mínima ou inexistente, e hoje em Bend ela é enorme pra qualquer programa real.

### Onde o Bend encaixa

Cruzando os três projetos com o que a linguagem oferece, o formato que ganha é **um núcleo puro pequeno, com spec afiada que testes cobrem mal, dentro de uma casca fina de efeitos**:

- alocadores, schedulers, rate limiters, lógica de quota
- regras determinísticas de jogo ou simulação, principalmente com rollback netcode (o único domínio onde a Base já tem o necessário: UDP, janela, áudio)
- máquinas de estado de consenso, ledger e matching engine
- parsers e codecs com lei de round-trip
- funções de merge de CRDT (comutativas, associativas, idempotentes)
- avaliadores de política de acesso (tipo o do ai-jail)

E o centro de design que os autores declaram: **a IA escreve o código e as provas, o humano escreve só o LAWS.bend, e o checker arbitra**. A descrição honesta mais curta que eu achei: uma *proof-carrying language for AI-written kernels*. Comparado com Lean ou Coq, que provam bem e entregam aplicação mal, o Bend é muito mais executável.

Uma coisa que me surpreendeu nos próprios números: de primeira eu assumiria que o nicho natural era pesquisa acadêmica em matemática. É o contrário. Pra matemática ele perde feio pra Lean 4, Coq e Isabelle: sem táticas, quase sem inferência, sem nada na escala da mathlib, sem reais, e com uma fundação (`Type : Type`, sem positivity check) que deixaria matemático de cabelo em pé. O que ele faz é **verificação de software**, mais perto de Dafny, F* ou Liquid Haskell do que de assistente de prova.

Duas limitações pesam até nesse nicho: o Bend emite um programa inteiro em vez de uma biblioteca, então o núcleo provado não pode ser linkado numa aplicação Rust hoje; e o custo de prova sem biblioteca de lemas é alto.

### O que mudaria o veredito

Registrado no `use-cases.md`, a lista do que me faria reavaliar:

- saída de biblioteca com ABI C, pra um núcleo provado viver dentro de um programa Rust ou C
- U64/I64 e F64
- uma biblioteca de lemas pra Nat, listas e ordem
- stdin, subprocessos, TLS e JSON na Base, ou um hub de pacotes que tenha isso
- builds nativos incrementais ou mais rápidos (62s pra 1.000 linhas hoje)
- uma ABI de efeitos que sobreviva a um release

## A realidade nua e crua

Agora a minha leitura, e você já sabe que eu não adoço.

**É uma linguagem recém-nascida.** Foi lançada anteontem. Fora o repo da própria linguagem, uma busca no GitHub acha hoje só algumas dezenas de spikes de 48 horas, quase todos com zero estrelas, nada que pareça projeto de verdade. As 21 mil estrelas do repo são quase todas herança do Bend 1, o repo foi renomeado. Os demos do site são todos de brinquedo: joguinho, Game of Life, pow2. São demonstrações de possibilidade, ainda sem uso real.

**A stdlib precisa crescer uma ordem de magnitude.** A força de uma linguagem mora na biblioteca padrão e no ecossistema. A única exceção histórica a essa regra foi o JavaScript, e aquilo lá é uma lata de vermes que não cabe neste artigo.

**Falta a killer app.** Toda linguagem que vingou tinha uma. Os meus testes apontam o nicho (núcleos puros provados, escritos por IA), mas alguém precisa transformar isso num app que o mundo queira usar. E aqui entra uma sugestão concreta, de graça: o Taelin podia escolher software open source popular que ele acha que ficaria melhor em Bend e reescrever. O Taelin é o exato oposto do mantenedor teimoso que torce o nariz pra IA: ele desenhou a linguagem inteira em volta de IA. Então que use isso a favor: pega um ripgrep, um jq, um sqlite da vida, reescreve com IA em Bend e publica a comparação lado a lado. Performance, linhas de código, e principalmente o que as provas garantem que o original não garante. Um before/after assim no mundo real vale mais que mil demos de joguinho. E de brinde, cada rewrite desses devolve o feedback mais valioso que existe: quais buracos da stdlib doeram de verdade num projeto real. Nada prioriza melhor o que implementar na próxima versão do que código de verdade esbarrando no que falta.

**Não espere webapp, mobile ou qualquer coisa do dia a dia tão cedo.** Talvez nem seja o propósito, e tudo bem também. Mas a promessa de *"velocidade de C"* corta pra outro lado: se o diferencial é performance, é mais fácil ir direto pro C, ainda mais hoje, com LLM escrevendo o código por você.

E aqui entra a minha situação concreta. Eu uso Rust pra caramba. **Odeio** a sintaxe, acho a ergonomia sofrível. Mas como quem escreve o código é o LLM e eu não preciso lidar com aquilo na mão, eu tolero, e em troca levo performance, garantias boas o suficiente e um ecossistema gigantesco de crates e frameworks. Ecossistema. É isso que decide.

> Eu não escolho linguagem pela elegância do paper. Escolho pelo tamanho do ecossistema que eu não preciso escrever na mão.

## O foco em prova e GPU, e a dúvida que fica

Uma coisa que me incomodou de leve o tempo inteiro: o Taelin claramente concentra tudo em dois pilares, provas e GPU, e eu não tinha certeza do que isso significava pro escopo da linguagem. Fui ler o que ele mesmo disse no [thread de pré-lançamento](https://x.com/VictorTaelin/status/2100374221671051472) e no HN, e a história é mais interessante do que eu assumi.

O pilar GPU é a herança de pesquisa. São dez anos de interaction nets e redução ótima, da HVM até aqui. Mas tem uma nuance que me surpreendeu: o Bend 2 conscientemente **trai** o idealismo acadêmico dele. Nas palavras do próprio: *"Bend2 is designed to be practical, not idealistic"*, mais perto de C do que de Haskell, porque ele não conseguiu fazer as interaction nets baterem as variantes lower-order em hardware comum. A GPU ficou como aplicação prática da obsessão, sem virar fetiche.

O pilar prova é mais velho que a era LLM: vem da época da Ethereum Foundation, de contrato imutável segurando milhões com bug, que gerou o Formality. A era LLM só deu pra obsessão antiga uma roupagem de mercado: *"the same capabilities that proved Navier-Stokes will now be writing real proofs that your own apps are correct"*.

E aí vem a minha hipótese que não sobreviveu à pesquisa. Eu estava pronto pra escrever que a stdlib mínima talvez fosse **de propósito**, que a ideia nunca foi programação geral, e que a minha crítica ao deserto de bibliotecas estaria mirando o alvo errado. Errado eu. As palavras dele são de ambição geral mesmo: *"the potential to become the most sensible choice for any vibe-coded project"*, *"Bend is made for the general public"*, e o time *"working hard to [...] make this language competitive with the mature alternatives in the market"*. A única magreza deliberada é a do checker, sem inferência, verbose de propósito. A Base pequena é dia dois de vida mesmo, tanto que ele próprio pede uma mathlib.

Isso faz a minha crítica à stdlib morder ainda **mais** forte: se o objetivo declarado é ser a escolha pra qualquer projeto vibe-coded, a comparação com ecossistemas maduros é o jogo que ele mesmo escolheu jogar.

E tem o ângulo do negócio, que ele admite com uma franqueza rara: *"we ship without a product"*. A linguagem é o substrato gratuito; o vendável é o [Bender](https://bend-lang.com/bender) e a infraestrutura de prova que vem atrás. Vale ficar de olho nesse espaço.

A dúvida que sobra, e essa eu registro sem resposta: a ambição generalista é o norte dele, mas a realidade que eu medi empurra o Bend pro nicho de núcleos verificados escritos por IA. Qual dos dois vence, só o tempo diz.

## O recado final

Se eu pudesse dar um conselho pro Taelin, seria esse: a parte difícil, a pesquisa, ele já fez. Agora vem a parte menos glamourosa, que é a que decide se linguagem vive ou morre: **marketing e construção de ecossistema**. Adoção, material de ensino, killer app, stdlib, mathlib. Ir muito além de toys e demos.

O exemplo que me vem à cabeça é o Zig. Anos de estrada e ainda briga por adoção, mesmo tendo uso prático imediato: o `zig cc` sozinho já é um substituto trivial pra compilar C, sem usar nada da linguagem. Tem app real usando, o [Ghostty](https://ghostty.org/) do Mitchell Hashimoto é o caso famoso. Mas o Andrew Kelley, o autor, é uma figura notoriamente difícil, da turma que torce o nariz pra IA, e claramente não entende de construção de ecossistema, e isso segura o Zig pra trás. Perfeccionismo técnico não combina com marketing e adoção.

O Bend 2 tem potencial de verdade. Checker instantâneo, provas pegando bug que teste não pega, paralelismo sem cerimônia. Mas potencial sozinho não significa nada se a adoção não vier. Eu torço pra vir, e torço duplo por ser um brasileiro liderando.

E uma provocação final, dessa vez pra você que leu até aqui. Stdlib rala, zero frameworks, zero bibliotecas de terceiros, nenhuma killer app: tudo isso deixa de ser problema quando você olha de outro ângulo e vira mapa de oportunidade. Cada coisa que falta no Bend é uma coisa que alguém vai ter que escrever, e quem chegar primeiro grava o nome na história do projeto. Se você sempre quis contribuir com open source de impacto mas nunca achou espaço nos projetos maduros, onde já existe de tudo, aqui tem um terreno vazio esperando.

São os meus dois centavos. Não levem tão a sério.
