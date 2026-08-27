---
title: "[Off-Topic] Carreira em Programação - Codificar não é Programar"
date: '2014-05-02T15:57:00-03:00'
slug: off-topic-carreira-em-programacao-codificar-nao-e-programar
translationKey: off-topic-carreira-em-programacao-codificar-nao-e-programar
description: "Programar não é apenas montar sites com frameworks: o autor defende estudar inglês, Ciência da Computação e fundamentos como álgebra, estatística, algoritmos e compiladores para criar soluções de valor."
tags:
- carreira
- aprendizado
- ciencia-da-computacao
- off-topic
draft: false
---

Um assunto que sempre discuto é a formação de programadores. A grande maioria dos artigos que se encontra na internet hoje lista apenas "técnicas": como ser um montador, como pegar peças que já existem e encaixá-las. Existe valor nisso, mas isso é uma fração minúscula da carreira de "programação", não a carreira inteira.

Dá para pegar um conhecimento inicial, digamos web e HTML, juntar alguns frameworks e bibliotecas (Rails, Django, WordPress) e colocar algo funcional no ar. Mas isso é pouco. Muito pouco.

O fato de ser tão simples, beirando o trivial, colocar "algo funcional" no ar esconde todo o potencial que existe na carreira de programação. Pior: o imediatismo do resultado cria a ilusão de que só isso basta e de que qualquer conhecimento mais avançado é desnecessário.

O reflexo disso aparece no crescimento dos cursos técnicos de programação e na baixa procura pelo bacharelado em Ciência da Computação. Quanto menos gente trabalhando nos fundamentos, na origem de tudo, mais sucateado o mercado fica daqui pra frente.

Você tem hoje um emprego de codificador: recortador de Photoshop, montador de HTML, colador de plugins de WordPress. Pare para pensar em como sua carreira vai evoluir daqui pra frente. Vai ser sempre só um montador? Vai pegar o caminho fácil e virar um "gerente" meia-boca de montadores?

Num único post é impossível listar e explicar todos os aspectos importantes da Ciência da Computação. Mas quero experimentar citar pelo menos alguns dos assuntos que a maioria acha desnecessário, só para provocar você a procurar mais.

## Aprenda a pelo menos "LER" fluentemente em Inglês

Eu gosto da língua portuguesa e ela sempre vai ser minha primeira língua. Mas pseudo-patriotismo e preguiça não mudam um fato: se você não se dedicar desde já a ler inglês com fluência, vai viver defasado num nível lastimável.

A primeira razão é que no mundo Ocidental tudo que é novo sai primeiro em inglês. (Excluo o Oriente porque não sei ler chinês, e o mercado de lá também é gigantesco.) Esperar alguém se interessar em traduzir custa trabalho e tempo.

Se depender da versão em português, você vai ver material defasado. E quando o assunto finalmente te interessar, ele pode já estar obsoleto. Aí a distância deixa de ser um passo e vira centenas de quilômetros.

A segunda razão é que a internet é globalizada. É comum pegar código feito em outros países para continuar, e é comum o código que você escreve ter que ser dividido com programadores de fora. Faça um favor a si mesmo: não passe vergonha.

## Guerras Religiosas

Programação é ciência. Não tem horóscopo, não tem guru, não tem torcida de futebol, numerologia nem astrologia. Lembre-se do nome: **CIÊNCIA** da Computação. Ninguém chama de **Astrologia** da Computação.

Todo mundo tem gostos subjetivos. Transformar gosto em dogma é estupidez. A preguiça de aprender algo novo produz o famoso _"Sou bom em Clipper, essa linguagem vai evoluir no futuro e sempre vai existir, basta eu defender com unhas e dentes não importa o que surja depois."_

Troque "Clipper" por qualquer outra: Cobol, Basic, Pascal, Algol, Eiffel, Smalltalk, até as mais recentes como Java, C#, Javascript, Python. Alguma coisa existir hoje não garante nada sobre amanhã. Pense em quão ridículo deve se sentir agora quem disse a frase acima.

