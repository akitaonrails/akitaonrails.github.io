---
title: "[Off-Topic] O Programador Humilde, por Edsger W. Dijkstra"
date: '2010-04-12T08:49:00-03:00'
slug: off-topic-o-programador-humilde-por-edsger-w-dijkstra
translationKey: off-topic-o-programador-humilde-por-edsger-w-dijkstra
description: "Dijkstra defende humildade diante da dificuldade de programar: é melhor evitar bugs desde o início, usar abstrações e linguagens modestas, pois nenhuma ferramenta elimina a complexidade."
tags:
- engenharia-de-software
- linguagens-de-programacao
- off-topic
draft: false
---

[![](http://s3.amazonaws.com/akitaonrails/assets/2010/4/12/450px-Edsger_Wybe_Dijkstra_original.jpg)](https://www.cs.utexas.edu/~EWD/transcriptions/EWD03xx/EWD340.html)

Depois de escrever meu artigo na Info, [Fábrica de Software é uma Besteira](http://web.archive.org/web/20130723194737/http://info.abril.com.br:80/noticias/rede/gestao20/software/fabrica-de-software-e-uma-besteira/), recebi um retweet com um link muito bom para um texto que eu não conhecia: [The Humble Programmer](https://www.cs.utexas.edu/~EWD/transcriptions/EWD03xx/EWD340.html).

O autor é o grande [Edsger W. Dijkstra](https://en.wikipedia.org/wiki/Edsger_W._Dijkstra), conhecido principalmente pelo paper seminal [A Case against the GO TO Statement](https://www.cs.utexas.edu/~EWD/transcriptions/EWD02xx/EWD215.html). The Humble Programmer é o discurso que ele deu ao receber o prêmio Turing de 1972.

O texto é fantástico e vale a leitura na íntegra, mas separei alguns trechos para comentar. O mais interessante é ler com o contexto do fim dos anos 60 na cabeça e ver como muito do que ele esperava para o futuro é coisa que nós, quase quatro décadas depois, ainda estamos esperando. Não publiquei este texto na Info por dois motivos: primeiro porque é mais voltado a programadores, segundo porque é um dos meus textos "tamanho Akita" :-)


> Duas opiniões sobre programação vêm desses dias. Eu os menciono agora, devo retornar a eles depois. Uma opinião era que um programador competente deveria ter mente voltada a quebra-cabeças e gostar muito de truques espertos; a outra opinião é que programação era nada mais do que otimizar a eficiência do processo computacional, em uma direção ou outra.

Infelizmente, a imagem do programador mudou para dois extremos. De um lado temos os super-programadores, autores renomados. Do outro, a profissão em si virou commodity, um bem de consumo farto e barato, justamente pelo que comentei no artigo sobre fábricas de software.

Esse barateamento artificial da profissão leva a um sucateamento e a uma demora maior nas pesquisas e evoluções da área. A competição para baixar o preço quase sempre vem da globalização: levar a tarefa para regiões onde a mão de obra é mais barata, como a Índia e a China. Melhorar a qualidade técnica dos processos e das tecnologias fica em segundo plano.

Isso não quer dizer que todo mundo na profissão seja operário. Quem cresceu sozinho e evoluiu ocupa posições e tarefas respeitáveis, mas isso se deve mais ao esforço individual.

> Essa última opinião era o resultado da circunstância frequente que, de fato, o equipamento disponível era dolorosamente lento, e nessa época se encontrava a expectativa ingênua que, assim que máquinas mais poderosas estivessem disponíveis, programação não seria mais um problema, e então o esforço de ir até os limites da máquina não seriam mais necessários e programação era basicamente isso, não era? Mas nas décadas seguintes uma coisa completamente diferente aconteceu: máquinas mais poderosas ficaram disponíveis. Mas em vez de nos encontrarmos num estado de perfeita harmonia com todos os problemas de programação resolvidos, nos encontramos até o pescoço na **crise do software**! Como pode?

Pelo menos hoje ninguém assume que a programação vai ficar mais simples só porque as máquinas melhoram. Mas reparem numa coisa que sempre repito: muita gente acha que os problemas de software são recentes, quando o termo "crise do software" foi cunhado ainda na década de 70. E até hoje ela não foi resolvida.

> A visão é que, muito antes dos anos 70 terminarem, devemos ser capazes de desenhar e implementar os tipos de sistemas que agora estão forçando nossa habilidades de programação, ao custo de somente uma pequena porcentagem de homens-anos que nos custam agora, e que além disso, esses sistemas serão **virtualmente livre de bugs**. Essas duas melhorias andam de mãos dadas. Nessa última questão software parece ser diferente de muitos outros produtos, onde como regra uma alta qualidade implica em alto preço. Aqueles que quiserem software confiável descobrirão que devem encontrar meios de evitar a maioria dos bugs para começo de conversa, e como resultado o processo de programação se tornará mais barato. Se quiser programadores mais efetivos, descobrirão que eles não devem desperdiçar tempo debugando, eles não devem introduzir bugs para começo de conversa. Em outras palavras: ambos os objetivos apontam para a mesma mudança.

_"Programadores mais efetivos ... não devem desperdiçar tempo debugando"_. Essa conclusão já tem quase quatro décadas. Ainda assim, os programadores de hoje, treinados nas faculdades para atender a "fábrica" e virar operários de ferramentas, têm ataques de histeria quando o editor deles não traz recursos específicos de debug.

_"Aqueles que quiserem software confiável descobrirão que devem encontrar meios de evitar a maioria dos bugs."_ Ou seja, a eficiência está em impedir que o bug entre no código logo de início. Correr atrás dele depois, o mais rápido possível, é o jogo errado.

Sei que soa pedante, mas nós temos técnicas para isso, e a maioria dos programadores não as usa. Elas sequer são ensinadas na faculdade. Procure por [Extreme Programming](http://web.archive.org/web/20100314121601/http://www.improveit.com.br/xp/livroxp).

Para evitar que bugs entrem por descuido (evitar a maioria, já que zerar 100% é impossível), existem técnicas como [Testar Primeiro](http://www.extremeprogramming.org/rules/testfirst.html), [Programação em Par](http://www.extremeprogramming.org/rules/pair.html), [Integração Contínua](http://www.extremeprogramming.org/rules/dedicated.html), [Testes para evitar Bugs de Regressão](http://www.extremeprogramming.org/rules/bugs.html) e [Testes de Aceitação](http://www.extremeprogramming.org/rules/functionaltests.html). São métodos simples e eficientes, e boa parte do mercado nem sabe que existem.

> Agora para as necessidades econômicas. Atualmente se encontra a opinião que nos anos 60 programação era uma profissão muito cara, e que nos anos seguintes salários de programadores devem cair. Normalmente essa opinião é expressada conectada com a recessão, mas poderia ser um sintoma de algo diferente e até saudável, de que talvez os programadores de décadas passadas não fizeram um bom trabalho como deveriam. A sociedade não está satisfeita com a performance dos programadores e seus produtos. Mas há outro fator de maior peso. Na situação presente é normal que para um sistema específico, o preço a ser pago pelo desenvolvimento de software seja da mesma ordem de magnitude do preço do hardware necessário, e a sociedade mais ou menos aceita isso. Mas fabricantes de hardware nos dizem que na próxima década os preços de hardware devem cair por um fator de 10. Se o desenvolvimento de software continuar com os mesmos processos desajeitados e caros como agora, as coisas devem ficar completamente fora de balanço. Você não pode esperar que a sociedade aceite isso, e portanto devemos aprender a programar com eficiência uma ordem de magnitude maior. Para colocar de outra forma: enquanto as máquinas eram os ítens mais caros no orçamento, a profissão de programação conseguia livrar sua cara com suas técnicas desajeitadas, mas esse guarda-chuva vai se fechar rapidamente.

E esse tem sido nosso desafio nas últimas décadas: "baratear" a tarefa de programação. O problema é que dá para levar isso para o lado errado. Um caminho é baratear a mão de obra, e basta pegar países mais pobres, que cobram menos. Outro é baratear a tecnologia.

Esse segundo caminho funciona até um ponto de inflexão, quando precisaríamos de um novo degrau de sofisticação e não o temos, porque o próprio barateamento cortou as pesquisas e as inovações da área. O argumento todo gira em torno de _"como não encarecer o que já é caro hoje"_. Uma das saídas é avançar a tecnologia para automatizar tarefas manuais.

Até hoje ainda existem "programadores" que perdem tempo abrindo as mesmas janelas e clicando nos mesmos botões "next, next, next" toda vez que precisam empacotar uma nova versão do software. Isso é automatizável, mas como o cara foi treinado só para seguir procedimentos, a maioria não se acha capaz de transformar aquilo num script. É o caso em que o "barateamento" da mão de obra e da formação impede o barateamento dos processos e o avanço da tecnologia. Era um problema nos anos 70 e continua no século XXI.

> O argumento 3 é baseado na aproximação construtiva ao problema de programar corretamente. Hoje uma técnica comum é fazer um programa e depois testá-lo. Mas: teste de programa pode ser uma maneira muito efetiva de mostrar a presença de bugs, mas é totalmente inadequado para mostrar sua ausência. A única forma efetiva de aumentar o nível de confiança de um programa significativamente é dar uma prova convincente de sua correção. Mas então não se deve fazer o programa primeiro e depois provar sua correção, porque senão o requerimento de fornecer a prova somente aumentará a carga do pobre programador. Do contrário: o programador deve fazer a prova de correção e o programa crescerem de mãos dadas. O argumento 3 é essencialmente baseado na seguinte observação. Se primeiro nos perguntarmos qual é a estrutura que uma prova convincente deve ter, tendo encontrado isso, então construir um programa que satisfaz os requerimentos da prova, então essa preocupação de correção se torna um guia heurístico muito efetivo.

Preciso admitir que, aqui, o Dijkstra se refere a provas formais matemáticas. Mas eu gostaria de expandir o conceito. O que ele diz é que o certo seria primeiro criar uma "prova" e só depois implementar o código que atende aos requisitos dessa "prova".

Arrisco dizer que Dijkstra praticamente foi pioneiro do "Test First" de Extreme Programming, também conhecido como TDD, ou "Test Driven Development". O ciclo é simples: 1) escreva um teste que descreve o requisito; 2) rode o teste e veja-o falhar, já que o código ainda não existe; 3) implemente o mínimo para o teste passar; 4) parta para o próximo requisito. Dijkstra já sabia, há quase quatro décadas, que essa ordem de desenvolvimento é o que minimiza o volume de bugs lá na frente, além de dezenas de outros benefícios que descobrimos depois.

> O argumento 4 tem a vez com a maneira com que a quantidade de esforço intelectual necessário para desenhar um programa depende do tamanho do programa. Foi sugerido que existe algum tipo de lei da natureza nos dizendo que a quantidade de esforço intelectual necessário cresce com o quadrado do tamanho do programa. Mas, graças aos céus, ninguém conseguiu provar essa lei. E isso porque ela não precisa ser verdade. Todos sabemos que a única ferramenta mental que exige uma peça finita de raciocínio e pode cobrir diversos casos é chamada de "abstração"; como resultado a exploração efetiva de seus poderes de abstração devem ser consideras como uma das atividades mais vitais de um programador competente. Nesse sentido deve valer a pena apontar que o propósito de abstração não é ser vago, mas criar um novo nível semântico onde se pode ser absolutamente preciso. (...) Um resultado foi a identificação de vários padrões de abstração que tem um papel vital em todo o processo de composição dos programas. O suficiente já é conhecido sobre esses padrões de abstração para devotar uma aula sobre cada um deles.

Esse ponto é mais complexo e tem a ver com a capacidade de abstração do programador. O conceito em si é "abstrato" e difícil de definir. A primeira parte é talento: quem não tem talento para programação não vira programador, ponto final.

Partindo da premissa de que a centelha do talento existe, entram em cena as milhares de horas de prática. E eu falo de prática de código de verdade, experimentando as situações mais diferentes possíveis. Repetir procedimentos não conta.

Só assim a intuição emerge da experiência, e é ela que permite enxergar padrões no código, oportunidades de refatoração e otimização, construções de mais alto nível para simplificar o programa, e por aí vai. O caminho começa com o programador seguindo procedimentos, mas precisa evoluir rápido para a experimentação. Isso é fundamental.

Como curiosidade, parte do que ele descreve é o que hoje conhecemos também como "Design Patterns".

> Agora para o quinto argumento. Tem a ver com a influência da ferramenta que estamos tentando usar contra nossos hábitos de pensamento. Eu observo uma tradição cultural, que em todas as probabilidades tem suas raízes na Renascença, de ignorar essa influência, de tomar a mente humana como um mestre supremo e autônomo de seus artefatos. Mas se eu começar a analisar os hábitos de pensamentos meus e de meus colegas humanos, eu chego, quer eu queira ou não, a uma conclusão completamente diferente, que as ferramentas que estamos tentando usar e a linguagem ou notação que usamos para expressar ou registrar nossos pensamentos, são os maiores fatores que determinam o que podemos pensar ou expressar! A análise dessa influência que linguagens de programação tem nos hábitos de pensamento de seus usuários, e o reconhecimento que, agora, poder cerebral é de longe o recurso mais escasso, juntos nos dão uma nova coleção de parâmetros para comparar méritos relativos de várias linguagens de programação. **O programador competente é totalmente consciente do tamanho estritamente limitado de seu crânio** ; então ele aproxima da tarefa de programação com total humildade, e entre outras coisas ele evita truques espertos como se fosse a praga. (...) Outra lição que devemos aprender do passado recente é que o desenvolvimento de linguagens de programação "mais ricas" ou "mais poderosas" foi um erro no sentido de que essas monstruosidades barrocas, essas conglomerações de idiossincrasias, são realmente ingerenciáveis, ambas mecanicamente e mentalmente. Eu vejo um grande futuro para linguagens de programação muito sistemáticas e muito modestas.

Um bom programador reconhece as próprias limitações e busca as ferramentas que melhor se encaixam nos problemas. A maioria das guerras de linguagem começa com argumentos assim. O problema é que insistir numa _"linguagem única"_ e empilhar nela tudo que todo mundo pede acaba criando um monstro "barroco", como diz Dijkstra.

Programadores são pessoas, e pessoas têm cérebros limitados. Precisamos conseguir nos expressar em forma de código, e quanto mais complicada a ferramenta, mais da nossa mente vai para manter as peças na cabeça e menos sobra para escrever código elegante.

Veja o próprio Dijkstra. Até os anos 70 ele praticamente viu os computadores nascerem e acompanhou de perto quase tudo, de linguagem de máquina a Fortran, Lisp e Algol. Se naquela época ele conseguia conhecer a fundo várias linguagens, não vejo desculpa para hoje, com todos os recursos que temos, não conhecermos uma ordem de magnitude a mais de linguagens, tecnologias e técnicas.

Ele fala em linguagens mais "modestas", e eu diria que hoje isso são as linguagens dinâmicas de alto nível, como Ruby ou Python. Abstrações que permitem sistemas ainda maiores com menos complexidade.

> Para complementar quero colocar um aviso a aqueles que identificam a dificuldade da tarefa de programação com a briga contra as inadequações de nossas ferramentas atuais, porque eles podem concluir que, uma vez que nossas ferramentas se tornem mais adequadas, programação não será um problema. Programação continuará sendo muito difícil, porque uma vez que nos livrarmos dos desajeitos circunstanciais, nos encontraremos livres para lidar com problemas que agora estão muito além da nossa capacidade de programação.

E desde os anos 70 sabemos que **não existe bala de prata**. Nenhuma ferramenta nova vai, por mágica, tornar a programação ordens de magnitude mais eficiente. Não existe almoço grátis.

> Isso já nos ensinou algumas lições, e a que eu escolhi estressar nesta palestra é o seguinte. Nós devemos fazer um trabalho de programação melhor, dado que nos aproximemos da tarefa com total apreciação por sua tremenda dificuldade, dado que nos seguremos a linguagens de programação modestas e elegantes, dado que nós respeitemos as limitações intrínsecas da mente humana e aproximemos da tarefa como Programadores Muito Humildes.

Programadores precisam ser Humildes no sentido certo da palavra: assumir as próprias limitações e criar novas técnicas, tecnologias e formas de fazer o mesmo trabalho com mais qualidade e mais eficiência, quebrando regras e tradições e criando novos padrões. Já os programadores que seguem apenas o que aprenderam, só os procedimentos, são **arrogantes**: acham que tudo o que dava para descobrir já foi descoberto.

Eu sempre [repito](https://blogoscoped.com/archive/2005-08-24-n14.html) que um bom programador é burro e preguiçoso. Burro porque, se ele se achar esperto, vai achar também que já sabe tudo, e quem já sabe tudo não pesquisa mais. E preguiçoso porque um programador esforçado demais repete o mesmo procedimento todo dia com afinco, enquanto o preguiçoso se cansa disso, automatiza o trabalho e ainda sobra tempo para descansar.

Acho que o Dijkstra concordaria com essa colocação ;-)
