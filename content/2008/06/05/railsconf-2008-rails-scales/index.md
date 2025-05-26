---
title: RailsConf 2008 - Rails Scales!
date: '2008-06-05T16:41:00-03:00'
slug: railsconf-2008-rails-scales
tags:
- railsconf2008
- english
draft: false
---

Esta RailsConf 2008 foi bastante técnica. Ao contrário dos outros anos, o comentário geral foi que o nível técnico das sessões foi muito bom. Só de olhar para a agenda dá para ver isso. De cerca de 30 sessões, pelo menos metade lidava com algum aspecto de escalabilidade.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/5/DSC05900.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05900&bgcolor=black)


A maioria dos patrocinadores tinha alguma coisa relacionada com escalabilidade. A Engine Yard apresentou o [Vertebra](http://www.slideshare.net/ezmobius/vertebra), a FiveRuns apresentou seu [TuneUp](http://www.fiveruns.com/products/tuneup), a New Relic tem o [RPM](http://www.newrelic.com/RPM-production-demo.html), a [RightScale](http://www.rightscale.com/m/features.html) tem seu sistema sobre AWS, a Morph tinha o [Morph eXchange](http://www.morphexchange.com/), a [Heroku](http://www.heroku.com) também tinha sua solução AWS e assim por diante.

Aliás, de uma vez por todas, porque várias pessoas me apontaram a mesma coisa: os newbies estão o tempo todo confundindo _performance_ com _escalabilidade_. Uma não é dependente da outra, você pode ter algo extremamente veloz mas extremamente não escalável e vice-versa. As tecnologias em torno de Ruby e Rails não são performáticas, mas são escaláveis. Se não entendeu, leia [este artigo](http://highscalability.com/scalability-vs-performance-vs-availability-vs-reliability-also-scale-vs-scale-out)

Dentre as diversas soluções uma das mais interessantes foi o [Fuzed](http://repo.or.cz/w/fuzed.git), uma arquitetura de cluster escrita em Erlang que suporta instalações Rails, mas pode suportar qualquer outra tecnologia. É um cluster inteligente que cuida das suas instâncias. Difícil explicar em palavras. Infelizmente ainda não tem muita informação online, mas achei a apresentação do Tom Preston e do David Fayram. O objetivo é usar [YAWS](http://www.infoq.com/articles/vinoski-erlang-rest) e Erlang para criar uma infraestrutura que torne trivial deployments de instâncias Rails em slices EC2.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/5/DSC06033.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06033&bgcolor=black)   
David Fayram e Tom Preston explicando Fuzed

Aliás, serviços como o AWS e o próprio cloud computing da Engine Yard foram estrelas. O mundo está se movendo em direção a cloud computing. Sistemas como Fuzed e Vertebra são literalmente os back-bones que vão orquestrar essas instâncias dinâmicas. Está ficando para trás essa idéia de arquiteturas estáticas, alguns scripts capistrano e um número fixo de mongrels. A idéia agora é ser dinâmico, fazer sistemas elásticos e flexíveis que se adaptam às condições de uso.

Assim que conseguir vou liberar as entrevistas que gravei, mas uma legal foi justamente com o James Linderbaum, CEO do Heroku. Como disse antes, eu não assisti à apresentação dele, mas o Vinicius saiu de lá **bastante** impressionado. Fazer deployment de uma aplicação, no Heroku, significa apenas um ‘git push’.

Sistemas como a da New Relic e FiveRuns disputam outro nicho: o de monitoramento e análise, de forma que eles conseguem dissecar sua aplicação e lhe dar recomendações e opções de otimização. Uma coisa que o Blaine Cook disse na sua apresentação foi que é impossível testar carga. Mesmo que você tenha uma suíte de testes com 100% de cobertura, uma coisa que não tem como prever é o comportamento humano. Mil pessoas se comportam **muito** diferente de 1 milhão de pessoas e você jamais vai saber como preparar sua aplicação para isso até chegar nesse patamar.

O que me leva de volta ao tal ‘problema’ Twitter. Conversei com o Ezra, com o Obie, e todos foram categóricos: não existe problema em escalar Rails. Não é o framework que vai fazer a diferença e sim a arquitetura total do sistema. Os gargalos começam muito antes, no banco de dados, nos discos, na rede. Todas essas empresas ganham dinheiro com isso, elas sabem exatamente do que estão falando.

Existem pessoas que “acham” que sabem como resolver o problema do Twitter, muito me admira que eles não tenham conseguido sequer fazer um Hello World num site feito em Frontpage. Acham que ‘entendem’ de banco de dados _“o problema é o MySQL, óbvio.”_ Acham que [sharding](http://lethargy.org/~jesus/archives/95-Partitioning-vs.-Federation-vs.-Sharding.html) resolve todos os problemas. Em lugares como Engine Yard estamos falando de engenheiros sérios, que enfrentam esse tipo de problemas como rotina. Quando o Ezra diz que o problema é a estrutura de dados, a enorme árvore de amigos-de-amigos que existem nas redes sociais, ele tem razão.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/5/DSC06112.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06112&bgcolor=black)   
Phusion tirando sarro dos ‘enterprisey’

O recado de todos foi muito simples: você não tem para onde fugir, se sua aplicação fizer sucesso, é muito provável que você não terá uma solução imediata nem óbvia. Serviços como Heroku podem adicionar novos slices dinamicamente, mas se você realmente fizer **muito** sucesso, nesse caso estamos falando de reestruturar sua aplicação.

Mas não adianta refatorar do nada, criar novos componentes que você “acha” que vão “escalar” melhor. É burrice. Quando se fala que é um erro otimizar prematuramente, não quer dizer que não se deva fazer nada. Algumas coisas são bastante óbvias e devem ser feitas, por exemplo, garantir que suas tabelas tenham os índices corretos, garantir que seus plugins, serviços não estejam gerando gigabytes de arquivos de log por hora, etc.

Porém, criar uma arquitetura maluca baseada apenas em ‘feeling’ é burrice. Use o que você tem à mão, ganhe tempo, lance cedo e torne seu produto um sucesso. Se conseguir fazer isso, aí você terá dados suficientes para começar a entender como seu aplicativo realmente se comporta. Com esses dados em mãos, aí sim deve começar o trabalho pró-ativo de otimização, refatoramento e, talvez, de reescrita de partes da aplicação.

Nenhum de vocês será um Twitter, é muito difícil. Mas existem vários casos sérios e que deram muito certo. Um case que eu gosto é o do John Straw, sobre [reescrever o YellowPages.com](http://en.oreilly.com/rails2008/public/schedule/detail/2082). Esse website server 23 milhões de visitantes únicos/mês. 2 milhões de pesquisas/dia. Mais de 48 milhões de requisições/dia.

Vejam a apresentação, mas no final, sabe onde eles tiveram a maior quantidade de problemas de performance? Pois bem, justamente com o Oracle que não gosta de muitas conexões. Outra coisa foi a performance de carregamento de páginas. O problema foi mais por causa de download de imagens, css do que qualquer outra coisa. Sigam o guideline do [Yahoo! sobre performance](http://developer.yahoo.com/performance/).

Outro case interessante é do TJ Murphy com seu [Warbook](http://en.oreilly.com/rails2008/public/schedule/detail/2127) um jogo social online em Rails para Facebook. Ele literalmente tem um negócio que fatura US$ 100 mil/mês e gasta apenas US$ 2 mil/mês em infra-estrutura. No caso específico dele, foi possível jogar quase tudo em memcache (95% dos hits) e usar bastante da elasticidade do AWS. O mais importante: medir antes de otimizar, ele fala em ferramentas: mire antes de atacar.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/5/DSC05924.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC05924&bgcolor=black)   
equipe da Engine Yard respondendo perguntas

No [Hosting with Woes](http://en.oreilly.com/rails2008/public/schedule/detail/2043) a equipe da Engine Yard discorreu algumas dicas sobre o que eles já viram todos os dias. Coisas como _“não use Ferret, use Sphinx, confie em mim!”_ Algumas coisas úteis como discussões ebb x mongrel x thin. O que eles disseram faz muito sentido: tanto faz: sua aplicação precisa ser gigantesca para você começar a sentir alguma diferença. Além disso parece que neste momento o Thin não é muito bom para lidar com actions que demoram muito.

De qualquer forma, use NginX (eles não tinham visto Passenger até então :-). Num slice como da Engine Yard, 3 mongrels por CPU é mais do que suficiente, seu I/O vai embora antes da CPU. Para tarefas muito demoradas não use BackgrounDRB, ela foi feita de maneira ingênua, atualmente o melhor é usar [BJ](http://codeforpeople.rubyforge.org/svn/bj/trunk/README) (Background Job) que é muito melhor.

Eles também falaram para parar de se preocupar com picos de Digg, TechCrunch, etc. Pelo menos sendo clientes deles, quer dizer :-) O que acontece é que em precisando de mais recursos, ele liberam no momento de pico e pronto. O mais importante é que sua aplicação seja o mais cacheado possível, se pudar colocar Page Cache mesmo na sua front-page melhor ainda. Um Digg pode chegar a dar até 10 mil visitantes no dia, um TechCrunch uns mil, um Ruby Inside/Ruby Flow, de 500 a mil. TV é diferente, um The Today Show pode levar até 100 mil visitantes e uma Fox News Business Show cerca de 2 mil conexões. O problema é que a maioria dessas visitas é ‘baixa-qualidade’, ou seja, poucos se dão ao trabalho de se registrar no seu serviço. Eles apenas atropelam e vão embora, por isso nem é relevante buscar esse tipo de audiência.

A Engine Yard estava particularmente mais engajada na missão de desmistificar os problemas de escalabilidade do Rails. O Ezra é um forte proponente nessa área e acho difícil qualquer outro Railer ter cacife suficiente para peitar alguém com a experiência que ele tem.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/6/5/DSC06055.JPG)](http://gallery.mac.com/akitaonrails#100097/DSC06055&bgcolor=black)   
entrevistando James Linderbaum, CEO do Heroku

E antes que alguém se engane: o Maglev é revolucionário, sem dúvida, mas não vai resolver nossos problemas tão cedo. Ele é voltado a um nicho muito específico que depende de bancos de dados orientados a objetos. Segundo os engenheiros da Gemstone, separar o Maglev do backend OODB não será simples porque eles são intimamente conectados. Com isso você é obrigado a sempre ter um servidor rodando, mesmo que não queira ou não precise. Ainda estamos meio longe desse divisor de águas. Por enquanto, a realidade nos leva de volta ao MRI e ao JRuby, que são os dois únicos realmente production-ready. E isso não é um problema, com todas as opções, ferramentas e soluções que temos, é preciso talento para não conseguir fazer Rails escalar.

