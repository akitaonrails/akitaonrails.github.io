---
title: 'Rails Venceu: O Elefante na Sala'
date: '2016-05-23T17:21:00-03:00'
slug: rails-venceu-o-elefante-na-sala
translationKey: rails-has-won
aliases:
- /2016/05/23/rails-has-won-the-elephant-in-the-room/
tags:
- off-topic
- open source
- rants
- traduzido
draft: false
---

Acabei de ler um [artigo muito bem escrito e importante](http://solnic.eu/2016/05/22/my-time-with-rails-is-up.html) do contribuidor OSS Solnic e tenho que concordar com ele em quase todos os pontos técnicos.

Antes de mais nada, é inevitável, mas ainda odeio títulos dramáticos, mesmo que eu mesmo escreva assim às vezes. "Meu tempo com Rails acabou" é como dizer "E você também deveria largar Rails se for inteligente". Descartei o artigo por completo por causa disso. Estava prestes a escrever uma contra-rant sem ler direito, mas agora que li, escrevi este artigo novo do zero.

Solnic está certo: Ruby, por si só, tem pouco ou nenhum futuro sozinho. Rails é um monopólio real nesta comunidade e a maioria dos projetos OSS mira no Rails. E sim, Rails encoraja algumas práticas ruins e anti-padrões. Isso pode ser muito desanimador para muitos contribuidores OSS, especialmente porque mudar a direção de um Elefante enorme exige um esforço descomunal.

Deixando claro: os argumentos técnicos dialéticos que ele apresenta são todos verdadeiros. Mas metade do artigo — como ele mesmo disse — é pura rant, retórica. E acho que seria bom equilibrar isso, que é o que vou tentar fazer neste post.

### Aceitando a Realidade

A realidade é esta: Rails foi feito sob medida para o Basecamp.

Todos sabemos disso, ou deveríamos. Apps no estilo Basecamp não são muito difíceis de fazer, pelo menos em termos de arquitetura. Não precisa de linguagens sofisticadas super performáticas com primitivas de concorrência e paralelismo. E a realidade é que 80% das aplicações web são estilo Basecamp (com base na minha experiência em consultoria). É por isso que Rails resistiu até agora.

É como sistemas de gerenciamento de conteúdo, ou CMS. A maioria deles são sistemas de blog. E para isso você pode ir em frente e instalar o Wordpress. Os mesmos argumentos feitos contra o Rails podem ser feitos contra o Wordpress. E você nunca deveria tunar o Wordpress para ser qualquer coisa além de um sistema de blog. Tente transformá-lo num e-commerce de alto tráfego e vai sofrer.

Para deixar claro: Wordpress tem um dos códigos-fonte mais ofensivos que já vi. Odiaria ter que manter aquela base de código. Me desculpo se algum contribuidor do Wordpress estiver lendo isso, digo sem malícia. E sabe o quê? Possivelmente metade de todos os CMSs do mundo é Wordpress. Mais de um milhão de sites.

Depois tem o caso do Magento2. Grande reescrita sobre o Magento original, escrito usando toda aquela parafernália do Zend que todo mundo detesta. Mas é enorme. Se você precisa de uma solução rápida e pronta para e-commerce, não precisa procurar mais.

Plugins do Wordpress funcionam no Magento? Não. São 2 comunidades fragmentadas, independentes e isoladas. Mas ambas geram muito dinheiro, o que cobre o custo da redundância entre elas. E isso sem contar Drupal, Joomla. PHP é um grande oceano de ilhas desconectadas.

A fragmentação não é estranha ao mundo Javascript. Mas é um tipo diferente de geração de valor. Facebook, Google, Microsoft, todos querem ser os líderes de pensamento na geração Millennial em rápida evolução. É uma estratégia de longo prazo. E um dos elementos desse jogo é o Browser. Não só em termos de Chrome vs Firefox vs IE, mas também em como as aplicações são implementadas.

Facebook criou o React. Google criou o Polymer e o Angular. O pessoal do Node passou por uma luta de poder com a Joyent que quase resultou em mais fragmentação, mas chegaram a um acordo com a [Node Foundation](http://readwrite.com/2015/02/10/joyent-node-js-foundation/).

A Apple foi à guerra total contra o Flash da Adobe e só agora o Google está [desligando-os no Chrome](http://www.theinquirer.net/inquirer/news/2458329/googles-chrome-browser-will-switch-off-flash-content-by-default). A Apple quer que o nativo prospere e que o Swift seja a linguagem que lidere tudo. O Google tem estratégias conflitantes porque quer que os [Instant Apps](http://techcrunch.com/2016/05/18/google-takes-a-new-approach-to-native-apps-with-instant-apps-for-android/) nativos triunfem, mas se falharem, o plano B continua sendo dominar os apps web baseados em HTML5/CSS3 com Angular. O Facebook não quer ter seu destino decidido pela luta de poder entre Apple e Google.

É uma luta de poder complexa se desenrolando — não é sobre competência técnica, não é sobre geração de valor. É sobre ego, influência e poder. E as tecnologias web estão sendo mantidas como _reféns_ neste cerco.

Depois tem a questão de que o futuro do Ruby está agora fortemente acoplado ao Rails. Isso é uma realidade e se você é um Rubyista que não gosta de Rails, sinto muito. Mas não tanto. Por exemplo, se Hanami é interessante, acredito que pelo menos uma empresa investiu nele. Se ninguém está usando, então não importa o quão tecnicamente superior ele seja. Se Rom.rb é ótimo, alguém deveria estar usando — caso contrário qual é o ponto? Por que criar uma maravilha técnica que ninguém quer? Mas se há pelo menos uma empresa usando, é **razão suficiente** para continuar, independentemente do que aconteça com Rails ou do que DHH diga ou faça.

> As pessoas pensam que porque algo é "tecnicamente superior" todos os outros deveriam adotar cegamente. Mas não é assim que o mercado funciona.

De todos os eventos de tamanho cósmico que acontecem por aí, realmente não me preocupo tanto se Ruby continua amarrado ao Rails. O que ele faria sem ele?

Todas as comunidades enfrentam fragmentação em algum momento. É muito difícil e caro manter coesão por muito tempo. A única comunidade que acho que conseguiu isso por pura força de regulação é a stack .NET da Microsoft. O próprio Rails desempenhou um papel importante em influenciar a mudança do antigo ASP.NET para o ASP.NET MVC. Agora eles finalmente [adquiriram o Xamarin](http://blogs.microsoft.com/blog/2016/02/24/microsoft-to-acquire-xamarin-and-empower-more-developers-to-build-apps-on-any-device/) antes que o .NET pudesse escapar do controle deles em plataformas open source.

Ruby on Rails é a única outra comunidade "coesa" que já vi. Com a vantagem de que o Basecamp não precisa de centenas de milhares de desenvolvedores para existir. Um nicho de mercado seria suficiente para o framework evoluir gradualmente através de processos OSS. Por isso sempre questiono a história e as origens de ferramentas e tecnologias para tomar minhas decisões sobre onde usá-las, não só a competência técnica.

Rails funciona porque não precisa fazer política com Apple, Facebook, Microsoft, Google ou qualquer outro comitê (por padrão, nunca confio em comitês). Quem depende do Rails fará a manutenção diretamente. Heroku, Github, New Relic, Shopify e muitos desenvolvedores talentosos.

### 3 Leis da Realidade de Mercado

1. É fácil analisar demais algo após o fato. 10 anos depois, consigo traçar facilmente um caminho ótimo, evitando todas as armadilhas. Não me torna gênio nenhum, apenas mostra que consigo conectar os pontos — agora claramente visíveis.

2. Nenhuma implementação de solução é perfeita. Se ela resolve um problema real, está fadada a ser imperfeita. Se resolve num mercado em rápida mudança, mais imperfeita ainda.

3. Ou você constrói ferramentas porque suas aplicações de negócio dependem disso, ou constrói ferramentas para vender. As primeiras geralmente serão melhores — em termos de ajuste ao mercado. Então se tiver que escolher às cegas, vá com as primeiras.

Portanto, sempre preferirei ferramentas que resolvem um problema real feitas por quem realmente depende delas. Caso contrário, o filho do sapateiro ficará descalço. Por exemplo: vou usar Angular se precisar. Mas nunca começaria um novo negócio que dependesse exclusivamente do Angular para sobreviver. Por quê? Porque o Google não precisa dele. Não piscou para abrir mão do GWT, não precisou pensar duas vezes para reescrever o Angular 2 de forma incompatível com o Angular 1.

Sempre vejo quais fatores externos vão influenciar o destino da tecnologia. Imagine que passei muito tempo escrevendo scripts para o Grunt. As pessoas decidem que é ruim. Agora o Gulp é a melhor escolha. Você investe tudo migrando para Gulp. Então as pessoas decidem que Webpack é a melhor escolha. Síndrome NIH (Not-invented-here) em abundância.

Às vezes isso faz o monopólio do ASP.NET no campo Microsoft e o monopólio do Rails no campo Ruby parecerem inócuos. E sim, comparei Rails com .NET. São as 2 stacks mais comparáveis. Comparável à facção Spring no campo Java — Spring se levantou contra a complexidade enorme do J2EE oficial em 2002 e então ele mesmo se tornou o novo gigante estilo J2EE a ser combatido.

Este é um dilema milenar:

> "Ou você morre como herói, ou vive tempo suficiente para se ver se tornar o vilão."

### Por que Rails é um problema agora?

Como disse antes, concordo com quase todo problema técnico que Solnic apontou.

Rails é de fato a criação de David Hansson (DHH). DHH é uma pessoa, com um ego muito grande e um negócio para administrar. Não dá para esperar que qualquer pessoa seja razoável o tempo todo, especialmente uma que empurrou algo do zero, tanto um negócio quanto uma plataforma tecnológica.

Quando começou, as pessoas desertaram de Java, .NET, PHP e até Python em massa. Todos reconheceram como Rails era interessante comparado a J2EE, ASP.NET, Plone. Oferecia não só produtividade, mas prazer técnico. Estávamos discutindo o maravilhoso mundo das linguagens dinâmicas, classes abertas, injetando comportamento em tempo real (aka [monkey patching](https://m.signalvnoise.com/provide-sharp-knives-cc0a22bf7934#.zcxl5lbh8)), aplaudindo o abandono de todas as abstrações desnecessárias.

A Idade de Ouro de 2004 a 2006 viu um fluxo interminável de celebração da magia Ruby. Aprendemos Ruby através da magia negra mais obscura do [Why, the Lucky Stiff](http://poignant.guide/). Era tudo menos arquiteturas limpas e modulares.

Então entramos na Idade de Prata, de 2007 até por volta de 2011. Rails foi longe demais, rápido demais. De repente vimos grandes empresas surgindo de todos os lados! Twitter, Github, Engine Yard, Heroku, Zendesk, Airbnb — todo mundo bebeu o Kool-Aid do Rails. O Merb estava à frente do seu tempo e foi apresentado da maneira errada. Confrontar o todo-poderoso Rails de frente naquele momento não foi inteligente. Fiquei muito apreensivo em 2009 e 2010 para ver se a pseudo-reescrita do Rails 3 realmente se concretizaria.

2011 a 2016 foi a Idade do Bronze, um período agridoce. Muitas linguagens novas surgiram e atingiram o estado "utilizável": V8 e Node.js, Rust, Clojure, Elixir, Scala, Haskell. A mudança mais importante: 2010 viu o advento das App Stores, com aplicativos nativos para smartphones e tablets. Esqueça desenvolvimento web — o mobile estava ganhando tudo.

Foi aí que as grandes empresas mostraram seus bolsos fundos. Apple lançou Swift. Google lançou Dart, Angular, Go. Microsoft lançou TypeScript e ASP.NET MVC. Facebook entrou tarde com React e depois React Native.

Rails agora pode ser considerado um "problema" pelas mesmas razões que o tornaram popular. Isso está fadado a acontecer com qualquer tecnologia.

Mas não dá para mudar muito a arquitetura do Rails — corre-se o risco de quebrar partes enormes dos projetos em produção. E quando alguém precisa reescrever partes grandes de um projeto, é melhor considerar reescrever em outra coisa completamente.

Muitas pessoas estão fazendo exatamente isso, especialmente para APIs e SPAs. As APIs podem ser escritas em Go, Elixir, Scala, evitando Ruby. Você perde o giro rápido do ecossistema Rails, mas se puder pagar (Unicórnio com bolsos fundos), por que não?

Mas para os 90% dos projetos pequenos e médios por aí, ainda dá para conseguir o melhor custo-benefício com Rails. É como dizer: para um blog, use Wordpress. Não tente escrever um blog SPA com APIs em Go e React do zero. Factível, mas não vale a pena.

Se você já usa Rails há algum tempo, siga boas práticas básicas. Adicione testes. Refatore o código, remova duplicações, atualize gems. Considere adicionar uma camada de abstração como o [Trailblazer](http://trailblazer.to/) e componentizar partes da aplicação como [Rails Engines](https://leanpub.com/cbra) ou separar em APIs [Rails-API](https://github.com/rails-api/rails-api). Um passo de cada vez.

> Raramente se beneficia de grandes rewrites do zero.

### Conclusão

Para desenvolvedores como Solnic a comunidade Rails provavelmente é um lugar frustrante. Mas também é um vício difícil de largar porque Rails é muito maior do que qualquer concorrente, você sempre se sente mal por ser o azarão.

Rails foi de azarão ao mainstream em 5 anos. Possivelmente o crescimento mais rápido que qualquer framework web já alcançou. A vida de um desenvolvedor web de 1995 a 2003 não era particularmente interessante. Rails fez muito para melhorá-la.

A arquitetura do Active Record vai machucar de verdade talvez 10% dos casos. O Active Support não tem alternativa melhor ainda. Substituir o Active Record por DataMapper ou Rom.rb como padrão não vai trazer tanto valor para as centenas de aplicações existentes. Se eu tivesse que reescrever, faria uma nova aplicação usando Rails + Trailblazer ou iria direto para Hanami. Mas a maioria das pessoas decidiria a favor de abandonar Ruby completamente.

O Active Record poderia ser melhor? Claro! Temos Data Mapper, Sequel e ROM.rb para provar. Mas poderia ter sido feito melhor em 2004? Não acho. Em 2004 "NoSQL" nem era uma coisa. O melhor que tínhamos era o Hibernate, muito antes do JPA. E para todos os efeitos práticos, o Active Record ainda faz muito melhor do que a média. Mas se você é grande, deve ter cuidado.

As outras comunidades vão enfrentar os mesmos problemas. É inevitável. Tudo é muito mais fácil quando você tem uma comunidade pequena que pode quebrar coisas sem grande impacto. É muito mais difícil manter algo que ficou grande além de todos os cenários otimistas.

Entendo a abordagem conservadora do DHH ao não fazer grandes perturbações. É um movimento válido — vai alienar desenvolvedores avançados como Solnic, mas ainda vai permitir que iniciantes mergulhem nele sem se preocupar com abstrações demais.

Atualização: DHH comentou nesta seção depois:

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr"><a href="https://twitter.com/AkitaOnRails">@akitaonrails</a> It's not out of conservatism. But a difference of opinion and values. I love Active Record. Love callbacks.</p>&mdash; DHH (@dhh) <a href="https://twitter.com/dhh/status/735051111141396480">May 24, 2016</a></blockquote>

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr"><a href="https://twitter.com/AkitaOnRails">@akitaonrails</a> Will everyone love the same techniques and methods as me? Of course not (see RSpec for just one popular example!). That's fine</p>&mdash; DHH (@dhh) <a href="https://twitter.com/dhh/status/735051237071171584">May 24, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

As pessoas esquecem que abstrações são muito boas para desenvolvedores avançados que sofreram com a falta delas. Mas iniciantes sempre vão sofrer se apresentados com muitas escolhas arquiteturais logo de cara. Pessoas experientes frequentemente esquecem a curva de aprendizado de quando eram iniciantes, e naquela época Rails era tão atraente. Lembra aquela sensação de realização?

**Rails venceu** pela sua simplicidade para iniciantes, orientação clara para pessoas experientes e flexibilidade razoável para desenvolvedores mais avançados. Conseguirá manter mais 10 anos? O tempo dirá.

Para terminar, com Bob Dylan:

> Reúnam-se ao redor, pessoas

> Onde quer que vagueiem

> E admitam que as águas

> Ao redor de vocês cresceram

> E aceitem que em breve

> Vocês estarão encharcados até os ossos.

> Se o seu tempo para você

> Vale ser salvo

> É melhor começar a nadar

> Ou vai afundar como uma pedra

> Pois os tempos estão mudando.

> ...
