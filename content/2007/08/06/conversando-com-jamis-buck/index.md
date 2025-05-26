---
title: Conversando com Jamis Buck
date: '2007-08-06T13:03:00-03:00'
slug: conversando-com-jamis-buck
tags:
- interview
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/245186199_71f55cc3c7.jpg)

**English Original:** [here](/2007/8/3/chatting-with-jamis-buck)

Esta é outra grande entrevista. Desta vez com Jamis Buck, o programador que ajudou o próprio David Hansson bem no começo da Era Rails, na 37signals.

Hoje é mais conhecido por suas conquistas com Capistrano e um monte de outras bibliotecas Ruby como os bindings sqlite-ruby e Net::SSH. Jamis foi muito gentil de nos dar a oportunidade de conhecer mais sobre sua carreira e o começo da história de Ruby on Rails.


 **AkitaOnRails:** Ok, então vamos começar. A primeira coisa que pergunto a todos os meus convidados: qual é seu passado? Quero dizer, quando, como, por que você começou com programação? Foi o começo clássico, como um hobby, ou foi uma coisa mais recente por causa da carreira ou coisa parecida?

**Jamis Buck:** Eu comecei a programar quando estava na décima série, quando minha mãe um novíssimo computador pessoal Tandy. Ele tinha 20 Mb de espaço em disco, e vinha com [GW-BASIC](http://en.wikipedia.org/wiki/GW-BASIC). Eu tinha programado antes, gráficos-tartaruga e um pouco de BASIC, mas foi com o Tandy que comecei a levar a sério. Eu me ensinei GW-BASIC com o pequeno livro de referência que veio com o computador e escrevi alguns jogos simples e utilitários. Então eu me ensinei Turbo Pascal e Turbo C++ na 11a e 12a séries, e começou daí :)

**AkitaOnRails:** Então você decidiu ir para Ciência da Computação na faculdade? Eu li no seu perfil no [WorkingWithRails](http://www.workingwithrails.com/person/5309-jamis-buck) que você é um programador Java arrependido? Quanto tempo você programa em Java?

**Jamis Buck:** Sim, então eu pulei para Ciência da Computação quando entrei na faculdade. Me graduei um pouco tarde, em 1999, depois de trabalhar tempo integral para a universidade ([BYU](http://www.byu.edu/webapp/home/index.jsp)) como programador por alguns anos. Foi onde fiz todo meu trabalho com Java. Na realidade nós fazíamos aplicações Web em C, o que não é tão insano quanto parece! Mas então tivemos uma mudança de liderança quando um novo CIO chegou, e ele basicamente deu uma ordem cega: _“aprendam Java, enterrem C!”_ Então tivemos que re-ferramentar massivamente, tirar certificados e assim por diante. Eu estava na equipe que liderou a pesquisa sobre que ferramentas Java deveríamos usar, então ganhamos muita experiência com isso. Eu trabalhei com Java em tempo integral lá por uns 2 anos, até a [37signals](http://37signals.com/) chegar em Fevereiro de 2005 e me fazer uma oferta melhor, e eu nunca mais olhei para trás!

**AkitaOnRails:** Uau, então você pulou direto de Java na universidade para Rails na 37signals? Ainda é um pouco cedo do que eu esperava, mas já que você mencionou: como você entrou em contato com o pessoal da 37signals? Como começou em Ruby estando tão ocupado com Java antes?

**Jamis Buck:** Bem, eu estava envolvido com Ruby (primariamente como hobby) desde cerca de 2001. Eu escrevi algumas bibliotecas como os bindings [sqlite](http://sqlite-ruby.rubyforge.org/) e sqlite3, e na RailsConf 2004, eu conheci o DHH. Eu fiz alguns trabalhos lá na conferência para fazer Rails falar com banco de dados sqlite. Depois disso, lá para Novembro de 2004, eu acho, David me perguntou se eu não estaria interessado em fazer alguma consultoria para a 37signals. Em Dezembro de Janeiro fiz alguns trabalhos esquisitos para eles como adicionar SFTP e suporte a time zones no Basecamp. E então, em Fevereiro, eles me fizeram voar para Seattle para participar do workshop [Building of Basecamp](http://www.37signals.com/workshop-062504.php) lá e eles me fizeram uma oferta.

**AkitaOnRails:** Eu entendo que a 37signals é uma empresa pequena em termos de número de empregados e muito da sua força interna vem justamente desse fato. Ela mudou muito desde que você começou, quero dizer, nos últimos 2 ou 3 anos? O que você gostava mais na época e o que gosta mais agora?

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/conf_room.jpg)

**Jamis Buck:** Bem, quando eu cheguei, eu fui o quinto empregado, e o segundo programador. Antes de eu chegar, David fazia toda a programação e trabalho de administração de sistemas, então eu acho que foi um grande alívio para ele ter alguém com quem dividir a carga! Certa de um ano atrás, contratamos mais dois programadores, e desde então contratamos mais duas pessoas, incluindo um administrador de sistemas tempo integral. Eu não consigo expressar quanto eu odiava ser um administrador, já que eu tinha pouca idéia do que estava fazendo!

**AkitaOnRails:** Você parece ser o tipo de pessoa que gosta do _encanamento_ porque esteve envolvido com coisas de ‘baixo-nível’ como bindings sqlite, Net::SSH e assim por diante. Esse é o tipo de coisa que o empolga mais? Ou é apenas coincidência e na realidade você prefere trabalho com GUI também?

**Jamis Buck:** Na realidade eu jurei, alguns anos atrás, que eu nunca seria um desenvolvedor de aplicações web :) Eu sempre preferi escrever as ferramentas do que escrever as aplicações. Mas eu realmente gostei de descrever aplicações web na 37signals. A equipe é ótima e o ferramental (Rails!) é fantástico. Eu ainda gosto de escrever bibliotecas (trabalhando no [Net::SSH](http://raa.ruby-lang.org/project/net-ssh/) e [Net::SFTP](http://raa.ruby-lang.org/project/net-sftp/) v2 agora mesmo, de fato) mas aplicações não são tão ruins também :)

**AkitaOnRails:** Mas lá atrás quando você literalmente era segundo-em-comando não tinha muita escolha, tinha? Aposto que você fez muitas interfaces do Basecamp? E você mencionou que não gosta muito do trabalho de administração porque não sabia muito bem o que fazia, mas provavelmente agora é um expert porque Capistrano arrasa nesse campo. Eu lembro dele ser chamado de SwitchTower antes. Pode nos contar essa história?

**Jamis Buck:** Eu trabalhei um pouco em todos as aplicações, algumas mais do que outras. Eu realmente não escrevo a interface (esse é o domínio de Jason Fried e Ryan Singer), mas eu as conecto e faço funcionar.

Aprendi uma tonelada de coisas sobre administração de sistemas desde que comecei. Ainda sou um grande amador nisso mas aprendi mais do que imaginava aprender sobre como mysql realmente funciona, por exemplo :)

Quando lancei Capistrano da primeira vez, um ano e meio atrás mais ou menos, ele era chamado de SwitchTower, mas por volta de Março de 2006 eu recebi uma [carta e desistência](http://en.wikipedia.org/wiki/Cease_and_desist) de uma empresa que tinha o nome registrado, e então eu procurei por um novo nome. O Core Team do Rails ajudou imensamente na época, eles ofereceram uma tonelada de sugestões para nomes. Marcel eventualmente me mandou uma mensagem e sugeriu “Capistrano” que simplesmente “clicou” para mim e eu fui com esse. Recebi críticas de algumas pessoas, que acharam o nome pobre, mas eu rio agora porque a maioria das pessoas que usam Cap hoje provavelmente chegaram a ele depois da mudança de nome e nunca souberam o outro nome, e nem pensam duas vezes sobre isso.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/logo-big.png)

**AkitaOnRails:** Você provavelmente está muito ocupado agora por causa do lançamento do Capistrano 2.0. Ele é um grande desvio do 1.4.1, se entendo corretamente. Você reescreveu muita coisa, teve que quebrar a compatibilidade. Acha que conseguiu o que queria com o lançamento ou está querendo mais em um lançamento 3.0?

**Jamis Buck:** Cap2 é basicamente o que eu queria que fosse. Existem alguns pequenos ajustes na minha fila, mas nada significante. Ele é cerca de 90% compatível com Cap1, então a maioria das pessoas não deveria ter problemas na troca. E desde o lançamento do 2.0, a carga de manutenção para cap tem sido realmente pequeno. Estou muito satisfeito com ele. Ainda preciso me ocupar com documentação, no entanto :) Isso é o que ainda segura muitas pessoas para trás.

**AkitaOnRails:** O que é o que você mais gosta sobre cap? Obviamente usou-o em seus próprios deployments na 37signals. Eu fantasio que você tinha um monte de scripts shell, mais de um ano atrás, então os costurou juntos para construir o que foi o primeiro lançamento do Capistrano.

**Jamis Buck:** Antes de SwitchTower/Capistrano, tínhamos uma ferramenta escrita pelo David para deployment do Basecamp. Na época, Basecamp rodava em um único servidor, então o deployment não era mais do que um “svn up”. Mais tarde, movemos Basecamp para múltiplos servidores e lançamos o Backpack, e então entendemos que precisávamos de algo mais poderoso para deployments. Então eu fui incumbido de escrever alguma coisa e Capistrano foi o resultado. O “cap shell”, em particular, o deixa imediatamente e facilmente executar comandos arbitrários em múltiplos servidores, simultaneamente, o que é muito útil. Claro, “cap deploy” é legal também :)

**AkitaOnRails:** Me lembro de um episódio onde David relatou sobre 72 horas de um problema que deixou Basecamp fora do ar. Você estava envolvido nesse episódio? :-) Dores de cabeça como esse parecem engraçados quando nos lembramos deles agora, mas obviamente não tão engraçados na ocasião.

**Jamis Buck:** Ha, sim, isso realmente aconteceu alguns dias depois que fui contratado :) Estávamos adicionando suporte a UTF-8 no Basecamp e a migração de banco de dados não se deu bem. Varamos noite. Uma bela apresentação da cultura da 37signals :) Felizmente, esse tipo de coisa não aconteceu desde então, embora tenhamos tido nossa cota de emergências, claro.

