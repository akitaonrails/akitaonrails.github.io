---
title: '[Akitando] #73 - RANT: A Realidade do "Software Livre"'
date: '2020-03-04T10:30:00-03:00'
slug: akitando-73-rant-a-realidade-do-software-livre
tags:
- software livre
- free software
- open source
- richard stallman
- GPL
- AGPL
- BSD
- fair use
- copyright
- akitando
draft: false
---

{{< youtube id="FVy1fZhNSDA" >}}

## DESCRIPTION

Muita gente acha que é defensor do Software Livre, mas na realidade não é. 

Pior ainda, por simplesmente só acreditar que está defendendo um movimento social, no final você está só defendendo o marketing de empresas e nem se dá conta disso. Nem é uma coisa completamente ruim, mas certamente não é o que sua crença diz. 

Então hoje eu vou desmistificar o que é software livre, open source e como as grandes corporações te enganaram. A idéia não é ser um vídeo completo sobre o assunto, somente sobre os temas que eu acho mais importantes pra começar.


Links:


* Affero General Public License (https://en.wikipedia.org/wiki/Affero_General_Public_License)
* What is free software? (https://www.gnu.org/philosophy/free-sw.html)
* The JavaScript Trap (https://www.gnu.org/philosophy/javascript-trap.html)
* The quietly accelerating adoption of the AGPL (https://www.synopsys.com/blogs/software-security/using-agpl-adoption/)
* What’s a SaaS to Do? The SaaS Loophole in GPL Open Source Licenses (https://resources.whitesourcesoftware.com/blog-whitesource/the-saas-loophole-in-gpl-open-source-licenses)
* Google open source guru: 'Why we ban the AGPL' (https://www.theregister.co.uk/2011/03/31/google_on_open_source_licenses/)
* Can I use the middleman loophole to reduce AGPL to LGPL? (https://opensource.stackexchange.com/questions/5010/can-i-use-the-middleman-loophole-to-reduce-agpl-to-lgpl)
* Managed Cassandra on AWS, Our Take (https://www.scylladb.com/2019/12/04/managed-cassandra-on-aws-our-take/)
* AWS and Open Source: It’s Complicated (https://www.redislabs.com/blog/aws-vs-open-source/)
* Choose an open source license (https://choosealicense.com/)
* Why Open Source misses the point of Free Software (https://www.gnu.org/philosophy/open-source-misses-the-point.en.html)
* How to decide whether to open source your SaaS solution (https://opensource.com/article/18/5/open-source-saas-y-world)
* Explaining The Fair Use Principle for Copyrighted Work (https://www.thebalancesmb.com/fair-use-of-copyrighted-work-explained-4771134)
* Copyright Definition (https://www.thebalancesmb.com/copyright-definition-2948254)
* YouTuber Extortion? MxR Plays v. Jukin - Real Law Review // LegalEagle (https://www.youtube.com/watch?v=5A_i-sB9H0Q)


AkitaOnRails:

* [Off-Topic] Software Livre: Exercício de CAPITALISMO (https://www.akitaonrails.com/2016/04/22/off-topic-software-livre-exercicio-de-capitalismo)

## SCRIPT

Olá pessoal, Fabio Akita


Eu acabei pulando o carnaval e não publicando video semana passada. Eu fiquei em dúvida entre dois temas e qual eu ia falar primeiro e os dois são trabalhosos pra explicar. Então deixei o assunto maturar na minha cabeça um pouco mais de tempo. O tema que eu escolhi falar foi sobre software livre. O problema é que software livre é um puta tema espinhoso. Se eu escolher palavras um pouco ambíguas, vai chover hater nos comentários porque todo mundo tem uma opinião forte sobre o assunto e na grande maioria das vezes elas estão erradas ou no mínimo incompletas. 





O motivo desse tema é que de vez em quando ainda me perguntam qual é a vantagem de mexer com software livre. As respostas mais comuns, de fato acabam sendo alguma coisa como "pra ajudar a comunidade" ou "pra outros poderem te ajudar". Não está completamente errado, mas não é só isso. E pensando um pouco mais no assunto, eu vejo que os motivos vão ser completamente diferentes pra pessoas e situações diferentes. Então acho que primeiro eu preciso explicar os mecanismos por baixo e daí você pode tirar conclusões melhores. Na realidade, pra variar, eu quero quebrar algumas concepções erradas que eu sei que muitos iniciantes ainda tem.





Eu já expliquei alguns dos elementos dessa novela, por exemplo, no video da Lerna vs ICE eu expliquei a diferença entre licenças permissivas e restritivas e a impossibilidade de mudar licenças retroativamente. E no vídeo sobre a Apple e GPL eu explico sobre como o GPLv3 que foi criado pra brigar contra DRM no episódio da Tivoização levou a Apple a migrar do compilador GCC para clang e evoluir o LLVM até sair a linguagem Swift.





Eu acho fascinante acompanhar as diversas novelas jurídicas e discussões filosóficas em torno de software livre e como você é facilmente enganado por ideologia barata se não parar pra ler além da propaganda. Por exemplo, talvez você ache que é um defensor do software livre usando Linux e programas de código aberto todo dia. Mas você não é 100% dentro da ideologia se navega em qualquer site moderno que executa Javascript. Já pensou porque?






(...)





Deixa eu começar com esse ponto que eu acho irônico. Muita gente pensa que usar Javascript é a mesma coisa que contribuir com o mundo de software livre, quando de fato não é. Se você é adepto da ideologia de software livre como Free Software e não somente como Open Source, você provavelmente conhece as quatro liberdade de software de cor, certo? Vamos relembrar. “Número 0 - e, claro, em programação listas começam em zero -, a liberdade de executar o programa como quiser, pra qualquer propósito.” Se você vai num Google Docs, ou Slack, ou Spotify, isso está satisfeito. Quando o seu navegador favorito carrega o site, ele carrega um monte de Javascript e executa o programa e você usa como quiser. O primeiro ponto está satisfeito.






“Número 1, a liberdade de estudar como o programa funciona, e mudá-lo pra ele computar como você desejar. Acesso ao código fonte é pré-condição pra isso.” Pronto, basicamente os principais produtos feitos em Javascript hoje quebram essa condição. O código Javascript é carregado no seu navegador, mas ele quase sempre vem em forma minificada. É impossível entender como esse código funciona porque minificação, que é uma forma de obfuscação criada pra minimizar o tamanho dos arquivos, é quase próxima de compilação. Você não tem como modificar o cliente do Google Docs ou do Spotify nem criar sua própria versão facilmente.





Continuando. “Número 2, a liberdade de redistribuir cópias para ajudar seu vizinho.” Neeeh, impossível. E “Número 3, a liberdade de distribuir cópias da sua modificação pros outros. Fazendo isso você dá uma chance pra toda a comunidade de se beneficiar de suas mudanças. Acesso ao código fonte é pré-condição pra isso.” Pois é, também não.






E antes que os haters cheguem nos comentários, calma! Eu usei Javascript de exemplo só porque é o alvo mais fácil já que a maioria de vocês estão aqui assistindo este video num front-end feito em Javascript que é o YouTube. E o YouTube não é software livre. E não só o Javascript do front-end, mas nenhum componente de nada que você usa todo dia, YouTube, Slack, Discord, Spotify, Netflix, Amazon, AliExpress, Uber, a maioria esmagadora dos softwares que você usa no seu dia a dia, são todos proprietários e fechados.






Isso não é imediatamente óbvio pros desavisados porque praticamente todas essas empresas e marcas parecem associadas de alguma forma com software livre. Em muitos casos oferecendo bibliotecas de código aberto que você pode consumir em seus próprios programas pra falar com as APIs dos produtos deles. Só que cliente de API é um software inútil sem a parte que roda no servidor. É simples entender a consequência. Você faz hoje um aplicativo que usa o cliente de API de um Dropbox. Digamos que amanhã o Dropbox feche, ou simplesmente decida fechar sua API. Seu aplicativo não serve pra mais nada. Era pra evitar esse tipo de cenário que nasceu a idéia de software livre.






Porém, o mundo SaaS inteiro se aproveita do que conhecemos como o GPL loophole. É uma brecha da licença GPL. Entenda, a GPL foi desenhada de tal forma que se você copiar um software GPL e fizer modificações, por exemplo, construindo seu produto em cima dele, e daí você comercializar ou distribuir o binário desse produto, você obrigatoriamente deveria distribuir o código fonte. Só que produtos SaaS não comercializa nem distribui o conteúdo, todo o código e binários rodam somente dentro dos servidores. E executar o código que você modificou é um direito do GPL. O que ele oferece aos usuários é apenas uma API e um front-end em Javascript com uma licença de uso remoto. E contanto que esse Javascript não contenha código GPL, também não há obrigação de abrir o código fonte.







À medida que muita coisa se move nessa direção onde tudo roda remoto, nenhum dos códigos proprietários é comercializado nem redistribuído. Porque você acha que idéias como usar iPad no lugar de Macbook ou Chromebooks são tão atraentes pra Apple e pro Google? A licença GPL não está sendo quebrada, só subvertida. O mundo de software livre obviamente notou isso e por isso existe a licença Aphero GPL ou AGPL, criada em 2002. A diferença com a GPL normal é que se você usa AGPL pra fazer um software as a service, seu código inteiro precisa ser aberto. E é por isso que nenhuma das empresas que eu mencionei e diversas outras, jamais vão chegar perto de software AGPL, porque ela basicamente quebra o modelo de negócios de SaaS como é conhecido hoje.







Um exemplo disso foi a entrevista do diretor de open source do Google em 2008, Chris DiBona que declarou que AGPL é banido dentro do Google. Toda grande empresa que se preza tem um departamento preocupado em avaliar todo o software desenvolvido internamente e suas dependências porque com o tanto de gerenciadores de pacotes que puxam coisas de fora como NPM pra Javascript ou Pip do Python e outros, é muito simples uma biblioteca GPL ou AGPL acabar entrando sem querer e contaminar todo o código. É um problema sério isso. Por isso todas as empresas vão sempre escolher licenças permissivas como MIT ou BSD ou derivadas delas.






Não existe nada como o passar do tempo. 20 anos atrás empresas como Apple, Microsoft ou Oracle eram os inimigos número 1 do software livre. Mas essa imagem foi revertida, e não é porque eles aderiram ao software livre, mas porque aprenderam como subverter a idéia toda. Hoje em dia a gente quer mais conveniência do que liberdade. Na verdade, hoje estamos mais dispostos a abrir mão de parte da liberdade em nome de mais conveniência e por isso todo mundo está em jardins fechados, os walled gardens, como dentro do ecossistema Apple, ou Amazon, ou Google ou similar. Todo o software que você usa e todos os dados que você deixa pra trás estão fora do seu controle, não importa se você usa Linux ou não. É o oposto de livre. Até mesmo quem está reclamando de privacidade continua dentro desses ecossistemas.








Antigamente você podia ter uma máquina Linux, com software 100% livre, rodando offline na sua máquina e ser razoavelmente produtivo. Mas hoje você não tem mais como, na prática. Se você trabalha remoto, vai ser obrigado a usar um comunicador, e ele vai ser um Slack ou similar, que é fechado. Se precisa compartilhar arquivos vai ser obrigado a usar um Dropbox ou OneDrive ou Google Drive, todos fechados. Se precisa compartilhar documentos, vai acabar usando Google Docs ou ironicamente Office online, e eles são fechados. Basicamente, tudo que não funciona se você fica offline, é software proprietário que encontrou caminho pra dentro do seu Linux.







Dá impressão que não é nada demais porque você não tá instalando manualmente nenhum binário proprietário na própria máquina. Na verdade, é pior: agora você não tem nem o binário mais: fica tudo remoto. Você abriu mão até do binário. Pior ainda, em vez de pagar uma única vez pelo software, você paga uma assinatura pelo direito de uso temporário desse software remoto. Pare de pagar e você não tem mais acesso ao software e muitas vezes nem aos seus dados. Não tem nem como piratear esse software, porque não existe mais um binário. No máximo um front-end  e um cliente de API, que são meras cascas descartáveis. Nem o conteúdo que você gera nesses softwares fica mais na sua máquina, fica na sua conta online do Google, ou da Apple.







Mas e o tanto de software livre que existe hoje em dia em lugares como GitHub? Sim, existem diversos softwares muito importantes e muito bons de forma livre e aberta. Só não os que você precisa usar todo dia. Com o passar do tempo e a maturidade no entendimento de software livre pelas empresas, um modelo ficou mais óbvio: mantenha todo o código crítico dos seus produtos fechados, mas abra alguns que podem se beneficiar da contribuição de fora. 







A kernel do Linux é um exemplo disso. É muito caro pra uma empresa criar e manter seu próprio kernel, que dirá seu próprio sistema operacional inteiro. O valor desse desenvolvimento e manutenção não compensa o investimento. Portanto é vantajoso dividir esse custo com outras empresas. O Linux é o que é hoje por causa do investimento compartilhado de dezenas de empresas da Linux Foundation que pagam programadores pra manter seus interesses em dia. Empresas como IBM, Microsoft, Intel, Oracle, RedHat, e várias outras. E todo mundo se beneficia disso. É um compromisso pragmático. Não soa tão legal se você for um purista que achava que um Linux da vida era feito só com programadores anônimos voluntários aleatórios, mas essa é a realidade.







Pra um Google compensa manter sua linguagem, o Go, como código aberto. Nem tanto pra ganhar contribuições de fora, mas porque eles precisam constantemente contratar bons engenheiros. E é sempre melhor se os candidatos aparecerem já dominando a linguagem que eles usam. Mas não espere que eles liberem o código fonte do algoritmo de pesquisa, ou do banco de dados BigTable, ou qualquer outra coisa assim que se usa internamente. Esses códigos sempre foram e sempre vão ser fechados. 






Mesma coisa o Facebook, pra eles compensa contribuir com linguagens como PHP, que eles usam internamente, vale a pena liberar o React como código aberto. Novamente eles precisam recrutar engenheiros o tempo todo. Essa é a principal motivação pra manter uma comunidade externa de desenvolvedores. Brigar contra software livre nos anos 90 e começo dos 2000 se mostrou extremamente danoso. A Microsoft sofreu isso na pele, sendo corretamente reconhecida como inimigo da liberdade.







Pra contratar bons profissionais, especialmente em um ambiente de abundância excessiva de hoje, com vários outros competidores, essas empresas precisaram mudar a estratégia. O marketing precisava mostrar que eles não eram o inimigo. Só que abrir o código secreto dos seus principais produtos nunca foi uma opção. Em vez disso elas se tocaram que dá pra pagar um preço mais barato e colher os mesmos benefícios. No começo dos anos 2000 todos os departamentos jurídicos já se atualizaram sobre as leis de propriedade intelectual de código frente a licenças de código aberto. O truque é simples: primeiro de tudo, você não precisa abrir o código dos produtos mais importantes, só do que não é crítico, como clientes de API, linguagens de programação, frameworks, bibliotecas, tudo aquilo que é commodity. Segundo, nunca usar GPL e muito menos AGPL internamente.








Felizmente pras empresas, depois do movimento de software livre, que é de fato um movimento social, ganhou força o movimento open source ou código aberto, que é um movimento pragmático de uma metodologia de desenvolvimento. Software Livre de verdade quase nenhuma empresa de fato adotou em seu núcleo e você vai notar que todas elas escolhem falar “open source” ou código aberto e raramente “free software” ou software livre. Open source é muito fácil de adotar porque elas costumam preferir licenças permissivas como MIT e BSD em vez de licenças restritivas como GPL e AGPL. O movimento open source meio que “matou” o software livre. E como pra maioria da população, incluindo a maioria dos desenvolvedores que nunca vão estudar sobre isso; open source e software livre são parecidos o suficiente pra passar batido. 






Podem dar uma olhada nas suas empresas favoritas e quais projetos abriram e quais são as licenças. A licença do Go? É similar a um BSD. A licença do V8 que é o coração do seu Javascript? É similar a um BSD. A licença do React? É MIT. A licença do novo Terminal do Windows que roda Bash? É MIT. A licença do VS Code? É MIT. Eu poderia apostar que a maioria das coisas que você usa no seu dia a dia, tirando o Linux, não é GPL. Ou seja, não é software livre, é só open source. Então todo mundo começou a adotar open source sem pensar muito e achando que é tudo a mesma coisa. Mas qual a importância dessa diferença?






Pense na Amazon Web Services ou AWS. E pra não ser injusto pense também no Google Cloud ou Microsoft Azure. Use qualquer um dos produtos deles, seja AWS Lambda, seja Google App Engine, seja Azure Machine Learning. Você nunca mais vai sair deles. Porque as alternativas são todas incompatíveis e uma vez que seu negócio estiver rodando em alguma delas, você está preso. Pelo próprio tamanho, escopo e complexidade, é praticamente impossível ter opções de código aberto que você poderia rodar no seu próprio servidor. E o modelo de negócio de vender assinaturas em vez de licenças tornou tudo tão mais barato e acessível, que você sequer conseguiria manter algo similar a um custo equivalente. Esse é o poder da adoção em massa num período de abundância econômica.








Antigamente a gente se preocupava que se todo mundo continuasse a usar Office, todos os documentos do mundo um dia poderiam ficar ilegíveis se o Office sumisse, ou se decidíssemos que não queríamos mais pagar a Microsoft e sim outra alternativa. Era um caminho sem volta. Deu um trabalhão e pressão de governos pra fazer a Microsoft criar um formato aberto que são os atuais DOCX e XLSX pra Word e Excel por exemplo. O antigo formato DOC e XLS eram binários fechados e sem documentação. As versões novas são basicamente arquivos XML abertos compactados num zip. Levou anos pra conseguir isso e hoje em dia ninguém mais dá a mínima porque edita dentro do Google Docs e ninguém sabe internamente que formato que eles usam. Como ele exporta em formatos conhecidos a gente não liga tanto. Pior, a gente não baixa e guarda os arquivos na própria máquina, todo mundo se acostumou a confiar no servidor do Google como mais seguro. Como foi que começamos a abrir mão das nossas propriedades assim?







A resposta é simples: nós somos baratos. Eu não lembro mais a fonte mas eu acho que o case de marketing que me contaram era assim. Cervejarias de diversas marcas precisam competir pra serem escolhidas pelo consumidor. Não lembro se foi a Heineken que teve a boa idéia de distribuir cerveja grátis ou muito mais barato pras fraternidades de faculdades, pras cervejadas e festas de estudantes. Óbvio, se todo mundo aprende a tomar Heineken na faculdade, as chances de continuarem a tomar Heineken quando se formarem e entrarem na vida adulta aumenta muito.







Toda empresa que pode faz isso. Sempre que você vê uma grande marca patrocinando eventos em faculdades, dando descontos generosos nos seus produtos, custeando salas de computador e material de aprendizado, não é porque eles são bonzinhos. Eles estão competindo pela sua fidelidade exatamente na época onde estudantes são facilmente compráveis com um coffee break barato em evento e algumas camisetas e stickers. É muito barato comprar a fidelidade de estudantes. E como funciona! Não faz sentido na minha cabeça ser fã de empresas. Eu pago pelos produtos, e pronto, eu não sou outdoor ambulante pra ficar carregando a marca delas de graça, ou em troca de um brinde.








Se parece um exagero, vamos olhar a AWS. A comunidade de desenvolvimento em geral parece gostar bastante dela, afinal a grande maioria das tech startups e produtos web escolhem ela como primeira opção. Afinal ela oferece suporte de muitos produtos open source que você quer usar como o MySQL ou Postgres no produto RDS ou o ElastiCache que implementa Memcached e Redis. Em dezembro teve o evento deles, o AWS re:Invent onde muita gente comemorou que eles vão começar a oferecer o NoSQL Cassandra como opção gerenciada, o que deve aumentar adoção do Cassandra por mais gente. Note que toda propaganda da AWS sempre faz menção de como eles gostam de contribuir com o mundo open source. E se eu parar aqui, realmente parece que é isso mesmo.









Vamos aos fatos. Segundo o blog post da RedisLabs, que é a mantenedora do Redis e que já tiveram vários problemas com a AWS, novamente, o que a propaganda diz não é a realidade. Pra começar a AWS não está oferecendo o Cassandra. Na verdade é só uma camada de compatibilidade. Eles vão oferecer uma API compatível com o Cassandra mas que internamente vai falar com o produto DynamoDB que eles já oferecem faz anos. Segundo a equipe do ScyllaDB que é uma implementação aberta de Cassandra em C++ esse produto da AWS não vai oferecer coisas essenciais a usuários de Cassandra como suporte multi-região, não vai ter UDT, não vai ter alter table, não vai ter counters, não vai ter views materializadas, não vai ter como carregar SSTables diretamente. É uma versão simplificada que “parece” Cassandra mas na verdade é o DynamoDB por baixo.







É como se no ano 2000 a Microsoft falasse que está lançando o MySQL. Só que por baixo dos panos na verdade é uma versão frankenstein do MySQL que recebe os comandos compatíveis de MySQL e só traduz pro SQL Server que é quem de fato vai estar rodando. A AWS está fazendo exatamente isso: um frankenstein do Cassandra pra receber os comandos, por exemplo tudo da API CQL e vai mandar pro DynamoDB. Os preços inclusive são basicamente do DynamoDB só que 16% mais caros pra ter essa camada por cima. E por isso não tem como ter todas as funcionalidades do Cassandra de verdade.






E essa não é a primeira vez, eu disse que o povo da RedisLabs tem problemas com a AWS porque o produto ElastiCache que suporta Redis, como o nome diz, é voltado primariamente pra ser só um cache, e não inclui suporte a funcionalidades chave que tornam o Redis viável pra ser um broker persistente de mensagens ou mesmo um banco de dados primário. Do ponto de vista da AWS se você precisa de mensageria ou suporte a pubsub deveria estar usando SQS ou SNS e se quer um banco de dados primário deveria usar o DynamoDB ou RDS. O Redis é bem mais do que a AWS oferece no ElastiCache. 






A mesma coisa acontece com o MongoDB da AWS. O MySQL da AWS se não me engano também não é o mesmo MySQL que você instala no seu Linux, é uma modificação interna que eles não abrem o código. E ao fazer isso, a Amazon divide as comunidades em duas: as que optam pela versão completa e realmente aberta e as que se acomodam às limitações dos produtos da AWS. É literalmente uma apropriação: agora que todo mundo gosta do Redis, vamos nos apropriar do nome Redis mas oferecer um produto inferior mas que pelo menos é mais conveniente de usar pra maioria das pessoas, já que a maioria sequer sabe a diferença.







Por menos que isso a Microsoft foi julgada como inimigo 20 anos atrás. E eu nem estou defendendo que eles deixaram de ser, só aprenderam a se marketar melhor. Porém, quando foi a última vez que você ouviu qualquer coisa negativa assim da AWS? Pois é. Esse é o resultado de um marketing muito bem trabalhado pela Amazon. Eles tem muito mais fãs do que detratores. E o mais interessante é que ela é bem vista como amiga do mundo de software livre. 






Se não ficou claro ainda, deixa eu desenhar: a AWS de hoje é a Microsoft dos anos 90. É a mesma tática, só que executada com muito mais finésse e pzazz. E isso não é uma exclusividade da Amazon. Você vai encontrar exemplos similares de todas as empresas que você é fã, seja Google, Facebook, Apple. E todos eles fizeram a lição de casa. Por exemplo, eles tem dezenas de programadores influencers como MVPs, evangelists, advocates ou seja lá qual é o título hoje em dia. Estão todos nas folhas de pagamentos deles. São todos recursos de marketing, não do desenvolvimento core de verdade. Eles patrocinam eventos e distribuem brindes em todos os lugares. Sempre que podem repetem como o mundo open source é importante e como eles apoiam. E com isso dobraram a opinião pública e hoje são os heróis do software livre. Richard Stallman e Eben Moglen estão se revirando em seus caixões.






Com tudo isso que eu disse, pode parecer que eu sou um defensor do software livre. Mas eu não sou não, nunca fui e não tenho vocação pra ser. Eu sou pragmático, eu me adapto às limitações de cada era. Eu nunca usei Linux porque queria participar do movimento de software livre. Eu sempre usei open source porque me interesso por tecnologia tanto em plataformas abertas quanto fechadas. Mas eu não posso evitar e dar risada se você se considera um defensor do software livre e diz isso vestindo uma camiseta da Amazon ou do Google. Seu preço é um brinde de evento, você é uma propaganda ambulante que custa barato e ainda não entendeu como as coisas funcionam.






Agora, falando de forma pragmática. Eu tiraria proveito desse momento. Como eu já venho repetindo em todos os meus vídeos, estamos num período da abundância. E goste disso ou não, essas empresas estão no topo do jogo. Se você tem ideologia de software livre e não gostou do que acabou de descobrir sobre a AWS, não seja ingênuo de achar que Google Cloud ou Microsoft Azure ou qualquer outro são diferentes. Digamos que você use Google AppEngine e você acha que é o super defensor do mundo de software livre porque programa em Python. Só que sua aplicação usa o DataStore do Google, que é um software proprietário e fechado. Pois é. Essa é a realidade.







Eu sinto um pouco de pena por quem é defensor de software livre, ou mesmo de quem é defensor da liberdade em geral, porque o voto da maioria dos programadores foi abrir mão da liberdade por conveniência. Antigamente o mantra era que o conhecimento e a informação querem ser livres. Mas acho que as pessoas em geral não fazem tanta questão assim disso. Independente de qual lado desses movimentos você está, a importância de ter contato com software livre também é entender como as coisas funcionam no mundo real. Em particular eu gosto da parte jurídica disso. E o tema que você precisa entender é copyright e propriedade intelectual.






Nunca, em hipótese alguma, use um código que você achou num GitHub da vida que não tem nenhuma licença ou copyright. É pedir pra ter problemas jurídicos depois. Se você desenvolve produtos web e o que eu falei até agora foi novidade, reveja todas as dependências que você usa e garanta que não existe código AGPL misturado. Se você desenvolve produtos mobile e distribui os binários, veja se não está usando alguma dependência GPL. GPL e AGPL são licenças virais, eu expliquei isso no video da Apple e GPL. Todo código que toca neles se torna automaticamente GPL ou AGPL e sua obrigação é abrir todo o código que você escreveu. Não existe nenhum problema em usar GPL ou AGPL, eu até acho que muitos casos deveriam usar, mas não se meta com licenças se você ainda não estudou como elas funcionam.






Na dúvida, a recomendação costuma ser pra escolher licenças permissivas como MIT ou BSD. Toda vez que você cria um repositório no GitHub ele te lembra pra você escolher uma licença. Quando falamos em liberdade você precisa entender o seguinte: licenças restritivas como GPL ou AGPL promovem o software livre, ou seja, estamos garantindo a liberdade do software e protegendo os usuários, mas restringindo a liberdade dos desenvolvedores. Licenças permissivas como MIT ou BSD estão promovendo a liberdade dos programadores e das empresas, mas não necessariamente do software e nem dos usuários. Ou seja, se você desenvolve um produto usando software com licença BSD, você não é obrigado a abrir o código que fez, você faz o que quiser, pode inclusive comercializar e nunca abrir o código. Você tem liberdade de escolher o que fazer. Entenderam?





Tirando a parte ideológica e filosófica, software livre e open source são um pequeno caso de leis de copyright e propriedade intelectual. Eu não tenho treinamento jurídico nisso portanto tudo que eu disser a respeito, não considerem como conselhos legais, mesmo porque eu nem posso advogar nada. De qualquer forma é um assunto muito interessante especialmente se você se considera criador de conteúdo. Só porque você pode baixar e editar algum código, não quer dizer que você tem licença vender. É a mesma coisa com código e qualquer outro produto de criação como video, áudio, imagens e tudo mais. Se você encontra na internet talvez só tenha licença pra ver, mas não pra usar. E se usar, você não pode declarar ignorância da lei. Ser ignorante da lei não o torna isento da lei, isso vale pra qualquer coisa. 






Em resumo super resumido, copyright é literalmente o que o nome diz, o direito de cópia. E a única pessoa que tem o direito de cópia sobre uma criação é o próprio criador. Esse direito é automático. Propriedade Intelectual é bem mais complicado e depende de pesquisa pra garantir que não havia obra igual ou similar já registrada antes. Licenças de software como a GPL foram chamadas de copyleft. Na realidade é um copyright onde o criador dá a licença de uso e modificação da criação se a pessoa obedecer as restrições da licença, que são as quatro liberdades que eu disse logo no começo do video. GPL é uma subversão do copyright, na prática é uma licença que restringe o uso, por isso chamamos de restritivas.






Em coisas fora de software, como este video, eu só posso usar coisas que eu comprei a licença. Por exemplo, a vinheta de entrada eu comprei. As músicas que eu uso em todos os vídeos são licenciadas pelo site Epidemic Sound. E nos casos onde eu uso pequenos trechos de músicas de filmes por exemplo, eu tento ao máximo estar próximo do que se chama de Fair Use. Essa parte da lei é a complicada, que é o limite de até onde você pode usar a criação de outra pessoa de forma que não entre em conflito com seu copyright. Um exemplo simples era antigamente que a gente fazia mix tapes, ou fitas cassetes com nossas músicas favoritas pra ouvir no carro. Se eu tinha a fita ou CD original comprado, eu tinha direito sob o Fair Use de fazer uma cópia pessoal para uso pessoal. No minuto que eu vendo a fita, aí eu infringi a lei, e vira pirataria. Se você assina um Spotify hoje, você concordou com os termos da assinatura, e você só tem a licença pra ouvir a música, mas não pode baixar e ouvir fora do Spotify. Muito menos usar as músicas inteiras ou mesmo trechos dela. E você não pode reclamar, a conveniência de pagar mais barato é que você abriu mão do fair use.







Na dúvida: não copie o que não é seu. Pra todo o resto, consulte um advogado especializado em propriedade intelectual. E já aviso que muitos vendem bullshit, então tomem cuidado e exercitem o pensamento crítico. Muita gente que quer empreender tem essas dúvida quanto ao software que estão desenvolvendo. Alguns acham que precisam registrar esse software. Mas isso é um dos bullshits: seu software nunca vai estar finalizado, você vai mudar ele o tempo todo. E provavelmente é um produto web as a service, que nunca vai ser exposto.






Digamos que alguém copie seu software e lance um concorrente de alguma forma. Essa é outra preocupação. Mas minha resposta pra isso é simples: se seu produto é tão frágil que só de copiar o código qualquer um consegue lançar um concorrente melhor, eu diria que sua empresa está muito mal montada. A marca, a operação, a comunicação, a reputação e tudo mais fazem o produto e não só o código. O código é só uma pequena parte de uma empresa de produto. Se seu negócio vai pros ares no segundo que alguém lança um concorrente, eu questionaria a necessidade da sua empresa existir. 






Registrar seu software não vai servir pra muita coisa. Se você teve uma idéia realmente original, de novo, consulte um advogado e consiga uma patente. Agora, copyright, propriedade intelectual, patentes, não são coisas que se enforçam sozinhas também. É obrigação do detentor da propriedade de proteger sua própria propriedade, então se alguém infringir sua propriedade você deve acionar seu advogado pra começar os procedimentos legais. Mas isso não é barato, é extremamente caro na realidade, estamos falando de centenas de milhares de reais pra mais. A hora de advogado é muito caro, e se você perder você arca com os custos do outro lado também. Portanto não é algo que você vai usar tão cedo. De curiosidade eu recomendo dar uma olhada num caso recente da Jukin Media vs MxR que é explicado num canal que eu gosto bastante que é o Legal Eagle onde um advogado de verdade discute um caso de disputa de copyrights do ponto de vista legal e não do seu ponto de vista do que você acha que é certo ou não. 








A discussão sobre propriedade e copyright é a parte mais cabeluda e não existe um consenso. Depende do caso. A legislação varia de país pra país e se quiser ter segurança sobre o assunto, consulte um advogado. Mas em princípio existem os que acreditam que tudo que alguém cria deveria ser domínio público e os que acreditam que tudo que alguém cria é propriedade do criador. Eu pessoalmente sou do segundo campo, tudo que você cria é automaticamente seu. Daí você tem a escolha do que fazer, se você acha que quer deixar os outros usarem, então é seu direito conceder a licença de uso. Do lado de quem usa também, se você aceitou o trabalho de alguém, você tem obrigação de seguir a licença que foi anexada nela. Esse é o protocolo. 






Isso tudo dito. Por que uma empresa abriria seu código como software livre ou open source? Dezenas de motivos e dezenas de estratégias. Mas mais importante, só porque você abriu o código não tem nenhuma garantia que alguém vai adotar. Muita gente pensa que abrir o código automaticamente vai trazer gente pra colaborar. Eu diria que se você está aqui se perguntando isso, provavelmente é porque não deveria tentar ainda. Vá estudar primeiro e participar de projetos que já existem pra entender como funciona. Pare de ver videos ou blog posts pra achar essa resposta. Não é barato manter o software aberto. Alguém precisa manter esse projeto ativo, responder dúvidas, orientar os possíveis voluntários, avaliar as contribuições o mais rápido quanto possível, manter o software estável pra quem está usando, manter canais de comunicação ativos e assim por diante. Repito, não é de graça manter um projeto open source.






Depois que sua empresa já estiver inserida em projetos abertos, tiver prática, entender a cultura e as licenças, é possível sim fazer bastante coisa. Um dos exemplos mais simples são projetos com licença dupla. Sim, você pode ter uma licença aberta e outra licença fechada. Um exemplo é o próprio MySQL. O conceito é simples, se seu software já tem sucesso você pode abrir ela com licença GPL, dessa forma você garante que outra empresa não pode copiar seu código e lançar uma versão própria fechada. Se outra empresa modificar o código, ela tem obrigação de soltar essa modificação ou ela vai estar infringindo a licença. Mas se uma empresa precisa fazer isso, ela tem a opção de te contatar pra comprar sua licença proprietária que dá o direito dela modificar o produto internamente e não liberar o código. É um modelo de negócio. Se ela é efetiva ou não, depende do negócio e, de novo, consulte seu advogado.






Você enquanto desenvolvedor, porque contribuir em projetos open source? Primeiro, porque você tem um problema com o software que você usa e quer ver consertado ou você quer uma funcionalidade que a comunidade não parece interessada em fazer. A idéia toda de open source é que você coce sua própria coceira. A postura da maioria dos desenvolvedores é ser bem folgado, povo só posta “ow, e aí, quando vocês vão fazer a funcionalidade lá que eu pedi 2 meses atrás?” Folgado pra caramba. Povo que mantém os projetos tem que ser super paciente, porque se fosse eu já respondia “eu vou fazer a hora que você me pagar, folgado”. Se você é desenvolvedor e nem você que precisa da funcionalidade se deu ao trabalho de tentar implementar, porque outra pessoa vai fazer pra você de graça? Se liga, é assim que você começa com o pé esquerdo.






A idéia de trabalho voluntário em projetos abertos parece algo estranho, mas não é tanto assim. Pra começar é uma base de treinamento. Você que é iniciante, você acha que já é o pica das galáxias, que manja do código? Eis um excelente lugar pra provar isso. Resolva um problema seu e ao mesmo tempo demonstre suas capacidades com código. Tem gente que acha que só deve escrever uma linha de código se é pago pra isso. Eu questiono se esse tipo de pessoa realmente gosta de programar, e se for esse o caso, eu não vejo crescendo como programador. Um bom programador escreveria código sozinho, sem ninguém ver, só pelo prazer ou vontade de programar, independente se alguém fosse ver ou não.






Mais do que isso, antigamente a gente não tinha referências pra saber o que é considerado um código bem feito ou mal feito, em que velocidade certos códigos são feitos, as diferentes alternativas de código pra resolver o mesmo problema. Você tem à sua disposição hoje, milhares de projetos abertos, gratuitamente disponíveis, que você pode fuçar quanto quiser. Mesmo se não tiver vontade de contribuir, eu fico pasmo que poucos iniciantes estão baixando esses códigos e estudando. Toda nova biblioteca ou programa útil que aparece, se me interessa eu baixo o código e vou olhar como foi implementado essa ou aquela função que me interessa e sempre me dá algum insight de “ahhh, dá pra fazer assim!” e isso vai se aculumando ao longo dos anos.






Eu mesmo fiz poucas contribuições em projetos open source. Quando eu tava na faculdade, quando eu ainda era um programador júnior, eu não era o melhor programador. E era bem difícil de contribuir em projetos abertos naquela época. Se você viu meus vídeos de Git eu expliquei porque. Foi só depois de 2008, ou seja, quase 20 anos depois que eu comecei a aprender a programar, que contribuir em projetos open source se tornou fácil como é hoje. Eu teria sido um programador muito melhor se desde o começo eu tivesse conseguido contribuir e criado essa rotina.






Mas tanto empresas quanto programadores, a intenção deste vídeo foi colocar suas expectativas em dia. Open source não é mágica. Só porque você abriu seu código, não quer dizer que alguém vai se interessar por ele. Na verdade é até uma boa se quiser testar, você abre seu código e vê que zero pessoas se interessaram. É uma boa evidência que esse código que você achava legal na verdade não tem tanta serventia pras pessoas, ou você que é muito ruim de comunicar os benefícios. De qualquer forma é um feedback útil. Mesma coisa se for um desenvolvedor, se suas contribuições que você achava que eram boas forem rejeitadas, é um bom feedback pra melhorar. E é isso que a maioria das pessoas precisam de qualquer forma: feedback. É como se você tivesse programadores sêniors do seu lado apontando seus erros. Só isso já tem muito valor. Por isso que apesar do trabalho ser voluntário, estão existindo trocas entre você, o projeto e os outros colaboradores. Isso não é caridade, são trocas voluntárias pra mútuo benefício.








Além disso, da mesma forma que você escolhe entrar, qualquer hora pode escolher sair. Jamais pense que alguém te deve alguma coisa só porque você fez uma contribuição. É outro bom exercício pra entender o valor das coisas. Você contribuiu pra coçar uma coceira sua. Se outra pessoa se beneficiou disso, bom pra ela, mas isso foi o efeito colateral. Se outra pessoa fez melhor uso da sua contribuição do que você mesmo, melhor ainda pra ela, e bom aprendizado pra você também. Não existe mérito automático, mérito é algo que você conquista, nunca vai ser dado pra você independente da quantidade de esforço que você fez. 





Enfim, o mundo de software livre não é tão ideológico como você poderia imaginar no começo. As grandes empresas já entenderam como formular estratégias onde eles podem alocar projetos open source como bons canais de marketing e de contratação de talentos. E isso não é uma coisa totalmente ruim, basta que você como desenvolvedor não fique perdendo tempo sendo fanboy de empresa e use o que está disponível como material grátis pra sua própria evolução. Essa é a única coisa que interessa pra um programador. Os brindes são inúteis, mas os códigos, sejam eles abertos via licenças permissivas ou via licenças restritivas, são códigos úteis. Pode ser que esse mundo abundante suma amanhã, então aproveite enquanto ela existe. 





Eu já ouvi muita gente reclamar que mora em lugares afastados, cidades pequenas, que sequer tem empresas ao redor onde elas podem começar a trabalhar. Em muitos casos, projetos open source podem ser a única fonte de conhecimento e contato com outros programadores. E mais, você tem a oportunidade de fazer código e receber feedback desse código. Se o feedback for negativo, você finalmente sabe no que precisa melhorar. Em vez de pensar mesquinharias de “ah, mas eu vou estar trabalhando de graça” eu pensaria diferente “puxa, eu estou recebendo feedback de graça”. E com o tempo, se você se dedicar de verdade, é possível montar um bom portfolio de contribuições em projetos relevantes que chamem a atenção de outras empresas procurando alguém como você. E por hoje vamos ficando por aqui, se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video mandem um joinha, assinem o canal, não deixem de clicar no sininho pra não perder os próximos episódios e ajudem o canal compartilhando o video com seus amigos. Este mês vai ter menos vídeos porque vou passar as próximas semanas nos Estados Unidos, então a gente se vê na minha volta. Até mais.
