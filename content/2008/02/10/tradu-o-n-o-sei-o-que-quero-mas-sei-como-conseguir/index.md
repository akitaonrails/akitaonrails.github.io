---
title: 'Tradução: Não sei o que quero, mas sei como conseguir'
date: '2008-02-10T17:18:00-02:00'
slug: tradu-o-n-o-sei-o-que-quero-mas-sei-como-conseguir
tags:
- off-topic
- principles
- agile
- management
- career
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/patton_headshot_small.jpg)

Este [artigo](http://www.agileproductdesign.com/blog/dont_know_what_i_want.html) é muito interessante e me deixou intrigado porque eu – que sou um amador em técnicas Ágeis – pela primeira vez vi um enfoque diferente na explicação de certos termos Ágeis, em particular, “iteração” vs “incremental”.

Segundo o perfil no site do autor: **Jeff Patton** tem focado em técnicas Ágeis desde 2000 e se especializou na aplicação de técnicas de design centradas no usuário para melhorar requirimentos Ágeis, planejamento e produtos. Alguns de seus artigos mais recentes podem ser encontrados na www.AgileProductDesign.com e na Crystal Clear de Alistair Cockburn. Seu próximo livro será lançado pela série de Desenvolvimento Ágil da Addison-Wesley que dará conselhos táticos para quem procura entregar software útil, usável e de valor.

Atualmente ele trabalha como consultor independente, é o fundador e moderador da lista agile-usability no grupo de discussão do Yahoo, um colunista na StickyMinds.com e IEEE Software, e vencedor do Gordon Park Award 2007 da Agile Alliance por contribuições ao desenvolvimento Ágil.

E aqui vai minha tradução do artigo em questão:


## Não sei o que quero, mas sei como conseguir

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/johnny_rotten.jpg)](http://en.wikipedia.org/wiki/John_Lydon)

Tudo começou com um desses estranhos treinamentos de pensamento que vêm a você quando está na metade do caminho entre dormir e acordar. As primeiras linhas da música [Anarchy in the UK](http://www.lyricsfreak.com/s/sex+pistols/anarchy+in+the+uk_20123592.html), do Sex Pistols, estava tocando na minha cabeça. (Isso pode ser uma dica tanto da minha idade, e do tipo e volume da música que ouço). Nessa manhã, [Johnny Rotten’s word](http://www.lyricsfreak.com/s/sex+pistols/anarchy+in+the+uk_20123592.html) pareciam particularmente sábias – e pareciam descrever perfeitamente um problema recorrente que tenho sofrido ajudando pessoas a realmente [entender](http://en.wikipedia.org/wiki/Grok) desenvolvimento Ágil. Brevemente, depois de se declarar um anti-cristo, Johnny diz:

**“Não sei o que quero, mas sei como conseguir.”**

E, isso é relevante porque eu constantemente caio em alguns problemas que fazem meu [sentido aranha](http://en.wikipedia.org/wiki/Spider-Man's_powers_and_equipment#Spider-sense) apitar. Em desenvolvimento de software Já ouviu algo parecido com isso?

**“Sabemos o que queremos. Poderia estimar quanto tempo vai levar para construir?”**

Se sentiu um frio na espinha, isso foi seu sentido aranha apitando. O outro problema é mais ou menos assim:

**“Precisamos finalizar o detalhamento desses requerimentos antes de começar o desenvolvimento.”**

Em resumo, eu caio em situações onde as pessoas do lado de especificação de desenvolvimento de software, “clientes” ou “donos do produto” em termos Ágeis, ou acreditam que sabem o que precisam, ou sentem que precisam saber antes de podermos começar a desenvolver. Mais ainda, eu ainda esbarro em vários ambiente Ágeis com a mesma antiga e chata reclamação sobre “clientes que não sabem o que querem” ou “clientes sempre mudando de idéia”.

Todos esses sentimentos para mim parecem surgir do não saber o que “iteração” significa, e é usada em desenvolvimento Ágil.

### Iterar e Incrementar são idéias separadas.

Eu costumo ver pessoas em desenvolvimento Ágil usar o termo **iterar** , mas realmente querem dizer **incrementar**.

Por desenvolvimento incremental quero dizer incrementalmente adicionar software de cada vez. Cada incremento adiciona mais software – meio como adicionar tijolos numa parede. Depois de vários incrementos, você tem uma parede grande.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/incrementing.jpg)

Por desenvolvimento iterativo quero dizer que construímos alguma coisa, então avaliamos se vai funcionar para nós, então fazemos mudanças. Nós construímos **esperando mudar.** Nunca esperamos fazer certo. Se ficou certo, foi um feliz acidente. Como não esperamos fazer certo, normalmente fazemos o mínimo necessário para validar se foi a coisa certa a se fazer.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/iterating.jpg)

Usei as duas figuras acima por vários anos para ajudar a ilustrar o conceito. Artistar trabalham iterativamente. Eles normalmente criam rascunhos, decidem criar uma pintura, criar uma sobre-pintura mostrando as cores e formas, então eventualmente começam a terminar de pintar. Eles param quando está “bom o suficiente” ou esgotam o tempo ou interesse.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/rembrandt_paint_by_number.jpg)

