---
title: Evolução pela Concorrência
date: '2006-09-27T16:13:00-03:00'
slug: evolução-pela-concorrência
translationKey: evolução-pela-concorrência
description: "O autor defende que críticas e concorrência fazem tecnologias evoluírem. Em Rails, limitações como internacionalização, legado e tarefas assíncronas já estimularam soluções da comunidade."
tags:
- rails
- engenharia-de-software
- economia
- off-topic
draft: false
---

 ![](/files/402px-AdamSmith.jpg)

Não lembro se escrevi sobre isso em algum post ou se foi no meu livro, mas existe um senso comum que chamo de **"Evolução pela Concorrência"**. Discussões como _"Ruby VS Java"_ ou _"Rails VS J2EE"_ não são exclusividade da comunidade Ruby on Rails. Vejam outras brigas recentes do mundo da informática:

- Firefox VS Internet Explorer
- Macs VS PCs
- Windows VS Linux
- C# VS Java

A Microsoft é a favorita para o papel de vilã. Ela atua em praticamente todos os mercados de informática, então sempre será alvo de críticas: _"Windows é ruim"_, _"Office é uma droga"_, _"Internet Explorer não presta"_, _"Visual Basic não é linguagem profissional"_. Alguns argumentos são válidos, outros são birra de visão estreita.

Crítica é construtiva quando a pessoa toma uma atitude. Radicais são desnecessários neste mundo. Quem só xinga e não age é irrelevante, como diz o ditado: **_"quem não faz parte da solução, faz parte do problema"_**.

