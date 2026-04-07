---
title: "Elixir 101 - Apresentando a Sintaxe"
date: '2015-11-25T17:25:00-02:00'
slug: elixir-101-apresentando-a-sintaxe
translationKey: elixir-101-syntax
aliases:
- /2015/11/25/elixir-101-introducing-the-syntax/
tags:
- learning
- beginner
- elixir
- traduzido
draft: false
---

Venho publicando vários artigos nas últimas semanas, dá uma olhada na [tag "Elixir"](http://www.akitaonrails.com/elixir) pra ler todos eles.

Muitas séries de tutoriais começam apresentando uma linguagem nova pela sintaxe. Eu inverti a ordem. Elixir não é interessante por causa da sintaxe. Erlang já é interessante por si só, por ser uma plataforma muito madura, altamente confiável, altamente concorrente e distribuída. Mas a sintaxe não é pra qualquer um. Não que seja "feia", ela é só diferente demais pra quem vem da escola C digerir com facilidade. Ela deriva de Prolog, e este é um pequeno exemplo de um exercício em Prolog:

```prolog
% P03 (*): Find the K'th element of a list.
%     The first element in the list is number 1.
%     Example:
%     ?- element_at(X,[a,b,c,d,e],3).
%     X = c

% The first element in the list is number 1.

% element_at(X,L,K) :- X is the K'th element of the list L
%    (element,list,integer) (?,?,+)

% Note: nth1(?Index, ?List, ?Elem) is predefined

element_at(X,[X|_],1).
element_at(X,[_|L],K) :- K > 1, K1 is K - 1, element_at(X,L,K1).
```

Erlang tem uma sintaxe parecida, com a ideia de frases divididas por vírgulas e terminando com um ponto.

O José Valim foi muito esperto: pegou a melhor das plataformas maduras disponíveis e cobriu com uma camada de sintaxe moderna e bibliotecas padrão mais fáceis de usar. Esse é o mesmo problema implementado em Elixir:

```ruby
defmodule Exercise do
  def element_at([found|_], 1), do: found
  def element_at([_|rest], position) when position > 1 do
    element_at(rest, position - 1)
  end
end
```

Se eu copiar e colar o código acima num shell IEx, posso testar assim:

```
iex(7)> Exercise.element_at(["a", "b", "c", "d", "e"], 3)
"c"
```

Esse exercício simples já mostra alguns dos pontos poderosos de Erlang dos quais o Elixir tira proveito, como pattern matching e recursão.

Antes de mais nada, toda função **precisa** ser definida dentro de um módulo, que você nomeia com <tt>defmodule My.Module do .. end</tt>. Internamente, isso vira o atom "Elixir.My.Process". Aninhar módulos é só um nome maior concatenado com pontos.

Daí você define funções públicas com o bloco <tt>def my_function(args) do .. end</tt>, que é só um macro pra mesma construção <tt>def my_function(args), do: ...</tt>. Métodos privados são declarados com <tt>defp</tt>.

Uma função é, na verdade, identificada pelo par nome e aridade. Então acima temos <tt>element_at/2</tt>, o que significa que aceita 2 argumentos. Mas temos 2 funções com a mesma aridade: a diferença é o **pattern matching**.

```ruby
def element_at([found|_], 1), do: found
```

Aqui estamos dizendo: o primeiro argumento será um array, decomponha-o. O primeiro elemento do array será armazenado na variável "found", o resto "_" será ignorado. E o segundo argumento precisa ser o número "1". Essa é a descrição do chamado "padrão" (pattern), que deve "casar" com os argumentos de entrada recebidos. Essa é a semântica do **"call-by-pattern"**.

Mas e se quisermos passar uma posição diferente de "1"? É pra isso que serve a segunda definição:

```
def element_at([_|rest], position) when position > 1 do
```

Agora, o primeiro argumento de novo **precisa** ser um array, mas dessa vez não nos importamos com o primeiro elemento, só com o resto do array sem o primeiro elemento. E qualquer posição diferente de "1" será armazenada na variável "position".

Mas essa função é especial, ela tem uma **guarda** que só permite uma <tt>position</tt> maior que 1. E se tentarmos uma posição negativa?

```
iex(8)> Exercise.element_at(["a", "b", "c", "d", "e"], -3)
** (FunctionClauseError) no function clause matching in Exercise.element_at/2
    iex:7: Exercise.element_at(["a", "b", "c", "d", "e"], -3)
```

Ele diz que nenhuma das cláusulas que passamos casa com nenhuma das definidas acima. Poderíamos ter adicionado uma terceira definição justamente pra capturar esses casos:

```ruby
def element_at(_list, _position), do: nil
```

Colocar o underscore "_" antes do nome da variável é o mesmo que ter só o underscore, mas estamos nomeando pra ficar mais legível. Quaisquer argumentos passados serão simplesmente ignorados. E esse é o caso mais genérico, quando os 2 anteriores não casam.

A linha anterior é o mesmo que escrever:

```
def element_at(_list, _position) do
  nil
end
```

Não vou entrar em macros agora, só saiba que existe mais de uma forma de fazer as coisas em Elixir e que você pode definir essas formas usando o suporte nativo do Erlang a macros, código dinâmico que é compilado em tempo de execução. É a maneira de fazer metaprogramação em Elixir.

Voltando à implementação, a primeira função ainda pode parecer estranha, vamos revisar:

```ruby
def element_at([_|rest], position) when position > 1 do
  element_at(rest, position - 1)
end
```

O que acontece é: quando chamamos <tt>Exercise.element_at(["a", "b", "c", "d", "e"], 3)</tt>, o primeiro argumento casa com o padrão <tt>[_|rest]</tt>. O primeiro elemento "a" é descartado e a nova lista <tt>["b", "c", "d", "e"]</tt> é armazenada como "<tt>rest</tt>".

Por fim, recursamos a chamada decrementando a variável "<tt>position</tt>". Então vira <tt>element_at(["b", "c", "d", "e"], 2)</tt>. E isso se repete até position virar "1", quando o pattern matching cai na segunda função, definida assim:

```
def element_at([found|_], 1), do: found
```

Nesse caso, o resto do array é casado por padrão e o primeiro elemento, "c", é armazenado na variável "<tt>found</tt>", o resto do array é descartado. Só chegou aqui porque a posição casou como "1", e então a função simplesmente retorna a variável "found", que contém o 3º elemento do array original, "c".

Isso tudo é bonito e elegante, mas em Elixir podíamos só ter feito esta outra versão:

```ruby
defmodule Exercise do
  def element_at(list, position), do: Enum.at(list, position)
end
```

E pronto! Vários tutoriais vão falar como recursão e pattern matching pra decompor listas resolvem um monte de problemas, mas o Elixir nos dá a conveniência de tratar listas como Enumerables e oferece um módulo [Enum](http://elixir-lang.org/docs/stable/elixir/Enum.html) bem rico, com funções muito úteis como <tt>at/2</tt>, <tt>each/2</tt>, <tt>take/2</tt> e por aí vai. É só escolher o que precisa e você manipula listas como um chefe.

Ah, e por sinal, existe algo chamado [Sigil](http://elixir-lang.org/getting-started/sigils.html) no Elixir. Em vez de escrever a Lista de Strings explicitamente, podíamos ter feito assim:

```
iex(8)> ~w(a b c d e f)
["a", "b", "c", "d", "e", "f"]
```

Ou, se quiséssemos uma Lista de Atoms, podíamos fazer assim:

```
iex(9)> ~w(a b c d e f)a
[:a, :b, :c, :d, :e, :f]
```

### Lists, Tuples e Keyword Lists

Bom, isso foi simples demais. Você precisa mesmo ter a ideia de pattern matching e os tipos básicos na cabeça pra fluir. Vamos pegar outro trecho do [Ex Manga Downloadr](http://www.akitaonrails.com/2015/11/18/ex-manga-downloadr-um-exercicio-com-elixir):

```ruby
defp parse_args(args) do
  parse = OptionParser.parse(args,
    switches: [name: :string, url: :string, directory: :string],
    aliases: [n: :name, u: :url, d: :directory]
  )
  case parse do
    {[name: manga_name, url: url, directory: directory], _, _} -> process(manga_name, url, directory)
    {[name: manga_name, directory: directory], _, _} -> process(manga_name, directory)
    {_, _, _ } -> process(:help)
  end
end
```

A primeira parte pode confundir você:

```ruby
OptionParser.parse(args,
    switches: [name: :string, url: :string, directory: :string],
    aliases: [n: :name, u: :url, d: :directory]
  )
```

O <tt>OptionParser.parse/2</tt> recebe só 2 argumentos: 2 arrays. Se você vem de Ruby, parece um Hash com colchetes opcionais, traduzindo pra algo parecido com isto:

```ruby
# isto está errado
OptionParser.parse(args,
    { switches: {name: :string, url: :string, directory: :string},
      aliases: {n: :name, u: :url, d: :directory} }
  )
```

Isso funciona em Ruby, mas não é o caso em Elixir; existem colchetes opcionais, só que não onde você imagina:

```ruby
# esta é a versão correta, mais explícita
OptionParser.parse(args,
    [
      {
        :switches,
        [
          {:name, :string}, {:url, :string}, {:directory, :string}
        ]
      },
      {
        aliases:
        [
          {:n, :name}, {:u, :url}, {:d, :directory}
        ]
      }
    ]
  )
```

QUE!?!?

Isso mesmo, o segundo argumento é, na verdade, um array com elementos que são **Tuples**, pareados com chave atom e valor, e alguns dos valores são, eles próprios, arrays com tuples.

1. em Elixir, Lists são o que normalmente chamamos de Array, uma Linked-List de elementos. Linked-Lists, como você sabe das aulas de Ciência da Computação, são fáceis pra inserir e remover elementos.

2. em Elixir, Tuples são listas fixas e imutáveis com posições fixas, com elementos delimitados pelas chaves "{}"

Se o exemplo anterior foi demais, vamos dar um passo atrás:

```ruby
defmodule Teste do
  def teste(opts) do
    [{:hello, world}, {:foo, bar}] = opts
    IO.puts "#{world} #{bar}"
  end
end
```

Agora podemos chamar assim:

```
iex(13)> Teste.teste hello: "world", foo: "bar"
world bar
```

Que é o mesmo que chamar assim:

```
iex(14)> Teste.teste([{:hello, "world"}, {:foo, "bar"}])
world bar
```

Isso pode confundir, mas é bem intuitivo. Você pode pensar nessa combinação de Lists ("[]") com elementos Tuple contendo um par atom e valor ("{:key, value}") como algo que se comporta quase como Hashes do Ruby usados pra argumentos nomeados opcionais.

Aí temos a parte de Pattern Match nos dois exemplos anteriores:

```ruby
case parse do
  {[name: manga_name, url: url, directory: directory], _, _} ->
    process(manga_name, url, directory)
  {[name: manga_name, directory: directory], _, _} ->
    process(manga_name, directory)
  {_, _, _ } ->
    process(:help)
end
```

E

```ruby
[{:hello, world}, {:foo, bar}] = opts
```

O último exemplo é só decomposição. O exemplo anterior é pattern match e decomposição. Você casa com base nos atoms e nas posições dentro das tuples dentro da lista. Você casa do caso mais específico pro mais genérico. E, no processo, as variáveis do padrão ficam disponíveis pra usar dentro da cláusula correspondente do case.

Vamos entender o significado desta linha:

```ruby
{[name: manga_name, url: url, directory: directory], _, _} -> process(manga_name, url, directory)
```

Ela está dizendo: dado o resultado da função <tt>OptionParser.parse/2</tt>, ele precisa ser uma tuple com 3 elementos. O segundo e o terceiro elementos não importam. Mas o primeiro elemento precisa ser uma List com pelo menos 3 tuples. E as chaves de cada tuple precisam ser os atoms <tt>:name</tt>, <tt>:url</tt> e <tt>:directory</tt>. Se estiverem lá, armazene os valores de cada tuple nas variáveis <tt>manga_name</tt>, <tt>url</tt> e <tt>directory</tt>, respectivamente.

Isso pode confundir bastante no início, mas essa combinação de uma List de Tuples é o que se chama [**Keyword List**](http://elixir-lang.org/getting-started/maps-and-dicts.html#keyword-lists) e você vai encontrar esse padrão muitas vezes, então acostume-se.

Keyword List parece um Map, mas o Map tem uma sintaxe diferente:

```ruby
list = [a: 1, b: 2, c: 3]
map = %{:a => 1, :b => 2, :c => 3}
```

Isso deve resumir bem:

```
iex(1)> list = [a: 1, b: 2, c: 3]
[a: 1, b: 2, c: 3]
iex(2)> map = %{:a => 1, :b => 2, :c => 3}
%{a: 1, b: 2, c: 3}

iex(3)> list[:a]
1
iex(4)> map[:a]
1

iex(5)> list.a
** (ArgumentError) argument error
    :erlang.apply([a: 1, b: 2, c: 3], :a, [])
iex(5)> map.a
1

iex(6)> list2 = [{:a, 1}, {:b, 2}, {:c, 3}]
[a: 1, b: 2, c: 3]
iex(7)> list = list2
[a: 1, b: 2, c: 3]
```

Keyword Lists são convenientes como argumentos de função ou valores de retorno. Mas se você quiser processar uma coleção de pares chave-valor, use uma estrutura tipo dicionário, neste caso, um Map. Especialmente se você precisar buscar na coleção pela chave. Eles parecem semelhantes, mas as estruturas internas são diferentes; uma Keyword List não é um Map, é só uma conveniência pra uma lista estática de tuples.

Por fim, se esse padrão casar com a variável <tt>parse</tt> passada no bloco <tt>case</tt>, ele executa <tt>process(manga_name, url, directory)</tt>, passando as 3 variáveis capturadas no match. Caso contrário, segue tentando o próximo padrão do bloco <tt>case</tt>.

A ideia é que o operador "=" não é uma "atribuição", é um casador, você casa um lado com o outro. Leia a mensagem de erro quando um padrão não casa:

```
iex(15)> [a, b, c] = 1
** (MatchError) no match of right hand side value: 1
```

Esse é um erro de matching, não um erro de atribuição. Mas se der certo, isso é o que temos:

```
iex(15)> [a, b, c] = [1, 2, 3]
[1, 2, 3]
iex(16)> a
1
iex(17)> c
3
```

Isso é uma decomposição de List. Acontece que, no caso simples, parece uma atribuição de variável, mas é bem mais complexo do que isso.

### Pipelines

Usamos exatamente esses conceitos de pattern matching nos elementos retornados do HTML parseado pelo Floki no meu Manga Downloadr:

```ruby
Floki.find(html, "#listing a")
|> Enum.map(fn {"a", [{"href", url}], _} -> url end)
```

O <tt>find/2</tt> pega uma string HTML da página baixada e casa com os seletores CSS do segundo argumento. O resultado é uma List de Tuples representando a estrutura de cada Nó HTML encontrado, neste caso, com este padrão: <tt>{"a", [{"href", url}], _}</tt>

Daí podemos usar <tt>Enum.map/2</tt>. Um map é uma função que recebe cada elemento de uma lista e retorna uma nova lista com novos elementos. O primeiro argumento é a lista original e o segundo é uma função que recebe cada elemento e retorna um novo.

Uma das principais features da linguagem Elixir, que a maioria das linguagens não tem, é o operador **Pipe** ("|>"). Ele se comporta quase como o operador pipe "|" do UNIX em qualquer shell.

No UNIX a gente costuma fazer coisas tipo "<tt>ps -ef | grep PROCESS | grep -v grep | awk '{print $2}' | xargs kill -9</tt>"

Isso é essencialmente o mesmo que fazer:

```
ps -ef > /tmp/ps.txt
grep mix /tmp/ps.txt > /tmp/grep.txt
grep -v grep /tmp/grep.txt > /tmp/grep2.txt
awk '{print $2}' /tmp/grep2.txt > /tmp/awk.txt
xargs kill -9 < /tmp/awk.txt
```

Cada processo UNIX pode receber algo da entrada padrão (STDIN) e enviar algo pra saída padrão (STDOUT). Podemos redirecionar a saída usando ">". Mas, em vez de fazer todos esses passos extras, criando um monte de arquivos temporários inúteis, podemos simplesmente "pipear" o STDOUT de um comando pro STDIN do próximo.

Elixir usa os mesmos princípios: podemos simplesmente usar o valor de retorno de uma função como o **primeiro argumento** da próxima função. Então o primeiro exemplo desta seção é o mesmo que fazer isto:

```ruby
results = Floki.find(html, "#listing a")
Enum.map(results, fn {"a", [{"href", url}], _} -> url end)
```

No mesmo projeto ExMangaDownloadr temos este trecho:

```ruby
defp process(manga_name, url, directory) do
  File.mkdir_p!(directory)
  url
    |> Workflow.chapters
    |> Workflow.pages
    |> Workflow.images_sources
    |> Workflow.process_downloads(directory)
    |> Workflow.optimize_images
    |> Workflow.compile_pdfs(manga_name)
    |> finish_process
end
```

E acabamos de aprender que isso é o equivalente a fazer o seguinte (estou trapaceando um pouco porque as 3 funções finais do workflow não estão transformando o "directory" de entrada, só repassando):

```ruby
  defp process(manga_name, url, directory) do
    File.mkdir_p!(directory)

    chapters  = Workflow.chapters(url)
    pages     = Workflow.pages(chapters)
    sources   = Workflow.images_sources(pages)
    Workflow.process_downloads(sources, directory)
    Workflow.optimize_images(directory)
    Workflow.compile_pdfs(directory, manga_name)
    finish_process(directory)
  end
```

Ou esta versão muito mais feia, que precisamos ler de trás pra frente:

```ruby
defp process(manga_name, url, directory) do
  File.mkdir_p!(directory)
  finish_process(
    Workflow.compile_pdfs(
      Workflow.optimize_images(
        Workflow.images_sources(
          Workflow.pages(
            Workflow.chapters(url)
          )
        )
      ), manga_name
    )
  )
end
```

Dá pra ver facilmente como o operador Pipe "|>" deixa qualquer pipeline de transformação muito mais fácil de ler. Sempre que você está partindo de um valor, passando os resultados por uma **cadeia de transformação**, você vai usar esse operador.

### Próximos Passos

Os conceitos apresentados neste artigo são os que eu acho que a maioria das pessoas vai achar mais desafiadores no primeiro contato. Se você entender Pattern Matching e Keyword Lists, vai entender todo o resto.

O site oficial oferece um ótimo [Getting Started](http://elixir-lang.org/getting-started/introduction.html) que você precisa ler inteiro.

Por intuição você já sabe a maior parte das coisas. Você tem blocos "do .. end", mas ainda não sabe que eles são só macros de conveniência pra passar uma lista de instruções como argumento dentro de uma Keyword List. Os blocos a seguir são equivalentes:

```ruby
if true do
  a = 1 + 2
  a + 10
end

if true, do: (
  a = 1 + 2
  a + 10
)

if true, [{:do, (
  a = 1 + 2
  a + 10
)}]
```

De cair o queixo, hein? Existem muitos macros que adicionam açúcar sintático em cima das primitivas.

Em geral, o Valim tornou as poderosas primitivas do Erlang mais acessíveis (Lists, Atoms, Maps, etc) e adicionou abstrações mais altas usando macros (blocos do .. end, o operador pipe, keyword lists, atalhos pra funções anônimas, etc). Essa combinação precisa é o que torna o Elixir muito gostoso de aprender. É como descascar uma cebola: você começa pelas abstrações mais altas e descobre macros de estruturas mais simples por baixo. Você vê uma Keyword List primeiro e descobre Lists de Tuples. Você vê um bloco e descobre outra Keyword List disfarçada por um macro. E assim vai.

Então você tem uma curva de entrada baixa e pode descer fundo na toca do coelho até o ponto em que está estendendo a própria linguagem.

Elixir oferece um design de linguagem muito esperto em cima do núcleo maduro do Erlang, com 25 anos. Isso é mais que esperto, é a escolha inteligente. Continue aprendendo!
