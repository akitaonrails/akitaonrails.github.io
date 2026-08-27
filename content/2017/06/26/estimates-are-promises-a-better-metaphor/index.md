---
title: "Estimativas São Promessas - Uma Metáfora Melhor"
date: '2017-06-26T17:44:00-03:00'
slug: estimativas-sao-promessas-uma-metafora-melhor
translationKey: estimates-are-promises
aliases:
- /2017/06/26/estimates-are-promises-a-better-metaphor/
description: "Estimativas podem virar promessas quando há gestão de risco: trave tempo e custo, priorize os primeiros 20% do escopo e use entregas em staging e velocidade como termômetros para ajustar o rumo."
tags:
- agile
- gestao
- engenharia-de-software
- off-topic
draft: false
---

Se você não sabia, eu respondo perguntas no Quora com frequência. [Me siga lá](https://www.quora.com/profile/Fabio-Akita); já escrevi quase 600 respostas, muitas parecidas com os posts mais longos daqui do blog.

Uma das mais populares responde à pergunta ["Qual é a coisa mais difícil que você faz como engenheiro de software?"](https://www.quora.com/What-is-the-hardest-thing-you-do-as-a-software-engineer/answer/Fabio-Akita). Escrevi algo parecido em português no post ["Estimativas são Promessas. Promessas devem ser cumpridas."](http://www.akitaonrails.com/2013/08/23/off-topic-estimativas-sao-promessas-promessas-devem-ser-cumpridas).

> Em resumo: você nunca consegue dar uma estimativa "correta". Se conseguisse, não seria uma "estimativa", seria uma "previsão".

Vamos assumir que não temos poderes de precognição nem bolas de cristal para prever o futuro.

Estimar algo é "chutar" o valor de alguma coisa. É sempre um chute, a mesma coisa que uma avaliação. Como todo chute, nunca pode ser considerado "correto": é só um candidato provável dentro de uma faixa infinita de valores possíveis.

> Não existe nenhuma conexão entre um chute e o resultado. Entenda essa verdade simples: dizer que algo pode acontecer não FAZ com que aconteça.

Estimar que vai chover amanhã não FAZ chover. Estimar o resultado do Super Bowl não FAZ o jogo acontecer daquele jeito. Não há correlação entre uma estimativa e o resultado real.

Eu disse nos artigos mencionados que **"Estimativas são Promessas"**. A intenção era provocar uma reação, porque a maioria das pessoas assume que estimativas jamais podem ser promessas, justamente pelo que acabei de explicar.

O que torna uma promessa especial é que, ao prometer algo, espera-se que você **AJA** para realizá-la.

![Skin in the Game](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/643/Skin-in-the-Game.png)

> Ninguém que não tem "skin in the game" deveria dar estimativas.

Se você não é um jogador ativo no jogo, não deveria dar chutes. Do mesmo jeito que ninguém faz promessas em nome de outra pessoa.

Dá pra fazer promessas críveis e cumpri-las? Dá, mas primeiro você precisa entender mais algumas verdades sobre a realidade.

Você provavelmente já leu muitos artigos explicando metodologias e técnicas de gestão de projetos. A maioria consegue explicar os "o quês" e os "comos", mas como sempre, falha nos "porquês".

Por que precisamos dessas metodologias? Por que elas são necessárias? Por que funcionam? Que mecanismos ocultos elas colocam em movimento?

O que diferencia as técnicas Ágeis da homeopatia ou de um clichê barato de autoajuda?

### É sempre sobre Pareto

Não existe escopo de projeto **preciso**. Existe um limite para adicionar detalhes, e depois dele você só tem [**retornos decrescentes**](http://www.investopedia.com/terms/l/lawofdiminishingmarginalreturn.asp).

O nível mais preciso de detalhe que o escopo de uma funcionalidade pode ter é o próprio código. E isso importa: as linhas de código **NÃO** são o produto final. O que os usuários experimentam de fato é a execução desse código em tempo de execução.

A programação em si é o **blueprint de verdade**. Os diagramas, os casos de uso, as user stories e tudo que vem antes da programação são só rascunho, um esboço.

Um arquiteto ou designer ingênuo pode achar que diagramas detalhados, documentos de casos de uso e slides bonitos de PowerPoint valem o mesmo que um blueprint de engenharia. Eles valem menos: são o equivalente a um **rabisco no guardanapo**. Voláteis e, na prática, quase inúteis.

![Napkin Sketch](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/644/Screenshot_from_2017-06-26_16-19-14.png)

_"Mas a programação não é a mesma coisa que a fase de construção, colocar tijolo sobre tijolo?"_ **NÃO**, não é isso que um programador faz. Empilhar tijolos é trabalho do interpretador da linguagem ou do compilador que gera o binário executável.

Essa é a metáfora que deixa os não-programadores malucos. Na engenharia, a construção em si é a parte mais cara e demorada. Na programação, a parte cara é criar o blueprint (escrever o código), e a "construção" é trivial: só compilar, o que é automático.

Do mesmo jeito, o escopo de um projeto é só um conjunto de esboços. Precisamos abandonar a ideia de que vai existir um escopo **"completo"**. Não dá pra dizer "100% do escopo" ou "escopo fechado", porque o escopo de um projeto de software é, por definição, sempre incompleto.

Além disso, sustento que cerca de 80% desse tal "escopo", o que prefiro chamar de esboço, é praticamente inútil para a maioria das atividades dos usuários finais: a seção administrativa, as páginas institucionais que ninguém lê, processos complicados de cadastro e por aí vai.

Por isso toda lista de funcionalidades **precisa** ser priorizada. Você costuma se virar com 20% das funcionalidades, que é o que as pessoas querem dizer com "MVP" ou "produto mínimo viável". **Entregue o mais cedo possível**, colete feedback dos usuários e refine o resto do "esboço" que você chama de backlog.

Então, em vez de mirar numa proposição de tudo-ou-nada, procurando equações complexas e estúpidas para calcular uma estimativa "precisa" de um esboço incompleto, assuma que dá pra entregar CEDO os primeiros 20% que realmente importam e descubra o resto em iterações.

É isso que chamamos de "Ágil", aliás.

### Ágil é sobre Gestão de Riscos

As pessoas assumem que Agilidade é gerenciar os próprios instrumentos de gestão: o backlog, os rituais, as métricas.

Ter instrumentos parecidos com Ágil não te torna Ágil.

Ser Ágil é manter o **Risco** sob controle.

Em vez de tratar projetos como uma proposição de tudo-ou-nada, comece a pensar como um investidor pensa no seu **portfólio de ações**. Você não espera que o portfólio inteiro dê lucro; parte do princípio de que alguns ativos vão ter desempenho abaixo do esperado. Como não sabe quais, você dilui o risco.

![Portfolio stocks](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/645/635824249336942840-ThinkstockPhotos-152955327.jpg)

Tentar prever o mercado de ações é um exercício de futilidade.

Tentar prever a implementação exata de um projeto, ainda mais os longos, também é um exercício de futilidade.

Então você precisa lidar com a incerteza do jeito certo: tornando-se [**Antifrágil**](https://www.amazon.com/Antifragile-Things-That-Disorder-Incerto/dp/0812979680).

> "Algumas coisas se beneficiam de choques; elas prosperam e crescem quando expostas à volatilidade, aleatoriedade, desordem e estressores, e adoram aventura, risco e incerteza. No entanto, apesar da ubiquidade do fenômeno, não existe uma palavra para o exato oposto de frágil. Vamos chamá-lo de antifrágil. A antifragilidade vai além da resiliência ou robustez. O resiliente resiste aos choques e permanece igual; o antifrágil melhora." - Nassim Taleb

Em vez do exercício absurdo e inútil de tentar prever incertezas e eventos aleatórios, você faz a coisa sensata: assume que Cisnes Negros existem e que você não consegue prevê-los. E aí se prepara para a incerteza da única forma razoável, que é não tentar prevê-los.

Exponha os pequenos erros cedo e corrija com frequência. Implementar tudo numa caixa-preta e fazer um deploy Big Bang é o caminho mais fácil para o **fracasso**. Entregar sempre, expor os bugs e corrigi-los constantemente é aceitar que erros vão acontecer e ganhar força no processo.

[![Antifragile](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/646/Antifragile-3.jpg)](https://www.amazon.com/Antifragile-Things-That-Disorder-Incerto/dp/0812979680)

### Uma Metáfora Melhor

![Iron Ore Furnace](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/642/steel_mill_blast_furnace_coking_coal_iron_ore_600.jpg)

Imagine que você, seja o cliente não-programador, seja o programador que não faz ideia de como explicar o processo para esse cliente, tem um alto-forno de minério de ferro para gerenciar.

O problema desses fornos é que, se você aquecer demais, eles podem explodir na sua cara. Se esfriar demais, o minério endurece.

Seu trabalho é adicionar carvão ao forno, e você decide o ritmo. Rápido demais, fica quente o bastante para explodir. Devagar demais, o fogo apaga e você perde o forno.

Agora tente estimar uma entrada constante de carvão para manter o forno em bom estado.

Não dá.

A saída mais fácil é instalar um **termômetro** que acompanha a temperatura atual do forno.

Você fica seguro dentro de uma certa margem de temperatura e acelera ou reduz a entrada de carvão consultando o termômetro o tempo todo.

O TEMPO TODO.

![Iron Furnace](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/647/iron-4.jpg)

É isso que a "Velocidade" do Ágil (ou qualquer simulação de Monte Carlo mais sofisticada) realmente é: um termômetro.

Se a Velocidade está alta demais, seu time provavelmente está fazendo hora extra ou entregando código de qualidade inferior. Isso vai dar problema: ou o time estoura rápido demais, ou o código acumula [dívida técnica](http://www.akitaonrails.com/2017/06/22/a-economia-do-desenvolvimento-de-software) rápido demais e você não vai conseguir pagar. Mantido esse ritmo, a Velocidade despenca até parar (o forno explode).

Se a Velocidade está baixa demais, seu time está enrolando, seu backlog é um lixo que ninguém entende nem depois de 10 horas de reunião, ou você deixou a Velocidade subir demais e agora está pagando a dívida técnica, ou seu time está morto de burnout (o fogo apagou).

Você quer manter a Velocidade **estável**, constante. É disso que se trata ser Ágil: ficar de olho no termômetro e responder.

### O Triângulo de Ferro dos Projetos

![Iron Triangle](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/650/ironTriangle.jpg)

Bem-vindo ao Triângulo de Ferro da Gestão de Projetos.

> Repita comigo: se eu quero travar o tempo, o custo e o escopo, **sou um idiota**.

Repita de novo.

Você deve travar tempo e custo. Se leu até aqui, sabe que nunca consegue travar o "escopo": só dá pra engordá-lo, e nem sempre torná-lo mais valioso. Por isso sempre digo que a definição de um Product Manager ou Product Owner é ser o guardião do ROI (Retorno sobre Investimento).

Por quê?

Porque o Triângulo de Ferro tem o seguinte corolário:

![Project Triangle](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/651/320px-Project-triangle.svg.png)

* Se quer rápido e bom, não pode ser barato
* Se quer rápido e barato, não pode ser bom
* Se quer bom e barato, não pode ser rápido

Isso é uma Lei, não tem como contornar. Escolha o seu.

![Make your choice](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/652/keep-calm-and-make-your-choice-9.png)

### Como Cumprir Promessas então?

Com essas 3 verdades em mãos:

* Não dá pra ter tudo ao mesmo tempo (barato, rápido e bom)
* Você está gerenciando a temperatura do forno
* Você só precisa de 20% do "esboço" que chama de "escopo"

Sim, qualquer desenvolvedor experiente consegue te dar uma estimativa de "ballpark". Uma estimativa de ballpark é assim:

* 1 mês (talvez 1 mês e meio, mas com certeza menos de 2)
* 3 meses (mais de 2 meses, menos de 6)
* 6 meses (mais de 4 meses, menos de 9)
* mais de 6 meses, provavelmente menos de 1 ano

Nem tente granular mais que isso. É inútil.

**Trave o tempo.** E **trave o custo** (o número de desenvolvedores vezes a taxa horária vezes o total de horas estimadas). Só isso.

Agora anote o que o cliente chama de "escopo" como user stories num backlog e peça pra ele priorizar.

Comece as iterações. Depois de cada uma, faça deploy num ambiente de staging. Não-programadores, atenção: SEMPRE garanta que o programador que você contratar entregue versões testáveis das stories numa URL pública que você possa visitar e testar.

Se o programador recusar isso ou vier com desculpa: **DEMITA**.

Se o programador, a empresa ou seja lá o que for te prometer um preço de "escopo fechado", prometer fazer tudo e você acreditar, você é ingênuo demais.

Acha graça em jogar esse jogo idiota de _"vou fingir que sei a verdade e você vai fingir que acredita no que estou dizendo"_?

![Actions and Words](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/648/e433998315b73da036e65884b67eba43.jpg)

Nenhum profissional sério tem tempo pra jogos idiotas. A única coisa honesta que alguém pode dizer sobre qualquer projeto de software é: _"com base na minha experiência, acredito que o ballpark para esse tipo de projeto é de X meses, dados os pressupostos Y e Z"._

Você não precisa acreditar nele. Só precisa começar a verificar o termômetro. Qualquer não-programador consegue avaliar a qualidade da entrega a partir das entregas frequentes das funcionalidades priorizadas.

_"Mas e se depois de 2 semanas eu não gostar do resultado?"_ Simples: **DEMITA**.

E às vezes "demitir" nem é a palavra certa. Às vezes o relacionamento é difícil e o melhor é seguir caminhos separados.

Você precisa aceitar perder 2 semanas, ou qualquer período curto, como parte da Gestão de Riscos. É melhor aceitar perder 2 semanas do orçamento do projeto do que acreditar cegamente em alguém por 6 meses e perder o orçamento inteiro e mais um pouco.

Pareto de novo: Agilidade é sobre Gestão de Riscos. Você aceita que perder 20% do orçamento está de bom tamanho e joga com isso. E tudo bem, porque você só precisa de um pouco mais de 20% do esboço vago que chama de escopo.

Viu o que fiz com a matemática aqui?

Paramos de jogar o faz-de-conta e passamos a gerenciar de fato os riscos do projeto. Você colabora no termômetro equivalente, que combina o backlog priorizado (a escala) e a velocidade (a temperatura), e fica de olho nas entregas parciais no ambiente de staging.

### Conclusão

Então sim, Estimativas devem ser levadas tão a sério quanto Promessas. Você consegue dar Estimativas razoáveis desde que consiga gerenciar os Riscos e o Cliente aceite as regras do jogo: não existe "escopo fechado e completo", prioridades primeiro, e testar e aceitar funcionalidades entregues toda semana.

A ideia por trás das Promessas é que você precisa **GERENCIAR** para cumpri-las. A melhor forma é parar com frequência, reavaliar e seguir. Parece perda de tempo, mas é assim que você evita desperdiçar tempo de verdade.

Se você não tem skin in the game, dê um passo atrás.

A Velocidade deve ser mantida estável, num ritmo previsível. Use a variância como sinal de estar rápido demais ou devagar demais, ajuste a outra variável, meça de novo e siga. Igual a um termômetro de forno.

Existem várias versões de "termômetros", do [Evidence Based Scheduling](https://www.joelonsoftware.com/2007/10/26/evidence-based-scheduling/) do Joel Spolsky às sofisticadas simulações de Monte Carlo e outros processos estocásticos (todos são termômetros, e NÃO ferramentas de estimativa).

O que te impede de fazer isso é usar as metáforas e as referências erradas.

Em vez de procurar metáforas equivalentes na construção civil, nas fábricas e em outras montagens de "hard"-ware, olhe para outro lugar, onde você vai encontrar processos de "soft"-ware.

Músicos têm prazos. Pintores têm prazos. Coreógrafos têm prazos. Esportes têm prazos. Laboratórios de pesquisa têm prazos. Como eles cumprem? Verificando constantemente o estado atual, comparando com os objetivos, avaliando se o que fazem está funcionando e mudando o que não funciona.

![Conducting Star Wars](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/649/conducting_starwars.jpg)

Hollywood tem prazos. Tem variáveis muito piores de controlar do que qualquer projeto de software que você vá encontrar, e ainda assim entrega. E lucra.

Aceite que você não controla todas as variáveis e pare de tentar. Pense nos mercados financeiros. Um dia o [Ethereum dispara 4.000%](https://web.archive.org/web/20170705022520/https://motherboard.vice.com/en_us/article/zme78x/why-the-value-of-ethereum-has-skyrocketed-4000-percent) e no dia seguinte [despenca num flash-crash](http://www.cnbc.com/2017/06/22/buyers-beware-lessons-from-the-ethereum-flash-crash.html).

Não tente ficar resistente ou resiliente. Prepare-se para ser Antifrágil.