Parabéns a todos que transformaram a insatisfação com o status quo em alternativas de altíssima qualidade aos criticados produtos Microsoft. Nenhuma é perfeita, mas a dedicação merece reconhecimento. Hoje só uso Firefox (ou o [Camino](http://www.caminobrowser.org/) no Mac, que usa a mesma engine Gecko).

O Linux, graças ao apoio tecnológico de gigantes como IBM e Silicon Graphics, ganhou filesystems avançados como o JFS e o XFS, suporte a [NUMA](http://lse.sourceforge.net/numa), clusters, gerenciamento mais avançado de [threads](http://web.archive.org/web/20180415043221/http://www.onlamp.com/pub/a/onlamp/2002/11/07/linux_threads.html), virtualização como o [Xen](http://web.archive.org/web/20111019173305/http://kerneltrap.org/node/4168) e muito mais. Virou uma alternativa confiável para grandes servidores.

A Apple também deixou de ser uma empresa irredutível. Soube assumir seus erros e fazer transições cada vez mais eficientes: dos processadores Motorola para o PowerPC da IBM, do obsoleto MacOS 9 para o MacOS X, baseado em núcleo Unix, e agora do PowerPC para os Intel Core Duo e Core 2 Duo. Mudar para evoluir.

A Microsoft, por sua vez, não está quieta. Vendo os concorrentes se levantarem, criou um sistema para eliminar boa parte das críticas: o Windows Vista. Apesar dos tropeços e atrasos, promete ser um sistema robusto e moderno. Melhor que o Linux? Melhor que o MacOS X? Quem sabe. Mas a evolução está acontecendo. O mesmo vale para a plataforma de desenvolvimento: sob a ameaça do Java, criou o .NET. Ambos têm vantagens e desvantagens, mas o .NET tem funcionalidades fantásticas que não podem ser ignoradas.

Esse fenômeno vai muito além do mundo de TI: é uma característica inerente do [capitalismo](http://en.wikipedia.org/wiki/Capitalism). A inteligência do sistema de concorrência é essa: ela leva inevitavelmente à evolução. As empresas de hoje são melhores que as de dez ou vinte anos atrás. É o exato motivo pelo qual monopólios precisam ser erradicados.

É o caso do nosso mercado de telecomunicações. Na época do ineficiente monopólio estatal da Telebrás, conseguir uma linha telefônica levava meses e custava obscenamente caro. Hoje, com concorrentes como Telefonica e Embratel, uma linha sai praticamente de um dia para o outro por um preço razoável. O serviço está longe da perfeição (vide Procon), mas é inegável que as coisas só começaram a melhorar depois da privatização.

E o que isso tudo tem a ver com Rails? Um corolário desse raciocínio: tecnologias pouco discutidas e pouco criticadas tendem a estagnar ou pior, a ser esquecidas. É o mesmo efeito dos monopólios. Uma empresa que fica tempo demais sem concorrente se acomoda, piora, desestabiliza, até surgir alguém para desbancá-la. Por isso, num mercado saudável, concorrência é imperativo.

Olhem casos como o [BeOS](http://en.wikipedia.org/wiki/BeOS), ou linguagens como [Nemerle](http://web.archive.org/web/20130529032811/http://nemerle.org/Main_Page) e [Scheme](http://www-swiss.ai.mit.edu/projects/scheme/). Todas mantêm pequenos nichos, mas foram esquecidas pelo mercado como um todo. Isso não significa que fossem ruins; por circunstâncias diversas, não foram criticadas nem sabatinadas o suficiente.

Expliquei tudo isso para chegar ao ponto: Ruby e Rails estão sob crítica constante, observados com minúcia, escrutinados sem cerimônia. E isso é excelente. Todas as engrenagens da evolução estão em movimento. Graças a essa atenção toda, pessoas inteligentes da comunidade se levantaram para preencher as lacunas, levando o RoR rápido a níveis que ele não alcançaria sozinho. Vejamos exemplos:

##### RoR não suporta Internacionalização

Para alguns, é uma falta grave, agravada pelo fato de a própria linguagem Ruby não ser muito amigável a Unicode. Lembrem que Ruby nasceu no Japão, para os japoneses, no começo dos anos 90. Detalhei o assunto no livro; resumindo, hoje temos soluções como o [Globalize](http://web.archive.org/web/20120209000503/http://wiki.rubyonrails.org/rails/pages/Internationalization).

##### RoR não tem o equivalente a EJBs

De fato, apesar de extremamente burocráticos, os containers EJB atuais são bastante robustos. O RoR equivale a apenas o container de servlets de um sistema J2EE completo. Mas graças a **Ezra Zygmuntowicz** agora temos o [BackgrounDRb](http://www.infoq.com/articles/BackgrounDRb). Ele funciona mais ou menos como um Message Bean para executar tarefas assíncronas. Não é necessariamente melhor, mas é uma solução.

##### RoR não passa de um gerador de templates

É a velha conversa sobre scaffolds. Muitos novatos e críticos mal informados acreditam que Rails é só o método scaffold. Estão redondamente errados, embora seja um conceito incrível, difícil ou impossível de reproduzir em linguagens estáticas. O scaffold padrão do Rails é simples demais: falta, por exemplo, interpretar os relacionamentos entre as tabelas. Surgiram várias alternativas, e as mais interessantes são Streamlined e AjaxScaffold, como já [mencionei](http://web.archive.org/web/20240223172630/https://www.akitaonrails.com/2006/09/27/snakes-vs-rubies-scaffold-on-steroids) alguns posts antes.

##### RoR privilegia apenas projetos Green Field

_"Green Field"_ é o que chamamos de projeto começado do zero, sem legado, onde podemos escolher a implementação e seguir as convenções do Rails desde o início. O problema é implementar um módulo Rails em cima de um banco de dados que já existe, totalmente fora das convenções. Nesse caso, dá trabalho. Para facilitar, Robby Russell está escrevendo o plugin [Acts as Legacy](http://www.robbyonrails.com/articles/2006/04/14/sneaking-rails-through-the-legacy-system), uma extensão do Active Record que promete tornar as coisas mais fáceis.

##### RoR utiliza scriptlets: código misturado com HTML, isso é terrível

Discussão sem fim. A engine de views do Rails, Erb, de fato usa o equivalente aos scriptlets de JSP ou PHP, com código Ruby puro misturado ao HTML. No caso do Rails, é uma grande funcionalidade. Mas há quem prefira algo parecido com taglibs: um HTML livre de programação, principalmente quando entram Web Designers no projeto. Uma ótima alternativa é o [Liquid](https://shopify.github.io/liquid/), com funcionalidades semelhantes ao Velocity do mundo Java. Assim dá para atender gregos e troianos.

##### RoR sozinho é muito cru. Python, por exemplo, tem Zope/Plone

Rails é um framework. Alguns querem estender a briga dizendo que Rails perde para o Zope. Para quem não conhece, Zope é um excelente servidor de aplicações com CMS, escrito em Python. Claro, comparar CMS com framework é comparar maçãs com laranjas. Mesmo assim, já existem soluções inteligentes escritas em Rails. Em CMS (conteúdo, blogs) temos o famoso [Typo](http://typosphere.org/) e o [Mephisto](http://mephistoblog.com/). Em eCommerce, o [Shopify](http://shopify.com/).

##### RoR usa bons Design Patterns mas não implementa conceitos novos como Rules Engine

Uma Rules Engine, ou Business Rules Engine, gerencia regras de negócio. É um conceito que ganhou força recentemente e ainda está amadurecendo, então cada fornecedor o implementa de um jeito. No mundo Java, um dos mais famosos é o JBoss Rules (Drools). No mundo Ruby já existe uma alternativa chamada [Rools](http://web.archive.org/web/20170203232526/http://rools.rubyforge.org/).

##### RoR não tem tantas bibliotecas quanto Java

Verdade. Apesar de a linguagem Ruby já ter mais de 10 anos e de o Rails ganhar plugins novos o tempo todo, é inegável que Java tem um acervo enorme de bibliotecas, perdendo talvez só para C/C++. Um fato novo pode mudar isso: a **[Sun acaba de contratar os criadores do JRuby](https://rubyonrails.org/2006/9/7/sun-hires-the-jruby-team)**, uma maneira de rodar código Ruby direto na JVM, o que abre caminho para o Ruby acessar todas as bibliotecas do Java. Se a Sun fizer a lição de casa, em pouco tempo teremos um Ruby na JVM com alta performance, robustez, suporte a internacionalização e acesso a uma infinidade de bibliotecas.

##### Finalmente, por que Rails foi feito em Ruby? Não poderia existir um "Jails"?

Muita gente questiona o fato de Rails ser escrito em Ruby. À primeira vista parece birra do programador contra Java. Estudando as linguagens mais famosas, fica claro que Rails só é Rails se for em Ruby. A prova está nos frameworks recentes (a maioria ainda inacabada) que copiam os mesmos conceitos em outras linguagens: [Grails](https://grails.org/) em Groovy/Java, [CakePHP](http://www.cakephp.org/) em PHP, [Castle](http://web.archive.org/web/20061024010829/http://www.castleproject.org/index.php/Main_Page) em .NET. Leiam as documentações, experimentem os códigos. Todos tentam, mas nenhum tem a mesma "sensação" do Ruby on Rails.

E isso faz parte do jogo. Essas alternativas precisam existir por dois motivos. Primeiro, porque frameworks concorrentes obrigam a comunidade Rails a inovar e evoluir mais rápido, sem se acomodar. Segundo, porque ajudam a justificar a escolha do Ruby para criar o Rails.

A mensagem é simples: não se incomodem com as críticas. Aceitem, entendam e evoluam. No mundo real não existe o lema fantasioso do Highlander, _"só pode haver um"_. Tecnologia que reina sozinha deve temer: não há mais para onde subir, só para cair. A evolução funciona em ciclos, como tudo na vida: nasce, cresce e morre.

Como consultor, minha função é escolher os _"best of breed"_, os melhores de cada setor naquele momento. Uma solução boa hoje pode estar substituída amanhã, então nós, profissionais de sistemas, precisamos estar atualizados a cada minuto. Escolher por marca, ou por ignorar as alternativas, é receita de ineficiência e obsolescência.

Abram os olhos.
