---
title: Swift para Rubistas, Rápida Introdução
date: '2014-06-03T17:01:00-03:00'
slug: swift-para-rubistas-rapida-introducao
tags:
- learning
- beginner
- apple
- swift
- objective-c
draft: false
---

Como vocês devem ter assistido no keynote de abertura da [WWDC 2014](http://startupi.com.br/2014/apple-esta-retornando-suas-formas-jobs-ficaria-orgulhoso/), a Apple lançou uma nova linguagem, mais moderna, para substituir o Objective-C como linguagem padrão para desenvolvimento de aplicações tanto OS X quanto iOS. Não se trata de uma nova "camada" mas uma linguagem que tecnicamente compila para o mesmo tipo de binário que o próprio Objective-C e mesmo C. Graças ao compilador que é implementado sobre LLVM isso se torna possível. 

A linguagem Swift é um Objective-C com funcionalidades mais modernas e uma sintaxe mais elegante e menos verbosa. Já havia [publicado neste blog](http://www.akitaonrails.com/Objective-C) anos atrás como o Objective-C e Ruby tem conceitos muito similares. E isso se deve à herança comum da linguagem Smalltalk.

Antes que algum afobado comece a trolar: o artigo não tem como objetivo dizer que Swift tem inspiração em Ruby ou que Ruby tem algum tipo de relação com Swift. Apenas aproveitando o fato de terem origens similares e funcionalidades que fazem sua programação ser próxima, quero usar o artigo para mostrar a rubistas algumas nuances do Swift.

Todos os exemplos de código foram extraídos do eBook [“The Swift Programming Language.”](https://itun.es/us/jEUH0.l) que é uma boa introdução à linguagem. Mas para realmente tirar proveito é melhor conhecer a fundo Objective-C, C e obviamente, toda a documentação de APIs dos frameworks para iOS e OS X.

## Exemplos de Sintaxe

Do ponto de vista da sintaxe, a linguagem está bem mais atraente. Vejamos um trecho muito simples em Swift:

--- C
if let actualNumber = possibleNumber.toInt() {
    println("\(possibleNumber) has an integer value of \(actualNumber)")
} else {
    println("\(possibleNumber) could not be converted to an integer")
}
// prints "123 has an integer value of 123”
---

E em Ruby:

--- ruby
if actual_number = possible_number && possible_number.to_i
  puts "#{possible_number} has an integer value of #{actual_number}"
else
  puts "#{possible_number} could not be converted to an integer"
end
# prints "123 has an integer value of 123”
---

Statements como "if" ou "for" não tem parênteses como em C, embora cada seção ainda seja separado por chaves "{}". Visualmente falando a diferença é bem pequena. Interpolação em strings tem uma sintaxe um pouco diferente mas no geral é muito semelhante. 

As convenções de nomenclatura são diferentes: no Ruby usamos tudo em caixa baixa separado por underline e Swift ainda tem a herança de Objective-C de camel casing. Além disso Swift identa código com 4 espaços e Ruby com 2.

Vejamos outro exemplo em Swift:

--- C
func alignRight(var string: String, count: Int, pad: Character) -> String {
    let amountToPad = count - countElements(string)
    for _ in 1...amountToPad {
        string = pad + string
    }
    return string
}
let originalString = "hello"
let paddedString = alignRight(originalString, 10, "-")
// paddedString is equal to "-----hello"
// originalString is still equal to "hello”
---

E o equivalente em Ruby seria:

--- ruby
def align_right(string, count, pad)
  amount_to_pad = count - string.size
  (1..amount_to_pad).each do
    string = pad + string
  end
  string
end
original_string = "hello"
padded_string = align_right(original_string, 10, "-")
---

A primeira semelhança é que Swift possui "Ranges" como em Ruby embora a notação seja oposta. Usamos ".." em Ruby para um range que inclui ambos os números extremos e "..." (3 pontos) para não incluir o último número. Em Swift é o contrário.

Em Swift, o correto é declarar os tipos dos argumentos e do valor de retorno e o "return" é explícito. No Ruby não tempos tipos pré-declarados e o retorno padrão é sempre o valor da última coisa executada. E falando em Ranges, tanto em Ruby quanto Swift podemos ter pattern matching de valores em intervalos:

--- C
let count = 3_000_000_000_000
let countedThings = "stars in the Milky Way"
var naturalCount: String
switch count {
case 0:
    naturalCount = "no"
case 1...3:
    naturalCount = "a few"
case 4...9:
    naturalCount = "several"
case 10...99:
    naturalCount = "tens of"
case 100...999:
    naturalCount = "hundreds of"
case 1000...999_999:
    naturalCount = "thousands of"
default:
    naturalCount = "millions and millions of"
}
println("There are \(naturalCount) \(countedThings).")
---

Em Ruby é praticamente a mesma coisa:

--- ruby
count = 3_000_000_000_000
counted_things = "stars in the Milky Way"
natural_count = case count
when 0 then "no"
when 1..3 then "a few"
when 4..9 then "several"
when 10..99 then "tens of"
when 100..999 then "hundreds of"
when 1000..999_999 then "thousands of"
else
  "millions and millions of"
end
puts "There are #{natural_count} #{counted_things}."
---

Swift e Ruby não precisam de "break" porque ele não cai para o próximo match. Ambos tem capacidade de comparar não só valores mas intervalos ou outros elementos. No caso, como Ruby tem return por default, não precisamos repetir a variável "natural_count" em cada ítem e o resultado geral do "case" vai para a única atribuição no topo.

Este outro trecho também é curioso:

--- C
if let roomCount = john.residence?.numberOfRooms {
    println("John's residence has \(roomCount) room(s).")
} else {
    println("Unable to retrieve the number of rooms.")
}
// prints "Unable to retrieve the number of rooms.”
---

O "equivalente" em Ruby (se estivermos no Rails) seria:

--- ruby
if room_count = john.residence.try(:number_of_rooms)
  puts "John's residence has #{room_count} room(s)."
else
  puts "Unable to retrieve the number of rooms."
end
---

Não é exatamente a mesma coisa. No Swift o "?" denota uma propriedade opcional e enviar uma mensagem a um objeto opcional devolve "nil". Na prática é quase a mesma coisa que o método [#try](http://guides.rubyonrails.org/active_support_core_extensions.html#try) do ActiveSupport do Rails.

E falando em ActiveSupport o Swift herda [Categories](http://code.tutsplus.com/tutorials/objective-c-succinctly-categories-and-extensions--mobile-22016) de Objective-C com o nome de Extensions, que é uma forma de estender a funcionalidade de uma classe que já existe:

--- C
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
println("One inch is \(oneInch) meters")
// prints "One inch is 0.0254 meters"
let threeFeet = 3.ft
println("Three feet is \(threeFeet) meters")
// prints "Three feet is 0.914399970739201 meters”
---

Em Ruby podemos facilmente fazer a mesma coisa diretamente porque classes são sempre abertas:

--- ruby
class Numeric
  def km; self * 1_000.0; end
  def m; self; end
  def cm; self / 100.0; end
  def mm; self / 1_000.0; end
  def ft; self / 3.28084; end
end

one_inch = 25.4.mm
puts "One inch is #{one_inch} meters"
three_feet = 3.ft
puts "Three feet is #{three_feet} meters"
---

Novamente, o resultado é similar mas os princípios são diferentes. A começar que no caso do Ruby estou abrindo a classe que é pai de todos os números, não só dos Floats (Doubles), caso contrário o segundo exemplo que é um Integer não funciona ("3.ft", teria que ser explicitamente "3.0.ft").

Além disso no Swift ele declara uma variável de processamento dinâmico. Nas semelhanças veja que tanto Swift quanto Ruby usam "self" para se referir ao objeto interno. Ambos permitem usar a notação de underline para delimitar milhares ("1_000", por exemplo).

Um outro exemplo mais prático em Swift seria este:

--- C
extension Int {
    func repetitions(task: () -> ()) {
        for i in 0..self {
            task()
        }
    }
}

3.repetitions({
    println("Hello!")
    })
// Hello!
// Hello!
// Hello!
---

E em Ruby já temos o equivalente ao método "repetitions" desta extension já implementada:

--- ruby
3.times do
  puts "Hello!"
end
---

Em particular veja que o Swift define um método que recebe uma função anônima, um bloco propriamente dito. Ele passa esse bloco entre chaves como parâmetro do método. É o equivalente no Ruby que passamos o bloco também entre chaves ou entre "do; end".

Outras coisas que lembram muito Ruby é como ele trata tipos de coleções:

--- C
var shoppingList = ["Eggs", "Milk"]
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
shoppingList[4...6] = ["Bananas", "Apples"]
---

Esse trecho quase que inteiramente se converte em como Ruby lida com arrays:

--- ruby
shopping_list = ["Eggs", "Milk"]
shopping_list += ["Chocolate Spread", "Cheese", "Butter"]
shopping_list[4...6] = ["Bananas", "Apples"]
---

O mesmo pode-se dizer de dicionários do Swift que são semelhantes a Hash no Ruby:

--- C
var airports = ["TYO": "Tokyo", "DUB": "Dublin"]
airports["LHR"] = "London"
for (airportCode, airportName) in airports {
    println("\(airportCode): \(airportName)")
}
---

Em Ruby seria:

--- ruby
airports = {TYO: "Tokyo", DUB: "Dublin"}
airports[:LHR] = "London"
for airport_code, airport_name in airports
  puts "#{airport_code}: #{airport_name}"
end
---

Em particular este último trecho, em Ruby, seria mais comumente escrito como:

--- ruby
airports.each do |airport_code, airport_name|
  puts "#{airport_code}: #{airport_name}"
end
---

A diferença é que Swift inicializa dicionários com a mesma sintaxe de arrays, com colchetes. Em Ruby diferenciamos arrays com colchetes e hashes com chaves. Além disso é comum usar chaves como strings em Swift e Objective-C pois eles são imutáveis por padrão. Em Ruby strings são tecnicamente mutáveis e o equivalente a uma "string imutável" em Ruby são symbols. Ao ser interpolado dentro de uma string, um symbol automaticamente se converte em string.

Já um tipo que Swift e outras linguagens como Python tem, e Ruby não tem, são Tuples. De forma simplificada, se trata de uma lista heterogênea (como um array) de constantes. Em Ruby usamos um Array para o mesmo fim. E temos, novamente, usos similares:

--- C
let http404Error = (404, "Not Found")
let (statusCode, statusMessage) = http404Error
println("The status code is \(statusCode)")
// prints "The status code is 404"
println("The status message is \(statusMessage)")
// prints "The status message is Not Found”
---

Veja que podemos decompor um Tuple de volta em variáveis de maneira similar em Ruby:

--- ruby
http_404_error = [404, "Not Found"]
status_code, status_message = http_404_error
puts "The status code is #{status_code}"
puts "The status message is #{status_message}"
---

## Conclusão

Isso foi apenas um rápido "tour" sobre as partes mais superficiais da linguagem. Swift ainda tem: 

* tipos Enum (diferente de funcionalidades de Enumeration do Ruby, não confundir)
* propriedades (getter, setter, weak references, etc)
* inicialização, deinicialização, ARC (procedimentos para automatic reference counting)
* tipos (type casting, nested types, generics, extensions, protocols)

Diferente de linguagens como Go ou Scala, ela não tem diretamente na linguagem nenhuma construção para abstrair atores ou outras coisas de concorrência. Isso porque no Objective-C e no Swift vamos subir para o nível dos frameworks, em particular para o [Grand Central Dispatch](https://developer.apple.com/library/mac/documentation/performance/reference/gcd_libdispatch_ref/Reference/reference.html) que basicamente funciona como um sistema de filas de processamento.

Como podem ver, Swift em si é uma linguagem bem minimalista. Sua intenção é ser um "sugar coating" sobre a cansada sintaxe do Objective-C, a cansativa rotina de lidar com arquivos de header e implementação, declaração estática de tipos em todos os lugares. Mas o que a linguagem não tem como "consertar" é a extensiva quantidade de APIs do Cocoa. Não se engane, é tudo muito bem organizado e consistente, diferente de outras plataformas.

Por exemplo, hoje (1 dia depois do anúncio da linguagem, para verem como a sintaxe é trivial de simples) já saiu um pequeno demo que é basicamente um [clone do famigerado Flappy Bird](https://github.com/fullstackio/FlappySwift), usando o SpriteKit como fundação. E veja um trecho mais realista:

--- C
// skyline
var skyTexture = SKTexture(imageNamed: "sky")
skyTexture.filteringMode = SKTextureFilteringMode.Nearest

var moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.1 * skyTexture.size().width * 2.0))
var resetSkySprite = SKAction.moveByX(skyTexture.size().width * 2.0, y: 0, duration: 0.0)
var moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite,resetSkySprite]))

for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( skyTexture.size().width * 2.0 ); ++i {
    var sprite = SKSpriteNode(texture: skyTexture)
    sprite.setScale(2.0)
    sprite.zPosition = -20;
    sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
    sprite.runAction(moveSkySpritesForever)
    self.addChild(sprite)
}
---

Não é nada do outro mundo, só precisa se acostumar com as APIs. A documentação da Apple é muito bem feita e fácil de usar.
