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
ruby

\>\> “teste”.hello  
NoMethodError: undefined method `hello’ for [teste](String)  
 from (irb):1  
-

O pensamento comum seria: _“tentamos chamar o método ‘hello’ que não existe em String.”_ Mas devemos pensar assim: _“tentamos enviar a mensagem ‘hello’ ao objeto e sua resposta padrão é que ele não sabe responder a essa mensagem.”_

Podemos reescrever o mesmo comportamento acima da seguinte forma:

* * *
ruby

\>\> “teste”.send(:hello)  
NoMethodError: undefined method `hello’ for [teste](String)  
 from (irb):22:in `send’  
 from (irb):22  
-

Outro exemplo de ‘envio de mensagens’:

* * *
ruby

\>\> “teste”.diga(“Fabio”)  
NoMethodError: undefined method `diga’ for [teste](String)  
 from (irb):24

\>\> “teste”.send(:diga, “Fabio”)  
NoMethodError: undefined method `diga’ for [teste](String)  
 from (irb):25:in `send’  
 from (irb):25  
-

Está entendendo o padrão? O equivalente a _‘chamar um método’_ é como se estivéssemos chamando o método ‘send’ onde o primeiro parâmetro é o ‘nome do método’ e a seguir uma lista (de tamanho arbitrário) de parâmetros. Numa linguagem tradicional, uma vez que a classe é definida, o contrato está fechado. Mas como vimos antes, em Ruby, nada é fechado. No caso, tentamos enviar uma mensagem chamada :diga e :hello que o String “teste” não sabe como responder. A resposta padrão é enviar uma exceção ‘NoMethodError’ indicando o erro.

Podemos resolver esse problema de duas formas: 1) reabrindo a classe String e definindo um método chamado ‘hello’ ou ‘diga’ ou 2) fazer com que a String receba qualquer mensagem, independente se existe um método para responder a ela ou não.

Nesse segundo caso, poderíamos fazer o seguinte:

* * *
ruby

class String  
 def method\_missing(metodo, \*args)  
 puts “Nao conheco o metodo #{metodo}. Os argumentos foram:”  
 args.each { |arg| puts arg }  
 end  
end  
-

Antes de explicar, vejamos agora como o String “teste” vai se comportar:

* * *
ruby

\>\> “teste”.hello  
Nao conheco o metodo hello. Os argumentos foram:  
=\> []

\>\> “teste”.diga(“Fabio”)  
Nao conheco o metodo diga. Os argumentos foram:  
Fabio  
=\> [“Fabio”]

\>\> “teste”.blabla(1,2,3)  
Nao conheco o metodo blabla. Os argumentos foram:  
1  
2  
3  
=\> [1, 2, 3]  
-

Se você pensar em _“chamar métodos”_ o que estamos fazendo acima parece muito estranho pois estaríamos _“chamando métodos que não existem”_. Mas se mudar o ponto de vista para _“enviar mensagens a objetos”_ agora temos _“objetos que respondem a qualquer mensagem”_.

Outra coisa que é meio polêmico são métodos privados. Em Ruby podemos fazer assim:

* * *
ruby

class Teste  
 private  
 def alo  
 “alo”  
 end  
end

