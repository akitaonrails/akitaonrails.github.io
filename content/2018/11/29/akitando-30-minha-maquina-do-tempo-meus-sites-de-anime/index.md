---
title: "[Akitando] #30 - Minha Máquina do Tempo | Meus Sites de Anime"
date: '2018-11-29T17:00:00-02:00'
slug: akitando-30-minha-maquina-do-tempo-meus-sites-de-anime
tags:
- backup
- animax
- revista Herói
- Cavaleiros do Zodíaco
- Evangelion
- Windows 98
- VMWare
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


<iframe width="560" height="315" src="https://www.youtube.com/embed/0KNGiOp7eoE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


### Descrição no YouTube

Uma coisa que recomendo que todo mundo faça: backups. Faça backup de todos os seus trabalhos. Daqui 20, 30 anos, você vai se agradecer por ter feito isso.

Aproveitando a dica, quero abrir uma pequena janela pra um hobby que eu tinha nos anos 90: os sites de anime que eu fazia.

E ainda terminando com uma confusão que deu até boletim de ocorrência :-D

Links:

* Meu Passado Otaku – A revista de anime que publicou… um Boletim de Ocorrência (!!!) (https://maisdeoitomil.wordpress.com/2016/03/07/meu-passado-otaku-a-revista-de-anime-que-publicou-um-boletim-de-ocorrencia/)

AkitaOnRails:

* [Off-Topic] Meu Backup Pessoal (Drobo/Time Capsule) (http://www.akitaonrails.com/2009/09/19/off-topic-meu-backup-pessoal-drobo-time-capsule)
* [Off-Topic] Faça Backup do seu Ambiente (http://www.akitaonrails.com/2011/03/01/off-topic-faca-backup-do-seu-ambiente)

## Script

Olá pessoal, Fabio Akita

Se vocês ainda não me seguem nas redes sociais procurem por AkitaOnRails no Facebook, Twitter e Instagram. Quem me segue no Instagram sabe que alguns dias atrás eu resolvi finalmente abrir minha cápsula do tempo. Os códigos que vocês viram nos episódios da série Sua Linguagem É especial? vieram daí.

Quando eu era criança eu não lembro se foi no Show de Beakman ou outro programa infantil desse tipo, onde eu vi o conceito de Cápsula do Tempo pela primeira vez. Não é só acumular velharias. É empacotar seu presente intencionalmente pra ser aberto bem no futuro.

Intuitivamente eu nunca tive vontade de fazer o mais óbvio: pegar uma caixa de sapato e colocar pertences meus da época como uma fita cassette ou brinquedo. Em vez disso eu queria de alguma forma preservar o que eu era. E eu me defino não pelo o que eu possuo, mas o que eu penso e produzo. Eu não sou apegado a nenhuma posse. Por sorte, tudo que eu produzo é digital.

Eu já tinha visto os disquetes de 8 polegadas e depois os de 5 1/4 polegadas ficarem obsoletos, eu estava vendo os disquetes de 3 1/2 ficarem obsoletos. Então eu fui gradativamente passando tudo de disquetes pra zip drives, de zip drives pra CD-ROMs (quando finalmente os gravadores ficaram acessíveis), de CD-ROMs pra DVD. E de DVD pra HDs. As coisas hoje em dia estão muito fáceis, antigamente eu tinha caixas e caixas de disquetes, CDs e DVDs, hoje cabe tudo num HDzão.

Em 2008 obviamente eu tinha noção que HDs tem vida útil e costumam falhar, são dispositivos mecânicos que não foram feitos pra durar pra sempre. Assistindo os primeiros video casts, programas tech que existiam desde antes do YouTube, que você via no iTunes, eu vi um programa da Kali Lewis sobre Drobos. Eu já sabia o que era uma configuração RAID de storage pra servidor mas eu achava complicado pra ter em casa. Mas o Drobo tinha a intenção de ser portátil e plug and play. Então eu resolvi pedir pra um amigo trazer pra mim.

E o Drobo realmente funcionou. Eu fiquei com esse Drobo por 10 anos. Nesses 10 anos eu troquei discos 2 vezes porque falharam, e isso justificou essa compra. Custou caro pra caramba, na época foi quase 800 dólares se somar com os HDs. Mas se considerar que foi 800 dólares que protegeram minha história por 10 anos, eu digo que foi extremamente barato. Eu troquei de Drobo ano passado. A porta USB 2 era muito lenta, troquei pelo mesmo modelo com USB 3, que ainda não chega a ser um Thunderbolt, mas já ajuda. Eu tirei todos os 4 HDs do antigo, coloquei no novo, e boom, plug and play, tudo funciona. Impressionante.

O objetivo não é fazer propaganda do Drobo, claro, mas eu não confiaria em nenhum HD externo que não seja redundante. Aliás, muito cuidado, existem muitas configurações de HD externo com 2 ou mais HDs em layout de RAID-0 com striping. É só a pior configuração imaginável porque se você tem 2 HDs de 500 GB em striping, você enxerga como se fosse um único HDzaão de 1 TB. Só que não tem proteção contra erro nem redundância, se um dos HDs falhar, você perde os dados DOS DOIS. Jamais use RAID-0. E RAID-1 é o pior custo benefício porque é basicamente um HD fazendo cópia do outro.

Temos outro problema hoje em dia. Tudo está no maldito cloud. O problema não é o cloud, o problema são serviços que dificultam você sincronizar uma cópia local. Você está tão acostumado que o Google vai cuidar dos seus e-mails, que o Dropbox ou Microsoft OneDrive ou Google GDrive vai cuidar dos seus arquivos, que o Slack vai cuidar dos seus chats, que a Apple vai cuidar das suas fotos e músicas, que você literalmente não pensa em fazer mais backup hoje em dia.

Eu prefiro partir do princípio que qualquer um deles pode ter uma falha amanhã, nem estou dizendo falir, uma falha mesmo, e podem perder meus dados. Eu não preciso guardar tudo, mas de meses em meses eu acho saudável exportar os arquivos do Twitter, eu gosto de abrir um Mozilla Thunderbird e conectar nos meus diversos e-mails pra sincronizar tudo local via IMAP, prefiro baixar tudo do Dropbox e manter um backup local no meu Drobo, e assim por diante. 

Nos últimos anos eu confesso que tenho sido menos cuidadoso com meus backups por conta de todos esses serviços cloud, mas é bom não descuidar. 25 anos depois, eu me arrependo de não ter guardado os fontes dos meus primeiros programas em Basic. Existem coisas que quando você tiver conseguido guardar dinheiro vai ainda conseguir encontrar algum colecionador vendendo, um MSX, um TK-85, mas seu primeiro programa? Isso não tem mais como.

De qualquer forma, este mês eu finalmente resolvi abrir meus arquivos antigos. Meus e-mails de 1997 a 2006, quase 10 anos de e-mails foram preservados em arquivos PST do Outlook que, felizmente, são fáceis de abrir. De 2006 em diante está tudo no Gmail. 
Viu meu vídeo sobre Sua Linguagem É Especial que eu mostro os sites que eu trabalhava pra PSN como o do Corinthians e Cruzeiro? Eu tenho as imagens porque eu ainda tenho o Photoshop original que eu usei pra recortar as imagens pro site. Estavam como anexo nesses e-mails.

Essa é uma daquelas coisas que de vez em quando dá trabalho, você gasta dinheiro e tempo, mas o prêmio é que eu tenho uma oportunidade única: de viajar no tempo, pra qualquer lugar de hoje até mais de 20 anos no passado. Eu ainda ia esperar mais uma década antes de abrir, mas eu sinto que agora é a hora de fazer isso. Vai que amanhã eu morro e perco a oportunidade de deixar registrado pra posteridade?

Eu não guardei todos os instaladores de todos os programas que eu usava. Mas por sorte achei esse site WinWorld que tem instaladores de tudo que é programa dos anos 90. Achei até o instalador de Clipper, FoxPro e tudo mais que eu usava. E graças ao VMWare Workstation Pro que eu uso todo dia, ele também suporta Windows 95 em diante. Eu comecei antes do Windows 95, no MS DOS 3 e usei tudo que a Microsoft lançou do fim dos anos 80 até 2004 que foi quando migrei pra Apple e Mac até voltar pro Windows 10 anos depois em 2015. O Windows 98 foi um dos que eu mais usei nos anos 90 por isso instalei ele.

Como eu já falei bastante, por hoje quero mostrar um dos primeiros sites pessoais que eu fiz. É tão velho que se não for Internet Explorer 4 ou Netscape Navigator 4, o site nem renderiza direito. Essa é uma época anterior a eu aprender ASP ou PHP, quando eu fazia sites estáticos com HTML puro, estamos falando de 1997.

Em 1994 o Brasil foi pego de surpresa quando a Manchete resolveu lançar Cavaleiros do Zodíaco. De repente eu comecei a ver mais gente falando de anime. Até então gostar de anime era um troço bem solitário. Eu cresci assistindo anime gravado em fita Betamax e VHS que vinha do Japão no meio dos anos 80. Mas depois de 1994 todo mundo queria mais e mais anime. Shurato, Sailor Moon, Yuyu Hakusho, e tantos mais. Em 1995 surgiu uma das primeiras revistas especializadas em anime e cultura japonesa, a revista Herói. Daí na sequência saiu um pasquim de pior qualidade chamado Japan Fury que depois se tornou Animax em 1996.

Por coincidência eu fazia parte de um grupo de pessoas que se auto-intitulava Orcade e participava dessa revista, então eu mesmo escrevi um ou dois artigos, em particular sobre Evangelion, que eu me considerava especialista na época - típico de amador se achar especialista mesmo . Como eu tinha acabado de aprender HTML e quando virei monitor na sala de computação da USP eu ganhei acesso ao servidor Unix da Politécnica e como em toda faculdade da época, toda conta tinha uma pasta exposta no Apache pra internet, então decidi fazer um site pra revista. Essa foi a Animax Plug-In.

Essa é a primeira versão, que eu fiz usando o bom e velho Microsoft FrontPage 3.0. Eu sei, eu sei, nem precisa dizer, esse design é tenebroso até pros padrões da época, se bem que em 1997 não se tinha tanto padrão assim pras coisas, em outro vídeo vou mostrar os sites profissionais que fazia com designers de verdade da época. Mas por agora veja que a gente usava framesets e frames e muito table. Não tinha CSS ainda. E o destaque é o menu lateral que abre e fecha, quer dizer, abre e fecha no Netscape mas não no Internet Explorer. Pois é, diferença de Javascript entre navegadores é antiga, a web nasceu quebrada e a gente vem tentando consertar desde então. Mas é legal ver funcionando de novo, em navegador novo nada funciona. Nessa época Internet Explorer era superior ao Netscape já. Renderizava bem mais rápido, Javascript era mais rápido. Eu escrevia pra caramba, vocês podem ver que minha mania de fazer textão não vem de hoje.

Lendo meus textos fica claro que eu escrevia bem mal. Eu ainda não tinha adquirido a noção de editar meus textos. É como programador júnior que ainda tem dó de apagar o código que escreveu. Hoje em dia eu às vezes escrevo páginas e páginas e no meio do caminho eu vejo que está ruim e jogo tudo fora e começo do zero, ou vou refinando o texto, apago seções inteiras. Não existe escrever em apagar. O melhor fluxo é deixar tudo crú sair da sua cabeça, e quando terminar esse dump, daí sim reler e começar a ajustar e apagar e reorganizar.

De qualquer maneira, esse design está um pouco mais engolível. Eu ficava tentando fazer jeitos bizarros de navegação. Dessa vez em vez de um menu lateral eu tinha um menu no fim da página que ia abrindo sub menus pra cima. E eu tinha conceito de uma página que abre a próxima. Naquela época não era muito claro qual a melhor abstração pra organizar conteúdo. Vocês vão notar que nessa época era comum a gente querer simular o estilo de layout editoração de revista. E eu tinha de tudo nesse site, até uns textos tentando ensinar japonês, como se isso fosse fazer alguma diferença. E como ainda não existia Google também era comum os sites terem páginas linkando outros sites, como uma bibliografia ou recomendação.

Na sequência essa é a terceira ou quarta versão. Isso já era 1999, 3 anos fazendo isso. Esta é um pouquinho mais aceitável, pelo menos um pouco mais limpo. De novo note o estilo de layout inpirado em revistas. Eu gastava meu parco salário comprando revistas importadas de anime nessa época, eu queria fazer juz ao investimento. E, de novo, note o menu lateral em Javascript só que dessa vez com inspiração em ícones do Mac OS 8 que eu tinha acesso na agência onde fazia estágio. E continuando no mesmo estilo das outras versões eu colocava mais e mais seções de mangás novos explicando um a um em detalhes, olhando agora eu fico pensando se teria paciência de fazer a mesma coisa hoje em dia.

Eu cheguei até a iniciar um projeto onde eu escaneei vários volumes de um manga que eu gostava e ficava traduzindo balão a balão no photoshop, puta trampo, mas antigamente não existia mangareader e mesmo no mangareader, alguém faz esse tipo de trampo. Eu sei exatamente como dá trabalho

Essa atividade durou uns 3 anos. Durante esse tempo o site ficava hospedado na minha conta no UNIX da faculdade, mas na realidade eu não podia usar a conta da faculdade pra um site de revista comercial, mesmo que eu não ganhasse nada por isso. Eu ganhei zero reais, a revista não dava dinheiro, o site não dava dinheiro, a gente fazia tudo isso porque gostava. Vocês podem ver que isso de eu gastar todo meu tempo livre fazendo coisas trabalhosas só pela diversão vem de longa data. 

Mas o que eu ganhei com isso foi outra coisa: com esse exercício todo, eu fiquei rápido pra layoutar sites no estilo da época. Podia me dar qualquer photoshop que eu recortava e montava muito rápido na agência. Sabia otimizar as imagens, otimizar o HTML - pelo menos pros padrões da época, e eu exercitei muito o Javascript da época. Isso seria muito útil nos anos seguintes. 

Além disso eu treinei muito minha escrita. Como eu disse antes, lendo agora, é fácil ver que meus textos não eram bons, mas também dá pra ver que mesmo nesse curto período eu escrevi o suficiente pra encher as páginas de um pequeno livro. Eu escrevia em detalhes sobre as séries que eu gostava, indo de personagem em personagem, isso deu tipo MUITO trabalho. Mas novamente, esse trabalho também me ajudou muito, os meus e-mails no trabalho sempre foram completos e concisos, porque eu tinha treinado muito escrever em grande quantidade em pouco tempo.

Ou seja, quando eu comecei meu blog em 2006 eu já tinha escrito muito texto anos antes. E agora escrevendo scripts aqui pro canal, é tudo uma sequência. Eu não sou escritor profissional, mas eu vim aprendendo as técnicas e tentando refinar com o passar do tempo. Mesmo em 1999 comparado com 1997 eu já tinha melhorado.

E como última curiosidade, uma das coisas que atraía as pessoas pra Animax Plug-in e minhas matérias na revista é porque eu era um troll. Como eu disse, a revista Herói era uma droga em termos de conteúdo. Ela vendia porque na época não tinha nada na internet, e todo mundo queria qualquer coisa Cavaleiros do Zodíaco e outros animes. 
Então eu tinha vários artigos listando um a um todos os erros dos textos da Herói, e não era errinhos ortográficos - que tinha de monte aliás - eram erros conceituais, contava a história errada mesmo. E eu não era sutil, eu chamava pro pau mesmo, eu diz sr Fulano, você não manja porque esse ponto X tá errado, ah e esse ponto Y tá totalmente errado. 
Ah, e eu nos meus 20 sou que nem vocês nos seus 20, só que em vez de ficar tweetando, eu fazia matéria de revista.
E eu sei porque todo mundo gosta de extravazar no twitter, é extremamente satisfatório enfiar o dedo na cara dos outros, cagar um monte de regra, pisar no calo dos outros e ainda ter gente aplaudindo você fazendo isso. Mais satisfatório ainda quando o outro lado reage e vira uma briga. Acho que faz parte da natureza humana.

Hoje eu não faço mais isso. Pelo menos não desse jeito e jamais em público. E não é só por questões de imagem ou qualquer coisa assim. Deixa eu dar uma perspectiva: minhas matérias e artigos circularam entre 1997 e 1999. Hoje em dia, não tem uma pessoa que se lembra mais disso. Os assuntos da época foram todos esquecidos. Pra todos os efeitos, é como se nunca tivessem existido. As brigas são divertidas na hora, mas no final ninguém vai se lembrar, com exceção de quem você pisou no calo. E depois daquela satisfação momentânea, você se sente vazio porque no final, não mudou nada. E você fica querendo ir atrás da próxima briga pra ter de novo a satisfação momentânea, é um vício.

Dê tempo suficiente e qualquer briga que você achou que valia a pena apostar tudo, depois de alguns poucos anos não tem valor nenhum. Não deixa de ser um pouco o: faça o que eu falo mas não faça o que eu fiz. Por outro lado tinha gente que me dizia isso na época, quem disse que eu dei atenção? 

O cara da revista Herói ficou tão puto que foi atrás do editor da Animax e socou ele na rua. Foram parar na polícia. E quem escreveu o texto ainda fui eu :-) hahaha Coitado. Vou deixar linkado na descrição se alguém se interessa nesse tipo de história.

Minha recomendação de hoje é: guarde o que você produz, mesmo que você ache que é uma droga. Daqui 20 ou 30 anos vai ser interessante constatar que você realmente evoluiu nesse tempo. Não confie nos serviços de cloud, você provavelmente vai viver mais do que eles. Muitos serviços que eu usava nos anos 90 e começo dos anos 2000 já não existem mais. Lembram do ICQ? Hotmail? Orkut?

E como eu disse no vídeo anterior, eu venho praticando deliberadamente a atividade de escrever desde o meio dos anos 90, agora vocês sabem porque eu escrevo tanto. Estamos no episódio 30 deste canal. Cada episódio tem em média umas 6 páginas no Google Docs, então desde Agosto eu já escrevi 180 páginas de texto, mais de 10 páginas semanalmente, ininterruptamente por umas 15 semanas já. Vou dizer que eu estou bem cansado, vamos ver até onde meu corpo aguenta.

E por hoje é isso aí, faça backups! E não deixe de comentar abaixo! Se curtiram mandem um joinha, compartilhem o vídeo com seus amigos, assinem o canal e cliquem no sininho. A gente se vê, até mais.


