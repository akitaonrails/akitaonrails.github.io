---
title: "[Akitando] #111 - RANT: Média Salarial NÃO Existe | Entendendo Power Laws"
date: '2021-12-20T11:18:00-03:00'
slug: akitando-111-rant-media-salarial-nao-existe-entendendo-power-laws
tags:
- power law
- normal
- gaussiana
- estatística
- linked
- redes
- grafos
- salário
- mercado
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/WwdNJM_3Cdo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## DESCRIÇÃO

Todo ano é a mesma coisa: alguém publica alguma coisa tentando definir "média salarial" de determinada profissão. E está ERRADO. Não existe o conceito de "média salarial" e neste video vou explicar porque, vou explicar como isso estraga sua visão de mundo e da profissão e te leva a tomar decisões erradas, e vou explicar o que de fato existe na estatística de salários de verdade.

## Conteúdo

* 00:00 - Intro
* 00:57 - Matemática
* 01:55 - Média no Colégio
* 04:00 - Como as pessoas entendem "normal"
* 04:54 - Desigualdade é "anormal"?
* 07:24 - Requerimento pra Normal
* 07:53 - Eventos Estatisticamente Independentes
* 09:51 - Zipf e Power Laws
* 12:09 - Modelo Erdös-Rényi
* 12:39 - Modelo Duncan-Strogatz
* 13:51 - Seis Graus de Separação
* 16:09 - Problema de ser trabalhar em pornô
* 17:15 - Recapitulando Grafos
* 18:30 - Modelo Barabási-Albert
* 19:20 - Redes Livre de Escala
* 19:54 - Power Law, e não Normal
* 20:52 - Sistemas Complexos Não Lineares
* 22:15 - Paretto é Power Law
* 23:35 - O Mundo Não é Normal
* 25:21 - Top Influencers: Power Law
* 27:21 - Top Empresas: Power Law
* 28:17 - Preferential Attachment
* 30:04 - Como seu salário realmente evolui?
* 31:01 - Salário começa em Cauda Longa
* 31:38 - Perseguir Média é ser Medíocre
* 33:40 - Novos mercados não tem Média
* 34:57 - Oferta e Procura
* 35:39 - Desculpas e mais Desculpas
* 36:41 - Conclusão

## Links

Links:

