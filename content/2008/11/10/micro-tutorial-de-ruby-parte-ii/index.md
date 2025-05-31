---
title: Micro-Tutorial de Ruby - Parte II
date: '2008-11-10T01:42:00-02:00'
slug: micro-tutorial-de-ruby-parte-ii
tags:
- learning
- beginner
- ruby
- tutorial
draft: false
---

Vamos continuar de onde paramos. Leia a [Parte I](/2008/11/10/micro-tutorial-de-ruby-parte-i) antes de continuar. Mas antes, mais algumas dicas:

Para quem quer aprender Ruby com material em português tem três opções: [Aprenda a Programar](http://aprendaaprogramar.rubyonrails.pro.br/) que foi um esforço de tradução da comunidade Brasileira, é um livro bem mais básico para quem sequer tem treinamento em programação. Também tem o [Why’s Poignant Guide to Ruby](http://github.com/carlosbrando/poignant-br/tree/master) que é outro esforço coletivo de tradução da nossa comunidade, liderada pelo Carlos Brando. O livro do Why é um grande clássico da literatura de Ruby. O TaQ também tem um PDF disponível para [download](http://eustaquiorangel.com/downloads/tutorialruby.pdf).

## Métodos vs Mensagens

Na seção anterior vimos como podemos organizar nosso código em módulos e durante os exemplos usamos um método estranho, o “send”. Vamos ver para que ele serve de fato.

Outra noção que precisamos mudar aqui: _“nós chamamos métodos dos objetos.”_ Em orientação a objetos, na realidade deveria ser _“nós enviamos mensagens aos objetos.”_ Por exemplo:

* * *

```ruby

>> “teste”.hello  
NoMethodError: undefined method `hello’ for [teste](String)  
 from (irb):1  
```

O pensamento comum seria: _“tentamos chamar o método ‘hello’ que não existe em String.”_ Mas devemos pensar assim: _“tentamos enviar a mensagem ‘hello’ ao objeto e sua resposta padrão é que ele não sabe responder a essa mensagem.”_

Podemos reescrever o mesmo comportamento acima da seguinte forma:

* * *

```ruby
>> “teste”.send(:hello)  
NoMethodError: undefined method `hello’ for [teste](String)  
 from (irb):22:in`send’  
 from (irb):22  
```

Outro exemplo de ‘envio de mensagens’:

* * *

```ruby

>> “teste”.diga(“Fabio”)  
NoMethodError: undefined method `diga’ for [teste](String)  
 from (irb):24

>> “teste”.send(:diga, “Fabio”)  
NoMethodError: undefined method `diga’ for [teste](String)  
 from (irb):25:in`send’  
 from (irb):25  
```

Está entendendo o padrão? O equivalente a _‘chamar um método’_ é como se estivéssemos chamando o método ‘send’ onde o primeiro parâmetro é o ‘nome do método’ e a seguir uma lista (de tamanho arbitrário) de parâmetros. Numa linguagem tradicional, uma vez que a classe é definida, o contrato está fechado. Mas como vimos antes, em Ruby, nada é fechado. No caso, tentamos enviar uma mensagem chamada :diga e :hello que o String “teste” não sabe como responder. A resposta padrão é enviar uma exceção ‘NoMethodError’ indicando o erro.

Podemos resolver esse problema de duas formas: 1) reabrindo a classe String e definindo um método chamado ‘hello’ ou ‘diga’ ou 2) fazer com que a String receba qualquer mensagem, independente se existe um método para responder a ela ou não.

Nesse segundo caso, poderíamos fazer o seguinte:

* * *

```ruby
class String  
 def method\_missing(metodo, \*args)  
 puts “Nao conheco o metodo #{metodo}. Os argumentos foram:”  
 args.each { |arg| puts arg }  
 end  
end  
```

Antes de explicar, vejamos agora como o String “teste” vai se comportar:

* * *

