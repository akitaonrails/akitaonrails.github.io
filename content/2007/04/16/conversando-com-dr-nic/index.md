---
title: Conversando com Dr. Nic
date: '2007-04-16T15:48:00-03:00'
slug: conversando-com-dr-nic
tags:
- interview
draft: false
---

**English readers, click [here](/2007/4/16/chatting-with-dr-nic)**

 ![](/files/130749539_89959dd059.jpg)

Hoje, Carlos Eduardo, da [e-Genial](http://www.egenial.com.br), me propôs uma entrevista com o próprio Dr. Nic Williams. O homem do momento. Eu aceitei imediatamente e começamos um chat via Skype por mais de uma hora. Ele é um cara legal e tão educado e bem informado como eu esperava.

Então, sem mais delongas, aqui vai:


#### Quem é Dr. Nic?

**AkitaOnRails** : Então, vamos começar dizendo a nossos leitores, quem é Dr. Nic – eu sei, muito genérico, mas vamos começar daqui :-)

**Dr Nic** : Eu como carne, sou casado, tenho um pequeno garoto e escrevo software. Sem nenhuma ordem em especial. Realmente parei de escrever software há um ano ou mais – deixei meu trabalho e fiz outras coisas. Mas tudo que fazia tinha uma solução via software, então me vi escrevendo software para isso. Eventualmente, aprendi a gostar do meu nerd interior. Agora estou feliz :-)

**AkitaOnRails** : Então, vamos a um _combo_ de questões. De onde você é? Qual é seu trabalho atual, é relacionado a Rails? Qual sua história com Rails?

