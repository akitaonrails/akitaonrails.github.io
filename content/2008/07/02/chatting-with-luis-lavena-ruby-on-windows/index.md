---
title: Conversando com Luis Lavena (Ruby no Windows)
date: '2008-07-02T14:16:00-03:00'
slug: conversando-com-luis-lavena-ruby-on-windows
translationKey: chatting-luis-lavena
tags:
- interview
- traduzido
aliases:
- /2008/07/02/chatting-with-luis-lavena-ruby-on-windows/
draft: false
---

Desta vez entrevistei [**Luis Lavena**](http://blog.mmediasys.com/). Se você é um desenvolvedor Ruby trabalhando no Windows, deve muito a ele! Afinal, ele é o mantenedor do [One-Click Ruby Installer](http://github.com/luislavena/rubyinstaller/tree), a principal distribuição de Ruby para Windows. É muito trabalho manter uma distribuição dessas e Luis explica todos os obstáculos necessários para isso. A mensagem principal: precisamos de mais colaboradores! Qualquer um pode reclamar, mas poucos descem do pedestal e colocam a mão na massa.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/7/2/325572435_f1f1382372.jpg)](http://www.flickr.com/photos/diegal/325572435/)


**AkitaOnRails:** Ok. Vamos começar. Primeiramente, obrigado pelo seu tempo. É curioso porque temos como 5 horas de diferença. Você está em Paris agora, mas entendo que é da Argentina. Pode nos contar o que está fazendo atualmente?

**Luis Lavena:** Sim, curioso mesmo. Agora sou Diretor Técnico de uma agência de design e interação com escritórios em NY e Paris. Meu trabalho é fazer a ponte entre o campo de design e o tecnológico, principalmente no desenvolvimento de aplicações web.

Sou da Argentina, moro lá, família e amigos. Agora me mudei por alguns meses para impulsionar alguns desenvolvimentos e dar os primeiros passos na nova organização.

Sou de uma pequena província chamada Tucumán, na área noroeste da Argentina (1200 km de Buenos Aires, para ser exato).

**AkitaOnRails:** Incrível. Você já foi ao Brasil? Tem contato com outros Railers da América Latina?

**Luis Lavena:** Apesar de o Brasil ser tão perto da Argentina, nunca fui lá, o que é uma pena. Tenho vários amigos que moraram lá ao longo dos anos.

Mantenho contato com vários Rubistas e Railers da América Latina, mas principalmente com os da Argentina por causa de vários encontros que tivemos ao longo dos anos em que a lista [RubyArg](http://lista.rubyargentina.com.ar) vem funcionando.

**AkitaOnRails:** Tenho muito interesse em entender como os Railers estão se organizando na Argentina, já que nós, no Brasil, somos uma comunidade em crescimento também. Você vê novos programadores indo direto para Rails ou é o movimento habitual de Java/outros para Rails? As empresas estão adotando, ou Ruby/Rails ainda tem um longo caminho a percorrer por lá também?

**Luis Lavena:** Bem, há um número enorme de desenvolvedores que vieram de Java e dotNET (principalmente Java) e estão experimentando Rails. Também há muitos desenvolvedores que usam Ruby para tarefas administrativas ou até para criar jogos.  
As empresas de desenvolvimento de software ainda precisam adotar Ruby/Rails nos seus negócios. O maior problema é a falta de suporte na forma de empresas como a Sun ou alguns serviços de consultoria para Java — ou mesmo Microsoft.

**AkitaOnRails:** Voltando ao passado, como você começou na programação em geral? Estudou ciência da computação, ou chegou até lá de outra forma? E, finalmente, como você tropeçou no Ruby e no Rails?

**Luis Lavena:** É engraçado. Comecei a programar em 1989, brincando com sprites e GOTOs em BASIC num computador Z80.

Oficialmente não terminei minha graduação em CC, porque trabalho e diversão me distraíram. Conheci o Ruby pela primeira vez em 2001, adorei a sintaxe, gostei da sua verbosidade, mas não estava maduro o suficiente para as minhas necessidades, pelo menos não no Windows.

Embora eu tenha usado Python por muitos anos, internamente usava Ruby para gerenciar várias coisas, desde scripts simples até rake tasks que nos ajudavam a construir nossas ferramentas.

Com Rails foi diferente — começamos a procurar alternativas ao Zope e apostamos no Rails naquela época (versão 0.10 ou 0.12, se a memória não me trai).

Posso dizer que não me arrependo da aposta no Rails naquela época.

**AkitaOnRails:** É muito interessante ver profissionais como você saindo da zona de conforto em direção ao "desconhecido" como Ruby e Rails. A maioria dos programadores é muito defensiva e até agressiva na busca de justificativas para não usar nenhum dos dois. Você se sentiu assim na época? O que te levou ao Ruby?

**Luis Lavena:** Bem, estou acostumado a mudar de linguagens conforme minhas necessidades.  
Considere que nossa primeira escolha foi a era pré-J2EE ou o dotNET. Analisamos o que nos daria melhores soluções a longo prazo e decidimos evitá-los.

As coisas de Java pareciam — e ainda parecem até hoje — caras para os negócios. A Argentina não é um país onde você vai encontrar clientes com orçamentos enormes para cobrar o custo de usar ferramentas desenhadas para outros mercados.

Bancos e similares podem se dar ao luxo de ter tudo rodando com J2EE, mas isso não funciona quando você tenta ser menor e ágil — baseado principalmente em experiências com o fluxo do mercado na Argentina.

**AkitaOnRails:** É ainda mais desafiador considerando que você decidiu que queria Ruby no Windows, provavelmente não encontrou nada razoável e decidiu atacar o problema você mesmo. Foi assim que aconteceu?

**Luis Lavena:** Fui obrigado a usar Windows por muitos anos, principalmente relacionado ao desenvolvimento de hardware no campo de transmissão de vídeo. Além disso, sou usuário de BSD e Linux, até brinquei alguns anos com Macs e ultimamente com OSX.

Então essa restrição me forçou a construir a maior parte das minhas ferramentas em torno dessa limitação.  
O Ruby me permitiu aproveitar essa limitação sendo expressivo, o que me tornou mais produtivo nessa área.

Ruby não é capaz de lidar com meus requisitos principais para processamento de vídeo, mas ainda alimenta 70% do meu ambiente, junto com software Open Source e Freeware.

Usei Ruby por tanto tempo que pensei que a comunidade, agora que estava crescendo, talvez valorizasse a experiência e a disposição de ajudar nesse cenário específico.

Então, em vez de continuar coçando minha coceira nas sombras, decidi contribuir de volta e ajudar outros que buscam a mesma coisa. Pode dizer que estou tentando equilibrar meu karma.

**AkitaOnRails:** Os americanos provavelmente não entendem isso, mas em países emergentes como o Brasil, as pessoas não têm muita escolha. A maioria não tem instrução suficiente (_cof_ inglês _cof_) e encontra muitas barreiras. O último recurso para todo mundo é o Windows. Acho que é a mesma coisa na Argentina. Os Railers aqui não simplesmente migram para Macs ou Linux — diria que pelo menos 90% de todos os desenvolvedores estão presos ao Windows por um motivo ou outro. É a mesma coisa na Argentina, imagino?

**Luis Lavena:** Mesmo que eu não goste, tenho que concordar. Felizmente as universidades começaram a mudar isso alguns anos atrás, dando palestras e sendo mais abertas à comunidade Linux, que cresceu muito.

Ainda assim, há muitos usuários e desenvolvedores presos em ambientes corporativos/médios ou que precisam rodar Windows por algum hardware proprietário ou similar.

Então, nós (como comunidade) não conseguimos chegar a esses desenvolvedores sem sermos mais abertos ou fornecer ferramentas que facilitem o caminho entre o ambiente atual deles e ferramentas alternativas.

**AkitaOnRails:** Mas por algum motivo parece haver quase zero interesse da comunidade em suportar Ruby no Windows. Quer dizer, existem pessoas como você, alguns desenvolvedores de RubyGems que se dão ao trabalho de disponibilizar binários para win32, mas parece não ser suficiente. Como o [One-Click Ruby Installer](http://rubyforge.org/projects/rubyinstaller/) começou? Você o criou ou herdou?

**Luis Lavena:** Sim, concordo, mas não posso culpá-los — afinal, cada um coça sua própria coceira. ;-)

Herdei o One-Click Installer do [Curt Hibbs](http://curthibbs.wordpress.com/), que também herdou do [Andy Hunt](http://en.wikipedia.org/wiki/Andy_Hunt_(author)) e outros contribuidores.

A verdade é que por muitos anos usei minha própria versão do Ruby, compilada internamente, então tínhamos controle sobre ela. Não a modificávamos de forma alguma — gostamos de ter todo o processo documentado e automatizado, para poder identificar os componentes específicos atualizados que introduziram conflitos.

O One-Click Installer, por outro lado, depende de builds feitos pelos atuais desenvolvedores e mantenedores do ruby-core, o que torna o processo de encontrar as dependências corretas um pouco difícil. Esse build também impôs outros problemas, mas isso exigiria mais tempo para explicar.

**AkitaOnRails:** Haha, quero mergulhar nas partes mais técnicas para que as pessoas possam entender melhor a situação atual no Windows. Quão diferente é o Ruby no Windows comparado ao Ruby no Linux? A coisa mais óbvia é que qualquer Gem com Extensões C sem binários adequados para Windows vai falhar. Tentar executar comandos shell vai falhar e o [RubyInline](http://www.zenspider.com/ZSS/Products/RubyInline/) também. O que mais?

**Luis Lavena:** Hehe, isso é só a ponta do iceberg. Deixe-me mostrar um exemplo. Suponha que você tem um pacote ABC construído para sua distribuição atual de Linux. Essa versão específica de Linux está vinculada a um runtime comum que cuida de comandos básicos como manipulação de arquivos, console, etc. Isso é geralmente chamado de CRT (C Runtime) e no Linux é a glibc.

Então sua distribuição de Linux está vinculada a esta versão glibc A.B.C. Se sua distribuição atualiza a versão da glibc (por exemplo de 2.2 para 2.5), você é forçado a:

1. atualizar todos os seus pacotes instalados, ou
2. recompilar tudo do zero.

Já ouvi de algumas dessas atualizações dando tão errado que os usuários são forçados a começar do zero. O Windows, por outro lado, não pode quebrar 2 bilhões de aplicações por causa de uma mudança de CRT, então mantém versões antigas e preserva a compatibilidade no arquivo MSVCRT.dll (onde a versão base é 6.0).

Uma vantagem do Windows é que você pode ter vários CRTs coexistindo no seu sistema operacional. A parte ruim é que você não pode vincular com segurança a um CRT e usar componentes que se vinculam a outra versão sem se preocupar com segfaults e afins.

Tentei condensar essas informações [num post](http://blog.mmediasys.com/2008/01/17/ruby-for-windows-part-1/) algum tempo atrás. Como você pode ver, a falta de ferramentas de desenvolvimento não é o pior problema no desenvolvimento Windows.

**AkitaOnRails:** Interessante. E outra coisa é o compilador Visual Studio vs [MinGW](http://www.mingw.org/). Você pode nos dar uma ideia de por que escolheu o MinGW? É só porque o VS é comercial e os desenvolvedores teriam que pagar?

**Luis Lavena:** O Visual Studio é ótimo, mas só quando você pode pagá-lo. As versões gratuitas carecem de algumas coisas muito úteis, como a Profile-Guided Optimization (PGO) que está sendo usada para construir binários Windows do Python, por exemplo.

O problema com o VS, mesmo as versões gratuitas, é que você não tem permissão de distribuí-las. Acho que é até ilegal vincular à URL/página de download. Então, mesmo para o nosso projeto de sandbox automatizado, o Visual Studio precisaria ser baixado, instalado e configurado manualmente.

Felizmente nas últimas versões você não precisa instalar o Platform SDK, que era 1GB. As versões do VS se vinculam apenas à versão mais recente do MSVCRT, o que nos força a relinkar cada biblioteca da qual o Ruby depende (e o código fonte do Ruby depende de muitos externos).

Além disso, o Ruby não usa a versão safe do CRT para funções de cópia de strings, então você precisa de flags de compilador só para evitar isso... Então depois de semanas de muito trabalho para compilar com VC8 e todas as dependências, você acaba com algo que tem performance quase igual, já que não há ganho de performance — mas agora você tem menos cabelos.

O MinGW, por outro lado, era mais próximo de um ambiente Linux, então a maioria das ferramentas funcionava imediatamente. A parte boa é que não precisávamos compilar todas as dependências com ele, já que por padrão tudo se vincula ao MSVCRT (o CRT padrão no Windows). O MinGW também fornece algumas ferramentas de cross-compilação que permitem construir, usando o ambiente Linux, bibliotecas compartilhadas (dll) e executáveis para Windows.  
Considero isso uma vantagem, não sei o que os outros pensam.

**AkitaOnRails:** Uau, isso é realmente avassalador e recomendo a qualquer pessoa interessada nos detalhes que dê uma olhada no seu [blog](http://blog.mmediasys.com/). Mas tudo isso dito, agora você tem tudo no lugar, um processo adequado e tal, presumo. Se eu sou um desenvolvedor C Windows e quero contribuir, onde devo ir primeiro para saber quais ferramentas usar, como compilar as coisas, etc.?

**Luis Lavena:** Essa é a parte boa! [Gordon Thiesfeld](http://blog.robustlunchbox.com/) e eu temos trabalhado em dois pacotes para o novo One-Click Installer: Runtime e Developer Kit.

O Runtime vem com o mínimo de Ruby+RubyGems para você começar e também pode ser usado como módulo para outras instalações. O DevKit fornece o ambiente MinGW para você criar extensões Ruby ou mesmo instalar aquelas que não são pré-compiladas para Windows mas são fáceis de obter.

Este DevKit não vai apenas facilitar o trabalho com Ruby no Windows (e dar acesso a algumas ótimas Rubygems), mas também permitir que você contribua de volta para o projeto Ruby. Como? Fácil — o projeto Ruby Installer (no [Github](http://github.com/luislavena/rubyinstaller/tree/master)) é auto-hospedado. O que isso significa? É possível replicar nosso ambiente de desenvolvimento em qualquer lugar, hackear suas mudanças ou até debugar o próprio código C do Ruby e contribuir de volta para a comunidade. Temos feito isso por vários meses e está funcionando. Que legal, né?

**AkitaOnRails:** Parece incrível. Não sabia disso e aposto que muitos desenvolvedores também não. Espero que os desenvolvedores C que leram isso possam se atualizar agora. Outro detalhe: RubyGems. Quão difícil é portar uma Gem com Extensões C para fornecer um binário Windows quando você a instala?

**Luis Lavena:** Oh, isso requer que alguns desenvolvedores não caiam em truques específicos de plataforma para fazer suas ferramentas funcionarem. Um exemplo, que também é uma má prática, é usar caminhos hard-coded...

Outro é depender da existência de algumas ferramentas externas que às vezes não estão disponíveis ou os desenvolvedores/usuários não instalaram. E não estou falando de problemas de plataforma Linux-Windows — mesmo entre distribuições Linux isso é um problema.

<object width="506" height="382">	<param name="allowfullscreen" value="true">	<param name="allowscriptaccess" value="always">	<param name="movie" value="http://www.vimeo.com/moogaloop.swf?clip_id=1266418&server=www.vimeo.com&show_title=1&show_byline=1&show_portrait=0&color=&fullscreen=1">	<embed src="http://www.vimeo.com/moogaloop.swf?clip_id=1266418&server=www.vimeo.com&show_title=1&show_byline=1&show_portrait=0&color=&fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="506" height="382"></embed></object>  
[Instalando Gems no RubyInstaller](http://www.vimeo.com/1266418?pg=embed&sec=1266418) de [Luis Lavena](http://www.vimeo.com/luislavena?pg=embed&sec=1266418) no [Vimeo](http://vimeo.com?pg=embed&sec=1266418).

**AkitaOnRails:** Então depende bastante da qualidade da Gem original, certo? Quanto mais limpo o código, mais fácil de portar, claro. Mas seu DevKit fornece alguns atalhos para isso? E quanto ao RubyInline, ele simplesmente quebra?

**Luis Lavena:** Sim, aprendi ao longo dos anos que você não deve supor nada sobre o ambiente em que sua aplicação vai rodar — assim você evita esses erros.

Felizmente o RubyInline funciona bem com o Ruby Installer (One-Click Installer que usa MinGW) há algumas versões atrás — graças ao Ryan Davis por incluir esses patches.

O build atual em VC6 do One-Click Installer não é seguro, pois você precisa do VS6 para funcionar, que não está mais disponível. Já ouvi de usuários aproveitando Sequel, Ambition e ImageScience no Windows graças a esses patches.

**AkitaOnRails:** Me corrija se estiver errado, mas não é uma forma de incorporar snippets de código C misturado com código Ruby? Isso significa que ele compila nativamente esse snippet para executar? Como consegue isso num ambiente Windows que não tem compiladores por padrão?

**Luis Lavena:** Conseguimos incluir alguns patches no Hoe e no RubyInline que "empacotam" as extensões pré-compiladas dentro das gems, então os usuários não precisam de um compilador nesses casos.

De qualquer forma, agora usar o build VC6 do Ruby exige mão de obra para manter essas gems e acompanhar os novos lançamentos, o que leva tempo. Até agora era só eu na jogada (já que temos algumas licenças VC6). Construir tudo para todo mundo é um fardo que estou ansioso para transferir para o DevKit.

**AkitaOnRails:** São vocês que mantêm as versões Windows das Gems ou cada desenvolvedor cuida do seu próprio projeto? Há um repositório central para Gems prontas para Windows? O DevKit já está disponível, aliás?

**Luis Lavena:** Para alguns projetos sou o único que mantém gems para Windows; para outros apenas contribuí com patches e outros usuários gerenciam os builds. Não há repositório central para gems Windows porque quero que o RubyForge seja o central.  
De qualquer forma, estou publicando as específicas do MinGW baseadas em forks do github aqui:

<macro:code>
<p>gem list <del>-remote —source http://gems.rubyinstaller.org<br>
-</del>-</p>
<p>O devkit já está disponível, mas estamos embrulhando-o num bom pacote de instalação Windows. Você pode sujar as mãos e pegar o projeto sandbox do <a href="http://github.com/luislavena/rubyinstaller">Github</a> para ter seu ambiente, ou simplesmente <a href="http://www.rubyinstaller.org/sandbox/">baixar os pacotes</a>.</p>
<p><strong>AkitaOnRails:</strong> Então, no que diz respeito a ferramentas e processos, você está fazendo um ótimo trabalho. Mas então há o código Ruby que, por si só, é um grande desafio pelo que ouço. Você me mencionou que nem parece C. Quais são os maiores problemas? Técnicos ou conseguir ajuda da lista ruby-core, ou ambos? E quanto aos test suites, como você está eliminando bugs de compatibilidade?</p>
<p><strong>Luis Lavena:</strong> Para ser honesto, às vezes olhar para o código C do Ruby me dá dor de cabeça. Há muitas macros, definições e condições de macro que aparecem no meio de um bloco if..else... A parte mais difícil, além de rastrear o bug, é obter feedback do ruby-core. Várias vezes <a href="http://blog.mmediasys.com/2008/03/06/is-windows-a-supported-platform-for-ruby-i-guess-not/">expressei</a> minhas preocupações em listas de e-mail, IRC e no meu blog.</p>
<p>Várias vezes perguntei se era OK ter alguns erros nos unit tests do próprio Ruby e às vezes obtive respostas, mas às vezes não. Felizmente não precisamos mais basear nossa qualidade de testes nos unit tests incluídos no Ruby. Começamos a encontrar problemas com a implementação do Ruby no Windows usando as Ruby Specs criadas pelo pessoal do projeto Rubinius e que a maioria das implementações (IronRuby e jRuby) contribui ativamente e usa como base de seus interpretadores.</p>
<p><strong>AkitaOnRails:</strong> Falando nisso, <a href="http://blog.emptyway.com/2008/04/06/the-rubyspecs-quick-starting-guide/">RubySpecs</a> — quão longe está o Ruby no Windows de passar por elas? Ou já passa?</p>
<p><strong>Luis Lavena:</strong> Bem, é uma tarefa grande. Primeiro começamos fazendo o MSpec funcionar corretamente no Windows, já que o RubySpec requer alguma auditoria para remover caminhos hard-coded. Então começamos a adicionar guards em torno de coisas que não são suportadas ou não funcionam no Windows no <span class="caps">MRI</span>.</p>
<p>Isso leva mais tempo já que precisamos revisar os resultados em cada plataforma, mergulhar na documentação do Ruby (que às vezes é insuficiente) ou respirar fundo e olhar para o código C para descobrir o que está fazendo.</p>
<p>Se tivéssemos <strong>mais mão de obra</strong>, talvez conseguíssemos terminar de proteger todo o código e ter specs rodando limpas no Windows. Agora há muitas que simplesmente falham ou causam segfault.</p>
<p><strong>AkitaOnRails:</strong> Você deveria documentar esse processo para que as pessoas possam ajudar, se ainda não o fez :-) Agora falando de coisas mais práticas: Ruby no Windows, hoje, é um runtime viável para rodar apps Rails no Windows? Mesmo apps em produção? Você trabalhou com Zed Shaw no Mongrel para Windows, certo? Experimentou o mais recente suporte FastCGI da Microsoft para <span class="caps">IIS</span>?</p>
<p><strong>Luis Lavena:</strong> Hehee, documentação, documentação — é totalmente superestimada. Planejamos ter vários screencasts no site do RubyInstaller, mas continua como <em>'em breve'</em> por enquanto.</p>
<p>Não só você pode desenvolver aplicações Rails no Windows (como eu também faço), mas conheço várias empresas que rodam lado a lado com <span class="caps">IIS</span> ou mesmo Tomcat.</p>
<p>Mesmo 2 anos após o Zed tê-lo criado, o Mongrel ainda domina o cenário de servidores web Ruby. Não fiz muito ao próprio Mongrel, já que o Zed criou algo que funcionava no Windows com pequenos ajustes.</p>
<p>Criei algo para rodar o Mongrel como serviço (mongrel_service), o que ajudou várias pessoas a introduzir Ruby e Rails em seus ambientes corporativos, inclusive conversando com servidores <span class="caps">MSSQL</span>.</p>
<p>Pessoalmente não testei o <a href="http://mvolo.com/blogs/serverside/archive/2007/02/18/10-steps-to-get-Ruby-on-Rails-running-on-Windows-with-IIS-FastCGI.aspx">suporte a <span class="caps">FCGI</span> no <span class="caps">IIS</span></a>, mas fui eu quem o corrigiu para ser incluído no One-Click Installer para que alguns usuários pudessem aproveitá-lo. Podemos dizer que funciona.</p>
<p><strong>AkitaOnRails:</strong> Sobre performance, o Windows parece ter uma condição inerente: na mesma máquina quando inicio, digamos, um simples <span class="caps">IRB</span> no Windows, depois dou dual boot para Linux e rodo, parece abrir muito mais rápido (não é exatamente um experimento científico :-). Qual é sua experiência com a performance do Ruby no Windows?</p>
<p><strong>Luis Lavena:</strong> Há problemas de performance relacionados ao código C gerado pelo compilador e problemas relacionados ao SO e I/O gerenciados por ele. Carregar o <span class="caps">IRB</span> no Windows pode estar exigindo RubyGems em segundo plano, que por sua vez precisa varrer e carregar todas as especificações de gems. Tento manter <code>RUBYOPT=rubygems</code> fora das minhas variáveis de ambiente.</p>
<p><strong>AkitaOnRails:</strong> Aliás, por que tenho a impressão de que vejo <span class="caps">RUBYOPT</span>=rubygems sendo recomendado em todo tutorial Windows que vejo?</p>
<p><strong>Luis Lavena:</strong> <code>RUBYOPT=rubygems</code> é a parte da mágica que devemos evitar.<br>
No Linux, se você começa a criar um script e precisa de uma gem, começa com:</p>
<hr>
ruby
<p>require 'rubygems'<br>
require 'some_gem'<br>
<del>-</del></p>
<p>O mesmo deveria ser feito para Windows. Não é doloroso, é boa prática. <span class="caps">RUBYOPT</span> é um atalho que não gosto — nunca vi uma distribuição Linux que ative isso por padrão e não gosto que seja configurado no Windows (é claro, esse é meu ponto de vista pessoal).</p>
<p>Então, para evitar cair em procedimentos de teste padrão, continuo usando um solver de sudoku simples mas bom que exercita recursão, arrays e condições da VM em vez de ser I/O bound.</p>
<p>Você pode ver isso, com resultados interessantes no <a href="http://blog.mmediasys.com/2008/04/24/contributions-speedup-and-less-quirks-for-us/">meu blog</a> (veja a seção <em>"Rubinius, RubySpecs, and speed."</em> do post).</p>
<p>O principal é que o VC6 torna tudo lento. Depois você tem as coisas I/O bound (I/O no Windows não é tão bom quanto no Linux). Considero o build padrão VC6 do Ruby no Windows dolorosamente lento. Por outro lado, o do MinGW é mais ágil, mas ainda acho que há um longo caminho a percorrer para melhorias.</p>
<p><strong>AkitaOnRails:</strong> Então, no geral, Ruby no Windows está sempre evoluindo — o que é ótimo —, roda bem no Windows — o que é notável —, mas poderia usar um pouco mais de ajuda, certo? Você acha que mais desenvolvedores C Windows ajudariam? Ou seja, adicionar mais mãos ajudaria a melhorar a qualidade?</p>
<p><strong>Luis Lavena:</strong> Definitivamente!</p>
<p><strong>AkitaOnRails:</strong> Que tipo de desenvolvedores — o que uma pessoa deveria saber para ajudar?</p>
<p><strong>Luis Lavena:</strong> Não sei se o "core" do Ruby vai aceitar isso — ultimamente só ouço a palavra fork em torno do Ruby <span class="caps">MRI</span>. Além disso, podemos corrigir bugs na implementação Ruby para Windows, mas não podemos melhorar muito a qualidade já que essas mudanças afetariam outras plataformas também.</p>
<p>A parte ruim é que não há separação clara por plataforma de código específico — tudo é uma série de macros e condições de compilação que dificultam o rastreamento (para desenvolvedores não-masoquistas).</p>
<p><strong>AkitaOnRails:</strong> O que me lembra o pessoal da Phusion com a sua <a href="http://www.rubyenterpriseedition.com/">Enterprise Edition</a>, que é um fork do <span class="caps">MRI</span>. Você tentou analisar os patches de GC copy-on-write deles? Talvez incluí-los na versão Windows? O Ruby no Windows em si é um "fork". Você acaba tendo que sincronizar seu trunk com o deles — é assim que funciona?</p>
<p><strong>Luis Lavena:</strong> Honestamente não tive tempo de analisar a Enterprise Edition, mesmo tendo acompanhado todos os posts e a discussão desses patches no ruby-core. O engraçado é que os últimos lançamentos da branch Ruby 1.8.6 estão me dando dores de cabeça (mais do que olhar para o código C). Eles não conseguem nem completar os self-tests e causam segfault com algumas extensões como a gem mysql.</p>
<p><strong>AkitaOnRails:</strong> Sim, tem gerado muito barulho na comunidade — e com razão. Espero que possam resolver logo. Bem, acho que já tomei muito do seu tempo. Há algum assunto que você gostaria de abordar, ou pelo menos alguma mensagem para a comunidade brasileira mais jovem?</p>
<p><strong>Luis Lavena:</strong> Sim — não tenha medo de fazer perguntas, não se envergonhe de usar Windows como plataforma. Você pode realizar ótimas aplicações usando Windows e pode se infiltrar mais facilmente em ambientes corporativos com ele.</p>
<p><strong>AkitaOnRails:</strong> Ah, o que me lembra de uma última pergunta que todo mundo me faz o tempo todo — e vou repassar para você, já que é um desenvolvedor Windows: quais são suas ferramentas preferidas para editar projetos Ruby/Rails?</p>
<p><strong>Luis Lavena:</strong> Uso principalmente coisas gratuitas ou open source, então tenho usado o <a href="http://www.activestate.com/store/download.aspx?prdGUID=20f4ed15-6684-4118-a78b-d37ff4058c5f">Komodo Edit</a> (não Pro) e o <a href="http://www.pnotepad.org/">Programmer Notepad</a>, já que às vezes os uso para trabalhar com código C, FreeBASIC e Assembler para hardware embarcado.</p>
<p>Ultimamente tenho usado um editor leve chamado <a href="http://intype.info/home/index.php">Intype</a> que vem com alguns bundles para imitar o TextMate, mas realmente não aproveito muito. Usei NetBeans por um tempo, mas depois de 500MB simplesmente fechei :-)</p>
<p><strong>AkitaOnRails:</strong> Haha, e o que você recomendaria para um programador Rails iniciante?</p>
<p><strong>Luis Lavena:</strong> Para começar, o NetBeans é bom, mas com a prática aprenderão que até o notepad é suficiente para programar.</p>
<p>(PS: Já estamos incluindo os patches da Enterprise para os últimos problemas no build MinGW! :-)</p>
<p><strong>AkitaOnRails:</strong> Haha, certo. Bem, acho que é isso. Espero que isso alcance um público mais amplo e chame atenção dos desenvolvedores Windows por aí. Muito obrigado!</p>
<p><strong>Luis Lavena:</strong> Obrigado a você, Fabio.</p>
<p style="text-align: center; margin: 5px"><a href="http://www.flickr.com/photos/diegal/325555121/"><img src="http://s3.amazonaws.com/akitaonrails/assets/2008/7/2/325555121_e6e22ea444.jpg" alt=""></a></p></macro:code>
