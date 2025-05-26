---
title: Evolução pela Concorrência
date: '2006-09-27T16:13:00-03:00'
slug: evolução-pela-concorrência
tags:
- off-topic
- principles
- markets
draft: false
---

 ![](/files/402px-AdamSmith.jpg)

Não lembro se escrevi sobre isso em algum post ou se foi no meu livro mesmo, porém existe um senso comum que chamo de **“Evolução pela Concorrência”**. Discussões como _“Ruby VS Java”_, _“Rails VS J2EE”_ não são exclusividades da comunidade Ruby on Rails (RoR). Muito pelo contrário. Vamos listar algumas discussões recentes no mundo da informática:

- Firefox VS Internet Explorer
- Macs VS PCs
- Windows VS Linux
- C# VS Java

A Microsoft é favorito no papel de vilão. Ela atua em praticamente todos os mercados de informática, por isso sempre será motivo de críticas. _“Windows é ruim”_, _“Office é uma droga”_, _“Internet Explorer não presta”_, _“Visual Basic não é linguagem profissional”_, etc. Alguns argumentos são válidos, outros são apenas birra de visões estreitas.

Críticas são construtivas quando as pessoas tomam atitudes. Radicais são desnecessários neste mundo. Pessoas que apenas xingam e não agem são irrelevantes: **_“quem não faz parte da solução, faz parte do problema”_**.


