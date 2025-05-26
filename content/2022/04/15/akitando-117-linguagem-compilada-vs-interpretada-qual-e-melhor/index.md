---
title: "[Akitando] #117 - Linguagem Compilada vs Interpretada | Qual é melhor?"
date: '2022-04-15T17:34:00-03:00'
slug: akitando-117-linguagem-compilada-vs-interpretada-qual-e-melhor
tags:
- compilador
- interpretador
- máquina virtual
- llvm
- gcc
- java
- javascript
- v8
- lexer
- parser
- chomski
- backus
- naur
- bnf
- algol
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/SNyh-cubxaU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Chegou a hora de finalmente entender qual a diferença de linguagens compiladas e interpretadas, linguagens estáticas e dinâmicas. Java é compilado? Javascript é interpretado? Qual a diferença?

Hoje você vai ganhar uma fundação mais sólida pra entender linguagens da maneira correta e é o pré-requisito pros próximos videos onde finalmente vou discutir as linguagens mais famosas da atualidade.

== Conteúdo

* 00:00:00 - Intro
* 00:00:55 - Pré-Requisitos
* 00:01:53 - Hello World em C e Java
* 00:03:03 - ELF vs CAFE
* 00:03:41 - 1a tentativa: compilador vs interpretador
* 00:04:45 - Estudo de Linguagens
* 00:07:37 - Análise Léxica
* 00:10:59 - Análise Sintática
* 00:14:39 - Abstract Syntax Tree (AST)
* 00:15:48 - Notação Polonesa
* 00:17:58 - Otimização de Bytecode
* 00:22:55 - Pra que serve um Programador?
* 00:27:04 - Linters
* 00:28:00 - Backus, Naur, BNF e História
* 00:31:57 - Parsers e "DOM"
* 00:32:58 - Interpretadores e Máquinas Virtuais
* 00:36:56 - Linguagens Dinâmicas
* 00:38:58 - Otimização Binária
* 00:42:52 - As Fases de um Compilador
* 00:46:23 - Just-In-Time Compiler (JIT)
* 00:50:33 - Linkers
* 00:59:24 - JIT de novo
* 01:02:30 - Google V8
* 01:05:25 - Por que dinâmico em vez de estático?
* 01:07:42 - 2a tentativa: compilador vs interpretador?
* 01:10:45 - Bônus: Bloopers (novidade)

== Links