Artistas de pintar-nos-números trabalham incrementalmente. Quando eu era criança fiz algumas ótimas artes de pinturas-nos-números. O problema com pintar-nos-números é que alguns artistas reais tiveram que realmente pintar a coisa, entender quais eram todas as cores, então desenhar todas as linhas e numerar as áreas – o que toma mais tempo do que somente criar a pintura. Usando uma estratégia de _somente_ incrementar significa mais ou menos ter que conseguir fazer certo da primeira vez.

### Nós iteramos por múltiplas razões

Depois de falar sobre iteração durante a [XP Day 2007](http://www.xpday.org/) alguém corretamente apontou a mim que não era tão simples quanto “mudar as coisas” em cada iteração. Ele apontou que:

- nós iteramos para **encontrar a solução correta.**

- então, dado um bom candidato a solução, então devemos iterar para **melhorar o candidato a solução.**

### Nós Incrementamos por múltiplas razões

Nós adicionamos incrementalmente a software por várias razões também.

- Usamos incrementação para **gradualmente construir funcionalidade** então _se_ o desenvolvimento leva mais tempo do que se espera, podemos lançar o que incrementalmente construímos até agora. (“Se” em itálico porque eu honestamente não consigo me lembrar de um projeto onde o desenvolvimento levou menos tempo do que o esperado.)

- Lançamos incrementalmente para que realmente **consigamos o valor de negócio que estamos buscando**. Porque, realmente não conseguimos retorno de investimento até as pessoas começarem a usar o software que construímos. Até lá, o valor esperado de negócio é apenas uma estimativa. E, se acha que estimativa de desenvolvimento de software é difícil, experimente estimar retorno de investimento.

### Nós combinamos iteração e incrementação

Em desenvolvimento Ágil realmente combinamos as duas táticas. Durante uma “iteração” de desenvolvimento onde construímos vários [user stories](http://www.agileproductdesign.com/blog/the_shrinking_story.html) algumas podem estar adicionando novas funcionalidades incrementalmente, outras podem estar iterando para melhorar, mudar ou remover funcionalidades existentes.

Onde as coisas realmente não dão certo em desenvolvimento Ágil é quando ninguém planeja iterar.

### O cliente apreensivo

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/gun_shy_customer_small.jpg)

Talvez você tenha estado em projetos Ágeis:

Os clientes se encontram com a equipe e escrevem várias user stories com sucesso. Depois de muita conversa entre desenvolvedores e clientes, os desenvolvedores estimam as histórias. Os clientes as priorizam, os de maior valor primeiro, e escolhem as histórias mais importantes para o primeiro lançamento estimado para daqui seis iterações.

O desenvolvimento começa, e as coisas parecem ir muito bem. Num mundo de fantasia essa história poderia ocorrer, todas as estimativas de desenvolvimento estavam precisas. Nas primeira iterações todas as histórias agendadas são finalizadas. Mas, é quando as coisas vão errado.

Depois de olhar para o software o cliente diz “Agora que vejo isso, está faltando algumas coisas. E, embora as coisas que tenha construído batem com os critérios de aceitação, nós, bem .. hum … não estávamos muito certos sobre critérios de aceitação e agora que vemos isso, isso precisa mudar.”

“Sem problema” diz a equipe. “Apenas escreva mais user stories. Mas, vocês terão que retirar algumas das outras deste lançamento para que possamos acabar no tempo.”

O cliente está chocado e nervoso. “O que você está dizendo é que eu preciso ter os requerimentos certos logo de início (‘requirements right up front’)!! Isso cheira a waterfall – exceto que sem o tempo inicial (‘up front time’) que eu precisaria para pelo menos tentar ter os requerimentos certos logo de começo.”

Eu trabalhei com essas equipes e clientes muitas vezes. Conheço muitas organizações onde “Desenvolvimento Ágil” foi etiquetado como um processo que simplesmente não funciona e foi ejetado da organização.

Conheço outros clientes que adaptaram gastando mais e mais tempo em requerimentos. Eles introduziram fases de “Iteração 0” ou “Sprint 0” mais prologadas onde eles de fato escrevem esses grandes requerimentos. Eles trabalham, 1, 2 ou 3 iterações à frente para realmente conseguir os detalhes de suas histórias antes delas serem introduzidas. Eles tentam duro conseguí-las certo. E, quando inevitavelmente eles falham em conseguí-las certo, eles ficam murchos, desiludidos, desapontados – e vários outros “des-” que você pode imaginar.

Não é culpa deles. Eles foram mal direcionados.

### Isso não significa o que você pensa que significa

Existe uma pequena frase miserável que as pessoas Ágeis usam frequentemente. Eles costumam dizer “ao final de cada iteração você terá software potencialmente entregável.” O [modelo Scrum Snowman](http://www.mountaingoatsoftware.com/scrum) comumente usado que todas as dezenas de milhares de Scrum Masters certificados viram, claramente diz isso.

| ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/scrum_snowman_model.gif) | ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/potentially_shippable_product.gif) |

