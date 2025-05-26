---
title: "[Akitando] #15 - Sua Linguagem NÃO É Especial! (Parte 1)"
date: '2018-10-02T17:00:00-03:00'
slug: akitando-15-sua-linguagem-nao-e-especial-parte-1
tags:
- programação
- carreira
- computação
- algol
- fortran
- knuth
- pascal
- bash
- delphi
- backus
- BNF
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


<iframe width="560" height="315" src="https://www.youtube.com/embed/p9-WuJbVHHc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


### Descrição no YouTube

Depois da semana geek, vamos "geekar" um pouco na programação também.

Honestamente essa polarização em torno de linguagens de programação é super cansativa. A turma do funcional vs a turma dos objetos. A turma do javascript, a turma do Go. 

Enquanto isso, a grande maioria da população de programadores está aflita, sem saber pra onde correr. Quantas linguagens preciso aprender? 2? 6? 50???

Calma! Vamos começar a colocar ordem nessa bagunça. Hoje vou explicar como fazer isso e porque sua linguagem de programação favorita não é tão especial quanto você pensa!

Veja hoje a Parte 1 e não deixe de assinar o canal para ver a Parte 2!

## Script

Olá pessoal, Fabio Akita

Esta semana vamos pular pra assuntos de tecnologia. Mas eu quero colocar em prática o que eu disse semana passada nos episódios geek. Lembra como eu disse que nós geeks não só assistimos as coisas mas gostamos de ficar explorando detalhes, rotas alternativas e até re-editando o que gostamos?

Hoje eu vou mostrar como fazemos isso em tecnologia também. Muitos de vocês hoje devem ter linguagens de programação favoritas. Todo mundo tem pelo menos uma. Como muitos de vocês sabem, eu gosto muito da linguagem Ruby. Porém isso não me torna cego às demais linguagens e eu não digo isso só da boca pra fora.

Também como disse no episódio de faculdade, eu comecei no fim dos anos 80, passei por Basic, dBase III, Clipper, Turbo Pascal 6, Visual Basic 6, Delphi desde a versão 1.0, Perl desde a versão 5 - se bem que ela nunca saiu da 5, PHP desde a 3, ASP clássico, .NET C# e VB.NET desde a versão 1.0, Java desde a versão 1.0, Javascript desde antes de virar padrão ECMA, Python 2. E isso foi só até o fim dos anos 90.

Se tem uma coisa que vocês devem levar deste episódio é o seguinte: linguagens de programação Não são filosofias de vida. Linguagens de programação são meras ferramentas. Ferramentas foram feitas para servir seus mestres, e não o contrário. Linguagens de programação não merecem lealdade e definitivamente não são religiões. Eu não sou definido pela minha linguagem de programação favorita. 
Você não é sua linguagem de programação. 

(...)

(crack de dedos) É hora de mostrar aqui quem manda.

A melhor forma de desmistificar qualquer coisa é abrir e dissecar. Ver do que é feito. Ver quem fez. Ver de onde veio. Pare de colocar as coisas num pedestal só porque você não compreende. Nada merece ficar num pedestal, muito menos linguagens de programação.

Antes de mais nada, se eu te perguntar, quais todas as linguagens de programação que existem hoje? Você talvez tenha a seguinte imagem na cabeça (IMAGEM)

Mas a realidade é que esta é a lista de linguagens ATIVAS nesse momento.
Pois é, bem mais do que você imaginava. Existem linguagens em uso neste momento que você sequer ouviu falar. Você precisa expandir seus horizontes. E agora o mundo que já parecia grande parece impossível. Mas não se preocupe, vamos organizar isso.

Se você só conhece uma ou duas linguagens, ou mesmo meia dúzia, faz parecer que cada uma delas é genial e única. Faz parecer que nunca mais ninguém vai chegar numa combinação tão perfeita. Por exemplo, a orientação a protótipos de Javascript, os CSP de Go, o garbage collector do Java, o pattern matching do Elixir.

Vamos começar do começo. Muitos quando pensam em linguagens antigas pensam em Fortran ou Lisp, mas eu começaria por Speedcode ou Speedcoding do lendário John Backus. É uma das primeiras linguagens interpretadas de alto nível. Muita gente acha que COBOL é quem inaugurou a era das linguagens simbólicas que prezava pela facilidade de uso ao usar palavras em vez de mnemônicos como Assembly, como o próprio nome Speed code já diz. Estamos falando de 1953. O objetivo foi facilitar a computação numérica de ponto flutuante para calcular posições astronômicas, trocando facilidade de uso por performance.

O mesmo John Backus depois criaria a linguagem mais famosa dele e que ainda está em uso até hoje, o Formula Translator ou Fortran, de 1957. Agora você sabe que a idéia original veio de Speedcoding. Como disse antes Speedcoding era interpretado e embora com uma linguagem fácil de usar a performance era sofrível, até 20x pior que assembly de máquina e naquela época hardware era proibitivamente caro. Por isso pense em Fortran como uma evolução compilada de Speedcode. Embora uma linguagem de uso geral obviamente ele foi pensado como uma linguagem para cálculo númerico. Se você fez faculdade e aprendeu sobre montadores, aprendeu sobre assembly.

De bônus, muitos ainda pensam que Fortran gera binário mais rápido do que C. Isso foi verdade no começo. Depois do padrão C99 ter colocado o keyword restrict isso já não é mais verdade. A diferença é que Fortran não permite aliasing de pointers. Dois nomes apontando pro mesmo espaço de memória e fazendo overlap. Se você usar restrict em C o mesmo código vai gerar um binário igualmente rápido.