\>\> Teste.new.alo  
NoMethodError: private method `alo’ called for #<teste:0x17d3b3c><br>
	from (irb):47</teste:0x17d3b3c>

\>\> Teste.new.send(:alo)  
=\> “alo”  
-

Essa classe ‘Foo’ tem um método privado (tudo que vem depois de ‘private’). A primeira tentativa de chamar o método “alo” falha, obviamente, por ser um método privado. Mas a segunda tentativa, usando “send” é bem sucedido! Na realidade “private” serve para indicar que não deveríamos estar acessando determinado método, mas Ruby não nos força a não conseguir. Se nós realmente quisermos, temos que explicitamente usar “send”, mas aí nós estamos conscientemente fazendo algo que “não deveríamos”. Ruby não é paternalista: é feita para quem sabe o que está fazendo.

Por isso no artigo anterior usamos Pessoa.send(:include, MeusPatches), porque “include” é um método privado que só deveria ser usado dentro da própria classe. Mas esse “pattern” costuma funcionar.

Talvez o melhor exemplo para demonstrar esta funcionalidade dinâmica é mostrando o XML Builder. Primeiro, instale a gem:

<macro:code>
<p>gem install builder<br>
<del>-</del></p>
<p>Agora podemos usar no <span class="caps">IRB</span>:</p>
<hr>
ruby
<p>&gt;&gt; require ‘rubygems’<br>
&gt;&gt; require ‘builder’<br>
=&gt; false<br>
&gt;&gt; x = Builder::XmlMarkup.new(:target =&gt; $stdout, :indent =&gt; 1)<br>
<inspect></inspect><br>
=&gt; #<io:0x12b7cc><br>
&gt;&gt; x.instruct!<br>
&lt;?xml version=“1.0” encoding=“<span class="caps">UTF</span>-8”?&gt;<br>
=&gt; #<io:0x12b7cc><br>
&gt;&gt; x.pessoa do |p|<br>
?&gt; p.nome “Fabio Akita”<br>
&gt;&gt; p.email “fabioakita@gmail.com”<br>
&gt;&gt; p.telefones do |t|<br>
?&gt; t.casa “6666-8888”<br>
&gt;&gt; t.trabalho “2222-3333”<br>
&gt;&gt; end<br>
&gt;&gt; end<br>
<pessoa><br>
 <nome>Fabio Akita</nome><br>
 <email>fabioakita@gmail.com</email><br>
 <telefones><br>
  <casa>6666-8888</casa><br>
  <trabalho>2222-3333</trabalho></telefones></pessoa></io:0x12b7cc></io:0x12b7cc></p>

<p>=&gt; #<io:0x12b7cc><br>
<del>-</del></io:0x12b7cc></p>
<p>Como podem ver, instanciamos a classe XmlMarkup na variável “x”. Daí passamos a enviar mensagens como “pessoa” ou “email” e ele gera os tags <span class="caps">XML</span> adequadamente. Muito diferente do que teríamos que fazer do jeito tradicional:</p>
<hr>
java
<p>import org.w3c.dom.<strong>;<br>
import javax.xml.parsers.</strong>; <br>
import javax.xml.transform.*;</p>
<p>class CreateDomXml <br>
{<br>
  public static void main(String[] args) <br>
  {<br>
    try{<br>
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();<br>
      DocumentBuilder docBuilder = factory.newDocumentBuilder();<br>
      Document doc = docBuilder.newDocument();</p>
Element root = doc.createElement(“pessoa”);
doc.appendChild(root);

Element childElement = doc.createElement(“nome”);
childElement.setValue(“Fabio Akita”);
root.appendChild(childElement);

childElement = doc.createElement(“email”);
childElement.setValue(“fabioakita@gmail.com”);
root.appendChild(childElement);
…..
} catch(Exception e) {
System.out.println(e.getMessage());
}
}
<p>}<br>
<del>-</del></p>
<p>Note que este código sequer está completo pois seria comprido demais para mostrar aqui. A idéia toda de usar os conceitos de <strong>meta-programação</strong>, de redefinição dinâmica de comportamento do objeto, é de permitir que você nunca precise fazer mais código do que realmente necessário. Na versão Ruby, temos no máximo a mesma quantidade de linhas que o <span class="caps">XML</span> resultante, graças à capacidade de ter um método ‘method_missing’ que consegue definir dinamicamente o que fazer com cada nova mensagem inesperada.</p>
<h2>Higher Order Functions e Blocos</h2>
<p>Vejamos o Design Pattern chamado Command:</p>
<hr>
ruby
<p>interface Command {<br>
  public void execute();<br>
}</p>
<p>class Button {<br>
  Command action;<br>
  public void setCommand(Command action) {<br>
    this.action = action;<br>
  }<br>
  public void click() {<br>
    this.action.execute();	<br>
  }<br>
}</p>
<p>Button myButton = new Button();<br>
myButton.setCommand(new Command() {<br>
  public void execute() {<br>
    System.out.println(“Clicked!!”);<br>
  }<br>
});<br>
<del>-</del></p>
<p>O que está acontecendo aqui é o seguinte: Criamos uma interface com um único método chamado ‘execute’. Daí criamos uma classe ‘Button’ onde podemos configurar que ação cada instância dele executará ao ser clicado. Essa ação é uma instância de um objeto que implementa Command. No final, criamos uma instância de Button e uma classe anônima (sem nome) com a implementação do método ‘execute’ para aquela instância.</p>
<p>Vejamos o mesmo exemplo do Design Pattern Command em Ruby (um dos vários jeitos de implementar):</p>
<hr>
ruby
<p>class Button<br>
  def initialize(&amp;block)<br>
    @block = block<br>
  end<br>
  def click<br>
    @block.call<br>
  end<br>
end</p>
<p>my_button = Button.new { puts “Clicked!!” }<br>
my_button.click<br>
<del>-</del></p>
<p>Primeiro, claro, bem mais curto, mas o mais importante: não precisamos encapsular uma ação como método de uma classe. Em linguagens tradicionais que não tem o conceito de “funções como cidadãos de primeira classe”, precisamos encapsular qualquer coisa em classes, mesmo que sejam classes anônimas.</p>
<p>No Ruby, temos o conceito de “código como objeto”. Na realidade encapsulamos o código diretamente em um objeto. No exemplo acima, o construtor ‘initialize’ captura qualquer bloco de código que passarmos a ele dentro da variável ‘block’ (para isso serve o “&amp;”). Daí quando instanciamos o parâmetro que passamos entre chaves {} é o bloco de código capturado como objeto e associado à variável ‘block’.</p>
<p>A partir daí ele fica armazenado como uma variável de instância “@block” e no método ‘click’ podemos executar esse bloco de código enviando a mensagem ‘call’ (afinal, ele é um objeto e, portanto, responde a métodos).</p>
<p>Vejamos um exemplo mais simples:</p>
<hr>
ruby
<p>&gt;&gt; def diga_algo(nome)<br>
&gt;&gt; yield(nome)<br>
&gt;&gt; end<br>
=&gt; nil</p>
<p>&gt;&gt; diga_algo(“Fabio”) { |nome| puts “Hello, #{nome}” }<br>
Hello, Fabio<br>
=&gt; nil</p>
<p>&gt;&gt; diga_algo(“Akita”) { |nome| puts “Hello, #{nome}” }<br>
Hello, Akita<br>
=&gt; nil<br>
<del>-</del></p>
<p>Agora complicou: primeiro definimos um método chamado ‘diga_algo’ que recebe apenas um parâmetro. Dentro do método chamamos o comando especial ‘yield’, passando o parâmetro recebido a ele. Esse comando ‘yield’ executa qualquer bloco que foi passado como último parâmetro à chamada do método. É como se o método ‘diga_algo’ tivesse um segundo parâmetro implícito – digamos, ‘&amp;b’ – e ‘yield(nome)’ fosse a mesma coisa que chamar ‘b.call(nome)’.</p>
<p>Preste atenção neste trecho:</p>
<hr>
ruby{ |nome| puts “Hello, #{nome}” }—-
<p>Pense nisso como se fosse uma função anônima: o que está entre pipes “||” são parâmetros dessa função. O ‘yield’ irá executar esse bloco de código. Por acaso, ele passará o parâmetro ‘nome’ para dentro do bloco Vejamos outro exemplo:</p>
<hr>
ruby
<p>&gt;&gt; soma = lambda { |a, b| a + b }<br>
=&gt; #&lt;Proc:0×012d4898@(irb):46&gt;<br>
&gt;&gt; soma.call(1,2)<br>
=&gt; 3<br>
&gt;&gt; soma.call(4,4)<br>
=&gt; 8<br>
<del>-</del></p>
<p>O comando ‘lambda’ serve para capturar o bloco de código numa instância da classe Proc. No exemplo, esse bloco aceita dois parâmetros, “a” e “b” e faz a soma deles. Depois podemos pegar o objeto ‘soma’ e chamar o método ‘call’ passando os dois parâmetros que ele requer.</p>
<p>No Ruby 1.8, um bloco também é uma <strong>Closure</strong> (“Fechamento”). Ou seja, o bloco de código engloba o ambiente ao seu redor, incluindo variáveis fora do bloco. Por exemplo:</p>
<hr>
ruby
<p>&gt;&gt; def criar_bloco(nome)<br>
&gt;&gt; lambda { puts “Hello #{nome}”}<br>
&gt;&gt; end<br>
=&gt; nil<br>
&gt;&gt; <br>
?&gt; fabio = criar_bloco(“Fabio”)<br>
=&gt; #&lt;Proc:0×0124aae4@(irb):59&gt;<br>
&gt;&gt; akita = criar_bloco(“Akita”)<br>
=&gt; #&lt;Proc:0×0124aae4@(irb):59&gt;<br>
<del>-</del></p>
<p>O método ‘criar_bloco’ retorna um novo bloco de código. Note que o método recebe o parâmetro ‘nome’ e daí criamos o novo lambda usando esse ‘nome’ dentro dele. Finalmente chamamos o método duas vezes, criando dois lambdas diferentes, passando dois parâmetros diferentes a ‘nome’.</p>
<p>Agora vamos executar esses blocos:</p>
<hr>
ruby
<p>&gt;&gt; fabio.call<br>
Hello Fabio<br>
=&gt; nil</p>
<p>&gt;&gt; akita.call<br>
Hello Akita<br>
=&gt; nil</p>
<p>&gt;&gt; fabio.call<br>
Hello Fabio<br>
=&gt; nil<br>
<del>-</del></p>
<p>Veja que o bloco <strong>reteve</strong> o conteúdo do parâmetro ‘nome’ que foi passado como argumento ao método ‘criar_bloco’. Cada um dos blocos reteve o parâmetro, e como os configuramos com conteúdos diferentes, ao serem executados eles tem comportamentos diferentes. Esse conceito de <strong>Fechamento</strong> é um pouco complicado da primeira vez, por isso se você pelo menos entendeu que existem blocos e que eles são encapsulados em objetos anônimos que chamamos de <strong>lambdas</strong>, por enquanto é o suficiente.</p>
<p>Mas mais do que isso, você viu como métodos Ruby conseguem receber blocos de código e devolver blocos de código. É a isso que chamamos de <a href="http://en.wikipedia.org/wiki/Higher-order_function">Higher Order Functions</a>, ou seja, uma ‘função’ (que chamamos de ‘bloco de código’) pode ser recebido ou repassado como se fosse uma variável qualquer. Isso é muito importante para categorizar Ruby como uma linguagem ‘inspirada em linguagens funcionais’, como Lisp. No caso, lambdas de Ruby não são livres de efeitos-colaterais, por isso ela não pode ser considerada puramente funcional. Mas isso já auxilia em muitas operações e é uma maneira bem mais eficiente inclusive de encapsular funcionalidades.</p>
<p>Vejamos outro exemplo de código para ler arquivos, começando por Java:</p>
<hr>
java
<p>StringBuilder contents = new StringBuilder();</p>
<p>try {<br>
  BufferedReader input = new BufferedReader(<br>
    new FileReader(aFile));<br>
  try {<br>
    String line = null; <br>
    while (( line = input.readLine()) != null){<br>
      contents.append(line);<br>
      contents.append(<br>
        System.getProperty(“line.separator”));<br>
    }<br>
  }<br>
  finally {<br>
    input.close();<br>
  }<br>
}<br>
catch (IOException ex){<br>
  ex.printStackTrace();<br>
}<br>
<del>-</del></p>
<p>Algo parecido, de forma literal, em Ruby, ficaria assim:</p>
<hr>
ruby
<p>contents = ""<br>
begin<br>
  input = File.open(aFile, “r”)<br>
  begin<br>
    while line = input.gets<br>
      contents &lt;&lt; line<br>
      contents &lt;&lt; “\n”<br>
    end<br>
  ensure<br>
    input.close<br>
  end<br>
rescue e<br>
  puts e<br>
end<br>
<del>-</del></p>
<p>Nada muito diferente, sequer em número de linhas. Porém, se considerarmos o caso de uso <em>“abrir um arquivo e processar seu conteúdo”</em>, todo esse código lida com o fato de abrir o arquivo, garantir que ele seja fechado, tratar exceções. O trecho específico de <em>“processar o conteúdo”</em> é nada mais do que as 4 linhas do bloco ‘while’. Podemos tornar isso mais <em>Rubista</em> criando um novo método ‘open’, que usa o recurso de ‘yield’ que mostramos acima.</p>
<p>Felizmente o Ruby já implementa o método ‘open’ da classe ‘File’ dessa forma, por isso podemos re-escrever o trecho de código acima assim:</p>
<hr>
ruby
<p>contents = ""<br>
File.open(aFile, “r”) do |input|<br>
  while line = input.gets<br>
    contents &lt;&lt; line<br>
    contents &lt;&lt; “\n”<br>
  end<br>
end<br>
<del>-</del></p>
<p>Um pouco melhor, bem mais encapsulado, expondo apenas o que é realmente essencial ao que queremos fazer. Olhando para este trecho sabemos exatamente que queremos abrir um arquivo e processar linha a linha de seu conteúdo, armazenando o resultado na variável ‘contents’. Todo o resto do <em>encanamento</em> está escondido dentro do método ‘open’. Podemos passar apenas o bloco do ‘while’ como um lambda e ele será executado no meio da implementação desse método. Se fôssemos reimplementar o método ‘open’ da classe ‘File’ para agir dessa forma, poderíamos fazer assim:</p>
<hr>
ruby
<p>class File <br>
  def File.open(<strong>args) <br>
    result = f = File.new(</strong>args) <br>
    if block_given? <br>
      begin <br>
        result = yield f <br>
      ensure <br>
        f.close <br>
      end <br>
    end <br>
    return result <br>
  end <br>
end <br>
<del>-</del></p>
<p>Aqui, simulamos a reabertura da classe ‘File’ e a reimplementação do método ‘open’. Note que primeiro checamos se foi passado um bloco (‘block_given?’) e daí usamos ‘yield’ para executar o lambda passado a ele, daí repassamos o arquivo ‘f’ recém-aberto. Quando seja lá o que ‘yield’ executar terminar, daí fechamos o arquivo e retornamos.</p>
<p>Aliás, é exatamente assim que os <strong>iteradores</strong> funcionam em Ruby. Um iterador serve para navegar pelos vários elementos de uma lista (ou outro objeto que se comporte como uma lista), sem se incomodar com os detalhes da implementação dessa lista (se é um array, uma lista ligada, uma sequência de bytes de um arquivo, etc).</p>
<p>Um pouco acima falei em reescrever de um jeito “um pouco mais Rubista”, mas vejamos um jeito mais Rubista ainda:</p>
<hr>
ruby
<p>contents = File.open(aFile).readlines.inject("") do |buf, line| <br>
  buf += line<br>
end<br>
<del>-</del></p>
<p>O método ‘readlines’ devolve um Array, onde cada elemento é uma linha do arquivo texto. O método “inject” é um <strong>Redutor</strong>: ele pega linha a linha do Array e repassa ao bloco, como primeiro parâmetro. O segundo parâmetro, ‘buf’, é um totalizador que é iniciado com o primeiro parâmetro que passamos no método ‘inject’, no caso a string vazia "". Ele repassa sempre esse objeto como segundo parâmetro do bloco. Dentro do bloco podemos fazer o que quiser, mas normalmente queremos que seja um totalizador por isso usamos o operador “+=” que significa “buf = buf + line”.</p>
<p>Em Ruby é muito comum utilizar essa maneira de pensar: em vez de pensar em <em>“como vamos iterar elemento a elemento”</em>, partimos do princípio que isso é trivial e daí pensamos <em>“como queremos filtrar elemento a elemento”</em>. Linhas como a seguinte são bastante comuns:</p>
<hr>
ruby
<p>&gt;&gt; [1,2,3,4,5].map { |elem| elem * elem }<br>
=&gt; [1, 4, 9, 16, 25]</p>
<p>&gt;&gt; [1,2,3,4,5].select { |elem| elem % 2 == 0 }<br>
=&gt; [2, 4]</p>
<p>&gt;&gt; [1,2,3,4,5].inject(0) { |total, elem| total += elem }<br>
=&gt; 15</p>
<p>&gt;&gt; total = 0<br>
=&gt; 0<br>
&gt;&gt; [1,2,3,4,5].each { |elem| total += elem }<br>
=&gt; [1, 2, 3, 4, 5]<br>
&gt;&gt; total<br>
=&gt; 15<br>
<del>-</del></p>
<p>O primeiro exemplo – “map” – substitui elemento a elemento pelo resultado do bloco. O segundo – “select” – devolve o resultado do filtro que é passado como bloco. O terceiro – “inject” – é o redutor que já vimos acima e o quarto – “each” – é a mesma coisa que o “inject” mas menos encapsulado e usando código extra para chegar ao mesmo efeito.</p>
<p>Para completar, blocos podem ser passados como parâmetro a um método usando duas sintaxes: chaves (“{}”) ou “do..end”, por exemplo:</p>
<hr>
ruby
{ |elem| puts elem }

do |elem|
puts elem
<p>end<br>
<del>-</del></p>
<p>Ambas as formas acima fazem a mesma coisa. A diferença é que costumamos usar chaves para blocos curtos, de uma única linha. Já o do..end é mais usado quando temos múltiplas linhas. Em ambos os casos os parâmetros do bloco vão entre pipes (“||”). Na realidade existem mais diferenças, mas para começar até aqui está bom.</p>
<h2>Tipos Básicos</h2>
<p>Invertendo a ordem das coisas, finalmente vamos falar um pouco mais sobre os tipos básicos do Ruby. Nós já vimos muitos deles então vamos apenas passar por eles rapidamente.</p>
<h3>Arrays</h3>
<p>Arrays são listas simples de elementos, a sintaxe mais básica é a seguinte:</p>
<hr>
ruby
<p>&gt;&gt; lista = [100,200,300,400]<br>
=&gt; [100, 200, 300, 400]<br>
&gt;&gt; lista<sup class="footnote" id="fnr2"><a href="#fn2">2</a></sup><br>
=&gt; 300<br>
<del>-</del></p>
<p>Até aqui nada de novo, porém o Ruby tem alguns facilitadores, por exemplo:</p>
<hr>
ruby
<p>?&gt; lista.first<br>
=&gt; 100<br>
&gt;&gt; lista.last<br>
=&gt; 400<br>
<del>-</del></p>
<p>Também já vimos que ele tem vários métodos que aceitam blocos para processar elemento a elemento, como “each”, “map”, “select”, “inject”. Já vimos anteriormente como operadores em Ruby nada mais são do que métodos. Vejamos como os Arrays se comportam:</p>
<hr>
ruby
<p>&gt;&gt; [1,2,3,4] + [5,6,7,8]<br>
=&gt; [1, 2, 3, 4, 5, 6, 7, 8]</p>
<p>&gt;&gt; [1,2,3,4,5] – [2,3,4]<br>
=&gt; [1, 5]</p>
<p>&gt;&gt; [1,2,3] * 2<br>
=&gt; [1, 2, 3, 1, 2, 3]<br>
<del>-</del></p>
<p>Como na maioria das linguagens a notação de colchetes (“[]”) deve ser familiar, para encontrar o elemento através do seu índice. Mas em Ruby, os colchetes também são operadores! Vamos fazer uma brincadeira:</p>
<hr>
ruby
<p>class Array<br>
  alias :seletor_antigo :[]<br>
  def [](indice)<br>
    return seletor_antigo(indice) if indice.is_a? Fixnum<br>
    return self.send(indice) if indice.is_a? Symbol<br>
    “Nada encontrado para #{indice}”<br>
  end<br>
end</p>
<p>&gt;&gt; lista = [1,2,3,4]<br>
=&gt; [1, 2, 3, 4]</p>
<p>&gt;&gt; lista<sup class="footnote" id="fnr2"><a href="#fn2">2</a></sup><br>
=&gt; 3</p>
<p>&gt;&gt; lista[:first]<br>
=&gt; 1</p>
<p>&gt;&gt; lista[:last]<br>
=&gt; 4</p>
<p>&gt;&gt; lista[:size]<br>
=&gt; 4</p>
<p>&gt;&gt; lista[“bla bla”]<br>
=&gt; “Nada encontrado para bla bla”<br>
<del>-</del></p>
<p>Viram o que aconteceu? Usamos “alias” novamente para criar um novo atalho à antiga implementação de [], daí reimplementamos []. Ele se comporta assim: se o parâmetro passado entre colchetes for um inteiro, é para se comportar como antes, portanto chamando o atalho “seletor_antigo”. Se for um símbolo (vamos explicar isso depois mas por enquanto entenda que é uma palavra com dois pontos antes, como “:first”), ele deve enviar a mensagem ao objeto usando “send”, ou seja, deve executar como se fosse um método. Dessa forma “lista[:first]” deve se comportar igual a “lista.first”. Finalmente, se for qualquer outra coisa (como um String), apenas mostre uma mensagem dizendo que nada foi encontrado.</p>
<p>Como podemos ver, mais do que o Array em si, o operador “[]” pode ser muito útil em vários cenários. Enfim, na maior parte dos casos um Array em Ruby se comporta muito parecido com um Array em qualquer outra linguagem.</p>
<h3>Hashes</h3>
<p>Um Hash, em outras linguagens, também é chamado de Dicionário, ou seja, é uma lista onde a ordem de inserção não é importante, e cada elemento é um par que liga uma chave a um valor. Por exemplo:</p>
<hr>
ruby
<p>&gt;&gt; dic = { “car” =&gt; “carro”, “table” =&gt; “mesa”, “mouse” =&gt; “rato” }<br>
=&gt; {"mouse"=&gt;"rato", “table”=&gt;"mesa", “car”=&gt;"carro"}</p>
<p>&gt;&gt; dic[“car”]<br>
=&gt; “carro”</p>
<p>&gt;&gt; dic[“mouse”]<br>
=&gt; “rato”<br>
<del>-</del></p>
<p>Novamente, é um comportamento parecido com um Array, mas em vez de passar índices numéricos ao operador “[]”, passamos uma chave e esperamos encontrar o valor correspondente. Para acrescentar mais elementos à lista, podemos fazer assim:</p>
<hr>
ruby
<p>&gt;&gt; dic.merge!( {"book" =&gt; “livro”, “leg” =&gt; "perna"} )<br>
=&gt; {"leg"=&gt;"perna", “mouse”=&gt;"rato", “table”=&gt;"mesa", “book”=&gt;"livro", “car”=&gt;"carro"}<br>
<del>-</del></p>
<p>Mais uma peculiaridade de Ruby. Um Hash tem dois métodos para mesclar novos elementos a uma lista já existente: “merge” e “merge!”. A diferença de um para outro é que o primeiro é um método não-destrutivo e o segundo é um método destrutivo, ou seja, o primeiro retorna a lista mesclada mas a original continua como antes, já o segundo método mescla os novos elementos diretamente na lista original. Ou seja, a linha anterior seria equivalente a fazer isso:</p>
<hr>
ruby
<p>dic = dic.merge( {"book" =&gt; “livro”, “leg” =&gt; "perna"} )<br>
<del>-</del></p>
<p>O resultado do merge é atribuído à mesma variável, ignorando a lista original, que é o que fazemos normalmente. Você também pode ter Hashes dentro de Hashes, assim:</p>
<hr>
ruby
<p>&gt;&gt; fabio = { “emails” =&gt; <br>
?&gt; { “trabalho” =&gt; “fabio.akita@locaweb.com.br”,<br>
?&gt; “normal” =&gt; “fabioakita@gmail.com” } }<br>
=&gt; {"emails"=&gt;{"normal"=&gt;"fabioakita@gmail.com", “trabalho”=&gt;"fabio.akita@locaweb.com.br"}}</p>
<p>?&gt; fabio[“emails”][“normal”]<br>
=&gt; “fabioakita@gmail.com”<br>
<del>-</del></p>
<p>Finalmente, podemos explorar o conteúdo de um Hash da seguinte maneira:</p>
<hr>
ruby
<p>&gt;&gt; dic.keys<br>
=&gt; [“leg”, “mouse”, “table”, “book”, “car”]<br>
&gt;&gt; dic.values<br>
=&gt; [“perna”, “rato”, “mesa”, “livro”, “carro”]</p>
<p>&gt;&gt; dic.keys.each do |chave|<br>
?&gt; puts “#{chave} = #{dic[chave]}”<br>
&gt;&gt; end<br>
leg = perna<br>
mouse = rato<br>
table = mesa<br>
book = livro<br>
car = carro<br>
<del>-</del></p>
<p>Se você entendeu blocos nas seções anteriores, este código deve ser bastante trivial de entender. Se não, retome a leitura do começo.</p>
<p>Hash é um dos tipos mais importantes e vamos retornar a ele em outra seção para ver como esse tipo é usado por todo tipo de codificação Ruby. Inclusive o Ruby on Rails utiliza Hashes o tempo todo em lugares onde a maioria nem imagina.</p>
<p>Continue lendo a <a href="/2008/11/10/micro-tutorial-de-ruby-parte-iii">Parte <span class="caps">III</span></a></p></macro:code>