Não faça esse papel. Em Ciência a gente não é leal a "times": torce para quem está ganhando e troca assim que ele se prova errado. É por isso que a Ciência sempre evolui.

E surpresas acontecem. Nos anos 80 e 90 ninguém deu bola para Objective-C; parecia fadada ao fracasso. Aí, em 2007, surge o iPhone e, surpresa, era preciso saber Objective-C. De repente ela virou uma das linguagens de maior sucesso do fim da primeira década do Século XXI. A cada dez anos o mercado se transforma de alguma forma. É a ["Lei de Bell"](http://en.wikipedia.org/wiki/Bell's_law_of_computer_classes).

## Aceite: suas soluções hoje são Ruins

Voltando ao tema **"Ignore as Guerras Religiosas"**: como saber o que fazer? Atenha-se aos princípios. Jogue fora o que os gurus falam, não idolatre ninguém, não siga cegamente ninguém. Desça às perguntas fundamentais e a direção mais óbvia aparece.

Quando você sabe como as coisas funcionam, tira o verniz, abre o capô, desmonta o motor, entende a química da combustão, só então domina a arte. Se você mal lembra pra que diabos serve trocar o óleo, vai ser sempre um motorista medíocre, no melhor dos casos. Qual é o seu objetivo? Se for ser o engenheiro do carro, ouvir gurus falando da cor do volante não te leva longe.

A Ciência da Computação costuma ser ignorada porque parece que aprender Matemática, além de chato, é inútil.

Vamos a alguns exemplos. Se eu perguntar a um iniciante como procurar por palavras dentro de um texto, as coisas mais óbvias que devem vir à cabeça são:

* usar funções de substring e um loop para vasculhar o texto (solução brute-force)
* usar uma expressão regular ou num banco de dados usar um "LIKE" (solução genérica)
* instalar um SOLR ou Elasticsearch (solução correta em muitos casos, mas "magia negra" no entendimento)

A maioria nem pensa na terceira solução. E quem pensa não sabe por quê. E se eu disser que, de forma absolutamente crua e resumida, a solução está em transformar o documento e os termos de busca em vetores e calcular a relevância entre eles por [similaridade de cosseno](http://en.wikipedia.org/wiki/Cosine_similarity)? É exatamente isso que significa [Vector Space Model](http://en.wikipedia.org/wiki/Vector_space_model) (VSM), que você encontra em diversas engines de procura.

<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; height: auto; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'>{{< youtube id="ZEkO8QSlynY" >}}</div>

O conhecimento por trás disso se chama [**Álgebra Linear**](http://en.wikipedia.org/wiki/Linear_algebra). Lembra dele, do PRIMEIRO ano de Ciência da Computação? Sobre esse assunto recomendo uma palestra que fiz, ["Como não fazer pesquisas usando LIKE"](https://www.eventials.com/akitaonrails/como-nao-fazer-pesquisas-usando-like/).

E quando você precisa criar um processo para filtrar conteúdo impróprio? A maioria pensaria assim:

* criar um blacklist de palavras e ir adicionando à medida que se lembra de palavras ofensivas. E usar a primeira ou segunda opção do que listei antes para buscar essas palavras.

Como você já imagina, a resposta mais "óbvia" ou "simples" (dada a falta de conhecimento) costuma ser a errada, e aqui ela também não é a mais eficiente.

Conheça machine learning e uma das suas formas mais simples, o [Classificador Bayesiano Ingênuo](http://en.wikipedia.org/wiki/Naive_Bayes_classifier). Alguém pode pensar _"puts, mas isso de machine learning é avançado demais pro dia a dia."_ De maneira alguma. Aliás, qualquer filtro anti-spam vagabundo que você encontra num site de downloads gratuitos usa um classificador.

A ideia é que palavras isoladas não bastam para dizer se um conteúdo é impróprio. A forma de construir as frases, o "tom" da escrita, tudo isso forma um padrão que pode ser classificado e aprendido. Quanto mais conteúdo impróprio é classificado, mais eficiente o algoritmo fica.

Se quiser experimentar uma forma simples [em Ruby, veja este blog](http://web.archive.org/web/20140423094927/http://blog.logankoester.com/bayesian-classification-on-rails). Se quiser aprender sobre classificadores mais avançados, veja o projeto [Apache Mahout](https://mahout.apache.org/).

{{< youtube id="DdYSMwEWbd4" >}}

E o que é isso? É matéria de [**Estatística e Probabilidade**](https://www.khanacademy.org/math/probability). Os fundamentos para entender isso estão, de novo, no PRIMEIRO ano de Ciência da Computação.

_"Ah, mas você está falando coisas que ninguém precisa saber. Pra fazer sites web isso é desnecessário."_

Um bom framework web precisa mapear rotas para a programação por baixo (os controllers) com eficiência. O Ruby on Rails tem um componente de rotas chamado [Journey](https://github.com/rails/journey), que configuramos pelo arquivo "config/routes.rb". Abaixo temos um trecho disso:

```ruby
ImageUploadDemo::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :photos

  authenticated :user do
    root :to => 'photos#index'
  end
  root :to => "photos#index"
  devise_for :users

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  ActiveAdmin.routes(self)
end
```

Quão difícil isso pode ser? O que a maioria imaginaria?

* Fácil, basta fazer um conjunto de arrays ou um hash (dicionário) e, quando chegar a URL, quebrar os termos via uma regular expression e encontrar o controller passando os parâmetros pra executar.

Repetindo: sim, isso funciona, para aplicações bem pequenas. Qualquer coisa muito maior que o exemplo acima já vai dar problema de performance.

Que tal ver um trecho do código do Journey?

```ruby
class Journey::Parser

token SLASH LITERAL SYMBOL LPAREN RPAREN DOT STAR OR

rule
  expressions
    : expressions expression  { result = Cat.new(val.first, val.last) }
    | expression              { result = val.first }
    | or
    ;
  expression
    : terminal
    | group
    | star
    ;
  group
    : LPAREN expressions RPAREN { result = Group.new(val[1]) }
    ;
  or
    : expressions OR expression { result = Or.new([val.first, val.last]) }
    ;
  star
    : STAR       { result = Star.new(Symbol.new(val.last)) }
    ;
  terminal
    : symbol
    | literal
    | slash
    | dot
    ;
  slash
    : SLASH              { result = Slash.new('/') }
    ;
  symbol
    : SYMBOL             { result = Symbol.new(val.first) }
    ;
  literal
    : LITERAL            { result = Literal.new(val.first) }
  dot
    : DOT                { result = Dot.new(val.first) }
    ;

end
```

Em bom português, agora **fodeu**. Parte do Journey se utiliza do [Racc](https://github.com/tenderlove/racc), um gerador de parsers.

Se você passou pelo menos pelo SEGUNDO ano de Ciência da Computação, então viu as matérias de [**Algoritmos e Estruturas de Dados**](http://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs) e Montadores. E se chegou ao TERCEIRO ano, aprendeu sobre [**Compiladores**](http://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools) (e viu o famoso livro do Dragão). O Racc deve ter te lembrado de Yacc, Flex, Bison.

{{< youtube id="QPCC2sbukeo" >}}

Para arrematar, você deve achar que sabe o que é [**Orientação a Objetos**](http://c2.com/cgi/wiki?NobodyAgreesOnWhatOoIs), certo? Aposto que considera sua linguagem favorita (seja Java, C# ou Javascript) orientada a objetos. Se eu pedir para definir o que isso significa, está na ponta da sua língua:

* Minha linguagem suporta Encapsulamento, Herança e Polimorfismo, portanto é orientada a objetos.

E se eu lhe disser que linguagens procedurais, imperativas e funcionais também suportam encapsulamento, herança (via delegação ou não) e polimorfismo? E se é esse o caso, então [o que define orientação a objetos?](http://c2.com/cgi/wiki?NobodyAgreesOnWhatOoIs)

Quem se entreteve no assunto talvez lembre de [Alan Kay](http://en.wikipedia.org/wiki/Alan_Kay), que cunhou o termo "orientação a objetos". Mas quantos pararam para pesquisar a linguagem Simula 67? O que o Simula introduziu em 1967? Objetos, classes, herança, subclasses, métodos virtuais, [corotinas](http://en.wikipedia.org/wiki/Coroutine), simulação de eventos discretos, garbage collection.

E quantos já ouviram falar dos criadores do Simula 67, [Kristen Nygaard](http://en.wikipedia.org/wiki/Kristen_Nygaard) e [Ole-Johan Dahl](http://en.wikipedia.org/wiki/Ole-Johan_Dahl)?

Não sabe quem são? Tenho certeza que não. Pois eu lhe apresento os pais da orientação a objetos.

## Sobre os Ombros de Gigantes

O que mencionei na seção anterior é uma gota d'água na ponta do iceberg. O importante é você ganhar consciência de que tudo que você acha que sabe é perto de nada. Quero que você aceite que tudo que você acha que sabe ou está errado ou é totalmente incompleto.

Isso é importante porque quem acha que já sabe tudo, ou perto disso, nunca vai aprender nada. Você precisa esvaziar o copo para poder enchê-lo. (by Bruce Lee)

![Bruce Lee Quote](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/406/big_quote-emptiness-the-starting-point-in-order-to-taste-my-cup-of-water-you-must-first-empty-your-cup-bruce-lee-246247.jpg)

Além disso, quero que você entenda que não está sozinho. Antes de você vieram dezenas de grandes mentes. E não falo desses gurus superficiais que ensinam meramente técnicas e ferramentas. Esqueça-os, todo mundo vai esquecê-los em breve também.

Todo mundo sabe quem é Linus Torvalds, Bill Gates, Steve Jobs, Zuckerberg. Esqueça-os por enquanto. Atenha-se aos imortais, os nomes que realmente fizeram diferença na história da Ciência da Computação. Alguns exemplos:

* [Charles Babbage](http://en.wikipedia.org/wiki/Charles_Babbage)
* [Ada Lovelace](http://en.wikipedia.org/wiki/Ada_Lovelace)
* [George Boole](http://en.wikipedia.org/wiki/George_Boole)
* [Alan Turing](http://en.wikipedia.org/wiki/Alan_Turing)
* [Alonzo Church](http://en.wikipedia.org/wiki/Alonzo_Church)
* [John von Neumann](http://en.wikipedia.org/wiki/John_von_Neumann)
* [John McCarthy](https://en.wikipedia.org/wiki/John_McCarthy_(computer_scientist))
* [Niklaus Wirth](http://en.wikipedia.org/wiki/Niklaus_Wirth)
* [Bertrand Meyer](http://en.wikipedia.org/wiki/Bertrand_Meyer)
* [Dan Ingals](http://en.wikipedia.org/wiki/Dan_Ingalls)
* [Donald Knuth](http://en.wikipedia.org/wiki/Donald_Knuth)
* [Edsger W. Dijkstra](http://en.wikipedia.org/wiki/Edsger_Dijkstra)

E isso é só uma amostra. Ciência é um campo amplo, onde o trabalho de um cientista complementa o do anterior. Passo a passo, sempre para frente. É um trabalho acumulativo de dezenas, centenas de anos. Nossa vantagem? Centenas de pessoas já trilharam esse caminho no passado, e podemos nos utilizar do que elas aprenderam e deixaram para nós, em vez de cometermos os mesmos erros até aprender sozinhos.

{{< youtube id="6dME3wgaQpM" >}}

Quase tudo que você vê por aí chamado de ["inovação"](http://web.archive.org/web/20140506054007/http://startups.ig.com.br/2013/restricoes-sao-libertadoras-menos-e-mais/) é a redescoberta de coisas já documentadas no passado, mas que estavam à frente do seu tempo. Foi assim com o mouse: [Douglas Engelbart](http://en.wikipedia.org/wiki/Douglas_Engelbart), que o criou em 1968, precisou esperar dezesseis anos, até Steve Jobs lançar o Macintosh, para ver sua invenção popularizada. Pare para pensar: quantas descobertas estão no passado, só esperando que alguém as desenterre para finalmente realizá-las?

Quer conhecer os livros imortais da Ciência da Computação? Vão alguns:

* [Structure and Interpretation of Computer Programs (SICP)](http://en.wikipedia.org/wiki/Structure_and_Interpretation_of_Computer_Programs)
* [The C Programming Language (K&R)](http://en.wikipedia.org/wiki/The_C_Programming_Language)
* [Algorithms + Data Structures = Programs](http://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs)
* [Compilers: Principles, Techniques and Tools](http://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools) - o livro do Dragão
* [Modern Operating Systems](http://en.wikipedia.org/wiki/Modern_Operating_Systems)
* [Computer Networks](http://en.wikipedia.org/wiki/Computer_network)
* [The Art of Computer Programming](http://en.wikipedia.org/wiki/The_Art_of_Computer_Programming) - nem eu li esses livros, e desconheço quem tenha lido e entendido, mas vou deixar aqui pela importância.

[Não quer fazer faculdade?](http://www.akitaonrails.com/2009/04/17/off-topic-devo-fazer-faculdade) Sem problema, tente acompanhar o material que o MIT disponibiliza online de [Electrical Engineering and Computer Science](http://web.archive.org/web/20140430225124/http://ocw.mit.edu/courses/). Se você ainda é amador completo mesmo no mundo da programação, veja este curso introdutório de Ciência da Computação no [Coursera](http://web.archive.org/web/20140517025706/https://www.coursera.org/course/cs101).

Repare que não estou citando neste artigo nenhum dos nomes que muitos poderiam esperar, como Martin Fowler, Bruce Eckel, Robert Martin, Michael Feathers, Kent Beck, Steve McConnell, Tom DeMarco, Dave Thomas. Esqueça-os por ora. Sem os anteriores, estes fazem pouca diferença.

Não coloque o carro na frente dos bois. Vá um passo de cada vez.

## Carreira em Programação

Uma coisa que eu sempre repito é o seguinte:

<blockquote>"Programar não é escrever qualquer código da mesma forma que culinária não é jogar qualquer ingrediente numa panela."</blockquote>

Entenda: escrever código é muito simples. Qualquer um que tenha o mínimo de coordenação motora para não tentar passar uma peça quadrada num buraco redondo, ou que minimamente já tenha empilhado uma peça de Lego em cima da outra, tem condições de escrever código. Não há mérito nenhum nisso.

Baixar um Twitter Bootstrap, usar um gerador do Yeoman, instalar um MySQL no Ubuntu, copiar e colar um trecho de jQuery: qualquer um consegue fazer.

Em termos de carreira, o que "qualquer um" consegue fazer é um mero ["commodity"](http://en.wikipedia.org/wiki/Commodity). Ser commodity significa que o valor que o mercado se dispõe a pagar só vai cair. De vez em quando surge alguma novidade que tenta criar uma diferenciação (_"veja, Angular JS"_, _"veja, HTML 5"_), mas ela se dissolve rápido na tendência de queda do valor.

O valor mora na criatividade da solução: extrair o maior resultado pelo menor custo. E criatividade só existe quando você domina todos os elementos ao seu redor. Quando uma hora de trabalho troca um algoritmo idiota de busca de palavras por um vector space model, reduz seu parque de dez máquinas para duas e responde ao usuário em um quinto do tempo, isso é conhecimento aplicado. E conhecimento assim tem valor, e cresce.

Uma caixa de ferramentas cheia faz de você um "faz-tudo com muitas ferramentas". O engenheiro ou arquiteto capaz de construir o próximo World Trade Center ou a Freedom Tower é outra coisa.

Mas, como todo mundo que quer evoluir, todos começamos como faz-tudo. Não há nada de errado nisso. Só não se iluda achando que uma caixa com mais ferramentas te transforma em algo diferente disso.