* ANSI C Grammar (https://www.lysator.liu.se/c/ANSI-C-grammar-y.html#compound-statement)
* EcmaScript 2023 (https://tc39.es/ecma262/#sec-ecmascript-language-statements-and-declarations)
* List of Java bytecode instructions (https://en.wikipedia.org/wiki/List_of_Java_bytecode_instructions)
* Why the New V8 is so Damn Fast (https://nodesource.com/blog/why-the-new-v8-is-so-damn-fast/)
* V8 Bytecode.h (https://github.com/v8/v8/blob/master/src/interpreter/bytecodes.h)
* LLVM Analysis and Transform Passes (https://llvm.org/docs/Passes.html)
* HHVM (https://hhvm.com/)

## SCRIPT

Olá pessoal, Fabio Akita


Todo bom iniciante que se preza mais cedo ou mais tarde vai se engajar numa discussão sobre porque sua linguagem favorita é melhor que dos outros. E invariavelmente um dos argumentos que vai aparecer é que ser compilado é melhor, é mais performático, ou que ser interpretado é melhor porque é mais produtivo. E certamente todos que estão participando dessa discussão estão errados de maneiras que vocês nem imaginam.







Hoje quero falar um pouco sobre o que significa uma linguagem ser compilada ou interpretada e porque a maioria dos programadores interpreta isso errado (no pun intended). O objetivo não de hoje não é dizer qual é melhor, e sim porque sua linha de raciocínio não leva em conta diversos outros fatores que são mais importantes. No final do video você vai enxergar todas as suas linguagens de uma forma diferente.




(...)





Pra todo mundo que tá estudando ou já se formou em ciências da computação: não, eu não vou falar do livro do dragão de compiladores. Também não vou falar do livro de sistemas operacionais do Tanenbaum. Porém todo mundo que estudou essas duas matérias vai ter um aproveitamento melhor desse video. Aproveitem pra discutir os detalhes técnicos com seus colegas ou fazer mais perguntas pros seus professores na faculdade e nos cursos.







Compiladores e sistemas operacionais são conteúdos pra pelo menos um ano ou mais no curso de ciências da computação. Partes desses assuntos eu já expliquei em videos como o guia mais hardcore de introdução à computação e hello world como você nunca viu antes, e todos os outros na playlist de "Como Seu Computador Funciona". Mas pra ter uma idéia, na faculdade, um dos trabalhos é fazer seu próprio compilador. Se nunca fez, depois do video fica de desafio tentar fazer o seu próprio. E pra isso já dou spoiler pra pesquisar tutoriais sobre a ferramenta ANTLR. Mas não vou falar especificamente de ANTLR hoje também.







Vamos começar do começo. Isso aqui é um Hello World em C. Agora, isso aqui é um terminal de Linux no WSL2 do meu PC e compilamos esse arquivo texto com o código em C num binário ELF compatível com Linux usando o compilador "cc", que significa "Compiler Collection". E pronto, isso é tudo que a maioria tem na cabeça quando se pensa em transformar código texto em um executável e no video sobre arquivos texto e binários eu explico como realmente as coisas funcionam e como um executável funciona. Mas vamos pra outro exemplo.








Agora, isso aqui é um Hello World em Java. Novamente vamos pro Terminal e é assim que se aprende na faculdade, roda `javac Hello.java` e ele vai gerar um `Hello.class`. E pra rodar é só fazer `java Hello` e voilá. Muita gente costuma dizer que Java é uma linguagem "compilada", entre aspas. Só que olha o que estamos fazendo: chamando o executável "java" antes e dando como parâmetro a classe "Hello" que acabamos de compilar. Se fosse realmente compilado, no sentido clássico, deveria dar pra só fazer `./Hello.class`, mas isso não funciona, o sistema operacional não tem nenhuma idéia de como executar isso, porque um binário `.class` não é um executável em formato ELF.









Como tinha explicado no video de arquivos, pro Linux saber que um binário pode ser executado, ele precisa estar num formato chamado ELF, que significa Executable and Linkable Format. Em particular, todo binário ELF começa com a sequência que em hexadecimal seria 7f 45 4c 46, que propositalmente é ASCII pra string "ELF". Isso é totalmente arbitrário e quem inventou o ELF só definiu que é assim e pronto. Mas se abrirmos os primeiros bits da classe Hello de Java, o que vemos nos primeiros bytes é a sequência hexadecimal `cafe babe`. Obviamente uma piada de café e java que o James Gosling escolheu pra serem os primeiros bytes de todas as classes Java.









Se definirmos que compilar é o processo de pegar um código fonte texto, por exemplo em C, passar por uma ferramenta como o "cc", que vai cuspir um binário que o sistema operacional vai conseguir executar diretamente, então não, o Java não é compilado. Por outro lado vamos definir um interpretador. Um interpretador é um programa que vai pegar ou o arquivo texto do código ou uma representação intermediária, como esse ".class" e vai traduzir pro binário de máquina que, aí sim, o sistema operacional e o processador vão entender. Portanto, por essa definição, Java é uma linguagem interpretada.









Isso é o que você vai encontrar na bolhadev, e na verdade o que acabei de falar não tá nem totalmente certo, nem totalmente errado. Tanto C quanto Java são linguagens compiladas. E antes de explicar qual a diferença, preciso começar explicando o que é o processo de compilação. Esse processo tem diversos passos mas minha intenção não é escovar bits hoje, mas sim fazer com que vocês tenham um modelo mental fácil na cabeça pra não cairem em pegadinhas de discussão online e conseguir entender as principais diferenças.









O estudo de linguagens de programação é meio que um sub-conjunto do estudo de linguagens em geral, tipo português ou inglês. Em ciência da computação, na teoria formal de linguagens, as linguagens de programação como C ou Java ou Python são o que chamamos de linguagens regulares. Por sua vez, uma linguagem regular é uma linguagem formal que pode ser definida por expressões regulares, sabe o regex que você usa todo dia pra validar formato de emails ou cpfs? E por sua vez uma expressão regular pode ser definida como uma linguagem que pode ser reconhecida por um autômato finito. Älguns de vocês já devem ter esbarrado no termo "máquinas de estado finito", que é outro nome que se dá a autômatos de estado finito.








Mas relaxa, nem eu sei tudo em todos os detalhes e não vou descer na matemática por trás de autômatos não, mas é pra saber que existe esse campo de estudo. Na prática, pense assim. Temos um texto em português. O que é um texto? É uma coleção de parágrafos. E o que são parágrafos? É uma coleção de frases. E o que é uma frase? É uma coleção de palavras. Palavras são coleções de letras separadas por espaço ou outras pontuações, como vírgula ou ponto.








Então, se eu juntar quaisquer letras, vou ter palavras? Se eu juntar quaisquer palavras, vou ter frases? Não. Existe uma ordem que funciona. Conjuntos de letras só formam palavras se elas existem num dicionário, que é uma coleção arbitrárias de conjuntos de letras, que a gente definiu. Se eu juntar as letras "h", "e", "l", "l", "o", um atrás do outro, no dicionário em inglês, isso define uma saudação e uma forma de iniciar uma comunicação por telefone, por exemplo. Tire um "l" dessa palavra e já não significa a mesma coisa.








Pra formar frases, não pode sair juntando quaisquer palavras. Elas precisam obedecer uma gramática. Sujeito, predicado, adjetivos, pronomes, tempos verbais e tudo mais que fazem uma frase ter sentido. Se eu disser a frase "não vai ter jeito", significa que não tem mais conserto, fodeu já. Mas se na verdade faltou uma vírgula nessa frase depois do não, então seria "não, vai ter jeito", que é exatamente o significado oposto. Uma única vírgula faz diferença. Quem já programou e teve bug porque esqueceu uma vírgula, em português, também tem bug se esquecer uma pontuação.








Voltando pro código C. Pro computador, um texto, é só um linguição de bytes, um linguição de caracteres. Tem letras, tem espaços, tem chaves, mas não quer dizer nada. Mesmo pra você, ser humano assistindo, se nunca programou, esse texto também não quer dizer bulhufas. Eu preciso dar um jeito de fazer o computador juntar letras que formam palavras, que no caso chamamos de "tokens", que fazem sentido. "int" é um conjunto de letras que faz sentido. "printf" é outro conjunto de letras que faz sentido. Então preciso conseguir quebrar esse texto todo em uma lista de tokens. Pra isso vou "tokenizer", ou "lexar", e isso é o trabalho de uma ferramenta que faz análise léxica.








Na realidade precisamos definir os lexemes da linguagem, o equivalente de dicionário. Podemos definir que dígitos são todos os caracteres de zero até 9. E definimos como não-dígitos, todas os caracteres de "a" até "z", em mínusculo e maiúsculo. Também definimos que pontuação são todos estes outros caracteres como parênteses, colchetes, vírgula, ponto e tudo mais. Alguns desses caracteres podem repetir em outra definição. Parênteses podem ser operadores, assim como sinal de mais, de menos, asterisco. E assim por diante. Agora um analisador léxico como um chamado `flex` pode pegar meu código em C e entender que tem sinais, strings, digitos, operadores e traduzir isso numa lista de tokens.








Uma vez tendo essa lista de tokens, precisamos saber o que significam. Eu preciso que o computador entenda que, o que vai entre parênteses depois do token "printf", é um argumento. Eu preciso que ele entenda que o "return 0" na última linha entre chaves se refere ao tipo "int" declarado no começo da função "main". Elas precisam estar seguindo alguma regra. Uma vez tendo uma lista de tokens, precisamos checar contra uma gramática.







Antes de ficar teórico demais, deixa eu mostrar um exemplo prático. Pra isso fiz a linguagem de programação mais idiota do mundo. Ela não é turing complete, só aceita uma expressão no formato `1 add 2` pra somar, ou `4 sub 3` pra substrair. Só isso. Olha só, escrevi um programa nessa linguagem e salvei como "hello.stupid", por que não? Pra rodar esse programa, fiz um interpretador em Javascript chamado "js stupid". Vamos abrir pra ver o que faz.







As primeiras linhas é o jeito mais porco de pegar um argumento da linha de comando. Vou executar fazendo "./stupid.js hello.stupid", igual o Java faz com "java Hello" antes, lembra. Pra isso botei um shebang na primeira linha que vai executar o Node automaticamente e carregar o resto do script nele. Depois pego o primeiro argumento e uso a biblioteca `path` pra formar o caminho absoluto até esse arquivo.







Daí uso a biblioteca "fs", de filesystem, pra ler o arquivo. Se eu passar um arquivo que não existe vai dar um erro e sair. Senão eu pego o conteúdo do arquivo, limpo coisas no final como o caracter de nova linha, caso tenha, sabe o "\n"? E aí simulo o que seria o trabalho do tal analisador léxico, que vai tokenizar o conteúdo do arquivo.







Meu lexer é tão simples que é só um split de string de javascript. Ele quebra onde tem espaço e joga os tokens nesse array que chamei de "tokens". Nesse ponto, converti o texto do arquivo numa lista e ainda converti o primeiro e o último token pra serem números.







Essa minha linguagem é tão besta que não precisa de um analisador sintático. Eu só faço um switch case e vejo o 2o token da lista. Se for "add" eu faço uma soma, se for "sub" eu faço uma subtração. E é isso aí. Eu posso adicionar quantas operações quiser seguindo esse formato. E no final, se colocar um operador que não tá declarado, vai dar erro de sintaxe e sair.







Se tiver um pouquinho de imaginação vai conseguir criar linguagens bem simplinhas usando só esse esquema. Mas dando spoilers já adianto onde que vai dar nó na cabeça. E se eu quisesse suportar uma expressão com mais de 2 números? Tipo fazer 1 + 2 + 3, como você faria? E se eu quisesse adicionar multiplicação e quiser que 1 + 2 * 3 dê a resposta correta? Note que multiplicação tem precedência, então 2 * 3 tem que vir antes de somar por 1. E dá pra ir complicando. E se eu quiser suportar variáveis? E se eu quiser suportar funções? 







Obviamente isso é um problema já resolvido. E o primeiro conceito é separar a análise de sintaxe da execução propriamente dita, que é o que costumamos chamar de "tempo de compilação" e "tempo de execução". Recapitulando, a análise léxica só dividiu o texto em tokens, e agora análise sintática vai dar significado pra esses tokens. Pra isso vai precisar de uma gramática que define o que são expressões, o que são funções, o que são condicionais. Por exemplo, podemos ver a gramática da linguagem C. 








As ferramentas tradicionais que aprendemos na faculdade são lex ou flex, pra definir a análise léxica, e o bison ou yacc pra definir a gramática. Se procurar no GitHub é fácil de achar a gramática de todas as linguagens. A gramática do C em yacc é bem curtinha. Você imagina que definir uma linguagem deve ser milhares de linhas, mas na realidade não é mais que meia dúzia de page down, algumas centenas de linhas. Isso não é o compilador todo, só o parser, claro.








Se olharmos lá no fim da gramática, eis a definição do que é uma função de C, literalmente ele nomeia como "function definition". E pode ser construído de 4 formas diferentes. A 1a são especificadores de declaração, seguido de declarador, seguido de lista de declaração e terminando com composição de statements. Em português não sei como chamam "statements", alguns chamam de expressão, mas a definição de expression e statement são diferentes. Eu acostumei a chamar de statement então vai assim mesmo.









Mas o que tudo isso quer dizer? Esses nomes são como etiquetas, a definição de cada uma tá mais pra cima. Por exemplo, vamos ver o que "compound statement" quer dizer. Olha só, pode ser também 4 coisas: um bloco entre chaves vazias, ou uma lista de statements entre chaves, ou uma lista de declarações entre chaves e por último pode ser uma lista de declarações seguida de uma lista de statements, mas o principal é que estamos olhando pra declaração oficial, completa e não-ambígua do que o C chama de "função". Não há espaço pra discussão, esta é gramática que define o C.








Agora o que é um statement list? Aqui vemos a definição e ela pode ser um statement ou vários statements, isso é meio que uma definição recursiva, por ser ela mesma várias vezes. Mas isso só define que pode ter um ou mais statements, agora precisamos ver o que é um statement. E agora sim, um statement pode ser de diversos tipos como labeled statement, compound statement que vimos antes, mas o interessante vai ser esse iteration statement.








E olha só, é isso que C chama de statements de iteração. Pode ser um while, pode ser um do while, pode ser for. E o for pode ser de dois jeitos diferentes, com ou sem uma expressão no final. E assim por diante. Se você tiver paciência pra ler a definição léxica e a gramática de yacc, tecnicamente é toda a sintaxe e semântica do C definida em 2 arquivos razoavelmente curtos, dá pra decorar e saber de cabeça. Claro, não é um iniciante que vai ler esses arquivos e entender tudo. Mas se alguma vez você já se perguntou, onde que tem a definição exata de uma linguagem? São nesses arquivos, e não em blog post.








Por exemplo, o Javascript tem uma definição semelhante. No site do EcmaScript podemos ver como é definido a versão mais nova 2023. E se pularmos aqui no menu pra Notação de Gramática, olha só como é a definição de um Variable Declaration, ou declaração de variável: é um Binding Identifier e um Initializer. Um Binding Identifier são tokens como "const", "let" ou "var" e um Initializer é uma expressão de assignment como "x = 1". E olha aqui embaixo, ele define como é um loop com for, um For Statement, que pode ser definido de 4 maneiras diferentes, todos com um Lexical Declaration e variando a forma da Expression.








Mas beleza, essa é a gramática mas e daí, pra que serve? O objetivo é quebrar seu código fonte, que é um texto, em uma listona de tokens e depois usar a gramática pra organizar esses tokens em uma estrutura de dados que podemos manipular programaticamente. O objetivo é transformar seu código em uma árvore, mais especificamente uma Parse Tree. Lembram? Eu sempre falo que uma das estruturas de dados mais importantes é uma árvore, por isso dediquei um video inteiro só sobre isso. No final seu código fonte vai ficar mais ou menos assim: (imagem)








Aliás, tudo que expliquei até agora sobre analisadores léxicos e sintáticos, o processo de transformar um texto de código em tokens e reorganizar esses tokens numa árvore, é o que muita gente chama de "parser", mas na realidade a primeira etapa de tokenizar é feito por um lexer, e a segunda parte de pegar os tokens e transformar em árvore é feita por um parser. Pra simplificar, vou pular a explicação do que é uma Parse Tree e ir direto pra mostrar outra representação da mesma árvore, que é a árvore de sintaxe, Syntax Tree, ou mais especificamente uma Abstract Syntax Tree ou AST.









Lembra daquela minha linguagem de programação mais estúpida do mundo, que só aceita uma linha e só faz soma de dois elementos? Digamos que eu evolua ela pra fazer conta com mais de dois elementos e queira escrever aquele `1 + 2 * 3`. Essa é a notação que chamamos de infixa onde operadores como o sinal de mais e o asterisco vão no meio dos operandos, que são os números. É a notação, ou forma de escrever, que nós humanos estamos mais acostumados a ver, mas não é a única notação e nem a melhor. 







Quem tá acostumado com as boas e velhas calculadoras de engenharia da HP conhece a famosa notação RPN ou notação polonesa reversa onde começamos digitando 3, depois 2, depois asterisco. Daí ele multiplica o 3 pelo 2, que dá 6. Continuamos digitando o 1 e só depois o sinal de soma, que vai somar o 1 com o resultado parcial 6, e isso vai dar 7.







Notação polonesa reversa é o que chamamos de pósfixa. Portanto notação polonesa é a préfixa. E numa árvore de sintaxe escrevemos de forma préfixa. O importante é saber que o que você considera "bom senso", nem sempre é, tem formas melhores. Vamos ver como fica. A árvore pra essa conta começa com um nó raiz que seria o sinal de mais. Começamos pelo operador, por isso préfixo. Daí divide em dois galhos, o nó da esquerda poderia ser o asterisco e o nó da direita o número 1. Embaixo do nó de asterisco, divide um nó a esquerda pra ser o 2 e outro a direita pra ser o 3. 








Essa representação seria o equivalente a escrever direto em polonês como `+(*(2, 3), 1)`. Já viram isso antes? Vamos mudar o símbolo de "+" e chamar de `somar` e trocar asterisco por `multiplicar`, daí ficaria `somar(multiplicar(2, 3), 1)`. Ficou mais claro agora?




É assim que você programa. A maioria das linguagens de programação, no caso especial de contas aritmeticas, como soma ou multiplicação, deixa você escrever da forma infixa, mas internamente, depois do parsing, o compilador tá mudando pra forma préfixa na árvore, assim como todo o resto das suas funções. Isso tudo foi pra ilustrar rapidamente que a forma que você escreve o código não é a forma como o computador vai executar.









Vamos ver como isso funciona. Vamos fazer outro programinha idiota em Java, que pegue os 3 primeiros parâmetros, converta o texto em número, que vai ser os números 1, 2 e 3 que usamos no exemplo anterior. Então precisa chamar o método estático `parseInt` da classe `Integer`. Daí vou imprimir no console com `System.out.print` a soma de a com b vezes c, exatamente como no exemplo. Agora compilamos com `javac` e podemos chamar `java Calc 1 2 3` e deu 7, como deveria. Nenhuma surpresa aqui.








Mas o que de fato executou? Pra quem não sabe existe a ferramenta `javap` que vem no JDK de Java que serve pra desassemblar, pra mostrar o assembly de bytecodes de Java. Lembra no episódio do guia mais hardcore de introdução a computadores que eu mostrei uma parte do assembly da CPU 6502 que era usado no antigo Nintendinho? Mesma coisa, a ferramenta javac vai passar nosso código por um parser, fazer algumas mágicas que já vou explicar e cuspir instruções binárias de máquina, o que comumente se chama de bytecodes ou assembly. E o javap só mostra esses bytecodes na tela de forma que nós humanos conseguimos ler.









Parece complicado, mas pra esse exemplo simples não é. Esse trecho que vai até a linha 21 são as instruções pra pegar os argumentos que passamos e converter em inteiro, aquele `Integer.parseInt`. Percebam que a gente só escreveu uma linha de código pra cada um dos três parâmetros, mas pra cada um ele gerou pelo menos 4 instruções, isso sem contar esse `invokestatic` que chama seja lá o que o `parseInt` faça. 








Novamente, o que você escreve na sua linguagem sempre vira bem mais instruções depois de compilado, e esse é o objetivo. Antigamente, até antes dos anos 90, era super comum escrever direto em assembly, em linguagem de máquina, porque era mais eficiente. Não havia nem memória, nem processamento suficiente pra existir um compilador inteligente como os de hoje. 







Mas agora os compiladores evoluíram tanto que geram assembly muito melhor do que é possível fazer na mão. Além disso os programas que escrevemos hoje são muito maiores, seria impossível escrever tudo em assembly. Se alguém já se perguntou se seria mais eficiente escrever tudo em assembly, não, não é, tirando raríssimas exceções, nenhum programador hoje é melhor que um compilador.









De qualquer forma, a parte que importa são as linhas 24 a 28. Aqui esse bytecode `iload` vai empilhando na Stack os números que converteu. Daí chama o bytecode `imul` que, como dá pra ver pelo nome, é a multiplicação. Ele desempilha os últimos 2 números, multiplica e empilha de volta o resultado. Chega na instrução `iadd` que desempilha os últimos dois valores na Stack, soma e empilha o resultado. Lembram? Eu expliquei pilhas no episódio de Hello World como você nunca viu. Se não sabe como um sistema baseado em pilha funciona, assista esse episódio depois.









Os mais espertos aí assistindo talvez tenham notado, mas porque eu fiz essa forma complicada de ter que passar os números como parâmetros na linha de comando? Por que não deixei hardcoded direto no código o `1 + 2 * 3`? Vamos fazer isso agora. Deixa eu criar uma nova classe chamada `Calc2` e fazer direto `System.out.print(1 + 2 * 3)`. 







Aliás, ignorem a nomenclatura de classes que estou usando, tá bem porco mesmo só pra ir mais rápido, mas obviamente não façam nomes como "Calc2" em projeto de verdade, né? Enfim, agora salvamos, compilamos de novo com `javac` e podemos executar com `java Calc2` e devolve 7 de novo. Se for como no exemplo anterior, agora deve ter cortado aquele monte de bytecodes de parseInt mas deve ter as mesmas instruções de iload pra empilhar e imul e iadd pra multiplicar e somar, né?








Vamos conferir. Fazemos `javap -c Calc2` e olha só, ué, cadê a multiplicação e adição? Não tem, em vez disso tem aqui esse bytecode `bipush` que quer dizer "empilhe este número inteiro na Stack", no caso o número 7 que já é direto o resultado de `1 + 2 * 3`. Sacaram? Na hora de compilar o javac já viu: cara, essa conta vai dar 7 sempre, nunca vai mudar, então pra que vou refazer o cálculo toda vez? Deixa eu já pré-calcular e dar direto o resultado. Assim ele economizou 3 chamadas de `iload`, e as chamadas pra `imul` e `iadd`. Em vez disso ficou só uma chamada `bipush` pra empilhar direto o resultado final 7 e daí já pula pra chamada que vai imprimir o texto no console. O compilador literalmente reescreveu meu código.










Lembram daquele meu interpretador pra linguagem mais estúpida do mundo? Ele pega o código do meu programa, tokeniza e coloca os tokens num array, e faz um switch case, se achar o operador "add" executa uma soma, se achar um "mul" faz multiplicação. E olhando pra isso, vocês poderiam pensar, "ah, isso faz sentido, pra que precisa de tanto trabalho pra converter os tokens numa árvore e depois da árvore converter em instruções de máquina em vez de direto já cuspir instruções?" E esse é um dos motivos. Vamos filosofar um pouco.









Não importa que sintaxe de linguagens você ache mais bonita ou mais elegante ou mais produtiva. Não importa se você gosta de usar chaves pra delimitar funções como no Java ou se prefere usar identação como em Python. Não importa se prefere dividir tudo em várias pequenas funções de poucas linhas ou prefira o jeito go-horse de entuchar o máximo de linhas dentro de uma função. Não importa se gosta ou não de colocar comentários detalhados antes de cada função. Tudo isso é totalmente irrelevante pro computador. 








Depois que seu código for parseado e compilado, o que vai sobrar são instruções de máquina. Muito do que você escreveu vai ser reescrito, o compilador vai pensar "porque esse idiota deixou um cálculo hardcoded que sempre dá a mesma resposta? vou reescrever e deixar direto só a resposta, foda-se." Sim, o compilador vai jogar fora tudo que você escreveu e vai reescrever tudo do zero da forma que ele acha mais eficiente. É isso que o computador vai ver no final e executar.








Mas então, tudo que sempre me falaram de Código Limpo, boas práticas, serve pra que então? Se no final o computador tá cagando e andando, pra que eu tô perdendo tempo organizando todo meu código, escolhendo nomes fáceis de entender e tudo mais? Porque você não está e nem deve estar programando pro computador, você programa pra outras pessoas. Entenda essa verdade: o seu trabalho não é programar pro computador e sim pra que outras pessoas entendam. Incluindo você daqui alguns dias ou meses.







Se como eu você curte retrogames, já deve ter assistido videos explicando os truques que programadores faziam antigamente pra conseguir extrair o máximo de máquinas de processadores super fracos como o Z80 ou 6502, com quase nada de RAM, na faixa de 2 kilobytes. Pensa que o Super Mario World inteiro, com todos os gráficos, fases e lógica ocupa meio megabyte. Em meio megabyte hoje você não consegue fazer nada. 








Qualquer página web simples precisa de múltiplos megabytes. E isso porque antigamente ciclos de CPU e RAM eram hiper caras. Pelo mesmo preço que se comprava um Nintendinho nos anos 80, hoje você compra um Playstation 5. Literalmente, no começo dos anos 80 um nintendinho custava quase 180 dólares, que se ajustar pra inflação dá quase 500 dólares, que é o preço de um PS5.









Por isso antigamente era hiper importante economizar ciclos e bytes ao máximo, mesmo que fosse ao custo de dificultar a vida dos programadores, porque o custo do hardware era muito maior que o custo de programadores. 10 kilobytes a mais de RAM que desperdiçasse em 1983 era 200 dólares a mais. Por isso escovar bits era a coisa mais importante. Mas o tempo passou e agora 200 dólares você compra mais de 16 giga de RAM. Por isso que desperdiçar 1 ou 2 gigas de RAM, por mais absurdo que pareça, não é mais grande coisa.









Por outro lado o que subiu foi a hora de programador. Se o programador tem que gastar o dia todo pra descobrir que diabos é esse número 7 e que a conta original era 1 + 2 * 3, que se estivesse explícito no código ia custar 2 segundos pra entender, faz muita diferença. Toda boa prática de código é feito pra economizar hora de programador e não hora da máquina. E mesmo se você trabalha sozinho, as boas práticas e código limpo continuam fazendo sentido, porque o você de amanhã, às 2 horas da manhã numa emergência, vai te agradecer por ter feito tudo organizado e fácil de ler. 








Lógico, não estou dizendo que você não tem que saber programar direito sabendo como a máquina vai se comportar. Nem o melhor compilador do mundo vai melhorar seu código bosta que dá "select *" numa tabela gigante do banco só pra pegar uma linha, porque ele não tem como saber, durante a compilação, que pode ter uma tabela de um milhão de linhas sendo consumido e causando vazamento de memória. Ele vai fazer o melhor possível, mas não existe limites pra programador ruim dificultar a vida do compilador.








Mas a tecnologia de compiladores não serve só pra cuspir binários otimizados. Aquela árvore de sintaxe abstrata, a AST é útil pro programador. Sabe quando no VSCode você instala uma extension pra Javascript que roda o jslinter e ele marca no seu código onde tem problemas e possíveis bugs? Essa análise é feita em cima da AST. Ele não tá olhando o texto do seu código. 







Por baixo dos panos ele passou pelo parser do V8, gerou a estrutura de árvore e tá processando os nós dessa árvore. Os nós podem conter metadados que apontam de volta qual linha do código que representa, e assim dá pra analisar e devolver a análise pro editor mostrar bonitinho pra você. Todo linter funciona assim. Um linter ou ferramentas de análise estática, tentam te orientar pra escrever código melhor e apontar coisas que seriam ambíguas pro compilador, daí ele pode te dizer o equivalente a "tem certeza que é isso que você quer fazer?"








O que mostrei até aqui é a fase de parsing. Essa idéia de criar uma gramática livre de contexto veio de ninguém menos que John Backus, criador do Fortran, provavelmente a primeira linguagem de alto nível de sucesso comercial, lá nos anos 60. E não só ele fez a linguagem como se inspirou nos trabalhos de pesquisadores como o grande Turing ou Noam Chomski, cujo foco era linguagens no termo mais genérico, tipo língua portuguesa ou inglês, mas os resultados poderiam ser aplicados em linguagens de computador.








O Backus inventou essa idéia de uma linguagem que descreve outra linguagem, ou seja, uma meta-linguagem, e usou pra definir uma nova linguagem chamada IAL, que viria a se tornar o ALGOL. Muita gente costuma pensar em C como o avô das linguagens, mais por causa dos blocos com chave e statements terminando com ponto e vírgula. Outros consideram o C muito novo pra ser avô e o verdadeiro avô seria o COBOL. 







Mas eu penso diferente. No máximo, COBOL é mais avô de coisas como linguagens de stored procedures de banco de dados. A real linguagem avô do que chamamos de "linguagens de uso genérico", anterior ao C, é o ALGOL. Antes do C ser inventado, o Ritchie e Kerninghan trabalharam no BCPL que poderíamos chamar de linguagem "B" e pra mim a linguagem "A" é o ALGOL.







Antes que alguém comente, sim, eu sei, não é exatamente assim. ALGOL foi um linguagem criada por comitê e, como tudo que é gerado por comitê, ficou uma linguagem bloated, complexa, gorda. Daí na universidade de Cambridge em Londres surgiu o CPL que é o Combined Programming Language, mas que obviamente muitos poderiam chamar de Cambridge Programming Language, pra ser o "ALGOL com os pés no chão". Acabou não sendo muito bem aceita, a intenção foi melhor que a implementação. Povo de javascript já viu episódios desse tipo, como yarn querendo ser npm melhorado, ou Deno querendo ser Node melhorado.








Ainda em Cambridge tentaram simplificar o CPL com o Basic CPL ou BCPL do Martin Richards, pra ser "só as coisas boas do CPL". Poucos anos depois o Ken Thompson chefiou o projeto de UNIX pras máquinas PDP/11 e fez um compilador pra uma versão reduzida do BCPL que chamou de linguagem B. Mas tanto BCPL quanto B eram limitadas. B era alto nivel demais e como eu disse antes, isso custava recursos escassos e caros de hardware. Por esses e outros problemas, surgiu Dennis Ritchie pra reescrever a linguagem que seria a sucessora do B pra ser mais "próxima da máquina" e daí surgiu o C.








Mas independente disso, está claro que as raízes das principais funcionalidades que reconhecemos hoje numa linguagem de uso geral surgiram com o Algol e por isso podemos considerar que ela é a verdadeira linguagem A. E a linguagem C é a versão que realmente vingou e serviu de inspiração pra linguagens mais modernas como C++, Objective-C, que inspiraram depois Java, Python, C# e todo o resto que vocês usam hoje.








De qualquer forma, o cientista da computação Peter Naur reconheceu o poder da idéia de metalinguagem do Backus e como já existia o termo "Chomski Normal Form", ele decidiu que a notação do Backus deveria se chamar "Backus Normal Form" ou BNF. Mas tecnicamente não era uma forma normal, como apontou o lendário Donald Knuth e foi ele que sugeriu que BNF deveria ser pra "Backus-Naur Form", e é assim que chamamos até hoje.








Mas como falei antes, poucos programadores hoje, eu incluso, estudam as definições matemáticas por trás das notações de linguagens, com o rigor que deveria, porque ferramentas como flex, bison, yacc simplificam tudo isso e a gente tem mais que se preocupar com o design da linguagem propriamente dita, que começa em escrever a tabela de lexemes e a gramática no formato que mostrei antes. Em particular, se tiver interesse em estudar mais sobre geradores de parsers, a que eu vejo que povo considera mais moderna é o ANTLR, que por acaso é feita em Java.








Um parser não serve só pra compilar linguagens de programação. Pense um arquivo de configuração em YAML ou um JSON. Ambos não deixam de ser linguagens, só que declarativas e não de programação. Ambas precisam de um parser e de fato, pra transformar um YAML ou JSON num objeto de javascript, ou um Hash em Python, precisa de um lexer e de um parser. 






Sabe quando você carrega um arquivo texto de HTML num navegador e agora dá pra inspecionar usando as ferramentas de debug? Você que é de front-end sabe disso, ele se transforma no tal do DOM ou Document Object Model. E o que é o DOM? É uma árvore, é resultado de passar o HTML por um parser. E como o navegador desenha as coisas na tela? Navegando pode Node a Node do DOM. O DOM está pra HTML assim como AST está pra uma linguagem de programação. E da mesma forma que você pode modificar nós do DOM, o compilador manipula nós do AST pra melhorar seu código e gerar binários mais eficientes.








Tanto o que você chama de compilador quanto o que chama de interpretador começam com um lexer e um parser. Mas a história não acaba aqui. Agora vem a parte interessante da história. Lembra quando fizemos o disassembly do binário compilado de Java? Ele não era uma árvore né, era uma sequência de instruções, o que em Java se chama de bytecodes. Depois que o javac gerou o AST, checou que a sintaxe tá correta e as dependências estão corretas, daí navega nó a nó da árvore e cospe os bytecodes correspondentes pra gerar o arquivo ".class" no final.








Vamos recapitular, o que é um bytecode? É literalmente isso, um código de byte. Cada instrução como aquela aaload, iload, imul, iadd são mnemônicos pra um código binário. Por exemplo, aaload é o hexadecimal 32 ou o binário 0011 0010. Lembra, a máquina hardware, a CPU, só entende binário e internamente tem instruções que são representadas por certas sequências de bits.









Assista o episódio de Hello World ou outros videos da série "Como Computadores Funcionam" pra relembrar disso. Mas agora vem uma pergunta, que diabos de instrução é isso de aaload, iload, imul. Isso não é assembly de x64, que é o que roda em Intel ou AMD aí no seu PC ou notebook. Também não são instruções de ARM como os Mac M1 ou Qualcomm do seu Android. Que diabo de instruções são essas? E aqui vem a parte que confunde a diferença entre um compilador puro e um interpretador. Essas instruções são pra uma máquina virtual que não existe em forma de hardware.








Se existisse um chip de Java - e nos anos 90 a Sun até queria mesmo fazer um chip de verdade Java -, essas seriam as instruções. Mas esse chip não existe, o que existe é a JVM, que literalmente significa Java Virtual Machine. Todo programa Java roda numa máquina virtual. Por similaridade, todo programa Python roda numa máquina virtual Python. Todo programa Javascript roda numa máquina virtual Javascript, como o Google V8 ou Mozilla SpiderMonkey. Todo navegador web vem embutido com uma máquina virtual. E sim, máquina virtual como um Virtualbox ou VMWare, já pararam pra pensar nisso?








A gente tá acostumado a pensar em máquina virtual só como um Virtualbox ou Parallels ou erroneamente um Docker - que não é máquina virtual. Pensamos como programas que podemos instalar num Mac M1 pra conseguir rodar outros programas compilados como binários de Intel e interpretar em tempo real pra rodar numa máquina ARM. Tecnicamente, toda máquina virtual é um interpretador, no sentido que ele interpreta uma instrução de uma máquina pra instrução de outra máquina.








Pra quem é de Python, quando chamamos `python -c compileall .`, ele vai pegar todos os arquivos texto com extensão `.py` e transformar em `.pyc` ou `.pyo`. Pra isso o código texto vai passar por um lexer, por um parser e no final o AST resultante é transformado em instruções pra uma máquina virtual de Python. Aí ele serializa e salva esse AST num binário ".pyc". O que chamamos de "interpretador" é um caso especial de máquina virtual. Alguns também chamam isso de "runtime", mas são só nomes diferentes pra mesma coisa. Pra todos os efeitos e propósitos, seu programa Python tá rodando numa máquina virtual. O Javascript do seu navegador ou no Node.js também.









Dentre várias coisas que podem ser diferentes é que normalmente quando falamos de interpretadores é quando temos algumas facilidades de desenvolvimento, como um REPL que é acrônimo pra Read-Eval-Print-Loop, que é a linha de comando que abre quando você digita `python` ou `node` no terminal e pode sair digitando código que ele vai executando imediatamente, ou seja, ele lê, faz evaluation, imprime o resultado e volta pro loop e fica nisso até apertar `Ctrl+D` pra sair. Aliás, a linha de comando do seu terminal, seja Bash, ZSH ou Fish, é um interpretador também.








Sendo mais específico, um interpretador costuma manter o AST num formato que podemos modificar, depois dos arquivos do programa terem todos passados pelo parser. Toda vez que dentro do console de Python a gente define um novo método, estamos adicionando nós na árvore AST. É isso que define o que muitos chamam de "linguagem dinâmica". Mesmo Java, apesar de mais chatinho, tem como modificar o AST que tá em memória. Eu posso mandar o classloader da JVM carregar outros arquivos ".class" que ainda não tinha carregado, ou usar a API de Reflection pra modificar o código em tempo real.








Claro, apesar de parecerem máquinas virtuais, interpretadores são diferentes de um VirtualBox. Um VirtualBox da vida de fato tenta ao máquina esconder tudo sobre a máquina host por baixo, pra fazer os programas rodando dentro acreditar que estão numa máquina de verdade. Quando um programa lá dentro pede pra fuçar o disco, o Virtualbox vai dar pra ele um disco virtual e não acesso ao disco de verdade. 








Quando o programa pede pra conectar na internet, ele não vai ter acesso ao TCP da máquina de verdade, mas sim à uma rede virtual interna, como se fosse uma rede externa separada que faz ponte com a rede da máquina de verdade. E assim por diante. Já um interpretador não tenta esconder nada. Quando o programa de python pede acesso ao disco, o interpretador dá acesso ao disco de verdade. Quando o programa pede pra abrir um socket de rede, ele passa pela rede de verdade. 








Então tecnicamente sim, Java é uma linguagem compilada porque no final gera um binário com instruções de máquina. Só que não são instruções de Intel ou ARM e sim pra JVM, uma máquina só virtual. Por outro lado, ela é interpretada porque a máquina pra qual ela foi compilada não existe e pra rodar depende de um interpretador que entende essas instruções e vai converter pras instruções da máquina host de verdade, como um Intel x64. O mesmo vale pra Python, Javascript, Ruby, PHP. E eu sei, já estou vendo você aí já indo ferozmente pros comentários pra discordar, porque eu ainda não mencionei JIT, segura a onda aí!








Já vou voltar no assunto de interpretadores e máquinas virtuais, mas o importante é saber que depois da fase de parsing, o objetivo é transformar a árvore abstrata de sintaxe em instruções de máquina, seja lá pra qual arquitetura de CPUs: uma de verdade como x64 ou arm64 ou uma virtual como a JVM. A história não acaba aqui.







Mesmo o compilador de C como GCC ou o clang de LLVM não sai da AST depois do parsing e já transforma direto em instrução de Intel. Não, acho que hoje em dia praticamente todos os compiladores trabalham com uma representação intermediária. O compilador de DotNet, por exemplo, chama isso de Intermediate Language ou IL. No mundo LLVM isso se chama Intermediate Representation ou IR. No mundo do GNU Compiler Collection ou GCC que todo mundo conhece, ele trabalha com RTL que é o Register Transfer Language. No mundo de shaders como pra rodar em Vulkan no SteamDeck, existe o padrão Standard Portable Intermediate Representation ou SPIR-V. E o que diabos é isso de linguagem intermediária?









Agora é a parte da mágica que eu falei antes que vou simplificar bastante, entenda que essa parte é absurdamente extensa na realidade. Vou usar o exemplo mais besta de todos. Lembra aquele exemplo da calculadora que escrevi em Java pra dar print em `1 + 2 * 3` e depois de compilar, fizemos o desassembly pra ver as instruções e só tinha um `bipush` direto do resultado 7? Pois é, o compilador foi inteligente em saber que não precisa traduzir instrução a instrução, a multiplicação e soma e, em vez disso, já pré-calculou e deixou direto o resultado, economizando várias instruções. Ou seja, ele otimizou o código e deixou tanto mais rápido quanto economizou ter que guardar os números 1, 2 e 3 na memória.









Essa é a otimização mais trivial e besta de todas, mas o compilador tem a capacidade de fazer centenas de outras otimizações. Por exemplo, digamos que seu código tenha trechos que nunca usa. Dependendo da linguagem e agressividade da otimização, ele pode até escolher jogar fora esse trecho e nem traduzir. Sim, o compilador pode escolher jogar seu código fora. Ele pode simplificar chamadas. Se a ordem dos fatores não influir no resultado, pode mudar a ordem do seu código pra CPU processar de forma mais eficiente.








Essa fase de otimização pode passar por todo o código mais de uma vez, é o que se chama de "passes". Isso pra conseguir fazer coisas como achar constantes duplicadas e fazer ambas apontarem pro mesmo lugar. Eliminação de código morto, ou seja, trechos que nunca são executados e podem ser eliminados. Tail Call elimination, pra remover chamadas recursivas que podem ser otimizadas. E muito, muito mais. Isso é o que o LLVM chama de Transformation Passes. 







Entre aspas é como se você tivesse um Linus Torvalds e um John Carmack juntos, reescrevendo seu código da maneira mais otimizada possível. Na prática essa etapa é o real trabalho de um compilador e onde se gasta mais tempo e mais recursos, porque tem um gerador de código varrendo tudo que você escreveu, exaustivamente, várias vezes, e reescrevendo da melhor forma que se conhece sem quebrar, nem gerar bugs.








Agora, imagine o seguinte: tá vendo essa lista de transformações e otimizações? Imagine se toda vez que inventa uma nova linguagem, se precisasse reescrever todas essas estratégias tudo de novo pra linguagem nova. Seria um trabalho absurdo, que ia gerar dezenas de bugs, e as otimizações seriam ruins porque criar essas rotinas levou anos e milhares de horas homens pra aperfeiçoar até ficarem perfeitas. Por isso que o comum é que toda nova linguagem, no final do parsing, seja convertida numa linguagem intermediária, que é sempre igual. E essa linguagem costuma ser tipo um assembly pra uma máquina virtual, que não precisa se preocupar nesse ponto com as limitações de design e legado de uma CPU de verdade com um x64.








Daí todas essas estratégias de otimização são executadas nessa linguagem interdiária. Um compilador como GCC ou derivados de LLVM na verdade são programas grandões que podemos dividir em 3 grandes funções diferentes. O primeiro é o front-end, que tem a responsabilidade de pegar linguagens como C, C++, Go, Rust, Swift e fazer o lexing, o parsing, gerar a árvore de sintaxe e dela cuspir as instruções de máquina virtual intermediária, sem quase nenhuma otimização. Essas instruções intermediárias são o RTL, no caso de GCC, ou IR no caso de LLVM, ou IL no caso de DotNet. O clang de LLVM seria o front-end de C pra LLVM, o conjunto das definições de lexer e gramática do parser.








Agora o 2o programa pega esse IR não otimizado e gasta um tempão lendo, relendo e reescrevendo, e a saída vai ser outro IR agora totalmente otimizado. Esse programa do meio poderia ser chamado de "middle-end". E relembrando, cada uma das otimizações ou transformation passes que ele faz poderia ser tema de um paper de Ph.D. Não são coisas triviais como o exemplo que eu mostrei. E finalmente temos o 3o programa, que chamamos de "back-end", que vai pegar o IR otimizado e traduzir finalmente pras instruções da máquina de verdade, ou seja, converter de instruções assembly de IR pra instruções assembly de x64 ou arm64 da vida. E esse é o binário final que pode ser executado.







Toda vez que que eu quiser inventar uma nova linguagem é só fazer as partes de lexer e parser, fazer só a parte que é o front-end dessa nova linguagem. É pra isso que servem ferramentas como o ANTLR que eu mencionei antes. É isso que linguagens como Rust fizeram quando construíram o compilador em cima de LLVM. Ele pode deixar um compilador que já existe otimizar o que puder. Num primeiro momento, o criador de uma nova linguagem não precisa refazer tudo do zero, pode reaproveitar o que já existe, porque uma vez tendo IR, o resto é igual. A preocupação inicial dele é só fazer um parser que converte sua linguagem em IR, como um transpiler que converte TypeScript em Javascript, por exemplo.







Quando um designer de chips como uma Apple inventa um novo como os tais M1, ele só precisa fazer a parte back-end, a parte que pega o IR já otimizado e converte em instruções de máquina. Amanhã a Qualcomm lança um novo chip SnapDragon ARM, ele só precisa atualizar o back-end do compilador, todo o resto continua igual. A AMD lança a nova série 6000 do Ryzen, só precisa atualizar o back-end dos principais compiladores se teve alguma mudança nas suas instruções. Entenderam?







Eu expliquei isso no video de Apple e GPL, mas além obviamente do hardware, qual é o grande segredo da Apple em conseguir migrar tudo pra M1 tão rápido? É eles terem investido quase 2 décadas melhorando suas tecnologias de compiladores em cima de LLVM. Com isso conseguiram migrar de PowerPC pra Intel nos anos 2000 e com isso migraram de Intel pra ARM muito rápido. E tudo que só o compilador não consegue resolver, eles tem como desenhar no chip pra compensar. E com isso temos as performances absurdas que vocês assistem nos diversos reviews de como programas originalmente compilados pra Intel rodam liso em ARM sem recompilar, só sendo interpretados em tempo real.







Se você é um cientista da computação e tem vontade de criar uma nova linguagem, provavelmente vai começar fazendo um front-end pra LLVM. Assim saíram linguagens como Rust da Mozilla, Julia, Crystal e outros. Pouquíssimas empresas tem capacidade pra fazer um compilador do zero com todos os tipos possíveis de otimização. Java tem otimizador próprio desde a era da Sun e depois passou pra Oracle e tem dezenas de empresas que investem em pesquisa pra continuar melhorando. O DotNet tem a Microsoft, que também investe pesado em pesquisa. E no meio disso tem o Javascript e o V8 do Google.








Agora, qual a diferença de C, Java e Javascript? No final do dia quer dizer que C é compilado porque gera binário nativo de máquina, mas Java e Javascript são interpretados? Não, no final do dia, todos geram binário nativo de máquina usando estratégias diferentes, pra resolver problemas diferentes. A estratégia de C se chama ahead of time compiling ou AOT. E no Java e Javascript eles usam Just in Time compiler, o famoso JIT. E mesmo JIT tem diversas estratégias diferentes.








Vou fazer outro exemplinho bem besta só pra vocês terem uma imagem na cabeça. Vamos voltar pro exemplo em Java de fazer um cálculo. Quem lembra como calcula a circunferência de um círculo? Lembra? Duas vezes Pi vezes Raio? 2 pi r. Então vamos fazer uma nova classe, método estático main, e System.out.print, 2 vezes 3.141592 etc que é PI mas vou colocar poucos dígitos pro exemplo, e vezes 10 que é o raio que quero usar. Salvamos, saímos, compilamos com `javac`, rodamos e voilá, 62.83 bla bla é a circunferência pra um raio 10.









Se fizermos disassembly com `javap` olha aqui embaixo essa instrução `ldc2_w` que puxa uma constante do pool de constantes e manda pra stack, e no comentário gerado temos que essa constante é um double 62.83 bla bla que é o valor pré-calculado. Ele fez a mesma otimização que no caso do `1 + 2 * 3`. Top, é o esperado. Mas como eu disse antes, olha como essa continha no código é feio, mesmo sendo simples. Quem curte código limpo tem gatilho só de ver isso. Dá pra melhorar isso.







	
Vamos escrever uma nova classe. Eu poderia começar definindo uma constante double chamada PI e escrever ali, 3.141592. Mas isso seria idiota porque obviamente Java já tem uma constante estática double de PI, que tá na classe Math. Ah, mas como eu ia adivinhar? Sempre pense: coisas triviais assim, as chances são que já existe. Na dúvida procurar no Google, "Java constant PI" e olha só, nos primeiros links já vem Math.PI. Quando você não acha as coisas não é que não existem ou são difíceis de achar, você que não procurou direito.








Enfim, continuamos fazendo uma função estática que retorna double chamada `circunferencia` que recebe como argumento uma variável double chamada `raio`. Dentro calculamos o 2 vezes `Math.PI` vezes a variável raio. E agora sim, no método `main` vamos dar `System.out.print`, como antes, mas o argumento vai ser o resultado do método `circunferencia` passando o valor 10. Pronto, salvamos, saímos, compilamos com `javac` e executamos e tá aí, 62.83 bla bla como tinha dada na outra versão. 








Compara a versão antiga com a nova. Ficou maior, mas a intenção do código tá muito mais clara. Se daqui 1 mês eu for editar esse código, dá pra saber o que ele faz imediatamente. E claro, dava pra ter feito bem mais bonito que isso, fazer uma classe chamada `Circulo` ou um módulo chamado `Geometria` ou qualquer coisa assim, mas hoje não é design de orientação a objetos, então não impliquem muito com isso hoje.








Mas vamos ver como fica fazendo disassembly com `javap` e olha que estranho, tem a instrução `ldc2_w` que puxa a contante 10 que é o raio que eu defini e puxa pra stack, daí invoca a função `circunferencia` e dá jump aqui pra cima. Daí faz outro `ldc2_w` pra puxar a constante de PI pra stack também, na verdade a constante de `2 * Pi`, veja o comentário que ele gerou mostrando que é o dobro de PI, então ele otimizou isso. Mas aí chama a instrução `dmul` que é multiplicação de double e desempilha os últimos dois valores que colocamos na stack pra calcular, retorna e finalmente dá `invokevirtual` no printf pra imprimir na tela.







Mas `2 * pi * 10` é tudo constante, porque ele não otimizou o suficiente pra arrancar fora essa função `circunferencia`, ela não seria desnecessária? Eu não disse que o compilador reescreve tudo pra ficar mais eficiente? Não dava pra ter pré-calculado como antes e só guardar a constante com o resultado final? Então, aqui que a coisa começa a complicar. Toda função que criamos no Java se torna uma interface. Se o compilador quisesse ser agressivo ele poderia arrancar tudo fora e deixar só a constante, porém a gente não sabe se ninguém mesmo vai usar essa função. Lembra? Java também é uma linguagem interpretada, dinâmica, cujo código pode ser alterado dentro da JVM.








Se pensar isoladamente só nessa classe, não teria problema, mas classes Java não vivem no vácuo, elas foram pensadas pra serem reusadas. Por exemplo, no mesmo diretório posso criar um novo arquivo e escrever uma nova classe assim, fazendo de novo um `System.out.print`, chamando `Calc3.circunferencia` direto assim mesmo e passando 20 como raio. Se eu sair e compilar só esse arquivo calc5.java, posso executar `java Calc5` e tudo funciona. Note que nem na hora de compilar e nem na hora de executar eu mencionei o Calc3, porque ele tá no mesmo diretório, então quando a JVM carrega a classe Calc5 automaticamente faz o Class Loader carregar o Calc3 junto. Mas ele não precisou recompilar o Calc3 de novo. 








E se eu apagar o Calc3.class e tentar executar o Calc5? Agora vai dar a erro de `NoClassDefFound`. Faz sentido né? Java foi feito de tal maneira que eu não preciso recompilar tudo do zero toda vez que alguma coisa muda. Ele compila cada classe individualmente, e pra garantir que outras classes não quebrem, pelo menos mantém a interface entre eles estável, o que significa que não pode sair otimizando demais e eliminando métodos, mesmo se naquela classe ela não é usada. E mesmo se eu tivesse declarado como `private`, ainda assim não daria pra apagar o método, porque Java tem sistema de Reflection que permite manipular métodos privados. Portanto, qualquer otimização que quebre a interface não pode ser feita.








Antes de continuar, agora precisamos entender rapidamente o que é uma interface. No mundo binário, não existe o conceito de abstração, tudo são instruções e endereços. Quando precisa chamar uma função, a máquina na verdade vai guardar o endereço que estamos executando  na pilha, vai fazer o jump, vai executar o que precisa, e no final vai retornar pro endereço que tinha guardado, pra continuar de onde parou. Eu expliquei isso no video do Hello World.







Agora, pra isso funcionar, quando eu compilei a classe Calc3, o compilador precisaria ter anotado que a função `circunferencia` vai estar disponível num endereço X, faz de conta 9000 0000. Daí quando eu compilei a classe Calc5 que chama essa função, nesse ponto o compilador precisaria saber que precisa escrever um jump pro tal endereço 9000 0000. Mas lembram que eu não passei o Calc3 como parâmetro nem nada? Como que o Java sabe pra qual endereço tem que dar jump?







Aqui estou especulando, mas imagino que quando a JVM carrega essas classes, nesse momento que ela vai preenchendo uma tabela interna que diz, "ok, carregar classe Calc3, ela tem um método circunferencia, vou colocar ela no endereço que tem vago aqui, 9000 0000". Depois carrega a Calc5 e quando executa a função `main` dela e de lá pede pra chamar a função `circunferencia`, daí a JVM intercepta essa chamada e consulta sua tabelinha "hmmmm, essa função é a que eu coloquei no endereço 9000 000, pula pra lá". Portanto os endereços não estão nas classes, elas são atribuídas na hora que a JVM carrega elas.







Vamos abrir o disassembly de novo, começa executando lá da linha 0 e vai indo. Uma hora esbarra nessa linha 6, que tem um `invokestatic` passando um índice 15. Ele olha lá na tabela interna dele e vê "ah, número 15 é o endereço 9000 0000" e aí dá o jump pro lugar certo. Eu simplifiquei mas justamente porque os endereços finais são definidos quando carrega o módulo e não quando compila, dá pra compilar as classes independentes uma da outra, como eu fiz aqui, compilando individualmente os dois arquivos, porque a JVM é quem vai gerenciar os endereços em tempo de execução.







Porém, linguagens como C, C++, Swift, Go, Rust, Crystal, e outras não tem um interpretador ou máquina virtual pra controlar isso, portanto cada parte de cada módulo sendo compilado precisa já saber o endereço final das coisas, senão na hora de executar não ia achar nada. Como que faz?







E aqui vem outro conceito de compilador que vou simplificar ao máximo. Pensa, se eu tivesse um projeto com mil arquivos, onde uma função num arquivo pode chamar funções em outros arquivos, seria uma zona pra compilar. Toda vez que eu mudo uma linha num arquivo, precisaria recompilar todos os mil arquivos pra garantir que os endereços de todo mundo estão corretos e eu não apaguei uma função ou deu conflito de endereços ou duplicou endereços sem querer. Então na realidade, tanto o GCC quanto um clang de LLVM quanto um rustc de Rust, vão quebrar a parte final da compilação em duas etapas.







Se você é de Linux e já instalou um pacote que compila a partir do código fonte, já deve ter esbarrado num `Makefile`, que nada mais é do que um script que automatiza a função de checar dependências, se tudo que precisa pra compilar tá instalado. Pra você que é de Javascript é o equivalente a um package.json. Pra você que é de Python é tipo um requirements.txt. Ele chama o compilador pra todos os arquivos do projeto. O que costuma aparecer na tela enquanto compila? Um monte de arquivos `.o` sendo gerados.








Esses ".o" são objetos, simplificando, eles são os binários compilados a partir de código fonte de C de cada arquivo. Vamos abrir o hello.c lá do começo. Tão vendo esse `include <stdio>` na primeira linha, isso indica pro compilador procurar por um arquivo de cabeçalho chamado `stdio.h` que tem que estar no Path do sistema. Nesse arquivo vai constar a interface da função `printf` que usamos lá embaixo. Se olharmos nesse arquivo tá dizendo que o `printf` é uma função que retorna inteiro e recebe como parâmetro um ponteiro constante de char, basicamente um array de chars, e tem outros argumentos opcionais.








Sem entrar muito em detalhes sobre o C, ter essa interface permite o compilador saber se quando estamos usando a função `printf`, se tá da forma correta. Porém, no momento da compilação do arquivo `hello.c` pro objeto binário `hello` ele ainda não sabe qual é o endereço onde encontrar a função, porque ela tá numa biblioteca externa, a libc, que é compartilhada com outros programas no mesmo sistema que dependem dela. Praticamente tudo numa distro Linux.







No ponto onde chama o `printf` o compilador vai tipo deixar um post-it dizendo "confirmar depois onde fica esse endereço". Se eu dependesse de outras bibliotecas externas, ia ficar deixando vários post-its pra confirmar depois. Pra ilustrar, vamos fazer o disassembly do objeto hello usando o `objdump -d`. Olhar assembly sempre é meio intimidante, mas não tem problema, só focar no pedaço que interessa que é a função `main` que começa aqui a partir do endereço 1139 em hexa. O `printf` é uma função então estamos procurando um `call`.







E no endereço 1147 temos um suspeito, um `call`, mas pra um endereço aqui perto, em 1030. Vamos ver o que tem lá. E olha lá, tem um jump pra esse outro endereço e um comentário que é pra função `puts` da glibc. Se não estou enganado, quando se chama o printf com o parâmetro opcional nulo, ele muda pra puts. Mas nessa linha, na primeira fase do compilador, quando ele ainda não sabe os endereços, vai ter algo como um espaço em branco pro endereço, um post-it pra segunda fase confirmar o endereço.







Essa segunda fase é o trabalho de um linker, no caso do GNU LD. Até agora eu não precisei chamar o linker manualmente porque o GCC faz isso sozinho pra gente. Mas se eu quiser manipular vários objetos já compilados e transformar numa biblioteca compartilhada, como um `.so` de Linux ou `.dll` de Windows, posso fazer isso com o comando `ld`.







Inclusive, o linker pode fazer otimizações em tempo de linking. Apesar do nome ser linker que é linkar ou grudar os pedaços, ele pode modificar mais do binário. É ele que sabe se é possível por exemplo fazer inlining. Lembra o exemplo besta de Java de circunferência? Se fosse em C, como ninguém mais chama aquela função, ele poderia simplesmente copiar o conteúdo da função e colar no lugar onde a função é chamada. Isso evita no mínimo uma instrução de jump e outra de return. Num programa maior tem muito mais ganhos.








No final, o compilador de C consegue analisar seu código e realizar um monte de otimizações e reescrever de uma forma otimizada, mas isso arquivo a arquivo independentemente, daí o linker reavalia  os binários gerados, liga os endereços de cada um onde precisa e ainda otimiza mais, o que diminui mais ainda o tamanho do binário, economiza mais memória e processamento na hora de executar, e por isso programas em C e similares como Rust são tão rápidos.








Linguagens como Java, Javascript, Python, e outros não tem o equivalente de um linker quando compilam do código fonte pra bytecode intermediário. Uma das razões disso é aumentar a reusabilidade desses binários, o que também torna a fase de compilação menos demorada que um C pra um projeto do mesmo tamanho. Porém o binário vai ser menos otimizado, tecnicamente mais lento do que o equivalente gerado por C. Então é isso? C sempre vai ser mais performático que qualquer coisa? Não é bem assim. E agora voltamos pra Just In Time Compiler, os JITs.










Quando você carrega um projeto em Java, ele inicia a máquina virtual JVM, daí o class loader começa carregando os arquivos binários `.class` do seu projeto e criando tipo uma tabelona interna que diz em quais endereços internos na memória estão quais classes e quais funções, de forma que quando uma classe pede pra executar uma função de outra classe, a JVM vai intermediar e arbitrar mandando executar a função correta, devolvendo o retorno e tudo mais. 








Um interpretador ou máquina virtual substitui a necessidade de um linker estático, porque ele cuida disso dinamicamente. Então você pode imaginar que o C, que não tem esse intermediário já precisa saber de antemão o endereço de tudo. Se de fato toda vez a JVM precisar ficar checando os endereços nessa tabela virtual pra cada chamada de função, seria tudo lento mesmo. Mas claro que no mínimo ela faz cache disso pra ir mais rápido. Mas ela pode fazer mais. Ela analisa os códigos mais executados, por exemplo baseado em quais caches são mais pedidos, os "pontos mais quentes" do programa, literalmente o HotSpot, que é o nome da máquina virtual de Java quando ele ganhou capacidades de just in time compiling, ou JIT.








Se meu programa chamasse aquela função circunferencia diversas vezes sempre com o mesmo raio, em vez de toda vez executar o cálculo, o JIT vai ser esperto e cachear o valor final. Muitas das otimizações que eu falei que o linker faz no C em tempo de compilação, o JIT vai fazer durante a execução. Por isso que em Java você já tenha ouvido falar de "tempo de aquecimento", ou warm up. Logo que inicia um servidor Java, ele vai ter uma performance X que pode até parecer baixa, mas deixe rodando um tempo, e o mesmo código começa a executar mais rápido. O JIT é um otimizador em tempo real, aplicando mais e mais otimizações nos códigos mais acessados.








Esse JIT, no final, tá traduzindo o bytecode do Java em instruções nativas de máquina de verdade mais otimizadas. É literalmente um compilador e mais ou menos um linkeditor que só trabalha em cima de código que realmente é necessário. Se seu programa for grande e tem partes que raramente são acessados ou ninguém nunca acessa, eles continuam lá sem serem otimizados. E o JIT vai fazendo cache do que vai otimizado, assim da próxima vez que alguém chamar essa parte, ele só executa o binário nativo de novo. E nesse ponto, esse trecho do código pode estar quase tão rápido como se tivesse sido escrito em C. Claro, não é só isso que determina a performance final, mas o JIT diminui bastante a distância entre traduzir bytecode Java de forma interpretada e um binário nativo compilado de C.









A mesma coisa acontece com Javascript no navegador. Navegadores baseados em Chromium, como o próprio Chrome, Microsoft Edge, Opera, Brave, todos acabam usando a máquina virtual Google V8 pra executar Javascript. V8 na verdade é o nome de um conjunto de tecnologias de compilador e máquina virtual, assim como Java ou Python. Internamente ele tem um lexer, um parser, que vai cuspir um AST e que por sua vez vai gerar uma representação binária intermediária em bytecodes específicos da máquina virtual do V8. 








Sim, o que roda no V8 não é javascript, são esses bytecodes. Repetindo, elas são como instruções de um x64 de verdade, mas pra uma máquina javascript que não existe. Nesse arquivo bytecode.h tem declarado todos os bytecodes. Vou deixar nas descrições abaixo pra quem tiver curiosidade.









Uma ver convertido em bytecodes, o interpretador do V8, que se chama Igniter, começa a traduzir instrução a instrução. Não vai ser lento, mas também não vai ser a melhor performance. Assim como na JVM, ele vai ficar analisando a execução e perceber quais partes precisa otimizar. Digamos que sua aplicação web baixou trocentas bibliotecas, por exemplo o arquivo inteiro do jQuery. Mas na real você só precisa da função `$()` pra achar um elemento da página e a função `fadeToggle` pra criar uma transição animada de fade desse elemento. Todas as outras funções você não usa.








Se o V8 fosse burro e tentasse compilar tudo que sua página baixa, ele ia gastar um tempão pra otimizar a biblioteca do jQuery inteiro, quando na verdade sua página só usa meia dúzia dessas funções. Mas à medida que o usuário navega pelo site, o V8 acha os hotspots e agora é hora do Just in Time Compiler, do JIT, entrar em ação, no caso o Google chama o JIT do V8 de TurboFan. É ele quem vai gastar memória e processamento pra otimizar as partes mais usadas e gerar binário nativo de máquina otimizado, parecido com o que o Java faz, e jogar num cache em memória ou até em disco. E por isso programas em Javascript costumam consumir muita memória.








Por isso que tanto Java quanto Javascript conseguem atingir velocidades muito boas, às vezes próximas de C mesmo sem terem sido agressivamente otimizadas por um compilador antes. Mas por que se dar a tanto trabalho e não simplesmente compilar tudo antes como o C faz? E isso não tem uma resposta única, mas se eu fosse resumir é o que define a diferença entre linguagens estáticas e dinâmicas.







A vantagem de C é que os compiladores amadureceram muito nos últimos 40 anos e o binário nativo final que geram tendem não só a serem os mais rápidos em geral, mas também a ocupar bem menos espaço em disco e a consumir menos memória quando carregam. Por isso que a kernel do Linux, drivers e coisas assim tendem a serem feitos com C, porque eu quero o mais otimizado possível e que escale bem, pra rodar tanto num servidor de datacenter com centenas de núcleos de processador e terabytes de RAM quanto num mero Raspberry Pi com quase nada de recursos.







Uma vez que o binário tá compilado estaticamente, é tudo fixo e imutável, você não tem como mudar o comportamento dele. Sim, se tiver muita paciência pra explorar coisas como injeção de código direto na memória do processo ou fazer patches de binários, explorar exploits de segurança, aí você consegue mudar alguma coisa. Mas isso é na gambiarra. É o que a comunidade de mods de games faz também. Eles descobrem em qual endereço da memória que fica o valor de vidas e eu injeto outro valor lá. Já mostrei isso no video do Super Mario.







Por outro lado pense no seu navegador web. A qualquer momento eu posso inspecionar um elemento de qualquer página e sair manipulando. Eu mesmo, quando faço capturas de tela pra mostrar a imagem de um site nos videos, se tem uma propaganda muito grande, abro o inspetor, seleciono o elemento de propaganda e apago. E essa mudança se reflete na página imediatamente. Isso só é possível porque o navegador mantém a estrutura de dados que representa essa página em memória de forma acessível via Javascript. E como o código javascript não é estático, não é fixo, porque tem um interpretador que aceita código novo sem precisar reiniciar, dá pra fazer essas coisas.






A grande vantagem de linguagens dinâmicas é permitir esse tipo de flexibilidade. Se isso é bom ou ruim, depende do seu uso. Tem gente que acha que isso não deveria ser permitido, que uma vez compilado, deveria ser tudo fechado. Tem gente que acha que precisa ser tudo aberto, independente se vai ficar mais lento ou consumir mais memória. Como eu sempre digo, em programação a gente troca uma coisa por outra, sempre. Não existe resposta definitiva, tudo depende de pra que vai usar. E no caso de um navegador web acho que todo mundo vai concordar que ser aberto e dinâmico é muito mais prático e é por isso que a Web em si fez tanto sucesso.








Além disso linguagens dinâmicas como Javascript, Ruby, Python, Elixir, Java, C#, possuem capacidades muito potentes de metaprogramação, onde você pode escrever código que altera que está em execução. Praticamente toda linguagem com um interpretador possibilita isso. Java tem Reflection, Javascript ES6 tem APIs como Reflect ou Proxy, Python tem a função `type`, Ruby tem coisas como Refinements. E a vantagem de um interpretador é que podemos injetar novos bytecodes sem reiniciar o programa. Como a maioria dos interpretadores possuem algum tipo de JIT, esse novo código também pode gerar binário nativo otimizado. 






Pra não complicar vou pular os detalhes sobre metaprogramação e a diferença com pré-processamento estático, templates como em C++, ou macros como em Rust. Estudem se tiver interesse, mas a conclusão de tudo isso é dizer que linguagens estáticas costumam ter um compilador que gera binários estáticos, cujo bytecode não é mais modificado facilmente. Linguagens dinâmicas costumam ter um interpretados justamente pra ter essas propriedades de dinamicamente modificar o bytecode e alterar o comportamento do programa em tempo real de execução. O custo disso é serem mais lentos, porque não puderam contar com a otimização agressiva de um compilador e linkeditor. 







Mas hoje em dia essa diferença diminuiu drasticamente, porque quase todo interpretador vem com um compilador embutido que roda em tempo real, um Just in time compiler, ou JIT. No fim do dia, ambos acabam gerando binário nativo otimizado, um gera tudo antes, o outro gera enquanto roda. Um usa menos recursos, porque fez toda a compilação e otimização antes, e o outro usa mais recursos, porque vai continuamento compilando à medida que o programa é executado.






Como o video ficou super longo já, no próximo video vou dar uma pincelada em cada linguagem individualmente, mas antes vocês precisavam entender a diferença entre compiladores e interpretadores. Ser interpretado não implica ser sempre "lento", só às vezes. Um exemplo, quem já ouviu falar de Elixir e Erlang provavelmente reconhece sua reputação de ser altamente escalável, tanto que é com ele que é feito o motor de comunicação por trás do Whatsapp, que é gigantesco. Mas nem todo mundo entende que Erlang, assim como Java, é uma linguagem interpretada, que roda numa máquina virtual, que é um tipo de interpretador, e que tem um Just in Time Compiler, ou JIT, pra acelerar as coisas.








Pela popularidade do Javascript, muita gente já sabe que as performances absurdas que ela consegue ter, o suficiente pra portar um game de verdade e rodar dentro do navegador é em grande parte graças ao JIT. Mas tem mais detalhes disso. E muito antes de Typescript e todas as linguagens transpiladas pra Javascript, um dos primeiros transpilers apareceu no mundo PHP com o HipHop do Facebook, que transpilava PHP pra C++. Hoje em dia eles pararam esse projeto e estão investindo mais na máquina virtual HHVM que é compatível até certo ponto com PHP 7. Python, consegue gravar os bytecodes da fase de parsing como arquivos `.pyc`, que são instruções pra sua própria máquina virtual. Ruby também gera bytecodes internamente. Enfim, tem bem mais coisas que eu vou guardar pro próximo video.









A intenção do video era só educar vocês pra não ficarem com cara de bobos argumentando coisas como "ah, sua linguagem é interpretada, por isso nunca vai ser tão rápida quanto uma compilada", ou "ah Java é melhor que Javascript porque ela é compilada". A grande verdade é que tecnologias de compiladores e máquinas virtuais evoluiu bastante nos últimos 20 anos e essas noções erradas que eram até corretas nos anos 90, já não é mais tão simples assim. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e não deixem de compartilhar o video com seus amigos. A gente se vê, até mais.