* Linked (https://www.amazon.com/dp/B06XC9JM6Y)
* Nonlinear Dynamics and Chaos: With Applications to Physics, Biology, Chemistry, and Engineering (https://www.amazon.com/Nonlinear-Dynamics-Student-Solutions-Manual/dp/0813349109)
* TED - Steven Strogatz: How things in nature tend to sync up (https://www.youtube.com/watch?v=aSNrKS-sCE0)
* TED - Steven Strogatz: The science of sync (https://www.ted.com/talks/steven_strogatz_the_science_of_sync/transcript?language=en)
* Small Worlds: The Dynamics of Networks between Order and Randomness (https://www.amazon.com/Small-Worlds-Randomness-Princeton-Complexity-ebook/dp/B07DMVNYK9)
* Six Degrees: The Science of a Connected Age (https://www.amazon.com/Six-Degrees-Science-Connected-Age-ebook/dp/B00256Z3B8)
* Milgram's Obedience Experiment (https://www.youtube.com/watch?v=cBDkJ-Nc3Ig)
* The Oracle of Bacon (https://oracleofbacon.org/movielinks.php)
* Largest Companies by Market Cap (https://companiesmarketcap.com/)
* The Misbehavior of Markets: A Fractal View of Financial Turbulence (https://www.amazon.com/Misbehavior-Markets-Fractal-Financial-Turbulence-ebook/dp/B004PYDBEO)
* Como Mentir com Estatística (https://www.amazon.com.br/Como-Mentir-Estat%C3%ADstica-Darrell-Huff/dp/858057952X)

## SCRIPT

Olá pessoal, Fabio Akita


Um tema que me irrita profundamente toda vez que ouço é discussões sobre médias salariais, não só na nossa área, mas no geral. Aliás, toda vez que alguém usar a palavra “média” pra falar de qualquer coisa, por exemplo, média de produtividade, média de sucesso, média de recordes! Isso me deixa profundamente irritado e me faz questionar seriamente a saúde do tico e do teco de quem tá falando.






Vou dizer já logo na entrada, "não existe o conceito de média salarial". Não importa quem diga, não importa quão bonito é o PDF com gráficos e diagramas coloridos, qualquer número de média salarial é um número sem sentido e inútil. Só porque alguém escreveu qualquer número num papel, não significa que automaticamente significa alguma coisa. E se você se preocupa com média salarial pra guiar sua carreira, eu me preocuparia seriamente com a saúde da sua carreira.




(...)






Deixa eu começar do começo. Matemática é a língua que usamos pra descrever a natureza, incluindo a natureza de eventos que são tão abstratos que poucos conseguem compreender completamente. Como a natureza além de 3 dimensões de espaço e 1 de tempo, como na teoria de super cordas, ou o que acontece dentro de um buraco negro, ou todos os comportamentos quânticos que acontecem no mundo sub-atômico.






Em dimensões cosmológicas ou sub-atômicas, onde nossos 5 sentidos normais não conseguem perceber nada, a única forma de descrever e comunicar esses eventos é usando a linguagem da matemática. Essa é a beleza desse campo. E falando nos nossos 5 sentidos, existe muito que podemos visualizar e ao mesmo tempo comunicar com números. Quando a gente mede as dimensões de um móvel, quando a gente calcula o tempo que nosso carro vai levar pra chegar do ponto A ao ponto B, pra calcular a quantidade de células no nosso corpo. Tudo pode ser descrito matematicamente.






E você deve ter aprendido lá pela época do colégio sobre esse conceito de agrupamento e distribuições chamado de média. E aqui começam nossos problemas. Você aprendeu, por exemplo, que podia sair perguntando a altura das pessoas na sua sala de aula. Daí era só organizar num gráfico de distribuição e daí era possível achar a média de altura da sala. Soma todas as alturas, divide pelo número de pessoas, tem a média.






Não só isso, no canto da direita, você ia achar as exceções da média, aquelas pessoas mais altas que jogam basquete, bem mais altas que a média. E no canto esquerdo desse gráfico estão as pessoas mais baixinhas, tadinhas, fora da média também. E talvez tenha aprendido que a distância deles da média é definido como desvio padrão. Tecnicamente temos variância que é a medida de dispersão, quanto mais próximo de zero, mais uniforme são os dados. E desvio padrão é a raíz quadrada da variância. Isso não importa muito pra hoje, mas só pra relembrar.






Quanto mais dados dispersos fora da média da média, maior a variância e o desvio padrão. Se você foi pra faculdade e teve alguma matéria sobre processos e qualidade, talvez tenha aprendido o conceito de Six Sigma, 6 desvios fora da média, o que a gente chama de 3 defeitos por milhão, que é o que uma indústria de manufatura gostaria de alcançar em termos de qualidade de produção, quando estamos falando de medição de defeitos em fabricação.






Recapitulando, você faz medições de alguma coisa ou evento, organiza num gráfico cuja curva fica com o formato de um sino, e por isso a gente também chama de formato de sino ou "bell shape", ou mais comumente chamado de distribuição Gaussiana ou “normal”. E talvez venha daqui a interpretação errada dessa distribuição.






A maioria das pessoas fora da matemática costuma saber que existe a distribuição gaussiana. Mas não existe só ela, existem diversas outras na estatística e probabilidade, como distribuição binomial, Poisson, Bernoulli, e existem dezenas de outras. Porém o mais comum é ver nos jornais, televisão e agora YouTube da vida só falando sobre distribuição gaussiana, que é a mais simples de visualizar e mais simples ainda de entender errado sem querer.








As características que as pessoas tiram dessa distribuição é que o normal é estar na média, no meio do gráfico, que é onde a maioria das medições tende a se acumular. Você aprende que estar fora da média é estar num desvio do padrão. Ou seja, é anormal, é fora do padrão. Exatamente como é muito fora do padrão ter 2 metros e meio de altura ou menos de 1 metro de altura. Ou é anormal jogar um dado e sair o número 5 várias vezes seguido. O normal seria tudo estar próximo da média.








Se você considera esse conceito como verdade, e se existe o conceito de média salarial, você acha que o normal seria todo mundo estar próximo da média, e que quem ganha muito abaixo da média obviamente está sendo injustiçado e quem está com muitos desvio padrão acima da média é um explorador que ganha demais. E essa é a conclusão errada que todo mundo chega e começa aqui a razão de porque eu odeio a menção ao conceito de média em riqueza. 






Essa noção está totalmente errada. Vocês entendem errado o conceito de “desigualdade”. Entenda um fato importante: a única igualdade que existe se chama todo mundo pobre igual, como foi por milhares de anos antes da Idade Média ainda. A partir do momento que você tem 1 centavo a mais que seu vizinho, você é tecnicamente mais rico e portanto desigual. Mas pra discussão não se alongar demais discutindo o conceito errado que a maioria das pessoas tem sobre riqueza, deixa eu buscar outras métricas menos controversas. Vamos pegar por exemplo, a quantidade de seguidores que as pessoas tem em redes sociais, como aqui mesmo no YouTube.







Se for seguir pelo mesmo raciocínio, eu suspeito que a maioria das pessoas imediatamente pensaria que a distribuição seguidores de influencers seria semelhante à distribuição normal, afinal ela serve pra tudo. Então todo mundo que tem um canal no YouTube estaria acumulado no meio do gráfico, tendo uma média de seguidores, na casa das dezenas de milhares. No canto direito estariam os mega-influencers, os Whindersons, os Pew Die Pie, os Ninja, com dezenas de milhões de seguidores. No canto esquerdo estariam os novos canais ou canais não tão acessados, com poucas centenas de seguidores. E pronto, esse é o mundo digital.








Eu não posso provar, mas por lógica eu suspeitaria que é por isso que muita gente deve achar que não é tão difícil virar um influencer profissional, seja lá o que isso significa. Não precisa ser o Whinderson ou Ninja com dezenas de milhões, basta atingir a média, centenas de milhares de seguidores. Como o meu canal aqui. Não é difícil, porque esse é o normal, essa é a média. Se eu não conseguir, a culpa não é minha, a culpa é do sistema, é da sociedade, é injustiça social, porque eu deveria ter o direito de pertencer à normalidade, à média.







E você poderia pensar assim pra tudo. Afinal, não é isso que "normal" significa? Todo mundo acumulado na média e os valores no extremo sendo extremamente raros e provavelmente injustos. Ninguém deveria ser nem poder ser um Whinderson e nem ignorado por todo mundo com nenhuma view. Se isso acontece, é um defeito no sistema, é fora da normalidade, é algum tipo de preconceito, por isso obviamente o sistema está errado. 







Essa visualização de mundo é utopia, ficção científica e não a realidade e nem os gráficos e distribuições suportam isso, porque se você acreditava em média e distribuição normal e usava pra tudo, você é que entendeu errado. De fato, a distribuição se chama "normal" porque ela descreve muitos eventos que observamos na natureza, mas não todos.






Se for guardar somente um ponto deste video inteiro, guarde o seguinte. Distribuições normais tem um requerimento extremamente importante: que a probabilidade de um evento não influencie a probabilidade de outros eventos, ou seja, que os eventos sejam estatisticamente independentes entre si. A formalização do conceito de independência na teoria de probabilidades é longa, mas deixa eu dar dois pequenos exemplos pra começar a desenhar essa diferença na cabeça de vocês.






Quando jogamos um dado de seis lados na mesa, cada lado sempre tem 1/6 de probabilidade de aparecer, mais ou menos 16% e pouco. Você pode jogar o mesmo dado 6 vezes, e algumas faces vão repetir, algumas faces nem vão aparecer, mas a probabilidade de cada face sempre é de 1 em 6, independente de quantas vezes você joga o dado. Isso é um evento independente. Se sair o número 2, em nada altera a probabilidade de aparecer 2 de novo ou 5, ou 6. Continua sempre sendo 1 chance em 6.






Por outro lado imagine um baralho. Se toda vez você tirar uma carta e depois recolocar a carta em algum lugar aleatório que você não veja na mesma pilha, a chance de qualquer carta é de 1 em 52. Ou a chance de sair uma carta de coração ou uma de espadas é 1 em 4, porque só tem 4 naipes. Se tiver recolocação da carta e novo embaralhamento, o evento de tirar uma carta é independente, porque a probabilidade continua sendo a mesma.






Porém, se você tirar uma carta e não recolocar, agora as probabilidades mudaram. Se você tirou uma carta 2 de espada, sem recolocar no baralho, a chance de tirar um 4 de espadas é de 1 em 51 cartas, porque o baralho não tem mais 52 cartas, sacou? E a chance de ser espadas é menor, é 1 em 12, porque não tem mais 13 cartas de espadas. Agora a probabilidade pra próxima carta muda à medida que você vai removendo cartas do baralho. Portanto os eventos NÃO são independentes.








Meu ponto é que uma distribuição normal é óbvia em eventos claramente independentes como jogar dados ou moedas. Cada jogada não influencia a próxima jogada. Medição de altura. A medição de altura de uma pessoa não altera a altura de outra pessoa. Ou no caso de processo que falei, na média, em toda fábrica toda peça sai funcionando, com pequenos e raros defeitos. Na média todas as peças tem a mesma qualidade, e se o processo estiver azeitado, defeitos são raros. Esses tipos de eventos podem ser independentes e a distribuição vai ser normal. 








Porém riqueza, número de vendas, número de seguidores em redes sociais, tamanho de cidades por população, tamanho de empresas, volume negociado na bolsa de valores, nenhum deles cabe numa distribuição normal. O exemplo mais fácil de explicar é o que dá origem à Lei de Zipf, sobre a distribuição de ranking e frequência. Em particular o exemplo sobre a distribuição da frequência de palavras em textos. Sem saber nada sobre linguística e estatística, se eu te perguntasse, quais as palavras que mais aparecem em textos em inglês, o que você responderia?








Por chute, você poderia dizer que é o "the" como em "the book" ou "the table". O "the" é a palavra mais frequente em textos em inglês, quase 7% ou seja, 7 em 100 palavras num texto é "the". Acho que não é difícil você concordar com isso se já leu inglês o suficiente. Em segundo lugar é a preposição "of", como em "of course" ou "best of luck" que aparece 3.5% de vezes, ou seja, 7 vezes em 50 palavras. Note que só nesse exemplo, a frequencia entre "the" que é o 1o lugar do ranking e "of" que é o 2o lugar do ranking é da metade. “Of” aparece metade das vezes que “the”. É uma grande distância ao pular só um lugar no ranking. Isso é importante de lembrar.






Essa é característica desse tipo de distribuição. A frequência de qualquer palavra é inversamente proporcional ao seu ranking na lista de palavras, e mais do que isso, a diferença entre cada posição no ranking não decresce de forma linear. A distribuição de Zipf tem o nome do linguista George Kingsley Zipf e é semelhante mas não idêntica à lei de Benford. Mas mais importante, faz parte de uma família de distribuições que chamamos de Power Law.









Eu descobri sobre Power Law pela primeira vez lendo o livro de Albert Lazló Barabási chamado Linked, publicado em 2002. E aqui eu vou ser obrigado a fazer uma longa tangente, mas tenham paciência que vou explicar porque essa história tem a ver com média salarial e porque esses conceitos são importantes pra entender mercados e sua própria carreira em geral.







A ciência por trás de coisas como a distribuição Power Law é a própria ciência por trás do entendimento da matemática de grafos e como ela evoluiu empiricamente por causa do surgimento da internet e, em particular, das redes sociais digitais. Se nunca leu o livro do Barabási eu recomendo muito, fico com muita vontade de resumir mas ia ficar tão longo que a tangente ia ser longa demais.







Foi com ele que aprendi melhor sobre o estudo de redes de Paul Erdös (um dos maiores matemáticos do século XX) e Alfréd Rényi que desenvolveram o modelo Erdös-Rényi que é o modelo mais conhecido se você estudou grafos na faculdade, grafos cujas conexão são distribuidas de forma aleatória entre os nós da rede. Porém, isso não serve pra explicar redes de internet e muito menos redes sociais. Aliás, toda vez que eu falar rede social assuma que são redes sociais virtuais como Twitter ou Facebook.







Durante a primeira bolha da internet, já no fim do século XX, surgiu o trabalho de outra dupla de matemáticos ainda vivos que contribuíram muito pro entendimento matemático da internet. O primeiro é o grande professor Steven Strogatz, que publicou livros como Non-Linear Dynamics and Chaos e já fez Ted Talks sobre sincronia e como sincronização acontece na natureza e até mesmo com objetos não-orgânicos. Vou deixar os links pra essas talks e livros na descrição abaixo. Ele tem muito material sobre teoria do caos e sistemas complexos não-lineares, que é um assunto difícil e que se você se interessa pelo tema, fuja de todo coaching que tenta falar disso e leia direto o Strogatz.







Um de seus alunos foi trabalhar justamente em empresas de internet como o antigo Yahoo! e depois Microsoft, onde teve acesso a volumes gigantescos de dados que foram cruciais pra moldar um melhor entendimento de redes, estendendo o que Erdös e Rényi publicaram décadas atrás. Esse foi Duncan Watts, que junto com seu professor e mentor, chegaram ao modelo de Small Worlds, chamado de Watts-Strogatz. Esse foi uma das pesquisas mais importantes do começo do século XXI, quando pesquisadores como eles tiveram acesso a Big Data. Isso foi Data Sciences de verdade.








No livro Linked, Barabási conta a fascinante história por trás desses dois modelos, por isso eu disse que é legal ler o livro inteiro. Um conceito super famoso do século XX que é a ponte entre os modelos de Erdös-Rényi e Watts-Strogatz é a idéia dos seis graus de separação. Tenho certeza que todo mundo pelo menos já ouviu falar disso, a idéia de que você está conectado a qualquer outra pessoa do mundo por no máximo umas 6 outras pessoas no meio. Aliás, a primeira rede social do mundo, antes de My Space ou Orkut foi justamente um site chamado Six Degrees. Por exemplo, digamos que eu conheço um programador, que foi trabalhar na Califórnia, o chefe dele é amigo de outro CTO, que trabalhou pro Elon Musk na época do PayPal, então eu teria 4 graus de separação com o Elon Musk.







Diversos experimentos foram conduzidos pra experimentar essa teoria, numa era antes da Internet, usando cartas e correios, como o que foi feito por ninguém menos que outro pesquisador que eu gosto muito, Stanley Milgram, no fim dos anos 60. Milgram, que se você já assistiu uma palestra minha por volta de 2009, deve ter visto quando eu mostrava experimentos dele sobre obediência, que vou deixar nas descrições abaixo.






Mas de qualquer forma, a idéia se popularizou no século XX por causa dos Seis Graus de Separação de Kevin Bacon, que foi uma brincadeira feita num programa de TV acho que por estudantes do MIT ou algo assim que falaram que o ator Kevin Bacon tinha até 6 graus de separação com qualquer outro ator de Hollywood. Eles pegaram o equivalente na época ao que temos hoje no IMDB que catalogava todos os atores que trabalharam em todos os filmes e com os inovadores programas de computador da época montaram um banco de dados que conseguisse puxar quem trabalhou com quem em quais filmes e descobrir os graus de separação. 







Esse tipo de programa, qualquer iniciante deveria conseguir fazer um script pra puxar os dados do IMDB e rapidamente chegar nos graus de separação. Mas lembrando que estamos falando do começo da era dos microcomputadores, onde um programa assim era super novidade pra todo mundo que não fosse de tecnologia. O site tá no ar até hoje e se chama Oracle of Bacon.org. Você pode ir lá agora e digitar, por exemplo, Marlon Brando. E ia ver que ele trabalhou em "The Freshman" com o ator Maximillian Schell, que por sua vez trabalhou no filme "Telling Lies in America" com Kevin Bacon, portanto ele tem 2 graus de separação com Marlon Brando.








Na prática não tinha nada necessariamente especial com Kevin Bacon, qualquer bom ator de Hollywood tem graus de separação semelhantes com qualquer outro ator de Hollywood. De qualquer forma, uma constatação que achei engraçada foi quando o Barabási conta que se eu perguntasse quem seriam os atores mais bem conectados de Hollywood, uma dos chutes talvez seria dizer "os que trabalharam em mais filmes".







Isso é verdade até certo ponto, mas não é uma regra, na verdade se você fizer um ranking dos atores com o maior número de filmes que participaram, eles são os que tem menos contatos com os artistas mais famosos. O que eles tem em comum? São todos atores de filmes pornô. A maioria dos artistas famosos nunca trabalhou num pornô, então mesmo se o cara tivesse trabalhado em 500 filmes pornô, isso não deixou ele mais próximo do Kevin Bacon ou Marlon Brando. Quantidade não é qualidade. Que é o que eu penso quando alguém me pergunta se senioridade é só quantidade de anos trabalhando ou quantidade de projetos do mesmo tipo. Parece brincadeira, mas muita gente fica só trabalhando no equivalente pornô da nossa indústria e não entende porque não evolui na carreira.







Voltando aos conceitos, o modelo de redes de Erdös e Rényi descrevem redes ideais, aleatórias e balanceadas em termos de conexões. Pensem em nós como servidores de internet ou pessoas numa rede social. Nesse modelo você consegue estudar as conexões mas não tem muita idéia de como essas conexões aparecem, funcionam ou evoluem. Você pode estudar o menor caminho entre dois nós e coisas assim, mas não muito mais que isso.






O modelo de Watts-Strogatz inovou ao trazer o conceito de "Small Worlds" ou mundos pequenos. Foi a constatação de Watts que conexões não são aleatórias e elas tendem a formar clusters, aglomerados. Pense numa grande rede como as pessoas espalhadas num estado. E pense em mundos pequenos quando elas tendem a se aglomerar em cidades. Dentro de cidades tem bairros. E como talvez você tenha mais conexões dentro do seu próprio bairro do que com bairros mais longes.






Ou no caso de Internet como você tem mais afinidades e conexões com determinados grupos online, como seu grupo de LOL no Discord, ou grupo de trabalho no Slack. Esses são os clusters ou small worlds. Mas nesse modelo ainda não entendemos todos os comportamentos de porque certos clusters são maiores que outros, porque grupos que aparecem do nada de repente começam a dominar, ou porque algumas pessoas são mais influentes que outras.







Finalmente chegamos em Barabási e Réka Albert e o novo modelo Barabási-Albert, que pega o que os outros descreveram até agora e finalmente conseguem explicar o surgimento e evolução de redes sociais de uma maneira mais formal. Foram eles que observaram que redes sociais e a internet são redes livres de escala, o que significa que tem distribuição power-law nas conexões de seus nós, enquanto modelos como Erdös-Rényi e Watts-Strogatz não exibem power laws.








Finalmente voltamos às tais distribuições e esse tal de Power Law. O que diabos é isso? O que Barabási descobriu é que redes como aparecem na natureza, seja redes sociais virtuais ou reais, redes como de neurônios no nosso cérebro, ecossistemas de animais, e outros tipos de redes complexas e não-lineares, provavelmente podem ser descritas como redes livres de escala.







Como o nome diz, uma rede livre de escala significa que ela exibe qualidades como fractais, ele até menciona pesquisas como de Mandelbrot, que alguns talvez conheçam dos trabalhos matemáticos de fractais propriamente ditos ou seus trabalhos sobre mercados financeiros e economia. Uma rede livre de escala ou fractal significa que não importa se você olha de perto ou de longe, em qualquer escala, ela exibe as mesmas propriedades. Portanto, o mesmo comportamento acontece com mil nós ou com um milhão de nós, independente da escala. Se ficou confuso, vou voltar nisso mais pra frente.








Agora, uma distribuição power law é importante porque ela é muito diferente de uma distribuição normal. Primeiro de tudo, na distribuição normal você sempre tem um pico, o valor médio, a média. Em power law não existe pico. No gráfico, a power law é uma curva em declínio, caindo rapidamente no começo e estendendo numa cauda longa ou Long Tail, que talvez você já tenha ouvido falar em outros livros. Não é necessariamente uma logarítmica, mas é parecido.








Entenda. O que eu disse antes é que distribuição normal funciona quando estamos falando de eventos independentes. Jogar um dado, uma moeda, medir altura, coisas desse tipo. Qualidades como riqueza, influência, salários, vendas, aglomeração de pessoas ou animais, sistemas biológicos complexos, infectologia nessa época de Covid. Tudo isso é interconectado numa rede. Nenhum dos eventos é estatisticamente independente. Elas influenciam as probabilidades dos outros. São sistemas complexos não-lineares.








E o que são sistemas complexos não-lineares? Preste atenção nas palavras do nome. Um sistema complexo tem comportamento não linear, ou seja, o sistema pode responder de formas diferentes dado as mesmas causas. Lembra do filme do Ashton Kutcher, o Efeito Borboleta? Tente voltar ao passado e mexa numa pequena coisa e o futuro fica completamente diferente? Pois é, não importa quantas vezes você tente, o resultado nunca é o esperado, porque é um sistema complexo. O filme é bem mau feito, claro, mas é uma forma de visualizar o que significa um sistema complexo ou caótico. E é uma das razões que eu falo que não adianta ler biografia ou tentar imitar gente famosa: mesmo se você tentar fazer tudo que eles fizeram, os resultados vão ser extremamente diferentes, porque pequenas variações são suficientes te colocar em caminhos completamente diferentes.







E o não-linear significa que o resultado não é proporcional, linear, com as causas. Que é aquele exemplo que todo mundo já ouvi falar de uma borboleta bate as asas no Brasil e acontece um Tsunami no Japão. Resultado desproporcional pra uma causa tão simples como uma borboleta batendo as asas, e é complexo porque não temos como correlacionar uma causalidade entre os dois eventos. Portanto, um sistema complexo não-linear. Mas o mais importante é que esse tipo de sistema costuma ser descrito com distribuições power law, como a de Zipf que falei antes, no caso de palavras do dicionário.






Mais importante, o mundo real complexo, como a economia, é muito descrita com distribuições Power Law, como a de Zipf que expliquei antes e outra distribuição da mesma família que você já deve ter ouvido falar. A distribuição de Paretto, que deriva do economista e engenheiro italiano Vilfredo Paretto, aquele que constatou que a distribuição de riqueza seguia a tal regra de 80/20. Lembram? 80% da riqueza está acumulado com 20% das pessoas? E o que isso significa. Volte pro gráfico de uma power law. Esse pedaço na esquerda são os 20% de pessoas, e essa área do gráfico representa 80%. O outro lado do gráfico são os 80% restante de pessoas, e a área embaixo dessa curva representa os 20% da restante da riqueza. Se você nunca visualizou 80/20, isto é 80/20.







Goste disso ou não, a realidade é que você vive num sistema complexo não-linear. O mercado de trabalho é um sistema complexo não-linear. É muito raro existirem variáveis independentes, tudo é interconectado, e os resultados são muito difíceis de prever por causa da não-linearidade. Por isso todo mundo tem tantas dúvidas e não existe uma receita linear simples de "faça esta lista de coisas, nesta ordem, nestas proporções, ao longo de X anos e garantidamente você vai ter sucesso". Não existe isso tanto quanto não existe uma receita pra prever meteorologia com previsão exata pra daqui 1 ano. 









Mas como eu disse antes, talvez na sua cabeça o mundo deveria ser Normal, o objetivo deveria ser a média. Fazer o que todo mundo faz deveria ser a forma segura. Extremos deveriam ser raros. Mas não. O mundo real é complexo e descrito com Power Laws, uma distribuição livre de escala, que não apresenta média. Por isso eu falei que é errado dizer "média salarial", não por causa de opinião x ou opinião y, mas porque eu acho que está tecnicamente e factualmente errado mesmo. Seria como eu dizer “fogo gelado”, um termo que não faz sentido.








Com toda essa teoria no lugar, a partir de agora é um pouco minha interpretação pra substituir seu entendimento em cima de distribuição normal pra power law. Primeiro de tudo, o que significa não existir média? No caso de salário significa que você é um ponto discreto neste gráfico. O gráfico não dá qualquer dica de qualificação se isso é muito ou se é pouco, ele apenas "é". É o que eu quero dizer quando digo que você recebe exatamente o que deveria. Não estou julgando se você "podia ganhar mais" ou se "ganha mais do que devia", estou dizendo que não tem nada de anormal do ponto de vista da distribuição.








É tudo uma rede interconectada. O que você ganha reflete não só suas capacidades técnicas, inclui também diversas outras variáveis, muitas delas não-lineares, como sua capacidade de comunicação e de negociação. Tirando todas as outras variáveis, se sua capacidade técnica talvez vale 10 mil reais, mas você ganha 5 mil, talvez sua capacidade de negociação te dê prejuízo de 5 mil reais, é uma forma de enxergar isso. Não estou dizendo se é ou não moralmente ou socialmente certo, estou dizendo que está correto do ponto de vista frio e calculista do gráfico mesmo. Nunca tente embutir seus preconceitos e crenças pessoais em cima de números. Números não se importam com isso.








Vamos voltar de novo pra quantidade de seguidores de influencers. Não é distribuição normal, é power law, vamos ver? Eu peguei o primeiro artigo que achei sobre os 50 maiores influencers do Twitter. Em 1o lugar temos o Barack Obama com 130 milhões de seguidores. O 2o lugar é o Justin Bieber que já cai pra 114 milhões, 15 milhões a menos que o Obama. 3o lugar é a Katy Parry, com 108 milhões. 4o lugar é Rihanna com 103 milhões. 5o lugar é Cristiano Ronaldo com 96 milhões. 







Nem precisa ir muito longe mas já em 12o lugar é o Elon Musk com 66 milhões. Menos da metade do Obama. Perto do fim dessa lista tá o Harry Styles em 48o lugar com 37 milhões, que é mais ou menos metade do Musk. Conseguem ver como a quantidade de seguidores vai caindo drasticamente? E isso é só a lista de 50 top influencers. Vamos colocar eles no gráfico? Olha só, copy e paste pro Excel, marca os números de seguidores, escolhe o gráfico de colunas e ... surpresa, surpresa, uma curva que se parece com uma power law, não com uma normal. 






Se a lista tivesse todos os mais de 77 milhões de usuários do Twitter, essa curva ia simplesmente decrescendo rapidamente e a grande maioria das pessoas estaria na Cauda Longa, no Long Tail essa curva. Mas eis a coisa interessante sobre livre escala. Se eu pegasse um trecho lá no fim dessa cauda longa, a curva ainda ia ter o mesmo formato dos 50 primeiros. Ou seja, a pessoa no lugar, faz de conta, 20 milhões nessa lista, ia ter talvez o dobro de seguidores de quem está no lugar 21 milhões. Só que em vez de 130 milhões de seguidores como o Obama, talvez tenha só 1000. Só que 1000 continua sendo o dobro de 500, que ainda é o dobro de quem só tem 250, que ainda é o dobro de quem só tem 120. E assim por diante.





Numa curva assim não existem classes. Todo mundo é 1 ou 2 seguidores mais rico que o próximo da lista. Não tem classes de influencers ricos, médios e pobres. Em qualquer escala, o trecho lá pra baixo dos 50 milhões, vai ter o cara com mil influencers que pode ser considerado muito melhor que o cara de 100 seguidores que é invejado pelo cara com 2 seguidores.





Só pra solidificar o conceito, vamos ver outro tipo de ranking, o ranking das empresas mais valiosas em termos de market cap no índice da S&P 500 dos Estados Unidos. Peguei esse gráfico num site aleatório chamado Companiesmarketcap. No topo da lista tá a Apple, com valor de mercado em dezembro de 2021 de quase 3 trilhões de dólares. Em segundo lugar está a Microsoft, com nada menos que 2.5 trilhões de valuation. Em terceiro temos a Alphabet, a holding que tem produtos como o Google por baixo, que vale quase 2 trilhões. E assim por diante. 







No meio dessa lista em trigésimo quinto lugar está a Oracle com valor de “só” 260 bilhões de dólares. Se não conseguiu enxergar ainda, vamos abrir o Excel, selecionar os valores de mercado e gerar o gráfico. Tá vendo? Mais uma distribuição power law. Não existe valor médio de uma empresa, tanto como não existe valor médio de um produto ou valor médio de salários. Praticamente tudo que você costuma ver na forma de rankings tem esse formato.







A parte interessante é que uma rede livre de escala que obedece uma distribuição power law tem outras características interessantes, uma das melhores é o que Barabási chamou de “preferential attachment”. Inclusive seu modelo foi revisado depois pra descrever melhor isso e o modelo mais atual se chama Bianconi-Barabási, que surgiu depois do lançamento do livro Linked.







Numa rede dessas você poderia pensar corretamente, poxa, os caras mais influentes provavelmente são aqueles que começaram a trabalhar na rede lá atrás, quando ela surgiu. É o que se chama de vantagem do primeiro ou “first-mover advantage”. E de fato tem isso. Daí quando o primeiro conseguiu a vantagem, começa o comportanto de "rico fica mais rico" ou "rich gets richer" que é o que todo mundo tem inveja, porque agora que o cara é grande, ele tende a atrair mais gente e ficar cada vez maior.







Mas se você viveu tempo suficiente na internet, reconhece que existe essa vantagem, existe esse comportamento de rico fica mais rico, mas também já presenciou vários influencers que tinham tudo e desapareceram e vários outros tomaram seu lugar. Veja na história da internet: um Yahoo sendo substituído pelo Google, uma Blackberry sendo substituída pela Apple, um TikTok batendo no Instagram. Sim, de fato existe vantagem em ser o primeiro, sim o rico fica mais rico, mas não, esse ranking nunca é estático, está em constante movimento.







Você que tem 1 seguidor, trabalha e vai ter 10, depois vai ter 100. Aquele que tinha 1000, falou merda, foi cancelado, agora perdeu 900 seguidores. E assim segue o jogo. E voltando pro tema de salários, isso tudo foi pra explicar que salários não tem média e não são estáticos. Nem dentro de uma mesma empresa existe média. A curva que descreve os salários é uma power law. Mais do que isso, você começa no fim da cauda longa, mas a curva não é linear.






Ou seja, se hoje você ganha 2000 reais. Passou um ano e ganhou um aumento pra 2200 reais. Na sua cabeça você pensa, puxa, pra eu chegar em 10 mil reais nesse ritmo, de 200 em 200, vai levar 40 anos então. Tô fodido. Esse mercado é uma merda. E se o mundo funcionasse como uma distribuição normal, um sistema linear simples, sim, seria isso mesmo. Mas o mundo Não é assim, em vez de simples, ele é complexo, em vez de linear, ele é não linear. 





Ou seja, incrementos não vão ser necessariamente de 200 em 200. Ano que vem já pode ser de 400. No ano seguinte, se fizer um bom trabalho, já vai ser de 1000. Em 2 anos talvez você já chegou ou ultrapassou 3000 reais. Daí no ano seguinte você foi pra 4000. De 4000 talvez já saltou pra 6000. E mais um ano já chegou em 10000. Em vez de 40 anos, foram 5 anos só. Esse é o poder de uma curva não linear. Seu salário também tem chances de crescer segundo uma power law. Mas não é uma garantia, só uma possibilidade.







O problema pros iniciantes é que no começo da cauda longa, ela parece lenta, quase horizontal, mas se você fizer o trabalho direito, evoluir suas capacidades técnicas, suas capacidades não-técnicas como comunicação, evoluir sua rede social com pessoas que começaram com você e saíram pro mercado e também começam a se dar bem, ou seja, você cresce seu networking de verdade, daí sua chances começam a aumentar exponencialmente. E se fizer um trabalho tão bom que consegue se conectar com alguém que representa um hub pro cluster da rede que participa, aumenta absurdamente suas chances de dar mais certo do que tinha planejado antes.









Essa teoria toda suporta a idéia de que se você é o cara que só faz o que mandam, prefere ficar quieto e esquecido num canto, torcendo pra que não notem que você tá lá, inventa desculpas toda hora e ganha reputação de que não é confiável, você está transformando um sistema complexo e não linear, num sistema simples e previsível, com poucas variáveis que vai ter acesso. E linear, onde cada esforço que você faz é diretamente proporcional a um pequeno retorno. E aí sim, naquela conta que fiz antes, vai ter sorte se pular de 2000 pra 10000 em 40 anos.







Só que a culpa não é do sistema, não é um mercado que não te valoriza e te paga abaixo da média. É você que matou todas as suas chances de escalar a curva não-linear. O único culpado da sua estagnação é você mesmo, e isso começa quando você acredita que existe uma média onde você se encaixa e pode ficar lá escondido pra sempre. Não existe. A menos que goste de ficar na estagnação, uma hora vai precisar dar a cara a tapa.







Se nada disso te convenceu ainda e você ainda acha que pode fazer como fazia no colégio e na faculdade, onde bastava dar um jeito na última hora pra tirar 5 e passar de ano, e não faz nenhuma diferença tirar 5 ou tirar 10, é aqui que você se ferra. Faz muita diferença aprender a correr atrás do 10. É a diferença de 40 anos e 5 anos pra ter o mesmo resultado. Você não faz parte de uma média, você faz parte de uma cauda longa. E na cauda longa, se você não fizer nada de diferente, o limite tende a zero.






Você sabe o que são palavras cognatas? Significa que além de sinônimas, tem raiz comum. Exemplo: "belo" e "beleza", "fera" e "feroz". Pois bem, se pra você ficar perto da média, ser mediano, parece bom, e se eu disser que mediano é cognato, compartilha a mesma raiz com a palavra "medíocre". Na prática a gente afastou médio de medíocre, mas não se engane, são a mesma raiz. Eu acho que você ficaria ofendido se eu te chamasse de medíocre, certo? Então pra que você tá tão obcecado pela média de alguma coisa? Fique longe da média, faça esforço pra tirar 10 e não pra ficar no 5.






Salário depende de dezenas de variáveis diferentes. As variáveis que estão sob seu controle como suas próprias capacidades e competências e as variáveis que você não tem como influenciar diretamente, como ciclos financeiros, situações específicas e regionais do mercado onde participa, como esses mercados se interconectam uns aos outros. Quer ver um exemplo na prática? Veja meu episódio onde conto minha história sobre Ruby on Rails no Brasil.







Existiu um dia que eu decidi investir meu tempo e minha carreira nesse troço novo que quase ninguém aqui conhecia chamado Ruby on Rails. Não havia uma única empresa que usava no Brasil. Não havia quase nenhum outro programador. O grupo que existia dava pra quase saber o nome de todo mundo de cabeça, de tão poucos que tinham. Era o ano de 2005. Qual era a média de um programador Rails em 2005? Você acha que esse número ia servir de qualquer coisa pra mim? 







Pra alguém ter a estúpida idéia de tentar calcular a média de salário desse mercado, primeiro eu precisava ajudar a influenciar a criar esse mercado, do zero. A vantagem? Eu sabia que era um sistema não-linear. Um bom exemplo se multiplica em dois, dois em quatro, quatro em oito, em breve eram dezenas de empresas e centenas de nós, no breve espaço de uma década. E assim aconteceu com dezenas de outros mercados que não existiam.








Qual era a média salarial de um programador de iPhone em 2009? Zero, porque não existia AppStore ainda. Qual era a média salarial de um devops de cloud de AWS em 2006? Zero, porque AWS tinha acabado de lançar. A informação que a média de um programador Java em 2006 era de sei lá, 4 mil reais, ia ajudar em alguma coisa pra qualquer um de nós? Nada, absolutamente nada. Salário é o que as empresas se convencem de pagar pelo que a gente faz eles acreditar que vale. É como o preço de um produto. As coisas não são demasiadamente caras ou baratas, elas obedecem oferta e procura. Como agora: a demanda por componentes eletrônicos está alta, mas as fábricas não conseguem atender essa demanda? Os preços sobem. É simples assim.








Ah, mas na minha cidadezinha de 2 mil habitantes só tem uma única empresa. Quem sabe se eu mostrar um PDF com média salarial da capital, faz alguma diferença? Não faz. Cai na real. E você não tá preso, ninguém está apontando uma arma pra sua cabeça. Ou você se muda de cidade, ou começa a trabalhar remoto por exemplo. Especialmente em tecnologia, tem dezenas de empresas que estão desesperadas neste exato instante, pra contratar bons programadores. Ah, mas eu não sou um bom programador. Aí é outro problema.









Você tem sorte então, que pelo menos tem uma empresa que ainda quer te manter, sei lá porque. Tá entendendo? Tudo começa e termina com o que você tá disposto ou não a fazer pra mudar sua própria situação. Lembra do meu video de Não Terceirize suas Decisões? Porque você tá tentando justificar sua situação com números que sequer fazem qualquer sentido matemático, como média pra salário? Como isso te ajuda? Assuma a verdade: isso é só mais uma desculpa que você tá dando pra você mesmo. Nada mais, nada menos.





Se você se interessou pelos assuntos que só tive tempo de explicar por cima, procure os autores originais, é o que eu sempre digo. Então os nomes que você precisa ter na sua lista são Paul Erdös, Alfred Rényi, Steven Strogatz, Duncan Watts, Albert Lazló Barabási e Ginestra Bianconi. Você vai passar pelo estudo de grafos, redes livre de escala e talvez vai se aventurar em teoria do caos e sistemas complexos não lineares e isso vai te dar um framework pra enxergar a Matrix por trás de fenômenos da natureza, incluindo como mercados e sociedades realmente funcionam. E em nenhum lugar você vai ver qualquer um insinuando que faz sentido levar algo inútil como "média salarial" a sério. Se ficaram com dúvidas, mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e compartilhem o video com seus amigos. A gente se vê, até mais.