```ruby

>> “teste”.hello  
Nao conheco o metodo hello. Os argumentos foram:  
=> []

>> “teste”.diga(“Fabio”)  
Nao conheco o metodo diga. Os argumentos foram:  
Fabio  
=> [“Fabio”]

>> “teste”.blabla(1,2,3)  
Nao conheco o metodo blabla. Os argumentos foram:  
1  
2  
3  
=> [1, 2, 3]  
```

Se você pensar em _“chamar métodos”_ o que estamos fazendo acima parece muito estranho pois estaríamos _“chamando métodos que não existem”_. Mas se mudar o ponto de vista para _“enviar mensagens a objetos”_ agora temos _“objetos que respondem a qualquer mensagem”_.

Outra coisa que é meio polêmico são métodos privados. Em Ruby podemos fazer assim:

* * *

```ruby
class Teste  
 private  
 def alo  
 “alo”  
 end  
end

>> Teste.new.alo  
NoMethodError: private method `alo’ called for #<teste:0x17d3b3c>
 from (irb):47</teste:0x17d3b3c>

>> Teste.new.send(:alo)  
=> “alo”  
```

Essa classe ‘Foo’ tem um método privado (tudo que vem depois de ‘private’). A primeira tentativa de chamar o método “alo” falha, obviamente, por ser um método privado. Mas a segunda tentativa, usando “send” é bem sucedido! Na realidade “private” serve para indicar que não deveríamos estar acessando determinado método, mas Ruby não nos força a não conseguir. Se nós realmente quisermos, temos que explicitamente usar “send”, mas aí nós estamos conscientemente fazendo algo que “não deveríamos”. Ruby não é paternalista: é feita para quem sabe o que está fazendo.

Por isso no artigo anterior usamos Pessoa.send(:include, MeusPatches), porque “include” é um método privado que só deveria ser usado dentro da própria classe. Mas esse “pattern” costuma funcionar.

Talvez o melhor exemplo para demonstrar esta funcionalidade dinâmica é mostrando o XML Builder. Primeiro, instale a gem:

```bash
gem install builder
```

Agora podemos usar no <span class="caps">IRB</span>:</p>
<hr>

```ruby
require ‘rubygems’
>> require ‘builder’
=> false
>> x = Builder::XmlMarkup.new(:target => $stdout, :indent => 1)
<inspect></inspect>
=> #<io:0x12b7cc>
>> x.instruct!
<?xml version=“1.0” encoding=“UTF-8”?>
=> #<io:0x12b7cc>
>> x.pessoa do |p|
?> p.nome “Fabio Akita”
>> p.email “fabioakita@gmail.com”
>> p.telefones do |t|
?> t.casa “6666-8888”
>> t.trabalho “2222-3333”
>> end
>> end
<pessoa>
 <nome>Fabio Akita</nome>
 <email>fabioakita@gmail.com</email>
 <telefones>
  <casa>6666-8888</casa>
  <trabalho>2222-3333</trabalho></telefones></pessoa></io:0x12b7cc></io:0x12b7cc></p>

