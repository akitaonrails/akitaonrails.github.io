---
title: "[Akitando] #16 - Sua Linguagem NÃO É Especial! (Parte 2)"
date: '2018-10-04T17:00:00-03:00'
slug: akitando-16-sua-linguagem-nao-e-especial-parte-2
tags:
- grace hopper
- cobol
- barbara liskov
- occam
- haskell
- elixir
- erlang
- golang
- python
- scipy
- programação
- computação
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


<iframe width="560" height="315" src="https://www.youtube.com/embed/XcTTajFENHI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


### Descrição no YouTube

Depois da semana geek, vamos "geekar" um pouco na programação também.

Honestamente essa polarização em torno de linguagens de programação é super cansativa. A turma do funcional vs a turma dos objetos. A turma do javascript, a turma do Go. 

Enquanto isso, a grande maioria da população de programadores está aflita, sem saber pra onde correr. Quantas linguagens preciso aprender? 2? 6? 50???

Calma! Vamos começar a colocar ordem nessa bagunça. Hoje vou explicar como fazer isso e porque sua linguagem de programação favorita não é tão especial quanto você pensa!

Não deixe de assistir a Parte 1 antes!

* Genealogia (https://github.com/akitaonrails/computer_languages_genealogy_graphs)

## Script

Olá pessoal, Fabio Akita

Vamos continuar a história que iniciei no episódio anterior. Se você Não assistiu clique no link acima e veja a parte 1, vamos lá, eu espero. 

Já viu? Então vamos continuar nossa história das linguagens.

(..)

No episódio anterior falamos da linhagem de linguagens derivadas de ALGOL, que eu chamaria da linguagem A, mas existiu outra A.

Já que falamos em Fortran e linguagem B, existiu uma outra vertente que quis perseguir sintaxes diferentes de notação matemática para se adequar mais a processamento de dados de negócios. O time da famosa Grace Hopper foi um dos que perseguiu esse objetivo entre 1958 e 1959. Vocês devem estar se lembrando: Ahá sim, daí ela inventou o COBOL. BEEE Nope, ela inventou outra linguagem ANTES do COBOL que viria a ser a primeira linguagem focada em se expressar mais próximo do inglês, esse foi FLOW-MATIC também conhecido como B-0 ou Business Language versão 0. Achou B-0 um nome estranho? É porque antes disso Grace Hopper fez extensões pra uma linguagem chamada ARITH-MATIC ou A-2. e antes do A-2 tinha o A-1 e, claro o A-0 também escrito por Hopper, isso lá pra 1951. Então a linhagem completa começa em A-0, A-2, A-3 que são ARITH-MATIC, AT-3 que é MATH-MATIC e B-0 que é FLOW-MATIC antes do COBOL. Todas as anteriores que falei antes são de Hopper, o COBOL não é, ele é inspirado nos trabalhos anteriores de Hopper. Todo mundo decorou COBOL e Hopper mas ninguém nunca ouviu falar dessa história. Não só decorem, busquem as fontes!

Já que mencionei Java e C# muita gente acredita que Java que inventou orientação a objetos, garbage collector, tipagem forte. Bom, vocês já viram que no fim dos anos 50 você já tinha ALGOL, Pascal que tinham tipagem forte. Alguns de vocês talvez tenham ouvido falar da linguagem Simula de 1967 criada por Ole-Johan Dahl e Krysten Nygaard, também chamado de Simulation Language que foi quem introduziu os conceitos de objetos, classes, herança, sub classes, co-rotinas e também o garbage collector. Mas não foi o primeiro, garbage collector. Linguagens como Basic já tinham um tipo primitivo de garbage collector. Mas essa é a parte fácil. Quantos de vocês já ouviram falar numa linguagem chamada CLU?

E eu disse CLU, CE ELE U, só pra garantir. Essa linguagem foi criada no MIT em 1974 por ninguém menos que Barbara Liskov e seus alunos. Quem? Bom, se você é de Java ou C# ou já estudou Uncle Bob conhece o princípio SOLID de orientação a objetos. S de Single Responsability Principle, O de Open/Closed Principle e L de Liskov Substitution Principle. Aí você que nunca parou pra pensar, o que diabos é Liskov? Prazer, Barbara Liskov criadora da linguagem CLU que fez adições no paradigma de programação orientada a objetos como tipos de dados abstratos, iteradores, retorno de múltiplos valores ou parallel assignment, classes com construtores. CLU, pra variar, tem sintaxe derivada de quem? Yep, ALGOL. E se chama CLU porque ele lida com Clusters que é mais ou menos uma Classe hoje.

Falando em funcionalidades, que tal falar sobre regular expressions. Todo mundo conhece hoje em dia né? Toda linguagem que se preza tem uma biblioteca boa de regex, normalmente baseada no padrão do Perl 5. Mas de onde diabos vem aquela maldita sintaxe de regex? Volte pra 1962 e vai encontrar o String Oriented and Symbolic Language ou SNOBOL, uma série de linguagens da Bell Labs - de novo - que culmina no SNOBOL 4, uma linguagem voltada a string de texto e que se diferencia das outras linguagens por ter patterns como first-class citizens. Resumindo a história era uma linguagem muito usada pra manipular texto mas foi caindo em desuso à medida que nos anos 80 e 90 surgiram AWK e o próprio Perl. Mas os patterns de SNOBOL ainda são mais poderosos do que regex hoje, meio como HTML é um sub-caso de SGML ou XML. Lembra do Backus-Nauer Form ou BNF que dá origem à definição de gramática de compiladores? O SNOBOL são quase isso pra patterns. Guarde SNOBOL e vamos pular pra outra linguagem

Nos anos 70 surgiu outra linguagem, agora uma funcional chamada Hope na universidade de edinburgh. Ela é anterior à Miranda ou Haskell e é contemporânea do da família ML de linguagens funcionais, sendo derivada do NPL de 77. E Hope e NPL são notáveis por serem as primeiras linguagens a terem o conceito de call-by-pattern. Guarde essa informação.

Em 1972 você tem a linguagem PROLOG que é um animal muito exótico, finalmente alguma coisa não derivada de ALGOL. Ela tem um paradigma que não é funcional, não é objeto, não é imperativo. É programação lógica, uma linguagem declarativa. Você começa definindo fatos e regras. Tudo é expresso em termos de relações ou relations hoje em dia pense em algo como um SQL. e a computação são queries nas relations. Na teoria de Codd sobre SQL ele se baseia em cálculo relacional - você estudou isso na faculdade né? E o que eu falei de fatos em prolog são dados. Uma relation em teoria relacional é a mesma coisa que uma tabela em SQL ou função relacional em lógica predicativa e a mesma coisa que um tuple-set em teoria dos conjutnso. E uma view de SQL é equivalente a uma regra de prolog.

Mais do que isso, prolog também é uma linguagem, como Hope e NPL baseada em pattern-matching. Mais especificamente, você podia implementar o pattern matching de Snobol em Prolog. Aliás, como Prolog não tem sintaxe derivada de Algol ela é bem feia aos nossos olhos acostumados à linguagem de Algol como Java ou C# ou Python. Tem uma outra linguagem que herda partes dessa sintaxe feia de Prolog, com um sistema de pattern-matching como Snobol e call-by-pattern como Hope. 

Muito prazer, seu nome é Erlang, lançado em 1986 por Joe Armstrong. Graças aos céus o José Valim inventou a linguagem Elixir que compila no mesmo bytecode de Erlang. Vocês devem conhecer Elixir e Erlang primeiro como uma linguagem funcional e segundo como uma linguagem de alta concorrência.

Vamos lá, primeiro ela não é uma linguagem puramente funcional. Aliás, Javascript também não é puramente funcional. Elas tem funções, ponto. Funcional são outras linguagens. Alguns de vocês que leram muitos blogs vão correr pra dizer “sim, como Haskell”. Vou mais pra trás, quando falei de Hope eu falei de Miranda que veio depois, que é uma linguagem lazy, puramente funcional, que não tem efeitos colaterais, e é escrita como uma série de equações que define várias funções matemáticas e tipos de dados algebraicos. De curiosidade, o parsing da linguagem faz uso de identação de forma a não precisar de chaves pra delimitar statements. Essa funcionalidade foi inspirada por … aha Python! Você poderia dizer. Não, Python é um bebê, antes dele tivemos pelo menos ISWIM e OCCAM.

ISWIM?  Sim, de 1966, inspirado por … bingo, ALGOL. Na verdade ALGOL 60 e Lisp. ISWIM significa If you See What I Mean ou também I see what you mean, mas isso seria I S W Y M mas ai foi escrito errado como I S W I M ou ISWIM. Ela é mais uma descrição de uma linguagem e não foi implementada, mas ela suas idéias inspiraram a linguagem Hope, depois Miranda, daí Haskell e Clean. Clean que tem uma relação de ser inspirado por Haskell e inspirar Haskell sendo meio um concorrente e ter uma funcionalidade em particular que compete com os monads de Haslell, no caso de Clean ele lida com estado mutável e I/O através de um uniqueness typing system.

Mas além de ISWIM ter código identado que veio a inspirar Python, a outra linguagem desse jeito é OCCAM. E ela também se relaciona com Erlang porque antes de Erlang foi desenhada como uma linguagem focada em concorrência e implementa um troço chamado Communicating Sequential Processes ou CSP. Basicamente a comunicação entre processos através de channels ou canais. O CSP de Occam foi reciclado para um aspecto mais funcional no Erlang através de passagem de mensagens entre processos. E você deve ter ouvido falar de outra linguagem que ficou famoso na atualidade por redescobrir CSP, sim a linguagem Go e suas go-rotinas. Todo mundo que fala de CSP menciona Tony Hoare mas eu nunca vi ninguém lembrar que Hoare inventou OCCAM e foi onde ele implementou CSP primeiro.

E já que mencionei a família ML de linguagens funcionais vale lembrar de uma coisa que surgiu primeiro nessa família lá no começo dos anos 70. Um troço chamado Hindley-Milner type system, um sistema de tipos clássicos de lambda calculus com polimorfismo paramétrico. Você viu isso na faculdade né? E porque isso é interessante?  O que as linguagens Clean, Crystal, D, F#, Go, Haskell, Java a partir da versão 10, Julia, Kotlin, OCaml, Rust, Scala, Swift e Visual Basic tem em comum? Eles tem tipagem forte mas diferente do Java antigo onde você precisava declarar todos os tipos de todas as variáveis explicitamente hoje em dia você não precisa né? E nem por isso a linguagem tem tipagem dinâmica como Python ou Ruby, ela tem tipagem forte através de Inferência de Tipo. Outro nome para inferência de tipo? Hindley-Milner type system. Muito prazer, linguagens ML.

E pra terminar, se você é de Javascript tem mais um aspecto dessa linguagem que não é novo. Que tal JSON ou Javascript Object Notation? Nosso querido Douglas Crockford foi olhar nas páginas da história de outra linguagem, o Relative Expression Based Object Language ou REBOL que é contemporâneo de 1997 desenhado por Carl Sassenrath primariamente feito pro AmigaOS e que usa conceitos de programação de Lisp, Forth, Logo e Self. Antes de Ruby tornar popular o conceito de DSLs ou Domain Specific Languages, é REBOL que foi desenhado especificamente pra DSLs, particularmente pra toolkits gráficos de Amiga.

Você acha que existem quantos paradigmas de programação? Muita gente fica se gabando achando que sabe muito discutindo porque o paradigma funcional é superior ao paradigma de objetos que se acha superior ao paradigma imperativo ou procedural. Meh, vá ver a história da linguagem APL e outras do paradigma de array programming e vai encontrar linguagens boas pra calcular vetores como Mathematica ou o moderno Julia. Se você prestou atenção na minha história já sabe que Prolog é paradigma lógico e declarativo. O mundo é sempre muito maior do que você pensa. Muito maior do que seu Javascript.

Mais ainda, na sua cabeça você acha que Java é velho? Agora que ele tem pouco mais de 20 anos? Fortran é de 1957 e tem versões novas sendo usadas até hoje. Cobol tem versão até hoje e é de 1959 ele inclusive ganhou novas funcionalidades como orientação a objetos. E você acha que elas não são usadas mais? Sabe um dos exemplos que todo mundo adora usar pra falar de Python, a biblioteca de ferramentas matemáticas ScyPy? Sabe porque diabos ela é tão rápida? E se eu te disser que mais de 20% do código fonte de Scypy é C outros 30% do código fonte é FORTRAN! 45% é uma casca de Python pra falar com todo esse C e Fortran. E é uma excelente escolha, porque Python sozinho nunca iria ter tanta performance pra cálculo numérico como Fortran.

Estão entendendo? Saiam do casulo. Pensem fora da caixa. Sua linguagem não foi desenhada por um ser onipresente e onipotente que um belo dia acordou e disse “que se faça Javascript” ou “que se faça Python”. Se você é programador de C# e fica zombando de Delphi, que tal saber que elas vieram do mesmo autor e derivam das mesmas linguagens? Você acha que porque usa Go ou Elixir de repente só recentemente surgiu programação concorrente com processos e channels de CSP? Nunca foram procurar Tony Hoare e linguagens como Occam? Pattern matching, pfff, SNOBOL. 

O que eu falei nesses 2 episódios é apenas uma dimensão da história da programação. Em outors episódios vou mostrar como você junta esta dimensão com outras dimensões pra começar a entender as fundações não só de onde vieram suas linguagens favoritas mas o que elas poderão ser no futuro.

O que acharam dessa série em 2 partes? Não deixe de colocar nos comentários o que acharam. Se gostaram mandem um joinha. Assinem o canal e não deixem de clicar no sininho pra não perder os próximos episódios. A gente se vê, até mais!
