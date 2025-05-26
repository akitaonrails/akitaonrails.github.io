---
title: 'RailsConf 2008: A Controvérsia MagLev'
date: '2008-06-04T12:13:00-03:00'
slug: railsconf-2008-a-controv-rsia-maglev
tags:
- railsconf2008
- smalltalk
draft: false
---

De longe, o anúncio mais **controverso** da RailsConf 2008 foi sobre o [MagLev](http://www.avibryant.com/2008/06/maglev-recap.html).

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC05953.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05953&bgcolor=black)

Em resumo, **Avi Bryant** foi convidado pela GemStone para levar adiante a idéia que ele próprio previu na RailsConf do [ano passado](http://gilesbowkett.blogspot.com/2007/05/avi-bryants-railsconf-keynote-ruby-can.html) dizendo:

> Eu sou do futuro, eu sei como esta história termina. Todas as pessoas dizendo que não se pode implementar uma máquina virtual rápida para Ruby estão erradas. Essa máquina já existe hoje, é chamada [GemStone](http://maglev.gemstone.com/) e ela certamente poderia ser adaptada para Ruby. Ela roda Smalltalk, e Ruby essencialmente _é_ Smalltalk, então adaptá-la para rodar Ruby está absolutamente dentro do possível.


Não só está dentro do possível, como efetivamente ela _é_ possível. A apresentação foi dividida entre primeiro Avi demonstrando MagLev rodando na prática e depois **Bob Walker** , da Gemstone, explicando como as coisas aconteceram.

Avi iniciou o equivalente a um console IRB do Maglev. De lá ele instanciou uma classe pure-Ruby ‘Hat’. Daí abriu um outro Maglev em outro terminal e demonstrou que o chapéu estava lá também, idêntico.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC05956.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05956&bgcolor=black)

Daí, ele instanciou uma classe ‘Rabbit’ e colocou o coelho dentro do chapéu. Do outro terminal, demonstrou como o coelho ‘apareceu’ no outro chapéu. Ele fez várias pequenas demonstrações desse tipo, com elementos simples de Ruby aparecendo em ambos os ambientes (dois processos independentes com shared-memory transparente). Também demonstrou como esse ambiente suporta Transações ACID. Como em SQL, você pode dar BEGIN, COMMIT, ROLLBACK. Qualquer elemento ‘global’ (definição de classes, variáveis globais, etc) são compartilhadas transacionalmente entre os diferentes processos Maglev.

Em março deste ano, o próprio Avi já dava dicas sobre seu envolvimento com a Gemstone, [neste artigo](http://www.avibryant.com/2008/03/ive-had-a-numbe.html) onde ele explica a tecnologia Gemstone para desenvolvedores Ruby on Rails.

Efetivamente, a tecnologia envolve não somente runtimes de Smalltalk que rodam em paralelo (gems), mas um conjunto integrado com uma engine de armazenamento de objetos no backend (stone). Imagine subir 2 mil gems (equivalente a subir vários mongrels) e imagine ter um enorme repositório em backend (equivalente a um massivo banco de dados) e um terceiro player que são memory caches entre os dois.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC05959.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05959&bgcolor=black)

Agora, o interessante é realmente o repositório de objetos (Stone). Ele é capaz de armazenar **1 trilhão de objetos** , ou até **17 Petabytes** de dados. E esses não são números de laboratório. É importante lembrar que a Gemstone está no mercado há mais de 20 anos, e a tecnologia foi refinada no mundo Smalltalk por muito tempo. Centenas de grandes clientes, que precisam de “objetos vivos” e ativos usam essa tecnologia, principalmente em mercados como o mundo financeiro.

O conjunto da tecnologia permite levantar quantos processos Maglev quanto se julgar necessário (ou quanto seu parque de máquinas aguentar). Estamos falando de paralelismos da ordem de 2 mil processos rodando em paralelo!

Isso é que se chama **escalabilidade**. Só isso já seria surpresa o suficiente. Porém, Bob deixou todos perplexos quando demonstrou números de **performance** (aos pundits, performance não tem absolutamente nada a ver com escalabilidade).

Uma das poucas pessoas que já tinha ‘visto’ o Maglev rodando foi outro amigo meu, [Antonio Cangiano](http://antoniocangiano.com/2008/05/31/maglev-rocks/) e sua reação – colocada no slide – foi _“Holy Shit!”_

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC05960.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05960&bgcolor=black)

Eles deixaram bem claro que eram números de laboratório, um micro-benchmark, e como todos já deveriam saber, não se pode pegar esses número e clamar nada a respeito. Porém, os slides deixaram todos apavorados. Não estamos falando dos normais _“2 ou 3x mais rápido que o MRI”_. Estamos falando de 40, 60, até 100 vezes mais rápido que o MRI!

Num dos slides eles mostraram quanto um serviço do tamanho do Twitter consegue processar: cerca de 600 req/s, que é um número respeitável. Um case real de Gemstone supera isso por uma ordem de grandeza: 6 mil transações/seg.

O que o Bob Walker deixou claro desde o início foi que eles estavam trabalhando nisso fazia menos de 100 dias, ou **4 meses**. Durante esse período eles conseguiram colocar muito da linguagem e até mesmo das Core Libraries, rodando no Gemstone, mas ainda falta muita coisa para ser 100% compatível. Inclusive ele agradeceu ao pessoal do Rubinius por ter iniciado o projeto RubySpecs, pois é exatamente o que eles vão usar para atingir o nível necessário de compatibilidade.

Tudo que foi demonstrado era uma **prova de conceito** , um test-bed para a própria Gemstone avaliar se seria realmente realista dizer que Ruby poderia rodar em Gemstone. E pelo que tudo indica, a prova foi um sucesso maior do que qualquer um poderia imaginar. Tudo porque o pessoal da Gemstone estava presente na RailsConf 2007 e viu Avi declamar que isso seria possível.

**Charles Nutter** parece que ficou bastante abalado com isso. No mesmo instante ele já enviou um Twitter dizendo algo como _“eles não deveriam ter mostrado o slide de performance, isso é prematuro.”_

Em seguida, rapidamente fez [este post](http://headius.blogspot.com/2008/06/maglev.html) em seu blog, que foi bastante criticado. Eu estava sentado na platéia próximo a eles. Vejam esta foto:

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC05966.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05966&bgcolor=black)

Eu não sei se foi apenas eu, mas durante aquela sessão eu senti um “clima” muito sinistro no ar. Seria necessário estar ao vivo lá para entender. Bob Walker tem um tom calmo e aterrorizante em sua voz. A forma como ele descreveu os números, o potencial todo e até a forma como ele pediu aplausos ao pessoal do Rubinius, me deixou com a seguinte impressão por baixo das linhas:

_“Obrigado pessoal (Jruby, Rubinius, etc), vocês foram ótimos, seu RubySpec é excelente e nós vamos usá-los. Sinto lhes dizer que é game over para todos vocês já que nosso produto é extremamente superior.”_

Claro que isso é opinião minha e não foi isso que ele disse. Mas não pude deixar de notar. Do meu lado esquerdo estavam juntos, o Rails Core Team (dá para ver o rosto do David), o pessoal do JRuby (Charles, Thomas, Ola), na frente deles o pessoal do Rubinius (Evan, Wilson) e outros Railers (como Josh Susser). Eu os observei de perto por um bom tempo, tirei várias fotos deles nesse exato momento e a reação deles não foi do tipo _“nossa, que projeto legal!”_, eles faziam mais cara de _“nossa, estamos acabados!”_ ou _“caramba, o que vamos fazer agora?”_

Comentei isso com várias pessoas, e o artigo negativo do Charles meio que confirma essa minha indagação. Ao conversar com outras pessoas, percebi que muitas estão no modo _“politicamente correto”_, sem criticar o Maglev mas também dando uma ‘ensaboada’ nas respostas. Só o Charles é quem foi mais explícito e, por isso mesmo, será o mais criticado.

O pessoal da Gemstone tem um grande problema nas mãos: _“Afirmações extraordinárias exigem provas extraordinárias.”_ Neste momento, o que eles tem é efetivamente o que o Charles chamou de _‘presentation-ware’_, ou seja, bom o suficiente para um demo, mas não para produção. Eles sequer usam o RubySpecs ainda. Porém, eles demonstraram uma aplicação – pequena – Rails rodando sobre Webrick dentro do Gemstone! Isso não é pouca coisa. Quanto tempo levou para o JRuby, Rubinius e IronRuby rodar Rails, mesmo que algumas poucas requests? 4 meses é um tempo recorde, independente de por qual lado você veja isso.

Por coincidência, a apresentação do Avi foi logo em seguida da do pessoal do Rubinius. Sinto dizer que eu não fiquei particularmente impressionando pelo que o Evan e o Wilson tinham a dizer. Eles finalmente mostraram um pouco de Rails rodando sobre Rubinius, mas estamos falando de algumas ordens de grandeza de **lentidão** ainda. A estratégia deles (e que foi a mesma do JRuby e do IronRuby) é de primeiro ficar o mais compatível possível com o MRI para depois buscar otimização. O caminho do Gemstone foi primeiro ser rápido e depois mostrar compatibilidade. Já explico porque nenhum dos dois está errado.

O pessoal do Rubinius está buscando reimplementar sua VM usando o projeto [LLVM](http://blog.fallingsnow.net/2008/05/23/simple-vm-jit-with-llvm/) em vez de fazer tudo do zero. O [LLVM](http://en.wikipedia.org/wiki/Low_Level_Virtual_Machine), ou Low Level Virtual Machine, é uma infraestrutura de compilador escrita em C++. É um projeto ambicioso e que deveria levar Rubinius para o próximo degrau. Mas isso ainda está longe.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC06057.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06057&bgcolor=black)

Eu conversei com o Avi pouco antes da apresentação bombástica. Ele pontuou uma coisa que o Evan disse na sua apresentação. O Rubinius é inspirado no Smalltalk, porém, eles ainda estão, evolutivamente falando, na década de 80. A implementação ainda é ‘ingênua’, assim como o **Squeak**. E ambas não têm nenhuma das novas tecnologias que estão presentes em máquinas mais avançadas como a Gemstone/S.

E foi exatamente isso que acredito que deixou os implementadores (Charles, Evan, Wilson, etc) mais apreensivos: a Gemstone/S está no mercado há décadas, uma VM otimizada exatamente para rodar linguagens extremamente dinâmicas como Smalltalk. Levou cerca de 2 anos para eles chegarem perto do MRI, e o Maglev já é ordens de grandeza superior. Eles levaram 4 meses apenas para fazer o Maglev, mas a infra-estrutura que a suporta tem 20 anos de idade.

Em seu [blog](http://headius.blogspot.com/2008/06/maglev.html) Charles diz o seguinte: implementar Ruby não é tarefa fácil, torná-la compatível significa ter que adicionar um overhead absurdo. Por exemplo, ele diz que para rodar o micro-benchmark no JRuby, ele poderia ‘desligar’ dezenas de overheads que tornam o JRuby mais lento, atingindo 3 ou até 4 vezes mais performance ao custo de deixar o JRuby menos compatível.

Mas eis o ponto crucial nisso: a JVM nunca foi feita para rodar linguagens dinâmicas. A Sun investiu milhares de homens/hora para torná-la especialmente veloz em linguagens estáticas como Java. Classes abertas, meta-programação, lambdas, etc não estão no projeto original e só agora estão sendo atacadas (talvez a partir da JDK 7, que o Charles tem ajudado).

Só existem 2 virtual machines que podem ser consideradas ‘estado-da-arte’, a JVM com seu excelente HotSpot e máquinas robustas como a Gemstone/S. A diferença é que a Gemstone teve 20 anos para tornar sua máquina absolutamente _rock-solid_ e absolutamente refinada para rodar Smalltalk. Mais do que isso, ela foi uma das poucas empresas que teve sucesso em OODB (banco de dados não relacional, de objetos). Mesmo com o overhead de ter um OODB transparente por trás, a Gemstone ainda é altamente veloz. Talvez um pouco mais lenta que a JVM rodando Java nativo.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC05970.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05970&bgcolor=black)

Depois da apresentação, aconteceu um pequeno happy-hour no Double Tree Hotel, e lá eu tive a oportunidade de conhecer e conversar diretamente com os engenheiros da Gemstone. Antes de mais nada eles me confirmaram o que o Avi já havia dito:

> Ruby == Smalltalk

Na prática, eles me disseram que implementaram 3 ou 4 novos bytecodes na virtual machine e é isso. Diferente do JRuby, eles não precisam de um layer para converter uma classe Ruby em uma classe Java. Uma classe Ruby é essencialmente idêntica a uma classe Smalltalk. Portanto não existe overhead de tradução, tecnicamente falando, os números de Smalltalk puro devem ser muito próximas de Ruby puro na mesma VM. Eis o calcanhar de aquiles do JRuby que a Gemstone não precisa ter.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/4/DSC05971.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05971&bgcolor=black)

O **Monty Williams** , da Gemstone, abriu seu Macbook Pro e rodou os micro-benchmarks na minha frente. Chega a ser embaraçoso como o Maglev é veloz comparado ao MRI, o impacto de ver os dois rodando ao mesmo tempo é algo que só pode ser apreciado ao vivo. Com o Antonio disse: _“Holy Shit!”_.

Mesmo assim, ninguém disse que está tudo perfeito. Agora eles vão retomar o projeto e decidir o que fazer. A Gemstone é uma empresa comercial e precisa, obviamente, ganhar dinheiro para sobreviver. O que eles disseram é o seguinte: a idéia não é tirar dinheiro de desenvolvedores como nós. Haverá uma versão free (_as in beer_) com uma certa limitação que certamente será suficiente para a maioria dos projetos pequenos/médios. Para quem precisa de tamanho “enterprise” daí sim será cobrado. Não vejo nenhum problema nisso. Produtos de qualidade podem e devem ter seu preço. O Charles também perguntou sobre isso no meio da apresentação e a resposta do Bob Walker foi _“bom, segundo me consta o JRuby foi feito sobre uma certa VM fechada que só agora está começando a se tornar aberta, certo?”_

Além disso, ainda existe muita coisa a se fazer para rodar Rails perfeitamente. Provavelmente o ActiveRecord precisará ser adaptado ou recodificado. Porque da forma como está, o AR é altamente dependente de SQL. Uma idéia inicial é converter chamadas SQL a chamadas diretas ao OODB deles. Coisas mais complexas como find\_by\_sql obviamente não daria para suportar. Ainda não se sabe como ter suporte a todos os bancos de dados do mercado (adapters Oracle, SQL Server, etc).

Esse foi um dos pontos mais discutidos durante a sessão de perguntas e respostas, mas o próprio **Chad Fowler** fez bem em fechar dizendo: _“se é para usar o Gemstone, para quê você quer SQL?”_ ou seja, a Gemstone foi feita para OODB, porque retirar dele esse poder e voltar a usar SQL?

Seguindo essa mesma linha de raciocínio, eu não acredito que o Gemstone precisa ser necessariamente o único. Quem precisa integrar com legado em Java, por exemplo, continuará melhor servido usando JRuby. Quem precisa de 100% de compatibilidade não somente com a linguagem mas com extensões nativas, adapters, etc ainda será melhor servido com MRI. Mas para quem iniciar _green-field projects_ (projetos do zero), poderá ter um boost incrível ao usar Maglev com todo o poder do OODB por trás. Escalabilidade + Performance passam a ser algo trivial.

O bottom-line é o seguinte:

- JRuby ainda precisa de um grande overhead para rodar Ruby. Ainda existem otimizações que podem ser feitas, mas sinceramente não acredito que eles atinjam perto da velocidade da Gemstone sem modificar a própria JVM.

- Rubinius ainda está muito no começo. Em vários sentidos eles estão para recomeçar do zero, usando a LLVM como base. Mas o projeto RubySpecs que saiu da primeira versão é extremamente importante.

- IronRuby cobre uma necessidade no mundo .NET e acredito que não consiga competir de igual para igual com os outros. John Lam gostou muito do Maglev e parece ter sido um dos únicos que não ficou necessariamente abalado, mas que acha bem vindo. Uma das razões é que ele também já foi muito criticado pelo Charles e a equipe do JRuby. Na sua apresentação ele demonstrou Rails rodando sobre IronRuby. Assim como no caso do Rubinius ainda é insipiente e mais uma prova de conceito, mas eles estão avançando bem, considerando o ambiente de trabalho onde estão.

- Maglev ainda é uma prova de conceito. A Gemstone ainda precisa delinear seu business plan. Ninguém teve acesso ao código-fonte e muita gente reclamou disso, mas acho que isso é irrelevante. Lembrem-se, foram míseros **4 meses** , onde eles sequer sabiam se seriam capazes de rodar alguma coisa. Agora que foi apresentado ao mundo, eles devem começar a liberar mais informações. Nem ainda sabem quanto vai custar. Vamos aguardar.

Uma outra coisa que notei: o pessoal da Gemstone tinha muitos senhores, idosos, pessoal verdadeiramente **sênior**. Não no mal sentido: o principal engenheiro deles, acho que o nome era Alan, está na empresa desde o começo. O que isso me demonstra é o seguinte: eles são **sabem** do que estão falando. Não se trata de um grupo de jovens mavericks fazendo peripécias com código. Estamos falando de gente que não joga para perder, que já tropeçou muitas vezes e que são extremamente técnicos e responsáveis no que dizem. Não é uma startup que nasceu ontem, é uma empresa sólida e lucrativa há décadas.

Só esse fato, para mim, lhes dá o benefício da dúvida. É prematuro mostrar slides de performance? Talvez. Mas eu acho que é prematuro subestimá-los também. O que eles atingiram em tão pouco tempo é incrível. Acredito que nos próximos meses veremos **muita** coisa interessante vindo deles.

Parabéns, principalmente, ao Avi Bryant. Como eu já disse antes, ele é um _role-model_ para todo bom programador. É um verdadeiro amante de programação. Claro que ele também tem opiniões fortes mas, diferente dos **pundits** , ele adora tanto Smalltalk quanto Ruby. E, novamente, ao invés de ficar dando indiretas aos ventos _“mudei de Ruby para Smalltalk porque acho Ruby lento/incompleto/bla bla bla”_ Avi pegou o estado da arte do Smalltalk e faz Ruby rodar nele. Grandes artistas agem assim, pequenos insetos gostam de ganhar page views fazendo reclamações nulas ao vento, e programadores que nunca serão bons programadores gostam dessas afirmações nulas. É a vida.

