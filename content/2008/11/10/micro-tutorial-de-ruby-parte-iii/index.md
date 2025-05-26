---
title: Micro-Tutorial de Ruby - Parte III
date: '2008-11-10T01:43:00-02:00'
slug: micro-tutorial-de-ruby-parte-iii
tags:
- learning
- beginner
- ruby
- tutorial
draft: false
---

Vamos continuar de onde paramos. Leia a [Parte I](/2008/11/10/micro-tutorial-de-ruby-parte-i) e [Parte II](/2008/11/10/micro-tutorial-de-ruby-parte-ii) antes de continuar. E algumas dicas finais:

Eu tenho alguns tutoriais e screencasts disponíveis na seção [Tutorials](/tutorials) aqui neste blog mesmo. Muitos me perguntam sobre livros, existem dezenas (procure na [Amazon](http://rubyurl.com/XgLe)) mas lembrem-se do seguinte: nenhum livro, em inglês ou português, jamais será capaz de ter tudo atualizado. Projetos open source estão em constante evolução. O Rails 2.1 saiu faz poucos meses e o 2.2 já está para sair daqui poucos dias. É impossível nesse meio tempo ter todos os livros atualizados, muito menos traduzidos. De preferência, use os dois: livros e material online. Isso dito, se você puder comprar apenas 1 livro de Ruby e 1 de Rails escolha [The Ruby Way](http://rubyurl.com/IXfs) e [The Rails Way](http://rubyurl.com/t8jb).

O principal: participe. Existe uma comunidade Brasileira em constante expansão. Procure por nós no [Google Groups](http://groups.google.com.br/group/rails-br/). Pesquise antes de perguntar, como disse acima, existem centenas de boas fontes de informação.


## Tipos Básicos

Continuando com os tipos básicos de Ruby (no artigo anterior já falamos de Arrays e Hashes):

### Strings

Novamente, nada de muito surpreendente aqui:

* * *
ruby

\>\> palavra = “bla bla”  
=\> “bla bla”  
\>\> palavra.size  
=\> 7  
-

A operação mais comum em string é a concatenação:

* * *
ruby

\>\> nome = “Fabio”  
=\> “Fabio”  
\>\> sobrenome = “Akita”  
=\> “Akita”  
\>\> nome + " " + sobrenome  
=\> “Fabio Akita”  
-

Porém, já vimos em seções anteriores outra maneira de fazer a mesma concatenação:

* * *
ruby

\>\> “#{nome} #{sobrenome}”  
=\> “Fabio Akita”  
-

Tudo que estiver dentro de “#{}” é executado e o resultado convertido em String e concatenado junto com o resto. Isso deve evitar aquele monte de “+” o tempo todo quando queremos concatenar as coisas. Um dos lugares onde mais usamos concatenação é quando queremos strings com quebras de linha. O jeito comum é fazer assim:

* * *
ruby

\>\> nome = “F”  
=\> “F”  
\>\> query = “SELECT \* FROM NOMES \n” +  
?\> “WHERE NOME LIKE ’%” + nome + “%’ \n” +  
?\> “ORDER BY NOME”  
=\> “SELECT \* FROM NOMES \nWHERE NOME LIKE ‘F’ \nORDER BY NOME”  
-

Ou algo parecido com isso, o que é bem feio e sabemos o quanto isso se torna impossível de dar manutenção no futuro. Mas em Ruby podemos fazer um pouco melhor que isso:

* * *
ruby

\>\> nome = “F”  
=\> “F”  
\>\> query = \<\<-STR  
SELECT \* FROM NOMES  
WHERE NOME LIKE ‘#{nome}’  
ORDER BY NOME  
STR  
=\> " SELECT \* FROM NOMES\n WHERE NOME LIKE ‘F’\n ORDER BY NOME\n"  
-

Onde está “STR” na realidade pode ser qualquer palavra em letras maiúsculas, tomando o cuidado para não ter espaços em branco nem antes nem depois do “STR” da última linha. Aproveitando os comentários do Tapajós e do Hugo, existem mais algumas maneiras e fazer isso:

* * *
ruby

\>\> nome = “F”  
=\> “F”  
\>\> query = {SELECT \* FROM NOMES  
WHERE NOME LIKE ’#{nome}%’  
ORDER BY NOME}  
=\> “SELECT \* FROM NOMES\n WHERE NOME LIKE ‘F’\n ORDER BY NOME”  
-

E também desta maneira:

* * *
ruby

\>\> nome = “F”  
=\> “F”  
\>\> query = Q(SELECT \* FROM NOMES  
WHERE NOME LIKE ’#{nome}%’  
ORDER BY NOME)  
=\> “SELECT \* FROM NOMES\n WHERE NOME LIKE ‘F’\n ORDER BY NOME”  
-

Todas as maneiras acima são jeitos de se criar strings de múltiplas linhas com a possibilidade de execução e substituição in-place usando “#{}”. Eu particularmente prefiro fazer alguma coisa do tipo:

* * *
ruby

\>\> nome = “F”  
=\> “F”  
\>\> query = q(SELECT \* FROM NOMES  
WHERE NOME LIKE ’[nome]%’  
ORDER BY NOME)  
=\> “SELECT \* FROM NOMES\n WHERE NOME LIKE ‘[nome]’\n ORDER BY NOME”

\>\> query.gsub!(‘[nome]’, nome)  
=\> “SELECT \* FROM NOMES\n WHERE NOME LIKE ‘F’\n ORDER BY NOME”  
-

A sintaxe de “%q()” também permite criar strings de múltiplas linhas mas não suporta a execução de código via “#{}”, por isso coloquei algo que possa encontrar depois (um “placeholder”) como “[nome]” e no final uso o método “gsub” que faz substituição em Strings. Eu disse que “prefiro” mais para separar explicitamente as substituições fora do String. Mas, novamente, existem diversas maneiras de realizar essa mesma tarefa, depende do que você precisa fazer.

**Disclaimer:** nunca crie consultas SQL da forma como mostrei acima. Se você apenas concatenar o valor que foi passado pelo usuário diretamente no comando SQL que vai executar, seu código estará automaticamente vulnerável à [SQL Injection](http://en.wikipedia.org/wiki/SQL_injection). Esse é o erro mais comum que todo desenvolvedor Web novato comete. Então cuidado! Para isso servem pacotes como ActiveRecord, que abstraem o SQL nativo e realizam as checagens mais comuns antes de criar o SQL.

### Symbols

Note que na seção sobre Hashes, criamos um pequeno dicionário ligando uma palavra em inglês à sua tradução em português. Para isso usamos objetos String tanto para os valores quanto para as chaves, por exemplo:

* * *
ruby

dic1 = { “leg” =\> “perna” }  
-

Mas você vai notar que em Ruby e principalmente no Rails, não costumamos usar Strings como chaves. Em vez disso usamos Symbols:

* * *
ruby

dic2 = { :leg =\> “perna” }  
-

Quero dizer, não é proibido usar Strings, mas se não precisar, prefira usar Symbols. Existem dois motivos para isso: o primeiro é porque symbols são mais legíveis e fáceis de visualizar, a segunda é economia de memória.

Em poucas palavras, um Symbol sempre gera um objeto Singleton imutável. Por exemplo:

* * *
ruby

\>\> a = :leg  
=\> :leg  
\>\> b = :leg  
=\> :leg  
\>\> a.object\_id  
=\> 531778  
\>\> b.object\_id  
=\> 531778  
-

Note como atribuímos :leg às variáveis “a” e “b”. Chamando o método “object\_id”, ambas respondem o mesmo ID, denotando que as duas variáveis estão apontando ao mesmo objeto Symbol. Vejamos o mesmo exemplo usando Strings:

* * *
ruby

\>\> a = “leg”  
=\> “leg”  
\>\> b = “leg”  
=\> “leg”  
\>\> a.object\_id  
=\> 11823830  
\>\> b.object\_id  
=\> 11820130  
-

Note como os dois IDs vieram diferentes. Ou seja, apesar do conteúdo ser o mesmo, as variáveis “a” e “b” estão apontando para objetos String diferentes. A primeira impressão é que são o mesmo objeto, mas na realidade são dois objetos distintos que por acaso tem o mesmo conteúdo. Espero que tenha ficado claro porque Symbols consomem menos memória que Strings.

Existem vários outros objetos singleton em Ruby. Números é um deles, afinal não faz sentido existir mais de um número “1”. O mesmo vale para objetos booleanos. Por exemplo:

* * *
ruby

\>\> a = 1  
=\> 1  
\>\> b = 1  
=\> 1  
\>\> c = true  
=\> true  
\>\> d = true  
=\> true

\>\> a.object\_id == b.object\_id  
=\> true  
\>\> c.object\_id == d.object\_id  
=\> true  
-

Na prática, sempre use Symbols como chaves de Hash. É onde eles são mais usados. Em Ruby on Rails, o pacote ActiveSupport consegue traduzir Hashes com chaves em String para Symbols, desta forma:

* * *
ruby

\>\> require ‘rubygems’  
=\> []  
\>\> require ‘activesupport’  
=\> []  
\>\> params = { “nome” =\> “Fabio”, “sobrenome” =\> “Akita” }  
=\> {"nome"=\>"Fabio", “sobrenome”=\>"Akita"}  
\>\> params.symbolize\_keys!  
=\> {:nome=\>"Fabio", :sobrenome=\>"Akita"}  
\>\> params[:nome]  
=\> “Fabio”  
\>\> params[:sobrenome]  
=\> “Akita”  
-

## Métodos em Ruby

Depois de tudo isso, podemos ir um pouco além. Em Ruby temos maneiras muito diferentes de se escrever métodos. Em linguagens estáticas, como Java, temos o conceito de [overloading](http://en.wikipedia.org/wiki/Method_overloading). Por exemplo:

* * *
java

public class Pessoa {  
 String nome;  
 String email;

public Pessoa(String nome, String email) { this.nome = nome; this.email = email; } public Pessoa(String nome) {

this(nome, "");  
 }  
}  
-

Esse trecho define a classe “Pessoa” com dois construtores. Dessa forma podemos instanciar uma nova Pessoa da seguinte forma:

* * *
java

Pessoa fabio = new Pessoa(“Fabio”, “fabio@foo.com.br”);  
Pessoa akita = new Pessoa(“Akita”);  
-

Ou seja, o parâmetro “email” é opcional. Dependendo se passamos ou não esse parâmetro, um dos dois construtores será chamado.

Porém, esse tipo de construção pode começar a ficar extremamente tedioso quando temos muitos parâmetros opcionais. Em Ruby temos algumas maneiras diferentes de lidar com isso. Para começar vejamos uma maneira simples:

* * *
ruby

class Pessoa  
 def initialize(nome, email = "")  
 @nome, @email = nome, email  
 end  
end  
-

Duas novidades: primeiro que um método suporta valores padrão. Dessa forma, se nada for passado no segundo parâmetro, ele assume o padrão vazio "", conforme descrevemos acima. Segundo, é possível fazer atribuição em massa. Acredito que esteja bastante óbvio entender apenas lendo o trecho acima.

Outra maneira:

* * *
ruby

class Pessoa  
 def initialize(nome, \*args)  
 @nome = nome  
 @args = args  
 end  
 def args  
 @args  
 end  
end

\>\> fabio = Pessoa.new(“Fabio”, “fabio@foo.com.br”, “6666-6666”)  
=\> #\<Pessoa:0×26ee61c `args=["fabio`foo.com.br", “6666-6666”], `nome="Fabio">
>> fabio.args.first
=> "fabio`foo.com.br"  
\>\> fabio.args.last  
=\> “6666-6666”  
-

O que temos no contrutor acima, o “\*”, é o “splat”. Pense nele como um buraco-negro: depois do parâmetro normal “nome”, tudo que vier depois será literalmente sugado para dentro da variável “args”. A resultante disso será um Array. Isso permite um método que tenha capacidade para infinitos argumentos. Outro exemplo de uso é este:

* * *
ruby

def soma(\*args)  
 args.inject(0) { |elem, total| total += elem }  
end

\>\> soma(2,2)  
=\> 4  
\>\> soma(1,2,3,4)  
=\> 10  
\>\> soma(100,200,300)  
=\> 600  
-

Felizmente já explicamos para que serve o “inject”. Resumindo: esse método somará todos os elementos passados como parâmetros, independente de quantos forem. E ainda podemos fazer mais: passar um array expandindo seus elementos para serem parâmetros:

* * *
ruby

\>\> items = [1,2,3,4,5,6]  
=\> [1, 2, 3, 4, 5, 6]  
\>\> soma \*items  
=\> 21  
-

Se passássemos o array “items” sem o splat para expandí-lo, o array inteiro seria considerado um único elemento do array “args” dentro do método, não dando o efeito esperado, veja:

* * *
ruby

\>\> soma items  
TypeError: can’t convert Fixnum into Array  
 from (irb):31:in `+’  
 from (irb):31:in `soma’  
 from (irb):40:in `inject’  
 from (irb):31:in `each’  
 from (irb):31:in `inject’  
 from (irb):31:in `soma’  
 from (irb):40  
-

Outra situação é quando temos métodos com um número muito grande de parâmetros opcionais. No Ruby on Rails temos exemplos como este:

* * *
ruby

\>\> Person.find :first, :conditions =\> { :nome =\> “Fabio” }, :order =\> :nome  
=\> SELECT \* FROM “people” WHERE (“people”.“nome” = ‘Fabio’) ORDER BY nome LIMIT 1  
-

Qualquer um que já tenha lidado com SQL sabe que montar consultas pode ser bastante complexo. Criar um único método que cuide disso numa linguagem estático é impossível. Se tentar criar um conjunto de métodos via overloading como vimos antes, também será um trabalho homérico e totalmente fútil.

Vejamos como é definido o método “find” da classe “ActiveRecord::Base”

* * *
ruby

def find(\*args)  
 options = args.extract\_options!  
 validate\_find\_options(options)  
 set\_readonly\_option!(options)

case args.first when :first then find\_initial(options) when :last then find\_last(options) when :all then find\_every(options) else find\_from\_ids(args, options) end

end  
-

O método “find” por si só é somente um envelope que chama outros métodos. Ele recebe nada mais, nada menos que um Array, usando o splat como mostramos antes. Logo na primeira linha ele usa um método interno do Rails para extrair tudo que é considerado “options”, no caso, elementos de um Hash.

Dependendo do primeiro argumento, ele repassa o Hash a métodos como “find\_initial”, “find\_last”, etc. No caso, o Hash em questão é o seguinte:

* * *
ruby

options = { :conditions =\> { :nome =\> “Fabio” }, :order =\> :nome }  
-

Vejamos um exemplo mais simples de um método com um parâmetro obrigatório e uma lista de parâmetros opcionais:

* * *
ruby

class Pessoa  
 attr\_accessor :primeiro\_nome, :sobrenome, :iniciais, :email  
 def initialize(primeiro\_nome = "", options = {})  
 @primeiro\_nome = primeiro\_nome  
 @sobrenome = options[:sobrenome]  
 @iniciais = options[:iniciais]  
 @email = options[:email]  
 end  
end

\>\> fabio = Pessoa.new(“Fabio”, :sobrenome =\> “Akita”, :iniciais =\> “FMA”)  
=\> #\<Pessoa:0×26b2c98 @iniciais=“FMA”, @sobrenome=“Akita”, @email=nil, @primeiro\_nome="Fabio"\>  
\>\> fabio.primeiro\_nome  
=\> “Fabio”  
\>\> fabio.sobrenome  
=\> “Akita”  
\>\> fabio.iniciais  
=\> “FMA”  
\>\> fabio.email  
=\> nil  
-

Caso não saiba, o método “attr\_accessor” serve para criar métodos equivalentes a “getters” e “setters” de Java ou C#. Como já falamos em seções anteriores, classes Ruby podem ser modificadas em tempo de execução. Veremos isso depois, por enquanto vejamos o construtor novamente. Depois do primeiro parâmetro, temos o familiar uso do par chave e valor. O que pode parece estranho é que talvez alguém estivesse esperando algo assim:

* * *
ruby

fabio = Pessoa.new(“Fabio”, {:sobrenome =\> “Akita”, :iniciais =\> "FMA"})  
-

Novamente, as chaves “{}” são opcionais: os últimos parâmetros, sendo pares com a sintaxe de “rocket” (“=\>”) são tratados como elementos do mesmo Hash e todos são “sugados” para o parâmetro “options” no método construtor. Retirando tudo que é opcional, a chamada poderia ficar simplesmente assim:

* * *
ruby

fabio = Pessoa.new “Fabio”, :sobrenome =\> “Akita”, :iniciais =\> “FMA”   
-

E assim temos algumas maneiras para criar métodos bastante flexíveis. Obviamente, aqui cabe cuidados sobre como planejar seus métodos. Fica muito fácil criar métodos que fazem mais do que deveriam dessa forma. Assim como mostramos acima com o método “find” tente criar métodos enxutos, que delegam a execução a outros métodos mais especializados, por exemplo.

## Métodos Dinâmicos

Vejamos mais sobre o método “attr\_accessor”:

* * *
ruby

class Pessoa  
 attr\_accessor :nome, :email  
end

\>\> fabio = Pessoa.new  
=\> #\<Pessoa:0×26a6f24 @iniciais=nil, @sobrenome=nil, @email=nil, @primeiro\_nome=""\>  
\>\> fabio.nome = “Fabio”  
=\> “Fabio”  
\>\> fabio.nome  
=\> “Fabio”  
-

Podemos reimplementar nossa própria versão simplificada de “attr\_accessor” desta maneira:

* * *
ruby

class Object  
 def my\_accessor( \*symbols )  
 symbols.each do |symbol|  
 module\_eval( “def #{symbol}() @#{symbol}; end” )  
 module\_eval( “def #{symbol}=(val) @#{symbol} = val; end” )  
 end  
 end  
end

class Pessoa  
 my\_accessor :telefone  
end

\>\> fabio = Pessoa.new  
=\> #\<Pessoa:0×2690f30 @iniciais=nil, @sobrenome=nil, @email=nil, @primeiro\_nome=""\>  
\>\> fabio.telefone = “6666-6666”  
=\> “6666-6666”  
\>\> fabio.telefone  
=\> “6666-6666”  
-

Abrindo a classe Object significa que nosso método “my\_accessor” estará disponível a qualquer classe do Ruby, já que todos herdam de Object. Esse método recebe um array de symbols, como já descrevemos antes. Daí usamos “each” para iterar symbol a symbol, e para cada um chamamos “module\_eval” que simplesmente executa qualquer String passado a ele, no caso criamos dinamicamente dois métodos, os equivalente a “getter” e “setter”. Para o exemplo :telefone, seria o mesmo que escrevêssemos:

* * *
ruby

class Pessoa  
 def telefone() @telefone; end  
 def telefone=(val) @telefone = val; end  
end  
-

Muita gente confunde “meta-programação” com “reflexão”. Reflexão é apenas perguntar a um objeto o que ele responde. Podemos fazer isso em Ruby de várias maneiras:

* * *
ruby

\>\> a = “string”  
=\> “string”  
\>\> a.methods  
=\> [“chop!”, “constantize”, … “squish”, “\<\<”]  
\>\> a.respond\_to? :size

\>\> p = Pessoa.new  
=\> #\<Pessoa:0×261af60 `iniciais=nil, @sobrenome=nil, @email=nil, @primeiro_nome="">
>> p.telefone
=> nil
>> p.instance_variable_set("`telefone", “3333-4444”)  
=\> “3333-4444”  
\>\> p.instance\_variable\_get(“@telefone”)  
=\> “3333-4444”  
-

Aqui vemos como todo objeto Ruby tem um método chamado “methods” que devolve um Array listando todos os métodos que ele responde. Além disso todo objeto Ruby ainda responde ao método “respond\_to?” que recebe um symbol como parâmetro e responde se esse objeto responde a essa mensagem.

No exemplo seguinte, com a classe “Pessoa”, podemos ainda manipular diretamente a variável de instância “@telefone” sem sequer precisar de métodos acessores.

Como podemos ver, Reflexão em Ruby é trivial. Já vimos antes como funciona o método “send” para enviar mensagens arbitrárias e também como implementar o método “method\_missing” para fazer um objeto responder a mensagens arbitrárias. Mas com exemplos como do “attr\_accessor” podemos entender como manipular o comportamento de um objeto em tempo de execução.

Por isso dizemos que Ruby tem capacidades muito poderosas de meta-programação, que é o que o torna particularmente prazeroso de usar, sem precisar contar com sintaxes obscuras ou truques não documentados. Pensar em meta-programação faz parte do dia-a-dia de programação com Ruby.

## Indo além do Nulo

Como mais um exemplo da flexibilidade do Ruby, vamos analisar o bom o velho “nulo”. Note que nulo é realmente nada. Não é o mesmo que zero. Não é o mesmo que uma string vazia.

Em Ruby, estamos falando do ‘nil’. Porém, como quase tudo em Ruby é um objeto, assim também é ‘nil’:

* * *
ruby

\>\> nil  
=\> nil  
\>\> nil.class  
=\> NilClass  
\>\> nil.object\_id  
=\> 4  
-

Ou seja, quando um método não devolve nada, ou seja, ‘nil’, ainda assim ele está devolvendo alguma coisa: a instância singleton da classe NilClass.

Não é difícil cair em situações onde queremos chamar um método em um objeto onde ainda não sabemos se o objeto é nil ou não. Por isso costumamos fazer algo assim:

* * *
ruby

unless obj.nil?  
 obj.say\_hello  
else  
 nil  
end  
-

Aqui eu propositadamente fiz um código mais longo do que deveria, apenas para aproveitar e demonstrar o “unless”. Pense nele como o oposto de “if”. Em outras linguagens estamos acostumados a fazer algo assim:

* * *
ruby

if !obj.nil? …  
-

Ou seja, “se não for …”. Mas em vez disso, em Ruby preferimos dizer “a menos que …”. Fica menos poluído do que colocar “!” (“not”) o tempo todo. Além disso chamamos o método “nil?” que checa se o objeto atual é nulo ou não. Esse método “nil?” está presente direto da classe pai “Object”, portanto todos os objetos no Ruby respondem a esse método, em particular, como “nil” também é um objeto, ele também responde a esse método:

* * *
ruby

\>\> nil.nil?  
=\> true  
\>\> 1.nil?  
=\> false  
-

E eu disse que o código acima era mais longo do que o necessário porque sempre podemos usar o operador ternário (que também existe em outras linguagens):

* * *
ruby

obj ? obj.say\_hello : nil  
-

Ou seja, se “obj” devolver “true” (apenas “false” e “nil” respondem como “false” em condicionais), então chame o método “say\_hello”, caso contrário, devolva ‘nil’.

Como em qualquer objeto, se tentarmos chamar um método em ‘nil’ que não existe, ele responderá normalmente com uma exceção:

* * *
ruby

\>\> nil.size  
NoMethodError: undefined method `size’ for nil:NilClass  
 from (irb):91  
-

Um outro truque que [discutiu-se](http://ozmm.org/posts/try.html) algum tempo atrás é criar um novo método em Object chamado “try”:

* * *
ruby

class Object  
 def try(metodo, \*args)  
 send(metodo, \*args) if respond\_to? metodo  
 end  
end

\>\> "".try(:size)  
=\> 0  
\>\> nil.try(:size)  
=\> nil  
-

Em vez de chamar um método diretamente quando ainda não sabemos se o objeto é nil ou não, podemos chamar o método “try” passando a mensagem (o nome do método) e seus parâmetros. Se o objeto para onde enviamos a mensagem souber responder essa mensagem (respond\_to?), então repassamos normalmente, senão devolvemos nil.

Recomendo que teste todos esses exemplos no IRB para entender o comportamento. Esse tipo de pensamento é crucial na programação Ruby. Não quer dizer, claro, que agora devemos usar coisas como “try” o tempo todo, mas nas situações onde são necessárias, essa pode ser a diferença entre um código extremamente enxuto e expressivo do que um código burocrático e difícil de entender.

### Conclusão

Até aqui mostramos apenas a ponta do iceberg da programação com Ruby. Existem dezenas de classes que já vêm na biblioteca padrão do Ruby que vocês precisam saber, como Net, File, FileUtils e muitos outros. Use o site [ApiDock](http://apidock.com/) sempre que tiver dúvidas quanto à sintaxe de algum método. Lembre-se da questão de parâmetros dinâmicos, o que dificulta a documentação automática. Mas também lembre-se que o código-fonte de bibliotecas Ruby costumam ser muito simples de ler. Portanto recomendo muito que, na dúvida, procure o código-fonte (que já está na sua máquina) e tente ler direto na fonte.

E para ver alguns exemplos muito interessantes de resolução de problemas em Ruby, também recomendo ler o site [Ruby Quiz](http://rubyquiz.com/) que contém uma biblioteca enorme de pequenos problemas simples com soluções muito criativas usando os recursos de Ruby.

O mais importante: não tente escrever Ruby da mesma forma como se escreve Java ou C#. _“Quando se está em Roma, faça como os romanos.”_ Portanto, nada de usar “camelCasing” para nomear seus métodos, por exemplo, use “metodos\_separados\_por\_underscore”. Escreva Ruby da forma Ruby.

