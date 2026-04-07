---
title: "[Off-Topic] Aprendendo Estatística"
date: '2016-11-01T17:03:00-02:00'
slug: off-topic-aprendendo-estatistica
translationKey: learning-statistics-off-topic
aliases:
- /2016/11/01/off-topic-learning-statistics/
tags:
- off-topic
- statistics
- R
- carreira
- traduzido
draft: false
---

Eu sempre falo pedaços e mais pedaços sobre estatística e, como [cético assumido](http://www.akitaonrails.com/science), acredito que consigo pensar além do "senso comum" no qual a maioria das pessoas se apoia. Estou muito acostumado com vieses, dados enviesados, perguntas erradas que levam a respostas erradas.

Eu até consigo apontar por que um certo argumento está errado. Mas sou bem incompetente no caminho contrário: dada uma coleta de dados decente, como fazer uma análise exploratória apropriada? Quais são as metodologias corretas para cada cenário? E claro, toda a matemática envolvida.

Por exemplo, acabei de publicar 2 artigos justamente para tentar lançar luz sobre isso: o "senso comum" da maioria dos desenvolvedores ao lidar com dados se resume a agregações primitivas como somas e médias. Comece a falar de "desvio padrão" e você já perdeu metade da população de devs. Comece a falar de distribuições binomiais ou de poisson e perdeu a metade restante. Agora entre em regressão linear, estatística bayesiana, e quase todo mundo já saiu da sala.

Estamos no século XXI. [A cada 60 segundos](http://www.smartinsights.com/internet-marketing-statistics/happens-online-60-seconds/), o Facebook recebe mais 3,3 milhões de novos posts; o YouTube recebe 400 horas de vídeos; o Instagram recebe 55.555 fotos enviadas; o WhatsApp troca 44,4 milhões de mensagens; até e-mail, mais de 206 milhões deles estão sendo enviados. Quando você terminar de ler este post, pode multiplicar esse volume por 5 ou 10!

> "Estamos nos afogando em informação,

> mas famintos por conhecimento"

> – Vários autores, o original provavelmente é de John Naisbitt

Vou passar algumas semanas mergulhando em [R](https://www.r-project.org/). Sim, muita gente vai falar de Julia, mas é impossível negar o impressionante corpo de conhecimento, a experiência e o conjunto robusto e extenso de pacotes disponíveis para R, incluindo material de aprendizado. Existe uma ótima ferramenta chamada [RStudio](https://blog.rstudio.org/2016/11/01/announcing-rstudio-v1-0/) que acabou de ter seu lançamento 1.0.

E entre os vários materiais que reuni, um se destacou só pela introdução (ainda preciso revisar o livro como um todo). Ele se chama ["Learning Statistics with R"](http://health.adelaide.edu.au/psychology/ccs/teaching/lsr/), de Daniel Navarro, da Universidade de Adelaide, na Austrália. Acho interessante porque é um professor de psicologia ensinando estatística de verdade através do básico de R, que é exatamente o que eu queria. Você pode comprar uma edição impressa ou baixar o PDF gratuito.

Gostei tanto da introdução que quis compartilhar alguns parágrafos para motivar você a se juntar a mim para aprender estatística melhor. Então vamos direto ao ponto:

### O conto de advertência do paradoxo de Simpson

A seguir uma história verdadeira. Em 1973, a Universidade da Califórnia em Berkeley se meteu em encrenca por causa das admissões de alunos para cursos de pós-graduação. Especificamente, o problema foi que a divisão por gênero das admissões era assim ...

```
            Número de candidatos    Percentual admitido
Homens           8442                    44%
Mulheres         4321                    35%
```

... e eles **foram processados**. Considerando que havia quase 13.000 candidatos, uma diferença de 9% nas taxas de admissão entre homens e mulheres é grande demais para ser coincidência. Dados bem convincentes, certo? E se eu te dissesse que esses dados na verdade refletem um leve viés a favor das mulheres, você provavelmente acharia que sou louco ou sexista.

Curiosamente, isso é meio que verdade ... depois que Berkeley foi processada, começaram a olhar os dados de admissão com muito cuidado (Bickel, Hammel, & O'Connell, 1975). E surpreendentemente, quando analisaram departamento por departamento, descobriram que a maioria dos departamentos tinha, na verdade, uma taxa de aprovação ligeiramente maior para as candidatas do que para os candidatos. A tabela abaixo mostra os números de admissão dos seis maiores departamentos (com os nomes removidos por questões de privacidade):

```
                       Homens                         Mulheres
Departamento  Candidatos   % admitidos   Candidatas   % admitidas
A                 825          62%            108          82%
B                 560          63%             25          68%
C                 325          37%            593          34%
D                 417          33%            375          35%
E                 191          28%            393          24%
F                 272           6%            341           7%
```

Surpreendentemente, a maioria dos departamentos teve taxa de admissão _maior_ para mulheres do que para homens! E mesmo assim a taxa geral de admissão na universidade era _menor_ para mulheres do que para homens. Como isso é possível? Como ambas as afirmações podem ser verdadeiras ao mesmo tempo?

Eis o que está acontecendo. Primeiro, repare que os departamentos não são iguais entre si em termos de percentual de admissão: alguns departamentos (por exemplo, engenharia, química) tendiam a admitir uma alta porcentagem dos candidatos qualificados, enquanto outros (por exemplo, inglês) tendiam a rejeitar a maioria dos candidatos, mesmo os de alta qualidade.

Então, entre os seis departamentos mostrados acima, repare que o departamento A é o mais generoso, seguido por B, C, D, E e F nessa ordem. Em seguida, repare que homens e mulheres tendiam a se candidatar a departamentos diferentes. Se ordenarmos os departamentos pelo número total de candidatos homens, temos **A** > **B** > D > C > F > E (os departamentos "fáceis" estão em negrito).

No geral, os homens tendiam a se candidatar aos departamentos com altas taxas de admissão. Agora compare isso com a forma como as candidatas mulheres se distribuíram. Ordenar os departamentos pelo número total de candidatas produz uma ordem bem diferente: C > E > D > F > **A** > **B**.

Em outras palavras, esses dados parecem sugerir que as candidatas mulheres tendiam a se candidatar aos departamentos "mais difíceis".

![Figura 1](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/571/Screen_Shot_2016-11-01_at_16.58.47.png)

E de fato, se olharmos para toda a Figura 1.1, vemos que essa tendência é sistemática e bem marcante. Esse efeito é conhecido como **paradoxo de Simpson**. Não é comum, mas acontece na vida real, e a maioria das pessoas fica muito surpresa quando se depara com ele pela primeira vez, e muita gente se recusa até a acreditar que seja real. É bem real. E embora haja várias lições estatísticas sutis enterradas aí, quero usá-lo para fazer um ponto bem mais importante . . . fazer pesquisa é difícil, e existem várias armadilhas sutis e contraintuitivas à espreita para os incautos. Esse é o motivo #2 pelo qual cientistas amam estatística e pelo qual ensinamos métodos de pesquisa. Porque ciência é difícil, e a verdade às vezes está astutamente escondida nos cantos e recantos de dados complicados.

Antes de deixar esse tópico de vez, quero apontar outra coisa realmente crítica que costuma ser ignorada numa aula de métodos de pesquisa. A estatística só resolve parte do problema. Lembre-se de que começamos toda essa história com a preocupação de que o processo de admissão de Berkeley pudesse estar injustamente enviesado contra as candidatas. Quando olhamos os dados "agregados", parecia mesmo que a universidade discriminava as mulheres, mas quando "desagregamos" e olhamos o comportamento individual de todos os departamentos, descobrimos que os departamentos em si eram, se algo, levemente enviesados a favor das mulheres.

O viés de gênero no total das admissões foi causado pelo fato de que as mulheres tendiam a se autosselecionar para os departamentos mais difíceis. De um ponto de vista puramente jurídico, isso deixa a universidade livre. As admissões de pós-graduação são decididas no nível do departamento individual (e há ótimas razões para fazer assim), e no nível dos departamentos individuais as decisões são mais ou menos imparciais (o leve viés a favor das mulheres nesse nível é pequeno e não consistente entre os departamentos). Como a universidade não pode ditar a quais departamentos as pessoas escolhem se candidatar, e a tomada de decisão acontece no nível do departamento, dificilmente pode ser responsabilizada por quaisquer vieses que essas escolhas produzam.

Essa foi a base para meus comentários meio irreverentes lá no começo, mas essa não é exatamente a história toda, certo? Afinal, se estamos interessados nisso de uma perspectiva mais sociológica e psicológica, talvez queiramos perguntar por que existem diferenças de gênero tão fortes nas candidaturas. Por que homens tendem a se candidatar a engenharia com mais frequência do que mulheres, e por que isso se inverte no departamento de inglês? E por que os departamentos que tendem a ter um viés de candidatura feminina tendem a ter taxas gerais de admissão mais baixas do que aqueles com viés de candidatura masculina? Isso não poderia ainda assim refletir um viés de gênero, mesmo com cada departamento individualmente sendo imparcial? Pode ser que sim.

Suponha, hipoteticamente, que homens preferissem se candidatar a "ciências exatas" e mulheres preferissem "humanidades". E suponha ainda que a razão pela qual os departamentos de humanidades têm baixas taxas de admissão seja porque o governo não quer financiar humanidades (vagas de doutorado, por exemplo, costumam estar atreladas a projetos de pesquisa financiados pelo governo). Isso constitui um viés de gênero? Ou apenas uma visão pouco esclarecida sobre o valor das humanidades? E se alguém em alto escalão no governo cortasse os fundos de humanidades porque achava que humanidades são "coisinha de mulher inútil"? Isso parece bem flagrantemente enviesado por gênero. Nada disso cabe no escopo da estatística, mas importa para o projeto de pesquisa.

Se você se interessa pelos efeitos estruturais gerais de vieses sutis de gênero, então provavelmente quer olhar tanto os dados agregados quanto os desagregados. Se você se interessa pelo processo de tomada de decisão dentro da própria Berkeley, então provavelmente só se interessa pelos dados desagregados.

Em resumo, há várias perguntas críticas que você não consegue responder com estatística, mas as respostas a essas perguntas terão um impacto enorme em como você analisa e interpreta os dados. E é por isso que você deve sempre pensar na estatística como uma ferramenta para te ajudar a aprender sobre seus dados, nem mais nem menos. É uma ferramenta poderosa para esse fim, mas não há substituto para o pensamento cuidadoso.

### Baixe o Livro

Ficou intrigado? Então [baixe o livro](http://health.adelaide.edu.au/psychology/ccs/teaching/lsr/) e vamos estudar um pouco de estatística além do básico. Não estou dizendo que esse é o melhor livro, apenas um que parece interessante, e se você por acaso conhece um bom livro que ensine estatística para iniciantes através do uso de R sem nenhum conhecimento prévio, me diga na seção de comentários abaixo.
