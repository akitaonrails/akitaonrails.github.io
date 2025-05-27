---
title: "[Akitando] #22 - Blockchains servem pra Eleições?"
date: '2018-10-30T17:00:00-03:00'
slug: akitando-22-blockchains-servem-pra-eleicoes
tags:
- blockchain
- eleições
- segurança
- fraude
- nosql
- THE CONF
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


{{< youtube id="KXG-upUkSZE" >}}


### Descrição no YouTube

As eleições acabaram de acabar, independente do resultado (eu gravei este vídeo um dia antes da votação) o assunto é relevante do mesmo jeito. Muitos se perguntam: é possível usar blockchains nas eleições públicas?

Na minha conferência THE CONF, que aconteceu no fim de Setembro deste ano, tivemos a ilustre presença do professor Diego Aranha. A gravação de sua palestra sairá em breve no canal da InfoQ Brasil. Mas juntando o que aprendemos com ele e o que eu sei de blockchains, quero dar uma explicação clara de porque blockchains não serviriam pra eleição que acabamos de ter, por exemplo.

Links:

* Discussão no Facebook que originou o vídeo: https://www.facebook.com/fabio.akita.profile/posts/10156823734709837?__xts__%5B0%5D=68.ARAAVbex2W97zViAmD7hbUmyD0yY9pJfqulyh9P7AfBkPttJD1cLOQzlGe1zap-S8tlRJ4mVuWu7Mul2s5682fju-RrBFzDqPMGdwxqXRmvKcDjY8bZj26jInugN1jCwF-vLWyV1K0-c_KynmquWpSe9UHNtLX-moYFnAv2EIG9s5WwqGHITXEnaqfsgd8Oj6QDQVRPI-suxfkvomVjTyTtaWAzv5Q&__tn__=-R

