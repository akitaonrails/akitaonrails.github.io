---
title: "[Primeiros Passos] Brincando de Rust + Ruby/FFI"
date: '2015-06-05T16:05:00-03:00'
slug: primeiros-passos-brincando-de-rust-ruby-ffi
tags:
- learning
- rust
draft: false
---

Estou nos meus primeiros dias estudando [Rust](http://www.rust-lang.org), a nova linguagem de sistema criado pela Mozilla. Essa linguagem está no meu radar faz vários meses, principalmente pelo suporte positivo de rubistas influentes como Steve Klabnik e Yehuda Katz.

Meu interesse é simples. Rust é uma linguagem pequena, mais próximo da categoria de C ou Objective-C do que GoLang, ou Elixir. Uma das coisas que sempre podemos fazer para "vitaminar" nosso querido Ruby é criar extensions em C. Mas se você já tentou fazer isso, sabe que nem é tão complicado com pequenas coisas à la "hello world", mas a coisa pode ficar exponencialmente complicada com muitas dependências e complexidades de toolchains. Então minha intenção em aprender Rust é ver se ela pode ser uma boa alternativa para criar extensions nativas performática facilmente consumíveis via [FFI](https://github.com/ffi/ffi/wiki/Why-use-FFI) (Foreign Function Interface).

Este artigo é apenas um pequeno exercício que vai além de um simples "hello world", que seria absolutamente trivial. Quero fazer uma pequena biblioteca capaz de ler um arquivo de tamanho arbitrário (portanto não pode carregar tudo em memória) e fazer um parse com regular expressions (algo que fazemos comumente).

Para isso estou usando como teste um arquivo de atores de filmes que baixei do [FTP do IMDB](http://www.imdb.com/interfaces), em particular o arquivo "actors.tgz" que abre como "actors.list". De cara vou dizer que é um dump bem porcaria, cujo texto sequer está em UTF-8. E para os efeitos deste artigo eu fiz uma versão menor com somente as primeira 10 mil linhas dele, que é um mísero arquivo de 515kb (comparado aos 938MB originais). Poderia ser qualquer arquivo, mas aleatoriamente escolhi esse.

Coloquei o projeto [no meu Github como exercício](https://github.com/akitaonrails/rust_ruby_exercise_1) (contribuições são bem vindas, pra melhorar o exemplo). Em Ruby, o código é simplesmente algo assim:

--- ruby
def find_actors(filename, skip_lines, target_movie)
  actors = []
  actor = nil
  File.foreach(filename).with_index do |line, line_num|
    next if line_num < 239
    line.encode!(line.encoding, 'binary', invalid: :replace, undef: :replace)
    if line.strip == ''
      actor = nil
      next
    end
    slices = line.split(/\t/)
    actor_buffer = slices.first
    movie        = slices.last
    if actor.nil? && !actor_buffer.nil? && actor_buffer != ''
      actor = actor_buffer
    end
    if !movie.nil? && movie.include?(target_movie)
      actors << actor unless actors.include?(actor)
    end
  end
  actors.join("\n")
end
```

Dá pra melhorar isso, mas é o suficiente para nossos propósitos. Rodando contra o arquivo pequeno de exemplo, o resultado vai ser:

```
> ruby actors.rb                                                                                                                               running pure Ruby version
145, Lyric
3, Utai
4 Real
4Shore
4Sure
4th Ba5e
4Tune
50 Cent
  0.050000   0.000000   0.050000 (  0.060104)
```

Se você baixar meu código do repositório, primeiro garanta que você tem o Rust instalado. Pra isso basta executar o seguinte:

```
curl -sSf https://static.rust-lang.org/rustup.sh | sh
```

Quando baixar meu código, vai ver que ele tem os arquivos Cargo.toml e Cargo.lock. Eles são semelhantes ao nosso Gemfile/Rakefile e Gemfile.lock. No Ruby controlamos nossas tarefas com Rake, as gems com Bundler (que lê as versões exatas do Gemfile.lock) e normalmente baixamos dependências que são Rubygems do Rubygems.org.

No caso do Rust, ele controla tanto tarefas (build, teste) e declaração de dependências via o arquivo Cargo.toml ([TOML](https://github.com/toml-lang/toml) sendo uma alternativa mais moderna a YAML). Em vez de Rake e Bundler temos [Cargo](http://doc.crates.io/guide.html). Em vez de Rubygems temos Crates. E em vez de Rubygems.org temos [Crates.io](https://crates.io).

Sendo uma linguagem que compila binários nativos, executamos <tt>cargo build</tt> mas se fizermos diretamente <tt>cargo test</tt> (para rodar testes incluídos no código) ou <tt>cargo run</tt> (para rodar o binário executável que fica no diretório <tt>bin/</tt>) ele vai automaticamente fazer a compilação do que precisa. No nosso caso, como estamos gerando uma biblioteca (que poderia ser um "*.so" para Linux, ou um "*.dylib" pra Mac ou "*.dll" para Windows), ele compila por padrão no diretório <tt>target/debug</tt> (que vai ser mais lento por ter símbolos pra debug e outros suportes). Para gerar a versão final, precisa executar <tt>cargo build --release</tt> e rodar como <tt>cargo run --release</tt> que vai gerar e linkar do binário em <tt>target/release</tt>.

Isso tudo dito, dê uma olhada nos arquivos Cargo.toml, src/main.rs, src/lib.rs. Os arquivos de Ruby estão misturados e são os <tt>actors.rb</tt>, <tt>imdb.rb</tt>. Pra executar a versão Ruby, lembre-se de também rodar <tt>gem install ffi</tt> primeiro (não estou usando Bundler nesse exercício).

## O Código Rust

Agora vamos olhar o código Rust equivalente ao Ruby anterior:

--- ruby
use std::io::prelude::*;
use std::io::BufReader;
use std::fs::File;

extern crate regex;
use regex::Regex;

pub fn find_actors(filename: String, skip_lines: usize, target_movie: String) -> String {
    let file = File::open(filename).unwrap();
    let mut reader = BufReader::new(&file).lines().skip(skip_lines);

    let mut actor = String::new();
    let mut actors : Vec<String> = Vec::new();
    let regex = Regex::new(r"^(.*?)\t+(.*?)$").unwrap();
    loop {
        let line = match reader.next() {
            Some(line) => match line {
                Ok(line) => line,
                Err(_)   => String::new(),
            },
            None => break,
        };

        match regex.captures(&line) {
            Some(captures) => {
                let actor_buffer = captures.at(1).unwrap();
                let movie        = captures.at(2).unwrap();

                if actor.is_empty() && !actor_buffer.is_empty() {
                    actor = actor_buffer.to_string();
                }

                if !movie.is_empty() && movie.contains(&target_movie) && !actors.contains(&actor) {
                    actors.push(actor.to_string());
                }
            },
            None => {
                actor = String::new();
            }
        };
    }
    actors.connect("\n")
}
```

Essa função usa coisas do próprio Rust que importamos dos módulos <tt>str::io</tt> e <tt>std::fs</tt> e tem a Crate regex externa. Também exportamos esse módulo com o nome de "imdb" que é o declaramos no Cargo.toml:

--- YAML
[package]
name = "actors"
version = "0.1.0"
authors = ["vagrant"]

[lib]
name = "imdb"
path = "src/lib.rs"
crate-type = ["rlib", "dylib"]

[dependencies]
regex = "0.1.8"
libc = "0.1.8"
```

Eu removi um trecho do arquivo que vou explicar na próxima seção, sobre FFI. Por enquanto vamos nos ater a esse código.

A sintaxe em si não deve ser tão assustadora num primeiro momento. As coisas estranhas vão exigir algum estudo.

* O Rust tem tipos e eles são declarados. O compilador usa inferência de tipos então não precisa declarar tudo o tempo todo como em Java. Ao contrário de Ruby, Rust não é orientado a "objetos". Ele tem structs e funções declaradas pra essas structs. Cada struct pode implementar funções declaradas em [Traits](https://doc.rust-lang.org/book/traits.html), que funcionam mais ou menos como Interfaces ou Protocolos (em Swift/Obj-C). Leia [outro artigo sobre Trait aqui](http://blog.rust-lang.org/2015/05/11/traits.html).

* Existe o conceito de [Generics](https://doc.rust-lang.org/book/generics.html). Por isso a sintaxe de <tt>Vec<String></tt> que declara um [Vetor](https://doc.rust-lang.org/book/vectors.html) com cada elemento sendo um String. Vetores são muito usados, então estude a respeito, mas é basicamente um Array de tamanho dinâmico (que pode receber novos elementos, possivelmente uma lista ligada).
	
* Falando em Strings, existe a struct [String](https://doc.rust-lang.org/book/strings.html) e a primitiva 'str'. Um <tt>"hello world"</tt> é um 'str' que pode virar um String se fizermos <tt>"hello world".to_string()</tt>.

* Em Rust, todos bindings de variáveis são imutáveis. Para torná-la mutável precisamos declarar explicitamente com <tt>let mut</tt> como no exemplo acima. Leia mais sobre [Variable Binding](https://doc.rust-lang.org/book/variable-bindings.html). Em particular, isso leva aos conceitos de [Ownership/Propriedade](https://doc.rust-lang.org/book/ownership.html) de uma variável, [Borrowing/Empréstimo](https://doc.rust-lang.org/book/references-and-borrowing.html) de variáveis entre escopos diferentes, como passar para uma função e [Lifetime/Tempo de Vida](https://doc.rust-lang.org/book/lifetimes.html) de uma variável. Vou adiantar que esse é um dos conceitos que pode levar mais tempo para se acostumar. 

Rust não tem garbage collector como em Ruby ou Java. Primeiro, porque ele usa primariamente o Stack em vez do Heap. Stack é uma pilha. Toda chamada de função empilha as variáveis que usa em seu espaço. Quando chama uma nova função ele empilha isso acima de si com suas variáveis. Quando a última função retorna, ele pode limpar as variáveis que alocou (que são sua "propriedade"). Se precisamos passar uma variável de uma função para a função seguinte podemos ou "copiar" o valor (normvalmente o que se faz com primitivas como i32 ou f64 - que são inteiros de 32bits ou floats de 64-bits, dentre outros tipos primitivos) ou podemos "mover a propriedade", por exemplo:

--- ruby
let x = "hello".to_string();
let y = x;
println!("{}", x); // vai dar pau, porque movemos a propriedade de "x" para o "y"
```

Ou "emprestar". Empréstimos são declarados com "&" ('e' comercial) e somente podemos emprestar uma única vez como em <tt>let y = &x</tt>. Sim, essa mecânica vai demorar mais pra se entender se você só conhece linguagens como Ruby ou Javascript. Se você aprendeu Objective-C antes do advento do [ARC](http://blog.caelum.com.br/gerenciamento-de-memoria-e-o-arc-no-objective-c/), já teve que parar pra pensar nesse tipo de [ciclo de vida de retain/copy/release](http://www.akitaonrails.com/2010/11/25/objective-c-entendendo-nsautoreleasepool).

Outros artigos [como este](http://nercury.github.io/rust/guide/2015/01/19/ownership.html) ou [este](http://arthurtw.github.io/2014/11/30/rust-borrow-lifetimes.html) podem ajudar. O objetivo dessa mecânica é para justamente evitar possibilidades de leaks de memória, ter desalocação determinística, usar a menor quantidade de memória quanto possível. Tecnicamente, não deveria haver leaks de memória óbvios em Rust. E não ter a lógica de Garbage Collection elimina uma das maiores complexidades que temos em linguagens mais modernas que contam com uma VM, o que facilita o uso do Rust para mais usos de sistema mais de baixo nível.

* Você vai ver várias chamadas a <tt>unwrap()</tt>, isso pode ser estranho. Então veja esta linha em específico:

--- ruby
let regex = Regex::new(r"^(.*?)\t+(.*?)$").unwrap()
```

Isso é só um jeito mais curto pra:

--- ruby
let regex = match Regex::new(r"^(.*?)\t+(.*?)$") {
    Ok(regex) => regex,
    Err(_) => panic!("invalid regex"),
};
```

O <tt>match</tt> é a avaliação de um [Pattern Matching](https://doc.rust-lang.org/book/patterns.html) sobre um tipo chamado core::result::Result que é a alternativa do Rust de evitar retornar códigos de erro (como em C) ou usar um sistema de exceptions (como em Ruby mesmo). Nesse caso a criação de uma struct de Regex pode dar certo ou errado. Se der certo teremos o resultado voltando como "Ok", se der errado voltará como "Err(e)" e podemos fazer alguma coisa com o erro ou parar tudo como no exemplo, chamando a macro "panic!". O método unwrap implementa exatamente essa lógica se não estamos interessados em tratar o erro.

Em conjunto com o conceito de Result, temos [Option Monads](http://hoverbear.org/2014/08/12/option-monads-in-rust/) (implementado como core::option::Option), também conhecidos como tipos "Maybe" que devolvem "Some" (algum valor) ou "None" (nenhum valor), que é a resposta do Rust pra não ter que lidar com Null. Em Ruby, como existe a classe NilClass, podemos criar ferramentas como [NullObjects](http://devblog.avdi.org/2011/05/30/null-objects-and-falsiness/) onde um "Maybe" devolve esse NullObject/None ou o valor em si, "Some".

Veja a biblioteca [Naught](https://github.com/avdi/naught) pra entender mais do conceito.

Em resumo isso significa que você vai ver muito códigos com "unwrap" e "match" lidando com "Ok/Err" ou "Some/None". Sendo honesto, ainda não estou tão seguro das melhores práticas de quando e como usar isso e definitivamente é um tópico que vou estudar mais.

Veja que tanto no <tt>reader.next()</tt>, que é pegando o próximo elemento o Iterador do Regex quanto o <tt>regex.captures()</tt> que faz o match da Regex contra o string da linha devolvem o tipo "Option" e usamos "match" para saber o que fazer. No primeiro caso, se não houver um próximo elemento no iterador, ele devolve "None" e sabemos que podemos sair (break) do loop. E no segundo caso, se a linha sendo processada não bater com a regex, ele devolve "None" e sabemos que acabou o bloco do ator corrente, então podemos zerá-la antes de começar o próximo ator.

* O resto do código depois do "captures()" é a mesma lógica que em Ruby, de checar linha do arquivo, dividir entre nome do ator e seus filmes, acumular o nome do último ator (porque no formato do arquivo um ator tem vários filmes, um em cada linha), e ir acumulando os nomes no Vetor/Array. No final simplemente pegamos todos os nomes e concatenamos com um "\n".

Este código não lida com alguns conceitos mais interessantes do Rust como [Threads](http://doc.rust-lang.org/book/dining-philosophers.html). Recomendo, no mínimo, ler toda a documentação oficial no site do Rust para entender esses e mais dos conceitos importantes.

## Exportando para consumo em FFI

A maioria dos exemplos que achamos primeiro usando o Google, são códigos simples. Estou usando direto a gem FFI em vez de usar a Fiddle, então saibam que existem [duas maneiras](http://blog.skylight.io/bending-the-curve-writing-safe-fast-native-gems-with-rust/).

Sem mais delongas, no mesmo arquivo <tt>src/lib.rs</tt> eu coloquei o seguinte:

--- ruby
extern crate libc;
use libc::c_char;
use std::ffi::{CString, CStr};

#[no_mangle]
pub extern "C" fn ffi_find_actors(filename_ptr: *const c_char, skip_lines: i32, target_movie_ptr: *const c_char) -> *const c_char {
    let filename = unsafe {
        CStr::from_ptr(filename_ptr)
    };
    let target_movie = unsafe {
        CStr::from_ptr(target_movie_ptr)
    };
    let result = find_actors(
        std::str::from_utf8(filename.to_bytes()).unwrap().to_string(),
        skip_lines as usize,
        std::str::from_utf8(target_movie.to_bytes()).unwrap().to_string()
        );
    CString::new(result).unwrap().as_ptr()
}
```

Ou seja, eu fiz uma nova função que consome a que analisamos antes. A que fizemos primeiro recebe structs String e devolve uma String, que são structs de Rust. Não entendi ainda como converter isso automaticamente para ser consumido externamente. Então essa função acima recebe de fora do Rust um ponteiro para uma lista de chars (que é o conceito original de uma "string"/"corrente"), pega o ponteiro, pega os bytes do local onde o ponteiro aponta, e cria uma 'str' UTF-8, e finalmente chama 'to_string()' pra gerar uma String de Rust.

Então ele pega o resultado, que é uma String, cria um CString (que vem do módulo "std::ffi"), ou seja, uma "String de C" e devolve o ponteiro para fora. Note que nos casos onde recebemos ponteiros, declaramos que é um bloco ["unsafe"](http://doc.rust-lang.org/book/unsafe.html).

A diretiva <tt>#[no_mangle]</tt> é para o compilador do Rust manter e não bagunçar o nome da função internamente. E <tt>pub extern</tt> é para declará-la disponível para ser usado publicamente e externamente.

Sinceramente, não sei se essa é a forma correta de se expôr uma função. Provalvemente de um jeito melhor e mais simples, mas ainda não encontrei. Se alguém souber como, não deixe de colocar nos comentários.

Então, do lado do Ruby, consumimos desta forma:

--- ruby
require 'ffi'

module RustWorld
  extend FFI::Library
  ffi_lib 'target/release/libimdb.so'
  attach_function :ffi_find_actors, [:string, :int, :string], :string
end
```

Note que estamos fazendo link com a versão de "release" gerado via <tt>cargo build --release</tt>. E então declaramos a assinatura da função que queremos usar.

Finalmente, podemos usar dentro do Ruby normalmente assim:

--- ruby
RustWorld.ffi_find_actors(filename, 239, target_movie)
```

## Comparação de Performance

Aqui vem uma pequena surpresa. Eu fiz esse código com uma versão em Ruby e outra em Rust, lendo e processando o mesmo arquivo, para obter o mesmo resultado final. O que tive foi o seguinte:

```
RUST=1 ruby actors.rb                                                                                                                         0.070000   0.010000   0.080000 (  0.079534)

ruby actors.rb                                                                                                                                0.060000   0.000000   0.060000 (  0.057541)
```

Ou seja, a versão Ruby é um pouco mais rápido que a versão em Rust, por uma margem de 27% (!!). Esses tempos foram marcados internamente dentro do Ruby (consumindo o Rust via FFI) com a biblioteca Benchmark.

E medindo diretamente, calculando o tempo com a função "time":

```
time cargo run --release                                                                                                                    cargo run --release  0.11s user 0.04s system 99% cpu 0.156 total

time ruby actors.rb                                                                                                                         ruby actors.rb  0.28s user 0.03s system 98% cpu 0.311 total
```

Aqui vemos o Ruby sendo mais lento. Como o arquivo de testes é muito pequeno, o tempo de subir o Ruby interfere na medição. Então vamos tentar com outro arquivo maior, com 52MB em vez de meros 515k:

```
time cargo run --release
cargo run --release  7.04s user 0.11s system 99% cpu 7.184 total

time ruby actors.rb
ruby actors.rb  6.69s user 0.08s system 99% cpu 6.808 total
```

Ou seja, o Ruby ainda é mais rápido que a versão Rust. E aqui podemos ficar confusos: o Rust, sendo muito mais próximo de C do que de Ruby, não deveria ser algumas ordens de grandeza mais rápido?

O código em si é muito simples. O primeiro ponto é que ele depende mais de I/O (ler o arquivo). E nisso o Ruby é muito rápido pois essa lógica é implementada internamente em C.

A segunda parte que eu imagino mais pesada é processar a Regex linha a linha. E nesse caso a engine de Regex do Ruby é bastante rápida, também internamente sendo feita em C - mais do que isso, ela é madura, tendo passado por inúmeras reescritas e refatoramentos nos últimos anos. E a biblioteca Regex do Rust eu imagino que, por ser ainda imatura, tem muito a ser otimizada e isso está segurando os números.

Outra coisa: é um processamento sequencial, linear, do arquivo. Se gastássemos mais tempo em particionar o arquivo e rodar pedaços em paralelo para maximizar o uso da máquina, imagino que o Rust talvez tivesse alguma vantagem, mas mesmo nesse caso usaríamos alguma coisa como a biblioteca [Grosser/Parallel](https://github.com/grosser/parallel) do Ruby, como [já expliquei em outro artigo](http://www.akitaonrails.com/2015/05/15/small-bites-brincando-de-crawlers-e-algumas-dicas-uteis#.VXHlGZ9Hlp8), pra conseguir também com Ruby usar todas as CPUs da máquina.

Na verdade, o problema não é o Rust ser "lento" mas subestimarmos o Ruby achando que ele sempre vai ser lento em tudo quando na verdade não é o caso. Faça a lição de casa antes de assumir que algo é lento ou rápido, você vai se surpreender em ver como Ruby é muito - e rápido - em diversos tipos de tarefas que à primeira vista parece que não. E não considerem que "Rust" é ruim por causa deste teste: é um caso de uso específico, que depende mais da forma como a biblioteca de Regex (possivelmente) amadureceu até este ponto.


**Obs 05/06/15:** Logo após publicar o post o camarada Jeffry DeGrande mandou um [Pull Request](https://github.com/akitaonrails/rust_ruby_exercise_1/pull/1) que troca a lenta crate "regex" pela "pcre" que, como seu nome diz, linka por baixo com a boa e velha biblioteca nativa "libpcre3" (Perl Compatible Regular Expression). Com isso os tempos ficam **Muito** melhores:

```
> RUST=1 ruby actors.rb
running Rust/FFI version
  1.600000   0.010000   1.610000 (  1.625171)

> ruby actors.rb
running pure Ruby version
  5.980000   0.050000   6.030000 (  6.046123)
```

Como eu suspeitava, a culpada era mesmo a biblioteca imatura de regex. Trocando pela pcre a implementação em Rust fica na menos que **3.7** vezes mais rápida que a em Ruby, que seria um tempo que deveríamos mesmo esperar de uma linguagem compilada!

## Conclusão

Rust atingiu sua versão 1.0 em Maio de 2015, ou seja, poucos dias atrás. Significa que muita coisa que você encontrar na Web, blogs, foruns, estarão defasados. Eu tive muita dificuldade em encontrar bons exemplos de código que funcionam na versão 1.0. Algumas structs mudaram de módulo. Alguns métodos estão com assinaturas diferentes e retornando coisas diferentes. A própria documentação oficial está com alguns erros ainda. Então tenha um pouco de paciência pois é a partir de agora com bons materiais vão começar a surgir.

Quem investiu tempo em aprender C/C++ (ou pelo menos Objective-C pré-ARC) não vai estranhar tanto assim o modelo de [gerenciamento de memória](http://pcwalton.github.io/blog/2013/03/18/an-overview-of-memory-management-in-rust/) do Rust. A idéia de ownership/borrowing não é tão diferente assim de um retain/release. Só que em vez de contar referências, você só pode "emprestar" uma vez. Além disso os valores são imutáveis, então é um modelo mais simples - embora mais difícil de se adaptar logo de cara. Especialmente importante é entender o modelo de [alocar no Stack](http://words.steveklabnik.com/a-new-introduction-to-rust) em vez de na Heap.

Também não há códigos de erro de retorno nem Exceptions. Aprender a lidar com o modelo de Pattern Matching em estruturas de Result/Option é outra mudança na forma de programar. Minha recomendação é abrir códigos fontes de terceiros como o próprio Cargo, para ver como são usados na prática.

Uma das coisas que não toquei neste artigo é seu excelente suporte a concorrência e paralelismo. Leia o exemplo do [Dining Philosopher](http://doc.rust-lang.org/book/dining-philosophers.html) e como o Rust resolve esse clássico problema. É bem simples mesmo entender.

Para quem acha que o mundo é orientado a objetos, Rust é mais uma linguagem que - embora tenha alguma semântica de objetos - não é orientado a objetos. Ele tem structs e funções associadas a structs. Entender o modelo de [Traits](http://blog.rust-lang.org/2015/05/11/traits.html) é crucial.

Rust é uma linguagem compilada, então toda vez que fizer algum código, existe o ciclo de compilar antes de executar, coisa que esquecemos como é no mundo Ruby ou Javascript. Mas a existência do Cargo facilita completamente esse fluxo e torna a experiência mil vezes mais agradável do que no mundo C, onde iríamos ter que mexer com Makefiles ou coisa similar. A organização padrão de projetos gerados pelo Cargo, empacotamentos em Crates e gerenciamento de dependências largamente inspirado no Bundler (que, aliás, todo mundo copia hoje em dia pois é o melhor modelo), ajuda muito ainda mais no começo.

Acompanhem o repositório no Github chamado [Awesome Rust](https://github.com/kud1ing/awesome-rust) que tem diversos links de projetos open source. Outro repositório é o [Rust Learning](https://github.com/ctjhoa/rust-learning) com links para várias documentações importantes para aprender. Existe já o rascunho de um ["guideline de estilo"](http://aturon.github.io/README.html).

Finalmente, Rust não é uma linguagem simples, definitivamente nem um pouco perto de algo como Ruby ou mesmo Elixir. Ele é mais baixo nível e vejo aplicações para coisas em nível de sistema. Ferramentas de linha de comando pra Linux. Bibliotecas para processamento de imagens, processamento numérico. Coisas que possam ser consumidas por outras linguagens ou aplicações, como o exemplo de expor funcionalidades como extensions nativas para Rubygems. Nesse sentido ele é mais seguro em termos de gerenciamento de memória, e com performance de processamento comparável a C++. Então é uma boa chance para programadores de linguagens de alto nível como Ruby ou Swift conseguirem descer para o nível de sistema sem precisar perder a cabeça com a complexidade de C/C++.
