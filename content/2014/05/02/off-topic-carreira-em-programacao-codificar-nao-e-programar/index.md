---
title: "[Off-Topic] Carreira em Programação - Codificar não é Programar"
date: '2014-05-02T15:57:00-03:00'
slug: off-topic-carreira-em-programacao-codificar-nao-e-programar
tags:
- off-topic
- career
- insights
- carreira
draft: false
---

Um assunto que sempre discuto é sobre a formação de programadores. A grande maioria (se não todos) os artigos que se encontra na internet hoje em dia lista apenas "técnicas", ou "como ser um montador", "como pegar peças que existem e montá-las". Apesar de existir muito valor nisso, vamos deixar bem claro que isso não constitui toda a carreira de "programação", apenas uma minúscula fração.

Sempre podemos pegar algum conhecimento inicial, por exemplo, web e HTML, juntar alguns frameworks e bibliotecas (Rails, Django, Wordpress) e de fato colocar alguma coisa funcional no ar. Mas isso é pouco, muito pouco.

O fato de ser tão "simples", beirando o trivial, colocar "alguma coisa funcional" no ar, esconde todo o potencial que existe na carreira de programação. Pior do que isso, o imediatismo de se ter um resultado leva à ilusão de que só isso é o suficiente e que qualquer conhecimento mais "avançado" é completamente desnecessário. O reflexo disso é o crescimento dos cursos técnicos de programação e a baixa adesão a cursos de bacharelado de Ciências da Computação. Isso é péssimo porque quanto menos gente tivermos trabalhando nos fundamentos, na origem de tudo, mais sucateado fica o mercado daqui pra frente.

Só porque neste instante você tem um emprego de codificador (recortador de photoshop, montador de HTML, colador de plugins de Wordpress, etc), pare para pensar como sua carreira vai evoluir daqui pra frente. Você vai ser sempre só um montador? Vai pegar o caminho fácil de virar um "gerente" meia-boca de montadores?

Infelizmente, em um único post, é impossível listar e explicar todos os aspectos importantes da Ciência da Computação. Mas quero experimentar listar pelo menos alguns dos assuntos que a maioria acha desnecessário para provocá-los a procurar mais.

## Aprenda a pelo menos "LER" fluentemente em Inglês

Sinto muito, eu gosto da língua portuguesa, sempre vai ser minha primeira língua. Porém pseudo-patriotismo ou pura preguiça não vai eliminar o fato de que se você não se dedicar desde já a ser fluente na leitura do Inglês, você sempre estará defasado num nível lastimável.

A primeira razão é que no mundo Ocidental (estou excluindo o que acontece no Oriente, porque eu não sei ler Chinês e o mercado lá também é gigantesco) tudo que sai de novo sai primeiro em inglês. Se for esperar alguém se interessar em traduzir, pense no trabalho que isso dá e o tempo que leva. Você vai estar necessariamente vendo material defasado se esperar sair em português. E quando começar a se interessar pelo material pode ser que ele já esteja inclusive obsoleto. Você não vai estar um passo atrás, vai estar centenas de quilômetros atrás.

A segunda razão é que o mundo da internet é globalizado. Não é incomum pegar código feito em outros países para continuar e não é incomum o código que você fizer ter que ser dividido com programadores de outros países. Se faça um favor: não passe vergonha.

## Guerras Religiosas

Programação não é torcida de futebol, nem numerologia, nem astrologia. Não tem horóscopo, não tem guru. Lembre-se isso se chama **CIÊNCIA** da Computação, não **Astrologia** da Computação.

Todo mundo tem gostos subjetivos, só que é estupidez transformar gosto em dogma. A preguiça de ter que aprender algo novo faz o famoso _"Sou bom em Clipper, essa linguagem vai evoluir no futuro e sempre vai existir, basta eu defender com unhas e dentes que não importa o que surgir depois."_