Parabéns a todos que demonstraram sua insatisfação com o status quo criando alternativas de altíssima qualidade aos criticados produtos Microsoft. Nenhuma é perfeita, mas sua dedicação deve ser reconhecida. Atualmente somente uso Firefox (ou o [Camino](http://www.caminobrowser.org/) para Mac, que usa a mesma engine Gecko). O Linux, graças ao apoio tecnológico de gigantes como a IBM, ganhou filesystems avançados como o JFS do AIX, o XFS do Irix (Silicon Graphics), suporte a [NUMA](http://lse.sourceforge.net/numa), clusters, gerenciamento mais avançado de [threads](http://www.onlamp.com/pub/a/onlamp/2002/11/07/linux_threads.html), virtualização como [Xen](http://kerneltrap.org/node/4168), e muito mais que o tornou uma alternativa confiável para grandes servidores.

A Apple também não é mais uma empresa irredutível. Ela soube assumir seus erros e fazer transições cada vez mais eficientes. Dos processadores Motorola para IBM PowerPC, do obsoleto MacOS 9 ao avançado MacOS X baseado em núcleo Unix e agora saindo dos IBM PowerPC para Intel Core Duo e Core 2 Duo. Mudar para evoluir.

A Microsoft, por sua vez, não está quieta. Vendo seus concorrentes se levantarem contra ela, criou um sistema para eliminar boa parte das críticas: o Windows Vista. Apesar dos diversos tropeços e atrasos, promete ser um sistema robusto e moderno. Melhor que o Linux? Melhor que o MacOS X? Quem sabe. Mas a evolução está acontecendo. O mesmo para sua plataforma de desenvolvimento: com a ameaça Java criou-se a alternativa .NET. Ambos tem vantagens e desvantagens, mas .NET tem funcionalidades fantásticas que não podem ser ignoradas.

Esse fato não é exclusividade do mundo de TI. É uma característica inerente do [capitalismo](http://en.wikipedia.org/wiki/Capitalism), a inteligência em torno do sistema de concorrência é que isso inevitavelmente leva à evolução. As empresas hoje são melhores que dez ou vinte anos atrás. É o exato motivo de porque monopólios precisam ser erradicados.

É o caso do nosso mercado de telecomunicações. Quando sofríamos nas mãos do ineficiente monopólio estatal conhecido como Telebrás, conseguir uma linha telefônica levava meses e custava obscenamente caro. Hoje, com concorrentes como Telefonica, Embratel, uma linha pode ser adquirida praticamente de um dia para ou outro por um preço razoável. O serviço é longe de perfeito (vide Procon), mesmo assim é inegável que as coisas só começaram a melhorar depois da privatização.

E o que isso tudo tem a ver com Rails? Um corolário desse fator é que tecnologias pouco discutidas, pouco criticadas, tendem a estagnar ou pior: serem esquecidas. É o mesmo efeito que acontece nos monopólios: se uma empresa fica muito tempo sem concorrente, ela sofre o efeito oposto: se acomoda, piora, desestabiliza até que, finalmente, surge um concorrente para desbancá-la. Por isso mesmo, em um mercado saudável, é imperativo que exista concorrência.

Procurem tecnologias como [BeOS](http://en.wikipedia.org/wiki/BeOS), linguagens como [Nemerle](http://nemerle.org/Main_Page), [Scheme](http://www-swiss.ai.mit.edu/projects/scheme/). Apesar de existirem pequenos nichos, elas foram esquecidas do mercado como um todo. Não quer dizer que eram ruins, mas por circunstâncias diversas, não foram criticadas o suficiente, não foram sabatinadas o suficiente.

Expliquei tudo isso para chegar a este ponto: Ruby e Rails estão sob constante crítica, sendo observados com minúcia, sendo excrutinados sem cerimônia. E isso é excelente. Todas as engrenagens da evolução estão em movimento. Graças a toda essa atenção, todas as críticas, dúvidas e inseguranças, pessoas inteligentes da comunidade se levantaram para completar o que falta, levando RoR rapidamente a níveis que não alcançaria sozinho. Vejamos alguns exemplos:

##### RoR não suporta Internacionalização

Para alguns, esta é uma falta grave. Mais grave ainda porque a própria linguagem Ruby não é muito amigável para Unicode. Lembre-se que Ruby foi feito no Japão, para os japoneses, no começo da década de 90. Detalhei esse assunto no livro, mas resumindo, hoje temos soluções como o [Globalize](http://wiki.rubyonrails.org/rails/pages/Internationalization).

##### RoR não tem o equivalente a EJBs

De fato, apesar de extremamente burocrática, os containers EJBs atuais são bastante robustos. RoR equivale a apenas o container de servlets de um sistema J2EE completo. Mas graças a **Ezra Zygmuntowicz** agora temos [BackgrounDRb](http://www.infoq.com/articles/BackgrounDRb). Ele funciona mais ou menos como um Message Bean para execução de tarefas assíncronas. Não é necessariamente melhor, mas é uma solução.

##### RoR não passa de um gerador de templates

É a velha conversa sobre scaffolds. Muitos novatos ou críticos pouco avisados acreditam que Rails é apenas o método scaffold. Claro, estão redondamento errados. Não podemos negar que é um conceito incrível, difícil ou impossível de ser atingido em linguagens estáticas. Porém, o Scaffold padrão do Rails é muito simples. Faltam recursos como interpretar os relacionamentos entre tabelas, por exemplo. Surgiram diversas alternativas, mas as mais interessantes são Streamlined e AjaxScaffold, como já [mencionei](http://www.akitaonrails.com/2006/09/27/snakes-vs-rubies-scaffold-on-steroids) alguns posts antes.

##### RoR privilegia apenas projetos Green Field

_“Green Field”_ é o que chamamos projetos iniciados do zero, ou seja, não-legado, onde temos a chance de escolher como implementar. Ou seja, onde podemos começar um projeto usando as convenções do Rails. O problema é tentar implementar um módulo em Rails em cima de um banco de dados que já existe, totalmente fora das convenções do Rails. Nesse caso, teremos trabalho. Para facilitar as coisas, Robby Russel está escrevendo o plugin [Acts as Legacy](http://www.robbyonrails.com/articles/2006/04/14/sneaking-rails-through-the-legacy-system), uma extensão para Active Record que deve tornar as coisas mais fáceis.

##### RoR utiliza scriplets: código misturado com HTML, isso é terrível

Essa discussão é interminável. A engine de renderização de views do Rails, Erb, de fato utiliza o equivalente aos scriplets de JSP ou PHP, onde misturamos código Ruby puro diretamente no meio de HTML. No caso específico de Rails, é uma grande funcionalidade. Mas existem aqueles que preferem algo parecido com taglibs: um HTML livre de programação, principalmente quando queremos envolver Web Designers. Uma grande alternativa é o projeto [Liquid](http://home.leetsoft.com/liquid), que traz funcionalidades semelhantes ao Velocity do mundo Java. Desta forma podemos atender gregos e troianos.

##### RoR sozinho é muito crú. Python, por exemplo, tem Zope/Plone

Rails é um framework. Alguns querem extender a briga implicando que Rails perde para, por exemplo, Zope. Para quem não conhece, Zope é um excelente gerenciador de conteúdo (CMS) escrito em Python. Claro, CMS e frameworks é como comparar maçãs e laranjas. Porém diversas soluções inteligentes estão sendo escritas em Rails. No setor de CMS (conteúdo, blogs) temos produtos como o famoso [Typo](http://typosphere.org/) ou [Mephisto](http://mephistoblog.com/). Como solução de eCommerce temos o [Shopify](http://shopify.com/).

##### RoR pode usar bons Design Patterns mas não implementa conceitos novos como Rules Engine

Rules Engine, ou Business Rules Engine, é uma inteligência para gerenciar regras de negócios. Trata-se de um conceito recente que ainda está em fase de amadurecimento, o que significa que fornecedores diferentes implementarão o conceito de maneiras diferentes. No mundo Java um dos mais famosos é o JBoss Rules (Drools), mas no mundo Ruby já temos uma alternativa chamada [Rools](http://rools.rubyforge.org/).

##### RoR não tem tantas bibliotecas quanto Java

Verdade. Apesar de linguagem Ruby já ter mais de 10 anos, apesar de Rails ganhar plugins novos o tempo todo, é inegável que Java tem uma biblioteca enorme de alternativas, perdendo talvez apenas para C/C++. Um novo fato pode mudar isso: a **[Sun recentemente contratou os criadores do JRuby](http://weblog.rubyonrails.com/2006/9/7/sun-hires-the-jruby-team)**, uma maneira de rodar código Ruby diretamente na JVM, abrindo caminho para que código Ruby tenha acesso a todas as bibliotecas que o Java. Se a Sun fizer sua lição de casa direito, em pouco tempo teremos uma versão de Ruby que roda em JVM com alta performance, robustez, suporte internacionalizado e acesso à uma infinidade de bibliotecas.

##### Finalmente, por que Rails foi feito em Ruby? Não poderia existir um “Jails” ou coisa parecida?

De fato, muitos se questionam o fato de Rails ser escrito em Ruby. À primeira vista parece apenas uma birra do programador contra Java. Estudando as características das linguagens mais famosas, fica claro que Rails só é Rails se for em Ruby. Para provar basta observar os frameworks mais recente (a maioria ainda inacabada) escrita em outras linguagens copiando os mesmos conceitos de Rails. Em Java/Groovy temos o [Grails](http://grails.codehaus.org/), em PHP temos o [CakePHP](http://www.cakephp.org/), em .NET temos o [Castle](http://www.castleproject.org/index.php/Main_Page). Leiam suas documentações, experimentem os códigos. Depois disso verão que todos tentam mas nenhum tem a mesma “sensação” que Ruby on Rails.

Mas isso não tem importância pois, como disse antes, faz parte do jogo da concorrência. É necessário que essas alternativas apareçam. Existem dois motivos. O primeiro porque frameworks concorrentes obrigam a comunidade Rails a inovar e evoluir mais rápido, sem acomodar. Segundo porque isso ajuda a justificar a escolha de Ruby para criar Rails.

A mensagem é simples: não se incomodem com críticas. Aceitem, entendam e evoluam. No mundo real não existe o fantasioso lema Highlander _“só pode haver um”_. Tecnologias que reinam sozinhas devem temer: não há mais para onde subir, apenas cair. A evolução funciona em ciclos, como tudo na vida: nascem, crescem e morrem.

Como consultor, minha função é justamente escolher os _“best of breed”_, ou seja, os melhores em cada setor, naquele momento. Uma solução que é boa hoje pode já ter sido substituída amanhã, por isso que nós, profissionais de sistemas, devemos estar atualizados a cada minuto. Fazer escolhas apenas por marcas, ou por ignorância de alternativas, são motivos para ineficiência e obsolescência.

Abram os olhos.