No filme “Princess Bribe” um dos vilões exclama “Inconcebível!” cada vez que um de seus planos é derrubado pelo herói. Isso acontece com tanta frequência que um de seus parceiros diz “Você sempre fala essa palavra. Eu acho que você não sabe o que isso significa.”

![](http://www.agileproductdesign.com/blog/images/inigo.jpg)

_“Entregável”. Você sempre fala essa palavra.   
Eu não acho que isso significa o que você acha que significa._

Para um cliente, alguém que pretende vender ou usar o software, ‘entregável’ significa que eles poderiam de fato vender ou usar o software. Isso significa que o número mínimo de funcionalidades estão todos presentes. O software precisa ser útil para os propósitos intencionados – pelo menos tão útil quanto o software antigo ou processo em papel que ele substitui. O software precisa parecer e se comportar bem – ter alta qualidade de acabamento – particularmente se isso é software comercial e você tem concorrentes baforando no seu cangote.

Entregável significa finalizado. Completamente feito e limpo. Não há necessidade de iterar em algo pronto – realmente pronto e entregável.

Dizer “entregável” para pessoas no papel de clientes significa lhes dizer que é bom que tenham os requerimentos certos porque é dessa forma que desenvolvimento Ágil funciona.

Agora, eu acredito que as pessoas Ágeis tinham outra coisa em mente quando disseram isso. Acho que eles queriam dizer sobre mante a qualidade do código bastante alta. Manter o código suportado com testes unitários e de aceitação. Tomar o cuidado de validar cada uma das user story. Isso diz aos testadores para se manterem envolvidos desde cedo e mais continuamente. Isso diz a desenvolvedores para desenvolver com alta atenção à qualidade. (Aparentemente desenvolvedores construiríam porcaria caso contrário?)

### YAGRI: You Aint Gunna Release It (Você Não Vai Lançar Isso)

Eu proponho que nós, da comunidade Ágil, sejamos claros sobre o que queremos dizer por iterativo e incremental. Precisamos explicar a esses clientes e donos de produtos que é importante escrever user stories que não tem a intenção de serem lançados. Para escrever histórias que eles intencionam avaliar, aprender, melhorar ou jogar fora como experimentos falhos.

Em conversas com meu amigo Alistair, ele propôs [escrever três cartões de user stories em vez de apenas um](http://alistair.cockburn.us/index.php/Three_cards_for_user_rights). O primeiro cartão tem a história de fato nela. O segundo é um espaço para as inevitáveis mudanças à história depois de a vermos. A terceira para os refinamentos depois de vermos as mudanças.

Esse é um exemplo de planejamento para iterar. Isso poderiar tirar muito stress das mãos trêmulas dos clientes apreensivos preocupados sobre fazer certo porque a história precisa ser “entregável”.

### Você sempre pode ter o que quer, mas é o que você precisa?

Onde aplicamos lírica do Sex Pistols a desenvolvimento de software, não podemos necessariamente aplicar os Rolling Stones.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/10/mick_jagger.jpg)

_“Você não pode ter sempre o quer. Mas se algum dia tentar,  
 talvez encontre, terá o que precisa.”_

Em desenvolvimento de software, infelizmente se você especificar alguma coisa, e todos fizerem seu melhor, terá o que quer – pelo menos o que foi especificado. Mas, é isso que precisa? Você somente saberá depois que olhar para isso e experimentá-lo.

Não escute ao Mick.

De fato, tente muito não ter tanta certeza sobre o que quer. Se alavancar iteração, você a terá mesmo se não souber o que era, para começar. Johnny estava certo.

“Não sei o que quero, mas sei como conseguir.”

### Por favor alavanque a explicação se quiser

Essa é uma história que contei durante a [palestra de Abrace a Incerteza na XP Day 2007](http://www.agileproductdesign.com/downloads/patton_embrace_uncertainty_preso_only.zip). É raro quando você precisa citar Johnny Rotten, Roger Waters, Paul Simon, Pete Townsend, John Lennon e as Spice Girls na mesma palestra.

Sinta-se livre para [fazer download da palestra](http://www.agileproductdesign.com/downloads/patton_embrace_uncertainty_preso_only.zip)

Aqui está a palestra com [os clipes musicais](http://www.agileproductdesign.com/downloads/patton_embrace_uncertainty.zip).

Sinta-se livre para usar os exemplos usando a creative commons license. Deixe as pessoas saberem que pegaram emprestado de mim.

Se gostou dos [slides da Monalisa](http://www.agileproductdesign.com/downloads/patton_iterating_and_incrementing.ppt), pode [pegá-las daqui](http://www.agileproductdesign.com/downloads/patton_iterating_and_incrementing.ppt).

As idéias gerais aqui estão escritas em um [artigo na StickyMinds.com](http://www.stickyminds.com/sitewide.asp?ObjectId=13178&Function=DETAILBROWSE&ObjectType=COL&sqry=%2AZ%28SM%29%2AJ%28COL%29%2AR%28createdate%29%2AK%28colarchive%29%2AF%28%7E%29%2A&sidx=2&sopp=10&sitewide.asp?sid=1&sqry=%2AZ%28SM%29%2AJ%28COL%29%2AR%28createdate%29%2AK%28colarchive%29%2AF%28%7E%29%2A&sidx=2&sopp=10) com um pouco menos de reclamação. Você pode compartilhar essa versão com seu chefe.

### Fiquem ligados

<object width="425" height="373"><param name="movie" value="http://www.youtube.com/v/4bM_l443VV4&rel=1&border=1">
<param name="wmode" value="transparent">
<embed src="http://www.youtube.com/v/4bM_l443VV4&rel=1&border=1" type="application/x-shockwave-flash" wmode="transparent" width="425" height="373"></embed></object>

Se quiserem saber mais sobre estratégias específicas para iterar sensivelmente em desenvolvimento Ágil, por favor me visitem em um tutorial que estarei ensinando em uma conferência. Também prestem atenção a este site e bloguem enquanto ressucito meu antigo livro do purgatório.

Finalmente, se leu este blog no [ThoughtBlogs](http://blogs.thoughtworks.com/) (e meu web analytics me diz que muitos de vocês vieram de lá) esta pode ser a última vez que meu blog aparece por lá. Por favor assinem diretamente, ou me procurem na [ThoughtWorks alumni blogs](http://blogs.thoughtworks.com/alumni/). Eu tive uma ótima estadia na ThoughtWorks pelos últimos anos, mas é hora de andar sozinho.

Obrigado por lerem.