**Dr Nic** : Sou um cidadão Australiano vivendo na Suécia, trabalhando para uma companhia telefônica sueca – Tele2 – no seu projeto de bilhetagem. Não tem nada a ver com Ruby. Dois anos atrás eu estava na Índia e estava procurando por maneiras de escrever código mais depressa. Tenho várias idéias e estava me tomando muito esforço escrever em .NET. Eu vi [aquele vídeo](http://www.rubyonrails.org/screencasts) sobre Ruby on Rails e minha reação inicial foi _“Eu odeio aquela sintax cheia de \<% … %\>”_. Então eu ignorei. Tentei fazer trabalho de Ajax com ASP.NET mas era muito feio e trabalhoso na época. Eu re-assisti o vídeo do Rails e ignorei os \<% … %\> feios, e me apaixonei desde então. Isso foi em Setembro de 2005, eu acho.

**AkitaOnRails** : Então, eu acho que você tem algumas considerações sobre os \<% … %\>. Qual sua posição sobre eles hoje, se acostumou ou tentou outra coisa?

**Dr Nic** : Não, eu não me importo com eles nem um pouco. Acho que nunca nem tentei [alternativas ao ERB](http://haml.hamptoncatlin.com/) em Rails. Eu uso Textile/RedCloth para o website do newgem. Foi apenas uma daquelas coisas de reação inicial. Eu vi os \<% … %\> e foi isso que acho que me barrou de aprender Ruby. Oh, eu também lembro de pensar _“Não quero aprender outra linguagem, que desnecessário”_. Estou contente de estar errado. Aprender Ruby foi necessário.

#### As Mágicas de Dr. Nic’s

**AkitaOnRails** : Vejo que gosta da parte ‘mágica’ de Ruby. Como você chegou à solução de [Magic Model](http://magicmodels.rubyforge.org) ? Acho que pareceu até natural, mas qual a história?

**Dr Nic** : Na RailsConf 2006, [Dave Thomas](http://pragdave.pragprog.com/) listou um bocado de coisas que ele via como _“coisas em que podemos trabalhar”_ em Rails. Uma delas foi a falta de Chaves Compostas, outra foi a misteriosa falta de DRY (Don’t Repeat Yourself) nos arquivos de models. Eu nunca havia lançado código à comunidade Ruby antes (nem em outra comunidade), mas algumas semanas depois eu simplesmente tive essas idéias de como resolver os dois problemas – ambos na mesma semana. Não sei o que foi que me possuiu para chamar o Magic Models por esse nome. Mas eu ainda gosto dele. Eu vislumbrei um show de mágicas onde você fazia o arquivo de Model desaparecer parte por parte e ele ainda continuar funcionando. Daí o nome. Ok, então eu sei porque eu chamei dessa forma. :-)

**AkitaOnRails** : De um ponto de vista de marketing acho fantástico. Você poderia chamar de algo enfeitado como ‘Houdini’ mas Magic Models funciona. Tenho a sensação que esse é seu projeto open source Rails mais famoso. Estou certo ou existe algum outro plugin seu que é mais interessante para a comunidade neste momento?

**Dr Nic** : Eu não acho que muitas pessoas de fato … você sabe … usam Magic Models. Lá no fundo você precisa de um arquivo de model como local para colocar outras funcionalidades. Então ele é mais uma apresentação de um conceito. Eu tenho um esquema de banco com 200 tabelas que uso para um trabalho. Eu uso hooks (ganchos) para incluir coisas adicionais nos models gerados. Espero que o [New Gem Generator](:http://newgem.rubyforge.org) se torne popular. Gostaria de ver mais pessoas compartilhando código.

**AkitaOnRails** : Então, o que você pode nos dizer sobre o Gem Generator. O que ele faz? Sobre o que é?

**Dr Nic** : Escrever um gem a partir de script não é simples/óbvio. Então ele cria um scaffolding para um gem, assim como o comando rails cria um scaffolding para uma aplicação Rails. Ele cria uma pasta contendo um Rakefile, pastas lib + test com alguns arquivos iniciais e um framework para gerenciar um website no rubyforge.org. Ele usa o [hoe](http://seattlerb.rubyforge.org/hoe/) + bibliotecas rubyforge porque eles são muito legais. Se as pessoas soubessem quão bom essas duas ferramentas são elas escreveriam mais gems e menos plugins Rails.

**AkitaOnRails** : Parece muito legal. Isso deve facilitar o lançamento de novos Gems. Eu não estou muito a par do processo de RubyGems e do website RubyForge. Você tentou fazer algum tipo de parceria sobre o Gem Generator e o projeto Gem atual? Talvez unificar (merging) os dois juntos para criar um pacote que tem tudo?

**Dr Nic** : Quando eu criei isso da primeira vez houve um pouco de conversa a respeito com o pessoal do RubyGems, mas não acho que seja importante. ‘Newgem’ é uma aplicação de scaffolding de gems; o gem hoe vem com ‘sow’ que cria uma estrutura similar. E eu acho que alguém está criando uma aplicação de scaffolding de gem. Então, quanto mais melhor. Você vê a mesma coisa para Rails. Você tem o scaffolding ‘rails’, mas agora tem aplicações ‘mega-rails’, como o [Hobo](http://hobocentral.net/), que lhe dá muito mais para iniciar na criação de uma aplicação. Eu inicio gems/projetos porque preciso da solução que acho que outras pessoas também iriam querer. Se alguém fizer uma versão melhor, isso é ótimo. Eu posso parar de suportar minha versão :-)

**AkitaOnRails** : Sim, e tem também o Streamlined e AjaxScaffold. Eu esperava ver ambos lançando versões novas logo. Eles [anunciaram um merging colaboração](http://www.height1percent.com/articles/2006/08/17/ajaxscaffold-and-streamlined-developers-to-collaborate) mas eu nunca mais ouvi sobre eles novamente. Você ouviu?

**Dr Nic** : [AjaxScaffold](http://www.akitaonrails.com/2006/12/01/come%C3%A7ando-com-o-plugin-ajax-scaffold) se tornou um plugin e foi renomeado como [ActiveScaffold](http://activescaffold.com/). Ainda está sobre desenvolvimento ativo por [Richard White](http://www.height1percent.com/) + outros. Na realidade, AjaxScaffold foi o primeiro projeto que eu ajudei, antes de escrever o [Composite Primary Keys](http://compositekeys.rubyforge.org/) + [Magic Models](http://magicmodels.rubyforge.org/). Então eu aprendi muito sobre gems e geradores rails do código deles. Eu nunca usei [Streamlined](http://www.streamlinedframework.org/) mas ele ainda está sobre desenvolvimento ativo, pelo menos até onde sei. Não sou muito fã de merging de projetos open source. Normalmente eles são construídos em torno da inspiração de um indivíduo. Esses indivíduos podem não compartilhar bem juntos :-) Além do mais, é um trabalho muito grande juntar dois blocos de código.

#### Open Sourcing

**AkitaOnRails** : Voltando ao que você falou antes: não abandone seu projeto. Brigue por ele! :-) Mas falando sério, desenvolvimento e suporte requerem muito esforço. Principalmente com suporte, conserto de bugs e tudo mais. Você recebe muita ajuda da comunidade, talvez com patches?

**Dr Nic** : Ajuda + patches – isso é que se tornou a melhor coisa sobre open source (OSS) – as pessoas corrigem seu código, ou no mínimo perguntam _“Por que você não fez desse jeito [alternativo]?”_

**AkitaOnRails** : Hm, deixe-me mudar de assunto um pouco. Eu tenho sentimentos mistos sobre merging e forking. Eu normalmente não gosto de forking a menos que a equipe original tenha ficado dormente como aconteceu ao projeto [XFree86](http://pt.wikipedia.org/wiki/Fork). Alternativas deveriam realmente ser diferentes como KDE e Gnome, e eles são ótimos. Mas componentes que fazem muita coisa parecida ou se complementam como a atual discussão sobre [beryl e compiz](http://lwn.net/Articles/229690/), talvez seja bom unirem esforços em uma única direção. O que acha? Por exemplo, acho que o suporte a multi conexões como o seu ou da Revolution Health deveriam estar na árvore principal do Rails. É tão importante quando os adaptadores de bancos de dados. Ou talvez não?

**Dr Nic** : Existe um projecto chamado [DRYSql](http://drysql.rubyforge.org/) que para todos os efeitos e propósitos é similar ao Magic Models. Não é um fork, mas o código deve ser similar. Mas estou feliz que ele tenha feito isso. Acho que OSS é dirigido pela inspiração – e pessoas gostam de ter seus nomes anexados ao código. Se ele escreve mais código porque ele carrega seu nome, então isso está ótimo. Sobre mais vs. menos no Rails – acho que mais código deveria ser extraído para fora do Rails, em vez de mais código adicionado. Infelizmente se você tira coisas, então o movimento anti-rails diz coisas estúpidas como _“Oh Rails não consegue fazer XXX”_ mesmo que tenha um plugin/gem que consiga, ou mesmo se você pudesse fazer isso em 5 a 100 linhas de código. Mas não estamos aqui para fazer os anti-railers felizes, apenas nós mesmos. Então, extraia código do núcleo do Rails e torne-o livre.

**AkitaOnRails** : Sim, como o desejo atual de cortar fora o suporte a Active Web Services (AWS) já que parece que menos pessoas estão usando, e torná-lo um plugin. Isso está correto, quanto mais está no núcleo, mais pesado para carregar o processo.

**Dr Nic** : Deixe as pessoas escolherem prototype/scriptaculous vs. jquery por exemplo. Mas ninguém fará isso – não vale o esforço. E certo – não há mais necessidade para AWS – ele já está empacotado como um gem separado. Você apenas pára de fazer com que ele seja uma dependência no gem do Rails. Então essa foi fácil. Mas minha atitude é que Rails é perfeito dado que ele é muito novo, completamente Open Source e tem uma maravilhosa comunidade de desenvolvedores inteligentes e preocupados que conseguem _“coçar sua própria coceira”_ e então compartilhar os resultados através de blogs + forums.

**AkitaOnRails** : Eu pessoalmente tenho um pouco de preocupação sobre isso porque Rails está se tornando algo como o kernel do Linux. O Linux não tem um conjunto específico de [APIs estáveis](http://www.kroah.com/log/linux/ols_2006_keynote.html), então cada nova versão requer algumas mexidas nos drivers. Isso funciona porque todo o código fonte dos drivers está na árvore principal. Rails é parecido: eu questionei DHH (refiram à entrevista no meu livro) sobre isso e ele não quer se limitar dando APIs estáveis por novas versões. Então plugins estão destinados a quebrar um dia a menos que eles sejam lançados juntos com a distribuição principal. Talvez veremos _‘Distros Rails’_ no futuro?

**Dr Nic** : Rails Fragmentado – sim, é uma preocupação válida. Acho que veremos “distros rails”. Acho que eles já existem. Mas não são chamados dessa forma. [Hobo](http://hobocentral.net/), por exemplo, poderia ser uma distro rails. Então um dia poderíamos ter um HoboConf.

**AkitaOnRails** : Na realidade, acabei de chegar a essa conclusão de _Distros_. Talvez eu devesse montar meu próprio :-) A _Distro Rails Akita_.

**Dr Nic** : Apenas certifique-se de criar screencasts. Isso vende software. Tendo dado essa pérola de sabedoria, não estou certo porque eu não faço isso. Escrever artigos em blog é legal e consome tempo, provavelmente é por isso. Mas vídeos funcionam. O sucesso de Rails será anotado nos livros de história, em parte, ao [vídeo de 15 minutos](http://rubyonrails.org/screencasts).

#### Twitter vs. DHH – Round 2

**AkitaOnRails** : Falando nisso, suporte, plugins, eu tenho que perguntar algo delicado (_não quero que isso se torne desculpa para outro flame-war_): o que você acha sobre a discussão atual de [Twitter vs DHH](http://www.akitaonrails.com/2007/04/15/a-polemica-twitter)? Twitter disse: _Rails deveria nos ter dado a solução_. DHH disse: _Twitter poderia ter contribuído de volta com a solução_. Acho que esse tipo de argumentação não faz nenhum bem à comunidade, como [postei](http://www.akitaonrails.com/2007/04/15/a-polemica-twitter) ontem no meu blog. Qual sua percepção sobre isso?

**Dr Nic** : Os caras do Twitter já contribuíram código à comunidade Ruby ([Jabber API](http://romeda.org/blog/2006/11/announcing-jabbersimple.html)), e quando eles chegarem a uma solução para sua situação, acho que irão gostar de compartilhar conosco. Isso será ótimo. Lembrem-se: Rails tem 2 anos de idade. .NET + ISS tem mais de 7 anos. Java tem 10 anos. LAMP é bem velho. Então, está tudo à nossa frente. São tempos excitantes.

**AkitaOnRails** : E você não conseguiu [sua camiseta](http://www.loudthinking.com/arc/000610.html#comments), ou conseguiu? :-)

**Dr Nic** : Ninguém perguntou meu endereço – uma consulta que precede a parte de enviar camisetas.

**AkitaOnRails** : hahaha, e você recebeu feedback da comunidade sobre o Magic Multi Connection (MMS) e a discussão sobre o Twitter? Aliás, como você chegou à solução de array global de módulos de conexão?

**Dr Nic** : Acho que o aspecto mais importante do MMC é que ele responde à dúvidas se Rails PODE se conectar a múltiplos bancos de dados. É uma coisa ingênua dizer _“Rails não consegue se conectar a múltiplos bancos de dados”_ mas os anti-railers gostam do som disso, eu acho. Mesmo sem o MMC, você pode criar seu próprio pool de conexões, e manualmente assinalar as conexões antes de cada requisição. O MMC esconde isso via módulos. A solução do Revolution Health move a alocação de conexão dentro dos métodos CRUD. Tudo a mesma solução. Apenas níveis diferentes de controle e sintaxe.

**AkitaOnRails** : Mas você tinha pensado nisso antes, ou foi o calor da discussão que o motivou a criar a solução?

**Dr Nic** : Eu havia escrito o gem uma semana antes, coçando minha própria coceira. A idéia de usar módulos para controlar o comportamento de models ActiveRecord me agrada no senso de “mágica”. É bonitinho. Por exemplo, o último Magic Models lhe permite usar Modules para especificar prefixos de nomes de tabela. Então, eu tinha o gem, o problema do Twitter apareceu. Então escrevi o artigo no blog e o tutorial como resultado. Eu ia lançar o gem em alguns dias mas não direcionado ao problema de master-slave. Foi construído com o objetivo de usar para websites administrativas que precisam se conectar com 2 ou mais bancos de dados diferentes. Vou blogar sobre isso depois.

**AkitaOnRails** : Realmente um timing excelente. Agora alguém precisa construir um screencast explicando aos Railers como configurar uma replicação master-slave entre bancos de dados MySQL primeiro :-)

**Dr Nic** : Acho que em primeiro lugar mais Railers estão interessados em como colocar suas aplicações Rails em produção :-) Eles sonham em ter problemas de escalabilidade. _“Oh, minha conta Google Ad-sense está cheia. O que eu devo fazer com todo esse dinheiro.”_

#### Comunidade e Macs!

**AkitaOnRails** : Falando em comunidade, você participou de muitas conferências, eventos? Você esteve na última RailsConf EU? Quais suas opiniões sobre o que está acontecendo em torno da comunidade?

**Dr Nic** : Eu conheci poucas pessoas na Railsconf 2006. Sentei-me na audiência assistindo a todos os bloggers famosos de Rails falando, como todos na audiência. Me senti feliz de estar lá. Eu era uma das 50 pessoas que tinha um laptop PC. Eu fiz uma rápida apresentação sobre RadRails vs. TextMate para algumas risadas. Viajar da Europa para Chicago custa um pouco de dinheiro, então mesmo a RailsConf EU sendo atravessando o canal em Londres, ele foi vetado pelo painel financeiro de Williams. Mas eu estarei no RailsConf novamente em Maio, deve ser maravilhoso. A comunidade de Rubistas é incrível.

**AkitaOnRails** : (_Eu bem que gostaria de estar lá também_) bem, isso significa que sua máquina primária é baseada em Windows. Você ainda está usando RadRails ou tentou os novos competidores como “E” ou mesmo a integração Ruby do NetBeans e IntelliJ?

**Dr Nic** : Ahh, _era_ um PC. Eu comprei um laptop unix, com um logotipo Apple :-) O PC era velho e estava fazendo barulho. Eu não encontrei razão para continuar com o PC vs. as possibilidades com OS X. Não sou um fã Apple, mas amo meu Mac.

**AkitaOnRails** : Deixe-me adivinhar: Macbook Pro 15" Core 2 Duo 2.33?

**Dr Nic** : Macbook 13" – Eu uso no ônibus e trem.

**AkitaOnRails** : Haha, Eu também digo _“Eu não sou um fã Apple”_. Talvez alguém devesse criar uma categoria _“Os Negadores”_ :-)

**Dr Nic** : Eu amo minha mulher, meu filho e meu mac, oficialmente, nessa ordem.

**AkitaOnRails** : Eu gostaria de poder usar o meu no metrô, mas eu seria roubado em menos de 10 segundos. Nenhuma dúvida sobre isso.

**Dr Nic** : Ha. É um grande planeta, você pode se mudar.

#### Conselho de Carreira de Dr. Nic

**AkitaOnRails** : Ótima proposta. Eu penso sobre isso. Aliás, no começo da conversa você nos disse que esteve trabalhando na Índia? Algum tipo de trabalho de consultoria para algumas das maiores como Tata, Wipro, Satyam? Quais suas opiniões sobre as recentes discussões e preocupações como sobre o livro de Chad Fowler, [My Job web to India](http://www.rubyonbr.org/articles/2006/10/18/por-que-aprender-ruby-o-torna-um-programador-pior-por-akita/)?

**Dr Nic** : Eu fui à Índia para o mesmo projeto que estou agora para a companhia sueca. Naquela época foi para a Accenture, que estava fazendo o trabalho ao mesmo tempo na Índia. Eu tenho uma cópia de e-book do livro do Chad … droga, não li ainda. Mas obrigado pelo lembrete. Eu tenho muitos pensamentos sobre _“outsourcing para a Índia”_. Mas nenhum positivo, então vou passar essa. É mais tópico para uma conversa com álcool envolvido :-)

**AkitaOnRails** : haha, se você algum dia pensar em fazer serviços via outsourcing, considere o Brasil. Você já ouviu qualquer coisa sobre nós em conversas sobre outsourcing?

**Dr Nic** : Nunca. As pessoas que ouço falando sobre outsourcing mencionam “Índia”, muitos países asiáticos e países do leste europeu. Nunca Brasil.

**AkitaOnRails** : Droga, eu sabia :-)

**Dr Nic** : Então, façam de conta que são Americanos e peçam por taxas Americanas.

**AkitaOnRails** : Bom conselho. Eu acabei de [escrever um artigo](http://www.akitaonrails.com/2007/04/14/off-topic-seja-arrogante) sobre a importância de ser fluente em inglês no meu blog. Essa é mais uma boa razão.

**Dr Nic** : Absolutamente. Clientes não pagam por linha de código. Eles meio que pagam por resultados, e meio que pagam para trabalhar com pessoas que gostem e possam confiar. Eu acho.

**AkitaOnRails** : E eu concordo com essa afirmação: pessoas contratam competência, em geral. E alguma vez você já considerou tirar férias no Brasil?

**Dr Nic** : Absolutamente, está em nossa lista de lugares a visitar.

**AkitaOnRails** : E o que sabe ou ouviu sobre nosso humilde país? (_pergunta padrão para um estrangeiro, eu precisava perguntar._)

**Dr Nic** : Futebol, pobreza, mulheres e a grande estátua na montanha, e a Amazônia.

**AkitaOnRails** : Aposto como é melhor que New Delhi ou Bangalore.

**Dr Nic** : Eles têm pobreza, mas nenhuma estátua na montanha :-)

**AkitaOnRails** : Bem, acho que já tomei muito do seu tempo. Que tal fecharmos? Você tem algo que gostaria de dizer à audiência brasileira? Recomendações de carreira? :-)

**Dr Nic** : Conselhos de carreira … Aprendam Inglês, orgulhem-se de ser Brasileiros e apreciem escrever código.

**AkitaOnRails** : Ah, última questão! _Nic_ é diminutivo para _Nicholas_? Dr. Nicholas Williams?

**Dr Nic** : Correto. PhD em Ciências da Computação. Apenas uso o nome _Dr Nic_ porque é um pouco diferente. Não é para exibir a parte “Dr”.

**AkitaOnRails** : Muito legal! Dr. Nic, então :-) Estou muito feliz por essa oportunidade. Espero poder conversar mais no futuro. Uma pena que não possamos conversar num bar com algumas cervejas.

