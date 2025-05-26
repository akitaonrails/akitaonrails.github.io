---
title: A Controvérsia CoffeeScript
date: '2011-04-16T18:31:00-03:00'
slug: a-controversia-coffeescript
tags:
- javascript
- fud
draft: false
---

Para quem não está acompanhando, esta semana rolou uma pequena controvérsia acerca de uma nova decisão na linha de desenvolvimento para o futuro Rails 3.1 (atualmente estamos na 3.0.6). A partir dessa versão, o framework trará como dependência as bibliotecas CoffeeScript, SASS e Sprockets, além da mudança que já havia sido anunciada antes de trocar a instalação padrão do framework Javascript, Prototype + Scriptaculous, por [jQuery](http://twitter.com/#!/dhh/statuses/45923430608023552).

A maioria dessas mudanças foram bem recebidas e até em alguns casos, aplaudida, no estilo _“já não era sem tempo!”_ (caso do jQuery).

Porém, a [escolha](http://twitter.com/#!/dhh/status/58207700672200704) de colocar o CoffeeScript como padrão causou um grande [furor](http://twitter.com/#!/dhh/status/58288725247012864), diversas trocas de hostilidades, piadas de humor negro, [sarcasmo](http://doihavetousecoffeescriptinrails.com/) e também muita gente que simplesmente gosta de fazer barulho sem motivo algum (tem tempo sobrando, eu diria).

O pessoal do Rails Core Team acha que é a melhor decisão. Uma parcela barulhenta da comunidade acha que foi uma grande bobagem. E agora, o que isso significa?


## Introdução: Pré-processadores

Existem muitas coisas que são difíceis mudar. Quem lida com montagem de interfaces HTML/CSS multi-browser sabe a dor de cabeça. Especificar algo como HTML e CSS é muito difícil. Como eu sempre digo, leia as [especificações](http://www.w3.org/Style/CSS/current-work.en.html). À primeira vista parece bem completo. Mas não é! Cada navegador tem muitas diferenças de implementação.

Frameworks como jQuery para Javascript ajudam a aliviar muitas dessas diferenças, abstraindo as implementações em algo menos complicado. No caso do Javascript é possível criar frameworks assim porque ele é uma real linguagem de programação genérica – e uma bastante completa, diga-se de passagem.

Já um HTML e CSS **não** são linguagens de programação (quem ainda chama HTML e CSS de _“linguagem de programação”_ merece apanhar, sério. E quando eu pergunto, _“em que linguagens sabe programar?”_ e o cidadão responde _“ah, sei HTML”_, esse merece ser jogado da janela do prédio!). HTML e CSS são _“linguagens de marcação”_. Tem gente que não sabe nem o que significa HTML: “HyperText **Markup** Language”. Está no próprio nome!

O quero dizer é que é impossível programar um framework HTML ou CSS escrito em HTML ou CSS, algo parecido com o efeito de um jQuery. Ou seja, podemos refatorar e reescrever quanto quisermos, mas nunca conseguiremos extrair uma “biblioteca” parametrizável e reusável escrito em CSS que seja capaz de gerar mais CSS.

Sabemos o benefício que existe em usar frameworks que abstraem muitas das repetições e coisas específicas de cada navegador numa linguagem mais genérica. Por exemplo, no caso do Javascript, em vez de fazer:

* * *
javascript

var elm = null;  
if (document.getElementById)  
{  
 // browser implements part of W3C DOM HTML  
 // Gecko, Internet Explorer 5+, Opera 5+  
 elm = document.getElementById(id);  
}  
else if (document.all)  
{  
 // Internet Explorer 4 or Opera with IE user agent  
 elm = document.all[id];  
}  
else if (document.layers)  
{  
 // Navigator 4  
 elm = document.layers[id];  
}  
-

Hoje podemos simplesmente fazer, com jQuery:

* * *
javascript

var elm = $(“#” + id);  
-

Outra alternativa seria mudar a especificação do HTML e CSS para serem mais enxutas e mais flexíveis. Mas isso seria praticamente impossível pois todos os navegadores do planeta precisaram ser atualizados para a mesma versão para que valesse a pena. É o dilema do HTML 5 vs Internet Explorer 6. Enquanto existir um cidadão usando o famigerado IE 6, vamos ter que criar código que trata versões e dá “fallback”, ou seja, escolhe uma versão não HTML 5.

Agora, nós conhecemos técnicas que podem facilitar a vida do desenvolvedor. Quem programa em C conhece [pré-processadores](http://en.wikipedia.org/wiki/C_preprocessor). Ele permite escrever macros, que podem ser reusados por todo seu código. Daí antes de compilar em código nativo de máquina, o compilador do C vai fazer o equivalente a um grande “procurar e substituir”, trocando as macros por código, por exemplo:

* * *
C

#define <acronym title="item,id"><span class="caps">MYCASE</span></acronym> \  
case id: \  
 item##\_##id = id;\  
break

switch(x) {  
<acronym title="widget,23"><span class="caps">MYCASE</span></acronym>;  
}  
-

Quando o pré-processador do C passar por esse código, ele será “reescrito” como:

* * *
C

switch(x) {  
 case 23:  
 widget\_23 = 23;  
 break;  
}  
-

Com esse recurso podemos praticamente criar uma sintaxe completamente nova que você nem perceberia mais que está lidanco com C. Não é exatamente recomendável fazer isso, mas as macros estão ali para justamente tentar abstrair mais do código e torná-la mais fácil de ler e dar manutenção. No final o código binário gerado seria o mesmo, mas para o desenvolvedor a vida pode ser mais fácil.

Pois bem, no mundo Ruby, sabendo que HTML e CSS não podem ser modificados e não podem gerar a si mesmos, recaímos em Ruby mesmo para criar o equivalente a pré-processadores. São formas de escrever HTML e CSS em uma sintaxe mais simples e com mais abstrações, de maneira a tentar evitar escrever tantas duplicações e a tornar a manutenção futura até mais simples.

CSS em particular é um monstro complicado porque diferente de HTML ela não define estrutura, define estilo a ser aplicado à estrutura. O HTML é razoavelmente “simples” e linear. Não há valores, não há reusos triviais, ela é uma hierarquia simples. Já CSS tem valores, tem reuso desses valores, tem conceitos de herança e prioridade dos estilos, tem valores derivados de outros valores. Mas ela não dá nenhum recurso para tornar isso fácil, então você é obrigado a repetir e repetir sem parar. E quando tem uma mudança drástica, é obrigado a reescrever muita coisa.

Entra SASS. Ele é como um pré-processador de CSS, que adiciona diversas funcionalidades que muitos acreditam que já deveriam ter sido criadas desde o começo. Por exemplo, veja o seguinte código em SASS:

* * *
css

/\* style.scss \*/

$main-color: #ce4dd6;  
$style: solid;

#navbar {  
 border-bottom: {  
 color: $main-color;  
 style: $style;  
 }  
}

a {  
 color: $main-color;  
 &:hover { border-bottom: $style 1px; }  
}  
-

É transformado no seguinte CSS:

* * *
css

/\* style.css \*/

#navbar {  
 border-bottom-color: #ce4dd6;  
 border-bottom-style: solid; }

a {  
 color: #ce4dd6; }  
 a:hover {  
 border-bottom: solid 1px; }  
-

Notem que aqui o objetivo sequer é escrever “menos linhas de código”. Se o objetivo fosse apenas esse, o SASS seria inútil. Mas o principal é a forma de escrever estilos como blocos dentro de blocos, usar variáveis e muito mais. No exemplo, digamos que você tivesse que mudar a cor principal (main-color). Teria que fazer um processo manual de “procurar e trocar” por todo seu código e ainda assim não teria nenhuma certeza se trocou tudo certo. Aqui basta trocar uma variável. Esse é apenas um dos benefícios. SASS tem muitos outros recursos que permitem organizar seu CSS de maneira nunca antes possíveis.

O autor do SASS é o grande Hampton Caitlin, que é contribuidor na comunidade Ruby há muitos anos. Antes do SASS, porém, ele havia criado outro tipo de pré-processador, mas para HTML chamado [HAML](haml-lang.com/). Vejamos o exemplo que ele mostra no site. Primeiro o código escrito em HAML:

* * *
css

#profile  
 .left.column  
 #date= print\_date  
 #address= current\_user.address  
 .right.column  
 #email= current\_user.email  
 #bio= current\_user.bio  
-

Esse HAML será transformado no seguinte HTML:

* * *
html

\<%= print\_date %\>

\<%= current\_user.address %\>

\<%= current\_user.email %\>

\<%= current\_user.bio %\>

* * *

A idéia principal do HAML é estética. Não funcionalidades. Segundo o próprio website, eis a definição de porque HAML existe:

> “Haml é baseado em um princípio primário. Marcação deve ser muito bonita.”

E eis o que eu acredito ser o principal problema do HAML: “ser bonito” ou “ser feio” é completamente uma questão não-absoluta de gosto pessoal. Quem acha HAML bonito vai criticar totalmente HTML. Mas quem acha HTML bonito o suficiente, vai achar HAML muito feio. E contra isso não há nenhum tipo de argumento.

No caso, a maioria do Rails Core Team, não viu valor na mudança estética de HTML para HAML. Eu pessoalmente também não vejo. Por outro lado não desgosto de HAML, se eu pegar um código que usa HAML provavelmente vou usá-lo sem problemas, mas se começar um projeto do zero, não sei se eu usaria. Provavelmente seria relutante.

O problema é o objetivo do HAML: se ele me acrescentasse funcionalidades que me permitissem simplificar a organização das views, criar estruturas reusáveis ou algo assim, seria muito interessante. Mas um arquivo HAML é um para um equivalente a um arquivo HTML (diferente do SASS que oferece mixins e imports). Um bloco HAML é um para um equivalente a um bloco de HTML (diferente do SASS que introduz nesting). E assim por diante.

Ou seja, estou literamente trocando seis por meia dúzia em troca de “estética”. Sendo que essa estética não tem explicação lógica, apenas gosto pessoal. Ou seja, qual é mais “bonito” aos seus olhos, este HAML:

* * *
css

%strong.code#message Hello, World!  
-

Ou este HTML:

* * *
html

**Hello, World!**  
-

Pois é, eu pessoalmente prefiro o HTML. O que não invalida quem prefere HAML. Portanto, dado que a escolha é puramente estética, entendo perfeitamente porque o Rails Core Team preferiu deixar o HAML de fora e só trazer o SASS. O SASS traz benefícios reais de produtividade e mantenabilidade do código. O HAML é puramente estético e é difícil de defender alguma coisa simplesmente por “parecer” esteticamente melhor.

## CoffeeScript – melhor ou apenas mais estética?

E aí caímos na controvérsia do [CoffeeScript](http://jashkenas.github.com/coffee-script/). Há um ano eu [já havia escrito](http://akitaonrails.com/2010/03/27/brincando-com-coffee-script) uma introdução a ele, portanto recomendo que leiam meu antigo artigo primeiro antes de continuar.

E como no caso do HAML, eu critico seu objetivo de existir. Do próprio website oficial, eu destaco este trecho:

> Javascript sempre teve um excelente modelo de objetos em seu interior. CoffeeScript é uma tentativa de expôr as boas partes do Javascript de maneira simples.
> 
> A regra de outro do CoffeeScript é: “É somente Javascript”. O código compila um-para-um no JS equivalente, e não há nenhuma interpretação em tempo de execução.

Assim como HAML, CoffeeScript tem exatamente o mesmo objetivo: ser um-para-um mais “esteticamente” bonito do que o original. E essa é a razão da discussão, porque quem acha CoffeeScript esteticamente mais bonito vai defendê-lo (caso do Rails Core Team) e quem não acha essa estética tão bonita assim vai questionar, criticar.

Repito: é uma questão **puramente estética**! Não há nenhum argumento técnico, lógico e objetivo para declarar que CoffeeScript é melhor ou pior. E não se trata simplesmente de escrever menos código (em muitos casos no SASS você pode acabar com mais linhas de código, só que com maior mantenabilidade), portanto ser mais “curto” pra escrever é interessante mas dificilmente é um argumento definitivo.

Além disso, uma linguagem de marcação como HTML é bem mais fácil de entender se você mantiver a estrutura mas só mudar a forma de escrever. Já uma linguagem de programação completa e complexa como Javascript, se você mudar a sintaxe, para quem nunca viu CoffeeScript, a curva de aprendizado será considerável não é zero e pode ser grande dependendo de quem vai pegar esse código para dar manutenção depois. Quem já sabe obviamente dirá _“mas é muito simples”_ mas para quem não conhece e não está vendo nenhum valor extra sendo adicionado, naturalmente irá questionar: _“e o que eu ganho com isso?”_ E ele também está certo, porque se para ele a estética é irrelevante, de fato ele não está levando absolutamente nenhum benefício em termos de programação ou organização.

Também usamos o argumento que Ruby é mais elegante ou esteticamente mais bonito do que outras. Mas Ruby efetivamente traz técnicas e paradigmas de programação novos como closures, classes abertas, metaprogramação, mixin de módulos, e muito mais. Não é apenas estética.

Mas não pensem que CoffeeScript é ruim por causa disso. De jeito nenhum, de fato Javascript tem uma sintaxe que está ficando velha muito rápido. O Coffee tem diversas ajudas de sintaxe que tornam mesmo muitas coisas menos complicado. Vejam alguns exemplos, primeiro em Coffee:

* * *
ruby

switch day  
 when “Mon” then go work  
 when “Tue” then go relax  
 when “Thu” then go iceFishing  
 when “Fri”, “Sat”  
 if day is bingoDay  
 go bingo  
 go dancing  
 when “Sun” then go church  
 else go work  
-

Agora em Javascript:

* * *
javascript

switch (day) {  
 case “Mon”:  
 go(work);  
 break;  
 case “Tue”:  
 go(relax);  
 break;  
 case “Thu”:  
 go(iceFishing);  
 break;  
 case “Fri”:  
 case “Sat”:  
 if (day === bingoDay) {  
 go(bingo);  
 go(dancing);  
 }  
 break;  
 case “Sun”:  
 go(church);  
 break;  
 default:  
 go(work);  
}  
-

E no final nem é tão complicado assim aprender Coffee. Basicamente entre no [site oficial](http://jashkenas.github.com/coffee-script/) deles e leia essa primeira página. Ela tem tudo que você precisa saber para começar. Eu diria que você precisa, em média de 1 a 2 horas para saber como ler e escrever em Coffee. Mais do que isso e significa que você tem pouca prática com programação, o que não é ruim, mas só para constatar que é só isso que um bom programador deveria levar.

## Conclusão

Isso tudo dito, eu consigo entende o valor estético do CoffeeScript e não acho ruim usá-lo. Não sinto ele tão valioso quanto um SASS. Também entendo manter o HAML fora do Rails por enquanto, até que seja mais fácil convencer os outros do seu valor.

O problema maior é que o Rails está começando a ficar mais complexo. É natural e até que ele conseguiu se manter bem nos últimos 5 anos sem virar um novo J2EE. Está longe disso. Mas agora temos um passo de pré-processamento que os programadores precisam ter consciência. Os arquivos <tt>.scss</tt> ou <tt>.coffee</tt> primeiro precisam passar por um processo de pré-processamento/compilação para se tornarem <tt>.css</tt> e <tt>.js</tt>. Pior ainda, se usar o [Sprockets](https://github.com/sstephenson/sprockets) (ou equivalente [Asset Packager](https://github.com/sbecker/asset_packager)), múltiplos arquivos CSS e JS serão compilados em um único minificado para melhorar velocidade de transferência.

Vários problemas podem acontecer: alguém editar o CSS final em vez do SCSS que o gerou, sem perceber. Esquecer de executar o passo que transforma o SCSS em CSS antes de atualizar uma versão em produção. Dar erro no navegador do cliente e a partir daí ficar difícil de determinar qual era o arquivo original em SCSS que gerou aquele CSS, e assim por diante. Nenhum desses problema é crítico ou incontornável uma vez que você sabe o que fazer. Mas é um passo extra na curva de aprendizado para quem está começando.

Todos esses pacotes são opcionais. Basta entrar na <tt>Gemfile</tt> que o Rails 3.1 irá gerar e retirar as dependências que não lhe interessam e adicionar as escolhas que prefere. Nesse sentido o Rails permanecerá modular, de forma a facilitar novas escolhas, por isso ninguém deveria estar preocupado.

No geral acredito que todas as mudanças mencionadas são positivas e aumenta o valor agregado do Ruby on Rails. E se você realmente gosta da prática de programação, aprender HAML, SASS, CoffeeScript, Sprockets, etc não deveria ser um sacrifício e sim um prazer. Se alguém está considerando aprender coisas novas um “sacrifício”, deveria rever sua carreira de programação.

