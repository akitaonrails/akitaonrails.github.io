---
title: "Por que Falar Mal do Ruby on Rails é Simplesmente Preguiça"
date: '2017-08-03T18:01:00-03:00'
slug: por-que-falar-mal-do-ruby-on-rails-e-simplesmente-preguica
translationKey: lazy-to-bad-mouth-rails
aliases:
- /2017/08/03/why-is-it-just-lazy-to-bad-mouth-ruby-on-rails/
tags:
- ruby
- rails
- traduzido
draft: false
---

É inevitável hoje em dia: de tempos em tempos vai aparecer um artigo proclamando a morte do Ruby on Rails. É o click-bait mais fácil do mundo, como [esse aqui do TNW](https://thenextweb.com/dd/2017/07/26/ruby-rails-major-coding-bootcamp-ditches-due-waning-interest/#.tnw_kWT917pu).

Você pode responder _"mais um fanboy de Ruby."_ Tudo bem, é um argumento justo de fazer, mas terrível de sustentar, porque é o clássico e raso [argumentum ad hominem](https://en.wikipedia.org/wiki/Ad_hominem). E já que estamos no assunto de falácias, o artigo click-bait acima está errado exatamente porque cai numa [Post hoc ergo propter hoc](https://en.wikipedia.org/wiki/Post_hoc_ergo_propter_hoc) descarada, temperada com um bom tanto de [viés de confirmação](https://en.wikipedia.org/wiki/Confirmation_bias) — do qual todos nós somos culpados o tempo todo.

Não estou dizendo que o autor escreveu essas falácias de propósito. Infelizmente, é fácil demais cair nelas. Especialmente quando todo mundo tem um desejo intrínseco de confirmar suas próprias crenças. Mesmo tentando ser cuidadoso, eu mesmo acabo fazendo isso.

Sobre o assunto específico de Rails, comece por aqui:

* [Rails has won: The Elephant in the Room](http://www.akitaonrails.com/2016/05/23/rails-venceu-o-elefante-na-sala)
* [The Ruby Community and Reputation](http://www.akitaonrails.com/2016/08/19/a-comunidade-ruby-e-a-reputacao)
* [Programmers Guild - Religion and Sports](http://www.akitaonrails.com/2017/05/14/guilda-de-programadores-religiao-e-esportes)

Como regra geral, qualquer pessoa anunciando a morte futura de qualquer coisa está provavelmente errada. É divertido fazer apostas, mas artigos em sites de alto perfil como o TNW deveriam ter mais cuidado, já que muitos iniciantes acabam acreditando piamente nessas opiniões.

É por isso que eu sempre digo às pessoas: parem de confiar em opiniões. Todo mundo tem uma opinião, e é exatamente por isso que elas são tão baratas. Aí as pessoas artificialmente elevam "celebridades" ou "gurus" ao status de quem tem opiniões de maior valor. Eu não compro isso, e você também não deveria.

[Cisnes Negros](https://en.wikipedia.org/wiki/Black_swan_theory) acontecem. Mas tentar prevê-los é exercício de futilidade. Você pode ter sorte uma ou duas vezes. Mas tentativas sistemáticas são inúteis. Por isso sou um grande defensor da [Antifrabilidade](https://en.wikipedia.org/wiki/Antifragility) — e vou te dar as regras gerais para entender o que fazer.

Estou dizendo que Ruby on Rails vai durar para sempre? Não seja ridículo, claro que não. Nada dura para sempre. Mais de 2 décadas trabalhando ativamente na área me ensinaram que apostar tudo num único cavalo é um erro. Vale no mercado financeiro, vale no mercado de tecnologia.

Em vez de ações ou títulos, o seu ativo é o seu conhecimento e a sua prática. Diversificação de portfólio costuma ser a aposta mais inteligente.

Você colocou todo o seu dinheiro em Bitcoins. Agora vai fazer de tudo para confirmar esse viés, assinando todo noticiário e opinião que confirma sua aposta, e vai atacar qualquer artigo que apresente um argumento contrário. Estou dizendo para não investir em Bitcoins? De forma alguma. Só não seja burro a ponto de colocar tudo num único ativo.

Você gastou todo o seu tempo aprendendo [Google Web Toolkit](https://en.wikipedia.org/wiki/Google_Web_Toolkit) em 2006. Boa sorte encontrando artigo que confirme esse viés agora. Esse é um daqueles casos post-factum em que só nos resta concordar consensualmente sobre a morte da coisa.

> O trabalho de um programador profissional de verdade não é dominar uma única ferramenta ou mesmo um único stack tecnológico. Seu trabalho é ser o melhor possível em aprender e praticar na área de tecnologia.

Dito isso, e mesmo que a estrutura do artigo seja imprecisa, o sentimento não está de todo errado. Ruby on Rails não representa mais o que representava há 10 anos. Mas antes de entrar em pânico, vamos explorar essa história juntos.

### 2003 - Um Novo Renascimento

Num exercício retrospectivo, é preciso reconhecer que uma série de eventos ajudou a desdobrar o fenômeno Rails entre 2003 e 2011. Não foi por design. Não foi planejado. Poderia ter sido outra coisa qualquer.

- Estávamos nos recuperando do crash da bolha dot-com de 2001.
- Redes sociais começavam a emergir: Orkut, MySpace, Friendster. Facebook ainda nem estava no radar.
- Blogs ganhavam força e competiam com os veículos de notícia tradicionais.
- Os grandes fornecedores focavam exclusivamente no mercado Enterprise e o resto era considerado amadorismo.
- No mainstream, ou você fazia .NET ou Java no Enterprise, ou fazia hotsites em Flash e PHP para agências.
- Até ferramentas open source como o Eclipse eram usadas principalmente dentro de umbrellas enterpriseiras como WebSphere ou WebLogic.
- O Manifesto Ágil tinha acabado de ser publicado em 2001 e o mercado mainstream não ligou muito. PMI e RUP eram a ordem do dia.

Então chegamos a 2004.

- O Google lançou o Gmail com grande repercussão. HTML dinâmico e Ajax demonstraram como era possível criar aplicações de nível Desktop na Web. É aí também que o Javascript ganha um novo papel, além de mini jogos burros ou anúncios.
- O Facebook explodiu e tivemos os primeiros vislumbres do que redes sociais granulares pareciam.
- A Apple consolidou seu retorno como gigante tech relevante com a ressurreição bem-sucedida do OS X, provando que Unix no desktop do consumidor era viável.
- A Microsoft entrou no século XXI depois de um pesadíssimo processo antitruste que quase a destruiu. Bill Gates saiu, Steve Ballmer assumiu as rédeas e eles viveram sua pior década.
- Anos de lock-in de fornecedor finalmente começaram a cansar os desenvolvedores; ninguém de verdade queria mais usar IBM, BEA, Oracle — e a promessa da revolução open source iniciada nos anos 90 finalmente começava a se solidificar.
- O crash dot-com deixou uma depressão no mercado tech, mas também deixou para trás uma infraestrutura que finalmente estava sendo bem aproveitada.

![How Bill Blew it](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/654/s-l225.jpg)

O Ruby on Rails aparece como uma pequena curiosidade, numa conferência tech obscura no Brasil, criado por uma agência pequena mas promissora chamada 37signals. Sinalizando algo que a maioria dos desenvolvedores nunca tinha visto antes: uma linguagem flexível — diferente de Java, C# ou PHP — que podia ser usada para implementar aplicações web estilo Gmail com a estética da Apple, se afastando de tudo que Microsoft e IBM representavam, e incorporando técnicas ágeis como Test-Driven Development de forma prática e já inclusa.

[![15 minute blog](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/655/75879992_fa890a9a07.jpg)](https://www.youtube.com/watch?v=Gzj723LkRJY)

O que mais você poderia pedir em 2005?

Então chega **2006**: a Amazon AWS lança S3 e EC2 e o termo "Elastic Cloud" vira o novo hype.

Até aquele ponto, "desenvolvimento web" significava ou departamentos de TI caros e burocráticos em grandes corporações, ou hospedagem compartilhada barata mas fraca em serviços como Dreamhost, 1&1, Media Temple.

A Elastic Cloud tinha a chave para superar o Enterprise e tornar possível que desenvolvedores independentes construíssem a tão sonhada "escala web".

O Ruby on Rails estava exatamente onde precisava estar: começando a ser adotado por uma nova safra de startups do Vale do Silício tentando fazer a diferença nessa nova era Ajax + Cloud. Lembre que o Rails foi lançado com RJS, uma forma de escrever Javascript via Ruby usando Prototype e Scriptaculous. O jQuery nem era mainstream ainda.

O Twitter aparece. O Groupon aparece. A Engine Yard aparece. E muito mais vem na sequência.

Tudo isso acontecendo numa velocidade absurda — e estou apenas arranhando a superfície aqui.

{{< youtube id="4XpnKHJAok8" >}}

**2007** chega e pelo menos 3 coisas grandes acontecem:

- Nasce outra startup baseada em Rails: Heroku. Se o EC2 da AWS cunhou o termo "Infrastructure as a Service" (IaaS), o Heroku definiu o que "Platform as a Service" (PaaS) significa. Conseguiu aproveitar o EC2 e tornar seu poder acessível.
- Ao mesmo tempo, desenvolvedores tinham ficado frustrados com sistemas de controle de versão como CVS, e as opções dos grandes fornecedores como Rational ClearCase, Microsoft SourceSafe eram simplesmente terríveis. O Subversion tinha surgido, mas suas muitas limitações seriam sua perdição. Linus Torvalds decide resolver o problema e lança o Git. Desenvolvedores mainstream finalmente aprendem termos básicos de ciência da computação como DAGs ("Directed Acyclic Graphs").
- O iPhone é lançado e uma nova revolução mobile começa. Players dominantes como Nokia e Blackberry foram abalados até o núcleo. Desenvolvedores queriam uma fatia disso. O Mobile Safari vira destaque da noite para o dia. E o WebKit sobe ao estrelato, eclipsando veteranos como Firefox/Gecko e Opera.

**2008**: o nascimento do GitHub e o alvorecer do DevOps.

O Git era ótimo, mas baixo nível demais. Vários outros concorrentes tentaram se tornar o novo padrão — Mercurial, Bazaar. Mas o nascimento do GitHub mudou tudo isso. E era mais uma startup baseada em Rails nas manchetes.

![There's an App for that](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/653/Theres-An-App-for-That-Tanglewood-Moms.jpg)

Mas a lua de mel mostrava sinais de esgotamento: o proeminente desenvolvedor Ruby Zed Shaw [saiu da comunidade em alto e bom som](https://techcrunch.com/2008/01/01/zed-shaw-puts-the-smack-down-on-the-rails-community/) em janeiro.

Nesse mesmo ano tivemos a guerra fria entre o framework Merb da Engine Yard e o Rails da 37signals, que resultou no [controverso merge Rails-Merb](http://yehudakatz.com/2008/12/23/rails-and-merb-merge/), abrindo mais uma rachadura na comunidade.

Mas ainda tínhamos muito trabalho pela frente, então seguimos em frente.

**2009**: "tem um app pra isso!"

A Apple finalmente lança um SDK nativo de verdade. Desenvolvedores começam a construir uma nova geração de apps de produtividade e jogos. O WebKit cresce em participação de mercado. A Apple solidifica o conceito de estética no desenvolvimento de software e o Ruby on Rails está no seu auge nesse ponto.

Começa a era NoSQL. Quando armazenamento e busca de dados realmente viram um gargalo, rapidamente aprendemos que bancos de dados enterpriseiros tradicionais não são "web scale" o suficiente. O MongoDB lidera o bando. O desenvolvimento web entra numa era de frenesi com NoSQL.

Em paralelo, o Twitter, que foi o cartão-postal da geração Rails, abre uma rachadura na comunidade Ruby ao declarar que começou a usar mais uma linguagem obscura: [Scala](http://www.artima.com/scalazine/articles/twitter_on_scala.html)!

Isso dá início à era da obsessão sem fim com "concorrência" — mais um conceito escorregadio sobre o qual muita gente fala bonito mas poucos de fato entendem o que significa. É o início da janela de oportunidade para Node.js, Scala, Erlang, Clojure, Go.

A lua de mel acabou.

**2010**:

- A morte da Sun e a Oracle assumindo o Java. Se as coisas já não estavam boas para o Java, isso foi um prego pesado no caixão.
- A Apple declara guerra aberta ao Flash. Mais um grande empurrão para Javascript e apps web front-end pesados.

[![Thoughts on Flash](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/656/apple-no-flash-250x376.jpg)](https://www.apple.com/hotnews/thoughts-on-flash/)

Na minha opinião pessoal, esse é o ano em que o Rails atingiu seu pico de influência. Era o stack obrigatório para desenvolvedores em Macs que queriam criar sua nova Lean Startup do zero.

{{< youtube id="icMA9rYNmgU" >}}

### 2011: Uma Nova Era

Em cerca de 6 anos, o mercado de desenvolvimento de software fez mudanças titânicas:

- O desenvolvimento distribuído derivado de anos de workflow Open Source se torna o novo padrão. Git e GitHub foram peças-chave. Os grandes fornecedores precisaram correr atrás com suas alternativas enterprise mal cheirosas como o TFS.
- O Ágil passa a ser levado a sério por uma nova safra de startups tech que evangelizavam desenvolvimento de software de qualidade. Os testes deixam de ser coisas improdutivas e chatas para se tornarem técnica central e inestimável. Ferramentas como Hudson/Jenkins combinadas com o workflow do Git pavimentam o caminho para o que a integração contínua e depois o deploy contínuo se tornariam.
- A AWS e o exemplo do Heroku pavimentam o caminho para tornar a TI antiga obsoleta e criar uma nova geração de infraestrutura como software, o "DevOps". Surge a urgência de fazer deploy em escala web com zero atrito. O time-to-market vira fator-chave: release cedo, release com frequência.
- A Apple lança a AppStore e ajuda a impulsionar o mercado de Software como Serviço, com apps precisando de internet ao vivo para funcionar. A "Cloud" chega às massas.
- Ao fazer com que todo ser humano no planeta carregasse um dispositivo poderoso e sempre conectado — um smartphone —, nunca estivemos tão perto do futuro orwelliano de 1984. Tudo que uma pessoa faz vira ponto de dados. Big Data se torna uma coisa. Ciência de Dados se torna uma profissão viável no mainstream. Disciplinas relacionadas à IA se tornam necessidade para raciocinar sobre tanto dado.

O Android se aproxima do iPhone. A Microsoft ressurge das cinzas. Em outubro, Steve Jobs morre, marcando o fim da Era de forte influência da Apple.

Mas por volta de 2011 outra coisa acontece: nós vencemos.

Desenvolvedores independentes superaram o status quo dos desenvolvedores enterprise. Houve uma virada de poder. As convenções para o campo do desenvolvimento de software não vêm mais dos velhos fornecedores de ferramentas. Não estamos mais ouvindo fabricantes de IDEs como Microsoft, BEA, Oracle. Estamos ouvindo os vencedores dessa geração de startups: Apple, Google, Facebook.

O conceito de _"uma linguagem para governar todas"_ foi destroçado no campo web pelo Ruby on Rails e no espaço de aplicações nativas pela Apple. Duas linguagens muito incomuns e estranhas, Ruby e Objective-C, atingiram o mainstream. Elas provaram que desenvolvedores podem aprender e dominar linguagens exóticas transformando-as em produtos lucrativos.

Com essas bases estabelecidas, uma nova **corrida do ouro** emerge: linguagens novas para todo lado, livres da noção de que para ter sucesso era preciso ficar em Java, C#, C++ — as pessoas finalmente começaram a olhar para outros lados para se diferenciar, e assim uma nova geração de linguagens exóticas chega: Scala, Haskell, Ocaml, F#, Erlang, Clojure, Rust, Elixir, etc. O céu é o limite.

Ao matar o Flash e acelerar HTML 5, ES6, e com toda a controvérsia em torno de concorrência, o Javascript ganhou nova vida e uma adoção rápida como nada antes.

### Epílogo

O Ruby on Rails está morto? Não.

O Ruby on Rails ainda é o líder do mercado? Não.

Qual é o legado da Geração Ruby on Rails? Ele teve um papel importante em definir o que hoje consideramos o novo status quo do desenvolvimento web: Git, CI, CD, Cloud, Métricas. Trouxe à mesa, com força, o pensamento estético da Apple.

Essa nova safra de startups tech teve um efeito colateral sério, porém: colocou novos engenheiros nos holofotes, elevando-os ao nível de rock stars e transformando-os em pretendentes a Steve Jobs. Eles simplesmente começaram a tomar tudo que conquistamos como garantido. Receita para o desastre.

E embora a influência dos grandes fornecedores tenha ficado rala comparada aos anos 90, eles não estão mortos. Depois de 2011 entramos numa nova era de caos, uma era de desenvolvedores insatisfeitos. Onde a cada dois anos surge uma nova derivação e temos aquela sensação insatisfatória de precisar reescrever tudo o tempo todo.

O pool do Ruby on Rails se diluiu em linguagens de nicho menores como o próprio Javascript, Go, Elixir, Scala.

O mainstream Java/Microsoft está ganhando nova tração. A estética também se diluiu. A engenharia cuidadosa está se diluindo. A ubiquidade das redes sociais e o caminho fácil do deploy rápido na nuvem estão tornando as pessoas cada vez menos pacientes. Artesanato requer paciência. As pessoas anseiam por Likes, uma nova geração de métricas de vaidade surgiu.

Temos agora um número maior de desenvolvedores independentes não-enterprise com pouca ou nenhuma paciência, com um senso exagerado de confiança, síndrome de [not-invented-here](https://en.wikipedia.org/wiki/Not_invented_here), tomando tudo como garantido e se importando cada vez menos com valor de verdade.

Concluindo: a morte do Ruby on Rails está sim muito exagerada, ele vai continuar por muitos anos ainda — especialmente se o Ruby Core Team conseguir entregar de fato a [meta 3x3](https://blog.heroku.com/ruby-3-by-3). As pessoas adoram compartilhar artigos de doom enquanto relatórios otimistas e mais realistas como [Por que Ruby on Rails ainda é a melhor escolha?](https://reinteractive.com/posts/320-why-ruby-on-rails-is-still-the-best-choice) são amplamente ignorados. É assim que funciona a vaidade das redes sociais.

Mas não vai ser o que foi, porque os tempos mudaram. Hoje podemos viver pelo workflow "On Rails" sem o Ruby on Rails. E ele não pode continuar quebrando o status quo, porque ele se tornou o status quo.

Fico curioso sobre para onde isso vai nos levar. Tenho algumas pistas, mas como disse, não estou no negócio de publicar manchetes click-bait.
