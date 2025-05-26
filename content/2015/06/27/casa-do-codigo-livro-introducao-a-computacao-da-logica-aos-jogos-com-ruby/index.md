---
title: "[Casa do Código] Livro: Introdução à Computação: Da Lógica aos jogos com Ruby"
date: '2015-06-27T11:23:00-03:00'
slug: casa-do-codigo-livro-introducao-a-computacao-da-logica-aos-jogos-com-ruby
tags:
- learning
- beginner
- book
draft: false
---

Estou um pouco atrasado com meu review mas antes tarde do que nunca. Alguns dias atrás a [Casa do Código lançou um novo livro](http://www.casadocodigo.com.br/products/livro-aprendendo-computacao-ruby) para iniciantes que querem começar no mundo da programação.

Hoje existem muitos tutoriais na Web para aprender todo tipo de truque de programação. Para muitos, programar se tornou um processo de:

1. pesquisar no Google, Stackoverflow ou outros fórums
2. copiar o trecho de código e colar no seu próprio código
3. lucrar

Isso é pouco, é muito pouco, é um enorme desserviço ao mercado de programação. Não há nada errado em copiar e colar trechos de código, até mesmo programadores realmente experientes fazem isso por conveniência muitas vezes. Mas é muito errado quando o programador faz isso sem ter consciência do que está realmente fazendo. E faça isso muitos anos, isso não o torna "experiente" em programação, meramente o torna uma máquina velha de copiar e colar.

Programação tem fundamentos, como qualquer profissão de prática. Derramar tinta na parede não o torna um pintor impressionista, apenas um péssimo pintor de paredes. Meramente copiar e colar código não o tornar um programador, apenas um digitador. Não há valor num profissional desse tipo, pois ele é imediatamente substituível.

Livros e tutoriais que ensinam os famosos "procedimentos" de baixar, instalar, digitar hello world e dizer que isso é o fundamental servem para quem já tem base de programação, para todos os outros não agrega em nada. 

Um livro como o que o [Guilherme Silveira](https://twitter.com/guilhermecaelum/status/605847398997311488) escreveu tem a audácia de fazer o que a grande maioria dos autores não tem coragem: dar um passo pra trás. Ensinar fundamentos não é nem de perto tão "glamuroso" como escrever um tutorial de uma nova biblioteca ou nova linguagem. Porém é o que a maioria esmagadora das pessoas que se auto-intitula "programadores" realmente precisa: conhecimento fundamental.

Esse tipo de conhecimento indepente da linguagem que está usando. Ela é universal. Mais do que isso, ela forma a linha de raciocínio sobre o qual você vai conseguir assimilar novos conhecimentos mais rápido e com mais eficácia, por isso é tão importante.

Livros desse tipo tendem a ser extremamente chatos por ser um conteúdo bastante teórico. A idéia do Guilherme para atingir esse objetivo sem ser chato foi escolher uma parte desse fundamento que é o mais essencial, criar exercícios que levam a pequenos jogos e com uma narrativa mais próxima aos tais tutoriais de Web que mencionei, conseguir explicar um conhecimento fundamental.

E como conhecimento fundamental, o que o livro do Guilherme oferece pode ser claramente entendido já pelo índice:

* Jogo da adivinhação, onde ele explica conceitos fundamentais como entrada e saída, funções, variáveis e atribuições. Os capitulos seguintes vão incrementar este jogo.

* Controle de Fluxo, onde entendemos como o computador toma decisões baseado no que ele sabe, o simples "if" e loops.

* Funções, algo que toda linguagem tem, uma forma de reusar pedaços de código em vez de copiar e colar sem consciência.

* Arrays, uma das estrutura de dados mais fundamentais da computação, saber o que é uma lista, ou o caso particular de Arrays, que são Strings. Poucos programadores amadores entendem porque eles são relacionado.

* Pontos e matemática, e novamente um dos pontos que a maioria aceita sem entender. Computadores foram feitos para lidar com números inteiros. Como ele realmente lida com números quebrados, ou com ponto flutuante?

* Binário. Hoje em dia a programação tem tantas abstrações que esquecemos que internamente o computador consegue entender apenas 0s e 1s. Todos falam em 32bits, 64bits, mas quase ninguém sabe o que isso significa. E isso leva a diversos programas ineficientes e abstrações mal feitas.

* Nível de dificuldade e o case. Este capítulo extende o anterior de "Controle de Fluxo" introduzindo mais algumas facilidades como "case" e "while".

* Arte Ascii, aqui o Guilherme resolve dar uma volta ao passado mostrando um pouco de como fazíamos "interfaces" para o usuário sem interfaces gráficas.

* Jogo da forca. Depois do Jogo da adivinhação agora começa o Jogo da Forca onde os próximos capítulos também vão incrementar este novo jogo. Aqui você vai começar a exercitar o que realmente significa "resolver um problema", como é pensar em "algoritmos" e não ser somente um "copy e paster".

* Responsabilidades. Ao falar de copy e pasters, aqui vamos começar a pensar em algo diferente que um programador amador raramente pensa: separação de responsabilidades, principalmente entre "interface do usuário" e "lógica de negócios". Um amador tende a misturar as duas coisas, um profissional deve aprender a separá-las.

* Entrada e saída de arquivo: palavras aleatórias e o top player. Neste capítulo vamos a outras maneiras de carregador dados que não seja apenas o que o usuário digitar, mas o que está em arquivos.

* Foge Foge, um jogo baseado no Pacman. Finalmente, chegamos ao terceiro jogo. Agora o Guilherme vai subir um pouco mais a dificuldade, usar tudo que foi ensinado até agora e fazer um jogo, que é bem simples na verdade, mas é um bom desafio para quem está começando a aprender. Aqui vamos ter que cuidar do estado dos personagens do jogo dentro de um mapa. Neste capítulo ele também vai introduzir conceitos importantes como "Refatoração" e outros específicos de linguagens dinâmicas como Ruby, como "duck typing".

* Botando os fantasmas para correr: arrays associativos, duck typing e outros. O capítulo anterior é bem extenso pois teve que lidar com o mapa, movimentos, colisão e este capítulo é uma extensão para adicionar os fantasmas e seu comportamento dentro do mapa. Muita atenção para não se perder até aqui.

* Matrizes e memória. Aqui temos mais um exercício avançado de pensamento em estruturas de dados, ao mapear o que seria o mapa do Foge Foge num "array de arrays" (ou matriz) e agora controlar o que existe em cada posição dessa matriz para guardar o estado do jogo a cada movimento. Um exercício importante que continua sendo um desafio até mesmo para alguns programadores considerados "experientes".

* Estruturas e classes: uma introdução a Orientação a Objetos. Para quem já teve aula na faculdade ou algo assim, este capítulo não vai voltar a velha teoria de explicar "encapsulamento, herança e polimorfismo", coisa que é bem antiquada já. O Guilherme vai direto ao ponto, pegar o jogo do Foge Foge, que até aqui foi feito de forma procedural e imperativa e criar abstrações sobre a mesma estrutura e lógica para demonstrar algumas maneiras de se fazer essa modelagem em objetos.

* Destruindo os fantasmas: o mundo da recursão. Outra técnica importante é recursão, uma forma de transitar por uma estrutura de dados como listas ou matrizes e processar cada elemento onde o processamento seguinte depende do anterior. É uma técnica muito poderosa e ao mesmo tempo uma das maneiras mais fáceis de atirar no próprio pé. Neste capítulo o Guilherme vai explicar como usar essa técnica de maneira segura.

No fim o Guilherme adiciona instruções para instalar o Ruby e algumas dicas de como continuar estudando para evoluir além do conteúdo do livro.

O livro é bem simples de seguir, a idéia de usar pequenos jogos que vão aumentando de dificuldade para explicar conceitos fundamentais torna o estudo muito mais interessante e se você estudar e seguir até o final pode ter certeza que vai estar melhor equipado para se tornar um programador melhor.

Continue estudando!
