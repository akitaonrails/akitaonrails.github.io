---
title: "Estimativas São Promessas - Uma Metáfora Melhor"
date: '2017-06-26T17:44:00-03:00'
slug: estimativas-sao-promessas-uma-metafora-melhor
translationKey: estimates-are-promises
aliases:
- /2017/06/26/estimates-are-promises-a-better-metaphor/
tags:
- off-topic
- principles
- management
- agile
- traduzido
draft: false
---

Se você não sabia, eu respondo perguntas no Quora com frequência. [Me siga lá](https://www.quora.com/profile/Fabio-Akita) — até agora escrevi quase 600 respostas, muitas delas parecidas com os posts mais longos daqui do blog.

Uma das respostas mais populares trata do assunto ["Qual é a coisa mais difícil que você faz como engenheiro de software?"](https://www.quora.com/What-is-the-hardest-thing-you-do-as-a-software-engineer/answer/Fabio-Akita). Escrevi uma resposta parecida em português no post ["Estimativas são Promessas. Promessas devem ser cumpridas."](http://www.akitaonrails.com/2013/08/23/off-topic-estimativas-sao-promessas-promessas-devem-ser-cumpridas).

> Em resumo: você nunca consegue dar uma estimativa "correta". Se conseguisse, não seria uma "estimativa" — seria uma "previsão".

Vamos assumir que não temos poderes de precognição nem bolas de cristal mágicas para prever o futuro.

Estimar algo é "chutar" o valor de algo. É sempre um chute. É a mesma coisa que uma avaliação. E como qualquer chute, nunca pode ser considerado "correto". É apenas um candidato provável dentro de uma faixa infinita de valores possíveis.

> Não existe nenhuma conexão entre um chute e o resultado. Entenda essa verdade simples: dizer que algo pode acontecer não FAZ com que aconteça.

Estimar que vai chover amanhã não FAZ chover. Estimar o resultado do Super Bowl não FAZ acontecer. Portanto, não há correlação entre uma estimativa e o resultado real.

Eu disse nos artigos mencionados que **"Estimativas são Promessas"**. A intenção era provocar uma reação, já que a maioria das pessoas assume que estimativas jamais podem ser promessas — exatamente pelo que acabei de explicar.

O que torna uma promessa especial é que, ao prometer algo, espera-se que você **AJA** para realizá-la.

![Skin in the Game](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/643/Skin-in-the-Game.png)

> Ninguém que não tem "skin in the game" deveria dar estimativas.

Se você não é um jogador ativo no jogo, não deveria dar chutes. Da mesma forma que ninguém faz promessas em nome de outra pessoa.

Você consegue fazer promessas críveis e cumpri-las? Sim, consegue — mas primeiro precisa entender mais algumas verdades sobre a realidade.

Você provavelmente já leu muitos artigos explicando metodologias e técnicas de gerenciamento de projetos. A maioria deles até que consegue explicar os "o quês" e os "comos", mas como sempre, falham em explicar os "porquês".

Por que precisamos dessas metodologias? Por que elas são necessárias? Por que funcionam? Quais são os mecanismos ocultos que elas colocam em movimento?

O que diferencia as técnicas Ágeis da homeopatia ou do clichê de autoajuda barata?

### É sempre sobre Pareto

Não existe escopo de projeto **preciso**. Existe um limite para adicionar detalhes, depois do qual você passa a ter [**retornos decrescentes**](http://www.investopedia.com/terms/l/lawofdiminishingmarginalreturn.asp).

O nível mais preciso de detalhe que o escopo de uma funcionalidade pode ter é o próprio código. Isso é importante: as linhas de código da programação **NÃO** são o produto final. O que os usuários vão de fato experimentar é a execução desse código em tempo de execução.

A programação em si é o **blueprint real**. Os diagramas, os casos de uso, as user stories ou qualquer outra coisa que vem antes da programação são apenas rascunho — um mero esboço.

Um arquiteto ou designer ingênuo pode achar que diagramas detalhados, documentos de casos de uso e slides bonitos de PowerPoint têm o mesmo valor que um blueprint de engenharia. Mas não têm: são o equivalente a um **rabisco no guardanapo**. Voláteis e, na prática, quase inúteis.

![Napkin Sketch](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/644/Screenshot_from_2017-06-26_16-19-14.png)

_"Mas a programação não é a mesma coisa que a fase de construção, colocar tijolo sobre tijolo?"_ - **NÃO**, isso não é o que um programador faz. O trabalho de empilhar tijolos cabe ao interpretador da linguagem ou ao compilador que gera o binário executável.

Essa é a metáfora que deixa os não-programadores malucos: na engenharia, a construção em si é a parte mais cara e demorada. Na programação, a parte cara é criar o blueprint (escrever o código), e a "construção" é trivial (só compilar, o que é automático).

Da mesma forma, o escopo de um projeto é apenas um conjunto de esboços. Precisamos abandonar a ideia de que vai existir um escopo **"completo"** de projeto. Não tem como dizer "100% do escopo" ou "escopo fechado", porque o escopo de um projeto de software é, por definição, sempre incompleto.

Além disso, vou argumentar que aproximadamente 80% desse tal "escopo" — o que prefiro chamar de esboço — é praticamente inútil para a maioria das atividades dos usuários finais (a seção administrativa, as páginas institucionais que ninguém lê, processos complicados de cadastro, etc).

Por isso toda lista de funcionalidades **precisa** ser priorizada. Você geralmente consegue se virar com 20% das funcionalidades (é isso que as pessoas querem dizer quando falam em "MVP" ou "produto mínimo viável"). **Entregue o mais cedo possível**, colete feedback dos usuários e refine o resto do "esboço" que você chama de backlog.

Então, em vez de buscar uma proposição de tudo-ou-nada tentando achar equações complexas e estúpidas para calcular uma estimativa "precisa" de um esboço incompleto, assuma que você consegue entregar CEDO — os primeiros 20% que realmente importam — e descubra o resto em iterações.

É isso que chamamos de "Ágil", aliás.

### Ágil é sobre Gestão de Riscos

As pessoas assumem que Agilidade é sobre gerenciamento de projetos no sentido de gerenciar os próprios instrumentos de gerenciamento: o backlog, os rituais, as métricas.

Ter instrumentos parecidos com Ágil não te torna Ágil.

Ser Ágil é manter o **Risco** sob controle.

Em vez de pensar em projetos como uma proposição de tudo-ou-nada, você precisa começar a pensar como um investidor pensa no seu **portfólio de ações**. Você não espera que todo o portfólio dê lucro — na verdade, você assume que alguns ativos vão ter desempenho abaixo do esperado. Só não sabe quais, então você dilui o risco.

![Portfolio stocks](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/645/635824249336942840-ThinkstockPhotos-152955327.jpg)

Tentar prever o mercado de ações é um exercício de futilidade.

Tentar prever a implementação precisa de um projeto — especialmente os longos — também é um exercício de futilidade.

Então você precisa lidar com a incerteza do jeito certo: tornando-se [**Antifrágil**](https://www.amazon.com/Antifragile-Things-That-Disorder-Incerto/dp/0812979680).

> "Algumas coisas se beneficiam de choques; elas prosperam e crescem quando expostas à volatilidade, aleatoriedade, desordem e estressores, e adoram aventura, risco e incerteza. No entanto, apesar da ubiquidade do fenômeno, não existe uma palavra para o exato oposto de frágil. Vamos chamá-lo de antifrágil. A antifragilidade vai além da resiliência ou robustez. O resiliente resiste aos choques e permanece igual; o antifrágil melhora." - Nassim Taleb

Em vez do exercício absurdo e inútil de tentar prever incertezas e eventos aleatórios, você faz a coisa razoável: assume que Cisnes Negros existem e que você não consegue prevê-los. Então se prepara para a incerteza da única forma razoável: não tentando prevê-los.

Exponha os pequenos erros cedo, corrija-os com frequência. Implementar tudo numa caixa-preta e fazer um deploy Big Bang é o caminho mais fácil para o **fracasso**. Entregar com frequência, expor os bugs e corrigi-los constantemente é aceitar que erros vão acontecer e ganhar força no processo.

[![Antifragile](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/646/Antifragile-3.jpg)](https://www.amazon.com/Antifragile-Things-That-Disorder-Incerto/dp/0812979680)

### Uma Metáfora Melhor

![Iron Ore Furnace](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/642/steel_mill_blast_furnace_coking_coal_iron_ore_600.jpg)

Imagine que você — seja o cliente não-programador, seja o programador que não faz ideia de como explicar o processo para o cliente não-programador — tem um alto-forno de minério de ferro para gerenciar.

O problema com esses fornos é que, se você aquecer demais, eles podem explodir na sua cara. Se esfriar demais, o minério endurece.

Seu trabalho é adicionar carvão ao forno. Você decide o ritmo. Se for rápido demais, fica quente o suficiente para explodir. Se for devagar demais, você pode apagar o fogo e perder o forno.

Agora, tente fazer uma estimativa de uma entrada constante de carvão para manter o forno em bom estado.

Não consegue.

A saída mais fácil é instalar um **termômetro** que acompanha a temperatura atual do forno.

Você fica seguro dentro de uma certa margem de temperaturas e acelera ou desacelera a entrada de carvão verificando o termômetro o tempo todo.

O TEMPO TODO.

![Iron Furnace](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/647/iron-4.jpg)

Isso é o que a "Velocidade" do Ágil (ou qualquer simulação de Monte Carlo mais sofisticada) realmente é: um termômetro.

Se a Velocidade está alta demais, seu time provavelmente está fazendo hora extra ou entregando código de qualidade inferior. Isso vai dar problema — seu time vai estourar rápido demais ou o código está acumulando [dívida técnica](http://www.akitaonrails.com/2017/06/22/a-economia-do-desenvolvimento-de-software) rápido demais e você não vai conseguir pagar. A Velocidade vai cair até parar se você mantiver esse ritmo (o forno explode).

Se a Velocidade está baixa demais, seu time está enrolando, seu backlog é um lixo inútil que ninguém consegue entender mesmo depois de 10 horas de reunião, ou você já deixou a Velocidade ficar alta demais e agora está pagando a dívida técnica, ou seu time está morto de burnout (o fogo apagou).

Você quer manter a Velocidade **estável**, constante. É disso que se trata ser Ágil: ficar de olho no termômetro e responder.

### O Triângulo de Ferro dos Projetos

![Iron Triangle](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/650/ironTriangle.jpg)

Bem-vindo ao Triângulo de Ferro do Gerenciamento de Projetos.

> Repita comigo: se eu quero travar o tempo, o custo e o escopo, **sou um idiota**.

Repita de novo.

Você deve travar tempo e custo, e se leu até aqui, sabe que nunca consegue travar o "escopo" — só pode engordá-lo (e não necessariamente torná-lo mais valioso). Por isso sempre digo que a própria definição de um Product Manager ou Product Owner é ser o guardião do ROI (Retorno sobre Investimento).

Por quê?

Porque o Triângulo de Ferro tem o seguinte corolário:

![Project Triangle](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/651/320px-Project-triangle.svg.png)

* Se quer rápido e bom, não pode ser barato
* Se quer rápido e barato, não pode ser bom
* Se quer bom e barato, não pode ser rápido

Isso é uma Lei. Não tem como contornar. Escolha o seu.

![Make your choice](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/652/keep-calm-and-make-your-choice-9.png)

### Como Cumprir Promessas então?

Com essas 3 verdades em mãos:

* Não dá pra ter tudo ao mesmo tempo (barato, rápido e bom)
* Você está gerenciando a temperatura do forno
* Você só precisa de 20% do "esboço" que chama de "escopo"

Sim, qualquer desenvolvedor experiente consegue te dar uma estimativa de "ballpark". Uma estimativa de ballpark vai assim:

* 1 mês (talvez 1 mês e meio, mas definitivamente menos de 2)
* 3 meses (é mais de 2 meses, menos de 6 meses)
* 6 meses (é mais de 4 meses, menos de 9 meses)
* é mais de 6 meses, provavelmente menos de 1 ano

Nem tente granular mais do que isso. É inútil.

**Trave o tempo.** E **trave o custo** (que é o número de desenvolvedores vezes a taxa horária vezes o total de horas estimadas). Só isso.

Agora anote o que o cliente chama de "escopo" como user stories num backlog e peça pra ele priorizar.

Comece as iterações. Após cada iteração, faça o deploy num ambiente de staging. Não-programadores, atenção: SEMPRE garanta que o programador que você contratar entregue versões testáveis das stories entregues em uma URL publicamente disponível que você possa visitar e testar.

Se o programador recusar isso ou der desculpas: **DEMITA**.

Se o programador, empresa ou seja lá o que for te prometer um preço de "escopo fechado", prometer fazer tudo e você acreditar — você é ingênuo demais.

Acha engraçado jogar esse jogo idiota de _"vou fingir que sei a verdade e você vai fingir que acredita no que estou dizendo"_?

![Actions and Words](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/648/e433998315b73da036e65884b67eba43.jpg)

Nenhum profissional sério tem tempo para jogar jogos idiotas, e a única coisa honesta que qualquer um pode dizer sobre qualquer projeto de software é: _"com base na minha experiência, acredito que o ballpark para esse tipo de projeto é de X meses, dados os pressupostos Y e Z"._

Você não precisa acreditar nele. Só precisa começar a verificar o termômetro. Qualquer não-programador consegue avaliar a qualidade da entrega com base nas entregas frequentes das funcionalidades priorizadas.

_"Mas e se depois de 2 semanas eu não gostar dos resultados?"_ Simples: **DEMITA**.

E às vezes "demitir" nem é a palavra certa. Às vezes o relacionamento é difícil e a melhor coisa é seguir caminhos separados.

Você precisa aceitar perder 2 semanas — ou qualquer período curto de tempo — como parte da Gestão de Riscos. É melhor aceitar perder 2 semanas do orçamento do projeto do que ter que acreditar cegamente em alguém por 6 meses e ter que perder o orçamento inteiro do projeto e um pouco mais.

Pareto de novo: Agilidade é sobre Gestão de Riscos. Você aceita que perder 20% do orçamento é ok. E joga com isso. Mas tudo bem, porque você só precisa de um pouco mais de 20% do esboço vago que você chama de escopo.

Viu o que fiz com a matemática aqui?

Paramos de jogar o jogo do faz-de-conta e de fato gerenciamos os riscos do projeto. Você colabora no termômetro equivalente, que é uma combinação do backlog priorizado (a escala), a velocidade (a temperatura), e fica de olho nas entregas parciais no ambiente de staging.

### Conclusão

Então sim, Estimativas devem ser levadas tão a sério quanto Promessas. Você consegue dar Estimativas razoáveis desde que consiga gerenciar os Riscos e o Cliente aceite as regras do jogo (não existe "escopo fechado e completo", "prioridades primeiro" e "testar e aceitar funcionalidades entregues toda semana").

A ideia por trás das Promessas é que você precisa **GERENCIAR** para cumpri-las. A melhor forma de fazer isso é parar com frequência, reavaliar e então continuar. Parece perda de tempo, mas você está se salvando de desperdiçar tempo de verdade.

Se você não tem skin in the game, dê um passo atrás.

A Velocidade deve ser mantida estável. Não sempre crescendo. Não sempre volátil e imprevisível. Mantenha a velocidade em um ritmo previsível e use a variância como indicação de estar rápido demais ou devagar demais, ajuste a outra variável, meça de novo e continue. Igual a um termômetro de forno.

Existem várias versões de "termômetros", do [Evidence Based Scheduling](https://www.joelonsoftware.com/2007/10/26/evidence-based-scheduling/) do Joel Spolsky até as sofisticadas simulações de Monte Carlo e outros processos estocásticos (todos são termômetros e NÃO ferramentas de estimativa).

O que te impede de fazer isso é usar as metáforas e referências erradas.

Em vez de tentar encontrar metáforas equivalentes na construção civil, fábricas e outras montagens de "hard"-ware, olhe em outro lugar, onde você vai encontrar outros processos de "soft"-ware.

Músicos têm prazos. Pintores têm prazos. Coreógrafos têm prazos. Esportes têm prazos. Laboratórios de pesquisa têm prazos. Como eles os cumprem? Verificando constantemente o estado atual e comparando com os objetivos, avaliando se o que estão fazendo está funcionando e mudando o que não funciona.

![Conducting Star Wars](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/649/conducting_starwars.jpg)

Hollywood tem prazos. Tem variáveis muito piores para controlar do que qualquer projeto de software que você possa encontrar, e consegue entregar. E lucrar.

Aceite que você não consegue controlar todas as variáveis — para de tentar. Pense nisso como os mercados financeiros. Um dia você tem o [Ethereum disparando 4.000%](https://motherboard.vice.com/en_us/article/zme78x/why-the-value-of-ethereum-has-skyrocketed-4000-percent) e no dia seguinte [despencando em um flash-crash](http://www.cnbc.com/2017/06/22/buyers-beware-lessons-from-the-ethereum-flash-crash.html).

Não tente se tornar resistente ou resiliente. Prepare-se para se tornar Antifrágil.
