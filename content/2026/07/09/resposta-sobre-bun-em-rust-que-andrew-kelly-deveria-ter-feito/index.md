---
title: "A Resposta sobre Bun em Rust que Andrew Kelly deveria ter feito"
slug: "resposta-sobre-bun-em-rust-que-andrew-kelly-deveria-ter-feito"
date: '2026-07-09T17:00:00-03:00'
draft: false
translationKey: bun-rust-response-andrew-kelly-should-have-written
tags:
  - zig
  - rust
  - bun
  - linguagens
  - ai
  - vibecoding
---

Eu li o post oficial do Jarred Sumner, ["Rewriting Bun in Rust"](https://bun.com/blog/bun-in-rust). E vou começar deixando meu viés claro: eu sou totalmente a favor da decisão do Bun de reescrever em Rust. Não porque Rust ganhou alguma guerra tribal contra Zig. Não é isso. Eu gosto muito de Zig. Mas, para o contexto do Bun, a decisão me parece compreensível, séria e bem executada.

O que eu mais gostei no post do Jarred foi o nível de detalhe. Ele não vendeu a fantasia idiota de escrever um prompt tipo "rewrite Bun in Rust" e esperar milagre. Pelo contrário. O que ele descreveu foi procedimento: `PORTING.md`, análise de lifetimes, `LIFETIMES.tsv`, trial run com três arquivos, workflows dinâmicos, revisores adversariais, correção de processo quando os agentes começaram a fazer besteira com `git stash`, depois compiler errors virando fila de trabalho, depois smoke tests, depois suíte inteira, depois CI multi-plataforma. Nada de vibe coding irresponsável. Engenharia usando IA como multiplicador.

Por isso fiquei decepcionado com a resposta do Andrew Kelley, ["My Thoughts on the Bun Rust Rewrite"](https://andrewkelley.me/post/my-thoughts-bun-rust-rewrite.html). Andrew é o criador do Zig. Eu queria ler o melhor argumento técnico possível defendendo Zig. Queria ver ele explicar onde Bun confundiu problema de linguagem com problema de arquitetura. Queria ver quais APIs Zig poderiam ter ajudado, quais invariantes deveriam ter sido endurecidas, onde `comptime`, allocators, arenas, `errdefer`, `DebugAllocator` e o novo desenho de I/O do Zig poderiam mudar a análise.

Em vez disso, uma parte grande do texto vira tentativa de assassinato de reputação. Comentário sobre personalidade, gestão, VC, cultura de startup, fofoca de bastidor. Pode até haver mágoa real ali. Não me interessa. Não ajuda tecnicamente.

Então resolvi fazer o exercício que eu esperava ter lido: colocar Claude Fable 5 e GPT 5.6 Sol como árbitros técnicos e pedir a eles a resposta que Andrew deveria ter escrito. Não a resposta gentil. Não a resposta de torcida. A resposta técnica.

Antes de passar a palavra, um off-topic. Se você, como eu, ficou olhando aquelas animações bonitas do GitHub no post do Bun e pensou "eu quero isso nos meus projetos", eu fui lá e fiz. O [`github-visualize`](https://github.com/akitaonrails/github-visualize) é um dashboard self-hosted que acompanha seus repositórios e reproduz a evolução dos commits, o heatmap por hora e a corrida do CI até ficar verde. Está tudo aberto no GitHub.

[![Timeline animada de commits no github-visualize](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/09/bun-zig-rust/github-visualize-commit-timeline.png)](https://github.com/akitaonrails/github-visualize)

Mas agora vamos separar apoio de prova. Uma coisa é dizer "eu teria feito algo parecido". Outra é dizer "era tecnicamente impossível continuar em Zig". Para responder isso, precisamos olhar para causas: quais bugs eram realmente bugs de linguagem, quais eram problemas de arquitetura, quais eram custos de ecossistema, e quais poderiam ter sido reduzidos com uma disciplina diferente dentro do próprio Zig.

É daí que começa a análise.

Antes, vocabulário mínimo. **Use-after-free** é usar memória depois de liberá-la. **Double-free** é liberar a mesma memória duas vezes. **Leak** é esquecer de liberar. **Ownership** é quem é responsável por destruir um recurso. **Lifetime** é por quanto tempo uma referência continua válida. **FFI** é a fronteira onde Rust ou Zig chamam C/C++ e perdem parte das garantias da linguagem. **GC root** é uma forma de dizer ao coletor de lixo: "não colete este objeto ainda". **Pinning** é segurar um buffer no lugar para ele não ser movido, destacado ou invalidado enquanto alguém ainda tem um ponteiro para ele. **Reentrância** é quando uma chamada volta para dentro do runtime antes da chamada anterior terminar.

## O que o Rust compra de verdade

A tese mais forte do post do Bun é simples: uma porcentagem grande dos bugs listados era use-after-free, double-free ou recurso esquecido em caminho de erro. Em Rust seguro, boa parte disso vira erro de compilador ou cleanup automático por `Drop`, desde que o recurso esteja modelado como valor dono. Rust não prova ausência geral de vazamentos: ciclos de `Rc`, `mem::forget`, `Box::leak` e `abort` ainda existem. Mas ele torna o vazamento acidental em caminho de erro muito mais difícil.

Isso está correto. E é um argumento forte.

O ponto forte do Rust aqui não é magia. É que ele obriga certas relações de posse e vida útil a aparecerem no tipo, em vez de ficarem espalhadas como convenção. Quando um valor tem dono, quando ele é movido, quando ele sai de escopo, quando um destrutor roda, isso deixa de ser só acordo entre programadores. O compilador participa.

No código atual do Bun, dá pra ver o padrão em miniatura. Um wrapper de bytes do MySQL guarda um valor do JavaScriptCore pinado, e o `Drop` desfaz o pin quando o objeto morre:

```rust
impl Drop for Bytes {
    fn drop(&mut self) {
        if !self.pinned.is_empty() {
            // `pinned` is rooted by the caller's MarkedArgumentBuffer for the
            // lifetime of this Value (see struct doc); the FFI itself is `safe fn`.
            JSC__JSValue__unpinArrayBuffer(self.pinned);
        }
        // self.slice dropped automatically
    }
}
```

Fonte: [`src/sql_jsc/mysql/MySQLValue.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/sql_jsc/mysql/MySQLValue.rs#L172-L180). O detalhe importante não é a chamada FFI em si. É o cleanup acompanhar o dono do valor.

Esse é o round que Rust ganha limpo. Em um projeto pequeno, disciplina basta. Em meio milhão de linhas, com callback reentrante, threadpool, libuv, sockets, TLS, JavaScriptCore, parser, bundler, package manager e API Node, disciplina vira custo recorrente.

Rust provavelmente reduziu o espaço de estados inválidos que o time precisava manter na cabeça. Vitória real.

Mas vitória real não significa vitória total.

## Zig não estava indefeso

O argumento mais fraco que se pode fazer contra Zig é fingir que ele é C com sintaxe nova. Não é. Zig tem mecanismos explícitos para tratar exatamente parte desses problemas.

O mais óbvio é [`errdefer`](https://ziglang.org/documentation/master/#errdefer), o mecanismo idiomático para cleanup em caminho de erro:

```zig
fn readThing(alloc: std.mem.Allocator, fail: bool) ![]u8 {
    const buf = try alloc.alloc(u8, 16);
    errdefer alloc.free(buf);

    if (fail) return error.Boom;
    return buf;
}

test "leak em caminho de erro" {
    const alloc = std.testing.allocator;
    try std.testing.expectError(error.Boom, readThing(alloc, true));
}
```

O [`std.testing.allocator` reporta vazamentos](https://ziglang.org/documentation/master/#Report-Memory-Leaks) em testes. O [`DebugAllocator`](https://github.com/ziglang/zig/blob/master/lib/std/heap/debug_allocator.zig) ajuda a encontrar double-free, leaks e vários usos inválidos de memória, inclusive tornando bugs mais barulhentos por não reutilizar endereços imediatamente. Isso não é a mesma coisa que prova estática de ausência de use-after-free. Não é borrow checker. Não cobre alocação feita dentro de C++, JavaScriptCore, BoringSSL ou qualquer outro allocator externo. Só pega o que passa por ele e só nos caminhos exercitados pelos testes.

O comentário do próprio allocator é preciso sobre o que ele entrega:

```zig
//! * Captures stack traces on allocation, free, and optionally resize.
//! * Double free detection, which prints all three traces (first alloc, first
//!   free, second free).
//! * Leak detection, with stack traces.
//! * Never reuses memory addresses, making it easier for Zig to detect branch
//!   on undefined values in case of dangling pointers.
```

Fonte: [`debug_allocator.zig`](https://github.com/ziglang/zig/blob/master/lib/std/heap/debug_allocator.zig#L3-L12). É ferramenta boa de teste e debug. Não é um teorema.

Mesmo assim, é errado dizer que Zig não tinha ferramenta nenhuma. Tinha.

A diferença é o momento do feedback. Em Rust, muita coisa aparece na compilação. Em Zig, muita coisa aparece em teste, fuzzing, allocator instrumentado, ASAN, revisão e estilo arquitetural. Em código crítico, isso importa. Feedback cedo é melhor.

Mas também importa dizer a frase inteira: se o problema era falta de invariantes claras no código Zig, a resposta poderia ter sido uma reescrita em Rust. Também poderia ter sido uma reestruturação agressiva do Zig.

Não sabemos qual teria sido mais barato. Só sabemos qual o Bun escolheu.

## `Drop` não é só açúcar, mas também não é milagre

O post do Bun acerta ao contrastar `defer` com `Drop`.

Em Zig, você escreve:

```zig
var resource = try Resource.init(allocator);
defer resource.deinit();
```

Isso é explícito. Está na sua cara. Não há fluxo de controle escondido. Essa é a filosofia do Zig: se algo acontece, você deve conseguir apontar para o lugar onde acontece.

Em Rust, se o tipo implementa `Drop`, o cleanup acompanha o dono:

```rust
impl Drop for Resource {
    fn drop(&mut self) {
        self.deinit();
    }
}
```

Isso não é apenas açúcar sintático. As [regras de destruição do Rust](https://doc.rust-lang.org/reference/destructors.html) ligam `Drop` a ownership, move semantics, ordem de destruição de campos e unwind de panic. Código seguro comum não consegue usar um valor depois de movido, nem dar double-drop no objeto como se ainda fosse dono dele. É uma garantia de linguagem.

Mas a garantia termina onde começa a semântica que o compilador não entende.

Se o `drop` chama uma função FFI para desproteger um valor do JavaScriptCore, o Rust garante que o destrutor vai rodar nos caminhos normais de escopo e drop, não em `abort`, `mem::forget`, leaks intencionais ou ciclos de `Rc`. Ele não prova que o ponteiro do JSC ainda é válido. Não prova que o GC não tem uma regra especial. Não prova que uma callback assíncrona de C não vai chamar de volta depois que você destruiu o wrapper.

O comentário no mesmo wrapper do Bun mostra o tamanho do contrato que ainda fica fora do compilador:

```rust
/// JS could `transfer()`/detach an earlier ArrayBuffer, or drop the last
/// JS reference to it and force GC, while we still hold a borrowed slice
/// into it. Pinning the backing `ArrayBuffer` makes it non-detachable for
/// the duration, and the caller's stack-scoped `MarkedArgumentBuffer`
/// roots the wrapper so GC can't sweep the cell. `Drop` unpins.
pub struct Bytes {
    pub slice: ZigStringSlice,
```

Fonte: [`MySQLValue.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/sql_jsc/mysql/MySQLValue.rs#L142-L154). Repara no tamanho do contrato. Ele não sumiu por ser Rust. Ficou documentado e encapsulado.

Essa é a fronteira real: Rust melhora o lado Rust do contrato. Ele não faz mágica dentro do heap do JavaScriptCore.

## A fronteira FFI continua sendo o inferno

Bun não é uma CLI simples. Bun é runtime JavaScript. Ele conversa com JavaScriptCore, uWebSockets, usockets, BoringSSL, SQLite, bibliotecas de compressão, APIs de sistema, handles assíncronos, buffers que podem ser destacados por JavaScript no meio de uma coerção, callbacks reentrantes e GC conservador.

É aí que o debate fica interessante.

Dentro de um bloco `unsafe`, Rust exige disciplina. O próprio [Rustonomicon sobre FFI](https://doc.rust-lang.org/nomicon/ffi.html) trata chamada estrangeira e ponteiro cru como obrigações do programador. Se o binding estiver mentindo, se a ownership real não bater com o tipo, se a callback estrangeira sobreviver ao objeto Rust, o compilador não salva.

O binding do Bun documenta as pré-condições na própria declaração:

```rust
unsafe extern "C" {
    /// By-value `JSValue`; C++ side null-checks and reads its own heap state.
    /// No caller-side preconditions → `safe fn`.
    safe fn JSC__JSValue__unpinArrayBuffer(v: JSValue);
    /// 0 = detached/null, 1 = FastTypedArray (GC-movable — caller should dupe;
    /// no unpin needed), 2 = pinned ArrayBuffer (caller must unpin).
}
```

Fonte: [`MySQLValue.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/sql_jsc/mysql/MySQLValue.rs#L859-L868). A linguagem permite declarar uma chamada estrangeira como segura. A obrigação de provar essa segurança continua sendo nossa.

Só que existe uma diferença importante: Rust permite encapsular esse `unsafe` atrás de APIs seguras. Você pode criar tipos de handle, `NonNull`, `PhantomData`, `Pin`, lifetimes marcando relação entre wrapper e runtime, wrappers que não implementam `Send` ou `Sync`, RAII para roots do GC, e uma superfície menor para auditoria. O objetivo não é zerar o perigo. É encolher o lugar onde o perigo mora.

O exemplo mais didático do post do Bun é o bug de `uv_close`. A primeira versão compilava, mas entregava um `Box` para libuv fechar assincronamente e deixava o `Box` cair no fim do escopo. Use-after-free seguido de double-free. A versão corrigida no código atual torna a transferência explícita:

```rust
spawn::WindowsStdioResult::Buffer(pipe) => {
    // `uv_close` is async — libuv keeps the raw handle pointer until the
    // next loop tick. Leak the Box so it outlives this scope; dropping it
    // here would be a use-after-free + double-free when the callback fires.
    Box::leak(pipe).close(Subprocess::on_pipe_close)
}
```

Fonte: [`js_bun_spawn_bindings.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/runtime/api/bun/js_bun_spawn_bindings.rs#L1359-L1366). Compilou em Rust e ainda estava errado na fronteira C/async. O processo de revisão pegou.

Aqui `leak` não significa "vazar para sempre". Significa tirar o `Box` do controle lexical do Rust e transferir a posse para o protocolo assíncrono do libuv, cuja callback depois reconstitui e libera a alocação.

Zig também permite escrever wrappers bons. A diferença é que ele não tem a fronteira `safe`/`unsafe` como parte da linguagem. Em Zig, tudo é explícito e revisável. Em Rust, uma parte maior do contrato pode virar tipo.

Para um time grande, isso pesa. Pesa ainda mais quando parte do código está sendo gerada por agentes.

## Arenas: sim, Bun já usava

Aqui o argumento pró-Zig precisa ser honesto. Arenas são idiomáticas e excelentes para certos problemas: parser, AST, ciclo de vida de uma requisição, dados que morrem juntos.

Mas o post do Bun não ignora arenas. Ele diz explicitamente que a abordagem existente já era uma mistura de lifetimes por arena, reference counting e "pay really close attention". Inclusive cita parser state e AST nodes como bons casos para arena.

O trecho do post é esse:

```text
Our current approach is a mix of:

- arena lifetimes, where the scope of when it's accessible is clear
  (parser state doesn't escape the calling function and so AST nodes
  are a good choice there)
- reference-counting
- pay really close attention
```

Fonte: [post oficial do Bun](https://bun.com/blog/bun-in-rust). O contra-argumento bom não é "use arena". Eles já usavam. O contra-argumento bom é perguntar se as fronteiras que sobraram poderiam ter sido endurecidas em Zig.

Então a resposta correta não é "vocês esqueceram arena". Eles não esqueceram.

A resposta correta é: arena resolve o caso em que o lifetime é claro. Ela não resolve sozinha handle de socket que fecha assincronamente, callback que roda depois, SSL session que precisa de `free` específico, root do GC, ponteiro que pode ser invalidado por reentrância, nem objeto que cruza várias camadas de API com ownership implícito.

Arena é uma ferramenta boa. Não é religião.

Se o Bun tivesse endurecido mais as fronteiras em Zig, talvez parte do benefício do rewrite pudesse ter vindo daí: APIs mais restritas, menos ponteiro cru atravessando subsistema, handles com ownership explícito, allocators instrumentados por padrão em teste, fuzzing direcionado para reentrância, wrappers que obrigam `deinit`, menos "presta atenção".

Mas isso também seria uma reescrita. Só que dentro de Zig.

## O borrow checker ajuda, mas não onde a internet acha

Muita gente fala de borrow checker como se ele fosse um detector universal de bug. Não é. Borrow checker é o pedaço do compilador Rust que impede certos empréstimos inválidos: dois donos mutáveis ao mesmo tempo, referência viva depois do dono morrer, uso depois de move. É muita coisa. Não é tudo.

Ele não entende o heap do JavaScriptCore. Não entende todas as regras de GC. Não entende automaticamente que uma callback de C pode disparar JS, que pode destacar um `ArrayBuffer`, que pode reentrar no runtime, que pode invalidar um ponteiro capturado antes. Essas invariantes precisam ser modeladas.

Mas quando são modeladas, Rust cobra.

Um exemplo pequeno no Bun: wrapper de `uSockets` que transforma ponteiro C em borrow Rust amarrado a `&mut self`:

```rust
impl PacketBuffer {
    pub fn get_peer(&mut self, index: c_int) -> &mut sockaddr_storage {
        // SAFETY: uSockets guarantees a non-null, properly-aligned peer pointer for
        // indices < packet count. The returned storage lives inside the C-owned packet
        // buffer, which is exclusively loaned to the data callback for its duration; no
        // other Rust or C path holds a reference to it. The reborrow of `&mut self`
        // ties the returned lifetime to this handle, so the borrow checker prevents
        // obtaining a second overlapping `&mut` via `get_peer`/`get_payload`.
        unsafe { &mut *us_udp_packet_buffer_peer(self, index) }
    }
}
```

Fonte: [`src/uws_sys/udp.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/uws_sys/udp.rs#L200-L209). O `unsafe` ainda existe. Mas, depois que o wrapper cria a referência, o borrow checker consegue impedir certos abusos no lado Rust.

E Bun não é só heap JavaScript. É parser, bundler, resolver de módulos, package manager, watcher de arquivos, protocolo HTTP, buffers, caches, tabelas, filas, estado de processo, glue code. Nessas partes, ownership local importa muito. `Vec`, `String`, slices, mapas, wrappers, enums, estados finitos: tudo isso fica mais fácil de refatorar com o compilador te batendo na mão.

O argumento honesto não é "borrow checker resolve Bun". É: o borrow checker reduz muitas classes de erro no lado Rust do Bun, e isso libera atenção humana para a parte que continua difícil.

É forte o suficiente. Não precisa exagerar.

## `comptime`: aqui Zig tem uma vantagem real

O melhor contra-exemplo técnico no próprio post do Bun é `Output.pretty`.

No Zig, a string de formato podia ser um parâmetro `comptime`. O próprio post do Bun coloca a diferença assim:

```rust
// Zig:
pub inline fn pretty(comptime fmt: string, args: anytype) void;
Output.pretty("<r>{f}<r>", .{hyperlink});

// Primeira API Rust:
pub fn pretty(payload: impl PrettyFmtInput);
Output::pretty(format_args!("<r>{}<r>", hyperlink));
```

Isso permitia processar marcadores de cor e formatação no literal conhecido em tempo de compilação, antes de misturar argumentos runtime. Ao portar para Rust, a primeira versão virou função. Resultado: o parser de tags mexeu em bytes que vinham dos argumentos. O issue [#30693](https://github.com/oven-sh/bun/issues/30693) mostra a regressão no port/canary envolvendo escape OSC 8 de hyperlink e `<r>`, não uma falha lançada em stable.

O bug era exatamente a contaminação entre template e argumento runtime:

```text
TerminalHyperlink::Display emits an OSC 8 hyperlink:

\x1b]8;;URL\x1b\ai\x1b]8;;\x1b\

The closing string terminator ST is the final two bytes `\x1b\`.

This is then wrapped via `Output::pretty(format_args!("<r>{}<r>", hyperlink))`.
The rendered string tail is `...\x1b\<r>`.
```

Fonte: [issue #30693](https://github.com/oven-sh/bun/issues/30693).

Depois eles corrigiram usando macro.

O código atual deixa a diferença explícita:

```rust
/// Write to stdout with `<tag>` color expansion.
/// Function form: performs the `<tag>` → ANSI rewrite at runtime on the rendered
/// payload (using stdout's colour state). Prefer the `pretty!` macro for literal
/// templates so the rewrite happens at compile time.
#[inline(always)]
pub fn pretty(payload: impl PrettyFmtInput) {
    let buf = payload.into_pretty_buf(enable_ansi_colors_stdout());
    write_bytes(Destination::Stdout, &buf);
}
```

E logo abaixo:

```rust
/// Compile-time `<tag>` → ANSI escape rewriter.
///
/// This must be a proc-macro because it consumes a string literal and emits
/// a new string literal usable as a `format_args!` template.
///
/// `pretty_fmt!("<red>{s}<r>", true)`  → `"\x1b[31m{}\x1b[0m"`
/// `pretty_fmt!("<red>{s}<r>", false)` → `"{}"`
pub use bun_core_macros::pretty_fmt;
```

Fonte: [`src/bun_core/output.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/bun_core/output.rs#L1765-L1805).

Isso demonstra uma força legítima do Zig: `comptime` é a própria linguagem rodando em tempo de compilação. Você não muda para um sistema paralelo. Em Rust, macros são poderosas e maduras, mas são outro mecanismo. Para alguns tipos de API, Zig é simplesmente mais direto.

Mas também não vamos transformar um bug de port em prova universal contra Rust. O problema ali não foi "Rust é frágil". Foi a tradução errada de uma API `comptime` para uma função runtime. O próprio post do Bun reconhece isso e corrige com macro.

A leitura correta é mais simples: Zig tinha uma garantia estrutural ali. A primeira versão Rust perdeu essa garantia. Isso custou uma regressão no port/canary.

Ponto para Zig.

## Tamanho de binário e performance: cuidado com causalidade barata

O post do Bun mostra números bons: binário menor, alguns benchmarks mais rápidos, startup melhor em certos cenários.

Os números do post:

```text
Bun v1.4.0 (canary) — Windows — 76 MB
Bun v1.3.14          — Windows — 94 MB
Bun v1.4.0 (canary) — Linux   — 70 MB
Bun v1.3.14          — Linux   — 88 MB

Bun.serve  — 169.6k → 177.7k — +4.8%
node:http  — 103.8k → 108.5k — +4.5%
fastify    —  91.5k →  95.9k — +4.8%
```

Fonte: [post oficial do Bun](https://bun.com/blog/bun-in-rust).

Eu acredito nos números. Não acredito em atribuição simples.

Reescrita muda muita coisa ao mesmo tempo. Muda layout de código, remove dívida, troca toolchain, mexe em LTO, muda como generics/comptime são instanciados, muda linker, muda código morto, muda ICU, muda organização interna. Quando tudo isso acontece junto, não dá para olhar o gráfico e dizer: "foi Rust".

Também não dá para dizer: "foi só rewrite".

O próprio post fala em combinação: Rust, mudanças em ICU, Identical Code Folding, LTO, codegen, limpeza acumulada. LTO é otimização no link final, quando o compilador enxerga mais do programa antes de gerar o binário. Identical Code Folding é o linker juntando funções idênticas em uma só. [Andrew tem razão](https://andrewkelley.me/post/my-thoughts-bun-rust-rewrite.html) em lembrar que Zig também tem suporte a LTO e que parte desses ganhos poderia ter sido buscada antes. Mas isso não prova que o resultado seria igual. Só prova que a causalidade é mista.

O `Cargo.toml` do Bun mostra que há engenharia de build explícita nessa história:

```toml
# Cargo's defaults (lto=false, codegen-units=16) leave us at ~105 crates × 16
# CGUs ≈ 1680 separately-optimized units with NO cross-crate inlining beyond
# `#[inline]`-annotated leaf fns. `lto = "fat"` + `codegen-units = 1` collapses
# the whole Rust crate graph into one LLVM module, matching Zig's shape.
[profile.release]
lto = "fat"
codegen-units = 1
debug = "line-tables-only"
strip = "none"
panic = "abort"
```

Fonte: [`Cargo.toml`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/Cargo.toml#L117-L135).

E tem configuração de LTO atravessando Rust e C++:

```ts
/**
 * Cross-language LTO: rustc emits LLVM bitcode (`-Clinker-plugin-lto`) into
 * `libbun_rust.a` so the final lld `-flto=thin` link sees through Rust↔C++
 * call edges. When false but `lto` is true, both halves still LTO
 * independently (C++ via `-flto=thin`, Rust via `[profile.release] lto =
 * "fat"`); only the cross-language inlining is lost.
 */
crossLangLto: boolean;
```

Fonte: [`scripts/build/config.ts`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/scripts/build/config.ts#L118-L129). Não é "Rust venceu". É linguagem, toolchain, linker, configuração e código trabalhando juntos.

Mesma coisa para stack usage e profundidade de parser. O post atribui melhoria ao Rust emitir melhor [`llvm.lifetime.start/end`](https://llvm.org/docs/LangRef.html#llvm-lifetime-start-intrinsic) e permitir reutilização de stack slots. Detalhe de codegen? Sim. Mas detalhe de codegen entregue pelo toolchain atual conta. O próprio Zig ainda tem uma [issue aberta sobre stack allocations que não acabam no fim do escopo](https://github.com/ziglang/zig/issues/23475). Para o usuário, pouco importa se a vantagem vem da linguagem pura, do compilador ou da maturidade do backend. Importa que funciona hoje.

O mecanismo descrito pelo Bun é este:

```text
Rust's LLVM IR codegen emits LLVM's llvm.lifetime.start and
llvm.lifetime.end intrinsics for stack variables when they are no longer
in use, which lets LLVM reuse stack space slots.
```

E o ticket do Zig diz, sem rodeio, que esse caso ainda não está resolvido:

```text
Block stack allocations do not disappear at end of block scope #23475
```

Também existe a solução arquitetural: parser iterativo com stack explícita na heap. Funciona em Zig e Rust. Mas é outro trabalho.

Leitura honesta: os números favorecem a versão Rust do Bun naquele experimento. Eles não provam superioridade geral de linguagem.

## Miri, crates e o mundo real

Há vantagens de Rust que não têm equivalente direto em Zig hoje.

Crates é a óbvia. O ecossistema Rust é grande, maduro e prático. Para um projeto do tamanho do Bun, biblioteca boa na prateleira vale engenharia real. Zig ainda está amadurecendo nesse ponto.

[`Miri`](https://github.com/rust-lang/miri) também é vantagem real. Ele detecta classes de comportamento indefinido em código Rust executado: out-of-bounds, use-after-free, dados não inicializados, problemas de alinhamento, data races em certos casos. O próprio projeto documenta os limites: não é prova formal, avalia as execuções que você fornece e tem suporte restrito para FFI e APIs de plataforma. Não substitui teste. Mas para validar abstrações `unsafe` isoladas, é uma ferramenta que Zig não tem do mesmo jeito.

Bun não só cita Miri no abstrato. Ele está no toolchain:

```toml
[toolchain]
channel = "nightly-2026-05-06"
components = ["rust-src", "rustfmt", "clippy", "miri", "llvm-tools"]
```

Fonte: [`rust-toolchain.toml`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/rust-toolchain.toml#L1-L24).

E tem teste interno explicando exatamente o uso:

```rust
// Run under Miri (`bun run rust:miri -p bun_ptr`): every path here walks raw
// pointers through `Box::into_raw` / `heap::take`, so Tree Borrows is what
// proves the ref/deref/destructor handoff does not alias or use-after-free.
```

Fonte: [`src/ptr/ref_count.rs`](https://github.com/oven-sh/bun/blob/fc865b398e51de8a95ddde4bca36408b26d40884/src/ptr/ref_count.rs#L1313-L1315). Não prova o programa inteiro. Exercita uma abstração perigosa sob um modelo feito para detectar comportamento indefinido nesses caminhos executados.

Há também contratação, tooling, documentação, IDE, cultura de revisão, CI, exemplos, gente no mercado. Isso não é detalhe político. É engenharia. Linguagem existe dentro de ecossistema.

Se o Bun fosse um projeto menor, com um time menor, menos pressão e menos superfície Node-compatible, talvez eu desse outro peso para isso. Mas Bun virou runtime usado por milhões de downloads mensais. A margem para "vamos manter disciplina perfeita" diminui.

## Async: Zig talvez tenha uma resposta melhor, mas ainda não é o presente do Bun

Zig removeu async/await antigo e está [redesenhando I/O em torno de `std.Io`](https://kristoff.it/blog/zig-new-async-io/), passado pelo chamador de modo parecido com `Allocator`. A ideia é boa: evitar o function coloring clássico, deixar a função menos acoplada a blocking, threaded ou event-driven, e tratar I/O como capacidade explícita.

O formato proposto é assim:

```zig
const std = @import("std");
const Io = std.Io;

fn saveData(io: Io, data: []const u8) !void {
    const file = try Io.Dir.cwd().createFile(io, "save.txt", .{});
    defer file.close(io);

    try file.writeAll(io, data);

    const out: Io.File = .stdout();
    try out.writeAll(io, "save complete");
}
```

Fonte: [Kristoff sobre o novo async I/O do Zig](https://kristoff.it/blog/zig-new-async-io/). O `io` é uma capacidade passada explicitamente, como `Allocator`.

Eu gosto muito dessa direção.

Mas ela ainda está em transição. A [issue de acompanhamento](https://github.com/ziglang/zig/issues/23446) continua aberta: há protótipo, roadmap, discussão, partes entrando aos poucos. Não é uma base estável sobre a qual o Bun pudesse apostar hoje sem custo.

Então o argumento aqui não pode ser "Zig já resolveu". A formulação correta é: Zig está caminhando para um desenho de async/I/O que pode ser mais limpo em alguns aspectos do que o modelo colorido tradicional. Mas Bun precisava tomar decisão com o que existe agora, não com o que promete existir depois.

Isso é sempre cruel com linguagens jovens. Mas é real.

## O processo do rewrite importa mais que a linguagem

O melhor do post do Jarred não é Rust. É método.

O loop mental do post é literalmente isso:

```js
// Pseudocode, not real code:
let task;
while ((task = todoList.pop())) {
  const result = task();
  const feedback = await Promise.all([review(result), review(result)]);
  await apply(feedback, result);
}
```

Depois, compiler errors viraram fila:

```text
~16,000 compiler errors left

error: deref *mut EventLoop before field access
error[E0034]: multiple applicable items in scope
error: event_loop/EventLoopTimer.rs: port Timespec::ns from bun.zig
```

E o ciclo por crate era explícito:

```text
- For each crate, run cargo check, group the output by file and save the errors to a file
- Fix all the compiler errors within that crate
- 2 adversarial reviewers for the crate's changes
- 1 fixer applies the fixes
```

Fonte: [post oficial do Bun](https://bun.com/blog/bun-in-rust).

Ele não mandou Claude reescrever um runtime inteiro e foi dormir. Ele montou loops. Separou implementador de revisor. Usou contexto diferente para revisão adversarial. Fez trial run. Corrigiu o workflow quando os agentes começaram a se atropelar. Proibiu comandos perigosos. Dividiu worktrees. Transformou compiler errors em fila. Rodou a mesma suíte TypeScript porque a suíte não dependia da linguagem do runtime. Usou CI multi-plataforma como árbitro.

Essa é a parte que todo mundo deveria estudar.

O modelo não substituiu engenharia. O modelo executou trabalho dentro de um processo de engenharia. Quando o processo estava ruim, o resultado ficava ruim. Quando o processo melhorava, o resultado melhorava.

É o detalhe que a discussão tribal ignora. A história não é "Claude reescreveu Bun". A história é "um engenheiro transformou uma migração gigante em vários loops verificáveis e usou Claude para acelerar cada loop".

Muito mais interessante.

## Então Zig falhou?

Não.

Zig não falhou por Bun ter escolhido Rust. Rust também não virou resposta universal porque Bun escolheu Rust.

O que a evidência pública mostra é mais chato: aquele código, naquele momento, estava caro demais para evoluir com o nível de confiança que o time queria. Rust comprou previsibilidade. Comprou feedback de compilador. Comprou ecossistema. Comprou um safe/unsafe boundary explícito. Comprou tooling. Comprou um ambiente em que agentes de IA conseguem bater em compiler errors e avançar mecanicamente.

Basta para justificar a decisão.

Mas não é suficiente para provar que Zig era tecnicamente inviável para Bun. Muitos problemas citados parecem também problemas de fronteira: ownership implícito, APIs permissivas demais, alocação sem contrato visível, recursos que cruzam camadas sem tipo carregando o dono, testes que talvez não capturavam invariantes difíceis, e o custo humano de revisar tudo isso.

Essas coisas poderiam ter sido atacadas em Zig. Talvez uma reestruturação agressiva do Zig tivesse resolvido muita coisa. Talvez não. Talvez custasse mais que o port. Talvez custasse menos, mas entregasse menos confiança. Não temos o contrafactual.

E é exatamente por isso que a conclusão precisa ser calibrada.

Eu apoio a decisão do Jarred como decisão de produto e engenharia. O post dele é um dos relatos mais úteis que já vi sobre rewrite grande assistido por IA. Mas gostar da decisão não me obriga a fingir que ela era a única conclusão técnica possível.

E tem um disclaimer importante. A [Anthropic comprou o Bun em dezembro de 2025](https://bun.com/blog/bun-in-rust), e o próprio Jarred abre o post dizendo que ele e o time do Bun agora trabalham lá. A Anthropic vende Claude Code. Jarred tinha todo o incentivo institucional para usar o máximo possível de Claude e transformar essa reescrita numa demonstração pública do produto do novo empregador. Isso não prova má-fé, nem invalida um resultado técnico. Mas adiciona viés à decisão e à forma como o caso é apresentado. Ignorar esse conflito de incentivos seria tão ingênuo quanto ignorar a mágoa do Andrew com a saída do Bun de Zig.

A melhor leitura é menos dramática: Bun escolheu pagar um custo grande agora para reduzir custos recorrentes de manutenção depois. Rust foi uma escolha defensável, talvez ótima para aquele time naquele momento. Zig continuou sendo uma linguagem excelente, mas teria exigido outro tipo de reengenharia: mais invariantes explícitas, menos ownership informal, mais ferramentas ligadas por padrão, mais fronteiras endurecidas.

Andrew poderia ter escrito isso. Poderia ter defendido Zig no campo técnico. Poderia ter dito: "Rust comprou algumas garantias reais, mas boa parte do problema era arquitetura e processo; aqui está como Zig poderia ter atacado as mesmas causas." Esse teria sido um post útil.

Não precisamos declarar vencedor. Linguagem não substitui arquitetura. Ela só muda quais erros ficam baratos de detectar e quais continuam dependendo de disciplina humana.

Bun escolheu trocar uma parte dessa disciplina por compilador. Eu acho uma boa aposta.

Não acho que isso enterre Zig.