Substitua "Clipper" por qualquer outra, de Cobol, Basic, Pascal, Algol, Eiffel, Smalltalk, etc até as mais recentes, Java, C#, Javascript, Python, etc. Só porque alguma coisa existe hoje não há absolutamente nenhuma garantia que vai continuar existindo. Pense quão ridículo alguém que disse a frase acima não deve estar se sentindo agora. Não faça esse papel. Em Ciências não somos leais a "times", torcemos sempre para quem está ganhando e trocamos tão logo ele se prove errado. É por isso que Ciência sempre evolui.

E surpresas acontecem. Durante os anos 80 e 90 ninguém deu atenção à Objective-C. Estava fadado ao fracasso. Do nada, em 2007, surge o iPhone que - surpresa, precisa saber Objective-C. De repente ela se torna uma das linguagens de maior sucesso do fim da primeira década do Século XXI. De 10 em 10 anos o mercado se transforma de alguma forma. A ["Lei de Bell"](http://en.wikipedia.org/wiki/Bell's_law_of_computer_classes).

## Aceite: suas soluções hoje são Ruins

Continuando o tema do **"Ignore as Guerras Religiosas"**, como fazer para entender o que fazer? Atenha-se aos princípios. Jogue fora o que os gurus falam, não idolatre ninguém e nem siga cegamente o que alguém diz, desça às perguntas fundamentais e vai encontrar uma direção mais óbvia.

Quando você sabe como as coisas funcionam, retira o verniz, abre o capô, desmonta o motor, entende a química da combustão, só então vai conseguir dominar a arte. Se você, male-male, lembra pra que diabos serve trocar o óleo, vai ser sempre só um motorista medíocre, no melhor dos casos. Qual é seu objetivo? É ser engenheiro do carro? Porque se for, simplesmente ouvir gurus falando da cor do volante dificilmente vai te levar muito longe.

A Ciência da Computação é normalmente ignorada porque parece que aprender Matemática não só é chato como é inútil.

Vamos dar alguns exemplos. Se eu perguntar a um iniciante como procurar por palavras dentro de um texto, as coisas mais óbvias que devem vir à cabeça são:

* usar funções de substring e um loop para vasculhar o texto (solução brute-force)
* usar uma expressão regular ou num banco de dados usar um "LIKE" (solução genérica)
* instalar um SOLR ou Elasticsearch (solução correta em muitos casos, mas "magia negra" no entendimento)

A maioria nem pensaria na 3a solução. E se pensar não sabe porque. E se eu disser que - obviamente de forma absolutamente crú e resumida - a solução está em transformar um documento e os termos de pesquisa em vetores e calcular a relevância entre os termos de procura e os documentos por [similaridade de cosseno](http://en.wikipedia.org/wiki/Cosine_similarity)? Pois é exatamente isso que significa [Vector Space Model](http://en.wikipedia.org/wiki/Vector_space_model) (VSM) que você vai encontrar em diversas engines de procura.

<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; height: auto; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'>{{< youtube id="ZEkO8QSlynY" >}}</div>

O conhecimento que leva a isso se chama [**Álgebra Linear**](http://en.wikipedia.org/wiki/Linear_algebra). Lembra-se disso do PRIMEIRO ano de Ciência da Computação? Em particular sobre esse assunto recomendo assistir uma palestra que fiz sobre isso chamado ["Como não fazer pesquisas usando LIKE"](https://www.eventials.com/akitaonrails/como-nao-fazer-pesquisas-usando-like/).

E quando você precisa criar um processo para filtrar conteúdo? Para evitar conteúdo impróprio? A maioria das pessoas pensaria no seguinte:

* criar um blacklist de palavras e ir adicionando à medida que se lembra de palavras ofensivas. E usar a primeira ou segunda opção do que listei antes para buscar essas palavras.

Como você já deve imaginar, a resposta mais "óbvia" ou "simples" (considerando a falta de conhecimento), provavelmente é a errada, e nesse caso de fato essa não é a mais eficiente.

Conheça sobre machine learning e uma das formas mais simples disso chamada [Classificador Bayesiano Ingênuo](http://en.wikipedia.org/wiki/Naive_Bayes_classifier). Alguém pode pensar _"puts, mas isso de machine learning é avançado demais pro dia a dia."_ De maneira alguma. Aliás, qualquer filtro anti-spam vagabundo que  você encontra num site de downloads gratuitos usa um classificador.

A idéia é que simplesmente palavras simples não são suficiente para determinar se um conteúdo é impróprio ou não. A forma da construção de frases, o "tom" da forma de se escrever. Tudo isso forma um padrão que pode ser classificado e aprendido. Quanto mais conteúdo impróprio é classificado mais eficiente o algoritmo fica. Se quiser experimentar uma forma simples [em Ruby veja este blog](http://blog.logankoester.com/bayesian-classification-on-rails). Se quiser aprender sobre classificadores mais avançados, veja o projeto [Apache Mahout](https://mahout.apache.org/).

{{< youtube id="DdYSMwEWbd4" >}}

E o que é isso? É uma matéria de [**Estatística e Probabilidade**](https://www.khanacademy.org/math/probability). Os fundamentos para entender isso estão de novo no PRIMEIRO ano de Ciência da Computação.

_"Ah, mas você está falando coisas que ninguém precisa saber. Pra fazer sites web isso é desnecessário."_

Uma coisa que qualquer bom framework web precisa saber fazer com eficiência hoje em dia é mapear rotas com a programação por baixo (controllers). O Ruby on Rails tem um componente de rotas chamado [Journey](https://github.com/rails/journey), que configuramos via o arquivo "config/routes.rb". Abaixo temos um trecho disso:

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

Quão difícil isso pode ser? O que a maioria poderia imaginar?

* Fácil, basta fazer um conjunto de arrays ou um hash (dicionário) e quando chegar a URL basta quebrar os termos via uma regular expression e encontrar o controller passando os parâmetros pra executar.

Vamos nos repetir novamente? Sim, isso funciona, para aplicações bem pequenas. Qualquer coisa muito maior do que o exemplo acima já vai dar problemas de performance.

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

Em bom português, agora **fodeu**. Parte do Journey se utiliza do [Racc](https://github.com/tenderlove/racc) um gerador de parsers.

Se você passou pelo menos pro SEGUNDO ano de Ciências da Computação então passou pelas matérias de [**Algoritmos e Estruturas de Dados**](http://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs) e Montadores. E se chegou ao TERCEIRO ano deve ter aprendido sobre [**Compiladores**](http://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools) (e visto o famoso livro do Dragão). Racc deve ter te lembrado de Yacc, Flex, Bison.

{{< youtube id="QPCC2sbukeo" >}}

Para arrematar, você deve achar que sabe o que é [**Orientação a Objetos**](http://c2.com/cgi/wiki?NobodyAgreesOnWhatOoIs), certo? Certamente acha que sua linguagem favorita (seja Java, C# ou Javascript) são orientados a objetos. Se eu pedir para definir o que isso significa, está na ponta da sua língua:

* Minha linguagem suporta Encapsulamento, Herança e Polimorfismo, portanto é orientada a objetos.

E se eu lhe disser que linguagens procedurais, imperativas, funcionais também suportam encapsulamento, herança (seja via delegação ou não) e polimorfismo? E se é esse o caso então [o que define orientação a objetos?](http://c2.com/cgi/wiki?NobodyAgreesOnWhatOoIs)

Alguns que se entreteram no assunto talvez se lembrem de [Alan Kay](http://en.wikipedia.org/wiki/Alan_Kay), que cunhou o termo "orientação a objetos". Mas quantos pararam para pesquisar a linguagem Simula 67? O que o Simula introduziu em 1967? Objetos, classes, herança, subclasses, métodos virtuais, [corotinas](http://en.wikipedia.org/wiki/Coroutine), simulação de eventos discretos, garbage collection.

E quantos já ouviram falar dos criadores do Simula 67, [Kristen Nygaard](http://en.wikipedia.org/wiki/Kristen_Nygaard) e [Ole-Johan Dahl](http://en.wikipedia.org/wiki/Ole-Johan_Dahl)?

Não sabem quem são? Tenho certeza que não. Bem, eis que lhes apresento os pais da orientação a objetos.

## Sobre os Ombros de Gigantes

O que mencionei na seção anterior não é nem a ponta do iceberg, é uma gota d'água nessa ponta. O importante é você ganhar consciência de que tudo que você acha que sabe é perto de nada. Quero que você aceite que tudo que você acha que sabe ou está errado ou é totalmente incompleto.

Isso é importante porque qualquer um que ache que já sabe tudo ou perto disso nunca vai aprender nada. Você precisa esvaziar o copo para poder enchê-lo. (by Bruce Lee)

![Bruce Lee Quote](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/406/big_quote-emptiness-the-starting-point-in-order-to-taste-my-cup-of-water-you-must-first-empty-your-cup-bruce-lee-246247.jpg)

Além disso quero que você entenda que você não está sozinho. Antes de você vieram dezenas de grandes mentes. E não estou falando desses gurus superficiais ensinando meramente técnicas e ferramentas. Esqueça-os, todo mundo vai esquecê-los em breve também.

Todo mundo sabe quem é Linus Torvalds, Bill Gates, Steve Jobs, Zuckerberg. Esqueça-os por enquanto. Atenha-se aos imortais. Nomes que realmente fizeram a diferença na história da Ciência da Computação. Alguns exemplos:

* [Charles Babbage](http://en.wikipedia.org/wiki/Charles_Babbage)
* [Ada Lovelace](http://en.wikipedia.org/wiki/Ada_Lovelace)
* [George Boole](http://en.wikipedia.org/wiki/George_Boole)
* [Alan Turing](http://en.wikipedia.org/wiki/Alan_Turing)
* [Alonzo Church](http://en.wikipedia.org/wiki/Alonzo_Church)
* [John von Neumann](http://en.wikipedia.org/wiki/John_von_Neumann)
* [John McCarthy](http://bit.ly/1rN6Kwe)
* [Niklaus Wirth](http://en.wikipedia.org/wiki/Niklaus_Wirth)
* [Bertrand Meyer](http://en.wikipedia.org/wiki/Bertrand_Meyer)
* [Dan Ingals](http://en.wikipedia.org/wiki/Dan_Ingalls)
* [Donald Knuth](http://en.wikipedia.org/wiki/Donald_Knuth)
* [Edsger W. Dijkstra](http://en.wikipedia.org/wiki/Edsger_Dijkstra)

E isso apenas para listar alguns poucos. Ciência é um campo amplo, onde o trabalho de um cientista complementa o trabalho do anterior. Passo a passo andando sempre para frente. É um trabalho acumulativo de dezenas, centenas de anos. Nossa vantagem? Centenas de pessoas já trilharam esse caminho no passado e podemos nos utilizar do que eles aprenderam e deixaram para nós, em vez de nós mesmos cometermos os mesmos erros até aprendermos.

{{< youtube id="6dME3wgaQpM" >}}

Quase tudo que você vê por aí que se chama ["inovação"](http://startups.ig.com.br/2013/restricoes-sao-libertadoras-menos-e-mais/) não é mais do que a redescoberta de coisas que já estão documentadas no passado mas estavam à frente do seu tempo. Foi assim com o mouse: [Douglas Engelbart](http://en.wikipedia.org/wiki/Douglas_Engelbart), que criou o mouse em 1968 precisou esperar até Steve Jobs lançar o Macintosh, 16 anos depois, para ver sua invenção ser popularizada. Pare para pensar: quantas descobertas estão no passado apenas esperando para que nós a desenterremos para finalmente realizá-las?

Quer saber sobre os livros imortais da Ciência da Computação? Vamos a alguns:

* [Structure and Interpretation of Computer Programs (SICP)](http://en.wikipedia.org/wiki/Structure_and_Interpretation_of_Computer_Programs)
* [The C Programming Language (K&R)](http://en.wikipedia.org/wiki/The_C_Programming_Language)
* [Algorithms + Data Structures = Programs](http://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs)
* [Compilers: Principles, Techniques and Tools](http://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools) - o livro do Dragão
* [Modern Operating Systems](http://en.wikipedia.org/wiki/Modern_Operating_Systems)
* [Computer Networks](http://en.wikipedia.org/wiki/Computer_network)
* [The Art of Computer Programming](http://en.wikipedia.org/wiki/The_Art_of_Computer_Programming) - nem eu li esses livros, e desconheço quem tenha lido e entendido mas vou deixar aqui pela importância.

[Não quer fazer uma faculdade?](http://www.akitaonrails.com/2009/04/17/off-topic-devo-fazer-faculdade) Não tem problema, tente acompanhar o material disponível online do MIT de [Electrical Engineering and Computer Science](http://ocw.mit.edu/courses/#electrical-engineering-and-computer-science). Se você ainda é completamente amador mesmo no mundo da programação veja este curso introdutório à Ciência da Computação no [Coursera](https://www.coursera.org/course/cs101).

Note que não estou citando neste artigo nenhum dos nomes que muitos poderiam esperar como Martin Fowler, Bruce Eckel, Robert Martin, Michael Feathers, Kent Beck, Steve McConnel, Tom DeMarco, Dave Thomas, etc. Esqueça-os. Se não ver os anteriores, estes farão pouca diferença.

Não coloque o carro na frente dos bois, vá um passo de cada vez.

## Carreira em Programação

Uma coisa que eu sempre repito é o seguinte:

<blockquote>"Programar não é escrever qualquer código da mesma forma que culinária não é jogar qualquer ingrediente numa panela."</blockquote>

Entenda: é muito simples escrever código, qualquer um que tenha o mínimo de coordenação motora pra não tentar passar uma peça quadrada num buraco circular, ou que minimamente já tenha empilhado uma peça de lego em cima da outra, tem condições de escrever código. Não há absolutamente nenhum mérito nisso.

Baixar um Twitter Bootstrap, usar um gerador do Yeoman, instalar um MySQL no Ubuntu, copiar e colar um trecho de JQuery, qualquer um consegue fazer.

Quando se fala em carreira, o que "qualquer um" consegue fazer significa que é um mero ["commodity"](http://en.wikipedia.org/wiki/Commodity). Ser um commodity significa que o valor que o mercado está disposto a pagar só vai decair, não vai subir. Temporariamente surge alguma novidade para tentar criar uma diferenciação (_"veja, Angular JS"_, _"veja, HTML 5"_), mas elas rapidamente se dissolvem na tendência de queda do valor.

O valor não está na montagem. Está na criatividade da solução: conseguir extrair o maior valor pelo menor custo. E criatividade só existe quando você tem domínio sobre todos os elementos ao seu redor. Quando 1 hora para trocar um algoritmo idiota de procura de palavras por um vector space model reduz seu parque de máquinas de 10 para 2, e responde ao seu usuário em 1/5 do tempo. Aí não é força bruta, é de fato conhecimento. E isso tem valor e cresce.

Ter uma caixa de ferramentas cheia só o torna um "faz-tudo com muitas ferramentas", não o torna um engenheiro/arquiteto capaz de construir o próximo World Trade Center/Freedom Tower.

Mas, como todo mundo que quer evoluir, todos começamos como faz-tudo. Não há nada de errado nisso, apenas não se iluda achando que ter uma caixa de ferramentas com mais ferramentas o torna qualquer coisa diferente disso.
