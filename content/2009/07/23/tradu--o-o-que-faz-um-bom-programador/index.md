---
title: "[Tradução] O que faz um bom programador?"
date: '2009-07-23T10:35:00-03:00'
slug: tradu--o-o-que-faz-um-bom-programador
tags:
- off-topic
- career
- translation
- carreira
draft: false
---

Muita gente já me perguntou como se tornar um bom programador. Normalmente estão mais preocupados em qual linguagem aprender, qual curso fazer, quais livros técnicos ler. Porém, assim como os autores desses dois artigos que vou traduzir, eu diria que existem qualidades mais importantes a se levar em conta.

O primeiro artigo é o [What makes a good programmer?](http://www.techfounder.net/2009/07/22/what-makes-a-good-programmer/)


### Um pensador analítico

Programadores precisam ser solucionadores de problemas. O processo de programação requer que nós sistematicamente quebremos problemas complicados, planejemos e implementemos solução e encontremos/eliminemos pequenas inconsistências no código (bugs).

Pensamento analítico também se manifesta na habilidade de seguir e entender lógicas complicadas através de segmentos disparates de código. Isso nos permite alcançar conceitos abstratos como metodologias de Orientação a Objetos e design patterns e implementemos na prática.

### Tem suas prioridades claras

Se eu lhe pedisse para ordenar os ítens seguintes por prioridade, como você os ordenaria?

- Segurança
- Mantenabilidade
- Usabilidade
- Performance
- quantidade de LOC (lines of code – linhas de código)

Pare um momento para pensar a respeito, e então considere:

1. Se você pegou **quantidade de LOC** primeiro, você falhou completamente pelos meus critérios. De fato, otimização de LOC pode normalmente ir diretamente contra as outras métricas (como mantenabilidade). Uma contagem baixa de LOC nunca deve ser o objetivo, somente o resultado da aplicação cuidadosa de uma boa arquitetura.
2. Se você pegou **performance** primeiro, você provavelmente é o cara que fica escrevendo artigos sobre porque se deveria usar loop _while_ em vez de _for_ já que ele foi alguns milissegundos mais rápido em seus benchmarks. Você pode sofrer com casos de otimização prematura.  
  

> Nós devemos esquecer sobre pequenas ineficiências, digamos, cerca de 97% do tempo: otimização prematura é a raíz de todo mal. – [Donald Knuth](http://en.wikipedia.org/wiki/Optimization_%28computer_science%29#When_to_optimize)

Performance deve ser bom o suficiente para satisfazer os requerimentos da aplicação. Fora casos de armadilha bem conhecidos (cmo executar queries em cada interação de um loop longo), otimizações de performance devem ser deixados para o fim e mesmo assim devem ser feitas quando apropriado (medir … medir … medir … otimizar).

A única exceção a isso é se você está primariamente desenvolvendo aplicações dependentes de performance (como drivers de baixo nível de sistema).

3. **Segurança** está mais ou menos no meio. Dependendo da aplicação e modelo distribuído isso pode ser completamente inútil ou de missão crítica. Está na maior parte no meio, e portanto não pode ser o número 1.
4. **Mantenabilidade** é definitivamente um dos mais importantes atributos de uma aplicação de software. Alta mantenabilidade permite que você melhore outros atributos (como performance), _quando for necessário._  
  
Mantenabilidade é o fator mais importante para manter a produtividade em alta e os custos em baixa. Por um longo tempo eu acreditei fortemente que isso era **o** atributo mais importante de design de software. Entretanto …
5. O atributo mais importante é **usabilidade**. No final, o valor de sua aplicação é o que se entrega ao usuário final.  
  
Devemos sempre lembrar – software não é escrito para servir seus desenvolvedores ou os sistemas em que roda. Eles são escritos para resolver problemas. Se esses problemas não são resolvidos, então o projeto é um fracasso.  
  
Eu escrevi usabilidade aqui como um termo mais geral do que somente efetividade de Interface de Usuário/UX. Mesmo uma aplicação de linha de comando ou um serviço que roda em background tem seus fatores de usabilidade no sentido de quão bem ele responde a uma necessidade específica.

### Termina as coisas

> Em princípio, você está procurando por pessoas que:  
> 
>   
> - são espertas e,
> - que terminam as coisas. 
> 
> [Joel Spolsky](http://www.joelonsoftware.com/articles/GuerrillaInterviewing3.html)

Talvez a coisa mais importante em um desenvolvedor. Você pode ser perfeito em todos os atributos anteriores e ainda ser um programador medíocre se você **não consegue terminar as coisas.** Um desenvolvedor mediano mas produtivo poderia facilmente substituir vários desenvolvedores altamente talentosos mas que se movem devagar, dependendo de suas responsabilidades.

No fim do dia você definitivamente quer desenvolvedores altamente produtivos mais do que aqueles que são grandes em teoria mas não na prática.

### Faz mais do que “apenas suficiente”

Terminar as coisas é importante. Terminar as coisas “do jeito certo” é ainda mais importante.

Pagar constante seu débito técnico é crucial – se você continuar acumulando débito fazendo “gambiarras” de correções rápidas que funcionam mas não são bons de mantenabilidade, você apenas está criando a aparência de progresso. Na realidade, o custo de se livrar do grande débito técnico poderia se tornar proibitivo antes de você perceber.

Gastar um tempo para constantemente refatorar código para uma forma com mais mantenabilidade é a melhor forma de prevenir a espiral que leva um projeto a desaparecer.

### Responsável

Uma pessoa poderia ser um programador capaz apenas em habilidades técnicas, entretanto se ele não assume seus próprios erros e não respeita prazos ele poderia se tornar um risco muito rapidamente.

Responsabilidade significa saber onde deixar seu ego para trás para o bem do projeto. Nós normalmente desenvolvemos grandes egos à medida que nos consideramos experts em muitas coisas. Colocar o projeto primeiro é um sinal de um bom desenvolvedor.

### Boas relações humanas

Outra coisa importante, essa também se aplica a programadores. Existe um estereótipo que programadores são criaturas reclusas, anti-sociais – programadores ainda são pessoas ;-)

Para ser parte de uma equipe ou lidar com clientes, um programador precisa ter habilidades sociais básicas. Rudez, arrogância, paciência curta – não tem espaço em um ambiente de trabalho profissional. Tudo que se precisa é uma maçã podre para arruinar o humor de todos.

### É isso

Se você respondeu positivamente a tudo acima, você provavelmente é um bom programador.

Você deve notar que não mencionei paixão ou diversidade tecnológica como atributos qualificatórios. Resumindo, eu não acho que sejam muito relevantes para a qualidade de um programador.

Paixão é bom de se ter, entretanto já conheci muitos profissionais e desenvolvedores de alta qualidade que estavam satisfeitos de apenas ir ao trabalho profissionalmente, das 9 às 17 e então ir para casa e ter vidas significativas e completas com a família. Um programador pode ser definitivamente completamente profissional sem ser apaixonado sobre programação.

Diversidade tecnológica é outra coisa boa de se ter mas não é um pré-requisito – enquanto se estiver no controle das tecnologias com que trabalha, uma falta de diversidade não deveria afetá-lo tanto. Tomadores de decisão precisam estar bem atentos para todas as opções antes de começar um projeto, entretanto hoje em dia a escolha de tecnologias simplesmente não é tão importante.

Você pode conseguir bons resultados independente da linguagem de programação e banco de dados entre outras considerações. A maior consideração deve ser o tipo de habilidades disponíveis no seu pessoal.

## [Tradução] Por que Bons Programadores são Preguiçosos e Idiotas

**Fonte:** [blogoscoped](http://blogoscoped.com/archive/2005-08-24-n14.html)

Eu percebi, paradoxialmente o suficiente, que bons programadores precisam ser tanto _preguiçosos_ quanto _idiotas._

**Preguiçosos** , porque apenas programadores preguiçosos irão querer escrever os tipos de ferramentas que podem substituí-los no final. Preguiçosos, porque somente um programador preguiçoso vai evitar escrever código monótono e repetitivo – assim evitando redundância, o inimigo da mantenabilidade e flexibilidade de software. No mais, as ferramentas e processos que vêm disso, disparados pela _preguiça_, irão aumentar a produção.

Claro, essa é apenas meia verdade. para um programador preguiço para ser um bom programador, ele (ou ela) também devem ser extremamente _não-preguiçosos_ quando é hora de aprender como ser _preguiçoso_, ou seja, quais ferramentas de software tornam seu trabalho mais fácil, quais técnicas evitam redundância, e como ele pode fazer seu trabalho ter mais mantenabilidade e ser facilmente refatorado.

Segundo (e vou elaborar mais sobre isso porque acho que esse conceito é menos conhecido que o primeiro) um bom programador precisar ser **idiota.** Por que? Porque se ele é esperto, e ele sabe que é esperto, ele vai:

1. parar de aprender
2. parar de ser crítico a respeito do seu trabalho

Ponto a) tornará mais difícil para ele tentar encontrar novas técnicas para permití-lo trabalhar mais rápido. Ponto b) tornará difícl a ele debugar seu próprio trabalho, e refatorá-lo. Na batalha interminável entre um programador e o compilador, é melhor para o programador desistir rápido e admitir que é sempre _ele_ e nunca o compilador o culpado (a menos que seja codificação de caracteres, que é a parte que até mesmo compiladores erram.)

Mas existe um ponto mais crucial de porque bons programadores precisam ser idiotas. Isso porque para ele encontrar as melhores soluções a um problema, precisa manter uma mente aberta e pensar fora da caixa (ou melhor, conhecer seu _formato_ real). De certa forma, isso leva à mentalidade de uma criança; incrivelmente criativa porque ele nunca ouviu “não” como resposta.

O direto oposto não seria muito construtivo; ser conhecedor dos parâmetros à mão e aceitá-los. Porque quem sabe quantos limites você acha que existem, na _real_? Quanto menos você souber, mais radical serão suas escolhas; melhores as ferramentas que você desenvolve, e melhor o produto que você desenvolve _com_ elas.

Eu conheço do meu trabalho um bom programador, quando confrontado com um problemas da gerência, adotará essa mentalidade de ser _idiota_; ele começará a perguntar as questões mais simples e infantis. Porque ele não aceita os parâmetros sugeridos a ele que alguém _acha_ que definem o problema. Aqui está uma típica conversa da terra perdida do desenvolvimento web:

- “Desde ontem, nosso cliente não consegue ver o logotipo no web site.”
- “Ele reiniciou o browser?”
- “Sim.”
- “Ele reiniciou o computador?”
- “Sim.”
- “Ele limpou seu cache?”
- “Sim.”
- “Ele roda Internet Explorer 6?”
- “Sim.”
- “Ele tem certeza que não consegue ver?”
- “Sim.”
- “Ele olhou para o web site na tela?”
- “O que?”
- “Bem, ele pode ter impresso.”
- “Não, ele estava olhando para a tela.”
- “Ele também não viu outras imagens além do logo?”
- “O que? Bem, vou perguntar a ele.”

Apenas para a argumentação (isso foi inteiramente hipotético) vamos dizer que o cliente de fato desligou as imagens do seu browser. Ou seu filho desligou. Seja qual for o caso, essa resposta não seria encontrada se você trabalhasse com um programador em modo<sup class="footnote" id="fnr1"><a href="#fn1">1</a></sup> “esperto”. Nenhuma das perguntas perguntadas pelo programador requerem qualquer habilidade de programação. Não, simplesmente porque o problema é tão estúpido, apenas estupidez pode resolvê-la.

> <sup class="footnote" id="fnr1"><a href="#fn1">1</a></sup> alguns anos atrás, eu tive uma longa discussão no telefone sobre o web site ter quebrado desde minha última atualização … acabou que a pessoa desabilitou os stylesheets em seu browser. Na época eu teria suspeitado de tudo **menos** numa solução tão simples e fiquei escutando meia hora de reclamações sobre padrões de qualidade, etc. No final, a premissa que minha atualização foi culpada era apenas isso … uma premissa. Melhor você ouvir **apenas os fatos** se começar a debugar, e nunca no que as pessoas **acham** que pode ser a razão.

De forma similar, quando um dos meus colegas programadores me pergunta: “Por que isso não está funcionando?” na maioria das vezes é porque ele está trabalhando no arquivo errado (ex. ele linkou na biblioteca 1, mas alterou na biblioteca 2, e sua revisão não aparece ou simplesmente não linkou na biblioteca.) Quando você pede ajuda a seu colega, particularmente sobre programação, você espera que ele saiba menos sobre o projeto … então ele faz perguntas estúpidas que você evitou perguntar a si mesmo de forma sub-consciente, porque você achava que sabia as respostas, quando de fato não sabia.

Existe outro lado nisso. A pessoa idiota-demais vai somente sair correndo e, sem pensar duas vezes, fazer algo errado. A pessoa esperta-demais vai se sentar e planejar algo certo, sem tomar nenhuma ação. Um programdor pragmático está mais ou menos no meio; ele sabe que tomar a decisão errada 1 vez em 10 não machuca os objetivos tão mal quanto 5 decisões certas de 10, e _não decidir nada_ nas outras 5 vezes.

É como a história da centopéia. A centopéia era muito boa em andar com suas cem pernas. Ela nunca pensou em como conseguia andar. Até que um dia, quando um inseto preto grande perguntou a ela “Como você consegue _andar_ com tantos pés? Não acha difícil coordenar seu ritmo?” O inseto grande preto já tinha ido embora, enquanto a centopéia ainda estava sentada, ponderando _como_ ela conseguia andar, se perguntando e (pela primeira vez na vida) até mesmo se preocupando um pouco. Desse dia em diante, a centopéia não conseguia andar mais.

Então, melhor não pensar demais se quiser conquistar alguma coisa. E, claro, essa é somente meia verdade também …

