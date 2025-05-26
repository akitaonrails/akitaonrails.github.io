---
title: Ruby Symbols
date: '2007-11-26T11:33:00-02:00'
slug: ruby-symbols
tags:
- learning
- beginner
- ruby
draft: false
---

Meu amigo Satish Talim me convidou para escrever um artigo no seu site [Ruby Learning](http://rubylearning.com). O tema desta vez foi [Ruby Symbols](http://rubylearning.com/blog/2007/11/26/akitaonrails-on-ruby-symbols/). Portanto escrevi um artigo tentando desmistificar o que é um símbolo e para que servem.

O artigo original foi em inglês, abaixo segue a tradução em português:


Ruby é muito similar a muitas outras linguagens orientadas a objeto. Podemos encontrar construções similares em linguagens não-dinâmicas como Java ou C#. Por outro lado, para começar a tocar nas possibilidades de Ruby é necessário investir tempo aprendendo o que chamamos de “Rubismos”. Um exemplo disso são **Símbolos**.

Isso é mais óbvio quando se começa a aprender Ruby através de Rails. Muito do poder de Rails vem do fato dele usar muitos rubismos. Vejamos um exemplo:

* * *
ruby

class Transact \< ActiveRecord::Base  
 validates\_presence\_of :when  
 validates\_presence\_of :category, :account  
 validates\_presence\_of :value  
 validates\_numericality\_of :value

belongs\_to :category belongs\_to :account

end  
-

‘class’ é fácil, afinal, todas as grandes linguagens são ‘orientadas-a-objeto’. Mas o que são os “dois-pontos” por todo o código? Eles denotam Símbolos. Mais importante, esses dois-pontos representam inicializadores da classe Symbol.

Isso pode ser bem confuso considerando que o jeito normal de inicializar um objeto é:

* * *
rubySymbol.new—-

A chamada ‘new’ pede pelo método padrão ‘initialize’ definido dentro da classe. Acontece que esse método é privado na classe Symbol, a idéia sendo que todo símbolo deve ser instanciado com a notação de dois-pontos.

Símbolos são usados como identificadores. Outras linguagens poderiam simplesmente usar Strings em vez de Símbolos. Em Ruby, ficaria parecido com isso:

* * *
ruby

class Transact \< ActiveRecord::Base  
 validates\_presence\_of “when”  
 validates\_presence\_of “category”, “account”  
 validates\_presence\_of “value”  
 validates\_numericality\_of “value”

belongs\_to “category” belongs\_to “account”

end  
-

Visualmente não ficou tão diferente: nos livramos dos dois-pontos e voltamos às confortáveis aspas. Parece a mesma coisa mas o comportamenteo é diferente. Como Símbolos em Ruby, Strings também tem um construtor especial. Em vez de fazer:

* * *
rubyString.new(“category”)—-

Apenas fazemos:

* * *
ruby"category"—-

Alguém poderia chamar esse tipo de atalho de “enfeite”, mas a linguagem seria bem chata sem eles. Usamos Strings o tempo todo, e seria muito doloroso instanciar novos Strings sem esse construtor especial: simplesmente escrevendo entre aspas.

O problema é, como Strings são fáceis de escrever, nós abusamos mais do que deveríamos. Existe um efeito colateral: cada nova construção instancia um novo objeto em memória, mesmo tendo o mesmo conteúdo. Por exemplo:

    >> "category".object_id
    => 2953810
    
    >> "category".object_id
    => 2951340

Aqui instanciamos 2 strings com o mesmo conteúdo. Cada objeto em memória tem um ID único de forma que cada string acima usa um pedaço separado de memória e tem IDs separados. Agora imagine que os mesmos strings acima apareçam centenas de vezes em diferentes lugares pelo seu projeto. Definitivamente estamos usando mais memória do que necessário.

Mas, isso não é um problema novo. Para isso, temos outra construção na maioria das linguagens chamada ‘constantes’, incluindo Ruby. Temos que planejar e pré-definir diversas constantes de ante-mão, de forma consciente. Então, nosso exemplo anterior, com uso de constantes ficaria assim:

* * *
ruby

class Transact \< ActiveRecord::Base  
ACCOUNT = “account”  
CATEGORY = “category”  
VALUE = “value”  
WHEN = “when”

validates\_presence\_of WHENvalidates\_presence\_of CATEGORY, ACCOUNTvalidates\_presence\_of VALUEvalidates\_numericality\_of VALUEbelongs\_to CATEGORYbelongs\_to ACCOUNT

end  
-

Isso funciona, mas não é nem de perto mais legal. Primeiro, é preciso pré-definir tudo antecipadamente, seja na mesma classe ou em um módulo separado apenas para constantes. Segundo, o código é menos elegante, menos legível, portanto, de mais difícil manutenção.

Então, voltamos ao propósito de Símbolos: ser tão eficientes em consumo de memória quanto constantes mas tão agradáveis aos olhos como strings. Notação de aspas já é de Strings, palavras em maiúsculo para constantes, cifrão para variáveis globais e assim por diante. Então, dois-pontos foi um bom candidato.

Vejamos o que isso significa:

    >> "string".object_id
    => 3001850
    >> "string".object_id
    => 2999540
    
    >> :string.object_id
    => 69618
    >> :string.object_id
    => 69618

Como explicamos antes, os primeiros 2 strings têm o mesmo conteúdo e parecem similar, mas ocupam espaços diferentes de memória, permitindo duplicação desnecessária.

Os últimos 2 símbolos são exatamente a mesma coisa. Então posso chamar identificadores como símbolos por todo meu código sem me preocupar com duplicação em memória. Eles são fáceis de inicializar e fáceis de gerenciar.

Podemos também transformar um String em um Símbolo e vice-versa:

    >> "string".to_sym
    => :string
    >> :symbol.to_s
    => "symbol"

Um lugar onde isso é usado muito bem é dentro do pacote ActiveSupport do Rails. Esse pacote foi feito para estender a linguagem Ruby e uma dessas extensões foi feita na comum classe Hash. Vejamos um exemplo:

    >> params = { "id" => 1, "action" => "show" }
    => {"action"=>"show", "id"=>1}
    
    >> params["id"]
    => 1
    
    >> params.symbolize_keys!
    => {:id=>1, :action=>"show"}
    
    >> params[:id]
    => 1

O primeiro comando linha instancia e popula um Hash (e temos mais uma notação especial de inicialização). O segundo comando pede pelo valor identificado pela chave “id”, que é uma string.

Em vez de fazer dessa maneira, podemos chamar o método symbolize\_keys! para transformar todas as chaves string em chaves símbolo. Agora, no último comando podemos usar a notação mais comum em Rails de símbolos como chaves dentro de um Hash. Quando o Rails recebe um post de um formulário HTML, ele apenas recebe strings, portanto é seu trabalho converter tudo em objetos que façam sentido. Se você esteve no mundo Rails, já viu esse uso em controllers.

Então, isso é tuod que pode ser dito sobre Símbolos: construções muito simples que tornam o código mais legível e mais eficiente ao mesmo tempo, o que é compatível com a filosofia Ruby.

