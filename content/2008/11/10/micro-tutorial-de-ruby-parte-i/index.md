---
title: Micro-Tutorial de Ruby - Parte I
date: '2008-11-10T01:41:00-02:00'
slug: micro-tutorial-de-ruby-parte-i
tags:
- learning
- beginner
- ruby
- tutorial
draft: false
---

Depois de fazer várias palestras nas últimas semanas, uma coisa que notei é que a maioria das pessoas que está iniciando no Ruby, ou só ouviu falar de Rails, fica muito surpreso ao ver algumas das características da linguagem.

Este artigo é destinado aos iniciantes ou a quem começou a se interessar recentemente por Ruby e Rails. Antes de mais nada, quem já sabe um pouco de Ruby e quer alguma documentação sobre Rails, recomendo muito o novo site [Rails Guides](http://guides.rails.info), um esforço que se iniciou com o **Pratik Naik** e deu grandes frutos. Este site é um trabalho em constante evolução mas já concentra toneladas de guias sobre as principais funcionalidades do Rails. O Cassio, da DRC, também tem um PDF (e um screencast) disponível em [seu site](http://www.devlab.com.br/rails), que é uma atualização do material criado pelo Ronaldo Ferraz.

Meu objetivo nesta série de artigos é demonstrar algumas das características de Ruby que a tornam diferente de outras linguagens, principalmente as estáticas como Java ou C#.

**Disclaimer:** antes de mais nada, vale avisar que usarei alguns trechos de código Java apenas como referência para quem vem de linguagens tradicionais. Não considere isso uma comparação direta (pois os códigos estão propositadamente não otimizados ou simplificados por motivos didáticos).


## O que tem de diferente no Ruby?

Todos os códigos Ruby mostrados neste artigo podem ser testados no ambiente IRB (Interpreted Ruby). Com o Ruby já [instalado](http://rubyforge.org/frs/download.php/43428/ruby186-27_rc1.exe) em sua máquina, digite o comando ‘irb’ e você estará dentro do ambiente dinâmico do interpretador Ruby. Qualquer código Ruby será executado na hora, o que deve facilitar seus testes. Na realidade eu recomendo que à medida que leiam o artigo, digitem os códigos em Ruby no IRB e vejam vocês mesmos os resultados. Será bem mais educativo desta forma.

Para começar, vejam este código:

* * *
ruby

class Pessoa  
 def initialize(nome)  
 @nome = nome  
 end

def nome @nome end def nome=(valor) @nome = valor end

end

fabio = Pessoa.new(“Fabio”)   
puts fabio.nome  
-

Antes de mais nada, algumas explicações: o que outras linguagens chamam de funções ou métodos, em Ruby são definidas com ‘def … end’. Todo bloco de código termina com ‘end’.

Para colocar um método todo na mesma linha você poderia separar cada linha com “;” (ponto-e-vírgula):

* * *
rubydef nome; @nome; end—-

Para que um método retorne um valor, não é necessário usar a palavra ‘return’ como estamos acostumados. O resultado da última expressão de um método sempre é devolvida no retorno. Por exemplo, o método ‘nome’ acima tem apenas ‘@nome’, que é o equivalente a fazer ‘return @nome’. Use ‘return’ apenas se quiser sair do fluxo do método antes de chegar à linha final. Finalmente, variáveis de instância (algo como ‘this.nome’) são denotados com o prefixo ‘@’.

Para instanciar uma classe, basta chamar o método ‘new’ dela. Os parâmetros passados a esse método são repassados como argumentos ao método padrão ‘initialize’. E ‘puts’ é apenas algo parecido com ‘System.out.println()’. Parênteses são opcionais, só os use para eliminar ambigüidades na hora de chamar um método com parâmetros.

À primeira vista, o código acima não é diferente de algo semelhante em Java:

* * *
java

class Pessoa {  
 String nome;  
 public Pessoa(String nome) {  
 this.nome = nome;  
 }  
 public String getNome() {  
 return this.nome;  
 }  
 public void setNome(String nome) {  
 this.nome = nome;  
 }  
}

Pessoa fabio = new Pessoa(“Fabio”);  
System.out.println(fabio.getNome());  
-

Nem mesmo em número de linhas de código temos algum ganho. Olhando apenas dessa forma, para um iniciante, ficaria a pergunta: _Onde está a diferença? Apenas por não ter chaves?_

Bom, vejamos um outro exemplo – da mesma classe Ruby:

* * *
ruby

require ‘ostruct’  
class Pessoa \< OpenStruct; end

fabio = Pessoa.new :nome =\> “Fabio”  
puts fabio.nome

fabio.email = ‘akitaonrails@mac.com’  
puts fabio.email  
-

Bom, agora estamos começando a conversar! No caso acima eu confesso, trapaceei um pouco. Fiz a classe ‘Pessoa’ herdar a partir de uma classe padrão do Ruby, a ‘OpenStruct’. Ela permite que os objetos instanciados a partir dessa classe tenham qualquer atributo que for necessário em tempo de execução! Vou voltar neste ponto mais tarde, por enquanto apenas ignore a magia negra e continue.

Ruby suporta herança simples de classes, assim como em Java ou C#. O caracter ‘\<’ é o equivalente a ‘extends’ em Java.

Vamos a mais alguns exemplos simples:

* * *
ruby

\>\> 1 + 2  
=\> 3  
\>\> numero = 5  
=\> 5  
\>\> numero \* 3  
=\> 15

\>\> contador = 1  
=\> 1  
\>\> while contador \< numero  
\>\> puts contador  
\>\> contador += 1  
\>\> end  
1  
2  
3  
4

\>\> def hello  
\>\> “Hello World”  
\>\> end

\>\> puts hello  
Hello World  
-

**Obs:** quando você está no IRB, “\>\>” é o “prompt de comando” e “=\>” é o resultado do comando que você acabou de executar. Não confunda com o código Ruby propriamente dito.

Na primeira parte algumas operações simples. Em seguida um loop tradicional, com contador. Depois um pequeno método chamado “hello” e sendo executado. Acredito que, independente da linguagem de onde você veio, o que mostrei até agora é bastante familiar. Novamente, fica a pergunta: _“onde está a diferença?”_

## Quase tudo é Objeto

Ruby foi muito influenciado por **Smalltalk** , a verdadeira linguagem que inspirou quase todas as outras mais modernas de orientação-a-objetos. Não quero aqui começar nenhuma discussão sobre o que é ser OOP ou não pois argumentos desse tipo são irrelevantes aqui.

O que muitos costumam reclamar em linguagens tradicionais é o seguinte:

* * *
java

class Teste {  
 public static void main(String[] args) {  
 System.out.println(“Hello World”);  
 }  
}  
-

Muita coisa para fazer um simples “Hello World”. Agora vejamos o Hello World em Ruby:

* * *
ruby

puts “Hello World”  
-

_“Oras, mas Ruby não é OOP?? Cadê a classe!!?”_ Vamos entender o exemplo. Considerando que ainda estamos dentro do ambiente IRB, faça o seguinte:

* * *
ruby

\>\> puts “Hello World”  
Hello World  
=\> nil

\>\> self  
=\> main  
\>\> self.class  
=\> Object  
-

Em Ruby, “self” é _mais ou menos_ parecido com a função do “this” em Java ou outras linguagens. Mas como podem ver, nós já estamos **dentro** de um objeto, de uma instância de Object. Nunca estamos num ambiente estático ou não-objeto. Criar um método no IRB significa adicionar esse método ao objeto ‘main’ que, por sua vez é uma instância da classe Object.

Mas não é apenas isso, veja o seguinte:

* * *
ruby

\>\> 1.class  
=\> Fixnum

\>\> true.class  
=\> TrueClass

\>\> false.class  
=\> FalseClass

\>\> nil.class  
=\> NilClass  
-

Um número, um booleano (verdadeiro, falso) e até nulo (o “nil”) são objetos. Todos eles respondem a métodos, em especial o método “class” que indica de que classe esse objeto é instância. Note que até o nulo é uma instância da classe chamada “NilClass”.

## Classes Abertas

Uma coisa que não tem o que se fazer em muitas linguagens estáticas como Java é **mudar de idéia**. Toda a idéia de se ter interfaces e classes fechadas força o programador a decidir da primeira vez e ter que sobreviver às conseqüências de sua decisão, o que normalmente força ter que tomar a decisão certa logo no começo e incentiva o temido [Big Design Up Front](http://en.wikipedia.org/wiki/Big_Design_Up_Front).

Quando precisamos de mais funcionalidades nesses casos, precisamos improvisar. Por exemplo:

* * *
java

class StringUtils {  
 public static boolean isEmpty(String str) {  
 return str == null || str.length() == 0;  
 }  
}

String nome = “Fabio Akita”;  
StringUtils.isEmpty(nome);  
-

O método “isEmpty()”, disponível na classe StringUtils do pacote Commons do Jakarta, avalia se o string que ele recebeu como argumento é nulo ou vazio. Na classe original “java.lang.String” não existia o método “isEmpty()”. Isso não é um erro, apenas na época em que essa classe foi criada, não parecia óbvio a ninguém que um método assim poderia ser útil. Mas agora, a classe String é fechada e não pode ser reimplementada. Também não adianta criar uma classe MyString que herda de String porque todas instâncias de String não terão as novas funcionalidades do MyString.

Portanto a solução-gambiarra significa criar uma classe separada “StringUtils”, com vários métodos estáticos, como o “isEmpty()”, o que efetivamente significa programação procedural e não-orientada a objetos. StringUtils é apenas uma estrutura com um punhado de métodos estáticos.

Em Ruby, podemos o mesmo problema resolver desta forma:

* * *
ruby

class String  
 def empty?  
 self.nil? || self.size == 0  
 end  
end

nome = “Fabio Akita”  
nome.empty?  
-

Nesse caso específico nem precisaríamos fazer isso porque o método “empty?” já existe na String de Ruby, mas está aí apenas para ilustrar o problema.

Temos algumas coisas interessantes aqui. Primeiro, o nome do método pode parecer estranho por causa da interrogação no final. Mas não se assustem, em Ruby isso é um caracter válido num nome de método e não tem nenhum efeito colateral, é apenas um caracter a mais que expressa a intenção do método, no caso, de fazer uma pergunta ao objeto.

Mas o mais importante: hoje estamos decidindo que a classe String deveria ter mais métodos do que ele já tem. Felizmente, graças às características da linguagem, não estamos presos a uma classe fechada: podemos reabrí-la, reimplementá-la como quisermos e, automaticamente, toda instância de String (novas e inclusive as que já existiam), passam a responder à nova implementação.

Vejamos outro exemplo de orientação a objetos mesclado com “eye candy”.

* * *
ruby

\>\> 1 + 2  
=\> 3  
-

Vamos lembrar do básico: números, em Ruby, são objetos, mais especificamente instâncias da classe Fixnum. Agora vejamos outra maneira de escrever a mesma coisa em Ruby, sem “eye candy”:

* * *
ruby

\>\> 1.+(2)  
=\> 3  
-

Espero que isso esteja claro: quando somamos dois números, na realidade estamos _chamando o método especial_ “+” do objeto “1” e passando como argumento o objeto “2”. E isso vale para todos os operadores matemáticos que conhecemos como “-”, “/”. Mas o que acontece quando tentamos somar dois objetos incompatíveis?

* * *
ruby

\>\> 1 + “2”  
TypeError: String can’t be coerced into Fixnum  
 from (irb):35:in `+’  
 from (irb):35

\>\> 1.<ins>(“s”)<br>
TypeError: String can’t be coerced into Fixnum<br>
	from (irb):36:in `</ins>’  
 from (irb):36  
-

Escrevi as duas maneiras novamente: passar um String como parâmetro ao método “+” de um Fixnum devolve uma exceção “TypeError” indicando que a operação é inválida. Mas digamos que, apenas por motivos didáticos, eu realmente queira que o Ruby reaja como Javascript ou Perl e que “1” seja convertido em String e depois concatenado ao parâmetro “2”, resultando em “12”.

* * *
ruby

\>\> class Fixnum  
\>\> alias :soma\_velha :+  
?\> def +(valor)  
\>\> return self.to\_s + valor if valor.is\_a? String  
\>\> soma\_velha(valor)  
\>\> end  
\>\> end  
=\> nil

\>\> 1 + 2  
=\> 3  
\>\> 1 + “2”  
=\> “12”  
-

Várias coisas acontecendo aqui. Vejamos os principais pontos: primeiro, estamos reabrindo a classe Fixnum, ou seja, todas as instâncias dessa classe serão afetadas automaticamente pelo que faremos a seguir.

Depois, mais uma novidade: o método ‘alias’. Esse é um método de classe que cria um novo apontamento a um método que já existe. Pense em algo assim: você tem ‘a = foo’ e depois ‘b = a’. Agora, tanto ‘a’ quanto ‘b’ apontam para o mesmo objeto ‘foo’.

Outra coisa: quando uma classe é criada, reaberta ou ‘executada’ os métodos chamados dentro dela são executados. Ou seja, o comando ‘alias’, por exemplo, serve para reapontar um método com outro nome. No exemplo, já existia o método chamado “+” e com “alias” criamos um segundo método chamado “soma\_velha” que aponta para a mesma implementação do método original. Ou seja, neste ponto as três chamadas a seguir se equivalem:

* * *
ruby

\>\> 5 + 10  
=\> 15

\>\> 5.+(10)  
=\> 15

\>\> 5.soma\_velha(10)  
=\> 15  
-

Mas fizemos mais: depois de criar o novo apontamento “soma\_velha” reimplementamos o método antigo “+”. A idéia é: se o parâmetro for um String, quero transformar o objeto Fixnum num String e depois concatenamos os dois. Veja como usamos o ‘return’ para retornar imediatamente caso este seja o caso. Senão, se o argumento passado não for um String, passamos para o método ‘soma\_velha’ fazer a soma do jeito antigo.

Note também que usamos o ‘if’ de uma forma um pouco diferente: no fim da expressão:

* * *
ruby

return self.to\_s + valor if valor.is\_a? String  
-

‘is\_a?’ é um método que está sem os parênteses (lembram-se? são opcionais) e serve para verificar o tipo do objeto ‘valor’. Literalmente podemos ler assim: “retorne self.to\_s concatenado com ‘valor’ se for do tipo String.” Se você entende inglês verá que a expressão é praticamente uma frase.

E é isso que acontece agora quando tentamos somar um número com um string: ele retorna a concatenação de dois Strings. Note também que esse comportamento passa a valer para todos os objetos numéricos (instâncias de Fixnum).

Esse conceito de reabrir uma classe e implementar uma nova funcionalidade ficou conhecido com o nome de [monkey patching](http://en.wikipedia.org/wiki/Monkey_patch). É um recurso muito poderoso e, como tudo que é poderoso ele pode ser tanto uma grande vantagem como um grande risco se usado da maneira errada. Espera-se, claro, que o programador não abuse disso.

O framework Ruby on Rails faz muito uso desse recurso. Um dos pacotes que compõe o Rails chama-se Active Support e uma de suas utilidades é justamente reabrir diversas classes padrão do Ruby para incorporar mais funcionalidades. Por exemplo:

* * *
ruby
1. carrega o pacote activesupport  
\>\> require ‘rubygems’  
\>\> require ‘activesupport’  
=\> true

1. horário atual  
\>\> Time.now  
=\> Wed Oct 29 23:36:24 -0200 2008

1. fazendo cálculos com datas  
\>\> Time.now – 23.days  
=\> Mon Oct 06 23:36:28 -0300 2008

\>\> 2.weeks.ago  
=\> Wed Oct 15 23:36:32 -0200 2008

1. fazendo cálculos com unidades de medida  
\>\> (1.gigabyte – 512.megabytes) / 1.kilobyte  
=\> 524288

1. transformando objetos em XML  
\>\> { :html =\> { :body =\> { :p =\> “teste” } } }.to\_xml  
=\> “\<?xml version=”1.0" encoding=“UTF-8”?\>\n  
<hash>\n \n \n <br>
<p>teste</p>\n \n \n<br>
</hash>\n"  
-

Como podem ver, podemos incrementar muito as funcionalidades de tudo que já existe. O Ruby on Rails começa exatamente assim: primeiro incorporando muitas coisas novas ao próprio Ruby e depois construindo sobre ela. Muitos são casos onde simplesmente depender de criar novas sub-classes não adiantaria muita coisa. Outro exemplo: em Java, se quisermos comparar o conteúdo de dois Strings, não devemos fazer isso:

* * *
java

String a = “foo”;  
String b = “bla”;  
if (a == b) {  
 System.out.println(“encontrado!”);  
}  
if (a \> b) {  
 System.out.println(“a maior do que b”);  
}  
-

O correto seria assim:

* * *
java

if (a.equals(b)) {  
 System.out.println(“encontrado!”);  
}  
if (a.compareTo(b) \> 0) {  
 System.out.println(“a maior do que b”);  
}  
-

Já, em Ruby, fazemos assim:

* * *
ruby

a = “foo”  
b = “bla”  
puts “encontrado!” if a == b  
puts “a maior do que b” if a \> b  
-

Exatamente como imaginaríamos que deveria ser. Isso porque “==” e “\>” são ‘operadores’ mas são também nomes de métodos, como explicamos acima. Então fica fácil implementar o comportamento que precisamos da maneira mais clara e expressiva possível.

### Módulos e Organização

No exemplo do Fixnum, reabrimos diretamente a classe para colocar novas funcionalidades. Mas podemos fazer diferente:

* * *
ruby

Fixnum.class\_eval do  
 alias :soma\_velha :+  
 def +(valor)  
 return self.to\_s + valor if valor.is\_a? String  
 soma\_velha(valor)  
 end  
end  
-

Como a classe “Fixnum” é por si mesmo um objeto, podemos chamar métodos nela. Por exemplo, “new” é um método dessa instância de Class. O que fizemos acima é a mesma coisa que fizemos antes, mas esse código podemos colocar dentro um método, para ser executado somente quando quisermos. Ou seja, podemos alterar o comportamento de uma classe programaticamente. Mas podemos ser ainda mais seletivos:

* * *
ruby

\>\> a = “teste”  
=\> “teste”  
\>\> a.instance\_eval do  
?\> def hello  
\>\> “hello from teste”  
\>\> end  
\>\> end  
=\> nil  
\>\> a.hello  
=\> “hello from teste”  
\>\> “foo”.hello  
NoMethodError: undefined method `hello’ for [foo](String)  
 from (irb):17  
 from :0  
-

Veja agora: criamos um String na variável “a”. Então modificamos essa instância acrescentando um método chamado “hello”, mas somente a essa instância. Quando chamamos “a.hello” ele responde como esperamos, mas quando pegamos uma nova instância de String e tentamos chamar o mesmo método, vemos que não existe. Ou seja, podemos modificar o comportamento de todos os objetos de uma classe, ou somente de um único objeto individual.

Agora vejamos um outro meio de injetar código em classes de maneiras mais organizadas:

* * *
ruby

module MeusPatches  
 def say\_hello  
 “Hello World!”  
 end

def say\_time Time.now end

end

class Fixnum  
 include MeusPatches  
end

class String  
 extend MeusPatches  
end  
-

Módulos são como Classes que não podem ser instanciadas. No exemplo acima, organizamos dois métodos dentro de um módulo chamado “MeusPatches”. Em seguida reabrimos as classes “Fixnum” e “String”. No primeiro incluímos o módulo e no segundo extendemos o módulo. Para entender a diferença vamos usar isso:

* * *
ruby

\>\> 13.say\_hello  
=\> “Hello World!”

\>\> "".say\_hello  
NoMethodError: undefined method `say\_hello’ for "":String  
 from (irb):19

\>\> String.say\_hello  
=\> “Hello World!”  
-

O objeto “13” (que é instância de Fixnum) responde ao método do módulo. A string vazia "" não responde. Eis a diferença entre “include” e “extend”: no segundo quem responde ao método do módulo é a própria classe. Na prática, pense que “include” serve para acrescentar métodos de instância e “extend” para acrescentar “métodos de classe” – esse não é o termo correto mas para a maioria dos casos serve.

No Ruby on Rails esse recurso é muito usado, principalmente para organizar códigos de classes muito longas. Por exemplo, o ActiveRecord tem centenas de funcionalidades. Colocar tudo numa única classe seria muito difícil de manter depois, por isso ele se organiza desta forma:

* * *
ruby
1. ActiveRecord::Base.class\_eval do  
 extend ActiveRecord::QueryCache  
 include ActiveRecord::Validations  
 include ActiveRecord::Locking::Optimistic  
 include ActiveRecord::Locking::Pessimistic  
 include ActiveRecord::AttributeMethods  
 include ActiveRecord::Dirty  
 include ActiveRecord::Callbacks  
 include ActiveRecord::Observing  
 include ActiveRecord::Timestamp  
 include ActiveRecord::Associations  
 include ActiveRecord::NamedScope  
 include ActiveRecord::AssociationPreload  
 include ActiveRecord::Aggregations  
 include ActiveRecord::Transactions  
 include ActiveRecord::Reflection  
 include ActiveRecord::Calculations  
 include ActiveRecord::Serialization  
end  
-

Cada um dos includes acima tem um arquivo separado. Por exemplo ActiveRecord::QueryCache fica no arquivo “active\_record/query\_cache.rb”. É uma excelente maneira de organizar seus códigos. Mas existem alguns truques importantes de se conhecer. Uma delas é entender que módulos tem “eventos”. Ou seja, podemos instruir o módulo para executar alguma coisa toda vez que for incluso em alguma classe.

* * *
ruby

module MeusPatches  
 def self.included(base)  
 base.send(:extend, ClassMethods)  
 puts “Module MeusPaches incluso na classe #{base.name}”  
 end

def metodo\_de\_instancia “sou um metodo de instancia” end module ClassMethods def self.extended(base) puts “Module MeusPatches::ClassMethods extendido na classe #{base.name}” end def metodo\_de\_classe “sou um metodo de classe” end end

end

class Pessoa  
end

?\> Pessoa.send(:include, MeusPatches)  
Module MeusPatches::ClassMethods extendido na classe Pessoa  
Module MeusPaches incluso na classe Pessoa  
=\> Pessoa  
\>\>   
?\> fabio = Pessoa.new  
=\> #<pessoa:0x1789528><br>
&gt;&gt; fabio.metodo_de_instancia<br>
=&gt; “sou um metodo de instancia”<br>
&gt;&gt; <br>
?&gt; Pessoa.metodo_de_classe<br>
=&gt; “sou um metodo de classe”<br>
<del>-</del></pessoa:0x1789528>

Você vai entender o que significa “send” na próxima seção. Apenas entenda a seguinte idéia: criamos um módulo chamado “MeusPatches” e um sub-módulo dentro dele chamado “ClassMethods” (poderia ser outro nome, mas só para padronizar). Os métodos do módulo principal ficam disponíveis às instâncias dos objetos e os métodos do sub-módulo ficam disponíveis como métodos de classe. A sequência é assim:

1. primeiro definimos o módulo MeusPatches e seu sub-módulo ClassMethods
2. definimos a classe Pessoa, uma classe vazia
3. incluímos o módulo MeusPatches à classe Pessoa
4. o método self.included é ativado que, por sua vez, manda extender o sub-módulo ClassMethods na classe Pessoa (que é passado como o parâmetro “base”)
5. agora a classe Pessoa ganhou os métodos de instância e de classe
6. criamos a instância “fabio” e chamamos o método “metodo\_de\_instancia”
7. chamamos o método “metodo\_de\_classe” diretamente da classe Pessoa

Se fôssemos reescrever a classe Pessoa sem o recurso de módulos, ela ficaria assim:

* * *
ruby

class Pessoa  
 def metodo\_de\_instancia  
 “sou um metodo de instancia”  
 end

def self.metodo\_de\_classe “sou um metodo de classe” end

end  
-

Criar um método a partir de “self” significa que o método está disponível apenas à classe e não às suas instâncias. Novamente, para ser mais fácil de comparar, pense em métodos estáticos de classe como em Java. Mas entenda que não é a mesma coisa: em Java ou C# as classes são estruturas estáticas, em Ruby a própria classe é um objeto (pois ela é instância da classe “Class”). Outra maneira de escrever a mesma coisa seria:

* * *
ruby

class Pessoa  
 def metodo\_de\_instancia  
 “sou um metodo de instancia”  
 end

class \<\< self def metodo\_de\_classe “sou um metodo de classe” end end

end  
-

A diferença é que em vez de escrever “def self.” o tempo todo, podemos simplesmente reabrir a metaclasse da classe Pessoa e escrever todos os métodos “localmente” ali dentro. Em ambos os casos a classe vai se comportar da seguinte forma:

* * *
ruby

\>\> p = Pessoa.new  
=\> #<pessoa:0x1775370></pessoa:0x1775370>

\>\> p.metodo\_de\_instancia  
=\> “sou um metodo de instancia”

\>\> p.metodo\_de\_classe  
NoMethodError: undefined method `metodo\_de\_classe’ for #<pessoa:0x1775370><br>
	from (irb):94</pessoa:0x1775370>

\>\> Pessoa.metodo\_de\_instancia  
NoMethodError: undefined method `metodo\_de\_instancia’ for Pessoa:Class  
 from (irb):95

\>\> Pessoa.metodo\_de\_classe  
=\> “sou um metodo de classe”  
-

Não perca a Parte II deste artigo para entender o básico da linguagem Ruby. Espero que até aqui tenha ficado bastante claro que não devemos tentar codificar Ruby da mesma forma que codificamos em outras linguagens estáticas. Tirem proveito do dinamismo dessa linguagem, é assim que fazemos o “The Ruby Way”.

Continue lendo a [Parte II](/2008/11/10/micro-tutorial-de-ruby-parte-ii)