**AkitaOnRails:** Lições aprendidas? Acho que é o que melhor se pode tirar dessas situações :-)

**Jamis Buck:** A lição principal que aprendi na época: quando brincando com charsets, garanta que tenha testado no maior número de charsets não-Latin1 quanto possível :) Naturalmente, nós testamos muitas vezes antes do deployment, mas realmente não pensamos em checar dados em russo ou japonês que estavam no banco de dados depois do teste, o que parece óbvio vendo agora. Nós tentamos alguns alfabetos não-Latin1 durante os testes mas os que tentamos funcionavam apesar da existência de alguns bugs. Outra lição aprendida: não importa quão bem você se prepare, alguma coisa sempre vai dar errado!

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/245186199_71f55cc3c73.png)

**AkitaOnRails:** Eu liderei uma equipe de voluntários e traduzimos seu livro [Getting Real](http://gettingreal.37signals.com/GR_por.php) para português do Brasil algum tempo atrás. Acredito que você se envolveu nisso também? Esse livro é uma referência ao espírito da 37signals, eu acho. Vocês realmente se movem da forma como está escrito? :-)

**Jamis Buck:** Na realidade eu não estava tão envolvido na composição do livro, embora tenha dado minha contribuição no processo de escrita. Mas sim, o livro descreve nossos processos. Realmente não há qualquer coisa no livro que não fazemos.

**AkitaOnRails:** Como vocês operam? Acredito que nem todos trabalhem no mesmo local físico? Vocês fazem muito trabalho remoto? Quantos programadores/administradores/designers trabalham lá agora?

**Jamis Buck:** Chicago é definitivamente o “coração” da 37signals: Jason, Ryan, David e Sam todos moram e trabalham lá. Temos um escritório lá também, e eles vão para lá regularmente trabalhar (embora eles também trabalhem de casa). Matt Linderman é nosso escritor, ele mora e trabalha em Nova Iorque. Mark Imbriaco, nosso administrador de sistemas, mora e trabalha em Chesapeake, na Virginia e Jeremy Kemper é outro programador, morando em Pasadena, na California agora. A natureza distribuída disso funciona muito bem para nós. Eu realmente amo trabalhar de casa, isso me possibilita estar mais envolvido com a vida de meus filhos, por exemplo, do que seria possível de outra maneira.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/building_djd.jpg)

