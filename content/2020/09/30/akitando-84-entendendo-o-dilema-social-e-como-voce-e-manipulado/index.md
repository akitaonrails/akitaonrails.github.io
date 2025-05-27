---
title: '[Akitando #84] Entendendo "O Dilema Social" e Como Você é Manipulado'
date: '2020-09-30T19:15:00-03:00'
slug: akitando-84-entendendo-o-dilema-social-e-como-voce-e-manipulado
tags:
- o dilema social
- redes sociais
- machine learning
- Bayes
- Asch
- Milgram
- Dan Ariely
- Philip Zimbardo
- Paul Graham
- akitando
draft: false
---

{{< youtube id="mNHKNyhSn8I" >}}

## DESCRIÇÃO

Se você está interessado no documentário “The Social Dilemma” do Netflix, não deixe de assistir o episódio de hoje, onde eu vou introduzir os pensamentos de machine learning que o documentário não explica e, mais do que isso, vou explicar como exatamente documentários como esse manipulam você.


Aproveito pra explorar um pouco o Teorema de Bayes no contexto de raciocínio real e porque probabilidades sempre te enganam. E de brinde estou recomendando vários livros desta vez. Links abaixo.



Links:

* Adam Ruins Social Media (https://www.youtube.com/watch?v=5pFX2P7JLwA)
* A Plan for Spam (http://www.paulgraham.com/spam.html)
* Veritasium: The Bayesian Trap (https://www.youtube.com/watch?v=R13BD8qKeTg)
* 3Blue1Brown: Bayes Theorem (https://www.youtube.com/watch?v=HZGCoVF3YvM)
* Julia Galef: A Visual Guide to Bayesian Thinking (https://www.youtube.com/watch?v=BrK7X_XlGB8)
* AkitaOnRails: Somos Matematicamente Ignorantes (https://www.akitaonrails.com/2008/03/01/off-topic-somos-matematicamente-ignorantes)
* TED: Dan Ariely - Controlamos nossas decisões? (https://www.ted.com/talks/dan_ariely_are_we_in_control_of_our_own_decisions?language=pt#t-552874)
* Experimento da Conformidade de Asch (https://www.youtube.com/watch?v=Ijop2hvPNFE)
* Adam Ruins Electric Cars (https://www.youtube.com/watch?v=MQLbakWESkw)

* No, Social Media Isn’t Destroying Civilization (https://www.jacobinmag.com/2020/09/the-social-dilemma-review-media-documentary)
* The Social Dilemma Fails to Blame the Individual (http://tripod.domains.trincoll.edu/arts/the-social-dilemma-fails-to-blame-the-individual/)
* Bayes Theorem: A Framework for Critical Thinking (https://neilkakkar.com/Bayes-Theorem-Framework-for-Critical-Thinking.html#the-4-rules-for-being-a-good-bayesian)


Livros:

* Iludidos pelo acaso: A influência da sorte nos mercados e na vida (https://www.amazon.com.br/dp/8547000968/ref=cm_sw_r_tw_dp_x_V94CFb72Q7R6E)
* A lógica do Cisne Negro (https://www.amazon.com.br/dp/8576842122/ref=cm_sw_r_tw_dp_x_V94CFbPC213KW)
* Rápido e devagar (https://www.amazon.com.br/dp/853900383X/ref=cm_sw_r_tw_dp_x_894CFbE5C17GF)
* A Mais Pura Verdade Sobre a Desonestidade (https://www.amazon.com.br/dp/8535258086/ref=cm_sw_r_tw_dp_x_l-4CFbE3D8KKZ)
* Como Mentir com Estatística (https://www.amazon.com.br/dp/858057952X/ref=cm_sw_r_tw_dp_x_s-4CFbX23H67B)
* Previsivelmente irracional (https://www.amazon.com.br/dp/854310999X/ref=cm_sw_r_tw_dp_x_qa5CFbK95R1GJ)



## SCRIPT

Olá pessoal, Fabio Akita


Eu ando meio preguiçoso ultimamente, por isso tô demorando pra lançar novos episódios, mas podem esperar que uma hora eles chegam. Durante minha procrastinação eu tenho pensado em novos assuntos e quando estou literalmente coçando o saco assistindo alguma coisa no YouTube ou Netflix, aí vem a inspiração. E nesse caso foi por causa do documentário The Social Dilemma que saiu recentemente no Netflix e muitos de vocês ficaram me recomendando via DM no Insta pra eu assistir. Já vou dar a nota aqui: é um generoso 5 de 10.





Então o tema de hoje vai ser dissecar partes desse documentário e também sugerir um exercício de programação que eu fiz lá por 2003 e que talvez ajude vocês a entender um pouco desse documentário. Eu também vou tentar explicar como você é facilmente manipulado, como você não é tão racional como pensa, mas não do jeito que você pensa. A melhor forma de consertar suas fraquezas é entendendo que elas existem, e eu vou expor suas fraquezas hoje. De bônus vou resgatar alguns conteúdos que quem assistiu palestras minhas lá por 2008 ou 2009 vai se lembrar. E como muita gente sempre me pede pra recomendar livros, hoje vou recomendar vários. Tem bastante coisa, então pega a pipoca e vamos lá.



(...)






Eu já disse isso antes, mas eu tenho muito pouca paciência pra documentários. Pra ser mais honesto, anos atrás eu até gostava. Nos meus 20 e poucos anos eu assistia bastante. Mas a falta de interesse tem mais a ver que a essa altura da vida, pouca coisa consegue me impressionar. Aos 20 anos era até facil de me impressionar, aos 40 tá difícil, precisa ser algo realmente fora do comum pra mudar a expressão da minha cara. O mais normal é minha expressão virar a de tédio.








Da forma como eu vejo, um documentário é uma faca de dois gumes. Se você é ingênuo, pode achar que um documentário é uma apresentação de fatos, uma explicação da verdade. Mas não é, um documentário é um filme, baseado em realidade, mas que expõe exclusivamente a visão e narrativa do diretor e escritor. Portanto ele sempre vai enviesar a conclusão pro que ele acha que é o certo e ele não tem nenhuma obrigação de mostrar a informação completa, sempre vai ser parcial. Quando você entende isso, também entende que ficar assistindo uma visão enviesada de alguém por 2 horas é pedir demais da minha atenção.









De fato, exatamente a mesma coisa que esse documentário fala pode ser explicado em 5 minutos como neste video do canal Adam Ruins Everything que vou deixar linkado nas descrições abaixo. Aliás, eu recomendo muito esse canal, assisto faz muitos anos e esse video em particular é de uns 3 anos atrás pelo menos. E isso é outra coisa importante. O documentário trás uma narrativa que parece algo extremamente urgente que tá acontecendo agora, como se fosse começar uma guerra civil mês que vem se a gente não fizer alguma coisa. Mas, nada do que ele diz é muita novidade. Qualquer um que trabalha nesse indústria sabe de tudo isso faz pelo menos 5 a 10 anos. 









Se você ainda não assistiu o documentário, ele explica em termos simples, pra população que não é de tech, sobre como as plataformas de redes sociais tem incentivos pra coletar dados sobre cada usuário pra conseguir recomendar os conteúdos que tem mais chances de manter você engajado o mais tempo possível. Todo mundo já passou por isso. Você clicou num artigo sobre Europa. Fuçou um grupo no Facebook sobre Itália. Mandou uma mensagem pra alguém sobre vinho. E dali a pouco numa página completamente aleatória, vem um banner com um ad sobre uma viagem pra vinículas na Sicília. E você pensa "nossa, leu minha mente!"









Eu vou voltar pro documentário daqui a pouco mas agora vem a primeira tangente que me ocorreu quando eu tava assistindo. Como não é uma palestra técnica nem nada, ele fala super super por cima que existe algum tipo de "inteligência artificial" que sabe tudo sobre nós e com isso é capaz de nos manipular pra nos manter online mais tempo. 









Mas você, que teoricamente tá nesse canal porque se interessa por programação, já parou pra se perguntar como funciona esse tipo de sistema? Claro, dá pra fazer uma carreira inteira só resolvendo esse problema, e é exatamente o que engenheiros do Google ou Facebook passaram os últimos 20 anos construindo, e não é em meia hora que eu vou explicar tudo. Mas acho que consigo dar uma pequena luz pra quem é iniciante.










Em 2003 eu era programador Java, trabalhando no mundo corporativo de SAP como expliquei neste video acima. Tem uma rotina que eu fazia naquela época e que eu faço até hoje que é ler notícias de sites de tecnologia, seja Hacker News ou Slashdot ou outros. Desde quando eu tava na faculdade ia organizando todos que eu gostava como bookmarks. Todo dia eu abria dezenas de janelas com todos eles. Era um saco, porque abas não tinham sido inventadas ainda. 









Depois inventaram abas e isso ajudou um pouco. Mas cada vez ia aumentando o número de sites que eu acompanhava. Daí em 1999 inventaram o RSS ou Really Simple Syndication. Syndication é a redistribuição de conteúdo, um termo que era usado mais em TV como um modelo de reprises de séries em múltiplos canais por exemplo. Chaves no SBT é um syndication.











Enfim, com o advento do RSS e alguns sites que permitiam agrupar o RSS de vários sites num lugar só, eu podia abrir um único site e ter acesso a todas as notícias e artigos que eu queria num mesmo lugar. O Atom só seria inventado dois anos depois em 2005. Mas em 2003 acho que o site que eu usava mais era o antigo Google Reader. Hoje em dia eu uso o Feedly. Muitos dos sites que eu acompanho até hoje vem desses bookmarks de antes de 1999. 







Antigamente a gente precisava ativamente pesquisar e procurar sites, escolher um a um o que queria consumir. Com redes sociais hoje em dia é diferente, a plataforma usa crowdsourcing e machine learning, ou seja, ele avalia o que todo mundo anda escolhendo e faz uma timeline customizada com a curadoria de conteúdos que ela acha que vai nos manter online a maior parte do tempo e não necessariamente que sejam úteis.









Eu sou o tipo de cara que automaticamente tem preconceito com best sellers. Você quer a posição numa livraria onde tem a maior probabilidade dos piores livros? É aquela que tem na entrada de todas chamada "mais vendidos". É o equivalente de uma timeline de rede social mas na vida real. Eu não acredito em seguir a maioria. Pra entretenimento sim, por isso eu consumo filmes blockbuster. Não porque eu procuro algo inteligente, mas porque eu quero mesmo algo pra desligar o cérebro e me divertir, e nesses casos a maioria costuma acertar mesmo. 









Eu tenho minhas contas em todas as redes sociais mas dificilmente fico seguindo alguém. Eu não faço muito diferente do que fazia com meus bookmarks antigos. No Facebook é onde me dá mais trabalho, porque todo mundo que eu aceito deixar me seguir na sequência eu sou obrigado a des-seguir, porque senão polui minha timeline com lixo. Até hoje eu faço minha própria curadoria. É um saco e dá muito trabalho, mas como eu faço isso faz mais de 2 décadas, já virou rotina. E definitivametne eu não participo de nenhum grupo, nem adianta me convidar.









No começo dos anos 2000 eu seguia alguns sites de programadores que sabiam escrever de maneira muito eloquente e com linha de raciocínio muito boa. Eu não tinha muito interesse em saber quem eles eram ou o que falavam no mundo real, porque o resultado do trabalho me interessa mais do que a pessoa, sempre. Se pra gostar do trabalho depende de eu gostar da pessoa, quer dizer que o trabalho não é tão bom assim. Exemplos daquela época era tipo Martin Fowler, Joel Spolsky ou Paul Graham. 









Eu não sabia disso na época, fui descobrir agora escrevendo o episódio, mas o Graham foi um que teve sorte de conseguir surfar a bolha das ponto com e pelo jeito se deu bem. Ele fundou a Viaweb que foi vendida pro Yahoo. E ele fez tudo com Common Lisp e justamente os artigos que ele escrevia no site dele era sobre a beleza de se programar em Lisp. Que eu achava muito legal mesmo sendo programador de Java. Lembrando, isso é 2003, uma década antes do povo ficar enchendo o saco falando de programação funcional como se fosse uma grande novidade.










O Graham depois fundou a YCombinator, uma das aceleradoras de startups mais famosas de Silicon Valley, de onde saíram algumas das marcas mais conhecidas como Stripe, Airbnb, Dropbox, Rappi, Gitlab, Docker, Twitch, Heroku e dezenas de outros. É meio que uma profecia que se auto-realiza. E é dele também o famoso site Hacker News, que meio que tomou o lugar do Slashdot entre os sites que eu mais acessava. Hacker News costuma agregar notícias interessantes, mas as discussões sempre são meh. Alguns poucos são úteis, a grande maioria é só perda de tempo, mas isso é verdade em todos os lugares que as pessoas podem comentar. Outra dica: engajar em comentários é perda de tempo.











Os artigos que eu lia dele ainda tão online então eu recomendo que vocês leiam uma hora também. Dentre eles tava o artigo "A Plan for Spam" ou "Um Plano contra o Spam". Lembrem-se, o Gmail ainda não tinha sido lançado. A gente tinha Hotmail e cada provedor tinha seu serviço porcaria de e-mail. Se você acha que spam hoje é ruim, pensa como era spam no pico da bolha das ponto-com. Era uma quantidade irritante de lixo. A gente usava clientes de e-mail como Outlook e precisava instalar plugins pra filtrar Spam como o SpamAssassin. Era raro o provedor de e-mail ter um sistema bom anti-spam.










Pra piorar a gente ainda usava o antigo sistema de blacklists e whitelists. Dava pra bloquear endereços que eram conhecidos de propaganda ou spam e precisava carregar e dar manutenção em listas de palavras bloqueadas ou permitidas. Se no e-mail aparecesse "aumente seu pênis" obviamente era spam, e dava pra bloquear. Porém, spammers iam ficando mais sofisticados. Sabendo que a gente ia bloquear a palavra "pênis" eles começavam a mandar penis sem acento ou escrever palavras com erros de propósito, tipo penis com "z" ou dois "n". Eu acho que é por isso que e-mails de spam tem tantos erros ortográficos, pra tentar fugir dos sistemas de spam primitivos.









Era uma guerra que não tinha como ganhar. Pra piorar você podia acabar apagando e-mails que não eram de spam, ou seja, falsos-positivos. Por isso o artigo do Graham me deixou impressionado quando eu li em 2003. Ele propõe um filtro baseado em treinamento estatístico, mais especificamente usando o método Bayesiano. O teorema de Bayes descreve a probabilidade de um evento, por exemplo, se um e-mail é um spam, baseado em conhecimento anterior de e-mails marcados que eram spam. Nos experimentos dele, pra cada mil e-mails de spam, ele deixava passar uns cinco que o filtro não pegava, e tinha zero falsos positivos. 









Ou seja, o algoritmo dele era 99.5% eficiente. Comparado com os filtros antigos baseados em lista, que se tinham 95% de eficácia era muito, 99.5% é um salto enorme. E melhor ainda, era um sistema que em vez de ficar dando manutenção em lista de combinações de palavras, era refinado automaticamente à medida que a gente recebia mais spams. Se você ler o artigo dele vai entender mais detalhes, por exemplo, no sistema de listas de palavras, quanto mais você escreve menor as chances de ser pego, mas num sistema bayesiano, a única saída pra tentar passar spam é escrever o menos possível, nível menos que um tweet. Porque quanto mais informação, maiores as chances de ser filtrado.








Eu li esse artigo 17 anos trás, e foi a primeira vez que eu entendi o poder da estatística e probabilidade que eu tanto falo. Mais do que isso, entender Bayes meio que muda a forma como você enxerga o mundo. Vale a pena entender pelo menos a noção mesmo que você nunca pare pra entender as fórmulas. Aliás, a fórmula em si é esta aqui (...), A probabilidade do evento B, dado o evento A é igual à probabilidade do evento A dado o evento B, vezes a probabilidade de A, dividido pela probabilidade de B. Uma fórmula muito elegante e simples, que tem um peso similar ao famoso E = m c ao quadrado de Einstein, que todo mundo veste na camiseta, faz tatuagem mas ninguém sabe o que de fato significa. E dessa fórmula pra chegar na bomba atômica ainda precisa de muito mais física por cima.









Acho que a maioria das pessoas devia tatuar a fórmula de Bayes, porque ela é muito mais útil no nosso dia a dia do que E igual m c quadrado. E pra explicar eu vou roubar um trecho de um video de outro canal que eu gosto bastante, o Veritasium, entitulado The Bayesian Trap que vou deixar o link nas descrições abaixo. Mas ele conta a seguinte história: Imagine o seguinte, você acorda uma manhã e se sente um pouco doente, tossindo, com febre. Daí você resolve ir no médico e ele manda você fazer um teste.








Daí sai o resultado e ele é positivo pra uma certa doença que afeta 0.1% da população. E não é uma doença legal, não tem cura, você certamente não quer ter essa doença. Daí você pergunta pro médico "puts, e qual é chance de eu estar com essa doença mesmo?" E o médico responde "bom, o teste corretamente identifica 99% das pessoas que tem a doença e dá só 1% de falsos positivos". E isso definitivamente soa bem ruim. Qual é a chance de você realmente ter a doença sabendo disso? E aqui vem o problema que eu falo que a gente é muito ruim com probabilidades porque a maioria das pessoas pensaria na hora que as chances de ter a doença devem ser perto de 99% já que o teste é preciso 99% das vezes.










E é aqui que entra a tal fórmula do teorema de Bayes pra ter uma nova perspectiva. Já aviso pra não se assustar com a fórmula que vou mostrar agora porque logo na sequência vou explicar porque você sequer precisa da fórmula, então se seguram por 2 minutos.




O teorema vai te dar a probabilidade de uma hipótese, digamos, se você tem mesmo a tal doença, baseado num evento, que você foi testado positivo. Pra calcular isso você precisa começar com uma probabilidade anterior da hipótese ser verdade, ou seja, a probabilidade de você ter a doença antes de fazer o teste, e multiplicar pela probabilidade do evento dado que a hipótese é verdadeira, ou seja, a probabilidade do teste dar positivo, dado que você tem a doença, e dividir isso pela probabilidade total do evento acontecer, ou seja, testar positivo.










A probabilidade anterior da hipótese ser verdadeira é normalmente a parte mais difícil da equação e muitas vezes não é melhor que um chute mesmo, guarde esse conceito. Mas nesse caso um ponto de partida adequado é a frequência da doença na população, que sabemos que é 0.1%. E se plugar o resto dos números, descobre que na verdade você tem só 9% de chance de realmente ter a doença depois de testar positivo.










Perceberam? Antes de aplicar a fórmula eu tenho certeza que a maioria de vocês pensaria que a chance de ter a doença seria mais perto de 99% por causa da precisão do teste. Mas aqui precisa ter o tal "bom senso" de verdade. Vamos pensar sem usar a fórmula, só usando real bom senso. Pensa numa população de 1000 pessoas. Como falamos que 0.1% da população tem a doença, então 1 pessoa nessas mil muito provavelmente tem a doença e se aplicar o teste nela, o teste muito provavelmente vai identificar como positivo. 








Mas, se testássemos também as outras novecentas e noventa e nove pessoas, 1% ou 10 seriam falsamente identificadas como tendo a doença. Lembra? O teste tem 1% de erro. Então se você é uma das pessoas que tem o resultado positivo no teste e todo mundo é selecionado aleatoriamente, então você é parte de um grupo de 11 pessoas que teriam o teste positivo e só tem uma pessoa de fato que tá doente. Então é 1 chance em 11, ou seja, 9%.











Por isso se fala que é importante uma segunda opinião, um segundo teste feito de maneira independente. E digamos que esse segundo teste também volta positivo. Agora, qual é a chance de você de fato ter a doença? Vamos usar a mesma fórmula de Bayes, mas agora em vez de usar a probabilidade anterior de que 0.1% da população tem a doença, vamos plugar a probabilidade posterior, os 9% de chance de você ter a doença dado que o primeiro teste deu positivo. 








Agora, se você calcular com os mesmos números de antes mas agora baseado em 2 testes positivos chegamos na probabilidade de 91%. E isso faz sentido porque 2 testes positivos rodados por 2 laboratórios independentes já é mais difícil de ser coincidência, mas mesmo assim 91% não é perto dos 99% que você achou no começo.









Recomendo que você assista o video completo do Derek no canal Veritasium e, como sempre, também recomendo o video do Grant do canal 3Blue1Brown que explica ainda melhor como o teorema funciona. Nesse video o Grant relembra o trabalho de Daniel Kahneman e Amos Tversky que inclusive deu o prêmio Nobel ao Kahneman e ficou famoso no seu livro Pensando Rápido e Devagar e o livro The Undoing Project de Michael Lewis. O trabalho deles foi pesquisando o julgamento humano e como esse julgamento costuma contradizer o que as leis da probabilidade de fato sugerem, e como nosso pensamento é irracional. 









O teorema de Bayes não é uma fórmula pra ser aplicada só uma vez. Ela é importante porque refina sua confiança numa hipótese depois de ver novas evidências. Na visão de mundo de Bayes é impossível ter 100% de confiança em alguma coisa, você vai refinando sua crença baseado no refinamento das probabilidades dado novas evidências. Por isso a pergunta não é "qual é a probabilidade da hipótese" e sim "qual é a probabilidade da hipótese dado este novo evento, ou evidência". Não é uma fórmula determinística pra conseguir 100% de verdade, mas pra ir se aproximando, validar ou invalidar uma crença. É uma forma de quantificar sua crença numa hipótese.









E é importante entender que mesmo com uma montanha de evidências, você nunca pode ter 100% de certeza nem com o teorema de Bayes. Exemplo clássico, se sua hipótese é que todas os cisnes são brancos, e você mora num lugar que só tem cisnes brancos, sua probabilidade vai se aproximando mais e mais de 100%, mas basta encontrar um cisne negro pra invalidar toda a hipótese. Essa é uma das teses do famoso livro da Lógica do Cisne Negro de Nicholas Taleb e o outro livro dele que eu acho mais interessante, o Iludidos pelo Acaso que fala sobre a aleatoriedade que não vemos no nosso dia a dia. A população em geral confunde quantidade de evidência com a qualidade das evidências. Se as evidências são ruins, sua conclusão necessariamente vai ser ruim, especialmente se a única ferramenta que você tem é inferência.









Eu sei que é difícil entender Bayes assim logo de cara. No YouTube mesmo tem diversos vídeos explicando e você vai achar dezenas de artigos no Google, é só procurar, mas vou deixar mais um exemplo simples pra tentar sedimentar essa noção. Como o Grant diz no seu video do 3Blue1Brown, ajuda muito se você não pensar em probabilidades como fórmulas, e sim como proporções. Quando a gente diz que um teste tem 99% de precisão, significa também que tem 1% de falsos positivos. No final você precisa ter um espaço de 100% de probabilidades. Se uma moeda tem 50% de chance de dar cara, também tem 50% de chance de dar coroa, e a probabilidade total é 100%.








O próximo exemplo eu peguei do canal da Julia Galef, que é muito parecido com os exemplos do Kahneman e Tversky, mas pode ajudar vocês agora. Considere um personagem fictício chamado Tom. A única coisa que eu vou dizer pra vocês sobre o Tom é que ele é muito tímido, sabe, pessoa introvertida, quieta e tals. Sem pegadinha, se você tivesse que chutar, qual carreira o Tom perseguiria, um phD de matemática ou uma escola de negócios, business? É pra escolher um ou outro. Vai, pensa por 2 segundos .... 







Pensou? Se eu tivesse que apostar o que vocês escolheriam, eu apostaria que quase todos diriam que o Tom escolheria phD em matemática. Mesmo quem chutou negócios, não saberia dizer porque, talvez só pra não ser óbvio. Mas todo mundo sempre associa o estereótipo de pessoa tímida tendo mais a ver com matemática do que com negócios. Esse é o problema das suas crenças, ou nesse caso, preconceitos e estereótipos. Não pense na pessoa, pense primeiro nas probabilidades precedentes.








Vamos lá, usando as mesmas crenças que você deve ter e sem tentar procurar uma estatística oficial. Se você tivesse que chutar, qual a proporção TOTAL de estudantes de escolas de negócios versus estudantes de phd de matemática? Eu acho que todo mundo chutaria e não estaria muito errado que deve ter muito mais estudantes de negócios do que de phd de matemática, numa proporção talvez de 10 pra 1. Olhe ao seu redor, quantos phd de matemática você já conheceu pessoalmente, e quantos estudantes de business tipo MBA, administração ou algo assim você já conheceu? A menos que você seja estudante já da área de matemática, provavelmente vai ter visto mais pessoas de negócios.







Nosso universo é esse quadrado, com a proporção de 10 estudantes de negócios pra 1 de matemática. Num universo de, digamos 1000 estudantes, eu acho que 10%, ou seja 100 sejam de matemática e os outros 900 são de negócios. Dentre os 100 de matemática, temos 75 que são tímidos. Mas 15% dos 900 de negócios são 135 alunos. Ou seja, a probabilidade do Tom se tornar um estudante de negócios, mesmo sendo tímido, ainda é o dobro dele ir pra matemática. Que é exatamente o oposto do que sua intuição disse logo no começo do exercício. 







E é exatamente esse erro que você comete todos os dias, toda vez que lê um tweet ou vê o noticiário e aparecem probabilidades e estimativas. Você ignora os precedentes. Você acha que tá pensando racionalmente, mas não tá. E essa é a lição mais importante do teorema de Bayes, mesmo que você nunca use as fórmulas.










Mas pros propósitos do assunto de spam, temos um controle maior da situação porque quem recebe os e-mails somos nós, e eu sei o que eu objetivamente considero spam ou não, e eu mesmo consigo separar os e-mails. E com Bayes, em vez de calcular a probabilidade de você ter uma doença, dado que um teste deu positivo, mude pra probabilidade de um e-mail ser spam dado os e-mails anteriores que eu marquei como spam. No começo, com uma probabilidade anterior que é um chute, você vai ter um resultado baixo. Mas à medida que você vai classificando mais e mais e-mails de spam, e treinando com essa fórmula, vai criando um modelo mais e mais preciso de que tipos de palavras e combinações realmente aparecem num spam, sem precisar manualmente criar listas de palavras.









No artigo do Graham ele fala em considerar não só o texto do corpo do e-mail mas também os cabeçalhos, o título e tudo que compõe o e-mail e fazendo isso podemos treinar esse modelo bayesiano pra ficar mais e mais preciso em identificar spams com muito pouco falso positivo. No caso dessa minha história, depois que eu li o artigo eu pensei num outro problema. Lembram que eu falei que por alguns anos eu vim acumulando vários sites que eu lia todos os dias e depois eu agreguei o RSS de todos num Google Reader da vida?








Mesmo naquela época acumulava sei lá, uns 500 artigos que eu precisava bater o olho toda semana. E desses, no máximo uma dúzia eu separava em abas pra ler depois. Por isso eu fico com tanta aba aberta. No meu Feedly de hoje, se eu deixo pra abrir uma vez por semana, acumula mais de mil artigos fácil. Eu gasto algumas horas batendo o olho e separando o que eu quero ler em abas. Na época eu pensei, a idéia toda do algoritmo do Graham seria ter uma pasta chamada Spam e no começo eu manualmente ia movendo os e-mails que eu sei que são Spam pra essa pasta. Com o tempo o algoritmo ia conseguir sozinho separar o que é spam do que não é. 











A mesma coisa vale pro oposto, que é selecionar automaticamente conteúdo que eu gosto. Então eu resolvi fazer um programinha bem simples, em PHP na época, porque  achei uma biblioteca de Bayes e de RSS em PHP primeiro. Então fiz um experimento pra puxar algumas centenas de artigos de RSS. A idéia é que isso podia economizar muito meu tempo depois. Mas o experimento foi um fracasso porque PHP não era a linguagem adequada, pra processar todos os RSS que eu lia, na minha máquina de 2003, era muito demorado. E nos primeiros testes o número de falsos positivos ainda era muito grande, então ia precisar de muitas rodadas até o número de falsos positivos ficar adequado. Eu queria reescrever em Java, mas na época acabei deixando a idéia de lado. 












Alguns anos depois começariam a surgir plataformas de redes sociais como conhecemos hoje. No ano seguinte o Facebook ia aparecer, quatro anos depois o Twitter, sete anos depois o Instagram. E em paralelo a isso a programação paralela ia começar a ganhar mais corpo com o advento de CPUs multi-core, como o AMD Athlon 64 que lançou em 2003. GPUs estavam engatinhando e a gente ainda usava computadores de 32-bits. Meu notebook Toshibão acho que era um Pentium 4 e eu tinha 1 Giga de RAM. Faltava processamento e faltou eu escrever em uma linguagem mais adequada pra esse caso de uso, como Java. 










Enfim, alguns anos depois surgiria a Amazon AWS em 2006, nesse mesmo ano sairia coisas como o Apache Hadoop que é uma coleção de programas open source pra lidar com quantidades massivas de dados, o início do que chamamos de Big Data. E em cima dele surgiriam outras ferramentas como o Apache Mahout que é outra coleção de programas open source distribuídos e escaláveis de machine learning. E o Mahout é uma coleção focada em coisas como álgebra linear e probabilidade e adivinhem, dentre os vários classificadores está o Naive Bayes. Eu só fui descobrir sobre isso acho que por volta de 2012 ou 2013.









Naive que é ingênuo em inglês e é ingênuo porque o classificador Naive Bayes parte da premissa que as características de uma medição são independentes uns dos outros, e isso é ingênuo porque quase nunca é verdade. Isso facilita a implementação mas não tem problema no resultado, só quer dizer que talvez vamos processar a mesma características duas vezes. 







Naive Bayes é uma algoritmo de classificação muito intuitivo. Ele começa fazendo a pergunta "dado tais características, essa medição pertence à classe A ou B", tipo spam ou não-spam, doente ou não-doente, artigos interessantes ou artigos chatos? E responde tomando a proporção de todas as medições anteriores com as mesmas características da classe A multiplicado pela proporção de todas as medidas da classe A. Se esse número é maior que o cálculo correspondente pra classe B então dizemos que a medição pertence à classe A. Só isso.









Machine Learning é basicamente estatística e probabilidade, álgebra linear e cálculo. E o teorema de Bayes é tipo o Hello World de Machine Learning. E dentro da categoria de classificadores temos um Naive Bayes. E mesmo ele tem algumas implementações diferentes como gaussiano, multinomial e Bernouli. Uma das vantagens é que escala muito bem desde conjuntos de dados pequenos até Big Data. Então se você tem interesse no assunto de Machine Learning eu acho que começar entendendo o Teorema de Bayes e como ele foi primeiro aplicado ao problema de Spam é um bom ponto de partida. 









E de bônus, muita gente pede um projetinho pra exercitar programação. E eis que minha história de 2003 pode servir pra alguma coisa. Eu fiz esse programinha super besta em PHP, que foi limitado ao pouco poder de processamento que eu tinha, provavelmente usando bibliotecas mal-escritas, e meu próprio programinha foi só um protótipo que eu montei em poucas horas e nunca refinei. Pois bem, eis o exercício, criar um programinha em qualquer linguagem, onde se possa cadastrar feeds de Atom ou RSS. Daí um background job tipo um cron vai ficar puxando novos artigos desses feeds de tempos em tempos e vai tudo pra algum tipo de Inbox. 









Dai via uma interface gráfica ou via linha de comando eu posso ir puxando um artigo de cada vez desse inbox e marcando com um Like da vida ou como Spam, e assim ir treinando o sistema com um classificador Naive Bayes. Pra isso precisa fazer um parser como o Paul Graham explica no artigo dele. E isso vai fazer você estudar um pouco de Natural Language Processing ou NLP, porque entender o conceito de grams e n-grams pode ajudar. Isso provavelmente vai te levar a estudar um pouco de Teoria da Informação de Claude Shannon também. 








No começo o programa não sabe nada sobre mim então todo artigo que me mostra ele não sabe se eu vou gostar ou não. Mas a partir do momento em que começar a acertar quando eu dou like com mais de 99% de certeza, ele pode automaticamente ir mandando artigos que acha que eu não vou gostar pra pasta de Spam, sempre que o background job puxar novos artigos do feed. Daí vai me mostrando só os que acha que eu iria dar Like. E à medida que deixar passar artigos que eu não gosto, eu posso marcar como Spam pra ir refinando. Não sei ainda se essa idéia funciona bem porque até hoje eu nunca parei pra fazer uma versão nova, talvez eu me anime a fazer também.









Você pode querer ser fancy e montar uma infraestrutura na AWS com Spark e Mahout mas não é obrigatório porque a idéia não é ter Big Data pra milhares de pessoas. Como qualquer computador médio de hoje em dia tem processamento de sobra, acho que mesmo um programinha simples local deve ser mais do que capaz de processar algumas centenas ou milhares de artigos vindos de feeds. Eu acho que é um projetinho que você consegue fazer em uma semana, talvez duas, nas horas vagas. Se você se diz de machine learning, esse exercício deveria ser como um hello world, porque hoje em dia existem bibliotecas, frameworks e serviços prontos que já fazem quase tudo que eu falei.








De qualquer forma, eu sempre considerei estatística e probabilidade uma matéria desconfortável no começo. Quando você tá acostumado com determinismo da física newtoniana por exemplo, você espera fórmulas que descrevem o mundo absolutamente. Só que probabilidades não funcionam assim. O mundo é probabilístico, tudo tem uma probabilidade de acontecer mas baseado no "meu" conhecimento do mundo, que é um conhecimento limitado e provavelmente falho. A probabilidade é intrínseca a mim e não aos eventos do mundo. Ou seja, duas pessoas analizando o mesmo evento, de forma independente, podem chegar a probabilidades bem diferentes. E isso soa bem desconfortável.









Por exemplo, se eu fosse ingênuo, poderia considerar que a probabilidade de existir Covid-19 é perto de zero porque eu não conheço ninguém perto de mim que tem. Pergunte a um médico na emergência de um hospital e ele vai dizer que pra ele é perto de 100%. As probabilidades são a medida da "sua" confiança numa determinada crença. Quando começamos a aprender introdução à probabilidade normalmente vemos exemplos bestas como jogar uma moeda pra tirar cara ou coroa, ou jogar dados, ou rodar uma roleta num cassino. São eventos independentes, e as probabilidades não são tão difíceis. Mas mesmo em eventos independentes nossa intuição é ruim. Por exemplo, 12 anos atrás eu escrevi um post no meu blog chamado Somos Matematicamente Ignorantes falando disso. Vou deixar linkado nas descrições.








Um dos exemplos desse artigo ilustra uma das idéias do livro Iludidos pelo Acaso do Taleb. Sempre é possível combinar dados aleatórios e encontrar alguma regularidade. Um exemplo muito conhecido é a comparação das coincidências nas vidas de Abraham Lincoln e John Kennedy, dois presidentes com sete letras em seus últimos nomes, eleitos com 100 anos de diferença, em 1860 e 1960. Ambos assassinados numa sexta-feira na presença de suas esposas, Lincoln no teatro Ford e Kennedy num automóvel feito pela Ford. 






Os assassinos dos dois tem três nomes: John Wilkes Booth e Lee Harvey Oswald, com quinze letras em cada nome completo. Oswald atirou em Kennedy de um armazém e correu para um teatro, e Booth atirou em Lincoln em um teatro e correu para um tipo de armazém. Ambos os sucessores vice-presidentes eram Democratas sulistas e ex-senadores chamados Johnson (Andrew e Lyndon), com treze letras em seus nomes e nascidos com 100 anos de diferença, 1808 e 1908.









Bizarro né? Mas se compararmos outros atributos relevantes falhamos em encontrar coincidências. Lincoln e Kennedy nasceram e morreram em dia e mês, e em estados diferentes, e nenhuma das datas é separada de 100 anos. Suas idades eram diferentes, assim como os nomes das esposas. Claro, se alguma dessas fosse correspondente estariam na lista de coincidências “misteriosas”. Pessoas vivem décadas, com centenas ou milhares de eventos durante a vida. Você sempre vai encontrar coincidências nas vidas de quaisquer duas pessoas.






Duas pessoas se encontrando numa festa normalmente encontram coincidências chocantes entre elas. Quantas vezes você conhece uma pessoa numa festa e depois de conversar fica com aquela impressão de "nossa, como temos coisas em comum" e aí chega na falsa conclusão de "é o destino, a gente foi feito pra se encontrar". Meh, porra nenhuma, fale com qualquer outra pessoa no mesmo lugar e você vai encontrar a mesma situação.











Você já viu artigos à la Buzzfeed de coincidências como essas como se fosse algo extraordinário. Coincidência é o que mais existe. E também eu acho que não tem nada mais clickbait do que fazer títulos de notícias usando números. A população em geral tem sérios problemas em entender esses números. Relembre da história do video do Veritasium que eu falei. Digamos que você, que fez o tal teste, é alguém famoso. E depois do primeiro teste positivo, algum papparazi descobre e publica a notícia com o título "Celebridade Fulano fez teste que tem 99% de precisão e deu positivo!" Noooooosa, todo mundo que lê o título assume "puts, tadinho, tão novo e já vai morrer". E lembram da conta que fizemos com o teorema de Bayes? Sua chance de ter a doença na verdade é só 9% ainda e os jornais já começaram a escrever seu obituário.










Aqui vale uma nova tangente. Isso me lembra outro autor que eu gosto muito, o pesquisador de economia comportamental, Dan Ariely, e seu famoso livro Previsivelmente Irracional que explica como nós achamos que somos pessoas racionais, com pensamento lógico, mas como na realidade nós nos comportamos de maneira instintiva e irracional. Além desse livro também recomendo outro dele, que é A Mais Pura Verdade Sobre a Desonestidade. Mas do primeiro livro tem vários exemplos que ele apresentou no TED, na época em que o TED tinha conteúdo interessante. Aliás, fica dica, se pegar algo no TED que é de menos de 10 anos pra cá, suspeite. Mas vamos ver um trecho da palestra dele que mostra como nós somos ruins em entender estatísticas. Lembrando que esse video é de 2008.




(Dan Ariely video)







Isso é tão comum na realidade que sempre que eu explico esses conceitos faço questão de lembrar de um livro de 1954 entitulado "Como Mentir com Estatística". Repetindo, probabilidades dependem do "seu" conhecimento sobre o mundo. O teorema de Bayes não é que nem uma fórmula de gravitação onde você tem medições que são fatos e o resultado é uma previsão precisa. Por exemplo, na história do teste da doença, a primeira rodada com a fórmula do teorema de bayes começa com um chute educado na probabilidade anterior, onde pegamos a probabilidade de infecção da população que no exemplo foi de 0.1%, ou 1 em cada 1000.










Nós minimizamos o efeito desse chute quando rodamos a segunda vez e agora substituimos a probabilidade anterior pela probabilidade posterior, de 9%. Se repetirmos o teste mais vezes vamos chegar mais e mais perto de uma confiabilidade perto de 100%. Mas se estivermos limitados a fazer só um teste, a próxima pergunta óbvia deveria ser: da onde vem esse 0.1%? Quando falamos população, estamos representando a região onde moramos? Ou esse número é da China? Qual foi o tamanho da amostra? Medimos 100 mil pessoas? 10 mil pessoas? Ou míseras 1000 pessoas? A confiabilidade do resultado depende diretamente da qualidade dos dados sendo medidos e do processo de medição.










Essa confiabilidade vai ficando melhor a cada nova evidência. Por outro lado, basta uma evidência em contrário pra invalidar a hipótese inteira. A moral da história é simples: se você tem 20 e poucos anos, evite ter crenças firmes de 100% em qualquer coisa. É muito cedo. Tirando coisas meio óbvias tipo leis da física, química, biologia, qualquer outra coisa como filosofia ou política, dependem totalmente das pessoas e do timing. E elas mudam, bem mais rápido do que você pensa. Tudo que parece urgente e fatal hoje na verdade não é tanto assim. 








Tudo que você acha que é 99% na verdade é mais perto de 9%. Pela última vez, as probabilidades que você pensa na sua cabeça refletem o seu limitado conhecimento do mundo. Eu tenho mais de 40 e sei que ainda tem um monte que não sei. Eu não me apego a ideologias ou semi-deuses, eu sou promíscuo de ideologias, e eu nunca acho que o mundo vai acabar fácil assim. Não acabou em Roma, nem na 2a Guerra. Não acabou na Guerra Fria. "ahhh mas agora é diferente" nah, é a mesma coisa.









Com tudo isso dito, vamos voltar ao documentário. Um meme que eu sempre achei engraçado é aquele onde um casal tá conversando e a esposa fala como ouviu falar que as grandes corporações estão espionando eles o tempo todo. O marido ri, a esposa ri, a Alexa e a Siri riem juntos. Se o produto é de graça, você é o produto. Você paga pra pesquisar no Google? Você paga pra postar fotos no Instagram? Você paga pra conversar por Whatsapp? Então o produto é você, mais especificamente todos os dados que você gera por dia. Você não é o cliente dessas plataformas, você é o usuário. E de fato, só conheço duas indústrias que não falam em clientes e sim em usuários, e o outro é o tráfico de drogas.









Se você assistir o documentário, parece mesmo uma distopia Orweliana. Existe toda a teoria da conspiração de como as redes sociais cresceram ao ponto de aparentemente conseguir mudar o rumo de uma eleição pra presidente, e como ela pode ser usada pra causar caos e até instigar uma possível guerra civil. E o documentário pinta essas inteligências artificiais como o grande inimigo. Ex-funcionários, ex-executivos e ex-investidores aparecem com aquele ar de "a gente não sabia, nós que criamos mas saiu do nosso controle", meio aquela coisa de "ai nossa, eu pequei no passado e agora me converti e virei crente". 









De repente, por causa disso, eles são os seres iluminados que viram a luz, e por isso eles sabem diferenciar o certo do errado, e o resto da população, coitados, são ignorantes. Mas eles que criaram as plataformas? São seres do bem, acima de todo mundo, que vão nos proteger de alguma forma. Qual forma? Fazendo lobby pra criar regulamentações, formas de controle e agências de censura, pra controlar o que as redes sociais podem ou não fazer, porque coitados, a população em geral é meio burra e se ninguém intervir eles vão continuar sendo explorados. 









Eu lavo minhas mãos, eu não tenho paciência pra ser ativista. Por princípio eu sou contra regulamentações. Regulamentações é um tapa buraco, pra pintar de inimigo uma ovelha negra, e jogar embaixo do tapete o trabalho que não foi feito antes. Pra ver como um documentário tem viés veja que ele faz o possível pra pintar as plataformas de redes sociais como o inimigo que precisa ser domado. Essa é a ovelha negra. Basta ver como o diretor omitiu o mais óbvio, a parte mais importante. Por que a maioria da população é tão simples de ser manipulado? Porque nosso sistema educacional está falido faz décadas.









Com o avanço rápido que vemos na tecnologia parece que o mundo também avança rápido. Mas tirando tecnologia, muitas áreas estão super defasadas, e educação é um dos principais em atraso. É que nem na época da discussão de jogos considerados violentos como Mortal Kombat ou Carmagedon. Ninguém vira assassino e sai matando pessoas na rua porque jogou videogames. Ou na época que o Rock and Roll começou a fazer sucesso e um novo mercado de jovens passou a consumir música. Ou na época que a TV foi lançada e todo mundo temia lavagem cerebral. Pessoas educadas não são facilmente influenciáveis assim. Pessoas não-educadas ou pior, que acham que são educadas, são. Porque na falta de ferramentas pra decidir o que é certo ou errado, elas são obrigadas a ouvir alguma autoridade. Qualquer autoridade. Se antigamente essas autoridades eram, talvez, o padre da igreja, hoje é o streamer influencer.







Existem diversos experimentos que tentam explicar o que leva uma população inteira a apoiar algo que é considerado "mau" hoje. Por exemplo, será possível que a população inteira da Alemanha na 2a guerra realmente achava virtuoso matar judeus? Como isso era possível? Pra dar uma explicação muito simples, eu sempre gosto de apresentar o experimento da conformidade social de Solomon Asch. É curtinho, vamos lá.




(Asch)






Pessoas são animais sociais que parecem ter querer serem aceito por comunidades ou grupos, mesmo não concordando. Esse conceito é meio alienígena pra mim, que sou anti-social, mas é o que eu mais ouço e acho que faz sentido. O trabalho seguinte é mais interessante. Asch foi conselheiro na tese de doutorado de outro pesquisador famoso e controverso, Stanley Milgram, que fez experimentos sobre obediência à autoridade. Vamos ver.



(Milgram)






Quando se fala de psicologia social, o be-a-bá pra mim são Asch e Milgram. Nos temos modernos temos os economistas comportamentais como Dan Ariely que mostrei antes. E talvez vocês esbarrem em outro ponto de vista interessante, o famoso Efeito Lucifer de Philip Zimbardo, mas diferente de Asch e Milgram, cujos experimentos foram repetidos diversas vezes ao longo de décadas, sempre dando os mesmos resultados; o experimento de Zimbardo é cheio de falhas, então se forem ler, leiam com uma quantidade generosa de sal. Mas a conclusão é a mesma: nós achamos que somos racionais e que temos condições de pensar com lógica, mas na realidade não é muito difícil nos manipular. 







O corolário dessa idéia é óbvio: não adianta trocar uma autoridade por outra autoridade, por exemplo, as empresas de redes sociais por grupos políticos. Qual o interesse de parte dos entrevistados do documentários? Eles querem se tornar essas autoridades. É uma estratégia antiga: crie algo que gera problemas, depois venda uma solução desse problema.









Você não quer que os jovens sejam influenciados pela torrente de fake news nas redes sociais? Agora é tarde demais, porque ninguém tem nem nunca vai ter a autoridade pra saber decidir o que é certo ou o que é errado absolutamente. O sistema educacional de praticamente todos os países do mundo ainda opera segundo modelo derivado da época da Revolução Industrial. Todo aluno aprende a obedecer uma figura de autoridade na sala de aula, uma figura de autoridade dentro de casa, e quando cresce e precisa pensar sozinho, ele procura outra figura de autoridade pra seguir, e normalmente erram feio. Os pais que estão apreensivos com as redes sociais hoje não são tão diferentes dos que estavam apreensivos que o rock and roll desvirtuasse a geração nos anos 60 e 70.









Quem assiste meus vídeos sabe como eu repito que não sigo influencers, tenho zero paciência, e também que vocês não devem acreditar em tudo que eu digo e me seguir cegamente, porque eu tenho zero paciência pra ser influencer. Eu sou só um cagador de regras dizendo o que eu sei. Considerem que eu tenho algumas vantagens que me ajudaram ao longo dos anos.








Ao contrário do que muita gente pode pensar se só conhece minha persona de YouTuber, é que eu sou muito introspecto e anti-social. Por mais estranho que possa parecer, eu me dou muito bem com minha própria companhia e me considero auto-suficiente. Sempre que me forço a ir contra minha natureza eu me dou mau. Minha persona pública, esta que vocês estão assistindo, é diferente da minha persona particular. 








Toda pessoa pública tem personas, fachadas. Ninguém é 100% autêntico o tempo todo, é impossível. Isso não é um problema, é normal. E por isso eu foco no resultado do trabalho de alguém e não na pessoa. Um biopic, cinebiografia ou uma biografia em geral é uma obra de ficção que tem a intenção de manipular o público a se sentir inspirado pela história de vida. Por isso muita celebridade publica auto-biografias. Porque todo mundo prefere poder controlar a narrativa da sua história em vez de confiar que outra pessoa vai dizer o que ele queria depois que morrer. 








Você deve analisar qualquer documentário ou biopic da mesma forma que se analisa qualquer filme. Vamos analisar uma técnica pequena mas efetiva pra dar de exemplo. Porque o diretor ou escritor não aparecem pra argumentar seus pontos de vista e sim trazem outras pessoas pra dizer o que ele quer passar? Porque colocar um terceiro falando trás credibilidade, especialmente se é alguém que trabalha ou trabalhou na indústria em questão. Quando aparece o título de ex-engenheiro do Google, dá impressão que ele representa o Google inteiro. O que a maioria não pensa é que o Google é uma organização de dezenas de milhares de pessoas, e estamos ouvindo a opinião de uma pessoa que nem trabalha mais lá. 









Outra técnica pequena. Nenhum diretor edita cenas à toa. Cada cena que ele te mostra tem um propósito, o objetivo de causar alguma reação ou emoção. Porque todos os entrevistados estão sentados? Mais importante, por que no começo do documentário mostra um pseudo-bastidores, eles chegando e se sentando, gaguejando? Isso é pra causar empatia, pra você se conectar com os entrevistados. Se aparecer direto só o título deles como ex-investidor, ex-fundador, ex-engenheiro, você vai se sentir desconectado. Mas se mostra eles chegando e se sentando na sua frente, como se estivessem chegando na sua casa, sentando do seu lado, é como se fosse um amigo ou conhecido seu chegando pra dividir uma breja com você. Você baixa sua guarda e ouve  como se fosse um amigo. 









Mesma coisa no fim, eles discutem como tentam educar os filhos criando limites pra usar apps e redes sociais em casa. A informação em si já é super conhecida, clichê até. O objetivo não é te explicar uma solução. É só mais uma técnica de empatia. Pra vocês que são pais se relacionarem e pensar "nossa, ele é gente como a gente, com os mesmos problemas". Todo político faz isso em campanha. Eu sou anti-social, essas técnicas não funcionam comigo. Eu não consigo ter a reação de me identificar com eles, pelo contrário, eles simplesmente parecem mais suspeitos fazendo isso. 








Outra técnica inteligente pro documentário não ficar expositivo demais e por consequência muito cansativo, é editar as entrevistas com a historinha de ficção de uma família enfrentando problemas do dia a dia por causa das redes sociais. O filho que tá sendo influenciado por canais extremistas. A hora do jantar que a família não sabe mais conversar. A filha que tá sofrendo com confusão da sua identidade pelo que se fala online, entrando em depressão. Aliás, essa é a parte mais apelativa do filme, acontece na seção central e tem como objetivo causar horror e pânico em quem está assistindo. 


(...)





Se você não tava convencido até agora, essa é a parte projetada pra te convencer. E essa parte te leva ao midpoint do filme, a grande revelação ou virada de eventos. Quem tá causando esse aumento no suicídio de meninas? 





A inteligência artificial. É revelado que estamos travando uma guerra impossível de vencer. Eles explicam como o poder de processamento aumentou exponencialmente nos últimos anos mas nossos cérebros não evoluíram quase nada nos últimos milênios. E a narrativa infere que as grandes corporações que criaram essas inteligências artificiais perderam o controle dessas plataformas e a população em geral vai perder a guerra e estar a mercê de ser controlada. E quem vai consertar isso? Provavelmente essas pessoas boazinhas que o filme passou uma hora fazendo você se empatizar. É assim que você vende uma autoridade.












Com isso vocês entendem porque eu não dou muita bola nem pra documentários e nem pra biografias. Eu aprecio a produção quando é bem feita, e consumo como  consumiria qualquer obra de ficção. Mas eu sempre me faço a pergunta mais óbvia: "a quem essa mensagem beneficia?" ou o famoso clichê "siga a trilha do dinheiro". Pensamento crítico não é só criticar as coisas, a premissa é que você entende como funcionam as engrenagens dos sistemas do mundo. E a palavra chave aqui é "entende" e não "acredita". Quanto menos crenças você tiver, menos difícil é entender o mundo. A maioria de nós começa tendo uma crença e usamos isso como o molde pra enxergar o mundo. Daí tudo que não encaixa nessa crença parece um defeito que precisa ser corrigido.









Eu penso diferente, eu observo o mundo e crio modelo mentais em cima da realidade, incluindo as parte que não gosto. Eu aceito que o que eu considero como defeitos são resultados naturais. Eu não gostar não vai mudar nada. E daí vou tentar entender porque essa parte que eu não gostei existe, qual propósito serve ou serviu, e mais importante, como isso pode me beneficiar. Por exemplo, se você assiste o documentário, acredita na visão de mundo que ele propõe, sem questionar muito, você deveria ficar extremamente desconfortável. Se você se acha mais esperto talvez pense "ah, por isso que eu já cancelei minha conta de Facebook".









Toda vez que eu vejo um tweet desses eu giro os olhos. Porque eu acho meio idiota mesmo. Nenhuma corporação ou inteligência artificial tá interessado em você individualmente. O Google não acorda todo dia pensando "vamos espionar o que o Fabio Akita tá fazendo neste minuto pra poder foder ele depois". A eficiência de recomendar conteúdos sob medida pra mim depende de ter mais e mais detalhes sobre mim. Mas eu sei como isso funciona, pra mim não faz diferença nenhuma. Sair da rede social não muda a rede social. Você acha que só porque você twitou que saiu e meia dúzia de pessoas deram like, você é virtuoso por alguma razão? É o mesmo tipo de bullshit de alguém que twita que comprou um Tesla pra salvar o meio ambiente. Bullshit, você comprou porque tem dinheiro e o carro de fato é interessante de dirigir. Só isso. Aliás, é outro video do canal do Adam Ruins Everything que recomendo.










Os entrevistados do documentário, ou influencers que se gabam de ter saído do Facebook mas continuam no YouTube ou Twitter, praticam o que se chama de "sinalização virtuosa", que é a prática de declarar que fez uma ação aleatória que parece virtuosa e declarando publicamente pra que outras pessoas possam dar like nela dizendo "nossa, que pessoa virtuosa". É tosco, porque na prática não mudou nada. Nunca siga uma pessoa por coisas assim, e sim pelos resultados mensuráveis de sucesso e consistência ao longo dos anos, o que uma pessoa late em rede social é descartável. Entretenimento de pipoca, como qualquer filme blockbuster.








A grande conclusão de tudo isso, que o documentário não fala, é que se os tais problemas descritos existem, eles não são inteiramente culpa das plataformas de redes sociais ou inteligências artificiais. Eles são ferramentas. Se quiser pode pensar que são como armas. Armas não atiram sozinhas, pessoas atiram. O que essas ferramentas possibilitaram foi só acelerar e amplificar o problema dos indivíduos. A culpa sempre é dos indivíduos. Todo mundo é adulto e não dizer "ah, eu sou um coitado, ninguém me protegeu, e por isso eu fiz merda". Daí aparece outra corja dizendo "é isso mesmo, ele não tinha como saber, mas eu sou um ser iluminado e eu sei o caminho da luz, e por isso vocês devem deixar que eu proteja todo mundo". Isso nunca dá certo.








E por hoje é isso, o objetivo de hoje era dar uma pincelada em diversos assuntos sobre entendimento do mundo, entendimento do comportamento das pessoas, e a fraqueza das suas próprias convicções, inspirado por esse documentário do Netflix. Munido de tudo que eu falei, se você entendeu pelo menos metade do que eu disse, acho que pode assistir o documentário e não sair dele mais manipulado do que quando entrou. É uma produção muito bem feitinha que, tirando o melodramático, é interessante de assistir quando não tiver nada pra fazer. Ou, se você tem mais o que fazer, a versão de 5 minutos do Adam Ruins Everything diz exatamente a mesma coisa, em menos tempo. E se você curtiu esse vídeo mande um joinha, assine o canal e clique no sininho pra não perder os próximos vídeos. Compartilhe com seus amigos pra ajudar o canal. A gente se vê, até mais.
