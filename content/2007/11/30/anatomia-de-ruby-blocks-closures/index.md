---
title: Anatomia de Ruby Blocks/Closures
date: '2007-11-30T10:59:00-02:00'
slug: anatomia-de-ruby-blocks-closures
tags:
- learning
- beginner
- ruby
draft: false
---

Continuando minha série de artigos para o [RubyLearning](http://rubylearning.com/) resolvi escrever sobre blocos e fechamentos, como foi sugerido nos comentários do meu [artigo anterior](http://www.akitaonrails.com/2007/11/26/ruby-symbols). O Satish Talim [acabou de postar](http://rubylearning.com/blog/2007/11/30/akitaonrails-on-anatomy-of-ruby-blocksclosures/) esse artigo e aqui eu publico a versão em português.

Blocos/Fechamentos é um assunto bastante complexo e controverso, principalmente quando nos deparamos com puristas xiitas. Ruby é 100% OOP. Essa é a definição, porém há as letras miúdas _“… menos blocos de código …”_. Para blocos de código precisamos ‘encapsulá-la’ numa jaqueta de objeto, esses são os Ruby Blocks.

Definitivamente não sou nenhum guru do Ruby como Hal Fulton ou David Black, mas espero que o texto seja explicativo o suficiente para elucidar as principais dúvidas. Eu não me ative aos conceitos acadêmicos de fechamentos porque não achei relevante ao uso prático.

Vamos ao artigo:

### Anatomia de Blocks/Closures em Ruby

Não existe um Rubismo mais difícil de explicar do que um Closure (Fechamento). Poderia escrever um livro inteiro só sobre isso. Em vez de entediar todos com teoria acadêmica, tentarei focar somente no que realmente importa para o dia a dia.

Começamos com um exemplo:

* * *

```ruby
for i in [1,2,3,4]  
 puts i  
end

a = 0  
b = [1,2,3,4]  
while a \< b.length  
 puts b[a]  
 a += 1  
end  
```

Esses são iteradores simples, similares com o que temos em várias linguagens. O primeiro usa ‘for’ e o segundo o familiar ‘while’. Nada demais aqui. Mas vejamos outra maneira de chegar ao mesmo resultado em Ruby:

* * *

```ruby
ruby { |i| puts i } do |i| puts i

end 
```

Nada mal, simples e elegante, mas é aqui que muitos engasgam. A notação de pipes (barra vertical) é particularmente ameaçadora para iniciantes. Ambas as notações de chaves e do..end definem um pedaço de código fechado que chamamos de ‘blocks’ (blocos) ou ‘closures’ (fechamentos). O que fica entre os pipes é como parâmetros de um método. Ele ‘parece’ como este pseudo-código:

* * *

```ruby
def unnamed_method(i)  
 puts i  
end
```

* * *

Isto não é um código Ruby válido, claro. É similar com o que podemos fazer em C# com delegates. Temos algo similar em Javascript (usando a biblioteca [Prototype](http://www.prototypejs.org/api/enumerable/each) library):

* * *

```js
) {  
 alert(i);  
});  
```

Em Javascript functions (funções) são cidadãos de primeira classe na linguagem e eles podem ser definidos de forma anônima (sem um nome), e então ser passado como parâmetro de outra função. Podemos manipular e mover funções por toda a parte.

Ruby não tem métodos como cidadãos de primeira-classe. Na realidade podemos extrair um método de um objeto e embrulhá-lo dentro de um objeto ‘Method’, mas ele segura o contexto de seu objeto, portanto ele não é independente.

```ruby
class Test
  def initialize
    @hello = “Hello!”
  end
  def say
    @hello
  end
end
m = Test.new.method(:say)
m.call # => “Hello!”<br>
```

<p>Aqui, extraímos o método :say da instância de Test. Note que podemos manipular o método como um objeto normal. Toda vez que enviamos a mensagem ‘call’ ao objeto de método, ele roda como se estivesse sendo executado do contexto de seu object original (Test.new.say). No exemplo acima a última expressão imprimiria com sucesso “Hello!”, conforme armazenada na variável local de instância @hello.</p>
<p>Embora simples, não fazemos isso sempre. Isso porque este método está ligado ao contexto do seu objeto original e normalmente não queremos isso: seria legal ter um bloco de código independente. Então, vamos criar um bloco de código muito simples referenciado por uma variável:</p>
<hr>

```ruby
c = lambda { |i| puts i }
c.call(1) # => 1
c.call(2) # => 2
```

<del>-</del></p>
<p>A palavra ‘lambda’ fecha o código entre chaves como um objeto, num bloco, uma instância da classe Proc. Este objeto responde ao método ‘call’. Nas duas últimas expressões passamos parâmetros ao método ‘call’ e eles vão à variável ‘i’ definida entre pipes dentro do bloco. Então, ele age como uma entidade independente, desconectada de qualquer classe em particular. Vejamos isso:</p>
<hr>

```ruby
class Test
  def say(block)
    block.call(self.class)
  end
end
c.call(self.class) # => Object
Test.new.say© # => Test
```

<del>-</del></p>
<p>Estamos usando o mesmo bloco definido acima na variável ‘c’. Depois da definição da classe Test, chamamos o bloco passando ‘self.class’ e ele retorna ‘Object’ como resultado.</p>
<p>Então, chamamos o método :say a partir de dentro de uma instância da classe Test. O método :say chama o bloco lhe dando o ‘self.class’ interno como parâmetro do bloco. Nesse caso ele imprime ‘Test’ em vez de ‘Object’, o que significa que o bloco se liga ao escopo que o cerca. Essa é uma diferença entre um bloco e um método desconectado de um objeto.</p>
<p>De muitas maneiras, Blocks lembram funções anônimas do Javascript, delegates anônimos do C#, classes internas anônimas do Java. Essa é uma construção muito útil que foi criada primariamente para lidar melhor com iteradores. Por exemplo:</p>
<hr>

```ruby
{ |i| puts t }
```

<ol>
 <li> => 4 3 2 1 <br>
<del>-</del>
</li>
</ol>
<p>Agora, isso é diferente do método ‘each’ do Array, que usamos antes. Este navega de trás para frente através dos elementos do Array. Ele pega um elemento e passa à variável ‘i’, configurado como parâmetro para o bloco definido entre chaves.</p>
<p>Em linguagens como Java, tudo tem que ser definido através de uma interface. Enumeradores não são diferentes, e temos interfaces como ‘Iterator’. Esse método define métodos simples como ‘hasNext()’ e ‘next()’. Mas e se precisarmos de algo como um iterador reverso? Agora estamos por conta própria. E se precisarmos de algo mais complicado como um iterador que apenas anda por elementos em posição par? Em Ruby podemos definir métodos como:</p>
<hr>

```ruby
class Array
  def even
    i = 0
    while i < self.size
      yield(self[i]) if i % 2 == 0
      i += 1
    end
  end
end

{ |i| puts i }
```

<ol>
 <li> => 1 3 5<br>
</li>
</ol>
<p>Primeiro de tudo, lembre-se que classes Ruby são todas abertas, então podemos facilmente redefinir a classe padrão de Array e adicionar novos métodos para isso. Agora preste atenção ao método ‘even’. Implementamos da maneira tradicional com um loop ‘while’. Mas a parte interessante é a palavra-chave ‘yield’. Façam de conta que isso funciona como se tivesse um <strong>local coringa demarcado</strong> para blocos. No exemplo, quando passamos o valor ‘self[i]’ como parâmetro, na realidade estamos passando para o parâmetro ‘i’ do bloco.</p>
<p>Podemos re-escrever este método de uma maneira um pouco diferente mas com o mesmo comportamento:</p>
<hr>

```ruby
class Array
  def even(&code)
    i = 0
    while i < self.size
      code.call( self[i] ) if i % 2 == 0
      i += 1
    end
  end
end
```

<p>Então, explicitamente definimos que o método ‘even’ espera receber um bloco, convertendo o parâmetro em ‘código’ passado a ele. Daí, de dentro chamamos o método ‘call’ ao ‘código’, passando ‘self[i]’ como seu parâmetro. O resultado é exatamente o mesmo que usar a palavra-chave ‘yield’.</p>
<p>Ainda podemos fazer mais diferente:</p>
<hr>

```ruby
class Array
  def even(block)
    i = 0<br>
    while i < self.size
      block.call( self[i] ) if i % 2 == 0
      i += 1
    end
  end
end
```

<p>Agora estamos fazendo sem o ‘&’ (ampersand). No exemplo anterior, o operador ampersand ‘captura’ um bloco em uma instância de Proc. No último caso, o método ‘even’ espera receber diretamente um objeto Proc, como isso:</p>
<hr>

```ruby
c = lambda { |i| puts i }
[1,2,3,4,5,6].even( c )
```

<p>Vamos retornar ao método ‘each’ do Array como mostramos antes:</p>
<hr>

```ruby

c = lambda { |i| puts i }
[1,2,3,4].each( &c )
```

<p>Um pouco diferente, porque o método ‘each’ não espera um objeto Proc como parâmetro, mas sim um bloco real. Então usamos ‘&’ antes da variável de instância de Proc e ele o ‘expande’ de volta ao bloco de código, de forma que o método ‘even’ possam executá-lo com ‘yield’ dentro, em vez de executá o objeto com o método ‘call’.</p>
<p>Esse uso de um objeto Proc não é tão ‘elegante’ quanto passar diretamente o bloco de código, mas com essa construção podemos armazenar código dentro de um objeto. E podemos definir um método que recebe quanto blocos precisar, por exemplo:</p>
<hr>

```ruby
def foo(name, block1, block2)
  block1.call
  puts name
  block2.call
end
foo “Fabio”, lambda { puts “Hello” }, lambda { puts “World” }
```

<del>-</del></p>
<p>Este exemplo recebe um parâmetro normal e 2 blocos em vez de um. Podemos passar blocos enclausurados em objetos Proc na lista de parâmetros como faríamos com qualquer outro tipo de objeto. Normalmente não precisamos de tantos blocos diferentes dentro de um único método. O jeito mais comum é:</p>
<hr>

```ruby
def foo( param1, param2 )
 #do something
  yield ( some_param ) if block_given?
end

foo(1, 2) do |some_param|
```

<p>Então definimos um método normal, com parâmetros normais. Mas dentro perguntamos se foi passado um bloco com o método ‘block_given?’. Em caso positivo, executamos com ‘yield’ passando algum parâmetro a ele (claro, parâmetros em blocos são opcionais, e você pode passar quantos parâmetros quiser a um bloco, mesmo nenhum).</p>
<p>Chamamos o método definido normalmente, passando um bloco ao final da chamada do método. Aliás, aqui vai outra maneira de definir um bloco: usando a construção do .. end. Não há uma regra rígida, mas reservamos a notação de chaves quando o bloco é pequeno o suficiente para caber em uma única linha e o do .. end quando temos blocos com múltiplas linhas dentro.</p>
<p>Aqui vai uma pegadinha:</p>
<hr>

```ruby
foo a, b do |some_param|
 #do something
end
foo a, b { |some_param| # do something }

```

<p>Ambas as construções com chaves e do .. end definem blocos, então à primeira vista os dois códigos acima parecem a mesma coisa. Mas a pegadinha é que em Ruby parênteses são opcionais, e por acaso não estamos usando aqui.</p>
<p>No primeiro código o assume-se que o bloco deve ser passado ao método ‘foo’, como esperado, com ‘a’ e ‘b’ sendo parâmetros normais. Mas no segundo código imagina-se que ‘b’ é um método e tenta-se passar o bloco a ele. A recomendação é: se você tem um método que precisa tanto de parâmetros e um bloco então feche seus parâmetros entre parênteses para evitar ambiguidades.</p>
<p>Então, agora entendemos que blocos são pedaços de código que podem ser transportados entre chamadas de métodos, como parâmetros ou valores retornados. Mas ainda há mais:</p>
<hr>

```ruby
c = Proc.new { |i| puts i }<br>
c = proc { |i| puts i }<br>
```

<p>Os 3 comandos acima fazem a mesma coisa: instanciam um objeto de bloco. ‘proc’ é um sinônimo para ‘lambda’, mas Proc.new é um pouco diferente (No Ruby 1.9, ‘proc’ passará a ser sinônimo do Proc.new). Como eles funcionam de maneira similar podemos considerar como a mesma coisa. O sinônimo ‘proc’ está para se tornar obsoleto no futuro então use apenas ‘lambda’ ou ‘Proc.new’ para definir blocos.</p>
<p>Palavras-chave para ter em mente são:</p>
<ul>
 <li>lambda/Proc.new – fecham um punhado de código dentro de uma instância de Proc.</li>
 <li>& – ampersand, tanto captura um bloco de código para dentro de um objeto Proc ou expande um objeto Proc de volta a um bloco de código.</li>
 <li>{}/do..end – definem um bloco de código.</li>
 <li>|| – pipes, definem os parâmetros de um bloco. Se não precisar de nenhum, apenas omita os pipes.</li>
</ul>
<p>Portanto, alguém poderia dizer que um Bloco é exatamente a mesma coisa que uma classe anônima. Nada disso, e agora finalmente chegamos à definição de um <strong>Closure</strong> (Fechamento): Blocos Ruby são Closures, podemos apenas dizer que ‘blocos’ e ‘closures’, em Ruby, significam a mesma coisa.</p>
<p>Blocos Ruby podem enclausurar não somente código e suas próprias variáveis locais, mas também podem fechar as variáveis do contexto que a cerca. É por isso que ela é chamada de ‘fechamento’. Vejamos um exemplo:</p>
<hr>

```ruby
def greetings_factory(prefix)
  Proc.new { |name| “#{prefix}, #{name} !”}<br>
end
birthday = greetings_factory(“Happy Birthday”)
xmas = greetings_factory(“Merry XMas”)
birthday.call(“David”) # => “Happy Birthday, David !”<br>
```

xmas.call(“Matz”) # => “Merry XMas, Matz !”<br>
<p>A primeira coisa é a definição de um método para ‘greetings_factory’. Ele recebe um prefixo como parâmetro e retorna um objeto Proc, cujo parâmetro interno é ‘name’. Até aqui tudo bem.</p>
<p>A segunda parte define duas instâncias Proc, uma para aniversário e outra para natal. Perceba que passamos 2 prefixos diferentes ao método ‘greetings_factory’. Os valores diferentes são ‘fechados’ dentro do Bloco. Então quando os chamamos mais tarde, vemos quão diferente eles se comportam: eles armazenaram o último estado dentro deles mesmo. Então cada bloco armazena a variável ‘prefix’ passada antes e ao mesmo tempo continuam aceitando um parâmetro ‘name’ dentro do bloco.</p>
<p>Tenha em mente que cada Bloco Ruby é um Closure, é por isso que esta construção funciona:</p>
<hr>

```ruby
list = []
[1,2,3,4].each do |i|
  list << i * 2
end
puts list.inspect # => [2, 4, 6, 8]
```

<p>Então, definimos um array ‘lista’ <strong>antes</strong> de criar o bloco de iteração. Daí, dentro do bloco nos referimos ao array externo ‘list’ e o populamos. Em Java, isso seria uma variável imutável declarada como ‘final’, mas em Ruby não existe essa limitação.</p>
<p>Você precisa ser cuidadoso sobre o ambiente que cerca eu bloco: não defina variáveis que serão usadas dentro do bloco cedo demais no seu código. Tente manter as dependências próximas, como no exemplo acima onde o Array ‘list’ é definida logo antes do próprio iterador.</p>
<p>Então, iteradores ficam vitaminados porque não estamos limitados à uma Interface estática. Podemos adicionar quaisquer métodos que precisarmos, como ‘each’, ‘reverse_each’, ‘collect’, ‘select’ e assim por diante. Cada um deles podem receber um bloco e passar um elemento de cada vez a esse bloco.</p>
<p>Outro uso muito importante é para enclausurar padrões de código muito usados. Por exemplo, Rails tem a seguinte construção para usar transações de bancos de dados:</p>
<hr>

```ruby
User.transaction do
  u = User.new(:login => ‘admin’)
  u.save!
end
```

<p>‘User’ seria uma classe ActiveRecord. Um exemplo da estrutura para a transação da classe do model seria parecida com esta estrutura:</p>
<hr>

```ruby
class ActiveRecord::Base
  def self.transaction
    begin<br>
      ActiveRecord::Base.establish_connection
      yield if block_given?
    rescue => e<br>
      RAILS_DEFAULT_LOGGER.error e
    ensure<br>
      ActiveRecord::Base.remove_connection
    end
  end
end
```

<p>Isso significa: abra o banco de dados e tente chamar o bloco com ‘yield’, se for fornecido. Se algo de errado acontecer, (rescue) pegue a mensagem de erro e jogue no log. Finalmente garanta (ensure) que a conexão foi fechada depois de tudo.</p>
<p>O ActiveRecord na realidade não abre e fecha conexões com tanta frequência, mas vocês entenderam. Mas essa é só a idéia macro de uma maneira de evitar repetição e sobre a extração de padrões comuns de código. Então é legal encapsular funcionalidades comuns e colocar marcadores (yield) para código definido pelo usuário no meio.</p>
<p>O método File.open faz a mesma coisa: ele se responsabiliza de abrir arquivos, executar um bloco do usuário com ‘yield’ e garantir que o arquivo seja fechado corretamente sem que o usuário tenha que fazer esse tipo de limpeza.</p>
<p>O <a href="http://martinfowler.com/bliki/Closure.html">conceito</a> mais importante é que blocos ajudam a esconder detalhes de implementação. Nós não queremos saber os detalhes internos de um iterador de lista, ou como uma transação funciona. Apenas precisamos focar na lógica de negócios, fechadas dentro de um bloco.</p>
<p>Então descrevemos um monte de coisas, e acho que cobri o básico. O suficiente para ler o código-fonte de um Rails e se acostumar com o modus operandi de closures. Espero que tenham gostado!</p></macro:code>
