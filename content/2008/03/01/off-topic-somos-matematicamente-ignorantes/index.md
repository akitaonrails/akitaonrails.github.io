---
title: 'Off Topic: Somos Matematicamente Ignorantes'
date: '2008-03-01T14:18:00-03:00'
slug: off-topic-somos-matematicamente-ignorantes
tags:
- off-topic
- principles
- science
- fallacies
draft: false
---

A menos que você já tenha estudado Estatística e Probabilidade ou seja um fã de matemática, é provável que seja um verdadeiro ingênuo em termos matemáticos, para não dizer outra palavra.

Principalmente se, mesmo com pouca frequência, tente explicar eventos puramente aleatórios como “coincidências misteriosas” que “precisam” ter alguma explicação mística ou sobrenatural.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/1/skeptic.jpg)

Mesmo entre nós, programadores, muitos ignoraram a disciplina durante o que é ensinado normalmente no primeiro ano de Ciências da Computação. Um dos resultados práticos desse tipo de ignorância: [Birthday Attacks](http://en.wikipedia.org/wiki/Birthday_attack) que é um tipo de ataque criptográfico nomeado assim porque explora a matemática por trás do [Birthday Paradox](http://en.wikipedia.org/wiki/Birthday_paradox) – que é explicado no artigo que traduzo abaixo.


Ou seja, dada uma função f (exemplo: autenticação), o objetivo do ataque é encontrar duas entradas x1 e x2 (exemplo: senhas) de tal forma que f(x1) = f(x2). Tal par x1 e x2 é chamado de [colisão](http://en.wikipedia.org/wiki/Hash_collision). Nós sempre concluímos esse problema da maneira errada.

Uma leitura interessante pode ser [The Psychology of the Psychic](http://en.wikipedia.org/wiki/The_Psychology_of_the_Psychic), de David Marks e do Dr. Richard Kammann, que é uma análise cética de afirmações paranormais. Uma definição não óbvia é o que Marks chamou de “Koestler’s Fallacy” onde as pessoas assumem que dois acertos estranhos em eventos aleatórios não podem acontecer apenas por chance (_cof_ Evolução _cof_).

Este artigo de **Bruce Martin** , da excelente revista [Skeptical Inquirer](http://csicop.org/si/9809/coincidence.html) demonstra como dois eventos “coincidentes” em um universos de alternativas aleatórias é mais comum do que pensamos. Ou seja, ele demonstra como nossa **intuição** ou **bom senso** em torno desse tipo de análise é totalmente falha e como somos complemente ignorantes ao atribuir probabilidades a eventos. _“Este projeto tem 90% de chance de dar certo.”_, _“Este time de futebol tem 60% de chance de ganhar o campeonato.”_, _“Eu tenho 45% e chance de passar no vestibular.”_ Tudo isso é não mais do que um chute, um número arbitrário sem qualquer senso de razão aos eventos que tenta prever.

Quando você tenta prever alguma coisa e erra diz, _“que estranho, normalmente eu acerto”_ e todos ignoram e esquecem esse fato. Se você por acaso “acerta” uma previsão diz _“ahá, eu sabia que tinha razão, eu sempre acerto!”_, e todos ficam surpresos e todos se relembram apenas desse fato. Nossa mente funciona assim mesmo: não guardamos tudo, armazenamos apenas o que nos é conveniente. E isso influi em nossas (más) decisões futuras.

Verdade #1: ninguém consegue “prever” o futuro com precisão. Verdade #2: eventos aleatórios acontecem com mais frequência do que imaginamos. Verdade #3: dentre diversos eventos completamente aleatórios sempre vamos encontrar padrões – e iremos memorizar esses padrões e tentaremos, inutilmente, dar “significados” e eles. Porém, essas “coincidências” são apenas isso: eventos aleatórios totalmente calculáveis.

**nota:** recomendo muito a leitura da excelente revista [Skeptical Inquirer](http://csicop.org/si/9809/). Assim como recomendo se manter informado sobre a [CSICOP](http://csicop.org/) ou _“Committee for Skeptical Inquiry”_ que é uma organização que encoraja a investigação crítica e afirmações pseudo-científicas e paranormais de um ponto de vista responsável e científico e dissemina informações factuais e resultados desse tipo de inquisição para a comunidade científica e o público. (mais sobre a [CSI](http://csicop.org/about/)) Todos os dias alguém em algum lugar do mundo está pensando ativamente em como nos enganar. Todos os dias nós automaticamente nos enganamos sem perceber. Todo dia esse tipo de mentira nos leva a decisões erradas e prejudiciais a nós mesmos. Por isso é necessário nos policiar o tempo todo para sermos “Skeptical Inquirers”, literalmente “Inquisidores Céticos”. Não sabermos a resposta de alguma pergunta hoje, não significa que não vamos desvendá-la amanhã. Conclusões precipitadas são o maior mal do progresso, porque ficamos estagnados investindo em mentiras. Espero que este artigo sirva como um alarme de que nós nos enganamos com mais frequência do que gostaríamos.

Acham que conseguem “adivinhar” os resultados de um campeonato esportivo? Acha que consegue adivinhar os resultados das bolsas de ações? Acha que consegue adivinhar o resultado de jogadas sucessivas de roleta num cassino? Pense novamente. Faz tempo que tenho este artigo guardado e queria traduzí-lo, mas só agora resolvi colocá-lo aqui. Este texto é longo e talvez cansativo para a maioria, mas recomendo ler até o final. Vamos à tradução do artigo:

## Coincidências: Notável ou Aleatório?

_As coincidências mais improváveis normalmente resultam do jogo de eventos aleatórios. A própria natureza da aleatoriedade garante que a combinação de dados aleatórios vai resultar em algum padrão._

Bruce Martin

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/1/cover.jpg)](http://csicop.org/si/9809/)

_“Você não acredita em telepatia?”_ Meu amigo, um sóbrio profissional, perguntou com desdém. _“Você acredita?”_ eu repliquei. _“Claro. Muitas vezes eu estava fora de noite e de repente ficava preocupado com meus filhos. Ligando para casa eu descobria que um estava doente, se machucou ou teve pesadelos. Como você pode explicar isso?”_

Esse tipo de episódio aconteceu a todos nós e é comum ouvir essas palavras, _“Não pode ser só coincidência”._ Hoje a explicação que muitas pessoas chegam envolve telepatia mental ou misturas psíquicas. Mas deveríamos saltar tão rapidamente nos braços do mundo místico? Poderiam tais eventos resultar de coincidências afinal de contas?

Existem duas funcionalidades de coincidências não bem conhecidas pelo público. Primeiro, nós tendemos a ignorar o poderoso reforço das coincidências, tanto acordando e em sonhos, em nossas memórias. Eventos não-coincidentes não registram em nossas memórias com a mesma intensidade. Segundo, nós falhamos em entender a extensão com que eventos altamente improváveis ocorrem diariamente a todo mundo. Não é possível estimar todas as probabilidades de muitos eventos pareados que ocorrem em nossas vidas diárias. Nós normalmente tendemos a dar às coincidências probabilidades menores do que merecem.

Entretanto, é possível calcular a probabilidade de eventos que parecem improváveis com precisão. Esses exemplos dão dicas de como nossas expectativas falham em concordar com a realidade.

### Datas de Aniversário Coincidentes

Em uma seleção aleatória de 33 pessoas existe 50% de chance (1 em 2) que pelo menos 2 pessoas tenham a mesma data de aniversário. Quem já não ficou surpreso de aprender isso pela primeira vez? O cálculo é direto. Primeiro encontre a probabilidade que todos no grupo tenham datas diferentes (X) e então subtraia essa fração de 1 para obter a probabilidade de pelo menos um aniversário comum no grupo (P), P = 1 – X. Probabilidades se limitam de 0 a 1, ou podem ser expressadas de 0 a 100%. De nenhuma coincidência a segunda pessoa tem uma escolha de 364 dias, a terceira pessoa 363 dias e a enésima pessoa 366 – n dias. Então a probabilidade de todas as diferentes datas de aniversário se torna:

* * *
bash

Para duas pessoas: X2 = (365\*364)/365

Para três pessoas: X3 = (365\* 364\*363)/365

Para n pessoas: Xn = (365\*364\* … 366-n)/365  
 Xn = 365! / [365^n \* (365-n)!]  
-

Com seus fatoriais a última igualidade não é especialmente útil a menos que se tenha a capacidade de lidar com números muito grandes. É instrutivo usar uma planilha e um loop de uma linguagem de computador para calcular Xn, a partir da 1a igualidade, para sucessivos valores de n. Quando n = 23, se descobre que Xn = 0.493 e P = 0.507. O gráfico da probabilidade de pelo menos 1 data de aniversário comum, P, contra o número de pessoas, n, aparece como o lado direito da curva de um círculo na figura 1. A curva mostra que a probabilidade de pelo menos 2 pessoas terem a mesma data de aniversário sobe devagar, no começo passando menos de 12% de probabilidade com 10 pessoas, subindo até 50% no círculo aberto correspondendo à 33a pessoa, então estabilizando e atingindo 90% de probabilidade em um grupo de 41 pessoas. Isso significa que, na média, de 10 grupos aleatórios de 41 pessoas, em 9 delas pelo menos 2 pessoas tem o mesmo aniversário. Nenhuma força misteriosa é necessária para explicar a coincidência.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/1/fig1.gif)

> **Figura 1:** Probabilidade de Aniversários Coincidentes: a curva do lado direito de um círculo representa a probabilidade que em um grupo aleatório de pessoas, pelo menos 2 tenham a mesma data de aniversário. Como indicado pelo círculo aberto acima da linha horizontal de probabilidade 0.50, na média 50% de chance é atingido com apenas 23 pessoas. A curva para o lado esquerdo representa a probabilidade que em um grupo aleatório de pessoas pelo menos 2 tenham o mesmo aniversário com diferença de 1 dia de cada um. A chance de 50% para essa coincidência de 3 dias ocorre com apenas 14 pessoas.

Note que a probabilidade de coincidência de aniversário para 23 + 23 = 46 pessoas não é 100%, como alguns poderiam supor, mas 95% como mostrado pela curva de lado direito na Figura 1. A extensão da curva acima do limite da figura 1 revela que 57 pessoas produzem 99% de probabilidade de aniversários coincidentes.

O mesmo princípio pode ser usado para calcular as probabilidades de pelo menos 2 pessoas em um grupo aleatório terem o mesmo aniversário com um dia de diferença (o mesmo e dois dias adjacentes, exemplo, o aniversário da primeira é dia 20, o da segunda ser entre os dias 19 e 21). Essa condição é menos restritiva que antes, e a probabilidade de 50% é atingida com apenas 14 pessoas. A curva de lado esquerdo na Figura 1 mostra um gráfico para as probabilidades de aniversários-dentro-de-1-dia.

Indo um pouco mais a fundo em alguns aspectos da probabilidade de aniversários idênticos nos dão dicas adicionais. Note que dissemos diversas vezes “pelo menos 2 pessoas” tendo o mesmo aniversário. Enquanto o grupo cresce as chances de múltiplas coincidências aumenta.

- A curva descendente à esquerda na Figura 2 representa a probabilidade de nenhuma coincidência (NC) de aniversários, idêntica aos valores de Xn calculados acima.

- A primeira curva com um máximo mostra a probabilidade de apenas um par (1P) com o mesmo aniversário. O máximo ocorre com 28 pessoas e uma probabilidade de 39%.

- À medida que o grupo cresce as probabilidades de outras coincidências também aumenta. A segunda curva com um máximo representa a probabilidade de exatamente 2 pares de pessoas (2P) tem aniversários idênticos. Seu máximo acontece com 39 pessoas e probabilidade de 28%.

- A última, a curva ascendente na Figura 2, mostra o total de probabilidades de todas as coincidências restantes (\> 2P), consistindo de 3 pares, etc. Para todos os números de pessoas, as probabilidades para todas as 4 curvas dão o total de 1.00 (100%).

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/1/fig2.gif)\</p?

> **Figura 2:** Probabilidades de Múltiplos Aniversários Coincidentes: A curva descendente na esquerda representa a probabilidade de nenhuma coincidência (NC). A primeira curva com um máximo demonstra as probabilidades de 1 único par (1P) com aniversários idênticos. A segunda curva com um máximo representa a probabilidade de exatamente 2 pares (2P) onde cada par pode ter aniversários diferentes entre si. A curva ascendente na direita mostra a probabilidade de todas as coincidência (\> 2P), 3 pares, triplets, etc. Para qualquer número de pessoas as probabilidades das 4 curvas dão o total de 1.00.

A Figura 2 mostra que para 33 pessoas as probabilidades são 36% para 1 par, 11% para 2 pares e 3% para o total de todas as coincidências, onde os totais somam 50%. Nós quebramos a probabilidade de 50% para pelo menos uma coincidência discutida acima para 33 pessoas em contribuições de componentes. Para 33 pessoas a probabilidade de nenhuma coincidência também é 50%, como mostrado na curva descendente (NC) da Figura 2.

Existe quase uma tripla intersecção com 38 pessoas onde a chance de 1 par idênitco, 2 pares idênticos e o total de todas as coincidências é 28-29. Para 38 ou mais pessoas o total de todas as coincidências se torna maior do que as possibilidades de exatamente 1 ou 2 pares e passa de 50% com 45 pessoas. Em um grupo aleatório de mais do que 45 pessoas existe uma chance melhor do que a média que existem mais do que 2 coincidências de aniversários.

O que essa série de cálculos conclui é isso: se coincidências de aniversários são muito mais comuns do que poderíamos imaginar, não é provável que muitas dessas outras coincidências impressionantes em nossas vidas seja o resultado de probabilidades também? Não demos multiplicar hipóteses: o princípio da Lâmina de Occam dita que a explicação mais simples deve ser preferida.

### Coincidências Presidenciais

Considere as datas de nascimento e morte de presidentes Americanos para ver como esse raciocínio funciona em casos reais. Existiram 41 nascimentos de presidentes, e a Figura 1 indica 90% de probabilidade que pelo menos 2 presidentes deveriam ter nascido no mesmo dia. E existe mesmo essa coincidência: James K. Polk e Warren G. Harding ambos nasceram no dia 2 de Novembro. O resultado aparece na Tabela 1.

| **Tabela 1** |
| **Coincidências Presidenciais** |
| **Aniversários, 41 casos (90%)** |
| 2/Nov | James K. Polk |
| &nbsp; | Warren G. Harding |
| **Mortes, 36 casos (83%)** |
| 8/Mar | Millard Fillmore |
| &nbsp; | William Howard Taft |
| 4/Jul | John Adams |
| &nbsp; | Thomas Jefferson |
| &nbsp; | James Monroe |

Com 41 casos existe 66% de chance de uma segunda coincidência, mas nenhuma aconteceu ainda [o resultado pode ser obtido adicionando as probabilidades para 41 pessoas para 2P (28%) e \>2P (38%) nas curvas da Figura 2.] Talvez o aniversário do próximo presidente coincida com um dos 41 anteriores.

Dos 36 presidentes mortos, a Figura 1 indica com 83% de probabilidade que pelo menos 2 devem ter morrido na mesma data. O resultado também aparece na Tabela 1. Ambos Millard Fillmore e William Howard Taft morreram em 8 de Março.

Com 36 casos, existe 51% de chance de uma segunda coincidência …

No que parece uma chocante coincidência, 3 presidentes morreram em 4 de Julho, como listado na Tabela 1. Ambos John Adams e Thomas Jefferson morreram no mesmo ano, 1826, no aniversário de 50 anos da assinatura da Declaração de Independência. As palavras finais de Adams, que qeu rival de longa data e correspondente Jefferson “ainda vive”, estavam erradas, já que Jefferson morrera antes no mesmo dia. James Monroe morreu na mesma data 5 anos depois.

Estudiosos de Presidentes sugerem que os presidentes anteriores fizerem um esforço para esperar até 4 de Julho. James Madison rejeitou estimulantes que poderiam ter prolongado sua vida, e ele morreu 6 dias antes, em 28 de Junho (em 1836). Parece evidente que para as mortes de muitos presidentes em 4 de Julho não é uma data aleatória. Apenas um presidente, Calvin Coolidge, nasceu em 4 de Julho.

Um ponto importante é que nenhuma data de aniversário foi especificada de antemão. A Tabela 2 lista de pessoas necessárias para probabilidade de 50%. A primeira repete o que já sabemos: um grupo de 33 pessoas é suficiente para pelo menos 2 terem o mesmo aniversário não-especificado.

| **Tabela 2** |
| **População para 50% de prob.** |
| Pelo menos 2 com a mesma data não-especificada | 23 |
| Pelo menos 1 tem a data especificada | 253 |
| Pelo menos 2 tem a mesma data especificada | 613 |

Se especificarmos uma data em particular, como hoje, são necessárias 253 pessoas para ter uma chance média de pelo menos 1 pessoas com esse aniversário.

Para pelo menos 2 pessoas terem a mesma data de aniversário, a probabilidade de 50% não é alcançado até que se tenha 613 pessoas. Essa enorme diferença de 33 contra 613 para probabilidade de 50% de pelo menos 2 pessoas com um aniversário em comum se deve ao fato de ter ou não uma data em particular.

Que algum evento improvável vai acontecer é normal; que um em particular vai acontecer é bem anormal. Se olharmos para nossas coincidências pessoais, vemos que elas foram raramente preditas com antecedência.

( **nota do Akita:** o que queremos dizer é o seguinte: coincidência acontecem. Dizer “improvável” não é “impossível”. 0.000001% ainda não é Zero. A diferença é que muito – mas muito mesmo – raramente é possível prever com antecedência um evento em particular, mesmo assim não impossível. Ou seja, acertar 1 previsão em milhares não é impossível. Acertar todas é altamente improvável. Essa é a natureza das coincidências: elas acontecem, por mais improváveis que sejam, é um fato, e não há nenhum agente sobrenatural lidando com isso, é apenas um evento aleatório matematicamente descritível. Prever que um certo evento vai acontecer “e” acertar também é absolutamente aleatório e não há nenhum poder místico ou intuitivo envolvido. É puramente como jogar dados e, por acaso, acertar um número. Não: você _não_ é um médium. :-)

### Abraham Lincoln e John Kennedy.

Sempre é possível combinar dados aleatórios e encontrar alguma regularidade. Um exemplo muito bem conhecido é a comparação das coincidências nas vidas de Abraham Lincoln e John Kennedy, dois presidentes com 7 letras em seus últimos nomes, e eleitos com 100 anos de diferença, 1860 e 1960. Ambos foram assassinados numa sexta-feira na presença de suas esposas, Lincoln no teatro Ford e Kennedy num automóvel feito pela Ford. Ambos assassinos tem 3 nomes: John Wilkes Booth e Lee Harvey Oswald, com 15 letras em cada nome completo. Oswald atirou em Kennedy de um armazém e correu para um teatro, e Booth atirou em Lincoln em um teatro e correu para um tipo de armazém. Ambos os sucessores vice-presidentes eram Democratas sulistas e ex-senadores chamados Johnson (Andrew e Lyndon), com 13 letras em seus nomes e nascidos com 100 anos de diferença, 1808 e 1908.

Mas se compararmos outros atributos relevantes falhamos em encontrar coincidências. Lincoln e Kennedy nasceram e morreram datas (dia e mês) e em estados diferentes, e nenhuma das datas é separada de 100 anos. Suas idades eram diferentes, assim como os nomes das esposas. Claro, se alguma dessas fosse correspondente estariam na lista de coincidências “misteriosas”. Para qualquer pessoa com vidas razoavelmente cheia de eventos é possível encontrar coincidências entre elas. Duas pessoas se encontrando numa festa normalmente encontram coincidências chocantes entre elas, mas o que são – aniversários, cidades natais, etc – não são previstos de antemão.

( **nota do Akita:** coincidências são **muito** mais comuns do que se imagina. Não somos tão diferentes assim quanto se pensa.)

### Mãos de Bridge

Em um jogo de cartas chamado Bridge é possível ter 635.013.559.600 diferentes mãos de 13 cartas. Esse número de mãos pode ser obtida se todas as pessoas no mundo jogassem bridge por um dia. Para um indivíduo isso levaria muitos milhões de anos de jogos contínuos para conseguir ter todas essas mãos. Mesmo assim qualquer mão obtida por um jogador é igualmente provável, ou melhor, igualmente improvável, já que suas probabilidades são 1/635.013.559.600 ou um pouco melhor do que 1 parte em 1 milhão. Qualquer mão tão improvável quanto 13 cartas de espada. Mãos de Bridge são um exemplo da ocorrência diária de eventos muito improváveis, mas claro, as mãos não são especificadas com antecedência.

Considere um grupo de apenas 10 ou mais estudantes em uma sala de aula de uma faculdade que tem estudantes de diversos estados. Durante uma sessão escolar, existem numerosas classes como essa. Mesmo assim as chances contra predizer exatamente a composição de qualquer sala com 10 anos de antecedência (com todos os estudantes e professores já nascidos nessa época) são verdadeiramente astronômicas. Esse é outro exemplo de ocorrências diárias de eventos altamente improváveis.

### Rodadas de Caras e Coroas

Que sequência de Caras (head – H) ou Coroa (tail – T) você poderia esperar das jogadas aleatórias de uma moeda? Nem tudo cara nem tudo coroa, nem mesmo cara e coroa alternados numa sequência como HTHTHTHT, já que essa série é obviamente regular e não aleatória. Em uma sequência aleatória esperamos jogadas de ambos cara e coroa. Podemos simular progressões de jogadas de moedas a partir de uma sequência aleatória de números.’

Até agora, como é conhecido, os dígitos decimais de números irracionais p, que multiplicam o diâmetro de um círculo para obter a circunferência, são aleatórios. Isso não significa que toda vez que p é calculado é obtido um resultado diferente, mas em vez disso que o valor de cada dígito único não é previsível a partir dos dígitos anteriores. Um exemplo desse tipo de padrão levando à previsibilidade é a sequência de dígitos decimais da fração 1/7 = 0,142857142857142857 …, onde há uma óbvia repetição (142857) a cada 6 dígitos.

Os dígitos decimais p foram calculadas até centenas de milhões de dígitos por computadores de alta-performance, mas listamos apenas os primeiros 100 dígitos em 4 linhas de 25 dígitos:

3,141592653589793238462643  
38327950288419716939937510  
582097494459230781\*64062862  
08\*9986280348253421170679

Existem 51 dígitos pares e 49 dígitos ímpares. Existe quase uma distribuição mediana quando os primeiros 100 dígitos decimais são divididos de outra maneira: 49 dígitos de 0 a 4 e 51 dígitos de 5 a 9.

Já que os dígitos decimais de p são aleatórios, podemos simular a sequência aleatória de caras e coroas assinalando dígitos pares para cara e ímpares para coroa. A sequência de caras e coroas em 100 jogadas com 25 por linha se torna (sendo T = coroa e H = cara):

THTTTHHTTTHTTTTHTHHHHHHT  
THTHTTTHHHHHTTTTHTTTTTTT  
THTHHHTTHTHHT\*THTHTHTH\*HHHHH  
HHHHTTHHHHHTHHHTTHHTTTHHTT

Combinando a sequência aleatória encontramos alguma regularidade, como a sequência de alternância em 8 jogadas de 62 a 69 (em negrito). A probabilidade de uma sequência alternada em 8 jogadas é 1 em 27 = 128 jogadas. Existem algumas longas sequências só de caras e só de coras. Existem 2 de 5 caras e 1 de 6 caras, 1 de 8 coroas e uma surpreendente de 10 coroas. Os dígitos decimais de p entre 69 e 78 são todos pares. Uma jogada de 10 dígitos pares deveria acontecer apenas 1 vez em 210 = 1.024 dígitos. Mesmo assim esse tipo de sequência aconteceu dentro dos primeiros 80 dígitos.

Então, o que temos aqui? Uma prova que os dígitos decimais de p não são aleatórios? Não, o que temos em vez disso é a demonstração de como é sempre possível combinar dados aleatórios e encontrar regularidades **não especificadas com antecedência**. Já que 10 dígitos pares acontecem nos primeiros 100 dígitos de p, poderíamos ( **erroneamente** ) achar que temos alguma coisa especial, e que esse tipo de sequência acontece frequentemente. De fato, uma sequência de 10 dígitos pares não acontece novamente nos primeiros mil dígitos de p. Nos primeiros mil dígitos uma única sequência de 10 ímpares acontece entre 411 e 420.

O ponto crucial é que a própria natureza da aleatoriedade garante que combinações de dados aleatórios vai dar em algum padrão. Mas o que esse padrão é não pode ser especificado com antecedência. Se alguém encontrar um padrão combinando dados aleatórios, ele ou ela pode usar isso com hipótese para investigar mais dados mas **nunca deve** chegar a uma conclusão geral disso. Em nosso exemplo nós descobrimos (mas não previmos) 10 dígitos ímpares em 100 dígitos mas não novamente nos próximos 900 dígitos. Para confirmar alguma tendência, os dados alvo precisam ser especificados com antecedência da inspeção dos dados. Se um padrão inesperado aparecer durante a inspeção depois que os dados foram obtidos, o padrão pode ser usado como uma hipótese para obter e inspecionar um conjunto complementamente novo de dados.

A sequência de caras e coroas pode ser aplicada de outras maneiras. Considere um quarterback de futebol americano que completa 50% de seus passes ou um jogador de basquete que pontua 50% de suas jogadas livres. Assinale cara (H) a um passe completo ou jogada livre e coroa (T) para uma perda, um erro, e então alguém pode espera longas sequências de acertos e erros como mostrado na sequência HT anterior. A maioria das sequências quentes ou frias em esportes são apenas a consequência de aleatoriedade. A “mão quente” é mais uma ilusão de significância que aparecem em conjuntos de dados que são aleatórios.

Podemos utilizar sequências aleatórias dos dígitos decimais de p para encontrar sequências prováveis para um batedor de baseball. Por exemplo, assinale os dígitos 0, 2 e 4 para batidas e os outros 7 dígitos para foras. Então, dos primeors 100 dígitos decimais existem 30 batidas e 70 foras. Se dividirmos a sequência de 100 dígitos em grupos sucessivos de 4, um número que representa batidas por jogo, obtemos os resultados para 25 jogos. Nosso batedor então vai sem conseguir bater por 4 jogos (3 em sucessão), dá um batida no 13o jogo, 2 batidas em 7 jogos, 3 batidas em um jogo e não tem um único jogo com 4 batidas. Surpreendentemente, o batedor tem pelo menos 1 batida nos últimos 13 jogos, considerado suficiente para ser uma sequência “real”. Mas essa sequência aparece a partir de uma sequência aleatória de dígitos decimais de p. A fase ruim e boa de um batedor parece apenas o resultado de uma jogada aleatória.

Claramente, coincidências improváveis não-especificadas acontecem diariamente em nossas vidas, e essas coincidências são muito mais o resultado de aleatoriedade. Se o conjunto de dados é grande o suficiente, coincidências vão aparecer, como demonstrado nos primeiros 100 dígitos decimais de p. As chances de conseguir 5 caras em sequência é de apenas 3%, mas para 100 jogadas as chances se aproximam de 96%. Embora aplicado em um contexto diferente, a teoria Ramsey (Scientific American, Julho 1990) diz que _“Cada conjunto grande de números, pontos ou objetos necessariamente contém um padrão altamente regular.”_ Não é necessário recorrer a forças misteriosas para explicar coincidências.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/1/fig3.gif)

> Figura 3: Simulação de Mercado de Ações: o mercado diário de ações apresentado como preço para 109 dias de transações gerados a partir da aleatoriedade dos dígitos decimais de p. A representação “topo da cabeça e ombro” (head and shoulders top) é mostrado como sendo consistente com jogadas aleatórias do mercado. Claro, o número de dias é flexível, um dígito decimal representa qualquer fração ou número de dias. [Veja anotações](#note) para uma descrição de como o preço das ações foi gerado.

### Preços Aleatórios no Mercado de Ações

Dada a fascinação atual pelo mercado de ações, podemos gerar resultados ainda mais interessantes a partir de dígitos decimais aleatórios de p. Vamos colocar em gráfico no eixo X o número de dígitos decimais e no eixo Y um valor de preço que é gerado a partir dos dígitos decimais descritos na Figura 3 e na [anotação](#note) de tal forma que exista um balanço arbitrário e igual entre direções de alta e baixa para preços.

Para os primeiros 108 dígitos decimais de p o gráfico inteiro está em território positivo. Começando com zero o gráfico começa a subir até atingir um platô nos dígitos 48 a 71 antes de começar a cair, quase retornando a zero no dígito 99, e cruzando para o território negativo depois do dígito 108. Para um técnico do mercado de ações esse gráfico representa um “topo da cabeça e ombros” em um gráfico de preços de ações ou preço de mercado de ações pelo tempo. Está tudo lá na Figura 3, um topo de cabeça e ombros. Mesmo assim esse gráfico foi gerado a partir dos primeiros 109 dígitos decimais aleatórios de p!

O valor máximo de 65 no eixo Y é alcançado 3 vezes na região de platô e é mais do que 7 vezes maior do que o máximo movimento único em 9. Portanto, podemos concluir que um ‘head and shoulders top’ em ações e preços de commodities podem ser representar nada mais do que jogos aleatórios nos mercados. (Depois de um longo período existe uma tendência de alta em mercados de ações na média.)

Um recente jogo recebido pelo correio oferecia um grande prêmio de US$ 5 milhões. As instruções diziam que as chances de ganhar o prêmio era de 1 em 200 milhões. Dentro dessa enorme população 1 pessoa ganhará o prêmio. Com tal incrível e desfavorável chance cada pessoas deve decidir para si se vale a pena o tempo e dinheiro gasto para mandar a carta. O verdadeiro grande ganhador parece ser o serviço postal, que ganha mais do que 10 vezes o prêmio principal.

Então, da próxima vez que ouvir, _“Isso não poderia ser só uma coincidência”,_ você estará mais do que justificado para responder, _“E por quê não?”_

### Concurso de Coincidências Presidenciais da CSICOP

De volta em 1992, a Skeptical Inquirer fez um concurso chamado Spooky Presidential Coincidences Contest, em resposta ao artigo “for the zillionth time”, de Ann Landers, que descrevia uma lista de arrepiantes paralelos entre John F. Kennedy e Abraham Lincoln. A tarefa era para leitores levantarem suas próprias listas de coincidências entre pares de presidentes. Teve 2 vencedores do concurso, Arturo Magidin da Cidade do México, e Chris Fishel, um estudante da Universidade da Virgínia. Magidin levantou 16 incríveis coincidências entre Kennedy e o presidente anterior do México Alvaro Obregón, enquanto Fishel levantou listas de coincidências de não menos do que 21 diferentes pares de presidentes americanos.

Alguns exemplos da lista de Magidin: Ambos “Kennedy” e “Obregón” tem 7 letras cada um; cada um deles foi assassinado; os assassinos de ambos têm 3 nomes e morreram quase logo depois de matarem os presidentes; Kennedy e Obregón ambos casaram em anos terminados em 3, cara um teve um filho que morreu pouco tempo depois de nascer; e ambos vieram de grandes famílias e morreram em seus 40 anos.

Fishel levantou dúzias de coincidências, aqui vão algumas: Thomas Jefferson e Andrew Jackson. Ambos serviram 2 mandatos completos; as esposas de ambos morreram antes de se tornarem presidentes; cada um tem 6 letras nos primeiros nomes; ambos estavam endividados no momento das mortes; cada um tinha uma capital de estado nomeados depois deles, e os predecessores de ambos recusaram aparecer nas suas inaugurações. [Para mais informações e as listas completas, veja SI Primavera 1992, 16(3); e Inverno 1993, 17(2).]

### Avisos

Estou em dívdia com o Professor Russell N. Grimes, da Universidade da Virgínia por discussões de expressões levando a Figura 2 e Tabela 2.

h3. Anotação

O preço da ação foi gerado em uma direção positiva quando o dígito precedente é ímpar (exceto para 5) e em uma direção negativa quando o dígito anterior é par, com a magnitude da direção dada pelo valor do dígito. Assim dígitos ímpares anteriores 1 + 3 + 7 + 9 = 20 geram um sentido positivo e dígitos pares anteriores 0 + 2 + 4 + 6 + 8 = 20 uma direção negativa. A soma dos dois sentidos é o mesmo. Para a esquerda ao longo do dígito 5, a direção é para cima ou para baixo, dependendo se o dígito anterior é ímpar ou par, respectivamente. Nos primeiros 108 dígitos decimais há oito 5s, cada metade gerando direções positivas e negativas. Portanto, temos equilíbrio perfeitamente arbitrário e igual entre direções positiva e o negativa.

### Referências

- Epstein, Richard A. 1967. [A Teoria dos Jogos e Lógica Estatística](http://csicop.org/q/book/012240761X). New York: Academic Press.

- Falk, Ruma. 1981. Em Coincidences. Skeptical Inquirer 6 (2): Inverno: 18-31.

- Graham, Ronald L., e Joel H. Spencer. 1990. Ramsey Theory. Scientific American 263 (1): 112-117 (Julho).

- Paulos, John Allen. 1988. [Innumeracy](http://csicop.org/q/book/0679726012). New York: Random House.

- Weaver, Warren. 1963. [Lady Luck](http://csicop.org/q/book/0486243427). Garden City, NY: Anchor Books.

### Sobre o Autor

**Bruce Martin** é Professor Emeritus de Química da Universidade de Virginia, Charlottesville, Virginia.

* * *

**notas finais do Akita:** apenas para ficar claro. “Acertos” em eventos aleatórios, encontro de “padrões”, também conhecidos como “coincidências”, simplesmente acontecem. Principalmente num universo grande de eventos aleatórios – ou mutuamente exclusivos.

O problema é quando resolvemos identificar esses padrões (fácil) e tentamos dar “sentidos” a essas sequências aleatoriamente coincidentes. Pior ainda: quando resolvemos atribuir sentidos de “causa e efeito” a esses eventos.

Suponha que alguém tenha tomado certa substância “H” que viu numa simpatia ou coisa parecida. E alguns dias depois, estava livre da enfermidade. Claro, ele dirá: _“graças à substância H, me curei!”_ e todos acreditarão. Mais ainda se várias pessoas relatarem a mesma coisa. Porém, nenhuma delas realmente investigou o caso. Tiraram conclusões depois do acontecimento dos fatos. Esse é o jeito errado.

Da forma correta, se formulássemos a hipótese de que tal substância “H” funciona, precisaríamos depois disso conseguir experimentalmente mais conjuntos de dados com resultados que ultrapassem os resultados que facilmente seriam obtidos através da própria aleatoriedade, como vimos acima. No caso do aniversário, basta 33 pessoas para encontrar 2 pessoas com o mesmo aniversário dentre um universo de 365 dias diferentes num ano!!

As pessoas só vão lembrar que, coincidentemente, mil pessoas se “curaram” com a tal substância “H”. Porém, ignoram que outras 10 mil, com a mesma enfermidade, tratadas com a mesma substância, não apresentaram melhoria nenhuma. Mas preferimos ignorar os 10 mil e apenas olhar os “grandiosos” mil positivos. Como se vê, números fora de contexto não servem para absolutamente nada.