**AkitaOnRails:** Ouvi que você é de Provo, em Utah? É uma coincidência porque meu chefe atual, [Carl Youngblood](/2007/7/20/conversando-com-carl-youngblood), também é de lá e também estudou na BYU :-) Por acaso vocês não se conhecem?

**Jamis Buck:** Na realidade moro em Caldwell, em Idaho, mas eu fui de Provo por cerca de 8 anos e sim, eu conheço Carl! Ambos participávamos do [Utah Ruby Users Group](http://groups.google.com/group/urug?hl=en). Ele é um grande cara.

**AkitaOnRails:** Você participou de muitas conferências para a comunidade Ruby. Não me lembro se escreveu algum livro. Está escrevendo algum agora?

**Jamis Buck:** Eu ia originalmente escrever um livro sobre Capistrano para a Apress, mas isso esfriou. Não estou ativamente envolvido em nenhum livro no momento, e realmente não tenho muito interesse nisso, honestamente. Eu prefiro muito mais escrever software! E eu tento postar no meu blog de vez em quando também.

**AkitaOnRails:** Sim, o [buckblog](http://weblog.jamisbuck.org/), tem dicas muito legais que eu gosto de ler. Você começou o blog por cause de Rails ou já tinha um blog de Java na época?

**Jamis Buck:** Eu comecei antes de Rails. Se ler os primeiros artigos, verá que sou bem eclético. Ainda estava tentando entender esse negócio todo de “blog” :) Desde então foco em desenvolvimento de software e uso o meu [blog familiar](http://family.jamisbuck.org) para posts mais pessoais atualmente.

**AkitaOnRails:** Eu também fui um programador Java e ainda tento me manter informado sobre o que está acontecendo em outras comunidades como Java, algum PHP, Python. O que você acha ou sente sobre outros frameworks e tecnologias como CakePHP, o [Seaside](http://www.seaside.st/) de Avi Bryant ou mesmo Django?

**Jamis Buck:** Honestamente, estou um pouco envergonhado de admitir que não tenho acompanhado outros frameworks tanto quanto deveria. Seaside tem idéias legais e meu desejo de melhorar minhas habilidades de programação Smalltalk me tem feito querer cutucar isso mais a fundo. Mas mais do que isso, não tenho pesquisado muito (para meu detrimento pessoal, estou certo).

**AkitaOnRails:** E ainda sobre Java, ando muito empolgado atualmente sobre JRuby. Eu entrevistei [Ola Bini](/2007/06/21/conversando-com-ola-bini-jruby-core-team-member) e meio que estou perseguindo Charles Nutter. Você conheceu esse pessoal? Se interessou sobre isso?

**Jamis Buck:** Sei quem são, e eu encontrei Charles em algumas conferências, mas nunca tive a chance de conversar com ele mais a fundo. JRuby definitivamente soa empolgante. Estou muito curioso, de fato, de saber se ele pode suportar Net::SSH ou não já que isso significa que você poderia rodar Capistrano sobre ele. Mas não tive a chance de realmente tentar isso.

**AkitaOnRails:** Insistindo no assunto de Java, eu postei algum tempo atrás sobre algumas discussões sobre Design Patterns apontarem [defeitos nas linguagens](/2007/7/30/gof-design-patterns-sobreviveu-ao-teste-do-tempo), e eu acabei de ler [um post](http://weblog.jamisbuck.org/2007/7/29/net-ssh-revisited) que você escreveu sobre Dependency Injection e sua biblioteca Net::SSH. O que acha de Design Patterns agora que é um programador Ruby em tempo integral?

**Jamis Buck:** Design Patterns são maravilhosos. Eles nos dão uma linguagem para falar mais concisamente sobre programação. É muito mais fácil dizer “use um método factory” do que dizer muitas palavras e confundir uns aos outros. Sobre design patterns específicos, alguns são mais úteis que outros em diferentes ambientes. Como escrevi no meu post, Dependency Injection é uma das coisas que você não precisa em Ruby, mas em ambientes como Java, pode ser um salva-vidas.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/276456883_dd0ae43334.jpg)

**AkitaOnRails:** Sobre a 37signals novamente, vocês estão bem comprometidos com produtos Apple. Eu vi aquele vídeo na [Apple Education](http://www.apple.com/education/whymac/compsci/video.html) com Jason e David. Agora vemos que o [Leopard](http://weblog.rubyonrails.org/2006/8/7/ruby-on-rails-will-ship-with-os-x-10-5-leopard) não trará somente Ruby mas também Rails, Mongrel e até mesmo Capistrano. Como é a relação de vocês com a Apple?

**Jamis Buck:** Não diria que existe qualquer “relacionamento” com a Apple. Somos grandes fãs de seus designs e interfaces e acho que isso reflete em nosso próprio trabalho. A própria Apple está incluindo Rails, Mongrel e Capistrano por causa do despertar de sucesso dessas ferramentas. Mac OS X realmente é um ambiente poderoso para programadores e adicionar essas ferramentas no pacote os fazem maiores ainda. Faz sentido incluir as populares ferramentas Ruby também, já que Ruby se tornará um [cidadão de primeira classe](http://rubycocoa.sourceforge.net/HomePage) no desenvolvimento de aplicações OS X, graças à adoção pela Apple dos bindings de Cocoa para Ruby.

**AkitaOnRails:** Você obviamente usa um Mac para seu trabalho. Quais são as ferramentas que usa mais além do Textmate?

**Jamis Buck:** Bem, Capistrano :) Firefox com Firebug, Parallels (para testes com IE), iTerm (embora eu esteja aguardando o novo Terminal.app no Leopard), [Campfire](http://www.campfirenow.com) é indispensável, AdiumX, NetNewsWire, Knox (para acesso simples a filesystem encriptado). Eu ainda decaio e uso vim de vez em quando, para edições rápidas. Provavelmente tem mais :) Mas não consigo lembrar deles de cabeça.

**AkitaOnRails:** Existe muita conversa sobre [GTD](http://en.wikipedia.org/wiki/Getting_Things_Done) hoje em dia. Acho que vi seu perfil no 43folders. Você está por dentro desse tipo de filosofia de organização também? Como você mantém sua rotina organizada? Muitas pessoas (eu incluso) sofrem para diferenciar trabalho de hobby e para nos manter dentro das datas dos projetos e tal.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/502950270_7175d894c8.jpg)

**Jamis Buck:** Eu não sou um fanático por GTD. Eu acho que tento ser bem pragmático sobre isso. Embora seja terrível com procrastinação. Na maior parte, das 8 às 5 eu tento me focar nas tarefas que foram assinaladas para mim e fora disso, trabalho com meus hobbies … que acabam cruzando com trabalho de vez em quanto :) Realmente sou a pessoa errada para perguntar sobre ser organizado! Se não fosse pela minha esposa, acho que faria muito pouca coisa, na realidade.

**AkitaOnRails:** No que está mais interessado atualmente além de Rails, Capistrano? Não necessariamente sobre tecnologia. Algum hobby?

**Jamis Buck:** Recentemente tenho me interessado sobre história militar, o que me levou a ler sobre a Guerra Civil Americana entre outras coisas. Minha esposa e eu realmente estamos gostando do Harry Potter 7 neste instante também :) E estou muito ligado a meu Nintendo Wii ultimamente! Eu costumava gostar de RPG, mas não tenho jogado por alguns anos. Ainda tenho uma tonelada de livros para [D&D](http://en.wikipedia.org/wiki/Dungeons_&_Dragons), embora, talvez algum dia me livre deles :) Gosto de gastar tempo com meus filhos (Nathaniel tem 5 anos e Katie tem 3). Vamos sair para acampar por alguns dias em uma semana ou duas, na realidade. Sempre alguma coisa para me manter ocupado!

**AkitaOnRails:** Haha, entendo. E você viaja bastante? Fora dos Estados Unidos, quero dizer.

**Jamis Buck:** Não realmente. Ano passado eu fui para Londres pela primeira vez, para a RailsConf lá, e este ano eu fui para a República Tcheca. Mas fora disso, sou muito caseiro. Eu até gostaria de viajar mais, mas não gosto de viajar sozinho, e ter crianças põe um freio no aspecto espontâneo de “levantar e ir” viajar. Fazemos viagens ocasionais de carro, o que é legal.

**AkitaOnRails:** Você ouve sobre o que acontecer nas comunidades Ruby/Rails pelo mundo? O que sente sobre o crescimento meteórico de Rails nos Estados Unidos? A 37signals, claro, foi o combustível para tudo isso e a razão que nós – ambos Rubistas agora – estamos conversando hoje.

**Jamis Buck:** Eu ouço algumas notícias, mas eu limei bastante meus feeds. Acho que assino somente de 30 a 40 feeds agora. Foi realmente empolgante ir para a República Tcheca e ver a excitação lá sobre Rails. Me lembrou muito de como as coisas eram nos Estados Unidos alguns anos atrás.

O crescimento de Rails tem sido incrível. Existem dores decorrentes do crescimento, claro. Com uma adoção maior se começa a acumular pessoas que não estão apaixonadas pela ferramenta, e somente querem aprender por causa do currículo, ou porque um cliente pediu por isso, e eu acho que isso dilui bastante as águas. Mas sempre haverá um núcleo de usuários apaixonados e é isso que torna a comunidade tão maravilhosa. Tem sido uma experiência realmente fantástica ser parte desse núcleo, quase desde o começo de Rails.

**AkitaOnRails:** Você tem a rara oportunidade de ver tudo isso de uma perspectiva de um VIP, perto de Jason e David. E claro, você mesmo, sendo um dos propulsores da comunidade. Muitas pessoas pensam no David como um [arrogante](http://www.flickr.com/photos/eugevon/130610241/) :-) Eu posso entender perfeitamente seu ponto de vista de opiniões. O que acha disso, da perspectiva de alguém que realmente conhece o homem?

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/245186199_71f55cc3c72.png)

**Jamis Buck:** David é uma das pessoas mais confiantes que já conheci. Minha maior frustração com ele é que ele está CERTO quase sempre. Ele é um pensador muito claro e pula direto ao núcleo das questões, o que pode ser bem desconcertante se não estiver acostumado. Todos esses atributos combinam, eu acho, para fazer as pessoas que não o conhecem considerá-lo “arrogante”. Mas ele não é arrogante. Ele não coloca as pessoas para baixo para se parecer acima. Ele é apenas extremamente talentoso, muito esperto e não divaga. Estou muito honrado de poder conhecê-lo. Aprendi muito com ambos, ele e Jason.

**AkitaOnRails:** Não sei se entendi corretamente mas Jason Fried foi quem começou a 37signals? Poe nos dar uma pequena pincelada sobre as origens da empresa? Eu sei que David não dos Estados Unidos, como eles se conheceram?

**Jamis Buck:** Jason co-fundou a 37signals, no final dos anos 90. Originalmente era uma consultoria de design. Em 2003, Jason começou a trabalhar em um projeto em PHP, e perguntava online sempre que travava. David respondia suas perguntas diversas vezes e Jason finalmente perguntou se David não escreveria o projeto. David veio como meio-período por um tempo então, já que estava terminando seus estudos. Mas eventualmente, Jason quis escrever Basecamp, e David fez todo o trabalho, meio-período, em Ruby. Suas experiências com aquilo, claro, levaram a Rails. E eventualmente David se tornou um parceiro na empresa. Isso foi em 2004, se me lembro corretamente.

**AkitaOnRails:** Legal. E voltando a falar de você. Agora que Capistrano 2.0 foi finalmente lançado, você está envolvido em alguma nova ferramenta open source?

**Jamis Buck:** Com Cap2 lançado, estou realmente focado em reescrever Net::SSH e Net::SFTP. Algumas frustrações com suas limitações escrevendo cap2 tornaram isso necessário :) A única coisa “nova” que saiu disso é Net::SCP, que é uma implementação de um cliente SCP em Ruby e que vou lançar quando lançar a versão 2 do Net::SSH e Net::SFTP.

**AkitaOnRails:** Oh, e falando nisso, eu lembro que o antigo Cap 1.4.1 não tocava muito bem em Windows. Isso é correto? Algum avanço nessa área ou você acha que suportar Windows é muita coisa?

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/3/506252072_642ad7ea39.jpg)

**Jamis Buck:** Bem, até onde eu sei, cap 1.4.1 funcionava bem em Windows. A limitação é que você não poderia fazer deploy PARA máquinas Windows. Deployment A PARTIR de Windows funciona bem. E sobre fazer cap deploy funcionar PARA Windows, não tenho planos. A dificuldade é que Windows não é um ambiente POSIX, que é uma das premissas do Capistrano, a respeito das máquinas destino.

**AkitaOnRails:** Ah sim, eu nunca tentei isso, daí minha confusão. Você está certo. Bem, eu acho que já tirei muito de você. Alguma coisa que gostaria de dizer à comunidade Brasileira? :-)

**Jamis Buck:** _“Mantenham-se apaixonados”_ :) Mantenha a paixão por Rails queimando, é o que faz valer a pena pertencer à comunidade.

**AkitaOnRails:** Não poderia ser melhor. Algum plano de vir para cá?

**Jamis Buck:** Ha, nenhum no futuro imediato :) Tenho um bebê chegando em Setembro, o que coloca um freio em planos de viagem :) Mesmo assim, eu adoraria visitar o Brasil algum dia.

**AkitaOnRails:** Não sabia disso. Parabéns!

**Jamis Buck:** Obrigado.

**AkitaOnRails:** Bem, muito obrigado por seu tempo. Foi uma conversa muito instrutiva. Sei que as pessoas vão gostar disso

**Jamis Buck:** Muito obrigado, Fabio. Estou muito grato por esta oportunidade!

