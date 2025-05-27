---
title: '[Akitando #140] Desbloqueando o "Algoritmo" do Twitter - Introdução a Grafos'
date: '2023-04-11T08:00:00-03:00'
slug: akitando-140-desbloqueando-o-algoritmo-do-twitter-introducao-a-grafos
tags:
- grafos
- twitter
- the-algorithm
- machine learning
- algebra
- estatistica
- probabilidade
- ciencia da computação
- hadoop
- hdfs
- spark
- graphx
- pinecone
- salsa
- pagerank
- hits
- graphjet
- realgraph
- lucene
- elastic
- protobuf
- scala
- ruby on rails
- akitaonrails
draft: false
---

{{< youtube id="uIflMYQnp8A" >}}

O Twitter liberou parte do código que chamou de "The Algorithm", que forma o sistema que popula a aba de recomendações "Para Você". 

Vamos entender qual é o contexto de ciência da computação e história necessários pra começar a entender esse código todo. E uma pequena introdução à ciência por trás de recomendações e grafos em geral.

Finalmente, vou poder mostrar na prática a diferença de "código de curso" e "código de verdade" e exatamente porque software nunca acaba.

## Capítulos

* 00:00:00 - Intro
* 00:00:57 - CAP 1 - Avisos e Descrevendo o Repositório
* 00:02:51 - CAP 2 - Interpretando Errado: Não Acredite em Blog Posts
* 00:07:14 - CAP 3 - Derrubando o Meme: Pessoas Idiotas
* 00:11:30 - CAP 4 - Objetivos do Video: derrubar os Clones. Código de Verdade
* 00:16:37 - CAP 5 - Entendendo Grafos. Introdução a Relevância
* 00:21:47 - CAP 6 - Primeira Geração de Relevância: WTF
* 00:27:49 - CAP 7 - Relevância nos Primórdios da Web: PageRank e HITS
* 00:35:43 - CAP 8 - Segunda Geração de Relevância: RealGraph e SALSA
* 00:39:22 - CAP 9 - Escalando com Hadoop e MapReduce: HDFS e Pig
* 00:43:15 - CAP 10 - Algoritmos Escaláveis de Grafos: Relembrando Mergesort
* 00:46:58 - CAP 11 - Terceira Geração de Relevância: GraphJet
* 00:50:36 - CAP 12 - Earlybird: Light Ranker. Apache Lucene
* 00:51:37 - CAP 13 - Ids para Sistemas Distribuídos: Snowflake
* 00:55:23 - CAP 14 - Serialização Eficiente sem JSON: Thrift e Protobufs
* 01:01:07 - CAP 15 - A Controvérsia do "Rails Não Escala". Por que Scala?
* 01:07:37 - CAP 16 - Introdução a Similarity Clusters: Similaridade de Cosseno
* 01:16:08 - CAP 17 - Resumindo os demais Projetos: Aplicando o que Aprendemos
* 01:20:22 - CAP 18 - Qualidade do Código: Mini-Assessment
* 01:22:43 - CAP 19 - Sendo Educado na Web: Memes Idiotas
* 01:24:32 - CAP 20 - Refletindo sobre o Código: Lições a Aprender
* 01:27:31 - Bloopers


## Links