* THE CONF (https://www.theconf.club)
* InfoQ Brasil (https://www.youtube.com/channel/UCjiSYWQhLi9a4znW2h5pCrg)

* Bolsonaro chama especialista em blockchain para fazer auditoria nas urnas eletrônicas (https://portaldobitcoin.com/bolsonaro-chama-especialista-em-blockchain-para-fazer-auditoria-nas-urnas-eletronicas/)
* TSE autoriza técnicos de Bolsonaro e Haddad em sala-cofre da apuração (https://www.poder360.com.br/eleicoes/tse-autoriza-tecnicos-de-bolsonaro-e-haddad-em-sala-cofre-da-apuracao/)
* Site sobre Urna Eletrônica (https://urnaeletronica.info)

## Script

Olá pessoal, Fabio Akita

Bom, as eleições já passaram, espero que todo mundo tenha voltado ao normal depois desse longo apocalipse zumbi digital. Bem vindos de volta.

Um dos assuntos controversos que, pra variar, não chamou a atenção que deveria é sobre a urna eletrônica. Este episódio não é sobre urna eletrônica, então calma aí. Se você me acompanha e participou da minha conferência, a The Conf, teve o prazer de assistir a palestra do professor Diego Aranha, que gentilmente veio compartilhar seus trabalhos conosco antes de partir pra Dinamarca onde trabalha agora. Sua palestra é detalhada e altamente instrutiva de quais são exatamente os problemas na urna e, mais importante, em todo o processo. Daqui algumas semana devemos ter as gravações das palestras e vocês poderão assistir. Então sigam o Twitter @theconf_br ou o meu Twitter @akitaonrails pra saber quando sair. Os vídeos serão postados pelo nosso parceiro e patrocinador InfoQ Brasil, fiquem ligados.

O gancho deste episódio foi um artigo que saiu no Portal Bitcoin falando que o Bozonaro chamou um especialista de blockchain pra fazer auditoria na urna eletrônica. Não estou nem criticando a pessoa em si que foi chamada, mas meus dois problemas: chamar alguém de especialista em blockchain, que eu passei 2 episódios semana passada afirmando que não existem e, essa noção que não sei porque se espalhou que blockchain é uma solução pra eleição. Ambas as noções estão erradas.

(...)

O que diabos é um especialista? Em definição simples pode ser só alguém que sabe alguma coisa. Especialista de fritar ovo. Especialista de aspirar a casa. Eu prefiro uma definição mais restritiva, por padrão, ninguém deveria poder se entitular especialista de nada. Quem reconhece alguém como especialista são outras pessoas ou no mínimo alguma instituição de longa tradição (medicina, engenharia), ao longo de muito tempo. Além disso um especialista deveria ser alguém que tem um estudo maior que qualquer outra pessoa, anos e anos, que publicou muito material, durante muito tempo, e praticou na área com resultados reconhecíveis, mensuráveis e irrefutáveis acima de dúvida razoável. Se houver dúvida, não é especialista.

Blockchains e criptomoedas é um fenômeno muito novo. Ele parece ter sido criado faz muito tempo. Surgiu na prática depois da última crise financeira de 2008 e 2009. Teve um certo crescimento mas por conta de episódios como Mt Gox e Silk Road em 2014 levou um tombo e ficou underground por 2015 e 2016, daí teve o bull run parabólico em 2017 e seu novo crash. A criptografia por trás vem de muitos anos atrás, dos Cypherpunks dos anos 90 e indo mais pra trás.

Blockchain é uma área nova, muito nova. Existem diversos tipos de blockchains como o canônico do Bitcoin e seus clones como Litecoin, Bitcoin Cash. Existe Ethereum com sua VM de Solidity. Existe IOTA que usa um DAG, ou directed acyclic graph, muito semelhante à estrutura de um Git. Existe Cardano ou Tezos com suas funcionalidades de auto-governança. Existem layer-2 como Plasma no Ethereum ou Lightning Network pra Bitcoin ou Litecoin. Existe a camada Omni que adiciona funcionalidades de smart contracts no Bitcoin e permite coisas como Tether USD. Existem plataformas criticadas como Ripple XRP ou EOS. Existrem até brincadeiras que deram muito certo como Dogecoin.

Existem dezenas de novos conceitos e novas tecnologias, auto governança, distributed autonomous organizations ou DAOs, stablecoins, zero knowledge proofs, secure enclaves, homomorphic encryption e muito mais no horizonte sendo pesquisado e testado. As tecnologias estão sendo testadas na prática, pelo mundo todo, por pessoas trabalhando sério e, nenhuma delas se auto-entitula especialista.

Quando alguém me fala “especialista de blockchain” eu só consigo imaginar isto:

(... bitconnect)

Muito do hype ao redor de blockchain eu vi parecido por volta de 2010 com a febre dos NoSQL. Me deixe fazer uma tangente se você não se lembra. Aqui é para os programadores. Com o advento das redes sociais e uma escala nunca antes vista de usuários postando “coisas”, os bancos de dados tradicionais - na sua maioria baseados em SQL - como MySQL, Postgres, Oracle, SQL Server, DB2, etc começaram a ruir para certa classe de aplicações. Pra mim o problema nunca foi o banco de dados mas a forma como eram usados.

Não obstante, surgiu uma nova categoria de bancos, os NO SQL. Basicamente qualquer tipo de armazém de dados que escolhe tirar uma das garantias ACID que bancos SQL prometem. Como eu expliquei sobre segurança e performance no meu vídeo de blockchain em São Francisco, arquitetura é uma escolha entre trade-off, você aumenta um ponto, é obrigado a diminuir outro. 

Você acha que o mundo de blockchain tem nomes pomposos? Proof of Work, Proof of Stake, zkSnarks? 
O Mundo de NoSQL tinha CAP, Consistency, Availability, Partition Tolerance, BASE (Basically Available, Soft state, Eventual consistency) 
e produtos como MongoDB, Redis, CouchDB, Riak, Cassandra. E conceitos como eventualmente consistente. E gerou abominações como o stack MEAN, juntando todos os hypes da época num acrônimo só e vendendo como se fosse a salvação da lavoura. Não existem balas de prata!

E porque estou trazendo NoSQL pra discussão? Blockchain é um NoSQL só que com objetivos diferentes. Você nunca parou pra associar blockchains com nosqls? Mostra falta de pensamento crítico. Os NoSQL de 7 anos atrás (pois é, já faz tempo), buscavam alta escalabilidade em troca de consistência eventual. Os blockchains trazem alta consistência em troca de performance.

O objetivo dessa comparação também é quebrar um pouco o mito dos grandes nomes na computação: só porque alguma coisa tem nome pomposo.

Quando me perguntam, o que é um blockchain? Minha resposta começa simples: é um banco de dados primitivo e glorificado. No caso de blockchains que usam métodos de proof of work, ele tem uma característica que o distingue de todos os outros bancos de dados: seus registros são garantidamente imutáveis, e toda réplica tem garantidamente o mesmo dado, alta consistência. Qualquer banco de dados, se eu tiver a senha de root ou administrador, eu posso dar um comando de UPDATE ou DELETE e modificar o banco como eu quiser e de repente toda réplica vai sincronizar a modificação. Blockchains não, ele embute consenso bizantino, por exemplo via proof of work, pra garantir que nenhuma Uma pessoa pode fazer isso sem controlar o consenso de mais da metade da rede.

Essa característica introduziu algo realmente inédito no nosso mundo digital de internet: pela primeira vez na história criou-se o conceito de não-fungibilidade. Significa que eu posso ter um bem digital não duplicável e cuja propriedade pode ser transmitido de uma pessoa para outra e há um consenso sobre essa propriedade. É o oposto de pirataria onde eu posso copiar um bem digital e não há como saber qual era o original e de quem era a propriedade original.

Tudo isso pra responder minha afirmação original: eleições. Muitos acham que por causa da não-fungibilidade que o blockchain garante eu poderia colocar um voto no blockchain e ele seria garantido contra modificação. É verdade.

Porém, seguindo o que aprendi com o professor Diego Aranha, minha conclusão é simples: blockchains são excelentes registros que podem ser usados em Eleições privadas com voto público, mas não servem para eleições públicas com voto secreto. O blockchain garante a integridade do voto mas não garante a segredo do voto.

Uma das características dos digital ledgers inspirados no modelo do Bitcoin é que todo registro entra linearmente num banco de dados append-only, que só adiciona pra frente e nunca modifica o passado, pense um log. Ele depende de um timestamp. Os endereços são públicos e rastreáveis. Bitcoin não garante anonimidade, na verdade ele facilita o rastreio do dinheiro. E por causa do timestamp, sem nenhum esforço, eu no mínimo consigo saber o primeiro voto da seção, o mais importante que é o voto do presidente da seção. Quanto vale essa informação?

Como detectar fake news sobre o assunto: 1) se a notícia só fala da urna propriamente dita, ela é inútil, embora a urna seja uma porcaria, o problema é o processo, por exemplo, quem garante que o código fonte auditado é o mesmo que compilou o binário que está na urna? 2) se a notícia fala da auditoria do código-fonte mas não menciona o professor Diego Aranha que nos últimos anos pessoalmente fez a auditoria e publicou diversos artigos a respeito com evidências concretas e explicações corretas, a notícia não sabe do que está falando 3) se a notícia junta urna eletrônica e blockchains na mesma frase, é total bullshit.

A equipe do professor Aranha tem um site que compila tudo que eles pesquisaram, a urnaeletronica.info e do FAQ deles eu cito, abre aspas:
Blockchain nas urnas eletrônicas resolve o problema?
Não. Blockchain serve para garantir que, uma vez registrada uma informação, ela nunca mais seja alterada. Mas se você não souber que a informação está correta no momento em que ela for registrada, de nada adianta garantir que ela não será alterada posteriormente.
Quando você faz uma compra com bitcoins no seu computador, a blockchain garante que uma vez que você transferiu aquelas moedas para a loja, você nunca mais poderá alegar que não transferiu, e portanto não poderá gastar as mesmas moedas para fazer outra transação. O propósito da blockchain é esse. É para isso que ela foi criada, e não para te proteger de criminosos que queiram roubar seu dinheiro. Se o seu computador estiver infectado com malware, ele pode muito bem registrar na blockchain uma transação incorreta, que transfira o dinheiro para um criminoso em vez de transferir para a loja.
Com votação, a situação se agrava, pois a transação na blockchain precisa ser sigilosa. Você inclui seu voto em um registro imutável mas, para proteger o sigilo, você depois não deve ser capaz de verificar o destinatário. Como verificar que seu voto foi destinado ao candidato correto? Ao contrário do roubo de bitcoins, que você acabaria percebendo, aqui você jamais saberia que seu voto foi desviado.
Imagine agora o problema inverso: de alguma maneira, você conseguiu inserir o registro corretamente e de forma sigilosa mas, depois de algum tempo, alguém descobre como quebrar o método que foi utilizado para garantir esse sigilo. Como a informação está registrada para sempre na blockchain, agora você nunca mais pode alegar que não votou naquele candidato.

Fecho aspas. E depois de tudo isso dito eu esbarro em outra notícia no sábado: “TSE autoriza técnicos de Bolsonaro e Haddad na sala-cofre da apuração” falando nisso como se fosse algo muito importante. (tapa na testa)

(... respira)


Cara, eu tento não perder a compostura, mas você não precisa ser “especialista” pra imaginar o que isso significa. Deixa eu citar esse artigo, abre aspas:
Até hoje, em todas as eleições brasileiras, representantes de candidatos eram convidados a assistir a apuração em uma sala no TSE, onde havia apenas monitores para o acompanhamento da apuração. Isso é mais ou menos o que a televisão e a internet mostram para a população. A diferença é que desta vez será franqueado o acesso ao que é conhecido como “sala-cofre”, local onde estão os computadores que de fato recebem as informações das milhares de urnas eletrônicas no país.

Fecha aspas… entendeu? Em vez de assistir de um monitor na sala do TSE, ele vão assistir de OUTRO monitor na sala-cofre … olhar pro computador vai alterar ou garantir qualquer coisa? É o que? o computador da sala-cofre emite ondas magnéticas diferentes que eu posso sentir? “ah.. Eu senti … tá fraudando …” (...tapa) 

Blockchains são bancos de dados com uma característica especial de garantir a não-fungibilidade do dado. Eu garanto que ele é meu. Por contra partida, uma vez estabelecida a identidade do autor, ela é irrefutável, não posso dizer que não fui eu. Por isso eu disse que blockchains são bons pra eleições privadas com voto público e não pra eleições públicas com voto privado. Eleições privadas? Por exemplo voto de acionistas numa empresa. O blockchain serve pra substituir o cartório, o voto uma vez registrado é imutável. É o cenário onde acabamos com os cartórios, mas não com eleições públicas.

Ficar discutindo onde na urna eletrônica ou no processo digital tem que mexer pra ficar “mais seguro” não faz sentido. Uma eleição de presidente, por exemplo, só acontece uma vez a cada 4 anos. Se houver erro, são 4 anos. “Mais seguro” não é seguro. Se há dúvida razoável, você precisa voltar ao método mais confiável - e que qualquer cidadão, sem conhecimento especializado possa entender - e só existe um: voto em papel. Ah, mas outros países não estão usando já? Como diz no site do prof Aranha, não exatamente.

Aliás, eu acho sempre interessante comparar a Wikipedia do Brasil com a dos Estados Unidos. Eu não confio 100% em nenhum dos dois, por isso é sempre bom procurar múltiplas fontes, mas é onde diferem que costuma ser legal. Na página dos Estados Unidos sobre voto eletrônico na Estônia tem uma ampla seção de críticas, existem dúvidas lá também até hoje! Na versão em português, coincidentemente, só essa seção de críticas foi omitido. Sensacional :-)

Nós, programadores ou pessoas de tecnologia temos a péssima mania de olhar uma solução de tecnologia e querer maquiar o problema pra caber na tecnologia. E, surpresa! Isso não resolve o problema. Na realidade o correto é o oposto: tem que resolver o problema com a solução adequada, mesmo que signifique não usar a tecnologia que queríamos. Resolver o problema é mais importante do que usar sua tecnologia favorita. Por isso eu fiz vídeos de porque sua linguagem não é especial, você não deve tentar encaixar todos os problemas na sua linguagem ou ferramenta favorita. Como diz o dito popular: pra quem só conhece martelo todos os problemas parecem pregos.

Mais do que isso, pare de tentar encaixar tecnologia nova em problemas que não precisam dela. Lembre-se da principal máxima da engenharia de software que eu mencionei antes. Não existe bala de prata. Aliás, no episódio seguinte vamos ver a origem dessa frase.

E com isso eu fico por aqui hoje galera, o que acharam do vídeo? Não deixem de comentar abaixo (e vamos evitar discussões políticas, o canal não é político e eu não estou interessado na política, comportem-se crianças). Se gostaram do vídeo mandem um joinha, assinem o canal e clique no sininho pra não perder os próximos vídeos. Até mais!