=> #<io:0x12b7cc>
</io:0x12b7cc>
```

Como podem ver, instanciamos a classe XmlMarkup na variável “x”. Daí passamos a enviar mensagens como “pessoa” ou “email” e ele gera os tags <span class="caps">XML</span> adequadamente. Muito diferente do que teríamos que fazer do jeito tradicional:</p>
<hr>

```java
import org.w3c.dom.<strong>;
import javax.xml.parsers.</strong>;
import javax.xml.transform.*;</p>
class CreateDomXml
{
  public static void main(String[] args)
  {
    try{
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      DocumentBuilder docBuilder = factory.newDocumentBuilder();
      Document doc = docBuilder.newDocument();
Element root = doc.createElement(“pessoa”);
doc.appendChild(root);

Element childElement = doc.createElement(“nome”);
childElement.setValue(“Fabio Akita”);
root.appendChild(childElement);

childElement = doc.createElement(“email”);
childElement.setValue(“<fabioakita@gmail.com>”);
root.appendChild(childElement);
…..
} catch(Exception e) {
System.out.println(e.getMessage());
}
}
}
```

Note que este código sequer está completo pois seria comprido demais para mostrar aqui. A idéia toda de usar os conceitos de <strong>meta-programação</strong>, de redefinição dinâmica de comportamento do objeto, é de permitir que você nunca precise fazer mais código do que realmente necessário. Na versão Ruby, temos no máximo a mesma quantidade de linhas que o <span class="caps">XML</span> resultante, graças à capacidade de ter um método ‘method_missing’ que consegue definir dinamicamente o que fazer com cada nova mensagem inesperada.</p>
<h2>Higher Order Functions e Blocos</h2>
Vejamos o Design Pattern chamado Command:</p>
<hr>

```ruby
interface Command {
  public void execute();
}

class Button {
  Command action;
  public void setCommand(Command action) {
    this.action = action;
  }
  public void click() {
    this.action.execute();
  }
}
Button myButton = new Button();
myButton.setCommand(new Command() {
  public void execute() {
    System.out.println(“Clicked!!”);
  }
});
```

O que está acontecendo aqui é o seguinte: Criamos uma interface com um único método chamado ‘execute’. Daí criamos uma classe ‘Button’ onde podemos configurar que ação cada instância dele executará ao ser clicado. Essa ação é uma instância de um objeto que implementa Command. No final, criamos uma instância de Button e uma classe anônima (sem nome) com a implementação do método ‘execute’ para aquela instância.</p>
Vejamos o mesmo exemplo do Design Pattern Command em Ruby (um dos vários jeitos de implementar):</p>
<hr>

```ruby
class Button
  def initialize(&block)
    @block = block
  end
  def click
    @block.call
  end
