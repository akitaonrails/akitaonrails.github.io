---
title: "[Off-Topic] Software Livre: Exercício de CAPITALISMO"
date: '2016-04-22T15:30:00-03:00'
slug: off-topic-software-livre-exercicio-de-capitalismo
translationKey: off-topic-software-livre-exercicio-de-capitalismo
description: "Software livre é propriedade privada distribuída sob licença, com trocas voluntárias e competição sem regulador. Por isso projetos morrem, forks nascem e ninguém consegue decretar sucesso."
tags:
- open-source
- economia
- filosofia
- off-topic
draft: false
---

Uma frase do [meu artigo anterior](http://www.akitaonrails.com/2016/04/20/off-topic-se-voce-precisa-de-validacao-provavelmente-esta-errado) causou estranheza em algumas pessoas:

> "A base disso é o mundo open source: a maior experiência capitalista do mundo do software e um exemplo vivo para todos do que é um Mercado Livre Laissez-faire. O melhor lugar para manter e melhorar commodities de tecnologia."

A estranheza vem da palavra "free". Por causa dos princípios de liberdade do Free Software, muita gente associa o mundo do código aberto a uma grande experiência "socialista". Minha tese é o contrário: software livre é a experiência mais capitalista que existe no software. Nenhum governo regula, nenhuma agência protege projeto ruim, toda troca é voluntária e a competição decide quem sobrevive. Um mercado assim não existe em nenhum setor da economia real; o período histórico mais próximo dele foi o fim do século XIX nos EUA, antes do Federal Reserve e do imposto de renda federal.

Matt Asay escreveu na C|NET, em ["Código Aberto: É sobre capitalismo, não brindes gratuitos"](http://www.cnet.com/news/open-source-its-about-capitalism-not-freebies/):

> "O segredo é usar software de código aberto como um meio para um fim, e não o fim em si mesmo. Código aberto é um meio de distribuição barata, uma maneira de colocar software nas mãos de potenciais compradores por pouco ou nenhum custo. É uma maneira de tornar a experiência de software social e menos arriscada, porque os usuários podem experimentar antes de comprar e porque eles podem customizar (ou pagar alguém para customizar) o software para suas necessidades por um custo menor do que software proprietário."

E foi mais direto ainda em ["Desculpe, socialistas: Código Aberto é um jogo capitalista"](http://web.archive.org/web/20211023100641/https://www.cnet.com/news/sorry-socialists-open-source-is-a-capitalists-game/):

> "[Sarah] Grey escreve que 'existem alternativas ao capitalismo'. Ela está certa. Infelizmente, código aberto não é uma delas. Código aberto é a essência do Livre Mercado do Capitalismo."

### Definições, para ninguém brigar com espantalho

Antes de seguir, os termos que estou usando. Capitalismo é propriedade privada dos meios de produção, com trocas voluntárias entre os donos dessa propriedade. Livre Mercado é a condução dessas trocas sem coerção e sem regulador: oferta, procura e preços ficam nas mãos dos participantes.

Socialismo, no sentido clássico, é propriedade estatal ou coletiva dos meios de produção. Saúde pública e ensino gratuito num país de economia de mercado são políticas de bem-estar, e não socialismo. A crítica deste texto é ao modelo em que o Estado é o dono da produção.

Com essas definições, defender o socialismo clássico e defender a liberdade individual são posições opostas: o primeiro exige subordinar a propriedade e as escolhas de cada um a uma entidade central.

### Software livre é propriedade privada sob licença

Código aberto não é domínio público. Todo software tem dono: o copyright pertence aos autores, e usar, copiar ou modificar esse código só é possível porque o dono concedeu uma licença. Sem licença, ninguém tem direito algum sobre código alheio, como Jeff Atwood lembrou em ["Escolha uma Licença, qualquer Licença"](http://blog.codinghorror.com/pick-a-license-any-license/):

> "Porque eu não indiquei explicitamente uma licença, eu declarei implicitamente um copyright sem explicar como outros poderiam usar meu código. Já que o código está sem licença, eu poderia teoricamente forçar o copyright a qualquer momento e demandar que as pessoas parem de usá-lo. Desenvolvedores experientes não tocam em código sem licença, porque não têm direito legal para isso."

Existe um teste prático para essa propriedade: o dono pode retirar o código da circulação quando quiser. Em março de 2016, Azer Koçulu despublicou seus pacotes do npm, incluindo o minúsculo left-pad, depois de uma disputa de nome com o aplicativo Kik. Milhares de builds quebraram no mesmo dia, como [a Ars Technica reportou](http://arstechnica.com/information-technology/2016/03/rage-quit-coder-unpublished-17-lines-of-javascript-and-broke-the-internet/). O código-fonte continuava no GitHub; o que ele removeu foi a distribuição no registro.

Concordar ou não com o Koçulu é irrelevante. O pacote era propriedade dele, e a decisão de remover era dele. O mais interessante veio depois: ninguém foi preso, nenhum regulador interveio. O npm restaurou o pacote quebrado e mudou sua [política de unpublish](http://blog.npmjs.org/post/141905368000/changes-to-npms-unpublish-policy). O mercado absorveu o choque e criou anticorpos, sem tirar de ninguém o direito de sair.

A comunidade Ruby viveu uma versão menor disso em 2009, quando _why apagou seus projetos e desapareceu, [como contei aqui](http://www.akitaonrails.com/2012/09/07/why-dramas-do-ruby-e-dinamitando-courtlandt/).

Quando o desacordo é interno, o mecanismo de saída é o fork: quem discorda clona o projeto e compete com o original. Foi o que aconteceu com o io.js, que nasceu como fork do Node.js em 2014 e se fundiu de volta em 2015, sob a recém-criada Node.js Foundation, quando a negociação fez sentido. A história tem vários forks que prosperaram: WebKit a partir do KHTML, LibreOffice a partir do OpenOffice.org, MariaDB a partir do MySQL, X.Org a partir do XFree86. E há derivados que ficaram maiores que a origem, como o Ubuntu a partir do Debian.

Fork é voto com os pés. Custa caro, porque exige manter um projeto inteiro, e é por isso que só prospera quando a motivação é real.

### Competição implica o direito de fracassar

Num mercado sem regulador, ninguém mantém projeto ruim vivo artificialmente. Para cada PostgreSQL que existe, dezenas de bancos de dados tentaram e morreram. Para cada distro Linux relevante, centenas viraram nota de rodapé. Isso é sinal de saúde: a seleção está funcionando.

A justiça desse processo é cega. O código não carrega a biografia do autor, e o mercado não distribui medalha por boas intenções. Um projeto sobrevive se convence usuários e colaboradores de seu mérito técnico, e morre se não convence.

Abrir o código, aliás, não salva ninguém. A Nokia concluiu a abertura do código do Symbian em 2010, quando a plataforma já perdia terreno para iPhone e Android. O gesto não reverteu nada: muito pouco, muito tarde.

Eu comparei esse processo à seleção natural num [screencast antigo](http://www.akitaonrails.com/2010/07/01/screencast-entenda-software-da-maneira-correta). O software que se adapta melhor às demandas do ambiente é o que mais se reproduz, na forma de usuários e contribuidores. O cemitério de projetos mortos prova que a seleção existe e funciona.

E a paisagem muda o tempo todo. O Apache HTTP cedeu espaço ao NGINX. O Firefox perdeu fatia enorme para o Chrome. O Perl cedeu para Python e para linguagens mais novas como Go. O MySQL perdeu prestígio entre desenvolvedores para o PostgreSQL, enfrentou a onda NoSQL e ainda ganhou um fork competidor, o MariaDB, depois da compra pela Oracle. Nenhum desses projetos tinha direito adquirido ao trono.

### O programador paga para participar

O mercado de software livre tem uma inversão curiosa de valores. Numa empresa, o programador recebe dinheiro para escrever código proprietário. Num projeto livre conhecido, é o programador quem "paga", com seu tempo e sua capacidade, para ter código aceito. Em troca ele recebe reputação, aprendizado, portfólio e, sim, um pouco de vaidade. É uma troca voluntária com benefício para os dois lados, como qualquer outra.

"Preço", aqui, não se mede só em dinheiro. Valor é qualquer coisa com oferta e procura, e quem define o preço é a competição. A moeda corrente desse mercado é a competência técnica demonstrada em público.

Isso tem uma consequência dura: convencer os outros faz parte do jogo. Se a sua ideia tem valor e mesmo assim ninguém adere, a explicação mais provável está na ideia ou na forma como você a apresenta, e não na burrice da plateia. Culpar a plateia é o jeito mais rápido de desvalorizar a própria causa.

### O paradoxo do software livre "socialista"

Imagine o modelo oposto: o mundo do software sob o socialismo clássico, com a produção controlada por uma entidade central.

Sem propriedade individual sobre os projetos, acaba a competição. Projeto ruim que atenda à agenda de quem controla se mantém vivo, mesmo que exista alternativa tecnicamente superior. A escolha sai das mãos de quem usa e vai para as mãos de quem controla. Não haveria acidentes como o left-pad, e o preço disso seria um catálogo imenso de software sucateado que ninguém quer usar.

Sem o benefício individual da troca, acaba o voluntariado. Nenhum programador competente doaria suas melhores horas sem reputação, aprendizado ou liberdade em troca. E se a contribuição virar cota obrigatória decretada em nome do "bem social", todos farão o mínimo para cumprir a cota. A produção soviética funcionou assim em praticamente todos os setores, com os resultados que conhecemos.

Sem competição, acaba a inovação. Inovação nasce de uma vontade individual de resolver o próprio problema do próprio jeito. Eric Raymond abriu ["A Catedral e o Bazar"](http://www.catb.org/~esr/writings/cathedral-bazaar/cathedral-bazaar/) com essa ideia:

> "Todo bom trabalho de software começa coçando uma coceira pessoal de um desenvolvedor."

Inovação também é transgressora, porque torna profissões inteiras obsoletas. As agências de viagem quase sumiram quando comprar passagem pela internet ficou trivial. As locadoras de vídeo morreram com o streaming. O Uber apertou os taxistas, o Airbnb apertou os hotéis. Quem ficou preso ao modelo anterior sofreu, e o mundo seguiu em frente.

Em software foi igual. O pessoal do GNU Hurd não comemorou quando o Linux explodiu. A Nokia não achou graça no Android. O MySQL não torce pelo PostgreSQL. Quem resiste à dinâmica do mercado fica para trás. Duro, e absolutamente justo.

### A distopia do monopólio protegido

Um software proprietário pode ser bom ou ruim; o problema aparece quando ele vira monopólio protegido. A Microsoft dos anos 90 era um monopólio de fato. Podemos discutir se o julgamento do Departamento de Justiça foi justo, mas o golpe decisivo no monopólio veio do mercado: o software livre, com GNU e Linux, e depois a internet comercial, que tirou do Windows o monopólio da plataforma.

Imagine um futuro alternativo em que a Microsoft convence o governo americano de que o Windows é essencial à segurança nacional e merece proteção permanente. Tudo teria parado. Até hoje usaríamos um Pentium de 100 MHz rodando um derivado de Windows 98, com internet discada, porque "ninguém precisa de mais que isso".

É essa a lógica de quem entrega as decisões do mercado a uma entidade central: não crie e-mail, vai prejudicar os carteiros; não crie sites, vai prejudicar as gráficas; não crie software livre, vai prejudicar os programadores do governo. Todo ditador usa o mesmo discurso, "para o bem da população", e todo discurso de "para o bem da população, não importam os meios" termina no mesmo lugar.

### Tirania e o fim do software livre

O pior caso possível para um projeto livre começa assim. Um desenvolvedor cria um software para resolver um problema e abre o código. Por vinte anos, centenas de pessoas usam e contribuem.

Então surge uma causa, qualquer uma, e alguém se autonomeia representante dela. Por pressão social e propaganda, os mantenedores viram párias. A mídia especializada amplifica, porque controvérsia atrai leitor. O código deixa de ser o assunto: o que passa a valer é a opinião pessoal, a aparência e o passado de cada colaborador.

A partir daí, participar do projeto vira um risco. Ninguém recebe mais valor por contribuir; só recebe exposição. Um a um, os que realmente escreviam código vão embora, e o projeto definha. É uma forma perversa de tomar uma propriedade e destruir seu valor sem confiscar nada formalmente.

Ayn Rand dramatizou esse mecanismo no julgamento de Howard Roark, em "A Nascente", e [escrevi sobre isso em 2011](http://www.akitaonrails.com/2011/02/04/off-topic-the-fountainhead-defesa-de-howard-roark):

> "Eu vim aqui dizer que eu não reconheço o direito de qualquer um a um minuto da minha vida, ou a qualquer parte da minha energia, nem a qualquer conquista minha, não importa quem clame por isso!"

Esse é o aviso. Uma camada política sobre um projeto livre destrói o mercado que sustentava o projeto.

### Conclusão

Nada disso condena quem contribui por motivação social. Quem troca seu código pela sensação de estar ajudando faz uma troca voluntária como qualquer outra, e isso fora do software tem nome: doação e trabalho voluntário. O problema começa quando alguém decide que a propriedade alheia deve servir à causa que ele escolheu.

Resolver os problemas do mundo é muito mais difícil do que discutir sobre eles. Bill Gates deu esse recado em 2000, respondendo ao hype de que PCs acabariam com a pobreza:

> "Ótimo, visite os centros da Infosys em Bangalore, mas saia do oásis e vá três milhas adiante, atrás do cara que vive sem privada, sem água encanada... O mundo não é plano, e PCs não estão, na hierarquia das necessidades humanas, entre as cinco primeiras posições."

Programadores, de qualquer classe social, têm internet e recursos de sobra para passar o dia em redes sociais discutindo como salvar o mundo. Quem trabalha de verdade nesses problemas está fora desse circuito, [executando em vez de falar](https://en.wikipedia.org/wiki/Computer_technology_for_developing_areas).

Termino com um caso real que me relataram, sem nomes:

> A: Puxa, ninguém dá chance à minha [minoria].
>
> B: Por que você não me ajuda a resolver estes problemas neste projeto open source? Daí você pode palestrar sobre isso.
>
> (A some. B espera, cansa, e chama C, que resolve os problemas e ganha o espaço de palestrar.)
>
> A: Tá vendo, B? Você é parte dos opressores que não dão espaço pra gente como eu, e preferiu dar a oportunidade pro C.

E uma nota pessoal para encerrar. Me taxam de "seguidor de Ayn Rand", e estão enganados: Rand apenas pôs por escrito, antes de mim, o que eu já pensava e praticava. O mesmo vale para Bastiat, Friedman, Hayek ou Menger. São referências, e referências não são donos. Julgar uma ideia pelo autor em vez de julgar o argumento pelo mérito é a definição de [ad hominem](https://pt.wikipedia.org/wiki/Argumento_ad_hominem), e eu não respondo bem a falácias.