Seguindo a história, você tem o Algorithmic Language ou ALGOL que é uma família de linguagens imperativas. Como o nome diz foi usado para descrever algoritmos, uma evolução do Fortran em termo de linguagem de alto nível. Uma das coisas mais importantes da produção do ALGOL foi a invenção do Backus Normal Form por John Backus de novo que depois foi revisado e extendido por Peter Naur pro ALGOL 60 e renomeado como Backus-Naur Form ou BNF por sugestão do lendário Donald Knuth. BNF é uma técnica de notação para gramáticas livre de contexto usado para descrever e definir sintaxe de linguagens. Se você fez faculdade e aprendeu sobre compiladores então teve que lidar com o Yet Another Compiler-Compiler ou YACC que é padrão em BSD ou o GNU bison.

Se seguirmos para o começo dos anos 1960 encontramos o Combined Programming Language também chamado de Cambridge Programming Language por ter sido desenvolvido na universidade de Cambridge ou Christopher’s Programming Language por ter sido desenhado por Christopher Strachey junto com David Barron. Na prática uma linguagem inspirada em ALGOL 60. Mas a linguagem demorou muito pra ficar pronta, quis fazer muita coisa, ele queria ao mesmo tempo possibilitar programação de baixo nível e ter abstrações de alto nível. No final não foi pra lugar nenhum mas inspirou um derivado mais simples chamado BCPL ou Basic CPL ou também Boostrap CPL voltado mais pra programação de sistemas, particularmente pra escrever compiladores. 

A família de linguagens ALGOL daria origem a derivados em particular alguns que você não imaginaria. Niklaus Wirth e Tony Hoare propuseram o ALGOL W como sucessor do ALGOL 60. Esse trabalho inspiraria Wirth a criar uma nova linguagem desenhada pra ser eficiente em tempo de compilação e execução, fortemente tipada, que possibilitaria a criação de estruturas de dados complexas e seria boa para ensinar programação estruturada e algoritmos, e entre 68 e 69 nasce a linguagem Pascal. Sim, Pascal é um derivado direto de ALGOL. Eu aprendi algoritmos e estruturas de dados com esse livro de Wirth.

Dando uma tangente nessa história, nos anos 80 Anders Hejlsberg escreveu o compilador Blue Label Pascal. Depois de ser adquirido pela Borland isso se tornaria o Turbo Pascal, que eu mencionei em outro episódio que foi a linguagem que aprendi na faculdade. Turbo Pascal fez muito sucesso na época, era muito compacto, eficiente e ainda vinha com uma IDE. Muitos programas famosos do Macintosh original foram escritos num dialeto de Turbo Pascal. E da Apple Computer saiu a extensão Object Pascal. É parecido mas não é a mesma coisa que o Object Pascal da Borland que viria a se tornar o famoso Delphi.

Quem contratou Anders Hejlsberg foi a Microsoft e ele criou o Microsoft J++, o derivado de Java da Microsoft. Eu costumo dizer que o atual C# que foi desenhado pelo Anders é o filho bastardo de Delphi com J++.

Voltando ao ALGOL e ao BCPL, como você pode imaginar, é bem adequado que da linguagem ALGOL ou A, venha BCPL que na sequência coincidentemente deu origem à linguagem B por volta de 1969 desenhada pelos lendários Ken Thompson e Dennis Ritchie na Bell Labs. O BCPL, CPL, ALGOL tem cara de Pascal pelos motivos que falei acima, mas Thompson e Ritchie reverteram muita coisa da sintaxe. Por exemplo, em vez de atribuição ser dois pontos e igual passou a ser só igual, eles inventaram os operadores aritméticos de atribuição que é o mais igual ou menos igual além de incrementadores e decrementadores que são os operadores mais mais e menos menos. Enquanto Pascal virou um derivado de tipagem forte de Algol, o B foi feito pra ser sem tipo. Agora adicione a isso a sintaxe de chaves e você tem a próxima linguagem desenhada por Thompsom e Ritchie para suceder o B, a linguagem C.

Agora você sabe de onde veio C e como Pascal é seu primo e como Java e C# são netos bastardos e primos bastardos um do outro, é um verdadeiro bacanal de linguagens.

Mas isso não pára por aqui. Sabe quem mais trabalhou na evolução do ALGOL, o ALGOL 68? Um cara chamado Stephen Richard Bourne, que criou um troço chamado Bourne Shell pra substituir o Thompson Shell ou SH. A linguagem de script é inspirado em ALGOL 68. Falando em shells David Korn criou o Korn Shell ou KSH baseado no Bourne Shell e é um meio do caminho entre ele e o C Shell de Bill Joy - talvez vocês de Java lembrem dele da época da Sun Microsystems. Agora some Bourne Shell, C Shell e Korn Shell implementado no mundo GNU e você tem o Bourne Again Shell ou BASH! Agora você sabe de onde vem o BASH. E só pra finalizar essa tangente, se você pegar BASH, KSH e o TC Shell sai o mais moderno Z Shell que muitos preferem usar hoje. Se você vem de UNIX de verdade e sistemas BSD antigos deve ter encontrado o Bourne Shell original.


Ufa, essa história é bem longa. Mas depois dessa tangente em shells vamos parar por aqui. No próximo episódio eu vou finalizar essa história mas eu acho que você já entendeu onde eu quero chegar.

O mundo de programação é muito maior do que sua linguagem favorita. E linguagens não são estáticos. Elas não nasceram do nada por um criador místico. Todas são derivadas de alguma outra e sabendo de onde elas vieram você pode começar a entender pra onde elas vão evoluir no futuro. O que acharam desse episódio? Se gostaram deixem um joinha, assinem o canal e não deixem de clicar no sininho pra não perder a parte 2 dessa história. A gente se vê, até mais!