end
my_button = Button.new { puts “Clicked!!” }
my_button.click
```

Primeiro, claro, bem mais curto, mas o mais importante: não precisamos encapsular uma ação como método de uma classe. Em linguagens tradicionais que não tem o conceito de “funções como cidadãos de primeira classe”, precisamos encapsular qualquer coisa em classes, mesmo que sejam classes anônimas.</p>
No Ruby, temos o conceito de “código como objeto”. Na realidade encapsulamos o código diretamente em um objeto. No exemplo acima, o construtor ‘initialize’ captura qualquer bloco de código que passarmos a ele dentro da variável ‘block’ (para isso serve o “&”). Daí quando instanciamos o parâmetro que passamos entre chaves {} é o bloco de código capturado como objeto e associado à variável ‘block’.</p>
A partir daí ele fica armazenado como uma variável de instância “@block” e no método ‘click’ podemos executar esse bloco de código enviando a mensagem ‘call’ (afinal, ele é um objeto e, portanto, responde a métodos).</p>
Vejamos um exemplo mais simples:</p>
<hr>

```ruby
>> def diga_algo(nome)
>> yield(nome)
>> end
=> nil</p>
>> diga_algo(“Fabio”) { |nome| puts “Hello, #{nome}” }
Hello, Fabio
=> nil</p>
>> diga_algo(“Akita”) { |nome| puts “Hello, #{nome}” }
Hello, Akita
=> nil
```

Agora complicou: primeiro definimos um método chamado ‘diga_algo’ que recebe apenas um parâmetro. Dentro do método chamamos o comando especial ‘yield’, passando o parâmetro recebido a ele. Esse comando ‘yield’ executa qualquer bloco que foi passado como último parâmetro à chamada do método. É como se o método ‘diga_algo’ tivesse um segundo parâmetro implícito – digamos, ‘&b’ – e ‘yield(nome)’ fosse a mesma coisa que chamar ‘b.call(nome)’.</p>
Preste atenção neste trecho:</p>
<hr>

```ruby
{ |nome| puts “Hello, #{nome}” }—-
```

Pense nisso como se fosse uma função anônima: o que está entre pipes “||” são parâmetros dessa função. O ‘yield’ irá executar esse bloco de código. Por acaso, ele passará o parâmetro ‘nome’ para dentro do bloco Vejamos outro exemplo:</p>
<hr>

```ruby
>> soma = lambda { |a, b| a + b }
=> #<Proc:0×012d4898@(irb):46>
>> soma.call(1,2)
=> 3
>> soma.call(4,4)
=> 8
```

O comando ‘lambda’ serve para capturar o bloco de código numa instância da classe Proc. No exemplo, esse bloco aceita dois parâmetros, “a” e “b” e faz a soma deles. Depois podemos pegar o objeto ‘soma’ e chamar o método ‘call’ passando os dois parâmetros que ele requer.</p>
No Ruby 1.8, um bloco também é uma <strong>Closure</strong> (“Fechamento”). Ou seja, o bloco de código engloba o ambiente ao seu redor, incluindo variáveis fora do bloco. Por exemplo:</p>
<hr>

```ruby
>> def criar_bloco(nome)
>> lambda { puts “Hello #{nome}”}
>> end
=> nil
>>
?> fabio = criar_bloco(“Fabio”)
=> #<Proc:0×0124aae4@(irb):59>
>> akita = criar_bloco(“Akita”)
=> #<Proc:0×0124aae4@(irb):59>
```

O método ‘criar_bloco’ retorna um novo bloco de código. Note que o método recebe o parâmetro ‘nome’ e daí criamos o novo lambda usando esse ‘nome’ dentro dele. Finalmente chamamos o método duas vezes, criando dois lambdas diferentes, passando dois parâmetros diferentes a ‘nome’.</p>
Agora vamos executar esses blocos:</p>
<hr>

```ruby
>> fabio.call
Hello Fabio
=> nil</p>
>> akita.call
Hello Akita
=> nil</p>
>> fabio.call
Hello Fabio
=> nil
```

Veja que o bloco <strong>reteve</strong> o conteúdo do parâmetro ‘nome’ que foi passado como argumento ao método ‘criar_bloco’. Cada um dos blocos reteve o parâmetro, e como os configuramos com conteúdos diferentes, ao serem executados eles tem comportamentos diferentes. Esse conceito de <strong>Fechamento</strong> é um pouco complicado da primeira vez, por isso se você pelo menos entendeu que existem blocos e que eles são encapsulados em objetos anônimos que chamamos de <strong>lambdas</strong>, por enquanto é o suficiente.</p>
Mas mais do que isso, você viu como métodos Ruby conseguem receber blocos de código e devolver blocos de código. É a isso que chamamos de <a href="http://en.wikipedia.org/wiki/Higher-order_function">Higher Order Functions</a>, ou seja, uma ‘função’ (que chamamos de ‘bloco de código’) pode ser recebido ou repassado como se fosse uma variável qualquer. Isso é muito importante para categorizar Ruby como uma linguagem ‘inspirada em linguagens funcionais’, como Lisp. No caso, lambdas de Ruby não são livres de efeitos-colaterais, por isso ela não pode ser considerada puramente funcional. Mas isso já auxilia em muitas operações e é uma maneira bem mais eficiente inclusive de encapsular funcionalidades.</p>
Vejamos outro exemplo de código para ler arquivos, começando por Java:</p>
<hr>

```java
StringBuilder contents = new StringBuilder();
try {
  BufferedReader input = new BufferedReader(
    new FileReader(aFile));
  try {
    String line = null;
    while (( line = input.readLine()) != null){
      contents.append(line);
      contents.append(
        System.getProperty(“line.separator”));
    }
  }
  finally {
    input.close();
  }
}
catch (IOException ex){
  ex.printStackTrace();
}
```

Algo parecido, de forma literal, em Ruby, ficaria assim:</p>
<hr>

```ruby
contents = ""
begin
  input = File.open(aFile, “r”)
  begin
    while line = input.gets
      contents << line
      contents << “\n”
    end
  ensure
    input.close
  end
rescue e
  puts e
end
```

Nada muito diferente, sequer em número de linhas. Porém, se considerarmos o caso de uso <em>“abrir um arquivo e processar seu conteúdo”</em>, todo esse código lida com o fato de abrir o arquivo, garantir que ele seja fechado, tratar exceções. O trecho específico de <em>“processar o conteúdo”</em> é nada mais do que as 4 linhas do bloco ‘while’. Podemos tornar isso mais <em>Rubista</em> criando um novo método ‘open’, que usa o recurso de ‘yield’ que mostramos acima.</p>
Felizmente o Ruby já implementa o método ‘open’ da classe ‘File’ dessa forma, por isso podemos re-escrever o trecho de código acima assim:</p>
<hr>

```ruby
contents = ""
File.open(aFile, “r”) do |input|
  while line = input.gets
    contents << line
    contents << “\n”
  end
end
```

Um pouco melhor, bem mais encapsulado, expondo apenas o que é realmente essencial ao que queremos fazer. Olhando para este trecho sabemos exatamente que queremos abrir um arquivo e processar linha a linha de seu conteúdo, armazenando o resultado na variável ‘contents’. Todo o resto do <em>encanamento</em> está escondido dentro do método ‘open’. Podemos passar apenas o bloco do ‘while’ como um lambda e ele será executado no meio da implementação desse método. Se fôssemos reimplementar o método ‘open’ da classe ‘File’ para agir dessa forma, poderíamos fazer assim:</p>
<hr>

```ruby
class File
  def File.open(<strong>args)
    result = f = File.new(</strong>args)
    if block_given?
      begin
        result = yield f
      ensure
        f.close
      end
    end
    return result
  end
end
```

Aqui, simulamos a reabertura da classe ‘File’ e a reimplementação do método ‘open’. Note que primeiro checamos se foi passado um bloco (‘block_given?’) e daí usamos ‘yield’ para executar o lambda passado a ele, daí repassamos o arquivo ‘f’ recém-aberto. Quando seja lá o que ‘yield’ executar terminar, daí fechamos o arquivo e retornamos.</p>
Aliás, é exatamente assim que os <strong>iteradores</strong> funcionam em Ruby. Um iterador serve para navegar pelos vários elementos de uma lista (ou outro objeto que se comporte como uma lista), sem se incomodar com os detalhes da implementação dessa lista (se é um array, uma lista ligada, uma sequência de bytes de um arquivo, etc).</p>
Um pouco acima falei em reescrever de um jeito “um pouco mais Rubista”, mas vejamos um jeito mais Rubista ainda:</p>
<hr>

```ruby
contents = File.open(aFile).readlines.inject("") do |buf, line|
  buf += line
end
```

O método ‘readlines’ devolve um Array, onde cada elemento é uma linha do arquivo texto. O método “inject” é um <strong>Redutor</strong>: ele pega linha a linha do Array e repassa ao bloco, como primeiro parâmetro. O segundo parâmetro, ‘buf’, é um totalizador que é iniciado com o primeiro parâmetro que passamos no método ‘inject’, no caso a string vazia "". Ele repassa sempre esse objeto como segundo parâmetro do bloco. Dentro do bloco podemos fazer o que quiser, mas normalmente queremos que seja um totalizador por isso usamos o operador “+=” que significa “buf = buf + line”.</p>
Em Ruby é muito comum utilizar essa maneira de pensar: em vez de pensar em <em>“como vamos iterar elemento a elemento”</em>, partimos do princípio que isso é trivial e daí pensamos <em>“como queremos filtrar elemento a elemento”</em>. Linhas como a seguinte são bastante comuns:</p>
<hr>

```ruby
>> [1,2,3,4,5].map { |elem| elem * elem }
=> [1, 4, 9, 16, 25]</p>
>> [1,2,3,4,5].select { |elem| elem % 2 == 0 }
=> [2, 4]</p>
>> [1,2,3,4,5].inject(0) { |total, elem| total += elem }
=> 15</p>
>> total = 0
=> 0
>> [1,2,3,4,5].each { |elem| total += elem }
=> [1, 2, 3, 4, 5]
>> total
=> 15
```

O primeiro exemplo – “map” – substitui elemento a elemento pelo resultado do bloco. O segundo – “select” – devolve o resultado do filtro que é passado como bloco. O terceiro – “inject” – é o redutor que já vimos acima e o quarto – “each” – é a mesma coisa que o “inject” mas menos encapsulado e usando código extra para chegar ao mesmo efeito.</p>
Para completar, blocos podem ser passados como parâmetro a um método usando duas sintaxes: chaves (“{}”) ou “do..end”, por exemplo:</p>
<hr>

```ruby
{ |elem| puts elem }

do |elem|
puts elem
end
```

Ambas as formas acima fazem a mesma coisa. A diferença é que costumamos usar chaves para blocos curtos, de uma única linha. Já o do..end é mais usado quando temos múltiplas linhas. Em ambos os casos os parâmetros do bloco vão entre pipes (“||”). Na realidade existem mais diferenças, mas para começar até aqui está bom.</p>
<h2>Tipos Básicos</h2>
Invertendo a ordem das coisas, finalmente vamos falar um pouco mais sobre os tipos básicos do Ruby. Nós já vimos muitos deles então vamos apenas passar por eles rapidamente.</p>
<h3>Arrays</h3>
Arrays são listas simples de elementos, a sintaxe mais básica é a seguinte:</p>
<hr>

```ruby
>> lista = [100,200,300,400]
=> [100, 200, 300, 400]
>> lista2
=> 300
```

Até aqui nada de novo, porém o Ruby tem alguns facilitadores, por exemplo:</p>
<hr>

```ruby
?> lista.first
=> 100
>> lista.last
=> 400
```

<del>-</del></p>
Também já vimos que ele tem vários métodos que aceitam blocos para processar elemento a elemento, como “each”, “map”, “select”, “inject”. Já vimos anteriormente como operadores em Ruby nada mais são do que métodos. Vejamos como os Arrays se comportam:</p>
<hr>

```ruby
>> [1,2,3,4] + [5,6,7,8]
=> [1, 2, 3, 4, 5, 6, 7, 8]</p>
>> [1,2,3,4,5] – [2,3,4]
=> [1, 5]</p>
>> [1,2,3] * 2
=> [1, 2, 3, 1, 2, 3]
```

Como na maioria das linguagens a notação de colchetes (“[]”) deve ser familiar, para encontrar o elemento através do seu índice. Mas em Ruby, os colchetes também são operadores! Vamos fazer uma brincadeira:</p>
<hr>

```ruby
class Array
  alias :seletor_antigo :[]
  def [](indice)
    return seletor_antigo(indice) if indice.is_a? Fixnum
    return self.send(indice) if indice.is_a? Symbol
    “Nada encontrado para #{indice}”
  end
end
>> lista = [1,2,3,4]
=> [1, 2, 3, 4]
>> lista2
=> 3
>> lista[:first]
=> 1
>> lista[:last]
=> 4
>> lista[:size]
=> 4
>> lista[“bla bla”]
=> “Nada encontrado para bla bla”
```

Viram o que aconteceu? Usamos “alias” novamente para criar um novo atalho à antiga implementação de [], daí reimplementamos []. Ele se comporta assim: se o parâmetro passado entre colchetes for um inteiro, é para se comportar como antes, portanto chamando o atalho “seletor_antigo”. Se for um símbolo (vamos explicar isso depois mas por enquanto entenda que é uma palavra com dois pontos antes, como “:first”), ele deve enviar a mensagem ao objeto usando “send”, ou seja, deve executar como se fosse um método. Dessa forma “lista[:first]” deve se comportar igual a “lista.first”. Finalmente, se for qualquer outra coisa (como um String), apenas mostre uma mensagem dizendo que nada foi encontrado.</p>
Como podemos ver, mais do que o Array em si, o operador “[]” pode ser muito útil em vários cenários. Enfim, na maior parte dos casos um Array em Ruby se comporta muito parecido com um Array em qualquer outra linguagem.</p>
<h3>Hashes</h3>
Um Hash, em outras linguagens, também é chamado de Dicionário, ou seja, é uma lista onde a ordem de inserção não é importante, e cada elemento é um par que liga uma chave a um valor. Por exemplo:</p>
<hr>

```ruby
>> dic = { “car” => “carro”, “table” => “mesa”, “mouse” => “rato” }
=> {"mouse"=>"rato", “table”=>"mesa", “car”=>"carro"}</p>
>> dic[“car”]
=> “carro”</p>
>> dic[“mouse”]
=> “rato”
```

Novamente, é um comportamento parecido com um Array, mas em vez de passar índices numéricos ao operador “[]”, passamos uma chave e esperamos encontrar o valor correspondente. Para acrescentar mais elementos à lista, podemos fazer assim:</p>
<hr>

```ruby
>> dic.merge!( {"book" => “livro”, “leg” => "perna"} )
=> {"leg"=>"perna", “mouse”=>"rato", “table”=>"mesa", “book”=>"livro", “car”=>"carro"}
```

Mais uma peculiaridade de Ruby. Um Hash tem dois métodos para mesclar novos elementos a uma lista já existente: “merge” e “merge!”. A diferença de um para outro é que o primeiro é um método não-destrutivo e o segundo é um método destrutivo, ou seja, o primeiro retorna a lista mesclada mas a original continua como antes, já o segundo método mescla os novos elementos diretamente na lista original. Ou seja, a linha anterior seria equivalente a fazer isso:</p>
<hr>

```ruby
dic = dic.merge( {"book" => “livro”, “leg” => "perna"} )
```

O resultado do merge é atribuído à mesma variável, ignorando a lista original, que é o que fazemos normalmente. Você também pode ter Hashes dentro de Hashes, assim:</p>
<hr>

```ruby
>> fabio = { “emails” =>
?> { “trabalho” => “fabio.akita@locaweb.com.br”,
?> “normal” => “fabioakita@gmail.com” } }
=> {"emails"=>{"normal"=>"fabioakita@gmail.com", “trabalho”=>"fabio.akita@locaweb.com.br"}}</p>
?> fabio[“emails”][“normal”]
=> “fabioakita@gmail.com”
```

Finalmente, podemos explorar o conteúdo de um Hash da seguinte maneira:</p>
<hr>

```ruby
>> dic.keys
=> [“leg”, “mouse”, “table”, “book”, “car”]

>> dic.values
=> [“perna”, “rato”, “mesa”, “livro”, “carro”]

>> dic.keys.each do |chave|
?> puts “#{chave} = #{dic[chave]}”
>> end

leg = perna
mouse = rato
table = mesa
book = livro
car = carro
```

Se você entendeu blocos nas seções anteriores, este código deve ser bastante trivial de entender. Se não, retome a leitura do começo.</p>
Hash é um dos tipos mais importantes e vamos retornar a ele em outra seção para ver como esse tipo é usado por todo tipo de codificação Ruby. Inclusive o Ruby on Rails utiliza Hashes o tempo todo em lugares onde a maioria nem imagina.</p>
Continue lendo a <a href="/2008/11/10/micro-tutorial-de-ruby-parte-iii">Parte <span class="caps">III</span></a></p>
