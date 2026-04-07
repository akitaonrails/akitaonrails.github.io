---
title: Conversando com Blaine Cook (Twitter)
date: '2008-06-17T00:29:00-03:00'
slug: conversando-com-blaine-cook-twitter
translationKey: chatting-blaine-cook
tags:
- interview
- traduzido
aliases:
- /2008/06/17/chatting-with-blaine-cook-twitter/
draft: false
---

Ruby on Rails é **grande**. Twitter é **grande**. E por isso eles se tornaram alvos fáceis para a mídia e os pundits frustrados em busca de mais pageviews. Blaine Cook foi um dos desenvolvedores do Twitter e gentilmente concordou em participar de uma das minhas entrevistas. E, claro, ele vai responder à pergunta: _"Rails Escala?"_

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/2299866775_385f7af555.jpg)](http://www.flickr.com/photos/hyku/2299866775/)


**AkitaOnRails:** Então, deixa eu explicar primeiro que meu principal objetivo ao entrevistar pessoas de alto perfil como você é trazer informação de qualidade para nossa crescente comunidade Rails no Brasil. É sempre bom perguntar sobre seu background, como você chegou ao Rails e qual foi sua experiência com ele.

**Blaine Cook:** Comecei com Rails num projeto pessoal pequeno em dezembro de 2004, depois que Evan Henshaw-Plath ([rabble](http://2008.xtech.org/public/schedule/speaker/283)) ficou muito animado com Ruby e Rails.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/43021932_545efed570.jpg)](http://www.flickr.com/photos/foolswisdom/43021932/)

Logo depois, comecei a trabalhar no [Odeo](http://www.odeo.com). Gosto muito de Rails e tive uma experiência excelente com ele. Construir web apps costumava ser um parto (ou seja, uma chatice) porque você acabava reconstruindo as mesmas peças repetidamente.

O Rails resolveu isso. Já existiam frameworks antes, mas o Rails reformulou a questão de forma humana, e é isso que vemos em todos os outros frameworks que vieram depois.

**AkitaOnRails:** E o que você fazia antes do Rails? Java Enterprise? Coisas Microsoft? Outros projetos open source?

**Blaine Cook:** Fazia principalmente PHP e Perl, no contexto de projetos open source e trabalhos de consultoria.

**AkitaOnRails:** Então **Odeo** e **Twitter** são seus maiores projetos em Rails? Antes de entrar no Twitter, pode nos contar como foi seu trabalho no Odeo?

**Blaine Cook:** Claro — o Odeo foi OK. O grande problema lá era foco. O podcasting ainda não tinha provado seu valor (e a forma que o podcasting assumiu hoje é bem diferente do que as pessoas imaginavam em 2004/2005), então era difícil ganhar tração com o produto.

Construímos coisas incríveis, muitas das quais estão só agora virando produtos. Coisas como mixagem multilista na web, mensagens em vídeo (como o [seesmic](http://www.seesmic.com/)), etc.

**AkitaOnRails:** É um assunto paralelo interessante: podcasting. Faço um [podcast brasileiro de Rails](http://podcast.rubyonrails.pro.br/) com um amigo e hoje em dia as pessoas estão muito acostumadas com podcasts. Qual era a visão 3, 4 anos atrás sobre o que o podcasting se tornaria?

**Blaine Cook:** Acho que é razoavelmente parecida, mas parece que a maior tração (ou seja, ouvintes) do podcasting veio de programas de rádio que buscavam distribuição mais ampla.

Havia um sentimento de que o podcasting seria muito mais popular entre blogueiros em geral. Todo mundo ia ter um podcast.

Mas na realidade é um meio com muito menos publicadores do que o blog.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/2303816926_beafddbb5c.jpg)](http://www.flickr.com/photos/jolieani/2303816926/)

**AkitaOnRails:** Você ajudou a fundar o Odeo, ou seja, você foi um dos criadores? Ou foi contratado para resolver o problema deles? E por que você saiu do Odeo?

**Blaine Cook:** Não — entrei no Odeo alguns meses depois que o desenvolvimento tinha começado. Na verdade nunca saí formalmente do Odeo — o produto foi vendido, e a empresa continuou como Obvious. O Twitter era um projeto paralelo dentro do Odeo.

**AkitaOnRails:** Ok, e o Twitter é enorme hoje. Você pode nos dar uma ideia de como surgiu toda a ideia do _"O que você está fazendo"_? Na época você achava que se tornaria um sucesso tão grande?

**Blaine Cook:** O Twitter começou como um projeto paralelo no Odeo, mas na verdade era uma ideia que o [Jack](http://www.stonetemple.com/articles/interview-jack-dorsey.shtml) já vinha desenvolvendo de diversas formas há vários anos.

Ele e **Noah Glass** (o fundador do Odeo) criaram uma subempresa dentro do Odeo para trabalhar nisso, na primavera de 2006. Inicialmente, eu detestei a ideia, principalmente porque era para ser só via SMS.

Olhando para trás, é difícil dizer, mas na época eu diria que o Twitter tinha poucas chances de dar certo. Acho que o sucesso teve muito a ver com sorte e abertura.

**AkitaOnRails:** Então, talvez um dos maiores motivos para o sucesso do Twitter fosse também seu calcanhar de Aquiles? Ou seja, o acesso via API que ele tem hoje?

**Blaine Cook:** Sim, com certeza.

**AkitaOnRails:** Entrando no assunto espinhoso: é bastante óbvio que o [Michael Arrington](http://www.techcrunch.com/2008/04/23/amateur-hour-over-at-twitter/) não gosta do Twitter. E especialmente parece que ele tem algo [contra você](http://www.alleyinsider.com/2008/4/lead_architect_blaine_cook_out_at_twitter) pessoalmente, pelo menos considerando o tom dos artigos dele no Techcrunch. Você pode comentar isso?

**Blaine Cook:** Não muito — não sei por que ele tem esse ranço. É levemente irritante, mas no fim das contas faz o Techcrunch parecer mais uma fofoqueira do que um veículo de notícias respeitável. Perda dele.

**AkitaOnRails:** E não só isso: parece que parte da mídia de tecnologia quer correlacionar a instabilidade do Twitter com o fato de que parte do front-end é movido a Ruby on Rails, daí a discussão _"Rails Escala?"_. Como Railer, me parece óbvio que relacionar Rails e instabilidade gera muitos pageviews. Você acha que é isso mesmo?

**Blaine Cook:** Acho que é pelo menos parte disso. Pageviews são uma atração enorme, obviamente.

**AkitaOnRails:** Talvez fosse útil alguém como você explicar para nossa audiência a diferença entre **'performance'** e **'escalabilidade'**, já que a maioria das pessoas parece não saber a diferença entre as duas.

**Blaine Cook:** Performance e escalabilidade são coisas muito diferentes. Performance é como o limite de velocidade — é uma questão de quão rápido você vai do ponto A ao ponto B. Nesse caso, estamos falando de quão rápido você consegue renderizar e entregar uma página ao usuário.

Escalabilidade é uma questão de quantos usuários você consegue atender. Estradas, por natureza, não escalam — quando estão cheias, você tem engarrafamento. Em arquiteturas web, o que buscamos são sistemas que expandem (geralmente adicionando mais hardware) para lidar com mais tráfego.

Obviamente estão relacionadas — se você tem um engarrafamento, o limite de velocidade efetivo é menor que o teórico. Mas aumentar o limite de velocidade não resolve engarrafamentos.

Há várias formas de diminuir o congestionamento — adicionar mais faixas na estrada, incentivar as pessoas a usar transporte público, ou melhor ainda incentivá-las a trabalhar mais perto de casa.

Da mesma forma, existem muitas técnicas para tornar sites mais escaláveis, e a maioria delas não envolve tornar as coisas muito mais "rápidas".

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/2476619970_af72edc5ef.jpg)](http://www.flickr.com/photos/gavinbell/2476619970/)

**AkitaOnRails:** Ótima explicação. O Twitter se envolveu em várias controvérsias desde o ano passado, e acho que você não estava envolvido na maioria delas, mas talvez possa lançar luz sobre essas questões já que nem todo mundo acompanha todas as notícias. A primeira foi aquela entrevista em que [Alex Payne](http://www.radicalbehavior.com/5-question-interview-with-twitter-developer-alex-payne/) reclamou que o Rails não suportava múltiplos bancos de dados. **David Hansson** respondeu irritado. Depois o [Dr. Nic](http://drnicwilliams.com/2007/04/12/magic-multi-connections-a-facility-in-rails-to-talk-to-more-than-one-database-at-a-time/) iniciou uma solução. Você pode explicar esse assunto para nossa audiência?

**Blaine Cook:** Claro — é verdade que o Rails não suporta múltiplos bancos de dados out of the box, mas isso é facilmente resolvido. Acho que a entrevista com o Alex não entrou nos detalhes e deturpou nossos desafios.

Se fosse apenas uma questão de suportar múltiplas conexões com banco de dados, isso seria facilmente resolvido. O problema real era muito mais complexo e tinha a ver com sharding customizado para nosso dataset específico.

**Eran Hammer-Lahav** tem uma série excelente (partes [1](http://www.hueniverse.com/hueniverse/2008/03/on-scaling-a-mi.html), [2](http://www.hueniverse.com/hueniverse/2008/03/scaling-a-micro.html), [3](http://www.hueniverse.com/hueniverse/2008/04/scaling-a-micro.html)) em que ele descreve alguns dos desafios associados a construir sites de microblogging para escalar.

Nada do que ele descreve no artigo é difícil de fazer com Rails. De fato, acho que o David (Hansson) está errado quando diz que Rails não é flexível — ele é muito mais flexível do que a maioria dos outros frameworks.

**AkitaOnRails:** Certo. E a outra controvérsia recente é, claro, por causa do [TechCrunch](http://www.techcrunch.com/2008/05/31/hey-twitter-i-have-a-few-questions-too/) de novo, onde dizem que o Twitter tem apenas meia dúzia de servidores e é por isso que cai com frequência. Você pode descrever grosseiramente como é a arquitetura de hardware do Twitter?

**Blaine Cook:** O Twitter tem muitos servidores, definitivamente mais do que meia dúzia. Não posso entrar em mais detalhes sobre o hardware, mas posso dizer que o back-end é um sistema assíncrono baseado em mensagens. O [Starling](http://rubyforge.org/projects/starling/) (o servidor de filas que eu escrevi e que o Twitter lançou em janeiro) é o mecanismo usado para passar mensagens entre processos.

O maior problema é que o Twitter lida com muitas requisições de API caras devido ao polling frequente necessário para manter os tweets dos seus amigos atualizados. O grande desafio era encontrar uma forma barata de tornar essas requisições caras mais baratas.

Usamos memcache extensivamente e tínhamos um monte de caching em operação há mais de um ano, mas não era suficiente.

**AkitaOnRails:** No ano passado, Alex e Britt falaram na RailsConf sobre [Scaling Rails](http://www.slideshare.net/eraz/scaling-rails-presentation/) e parecia que o problema do Twitter logo acabaria. Era principalmente sobre caching e otimizações do tipo, e uma das mensagens principais era _"faça cache de tudo"_. Vi você falando este ano sobre database sharding e como é diferente arquitetar para 1 mil pessoas e para 1 milhão e que não dá pra prever o que fazer antes. O Twitter ainda cai às vezes, então o que mudou entre o ano passado e agora em relação a Scaling Rails?

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/2329021397_3dde02123a.jpg)](http://www.flickr.com/photos/x180/2329021397/)

**Blaine Cook:** Sim — sabíamos há muito tempo que o sharding de banco de dados era importante, mas por várias razões não conseguimos avançar nisso.

O negócio com sharding é que, enquanto alguém não aparecer com algo parecido com o que o Google tem (e não me refiro ao Bigtable), a forma que sua aplicação assume antes do sharding é muito diferente da forma depois. O sharding torna certas coisas mais difíceis e é geralmente caro.

Quando as pessoas falam em "sharding" ou "denormalização", o que querem dizer é _"duplicar dados de formas específicas para tornar certas consultas mais rápidas."_

Isso sempre envolve custo adicional. Se você está construindo um app novo que provavelmente nunca verá centenas de milhares de usuários — ou se você não sabe se verá ou não — geralmente não vale investir muito dinheiro em hardware e tempo de engenharia para construir uma arquitetura "escalável".

A realidade é que a maioria dos desenvolvedores conhece SQL e consegue construir aplicações CGI com PHP, Rails ou o que for, mas relativamente poucos têm experiência em pegar esses datasets normalizados e diretos e quebrá-los em sistemas sharded muito mais complexos.

**AkitaOnRails:** Claro, às vezes as pessoas acham que vão construir o "próximo" Twitter. [Entrevistei o Ezra](/2008/6/5/railsconf-2008-brazil-rails-podcast-special-edition), da Engine Yard, na RailsConf e ele reconhece que o grafo de amigos-de-amigos é um problema tão complexo que quem resolver vai ganhar muito dinheiro. Ou seja, designs SQL tradicionais não funcionam sempre, né?

**Blaine Cook:** Claro — a questão é: o que mais você vai usar? O Google tem uma arquitetura que permite gastar quantidades infinitas de dinheiro para construir listas denormalizadas de tudo e acessar essas listas rapidamente. Há vários projetos — HBase, Hypertable, CouchDB e muitos outros — que visam resolver esses problemas, mas nenhum deles está pronto para uso em produção.

A realidade é que 10 anos atrás as pessoas construíam aplicações web com tcsh, e agora temos ferramentas melhores.

**AkitaOnRails:** Onde o Twitter está hospedado? Por alguma razão vi a Engine Yard falando muito sobre questões de escalabilidade durante toda a RailsConf deste ano. Você acha que o meme "Rails não escala" está deixando os Railers preocupados com perspectivas futuras? Mesmo que não devesse assustar tanto assim, já que temos sites de alto tráfego como Scribd e YellowPages no topo da lista — embora as arquiteturas sejam completamente diferentes, é claro. O que você acha?

**Blaine Cook:** Não tenho certeza, mas acho que o Twitter tem mais tráfego que o YellowPages ou Scribd — a API é realmente poderosa.

**AkitaOnRails:** Ah, entendo. O Alexa e outros não contabilizam requisições de API, né?

**Blaine Cook:** O Twitter está hospedado na NTT/Verio. Acho que houve um post no blog sobre isso em fevereiro. Certo, o Alexa não contabiliza tráfego de API/SMS/XMPP.

Quanto à perspectiva de que Rails não escala — acho que é um efeito colateral infeliz dos problemas do Twitter, com certeza, e acho que algumas pessoas se preocupam com isso. Para contextualizar, porém, o Friendster foi escrito em Java inicialmente e migrou para PHP. O Myspace foi escrito em ColdFusion e migrou para ASP.NET.

Quando as pessoas têm problemas ao escalar sites frequentemente pensam que a linguagem é o problema, mas acho que raramente é o caso.

Ruby é mais lento que PHP ou Java (dependendo de qual framework você usa) ou, bem, a maioria das linguagens, mas está ficando mais rápido. E "mais lento" se traduz apenas em custo adicional.

**AkitaOnRails:** O que me lembra da última controvérsia: o [Twitter abandonando Rails](http://www.techcrunch.com/2008/05/01/twitter-said-to-be-abandoning-ruby-on-rails/). O fato é que você já tem um ambiente misto, certo? A maioria dos pundits acha que "sabe" resolver os problemas do Twitter, embora não façam ideia do que estão falando. Alguns culpam o Rails, outros culpam o MySQL (_"vá para Oracle"_, dizem). Você pode elaborar sobre isso?

**Blaine Cook:** Certo — a maior parte do nosso desenvolvimento era em Ruby/Rails, mas havia código em outras linguagens. Python, Java, e alguns experimentos com Scala. O que ignora o fato de que rodávamos partes significativas da nossa infraestrutura com código não-Ruby — Apache, Mongrel, MySQL, memcached, ejabberd, etc., são todas aplicações excelentes e críticas para construir sites escaláveis.

O Oracle definitivamente tem algumas dessas coisas resolvidas, mas é muito mais fácil contratar para MySQL, e as taxas de licenciamento e suporte do Oracle não são de se desprezar.

Construir sua arquitetura em torno de um sistema que só vai ficar mais barato com o tempo, em vez de mais caro, é sempre uma boa ideia.

**AkitaOnRails:** E tenho que perguntar: você pode divulgar alguns números significativos, ou ordens de grandeza, como tweets por dia, tempo médio de inatividade, ou algo assim, só para termos uma ideia do tamanho dos problemas do Twitter? Vindo de alguém que de fato teve que lidar com uma situação tão enorme — que a maioria das pessoas provavelmente nunca vai enfrentar —, o que você diria serem as melhores funcionalidades do Ruby/Rails para você?

**Blaine Cook:** Infelizmente, não — há muitas estimativas na web, mais notavelmente o compete e os números de fan-out do Dave Winer.

Acho que o melhor recurso do Ruby é que é **divertido de desenvolver** com ele. E nunca deixa de ser divertido. É uma linguagem expressiva e poderosa. O Rails torna o desenvolvimento web indolor, comparado a fazer tudo na mão. Isso é algo que não deveria ser subestimado, ou cujo valor deveria ser esquecido.

Além disso, são muito flexíveis. Precisávamos construir uma ferramenta de denormalização, por exemplo, e fazer isso em Ruby era tão fácil/difícil quanto em qualquer outra linguagem, exceto na hora de integrá-la ao restante do sistema — sem busca e substituição, sem subclasses nem nada. É só ligar e funciona.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/440202833_77152b8080.jpg)](http://www.flickr.com/photos/niallkennedy/440202833/)

**AkitaOnRails:** Por fim, você pode nos contar por que saiu do Twitter? Quais são seus novos projetos? O Twitter sobreviveu à WWDC da semana passada, o que é muito, considerando que eventos tão grandes costumavam derrubá-lo no passado.

**Blaine Cook:** Estou me mudando para o Reino Unido, e o Twitter entrou/está entrando numa fase em que o foco principal é confiabilidade. Quando saí, a esperança era que o sistema estava estabilizado e o roadmap estava claro para colocá-los em melhor posição. Na época, eles tinham tido um período prolongado de uptime ininterrupto e haviam sobrevivido com louvor à [SXSW](http://sxsw.com/). Infelizmente não durou, mas parece que as coisas estão melhores de novo.

Ainda não estou pronto para revelar o que vem a seguir, mas tenho várias coisas empolgantes acontecendo. Vou continuar mantendo o Starling e o [xmpp4r-simple](http://code.google.com/p/xmpp4r-simple/), e ainda estou ativo no grupo de trabalho da especificação OAuth.

**AkitaOnRails:** No fim das contas, o Twitter já se tornou quase parte da nossa cultura (pelo menos no nosso mundo tech). As pessoas reclamam quando cai porque agora dependem tanto dele. Pessoas como Michael Arrington, Robert Scoble, Leo Laporte vivem reclamando, dizendo que vão migrar para Pownce ou Jaiku, mas continuam lá. Você tem algum palpite de por que os usuários do Twitter são tão fiéis?

**Blaine Cook:** Não! Acho que o rico ecossistema de ferramentas que você pode usar para interagir com o Twitter nos seus próprios termos é uma grande parte disso. Muitos usuários têm um investimento pessoal e querem ver esse investimento retornar.

**AkitaOnRails:** Ok, acho que cobrimos tudo. Alguma consideração final para nossa jovem comunidade Rails brasileira?

**Blaine Cook:** A web é notavelmente jovem, e há muito espaço para acontecerem coisas incríveis. Fico sempre animado ao ver o que as pessoas estão construindo e o que é possível com essa coisa toda chamada Internet. Com todos os comentários mesquinhos e desinformados do Arrington, acho que sites como Techcrunch, [Mashable](http://www.mashable.com) e [Silicon Alley Insider](http://www.alleyinsider.com) são interessantes porque apresentam um fluxo interminável de coisas incríveis que as pessoas estão construindo na web.

O foco financeiro é infeliz, já que há muitos apps que sobrevivem e proporcionam renda para seus criadores sem precisar escalar para proporções galácticas.

O ponto principal é que há muito a fazer, e não se preocupe com escalabilidade ou modelo de negócios ou qualquer coisa — a menos que você seja apaixonado pelo que está fazendo, nada disso importa.

Se você é apaixonado pelo que está fazendo, há uma boa chance de você descobrir os detalhes no caminho.

**AkitaOnRails:** Fantástico! Muito obrigado pela sua gentileza, tenho certeza que minha audiência vai adorar. E só para você saber: nós, brasileiros, **tweetamos** muito sim! :-) Valeu!

**Blaine Cook:** Que ótimo! Não foi nada, obrigado por ser um ótimo entrevistador.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/17/2300104137_96c83ac13d.jpg)](http://www.flickr.com/photos/briandewitt/2300104137/)