* Fio no Twitter (https://twitter.com/AkitaOnRails/status/1641887891327537158?s=20)
* Twitter: The Algorithm (https://github.com/twitter/the-algorithm)
* Twitter: The Algorithm ML (https://github.com/twitter/the-algorithm-ml)
* Twitter's Recommendation Algorithm (https://blog.twitter.com/engineering/en_us/topics/open-source/2023/twitter-recommendation-algorithm)
* Steven Tey: # How the Twitter Algorithm works in 2023 (https://steventey.com/blog/twitter-algorithm)
* Aakash Gupta: The Real Twitter Files: The Algorithm (https://aakashgupta.substack.com/p/the-real-twitter-files-the-algorithm)
* Earlybird: Real-Time Search at Twitter (https://stephenholiday.com/notes/earlybird/)
* Twitter Search is Now 3x Faster (https://blog.twitter.com/engineering/en_us/a/2011/twitter-search-is-now-3x-faster)
* Paper: GraphJet: Real-Time Content Recommendations at Twitter (https://www.vldb.org/pvldb/vol9/p1281-sharma.pdf)
* Paper: RealGraph: User Interaction Prediction at Twitter (https://www.ueo-workshop.com/wp-content/uploads/2014/04/sig-alternate.pdf)
* Paper: Real-Time Twitter Recommendation: Online Motif Detection in Large Dynamic Graphs (http://www.vldb.org/pvldb/vol7/p1379-lin.pdf)
* Paper: Discovering Similar Users on Twitter (http://snap.stanford.edu/mlg2013/submissions/mlg2013_submission_20.pdf)
* GitHub: FlockDB (https://github.com/twitter-archive/flockdb)
* GitHub: Cassovary (https://github.com/twitter/cassovary)
* GitHub: GraphJet (https://github.com/twitter/GraphJet)
* Twitter: Finagle (https://twitter.github.io/finagle/)
* Apache Avro (https://avro.apache.org/)
* AkitaOnRails: Chatting with Blaine Cook (Twitter) (https://www.akitaonrails.com/2008/6/17/chatting-with-blaine-cook-twitter)
* Fireship: Vector databases are so hot right now. WTF are they? (https://www.youtube.com/watch?v=klTvEwg3oJ4)
* Slideshare: Restrição == Inovação (https://www.slideshare.net/akitaonrails/devconf-2019-so-carlos)
* Elastic: Vector Search (https://www.elastic.co/what-is/vector-search)

## SCRIPT

Olá pessoal, Fabio Akita

Já não é notícia nova, a esta altura acho que todo mundo já viu ou ouviu alguém comentando sobre o código dos algoritmos de recomendação do Twitter, que tio Elon Musk liberou, parcialmente, no último dia de março de 2023. No momento em que estava escrevendo o script deste episódio não se passou uma semana ainda. E até a gravação deste video ainda não foi liberada a segunda parte do código. Mas vamos ver o que temos até agora.



(...)




No mesmo dia que a primeira parte do código foi liberado, eu e diversos outros programadores e pesquisadores começamos a avaliar o código e surgiu muita coisa interessante. Eu mesmo fui twittando em tempo real o que achei de primeiras impressões. Meu foco foi mais na parte técnica e arquitetura. Os links pros meus tweets originais estão na descrição abaixo e neste video vou elaborar em mais detalhes o que não coube em pequenos tweets.






Antes de começar, preciso deixar alguns avisos muito claros aqui. Este código é incompleto. Ainda falta pelo menos uma segunda parte. E mesmo com essa parte, ainda não vamos ter certeza que tudo vai ser liberado. O que o Twitter soltou não é mais que uma pequena fração de todo o código necessário pra se fazer um verdadeiro clone de Twitter. 







Esse código só cobre uma parte dos sistemas que devolvem os tweets recomendados que você vê na aba de "Para você". Em termos coloquiais chamamos isso tudo de "Algoritmo do Twitter", mas não é um único algoritmo: é uma coleção de dezenas de algoritmos e heurísticas que, funcionando juntos, geram recomendações que tem relevância pros seus interesses.







Mesmo sendo incompleto, estamos falando de mais de 4 mil e seissentos arquivos. Mais de 330 mil linhas de códigos, sendo mais da metade código feito na linguagem Scala, e quase 30% em Java. A próxima linguagem mais relevante depois dessas duas é Rust, na nova parte de machine learning chamada Navi, mas mesmo assim é só 2% do total desse código.






Mais importante, o sistema de build que eles utilizam é o Bazel. Pense NPM se você for de Javascript, ou algo parecido com Gradle se for de Java mesmo. Eu mesmo nunca vi Bazel sendo utilizado num projeto de verdade e cada sub-projeto tem um arquivo de BUILD em Bazel, mas eles omitiram os arquivos WORKSPACE, que são necessários pra conseguirmos realmente compilar e buildar cada projeto. 







É possível reconstruir do zero, via tentativa e erro, mas é um trabalhinho bem chato que eu não tenho interesse em fazer e, até o momento, não vi ninguém se prontificando a fazer. Portanto tudo que eu, ou qualquer outro analisar, é baseado unicamente em análise estática do código, que é um jeito mais bonito de dizer que só temos como ler o código ou fazer compilações parciais. Por isso não acredite em tudo que ler em somente um pedaço do código. Deixa eu dar um exemplo.







Alguns pesquisadores foram mais interessados na parte das regras de negócio: os critérios que afetam o alcance de tweets. Em resumo, não teve nenhuma grande novidade bombástica além do que todo mundo mais ou menos já sabia só por observação. Vamos ver dois exemplos, o blog post do desenvolvedor Steven, da Vercel, e o blog post do Aakash Gupta. Ambos os links, novamente, estão na descrição abaixo.






No post do Steven, você vai ler que o algoritmo de ranqueamento vai determinar pesos em algumas ações em cima do seu tweet. Por exemplo, um like tem peso 0.5, um retweet é mais importante, tem peso 1, se alguém clicar no tweet, der reply ou like ou ficar mais que 2 minutos lendo, vai ter peso 11 e assim por diante. Mas, de onde ele tirou essa informação? 







Ele coloca o link pro README no diretório projects/home/recap dentro do repositório the-algorithm-ml, que é o repositório menor de machine learning. A contagem de Scala e Java que falei acima foi no repositório principal the-algorithm, que é o maior; mas tem esse outro menor que é basicamente um projetinho Python, com 91 arquivos e umas 6 mil linhas de código pra PyTorch, que eles chamam de "heavy ranker".







O problema é que o único lugar nesse código onde esses números de peso aparecem, é na documentação desse README. Olha só, se eu abrir o VS Code no projeto the-algorithm-ml e procurar por esse parâmetro "is_negative_feedback_v2", que tem um peso negativo 74, só aparece no README, em nenhum lugar no código tem de fato esse valor. 






Existe um arquivo "local_prod.yaml" que parece que configura esses parâmetros pra produção, e no servidor deles pode ser que esteja mesmo este número, mas no arquivo neste repositório, não tem nada. Portanto, não posso dizer que está nem certo, nem errado, só que é inconclusivo. Só que se você ler o post, vai achar que isso é um fato. E tenho certeza que um monte de gente vai referenciar esse blog post e repetir a informação sem checar o que significa. O Steven não errou nem mentiu, mas ele está descrevendo informação incompleta.







Mas não é só isso. Se for agora no post do tal Gupta, ele vai falar de outros parâmetros de peso. Por exemplo, ele fala que retweets dão um boost de 20 vezes. E de onde ele tira isso? É do repositório principal the-algorithm, no arquivo EarlybirdTensorflowBasedSimilarityEngine.scala no projeto cr_mixer. Lá tem esse trecho da função `getLinearRankingParams`. Ah, agora não é um README, é trecho de código. Então deve ser confiável, certo? Também não. 







Vamos procurar quem chama essa função. Caímos nesse trecho da função `getRelevanceOptions` que, caso essa variável `useTensorflowRanking` seja falsa, daí vai chamar a função com os parâmetros que vimos antes, caso contrário, vai chamar essa outra função `getTensorflowBasedRankingParams`. Vamos ver o que ela define. Voltamos pro arquivo anterior e vemos que ela chama a função `getLinearRankingParams` abaixo, mas muda o tipo e, mais importante tem esse `applyBoosts` pra false.







O que isso significa? Será que então todos esses parâmetros com nome "boost" aqui embaixo vão ser ignorados? Como `offensiveBoost` ou `tweetHasTrendBoost`? Aí que tá, não temos como saber. Como disse antes, esse código é incompleto. Até o presente momento não sabemos nem se 100% desse código compila, não sabemos quais dependências estão faltando, não sabemos como buildar e, portanto, não sabemos como executar esse código e nem quais caminhos dentro são realmente executados pra cada tipo de dados e configurações. 







E mesmo se conseguirmos fazer rodar, vamos voltar praquele README que mostrei agora pouco, da parte de machine learning com PyTorch. Olha o que diz: "não podemos liberar os dados reais de treino por causa de privacidade". Faz sentido, claro, mas sem ter o mesmo material de treino, ou pelo menos o mesmo modelo gerado no final, não temos como reproduzir exatamente o que roda no Twitter e, portanto, não podemos garantir que é exatamente a mesma coisa rodando em produção nos servidores deles.







Portanto, do ponto de vista de auditoria, podemos confiar que, sim, esse código é certamente retirado do código real dentro do Twitter. É código demais pra falsificar, não seria prático. Mas os detalhes do que exatamente roda lá dentro, talvez a gente nunca saiba. Sempre é possível omitir camadas de filtros na fase de mixagem que adicionam ou removem tweets, ou omitir os arquivos de configuração reais que modificam todos esses pesos e boosts.  Não temos como realmente saber, por isso cuidado com afirmações sendo feitas só lendo esse código.







Antes de continuar, eu preciso falar da vergonha alheia que foi o comportamento geral das pessoas frente a esse código. Vamos estabelecer: eu não sou fã de Elon Musk, Dogecoin é shitcoin, e acho uma puta perda de tempo gente que idolatra o cara ou que perde tempo engajando. Ele é só mais um cara que existe. A existência dele não me afeta, assim como a existência de qualquer outro, pra mim, é insignificante. E é só isso. 







O Twitter é uma empresa privada. Como qualquer empresa, ela não tem nenhuma obrigação de liberar código. Portanto, o que ela fez ao liberar, pra mim, é um excelente marketing. Uma cortina de fumaça pra desviar atenção, controlar a narrativa e deixar todo mundo coçando a cabeça tentando desvendar esse quebra cabeça; e ao mesmo tempo cutucar os críticos no governo e cutucar os concorrentes como um Zuckerberg da vida. No mínimo vai deixar muita gente chata ocupada tentando abrir uma caixa semi-transparente que não tem chave pra tranca. 







A real motivação por trás disso não me interessa. Só me interessa que temos esse código. O que foi liberado, continua sendo um código excelente de explorar. Porém, pessoas idiotas parece que tem talento de encontrar a parte mais insignificante, e viralizar os memes mais idiotas. Se você pesquisar a palavra "Elon" no VS Code, a primeira coisa que vai aparecer é essa chave "author_is_elon", logo em cima de outras chaves "suspeitas" como "author_is_democrat" ou "author_is_republican". Uau, que vazamento inesperado! O que é isso, a prova que o Elon dá boost nos tweets dele? O que é isso de democratas e republicanos, tem manipulação neles também?







Até gente que se auto-denomina "programador" ficou fazendo meme disso. É uma vergonha alheia. Se você viu alguém fazendo meme disso, pode des-seguir, o cara é inútil. Deixa eu mostrar como faz. Vamos lá pro código. Esse "author_is_elon" é chave pra um Map que no final vai se chamar PredicateMap, que é gerado através desta Sequence, onde cada elemento é um tuple com uma string que serve de chave e um FeatureMap, que é uma função booleana. No caso desse trecho do Elon, ele recebe um candidato, provavelmente candidato de tweet pra recomendar, e checa se a tal feature de Author contém esse tal DDGStatsElonFeature. Ênfase em "stats".







Bacana, e quem usa esse PredicateMap? Vamos procurar no código. Achamos aqui na linha 82 do objeto ServedEventsBuilder que extende essa trait ClientEventsBuilder. Nesse trecho ele tá iterando por cada predicado naquela PredicateMap e no final o que  tá gerando são counts pra cada predicado. É um contador. E quem vai usar essas contagens? Vamos de novo pesquisar, agora por esse objeto `ServedEventsBuilder`.






Pronto, chegamos neste `HomeScribeClientEventSideEffect`. É o que o Twitter chama de "side-effect". Pelo que eu já tinha deduzido lendo o código, side-effect é um job de Kafka, um job assíncrono. E Scribe é justamente o servidor de logs open source que foi desenvolvido pelo Facebook. É só um servidor de log, não diferente de um Apache Flume ou Logstash, ou Rsyslog da vida. Esses códigos servem pra gerar métricas. É só isso.







"Ah, mas tinha que ser o cuzão egocêntrico do Elon pra ter um código especial pra uma métrica só pra ele." Ué, mesmo se for. Se ele desenbolsou 40 bilhões pra comprar a porra toda, achei foi muito pouco código com o nome dele. Achei que fosse achar classes inteiras renomeadas pra DogeCoin ou algo assim espalhado por aí. Aliás, vocês estão assumindo que esse código foi feito por ordem do Elon. 







Outra teoria muito mais plausível é que esse código foi feito justamente pelo povo que ele demitiu, pra monitorar os efeitos dos tweets do Elon antes da compra ter sido realizada. Muito mais plausível. Independente do que for, só vamos saber se, alguém de dentro do twitter, vazar os logs do repositório Git de verdade, com o timestamp do commit. E mesmo assim, commits de Git podem ser facilmente adulterados. Por isso é uma discussão meio inútil.







Todo mundo ficou fazendo meme com um código de log. E vocês se acham programadores? A discussão do porque esse trecho existe é irrelevante e só serve pra demonstrar como é um programador que gosta de fazer bikeshed: discutir coisas inúteis, sem nenhum valor, sem nenhum mérito. Você está perdendo seu tempo. Agora vamos entender como um programador de verdade olha pra esse código.








O objetivo a partir daqui é o seguinte: desmistificar a diferença de código de curso, código de tutorial e código de produção de empresa de verdade. Pra um iniciante que nunca trabalhou ou só trabalhou em projetos pequenos, a diferença vai ser gritante. A outra coisa é como um programador sênior pensa. Infelizmente, não tem como, num único video, com só 2 dias de análise, sem compilar, conseguir ter a visão completa. Então tudo que vou dizer são só minhas primeiras impressões.







Eu já disse isso em outros videos, mas aqui vale repetir: código de curso, código de tutorial, código em video no Youtube, são absurdamente diferentes de código de verdade de produção. Não tem nem comparação. A complexidade e tamanhos são impossíveis de caber em qualquer curso ou tutorial. É inviável. Literalmente, sem exagero, um curso vai te ensinar a fazer uma casinha de rato com caixa de sapato, mas todo projeto relevante de verdade é um Burj Khalifa, o arranha-céus mais alto do mundo que nunca foi construído, e toda a engenharia pra construir isso num terreno de areia, sem receita pré-pronta.








Outra coisa que já disse antes: software nunca acaba. Se seu produto realmente vale alguma coisa, você vai reescrever partes ou até ele inteiro, mais cedo ou mais tarde. E com esse código liberado pelo Twitter, vou finalmente poder ilustrar esses dois pontos. E esse vai ser o objetivo do video.







Eu peguei aleatoriamente o primeiro projeto no Github com nome de "twitter clone". Tem dezenas por aí. Esse é feito em Next.js, com Typescript, Firebase, Tailwind, só "tecnologia de ponta", como um amador poderia pensar. E ele faz tudo, olha só o Readme: usuários conseguem postar tweets, dar like, retweet, reply, adicionar bookmarks, adicionar imagens, seguir ou des-seguir outros usuários, updates de likes e tudo mais em tempo real. Porra, faz tudo. 







Só que não. Isso não passa de uma caixa de sapatos frente ao Burj Khalifa. Vamos ver, com a ferramenta Tokei, vemos que esse projeto tem 158 arquivos e mais de 32 mil linhas de código. Pra um iniciante, sem dúvida, pode parecer gigantesco. Mas não é. Mesmo sendo só uma fração incompleta, o repositório do Twitter que estamos avaliando, tem mais de 4600 arquivos e mais de 330 mil linhas de código. 10 vezes mais código.







Mas esses projetos sequer são equivalentes. Esse tal "clone" é só o front-end e só as operações mais básicas. Ele jamais aguentaria a escala do Twitter em produção. O "the-algorithm" que foi liberado é só pra buscar os tweets que aparecem na aba "Pra você". Notaram como esses clones omitem a aba "pra você"? Claro, porque justamente a inteligência pra buscar tweets recomendados, em tempo real, em escala, não é um problema trivial de resolver. Todo clone que você achar, ou vai omitir, ou vai ter uma versão super besta de recomendação. E nunca vão escalar pra ordem de centenas de milhões de pessoas. São todos, caixas de sapato.







E não tem nenhum problema nisso. O foco da maioria desses clones é ser um exercício pra iniciantes de front-end treinarem fazer interfaces parecidas com coisas que já existem. Nada mais, nada menos. Nenhum desses clones, seja clone de Twitter, clone de Instagram, clone de Pinterest, chega perto da unha dos pés das versões de verdade e são incapazes de fazer uma fração do que os originais fazem, ou de aguentar uma fração do tráfego. Essa é a realidade dos clones: são todos meros exercícios. Contanto que vocês entendam isso, não tem nenhum problema se exercitar neles. Todo mundo precisa começar do zero. E esse é o nível zero.








A razão dessa diferença é que é trivial fazer qualquer aplicativo funcionar só na sua máquina, com uma pessoa usando. Mesmo se você virar freelancer, normalmente trabalha em projetos que muito pouca gente usa. 10 pessoas. 100 pessoas. Mesmo mil pessoas, é extremamente pequeno. Empresas grandes como MercadoLivre, iFood, Nubank, lidam com milhões, dezenas de milhões de pessoas. No caso de Facebook, Google ou Apple, são bilhões de pessoas. 







E nessa escala, as soluções são completamente diferentes de  todo curso e tutorial que você procurar. Eu afirmo que não existe nenhum curso que cobre casos de larga escala, simplesmente porque todos fazendo cursos nunca tiveram que lidar com esse problema. Eles também simplesmente não sabem que isso existe. Eu mesmo nunca tive que lidar com o caso excepcional de bilhões de pessoas. 







É muito caso a caso, em cada empresa gigante, vai ser diferente. Nenhum curso conseguiria cobrir, mesmo se quisessem. Simplesmente não existe esse material disponível, e é uma das razões de porquê esse código do Twitter é relevante: porque não existe código de produção de empresa de verdade disponível pra podermos mostrar, todos são fechados.







Eu trabalhei em vários projetos, incluindo alguns dessa categoria grande. Mas não posso mostrar, porque nenhum de nós deve quebrar confidencialidade e propriedade intelectual de clientes. Por isso eu falo pra não confiar em nenhum programador que não tenha tido esse nível de experiência: eles nunca viram nada além da dimensão de caixa de sapato e acha que o resto do mundo é pequeno assim. E definitivamente não é. Só quem já subiu no topo do Burj Khalifa, sabe a diferença.








A tal aba "Pra você", à primeira vista, parece super simples. Na aba "seguindo" mostra só tweets de pessoas que eu sigo, provavelmente em ordem cronológica. Fácil de fazer, um iniciante consegue imaginar um "select top 100 * from tweets order by created_at desc" da vida. Agora, no pra você, tem tweets de gente que eu sigo e de gente que eu não sigo, mas que as pessoas que eu sigo interagiram. Então se eu sigo o João e o João retwitou o tweet do Paulo, no meu "pra você" pode aparecer o tweet do Paulo. Só que não é tão simples assim.









E se quem eu sigo interagiu com 100 tweets? Quais deles deveriam aparecer pra mim? Das pessoas que eu sigo, quais delas são mais relevantes pra aparecer no topo primeiro? Por que eu vejo o like de algumas pessoas mas não de outras? Ah, será que como os posts de blogs tavam tentando explicar, é só botar um peso pra like, outro peso pra retweet e dar um "group by" ou "order by" da vida e pegar o topo? Também não. 







Como é impossível cobrir o código todo que foi liberado, escolhi começar falando só de um pequeno trecho. Um banco de dados NoSQL de grafos, que inclusive já tinha sido liberado antes como open source, com licença Apache, chamado GraphJet, e a história por trás dele. Tudo isso foi descrito num paper de autoria de Aneesh Sharma e vários outros colaboradores, publicado em 2016.







Pra todo mundo que não fez ciências da computação entender, na faculdade a gente aprende sobre um troço chamado "grafos". Na prática, você já deve ter visto e até desenhado. É quando se desenha caixinhas ou círculos que chamamos de nós e ligamos um nó com outro nó com um troço que chamamos de vértices. Podemos representar grafos como matrizes adjacentes ou listas adjacentes. Outra forma de representar grafos é com vetores.






Daí podemos classificar grafos baseados em características como número de nós ou número de vértices, edges ou bordas, direção das bordas. Tem diversos tipos de grafos como unidirecionais. Em Git, por exemplo, você já deve ter ouvido falar que é um DAG, um direct acyclic graph, ou grafo acíclico, que não é cíclico, e direto. 






Dado um grafo, temos como navegar de um nó pra outro nó. Pense em nós como uma casa numa rua e os vértices como o caminho, talvez a rua, entre essas casas. Daí temos algoritmos pra navegar como o algoritmo do menor caminho entre dois nós, que é o hello world de grafos. Não só isso, ainda no assunto de classificação, temos nós que ficam nas bordas do grafo que tem poucos vértices e temos nós no meio dos grafos com muitos vértices. 






Costumamos chamar esses nós de "hubs". Na prática, numa rede social, chamamos de hubs, mas pessoas comuns chamam de "influencers". Pessoas comuns são os nós das bordas, com poucos relacionamentos, que são os vértices.






Tudo na natureza pode ser representado como grafos. Como falei antes, evolução de desenvolvimento de software, pode ser representado como um DAG, um grafo de commits, com branches. Um sistema de logística e entregas é orientado num mapa com grafos, pra determinar o melhor caminho de entrega entre dois pontos. O DNA humano pode ser um grafo, onde os nós são as bases como adenina, citosina, guanina e timina, formando nucleobases. As sinapses do nosso cérebro são grafos.






Num ecossistema animal temos a hierarquia da cadeia alimentar, que pode ser representado como um grafo. No mercado temos grafos de empresas e relacionamentos de comprador e vendedor. E assim por diante. No caso do Twitter, que é uma rede social, os nós costumam ser as pessoas, e os vértices são os relacionamentos, quem nós seguimos, quem damos likes ou retweets, quem bloqueamos e assim por diante.






Se você nunca estudou ciências da computação, vai ter um pouco de dificuldade de entender o que vou explicar e certamente não vai entender nada do código do Twitter. Vou tentar simplificar o máximo que der, mas só consigo chegar até certo ponto, então, se interesse em depois ir procurar cursos como nas aulas do MIT sobre grafos. Pra operar em grafos, você vai precisar aprender coisas como Álgebra Linear e Cálculo, pelo menos o Cálculo básico. 






E portanto sim, pra entender como uma rede social funciona e o código por trás, precisa entender esses aspectos da matemática. E pra chegar no ponto de recomendação, também precisa entender o básico de estatística e probabilidade, porque recomendação é justamente a probabilidade dos tweets que o sistema recomendar realmente te interessar a ponto de engajar, dar like ou reply, que é a base de machine learning. 






Mesmo se você não for implementar do zero inteligência artificial, machine learning, ainda assim precisa entender essa matemática. Machine Learning é, nada mais, nada menos, do que uma coleção de algoritmos de classificação e probabilidade. Se não souber quando pode usar regressão linear, regressão logística, similaridade de cosseno, bayes ingênuo, não vai saber o que fazer. 






Cada caso, cada tipo de conjunto de dados e o resultado que quer, depende de saber escolher quais desses algoritmos usar. E pra saber quais usar, precisa saber a matemática por trás. Senão vai usar regressão linear quando não podia e ter resultados errados, que é a coisa mais comum de ver amador fazer. Nem tudo que parece uma reta, é uma reta.







E no caso desse código do Twitter sim, eu encontrei que ele usa coisas como grafos, regressão logística e similaridade de cosseno. Mas estou me adiantando. Vamos voltar ao tal paper do Graphjet de 2016. Um problema, que não é trivial de resolver e não tem uma solução única, porque depende do comportamento dos usuários e dos dados disponíveis, é recomendação. Seja recomendação de produtos num ecommerce, recomendação de leitura num site de notícias, ou recomendação de tweets num Twitter.






Como usuários seguem usuários, naturalmente temos grafos, em particular grafos bipartidos, com usuários de um lado e tweets de outro. Os esforços de recomendação começaram no Twitter por volta de 2010, lembrando que o Twitter começou a operar em março de 2006. 






Eu mesmo criei minha conta só um ano depois, em abril de 2007, durante a Railsconf 2008 em Portland, onde eu via todo mundo se cadastrando pra gente compartilhar onde ia ser o próximo happy hour. Lembrando que ainda não existia Messenger do Facebook, não existia Whatsapp, não existia Telegram. O único aplicativo de mensagem que todo mundo usava, era SMS.






De qualquer forma, quando eles começaram a experimentar a recomendar usuários novos pra gente seguir, por volta de 2010, foi com um sistema que chamaram carinhosamente de "WTF", What the Fuck. Mentira, era "Who To Follow". A arquitetura era como nessa figura. Segundo o paper, no seu núcleo tinha esse Cassovary, que é um motor de processamento de grafos in-memory, ou seja, que mantém os grafos em memória. Isso é importante, porque a maioria dos algoritmos conhecidos pra lidar com grafos assume ter o grafo todo em memória. Guarde essa informação.







Esse projeto Cassovary é open source e podemos encontrar no GitHub deles. Última atualização foi de 2021, e não é mais utilizado hoje. Continuando, esse Cassovary operava em snapshots de grafos de seguidores carregados do HDFS, que é o sistema de arquivos distribuídos do Hadoop. Quem já trabalhou com Big Data, Data Lakes, certamente já esbarrou em instalações de HDFS e no Twitter não era diferente. Só entenda que é um sistema de arquivos distribuído, como se você tivesse uma partição única espalhada em múltiplos servidores. É um nível acima de um simples RAID.






Os grafos de seguidores vinham de outro banco de dados chamado FlockDB que fazia a ingestão desses dados no HDFS. FlockDB acho que foi o primeiro banco de dados de grafos que o Twitter criou e soltou como open source. O que aconteceu foi: eles começaram como qualquer tech startup normal, sem saber o que o produto ia se tornar. No começo usavam um banco de dados normal, MySQL mesmo. Mas quando começaram a fazer sucesso e ver que o problema era maior que um banco relacional, começaram a pesquisar alternativas. E o primeiro resultado foi um banco de dados de grafos, o FlockDB.







O FlockDB dava mais performance pra operações de inserção, updates, já que não precisava das garantias ACID de um banco relacional. Tinha operações extras pra lidar com grafos, como navegar por nós e pelos vértices. E vocês tem que entender que carregar um grafo em memória pode ser pesado. Imagine sua própria conta: você tem dezenas de tweets, você segue dezenas de pessoas, essas pessoas tem dezenas de tweets. 








Cada um desses tweets tem contagens de likes, retweets; alguns tweets são replies pra outros tweets. E pra calcular qual deles é mais relevante ou menos relevante, o ideal é ter toda essa estrutura em memória pra conseguir navegar por toda essa informação. Agora pensa num banco de dados relacional como MySQL. Como você resolveria esse problema? Qualquer solução que você imaginar em SQL, pode ter certeza, já foi testado e sabemos que não vai escalar. Essa é um dos poucos cenários que podemos afirmar que um banco de dados relacional não é adequado.







Segundo a página de GitHub do FlockDB, até 2010 o cluster deles armazenava mais de 13 bilhões de bordas e sustentava picos de tráfego de mais de 20 mil escritas por segundo, e mais de 100 mil operações de leitura por segundo. Mas rapidamente chegou um ponto onde isso já não era mais suficiente. Foi quando começaram a puxar esses dados pra HDFS e processando nesse novo projeto que chamaram de Cassovary, um segundo projeto em Java pra lidar com "Big Graphs", grafos com bilhões de nós e vértices. Foi a época que as celebridades gigantes começaram a viver no Twitter. Pense nível Kardashians.







Voltando ao paper, a camada de armazenamento do Cassovary dava acesso aos grafos via queries, pesquisas baseadas em vértices. Pense um "SQL" especializado em grafos. E em cima disso um motor de recomendação computava as sugestões de "Who To Follow", o WTF, ou "quem seguir". Foi assim que nos primórdios do Twitter a ganhamos sugestões de novas contas pra poder seguir.







Um dos objetivos desse projeto era ver se era possível manter os grafos em memória, in-memory. A pergunta que eles não tinham resposta é: será que o crescimento do volume de dados desses grafos seria mais lento que a Lei de Moore? Se for, o preço de memória iria baratear mais rápido do que os dados cresciam, e daria pra computar tudo em memória. Que é mais simples do que ter que lidar com discos, particionamento, paging, cache e tudo mais. 






Como o paper diz, considere um grafo com 10 bilhões de bordas: mesmo uma representação ingênua, simples, ocuparia algo na faixa de 80 gigabytes, que um único servidor consegue aguentar. Você já trabalhou com um servidor, este ano, que tem 80 gigabytes? Se sim, diga nos comentários que empresa é, pra todo mundo entender meu ponto.







Uma das limitações, mesmo naquela época, é que essa sugestões de recomendação de quem seguir, eram calculados em batch, uma vez por dia, não era em tempo real como é hoje. Ou seja, você só tinha recomendações novas uma vez por dia. De qualquer forma, via muita experimentação, muitos testes A/B, eles chegaram em dois conceitos que usam até hoje e que vale explicar. O primeiro se chama círculo de confiança e o segundo foi a adoção de "SALSA" que é Stochastic Approach for Link-Structure Analysis ou Análise de estrutura de links usando processos estocásticos. 







Um exemplo de grafo que eu não mencionei, mas deveria ser óbvio, é a própria World Wide Web. Toda página na internet é um nó, as bordas, vértices, são links de uma página pra outra. No começo da web, já se tinha um número grande de páginas, o suficiente pra ser difícil de achar as coisas. Pense numa era antes de existir Google. A forma rudimentar que existia pra gente se achar era derivado do conceito antiquado de Páginas Amarelas. 







Se você for muito novo talvez nunca tenha visto, mas antigamente, quando precisávamos achar um mecânico, um médico ou qualquer serviço, tínhamos um livrão físico de páginas amarelas que era um diretório com todos os serviços da cidade. Cada cidade tinha um livro diferente. Imaginem que novos negócios tinham dificuldade de serem encontrados, porque precisava esperar uma nova edição ser impressa e distribuída pra todo mundo. Páginas de classificados nos jornais meio que cobriam um pouco dessa diferença.







Serviços como Yahoo, Excite, Lycos e outros serviam esse papel na Web. Se eu criasse um site novo, pedia pra ser incluído num desses diretórios pra que as pessoas conseguissem me achar. Esse era o processo. Mas mesmo assim, imagine restaurantes. Qual das centenas de restaurantes numa cidade grande como São Paulo, seria relevante pra mim? Mesmo se tivesse a opção de filtrar por localização e tipo de cozinha. Ainda assim eu tinha que manualmente tentar várias. Era bem trabalhoso.







Portanto, resolver esse problema de relevância entre milhares de páginas web, era muito importante. E lá no meio pro fim dos anos 90 surgiram pelo menos dois estilos diferentes de lidar com isso. A maioria de vocês que estudou o mínimo de grafos talvez estejam familiarizado com o famoso paper de PageRank, literalmente ranking de páginas, inventado pelos fundadores do Google, Larry Page e Sergey Brin em 1996 quando ainda eram estudantes de Stanford.






Procurem no YouTube, tem dezenas de videos que explicam PageRank, mas a idéia básica é a seguinte. Começa pelo básico, o "H" de HTML é pra Hyperlink. Todo mundo esquece isso, mas o mais importante numa página web é que a página de alguém contenha um link pra sua página. Quanto mais sites diferentes tem links apontando pro seu site, mais relevante ele pode ser. 







No PageRank, imaginamos um navegador aleatório, uma pessoa imaginária que vai clicando em páginas e nos links nessas páginas, aleatoriamente. Qual a probabilidade de, só navegando sem rumo, alguém cair na sua página? Esssa probabilidade é o seu score, sua pontuação. Se sua página é famosa, centenas de outras páginas contém link pra sua, a probabilidade desse navegador aleatório chegar na sua página é alta, portanto sua pontuação no ranking, no PageRank, é alta.







Esse foi o algoritmo usado na primeira versão do Google, o site que matou todos os diretórios estilo páginas amarelas. Porque agora era possível fazer um programa que sai vasculhando todas as páginas na web, avaliando os hyperlinks entre eles, e atribuindo pontuações nesse ranking. Daí, quando fazemos uma pesquisa, ele nos mostra primeiro as páginas mais bem pontuadas. É por isso que logo na primeira página, os primeiros links costumam ser os corretos.







Com isso eliminamos a necessidade de seres humanos ficarem manualmente classificando páginas em diretórios e atualizando a relevância na mão, que sempre foi demorado, trabalhoso, tedioso e com muita margem de erro. Essa talvez tenha sido a primeira categoria de trabalhadores da web que perderam seu trabalho pra um algoritmo, e não será a última. Tudo que é feito manualmente e pode ser automatizado, certamente será. Todo trabalho repetitivo é automatizável, sabemos isso desde o começo da Web.







Mas todo algoritmo tem seu ponto fraco e rapidamente as pessoas começaram a notar que se o lance é esse número de links pra sua página, que tal criar um monte de sites fantasma que fazem links pra uma página que você quer tornar relevante? E assim surgiram os primeiros web farms, fazendas de servidores fake, e uma galera que vendia relevância pro seu site, fazendo um monte de site falso linkar pra sua. Seja criando sites bestas em série ou invadindo sites dos outros pra colocar links.






Isso aconteceu só lá no começo dos anos 2000. Por isso o Google evoluiu e deixou de usar PageRank e passou a usar, por exemplo, TrustRank, que combate web spam identificando quem é site legítimo e quem não é, e descontando pontuação. Ao longo dos anos o Google sempre foi aprimorando esses algoritmos, não é um produto fixo. Parte do trabalho de agências web era ficar monitorando quando o Google lançava uma nova versão pra modificar as estratégias pra levar relevância pros seus clientes. Esses truques baratos não funcionam mais hoje.








Mas não era só isso. Mesmo sem spammer e gente maliciosa, as primeiras versões do PageRank ainda sofriam de um problema grave. Pra ilustrar, veja meu conteúdo, meu canal e meu blog, que é de um domínio muito específico de assuntos de tecnologia pra programadores. Talvez eu faça um video explicando em detalhes sobre o algoritmo do Twiter, exatamente o que estou fazendo agora. Pra programadores é relevante. 







Porém, imagine que um bosta como um Felipe Neto também faça um video falando sobre o algoritmo do Twitter. Segundo o PageRank, que é um ranking global, quer você goste dele ou não, se pesquisar no Google de 1997 "algoritmo do Twitter", esse video do Felipe Neto iria aparecer na frente do meu. Essa é a desvantagem de um algoritmo de ranking global como o PageRank original.







Mas como eu falei, as pesquisas em torno de grafos evoluíram rápido. Por exemplo, em 1999 surgiu o algoritmo HITS que significa Hyperlink-Induced Topic Search, de Jon Kleinberg. HITS opera num grafo direcionado, onde páginas web representam nós e hyperlinks são bordas direcionadas. Até aqui, igual PageRank, mas o HITS assinala duas pontuações pra cada página web: uma pontuação se é um "hub" e outra pontuação se é uma "autoridade". 







Hubs são páginas que linkam pra diversas outras páginas. Pense um site do Estadão ou da Folha. São hubs de notícias que linkam pra trocentas outras páginas fora. Ou influencers como o Nelipe Feto, é um hub. Já autoridades são páginas que recebem muitos links de muitos hubs. Pense a página da Receita Federal em época de imposto de renda. Todo mundo faz link pra ela, pra avisar que tá vencendo a data ou ensinando como preencher seu imposto. Mas todo mundo pode ser ao mesmo tempo um hub e uma autoridade, alguns são mais hubs, alguns são mais autoridades num domínio em específico. Por isso duas pontuações distintas.






Portanto, o canal de um Nelipe Feto da vida teria uma pontuação de Hub muito maior do que de autoridade, que é exatamente o perfil do influencer médio: serve pra direcionar tráfego pra todo mundo, mas ele mesmo não é autoridade de quase nada. Já caras como eu geram muito pouco tráfego pros outros, mas todo mundo me menciona e linka pra mim em assuntos de um domínio específico de programação e tecnologia. 







Com isso, minha pontuação de autoridade, num video sobre "algoritmo do Twitter", seria maior que do Nelipe e eu apareceria no topo da pesquisa, mesmo ele tendo muito mais tráfego e sendo muito mais famoso. Essa é a vantagem de algoritmos da família do HITS, se comparado ao PageRank original: ele torna esse jogo bem mais justo do que uma pontuação única global, e tenta melhorar a confusão entre influencer e autoridade. Só porque alguém tem muito seguidor, de jeito nenhum o torna autoridade de coisa nenhuma.







Porém, se antes, a forma ingênua era ter uma única pontuação global do PageRank, em HITS teríamos sub-grafos pro domínio ou tópico, por exemplo, programação, gastronomia, viagens, cinema e cada vértice teria duas pontuações, de hub ou autoridade, por tópico. Portanto dá pra imaginar que é mais caro computar HITS do que PageRank. Claro, o que temos hoje num Google é uma amálgama dessas técnicas e muitas outras que surgiram ao longo do tempo. O que nos leva de volta a SALSA.







SALSA poderia ser considerado uma evolução da idéia de HITS pra análise de links, mas uma das idéias é não precisar navegar por todos os vértices e pontuar o grafo inteiro. Em vez disso ele implementa a idéia de andarilho aleatório ou random walker. É que nem pesquisas de opinião pública. Todo mundo tá acostumado a ver agências de fake news, cof, quero dizer, imprensa tradicional, fazendo pesquisas de opinião na rua pra dizer "ah, metade dos brasileiros considera o governo atual uma bosta". Mas como eles sabem disso? Eu não lembro de ninguém me perguntando isso.







Essa é a mágica da estatística. Podemos fazer sampling, ou seja, pesquisar só uma fração da população. Quanto mais aleatório for esse sampling, melhor. Um coisa é perguntar pra 100 pessoas só de São Paulo, outra coisa é perguntar pra 4 pessoas de cada estado. Assumindo que escolhemos bem esse grupo, dentro de uma margem de erro, podemos afirmar que a população em geral tem essa ou aquela opinião, economizando ter que perguntar pros mais de 200 milhões de cidadãos do país. É uma puta economia de 200 milhões pra 100. Entendem?








Mesma coisa num grafo. Eu não preciso necessariamente andar o grafo inteiro, posso escolher um grupo aleatoriamente, em vez de usar o modo iterativo original do HITS, economizando muito processamento e tendo resultados que caem em margens de erro estatisticamente aceitáveis. Pra otimizar mais isso, ele também reorganiza os nós e vértices num grafo bipartido, que ajuda a separar os papéis de hubs e autoridades. 







Posso separar nossos nós em dois conjuntos distintos: um com páginas que linkam pra outras páginas, os hubs, e outro grupo com páginas que recebem links, as autoridades. Não vale a pena eu detalhar hoje, mas gravem esses dois conceitos de random walk e grafo bipartido pra estudar depois se tiverem interesse.






Expliquei tudo isso porque o paper do Twitter menciona que eles desenvolveram um algoritmo de recomendação baseado em SALSA, que é um algoritmo de random walk na mesma família de HITS, originalmente desenvolvido pra ranking de pesquisa web. O algoritmo constrói um grafo bipartido de uma coleção de websites de interesse (hubs de um lado e autoridades de outro), e cada passo no SALSA navega por duas bordas - um pra frente e outro pra trás. - agora você sabe o que esse parágrafo do paper está dizendo.







E ele continua dizendo: nós adaptamos SALSA pra recomendação de usuários da maneira mostrada nesta figura. O lado de hubs na esquerda é populado com o tal círculo de confiança do usuário, os usuários que ele escolheu manualmente seguir. As "autoridades" no lado direito são populados com usuários que esses hubs interagem. Depois que esse grafo bipartido é construído, rodamos múltiplas iterações de SALSA, que assinala pontuações. 







Daí os vértices do lado direito são ranqueados por essa pontuação e tratados como recomendações de usuários. Os vértices do lado esquerdo também são ranqueados e interpretados como similaridade entre usuários. Baseado no princípio da homofilia, que é só um nome bonito pra dizer que pessoas com interesses parecidos tendem a se agrupar mais, podemos apresentar esse resultado como recomendações, que antigamente era uma seção chamada "similares a você".








Resolvi dar uma detalhadinha a mais até aqui pra tentar explicar como foi o raciocínio por trás da primeira versão do motor de recomendação, mas agora vou tentar andar um pouco mais rápido, porque esse foi o sistema WTF que não existe mais. Sim, toda essa pesquisa, experimentação, durou pouco tempo. Apesar de ser um sistema bom, que funcionou bem, ele ainda não é o que conhecemos hoje. E em 2012 eles começaram a perseguir o tal projeto Cassovary que mencionei antes.







Pra ter recomendações ainda melhores, eles queriam usar mais sinais dos logs de comportamento dos usuários. Comportamento de likes, retweets, replies, follow e tudo mais. Mas isso torna os metadados do grafo ainda maiores e a premissa da primeira versão, que era tentar manter tudo em memória, já não cabia mais. Daí veio a decisão de tentar usar Hadoop, em particular Apache Pig que, pra quem não sabe, é tipo um compilador que produz sequências de programas MapReduce.






Hadoop é uma plataforma de tecnologias criadas pra lidar com o problema de Big Data no auge da Bolha da Internet no começo dos anos 2000. Pra muita gente ainda hoje, o conceito de Big Data não é muito palpável, porque ninguém lida com isso no dia a dia. Varia de produto pra produto, mas quando estamos gerando coisa como gigabytes por dia de dados, terabytes por mês, estamos em território de Big Data. O que você faz, com um banco de dados que tem centenas de terabytes? Deita e chora, porque não importa quão bom seja seus índices e queries, sua aplicação vai ficar absurdamente lenta, só pelo tamanho.







Nessa ordem de grandeza estamos falando que não é possível manter todos os dados numa única máquina, mesmo sendo um servidor grande, seja por limitação física ou de custo. Daí a única solução é a estratégia de Napoleão: particionar, dividir esse tanto de dados em múltiplos servidores, e daí conquistar. Por isso a base do Hadoop começa com o HDFS, que é o Hadoop File System, um sistema de arquivos distribuído.






Agora o problema é o seguinte: na faculdade você aprendeu a lidar com dados todos no mesmo lugar. Por exemplo, digamos que você tem uma lista de produtos e preços e queremos achar o produto mais barato, como faz? Simples, escolhe um algoritmo qualquer de ordenação como um Quicksort ou Mergesort da vida, e pega o primeiro elemento que vai ser o mais barato. Pra fazer isso, precisamos iterar elemento a elemento da lista pelo menos uma vez. Mas e agora, e se estamos com 5 servidores e essa lista foi dividida por 5?






Intuitivamente, poderíamos pensar, beleza, vou ter que repetir a ordenação uma vez em cada máquina. Daí no final vou ter uma lista parcial com os 5 produtos mais baratos achados em cada um dos 5 servidores, daí faço uma última ordenação nessa lista e finalmente acho o mais barato. Cada um dos servidores vai rodar em um quinto do tempo do que se fosse a lista completa, mas no final, ainda tem pelo menos mais uma operação de ordenação extra e aí tenho o resultado. Então seria tecnicamente um pouco mais "lento" rodar em vários servidores separados, mas vai ser menos caro.






Isso de rodar um algoritmo em pedaços dos dados, mapear os resultados parciais e depois reduzir na resposta final, é o que, a grosso modo, chamamos de MapReduce, que é parte fundamental de como fazer processamento de dados em Hadoop. Novamente, não vou detalhar MapReduce então anote pra pesquisar mais depois. MapReduce ficou famoso porque, depois do PageRank, é como o Google conseguiu operar em larga escala e deixou todo mundo no chinelo no começo dos anos 2000. 






Hoje em dia é como toda grande empresa de tecnologia funciona, mas 20 anos atrás, essa forma de pensar em processamento de dados foi fundamental pra possibilitar termos produtos que aceitam quantidades massivas de pessoas e transações, literalmente ultrapassando a população total de diversos países. Tem mais gente no Twitter do que a população dos Estados Unidos, metade da população do mundo tá em produtos da Meta.







Por isso, pra segunda versão do motor de recomendação, o Twitter deixou o FlockDB e WTF pra trás e perseguiu o tal projeto Cassovary pra rodar em cima do HDFS do Hadoop, usando MapReduce. Mas eles tiveram vários problemas. Mesmo em 2012 já era sabido que grafos não performavam bem em Hadoop. Isso porque a maioria dos algoritmos conhecidos pra processar grafos são iterativos, lembra que falei pra guardar essa informação?







Pra ilustrar. Pense nos diferentes algoritmos de ordenação que aprendeu na faculdade. Alguns professores cometem o pecado de não explicar porque existem tantos e porque foram criados. Por exemplo, meu professor na faculdade mandou a gente decorar lá Quicksort, Mergesort, mas não explicou que mergesort foi criado pelo lendário Von Neumann pro problema de listas de dados que não cabiam na memória RAM da época, então começavam gravados numa fita. Daí o algoritmo vai percorrendo os elementos da fita, sem estourar a RAM, e vai gravando ordenado numa segunda fita. Se tiver essa imagem de fitas na cabeça, mergesort finalmente faz sentido. Sem isso, é um algoritmo que não faz sentido existir.








Em 2012 ainda não existia o equivalente mergesort pra grafos que não cabem em memória e precisam ficar divididos em partições de HDFS distribuídos em múltiplos servidores. Hoje em dia já existe um suporte maior. Pense um Apache Spark com GraphX. Mas 10 anos atrás, era um uso inédito ainda. O próprio paper descreve que eles estavam cientes dessas desvantagens. O paper menciona que o gargalo era na materialização dos vizinhos dos vértices, que requeria um enorme shuffling de dados, que é pegar dados de diversos servidores pra formar o grafo necessário pro processamento.







Nessa parte do paper ele referencia outro paper, o "Discovering Similar Users on Twitter", onde é explicado como exatamente eles conseguiram passar as barreiras de usar Hadoop, adaptando o algoritmo de PageRank personalizado pra ambiente distribuído. Como já expliquei, esse algoritmo é largamente utilizado pra computar similaridade entre nós em um grafo, mas é iterativo e requer data shuffling frequente. Quando falo data shuffling é tipo reembaralhar dados. Pensa como isso é difícil quando seus dados estão distribuídos em diferentes servidores.







Pra resolver, os autores do paper propõe uma modificação ao algoritmo de PageRank personalizado chamado "One Pass PPR", que reduz o número de iterações e minimiza esse reembaralhamento pra cada iteração. Nesse caso, os dados são particionados baseados nos IDs dos usuários e processados numa única passada sobre os dados, usando uma combinação de pontuações local e global. O algoritmo também usa técnicas de caching pra evitar recomputar resultados intermediários, reduzindo o número de iterações totais.






Além disso os autores também propõe técnicas de compressão pra reduzir o tamanho do grafo e possibilitar processamento mais rápido em sistemas distribuídos como Hadoop. É muito detalhe pra tentar explicar hoje, mas esse é o resumão desse outro paper que também recomendo darem uma olhada depois. 






É nele que se resolve o problema de conseguir dizer que quem segue um Lebron James tem alta probabilidade de seguir um Kobe Bryant ou quem segue uma Lady Gaga costuma seguir uma Taylor Swift. E é onde nasce o framework que é utilizado até hoje e que vou retornar pra explicar, sobre a arquitetura de geração de candidatos e modelo de aprendizado baseado em regressão logística e similaridade de cosseno pra achar usuários similares no Twitter.







Voltando ao Cassovary, é só uma parte da solução, é quem dá acesso aos dados dos grafos em Hadoop. A solução geral é chamada de RealGraph, que é uma representação composta do grafo de seguidores e grafos de interação induzidos através de logs de comportamento. Essa representação é construída de múltiplos pipelines de funcionalidades que são extraídas, limpas, transformadas e juntadas a partir dos logs crús. O RealGraph é armazenado em HDFS. E esse nome "RealGraph" vamos encontrar no código em Scala do repositório que foi liberado, como podemos ver no VS Code. Toda vez que ver "RealGraph", provavelmente é isso.







Mas esse segundo motor de recomendação ainda tinha um grande defeito, só servia pra recomendar usuários similares pra você seguir e só atualizava poucas vezes ao dia, não era nem perto de ser tempo real. Funcionava, mas ainda não é a aba "pra você" que tem no Twitter hoje. Pulamos do WTF de 2010, pro Cassovary, Hadoop e RealGraph de 2012, e agora saltamos pra 2014 e um novo paper que descreve algumas novas estratégias pra particionar e organizar esses grafos. Como podem ver, não era um problema trivial de resolver. 







No caso de Twitter, e até em sistemas de mensageria em geral, existe uma particularidade nos dados: você nunca precisa do grafo inteiro dos usuários. Por exemplo, pouca gente tá interessado em ver tweets de mais de 1 ou 2 dias atrás das pessoas que segue. Então mesmo que seu influencer favorito tweet todos os dias, o que seria um volume grande de tweets pro grafo, podemos limitar uma janela de 1 ou 2 dias pra todo mundo e lidar com um sub-grafo muito menor. 







Pensando assim não precisamos lidar com operações como "deletar" um tweet do grafo, por exemplo. Basta pensar em expiração. É mais ou menos o mesmo pensamento por trás de caches como Memcached ou Redis da vida, que usamos hoje. Não pense em como apagar dados velhos, estabeleça uma janela de tempo e deixa expirar sozinho, que é boa prática de qualquer tipo de caching.







Não só isso, mas não precisamos guardar o timestamp exato de cada tweet no grafo. Isso vem da observação que a maioria das interações, como likes, retweets, replies, costumam acontecer muito próximo do momento que o tweet foi criado. Pra maioria de nós é interessante saber que o tweet foi postado 1 hora atrás, 5 horas atrás, 1 dia atrás, mas não interessa exatamente quando. É menos um dado pra ter em memória e mais uma economia.







Pensando em tudo que eles aprenderam até agora, iniciariam um terceiro motor de recomendação em cima de outro projeto que eles também tornariam open source, chamado de GraphJet. Ele mantém um grafo bipartido que registra integrações de usuários a tweets durante as mais recentes "n" horas, com uma API super simples só com as operações que eles sabiam que realmente iam precisar, sem fazer overengineering de criar um banco de dados de grafos genérico demais. Finalmente tinham experiência suficiente pra conseguir especializar a solução.







O resto do paper entra em detalhes sobre como foi a estratégia de mapeamento de IDs, estratégias de gerenciamento de memória pra balancear reembaralhamento e distribuição dos dados. Em resumo, eles conseguiram chegar num modelo onde só o processamento pra encontrar usuários e tweets recomendados ficou na casa abaixo dos 10 milissegundos, que é perto do ideal pra conseguir ter resultados em real-time, onde a maior parte dos gargalos era a comunicação com os diversos sistemas de filas, como o Apache Kafka que usam até hoje.







Esse paper é bem bacana e recomendo lerem com muita calma e anotando cada termo que não conhecem pra pesquisar depois. Ele descreve as três gerações de motores de recomendação dentro do Twitter até 2016. Não parei pra ver se tem papers mais novos que continuam essa história, mas graças a isso o código liberado que tem vários trechos que mencionam RealGraph ou GraphJet, agora devem fazer mais sentido. Entenderam? Sem esse tipo de pesquisa, só lendo o código liberado, ninguém nunca ia entender do que se trata. Precisa do contexto histórico.







E isso é só a parte do motor de recomendação, existem diversas outras funcionalidades no Twitter, por exemplo, o motor de pesquisa, que é quando você faz pesquisas por palavras-chave e ele retorna tweets com esse conteúdo, que nem uma pesquisa no Google. Na figura da solução do Cassovary, que puxa dados do HDFS, que vieram do FlockDB, pra cima tem fetchers que mandam pra um serviço chamado Blender.







Blender foi um front-end escrito em Java em cima do Netty, que é a grosso modo o equivalente a um Node.js pra Java. Por baixo usa o lendário Apache Lucene como motor de procura. Lucene é feito em Java e a gente usa faz anos. Toda vez que um site tiver um campo de pesquisa, e os resultados forem bons, pode ter certeza que tem Lucene por trás. O produto mais famoso que é construído em cima do Lucene é o Elastic, também conhecido como Elasticsearch, ou o Solr da própria Apache. Full text search, correção ortográfica, auto complete, tudo isso já é problema resolvido por Lucene, Solr ou Elastic.







Só encontrei um post no blog de engenharia do Twitter e outro post de um ex-programador que trabalhou no Twitter por volta de 2012, mas além do Blender existia um outro sistema relacionado à parte de pesquisa em tempo real, que é diferente do sistema de recomendação, chamado Earlybird. E eu menciono isso porque "Earlybird" é outro termo que aparece bastante no código que foi liberado recentemente. Então agora você sabe.








Aproveitando que comecei a falar de projetos open source do Twitter, na parte do paper onde ele explica o desenvolvimento da solução GraphJet, falei que tem uma seção que fala da estratégia de IDs. Isso gerou outro projeto open source chamado Snowflake, que eu não conhecia também. Mas em dados distribuídos, IDs únicos é um problema. Por exemplo, numa tabela de banco de dados MySQL, rodando na sua máquina local, você coloca um inteiro auto incremental e esquece. Cada nova linha vai ganhando um ID como 1, 2, 3 ... 10, 11, 12 ... 1001, 1002 e assim por diante.







Ids incrementais tem diversos problemas, um deles é segurança, mas o outro é conseguir particionar esses IDs. E quando eu tenho um banco de dados distribuídos em 2 servidores? Vou só dizer que no primeiro servidor vai de 1 a 1 milhão, no segundo servidor vai de 1 milhão a 2 milhões? Isso não escala. Se você for mais esperto vai lembrar, ah, podemos usar coisas como UUID ou GUID da Microsoft, IDs de 64 bits ou 128 bits aleatórios. Ou até espaços menores de 48 bits, como MAC address de placas de rede.







Quanto maior o ID, mais espaço vai ocupar em disco e quando carregar em memória. E se vamos desperdiçar esse espaço, o ideal é que não seja aleatório e sirva algum propósito. Daí temos IDs semi-aleatórios. No caso da estratégia do Snowflake o ID é um número aleatório prefixado com um timestamp, um identificador do servidor onde está, e uma sequência numérica aleatória. Dessa forma consigo agrupar tweets que foram criados num determinado período de tempo, tenho a localização no cluster de servidores, mas também sei que não vai ter colisão desse ID com outro ID em outro servidor. Quer dizer, até pode ter colisão mas a probabilidade é hiper baixa, perto de zero, na prática.







Menciono isso porque se procurar no VS Code, olha só, Snowflake aparece em diversos lugares do código. E achamos trechos que usam a função `timeFromIdOpt` onde passamos um ID de Snowflake e ele retorna um timestamp, daí podemos fazer operações, como ver se foi criado antes ou depois de determinada data. Se estudar bancos de dados distribuídos, vai ver como existem diferentes estratégias de IDs únicos pra diferentes necessidades. 






Um banco de dados como Cassandra usa outra estratégia, chamada TimeUUID, que é muito similar, já que também tem um componente de timestamp embutido no ID, o que facilita fazer queries de períodos de tempo e análise de time series, séries de tempo e processamento de eventos. Um DynamoDB da Amazon tem um identificador único chamado de "chave de partição" que é usado pra particionar dados em múltiplos servidores no cluster. A chave de partição é combinado com uma "chave de ordenação", que é usado pra ordenar os dados dentro de uma partição.







Sem fugir demais do assunto, mas já que falei disso, preciso pelo menos explicar outro conceito. Em bancos de dados distribuídos, um problema seria se um servidor ficar mais cheio que outros servidores. Idealmente queremos balancear o volume de dados entre cada servidor. Uma das formas de fazer isso é o que chamamos de "Consistent Hashing". Esse algoritmo mapeia chaves de partição, como o Snowflake do Twitter ou TimeUUID do Cassandra em nós virtuais num anel, um ring. Cada nó virtual representa um servidor físico no cluster.







À medida que novos nós são adicionados ou removidos do cluster, os ranges de partição são redistribuídos por todos os nós virtuais, garantindo distribuição uniforme das chaves de partição. Novamente, é um problema bem conhecido e bem resolvido nos mais diversos bancos de dados distribuídos. Eu lembro quando líamos papers da Amazon sobre isso lá por 2008 e 2009. Mas pra um estudante de ciência da computação hoje, continua sendo um problema fascinante de entender, já que o conceito é bem simples. Um ID é muito mais do que só uma etiqueta qualquer. Ela serve pra facilitar pesquisas e pra facilitar balanceamento de sistemas distribuídos.








E pra terminar essa parte de open source, tem outros dois projetos que são mencionados que acho importante explicar. O primeiro se chama Thrift e o segundo é Protocol Buffers ou Protobufs. Acho que muitos de vocês já devem ter ouvido falar pelo menos de Protobufs. Bem a grosso modo, pense micro-serviços ou endpoints de APIs hoje. A maioria de vocês deve estar acostumado a ter endpoints que se comunicam ou simplesmente cospem dados em formato JSON. É o hello world de APIs em todo tutorial e curso. Só que JSON não é a única forma e pra muitos casos, é a pior opção.







JSON é um formato excelente pra endpoints de APIs que seres humanos como eu ou você vamos manipular. É indicado pra coisas como APIs de ecommerce, onde queremos puxar coisas como principais ofertas, pra mostrar no nosso blog. Mas pra comunicação entre sistemas, por exemplo, o backend do ecommerce conversar com meios de pagamento ou logística. Ou mesmo pra comunicação entre micro-serviços dentro da mesma empresa, é um dos protocolos mais porcaria que existem.






Como um exemplo bem, mas bem tosco, imagine este pequeno JSON de um produto de ecommerce. Quem já trabalhou com ecommerce sabe que é bem maior que isso, mas pra ilustrar aqui no video é suficiente:





```
{
  "product_id": "PS5-001",
  "name": "PlayStation 5",
  "description": "The PlayStation 5 is the next generation of gaming consoles, with advanced graphics, haptic feedback, and lightning-fast load times.",
  "price": 499.99,
  "availability": true,
  "images": [
    {
      "url": "https://example.com/images/ps5-001-front.jpg",
      "type": "front"
    },
    {
      "url": "https://example.com/images/ps5-001-back.jpg",
      "type": "back"
    }
  ]
}
```




JSON é um protocolo texto, onde o schema vai embutido junto com cada registro. Como falei, isso facilita pra pessoas comuns conseguirem ler sem muita dificuldade. Agora imagine um schema de Protobuf assim: 


```
message Product {
  string product_id = 1;
  string name = 2;
  string description = 3;
  float price = 4;
  bool availability = 5;
  repeated Image images = 6;
}

message Image {
  string url = 1;
  string type = 2;
}
```



Note, ele define exatamente que tipo de dados, portanto qual o tamanho exato, de cada campo de dados. Dessa forma não preciso de coisas como aspas, vírgulas, nada disso, posso concatenar um valor atrás do outro, porque o tamanho vai ser fixo. No final, o mesmo JSON, convertido em Protobuf vai gerar um linguição binário que, em hexadecimal, seria assim:


```
0a 07 50 53 35 2d 30 30 31 12 10 50 6c 61 79 53 74 61 74 69 6f 6e 20 35 1a 42 54 68 65 20 50 6c 61 79 53 74 61 74 69 6f 6e 20 35 20 69 73 20 74 68 65 20 6e 65 78 74 20 67 65 6e 65 72 61 74 69 6f 6e 20 6f 66 20 67 61 6d 69 6e 67 20 63 6f 6e 73 6f 6c 65 73 2c 20 77 69 74 68 20 61 64 76 61 6e 63 65 64 20 67 72 61 70 68 69 63 73 2c 20 68 61 70 74 69 63 20 66 65 65 64 62 61 63 6b 2c 20 61 6e 64 20 6c 69 67 68 74 6e 69 6e 67 2d 66 61 73 74 20 6c 6f 61 64 20 74 69 6d 65 73 2e 20 32 25 15 01 20 f3 26 9d 3a 40 28 01 32 2b 0a 1f 68 74 74 70 73 3a 2f 2f 65 78 61 6d 70 6c 65 2e 63 6f 6d 2f 69 6d 61 67 65 73 2f 70 73 35 2d 30 30 31 2d 66 72 6f 6e 74 2e 6a 70 67 22 04 66 72 6f 6e 74
```




É isso que a nova API com Protobuf vai cuspir. Como disse antes, ao contrário do JSON, esse formato é 100% hostil pra um ser humano conseguir ler, porém, é 100% perfeito pra um computador ler. A fase de converter o JSON numa estrutura de dados é muito mais simples. Um protobuf é muito próximo de uma struct de C, só que mais genérico pra funcionar em qualquer linguagem. O JSON do exemplo é um string que pesa quase 200 bytes. Já esse linguição, que contém exatamente os mesmos dados, pesa menos de 80 bytes. Mesmo nesse exemplo super tosco, estamos falando de uma economia de 2.5 vezes na transferência de rede, sem contar a economia de processamento.








Lembra que falei que o Twitter lida com milhões de tweets todo dia? Imagine se internamente, em todo sistema, de pesquisa, banco de dados distribuído, sistema de recomendação, filas de processamento, ficasse trafegando tudo em JSON. Terabytes e terabytes de banda sendo desperdiçados. Por isso o Twitter adotou o equivalente a Protobufs do Google, o Thrift do Facebook. Thrift e Protobuf é quase a mesma coisa.






A única pergunta que você poderia ter é: por que o Twitter não usou o Protobuf do Google então? Em vez de reinventar a roda? De fato, Protobufs foram criados antes, sendo usados dentro do Google desde pelo menos 2001, mas só foi lançado publicamente em 2008. Nesse meio tempo surgiu o Facebook, que teve problemas similares pra resolver e inventaram o Thrift, que lançaram em Abril de 2007. Por isso o Twitter só tinha a opção do Thrift em 2007. Mas pra novos projetos, especialmente que interagem com componentes como PyTorch ou Tensorflow, que também veio do Google, eles passaram a usar Protobufs e você vai achar os dois no código.







Thrift e Protobufs são protocolos de serialização de dados. Esse tipo de protocolo é ideal pra comunicação entre micro-serviços. Só que diferente de JSON ou XML, a forma de fazer essa comunicação não é via HTTP, como num web service, e sim via RPC ou Remote Procedure Call, que formaliza como um serviço chama uma função, ou procedure, de outro serviço. No caso do Google eles tem o gRPC que é um framework de RPC que tem como objetivo prover comunicação eficiente e escalável entre serviços na rede. 






Twitter não usou gRPC. Finagle é o equivalente de gRPC feito pelo Twitter, que usa Thrift pra serialização de dados em vez de Protobufs. Tem os mesmos objetivos de lidar com comunicação de alto throughput, baixa latência, na rede. Finagle é implementado em cima de Netty também, usando muita funcionalidade de programação assíncrona com Futures de Scala, que é o equivalente Promises de Javascript de hoje. E novamente, o Twitter Finagle foi lançado em 2011, o gRPC do Google só sairia por volta de 2015. O Twitter estava tendo que inventar tecnologias que não existiam ainda, por isso é um case fascinante.







Mas claro, Google sendo um nome muito maior e mais reconhecido que Twitter, matou os projetos Thrift e Finagle. Num projeto moderno, você deveria escolher Protobufs e gRPC ou alternativas mais modernas. Hoje, o Thrift ainda existe como Apache Thrift mas da Apache temos outras alternativas como Apache Avro, que foi criado mais pro cenário de streaming de dados serializados. Ou seja, quando você abre um streaming de um serviço pra outro serviço e trafega registros serializados com Avro entre eles.






Apache é um nome muito reconhecido pra quem é de Java e também no espaço de data sciences e machine learning. Quem lida com Kafka e é de Java, deve ter usado Avro como opção de serialização pra jobs em vez de Protobufs ou JSON. JSON é mais pra linguagens menores, como Javascript ou mesmo Ruby e PHP. Protobufs são mais usados em soluções que envolvam tecnologias do Google, como em Android. De qualquer forma, vale a pena estudar todas. Não ache que o mundo acaba em JSON ou XML. Tem coisa muito melhor e muito mais eficiente que é usado por sistemas realmente de grande volume. Pro ecommerce da esquina, de fato, tanto faz.







Falando em Java, acho que vale a pena eu relembrar a parte inicial dessa história. O que aconteceu justamente entre 2007 a 2010. Essa era a época que eu era mais participativo na comunidade Ruby on Rails e, claro, Twitter era um dos exemplos de maior sucesso de Rails. Mas aí veio a notícia bombástica: o Twitter declarou que estava migrando de Ruby pra Scala. E daí veio o meme que não morre de "Rails não escala". 






A forma como o Alex Payne, um dos principais desenvolvedores do Twitter descreveu, ou melhor, não descreveu os problemas que estavam enfrentando, tudo que eu expliquei até aqui, causou má interpretação e muita gente falando muita merda. Eu conversei com outro dos principais desenvolvedores daquela época, Blaine Cook, em junho de 2008. E mesma naquela época, eu também não tinha uma visão completa dos acontecimentos. Depois leiam a entrevista original que está no meu blog.






Por exemplo, da forma como Alex Payne falou, deu impressão que ele estava dizendo que Ruby on Rails não suportava conectar com múltiplos bancos de dados, o que não era verdade. Sim, não havia uma chavinha fácil, mas era basicamente uma linha extra que precisava ser colocada na classe pai de todos os ActiveRecords e dava pra selecionar onde fazer a conexão. Eu e vários outros escrevemos tutoriais de como fazer isso.






Mas a verdade é que o problema não era esse. Ninguém de fora do Twitter tinha muita noção do volume de dados que eles estavam tendo que lidar. E isso era 2007. Lembrem-se, a Amazon AWS tinha lançado não fazia um ano. Produtos que hoje são arroz com feijão, como SQS, DynamoDB, Route53 nem tinham sido lançados ainda. Firebase ainda não existia. Porra, coisas como Redis ainda não tinha sido inventado. GitHub ainda não tinha sido inventado.







A verdade é que particionar dados, organizar um MySQL em shards, e conseguir fazer uma arquitetura coesa em cima disso, não era trivial, e o Twitter estava numa fase de crescimento rápido. Não é que Ruby on Rails não escalava pra escala do Twitter. Nada em Python escalaria. Nada em PHP escalaria. Node.js ainda não tinha sido inventado também, mas também não escalaria. Entenda, havia poucas opções.






Possivelmente a opção mais completa teria sido começar a implementar um banco de dados de grafos em cima de Erlang, algo inspirado no banco de dados Mnesia que vem no OTP de Erlang. Porém, já viram Erlang? Hoje ele ainda é pouco usado, e em 2007 menos ainda. É verdade que grandes sistemas de telecomunicações já usavam fazia anos, mas era um salto bem grande pra uma tech startup tomar. 







Quais as alternativas? Eles precisavam de uma linguagem pra escrever componentes como sistemas de filas, coisas no nível de Kafka, lembrando que Kafka só seria lançado em 2011. Coisas no nível de Cassandra, que também só seria liberado publicamente pelo Facebook em 2008. Neo4J talvez fosse o componente mais próximo de se encaixar nos problemas do Twitter, mas era super novo, tinha sido lançado em 2007.







Entendem? Imagine você sendo um desenvolvedor do Twitter, vendo milhares, centenas de milhares de tweets sendo postados todos os dias, e tendo que lidar com grafos de usuários e tweets, sendo que algoritmos de grafos nunca tinham sido testados com volumes desse tipo. Numa época onde toda tecnologia de Cloud e NoSQL e Devops ainda não tinha sido inventado, onde linguagens mais comuns como Ruby, Python, PHP, Javascript, não estavam ajudando e programar em C++ ou Java, parecia ser um passo pra trás.






Elixir não tinha sido inventado ainda. Go não tinha sido lançado ainda. Rust não tinha sido inventado ainda. LLVM ainda era uma grande novidade, já que a Apple tava só começando a mover suas ferramentas e linguagens de GCC pra Clang, como conto no episódio da Apple e GPL. Mas havia uma única linguagem que talvez pudesse fazer sentido, a linguagem Scala, que tinha sido lançado já em 2001, pelo visionário Martin Odersky.






Odersky é um desses gênios incompreendidos, tanto que tirando povo da área de Java, duvido que qualquer um aqui já tenha ouvido falar dele. Mas deveriam. O cara é Ph.D de ciência da computação pela ETH de Zurique e trabalhou sob a supervisão de ninguém menos que Niklaus Wirth, o inventor de várias linguagens como Modula-2 e Pascal, e o autor do livro de estruturas de dados e algoritmos que eu usei na faculdade.





Odersky participou e fez contribuições no mundo Java desde a versão 1.1, tendo trabalhado no compilador, na implementação de Generics, e algumas linguagens experimentais como a Pizza e Funnel, que influenciaram o design do Java.





Muito antes de programação funcional ficar hypezinho de hipster sem graça, como é hoje, no começo do século, ele já vislumbrava uma linguagens que destilasse o melhor da orientação a objetos, como usar traits, que são como protocolos de Objective-C, em vez de herança excessiva, mesclado com conceitos de programação funcional. Scala já tinha higher order functions, já usava tipo Opcional, evitando os famosos NullPointerException, pattern matching e tudo que se vê em linguagens mais modernas de hoje.







Então era de fato a linguagem mais moderna que se podia escolher em 2007, mas rodando em cima da JVM, que era a virtual machine mais madura que existia. Dava pra criar aplicações que só seriam possíveis em C++ com uma fração da dor de cabeça. Pra isso custaria um pouco mais caro em uso de recursos do que se fosse puramente nativo, mas a JVM naquele ponto oferecia um ecossistema que ninguém mais tinha. 






E o objetivo do uso de Scala não era pra fazer front-end-zinho, era pra fazer os diversos componentes que eu expliquei que ainda não existiam. Começou com o projeto open source Starling, que é mais ou menos um mini Kafka, alguns anos antes do Kafka. Inventaram o RealGraph e GraphJet antes de um banco de dados de grafos maduro existir. Utilizaram coisas como Hadoop, que também faz parte do ecossistema Java. Nada disso seria possível sem ser, ou em Java ou em C++. 






Hoje em dia eles teriam muito mais opções, como o próprio Elixir, Go ou Rust, e se quisessem arriscar em linguagens mais exóticas teriam D, Nim, Zig, talvez Swift, Kotlin. Mas de novo, era 2006 pra 2007 e o relógio tava correndo. Em retrospecto, foi uma decisão muito acertada. E é por isso que o código que foi liberado é 2 terços Scala e Java. Muito das pesquisas que o Twitter fez, junto com trabalhos do Facebook, Google, Apple, Amazon, gerou o atual ecossistema de linguagens, ferramentas e plataformas pra lidar com Big Data, Data Science, Machine Learning, culminando com Deep Learning e a atual geração de inteligência artificial que todo mundo tá babando. Mas foi assim que as coisas começaram, no início do século.







Agora que temos uma noção melhor do contexto histórico, dos projetos e papers de pesquisa gerados, podemos começar a entender melhor o código liberado. Esse código é um conjunto de diversos sub-projetos. Se abrirmos o primeiro README na raíz do repositório, eles descreveram o que são cada um desses projetos. Por exemplo, SimClusters-ann é o serviço que retorna candidatos de recomendações de tweets dado embeddings de um cluster de similaridade.






Esse serviço usa o algoritmo de similaridade aproximado de cossenos. Já vou explicar isso. Segundo o README, um job constrói o mapeamento entre SimClusters e Tweets. O job grava os top 400 tweets de um SimCluster e os top 100 SimClusters pra um tweet. Pontuação de favoritos e pontuação de seguidores são dois tipos de pontuação que um tweet pode ter. Os top 100 SimClusters baseados nessas pontuações é que chamam de Tweet SimCluster Embedding.






A similaridade de cosseno entre dois Embeddings apresenta o nível de relevância de dois tweets num espaço de SimClusters. A pontuação varia de 0 a 1. A alta pontuação de similaridade de cosseno, maior que 0.7 significa que os usuários que gostam de dois desses tweets compartilham os mesmos SimClusters.






Similaridade de cosseno é um conceito de Álgebra Linear pra medir quão similar são dois vetores em termos de direção e magnitude. Eu gosto desse conceito porque expliquei isso desde pelo menos 2015 até minha última palestra pública em 2019. Quem assistiu minha palestra "Restrição == Inovação" vai se lembrar disso, e vou aproveitar pra usar os slides que eu usava nessa palestra.






Comece visualizando a página inicial do Google, o campo onde se digita palavras-chaves. Podemos digitar "apple" e recebemos páginas indexadas da web que tem essa palavra. Um amador que acabou de aprender SQL poderia pensar que é alguma coisa parecido com "select urls from pages where text like '%apple%'". 






Essa é a solução que faríamos no começo dos anos 90, antes de Larry Page e Sergey Brin inventarem PageRank, antes de Jon Kleinberg inventar HITS. Essa linha de SQL de fato vai achar todas as páginas onde aparece a palavra "apple", mas não vai saber como ordenar: qual delas é mais relevante e deveria estar no topo da lista? Pra saber relevância, precisamos de Álgebra Linear.








Tudo depende de como você enxerga o que é uma página web. Todo mundo enxerga um documento, uma coleção de palavras, que é o texto desse documento. Digamos que nosso banco de dados só tem 3 documentos indexados, como neste slide. Pra simplificar bastante, vamos assumir que nosso vocabulário é bem limitado e os documentos só tem as palavras apple e banana. O documento 1 tem 4 apples e 1 banana, documento 2 tem 3 bananas e 1 apple, e documento 3 tem 5 bananas e nenhum apple.






Podemos representar esses documentos como vetores, como  neste slide. Próximo passo, criamos um índice, que é uma lista que diz em quais documentos aparece a palavra apple e quais aparece banana. Pense em algo como o índice do seu banco de dados MySQL ou Postgres ou SQL Server da vida. Agora vamos digitar a palavra "apple" no campo de pesquisa desse nosso Google de mentira.






O truque começa em representar essa pesquisa, essa query, também com um vetor. No caso apple sendo 1 e banana sendo 0. É como se fosse um documento também. Pelo índice, podemos descartar o documento 3, já que apple não aparece nenhuma vez. Mas ainda temos o documento 1 e o documento 2. Qual deles é o mais relevante pra aparecer no topo da lista? De bater o olho sabemos que é o documento 1, porque aparecem a palavra apple 4 vezes, e no documento 2 só aparece 1 vez. Mas como um algoritmo conseguiria computar isso?







Pra isso desenhamos esses vetores num espaço vetorial, um Vector Space. No caso só temos duas dimensões, porque só temos duas palavras no nosso vocabulário. Apple é o eixo X e banana é o eixo Y. Então o vetor que representa o documento 1 seria assim: 4 unidades pra direita no eixo X, e 1 unidade pra cima no eixo Y. Já o documento dois seria só 1 unidade pra direita no eixo X mas 3 unidades pra cima no eixo Y. Finalmente o vetor da query é só uma unidade pra direita no eixo X, só 1 palavra apple, entenderam?







O lance com vetores é que agora temos ângulos entre o vetor de pesquisa e os vetores de documentos. E pra calcular a similaridade de cosseno usamos dot product, que é produto escalar. Funciona assim: vamos multiplicar apple com apple, banana com banana e somar os dois. Então vetor de pesquisa é 1 e 0, 1 apple e 0 bananas e vetor do documento 1 é 4 apples e 1 banana então a conta seria 1 vezes 4 mais 0 vezes 1, que dá 4, esse é o produto escalar.






Daí fazemos a mesma coisa entre vetor de pesquisa, de novo, e o vetor do documento 2, então o produto escalar vai ser, 1 apple vezes 1 apple mais 0 banana vezes 4 bananas, dando 1. Como o produto escalar 4 do documento 1 é maior que o 1 do documento 2, sabemos que o documento 1 tem mais similaridade com a pesquisa e, portanto, é o mais relevante pra aparecer no topo da lista.







Esse exemplo é super trivial porque só usamos duas palavras, então temos só duas dimensões. Mas vamos complicar. E se tivéssemos um novo documento indexado que tenha a palavra coco? O vetor dele poderia ser 1 apple, 0 banana e 2 cocos. Todos os outros vetores precisam ser atualizados pra conter coco, mas no caso tem 0 cocos então não muda nada. Pra representar o espaço vetorial, precisamos de uma nova dimensão Z. O vetor desse novo documento seria desenhado com 1 unidade pra direita no eixo X e 2 unidades pra baixo no eixo Z.







E podemos calcular o produto escalar entre a pesquisa e esse novo documento também. Em geometria, a gente consegue desenhar no papel até 3 dimensões, mas claro, o vocabulário de uma língua como português é muito mais que só 3 palavras. Num dicionário como o Aurélio, vai ter mais de 500 mil palavras. Portanto podemos ter potencialmente 500 mil dimensões nesse espaço vetorial. Na realidade vai ser a quantidade de palavras únicas que tem num documento, ou página web de verdade. O script deste episódio, por exemplo, tem mais de 3 mil palavras únicas. É um vetor de 3 mil dimensões.







Felizmente, produto escalar é uma operação muito rápida de se calcular em qualquer computador moderno, só somas e multiplicações simples. E é assim que funciona a base de todo tipo de algoritmo de relevância e recomendação. É isso que tem por baixo da biblioteca Apache Lucene que falei antes. E se olhar a documentação de um Elastic vai ver que menciona VSM, ou Vector Space Model, que é esse gráfico que vim mostrando, muito maior do que os 3 do exemplo. E é isso que esse projeto SimClusters vai fazer, só que com vetores de usuários e tweets.







No caso do Twitter, esse primeiro projeto se chama SimCluster-ANN. SimCluster é similarity cluster, e esse "ANN" provavelmente significa "Approximate Nearest Neighbor" ou vizinho mais próximo aproximado. Em machine learning e data mining, pesquisa de vizinho mais próximo é o problema de encontrar o ponto de dado mais próximo em um espaço de muitas dimensões, dado um certo ponto de pesquisa, onde soluções exatas são inviáveis pelo tamanho do conjunto de dados.






Algoritmos de vizinho próximo aproximado, como Locality-sensitive hashing ou LSH e métodos baseados em árvore como KD-trees, oferecem uma forma eficiente de resolver esse problema fazendo um trade off de algum grau de precisão por uma melhoria significativa em performance. Então é mais uma otimização do Twitter pra ganhar performance, mais ou menos como o random walk no algoritmo de SALSA que expliquei antes.






Nesse sub-projeto, o conceito importante são embedding spaces, que tem como objetivo responder a pergunta "quais tweets e usuários são similares aos meus interesses?". Embedding funciona gerando representações numéricas dos interesses dos usuários e conteúdo de tweets. Daí podemos calcular a similaridade entre quaisquer dois usuários, tweets ou pares de usuários e tweets num espaço de embedding.





Justamente um dos espaços de embeddings mais úteis do Twitter são os SimClusters. SimClusters descobrem comunidades ancoradas por um grupo de usuários influentes usando um algoritmo customizado de factorização de matrizes. Existem umas 145 mil comunidades, que são atualizadas a cada três semanas. Usuários e tweets são representados em espaço de comunidades e podem pertencer a múltiplas comunidades. Elas podem ter algumas milhares até milhões de usuários. Segundo o blog de engenharia, essa imagem representa algumas das maiores comunidades.






Sem entrar em muito mais detalhes, vamos bater o olho em alguns outros projetos descritos naquele arquivo README. Veja um aqui chamado "real-graph". Eu falei de RealGraph antes. Veja este "Tweepcred", que é o algoritmo de PageRank pra calcular reputação dos usuários. Temos esse "recos-injector" que é descrito como um processador de eventos em streaming pra construir os streams de entrada pra serviços baseados em GraphJet. Já sabemos o que é GraphJet, mas "recos" eu acho que significa "recomendações", então é um injetor de recomendações pra GraphJet.





Pulando lá pra baixo temos esse "light-ranker" que é um ranqueador mais leve usado pelo índice de pesquisa, o tal Earlybird que mencionei antes, que é um projeto legado e parece que ainda é usado; o componente construído em cima de Apache Lucene. O heavy-ranker está no outro repositório "the-algorithm-ml", que o blog post do Steven, que falei lá no começo, menciona e segundo o README é o responsável pela aba "Pra você" e tem aquela lista de pesos.






Nesse ponto da cadeia, depois da fase de candidate sourcing, temos uns 1500 candidatos que podem ser relevantes. Pontuação serve pra prever a relevância de cada tweet candidato e é o sinal primário pra ranquear tweets na timeline. Nesse estágio, todos os candidatos são tratados igualmente. O ranqueamento sai de um rede neural de uns 48 milhões de parâmetros que é continuamente treinada com interações de tweets pra otimizar o engajamento positivo (como likes, replies e retweets), segundo o blog de engenharia do Twitter.







Sendo bem honesto, eu não tenho certeza de como exatamente isso funciona ainda. Olha o diagrama que tem no próprio arquivo README que lista os projetos. Os dados vem dessas caixinhas intituladas "Grafo Social", "engajamento de tweets" e "dados dos usuários". Daí temos features, como o GraphJet, SimClusters, TwHIN que é outro projeto no repositório the-algorithm-ml, e serve pra pré-treinar os tais embeddings. 







Daí temos o RealGraph, TweepCred e Trust & Safety, que parece ser um projeto de tensorflow pra treinar modelos pra filtrar coisas como conteúdo pornográfico, adulto, ou o que ele considera como "tóxico". Não sabemos exatamente porque não foi liberado o modelo e nem os dados de treino. É um projeto bem pequeno e quem entende de Tensorflow poderia dizer um pouco mais, mas não tem muito pra se ver.







Continuando, temos essa coluna que ele chama de Home Mixer. Daí temos 3 fases: uma que ele chama de candidate sourcing, que é literalmente "escolher os candidatos", candidatos de recomendação. Esses candidatos passam pelo tal heavy ranker, que parece ser o modelo de machine learning via PyTorch. O resultado disso passa pra etapa final de heurísticas e filtros.






Então, pra se chegar nos tweets recomendados na aba "Pra você", na etapa de sourcing já acontece diversos filtros pra selecionar os candidatos de tweets que você pode gostar de ver. Esses "filtros" passam pelos projetos de SimCluster, RealGraph, T&S, Tweepcred, os GraphJets e são mesclados pelo projeto cr_mixer. Isso vale comentar. Os tweets recomendados, mais ou menos, são metade de tweets gerados pelas pessoas que você segue, o que ele chama de "In-Network" e a outra metade é de tweets de pessoas que você não segue, que ele chama de "Out-of-Network" e quem puxa isso é esse projeto cr-mixer.






Dado esse conjunto inicial de tweets, In e Out of network, aí vem a parte de recomendação propriamente dito usando o light ranker, o projeto Earlybird, e daí o heavy ranker. Mas antes de mandar pra você, ainda passa por um pipeline de filtros. Pelo projeto home mixer propriamente dito, esse visibility-filters que é onde está implementado a política de censura do Twitter.






Por último, tem esse projeto Navi, que parece mais recente, escrito em Rust, mas é super pequeno e não faz muita coisa. Parece mais um adaptador pra falar com os componentes de Tensorflow e PyTorch e um tal de Onnx, que eu não conhecia, mas parece que significa Open Neural Network Exchange, que é um formato open source pra representar modelos de machine learning. Foi originalmente desenvolvido pela Microsoft e Facebook em 2017 pra facilitar interoperabilidade entre diferentes frameworks de deep learning, por exemplo, entre PyTorch e Tensorflow. Mas realmente não sei como ele é usado neste projeto ainda.







Se tiverem interesse em saber mais, cada um desses sub-projetos tem um README também, então recomendo que comecem por eles. Mas como disse no começo, se tentar rodar `bazel build` em qualquer diretório, ele vai reclamar da falta de um arquivo de Workspace. Então, até o Twitter liberar isso, ou alguém se dar o trabalho de gerar na mão, não temos como compilar e nem de tentar rodar nada.    






Por isso que é meio chato, porque mesmo lendo essas coisas todas na documentação e no próprio código, não temos como testar. Basta um if que a passamos batido e talvez algum desses componentes nem rodem. É muito difícil saber o comportamento exato dum sistema grande desses sem ter uma massa de dados de entrada pra ver o que realmente é cuspido na saída.







De qualquer forma, do ponto de vista de organização, além da falta de arquivos pra fazer build, também senti muita falta de arquivos de testes automatizados. Não tem como saber se eles tiraram antes de abrir em público, se ainda vai ser liberado, ou se realmente não existem. Espero que existam, porque dar manutenção num sistema grande desses, sem testes, seria uma grande burrice. 







Se eles tivessem liberado os arquivos de testes, nós teríamos uma idéia muito melhor de como esse sistema de comporta, mesmo sem poder compilar e rodar. Testes servem como se fosse uma documentação viva de um sistema. Teria sido muito mais fácil confirmar tudo que analisamos.







Mas no geral, minha opinião é que o código Scala parece muito bem feito, dado o contexto que se trata de um legado de mais de 10 anos. Eu esperaria algo muito mais bagunçado, muito mais macarrônico. Comparado com o código do Twitch, que eu analisei em outro video quando foi vazado, eu preferiria muito mais trabalhar neste código do que no outro. 






O básico tá bem feito: métodos curtos, baixa complexidade ciclomática, nomenclatura bem feita, nada de variáveis "x" ou "y" que não dá pra saber do que se trata. Pouca coisa hard-coded, tudo organizado em arquivos de configuração, e até que bem comentados onde precisa. Não é comum ver projetos legados com esse nível de qualidade. Não é nem de longe perfeito, mas até que me surpreendeu.






Obviamente, esse repositório é só um espelho incompleto do repositório de verdade, que permanece fechado dentro do Twitter, sob confidencialidade. O código que foi liberado também não pode ser usado por nenhum projeto fechado sem liberar as modificações feitas em cima desse código. É isso que a licença AGPL que eles colocaram significa: eles não querem que ninguém adicione em outro projeto e mantenha fechado.







Depois que soltaram esse código, um bando de imbecis ficou spamando a seção de Issues, mas teve um ou outro pull request que eles aprovaram já, nada significativo. Só a remoção daquele código de métrica que tinha o "author_is_elon" que imbecis adoraram ficar fazendo meme. Não teve nenhuma contribuição significativa ainda e nem espero que vá ter, até que eles liberem os arquivos de Workspace do Bazel. 







Eu não tenho muito senso de humor pra memes idiotas e gente que acha bacana ficar pichando uma seção que deveria ser séria como a área de Issues. Quer fazer meme idiota, fica no Reddit ou no 4chan. Não tem o mínimo de etiqueta, não participa. Participação desse tipo é só idiota, não tem nenhum valor e não contribui com absolutamente nada. É só certificado de idiota mesmo.






Ao longo de mais de 10 anos, o Twitter fez sua parte e contribuiu tecnicamente. Os papers que falei, os projetos open source, os diversos blog posts de engenharia, inspiraram muitos outros projetos a tentar arquiteturas e tecnologias que, na época, sequer existiam ou se existiam, ninguém sabia se funcionava. Independente da sua opinião política, que é irrelevante, o Twitter certamente contribuiu ordens de grandeza mais do que qualquer um dos engraçadinhos que não sabem respeitar um trabalho de engenharia.






Ter acesso a esse código não me torna mais fã do Elon Musk, mas só serve pra confirmar muitas coisas que eu já sabia sobre os primeiros engenheiros do Twitter: eles foram muito bons, especialmente pra época. E pra vocês que são iniciantes, aproveitem a oportunidade pra fuçar tanto o código quanto os papers que eu citei. É assim que um produto em produção evolui. Só nesse sistema de recomendações, vimos 3 gerações diferentes de soluções, cada uma gerando mais experiência pra fazer o próximo ser melhor. Código de produção de verdade, de um produto que tem uso, nunca acaba. 






Você que é empreendedor querendo entender mais de programação, entenda: se seu código não está evoluindo, é porque seu produto é irrelevante. O Twitter existe desde 2006, e o código nunca chegou numa versão que todo mundo tirou a mão e falou "tá perfeito, não precisa mexer mais". O mesmo acontece com qualquer produto, ecommerce, elearning, fintech, todos continuam evoluindo, pivotando, ajustando e consertando pra ficar cada vez melhor. O Twitter de hoje é bem diferente do Twitter de 2007, mesmo que só pelo front-end não pareça que tenha mudado muita coisa. A cara não muda tanto quanto o backend.







Dá pra ficar literalmente dias, indo de arquivo em arquivo, tentando desvendar quem chama quem, quem depende de quem, em que momentos, quais serviços rodam pra quais tipos de dados. Mas é super trabalhoso fazer isso sem conseguir rodar nada e sem testes. Eu não acho que vale a pena, mas na internet sempre tem alguém com mais boa vontade de fazer trabalho chato como esse. Com apenas 2 dias olhando pra esse código, eu só consigo descrever até aqui.






E com tudo isso, pelo menos espero que pra vocês que sejam iniciantes, tenham tido uma perspectiva diferente do que imaginavam que seria um código de verdade de produção. Mesmo sem entender nada, deve dar pra começar a entender melhor a dimensão. Repetindo: esse repositório liberado só tem parte do código do sistema de recomendação. Não tem o front-end web, não tem o app mobile, não tem as ferramentas de administração, não tem o ferramental de monitoramento, enfim, só estamos vendo uma fração do que é feito o Twitter.






Antes de terminar, enquanto estava escrevendo este episódio, o canal Fireship lançou também um video curto falando disso. Não tem nada demais, mas eles lançaram um segundo especialmente sobre "Vector databases". Só assistindo esse video dele, duvido quem a maioria tenha entendido. Eu expliquei o que é isso durante este video, e se você já não tinha conhecimento prévio de Álgebra Linear, provavelmente entendeu mas não compreendeu. 






Enfim, o Fireship menciona bancos de dados modernos de vetores como Pinecone e Weaviate e disse que vai fazer um curso sobre isso. Não sei se foi piada, como eles sempre fazem, ou se vão mesmo, mas vou ficar de olho pra saber. Problema de um curso desses é o famoso "olha como se faz um hello world, é super simples", mas sem entender tudo que falei hoje, você vai usar sem entender. Mas assistam lá depois. Vou deixar o link na descrição abaixo.






E finalmente, isso responde outra pergunta que todo mundo tem: precisa saber matemática pra ser programador? E a resposta é não. Pra fazer coisa simples, sabendo matemática básica de regra de três e porcentagem, dá pra ir se virando. No dia a dia de software pequeno, se souber pelo menos usar uma calculadora, já funciona. Agora, sem saber Álgebra Linear, Cálculo, Estatística e Probabilidade, você nunca vai trabalhar em projetos como esse do Twitter, é uma impossibilidade. Matemática é opcional, inglês é opcional, tudo depende de quão pouco você quer ter de opções. Se ficaram com dúvidas, mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e não deixem de compartilhar o video com seus amigos. A gente se vê, até mais.

