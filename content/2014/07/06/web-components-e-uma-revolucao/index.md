---
title: Web Components é uma Revolução?
date: '2014-07-06T01:09:00-03:00'
slug: web-components-e-uma-revolucao
tags:
- insights
- javascript
- front-end
draft: false
---

Existe uma nova celebridade na cidade, e seu nome é ["Web Components"](http://webcomponents.org/). Ultimamente muitos apresentam esta nova tecnologia como o 'Santo Graal' que vai resolver todos os problemas da Web. Este artigo não é um apoio incondicional, não é uma crítica negativa irrefutável, mas meramente uma apresentação de perspectivas com o objetivo de dar clareza. Nenhuma discussão pode funcionar onde os gritos mais altos são simplesmente _"Isso vai revolucionar a Web!"_ (sem explicar porque) ou _"O Google e a Mozilla estão por trás então é foda!"_ (sem comentários).

Do ponto de vista puramente técnico é muito simples entender o que é um "Web Component". Ele é o conjunto de 4 tecnologias de navegadores web.

* Custom Elements
* HTML Imports
* Templates
* Shadow DOM

Colocando em ordem de importância, eu resumiria da seguinte forma:

* Custom Elements - permite criar tags diferente dos canônicos como "body", "input" e evitar o classes-hell ou div-hell onde tudo é um punhado de divs dentro de divs criando os horrendos macarrões de tags. A idéia é encapsular tudo dentro de tags simples e mais fáceis de manusear.
* Shadow DOM - para o fator encapsulamento, precisamos primeiro conseguir eliminar o sangramento de estilos e comportamentos por tudo que existe numa página. Shadow DOM permite criar trechos de nós de elementos de DOM que são independentes e isolados entre si, onde o estilo de um trecho não interfere com outro. Somente o Chrome e Firefox mais novos suportam isso. WebKit/Safari deixou de suportar a implementação incompleta que tinham (mas talvez voltem) e o IE, para variar, nunca nem tentou implementar isso. Para funcionar na maioria dos navegadores existem projetos como o Polymer/Platform e X-Tag para servir como "polyfill" para navegadores legados.
* Templates - como o nome diz, para criar componentes dinâmicos, é importante ter trechos de DOM inertes, diferentes de somente uma string, para conseguir manipular e instanciar conforme necessário. Por exemplo, linhas de uma tabela dinâmica. Existem várias bibliotecas de templates, como Mustache, mas para Web Components funcionar, era importante ter um padrão.
* HTML Imports - e uma vez tendo um trecho de DOM isolado, com estilos e comportamentos independentes de outros componentes, agora precisamos empacotar isso. E para isso servem esses imports que basicamente é um arquivo HTML que declara os arquivos CSS e Javascript que ele depende, e o HTML Import sabe como carregar tudo de uma vez. Aqui fica uma das minhas maiores preocupações - que vou tentar explicar mais para o fim.

Existem já dezenas de artigos e documentação de como é um Web Component, como construir um do zero e onde encontrar componentes. Não é foco deste artigo explicar os detalhes técnicos de um Web Component.

Por si só, devo dizer que são tecnologias interessantes que todo bom nerd gosta de brincar. Porém não deveria ser novidade que só porque alguma coisa é tecnicamente interessante, por si só, não garante absolutamente nada. A principal pergunta é: _"o que eu ganho com isso?"_ Antes de responder a essa pergunta, toda tecnologia é somente uma solução procurando um problema.

Infelizmente nem eu, nem ninguém, temos como prever o futuro, então neste artigo quero avaliar qualquer proposta baseado no que temos no presente, relembrar o passado e o que isso pode representar no curto prazo. O longo prazo deixo para os profetas e quem gosta de apostar em loteria. Então vou tentar quebrar alguns dos grandes problemas do desenvolvimento Web que temos hoje.

## O Problema do HTML/CSS macarrônicos

A forma de desenhar uma página Web mudou bastante nos últimos 20 anos. As tecnologias básicas ainda são as mesmas: HTML 5 para estruturar um documento. CSS 3 para estilizar os elementos nesse documento. Javascript para adicionar comportamento. Acho que a esta altura todos já sabemos que devemos separar estilização/apresentação da estrutura e conteúdo. Também sabemos que não devemos nem usar tabelas para tudo e nem usar divs com float para tudo. 

Passamos pela era da [Web Semântica](http://semanticweb.org/wiki/Main_Page) e [Web Responsiva](http://www.smashingmagazine.com/2011/01/12/guidelines-for-responsive-web-design/). Quando os navegadores implementaram tables no [Netscape Navigator 1.1 e IE 2.0 em 1995 e 1996](http://www.barrypearson.co.uk/articles/layout_tables/history.htm) ainda não se falava em acessibilidade e semântica apareceriam a partir de 1997 com o HTML 3.2. Estávamos criando a Web e usando ao mesmo tempo, como hoje as implementações apareciam antes de se ter uma especificação mais geral. A W3C é lenta não é de hoje.

Acho que a evangelização de Responsive Web também merece um "rant" mas fica para outro artigo.

Mesmo assim ainda somos reféns de códigos como deste exemplo de tabs do framework [Bootstrap](http://getbootstrap.com/components/#input-groups):

```HTML
<ul class="nav nav-tabs" role="tablist">
  <li class="active"><a href="#">Home</a></li>
  <li><a href="#">Profile</a></li>
  <li><a href="#">Messages</a></li>
</ul>
```

E vejamos um trecho para tabs mas usando um web component do novíssimo [Polymer/Paper](http://www.polymer-project.org/components/paper-elements/demo.html#paper-tabs):

```HTML
<paper-tabs selected="0" selectedindex="0" id="paper_tabs">
  <paper-tab id="tab_home" active>Home</paper-tab>
  <paper-tab id="tab_profile">Profile</paper-tab>
  <paper-tab id="tab_messages">Messages</paper-tab>
</paper-tabs>
```

Esse é o resultado da primeira tecnologia de Web Components: [Custom Elements](http://www.html5rocks.com/en/tutorials/webcomponents/customelements/). De fato isso acrescenta uma clareza enorme. No primeiro exemplo o que temos é:

<blockquote>"Uma lista não ordenada com classes nav e nav-tags e dentro delas itens de lista."</blockquote>

Se você souber o que são as classes "nav" e "nav-tabs" vamos saber que se trata de uma lista de tabs. No caso do exemplo do Paper podemos ler claramente:

<blockquote>"Um conjunto de tabs, implementado com Paper."</blockquote>

Isto é um exemplo pequeno mas imaginando como páginas Web são complexas, tirar a ambiguidade de para que servem cada conjunto de tags numa árvore infinita de tags é muito importante. Perdemos muito tempo em tentativa e erro de retirar pedaços e tentando inserir outros pedaços no meio da árvore de HTML e decifrando nomes de classes CSS.

Na prática, sem ter Custom Elements para tornar as tags mais amigáveis, outra forma é encapsular a inicialização usando um marcador simples numa tag HTML (como uma classe CSS ou ID) e ativar o resto via Javascript. É como todo plugin JQuery funciona. Um exemplo simples é como encapsulamos o Google Maps com o plugin [Gmap3](http://gmap3.net/en/catalog/9-map/map-32) do JQuery:

```HTML
<div id="my-map"></div>
<script>
$("#my-map").gmap3({
    map:{
      address:"Cupertino, CA",
      options:{
        zoom:4,
        mapTypeId: google.maps.MapTypeId.SATELLITE,
        mapTypeControl: true,
        mapTypeControlOptions: {
          style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
        },
        navigationControl: true,
        scrollwheel: true,
        streetViewControl: true
      }
    }
  });
</script>
```

E outro exemplo com a alternativa com o [Web Component Google-Map](http://polymerlabs.github.io/google-map/components/google-map/) (lembrando que esta versão é mais simples do que o plugin Gmap3):

```HTML
<google-map latitude="37.77493" longitude="-122.41942" fitToMarkers>
  <google-map-marker latitude="37.779" longitude="-122.3892"
      draggable="true" title="Go Giants!"></google-map-marker>
  <google-map-marker latitude="37.777" longitude="-122.38911"></google-map-marker>
</google-map>
```

Estamos movendo parte do que faríamos via Javascript de volta ao HTML. Mas somente isso não é suficiente e já sabemos disso. A tecnologia de "Cascading Style Sheet versão 3", comumente conhecida como CSS 3 até hoje permanece arcaica. Felizmente inventamos uma forma de tornar os malditos macarrões de CSS gerenciáveis. Agradecimentos são devidos à [Hampton Catlin](http://www.hamptoncatlin.com), um grande rubista que - em <strong>2007</strong> - inventou a [linguagem de script SASS](http://sass-lang.com/), que é um "super-set" de CSS e gera CSS 3, adicionando variáveis, nesting, partials, import, mixins, extensão/herança, operadores.

SASS foi a primeira linguagem de pré-processamento que acelerou a idéia da possibilidade de novas formas de gerenciar assets Web como CSS. Depois dele vieram LESS e toda uma gama de frameworks e bibliotecas como [Singularity](http://singularity.gs/), [Bourbon Neat](http://neat.bourbon.io/), [Susy](http://susy.oddbird.net/), [Zurb Foundation](http://foundation.zurb.com/), [Compass](http://compass-style.org/). Foi uma pena terem escrito o Twitter Bootstrap original em [LESS em vez de SASS](http://wordsbyf.at/2012/03/08/why-less/), mas acho que o projeto [LibSass](http://libsass.org/) (SASS escrito em C) ainda não existia. Mas pelo próprio exemplo acima fica claro porque você deveria escolher outro framework em vez de Bootstrap.

Porém SASS não foi a primeira vez que alguém criou um pré-processador para a Web. Provavelmente a primeira foi a [Wiki Markup](http://en.wikipedia.org/wiki/Wiki_markup) implementada junto com o primeiro Wiki, o [WikiWikiWeb](http://en.wikipedia.org/wiki/WikiWikiWeb) de Ward Cunningham em 1995. Depois disso ainda tivemos o MediaWiki da Wikipedia até chegarmos atualmente a pré-processadores de HTML como Markdown, que praticamente usamos sem pensar em comentários de Github.

No mundo Rails já tentamos melhorar o HTML também, com pré-processadores como o HAML (do próprio Catlin) ou outros mais recentes como [Slim](http://slim-lang.com/). Mas nesse caso ainda não estamos melhorando o HTML tão drasticamente como SASS faz com CSS, por isso ainda não há uma boa alternativa e Custom Elements é o mais próximo de uma boa alternativa neste momento.

Estou trazendo estes pontos porque Web Components não declara nenhum pré-processador de CSS como padrão, por convenção. Assumimos CSS 3 puro. Não é um problema, mas se estamos falando de reuso, atualmente a melhor forma é usando mixins de SASS encapsuladas em bibliotecas como Compass ou Bourbon.

## O Problema do Sangramento de Estilos e Comportamentos

Este é um dos aspectos mais irritantes de desenvolvimento front-end depois da compatibilidade de navegadores: como organizar as milhares de linhas de CSS? (seja ele puro, escrito em SASS ou LESS).

Antes de continuar, se nunca ouviu falar de [CSS Anti-patterns](http://markdaggett.com/blog/2011/12/04/css-anti-patterns/), leia a respeito antes. E também que todos já pelo menos ouviram falar nas diversas metodologias para organizar CSS ([OOCss](http://www.smashingmagazine.com/2011/12/12/an-introduction-to-object-oriented-css-oocss/) , [SMACSS](http://www.smashingmagazine.com/2012/04/20/decoupling-html-from-css/), [BEM](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/)). Eu honestamente não usaria ACSS e me foram dados bons argumentos para preferir BEM.

Essa introdução foi somente porque também não sou ainda um bom desenvolvedor front-end mas até aqui é o mínimo para começar. Vamos assumir que já passamos desses pontos também. Meu raciocínio começa pelo seguinte caso de uso: _"quero criar CSS para um elemento visual, composto de diversos tags, e que não deve se deformar aleatoriamente por estilo de fora e nem deformar outros elementos ao redor."_ Seria o caso de um Widget ou o que poderia ser um "Web Component", ao pé-da-letra.

Passamos anos fazendo [Widgets](http://codeutopia.net/blog/2012/05/26/best-practices-for-building-embeddable-widgets/). As duas grandes formas são usando um iframe com [postMessage()](http://blog.teamtreehouse.com/cross-domain-messaging-with-postmessage) ou zerar os estilos de um trecho do DOM com [Cleanslate](https://github.com/premasagar/cleanslate) e garantir que você está isolando seu CSS e Javascript usando namespaces e torcendo pra acidentalmente não sobrar nada global no meio do caminho ou outro desenvolvedor sobrescrever o que você fez.

Isso mudou em 2012 quando surgiu a implementação de [Shadow DOM](http://blog.teamtreehouse.com/working-with-shadow-dom). Os novos elementos do HTML 5 como "audio" ou "video" ou "range" foram criados dessa forma em muitos navegadores. Em resumo mencionamos que uma página Web é uma árvore de tags, essa árvore que chamamos de Document Object Model ou "DOM". Imagine se pudéssemos isolar um trecho de nós, uma sub-árvore, que não fosse influenciada pelos estilos externos e cujos estilos internos não "vazassem" para fora. Para isso criamos um novo elemento, um "ShadowRoot" que delimita uma sub-árvore isolada e independente e que, para todos os propósitos, não aparece no DOM principal, mas tem sua própria raíz de DOM isolada. Esse é o conceito.

No [momento deste artigo](http://caniuse.com/shadowdom), somente o Chrome a partir da versão 25 (hoje no 35), o Firefox a partir da versão 31 (hoje no 30) e Ópera versão 15 (hoje no 22) suportam Shadow DOM. A Apple [retirou o suporte do WebKit](http://trac.webkit.org/changeset/164131) em fevereiro. A Microsoft sequer [considerou começar a implementar](http://connect.microsoft.com/IE/feedback/details/793965/ie11-feature-request-support-for-shadow-dom) ainda.

[Shadow DOM](http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom/) não é obrigatório para criar Custom Elements, mas é um recurso interessante e importante para atingir o objetivo de componentes Web independentes e isolados que não precisem recorrer a recursos como reiniciar o CSS de uma sub-árvore com artifícios como Cleanslate. De qualquer forma, seja via as convenções listadas acima e outras, ou seja via Shadow DOM, hoje temos como criar um nível razoável de isolamento e facilidade de manutenção. O problema é que isso não é inerente a HTML 5 e CSS 3, mas uma camada acima que não tem um consenso geral ainda.

## O Problema de Reusar Elementos

Num mundo onde fazíamos praticamente tudo via server-side, esse era um problema praticamente resolvido. Seja com Rails e ERB/HAML/Slim, seja com templates de Django, seja com Blade em Laravel, seja com Razor em Asp.Net. Porém hoje temos aplicações mistas, onde deferimos muita lógica para a camada do navegador usando mais Javascript. Em vez de devolver pedaços prontos de HTML, agora devolvemos dados semi-estruturados em JSON e deixamos o Javascript criar os elementos no DOM.

Significa que no navegador temos um conjunto de dados e precisamos de uma forma de declarar os elementos de DOM onde vamos aplicar esses dados antes de instanciar o trecho no DOM. Do mundo Ruby surgiu uma das formas mais populares, [Mustache](http://mustache.github.io/), criado pelo co-fundador do Github, [Chris Wanstrath](https://github.com/defunkt). Depois outro rubista, [Yehuda Katz](https://github.com/wycats), trouxe outra alternativa com o [Handlebars](http://handlebarsjs.com/). A idéia geral é criar um elemento "script" e dentro dela colocar templates usando a notação do Mustache. Então um Javascript pode pegar o conteúdo string dessa tag script e criar o elemento no DOM depois de mesclar com os dados que quiser.

Está claro que estamos fazendo uma "gambiarra" elegante. A parte não tão elegante é ter que injetar HTML usando "innerHTML", mas funciona muito bem. O outro problema é controlar manualmente coisas como imagens e javascripts que um elemento pode precisar mas antes dele ser usado, ou seja, talvez sem necessidade. Para isso precisamos controlar via Javascript.

Na definição de Web Components foi criado um novo elemento para resolver alguns desses problemas, o ["template"](http://www.html5rocks.com/en/tutorials/webcomponents/template/). Sua definição é bem recente, de fevereiro de 2014. Serve basicamente o mesmo propósito de colocar um template dentro de uma tag "script" mas em vez de ser somente um string injetável ele realmente é uma sub-árvore de DOM "inerte", que podemos manipular os nós via Javascript antes de ativá-lo ao inserir no DOM principal.

Por não ser mais um trecho de texto, perdemos a função do Mustache e do Handlebar de facilmente mesclar dados e inclusive ter alguma lógica como condicionais e loops. Em vez disso precisamos manipular os nós via javascript, fazendo coisas como:

```javascript
t.content.querySelector('img').src = 'logo.png';
```

Em vez de ter:

```HTML
<img src="{{minha-imagem}}" alt="great image">
```

Neste caso de templates eu diria que demos 2 passos pra trás e 1 para frente. Provavelmente dentro de um "HTML template" vamos precisar ter um Mustache para completar o processo? Admito que não acompanho a especificação mas pelo pouco que vi até agora não me parece que a especificação W3C de HTML template resolve o problema que bibliotecas como Mustache, Handlebars ou [HTMLBars](https://github.com/tildeio/htmlbars) resolvem hoje.

E não estou nem mencionando sobre Binding. Pelo que entendi isso não está na especificação, mas implementado em projetos como o [Google MDV](http://mdv.googlecode.com/svn/trunk/docs/design_intro.html) que agora está integrado ao [Data Binding e Event Mapping do Polymer](http://www.polymer-project.org/docs/polymer/databinding.html) como [TemplateBinding](https://github.com/Polymer/TemplateBinding).

## O Problema de Reusar "Componentes"

Definindo "Web Components" como, um conjunto de HTML, CSS, Javascript que funciona em independência e isolamento, finalmente sobra o problema de "empacotar" esse conjunto. E agora entra a [nova especificação de HTML Imports](http://w3c.github.io/webcomponents/spec/imports/) de Julho de 2014. 

Na prática, um HTML Import é nada mais do que um arquivo HTML "normal" com links para outros arquivos como stylesheets, imagens, javascripts e outros assets. Novamente, não vou descrever todos os detalhes e para aprender mais leia o artigo [Why imports?](http://www.html5rocks.com/en/tutorials/webcomponents/imports/).

Atualmente, se precisamos usar algum conjunto desses, como um componente de Bootstrap, por exemplo, precisamos manualmente linkar para os stylesheets na ordem correta e fazer algo como:

```HTML
<head>
  <link rel="stylesheet" href="bootstrap.css">
  <link rel="stylesheet" href="fonts.css">
  ...
</head>
<body>
  ...
  <script src="jquery.js"></script>
  <script src="bootstrap.js"></script>
  <script src="bootstrap-tooltip.js"></script>
  <script src="bootstrap-dropdown.js"></script>
</body>
```

Com HTML Imports podemos fazer simplesmente:

```HTML
<head>
  <link rel="import" href="bootstrap.html">
</head>
```

O problema imediato de algo como Web Components é que qualquer pequena página pode ter rapidamente dezenas de Imports, cada import requerendo outros arquivos e potencialmente triplicando ou mais a quantidade de chamadas pela rede. Quando tivermos algo melhor como HTTP 2.0 ou outro processo de [pipelining e multiplexing como com o protocolo SPDY](http://stackoverflow.com/questions/10480122/difference-between-http-pipeling-and-http-multiplexing-with-spdy) talvez não tenhamos que nos preocupar com isso, mas com o HTTP 1.1 que temos hoje precisamos ainda pensar em como economizar ao máximo chamadas de rede para pedir assets.

O mundo Rails trouxe pela primeira vez uma implementação de um processo completo e automatizado para concatenar e minificar stylesheets, javascript e sprites com o [Sprockets](https://github.com/sstephenson/sprockets) que [Sam Stephenson](https://github.com/sstephenson) - também criador do Prototype - iniciou em fevereiro de 2009 (obviamente os componentes que podem ser usados pelo Sprockets, como compressor, já existiam). Finalmente o Sprockets foi adicionado ao Rails 3.1 lançado em Agosto de 2011 como ["Asset Pipeline"](http://www.akitaonrails.com/2012/07/01/asset-pipeline-para-iniciantes). 

Hoje em dia o Sprockets continua sendo uma das opções mais completas e outros frameworks correram para criar suas próprias versões, como o ["connect-assets"](https://github.com/d-i/half-pipe) para Node.js, diversas receitas para Grunt e [Gulp](http://blog.carbonfive.com/2014/05/05/roll-your-own-asset-pipeline-with-gulp/)) e opções para [Grails](http://grails.org/plugin/asset-pipeline), [Cassette/ASP.NET MVC](http://getcassette.net/), [Pipeline Django](https://github.com/cyberdelia/django-pipeline).

No mundo de Web Components foi imediatamente criado o projeto [Vulcanize](http://www.polymer-project.org/articles/concatenating-web-components.html) ou no caso do mundo Rails podemos adicionar o processo ao próprio Sprockets com o projeto [Emcee](http://www.akitaonrails.com/2014/06/29/usando-polymer-com-rails), que foi o tema do meu post anterior. A idéia é pegar os HTML imports e concatená-los num único arquivo, incluindo tornar os links para stylesheets e javascripts externos como trechos inline num único HTML. Nem o Vulcanize e nem o Emcee atualmente minificam seus conteúdos, no entanto.

Note que imports é apenas uma parte do problema. Nem vamos entrar no problema de gerenciamento de versões (problema que projetos como Bower, NPM, Bundler no Ruby, PHP Composer, NuGet, Gradle, Pip, etc foram criados para resolver). O que acontece com componentes que dependem de versões específicas de outro componente? E bibliotecas internas como JQuery que um componente pode precisar? Ainda não sei o que acontece nesses casos.

## Web Components é uma "Revolução"?

Tudo isso dito, vamos revisar:

* Podemos criar conjuntos de tags isolados com Shadow DOM, com seus próprios estilos e comportamentos que não vazam e não automaticamente herdam estilos e comportamentos do DOM principal, a técnica é usar Shadow DOM (ou uma das formas antigas com Cleanslate, criação de elementos com Javascript, IFrame)
* Podemos definir trechos inertes de HTML que podem ser instanciados via Javascript para dentro do DOM. Com projetos como TemplateBinding recuperamos algo como HTMLBars e podemos mesclar dados com o template. A técnica é usar HTML template e Polymer (ou uma das formas antigas com Mustache, Handlebars, HTMLBars).
* Uma vez definido nosso "widget" ou "componente", podemos encapsulá-lo dentro de uma embalagem mais amigável usando Custom Elements (ou uma das formas antigas como plugins de JQuery fazem com Javascript para encapsular).
* E uma vez montado o Widget/Componente podemos empacotar tudo num único HTML Import para podermos resusar facilmente dentro de outros HTML (em vez da forma antiga de declarar manualmente os arquivos de dependência)

Vocês devem ter notado que do ponto de vista de um desenvolvedor que apenas consome tais componentes/widgets, o processo em si é uma melhoria mas não é tão diferente quanto utilizar plugins de JQuery. De fato é uma passo adiante, oficializando o que antes era "gambiarra" em alguma coisa um pouco melhor (Custom Elements em vez de Javascript, Shadow DOM em vez de IFrame, HTML Template em vez de string em tag Script).

E aqui vem o maior desafio ao conjunto de tecnologias de Web Components: ele é definitivamente melhor. Só que não é disruptivo. Ao usuário final, o que ele "vê" e "interage" numa página web no navegador será exatamente idêntico. Significa que o usuário final tem muito pouco a se beneficiar da tecnologia. Portanto ele não é o público-alvo.

O público-alvo é o desenvolvedor front-end que, em vez de buscar um plugin JQuery - por exemplo - vai buscar um Web Component e a forma de utilizá-los não será muito diferente. Como ele não tem a motivação de melhorar muita coisa a seu público-alvo, ele tem muito pouco incentivo para mudar sua forma de trabalho.

O raciocínio é simples: quero colocar um Carrossel na minha página. Existem centenas, [Jssor Slider](http://www.jssor.com/), [jCarousel](http://sorgalla.com/jcarousel/), [Slick - the last carousel you'll ever need](http://kenwheeler.github.io/slick/). E para Web Components? Pelo menos no momento deste artigo só encontrei o [Polymer-ui-carousel](https://github.com/addyosmani/polymer-ui-carousel), que não chega aos pés dos antecessores. Qual você acha que o desenvolvedor front-end vai escolher?

Existem dois repositórios de componentes públicos (aliás, não entendi porque existem dois, um projeto como esse não ganha nada nascendo já fragmentado): o [Component Kitchen](http://component.kitchen/) com cerca de 276 componentes e o [Custom Elements](http://customelements.io/) com 327 componentes. Como todo repositório inicial, a maioria deles não é de grande serventia. São mais demonstrações e provas de conceito. Sinceramente, alguém se dar ao trabalho para fazer um componente de Pokémon tem que ser só um tech-demo. É inútil. E você pode contar com coisas redundantes e/ou desnecessárias como botões de Facebook, gravatar, botão de Github, coisas que um [AddThis](http://www.addthis.com/) já tem resolvido. Claro, não quero ser injusto e dizer que Web Components não tem utilidade só porque a primeira geração de componentes não é interessante. Essas coisas levam tempo para amadurecer, como qualquer tecnologia.

Para que a estratégia funcione ou a tecnologia em si é <string>disruptiva</string> - o que acabamos de ver que não é, é apenas <strong>evolutiva</strong> -, ou é necessário um pacote completo para ser candidato a ["killer-app"](http://en.wikipedia.org/wiki/Killer_application). Voltamos ao que disse antes sobre uma solução procurando um problema. Sem um verdadeiro killer-app-blockbuster é muito difícil conseguir tração e coesão de um ecossistema. No caso do Ruby isso foi o Rails. No caso do Go parece que é o Docker. No caso do Node foi o halo-effect do Google Chrome evoluindo o V8.

Para isso o Google criou o [Polymer/Paper](http://www.polymer-project.org/components/paper-elements/demo.html#core-toolbar) que define um conjunto coeso e visualmente integrado (via filosofia gráfica e interativa do [Material Design](http://www.google.com/design/) que, assumindo que "pegue", também tem a vantagem de dar ao usuário final um "eye-candy" que justifique sua adoção). É uma proposição "tudo ou nada", embora você possa pegar pedaços dela, a intenção é fazer aplicações/sites usando inteiramente o Polymer.

O projeto [Polymer](http://www.polymer-project.org/) é ambicioso e somente uma corporação como o Google poderia fazer algo assim tão rápido (dado que metade das especificações de tecnologia de Web Components como HTML Imports e HTML template são deste ano de 2014). Ao contrário do que deveria parecer, a arquitetura não é simples e com o pouco suporte de navegadores a única estratégia é criar Polyfills, implementações ("quasi"-completas) para tudo que navegadores "legados" mas que muita gente usa como IE abaixo de 10, Safari e Mobile Safari. Para isso serve o [Polymer/Platform](http://www.polymer-project.org/docs/start/platform.html).

![Arquitetura do Polymer](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/413/polymer-architecture.png)

Só que já passamos do ponto de somente usar plugins JQuery, agora migramos para a era dos one-page-apps via Javascript que consome endpoints REST que retornam JSON. Estamos falando somente do ponto de vista de componentes, mas uma aplicação é maior do que isso. Para quem vem do mundo ASP.NET MVC, Rails, Django, falamos muito sobre o conceito "Web MVC" (Model-View-Controller) ou mais corretamente, [MVC Model-2](http://en.wikipedia.org/wiki/Model_2) da Sun, definido para J2EE.

Muitos nem sabem que usam outro modelo, o [MVP](http://en.wikipedia.org/wiki/Model–view–presenter) (Model-View-Presenter) presente em ASP.NET (antigo), Window.Forms, [GWT](http://www.gwtproject.org/?csw=1) (Google Web Toolkit, lembram? Também do Google!). E, finalmente, também da Microsoft chegamos ao [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) (Model View View Model), uma evolução de MVP com MVC2, mais conhecido pelos seus conceitos de Data Binding 2-way de elementos do DOM com models puxados via Javascript. Agora temos a categoria que vocês já devem ter conhecido com [Knockout.js](http://knockoutjs.com/), [Angular.js](https://angularjs.org/), [Ember](http://emberjs.com/). Estamos falando de mais do que o jeito MVP de arrastar componentes a um canvas e adicionar eventos de callback, mas um framework completo que lida com Models, Views, Rotas.

O Yehuda Katz escreveu sobre [integrar o Ember com Web Components](https://gist.github.com/wycats/9144666b0c606d1838be) em Maio e ele explicita muitos detalhes que vale a pena ler a respeito. Segundo esta [thread no Google Groups](https://groups.google.com/forum/#!msg/polymer-dev/4RSYaKmbtEk/uYnY3900wpIJ), parece que o projeto Angular 2.0 deve também se integrar com Web Components e Polymer. Quando estes projetos e outros frameworks se unirem ao esforço Polymer provavelmente vamos ver o real valor dos Web Components.

Polymer é o projeto principal. Web Components é o conjunto de mecanismos, o meio para atingir esse objetivo. E é um problema clássico de ovo e galinha: os navegadores diferentes de Chrome precisam se equiparar e seguir a vontade do Google. Os polyfills, via Polymer/Platform e [Mozilla X-Tag](http://www.x-tags.org/blog) vão suprir o que falta (Mutation Observers, Shadow DOM, etc) como o JQuery fez no passado. Mas para os navegadores tracionarem nessa direção os desenvolvedores precisam entrar no barco, e para isso somente um pacote completo como Polymer/Paper e, se possível, aliado a frameworks como Ember e Angular podem fazer isso acontecer, e não pequenos componentes-demonstração.

## A História se Repete

Já vimos essa história acontecer antes. Durante o [Browser Wars](http://en.wikipedia.org/wiki/Browser_wars) muitos apenas vão se lembrar que a Microsoft conspirou ativamente para destruir a Netscape, culminando no processo que quase quebrou a Microsoft em 3 no ano 2000 e a consequência final que foi a sobra do amaldiçoado Internet Explorer 6 que, apesar de ter sido um excelente navegador em sua era, ele não deveria nunca ter durado mais de uma década em uso.

Muitos talvez não lembrem que isso também gerou muitas novas tecnologias, para listar algumas:

* O Internet Explorer 3.0 foi o primeiro navegador a implementar o CSS 1.
* O Internet Explorer 4.0 foi quem expôs o DOM e criou o DHTML, Dynamic HTML, com Dynamic Styling e manipulação de elementos do DOM via Javascript
* O Internet Explorer 5.0 foi quem trouxe a semente do Ajax com o componente proprietário XMLHTTP e a técnica de buscar conteúdo de forma assíncrona com iframes usada no Outlook Web Access, dando origem ao XMLHttpRequest

O período negro pós-2000 da Microsoft culminou no fracasso do Windows Vista e consequente sobrevida à la The Walking Dead tanto do Windows XP quanto do IE 6. O Google pegou o bastão de onde a Microsoft largou. O Core Business do Google é o AdWords. Controlar as plataformas Web faz parte da estratégia e o navegador continua sendo importante, porque ele é o novo sistema operacional desta geração, seja desktop ou mobile. Esqueçam Windows vs OS X vs GNU/Linux.

Outra tecnologia Microsoft que foi esquecida foi a primeira verdadeira tentativa de componentizar a Web. Foi com [HTML Components](http://www.w3.org/TR/NOTE-HTMLComponents) do fim de 1998. Nessa época ainda estávamos tentando dominar drag-and-drop de elementos com DHTML e começando a brincar com as possibilidades de fazer requisições sem precisar recarregar a página.

Se olhar esta página de [APIs Legadas](http://bit.ly/1jV3VpJ) da Microsoft teremos:

* Legacy DOM - substituída, claro, pelo DOM mais moderno
* IE Architecture/Active X - substituído por Silverlight, Flash, ainda Applets e widgets
* Browser Extensions - ainda temos extensions mas nenhum padrão
* DHTML Behaviors e DHTML Data Binding - são os novos Web Components
* Filters and Transitions - que até hoje temos browser-specific com modificadores como -moz ou -webkit, CSS 3
* Vector Markup Language (VML) - que é o atual SVG e HTML 5 Canvas

Não estou querendo dizer que é tudo mérito da Microsoft. A intenção é apenas explicar - para quem começou a usar a Internet na era pós-Browser Wars e pós-[Crash das Dot-coms](http://en.wikipedia.org/wiki/Dot-com_bubble) que Web Components não surgiu do nada, ela é o próximo passo lógico da evolução dos browsers e arquitetura Web.

Para o próprio Google essa não é a primeira vez. A primeira vez foi com [GWT](http://en.wikipedia.org/wiki/Google_Web_Toolkit) (Google Web Toolkit), que nasceu em 2006. Esse foi o auge dos frameworks MVC back-end que facilitavam desenvolvimento de aplicações Web usando Ajax. Foi a era pós-J2EE onde surgiram Rails, Django e outros Rails/Django-like como CakePHP, Grails.

Depois veio a era back-end assíncrono, desenterrando o problema [C10K de 1999 de Dan Kegel](http://www.kegel.com/c10k.html), use case de Web Sockets (chat, APIs) que começa com Scala, vai para Node.js, chega em GoLang, Elixir. Novamente, não veio do nada, foi o próximo passo evolutivo depois do próprio Erlang, Twisted, Tornado, Java NIO/Netty, etc.

Em paralelo o Google investiu no Chrome e para isso precisou investir em Javascript e tornar o V8 algo realmente usável. Milhares de homens-hora e milhões de dólares depois, temos uma engine realmente performática. Com isso o mundo Javascript cresceu exponencialmente. Uma tecnologia que já se imaginava dominada na década de 90 ganhou nova roupagem e uma segunda chance. Com isso a arquitetura MVC2 evoluiu para um híbrido, com frameworks MVVM no client-side.

Portanto é natural evoluir do mindset GWT para Angular.js e eventualmente para Web Components/Polymer. E é onde estamos agora. Note que estamos sempre circulando os conceitos de MVC-clássico, MVC Model-2, MVP e agora MVVM, todos patterns originados do lendário MVC de [Trygve Reenskaug](http://heim.ifi.uio.no/~trygver/themes/mvc/mvc-index.html) do Smalltalk-80. Lembrando que já experimentamos programação orientada a componentes antes: foi a década de 90, que imaginou uma revolução ao usar componentes reusáveis para tornar o processo de programação meramente um jogo de arrastar blocos. Isso ficou conhecido como [RAD](http://en.wikipedia.org/wiki/Rapid_application_development) (Rapid Application Development), que deu origem a toolkits e IDEs. Foi o conceito que deu origem a PowerBuilder, Visual Basic, Delphi, Swing. E a evolução na direção de ferramentas CASE (Computer Aided Software Engineering). Achávamos que poderíamos criar diagramas (UML) e as ferramentas gerariam o código-fonte para nós. Já ouviu falar disso? Pois é, não deu muito certo. O Visual Studio de hoje [ainda tem suporte](http://msdn.microsoft.com/en-us/library/ff657795.aspx) a isso (yikes).

A diferença são as ondas da moda: na década de 90 ainda estávamos definindo o que era possível e, pelo bem ou pelo mal, o que a Microsoft inventou realmente foi revolucionário porque não havia precedente. A era pré-Bolha trouxe o MVC2 para o desenvolvimento Web com Web Objects e J2EE. O advento do Ajax e aplicações dinâmicas trouxe de GWT a Rails. E agora a era da Renascença do Javascript trouxe o MVVM e Web Components.

Não sei o que vem depois daqui, mas depois de organizar a informação histórica espero que mais alguém tenha insights do que vem pela frente. O que acham que Web Components realmente pode trazer que já não vimos com GWT e anteriores?
