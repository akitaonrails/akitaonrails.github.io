---
title: "Tentando igualar o Fast Blank em C usando Crystal"
date: '2016-07-06T17:10:00-03:00'
slug: tentando-igualar-fast-blank-em-c-usando-crystal
translationKey: fast-blank-crystal-vs-c
aliases:
- /2016/07/06/trying-to-match-c-based-fast-blank-with-crystal/
tags:
- crystal
- traduzido
draft: false
---

Na minha visão, Crystal pode se tornar a solução ideal para deixar nossas queridas gems de Ruby mais rápidas. Até agora, temos usado extensões em C para acelerar código CPU-bound em Ruby. Nokogiri, por exemplo, é um wrapper que oferece uma API agradável em cima da libxml, que é uma biblioteca enorme escrita em C.

Mas existem várias oportunidades para acelerar aplicações Rails também. Por exemplo, acabamos de ver o lançamento da [gem "faster_path"](https://github.com/danielpclark/faster_path), dessa vez escrita em Rust e conectada via FFI (Foreign Function Interface). O autor afirma que o Sprockets precisa calcular muitos paths e fazer essa biblioteca, compilada nativamente e otimizada com Rust, trouxe uma melhora enorme na tarefa do asset pipeline.

Sam Saffron, do Discourse, também construiu uma gem bem pequena chamada ["fast_blank"](https://github.com/SamSaffron/fast_blank), uma minúscula biblioteca em C que reimplementa o método `String#blank?` do ActiveSupport para ser até 9x mais rápido. Como o Rails digere volumes de strings, checando se elas são "blank" o tempo todo, isso adiciona alguma performance (depende da sua aplicação, claro).

O Santo Graal da performance em nível nativo é conseguir escrever código próximo de Ruby ao invés de ter que mexer em C de baixo nível ou enfrentar a curva de aprendizado alta de uma linguagem como Rust. Mais que isso, eu gostaria de evitar usar FFI. Eu não sou um expert em FFI, mas lembro de ter entendido que ele adiciona overhead nas bindings.

Aliás, é importante deixar claro logo de cara: eu estou bem longe de ser um expert em C. Tenho pouquíssima experiência lidando com desenvolvimento hardcore em C. O que é justamente o motivo de essa possibilidade de escrever em Crystal ser tão atraente para mim. Então, se você é um expert em C e percebe alguma bobagem que estou falando, por favor me avise nos comentários abaixo.

Meu exercício é reescrever a gem Fast Blank, originalmente em C, em Crystal, adicioná-la na mesma gem para compilar usando Crystal se estiver disponível ou cair no fallback de C, e fazer os specs passarem para que seja uma transição transparente para o usuário.

Para conseguir isso eu tive que:

* Estender o `extconf.rb` da gem para gerar Makefiles diferentes (para C e Crystal) capazes de compilar em OS X ou Linux (Ubuntu pelo menos) - OK
* Fazer os specs passarem na versão Crystal - Quase (está ok para a maior parte, exceto um edge case)
* Fazer a performance ser mais rápida que Ruby e próxima de C - Ainda não tanto (no OS X a performance é bem boa, mas no Ubuntu não escala tão bem para strings grandes)

Você pode conferir os resultados até agora no [meu fork no Github](https://github.com/akitaonrails/fast_blank/tree/crystal_version) e acompanhar a [discussão do Pull Request também](https://github.com/SamSaffron/fast_blank/pull/20).

### Comparando C e Crystal

Só para começar, vamos ver um trecho da versão original em C do Sam:

```C
static VALUE
rb_str_blank(VALUE str)
{
  rb_encoding *enc;
  char *s, *e;

  enc = STR_ENC_GET(str);
  s = RSTRING_PTR(str);
  if (!s || RSTRING_LEN(str) == 0) return Qtrue;

  e = RSTRING_END(str);
  while (s < e) {
    int n;
    unsigned int cc = rb_enc_codepoint_len(s, e, &n, enc);

    if (!rb_isspace(cc) && cc != 0) return Qfalse;
    s += n;
  }
  return Qtrue;
}
```

Sim, bem assustador, eu sei. Agora vamos ver a versão em Crystal:

```ruby
struct Char
  ...
  # mesma forma como o C Ruby implementa
  def is_blank
    self == ' ' || ('\t' <= self <= '\r')
  end
end

class String
  ...
  def blank?
    return true if self.nil? || self.size == 0
    each_char { |char| return false if !char.is_blank }
    return true
  end
end
```

Caraca! Se você é rubyista, aposto que entende 100% do snippet acima. Não é "exatamente" a mesma coisa (porque os specs ainda não estão passando completamente), mas chega bem perto.

### A busca por um Makefile para Crystal

Pesquisei vários [repositórios experimentais no Github](https://github.com/akitaonrails/ruby_ext_in_crystal_math) e Gists por aí. Mas não achei nenhum que tivesse tudo, então decidi adaptar o que encontrei até chegar a essa versão:

Obs: de novo, eu não sou expert em C. Se você tem experiência com Makefiles, sei que esse aqui dá para refatorar para algo mais bonito. Me avise nos comentários.

```C
ifeq "$(PLATFORM)" ""
PLATFORM := $(shell uname)
endif

ifeq "$(PLATFORM)" "Linux"
UNAME = "$(shell llvm-config --host-target)"
CRYSTAL_BIN = $(shell readlink -f `which crystal`)
LIBRARY_PATH = $(shell dirname $(CRYSTAL_BIN))/../embedded/lib
LIBCRYSTAL = $(shell dirname $(CRYSTAL_BIN) )/../src/ext/libcrystal.a
LIBRUBY = $(shell ruby -e "puts RbConfig::CONFIG['libdir']")
LIBS = -lpcre -lgc -lpthread -levent -lrt -ldl
LDFLAGS = -rdynamic

install: all

all: fast_blank.so

fast_blank.so: fast_blank.o
  $(CC) -shared $^ -o $@ $(LIBCRYSTAL) $(LDFLAGS) $(LIBS) -L$(LIBRARY_PATH) -L$(LIBRUBY)

fast_blank.o: ../../../../ext/src/fast_blank.cr
  crystal build --cross-compile --release --target $(UNAME) $<

.PHONY: clean
clean:
  rm -f bc_flags
  rm -f *.o
  rm -f *.so
endif

ifeq "$(PLATFORM)" "Darwin"
CRYSTAL_FLAGS = -dynamic -bundle -Wl,-undefined,dynamic_lookup

install: all

all: fast_blank.bundle

fast_blank.bundle: ../../../../ext/src/fast_blank.cr
  crystal $^ --release --link-flags "$(CRYSTAL_FLAGS)" -o $@

clean:
  rm -f *.log
  rm -f *.o
  rm -f *.bundle
endif
```

A maioria das pessoas usando Crystal está em OS X, incluindo os criadores de Crystal. LLVM está sob o guarda-chuva da Apple, e todo o ecossistema deles depende muito de LLVM. Eles passaram muitos anos migrando primeiro o front-end de C, depois o back-end de C, do GCC padrão da GNU para o Clang. E conseguiram fazer tanto Objective-C quanto Swift compilarem para o IR do LLVM, e é por isso que ambos conseguem interagir nativamente.

Depois, eles melhoraram o suporte ao backend ARM, e é assim que eles conseguem ter um "Simulador" iOS inteiro (não um emulador lento como cachorro tipo o de Android), onde os apps iOS são compilados nativamente para rodar em processador Intel x86_64 durante o desenvolvimento e depois rapidamente recompilam para ARM quando vão empacotar para a App Store.

Dessa forma você consegue rodar nativamente, testar rapidamente, sem a lentidão de um ambiente emulado. A propósito, vou dizer isso uma vez: o maior erro do Google é não dar suporte a LLVM como deveria e ficar reinventando a roda. Se tivessem feito isso, Go já poderia ser usado para implementar para Android e Chromebooks, além de servidores baseados em x86, e poderiam jogar fora todo o imbróglio com Java/Oracle.

Mas estou divagando.

No OS X você pode passar uma link-flag "`-bundle`" para o crystal e ele provavelmente vai usar clang por baixo dos panos para gerar o bundle binário.

No Ubuntu, o crystal apenas compila para um arquivo objeto (.o) e você tem que invocar o GCC manualmente com a opção "`-shared`" para criar um shared object. Para fazer isso temos que usar o ["--cross-compile"](https://crystal-lang.org/docs/syntax_and_semantics/cross-compilation.html) e passar um triplet de target do LLVM para gerar o .o (isso requer a ferramenta `llvm-config`).

Shared Libraries (.so) e Loadable Modules (.bundle) são bichos diferentes, dê uma olhada [nessa documentação](http://docstore.mik.ua/orelly/unix3/mac/ch05_03.htm) para mais detalhes.

Tenha em mente que benchmarkar binários compilados com compiladores diferentes pode fazer diferença. Não sou expert mas, por puro empirismo, acredito que Ruby sob RVM no OS X é compilado usando o Clang padrão do OS X. No Ubuntu é compilado com GCC. Isso parece deixar Ruby no OS X "levemente" ineficiente em benchmarks sintéticos.

Por outro lado, binários Crystal linkados com GCC parecem "levemente" ineficientes no Ubuntu, enquanto Ruby no Ubuntu parece um pouco mais rápido, tendo sido compilado e linkado com GCC.

Então, quando comparamos Fast Blank/OS X/um pouco mais rápido com Ruby/OS X/mais lento contra Fast Blank/Ubuntu/um pouco mais lento com Ruby/Ubuntu/um pouco mais rápido, parece dar uma vantagem maior para a comparação no OS X em relação ao benchmark do Ubuntu, mesmo que os tempos individuais de computação não estejam tão longe entre si.

Vou voltar a esse ponto na seção de benchmarks.

Por fim, toda vez que você tem uma rubygem com extensão nativa, vai encontrar este trecho nos arquivos gemspec:

```ruby
Gem::Specification.new do |s|
  s.name = 'fast_blank'
  ...
  s.extensions = ['ext/fast_blank/extconf.rb']
  ...
```

Quando a gem é instalada via `gem install` ou `bundle install`, ela vai rodar esse script para gerar um `Makefile` adequado. Em uma extensão pura em C, ele usa a biblioteca embutida "mkmf" para gerar.

No nosso caso, se temos Crystal instalado, queremos usar a versão Crystal, então adaptei o `extconf.rb` para ficar assim:

```ruby
require 'mkmf'

if ENV['VERSION'] != "C" && find_executable('crystal') && find_executable('llvm-config')
  # Patch bem porco
  def create_makefile(target, srcprefix = nil)
    mfile = open("Makefile", "wb")
    cr_makefile = File.join(File.dirname(__FILE__), "../src/Makefile")
    mfile.print File.read(cr_makefile)
  ensure
    mfile.close if mfile
    puts "Crystal version of the Makefile copied"
  end
end

create_makefile 'fast_blank'
```

Então, se ele encontrar `crystal` e `llvm-config` (que no OS X você precisa adicionar o path apropriado assim: `export PATH=$(brew --prefix llvm)/bin:$PATH`).

O `Rakefile` desse projeto declara a task padrão `:compile` como a primeira a rodar, e ela vai executar o `extconf.rb`, que vai gerar o `Makefile` apropriado e rodar o comando `make` para compilar e linkar a biblioteca correta no path `lib/`.

Então acabamos com `lib/fast_blank.bundle` no OS X e `lib/fast_blank.so` no Ubuntu. A partir daí podemos simplesmente fazer `require "fast_blank"` em qualquer arquivo Ruby da gem e ele terá acesso aos mapeamentos das funções C exportadas publicamente da biblioteca Crystal.

### Mapeando C-Ruby para Crystal

Bom, qualquer extensão direta em C - sem FFI, fiddle ou outras "pontes" - vai SEMPRE ter uma vantagem muito maior.

A razão é que você literalmente tem que "copiar" dados de C-Ruby para Crystal/Rust/Go ou qualquer outra linguagem que você esteja fazendo binding. Já com uma extensão em C você consegue operar diretamente no espaço de memória com os dados, sem ter que mover ou copiar para outro lugar.

Por exemplo. Primeiro, você precisa fazer o binding das funções C de C-Ruby para Crystal. E fazemos isso com os mapeamentos do [Crystalized Ruby do Paul Hoffer](https://github.com/phoffer/crystalized_ruby/blob/master/src/lib_ruby.cr). É um repositório experimental que ajudei a limpar um pouco para que ele depois extraísse essa biblioteca de mapeamento como uma Shard própria (shards são o mesmo que gems para Crystal). Por enquanto, eu simplesmente copiei o arquivo para o meu Fast Blank.

Algumas das partes relevantes são assim:

```ruby
lib LibRuby
  type VALUE = Void*
  type METHOD_FUNC = VALUE -> VALUE
  type ID = Void*
  ...

  # strings
  fun rb_str_to_str(value : VALUE) : VALUE
  fun rb_string_value_cstr(value_ptr : VALUE*) : UInt8*
  fun rb_str_new_cstr(str : UInt8*) : VALUE
  fun rb_utf8_encoding() : VALUE
  fun rb_enc_str_new_cstr(str : UInt8*, enc : VALUE) : VALUE
  ...
  # tratamento de exceções
  fun rb_rescue(func : VALUE -> UInt8*, args : VALUE, callback: VALUE -> UInt8*, value: VALUE) : UInt8*
end
...
class String
  RUBY_UTF = LibRuby.rb_utf8_encoding
  def to_ruby
    LibRuby.rb_enc_str_new_cstr(self, RUBY_UTF)
  end

  def self.from_ruby(str : LibRuby::VALUE)
    c_str = LibRuby.rb_rescue(->String.cr_str_from_rb_cstr, str, ->String.return_empty_string, 0.to_ruby)
    # FIXME ainda existe um problema não tratado: quando recebemos \u0000 do Ruby, ele lança "string contains null bytes"
    # então capturamos com rb_rescue, mas aí não conseguimos gerar um Pointer(UInt8) que represente o unicode 0, ao invés disso retornamos uma string em branco
    # mas aí os specs falham
    new(c_str)
  ensure
    ""
  end

  def self.cr_str_from_rb_cstr(str : LibRuby::VALUE)
    rb_str = LibRuby.rb_str_to_str(str)
    c_str  = LibRuby.rb_string_value_cstr(pointerof(rb_str))
  end

  def self.return_empty_string(arg : LibRuby::VALUE)
    a = 0_u8
    pointerof(a)
  end
end
```

Aí posso usar esses mapeamentos e helpers para construir uma classe "Wrapper" em Crystal:

```ruby
require "./lib_ruby"
require "./string_extension"

module StringExtensionWrapper
  def self.blank?(self : LibRuby::VALUE)
    return true.to_ruby if LibRuby.rb_str_length(self) == 0
    str = String.from_ruby(self)
    str.blank?.to_ruby
  rescue
    true.to_ruby
  end

  def self.blank_as?(self : LibRuby::VALUE)
    return true.to_ruby if LibRuby.rb_str_length(self) == 0
    str = String.from_ruby(self)
    str.blank_as?.to_ruby
  rescue
    true.to_ruby
  end

  def self.crystal_value(self : LibRuby::VALUE)
    str = String.from_ruby(self)
    str.to_ruby
  end
end
```

E esse "Wrapper" depende da própria biblioteca "pura" em Crystal, como nos snippets das extensões da struct Char e da classe String que mostrei na primeira seção do artigo.

Por fim, tenho um arquivo principal "fast_blank.cr" que faz o extern dessas funções do Wrapper para que o C-Ruby possa enxergá-las como métodos comuns de String:

```ruby
require "./string_extension_wrapper.cr"

fun init = Init_fast_blank
  GC.init
  LibCrystalMain.__crystal_main(0, Pointer(Pointer(UInt8)).null)

  string = LibRuby.rb_define_class("String", LibRuby.rb_cObject)
  LibRuby.rb_define_method(string, "blank?", ->StringExtensionWrapper.blank?, 0)
  LibRuby.rb_define_method(string, "blank_as?", ->StringExtensionWrapper.blank_as?, 0)
  ...
end
```

Isso é basicamente boilerplate. Mas agora veja o que estou tendo que fazer no wrapper, neste snippet específico:

```ruby
def self.blank?(self : LibRuby::VALUE)
  return true.to_ruby if LibRuby.rb_str_length(self) == 0
  str = String.from_ruby(self)
  str.blank?.to_ruby
rescue
  true.to_ruby
end
```

Estou recebendo uma String do C-Ruby tipada como ponteiro (VALUE), depois passo pelos mapeamentos do lib_ruby.cr para pegar os dados da string do C-Ruby e copiar para uma nova instância da representação interna de String do Crystal. Então, em qualquer momento eu tenho 2 cópias da mesma string, uma no espaço de memória do C-Ruby e outra no espaço de memória do Crystal.

Isso acontece com todas as extensões tipo FFI, mas não acontece com a implementação pura em C. Na implementação em C do Sam Saffron, ela trabalha diretamente com o mesmo endereço no espaço de memória do C-Ruby:

```C
static VALUE
rb_str_blank(VALUE str)
{
  rb_encoding *enc;
  char *s, *e;

  enc = STR_ENC_GET(str);
  s = RSTRING_PTR(str);
  ...
```

Ela recebe um ponteiro (endereço de memória direto) e segue. E essa é uma vantagem enorme para a versão em C. Quando você tem um grande volume de strings de tamanho médio a grande sendo copiadas de C-Ruby para Crystal, isso adiciona um overhead perceptível que não dá para remover.

### Caveat do mapeamento de String

Ainda tenho um problema. Existe um edge case que não consegui superar ainda (ajuda é mais que bem-vinda). Quando o C-Ruby passa um unicode `"\u0000"`, eu não consigo criar o mesmo caractere em Crystal e acabo passando apenas uma string vazia (""), o que não é a mesma coisa.

A maneira de lidar com isso é receber uma String Ruby (VALUE) e pegar a C-String dela assim:

```ruby
rb_str = LibRuby.rb_str_to_str(str)
c_str  = LibRuby.rb_string_value_cstr(pointerof(rb_str))
```

Se a "str" for o "\u0000" (no Ruby 2.2.5 pelo menos), o C-Ruby lança uma exceção "string contains null bytes". É por isso que eu faço rescue dessa exceção assim:

```ruby
c_str = LibRuby.rb_rescue(->String.cr_str_from_rb_cstr, str, ->String.return_empty_string, 0.to_ruby)
```

Quando uma exceção é disparada, tenho que passar o ponteiro para outra função para fazer o rescue:

```ruby
def self.return_empty_string(arg : LibRuby::VALUE)
  a = 0_u8
  pointerof(a)
end
```

Mas isso não está correto, estou apenas passando o ponteiro para um caractere "0", que é "vazio". Por isso, os specs não estão passando corretamente:

```
Failures:

  1) String provides a parity with active support function
     Failure/Error: expect("#{i.to_s(16)} #{c.blank_as?}").to eq("#{i.to_s(16)} #{c.blank2?}")

       expected: "0 false"
            got: "0 true"

       (compared using ==)
     # ./spec/fast_blank_spec.rb:22:in `block (3 levels) in <top (required)>'
     # ./spec/fast_blank_spec.rb:19:in `times'
     # ./spec/fast_blank_spec.rb:19:in `block (2 levels) in <top (required)>'

  2) String treats  correctly
     Failure/Error: expect("\u0000".blank_as?).to be_falsey
       expected: falsey value
            got: true
     # ./spec/fast_blank_spec.rb:47:in `block (2 levels) in <top (required)>'
```

O Ary deu uma dica simples depois, vou adicionar na conclusão abaixo.

### Os benchmarks sintéticos (cuidado em como interpretá-los!)

A [implementação original de String#blank? do ActiveSupport do Rails](https://github.com/rails/rails/blob/2a371368c91789a4d689d6a84eb20b238c37678a/activesupport/lib/active_support/core_ext/object/blank.rb#L101) é assim:

```ruby
class String
  # 0x3000: fullwidth whitespace
  NON_WHITESPACE_REGEXP = %r![^\s#{[0x3000].pack("U")}]!

  # Uma string é blank se for vazia ou contiver só whitespace:
  #
  #   "".blank?                 # => true
  #   "   ".blank?              # => true
  #   "　".blank?               # => true
  #   " something here ".blank? # => false
  #
  def blank?
    # 1.8 não trata [:space:] direito
    if encoding_aware?
      self !~ /[^[:space:]]/
    else
      self !~ NON_WHITESPACE_REGEXP
    end
  end
end
```

É basicamente uma comparação por expressão regular, o que pode ser meio lento. A versão do Sam é um loop mais direto pela string para comparar cada caractere com o que é considerado "blank". Existem vários codepoints unicode considerados blank, alguns não, e por isso as versões em C e Crystal são parecidas, mas diferentes da versão do Rails.

Na gem Fast Blank existe um script Ruby `benchmark` para comparar a extensão em C contra a implementação baseada em Regex do Rails.

A implementação Regex é chamada de **"Slow Blank"**. Ela é particularmente lenta se você passa uma String realmente vazia, então no benchmark o Sam adicionou uma **"New Slow Blank"** que checa primeiro com `String#empty?`, e essa versão é mais rápida nesse edge case.

A versão rápida em C se chama **"Fast Blank"**, mas mesmo que você possa considerá-la "correta", ela não é compatível com todos os edge cases do Rails. Então ele implementou um `String#blank_as?` que é compatível com Rails. O Sam chama de **"Fast Activesupport"**.

Na minha versão em Crystal eu fiz a mesma coisa, tendo tanto `String#blank?` quanto `String#blank_as?`.

Então, sem mais delongas, aqui está o benchmark da **versão em C no OS X** para strings vazias, e exercitamos cada função muitas vezes em poucos segundos para ter resultados mais precisos (confira o ["benchmark/ips"](https://github.com/evanphx/benchmark-ips) do Evan Phoenix para entender a metodologia de "iteration per second").

```
================== Test String Length: 0 ==================
Warming up _______________________________________
          Fast Blank   191.708k i/100ms
  Fast ActiveSupport   209.628k i/100ms
          Slow Blank    61.487k i/100ms
      New Slow Blank   203.165k i/100ms
Calculating _______________________________________
          Fast Blank     20.479M (± 9.3%) i/s -    101.414M in   5.001177s
  Fast ActiveSupport     21.883M (± 9.4%) i/s -    108.378M in   5.004350s
          Slow Blank      1.060M (± 4.7%) i/s -      5.288M in   5.001365s
      New Slow Blank     18.883M (± 6.9%) i/s -     94.065M in   5.008899s

Comparison:
  Fast ActiveSupport: 21882711.5 i/s
          Fast Blank: 20478961.5 i/s - same-ish: difference falls within error
      New Slow Blank: 18883442.2 i/s - same-ish: difference falls within error
          Slow Blank:  1059692.6 i/s - 20.65x slower
```

Está super rápido. A versão do Rails é 20x mais lenta na minha máquina.

Agora, **versão Crystal no OS X**

```
================== Test String Length: 0 ==================
Warming up _______________________________________
          Fast Blank   174.349k i/100ms
  Fast ActiveSupport   174.035k i/100ms
          Slow Blank    64.684k i/100ms
      New Slow Blank   215.164k i/100ms
Calculating _______________________________________
          Fast Blank      8.647M (± 1.6%) i/s -     43.239M in   5.001530s
  Fast ActiveSupport      8.580M (± 1.3%) i/s -     42.987M in   5.010759s
          Slow Blank      1.047M (± 3.7%) i/s -      5.239M in   5.008907s
      New Slow Blank     19.090M (± 9.3%) i/s -     94.672M in   5.009057s

Comparison:
      New Slow Blank: 19090034.8 i/s
          Fast Blank:  8647459.7 i/s - 2.21x slower
  Fast ActiveSupport:  8580487.9 i/s - 2.22x slower
          Slow Blank:  1047465.3 i/s - 18.22x slower
```

Como expliquei antes, mesmo checando strings vazias, a versão Crystal é mais lenta que o check de Ruby por `String#empty?` (New Slow Blank), porque tenho a rotina de cópia de string nos mapeamentos do Wrapper. Isso adiciona overhead perceptível ao longo de muitas iterações. Continua sendo 18x mais rápido que Rails, mas perde para C-Ruby.

Por fim, **versão Crystal no Ubuntu**

```
================== Test String Length: 0 ==================
Warming up _______________________________________
          Fast Blank   255.883k i/100ms
  Fast ActiveSupport   260.915k i/100ms
          Slow Blank   105.424k i/100ms
      New Slow Blank   284.670k i/100ms
Calculating _______________________________________
          Fast Blank      8.895M (± 9.8%) i/s -     44.268M in   5.037761s
  Fast ActiveSupport      8.647M (± 8.2%) i/s -     43.051M in   5.020125s
          Slow Blank      1.736M (± 3.9%) i/s -      8.750M in   5.048253s
      New Slow Blank     22.170M (± 6.2%) i/s -    110.452M in   5.004909s

Comparison:
      New Slow Blank: 22170031.0 i/s
          Fast Blank:  8895113.3 i/s - 2.49x slower
  Fast ActiveSupport:  8646940.8 i/s - 2.56x slower
          Slow Blank:  1736071.0 i/s - 12.77x slower
```

Note que está na mesma faixa, mas a versão Rails no Ubuntu roda quase duas vezes mais rápido comparada à equivalente no OS X, o que faz a comparação contra a biblioteca Crystal cair de 18x para 12x.

O benchmark continua comparando contra strings cada vez maiores, de 6, para 14, para 24, até 136 caracteres.

Vamos pegar só o último teste, com 136 caracteres. Primeiro com a **versão em C no OS X**:

```
================== Test String Length: 136 ==================
Warming up _______________________________________
          Fast Blank   177.521k i/100ms
  Fast ActiveSupport   193.559k i/100ms
          Slow Blank    89.378k i/100ms
      New Slow Blank    60.639k i/100ms
Calculating _______________________________________
          Fast Blank     10.727M (± 8.7%) i/s -     53.256M in   5.006538s
  Fast ActiveSupport     11.600M (± 8.3%) i/s -     57.681M in   5.009692s
          Slow Blank      1.872M (± 5.7%) i/s -      9.385M in   5.029243s
      New Slow Blank      1.017M (± 5.3%) i/s -      5.094M in   5.022994s

Comparison:
  Fast ActiveSupport: 11600112.2 i/s
          Fast Blank: 10726792.8 i/s - same-ish: difference falls within error
          Slow Blank:  1872262.5 i/s - 6.20x slower
      New Slow Blank:  1016926.7 i/s - 11.41x slower
```

A versão em C é consistentemente muito mais rápida em todos os casos de teste e nos 136 caracteres ainda está 11x mais rápida que o Rails em Ruby puro.

Agora a **versão Crystal no OS X**:

```
================== Test String Length: 136 ==================
Warming up _______________________________________
          Fast Blank   127.749k i/100ms
  Fast ActiveSupport   126.538k i/100ms
          Slow Blank    94.390k i/100ms
      New Slow Blank    60.594k i/100ms
Calculating _______________________________________
          Fast Blank      3.283M (± 1.8%) i/s -     16.480M in   5.021364s
  Fast ActiveSupport      3.235M (± 1.3%) i/s -     16.197M in   5.008315s
          Slow Blank      1.888M (± 4.4%) i/s -      9.439M in   5.009458s
      New Slow Blank    967.950k (± 4.7%) i/s -      4.848M in   5.018946s

Comparison:
          Fast Blank:  3283025.1 i/s
  Fast ActiveSupport:  3234586.5 i/s - same-ish: difference falls within error
          Slow Blank:  1887800.5 i/s - 1.74x slower
      New Slow Blank:   967950.2 i/s - 3.39x slower
```

Também é mais rápida, mas só por 2 a 3 vezes comparada ao Ruby puro, bem longe do 11x. Mas minha hipótese é que o mapeamento e cópia de tantas strings adiciona um overhead grande que a versão em C não tem.

E a **versão Crystal no Ubuntu**:

```
================== Test String Length: 136 ==================
Warming up _______________________________________
          Fast Blank   186.810k i/100ms
  Fast ActiveSupport   187.306k i/100ms
          Slow Blank   143.439k i/100ms
      New Slow Blank    98.308k i/100ms
Calculating _______________________________________
          Fast Blank      3.517M (± 3.9%) i/s -     17.560M in   5.000791s
  Fast ActiveSupport      3.485M (± 3.8%) i/s -     17.419M in   5.006427s
          Slow Blank      2.755M (± 4.2%) i/s -     13.770M in   5.008490s
      New Slow Blank      1.551M (± 4.3%) i/s -      7.766M in   5.017853s

Comparison:
          Fast Blank:  3516960.7 i/s
  Fast ActiveSupport:  3484575.5 i/s - same-ish: difference falls within error
          Slow Blank:  2754669.0 i/s - 1.28x slower
      New Slow Blank:  1550815.2 i/s - 2.27x slower
```

Novamente, as versões Ubuntu tanto da biblioteca Crystal quanto do binário Ruby rodam mais rápido, e a comparação mostra no máximo o dobro de velocidade. E o `String#empty?` do Ruby puro está na mesma faixa que a versão Crystal.

### Conclusão

A conclusão mais óbvia é que provavelmente errei ao escolher Fast Blank como minha primeira prova de conceito. O algoritmo é trivial demais e um simples check de `String#empty?` em Ruby puro é ordens de magnitude mais rápido que o overhead adicionado de mapear e copiar strings para Crystal.

Além disso, qualquer caso de uso onde você tem uma quantidade enorme de pequenos pedaços de dados sendo transferidos de C-Ruby para Crystal, ou qualquer extensão baseada em FFI, vai ter o overhead da cópia de dados, que uma versão pura em C não tem. É por isso que Fast Blank é melhor feito em C.

Outros casos de uso, onde você tem menos dados, ou dados que podem ser transferidos em lote (menos chamadas do C-Ruby para a extensão, com argumentos de tamanho maior, e com processamento mais custoso), são candidatos melhores para se beneficiar de extensões.

Mais uma vez, nem tudo fica automaticamente mais rápido, sempre temos que entender os cenários de uso primeiro. Mas como é muito mais fácil escrever em Crystal e fazer benchmark, podemos fazer provas de conceito mais rapidamente e descartar a ideia se as medições provarem que não vamos nos beneficiar tanto.

A documentação do Crystal recebeu recentemente um ["Performance Guide"](https://crystal-lang.org/docs/guides/performance.html). É bem útil para você evitar armadilhas comuns que prejudicam a performance geral. Mesmo que LLVM seja bem competente em otimização pesada, ele não pode fazer tudo. Então leia tudo para melhorar suas habilidades gerais em Crystal.

Dito isso, ainda acredito que esse exercício valeu muito a pena. Provavelmente vou fazer mais alguns. Eu gostaria muito de agradecer ao Ary (criador do Crystal) e ao Paul Hoffer pela paciência em me ajudar com muitas das peculiaridades que encontrei pelo caminho.

Enquanto eu finalizava esse post, [o Ary apontou](https://github.com/SamSaffron/fast_blank/pull/20#issuecomment-230875300) que eu poderia provavelmente abandonar Strings completamente e trabalhar diretamente com um array de bytes, o que é uma boa ideia e provavelmente vou tentar. Acho que já deixei claro que toda a cópia de String adiciona um overhead bem perceptível, como vimos nos benchmarks acima. Me avise se alguém quiser contribuir também. Com mais alguns ajustes, acredito que dá para ter uma versão Crystal que pelo menos compita com a versão em C, sendo também mais legível e fácil de manter para a maioria dos rubyistas, que é o meu objetivo.

Espero que os códigos que publiquei aqui sirvam como exemplos de boilerplate para mais extensões Ruby baseadas em Crystal no futuro!
