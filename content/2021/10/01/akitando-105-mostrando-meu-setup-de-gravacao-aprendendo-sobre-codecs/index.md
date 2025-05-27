---
title: "[Akitando] #105 - Mostrando meu Setup de Gravação | Aprendendo sobre CODECs"
date: '2021-10-01T11:12:00-03:00'
slug: akitando-105-mostrando-meu-setup-de-gravacao-aprendendo-sobre-codecs
tags:
- atomos ninja v
- sony a7iii
- h.264
- h.265
- prores
- dnxhr
- codec
- setup
- estúdio
- akitando
draft: false
---

{{< youtube id="ApaPk9ToRJM" >}}

## DESCRIÇÃO

Transformando Limão em Limonada é o tema. Finalmente vou mostrar o setup que eu vim fazendo upgrade pra fazer videos melhores. Em particular meu novo Atomos Ninja V. E vou aproveitar pra explicar um pouco sobre CODECs de video. E no final vou mostrar meu cenário em mais detalhes.

Pra quem tinha curiosidade de saber como eu faço meus videos, este é o video!

## Conteúdo

* 00:00 - Intro
* 01:24 - Perdi minhas gravações, de novo!
* 03:19 - Sony a7iii
* 05:11 - Europeus fazem leis idiotas
* 06:06 - Captura de video no PC
* 06:29 - Setup do meu PC atual
* 10:39 - Setup do áudio
* 11:12 - Telepromper
* 11:24 - Meu processo de gravação antigo e chato!
* 12:59 - Solução: Atomos Ninja V
* 14:22 - Codecs e Containers
* 16:57 - Como um video é estruturado?
* 17:28 - Compressão. Imagens, áudio e video
* 22:25 - Codecs de delivery vs de edição
* 26:20 - Chroma Subsampling. Monitor vs TV
* 28:51 - iPhone 13
* 29:30 - Comparando Codecs
* 33:28 - Tour pelos detalhes do meu Cenário
* 36:22 - Final

## Links

