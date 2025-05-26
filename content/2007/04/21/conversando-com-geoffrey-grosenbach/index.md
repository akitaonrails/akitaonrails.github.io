---
title: Conversando com Geoffrey Grosenbach
date: '2007-04-21T22:00:00-03:00'
slug: conversando-com-geoffrey-grosenbach
tags:
- interview
draft: false
---

**English readers, click [here](/2007/4/19/chatting-with-geoffrey-grosenbach)**

 ![](/files/geoffrey.gif)

A entrevista com [Dr Nic](/pages/drnic) foi um enorme sucesso. E conhecer e trocar idéias com pessoas tão espertas e inteligentes é muito viciante. Então, novamente tive muita sorte de conseguir entrar em contato com **Geoffrey Grosenbach** , da [Topfunky Corporation](http://www.topfunky.com/). Ele foi muito gentil aceitando o convite para esta entrevista e dividindo sua experiência conosco, brasileiros.

Estou tentando bastante conhecer e entrevistar mais celebridades da indústria americana, então se segurem aí que podemos ter mais surpresas.

Foi uma conversa bem longa, que eu gostei muito. Discutimos muito sobre ele mesmo, seus projetos, a comunidade Ruby on Rails e coisas ainda por vir. Então, vamos começar.


### Quem é Geoffrey?

**AkitaOnRails** : Nós conhecemos o nome Geoffrey Grosenbach do [Rails Podcast](http://podcast.rubyonRails.org/) e [PeepCode](http://peepcode.com/). Mas novamente, quem é Geoffrey Grosenbach? De onde você veio? Como iniciou com Rails?

**Geoffrey** : Quem sou eu? É uma grande questão, mas eu vi que você perguntou a Dr. Nic, então estava esperando por isso ;-) Eu comecei com Rails cerca de 2 anos atrás enquanto estava morando no Taiwan. Eu era um coordenador de tecnologia numa escola americana e queria acompanhar o que estava acontecendo na comunidade de desenvolvimento web. Eu também tinha alguns lances de free-lance e pensei, _“Vou tentar Rails em um deles”_. O cliente não se importava qual tecnologia era usada e foi uma grande oportunidade de usar Rails em um projeto real, que é provavelmente algo que eu devo fazer novamente! De qualquer forma, antes eu trabalhei para várias startups. Minha formação universitária na verdade é em **Filosofia** , embora nunca tenha ganho um centavo disso (mas foi um grande tópico para se estudar).

**AkitaOnRails** : Legal. E qual o lance sobre Taiwan? Quanto tempo morou lá? Foi somente para algum projeto em particular?

**Geoffrey** : Eu morei lá por menos de 2 anos. Queria morar fora dos EUA por um tempo e alguns amigos me encorajavam a ir trabalhar na escola deles. Teve alguns anos secos em 2002 e 2003 quando era difícil conseguir um bom trabalho de desenvolvimento web aqui, então peguei a oportunidade. Eu ensinei algumas classes relacionadas à computação para adolescentes e também comprei equipamentos e mantinha a rede (Windows 98) rodando.

**AkitaOnRails** : A Era Pós-[Bolha](http://en.wikipedia.org/wiki/Dot-com_bubble). Você mencionou startups, algum nome conhecido? E Jesus, Windows 98 em 2003? :-)

**Geoffrey** : Sim, era bem triste. Felizmente, não era Windows ME! Eu atualizei toda a rede para XP enquanto estive lá. Também rodei alguns servidores linux para firewalls e coisas do tipo, e convenci a escola a me comprar um Mac com tela dupla. Mas quanto a startups …

Escrevi software do tipo para data-mining, chamado Project Guides que foi posteriormente comprada pela Onvia. Onvia era uma companhia bem grande e vendia equipamentos para computadores online antes de se tornar pública. Mas agora eles mudaram completamente e estão no negócio de contratos com o governo.

Foi um trabalho engraçado porque eu basicamente criei a posição. Fui contratado para escanear artigos de jornal e rodar um software de OCR para extrair o texto (como um interno da faculdade). Pensei, _“Isso não poderia ser feito online?”_ Então pesquisei fontes existentes e escrevi um robô como prova-de-conceito que visitaria sites de anúncios de projetos do governo e catalogaria projetos ainda por vir em que as companhias poderiam competir. Não havia RSS, então teve muita interpretação do HTML para puxar os dados dela.

**AkitaOnRails** : E tudo isso na Era da Bolha da Internet? Quão ruim a explosão da bolha afetou você, sua vida e seus planos?

**Geoffrey** : Sim. Bem, com uma graduação em filosofia, não esperava ser muito rico. Quando consegui aquele trabalho de programação foi uma grande surpresa. Mas eu amo programar (minha primeira aula de programação foi aprendendo BASIC na 4a série, no meio dos anos 80).

**AkitaOnRails** : E por curiosidade, o que o levou a se formar em Filosofia em vez de, vamos dizer, Ciências da Computação?

**Geoffrey** : Sou um ávido **autodidata** e sentia que me beneficiaria mais aprendendo muitos dos tópicos por conta própria em vez de seguir um programa. Depois que me formei, muitos dos meus amigos formados em Ciências da Computação vinham a mim me perguntar como fazer coisas básicas como conectar a um banco de dados ou escrever uma página web dinâmica. Acho que apenas preferi aprender por conta própria, no trabalho, em vez de em uma classe.

**AkitaOnRails** : Haha, Eu entendo isso completamente. Eu tenho uma situação similar. Sou um autodidata também. Mas de volta à primeira questão, não foi um pouco fora do comum pegar Ruby como uma opção há 2 anos atrás? Ou ele já era famoso naquela época?

**Geoffrey** : Eu tinha ouvido sobre Ruby acho que na época do [famoso artigo da Dr. Dobbs](http://www.ddj.com/dept/webservices/184404436) em 2000 ou 2001. Pensei, _“Que esquisito. Chamar métodos em um número inteiro?”_ Eu gostaria de ter tentado mais na época, e não sei porque não tentei. Eu estava tentando outras linguagens como [REBOL](http://en.wikipedia.org/wiki/REBOL) e aprendendo C e Java, claro. Mas por que Ruby? Eu estava fazendo o serviço de algum cliente e me deparei com [Basecamp](http://www.basecamphq.com/). Com isso eu conheci Rails e decidi tentar usá-lo. Além disso, não estava trabalhando para uma empresa que requeria uma linguagem em particular. A escola em Taiwan usava Cold Fusion e eu escrevi alguns scripts de administração de sistemas em Perl, mas poderia usar o que quisesse.

**AkitaOnRails** : Você trabalha com Rails hoje em dia? Talvez seja hora de perguntar sobre a [Topfunky](http://www.topfunky.com/). O que pode nos dizer sobre isso?

**Geoffrey** : Bem, o trabalho em Taiwan era um contrato de 2 anos. Então eu tinha que decidir se queria ou não assinar por mais 2 anos. Decidi voltar a Seattle e parecia uma boa hora para tentar alguns bicos free-lance antes de me candidatar a outros empregos. Ironicamente, um dos empregos em que me candidatei me mandaria de volta à Onvia para escrever a próxima geração de softwares de robôs para eles (como um sub-contratado).

Então, eu esqueci a série exata de eventos, mas comecei meu [blog](http://nubyonrails.com/) e também consegui um pequeno bico fazendo Rails. Tem sido 100% Rails desde então, a maioria para a [PNN](http://pnn.com/), uma empresa perto de São Francisco. Na realidade, tenho trabalhado consistentemente para a PNN pelo último ano e meio. Mas estarei tempo integral com PeepCode a partir dos próximos um ou dois meses.

**AkitaOnRails** : Eu ia perguntar isso. Parece que [PeepCode](http://peepcode.com/) faz muito sucesso agora.

**Geoffrey** : Oh sim, parte do acordo me levou a uma reunião da Seattle Ruby Brigade no verão de 2005, que por acaso aconteceu na Amazon.

### O Rails Podcast

[![](/files/railspodcast.png)](http://podcast.rubyonrails.org/)

**AkitaOnRails** : Você começou tudo isso ao mesmo tempo? O blog, o podcast, os screencasts?

**Geoffrey** : O blog primeiro. Eu escrevi a biblioteca [Sparklines](http://nubyonrails.com/pages/sparklines) inspirado em uns rascunhos deixados numa mesa na Amazon. Então fiz algumas entrevistas para o podcast e eventualmente tomei conta disso. PeepCode tem apenas uns 6 meses de idade, mas foi muito melhor do que eu jamais teria esperado.

**AkitaOnRails** : Ainda não ouvi todos os [Rails Podcast](http://podcast.rubyonrails.org/). Quem foi o primeiro entrevistado? De onde veio a idéia de fazer entrevistas?

**Geoffrey** : Eu não comecei, na realidade. [Scott Barron](http://rubyi.st/), do Core Team do Rails começou, baseado num desafio de Heinemeier Hansson. Ele entrevistou DHH e então Dave Thomas, e depois disso se passou um mês. Escrevi a ele perguntando se ele publicaria uma entrevista se eu fizesse uma.

Sempre me interessei por gravação e áudio. Então acabei fazendo mais 43 e ainda indo forte! Meu primeiro convidado foi Thomas Fuchs, do [Scriptaculous](http://script.aculo.us/). Honestamente, a qualidade do som foi inicialmente horrível. E eu tremia um pouco nas entrevistas, mas aprendi muito no processo.

**AkitaOnRails** : Seu [último episódio do podcast](http://podcast.rubyonrails.org/programs/1/episodes/jack_dorsey_and_alex_payne_of_twitter) foi sobre o Twitter, Alex Payne e a discussão sobre o problema de escalabilidade. Ainda não tive tempo de ouvir. Como foi? Já está tudo acertado? Eles não estão deixando Rails, estão? :-)

**Geoffrey** : Estou surpreso como o problema do Twitter se tornou tão falado ultimamente. Teve essa entrevista em um blog com Alex Pane e depois a resposta do DHH, e estourou daí. Com sorte, essa entrevista vai comandar tanta mídia como a outra. ;-) O podcast que fiz com Alex e Jack Dorsey, criador do Twitter, foi bem civilizado.

**AkitaOnRails** : Exatamente, tenho [acompanhado](http://www.akitaonrails.com/articles/2007/04/15/a-polemica-twitter) o fluxo dos eventos e também me surpreendeu. Mas os caras do Twitter estão chateados sobre todo esse barulho ao redor deles?

**Geoffrey** : Eles falaram sobre a idéia, como levou apenas 2 semanas para desenvolver a primeira versão. E rapidamente mencionaram que estavam tendo alguns problemas de escalabilidade, que estão consertando. Dos comentários do Blaine, o líder de desenvolvimento, eles têm sido muito abertos sobre isso. Eles não parecem estar muito chateados e tem suportado Rails completamente, e ainda sendo honestos sobre os problemas que estão atacando.

### A Comunidade Rails

[![](/files/railsconf.jpg)](http://conferences.oreillynet.com/rails/)

**AkitaOnRails** : E abruptamente mudando de assunto, e sobre as conferências. RubyConf, RailsConf, US, EU, você participou de todos?

**Geoffrey** : Tive muita sorte de poder participar de muitos deles, sim. RubyConf 2005 e 2006. RailsConf Chicago e Londres. Estarei na Rails Conf Portland este ano, e também Berlin. E estou indo para a [GoRuCo](http://www.goruco.com) em Nova Iorque amanhã. Senti falta de alguns dos regionais também, como a de Salt Lake City e o SDForum.

**AkitaOnRails** : Essa é a ocasião quando você faz os podcasts? Você os caça e os grava? É como funciona? :-)

**Geoffrey** : Eu sempre disse que se não pudesse pagar para ir às conferências, iria apenas para os happy hours! É ótimo encontrar as pessoas ao vivo. Tento fazer tantos quanto possíveis ao vivo. Gravar pelo Skype é uma grande opção, mas a qualidade de som costuma ser baixa. Gosto da sensação jornalística, no local, de fazer ao vivo. E eu acabei de conseguir um pequeno gravador portátil que eu levo a todos os lugares comigo (a Zoom H4).

**AkitaOnRails** : Sim, com certeza, os happy hours! E sei que as opiniões serão a favor do Rails, mas você já encontrou algum ‘cético’ na platéia das conferências? Sente que eles estão tendo dificuldades em aprender ou mesmo usar Rails no trabalho? Quais são as coisas boas ou reclamações que costuma ouvir?

**Geoffrey** : Bem, se alguém está pagando US$1000 ou mais para voar até a conferência, comprar a entrada, pagar o hotel, provavelmente não serão céticos. Mas há uma grande mistura de pessoas, alguns dos quais estão começando a aprender sobre Rails. Definitivamente existem partes difíceis no aprendizado de Rails, ou pelo menos partes que não são convencionais. É o que eu tento cobrir no PeepCode.

**AkitaOnRails** : Muitos dos programadores participantes dos eventos são pessoas em transição para o Rails, ou você vê pessoas começando suas carreiras indo diretamente ao Rails? Rails ainda tem o status de novidade ou já está bem estabelecido aí nos EUA?

**Geoffrey** : Ainda novidade, eu acho. Escrevi a uma faculdade local me oferecendo para dar uma apresentação às suas turmas de Ciências da Computação sobre Rails. Eles nunca responderam. Acho que muito depende dos próprios estudantes de se manter atualizados e aprender por conta própria. O que é uma surpresa! Também acho que há muitas pessoas que querem usar mas estão em trabalhos onde não podem. Mas definitivamente existe mais demanda do que programadores (nos EUA). Então, pelo menos por enquanto, as pessoas que conhecem Rails podem se beneficiar do status de novidade.

**AkitaOnRails** : E os programadores estão se acostumando a conceitos como _“Convenção em vez de Configuração”_ ou mesmo ao lance de REST do Rails 1.2? O que você acha?

**Geoffrey** : Indo mais em detalhes nisso, acho que existe uma grande desconexão entre pessoas da vanguarda do Rails, que usam o   
Rails do [trunk/edge](http://dev.rubyonrails.org/) o tempo todo, daqueles que estão apenas aprendendo usando os lançamentos oficiais. Mesmo agora, algumas pessoas falam como se já tivéssemos mudado completamente da sintaxe /articles/custom\_action em vez da /articles;custom\_action. Então existem muitos tentando aprender Rails, ou lançando um produto em que estavam trabalhando por 6 ou 9 meses. Para essas pessoas, tem muito aprendizado sobre os estilos atuais que são difíceis. Nem todos podem re-escrever completamente sua aplicações toda vez que a sintaxe muda. Mas as idéias gerais do Rails estão vazando para outros frameworks, então acho que as pessoas estão ficando mais familiarizadas com as idéias, especialmente REST. Mas depende de cada pessoa, claro.

### Aprendendo Rails

[![](/files/adrianholovaty.jpg)](http://www.holovaty.com/)

**AkitaOnRails** : Tendo feito diversos podcasts, blogs e material de ensino no PeepCode, onde você sente que as pessoas estão tendo mais dificuldade com Rails? Onde estão travando? Muitas pessoas que conheço estão com um pouco de receio sobre a sintaxe concisa (a maioria programadores Java) e a falta de compilação (tipagem estática).

**Geoffrey** : Duas coisas,

1. A mágica que acontece por trás dos panos. Em [Django](http://www.djangoproject.com/), por exemplo, existe uma conexão mais explícita entre os templates sendo renderizados e as variáveis sendo passadas. Com Rails, existe um benefício de ter as coisas acontecendo automaticamente, mas também pode confundir.
2. ActiveRecord. Ainda é a maior parte do Rails e a coisa que atrai as pessoas, mesmo que existam outros ORM por aí. Acho que tem tudo a ver com interface de usuário e aprender a tirar vantagem do que está lá sem ficar frustrado pelo que está acontecendo às escuras. Por exemplo, eu estava debugando um problema esquisito com _validates\_uniqueness\_of_ na noite passada. Ainda não sei o que estava acontecendo, e pode ter sido um problema sobre quão tarde era, mas o erro estava bem fundo em algum lugar dentro do Active Record. Se alguém estivesse apenas aprendendo Rails e esperando que as coisas funcionassem perfeitamente o tempo todo, isso poderia ser realmente confuso.

**AkitaOnRails** : Você estava usando o edge? Ou a versão estável?

**Geoffrey** : Estável. Mas qualquer projeto de programação vai encontrar esse tipo de dificuldade. O problema é que as pessoas esperam que Rails seja uma navegação 100% perfeita, alguma vezes (eu incluso).

**AkitaOnRails** : Java era assim também lá no meio dos anos 90. Agora as pessoas estão mais ligadas no seu comportamento. E falando de Django, lembro que você entrevistou [Adrian Holovaty](http://podcast.rubyonrails.org/programs/1/episodes/adrian_holovaty). Ele parece um cara legal. Como você o convidou? Um cara de Python falando em um show de Ruby. E você tem usado Django? Gostei muito dele.

**Geoffrey** : Bem, me interesso em ver outras perspectivas em linguagens e frameworks. Acho que é parte do que me atrai a Ruby. Anteriormente, uma das entrevistas mais populares foi com [Avi Bryant](http://smallthought.com/avi/), do [Seaside](http://www.seaside.st/) e [DabbleDB](http://www.dabbledb.com/). Então acho que as pessoas gostam de ouvir alguém de fora do Rails de vez em quando. Então me encontrei no escritório dele em uma manhã de Domingo. Foi uma grande conversa, embora eu entenda Django um pouco melhor agora, portanto faria perguntas diferentes se o entrevistasse novamente. Essa é ainda a entrevista com maior número de downloads, depois daquela com o DHH.

**AkitaOnRails** : Não brinca! Eu digo a colegas o tempo todo: _“não se limite a apenas uma coisa. Mais ainda, não sejam idiotas religiosos!”_ Uma vez brinquei: _“vocês parecem com Sauron, um framework para controlar tudo, e na escuridão, uní-los!”_ :-) Você vê pessoas assim também? Espero que eles estejam diminuindo para uma geração com mais mente aberta.

**Geoffrey** : Estranhamente, muitos programadores open source encaram software como um departamento de marketing encararia. _“Precisamos de uma fatia maior do mercado!”_ Ou religiosamente, achando que você precisa escolher uma e ficar com ela. Mas felizmente web services e APIs remotas estão mudando isso.

**AkitaOnRails** : Sim, é tudo em torno de APIs, _“se não for uma API aberta, eu não uso”_. Não lembro onde ouvi isso.

**Geoffrey** : Muitas pessoas têm um blog em Rails que importam links do site del.icio.us a partir de seus servidores rodando PHP, que rastreiam suas estatísticas do Google, rodando Python ou seja lá no quê o Google Analytics roda. Portanto existem muitas ferramentas que são boas em coisas diferentes. E usando coisas dos outros, você pode pegar suas melhores idéias!

**AkitaOnRails** : Acho que sim, é uma das coisas mais atraentes sobre toda essa conversa de “Web 2.0”. Não apenas o aspecto de rede social, mas também a facilidade de **inter-operabilidade**.

**Geoffrey** : Eu venho usando [HAML](http://haml.hamptoncatlin.com) desde a última semana, e amo a sintaxe, que é muito parecida com YAML. Culturalmente, fazemos isso, então não deveria ser surpresa que linguagens de programação também não possam.

### Projetos Pessoais e Disciplina

**AkitaOnRails** : Então, como vai sua vida com tantas coisas a fazer, lugares a ir e pessoas a conhecer? Conferências, Topfunky, PeepCode, podcasts, entrevistas. Como você organiza tantas atividades? Muitas pessoas que conheço reclamam, _“não tenho tempo suficiente para aprender coisas novas”_, como desculpa para não aprender Rails ou sei lá. Alguma dica para a platéia?

[![](/files/zedshaw.jpg)](http://www.zedshaw.com)

**Geoffrey** : Meu modelo de organização pessoal e refinamento de processo é Zed Shaw. Ainda preciso entrevistá-lo sobre isso, mas ele mantém estatísticas de quantos bugs ele faz e então muda seu fluxo de trabalho se atinge um certo número. Eu não sou tão perfeitamente calibrado, mas mexo nas minhas ferramentas para tirar o máximo de benefício delas. Uso diferentes listas de tarefas e sistemas de gerenciamento de projetos (Backpack, meu próprio: [The Online CEO](http://theonlineceo.com/)). A maior parte é para ter consciência das minhas próprias habilidades, necessidades e disposição mental!

Um problema que estou tentando resolver é como manter um projeto open source. Comecei com um punhado de coisas e a receber patches das pessoas, mas não tenho tempo para realmente aplicá-las e debugá-las, ou re-escrevê-las para funcionar como acho que deveriam. Estou pensando em rodar um servidor [svn](http://subversion.tigris.org) aberto onde qualquer um possa comitar. Open source sem a responsabilidade de manter o projeto andando! ;-)

**AkitaOnRails** : Você precisa sub-contratar um _mantenedor_ :-) Nada pode ser comitado a menos que tenha passado por uma boa revisão ou um conjunto de testes mais sério.

**Geoffrey** : Sim, o problema é encontrar um mantenedor que tenha tempo livre. Mas é legal ter um projeto que de fato faça dinheiro, porque isso mantém as prioridades claras.

**AkitaOnRails** : Aliás, que projetos open source?

**Geoffrey** : Bem, tenho uma pilha de 30 patches para o [Gruff](http://nubyonrails.com/pages/gruff) que não tive tempo de comitar. E mesmo alguns dos meus próprios plugins Rails e documentação, como as receitas de Capistrano que publiquei para a Dreamhost e TextDrive. Eu nem mesmo tenho aplicações minhas lá agora, então é difícil se motivar a mantê-las. Minha esposa adora limpar a casa e colocar uma pilha “livre” em frente de casa. Normalmente, ela pode se livrar de uma pilha de 20 ou 30 objetos em 24 horas dessa maneira. Preciso de uma versão open source disso. ;-)

**AkitaOnRails** : Oh, esse é um assunto legal que estava quase esquecendo: seus projetos open source. Entendo que mantêm alguns. Qual é o que as pessoas mais gostam?

**Geoffrey** : Gruff é definitivamente o mais popular. Aprecio escrever bibliotecas de gráficos e usá-las em meus próprios projetos.

**AkitaOnRails** : Muitos aqui provavelmente não estão familiarizados com Gruff. Como você o apresentaria?

**Geoffrey** : Comecei Gruff no outono de 2005. Muitas pessoas estavam no IRC ou blogs dizendo _“Onde tem uma boa biblioteca de gráficos em Ruby? Não consigo encontrar nenhum.”_ Então estava assistindo um filme numa noite e estava com meu laptop. Comecei a pensar sobre que tipo de biblioteca de gráficos eu gostaria de usar, como as APIs funcionariam, etc. Ao final do filme, eu tinha um bom começo. Então, ele faz gráficos de barra, de linha e algumas outras. Ele usa [RMagick](http://rmagick.rubyforge.org), que é o maior problema. É difícil instalar todas as dependências. Ryan Davis, aqui de Seattle, escreveu uma biblioteca PNG em Ruby puro. Tenho esperanças de escrever uma biblioteca de gráficos mais simples toda em Ruby.

**AkitaOnRails** : Sim, ouvi falar disso. Ouvi que é mais estável que [ImageMagick](http://www.imagemagick.org) (sem os vazamentos de memória).

**Geoffrey** : Na realidade, ele tem alguns diferentes em desenvolvimento. ImageScience faz redimensionamento. Sua biblioteca separada de png pode desenhar e renderizar fontes simples.

### Além de Ruby

**AkitaOnRails** : Então, alguma vez você já esteve em contato com Charles Nutter, Ola Bini ou alguém da equipe [JRuby](http://www.akitaonrails.com/articles/2007/04/17/jruby-é-sério)? Você tem acompanhado o assunto? Tem alguma opinião ou ouvido alguma conversa de javeiro a respeito?

**Geoffrey** : Eu [entrevistei](http://podcast.rubyonRails.org/programs/1/episodes/Railsconf_europe) Charles Nutter na RailsConf em Londres, alguns dias depois dele ter começado a trabalhar na Sun. Acho muito empolgante ver esse projeto perto de se completar. A inter-operabilidade com Java será um grande empurrão para projetos Java existentes. Também estou empolgado sobre o projeto [Rubinius](http://rubini.us/), por Evan Phoenix aqui em Seattle.

[![](/files/evanphoenix.jpg)](http://blog.fallingsnow.net/rubinius/)

A cultura antiga ao redor do Ruby no Japão envolveu um monte de experimentação e hacking no próprio interpretador Ruby. Espero que o Rubinius torne possível para as pessoas hackearem em Ruby mesmo. E provavelmente também será mais rápido e mais fácil de dar manutenção. Ele também tem grandes funcionalidades para introspecção. Mesmo os próprios métodos são objetos em Rubinius, com algumas funcionalidades a mais do que Ruby tem agora.

**AkitaOnRails** : É um dos obstáculos que o pessoal de JRuby está enfrentando. Você vê uma forte troca de informações entre os projetos? Junto com XRuby, talvez?

**Geoffrey** : Eles definitivamente estão trabalhando juntos. Eu sei que todos os implementadores alternativos se encontraram na RubyConf em Denver no último outono. Acho até que eles devem ter um mailing list.

**AkitaOnRails** : E com toda a turbulência pela comunidade, o que você acha que são os desenvolvimentos mais empolgantes?

**Geoffrey** : PeepCode, claro!

**AkitaOnRails** : hahaha, claro! :-)

**Geoffrey** : Sério, eu acho que tem tantos grandes projetos que é difícil se manter atualizado em todos eles.

**AkitaOnRails** : Você está certo, não seria justo apontar para apenas um ou dois. Eu ia perguntar quem foi o seu convidado favorito no podcast, mas isso também não seria justo. Em vez disso pergunto: alguma vez já esbarrou com alguma situação engraçada ou curiosa durante alguma de suas entrevistas? Alguma coisa que saltou aos olhos?

**Geoffrey** : Eu adoro poder documentar a história do Ruby. Foi ótimo [entrevistar Matz](http://podcast.rubyonrails.org/programs/1/episodes/yukihiro_matsumoto), e ter traduzido do japonês por ele. [Jim Weirich](http://podcast.rubyonrails.org/programs/1/episodes/jim_weirich) é muito profundo. Entrevistar [Marcel Molina e Sam Stephenson](http://podcast.rubyonrails.org/programs/1/episodes/railsconf_2006_marcel_molina_and_sam_stephenson) juntos foi ótimo. Marcel falou mais, mas quando Sam falava era somente naquelas tacadas concentradas e concisas. Ele seria um grande escritor de discursos, o discurso teria apenas 2 minutos e seria o suficiente para comunicar efetivamente.

**AkitaOnRails** : O Core Team, sim. Eu lembro disso. Ele _TEM_ que ser conciso: afinal ele escreve uma [biblioteca javascript](http://www.prototypejs.org/) que precisa carregar rápido mesmo numa conexão lenta :-)

**Geoffrey** : Gravar clandestinamente um concerto do [why the lucky stiff](http://podcast.rubyonrails.org/programs/1/episodes/sxswi_why_the_lucky_stiff) na SXSW 2005 foi muito engraçado.

**AkitaOnRails** : SXSW, [South by Southwest](http://2007.sxsw.com/). Os brasileiros não devem estar a par desse evento. Poderia descrever a eles rapidamente? Quem se encontra lá, sobre o que é?

**Geoffrey** : Ah, acontece uma vez ao ano no Texas. É parte de um festival de música e filmes, e ambos são muitos maiores do que a parte de desenvolvimento web. Mas quase todo desenvolvedor web que já escreveu um livro ou tem um blog popular vai pra lá (pelo menos os americanos). Dura somente uns 3 dias, mas é um período divertido.

**AkitaOnRails** : Eu sei que muitos podcasters vão lá. Você se encontrou com o pessoal do Revision3, TWiT, C|Net, Podshow e outros? Vocês tem eventos de Podcast aí também, não tem? Muitos brasileiros ainda estão só começando a entender a beleza dos podcasts.

**Geoffrey** : Eu nunca estive em conferências de podcast. Conheço alguns outros podcasters do Boagworld Podcast, Web 2.0 Show, mas não muitos. Consegui um iPod Video no Natal e comecei a assinar mais desde então, agora quee tenho o espaço para carregar todos. Eu gosto de Dan Benjamin’s Hivelogic Radio Show, alguns video podcasts, como ZeFrank. Gosto de podcasts mais jornalísticos, mais na rua do que os que são excessivamente produzidos.

**AkitaOnRails** : São boas sugestões aos nossos leitores. Vamos pular para mais um último assunto antes que te enterre em tantas perguntas. E sobre o Mac? Por que os Railers gostam tanto de Macs? :-) (Eu sou um usuário Mac, mas é sempre bom ouvir dos outros).

**Geoffrey** : Eu acho que Ruby tem uma ótima interface de usuário para programadores, e as pessoas que gostam disso algumas vezes gostam de Macs também. Acho que quanto mais popular Ruby se tornar, mais conteúdo e ajuda aparecerá para pessoas usando Windows. Meu pai adotivo era professor, então eu uso equipamentos Apple desde 1983. Sinto que vivo num universo paralelo quando vou a conferências Ruby e vejo tantos Macs.

**AkitaOnRails** : Eu me surpreendi também. E provavelmente todos que foram lá foram pegos de surpresa. Ou não? Isso é uma coisa de Ruby ou isso tudo começou com Rails?

**Geoffrey** : Não tenho certeza. TextMate é definitivamente um fator, e a filosofia sobre o fato de ser leve, não precisar de IDE. E agora que as pessoas podem ter lucro escrevendo código Ruby, isso faz o preço dos Macs não ser mais problema.

**AkitaOnRails** : Jason Fried e DHH certamente ajudaram nesse fator. Parece que a Apple lançará o Rails pré-configurado no Leopard (quando ele finalmente for lançado em outubro).

**Geoffrey** : Também estou interessado na [Integração Ruby com Cocoa](http://rubycocoa.sourceforge.net/doc/) para aqueles escrevendo aplicações Mac de desktop. É maluco que o Java esteja sendo abandonado por isso no Mac, mas Ruby terá a infra-estrutura com o Leopard (eu acho).

**AkitaOnRails** : Você também é um programador Objective C? Ouvi que a integração do Ruby com Cocoa será mais forte no Leopard.

**Geoffrey** : Eu programei um pouco. Experimentei um pouco com OpenGL, alguns anos atrás. Então escrevi um jogo 3D simples em OpenGL e Objective C.

**AkitaOnRails** : Java está sendo abandonado porque a Sun nunca foi bom pra Apple. Linux, Solaris e Windows sempre foram suportados diretamente pela Sun. Acho que tenho lembranças de que a Apple teve que fazer seu próprio JVM e suportá-lo eles mesmos.

**Geoffrey** : Certo, e também era um pouco mais lento que outras implementações. Objective C está ganhando mais gerenciamento de memória automática, se me lembro corretamente. Então talvez integrar Ruby com aplicações de desktop Mac tenham uma chance de se dar bem.

**AkitaOnRails** : Precisamente. Talvez o Open Java torne as coisas mais fáceis em futuras versões para Mac OS X. Quem sabe. E falando de futuro, quais são seus planos para o futuro de seus projetos?

**Geoffrey** : Pretendo trabalhar em tempo integral no PeepCode. Eu não deveria dizer “este verão” porque acho que vocês estão para entrar no inverno.

### PeepCode

[![](/files/peepcode.jpg)](http://www.peepcode.com)

**AkitaOnRails** : Haha, sim, exatamente. Eu, pessoalmente, gosto do PeepCode, mas nunca ouvi falar de ninguém aqui comprando. Você faria versões traduzidas?

**Geoffrey** : Algumas editoras se aproximaram querendo distribuir, mas eu realmente quero permanecer independente o mais tempo possível, e eu acho que tenho algumas grandes idéias que não seriam suportadas tão fortemente. Comecei a falar com alguém sobre traduções em japonês. Recebi umas poucas revisões em português, embora talvez não do Brasil.

**AkitaOnRails** : Uau, conte comigo se um dia tiver planos para uma tradução em português do Brasil ;-)

**Geoffrey** : Grande! Eu gostaria de tentar isso seriamente. Estou começando a ramificar em tópicos que devem ter apelo maior. Lançarei “Javascript com Prototype” semana que vem. Eu definitivamente quero lançar episódios específicos de Rails todo mês, mas espero adicionar outros em uma variedade de tópicos de desenvolvimento web também.

**AkitaOnRails** : Agora, isso é legal. Em vez de focar nos detalhes de Rails, você vai aumentar os assuntos. Eu comprei somente os 3 primeiros screencasts até agora. Já chegou a fazer algo sobre Mongrel ou procedimentos de deployment e otimização?

**Geoffrey** : Eu fiz um sobre Capistrano e também um com Zed Shaw sobre benchmarking com httperf. Tem também um sobre Caching de Página, Action e Fragmentos. Também espero cobrir outros tópicos que são pouco documentados em outros lugares, como escalabilidade com memcached e mogilefs.

**AkitaOnRails** : Eu _TENHO_ que comprar esses. Para que todos saibam: como é o modelo de precificação?

**Geoffrey** : Custa US$ 9 por um episódio (que dura de 45 a 90 minutos, dependendo do tópico). Você pode comprar 5 ou 10 com desconto (US$ 7/cada se comprar 10). Também estou lançando preço de equipe, dessa forma você compra com desconto para uma equipe de desenvolvimento com 5 ou 10 pessoas. E eu estarei dando cupons grátis no meu blog e outros lugares.

**AkitaOnRails** : E o tamanho de cada episódio? Quantos episódios você tem até agora? Você mencionou Zed, então você não está apresentando mais sozinho?

**Geoffrey** : Só tenho 7 episódios até agora. A maioria com mais de uma hora, mas todos tem pelo menos 45 minutos. Eu ia trabalhar com outros autores que fariam um screencast inteiro, mas acabou sendo muito difícil por enquanto. Então estou fazendo mais como uma colaboração onde eu faço o screencast, mas outra pessoa é o editor técnico e me ajuda com o conteúdo. A parte boa disso é que aprendo tanto quando as pessoas que compram os screencasts! Aprendi uma tonelada sobre javascript nas últimas semanas, e estou trabalhando com [Justin Palmer](http://encytemedia.com).

**AkitaOnRails** : Legal. PeepCode é somente o nome do site? É um projeto relacionado à TopFunky? Ou são coisas separadas?

**Geoffrey** : Topfunky é minha empresa, PeepCode é um dos meus produtos. O negócio é apenas eu e minha esposa por enquanto. Espero manter dessa forma o máximo que puder, mas devo contratar alguém temporário ano que vem.

### Uma Mensagem ao Brasil

**AkitaOnRails** : Ok, legal. Bem, poderíamos ir indefinidamente aqui (estou adorando esta conversa). Mas já tenho muito material aqui para trabalhar. Algo mais que gostaria de dizer? Programadores brasileiros, que estão começando suas carreiras, estão muito perdidos sobre o que fazer, que atitudes tomar. Quais seriam suas palavras a eles, como um experiente programador e empresário?

**Geoffrey** : Meu conselho é _[stick it to the man.](http://en.wikipedia.org/wiki/The_Man)_ (_“Resista! Lute!”_) Existem tantas oportunidades para desenvolvedores. Com a internet, todo mundo tem um canal de distribuição. Muitas pessoas acham que não vale a pena começar um negócio a menos que possa vendê-lo ao Google por 4 bilhões de dólares, mas existem tantas idéias lá fora que seriam perfeitas para serem tocadas por negócios pequenos ou um desenvolvedor sozinho. Então você pode usar sua renda para fundar sua próxima idéia de um bilhão de dólares. ;-)

**AkitaOnRails** : Sim, vá uma passo de cada vez. [Kevin Rose](http://www.businessweek.com/magazine/content/06_33/b3997001.htm) é uma má influência para todos esses garotos. :-)

**Geoffrey** : Exatamente. E você não precisa bater para fora os outros concorrentes do mercado. Existem muitos nichos pequenos que podem ser suportados por uma pessoa se a idéia de negócio é boa.

[![](/files/next-small-thing-1.jpg)](http://valleywag.com/tech/jason-fried/jason-fried-expands-his-little-thing-189142.php)

**AkitaOnRails** : É o lema de Jason Fried: [fazer menos em vez de fazer mais](http://www.37signals.com/svn/archives2/less_as_a_competitive_advantage_my_10_minutes_at_web_20.php).

**Geoffrey** : Certo. Existem muitas pessoas de negócios com grandes idéias, mas eles não conseguem implementá-las. Como um desenvolvedor, você tem essa habilidade, mas precisa de idéias. Não estou certo qual dos dois é mais difícil!

**AkitaOnRails** : Ok, Geoffrey, foi um grande prazer ter essa chance de falar com você. Espero que eu não o tenha entediado porque quero continuar essa conversa em outra ocasião.

**Geoffrey** : Foi bom, obrigado! Eu adoraria ir ao Brasil algum dia. Estarei lá se você fizer uma conferência Rails!

**AkitaOnRails** : Ha! Pode apostar, eu te convido! Apenas preciso encontrar um patrocinador :-)

**Geoffrey** : Algumas das melhores comidas que experimentei foram num restaurante brasileiro de um famoso skatista Bob Burnquist.

**AkitaOnRails** : Aí em Seattle?

**Geoffrey** : Não, em Los Angeles. O restaurante não está mais lá, infelizmente. De qualquer forma, obrigado pela entrevista! Foi ótimo conversar com você.

