---
title: 'Hanselminutes: Entrevista com David Hansson e Martin Fowler'
date: '2007-07-08T00:20:09-03:00'
slug: hanselminutes-entrevista-com-david-hansson-e-martin-fowler
tags:
- translation
- hanselman
draft: false
---

Como [disse antes](http://www.akitaonrails.com/articles/2007/04/14/off-topic-seja-arrogante), eu ouço muitos podcasts. Todos os dias meu iTunes baixa mais e mais. Isso já me deixou com uma fila enorme de programas ainda a ouvir. Este [episódio](http://www.hanselman.com/blog/HanselminutesPodcast65MartinFowlerAndDavidHeinemeierHansson.aspx) do podcast **Hanselminutes** , em especial, está me esperando desde a RailsConf que aconteceu mês passado.

[![](/files/Scott_Hanselman.jpg)](http://www.flickr.com/photos/computerzen/505364200/)

O host do programa é Scott Hanselman, que na realidade é do mundo .NET, Microsoft, mas que também cobre outras plataformas. Nesse episódio ele estava na RailsConf 2007, em sua cidade natal que é Portland, no Oregon. Ele teve a oportunidade de entrevistar David Heinemeier Hansson e Martin Fowler ao mesmo tempo. Vocês podem ler a transcrição literal da entrevista em [PDF](http://perseus.franklins.net/hanselminutes_0065.pdf).

Eu achei esta uma das melhores entrevistas dos dois e, como sempre, resolvi que devia traduzir. Porém, essa transcrição está muito literal. Ou seja, está exatamente como eles falaram. O problema disso é que o formato está extremamente informal, disperso, _quebradiço_, por assim dizer. Eu comecei a traduzir mas o texto ficou tão emaranhado que quase no final resolvi jogar tudo fora e começar novamente. Em vez de traduzir ipsis literis como falaram, vou tentar expôr as idéias principais deles de forma mais organizada para que vocês consigam entender. Mesmo assim, recomendo ouvir o podcast, no áudio a conversa faz mais sentido.


## HTML e CSS

O primeiro assunto começa quando Scott diz estar cansado de ficar escrevendo tags para criar telas. Ele acha que numa atualidade onde temos efeitos tridimensionais no Linux (com o projeto Beryl), o Mac OS X (que já levou 3D em conta há anos) e o recém-chegado Windows Vista, o visual ‘limitado’ do HTML talvez esteja mostrando sua idade.

David e Martin discordam disso, assim como este _humilde_ tradutor que vos fala. Na realidade HTML e CSS são perfeitos para o trabalho. É um argumento que já foi discutido várias vezes nos últimos anos, mas é inegável que em 10 anos de história, nenhuma outra tecnologia conseguiu fazer frente ao HTML.

Tivemos Applets, o próprio Flash, agora temos tentativas como Apollo, Silverlight. David tem um argumento muito bom: nenhuma dessas ditas ‘alternativas’ apresenta nada de novo. Qual a diferença de um botão em Flash ou um botão em HTML? Absolutamente nenhum, ambos têm os mesmos eventos, fazem as mesmas coisas. A diferença é que em HTML é muito mais simples, padronizado. No fim do dia, um Silverlight talvez tenha efeitos-especiais, enfeites, mas não passa disso: firulas.

No fim do dia, o usuário ainda estará utilizando exatamente os mesmos elementos: vai arrastar o mouse sobre um botão e clicará nele. Vai escolher uma caixa de entrada e digitar seus dados. Vai clicar numa lista e escolher um ítem. Claro, existem os casos extremos, como algum Widget de Mac (ou Gadget, ou Vista), onde você queira ver a planta de sua casa, arrastar os móveis de lugar para visualizar como vai ficar.

Porém, o problema é esse: esse tipo de interface é o caso extremo, a exceção à regra. Somente um caso e centenas. A grande maioria dos casos de aplicação Web é o bom e velho formulário. E foi exatamente para isso que surgiu o HTML e o CSS. Flash pode ser bom para Widgets, não para aplicações Web.

Talvez amanhã, quando tivermos telas multi-touch ou coisas assim, alguém consiga inventar uma maneira completamente nova e muito melhor do que os paradigmas atuais. E o ponto de David é: se isso acontecer, faz sentido ir atrás. Mas enquanto essas coisas não passarem de promessas, não faz sentido segurar a respiração até acontecer. Enquanto isso, HTML e CSS são bons o suficiente para tudo que precisamos hoje.

## “Tela Branca”

 ![](/files/80160232_867ff0523b.jpg)

Outro excelente argumento de David é contra a “Tela Branca”, no sentido de um quadro em branco que você precisa pintar. A tese é que a maioria das pessoas não se dá bem com telas em branco. O problema é que você tem liberdade de fazer qualquer coisa. Nesse sentido, cada novo projeto seria mais uma tela em branco. Antes de Rails tínhamos que refazer as mesmas coisas o tempo todo. Reinventar a roda. Alguns gostam disso, mas não quer dizer que é a maneira correta.

Novamente, esse é o problema com os ditos ‘candidatos’ a substitutos do HTML. O erro deles é achar que a Web precisa ser reiniciada, começar do zero, começar com outra tecnologia em cima de uma tela branca. Onde está a inovação? Porque começar do zero para fazer os mesmos formulários novamente? Apenas para ter uma animação extra desnecessária? Qual o ponto, senão os casos extremos? Onde está o benefício senão aumentar a confusão?

Como uma nota extra: não precisamos de mais ditos ‘substitutos’. David colocou um ponto interessante: as pessoas buscando a _Próxima Grande Coisa_ são _Pesquisadores_, mas não podemos confundir pesquisa com desenvolvimento do dia-a-dia. Martin completou bem: desses _pesquisadores_ talvez 5% consigam surgir com algo realmente revolucionário, que talvez valha a pena investir. Obviamente, não temos como saber quem são os 95% que são puro lixo, portanto só nos resta investir nos 100% para descobrir. Mas se ele precisasse chutar iria atrás das pessoas que estão fazendo pesquisas mais aprofundadas no assunto da real interação do usuário com o aplicativo. Não somente artesões de novos ‘botões animados’, mas sim aqueles que estão buscando melhorar o contexto de interface de usuário como um todo.

David dá outros bons argumentos. Veja o AJAX, só agora as pessoas descobriram _“Puxa, dá para fazer coisas incríveis com JavaScript manipulando dados em tempo real no browser.”_ Em bom português, todos se sentiram ‘pintos no lixo’, se esbaldaram e já exageraram. Mesmo com coisas simples como Ajax as pessoas ainda tem muito o que aprender. Não precisamos de nada a mais do que isso neste momento.

Quando você dá telas em branco aos desenvolvedores, eles ficam obcecados. Perdem seu tempo criando enfeites e perdem o foco no verdadeiro objetivo: a interação do usuário com a aplicação. Nós ainda estamos longe de esgotar as possibilidades da tríade HTML, CSS e JavaScript. _“Precisamos aprender a andar antes de começar a correr”_ e nesse assunto ainda estamos engatinhando. Se começarmos a correr desde agora ainda acabamos indo na direção errada. Portanto, não, não precisamos de mais telas em branco ainda.

Como nota à parte de mim mesmo, eu diria que o futuro próximo nas interfaces de usuário não será via um novo plugin vetorial ou applet Java. O correto é puro e simplesmente o [HTML 5](http://www.whatwg.org/specs/web-apps/current-work/), uma evolução natural do HTML 4 e do XHTML 1.0 que já usamos hoje mas adaptado a aceitar mais eventos, mais propriedades nos elementos que já existem. Muitas das coisas do HTML 5 nós já fazemos hoje, mas para funcionar precisamos embutir quantidades obcenas de JavaScript. A idéia do consórcio formado pela Apple, Mozilla e Opera pode não ser perfeita, mas é uma boa evolução sobre um HTML que não é atualizado significativamente há uma década. Felizmente, parece que os burocratas da W3C finalmente resolveram fazer as peças moverem.

## Web Design

 ![](/files/224116549_c1f14e8480.jpg)

Isso me leva a outro assunto interessante e que a maioria está cansado de saber mas continua fazendo errado. O bom e velho _“faça o que eu digo, mas não faça o que eu faço.”_ Nos processos de desenvolvimento padrão de aplicações Web, primeiro a ‘equipe de design’ faz os ‘protótipos’ da aplicação: fazem uma imagem em Photoshop de cada tipo de página. Dezenas de imagens. Depois disso pronto, passa para alguém recortar e montar em tabelinhas dentro do Dreamweaver.

**Errado!** Esta é a maneira mais equivocada de se considerar em um processo. Como David diz: é péssimo usar Photoshop para prototipar a Web pois são mídias completamente diferentes. Fazer cantos arredondados no Photoshop é algo trivial, em HTML e CSS é horrível. É como pedir para um escultor prototipar em argila e depois a coisa real tem que ser feita em metal. Não dá: o designer precisa estar o mais humanamente próximo do metal, moldar diretamente no material final.

A outra maneira errada: fazer o desenvolvedor começar a codificar antes de saber como ela deve ficar. O problema é que o desenvolvedor fará o mais simples, não o melhor. Pois não há referencial a ele. O pensamento mais comum é _“farei de qualquer jeito, depois o designer fará ficar bonito”_. Isso não funciona. _“Mas o designer deixou rosa, com cantos arredondados e tudo bonitinho, não entendo porque o usuário não consegue usar …”_

Na 37signals os web designers começam fazendo algumas poucas páginas diretamente em HTML. Essa é outra vantagem de HTML e CSS: eles possibilitam colocar ferramentas simples diretamente nas mãos dos designers. No fundo, um web designer não é somente alguém para colocar cores bonitas, mas sim para colocar cores úteis. Um bom Web Designer na realidade é um Designer de Interação.

Uma vez que as primeiras páginas estão prontas, logo elas são convertidas para Rails e a partir daí o designer é obrigado a evoluir as páginas diretamente no HTML, no meio de código Ruby. Isso ainda traz outra vantagem: ninguém precisa conjecturar como a aplicação seria: ela já está funcionando. Agora qualquer mudança é sobre a coisa real. E mais: nada dos horrendos Lorem Ipsum como textos para preencher os vazios da página. Agora o designer pode entrar com dados reais.

## Integração Contínua: Especificações são Inúteis

E como evitar que os designers quebrem o código? Primeiro, temos que parar de considerar que todo designer é tão burro assim. Existem designers burros, mas para começar estes nem deveriam estar trabalhando. Os outros se dão bem trabalhando dessa maneira, sendo ao mesmo tempo designer e usuário. E para garantir a estabilidade do trabalho: testes. Os desenvolvedores tem que criar a suíte de testes desde o começo para evitar que qualquer um quebre as coisas. Quanto mais a aplicação estiver coberta por testes, mais difícil para um designer quebrar o código.

Como Martin bem lembrou, esse processo de designers e desenvolvedores trabalhando juntos levam a iterações muito curtas, coisa de poucas horas ou poucos dias. As decisões são tomadas e implementadas, num processo de integração contínua. Nesse sentido, não existe a burocracia de voltar atrás, buscar alguma especificação funcional e começar mudando de lá: a aplicação em desenvolvimento é a especificação, principalmente porque, como disse David, não existe nada de funcional em uma especificação. A única coisa que se pode chamar de ‘funcional’ é uma aplicação rodando. Não há necessidade de especular _“como será que vai ficar”_ ela literalmente já é, a questão agora é _“como melhorar?”_

![](/files/443657782_c8632e2081.jpg)

São os primeiros passos para um desenvolvimento ágil. Em vez de se preocupar com a burocracia, com especificações, com protótipos, com Photoshops, toma-se uma direção ‘designer-primeiro’. Mas não no sentido que os designer vão se trancar durante três meses e sair do quartinho com dúzias de layouts para passar para os desenvolvedores. As iterações são muito mais curtas, o protótipo passa para uma tela real muito rápido. E, como disse antes, é preciso uma boa dose de disciplina e testes para manter tudo rodando e evoluindo ao mesmo tempo. Parte disso, como descreveu Martin, é que o Rails meio que nos força a criar uma aplicação modularizada, que incentiva a criação de testes.

## Negando novamente a Tela Branca

Quando começamos um novo projeto, digamos, em Visual C#, a ferramenta nos dá basicamente uma pasta listando as dependências de DLLs e outra pasta simples para códigos-fonte e é só. Uma das coisas que mais agradou Martin no Rails foi o fato dele pré-criar diversas pastas, cada uma com sua função. Rails tenta forçá-lo a fazer a coisa certa dificultando a coisa errada. Para que você faça feio em Rails, é necessário explicitamente querer fazer feio, apagar as pastas que já foram criadas, mover as coisas para lugares errados e assim por diante. Dá tanto trabalho fazer do jeito errado, que ninguém realmente faz isso.

Em .NET existe algo similar em projetos paralelos como o _Tree Surgeon_, mas a diferença é que na comunidade Rails existe algo no sub-consciente de todos que levam a essa uniformidade. Quando o gerador de Models gera um teste unitário, a idéia é que o desenvolvedor pense _“puxa, o gerador criou um arquivo de teste, isso significa que eu deveria estar testando”_. Existe motivação para fazer as coisas do jeito certo.

E isso só acontece porque Rails não é uma tela branca. Ela coloca uma série de limitações, ela não o deixa fazer absolutamente tudo que quiser. Pode parecer ilógico, mas a limitação traz mais liberdade de acerto. Isso porque começar numa tela em branco a cada projeto o força a tomar as mesmas decisões várias e várias vezes.

HTML, CSS, Rails todas são tecnologias cujo objetivo é simplificar nossas vidas tomando as decisões repetitivas por nós, limitando nossas possibilidades e com isso aumentando nossa produtividade sem ser difícil de aprender e, principalmente, sem limitar nossa criatividade – como fazem outras tecnologias. Esse é o balanço perfeito.

## Comunidade e Senso de Estética

Essa idéia do balanço, das convenções nos leva a outro assunto recorrente: ao senso de estética que parece que todos da comunidade Rails parecem compartilhar. Não basta cuspir código, é preciso saber codificar da mesma forma como um enólogo sabe apreciar um bom vinho.

![](/files/383052026_da42ce322c.jpg)

David diz que uma das habilidades que todo bom programador deve ter é saber dar bons nomes. Veja o recurso de pluralização do Rails. Nós temos essa convenção onde o nome dos Models deve ser no singular e a dos Controllers no plural. Mas não somente acrescentando um “s” no final da palavra. Existe todo um sistema para cobrir praticamente todos os casos da língua inglesa. Houve até um caso famoso na época para ter o plural ‘Octopi’ da palavra singular ‘Octopus’.

É algo que parece fútil, sem sentido, até impensável. Ainda hoje muitos questionam se não teria sido muito mais prático deixar tudo no singular mesmo e pronto. Mas a equipe Rails bateu o martelo: gostamos deste estilo de estética. Eles gastaram um bom tempo para deixar claro que estética importa.

Felizmente para a comunidade Ruby, os primeiros desenvolvedores que adotaram Ruby, como David Thomas, Hal Fulton, eram programadores que também se importavam com o código. E a comunidade se organizou em torno desse mesmo estilo, desse mesmo senso de estética. E o episódio da pluralização do Rails, acabou servindo como um _filtro_ para entrar na comunidade: em vez do programador gastar meses aprendendo Rails para só depois se tocar que na verdade não gosta disso, a pluralização está bem na cara, é uma das primeiras coisas que se vê. Então esse principiante pode escolher imediatamente continuar ou pular fora. Se ele tiver o mesmo estilo, o mesmo nível cultural do resto da comunidade Ruby, vai entender o recurso e vai gostar de Rails.

A idéia não é excluir as pessoas porque gostamos, mas porque podemos: você não vai andar nesta casa se não respeitar esses valores, ou pelo menos se não aprender a apreciá-los.

## Alpha Geeks

Finalmente chegamos numa parte mais ‘política’ da discussão. Porque eles começaram dizendo, _“o que você acha que tornou .NET popular?”_, bem, a Microsoft disse _“Esta será a próxima grande coisa.”_ E o que tornou Java popular? Bem, a IBM e a Sun disseram a mesma coisa. E Ruby? Não há nenhuma corporação por trás dela.

Ruby e Rails cresceram por mérito próprio. Nenhuma grande empresa precisou investir em seu marketing. 37signals? Uma empresa de uma dúzia de pessoas. ThoughtWorks? 800 pessoas. Nada tão extraordinário quanto uma Microsoft com dezenas de milhares de pessoas espalhadas pelo globo.

E falando na ThoughtWorks, o que Martin nos revela é interessante. Ele mesmo diz que sua empresa não é nenhuma mega-corporação. Mesmo assim, quando .NET saiu, eles investiram pesado nele, fizeram diversos projetos. O que eles têm acompanhado é que a demanda pro projetos Java estagnou: não sobe nem desce. Porém as de .NET estão caindo mas Ruby já representa 40% dos projetos da empresa. Ele é o primeiro a dizer que ainda não sabe se isso é só algo momentâneo ou se estamos diante de uma tendência sólida. Mas é algo a se considerar.

![](/files/49346772_0ee70562a6.jpg)

Antes de falar na Microsoft, vamos falar dos Alpha Geeks. Claro, Ruby ainda é apenas um pequeno ponto comparado à larga escala de milhões de desenvolvedores Java e .NET o importante não é apenas o número absoluto de pessoas. O problema é que os chamados ‘Alpha Geeks’ são muito menos, e eles estão migrando de Java e .NET para Ruby e outras linguagens dinâmicas. Quem são esses Alpha Geeks? São os formadores e opinião, são os líderes, os cabeças das comunidades, aqueles que influenciarão as próximas grandes coisas.

O fato dos projetos de .NET estarem em declínio, no exemplo de ThoughtWorks, é uma indicação. É a mesma coisa com os movimentos Ágeis. Se um bom desenvolvedor se vê preso a uma empresa que o obriga a usar processos antiquados waterfall, só lhe resta abandonar essa empresa e ir atrás de alguma outra menor que use XP, por exemplo. Muitas pessoas chegam no David para dizer, _“eu larguei meu trabalho por causa de Java. Eu simplesmente não gosto de trabalhar num ambiente onde só usam essas ferramentas. Então preferi pegar me tornar um freelance para trabalhar com Ruby on Rails. Estou muito mais feliz agora.”_

Mas eles deixam claro uma coisa: isso não quer dizer que Java seja ruim. Muito pelo contrário, eles não desgostam de JRuby. Eles consideram que foi um movimento bastante acertado da Sun ter contratado o pessoal do JRuby e ter investido nesse projeto a ponto de surgir um produto tão bom que já consegue rodar aplicações complexas escritas em Rails. Resta saber se a Microsoft vai pelo mesmo caminho com o .NET.

## Hidra

E voltamos ao assunto Microsoft. Eles gastam algum tempo conjecturando. O maior problema para a Microsoft é que ela fez tantas coisas ruins que perdeu a boa reputação. Nenhum deles considera que dentro da empresa Microsoft exista indivíduos que sejam verdadeiramente maus. Mas a política da corporação como um todo não está ajudando. Eles filosofam no sentido de que as pessoas podem ser boas pessoas para se conversar, tomar uma cerveja, mas no final são suas atitudes que contam quando alguém publica uma notícia dizendo que o Linux está infringindo não sei quantas patentes.

E o problema para ela é que uma ação má apaga todas as boas ações anteriores. Perdendo a reputação, mesmo tendo coisas realmente interessantes como LINQ, as novas ferramentas de Workflow e tudo mais, mesmo assim a comunidade vai começar a diminuir, os Alpha Geeks vão migrar para outras tecnologias. Talvez seja o que Paul Graham quis dizer quando afirmou que a [Microsoft estava morta](http://www.paulgraham.com/microsoft.html), no sentido de que ela não é mais perigosa porque perdeu a relevância. Quem sabe?

![](/files/521201549_db11ff1e79.jpg)

O problema da Microsoft em especial, é que ela é muito grande. Quem faz todas essas más ações? Todos concordam que não se pode colocar a culpa de tudo no Bill. Não é ele diretamente quem faz cada uma dessas coisas. O problema é que eles estão sem direção, estão sem líderes. E nesse sentido eles se parecem com uma Hidra. E é por isso que muita gente não confia neles: enquanto uma pessoa lá pode estar sorrindo, outra na mesma empresa o está apunhalando pelas costas.

Como eu disse antes, Scott, o entrevistador, está na folha de pagamento da Microsoft, por isso é uma situação estranha. Ele não pode ser hiperbólico sobre a Microsoft nem pode bater nela. De qualquer forma tentou conciliar: será que não adiantaria para a Microsoft fazer a mesma coisa que pessoas como David e Martin? Sair pelo mundo, em conferências, dizendo as coisas boas que tem. Mas, David, afiado como sempre, deu a última rasteira: _“não basta dizer ao mundo que você é bom, você precisa fazer coisas boas para ser considerado bom.”_

Nós julgamos as pessoas pelos seus atos, não pelo que elas falam. Em um determinado momento, o estilo selvagem e monopolista funcionou muito bem. Eles fizeram bilhões de dólares com essa estratégia. Mas agora não funciona mais. Esse tipo de ‘tradição’ não se muda do dia pra noite: tem pessoas que trabalham lá há mais de 15 anos. Portanto é muito difícil voltar aos trilhos, e eles precisam fazer algo rápido.