- Video Codecs & Compression Guide (Feat. Atomos Ninja V) (https://www.youtube.com/watch?v=wX9KGRHaMEY)
- Playlist: Computerphile - Digital Imaging - Mike Pound (https://www.youtube.com/watch?v=06OHflWNCOE&list=PLboJFH3ATn0yC9uLuRLhaezUvtVPLtQvv)
- This Is What Happens When You Re-Upload a YouTube Video 1000 Times! (https://www.youtube.com/watch?v=JR4KHfqw-oE)
- Have we gone MAD?? (12k video - https://www.youtube.com/watch?v=pocfGBQZUSI)
- Do TVs Suck As Monitors? (https://www.youtube.com/watch?v=Jcd07Fndqus)


## SCRIPT

Olá pessoal, Fabio Akita

Desde que abri o canal, uma das perguntas mais frequentes, tipo que eu recebo no mínimo uma vez por semana é sobre quais cursos eu recomendo pra quem tá começando. E como eu já disse em vários videos: eu não recomendo nenhum, e na prática tanto faz qual. Nenhum curso vai ser completo, eles servem só pra ter dar um empurrão, mas nunca vão te ensinar tudo de qualquer assunto. A segunda pergunta que mais recebo complementa a primeira que é quais livros eu recomendo.






Muito do que você não vai aprender via cursos ou tutoriais está em livros. E não ache que dá pra pegar essa lista e sair lendo tudo de uma vez. Boa parte deles você vai lendo aos poucos ao longo dos seus primeiros 10 anos de carreira, porque você ainda não tem nem o conhecimento e nem a experiência pra entender de fato o que estão tentando te dizer.






Hoje vou listar alguns livros que eu pessoalmente acho importantes. Não é uma lista nem completa e nem definitiva, são livros que eu fui usando ao longo dos anos e que acho que podem te ajudar. E vou apresentar mais ou menos na ordem que conheci eles, cronologicamente, porque faz diferença quando eles foram lançados e em qual contexto. Prestem atenção ao contexto que vou falar mais do que na lista em si.


(...)




Vamos lá. Nenhum livro é obrigatório. Então não saiam por aí dizendo pros outros que o Akita falou então é pra ler. Os livros que vou falar hoje eu não li tudo de uma vez só, muitos nem li inteiro, e vim acumulando ao longo dos primeiros 10 a 15 anos da minha carreira, durante e depois da faculdade. 








Ninguém vai conseguir ler e principalmente entender esses livros numa só leitura. Isso não é literatura, são livros de aprendizado e referência. Alguns temas dentro desses livros você só vai entender de verdade depois que passar por projetos reais e só daí vai vir o "ahhhh, era isso que o livro queria dizer", aquele momento "ahá". 








Isso dito, se você assiste meu canal já deve imaginar que minha primeira recomendação é o livro do Cormen de Introdução a Algoritmos. Eu tenho esta terceira edição, não sei se tem mais novo, mas não importa. O maior problema de começar estudando e usando frameworks e bibliotecas pré-prontas é que elas evitam que você precise saber como são feitos, porque já vem tudo pré-pronto e escondido pra só usar.







Eu falei disso em videos anteriores e até mostrei, mas se usa uma lista ou collection em Javascript, você não tem idéia se por baixo tá implementado uma lista ligada, ou uma árvore Red Black ou o que. Você só adiciona elementos, remove elementos, manda ordenar e pára por aí. E isso vale pra qualquer outra coisa funcionalidade. Você usa uma biblioteca de caching do seu framework favorito, mas como é implementado? É uma fila simples? É uma fila circular? É uma árvore B-Tree? Que tipo de hashing ele usa? Pra você tanto faz, você só empilha e desempilha elementos e deixa o framework cuidar de tudo pra você.








Então toda vez que usa listas, manipula strings, usa threads ou fibers, caching e tudo mais, só confia que o framework sabe o que tá fazendo e não se preocupa. E isso é ok pra 80% dos casos, por isso que muito iniciante consegue ir até longe em alguns projetos sem nunca ter lido um único livro sobre algoritmos e estruturas de dados. Esse é o nível de um junior. Porém um sênior precisa lidar com problemas diferentes. 








Otimização de performance, otimização de carga, reorganização e refatoração do código pra ser ao mesmo tempo mais fácil de dar manutenção e também mais performático, diminuir tempo de latência, diminuir uso de memória por requisição, resolver conflitos de versões de bibliotecas externas, fechar buracos de segurança e mais. E pra isso, você precisa saber como essas bibliotecas e frameworks funcionam por baixo, e pra isso, precisa da fundação, que começa em algoritmos e estruturas de dados.







Um livro como do Cormen não é completo. Ele fala de bastante coisa que você deveria saber, mas nenhum livro nunca vai ter tudo. E antes que vocês perguntem nos comentários ou fiquem me mandando DMs, não, não precisa ser o livro do Cormen. Eu mesmo não usei ele na faculdade. Eu aprendi o básico com um muito mais simples, este do Niklaus Wirth. Olha como é menor.







Diferente do Cormen, o livro do Wirth sequer entra no assunto de grafos, por exemplo. Além disso o Wirth escreveu o livro dele em 1986, já o Cormen e seus co-autores escreveram o deles em 2009. Por isso, no livro mais novo tem assuntos mais modernos, como multithreading, que ainda era um assunto que engatinhava nos anos 80.







Se você acha que precisa ter o livro mais completo de todos, ele não existe mas o mais próximo não é um livro, mas uma coleção de livros, do lendário Donald Knuth, o famoso The Art of Computer Programming, o magnum opus da ciência da computação que ele começou a escrever em 1962 e até hoje não terminou. Eu já falei dele em outro video mas os livros que eu tenho são do 1 ao 3 mais o 4A. Segundo a Wikipedia ele tá escrevendo os fascículos 5 e 6 que são os primeiros dois terços do volume 4B.







E quanto ainda falta pra acabar? Bom, depois do 4B ainda vai ter os volumes 4C e 4D e depois os volumes 5, 6 e 7. Ou seja, o que eu tenho aqui ainda não é nem metade do que seria a obra completa. Essa coleção é o Game of Thrones da computação, e o Knuth é o George R R Martin da nossa área. Todos cruzando os dedos pra ele conseguir terminar tudo. Os livros do Wirth e do Cormen eu diria que são um resumão do que seria os livros de 1 a 4D do Knuth.







Ou seja, os temas dos primeiros 7 volumes do Knuth, que incluem os volumes 4B a 4D que ele ainda não escreveu são o que você encontra no sillabus dos primeiros anos de um curso de ciência da computação. Começa com coisas como matemática básica, números, potências, logaritmos, teoria dos números, permutações, fatoriais, coeficientes binomiais, ou seja, não só o assunto de algoritmos mas temas de matemática que você aprende nos primeiros 2 anos de ciências da computação em matérias como Álgebra, Estatística e probabilidade.







No primeiro volume do Knuth você tem coisas básicas como pilhas, filas, listas ligadas, listas circulares, arrays, árvores binárias, que foram assuntos que eu detalhei alguns videos atrás. Por isso o primeiro volume se chama Algoritmos Fundamentais. Já o segundo volume complica um pouco mais. Ele se chama Algoritmos Seminuméricos e logo de cara o primeiro assunto no livro é definir números aleatórios. 






Fazendo uma tangente, números aleatórios gerados por computador não são puramente aleatórios, são pseudo-aleatórios. Em qualquer linguagem moderna de programação você só usa uma função como Random e esquece, mas nesse livro você pode estudar como isso funciona. E nos capítulos seguintes ele vai discorrer sobre sistemas posicionais de números como aritmética de ponto flutuante, que foi outro assunto que já expliquei alguns videos atrás. E continua em assuntos como aritmética racional, aritmética polinomial. 







E sim, essa coleção inteira é bem pesada em notação matemática. Se você não tá acostumado é absolutamente intimidador. Entendida toda a base matemática fundamental, só no volume 3, que é chamado de Ordenação e Procuram, é que vamos finalmente encontrar os algoritmos de ordenação como inserção, seleção e procura com temas como pesquisa binária e árvores balanceadas que eu também já mostrei alguns videos atrás. 







Finalmente chegamos ao volume 4A que é chamado de Algoritmos de Combinatória Parte 1 que explica o básico de álgebra booleana, truques e técnicas de operações bitwise, diagramas de decisão binária e geração de todas as possibilidades onde entramos no assunto de n-tuplas, permutações, combinações, partições, conjuntos e muito mais. E isso é parte 1 porque o tema de Algoritmos de Combinatória vai se esticar nos próximos volumes ainda não escritos, do 4B ao 4D.







Só esses 4 volumes somam quase 3 mil páginas. Pra colocar em perspectiva, o livro do Cormen é menos da metade disso. Mas se prestou atenção vai notar que os livros do Knuth cobrem mais assuntos, em particular a base matemática. Livros mais focados só em algoritmos e estruturas de dados, como do Cormen, se preocupam menos com as provas matemáticas e mais em como cada elemento é implementado e funciona. Eu diria que é mais prático pra gente. Você só vai realmente ler página a página do Knuth se for se especializar em matemática aplicada ou algo assim. 







Mas pra assuntos específicos, vale como referência se quiser descer a fundo. Por exemplo, como realmente números aleatórios são matematicamente definidos? Eu repito, a grande maioria de nós não tem o vocabulário de matemática teórica suficiente pra realmente conseguir absorver tudo do Knuth, por isso qualquer coisa perto do livro do Cormen é mais prático. Mesmo o Cormen é um pouco pesado em matemática, então qualquer livro de algoritmos e estruturas de dados é suficiente.







Mas e os livros de 5 a 7 que o Knuth ainda não escreveu? Os títulos parecem que vão ser Algoritmos Sintáticos, teoria de linguagens livres de contexto e técnicas de compiladores. Linguagens livres de contexto você vai cair no trabalho mais importante do Noam Chomsky - e na minha opinião, a única coisa que você precisa ler dele. Enfim, na realidade já existem livros que cobrem esses assuntos. Se você fez ciência da computação já sabe. Essa é minha segunda recomendação: o famoso livro do dragão, o Compiladores - Princípios, Técnicas e Ferramentas, do Aho, Ullman e outros, publicado em 1986.







Eu já falei em outros episódios sobre compiladores como GCC, e principalmente sobre uma das tecnologias mais importantes deste século: o LLVM, que se você pelo menos acompanha artigos técnicos, já ouviu falar diversas vezes. Eu explico sobre LLVM no episódio sobre a Apple e recomendo que assistam pra entender o contexto, mas é graças a LLVM que você tem linguagens como Swift, Rust, Crystal, Julia, linguagens de shaders pra GPU e muito mais. E pra entender LLVM você precisa entender compiladores e realmente como linguagens de programação são criadas.








Na prática, a menos que você pretenda criar sua própria linguagem do zero, não precisa saber o livro do Dragão de cabo a rabo. É mais pra entender os principais conceitos. Esse livro vai te explicar o que é análise léxica e ferramentas como Lex e você mesmo vai descobrir outras como o GNU Flex depois. Daí vai pular pra análise sintática e ferramentas como o Yacc e outros como o GNU Bison. O livro usa os antigos Lex e Yacc, na minha época da faculdade no meio dos anos 90 era Flex e Bison, mas hoje em dia existem ferramentas mais modernas.








Isso é só pra desenhar a linguagem e criar um parser, mas a partir daí tem que fazer a geração do código binário propriamente dito que passa por um código intermediário, otimizações independentes de máquina, paralelismo em nível de instrução, localidade, análise interprocedural. Se você me perguntar se eu ainda sei essas coisas, não, não lembro nem uma fração mais hoje. Mas os conceitos que guardei me ajudam a avaliar toda vez que uma nova linguagem aparece, eu consigo entender como funciona, o que procurar na linguagem, no compilador, no código final gerado e tudo mais.







Compiladores é um tema que você não deveria tentar aprender tudo de uma só vez. Compensa até começar com algum livro mais simples, curso online ou até um tutorial com ferramentas de mais alto nível que te permitem criar linguagens simples que não necessariamente vão ser performáticas, mas vão ajudar a "molhar os dedos" no assunto antes de aprofundar nos detalhes que tem no livro do dragão.






De qualquer forma, só faz sentido ter a ambição de escrever a própria linguagem se você estudou um pouco mais a fundo sobre linguagens. E não só "ah, eu gosto de parênteses" ou "ah, eu prefiro não ter ponto e vírgula no fim das linhas". Design de linguagem é muito mais que isso. Um livro que talvez ajude a entender as features de uma linguagem é o The Design and Evolution of C++, do Bjarne Stroustrup que é o pai do C++. 







Ele conta um pouco a história de como o Stroustrup se inspirou em C with Classes pra chegar ao C++ e justifica as funcionalidades que criou em cima disso como o gerenciamento de memória, herança múltipla, casting, templates, exceptions, namespaces e tudo mais que forma a base do C++ e depois serviu de inspiração pra implementar muitas das linguagens modernas que você usa como um Java ou C#.







Entender o pulo do C pro C++ pela visão do autor é interessante e também as primeiras interpretações sobre o que é orientação a objetos. C++ é uma linguagem que eu mesmo nunca usei muito profissionalmente, então eu mesmo sou amador, mas acho fascinante entender como se encaixa na história das linguagens de programação. Ela ainda é uma das linguagens mais usadas pra código de sistemas, tudo de mais importante que você usa é escrito com C e C++, seu Javascript é escrito em C++. E isso não vai mudar por um bom tempo ainda.






Daí pulamos um pouco do tema de ciências da computação e vamos um pouco pra engenharia de software. Eu já expliquei a diferença em outro video, mas aproveitando o gancho da orientação a objetos do C++ vale pelo menos mencionar outro livro, o Object Oriented Analysis and Design with Applications do Booch e outros autores.







Orientação a objetos é um tema super longo, bem mais complexo do que você aprende na faculdade e eu não vou detalhar tudo hoje. Dependendo da era que estudar você vai ter interpretações diferentes de muitos conceitos, mas o que muita gente chama de orientação a objetos deriva do vocabulário criado pelo Grady Booch, Ivar Jacobson e Jim Rumbaugh. Cada um deles tinha uma versão de definição de orientação a objetos e eles se juntaram pra compilar seus trabalhos numa obra só. O que se publicou dos anos 90 em diante deriva disso.







Esse livro em particular não é a obra definitiva nem nada disso, mas eu acho interessante que ele tenta justamente definir muito desse vocabulário, definir o que exatamente é uma classe, o que é um objeto, qual é a notação que se deveria usar pra comunicar um modelo de objetos. Algumas partes, em particular a seção 3 do livro que pode estar um pouco defasado porque ele tenta explicar esses conceitos usando exemplos de cinco aplicações que vão de um sistema de navegação de satélite até um sistema de rastreio de férias via web, definido com essa notação de objetos.







Eu digo defasado porque a forma como desenvolvemos aplicações e até a forma como modelamos classes e objetos mudou daquela época até hoje então alguma coisa ficou obsoleta mesmo, não tem jeito, mas muitos dos conceitos ainda valem hoje e principalmente o raciocínio e história por trás de porque eles definiram as coisas daquele jeito. Esse livro em particular vale mais pra capturar um momento da história do que pra ensinar todas as técnicas que você precisa saber.






Esse livro, na real, é opcional e complementar a outro livro mais conhecido que é o The Unified Software Development Process escrito pelos mesmos Los 3 Hermanos, o Jacobson, Booch e Rumbaugh. Ele define a famosa e famigerada notação UML mas, mais importante, define o processo de desenvolvimento de software conhecido como Unified Process ou até hoje o que você conhece como Rational Unified Process ou RUP.






Lembrando, esses livros foram escritos antes de 2001, nos anos 90, portanto antes do Manifesto Ágil, antes de cloud computing, antes de smartphones, antes ainda da primeira bolha da internet, literalmente na infância da Web. Então tudo que você conhece como formas modernas de desenvolvimento de software, que só nasceram nos últimos 20 anos, ainda não existiam nessa época. Mesmo assim, eu ainda acho que vale a pena ler o começo desse livro, porque muitos dos conceitos de engenharia de software que você usa são derivados dessa época.







Em particular, eu já falei em outros episódios que pra mim um bom exemplo de linguagem orientada a objetos, por incrível que pareça é o Erlang, em particular o Elixir. Muita gente pensa em Elixir como uma linguagem funcional, mas pra mim é o contrário. Ele é primeiro uma linguagem orientada a objetos que por acaso tem aspectos funcionais. Eu argumentaria que Elixir e Erlang são mais orientados a objetos do que Java, que muita gente ainda pensa como a referência em objetos. Se você não entendeu isso, ainda precisa estudar mais.








Um dos argumentos sobre Erlang é que logo no prefácio desse livro, eles contam sobre o case da Ericsson, que é a inspiração do Unified Process. Se você não sabe, o “ER” de Erlang é de Ericsson. Os autores argumentam que o sistema de telecomunicações deles era tão bom porque modelaram o sistema inteiro como um conjunto de blocos interconectados, o que em UML se chamaria de componentes ou sub-sistemas. E eles foram montando blocos de baixo nível e subindo pra sub-sistemas de alto nível pra tornar o sistema mais fácil de gerenciar e foram encontrando esses blocos trabalhando pelos casos de tráfego anteriores - o que hoje se chamaria em UML de "casos de uso".







O caso da Ericsson é relevante pro assunto de orientação a objetos porque quem trabalhou lá foi justamente um dos co-autores desse livro, o Jacobson, que saiu em 1987 e fundou a empresa Objectory e nos anos seguintes ele e alguns colaboradores desenvolveram um processo chamado Objectory também pra servir pra mais casos além de telecomunicações, e foi aí que coisas como "casos de uso" ganharam esse nome.







Alguns anos depois, em 1995 a empresa Rational Software Corporation comprou a Objectory e eles trabalharam em juntar os dois processos que tinham e chegaram primeiro no Rational Objectory Process. Depois disso que o Booch, Rumbaugh e Jacobson colaboraram pra criar o Unified Modeling Language, o UML, pra ter uma linguagem visual pra comunicar as idéias sobre objetos e finalmente chegaram no Unified Process ou Rational Unified Process, que é o RUP, que muitos que fizeram engenharia de software devem ter estudado.







Em 2021 raramente você vai ver alguma empresa usando fortemente UML e RUP em projetos. Pelo menos eu espero que não. Talvez em empresas antiquadas e altamente burocráticas, mas em tech startups é bem raro encontrar. Mas muito do vocabulário e notações que usamos até em rascunhos numa lousa são derivados do UML. Muito da engenharia de software moderna ainda usa os nomes originais, como "casos de uso" por exemplo, ou diagrama de componentes. O que eles chamavam de sub-sistemas você poderia chamar hoje de micro-serviços e assim vai. 






Se quiser aprender esse vocabulário sem perder muito tempo no detalhamento do processo em si, que ninguém mais usa como antigamente, você pode pular direto pra outro livro bem menor, de menos de 200 páginas, chamado UML Distilled do Martin Fowler, que é basicamente um resumão de UML e RUP. Ele tem só o que o Fowler acha que é mais relevante alguém saber, é quase um cheat sheet sobre UML.






Levou alguns anos, até demais na minha opinião, pras pessoas entenderem que seguir algo como um RUP ao pé da letra era absolutamente burocrático e improdutivo. A gente tava mais preocupado em rastrear, gerenciar e aprovar artefatos, como diagramas, do que com o código em si. É uma das grandes críticas em relação ao campo da orientação a objetos em geral.






Falando em Martin Fowler, ele foi um dos escritores mais prolixos e influentes do fim dos anos 90 até pelo menos o meio dos anos 2000 e um dos seus livros mais importantes parece uma reação contra o que um RUP representa. Esse livro obviamente é o Refactoring, publicado em 1999. E hoje em dia todo mundo fala em refatorar, refatorar, mas quantos de vocês conseguem definir o que é refatorar? Qual a diferença entre refatorar e reescrever?






Nas palavras do próprio Fowler, refatorar é o processo de mudar um software de tal maneira que isso não altere o comportamento externo do código e mesmo assim melhore a estrutura interna. É uma forma "disciplinada" de limpar código que minimiza as chances de introduzir bugs. Em essência, quando você refatora, está melhorando o design do código depois que ele foi escrito. Muita gente falando “refatoração” na verdade está querendo dizer “reescrever”, que não é um processo disciplinado de melhoria sem mudar comportamento, é literalmente jogar fora e escrever de novo de outro jeito, com outro comportamento, e não garante nenhuma melhoria.






E não é à toa que o Martin, junto com outros autores como Kent Beck, são signatários do Manifesto Ágil. Em metodologias antigas de engenharia de software, onde o RUP se inclui, a ideia principal é primeiro criar o design inteiro do software, por exemplo desenhando com diagramas com UML. E só depois que o design estiver perfeito que se começa a escrever o código. Ou até mesmo daria pra gerar automaticamente esse código a partir dos diagramas. Eles consideram design e codificação como duas etapas separadas. Mesmo tendo coisas como iteração no processo, as etapas em si ainda são conceitualmente separadas. Muitas empresas tentaram criar ferramentas que partiam dos diagramas de classes e tudo mais de UML e geravam código em Java da vida.








Essa ideia nunca funcionou direito e a gente foi entendendo melhor porque depois da virada do século, depois que começamos a ideia de agilidade. A premissa errada é achar que é possível criar um design perfeito em papel primeiro e depois o código seria só um reflexo direto desse design. Na realidade o código "é" o design e ele nunca vai estar perfeito, muito menos na primeira vez. Daí vem a ideia de fazer o primeiro código que funciona primeiro, que provavelmente vai ser um código ruim, e só depois, disciplinadamente, refatorar esse código até termos uma estrutura que seja livre de bugs e de mais fácil manutenção.






Aliás, vale aproveitar pra dizer que muita gente pensa que primeiro nasceu o Manifesto Ágil em 2001 e só depois começamos a entender o que são técnicas ágeis, mas é o contrário. Primeiro os signatários do manifesto passaram anos praticando, formulando as técnicas e documentando, durante os anos 80 e 90 principalmente, e só depois que isso deu origem ao Manifesto. Essa ordem é importante, porque o Manifesto é só um resuminho de 20 anos de experiência de cada um deles que veio antes.






Na indústria mais tradicional, por décadas sempre se tentou o conceito de design primeiro e código depois. Lá atrás a gente desenhava software com fluxogramas em linguagens procedurais, por exemplo. E isso fazia sentido porque debugar software depois era custoso, difícil, tedioso. As linguagens antigas eram fortran, cobol, algol, Ada ou C. Nenhum programador nos anos 70 e antes tinha um notebook multi-core com gigabytes de RAM. Não, eles tinham que compartilhar um único computador grande com vários outros engenheiros e programar a partir de terminais remotos.







Esses terminais eram lentos, ninguém tinha um VS Code ou Sublime Text da vida. O editor VI original foi criado justamente pra ser super otimizado pra desenhar o mínimo possível na tela e permitir navegar no código com o mínimo de comandos. Porque cada comando navegava numa rede lenta até um computador compartilhado lento que tinha no máximo kilobytes de RAM. Portanto, você gostaria que o código funcionasse de primeira, não era produtivo ficar debugando e "refatorando" o código depois. 







O que aconteceu nos anos 90 até os 2000 é que microcomputadores apareceram e ficaram consideravelmente potentes, internet e rede mais veloz apareceu, e agora era factível você rodar um sistema inteiro no seu computador pessoal antes de rodar no servidor da empresa. Fazer o design antecipadamente era crucial nas décadas de 60 a 80, mas depois disso a tecnologia avançou o suficiente pra gente conseguir fazer código ruim primeiro e refatorar depois pra ter código bom, então o design e o código passaram a ser um processo orgânico de melhoria contínua. Isso é uma interpretação minha, mas eu diria que “Agile” marca quando separávamos design e código em etapas distintas pra serem unidos em design emergente.







Falando em processos ágeis, se tiver só um livro que você queira ler, que seja o Extreme Programming Explained, do Kent Beck, também de 1999. Veja que em 1999 e 2000 que começou a aparecer mais livros sobre esse novo jeito de programar que vinha sendo praticado fazia mais de 10 anos, que culminaria com o manifesto ágil em 2001 e muito do que você considera técnicas de engenharia de software modernas como pair programming, test driven development, continuous integration, refactoring, small releases, nascem nele. 







Engenharia de software é um campo em constante mudança. Dependendo de que ano é a literatura que você está estudando, vai cair nos RUP da vida ou vai cair em derivados de Extreme Programming. A ideia não é dizer que os conceitos dos anos 90 estavam errados. Eles faziam sentido pras circunstâncias da época e vale a pena entender porque. 






Vocês podem ver que alguns livros e temas envelhecem melhor que outros. Uma coisa que me ocorreu gravando esse video é que se você prestou atenção, note que livros de ciência da computação tendem a envelhecer melhor que livros de engenharia de software. Livros de ciência da computação de 30 anos atrás ainda se aproveitam hoje, mas livros de engenharia de software de 30 anos atrás, estão obsoletos. 






Até hoje ainda não temos "o" melhor jeito de escrever software, estamos constantemente mudando os processos de como transformar idéias em código. Mas as peças fundamentais que usamos pra construir essas idéias ainda continuam válidas. Na ciência da computação o conhecimento meio que vai se estendendo mas não jogando muita coisa fora pelo caminho.






Uma parte disso é porque as teorias matemáticas que embasam coisas como algoritmos, uma vez provadas, variam muito pouco na implementação. É o trabalho de caras como Knuth. Uma árvore balanceada, seja feita em C ou seja em Kotlin, continua sendo uma árvore balanceada. Linguagens diferentes mas as características continuam as mesmas. É um dos motivos de porque linguagens funcionais ganharam algum destaque nos últimos anos. Muitos tentam trazer esse rigor matemático, como de lambda calculus, pros processos de como escrever código. Mas escrever código não é uma ciência exata, é um processo aberto à interpretação.







O problema é que código não é só rápido, ou seguro. Em engenharia a gente tenta buscar várias características como mantenabilidade, flexibilidade, portabilidade, reusabilidade, legibilidade, testabilidade, segurança e assim por diante. Você pode escrever o código mais seguro possível, mas vai prejudicar a flexibilidade e reusabilidade, e assim por diante. O desafio de um programador é balancear essas características, e isso é difícil porque depende de quais problemas você precisa realmente resolver com esse código. E pior, os requerimentos desse código mudam conforme o software é usado. 






Num primeiro momento a prioridade pode ser eficiência, mas depois de um tempo a prioridade passa a ser segurança, depois passa a ser mantenabilidade. Então o código precisa ser modificado ao longo do tempo, o design desse código vai mudando conforme as necessidades vão mudando. Por isso, nenhum código está 100% pronto e congelado pra sempre. E repetindo, por isso é quase impossível fazer um design perfeito antes do código.








Muito amador ainda acha que código, se rodar, tá ótimo, não importa se tá sujo, com nomenclaturas toscas, com alta complexidade. "Ah, roda, então foda-se". Código que roda, mas é sujo, com baixa mantenabilidade, é lixo, pode jogar fora. Não adianta nada rodar se amanhã você precisar estender, consertar, reusar. Daí mais atrapalha que ajuda. É lixo. Não basta rodar,  precisa estar limpo o suficiente pra quando outro programador for reusar, não vai sofrer.







Se você quiser um livro mais estruturado com a melhor forma de escrever código e como se comportar como um bom profissional, o melhor livro pra começar é de outro agilista, o controverso Robert Martin, vulgo Uncle Bob. Ele é outro escritor prolixo e seu livro mais conhecido é sem dúvida o Clean Code, ou Código Limpo. E o conteúdo é parecido com o Code Complete do McConnell mas bem mais atual. 







Ele toca em coisas tipo, como criar nomes de variáveis, funções que sejam fáceis de entender. E segue falando de todas as boas práticas que deveriam ser óbvios pra todo profissional: escrever funções com corpo curto, código bem formatado e legível, como escrever código que lida com exceções, como criar fronteiras claras entre diferentes módulos, como fazer testes unitários, um pouco sobre organização de classes em linguagens orientadas a objetos, noções de design emergente, ou seja, design que emerge à medida que você escreve código, testa e refatora. 







Eu diria que se você quer ser um bom profissional, no mínimo tem que escrever código limpo como o Bob Martin ensina E falando em profissionalismo, um livro mais recente dele que lida com temas mais sobre como trabalhar em equipe, como gerenciar tempo, como fazer estimativas e coisas assim é o Clean Coder, ou Programador Limpo. Esse eu mesmo não cheguei a ler, mas pelo pouco que vi, acho que pode ser útil pra quem tá começando na profissão e ainda não sabe exatamente quais são suas responsabilidades perante seus colegas e projetos.








Outro livro com tema similar é um grande clássico que fez 20 anos recentemente, escrito por outros dois agilistas, Dave Thomas e Andy Hunt, o famoso The Pragmatic Programmer. Se o Clean Code e o Clean Coder do Bob Martin são meio que um manifesto do profissional de código, o The Pragmatic Programmer é uma mistura dos dois e tenta explicar a filosofia de um programador pragmático. Eles discorrem sobre como lidar com resolução de problemas de software, tocam em assuntos de agilidade de novo como testes, como escrever código limpo.








Se você assistiu meu episódio intitulado Esqueça Metodologias Ágeis, já sabe que estamos numa era pós-Agile. Os conceitos e técnicas originais de agilidade são simples, mas diversas empresas e consultorias sequestraram o termo "ágil" e inventaram um monte de metodologias e ferramentas burocráticas que nos levaram de volta à época do RUP e UML. 






Se você quer saber o que é realmente ser Ágil, deve ler os autores originais e não trabalhos derivados. Em particular Martin Fowler, Kent Beck, Bob Martin, Dave Thomas e Andy Hunt, que são todos os livros que eu recomendei até agora. Leia os livros deles e você vai estar meio caminho andado pra conseguir distinguir ágil de verdade das bullshitagens de coach de consultoria ágil por aí.







Muitos já me pediram pra falar sobre alguns desses temas, como testes. Ainda não sei se vou fazer um video disso porque é um tema tão bem documentado já que você só não aprende se fizer esforço pra ignorar. E repetindo: leia sobre assuntos de agilidade a partir dos autores originais. Quer saber sobre testes? Comece com Kent Beck e seus livros de Extreme Programming, não tem que inventar moda. 








Tem três outros livros que vale mencionar. Uma coisa que vocês só vão realmente entender lendo e escrevendo muito código de verdade é sobre a diferença entre design e código e como design emerge a partir do código e de seu uso, como eu já disse. Num primeiro momento, se está começando os estudos, não pense que vai conseguir pré-planejar todos os aspectos de um software antes de escrever uma linha de código. Não vai. E os próximos livros podem confundir vocês nisso.







O primeiro é o clássico Design Patterns, escrito pelo Erich Gamma e sua gangue dos quatro. No tema de achar que dá pra planejar em detalhes antes de codificar, esse é o primeiro livro mal interpretado. Cansei de ver amador com esse livro embaixo do braço querendo pagar de arquiteto e falando bullshitagens como "vamos fazer esse módulo usando alguns decorators pra montar um adapter que vai sair de um factory que vai ser um singleton derivado de um command de um chain of responsability suportado por um observer". Bleh.








Eu já expliquei isso no fim do meu video sobre como aprendi inglês, mas vou repetir. A tradução do título desse livro em português é "Padrões de Design". Dá a impressão que esse livro tem todos os padrões, no sentido de as melhores peças, ou as peças definitivas, pra se fazer design de software. O problema é que a palavra "padrão" em português pode ser traduzida em 3 palavras diferentes em inglês, standard, default ou pattern.






Muita gente pensa que "padrão" é o standard. E standard é como você pensou mesmo: um padrão oficial, uma definição definitiva sobre alguma coisa. Mas estamos falando de "pattern", e pattern é só alguma coisa que se repete muito, independente se é boa ou ruim e definitivamente não é o "padrão definitivo". O livro de Design Patterns é um catálogo de patterns, de repetições que os autores viram muito em diversos projetos, e simplesmente deram um nome pra eles. Só isso, nada mais, nada menos.






Esse livro foi publicado em 1994, um ano antes de entrar na faculdade. E eu só fui conhecer ele alguns anos depois, lá por 1998. Nesse momento eu já tava programando faz alguns anos e quando vi o livro, em inglês, foi exatamente o que pensei. "Oras, o livro só dá nome pra coisa que já vi várias vezes". Por exemplo, quem mexia com emuladores naturalmente reconhecia o Design Pattern Adapter. Toda vez que troco a biblioteca opengl do game por um directx é meio que um Adapter.






Design Patterns é um catálogo, e não um manual de como fazer design. Se você já programou tempo suficiente, só vai descobrir que alguns trechos de código que já viu várias vezes por acaso tem nomes, como Singletons, ou Visitors. Esse livro é útil somente pra nos dar um vocabulário comum pra ficar mais fácil pra dois programadores comunicarem um conceito com um nome comum. E ele nem é o catálogo mais completo, existem diversos outros patterns que não estão nesse livro. Vide livros como Patterns of Enterprise Applications Architecture do próprio Martin Fowler.






Falando em arquitetura, outro livro que alguns podem usar errado pensando que é um manual de instruções é o Domain Driven Design do Eric Evans, publicado em 2003. Nas palavras do Martin Fowler, esse livro descreve uma forma de desenvolvimento de software centrado num modelo de domínio que tem um entendimento rico dos processos e regras desse domínio. Em resumo bem resumido, é mais um livro que orienta em como dar nome pras coisas e como organizar essas coisas.






Assim como Design Patterns, ele nos dá novos vocabulários pra descrever sistemas como Ubiquitous Language, Aggregates, Bounded Contexts e outras classificações, mas enxergando mais o big picture de um sistema em vez de só pequenos componentes. Bounded Contexts em particular é interessante porque descreve um pattern que aparece em muitos sistemas.






Por exemplo, imagine que você tem um sub-sistema que tem contexto de Vendas e outro sub-sistema com contexto de Suporte. No de vendas você tem entidades como Vendedor, Oportunidade. No de suporte tem entidades como ticket, defeitos. Mas no bound, na fronteira entre os dois sub-sistemas ele compartilham entidades como o usuário ou o produto.






Começa a ficar difícil de lidar com sistemas que crescem se num sub-sistema você chama usuário de cliente e no outro sub-sistema você chama de comprador, por exemplo. Parte da idéia de DDD é criar um linguagem ubíquita, comum entre desenvolvedores e usuários. Enfim, como eu disse antes, ele se preocupa muito com a arte de dar bons nomes pras coisas. Não é à toa que a gente brinca que uma das coisas mais difíceis da computação é dar nomes pras coisas.







O terceiro e último livro, por incrível que pareça acho que é a cola que une todos os livros de engenharia que falei até aqui. É o famigerado The Lean Startup, do Eric Ries, publicado em 2011. Foi exatamente quando começou a atual bolha de tech startups e esse livro apareceu na hora certa pra se tornar meio que a bíblia das novas tech startups. É um livro meio que de empreendedorismo, é superficial, e por causa disso muita gente interpreta do jeito errado. Próxima pessoa que falar que “validou” a idéia fazendo pesquisa com uma dúzia de pessoas, eu juro que eu chuto.







De qualquer forma, ele fala algumas coisas que são relevantes pra engenharia de software. Você pode estudar orientação a objetos, processos de desenvolvimento de software, metodologias ágeis, como fazer código limpo, como modelar sistemas com DDD, mas se você não entende o mínimo de negócios, seu software sempre vai ser ruim. Porque o melhor software é aquele que resolve problemas do mundo real, e não do mundo teórico.






Um conceito importante que o The Lean Startup ajudou a popularizar foi o de Minimum Viable Product ou MVP, ou simplesmente Protótipo. A ideia ultrapassada, vinda de processos monumentais como RUP da vida, é de tentar fazer o design do melhor software possível, o mais complicado, com mais opções, com maior número de funcionalidades possíveis. Eu não sei se alguém aqui já passou por isso, mas eu já tive que avaliar calhamaços, literalmente pilhas de quinhentas páginas de especificações e diagramas de UML. 







Nunca vi um design assim no papel que desse pra traduzir em software, sempre tinha um monte de buracos pelo caminho. É impossível desenhar 100% de um software antes de construir, é sempre mais prático começar com um design mínimo, construir, aprender com os erros e ir estendendo e refatorando, ou seja, fazendo o design emergir do software.







Casos que já vi várias vezes, seja a partir de um software legado já existente ou um MVP, povo sempre fica com a ideia de "agora sim, eu já sei como que o design de verdade deveria ser" e aí segue tentando desenhar a versão 2.0 "perfeita", e cai na armadilha do "Segundo Sistema" que nosso amigo Fred Brooks já avisou no livro The Mythical Man-Month, que eu já fiz um video inteiro a respeito meses atrás. Dêem uma olhada.







É muito difícil fazer uma lista com TODOS os livros que eu acho que todo mundo deveria ler. Acho que uma lista assim seria impossível. Dependendo da sua escolha de carreira ou mesmo dos seus gostos, alguns são mais interessantes que outros. Essa lista é a que pessoalmente acho que é relevante, embora incompleta, pra maioria. Minha recomendação é sempre ir atrás dos autores originais de um determinado tema, autores que têm mais de décadas de experiência em projetos reconhecidos. Evitar ao máximo derivativos que costumam simplificar demais ou até alterar o que o original dizia. 






Mas como eu disse antes, em particular livros de engenharia de software tendem a envelhecer mais rápido do que livros técnicos de ciências da computação. Mas ambos os temas são importantes pra qualquer programador. De qualquer forma, se ficaram com dúvidas mande nos comentários abaixo, se curtiram o video deixem um joinha, não deixem de assinar o canal e compartilhar com seus amigos. A gente se vê, até mais!


06:52 - o que vem depois hello world
09:50 - Apple GPL
