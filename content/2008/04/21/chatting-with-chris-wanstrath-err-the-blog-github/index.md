---
title: Conversando com Chris Wanstrath (Err the Blog/Github)
date: '2008-04-21T19:12:00-03:00'
slug: conversando-com-chris-wanstrath-err-the-blog-github
translationKey: chatting-chris-wanstrath
tags:
- interview
- traduzido
aliases:
- /2008/04/21/chatting-with-chris-wanstrath-err-the-blog-github/
draft: false
---

Chris é um cara muito acessível e tranquilo, e bastou pegá-lo pelo AIM para a entrevista começar de cara. Para quem nunca ouviu falar de **Chris Wanstrath**, ele é também conhecido pelo Err the Blog e, mais recentemente, como um dos caras por trás do fenômeno **Github**.

Ele respondeu tudo com riqueza de detalhes e conversamos bastante sobre seus projetos open source, performance, escalabilidade e, claro, muito sobre Git e Github. Espero que isso deixe as pessoas ainda mais animadas com o ritmo em que a comunidade Ruby/Rails está movendo as coisas pra frente.

**AkitaOnRails:** Ok, de onde você é?

**Chris Wanstrath:** Atualmente moro em San Francisco, mas cresci em Cincinnati, Ohio. Me mudei para San Francisco em 2005 para trabalhar na C|NET, onde fiz PHP por um tempo em sites como [gamespot.com](http://gamespot.com), [mp3.com](http://mp3.com) e [tv.com](http://tv.com).

Em 2006 me mudei para o site [chowhound.com](http://chowhound.com) dentro da C|NET para trabalhar com Rails, algo que eu vinha fazendo nas horas vagas há um tempo. Enquanto estava lá, **P.J. Hyett** e eu trabalhamos no chowhound.com e depois construímos o [chow.com](http://chow.com), que lançamos mais tarde naquele ano. Então em abril de 2007 os dois saímos da C|NET para formar nossa empresa de consultoria, Err Free.

Em dezembro de 2007 lançamos o [FamSpam](http://famspam.com/), um site para manter contato com sua família. É basicamente uma versão simplificada do Google Groups com ênfase em participar de uma thread pelo menos uma vez por semana e encontrar facilmente fotos ou outros arquivos enviados.

Enquanto P.J. e eu trabalhávamos no FamSpam, **Tom Preston-Werner** e eu trabalhávamos no GitHub nas horas vagas. Começamos em outubro trabalhando noites e fins de semana. Queríamos basicamente uma maneira fácil, bonita e cheia de recursos de jogar nossos repositórios Git no ar e compartilhá-los com as pessoas. Conforme fomos nos aprofundando, percebemos como coisas como o dashboard poderiam mudar a forma como lidamos com contribuições open source. Depois disso, todas as funcionalidades sociais começaram a se encaixar. O beta privado do Github foi lançado em janeiro e em abril vimos o lançamento público.

**AkitaOnRails:** Uau, cara, você é muito ocupado mesmo. Quero entrar em detalhes em cada tópico que você mencionou, mas primeiro: eu soube que você trabalhava na C|Net por causa das suas palestras sobre memcached. Tenho 2 perguntas: você era programador PHP, o que te fez mudar para Ruby on Rails? E aí, trabalhar para uma rede de alto perfil como a C|Net te expôs a sites muito exigentes. Como você descobriu como aproveitar o memcached com Rails e depois o plugin cache_fu?

**Chris Wanstrath:** Comecei a fazer Rails no início de 2005 e peguei meu primeiro emprego com PHP em fevereiro de 2005 (antes disso eu fazia ASP e Perl, sobre os quais prefiro não falar). Então, honestamente, nunca me considerei um "programador PHP" mais do que um programador Rails. Eu realmente gostava de sites e sabia que podia me pagar fazendo PHP, então foi o que fiz. Enquanto isso, estava constantemente fazendo Ruby nas horas vagas.

Quando a C|Net começou a fazer Rails, soube que seria uma combinação perfeita para mim. Eu gostava muito de PHP e adorava Gamespot, mas era simplesmente absurdo passar a noite inteira brincando com Ruby enquanto trabalhava profissionalmente com PHP.

Na verdade, uma das coisas que me contrataram no Gamespot foi meu parser de yaml em PHP puro chamado [SPYC](http://spyc.sourceforge.net/) (simple PHP yaml class). Foi inspirado (obviamente) no parser syck yaml do _why. Eu queria uma forma fácil, sem extensões, de lidar com YAML em PHP porque estava muito mimado pelo Ruby.

Acho que hoje os frameworks CakePHP e Symfony o usam e fazem suas configurações em yaml. Mas mesmo escrevendo PHP eu queria estar escrevendo Ruby. O motivo principal pelo qual aprendi Ruby foi que eu conhecia PHP e Perl, mas queria algo que pudesse usar tanto para escrever sites quanto scripts de linha de comando. Perl era ótimo para scripts e PHP era ótimo para sites, mas eu estava simplesmente cansado de usar os dois.

Então enquanto estava aprendendo Python, o Rails apareceu.

Quanto ao [cache_fu](http://errtheblog.com/posts/57-kickin-ass-w-cachefu), eu tinha muito interesse nos aspectos de "escalabilidade" de manter um site enquanto trabalhava no Gamespot.

Embora bom design OOP e afins possam ser aprendidos por qualquer um que escreva código suficiente, não dá para aprender sobre escalabilidade a não ser que você esteja trabalhando em um site grande. Há truques demais e partes móveis demais, e é muito difícil simular a carga em um ambiente controlado.

Então, enquanto estava no Gamespot, como disse, tentei aprender o máximo possível sobre coisas como replicação MySQL, clustering de bancos de dados, sharding de bancos de dados e memcached com base em como os caras espertos da C|Net configuraram tudo ao longo dos anos. Eles tinham muitas máquinas servindo muito tráfego, então era perfeito.

No Chowhound, estávamos reescrevendo um antigo site HTML estático em Rails e preocupados com a transição de arquivos planos para chamadas de banco de dados dinâmicas e geração de páginas. Tinha um tráfego considerável de um grupo de fãs fanáticos, e sabíamos que o novo visual "web 2.0" do site não iria agradar os usuários mais antigos, então pelo menos queríamos que o site fosse performático para dar a eles um motivo a menos para reclamar. Então basicamente pegamos muito do que eu aprendi no Gamespot e as informações disponíveis livremente na internet em listas de e-mail e discussões, e tentamos fazer uma forma mais amigável ao Rails de cache de objetos com memcached.

Ruby é tão bom em eliminar repetição e criar APIs amigáveis. Por isso o cache_fu faz cache de fragmentos e cache de objetos, porque em sites maiores você acaba usando ambos para propósitos diferentes, que foi basicamente como era no Gamespot.

**AkitaOnRails:** Interessante. E não é muito comum eu encontrar pessoas que lidaram com sites realmente grandes. Você pode nos dar uma ideia de que tipo de carga seus apps Rails tiveram que suportar? Alguns especialistas que conheço reclamam da distribuição vanilla do Rails e recomendam muitos ajustes como abandonar completamente o ActiveRecord e vários outros hacks. Você precisou hackear muito o Rails para atingir a escalabilidade que precisava, ou acha que a maior parte é boa o suficiente para evitar muito tweaking?

**Chris Wanstrath:** Não consideraria o Chowhound um grande site Rails mais. Agora que temos scribd, twitter, friends for sale e Yellowpages, o Chowhound não entra mais na lista.

Acabamos fazendo muita otimização prematura naquele site e pouca otimização do mundo real. Aprendi muitas lições lá que apliquei em outros sites pelo caminho. No entanto, recentemente tive a chance de trabalhar com os caras do friends for sale no app deles para Facebook, que recebe milhões de visualizações de página por dia e lida com uma quantidade insana de registros no banco.

Pelo que sei, o único hack no AR que fizemos foi aplicar o patch de atualizações parciais do Pratik Naik. Isso porque, com tantas linhas e índices tão grandes, você quer evitar modificar índices quando não precisa, então salvar apenas as colunas/atributos alterados pode ter um ganho de performance bem grande. Felizmente, as atualizações parciais agora estão no Rails Core.

Na minha experiência, você passa muito mais tempo tentando escalar o SQL antes mesmo de precisar endereçar o AR. E quando chega na parte do AR, geralmente é o código da sua aplicação. Buscar e salvar registros demais em callbacks de before/after_save, gravações de linhas completas como eu acabei de descrever, e geralmente não ser um bom cidadão SQL. Só abandonaria o AR completamente se sentisse que não tinha controle sobre o SQL gerado por ele. O que, como qualquer um sabe, não é o caso — você tem muito controle sobre ele.

Há momentos, no entanto, em que o AR é exagero e você realmente precisa de velocidade. No Github, precisamos autenticar você toda vez que tenta fazer pull ou push de um repositório via ssh. Carregar um ambiente Rails inteiro, ou mesmo o activerecord, era notavelmente lento, então mudamos para usar sequel em um script ruby simples. Como não precisamos do enorme conjunto de funcionalidades do AR e das boas capacidades de OOP para uma busca de linha única tão simples, fez muito sentido para nós.

**AkitaOnRails:** Concordo com isso, foi o que experimentei também em relação ao AR. Então, você é também autor de vários outros plugins Rails famosos como will_paginate, Ambition, o original Sexy Migrations. Pode comentar brevemente sobre cada um? Estou esquecendo algum outro plugin? Parte do que você fez se tornou o padrão "de facto" para desenvolvimento Rails, algumas pessoas aqui usam esses plugins sem realmente saber que você fez todos eles.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/21/113964679_23c106ba1b.jpg)   
_P.J Hyett na SXSW'06_

**Chris Wanstrath:** [Err the blog](http://errtheblog.com) são na verdade duas pessoas, P.J. Hyett e eu. Eu não escrevi o [will_paginate](http://errtheblog.com/posts/56-im-paginating-again) — P.J. escreveu a versão original e depois Mislav Marohnić a reescreveu. Mislav é agora o mantenedor. Mas eu ainda fico com todo o crédito, o que me está bem.

Quanto aos outros plugins, há mofo, ambition, sexy migrations, cache_fu, acts_as_textiled, fixture_scenarios_builder e gibberish.

[Mofo](http://errtheblog.com/posts/35-me-and-uformats) é um parser de microformatos baseado em Hpricot. Está no Github e infelizmente não recebe tanto carinho meu ultimamente, mas pelo que sei ainda é o padrão ouro para parsing de microformatos em Ruby.

Foi o primeiro gem que lancei que também funcionava como plugin Rails, que é como acho que a maioria dos plugins deveria ser distribuída no futuro. Gems já têm um sistema de distribuição sólido e esquema de versionamento, e se o Github se tornar uma fonte de gems então praticamente não há razão para não lançar plugins como gems.

[Sexy migrations](http://errtheblog.com/posts/51-sexy-migrations) foram inspiradas pelo Hobo. Infelizmente a versão deles era específica para Hobo, então escrevi uma versão amigável para plugins. O DHH depois escreveu sua própria versão e incorporou ao core, totalizando 3 implementações distintas de sexy migrations.

[Gibberish](http://errtheblog.com/posts/55-ya-talkin-gibberish) é um plugin de localização bem divertido que escrevi _pro bono_ para um cliente, simplesmente porque sentia que as APIs de todos os plugins de localização existentes eram muito difíceis de trabalhar. Esperançosamente, com a ajuda de quem tiver interesse, podemos começar a localizar o Github em breve.

[Ambition](http://errtheblog.com/posts/64-even-more-ambitious) foi inspirado por uma incursão no Erlang. Li um post de blog explicando que a sintaxe de consulta do [mnesia](http://www.infoq.com/news/2007/08/mnesia), que é toda compreensão de listas (basicamente a versão Ruby do módulo Enumerable), foi possibilitada pela capacidade de percorrer a árvore de parse e construir uma consulta mnesia dessa forma.

Então comecei a brincar com o gem parse_tree para ver se conseguia fazer o mesmo para Ruby. Agora é, claro, um framework completo para gerar consultas arbitrárias para qualquer RubyGem baseado em Enumerable. Para consultas simples, realmente gosto de tratar tabelas como arrays — parece muito natural.

[Acts_as_textiled](http://errtheblog.com/posts/12-actsastextiled) foi o primeiro plugin Rails que lancei. É uma prova do Rails que o plugin ainda funciona na versão edge hoje. A única outra coisa notável que o Err iniciou é o termo "vendor everything", que agora faz parte do Rails através do [config.gems](http://ryandaigle.com/articles/2008/4/1/what-s-new-in-edge-rails-gem-dependencies).

Isso e o gem [Cheat](http://errtheblog.com/posts/21-cheat) (e o site).

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/21/322610984_f5d9e82bda.jpg)   
_Tom Preston-Werner_

**AkitaOnRails:** (Claro, me desculpe P.J.!) E isso desperta outra curiosidade minha: de onde veio o nome "Err"? É tanto para o [Err the Blog](http://errtheblog.com/) quanto para a [Err Free](http://errfree.com/), que é sua empresa. Você mencionou P.J. e Tom. E vocês três são Railers em tempo integral, certo? Como vocês se uniram e decidiram começar a própria empresa? Muitas pessoas me perguntam sobre empreendedorismo e você é mais um bom exemplo.

**Chris Wanstrath:** "err" é uma espécie de trocadilho com "Typo", que era o motor de blogging em Rails mais popular quando começamos nosso blog, então pode ser um pouco confuso, mas na verdade sou cofundador de duas empresas distintas.

Há a **Err Free** e a **Logical Awesome**. Err Free é consultoria e treinamento em Ruby & Rails. P.J. e eu somos donos da empresa, e a usamos para fazer trabalho de cliente, palestras, treinamento corporativo, esse tipo de coisa. Ela também é dona e operadora do FamSpam, que usamos com nossas próprias famílias.

Logical Awesome, no entanto, foi fundada por mim e Tom. Isso porque eu estava desenvolvendo FamSpam com P.J. e GitHub com Tom ao mesmo tempo, separadamente. Hoje, no entanto, P.J. faz parte da Logical Awesome e é um dos desenvolvedores do GitHub.

Tom trabalha na **Powerset** e na verdade não faz muito Rails para o GitHub — ele faz principalmente flash, haxe, C, css, design e ruby. E porque ele é o autor do [God](http://god.rubyforge.org/), faço ele escrever todos os arquivos de config também. Quanto à decisão de começar uma empresa, sou alguém que precisa estar envolvido em tudo o que faço em todos os níveis. Na C|Net, há um limite de quanto você pode contribuir num site que emprega 30 pessoas, especialmente quando há pessoas dedicadas de produto e "visão", enquanto no Github somos apenas eu, Tom e P.J.

Se o site for lento, confuso, ruim ou não melhorar seu fluxo de trabalho, posso assumir responsabilidade por isso. Mas se for rápido, simples, incrível e transformador, também fico com essa responsabilidade. O que é muito gratificante.

Também significa que, quando você é cofundador de uma empresa majoritariamente técnica, as discussões são muito mais lógicas. Vi decisões sendo tomadas na C|Net que contradiziam diretamente estatísticas de A/B que tínhamos coletado. Na Logical Awesome, isso nunca aconteceria. Não é nem lógico nem incrível. Basicamente: queria encontrar a empresa ideal, então encontrei boas pessoas e a fundei.

**AkitaOnRails:** Ok, chegamos ao prato principal do dia: o [Github](http://github.com)! Não consigo pensar em melhor exemplo de produto inovador que aproveita tão bem o poder do Git. Estou muito curioso para entender como você teve essa ideia. Ao mesmo tempo, muita gente ainda não consegue entender por que os Railers como um todo começaram a usar Git tão maciçamente de repente. O pessoal do Mercurial e Bazaar está muito desconfortável. O que você acha que o Git tem que atraiu os Railers em bando? Ou pelo menos o que você acha que o Git tem que nenhum outro tem? Comecei a evangelizar Git aqui no Brasil no ano passado depois de ouvir Randall Schwartz, e recentemente alguém me perguntou qual seria minha escolha para um killer-app Rails e Github me veio à mente imediatamente. Então você tem boa presença mental também.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/21/Picture_1.png)](http://github.com)

**Chris Wanstrath:** Github é super emocionante para mim porque é realmente um site feito para mim. Tom e eu somos bem parecidos no sentido de que ambos temos uma quantidade considerável de projetos open source, todos usados e corrigidos por pessoas que nunca conhecemos.

Lidar com isso do jeito antigo estava bom até que eu e P.J. começamos a trabalhar no FamSpam... à medida que meu tempo livre diminuía, minha capacidade de manter meus projetos open source diminuía também. E isso é definitivamente um problema de fluxo de trabalho. Às vezes quando você não consegue encontrar tempo suficiente para fazer algo, você só precisa fazer esse algo demorar menos tempo.

Github foi literalmente escrito para chronic, god, ambition, will_paginate e o resto dos nossos projetos. Queríamos tornar muito simples para as pessoas contribuírem, e isso realmente não é possível sem Git.

Comecei a usar Git logo depois de assistir à [palestra técnica do Linus](http://www.youtube.com/watch?v=4XpnKHJAok8) em maio de 2007, que é muito boa para explicar Git de um nível conceitual bem alto. Então quando esse problema de tempo surgiu, eu já usava Git há alguns meses e Tom, coincidentemente, estava tentando resolver o mesmo problema.

Conversamos depois de um meetup local de Ruby em San Francisco, num bar é claro (onde todas as grandes ideias e parcerias começam), e decidimos trabalhar no problema juntos. Eu estava brincando com um Gitweb específico do Err, mas Github é obviamente muito mais ambicioso em escopo.

Quanto à adoção do Git, não tenho ideia do que foi o ponto de inflexão. Quando começamos a trabalhar no app em outubro, estávamos preocupados com ./script/plugin e tarballs e windows e espelhamento de svn. Não tínhamos nem certeza se conseguiríamos construir um negócio em torno de Git, porque o subversion ainda era tão dominante.

Como todos sabemos, no entanto, Git chegou ao ponto de inflexão no início de 2008 e todo mundo de alguma forma encontrou tempo para experimentá-lo. Talvez leve uns dois segundos para perceber o quanto é mais rápido, e depois mais alguns segundos para perceber o quanto é mais incrível. Então não é grande surpresa que esteja conquistando convertidos.

Quanto à comunidade Rails, definitivamente é por causa dos projetos. Quando Merb, Rubinius e Ruby on Rails todos migram para Git, você não tem escolha. É para onde a comunidade está indo. Quanto a outras linguagens, temos um grande número de projetos não-Ruby no Github. PHP, Java, Javascript, Lisp, Python — há alguns forks de Django, por exemplo, as linguagens de programação [io](http://www.iolanguage.com/) e [nu](http://programming.nu/) também estão hospedadas no Github.

Então o que realmente importa são os early adopters, acho. Nu é um lisp escrito em Objective-C, muito novo e muito de ponta. As pessoas que o usam agora são pessoas que percebem o quanto é poderoso e incrível rodar uma linguagem tão dinâmica em uma plataforma tão madura e estável. E naturalmente, os pensadores progressistas por trás do nu sabem que Git (e controle de versão distribuído) é um conceito igualmente poderoso e igualmente de ponta.

Com Prototype e Scriptaculous migrados, e rumores de outros frameworks Javascript migrando, é só uma questão de tempo até Git se tornar ainda mais difundido.

Acho que os Railers simplesmente gostam muito de blogar.

Quanto a outras soluções, é Rails vs Django de novo. Se você usa Mercurial, tudo bem. Os dois são tão parecidos (sim, [Git funciona ótimo no Windows](http://kylecordes.com/2008/03/22/git-windows-works/)) que enquanto as pessoas migrarem para controle de versão distribuído, ainda é uma vitória.

Ah, mas espera, Mercurial não tem Github :-)

![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/21/Picture_3.png)

**AkitaOnRails:** Exatamente :-) E me pergunto quais foram os desafios de montar algo como o Github. Não é um simples app Rails, com código Ruby muito rápido e puro. Você provavelmente está lidando com milhares de chamadas de sistema para binários Git, vários jobs em background, manutenção, segurança. O que você acha que foram os maiores desafios ao montar o Github antes de lançá-lo recentemente ao público?

**Chris Wanstrath:** Bem, você acertou em cheio... escalar Rails é a parte fácil. Escalar sshd, Git, Git-daemon e nossos jobs em background é a parte difícil.

Chamamos Git diretamente muitas vezes por página, precisamos processar jobs que entram de muitos lugares diferentes (criar um repositório no site, fazer push de um repositório via ssh), precisamos ser seguros (ssl e ssh para todos os repositórios privados o tempo todo), precisamos garantir que tudo rode rápido (memcached tanto para chamadas Git quanto para o banco), precisamos garantir que você esteja _"por dentro"_ com um feed de notícias agregando informações de todas as fontes diferentes dentro do nosso sistema (quase 1 milhão de linhas na tabela de feed quando lançamos).

Então definitivamente não foi fácil. Sem mencionar que ssl é essencialmente o "modo lento" para http, então precisamos garantir que estamos indo rápido porque coisas como seu dashboard já têm uma desvantagem de velocidade. Como exemplo, o sshd armazena suas chaves num arquivo authorized_keys. Bem, nem tínhamos terminado nosso beta ainda e o arquivo de chaves tinha mais de 4 megabytes de texto puro. Então tivemos um dos gurus de C da Engine Yard patcheando o sshd para nós para fazer pesquisas baseadas em MySQL, nos dando pesquisas mais rápidas e sem o custo de acrescentar/escrever num arquivo massivo.

Matthew Palmer é o referido guru, e planejamos tornar esse código open source em breve.

Também temos hooks de post-receive (quando você faz "Git push") rodando que hospedamos e entregamos — então se você fizer push, faremos POST para uma URL arbitrária com JSON dos commits. Mas você também pode nos dar algumas informações e faremos post para campfire, irc, twitter ou lighthouse com payloads customizados.

Como temos flash, flash com haxe, Python, C, ruby, scripts bash, muito Javascript e algum erlang por vir nos bastidores, é definitivamente uma mistura interessante.

Temos a sorte de estar hospedados na **Engine Yard**, no entanto. Se não os tivéssemos, estaríamos perdidos. A configuração incrível de cluster deles com GFS significa que podemos hospedar nossos potencialmente centenas de gigabytes de repositórios em um drive compartilhado com RAID, redundância e backups. Se estivéssemos rodando Github em um VPS barebones, nem sei como compartilharíamos acesso a esses repositórios. Não seria divertido.

Eles também têm muitos especialistas disponíveis 24/7, o que é ótimo porque tenho tendência a esquecer de dormir e trabalhar até as 7 da manhã. Esses caras tiram muito da dor de rodar um site muito dependente de Unix.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/21/Picture_5.png)](http://www.flickr.com/photos/ozmm/487496000/)

**AkitaOnRails:** Interessante, Erlang? Adoraria saber o que você está fazendo com ele. Voltando, acho que vi um clone Git do trunk do Rails no Github muito antes de o DHH anunciar isso alguns dias atrás. Acho que foi Michael Koziarski quem fez primeiro, sem muito alarde. Vocês estavam planejando isso junto com o pessoal da 37signals, ou a migração do Rails Core para o Github foi algo que aconteceu naturalmente? E vocês têm algum tipo de parceria com o pessoal do Lighthouse também, porque vocês já têm alguns hooks para gerenciar tickets do Lighthouse através de mensagens de commit do Github, certo?

**Chris Wanstrath:** O material de Erlang vai ser muito legal, prometo. Faremos muito barulho sobre isso quando estiver pronto. Quanto ao Rails, o koz de fato tinha um espelho do seu repositório Git-svn no Github durante o beta. Era não oficial. Então em fevereiro ele escreveu um [post explicando](http://www.koziarski.net/archives/2008/2/23/on-Git) que o core estava pensando em migrar para Git.

Quando vi o post, enviei um e-mail para ele e conversamos um pouco sobre o que precisaria ser feito para mover Rails para o Github, que era obviamente algo que amo em um número enorme de níveis. Ele disse que voltaria a falar comigo, e então algumas semanas depois o time Core nos contactou e queria discutir a migração. O resto é história.

Realmente respeito o trabalho que o time do [Lighthouse](http://www.lighthouseapp.com/) faz. O bug tracker é ótimo, e o novo redesign é ainda melhor, mas não temos nenhuma parceria oficial com eles. Escrevemos o hook post-receive do lighthouse porque queríamos, o Rails queria e um grande número dos nossos usuários queria.

**AkitaOnRails:** Muitos outros começaram a migrar para o Github durante o Beta. Acho que o Merb foi mais óbvio por causa do envolvimento do Ezra com a Engine Yard. Dr. Nic começou a usá-lo para os bundles do Textmate. Você pode apontar algum outro projeto relacionado a Rails de alto perfil hospedado no Github agora?

**Chris Wanstrath:** Merb foi na verdade o motivo pelo qual o Github entrou em beta. Lançamos o beta para que eles pudessem começar a usar o site para a reescrita 0.9 do merb-core. Quanto a projetos populares, a melhor coisa a fazer é verificar [http://Github.com/popular/watched](http://Github.com/popular/watched) e [http://Github.com/popular/forked](http://Github.com/popular/forked). Datamapper, Rspec e Mephisto são alguns dos populares.

**AkitaOnRails:** Você está usando código Git vanilla, ou o customizou de alguma forma para melhor se adaptar ao seu ambiente? Já conversou com Junio Hamano ou algum outro mantenedor do core do Git? Com o Github provavelmente consumindo muito do seu tempo, como estão o Chow e o FamSpam agora? Como você está gerenciando todos esses produtos ao mesmo tempo?

**Chris Wanstrath:** Patcheamos o Git-daemon para registrar estatísticas, que em breve vamos surfacear no site na forma de atividade melhor e mais granular. Você poderá ver quantas vezes seu projeto foi clonado, projetos populares nas últimas 24 horas, projetos mais clonados de todos os tempos, esse tipo de coisa.

Enviamos e-mail para os caras do core do Git sobre o site, só para dizer obrigado por escreverem o Git e para informá-los sobre o Github, mas na verdade não tivemos ocasião de conversar sobre nada em particular. Se algum dia me cruzar com algum deles, definitivamente vou pagar algumas doses.

Na verdade, não trabalho mais no Chow. Meu último dia na C|NET foi há quase exatamente um ano, então meu tempo com Ruby é gasto no FamSpam, Github, open source e fazendo trabalho de cliente ocasionalmente.

FamSpam está indo bem. Agora que o Github foi lançado, há alguns recursos que queremos adicionar. Por sorte, no entanto, o site está muito polido e rodando sem precisar de muita intervenção. O que adoraríamos fazer, porque no fundo é uma ótima lista de e-mail baseada em Rails, é experimentar alguns conceitos diferentes.

Talvez um para open source, ou uma versão para times de liga juvenil — qualquer um que precise manter contato e ter seu fluxo de e-mail e compartilhamento de documentos otimizado. Por ora, no entanto, tento gastar o máximo de tempo possível no Github. Há tantos lugares para onde queremos levá-lo.

**AkitaOnRails:** Provavelmente já ultrapassei o tempo da entrevista (me desculpe por isso), mas essa conversa é super interessante. Um projeto que acabei de lembrar é o Sake. Para mim o Sake é muito bacana porque muita gente reclama de quão "difícil e complexa" é a linha de comando do Git, e soluções como Sake facilitam muito o fluxo de trabalho. Por exemplo, meu fluxo de trabalho Git inteiro para projetos Rails são apenas 4 pequenas tarefas sake como Git:update e Git:push. Se não me engano, alguém do Err fez o Sake, certo? Você ainda está evoluindo ele?

**Chris Wanstrath:** Sim, eu escrevi o [Sake](http://errtheblog.com/posts/60-sake-bomb). Não é um plugin Rails, mas foi escrito para ajudar no desenvolvimento Rails. As "tarefas Git" para Sake estão ficando bem populares, pois Git realmente facilita um fluxo de trabalho melhor. Se você quiser implementá-lo, ou diferentes ramificações desse fluxo, você pode facilmente empacotar alguns comandos numa tarefa rake ou script bash.

E enquanto scripts bash são ótimos, as tarefas sake são portáteis. Muito do sake foi inspirado, de forma muito livre, no Git — você pode importar tarefas sake de qualquer arquivo de texto, seja na web ou local, e sake vem com seu próprio daemon para servir suas tarefas.

Então você poderia compartilhar tarefas via wifi, por exemplo, da mesma forma que poderia compartilhar repositórios Git numa rede adhoc. Sake está no Github, então fique à vontade para adicionar funcionalidades que achar que devem existir.

**AkitaOnRails:** Outra coisa sobre a qual gostaria de ouvir sua opinião. Recentemente fiz uma apresentação sobre estratégias de deploy Rails para iniciantes. A arquitetura simples mais comum gira em torno de Apache/Nginx/Litespeed + Mongrel/Evented Mongrel/Thin/Ebb. Geralmente é uma questão de balanceamento de carga entre um servidor web usando algum tipo de IPC para distribuir a carga de volta para VMs Ruby rodando sua app Rails.

Agora temos mod_Rails. Qual é sua opinião sobre ter todas essas escolhas, você tem alguma receita particular que prefere ou depende das necessidades de cada aplicação? Você teve tempo de testar mod_Rails? Acho que Hongli Lai está fazendo um trabalho ótimo em relação a coisas como mongrel_light_cluster e seus esforços para tornar o GC do Ruby mais amigável ao copy-on-write. Você deu uma olhada nisso?

**Chris Wanstrath:** A coisa boa da Engine Yard é que eles cuidam de tudo isso para mim. Então, enquanto antes passava muito tempo fazendo benchmark e brincando com diferentes soluções, como Mongrel vs Emongrel, agora simplesmente deixo os especialistas cuidarem disso para que eu possa me concentrar no Github.

Então não, ainda não brinquei com mod_Rails porque não estou numa situação em que pudesse implantá-lo mesmo que quisesse usá-lo. Que na minha opinião é a melhor situação para se estar, e é basicamente a razão pela qual mod_Rails foi escrito.

**AkitaOnRails:** E a propósito, você vai fazer alguma apresentação na RailsConf este ano?

**Chris Wanstrath:** Vou. Vou falar sobre _"Beyond cap deploy"_, que será basicamente um olhar aprofundado na arquitetura do Github, e depois vou estar num painel com Ben Curtis, Geoff Grosenbach, P.J. e Tom sobre ser um "programador lucrativo" com projetos paralelos.

**AkitaOnRails:** Estou muito satisfeito por ter tido a oportunidade de conversar com você.

**Chris Wanstrath:** Eu também. Obrigado!
